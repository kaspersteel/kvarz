     WITH base AS (
             SELECT fio_pac.attr_1985_ AS "fio",
                    o.attr_4005_ AS "hist_id",
                    nom_cat.attr_444_ AS "nom",
                    o.attr_4032_ AS "date_rasp",
                    plan.attr_784_ AS "id_proc",
                    proc.attr_695_ AS "name_proc",
                    p.*,
                    (
                       SELECT ARRAY[
                              ARRAY_AGG(t_ranges.start),
                              ARRAY_AGG(t_ranges.finish)
                              ]
                         FROM (
                                 SELECT timeslots.attr_4754_ AS "start",
                                        timeslots.attr_4753_ AS "finish",
                                        T.id AS "id"
                                   FROM UNNEST(P.array_time) AS T ("id")
                              LEFT JOIN registry.object_4002_ timeslots ON timeslots.id = T.id
                              ) AS "t_ranges"
                    ) AS "array_ranges"
               FROM registry.object_4000_ o
                    /*строится таблица соответствия id процедуры в плане и её времени по строке расписания*/
          LEFT JOIN LATERAL (
                       VALUES (o.attr_4008_, o.attr_4007_),
                              (o.attr_4010_, o.attr_4009_),
                              (o.attr_4012_, o.attr_4011_),
                              (o.attr_4014_, o.attr_4013_),
                              (o.attr_4016_, o.attr_4015_),
                              (o.attr_4018_, o.attr_4017_),
                              (o.attr_4020_, o.attr_4019_),
                              (o.attr_4022_, o.attr_4021_),
                              (o.attr_4024_, o.attr_4023_),
                              (o.attr_4026_, o.attr_4025_),
                              (o.attr_4028_, o.attr_4027_),
                              (o.attr_4030_, o.attr_4029_),
                              (o.attr_4163_, o.attr_4162_),
                              (o.attr_4166_, o.attr_4165_),
                              (o.attr_4169_, o.attr_4168_),
                              (o.attr_4252_, o.attr_4251_),
                              (o.attr_4444_, o.attr_4443_),
                              (o.attr_4447_, o.attr_4446_),
                              (o.attr_4456_, o.attr_4455_),
                              (o.attr_4459_, o.attr_4458_)
                    ) AS p ("proc_in_plan", "array_time") ON p.array_time IS NOT NULL
                AND p.array_time != ARRAY[1]
          LEFT JOIN registry.object_783_ plan ON plan.id = p.proc_in_plan
                AND NOT plan.is_deleted
          LEFT JOIN registry.object_694_ proc ON plan.attr_784_ = proc.id
                AND NOT proc.is_deleted
          LEFT JOIN registry.object_45_ fio_pac ON o.attr_4004_ = fio_pac.id
                AND NOT fio_pac.is_deleted
          LEFT JOIN registry.object_127_ nom_cat ON o.attr_4006_ = nom_cat.id
                AND NOT nom_cat.is_deleted
              WHERE NOT o.is_deleted
                AND o.attr_4005_ = '{superid}'
                AND o.attr_4032_ = COALESCE(
                    (
                    CASE
                              WHEN '{date_rasp}' = '' THEN NULL
                              ELSE '{date_rasp}'::TEXT
                    END
                    ),
                    CURRENT_DATE::TEXT
                    )::date
           ORDER BY 4 DESC,
                    1,
                    8
          )
   SELECT base.*,
          (
             SELECT STRING_AGG(interval, '\n')
               FROM (
                       SELECT UNNEST(ARRAY_REMOVE(ARRAY_AGG(x.c1), NULL)) || '-' || UNNEST(ARRAY_REMOVE(ARRAY_AGG(x.c2), NULL)) AS interval
                         FROM (
                                 SELECT CASE
                                                  WHEN timeslots.start NOT IN (
                                                     SELECT timeslots.finish
                                                       FROM UNNEST(
                                                            base.array_ranges [1:1][1:], 
                                                            base.array_ranges [2:2][1:]
                                                            ) AS timeslots ("start", "finish")
                                                  ) THEN timeslots.start
                                        END AS c1,
                                        CASE
                                                  WHEN timeslots.finish NOT IN (
                                                     SELECT timeslots.start
                                                       FROM UNNEST(
                                                            base.array_ranges [1:1][1:], 
                                                            base.array_ranges [2:2][1:]
                                                            ) AS timeslots ("start", "finish")
                                                  ) THEN timeslots.finish
                                        END AS c2
                                   FROM UNNEST(
                                        base.array_ranges [1:1][1:], 
                                        base.array_ranges [2:2][1:]
                                        ) AS timeslots ("start", "finish")
                              ) x
                    ) y
          ) AS "time_proc"
     FROM base
    WHERE base.array_time IS NOT NULL