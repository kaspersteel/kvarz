   /*базовая сохраняемая*/
   ELECT -->>
          CASE
                    WHEN o.attr_1458_ IS NOT NULL THEN mrsh_card41.attr_3271_
          END
     FROM registry.object_1409_ o -->>
LEFT JOIN registry.object_301_ spr_nom_for_komp41 ON spr_nom_for_komp41.id = o.attr_1458_
      AND spr_nom_for_komp41.is_deleted <> TRUE
LEFT JOIN registry.object_519_ mrsh_card41 ON mrsh_card41.attr_520_ = spr_nom_for_komp41.id
      AND mrsh_card41.is_deleted <> TRUE
      AND mrsh_card41.attr_2908_ IS TRUE
    WHERE o.is_deleted IS FALSE -->>
 GROUP BY -->>
          spr_nom_for_komp41.id
        , mrsh_card41.id