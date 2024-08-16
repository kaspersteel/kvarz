   SELECT -->>
          CASE
                    WHEN o.attr_1463_ = 1 THEN o.attr_1458_
                    ELSE o.attr_1482_
          END
     FROM registry.object_1409_ o -->>
    WHERE o.is_deleted IS FALSE -->>
 GROUP BY -->>