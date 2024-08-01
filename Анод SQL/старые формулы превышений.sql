(select case when 
sum((select sum(table_marsh_card.attr_1443_)
from registry.object_527_ table_marsh_card
where table_marsh_card.is_deleted<>true and table_marsh_card.attr_586_ = 39 and table_marsh_card.attr_538_ = marsh_card.id
group by table_marsh_card.attr_538_ ) * coalesce(o.attr_1896_, 0)) 
 > norm_nch.attr_2640_ then 1 else 0 end

from registry.object_1409_ o
left join registry.object_301_ nomenclature on o.attr_1458_ = nomenclature.id and nomenclature.is_deleted<>true
left join registry.object_519_ marsh_card on marsh_card.attr_520_ = nomenclature.id and marsh_card.is_deleted<>true and marsh_card.attr_2908_ is true
left join registry.object_2637_  norm_nch on norm_nch.attr_2639_>=o.attr_1548_ and norm_nch.attr_2638_<=o.attr_1548_ and norm_nch.is_deleted <>true
 left join registry.object_606_ orders on o.attr_1650_::integer = orders.id and orders.is_deleted<>true
where o.is_deleted<>true and (o.attr_1421_ is null or o.attr_1421_ != 1) and o.attr_1650_ is not null and o.attr_2042_ = 2
group by norm_nch.attr_2640_)

(select case when 
sum((select sum(table_marsh_card.attr_1443_)
from registry.object_527_ table_marsh_card
where table_marsh_card.is_deleted<>true and table_marsh_card.attr_586_ = 46 and table_marsh_card.attr_538_ = marsh_card.id
group by table_marsh_card.attr_538_ ) * coalesce(o.attr_1896_, 0)) 
 > norm_nch.attr_2641_ then 1 else 0 end

from registry.object_1409_ o
left join registry.object_301_ nomenclature on o.attr_1458_ = nomenclature.id and nomenclature.is_deleted<>true
left join registry.object_519_ marsh_card on marsh_card.attr_520_ = nomenclature.id and marsh_card.is_deleted<>true and marsh_card.attr_2908_ is true
left join registry.object_2637_  norm_nch on norm_nch.attr_2639_>=o.attr_1551_ and norm_nch.attr_2638_<=o.attr_1551_ and norm_nch.is_deleted <>true
 left join registry.object_606_ orders on o.attr_1650_::integer = orders.id and orders.is_deleted<>true
where o.is_deleted<>true and (o.attr_1421_ is null or o.attr_1421_ != 1) and o.attr_1650_ is not null and o.attr_2042_ = 2
group by norm_nch.attr_2641_)

(select case when 
sum((select sum(table_marsh_card.attr_1443_)
from registry.object_527_ table_marsh_card
where table_marsh_card.is_deleted<>true and table_marsh_card.attr_586_ in (33, 40) and table_marsh_card.attr_538_ = marsh_card.id
group by table_marsh_card.attr_538_ ) * coalesce(o.attr_1896_, 0)) 
 > norm_nch.attr_2642_ then 1 else 0 end

from registry.object_1409_ o
left join registry.object_301_ nomenclature on o.attr_1458_ = nomenclature.id and nomenclature.is_deleted<>true
left join registry.object_519_ marsh_card on marsh_card.attr_520_ = nomenclature.id and marsh_card.is_deleted<>true and marsh_card.attr_2908_ is true
left join registry.object_2637_  norm_nch on norm_nch.attr_2639_>=o.attr_1554_ and norm_nch.attr_2638_<= o.attr_1554_ and norm_nch.is_deleted <>true
left join registry.object_606_ orders on o.attr_1650_::integer = orders.id and orders.is_deleted<>true
where o.is_deleted<>true and (o.attr_1421_ is null or o.attr_1421_ != 1) and o.attr_1650_ is not null and o.attr_2042_ = 2
group by norm_nch.attr_2642_)

(select case when 
sum((select sum(table_marsh_card.attr_1443_)
from registry.object_527_ table_marsh_card
where table_marsh_card.is_deleted<>true and table_marsh_card.attr_586_ in (42, 43, 45, 59, 60) and table_marsh_card.attr_538_ = marsh_card.id
group by table_marsh_card.attr_538_ ) * coalesce(o.attr_1896_, 0)) 
 > norm_nch.attr_2643_ then 1 else 0 end

from registry.object_1409_ o
left join registry.object_301_ nomenclature on o.attr_1458_ = nomenclature.id and nomenclature.is_deleted<>true
left join registry.object_519_ marsh_card on marsh_card.attr_520_ = nomenclature.id and marsh_card.is_deleted<>true and marsh_card.attr_2908_ is true
left join registry.object_2637_  norm_nch on norm_nch.attr_2639_>=o.attr_1557_ and norm_nch.attr_2638_<=o.attr_1557_ and norm_nch.is_deleted <>true
 left join registry.object_606_ orders on o.attr_1650_::integer = orders.id and orders.is_deleted<>true
where o.is_deleted<>true and (o.attr_1421_ is null or o.attr_1421_ != 1) and o.attr_1650_ is not null and o.attr_2042_ = 2
group by norm_nch.attr_2643_)

(select case when 
sum((select sum(table_marsh_card.attr_1443_)
from registry.object_527_ table_marsh_card
where table_marsh_card.is_deleted<>true and table_marsh_card.attr_586_ in (51, 63) and table_marsh_card.attr_538_ = marsh_card.id
group by table_marsh_card.attr_538_ ) * coalesce(o.attr_1896_, 0)) 
 > norm_nch.attr_2644_ then 1 else 0 end

from registry.object_1409_ o
left join registry.object_301_ nomenclature on o.attr_1458_ = nomenclature.id and nomenclature.is_deleted<>true
left join registry.object_519_ marsh_card on marsh_card.attr_520_ = nomenclature.id and marsh_card.is_deleted<>true and marsh_card.attr_2908_ is true
left join registry.object_2637_  norm_nch on norm_nch.attr_2639_>=o.attr_1560_ and norm_nch.attr_2638_<=o.attr_1560_ and norm_nch.is_deleted <>true
 left join registry.object_606_ orders on o.attr_1650_::integer = orders.id and orders.is_deleted<>true
where o.is_deleted<>true and (o.attr_1421_ is null or o.attr_1421_ != 1) and o.attr_1650_ is not null and o.attr_2042_ = 2
group by norm_nch.attr_2644_)

(select case when 
sum((select sum(table_marsh_card.attr_1443_)
from registry.object_527_ table_marsh_card
where table_marsh_card.is_deleted<>true and table_marsh_card.attr_586_ = 55 and table_marsh_card.attr_538_ = marsh_card.id
group by table_marsh_card.attr_538_ ) * coalesce(o.attr_1896_, 0)) 
 > norm_nch.attr_2645_ then 1 else 0 end

from registry.object_1409_ o
left join registry.object_301_ nomenclature on o.attr_1458_ = nomenclature.id and nomenclature.is_deleted<>true
left join registry.object_519_ marsh_card on marsh_card.attr_520_ = nomenclature.id and marsh_card.is_deleted<>true and marsh_card.attr_2908_ is true
left join registry.object_2637_  norm_nch on norm_nch.attr_2639_>=o.attr_1563_ and norm_nch.attr_2638_<=o.attr_1563_ and norm_nch.is_deleted <>true
 left join registry.object_606_ orders on o.attr_1650_::integer = orders.id and orders.is_deleted<>true
where o.is_deleted<>true and (o.attr_1421_ is null or o.attr_1421_ != 1) and o.attr_1650_ is not null and o.attr_2042_ = 2
group by norm_nch.attr_2645_)