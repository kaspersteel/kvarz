WITH o AS (
SELECT *
FROM registry.object_4000_ base
LEFT JOIN registry.object_45_ fio_pac ON base.attr_4004_=fio_pac.id AND fio_pac.is_deleted<>true
LEFT JOIN registry.object_127_ nom_cat ON base.attr_4006_=nom_cat.id AND nom_cat.is_deleted<>true
WHERE base.is_deleted<>true AND base.attr_4032_='{date_rasp}')

select o1.fio, o1.proc, o1.nom, o1.hist_id, o1.time_proc
from 
(select o.attr_1985_ as fio, proc_id.attr_695_ as proc, o.attr_444_ as nom, o.attr_4005_ as hist_id,

concat(
case 
when o.attr_4007_@>array[2,3] and o.attr_4007_@>array[4]<>true then concat('08:30 - 09:10', '\n')
when o.attr_4007_@>array[3,4] and o.attr_4007_@>array[2]<>true then concat('08:50 - 09:30', '\n')
else concat(
case when o.attr_4007_@>array[2] then concat('08:30 - 08:50', '\n') end,
case when o.attr_4007_@>array[3] then concat('08:50 - 09:10', '\n') end,
case when o.attr_4007_@>array[4] then concat('09:10 - 09:30', '\n') end)
end, 
case 
when o.attr_4007_@>array[5,6] then concat('09:40 - 10:20', '\n')
when o.attr_4007_@>array[5] and o.attr_4007_@>array[6]<>true then concat('09:40 - 10:00', '\n')
when o.attr_4007_@>array[6] and o.attr_4007_@>array[5]<>true then concat('10:00 - 10:20', '\n') end,
case
when o.attr_4007_@>array[7,8] then concat('10:30 - 11:10', '\n') 
when o.attr_4007_@>array[7] and o.attr_4007_@>array[8]<>true then concat('10:30 - 10:50', '\n')
when o.attr_4007_@>array[8] and o.attr_4007_@>array[7]<>true then concat('10:50 - 11:10', '\n') end,
case
when o.attr_4007_@>array[9,10] then concat('11:20 - 12:00', '\n') 
when o.attr_4007_@>array[9] and o.attr_4007_@>array[10]<>true then concat('11:20 - 11:40', '\n')
when o.attr_4007_@>array[10] and o.attr_4007_@>array[9]<>true then concat('11:40 - 12:00', '\n') end,
case
when o.attr_4007_@>array[11,12] then concat('13:00 - 13:40', '\n') 
when o.attr_4007_@>array[11] and o.attr_4007_@>array[12]<>true then concat('13:00 - 13:20', '\n')
when o.attr_4007_@>array[12] and o.attr_4007_@>array[11]<>true then concat('13:20 - 13:40', '\n')
end,
case
when o.attr_4007_@>array[13,14] then concat('13:50 - 14:30', '\n') 
when o.attr_4007_@>array[13] and o.attr_4007_@>array[14]<>true then concat('13:50 - 14:10', '\n')
when o.attr_4007_@>array[14] and o.attr_4007_@>array[13]<>true then concat('14:10 - 14:30', '\n')
end,
case
when o.attr_4007_@>array[15,16] then concat('14:40 - 15:20', '\n') 
when o.attr_4007_@>array[15] and o.attr_4007_@>array[16]<>true then concat('14:40 - 15:00', '\n')
when o.attr_4007_@>array[16] and o.attr_4007_@>array[15]<>true then concat('15:00 - 15:20', '\n')
end,
case
when o.attr_4007_@>array[17,18] then concat('15:30 - 16:10', '\n') 
when o.attr_4007_@>array[17] and o.attr_4007_@>array[18]<>true then concat('15:30 - 15:50', '\n')
when o.attr_4007_@>array[18] and o.attr_4007_@>array[17]<>true then concat('15:50 - 16:10', '\n')
end,
case
when o.attr_4007_@>array[19,20] then concat('16:20 - 17:00', '\n') 
when o.attr_4007_@>array[19] and o.attr_4007_@>array[20]<>true then concat('16:20 - 16:40', '\n')
when o.attr_4007_@>array[20] and o.attr_4007_@>array[19]<>true then concat('16:40 - 17:00', '\n')
end,
case
when o.attr_4007_@>array[21,22] then concat('17:00 - 17:40', '\n') 
when o.attr_4007_@>array[21] and o.attr_4007_@>array[22]<>true then concat('17:00 - 17:20', '\n')
when o.attr_4007_@>array[22] and o.attr_4007_@>array[21]<>true then concat('17:20 - 17:40', '\n')
end,
case
when o.attr_4007_@>array[23,24] then concat('17:40 - 18:20', '\n') 
when o.attr_4007_@>array[23] and o.attr_4007_@>array[24]<>true then concat('17:40 - 18:00', '\n')
when o.attr_4007_@>array[24] and o.attr_4007_@>array[23]<>true then concat('18:00 - 18:20', '\n')
end,
case
when o.attr_4007_@>array[25,26] then concat('18:20 - 19:00', '\n') 
when o.attr_4007_@>array[25] and o.attr_4007_@>array[26]<>true then concat('18:20 - 18:40', '\n')
when o.attr_4007_@>array[26] and o.attr_4007_@>array[25]<>true then concat('18:40 - 19:00', '\n')
end) as time_proc

from o
left join registry.object_783_ pl on o.attr_4008_=pl.id and pl.is_deleted<>true
left join registry.object_694_ proc_id on pl.attr_784_=proc_id.id and proc_id.is_deleted<>true
where o.attr_4007_ is not null

union all

select o.attr_1985_ as fio, proc_id.attr_695_ as proc, o.attr_444_ as nom, o.attr_4005_ as hist_id,

concat(
case 
when o.attr_4009_@>array[2,3] and o.attr_4009_@>array[4]<>true then concat('08:30 - 09:10', '\n')
when o.attr_4009_@>array[3,4] and o.attr_4009_@>array[2]<>true then concat('08:50 - 09:30', '\n')
else concat(
case when o.attr_4009_@>array[2] then concat('08:30 - 08:50', '\n')  end,
case when o.attr_4009_@>array[3] then concat('08:50 - 09:10', '\n')  end,
case when o.attr_4009_@>array[4] then concat('09:10 - 09:30', '\n')  end)
end, 
case 
when o.attr_4009_@>array[5,6] then concat('09:40 - 10:20', '\n')
when o.attr_4009_@>array[5] and o.attr_4009_@>array[6]<>true then concat('09:40 - 10:00', '\n')
when o.attr_4009_@>array[6] and o.attr_4009_@>array[5]<>true then concat('10:00 - 10:20', '\n')
 end,
case
when o.attr_4009_@>array[7,8] then concat('10:30 - 11:10', '\n') 
when o.attr_4009_@>array[7] and o.attr_4009_@>array[8]<>true then concat('10:30 - 10:50', '\n')
when o.attr_4009_@>array[8] and o.attr_4009_@>array[7]<>true then concat('10:50 - 11:10', '\n')
 end,
case
when o.attr_4009_@>array[9,10] then concat('11:20 - 12:00', '\n') 
when o.attr_4009_@>array[9] and o.attr_4009_@>array[10]<>true then concat('11:20 - 11:40', '\n')
when o.attr_4009_@>array[10] and o.attr_4009_@>array[9]<>true then concat('11:40 - 12:00', '\n')
 end,
case
when o.attr_4009_@>array[11,12] then concat('13:00 - 13:40', '\n') 
when o.attr_4009_@>array[11] and o.attr_4009_@>array[12]<>true then concat('13:00 - 13:20', '\n')
when o.attr_4009_@>array[12] and o.attr_4009_@>array[11]<>true then concat('13:20 - 13:40', '\n')
 end,
case
when o.attr_4009_@>array[13,14] then concat('13:50 - 14:30', '\n') 
when o.attr_4009_@>array[13] and o.attr_4009_@>array[14]<>true then concat('13:50 - 14:10', '\n')
when o.attr_4009_@>array[14] and o.attr_4009_@>array[13]<>true then concat('14:10 - 14:30', '\n')
 end,
case
when o.attr_4009_@>array[15,16] then concat('14:40 - 15:20', '\n') 
when o.attr_4009_@>array[15] and o.attr_4009_@>array[16]<>true then concat('14:40 - 15:00', '\n')
when o.attr_4009_@>array[16] and o.attr_4009_@>array[15]<>true then concat('15:00 - 15:20', '\n')
 end,
case
when o.attr_4009_@>array[17,18] then concat('15:30 - 16:10', '\n') 
when o.attr_4009_@>array[17] and o.attr_4009_@>array[18]<>true then concat('15:30 - 15:50', '\n')
when o.attr_4009_@>array[18] and o.attr_4009_@>array[17]<>true then concat('15:50 - 16:10', '\n')
 end,
case
when o.attr_4009_@>array[19,20] then concat('16:20 - 17:00', '\n') 
when o.attr_4009_@>array[19] and o.attr_4009_@>array[20]<>true then concat('16:20 - 16:40', '\n')
when o.attr_4009_@>array[20] and o.attr_4009_@>array[19]<>true then concat('16:40 - 17:00', '\n')
 end,
case
when o.attr_4009_@>array[21,22] then concat('17:00 - 17:40', '\n') 
when o.attr_4009_@>array[21] and o.attr_4009_@>array[22]<>true then concat('17:00 - 17:20', '\n')
when o.attr_4009_@>array[22] and o.attr_4009_@>array[21]<>true then concat('17:20 - 17:40', '\n')
end,
case
when o.attr_4009_@>array[23,24] then concat('17:40 - 18:20', '\n') 
when o.attr_4009_@>array[23] and o.attr_4009_@>array[24]<>true then concat('17:40 - 18:00', '\n')
when o.attr_4009_@>array[24] and o.attr_4009_@>array[23]<>true then concat('18:00 - 18:20', '\n')
end,
case
when o.attr_4009_@>array[25,26] then concat('18:20 - 19:00', '\n') 
when o.attr_4009_@>array[25] and o.attr_4009_@>array[26]<>true then concat('18:20 - 18:40', '\n')
when o.attr_4009_@>array[26] and o.attr_4009_@>array[25]<>true then concat('18:40 - 19:00', '\n')
end) as time_proc

from o
left join registry.object_783_ pl on o.attr_4010_=pl.id and pl.is_deleted<>true
left join registry.object_694_ proc_id on pl.attr_784_=proc_id.id and proc_id.is_deleted<>true
where o.attr_4009_ is not null 

union all

select o.attr_1985_ as fio, proc_id.attr_695_ as proc, o.attr_444_ as nom, o.attr_4005_ as hist_id,

concat(
case 
when o.attr_4011_@>array[2,3] and o.attr_4011_@>array[4]<>true then concat('08:30 - 09:10', '\n')
when o.attr_4011_@>array[3,4] and o.attr_4011_@>array[2]<>true then concat('08:50 - 09:30', '\n')
else concat(
case when o.attr_4011_@>array[2] then concat('08:30 - 08:50', '\n')  end,
case when o.attr_4011_@>array[3] then concat('08:50 - 09:10', '\n')  end,
case when o.attr_4011_@>array[4] then concat('09:10 - 09:30', '\n')  end)
end, 
case 
when o.attr_4011_@>array[5,6] then concat('09:40 - 10:20', '\n')
when o.attr_4011_@>array[5] and o.attr_4011_@>array[6]<>true then concat('09:40 - 10:00', '\n')
when o.attr_4011_@>array[6] and o.attr_4011_@>array[5]<>true then concat('10:00 - 10:20', '\n')
 end,
case
when o.attr_4011_@>array[7,8] then concat('10:30 - 11:10', '\n') 
when o.attr_4011_@>array[7] and o.attr_4011_@>array[8]<>true then concat('10:30 - 10:50', '\n')
when o.attr_4011_@>array[8] and o.attr_4011_@>array[7]<>true then concat('10:50 - 11:10', '\n')
 end,
case
when o.attr_4011_@>array[9,10] then concat('11:20 - 12:00', '\n') 
when o.attr_4011_@>array[9] and o.attr_4011_@>array[10]<>true then concat('11:20 - 11:40', '\n')
when o.attr_4011_@>array[10] and o.attr_4011_@>array[9]<>true then concat('11:40 - 12:00', '\n')
 end,
case
when o.attr_4011_@>array[11,12] then concat('13:00 - 13:40', '\n') 
when o.attr_4011_@>array[11] and o.attr_4011_@>array[12]<>true then concat('13:00 - 13:20', '\n')
when o.attr_4011_@>array[12] and o.attr_4011_@>array[11]<>true then concat('13:20 - 13:40', '\n')
 end,
case
when o.attr_4011_@>array[13,14] then concat('13:50 - 14:30', '\n') 
when o.attr_4011_@>array[13] and o.attr_4011_@>array[14]<>true then concat('13:50 - 14:10', '\n')
when o.attr_4011_@>array[14] and o.attr_4011_@>array[13]<>true then concat('14:10 - 14:30', '\n')
 end,
case
when o.attr_4011_@>array[15,16] then concat('14:40 - 15:20', '\n') 
when o.attr_4011_@>array[15] and o.attr_4011_@>array[16]<>true then concat('14:40 - 15:00', '\n')
when o.attr_4011_@>array[16] and o.attr_4011_@>array[15]<>true then concat('15:00 - 15:20', '\n')
 end,
case
when o.attr_4011_@>array[17,18] then concat('15:30 - 16:10', '\n') 
when o.attr_4011_@>array[17] and o.attr_4011_@>array[18]<>true then concat('15:30 - 15:50', '\n')
when o.attr_4011_@>array[18] and o.attr_4011_@>array[17]<>true then concat('15:50 - 16:10', '\n')
 end,
case
when o.attr_4011_@>array[19,20] then concat('16:20 - 17:00', '\n') 
when o.attr_4011_@>array[19] and o.attr_4011_@>array[20]<>true then concat('16:20 - 16:40', '\n')
when o.attr_4011_@>array[20] and o.attr_4011_@>array[19]<>true then concat('16:40 - 17:00', '\n')
 end,
case
when o.attr_4011_@>array[21,22] then concat('17:00 - 17:40', '\n') 
when o.attr_4011_@>array[21] and o.attr_4011_@>array[22]<>true then concat('17:00 - 17:20', '\n')
when o.attr_4011_@>array[22] and o.attr_4011_@>array[21]<>true then concat('17:20 - 17:40', '\n')
end,
case
when o.attr_4011_@>array[23,24] then concat('17:40 - 18:20', '\n') 
when o.attr_4011_@>array[23] and o.attr_4011_@>array[24]<>true then concat('17:40 - 18:00', '\n')
when o.attr_4011_@>array[24] and o.attr_4011_@>array[23]<>true then concat('18:00 - 18:20', '\n')
end,
case
when o.attr_4011_@>array[25,26] then concat('18:20 - 19:00', '\n') 
when o.attr_4011_@>array[25] and o.attr_4011_@>array[26]<>true then concat('18:20 - 18:40', '\n')
when o.attr_4011_@>array[26] and o.attr_4011_@>array[25]<>true then concat('18:40 - 19:00', '\n')
end) as time_proc

from o
left join registry.object_783_ pl on o.attr_4012_=pl.id and pl.is_deleted<>true
left join registry.object_694_ proc_id on pl.attr_784_=proc_id.id and proc_id.is_deleted<>true
where o.attr_4011_ is not null 

union all

select o.attr_1985_ as fio, proc_id.attr_695_ as proc, o.attr_444_ as nom, o.attr_4005_ as hist_id,

concat(
case 
when o.attr_4013_@>array[2,3] and o.attr_4013_@>array[4]<>true then concat('08:30 - 09:10', '\n')
when o.attr_4013_@>array[3,4] and o.attr_4013_@>array[2]<>true then concat('08:50 - 09:30', '\n')
else concat(
case when o.attr_4013_@>array[2] then concat('08:30 - 08:50', '\n')  end,
case when o.attr_4013_@>array[3] then concat('08:50 - 09:10', '\n')  end,
case when o.attr_4013_@>array[4] then concat('09:10 - 09:30', '\n')  end)
end, 
case 
when o.attr_4013_@>array[5,6] then concat('09:40 - 10:20', '\n')
when o.attr_4013_@>array[5] and o.attr_4013_@>array[6]<>true then concat('09:40 - 10:00', '\n')
when o.attr_4013_@>array[6] and o.attr_4013_@>array[5]<>true then concat('10:00 - 10:20', '\n')
 end,
case
when o.attr_4013_@>array[7,8] then concat('10:30 - 11:10', '\n') 
when o.attr_4013_@>array[7] and o.attr_4013_@>array[8]<>true then concat('10:30 - 10:50', '\n')
when o.attr_4013_@>array[8] and o.attr_4013_@>array[7]<>true then concat('10:50 - 11:10', '\n')
 end,
case
when o.attr_4013_@>array[9,10] then concat('11:20 - 12:00', '\n') 
when o.attr_4013_@>array[9] and o.attr_4013_@>array[10]<>true then concat('11:20 - 11:40', '\n')
when o.attr_4013_@>array[10] and o.attr_4013_@>array[9]<>true then concat('11:40 - 12:00', '\n')
 end,
case
when o.attr_4013_@>array[11,12] then concat('13:00 - 13:40', '\n') 
when o.attr_4013_@>array[11] and o.attr_4013_@>array[12]<>true then concat('13:00 - 13:20', '\n')
when o.attr_4013_@>array[12] and o.attr_4013_@>array[11]<>true then concat('13:20 - 13:40', '\n')
 end,
case
when o.attr_4013_@>array[13,14] then concat('13:50 - 14:30', '\n') 
when o.attr_4013_@>array[13] and o.attr_4013_@>array[14]<>true then concat('13:50 - 14:10', '\n')
when o.attr_4013_@>array[14] and o.attr_4013_@>array[13]<>true then concat('14:10 - 14:30', '\n')
 end,
case
when o.attr_4013_@>array[15,16] then concat('14:40 - 15:20', '\n') 
when o.attr_4013_@>array[15] and o.attr_4013_@>array[16]<>true then concat('14:40 - 15:00', '\n')
when o.attr_4013_@>array[16] and o.attr_4013_@>array[15]<>true then concat('15:00 - 15:20', '\n')
 end,
case
when o.attr_4013_@>array[17,18] then concat('15:30 - 16:10', '\n') 
when o.attr_4013_@>array[17] and o.attr_4013_@>array[18]<>true then concat('15:30 - 15:50', '\n')
when o.attr_4013_@>array[18] and o.attr_4013_@>array[17]<>true then concat('15:50 - 16:10', '\n')
 end,
case
when o.attr_4013_@>array[19,20] then concat('16:20 - 17:00', '\n') 
when o.attr_4013_@>array[19] and o.attr_4013_@>array[20]<>true then concat('16:20 - 16:40', '\n')
when o.attr_4013_@>array[20] and o.attr_4013_@>array[19]<>true then concat('16:40 - 17:00', '\n')
 end,
case
when o.attr_4013_@>array[21,22] then concat('17:00 - 17:40', '\n') 
when o.attr_4013_@>array[21] and o.attr_4013_@>array[22]<>true then concat('17:00 - 17:20', '\n')
when o.attr_4013_@>array[22] and o.attr_4013_@>array[21]<>true then concat('17:20 - 17:40', '\n')
end,
case
when o.attr_4013_@>array[23,24] then concat('17:40 - 18:20', '\n') 
when o.attr_4013_@>array[23] and o.attr_4013_@>array[24]<>true then concat('17:40 - 18:00', '\n')
when o.attr_4013_@>array[24] and o.attr_4013_@>array[23]<>true then concat('18:00 - 18:20', '\n')
end,
case
when o.attr_4013_@>array[25,26] then concat('18:20 - 19:00', '\n') 
when o.attr_4013_@>array[25] and o.attr_4013_@>array[26]<>true then concat('18:20 - 18:40', '\n')
when o.attr_4013_@>array[26] and o.attr_4013_@>array[25]<>true then concat('18:40 - 19:00', '\n')
end) as time_proc

from o
left join registry.object_783_ pl on o.attr_4014_=pl.id and pl.is_deleted<>true
left join registry.object_694_ proc_id on pl.attr_784_=proc_id.id and proc_id.is_deleted<>true
where o.attr_4013_ is not null 

union all

select o.attr_1985_ as fio, proc_id.attr_695_ as proc, o.attr_444_ as nom, o.attr_4005_ as hist_id,

concat(
case 
when o.attr_4015_@>array[2,3] and o.attr_4015_@>array[4]<>true then concat('08:30 - 09:10', '\n')
when o.attr_4015_@>array[3,4] and o.attr_4015_@>array[2]<>true then concat('08:50 - 09:30', '\n')
else concat(
case when o.attr_4015_@>array[2] then concat('08:30 - 08:50', '\n')  end,
case when o.attr_4015_@>array[3] then concat('08:50 - 09:10', '\n')  end,
case when o.attr_4015_@>array[4] then concat('09:10 - 09:30', '\n')  end)
end, 
case 
when o.attr_4015_@>array[5,6] then concat('09:40 - 10:20', '\n')
when o.attr_4015_@>array[5] and o.attr_4015_@>array[6]<>true then concat('09:40 - 10:00', '\n')
when o.attr_4015_@>array[6] and o.attr_4015_@>array[5]<>true then concat('10:00 - 10:20', '\n')
 end,
case
when o.attr_4015_@>array[7,8] then concat('10:30 - 11:10', '\n') 
when o.attr_4015_@>array[7] and o.attr_4015_@>array[8]<>true then concat('10:30 - 10:50', '\n')
when o.attr_4015_@>array[8] and o.attr_4015_@>array[7]<>true then concat('10:50 - 11:10', '\n')
 end,
case
when o.attr_4015_@>array[9,10] then concat('11:20 - 12:00', '\n') 
when o.attr_4015_@>array[9] and o.attr_4015_@>array[10]<>true then concat('11:20 - 11:40', '\n')
when o.attr_4015_@>array[10] and o.attr_4015_@>array[9]<>true then concat('11:40 - 12:00', '\n')
 end,
case
when o.attr_4015_@>array[11,12] then concat('13:00 - 13:40', '\n') 
when o.attr_4015_@>array[11] and o.attr_4015_@>array[12]<>true then concat('13:00 - 13:20', '\n')
when o.attr_4015_@>array[12] and o.attr_4015_@>array[11]<>true then concat('13:20 - 13:40', '\n')
 end,
case
when o.attr_4015_@>array[13,14] then concat('13:50 - 14:30', '\n') 
when o.attr_4015_@>array[13] and o.attr_4015_@>array[14]<>true then concat('13:50 - 14:10', '\n')
when o.attr_4015_@>array[14] and o.attr_4015_@>array[13]<>true then concat('14:10 - 14:30', '\n')
 end,
case
when o.attr_4015_@>array[15,16] then concat('14:40 - 15:20', '\n') 
when o.attr_4015_@>array[15] and o.attr_4015_@>array[16]<>true then concat('14:40 - 15:00', '\n')
when o.attr_4015_@>array[16] and o.attr_4015_@>array[15]<>true then concat('15:00 - 15:20', '\n')
 end,
case
when o.attr_4015_@>array[17,18] then concat('15:30 - 16:10', '\n') 
when o.attr_4015_@>array[17] and o.attr_4015_@>array[18]<>true then concat('15:30 - 15:50', '\n')
when o.attr_4015_@>array[18] and o.attr_4015_@>array[17]<>true then concat('15:50 - 16:10', '\n')
 end,
case
when o.attr_4015_@>array[19,20] then concat('16:20 - 17:00', '\n') 
when o.attr_4015_@>array[19] and o.attr_4015_@>array[20]<>true then concat('16:20 - 16:40', '\n')
when o.attr_4015_@>array[20] and o.attr_4015_@>array[19]<>true then concat('16:40 - 17:00', '\n')
 end,
case
when o.attr_4015_@>array[21,22] then concat('17:00 - 17:40', '\n') 
when o.attr_4015_@>array[21] and o.attr_4015_@>array[22]<>true then concat('17:00 - 17:20', '\n')
when o.attr_4015_@>array[22] and o.attr_4015_@>array[21]<>true then concat('17:20 - 17:40', '\n')
end,
case
when o.attr_4015_@>array[23,24] then concat('17:40 - 18:20', '\n') 
when o.attr_4015_@>array[23] and o.attr_4015_@>array[24]<>true then concat('17:40 - 18:00', '\n')
when o.attr_4015_@>array[24] and o.attr_4015_@>array[23]<>true then concat('18:00 - 18:20', '\n')
end,
case
when o.attr_4015_@>array[25,26] then concat('18:20 - 19:00', '\n') 
when o.attr_4015_@>array[25] and o.attr_4015_@>array[26]<>true then concat('18:20 - 18:40', '\n')
when o.attr_4015_@>array[26] and o.attr_4015_@>array[25]<>true then concat('18:40 - 19:00', '\n')
end) as time_proc

from o
left join registry.object_783_ pl on o.attr_4016_=pl.id and pl.is_deleted<>true
left join registry.object_694_ proc_id on pl.attr_784_=proc_id.id and proc_id.is_deleted<>true
where o.attr_4015_ is not null 

union all

select o.attr_1985_ as fio, proc_id.attr_695_ as proc, o.attr_444_ as nom, o.attr_4005_ as hist_id,

concat(
case 
when o.attr_4017_@>array[2,3] and o.attr_4017_@>array[4]<>true then concat('08:30 - 09:10', '\n')
when o.attr_4017_@>array[3,4] and o.attr_4017_@>array[2]<>true then concat('08:50 - 09:30', '\n')
else concat(
case when o.attr_4017_@>array[2] then concat('08:30 - 08:50', '\n')  end,
case when o.attr_4017_@>array[3] then concat('08:50 - 09:10', '\n')  end,
case when o.attr_4017_@>array[4] then concat('09:10 - 09:30', '\n')  end)
end, 
case 
when o.attr_4017_@>array[5,6] then concat('09:40 - 10:20', '\n')
when o.attr_4017_@>array[5] and o.attr_4017_@>array[6]<>true then concat('09:40 - 10:00', '\n')
when o.attr_4017_@>array[6] and o.attr_4017_@>array[5]<>true then concat('10:00 - 10:20', '\n')
 end,
case
when o.attr_4017_@>array[7,8] then concat('10:30 - 11:10', '\n') 
when o.attr_4017_@>array[7] and o.attr_4017_@>array[8]<>true then concat('10:30 - 10:50', '\n')
when o.attr_4017_@>array[8] and o.attr_4017_@>array[7]<>true then concat('10:50 - 11:10', '\n')
 end,
case
when o.attr_4017_@>array[9,10] then concat('11:20 - 12:00', '\n') 
when o.attr_4017_@>array[9] and o.attr_4017_@>array[10]<>true then concat('11:20 - 11:40', '\n')
when o.attr_4017_@>array[10] and o.attr_4017_@>array[9]<>true then concat('11:40 - 12:00', '\n')
 end,
case
when o.attr_4017_@>array[11,12] then concat('13:00 - 13:40', '\n') 
when o.attr_4017_@>array[11] and o.attr_4017_@>array[12]<>true then concat('13:00 - 13:20', '\n')
when o.attr_4017_@>array[12] and o.attr_4017_@>array[11]<>true then concat('13:20 - 13:40', '\n')
 end,
case
when o.attr_4017_@>array[13,14] then concat('13:50 - 14:30', '\n') 
when o.attr_4017_@>array[13] and o.attr_4017_@>array[14]<>true then concat('13:50 - 14:10', '\n')
when o.attr_4017_@>array[14] and o.attr_4017_@>array[13]<>true then concat('14:10 - 14:30', '\n')
 end,
case
when o.attr_4017_@>array[15,16] then concat('14:40 - 15:20', '\n') 
when o.attr_4017_@>array[15] and o.attr_4017_@>array[16]<>true then concat('14:40 - 15:00', '\n')
when o.attr_4017_@>array[16] and o.attr_4017_@>array[15]<>true then concat('15:00 - 15:20', '\n')
 end,
case
when o.attr_4017_@>array[17,18] then concat('15:30 - 16:10', '\n') 
when o.attr_4017_@>array[17] and o.attr_4017_@>array[18]<>true then concat('15:30 - 15:50', '\n')
when o.attr_4017_@>array[18] and o.attr_4017_@>array[17]<>true then concat('15:50 - 16:10', '\n')
 end,
case
when o.attr_4017_@>array[19,20] then concat('16:20 - 17:00', '\n') 
when o.attr_4017_@>array[19] and o.attr_4017_@>array[20]<>true then concat('16:20 - 16:40', '\n')
when o.attr_4017_@>array[20] and o.attr_4017_@>array[19]<>true then concat('16:40 - 17:00', '\n')
 end,
case
when o.attr_4017_@>array[21,22] then concat('17:00 - 17:40', '\n') 
when o.attr_4017_@>array[21] and o.attr_4017_@>array[22]<>true then concat('17:00 - 17:20', '\n')
when o.attr_4017_@>array[22] and o.attr_4017_@>array[21]<>true then concat('17:20 - 17:40', '\n')
end,
case
when o.attr_4017_@>array[23,24] then concat('17:40 - 18:20', '\n') 
when o.attr_4017_@>array[23] and o.attr_4017_@>array[24]<>true then concat('17:40 - 18:00', '\n')
when o.attr_4017_@>array[24] and o.attr_4017_@>array[23]<>true then concat('18:00 - 18:20', '\n')
end,
case
when o.attr_4017_@>array[25,26] then concat('18:20 - 19:00', '\n') 
when o.attr_4017_@>array[25] and o.attr_4017_@>array[26]<>true then concat('18:20 - 18:40', '\n')
when o.attr_4017_@>array[26] and o.attr_4017_@>array[25]<>true then concat('18:40 - 19:00', '\n')
end) as time_proc

from o
left join registry.object_783_ pl on o.attr_4018_=pl.id and pl.is_deleted<>true
left join registry.object_694_ proc_id on pl.attr_784_=proc_id.id and proc_id.is_deleted<>true
where o.attr_4017_ is not null 

union all

select o.attr_1985_ as fio, proc_id.attr_695_ as proc, o.attr_444_ as nom, o.attr_4005_ as hist_id,

concat(
case 
when o.attr_4019_@>array[2,3] and o.attr_4019_@>array[4]<>true then concat('08:30 - 09:10', '\n')
when o.attr_4019_@>array[3,4] and o.attr_4019_@>array[2]<>true then concat('08:50 - 09:30', '\n')
else concat(
case when o.attr_4019_@>array[2] then concat('08:30 - 08:50', '\n')  end,
case when o.attr_4019_@>array[3] then concat('08:50 - 09:10', '\n')  end,
case when o.attr_4019_@>array[4] then concat('09:10 - 09:30', '\n')  end)
end, 
case 
when o.attr_4019_@>array[5,6] then concat('09:40 - 10:20', '\n')
when o.attr_4019_@>array[5] and o.attr_4019_@>array[6]<>true then concat('09:40 - 10:00', '\n')
when o.attr_4019_@>array[6] and o.attr_4019_@>array[5]<>true then concat('10:00 - 10:20', '\n')
 end,
case
when o.attr_4019_@>array[7,8] then concat('10:30 - 11:10', '\n') 
when o.attr_4019_@>array[7] and o.attr_4019_@>array[8]<>true then concat('10:30 - 10:50', '\n')
when o.attr_4019_@>array[8] and o.attr_4019_@>array[7]<>true then concat('10:50 - 11:10', '\n')
 end,
case
when o.attr_4019_@>array[9,10] then concat('11:20 - 12:00', '\n') 
when o.attr_4019_@>array[9] and o.attr_4019_@>array[10]<>true then concat('11:20 - 11:40', '\n')
when o.attr_4019_@>array[10] and o.attr_4019_@>array[9]<>true then concat('11:40 - 12:00', '\n')
 end,
case
when o.attr_4019_@>array[11,12] then concat('13:00 - 13:40', '\n') 
when o.attr_4019_@>array[11] and o.attr_4019_@>array[12]<>true then concat('13:00 - 13:20', '\n')
when o.attr_4019_@>array[12] and o.attr_4019_@>array[11]<>true then concat('13:20 - 13:40', '\n')
 end,
case
when o.attr_4019_@>array[13,14] then concat('13:50 - 14:30', '\n') 
when o.attr_4019_@>array[13] and o.attr_4019_@>array[14]<>true then concat('13:50 - 14:10', '\n')
when o.attr_4019_@>array[14] and o.attr_4019_@>array[13]<>true then concat('14:10 - 14:30', '\n')
 end,
case
when o.attr_4019_@>array[15,16] then concat('14:40 - 15:20', '\n') 
when o.attr_4019_@>array[15] and o.attr_4019_@>array[16]<>true then concat('14:40 - 15:00', '\n')
when o.attr_4019_@>array[16] and o.attr_4019_@>array[15]<>true then concat('15:00 - 15:20', '\n')
 end,
case
when o.attr_4019_@>array[17,18] then concat('15:30 - 16:10', '\n') 
when o.attr_4019_@>array[17] and o.attr_4019_@>array[18]<>true then concat('15:30 - 15:50', '\n')
when o.attr_4019_@>array[18] and o.attr_4019_@>array[17]<>true then concat('15:50 - 16:10', '\n')
 end,
case
when o.attr_4019_@>array[19,20] then concat('16:20 - 17:00', '\n') 
when o.attr_4019_@>array[19] and o.attr_4019_@>array[20]<>true then concat('16:20 - 16:40', '\n')
when o.attr_4019_@>array[20] and o.attr_4019_@>array[19]<>true then concat('16:40 - 17:00', '\n')
 end,
case
when o.attr_4019_@>array[21,22] then concat('17:00 - 17:40', '\n') 
when o.attr_4019_@>array[21] and o.attr_4019_@>array[22]<>true then concat('17:00 - 17:20', '\n')
when o.attr_4019_@>array[22] and o.attr_4019_@>array[21]<>true then concat('17:20 - 17:40', '\n')
end,
case
when o.attr_4019_@>array[23,24] then concat('17:40 - 18:20', '\n') 
when o.attr_4019_@>array[23] and o.attr_4019_@>array[24]<>true then concat('17:40 - 18:00', '\n')
when o.attr_4019_@>array[24] and o.attr_4019_@>array[23]<>true then concat('18:00 - 18:20', '\n')
end,
case
when o.attr_4019_@>array[25,26] then concat('18:20 - 19:00', '\n') 
when o.attr_4019_@>array[25] and o.attr_4019_@>array[26]<>true then concat('18:20 - 18:40', '\n')
when o.attr_4019_@>array[26] and o.attr_4019_@>array[25]<>true then concat('18:40 - 19:00', '\n')
end) as time_proc

from o
left join registry.object_783_ pl on o.attr_4020_=pl.id and pl.is_deleted<>true
left join registry.object_694_ proc_id on pl.attr_784_=proc_id.id and proc_id.is_deleted<>true
where o.attr_4019_ is not null 

union all

select o.attr_1985_ as fio, proc_id.attr_695_ as proc, o.attr_444_ as nom, o.attr_4005_ as hist_id,

concat(
case 
when o.attr_4021_@>array[2,3] and o.attr_4021_@>array[4]<>true then concat('08:30 - 09:10', '\n')
when o.attr_4021_@>array[3,4] and o.attr_4021_@>array[2]<>true then concat('08:50 - 09:30', '\n')
else concat(
case when o.attr_4021_@>array[2] then concat('08:30 - 08:50', '\n')  end,
case when o.attr_4021_@>array[3] then concat('08:50 - 09:10', '\n')  end,
case when o.attr_4021_@>array[4] then concat('09:10 - 09:30', '\n')  end)
end, 
case 
when o.attr_4021_@>array[5,6] then concat('09:40 - 10:20', '\n')
when o.attr_4021_@>array[5] and o.attr_4021_@>array[6]<>true then concat('09:40 - 10:00', '\n')
when o.attr_4021_@>array[6] and o.attr_4021_@>array[5]<>true then concat('10:00 - 10:20', '\n')
 end,
case
when o.attr_4021_@>array[7,8] then concat('10:30 - 11:10', '\n') 
when o.attr_4021_@>array[7] and o.attr_4021_@>array[8]<>true then concat('10:30 - 10:50', '\n')
when o.attr_4021_@>array[8] and o.attr_4021_@>array[7]<>true then concat('10:50 - 11:10', '\n')
 end,
case
when o.attr_4021_@>array[9,10] then concat('11:20 - 12:00', '\n') 
when o.attr_4021_@>array[9] and o.attr_4021_@>array[10]<>true then concat('11:20 - 11:40', '\n')
when o.attr_4021_@>array[10] and o.attr_4021_@>array[9]<>true then concat('11:40 - 12:00', '\n')
 end,
case
when o.attr_4021_@>array[11,12] then concat('13:00 - 13:40', '\n') 
when o.attr_4021_@>array[11] and o.attr_4021_@>array[12]<>true then concat('13:00 - 13:20', '\n')
when o.attr_4021_@>array[12] and o.attr_4021_@>array[11]<>true then concat('13:20 - 13:40', '\n')
 end,
case
when o.attr_4021_@>array[13,14] then concat('13:50 - 14:30', '\n') 
when o.attr_4021_@>array[13] and o.attr_4021_@>array[14]<>true then concat('13:50 - 14:10', '\n')
when o.attr_4021_@>array[14] and o.attr_4021_@>array[13]<>true then concat('14:10 - 14:30', '\n')
 end,
case
when o.attr_4021_@>array[15,16] then concat('14:40 - 15:20', '\n') 
when o.attr_4021_@>array[15] and o.attr_4021_@>array[16]<>true then concat('14:40 - 15:00', '\n')
when o.attr_4021_@>array[16] and o.attr_4021_@>array[15]<>true then concat('15:00 - 15:20', '\n')
 end,
case
when o.attr_4021_@>array[17,18] then concat('15:30 - 16:10', '\n') 
when o.attr_4021_@>array[17] and o.attr_4021_@>array[18]<>true then concat('15:30 - 15:50', '\n')
when o.attr_4021_@>array[18] and o.attr_4021_@>array[17]<>true then concat('15:50 - 16:10', '\n')
 end,
case
when o.attr_4021_@>array[19,20] then concat('16:20 - 17:00', '\n') 
when o.attr_4021_@>array[19] and o.attr_4021_@>array[20]<>true then concat('16:20 - 16:40', '\n')
when o.attr_4021_@>array[20] and o.attr_4021_@>array[19]<>true then concat('16:40 - 17:00', '\n')
 end,
case
when o.attr_4021_@>array[21,22] then concat('17:00 - 17:40', '\n') 
when o.attr_4021_@>array[21] and o.attr_4021_@>array[22]<>true then concat('17:00 - 17:20', '\n')
when o.attr_4021_@>array[22] and o.attr_4021_@>array[21]<>true then concat('17:20 - 17:40', '\n')
end,
case
when o.attr_4021_@>array[23,24] then concat('17:40 - 18:20', '\n') 
when o.attr_4021_@>array[23] and o.attr_4021_@>array[24]<>true then concat('17:40 - 18:00', '\n')
when o.attr_4021_@>array[24] and o.attr_4021_@>array[23]<>true then concat('18:00 - 18:20', '\n')
end,
case
when o.attr_4021_@>array[25,26] then concat('18:20 - 19:00', '\n') 
when o.attr_4021_@>array[25] and o.attr_4021_@>array[26]<>true then concat('18:20 - 18:40', '\n')
when o.attr_4021_@>array[26] and o.attr_4021_@>array[25]<>true then concat('18:40 - 19:00', '\n')
end) as time_proc

from o
left join registry.object_783_ pl on o.attr_4022_=pl.id and pl.is_deleted<>true
left join registry.object_694_ proc_id on pl.attr_784_=proc_id.id and proc_id.is_deleted<>true
where o.attr_4021_ is not null 

union all

select o.attr_1985_ as fio, proc_id.attr_695_ as proc, o.attr_444_ as nom, o.attr_4005_ as hist_id,

concat(
case 
when o.attr_4023_@>array[2,3] and o.attr_4023_@>array[4]<>true then concat('08:30 - 09:10', '\n')
when o.attr_4023_@>array[3,4] and o.attr_4023_@>array[2]<>true then concat('08:50 - 09:30', '\n')
else concat(
case when o.attr_4023_@>array[2] then concat('08:30 - 08:50', '\n')  end,
case when o.attr_4023_@>array[3] then concat('08:50 - 09:10', '\n')  end,
case when o.attr_4023_@>array[4] then concat('09:10 - 09:30', '\n')  end)
end, 
case 
when o.attr_4023_@>array[5,6] then concat('09:40 - 10:20', '\n')
when o.attr_4023_@>array[5] and o.attr_4023_@>array[6]<>true then concat('09:40 - 10:00', '\n')
when o.attr_4023_@>array[6] and o.attr_4023_@>array[5]<>true then concat('10:00 - 10:20', '\n')
 end,
case
when o.attr_4023_@>array[7,8] then concat('10:30 - 11:10', '\n') 
when o.attr_4023_@>array[7] and o.attr_4023_@>array[8]<>true then concat('10:30 - 10:50', '\n')
when o.attr_4023_@>array[8] and o.attr_4023_@>array[7]<>true then concat('10:50 - 11:10', '\n')
 end,
case
when o.attr_4023_@>array[9,10] then concat('11:20 - 12:00', '\n') 
when o.attr_4023_@>array[9] and o.attr_4023_@>array[10]<>true then concat('11:20 - 11:40', '\n')
when o.attr_4023_@>array[10] and o.attr_4023_@>array[9]<>true then concat('11:40 - 12:00', '\n')
 end,
case
when o.attr_4023_@>array[11,12] then concat('13:00 - 13:40', '\n') 
when o.attr_4023_@>array[11] and o.attr_4023_@>array[12]<>true then concat('13:00 - 13:20', '\n')
when o.attr_4023_@>array[12] and o.attr_4023_@>array[11]<>true then concat('13:20 - 13:40', '\n')
 end,
case
when o.attr_4023_@>array[13,14] then concat('13:50 - 14:30', '\n') 
when o.attr_4023_@>array[13] and o.attr_4023_@>array[14]<>true then concat('13:50 - 14:10', '\n')
when o.attr_4023_@>array[14] and o.attr_4023_@>array[13]<>true then concat('14:10 - 14:30', '\n')
 end,
case
when o.attr_4023_@>array[15,16] then concat('14:40 - 15:20', '\n') 
when o.attr_4023_@>array[15] and o.attr_4023_@>array[16]<>true then concat('14:40 - 15:00', '\n')
when o.attr_4023_@>array[16] and o.attr_4023_@>array[15]<>true then concat('15:00 - 15:20', '\n')
 end,
case
when o.attr_4023_@>array[17,18] then concat('15:30 - 16:10', '\n') 
when o.attr_4023_@>array[17] and o.attr_4023_@>array[18]<>true then concat('15:30 - 15:50', '\n')
when o.attr_4023_@>array[18] and o.attr_4023_@>array[17]<>true then concat('15:50 - 16:10', '\n')
 end,
case
when o.attr_4023_@>array[19,20] then concat('16:20 - 17:00', '\n') 
when o.attr_4023_@>array[19] and o.attr_4023_@>array[20]<>true then concat('16:20 - 16:40', '\n')
when o.attr_4023_@>array[20] and o.attr_4023_@>array[19]<>true then concat('16:40 - 17:00', '\n')
 end,
case
when o.attr_4023_@>array[21,22] then concat('17:00 - 17:40', '\n') 
when o.attr_4023_@>array[21] and o.attr_4023_@>array[22]<>true then concat('17:00 - 17:20', '\n')
when o.attr_4023_@>array[22] and o.attr_4023_@>array[21]<>true then concat('17:20 - 17:40', '\n')
end,
case
when o.attr_4023_@>array[23,24] then concat('17:40 - 18:20', '\n') 
when o.attr_4023_@>array[23] and o.attr_4023_@>array[24]<>true then concat('17:40 - 18:00', '\n')
when o.attr_4023_@>array[24] and o.attr_4023_@>array[23]<>true then concat('18:00 - 18:20', '\n')
end,
case
when o.attr_4023_@>array[25,26] then concat('18:20 - 19:00', '\n') 
when o.attr_4023_@>array[25] and o.attr_4023_@>array[26]<>true then concat('18:20 - 18:40', '\n')
when o.attr_4023_@>array[26] and o.attr_4023_@>array[25]<>true then concat('18:40 - 19:00', '\n')
end) as time_proc

from o
left join registry.object_783_ pl on o.attr_4024_=pl.id and pl.is_deleted<>true
left join registry.object_694_ proc_id on pl.attr_784_=proc_id.id and proc_id.is_deleted<>true
where o.attr_4023_ is not null 

union all

select o.attr_1985_ as fio, proc_id.attr_695_ as proc, o.attr_444_ as nom, o.attr_4005_ as hist_id,

concat(
case 
when o.attr_4025_@>array[2,3] and o.attr_4025_@>array[4]<>true then concat('08:30 - 09:10', '\n')
when o.attr_4025_@>array[3,4] and o.attr_4025_@>array[2]<>true then concat('08:50 - 09:30', '\n')
else concat(
case when o.attr_4025_@>array[2] then concat('08:30 - 08:50', '\n')  end,
case when o.attr_4025_@>array[3] then concat('08:50 - 09:10', '\n')  end,
case when o.attr_4025_@>array[4] then concat('09:10 - 09:30', '\n')  end)
end, 
case 
when o.attr_4025_@>array[5,6] then concat('09:40 - 10:20', '\n')
when o.attr_4025_@>array[5] and o.attr_4025_@>array[6]<>true then concat('09:40 - 10:00', '\n')
when o.attr_4025_@>array[6] and o.attr_4025_@>array[5]<>true then concat('10:00 - 10:20', '\n')
 end,
case
when o.attr_4025_@>array[7,8] then concat('10:30 - 11:10', '\n') 
when o.attr_4025_@>array[7] and o.attr_4025_@>array[8]<>true then concat('10:30 - 10:50', '\n')
when o.attr_4025_@>array[8] and o.attr_4025_@>array[7]<>true then concat('10:50 - 11:10', '\n')
 end,
case
when o.attr_4025_@>array[9,10] then concat('11:20 - 12:00', '\n') 
when o.attr_4025_@>array[9] and o.attr_4025_@>array[10]<>true then concat('11:20 - 11:40', '\n')
when o.attr_4025_@>array[10] and o.attr_4025_@>array[9]<>true then concat('11:40 - 12:00', '\n')
 end,
case
when o.attr_4025_@>array[11,12] then concat('13:00 - 13:40', '\n') 
when o.attr_4025_@>array[11] and o.attr_4025_@>array[12]<>true then concat('13:00 - 13:20', '\n')
when o.attr_4025_@>array[12] and o.attr_4025_@>array[11]<>true then concat('13:20 - 13:40', '\n')
 end,
case
when o.attr_4025_@>array[13,14] then concat('13:50 - 14:30', '\n') 
when o.attr_4025_@>array[13] and o.attr_4025_@>array[14]<>true then concat('13:50 - 14:10', '\n')
when o.attr_4025_@>array[14] and o.attr_4025_@>array[13]<>true then concat('14:10 - 14:30', '\n')
 end,
case
when o.attr_4025_@>array[15,16] then concat('14:40 - 15:20', '\n') 
when o.attr_4025_@>array[15] and o.attr_4025_@>array[16]<>true then concat('14:40 - 15:00', '\n')
when o.attr_4025_@>array[16] and o.attr_4025_@>array[15]<>true then concat('15:00 - 15:20', '\n')
 end,
case
when o.attr_4025_@>array[17,18] then concat('15:30 - 16:10', '\n') 
when o.attr_4025_@>array[17] and o.attr_4025_@>array[18]<>true then concat('15:30 - 15:50', '\n')
when o.attr_4025_@>array[18] and o.attr_4025_@>array[17]<>true then concat('15:50 - 16:10', '\n')
 end,
case
when o.attr_4025_@>array[19,20] then concat('16:20 - 17:00', '\n') 
when o.attr_4025_@>array[19] and o.attr_4025_@>array[20]<>true then concat('16:20 - 16:40', '\n')
when o.attr_4025_@>array[20] and o.attr_4025_@>array[19]<>true then concat('16:40 - 17:00', '\n')
 end,
case
when o.attr_4025_@>array[21,22] then concat('17:00 - 17:40', '\n') 
when o.attr_4025_@>array[21] and o.attr_4025_@>array[22]<>true then concat('17:00 - 17:20', '\n')
when o.attr_4025_@>array[22] and o.attr_4025_@>array[21]<>true then concat('17:20 - 17:40', '\n')
end,
case
when o.attr_4025_@>array[23,24] then concat('17:40 - 18:20', '\n') 
when o.attr_4025_@>array[23] and o.attr_4025_@>array[24]<>true then concat('17:40 - 18:00', '\n')
when o.attr_4025_@>array[24] and o.attr_4025_@>array[23]<>true then concat('18:00 - 18:20', '\n')
end,
case
when o.attr_4025_@>array[25,26] then concat('18:20 - 19:00', '\n') 
when o.attr_4025_@>array[25] and o.attr_4025_@>array[26]<>true then concat('18:20 - 18:40', '\n')
when o.attr_4025_@>array[26] and o.attr_4025_@>array[25]<>true then concat('18:40 - 19:00', '\n')
end) as time_proc

from o
left join registry.object_783_ pl on o.attr_4026_=pl.id and pl.is_deleted<>true
left join registry.object_694_ proc_id on pl.attr_784_=proc_id.id and proc_id.is_deleted<>true
where o.attr_4025_ is not null 

union all 

select o.attr_1985_ as fio, proc_id.attr_695_ as proc, o.attr_444_ as nom, o.attr_4005_ as hist_id,

concat(
case 
when o.attr_4027_@>array[2,3] and o.attr_4027_@>array[4]<>true then concat('08:30 - 09:10', '\n')
when o.attr_4027_@>array[3,4] and o.attr_4027_@>array[2]<>true then concat('08:50 - 09:30', '\n')
else concat(
case when o.attr_4027_@>array[2] then concat('08:30 - 08:50', '\n')  end,
case when o.attr_4027_@>array[3] then concat('08:50 - 09:10', '\n')  end,
case when o.attr_4027_@>array[4] then concat('09:10 - 09:30', '\n')  end)
end, 
case 
when o.attr_4027_@>array[5,6] then concat('09:40 - 10:20', '\n')
when o.attr_4027_@>array[5] and o.attr_4027_@>array[6]<>true then concat('09:40 - 10:00', '\n')
when o.attr_4027_@>array[6] and o.attr_4027_@>array[5]<>true then concat('10:00 - 10:20', '\n')
 end,
case
when o.attr_4027_@>array[7,8] then concat('10:30 - 11:10', '\n') 
when o.attr_4027_@>array[7] and o.attr_4027_@>array[8]<>true then concat('10:30 - 10:50', '\n')
when o.attr_4027_@>array[8] and o.attr_4027_@>array[7]<>true then concat('10:50 - 11:10', '\n')
 end,
case
when o.attr_4027_@>array[9,10] then concat('11:20 - 12:00', '\n') 
when o.attr_4027_@>array[9] and o.attr_4027_@>array[10]<>true then concat('11:20 - 11:40', '\n')
when o.attr_4027_@>array[10] and o.attr_4027_@>array[9]<>true then concat('11:40 - 12:00', '\n')
 end,
case
when o.attr_4027_@>array[11,12] then concat('13:00 - 13:40', '\n') 
when o.attr_4027_@>array[11] and o.attr_4027_@>array[12]<>true then concat('13:00 - 13:20', '\n')
when o.attr_4027_@>array[12] and o.attr_4027_@>array[11]<>true then concat('13:20 - 13:40', '\n')
 end,
case
when o.attr_4027_@>array[13,14] then concat('13:50 - 14:30', '\n') 
when o.attr_4027_@>array[13] and o.attr_4027_@>array[14]<>true then concat('13:50 - 14:10', '\n')
when o.attr_4027_@>array[14] and o.attr_4027_@>array[13]<>true then concat('14:10 - 14:30', '\n')
 end,
case
when o.attr_4027_@>array[15,16] then concat('14:40 - 15:20', '\n') 
when o.attr_4027_@>array[15] and o.attr_4027_@>array[16]<>true then concat('14:40 - 15:00', '\n')
when o.attr_4027_@>array[16] and o.attr_4027_@>array[15]<>true then concat('15:00 - 15:20', '\n')
 end,
case
when o.attr_4027_@>array[17,18] then concat('15:30 - 16:10', '\n') 
when o.attr_4027_@>array[17] and o.attr_4027_@>array[18]<>true then concat('15:30 - 15:50', '\n')
when o.attr_4027_@>array[18] and o.attr_4027_@>array[17]<>true then concat('15:50 - 16:10', '\n')
 end,
case
when o.attr_4027_@>array[19,20] then concat('16:20 - 17:00', '\n') 
when o.attr_4027_@>array[19] and o.attr_4027_@>array[20]<>true then concat('16:20 - 16:40', '\n')
when o.attr_4027_@>array[20] and o.attr_4027_@>array[19]<>true then concat('16:40 - 17:00', '\n')
end,
case
when o.attr_4027_@>array[21,22] then concat('17:00 - 17:40', '\n') 
when o.attr_4027_@>array[21] and o.attr_4027_@>array[22]<>true then concat('17:00 - 17:20', '\n')
when o.attr_4027_@>array[22] and o.attr_4027_@>array[21]<>true then concat('17:20 - 17:40', '\n')
end,
case
when o.attr_4027_@>array[23,24] then concat('17:40 - 18:20', '\n') 
when o.attr_4027_@>array[23] and o.attr_4027_@>array[24]<>true then concat('17:40 - 18:00', '\n')
when o.attr_4027_@>array[24] and o.attr_4027_@>array[23]<>true then concat('18:00 - 18:20', '\n')
end,
case
when o.attr_4027_@>array[25,26] then concat('18:20 - 19:00', '\n') 
when o.attr_4027_@>array[25] and o.attr_4027_@>array[26]<>true then concat('18:20 - 18:40', '\n')
when o.attr_4027_@>array[26] and o.attr_4027_@>array[25]<>true then concat('18:40 - 19:00', '\n')
end) as time_proc

from o
left join registry.object_783_ pl on o.attr_4028_=pl.id and pl.is_deleted<>true
left join registry.object_694_ proc_id on pl.attr_784_=proc_id.id and proc_id.is_deleted<>true
where o.attr_4027_ is not null 

union all

select o.attr_1985_ as fio, proc_id.attr_695_ as proc, o.attr_444_ as nom, o.attr_4005_ as hist_id,

concat(
case 
when o.attr_4029_@>array[2,3] and o.attr_4029_@>array[4]<>true then concat('08:30 - 09:10', '\n')
when o.attr_4029_@>array[3,4] and o.attr_4029_@>array[2]<>true then concat('08:50 - 09:30', '\n')
else concat(
case when o.attr_4029_@>array[2] then concat('08:30 - 08:50', '\n')  end,
case when o.attr_4029_@>array[3] then concat('08:50 - 09:10', '\n')  end,
case when o.attr_4029_@>array[4] then concat('09:10 - 09:30', '\n')  end)
end, 
case 
when o.attr_4029_@>array[5,6] then concat('09:40 - 10:20', '\n')
when o.attr_4029_@>array[5] and o.attr_4029_@>array[6]<>true then concat('09:40 - 10:00', '\n')
when o.attr_4029_@>array[6] and o.attr_4029_@>array[5]<>true then concat('10:00 - 10:20', '\n')
 end,
case
when o.attr_4029_@>array[7,8] then concat('10:30 - 11:10', '\n') 
when o.attr_4029_@>array[7] and o.attr_4029_@>array[8]<>true then concat('10:30 - 10:50', '\n')
when o.attr_4029_@>array[8] and o.attr_4029_@>array[7]<>true then concat('10:50 - 11:10', '\n')
 end,
case
when o.attr_4029_@>array[9,10] then concat('11:20 - 12:00', '\n') 
when o.attr_4029_@>array[9] and o.attr_4029_@>array[10]<>true then concat('11:20 - 11:40', '\n')
when o.attr_4029_@>array[10] and o.attr_4029_@>array[9]<>true then concat('11:40 - 12:00', '\n')
 end,
case
when o.attr_4029_@>array[11,12] then concat('13:00 - 13:40', '\n') 
when o.attr_4029_@>array[11] and o.attr_4029_@>array[12]<>true then concat('13:00 - 13:20', '\n')
when o.attr_4029_@>array[12] and o.attr_4029_@>array[11]<>true then concat('13:20 - 13:40', '\n')
 end,
case
when o.attr_4029_@>array[13,14] then concat('13:50 - 14:30', '\n') 
when o.attr_4029_@>array[13] and o.attr_4029_@>array[14]<>true then concat('13:50 - 14:10', '\n')
when o.attr_4029_@>array[14] and o.attr_4029_@>array[13]<>true then concat('14:10 - 14:30', '\n')
 end,
case
when o.attr_4029_@>array[15,16] then concat('14:40 - 15:20', '\n') 
when o.attr_4029_@>array[15] and o.attr_4029_@>array[16]<>true then concat('14:40 - 15:00', '\n')
when o.attr_4029_@>array[16] and o.attr_4029_@>array[15]<>true then concat('15:00 - 15:20', '\n')
 end,
case
when o.attr_4029_@>array[17,18] then concat('15:30 - 16:10', '\n') 
when o.attr_4029_@>array[17] and o.attr_4029_@>array[18]<>true then concat('15:30 - 15:50', '\n')
when o.attr_4029_@>array[18] and o.attr_4029_@>array[17]<>true then concat('15:50 - 16:10', '\n')
 end,
case
when o.attr_4029_@>array[19,20] then concat('16:20 - 17:00', '\n') 
when o.attr_4029_@>array[19] and o.attr_4029_@>array[20]<>true then concat('16:20 - 16:40', '\n')
when o.attr_4029_@>array[20] and o.attr_4029_@>array[19]<>true then concat('16:40 - 17:00', '\n')
 end,
case
when o.attr_4029_@>array[21,22] then concat('17:00 - 17:40', '\n') 
when o.attr_4029_@>array[21] and o.attr_4029_@>array[22]<>true then concat('17:00 - 17:20', '\n')
when o.attr_4029_@>array[22] and o.attr_4029_@>array[21]<>true then concat('17:20 - 17:40', '\n')
end,
case
when o.attr_4029_@>array[23,24] then concat('17:40 - 18:20', '\n') 
when o.attr_4029_@>array[23] and o.attr_4029_@>array[24]<>true then concat('17:40 - 18:00', '\n')
when o.attr_4029_@>array[24] and o.attr_4029_@>array[23]<>true then concat('18:00 - 18:20', '\n')
end,
case
when o.attr_4029_@>array[25,26] then concat('18:20 - 19:00', '\n') 
when o.attr_4029_@>array[25] and o.attr_4029_@>array[26]<>true then concat('18:20 - 18:40', '\n')
when o.attr_4029_@>array[26] and o.attr_4029_@>array[25]<>true then concat('18:40 - 19:00', '\n')
end) as time_proc

from o
left join registry.object_783_ pl on o.attr_4030_=pl.id and pl.is_deleted<>true
left join registry.object_694_ proc_id on pl.attr_784_=proc_id.id and proc_id.is_deleted<>true
where o.attr_4029_ is not null 

union all

select o.attr_1985_ as fio, proc_id.attr_695_ as proc, o.attr_444_ as nom, o.attr_4005_ as hist_id,

concat(
case 
when o.attr_4162_@>array[2,3] and o.attr_4162_@>array[4]<>true then concat('08:30 - 09:10', '\n')
when o.attr_4162_@>array[3,4] and o.attr_4162_@>array[2]<>true then concat('08:50 - 09:30', '\n')
else concat(
case when o.attr_4162_@>array[2] then concat('08:30 - 08:50', '\n') end,
case when o.attr_4162_@>array[3] then concat('08:50 - 09:10', '\n') end,
case when o.attr_4162_@>array[4] then concat('09:10 - 09:30', '\n') end)
end, 
case 
when o.attr_4162_@>array[5,6] then concat('09:40 - 10:20', '\n')
when o.attr_4162_@>array[5] and o.attr_4162_@>array[6]<>true then concat('09:40 - 10:00', '\n')
when o.attr_4162_@>array[6] and o.attr_4162_@>array[5]<>true then concat('10:00 - 10:20', '\n') end,
case
when o.attr_4162_@>array[7,8] then concat('10:30 - 11:10', '\n') 
when o.attr_4162_@>array[7] and o.attr_4162_@>array[8]<>true then concat('10:30 - 10:50', '\n')
when o.attr_4162_@>array[8] and o.attr_4162_@>array[7]<>true then concat('10:50 - 11:10', '\n') end,
case
when o.attr_4162_@>array[9,10] then concat('11:20 - 12:00', '\n') 
when o.attr_4162_@>array[9] and o.attr_4162_@>array[10]<>true then concat('11:20 - 11:40', '\n')
when o.attr_4162_@>array[10] and o.attr_4162_@>array[9]<>true then concat('11:40 - 12:00', '\n') end,
case
when o.attr_4162_@>array[11,12] then concat('13:00 - 13:40', '\n') 
when o.attr_4162_@>array[11] and o.attr_4162_@>array[12]<>true then concat('13:00 - 13:20', '\n')
when o.attr_4162_@>array[12] and o.attr_4162_@>array[11]<>true then concat('13:20 - 13:40', '\n')
end,
case
when o.attr_4162_@>array[13,14] then concat('13:50 - 14:30', '\n') 
when o.attr_4162_@>array[13] and o.attr_4162_@>array[14]<>true then concat('13:50 - 14:10', '\n')
when o.attr_4162_@>array[14] and o.attr_4162_@>array[13]<>true then concat('14:10 - 14:30', '\n')
end,
case
when o.attr_4162_@>array[15,16] then concat('14:40 - 15:20', '\n') 
when o.attr_4162_@>array[15] and o.attr_4162_@>array[16]<>true then concat('14:40 - 15:00', '\n')
when o.attr_4162_@>array[16] and o.attr_4162_@>array[15]<>true then concat('15:00 - 15:20', '\n')
end,
case
when o.attr_4162_@>array[17,18] then concat('15:30 - 16:10', '\n') 
when o.attr_4162_@>array[17] and o.attr_4162_@>array[18]<>true then concat('15:30 - 15:50', '\n')
when o.attr_4162_@>array[18] and o.attr_4162_@>array[17]<>true then concat('15:50 - 16:10', '\n')
end,
case
when o.attr_4162_@>array[19,20] then concat('16:20 - 17:00', '\n') 
when o.attr_4162_@>array[19] and o.attr_4162_@>array[20]<>true then concat('16:20 - 16:40', '\n')
when o.attr_4162_@>array[20] and o.attr_4162_@>array[19]<>true then concat('16:40 - 17:00', '\n')
end,
case
when o.attr_4162_@>array[21,22] then concat('17:00 - 17:40', '\n') 
when o.attr_4162_@>array[21] and o.attr_4162_@>array[22]<>true then concat('17:00 - 17:20', '\n')
when o.attr_4162_@>array[22] and o.attr_4162_@>array[21]<>true then concat('17:20 - 17:40', '\n')
end,
case
when o.attr_4162_@>array[23,24] then concat('17:40 - 18:20', '\n') 
when o.attr_4162_@>array[23] and o.attr_4162_@>array[24]<>true then concat('17:40 - 18:00', '\n')
when o.attr_4162_@>array[24] and o.attr_4162_@>array[23]<>true then concat('18:00 - 18:20', '\n')
end,
case
when o.attr_4162_@>array[25,26] then concat('18:20 - 19:00', '\n') 
when o.attr_4162_@>array[25] and o.attr_4162_@>array[26]<>true then concat('18:20 - 18:40', '\n')
when o.attr_4162_@>array[26] and o.attr_4162_@>array[25]<>true then concat('18:40 - 19:00', '\n')
end) as time_proc

from o
left join registry.object_783_ pl on o.attr_4163_=pl.id and pl.is_deleted<>true
left join registry.object_694_ proc_id on pl.attr_784_=proc_id.id and proc_id.is_deleted<>true
where o.attr_4162_ is not null

union all

select o.attr_1985_ as fio, proc_id.attr_695_ as proc, o.attr_444_ as nom, o.attr_4005_ as hist_id,

concat(
case 
when o.attr_4165_@>array[2,3] and o.attr_4165_@>array[4]<>true then concat('08:30 - 09:10', '\n')
when o.attr_4165_@>array[3,4] and o.attr_4165_@>array[2]<>true then concat('08:50 - 09:30', '\n')
else concat(
case when o.attr_4165_@>array[2] then concat('08:30 - 08:50', '\n') end,
case when o.attr_4165_@>array[3] then concat('08:50 - 09:10', '\n') end,
case when o.attr_4165_@>array[4] then concat('09:10 - 09:30', '\n') end)
end, 
case 
when o.attr_4165_@>array[5,6] then concat('09:40 - 10:20', '\n')
when o.attr_4165_@>array[5] and o.attr_4165_@>array[6]<>true then concat('09:40 - 10:00', '\n')
when o.attr_4165_@>array[6] and o.attr_4165_@>array[5]<>true then concat('10:00 - 10:20', '\n') end,
case
when o.attr_4165_@>array[7,8] then concat('10:30 - 11:10', '\n') 
when o.attr_4165_@>array[7] and o.attr_4165_@>array[8]<>true then concat('10:30 - 10:50', '\n')
when o.attr_4165_@>array[8] and o.attr_4165_@>array[7]<>true then concat('10:50 - 11:10', '\n') end,
case
when o.attr_4165_@>array[9,10] then concat('11:20 - 12:00', '\n') 
when o.attr_4165_@>array[9] and o.attr_4165_@>array[10]<>true then concat('11:20 - 11:40', '\n')
when o.attr_4165_@>array[10] and o.attr_4165_@>array[9]<>true then concat('11:40 - 12:00', '\n') end,
case
when o.attr_4165_@>array[11,12] then concat('13:00 - 13:40', '\n') 
when o.attr_4165_@>array[11] and o.attr_4165_@>array[12]<>true then concat('13:00 - 13:20', '\n')
when o.attr_4165_@>array[12] and o.attr_4165_@>array[11]<>true then concat('13:20 - 13:40', '\n')
end,
case
when o.attr_4165_@>array[13,14] then concat('13:50 - 14:30', '\n') 
when o.attr_4165_@>array[13] and o.attr_4165_@>array[14]<>true then concat('13:50 - 14:10', '\n')
when o.attr_4165_@>array[14] and o.attr_4165_@>array[13]<>true then concat('14:10 - 14:30', '\n')
end,
case
when o.attr_4165_@>array[15,16] then concat('14:40 - 15:20', '\n') 
when o.attr_4165_@>array[15] and o.attr_4165_@>array[16]<>true then concat('14:40 - 15:00', '\n')
when o.attr_4165_@>array[16] and o.attr_4165_@>array[15]<>true then concat('15:00 - 15:20', '\n')
end,
case
when o.attr_4165_@>array[17,18] then concat('15:30 - 16:10', '\n') 
when o.attr_4165_@>array[17] and o.attr_4165_@>array[18]<>true then concat('15:30 - 15:50', '\n')
when o.attr_4165_@>array[18] and o.attr_4165_@>array[17]<>true then concat('15:50 - 16:10', '\n')
end,
case
when o.attr_4165_@>array[19,20] then concat('16:20 - 17:00', '\n') 
when o.attr_4165_@>array[19] and o.attr_4165_@>array[20]<>true then concat('16:20 - 16:40', '\n')
when o.attr_4165_@>array[20] and o.attr_4165_@>array[19]<>true then concat('16:40 - 17:00', '\n')
end,
case
when o.attr_4165_@>array[21,22] then concat('17:00 - 17:40', '\n') 
when o.attr_4165_@>array[21] and o.attr_4165_@>array[22]<>true then concat('17:00 - 17:20', '\n')
when o.attr_4165_@>array[22] and o.attr_4165_@>array[21]<>true then concat('17:20 - 17:40', '\n')
end,
case
when o.attr_4165_@>array[23,24] then concat('17:40 - 18:20', '\n') 
when o.attr_4165_@>array[23] and o.attr_4165_@>array[24]<>true then concat('17:40 - 18:00', '\n')
when o.attr_4165_@>array[24] and o.attr_4165_@>array[23]<>true then concat('18:00 - 18:20', '\n')
end,
case
when o.attr_4165_@>array[25,26] then concat('18:20 - 19:00', '\n') 
when o.attr_4165_@>array[25] and o.attr_4165_@>array[26]<>true then concat('18:20 - 18:40', '\n')
when o.attr_4165_@>array[26] and o.attr_4165_@>array[25]<>true then concat('18:40 - 19:00', '\n')
end) as time_proc

from o
left join registry.object_783_ pl on o.attr_4166_=pl.id and pl.is_deleted<>true
left join registry.object_694_ proc_id on pl.attr_784_=proc_id.id and proc_id.is_deleted<>true
where o.attr_4165_ is not null

union all 

select o.attr_1985_ as fio, proc_id.attr_695_ as proc, o.attr_444_ as nom, o.attr_4005_ as hist_id,

concat(
case 
when o.attr_4168_@>array[2,3] and o.attr_4168_@>array[4]<>true then concat('08:30 - 09:10', '\n')
when o.attr_4168_@>array[3,4] and o.attr_4168_@>array[2]<>true then concat('08:50 - 09:30', '\n')
else concat(
case when o.attr_4168_@>array[2] then concat('08:30 - 08:50', '\n') end,
case when o.attr_4168_@>array[3] then concat('08:50 - 09:10', '\n') end,
case when o.attr_4168_@>array[4] then concat('09:10 - 09:30', '\n') end)
end, 
case 
when o.attr_4168_@>array[5,6] then concat('09:40 - 10:20', '\n')
when o.attr_4168_@>array[5] and o.attr_4168_@>array[6]<>true then concat('09:40 - 10:00', '\n')
when o.attr_4168_@>array[6] and o.attr_4168_@>array[5]<>true then concat('10:00 - 10:20', '\n') end,
case
when o.attr_4168_@>array[7,8] then concat('10:30 - 11:10', '\n') 
when o.attr_4168_@>array[7] and o.attr_4168_@>array[8]<>true then concat('10:30 - 10:50', '\n')
when o.attr_4168_@>array[8] and o.attr_4168_@>array[7]<>true then concat('10:50 - 11:10', '\n') end,
case
when o.attr_4168_@>array[9,10] then concat('11:20 - 12:00', '\n') 
when o.attr_4168_@>array[9] and o.attr_4168_@>array[10]<>true then concat('11:20 - 11:40', '\n')
when o.attr_4168_@>array[10] and o.attr_4168_@>array[9]<>true then concat('11:40 - 12:00', '\n') end,
case
when o.attr_4168_@>array[11,12] then concat('13:00 - 13:40', '\n') 
when o.attr_4168_@>array[11] and o.attr_4168_@>array[12]<>true then concat('13:00 - 13:20', '\n')
when o.attr_4168_@>array[12] and o.attr_4168_@>array[11]<>true then concat('13:20 - 13:40', '\n')
end,
case
when o.attr_4168_@>array[13,14] then concat('13:50 - 14:30', '\n') 
when o.attr_4168_@>array[13] and o.attr_4168_@>array[14]<>true then concat('13:50 - 14:10', '\n')
when o.attr_4168_@>array[14] and o.attr_4168_@>array[13]<>true then concat('14:10 - 14:30', '\n')
end,
case
when o.attr_4168_@>array[15,16] then concat('14:40 - 15:20', '\n') 
when o.attr_4168_@>array[15] and o.attr_4168_@>array[16]<>true then concat('14:40 - 15:00', '\n')
when o.attr_4168_@>array[16] and o.attr_4168_@>array[15]<>true then concat('15:00 - 15:20', '\n')
end,
case
when o.attr_4168_@>array[17,18] then concat('15:30 - 16:10', '\n') 
when o.attr_4168_@>array[17] and o.attr_4168_@>array[18]<>true then concat('15:30 - 15:50', '\n')
when o.attr_4168_@>array[18] and o.attr_4168_@>array[17]<>true then concat('15:50 - 16:10', '\n')
end,
case
when o.attr_4168_@>array[19,20] then concat('16:20 - 17:00', '\n') 
when o.attr_4168_@>array[19] and o.attr_4168_@>array[20]<>true then concat('16:20 - 16:40', '\n')
when o.attr_4168_@>array[20] and o.attr_4168_@>array[19]<>true then concat('16:40 - 17:00', '\n')
end,
case
when o.attr_4168_@>array[21,22] then concat('17:00 - 17:40', '\n') 
when o.attr_4168_@>array[21] and o.attr_4168_@>array[22]<>true then concat('17:00 - 17:20', '\n')
when o.attr_4168_@>array[22] and o.attr_4168_@>array[21]<>true then concat('17:20 - 17:40', '\n')
end,
case
when o.attr_4168_@>array[23,24] then concat('17:40 - 18:20', '\n') 
when o.attr_4168_@>array[23] and o.attr_4168_@>array[24]<>true then concat('17:40 - 18:00', '\n')
when o.attr_4168_@>array[24] and o.attr_4168_@>array[23]<>true then concat('18:00 - 18:20', '\n')
end,
case
when o.attr_4168_@>array[25,26] then concat('18:20 - 19:00', '\n') 
when o.attr_4168_@>array[25] and o.attr_4168_@>array[26]<>true then concat('18:20 - 18:40', '\n')
when o.attr_4168_@>array[26] and o.attr_4168_@>array[25]<>true then concat('18:40 - 19:00', '\n')
end) as time_proc

from o
left join registry.object_783_ pl on o.attr_4169_=pl.id and pl.is_deleted<>true
left join registry.object_694_ proc_id on pl.attr_784_=proc_id.id and proc_id.is_deleted<>true
where o.attr_4168_ is not null

union all

select o.attr_1985_ as fio, proc_id.attr_695_ as proc, o.attr_444_ as nom, o.attr_4005_ as hist_id,

concat(
case 
when o.attr_4251_@>array[2,3] and o.attr_4251_@>array[4]<>true then concat('08:30 - 09:10', '\n')
when o.attr_4251_@>array[3,4] and o.attr_4251_@>array[2]<>true then concat('08:50 - 09:30', '\n')
else concat(
case when o.attr_4251_@>array[2] then concat('08:30 - 08:50', '\n') end,
case when o.attr_4251_@>array[3] then concat('08:50 - 09:10', '\n') end,
case when o.attr_4251_@>array[4] then concat('09:10 - 09:30', '\n') end)
end, 
case 
when o.attr_4251_@>array[5,6] then concat('09:40 - 10:20', '\n')
when o.attr_4251_@>array[5] and o.attr_4251_@>array[6]<>true then concat('09:40 - 10:00', '\n')
when o.attr_4251_@>array[6] and o.attr_4251_@>array[5]<>true then concat('10:00 - 10:20', '\n') end,
case
when o.attr_4251_@>array[7,8] then concat('10:30 - 11:10', '\n') 
when o.attr_4251_@>array[7] and o.attr_4251_@>array[8]<>true then concat('10:30 - 10:50', '\n')
when o.attr_4251_@>array[8] and o.attr_4251_@>array[7]<>true then concat('10:50 - 11:10', '\n') end,
case
when o.attr_4251_@>array[9,10] then concat('11:20 - 12:00', '\n') 
when o.attr_4251_@>array[9] and o.attr_4251_@>array[10]<>true then concat('11:20 - 11:40', '\n')
when o.attr_4251_@>array[10] and o.attr_4251_@>array[9]<>true then concat('11:40 - 12:00', '\n') end,
case
when o.attr_4251_@>array[11,12] then concat('13:00 - 13:40', '\n') 
when o.attr_4251_@>array[11] and o.attr_4251_@>array[12]<>true then concat('13:00 - 13:20', '\n')
when o.attr_4251_@>array[12] and o.attr_4251_@>array[11]<>true then concat('13:20 - 13:40', '\n')
end,
case
when o.attr_4251_@>array[13,14] then concat('13:50 - 14:30', '\n') 
when o.attr_4251_@>array[13] and o.attr_4251_@>array[14]<>true then concat('13:50 - 14:10', '\n')
when o.attr_4251_@>array[14] and o.attr_4251_@>array[13]<>true then concat('14:10 - 14:30', '\n')
end,
case
when o.attr_4251_@>array[15,16] then concat('14:40 - 15:20', '\n') 
when o.attr_4251_@>array[15] and o.attr_4251_@>array[16]<>true then concat('14:40 - 15:00', '\n')
when o.attr_4251_@>array[16] and o.attr_4251_@>array[15]<>true then concat('15:00 - 15:20', '\n')
end,
case
when o.attr_4251_@>array[17,18] then concat('15:30 - 16:10', '\n') 
when o.attr_4251_@>array[17] and o.attr_4251_@>array[18]<>true then concat('15:30 - 15:50', '\n')
when o.attr_4251_@>array[18] and o.attr_4251_@>array[17]<>true then concat('15:50 - 16:10', '\n')
end,
case
when o.attr_4251_@>array[19,20] then concat('16:20 - 17:00', '\n') 
when o.attr_4251_@>array[19] and o.attr_4251_@>array[20]<>true then concat('16:20 - 16:40', '\n')
when o.attr_4251_@>array[20] and o.attr_4251_@>array[19]<>true then concat('16:40 - 17:00', '\n')
end,
case
when o.attr_4251_@>array[21,22] then concat('17:00 - 17:40', '\n') 
when o.attr_4251_@>array[21] and o.attr_4251_@>array[22]<>true then concat('17:00 - 17:20', '\n')
when o.attr_4251_@>array[22] and o.attr_4251_@>array[21]<>true then concat('17:20 - 17:40', '\n')
end,
case
when o.attr_4251_@>array[23,24] then concat('17:40 - 18:20', '\n') 
when o.attr_4251_@>array[23] and o.attr_4251_@>array[24]<>true then concat('17:40 - 18:00', '\n')
when o.attr_4251_@>array[24] and o.attr_4251_@>array[23]<>true then concat('18:00 - 18:20', '\n')
end,
case
when o.attr_4251_@>array[25,26] then concat('18:20 - 19:00', '\n') 
when o.attr_4251_@>array[25] and o.attr_4251_@>array[26]<>true then concat('18:20 - 18:40', '\n')
when o.attr_4251_@>array[26] and o.attr_4251_@>array[25]<>true then concat('18:40 - 19:00', '\n')
end) as time_proc

from o
left join registry.object_783_ pl on o.attr_4252_=pl.id and pl.is_deleted<>true
left join registry.object_694_ proc_id on pl.attr_784_=proc_id.id and proc_id.is_deleted<>true
where o.attr_4251_ is not null

union all

select o.attr_1985_ as fio, proc_id.attr_695_ as proc, o.attr_444_ as nom, o.attr_4005_ as hist_id,

concat(
case 
when o.attr_4443_@>array[2,3] and o.attr_4443_@>array[4]<>true then concat('08:30 - 09:10', '\n')
when o.attr_4443_@>array[3,4] and o.attr_4443_@>array[2]<>true then concat('08:50 - 09:30', '\n')
else concat(
case when o.attr_4443_@>array[2] then concat('08:30 - 08:50', '\n') end,
case when o.attr_4443_@>array[3] then concat('08:50 - 09:10', '\n') end,
case when o.attr_4443_@>array[4] then concat('09:10 - 09:30', '\n') end)
end, 
case 
when o.attr_4443_@>array[5,6] then concat('09:40 - 10:20', '\n')
when o.attr_4443_@>array[5] and o.attr_4443_@>array[6]<>true then concat('09:40 - 10:00', '\n')
when o.attr_4443_@>array[6] and o.attr_4443_@>array[5]<>true then concat('10:00 - 10:20', '\n') end,
case
when o.attr_4443_@>array[7,8] then concat('10:30 - 11:10', '\n') 
when o.attr_4443_@>array[7] and o.attr_4443_@>array[8]<>true then concat('10:30 - 10:50', '\n')
when o.attr_4443_@>array[8] and o.attr_4443_@>array[7]<>true then concat('10:50 - 11:10', '\n') end,
case
when o.attr_4443_@>array[9,10] then concat('11:20 - 12:00', '\n') 
when o.attr_4443_@>array[9] and o.attr_4443_@>array[10]<>true then concat('11:20 - 11:40', '\n')
when o.attr_4443_@>array[10] and o.attr_4443_@>array[9]<>true then concat('11:40 - 12:00', '\n') end,
case
when o.attr_4443_@>array[11,12] then concat('13:00 - 13:40', '\n') 
when o.attr_4443_@>array[11] and o.attr_4443_@>array[12]<>true then concat('13:00 - 13:20', '\n')
when o.attr_4443_@>array[12] and o.attr_4443_@>array[11]<>true then concat('13:20 - 13:40', '\n')
end,
case
when o.attr_4443_@>array[13,14] then concat('13:50 - 14:30', '\n') 
when o.attr_4443_@>array[13] and o.attr_4443_@>array[14]<>true then concat('13:50 - 14:10', '\n')
when o.attr_4443_@>array[14] and o.attr_4443_@>array[13]<>true then concat('14:10 - 14:30', '\n')
end,
case
when o.attr_4443_@>array[15,16] then concat('14:40 - 15:20', '\n') 
when o.attr_4443_@>array[15] and o.attr_4443_@>array[16]<>true then concat('14:40 - 15:00', '\n')
when o.attr_4443_@>array[16] and o.attr_4443_@>array[15]<>true then concat('15:00 - 15:20', '\n')
end,
case
when o.attr_4443_@>array[17,18] then concat('15:30 - 16:10', '\n') 
when o.attr_4443_@>array[17] and o.attr_4443_@>array[18]<>true then concat('15:30 - 15:50', '\n')
when o.attr_4443_@>array[18] and o.attr_4443_@>array[17]<>true then concat('15:50 - 16:10', '\n')
end,
case
when o.attr_4443_@>array[19,20] then concat('16:20 - 17:00', '\n') 
when o.attr_4443_@>array[19] and o.attr_4443_@>array[20]<>true then concat('16:20 - 16:40', '\n')
when o.attr_4443_@>array[20] and o.attr_4443_@>array[19]<>true then concat('16:40 - 17:00', '\n')
end,
case
when o.attr_4443_@>array[21,22] then concat('17:00 - 17:40', '\n') 
when o.attr_4443_@>array[21] and o.attr_4443_@>array[22]<>true then concat('17:00 - 17:20', '\n')
when o.attr_4443_@>array[22] and o.attr_4443_@>array[21]<>true then concat('17:20 - 17:40', '\n')
end,
case
when o.attr_4443_@>array[23,24] then concat('17:40 - 18:20', '\n') 
when o.attr_4443_@>array[23] and o.attr_4443_@>array[24]<>true then concat('17:40 - 18:00', '\n')
when o.attr_4443_@>array[24] and o.attr_4443_@>array[23]<>true then concat('18:00 - 18:20', '\n')
end,
case
when o.attr_4443_@>array[25,26] then concat('18:20 - 19:00', '\n') 
when o.attr_4443_@>array[25] and o.attr_4443_@>array[26]<>true then concat('18:20 - 18:40', '\n')
when o.attr_4443_@>array[26] and o.attr_4443_@>array[25]<>true then concat('18:40 - 19:00', '\n')
end) as time_proc

from o
left join registry.object_783_ pl on o.attr_4444_=pl.id and pl.is_deleted<>true
left join registry.object_694_ proc_id on pl.attr_784_=proc_id.id and proc_id.is_deleted<>true
where o.attr_4443_ is not null

union all

select o.attr_1985_ as fio, proc_id.attr_695_ as proc, o.attr_444_ as nom, o.attr_4005_ as hist_id,

concat(
case 
when o.attr_4446_@>array[2,3] and o.attr_4446_@>array[4]<>true then concat('08:30 - 09:10', '\n')
when o.attr_4446_@>array[3,4] and o.attr_4446_@>array[2]<>true then concat('08:50 - 09:30', '\n')
else concat(
case when o.attr_4446_@>array[2] then concat('08:30 - 08:50', '\n') end,
case when o.attr_4446_@>array[3] then concat('08:50 - 09:10', '\n') end,
case when o.attr_4446_@>array[4] then concat('09:10 - 09:30', '\n') end)
end, 
case 
when o.attr_4446_@>array[5,6] then concat('09:40 - 10:20', '\n')
when o.attr_4446_@>array[5] and o.attr_4446_@>array[6]<>true then concat('09:40 - 10:00', '\n')
when o.attr_4446_@>array[6] and o.attr_4446_@>array[5]<>true then concat('10:00 - 10:20', '\n') end,
case
when o.attr_4446_@>array[7,8] then concat('10:30 - 11:10', '\n') 
when o.attr_4446_@>array[7] and o.attr_4446_@>array[8]<>true then concat('10:30 - 10:50', '\n')
when o.attr_4446_@>array[8] and o.attr_4446_@>array[7]<>true then concat('10:50 - 11:10', '\n') end,
case
when o.attr_4446_@>array[9,10] then concat('11:20 - 12:00', '\n') 
when o.attr_4446_@>array[9] and o.attr_4446_@>array[10]<>true then concat('11:20 - 11:40', '\n')
when o.attr_4446_@>array[10] and o.attr_4446_@>array[9]<>true then concat('11:40 - 12:00', '\n') end,
case
when o.attr_4446_@>array[11,12] then concat('13:00 - 13:40', '\n') 
when o.attr_4446_@>array[11] and o.attr_4446_@>array[12]<>true then concat('13:00 - 13:20', '\n')
when o.attr_4446_@>array[12] and o.attr_4446_@>array[11]<>true then concat('13:20 - 13:40', '\n')
end,
case
when o.attr_4446_@>array[13,14] then concat('13:50 - 14:30', '\n') 
when o.attr_4446_@>array[13] and o.attr_4446_@>array[14]<>true then concat('13:50 - 14:10', '\n')
when o.attr_4446_@>array[14] and o.attr_4446_@>array[13]<>true then concat('14:10 - 14:30', '\n')
end,
case
when o.attr_4446_@>array[15,16] then concat('14:40 - 15:20', '\n') 
when o.attr_4446_@>array[15] and o.attr_4446_@>array[16]<>true then concat('14:40 - 15:00', '\n')
when o.attr_4446_@>array[16] and o.attr_4446_@>array[15]<>true then concat('15:00 - 15:20', '\n')
end,
case
when o.attr_4446_@>array[17,18] then concat('15:30 - 16:10', '\n') 
when o.attr_4446_@>array[17] and o.attr_4446_@>array[18]<>true then concat('15:30 - 15:50', '\n')
when o.attr_4446_@>array[18] and o.attr_4446_@>array[17]<>true then concat('15:50 - 16:10', '\n')
end,
case
when o.attr_4446_@>array[19,20] then concat('16:20 - 17:00', '\n') 
when o.attr_4446_@>array[19] and o.attr_4446_@>array[20]<>true then concat('16:20 - 16:40', '\n')
when o.attr_4446_@>array[20] and o.attr_4446_@>array[19]<>true then concat('16:40 - 17:00', '\n')
end,
case
when o.attr_4446_@>array[21,22] then concat('17:00 - 17:40', '\n') 
when o.attr_4446_@>array[21] and o.attr_4446_@>array[22]<>true then concat('17:00 - 17:20', '\n')
when o.attr_4446_@>array[22] and o.attr_4446_@>array[21]<>true then concat('17:20 - 17:40', '\n')
end,
case
when o.attr_4446_@>array[23,24] then concat('17:40 - 18:20', '\n') 
when o.attr_4446_@>array[23] and o.attr_4446_@>array[24]<>true then concat('17:40 - 18:00', '\n')
when o.attr_4446_@>array[24] and o.attr_4446_@>array[23]<>true then concat('18:00 - 18:20', '\n')
end,
case
when o.attr_4446_@>array[25,26] then concat('18:20 - 19:00', '\n') 
when o.attr_4446_@>array[25] and o.attr_4446_@>array[26]<>true then concat('18:20 - 18:40', '\n')
when o.attr_4446_@>array[26] and o.attr_4446_@>array[25]<>true then concat('18:40 - 19:00', '\n')
end) as time_proc

from o
left join registry.object_783_ pl on o.attr_4447_=pl.id and pl.is_deleted<>true
left join registry.object_694_ proc_id on pl.attr_784_=proc_id.id and proc_id.is_deleted<>true
where o.attr_4446_ is not null) o1

where o1.proc is not null
order by o1.fio