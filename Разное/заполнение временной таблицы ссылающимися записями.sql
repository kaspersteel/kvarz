DO $$
DECLARE
    parameters JSONB := '{"id": 3, "registry_id": 103, "user_id": 1}';
    registry_id INT := (parameters ->> 'registry_id')::INT;
    target_id INT := (parameters ->> 'id')::INT;
    excluded_registry_ids INT[] := ARRAY[30];  -- список исключаемых реестров (object_id)
    rec RECORD;
    current RECORD;
    dyn_sql TEXT;
BEGIN
    -- Очистка временной таблицы, если существует
    DROP TABLE IF EXISTS temp_results;
    CREATE TEMP TABLE temp_results (
        entity_id TEXT,
        object_id INT,
        record_id INT,
        is_deleted BOOLEAN,
        found_by_attr INT,
        found_by_object_id INT,
        record_data JSONB,
        UNIQUE (object_id, record_id)
    );

    -- Создаём временную таблицу для очереди и контроля обработанных записей
    DROP TABLE IF EXISTS temp_to_process;
    CREATE TEMP TABLE temp_to_process (
        object_id INT,
        record_id INT,
        processed BOOLEAN DEFAULT FALSE,
        PRIMARY KEY (object_id, record_id)
    ) ON COMMIT DROP;

    -- Вставляем исходную запись в очередь на обработку и сразу в результаты
    INSERT INTO temp_to_process(object_id, record_id, processed) VALUES (registry_id, target_id, FALSE);

    dyn_sql := format($fmt$
        INSERT INTO temp_results (entity_id, object_id, record_id, is_deleted, found_by_attr, found_by_object_id, record_data)
        SELECT NULL, %s, %s, is_deleted, NULL, NULL, to_jsonb(t)
        FROM registry.object_%s_ t
        WHERE id = %s
    $fmt$, registry_id, target_id, registry_id, target_id);
    EXECUTE dyn_sql;

    LOOP
        -- Получаем следующую необработанную запись из очереди
        SELECT object_id, record_id INTO current
        FROM temp_to_process
        WHERE processed = FALSE
        LIMIT 1;

        IF NOT FOUND THEN
            EXIT;
        END IF;

        -- Помечаем текущую запись как обработанную
        UPDATE temp_to_process SET processed = TRUE WHERE object_id = current.object_id AND record_id = current.record_id;

        -- Для каждой таблицы, ссылающейся на текущую object_id, ищем записи, ссылающиеся на current.record_id
        FOR rec IN
            SELECT entity_id, object_id
            FROM registry.xref_settings
            WHERE entity_type_id = 'xref_field'
              AND xref_object_id = current.object_id
              AND object_id <> ALL (excluded_registry_ids)
        LOOP
            -- Проверяем наличие столбца attr_<entity_id>_ в таблице
            PERFORM 1
            FROM information_schema.columns
            WHERE table_schema = 'registry'
              AND table_name = format('object_%s_', rec.object_id)
              AND column_name = format('attr_%s_', rec.entity_id);

            IF FOUND THEN
                dyn_sql := format($fmt$
                    INSERT INTO temp_to_process (object_id, record_id, processed)
                    SELECT %s, id, FALSE
                    FROM registry.object_%s_
                    WHERE attr_%s_ = %s
                    ON CONFLICT DO NOTHING
                $fmt$,
                    rec.object_id,
                    rec.object_id,
                    rec.entity_id,
                    current.record_id
                );
                EXECUTE dyn_sql;

                -- Вставляем найденные записи с указанием числового found_by_attr и объекта, по которому найдена
                dyn_sql := format($fmt$
                    INSERT INTO temp_results (entity_id, object_id, record_id, is_deleted, found_by_attr, found_by_object_id, record_data)
                    SELECT %L, %s, id, is_deleted, %s, %s, to_jsonb(t)
                    FROM registry.object_%s_ t
                    WHERE attr_%s_ = %s
                    ON CONFLICT (object_id, record_id) DO NOTHING
                $fmt$,
                    rec.entity_id::TEXT,
                    rec.object_id,
                    rec.entity_id,
                    current.object_id,
                    rec.object_id,
                    rec.entity_id,
                    current.record_id
                );
                EXECUTE dyn_sql;
            ELSE
                RAISE NOTICE 'Пропущено: в таблице registry.object_%s_ нет столбца attr_%s_', rec.object_id, rec.entity_id;
            END IF;
        END LOOP;
    END LOOP;
END
$$;

-- Вывод результатов в той же сессии:
SELECT * FROM temp_results
ORDER BY
    found_by_object_id NULLS FIRST,
    object_id,
    record_id;