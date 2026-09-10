WITH 
/*таблица переменных*/
vars AS ( SELECT 
     {division}::int as "division",
     {employee}::int as "employee",
     {period}::date as "period",
     (SELECT o.attr_1815_ FROM registry.object_15_ o WHERE o.id = {user}) as "subdivs",
     EXTRACT(MONTH FROM {period}::date)::int as "month_tab",
     EXTRACT(YEAR FROM {period}::date)::int as "year_tab",
     date_trunc('month', {period}::date) as fdm_tab,
     date_trunc('month', {period}::date) + INTERVAL '1 MONTH - 1 day' as ldm_tab,
     'RGB(0 255 0 / 0)' AS "c_notwork",
     'RGB(60 179 113 / 0.25)' AS "c_work",
     'RGB(36 107 68 / 0.25)' AS "c_hand", --Mint Green    
     /*'RGB(101 146 86 / 0.25)' AS "c_hand", --Спаржа*/
     /*'RGB(60 113 179 / 0.25)' AS "c_hand", --Steel Blue*/   
     /*'RGB(60 156 180 / 0.25)' AS "c_hand", --Grey Blue*/
     'RGB(180 60 66 / 0.25)' AS "c_alert",
     /*'RGB(220 20 60 / 0.25)' AS "c_alert", --Crimson */   
     'RGB(255 255 0 / 0.25)' AS "c_vacation",
     'RGB(255 165 0 / 0.25)' AS "c_absence",
     'RGB(105 105 105 / 0.25)' AS "c_holiday" --DimGrey
     /*'RGB(65 105 225 / 0.25)' AS "c_holiday" --RoyalBlue*/        
     /*'RGB(255 238 208 / 1)' AS "c_holiday" --цвет шапки*/    
), 
/*базовая таблица табеля с суммами часов*/
base_tab AS (
/*заготовка под строку дней недели*/
   SELECT NULL AS "object_tab",
          NULL AS "card_tab",
          NULL AS "object_sotr",
          NULL AS "card_sotr",
          0 AS "id_sotr",
          NULL AS "fio_sotr",
          NULL AS "name_post",
          NULL AS "name_div",
          NULL AS "id_div",
          NULL AS "name_brigade",
          NULL AS "id_tab",
          NULL AS "day_tab",
          NULL AS "h_plan",
          NULL AS "h_hand",
          NULL AS "h_asys",
          NULL AS "otp_plan",
          NULL AS "absence",
          NULL AS "sum_plan",
          NULL AS "sum_fact",
          NULL AS "sum_br_plan",
          NULL AS "sum_br_fact",
          NULL AS "sum_div_plan",
          NULL AS "sum_div_fact"
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

          SUM( tabel.attr_1780_ ) OVER ( PARTITION BY o.id ) AS "sum_plan",
          SUM( COALESCE( tabel.attr_1816_, FLOOR( EXTRACT( HOUR FROM asyst.attr_1789_ + INTERVAL '30 minutes' )::INT ) ) ) OVER ( PARTITION BY o.id ) AS "sum_fact",
          SUM( tabel.attr_1780_ ) OVER ( PARTITION BY brigade.id ) AS "sum_br_plan",
          SUM( COALESCE( tabel.attr_1816_, FLOOR( EXTRACT( HOUR FROM asyst.attr_1789_ + INTERVAL '30 minutes' )::INT ) ) ) OVER ( PARTITION BY brigade.id ) AS "sum_br_fact",
          SUM( tabel.attr_1780_ ) OVER ( PARTITION BY division.id ) AS "sum_div_plan",
          SUM( COALESCE( tabel.attr_1816_, FLOOR( EXTRACT( HOUR FROM asyst.attr_1789_ + INTERVAL '30 minutes' )::INT ) ) ) OVER ( PARTITION BY division.id ) AS "sum_div_fact"
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
                    WHEN (SELECT division FROM vars) IS NOT NULL THEN CASE
                              WHEN division.id = (SELECT division FROM vars) THEN TRUE
                              ELSE FALSE
                    END
                    ELSE CASE
                              WHEN ARRAY[division.id] && (SELECT subdivs FROM vars) THEN TRUE
                              --WHEN division.id = ANY(SELECT UNNEST(subdivs) FROM vars) THEN TRUE
                              ELSE FALSE
                    END
          END
      AND CASE
                    WHEN (
                       SELECT employee
                         FROM vars
                    )::INT IS NOT NULL THEN CASE
                              WHEN o.id = (
                                 SELECT employee
                                   FROM vars
                              )::INT THEN TRUE
                              ELSE FALSE
                    END
                    ELSE TRUE
          END
      AND CASE
                    WHEN DATE_TRUNC('month', tabel.attr_1776_::date) = DATE_TRUNC(
                    'month',
                    (
                       SELECT period
                         FROM vars
                    )
                    ) THEN TRUE
                    ELSE FALSE
          END
			ORDER BY id_sotr, id_tab
),

/*табель*/
T AS (
   SELECT distinct
	 base_tab.object_tab,
base_tab.card_tab,
base_tab.object_sotr,
base_tab.card_sotr,
				base_tab.id_sotr,
          base_tab.fio_sotr,
					CASE 
WHEN base_tab.id_sotr is not NULL THEN base_tab.fio_sotr 
WHEN base_tab.name_brigade is not NULL THEN 'Итого '||base_tab.name_brigade||' --->' 
WHEN base_tab.name_div is not NULL THEN 'Итого '||base_tab.name_div||' --->' 
END as "first_column", 
          base_tab.name_post,
          base_tab.name_div,
          base_tab.id_div,
          base_tab.name_brigade,
CASE 
WHEN base_tab.id_sotr is not NULL THEN MAX (base_tab.sum_plan) 
WHEN base_tab.name_brigade is not NULL THEN MAX (base_tab.sum_br_plan) 
ELSE MAX (base_tab.sum_div_plan)
END as sum_plan,

CASE 
WHEN base_tab.id_sotr is not NULL THEN MAX (base_tab.sum_fact)
WHEN base_tab.name_brigade is not NULL THEN MAX (base_tab.sum_br_fact)
ELSE MAX (base_tab.sum_div_fact)
END as sum_fact,
MAX (CASE WHEN base_tab.day_tab = 1 THEN base_tab.id_tab END) as id_tab1,
MAX (CASE WHEN base_tab.day_tab = 2 THEN base_tab.id_tab END) as id_tab2,
MAX (CASE WHEN base_tab.day_tab = 3 THEN base_tab.id_tab END) as id_tab3,
MAX (CASE WHEN base_tab.day_tab = 4 THEN base_tab.id_tab END) as id_tab4,
MAX (CASE WHEN base_tab.day_tab = 5 THEN base_tab.id_tab END) as id_tab5,
MAX (CASE WHEN base_tab.day_tab = 6 THEN base_tab.id_tab END) as id_tab6,
MAX (CASE WHEN base_tab.day_tab = 7 THEN base_tab.id_tab END) as id_tab7,
MAX (CASE WHEN base_tab.day_tab = 8 THEN base_tab.id_tab END) as id_tab8,
MAX (CASE WHEN base_tab.day_tab = 9 THEN base_tab.id_tab END) as id_tab9,
MAX (CASE WHEN base_tab.day_tab = 10 THEN base_tab.id_tab END) as id_tab10,
MAX (CASE WHEN base_tab.day_tab = 11 THEN base_tab.id_tab END) as id_tab11,
MAX (CASE WHEN base_tab.day_tab = 12 THEN base_tab.id_tab END) as id_tab12,
MAX (CASE WHEN base_tab.day_tab = 13 THEN base_tab.id_tab END) as id_tab13,
MAX (CASE WHEN base_tab.day_tab = 14 THEN base_tab.id_tab END) as id_tab14,
MAX (CASE WHEN base_tab.day_tab = 15 THEN base_tab.id_tab END) as id_tab15,
MAX (CASE WHEN base_tab.day_tab = 16 THEN base_tab.id_tab END) as id_tab16,
MAX (CASE WHEN base_tab.day_tab = 17 THEN base_tab.id_tab END) as id_tab17,
MAX (CASE WHEN base_tab.day_tab = 18 THEN base_tab.id_tab END) as id_tab18,
MAX (CASE WHEN base_tab.day_tab = 19 THEN base_tab.id_tab END) as id_tab19,
MAX (CASE WHEN base_tab.day_tab = 20 THEN base_tab.id_tab END) as id_tab20,
MAX (CASE WHEN base_tab.day_tab = 21 THEN base_tab.id_tab END) as id_tab21,
MAX (CASE WHEN base_tab.day_tab = 22 THEN base_tab.id_tab END) as id_tab22,
MAX (CASE WHEN base_tab.day_tab = 23 THEN base_tab.id_tab END) as id_tab23,
MAX (CASE WHEN base_tab.day_tab = 24 THEN base_tab.id_tab END) as id_tab24,
MAX (CASE WHEN base_tab.day_tab = 25 THEN base_tab.id_tab END) as id_tab25,
MAX (CASE WHEN base_tab.day_tab = 26 THEN base_tab.id_tab END) as id_tab26,
MAX (CASE WHEN base_tab.day_tab = 27 THEN base_tab.id_tab END) as id_tab27,
MAX (CASE WHEN base_tab.day_tab = 28 THEN base_tab.id_tab END) as id_tab28,
MAX (CASE WHEN base_tab.day_tab = 29 THEN base_tab.id_tab END) as id_tab29,
MAX (CASE WHEN base_tab.day_tab = 30 THEN base_tab.id_tab END) as id_tab30,
MAX (CASE WHEN base_tab.day_tab = 31 THEN base_tab.id_tab END) as id_tab31,
          array_agg(base_tab.h_plan ORDER BY day_tab) AS "h_plan",
          array_agg(base_tab.h_hand ORDER BY day_tab) AS "h_hand",
          array_agg(base_tab.h_asys ORDER BY day_tab) AS "h_asys",
          array_agg(base_tab.otp_plan ORDER BY day_tab) AS "otp_plan",
          array_agg(base_tab.absence ORDER BY day_tab) AS "absence"

FROM base_tab
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
),
/*строка дней недели*/
dow AS (
SELECT 
MAX (CASE WHEN EXTRACT(DAY FROM days) = 1 THEN '<div style="background-color:'||CASE WHEN holidays.id is not null THEN (SELECT c_holiday FROM vars) END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(days, 'TMDy')||'</div></div> ' END) as column1,
MAX (CASE WHEN EXTRACT(DAY FROM days) = 2 THEN '<div style="background-color:'||CASE WHEN holidays.id is not null THEN (SELECT c_holiday FROM vars) END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(days, 'TMDy')||'</div></div> ' END) as column2,
MAX (CASE WHEN EXTRACT(DAY FROM days) = 3 THEN '<div style="background-color:'||CASE WHEN holidays.id is not null THEN (SELECT c_holiday FROM vars) END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(days, 'TMDy')||'</div></div> ' END) as column3,
MAX (CASE WHEN EXTRACT(DAY FROM days) = 4 THEN '<div style="background-color:'||CASE WHEN holidays.id is not null THEN (SELECT c_holiday FROM vars) END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(days, 'TMDy')||'</div></div> ' END) as column4,
MAX (CASE WHEN EXTRACT(DAY FROM days) = 5 THEN '<div style="background-color:'||CASE WHEN holidays.id is not null THEN (SELECT c_holiday FROM vars) END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(days, 'TMDy')||'</div></div> ' END) as column5,
MAX (CASE WHEN EXTRACT(DAY FROM days) = 6 THEN '<div style="background-color:'||CASE WHEN holidays.id is not null THEN (SELECT c_holiday FROM vars) END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(days, 'TMDy')||'</div></div> ' END) as column6,
MAX (CASE WHEN EXTRACT(DAY FROM days) = 7 THEN '<div style="background-color:'||CASE WHEN holidays.id is not null THEN (SELECT c_holiday FROM vars) END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(days, 'TMDy')||'</div></div> ' END) as column7,
MAX (CASE WHEN EXTRACT(DAY FROM days) = 8 THEN '<div style="background-color:'||CASE WHEN holidays.id is not null THEN (SELECT c_holiday FROM vars) END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(days, 'TMDy')||'</div></div> ' END) as column8,
MAX (CASE WHEN EXTRACT(DAY FROM days) = 9 THEN '<div style="background-color:'||CASE WHEN holidays.id is not null THEN (SELECT c_holiday FROM vars) END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(days, 'TMDy')||'</div></div> ' END) as column9,
MAX (CASE WHEN EXTRACT(DAY FROM days) = 10 THEN '<div style="background-color:'||CASE WHEN holidays.id is not null THEN (SELECT c_holiday FROM vars) END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(days, 'TMDy')||'</div></div> ' END) as column10,
MAX (CASE WHEN EXTRACT(DAY FROM days) = 11 THEN '<div style="background-color:'||CASE WHEN holidays.id is not null THEN (SELECT c_holiday FROM vars) END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(days, 'TMDy')||'</div></div> ' END) as column11,
MAX (CASE WHEN EXTRACT(DAY FROM days) = 12 THEN '<div style="background-color:'||CASE WHEN holidays.id is not null THEN (SELECT c_holiday FROM vars) END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(days, 'TMDy')||'</div></div> ' END) as column12,
MAX (CASE WHEN EXTRACT(DAY FROM days) = 13 THEN '<div style="background-color:'||CASE WHEN holidays.id is not null THEN (SELECT c_holiday FROM vars) END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(days, 'TMDy')||'</div></div> ' END) as column13,
MAX (CASE WHEN EXTRACT(DAY FROM days) = 14 THEN '<div style="background-color:'||CASE WHEN holidays.id is not null THEN (SELECT c_holiday FROM vars) END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(days, 'TMDy')||'</div></div> ' END) as column14,
MAX (CASE WHEN EXTRACT(DAY FROM days) = 15 THEN '<div style="background-color:'||CASE WHEN holidays.id is not null THEN (SELECT c_holiday FROM vars) END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(days, 'TMDy')||'</div></div> ' END) as column15,
MAX (CASE WHEN EXTRACT(DAY FROM days) = 16 THEN '<div style="background-color:'||CASE WHEN holidays.id is not null THEN (SELECT c_holiday FROM vars) END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(days, 'TMDy')||'</div></div> ' END) as column16,
MAX (CASE WHEN EXTRACT(DAY FROM days) = 17 THEN '<div style="background-color:'||CASE WHEN holidays.id is not null THEN (SELECT c_holiday FROM vars) END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(days, 'TMDy')||'</div></div> ' END) as column17,
MAX (CASE WHEN EXTRACT(DAY FROM days) = 18 THEN '<div style="background-color:'||CASE WHEN holidays.id is not null THEN (SELECT c_holiday FROM vars) END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(days, 'TMDy')||'</div></div> ' END) as column18,
MAX (CASE WHEN EXTRACT(DAY FROM days) = 19 THEN '<div style="background-color:'||CASE WHEN holidays.id is not null THEN (SELECT c_holiday FROM vars) END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(days, 'TMDy')||'</div></div> ' END) as column19,
MAX (CASE WHEN EXTRACT(DAY FROM days) = 20 THEN '<div style="background-color:'||CASE WHEN holidays.id is not null THEN (SELECT c_holiday FROM vars) END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(days, 'TMDy')||'</div></div> ' END) as column20,
MAX (CASE WHEN EXTRACT(DAY FROM days) = 21 THEN '<div style="background-color:'||CASE WHEN holidays.id is not null THEN (SELECT c_holiday FROM vars) END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(days, 'TMDy')||'</div></div> ' END) as column21,
MAX (CASE WHEN EXTRACT(DAY FROM days) = 22 THEN '<div style="background-color:'||CASE WHEN holidays.id is not null THEN (SELECT c_holiday FROM vars) END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(days, 'TMDy')||'</div></div> ' END) as column22,
MAX (CASE WHEN EXTRACT(DAY FROM days) = 23 THEN '<div style="background-color:'||CASE WHEN holidays.id is not null THEN (SELECT c_holiday FROM vars) END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(days, 'TMDy')||'</div></div> ' END) as column23,
MAX (CASE WHEN EXTRACT(DAY FROM days) = 24 THEN '<div style="background-color:'||CASE WHEN holidays.id is not null THEN (SELECT c_holiday FROM vars) END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(days, 'TMDy')||'</div></div> ' END) as column24,
MAX (CASE WHEN EXTRACT(DAY FROM days) = 25 THEN '<div style="background-color:'||CASE WHEN holidays.id is not null THEN (SELECT c_holiday FROM vars) END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(days, 'TMDy')||'</div></div> ' END) as column25,
MAX (CASE WHEN EXTRACT(DAY FROM days) = 26 THEN '<div style="background-color:'||CASE WHEN holidays.id is not null THEN (SELECT c_holiday FROM vars) END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(days, 'TMDy')||'</div></div> ' END) as column26,
MAX (CASE WHEN EXTRACT(DAY FROM days) = 27 THEN '<div style="background-color:'||CASE WHEN holidays.id is not null THEN (SELECT c_holiday FROM vars) END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(days, 'TMDy')||'</div></div> ' END) as column27,
MAX (CASE WHEN EXTRACT(DAY FROM days) = 28 THEN '<div style="background-color:'||CASE WHEN holidays.id is not null THEN (SELECT c_holiday FROM vars) END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(days, 'TMDy')||'</div></div> ' END) as column28,
MAX (CASE WHEN EXTRACT(DAY FROM days) = 29 THEN '<div style="background-color:'||CASE WHEN holidays.id is not null THEN (SELECT c_holiday FROM vars) END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(days, 'TMDy')||'</div></div> ' END) as column29,
MAX (CASE WHEN EXTRACT(DAY FROM days) = 30 THEN '<div style="background-color:'||CASE WHEN holidays.id is not null THEN (SELECT c_holiday FROM vars) END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(days, 'TMDy')||'</div></div> ' END) as column30,
MAX (CASE WHEN EXTRACT(DAY FROM days) = 31 THEN '<div style="background-color:'||CASE WHEN holidays.id is not null THEN (SELECT c_holiday FROM vars) END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(days, 'TMDy')||'</div></div> ' END) as column31
FROM generate_series((SELECT fdm_tab FROM vars), (SELECT ldm_tab FROM vars), '1 day') days
LEFT JOIN registry.object_757_ holidays ON holidays.attr_789_ = days AND NOT holidays.is_deleted
),
/*строка дней недели c полями, нужными для UNION*/
dow_row AS (
SELECT 
T_row.*, dow.*
FROM dow
LEFT JOIN (SELECT * FROM T WHERE id_sotr = 0) T_row ON true
)

--SELECT * from base_tab 
SELECT * 
FROM dow_row
UNION ALL
select T.* ,
CASE WHEN T.id_sotr is not null THEN CASE WHEN T.h_asys[1] = '00:00:00' THEN CASE T.absence[1] WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' ELSE CASE WHEN T.otp_plan[1] = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 1) <= CURRENT_DATE THEN CASE WHEN T.h_plan[1] is not null THEN CASE WHEN T.h_hand[1] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[1]::TEXT||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 10; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[1] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END::text END ELSE CASE WHEN T.h_plan[1] is not null THEN '<div style="background-color:'||(SELECT 'darkgrey' FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' END END END END ELSE CASE WHEN T.h_hand[1] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[1]::TEXT||'</div></div> ' ELSE CASE WHEN T.h_asys[1] + interval '30 minutes' != make_time(T.h_plan[1], 0, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[1] + INTERVAL '30 minutes' )::INT )||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[1] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END END::text END END as column1,
CASE WHEN T.id_sotr is not null THEN CASE WHEN T.h_asys[2] = '00:00:00' THEN CASE T.absence[2] WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' ELSE CASE WHEN T.otp_plan[2] = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 2) <= CURRENT_DATE THEN CASE WHEN T.h_plan[2] is not null THEN CASE WHEN T.h_hand[2] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[2]::TEXT||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 20; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[2] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END::text END ELSE CASE WHEN T.h_plan[2] is not null THEN '<div style="background-color:'||(SELECT 'darkgrey' FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' END END END END ELSE CASE WHEN T.h_hand[2] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[2]::TEXT||'</div></div> ' ELSE CASE WHEN T.h_asys[2] + interval '30 minutes' != make_time(T.h_plan[2], 0, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[2] + INTERVAL '30 minutes' )::INT )||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[2] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END END::text END END as column2,
CASE WHEN T.id_sotr is not null THEN CASE WHEN T.h_asys[3] = '00:00:00' THEN CASE T.absence[3] WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' ELSE CASE WHEN T.otp_plan[3] = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 3) <= CURRENT_DATE THEN CASE WHEN T.h_plan[3] is not null THEN CASE WHEN T.h_hand[3] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[3]::TEXT||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 30; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[3] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END::text END ELSE CASE WHEN T.h_plan[3] is not null THEN '<div style="background-color:'||(SELECT 'darkgrey' FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' END END END END ELSE CASE WHEN T.h_hand[3] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[3]::TEXT||'</div></div> ' ELSE CASE WHEN T.h_asys[3] + interval '30 minutes' != make_time(T.h_plan[3], 0, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[3] + INTERVAL '30 minutes' )::INT )||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[3] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END END::text END END as column3,
CASE WHEN T.id_sotr is not null THEN CASE WHEN T.h_asys[4] = '00:00:00' THEN CASE T.absence[4] WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' ELSE CASE WHEN T.otp_plan[4] = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 4) <= CURRENT_DATE THEN CASE WHEN T.h_plan[4] is not null THEN CASE WHEN T.h_hand[4] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[4]::TEXT||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 40; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[4] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END::text END ELSE CASE WHEN T.h_plan[4] is not null THEN '<div style="background-color:'||(SELECT 'darkgrey' FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' END END END END ELSE CASE WHEN T.h_hand[4] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[4]::TEXT||'</div></div> ' ELSE CASE WHEN T.h_asys[4] + interval '30 minutes' != make_time(T.h_plan[4], 0, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[4] + INTERVAL '30 minutes' )::INT )||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[4] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END END::text END END as column4,
CASE WHEN T.id_sotr is not null THEN CASE WHEN T.h_asys[5] = '00:00:00' THEN CASE T.absence[5] WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' ELSE CASE WHEN T.otp_plan[5] = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 5) <= CURRENT_DATE THEN CASE WHEN T.h_plan[5] is not null THEN CASE WHEN T.h_hand[5] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[5]::TEXT||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 50; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[5] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END::text END ELSE CASE WHEN T.h_plan[5] is not null THEN '<div style="background-color:'||(SELECT 'darkgrey' FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' END END END END ELSE CASE WHEN T.h_hand[5] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[5]::TEXT||'</div></div> ' ELSE CASE WHEN T.h_asys[5] + interval '30 minutes' != make_time(T.h_plan[5], 0, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[5] + INTERVAL '30 minutes' )::INT )||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[5] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END END::text END END as column5,
CASE WHEN T.id_sotr is not null THEN CASE WHEN T.h_asys[6] = '00:00:00' THEN CASE T.absence[6] WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' ELSE CASE WHEN T.otp_plan[6] = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 6) <= CURRENT_DATE THEN CASE WHEN T.h_plan[6] is not null THEN CASE WHEN T.h_hand[6] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[6]::TEXT||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 60; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[6] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END::text END ELSE CASE WHEN T.h_plan[6] is not null THEN '<div style="background-color:'||(SELECT 'darkgrey' FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' END END END END ELSE CASE WHEN T.h_hand[6] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[6]::TEXT||'</div></div> ' ELSE CASE WHEN T.h_asys[6] + interval '30 minutes' != make_time(T.h_plan[6], 0, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[6] + INTERVAL '30 minutes' )::INT )||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[6] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END END::text END END as column6,
CASE WHEN T.id_sotr is not null THEN CASE WHEN T.h_asys[7] = '00:00:00' THEN CASE T.absence[7] WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' ELSE CASE WHEN T.otp_plan[7] = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 7) <= CURRENT_DATE THEN CASE WHEN T.h_plan[7] is not null THEN CASE WHEN T.h_hand[7] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[7]::TEXT||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 70; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[7] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END::text END ELSE CASE WHEN T.h_plan[7] is not null THEN '<div style="background-color:'||(SELECT 'darkgrey' FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' END END END END ELSE CASE WHEN T.h_hand[7] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[7]::TEXT||'</div></div> ' ELSE CASE WHEN T.h_asys[7] + interval '30 minutes' != make_time(T.h_plan[7], 0, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[7] + INTERVAL '30 minutes' )::INT )||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[7] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END END::text END END as column7,
CASE WHEN T.id_sotr is not null THEN CASE WHEN T.h_asys[8] = '00:00:00' THEN CASE T.absence[8] WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' ELSE CASE WHEN T.otp_plan[8] = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 8) <= CURRENT_DATE THEN CASE WHEN T.h_plan[8] is not null THEN CASE WHEN T.h_hand[8] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[8]::TEXT||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 80; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[8] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END::text END ELSE CASE WHEN T.h_plan[8] is not null THEN '<div style="background-color:'||(SELECT 'darkgrey' FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' END END END END ELSE CASE WHEN T.h_hand[8] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[8]::TEXT||'</div></div> ' ELSE CASE WHEN T.h_asys[8] + interval '30 minutes' != make_time(T.h_plan[8], 0, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[8] + INTERVAL '30 minutes' )::INT )||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[8] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END END::text END END as column8,
CASE WHEN T.id_sotr is not null THEN CASE WHEN T.h_asys[9] = '00:00:00' THEN CASE T.absence[9] WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' ELSE CASE WHEN T.otp_plan[9] = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 9) <= CURRENT_DATE THEN CASE WHEN T.h_plan[9] is not null THEN CASE WHEN T.h_hand[9] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[9]::TEXT||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 90; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[9] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END::text END ELSE CASE WHEN T.h_plan[9] is not null THEN '<div style="background-color:'||(SELECT 'darkgrey' FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' END END END END ELSE CASE WHEN T.h_hand[9] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[9]::TEXT||'</div></div> ' ELSE CASE WHEN T.h_asys[9] + interval '30 minutes' != make_time(T.h_plan[9], 0, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[9] + INTERVAL '30 minutes' )::INT )||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[9] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END END::text END END as column9,
CASE WHEN T.id_sotr is not null THEN CASE WHEN T.h_asys[10] = '00:00:00' THEN CASE T.absence[10] WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' ELSE CASE WHEN T.otp_plan[10] = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 10) <= CURRENT_DATE THEN CASE WHEN T.h_plan[10] is not null THEN CASE WHEN T.h_hand[10] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[10]::TEXT||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 100; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[10] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END::text END ELSE CASE WHEN T.h_plan[10] is not null THEN '<div style="background-color:'||(SELECT 'darkgrey' FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' END END END END ELSE CASE WHEN T.h_hand[10] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[10]::TEXT||'</div></div> ' ELSE CASE WHEN T.h_asys[10] + interval '30 minutes' != make_time(T.h_plan[10], 0, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[10] + INTERVAL '30 minutes' )::INT )||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[10] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END END::text END END as column10,
CASE WHEN T.id_sotr is not null THEN CASE WHEN T.h_asys[11] = '00:00:00' THEN CASE T.absence[11] WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' ELSE CASE WHEN T.otp_plan[11] = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 11) <= CURRENT_DATE THEN CASE WHEN T.h_plan[11] is not null THEN CASE WHEN T.h_hand[11] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[11]::TEXT||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 110; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[11] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END::text END ELSE CASE WHEN T.h_plan[11] is not null THEN '<div style="background-color:'||(SELECT 'darkgrey' FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' END END END END ELSE CASE WHEN T.h_hand[11] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[11]::TEXT||'</div></div> ' ELSE CASE WHEN T.h_asys[11] + interval '30 minutes' != make_time(T.h_plan[11], 0, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[11] + INTERVAL '30 minutes' )::INT )||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[11] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END END::text END END as column11,
CASE WHEN T.id_sotr is not null THEN CASE WHEN T.h_asys[12] = '00:00:00' THEN CASE T.absence[12] WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' ELSE CASE WHEN T.otp_plan[12] = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 12) <= CURRENT_DATE THEN CASE WHEN T.h_plan[12] is not null THEN CASE WHEN T.h_hand[12] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[12]::TEXT||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 120; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[12] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END::text END ELSE CASE WHEN T.h_plan[12] is not null THEN '<div style="background-color:'||(SELECT 'darkgrey' FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' END END END END ELSE CASE WHEN T.h_hand[12] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[12]::TEXT||'</div></div> ' ELSE CASE WHEN T.h_asys[12] + interval '30 minutes' != make_time(T.h_plan[12], 0, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[12] + INTERVAL '30 minutes' )::INT )||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[12] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END END::text END END as column12,
CASE WHEN T.id_sotr is not null THEN CASE WHEN T.h_asys[13] = '00:00:00' THEN CASE T.absence[13] WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' ELSE CASE WHEN T.otp_plan[13] = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 13) <= CURRENT_DATE THEN CASE WHEN T.h_plan[13] is not null THEN CASE WHEN T.h_hand[13] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[13]::TEXT||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 130; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[13] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END::text END ELSE CASE WHEN T.h_plan[13] is not null THEN '<div style="background-color:'||(SELECT 'darkgrey' FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' END END END END ELSE CASE WHEN T.h_hand[13] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[13]::TEXT||'</div></div> ' ELSE CASE WHEN T.h_asys[13] + interval '30 minutes' != make_time(T.h_plan[13], 0, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[13] + INTERVAL '30 minutes' )::INT )||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[13] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END END::text END END as column13,
CASE WHEN T.id_sotr is not null THEN CASE WHEN T.h_asys[14] = '00:00:00' THEN CASE T.absence[14] WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' ELSE CASE WHEN T.otp_plan[14] = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 14) <= CURRENT_DATE THEN CASE WHEN T.h_plan[14] is not null THEN CASE WHEN T.h_hand[14] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[14]::TEXT||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 140; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[14] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END::text END ELSE CASE WHEN T.h_plan[14] is not null THEN '<div style="background-color:'||(SELECT 'darkgrey' FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' END END END END ELSE CASE WHEN T.h_hand[14] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[14]::TEXT||'</div></div> ' ELSE CASE WHEN T.h_asys[14] + interval '30 minutes' != make_time(T.h_plan[14], 0, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[14] + INTERVAL '30 minutes' )::INT )||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[14] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END END::text END END as column14,
CASE WHEN T.id_sotr is not null THEN CASE WHEN T.h_asys[15] = '00:00:00' THEN CASE T.absence[15] WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' ELSE CASE WHEN T.otp_plan[15] = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 15) <= CURRENT_DATE THEN CASE WHEN T.h_plan[15] is not null THEN CASE WHEN T.h_hand[15] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[15]::TEXT||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 150; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[15] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END::text END ELSE CASE WHEN T.h_plan[15] is not null THEN '<div style="background-color:'||(SELECT 'darkgrey' FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' END END END END ELSE CASE WHEN T.h_hand[15] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[15]::TEXT||'</div></div> ' ELSE CASE WHEN T.h_asys[15] + interval '30 minutes' != make_time(T.h_plan[15], 0, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[15] + INTERVAL '30 minutes' )::INT )||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[15] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END END::text END END as column15,
CASE WHEN T.id_sotr is not null THEN CASE WHEN T.h_asys[16] = '00:00:00' THEN CASE T.absence[16] WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' ELSE CASE WHEN T.otp_plan[16] = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 16) <= CURRENT_DATE THEN CASE WHEN T.h_plan[16] is not null THEN CASE WHEN T.h_hand[16] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[16]::TEXT||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 160; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[16] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END::text END ELSE CASE WHEN T.h_plan[16] is not null THEN '<div style="background-color:'||(SELECT 'darkgrey' FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' END END END END ELSE CASE WHEN T.h_hand[16] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[16]::TEXT||'</div></div> ' ELSE CASE WHEN T.h_asys[16] + interval '30 minutes' != make_time(T.h_plan[16], 0, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[16] + INTERVAL '30 minutes' )::INT )||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[16] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END END::text END END as column16,
CASE WHEN T.id_sotr is not null THEN CASE WHEN T.h_asys[17] = '00:00:00' THEN CASE T.absence[17] WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' ELSE CASE WHEN T.otp_plan[17] = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 17) <= CURRENT_DATE THEN CASE WHEN T.h_plan[17] is not null THEN CASE WHEN T.h_hand[17] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[17]::TEXT||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 170; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[17] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END::text END ELSE CASE WHEN T.h_plan[17] is not null THEN '<div style="background-color:'||(SELECT 'darkgrey' FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' END END END END ELSE CASE WHEN T.h_hand[17] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[17]::TEXT||'</div></div> ' ELSE CASE WHEN T.h_asys[17] + interval '30 minutes' != make_time(T.h_plan[17], 0, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[17] + INTERVAL '30 minutes' )::INT )||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[17] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END END::text END END as column17,
CASE WHEN T.id_sotr is not null THEN CASE WHEN T.h_asys[18] = '00:00:00' THEN CASE T.absence[18] WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' ELSE CASE WHEN T.otp_plan[18] = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 18) <= CURRENT_DATE THEN CASE WHEN T.h_plan[18] is not null THEN CASE WHEN T.h_hand[18] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[18]::TEXT||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 180; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[18] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END::text END ELSE CASE WHEN T.h_plan[18] is not null THEN '<div style="background-color:'||(SELECT 'darkgrey' FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' END END END END ELSE CASE WHEN T.h_hand[18] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[18]::TEXT||'</div></div> ' ELSE CASE WHEN T.h_asys[18] + interval '30 minutes' != make_time(T.h_plan[18], 0, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[18] + INTERVAL '30 minutes' )::INT )||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[18] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END END::text END END as column18,
CASE WHEN T.id_sotr is not null THEN CASE WHEN T.h_asys[19] = '00:00:00' THEN CASE T.absence[19] WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' ELSE CASE WHEN T.otp_plan[19] = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 19) <= CURRENT_DATE THEN CASE WHEN T.h_plan[19] is not null THEN CASE WHEN T.h_hand[19] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[19]::TEXT||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 190; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[19] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END::text END ELSE CASE WHEN T.h_plan[19] is not null THEN '<div style="background-color:'||(SELECT 'darkgrey' FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' END END END END ELSE CASE WHEN T.h_hand[19] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[19]::TEXT||'</div></div> ' ELSE CASE WHEN T.h_asys[19] + interval '30 minutes' != make_time(T.h_plan[19], 0, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[19] + INTERVAL '30 minutes' )::INT )||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[19] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END END::text END END as column19,
CASE WHEN T.id_sotr is not null THEN CASE WHEN T.h_asys[20] = '00:00:00' THEN CASE T.absence[20] WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' ELSE CASE WHEN T.otp_plan[20] = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 20) <= CURRENT_DATE THEN CASE WHEN T.h_plan[20] is not null THEN CASE WHEN T.h_hand[20] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[20]::TEXT||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 200; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[20] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END::text END ELSE CASE WHEN T.h_plan[20] is not null THEN '<div style="background-color:'||(SELECT 'darkgrey' FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' END END END END ELSE CASE WHEN T.h_hand[20] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[20]::TEXT||'</div></div> ' ELSE CASE WHEN T.h_asys[20] + interval '30 minutes' != make_time(T.h_plan[20], 0, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[20] + INTERVAL '30 minutes' )::INT )||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[20] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END END::text END END as column20,
CASE WHEN T.id_sotr is not null THEN CASE WHEN T.h_asys[21] = '00:00:00' THEN CASE T.absence[21] WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' ELSE CASE WHEN T.otp_plan[21] = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 21) <= CURRENT_DATE THEN CASE WHEN T.h_plan[21] is not null THEN CASE WHEN T.h_hand[21] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[21]::TEXT||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 210; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[21] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END::text END ELSE CASE WHEN T.h_plan[21] is not null THEN '<div style="background-color:'||(SELECT 'darkgrey' FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' END END END END ELSE CASE WHEN T.h_hand[21] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[21]::TEXT||'</div></div> ' ELSE CASE WHEN T.h_asys[21] + interval '30 minutes' != make_time(T.h_plan[21], 0, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[21] + INTERVAL '30 minutes' )::INT )||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[21] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END END::text END END as column21,
CASE WHEN T.id_sotr is not null THEN CASE WHEN T.h_asys[22] = '00:00:00' THEN CASE T.absence[22] WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' ELSE CASE WHEN T.otp_plan[22] = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 22) <= CURRENT_DATE THEN CASE WHEN T.h_plan[22] is not null THEN CASE WHEN T.h_hand[22] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[22]::TEXT||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 220; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[22] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END::text END ELSE CASE WHEN T.h_plan[22] is not null THEN '<div style="background-color:'||(SELECT 'darkgrey' FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' END END END END ELSE CASE WHEN T.h_hand[22] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[22]::TEXT||'</div></div> ' ELSE CASE WHEN T.h_asys[22] + interval '30 minutes' != make_time(T.h_plan[22], 0, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[22] + INTERVAL '30 minutes' )::INT )||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[22] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END END::text END END as column22,
CASE WHEN T.id_sotr is not null THEN CASE WHEN T.h_asys[23] = '00:00:00' THEN CASE T.absence[23] WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' ELSE CASE WHEN T.otp_plan[23] = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 23) <= CURRENT_DATE THEN CASE WHEN T.h_plan[23] is not null THEN CASE WHEN T.h_hand[23] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[23]::TEXT||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 230; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[23] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END::text END ELSE CASE WHEN T.h_plan[23] is not null THEN '<div style="background-color:'||(SELECT 'darkgrey' FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' END END END END ELSE CASE WHEN T.h_hand[23] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[23]::TEXT||'</div></div> ' ELSE CASE WHEN T.h_asys[23] + interval '30 minutes' != make_time(T.h_plan[23], 0, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[23] + INTERVAL '30 minutes' )::INT )||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[23] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END END::text END END as column23,
CASE WHEN T.id_sotr is not null THEN CASE WHEN T.h_asys[24] = '00:00:00' THEN CASE T.absence[24] WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' ELSE CASE WHEN T.otp_plan[24] = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 24) <= CURRENT_DATE THEN CASE WHEN T.h_plan[24] is not null THEN CASE WHEN T.h_hand[24] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[24]::TEXT||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 240; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[24] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END::text END ELSE CASE WHEN T.h_plan[24] is not null THEN '<div style="background-color:'||(SELECT 'darkgrey' FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' END END END END ELSE CASE WHEN T.h_hand[24] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[24]::TEXT||'</div></div> ' ELSE CASE WHEN T.h_asys[24] + interval '30 minutes' != make_time(T.h_plan[24], 0, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[24] + INTERVAL '30 minutes' )::INT )||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[24] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END END::text END END as column24,
CASE WHEN T.id_sotr is not null THEN CASE WHEN T.h_asys[25] = '00:00:00' THEN CASE T.absence[25] WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' ELSE CASE WHEN T.otp_plan[25] = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 25) <= CURRENT_DATE THEN CASE WHEN T.h_plan[25] is not null THEN CASE WHEN T.h_hand[25] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[25]::TEXT||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 250; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[25] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END::text END ELSE CASE WHEN T.h_plan[25] is not null THEN '<div style="background-color:'||(SELECT 'darkgrey' FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' END END END END ELSE CASE WHEN T.h_hand[25] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[25]::TEXT||'</div></div> ' ELSE CASE WHEN T.h_asys[25] + interval '30 minutes' != make_time(T.h_plan[25], 0, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[25] + INTERVAL '30 minutes' )::INT )||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[25] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END END::text END END as column25,
CASE WHEN T.id_sotr is not null THEN CASE WHEN T.h_asys[26] = '00:00:00' THEN CASE T.absence[26] WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' ELSE CASE WHEN T.otp_plan[26] = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 26) <= CURRENT_DATE THEN CASE WHEN T.h_plan[26] is not null THEN CASE WHEN T.h_hand[26] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[26]::TEXT||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 260; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[26] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END::text END ELSE CASE WHEN T.h_plan[26] is not null THEN '<div style="background-color:'||(SELECT 'darkgrey' FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' END END END END ELSE CASE WHEN T.h_hand[26] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[26]::TEXT||'</div></div> ' ELSE CASE WHEN T.h_asys[26] + interval '30 minutes' != make_time(T.h_plan[26], 0, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[26] + INTERVAL '30 minutes' )::INT )||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[26] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END END::text END END as column26,
CASE WHEN T.id_sotr is not null THEN CASE WHEN T.h_asys[27] = '00:00:00' THEN CASE T.absence[27] WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' ELSE CASE WHEN T.otp_plan[27] = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 27) <= CURRENT_DATE THEN CASE WHEN T.h_plan[27] is not null THEN CASE WHEN T.h_hand[27] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[27]::TEXT||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 270; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[27] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END::text END ELSE CASE WHEN T.h_plan[27] is not null THEN '<div style="background-color:'||(SELECT 'darkgrey' FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' END END END END ELSE CASE WHEN T.h_hand[27] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[27]::TEXT||'</div></div> ' ELSE CASE WHEN T.h_asys[27] + interval '30 minutes' != make_time(T.h_plan[27], 0, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[27] + INTERVAL '30 minutes' )::INT )||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[27] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END END::text END END as column27,
CASE WHEN T.id_sotr is not null THEN CASE WHEN T.h_asys[28] = '00:00:00' THEN CASE T.absence[28] WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' ELSE CASE WHEN T.otp_plan[28] = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 28) <= CURRENT_DATE THEN CASE WHEN T.h_plan[28] is not null THEN CASE WHEN T.h_hand[28] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[28]::TEXT||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 280; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[28] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END::text END ELSE CASE WHEN T.h_plan[28] is not null THEN '<div style="background-color:'||(SELECT 'darkgrey' FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' END END END END ELSE CASE WHEN T.h_hand[28] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[28]::TEXT||'</div></div> ' ELSE CASE WHEN T.h_asys[28] + interval '30 minutes' != make_time(T.h_plan[28], 0, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[28] + INTERVAL '30 minutes' )::INT )||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[28] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END END::text END END as column28,
CASE WHEN EXTRACT(DAY FROM (SELECT ldm_tab FROM vars)) >= 29 AND T.id_sotr is not null THEN CASE WHEN T.h_asys[29] = '00:00:00' THEN CASE T.absence[29] WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' ELSE CASE WHEN T.otp_plan[29] = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 29) <= CURRENT_DATE THEN CASE WHEN T.h_plan[29] is not null THEN CASE WHEN T.h_hand[29] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[29]::TEXT||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 290; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[29] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END::text END ELSE CASE WHEN T.h_plan[29] is not null THEN '<div style="background-color:'||(SELECT 'darkgrey' FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' END END END END ELSE CASE WHEN T.h_hand[29] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[29]::TEXT||'</div></div> ' ELSE CASE WHEN T.h_asys[29] + interval '30 minutes' != make_time(T.h_plan[29], 0, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[29] + INTERVAL '30 minutes' )::INT )||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[29] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END END::text END END as column29,
CASE WHEN EXTRACT(DAY FROM (SELECT ldm_tab FROM vars)) >= 30 AND T.id_sotr is not null THEN CASE WHEN T.h_asys[30] = '00:00:00' THEN CASE T.absence[30] WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' ELSE CASE WHEN T.otp_plan[30] = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 30) <= CURRENT_DATE THEN CASE WHEN T.h_plan[30] is not null THEN CASE WHEN T.h_hand[30] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[30]::TEXT||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 300; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[30] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END::text END ELSE CASE WHEN T.h_plan[30] is not null THEN '<div style="background-color:'||(SELECT 'darkgrey' FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' END END END END ELSE CASE WHEN T.h_hand[30] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[30]::TEXT||'</div></div> ' ELSE CASE WHEN T.h_asys[30] + interval '30 minutes' != make_time(T.h_plan[30], 0, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[30] + INTERVAL '30 minutes' )::INT )||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[30] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END END::text END END as column30,
CASE WHEN EXTRACT(DAY FROM (SELECT ldm_tab FROM vars)) >= 31 AND T.id_sotr is not null THEN CASE WHEN T.h_asys[31] = '00:00:00' THEN CASE T.absence[31] WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' ELSE CASE WHEN T.otp_plan[31] = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 31) <= CURRENT_DATE THEN CASE WHEN T.h_plan[31] is not null THEN CASE WHEN T.h_hand[31] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[31]::TEXT||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 310; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[31] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END::text END ELSE CASE WHEN T.h_plan[31] is not null THEN '<div style="background-color:'||(SELECT 'darkgrey' FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' END END END END ELSE CASE WHEN T.h_hand[31] is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||T.h_hand[31]::TEXT||'</div></div> ' ELSE CASE WHEN T.h_asys[31] + interval '30 minutes' != make_time(T.h_plan[31], 0, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[31] + INTERVAL '30 minutes' )::INT )||'</div></div> ' ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||FLOOR( EXTRACT( HOUR FROM T.h_asys[31] + INTERVAL '30 minutes' )::INT )||'</div></div> ' END END::text END END as column31

from T
WHERE T.first_column is not null

WITH 
/*таблица переменных*/
vars AS ( SELECT 
     {division}::int as "division",
     {employee}::int as "employee",
     {period}::date as "period",
     (SELECT o.attr_1815_ FROM registry.object_15_ o WHERE o.id = {user}) as "subdivs",
     EXTRACT(MONTH FROM {period}::date)::int as "month_tab",
     EXTRACT(YEAR FROM {period}::date)::int as "year_tab",
     date_trunc('month', {period}::date) as fdm_tab,
     date_trunc('month', {period}::date) + INTERVAL '1 MONTH - 1 day' as ldm_tab,
     'RGB(0 255 0 / 0)' AS "c_notwork",
     'RGB(60 179 113 / 0.25)' AS "c_work",
     'RGB(0 191 255 / 0.25)' AS "c_hand", --DeepSkyBlue
     /*'RGB(177 38 41 / 0.25)' AS "c_alert",*/
     'RGB(255 0 0 / 0.25)' AS "c_alert", --Red
     /*'RGB(220 20 60 / 0.25)' AS "c_alert", --Crimson*/
     'RGB(255 255 0 / 0.25)' AS "c_vacation",
     'RGB(255 165 0 / 0.25)' AS "c_absence",
     'RGB(105 105 105 / 0.25)' AS "c_holiday" --DimGrey
     /*'RGB(65 105 225 / 0.25)' AS "c_holiday" --RoyalBlue*/        
     /*'RGB(255 238 208 / 1)' AS "c_holiday" --цвет шапки*/    
), 
/*базовая таблица табеля с суммами часов*/
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
          EXTRACT(DAY FROM days) AS "day_tab",
          NULL AS "h_plan",
          NULL AS "h_hand",
          NULL AS "h_asys",
          NULL AS "otp_plan",
          NULL AS "absence",
days AS "date_period",
holidays.id AS "holyday"
FROM generate_series((SELECT fdm_tab FROM vars), (SELECT ldm_tab FROM vars), '1 day') days
LEFT JOIN registry.object_757_ holidays ON holidays.attr_789_ = days AND NOT holidays.is_deleted

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
                    WHEN (SELECT division FROM vars) IS NOT NULL THEN CASE
                              WHEN division.id = (SELECT division FROM vars) THEN TRUE
                              ELSE FALSE
                    END
                    ELSE CASE
                              WHEN ARRAY[division.id] && (SELECT subdivs FROM vars) THEN TRUE

                              ELSE FALSE
                    END
          END
      AND CASE
                    WHEN (
                       SELECT employee
                         FROM vars
                    )::INT IS NOT NULL THEN CASE
                              WHEN o.id = (
                                 SELECT employee
                                   FROM vars
                              )::INT THEN TRUE
                              ELSE FALSE
                    END
                    ELSE TRUE
          END
      AND CASE
                    WHEN DATE_TRUNC('month', tabel.attr_1776_::date) = DATE_TRUNC(
                    'month',
                    (
                       SELECT period
                         FROM vars
                    )
                    ) THEN TRUE
                    ELSE FALSE
          END
			ORDER BY id_sotr, id_tab
),
base_tab AS (
SELECT 
source_tab.*,

CASE
          WHEN source_tab.id_sotr = 0 THEN '<div style="background-color:' || CASE
                    WHEN source_tab.holyday IS NOT NULL THEN (
                       SELECT c_holiday
                         FROM vars
                    )
          END || '; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">' || TO_CHAR(source_tab.date_period, 'TMDy') || '</div></div> '
          ELSE CASE
                    WHEN source_tab.h_asys = '00:00:00' THEN CASE source_tab.absence
                              WHEN 1 THEN '<div style="background-color:' || (
                                 SELECT c_absence
                                   FROM vars
                              ) || '; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">' || 'О' || '</div></div> '
                              WHEN 4 THEN '<div style="background-color:' || (
                                 SELECT c_absence
                                   FROM vars
                              ) || '; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">' || 'О' || '</div></div> '
                              WHEN 5 THEN '<div style="background-color:' || (
                                 SELECT c_absence
                                   FROM vars
                              ) || '; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">' || 'О' || '</div></div> '
                              WHEN 2 THEN '<div style="background-color:' || (
                                 SELECT c_absence
                                   FROM vars
                              ) || '; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">' || 'А' || '</div></div> '
                              WHEN 3 THEN '<div style="background-color:' || (
                                 SELECT c_absence
                                   FROM vars
                              ) || '; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">' || 'Б' || '</div></div> '
                              ELSE CASE
                                        WHEN source_tab.otp_plan = 1 THEN '<div style="background-color:' || (
                                           SELECT c_vacation
                                             FROM vars
                                        ) || '; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">' || 'Оп' || '</div></div> '
                                        ELSE CASE
                                                  WHEN MAKE_DATE(
                                                  (
                                                     SELECT year_tab
                                                       FROM vars
                                                  ),
                                                  (
                                                     SELECT month_tab
                                                       FROM vars
                                                  ),
                                                  source_tab.day_tab::INT
                                                  ) <= CURRENT_DATE THEN CASE
                                                            WHEN source_tab.h_plan IS NOT NULL THEN CASE
                                                                      WHEN source_tab.h_hand IS NOT NULL THEN '<div style="background-color:' || (
                                                                         SELECT c_hand
                                                                           FROM vars
                                                                      ) || '; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">' || source_tab.h_hand::TEXT || '</div></div> '
                                                                      ELSE '<div style="background-color:' || (
                                                                         SELECT c_alert
                                                                           FROM vars
                                                                      ) || '; height: 25px;"><div style="font-weight: 460; padding: 0px 5px;">' || FLOOR(
                                                                      EXTRACT(
                                                                      HOUR
                                                                           FROM source_tab.h_asys + INTERVAL '30 minutes'
                                                                      )::INT
                                                                      ) || '</div></div> '
                                                            END::TEXT
                                                  END
                                                  ELSE CASE
                                                            WHEN source_tab.h_plan IS NOT NULL THEN '<div style="background-color:' || (
                                                               SELECT c_work
                                                                 FROM vars
                                                            ) || '; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">' || 'Д' || '</div></div> '
                                                            ELSE '<div style="background-color:' || (
                                                               SELECT c_notwork
                                                                 FROM vars
                                                            ) || '; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">' || '' || '</div></div> '
                                                  END
                                        END
                              END
                    END
                    ELSE CASE
                              WHEN source_tab.h_hand IS NOT NULL THEN '<div style="background-color:' || (
                                 SELECT c_hand
                                   FROM vars
                              ) || '; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">' || source_tab.h_hand::TEXT || '</div></div> '
                              ELSE CASE
                                        WHEN source_tab.h_asys + INTERVAL '30 minutes' != MAKE_TIME(source_tab.h_plan, 0, 0) THEN '<div style="background-color:' || (
                                           SELECT c_alert
                                             FROM vars
                                        ) || '; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">' || FLOOR(
                                        EXTRACT(
                                        HOUR
                                             FROM source_tab.h_asys + INTERVAL '30 minutes'
                                        )::INT
                                        ) || '</div></div> '
                                        ELSE '<div style="background-color:' || (
                                           SELECT c_work
                                             FROM vars
                                        ) || '; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">' || FLOOR(
                                        EXTRACT(
                                        HOUR
                                             FROM source_tab.h_asys + INTERVAL '30 minutes'
                                        )::INT
                                        ) || '</div></div> '
                              END
                    END::TEXT
          END
END AS "html",
          SUM( source_tab.h_plan) OVER ( PARTITION BY source_tab.id_sotr ) AS "sum_plan",
          SUM( COALESCE( source_tab.h_hand, FLOOR( EXTRACT( HOUR FROM source_tab.h_asys + INTERVAL '30 minutes' )::INT ) ) ) OVER ( PARTITION BY source_tab.id_sotr ) AS "sum_fact",
          SUM( source_tab.h_plan ) OVER ( PARTITION BY source_tab.name_brigade ) AS "sum_br_plan",
          SUM( COALESCE( source_tab.h_hand, FLOOR( EXTRACT( HOUR FROM source_tab.h_asys + INTERVAL '30 minutes' )::INT ) ) ) OVER ( PARTITION BY source_tab.name_brigade ) AS "sum_br_fact",
          SUM( source_tab.h_plan ) OVER ( PARTITION BY source_tab.name_div ) AS "sum_div_plan",
          SUM( COALESCE( source_tab.h_hand, FLOOR( EXTRACT( HOUR FROM source_tab.h_asys + INTERVAL '30 minutes' )::INT ) ) ) OVER ( PARTITION BY source_tab.name_div ) AS "sum_div_fact"
FROM source_tab
),

/*табель*/
T AS (
   SELECT distinct
	 base_tab.object_tab,
base_tab.card_tab,
base_tab.object_sotr,
base_tab.card_sotr,
base_tab.id_sotr,
base_tab.fio_sotr,
					
CASE 
WHEN base_tab.id_sotr = 0 THEN '' 
WHEN base_tab.id_sotr is not NULL THEN base_tab.fio_sotr 
WHEN base_tab.name_brigade is not NULL THEN 'Итого '||base_tab.name_brigade||' --->' 
WHEN base_tab.name_div is not NULL THEN 'Итого '||base_tab.name_div||' --->' 
END as "first_column", 
          base_tab.name_post,
          base_tab.name_div,
          base_tab.id_div,
          base_tab.name_brigade,
CASE 
WHEN base_tab.id_sotr is not NULL THEN MAX (base_tab.sum_plan) 
WHEN base_tab.name_brigade is not NULL THEN MAX (base_tab.sum_br_plan) 
ELSE MAX (base_tab.sum_div_plan)
END as sum_plan,

CASE 
WHEN base_tab.id_sotr is not NULL THEN MAX (base_tab.sum_fact)
WHEN base_tab.name_brigade is not NULL THEN MAX (base_tab.sum_br_fact)
ELSE MAX (base_tab.sum_div_fact)
END as sum_fact,

CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 1 THEN base_tab.id_tab END) END as id_tab1,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 2 THEN base_tab.id_tab END) END as id_tab2,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 3 THEN base_tab.id_tab END) END as id_tab3,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 4 THEN base_tab.id_tab END) END as id_tab4,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 5 THEN base_tab.id_tab END) END as id_tab5,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 6 THEN base_tab.id_tab END) END as id_tab6,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 7 THEN base_tab.id_tab END) END as id_tab7,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 8 THEN base_tab.id_tab END) END as id_tab8,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 9 THEN base_tab.id_tab END) END as id_tab9,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 10 THEN base_tab.id_tab END) END as id_tab10,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 11 THEN base_tab.id_tab END) END as id_tab11,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 12 THEN base_tab.id_tab END) END as id_tab12,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 13 THEN base_tab.id_tab END) END as id_tab13,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 14 THEN base_tab.id_tab END) END as id_tab14,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 15 THEN base_tab.id_tab END) END as id_tab15,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 16 THEN base_tab.id_tab END) END as id_tab16,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 17 THEN base_tab.id_tab END) END as id_tab17,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 18 THEN base_tab.id_tab END) END as id_tab18,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 19 THEN base_tab.id_tab END) END as id_tab19,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 20 THEN base_tab.id_tab END) END as id_tab20,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 21 THEN base_tab.id_tab END) END as id_tab21,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 22 THEN base_tab.id_tab END) END as id_tab22,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 23 THEN base_tab.id_tab END) END as id_tab23,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 24 THEN base_tab.id_tab END) END as id_tab24,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 25 THEN base_tab.id_tab END) END as id_tab25,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 26 THEN base_tab.id_tab END) END as id_tab26,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 27 THEN base_tab.id_tab END) END as id_tab27,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 28 THEN base_tab.id_tab END) END as id_tab28,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 29 THEN base_tab.id_tab END) END as id_tab29,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 30 THEN base_tab.id_tab END) END as id_tab30,
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 31 THEN base_tab.id_tab END) END as id_tab31,

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

select T.* FROM T 

WHERE nNOT (T.name_div = '0' AND T.id_sotr is null)