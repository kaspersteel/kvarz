WITH q AS (
	SELECT
		o.ID AS id_o,
		ARRAY_AGG ( n.ID ) AS arr_id_n 
	FROM
		registry.object_793_ o
        /*связанная таблица*/
		LEFT JOIN registry.object_1744_ n ON o.ID = n.attr_4587_ 
		AND NOT n.is_deleted 
		--WHERE o.id = o_this.id
		
	GROUP BY
		o.ID 
	) SELECT
	*
	,	UNNEST ( arr_id_n ) AS id_n 
FROM
	q 
WHERE
	ARRAY_LENGTH( arr_id_n, 1 ) > 1 
ORDER BY
	id_o,
	id_n