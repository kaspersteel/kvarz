   SELECT -->
          COALESCE(remnants.attr_2574_, 16)
     FROM registry.object_2111_ o -->>          
LEFT JOIN registry.object_1617_ remnants ON remnants.id = (
             SELECT remnants_max.id
               FROM (
                       SELECT ID
                            , attr_1618_ AS "nom_id"
                            , attr_3951_ AS "given"
                            , attr_2574_ AS "storage"
                            , attr_3131_ AS "value"
                            , MAX(attr_3131_) OVER (
                              PARTITION BY attr_1618_
                                      , attr_3951_
                              ) AS max_value
                         FROM registry.object_1617_
                        WHERE is_deleted IS FALSE
                          AND attr_3131_ > 0
                          AND attr_2574_ <> 14
                    ) remnants_max
              WHERE remnants_max.nom_id = o.attr_2115_
                AND remnants_max.given = o.attr_4121_
                AND remnants_max.max_value = remnants_max.value
              LIMIT 1
          )
    WHERE o.is_deleted IS FALSE -->>
 GROUP BY -->>
          remnants.id