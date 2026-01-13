WITH 
/*таблица переменных*/
vars AS ( SELECT 
     {division}::int as "division",
     '{period}'::date as "period",
      /* unlegal - показывать неоформленных */
     {unlegal}::boolean as "unlegal",
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
     EXTRACT(MONTH FROM '{period}'::date)::int as "month_tab",
     EXTRACT(YEAR FROM '{period}'::date)::int as "year_tab",
     date_trunc('month', '{period}'::date) as fdm_tab,
     date_trunc('month', '{period}'::date) + INTERVAL '1 MONTH - 1 day' as ldm_tab
),
/*исходная таблица табеля*/
source_tab AS (
/*заготовка под строку дней недели*/
     SELECT 
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
          days AS "date_period",
          holidays.id AS "holyday"
     FROM GENERATE_SERIES( ( SELECT fdm_tab FROM vars ), ( SELECT ldm_tab FROM vars ), '1 day' ) days
LEFT JOIN registry.object_757_ holidays ON holidays.attr_789_ = days
      AND NOT holidays.is_deleted
UNION ALL
SELECT
          o.id AS "id_sotr",
          o.attr_424_ AS "fio_sotr",
          post.attr_504_ AS "name_post",
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
/*подключаем суммарное время из AS потому что пропуск может прикладываться несколько раз за день*/
LEFT JOIN (
             SELECT DISTINCT attr_1786_ AS "ref_id",  attr_1787_::date AS "ref_date", SUM(attr_1789_) OVER ( PARTITION BY attr_1786_, attr_1787_::date ) AS "sum_h"
               FROM registry.object_1785_
              WHERE NOT is_deleted
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
    WHERE NOT o.is_deleted
	/*показываем неоформленных, если установлен флаг unlegal.*/
  	/*без проверки а уволенность*/
  	  AND CASE WHEN ( SELECT unlegal FROM vars ) THEN TRUE /*если выбран показ неоформленных, показываем всех*/
           	   ELSE CASE WHEN NOT o.attr_1685_ THEN TRUE /*если выбрано скрывать неоформленных, показываем тех, кто не "не оформлен"*/
                         ELSE FALSE 
                    END
          END
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
			ORDER BY id_sotr, id_tab
),
/*базовая таблица табеля с суммами часов*/
base_tab AS (
SELECT 
source_tab.*,
/*сборка информации для ячеек таблицы*/
CASE WHEN source_tab.day_tab != 0 THEN
CASE WHEN source_tab.id_sotr = 0 THEN 
            CASE WHEN source_tab.holyday is not null THEN 'В' END 
                 ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), source_tab.day_tab::INT ) <= CURRENT_DATE THEN 
                                CASE WHEN source_tab.h_hand is not null THEN source_tab.h_hand::TEXT 
                                     ELSE CASE WHEN source_tab.h_asys = '00:00:00'::time THEN  
                                                    CASE source_tab.absence WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' 
                                                                            ELSE CASE WHEN source_tab.otp_plan = 1 THEN 'Оп' 
                                                                                      ELSE CASE WHEN source_tab.h_plan is not null THEN '!' 
  								                                                ELSE '' END END END 
                                                    ELSE CASE WHEN source_tab.absence is not null OR source_tab.otp_plan is not null THEN EXTRACT( HOUR FROM source_tab.h_asys + INTERVAL '30 minutes' )::TEXT
                                                              ELSE CASE WHEN EXTRACT( HOUR FROM source_tab.h_asys + INTERVAL '30 minutes' )::INT != COALESCE( source_tab.h_plan, 0) THEN '!'  
                                   		                              ELSE EXTRACT( HOUR FROM source_tab.h_asys + INTERVAL '30 minutes' )::TEXT END END END END 
     ELSE CASE source_tab.absence WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' 
                                  ELSE CASE WHEN source_tab.otp_plan = 1 THEN 'Оп' 
                                            ELSE CASE WHEN source_tab.h_plan is null THEN '' 
                                                      ELSE 'Д' END 
END END END END END as "html",	

/*отдельные суммы по сотруднику, бригаде, подразделению*/
CASE WHEN source_tab.id_sotr != 0 THEN SUM( COALESCE( source_tab.h_plan, 0) ) OVER ( PARTITION BY source_tab.id_sotr, source_tab.name_div, source_tab.name_brigade ) END AS "sum_plan",
CASE WHEN source_tab.id_sotr != 0 
     THEN COALESCE( SUM( CASE WHEN source_tab.day_tab = 0 THEN source_tab.h_hand END) OVER ( PARTITION BY source_tab.id_sotr, source_tab.name_div, source_tab.name_brigade ) , 
                    EXTRACT( HOUR FROM (SUM( COALESCE( make_time(source_tab.h_hand, 0 , 0), source_tab.h_asys )) OVER ( PARTITION BY source_tab.id_sotr, source_tab.name_div, source_tab.name_brigade ) ) + INTERVAL '30 minutes') )::INT
END AS "sum_fact"
FROM source_tab
ORDER BY id_sotr, day_tab
),

/*табель*/
T AS (
      SELECT DISTINCT 
          /*тип строки*/
          CASE
                  WHEN base_tab.id_sotr = 0 THEN 'dates'
                  WHEN base_tab.id_sotr IS NOT NULL THEN 'sotr'
                  WHEN base_tab.name_brigade IS NOT NULL THEN 'brigade'
                  WHEN base_tab.name_div IS NOT NULL THEN 'division'
          END AS "row_type",
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
                  WHEN base_tab.id_sotr = 0 THEN NULL
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
                  WHEN base_tab.id_sotr IS NOT NULL THEN MAX(base_tab.sum_plan)
                  WHEN base_tab.name_brigade IS NOT NULL THEN NULL
                  ELSE NULL
          END AS sum_plan,
          CASE
                  WHEN base_tab.id_sotr IS NOT NULL THEN MAX(base_tab.sum_fact)
                  WHEN base_tab.name_brigade IS NOT NULL THEN NULL
                  ELSE NULL
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
(base_tab.id_sotr, base_tab.fio_sotr, base_tab.id_div, base_tab.name_div,  base_tab.sort_inbrigade, base_tab.name_post, base_tab.fired_date, base_tab.name_brigade)
, (base_tab.name_brigade, base_tab.name_div)
, base_tab.name_div
)
HAVING (base_tab.fired_date is null OR base_tab.fired_date > ( SELECT fdm_tab FROM vars )) AND (MAX(base_tab.sum_plan) != 0 OR MAX(base_tab.sum_plan) is null)

)

SELECT 
    CASE WHEN T.row_type = 'sotr' THEN ROW_NUMBER() OVER (PARTITION BY T.row_type = 'sotr' ORDER BY name_div, lv_div, name_brigade, lv_br, sort_inbrigade, fio_sotr) END AS npp,
    CASE WHEN T.row_type = 'sotr' THEN ROW_NUMBER() OVER (PARTITION BY T.row_type = 'sotr', name_brigade ORDER BY name_div, lv_div, name_brigade, lv_br, sort_inbrigade, fio_sotr) END AS nppb,
    T.* 
FROM T 
/*убираем строку итого для строки дней*/
WHERE not (T.name_div = '0' AND T.id_sotr is null)
ORDER BY name_div, lv_div, name_brigade, lv_br, sort_inbrigade, fio_sotr