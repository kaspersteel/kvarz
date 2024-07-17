select o.id,
component.id as component_id,
component.attr_1414_ as rod_component,
component.attr_1410_ as component,
component.attr_1413_ as name,

project.attr_1394_ as nn,
accept_list.attr_3403_ as pvn,


case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end as plan_count,
accept_list.id as pv_id,

/*Отрезная*/

(select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 39 and o1.attr_2148_ = accept_list.id) as otk_otrez,

/*Токарная1*/

(select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 46 and o1.attr_2148_ = accept_list.id) as otk_tok1,

/*Термическая*/

(select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 41 and o1.attr_2148_ = accept_list.id) as otk_term,

/*Токарная*/

(select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 40 and o1.attr_2148_ = accept_list.id and o1.attr_3208_ = (select min(o2.attr_3208_)
from registry.object_2138_ o2
where o2.is_deleted IS FALSE  and o2.attr_2149_ = 40 and o2.attr_2148_ = accept_list.id)) as otk_tokr,

/*Фрезерная*/

(select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 42 and o1.attr_2148_ = accept_list.id and o1.attr_3208_ = (select min(o2.attr_3208_)
from registry.object_2138_ o2
where o2.is_deleted IS FALSE  and o2.attr_2149_ = 42 and o2.attr_2148_ = accept_list.id)) as otk_frezer,

/*Расточная*/

(select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 43 and o1.attr_2148_ = accept_list.id and o1.attr_3208_ = (select min(o2.attr_3208_)
from registry.object_2138_ o2
where o2.is_deleted IS FALSE  and o2.attr_2149_ = 43 and o2.attr_2148_ = accept_list.id)) as otk_rast,

/*Долбежная*/

(select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 45 and o1.attr_2148_ = accept_list.id and o1.attr_3208_ = (select min(o2.attr_3208_)
from registry.object_2138_ o2
where o2.is_deleted IS FALSE  and o2.attr_2149_ = 45 and o2.attr_2148_ = accept_list.id)) as otk_dolb,

/*Шлифовальная*/

(select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 51 and o1.attr_2148_ = accept_list.id and o1.attr_3208_ = (select min(o2.attr_3208_)
from registry.object_2138_ o2
where o2.is_deleted IS FALSE  and o2.attr_2149_ = 51 and o2.attr_2148_ = accept_list.id)) as otk_shlif,

/*Сварочная*/

(select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 49 and o1.attr_2148_ = accept_list.id and o1.attr_3208_ = (select min(o2.attr_3208_)
from registry.object_2138_ o2
where o2.is_deleted IS FALSE  and o2.attr_2149_ = 49 and o2.attr_2148_ = accept_list.id)) as otk_svar,

/*Слесарная*/

(select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 44 and o1.attr_2148_ = accept_list.id and o1.attr_3208_ = (select min(o2.attr_3208_)
from registry.object_2138_ o2
where o2.is_deleted IS FALSE  and o2.attr_2149_ = 44 and o2.attr_2148_ = accept_list.id)) as otk_sles,

/*Притирочная*/

(select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 63 and o1.attr_2148_ = accept_list.id) as otk_pritir,

/*Опрессовочная*/

(select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 56 and o1.attr_2148_ = accept_list.id) as otk_opress,

/*Слесарно-сборочная*/

(select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 55 and o1.attr_2148_ = accept_list.id) as otk_sles_sbor,

/*Токарная ЧПУ*/

(select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 33 and o1.attr_2148_ = accept_list.id) as otk_tokr_chpu,

/*Расточная ЧПУ*/

(select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 59 and o1.attr_2148_ = accept_list.id) as otk_rast_chpu,

/*Фрезерная ЧПУ*/

(select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 60 and o1.attr_2148_ = accept_list.id) as otk_frezer_chpu,

/*Маршрутная*/

(select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 53 and o1.attr_2148_ = accept_list.id) as otk_marsh,

/*Комплектовочная*/

(select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 54 and o1.attr_2148_ = accept_list.id) as otk_kom,

/*Упаковочная*/

(select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 67 and o1.attr_2148_ = accept_list.id) as otk_upakov,

/*Прочие*/

(select sum(o1.attr_2609_)
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ in (62,38,57,50,52,48,47,61) and o1.attr_2148_ = accept_list.id
order by o.attr_1964_ limit 1) as otk_procheye,

/*Прочие Токарные*/

(select sum(o1.attr_2609_)
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 40 and o1.attr_2148_ = accept_list.id and o1.id != (select o1.id
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 40 and o1.attr_2148_ = accept_list.id and o1.attr_3208_ = (select min(o2.attr_3208_)
from registry.object_2138_ o2
where o2.is_deleted IS FALSE  and o2.attr_2149_ = 40 and o2.attr_2148_ = accept_list.id))) as otk_tokr_procheye,

/*Прочие Шлифовальные*/

(select sum(o1.attr_2609_)
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 51 and o1.attr_2148_ = accept_list.id and o1.id != (select o1.id
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 51 and o1.attr_2148_ = accept_list.id and o1.attr_3208_ = (select min(o2.attr_3208_)
from registry.object_2138_ o2
where o2.is_deleted IS FALSE  and o2.attr_2149_ = 51 and o2.attr_2148_ = accept_list.id))) as otk_shlif_procheye,

/*Прочие Слесарные*/

(select sum(o1.attr_2609_)
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 44 and o1.attr_2148_ = accept_list.id and o1.id != (select o1.id
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 44 and o1.attr_2148_ = accept_list.id and o1.attr_3208_ = (select min(o2.attr_3208_)
from registry.object_2138_ o2
where o2.is_deleted IS FALSE  and o2.attr_2149_ = 44 and o2.attr_2148_ = accept_list.id))) as otk_sles_procheye,

/*Прочие Фрезерные*/

(select sum(o1.attr_2609_)
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 42 and o1.attr_2148_ = accept_list.id and o1.id != (select o1.id
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 42 and o1.attr_2148_ = accept_list.id and o1.attr_3208_ = (select min(o2.attr_3208_)
from registry.object_2138_ o2
where o2.is_deleted IS FALSE  and o2.attr_2149_ = 42 and o2.attr_2148_ = accept_list.id))) as otk_frezer_procheye,


/*Отрезная-Проверка*/

case when '39' = any((select array_agg(distinct o1.attr_2149_)
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2148_ = accept_list.id and o1.attr_2150_ = accept_list.attr_2632_)::text[]) then 
(case when (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) = (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 39 and o1.attr_2148_ = accept_list.id) then 1 else 0 end) end as proverka_otrez,

/*Токарная1-Проверка*/

case when '46' = any((select array_agg(distinct o1.attr_2149_)
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2148_ = accept_list.id and o1.attr_2150_ = accept_list.attr_2632_)::text[]) then 
(case when (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) = (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 46 and o1.attr_2148_ = accept_list.id) then 1 else 0 end) end as proverka_tokr1,

/*Термическая-Проверка*/

case when '41' = any((select array_agg(distinct o1.attr_2149_)
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2148_ = accept_list.id and o1.attr_2150_ = accept_list.attr_2632_)::text[]) then 
(case when (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) = (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 41 and o1.attr_2148_ = accept_list.id) then 1 else 0 end) end as proverka_term,

/*Токарная-Проверка*/

case when '40' = any((select array_agg(distinct o1.attr_2149_)
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2148_ = accept_list.id and o1.attr_2150_ = accept_list.attr_2632_)::text[]) then 
(case when (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) = (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 40 and o1.attr_2148_ = accept_list.id and o1.attr_3208_ = (select min(o2.attr_3208_)
from registry.object_2138_ o2
where o2.is_deleted IS FALSE  and o2.attr_2149_ = 40 and o2.attr_2148_ = accept_list.id)) then 1 else 0 end) end as proverka_tokr,

/*Фрезерная-Проверка*/

case when '42' = any((select array_agg(distinct o1.attr_2149_)
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2148_ = accept_list.id and o1.attr_2150_ = accept_list.attr_2632_)::text[]) then 
(case when (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) = (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 42 and o1.attr_2148_ = accept_list.id and o1.attr_3208_ = (select min(o2.attr_3208_)
from registry.object_2138_ o2
where o2.is_deleted IS FALSE  and o2.attr_2149_ = 42 and o2.attr_2148_ = accept_list.id)) then 1 else 0 end) end as proverka_frezer,

/*Расточная-Проверка*/

case when '43' = any((select array_agg(distinct o1.attr_2149_)
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2148_ = accept_list.id and o1.attr_2150_ = accept_list.attr_2632_)::text[]) then 
(case when (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) = (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 43 and o1.attr_2148_ = accept_list.id and o1.attr_3208_ = (select min(o2.attr_3208_)
from registry.object_2138_ o2
where o2.is_deleted IS FALSE  and o2.attr_2149_ = 43 and o2.attr_2148_ = accept_list.id)) then 1 else 0 end) end as proverka_rast,

/*Долбежная-Проверка*/

case when '45' = any((select array_agg(distinct o1.attr_2149_)
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2148_ = accept_list.id and o1.attr_2150_ = accept_list.attr_2632_)::text[]) then 
(case when (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) = (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 45 and o1.attr_2148_ = accept_list.id and o1.attr_3208_ = (select min(o2.attr_3208_)
from registry.object_2138_ o2
where o2.is_deleted IS FALSE  and o2.attr_2149_ = 45 and o2.attr_2148_ = accept_list.id)) then 1 else 0 end) end as proverka_dolb,

/*Шлифовальная-Проверка*/

case when '51' = any((select array_agg(distinct o1.attr_2149_)
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2148_ = accept_list.id and o1.attr_2150_ = accept_list.attr_2632_)::text[]) then 
(case when (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) = (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 51 and o1.attr_2148_ = accept_list.id and o1.attr_3208_ = (select min(o2.attr_3208_)
from registry.object_2138_ o2
where o2.is_deleted IS FALSE  and o2.attr_2149_ = 51 and o2.attr_2148_ = accept_list.id)) then 1 else 0 end) end as proverka_shlif,

/*Сварочная-Проверка*/

case when '49' = any((select array_agg(distinct o1.attr_2149_)
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2148_ = accept_list.id and o1.attr_2150_ = accept_list.attr_2632_)::text[]) then 
(case when (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) = (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 49 and o1.attr_2148_ = accept_list.id and o1.attr_3208_ = (select min(o2.attr_3208_)
from registry.object_2138_ o2
where o2.is_deleted IS FALSE  and o2.attr_2149_ = 49 and o2.attr_2148_ = accept_list.id)) then 1 else 0 end) end as proverka_svar,

/*Слесарная-Проверка*/

case when '44' = any((select array_agg(distinct o1.attr_2149_)
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2148_ = accept_list.id and o1.attr_2150_ = accept_list.attr_2632_)::text[]) then 
(case when (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) = (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 44 and o1.attr_2148_ = accept_list.id and o1.attr_3208_ = (select min(o2.attr_3208_)
from registry.object_2138_ o2
where o2.is_deleted IS FALSE  and o2.attr_2149_ = 44 and o2.attr_2148_ = accept_list.id)) then 1 else 0 end) end as proverka_sles,

/*Притирочная-Проверка*/

case when '63' = any((select array_agg(distinct o1.attr_2149_)
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2148_ = accept_list.id and o1.attr_2150_ = accept_list.attr_2632_)::text[]) then 
(case when (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) = (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 63 and o1.attr_2148_ = accept_list.id) then 1 else 0 end) end as proverka_pritir,

/*Опрессовочная-Проверка*/

case when '56' = any((select array_agg(distinct o1.attr_2149_)
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2148_ = accept_list.id and o1.attr_2150_ = accept_list.attr_2632_)::text[]) then 
(case when (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) = (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 56 and o1.attr_2148_ = accept_list.id) then 1 else 0 end) end as proverka_opress,

/*Слесарно-сборочная-Проверка*/

case when '55' = any((select array_agg(distinct o1.attr_2149_)
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2148_ = accept_list.id and o1.attr_2150_ = accept_list.attr_2632_)::text[]) then 
(case when (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) = (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 55 and o1.attr_2148_ = accept_list.id) then 1 else 0 end) end as proverka_sles_sbor,

/*Токарная ЧПУ-Проверка*/

case when '33' = any((select array_agg(distinct o1.attr_2149_)
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2148_ = accept_list.id and o1.attr_2150_ = accept_list.attr_2632_)::text[]) then 
(case when (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) = (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 33 and o1.attr_2148_ = accept_list.id) then 1 else 0 end) end as proverka_tokr_chpu,

/*Расточная ЧПУ-Проверка*/

case when '59' = any((select array_agg(distinct o1.attr_2149_)
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2148_ = accept_list.id and o1.attr_2150_ = accept_list.attr_2632_)::text[]) then 
(case when (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) = (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 59 and o1.attr_2148_ = accept_list.id) then 1 else 0 end) end as proverka_rast_chpu,

/*Фрезерная ЧПУ-Проверка*/

case when '60' = any((select array_agg(distinct o1.attr_2149_)
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2148_ = accept_list.id and o1.attr_2150_ = accept_list.attr_2632_)::text[]) then 
(case when (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) = (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 60 and o1.attr_2148_ = accept_list.id) then 1 else 0 end) end as proverka_frezer_chpu,

/*Маршрутная-Проверка*/

case when '53' = any((select array_agg(distinct o1.attr_2149_)
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2148_ = accept_list.id and o1.attr_2150_ = accept_list.attr_2632_)::text[]) then 
(case when (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) = (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 53 and o1.attr_2148_ = accept_list.id) then 1 else 0 end) end as proverka_marsh,

/*Комплектовочная-Проверка*/

case when '54' = any((select array_agg(distinct o1.attr_2149_)
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2148_ = accept_list.id and o1.attr_2150_ = accept_list.attr_2632_)::text[]) then 
(case when (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) = (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 54 and o1.attr_2148_ = accept_list.id) then 1 else 0 end) end as proverka_kom,

/*Упаковочная-Проверка*/

case when '67' = any((select array_agg(distinct o1.attr_2149_)
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2148_ = accept_list.id and o1.attr_2150_ = accept_list.attr_2632_)::text[]) then 
(case when (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) = (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 67 and o1.attr_2148_ = accept_list.id) then 1 else 0 end) end as proverka_upakov,

/*Отрезная_Проверка2 (Если кол-во больше, чем плановое = синий)*/

case when (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 39 and o1.attr_2148_ = accept_list.id) > (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) then 'blue' end as proverka2_otrez,

/*Токарная1-Проверка2*/

case when (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 46 and o1.attr_2148_ = accept_list.id) > (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) then 'blue' end as proverka2_tokr1,

/*Термическая-Проверка2*/

case when (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 41 and o1.attr_2148_ = accept_list.id) > (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) then 'blue' end as proverka2_term,

/*Токарная-Проверка2*/

case when (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 40 and o1.attr_2148_ = accept_list.id and o1.attr_3208_ = (select min(o2.attr_3208_)
from registry.object_2138_ o2
where o2.is_deleted IS FALSE  and o2.attr_2149_ = 40 and o2.attr_2148_ = accept_list.id)) > (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) then 'blue' end as proverka2_tokr,

/*Фрезерная-Проверка2*/

case when (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 42 and o1.attr_2148_ = accept_list.id and o1.attr_3208_ = (select min(o2.attr_3208_)
from registry.object_2138_ o2
where o2.is_deleted IS FALSE  and o2.attr_2149_ = 42 and o2.attr_2148_ = accept_list.id)) > (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) then 'blue' end as proverka2_frezer,

/*Расточная-Проверка2*/

case when (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 43 and o1.attr_2148_ = accept_list.id and o1.attr_3208_ = (select min(o2.attr_3208_)
from registry.object_2138_ o2
where o2.is_deleted IS FALSE  and o2.attr_2149_ = 43 and o2.attr_2148_ = accept_list.id)) > (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) then 'blue' end as proverka2_rast,

/*Долбежная-Проверка2*/

case when (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 45 and o1.attr_2148_ = accept_list.id and o1.attr_3208_ = (select min(o2.attr_3208_)
from registry.object_2138_ o2
where o2.is_deleted IS FALSE  and o2.attr_2149_ = 45 and o2.attr_2148_ = accept_list.id)) > (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) then 'blue' end as proverka2_dolb,

/*Шлифовальная-Проверка2*/

case when (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 51 and o1.attr_2148_ = accept_list.id and o1.attr_3208_ = (select min(o2.attr_3208_)
from registry.object_2138_ o2
where o2.is_deleted IS FALSE  and o2.attr_2149_ = 51 and o2.attr_2148_ = accept_list.id)) > (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) then 'blue' end as proverka2_shlif,

/*Сварочная-Проверка2*/

case when (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 49 and o1.attr_2148_ = accept_list.id and o1.attr_3208_ = (select min(o2.attr_3208_)
from registry.object_2138_ o2
where o2.is_deleted IS FALSE  and o2.attr_2149_ = 49 and o2.attr_2148_ = accept_list.id)) > (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) then 'blue' end as proverka2_svar,

/*Слесарная-Проверка2*/

case when (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 44 and o1.attr_2148_ = accept_list.id and o1.attr_3208_ = (select min(o2.attr_3208_)
from registry.object_2138_ o2
where o2.is_deleted IS FALSE  and o2.attr_2149_ = 44 and o2.attr_2148_ = accept_list.id)) > (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) then 'blue' end as proverka2_sles,

/*Притирочная-Проверка2*/

case when (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 63 and o1.attr_2148_ = accept_list.id) > (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) then 'blue' end as proverka2_pritir,

/*Опрессовочная-Проверка2*/

case when (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 56 and o1.attr_2148_ = accept_list.id) > (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) then 'blue' end as proverka2_opress,

/*Слесарно-сборочная-Проверка2*/

case when (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 55 and o1.attr_2148_ = accept_list.id) > (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) then 'blue' end as proverka2_sles_sbor,

/*Токарная ЧПУ-Проверка2*/

case when (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 33 and o1.attr_2148_ = accept_list.id) > (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) then 'blue' end as proverka2_tokr_chpu,

/*Расточная ЧПУ-Проверка2*/

case when (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 59 and o1.attr_2148_ = accept_list.id) > (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) then 'blue' end as proverka2_rast_chpu,

/*Фрезерная ЧПУ-Проверка2*/

case when (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 60 and o1.attr_2148_ = accept_list.id) > (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) then 'blue' end as proverka2_frezer_chpu,

/*Маршрутная-Проверка2*/

case when (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 53 and o1.attr_2148_ = accept_list.id) > (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) then 'blue' end as proverka2_marsh,

/*Комплектовочная-Проверка2*/

case when (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 54 and o1.attr_2148_ = accept_list.id) > (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) then 'blue' end as proverka2_kom,

/*Упаковочная-Проверка2*/

case when (select o1.attr_2609_
from registry.object_2138_ o1
where o1.is_deleted IS FALSE  and o1.attr_2149_ = 67 and o1.attr_2148_ = accept_list.id) > (case when component.attr_1411_ in (1,2,8,9) then project.attr_1895_ else component.attr_1896_ end) then 'blue' end as proverka2_upakov


from registry.object_606_ o

left join registry.object_1227_ project on project.attr_1923_ = o.id and project.is_deleted IS FALSE 
left join registry.object_1409_ component on component.attr_1423_ = project.id and component.is_deleted IS FALSE 

/*Ссылка на ПВ*/
left join registry.object_2137_ accept_list on accept_list.attr_2632_ = component.attr_1458_ 
and accept_list.is_deleted IS FALSE  and string_to_array (component.attr_1650_, ',')::integer[] <@ accept_list.attr_2675_ 
and project.attr_1394_ ::text = any(string_to_array(accept_list.attr_3403_,'; '))

where o.is_deleted IS FALSE  and o.id =533