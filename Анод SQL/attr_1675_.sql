/*Масса. Базовая формула в attr_2204_*/
COALESCE (o.attr_1669_,
    CASE
        WHEN sort.attr_1373_=1 THEN (pi()*(o.attr_2212_/2/1000)^2*o.attr_2209_/1000)*material.attr_1359_ /*Круг/цилиндр*/
        WHEN sort.attr_1373_=2 THEN (o.attr_2210_/1000*o.attr_2209_/1000*o.attr_2211_/1000)*material.attr_1359_ /*Лист*/
        WHEN sort.attr_1373_=3 THEN (o.attr_2211_/1000*(o.attr_2210_/1000+o.attr_2932_/1000-o.attr_2211_/1000)*o.attr_2209_/1000)*material.attr_1359_/*Уголок*/
        WHEN sort.attr_1373_=4 THEN (2*sqrt(3)*(o.attr_2932_/1000/2)^2*o.attr_2209_/1000)*material.attr_1359_/*Шестигранник*/
        WHEN sort.attr_1373_=5 THEN (pi()*((o.attr_2212_/1000/2)^2-(o.attr_2928_/1000/2)^2)*(o.attr_2209_/1000))/4*material.attr_1359_/*Труба/кольцо*/
        WHEN sort.attr_1373_=7 THEN (4*o.attr_2211_/1000*((o.attr_2210_/1000)-(o.attr_2211_/1000))*(o.attr_2209_/1000))*material.attr_1359_/*Труба проф. квадратная*/
        WHEN sort.attr_1373_=8 THEN (2*(o.attr_2211_/1000)*(o.attr_2210_/1000+o.attr_2932_/1000-2*o.attr_2211_/1000)*(o.attr_2209_/1000))*material.attr_1359_/*Труба проф. прямоугольная*/
        WHEN sort.attr_1373_=9 THEN ((o.attr_2932_/1000)*(o.attr_2211_/1000)-2*(o.attr_2211_/1000)*(o.attr_2210_/1000-o.attr_2211_/1000)*(o.attr_2209_/1000))*material.attr_1359_/*Швеллер*/
        ELSE NULL
    END)