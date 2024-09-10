/*базовая сохраняемая*/
   SELECT -->>
          mrsh_card123.attr_2381_
     FROM registry.object_1409_ o -->>
LEFT JOIN registry.object_301_ spr_nom_for_komp14 ON spr_nom_for_komp14.id = o.attr_1458_
      AND spr_nom_for_komp14.is_deleted <> TRUE
LEFT JOIN registry.object_519_ mrsh_card123 ON mrsh_card123.attr_520_ = spr_nom_for_komp14.id
      AND mrsh_card123.is_deleted <> TRUE
      AND mrsh_card123.attr_2908_ IS TRUE
LEFT JOIN registry.object_369_ comp_structure ON o.attr_3969_ = comp_structure.id
      AND comp_structure.is_deleted <> TRUE
    WHERE o.is_deleted IS FALSE -->>
 GROUP BY -->>
          spr_nom_for_komp14.id
        , mrsh_card123.id