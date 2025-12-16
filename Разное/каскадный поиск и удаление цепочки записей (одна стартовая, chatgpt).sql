DO $$
DECLARE
    parameters JSONB := '{
        "id": 11,
        "registry_id": 103,
        "user_id": 1,
        "confirm_delete": false,
        "excluded_registry_ids": "30"
    }';

    registry_id  INT := (parameters ->> 'registry_id')::INT;
    target_id    INT := (parameters ->> 'id')::INT;
    p_confirm_delete BOOLEAN := COALESCE((parameters ->> 'confirm_delete')::BOOLEAN, FALSE);
    excluded_text TEXT := COALESCE(parameters ->> 'excluded_registry_ids', '');

    excluded_registry_ids_array INT[];

    current RECORD;
    rec RECORD;
    dyn_sql TEXT;
BEGIN
    ------------------------------------------------------------------
    -- 0. Формируем массив исключенных реестров
    ------------------------------------------------------------------
SELECT ARRAY(
    SELECT DISTINCT CAST(regexp_replace(x, '\D', '', 'g') AS INT)
    FROM unnest(string_to_array(excluded_text, ',')) AS t(x)
    WHERE regexp_replace(x, '\D', '', 'g') <> ''
) INTO excluded_registry_ids_array;

IF excluded_registry_ids_array IS NULL THEN
    excluded_registry_ids_array := ARRAY[]::INT[];
END IF;


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
    INSERT INTO temp_to_process (object_id, record_id)
    VALUES (registry_id, target_id);

    EXECUTE format(
        'INSERT INTO temp_found_records
         SELECT NULL::TEXT, %1$s, %2$s, NULL, NULL, is_deleted, to_jsonb(t)
         FROM registry.object_%1$s_ t
         WHERE id = %2$s
         ON CONFLICT DO NOTHING',
         registry_id, target_id
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

        -- Сохраняем результат
        EXECUTE format(
            'INSERT INTO temp_found_records
             SELECT %L::TEXT, %s, %s, %L, %L, is_deleted, to_jsonb(t)
             FROM registry.object_%s_ t
             WHERE id = %s
             ON CONFLICT DO NOTHING',
            current.found_by_attr,
            current.object_id,
            current.record_id,
            current.found_by_attr,
            current.found_by_object_id,
            current.object_id,
            current.record_id
        );

        -- Поиск связанных записей
        FOR rec IN
            SELECT xs.entity_id,
                   xs.object_id AS target_object_id
            FROM registry.xref_settings xs
            WHERE xs.entity_type_id = 'xref_field'
              AND xs.xref_object_id = current.object_id
              AND NOT (xs.object_id = ANY (excluded_registry_ids_array))
        LOOP
            -- Проверка наличия колонки attr_XXX_
            IF EXISTS (
                SELECT 1
                FROM information_schema.columns
                WHERE table_schema='registry'
                  AND table_name = format('object_%s_', rec.target_object_id)
                  AND column_name = format('attr_%s_', rec.entity_id)
            ) THEN

                -- Добавление в очередь
                dyn_sql := format(
                    'INSERT INTO temp_to_process (object_id, record_id, found_by_attr, found_by_object_id)
                     SELECT %1$s, t.id, %2$s, %3$s
                     FROM registry.object_%1$s_ t
                     WHERE attr_%2$s_ = %4$s
                       AND (is_deleted IS NULL OR is_deleted = FALSE)
                     ON CONFLICT DO NOTHING',
                     rec.target_object_id,
                     rec.entity_id,
                     current.object_id,
                     current.record_id
                );
                EXECUTE dyn_sql;

                -- Добавление в найденные
                dyn_sql := format(
                    'INSERT INTO temp_found_records
                     SELECT %1$L, %2$s, t.id, %1$s, %3$s, is_deleted, to_jsonb(t)
                     FROM registry.object_%2$s_ t
                     WHERE attr_%1$s_ = %4$s
                       AND (is_deleted IS NULL OR is_deleted = FALSE)
                     ON CONFLICT DO NOTHING',
                     rec.entity_id,
                     rec.target_object_id,
                     current.object_id,
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
        RAISE NOTICE 'Исключены реестры: %', excluded_registry_ids_array;        
        RAISE NOTICE 'Найдено записей для удаления: %', (SELECT COUNT(*) FROM temp_found_records);
        RAISE NOTICE 'Чтобы выполнить удаление — установите "confirm_delete": true';
        RAISE NOTICE '================================================================';

        FOR rec IN
            SELECT entity_id, object_id, record_id,
                   found_by_attr, found_by_object_id
            FROM temp_found_records
            ORDER BY COALESCE(found_by_object_id,0), object_id, record_id
        LOOP
            RAISE INFO '→ object_% | id=% | entity_id=% | через attr_% | из object_%',
                rec.object_id,
                rec.record_id,
                COALESCE(rec.entity_id,'<src>'),
                COALESCE(rec.found_by_attr::TEXT,'-'),
                COALESCE(rec.found_by_object_id::TEXT,'-');
        END LOOP;
        RETURN;
    END IF;

    ------------------------------------------------------------------
    -- 5. Мягкое удаление
    ------------------------------------------------------------------
    RAISE NOTICE 'Начато удаление...';

    FOR rec IN
        SELECT object_id, record_id
          FROM temp_found_records
         WHERE is_deleted IS NOT TRUE
         ORDER BY COALESCE(found_by_object_id,0) DESC,
                  object_id, record_id
    LOOP
        dyn_sql := format(
            'UPDATE registry.object_%s_
             SET is_deleted = TRUE
             WHERE id = %s',
            rec.object_id, rec.record_id
        );

        BEGIN
            EXECUTE dyn_sql;
            RAISE INFO 'Удалено: object_% id=%', rec.object_id, rec.record_id;
        EXCEPTION WHEN OTHERS THEN
            RAISE WARNING 'Ошибка при удалении object_% id=%: %',
                rec.object_id, rec.record_id, SQLERRM;
        END;
    END LOOP;

    RAISE NOTICE 'Удаление завершено. Всего записей: %', (SELECT COUNT(*) FROM temp_found_records);
END $$;
