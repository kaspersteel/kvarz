/*Пересечение процедур, выявление неназначенного времени (attr_4859_)*/
/*базовая*/
SELECT -->>
*
FROM registry.object_4000_ o
LEFT JOIN LATERAL (
    WITH 
    proc AS (
            SELECT 
                f.object_id AS "record", 
                f.proc_id AS "id",
                f.proc_name AS "name",
                f.proc_interval AS "interval",
                f.proc_id_plan AS "id_plan",
                f.proc_comment AS "comment",
                f.proc_check_intersect AS "check_intersect"
            FROM public.sched_get_procedures_config() f 
            WHERE f.object_id = o.id
    ),
    intersection AS (
        SELECT 
            proc."record" AS "id",
            STRING_AGG(DISTINCT proc."name" || ' || ' || proc2."name", '\n') AS "result"
        FROM proc
        JOIN proc proc2 ON proc."record" = proc2."record"
            AND proc.id < proc2.id
            AND proc."interval" && proc2."interval"
            AND NOT ( proc."interval" && ARRAY[1] OR proc2."interval" && ARRAY[1] )
            AND proc.check_intersect
            AND proc2.check_intersect
        WHERE proc2."name" IS NOT NULL
        GROUP BY proc."record"
    ),
    notime AS (
        SELECT 
            proc."record" AS "id",
            NULLIF( SUM( CASE WHEN proc.id_plan IS NOT NULL AND proc.interval IS NULL THEN 1 ELSE 0 END ), 0 ) || ' проц.' AS "result"
        FROM proc
        GROUP BY proc."record"
    )
    SELECT 
        (SELECT result FROM intersection) AS "intxn",
        (SELECT result FROM notime) AS "notime"
) proc_agg ON true
WHERE o.is_deleted IS FALSE -->>
GROUP BY -->>          