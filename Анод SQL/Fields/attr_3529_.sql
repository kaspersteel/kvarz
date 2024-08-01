   SELECT -->
          COALESCE(
          o.attr_3529_
        , (
             SELECT remnants_nom.storage
               FROM (
                       SELECT ID
                            , attr_1618_ AS nom_id
                            , attr_3951_ AS given
                            , attr_2574_ AS STORAGE
                            , attr_1620_ AS VALUE
                            , MAX(attr_1620_) OVER (
                              PARTITION BY attr_1618_
                                      , attr_3951_
                              ) AS max_value
                         FROM registry.object_1617_
                        WHERE is_deleted IS FALSE
                    ) remnants_nom
              WHERE remnants_nom.nom_id = o.attr_1458_
                AND remnants_nom.given = o.attr_3933_
                AND remnants_nom.max_value = remnants_nom.value
              LIMIT 1
          )
          )