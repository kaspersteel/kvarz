/*Информация о компонентах в задании*/
SELECT -->
/*выбрать компоненты без единиц хранения либо список изделий по заказу list*/
COALESCE ( o.attr_3197_, list)
FROM registry.object_3168_ o -->
LEFT JOIN (
WITH 
/* Агрегация компонентов по изделиям */
products AS (
    SELECT 
        pwt.id AS pwt_id,
        comp_task.attr_2102_ AS order_prod,
        pos_ord.attr_1410_ AS pos_designation,
        concat_ws(
            ' - ', 
            pos_ord.attr_1410_, 
            string_agg(
                CASE 
                    WHEN comp_ord.attr_1421_ = 9 THEN concat(comp_ord.attr_1410_, ' (отменён)')
                    ELSE comp_ord.attr_1410_
                END, 
                ', '
            ) FILTER (WHERE comp_ord.attr_1410_ IS NOT NULL)
        ) AS list_p_with_comps
    FROM registry.object_3168_ pwt
    LEFT JOIN registry.object_2094_ comp_task 
        ON comp_task.attr_3175_ = pwt.id AND comp_task.is_deleted IS FALSE
    LEFT JOIN registry.object_1409_ comp_ord 
        ON comp_task.attr_2100_ = comp_ord.id AND comp_ord.is_deleted IS FALSE
    LEFT JOIN registry.object_1409_ pos_ord 
        ON comp_ord.attr_1414_ = pos_ord.id AND pos_ord.is_deleted IS FALSE
    WHERE pwt.is_deleted IS FALSE
    GROUP BY pwt.id, comp_task.attr_2102_, pos_ord.attr_1410_
),

/* Сборка списка компонентов */
components AS (
    SELECT 
        p.pwt_id AS id,
        concat_ws(
            ' - ', 
            concat('Заказ № ', ord.attr_607_), 
            string_agg(p.list_p_with_comps, '; ')
        ) AS list
    FROM products p
    JOIN registry.object_606_ ord ON p.order_prod = ord.id AND ord.is_deleted IS FALSE
    GROUP BY p.pwt_id, p.list_p_with_comps, ord.attr_607_
)

    SELECT id, string_agg(DISTINCT list, E'\n') AS list 
    FROM components
    GROUP BY id
                ) pos_task ON pos_task.id = o.id
WHERE NOT o.is_deleted -->
GROUP BY -->
o.id, pos_task.id, pos_task.list