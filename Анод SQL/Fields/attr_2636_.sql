   SELECT -->>
          CASE
                    WHEN COUNT(mk_comp_norm.id) IS NOT NULL THEN (mk_comp_norm.attr_1449_)
                    ELSE CASE
                              WHEN comp_for_zp.attr_1514_ IS NOT NULL THEN (
                              comp_for_zp.attr_1430_ * comp_for_zp.attr_1514_ * o.attr_1412_
                              )
                    END
          END
     FROM registry.object_1409_ o -->>
LEFT JOIN registry.object_301_ nom_for_zvp ON nom_for_zvp.id = o.attr_2679_
      AND nom_for_zvp.is_deleted <> TRUE
LEFT JOIN registry.object_1227_ proj_for_zvp ON nom_for_zvp.attr_2544_ = proj_for_zvp.id
      AND proj_for_zvp.is_deleted <> TRUE
LEFT JOIN registry.object_1409_ comp_for_zp ON comp_for_zp.attr_1423_ = proj_for_zvp.id
      AND comp_for_zp.is_deleted <> TRUE
      AND comp_for_zp.attr_1518_ = o.attr_1410_
LEFT JOIN registry.object_519_ mk_comp_norm ON mk_comp_norm.attr_520_ = o.attr_1458_
      AND mk_comp_norm.is_deleted <> TRUE
      AND mk_comp_norm.attr_2908_ IS TRUE
    WHERE o.is_deleted IS FALSE -->>
 GROUP BY -->>
          nom_for_zvp.id
        , proj_for_zvp.id
        , comp_for_zp.id
        , mk_comp_norm.id