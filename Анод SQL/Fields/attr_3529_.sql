   SELECT -->
    COALESCE(
          o.attr_3529_
        , COALESCE(
          (
             SELECT remnants_nom.storage
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
                    ) remnants_nom
              WHERE remnants_nom.nom_id = o.attr_1458_
                AND remnants_nom.given = o.attr_3933_
                AND remnants_nom.max_value = remnants_nom.value
              LIMIT 1
          ), 16 ))
     FROM registry.object_1409_ o -->>
    WHERE o.is_deleted IS FALSE -->>