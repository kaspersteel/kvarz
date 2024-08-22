   SELECT CASE
                    WHEN mfs.attr_4525_ = 1 THEN 'П'
                    ELSE CASE
                              WHEN mfs.attr_4525_ = 2 THEN 'Э'
                              ELSE CASE
                                        WHEN mfs.attr_4525_ = 3 THEN 'В'
                                        ELSE CASE
                                                  WHEN mfs.attr_4525_ = 4 THEN 'Д'
                                        END
                              END
                    END
          END AS type_round
        , TO_CHAR(mfs.attr_4523_, 'DD.MM.YY') AS date_round
        , mfs.attr_4530_ AS point1
        , mfs.attr_4531_ AS point2
        , mfs.attr_4532_ AS point3
        , mfs.attr_4533_ AS point4
        , mfs.attr_4534_ AS point5
        , mfs.attr_4535_ AS point6
        , mfs.ID AS id_mfs
        , mfs.attr_4520_ AS id_hist
     FROM registry.object_4518_ mfs
    WHERE mfs.is_deleted IS FALSE
 ORDER BY mfs.ID
        , mfs.attr_4525_