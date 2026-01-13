SELECT
    e1.entity_id,	e1.xref_attr_id,	e1.xref_object_id,	e1.entity_type_id,	e1.object_id
FROM
    registry.xref_settings e1
WHERE e1.entity_type_id = 'xref_field'
    AND e1.xref_object_id = 102