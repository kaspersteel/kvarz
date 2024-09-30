/*Заказы в производство*/
   SELECT -->>
          CASE
                    WHEN comp_task.ID IS NOT NULL THEN ARRAY[comp_task.attr_2102_]
                    ELSE massive_ord.mas_ord
          END
     FROM registry.object_2137_ o -->>
LEFT JOIN (
             SELECT comp_task.attr_3203_ AS nom_ed,
                    comp_task.attr_3204_ AS tech_card,
                    comp_task.attr_2173_ AS task_work,
                    comp_task.attr_3175_ AS task_work_pos,
                    comp_task.attr_2203_ AS ed_hran,
                    comp_task.attr_2104_ AS mat,
                    comp_task.attr_2105_ AS sort,
                    comp_task.attr_2106_ AS tr,
                    SUM(comp_task.attr_2103_)
                    /*массив id заказов*/
,
                    ARRAY_AGG(DISTINCT (ord_to_man.ID)) AS mas_ord
                    /*массив id изделий в справочнике номенклатуры*/
,
                    ARRAY_AGG(DISTINCT (comp_ord.attr_1482_)) AS mas_izd_nom
                    /*массив id изделий - головных компонентов*/
,
                    ARRAY_AGG(DISTINCT (comp_task.attr_2101_)) AS mas_izd_ord
               FROM registry.object_2094_ comp_task /*компоненты заданий в работу*/
                    /*Заказ в производство*/
          LEFT JOIN registry.object_606_ ord_to_man ON comp_task.attr_2102_ = ord_to_man.ID
                AND ord_to_man.is_deleted IS FALSE
                    /*Изделия*/
          LEFT JOIN registry.object_1409_ comp_ord ON comp_task.attr_2101_ = comp_ord.ID
                AND comp_ord.is_deleted IS FALSE
              WHERE comp_task.is_deleted IS FALSE
           GROUP BY comp_task.attr_3203_,
                    comp_task.attr_3204_,
                    comp_task.attr_2173_,
                    comp_task.attr_2203_,
                    comp_task.attr_2104_,
                    comp_task.attr_2105_,
                    comp_task.attr_2106_,
                    comp_task.attr_3175_
           ORDER BY comp_task.attr_3203_,
                    comp_task.attr_3204_,
                    comp_task.attr_2203_
          ) massive_ord ON massive_ord.task_work_pos = o.attr_3193_
      AND massive_ord.nom_ed = o.attr_2632_
          /*Ищем компоненты заданий в сборку.*/
          /*Они понадобятся, чтоб собрать списки заказов и изделий, так как в таких заданиях нет позиций*/
LEFT JOIN registry.object_2094_ comp_task ON comp_task.ID = ANY (o.attr_3904_)
      AND comp_task.is_deleted IS FALSE
          /*ищем изделия для компонентов*/
LEFT JOIN registry.object_1409_ comp_task_head ON comp_task.attr_2101_ = comp_task_head.ID
      AND comp_task_head.is_deleted IS FALSE
          /*Ищем сами задания для других формул, так как эта - базовая*/
LEFT JOIN registry.object_2093_ task ON o.attr_2226_ = task.id
      AND task.is_deleted IS FALSE
    WHERE o.is_deleted IS FALSE -->>      
 GROUP BY -->>
          massive_ord.mas_ord
        , comp_task.ID
        , massive_ord.mas_izd_nom
        , massive_ord.mas_izd_ord
        , massive_ord.task_work_pos
        , task.id