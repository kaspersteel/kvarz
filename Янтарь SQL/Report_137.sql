     WITH base AS (
             SELECT fio_pac.attr_1985_ AS "fio",
                    o.attr_4005_ AS "hist_id",
                    nom_cat.attr_444_ AS "nom",
                    o.attr_4032_ AS "date_rasp",
                    plan.attr_784_ AS "id_proc",
                    proc.attr_695_ AS "name_proc",
                    P.*,
                    (
                       SELECT ARRAY[
                              ARRAY_AGG(t_ranges."start"),
                              ARRAY_AGG(t_ranges."finish")
                              ]
                         FROM (
                                 SELECT timeslots.attr_4754_ AS "start",
                                        timeslots.attr_4753_ AS "finish",
                                        T.ID AS "id"
                                   FROM UNNEST(P.array_time) AS T ("id")
                              LEFT JOIN registry.object_4002_ timeslots ON timeslots.ID = T.ID
                              ) AS "t_ranges"
                    ) AS "array_ranges"
               FROM registry.object_4000_ o
                    /*Каждая строка расписания разворачивается в набор строк с параметрами отдельной процедуры. Неназначенные процедуры и процедуры без времени не учитываются.*/
                    /*Для добавления новой процедуры нужно добавить строку с её параметрами в список VALUES*/
          LEFT JOIN LATERAL (
                       VALUES (o.attr_4008_, o.attr_4007_, o.attr_4062_),
                              (o.attr_4010_, o.attr_4009_, o.attr_4063_),
                              (o.attr_4012_, o.attr_4011_, o.attr_4068_),
                              (o.attr_4014_, o.attr_4013_, o.attr_4069_),
                              (o.attr_4016_, o.attr_4015_, o.attr_4064_),
                              (o.attr_4018_, o.attr_4017_, o.attr_4067_),
                              (o.attr_4020_, o.attr_4019_, o.attr_4066_),
                              (o.attr_4022_, o.attr_4021_, o.attr_4070_),
                              (o.attr_4024_, o.attr_4023_, o.attr_4065_),
                              (o.attr_4026_, o.attr_4025_, o.attr_4071_),
                              (o.attr_4028_, o.attr_4027_, o.attr_4072_),
                              (o.attr_4030_, o.attr_4029_, o.attr_4073_),
                              (o.attr_4163_, o.attr_4162_, o.attr_4164_),
                              (o.attr_4166_, o.attr_4165_, o.attr_4167_),
                              (o.attr_4169_, o.attr_4168_, o.attr_4170_),
                              (o.attr_4252_, o.attr_4251_, o.attr_4253_),
                              (o.attr_4444_, o.attr_4443_, o.attr_4445_),
                              (o.attr_4447_, o.attr_4446_, o.attr_4448_),
                              (o.attr_4456_, o.attr_4455_, o.attr_4457_),
                              (o.attr_4459_, o.attr_4458_, o.attr_4460_)
                    ) AS P ("proc_in_plan", "array_time", "comment") ON P.array_time IS NOT NULL
                AND P.array_time != ARRAY[1]
          LEFT JOIN registry.object_783_ plan ON plan.ID = P.proc_in_plan
                AND NOT plan.is_deleted
          LEFT JOIN registry.object_694_ proc ON plan.attr_784_ = proc.ID
                AND NOT proc.is_deleted
          LEFT JOIN registry.object_45_ fio_pac ON o.attr_4004_ = fio_pac.ID
                AND NOT fio_pac.is_deleted
          LEFT JOIN registry.object_127_ nom_cat ON o.attr_4006_ = nom_cat.ID
                AND NOT nom_cat.is_deleted
              WHERE NOT o.is_deleted
                AND CASE '{superid}'
                              WHEN '' THEN TRUE
                              WHEN o.attr_4005_::VARCHAR THEN TRUE
                              ELSE FALSE
                    END
                AND o.attr_4032_ = COALESCE(
                    (
                    CASE
                              WHEN 'date_rasp' = '' THEN NULL
                              ELSE 'date_rasp'::VARCHAR
                    END
                    ),
                    CURRENT_DATE::VARCHAR
                    )::date
           ORDER BY "date_rasp" DESC,
                    "fio",
                    "array_time"
          )
	SELECT
	base.*,
	(
	SELECT
		string_agg ( i, '\n' ) AS "time_proc" 
	FROM
		(
		SELECT UNNEST
			(
				ARRAY (
				SELECT UNNEST
					( base.array_ranges [ 1 : 1 ][ 1 :] ) EXCEPT
				SELECT UNNEST
					( base.array_ranges [ 2 : 2 ][ 1 :] ) 
				) 
				) || '-' || UNNEST (
				ARRAY (
				SELECT UNNEST
					( base.array_ranges [ 2 : 2 ][ 1 :] ) EXCEPT
				SELECT UNNEST
					( base.array_ranges [ 1 : 1 ][ 1 :] ) 
				) 
			) AS "i" 
		) AS "y" 
	) 
FROM
	base 
WHERE
	base.array_time IS NOT NULL
