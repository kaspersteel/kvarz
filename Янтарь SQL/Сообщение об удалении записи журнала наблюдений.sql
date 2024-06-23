SELECT	 
concat ('По пациенту ', hist.attr_2364_,' ИБ №', hist.attr_1898_, ' удалена запись журнала наблюдений от ', j_nabl.attr_658_)
FROM registry.object_4259_ o
LEFT JOIN registry.object_316_ j_nabl ON j_nabl.id = o.attr_4260_
LEFT JOIN registry.object_303_ hist ON hist.id = j_nabl.attr_319_
ORDER BY o.id desc
LIMIT 1