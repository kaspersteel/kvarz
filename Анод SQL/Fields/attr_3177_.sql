/*Информация о компонентах в задании*/
--SELECT
/*выбрать компоненты без единиц хранения либо список изделий по заказу list*/
          COALESCE(o.attr_3197_, STRING_AGG(DISTINCT list, '\n'))
-- registry.object_3168_ o
LEFT JOIN (
             SELECT o.id
                  , CONCAT_WS(
                    ' - '
                  , CONCAT('Заказ № ', ord.attr_607_)
                  , STRING_AGG(izd.list_izd_with_comps, '; ') FILTER (
                        WHERE ord.attr_607_ IS NOT NULL
                    )
                    ) AS list
               FROM registry.object_3168_ o
          LEFT JOIN (
                       SELECT o.id
                            , comp_task.attr_2102_ order_prod
                            , pos_ord.attr_1410_ pos_designation
                            , CONCAT_WS(
                              ' - '
                            , pos_ord.attr_1410_
                            , STRING_AGG(
                              CASE
                                        WHEN comp_ord.attr_1421_ = 9 THEN CONCAT(comp_ord.attr_1410_, ' (отменён)')
                                        ELSE comp_ord.attr_1410_
                              END
                            , ', '
                              ) FILTER (
                                  WHERE comp_ord.attr_1410_ IS NOT NULL
                              )
                              ) list_izd_with_comps
                         FROM registry.object_3168_ o
                    LEFT JOIN registry.object_2094_ comp_task ON comp_task.attr_3175_ = o.id
                          AND comp_task.is_deleted IS FALSE
                    LEFT JOIN registry.object_1409_ comp_ord ON comp_task.attr_2100_ = comp_ord.id
                          AND comp_ord.is_deleted IS FALSE
                    LEFT JOIN registry.object_1409_ pos_ord ON comp_ord.attr_1414_ = pos_ord.id
                          AND pos_ord.is_deleted IS FALSE
                        WHERE o.is_deleted IS FALSE
                     GROUP BY o.id
                            , comp_task.attr_2102_
                            , pos_ord.attr_1410_
                    ) izd ON o.id = izd.id
          LEFT JOIN registry.object_606_ ord ON izd.order_prod = ord.id
                AND ord.is_deleted IS FALSE
              WHERE o.is_deleted IS FALSE
           GROUP BY o.id
                  , izd.list_izd_with_comps
                  , ord.attr_607_
           ORDER BY o.id
                  , ord.attr_607_
          ) pos_task ON pos_task.id = o.id
--GROUP BY 
            o.id