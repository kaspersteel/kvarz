   SELECT TO_CHAR(o.attr_1964_, 'DD.MM.YYYY') AS shipping_date,
          o.attr_607_ AS order_number,
          POSITION.attr_1574_ AS order_position,
          POSITION.ID AS project_id,
          comp_order.ID AS components_id,
          comp_order.attr_2042_,
          comp_order.attr_1414_ AS parent_id,
          comp_structure.attr_3926_ AS rash,
          /*Создание системы упорядочивания: в комплектовочной ведомости должна соблюдаться иерархия по типу номенклатурной единицы, таким образом элементы с id = (1,8,9,10,11) будут стоять на первом месте, с id = 2 - на втором месте и тд.*/
          CASE
                    WHEN comp_order.attr_1411_ IN (1, 8, 9, 10, 11) THEN 1
                    WHEN comp_order.attr_1411_ = 2 THEN 2
                    WHEN comp_order.attr_1411_ = 3 THEN 3
                    WHEN comp_order.attr_1411_ IN (6, 7)
                          AND nomenclature.attr_1094_ <> 216 THEN 4
                              WHEN comp_order.attr_1411_ IN (6, 7)
                          AND nomenclature.attr_1094_ = 216 THEN 5
                              ELSE comp_order.attr_1411_
          END AS type_ne,
          COALESCE(comp_order.attr_1518_, comp_order.attr_1410_) AS detail,
          comp_order.attr_1839_ AS component,
          COALESCE(comp_order.attr_2433_, comp_order.attr_1412_) AS one_count,
          comp_order.attr_1896_ AS general_count,
          nom_units.attr_390_ AS nom_units,
          given.attr_3936_ AS given_type,
          /*остаток на складе*/
          COALESCE(
          (
             SELECT SUM(sum_ost.attr_1620_) AS sum_ost
               FROM registry.object_1617_ sum_ost
              WHERE sum_ost.is_deleted IS FALSE
                AND sum_ost.attr_1618_ = comp_order.attr_1482_
                AND sum_ost.attr_3951_ = comp_order.attr_3933_
          ),
          0
          ) AS stock_residue,
          /*детали в пути*/
          CASE
                    WHEN comp_order.attr_3933_ THEN 0
                    ELSE COALESCE(
                    (
                       SELECT SUM(order_nom.attr_1683_)
                         FROM registry.object_1596_ order_to_diler
                    LEFT JOIN registry.object_1679_ order_nom ON order_nom.attr_1682_ = order_to_diler.ID
                          AND order_nom.is_deleted IS FALSE
                          AND order_nom.attr_1680_ = comp_order.attr_1482_
                        WHERE order_to_diler.is_deleted IS FALSE
                          AND order_to_diler.attr_1606_ IN (5, 6)
                    ),
                    0
                    )
          END AS on_way,
          /*заготовка: то из чего делают детали. Взяли материал, обкромсали его, получили заготовку, потом из заготовки получили деталь*/
          CONCAT_WS(
          ' ',
          sprav_mat.attr_2976_,
          ' ',
          sprav_sort.attr_401_,
          ' ',
          sprav_tr.attr_401_
          ) AS wokrpiece,
          /*остаток материала для заготовки*/
          COALESCE(
          (
             SELECT SUM(ost_mat.attr_1675_) AS materials_residue
               FROM registry.object_1659_ ost_mat
              WHERE ost_mat.is_deleted IS FALSE
                AND comp_order.attr_2042_ = 2
                AND ost_mat.attr_3952_ = comp_order.attr_3934_
                AND comp_order.attr_1425_ = ost_mat.attr_1663_
                AND COALESCE(comp_order.attr_1426_, 0) = COALESCE(ost_mat.attr_1664_, 0)
                AND COALESCE(comp_order.attr_1448_, 0) = COALESCE(ost_mat.attr_1665_, 0)
                
          ),
          0
          ) AS worpiece_residue,
          /*количество материала различного типа*/
          CONCAT(
          CASE
                    WHEN comp_order.attr_1452_ = 16 THEN comp_structure.attr_3926_ /*расход МвС*/
                    WHEN sprav_mat.attr_1354_ = 6 THEN comp_order.attr_1896_ /*количество заготовок*/
                    ELSE CASE
                              WHEN tech_card_prod.attr_2554_ IS TRUE THEN (
                              tech_card_prod.attr_1908_ * CEILING(comp_order.attr_1896_ / tech_card_prod.attr_2907_)
                              ) + (
                              COALESCE(tech_card_prod.attr_4105_, 0) * CEILING(comp_order.attr_1896_ / tech_card_prod.attr_2555_)
                              )
                              WHEN tech_card_prod.attr_2554_ IS FALSE THEN comp_order.attr_1896_ * tech_card_prod.attr_1908_
                    END /*списываемая масса материала*/
          END::NUMERIC(5, 2),
          ' ',
          mat_units.attr_390_
          ) AS worpiece_weight
     FROM registry.object_606_ o
LEFT JOIN registry.object_1227_ POSITION ON o.ID = POSITION.attr_1923_
      AND POSITION.is_deleted IS FALSE
LEFT JOIN registry.object_1409_ comp_order ON POSITION.ID = comp_order.attr_1423_
      AND comp_order.is_deleted IS FALSE
LEFT JOIN registry.object_301_ nomenclature ON nomenclature.ID = comp_order.attr_1482_
      AND nomenclature.is_deleted IS FALSE
LEFT JOIN registry.object_369_ comp_structure ON comp_structure.id = comp_order.attr_3969_
      AND comp_structure.is_deleted IS FALSE
LEFT JOIN registry.object_519_ tech_card_prod ON tech_card_prod.id = comp_order.attr_4085_
LEFT JOIN registry.object_400_ sprav_mat ON sprav_mat.ID = CASE
                    WHEN comp_order.attr_1452_ = 16 THEN comp_structure.attr_3967_
                    ELSE tech_card_prod.attr_2381_
          END
LEFT JOIN registry.object_400_ sprav_sort ON tech_card_prod.attr_1876_ = sprav_sort.ID
LEFT JOIN registry.object_400_ sprav_tr ON tech_card_prod.attr_1877_ = sprav_tr.ID
LEFT JOIN registry.object_3935_ given ON given.ID = comp_order.attr_3937_
LEFT JOIN registry.object_389_ nom_units ON nom_units.ID = nomenclature.attr_379_
LEFT JOIN registry.object_389_ mat_units ON mat_units.ID = CASE
                    WHEN comp_order.attr_1452_ = 16 THEN comp_structure.attr_3925_ /*ед. изм. расхода МвС*/
                    WHEN sprav_tr.ID IS NOT NULL THEN sprav_tr.attr_1673_ /*ед. изм. типоразмера*/
                    ELSE sprav_mat.attr_1673_ /*ед. изм. материала*/
          END
    WHERE o.is_deleted IS FALSE
      AND comp_order.attr_1896_ > 0
      AND ARRAY[o.ID::TEXT] && STRING_TO_ARRAY('{superid}', ',')
      AND CASE
                    WHEN '{position}' = '0'
                           OR '{position}' = '' THEN TRUE
                              ELSE ARRAY[POSITION.ID::TEXT] && STRING_TO_ARRAY('{position}', ',')
          END