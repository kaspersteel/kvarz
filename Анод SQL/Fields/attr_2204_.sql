SELECT CONCAT(
material.attr_2976_, ' /'
        , CASE
          WHEN sort.attr_401_ IS NOT NULL THEN CONCAT(' ', sort.attr_401_)
          ELSE NULL
END
        , CASE
          WHEN typer.attr_401_ IS NOT NULL THEN CONCAT(' ', typer.attr_401_)
          ELSE NULL
END
        , CASE
          WHEN o.attr_2212_ IS NOT NULL THEN CONCAT(' Ø', o.attr_2212_)
          ELSE NULL
END
        , CASE
          WHEN o.attr_1666_ IS NOT NULL THEN CONCAT('/ № плавки ', o.attr_1666_)
          ELSE NULL
END
        , CASE
          WHEN o.attr_1667_ IS NOT NULL THEN CONCAT(' / № серт.: ', o.attr_1667_)
          ELSE NULL
END
        , ' / Тек. остаток: '
        , CASE
          WHEN o.attr_3160_ THEN CONCAT(' ', o.attr_2209_, ' мм')
          ELSE CONCAT(o.attr_1675_, ' ', sprav_units.attr_390_)
END
        , CASE
          WHEN o.attr_3952_ THEN ' (дав.)'
          ELSE ''
END
)
FROM registry.object_3168_ o -->
LEFT JOIN registry.object_400_ material ON material.id = o.attr_1663_ AND NOT material.is_deleted
LEFT JOIN registry.object_400_ sort ON sort.id = o.attr_1664_ AND NOT sort.is_deleted
LEFT JOIN registry.object_400_ typer ON o.attr_1665_ = typer.id AND NOT typer.is_deleted
LEFT JOIN registry.object_389_ sprav_units ON o.attr_1674_ = sprav_units.id AND NOT sprav_units.is_deleted
LEFT JOIN LATERAL (SELECT COALESCE (o.attr_1669_,
    CASE sort.attr_1373_
        WHEN 1 THEN (pi()*(o.attr_2212_/2/1000)^2*o.attr_2209_/1000)*material.attr_1359_ /*Круг/цилиндр*/
        WHEN 2 THEN (o.attr_2210_/1000*o.attr_2209_/1000*o.attr_2211_/1000)*material.attr_1359_ /*Лист*/
        WHEN 3 THEN (o.attr_2211_/1000*(o.attr_2210_/1000+o.attr_2932_/1000-o.attr_2211_/1000)*o.attr_2209_/1000)*material.attr_1359_/*Уголок*/
        WHEN 4 THEN (2*sqrt(3)*(o.attr_2932_/1000/2)^2*o.attr_2209_/1000)*material.attr_1359_/*Шестигранник*/
        WHEN 5 THEN (pi()*((o.attr_2212_/1000/2)^2-(o.attr_2928_/1000/2)^2)*(o.attr_2209_/1000))*material.attr_1359_/*Труба/кольцо*/
        WHEN 6 THEN (pi()*(o.attr_2212_/2/1000)^2*o.attr_2209_/1000)*material.attr_1359_ /*Поковка*/
        WHEN 7 THEN (4*o.attr_2211_/1000*((o.attr_2210_/1000)-(o.attr_2211_/1000))*(o.attr_2209_/1000))*material.attr_1359_/*Труба проф. квадратная*/
        WHEN 8 THEN (2*(o.attr_2211_/1000)*(o.attr_2210_/1000+o.attr_2932_/1000-2*o.attr_2211_/1000)*(o.attr_2209_/1000))*material.attr_1359_/*Труба проф. прямоугольная*/
        WHEN 9 THEN ((o.attr_2932_/1000)*(o.attr_2211_/1000)-2*(o.attr_2211_/1000)*(o.attr_2210_/1000-o.attr_2211_/1000)*(o.attr_2209_/1000))*material.attr_1359_/*Швеллер*/
        ELSE 0
    END) AS mass_calc) AS sub ON true
WHERE NOT o.is_deleted -->
GROUP BY -->
material.id, sort.id, typer.id, sprav_units.id, sub.mass_calc