   SELECT ord.attr_607_ AS order_num
        , SUM(t_op.attr_1443_) AS time_for_cut
     FROM registry.object_606_ ord
LEFT JOIN registry.object_1227_ project ON ord.id = project.attr_1923_
      AND project.is_deleted IS FALSE
LEFT JOIN registry.object_1409_ comp ON project.id = comp.attr_1423_
      AND comp.is_deleted IS FALSE
      AND comp.attr_3183_ IS NOT TRUE
LEFT JOIN registry.object_519_ tech_card ON (
          CASE
                    WHEN comp.attr_1463_ = 2
                           OR comp.attr_1421_ IN (6, 4) THEN tech_card.attr_1466_
                              ELSE tech_card.attr_520_
          END = CASE
                    WHEN comp.attr_1463_ = 2
                           OR comp.attr_1421_ IN (6, 4) THEN comp.ID
                              ELSE comp.attr_1482_
          END
          ) /*выбираем карту из компонента, если его изменили или создали не из ном. ед.*/
      AND tech_card.is_deleted IS FALSE
      AND tech_card.attr_2908_ IS TRUE /*активная карта*/
LEFT JOIN registry.object_527_ t_op ON t_op.attr_538_ = tech_card.id
      AND t_op.attr_586_ = '39'
    WHERE ord.is_deleted IS FALSE
      AND ord.id != 74
 GROUP BY ord.id
 ORDER BY ord.id DESC