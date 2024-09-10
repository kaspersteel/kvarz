   SELECT -->>
          CASE
                    WHEN o.attr_1463_ = 1 THEN sprav_mat12.attr_1359_
                    ELSE o.attr_1420_
          END
     FROM registry.object_1409_ o -->>
LEFT JOIN registry.object_400_ sprav_mat12 ON sprav_mat12.id = o.attr_1415_
    WHERE o.is_deleted IS FALSE -->>
 GROUP BY -->>
          sprav_mat12.id