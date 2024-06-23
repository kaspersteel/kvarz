/*Пересечение процедур*/ 
	concat_ws(
		'\n'
	,	CASE
			WHEN o.attr_4007_ && o.attr_4009_ AND
				(o.attr_4007_ && ARRAY[1] OR o.attr_4009_ && ARRAY[1]) <> TRUE
				THEN concat('ЛФК 1!!ЛФК 2', '\n')
		END
	,	CASE
			WHEN o.attr_4007_ && o.attr_4011_ AND
				(o.attr_4007_ && ARRAY[1] OR o.attr_4011_ && ARRAY[1]) <> TRUE
				THEN concat('ЛФК 1!!Бассейн', '\n')
		END
	,	CASE
			WHEN o.attr_4007_ && o.attr_4013_ AND
				(o.attr_4007_ && ARRAY[1] OR o.attr_4013_ && ARRAY[1]) <> TRUE
				THEN concat('ЛФК 1!!Гидромассаж', '\n')
		END
	,	CASE
			WHEN o.attr_4007_ && o.attr_4015_ AND
				(o.attr_4007_ && ARRAY[1] OR o.attr_4015_ && ARRAY[1]) <> TRUE
				THEN concat('ЛФК 1!!Эрготерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4007_ && o.attr_4017_ AND
				(o.attr_4007_ && ARRAY[1] OR o.attr_4017_ && ARRAY[1]) <> TRUE
				THEN concat('ЛФК 1!!Занятие с логопедом', '\n')
		END
	,	CASE
			WHEN o.attr_4007_ && o.attr_4019_ AND
				(o.attr_4007_ && ARRAY[1] OR o.attr_4019_ && ARRAY[1]) <> TRUE
				THEN concat('ЛФК 1!!Занятие с психологом', '\n')
		END
	,	CASE
			WHEN o.attr_4007_ && o.attr_4021_ AND
				(o.attr_4007_ && ARRAY[1] OR o.attr_4021_ && ARRAY[1]) <> TRUE
				THEN concat('ЛФК 1!!ИРТ', '\n')
		END
	,	CASE
			WHEN o.attr_4007_ && o.attr_4023_ AND
				(o.attr_4007_ && ARRAY[1] OR o.attr_4023_ && ARRAY[1]) <> TRUE
				THEN concat('ЛФК 1!!Массаж', '\n')
		END
	,	CASE
			WHEN o.attr_4007_ && o.attr_4025_ AND
				(o.attr_4007_ && ARRAY[1] OR o.attr_4025_ && ARRAY[1]) <> TRUE
				THEN concat('ЛФК 1!!ФТ', '\n')
		END
	,	CASE
			WHEN o.attr_4007_ && o.attr_4027_ AND
				(o.attr_4007_ && ARRAY[1] OR o.attr_4027_ && ARRAY[1]) <> TRUE
				THEN concat('ЛФК 1!!Грязетерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4007_ && o.attr_4029_ AND
				(o.attr_4007_ && ARRAY[1] OR o.attr_4029_ && ARRAY[1]) <> TRUE
				THEN concat('ЛФК 1!!Соляная пещера', '\n')
		END
	,	CASE
			WHEN o.attr_4007_ && o.attr_4162_ AND
				(o.attr_4007_ && ARRAY[1] OR o.attr_4162_ && ARRAY[1]) <> TRUE
				THEN concat('ЛФК 1!!Гирудотерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4007_ && o.attr_4251_ AND
				(o.attr_4007_ && ARRAY[1] OR o.attr_4251_ && ARRAY[1]) <> TRUE
				THEN concat('ЛФК 1!!Социокульт. меропр.', '\n')
		END
	,	CASE
			WHEN o.attr_4007_ && o.attr_4443_ AND
				(o.attr_4007_ && ARRAY[1] OR o.attr_4443_ && ARRAY[1]) <> TRUE
				THEN concat('ЛФК 1!!Ингаляция', '\n')
		END
	,	CASE
			WHEN o.attr_4007_ && o.attr_4446_ AND
				(o.attr_4007_ && ARRAY[1] OR o.attr_4446_ && ARRAY[1]) <> TRUE
				THEN concat('ЛФК 1!!Прессотерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4009_ && o.attr_4011_ AND
				(o.attr_4009_ && ARRAY[1] OR o.attr_4011_ && ARRAY[1]) <> TRUE
				THEN concat('ЛФК 2!!Бассейн', '\n')
		END
	,	CASE
			WHEN o.attr_4009_ && o.attr_4013_ AND
				(o.attr_4009_ && ARRAY[1] OR o.attr_4013_ && ARRAY[1]) <> TRUE
				THEN concat('ЛФК 2!!Гидромассаж', '\n')
		END
	,	CASE
			WHEN o.attr_4009_ && o.attr_4015_ AND
				(o.attr_4009_ && ARRAY[1] OR o.attr_4015_ && ARRAY[1]) <> TRUE
				THEN concat('ЛФК 2!!Эрготерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4009_ && o.attr_4017_ AND
				(o.attr_4009_ && ARRAY[1] OR o.attr_4017_ && ARRAY[1]) <> TRUE
				THEN concat('ЛФК 2!!Занятие с логопедом', '\n')
		END
	,	CASE
			WHEN o.attr_4009_ && o.attr_4019_ AND
				(o.attr_4009_ && ARRAY[1] OR o.attr_4019_ && ARRAY[1]) <> TRUE
				THEN concat('ЛФК 2!!Занятие с психологом', '\n')
		END
	,	CASE
			WHEN o.attr_4009_ && o.attr_4021_ AND
				(o.attr_4009_ && ARRAY[1] OR o.attr_4021_ && ARRAY[1]) <> TRUE
				THEN concat('ЛФК 2!!ИРТ', '\n')
		END
	,	CASE
			WHEN o.attr_4009_ && o.attr_4023_ AND
				(o.attr_4009_ && ARRAY[1] OR o.attr_4023_ && ARRAY[1]) <> TRUE
				THEN concat('ЛФК 2!!Массаж', '\n')
		END
	,	CASE
			WHEN o.attr_4009_ && o.attr_4025_ AND
				(o.attr_4009_ && ARRAY[1] OR o.attr_4025_ && ARRAY[1]) <> TRUE
				THEN concat('ЛФК 2!!ФТ', '\n')
		END
	,	CASE
			WHEN o.attr_4009_ && o.attr_4027_ AND
				(o.attr_4009_ && ARRAY[1] OR o.attr_4027_ && ARRAY[1]) <> TRUE
				THEN concat('ЛФК 2!!Грязетерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4009_ && o.attr_4029_ AND
				(o.attr_4009_ && ARRAY[1] OR o.attr_4029_ && ARRAY[1]) <> TRUE
				THEN concat('ЛФК 2!!Соляная пещера', '\n')
		END
	,	CASE
			WHEN o.attr_4009_ && o.attr_4162_ AND
				(o.attr_4009_ && ARRAY[1] OR o.attr_4162_ && ARRAY[1]) <> TRUE
				THEN concat('ЛФК 2!!Гирудотерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4009_ && o.attr_4251_ AND
				(o.attr_4009_ && ARRAY[1] OR o.attr_4251_ && ARRAY[1]) <> TRUE
				THEN concat('ЛФК 2!!Социокульт. меропр.', '\n')
		END
	,	CASE
			WHEN o.attr_4009_ && o.attr_4443_ AND
				(o.attr_4009_ && ARRAY[1] OR o.attr_4443_ && ARRAY[1]) <> TRUE
				THEN concat('ЛФК 2!!Ингаляция', '\n')
		END
	,	CASE
			WHEN o.attr_4009_ && o.attr_4446_ AND
				(o.attr_4009_ && ARRAY[1] OR o.attr_4446_ && ARRAY[1]) <> TRUE
				THEN concat('ЛФК 2!!Прессотерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4011_ && o.attr_4013_ AND
				(o.attr_4011_ && ARRAY[1] OR o.attr_4013_ && ARRAY[1]) <> TRUE
				THEN concat('Бассейн!!Гидромассаж', '\n')
		END
	,	CASE
			WHEN o.attr_4011_ && o.attr_4015_ AND
				(o.attr_4011_ && ARRAY[1] OR o.attr_4015_ && ARRAY[1]) <> TRUE
				THEN concat('Бассейн!!Эрготерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4011_ && o.attr_4017_ AND
				(o.attr_4011_ && ARRAY[1] OR o.attr_4017_ && ARRAY[1]) <> TRUE
				THEN concat('Бассейн!!Занятие с логопедом', '\n')
		END
	,	CASE
			WHEN o.attr_4011_ && o.attr_4019_ AND
				(o.attr_4011_ && ARRAY[1] OR o.attr_4019_ && ARRAY[1]) <> TRUE
				THEN concat('Бассейн!!Занятие с психологом', '\n')
		END
	,	CASE
			WHEN o.attr_4011_ && o.attr_4021_ AND
				(o.attr_4011_ && ARRAY[1] OR o.attr_4021_ && ARRAY[1]) <> TRUE
				THEN concat('Бассейн!!ИРТ', '\n')
		END
	,	CASE
			WHEN o.attr_4011_ && o.attr_4023_ AND
				(o.attr_4011_ && ARRAY[1] OR o.attr_4023_ && ARRAY[1]) <> TRUE
				THEN concat('Бассейн!!Массаж', '\n')
		END
	,	CASE
			WHEN o.attr_4011_ && o.attr_4025_ AND
				(o.attr_4011_ && ARRAY[1] OR o.attr_4025_ && ARRAY[1]) <> TRUE
				THEN concat('Бассейн!!ФТ', '\n')
		END
	,	CASE
			WHEN o.attr_4011_ && o.attr_4027_ AND
				(o.attr_4011_ && ARRAY[1] OR o.attr_4027_ && ARRAY[1]) <> TRUE
				THEN concat('Бассейн!!Грязетерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4011_ && o.attr_4029_ AND
				(o.attr_4011_ && ARRAY[1] OR o.attr_4029_ && ARRAY[1]) <> TRUE
				THEN concat('Бассейн!!Соляная пещера', '\n')
		END
	,	CASE
			WHEN o.attr_4011_ && o.attr_4162_ AND
				(o.attr_4011_ && ARRAY[1] OR o.attr_4162_ && ARRAY[1]) <> TRUE
				THEN concat('Бассейн!!Гирудотерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4011_ && o.attr_4251_ AND
				(o.attr_4011_ && ARRAY[1] OR o.attr_4251_ && ARRAY[1]) <> TRUE
				THEN concat('Бассейн!!Социокульт. меропр.', '\n')
		END
	,	CASE
			WHEN o.attr_4011_ && o.attr_4443_ AND
				(o.attr_4011_ && ARRAY[1] OR o.attr_4443_ && ARRAY[1]) <> TRUE
				THEN concat('Бассейн!!Ингаляция', '\n')
		END
	,	CASE
			WHEN o.attr_4011_ && o.attr_4446_ AND
				(o.attr_4011_ && ARRAY[1] OR o.attr_4446_ && ARRAY[1]) <> TRUE
				THEN concat('Бассейн!!Прессотерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4013_ && o.attr_4015_ AND
				(o.attr_4013_ && ARRAY[1] OR o.attr_4015_ && ARRAY[1]) <> TRUE
				THEN concat('Гидромассаж!!Эрготерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4013_ && o.attr_4017_ AND
				(o.attr_4013_ && ARRAY[1] OR o.attr_4017_ && ARRAY[1]) <> TRUE
				THEN concat('Гидромассаж!!Занятие с логопедом', '\n')
		END
	,	CASE
			WHEN o.attr_4013_ && o.attr_4019_ AND
				(o.attr_4013_ && ARRAY[1] OR o.attr_4019_ && ARRAY[1]) <> TRUE
				THEN concat('Гидромассаж!!Занятие с психологом', '\n')
		END
	,	CASE
			WHEN o.attr_4013_ && o.attr_4021_ AND
				(o.attr_4013_ && ARRAY[1] OR o.attr_4021_ && ARRAY[1]) <> TRUE
				THEN concat('Гидромассаж!!ИРТ', '\n')
		END
	,	CASE
			WHEN o.attr_4013_ && o.attr_4023_ AND
				(o.attr_4013_ && ARRAY[1] OR o.attr_4023_ && ARRAY[1]) <> TRUE
				THEN concat('Гидромассаж!!Массаж', '\n')
		END
	,	CASE
			WHEN o.attr_4013_ && o.attr_4025_ AND
				(o.attr_4013_ && ARRAY[1] OR o.attr_4025_ && ARRAY[1]) <> TRUE
				THEN concat('Гидромассаж!!ФТ', '\n')
		END
	,	CASE
			WHEN o.attr_4013_ && o.attr_4027_ AND
				(o.attr_4013_ && ARRAY[1] OR o.attr_4027_ && ARRAY[1]) <> TRUE
				THEN concat('Гидромассаж!!Грязетерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4013_ && o.attr_4029_ AND
				(o.attr_4013_ && ARRAY[1] OR o.attr_4029_ && ARRAY[1]) <> TRUE
				THEN concat('Гидромассаж!!Соляная пещера', '\n')
		END
	,	CASE
			WHEN o.attr_4013_ && o.attr_4162_ AND
				(o.attr_4013_ && ARRAY[1] OR o.attr_4162_ && ARRAY[1]) <> TRUE
				THEN concat('Гидромассаж!!Гирудотерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4013_ && o.attr_4251_ AND
				(o.attr_4013_ && ARRAY[1] OR o.attr_4251_ && ARRAY[1]) <> TRUE
				THEN concat('Гидромассаж!!Социокульт. меропр.', '\n')
		END
	,	CASE
			WHEN o.attr_4013_ && o.attr_4443_ AND
				(o.attr_4013_ && ARRAY[1] OR o.attr_4443_ && ARRAY[1]) <> TRUE
				THEN concat('Гидромассаж!!Ингаляция', '\n')
		END
	,	CASE
			WHEN o.attr_4013_ && o.attr_4446_ AND
				(o.attr_4013_ && ARRAY[1] OR o.attr_4446_ && ARRAY[1]) <> TRUE
				THEN concat('Гидромассаж!!Прессотерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4015_ && o.attr_4017_ AND
				(o.attr_4015_ && ARRAY[1] OR o.attr_4017_ && ARRAY[1]) <> TRUE
				THEN concat('Эрготерапия!!Занятие с логопедом', '\n')
		END
	,	CASE
			WHEN o.attr_4015_ && o.attr_4019_ AND
				(o.attr_4015_ && ARRAY[1] OR o.attr_4019_ && ARRAY[1]) <> TRUE
				THEN concat('Эрготерапия!!Занятие с психологом', '\n')
		END
	,	CASE
			WHEN o.attr_4015_ && o.attr_4021_ AND
				(o.attr_4015_ && ARRAY[1] OR o.attr_4021_ && ARRAY[1]) <> TRUE
				THEN concat('Эрготерапия!!ИРТ', '\n')
		END
	,	CASE
			WHEN o.attr_4015_ && o.attr_4023_ AND
				(o.attr_4015_ && ARRAY[1] OR o.attr_4023_ && ARRAY[1]) <> TRUE
				THEN concat('Эрготерапия!!Массаж', '\n')
		END
	,	CASE
			WHEN o.attr_4015_ && o.attr_4025_ AND
				(o.attr_4015_ && ARRAY[1] OR o.attr_4025_ && ARRAY[1]) <> TRUE
				THEN concat('Эрготерапия!!ФТ', '\n')
		END
	,	CASE
			WHEN o.attr_4015_ && o.attr_4027_ AND
				(o.attr_4015_ && ARRAY[1] OR o.attr_4027_ && ARRAY[1]) <> TRUE
				THEN concat('Эрготерапия!!Грязетерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4015_ && o.attr_4029_ AND
				(o.attr_4015_ && ARRAY[1] OR o.attr_4029_ && ARRAY[1]) <> TRUE
				THEN concat('Эрготерапия!!Соляная пещера', '\n')
		END
	,	CASE
			WHEN o.attr_4015_ && o.attr_4162_ AND
				(o.attr_4015_ && ARRAY[1] OR o.attr_4162_ && ARRAY[1]) <> TRUE
				THEN concat('Эрготерапия!!Гирудотерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4015_ && o.attr_4251_ AND
				(o.attr_4015_ && ARRAY[1] OR o.attr_4251_ && ARRAY[1]) <> TRUE
				THEN concat('Эрготерапия!!Социокульт. меропр.', '\n')
		END
	,	CASE
			WHEN o.attr_4015_ && o.attr_4443_ AND
				(o.attr_4015_ && ARRAY[1] OR o.attr_4443_ && ARRAY[1]) <> TRUE
				THEN concat('Эрготерапия!!Ингаляция', '\n')
		END
	,	CASE
			WHEN o.attr_4015_ && o.attr_4446_ AND
				(o.attr_4015_ && ARRAY[1] OR o.attr_4446_ && ARRAY[1]) <> TRUE
				THEN concat('Эрготерапия!!Прессотерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4017_ && o.attr_4019_ AND
				(o.attr_4017_ && ARRAY[1] OR o.attr_4019_ && ARRAY[1]) <> TRUE
				THEN concat('Занятие с логопедом!!Занятие с психологом', '\n')
		END
	,	CASE
			WHEN o.attr_4017_ && o.attr_4021_ AND
				(o.attr_4017_ && ARRAY[1] OR o.attr_4021_ && ARRAY[1]) <> TRUE
				THEN concat('Занятие с логопедом!!ИРТ', '\n')
		END
	,	CASE
			WHEN o.attr_4017_ && o.attr_4023_ AND
				(o.attr_4017_ && ARRAY[1] OR o.attr_4023_ && ARRAY[1]) <> TRUE
				THEN concat('Занятие с логопедом!!Массаж', '\n')
		END
	,	CASE
			WHEN o.attr_4017_ && o.attr_4025_ AND
				(o.attr_4017_ && ARRAY[1] OR o.attr_4025_ && ARRAY[1]) <> TRUE
				THEN concat('Занятие с логопедом!!ФТ', '\n')
		END
	,	CASE
			WHEN o.attr_4017_ && o.attr_4027_ AND
				(o.attr_4017_ && ARRAY[1] OR o.attr_4027_ && ARRAY[1]) <> TRUE
				THEN concat('Занятие с логопедом!!Грязетерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4017_ && o.attr_4029_ AND
				(o.attr_4017_ && ARRAY[1] OR o.attr_4029_ && ARRAY[1]) <> TRUE
				THEN concat('Занятие с логопедом!!Соляная пещера', '\n')
		END
	,	CASE
			WHEN o.attr_4017_ && o.attr_4162_ AND
				(o.attr_4017_ && ARRAY[1] OR o.attr_4162_ && ARRAY[1]) <> TRUE
				THEN concat('Занятие с логопедом!!Гирудотерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4017_ && o.attr_4251_ AND
				(o.attr_4017_ && ARRAY[1] OR o.attr_4251_ && ARRAY[1]) <> TRUE
				THEN concat('Занятие с логопедом!!Социокульт. меропр.', '\n')
		END
	,	CASE
			WHEN o.attr_4017_ && o.attr_4443_ AND
				(o.attr_4017_ && ARRAY[1] OR o.attr_4443_ && ARRAY[1]) <> TRUE
				THEN concat('Занятие с логопедом!!Ингаляция', '\n')
		END
	,	CASE
			WHEN o.attr_4017_ && o.attr_4446_ AND
				(o.attr_4017_ && ARRAY[1] OR o.attr_4446_ && ARRAY[1]) <> TRUE
				THEN concat('Занятие с логопедом!!Прессотерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4019_ && o.attr_4021_ AND
				(o.attr_4019_ && ARRAY[1] OR o.attr_4021_ && ARRAY[1]) <> TRUE
				THEN concat('Занятие с психологом!!ИРТ', '\n')
		END
	,	CASE
			WHEN o.attr_4019_ && o.attr_4023_ AND
				(o.attr_4019_ && ARRAY[1] OR o.attr_4023_ && ARRAY[1]) <> TRUE
				THEN concat('Занятие с психологом!!Массаж', '\n')
		END
	,	CASE
			WHEN o.attr_4019_ && o.attr_4025_ AND
				(o.attr_4019_ && ARRAY[1] OR o.attr_4025_ && ARRAY[1]) <> TRUE
				THEN concat('Занятие с психологом!!ФТ', '\n')
		END
	,	CASE
			WHEN o.attr_4019_ && o.attr_4027_ AND
				(o.attr_4019_ && ARRAY[1] OR o.attr_4027_ && ARRAY[1]) <> TRUE
				THEN concat('Занятие с психологом!!Грязетерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4019_ && o.attr_4029_ AND
				(o.attr_4019_ && ARRAY[1] OR o.attr_4029_ && ARRAY[1]) <> TRUE
				THEN concat('Занятие с психологом!!Соляная пещера', '\n')
		END
	,	CASE
			WHEN o.attr_4019_ && o.attr_4162_ AND
				(o.attr_4019_ && ARRAY[1] OR o.attr_4162_ && ARRAY[1]) <> TRUE
				THEN concat('Занятие с психологом!!Гирудотерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4019_ && o.attr_4251_ AND
				(o.attr_4019_ && ARRAY[1] OR o.attr_4251_ && ARRAY[1]) <> TRUE
				THEN concat('Занятие с психологом!!Социокульт. меропр.', '\n')
		END
	,	CASE
			WHEN o.attr_4019_ && o.attr_4443_ AND
				(o.attr_4019_ && ARRAY[1] OR o.attr_4443_ && ARRAY[1]) <> TRUE
				THEN concat('Занятие с психологом!!Ингаляция', '\n')
		END
	,	CASE
			WHEN o.attr_4019_ && o.attr_4446_ AND
				(o.attr_4019_ && ARRAY[1] OR o.attr_4446_ && ARRAY[1]) <> TRUE
				THEN concat('Занятие с психологом!!Прессотерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4021_ && o.attr_4023_ AND
				(o.attr_4021_ && ARRAY[1] OR o.attr_4023_ && ARRAY[1]) <> TRUE
				THEN concat('ИРТ!!Массаж', '\n')
		END
	,	CASE
			WHEN o.attr_4021_ && o.attr_4025_ AND
				(o.attr_4021_ && ARRAY[1] OR o.attr_4025_ && ARRAY[1]) <> TRUE
				THEN concat('ИРТ!!ФТ', '\n')
		END
	,	CASE
			WHEN o.attr_4021_ && o.attr_4027_ AND
				(o.attr_4021_ && ARRAY[1] OR o.attr_4027_ && ARRAY[1]) <> TRUE
				THEN concat('ИРТ!!Грязетерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4021_ && o.attr_4029_ AND
				(o.attr_4021_ && ARRAY[1] OR o.attr_4029_ && ARRAY[1]) <> TRUE
				THEN concat('ИРТ!!Соляная пещера', '\n')
		END
	,	CASE
			WHEN o.attr_4021_ && o.attr_4162_ AND
				(o.attr_4021_ && ARRAY[1] OR o.attr_4162_ && ARRAY[1]) <> TRUE
				THEN concat('ИРТ!!Гирудотерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4021_ && o.attr_4251_ AND
				(o.attr_4021_ && ARRAY[1] OR o.attr_4251_ && ARRAY[1]) <> TRUE
				THEN concat('ИРТ!!Социокульт. меропр.', '\n')
		END
	,	CASE
			WHEN o.attr_4021_ && o.attr_4443_ AND
				(o.attr_4021_ && ARRAY[1] OR o.attr_4443_ && ARRAY[1]) <> TRUE
				THEN concat('ИРТ!!Ингаляция', '\n')
		END
	,	CASE
			WHEN o.attr_4021_ && o.attr_4446_ AND
				(o.attr_4021_ && ARRAY[1] OR o.attr_4446_ && ARRAY[1]) <> TRUE
				THEN concat('ИРТ!!Прессотерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4023_ && o.attr_4025_ AND
				(o.attr_4023_ && ARRAY[1] OR o.attr_4025_ && ARRAY[1]) <> TRUE
				THEN concat('Массаж!!ФТ', '\n')
		END
	,	CASE
			WHEN o.attr_4023_ && o.attr_4027_ AND
				(o.attr_4023_ && ARRAY[1] OR o.attr_4027_ && ARRAY[1]) <> TRUE
				THEN concat('Массаж!!Грязетерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4023_ && o.attr_4029_ AND
				(o.attr_4023_ && ARRAY[1] OR o.attr_4029_ && ARRAY[1]) <> TRUE
				THEN concat('Массаж!!Соляная пещера', '\n')
		END
	,	CASE
			WHEN o.attr_4023_ && o.attr_4162_ AND
				(o.attr_4023_ && ARRAY[1] OR o.attr_4162_ && ARRAY[1]) <> TRUE
				THEN concat('Массаж!!Гирудотерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4023_ && o.attr_4251_ AND
				(o.attr_4023_ && ARRAY[1] OR o.attr_4251_ && ARRAY[1]) <> TRUE
				THEN concat('Массаж!!Социокульт. меропр.', '\n')
		END
	,	CASE
			WHEN o.attr_4023_ && o.attr_4443_ AND
				(o.attr_4023_ && ARRAY[1] OR o.attr_4443_ && ARRAY[1]) <> TRUE
				THEN concat('Массаж!!Ингаляция', '\n')
		END
	,	CASE
			WHEN o.attr_4023_ && o.attr_4446_ AND
				(o.attr_4023_ && ARRAY[1] OR o.attr_4446_ && ARRAY[1]) <> TRUE
				THEN concat('Массаж!!Прессотерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4025_ && o.attr_4027_ AND
				(o.attr_4025_ && ARRAY[1] OR o.attr_4027_ && ARRAY[1]) <> TRUE
				THEN concat('ФТ!!Грязетерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4025_ && o.attr_4029_ AND
				(o.attr_4025_ && ARRAY[1] OR o.attr_4029_ && ARRAY[1]) <> TRUE
				THEN concat('ФТ!!Соляная пещера', '\n')
		END
	,	CASE
			WHEN o.attr_4025_ && o.attr_4162_ AND
				(o.attr_4025_ && ARRAY[1] OR o.attr_4162_ && ARRAY[1]) <> TRUE
				THEN concat('ФТ!!Гирудотерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4025_ && o.attr_4251_ AND
				(o.attr_4025_ && ARRAY[1] OR o.attr_4251_ && ARRAY[1]) <> TRUE
				THEN concat('ФТ!!Социокульт. меропр.', '\n')
		END
	,	CASE
			WHEN o.attr_4025_ && o.attr_4443_ AND
				(o.attr_4025_ && ARRAY[1] OR o.attr_4443_ && ARRAY[1]) <> TRUE
				THEN concat('ФТ!!Ингаляция', '\n')
		END
	,	CASE
			WHEN o.attr_4025_ && o.attr_4446_ AND
				(o.attr_4025_ && ARRAY[1] OR o.attr_4446_ && ARRAY[1]) <> TRUE
				THEN concat('ФТ!!Прессотерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4027_ && o.attr_4029_ AND
				(o.attr_4027_ && ARRAY[1] OR o.attr_4029_ && ARRAY[1]) <> TRUE
				THEN concat('Грязетерапия!!Соляная пещера', '\n')
		END
	,	CASE
			WHEN o.attr_4027_ && o.attr_4162_ AND
				(o.attr_4027_ && ARRAY[1] OR o.attr_4162_ && ARRAY[1]) <> TRUE
				THEN concat('Грязетерапия!!Гирудотерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4027_ && o.attr_4251_ AND
				(o.attr_4027_ && ARRAY[1] OR o.attr_4251_ && ARRAY[1]) <> TRUE
				THEN concat('Грязетерапия!!Социокульт. меропр.', '\n')
		END
	,	CASE
			WHEN o.attr_4007_ && o.attr_4443_ AND
				(o.attr_4007_ && ARRAY[1] OR o.attr_4443_ && ARRAY[1]) <> TRUE
				THEN concat('Грязетерапия!!Ингаляция', '\n')
		END
	,	CASE
			WHEN o.attr_4007_ && o.attr_4446_ AND
				(o.attr_4007_ && ARRAY[1] OR o.attr_4446_ && ARRAY[1]) <> TRUE
				THEN concat('Грязетерапия!!Прессотерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4029_ && o.attr_4162_ AND
				(o.attr_4029_ && ARRAY[1] OR o.attr_4162_ && ARRAY[1]) <> TRUE
				THEN concat('Соляная пещера!!Гирудотерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4029_ && o.attr_4251_ AND
				(o.attr_4029_ && ARRAY[1] OR o.attr_4251_ && ARRAY[1]) <> TRUE
				THEN concat('Соляная пещера!!Социокульт. меропр.', '\n')
		END
	,	CASE
			WHEN o.attr_4029_ && o.attr_4443_ AND
				(o.attr_4029_ && ARRAY[1] OR o.attr_4443_ && ARRAY[1]) <> TRUE
				THEN concat('Соляная пещера!!Ингаляция', '\n')
		END
	,	CASE
			WHEN o.attr_4029_ && o.attr_4446_ AND
				(o.attr_4029_ && ARRAY[1] OR o.attr_4446_ && ARRAY[1]) <> TRUE
				THEN concat('Соляная пещера!!Прессотерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4162_ && o.attr_4251_ AND
				(o.attr_4162_ && ARRAY[1] OR o.attr_4251_ && ARRAY[1]) <> TRUE
				THEN concat('Гирудотерапия!!Социокульт. меропр.', '\n')
		END
	,	CASE
			WHEN o.attr_4162_ && o.attr_4443_ AND
				(o.attr_4162_ && ARRAY[1] OR o.attr_4443_ && ARRAY[1]) <> TRUE
				THEN concat('Гирудотерапия!!Ингаляция', '\n')
		END
	,	CASE
			WHEN o.attr_4162_ && o.attr_4446_ AND
				(o.attr_4162_ && ARRAY[1] OR o.attr_4446_ && ARRAY[1]) <> TRUE
				THEN concat('Гирудотерапия!!Прессотерапия', '\n')
		END
	,	CASE
			WHEN o.attr_4251_ && o.attr_4443_ AND
				(o.attr_4251_ && ARRAY[1] OR o.attr_4443_ && ARRAY[1]) <> TRUE
				THEN concat('Социокульт. меропр.!!Ингаляция', '\n')
		END
	,	CASE
			WHEN o.attr_4251_ && o.attr_4446_ AND
				(o.attr_4251_ && ARRAY[1] OR o.attr_4446_ && ARRAY[1]) <> TRUE
				THEN concat('Социокульт. меропр.!!Прессотерапия', '\n')
		END
	)