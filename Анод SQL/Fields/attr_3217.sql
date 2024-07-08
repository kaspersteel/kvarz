ed_hran.attr_3130_ - (
(
   SELECT CASE
                    WHEN units_eq.attr_2943_ = 6 THEN SUM(comp_poz_work.attr_2103_)
                    ELSE SUM(
                    comp_poz_work.attr_2107_ * comp_poz_work.attr_2103_
                    )
          END AS amoun_massa
     FROM registry.object_3168_ poz_work
LEFT JOIN registry.object_2094_ comp_poz_work ON poz_work.id = comp_poz_work.attr_3175_
LEFT JOIN registry.object_1659_ units_eq ON poz_work.attr_3169_ = units_eq.id
    WHERE poz_work.is_deleted <> TRUE
      AND poz_work.id = o.id
 GROUP BY poz_work.id
        , units_eq.attr_2943_
)
)