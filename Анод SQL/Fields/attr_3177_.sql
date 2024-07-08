/*Информация о компонентах в задании*/
   SELECT
          /*выбрать компоненты без единиц хранения либо список изделий по заказу list*/
          COALESCE(o.attr_3197_, STRING_AGG(DISTINCT list, '\n'))
     FROM "object_3168_" o
LEFT JOIN (
             SELECT o.id
                  , CONCAT_WS(
                    ' - '
                  , CONCAT('Заказ № ', ord.attr_607_)
                  , STRING_AGG(o2.list_izd_with_comps, '; ') FILTER (
                        WHERE ord.attr_607_ IS NOT NULL
                    )
                    ) AS list
               FROM registry.object_3168_ o
          LEFT JOIN (
                       SELECT o.id
                            , comp.attr_2102_ order_prod
                            , comp_ord1.attr_1410_ izd
                            , CONCAT_WS(
                              ' - '
                            , comp_ord1.attr_1410_
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
                    LEFT JOIN registry.object_2094_ comp ON comp.attr_3175_ = o.id
                          AND comp.is_deleted <> TRUE
                    LEFT JOIN registry.object_1409_ comp_ord ON comp.attr_2100_ = comp_ord.id
                          AND comp_ord.is_deleted <> TRUE
                    LEFT JOIN registry.object_1409_ comp_ord1 ON comp_ord.attr_1414_ = comp_ord1.id
                          AND comp_ord1.is_deleted <> TRUE
                        WHERE o.is_deleted <> TRUE
                     GROUP BY o.id
                            , comp.attr_2102_
                            , comp_ord1.attr_1410_
                    ) o2 ON o.id = o2.id
          LEFT JOIN registry.object_606_ ord ON o2.order_prod = ord.id
                AND ord.is_deleted <> TRUE
              WHERE o.is_deleted <> TRUE
           GROUP BY o.id
                  , o2.list_izd_with_comps
                  , ord.attr_607_
           ORDER BY o.id
                  , ord.attr_607_
          ) o3 ON o3.id = o.id
 GROUP BY o.id