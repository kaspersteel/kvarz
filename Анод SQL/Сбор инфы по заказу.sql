   SELECT o.ID "606id",
          component.ID "1409id",
          component.attr_1458_ "c_NE",
          comp_head.ID "1409head_id",
          comp_head.attr_1458_ "c_head_NE",
          comp_task.ID "2094id",
          comp_task.attr_2101_,
          comp_task.attr_2102_,
          comp_task.attr_2173_,
          comp_task.attr_3203_,
          task.ID "2093id",
          accepted_list.ID "2137id",
          accepted_list.attr_2226_,
          accepted_list.attr_2675_,
          accepted_list.attr_2632_,
          accepted_list.attr_3264_,
          accepted_list.attr_4033_,
          (
             SELECT ARRAY_AGG(
                    DISTINCT CASE
                              WHEN c.attr_1414_ IS NOT NULL
                                    AND ARRAY[comp_head.attr_1458_] <@ accepted_list.attr_3264_ THEN comp_head.ID
                                        WHEN c.attr_1414_ IS NULL
                                    AND ARRAY[c.attr_1458_] <@ accepted_list.attr_3264_ THEN c.ID
                    END
                    )
               FROM registry.object_1409_ c
          LEFT JOIN registry.object_1409_ comp_head ON c.attr_1414_ = comp_head.ID
                AND comp_head.is_deleted IS FALSE
              WHERE c.attr_1650_::INT = ANY (accepted_list.attr_2675_)
                AND c.attr_1458_ = accepted_list.attr_2632_
                AND c.is_deleted IS FALSE
          ) "heads_array"
     FROM registry.object_606_ o
LEFT JOIN registry.object_1227_ project ON project.attr_1923_ = o.ID
      AND project.is_deleted IS FALSE
LEFT JOIN registry.object_1409_ component ON component.attr_1423_ = project.ID
      AND component.is_deleted IS FALSE
      AND component.attr_1896_ <> 0
LEFT JOIN registry.object_1409_ comp_head ON component.attr_1414_ = comp_head.ID
      AND comp_head.is_deleted IS FALSE
LEFT JOIN registry.object_2094_ comp_task ON comp_task.attr_2100_ = component.ID
      AND comp_task.is_deleted IS FALSE
LEFT JOIN registry.object_2093_ task ON task.ID = comp_task.attr_2173_
      AND task.is_deleted IS FALSE
LEFT JOIN registry.object_2137_ accepted_list ON accepted_list.is_deleted IS FALSE
          /*совпадает задание*/
      AND comp_task.attr_2173_ = accepted_list.attr_2226_
          /*совпадает заказ*/
      AND ARRAY[comp_task.attr_2102_] <@ (accepted_list.attr_2675_)
          /*совпадает НЕ*/
      AND comp_task.attr_3203_ = accepted_list.attr_2632_
          /*совпадает изделие*/
      AND ARRAY[comp_task.attr_2101_] <@ (
             SELECT ARRAY_AGG(
                    DISTINCT 
                    /*проверка выдаст NULL, если компоненты с одной НЕ в одном заказе, но изделия у них разные.*/
                    /*NULL на результат работы не влияет*/
                    CASE
                    /*если у компонента есть предок и НЕ предка входит в массив НЕ изделий ПВ - берем id предка*/
                              WHEN c.attr_1414_ IS NOT NULL
                                    AND ARRAY[comp_head.attr_1458_] <@ accepted_list.attr_3264_ THEN comp_head.ID
                    /*если у компонента нет предка и его НЕ входит в массив НЕ изделий ПВ - берем id компонента*/                
                              WHEN c.attr_1414_ IS NULL
                                    AND ARRAY[c.attr_1458_] <@ accepted_list.attr_3264_ THEN c.ID
                    END
                    )
               FROM registry.object_1409_ c
          LEFT JOIN registry.object_1409_ comp_head ON c.attr_1414_ = comp_head.ID
                AND comp_head.is_deleted IS FALSE
              WHERE c.attr_1650_::INT = ANY (accepted_list.attr_2675_)
                AND c.attr_1458_ = accepted_list.attr_2632_
                AND c.is_deleted IS FALSE
          )
    WHERE o.is_deleted IS FALSE
      AND o.ID = 533
      AND component.attr_1896_ <> 0
      AND comp_task.id IS NOT NULL
 ORDER BY component.id