/*Полное расписание на день по новому расписанию*/
select
concat(case when o.attr_4007_&&array[1] then null
else concat(
case 
when o.attr_4007_@>array[2,3] and o.attr_4007_@>array[4]<>true then '08:30 - 09:10 '
when o.attr_4007_@>array[3,4] and o.attr_4007_@>array[2]<>true then '08:50 - 09:30 '
else concat(
case when o.attr_4007_@>array[2] then '08:30 - 08:50 ' else null end,
case when o.attr_4007_@>array[3] then '08:50 - 09:10 ' else null end,
case when o.attr_4007_@>array[4] then '09:10 - 09:30 ' else null end)
end, 

case 
when o.attr_4007_@>array[5,6] then '09:40-10:20 '
when o.attr_4007_@>array[5] and o.attr_4007_@>array[6]<>true then '09:40 - 10:00 '
when o.attr_4007_@>array[6] and o.attr_4007_@>array[5]<>true then '10:00 - 10:20 '
else null end,

case
when o.attr_4007_@>array[7,8] then '10:30 - 11:10 ' 
when o.attr_4007_@>array[7] and o.attr_4007_@>array[8]<>true then '10:30 - 10:50 '
when o.attr_4007_@>array[8] and o.attr_4007_@>array[7]<>true then '10:50 - 11:10 '
else null end,

case
when o.attr_4007_@>array[9,10] then '11:20 - 12:00 ' 
when o.attr_4007_@>array[9] and o.attr_4007_@>array[10]<>true then '11:20 - 11:40 '
when o.attr_4007_@>array[10] and o.attr_4007_@>array[9]<>true then '11:40 - 12:00 '
else null end,

case
when o.attr_4007_@>array[11,12] then '13:00 - 13:40 ' 
when o.attr_4007_@>array[11] and o.attr_4007_@>array[12]<>true then '13:00 - 13:20 '
when o.attr_4007_@>array[12] and o.attr_4007_@>array[11]<>true then '13:20 - 13:40 '
else null end,

case
when o.attr_4007_@>array[13,14] then '13:50 - 14:30 ' 
when o.attr_4007_@>array[13] and o.attr_4007_@>array[14]<>true then '13:50 - 14:10 '
when o.attr_4007_@>array[14] and o.attr_4007_@>array[13]<>true then '14:10 - 14:30 '
else null end,

case
when o.attr_4007_@>array[15,16] then '14:40 - 15:20 ' 
when o.attr_4007_@>array[15] and o.attr_4007_@>array[16]<>true then '14:40 - 15:00 '
when o.attr_4007_@>array[16] and o.attr_4007_@>array[15]<>true then '15:00 - 15:20 '
else null end,

case
when o.attr_4007_@>array[17,18] then '15:30 - 16:10 ' 
when o.attr_4007_@>array[17] and o.attr_4007_@>array[18]<>true then '15:30 - 15:50 '
when o.attr_4007_@>array[18] and o.attr_4007_@>array[17]<>true then '15:50 - 16:10 '
else null end,

case
when o.attr_4007_@>array[19,20] then '16:20 - 17:00 ' 
when o.attr_4007_@>array[19] and o.attr_4007_@>array[20]<>true then '16:20 - 16:40 '
when o.attr_4007_@>array[20] and o.attr_4007_@>array[19]<>true then '16:40 - 17:00 '
else null end,

case
when o.attr_4007_@>array[21,22] then '17:00 - 17:40 ' 
when o.attr_4007_@>array[21] and o.attr_4007_@>array[22]<>true then '17:00 - 17:20 '
when o.attr_4007_@>array[22] and o.attr_4007_@>array[21]<>true then '17:20 - 17:40 '
else null end,

case
when o.attr_4007_@>array[23,24] then '17:40 - 18:20 ' 
when o.attr_4007_@>array[23] and o.attr_4007_@>array[24]<>true then '17:40 - 18:00 '
when o.attr_4007_@>array[24] and o.attr_4007_@>array[23]<>true then '18:00 - 18:20 '
else null end,

case
when o.attr_4007_@>array[25,26] then '18:20 - 19:00 ' 
when o.attr_4007_@>array[25] and o.attr_4007_@>array[26]<>true then '18:20 - 18:40 '
when o.attr_4007_@>array[26] and o.attr_4007_@>array[25]<>true then '18:40 - 19:00 '
else null end) end) as lfk1,

concat(case when o.attr_4009_&&array[1] then null
else concat(
case 
when o.attr_4009_@>array[2,3] and o.attr_4009_@>array[4]<>true then '08:30 - 09:10 '
when o.attr_4009_@>array[3,4] and o.attr_4009_@>array[2]<>true then '08:50 - 09:30 '
else concat(
case when o.attr_4009_@>array[2] then '08:30 - 08:50 ' else null end,
case when o.attr_4009_@>array[3] then '08:50 - 09:10 ' else null end,
case when o.attr_4009_@>array[4] then '09:10 - 09:30 ' else null end)
end, 

case 
when o.attr_4009_@>array[5,6] then '09:40-10:20 '
when o.attr_4009_@>array[5] and o.attr_4009_@>array[6]<>true then '09:40 - 10:00 '
when o.attr_4009_@>array[6] and o.attr_4009_@>array[5]<>true then '10:00 - 10:20 '
else null end,

case
when o.attr_4009_@>array[7,8] then '10:30 - 11:10 ' 
when o.attr_4009_@>array[7] and o.attr_4009_@>array[8]<>true then '10:30 - 10:50 '
when o.attr_4009_@>array[8] and o.attr_4009_@>array[7]<>true then '10:50 - 11:10 '
else null end,

case
when o.attr_4009_@>array[9,10] then '11:20 - 12:00 ' 
when o.attr_4009_@>array[9] and o.attr_4009_@>array[10]<>true then '11:20 - 11:40 '
when o.attr_4009_@>array[10] and o.attr_4009_@>array[9]<>true then '11:40 - 12:00 '
else null end,

case
when o.attr_4009_@>array[11,12] then '13:00 - 13:40 ' 
when o.attr_4009_@>array[11] and o.attr_4009_@>array[12]<>true then '13:00 - 13:20 '
when o.attr_4009_@>array[12] and o.attr_4009_@>array[11]<>true then '13:20 - 13:40 '
else null end,

case
when o.attr_4009_@>array[13,14] then '13:50 - 14:30 ' 
when o.attr_4009_@>array[13] and o.attr_4009_@>array[14]<>true then '13:50 - 14:10 '
when o.attr_4009_@>array[14] and o.attr_4009_@>array[13]<>true then '14:10 - 14:30 '
else null end,

case
when o.attr_4009_@>array[15,16] then '14:40 - 15:20 ' 
when o.attr_4009_@>array[15] and o.attr_4009_@>array[16]<>true then '14:40 - 15:00 '
when o.attr_4009_@>array[16] and o.attr_4009_@>array[15]<>true then '15:00 - 15:20 '
else null end,

case
when o.attr_4009_@>array[17,18] then '15:30 - 16:10 ' 
when o.attr_4009_@>array[17] and o.attr_4009_@>array[18]<>true then '15:30 - 15:50 '
when o.attr_4009_@>array[18] and o.attr_4009_@>array[17]<>true then '15:50 - 16:10 '
else null end,

case
when o.attr_4009_@>array[19,20] then '16:20 - 17:00 ' 
when o.attr_4009_@>array[19] and o.attr_4009_@>array[20]<>true then '16:20 - 16:40 '
when o.attr_4009_@>array[20] and o.attr_4009_@>array[19]<>true then '16:40 - 17:00 '
else null end,

case
when o.attr_4009_@>array[21,22] then '17:00 - 17:40 ' 
when o.attr_4009_@>array[21] and o.attr_4009_@>array[22]<>true then '17:00 - 17:20 '
when o.attr_4009_@>array[22] and o.attr_4009_@>array[21]<>true then '17:20 - 17:40 '
else null end,

case
when o.attr_4009_@>array[23,24] then '17:40 - 18:20 ' 
when o.attr_4009_@>array[23] and o.attr_4009_@>array[24]<>true then '17:40 - 18:00 '
when o.attr_4009_@>array[24] and o.attr_4009_@>array[23]<>true then '18:00 - 18:20 '
else null end,

case
when o.attr_4009_@>array[25,26] then '18:20 - 19:00 ' 
when o.attr_4009_@>array[25] and o.attr_4009_@>array[26]<>true then '18:20 - 18:40 '
when o.attr_4009_@>array[26] and o.attr_4009_@>array[25]<>true then '18:40 - 19:00 '
else null end) end) as lfk2,

concat(case when o.attr_4011_&&array[1] then null
else concat(
case 
when o.attr_4011_@>array[2,3] and o.attr_4011_@>array[4]<>true then '08:30 - 09:10 '
when o.attr_4011_@>array[3,4] and o.attr_4011_@>array[2]<>true then '08:50 - 09:30 '
else concat(
case when o.attr_4011_@>array[2] then '08:30 - 08:50 ' else null end,
case when o.attr_4011_@>array[3] then '08:50 - 09:10 ' else null end,
case when o.attr_4011_@>array[4] then '09:10 - 09:30 ' else null end)
end, 

case 
when o.attr_4011_@>array[5,6] then '09:40-10:20 '
when o.attr_4011_@>array[5] and o.attr_4011_@>array[6]<>true then '09:40 - 10:00 '
when o.attr_4011_@>array[6] and o.attr_4011_@>array[5]<>true then '10:00 - 10:20 '
else null end,

case
when o.attr_4011_@>array[7,8] then '10:30 - 11:10 ' 
when o.attr_4011_@>array[7] and o.attr_4011_@>array[8]<>true then '10:30 - 10:50 '
when o.attr_4011_@>array[8] and o.attr_4011_@>array[7]<>true then '10:50 - 11:10 '
else null end,

case
when o.attr_4011_@>array[9,10] then '11:20 - 12:00 ' 
when o.attr_4011_@>array[9] and o.attr_4011_@>array[10]<>true then '11:20 - 11:40 '
when o.attr_4011_@>array[10] and o.attr_4011_@>array[9]<>true then '11:40 - 12:00 '
else null end,

case
when o.attr_4011_@>array[11,12] then '13:00 - 13:40 ' 
when o.attr_4011_@>array[11] and o.attr_4011_@>array[12]<>true then '13:00 - 13:20 '
when o.attr_4011_@>array[12] and o.attr_4011_@>array[11]<>true then '13:20 - 13:40 '
else null end,

case
when o.attr_4011_@>array[13,14] then '13:50 - 14:30 ' 
when o.attr_4011_@>array[13] and o.attr_4011_@>array[14]<>true then '13:50 - 14:10 '
when o.attr_4011_@>array[14] and o.attr_4011_@>array[13]<>true then '14:10 - 14:30 '
else null end,

case
when o.attr_4011_@>array[15,16] then '14:40 - 15:20 ' 
when o.attr_4011_@>array[15] and o.attr_4011_@>array[16]<>true then '14:40 - 15:00 '
when o.attr_4011_@>array[16] and o.attr_4011_@>array[15]<>true then '15:00 - 15:20 '
else null end,

case
when o.attr_4011_@>array[17,18] then '15:30 - 16:10 ' 
when o.attr_4011_@>array[17] and o.attr_4011_@>array[18]<>true then '15:30 - 15:50 '
when o.attr_4011_@>array[18] and o.attr_4011_@>array[17]<>true then '15:50 - 16:10 '
else null end,

case
when o.attr_4011_@>array[19,20] then '16:20 - 17:00 ' 
when o.attr_4011_@>array[19] and o.attr_4011_@>array[20]<>true then '16:20 - 16:40 '
when o.attr_4011_@>array[20] and o.attr_4011_@>array[19]<>true then '16:40 - 17:00 '
else null end,

case
when o.attr_4011_@>array[21,22] then '17:00 - 17:40 ' 
when o.attr_4011_@>array[21] and o.attr_4011_@>array[22]<>true then '17:00 - 17:20 '
when o.attr_4011_@>array[22] and o.attr_4011_@>array[21]<>true then '17:20 - 17:40 '
else null end,

case
when o.attr_4011_@>array[23,24] then '17:40 - 18:20 ' 
when o.attr_4011_@>array[23] and o.attr_4011_@>array[24]<>true then '17:40 - 18:00 '
when o.attr_4011_@>array[24] and o.attr_4011_@>array[23]<>true then '18:00 - 18:20 '
else null end,

case
when o.attr_4011_@>array[25,26] then '18:20 - 19:00 ' 
when o.attr_4011_@>array[25] and o.attr_4011_@>array[26]<>true then '18:20 - 18:40 '
when o.attr_4011_@>array[26] and o.attr_4011_@>array[25]<>true then '18:40 - 19:00 '
else null end) end) as bass,

concat(case when o.attr_4013_&&array[1] then null
else concat(
case 
when o.attr_4013_@>array[2,3] and o.attr_4013_@>array[4]<>true then '08:30 - 09:10 '
when o.attr_4013_@>array[3,4] and o.attr_4013_@>array[2]<>true then '08:50 - 09:30 '
else concat(
case when o.attr_4013_@>array[2] then '08:30 - 08:50 ' else null end,
case when o.attr_4013_@>array[3] then '08:50 - 09:10 ' else null end,
case when o.attr_4013_@>array[4] then '09:10 - 09:30 ' else null end)
end, 

case 
when o.attr_4013_@>array[5,6] then '09:40-10:20 '
when o.attr_4013_@>array[5] and o.attr_4013_@>array[6]<>true then '09:40 - 10:00 '
when o.attr_4013_@>array[6] and o.attr_4013_@>array[5]<>true then '10:00 - 10:20 '
else null end,

case
when o.attr_4013_@>array[7,8] then '10:30 - 11:10 ' 
when o.attr_4013_@>array[7] and o.attr_4013_@>array[8]<>true then '10:30 - 10:50 '
when o.attr_4013_@>array[8] and o.attr_4013_@>array[7]<>true then '10:50 - 11:10 '
else null end,

case
when o.attr_4013_@>array[9,10] then '11:20 - 12:00 ' 
when o.attr_4013_@>array[9] and o.attr_4013_@>array[10]<>true then '11:20 - 11:40 '
when o.attr_4013_@>array[10] and o.attr_4013_@>array[9]<>true then '11:40 - 12:00 '
else null end,

case
when o.attr_4013_@>array[11,12] then '13:00 - 13:40 ' 
when o.attr_4013_@>array[11] and o.attr_4013_@>array[12]<>true then '13:00 - 13:20 '
when o.attr_4013_@>array[12] and o.attr_4013_@>array[11]<>true then '13:20 - 13:40 '
else null end,

case
when o.attr_4013_@>array[13,14] then '13:50 - 14:30 ' 
when o.attr_4013_@>array[13] and o.attr_4013_@>array[14]<>true then '13:50 - 14:10 '
when o.attr_4013_@>array[14] and o.attr_4013_@>array[13]<>true then '14:10 - 14:30 '
else null end,

case
when o.attr_4013_@>array[15,16] then '14:40 - 15:20 ' 
when o.attr_4013_@>array[15] and o.attr_4013_@>array[16]<>true then '14:40 - 15:00 '
when o.attr_4013_@>array[16] and o.attr_4013_@>array[15]<>true then '15:00 - 15:20 '
else null end,

case
when o.attr_4013_@>array[17,18] then '15:30 - 16:10 ' 
when o.attr_4013_@>array[17] and o.attr_4013_@>array[18]<>true then '15:30 - 15:50 '
when o.attr_4013_@>array[18] and o.attr_4013_@>array[17]<>true then '15:50 - 16:10 '
else null end,

case
when o.attr_4013_@>array[19,20] then '16:20 - 17:00 ' 
when o.attr_4013_@>array[19] and o.attr_4013_@>array[20]<>true then '16:20 - 16:40 '
when o.attr_4013_@>array[20] and o.attr_4013_@>array[19]<>true then '16:40 - 17:00 '
else null end,

case
when o.attr_4013_@>array[21,22] then '17:00 - 17:40 ' 
when o.attr_4013_@>array[21] and o.attr_4013_@>array[22]<>true then '17:00 - 17:20 '
when o.attr_4013_@>array[22] and o.attr_4013_@>array[21]<>true then '17:20 - 17:40 '
else null end,

case
when o.attr_4013_@>array[23,24] then '17:40 - 18:20 ' 
when o.attr_4013_@>array[23] and o.attr_4013_@>array[24]<>true then '17:40 - 18:00 '
when o.attr_4013_@>array[24] and o.attr_4013_@>array[23]<>true then '18:00 - 18:20 '
else null end,

case
when o.attr_4013_@>array[25,26] then '18:20 - 19:00 ' 
when o.attr_4013_@>array[25] and o.attr_4013_@>array[26]<>true then '18:20 - 18:40 '
when o.attr_4013_@>array[26] and o.attr_4013_@>array[25]<>true then '18:40 - 19:00 '
else null end) end) as hidro,

concat(case when o.attr_4015_&&array[1] then null
else concat(
case 
when o.attr_4015_@>array[2,3] and o.attr_4015_@>array[4]<>true then '08:30 - 09:10 '
when o.attr_4015_@>array[3,4] and o.attr_4015_@>array[2]<>true then '08:50 - 09:30 '
else concat(
case when o.attr_4015_@>array[2] then '08:30 - 08:50 ' else null end,
case when o.attr_4015_@>array[3] then '08:50 - 09:10 ' else null end,
case when o.attr_4015_@>array[4] then '09:10 - 09:30 ' else null end)
end, 

case 
when o.attr_4015_@>array[5,6] then '09:40-10:20 '
when o.attr_4015_@>array[5] and o.attr_4015_@>array[6]<>true then '09:40 - 10:00 '
when o.attr_4015_@>array[6] and o.attr_4015_@>array[5]<>true then '10:00 - 10:20 '
else null end,

case
when o.attr_4015_@>array[7,8] then '10:30 - 11:10 ' 
when o.attr_4015_@>array[7] and o.attr_4015_@>array[8]<>true then '10:30 - 10:50 '
when o.attr_4015_@>array[8] and o.attr_4015_@>array[7]<>true then '10:50 - 11:10 '
else null end,

case
when o.attr_4015_@>array[9,10] then '11:20 - 12:00 ' 
when o.attr_4015_@>array[9] and o.attr_4015_@>array[10]<>true then '11:20 - 11:40 '
when o.attr_4015_@>array[10] and o.attr_4015_@>array[9]<>true then '11:40 - 12:00 '
else null end,

case
when o.attr_4015_@>array[11,12] then '13:00 - 13:40 ' 
when o.attr_4015_@>array[11] and o.attr_4015_@>array[12]<>true then '13:00 - 13:20 '
when o.attr_4015_@>array[12] and o.attr_4015_@>array[11]<>true then '13:20 - 13:40 '
else null end,

case
when o.attr_4015_@>array[13,14] then '13:50 - 14:30 ' 
when o.attr_4015_@>array[13] and o.attr_4015_@>array[14]<>true then '13:50 - 14:10 '
when o.attr_4015_@>array[14] and o.attr_4015_@>array[13]<>true then '14:10 - 14:30 '
else null end,

case
when o.attr_4015_@>array[15,16] then '14:40 - 15:20 ' 
when o.attr_4015_@>array[15] and o.attr_4015_@>array[16]<>true then '14:40 - 15:00 '
when o.attr_4015_@>array[16] and o.attr_4015_@>array[15]<>true then '15:00 - 15:20 '
else null end,

case
when o.attr_4015_@>array[17,18] then '15:30 - 16:10 ' 
when o.attr_4015_@>array[17] and o.attr_4015_@>array[18]<>true then '15:30 - 15:50 '
when o.attr_4015_@>array[18] and o.attr_4015_@>array[17]<>true then '15:50 - 16:10 '
else null end,

case
when o.attr_4015_@>array[19,20] then '16:20 - 17:00 ' 
when o.attr_4015_@>array[19] and o.attr_4015_@>array[20]<>true then '16:20 - 16:40 '
when o.attr_4015_@>array[20] and o.attr_4015_@>array[19]<>true then '16:40 - 17:00 '
else null end,

case
when o.attr_4015_@>array[21,22] then '17:00 - 17:40 ' 
when o.attr_4015_@>array[21] and o.attr_4015_@>array[22]<>true then '17:00 - 17:20 '
when o.attr_4015_@>array[22] and o.attr_4015_@>array[21]<>true then '17:20 - 17:40 '
else null end,

case
when o.attr_4015_@>array[23,24] then '17:40 - 18:20 ' 
when o.attr_4015_@>array[23] and o.attr_4015_@>array[24]<>true then '17:40 - 18:00 '
when o.attr_4015_@>array[24] and o.attr_4015_@>array[23]<>true then '18:00 - 18:20 '
else null end,

case
when o.attr_4015_@>array[25,26] then '18:20 - 19:00 ' 
when o.attr_4015_@>array[25] and o.attr_4015_@>array[26]<>true then '18:20 - 18:40 '
when o.attr_4015_@>array[26] and o.attr_4015_@>array[25]<>true then '18:40 - 19:00 '
else null end) end) as ergo,

concat(case when o.attr_4017_&&array[1] then null
else concat(
case 
when o.attr_4017_@>array[2,3] and o.attr_4017_@>array[4]<>true then '08:30 - 09:10 '
when o.attr_4017_@>array[3,4] and o.attr_4017_@>array[2]<>true then '08:50 - 09:30 '
else concat(
case when o.attr_4017_@>array[2] then '08:30 - 08:50 ' else null end,
case when o.attr_4017_@>array[3] then '08:50 - 09:10 ' else null end,
case when o.attr_4017_@>array[4] then '09:10 - 09:30 ' else null end)
end, 

case 
when o.attr_4017_@>array[5,6] then '09:40-10:20 '
when o.attr_4017_@>array[5] and o.attr_4017_@>array[6]<>true then '09:40 - 10:00 '
when o.attr_4017_@>array[6] and o.attr_4017_@>array[5]<>true then '10:00 - 10:20 '
else null end,

case
when o.attr_4017_@>array[7,8] then '10:30 - 11:10 ' 
when o.attr_4017_@>array[7] and o.attr_4017_@>array[8]<>true then '10:30 - 10:50 '
when o.attr_4017_@>array[8] and o.attr_4017_@>array[7]<>true then '10:50 - 11:10 '
else null end,

case
when o.attr_4017_@>array[9,10] then '11:20 - 12:00 ' 
when o.attr_4017_@>array[9] and o.attr_4017_@>array[10]<>true then '11:20 - 11:40 '
when o.attr_4017_@>array[10] and o.attr_4017_@>array[9]<>true then '11:40 - 12:00 '
else null end,

case
when o.attr_4017_@>array[11,12] then '13:00 - 13:40 ' 
when o.attr_4017_@>array[11] and o.attr_4017_@>array[12]<>true then '13:00 - 13:20 '
when o.attr_4017_@>array[12] and o.attr_4017_@>array[11]<>true then '13:20 - 13:40 '
else null end,

case
when o.attr_4017_@>array[13,14] then '13:50 - 14:30 ' 
when o.attr_4017_@>array[13] and o.attr_4017_@>array[14]<>true then '13:50 - 14:10 '
when o.attr_4017_@>array[14] and o.attr_4017_@>array[13]<>true then '14:10 - 14:30 '
else null end,

case
when o.attr_4017_@>array[15,16] then '14:40 - 15:20 ' 
when o.attr_4017_@>array[15] and o.attr_4017_@>array[16]<>true then '14:40 - 15:00 '
when o.attr_4017_@>array[16] and o.attr_4017_@>array[15]<>true then '15:00 - 15:20 '
else null end,

case
when o.attr_4017_@>array[17,18] then '15:30 - 16:10 ' 
when o.attr_4017_@>array[17] and o.attr_4017_@>array[18]<>true then '15:30 - 15:50 '
when o.attr_4017_@>array[18] and o.attr_4017_@>array[17]<>true then '15:50 - 16:10 '
else null end,

case
when o.attr_4017_@>array[19,20] then '16:20 - 17:00 ' 
when o.attr_4017_@>array[19] and o.attr_4017_@>array[20]<>true then '16:20 - 16:40 '
when o.attr_4017_@>array[20] and o.attr_4017_@>array[19]<>true then '16:40 - 17:00 '
else null end,

case
when o.attr_4017_@>array[21,22] then '17:00 - 17:40 ' 
when o.attr_4017_@>array[21] and o.attr_4017_@>array[22]<>true then '17:00 - 17:20 '
when o.attr_4017_@>array[22] and o.attr_4017_@>array[21]<>true then '17:20 - 17:40 '
else null end,

case
when o.attr_4017_@>array[23,24] then '17:40 - 18:20 ' 
when o.attr_4017_@>array[23] and o.attr_4017_@>array[24]<>true then '17:40 - 18:00 '
when o.attr_4017_@>array[24] and o.attr_4017_@>array[23]<>true then '18:00 - 18:20 '
else null end,

case
when o.attr_4017_@>array[25,26] then '18:20 - 19:00 ' 
when o.attr_4017_@>array[25] and o.attr_4017_@>array[26]<>true then '18:20 - 18:40 '
when o.attr_4017_@>array[26] and o.attr_4017_@>array[25]<>true then '18:40 - 19:00 '
else null end) end) as logo,

concat(case when o.attr_4019_&&array[1] then null
else concat(
case 
when o.attr_4019_@>array[2,3] and o.attr_4019_@>array[4]<>true then '08:30 - 09:10 '
when o.attr_4019_@>array[3,4] and o.attr_4019_@>array[2]<>true then '08:50 - 09:30 '
else concat(
case when o.attr_4019_@>array[2] then '08:30 - 08:50 ' else null end,
case when o.attr_4019_@>array[3] then '08:50 - 09:10 ' else null end,
case when o.attr_4019_@>array[4] then '09:10 - 09:30 ' else null end)
end, 

case 
when o.attr_4019_@>array[5,6] then '09:40-10:20 '
when o.attr_4019_@>array[5] and o.attr_4019_@>array[6]<>true then '09:40 - 10:00 '
when o.attr_4019_@>array[6] and o.attr_4019_@>array[5]<>true then '10:00 - 10:20 '
else null end,

case
when o.attr_4019_@>array[7,8] then '10:30 - 11:10 ' 
when o.attr_4019_@>array[7] and o.attr_4019_@>array[8]<>true then '10:30 - 10:50 '
when o.attr_4019_@>array[8] and o.attr_4019_@>array[7]<>true then '10:50 - 11:10 '
else null end,

case
when o.attr_4019_@>array[9,10] then '11:20 - 12:00 ' 
when o.attr_4019_@>array[9] and o.attr_4019_@>array[10]<>true then '11:20 - 11:40 '
when o.attr_4019_@>array[10] and o.attr_4019_@>array[9]<>true then '11:40 - 12:00 '
else null end,

case
when o.attr_4019_@>array[11,12] then '13:00 - 13:40 ' 
when o.attr_4019_@>array[11] and o.attr_4019_@>array[12]<>true then '13:00 - 13:20 '
when o.attr_4019_@>array[12] and o.attr_4019_@>array[11]<>true then '13:20 - 13:40 '
else null end,

case
when o.attr_4019_@>array[13,14] then '13:50 - 14:30 ' 
when o.attr_4019_@>array[13] and o.attr_4019_@>array[14]<>true then '13:50 - 14:10 '
when o.attr_4019_@>array[14] and o.attr_4019_@>array[13]<>true then '14:10 - 14:30 '
else null end,

case
when o.attr_4019_@>array[15,16] then '14:40 - 15:20 ' 
when o.attr_4019_@>array[15] and o.attr_4019_@>array[16]<>true then '14:40 - 15:00 '
when o.attr_4019_@>array[16] and o.attr_4019_@>array[15]<>true then '15:00 - 15:20 '
else null end,

case
when o.attr_4019_@>array[17,18] then '15:30 - 16:10 ' 
when o.attr_4019_@>array[17] and o.attr_4019_@>array[18]<>true then '15:30 - 15:50 '
when o.attr_4019_@>array[18] and o.attr_4019_@>array[17]<>true then '15:50 - 16:10 '
else null end,

case
when o.attr_4019_@>array[19,20] then '16:20 - 17:00 ' 
when o.attr_4019_@>array[19] and o.attr_4019_@>array[20]<>true then '16:20 - 16:40 '
when o.attr_4019_@>array[20] and o.attr_4019_@>array[19]<>true then '16:40 - 17:00 '
else null end,

case
when o.attr_4019_@>array[21,22] then '17:00 - 17:40 ' 
when o.attr_4019_@>array[21] and o.attr_4019_@>array[22]<>true then '17:00 - 17:20 '
when o.attr_4019_@>array[22] and o.attr_4019_@>array[21]<>true then '17:20 - 17:40 '
else null end,

case
when o.attr_4019_@>array[23,24] then '17:40 - 18:20 ' 
when o.attr_4019_@>array[23] and o.attr_4019_@>array[24]<>true then '17:40 - 18:00 '
when o.attr_4019_@>array[24] and o.attr_4019_@>array[23]<>true then '18:00 - 18:20 '
else null end,

case
when o.attr_4019_@>array[25,26] then '18:20 - 19:00 ' 
when o.attr_4019_@>array[25] and o.attr_4019_@>array[26]<>true then '18:20 - 18:40 '
when o.attr_4019_@>array[26] and o.attr_4019_@>array[25]<>true then '18:40 - 19:00 '
else null end) end) as pshich,


concat(case when o.attr_4021_&&array[1] then null
else concat(
case 
when o.attr_4021_@>array[2,3] and o.attr_4021_@>array[4]<>true then '08:30 - 09:10 '
when o.attr_4021_@>array[3,4] and o.attr_4021_@>array[2]<>true then '08:50 - 09:30 '
else concat(
case when o.attr_4021_@>array[2] then '08:30 - 08:50 ' else null end,
case when o.attr_4021_@>array[3] then '08:50 - 09:10 ' else null end,
case when o.attr_4021_@>array[4] then '09:10 - 09:30 ' else null end)
end, 

case 
when o.attr_4021_@>array[5,6] then '09:40-10:20 '
when o.attr_4021_@>array[5] and o.attr_4021_@>array[6]<>true then '09:40 - 10:00 '
when o.attr_4021_@>array[6] and o.attr_4021_@>array[5]<>true then '10:00 - 10:20 '
else null end,

case
when o.attr_4021_@>array[7,8] then '10:30 - 11:10 ' 
when o.attr_4021_@>array[7] and o.attr_4021_@>array[8]<>true then '10:30 - 10:50 '
when o.attr_4021_@>array[8] and o.attr_4021_@>array[7]<>true then '10:50 - 11:10 '
else null end,

case
when o.attr_4021_@>array[9,10] then '11:20 - 12:00 ' 
when o.attr_4021_@>array[9] and o.attr_4021_@>array[10]<>true then '11:20 - 11:40 '
when o.attr_4021_@>array[10] and o.attr_4021_@>array[9]<>true then '11:40 - 12:00 '
else null end,

case
when o.attr_4021_@>array[11,12] then '13:00 - 13:40 ' 
when o.attr_4021_@>array[11] and o.attr_4021_@>array[12]<>true then '13:00 - 13:20 '
when o.attr_4021_@>array[12] and o.attr_4021_@>array[11]<>true then '13:20 - 13:40 '
else null end,

case
when o.attr_4021_@>array[13,14] then '13:50 - 14:30 ' 
when o.attr_4021_@>array[13] and o.attr_4021_@>array[14]<>true then '13:50 - 14:10 '
when o.attr_4021_@>array[14] and o.attr_4021_@>array[13]<>true then '14:10 - 14:30 '
else null end,

case
when o.attr_4021_@>array[15,16] then '14:40 - 15:20 ' 
when o.attr_4021_@>array[15] and o.attr_4021_@>array[16]<>true then '14:40 - 15:00 '
when o.attr_4021_@>array[16] and o.attr_4021_@>array[15]<>true then '15:00 - 15:20 '
else null end,

case
when o.attr_4021_@>array[17,18] then '15:30 - 16:10 ' 
when o.attr_4021_@>array[17] and o.attr_4021_@>array[18]<>true then '15:30 - 15:50 '
when o.attr_4021_@>array[18] and o.attr_4021_@>array[17]<>true then '15:50 - 16:10 '
else null end,

case
when o.attr_4021_@>array[19,20] then '16:20 - 17:00 ' 
when o.attr_4021_@>array[19] and o.attr_4021_@>array[20]<>true then '16:20 - 16:40 '
when o.attr_4021_@>array[20] and o.attr_4021_@>array[19]<>true then '16:40 - 17:00 '
else null end,

case
when o.attr_4021_@>array[21,22] then '17:00 - 17:40 ' 
when o.attr_4021_@>array[21] and o.attr_4021_@>array[22]<>true then '17:00 - 17:20 '
when o.attr_4021_@>array[22] and o.attr_4021_@>array[21]<>true then '17:20 - 17:40 '
else null end,

case
when o.attr_4021_@>array[23,24] then '17:40 - 18:20 ' 
when o.attr_4021_@>array[23] and o.attr_4021_@>array[24]<>true then '17:40 - 18:00 '
when o.attr_4021_@>array[24] and o.attr_4021_@>array[23]<>true then '18:00 - 18:20 '
else null end,

case
when o.attr_4021_@>array[25,26] then '18:20 - 19:00 ' 
when o.attr_4021_@>array[25] and o.attr_4021_@>array[26]<>true then '18:20 - 18:40 '
when o.attr_4021_@>array[26] and o.attr_4021_@>array[25]<>true then '18:40 - 19:00 '
else null end) end) as irt,

concat(case when o.attr_4023_&&array[1] then null
else concat(
case 
when o.attr_4023_@>array[2,3] and o.attr_4023_@>array[4]<>true then '08:30 - 09:10 '
when o.attr_4023_@>array[3,4] and o.attr_4023_@>array[2]<>true then '08:50 - 09:30 '
else concat(
case when o.attr_4023_@>array[2] then '08:30 - 08:50 ' else null end,
case when o.attr_4023_@>array[3] then '08:50 - 09:10 ' else null end,
case when o.attr_4023_@>array[4] then '09:10 - 09:30 ' else null end)
end, 

case 
when o.attr_4023_@>array[5,6] then '09:40-10:20 '
when o.attr_4023_@>array[5] and o.attr_4023_@>array[6]<>true then '09:40 - 10:00 '
when o.attr_4023_@>array[6] and o.attr_4023_@>array[5]<>true then '10:00 - 10:20 '
else null end,

case
when o.attr_4023_@>array[7,8] then '10:30 - 11:10 ' 
when o.attr_4023_@>array[7] and o.attr_4023_@>array[8]<>true then '10:30 - 10:50 '
when o.attr_4023_@>array[8] and o.attr_4023_@>array[7]<>true then '10:50 - 11:10 '
else null end,

case
when o.attr_4023_@>array[9,10] then '11:20 - 12:00 ' 
when o.attr_4023_@>array[9] and o.attr_4023_@>array[10]<>true then '11:20 - 11:40 '
when o.attr_4023_@>array[10] and o.attr_4023_@>array[9]<>true then '11:40 - 12:00 '
else null end,

case
when o.attr_4023_@>array[11,12] then '13:00 - 13:40 ' 
when o.attr_4023_@>array[11] and o.attr_4023_@>array[12]<>true then '13:00 - 13:20 '
when o.attr_4023_@>array[12] and o.attr_4023_@>array[11]<>true then '13:20 - 13:40 '
else null end,

case
when o.attr_4023_@>array[13,14] then '13:50 - 14:30 ' 
when o.attr_4023_@>array[13] and o.attr_4023_@>array[14]<>true then '13:50 - 14:10 '
when o.attr_4023_@>array[14] and o.attr_4023_@>array[13]<>true then '14:10 - 14:30 '
else null end,

case
when o.attr_4023_@>array[15,16] then '14:40 - 15:20 ' 
when o.attr_4023_@>array[15] and o.attr_4023_@>array[16]<>true then '14:40 - 15:00 '
when o.attr_4023_@>array[16] and o.attr_4023_@>array[15]<>true then '15:00 - 15:20 '
else null end,

case
when o.attr_4023_@>array[17,18] then '15:30 - 16:10 ' 
when o.attr_4023_@>array[17] and o.attr_4023_@>array[18]<>true then '15:30 - 15:50 '
when o.attr_4023_@>array[18] and o.attr_4023_@>array[17]<>true then '15:50 - 16:10 '
else null end,

case
when o.attr_4023_@>array[19,20] then '16:20 - 17:00 ' 
when o.attr_4023_@>array[19] and o.attr_4023_@>array[20]<>true then '16:20 - 16:40 '
when o.attr_4023_@>array[20] and o.attr_4023_@>array[19]<>true then '16:40 - 17:00 '
else null end,

case
when o.attr_4023_@>array[21,22] then '17:00 - 17:40 ' 
when o.attr_4023_@>array[21] and o.attr_4023_@>array[22]<>true then '17:00 - 17:20 '
when o.attr_4023_@>array[22] and o.attr_4023_@>array[21]<>true then '17:20 - 17:40 '
else null end,

case
when o.attr_4023_@>array[23,24] then '17:40 - 18:20 ' 
when o.attr_4023_@>array[23] and o.attr_4023_@>array[24]<>true then '17:40 - 18:00 '
when o.attr_4023_@>array[24] and o.attr_4023_@>array[23]<>true then '18:00 - 18:20 '
else null end,

case
when o.attr_4023_@>array[25,26] then '18:20 - 19:00 ' 
when o.attr_4023_@>array[25] and o.attr_4023_@>array[26]<>true then '18:20 - 18:40 '
when o.attr_4023_@>array[26] and o.attr_4023_@>array[25]<>true then '18:40 - 19:00 '
else null end) end) as mass,

concat(case when o.attr_4025_&&array[1] then null
else concat(
case 
when o.attr_4025_@>array[2,3] and o.attr_4025_@>array[4]<>true then '08:30 - 09:10 '
when o.attr_4025_@>array[3,4] and o.attr_4025_@>array[2]<>true then '08:50 - 09:30 '
else concat(
case when o.attr_4025_@>array[2] then '08:30 - 08:50 ' else null end,
case when o.attr_4025_@>array[3] then '08:50 - 09:10 ' else null end,
case when o.attr_4025_@>array[4] then '09:10 - 09:30 ' else null end)
end, 

case 
when o.attr_4025_@>array[5,6] then '09:40-10:20 '
when o.attr_4025_@>array[5] and o.attr_4025_@>array[6]<>true then '09:40 - 10:00 '
when o.attr_4025_@>array[6] and o.attr_4025_@>array[5]<>true then '10:00 - 10:20 '
else null end,

case
when o.attr_4025_@>array[7,8] then '10:30 - 11:10 ' 
when o.attr_4025_@>array[7] and o.attr_4025_@>array[8]<>true then '10:30 - 10:50 '
when o.attr_4025_@>array[8] and o.attr_4025_@>array[7]<>true then '10:50 - 11:10 '
else null end,

case
when o.attr_4025_@>array[9,10] then '11:20 - 12:00 ' 
when o.attr_4025_@>array[9] and o.attr_4025_@>array[10]<>true then '11:20 - 11:40 '
when o.attr_4025_@>array[10] and o.attr_4025_@>array[9]<>true then '11:40 - 12:00 '
else null end,

case
when o.attr_4025_@>array[11,12] then '13:00 - 13:40 ' 
when o.attr_4025_@>array[11] and o.attr_4025_@>array[12]<>true then '13:00 - 13:20 '
when o.attr_4025_@>array[12] and o.attr_4025_@>array[11]<>true then '13:20 - 13:40 '
else null end,

case
when o.attr_4025_@>array[13,14] then '13:50 - 14:30 ' 
when o.attr_4025_@>array[13] and o.attr_4025_@>array[14]<>true then '13:50 - 14:10 '
when o.attr_4025_@>array[14] and o.attr_4025_@>array[13]<>true then '14:10 - 14:30 '
else null end,

case
when o.attr_4025_@>array[15,16] then '14:40 - 15:20 ' 
when o.attr_4025_@>array[15] and o.attr_4025_@>array[16]<>true then '14:40 - 15:00 '
when o.attr_4025_@>array[16] and o.attr_4025_@>array[15]<>true then '15:00 - 15:20 '
else null end,

case
when o.attr_4025_@>array[17,18] then '15:30 - 16:10 ' 
when o.attr_4025_@>array[17] and o.attr_4025_@>array[18]<>true then '15:30 - 15:50 '
when o.attr_4025_@>array[18] and o.attr_4025_@>array[17]<>true then '15:50 - 16:10 '
else null end,

case
when o.attr_4025_@>array[19,20] then '16:20 - 17:00 ' 
when o.attr_4025_@>array[19] and o.attr_4025_@>array[20]<>true then '16:20 - 16:40 '
when o.attr_4025_@>array[20] and o.attr_4025_@>array[19]<>true then '16:40 - 17:00 '
else null end,

case
when o.attr_4025_@>array[21,22] then '17:00 - 17:40 ' 
when o.attr_4025_@>array[21] and o.attr_4025_@>array[22]<>true then '17:00 - 17:20 '
when o.attr_4025_@>array[22] and o.attr_4025_@>array[21]<>true then '17:20 - 17:40 '
else null end,

case
when o.attr_4025_@>array[23,24] then '17:40 - 18:20 ' 
when o.attr_4025_@>array[23] and o.attr_4025_@>array[24]<>true then '17:40 - 18:00 '
when o.attr_4025_@>array[24] and o.attr_4025_@>array[23]<>true then '18:00 - 18:20 '
else null end,

case
when o.attr_4025_@>array[25,26] then '18:20 - 19:00 ' 
when o.attr_4025_@>array[25] and o.attr_4025_@>array[26]<>true then '18:20 - 18:40 '
when o.attr_4025_@>array[26] and o.attr_4025_@>array[25]<>true then '18:40 - 19:00 '
else null end) end) as ft,

concat(case when o.attr_4027_&&array[1] then null
else concat(
case 
when o.attr_4027_@>array[2,3] and o.attr_4027_@>array[4]<>true then '08:30 - 09:10 '
when o.attr_4027_@>array[3,4] and o.attr_4027_@>array[2]<>true then '08:50 - 09:30 '
else concat(
case when o.attr_4027_@>array[2] then '08:30 - 08:50 ' else null end,
case when o.attr_4027_@>array[3] then '08:50 - 09:10 ' else null end,
case when o.attr_4027_@>array[4] then '09:10 - 09:30 ' else null end)
end, 

case 
when o.attr_4027_@>array[5,6] then '09:40-10:20 '
when o.attr_4027_@>array[5] and o.attr_4027_@>array[6]<>true then '09:40 - 10:00 '
when o.attr_4027_@>array[6] and o.attr_4027_@>array[5]<>true then '10:00 - 10:20 '
else null end,

case
when o.attr_4027_@>array[7,8] then '10:30 - 11:10 ' 
when o.attr_4027_@>array[7] and o.attr_4027_@>array[8]<>true then '10:30 - 10:50 '
when o.attr_4027_@>array[8] and o.attr_4027_@>array[7]<>true then '10:50 - 11:10 '
else null end,

case
when o.attr_4027_@>array[9,10] then '11:20 - 12:00 ' 
when o.attr_4027_@>array[9] and o.attr_4027_@>array[10]<>true then '11:20 - 11:40 '
when o.attr_4027_@>array[10] and o.attr_4027_@>array[9]<>true then '11:40 - 12:00 '
else null end,

case
when o.attr_4027_@>array[11,12] then '13:00 - 13:40 ' 
when o.attr_4027_@>array[11] and o.attr_4027_@>array[12]<>true then '13:00 - 13:20 '
when o.attr_4027_@>array[12] and o.attr_4027_@>array[11]<>true then '13:20 - 13:40 '
else null end,

case
when o.attr_4027_@>array[13,14] then '13:50 - 14:30 ' 
when o.attr_4027_@>array[13] and o.attr_4027_@>array[14]<>true then '13:50 - 14:10 '
when o.attr_4027_@>array[14] and o.attr_4027_@>array[13]<>true then '14:10 - 14:30 '
else null end,

case
when o.attr_4027_@>array[15,16] then '14:40 - 15:20 ' 
when o.attr_4027_@>array[15] and o.attr_4027_@>array[16]<>true then '14:40 - 15:00 '
when o.attr_4027_@>array[16] and o.attr_4027_@>array[15]<>true then '15:00 - 15:20 '
else null end,

case
when o.attr_4027_@>array[17,18] then '15:30 - 16:10 ' 
when o.attr_4027_@>array[17] and o.attr_4027_@>array[18]<>true then '15:30 - 15:50 '
when o.attr_4027_@>array[18] and o.attr_4027_@>array[17]<>true then '15:50 - 16:10 '
else null end,

case
when o.attr_4027_@>array[19,20] then '16:20 - 17:00 ' 
when o.attr_4027_@>array[19] and o.attr_4027_@>array[20]<>true then '16:20 - 16:40 '
when o.attr_4027_@>array[20] and o.attr_4027_@>array[19]<>true then '16:40 - 17:00 '
else null end,

case
when o.attr_4027_@>array[21,22] then '17:00 - 17:40 ' 
when o.attr_4027_@>array[21] and o.attr_4027_@>array[22]<>true then '17:00 - 17:20 '
when o.attr_4027_@>array[22] and o.attr_4027_@>array[21]<>true then '17:20 - 17:40 '
else null end,

case
when o.attr_4027_@>array[23,24] then '17:40 - 18:20 ' 
when o.attr_4027_@>array[23] and o.attr_4027_@>array[24]<>true then '17:40 - 18:00 '
when o.attr_4027_@>array[24] and o.attr_4027_@>array[23]<>true then '18:00 - 18:20 '
else null end,

case
when o.attr_4027_@>array[25,26] then '18:20 - 19:00 ' 
when o.attr_4027_@>array[25] and o.attr_4027_@>array[26]<>true then '18:20 - 18:40 '
when o.attr_4027_@>array[26] and o.attr_4027_@>array[25]<>true then '18:40 - 19:00 '
else null end) end) as gt,

concat(case when o.attr_4029_&&array[1] then null
else concat(
case 
when o.attr_4029_@>array[2,3] and o.attr_4029_@>array[4]<>true then '08:30 - 09:10 '
when o.attr_4029_@>array[3,4] and o.attr_4029_@>array[2]<>true then '08:50 - 09:30 '
else concat(
case when o.attr_4029_@>array[2] then '08:30 - 08:50 ' else null end,
case when o.attr_4029_@>array[3] then '08:50 - 09:10 ' else null end,
case when o.attr_4029_@>array[4] then '09:10 - 09:30 ' else null end)
end, 

case 
when o.attr_4029_@>array[5,6] then '09:40-10:20 '
when o.attr_4029_@>array[5] and o.attr_4029_@>array[6]<>true then '09:40 - 10:00 '
when o.attr_4029_@>array[6] and o.attr_4029_@>array[5]<>true then '10:00 - 10:20 '
else null end,

case
when o.attr_4029_@>array[7,8] then '10:30 - 11:10 ' 
when o.attr_4029_@>array[7] and o.attr_4029_@>array[8]<>true then '10:30 - 10:50 '
when o.attr_4029_@>array[8] and o.attr_4029_@>array[7]<>true then '10:50 - 11:10 '
else null end,

case
when o.attr_4029_@>array[9,10] then '11:20 - 12:00 ' 
when o.attr_4029_@>array[9] and o.attr_4029_@>array[10]<>true then '11:20 - 11:40 '
when o.attr_4029_@>array[10] and o.attr_4029_@>array[9]<>true then '11:40 - 12:00 '
else null end,

case
when o.attr_4029_@>array[11,12] then '13:00 - 13:40 ' 
when o.attr_4029_@>array[11] and o.attr_4029_@>array[12]<>true then '13:00 - 13:20 '
when o.attr_4029_@>array[12] and o.attr_4029_@>array[11]<>true then '13:20 - 13:40 '
else null end,

case
when o.attr_4029_@>array[13,14] then '13:50 - 14:30 ' 
when o.attr_4029_@>array[13] and o.attr_4029_@>array[14]<>true then '13:50 - 14:10 '
when o.attr_4029_@>array[14] and o.attr_4029_@>array[13]<>true then '14:10 - 14:30 '
else null end,

case
when o.attr_4029_@>array[15,16] then '14:40 - 15:20 ' 
when o.attr_4029_@>array[15] and o.attr_4029_@>array[16]<>true then '14:40 - 15:00 '
when o.attr_4029_@>array[16] and o.attr_4029_@>array[15]<>true then '15:00 - 15:20 '
else null end,

case
when o.attr_4029_@>array[17,18] then '15:30 - 16:10 ' 
when o.attr_4029_@>array[17] and o.attr_4029_@>array[18]<>true then '15:30 - 15:50 '
when o.attr_4029_@>array[18] and o.attr_4029_@>array[17]<>true then '15:50 - 16:10 '
else null end,

case
when o.attr_4029_@>array[19,20] then '16:20 - 17:00 ' 
when o.attr_4029_@>array[19] and o.attr_4029_@>array[20]<>true then '16:20 - 16:40 '
when o.attr_4029_@>array[20] and o.attr_4029_@>array[19]<>true then '16:40 - 17:00 '
else null end,

case
when o.attr_4029_@>array[21,22] then '17:00 - 17:40 ' 
when o.attr_4029_@>array[21] and o.attr_4029_@>array[22]<>true then '17:00 - 17:20 '
when o.attr_4029_@>array[22] and o.attr_4029_@>array[21]<>true then '17:20 - 17:40 '
else null end,

case
when o.attr_4029_@>array[23,24] then '17:40 - 18:20 ' 
when o.attr_4029_@>array[23] and o.attr_4029_@>array[24]<>true then '17:40 - 18:00 '
when o.attr_4029_@>array[24] and o.attr_4029_@>array[23]<>true then '18:00 - 18:20 '
else null end,

case
when o.attr_4029_@>array[25,26] then '18:20 - 19:00 ' 
when o.attr_4029_@>array[25] and o.attr_4029_@>array[26]<>true then '18:20 - 18:40 '
when o.attr_4029_@>array[26] and o.attr_4029_@>array[25]<>true then '18:40 - 19:00 '
else null end) end) as sol_p,

concat(case when o.attr_4162_ &&array[1] then null
else concat(
case 
when o.attr_4162_@>array[2,3] and o.attr_4162_@>array[4]<>true then '08:30 - 09:10 '
when o.attr_4162_@>array[3,4] and o.attr_4162_@>array[2]<>true then '08:50 - 09:30 '
else concat(
case when o.attr_4162_@>array[2] then '08:30 - 08:50 ' else null end,
case when o.attr_4162_@>array[3] then '08:50 - 09:10 ' else null end,
case when o.attr_4162_@>array[4] then '09:10 - 09:30 ' else null end)
end, 

case 
when o.attr_4162_@>array[5,6] then '09:40-10:20 '
when o.attr_4162_@>array[5] and o.attr_4162_@>array[6]<>true then '09:40 - 10:00 '
when o.attr_4162_@>array[6] and o.attr_4162_@>array[5]<>true then '10:00 - 10:20 '
else null end,

case
when o.attr_4162_@>array[7,8] then '10:30 - 11:10 ' 
when o.attr_4162_@>array[7] and o.attr_4162_@>array[8]<>true then '10:30 - 10:50 '
when o.attr_4162_@>array[8] and o.attr_4162_@>array[7]<>true then '10:50 - 11:10 '
else null end,

case
when o.attr_4162_@>array[9,10] then '11:20 - 12:00 ' 
when o.attr_4162_@>array[9] and o.attr_4162_@>array[10]<>true then '11:20 - 11:40 '
when o.attr_4162_@>array[10] and o.attr_4162_@>array[9]<>true then '11:40 - 12:00 '
else null end,

case
when o.attr_4162_@>array[11,12] then '13:00 - 13:40 ' 
when o.attr_4162_@>array[11] and o.attr_4162_@>array[12]<>true then '13:00 - 13:20 '
when o.attr_4162_@>array[12] and o.attr_4162_@>array[11]<>true then '13:20 - 13:40 '
else null end,

case
when o.attr_4162_@>array[13,14] then '13:50 - 14:30 ' 
when o.attr_4162_@>array[13] and o.attr_4162_@>array[14]<>true then '13:50 - 14:10 '
when o.attr_4162_@>array[14] and o.attr_4162_@>array[13]<>true then '14:10 - 14:30 '
else null end,

case
when o.attr_4162_@>array[15,16] then '14:40 - 15:20 ' 
when o.attr_4162_@>array[15] and o.attr_4162_@>array[16]<>true then '14:40 - 15:00 '
when o.attr_4162_@>array[16] and o.attr_4162_@>array[15]<>true then '15:00 - 15:20 '
else null end,

case
when o.attr_4162_@>array[17,18] then '15:30 - 16:10 ' 
when o.attr_4162_@>array[17] and o.attr_4162_@>array[18]<>true then '15:30 - 15:50 '
when o.attr_4162_@>array[18] and o.attr_4162_@>array[17]<>true then '15:50 - 16:10 '
else null end,

case
when o.attr_4162_@>array[19,20] then '16:20 - 17:00 ' 
when o.attr_4162_@>array[19] and o.attr_4162_@>array[20]<>true then '16:20 - 16:40 '
when o.attr_4162_@>array[20] and o.attr_4162_@>array[19]<>true then '16:40 - 17:00 '
else null end,

case
when o.attr_4162_@>array[21,22] then '17:00 - 17:40 ' 
when o.attr_4162_@>array[21] and o.attr_4162_@>array[22]<>true then '17:00 - 17:20 '
when o.attr_4162_@>array[22] and o.attr_4162_@>array[21]<>true then '17:20 - 17:40 '
else null end,

case
when o.attr_4162_@>array[23,24] then '17:40 - 18:20 ' 
when o.attr_4162_@>array[23] and o.attr_4162_@>array[24]<>true then '17:40 - 18:00 '
when o.attr_4162_@>array[24] and o.attr_4162_@>array[23]<>true then '18:00 - 18:20 '
else null end,

case
when o.attr_4162_@>array[25,26] then '18:20 - 19:00 ' 
when o.attr_4162_@>array[25] and o.attr_4162_@>array[26]<>true then '18:20 - 18:40 '
when o.attr_4162_@>array[26] and o.attr_4162_@>array[25]<>true then '18:40 - 19:00 '
else null end) end) as girudoterapy,

concat(case when o.attr_4165_ &&array[1] then null
else concat(
case 
when o.attr_4165_@>array[2,3] and o.attr_4165_@>array[4]<>true then '08:30 - 09:10 '
when o.attr_4165_@>array[3,4] and o.attr_4165_@>array[2]<>true then '08:50 - 09:30 '
else concat(
case when o.attr_4165_@>array[2] then '08:30 - 08:50 ' else null end,
case when o.attr_4165_@>array[3] then '08:50 - 09:10 ' else null end,
case when o.attr_4165_@>array[4] then '09:10 - 09:30 ' else null end)
end, 

case 
when o.attr_4165_@>array[5,6] then '09:40-10:20 '
when o.attr_4165_@>array[5] and o.attr_4165_@>array[6]<>true then '09:40 - 10:00 '
when o.attr_4165_@>array[6] and o.attr_4165_@>array[5]<>true then '10:00 - 10:20 '
else null end,

case
when o.attr_4165_@>array[7,8] then '10:30 - 11:10 ' 
when o.attr_4165_@>array[7] and o.attr_4165_@>array[8]<>true then '10:30 - 10:50 '
when o.attr_4165_@>array[8] and o.attr_4165_@>array[7]<>true then '10:50 - 11:10 '
else null end,

case
when o.attr_4165_@>array[9,10] then '11:20 - 12:00 ' 
when o.attr_4165_@>array[9] and o.attr_4165_@>array[10]<>true then '11:20 - 11:40 '
when o.attr_4165_@>array[10] and o.attr_4165_@>array[9]<>true then '11:40 - 12:00 '
else null end,

case
when o.attr_4165_@>array[11,12] then '13:00 - 13:40 ' 
when o.attr_4165_@>array[11] and o.attr_4165_@>array[12]<>true then '13:00 - 13:20 '
when o.attr_4165_@>array[12] and o.attr_4165_@>array[11]<>true then '13:20 - 13:40 '
else null end,

case
when o.attr_4165_@>array[13,14] then '13:50 - 14:30 ' 
when o.attr_4165_@>array[13] and o.attr_4165_@>array[14]<>true then '13:50 - 14:10 '
when o.attr_4165_@>array[14] and o.attr_4165_@>array[13]<>true then '14:10 - 14:30 '
else null end,

case
when o.attr_4165_@>array[15,16] then '14:40 - 15:20 ' 
when o.attr_4165_@>array[15] and o.attr_4165_@>array[16]<>true then '14:40 - 15:00 '
when o.attr_4165_@>array[16] and o.attr_4165_@>array[15]<>true then '15:00 - 15:20 '
else null end,

case
when o.attr_4165_@>array[17,18] then '15:30 - 16:10 ' 
when o.attr_4165_@>array[17] and o.attr_4165_@>array[18]<>true then '15:30 - 15:50 '
when o.attr_4165_@>array[18] and o.attr_4165_@>array[17]<>true then '15:50 - 16:10 '
else null end,

case
when o.attr_4165_@>array[19,20] then '16:20 - 17:00 ' 
when o.attr_4165_@>array[19] and o.attr_4165_@>array[20]<>true then '16:20 - 16:40 '
when o.attr_4165_@>array[20] and o.attr_4165_@>array[19]<>true then '16:40 - 17:00 '
else null end,

case
when o.attr_4165_@>array[21,22] then '17:00 - 17:40 ' 
when o.attr_4165_@>array[21] and o.attr_4165_@>array[22]<>true then '17:00 - 17:20 '
when o.attr_4165_@>array[22] and o.attr_4165_@>array[21]<>true then '17:20 - 17:40 '
else null end,

case
when o.attr_4165_@>array[23,24] then '17:40 - 18:20 ' 
when o.attr_4165_@>array[23] and o.attr_4165_@>array[24]<>true then '17:40 - 18:00 '
when o.attr_4165_@>array[24] and o.attr_4165_@>array[23]<>true then '18:00 - 18:20 '
else null end,

case
when o.attr_4165_@>array[25,26] then '18:20 - 19:00 ' 
when o.attr_4165_@>array[25] and o.attr_4165_@>array[26]<>true then '18:20 - 18:40 '
when o.attr_4165_@>array[26] and o.attr_4165_@>array[25]<>true then '18:40 - 19:00 '
else null end) end) as fitoterapy,

concat(case when o.attr_4168_ &&array[1] then null
else concat(
case 
when o.attr_4168_@>array[2,3] and o.attr_4168_@>array[4]<>true then '08:30 - 09:10 '
when o.attr_4168_@>array[3,4] and o.attr_4168_@>array[2]<>true then '08:50 - 09:30 '
else concat(
case when o.attr_4168_@>array[2] then '08:30 - 08:50 ' else null end,
case when o.attr_4168_@>array[3] then '08:50 - 09:10 ' else null end,
case when o.attr_4168_@>array[4] then '09:10 - 09:30 ' else null end)
end, 

case 
when o.attr_4168_@>array[5,6] then '09:40-10:20 '
when o.attr_4168_@>array[5] and o.attr_4168_@>array[6]<>true then '09:40 - 10:00 '
when o.attr_4168_@>array[6] and o.attr_4168_@>array[5]<>true then '10:00 - 10:20 '
else null end,

case
when o.attr_4168_@>array[7,8] then '10:30 - 11:10 ' 
when o.attr_4168_@>array[7] and o.attr_4168_@>array[8]<>true then '10:30 - 10:50 '
when o.attr_4168_@>array[8] and o.attr_4168_@>array[7]<>true then '10:50 - 11:10 '
else null end,

case
when o.attr_4168_@>array[9,10] then '11:20 - 12:00 ' 
when o.attr_4168_@>array[9] and o.attr_4168_@>array[10]<>true then '11:20 - 11:40 '
when o.attr_4168_@>array[10] and o.attr_4168_@>array[9]<>true then '11:40 - 12:00 '
else null end,

case
when o.attr_4168_@>array[11,12] then '13:00 - 13:40 ' 
when o.attr_4168_@>array[11] and o.attr_4168_@>array[12]<>true then '13:00 - 13:20 '
when o.attr_4168_@>array[12] and o.attr_4168_@>array[11]<>true then '13:20 - 13:40 '
else null end,

case
when o.attr_4168_@>array[13,14] then '13:50 - 14:30 ' 
when o.attr_4168_@>array[13] and o.attr_4168_@>array[14]<>true then '13:50 - 14:10 '
when o.attr_4168_@>array[14] and o.attr_4168_@>array[13]<>true then '14:10 - 14:30 '
else null end,

case
when o.attr_4168_@>array[15,16] then '14:40 - 15:20 ' 
when o.attr_4168_@>array[15] and o.attr_4168_@>array[16]<>true then '14:40 - 15:00 '
when o.attr_4168_@>array[16] and o.attr_4168_@>array[15]<>true then '15:00 - 15:20 '
else null end,

case
when o.attr_4168_@>array[17,18] then '15:30 - 16:10 ' 
when o.attr_4168_@>array[17] and o.attr_4168_@>array[18]<>true then '15:30 - 15:50 '
when o.attr_4168_@>array[18] and o.attr_4168_@>array[17]<>true then '15:50 - 16:10 '
else null end,

case
when o.attr_4168_@>array[19,20] then '16:20 - 17:00 ' 
when o.attr_4168_@>array[19] and o.attr_4168_@>array[20]<>true then '16:20 - 16:40 '
when o.attr_4168_@>array[20] and o.attr_4168_@>array[19]<>true then '16:40 - 17:00 '
else null end,

case
when o.attr_4168_@>array[21,22] then '17:00 - 17:40 ' 
when o.attr_4168_@>array[21] and o.attr_4168_@>array[22]<>true then '17:00 - 17:20 '
when o.attr_4168_@>array[22] and o.attr_4168_@>array[21]<>true then '17:20 - 17:40 '
else null end,

case
when o.attr_4168_@>array[23,24] then '17:40 - 18:20 ' 
when o.attr_4168_@>array[23] and o.attr_4168_@>array[24]<>true then '17:40 - 18:00 '
when o.attr_4168_@>array[24] and o.attr_4168_@>array[23]<>true then '18:00 - 18:20 '
else null end,

case
when o.attr_4168_@>array[25,26] then '18:20 - 19:00 ' 
when o.attr_4168_@>array[25] and o.attr_4168_@>array[26]<>true then '18:20 - 18:40 '
when o.attr_4168_@>array[26] and o.attr_4468_@>array[25]<>true then '18:40 - 19:00 '
else null end) end) as kislorod_cocteil,

concat(case when o.attr_4251_ &&array[1] then null
else concat(
case 
when o.attr_4251_@>array[2,3] and o.attr_4251_@>array[4]<>true then '08:30 - 09:10 '
when o.attr_4251_@>array[3,4] and o.attr_4251_@>array[2]<>true then '08:50 - 09:30 '
else concat(
case when o.attr_4251_@>array[2] then '08:30 - 08:50 ' else null end,
case when o.attr_4251_@>array[3] then '08:50 - 09:10 ' else null end,
case when o.attr_4251_@>array[4] then '09:10 - 09:30 ' else null end)
end, 

case 
when o.attr_4251_@>array[5,6] then '09:40-10:20 '
when o.attr_4251_@>array[5] and o.attr_4251_@>array[6]<>true then '09:40 - 10:00 '
when o.attr_4251_@>array[6] and o.attr_4251_@>array[5]<>true then '10:00 - 10:20 '
else null end,

case
when o.attr_4251_@>array[7,8] then '10:30 - 11:10 ' 
when o.attr_4251_@>array[7] and o.attr_4251_@>array[8]<>true then '10:30 - 10:50 '
when o.attr_4251_@>array[8] and o.attr_4251_@>array[7]<>true then '10:50 - 11:10 '
else null end,

case
when o.attr_4251_@>array[9,10] then '11:20 - 12:00 ' 
when o.attr_4251_@>array[9] and o.attr_4251_@>array[10]<>true then '11:20 - 11:40 '
when o.attr_4251_@>array[10] and o.attr_4251_@>array[9]<>true then '11:40 - 12:00 '
else null end,

case
when o.attr_4251_@>array[11,12] then '13:00 - 13:40 ' 
when o.attr_4251_@>array[11] and o.attr_4251_@>array[12]<>true then '13:00 - 13:20 '
when o.attr_4251_@>array[12] and o.attr_4251_@>array[11]<>true then '13:20 - 13:40 '
else null end,

case
when o.attr_4251_@>array[13,14] then '13:50 - 14:30 ' 
when o.attr_4251_@>array[13] and o.attr_4251_@>array[14]<>true then '13:50 - 14:10 '
when o.attr_4251_@>array[14] and o.attr_4251_@>array[13]<>true then '14:10 - 14:30 '
else null end,

case
when o.attr_4251_@>array[15,16] then '14:40 - 15:20 ' 
when o.attr_4251_@>array[15] and o.attr_4251_@>array[16]<>true then '14:40 - 15:00 '
when o.attr_4251_@>array[16] and o.attr_4251_@>array[15]<>true then '15:00 - 15:20 '
else null end,

case
when o.attr_4251_@>array[17,18] then '15:30 - 16:10 ' 
when o.attr_4251_@>array[17] and o.attr_4251_@>array[18]<>true then '15:30 - 15:50 '
when o.attr_4251_@>array[18] and o.attr_4251_@>array[17]<>true then '15:50 - 16:10 '
else null end,

case
when o.attr_4251_@>array[19,20] then '16:20 - 17:00 ' 
when o.attr_4251_@>array[19] and o.attr_4251_@>array[20]<>true then '16:20 - 16:40 '
when o.attr_4251_@>array[20] and o.attr_4251_@>array[19]<>true then '16:40 - 17:00 '
else null end,

case
when o.attr_4251_@>array[21,22] then '17:00 - 17:40 ' 
when o.attr_4251_@>array[21] and o.attr_4251_@>array[22]<>true then '17:00 - 17:20 '
when o.attr_4251_@>array[22] and o.attr_4251_@>array[21]<>true then '17:20 - 17:40 '
else null end,

case
when o.attr_4251_@>array[23,24] then '17:40 - 18:20 ' 
when o.attr_4251_@>array[23] and o.attr_4251_@>array[24]<>true then '17:40 - 18:00 '
when o.attr_4251_@>array[24] and o.attr_4251_@>array[23]<>true then '18:00 - 18:20 '
else null end,

case
when o.attr_4251_@>array[25,26] then '18:20 - 19:00 ' 
when o.attr_4251_@>array[25] and o.attr_4251_@>array[26]<>true then '18:20 - 18:40 '
when o.attr_4251_@>array[26] and o.attr_4251_@>array[25]<>true then '18:40 - 19:00 '
else null end) end) as soc_cult,

concat(case when o.attr_4443_ &&array[1] then null
else concat(
case 
when o.attr_4443_@>array[2,3] and o.attr_4443_@>array[4]<>true then '08:30 - 09:10 '
when o.attr_4443_@>array[3,4] and o.attr_4443_@>array[2]<>true then '08:50 - 09:30 '
else concat(
case when o.attr_4443_@>array[2] then '08:30 - 08:50 ' else null end,
case when o.attr_4443_@>array[3] then '08:50 - 09:10 ' else null end,
case when o.attr_4443_@>array[4] then '09:10 - 09:30 ' else null end)
end, 

case 
when o.attr_4443_@>array[5,6] then '09:40-10:20 '
when o.attr_4443_@>array[5] and o.attr_4443_@>array[6]<>true then '09:40 - 10:00 '
when o.attr_4443_@>array[6] and o.attr_4443_@>array[5]<>true then '10:00 - 10:20 '
else null end,

case
when o.attr_4443_@>array[7,8] then '10:30 - 11:10 ' 
when o.attr_4443_@>array[7] and o.attr_4443_@>array[8]<>true then '10:30 - 10:50 '
when o.attr_4443_@>array[8] and o.attr_4443_@>array[7]<>true then '10:50 - 11:10 '
else null end,

case
when o.attr_4443_@>array[9,10] then '11:20 - 12:00 ' 
when o.attr_4443_@>array[9] and o.attr_4443_@>array[10]<>true then '11:20 - 11:40 '
when o.attr_4443_@>array[10] and o.attr_4443_@>array[9]<>true then '11:40 - 12:00 '
else null end,

case
when o.attr_4443_@>array[11,12] then '13:00 - 13:40 ' 
when o.attr_4443_@>array[11] and o.attr_4443_@>array[12]<>true then '13:00 - 13:20 '
when o.attr_4443_@>array[12] and o.attr_4443_@>array[11]<>true then '13:20 - 13:40 '
else null end,

case
when o.attr_4443_@>array[13,14] then '13:50 - 14:30 ' 
when o.attr_4443_@>array[13] and o.attr_4443_@>array[14]<>true then '13:50 - 14:10 '
when o.attr_4443_@>array[14] and o.attr_4443_@>array[13]<>true then '14:10 - 14:30 '
else null end,

case
when o.attr_4443_@>array[15,16] then '14:40 - 15:20 ' 
when o.attr_4443_@>array[15] and o.attr_4443_@>array[16]<>true then '14:40 - 15:00 '
when o.attr_4443_@>array[16] and o.attr_4443_@>array[15]<>true then '15:00 - 15:20 '
else null end,

case
when o.attr_4443_@>array[17,18] then '15:30 - 16:10 ' 
when o.attr_4443_@>array[17] and o.attr_4443_@>array[18]<>true then '15:30 - 15:50 '
when o.attr_4443_@>array[18] and o.attr_4443_@>array[17]<>true then '15:50 - 16:10 '
else null end,

case
when o.attr_4443_@>array[19,20] then '16:20 - 17:00 ' 
when o.attr_4443_@>array[19] and o.attr_4443_@>array[20]<>true then '16:20 - 16:40 '
when o.attr_4443_@>array[20] and o.attr_4443_@>array[19]<>true then '16:40 - 17:00 '
else null end,

case
when o.attr_4443_@>array[21,22] then '17:00 - 17:40 ' 
when o.attr_4443_@>array[21] and o.attr_4443_@>array[22]<>true then '17:00 - 17:20 '
when o.attr_4443_@>array[22] and o.attr_4443_@>array[21]<>true then '17:20 - 17:40 '
else null end,

case
when o.attr_4443_@>array[23,24] then '17:40 - 18:20 ' 
when o.attr_4443_@>array[23] and o.attr_4443_@>array[24]<>true then '17:40 - 18:00 '
when o.attr_4443_@>array[24] and o.attr_4443_@>array[23]<>true then '18:00 - 18:20 '
else null end,

case
when o.attr_4443_@>array[25,26] then '18:20 - 19:00 ' 
when o.attr_4443_@>array[25] and o.attr_4443_@>array[26]<>true then '18:20 - 18:40 '
when o.attr_4443_@>array[26] and o.attr_4443_@>array[25]<>true then '18:40 - 19:00 '
else null end) end) as inhal,

concat(case when o.attr_4446_ &&array[1] then null
else concat(
case 
when o.attr_4446_@>array[2,3] and o.attr_4446_@>array[4]<>true then '08:30 - 09:10 '
when o.attr_4446_@>array[3,4] and o.attr_4446_@>array[2]<>true then '08:50 - 09:30 '
else concat(
case when o.attr_4446_@>array[2] then '08:30 - 08:50 ' else null end,
case when o.attr_4446_@>array[3] then '08:50 - 09:10 ' else null end,
case when o.attr_4446_@>array[4] then '09:10 - 09:30 ' else null end)
end, 

case 
when o.attr_4446_@>array[5,6] then '09:40-10:20 '
when o.attr_4446_@>array[5] and o.attr_4446_@>array[6]<>true then '09:40 - 10:00 '
when o.attr_4446_@>array[6] and o.attr_4446_@>array[5]<>true then '10:00 - 10:20 '
else null end,

case
when o.attr_4446_@>array[7,8] then '10:30 - 11:10 ' 
when o.attr_4446_@>array[7] and o.attr_4446_@>array[8]<>true then '10:30 - 10:50 '
when o.attr_4446_@>array[8] and o.attr_4446_@>array[7]<>true then '10:50 - 11:10 '
else null end,

case
when o.attr_4446_@>array[9,10] then '11:20 - 12:00 ' 
when o.attr_4446_@>array[9] and o.attr_4446_@>array[10]<>true then '11:20 - 11:40 '
when o.attr_4446_@>array[10] and o.attr_4446_@>array[9]<>true then '11:40 - 12:00 '
else null end,

case
when o.attr_4446_@>array[11,12] then '13:00 - 13:40 ' 
when o.attr_4446_@>array[11] and o.attr_4446_@>array[12]<>true then '13:00 - 13:20 '
when o.attr_4446_@>array[12] and o.attr_4446_@>array[11]<>true then '13:20 - 13:40 '
else null end,

case
when o.attr_4446_@>array[13,14] then '13:50 - 14:30 ' 
when o.attr_4446_@>array[13] and o.attr_4446_@>array[14]<>true then '13:50 - 14:10 '
when o.attr_4446_@>array[14] and o.attr_4446_@>array[13]<>true then '14:10 - 14:30 '
else null end,

case
when o.attr_4446_@>array[15,16] then '14:40 - 15:20 ' 
when o.attr_4446_@>array[15] and o.attr_4446_@>array[16]<>true then '14:40 - 15:00 '
when o.attr_4446_@>array[16] and o.attr_4446_@>array[15]<>true then '15:00 - 15:20 '
else null end,

case
when o.attr_4446_@>array[17,18] then '15:30 - 16:10 ' 
when o.attr_4446_@>array[17] and o.attr_4446_@>array[18]<>true then '15:30 - 15:50 '
when o.attr_4446_@>array[18] and o.attr_4446_@>array[17]<>true then '15:50 - 16:10 '
else null end,

case
when o.attr_4446_@>array[19,20] then '16:20 - 17:00 ' 
when o.attr_4446_@>array[19] and o.attr_4446_@>array[20]<>true then '16:20 - 16:40 '
when o.attr_4446_@>array[20] and o.attr_4446_@>array[19]<>true then '16:40 - 17:00 '
else null end,

case
when o.attr_4446_@>array[21,22] then '17:00 - 17:40 ' 
when o.attr_4446_@>array[21] and o.attr_4446_@>array[22]<>true then '17:00 - 17:20 '
when o.attr_4446_@>array[22] and o.attr_4446_@>array[21]<>true then '17:20 - 17:40 '
else null end,

case
when o.attr_4446_@>array[23,24] then '17:40 - 18:20 ' 
when o.attr_4446_@>array[23] and o.attr_4446_@>array[24]<>true then '17:40 - 18:00 '
when o.attr_4446_@>array[24] and o.attr_4446_@>array[23]<>true then '18:00 - 18:20 '
else null end,

case
when o.attr_4446_@>array[25,26] then '18:20 - 19:00 ' 
when o.attr_4446_@>array[25] and o.attr_4446_@>array[26]<>true then '18:20 - 18:40 '
when o.attr_4446_@>array[26] and o.attr_4446_@>array[25]<>true then '18:40 - 19:00 '
else null end) end) as presso,

fio_pac.attr_1985_ as fio, nomer.attr_135_ as nom_and_category

from registry.object_4000_ o
left join registry.object_303_ hist on o.attr_4005_ =hist.id
left join registry.object_102_ zaezd on hist.attr_765_ =zaezd.id
left join registry.object_45_ fio_pac on o.attr_4004_=fio_pac.id and fio_pac.is_deleted<>true
left join registry.object_127_ nomer on zaezd.attr_117_=nomer.id and nomer.is_deleted<>true

where o.is_deleted<>true and o.attr_4032_='{day_rasp}'
order by fio_pac.attr_1985_

