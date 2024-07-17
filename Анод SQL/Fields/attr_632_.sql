--SELECT 
head.id
--FROM registry.object_369_ o
LEFT JOIN registry.object_369_ head ON head.attr_374_ = o.attr_374_
      AND head.attr_1455_ IS NULL
      AND head.is_deleted IS FALSE
--GROUP BY 
head.id