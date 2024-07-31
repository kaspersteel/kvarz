CASE
          WHEN o.attr_2152_ IS NULL
                AND o.attr_2609_ IS NULL
                AND o.attr_2610_ IS NULL
                AND o.attr_2611_ IS NULL THEN (
                       SELECT CASE
                                        WHEN o1.attr_2609_ IS NOT NULL THEN o1.attr_2609_
                                        ELSE o1.attr_2152_
                              END
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2148_ = o.attr_2148_
                          AND o1.attr_3208_ < o.attr_3208_
                     ORDER BY o1.attr_3208_ DESC
                        LIMIT 1
                    )
                    ELSE CASE
                              WHEN o.attr_2609_ IS NULL
                                    AND o.attr_2610_ IS NULL
                                    AND o.attr_2611_ IS NULL THEN o.attr_2152_
                                        ELSE (
                                        CASE
                                                  WHEN o.attr_2609_ IS NULL THEN 0
                                                  ELSE o.attr_2609_
                                        END + CASE
                                                  WHEN o.attr_2610_ IS NULL THEN 0
                                                  ELSE o.attr_2610_
                                        END + CASE
                                                  WHEN o.attr_2611_ IS NULL THEN 0
                                                  ELSE o.attr_2611_
                                        END
                                        )
                    END
END