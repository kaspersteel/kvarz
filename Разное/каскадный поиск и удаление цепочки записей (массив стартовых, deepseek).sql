DO $$
DECLARE
    parameters JSONB := '{
        "target_ids": "15, 16, 17, 18, 19, 20", 
        "registry_id": 103,
        "user_id": 1,
        "confirm_delete": false,
        "excluded_registry_ids": "30"
    }';

    registry_id            INT     := (parameters ->> 'registry_id')::INT;
    target_ids_text        TEXT    := COALESCE(parameters ->> 'target_ids', '');
    p_confirm_delete       BOOLEAN := COALESCE((parameters ->> 'confirm_delete')::BOOLEAN, FALSE);
    excluded_text          TEXT    := COALESCE(parameters ->> 'excluded_registry_ids', '');

    target_ids_array       INT[];
    excluded_registry_ids_array INT[];
    
    current RECORD;
    rec     RECORD;
    dyn_sql TEXT;
    target_id INT;
BEGIN
    ------------------------------------------------------------------
    -- ПАРСИНГ ВХОДНЫХ ДАННЫХ
    ------------------------------------------------------------------
    IF target_ids_text <> '' THEN
        target_ids_array := string_to_array(REPLACE(TRIM(target_ids_text), ' ', ''), ',')::INT[];
    ELSE
        target_ids_array := ARRAY[]::INT[];
    END IF;
    
    IF excluded_text <> '' THEN
        excluded_registry_ids_array := string_to_array(REPLACE(TRIM(excluded_text), ' ', ''), ',')::INT[];
    ELSE
        excluded_registry_ids_array := ARRAY[]::INT[];
    END IF;

    RAISE NOTICE 'target_ids: %', target_ids_array;
    RAISE NOTICE 'excluded_registry_ids: %', excluded_registry_ids_array;

    IF array_length(target_ids_array, 1) IS NULL OR array_length(target_ids_array, 1) = 0 THEN
        RAISE EXCEPTION 'Не указаны target_ids для удаления. Получено: "%"', target_ids_text;
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
        found_by_record_id INT,
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
        found_by_record_id INT,
        is_deleted         BOOLEAN,
        record_data        JSONB,
        UNIQUE (object_id, record_id)
    ) ON COMMIT DROP;

    ------------------------------------------------------------------
    -- 2. Добавляем стартовые записи
    ------------------------------------------------------------------
    FOREACH target_id IN ARRAY target_ids_array
    LOOP
        INSERT INTO temp_to_process (object_id, record_id, found_by_attr, found_by_object_id, found_by_record_id)
        VALUES (registry_id, target_id, NULL, NULL, NULL)
        ON CONFLICT (object_id, record_id) DO NOTHING;
        
        EXECUTE format('
            INSERT INTO temp_found_records
            SELECT NULL::TEXT, %s, %s, NULL::INT, NULL::INT, NULL::INT, is_deleted, to_jsonb(t)
            FROM registry.object_%s_ t
            WHERE id = %s
            ON CONFLICT (object_id, record_id) DO NOTHING',
            registry_id, target_id, registry_id, target_id
        );
    END LOOP;

    ------------------------------------------------------------------
    -- 3. BFS-поиск связанных записей
    ------------------------------------------------------------------
    LOOP
        SELECT object_id, record_id, found_by_attr, found_by_object_id, found_by_record_id
        INTO current
        FROM temp_to_process
        WHERE processed = FALSE
        LIMIT 1;

        EXIT WHEN NOT FOUND;

        UPDATE temp_to_process
           SET processed = TRUE
         WHERE object_id = current.object_id
           AND record_id = current.record_id;

        FOR rec IN
            SELECT xs.entity_id, xs.object_id AS target_object_id
            FROM registry.xref_settings xs
            WHERE xs.entity_type_id = 'xref_field'
              AND xs.xref_object_id = current.object_id
              AND (excluded_registry_ids_array IS NULL OR array_length(excluded_registry_ids_array, 1) = 0 
                   OR NOT (xs.object_id = ANY(excluded_registry_ids_array)))
        LOOP
            IF EXISTS (
                SELECT 1 FROM information_schema.columns
                WHERE table_schema = 'registry'
                  AND table_name = format('object_%s_', rec.target_object_id)
                  AND column_name = format('attr_%s_', rec.entity_id)
            ) THEN

                dyn_sql := format('
                    INSERT INTO temp_to_process (object_id, record_id, found_by_attr, found_by_object_id, found_by_record_id)
                    SELECT %s, id, %s, %s, %s
                    FROM registry.object_%s_
                    WHERE attr_%s_ = %s
                      AND (is_deleted IS NULL OR is_deleted = FALSE)
                    ON CONFLICT (object_id, record_id) DO NOTHING',
                    rec.target_object_id,
                    rec.entity_id,
                    current.object_id,
                    current.record_id,
                    rec.target_object_id,
                    rec.entity_id,
                    current.record_id
                );
                EXECUTE dyn_sql;

                dyn_sql := format('
                    INSERT INTO temp_found_records
                    SELECT %L::TEXT, %s, id, %s, %s, %s, is_deleted, to_jsonb(t)
                    FROM registry.object_%s_ t
                    WHERE attr_%s_ = %s
                      AND (is_deleted IS NULL OR is_deleted = FALSE)
                    ON CONFLICT (object_id, record_id) DO NOTHING',
                    rec.entity_id,
                    rec.target_object_id,
                    rec.entity_id,
                    current.object_id,
                    current.record_id,
                    rec.target_object_id,
                    rec.entity_id,
                    current.record_id
                );
                EXECUTE dyn_sql;
            END IF;
        END LOOP;
    END LOOP;

    ------------------------------------------------------------------
    -- 4. Построение дерева для вывода
    ------------------------------------------------------------------
    DROP TABLE IF EXISTS temp_tree;
    CREATE TEMP TABLE temp_tree (
        id SERIAL PRIMARY KEY,
        object_id INT,
        record_id INT,
        entity_id TEXT,
        found_by_object_id INT,
        found_by_record_id INT,
        level INT,
        sort_path TEXT,
        is_last BOOLEAN DEFAULT FALSE
    ) ON COMMIT DROP;

    WITH RECURSIVE tree_cte AS (
        SELECT 
            object_id,
            record_id,
            entity_id,
            found_by_object_id,
            found_by_record_id,
            0 as level,
            LPAD(object_id::text, 10, '0') || LPAD(record_id::text, 10, '0') as sort_path
        FROM temp_found_records
        WHERE found_by_object_id IS NULL AND found_by_record_id IS NULL
        
        UNION ALL
        
        SELECT 
            child.object_id,
            child.record_id,
            child.entity_id,
            child.found_by_object_id,
            child.found_by_record_id,
            parent.level + 1 as level,
            parent.sort_path || '->' || LPAD(child.object_id::text, 10, '0') || LPAD(child.record_id::text, 10, '0') as sort_path
        FROM temp_found_records child
        INNER JOIN tree_cte parent 
            ON child.found_by_object_id = parent.object_id 
            AND child.found_by_record_id = parent.record_id
    )
    INSERT INTO temp_tree (object_id, record_id, entity_id, found_by_object_id, found_by_record_id, level, sort_path)
    SELECT object_id, record_id, entity_id, found_by_object_id, found_by_record_id, level, sort_path
    FROM tree_cte
    ORDER BY sort_path;

    -- Определяем последнюю запись в каждой группе siblings
    UPDATE temp_tree t
    SET is_last = NOT EXISTS (
        SELECT 1 FROM temp_tree t2
        WHERE t2.found_by_object_id = t.found_by_object_id
          AND t2.found_by_record_id = t.found_by_record_id
          AND t2.level = t.level
          AND t2.sort_path > t.sort_path
    )
    WHERE t.found_by_object_id IS NOT NULL;

    -- Для корневых записей определяем, является ли последней
    UPDATE temp_tree t
    SET is_last = NOT EXISTS (
        SELECT 1 FROM temp_tree t2
        WHERE t2.found_by_object_id IS NULL
          AND t2.found_by_record_id IS NULL
          AND t2.level = 0
          AND t2.sort_path > t.sort_path
    )
    WHERE t.found_by_object_id IS NULL;

    ------------------------------------------------------------------
    -- 5. Вывод результата (ДЕРЕВО С СИМВОЛАМИ)
    ------------------------------------------------------------------
    IF NOT p_confirm_delete THEN
        RAISE NOTICE '================================================================';
        RAISE NOTICE 'Исходные target_ids: %', target_ids_array;
        RAISE NOTICE 'Исключённые реестры: %', excluded_registry_ids_array;
        RAISE NOTICE 'Найдено записей для удаления: %', (SELECT COUNT(*) FROM temp_found_records);
        RAISE NOTICE 'Записей в дереве: %', (SELECT COUNT(*) FROM temp_tree);
        RAISE NOTICE 'Чтобы выполнить удаление — установите "confirm_delete": true';
        RAISE NOTICE '================================================================';
        RAISE NOTICE '';

        RAISE NOTICE 'Дерево зависимостей для удаления:';
        RAISE NOTICE '';

        IF (SELECT COUNT(*) FROM temp_tree) = 0 THEN
            RAISE NOTICE 'Дерево пустое!';
        ELSE
            DECLARE
                tree_rec RECORD;
                parent_paths TEXT[] := ARRAY[]::TEXT[];
                parent_is_last BOOLEAN[] := ARRAY[]::BOOLEAN[];
                i INT;
            BEGIN
                FOR tree_rec IN
                    SELECT 
                        t.*,
                        CASE 
                            WHEN t.found_by_object_id IS NOT NULL THEN 
                                format('object_%s_ id=%s', t.found_by_object_id, t.found_by_record_id)
                            ELSE NULL
                        END as parent_info_formatted
                    FROM temp_tree t
                    ORDER BY t.sort_path
                LOOP
                    -- Формируем префикс с символами дерева
                    DECLARE
                        tree_prefix TEXT := '';
                        line_prefix TEXT;
                        entity_info TEXT := '';
                    BEGIN
                        -- Для каждого уровня выше текущего формируем символы
                        FOR i IN 1..tree_rec.level LOOP
                            IF i < tree_rec.level THEN
                                -- Проверяем, является ли родитель на этом уровне последним
                                IF COALESCE(parent_is_last[i], FALSE) THEN
                                    tree_prefix := tree_prefix || '    ';
                                ELSE
                                    tree_prefix := tree_prefix || '│   ';
                                END IF;
                            ELSE
                                -- Для текущего уровня определяем символ
                                IF tree_rec.is_last THEN
                                    tree_prefix := tree_prefix || '└── ';
                                ELSE
                                    tree_prefix := tree_prefix || '├── ';
                                END IF;
                            END IF;
                        END LOOP;
                        
                        -- Обновляем информацию о родителях
                        IF array_length(parent_paths, 1) < tree_rec.level + 1 THEN
                            parent_paths := array_append(parent_paths, tree_rec.sort_path);
                            parent_is_last := array_append(parent_is_last, tree_rec.is_last);
                        ELSE
                            parent_paths[tree_rec.level + 1] := tree_rec.sort_path;
                            parent_is_last[tree_rec.level + 1] := tree_rec.is_last;
                        END IF;
                        
                        -- Убираем лишние уровни
                        IF array_length(parent_paths, 1) > tree_rec.level + 1 THEN
                            parent_paths := parent_paths[1:tree_rec.level + 1];
                            parent_is_last := parent_is_last[1:tree_rec.level + 1];
                        END IF;
                        
                        -- Информация о сущности
                        IF tree_rec.entity_id IS NOT NULL THEN
                            entity_info := format(' (attr_%s_)', tree_rec.entity_id);
                        END IF;
                        
                        -- Выводим запись
                        IF tree_rec.level = 0 THEN
                            -- Корневые записи
                            RAISE INFO '%object_%_ id=% %', 
                                tree_prefix, 
                                tree_rec.object_id, 
                                tree_rec.record_id,
                                entity_info;
                        ELSE
                            -- Дочерние записи с информацией о родителе в той же строке
                            RAISE INFO '%object_%_ id=% % ➔ %', 
                                tree_prefix,
                                tree_rec.object_id, 
                                tree_rec.record_id,
                                entity_info,
                                tree_rec.parent_info_formatted;
                        END IF;
                    END;
                END LOOP;
            END;
        END IF;

        RAISE NOTICE '';
        RAISE NOTICE '================================================================';

        RETURN;
    END IF;

    ------------------------------------------------------------------
    -- 6. Реальное мягкое удаление
    ------------------------------------------------------------------
    RAISE NOTICE 'Начато удаление...';
    
    DECLARE
        deleted_count INT := 0;
    BEGIN
        FOR rec IN
            SELECT object_id, record_id
            FROM temp_found_records
            WHERE is_deleted IS NOT TRUE
              AND NOT (object_id = ANY(excluded_registry_ids_array))
            ORDER BY COALESCE(found_by_object_id, 0) DESC, object_id, record_id
        LOOP
            dyn_sql := format('UPDATE registry.object_%s_ SET is_deleted = TRUE WHERE id = %s',
                              rec.object_id, rec.record_id);
            BEGIN
                EXECUTE dyn_sql;
                IF FOUND THEN
                    deleted_count := deleted_count + 1;
                END IF;
                RAISE INFO 'Удалено: object_%_ id=%', rec.object_id, rec.record_id;
            EXCEPTION WHEN OTHERS THEN
                RAISE WARNING 'Ошибка при удалении object_%s_ id=%s: %',
                    rec.object_id, rec.record_id, SQLERRM;
            END;
        END LOOP;
        
        RAISE NOTICE 'Удаление завершено. Удалено записей: %, Всего найдено: %', 
            deleted_count, (SELECT COUNT(*) FROM temp_found_records);
    END;
END;
$$;