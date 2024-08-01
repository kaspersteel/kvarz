   SELECT -->>
          CASE
                    WHEN (
                    COALESCE(
                    (
                       SELECT SUM(sum_ost.attr_1620_) AS sum_ost
                         FROM registry.object_1617_ sum_ost
                        WHERE sum_ost.is_deleted <> TRUE
                          AND sum_ost.attr_1618_ = o.attr_1458_
                          AND sum_ost.attr_3951_ = o.attr_3933_
                    )
                  , 0
                    ) + CASE
                              WHEN o.attr_3933_ THEN 0
                              ELSE COALESCE(
                              (
                                 SELECT SUM(order_nom.attr_1683_)
                                   FROM registry.object_1596_ order_to_diler
                              LEFT JOIN registry.object_1679_ order_nom ON order_nom.attr_1682_ = order_to_diler.id
                                    AND order_nom.is_deleted <> TRUE
                                  WHERE order_to_diler.is_deleted <> TRUE
                                    AND order_nom.attr_1680_ = o.attr_1458_
                                    AND order_to_diler.attr_1606_ IN (5, 6)
                               GROUP BY order_nom.attr_1680_
                              )
                            , 0
                              )
                    END - COALESCE(
                    (
                       SELECT SUM(ABS(sum_ost.attr_1677_)) AS sum_ost
                         FROM registry.object_1617_ sum_ost
                        WHERE sum_ost.is_deleted <> TRUE
                          AND sum_ost.attr_1618_ = o.attr_1458_
                          AND sum_ost.attr_3951_ = o.attr_3933_
                    )
                  , 0
                    ) - o.attr_1896_
                    ) >= 0 THEN TRUE
                    ELSE FALSE
          END
     FROM registry.object_1409_ o -->>
    WHERE o.is_deleted IS FALSE -->>
 GROUP BY -->>