   SELECT -->>
          CASE
                    WHEN o.attr_1514_ IS NOT NULL THEN o.attr_1430_ * o.attr_1514_
                    ELSE o.attr_2088_
          END
     FROM registry.object_1409_ o -->>
    WHERE o.is_deleted IS FALSE -->>
 GROUP BY -->>