/*несохраняемая с базовой в attr_3185_*/
--SELECT
CASE
          WHEN o.attr_3244_ = 2 THEN CONCAT(o.attr_3187_, '/', o.attr_3188_)
          WHEN o.attr_3244_ IS NULL
                 OR o.attr_3244_ = 1 THEN CONCAT(
                    remnants.attr_1675_ - (
                       SELECT SUM(comp_task.attr_2108_)
                         FROM registry.object_2094_ comp_task
                        WHERE comp_task.is_deleted <> TRUE
                          AND comp_task.attr_3175_ = o.ID
                    )
                  , '/'
                  , remnants.attr_2209_ - (
                       SELECT SUM(o1.attr_2626_)
                         FROM registry.object_2094_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_3175_ = o.ID
                    )
                    )
END
--FROM registry.object__ o

--GROUP BY