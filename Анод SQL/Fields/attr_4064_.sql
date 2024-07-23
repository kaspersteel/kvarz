--SELECT 
CASE WHEN (COUNT(tab_nakladnaya.ID) FILTER (WHERE tab_nakladnaya.attr_3450_ IS TRUE)
          ) = 0 THEN FALSE ELSE TRUE END
--FROM registry.object_2094_ o
/*ищем задание, для базовой формулы*/
     JOIN registry.object_2093_ task_work ON o.attr_2173_ = task_work.id
      AND task_work.is_deleted IS FALSE
/*ищем требование-накладную*/
     JOIN registry.object_2112_ nakladnaya ON nakladnaya.attr_3415_ = o.id
      AND nakladnaya.is_deleted IS FALSE
/*ищем выдаваемое по ТН*/
     JOIN registry.object_2111_ tab_nakladnaya ON tab_nakladnaya.attr_2126_ = nakladnaya.id
      AND tab_nakladnaya.is_deleted IS FALSE
--GROUP BY 
task_work.id, nakladnaya.id