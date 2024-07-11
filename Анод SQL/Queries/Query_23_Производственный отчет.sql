     WITH pos_order AS (
             SELECT o.id AS pos_order_id
                  , CASE
                              WHEN (
                              comp.attr_1623_ >= week_plan_order.attr_2089_
                                    AND comp.attr_1623_ <= week_plan_order.attr_2090_
                                        )
                                     OR (
                                        comp.attr_1643_ >= week_plan_order.attr_2089_
                                    AND comp.attr_1643_ <= week_plan_order.attr_2090_
                                        )
                                     OR (
                                        comp.attr_1545_ >= week_plan_order.attr_2089_
                                    AND comp.attr_1545_ <= week_plan_order.attr_2090_
                                        )
                                     OR (
                                        comp.attr_1548_ >= week_plan_order.attr_2089_
                                    AND comp.attr_1548_ <= week_plan_order.attr_2090_
                                        )
                                     OR (
                                        comp.attr_1551_ >= week_plan_order.attr_2089_
                                    AND comp.attr_1551_ <= week_plan_order.attr_2090_
                                        )
                                     OR (
                                        comp.attr_1554_ >= week_plan_order.attr_2089_
                                    AND comp.attr_1554_ <= week_plan_order.attr_2090_
                                        )
                                     OR (
                                        comp.attr_1557_ >= week_plan_order.attr_2089_
                                    AND comp.attr_1557_ <= week_plan_order.attr_2090_
                                        )
                                     OR (
                                        comp.attr_1560_ >= week_plan_order.attr_2089_
                                    AND comp.attr_1560_ <= week_plan_order.attr_2090_
                                        )
                                     OR (
                                        comp.attr_1563_ >= week_plan_order.attr_2089_
                                    AND comp.attr_1563_ <= week_plan_order.attr_2090_
                                        ) THEN TRUE
                                        ELSE FALSE
                    END AS pos_in_period
                  , manufact_order.attr_607_ AS num_order
                  , partners.attr_29_ AS customer
                  , o.attr_1574_ AS pos_designation
               FROM registry.object_1227_ o
          LEFT JOIN registry.object_606_ week_plan_order ON week_plan_order.id = 74
          LEFT JOIN registry.object_606_ manufact_order ON manufact_order.id = o.attr_1923_
                AND manufact_order.is_deleted IS FALSE
          LEFT JOIN registry.object_4_ partners ON partners.id = manufact_order.attr_2438_
                AND partners.is_deleted IS FALSE
          LEFT JOIN registry.object_1409_ comp ON comp.attr_1423_ = o.ID
                AND comp.is_deleted IS FALSE
                AND comp.attr_1414_ IS NULL
          )
        , pos_data AS (
             SELECT o.ID AS pos_order_id
                  , pos_order.pos_in_period AS pos_in_period
                  , pos_order.num_order AS num_order
                  , pos_order.customer AS customer
                  , pos_order.pos_designation AS pos_designation
                    /*здесь и далее - отладочная информация в комментариях*/
                    /* ,comp.ID AS comp_id,
                    comp.attr_1896_ AS comp_quant,
                    comp_task.attr_3203_.ID AS nomen_id,
                    comp_task.ID AS comp_task_id,
                    accept_list.ID AS accept_list_id,
                    to_accept.ID AS to_accept_op_id,
                    to_accept.attr_3208_ AS to_accept_step,
                    to_accept.attr_2609_ AS to_accept_getOTK,
                    to_accept.attr_3373_ AS to_accept_norm,
                    tech_card.id AS tech_card_id,
                    t_op.id AS t_op_id,
                    t_op.attr_613_ AS to_step,
                    t_op.attr_1443_ AS norm_to*/
                    /*количество изделий в заказе учтено в общем количестве компонентов comp.attr_1896_*/
                    /*записи для суммирования выбираются по равенству шагов техопераций в МК и ПВ */

                  , SUM(t_op.attr_1443_ * comp.attr_1896_) FILTER (
                        WHERE to_accept.attr_3208_ = t_op.attr_613_
                           OR to_accept.attr_3208_ IS NULL
                    )
                    --OVER (PARTITION BY o.id)
                    AS sum_norm
                  , SUM(to_accept.attr_2609_ * to_accept.attr_3373_) FILTER (
                        WHERE to_accept.attr_3208_ = t_op.attr_613_
                           OR to_accept.attr_3208_ IS NULL
                    )
                    --OVER (PARTITION BY o.id) 
                    AS sum_getOTK
               FROM registry.object_1227_ o
          LEFT JOIN pos_order ON pos_order.pos_order_id = o.id
          LEFT JOIN registry.object_1409_ comp ON comp.attr_1423_ = o.ID
                AND comp.is_deleted IS FALSE
          LEFT JOIN registry.object_2094_ comp_task ON comp_task.attr_2100_ = comp.ID
                AND comp_task.is_deleted IS FALSE
          LEFT JOIN registry.object_2137_ accept_list ON accept_list.attr_2632_ = comp_task.attr_3203_
                AND comp_task.attr_2101_::INTEGER = ANY (accept_list.attr_4033_)
                AND accept_list.is_deleted IS FALSE
          LEFT JOIN registry.object_2138_ to_accept ON to_accept.attr_2148_ = accept_list.ID
                AND to_accept.is_deleted IS FALSE
          LEFT JOIN registry.object_519_ tech_card ON (
                    CASE
                              WHEN comp.attr_1463_ = 2
                                     OR comp.attr_1421_ IN (6, 4) THEN tech_card.attr_1466_
                                        ELSE tech_card.attr_520_
                    END = CASE
                              WHEN comp.attr_1463_ = 2
                                     OR comp.attr_1421_ IN (6, 4) THEN comp.ID
                                        ELSE comp_task.attr_3203_
                    END
                    )
                AND tech_card.is_deleted IS FALSE
                    /*активная карта*/
                AND tech_card.attr_2908_ IS TRUE
          LEFT JOIN registry.object_527_ t_op ON t_op.attr_538_ = tech_card.id
              WHERE o.is_deleted IS FALSE
                AND comp.is_deleted IS FALSE
                    /*компонент не удален из состава позиции*/
                AND (
                    comp.attr_1421_ IS NULL
                 OR comp.attr_1421_ != 1
                    )
                    /*компонент входит в заказ в производство*/
                AND comp.attr_1650_ IS NOT NULL
                    /*компонент собственного производства*/
                AND comp.attr_2042_ = 2
                    /*AND o.id = 1958 
                    AND comp.id = 32446*/
           GROUP BY o.ID
                  , pos_order.pos_in_period
                  , pos_order.num_order
                  , pos_order.customer
                  , pos_order.pos_designation
                    --ORDER BY o.id, comp.ID, to_accept.attr_3208_, t_op.attr_613_		
          )
   SELECT pos_order_id
        , pos_designation
        , pos_in_period
        , num_order
        , customer
        , COALESCE(sum_norm, 0) AS sum_norm
        , COALESCE(sum_getOTK, 0) AS sum_getOTK
        , COALESCE(sum_getOTK * 100 / sum_norm, 0)::DECIMAL(4, 2) AS progress
        , 1227 AS object_pos_order
     FROM pos_data