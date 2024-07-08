--SELECT
ed_hran.attr_3130_
--FROM registry.object_3168_ o
LEFT JOIN registry.object_1659_ ed_hran ON o.attr_3169_ = ed_hran.id
      AND ed_hran.is_deleted IS FALSE
--GROUP BY
ed_hran.id