DECLARE 
recalc_ids INT [];
BEGIN
		recalc_ids = (
		SELECT 
			ARRAY_AGG	( comp_pos_ord.id ) 
		FROM
			registry.object_1227_ pos_ord
			LEFT JOIN registry.object_1409_ comp_pos_ord ON comp_pos_ord.attr_1423_ = pos_ord.ID 
			AND comp_pos_ord.is_deleted IS FALSE 
		WHERE
			pos_ord.ID = ( PARAMETERS ->> 'id' ) :: INT );
	CALL registry."updateStoredFormulasByRows" ( 1409, recalc_ids );
END