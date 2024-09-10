SELECT -->>
CASE
          WHEN o.attr_1429_ IS NULL THEN (
          CASE o.attr_1438_
                    WHEN 1 THEN 3.1415 * (o.attr_1442_ / 2000) * (o.attr_1442_ / 2000) * (o.attr_1439_ / 1000) * o.attr_1428_
                    WHEN 2 THEN o.attr_1441_ / 1000 * o.attr_1439_ / 1000 * o.attr_1440_ / 1000 * o.attr_1428_
                    WHEN 5 THEN (
                    ((o.attr_1442_ / 1000) ^ 2) - ((o.attr_1442_ / 1000) - (o.attr_1441_ / 1000) * 2) ^ 2
                    ) * 3.1415 / 4 * (o.attr_1439_ / 1000) * o.attr_1428_
          END
          )
          ELSE o.attr_1419_ * o.attr_1429_
END
FROM registry.object_1409_ o -->>

WHERE o.is_deleted IS FALSE -->>
GROUP BY -->>