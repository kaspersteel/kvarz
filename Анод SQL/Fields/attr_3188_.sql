--SELECT
remnants.attr_2209_ - (
   SELECT SUM(o1.attr_2626_)
     FROM registry.object_2094_ o1
    WHERE o1.is_deleted <> TRUE
      AND o1.attr_3175_ = o.id
)
--FROM registry.object__ o
--GROUP BY