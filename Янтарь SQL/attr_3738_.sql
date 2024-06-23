/*id последнего протокола служ */

(select  prot_mdb.max_id

from registry.object_303_ o21

left join 
(select max (prot_mdb1.id) as max_id,  
prot_mdb1.attr_1141_ as hist_id 

from registry.object_1063_ prot_mdb1 where prot_mdb1.is_deleted<>true group by prot_mdb1.attr_1141_) prot_mdb on prot_mdb.hist_id=o21.id

where o21.is_deleted <>true and o21.id=o.id

group by prot_mdb.max_id)