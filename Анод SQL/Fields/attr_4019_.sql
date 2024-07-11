--SELECT
CASE 
	WHEN (o.attr_3244_ is not null and o.attr_3244_ = 2) THEN
		concat ( o.attr_3252_, '/', o.attr_3251_ ) 
	ELSE '-'
END
--FROM registry.object__ o

--GROUP BY