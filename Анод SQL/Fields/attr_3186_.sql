/*несохраняемая с базовой в attr_3185_*/
   SELECT -->>
          CASE
                    WHEN o.attr_3231_ IS FALSE THEN CASE
                              WHEN remnants.attr_2943_ = 6 THEN NULL
                              ELSE COALESCE(
                              SUM(comp_poz_work.attr_2626_) FILTER (
                                  WHERE comp_poz_work.attr_3176_ IS FALSE
                              )
                            , 0
                              )
                    END
                    ELSE CASE
                              WHEN remnants.attr_2943_ = 6 THEN NULL
                              ELSE COALESCE(SUM(comp_poz_work.attr_2626_), 0)
                    END
          END
     FROM registry.object_3168_ o -->
LEFT JOIN registry.object_2094_ comp_poz_work ON o.id = comp_poz_work.attr_3175_
      AND comp_poz_work.is_deleted IS FALSE
LEFT JOIN registry.object_1659_ remnants ON o.attr_3169_ = remnants.id
      AND remnants.is_deleted IS FALSE
    WHERE o.is_deleted IS FALSE
 GROUP BY -->>
          o.id
        , remnants.attr_2943_