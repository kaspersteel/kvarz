  WITH base AS (
	SELECT
		fio_pac.attr_1985_ AS "fio",
		o.attr_4005_ AS "hist_id",
		nom_fond.attr_135_ AS "nom",
		nom_fond.attr_444_ AS "nom_cat",
		o.attr_4032_ AS "date_rasp",
		plan.attr_784_ AS "id_proc",
		COALESCE(proc.attr_695_, P.name) AS "name_proc",
		P.*,
		(
	SELECT
		string_agg ( i, '\n' ) 
	FROM
		(
		SELECT UNNEST
			(
				ARRAY (
				SELECT UNNEST
					( ranges.arr [ 1 : 1 ][ 1 :] ) EXCEPT
				SELECT UNNEST
					( ranges.arr [ 2 : 2 ][ 1 :] ) 
				) 
				) || '-' || UNNEST (
				ARRAY (
				SELECT UNNEST
					( ranges.arr [ 2 : 2 ][ 1 :] ) EXCEPT
				SELECT UNNEST
					( ranges.arr [ 1 : 1 ][ 1 :] ) 
				) 
			) AS "i"
			FROM 			                    (
                       SELECT ARRAY[
                              ARRAY_AGG(t_ranges."start"),
                              ARRAY_AGG(t_ranges."finish")
                              ] as "arr"
                         FROM (
                                 SELECT timeslots.attr_4754_ AS "start",
                                        timeslots.attr_4753_ AS "finish",
                                        T.ID AS "id"
                                   FROM UNNEST(P.interval) AS T ("id")
                              LEFT JOIN registry.object_4002_ timeslots ON timeslots.ID = T.ID
                              ) AS "t_ranges"
                    ) AS "ranges"
		) AS "y" 
	) AS "time_proc" 
	FROM
		registry.object_4000_ o 
		/*Каждая строка расписания разворачивается в набор строк с параметрами отдельной процедуры. Неназначенные процедуры и процедуры без времени не учитываются.*/
		/*Для добавления новой процедуры нужно добавить её конфиг в реестр 5021. Тогда с ней сможет работать функция public.sched_get_procedures_config()*/
		LEFT JOIN LATERAL (
            SELECT 
                f.proc_name AS "name",
                f.proc_interval AS "interval",
                f.proc_id_plan AS "id_plan",
                f.proc_comment AS "comment"
            FROM public.sched_get_procedures_config() f 
            WHERE f.object_id = o.id
        ) P ON P.interval IS NOT NULL 
		AND P.interval != ARRAY [ 1 ]
		LEFT JOIN registry.object_783_ plan ON plan.ID = P.id_plan 
		AND NOT plan.is_deleted
		LEFT JOIN registry.object_694_ proc ON plan.attr_784_ = proc.ID 
		AND NOT proc.is_deleted
		LEFT JOIN registry.object_45_ fio_pac ON o.attr_4004_ = fio_pac.ID 
		AND NOT fio_pac.is_deleted
		LEFT JOIN registry.object_127_ nom_fond ON o.attr_4006_ = nom_fond.ID 
		AND NOT nom_fond.is_deleted 
              WHERE NOT o.is_deleted
                AND CASE '{superid}'
                              WHEN '' THEN TRUE
                              WHEN o.attr_4005_::VARCHAR THEN TRUE
                              ELSE FALSE
                    END
                AND o.attr_4032_ = COALESCE(
                    (
                    CASE
                              WHEN '{date_rasp}' = '' THEN NULL
                              ELSE '{date_rasp}'::VARCHAR
                    END
                    ),
                    CURRENT_DATE::VARCHAR
                    )::date

           ORDER BY "date_rasp" DESC,
                    "fio",
                    "time_proc"
          )
	SELECT base.*
      FROM base
     WHERE base.interval IS NOT NULL