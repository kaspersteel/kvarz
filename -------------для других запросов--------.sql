	-------------для других запросов---------------
      SELECT
	base.*,
	(
	SELECT
		string_agg ( i, '\n' ) AS "time_proc" 
	FROM
		(
		SELECT UNNEST
			(
				ARRAY (
				SELECT UNNEST
					( base.array_ranges [ 1 : 1 ][ 1 :] ) EXCEPT
				SELECT UNNEST
					( base.array_ranges [ 2 : 2 ][ 1 :] ) 
				) 
				) || '-' || UNNEST (
				ARRAY (
				SELECT UNNEST
					( base.array_ranges [ 2 : 2 ][ 1 :] ) EXCEPT
				SELECT UNNEST
					( base.array_ranges [ 1 : 1 ][ 1 :] ) 
				) 
			) AS "i" 
		) AS "y" 
	) 
FROM
	base 
WHERE
	base.array_time IS NOT NULL