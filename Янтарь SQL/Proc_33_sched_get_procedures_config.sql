CREATE OR REPLACE FUNCTION "public"."sched_get_procedures_config"("parameters" jsonb=''::jsonb)
  RETURNS TABLE("object_id" int4, "proc_id" int4, "proc_name" text, "proc_interval" _int4, "proc_id_plan" int4, "proc_comment" text, "proc_check_intersect" bool) AS $BODY$
		DECLARE
    v_sql TEXT;
    v_union TEXT := '';
    rec RECORD;
    v_first BOOLEAN := TRUE;
    
    -- Переменные для хранения готовых фрагментов SQL
    v_sql_interval TEXT;
    v_sql_plan TEXT;
    v_sql_comment TEXT;
    v_sql_check TEXT;
BEGIN
    FOR rec IN 
        SELECT 
            id AS cfg_id,
            attr_5022_ AS name,
            attr_5023_ AS attr_plan,
            attr_5024_ AS attr_interval,
            attr_5025_ AS attr_comment,
            attr_5050_ AS flag_check
        FROM registry.object_5021_
        WHERE NOT is_deleted
        ORDER BY row_order
    LOOP
        -- 1. Интервал
        IF rec.attr_interval IS NULL THEN
            v_sql_interval := 'NULL::INTEGER[]';
        ELSE
            v_sql_interval := FORMAT('o.%I::INTEGER[]', rec.attr_interval);
        END IF;

        -- 2. План
        IF rec.attr_plan IS NULL THEN
            v_sql_plan := 'NULL::INTEGER';
        ELSE
            v_sql_plan := FORMAT('o.%I::INTEGER', rec.attr_plan);
        END IF;

        -- 3. Комментарий
        IF rec.attr_comment IS NULL THEN
            v_sql_comment := 'NULL::TEXT';
        ELSE
            v_sql_comment := FORMAT('o.%I::TEXT', rec.attr_comment);
        END IF;

        -- 4. Флаг пересечения
        v_sql_check := FORMAT('%L::BOOLEAN', rec.flag_check = 't');

        IF NOT v_first THEN
            v_union := v_union || ' UNION ALL ';
        END IF;
        v_first := FALSE;
        v_union := v_union || FORMAT(
            $fmt$
            SELECT 
                o.id AS object_id, 
                %L::INTEGER AS proc_id, 
                %L::TEXT AS proc_name, 
                %s AS proc_interval,
                %s AS proc_id_plan,
                %s AS proc_comment,
                %s AS proc_check_intersect
            FROM registry.object_4000_ o 
            WHERE NOT o.is_deleted
            $fmt$,
            rec.cfg_id,
            rec.name,
            v_sql_interval,
            v_sql_plan,
            v_sql_comment,
            v_sql_check
        );
    END LOOP;

    IF v_union = '' THEN
        RETURN;
    END IF;

    RETURN QUERY EXECUTE v_union;
END
		$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000