SELECT 
       move_mat.id AS _id ,
       to_char(move_mat.attr_3992_, '«DD»  MM  YYYYг.') AS date,
       move_mat.attr_3991_ AS number ,
       source_storage.attr_2123_   AS source_storage_name ,
       target_storage.attr_2123_   AS target_storage_name ,
       target_storage.id   AS target_storage_id ,
       tab_move_mat.attr_4001_ AS tab_move_quant ,
       remnants.id AS remnants_id ,
       sprav_mat.attr_2976_ AS mat ,
       coalesce(sprav_sort.attr_2976_, '-') AS sort ,
       coalesce(sprav_tr.attr_2976_, '-') AS tr ,
       coalesce(sprav_units.attr_390_, '-') AS units ,
       anod_stuff.attr_205_ AS anod_stuff_name ,
       partners.attr_29_ AS partners_name ,
       partners_stuff.attr_3574_ AS partners_stuff_name

FROM registry.object_3987_ move_mat
LEFT JOIN registry.object_3988_ tab_move_mat ON tab_move_mat.attr_3990_ = move_mat.id
AND tab_move_mat.attr_4000_ = move_mat.attr_3993_
AND tab_move_mat.is_deleted = false 
LEFT JOIN registry.object_1659_ remnants ON remnants.id = tab_move_mat.attr_3999_ AND remnants.is_deleted = false 
LEFT JOIN registry.object_1685_ source_storage ON source_storage.id = move_mat.attr_3993_ AND source_storage.is_deleted = false 
LEFT JOIN registry.object_1685_ target_storage ON target_storage.id = move_mat.attr_3994_ AND target_storage.is_deleted = false 
LEFT JOIN registry.object_400_ sprav_mat ON sprav_mat.id = remnants.attr_1663_ AND sprav_mat.is_deleted = false 
LEFT JOIN registry.object_400_ sprav_sort ON sprav_sort.id = remnants.attr_1664_ AND sprav_sort.is_deleted = false 
LEFT JOIN registry.object_400_ sprav_tr ON sprav_tr.id = remnants.attr_1665_ AND sprav_tr.is_deleted = false 
LEFT JOIN registry.object_389_ sprav_units ON sprav_units.id = remnants.attr_1674_ AND sprav_units.is_deleted = false 
LEFT JOIN registry.object_17_ anod_stuff ON anod_stuff.id = move_mat.attr_3996_ AND anod_stuff.is_deleted = false 
LEFT JOIN registry.object_4_ partners ON partners.id = move_mat.attr_3997_ AND partners.is_deleted = false 
LEFT JOIN registry.object_680_ partners_stuff ON partners_stuff.id = move_mat.attr_4002_ AND partners_stuff.is_deleted = false 

WHERE move_mat.is_deleted = false and move_mat.id = {superid}