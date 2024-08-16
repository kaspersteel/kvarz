/*базовая сохраняемая*/
   SELECT -->>
          sprav_mat18.attr_1359_
     FROM registry.object_1409_ o -->>
LEFT JOIN registry.object_400_ sprav_mat18 ON sprav_mat18.id = o.attr_1425_
    WHERE o.is_deleted IS FALSE -->>
 GROUP BY -->>
          sprav_mat18.id