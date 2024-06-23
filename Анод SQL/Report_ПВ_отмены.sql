SELECT
	o.id
,	2137 "Реестр_ПВ"
,	t_op.attr_3208_ "Шаг"
,	sprav_to.attr_547_ "ТО"
,	coalesce(t_op.attr_2609_, t_op.attr_2152_) "Количество_посл_ТО"
,	ord_pos_comp.attr_1896_ "Количество_комп_в_поз"
,	400 "Реестр_материалов"
,	task_comp.attr_3902_ "Ссылка_на_заготовку"
,	sprav_mat.attr_401_ "Наименование_заготовки"
,	ord_pos_comp.attr_1423_ "позиция_заказа"
,	task_pos.attr_3231_ "Выдано"
,	o.attr_2675_ "Заказы_ПВ"
,	ord_pos_comp.id "Компонент_позиции"
,	task_comp.attr_2102_ "Заказ"
,	CASE
		WHEN ord_pos_comp.attr_1421_ = 9
			THEN concat('По заказу № ', task_comp.attr_2102_, ' производство отменено')
	END "Инфо_для_ПВ"
,	o.attr_3207_ "Плановое_количество"
,	o.attr_2155_ "Номер_ПВ"
,	array_to_string(array_agg(DISTINCT jn_108.attr_362_), '; ') "Наименование_НЕ"
,	array_to_string(array_agg(DISTINCT jn_108.attr_1223_), '; ') "Обозначение_НЕ"
,	array_agg(DISTINCT jn_108.id) xref_2632
FROM
	registry.object_2137_ o
LEFT JOIN
	registry.object_301_ jn_108
		ON o.attr_2632_ = jn_108.id AND
		jn_108.is_deleted = FALSE
LEFT JOIN
	registry.object_2138_ t_op
		ON t_op.attr_2148_ = o.id AND
		t_op.attr_3208_ = (
			SELECT
				max(a.attr_3208_)
			FROM
				registry.object_2138_ a
			WHERE
				a.is_deleted = FALSE AND
				a.attr_2152_ IS NOT NULL AND
				a.attr_2148_ = o.id
		)
LEFT JOIN
	registry.object_545_ sprav_to
		ON t_op.attr_2149_ = sprav_to.id
LEFT JOIN
	registry.object_2094_ task_comp
		ON o.attr_2226_ = task_comp.attr_2173_
LEFT JOIN
	registry.object_1409_ ord_pos_comp
		ON task_comp.attr_2100_ = ord_pos_comp.id AND
		ord_pos_comp.attr_1458_ = o.attr_2632_ AND
		ord_pos_comp.attr_1650_::integer = ANY(o.attr_2675_)
LEFT JOIN
	registry.object_400_ sprav_mat
		ON task_comp.attr_3902_ = sprav_mat.id
LEFT JOIN
	registry.object_3168_ task_pos
		ON o.attr_3193_ = task_pos.id
LEFT JOIN
	registry.object_1227_ ord_pos
		ON ord_pos_comp.attr_1423_ = ord_pos.id
WHERE
	o.is_deleted = FALSE
GROUP BY
	o.id
,	t_op.attr_2609_
,	t_op.attr_2152_
,	t_op.attr_3208_
,	sprav_to.attr_547_
,	ord_pos_comp.attr_1896_
,	task_comp.attr_3902_
,	sprav_mat.attr_401_
,	ord_pos_comp.attr_1423_
,	task_pos.attr_3231_
,	ord_pos_comp.id
,	task_comp.attr_2102_
,	ord_pos.attr_1948_