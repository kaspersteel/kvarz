   SELECT -->>
          ord.attr_1926_
     FROM registry.object_1409_ o -->>
LEFT JOIN registry.object_606_ ord ON proj_for_id.attr_1923_ = ord.id
    WHERE o.is_deleted IS FALSE -->>
 GROUP BY -->>
          ord.attr_1926_