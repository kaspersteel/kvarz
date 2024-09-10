   SELECT -->>
          COALESCE(sum_in_ord.kol_vo_om, 0)
     FROM registry.object_1409_ o -->>
LEFT JOIN (
             SELECT comp_project.attr_1482_ AS cp_nom_id
                  , comp_sprav_nom.attr_1223_
                  , ARRAY_TO_STRING(
                    ARRAY_AGG(
                    CONCAT(
                    ord.attr_607_
                  , ' - '
                  , sprav_nom.attr_1223_
                  , ' - '
                  , comp_project.attr_1896_
                    )
                    ) FILTER (
                        WHERE (comp_project.attr_1896_ IS NOT NULL)
                    )
                  , '; '
                    ) AS list_order
                  , SUM(comp_project.attr_1896_) AS kol_vo_om
                  , ARRAY_AGG(ord.id) AS mass_ord
               FROM registry.object_606_ ord
          LEFT JOIN registry.object_1227_ project ON project.attr_1923_ = ord.id
                AND project.is_deleted <> TRUE
          LEFT JOIN registry.object_301_ sprav_nom ON project.attr_1394_ = sprav_nom.id
                AND sprav_nom.is_deleted <> TRUE
          LEFT JOIN (
                       SELECT ARRAY_AGG(comp_task_work.attr_2100_) AS mass_comp_work
                         FROM registry.object_2094_ comp_task_work
                        WHERE comp_task_work.is_deleted <> TRUE
                    ) comp_work ON 1 = 1
          LEFT JOIN registry.object_1409_ comp_project ON comp_project.attr_1423_ = project.id
                AND comp_project.is_deleted <> TRUE
                AND comp_project.attr_2042_ = 3
                AND NOT ARRAY[comp_project.id] && comp_work.mass_comp_work
                AND NOT ARRAY[comp_project.attr_1414_] && comp_work.mass_comp_work
          LEFT JOIN registry.object_301_ comp_sprav_nom ON comp_project.attr_1482_ = comp_sprav_nom.id
              WHERE ord.is_deleted <> TRUE
           GROUP BY comp_project.attr_1482_
                  , comp_sprav_nom.attr_1223_
           ORDER BY comp_project.attr_1482_
          ) sum_in_ord ON sum_in_ord.cp_nom_id = o.attr_1482_
    WHERE o.is_deleted IS FALSE -->>
 GROUP BY -->>
          sum_in_ord.kol_vo_om