DO $$
DECLARE
    parameters JSONB := '{
        "id": 5,
        "registry_id": 103,
        "user_id": 1,
        "confirm_delete": true,
        "excluded_registry_ids": "30"
    }';

    registry_id            INT     := (parameters ->> 'registry_id')::INT;
    target_id               INT     := (parameters ->> 'id')::INT;
    p_confirm_delete       BOOLEAN := COALESCE((parameters ->> 'confirm_delete')::BOOLEAN, FALSE);
    excluded_text           TEXT    := COALESCE(parameters ->> 'excluded_registry_ids', '');

    excluded_registry_ids_array INT[] := 
        CASE 
            WHEN TRIM(excluded_text) = '' THEN ARRAY[]::INT[]
            ELSE (
                SELECT ARRAY_AGG(DISTINCT v::INT)
                FROM UNNEST(string_to_array(excluded_text, ',')) AS t(v)
                WHERE TRIM(v) ~ '^\d+$'
            )
        END;

    current RECORD;
    rec     RECORD;
    dyn_sql TEXT;
BEGIN
    ------------------------------------------------------------------
    -- 1. Временные таблицы
    ------------------------------------------------------------------
    DROP TABLE IF EXISTS temp_to_process;
    CREATE TEMP TABLE temp_to_process (
        object_id          INT NOT NULL,
        record_id          INT NOT NULL,
        found_by_attr      INT,
        found_by_object_id INT,
        processed          BOOLEAN DEFAULT FALSE,
        PRIMARY KEY (object_id, record_id)
    ) ON COMMIT DROP;

    DROP TABLE IF EXISTS temp_found_records;
    CREATE TEMP TABLE temp_found_records (
        entity_id          TEXT,
        object_id          INT NOT NULL,
        record_id          INT NOT NULL,
        found_by_attr      INT,
        found_by_object_id INT,
        is_deleted         BOOLEAN,
        record_data        JSONB,
        UNIQUE (object_id, record_id)
    ) ON COMMIT DROP;

    ------------------------------------------------------------------
    -- 2. Добавляем стартовую запись
    ------------------------------------------------------------------
    INSERT INTO temp_to_process (object_id, record_id, found_by_attr, found_by_object_id)
    VALUES (registry_id, target_id, NULL, NULL);

    -- Статическая вставка стартовой записи
    EXECUTE format('
        INSERT INTO temp_found_records
        SELECT NULL::TEXT, %s, %s, NULL::INT, NULL::INT, is_deleted, to_jsonb(t)
        FROM registry.object_%s_ t
        WHERE id = %s
        ON CONFLICT (object_id, record_id) DO NOTHING',
        registry_id, target_id, registry_id, target_id
    );

    ------------------------------------------------------------------
    -- 3. BFS-поиск связанных записей
    ------------------------------------------------------------------
    LOOP
        SELECT object_id, record_id, found_by_attr, found_by_object_id
        INTO current
        FROM temp_to_process
        WHERE processed = FALSE
        LIMIT 1;

        EXIT WHEN NOT FOUND;

        UPDATE temp_to_process
           SET processed = TRUE
         WHERE object_id = current.object_id
           AND record_id = current.record_id;

        -- Добавляем текущую запись в результаты (если ещё нет)
        EXECUTE format('
            INSERT INTO temp_found_records
            SELECT %L::TEXT, %s, %s, %L::INT, %L::INT, t.is_deleted, to_jsonb(t)
            FROM registry.object_%s_ t
            WHERE t.id = %s
            ON CONFLICT (object_id, record_id) DO NOTHING',
            current.found_by_attr,
            current.object_id,
            current.record_id,
            current.found_by_attr,
            current.found_by_object_id,
            current.object_id,
            current.record_id
        );

        -- Поиск ссылающихся записей
        FOR rec IN
            SELECT xs.entity_id, xs.object_id AS target_object_id
            FROM registry.xref_settings xs
            WHERE xs.entity_type_id = 'xref_field'
              AND xs.xref_object_id = current.object_id
              AND (excluded_registry_ids_array IS NULL OR xs.object_id <> ALL(excluded_registry_ids_array))
        LOOP
            IF EXISTS (
                SELECT 1 FROM information_schema.columns
                WHERE table_schema = 'registry'
                  AND table_name = format('object_%s_', rec.target_object_id)
                  AND column_name = format('attr_%s_', rec.entity_id)
            ) THEN

                -- 1. В очередь
                dyn_sql := format('
                    INSERT INTO temp_to_process (object_id, record_id, found_by_attr, found_by_object_id)
                    SELECT %s, id, %s, %s
                    FROM registry.object_%s_
                    WHERE attr_%s_ = %s
                      AND (is_deleted IS NULL OR is_deleted = FALSE)
                    ON CONFLICT (object_id, record_id) DO NOTHING',
                    rec.target_object_id,
                    rec.entity_id,
                    current.object_id,
                    rec.target_object_id,
                    rec.entity_id,
                    current.record_id
                );
                EXECUTE dyn_sql;

                -- 2. В результаты
                dyn_sql := format('
                    INSERT INTO temp_found_records
                    SELECT %L::TEXT, %s, id, %s, %s, is_deleted, to_jsonb(t)
                    FROM registry.object_%s_ t
                    WHERE attr_%s_ = %s
                      AND (is_deleted IS NULL OR is_deleted = FALSE)
                    ON CONFLICT (object_id, record_id) DO NOTHING',
                    rec.entity_id,
                    rec.target_object_id,
                    rec.entity_id,
                    current.object_id,
                    rec.target_object_id,
                    rec.entity_id,
                    current.record_id
                );
                EXECUTE dyn_sql;
            END IF;
        END LOOP;
    END LOOP;

    ------------------------------------------------------------------
    -- 4. Вывод результата
    ------------------------------------------------------------------
    IF NOT p_confirm_delete THEN
        RAISE NOTICE '================================================================';
        RAISE NOTICE 'Найдено записей для удаления: %', (SELECT COUNT(*) FROM temp_found_records);
        RAISE NOTICE 'Чтобы выполнить удаление — установите "confirm_delete": true';
        RAISE NOTICE '================================================================';

        FOR rec IN
            SELECT entity_id, object_id, record_id,
                   found_by_attr, found_by_object_id
            FROM temp_found_records
            ORDER BY COALESCE(found_by_object_id, 0), object_id, record_id
        LOOP
            RAISE INFO '→ object_%_ | id=% | entity_id=% | через attr_%_ | из object_%_',
                rec.object_id,
                rec.record_id,
                COALESCE(rec.entity_id, '<исходная>'),
                COALESCE(rec.found_by_attr::TEXT, '-'),
                COALESCE(rec.found_by_object_id::TEXT, '-');
        END LOOP;

        RETURN;
    END IF;

    ------------------------------------------------------------------
    -- 5. Реальное мягкое удаление
    ------------------------------------------------------------------
    RAISE NOTICE 'Начато удаление...';

    FOR rec IN
        SELECT object_id, record_id
        FROM temp_found_records
        WHERE is_deleted IS NOT TRUE
        ORDER BY COALESCE(found_by_object_id, 0) DESC, object_id, record_id
    LOOP
        dyn_sql := format('UPDATE registry.object_%s_ SET is_deleted = TRUE WHERE id = %s',
                          rec.object_id, rec.record_id);
        BEGIN
            EXECUTE dyn_sql;
            RAISE INFO 'Удалено: object_%_ id=%', rec.object_id, rec.record_id;
        EXCEPTION WHEN OTHERS THEN
            RAISE WARNING 'Ошибка при удалении object_%s_ id=%s: %',
                rec.object_id, rec.record_id, SQLERRM;
        END;
    END LOOP;

    RAISE NOTICE 'Удаление завершено. Всего обработано записей: %', (SELECT COUNT(*) FROM temp_found_records);
END;
$$;