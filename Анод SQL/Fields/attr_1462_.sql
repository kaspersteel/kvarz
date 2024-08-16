   SELECT -->>
          CASE
                    WHEN o.attr_1414_ IS NULL THEN o.id
                    ELSE CASE
                              WHEN cp1.attr_1414_ IS NULL THEN cp1.id
                              ELSE CASE
                                        WHEN cp2.attr_1414_ IS NULL THEN cp2.id
                                        ELSE cp2.id
                              END
                    END
          END
     FROM registry.object_1409_ o -->>
LEFT JOIN registry.object_1409_ cp1 ON cp1.id = o.attr_1414_
      AND cp1.is_deleted <> TRUE
LEFT JOIN registry.object_1409_ cp2 ON cp2.id = cp1.attr_1414_
      AND cp2.is_deleted <> TRUE
    WHERE o.is_deleted IS FALSE -->>
 GROUP BY -->>
          cp1.id
        , cp2.id