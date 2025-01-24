WITH 
/*таблица переменных*/
vars AS ( SELECT 
     {employee}::int as "employee",
     {period}::date as "period",
     EXTRACT(YEAR FROM {period}::date)::int as "year_tab",
     array ['Январь', 'Февраль', 'Март', 'Апрель', 'Май',	'Июнь', 'Июль',	'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'] AS month_arr,
     'RGB(0 255 0 / 0)' AS "c_notwork",
     'RGB(60 179 113 / 0.25)' AS "c_work",
     'RGB(0 191 255 / 0.25)' AS "c_hand", --DeepSkyBlue
     'RGB(220 38 41 / 0.25)' AS "c_alert",
     /*'RGB(255 0 0 / 0.25)' AS "c_alert", --Red*/
     /*'RGB(220 20 60 / 0.25)' AS "c_alert", --Crimson*/
     'RGB(255 255 0 / 0.25)' AS "c_vacation",
     'RGB(255 165 0 / 0.25)' AS "c_absence",
     'RGB(105 105 105 / 0.25)' AS "c_holiday" --DimGrey
), 
/*исходная таблица табеля*/
source_tab AS (
SELECT
	    1774 AS "object_tab",
          223 AS "card_tab",
          EXTRACT(MONTH FROM tabel.attr_1776_::date)::int as "month_tab",
          o.id AS "id_sotr",
          o.attr_424_ AS "fio_sotr",
          tabel.id AS "id_tab",
          EXTRACT(DAY FROM tabel.attr_1776_) AS "day_tab",
          tabel.attr_1780_ AS "h_plan",
          tabel.attr_1816_ AS "h_hand",
          COALESCE( asyst.attr_1789_, '00:00:00' ) AS "h_asys",
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
/*базовая таблица табеля с суммами часов*/
base_tab AS (
SELECT 
source_tab.*,
/*сборка HTML-кода для ячеек таблицы*/
CASE WHEN make_date((SELECT year_tab FROM vars), source_tab.month_tab, source_tab.day_tab::int ) <= CURRENT_DATE THEN 
               CASE WHEN source_tab.h_hand is not null THEN '<div style="background-color:'||(SELECT c_hand FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||source_tab.h_hand::TEXT||'</div></div> ' 
                    ELSE CASE WHEN EXTRACT( HOUR FROM source_tab.h_asys + INTERVAL '30 minutes' )::INT != COALESCE( source_tab.h_plan, 0) THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'|| EXTRACT( HOUR FROM source_tab.h_asys + INTERVAL '30 minutes' )::INT ||'</div></div> ' 
                              ELSE CASE WHEN source_tab.h_plan is not null THEN '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'|| EXTRACT( HOUR FROM source_tab.h_asys + INTERVAL '30 minutes' )::INT ||'</div></div> ' 
                                        ELSE CASE source_tab.absence 
                                                  WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' 
                                                  WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' 
                                                  WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' 
                                                  WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' 
                                                  WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' 
                                                  ELSE CASE WHEN source_tab.otp_plan = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' 
                                                            ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' 
                                                       END 
                                             END 
                                   END 
                         END 
               END
               ELSE CASE WHEN source_tab.h_plan is null THEN 
                         CASE source_tab.absence 
                              WHEN 1 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' 
                              WHEN 4 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' 
                              WHEN 5 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'О'||'</div></div> ' 
                              WHEN 2 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'А'||'</div></div> ' 
                              WHEN 3 THEN '<div style="background-color:'||(SELECT c_absence FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Б'||'</div></div> ' 
                              ELSE CASE WHEN source_tab.otp_plan = 1 THEN '<div style="background-color:'||(SELECT c_vacation FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Оп'||'</div></div> ' 
                                        ELSE '<div style="background-color:'||(SELECT c_notwork FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||''||'</div></div> ' 
                                   END 
                         END 
                         ELSE CASE WHEN source_tab.absence is not null OR source_tab.otp_plan is not null THEN '<div style="background-color:'||(SELECT c_alert FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'!'||'</div></div> ' 
                                   ELSE '<div style="background-color:'||(SELECT c_work FROM vars)||'; height: 25px;"><div style="font-weight: 400; padding: 0px 5px;">'||'Д'||'</div></div> ' 
                              END 
                    END 
  END as "html",																								
/*отдельные суммы по сотруднику, году*/
          SUM( source_tab.h_plan) OVER ( PARTITION BY EXTRACT(MONTH FROM source_tab.date_period::date)::int) AS "sum_plan",
          SUM( COALESCE( source_tab.h_hand, EXTRACT( HOUR FROM source_tab.h_asys + INTERVAL '30 minutes' )::INT ) ) OVER ( PARTITION BY EXTRACT(MONTH FROM source_tab.date_period::date)::int) AS "sum_fact",
          SUM( source_tab.h_plan) OVER () AS "sum_plan_year",
          SUM( COALESCE( source_tab.h_hand, EXTRACT( HOUR FROM source_tab.h_asys + INTERVAL '30 minutes' )::INT ) ) OVER () AS "sum_fact_year"
FROM source_tab
),

/*табель*/
T AS (
      SELECT DISTINCT 
          base_tab.object_tab,
          base_tab.card_tab,
          base_tab.id_sotr,
          base_tab.fio_sotr,
		  base_tab.month_tab,
            /*первая колонка таблицы*/
          CASE
               WHEN base_tab.id_sotr is not NULL THEN (SELECT month_arr[base_tab.month_tab] FROM vars)
               ELSE 'Итого за '||(SELECT year_tab FROM vars) || ' --->'
          END AS "first_column",

CASE 
WHEN base_tab.id_sotr is not NULL THEN MAX (base_tab.sum_plan)
ELSE MAX (base_tab.sum_plan_year) END as "sum_plan",
CASE 
WHEN base_tab.id_sotr is not NULL THEN MAX (base_tab.sum_fact)
ELSE MAX (base_tab.sum_fact_year) END as "sum_fact",
/*поколоночный вывод ID записей в реестре табеля*/
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
/*поколоночный вывод HTML-кода в ячейки*/
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
/*формулы группировки по сотруднику, а так же году - для строки итого*/
GROUP BY 
GROUPING SETS (
(object_tab, card_tab, base_tab.month_tab, base_tab.id_sotr, base_tab.fio_sotr)
, base_tab.fio_sotr
)

ORDER BY
base_tab.month_tab
)

select T.* from T 
WHERE T.fio_sotr is not null