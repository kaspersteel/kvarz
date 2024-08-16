   SELECT -->>
          spr_mater37.attr_1373_
     FROM registry.object__ o -->>
LEFT JOIN registry.object_400_ spr_mater37 ON spr_mater37.id = o.attr_1426_
      AND spr_mater37.is_deleted <> TRUE
    WHERE o.is_deleted IS FALSE -->>
 GROUP BY -->>
          spr_mater37.id