     WITH dataset AS (
             SELECT o.attr_607_ order_num,
                    project.attr_1574_ product,
                    comp.id comp_id,
                    o.attr_1964_::date shipping_date,
                    comp.attr_1548_::date date_cut,
                    comp.attr_1412_ count_one,
                    comp.attr_1896_ general_count,
                    CASE
                              WHEN comp.attr_1452_ = 16 THEN comp_structure.attr_3967_
                              ELSE tech_card_prod.attr_2381_
                    END mat,
                    tech_card_prod.attr_1876_ sort,
                    tech_card_prod.attr_1877_ tr,
                    CASE
                              WHEN comp.attr_1452_ = 16 THEN comp_structure.attr_3926_
                              WHEN sprav_mat.attr_1354_ = 6 THEN comp.attr_1896_
                              ELSE CASE
                                        WHEN tech_card_prod.attr_2554_ IS TRUE THEN tech_card_prod.attr_1908_ * CEILING(
                                        comp.attr_1896_::NUMERIC(5, 2) / tech_card_prod.attr_2907_::NUMERIC(5, 2)
                                        ) + COALESCE(tech_card_prod.attr_4105_, 0) * CEILING(
                                        comp.attr_1896_::NUMERIC(5, 2) / tech_card_prod.attr_2555_::NUMERIC(5, 2)
                                        )
                                        WHEN tech_card_prod.attr_2554_ IS FALSE THEN comp.attr_1896_ * tech_card_prod.attr_1908_
                              END
                    END quant,
                    CASE
                              WHEN comp.attr_1452_ = 16 THEN comp_structure.attr_3925_
                              WHEN sprav_tr.id IS NOT NULL THEN sprav_tr.attr_1673_
                              ELSE sprav_mat.attr_1673_
                    END units
               FROM registry.object_606_ o
          LEFT JOIN registry.object_1227_ project ON o.id = project.attr_1923_
                AND NOT project.is_deleted
          LEFT JOIN registry.object_1409_ comp ON project.id = comp.attr_1423_
                AND NOT comp.is_deleted
          LEFT JOIN registry.object_369_ comp_structure ON comp.attr_3969_ = comp_structure.id
                AND NOT comp_structure.is_deleted
          LEFT JOIN registry.object_519_ tech_card_prod ON comp.attr_4085_ = tech_card_prod.id
          LEFT JOIN registry.object_400_ sprav_mat ON CASE
                              WHEN comp.attr_1452_ = 16 THEN comp_structure.attr_3967_
                              ELSE tech_card_prod.attr_2381_
                    END = sprav_mat.id
          LEFT JOIN registry.object_400_ sprav_sort ON tech_card_prod.attr_1876_ = sprav_sort.id
          LEFT JOIN registry.object_400_ sprav_tr ON tech_card_prod.attr_1877_ = sprav_tr.id
              WHERE o.is_deleted IS FALSE
                AND o.attr_1926_ NOT IN (10, 13)
                AND comp.attr_3937_ IS NULL
                AND comp.attr_1896_ > 0
                AND (
                    comp.attr_1452_ = 16
                 OR (
                    comp.attr_1452_ <> 16
                AND (
                    comp.attr_2042_ NOT IN (1, 3)
                 OR comp.attr_2042_ IS NULL
                    )
                    )
                    )
          ),
          remnants AS (
             SELECT remnants.attr_1663_ mat_id,
                    remnants.attr_1664_ sort_id,
                    remnants.attr_1665_ tr_id,
                    SUM(DISTINCT attr_1675_) current_rem_mass,
                    SUM(DISTINCT attr_3130_) expected_rem_mass
               FROM dataset
          LEFT JOIN registry.object_1659_ remnants ON dataset.mat = remnants.attr_1663_
                AND COALESCE(dataset.sort, 0) = COALESCE(remnants.attr_1664_, 0)
                AND COALESCE(dataset.tr, 0) = COALESCE(remnants.attr_1665_, 0)
                AND remnants.is_deleted IS FALSE
           GROUP BY remnants.id
          ),
          sum_remnants AS (
             SELECT remnants.mat_id,
                    remnants.sort_id,
                    remnants.tr_id,
                    SUM(remnants.current_rem_mass) sum_current_rem_mass,
                    SUM(remnants.expected_rem_mass) sum_expected_rem_mass
               FROM remnants
           GROUP BY remnants.mat_id,
                    remnants.sort_id,
                    remnants.tr_id
          ),
          supply AS (
             SELECT order_mat.attr_1827_ mat_id,
                    order_mat.attr_1828_ sort_id,
                    order_mat.attr_1829_ tr_id,
                    SUM(DISTINCT order_mat.attr_2984_) quant
               FROM registry.object_1596_ order_to_diler
          LEFT JOIN registry.object_1826_ order_mat ON order_mat.attr_1834_ = order_to_diler.id
                AND NOT order_mat.is_deleted
              WHERE NOT order_to_diler.is_deleted
                AND order_to_diler.attr_1606_ IN (5, 6)
           GROUP BY order_mat.attr_1827_,
                    order_mat.attr_1828_,
                    order_mat.attr_1829_
          )
   SELECT order_num,
          product,
          shipping_date,
          CONCAT( sprav_mat.attr_2976_, ' ', sprav_sort.attr_2976_, ' ', sprav_tr.attr_2976_ ) full_material,
          sprav_mat.attr_2976_ mat,
          sprav_sort.attr_2976_ sort,
          sprav_tr.attr_2976_ tr,
          COALESCE(sprav_units.attr_390_, '-') units,
          ROUND(COALESCE(SUM(dataset.quant), 0), 2) sum_quant,
          count_one,
          general_count,
          sum_remnants.sum_expected_rem_mass,
          supply.quant,
          COALESCE(
          CASE
                    WHEN COALESCE(sum_remnants.sum_expected_rem_mass, 0) + COALESCE(supply.quant, 0) - COALESCE(SUM(dataset.quant * general_count), 0) >= 0 THEN 0
                    ELSE ROUND(
                    ABS(
                    COALESCE(sum_remnants.sum_expected_rem_mass, 0) + COALESCE(supply.quant, 0) - COALESCE(SUM(dataset.quant * general_count), 0)
                    ),
                    2
                    )
          END,
          0
          ) deficit
     FROM dataset
LEFT JOIN registry.object_400_ sprav_mat ON dataset.mat = sprav_mat.id
LEFT JOIN registry.object_400_ sprav_sort ON dataset.sort = sprav_sort.id
LEFT JOIN registry.object_400_ sprav_tr ON dataset.tr = sprav_tr.id
LEFT JOIN registry.object_389_ sprav_units ON dataset.units = sprav_units.id
LEFT JOIN sum_remnants ON dataset.mat = sum_remnants.mat_id
      AND COALESCE(dataset.sort, 0) = COALESCE(sum_remnants.sort_id, 0)
      AND COALESCE(dataset.tr, 0) = COALESCE(sum_remnants.tr_id, 0)
LEFT JOIN supply ON dataset.mat = supply.mat_id
      AND COALESCE(dataset.sort, 0) = COALESCE(supply.sort_id, 0)
      AND COALESCE(dataset.tr, 0) = COALESCE(supply.tr_id, 0)
    WHERE sprav_mat.id IS NOT NULL
      AND dataset.date_cut BETWEEN '{Период.FromDate}'::date AND '{Период.ToDate}'::date
      AND NOT dataset.comp_id IN (
             SELECT attr_2100_
               FROM registry.object_2094_
              WHERE NOT is_deleted
          )
 GROUP BY dataset.order_num,
          dataset.product,
          dataset.shipping_date,
          dataset.count_one,
          dataset.general_count,
          sum_remnants.sum_expected_rem_mass,
          supply.quant,
          sprav_mat.id,
          sprav_sort.id,
          sprav_tr.id,
          sprav_units.id
 ORDER BY mat, sort, tr