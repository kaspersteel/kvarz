/*поле json с массивом записей-объектов*/
[{"ord":448, "given":true, "step":"015", "t_oper":"Слесарная", "quant_cancel":2}, {"ord":449, "given":true, "step":"005", "t_oper":"Отрезная", "quant_cancel":1}]

/*исходный запрос-парсер поля json*/
SELECT * 
FROM  json_to_recordset((SELECT attr_3839_ FROM registry.object_2137_ o WHERE o.id=555)) as cancel(ord numeric, step text, t_oper text, quant_cancel numeric)
WHERE cancel.ord=459

/*запрос в расширенной таблице. в базовую формулу перенести части, качающиеся таблицы таблицы "cancel", нужные параметры вытягиваются в любой другой формуле*/
SELECT o.id,2137 AS "Реестр_ПВ",array_to_string(array_agg(distinct jn_84.attr_607_), '; ') AS "Заказ",o.attr_2155_ AS "Номер_ПВ",o.attr_3207_ AS "Плановое_количество",o.attr_3402_ AS "Заказы",array_agg(distinct jn_84.id) AS xref_2675, 
cancel.given, 
cancel.step,
cancel.t_oper,
cancel.quant_cancel 
FROM registry.object_2137_ o
LEFT JOIN registry.xref_2675_ ON o.id = xref_2675_.from_id 
LEFT JOIN registry.object_606_ AS jn_84 ON xref_2675_.to_id = jn_84.id AND jn_84.is_deleted = false
LEFT JOIN LATERAL(SELECT * FROM json_to_recordset(o.attr_3839_) AS cancel(ord numeric, given boolean, step text, t_oper text, quant_cancel numeric)) AS cancel ON cancel.ord::VARCHAR=jn_84.attr_607_
WHERE o.is_deleted = false
GROUP BY o.id,jn_84.attr_607_,cancel.given, cancel.step, cancel.t_oper, cancel.quant_cancel 