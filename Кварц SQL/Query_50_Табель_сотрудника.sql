WITH 
/*таблица переменных*/
vars AS ( SELECT 
     {employee}::int as "employee",
     {period}::date as "period",
     EXTRACT(YEAR FROM {period}::date)::int as "year_tab",
     date_trunc('year', {period}::date) as fdy_tab,
     date_trunc('year', {period}::date) + INTERVAL '1 year' as ldy_tab,
     array ['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'] AS month_arr,
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
          COALESCE( CASE WHEN tabel.attr_1908_ THEN null ELSE asyst.sum_h END, '00:00:00' ) AS "h_asys",
          CASE WHEN gr_otp.id is not null THEN 1 END AS "otp_plan",
          absence.attr_1504_ AS "absence",
          tabel.attr_1776_ AS "date_period"
     FROM registry.object_419_ o
CROSS JOIN vars
LEFT JOIN registry.object_1774_ tabel ON o.id = tabel.attr_1775_
      AND NOT tabel.is_deleted
LEFT JOIN LATERAL (
             SELECT SUM(attr_1789_) AS "sum_h"
               FROM registry.object_1785_
              WHERE o.id = attr_1786_
                AND tabel.attr_1776_ = attr_1787_::date
                AND NOT is_deleted
          ) asyst ON TRUE
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
      /*упрощённый фильтр по сотруднику*/
      AND (vars.employee IS NULL OR o.id = vars.employee)
      /*sargable фильтр по году вместо DATE_TRUNC*/
      AND tabel.attr_1776_ >= vars.fdy_tab
      AND tabel.attr_1776_ <  vars.ldy_tab
      /*ORDER BY id_tab - закомментировано для тестирования*/
),

/*базовая таблица табеля (объединяет sum1_tab, sum2_tab и base_tab)*/
base_tab AS (
SELECT 
source_tab.*,
/*отдельные суммы по месяцу и году*/
SUM( COALESCE( source_tab.h_plan, 0) ) OVER ( PARTITION BY EXTRACT(MONTH FROM source_tab.date_period::date)::int) AS "sum_plan",
COALESCE( SUM( CASE WHEN source_tab.day_tab = 0 THEN source_tab.h_hand END) OVER ( PARTITION BY EXTRACT(MONTH FROM source_tab.date_period::date)::int),
          SUM( COALESCE( source_tab.h_hand, EXTRACT( HOUR FROM source_tab.h_asys ) )::INT ) OVER ( PARTITION BY EXTRACT(MONTH FROM source_tab.date_period::date)::int)) AS "sum_fact",
/*суммы за год*/
SUM( COALESCE( source_tab.h_plan, 0) ) OVER () AS "sum_plan_year",
COALESCE( SUM( CASE WHEN source_tab.day_tab = 0 THEN source_tab.h_hand END) OVER (),
          SUM( COALESCE( source_tab.h_hand, EXTRACT( HOUR FROM source_tab.h_asys ) )::INT ) OVER ()) AS "sum_fact_year",

/*сборка HTML-кода для ячеек таблицы*/
CASE WHEN source_tab.day_tab != 0 THEN
     CASE WHEN make_date(vars.year_tab, source_tab.month_tab, source_tab.day_tab::int ) <= CURRENT_DATE THEN 
               CASE WHEN source_tab.h_hand is not null THEN '<div style="background-color:'||vars.c_hand||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||source_tab.h_hand::TEXT||'</div></div> ' 
                    ELSE CASE WHEN source_tab.h_asys = '00:00:00'::time THEN 
  					CASE source_tab.absence 
                                   WHEN 1 THEN '<div style="background-color:'||vars.c_absence||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' 
                                   WHEN 4 THEN '<div style="background-color:'||vars.c_absence||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' 
                                   WHEN 5 THEN '<div style="background-color:'||vars.c_absence||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' 
                                   WHEN 2 THEN '<div style="background-color:'||vars.c_absence||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' 
                                   WHEN 3 THEN '<div style="background-color:'||vars.c_absence||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' 
                                   ELSE CASE WHEN source_tab.otp_plan = 1 THEN '<div style="background-color:'||vars.c_vacation||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' 
                                             ELSE CASE WHEN source_tab.h_plan is not null THEN '<div style="background-color:'||vars.c_alert||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'|| EXTRACT( HOUR FROM source_tab.h_asys + INTERVAL '30 minutes' )::INT ||'</div></div> ' 
  								       ELSE '<div style="background-color:'||vars.c_notwork||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' 
  							        END
                                        END 
                              END 
                              ELSE CASE WHEN source_tab.absence is not null OR source_tab.otp_plan is not null THEN '<div style="background-color:'||vars.c_alert||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'|| EXTRACT( HOUR FROM source_tab.h_asys + INTERVAL '30 minutes' )::INT ||'</div></div> '
                                        ELSE CASE WHEN EXTRACT( HOUR FROM source_tab.h_asys + INTERVAL '30 minutes' )::INT != COALESCE( source_tab.h_plan, 0) THEN '<div style="background-color:'||vars.c_alert||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'|| EXTRACT( HOUR FROM source_tab.h_asys + INTERVAL '30 minutes' )::INT ||'</div></div> ' 
                                   		        ELSE  '<div style="background-color:'||vars.c_work||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'|| EXTRACT( HOUR FROM source_tab.h_asys + INTERVAL '30 minutes' )::INT ||'</div></div> ' 
  							   END
                                   END
                         END 
               END
               ELSE CASE source_tab.absence 
                         WHEN 1 THEN '<div style="background-color:'||vars.c_absence||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' 
                         WHEN 4 THEN '<div style="background-color:'||vars.c_absence||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' 
                         WHEN 5 THEN '<div style="background-color:'||vars.c_absence||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' 
                         WHEN 2 THEN '<div style="background-color:'||vars.c_absence||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' 
                         WHEN 3 THEN '<div style="background-color:'||vars.c_absence||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' 
                         ELSE CASE WHEN source_tab.otp_plan = 1 THEN '<div style="background-color:'||vars.c_vacation||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' 
                                   ELSE CASE WHEN source_tab.h_plan is null THEN '<div style="background-color:'||vars.c_notwork||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' 
                                             ELSE '<div style="background-color:'||vars.c_work||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' 
                                        END
                              END 
                    END 
          END
END as "html"
FROM source_tab
CROSS JOIN vars
/*ORDER BY id_sotr, day_tab - закомментировано для тестирования*/
),

/*табель*/
T AS (
      SELECT 
          base_tab.object_tab,
          base_tab.card_day,
          base_tab.card_period,
          base_tab.id_sotr,
          base_tab.fio_sotr,
          base_tab.month_tab,
          
          /*первая колонка таблицы — через GROUPING для надёжности*/
          CASE
               WHEN GROUPING(base_tab.month_tab) = 0 THEN vars.month_arr[base_tab.month_tab]
               ELSE 'Итого за ' || vars.year_tab
          END AS "first_column",

          CASE 
               WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(base_tab.sum_plan)
               ELSE MAX(base_tab.sum_plan_year) 
          END as "sum_plan",
          
          CASE 
               WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(base_tab.sum_fact)
               ELSE MAX(base_tab.sum_fact_year) 
          END as "sum_fact",
          
          CASE
               WHEN base_tab.id_sotr != 0 THEN MAX(
                    CASE
                         WHEN base_tab.day_tab = 0 THEN CASE
                              WHEN base_tab.h_hand IS NOT NULL THEN vars.c_hand
                              ELSE vars.c_notwork
                         END
                    END )
               ELSE vars.c_notwork
          END AS "sum_fact_color",
          
          /*поколоночный вывод ID записей в реестре табеля*/
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 0  THEN base_tab.id_tab END) END as "id_period",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 1  THEN base_tab.id_tab END) END as "id_day1",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 2  THEN base_tab.id_tab END) END as "id_day2",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 3  THEN base_tab.id_tab END) END as "id_day3",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 4  THEN base_tab.id_tab END) END as "id_day4",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 5  THEN base_tab.id_tab END) END as "id_day5",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 6  THEN base_tab.id_tab END) END as "id_day6",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 7  THEN base_tab.id_tab END) END as "id_day7",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 8  THEN base_tab.id_tab END) END as "id_day8",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 9  THEN base_tab.id_tab END) END as "id_day9",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 10 THEN base_tab.id_tab END) END as "id_day10",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 11 THEN base_tab.id_tab END) END as "id_day11",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 12 THEN base_tab.id_tab END) END as "id_day12",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 13 THEN base_tab.id_tab END) END as "id_day13",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 14 THEN base_tab.id_tab END) END as "id_day14",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 15 THEN base_tab.id_tab END) END as "id_day15",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 16 THEN base_tab.id_tab END) END as "id_day16",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 17 THEN base_tab.id_tab END) END as "id_day17",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 18 THEN base_tab.id_tab END) END as "id_day18",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 19 THEN base_tab.id_tab END) END as "id_day19",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 20 THEN base_tab.id_tab END) END as "id_day20",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 21 THEN base_tab.id_tab END) END as "id_day21",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 22 THEN base_tab.id_tab END) END as "id_day22",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 23 THEN base_tab.id_tab END) END as "id_day23",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 24 THEN base_tab.id_tab END) END as "id_day24",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 25 THEN base_tab.id_tab END) END as "id_day25",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 26 THEN base_tab.id_tab END) END as "id_day26",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 27 THEN base_tab.id_tab END) END as "id_day27",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 28 THEN base_tab.id_tab END) END as "id_day28",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 29 THEN base_tab.id_tab END) END as "id_day29",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 30 THEN base_tab.id_tab END) END as "id_day30",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 31 THEN base_tab.id_tab END) END as "id_day31",
          
          /*поколоночный вывод HTML-кода в ячейки*/
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 1  THEN base_tab.html END) END as "column1",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 2  THEN base_tab.html END) END as "column2",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 3  THEN base_tab.html END) END as "column3",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 4  THEN base_tab.html END) END as "column4",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 5  THEN base_tab.html END) END as "column5",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 6  THEN base_tab.html END) END as "column6",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 7  THEN base_tab.html END) END as "column7",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 8  THEN base_tab.html END) END as "column8",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 9  THEN base_tab.html END) END as "column9",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 10 THEN base_tab.html END) END as "column10",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 11 THEN base_tab.html END) END as "column11",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 12 THEN base_tab.html END) END as "column12",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 13 THEN base_tab.html END) END as "column13",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 14 THEN base_tab.html END) END as "column14",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 15 THEN base_tab.html END) END as "column15",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 16 THEN base_tab.html END) END as "column16",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 17 THEN base_tab.html END) END as "column17",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 18 THEN base_tab.html END) END as "column18",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 19 THEN base_tab.html END) END as "column19",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 20 THEN base_tab.html END) END as "column20",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 21 THEN base_tab.html END) END as "column21",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 22 THEN base_tab.html END) END as "column22",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 23 THEN base_tab.html END) END as "column23",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 24 THEN base_tab.html END) END as "column24",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 25 THEN base_tab.html END) END as "column25",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 26 THEN base_tab.html END) END as "column26",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 27 THEN base_tab.html END) END as "column27",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 28 THEN base_tab.html END) END as "column28",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 29 THEN base_tab.html END) END as "column29",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 30 THEN base_tab.html END) END as "column30",
          CASE WHEN GROUPING(base_tab.month_tab) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 31 THEN base_tab.html END) END as "column31"
						
FROM base_tab
CROSS JOIN vars
/*формулы группировки по сотруднику и месяцу, а также по сотруднику — для строки итого*/
GROUP BY 
GROUPING SETS (
    (object_tab, card_day, card_period, base_tab.month_tab, base_tab.id_sotr, base_tab.fio_sotr)
  , (base_tab.fio_sotr)
),
vars.year_tab, vars.month_arr, vars.c_notwork, vars.c_work, vars.c_hand, vars.c_alert, vars.c_vacation, vars.c_absence, vars.c_holiday
)

SELECT T.* 
FROM T 
WHERE T.fio_sotr is not null
  AND NOT (T.id_period is null AND T.id_sotr is not null)
  /*AND T.sum_plan != 0*/
ORDER BY T.month_tab