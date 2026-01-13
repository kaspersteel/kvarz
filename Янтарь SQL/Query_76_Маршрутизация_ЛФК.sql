     WITH TIME AS (
             SELECT (
                       SELECT ARRAY_AGG(id)
                         FROM registry.object_4002_
                        WHERE attr_4754_::TIME >= CURRENT_TIME - INTERVAL '30 minutes'
                          AND attr_4754_::TIME < CURRENT_TIME + INTERVAL '30 minutes'
                    ) --	ARRAY[4,5,6] 
					AS search_range,
                    (
                       SELECT id
                         FROM registry.object_4002_
                        WHERE attr_4754_::TIME >= CURRENT_TIME
                          AND attr_4753_::TIME < CURRENT_TIME
                    ) --5 
					AS current_slot
          ),
expanded AS (
  SELECT o.id AS "id", o.attr_4004_ AS "client", o.attr_4005_ AS "hist", ts.attr_4754_::time AS "begin_time", ts.attr_4753_::time AS "end_time"
  FROM registry.object_4000_ o
  JOIN LATERAL unnest(o.attr_4007_) AS intervals(id) ON TRUE
  JOIN registry.object_4002_ ts ON ts.id = intervals.id
  WHERE o.attr_4032_ = CURRENT_DATE
  AND o.attr_4007_ && (SELECT search_range FROM time)
  AND not o.is_deleted

  UNION ALL

  SELECT o.id AS "id", o.attr_4004_ AS "client", o.attr_4005_ AS "hist", ts.attr_4754_::time AS "begin_time", ts.attr_4753_::time AS "end_time"
  FROM registry.object_4000_ o
  JOIN LATERAL unnest(o.attr_4009_) AS intervals(id) ON TRUE
  JOIN registry.object_4002_ ts ON ts.id = intervals.id
  WHERE o.attr_4032_ = CURRENT_DATE
  AND o.attr_4009_ && (SELECT search_range FROM time)
),
ordered AS (
  SELECT
    id,
	  client,
	  hist,
    begin_time,
    end_time,
    lag(end_time) OVER (PARTITION BY id, client, hist ORDER BY begin_time) AS "prev_end"
  FROM expanded
),
grouped AS (
  SELECT
    id, 
    client, 
    hist,
    begin_time,
    end_time,
    SUM(CASE WHEN prev_end = begin_time THEN 0 ELSE 1 END) OVER (PARTITION BY id, client, hist  ORDER BY begin_time) AS "grp"
  FROM ordered
),
merged AS (
  SELECT
    id,
    client, 
    hist,
    MIN(begin_time) AS "interval_begin",
    MAX(end_time) AS "interval_end"
  FROM grouped
  GROUP BY id, client, hist , grp
), 
merged_data AS (
SELECT
    merged.id,
    merged.client, 
    merged.hist ,
    clients.attr_69_ AS "fio",
	  STRING_AGG (' Дневник ' || diaries.id || ' На дату ' || diaries.attr_331_ || ' Создан ' || diaries.attr_650_, E';\n') AS diary,
    to_char(merged.interval_begin, 'HH24:MI')  || ' - ' || to_char(merged.interval_end, 'HH24:MI') AS "time_proc",
MAX (CASE 
    WHEN diaries.attr_650_ IS NOT NULL
         AND diaries.attr_650_ + INTERVAL '10 minutes' BETWEEN (CURRENT_DATE + merged.interval_begin) AND (CURRENT_DATE + merged.interval_end)
         AND CURRENT_TIMESTAMP > (CURRENT_DATE + merged.interval_end) THEN 'Выполнено'

    WHEN diaries.attr_650_ IS NOT NULL
         AND diaries.attr_650_ + INTERVAL '10 minutes' BETWEEN (CURRENT_DATE + merged.interval_begin) AND (CURRENT_DATE + merged.interval_end)
         AND CURRENT_TIMESTAMP BETWEEN (CURRENT_DATE + merged.interval_begin) AND (CURRENT_DATE + merged.interval_end) THEN 'Исполняется'

    WHEN diaries.attr_650_ IS NULL
         AND CURRENT_TIME > (merged.interval_begin + INTERVAL '10 minutes') THEN 'Просрочено'

    WHEN diaries.attr_650_ IS NOT NULL
         AND diaries.attr_650_ BETWEEN ((CURRENT_DATE + merged.interval_begin) - INTERVAL '10 minutes') AND (CURRENT_DATE + merged.interval_begin) THEN 'Ожидает'
		 
	WHEN diaries.attr_650_ IS NOT NULL THEN 'Дневник создан вручную'

    WHEN diaries.id IS NULL THEN 'Назначено'

    ELSE ''
END) AS "status",

MAX (CASE 
    WHEN diaries.attr_650_ IS NOT NULL
         AND diaries.attr_650_ + INTERVAL '10 minutes' BETWEEN (CURRENT_DATE + merged.interval_begin) AND (CURRENT_DATE + merged.interval_end)
         AND CURRENT_TIMESTAMP > (CURRENT_DATE + merged.interval_end) THEN '#A8A8A8'

    WHEN diaries.attr_650_ IS NOT NULL
         AND diaries.attr_650_ + INTERVAL '10 minutes' BETWEEN (CURRENT_DATE + merged.interval_begin) AND (CURRENT_DATE + merged.interval_end)
         AND CURRENT_TIMESTAMP BETWEEN (CURRENT_DATE + merged.interval_begin) AND (CURRENT_DATE + merged.interval_end) THEN '#7CBF7C'

    WHEN diaries.attr_650_ IS NULL
         AND CURRENT_TIME > (merged.interval_begin + INTERVAL '10 minutes') THEN '#D46A6A'

    WHEN diaries.attr_650_ IS NOT NULL
         AND diaries.attr_650_ BETWEEN ((CURRENT_DATE + merged.interval_begin) - INTERVAL '10 minutes') AND (CURRENT_DATE + merged.interval_begin) THEN '#E3D27A'
		 
	WHEN diaries.attr_650_ IS NOT NULL THEN '#9C7AA3'

    WHEN diaries.id IS NULL THEN '#5A9BD5'

    ELSE '#fff'
END) AS "row_color"

FROM merged
LEFT JOIN registry.object_45_ clients ON clients.id = merged.client
LEFT JOIN registry.object_309_ diaries ON not diaries.is_deleted 
AND diaries.attr_311_ = merged.hist 
AND diaries.attr_2325_ in (1, 11)
AND diaries.attr_650_ >= CURRENT_TIMESTAMP - INTERVAL '60 minutes' --'2025-08-18 09:25:00'
AND diaries.attr_650_  < CURRENT_TIMESTAMP + INTERVAL '60 minutes' --'2025-08-18 10:25:00'
AND diaries.attr_331_ = CURRENT_DATE
GROUP BY merged.id, merged.client, merged.hist, merged.interval_begin, merged.interval_end, clients.id

UNION ALL

SELECT
    null AS "id",
    null AS "client", 
    null AS "hist",
    '' AS "fio",
	null AS "diary",
	null AS "time_proc",
	'нет назначений' AS "status",
	'#C1B7A4' AS "row_color"
WHERE NOT EXISTS (SELECT 1 FROM merged)
)

SELECT * FROM merged_data

ORDER BY time_proc, fio