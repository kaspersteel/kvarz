SELECT
	concat (
		EXTRACT ( 'year' FROM CURRENT_DATE ) :: INTEGER - 2000,
		'-',
		lpad(
		CASE
				
				WHEN (
				SELECT COUNT
					( zap.ID ) 
				FROM
					registry.object_699_ zap 
				WHERE
					zap.is_deleted <> TRUE 
					AND zap.attr_700_ IS NOT NULL 
					AND EXTRACT ( 'year' FROM zap.attr_713_ :: DATE ) = EXTRACT ( 'year' FROM CURRENT_DATE ) 
					) = 0 THEN
					'1' ELSE ( SELECT (SUBSTRING ( zap.attr_700_, '[1-9][0-9]*$' ) :: INTEGER + 1 ) 
				FROM
					registry.object_699_ zap 
				WHERE
					zap.is_deleted <> TRUE 
					AND zap.attr_700_ IS NOT NULL 
					AND EXTRACT ( 'year' FROM zap.attr_713_ :: DATE ) = EXTRACT ( 'year' FROM CURRENT_DATE ) 
				ORDER BY
					zap.ID DESC 
					LIMIT 1 
				) :: VARCHAR 
			END,
			5,
			'0' 
		) 
	)