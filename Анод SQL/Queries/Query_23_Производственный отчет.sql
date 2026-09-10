     WITH plan_bounds AS (
          -- Один раз считываем границы периода из записи фильтра
             SELECT attr_2089_ AS p_start,
                    attr_2090_ AS p_end
               FROM registry.object_606_
              WHERE id = 74
          ),
          pos_order AS (
             SELECT o.id AS pos_id,
                    (
                       SELECT COALESCE( BOOL_OR( v.val >= pb.p_start AND v.val <= pb.p_end ), FALSE )
                         FROM (
                                 VALUES (comp.attr_1623_), (comp.attr_1643_), (comp.attr_1545_), (comp.attr_1548_), (comp.attr_1551_),
                                        (comp.attr_1554_), (comp.attr_1557_), (comp.attr_1560_), (comp.attr_1563_)
                              ) AS v (val),
                              plan_bounds pb
                    ) AS in_period,
                    manufact_order.attr_607_ AS num_order,
                    partners.attr_29_ AS customer,
                    o.attr_1574_ AS pos_designation
               FROM registry.object_1227_ o
              CROSS JOIN plan_bounds pb -- Оптимизация для планировщика запросов, он видит константы на этапе планирования
          LEFT JOIN registry.object_606_ manufact_order ON manufact_order.id = o.attr_1923_
                AND manufact_order.is_deleted IS FALSE
          LEFT JOIN registry.object_4_ partners ON partners.id = manufact_order.attr_2438_
                AND partners.is_deleted IS FALSE
          LEFT JOIN registry.object_1409_ comp ON comp.attr_1423_ = o.ID
                AND comp.is_deleted IS FALSE
                AND comp.attr_1414_ IS NULL
              WHERE o.is_deleted IS FALSE
                AND o.attr_1948_ <> 1
          ),
          max_accept_step AS (
             SELECT attr_2148_,
                    MAX(attr_3208_) AS step
               FROM registry.object_2138_
              WHERE is_deleted IS FALSE
                AND attr_2152_ IS NOT NULL
           GROUP BY attr_2148_
          ),
          pos_data AS (
             SELECT pos_order.pos_id,
                    pos_order.num_order,
                    pos_order.customer,
                    pos_order.pos_designation,
                    /*---------раскомментировать при тестировании----------*/
                    SUM(t_op.attr_1443_ * comp.attr_1896_) AS sum_norm,
                    SUM(to_accept.attr_3373_ * comp.attr_1896_) AS sum_getOTK
                    /*-----------------------------------------------------*/
                    /*----------закомментировать при тестировании----------
                    comp.ID AS comp_id,
                    comp.attr_1421_,
                    comp.attr_1896_ AS comp_quant,
                    comp_task.attr_3203_ AS nomen_id,
                    comp_task.ID AS comp_task_id,
                    comp.attr_1430_,
                    comp.attr_1431_,
                    comp.attr_4085_ AS tech_card_id,
                    t_op.attr_613_ AS to_step,
                    t_op.attr_1443_ AS norm_to,
                    COALESCE(accept_list_assembled.id, accept_list_manufactured.id)   AS accept_list_id,
                    to_accept.ID AS to_accept_id,
                    to_accept.attr_3208_ AS to_accept_step,
                    to_accept.attr_2609_ AS to_accept_getOTK,
                    to_accept.attr_3373_ AS to_accept_norm
                    -----------------------------------------------------*/
                    /*количество изделий в заказе учтено в общем количестве компонентов comp.attr_1896_*/
                    /*записи для суммирования выбираются по равенству шагов техопераций в МК и ПВ */
                    /*ПВ находятся по отдельности для сборочных и обычных компонентов для оптимизации по индексам */
               FROM pos_order
          LEFT JOIN registry.object_1409_ comp ON comp.attr_1423_ = pos_order.pos_id
                AND comp.is_deleted IS FALSE
                AND comp.attr_2042_ = 2
          LEFT JOIN registry.object_2094_ comp_task ON comp_task.attr_2100_ = comp.ID
                AND comp_task.is_deleted IS FALSE
          LEFT JOIN registry.object_527_ t_op ON comp.attr_4085_ = t_op.attr_538_
                AND t_op.is_deleted IS FALSE
          LEFT JOIN registry.object_2137_ accept_list_assembled ON accept_list_assembled.is_deleted IS FALSE
                AND comp_task.id = ANY (accept_list_assembled.attr_3904_)
          LEFT JOIN registry.object_2137_ accept_list_manufactured ON accept_list_manufactured.is_deleted IS FALSE
                AND accept_list_manufactured.attr_2632_ = comp.attr_1458_
                AND comp.attr_1414_ = ANY (accept_list_manufactured.attr_4033_)
                AND accept_list_manufactured.attr_3193_ = comp_task.attr_3175_
          LEFT JOIN max_accept_step mas ON mas.attr_2148_ = COALESCE(
                    accept_list_assembled.id,
                    accept_list_manufactured.id
                    )
          LEFT JOIN registry.object_2138_ to_accept ON to_accept.attr_2148_ = COALESCE(
                    accept_list_assembled.id,
                    accept_list_manufactured.id
                    )
                AND to_accept.is_deleted IS FALSE
                AND to_accept.attr_3208_ = t_op.attr_613_
                AND to_accept.attr_3433_ IS NULL
                AND to_accept.attr_3208_ <= mas.step
              WHERE pos_order.in_period IS TRUE
                    /*---------раскомментировать при тестировании----------
                    AND pos_order.pos_id = 2593
                    -----------------------------------------------------*/
                    /*----------закомментировать при тестировании----------*/
           GROUP BY pos_order.pos_id, pos_order.num_order, pos_order.customer, pos_order.pos_designation
                    /*-----------------------------------------------------*/
          )
   SELECT pos_id,
          pos_designation,
          num_order,
          customer,
          COALESCE(sum_norm, 0) AS sum_norm,
          COALESCE(sum_getOTK, 0) AS sum_getOTK,
          LEAST( ROUND( COALESCE(sum_getOTK * 100.0 / NULLIF(sum_norm, 0), 0), 0 ), 100 )::INT AS progress,
          1227 AS pos_obj
     FROM pos_data