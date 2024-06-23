select 
requirement_invoice.id, 
requirement_invoice.attr_2121_  as n_requirement_invoice, 
accepted_list.attr_2155_ as n_accepted_list,
work_task.attr_2174_  as n_work_task,
requirement_invoice.attr_3420_  as amount,
orders.attr_607_ as n_order,
sprav_nom.attr_376_ as article,
sprav_comp.attr_1494_ as component_article, 
sprav_comp.attr_362_ as component_name, 
mat.attr_2976_ as mat_name, 
sort.attr_401_ as sort_name,
tr.attr_401_ as tr_name,
table_requirement_invoice.attr_3422_ as comp_amount,
table_requirement_invoice.attr_3423_ as sum_amount_comp,
spav_storage.attr_2123_ as name_storage

from registry.object_2112_ requirement_invoice

left join registry.object_2093_ work_task on requirement_invoice.attr_2215_ = work_task.id and work_task.is_deleted<>true and  work_task.is_deleted<>true

left join registry.object_2094_ comp_position_work_task on requirement_invoice.attr_3415_ = comp_position_work_task.id and  comp_position_work_task.is_deleted<>true

/*left join registry.object_2137_ accepted_list on accepted_list.attr_3414_ = comp_position_work_task.id and accepted_list.is_deleted<>true */
left join registry.object_2137_ accepted_list on comp_position_work_task.id = ANY (accepted_list.attr_3863_) and accepted_list.is_deleted<>true
left join registry.object_606_ orders on requirement_invoice.attr_3416_ = orders.id and orders.is_deleted<>true

left join registry.object_301_ sprav_nom on requirement_invoice.attr_3417_ = sprav_nom.id and  sprav_nom.is_deleted<>true

left join registry.object_2111_ table_requirement_invoice on table_requirement_invoice.attr_2126_ = requirement_invoice.id and table_requirement_invoice.is_deleted<>true

left join registry.object_301_ sprav_comp on table_requirement_invoice.attr_2115_ = sprav_comp.id

left join registry.object_400_ mat on table_requirement_invoice.attr_2116_ = mat.id

left join registry.object_400_ sort on table_requirement_invoice.attr_2117_ = sort.id

left join registry.object_400_ tr on table_requirement_invoice.attr_2118_ = tr.id

left join registry.object_1685_ spav_storage on table_requirement_invoice.attr_3424_ = spav_storage.id

where requirement_invoice.is_deleted<>true and requirement_invoice.id=  '{superid}' 