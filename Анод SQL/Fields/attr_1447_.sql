   SELECT -->>
          mrsh_card3.attr_1877_
     FROM registry.object_1409_ o -->>
LEFT JOIN registry.object_301_ spr_nom_for_komp3 ON spr_nom_for_komp3.id = o.attr_1458_
      AND spr_nom_for_komp3.is_deleted <> TRUE
LEFT JOIN registry.object_519_ mrsh_card3 ON mrsh_card3.attr_520_ = spr_nom_for_komp3.id
      AND mrsh_card3.is_deleted <> TRUE
      AND mrsh_card3.attr_2908_ IS TRUE
    WHERE o.is_deleted IS FALSE -->>
 GROUP BY -->>
          spr_nom_for_komp3.id
        , mrsh_card3.id