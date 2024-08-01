   SELECT -->>
          defect.id
     FROM registry.object_1409_ o -->>
LEFT JOIN registry.object_2612_ defect ON defect.attr_3487_ = nado.id
      AND defect.is_deleted <> TRUE
    WHERE o.is_deleted IS FALSE -->>
 GROUP BY -->>
          defect.id