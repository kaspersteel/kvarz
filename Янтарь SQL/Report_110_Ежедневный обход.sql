/*Ежедневный обход*/
select ezh_osm.*,
skin.attr_946_ as "skin",
obsh.attr_938_ as "obsost",
breathe.attr_958_ as "breathe",
hrip.attr_931_ as "hrip",
tones_h.attr_963_ as "tones_h",
abs_1.attr_967_ as "abs_1",
abs_2.attr_968_ as "abs_2",
perif.attr_973_ as "perif",
sozn.attr_976_ as "sozn",
sglazh.attr_931_ as "sglazh",
glot.attr_1035_ as "glot",
chmn.attr_3317_ as "chmn",
move.attr_1187_ as "move",
 fonat.attr_2105_ as "fonat",
sotrud.attr_16_ as "sotrudnik",
rithm_heart.attr_964_ as "r_heart",
case when ezh_osm.attr_4147_ = true then to_char(ezh_osm.attr_4097_, 'DD.MM.YYYY') else to_char(ezh_osm.attr_4097_, 'DD.MM.YYYY hh:mm') end as date_go_round,

case when ezh_osm.attr_4147_ is not true then  concat('Общее состояние: ', obsh.attr_938_, '.', 
'\n\nЖалобы: ', ezh_osm.attr_1818_, '.', 
'\n\nОбъективно: кожные покровы ', skin.attr_946_, '. В легких дыхание ', breathe.attr_958_, ', хрипов ', hrip.attr_931_,', ЧД ', ezh_osm.attr_1822_, ' в мин. АД ', ezh_osm.attr_1823_, ' мм. рт. ст. пульс ', ezh_osm.attr_1824_, ' уд в мин, тоны сердца ', tones_h.attr_963_, ', ритм 
', rithm_heart.attr_964_, '. Живот ', abs_1.attr_967_,', ', abs_2.attr_968_, '. Периферических отеков ', perif.attr_973_,'.',
case when ezh_osm.attr_2893_ is true then 

concat ('\n\nВ неврологическом статусе: сознание - ', sozn.attr_976_, ', ЧМН – ', chmn.attr_3317_,', ', ezh_osm.attr_3571_,', глотание - ', glot.attr_1035_, ', фонация - ', fonat.attr_2105_, ', афазия - ', case when ezh_osm.attr_3643_ = 1 then 'есть' when ezh_osm.attr_3643_= 2 then 'нет' end, ', ', ezh_osm.attr_3646_, ', сух. рефлексы - ', ezh_osm.attr_2044_,' ', ref_ds.attr_3501_ , '. В пределах палаты передвигается ', move.attr_1187_, ' ',  ezh_osm.attr_3572_, '. ', 'Стул - ', stul.attr_936_, '.') else '' end,

case when  ezh_osm.attr_3899_ is true then  concat( 'Сила в конечностях – в проксимальных отделах справа: верх – ', ezh_osm.attr_1833_, ' б., ', 'низ – ', ezh_osm.attr_1835_, ' б., ', 'в дистальных справа: ', 'верх - ', ezh_osm.attr_1834_, ' б., ', 'низ –', ezh_osm.attr_3319_, ' б., ', ' в проксимальных слева: верх -', ezh_osm.attr_3320_, ' б.’, низ – ', ezh_osm.attr_3322_, ' б., ', 'в дистальных слева: ', 'верх - ', ezh_osm.attr_3321_, ' б., ', 'низ –', ezh_osm.attr_3323_, ' б., ', '. В остальных группах мышц –', ezh_osm.attr_1837_, ' б. ') else null end,

case when  ezh_osm.attr_2894_ is not null then   
concat('\n\nКомментарий: ', ezh_osm.attr_2894_, '.'
) end) 

when ezh_osm.attr_4147_ = true then case when  ezh_osm.attr_2894_ is not null then   
concat('Комментарий: ', ezh_osm.attr_2894_, '.'
) end end as status

from registry.object_1814_ ezh_osm 
left join registry.object_945_ skin on skin.id=ezh_osm.attr_1819_ and skin.is_deleted <>true
left join registry.object_937_ obsh  on obsh.id=ezh_osm.attr_1817_ and obsh.is_deleted <>true
left join registry.object_957_ breathe on breathe.id=ezh_osm.attr_1820_ and breathe.is_deleted <>true
left join registry.object_929_ hrip on hrip.id=ezh_osm.attr_1821_ and hrip.is_deleted <>true
left join registry.object_961_ tones_h on tones_h.id=ezh_osm.attr_1825_ and tones_h.is_deleted <>true
left join registry.object_965_ abs_1 on abs_1.id=ezh_osm.attr_1826_ and abs_1.is_deleted <>true
left join registry.object_966_ abs_2 on abs_2.id=ezh_osm.attr_1827_ and abs_2.is_deleted <>true
left join registry.object_972_ perif on perif.id=ezh_osm.attr_1828_ and perif.is_deleted <>true
left join registry.object_975_ sozn on sozn.id=ezh_osm.attr_1829_ and sozn.is_deleted <>true
left join registry.object_929_ sglazh on sglazh.id=ezh_osm.attr_1830_ and sglazh.is_deleted <>true
left join registry.object_995_ glot on glot.id=ezh_osm.attr_1831_ and glot.is_deleted <>true
left join registry.object_3316_ chmn on chmn.id=ezh_osm.attr_3318_ and chmn.is_deleted <>true
left join registry.object_1185_ move  on move.id=ezh_osm.attr_1839_ and move.is_deleted <>true
left join registry.object_962_ rithm_heart on ezh_osm.attr_2042_ = rithm_heart.id
left join registry.object_2104_ fonat on fonat.id=ezh_osm.attr_1832_ and fonat.is_deleted <>true
left join registry.object_935_ stul  on stul.id=ezh_osm.attr_1840_ and stul.is_deleted <>true
left join registry.object_9_ sotrud on ezh_osm.attr_2045_ =sotrud.id and sotrud.is_deleted<>true
left join registry.object_3500_ ref_ds on ezh_osm.attr_3574_=ref_ds.id and ref_ds.is_deleted<>true

where ezh_osm.is_deleted <>true and ezh_osm.attr_1953_ = {id}

group by 

ezh_osm.id, 
skin.id,
obsh.id,
breathe.id,
hrip.id,
tones_h.id,
abs_1.id,
abs_2.id,
perif.id,
sozn.id,
sglazh.id,
glot.id,
chmn.id,
move.id,
fonat.id,
stul.id,
sotrud.id,
ref_ds.id,
rithm_heart.attr_964_

order by ezh_osm.attr_4097_

