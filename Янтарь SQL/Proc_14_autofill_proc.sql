DECLARE
    ------------------------------------------------------------------
    --  parameters JSONB := '{"id": 1, "role_id": 1, "user_id": 129, "s_date": "2025-10-03","s_proc": 3,"new_time": [10, 10], "new_comment": "кабинет 0"}';
    ------------------------------------------------------------------

    do_user     INT  := (parameters ->> 'user_id')::INT;
    s_date      DATE := (parameters ->> 's_date')::DATE;
    s_proc      INT  := (parameters ->> 's_proc')::INT;
    new_time INT[] := CASE
        WHEN parameters ? 'new_time' AND parameters ->> 'new_time' IS NOT NULL THEN
            ARRAY(SELECT jsonb_array_elements_text(parameters -> 'new_time')::INT)
        ELSE NULL
    END;
    new_comment TEXT := parameters ->> 'new_comment';
    attr_time    TEXT;
    attr_comment TEXT;
    attr_plan    TEXT;
    v_sql TEXT;
    col_exists BOOLEAN;
BEGIN
    ------------------------------------------------------------------
    -- 1. Загружаем конфиг процедуры 
    ------------------------------------------------------------------
    SELECT attr_5024_, attr_5025_, attr_5022_
    INTO attr_time, attr_comment, attr_plan
    FROM registry.object_5021_
    WHERE id = s_proc;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Процедура % не найдена в object_5021_', s_proc;
    END IF;

    ------------------------------------------------------------------
    -- 2. Проверки заполненности полей конфигурации
    ------------------------------------------------------------------
    IF attr_plan IS NULL OR attr_plan = '' THEN
        RAISE EXCEPTION 'Для процедуры % не задано поле плана (attr_5022_)', s_proc;
    END IF;

    IF attr_time IS NULL OR attr_time = '' THEN
        RAISE EXCEPTION 'Для процедуры % не задано поле времени (attr_5024_)', s_proc;
    END IF;

    IF attr_comment IS NULL OR attr_comment = '' THEN
        RAISE EXCEPTION 'Для процедуры % не задано поле комментария (attr_5025_)', s_proc;
    END IF;

    ------------------------------------------------------------------
    -- 3. Универсальный UPDATE
    ------------------------------------------------------------------
    v_sql := format($sql$
        UPDATE registry.object_4000_ o
        SET
            %I = COALESCE($1, o.%I),
            %I = COALESCE($2, o.%I),
            operation_user_id = $3
        FROM registry.object_4000_ s
        WHERE o.id = s.id
          AND s.attr_4032_ = $4
          AND s.%I IS NOT NULL
    $sql$,
        attr_time,    attr_time,
        attr_comment, attr_comment,
        attr_plan
    );

    EXECUTE v_sql USING
        new_time, new_comment, do_user, s_date;

END;