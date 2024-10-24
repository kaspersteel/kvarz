DECLARE copy_ids INT [];
do_user INT = ( PARAMETERS ->> 'user_id' ) :: INT;
quant INT = ( PARAMETERS ->> 'quant' ) :: INT;
instrument RECORD;
BEGIN
	SELECT
		remnants.ID AS "id",
		spr_instr.attr_456_ AS "type",
		spr_instr.attr_4153_ AS "cat" INTO instrument 
	FROM
		registry.object_2936_ remnants
		LEFT JOIN registry.object_454_ spr_instr ON spr_instr.ID = remnants.attr_2937_ 
		AND NOT spr_instr.is_deleted 
	WHERE
		remnants.ID = ( PARAMETERS ->> 'id' ) :: INT;
	CASE
		instrument.TYPE 
		WHEN 2 THEN
		UPDATE registry.object_2936_ 
		SET attr_4160_ = TRUE,
			attr_2942_ = CURRENT_DATE,
			operation_user_id = do_user 
		WHERE
			ID = instrument.ID;
		
		WHEN 1 THEN
		copy_ids = registry."copyRecord" ( 2936, instrument.ID, 1, NULL, NULL, do_user, TRUE );
		UPDATE registry.object_2936_ 
		SET attr_4145_ = quant,
			attr_4160_ = TRUE,
			attr_2942_ = CURRENT_DATE,
			operation_user_id = do_user 
		WHERE
			ID = copy_ids [ 1 ]:: INT;
		UPDATE registry.object_2936_ 
		SET attr_4145_ = attr_4145_ - quant,
			attr_2942_ = CURRENT_DATE,
			operation_user_id = do_user 
		WHERE
			ID = instrument.ID;
		
	END CASE;

END