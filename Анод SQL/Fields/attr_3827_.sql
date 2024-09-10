--SELECT
nado.id
--FROM registry.object_1409_ o
LEFT JOIN registry.object_2094_ comp_task ON comp_task.attr_2100_ = o.ID 
AND comp_task.is_deleted IS FALSE 
LEFT JOIN registry.object_2137_ nado ON nado.attr_2632_ = o.attr_1458_
      AND nado.is_deleted IS FALSE 
      AND o.attr_1414_::INTEGER = ANY (nado.attr_4033_)
      AND nado.attr_3193_ = comp_task.attr_3175_
--GROUP BY
          nado.id