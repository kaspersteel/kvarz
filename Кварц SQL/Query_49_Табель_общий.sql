WITH 
/*таблица переменных*/
vars AS ( SELECT
      /*mode - режим учёта места работы. 1 - из графика, 2 - из оргструктуры*/ 
     {mode}::int as "mode",    
      /* unlegal - показывать неоформленных */
     {unlegal}::boolean as "unlegal",    
     {division}::int as "division",
     {period}::date as "period",
     (    SELECT (
             SELECT ARRAY_AGG(DISTINCT divs)
               FROM UNNEST(
                       COALESCE(odd_org.sub_divs, ARRAY[]::int[]) || 
                       COALESCE(org.sub_divs,   ARRAY[]::int[])
                    ) AS "divs"
          )
     FROM registry.object_15_ users
LEFT JOIN LATERAL (
             SELECT COALESCE(ARRAY_AGG(attr_65_), ARRAY[]::int[]) AS "sub_divs"
               FROM registry.object_36_ o
              WHERE o.ID = ANY (COALESCE(users.attr_1815_, ARRAY[]::int[]))
                AND NOT o.is_deleted
          ) "org" ON TRUE
LEFT JOIN LATERAL (
             SELECT COALESCE(ARRAY_AGG(DISTINCT odd_sub_org.attr_65_), ARRAY[]::int[]) AS "sub_divs"
               FROM registry.object_36_ odd_org
          LEFT JOIN registry.object_36_ odd_up_org ON odd_up_org.ID = odd_org.attr_1753_
                AND odd_up_org.attr_65_ != odd_org.attr_65_
                AND NOT odd_up_org.is_deleted
          LEFT JOIN registry.object_15_ odd_users ON odd_users.attr_506_ = odd_org.attr_285_
                AND NOT odd_users.is_deleted
          LEFT JOIN registry.object_36_ odd_sub_org ON odd_sub_org.ID = ANY (COALESCE(odd_users.attr_1815_, ARRAY[]::int[]))
                AND NOT odd_sub_org.is_deleted
              WHERE odd_org.attr_65_ = ANY (COALESCE(users.attr_1914_, ARRAY[]::int[]))
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
          NULL AS "fired_date",
          '0' AS "name_div",
          NULL AS "id_div",
          NULL AS "name_brigade",
          NULL AS "sort_inbrigade",
          NULL AS "id_tab",
          EXTRACT( DAY FROM days ) AS "day_tab",
          NULL AS "h_plan",
          NULL AS "h_hand",
          NULL AS "h_asys",
          NULL AS "otp_plan",
          NULL AS "absence",
	    NULL AS "note_litera",
	    NULL AS "note_color",
          days AS "date_period",
          holidays.id AS "holyday"
     FROM GENERATE_SERIES( (SELECT fdm_tab FROM vars), (SELECT ldm_tab FROM vars), '1 day' ) days
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
          post.attr_504_||CASE WHEN o.attr_1685_ THEN ' (неоф)' ELSE '' END||CASE WHEN o.attr_1496_ is not null THEN ' (ув)' ELSE '' END AS "name_post",
          o.attr_1496_ AS "fired_date",
          division.attr_1545_ AS "name_div",
          division.id AS "id_div",
          brigade.attr_1793_ AS "name_brigade",
		  o.attr_1950_ AS "sort_inbrigade",
          tabel.id AS "id_tab",
		  /*информационная ячейка за период будет "Днём Зеро"*/
          CASE WHEN tabel.attr_1908_ THEN 0 ELSE EXTRACT(DAY FROM tabel.attr_1776_) END AS "day_tab",
          tabel.attr_1780_ AS "h_plan",
          tabel.attr_1816_ AS "h_hand",
          COALESCE( CASE WHEN tabel.attr_1908_ THEN null ELSE asyst.sum_h END, '00:00:00' )::time AS "h_asys",
          CASE WHEN gr_otp.id is not null THEN 1 END AS "otp_plan",
          absence.attr_1504_ AS "absence",
		  notes.attr_1801_ AS "note_litera",
		  notes.attr_1802_ AS "note_color",
          NULL AS "date_period",
          NULL AS "holyday"
     FROM registry.object_419_ o
CROSS JOIN vars
LEFT JOIN registry.object_1774_ tabel ON o.id = tabel.attr_1775_
      AND NOT tabel.is_deleted
LEFT JOIN registry.object_503_ post ON o.attr_505_ = post.id
      AND NOT post.is_deleted
LEFT JOIN registry.object_1544_ division ON division.id = CASE vars.mode WHEN 1 THEN tabel.attr_1817_ WHEN 2 THEN o.attr_1546_ END
      AND NOT division.is_deleted
LEFT JOIN registry.object_1790_ brigade ON brigade.id = CASE vars.mode WHEN 1 THEN tabel.attr_1818_ WHEN 2 THEN o.attr_1804_ END
      AND NOT brigade.is_deleted
/*подключаем суммарное время из AS потому что пропуск может прикладываться несколько раз за день*/
LEFT JOIN (
             SELECT attr_1786_ AS "ref_id",  
                    attr_1787_::date AS "ref_date", 
                    SUM(attr_1789_) AS "sum_h"
               FROM registry.object_1785_
              WHERE NOT is_deleted
                AND attr_1787_ >= (SELECT fdm_tab FROM vars)
                AND attr_1787_ <  (SELECT ldm_tab FROM vars) + INTERVAL '1 day'
              GROUP BY attr_1786_, attr_1787_::date
		  ) asyst ON o.id = asyst.ref_id AND tabel.attr_1776_ = asyst.ref_date
LEFT JOIN registry.object_1690_ gr_otp ON o.id = gr_otp.attr_1692_
      AND tabel.attr_1776_ >= gr_otp.attr_1693_::date
      AND tabel.attr_1776_ <= gr_otp.attr_1694_::date
      AND NOT gr_otp.attr_1752_
      AND NOT gr_otp.is_deleted
LEFT JOIN registry.object_1502_ absence ON o.id = absence.attr_1503_
      AND tabel.attr_1776_ >= absence.attr_1505_::date
      AND tabel.attr_1776_ <= absence.attr_1506_::date
      AND NOT absence.is_deleted
LEFT JOIN registry.object_1792_ notes ON o.id = notes.attr_1952_
      AND tabel.attr_1776_ >= notes.attr_1953_::date
      AND tabel.attr_1776_ <= notes.attr_1954_::date
      AND NOT notes.is_deleted
	  AND notes.attr_1951_  
WHERE NOT o.is_deleted
	/*Новикова О.А. 09.10.25  по просьбе Баранова убираем из табеля уволенных сотрудников, в неоформленных могут находиться сотрудники, которые уволены, но работают неофиц. - их показываем*/
	/*показываем неоформленных, если установлен флаг unlegal.*/
  	/*с проверкой на уволенность.*/
  	/* AND (vars.unlegal OR (NOT o.attr_1685_ AND (o.attr_1496_ IS NULL OR o.attr_1496_ >= vars.period))) */
  	/*без проверки на уволенность*/
  	AND (vars.unlegal OR NOT o.attr_1685_)
      /*защита от NULL в массивах: COALESCE(division.id, 0) и COALESCE(vars.subdivs, ARRAY[]::int[])*/
      AND (
             (vars.division IS NOT NULL AND division.id = vars.division)
             OR
             (vars.division IS NULL AND COALESCE(division.id, 0) = ANY(COALESCE(vars.subdivs, ARRAY[]::int[])))
          )
      /*sargable фильтр по месяцу*/
      AND tabel.attr_1776_ >= vars.fdm_tab
      AND tabel.attr_1776_ <  vars.ldm_tab + INTERVAL '1 day'
      /*ORDER BY id_sotr, day_tab - закомментировано для тестирования*/
),

/*базовая таблица табеля*/
base_tab AS (
SELECT 
source_tab.*,
vars.month_tab as "month_tab",
/*отдельные суммы по сотруднику, бригаде, подразделению*/
CASE WHEN source_tab.id_sotr != 0 THEN SUM( COALESCE( source_tab.h_plan, 0) ) OVER ( PARTITION BY source_tab.id_sotr, source_tab.name_div, source_tab.name_brigade ) END AS "sum_plan",
CASE WHEN source_tab.id_sotr != 0 
     THEN COALESCE( SUM( CASE WHEN source_tab.day_tab = 0 THEN source_tab.h_hand END) OVER ( PARTITION BY source_tab.id_sotr, source_tab.name_div, source_tab.name_brigade ) , 
                    EXTRACT( HOUR FROM (SUM( COALESCE( make_time(source_tab.h_hand, 0 , 0), source_tab.h_asys )) OVER ( PARTITION BY source_tab.id_sotr, source_tab.name_div, source_tab.name_brigade ) ) + INTERVAL '30 minutes') )::INT
END AS "sum_fact",
/*
SUM( COALESCE( source_tab.h_plan, 0) ) OVER ( PARTITION BY source_tab.name_brigade ) AS "sum_br_plan",
SUM( COALESCE( source_tab.h_plan, 0) ) OVER ( PARTITION BY source_tab.name_div ) AS "sum_div_plan", */

/*сборка HTML-кода для ячеек таблицы*/
CASE WHEN source_tab.day_tab != 0 THEN
CASE WHEN source_tab.id_sotr = 0 THEN '<div style="background-color:'||CASE WHEN source_tab.holyday is not null THEN vars.c_holiday ELSE 'RGB(0 255 0 / 0)' END||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||TO_CHAR(source_tab.date_period, 'TMDy')||'</div></div> ' 
     ELSE CASE WHEN make_date(vars.year_tab, vars.month_tab, source_tab.day_tab::int ) <= CURRENT_DATE THEN 
               CASE WHEN source_tab.h_hand is not null THEN '<div style="background-color:'||vars.c_hand||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||source_tab.h_hand::TEXT||'</div></div> ' 
                    ELSE CASE WHEN source_tab.h_asys = '00:00:00'::time THEN 
  					CASE source_tab.absence 
                                   WHEN 1 THEN '<div style="background-color:'||vars.c_absence||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' 
                                   WHEN 4 THEN '<div style="background-color:'||vars.c_absence||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' 
                                   WHEN 5 THEN '<div style="background-color:'||vars.c_absence||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' 
                                   WHEN 2 THEN '<div style="background-color:'||vars.c_absence||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' 
                                   WHEN 3 THEN '<div style="background-color:'||vars.c_absence||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' 
                                   ELSE CASE WHEN source_tab.otp_plan = 1 THEN '<div style="background-color:'||vars.c_vacation||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' 
                                             ELSE CASE WHEN source_tab.note_litera is not null THEN '<div style="background-color:'||source_tab.note_color||'40; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||source_tab.note_litera||'</div></div> ' 
													   ELSE CASE WHEN source_tab.h_plan is not null THEN '<div style="background-color:'||vars.c_alert||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'|| EXTRACT( HOUR FROM source_tab.h_asys + INTERVAL '30 minutes' )::INT ||'</div></div> ' 
																 ELSE '<div style="background-color:'||vars.c_notwork||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' 
															END
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
                                   ELSE CASE WHEN source_tab.note_litera is not null THEN '<div style="background-color:'||source_tab.note_color||'40; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||source_tab.note_litera||'</div></div> ' 
											 ELSE CASE WHEN source_tab.h_plan is null THEN '<div style="background-color:'||vars.c_notwork||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' 
													   ELSE '<div style="background-color:'||vars.c_work||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' 
												  END
										END
							  END 
                    END 
          END
END END as "html"
FROM source_tab
CROSS JOIN vars
/*ORDER BY id_sotr, day_tab - закомментировано для тестирования*/
),

/*табель*/
T AS (
   SELECT 
          /*поля, общие для всех группировок*/
          base_tab.object_tab,
          base_tab.card_day,
          base_tab.card_period,
          base_tab.object_sotr,
          base_tab.card_sotr,
          base_tab.month_tab,
          
          /*тип строки*/
          CASE
              /*сначала проверяем служебное значение id_sotr = 0 — это строка дат*/
              WHEN base_tab.id_sotr = 0 THEN 'dates'
              /*потом проверяем, входит ли id_sotr в текущий GROUPING SET*/
              WHEN GROUPING(base_tab.id_sotr) = 0 THEN 'sotr'
              /*если id_sotr не в группировке, смотрим на brigade/division*/
              WHEN GROUPING(base_tab.name_brigade) = 0 THEN 'brigade'
              WHEN GROUPING(base_tab.name_div) = 0 AND GROUPING(base_tab.name_brigade) = 1 THEN 'division'
              ELSE ''
          END AS "row_type",
          
          /*поля сотрудника*/
          base_tab.id_sotr,
          base_tab.fio_sotr,
          
          /*выделение заголовков подразделений и бригад*/
          CASE
              WHEN base_tab.name_div = '0' THEN NULL
              WHEN base_tab.name_brigade IS NULL AND base_tab.id_sotr IS NULL THEN 1
              WHEN base_tab.name_brigade IS NULL THEN 2
              ELSE 3
          END AS "lv_div",
          
          CASE
              WHEN base_tab.name_brigade IS NULL THEN NULL
              WHEN base_tab.id_sotr IS NULL THEN 1
              ELSE 2
          END AS "lv_br",
          
          /*первая колонка таблицы*/
          CASE
                  WHEN base_tab.id_sotr = 0 THEN ''
                  WHEN base_tab.id_sotr IS NOT NULL THEN base_tab.fio_sotr
                  WHEN base_tab.name_brigade IS NOT NULL THEN '' || base_tab.name_brigade || ''
                  WHEN base_tab.name_div IS NOT NULL THEN '' || base_tab.name_div || ''
          END AS "first_column",
          
          base_tab.name_post,
          base_tab.fired_date,
          base_tab.name_div,
          base_tab.id_div,
          base_tab.name_brigade,
          base_tab.sort_inbrigade,
          
          CASE
              WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(base_tab.sum_plan)
              ELSE NULL
          END AS sum_plan,
          
          CASE
              WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(base_tab.sum_fact)
              ELSE NULL
          END AS sum_fact,
          
          CASE
              WHEN base_tab.id_sotr != 0 THEN MAX(
                  CASE
                      WHEN base_tab.day_tab = 0 THEN 
                          CASE WHEN base_tab.h_hand IS NOT NULL 
                               THEN vars.c_hand
                               ELSE vars.c_notwork
                          END
                  END)
              ELSE vars.c_notwork
          END AS "sum_fact_color",
          
          /*поколоночный вывод ID записей*/
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 0  THEN base_tab.id_tab END) END AS "id_period",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 1  THEN base_tab.id_tab END) END AS "id_day1",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 2  THEN base_tab.id_tab END) END AS "id_day2",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 3  THEN base_tab.id_tab END) END AS "id_day3",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 4  THEN base_tab.id_tab END) END AS "id_day4",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 5  THEN base_tab.id_tab END) END AS "id_day5",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 6  THEN base_tab.id_tab END) END AS "id_day6",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 7  THEN base_tab.id_tab END) END AS "id_day7",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 8  THEN base_tab.id_tab END) END AS "id_day8",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 9  THEN base_tab.id_tab END) END AS "id_day9",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 10 THEN base_tab.id_tab END) END AS "id_day10",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 11 THEN base_tab.id_tab END) END AS "id_day11",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 12 THEN base_tab.id_tab END) END AS "id_day12",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 13 THEN base_tab.id_tab END) END AS "id_day13",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 14 THEN base_tab.id_tab END) END AS "id_day14",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 15 THEN base_tab.id_tab END) END AS "id_day15",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 16 THEN base_tab.id_tab END) END AS "id_day16",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 17 THEN base_tab.id_tab END) END AS "id_day17",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 18 THEN base_tab.id_tab END) END AS "id_day18",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 19 THEN base_tab.id_tab END) END AS "id_day19",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 20 THEN base_tab.id_tab END) END AS "id_day20",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 21 THEN base_tab.id_tab END) END AS "id_day21",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 22 THEN base_tab.id_tab END) END AS "id_day22",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 23 THEN base_tab.id_tab END) END AS "id_day23",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 24 THEN base_tab.id_tab END) END AS "id_day24",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 25 THEN base_tab.id_tab END) END AS "id_day25",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 26 THEN base_tab.id_tab END) END AS "id_day26",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 27 THEN base_tab.id_tab END) END AS "id_day27",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 28 THEN base_tab.id_tab END) END AS "id_day28",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 29 THEN base_tab.id_tab END) END AS "id_day29",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 30 THEN base_tab.id_tab END) END AS "id_day30",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 31 THEN base_tab.id_tab END) END AS "id_day31",
          
          /*поколоночный вывод HTML-кода*/
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 1  THEN base_tab.html END) END AS "column1",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 2  THEN base_tab.html END) END AS "column2",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 3  THEN base_tab.html END) END AS "column3",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 4  THEN base_tab.html END) END AS "column4",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 5  THEN base_tab.html END) END AS "column5",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 6  THEN base_tab.html END) END AS "column6",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 7  THEN base_tab.html END) END AS "column7",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 8  THEN base_tab.html END) END AS "column8",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 9  THEN base_tab.html END) END AS "column9",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 10 THEN base_tab.html END) END AS "column10",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 11 THEN base_tab.html END) END AS "column11",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 12 THEN base_tab.html END) END AS "column12",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 13 THEN base_tab.html END) END AS "column13",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 14 THEN base_tab.html END) END AS "column14",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 15 THEN base_tab.html END) END AS "column15",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 16 THEN base_tab.html END) END AS "column16",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 17 THEN base_tab.html END) END AS "column17",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 18 THEN base_tab.html END) END AS "column18",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 19 THEN base_tab.html END) END AS "column19",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 20 THEN base_tab.html END) END AS "column20",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 21 THEN base_tab.html END) END AS "column21",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 22 THEN base_tab.html END) END AS "column22",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 23 THEN base_tab.html END) END AS "column23",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 24 THEN base_tab.html END) END AS "column24",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 25 THEN base_tab.html END) END AS "column25",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 26 THEN base_tab.html END) END AS "column26",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 27 THEN base_tab.html END) END AS "column27",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 28 THEN base_tab.html END) END AS "column28",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 29 THEN base_tab.html END) END AS "column29",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 30 THEN base_tab.html END) END AS "column30",
          CASE WHEN GROUPING(base_tab.id_sotr) = 0 THEN MAX(CASE WHEN base_tab.day_tab = 31 THEN base_tab.html END) END AS "column31"

   FROM base_tab
   CROSS JOIN vars
   GROUP BY 
   GROUPING SETS (
       (object_tab, card_day, card_period, object_sotr, card_sotr, base_tab.month_tab, base_tab.id_sotr, base_tab.fio_sotr, base_tab.id_div, base_tab.name_div, base_tab.sort_inbrigade, base_tab.name_post, base_tab.fired_date,   base_tab.name_brigade)
     , (base_tab.name_brigade, base_tab.name_div)
     , (base_tab.name_div)
   ),
   vars.c_hand, vars.c_notwork, vars.fdm_tab, vars.c_alert, vars.c_work, vars.c_vacation, vars.c_absence, vars.c_holiday
   
   /*убираем уволенных и неработавших*/
    HAVING (base_tab.fired_date is null OR base_tab.fired_date > vars.fdm_tab)
           AND (MAX(base_tab.sum_plan) != 0 OR MAX(base_tab.sum_plan) is null)
)
SELECT 
    CASE WHEN T.row_type = 'sotr' THEN ROW_NUMBER() OVER (PARTITION BY T.row_type = 'sotr' ORDER BY name_div, lv_div, name_brigade, lv_br, sort_inbrigade, fio_sotr) END AS npp,
    CASE WHEN T.row_type = 'sotr' THEN ROW_NUMBER() OVER (PARTITION BY T.row_type = 'sotr', name_brigade ORDER BY name_div, lv_div, name_brigade, lv_br, sort_inbrigade, fio_sotr) END AS nppb,
    T.* 
FROM T 
/*убираем строку итого для строки дней*/
WHERE not (T.name_div = '0' AND T.id_sotr is null)
ORDER BY name_div, lv_div, name_brigade, lv_br, sort_inbrigade, fio_sotr