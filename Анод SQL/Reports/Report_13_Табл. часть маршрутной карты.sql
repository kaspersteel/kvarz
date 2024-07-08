SELECT
	o.*
,	to_type1.attr_547_ name_type_operation
,	o.attr_628_ under_step
,	concat(preambula.attr_1845_, o.attr_1846_) text_preambula
,	concat_ws(
		'\n'
	,	array_to_string(
			array_agg(DISTINCT concat_ws('\n', os2.attr_468_)) FILTER(WHERE os2.id IS NOT NULL)
		,	', '
		)
	,	array_to_string(
			array_agg(DISTINCT concat_ws('\n', os4.attr_2916_)) FILTER(WHERE os4.id IS NOT NULL)
		,	', '
		)
	,	array_to_string(
			array_agg(DISTINCT concat_ws('\n', instrct.attr_561_)) FILTER(WHERE instrct.id IS NOT NULL)
		,	', '
		)
	,	array_to_string(
			array_agg(DISTINCT concat_ws('\n', osnastka_nom.attr_362_)) FILTER(WHERE osnastka_nom.id IS NOT NULL)
		,	', '
		)
	,	array_to_string(
			array_agg(DISTINCT concat_ws('\n', vs_m.attr_401_)) FILTER(WHERE vs_m.id IS NOT NULL)
		,	', '
		)
	) oborudovanie_and_yet
FROM
	registry.object_527_ o
LEFT JOIN
	registry.object_1844_ preambula
		ON preambula.id = o.attr_1847_ AND
		preambula.is_deleted <> TRUE
LEFT JOIN
	registry.object_545_ to_type1
		ON to_type1.id = o.attr_586_ AND
		to_type1.is_deleted <> TRUE
LEFT JOIN
	registry.xref_534_ mnss2
		ON mnss2.from_id = o.id
LEFT JOIN
	registry.object_466_ os2
		ON mnss2.to_id = os2.id AND
		os2.is_deleted <> TRUE
LEFT JOIN
	registry.xref_535_ inosnov
		ON inosnov.from_id = o.id
LEFT JOIN
	registry.object_454_ os4
		ON inosnov.to_id = os4.id AND
		os4.is_deleted <> TRUE
LEFT JOIN
	registry.xref_536_ instrrr
		ON instrrr.from_id = o.id
LEFT JOIN
	registry.object_544_ instrct
		ON instrrr.to_id = instrct.id AND
		instrct.is_deleted <> TRUE
LEFT JOIN
	registry.xref_2873_ osnastka
		ON osnastka.from_id = o.id
LEFT JOIN
	registry.object_301_ osnastka_nom
		ON osnastka.to_id = osnastka_nom.id AND
		osnastka_nom.is_deleted <> TRUE
LEFT JOIN
	registry.xref_2880_ vs_material
		ON vs_material.from_id = o.id
LEFT JOIN
	registry.object_400_ vs_m
		ON vs_material.to_id = vs_m.id AND
		vs_m.is_deleted <> TRUE
WHERE
	o.is_deleted <> TRUE
GROUP BY
	o.id
,	to_type1.attr_547_
,	o.attr_628_
,	preambula.attr_1845_
ORDER BY
	o.attr_613_