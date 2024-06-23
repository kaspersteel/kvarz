SELECT
	concat(
		extract('year' FROM current_date)::integer - 2000
	,	'-'
	,	lpad((substring(zap.attr_700_, '[1-9][0-9]*$')::integer + 1)::varchar, 5, '0')
	)
FROM
	registry.object_699_ zap
WHERE
	zap.is_deleted <> TRUE AND
	zap.attr_700_ IS NOT NULL AND
	extract('year' FROM zap.attr_713_::date) = extract('year' FROM current_date)
ORDER BY
	zap.id DESC
LIMIT 1;