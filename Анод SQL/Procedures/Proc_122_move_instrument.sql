DECLARE 
copy_ids INT [];
do_user INT = ( PARAMETERS ->> 'user_id' ) :: INT;
responsible INT = ( PARAMETERS ->> 'responsible' ) :: INT;
employee INT = ( PARAMETERS ->> 'employee' ) :: INT;
give_quant INT = ( PARAMETERS ->> 'give_quant' ) :: INT;
instrument RECORD;
BEGIN
	SELECT
		remnants.ID AS "id",
		prev_remnants.ID AS "prev_rem",
		spr_instr.attr_456_ AS "type",
		spr_instr.attr_4153_ AS "cat" INTO instrument 
	FROM
		registry.object_2936_ remnants
		LEFT JOIN registry.object_454_ spr_instr ON spr_instr.ID = remnants.attr_2937_ 
		AND NOT spr_instr.is_deleted
		LEFT JOIN registry.object_2936_ prev_remnants ON prev_remnants.attr_4144_ = employee 
		AND prev_remnants.attr_2937_ = remnants.attr_2937_ 
		AND NOT prev_remnants.is_deleted 
	WHERE
		remnants.ID = ( PARAMETERS ->> 'id' ) :: INT;
	CASE
			instrument.TYPE 
			WHEN 2 THEN
			UPDATE registry.object_2936_ 
			SET attr_4144_ = employee,
			attr_4163_ = responsible,
			attr_4158_ = TRUE,
			attr_2942_ = CURRENT_DATE,
			operation_user_id = do_user 
		WHERE
			ID = instrument.ID;
		
		WHEN 1 THEN
		CASE
			WHEN instrument.cat = 3 THEN
				copy_ids = registry."copyRecord" ( 2936, instrument.ID, 1, NULL, NULL, do_user, TRUE );
			UPDATE registry.object_2936_ 
			SET attr_4144_ = employee,
			attr_4163_ = responsible,
			attr_4145_ = give_quant,
			attr_4160_ = TRUE,
			attr_2942_ = CURRENT_DATE,
			operation_user_id = do_user 
			WHERE
				ID = copy_ids [ 1 ]:: INT;
			
			WHEN instrument.cat = 1 
			OR instrument.cat = 2 THEN
				IF
					instrument.prev_rem IS NOT NULL THEN
						UPDATE registry.object_2936_ 
						SET attr_4145_ = COALESCE (attr_4145_, 0) + give_quant,
						attr_4163_ = responsible,
						attr_4158_ = TRUE,
						attr_2942_ = CURRENT_DATE,
						operation_user_id = do_user 
					WHERE
						ID = instrument.prev_rem;
					ELSE copy_ids = registry."copyRecord" ( 2936, instrument.ID, 1, NULL, NULL, do_user, TRUE );
					UPDATE registry.object_2936_ 
					SET attr_4144_ = employee,
					attr_4163_ = responsible,
					attr_4145_ = give_quant,
					attr_4158_ = TRUE,
					attr_2942_ = CURRENT_DATE,
					operation_user_id = do_user 
					WHERE
						ID = copy_ids [ 1 ]:: INT;
					
				END IF;
				ELSE 
				END CASE;
			UPDATE registry.object_2936_ 
			SET attr_4145_ = attr_4145_ - give_quant,
			attr_2942_ = CURRENT_DATE,
			operation_user_id = do_user 
			WHERE
				ID = instrument.ID;
			
		END CASE;
	
END