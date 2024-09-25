   SELECT -->
          nado.id
     FROM registry.object_1409_ o -->
LEFT JOIN registry.object_2094_ comp_task ON comp_task.attr_2100_ = o.ID
      AND comp_task.is_deleted IS FALSE
LEFT JOIN registry.object_2137_ nado ON nado.is_deleted IS FALSE
      AND comp_task.id = ANY (nado.attr_3904_)
       OR (
          nado.attr_2632_ = o.attr_1458_
      AND o.attr_1414_::INT = ANY (nado.attr_4033_)
      AND nado.attr_3193_ = comp_task.attr_3175_
          )
/*
LEFT JOIN registry.object_2094_ comp_task ON comp_task.attr_2100_ = o.ID
      AND comp_task.is_deleted IS FALSE
LEFT JOIN registry.object_2137_ nado ON nado.attr_2632_ = o.attr_1458_
      AND nado.is_deleted IS FALSE
      AND COALESCE(o.attr_1414_, o.id)::INT = ANY (nado.attr_4033_)
      AND ( nado.attr_3193_ = comp_task.attr_3175_
       OR comp_task.id = ANY (nado.attr_3904_) )
*/
    WHERE o.is_deleted IS FALSE -->>
 GROUP BY -->
          nado.id


