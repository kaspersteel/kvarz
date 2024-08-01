   SELECT -->>
          COALESCE(
          (
             SELECT SUM(ost_mat.attr_1675_) AS materials_residue
               FROM registry.object_1659_ ost_mat
              WHERE ost_mat.is_deleted <> TRUE
                AND ost_mat.attr_3952_ = o.attr_3934_
                AND (
                    o.attr_1425_ = ost_mat.attr_1663_
                AND o.attr_1426_ = ost_mat.attr_1664_
                AND o.attr_1448_ = ost_mat.attr_1665_
                    )
                 OR (
                    o.attr_1425_ = ost_mat.attr_1663_
                AND o.attr_1426_ IS NULL
                AND o.attr_1448_ IS NULL
                AND ost_mat.attr_1664_ IS NULL
                AND ost_mat.attr_1665_ IS NULL
                    )
          )
        , 0
          )
     FROM registry.object_1409_ o -->>
    WHERE o.is_deleted IS FALSE -->>
 GROUP BY -->>