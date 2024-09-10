   SELECT CASE
                    WHEN bbs.attr_4468_ = 1 THEN 'П'
                    ELSE CASE
                              WHEN bbs.attr_4468_ = 2 THEN 'Э'
                              ELSE CASE
                                        WHEN bbs.attr_4468_ = 3 THEN 'В'
                                        ELSE CASE
                                                  WHEN bbs.attr_4468_ = 4 THEN 'Д'
                                        END
                              END
                    END
          END AS type_round
        , TO_CHAR(bbs.attr_4466_, 'DD.MM.YY') AS date_round
        , bbs.attr_4473_ AS point1
        , bbs.attr_4474_ AS point2
        , bbs.attr_4475_ AS point3
        , bbs.attr_4476_ AS point4
        , bbs.attr_4477_ AS point5
        , bbs.attr_4478_ AS point6
        , bbs.attr_4479_ AS point7
        , bbs.attr_4480_ AS point8
        , bbs.attr_4481_ AS point9
        , bbs.attr_4482_ AS point10
        , bbs.attr_4483_ AS point11
        , bbs.attr_4484_ AS point12
        , bbs.attr_4485_ AS point13
        , bbs.attr_4486_ AS point14
        , bbs.ID AS id_bbs
        , bbs.attr_4463_ AS id_hist
     FROM registry.object_4461_ bbs
    WHERE bbs.is_deleted IS FALSE
 ORDER BY bbs.ID
        , bbs.attr_4468_