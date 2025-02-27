WITH 
/*таблица переменных*/
vars AS ( SELECT
      /*mode - режим учёта места работы. 1 - из графика, 2 - из оргструктуры*/ 
     {mode}::int as "mode",    
     {division}::int as "division",
     {period}::date as "period",
     (    SELECT (
             SELECT ARRAY_AGG(DISTINCT divs)
               FROM UNNEST(odd_org.sub_divs || org.sub_divs) AS "divs"
          )
     FROM registry.object_15_ users
LEFT JOIN LATERAL (
             SELECT ARRAY_AGG(attr_65_) AS "sub_divs"
               FROM registry.object_36_ o
              WHERE o.ID = ANY (users.attr_1815_)
                AND NOT o.is_deleted
          ) "org" ON TRUE
LEFT JOIN LATERAL (
             SELECT ARRAY_AGG(DISTINCT odd_sub_org.attr_65_) AS "sub_divs"
               FROM registry.object_36_ odd_org
          LEFT JOIN registry.object_36_ odd_up_org ON odd_up_org.ID = odd_org.attr_1753_
                AND odd_up_org.attr_65_ != odd_org.attr_65_
                AND NOT odd_up_org.is_deleted
          LEFT JOIN registry.object_15_ odd_users ON odd_users.attr_506_ = odd_org.attr_285_
                AND NOT odd_users.is_deleted
          LEFT JOIN registry.object_36_ odd_sub_org ON odd_sub_org.ID = ANY (odd_users.attr_1815_)
                AND NOT odd_sub_org.is_deleted
              WHERE odd_org.attr_65_ = ANY (users.attr_1914_)
                AND NOT odd_org.is_deleted
                AND odd_up_org.id IS NOT NULL
          ) "odd_org" ON TRUE
    WHERE users.id = {user}::INT) as "subdivs",
     EXTRACT(MONTH FROM {period}::date)::int as "month_tab",
     EXTRACT(YEAR FROM {period}::date)::int as "year_tab",
     date_trunc('month', {period}::date) as fdm_tab,
     date_trunc('month', {period}::date) + INTERVAL '1 MONTH - 1 day' as ldm_tab,
     'RGBA(0, 255, 0, 0)' AS "c_notwork",
     'RGBA(60, 179, 113, 0.25)' AS "c_work",
     'RGBA(0, 102, 255, 0.4)' AS "c_hand",
     'RGBA(220, 38, 41, 0.25)' AS "c_alert",
     'RGBA(255, 255, 0, 0.25)' AS "c_vacation",
     'RGBA(255, 165, 0, 0.25)' AS "c_absence",
     'RGBA(105, 105, 105, 0.25)' AS "c_holiday"
), 
/*исходная таблица табеля*/
source_tab AS (
/*заготовка под строку дней недели*/
     SELECT NULL AS "object_tab",
          NULL AS "card_day",
          NULL AS "card_period",
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
          223 AS "card_day",
          249 AS "card_period",
          419 AS "object_sotr",
          222 AS "card_sotr",
          o.id AS "id_sotr",
          o.attr_424_ AS "fio_sotr",
          post.attr_504_ AS "name_post",
          division.attr_1545_ AS "name_div",
          division.id AS "id_div",
          brigade.attr_1793_ AS "name_brigade",
          tabel.id AS "id_tab",
		  /*информационная ячейка за период будет "Днём Зеро"*/
          CASE WHEN tabel.attr_1908_ THEN 0 ELSE EXTRACT(DAY FROM tabel.attr_1776_) END AS "day_tab",
          tabel.attr_1780_ AS "h_plan",
          tabel.attr_1816_ AS "h_hand",
          COALESCE( CASE WHEN tabel.attr_1908_ THEN null ELSE asyst.attr_1789_ END, '00:00:00' ) AS "h_asys",
          CASE WHEN gr_otp.id is not null THEN 1 END AS "otp_plan",
          absence.attr_1504_ AS "absence",
          NULL AS "date_period",
          NULL AS "holyday"
     FROM registry.object_419_ o
LEFT JOIN registry.object_1774_ tabel ON o.id = tabel.attr_1775_
      AND NOT tabel.is_deleted
LEFT JOIN registry.object_503_ post ON o.attr_505_ = post.id
      AND NOT post.is_deleted
LEFT JOIN registry.object_1544_ division ON CASE WHEN (SELECT mode FROM vars) = 1 THEN tabel.attr_1817_ WHEN (SELECT mode FROM vars) = 2 THEN o.attr_1546_ END = division.id
      AND NOT division.is_deleted
LEFT JOIN registry.object_1790_ brigade ON CASE WHEN (SELECT mode FROM vars) = 1 THEN tabel.attr_1818_ WHEN (SELECT mode FROM vars) = 2 THEN o.attr_1804_ END = brigade.id
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
                    WHEN (SELECT division FROM vars) IS NOT NULL THEN 
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
			ORDER BY id_sotr, day_tab
),
/*расчёт сумм*/
sum1_tab AS (
SELECT
source_tab.*,																								
/*отдельные суммы по сотруднику, бригаде, подразделению*/
CASE WHEN source_tab.id_sotr != 0 THEN SUM( COALESCE( source_tab.h_plan, 0) ) OVER ( PARTITION BY source_tab.id_sotr, source_tab.name_div, source_tab.name_brigade ) END AS "sum_plan",
CASE WHEN source_tab.id_sotr != 0 
     THEN COALESCE( SUM( CASE WHEN source_tab.day_tab = 0 THEN source_tab.h_hand END) OVER ( PARTITION BY source_tab.id_sotr, source_tab.name_div, source_tab.name_brigade ) , 
                    SUM( COALESCE( source_tab.h_hand, EXTRACT( HOUR FROM source_tab.h_asys ) )::INT ) OVER ( PARTITION BY source_tab.id_sotr, source_tab.name_div, source_tab.name_brigade ) ) 
END AS "sum_fact",
SUM( COALESCE( source_tab.h_plan, 0) ) OVER ( PARTITION BY source_tab.name_brigade ) AS "sum_br_plan",
SUM( COALESCE( source_tab.h_plan, 0) ) OVER ( PARTITION BY source_tab.name_div ) AS "sum_div_plan"
FROM source_tab
ORDER BY id_sotr, day_tab
),
/*расчёт дополнительных сумм*/
sum2_tab AS (
SELECT
sum1_tab.*,																								
SUM( CASE WHEN sum1_tab.day_tab = 0 THEN sum1_tab.sum_fact END ) OVER ( PARTITION BY sum1_tab.name_brigade )  AS "sum_br_fact",
SUM( CASE WHEN sum1_tab.day_tab = 0 THEN sum1_tab.sum_fact END ) OVER ( PARTITION BY sum1_tab.name_div )  AS "sum_div_fact"

FROM sum1_tab
ORDER BY id_sotr, day_tab
),

/*базовая таблица табеля*/
base_tab AS (
SELECT 
sum2_tab.*,
/*сборка HTML-кода для ячеек таблицы*/
CASE WHEN sum2_tab.day_tab != 0 THEN
CASE WHEN sum2_tab.id_sotr = 0 THEN '<div style="background-color:'||CASE WHEN sum2_tab.holyday is not null THEN (SELECT c_holiday FROM vars) ELSE 'RGB(0 255 0 / 0)' END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(sum2_tab.date_period, 'TMDy')||'</div></div> ' 
     ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), sum2_tab.day_tab::int ) <= CURRENT_DATE THEN 
               CASE WHEN sum2_tab.h_hand is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||sum2_tab.h_hand::TEXT||'</div></div> ' 
                    ELSE CASE WHEN sum2_tab.h_asys = '00:00:00'::time THEN 
  					CASE sum2_tab.absence 
                                   WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' 
                                   WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' 
                                   WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' 
                                   WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' 
                                   WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' 
                                   ELSE CASE WHEN sum2_tab.otp_plan = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' 
                                             ELSE CASE WHEN sum2_tab.h_plan is not null THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'|| EXTRACT( HOUR FROM sum2_tab.h_asys + INTERVAL '30 minutes' )::INT ||'</div></div> ' 
  								       ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' 
  							        END
                                        END 
                              END 
                              ELSE CASE WHEN sum2_tab.absence is not null OR sum2_tab.otp_plan is not null THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'|| EXTRACT( HOUR FROM sum2_tab.h_asys + INTERVAL '30 minutes' )::INT ||'</div></div> '
                                        ELSE CASE WHEN EXTRACT( HOUR FROM sum2_tab.h_asys + INTERVAL '30 minutes' )::INT != COALESCE( sum2_tab.h_plan, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'|| EXTRACT( HOUR FROM sum2_tab.h_asys + INTERVAL '30 minutes' )::INT ||'</div></div> ' 
                                   		        ELSE  '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'|| EXTRACT( HOUR FROM sum2_tab.h_asys + INTERVAL '30 minutes' )::INT ||'</div></div> ' 
  							   END
                                   END
                         END 
               END
               ELSE CASE sum2_tab.absence 
                         WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' 
                         WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' 
                         WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' 
                         WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' 
                         WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' 
                         ELSE CASE WHEN sum2_tab.otp_plan = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' 
                                   ELSE CASE WHEN sum2_tab.h_plan is null THEN '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' 
                                             ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' 
                                        END
                              END 
                    END 
          END
END END as "html"
FROM sum2_tab
ORDER BY id_sotr, day_tab
),

/*табель*/
T AS (
   SELECT DISTINCT base_tab.object_tab,
          base_tab.card_day,
          base_tab.card_period,
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
          /*array_agg (base_tab.h_plan ORDER BY base_tab.day_tab) "arr_plan", 
          array_agg (base_tab.h_asys ORDER BY base_tab.day_tab) "arr_asys", отладочная информация*/
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
          CASE
                    WHEN base_tab.id_sotr != 0 THEN MAX(
                    CASE
                              WHEN base_tab.day_tab = 0 THEN CASE
                                                                  WHEN base_tab.h_hand IS NOT NULL THEN ( SELECT c_hand FROM vars )
                                                                  ELSE ( SELECT c_notwork FROM vars )
                                                             END
                    END )
          ELSE ( SELECT c_notwork FROM vars )
END AS "sum_fact_color",
/*поколоночный вывод ID записей в реестре табеля*/
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 0 THEN base_tab.id_tab END) END as "id_period",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 1 THEN base_tab.id_tab END) END as "id_day1",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 2 THEN base_tab.id_tab END) END as "id_day2",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 3 THEN base_tab.id_tab END) END as "id_day3",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 4 THEN base_tab.id_tab END) END as "id_day4",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 5 THEN base_tab.id_tab END) END as "id_day5",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 6 THEN base_tab.id_tab END) END as "id_day6",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 7 THEN base_tab.id_tab END) END as "id_day7",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 8 THEN base_tab.id_tab END) END as "id_day8",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 9 THEN base_tab.id_tab END) END as "id_day9",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 10 THEN base_tab.id_tab END) END as "id_day10",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 11 THEN base_tab.id_tab END) END as "id_day11",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 12 THEN base_tab.id_tab END) END as "id_day12",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 13 THEN base_tab.id_tab END) END as "id_day13",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 14 THEN base_tab.id_tab END) END as "id_day14",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 15 THEN base_tab.id_tab END) END as "id_day15",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 16 THEN base_tab.id_tab END) END as "id_day16",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 17 THEN base_tab.id_tab END) END as "id_day17",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 18 THEN base_tab.id_tab END) END as "id_day18",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 19 THEN base_tab.id_tab END) END as "id_day19",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 20 THEN base_tab.id_tab END) END as "id_day20",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 21 THEN base_tab.id_tab END) END as "id_day21",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 22 THEN base_tab.id_tab END) END as "id_day22",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 23 THEN base_tab.id_tab END) END as "id_day23",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 24 THEN base_tab.id_tab END) END as "id_day24",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 25 THEN base_tab.id_tab END) END as "id_day25",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 26 THEN base_tab.id_tab END) END as "id_day26",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 27 THEN base_tab.id_tab END) END as "id_day27",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 28 THEN base_tab.id_tab END) END as "id_day28",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 29 THEN base_tab.id_tab END) END as "id_day29",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 30 THEN base_tab.id_tab END) END as "id_day30",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 31 THEN base_tab.id_tab END) END as "id_day31",
/*поколоночный вывод HTML-кода в ячейки*/
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 1 THEN base_tab.html END) END as "column1",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 2 THEN base_tab.html END) END as "column2",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 3 THEN base_tab.html END) END as "column3",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 4 THEN base_tab.html END) END as "column4",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 5 THEN base_tab.html END) END as "column5",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 6 THEN base_tab.html END) END as "column6",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 7 THEN base_tab.html END) END as "column7",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 8 THEN base_tab.html END) END as "column8",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 9 THEN base_tab.html END) END as "column9",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 10 THEN base_tab.html END) END as "column10",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 11 THEN base_tab.html END) END as "column11",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 12 THEN base_tab.html END) END as "column12",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 13 THEN base_tab.html END) END as "column13",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 14 THEN base_tab.html END) END as "column14",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 15 THEN base_tab.html END) END as "column15",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 16 THEN base_tab.html END) END as "column16",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 17 THEN base_tab.html END) END as "column17",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 18 THEN base_tab.html END) END as "column18",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 19 THEN base_tab.html END) END as "column19",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 20 THEN base_tab.html END) END as "column20",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 21 THEN base_tab.html END) END as "column21",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 22 THEN base_tab.html END) END as "column22",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 23 THEN base_tab.html END) END as "column23",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 24 THEN base_tab.html END) END as "column24",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 25 THEN base_tab.html END) END as "column25",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 26 THEN base_tab.html END) END as "column26",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 27 THEN base_tab.html END) END as "column27",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 28 THEN base_tab.html END) END as "column28",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 29 THEN base_tab.html END) END as "column29",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 30 THEN base_tab.html END) END as "column30",
CASE WHEN base_tab.id_sotr is not null THEN MAX (CASE WHEN base_tab.day_tab = 31 THEN base_tab.html END) END as "column31"
						
FROM base_tab
/*формулы группировки по сотруднику, а так же бригаде и подразделению - для строк итого*/
GROUP BY 
GROUPING SETS (
(object_tab, card_day, card_period, object_sotr, card_sotr, base_tab.id_sotr, base_tab.fio_sotr, base_tab.id_div, base_tab.name_div, base_tab.name_post, base_tab.name_brigade)
, (base_tab.name_brigade, base_tab.name_div)
, base_tab.name_div
)

ORDER BY
name_div, 
name_brigade, 
fio_sotr
)

SELECT * 
FROM T 
/*убираем строку итого для строки дней*/
WHERE not (T.name_div = '0' AND T.id_sotr is null)
AND not (T.id_period is null AND T.id_sotr is not null)
/*AND T.sum_plan != 0*/