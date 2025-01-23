WITH 
/*таблица переменных*/
vars AS ( SELECT 
     {division}::int as "division",
     '{period}'::date as "period",
     (SELECT o.attr_1815_ FROM registry.object_15_ o WHERE o.id = {user}) as "subdivs",
     EXTRACT(MONTH FROM '{period}'::date)::int as "month_tab",
     EXTRACT(YEAR FROM '{period}'::date)::int as "year_tab",
     date_trunc('month', '{period}'::date) as fdm_tab,
     date_trunc('month', '{period}'::date) + INTERVAL '1 MONTH - 1 day' as ldm_tab,
),
/*исходная таблица табеля*/
source_tab AS (
/*заготовка под строку дней недели*/
     SELECT NULL AS "object_tab",
          NULL AS "card_tab",
          NULL AS "object_sotr",
          NULL AS "card_sotr",
          0 AS "id_sotr",
          NULL AS "fio_sotr",
          NULL AS "name_post",
          '0' AS "name_div",
          NULL AS "id_div",
          NULL AS "name_brigade",
          NULL AS "id_tab",
          EXTRACT( DAY FROM days ) AS "day_tab",
          NULL AS "h_plan",
          NULL AS "h_hand",
          NULL AS "h_asys",
          NULL AS "otp_plan",
          NULL AS "absence",
          days AS "date_period",
          holidays.id AS "holyday"
     FROM GENERATE_SERIES( ( SELECT fdm_tab FROM vars ), ( SELECT ldm_tab FROM vars ), '1 day' ) days
LEFT JOIN registry.object_757_ holidays ON holidays.attr_789_ = days
      AND NOT holidays.is_deleted
UNION ALL
SELECT
	    1774 AS "object_tab",
          223 AS "card_tab",
          419 AS "object_sotr",
          222 AS "card_sotr",
          o.id AS "id_sotr",
          o.attr_424_ AS "fio_sotr",
          post.attr_504_ AS "name_post",
          division.attr_1545_ AS "name_div",
          division.id AS "id_div",
          brigade.attr_1793_ AS "name_brigade",
          tabel.id AS "id_tab",
          EXTRACT(DAY FROM tabel.attr_1776_) AS "day_tab",
          tabel.attr_1780_ AS "h_plan",
          tabel.attr_1816_ AS "h_hand",
          COALESCE( asyst.attr_1789_, '00:00:00' ) AS "h_asys",
          CASE WHEN gr_otp.id is not null THEN 1 END AS "otp_plan",
          absence.attr_1504_ AS "absence",
          NULL AS "date_period",
          NULL AS "holyday"
     FROM registry.object_419_ o
LEFT JOIN registry.object_1774_ tabel ON o.id = tabel.attr_1775_
      AND NOT tabel.is_deleted
LEFT JOIN registry.object_503_ post ON o.attr_505_ = post.id
      AND NOT post.is_deleted
LEFT JOIN registry.object_1544_ division ON o.attr_1546_ = division.id
      AND NOT division.is_deleted
LEFT JOIN registry.object_1790_ brigade ON o.attr_1804_ = brigade.id
      AND NOT brigade.is_deleted
LEFT JOIN registry.object_1785_ asyst ON o.id = asyst.attr_1786_
      AND tabel.attr_1776_ = asyst.attr_1787_::date
      AND NOT asyst.is_deleted
LEFT JOIN registry.object_1690_ gr_otp ON o.id = gr_otp.attr_1692_
      AND tabel.attr_1776_ >= gr_otp.attr_1693_::date
      AND tabel.attr_1776_ <= gr_otp.attr_1694_::date
      AND NOT gr_otp.attr_1752_
      AND NOT gr_otp.is_deleted
LEFT JOIN registry.object_1502_ absence ON o.id = absence.attr_1503_
      AND tabel.attr_1776_ >= absence.attr_1505_::date
      AND tabel.attr_1776_ <= absence.attr_1506_::date
      AND NOT absence.is_deleted
    WHERE NOT o.is_deleted
      AND CASE
                    WHEN (SELECT division FROM vars) != 0 THEN 
                    CASE
                              WHEN division.id = (SELECT division FROM vars) THEN TRUE
                              ELSE FALSE
                    END
                    ELSE CASE
                              WHEN ARRAY[division.id] && (SELECT subdivs FROM vars) THEN TRUE
                              ELSE FALSE
                         END
          END
       AND CASE
                    WHEN DATE_TRUNC('month', tabel.attr_1776_::date) = DATE_TRUNC( 'month', ( SELECT period FROM vars ) ) THEN TRUE
                    ELSE FALSE
          END
			ORDER BY id_sotr, id_tab
),
/*базовая таблица табеля с суммами часов*/
base_tab AS (
SELECT 
source_tab.*,
/*сборка информации для ячеек таблицы*/
CASE WHEN source_tab.id_sotr = 0 THEN CASE WHEN source_tab.holyday is not null THEN 'В' END ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), source_tab.day_tab::int ) <= CURRENT_DATE THEN CASE WHEN source_tab.h_hand is not null THEN source_tab.h_hand::TEXT ELSE CASE WHEN EXTRACT( HOUR FROM source_tab.h_asys + INTERVAL '30 minutes' )::INT != COALESCE( source_tab.h_plan, 0) THEN '!' ELSE CASE WHEN source_tab.h_plan is not null THEN EXTRACT( HOUR FROM source_tab.h_asys + INTERVAL '30 minutes' )::TEXT ELSE CASE source_tab.absence WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN source_tab.otp_plan = 1 THEN 'Оп' ELSE '' END END END END END ELSE CASE WHEN source_tab.h_plan is null THEN CASE source_tab.absence WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN source_tab.otp_plan = 1 THEN 'Оп' ELSE '' END END ELSE CASE WHEN source_tab.absence is not null OR source_tab.otp_plan is not null THEN '!' ELSE 'Д' END END END END as "html"																																																																									
,																						

/*отдельные суммы по сотруднику, бригаде, подразделению*/
          SUM( source_tab.h_plan) OVER ( PARTITION BY source_tab.id_sotr ) AS "sum_plan",
          SUM( COALESCE( source_tab.h_hand, EXTRACT( HOUR FROM source_tab.h_asys + INTERVAL '30 minutes' )::INT ) ) OVER ( PARTITION BY source_tab.id_sotr ) AS "sum_fact",
          SUM( source_tab.h_plan ) OVER ( PARTITION BY source_tab.name_brigade ) AS "sum_br_plan",
          SUM( COALESCE( source_tab.h_hand, EXTRACT( HOUR FROM source_tab.h_asys + INTERVAL '30 minutes' )::INT ) ) OVER ( PARTITION BY source_tab.name_brigade ) AS "sum_br_fact",
          SUM( source_tab.h_plan ) OVER ( PARTITION BY source_tab.name_div ) AS "sum_div_plan",
          SUM( COALESCE( source_tab.h_hand, EXTRACT( HOUR FROM source_tab.h_asys + INTERVAL '30 minutes' )::INT ) ) OVER ( PARTITION BY source_tab.name_div ) AS "sum_div_fact"
FROM source_tab
),

/*табель*/
T AS (
      SELECT DISTINCT 
          base_tab.object_tab,
          base_tab.card_tab,
          base_tab.object_sotr,
          base_tab.card_sotr,
          base_tab.id_sotr,
          base_tab.fio_sotr,
            /*первая колонка таблицы*/
          CASE
                    WHEN base_tab.id_sotr = 0 THEN ''
                    WHEN base_tab.id_sotr IS NOT NULL THEN base_tab.fio_sotr
                    WHEN base_tab.name_brigade IS NOT NULL THEN 'Итого ' || base_tab.name_brigade || ''
                    WHEN base_tab.name_div IS NOT NULL THEN 'Итого ' || base_tab.name_div || ''
          END AS "first_column",
          base_tab.name_post,
          base_tab.name_div,
          base_tab.id_div,
          base_tab.name_brigade,
          CASE
                    WHEN base_tab.id_sotr IS NOT NULL THEN MAX(base_tab.sum_plan)
                    WHEN base_tab.name_brigade IS NOT NULL THEN MAX(base_tab.sum_br_plan)
                    ELSE MAX(base_tab.sum_div_plan)
          END AS sum_plan,
          CASE
                    WHEN base_tab.id_sotr IS NOT NULL THEN MAX(base_tab.sum_fact)
                    WHEN base_tab.name_brigade IS NOT NULL THEN MAX(base_tab.sum_br_fact)
                    ELSE MAX(base_tab.sum_div_fact)
          END AS sum_fact,

/*поколоночный вывод информации в ячейки*/
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 1 THEN base_tab.html END) END as column1,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 2 THEN base_tab.html END) END as column2,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 3 THEN base_tab.html END) END as column3,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 4 THEN base_tab.html END) END as column4,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 5 THEN base_tab.html END) END as column5,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 6 THEN base_tab.html END) END as column6,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 7 THEN base_tab.html END) END as column7,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 8 THEN base_tab.html END) END as column8,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 9 THEN base_tab.html END) END as column9,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 10 THEN base_tab.html END) END as column10,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 11 THEN base_tab.html END) END as column11,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 12 THEN base_tab.html END) END as column12,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 13 THEN base_tab.html END) END as column13,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 14 THEN base_tab.html END) END as column14,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 15 THEN base_tab.html END) END as column15,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 16 THEN base_tab.html END) END as column16,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 17 THEN base_tab.html END) END as column17,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 18 THEN base_tab.html END) END as column18,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 19 THEN base_tab.html END) END as column19,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 20 THEN base_tab.html END) END as column20,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 21 THEN base_tab.html END) END as column21,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 22 THEN base_tab.html END) END as column22,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 23 THEN base_tab.html END) END as column23,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 24 THEN base_tab.html END) END as column24,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 25 THEN base_tab.html END) END as column25,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 26 THEN base_tab.html END) END as column26,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 27 THEN base_tab.html END) END as column27,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 28 THEN base_tab.html END) END as column28,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 29 THEN base_tab.html END) END as column29,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 30 THEN base_tab.html END) END as column30,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 31 THEN base_tab.html END) END as column31
						
FROM base_tab
/*формулы группировки по сотруднику, а так же бригаде и подразделению - для строк итого*/
GROUP BY 
GROUPING SETS (
(object_tab, card_tab, object_sotr, card_sotr, base_tab.id_sotr, base_tab.fio_sotr, base_tab.id_div, base_tab.name_div, base_tab.name_post, base_tab.name_brigade)
, (base_tab.name_brigade, base_tab.name_div)
, base_tab.name_div
)

ORDER BY
name_div, 
name_brigade, 
fio_sotr
)

select T.* from T 
/*убираем строку итого для строки дней*/
WHERE not (T.name_div = '0' AND T.id_sotr is null)