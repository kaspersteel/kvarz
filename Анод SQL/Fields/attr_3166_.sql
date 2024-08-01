   SELECT -->>
          CASE
                    WHEN o.attr_1421_ IS NOT NULL THEN (
                       SELECT SUM(tab_part_marsh_comp.attr_1443_)
                         FROM registry.object_519_ marsh_comp
                    LEFT JOIN registry.object_527_ tab_part_marsh_comp ON tab_part_marsh_comp.attr_538_ = marsh_comp.id
                          AND tab_part_marsh_comp.attr_586_ = 39
                        WHERE marsh_comp.attr_1466_ = o.id
                          AND marsh_comp.is_deleted <> TRUE
                          AND marsh_comp.attr_2908_ IS TRUE
                    ) * o.attr_1896_
                    ELSE (
                       SELECT SUM(tab_part_marsh_nom.attr_1443_)
                         FROM registry.object_519_ marsh_nom
                    LEFT JOIN registry.object_527_ tab_part_marsh_nom ON tab_part_marsh_nom.attr_538_ = marsh_nom.id
                          AND tab_part_marsh_nom.attr_586_ = 39
                        WHERE marsh_nom.attr_520_ = o.attr_1458_
                          AND marsh_nom.is_deleted <> TRUE
                          AND marsh_nom.attr_2908_ IS TRUE
                    ) * o.attr_1896_
          END
     FROM registry.object__ o -->>
    WHERE o.is_deleted IS FALSE -->>
 GROUP BY -->>