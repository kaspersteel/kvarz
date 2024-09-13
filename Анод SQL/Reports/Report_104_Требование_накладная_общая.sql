     WITH dataset AS (
             SELECT invoice.id AS id_requirement_invoice,
                    invoice.attr_2121_ AS n_requirement_invoice,
                    accepted_list.attr_2155_ AS n_accepted_list,
                    work_task.attr_2174_ AS n_work_task,
                    invoice.attr_4125_ AS invoice_amount,
                    invoice.attr_3420_ AS order_amount,
                    orders.attr_607_ AS n_order,
                    sprav_nom.attr_376_ AS article,
                    sprav_comp.attr_1494_ AS component_article,
                    sprav_comp.attr_362_ AS component_name,
                    mat.attr_2976_ AS mat_name,
                    sort.attr_401_ AS sort_name,
                    tr.attr_401_ AS tr_name,
                    CONCAT(
                    mat.attr_2976_,
                    '',
                    sort.attr_401_,
                    '',
                    tr.attr_401_
                    ) AS full_name_mat,
                    tab_invoice.attr_3422_ AS comp_amount,
                    tab_invoice.attr_3423_ AS sum_amount_comp,
                    COALESCE(remnants.attr_2574_, 16) AS "storage"
               FROM registry.object_2112_ invoice
          LEFT JOIN registry.object_2093_ work_task ON invoice.attr_2215_ = work_task.id
                AND work_task.is_deleted IS FALSE
          LEFT JOIN registry.object_2094_ comp_work_task ON invoice.attr_3415_ = comp_work_task.id
                AND comp_work_task.is_deleted IS FALSE
          LEFT JOIN registry.object_2137_ accepted_list ON accepted_list.attr_3414_ = comp_work_task.id
                AND accepted_list.is_deleted IS FALSE
          LEFT JOIN registry.object_606_ orders ON invoice.attr_3416_ = orders.id
                AND orders.is_deleted IS FALSE
          LEFT JOIN registry.object_301_ sprav_nom ON invoice.attr_3417_ = sprav_nom.id
                AND sprav_nom.is_deleted IS FALSE
          LEFT JOIN registry.object_2111_ tab_invoice ON tab_invoice.attr_2126_ = invoice.id
                AND tab_invoice.is_deleted IS FALSE
          LEFT JOIN registry.object_301_ sprav_comp ON tab_invoice.attr_2115_ = sprav_comp.id
                AND sprav_comp.is_deleted IS FALSE
          LEFT JOIN registry.object_400_ mat ON tab_invoice.attr_2116_ = mat.id
                AND mat.is_deleted IS FALSE
          LEFT JOIN registry.object_400_ sort ON tab_invoice.attr_2117_ = sort.id
                AND sort.is_deleted IS FALSE
                AND sort.attr_1353_ = mat.id
          LEFT JOIN registry.object_400_ tr ON tab_invoice.attr_2118_ = tr.id
                AND tr.is_deleted IS FALSE
                AND tr.attr_1353_ = sort.id
          LEFT JOIN registry.object_1617_ remnants ON remnants.id = COALESCE(
                    attr_4123_,
                    (
                       SELECT remnants_max.id
                         FROM (
                                 SELECT ID,
                                        attr_1618_ AS "nom_id",
                                        attr_3951_ AS "given",
                                        attr_3131_ AS "value",
                                        MAX(attr_3131_) OVER (
                                        PARTITION BY attr_1618_,
                                                  attr_3951_
                                        ) AS "max_value"
                                   FROM registry.object_1617_
                                  WHERE is_deleted IS FALSE
                                    AND attr_3131_ > 0
                                    AND attr_2574_ <> 14
                              ) remnants_max
                        WHERE remnants_max.nom_id = attr_2115_
                          AND remnants_max.given = attr_4121_
                          AND remnants_max.max_value = remnants_max.value
                        LIMIT 1
                    )
                    )
              WHERE invoice.is_deleted IS FALSE
              AND remnants.attr_3131_ >= tab_invoice.attr_3423_
          )
   SELECT dataset.*,
          sprav_storage.attr_2123_ AS name_storage
     FROM dataset
LEFT JOIN registry.object_1685_ sprav_storage ON dataset.storage = sprav_storage.id
      AND sprav_storage.is_deleted IS FALSE
    WHERE dataset.id_requirement_invoice = '{superid}'
      AND CASE
                    WHEN '{type}' = 1
                          AND dataset.storage NOT IN (14, 15, 16) THEN TRUE
                              WHEN '{type}' = 2
                          AND dataset.storage NOT IN (4, 5, 6, 9, 12, 14, 15, 16) THEN TRUE
                              WHEN '{type}' = 3
                          AND dataset.storage = '{storage}' THEN TRUE
          END