WITH proc AS (
	SELECT
		proc.*
	FROM
		registry.object_4000_ o,
		LATERAL (
		VALUES
			( 'ЛФК 1', o.attr_4007_, 1 ),
			( 'ЛФК 2', o.attr_4009_, 2 ),
			( 'Бассейн', o.attr_4011_, 3 ),
			( 'Гидромассаж', o.attr_4013_, 4 ),
			( 'Эрготерапия', o.attr_4015_, 5 ),
			( 'Занятие с логопедом', o.attr_4017_, 6 ),
			( 'Занятие с психологом', o.attr_4019_, 7 ),
			( 'ИРТ', o.attr_4021_, 8 ),
			( 'Массаж', o.attr_4023_, 9 ),
			( 'ФТ', o.attr_4025_, 10 ),
			( 'Грязетерапия', o.attr_4027_, 11 ),
			( 'Соляная пещера', o.attr_4029_, 12 ),
			( 'Гирудотерапия', o.attr_4251_, 13 ),
			( 'Ингаляция', o.attr_4443_, 14 ),
			( 'Прессотерапия', o.attr_4446_, 15 ) 
		) AS proc ( "name", "interval", "id" ) /*собираем таблицу интервалов из строки, LATERAL позволяет обратиться из подзапроса к таблице, вызванной вне его*/
	/*фильтр WHERE нужен для тестирования в СУБД*/
	WHERE o.ID = 6774 
	) 

SELECT
	string_agg ( DISTINCT proc3."intersect", E';\n' ) AS _output /*собираем уникальные значения пересечений*/
FROM
	(
	SELECT DISTINCT
	  proc."id" as proc1_id,
		proc2."id" as proc2_id,
		proc."name" AS proc1_name,
		proc2."name" AS proc2_name,
		concat (
		CASE
			WHEN proc."id" < proc2."id" THEN
			proc."name" ELSE proc2."name" 
			END,
			' || ',
		CASE
			WHEN proc."id" > proc2."id" THEN
			proc."name" ELSE proc2."name" 
			END 
			) AS "intersect" /*разворачиваем зеркальные пары, чтобы исключить их при агрегации*/
		FROM
			proc /*к таблице интервалов цепляем по условию пересечения интервалов строки из неё же, исключая одинаковые строки*/
			LEFT JOIN proc proc2 ON proc."name" != proc2."name" 
			AND proc."interval" && proc2."interval" 
			AND ( proc."interval" && ARRAY [ 1 ] OR proc2."interval" && ARRAY [ 1 ] ) <> TRUE 
		WHERE
			proc2."name" IS NOT NULL /*очищаем от строк, куда не прикрепилось ни одной записи*/
		) proc3 