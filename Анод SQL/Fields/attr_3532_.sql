CASE
          WHEN (
             SELECT COUNT(rezolution.*)
               FROM registry.object_3533_ rezolution
              WHERE rezolution.is_deleted <> TRUE
                AND rezolution.attr_3534_ = o.id
                AND rezolution.attr_3535_ = o.attr_26_
          ) = 0 THEN TRUE
          ELSE FALSE
END