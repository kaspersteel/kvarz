SELECT -->>
CASE
	WHEN
		ARRAY_TO_STRING( ARRAY_AGG ( docs.file_id ), ', ' ) <> '' THEN
			CONCAT (
				'[',
				ARRAY_TO_STRING(
					ARRAY_AGG (
						DISTINCT jsonb_build_object ( 'id', docs.file_id, 'name', concat (docs.create_date, ' ',docs.NAME), 'guid', docs.guid, 'extension', docs.extension ) 
					),
					', ' 
				),
				']' 
			) ELSE NULL 
		END 
FROM registry.object_45_ o -->>
LEFT JOIN (
	SELECT
		f.ID AS file_id,
		n.ID AS n_id,
		s.ID AS ID,
		f.NAME,
		f.create_date::date,
		f.guid,
		f.extension 
	FROM
		registry.object_45_ s
		LEFT JOIN registry.object_102_ n ON n.attr_104_ = s.ID 
		LEFT JOIN registry.files_102_ AS plan ON n.ID = plan.record_id 
		AND plan.field_id IN ( 244, 245, 249 )
		LEFT JOIN registry.files AS f ON plan.file_id = f.ID 
	WHERE
		f.ID IS NOT NULL 
		) AS docs ON docs.ID = o.ID
WHERE o.is_deleted IS FALSE -->>
GROUP BY -->>
o.id