   SELECT sprav_tape_mat.id,
          CASE
                    WHEN sprav_tape_mat.id = 6 THEN 'шт'
                    ELSE CASE
                              WHEN o1.form_sort = 2 THEN 'кг'
                              ELSE 'кг/мм'
                    END
          END AS units,
          o1.name_ed_hran,
          CASE
                    WHEN sprav_tape_mat.id = 6 THEN cur_task_m::text
                    ELSE CASE
                              WHEN o1.form_sort = 2 THEN cur_task_m::text
                              ELSE cur_task_m || '/' || cur_task_l
                    END
          END AS limits,
          CASE
                    WHEN sprav_tape_mat.id = 6 THEN cur_task_m::text
                    ELSE CASE
                              WHEN o1.form_sort = 2 THEN ed_hran_cur_bal_m::text
                              ELSE ed_hran_cur_bal_m || '/' || ed_hran_cur_bal_l
                    END
          END AS released,
          CASE
                    WHEN sprav_tape_mat.id = 6 THEN '0'
                    ELSE CASE
                              WHEN o1.form_sort = 2 THEN expected_bal_m::text
                              ELSE expected_bal_m || '/' || expected_bal_l
                    END
          END AS expected_balance,
          CASE
                    WHEN sprav_tape_mat.id = 6 THEN '0'
                    ELSE CASE
                              WHEN o1.form_sort = 2 THEN return_m::text
                              ELSE return_m || '/' || return_l
                    END
          END AS returned,
          mas_orders,
          mas_izdel,
          mas_description,
          mas_detal
     FROM (
             SELECT ed_hran.id AS ed_hran_id,
                    ed_hran.attr_2214_ AS form_sort,
                    ed_hran.attr_1663_ AS mat_id,
                    ed_hran.attr_1664_ AS sort_id,
                    ed_hran.attr_1665_ AS tr_id,
                    ed_hran.attr_2943_ AS type_mat,
                    ed_hran.attr_2204_ AS name_ed_hran,
                    ARRAY_TO_STRING(ARRAY_AGG(orders.attr_607_), '; ') AS mas_orders,
                    ARRAY_TO_STRING(ARRAY_AGG(DISTINCT (izdel.attr_1410_)), '; ') AS mas_izdel,
                    ARRAY_TO_STRING(
                    ARRAY_AGG(DISTINCT (comp_orders.attr_1410_)),
                    '; '
                    ) AS mas_description,
                    ARRAY_TO_STRING(
                    ARRAY_AGG(DISTINCT (comp_orders.attr_1413_)),
                    '; '
                    ) AS mas_detal,
                    (
                       SELECT CASE
                                        WHEN units_eq.attr_2943_ = 6 THEN 0
                                        ELSE SUM(
                                        (comp_poz_work.attr_2588_ + 2) * comp_poz_work.attr_2103_
                                        )
                              END AS leight
                         FROM registry.object_3168_ poz_work
                    LEFT JOIN registry.object_2094_ comp_poz_work ON poz_work.id = comp_poz_work.attr_3175_
                    LEFT JOIN registry.object_1659_ units_eq ON poz_work.attr_3169_ = units_eq.id
                        WHERE poz_work.is_deleted <> TRUE
                          AND poz_work.id = position_of_task.id
                     GROUP BY poz_work.id,
                              units_eq.attr_2943_
                    ) AS cur_task_l,
                    (
                       SELECT CASE
                                        WHEN units_eq.attr_2943_ = 6 THEN SUM(comp_poz_work.attr_2103_)
                                        ELSE SUM(
                                        comp_poz_work.attr_2107_ * comp_poz_work.attr_2103_
                                        )
                              END AS amoun_massa
                         FROM registry.object_3168_ poz_work
                    LEFT JOIN registry.object_2094_ comp_poz_work ON poz_work.id = comp_poz_work.attr_3175_
                    LEFT JOIN registry.object_1659_ units_eq ON poz_work.attr_3169_ = units_eq.id
                        WHERE poz_work.is_deleted <> TRUE
                          AND poz_work.id = position_of_task.id
                     GROUP BY poz_work.id,
                              units_eq.attr_2943_
                    ) AS cur_task_m,
                    ed_hran.attr_1675_ AS ed_hran_cur_bal_m,
                    ed_hran.attr_2209_ AS ed_hran_cur_bal_l,
                    (
                    ed_hran.attr_1675_ - (
                       SELECT CASE
                                        WHEN units_eq.attr_2943_ = 6 THEN SUM(comp_poz_work.attr_2103_)
                                        ELSE SUM(
                                        comp_poz_work.attr_2107_ * comp_poz_work.attr_2103_
                                        )
                              END AS amoun_massa
                         FROM registry.object_3168_ poz_work
                    LEFT JOIN registry.object_2094_ comp_poz_work ON poz_work.id = comp_poz_work.attr_3175_
                    LEFT JOIN registry.object_1659_ units_eq ON poz_work.attr_3169_ = units_eq.id
                        WHERE poz_work.is_deleted <> TRUE
                          AND poz_work.id = position_of_task.id
                     GROUP BY poz_work.id,
                              units_eq.attr_2943_
                    )
                    ) AS expected_bal_m,
                    (
                    ed_hran.attr_2209_ - (
                       SELECT CASE
                                        WHEN units_eq.attr_2943_ = 6 THEN 0
                                        ELSE SUM(
                                        (comp_poz_work.attr_2588_ + 2) * comp_poz_work.attr_2103_
                                        )
                              END AS leight
                         FROM registry.object_3168_ poz_work
                    LEFT JOIN registry.object_2094_ comp_poz_work ON poz_work.id = comp_poz_work.attr_3175_
                    LEFT JOIN registry.object_1659_ units_eq ON poz_work.attr_3169_ = units_eq.id
                        WHERE poz_work.is_deleted <> TRUE
                          AND poz_work.id = position_of_task.id
                     GROUP BY poz_work.id,
                              units_eq.attr_2943_
                    )
                    ) AS expected_bal_l,
                    position_of_task.attr_3252_ AS return_m,
                    position_of_task.attr_3251_ AS return_l
               FROM registry.object_2093_ task
          LEFT JOIN registry.object_3168_ position_of_task ON position_of_task.attr_3173_ = task.id
                AND position_of_task.is_deleted <> TRUE
          LEFT JOIN registry.object_1659_ ed_hran ON position_of_task.attr_3169_ = ed_hran.id
          LEFT JOIN registry.object_2094_ comp_task ON comp_task.attr_3175_ = position_of_task.id
                AND comp_task.attr_2173_ = task.id
                AND comp_task.is_deleted <> TRUE
          LEFT JOIN registry.object_606_ orders ON comp_task.attr_2102_ = orders.id
                AND orders.is_deleted <> TRUE
          LEFT JOIN registry.object_1409_ izdel ON comp_task.attr_2101_ = izdel.id
                AND izdel.is_deleted <> TRUE
          LEFT JOIN registry.object_1409_ comp_orders ON comp_task.attr_2100_ = comp_orders.id
                AND comp_orders.is_deleted <> TRUE
              WHERE task.is_deleted <> TRUE
                AND position_of_task.attr_3169_ IS NOT NULL
                AND task.id = '{super_id}'
           GROUP BY ed_hran.id,
                    ed_hran.attr_2214_,
                    ed_hran.attr_1663_,
                    ed_hran.attr_1664_,
                    ed_hran.attr_1665_,
                    ed_hran.attr_2943_,
                    ed_hran.attr_2204_,
                    position_of_task.id
          ) o1
LEFT JOIN registry.object_1344_ sprav_tape_mat ON o1.type_mat = sprav_tape_mat.id