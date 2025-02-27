/*SELECT -устарел
array_to_string( array_remove( array_agg( distinct div_dn_org.id), null), ',') AS dn_divs
FROM registry.object_15_ users
LEFT JOIN registry.object_419_ sotr ON sotr.id = users.attr_509_
      AND NOT sotr.is_deleted
	  AND sotr.attr_1496_ is null
LEFT JOIN registry.object_503_ post ON sotr.attr_505_ = post.id
      AND NOT post.is_deleted
LEFT JOIN registry.object_1544_ division ON sotr.attr_1546_ = division.id
      AND NOT division.is_deleted
LEFT JOIN registry.object_36_ org ON org.attr_285_ = post.id AND org.attr_65_ = division.id
      AND NOT org.is_deleted			
LEFT JOIN registry.object_36_ dn_org ON dn_org.attr_1753_ = org.id OR dn_org.id = org.id
      AND NOT dn_org.is_deleted		
LEFT JOIN registry.object_1544_ div_dn_org ON dn_org.attr_65_ = div_dn_org.id
      AND NOT div_dn_org.is_deleted			
WHERE users.id = {user}::int
GROUP BY  sotr.id,  post.attr_504_, division.attr_1545_ 
HAVING NOT (array_agg(div_dn_org.id) = '{NULL}')*/

SELECT 
array_to_string(  (SELECT ARRAY_AGG ( DISTINCT divs) FROM UNNEST ( odd_org.sub_divs || org.sub_divs ) AS "divs" ), ',' ) AS "dn_divs" 
FROM
	registry.object_15_ users
	LEFT JOIN LATERAL (
	SELECT 
		ARRAY_AGG( attr_65_ ) AS "sub_divs" 
	FROM
		registry.object_36_ o 
	WHERE
		o.ID = ANY ( users.attr_1815_ ) 
		AND NOT o.is_deleted 
	) "org" ON TRUE 
		LEFT JOIN LATERAL (
	SELECT 
	ARRAY_AGG ( distinct odd_sub_org.attr_65_ ) AS "sub_divs"
FROM
	registry.object_36_ odd_org
	LEFT JOIN registry.object_36_ odd_up_org ON odd_up_org.ID = odd_org.attr_1753_ 
	AND odd_up_org.attr_65_ != odd_org.attr_65_ 
	AND NOT odd_up_org.is_deleted 
	LEFT JOIN registry.object_15_ odd_users ON odd_users.attr_506_ = odd_org.attr_285_
	AND NOT odd_users.is_deleted 
	LEFT JOIN registry.object_36_ odd_sub_org ON odd_sub_org.ID = ANY (odd_users.attr_1815_)
	AND NOT odd_sub_org.is_deleted 
WHERE
	odd_org.attr_65_ = ANY ( users.attr_1914_ ) 
	AND NOT odd_org.is_deleted
	AND odd_up_org.id is not null
	) "odd_org" ON TRUE 
    WHERE users.id = {user}::INT