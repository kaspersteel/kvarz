/*Фактическая трудоёмкость на весь заказ
В произ- водстве, н/ч	
Прочее, н/ч	
В коопер, н/ч	
В руб.	
Отклонения по трудоёмкости (+/-)	
В н/ч	
В руб.*/
WITH dataset AS (
	 SELECT orders.id orders_id
        , position_orders.id position_orders_id
        , orders.attr_607_ order_num
        , comp_position_orders.id comp_position_orders_id
        , comp_position_orders.attr_1414_ parent_id
				, tech_op_list.id_accepted_list
				, SUM (comp_position_orders.attr_1896_) OVER accepted_partition AS sum_general_count
				, tech_op_list.prin
, comp_position_orders.attr_2042_ AS source
        , CASE
                    WHEN comp_position_orders.attr_1411_ IN (1, 8, 9, 10, 11) THEN 1
                    WHEN comp_position_orders.attr_1411_ = 2 THEN 2
                    WHEN comp_position_orders.attr_1411_ = 3 THEN 3
                    WHEN comp_position_orders.attr_1411_ IN (6, 7)
                          AND nom_units.attr_1094_ <> 216 THEN 4
                              WHEN comp_position_orders.attr_1411_ IN (6, 7)
                          AND nom_units.attr_1094_ = 216 THEN 5
                              ELSE comp_position_orders.attr_1411_
          END type_ne
        , CASE
                    WHEN comp_position_orders.attr_1421_ IN (4, 6) THEN comp_position_orders.attr_1518_
                    ELSE comp_position_orders.attr_1410_
          END article_comp
        , CASE
                    WHEN comp_position_orders.attr_1421_ IN (4, 6) THEN comp_position_orders.attr_1839_
                    ELSE comp_position_orders.attr_1413_
          END name_comp
        , CASE
                    WHEN comp_position_orders.attr_1421_ IN (4, 6) THEN comp_position_orders.attr_2433_
                    ELSE comp_position_orders.attr_1412_
          END one_count
        , comp_position_orders.attr_1896_ general_count
        , /*Выпуск изделий/ деталей, шт.	
          Откло-нение (+/-)*/
          CONCAT_WS(
          ' '
        , reg_mat.attr_2976_
        , reg_sort.attr_401_
        , reg_tr.attr_401_
          ) name_reg_mat
        , CASE
                    WHEN comp_position_orders.attr_1411_ IN (1, 2, 6, 8, 9) THEN units_nomenclature.attr_390_
                    ELSE CASE
                              WHEN units_reg_tr.attr_390_ IS NULL THEN units_reg_mat.attr_390_
                              ELSE units_reg_tr.attr_390_
                    END
          END name_units_reg_mat
        , CASE
                    WHEN comp_position_orders.attr_1411_ IN (1, 2, 6, 8, 9) THEN CASE
                              WHEN comp_position_orders.attr_1421_ IN (4, 6) THEN comp_position_orders.attr_2433_
                              ELSE comp_position_orders.attr_1412_
                    END
                    ELSE tech_card.attr_1908_
          END reg_amount
        , CASE
                    WHEN comp_position_orders.attr_1411_ IN (1, 2, 6, 8, 9) THEN comp_position_orders.attr_1896_
                    ELSE tech_card.attr_1908_ * comp_position_orders.attr_1896_
          END sum_reg_amount
        , /*Цена, руб.	
          Сумма на весь заказ, руб.*/
          CONCAT_WS(
          ' '
        , fact_mat.attr_2976_
        , fact_sort.attr_401_
        , fact_tr.attr_401_
          ) name_fact_mat
        , CASE
                    WHEN comp_position_orders.attr_1411_ IN (1, 2, 6, 8, 9) THEN units_nomenclature.attr_390_
                    ELSE CASE
                              WHEN units_fact_tr.attr_390_ IS NULL THEN units_fact_mat.attr_390_
                              ELSE units_fact_tr.attr_390_
                    END
          END name_units_fact_mat
        , CASE
                    WHEN comp_position_orders.attr_1411_ IN (1, 2, 6, 8, 9) THEN 1
                    ELSE CASE
                              WHEN fact_sort.attr_1373_ = 1 THEN (
                              PI() * (units_materials.attr_2212_ / 2 / 1000) ^ 2 * (work_task_comp.attr_2588_ + 2) / 1000
                              ) * fact_mat.attr_1359_
                              WHEN fact_sort.attr_1373_ = 2 THEN (
                              units_materials.attr_2210_ / 1000 * (work_task_comp.attr_2588_ + 2) / 1000 * units_materials.attr_2211_ / 1000
                              ) * fact_mat.attr_1359_
                              WHEN fact_sort.attr_1373_ = 3 THEN (
                              units_materials.attr_2211_ / 1000 * (
                              units_materials.attr_2210_ / 1000 + units_materials.attr_2932_ / 1000 - units_materials.attr_2211_ / 1000
                              ) * (work_task_comp.attr_2588_ + 2) / 1000
                              ) * fact_mat.attr_1359_
                              WHEN fact_sort.attr_1373_ = 4 THEN (
                              2 * SQRT(3) * (units_materials.attr_2932_ / 1000 / 2) ^ 2 * (work_task_comp.attr_2588_ + 2) / 1000
                              ) * fact_mat.attr_1359_
                              WHEN fact_sort.attr_1373_ = 5 THEN (
                              PI() * (
                              (units_materials.attr_2212_ / 1000 / 2) ^ 2 - (units_materials.attr_2928_ / 1000 / 2) ^ 2
                              ) * ((work_task_comp.attr_2588_ + 2) / 1000)
                              ) / 4 * fact_mat.attr_1359_
                              WHEN fact_sort.attr_1373_ = 7 THEN (
                              4 * units_materials.attr_2211_ / 1000 * (
                              (units_materials.attr_2210_ / 1000) - (units_materials.attr_2211_ / 1000)
                              ) * ((work_task_comp.attr_2588_ + 2) / 1000)
                              ) * fact_mat.attr_1359_
                              WHEN fact_sort.attr_1373_ = 8 THEN (
                              2 * (units_materials.attr_2211_ / 1000) * (
                              units_materials.attr_2210_ / 1000 + units_materials.attr_2932_ / 1000 -2 * units_materials.attr_2211_ / 1000
                              ) * ((work_task_comp.attr_2588_ + 2) / 1000)
                              ) * fact_mat.attr_1359_
                              WHEN fact_sort.attr_1373_ = 9 THEN (
                              (units_materials.attr_2932_ / 1000) * (units_materials.attr_2211_ / 1000) -2 * (units_materials.attr_2211_ / 1000) * (
                              units_materials.attr_2210_ / 1000 - units_materials.attr_2211_ / 1000
                              ) * ((work_task_comp.attr_2588_ + 2) / 1000)
                              ) * fact_mat.attr_1359_
                              ELSE NULL
                    END
          END fact_amount
        , CASE
                    WHEN comp_position_orders.attr_1411_ IN (1, 2, 6, 8, 9) THEN work_task_comp.attr_2103_
                    ELSE CASE
                              WHEN fact_sort.attr_1373_ = 1 THEN (
                              PI() * (units_materials.attr_2212_ / 2 / 1000) ^ 2 * (work_task_comp.attr_2588_ + 2) / 1000
                              ) * fact_mat.attr_1359_
                              WHEN fact_sort.attr_1373_ = 2 THEN (
                              units_materials.attr_2210_ / 1000 * (work_task_comp.attr_2588_ + 2) / 1000 * units_materials.attr_2211_ / 1000
                              ) * fact_mat.attr_1359_
                              WHEN fact_sort.attr_1373_ = 3 THEN (
                              units_materials.attr_2211_ / 1000 * (
                              units_materials.attr_2210_ / 1000 + units_materials.attr_2932_ / 1000 - units_materials.attr_2211_ / 1000
                              ) * (work_task_comp.attr_2588_ + 2) / 1000
                              ) * fact_mat.attr_1359_
                              WHEN fact_sort.attr_1373_ = 4 THEN (
                              2 * SQRT(3) * (units_materials.attr_2932_ / 1000 / 2) ^ 2 * (work_task_comp.attr_2588_ + 2) / 1000
                              ) * fact_mat.attr_1359_
                              WHEN fact_sort.attr_1373_ = 5 THEN (
                              PI() * (
                              (units_materials.attr_2212_ / 1000 / 2) ^ 2 - (units_materials.attr_2928_ / 1000 / 2) ^ 2
                              ) * ((work_task_comp.attr_2588_ + 2) / 1000)
                              ) / 4 * fact_mat.attr_1359_
                              WHEN fact_sort.attr_1373_ = 7 THEN (
                              4 * units_materials.attr_2211_ / 1000 * (
                              (units_materials.attr_2210_ / 1000) - (units_materials.attr_2211_ / 1000)
                              ) * ((work_task_comp.attr_2588_ + 2) / 1000)
                              ) * fact_mat.attr_1359_
                              WHEN fact_sort.attr_1373_ = 8 THEN (
                              2 * (units_materials.attr_2211_ / 1000) * (
                              units_materials.attr_2210_ / 1000 + units_materials.attr_2932_ / 1000 -2 * units_materials.attr_2211_ / 1000
                              ) * ((work_task_comp.attr_2588_ + 2) / 1000)
                              ) * fact_mat.attr_1359_
                              WHEN fact_sort.attr_1373_ = 9 THEN (
                              (units_materials.attr_2932_ / 1000) * (units_materials.attr_2211_ / 1000) -2 * (units_materials.attr_2211_ / 1000) * (
                              units_materials.attr_2210_ / 1000 - units_materials.attr_2211_ / 1000
                              ) * ((work_task_comp.attr_2588_ + 2) / 1000)
                              ) * fact_mat.attr_1359_
                              ELSE NULL
                    END
          END * comp_position_orders.attr_1896_ sum_fact_amount
        , /*	Цена, руб.	
          Списано на весь заказ, руб.*/
          CASE
                    WHEN comp_position_orders.attr_1411_ IN (1, 2, 6, 8, 9) THEN comp_position_orders.attr_1896_
                    ELSE tech_card.attr_1908_ * comp_position_orders.attr_1896_
          END - CASE
                    WHEN comp_position_orders.attr_1411_ IN (1, 2, 6, 8, 9) THEN work_task_comp.attr_2103_
                    ELSE CASE
                              WHEN fact_sort.attr_1373_ = 1 THEN (
                              PI() * (units_materials.attr_2212_ / 2 / 1000) ^ 2 * (work_task_comp.attr_2588_ + 2) / 1000
                              ) * fact_mat.attr_1359_
                              WHEN fact_sort.attr_1373_ = 2 THEN (
                              units_materials.attr_2210_ / 1000 * (work_task_comp.attr_2588_ + 2) / 1000 * units_materials.attr_2211_ / 1000
                              ) * fact_mat.attr_1359_
                              WHEN fact_sort.attr_1373_ = 3 THEN (
                              units_materials.attr_2211_ / 1000 * (
                              units_materials.attr_2210_ / 1000 + units_materials.attr_2932_ / 1000 - units_materials.attr_2211_ / 1000
                              ) * (work_task_comp.attr_2588_ + 2) / 1000
                              ) * fact_mat.attr_1359_
                              WHEN fact_sort.attr_1373_ = 4 THEN (
                              2 * SQRT(3) * (units_materials.attr_2932_ / 1000 / 2) ^ 2 * (work_task_comp.attr_2588_ + 2) / 1000
                              ) * fact_mat.attr_1359_
                              WHEN fact_sort.attr_1373_ = 5 THEN (
                              PI() * (
                              (units_materials.attr_2212_ / 1000 / 2) ^ 2 - (units_materials.attr_2928_ / 1000 / 2) ^ 2
                              ) * ((work_task_comp.attr_2588_ + 2) / 1000)
                              ) / 4 * fact_mat.attr_1359_
                              WHEN fact_sort.attr_1373_ = 7 THEN (
                              4 * units_materials.attr_2211_ / 1000 * (
                              (units_materials.attr_2210_ / 1000) - (units_materials.attr_2211_ / 1000)
                              ) * ((work_task_comp.attr_2588_ + 2) / 1000)
                              ) * fact_mat.attr_1359_
                              WHEN fact_sort.attr_1373_ = 8 THEN (
                              2 * (units_materials.attr_2211_ / 1000) * (
                              units_materials.attr_2210_ / 1000 + units_materials.attr_2932_ / 1000 -2 * units_materials.attr_2211_ / 1000
                              ) * ((work_task_comp.attr_2588_ + 2) / 1000)
                              ) * fact_mat.attr_1359_
                              WHEN fact_sort.attr_1373_ = 9 THEN (
                              (units_materials.attr_2932_ / 1000) * (units_materials.attr_2211_ / 1000) -2 * (units_materials.attr_2211_ / 1000) * (
                              units_materials.attr_2210_ / 1000 - units_materials.attr_2211_ / 1000
                              ) * ((work_task_comp.attr_2588_ + 2) / 1000)
                              ) * fact_mat.attr_1359_
                              ELSE NULL
                    END
          END * comp_position_orders.attr_1896_ differense
        , SUM(tp_tech_card.attr_1443_) AS sum_norm_time
        , /*Нормативная трудоёмкость		
          Трудоёмкость на весь заказ, н/ч	
          Трудоёмкость на весь заказ, руб.*/
          ROUND(
          tech_op_list.master_amount * comp_position_orders.attr_1896_
        , 2
          ) master_work_hours
        , ROUND(
          tech_op_list.amount_otk * comp_position_orders.attr_1896_
        , 2
          ) otk_work_hours
        , ROUND(
          tech_op_list.another_time * comp_position_orders.attr_1896_
        , 2
          ) another_time
        , ROUND(
          tech_op_list.cooperation * comp_position_orders.attr_1896_
        , 2
          ) cooperation
     FROM registry.object_606_ orders
LEFT JOIN registry.object_1227_ position_orders ON position_orders.attr_1923_ = orders.id
      AND position_orders.is_deleted <> TRUE
      AND (
          position_orders.attr_1948_ <> 1
       OR position_orders.attr_1948_ IS NULL
          )
LEFT JOIN registry.object_1409_ comp_position_orders ON comp_position_orders.attr_1423_ = position_orders.id
      AND comp_position_orders.is_deleted <> TRUE
      AND (
          comp_position_orders.attr_1421_ <> 1
       OR comp_position_orders.attr_1421_ IS NULL
          )
LEFT JOIN registry.object_301_ nom_units ON comp_position_orders.attr_1482_ = nom_units.id
LEFT JOIN registry.object_389_ units_nomenclature ON nom_units.attr_379_ = units_nomenclature.id
LEFT JOIN registry.object_519_ tech_card ON comp_position_orders.attr_1482_ = tech_card.attr_520_
      AND tech_card.is_deleted <> TRUE
      AND tech_card.attr_2908_ = TRUE
LEFT JOIN registry.object_527_ tp_tech_card ON tp_tech_card.attr_538_ = tech_card.id
      AND tp_tech_card.is_deleted <> TRUE
LEFT JOIN registry.object_400_ reg_mat ON tech_card.attr_2381_ = reg_mat.id
LEFT JOIN registry.object_400_ reg_sort ON tech_card.attr_1876_ = reg_sort.id
LEFT JOIN registry.object_400_ reg_tr ON tech_card.attr_1877_ = reg_tr.id
LEFT JOIN registry.object_389_ units_reg_mat ON reg_mat.attr_1673_ = units_reg_mat.id
LEFT JOIN registry.object_389_ units_reg_tr ON reg_tr.attr_1673_ = units_reg_tr.id
LEFT JOIN registry.object_519_ comp_tech_card ON comp_position_orders.id = comp_tech_card.attr_1466_
      AND comp_tech_card.is_deleted <> TRUE
      AND comp_tech_card.attr_2908_ = TRUE
LEFT JOIN registry.object_527_ tp_comp_tech_card ON tp_comp_tech_card.attr_538_ = comp_tech_card.id
      AND tp_comp_tech_card.is_deleted <> TRUE
LEFT JOIN registry.object_2094_ work_task_comp ON work_task_comp.attr_2100_ = comp_position_orders.id
      AND work_task_comp.is_deleted <> TRUE
LEFT JOIN (
             SELECT accepted_list.id AS id_accepted_list
                  , accepted_list.attr_3193_ position_task_id
                  , accepted_list.attr_2632_ nom_units
                  , accepted_list.attr_2167_ id_units_materials
                  , accepted_list.attr_4033_ array_izd
                  , SUM(
                    CASE
                              WHEN accepted_list_table_part.attr_3433_ IS NULL THEN accepted_list_table_part.attr_3373_
                              ELSE 0
                    END
                    ) master_amount
                  , SUM(accepted_list_table_part.attr_3373_) amount_otk
                  , SUM(accept.sum_another_time) another_time
                  , SUM(
                    CASE
                              WHEN accepted_list_table_part.attr_3433_ IS NOT NULL THEN accepted_list_table_part.attr_3373_
                              ELSE 0
                    END
                    ) cooperation
                  , docs.prin prin
               FROM registry.object_2137_ accepted_list
          LEFT JOIN registry.object_2138_ accepted_list_table_part ON accepted_list_table_part.attr_2148_ = accepted_list.id
                AND accepted_list_table_part.is_deleted <> TRUE
          LEFT JOIN (
                       SELECT o.attr_3276_
                            , o.attr_3277_
                            , SUM(o.attr_3283_) AS sum_another_time
                         FROM registry.object_3273_ o
                        WHERE o.is_deleted <> TRUE
                     GROUP BY o.attr_3276_
                            , o.attr_3277_
                    ) accept ON accept.attr_3276_ = accepted_list.id
                AND accept.attr_3277_ = accepted_list_table_part.id
          LEFT JOIN ( SELECT 
					doc.attr_3441_ link_pv
					, SUM(doc.attr_3081_) prin
					FROM registry.object_3023_ doc 
					
                WHERE doc.is_deleted IS FALSE
								AND doc.attr_3028_ IS TRUE
								GROUP BY doc.attr_3441_
								) docs ON docs.link_pv = accepted_list.id
              WHERE accepted_list.is_deleted <> TRUE
           GROUP BY accepted_list.id
                  , docs.prin
           ORDER BY accepted_list.id DESC
          ) tech_op_list ON tech_op_list.nom_units = comp_position_orders.attr_1482_
      AND comp_position_orders.attr_1414_::INTEGER = ANY (tech_op_list.array_izd)
      AND tech_op_list.position_task_id = work_task_comp.attr_3175_
      AND work_task_comp.attr_3175_ = tech_op_list.position_task_id
LEFT JOIN registry.object_1659_ units_materials ON tech_op_list.id_units_materials = units_materials.id
LEFT JOIN registry.object_400_ fact_mat ON units_materials.attr_1663_ = fact_mat.id
LEFT JOIN registry.object_400_ fact_sort ON units_materials.attr_1664_ = fact_sort.id
LEFT JOIN registry.object_400_ fact_tr ON units_materials.attr_1665_ = fact_tr.id
LEFT JOIN registry.object_389_ units_fact_mat ON fact_mat.attr_1673_ = units_fact_mat.id
LEFT JOIN registry.object_389_ units_fact_tr ON fact_tr.attr_1673_ = units_fact_tr.id
    WHERE orders.is_deleted <> TRUE
      AND orders.id = '{superid}'
      AND comp_position_orders.attr_1896_ <> 0
 GROUP BY orders.id
        , position_orders.id
        , comp_position_orders.id
        , reg_mat.id
        , reg_sort.id
        , reg_tr.id
        , units_nomenclature.id
        , units_reg_tr.id
        , units_reg_mat.id
        , tech_card.id
        , fact_mat.id
        , fact_sort.id
        , fact_tr.id
        , units_fact_tr.id
        , units_fact_mat.id
        , units_materials.id
        , work_task_comp.id
        , tech_op_list.master_amount
        , tech_op_list.amount_otk
        , tech_op_list.another_time
        , tech_op_list.cooperation
, tech_op_list.prin
,tech_op_list.id_accepted_list
        , nom_units.attr_1094_
				WINDOW accepted_partition AS (PARTITION BY tech_op_list.id_accepted_list ORDER BY comp_position_orders.attr_1414_)
)
,	resultat AS (SELECT dataset.*
			
			, CASE WHEN dataset.sum_general_count <= dataset.prin THEN dataset.general_count
						 WHEN ((dataset.sum_general_count - dataset.general_count) < dataset.prin) AND  dataset.sum_general_count > dataset.prin THEN
				dataset.prin - (dataset.sum_general_count - dataset.general_count)
				ELSE 0
				END::INT AS value_prin
						
   FROM dataset
     
		)
				SELECT resultat.* ,
CASE WHEN resultat.source <> 2 THEN 'не произв.' ELSE (general_count - value_prin)::varchar END  AS diff_vypusk
FROM resultat
           

				