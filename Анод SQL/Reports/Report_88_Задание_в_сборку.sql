   SELECT task_work.id AS task_work_id
        , task_work.attr_2174_ AS n_task_work
        , TO_CHAR(task_work.attr_2095_, 'DD.MM.YYYY') AS date_beg
        , TO_CHAR(task_work.attr_3179_, 'DD.MM.YYYY') AS date_end
        , comp_task_work.id AS comp_task_work_id
        , comp_order.attr_1410_ AS comp_article
        , comp_order.attr_1413_ AS comp_name
        , comp_order.attr_1896_ AS sum_amount
        , accepted_list.attr_2155_ AS n_accepted_list
        , requirement_invoice.attr_2121_ AS n_requirement_invoice
     FROM registry.object_2093_ task_work
LEFT JOIN registry.object_2094_ comp_task_work ON comp_task_work.attr_2173_ = task_work.id
      AND comp_task_work.is_deleted IS FALSE
LEFT JOIN registry.object_1409_ comp_order ON comp_task_work.attr_2100_ = comp_order.id
      AND comp_order.is_deleted IS FALSE
LEFT JOIN registry.object_2137_ accepted_list ON comp_task_work.id = ANY (accepted_list.attr_3904_)
      AND accepted_list.is_deleted IS FALSE
LEFT JOIN registry.object_2112_ requirement_invoice ON requirement_invoice.attr_3415_ = comp_task_work.id
      AND requirement_invoice.attr_2215_ = task_work.id
      AND requirement_invoice.is_deleted IS FALSE
    WHERE task_work.is_deleted IS FALSE
      AND task_work.id = '{superid}'