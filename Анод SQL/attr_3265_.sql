 /*изначальный*/
 case when o.attr_3076_ = 2 then  false else 
 case when (select sum(
   case when mat_part.id is null and nom_part.id is null then 0 
		/*when o1.attr_3076_ =1 and mat_part.attr_3026_= true then -1 удален для проведения смешанного оприходования единиц хранения и других материалов*/
 		when o1.attr_3076_ =2 or (mat_part.attr_3026_ =false or mat_part.attr_3026_ is null)  then 1 end)
from registry.object_3022_ o1
left join registry.object_3024_ mat_part on mat_part.attr_3083_ = o1.id and mat_part.is_deleted<>true
left join registry.object_3023_ nom_part on nom_part.attr_3082_  = o1.id and nom_part.is_deleted<>true
where o1.is_deleted<>true and o1.id = o.id
group by o1.id
order by o1.id) <=0 then true else false end end

/*новый*/
case when o.attr_3076_ = 2 then  false else 
 case when (select sum(
   case when mat_part.id is null and nom_part.id is null then false 
				when mat_part.attr_3026_ = false then true else false end)
from registry.object_3022_ o1
left join registry.object_3024_ mat_part on mat_part.attr_3083_ = o1.id and mat_part.is_deleted<>true
left join registry.object_3023_ nom_part on nom_part.attr_3082_ = o1.id and nom_part.is_deleted<>true
where o1.is_deleted<>true and o1.id = o.id
group by o1.id
order by o1.id) = 0 then true else false end end