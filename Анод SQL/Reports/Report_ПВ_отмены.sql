SELECT
	o.id
,	2137 "Реестр_ПВ"
,	t_op.attr_3208_ "Шаг"
,	sprav_to.attr_547_ "ТО"
,	coalesce(t_op.attr_2609_, t_op.attr_2152_) "Количество_посл_ТО"
,	comp_pos_ord.attr_1896_ "Количество_комп_в_поз"
,	400 "Реестр_материалов"
,	comp_task.attr_3902_ "Ссылка_на_заготовку"
,	sprav_mat.attr_401_ "Наименование_заготовки"
,	comp_pos_ord.attr_1423_ "позиция_заказа"
,	pos_task.attr_3231_ "Выдано"
,	o.attr_2675_ "Заказы_ПВ"
,	comp_pos_ord.id "Компонент_позиции"
,	comp_task.attr_2102_ "Заказ"
,	CASE
		WHEN comp_pos_ord.attr_1421_ = 9
			THEN concat('По заказу № ', ord.attr_607_, ' производство отменено')
	END "Инфо_для_ПВ"
,	o.attr_3207_ "Плановое_количество"
,	o.attr_2155_ "Номер_ПВ"
,	array_to_string(array_agg(DISTINCT sprav_nom.attr_362_), '; ') "Наименование_НЕ"
,	array_to_string(array_agg(DISTINCT sprav_nom.attr_1223_), '; ') "Обозначение_НЕ"
,	array_agg(DISTINCT sprav_nom.id) sprav_nom_ids
FROM
	registry.object_2137_ o
LEFT JOIN
	registry.object_301_ sprav_nom
		ON o.attr_2632_ = sprav_nom.id AND
		sprav_nom.is_deleted IS FALSE
		
LEFT JOIN
	registry.object_2138_ t_op
		ON t_op.attr_2148_ = o.id AND
		t_op.attr_3208_ = (
			SELECT
				max(a.attr_3208_)
			FROM
				registry.object_2138_ a
			WHERE
				a.is_deleted IS FALSE AND
				a.attr_2152_ IS NOT NULL AND
				a.attr_2148_ = o.id
		)
LEFT JOIN
	registry.object_545_ sprav_to
		ON t_op.attr_2149_ = sprav_to.id
/*выбор компонентов задания по ссылке на задание, ссылке на НЕ, ссылке на изделие*/		
LEFT JOIN
	registry.object_2094_ comp_task
		ON o.attr_2632_ = comp_task.attr_3203_
		AND	comp_task.attr_2101_::integer = ANY(o.attr_4033_)
/*выбор компонентов заказа по ссылке из компонента задания*/		
LEFT JOIN
	registry.object_1409_ comp_pos_ord
		ON comp_task.attr_2100_ = comp_pos_ord.id 

LEFT JOIN
	registry.object_400_ sprav_mat
		ON comp_task.attr_3902_ = sprav_mat.id
LEFT JOIN
	registry.object_3168_ pos_task
		ON o.attr_3193_ = pos_task.id
LEFT JOIN
	registry.object_1227_ pos_ord
		ON comp_pos_ord.attr_1423_ = pos_ord.id
LEFT JOIN
	registry.object_606_ ord
		ON pos_ord.attr_1923_ = ord.id		
WHERE
	o.is_deleted IS FALSE
GROUP BY
	o.id
,	t_op.attr_2609_
,	t_op.attr_2152_
,	t_op.attr_3208_
,	sprav_to.attr_547_
,	comp_pos_ord.attr_1896_
,	comp_task.attr_3902_
,	sprav_mat.attr_401_
,	comp_pos_ord.attr_1423_
,	pos_task.attr_3231_
,	comp_pos_ord.id
,	comp_task.attr_2102_
,	pos_ord.attr_1948_
,	ord.id