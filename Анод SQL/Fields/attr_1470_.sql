   SELECT -->>
          CASE
                    WHEN comp_NE.attr_1455_ IS NULL THEN comp_NE.attr_632_
          END
     FROM registry.object_1409_ o -->>
LEFT JOIN registry.object_369_ comp_NE ON o.attr_1458_ = comp_NE.attr_374_
      AND comp_NE.attr_374_ = comp_NE.attr_370_
      AND comp_NE.attr_1455_ IS NULL
      AND comp_NE.is_deleted <> TRUE
    WHERE o.is_deleted IS FALSE -->>
 GROUP BY -->>
          comp_NE.id
    LIMIT 1