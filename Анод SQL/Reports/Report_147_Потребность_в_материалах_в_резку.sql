     WITH DATASET AS (
             SELECT o.ID AS project_id,
                    o.attr_1923_::TEXT AS ORDER,
                    comp.ID AS comp_id,
                    nom_in_comp.ID AS nom_in_comp_id,
                    nom_in_comp.attr_376_ AS nom_in_comp_design,
                    tech_card_prod.ID AS tech_card_id,
                    comp.attr_3934_ AS given_mat /*давальческий*/,
                    comp.attr_1548_::DATE AS date_cut,
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
               FROM registry.object_1227_ o
          LEFT JOIN registry.object_1409_ comp ON comp.attr_1423_ = o.ID
                AND comp.is_deleted IS FALSE
                AND (
                    comp.attr_1421_ IS NULL
                 OR comp.attr_1421_ != 1
                    ) /*без измененний или не удален из состава*/
          LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_1458_ = nom_in_comp.ID
                AND nom_in_comp.is_deleted IS FALSE
          LEFT JOIN registry.object_369_ comp_structure ON comp.attr_3969_ = comp_structure.ID
                AND comp_structure.is_deleted IS FALSE
          LEFT JOIN registry.object_519_ tech_card_prod comp.attr_4085_ = tech_card_prod.id
          LEFT JOIN registry.object_400_ sprav_mat ON CASE
                              WHEN comp.attr_1452_ = 16 THEN comp_structure.attr_3967_
                              ELSE tech_card_prod.attr_2381_
                    END = sprav_mat.ID
          LEFT JOIN registry.object_400_ sprav_sort ON tech_card_prod.attr_1876_ = sprav_sort.ID
          LEFT JOIN registry.object_400_ sprav_tr ON tech_card_prod.attr_1877_ = sprav_tr.ID
              WHERE o.is_deleted IS FALSE
                AND o.attr_1923_ IS NOT NULL /*входит в заказ в производство*/
                AND comp.attr_3266_ IS FALSE /* есть отрезная операция*/
                AND comp.attr_2042_ NOT IN (1, 3) /*производимый компонент*/
          ),
          REMNANTS AS (
             SELECT remnants.attr_3952_ AS given,
                    remnants.attr_1663_ AS mat_id,
                    remnants.attr_1664_ AS sort_id,
                    remnants.attr_1665_ AS tr_id,
                    SUM(DISTINCT attr_1675_) AS current_rem_mass,
                    SUM(DISTINCT attr_3130_) AS expected_rem_mass
               FROM DATASET
          LEFT JOIN registry.object_1659_ remnants ON DATASET.mat = remnants.attr_1663_
                AND COALESCE(DATASET.sort, 0) = COALESCE(remnants.attr_1664_, 0)
                AND COALESCE(DATASET.tr, 0) = COALESCE(remnants.attr_1665_, 0)
                AND DATASET.given_mat = remnants.attr_3952_
                AND remnants.is_deleted IS FALSE
           GROUP BY remnants.id
          ),
          SUM_REMNANTS AS (
             SELECT REMNANTS.given,
                    REMNANTS.mat_id,
                    REMNANTS.sort_id,
                    REMNANTS.tr_id,
                    SUM(REMNANTS.current_rem_mass) AS sum_current_rem_mass,
                    SUM(REMNANTS.expected_rem_mass) AS sum_expected_rem_mass
               FROM REMNANTS
           GROUP BY REMNANTS.given,
                    REMNANTS.mat_id,
                    REMNANTS.sort_id,
                    REMNANTS.tr_id
          )
   SELECT STRING_AGG(DISTINCT DATASET.comp_id::TEXT, ', ') AS comp_ids,
          STRING_AGG(DISTINCT DATASET.nom_in_comp_design::TEXT, ', ') AS nom_designs,
          sprav_mat.ID AS sprav_mat_id,
          sprav_sort.ID AS sprav_sort_id,
          sprav_tr.ID AS sprav_tr_id,
          sprav_mat.attr_2976_ AS mat,
          sprav_sort.attr_2976_ AS sort,
          sprav_tr.attr_2976_ AS tr,
          COALESCE(sprav_units.attr_390_, '-') AS units,
          COALESCE(SUM(DATASET.quant), 0) AS sum_quant,
          DATASET.given_mat AS given_mat,
          STRING_AGG(
          DISTINCT DATASET.order,
          ', '
           ORDER BY DATASET.order
          ) AS orders,
          COALESCE(SUM_REMNANTS.sum_current_rem_mass, 0) AS sum_current_rem_mass,
          COALESCE(SUM_REMNANTS.sum_expected_rem_mass, 0) AS sum_expected_rem_mass
     FROM DATASET
LEFT JOIN registry.object_400_ sprav_mat ON DATASET.mat = sprav_mat.ID
LEFT JOIN registry.object_400_ sprav_sort ON DATASET.sort = sprav_sort.ID
LEFT JOIN registry.object_400_ sprav_tr ON DATASET.tr = sprav_tr.ID
LEFT JOIN registry.object_389_ sprav_units ON DATASET.units = sprav_units.ID
LEFT JOIN SUM_REMNANTS ON DATASET.mat = SUM_REMNANTS.mat_id
	 AND COALESCE(DATASET.sort, 0) = COALESCE(SUM_REMNANTS.sort_id, 0) 
	 AND COALESCE(DATASET.tr, 0) = COALESCE(SUM_REMNANTS.tr_id, 0)
      AND DATASET.given_mat = SUM_REMNANTS.given
    WHERE sprav_mat.ID IS NOT NULL
      AND DATASET.date_cut BETWEEN '{start_date_cut}'::DATE AND '{end_date_cut}'::DATE
      AND DATASET.comp_id NOT IN (
             SELECT attr_2100_
               FROM registry.object_2094_
              WHERE is_deleted IS FALSE
          ) /*компонент ещё не в производстве */
 GROUP BY sprav_mat.ID,
          sprav_sort.ID,
          sprav_tr.ID,
          sprav_units.ID,
          DATASET.given_mat,
          SUM_REMNANTS.sum_current_rem_mass,
          SUM_REMNANTS.sum_expected_rem_mass
 ORDER BY sprav_mat.attr_2976_,
          sprav_sort.attr_2976_,
          sprav_tr.attr_2976_