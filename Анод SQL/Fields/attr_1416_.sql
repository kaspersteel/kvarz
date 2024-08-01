   SELECT -->>
          mrsh_card12.attr_1876_
     FROM registry.object_1409_ o -->>
LEFT JOIN registry.object_301_ spr_nom_for_komp1 ON spr_nom_for_komp1.id = o.attr_1458_
      AND spr_nom_for_komp1.is_deleted <> TRUE
LEFT JOIN registry.object_519_ mrsh_card12 ON mrsh_card12.attr_520_ = spr_nom_for_komp1.id
      AND mrsh_card12.is_deleted <> TRUE
      AND mrsh_card12.attr_2908_ IS TRUE
    WHERE o.is_deleted IS FALSE -->>
 GROUP BY -->>
          spr_nom_for_komp1.id
        , mrsh_card12.id