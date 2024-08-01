/*базовая сохраняемая*/
   SELECT -->>
          CASE
                    WHEN o.attr_1463_ = 1
                          AND o.attr_1478_ <> 1
                          AND o.attr_1458_ IS NOT NULL THEN type_nom_units.attr_363_
                              ELSE o.attr_1411_
          END
     FROM registry.object_1409_ o -->>
LEFT JOIN registry.object_301_ type_nom_units ON o.attr_1458_ = type_nom_units.id
    WHERE o.is_deleted IS FALSE -->>
 GROUP BY -->>