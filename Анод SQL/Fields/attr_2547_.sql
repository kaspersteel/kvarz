   SELECT -->>
          CASE
                    WHEN (
                    (
                       SELECT COALESCE(SUM(sum_ost.attr_1620_), 0) - COALESCE(SUM(ABS(sum_ost.attr_1677_)), 0) AS expected_ost /*ожидаемый остаток на складе*/
                         FROM registry.object_1617_ sum_ost
                        WHERE sum_ost.is_deleted IS FALSE
                          AND sum_ost.attr_1618_ = o.attr_1458_ /*обозначение*/
                          AND sum_ost.attr_3951_ = o.attr_3933_ /*признак давальческого*/
                    ) + CASE
                              WHEN o.attr_3933_ THEN 0
                              ELSE COALESCE(
                              (
                                 SELECT SUM(order_nom.attr_1683_) /*в заказах поставщикам*/
                                   FROM registry.object_1596_ order_to_diler
                              LEFT JOIN registry.object_1679_ order_nom ON order_nom.attr_1682_ = order_to_diler.id
                                    AND order_nom.is_deleted IS FALSE
                                  WHERE order_to_diler.is_deleted IS FALSE
                                    AND order_nom.attr_1680_ = o.attr_1458_ /*обозначение*/
                                    AND order_to_diler.attr_1606_ IN (5, 6) /*в пути и на входном контроле*/
                               GROUP BY order_nom.attr_1680_
                              )
                            , 0
                              )
                    END - o.attr_1896_ /*количество в заказе*/
                    ) >= 0 THEN TRUE
                    ELSE FALSE
          END
     FROM registry.object_1409_ o -->>
    WHERE o.is_deleted IS FALSE -->>
 GROUP BY -->>