SELECT
          o.id AS "id_sotr",
          o.attr_424_ AS "fio_sotr",
          post.attr_504_ AS "name_post",
          division.attr_1545_ AS "name_div",
	    array_remove(array_agg(distinct div_dn_org.id), null) AS dn_divs
FROM registry.object_419_ o
LEFT JOIN registry.object_503_ post ON o.attr_505_ = post.id
      AND NOT post.is_deleted
LEFT JOIN registry.object_1544_ division ON o.attr_1546_ = division.id
      AND NOT division.is_deleted
LEFT JOIN registry.object_36_ org ON org.attr_285_ = post.id AND org.attr_65_ = division.id
      AND NOT org.is_deleted			
LEFT JOIN registry.object_36_ dn_org ON dn_org.attr_1753_ = org.id
      AND NOT dn_org.is_deleted		
LEFT JOIN registry.object_503_ post_dn_org ON dn_org.attr_285_ = post_dn_org.id
      AND NOT post_dn_org.is_deleted
LEFT JOIN registry.object_1544_ div_dn_org ON dn_org.attr_65_ = div_dn_org.id
      AND NOT div_dn_org.is_deleted			
WHERE NOT o.is_deleted
AND o.attr_1496_ is null
GROUP BY  o.id,  post.attr_504_, division.attr_1545_ 
HAVING NOT (array_agg(div_dn_org.id) = '{NULL}')
ORDER BY fio_sotr, name_div