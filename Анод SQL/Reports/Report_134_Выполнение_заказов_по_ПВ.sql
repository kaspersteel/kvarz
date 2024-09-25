   SELECT TO_CHAR(o.attr_1964_, 'DD.MM.YYYY') shipping_date,
          o.attr_607_ order_number,
          position.attr_1574_ order_position,
          position.id position_id,
          comp_order.id components_id,
          comp_order.attr_1414_ AS parent_id,
          CASE
                    WHEN accepted_list.attr_2155_ IS NOT NULL THEN CONCAT(accepted_list.attr_2155_, ' - ', accepted_list.attr_3207_)
          END AS pv,
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
          END type_ne,

          /*необходимо учесть был ли изменен компонент или нет, поэтому проверка по статусам 4 и 6. Если были изменения, значит обозначение, наименование, количество будет новым, если изменений не было, то не меняем*/
          COALESCE(
                    comp_order.attr_1518_,
                    comp_order.attr_1410_
                    ) AS detail,
          comp_order.attr_1839_ AS component,
          COALESCE(
                    comp_order.attr_2433_,
                    comp_order.attr_1412_
                    ) AS one_count,
          comp_order.attr_1896_ general_count,
          unit.attr_390_ unit,
          /*остаток на складе: суммарное количество деталей для данного изделия,  имеющееся на складе. Если остаток есть - сумма attr_1620_, если остатка нет - 0*/
          COALESCE ( (
                       SELECT SUM(sum_ost.attr_1620_) AS sum_ost
                         FROM registry.object_1617_ sum_ost
                        WHERE sum_ost.is_deleted IS FALSE
                          AND sum_ost.attr_1618_ = comp_order.attr_1482_
                    ), 0) stock_residue,
          /*детали в пути: количество заказанных у поставщика деталей, которые еще не пришли, они в пути на производство. Через подзапрос присоединяются только, те детали которые имеют статус 5 (в пути) или 6 (на входном контроле)*/
          COALESCE ((
                       SELECT SUM(order_nom.attr_1683_)
                         FROM registry.object_1596_ order_to_diler
                    LEFT JOIN registry.object_1679_ order_nom ON order_nom.attr_1682_ = order_to_diler.id
                          AND order_nom.is_deleted IS FALSE
                        WHERE order_to_diler.is_deleted IS FALSE
                          AND order_nom.attr_1680_ = comp_order.attr_1482_
                          AND order_to_diler.attr_1606_ IN (5, 6)
                     GROUP BY order_nom.attr_1680_
                    ), 0) on_way,
          /*заготовка: то из чего делают детали. Взяли материал, обкромсали его, получили заготовку, потом из заготовки получили деталь*/
          CONCAT_WS(
          ' ',
          sprav_mat.attr_2976_,
          sprav_sort.attr_401_,
          sprav_tr.attr_401_
          ) AS wokrpiece,
          /*остаток заготовок: считается масса остатков материалов. Условие where: так как у нас имеются записи, где могут отсутствовать сортамент и типоразмер у материала, то для материалов существует два критерия отбора: 1. полное совпадение (материал=материал, сортамент=сортамент, типоразмер=типоразмер), 2. частичное совпадение (материала=материал, остальное  null)*/
          COALESCE(
          (
             SELECT SUM(ost_mat.attr_1675_) AS sprav_mat_residue
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
          /*для расчета массы заготовки, необходимо учесть был ли изменен компонент или нет, поэтому проверка по статусам 4 и 6. Если были изменения, значит масса будет новой и при расчёте используем ее, если изменений не было, то обычную массу компонента*/
          CASE
                    WHEN comp_order.attr_1421_ IN (4, 6) THEN comp_order.attr_1427_ * comp_order.attr_1896_
                    ELSE comp_order.attr_1419_ * comp_order.attr_1896_
          END worpiece_weight
     FROM registry.object_606_ o
LEFT JOIN registry.object_1227_ position ON o.id = position.attr_1923_
LEFT JOIN registry.object_1409_ comp_order ON position.id = comp_order.attr_1423_
LEFT JOIN registry.object_301_ nomenclature ON nomenclature.id = comp_order.attr_1482_
LEFT JOIN registry.object_301_ orn ON comp_order.attr_1458_ = orn.id
      AND orn.is_deleted IS FALSE
LEFT JOIN registry.object_2094_ comp_task ON comp_task.attr_2100_ = comp_order.ID
      AND comp_task.is_deleted IS FALSE
      /*извлекаем записи по информации из ПВ. 
                    Для собираемых компонентов по наличию их в массиве производимых компонентов. 
                    Для несобираемых - по соответствию номенклатуры, узлу в позиции заказа и*/
LEFT JOIN registry.object_2137_ accepted_list ON accepted_list.is_deleted IS FALSE
      AND comp_task.id = ANY (accepted_list.attr_3904_)
       OR (
          accepted_list.attr_2632_ = comp_order.attr_1458_
      AND comp_order.attr_1414_::INT = ANY (accepted_list.attr_4033_)
      AND accepted_list.attr_3193_ = comp_task.attr_3175_
          )
LEFT JOIN registry.object_389_ unit ON unit.id = nomenclature.attr_379_
LEFT JOIN registry.object_519_ tech_card_prod ON tech_card_prod.id = comp_order.attr_4085_
LEFT JOIN registry.object_400_ sprav_mat ON sprav_mat.ID =  tech_card_prod.attr_2381_
LEFT JOIN registry.object_400_ sprav_sort ON tech_card_prod.attr_1876_ = sprav_sort.ID
LEFT JOIN registry.object_400_ sprav_tr ON tech_card_prod.attr_1877_ = sprav_tr.ID
    WHERE o.is_deleted IS FALSE
      AND comp_order.attr_1896_ > 0
      AND ARRAY[o.id::TEXT] && STRING_TO_ARRAY('{superid}', ',')
      AND CASE
                    WHEN '{position}' = '0'
                           OR '{position}' = '' THEN TRUE
                              ELSE ARRAY[position.id::TEXT] && STRING_TO_ARRAY('{position}', ',')
          END