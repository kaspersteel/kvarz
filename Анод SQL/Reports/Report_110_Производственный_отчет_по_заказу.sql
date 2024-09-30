     WITH
          /*таблица производственных данных: данные по ПВ, приемкам, оприходованию*/
          tech_op_list AS (
             SELECT accepted_list.id AS id_accepted_list,
                    accepted_list.attr_3193_ position_task_id,
                    accepted_list.attr_3904_ array_comp_task,
                    accepted_list.attr_2632_ nom_units,
                    accepted_list.attr_2167_ id_units_materials,
                    accepted_list.attr_4033_ array_izd,
                    SUM(
                    CASE
                              WHEN accepted_list_table_part.attr_3433_ IS NULL
                                    AND accepted_list_table_part.attr_3208_ <= (
                                           SELECT MAX(a.attr_3208_)
                                             FROM registry.object_2138_ a
                                            WHERE a.is_deleted = FALSE
                                              AND a.attr_2152_ IS NOT NULL
                                              AND a.attr_2148_ = accepted_list.id
                                        ) THEN accepted_list_table_part.attr_3373_
                                        ELSE 0
                    END
                    ) master_amount,
                    SUM(accepted_list_table_part.attr_3373_) amount_otk,
                    CASE
                              WHEN (
                                 SELECT nomen.attr_2869_
                                   FROM registry.object_301_ nomen
                                  WHERE nomen.is_deleted IS FALSE
                                    AND nomen.id = accepted_list.attr_2632_
                              ) IS TRUE THEN SUM(accept.sum_another_time)
                              ELSE 0
                    END another_time,
                    SUM(
                    CASE
                              WHEN accepted_list_table_part.attr_3433_ IS NOT NULL THEN accepted_list_table_part.attr_3373_
                              ELSE 0
                    END
                    ) cooperation,
                    docs.prin prin
               FROM registry.object_2137_ accepted_list
          LEFT JOIN registry.object_2138_ accepted_list_table_part ON accepted_list_table_part.attr_2148_ = accepted_list.id
                AND accepted_list_table_part.is_deleted IS FALSE
                    /*извлекаем суммарное "прочее время" из резолюций по ПВ*/
          LEFT JOIN (
                       SELECT o.attr_3276_,
                              o.attr_3277_,
                              SUM(o.attr_3283_) AS sum_another_time
                         FROM registry.object_3273_ o
                        WHERE o.is_deleted IS FALSE
                     GROUP BY o.attr_3276_,
                              o.attr_3277_
                    ) accept ON accept.attr_3276_ = accepted_list.id
                AND accept.attr_3277_ = accepted_list_table_part.id
                    /*извлекаем суммарную информацию об оприходовании номенклатуры по ПВ*/
          LEFT JOIN (
                       SELECT doc.attr_3441_ link_pv,
                              SUM(doc.attr_3081_) prin
                         FROM registry.object_3023_ doc
                        WHERE doc.is_deleted IS FALSE
                          AND doc.attr_3028_ IS TRUE
                     GROUP BY doc.attr_3441_
                    ) docs ON docs.link_pv = accepted_list.id
              WHERE accepted_list.is_deleted IS FALSE
           GROUP BY accepted_list.id,
                    docs.prin
           ORDER BY accepted_list.id DESC
          ),
          /*таблица со всеми данными по компонентам*/
          dataset AS (
             SELECT orders.id AS orders_id,
                    position_orders.id AS position_orders_id,
                    orders.attr_607_ AS order_num,
                    nom_tech_card.id AS nom_tech_card,
                    comp_position_orders.id AS comp_position_orders_id,
                    comp_position_orders.attr_1414_ AS parent_id,
                    tech_op_list.id_accepted_list AS id_accepted_list,
                    SUM(comp_position_orders.attr_1896_) OVER accepted_partition AS sum_general_count,
                    tech_op_list.prin AS prin,
                    comp_position_orders.attr_2042_ AS source,
                    work_task_comp.id AS id_work_task_comp,
                    CASE
                              WHEN comp_position_orders.attr_1411_ IN (1, 8, 9, 10, 11) THEN 1
                              WHEN comp_position_orders.attr_1411_ = 2 THEN 2
                              WHEN comp_position_orders.attr_1411_ = 3 THEN 3
                              WHEN comp_position_orders.attr_1411_ IN (6, 7)
                                    AND nom_units.attr_1094_ <> 216 THEN 4
                                        WHEN comp_position_orders.attr_1411_ IN (6, 7)
                                    AND nom_units.attr_1094_ = 216 THEN 5
                                        ELSE comp_position_orders.attr_1411_
                    END AS type_ne,
                    COALESCE(
                    comp_position_orders.attr_1518_,
                    comp_position_orders.attr_1410_
                    ) AS article_comp,
                    comp_position_orders.attr_1839_ AS name_comp,
                    COALESCE(
                    comp_position_orders.attr_2433_,
                    comp_position_orders.attr_1412_
                    ) AS one_count,
                    comp_position_orders.attr_1896_ AS general_count,
                    CASE
                              WHEN comp_position_orders.attr_1411_ = 82 THEN CONCAT_WS(' ', mat.attr_401_)
                              ELSE CONCAT_WS(
                              ' ',
                              reg_mat.attr_2976_,
                              reg_sort.attr_401_,
                              reg_tr.attr_401_
                              )
                    END AS name_reg_mat,
                    CASE
                              WHEN comp_position_orders.attr_1411_ IN (1, 2, 6, 8, 9) THEN units_nomenclature.attr_390_
                              WHEN comp_position_orders.attr_1411_ = 82 THEN units__mat.attr_390_
                              ELSE CASE
                                        WHEN units_reg_tr.attr_390_ IS NULL THEN units_reg_mat.attr_390_
                                        ELSE units_reg_tr.attr_390_
                              END
                    END AS name_units_reg_mat,
                    /*если сборочная единица или стандартная деталь, то выбираем между исходным и новым количеством, если деталь - берем массу детали из техкарты НЕ*/
                    CASE
                              WHEN comp_position_orders.attr_1411_ IN (1, 2, 6, 8, 9) THEN COALESCE(
                              comp_position_orders.attr_1412_,
                              comp_position_orders.attr_2433_
                              )
                              WHEN comp_position_orders.attr_1411_ = 82 THEN comp.attr_3926_
                              ELSE nom_tech_card.attr_3271_
                    END AS reg_amount,
                    /*если деталь - считаем массу заготовки, в остальных случаях берем общее количество из заказа*/
                    CASE
                              WHEN comp_position_orders.attr_1411_ IN (1, 2, 6, 8, 9) THEN comp_position_orders.attr_1896_
                              ELSE CASE
                                        WHEN nom_tech_card.attr_2554_ IS TRUE THEN (
                                        nom_tech_card.attr_1908_ * CEILING(
                                        comp_position_orders.attr_1896_::NUMERIC(5, 2) / nom_tech_card.attr_2907_::NUMERIC(5, 2)
                                        )
                                        ) + (
                                        COALESCE(nom_tech_card.attr_4105_, 0) * CEILING(
                                        comp_position_orders.attr_1896_::NUMERIC(5, 2) / nom_tech_card.attr_2555_::NUMERIC(5, 2)
                                        )
                                        )
                                        WHEN nom_tech_card.attr_2554_ IS FALSE THEN comp_position_orders.attr_1896_ * nom_tech_card.attr_1908_
                                        WHEN comp_position_orders.attr_1411_ = 82 THEN comp_position_orders.attr_1896_ * comp.attr_3926_
                              END
                    END AS sum_reg_amount,
                    CASE
                              WHEN comp_position_orders.attr_2042_ = 2 THEN CONCAT_WS(
                              ' ',
                              fact_mat.attr_2976_,
                              fact_sort.attr_401_,
                              fact_tr.attr_401_
                              )
                    END AS name_fact_mat,
                    CASE
                              WHEN comp_position_orders.attr_1411_ IN (1, 2, 6, 8, 9)
                                    AND comp_position_orders.attr_2042_ = 2 THEN units_nomenclature.attr_390_
                                        ELSE (
                                        CASE
                                                  WHEN comp_position_orders.attr_2042_ = 2 THEN COALESCE(units_fact_tr.attr_390_, units_fact_mat.attr_390_)
                                        END
                                        )
                    END AS name_units_fact_mat,
                    /*если компонент - не деталь, то берем единицу(?), если деталь - берем массу детали из карты, пошедшей в производство */
                    CASE
                              WHEN comp_position_orders.attr_1411_ IN (1, 2, 6, 8, 9)
                                    AND comp_position_orders.attr_2042_ = 2 THEN 1
                                        ELSE (
                                        CASE
                                                  WHEN comp_position_orders.attr_2042_ = 2
                                                        AND comp_position_orders.attr_3934_ IS FALSE
                                                        AND poz.attr_3231_ IS TRUE THEN prod_tech_card.attr_3271_
                                                            ELSE 0
                                        END
                                        )
                    END AS fact_amount,
                    /*если компонент - не деталь, то берем его общее кол-во из заказа, если деталь - берем общую массу заготовок из компонента*/
                    CASE
                              WHEN comp_position_orders.attr_1411_ IN (1, 2, 6, 8, 9)
                                    AND comp_position_orders.attr_2042_ = 2 THEN work_task_comp.attr_3419_
                                        ELSE (
                                        CASE
                                                  WHEN comp_position_orders.attr_2042_ = 2
                                                        AND comp_position_orders.attr_3934_ IS FALSE
                                                        AND poz.attr_3231_ IS TRUE THEN work_task_comp.attr_2108_
                                                            ELSE 0
                                        END
                                        )
                    END AS sum_fact_amount,
                    /*SUM(tp_tech_card.attr_1443_) AS sum_norm_time,*/
                    nom_tech_card.attr_1449_ AS sum_norm_time,
                    ROUND(
                    tech_op_list.master_amount * comp_position_orders.attr_1896_,
                    2
                    ) master_work_hours,
                    ROUND(
                    tech_op_list.amount_otk * comp_position_orders.attr_1896_,
                    2
                    ) otk_work_hours,
                    ROUND(
                    tech_op_list.another_time * comp_position_orders.attr_1896_ + (
                       SELECT SUM(task.attr_4122_)
                         FROM registry.object_329_ task
                        WHERE task.is_deleted IS FALSE
                          AND task.attr_4089_ = comp_position_orders.id
                    ),
                    2
                    ) another_time,
                    ROUND(
                    tech_op_list.cooperation * comp_position_orders.attr_1896_,
                    2
                    ) cooperation
               FROM registry.object_606_ orders
          LEFT JOIN registry.object_1227_ position_orders ON position_orders.attr_1923_ = orders.id
                AND position_orders.is_deleted IS FALSE
                AND (
                    position_orders.attr_1948_ <> 1
                 OR position_orders.attr_1948_ IS NULL
                    )
          LEFT JOIN registry.object_1409_ comp_position_orders ON comp_position_orders.attr_1423_ = position_orders.id
                AND comp_position_orders.is_deleted IS FALSE
                AND (
                    comp_position_orders.attr_1421_ <> 1
                 OR comp_position_orders.attr_1421_ IS NULL
                    )
          LEFT JOIN registry.object_301_ nom_units ON comp_position_orders.attr_1458_ = nom_units.id
          LEFT JOIN registry.object_389_ units_nomenclature ON nom_units.attr_379_ = units_nomenclature.id
          LEFT JOIN registry.object_519_ nom_tech_card ON comp_position_orders.attr_1458_ = nom_tech_card.attr_520_
                AND nom_tech_card.is_deleted IS FALSE
                AND nom_tech_card.attr_2908_ IS TRUE
          LEFT JOIN registry.object_527_ tp_tech_card ON tp_tech_card.attr_538_ = nom_tech_card.id
                AND tp_tech_card.is_deleted IS FALSE
          LEFT JOIN registry.object_400_ reg_mat ON nom_tech_card.attr_2381_ = reg_mat.id
          LEFT JOIN registry.object_400_ reg_sort ON nom_tech_card.attr_1876_ = reg_sort.id
          LEFT JOIN registry.object_400_ reg_tr ON nom_tech_card.attr_1877_ = reg_tr.id
          LEFT JOIN registry.object_389_ units_reg_mat ON reg_mat.attr_1673_ = units_reg_mat.id
          LEFT JOIN registry.object_389_ units_reg_tr ON reg_tr.attr_1673_ = units_reg_tr.id
          LEFT JOIN registry.object_519_ prod_tech_card ON prod_tech_card.id = comp_position_orders.attr_4085_
          LEFT JOIN registry.object_527_ tp_comp_tech_card ON tp_comp_tech_card.attr_538_ = prod_tech_card.id
                AND tp_comp_tech_card.is_deleted IS FALSE
          LEFT JOIN registry.object_369_ comp ON comp_position_orders.attr_3969_ = comp.id
          LEFT JOIN registry.object_400_ mat ON comp.attr_3967_ = mat.id
          LEFT JOIN registry.object_389_ units__mat ON comp.attr_3925_ = units__mat.id
          LEFT JOIN registry.object_2094_ work_task_comp ON work_task_comp.attr_2100_ = comp_position_orders.id
                AND work_task_comp.is_deleted IS FALSE
          LEFT JOIN registry.object_3168_ poz ON poz.id = work_task_comp.attr_3175_
                AND poz.is_deleted IS FALSE
                    /*извлекаем из таблицы производственных данных записи по информации из ПВ. 
                    Для собираемых компонентов по наличию их в массиве производимых компонентов. 
                    Для несобираемых - по соответствию номенклатуры, узлу в позиции заказа и*/
          LEFT JOIN tech_op_list ON work_task_comp.id = ANY (tech_op_list.array_comp_task)
                 OR (
                    tech_op_list.nom_units = comp_position_orders.attr_1458_
                AND comp_position_orders.attr_1414_::INT = ANY (tech_op_list.array_izd)
                AND tech_op_list.position_task_id = work_task_comp.attr_3175_
                    )
          LEFT JOIN registry.object_400_ fact_mat ON prod_tech_card.attr_2381_ = fact_mat.id
          LEFT JOIN registry.object_400_ fact_sort ON prod_tech_card.attr_1876_ = fact_sort.id
          LEFT JOIN registry.object_400_ fact_tr ON prod_tech_card.attr_1877_ = fact_tr.id
          LEFT JOIN registry.object_389_ units_fact_mat ON fact_mat.attr_1673_ = units_fact_mat.id
          LEFT JOIN registry.object_389_ units_fact_tr ON fact_tr.attr_1673_ = units_fact_tr.id
              WHERE orders.is_deleted IS FALSE
                AND orders.id = '{superid}'
                AND comp_position_orders.attr_1896_ <> 0
           GROUP BY orders.id,
                    position_orders.id,
                    comp_position_orders.id,
                    reg_mat.id,
                    reg_sort.id,
                    reg_tr.id,
                    units_nomenclature.id,
                    units_reg_tr.id,
                    units_reg_mat.id,
                    nom_tech_card.id,
                    prod_tech_card.id,
                    fact_mat.id,
                    fact_sort.id,
                    fact_tr.id,
                    units_fact_tr.id,
                    units_fact_mat.id,
                    work_task_comp.id,
                    tech_op_list.master_amount,
                    tech_op_list.amount_otk,
                    tech_op_list.another_time,
                    tech_op_list.cooperation,
                    tech_op_list.prin,
                    tech_op_list.id_accepted_list,
                    nom_units.id,
                    poz.attr_3231_,
                    mat.attr_401_,
                    units__mat.attr_390_,
                    comp.attr_3926_,
                    mat.attr_2976_,
                    nom_tech_card.attr_1449_
             WINDOW accepted_partition AS (
                    PARTITION BY tech_op_list.id_accepted_list
                     ORDER BY comp_position_orders.attr_1414_
                    )
           ORDER BY comp_position_orders.id
          ),
          /*таблица данных с дополнительными расчетами*/
          calculate AS (
             SELECT dataset.*,
                    /*отклонение по материалам*/
                    dataset.sum_reg_amount - dataset.sum_fact_amount AS differense,
                    /*распределение оприходованного по ПВ на компоненты, изготавливаемые по этой ПВ*/
                    CASE
                              WHEN dataset.sum_general_count <= dataset.prin THEN dataset.general_count
                              WHEN (dataset.sum_general_count - dataset.general_count) < dataset.prin
                                    AND dataset.sum_general_count > dataset.prin THEN dataset.prin - (dataset.sum_general_count - dataset.general_count)
                                        ELSE 0
                    END::INT AS value_prin
               FROM dataset
          )
          /*результирующий запрос*/
   SELECT calculate.*,
          CASE
                    WHEN calculate.source <> 2 THEN 'не произв.'
                    ELSE (general_count - value_prin)::VARCHAR
          END AS diff_vypusk
     FROM calculate