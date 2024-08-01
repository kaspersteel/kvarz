   SELECT -->>
          COALESCE(
          (
             SELECT SUM(sum_ost.attr_1620_) AS sum_ost
               FROM registry.object_1617_ sum_ost
              WHERE sum_ost.is_deleted <> TRUE
                AND sum_ost.attr_1618_ = o.attr_1458_
                AND sum_ost.attr_3951_ = o.attr_3933_
          )
        , 0
          )
     FROM registry.object_1409_ o -->>
    WHERE o.is_deleted IS FALSE -->>
 GROUP BY -->>