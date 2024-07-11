--SELECT
remnants.attr_1675_ - (
   SELECT SUM(comp_task.attr_2108_)
     FROM registry.object_2094_ comp_task
    WHERE comp_task.is_deleted <> TRUE
      AND comp_task.attr_3175_ = o.id
)
--FROM registry.object__ o
--GROUP BY