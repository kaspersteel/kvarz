/*Наличие компонентов проектируемого изделия*/
case when  (
coalesce((select sum(sum_ost.attr_1620_) as sum_ost
from registry.object_1617_ sum_ost
where sum_ost.is_deleted <>true and sum_ost.attr_1618_ = o.attr_1458_), 0)
+
coalesce((select sum(order_nom.attr_1683_)
from registry.object_1596_ order_to_diler
left join registry.object_1679_ order_nom on order_nom.attr_1682_ = order_to_diler.id and order_nom.is_deleted<>true
where order_to_diler.is_deleted<>true and order_nom.attr_1680_ =o.attr_1458_ and order_to_diler.attr_1606_ in (5,6)
group by order_nom.attr_1680_ ), 0)
-
coalesce((select sum(abs(sum_ost.attr_1677_)) as sum_ost
from registry.object_1617_ sum_ost
where sum_ost.is_deleted <>true and sum_ost.attr_1618_ = o.attr_1458_), 0)
- 
o.attr_1896_) > 0 then true else false end

/*Наличие компонентов проектируемого изделия с учетом давальческого*/
case when  (
coalesce((select sum(sum_ost.attr_1620_) as sum_ost
from registry.object_1617_ sum_ost
where sum_ost.is_deleted <>true and sum_ost.attr_1618_ = o.attr_1458_ and sum_ost.attr_3951_ = o.attr_3933_), 0)
+
case when o.attr_3933_ then 0 else
coalesce((select sum(order_nom.attr_1683_)
from registry.object_1596_ order_to_diler
left join registry.object_1679_ order_nom on order_nom.attr_1682_ = order_to_diler.id and order_nom.is_deleted<>true
where order_to_diler.is_deleted<>true and order_nom.attr_1680_ =o.attr_1458_ and order_to_diler.attr_1606_ in (5,6)
group by order_nom.attr_1680_ ), 0) end
-
coalesce((select sum(abs(sum_ost.attr_1677_)) as sum_ost
from registry.object_1617_ sum_ost
where sum_ost.is_deleted <>true and sum_ost.attr_1618_ = o.attr_1458_ and sum_ost.attr_3951_ = o.attr_3933_), 0)
- 
o.attr_1896_) > 0 then true else false end