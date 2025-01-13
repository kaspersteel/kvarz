WITH 
vars AS (SELECT 
null::int as "division",
null::int as "employee",
'01-01-2025'::date as "period",
EXTRACT(MONTH FROM '01-01-2025'::date)::int as "month_tab",
EXTRACT(YEAR FROM '01-01-2025'::date)::int as "year_tab",
date_trunc('month', '01-01-2025'::date) as "fdm_tab",
'01-01-2025'::date + INTERVAL '1 MONTH - 1 day' as "ldm_tab",
'RGB(0 255 0 / 0)' AS "c_notwork",
'RGB(60 179 113 / 0.25)' AS "c_work",
'RGB(220 20 60 / 0.25)' AS "c_alert",
'RGB(255 255 0 / 0.25)' AS "c_vacation",
'RGB(255 165 0 / 0.25)' AS "c_absence",
'RGB(105 105 105 / 0.25)' AS "c_holiday" --DimGrey
/*'RGB(255 238 208 / 1)' AS "c_holiday" --цвет шапки*/    
/*'RGB(65 105 225 / 0.25)' AS "c_holiday" --RoyalBlue*/ 
), 

base_tab AS ( SELECT 
          o.id AS "id_sotr",
          o.attr_424_ AS "fio_sotr",
          o.attr_1762_ AS "chiefs_org_str",
          post.attr_504_ AS "name_post",
          division.attr_1545_ AS "name_div",
          division.id AS "id_div",
          brigade.attr_1793_ AS "name_brigade",
          tabel.id AS "id_tab",
          EXTRACT(
          DAY
               FROM tabel.attr_1776_
          ) AS "day_tab",
          tabel.attr_1780_ AS "h_tab",
          COALESCE (asyst.attr_1789_, '00:00:00') AS "h_asyst",
          gr_otp.id AS "id_gr_otp",
          absence.attr_1504_ AS "type_absence",
          SUM (tabel.attr_1780_) OVER (PARTITION BY o.id) as "sum_plan",
          SUM (FLOOR (EXTRACT(HOUR FROM asyst.attr_1789_+ interval '30 minutes')::int)) OVER (PARTITION BY o.id) as "sum_fact",
          SUM (tabel.attr_1780_) OVER (PARTITION BY brigade.id) as "sum_br_plan",
          SUM (FLOOR (EXTRACT(HOUR FROM asyst.attr_1789_+ interval '30 minutes')::int)) OVER (PARTITION BY brigade.id) as "sum_br_fact",		
					SUM (tabel.attr_1780_) OVER (PARTITION BY division.id) as "sum_div_plan",
          SUM (FLOOR (EXTRACT(HOUR FROM asyst.attr_1789_+ interval '30 minutes')::int)) OVER (PARTITION BY division.id) as "sum_div_fact"
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
AND CASE WHEN (SELECT division FROM vars)::int IS NOT NULL THEN 
         CASE WHEN division.id = (SELECT division FROM vars)::int THEN TRUE 
                    ELSE FALSE 
               END 
     ELSE TRUE
     END
AND  
     CASE WHEN (SELECT employee FROM vars)::int IS NOT NULL THEN
          CASE WHEN o.id = (SELECT employee FROM vars)::int THEN TRUE 
                    ELSE FALSE 
               END 
     ELSE TRUE
     END
AND case when date_trunc('month', tabel.attr_1776_::date) = date_trunc('month', (SELECT period FROM vars)) then true else false end),
/*табель*/
T AS (select
1774 as "object_tab",
223 as "card_tab",
419 as "object_sotr",
222 as "card_sotr",
base_tab.id_sotr, 
CASE 
WHEN base_tab.id_sotr is not NULL THEN base_tab.fio_sotr 
WHEN base_tab.name_brigade is not NULL THEN '> Итого '||base_tab.name_brigade 
ELSE '> Итого '||base_tab.name_div 
END as "fio_sotr", 
base_tab.chiefs_org_str, 
base_tab.id_div,
base_tab.name_div, 
base_tab.name_post, 
base_tab.name_brigade,

CASE 
WHEN base_tab.id_sotr is not NULL THEN MAX (base_tab.sum_plan) 
WHEN base_tab.name_brigade is not NULL THEN MAX (base_tab.sum_br_plan) 
ELSE MAX (base_tab.sum_div_plan)
END as sum_plan2,

CASE 
WHEN base_tab.id_sotr is not NULL THEN MAX (base_tab.sum_fact)
WHEN base_tab.name_brigade is not NULL THEN MAX (base_tab.sum_br_fact)
ELSE MAX (base_tab.sum_div_fact)
END as sum_fact2,

MAX (CASE WHEN base_tab.day_tab = 1 THEN base_tab.h_tab END) as h_plan1,
MAX (CASE WHEN base_tab.day_tab = 2 THEN base_tab.h_tab END) as h_plan2,
MAX (CASE WHEN base_tab.day_tab = 3 THEN base_tab.h_tab END) as h_plan3,
MAX (CASE WHEN base_tab.day_tab = 4 THEN base_tab.h_tab END) as h_plan4,
MAX (CASE WHEN base_tab.day_tab = 5 THEN base_tab.h_tab END) as h_plan5,
MAX (CASE WHEN base_tab.day_tab = 6 THEN base_tab.h_tab END) as h_plan6,
MAX (CASE WHEN base_tab.day_tab = 7 THEN base_tab.h_tab END) as h_plan7,
MAX (CASE WHEN base_tab.day_tab = 8 THEN base_tab.h_tab END) as h_plan8,
MAX (CASE WHEN base_tab.day_tab = 9 THEN base_tab.h_tab END) as h_plan9,
MAX (CASE WHEN base_tab.day_tab = 10 THEN base_tab.h_tab END) as h_plan10,
MAX (CASE WHEN base_tab.day_tab = 11 THEN base_tab.h_tab END) as h_plan11,
MAX (CASE WHEN base_tab.day_tab = 12 THEN base_tab.h_tab END) as h_plan12,
MAX (CASE WHEN base_tab.day_tab = 13 THEN base_tab.h_tab END) as h_plan13,
MAX (CASE WHEN base_tab.day_tab = 14 THEN base_tab.h_tab END) as h_plan14,
MAX (CASE WHEN base_tab.day_tab = 15 THEN base_tab.h_tab END) as h_plan15,
MAX (CASE WHEN base_tab.day_tab = 16 THEN base_tab.h_tab END) as h_plan16,
MAX (CASE WHEN base_tab.day_tab = 17 THEN base_tab.h_tab END) as h_plan17,
MAX (CASE WHEN base_tab.day_tab = 18 THEN base_tab.h_tab END) as h_plan18,
MAX (CASE WHEN base_tab.day_tab = 19 THEN base_tab.h_tab END) as h_plan19,
MAX (CASE WHEN base_tab.day_tab = 20 THEN base_tab.h_tab END) as h_plan20,
MAX (CASE WHEN base_tab.day_tab = 21 THEN base_tab.h_tab END) as h_plan21,
MAX (CASE WHEN base_tab.day_tab = 22 THEN base_tab.h_tab END) as h_plan22,
MAX (CASE WHEN base_tab.day_tab = 23 THEN base_tab.h_tab END) as h_plan23,
MAX (CASE WHEN base_tab.day_tab = 24 THEN base_tab.h_tab END) as h_plan24,
MAX (CASE WHEN base_tab.day_tab = 25 THEN base_tab.h_tab END) as h_plan25,
MAX (CASE WHEN base_tab.day_tab = 26 THEN base_tab.h_tab END) as h_plan26,
MAX (CASE WHEN base_tab.day_tab = 27 THEN base_tab.h_tab END) as h_plan27,
MAX (CASE WHEN base_tab.day_tab = 28 THEN base_tab.h_tab END) as h_plan28,
MAX (CASE WHEN base_tab.day_tab = 29 THEN base_tab.h_tab END) as h_plan29,
MAX (CASE WHEN base_tab.day_tab = 30 THEN base_tab.h_tab END) as h_plan30,
MAX (CASE WHEN base_tab.day_tab = 31 THEN base_tab.h_tab END) as h_plan31,

MAX (CASE WHEN base_tab.day_tab = 1 THEN base_tab.h_asyst END) as h_asys1,
MAX (CASE WHEN base_tab.day_tab = 2 THEN base_tab.h_asyst END) as h_asys2,
MAX (CASE WHEN base_tab.day_tab = 3 THEN base_tab.h_asyst END) as h_asys3,
MAX (CASE WHEN base_tab.day_tab = 4 THEN base_tab.h_asyst END) as h_asys4,
MAX (CASE WHEN base_tab.day_tab = 5 THEN base_tab.h_asyst END) as h_asys5,
MAX (CASE WHEN base_tab.day_tab = 6 THEN base_tab.h_asyst END) as h_asys6,
MAX (CASE WHEN base_tab.day_tab = 7 THEN base_tab.h_asyst END) as h_asys7,
MAX (CASE WHEN base_tab.day_tab = 8 THEN base_tab.h_asyst END) as h_asys8,
MAX (CASE WHEN base_tab.day_tab = 9 THEN base_tab.h_asyst END) as h_asys9,
MAX (CASE WHEN base_tab.day_tab = 10 THEN base_tab.h_asyst END) as h_asys10,
MAX (CASE WHEN base_tab.day_tab = 11 THEN base_tab.h_asyst END) as h_asys11,
MAX (CASE WHEN base_tab.day_tab = 12 THEN base_tab.h_asyst END) as h_asys12,
MAX (CASE WHEN base_tab.day_tab = 13 THEN base_tab.h_asyst END) as h_asys13,
MAX (CASE WHEN base_tab.day_tab = 14 THEN base_tab.h_asyst END) as h_asys14,
MAX (CASE WHEN base_tab.day_tab = 15 THEN base_tab.h_asyst END) as h_asys15,
MAX (CASE WHEN base_tab.day_tab = 16 THEN base_tab.h_asyst END) as h_asys16,
MAX (CASE WHEN base_tab.day_tab = 17 THEN base_tab.h_asyst END) as h_asys17,
MAX (CASE WHEN base_tab.day_tab = 18 THEN base_tab.h_asyst END) as h_asys18,
MAX (CASE WHEN base_tab.day_tab = 19 THEN base_tab.h_asyst END) as h_asys19,
MAX (CASE WHEN base_tab.day_tab = 20 THEN base_tab.h_asyst END) as h_asys20,
MAX (CASE WHEN base_tab.day_tab = 21 THEN base_tab.h_asyst END) as h_asys21,
MAX (CASE WHEN base_tab.day_tab = 22 THEN base_tab.h_asyst END) as h_asys22,
MAX (CASE WHEN base_tab.day_tab = 23 THEN base_tab.h_asyst END) as h_asys23,
MAX (CASE WHEN base_tab.day_tab = 24 THEN base_tab.h_asyst END) as h_asys24,
MAX (CASE WHEN base_tab.day_tab = 25 THEN base_tab.h_asyst END) as h_asys25,
MAX (CASE WHEN base_tab.day_tab = 26 THEN base_tab.h_asyst END) as h_asys26,
MAX (CASE WHEN base_tab.day_tab = 27 THEN base_tab.h_asyst END) as h_asys27,
MAX (CASE WHEN base_tab.day_tab = 28 THEN base_tab.h_asyst END) as h_asys28,
MAX (CASE WHEN base_tab.day_tab = 29 THEN base_tab.h_asyst END) as h_asys29,
MAX (CASE WHEN base_tab.day_tab = 30 THEN base_tab.h_asyst END) as h_asys30,
MAX (CASE WHEN base_tab.day_tab = 31 THEN base_tab.h_asyst END) as h_asys31,

MAX (CASE WHEN base_tab.day_tab = 1 AND base_tab.id_gr_otp is not null THEN 1 ELSE 0 END) as otp_plan1,
MAX (CASE WHEN base_tab.day_tab = 2 AND base_tab.id_gr_otp is not null THEN 1 ELSE 0 END) as otp_plan2,
MAX (CASE WHEN base_tab.day_tab = 3 AND base_tab.id_gr_otp is not null THEN 1 ELSE 0 END) as otp_plan3,
MAX (CASE WHEN base_tab.day_tab = 4 AND base_tab.id_gr_otp is not null THEN 1 ELSE 0 END) as otp_plan4,
MAX (CASE WHEN base_tab.day_tab = 5 AND base_tab.id_gr_otp is not null THEN 1 ELSE 0 END) as otp_plan5,
MAX (CASE WHEN base_tab.day_tab = 6 AND base_tab.id_gr_otp is not null THEN 1 ELSE 0 END) as otp_plan6,
MAX (CASE WHEN base_tab.day_tab = 7 AND base_tab.id_gr_otp is not null THEN 1 ELSE 0 END) as otp_plan7,
MAX (CASE WHEN base_tab.day_tab = 8 AND base_tab.id_gr_otp is not null THEN 1 ELSE 0 END) as otp_plan8,
MAX (CASE WHEN base_tab.day_tab = 9 AND base_tab.id_gr_otp is not null THEN 1 ELSE 0 END) as otp_plan9,
MAX (CASE WHEN base_tab.day_tab = 10 AND base_tab.id_gr_otp is not null THEN 1 ELSE 0 END) as otp_plan10,
MAX (CASE WHEN base_tab.day_tab = 11 AND base_tab.id_gr_otp is not null THEN 1 ELSE 0 END) as otp_plan11,
MAX (CASE WHEN base_tab.day_tab = 12 AND base_tab.id_gr_otp is not null THEN 1 ELSE 0 END) as otp_plan12,
MAX (CASE WHEN base_tab.day_tab = 13 AND base_tab.id_gr_otp is not null THEN 1 ELSE 0 END) as otp_plan13,
MAX (CASE WHEN base_tab.day_tab = 14 AND base_tab.id_gr_otp is not null THEN 1 ELSE 0 END) as otp_plan14,
MAX (CASE WHEN base_tab.day_tab = 15 AND base_tab.id_gr_otp is not null THEN 1 ELSE 0 END) as otp_plan15,
MAX (CASE WHEN base_tab.day_tab = 16 AND base_tab.id_gr_otp is not null THEN 1 ELSE 0 END) as otp_plan16,
MAX (CASE WHEN base_tab.day_tab = 17 AND base_tab.id_gr_otp is not null THEN 1 ELSE 0 END) as otp_plan17,
MAX (CASE WHEN base_tab.day_tab = 18 AND base_tab.id_gr_otp is not null THEN 1 ELSE 0 END) as otp_plan18,
MAX (CASE WHEN base_tab.day_tab = 19 AND base_tab.id_gr_otp is not null THEN 1 ELSE 0 END) as otp_plan19,
MAX (CASE WHEN base_tab.day_tab = 20 AND base_tab.id_gr_otp is not null THEN 1 ELSE 0 END) as otp_plan20,
MAX (CASE WHEN base_tab.day_tab = 21 AND base_tab.id_gr_otp is not null THEN 1 ELSE 0 END) as otp_plan21,
MAX (CASE WHEN base_tab.day_tab = 22 AND base_tab.id_gr_otp is not null THEN 1 ELSE 0 END) as otp_plan22,
MAX (CASE WHEN base_tab.day_tab = 23 AND base_tab.id_gr_otp is not null THEN 1 ELSE 0 END) as otp_plan23,
MAX (CASE WHEN base_tab.day_tab = 24 AND base_tab.id_gr_otp is not null THEN 1 ELSE 0 END) as otp_plan24,
MAX (CASE WHEN base_tab.day_tab = 25 AND base_tab.id_gr_otp is not null THEN 1 ELSE 0 END) as otp_plan25,
MAX (CASE WHEN base_tab.day_tab = 26 AND base_tab.id_gr_otp is not null THEN 1 ELSE 0 END) as otp_plan26,
MAX (CASE WHEN base_tab.day_tab = 27 AND base_tab.id_gr_otp is not null THEN 1 ELSE 0 END) as otp_plan27,
MAX (CASE WHEN base_tab.day_tab = 28 AND base_tab.id_gr_otp is not null THEN 1 ELSE 0 END) as otp_plan28,
MAX (CASE WHEN base_tab.day_tab = 29 AND base_tab.id_gr_otp is not null THEN 1 ELSE 0 END) as otp_plan29,
MAX (CASE WHEN base_tab.day_tab = 30 AND base_tab.id_gr_otp is not null THEN 1 ELSE 0 END) as otp_plan30,
MAX (CASE WHEN base_tab.day_tab = 31 AND base_tab.id_gr_otp is not null THEN 1 ELSE 0 END) as otp_plan31,

MAX (CASE WHEN base_tab.day_tab = 1 THEN base_tab.type_absence END) as absence1,
MAX (CASE WHEN base_tab.day_tab = 2 THEN base_tab.type_absence END) as absence2,
MAX (CASE WHEN base_tab.day_tab = 3 THEN base_tab.type_absence END) as absence3,
MAX (CASE WHEN base_tab.day_tab = 4 THEN base_tab.type_absence END) as absence4,
MAX (CASE WHEN base_tab.day_tab = 5 THEN base_tab.type_absence END) as absence5,
MAX (CASE WHEN base_tab.day_tab = 6 THEN base_tab.type_absence END) as absence6,
MAX (CASE WHEN base_tab.day_tab = 7 THEN base_tab.type_absence END) as absence7,
MAX (CASE WHEN base_tab.day_tab = 8 THEN base_tab.type_absence END) as absence8,
MAX (CASE WHEN base_tab.day_tab = 9 THEN base_tab.type_absence END) as absence9,
MAX (CASE WHEN base_tab.day_tab = 10 THEN base_tab.type_absence END) as absence10,
MAX (CASE WHEN base_tab.day_tab = 11 THEN base_tab.type_absence END) as absence11,
MAX (CASE WHEN base_tab.day_tab = 12 THEN base_tab.type_absence END) as absence12,
MAX (CASE WHEN base_tab.day_tab = 13 THEN base_tab.type_absence END) as absence13,
MAX (CASE WHEN base_tab.day_tab = 14 THEN base_tab.type_absence END) as absence14,
MAX (CASE WHEN base_tab.day_tab = 15 THEN base_tab.type_absence END) as absence15,
MAX (CASE WHEN base_tab.day_tab = 16 THEN base_tab.type_absence END) as absence16,
MAX (CASE WHEN base_tab.day_tab = 17 THEN base_tab.type_absence END) as absence17,
MAX (CASE WHEN base_tab.day_tab = 18 THEN base_tab.type_absence END) as absence18,
MAX (CASE WHEN base_tab.day_tab = 19 THEN base_tab.type_absence END) as absence19,
MAX (CASE WHEN base_tab.day_tab = 20 THEN base_tab.type_absence END) as absence20,
MAX (CASE WHEN base_tab.day_tab = 21 THEN base_tab.type_absence END) as absence21,
MAX (CASE WHEN base_tab.day_tab = 22 THEN base_tab.type_absence END) as absence22,
MAX (CASE WHEN base_tab.day_tab = 23 THEN base_tab.type_absence END) as absence23,
MAX (CASE WHEN base_tab.day_tab = 24 THEN base_tab.type_absence END) as absence24,
MAX (CASE WHEN base_tab.day_tab = 25 THEN base_tab.type_absence END) as absence25,
MAX (CASE WHEN base_tab.day_tab = 26 THEN base_tab.type_absence END) as absence26,
MAX (CASE WHEN base_tab.day_tab = 27 THEN base_tab.type_absence END) as absence27,
MAX (CASE WHEN base_tab.day_tab = 28 THEN base_tab.type_absence END) as absence28,
MAX (CASE WHEN base_tab.day_tab = 29 THEN base_tab.type_absence END) as absence29,
MAX (CASE WHEN base_tab.day_tab = 30 THEN base_tab.type_absence END) as absence30,
MAX (CASE WHEN base_tab.day_tab = 31 THEN base_tab.type_absence END) as absence31,

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
MAX (CASE WHEN base_tab.day_tab = 31 THEN base_tab.id_tab END) as id_tab31

FROM base_tab

GROUP BY 
GROUPING SETS (
(base_tab.id_sotr, base_tab.fio_sotr, base_tab.chiefs_org_str, base_tab.id_div, base_tab.name_div, base_tab.name_post, base_tab.name_brigade)
, (base_tab.name_brigade, base_tab.name_div)
)

ORDER BY
base_tab.name_div, base_tab.name_brigade, base_tab.fio_sotr
)

SELECT T.*,
CASE T.absence1 WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN T.otp_plan1 = 1 THEN 'Оп' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 1) <= CURRENT_DATE THEN T.h_plan1::text ELSE CASE WHEN T.h_plan1 is not null THEN 'Д' ELSE '' END END END END as mark1,
CASE T.absence2 WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN T.otp_plan2 = 1 THEN 'Оп' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 2) <= CURRENT_DATE THEN T.h_plan2::text ELSE CASE WHEN T.h_plan2 is not null THEN 'Д' ELSE '' END END END END as mark2,
CASE T.absence3 WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN T.otp_plan3 = 1 THEN 'Оп' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 3) <= CURRENT_DATE THEN T.h_plan3::text ELSE CASE WHEN T.h_plan3 is not null THEN 'Д' ELSE '' END END END END as mark3,
CASE T.absence4 WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN T.otp_plan4 = 1 THEN 'Оп' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 4) <= CURRENT_DATE THEN T.h_plan4::text ELSE CASE WHEN T.h_plan4 is not null THEN 'Д' ELSE '' END END END END as mark4,
CASE T.absence5 WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN T.otp_plan5 = 1 THEN 'Оп' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 5) <= CURRENT_DATE THEN T.h_plan5::text ELSE CASE WHEN T.h_plan5 is not null THEN 'Д' ELSE '' END END END END as mark5,
CASE T.absence6 WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN T.otp_plan6 = 1 THEN 'Оп' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 6) <= CURRENT_DATE THEN T.h_plan6::text ELSE CASE WHEN T.h_plan6 is not null THEN 'Д' ELSE '' END END END END as mark6,
CASE T.absence7 WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN T.otp_plan7 = 1 THEN 'Оп' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 7) <= CURRENT_DATE THEN T.h_plan7::text ELSE CASE WHEN T.h_plan7 is not null THEN 'Д' ELSE '' END END END END as mark7,
CASE T.absence8 WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN T.otp_plan8 = 1 THEN 'Оп' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 8) <= CURRENT_DATE THEN T.h_plan8::text ELSE CASE WHEN T.h_plan8 is not null THEN 'Д' ELSE '' END END END END as mark8,
CASE T.absence9 WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN T.otp_plan9 = 1 THEN 'Оп' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 9) <= CURRENT_DATE THEN T.h_plan9::text ELSE CASE WHEN T.h_plan9 is not null THEN 'Д' ELSE '' END END END END as mark9,
CASE T.absence10 WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN T.otp_plan10 = 1 THEN 'Оп' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 10) <= CURRENT_DATE THEN T.h_plan10::text ELSE CASE WHEN T.h_plan10 is not null THEN 'Д' ELSE '' END END END END as mark10,
CASE T.absence11 WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN T.otp_plan11 = 1 THEN 'Оп' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 11) <= CURRENT_DATE THEN T.h_plan11::text ELSE CASE WHEN T.h_plan11 is not null THEN 'Д' ELSE '' END END END END as mark11,
CASE T.absence12 WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN T.otp_plan12 = 1 THEN 'Оп' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 12) <= CURRENT_DATE THEN T.h_plan12::text ELSE CASE WHEN T.h_plan12 is not null THEN 'Д' ELSE '' END END END END as mark12,
CASE T.absence13 WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN T.otp_plan13 = 1 THEN 'Оп' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 13) <= CURRENT_DATE THEN T.h_plan13::text ELSE CASE WHEN T.h_plan13 is not null THEN 'Д' ELSE '' END END END END as mark13,
CASE T.absence14 WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN T.otp_plan14 = 1 THEN 'Оп' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 14) <= CURRENT_DATE THEN T.h_plan14::text ELSE CASE WHEN T.h_plan14 is not null THEN 'Д' ELSE '' END END END END as mark14,
CASE T.absence15 WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN T.otp_plan15 = 1 THEN 'Оп' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 15) <= CURRENT_DATE THEN T.h_plan15::text ELSE CASE WHEN T.h_plan15 is not null THEN 'Д' ELSE '' END END END END as mark15,
CASE T.absence16 WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN T.otp_plan16 = 1 THEN 'Оп' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 16) <= CURRENT_DATE THEN T.h_plan16::text ELSE CASE WHEN T.h_plan16 is not null THEN 'Д' ELSE '' END END END END as mark16,
CASE T.absence17 WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN T.otp_plan17 = 1 THEN 'Оп' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 17) <= CURRENT_DATE THEN T.h_plan17::text ELSE CASE WHEN T.h_plan17 is not null THEN 'Д' ELSE '' END END END END as mark17,
CASE T.absence18 WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN T.otp_plan18 = 1 THEN 'Оп' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 18) <= CURRENT_DATE THEN T.h_plan18::text ELSE CASE WHEN T.h_plan18 is not null THEN 'Д' ELSE '' END END END END as mark18,
CASE T.absence19 WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN T.otp_plan19 = 1 THEN 'Оп' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 19) <= CURRENT_DATE THEN T.h_plan19::text ELSE CASE WHEN T.h_plan19 is not null THEN 'Д' ELSE '' END END END END as mark19,
CASE T.absence20 WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN T.otp_plan20 = 1 THEN 'Оп' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 20) <= CURRENT_DATE THEN T.h_plan20::text ELSE CASE WHEN T.h_plan20 is not null THEN 'Д' ELSE '' END END END END as mark20,
CASE T.absence21 WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN T.otp_plan21 = 1 THEN 'Оп' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 21) <= CURRENT_DATE THEN T.h_plan21::text ELSE CASE WHEN T.h_plan21 is not null THEN 'Д' ELSE '' END END END END as mark21,
CASE T.absence22 WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN T.otp_plan22 = 1 THEN 'Оп' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 22) <= CURRENT_DATE THEN T.h_plan22::text ELSE CASE WHEN T.h_plan22 is not null THEN 'Д' ELSE '' END END END END as mark22,
CASE T.absence23 WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN T.otp_plan23 = 1 THEN 'Оп' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 23) <= CURRENT_DATE THEN T.h_plan23::text ELSE CASE WHEN T.h_plan23 is not null THEN 'Д' ELSE '' END END END END as mark23,
CASE T.absence24 WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN T.otp_plan24 = 1 THEN 'Оп' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 24) <= CURRENT_DATE THEN T.h_plan24::text ELSE CASE WHEN T.h_plan24 is not null THEN 'Д' ELSE '' END END END END as mark24,
CASE T.absence25 WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN T.otp_plan25 = 1 THEN 'Оп' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 25) <= CURRENT_DATE THEN T.h_plan25::text ELSE CASE WHEN T.h_plan25 is not null THEN 'Д' ELSE '' END END END END as mark25,
CASE T.absence26 WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN T.otp_plan26 = 1 THEN 'Оп' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 26) <= CURRENT_DATE THEN T.h_plan26::text ELSE CASE WHEN T.h_plan26 is not null THEN 'Д' ELSE '' END END END END as mark26,
CASE T.absence27 WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN T.otp_plan27 = 1 THEN 'Оп' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 27) <= CURRENT_DATE THEN T.h_plan27::text ELSE CASE WHEN T.h_plan27 is not null THEN 'Д' ELSE '' END END END END as mark27,
CASE T.absence28 WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN T.otp_plan28 = 1 THEN 'Оп' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 28) <= CURRENT_DATE THEN T.h_plan28::text ELSE CASE WHEN T.h_plan28 is not null THEN 'Д' ELSE '' END END END END as mark28,
CASE T.absence29 WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN T.otp_plan29 = 1 THEN 'Оп' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 29) <= CURRENT_DATE THEN T.h_plan29::text ELSE CASE WHEN T.h_plan29 is not null THEN 'Д' ELSE '' END END END END as mark29,
CASE T.absence30 WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN T.otp_plan30 = 1 THEN 'Оп' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 30) <= CURRENT_DATE THEN T.h_plan30::text ELSE CASE WHEN T.h_plan30 is not null THEN 'Д' ELSE '' END END END END as mark30,
CASE T.absence31 WHEN 1 THEN 'О' WHEN 4 THEN 'О' WHEN 5 THEN 'О' WHEN 2 THEN 'А' WHEN 3 THEN 'Б' ELSE CASE WHEN T.otp_plan31 = 1 THEN 'Оп' ELSE CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 31) <= CURRENT_DATE THEN T.h_plan31::text ELSE CASE WHEN T.h_plan31 is not null THEN 'Д' ELSE '' END END END END as mark31,

CASE WHEN T.absence1 IN (1, 2, 3, 4, 5) THEN (SELECT c_absence FROM vars) ELSE CASE WHEN T.otp_plan1 = 1 THEN (SELECT c_vacation FROM vars) ELSE CASE WHEN T.h_plan1 is not null THEN CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 1) <= CURRENT_DATE AND T.h_asys1 + interval '30 minutes' < make_time(T.h_plan1, 0, 0) THEN (SELECT c_alert FROM vars) ELSE (SELECT c_work FROM vars) END ELSE (SELECT c_notwork FROM vars) END END END as color1,
CASE WHEN T.absence2 IN (1, 2, 3, 4, 5) THEN (SELECT c_absence FROM vars) ELSE CASE WHEN T.otp_plan2 = 1 THEN (SELECT c_vacation FROM vars) ELSE CASE WHEN T.h_plan2 is not null THEN CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 2) <= CURRENT_DATE AND T.h_asys2 + interval '30 minutes' < make_time(T.h_plan2, 0, 0) THEN (SELECT c_alert FROM vars) ELSE (SELECT c_work FROM vars) END ELSE (SELECT c_notwork FROM vars) END END END as color2,
CASE WHEN T.absence3 IN (1, 2, 3, 4, 5) THEN (SELECT c_absence FROM vars) ELSE CASE WHEN T.otp_plan3 = 1 THEN (SELECT c_vacation FROM vars) ELSE CASE WHEN T.h_plan3 is not null THEN CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 3) <= CURRENT_DATE AND T.h_asys3 + interval '30 minutes' < make_time(T.h_plan3, 0, 0) THEN (SELECT c_alert FROM vars) ELSE (SELECT c_work FROM vars) END ELSE (SELECT c_notwork FROM vars) END END END as color3,
CASE WHEN T.absence4 IN (1, 2, 3, 4, 5) THEN (SELECT c_absence FROM vars) ELSE CASE WHEN T.otp_plan4 = 1 THEN (SELECT c_vacation FROM vars) ELSE CASE WHEN T.h_plan4 is not null THEN CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 4) <= CURRENT_DATE AND T.h_asys4 + interval '30 minutes' < make_time(T.h_plan4, 0, 0) THEN (SELECT c_alert FROM vars) ELSE (SELECT c_work FROM vars) END ELSE (SELECT c_notwork FROM vars) END END END as color4,
CASE WHEN T.absence5 IN (1, 2, 3, 4, 5) THEN (SELECT c_absence FROM vars) ELSE CASE WHEN T.otp_plan5 = 1 THEN (SELECT c_vacation FROM vars) ELSE CASE WHEN T.h_plan5 is not null THEN CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 5) <= CURRENT_DATE AND T.h_asys5 + interval '30 minutes' < make_time(T.h_plan5, 0, 0) THEN (SELECT c_alert FROM vars) ELSE (SELECT c_work FROM vars) END ELSE (SELECT c_notwork FROM vars) END END END as color5,
CASE WHEN T.absence6 IN (1, 2, 3, 4, 5) THEN (SELECT c_absence FROM vars) ELSE CASE WHEN T.otp_plan6 = 1 THEN (SELECT c_vacation FROM vars) ELSE CASE WHEN T.h_plan6 is not null THEN CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 6) <= CURRENT_DATE AND T.h_asys6 + interval '30 minutes' < make_time(T.h_plan6, 0, 0) THEN (SELECT c_alert FROM vars) ELSE (SELECT c_work FROM vars) END ELSE (SELECT c_notwork FROM vars) END END END as color6,
CASE WHEN T.absence7 IN (1, 2, 3, 4, 5) THEN (SELECT c_absence FROM vars) ELSE CASE WHEN T.otp_plan7 = 1 THEN (SELECT c_vacation FROM vars) ELSE CASE WHEN T.h_plan7 is not null THEN CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 7) <= CURRENT_DATE AND T.h_asys7 + interval '30 minutes' < make_time(T.h_plan7, 0, 0) THEN (SELECT c_alert FROM vars) ELSE (SELECT c_work FROM vars) END ELSE (SELECT c_notwork FROM vars) END END END as color7,
CASE WHEN T.absence8 IN (1, 2, 3, 4, 5) THEN (SELECT c_absence FROM vars) ELSE CASE WHEN T.otp_plan8 = 1 THEN (SELECT c_vacation FROM vars) ELSE CASE WHEN T.h_plan8 is not null THEN CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 8) <= CURRENT_DATE AND T.h_asys8 + interval '30 minutes' < make_time(T.h_plan8, 0, 0) THEN (SELECT c_alert FROM vars) ELSE (SELECT c_work FROM vars) END ELSE (SELECT c_notwork FROM vars) END END END as color8,
CASE WHEN T.absence9 IN (1, 2, 3, 4, 5) THEN (SELECT c_absence FROM vars) ELSE CASE WHEN T.otp_plan9 = 1 THEN (SELECT c_vacation FROM vars) ELSE CASE WHEN T.h_plan9 is not null THEN CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 9) <= CURRENT_DATE AND T.h_asys9 + interval '30 minutes' < make_time(T.h_plan9, 0, 0) THEN (SELECT c_alert FROM vars) ELSE (SELECT c_work FROM vars) END ELSE (SELECT c_notwork FROM vars) END END END as color9,
CASE WHEN T.absence10 IN (1, 2, 3, 4, 5) THEN (SELECT c_absence FROM vars) ELSE CASE WHEN T.otp_plan10 = 1 THEN (SELECT c_vacation FROM vars) ELSE CASE WHEN T.h_plan10 is not null THEN CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 10) <= CURRENT_DATE AND T.h_asys10 + interval '30 minutes' < make_time(T.h_plan10, 0, 0) THEN (SELECT c_alert FROM vars) ELSE (SELECT c_work FROM vars) END ELSE (SELECT c_notwork FROM vars) END END END as color10,
CASE WHEN T.absence11 IN (1, 2, 3, 4, 5) THEN (SELECT c_absence FROM vars) ELSE CASE WHEN T.otp_plan11 = 1 THEN (SELECT c_vacation FROM vars) ELSE CASE WHEN T.h_plan11 is not null THEN CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 11) <= CURRENT_DATE AND T.h_asys11 + interval '30 minutes' < make_time(T.h_plan11, 0, 0) THEN (SELECT c_alert FROM vars) ELSE (SELECT c_work FROM vars) END ELSE (SELECT c_notwork FROM vars) END END END as color11,
CASE WHEN T.absence12 IN (1, 2, 3, 4, 5) THEN (SELECT c_absence FROM vars) ELSE CASE WHEN T.otp_plan12 = 1 THEN (SELECT c_vacation FROM vars) ELSE CASE WHEN T.h_plan12 is not null THEN CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 12) <= CURRENT_DATE AND T.h_asys12 + interval '30 minutes' < make_time(T.h_plan12, 0, 0) THEN (SELECT c_alert FROM vars) ELSE (SELECT c_work FROM vars) END ELSE (SELECT c_notwork FROM vars) END END END as color12,
CASE WHEN T.absence13 IN (1, 2, 3, 4, 5) THEN (SELECT c_absence FROM vars) ELSE CASE WHEN T.otp_plan13 = 1 THEN (SELECT c_vacation FROM vars) ELSE CASE WHEN T.h_plan13 is not null THEN CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 13) <= CURRENT_DATE AND T.h_asys13 + interval '30 minutes' < make_time(T.h_plan13, 0, 0) THEN (SELECT c_alert FROM vars) ELSE (SELECT c_work FROM vars) END ELSE (SELECT c_notwork FROM vars) END END END as color13,
CASE WHEN T.absence14 IN (1, 2, 3, 4, 5) THEN (SELECT c_absence FROM vars) ELSE CASE WHEN T.otp_plan14 = 1 THEN (SELECT c_vacation FROM vars) ELSE CASE WHEN T.h_plan14 is not null THEN CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 14) <= CURRENT_DATE AND T.h_asys14 + interval '30 minutes' < make_time(T.h_plan14, 0, 0) THEN (SELECT c_alert FROM vars) ELSE (SELECT c_work FROM vars) END ELSE (SELECT c_notwork FROM vars) END END END as color14,
CASE WHEN T.absence15 IN (1, 2, 3, 4, 5) THEN (SELECT c_absence FROM vars) ELSE CASE WHEN T.otp_plan15 = 1 THEN (SELECT c_vacation FROM vars) ELSE CASE WHEN T.h_plan15 is not null THEN CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 15) <= CURRENT_DATE AND T.h_asys15 + interval '30 minutes' < make_time(T.h_plan15, 0, 0) THEN (SELECT c_alert FROM vars) ELSE (SELECT c_work FROM vars) END ELSE (SELECT c_notwork FROM vars) END END END as color15,
CASE WHEN T.absence16 IN (1, 2, 3, 4, 5) THEN (SELECT c_absence FROM vars) ELSE CASE WHEN T.otp_plan16 = 1 THEN (SELECT c_vacation FROM vars) ELSE CASE WHEN T.h_plan16 is not null THEN CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 16) <= CURRENT_DATE AND T.h_asys16 + interval '30 minutes' < make_time(T.h_plan16, 0, 0) THEN (SELECT c_alert FROM vars) ELSE (SELECT c_work FROM vars) END ELSE (SELECT c_notwork FROM vars) END END END as color16,
CASE WHEN T.absence17 IN (1, 2, 3, 4, 5) THEN (SELECT c_absence FROM vars) ELSE CASE WHEN T.otp_plan17 = 1 THEN (SELECT c_vacation FROM vars) ELSE CASE WHEN T.h_plan17 is not null THEN CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 17) <= CURRENT_DATE AND T.h_asys17 + interval '30 minutes' < make_time(T.h_plan17, 0, 0) THEN (SELECT c_alert FROM vars) ELSE (SELECT c_work FROM vars) END ELSE (SELECT c_notwork FROM vars) END END END as color17,
CASE WHEN T.absence18 IN (1, 2, 3, 4, 5) THEN (SELECT c_absence FROM vars) ELSE CASE WHEN T.otp_plan18 = 1 THEN (SELECT c_vacation FROM vars) ELSE CASE WHEN T.h_plan18 is not null THEN CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 18) <= CURRENT_DATE AND T.h_asys18 + interval '30 minutes' < make_time(T.h_plan18, 0, 0) THEN (SELECT c_alert FROM vars) ELSE (SELECT c_work FROM vars) END ELSE (SELECT c_notwork FROM vars) END END END as color18,
CASE WHEN T.absence19 IN (1, 2, 3, 4, 5) THEN (SELECT c_absence FROM vars) ELSE CASE WHEN T.otp_plan19 = 1 THEN (SELECT c_vacation FROM vars) ELSE CASE WHEN T.h_plan19 is not null THEN CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 19) <= CURRENT_DATE AND T.h_asys19 + interval '30 minutes' < make_time(T.h_plan19, 0, 0) THEN (SELECT c_alert FROM vars) ELSE (SELECT c_work FROM vars) END ELSE (SELECT c_notwork FROM vars) END END END as color19,
CASE WHEN T.absence20 IN (1, 2, 3, 4, 5) THEN (SELECT c_absence FROM vars) ELSE CASE WHEN T.otp_plan20 = 1 THEN (SELECT c_vacation FROM vars) ELSE CASE WHEN T.h_plan20 is not null THEN CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 20) <= CURRENT_DATE AND T.h_asys20 + interval '30 minutes' < make_time(T.h_plan20, 0, 0) THEN (SELECT c_alert FROM vars) ELSE (SELECT c_work FROM vars) END ELSE (SELECT c_notwork FROM vars) END END END as color20,
CASE WHEN T.absence21 IN (1, 2, 3, 4, 5) THEN (SELECT c_absence FROM vars) ELSE CASE WHEN T.otp_plan21 = 1 THEN (SELECT c_vacation FROM vars) ELSE CASE WHEN T.h_plan21 is not null THEN CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 21) <= CURRENT_DATE AND T.h_asys21 + interval '30 minutes' < make_time(T.h_plan21, 0, 0) THEN (SELECT c_alert FROM vars) ELSE (SELECT c_work FROM vars) END ELSE (SELECT c_notwork FROM vars) END END END as color21,
CASE WHEN T.absence22 IN (1, 2, 3, 4, 5) THEN (SELECT c_absence FROM vars) ELSE CASE WHEN T.otp_plan22 = 1 THEN (SELECT c_vacation FROM vars) ELSE CASE WHEN T.h_plan22 is not null THEN CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 22) <= CURRENT_DATE AND T.h_asys22 + interval '30 minutes' < make_time(T.h_plan22, 0, 0) THEN (SELECT c_alert FROM vars) ELSE (SELECT c_work FROM vars) END ELSE (SELECT c_notwork FROM vars) END END END as color22,
CASE WHEN T.absence23 IN (1, 2, 3, 4, 5) THEN (SELECT c_absence FROM vars) ELSE CASE WHEN T.otp_plan23 = 1 THEN (SELECT c_vacation FROM vars) ELSE CASE WHEN T.h_plan23 is not null THEN CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 23) <= CURRENT_DATE AND T.h_asys23 + interval '30 minutes' < make_time(T.h_plan23, 0, 0) THEN (SELECT c_alert FROM vars) ELSE (SELECT c_work FROM vars) END ELSE (SELECT c_notwork FROM vars) END END END as color23,
CASE WHEN T.absence24 IN (1, 2, 3, 4, 5) THEN (SELECT c_absence FROM vars) ELSE CASE WHEN T.otp_plan24 = 1 THEN (SELECT c_vacation FROM vars) ELSE CASE WHEN T.h_plan24 is not null THEN CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 24) <= CURRENT_DATE AND T.h_asys24 + interval '30 minutes' < make_time(T.h_plan24, 0, 0) THEN (SELECT c_alert FROM vars) ELSE (SELECT c_work FROM vars) END ELSE (SELECT c_notwork FROM vars) END END END as color24,
CASE WHEN T.absence25 IN (1, 2, 3, 4, 5) THEN (SELECT c_absence FROM vars) ELSE CASE WHEN T.otp_plan25 = 1 THEN (SELECT c_vacation FROM vars) ELSE CASE WHEN T.h_plan25 is not null THEN CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 25) <= CURRENT_DATE AND T.h_asys25 + interval '30 minutes' < make_time(T.h_plan25, 0, 0) THEN (SELECT c_alert FROM vars) ELSE (SELECT c_work FROM vars) END ELSE (SELECT c_notwork FROM vars) END END END as color25,
CASE WHEN T.absence26 IN (1, 2, 3, 4, 5) THEN (SELECT c_absence FROM vars) ELSE CASE WHEN T.otp_plan26 = 1 THEN (SELECT c_vacation FROM vars) ELSE CASE WHEN T.h_plan26 is not null THEN CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 26) <= CURRENT_DATE AND T.h_asys26 + interval '30 minutes' < make_time(T.h_plan26, 0, 0) THEN (SELECT c_alert FROM vars) ELSE (SELECT c_work FROM vars) END ELSE (SELECT c_notwork FROM vars) END END END as color26,
CASE WHEN T.absence27 IN (1, 2, 3, 4, 5) THEN (SELECT c_absence FROM vars) ELSE CASE WHEN T.otp_plan27 = 1 THEN (SELECT c_vacation FROM vars) ELSE CASE WHEN T.h_plan27 is not null THEN CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 27) <= CURRENT_DATE AND T.h_asys27 + interval '30 minutes' < make_time(T.h_plan27, 0, 0) THEN (SELECT c_alert FROM vars) ELSE (SELECT c_work FROM vars) END ELSE (SELECT c_notwork FROM vars) END END END as color27,
CASE WHEN T.absence28 IN (1, 2, 3, 4, 5) THEN (SELECT c_absence FROM vars) ELSE CASE WHEN T.otp_plan28 = 1 THEN (SELECT c_vacation FROM vars) ELSE CASE WHEN T.h_plan28 is not null THEN CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 28) <= CURRENT_DATE AND T.h_asys28 + interval '30 minutes' < make_time(T.h_plan28, 0, 0) THEN (SELECT c_alert FROM vars) ELSE (SELECT c_work FROM vars) END ELSE (SELECT c_notwork FROM vars) END END END as color28,
CASE WHEN T.absence29 IN (1, 2, 3, 4, 5) THEN (SELECT c_absence FROM vars) ELSE CASE WHEN T.otp_plan29 = 1 THEN (SELECT c_vacation FROM vars) ELSE CASE WHEN T.h_plan29 is not null THEN CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 29) <= CURRENT_DATE AND T.h_asys29 + interval '30 minutes' < make_time(T.h_plan29, 0, 0) THEN (SELECT c_alert FROM vars) ELSE (SELECT c_work FROM vars) END ELSE (SELECT c_notwork FROM vars) END END END as color29,
CASE WHEN T.absence30 IN (1, 2, 3, 4, 5) THEN (SELECT c_absence FROM vars) ELSE CASE WHEN T.otp_plan30 = 1 THEN (SELECT c_vacation FROM vars) ELSE CASE WHEN T.h_plan30 is not null THEN CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 30) <= CURRENT_DATE AND T.h_asys30 + interval '30 minutes' < make_time(T.h_plan30, 0, 0) THEN (SELECT c_alert FROM vars) ELSE (SELECT c_work FROM vars) END ELSE (SELECT c_notwork FROM vars) END END END as color30,
CASE WHEN T.absence31 IN (1, 2, 3, 4, 5) THEN (SELECT c_absence FROM vars) ELSE CASE WHEN T.otp_plan31 = 1 THEN (SELECT c_vacation FROM vars) ELSE CASE WHEN T.h_plan31 is not null THEN CASE WHEN make_date((SELECT year_tab FROM vars), (SELECT month_tab FROM vars), 31) <= CURRENT_DATE AND T.h_asys31 + interval '30 minutes' < make_time(T.h_plan31, 0, 0) THEN (SELECT c_alert FROM vars) ELSE (SELECT c_work FROM vars) END ELSE (SELECT c_notwork FROM vars) END END END as color31

FROM T
WHERE T.fio_sotr is not null