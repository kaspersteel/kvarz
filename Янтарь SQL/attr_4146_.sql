SELECT -->>
CASE
          WHEN o.attr_4148_ = TRUE THEN array_agg (DISTINCT sotr.id)
          WHEN o.attr_4585_ = TRUE THEN array [129] /*array_agg(distinct sotr2.id)||array [o.attr_137_, o.attr_1798_]*/
          ELSE CASE
                    WHEN o.attr_105_ = 2 THEN array [o.attr_3355_]
                    WHEN o.attr_105_ IN (4, 9, 10) THEN array [o.attr_137_, o.attr_3356_]
                    WHEN o.attr_105_ = 6 THEN array [o.attr_137_, o.attr_3356_, o.attr_3373_, o.attr_3374_, o.attr_3498_]
                    WHEN o.attr_105_ = 7 THEN array [o.attr_3436_, o.attr_3374_, o.attr_3498_, o.attr_3355_, o.attr_1798_]
                    WHEN o.attr_105_ = 12 THEN array [92, 113, 110, 109, 111, 112, 115, 46, 126, 62, 63, 64, 65, 66, 67, 94, 96, 97, 104, 124, o.attr_3373_, o.attr_3436_, o.attr_3374_, o.attr_3498_, o.attr_3355_, o.attr_3356_, o.attr_137_ ]
                    WHEN o.attr_105_ = 13 THEN array [o.attr_137_, o.attr_3356_, o.attr_3373_, o.attr_3374_, o.attr_3498_ ]
                    WHEN o.attr_105_ = 14
                         AND array_agg (rez.attr_601_) && array [7, 12, 28, 29 ] THEN array [5, 18, 81, 115, 46, 126, 62, 63, 64, 65, 66, 67, 94, 96, 97, 104, 124, o.attr_137_, o.attr_3356_]
                    WHEN o.attr_105_ = 19 THEN array [o.attr_137_, o.attr_3356_, o.attr_3373_ , o.attr_3374_, o.attr_3498_]
                    WHEN o.attr_105_ = 28 THEN array [92, 113, 110, 109, 111, 112,115, 62, 63, 64, 65, 66, 67, 94, 96, 97, 104, 124, 126, o.attr_137_, o.attr_3357_, o.attr_3356_, o.attr_3373_, o.attr_3355_, o.attr_3436_, o.attr_3374_, o.attr_3498_]
                    WHEN o.attr_105_ = 29 THEN array [o.attr_137_, o.attr_3356_, o.attr_3374_, o.attr_3498_]
                    ELSE array [115, 46]
          END
END
FROM registry.object_102_ o -->>
LEFT JOIN (
             SELECT o1.attr_600_,
                    o1.attr_601_
               FROM registry.object_595_ o1
              WHERE o1.is_deleted <> TRUE
          ) rez ON o.id = rez.attr_600_
LEFT JOIN (
             SELECT o1.id
               FROM registry.object_9_ o1
              WHERE o1.is_deleted <> TRUE
                AND o1.attr_4584_ NOT IN (0, 1, 35)
          ) sotr ON 1 = 1
LEFT JOIN (
             SELECT o1.id
               FROM registry.object_9_ o1
              WHERE o1.is_deleted <> TRUE
                AND o1.attr_4584_ IN (30, 31, 33)
          ) sotr2 ON TRUE
WHERE o.is_deleted IS FALSE -->>
GROUP BY -->>