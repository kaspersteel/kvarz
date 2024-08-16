   SELECT mat.id AS mat_id
        , sort.id AS sort_id
        , typer.id AS typer_id
        , mat.attr_1353_ AS pap
        , up_level.attr_1353_ AS pap2
        , CONCAT(mat.attr_401_, ' ', gost_mat.attr_428_) AS mat_name
        , sort.attr_401_ AS sort_name
        , typer.attr_401_ AS typer_name
        , ostatki_mat.current_bal
        , ostatki_mat.sum_ost AS sum_ost
        , CASE
                    WHEN typer.attr_2974_ IS NULL THEN mat.attr_2974_
                    ELSE typer.attr_2974_
          END AS min_ost
        , CASE
                    WHEN (
                    CASE
                              WHEN typer.attr_2974_ IS NULL THEN mat.attr_2974_
                              ELSE typer.attr_2974_
                    END
                    ) IS NOT NULL THEN NULL
                    ELSE order_for_manufacture.sum_kol_vo_om
          END AS sum_kol_vo_order_manafacture
        , ARRAY_TO_STRING(order_for_manufacture.mass_ord, '; ')
        , CASE
                    WHEN (
                    CASE
                              WHEN typer.attr_2974_ IS NULL THEN mat.attr_2974_
                              ELSE typer.attr_2974_
                    END
                    ) IS NOT NULL THEN NULL
                    ELSE order_for_manufacture.list_ord
          END AS list_oreder_manafacture
        , ord_to_diler.sum_product_in_way
        , CASE
                    WHEN mat.attr_2974_ IS NOT NULL
                           OR typer.attr_2974_ IS NOT NULL THEN (
                              CASE
                                        WHEN (
                                        CASE
                                                  WHEN typer.attr_2974_ IS NULL THEN mat.attr_2974_
                                                  ELSE typer.attr_2974_
                                        END - CASE
                                                  WHEN ostatki_mat.sum_ost IS NULL THEN 0
                                                  ELSE ostatki_mat.sum_ost
                                        END - CASE
                                                  WHEN ord_to_diler.sum_product_in_way IS NULL THEN 0
                                                  ELSE ord_to_diler.sum_product_in_way
                                        END
                                        ) <= 0 THEN 0
                                        ELSE (
                                        CASE
                                                  WHEN typer.attr_2974_ IS NULL THEN mat.attr_2974_
                                                  ELSE typer.attr_2974_
                                        END - CASE
                                                  WHEN ostatki_mat.sum_ost IS NULL THEN 0
                                                  ELSE ostatki_mat.sum_ost
                                        END - CASE
                                                  WHEN ord_to_diler.sum_product_in_way IS NULL THEN 0
                                                  ELSE ord_to_diler.sum_product_in_way
                                        END
                                        )
                              END
                              )
                              ELSE (
                              CASE
                                        WHEN (
                                        CASE
                                                  WHEN order_for_manufacture.sum_kol_vo_om IS NULL THEN 0
                                                  ELSE order_for_manufacture.sum_kol_vo_om
                                        END - CASE
                                                  WHEN ostatki_mat.sum_ost IS NULL THEN 0
                                                  ELSE ostatki_mat.sum_ost
                                        END - CASE
                                                  WHEN ord_to_diler.sum_product_in_way IS NULL THEN 0
                                                  ELSE ord_to_diler.sum_product_in_way
                                        END
                                        ) <= 0 THEN 0
                                        ELSE (
                                        CASE
                                                  WHEN order_for_manufacture.sum_kol_vo_om IS NULL THEN 0
                                                  ELSE order_for_manufacture.sum_kol_vo_om
                                        END - CASE
                                                  WHEN ostatki_mat.sum_ost IS NULL THEN 0
                                                  ELSE ostatki_mat.sum_ost
                                        END - CASE
                                                  WHEN ord_to_diler.sum_product_in_way IS NULL THEN 0
                                                  ELSE ord_to_diler.sum_product_in_way
                                        END
                                        )
                              END
                              )
          END AS need_to_order
        , CASE
                    WHEN mat.attr_2947_ IS NOT NULL THEN mat.attr_2947_
                    ELSE typer.attr_2947_
          END AS code3
     FROM registry.object_400_ mat
LEFT JOIN registry.object_400_ sort ON sort.attr_1353_ = mat.id
      AND sort.is_deleted <> TRUE
LEFT JOIN registry.object_400_ typer ON typer.attr_1353_ = sort.id
      AND typer.is_deleted <> TRUE
LEFT JOIN registry.object_424_ gost_mat ON mat.attr_405_ = gost_mat.id
LEFT JOIN registry.object_400_ up_level ON mat.attr_1353_ = up_level.id
LEFT JOIN (
             SELECT ost_mat.attr_1663_ AS ost_mat_id
                  , ost_mat.attr_1664_ AS ost_sort_id
                  , ost_mat.attr_1665_ AS ost_typer_id
                  , ed_izm.attr_390_ AS ed_izm_ost
                  , SUM(ost_mat.attr_1675_) AS current_bal
                  , SUM(
                    ost_mat.attr_1675_ - CASE
                              WHEN ost_mat.attr_3128_ < 0 THEN - ost_mat.attr_3128_
                              WHEN ost_mat.attr_3128_ IS NULL
                                     OR ost_mat.attr_3128_ = 0 THEN 0
                                        ELSE ost_mat.attr_3128_
                    END
                    ) AS sum_ost
               FROM registry.object_1659_ ost_mat
          LEFT JOIN registry.object_389_ ed_izm ON ost_mat.attr_1674_ = ed_izm.id
                AND ed_izm.is_deleted <> TRUE
              WHERE ost_mat.is_deleted <> TRUE
                AND ost_mat.attr_1675_ IS NOT NULL
           GROUP BY ost_mat.attr_1663_
                  , ost_mat.attr_1664_
                  , ost_mat.attr_1665_
                  , ed_izm.attr_390_
          ) ostatki_mat ON (
          ostatki_mat.ost_mat_id = mat.id
      AND ostatki_mat.ost_sort_id = sort.id
      AND ostatki_mat.ost_typer_id = typer.id
          )
       OR (
          ostatki_mat.ost_mat_id = mat.id
      AND ostatki_mat.ost_sort_id IS NULL
      AND ostatki_mat.ost_typer_id IS NULL
          )
LEFT JOIN (
             SELECT o2.mat_id
                  , o2.sort_id
                  , o2.typer_id
                  , ARRAY_TO_STRING(
                    ARRAY_AGG(CONCAT(ord1.attr_607_, ' - ', o2.s_kol_vo_om))
                  , '; '
                    ) AS list_ord
                  , SUM(o2.s_kol_vo_om) AS sum_kol_vo_om
                  , ARRAY_AGG(o2.ord_id) AS mass_ord
               FROM (
                       SELECT o1.mat_id
                            , o1.sort_id
                            , o1.typer_id
                            , o1.ord_id
                            , mat.attr_1354_
                            , sort.attr_1373_
                            , CASE
                                        WHEN mat.attr_1354_ IN (6) /*материал - заготовка*/
                                               OR sort.attr_1373_ = 6 /*сортамент - поковка*/
                                               OR o1.sort_id IS NULL
                                               OR o1.typer_id IS NULL THEN SUM(o1.kol_vo_om_det)
                                                  ELSE SUM(o1.kol_vo_om)
                              END AS s_kol_vo_om
                         FROM (
                                 SELECT tech_card_prod.attr_2381_ AS mat_id /*материал из техкарты*/
                                      , tech_card_prod.attr_1876_ AS sort_id /*сортамент*/
                                      , tech_card_prod.attr_1877_ AS typer_id /*типоразмер*/
                                      , COALESCE(
                                        ROUND(
                                        SUM(
                                        comp.attr_1896_ * CASE
                                                  WHEN tech_card_prod.attr_2554_ IS TRUE THEN (
                                                  tech_card_prod.attr_1908_ * CEILING(
                                                  comp.attr_1896_::NUMERIC(5, 2) / tech_card_prod.attr_2907_::NUMERIC(5, 2)
                                                  )
                                                  ) + (
                                                  COALESCE(tech_card_prod.attr_4105_, 0) * CEILING(
                                                  comp.attr_1896_::NUMERIC(5, 2) / tech_card_prod.attr_2555_::NUMERIC(5, 2)
                                                  )
                                                  )
                                                  WHEN tech_card_prod.attr_2554_ IS FALSE THEN comp.attr_1896_ * tech_card_prod.attr_1908_
                                        END /*списываемая масса материала*/
                                        )
                                      , 2
                                        )
                                      , 0
                                        ) AS kol_vo_om
                                      , SUM(comp.attr_1896_) AS kol_vo_om_det
                                      , ord.ID AS ord_id
                                      , comp.attr_4085_
                                   FROM registry.object_606_ ord
                              LEFT JOIN registry.object_1227_ project ON project.attr_1923_ = ord.ID
                                    AND project.is_deleted <> TRUE
                              LEFT JOIN (
                                           SELECT ARRAY_AGG(comp_task_work.attr_2100_) AS mass_comp_work
                                             FROM registry.object_2094_ comp_task_work
                                            WHERE comp_task_work.is_deleted <> TRUE
                                        ) comp_work ON 1 = 1
                              LEFT JOIN registry.object_1409_ comp ON comp.attr_1423_ = project.ID
                                    AND comp.is_deleted <> TRUE
                                    AND NOT ARRAY[comp.ID] && comp_work.mass_comp_work
                                    AND NOT ARRAY[comp.attr_1414_] && comp_work.mass_comp_work
                              LEFT JOIN registry.object_519_ tech_card_prod ON comp.attr_4085_ = tech_card_prod.ID
                                  WHERE ord.is_deleted <> TRUE
                                    AND ord.attr_1926_ NOT IN (1, 12)
                                    AND comp.attr_3937_ IS NULL /*не из давальческого*/
                                    AND comp.attr_1452_ != 16 /*не материал в спецификации*/
                                    AND tech_card_prod.attr_2045_ = 1
                               GROUP BY ord.ID
                                      , comp.ID
                                      , project.ID
                                      , tech_card_prod.ID
                               ORDER BY 1
                                      , 2
                                      , 3
                              ) o1
                    LEFT JOIN registry.object_400_ mat ON o1.mat_id = mat.ID
                          AND mat.is_deleted <> TRUE
                    LEFT JOIN registry.object_400_ sort ON o1.sort_id = sort.ID
                          AND sort.is_deleted <> TRUE
                     GROUP BY o1.ord_id
                            , o1.mat_id
                            , o1.sort_id
                            , o1.typer_id
                            , mat.attr_1354_
                            , sort.attr_1373_
                    ) o2
          LEFT JOIN registry.object_606_ ord1 ON o2.ord_id = ord1.ID
           GROUP BY o2.mat_id
                  , o2.sort_id
                  , o2.typer_id
           ORDER BY o2.mat_id
                  , o2.sort_id
                  , o2.typer_id
          ) order_for_manufacture ON order_for_manufacture.mat_id = mat.id
      AND COALESCE(order_for_manufacture.sort_id, 0) = COALESCE(sort.id, 0)
      AND COALESCE(order_for_manufacture.typer_id, 0) = COALESCE(typer.id, 0)
LEFT JOIN (
             SELECT poz_order_to_diler.attr_1816_ AS ord_d_mat_id
                  , poz_order_to_diler.attr_1817_ AS ord_d_sort_id
                  , poz_order_to_diler.attr_1818_ AS ord_d_typer_id
                  , SUM(poz_order_to_diler.attr_1819_) AS sum_product_in_way
               FROM registry.object_1815_ poz_order_to_diler
          LEFT JOIN registry.object_1596_ order_to_diler ON poz_order_to_diler.attr_1825_ = order_to_diler.id
                AND order_to_diler.is_deleted <> TRUE
              WHERE poz_order_to_diler.is_deleted <> TRUE
                AND order_to_diler.attr_1606_ IN (5, 6)
           GROUP BY poz_order_to_diler.attr_1816_
                  , poz_order_to_diler.attr_1817_
                  , poz_order_to_diler.attr_1818_
          ) ord_to_diler ON (
          ord_to_diler.ord_d_mat_id = mat.id
      AND ord_to_diler.ord_d_sort_id = sort.id
      AND ord_to_diler.ord_d_typer_id = typer.id
          )
       OR (
          ord_to_diler.ord_d_mat_id = mat.id
      AND ord_to_diler.ord_d_sort_id IS NULL
      AND ord_to_diler.ord_d_typer_id IS NULL
          )
LEFT JOIN registry.object_2967_ sluj_reg ON sluj_reg.attr_2972_ = 296 /*:currentUser*/
    WHERE mat.is_deleted <> TRUE
      AND mat.attr_1354_ IN (1, 6)
      AND order_for_manufacture.mass_ord && sluj_reg.attr_2973_
      AND mat.attr_1353_ = sluj_reg.attr_2971_
 ORDER BY mat.id
        , sort.id
        , typer.attr_401_