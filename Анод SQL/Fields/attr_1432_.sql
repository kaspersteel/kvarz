   SELECT -->>
          CASE
                    WHEN o.attr_1421_ IN (1, 4, 5, 6) THEN TRUE
                    ELSE FALSE
          END
     FROM registry.object_1409_ o -->>
    WHERE o.is_deleted IS FALSE -->>
 GROUP BY -->>