/*Сменный отчет ОТК*/
select 
o.date_work, 
o.fio_otk, 
o.fio_employee, 
o.accep_list_tp_id, 
o.n_acceptance_list, 
n_ords,
o.designation_article, 
o.designation_nomenclature,
o.name_nomenclature, 
o.name_tech_op, 
sum(o.amount_accapted) as sum_amount_accapted, 
sum(o.amount_deffect) as sum_amount_deffect,
sum(o.amount_rework) as sum_amount_rework,
deffect_act.number_deffect_act,
deffect_act.date_deffect_act::date,
o.gs::date

from (select  gs,
to_char(gs, 'DD.MM.YY') as date_work, 
otk.id as otk_id,
otk.attr_205_ as fio_otk, 
employee.id as employee_id,
employee.attr_205_ as fio_employee, 
subunit.attr_3405_ as name_subunit,
acceptance_list.id as accept_list_id,
acceptance_list.attr_2155_ as n_acceptance_list, 
acceptance_list_table_part.id as accep_list_tp_id, 
array_to_string(array_agg(distinct(ord.attr_607_)), ', ') as n_ords, 
array_to_string(array_agg(distinct(comp_order.attr_376_)), ',') as designation_article,
nomenclature.id as nomenclature_id,  
nomenclature.attr_1494_ as designation_nomenclature, 
nomenclature.attr_362_ as name_nomenclature, 
tech_operation.attr_547_ as name_tech_op, 

acceptance.attr_3280_ as amount_accapted, 
acceptance.attr_3282_ as amount_deffect,
acceptance.attr_3281_ as amount_rework,

acceptance_list_table_part.attr_3208_ as n_step, 
acceptance_list_table_part.attr_2149_ as id_to, 
acceptance_list.attr_2226_ as id_work_task, 
acceptance_list.attr_2167_ as id_ed_hran, 
acceptance_list.attr_3193_ as id_position_work_task


/*для теста в СУБД
from  generate_series(to_date('01/01/2023','DD.MM.YYYY'), to_date('31/12/2023','DD.MM.YYYY') , interval '1 day') as gs
*/

from generate_series(to_date('{Период.FromDate}','DD.MM.YYYY'), to_date('{Период.ToDate}','DD.MM.YYYY') , interval '1 day') as gs

left join registry.object_3273_ acceptance on acceptance.attr_3275_::date =  gs::date  and acceptance.attr_3284_ = true and acceptance.is_deleted<>true
left join registry.object_17_ otk on acceptance.attr_3278_ = otk.id and  otk.is_deleted<>true
left join registry.object_17_ employee on acceptance.attr_3279_ = employee.id and employee.is_deleted<>true
left join registry.object_3404_ subunit on acceptance.attr_3494_ = subunit.id
left join registry.object_2137_ acceptance_list on acceptance.attr_3276_ = acceptance_list.id and acceptance_list.is_deleted<>true
/*код убран из-за некорректной работы с полем acceptance_list.attr_2675_ в конструкторе
left join registry.xref_2675_ mass_order on mass_order.from_id = acceptance_list.id 
left join registry.object_606_ ord on mass_order.to_id = ord.id and ord.is_deleted<>true
left join registry.xref_3264_ mass_article on mass_article.from_id = acceptance_list.id
left join registry.object_301_ comp_order on mass_article.to_id = comp_order.id and comp_order.is_deleted<>true*/
left join registry.object_606_ ord on ord.id = ANY (acceptance_list.attr_2675_) and ord.is_deleted<>true
left join registry.object_301_ comp_order on comp_order.id = ANY (acceptance_list.attr_3264_) and comp_order.is_deleted<>true
left join registry.object_301_ nomenclature on acceptance_list.attr_2632_ = nomenclature.id and nomenclature.is_deleted<>true
left join registry.object_2138_ acceptance_list_table_part on acceptance.attr_3277_ = acceptance_list_table_part.id and acceptance_list_table_part.is_deleted<>true
left join registry.object_545_ tech_operation on  acceptance_list_table_part.attr_2149_ = tech_operation.id and tech_operation.is_deleted<>true

where acceptance.is_deleted<>true
group by gs, to_char(gs, 'DD.MM.YY'), otk.id, employee.id, subunit.attr_3405_, acceptance_list.id, tech_operation.id, acceptance_list_table_part.id, acceptance.id, nomenclature.id
 
order by employee.attr_205_, to_char(gs, 'DD.MM.YY') desc) o

left join (select	o.attr_3203_ as nom_ed, o.attr_3204_ as tech_card, o.attr_2173_, o.attr_3175_, o.attr_2203_ as ed_hran, o.attr_2104_ as mat,	o.attr_2105_ as sort, o.attr_2106_ as tr,	sum( o.attr_2103_ ) 
from	registry.object_2094_ o 
where o.is_deleted <> true
group by o.attr_3203_,	o.attr_3204_,	o.attr_2173_,	o.attr_2203_,	o.attr_2104_,	o.attr_2105_,	o.attr_2106_,	o.attr_3175_ 
order by o.attr_3203_,	o.attr_3204_,	o.attr_2203_) mass on mass.nom_ed = o.nomenclature_id and mass.attr_2173_ = o.id_work_task and mass.ed_hran= o.id_ed_hran and mass.attr_3175_ = o.id_position_work_task

left join (select o.attr_538_ as id_tech_card, o.attr_586_ as id_to, o.attr_613_ as n_step, o.attr_1443_ as norm_time  from registry.object_527_ o where o.is_deleted<>true) n_t  on mass.tech_card = n_t.id_tech_card and o.id_to = n_t.id_to and o.n_step = n_t.n_step

left join (select o.attr_3487_ as accept_act_id, o.attr_3411_ as accept_act_tp_id, o.attr_3389_ as date_deffect_act, o.attr_3399_ as sotr_otk, o.attr_3394_ as employee_id,  o.attr_3388_ as number_deffect_act   from registry.object_2612_ o where o.is_deleted<>true) deffect_act on deffect_act.accept_act_id = o.accept_list_id and deffect_act.accept_act_tp_id = o.accep_list_tp_id and deffect_act.date_deffect_act::date = o.gs::date and deffect_act.sotr_otk = o.otk_id and deffect_act.employee_id = o.employee_id



where o.fio_otk is not null or o.fio_employee is not null

group by o.date_work, o.fio_otk, o.fio_employee, o.accep_list_tp_id, o.n_acceptance_list, n_ords, o.designation_article, o.designation_nomenclature,o.name_nomenclature, o.name_tech_op, deffect_act.number_deffect_act,
deffect_act.date_deffect_act::date,
o.gs::date
order by o.fio_employee, o.date_work
