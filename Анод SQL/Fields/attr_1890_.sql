   SELECT -->>
          CASE
                    WHEN o.attr_1463_ = 2
                          AND tech_card.attr_1466_ IS NOT NULL THEN TRUE
                              WHEN o.attr_1463_ = 1
                          AND mk_for_comp.attr_520_ IS NOT NULL THEN TRUE
                              ELSE FALSE
          END
     FROM registry.object_1409_ o -->>
LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_1466_ = o.ID
      AND tech_card.attr_2908_ IS TRUE
      AND tech_card.is_deleted IS FALSE
LEFT JOIN registry.object_301_ nom_for_comp ON nom_for_comp.ID = o.attr_1458_
      AND nom_for_comp.is_deleted IS FALSE
LEFT JOIN registry.object_519_ mk_for_comp ON nom_for_comp.ID = mk_for_comp.attr_520_
      AND mk_for_comp.attr_2908_ IS TRUE
      AND mk_for_comp.is_deleted IS FALSE
    WHERE o.is_deleted IS FALSE -->>
 GROUP BY --> 
          tech_card.ID
        , nom_for_comp.ID
        , mk_for_comp.ID