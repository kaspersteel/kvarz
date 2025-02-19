WITH 
/*таблица переменных*/
vars AS ( SELECT 
     {employee}::int as "employee",
     {period}::date as "period",
     EXTRACT(YEAR FROM {period}::date)::int as "year_tab",
     array ['Январь', 'Февраль', 'Март', 'Апрель', 'Май',	'Июнь', 'Июль',	'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'] AS month_arr,
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
SELECT
	     1774 AS "object_tab",
          223 AS "card_day",
          249 AS "card_period",
          EXTRACT(MONTH FROM tabel.attr_1776_::date)::int as "month_tab",
          o.id AS "id_sotr",
          o.attr_424_ AS "fio_sotr",
          tabel.id AS "id_tab",
		  /*информационная ячейка за период будет "Днём Зеро"*/
          CASE WHEN tabel.attr_1908_ THEN 0 ELSE EXTRACT(DAY FROM tabel.attr_1776_) END AS "day_tab",
          tabel.attr_1780_ AS "h_plan",
          tabel.attr_1816_ AS "h_hand",
          COALESCE( CASE WHEN tabel.attr_1908_ THEN null ELSE asyst.attr_1789_ END, '00:00:00' ) AS "h_asys",
          CASE WHEN gr_otp.id is not null THEN 1 END AS "otp_plan",
          absence.attr_1504_ AS "absence",
          tabel.attr_1776_ AS "date_period"
     FROM registry.object_419_ o
LEFT JOIN registry.object_1774_ tabel ON o.id = tabel.attr_1775_
      AND NOT tabel.is_deleted
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
                    WHEN ( SELECT employee FROM vars )::INT IS NOT NULL THEN 
                    CASE
                              WHEN o.id = ( SELECT employee FROM vars )::INT THEN TRUE
                              ELSE FALSE
                    END
                    ELSE TRUE
          END
      AND CASE
                    WHEN DATE_TRUNC('year', tabel.attr_1776_::date) = DATE_TRUNC( 'year', ( SELECT period FROM vars ) ) THEN TRUE
                    ELSE FALSE
          END
			ORDER BY id_tab
),
/*расчёт сумм*/
sum1_tab AS (
SELECT
source_tab.*,																								
/*отдельные суммы по сотруднику, году*/
SUM( COALESCE( source_tab.h_plan, 0) ) OVER ( PARTITION BY EXTRACT(MONTH FROM source_tab.date_period::date)::int) AS "sum_plan",
COALESCE( SUM( CASE WHEN source_tab.day_tab = 0 THEN source_tab.h_hand END) OVER ( PARTITION BY EXTRACT(MONTH FROM source_tab.date_period::date)::int),
          SUM( EXTRACT( HOUR FROM COALESCE( make_time(source_tab.h_hand, 0, 0), source_tab.h_asys) )::INT ) OVER ( PARTITION BY EXTRACT(MONTH FROM source_tab.date_period::date)::int))AS "sum_fact",
SUM( COALESCE( source_tab.h_plan, 0) ) OVER () AS "sum_plan_year"

FROM source_tab
ORDER BY id_sotr, day_tab
),
/*расчёт дополнительных сумм*/
sum2_tab AS (
SELECT
sum1_tab.*,																								
SUM( CASE WHEN sum1_tab.day_tab = 0 THEN sum1_tab.sum_fact END ) OVER () AS "sum_fact_year"

FROM sum1_tab
ORDER BY id_sotr, day_tab
),

/*базовая таблица табеля*/
base_tab AS (
SELECT 
sum2_tab.*,
/*сборка HTML-кода для ячеек таблицы*/
CASE WHEN sum2_tab.day_tab != 0 THEN
     CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), sum2_tab.day_tab::int ) <= CURRENT_DATE THEN 
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
END as "html"
FROM sum2_tab
ORDER BY id_sotr, day_tab
),
/*табель*/
T AS (
      SELECT DISTINCT 
          base_tab.object_tab,
          base_tab.card_day,
          base_tab.card_period,
          base_tab.id_sotr,
          base_tab.fio_sotr,
		base_tab.month_tab,
            /*первая колонка таблицы*/
          CASE
               WHEN base_tab.id_sotr is not NULL THEN (SELECT month_arr[base_tab.month_tab] FROM vars)
               ELSE 'Итого за '||(SELECT year_tab FROM vars) || ' --->'
          END AS "first_column",

CASE WHEN base_tab.id_sotr is not NULL THEN MAX (base_tab.sum_plan)
     ELSE MAX (base_tab.sum_plan_year) 
END as "sum_plan",
CASE WHEN base_tab.id_sotr is not NULL THEN MAX (base_tab.sum_fact)
     ELSE MAX (base_tab.sum_fact_year) 
END as "sum_fact",
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
/*формулы группировки по сотруднику, а так же году - для строки итого*/
GROUP BY 
GROUPING SETS (
(object_tab, card_day, card_period, base_tab.month_tab, base_tab.id_sotr, base_tab.fio_sotr)
, base_tab.fio_sotr
)

ORDER BY
base_tab.month_tab
)

select T.* from T 
WHERE T.fio_sotr is not null