--SELECT
nado.id
--FROM registry.object_1409_ o
LEFT JOIN registry.object_301_ orn ON o.attr_1458_ = orn.ID 
AND orn.is_deleted IS FALSE 
LEFT JOIN registry.object_2094_ comp_task ON comp_task.attr_2100_ = o.ID 
AND comp_task.is_deleted IS FALSE 
LEFT JOIN registry.object_2137_ nado ON nado.attr_2632_ = orn.ID 
AND nado.is_deleted IS FALSE 
AND (comp_task.ID = ANY (nado.attr_3904_) 
     OR nado.attr_3414_ = comp_task.id)
--GROUP BY
nado.id