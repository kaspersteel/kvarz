   SELECT -->>
          CASE
                    WHEN o.attr_3933_ THEN 0
                    ELSE COALESCE(
                    (
                       SELECT SUM(order_nom.attr_1683_)
                         FROM registry.object_1596_ order_to_diler
                    LEFT JOIN registry.object_1679_ order_nom ON order_nom.attr_1682_ = order_to_diler.id
                          AND order_nom.is_deleted <> TRUE
                          AND order_nom.attr_1680_ = o.attr_1458_
                        WHERE order_to_diler.is_deleted <> TRUE
                          AND order_to_diler.attr_1606_ IN (5, 6)
                    )
                  , 0
                    )
          END
     FROM registry.object_1409_ o -->>
    WHERE o.is_deleted IS FALSE -->>
 GROUP BY -->>