CREATE OR REPLACE FUNCTION "public"."sched_get_procedures_config"("parameters" jsonb=''::jsonb)
  RETURNS TABLE("object_id" int4, "proc_id" int4, "proc_name" text, "proc_interval" _int4, "proc_id_plan" int4, "proc_comment" text, "proc_check_intersect" bool) AS $BODY$
DECLARE
    v_sql TEXT;
BEGIN
      SELECT string_agg(
        FORMAT(
            $fmt$
            SELECT 
                o.id AS object_id, 
                %L::INTEGER AS proc_id, 
                %L::TEXT AS proc_name, 
                %s AS proc_interval,
                %s AS proc_id_plan,
                %s AS proc_comment,
                %L::BOOLEAN AS proc_check_intersect
            FROM registry.object_4000_ o 
            WHERE NOT o.is_deleted
            $fmt$,
            cfg.id,
            cfg.attr_5022_,
            -- Логика для interval (массив int)
            CASE 
                WHEN cfg.attr_5024_ IS NULL THEN 'NULL::INTEGER[]' 
                ELSE FORMAT('o.%I::INTEGER[]', cfg.attr_5024_) 
            END,
            -- Логика для plan (int)
            CASE 
                WHEN cfg.attr_5023_ IS NULL THEN 'NULL::INTEGER' 
                ELSE FORMAT('o.%I::INTEGER', cfg.attr_5023_) 
            END,
            -- Логика для comment (text)
            CASE 
                WHEN cfg.attr_5025_ IS NULL THEN 'NULL::TEXT' 
                ELSE FORMAT('o.%I::TEXT', cfg.attr_5025_) 
            END,
            -- Логика для флага (bool)
            (cfg.attr_5050_ = 't')
        ),
        ' UNION ALL ' 
        ORDER BY cfg.row_order
    )
    INTO v_sql
    FROM registry.object_5021_ cfg
    WHERE NOT cfg.is_deleted;

    IF v_sql IS NULL THEN
        RETURN;
    END IF;

    RETURN QUERY EXECUTE v_sql;
END
		$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000