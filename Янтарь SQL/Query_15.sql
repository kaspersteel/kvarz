/*Календарь заселения*/

select pacient.attr_69_ as pacient_fio,
o.attr_136_ as date_zaezd, 
form_opl.attr_121_ as forma_opl, 
nomer.attr_444_ as room, 
status.attr_119_ as stasus_zaezd,

case when o.attr_449_ is null then concat (pacient.attr_1985_, ', ', form_opl.attr_121_, ', ', prizn.attr_3491_, case when o.attr_3473_ is true then ', доп.день' else '' end) 
else concat ('Сопр. пац-та ', sopr.attr_1985_, ' - ', pacient.attr_1985_) end as podp,
o.attr_116_ as com,

CASE 

WHEN o.attr_105_ in (12, 19, 7) and o.attr_114_=2 THEN 'green' 
WHEN o.attr_105_ in (12, 19, 7) and o.attr_114_=1 then  'yellow'
WHEN o.attr_105_ in (14,33) then  'orange'
WHEN o.attr_105_ = 6 or ( o.attr_117_ is not null and o.attr_698_ is not null and o.attr_105_ = 25) THEN 'blue'
else  'grey' end as color,

o.id as zap_id


from registry.object_102_ o

left join registry.object_45_ pacient on o.attr_104_=pacient.id and pacient.is_deleted<>true
left join registry.object_120_ form_opl on o.attr_114_=form_opl.id and form_opl.is_deleted<>true
left join registry.object_127_ nomer on o.attr_117_=nomer.id and nomer.is_deleted<>true
left join registry.object_118_ status on o.attr_105_=status.id and status.is_deleted<>true
left join registry.object_3490_ prizn on pacient.attr_3489_=prizn.id and prizn.is_deleted<>true
left join registry.object_127_ rooms on rooms.id=o.attr_117_ and rooms.is_deleted <>true
left join registry.object_45_ sopr on o.attr_449_= sopr.id and sopr.is_deleted<>true
left join registry.object_102_ check_in2 on check_in2.id = o.attr_698_

where o.is_deleted<>true and o.attr_136_ is not null and o.attr_105_ in (6, 7, 11, 12, 14, 15, 19, 25, 26, 27, 32, 33, 34, 35, 36) /*and o.attr_649_ <>true*/
order by o.attr_136_