/*базовая сохраняемая*/
   SELECT -->>
          CASE
                    WHEN o.attr_1458_ IS NULL THEN NULL
                    ELSE sprav_nom.attr_1494_
          END
     FROM registry.object_1409_ o -->>
LEFT JOIN registry.object_301_ sprav_nom ON sprav_nom.id = o.attr_1458_
      AND sprav_nom.is_deleted IS FALSE
    WHERE o.is_deleted IS FALSE -->>
 GROUP BY -->>
          sprav_nom.id