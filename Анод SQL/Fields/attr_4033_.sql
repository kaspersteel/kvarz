SELECT -->>
CASE WHEN massive_ord.task_work_pos IS NOT NULL THEN 
massive_ord.mas_izd_ord 
ELSE ARRAY [comp_task_head.id] END
FROM registry.object_2137_ o -->>

WHERE o.is_deleted IS FALSE -->>
GROUP BY -->>