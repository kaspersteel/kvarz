DECLARE copy_ids INT [];
do_user INT = ( PARAMETERS ->> 'user_id' ) :: INT;
responsible INT = ( PARAMETERS ->> 'responsible' ) :: INT;
employee INT = ( PARAMETERS ->> 'employee' ) :: INT;
quant INT = ( PARAMETERS ->> 'quant' ) :: INT;
instrument RECORD;
BEGIN
	SELECT
		remnants.ID AS "id",
		source_remnants.ID AS "source_rem",
		spr_instr.attr_456_ AS "type",
		spr_instr.attr_4153_ AS "cat",
		remnants.attr_4145_ AS "crnt_quant"
		INTO instrument 
	FROM
		registry.object_2936_ remnants
		LEFT JOIN registry.object_454_ spr_instr ON spr_instr.ID = remnants.attr_2937_ 
		AND NOT spr_instr.is_deleted
		LEFT JOIN registry.object_2936_ source_remnants ON source_remnants.attr_4144_ = responsible 
		AND source_remnants.attr_2937_ = remnants.attr_2937_ 
		AND NOT source_remnants.is_deleted 
	WHERE
		remnants.ID = ( PARAMETERS ->> 'id' ) :: INT;
	CASE
			instrument.TYPE 
			WHEN 2 THEN
			UPDATE registry.object_2936_ 
			SET attr_4163_ = employee,
			attr_4144_ = responsible,
			attr_4158_ = FALSE,
			attr_2942_ = CURRENT_DATE,
			operation_user_id = do_user 
		WHERE
			ID = instrument.ID;
		
		WHEN 1 THEN
		UPDATE registry.object_2936_ 
		SET attr_4145_ = attr_4145_ - quant,
		attr_4158_ = (CASE WHEN instrument.crnt_quant = quant THEN FALSE ELSE TRUE END), 
        attr_2942_ = CURRENT_DATE,
		operation_user_id = do_user 
		WHERE
			ID = instrument.ID;
		UPDATE registry.object_2936_ 
		SET attr_4145_ = attr_4145_ + quant,
		attr_2942_ = CURRENT_DATE,
		operation_user_id = do_user 
		WHERE
			ID = instrument.source_rem;
		
	END CASE;

END