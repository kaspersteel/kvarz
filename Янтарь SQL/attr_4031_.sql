/*Пересечение процедур, выявление неназначенного времени (attr_4859_)*/
/*базовая*/
SELECT -->>
*
FROM registry.object_4000_ o
LEFT JOIN (
                    WITH base AS (
             SELECT *
               FROM registry.object_4000_
              WHERE NOT is_deleted
          ),
          proc AS (
             SELECT o.id AS "record",
                    tab_proc.*
               FROM base o
          LEFT JOIN LATERAL (
                       VALUES (1, 'ЛФК 1', o.attr_4007_, o.attr_4008_, TRUE),
                              (2, 'ЛФК 2', o.attr_4009_, o.attr_4010_, TRUE),
                              (3, 'Бассейн', o.attr_4011_, o.attr_4012_, TRUE),
                              (4, 'Гидромассаж', o.attr_4013_, o.attr_4014_, TRUE),
                              (5, 'Эрготерапия', o.attr_4015_, o.attr_4016_, TRUE),
                              (6, 'Логопед', o.attr_4017_, o.attr_4018_, TRUE),
                              (7, 'Психолог', o.attr_4019_, o.attr_4020_, TRUE),
                              (8, 'ИРТ', o.attr_4021_, o.attr_4022_, TRUE),
                              (9, 'Массаж', o.attr_4023_, o.attr_4024_, TRUE),
                              (10, 'Физиотерапия', o.attr_4025_, o.attr_4026_, TRUE),
                              (11, 'Грязетерапия', o.attr_4027_, o.attr_4028_, TRUE),
                              (12, 'Спелеотерапия', o.attr_4029_, o.attr_4030_, TRUE),
                              (13, 'Гирудотерапия', o.attr_4162_, o.attr_4163_, TRUE),
                              (14, 'Фитоотерапия', o.attr_4165_, o.attr_4166_, FALSE),
                              (15, 'Кисл. кокт.', o.attr_4168_, o.attr_4169_, FALSE),
                              (16, 'Социокульт.', o.attr_4251_, o.attr_4252_, TRUE),
                              (17, 'Ингаляция', o.attr_4443_, o.attr_4444_, TRUE),
                              (18, 'Прессотерапия', o.attr_4446_, o.attr_4447_, TRUE),
                              (19, 'Сухая Игла', o.attr_4455_, o.attr_4456_, TRUE),
                              (20, 'ВТЭС', o.attr_4458_, o.attr_4459_, TRUE)
                    ) AS tab_proc ( "id", "name", "interval", "id_plan", "check_intersect" ) ON TRUE
          ),
          intersection AS (
             SELECT proc."record" AS "id",
                    STRING_AGG(DISTINCT proc."name" || ' || ' || proc2."name", '\n') AS "result"
               FROM proc
               JOIN proc proc2 ON proc."record" = proc2."record"
                AND proc.id < proc2.id
                AND proc."interval" && proc2."interval"
                AND NOT ( proc."interval" && ARRAY[1] OR proc2."interval" && ARRAY[1] )
                AND proc.check_intersect
                AND proc2.check_intersect
          /*очищаем от строк, куда не прикрепилось ни одной записи*/
              WHERE proc2."name" IS NOT NULL
           GROUP BY proc."record"
          ),
          notime AS (
             SELECT proc."record" AS "id",
                    NULLIF( SUM( CASE WHEN proc.id_plan IS NOT NULL AND proc.interval IS NULL THEN 1 ELSE 0 END ), 0 ) || ' проц.' AS "result"
               FROM proc
           GROUP BY proc."record"
          )
   SELECT o.id AS record,
          intersection.result AS "intxn",
          notime.result AS "notime"
     FROM base o
LEFT JOIN intersection USING (id)
LEFT JOIN notime USING (id)
) proc_agg ON proc_agg."record" = o.id
WHERE o.is_deleted IS FALSE -->>
GROUP BY -->>          