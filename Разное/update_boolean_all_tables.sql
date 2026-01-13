DO $$
DECLARE
    schema_name CONSTANT text := 'registry';
    rec RECORD;
    col_record RECORD;
    set_clauses text;
    where_clauses text;
    first boolean;
BEGIN
    CREATE TEMP TABLE temp_update_list (
        table_name text,
        bool_col_count int,
        null_rows_count bigint
    ) ON COMMIT DROP;

    FOR rec IN
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = schema_name
          AND table_type = 'BASE TABLE'
        ORDER BY table_name
    LOOP
        DECLARE
            cols_cond text;
            bool_col_count int;
            null_rows_count bigint;
            sql text;
        BEGIN
            SELECT string_agg(format('%I IS NULL', column_name), ' OR ')
            INTO cols_cond
            FROM information_schema.columns
            WHERE table_schema = schema_name
              AND table_name = rec.table_name
              AND data_type = 'boolean'
              AND column_name != 'is_deleted';

            SELECT COUNT(*)
            INTO bool_col_count
            FROM information_schema.columns
            WHERE table_schema = schema_name
              AND table_name = rec.table_name
              AND data_type = 'boolean'
              AND column_name != 'is_deleted';

            IF cols_cond IS NOT NULL THEN
                sql := format('SELECT COUNT(*) FROM %I.%I WHERE %s', schema_name, rec.table_name, cols_cond);
                EXECUTE sql INTO null_rows_count;

                IF null_rows_count > 0 THEN
                    INSERT INTO temp_update_list(table_name, bool_col_count, null_rows_count)
                    VALUES (rec.table_name, bool_col_count, null_rows_count);
                END IF;
            END IF;
        END;
    END LOOP;

    RAISE NOTICE 'Таблицы, требующие обновления (таблица | число булевых колонок | строк с NULL):';
    FOR rec IN
        SELECT * FROM temp_update_list ORDER BY null_rows_count
    LOOP
        RAISE NOTICE '% | % | %', rec.table_name, rec.bool_col_count, rec.null_rows_count;
    END LOOP;

    FOR rec IN
        SELECT * FROM temp_update_list ORDER BY null_rows_count
    LOOP
        RAISE NOTICE 'Подготовка к обновлению таблицы %.%. Через 5 секунд будет выполнено обновление. Для отмены прервите выполнение.', schema_name, rec.table_name;
        PERFORM pg_sleep(5);

        set_clauses := '';
        where_clauses := '';
        first := true;

        FOR col_record IN
            SELECT column_name
            FROM information_schema.columns
            WHERE table_schema = schema_name
              AND table_name = rec.table_name
              AND data_type = 'boolean'
              AND column_name != 'is_deleted'
            ORDER BY column_name
        LOOP
            IF first THEN
                set_clauses := format('%I = COALESCE(%I, FALSE)', col_record.column_name, col_record.column_name);
                where_clauses := format('%I IS NULL', col_record.column_name);
                first := false;
            ELSE
                set_clauses := set_clauses || format(', %I = COALESCE(%I, FALSE)', col_record.column_name, col_record.column_name);
                where_clauses := where_clauses || format(' OR %I IS NULL', col_record.column_name);
            END IF;

            EXECUTE format('ALTER TABLE %I.%I ALTER COLUMN %I SET DEFAULT FALSE',
                schema_name, rec.table_name, col_record.column_name);

            RAISE NOTICE 'Установлен DEFAULT FALSE на колонку %.%: %', schema_name, rec.table_name, col_record.column_name;

            PERFORM pg_sleep(0.1);
        END LOOP;

        EXECUTE format('UPDATE %I.%I SET %s WHERE %s',
            schema_name, rec.table_name, set_clauses, where_clauses);

        RAISE NOTICE 'Обновлены NULL на FALSE в таблице %.%', schema_name, rec.table_name;

        PERFORM pg_sleep(0.2);
    END LOOP;
END $$;
