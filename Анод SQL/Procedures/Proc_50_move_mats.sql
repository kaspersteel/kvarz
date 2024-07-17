DECLARE 
copy_ids INT[];
remnant RECORD;

BEGIN
/*поиск существующих остатков по материалу, складу-цели и аутсорсеру*/
FOR remnant IN (SELECT 
		move_mat.attr_3994_ AS move_mat_target_storage,
		move_mat.attr_3997_ AS move_mat_outsourcer,
		tab_move_mat.attr_4001_	AS tab_move_quant,
		source_remnants.id AS source_id, 
		target_remnants.id AS target_id 
FROM registry.object_3987_ move_mat
	LEFT JOIN registry.object_3988_ tab_move_mat ON tab_move_mat.attr_3990_ = move_mat.ID 
	AND tab_move_mat.attr_4000_ = move_mat.attr_3993_ AND tab_move_mat.is_deleted = false
	LEFT JOIN registry.object_1659_ source_remnants ON source_remnants.ID = tab_move_mat.attr_3999_ AND source_remnants.is_deleted = false
	LEFT JOIN registry.object_1659_ target_remnants ON target_remnants.attr_1663_ = tab_move_mat.attr_4005_
	AND COALESCE ( target_remnants.attr_1664_, 0 ) = COALESCE ( tab_move_mat.attr_4006_, 0 ) 
	AND COALESCE ( target_remnants.attr_1665_, 0 ) = COALESCE ( tab_move_mat.attr_4007_, 0 ) 
	AND target_remnants.attr_4004_ = move_mat.attr_3997_ 
	AND target_remnants.attr_2921_ = move_mat.attr_3994_ 
	AND target_remnants.is_deleted = false 
WHERE move_mat.id = (parameters->>'id')::int) LOOP
	/*если остаток найден - добавляем к нему перемещаемое*/
	IF remnant.target_id is not NULL THEN
		UPDATE registry.object_1659_
		SET 
			attr_1669_ = attr_1669_ + remnant.tab_move_quant,
			attr_2566_ = CURRENT_DATE
		WHERE id = remnant.target_id;
		CALL registry."updateStoredFormulasByRow"(1659, remnant.target_id);
		UPDATE registry.object_1659_
		SET 
		attr_1669_ = attr_1669_ - remnant.tab_move_quant,
		attr_2566_ = CURRENT_DATE
		WHERE id = remnant.source_id;
		CALL registry."updateStoredFormulasByRow"(1659, remnant.source_id);
	/*если записи остатка нет, создаем её и заполняем данными из накладной*/	
	ELSE
		copy_ids = registry."copyRecord"(1659, remnant.source_id , 1, NULL, NULL, (parameters->>'user_id')::int, true);
        UPDATE registry.object_1659_
		SET 
			attr_1669_ = remnant.tab_move_quant,
			attr_2921_ = remnant.move_mat_target_storage,
			attr_4004_ = remnant.move_mat_outsourcer,
			attr_3095_ = null, /*ссылка на позицию приходования*/
			attr_1676_ = 0, /*Длина остатка резерв/в производстве*/
			attr_3128_ = 0, /*Масса резерв/в производств*/
			attr_3110_ = 0, /*Резерв служ*/
			attr_3196_ = null, /*Резерв для*/
			attr_2566_ = CURRENT_DATE
		WHERE id = copy_ids[1];
		CALL registry."updateStoredFormulasByRow"(1659, copy_ids[1]);
        RAISE NOTICE 'Создана запись с id %', copy_ids[1];
		UPDATE registry.object_1659_
		SET 
			attr_1669_ = attr_1669_ - remnant.tab_move_quant,
			attr_2566_ = CURRENT_DATE
		WHERE id = remnant.source_id;
		CALL registry."updateStoredFormulasByRow"(1659, remnant.source_id);
	END IF;
END LOOP;
/*ставим статус "Выдано" накладной*/
UPDATE registry.object_3987_
		SET attr_4010_ = true
		WHERE id = (parameters->>'id')::int;
END