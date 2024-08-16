     WITH dataset AS (
             SELECT o.attr_607_ AS order_num,
                    project.attr_1574_ AS product,
                    comp.ID AS comp_id,
                    o.attr_1964_::DATE AS shipping_date,
                    comp.attr_1548_::DATE AS date_cut,
                    comp.attr_1412_ AS count_one,
                    comp.attr_1896_ AS general_count,
                    CASE
                              WHEN comp.attr_1452_ = 16 THEN comp_structure.attr_3967_
                              ELSE tech_card_prod.attr_2381_
                    END AS mat /*материал из техкарты или компонента состава ном. ед.*/,
                    tech_card_prod.attr_1876_ AS sort /*сортамент*/,
                    tech_card_prod.attr_1877_ AS tr /*типоразмер*/,
                    CASE
                              WHEN comp.attr_1452_ = 16 THEN comp_structure.attr_3926_ /*расход МвС*/
                              WHEN sprav_mat.attr_1354_ = 6 THEN comp.attr_1896_ /*количество заготовок*/
                              ELSE CASE
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
                    END AS quant /*количество материала различного типа*/,
                    CASE
                              WHEN comp.attr_1452_ = 16 THEN comp_structure.attr_3925_ /*ед. изм. расхода МвС*/
                              WHEN sprav_tr.ID IS NOT NULL THEN sprav_tr.attr_1673_ /*ед. изм. типоразмера*/
                              ELSE sprav_mat.attr_1673_ /*ед. изм. материала*/
                    END AS units /*ссылка на ед. измерения*/
               FROM registry.object_606_ o
          LEFT JOIN registry.object_1227_ project ON o.ID = project.attr_1923_
                AND project.is_deleted IS FALSE
          LEFT JOIN registry.object_1409_ comp ON project.ID = comp.attr_1423_
                AND comp.is_deleted IS FALSE
          LEFT JOIN registry.object_369_ comp_structure ON comp.attr_3969_ = comp_structure.ID
                AND comp_structure.is_deleted IS FALSE
          LEFT JOIN registry.object_519_ tech_card_prod ON comp.attr_4085_ = tech_card_prod.ID
          LEFT JOIN registry.object_400_ sprav_mat ON CASE
                              WHEN comp.attr_1452_ = 16 THEN comp_structure.attr_3967_
                              ELSE tech_card_prod.attr_2381_
                    END = sprav_mat.ID
          LEFT JOIN registry.object_400_ sprav_sort ON tech_card_prod.attr_1876_ = sprav_sort.ID
          LEFT JOIN registry.object_400_ sprav_tr ON tech_card_prod.attr_1877_ = sprav_tr.ID
              WHERE o.is_deleted IS FALSE
                AND o.attr_1926_ NOT IN (10, 13)
                AND comp.attr_3934_ IS FALSE /*не с давальческим материалом*/
                AND (
                    comp.attr_1452_ = 16
                 OR (
                    comp.attr_1452_ != 16
                AND (
                    comp.attr_2042_ NOT IN (1, 3)
                 OR comp.attr_2042_ IS NULL
                    )
                    )
                    ) /*материал в спецификации либо не производится*/
          ),
          REMNANTS AS (
             SELECT remnants.attr_1663_ AS mat_id,
                    remnants.attr_1664_ AS sort_id,
                    remnants.attr_1665_ AS tr_id,
                    SUM(DISTINCT attr_1675_) AS current_rem_mass,
                    SUM(DISTINCT attr_3130_) AS expected_rem_mass
               FROM DATASET
          LEFT JOIN registry.object_1659_ remnants ON DATASET.mat = remnants.attr_1663_
                AND COALESCE(DATASET.sort, 0) = COALESCE(remnants.attr_1664_, 0)
                AND COALESCE(DATASET.tr, 0) = COALESCE(remnants.attr_1665_, 0)
                AND remnants.is_deleted IS FALSE
           GROUP BY remnants.ID
          ),
          SUM_REMNANTS AS (
             SELECT REMNANTS.mat_id,
                    REMNANTS.sort_id,
                    REMNANTS.tr_id,
                    SUM(REMNANTS.current_rem_mass) AS sum_current_rem_mass,
                    SUM(REMNANTS.expected_rem_mass) AS sum_expected_rem_mass
               FROM REMNANTS
           GROUP BY REMNANTS.mat_id,
                    REMNANTS.sort_id,
                    REMNANTS.tr_id
          ),
          SUPPLY AS (
             SELECT order_mat.attr_1827_ AS mat_id,
                    order_mat.attr_1828_ AS sort_id,
                    order_mat.attr_1829_ AS tr_id,
                    SUM(DISTINCT order_mat.attr_2984_) AS quant
               FROM registry.object_1596_ order_to_diler
          LEFT JOIN registry.object_1826_ order_mat ON order_mat.attr_1834_ = order_to_diler.ID
                AND order_mat.is_deleted IS FALSE
              WHERE order_to_diler.is_deleted IS FALSE
                AND order_to_diler.attr_1606_ IN (5, 6)
           GROUP BY order_mat.attr_1827_,
                    order_mat.attr_1828_,
                    order_mat.attr_1829_
          )
   SELECT order_num,
          product,
          shipping_date,
          CONCAT(
          sprav_mat.attr_2976_,
          ' ',
          sprav_sort.attr_2976_,
          ' ',
          sprav_tr.attr_2976_
          ) AS full_material,
          sprav_mat.attr_2976_ AS mat,
          sprav_sort.attr_2976_ AS sort,
          sprav_tr.attr_2976_ AS tr,
          COALESCE(sprav_units.attr_390_, '-') AS units,
          ROUND(
          COALESCE(SUM(DATASET.quant * general_count), 0),
          2
          ) AS sum_quant,
          count_one,
          general_count,
          SUM_REMNANTS.sum_expected_rem_mass,
          SUPPLY.quant,
          COALESCE(
          CASE
                    WHEN (
                    (
                    COALESCE(SUM_REMNANTS.sum_expected_rem_mass, 0) + COALESCE(SUPPLY.quant, 0)
                    ) - COALESCE(SUM(DATASET.quant * general_count), 0)
                    ) >= 0 THEN 0
                    ELSE ROUND(
                    ABS(
                    (
                    COALESCE(SUM_REMNANTS.sum_expected_rem_mass, 0) + COALESCE(SUPPLY.quant, 0)
                    ) - COALESCE(SUM(DATASET.quant * general_count), 0)
                    ),
                    2
                    )
          END,
          0
          ) deficit
     FROM dataset
LEFT JOIN registry.object_400_ sprav_mat ON DATASET.mat = sprav_mat.ID
LEFT JOIN registry.object_400_ sprav_sort ON DATASET.sort = sprav_sort.ID
LEFT JOIN registry.object_400_ sprav_tr ON DATASET.tr = sprav_tr.ID
LEFT JOIN registry.object_389_ sprav_units ON DATASET.units = sprav_units.ID
LEFT JOIN SUM_REMNANTS ON DATASET.mat = SUM_REMNANTS.mat_id
      AND COALESCE(DATASET.sort, 0) = COALESCE(SUM_REMNANTS.sort_id, 0)
      AND COALESCE(DATASET.tr, 0) = COALESCE(SUM_REMNANTS.tr_id, 0)
LEFT JOIN SUPPLY ON DATASET.mat = SUPPLY.mat_id
      AND COALESCE(DATASET.sort, 0) = COALESCE(SUPPLY.sort_id, 0)
      AND COALESCE(DATASET.tr, 0) = COALESCE(SUPPLY.tr_id, 0)
    WHERE sprav_mat.ID IS NOT NULL
      AND DATASET.date_cut BETWEEN '{Период.FromDate}'::DATE AND '{Период.ToDate}'::DATE
      AND DATASET.comp_id NOT IN (
             SELECT attr_2100_
               FROM registry.object_2094_
              WHERE is_deleted IS FALSE
          ) /*компонент ещё не в производстве */
 GROUP BY dataset.order_num,
          dataset.product,
          dataset.shipping_date,
          dataset.count_one,
          dataset.general_count,
          sum_remnants.sum_expected_rem_mass,
          supply.quant,
          sprav_mat.ID,
          sprav_sort.ID,
          sprav_tr.ID,
          sprav_units.ID
 ORDER BY mat,
          sort,
          tr