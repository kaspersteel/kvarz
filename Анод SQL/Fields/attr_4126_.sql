SELECT -->>
CASE WHEN (COUNT(*) FILTER(WHERE tab_invoice.attr_3450_ IS FALSE)) = 0 THEN TRUE ELSE FALSE END
FROM registry.object_2112_ o -->>
LEFT JOIN registry.object_2111_ tab_invoice ON tab_invoice.attr_2126_ = o.id
AND tab_invoice.is_deleted IS FALSE
WHERE o.is_deleted IS FALSE -->>
