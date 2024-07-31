SELECT o.*,
       p.attr_552_ AS billet_name,
       p.attr_447_ AS weigh_billet,
       det.attr_362_ AS name_detal,
       sotrud.attr_1894_ AS sotr1,
       sotrud1.attr_1894_ AS sotr2,
       sotrud2.attr_1894_ AS sotr3,
       sotrud4.attr_1894_ AS sotr4,
       sotrud5.attr_1894_ AS sotr5,
       materials.attr_401_ AS name_materials,
       concat(sprav_matterials.attr_401_, sprav_matterials1.attr_401_) AS zagotovka,
       CASE
           WHEN o.attr_2882_ IS TRUE THEN 'КАРТА МАРШРУТНОГО ТЕХНОЛОГИЧЕСКОГО ПРОЦЕССА СБОРКИ ТИПОВАЯ'
           ELSE 'КАРТА МАРШРУТНОГО ТЕХНОЛОГИЧЕСКОГО ПРОЦЕССА СБОРКИ'
       END AS name_card
FROM registry.object_519_ o
LEFT JOIN registry.object_400_ materials ON materials.id=o.attr_2381_
LEFT JOIN registry.object_400_ sprav_matterials ON sprav_matterials.id=o.attr_1876_
AND sprav_matterials.is_deleted <>TRUE
LEFT JOIN registry.object_400_ sprav_matterials1 ON sprav_matterials1.id=o.attr_1877_
AND sprav_matterials1.is_deleted <>TRUE
LEFT JOIN registry.object_441_ p ON p.id=o.attr_522_
LEFT JOIN registry.object_301_ det ON det.id=o.attr_520_
LEFT JOIN registry.object_17_ sotrud ON sotrud.id=o.attr_2047_
LEFT JOIN registry.object_17_ sotrud1 ON sotrud1.id=o.attr_2048_
LEFT JOIN registry.object_17_ sotrud2 ON sotrud2.id=o.attr_2049_
LEFT JOIN registry.object_17_ sotrud4 ON sotrud4.id=o.attr_2050_
LEFT JOIN registry.object_17_ sotrud5 ON sotrud5.id=o.attr_2051_
WHERE o.is_deleted <>TRUE
  AND o.id ='{superId}'
  AND o.attr_2045_=2