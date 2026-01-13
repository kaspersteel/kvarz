DO $$
DECLARE
    schema_name CONSTANT text := 'registry';     -- Имя схемы
    tbl_name CONSTANT text := 'object_316_';      -- Имя таблицы
    col_record RECORD;
    set_clauses text := '';
    where_clauses text := '';
    first boolean := true;
BEGIN
    -- Формируем части SET и WHERE для всех boolean-столбцов таблицы
    FOR col_record IN
        SELECT column_name
        FROM information_schema.columns
        WHERE table_schema = schema_name
          AND table_name = tbl_name
          AND data_type = 'boolean'
          AND column_name != 'is_deleted'
    LOOP
        -- Добавляем в SET: col = COALESCE(col, FALSE)
        IF first THEN
            set_clauses := format('%I = COALESCE(%I, FALSE)', col_record.column_name, col_record.column_name);
            where_clauses := format('%I IS NULL', col_record.column_name);
            first := false;
        ELSE
            set_clauses := set_clauses || format(', %I = COALESCE(%I, FALSE)', col_record.column_name, col_record.column_name);
            where_clauses := where_clauses || format(' OR %I IS NULL', col_record.column_name);
        END IF;

        -- Устанавливаем DEFAULT FALSE для каждого boolean-поля
        EXECUTE format('ALTER TABLE %I.%I ALTER COLUMN %I SET DEFAULT FALSE',
                       schema_name, tbl_name, col_record.column_name);

        RAISE NOTICE 'Set DEFAULT FALSE for column %.% in table %', schema_name, col_record.column_name, tbl_name;
    END LOOP;

    -- Если есть boolean-поля, обновляем данные
    IF set_clauses <> '' THEN
        EXECUTE format('UPDATE %I.%I SET %s WHERE %s',
                       schema_name, tbl_name, set_clauses, where_clauses);

        RAISE NOTICE 'Updated NULL to FALSE in table %.%', schema_name, tbl_name;
    ELSE
        RAISE NOTICE 'No boolean columns found in table %.%', schema_name, tbl_name;
    END IF;
END $$;