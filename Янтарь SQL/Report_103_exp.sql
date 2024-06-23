/*Полное расписание на день по новому расписанию*/
WITH 
ts /*таблица интервалов*/
AS (select * 
	from registry.object_4002_), 
o /*базовая таблица*/
AS (SELECT attr_4007_, attr_4009_, attr_4011_, attr_4013_, attr_4015_, attr_4017_, attr_4019_, attr_4021_, attr_4023_, attr_4025_, attr_4027_, attr_4029_, attr_4162_, attr_4165_, attr_4168_, attr_4251_, attr_4004_, attr_4005_ 
	FROM registry.object_4000_ 
	WHERE is_deleted<>true and attr_4032_='2024-02-26'::date)

select
(select ts.attr_4003_ from o registry.xref_4007_ o.attr_4007_) as lfk1,

/*o.attr_4009_ as lfk2,

o.attr_4011_ as bass,

o.attr_4013_ as hidro,

o.attr_4015_ as ergo,

o.attr_4017_ as logo,

o.attr_4019_ as pshich,

o.attr_4021_ as irt,

o.attr_4023_ as mass,

o.attr_4025_ as ft,

o.attr_4027_ as gt,

o.attr_4029_ as sol_p,

o.attr_4162_ as girudoterapy,

o.attr_4165_ as fitoterapy,

o.attr_4168_ as kislorod_cocteil,

o.attr_4251_ as soc_cult,*/

fio_pac.attr_1985_ as fio, nomer.attr_135_ as nom_and_category

from o
left join registry.object_303_ hist on o.attr_4005_=hist.id
left join registry.object_102_ zaezd on hist.attr_765_=zaezd.id
left join registry.object_45_ fio_pac on o.attr_4004_=fio_pac.id
left join registry.object_127_ nomer on zaezd.attr_117_=nomer.id

order by fio_pac.attr_1985_

