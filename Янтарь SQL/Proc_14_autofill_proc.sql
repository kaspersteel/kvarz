DECLARE
/*parameters JSONB := '{"id": 1, "role_id": 1, "user_id": 129, "s_date": "2025-10-03","s_proc": 3,"new_time": [10, 10], "new_comment": "кабинет 0"}';*/
do_user INT := (parameters ->> 'user_id')::INT;
s_date DATE := (parameters ->> 's_date')::DATE;
s_proc INT := (parameters ->> 's_proc')::INT;
new_time INT[] := CASE
    WHEN (parameters ? 'new_time') AND (parameters ->> 'new_time') IS NOT NULL THEN
        ARRAY(SELECT jsonb_array_elements_text(parameters -> 'new_time')::INT)
    ELSE NULL END;
new_comment TEXT := (parameters ->> 'new_comment')::TEXT;
v_sql TEXT;
attr_time TEXT;
attr_comment TEXT;
BEGIN
-- Получаем сопоставления из таблицы
SELECT attr_5024_, attr_5025_
INTO attr_time, attr_comment
FROM registry.object_5021_
WHERE id = s_proc
LIMIT 1;
/*IF attr_time IS NULL OR attr_comment IS NULL THEN
    RAISE EXCEPTION 'Не найдено сопоставление полей для s_proc = %', s_proc;
END IF;*/

v_sql := format($sql$
    UPDATE registry.object_4000_ o
    SET
        %I = coalesce (%L, %I),
        %I = coalesce (%L, %I),
		operation_user_id = %s
    FROM (
        SELECT s.id
        FROM registry.object_4000_ s
        LEFT JOIN LATERAL (
            VALUES
                ('lfk1', 1, s.attr_4008_),
                ('lfk2', 2, s.attr_4010_),
                ('bass', 3, s.attr_4012_),
                ('hidro', 4, s.attr_4014_),
                ('ergo', 5, s.attr_4016_),
                ('logo', 6, s.attr_4018_),
                ('pshich', 7, s.attr_4020_),
                ('irt', 8, s.attr_4022_),
                ('mass', 9, s.attr_4024_),
                ('ft', 10, s.attr_4026_),
                ('gt', 11, s.attr_4028_),
                ('sol_p', 12, s.attr_4030_),
                ('girudoterapy', 13, s.attr_4163_),
                ('fitoterapy', 14, s.attr_4166_),
                ('kislorod_cocteil', 15, s.attr_4169_),
                ('soc_cult', 16, s.attr_4252_),
                ('inhal', 17, s.attr_4444_),
                ('presso', 18, s.attr_4447_),
                ('dry_needle', 19, s.attr_4456_),
                ('vtes', 20, s.attr_4459_)
        ) AS P(name_proc, npp_proc, id_plan) ON P.id_plan IS NOT NULL
        WHERE s.attr_4032_ = %L
          AND P.npp_proc = %s
    ) AS sub
    WHERE o.id = sub.id;
$sql$, attr_time, new_time, attr_time, attr_comment, new_comment, attr_comment, do_user, s_date, s_proc);

EXECUTE v_sql;

END