select o.id,
head.attr_376_ as head,
o.attr_1455_,
nomen.attr_1223_ as obz,
nomen.attr_376_ as obz2,
o.attr_2905_ as typ,
o.attr_582_ as name,
code.attr_1525_ as kod,
o.attr_4079_ as count,
/*nomen.attr_363_ as type_nom,*/

CASE

WHEN nomen.attr_363_  IN (84,85,86,87,1,10) THEN 1
WHEN nomen.attr_363_ =2 THEN 2
WHEN nomen.attr_363_ =3 AND nomen.attr_376_ LIKE split_part(head.attr_376_, ' ', 1)||'%' THEN 3
WHEN nomen.attr_363_ =3 AND nomen.attr_376_ NOT LIKE split_part(head.attr_376_, ' ', 1)||'%' THEN 4
WHEN nomen.attr_363_ =6 AND NOT nomen.attr_4157_ THEN 5
WHEN nomen.attr_363_ =6 AND nomen.attr_4157_ THEN 6
WHEN nomen.attr_363_ IN (7,88) THEN 7
WHEN nomen.attr_363_ =82 THEN  8
WHEN nomen.attr_363_ IN (8,9,11,83) THEN  9
ELSE  10
END  type_nom,  

CASE

WHEN nomen.attr_363_  IN (84,85,86,87,1,10) THEN 'изд'
WHEN nomen.attr_363_ =2 THEN 'сб'
WHEN nomen.attr_363_ =3 THEN 'дет'
WHEN nomen.attr_363_ =6 AND NOT nomen.attr_4157_ THEN 'ГД'
WHEN nomen.attr_363_ =6 AND nomen.attr_4157_ THEN 'СтД'
WHEN nomen.attr_363_ IN (7,88) THEN 'прч'
WHEN nomen.attr_363_ =82 THEN  'МвС'
WHEN nomen.attr_363_ IN (8,9,11,83) THEN  'К'
ELSE  'др'
END  name_type_nom,  

CASE
		WHEN o.attr_1456_ IN (3,8,9.10 ) THEN
		4 
                WHEN o.attr_1456_ = 1 THEN
		2
                WHEN o.attr_1456_ IN (2, 15, 16) THEN
		1
		WHEN o.attr_1456_ IN ( 6, 7 )  THEN
		3
ELSE o.attr_1456_ END typk,

/*o.attr_371_ as kol_vo,*/

o.attr_4079_ as kol_vo,

case when nomen.attr_363_ <>6 then mat.attr_401_ else null end as mat_name, 

case when t_marsh.content_op is not null then 'М' else null end as have_marsh,
case when marsh_card.attr_2554_ = true then concat(round(marsh_card.attr_1879_, 0), '*N', case when marsh_card.attr_2884_ is not null then concat('+', round(marsh_card.attr_2884_, 0)) else null end,  ', maxN=', marsh_card.attr_2555_ ) end as formula_izg,

round(marsh_card.attr_1879_, 0) as L,  
round(marsh_card.attr_1873_, 0) as D, 
round(marsh_card.attr_3220_, 0) as d_in,
round(marsh_card.attr_1875_, 0) as B, 
round(marsh_card.attr_1874_, 0) as s, 
round(marsh_card.attr_3271_, 4) as massa,

t_otrez.sum_time_op*o.attr_4079_ as otrez_op,
t_tokrn.sum_time_op*o.attr_4079_ as tokrn_op,
t_frez.sum_time_op*o.attr_4079_ as frez_op,
t_rast.sum_time_op*o.attr_4079_ as rast_op,
t_sverl.sum_time_op*o.attr_4079_ as sverl_op,
t_dolb.sum_time_op*o.attr_4079_ as dolb_op,
t_shlif.sum_time_op*o.attr_4079_ as shlif_op,
t_svar.sum_time_op*o.attr_4079_ as svar_op,
t_sles.sum_time_op*o.attr_4079_ as sles_op,
t_term.sum_time_op*o.attr_4079_ as term_op,
t_pokr.sum_time_op*o.attr_4079_ as pokr_op,
t_sles_sbor.sum_time_op*o.attr_4079_ as sles_sbor_op,
t_tokr1.sum_time_op*o.attr_4079_ as tokr1_op,
t_tokr_s_chpy.sum_time_op*o.attr_4079_ as tokr_s_chpy_op,
t_frez_s_chpy.sum_time_op*o.attr_4079_ as frez_s_chpy_op,
t_rast_s_chpy.sum_time_op*o.attr_4079_ as rast_s_chpy_op,


t_gravirov.sum_time_op*o.attr_4079_ as gravirov_op,
t_komplekt.sum_time_op*o.attr_4079_ as komplekt_op,
t_kontrol.sum_time_op*o.attr_4079_ as kontrol_op,
t_markir.sum_time_op*o.attr_4079_ as markir_op,
t_opres.sum_time_op*o.attr_4079_ as opres_op,
t_preamb.sum_time_op*o.attr_4079_ as preamb_op,
t_pritir.sum_time_op*o.attr_4079_ as pritir_op,
t_razval.sum_time_op*o.attr_4079_ as razval_op,
t_elektro.sum_time_op*o.attr_4079_ as elektro_op,

t_another.sum_time_op*o.attr_4079_ as another_op,
t_marsh.content_op as marsh_op,

(case when t_otrez.sum_time_op*o.attr_4079_ is not null then t_otrez.sum_time_op*o.attr_4079_ else 0 end+
 case when t_tokrn.sum_time_op*o.attr_4079_ is not null then t_tokrn.sum_time_op*o.attr_4079_ else 0 end+
 case when t_frez.sum_time_op*o.attr_4079_ is not null then t_frez.sum_time_op*o.attr_4079_ else 0 end +
 case when t_rast.sum_time_op*o.attr_4079_ is not null then t_rast.sum_time_op*o.attr_4079_ else 0 end +
 case when t_sverl.sum_time_op*o.attr_4079_ is not null then t_sverl.sum_time_op*o.attr_4079_ else 0 end +
 case when t_dolb.sum_time_op*o.attr_4079_ is not null then t_dolb.sum_time_op*o.attr_4079_ else 0 end +
 case when t_shlif.sum_time_op*o.attr_4079_ is not null then t_shlif.sum_time_op*o.attr_4079_ else 0 end +
 case when t_svar.sum_time_op*o.attr_4079_ is not null then t_svar.sum_time_op*o.attr_4079_ else 0 end +
 case when t_sles.sum_time_op*o.attr_4079_ is not null then t_sles.sum_time_op*o.attr_4079_ else 0 end +
 case when t_term.sum_time_op*o.attr_4079_ is not null then t_term.sum_time_op*o.attr_4079_  else 0 end +
 case when t_pokr.sum_time_op*o.attr_4079_ is not null then t_pokr.sum_time_op*o.attr_4079_ else 0 end +
 case when t_sles_sbor.sum_time_op*o.attr_4079_ is not null then t_sles_sbor.sum_time_op*o.attr_4079_ else 0 end +
 case when t_tokr1.sum_time_op*o.attr_4079_ is not null then t_tokr1.sum_time_op*o.attr_4079_ else 0 end +
 case when t_tokr_s_chpy.sum_time_op*o.attr_4079_ is not null then t_tokr_s_chpy.sum_time_op*o.attr_4079_ else 0 end +
 case when t_frez_s_chpy.sum_time_op*o.attr_4079_ is not null then t_frez_s_chpy.sum_time_op*o.attr_4079_  else 0 end +
 case when t_rast_s_chpy.sum_time_op*o.attr_4079_ is not null then t_rast_s_chpy.sum_time_op*o.attr_4079_ else 0 end +
 case when t_another.sum_time_op*o.attr_4079_ is not null then t_another.sum_time_op*o.attr_4079_ else 0 end) as sum_time


from registry.object_369_ o

left join registry.object_301_ nomen on o.attr_370_ = nomen.id and nomen.is_deleted<>true
left join registry.object_519_ mk2 on mk2.attr_520_= o.attr_370_ and mk2.attr_2908_ is true and mk2.is_deleted =false
left join registry.object_301_ code on o.attr_370_=code.id
left join registry.object_301_ head on o.attr_374_=head.id

left join registry.object_400_ mat on nomen.attr_526_=mat.id and mat.is_deleted<>true
left join registry.object_519_ marsh_card on marsh_card.attr_520_= nomen.id and marsh_card.is_deleted<>true and marsh_card.attr_2908_ = true

left join (select o.attr_538_ as marsh_card_id, sum(o.attr_1443_) as sum_time_op
from registry.object_527_ o
where o.is_deleted<>true and o.attr_586_=39
group by o.attr_538_ 
) t_otrez on t_otrez.marsh_card_id=marsh_card.id
left join (select o.attr_538_ as marsh_card_id, sum(o.attr_1443_) as sum_time_op
from registry.object_527_ o
where o.is_deleted<>true and o.attr_586_=40
group by o.attr_538_ 
) t_tokrn on t_tokrn.marsh_card_id=marsh_card.id
left join (select o.attr_538_ as marsh_card_id, sum(o.attr_1443_) as sum_time_op
from registry.object_527_ o
where o.is_deleted<>true and o.attr_586_=42
group by o.attr_538_ 
) t_frez on t_frez.marsh_card_id=marsh_card.id
left join (select o.attr_538_ as marsh_card_id, sum(o.attr_1443_) as sum_time_op
from registry.object_527_ o
where o.is_deleted<>true and o.attr_586_=43
group by o.attr_538_ 
) t_rast on t_rast.marsh_card_id=marsh_card.id
left join (select o.attr_538_ as marsh_card_id, sum(o.attr_1443_) as sum_time_op
from registry.object_527_ o
where o.is_deleted<>true and o.attr_586_=47
group by o.attr_538_ 
) t_sverl on t_sverl.marsh_card_id=marsh_card.id
left join (select o.attr_538_ as marsh_card_id, sum(o.attr_1443_) as sum_time_op
from registry.object_527_ o
where o.is_deleted<>true and o.attr_586_=45
group by o.attr_538_ 
) t_dolb on t_dolb.marsh_card_id=marsh_card.id
left join (select o.attr_538_ as marsh_card_id, sum(o.attr_1443_) as sum_time_op
from registry.object_527_ o
where o.is_deleted<>true and o.attr_586_=51
group by o.attr_538_ 
) t_shlif on t_shlif.marsh_card_id=marsh_card.id
left join (select o.attr_538_ as marsh_card_id, sum(o.attr_1443_) as sum_time_op
from registry.object_527_ o
where o.is_deleted<>true and o.attr_586_=49
group by o.attr_538_ 
) t_svar on t_svar.marsh_card_id=marsh_card.id
left join (select o.attr_538_ as marsh_card_id, sum(o.attr_1443_) as sum_time_op
from registry.object_527_ o
where o.is_deleted<>true and o.attr_586_=44
group by o.attr_538_ 
) t_sles on t_sles.marsh_card_id=marsh_card.id
left join (select o.attr_538_ as marsh_card_id, sum(o.attr_1443_) as sum_time_op
from registry.object_527_ o
where o.is_deleted<>true and o.attr_586_=41
group by o.attr_538_ 
) t_term on t_term.marsh_card_id=marsh_card.id
left join (select o.attr_538_ as marsh_card_id, sum(o.attr_1443_) as sum_time_op
from registry.object_527_ o
where o.is_deleted<>true and o.attr_586_=50
group by o.attr_538_ 
) t_pokr on t_pokr.marsh_card_id=marsh_card.id
left join (select o.attr_538_ as marsh_card_id, sum(o.attr_1443_) as sum_time_op
from registry.object_527_ o
where o.is_deleted<>true and o.attr_586_=55
group by o.attr_538_ 
) t_sles_sbor on t_sles_sbor.marsh_card_id=marsh_card.id

left join (select o.attr_538_ as marsh_card_id, array_to_string(array_agg(concat('Шаг №', o.attr_613_,' - ', o.attr_2863_)), '\n') as content_op
from registry.object_527_ o
where o.is_deleted<>true and o.attr_586_=53
group by o.attr_538_ 
) t_marsh on t_marsh.marsh_card_id=marsh_card.id

left join (select o.attr_538_ as marsh_card_id, sum(o.attr_1443_) as sum_time_op
from registry.object_527_ o
where o.is_deleted<>true and o.attr_586_=46
group by o.attr_538_ 
) t_tokr1 on t_tokr1.marsh_card_id=marsh_card.id

left join (select o.attr_538_ as marsh_card_id, sum(o.attr_1443_) as sum_time_op
from registry.object_527_ o
where o.is_deleted<>true and o.attr_586_=33
group by o.attr_538_ 
) t_tokr_s_chpy on t_tokr_s_chpy.marsh_card_id=marsh_card.id

left join (select o.attr_538_ as marsh_card_id, sum(o.attr_1443_) as sum_time_op
from registry.object_527_ o
where o.is_deleted<>true and o.attr_586_=60
group by o.attr_538_ 
) t_frez_s_chpy on t_frez_s_chpy.marsh_card_id=marsh_card.id

left join (select o.attr_538_ as marsh_card_id, sum(o.attr_1443_) as sum_time_op
from registry.object_527_ o
where o.is_deleted<>true and o.attr_586_=59
group by o.attr_538_ 
) t_rast_s_chpy on t_rast_s_chpy.marsh_card_id=marsh_card.id

/*Гравировальная*/

left join (select o.attr_538_ as marsh_card_id, sum(o.attr_1443_) as sum_time_op
from registry.object_527_ o
where o.is_deleted<>true and o.attr_586_=62
group by o.attr_538_ 
) t_gravirov on t_gravirov.marsh_card_id=marsh_card.id

/*Комплектовочная*/

left join (select o.attr_538_ as marsh_card_id, sum(o.attr_1443_) as sum_time_op
from registry.object_527_ o
where o.is_deleted<>true and o.attr_586_=54
group by o.attr_538_ 
) t_komplekt on t_komplekt.marsh_card_id=marsh_card.id

/*Контрольная*/

left join (select o.attr_538_ as marsh_card_id, sum(o.attr_1443_) as sum_time_op
from registry.object_527_ o
where o.is_deleted<>true and o.attr_586_=38
group by o.attr_538_ 
) t_kontrol on t_kontrol.marsh_card_id=marsh_card.id

/*Маркировочная*/

left join (select o.attr_538_ as marsh_card_id, sum(o.attr_1443_) as sum_time_op
from registry.object_527_ o
where o.is_deleted<>true and o.attr_586_=57
group by o.attr_538_ 
) t_markir on t_markir.marsh_card_id=marsh_card.id

/*Опрессовочная*/

left join (select o.attr_538_ as marsh_card_id, sum(o.attr_1443_) as sum_time_op
from registry.object_527_ o
where o.is_deleted<>true and o.attr_586_=56
group by o.attr_538_ 
) t_opres on t_opres.marsh_card_id=marsh_card.id

/*Преамбула*/

left join (select o.attr_538_ as marsh_card_id, sum(o.attr_1443_) as sum_time_op
from registry.object_527_ o
where o.is_deleted<>true and o.attr_586_=52
group by o.attr_538_ 
) t_preamb on t_preamb.marsh_card_id=marsh_card.id

/*Притирочная*/

left join (select o.attr_538_ as marsh_card_id, sum(o.attr_1443_) as sum_time_op
from registry.object_527_ o
where o.is_deleted<>true and o.attr_586_=63
group by o.attr_538_ 
) t_pritir on t_pritir.marsh_card_id=marsh_card.id

/*Развальцовка*/

left join (select o.attr_538_ as marsh_card_id, sum(o.attr_1443_) as sum_time_op
from registry.object_527_ o
where o.is_deleted<>true and o.attr_586_=48
group by o.attr_538_ 
) t_razval on t_razval.marsh_card_id=marsh_card.id

/*Электроэрозионная*/

left join (select o.attr_538_ as marsh_card_id, sum(o.attr_1443_) as sum_time_op
from registry.object_527_ o
where o.is_deleted<>true and o.attr_586_=61
group by o.attr_538_ 
) t_elektro on t_elektro.marsh_card_id=marsh_card.id

left join (select o.attr_538_ as marsh_card_id, sum(o.attr_1443_) as sum_time_op
from registry.object_527_ o
where o.is_deleted<>true and o.attr_586_ not in (39, 40,42, 43,47,45,51,49,44,41,50,55,53,46,33,60,59)
group by o.attr_538_ 
) t_another on t_another.marsh_card_id=marsh_card.id


where o.is_deleted<>true and o.attr_374_= '{superid}'


ORDER BY type_nom, CASE
when nomen.attr_363_=3 then nomen.attr_376_
else o.attr_582_
end

