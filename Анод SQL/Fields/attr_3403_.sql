SELECT -->>
CASE WHEN massive_ord.task_work_pos IS NOT NULL THEN 
array_to_string(massive_ord.mas_izd_nom, '; ')  
ELSE array_to_string(ARRAY [comp_task_head.attr_1458_], '; ')  END
FROM registry.object_2137_ o -->>

WHERE o.is_deleted IS FALSE -->>
GROUP BY -->>