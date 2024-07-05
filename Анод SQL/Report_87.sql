SELECT
    requirement_invoice.id
  , requirement_invoice.attr_2121_ AS n_requirement_invoice
  , accepted_list.attr_2155_ AS n_accepted_list
  , work_task.attr_2174_ AS n_work_task
  , requirement_invoice.attr_3420_ AS amount
  , orders.attr_607_ AS n_order
  , sprav_nom.attr_376_ AS article
  , sprav_comp.attr_1494_ AS component_article
  , sprav_comp.attr_362_ AS component_name
  , mat.attr_2976_ AS mat_name
  , sort.attr_401_ AS sort_name
  , tr.attr_401_ AS tr_name
  , CONCAT(
        mat.attr_2976_
      , ''
      , sort.attr_401_
      , ''
      , tr.attr_401_
    ) AS full_name_mat
  , table_requirement_invoice.attr_3422_ AS comp_amount
  , table_requirement_invoice.attr_3423_ AS sum_amount_comp
  , sprav_storage.attr_2123_ AS name_storage
FROM
    registry.object_2112_ requirement_invoice
    LEFT JOIN registry.object_2093_ work_task ON requirement_invoice.attr_2215_ = work_task.id
    AND work_task.is_deleted IS FALSE
    LEFT JOIN registry.object_2094_ comp_work_task ON requirement_invoice.attr_3415_ = comp_work_task.id
    AND comp_work_task.is_deleted IS FALSE
    LEFT JOIN registry.object_2137_ accepted_list ON accepted_list.attr_3414_ = comp_work_task.id
    AND accepted_list.is_deleted IS FALSE
    LEFT JOIN registry.object_606_ orders ON requirement_invoice.attr_3416_ = orders.id
    AND orders.is_deleted IS FALSE
    LEFT JOIN registry.object_301_ sprav_nom ON requirement_invoice.attr_3417_ = sprav_nom.id
    AND sprav_nom.is_deleted IS FALSE
    LEFT JOIN registry.object_2111_ table_requirement_invoice ON table_requirement_invoice.attr_2126_ = requirement_invoice.id
    AND table_requirement_invoice.is_deleted IS FALSE
    LEFT JOIN registry.object_301_ sprav_comp ON table_requirement_invoice.attr_2115_ = sprav_comp.id
    AND sprav_comp.is_deleted IS FALSE
    LEFT JOIN registry.object_400_ mat ON table_requirement_invoice.attr_2116_ = mat.id
    AND mat.is_deleted IS FALSE
    LEFT JOIN registry.object_400_ sort ON table_requirement_invoice.attr_2117_ = sort.id
    AND sort.is_deleted IS FALSE
    AND sort.attr_1353_ = mat.id
    LEFT JOIN registry.object_400_ tr ON table_requirement_invoice.attr_2118_ = tr.id
    AND tr.is_deleted IS FALSE
    AND tr.attr_1353_ = sort.id
    LEFT JOIN registry.object_1685_ sprav_storage ON table_requirement_invoice.attr_3424_ = sprav_storage.id
    AND sprav_storage.is_deleted IS FALSE
WHERE
    requirement_invoice.is_deleted IS FALSE
    AND requirement_invoice.id = '{superid}'
    AND table_requirement_invoice.attr_3424_ IN ({storage})