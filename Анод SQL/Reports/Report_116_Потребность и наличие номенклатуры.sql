     WITH dataset AS (
             SELECT o.attr_607_ order_num
                  , project.attr_1574_ product
                  , nomenclature.attr_1223_ detail
                  , o.attr_1964_ shipping_date
                  , comp.attr_1412_ norm_amount
                  , SUM(comp.attr_1412_) OVER (
                    PARTITION BY nomenclature.attr_376_
                    ) sum_norm_amount
                  , unit.attr_390_ unit
                  , COALESCE(
                    (
                       SELECT SUM(sum_ost.attr_1620_) AS sum_ost
                         FROM registry.object_1617_ sum_ost
                        WHERE sum_ost.is_deleted IS FALSE
                          AND sum_ost.attr_1618_ = comp.attr_1482_
                          AND sum_ost.attr_3951_ IS FALSE /*не давальческая номенклатура*/
                    ) 
                  , 0
                    ) stock_residue
                  , COALESCE(
                    (
                       SELECT SUM(order_nom.attr_1683_)
                         FROM registry.object_1596_ order_to_diler
                    LEFT JOIN registry.object_1679_ order_nom ON order_nom.attr_1682_ = order_to_diler.id
                          AND order_nom.is_deleted IS FALSE
                        WHERE order_to_diler.is_deleted IS FALSE
                          AND order_nom.attr_1680_ = comp.attr_1482_
                          AND order_to_diler.attr_1606_ IN (5, 6)
                     GROUP BY order_nom.attr_1680_
                    )
                  , 0
                    ) on_way
               FROM registry.object_606_ o
          LEFT JOIN registry.object_1227_ project ON o.id = project.attr_1923_
                AND project.is_deleted IS FALSE
          LEFT JOIN registry.object_1409_ comp ON project.id = comp.attr_1423_
                AND comp.is_deleted IS FALSE
          LEFT JOIN registry.object_301_ nomenclature ON nomenclature.id = comp.attr_1482_
          LEFT JOIN registry.object_389_ unit ON unit.id = nomenclature.attr_379_
              WHERE o.is_deleted IS FALSE
                AND o.attr_1926_ NOT IN (1, 10, 13)
                AND comp.attr_3933_ IS FALSE /*не давальческая номенклатура*/
                AND comp.attr_1452_ != 16 /*не материал в спецификации*/
                AND comp.attr_1545_ BETWEEN '{Период.FromDate}' AND ('{Период.ToDate}'::date)
           ORDER BY detail
                  , order_num
          )
   SELECT order_num
        , product
        , detail
        , shipping_date
        , norm_amount
        , sum_norm_amount
        , unit
        , stock_residue
        , on_way
        , CASE
                    WHEN (stock_residue + on_way) - sum_norm_amount >= 0 THEN 0
                    ELSE ABS((stock_residue + on_way) - sum_norm_amount)
          END deficit
     FROM dataset