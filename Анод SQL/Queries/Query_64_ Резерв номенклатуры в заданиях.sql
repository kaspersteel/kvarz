SELECT
    orders.attr_607_ AS num_order
    , o.attr_2174_ AS num_task
    , nomenclature.attr_362_ AS name
    , nomenclature.attr_376_ AS designation
    , SUM(comp_orders.attr_1896_) AS sum_count
    , array_agg (components.id) AS comp_tasks_ids
    , array_agg (comp_orders.id) AS comp_orders_ids
FROM
    registry.object_2093_ o
    LEFT JOIN registry.object_2094_ components ON components.attr_2173_ = o.id
    AND NOT components.is_deleted
    LEFT JOIN registry.object_1409_ comp_orders ON comp_orders.id = components.attr_2100_
    AND NOT components.is_deleted
    LEFT JOIN registry.object_301_ nomenclature ON nomenclature.id = comp_orders.attr_1482_
    AND NOT nomenclature.is_deleted
    LEFT JOIN registry.object_606_ orders ON orders.id = components.attr_2102_
    AND NOT orders.is_deleted
WHERE
    NOT o.is_deleted
    AND o.attr_3206_
    AND NOT (components.id is null OR comp_orders.id is null OR nomenclature.id is null OR orders.id is null)
    AND comp_orders.attr_1482_ = {a_1482}
GROUP BY
    nomenclature.id,
    o.attr_2174_,
    orders.attr_607_
ORDER BY
    orders.attr_607_,
    o.attr_2174_,
    nomenclature.attr_376_