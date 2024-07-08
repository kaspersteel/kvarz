/*Заказы в производство attr_2675_*/
SELECT
CASE
		WHEN task_work_comp.ID IS NOT NULL THEN
		ARRAY [ task_work_comp.attr_2102_ ] ELSE massive_ord.mas_ord
END 
	FROM
		registry.object_2137_ o
		LEFT JOIN (
		SELECT
			comp.attr_3203_ AS nom_ed,
			comp.attr_3204_ AS tech_card,
			comp.attr_2173_ AS task_work,
			comp.attr_3175_ AS task_work_pos,
			comp.attr_2203_ AS ed_hran,
			comp.attr_2104_ AS mat,
			comp.attr_2105_ AS sort,
			comp.attr_2106_ AS tr,
			SUM ( comp.attr_2103_ ),
			ARRAY_AGG ( DISTINCT ( ord_to_man.ID ) ) AS mas_ord,
			ARRAY_AGG ( DISTINCT ( comp_ord.attr_1482_ ) ) AS mas_izd 
		FROM
			registry.object_2094_ comp /*компоненты заданий в работу*/
			LEFT JOIN registry.object_606_ ord_to_man ON comp.attr_2102_ = ord_to_man.ID /*Заказ в производство*/
			LEFT JOIN registry.object_1409_ comp_ord ON comp.attr_2101_ = comp_ord.ID /*Изделия*/
		WHERE
			comp.is_deleted <> TRUE 
		GROUP BY
			comp.attr_3203_,
			comp.attr_3204_,
			comp.attr_2173_,
			comp.attr_2203_,
			comp.attr_2104_,
			comp.attr_2105_,
			comp.attr_2106_,
			comp.attr_3175_ 
		ORDER BY
			comp.attr_3203_,
			comp.attr_3204_,
			comp.attr_2203_ 
		) massive_ord ON massive_ord.task_work_pos = o.attr_3193_ 
		AND massive_ord.nom_ed = o.attr_2632_
		LEFT JOIN registry.object_2094_ task_work_comp ON (task_work_comp.ID = ANY(o.attr_3904_) OR o.attr_3414_ = task_work_comp.id)

	WHERE
		o.is_deleted IS NOT TRUE 
	GROUP BY
		massive_ord.mas_ord,
		task_work_comp.ID,
		massive_ord.mas_izd

/*запрос для Навикат*/
SELECT
*,
CASE
		
		WHEN task_work_comp.ID IS NOT NULL THEN
		ARRAY [ task_work_comp.attr_2102_ ] ELSE massive_ord.mas_ord 
	END 
	FROM
		registry.object_2137_ o
		LEFT JOIN (
		SELECT
			comp.attr_3203_ AS nom_ed,
			comp.attr_3204_ AS tech_card,
			comp.attr_2173_ AS task_work,
			comp.attr_3175_ AS task_work_pos,
			comp.attr_2203_ AS ed_hran,
			comp.attr_2104_ AS mat,
			comp.attr_2105_ AS sort,
			comp.attr_2106_ AS tr,
			SUM ( comp.attr_2103_ ),
			ARRAY_AGG ( DISTINCT ( ord_to_man.ID ) ) AS mas_ord,
			ARRAY_AGG ( DISTINCT ( comp_ord.attr_1482_ ) ) AS mas_izd 
		FROM
			registry.object_2094_ comp /*компоненты заданий в работу*/
			LEFT JOIN registry.object_606_ ord_to_man ON comp.attr_2102_ = ord_to_man.ID /*Заказ в производство*/
			LEFT JOIN registry.object_1409_ comp_ord ON comp.attr_2101_ = comp_ord.ID /*Компонент проектируемого изделия*/
			
		WHERE
			comp.is_deleted <> TRUE 
		GROUP BY
			comp.attr_3203_,
			comp.attr_3204_,
			comp.attr_2173_,
			comp.attr_2203_,
			comp.attr_2104_,
			comp.attr_2105_,
			comp.attr_2106_,
			comp.attr_3175_ 
		ORDER BY
			comp.attr_3203_,
			comp.attr_3204_,
			comp.attr_2203_ 
		) massive_ord ON massive_ord.task_work_pos = o.attr_3193_ 
		AND massive_ord.nom_ed = o.attr_2632_
		LEFT JOIN registry.object_2094_ task_work_comp ON o.attr_3414_ = task_work_comp.ID 
		WHERE
		o.is_deleted IS NOT TRUE 
	GROUP BY
		massive_ord.mas_ord,
		task_work_comp.ID,
		massive_ord.mas_izd,
		o.ID,
		massive_ord.nom_ed,
		massive_ord.tech_card,
		massive_ord.task_work,
		massive_ord.task_work_pos,
		massive_ord.ed_hran,
		massive_ord.mat,
		massive_ord.sort,
	massive_ord.tr,
	massive_ord.SUM
