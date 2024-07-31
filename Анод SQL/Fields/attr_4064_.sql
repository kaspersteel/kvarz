--SELECT 
CASE
          WHEN (
          COUNT(tab_nakladnaya.ID) FILTER (
              WHERE tab_nakladnaya.attr_3450_ IS TRUE
          )
          ) = 0 THEN FALSE
          ELSE TRUE
END
--FROM registry.object_2094_ o
/*ищем задание, для базовой формулы*/
LEFT JOIN registry.object_2093_ task_work ON o.attr_2173_ = task_work.id
      AND task_work.is_deleted IS FALSE
          /*ищем требование-накладную*/
LEFT JOIN registry.object_2112_ nakladnaya ON nakladnaya.attr_3415_ = o.id
      AND nakladnaya.id IN (
             SELECT nakladnaya.id
               FROM registry.object_2112_ nakladnaya
          LEFT JOIN registry.object_2111_ tab_nakladnaya ON tab_nakladnaya.attr_2126_ = nakladnaya.id
                AND tab_nakladnaya.is_deleted IS FALSE
           GROUP BY nakladnaya.id
             HAVING COUNT(tab_nakladnaya.id) > 0
          )
      AND nakladnaya.is_deleted IS FALSE
          /*ищем выдаваемое по ТН*/
LEFT JOIN registry.object_2111_ tab_nakladnaya ON tab_nakladnaya.attr_2126_ = nakladnaya.id
      AND tab_nakladnaya.is_deleted IS FALSE
--GROUP BY 
task_work.id, nakladnaya.id