   SELECT o.id
        , papk.attr_362_ AS papka
        , o.attr_1223_ AS oboznachenie
        , o.attr_2977_ AS code3
        , o.attr_2968_ AS min_ost
        , ost_n.current_bal
        , ost_n.sum_ost
        , order_for_manufacture.mass_ord
        , ARRAY_TO_STRING(order_for_manufacture.mass_ord, '; ') AS text_mass_ord
        , order_for_manufacture.list_order
        , order_for_manufacture.kol_vo_om AS kol_vo_ord_man
        , production_in_way.sum_prod_in_way
        , CASE
                    WHEN o.attr_2968_ IS NOT NULL THEN CASE
                              WHEN (
                              o.attr_2968_ - CASE
                                        WHEN production_in_way.sum_prod_in_way IS NULL THEN 0
                                        ELSE production_in_way.sum_prod_in_way
                              END - CASE
                                        WHEN ost_n.sum_ost IS NULL THEN 0
                                        ELSE ost_n.sum_ost
                              END
                              ) < 0 THEN 0
                              ELSE (
                              CASE
                                        WHEN order_for_manufacture.kol_vo_om IS NULL THEN 0
                                        ELSE order_for_manufacture.kol_vo_om
                              END + CASE
                                        WHEN o.attr_2968_ IS NULL THEN 0
                                        ELSE o.attr_2968_
                              END - CASE
                                        WHEN production_in_way.sum_prod_in_way IS NULL THEN 0
                                        ELSE production_in_way.sum_prod_in_way
                              END - CASE
                                        WHEN ost_n.sum_ost IS NULL THEN 0
                                        WHEN ost_n.sum_ost < 0 THEN - ost_n.sum_ost
                                        ELSE ost_n.sum_ost
                              END
                              )
                    END
                    ELSE CASE
                              WHEN (
                              CASE
                                        WHEN order_for_manufacture.kol_vo_om IS NULL THEN 0
                                        ELSE order_for_manufacture.kol_vo_om
                              END - CASE
                                        WHEN production_in_way.sum_prod_in_way IS NULL THEN 0
                                        ELSE production_in_way.sum_prod_in_way
                              END - CASE
                                        WHEN ost_n.sum_ost IS NULL THEN 0
                                        WHEN ost_n.sum_ost < 0 THEN - ost_n.sum_ost
                                        ELSE ost_n.sum_ost
                              END
                              ) < 0 THEN 0
                              ELSE (
                              CASE
                                        WHEN order_for_manufacture.kol_vo_om IS NULL THEN 0
                                        ELSE order_for_manufacture.kol_vo_om
                              END - CASE
                                        WHEN production_in_way.sum_prod_in_way IS NULL THEN 0
                                        ELSE production_in_way.sum_prod_in_way
                              END - CASE
                                        WHEN ost_n.sum_ost IS NULL THEN 0
                                        WHEN ost_n.sum_ost < 0 THEN - ost_n.sum_ost
                                        ELSE ost_n.sum_ost
                              END
                              )
                    END
          END AS kolvo_to_need
     FROM registry.object_301_ o
LEFT JOIN registry.object_301_ papk ON o.attr_1094_ = papk.id
      AND papk.is_deleted <> TRUE
LEFT JOIN (
             SELECT SUM(ost_nom.attr_1620_) AS current_bal
                  , SUM(
                    ost_nom.attr_1620_ - CASE
                              WHEN ost_nom.attr_1677_ IS NULL THEN 0
                              ELSE ost_nom.attr_1677_
                    END
                    ) AS sum_ost
                  , ost_nom.attr_1618_ AS nom_id
               FROM registry.object_1617_ ost_nom
              WHERE ost_nom.is_deleted <> TRUE
           GROUP BY ost_nom.attr_1618_
          ) ost_n ON ost_n.nom_id = o.id
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
                AND ord.attr_1926_ NOT IN (1, 12)
                AND comp_project.attr_3937_ IS NULL /*не из давальческого*/
                AND comp_project.attr_1452_ != 16 /*не материал в спецификации*/
           GROUP BY comp_project.attr_1482_
                  , comp_sprav_nom.attr_1223_
           ORDER BY comp_project.attr_1482_
          ) order_for_manufacture ON order_for_manufacture.cp_nom_id = o.id
LEFT JOIN (
             SELECT poz_order_d.attr_1680_ AS order_to_d_nom_id
                  , SUM(poz_order_d.attr_1683_) AS sum_prod_in_way
               FROM registry.object_1679_ poz_order_d
          LEFT JOIN registry.object_1596_ order_to_diler ON poz_order_d.attr_1682_ = order_to_diler.id
                AND order_to_diler.is_deleted <> TRUE
              WHERE poz_order_d.is_deleted <> TRUE
                AND order_to_diler.attr_1606_ IN (5, 6)
           GROUP BY poz_order_d.attr_1680_
          ) production_in_way ON production_in_way.order_to_d_nom_id = o.id
LEFT JOIN registry.object_2967_ sluj_reg ON sluj_reg.attr_2972_ = 296 /*:currentUser*/
    WHERE o.is_deleted <> TRUE
      AND o.attr_363_ IN (3, 6, 7)
      AND order_for_manufacture.mass_ord && sluj_reg.attr_2973_
 ORDER BY o.attr_1223_