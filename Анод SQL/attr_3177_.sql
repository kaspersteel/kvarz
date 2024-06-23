/*Информация о компонентах в задании*/
select
/*выбрать компоненты без единиц хранения либо список изделий по заказу list*/ 
case when o.attr_3197_  is not null then o.attr_3197_ else string_agg(list, '\n') end
from "object_3168_" o
left join 
(select 
	o.id, 
	ord.attr_607_, --номер заказа
	concat_ws(' - ', concat('Заказ № ', ord.attr_607_), string_agg(o2.name_comp, '; ') filter (where(ord.attr_607_ is not null))) as list --список изделий с компонентами
	from registry.object_3168_ o
		left join 
			(select 
				o.id, 
				comp.attr_2102_,  --заказ в производство
				comp_ord1.attr_1410_,  --обозначение компонента изделия
             	concat_ws(' - ',comp_ord1.attr_1410_, string_agg(case when comp_ord.attr_1478_ = 6 then concat(comp_ord.attr_1410_, ' (отм)') else comp_ord.attr_1410_ end, ', ') filter (where(comp_ord.attr_1410_ is not null))) as name_comp --список компонентов, входящих в изделие, с информацией о статусе
             	from registry.object_3168_  o
				left join registry.object_2094_ comp on comp.attr_3175_ = o.id and comp.is_deleted<>true
				left join registry.object_1409_ comp_ord on comp.attr_2100_ = comp_ord.id and comp_ord.is_deleted<>true --компоненты изделий
				left join registry.object_1409_ comp_ord1 on comp.attr_2101_ = comp_ord1.id and comp_ord.is_deleted<>true --изделия
				where o.is_deleted<>true
				group by o.id, comp.attr_2102_, comp_ord1.attr_1410_
			) o2 on o.id=o2.id
		left join registry.object_606_ ord on o2.attr_2102_=ord.id and ord.is_deleted<>true
		group by o.id, ord.attr_607_
) o3 on o3.id=o.id
group by o.id