DO
$$
DECLARE
    ------------------------------------------------------------------
    parameters JSONB := '{"id": 1, "role_id": 1, "user_id": 129, "s_date": "2026-02-16","s_proc": 7,"new_time": [10, 10], "new_comment": "прятки"}';
    ------------------------------------------------------------------

    do_user     INT  := (parameters ->> 'user_id')::INT;
    s_date      DATE := (parameters ->> 's_date')::DATE;
    s_proc      INT  := (parameters ->> 's_proc')::INT;
    new_time INT[] := CASE
        WHEN parameters ? 'new_time' AND jsonb_typeof(parameters -> 'new_time') = 'array' THEN
            ARRAY(SELECT jsonb_array_elements_text(parameters -> 'new_time')::INT)
        ELSE NULL
    END;
    new_comment TEXT := NULLIF(TRIM(parameters ->> 'new_comment'), '');
    attr_time    TEXT;
    attr_comment TEXT;
    attr_plan    TEXT;
    v_sql        TEXT;
    set_parts    TEXT[] := '{}';
    where_parts  TEXT[] := ARRAY[format('o.attr_4032_ = %L', s_date)];
BEGIN
    ------------------------------------------------------------------
    -- 1. Загружаем конфиг процедуры 
    ------------------------------------------------------------------
    SELECT attr_5024_, attr_5025_, attr_5023_
    INTO attr_time, attr_comment, attr_plan
    FROM registry.object_5021_
    WHERE id = s_proc;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Процедура % не найдена в object_5021_', s_proc;
    END IF;

    ------------------------------------------------------------------
    -- 2. Валидация: только обязательное поле времени
    ------------------------------------------------------------------
    IF attr_time IS NULL OR attr_time = '' THEN
        RAISE EXCEPTION 'Для процедуры % не задано поле времени (attr_5024_)', s_proc;
    END IF;
    -- attr_comment и attr_plan могут быть пустыми — разрешено для спецконфигов

    ------------------------------------------------------------------
    -- 3. Формируем SET-часть динамически
    ------------------------------------------------------------------
    -- Обязательное обновление времени
    set_parts := array_append(set_parts, 
        format('%I = COALESCE(%L, o.%I)', 
            attr_time, 
            new_time, 
            attr_time
        )
    );
    
    -- Условное обновление комментария (только если поле указано в конфиге И есть значение)
    IF attr_comment IS NOT NULL AND attr_comment != '' AND new_comment IS NOT NULL THEN
        set_parts := array_append(set_parts,
            format('%I = %L', attr_comment, new_comment)  -- ✅ Прямая подстановка безопасна: new_comment прошёл NULLIF
        );
    END IF;
    
    -- Обязательное обновление пользователя
    set_parts := array_append(set_parts, 
        format('operation_user_id = %s', do_user)
    );

    ------------------------------------------------------------------
    -- 4. Формируем WHERE-часть
    ------------------------------------------------------------------
    -- Условие по плану: применяется ТОЛЬКО если поле указано в конфиге
    IF attr_plan IS NOT NULL AND attr_plan != '' THEN
        where_parts := array_append(where_parts, 
            format('o.%I IS NOT NULL', attr_plan)
        );
    END IF;

    ------------------------------------------------------------------
    -- 5. Собираем и выполняем финальный SQL
    ------------------------------------------------------------------
    v_sql := format(
        'UPDATE registry.object_4000_ o SET %s WHERE %s',
        array_to_string(set_parts, ', '),
        array_to_string(where_parts, ' AND ')
    );
    
    EXECUTE v_sql;

END;
$$ LANGUAGE plpgsql;

SELECT * FROM registry.object_4000_ WHERE attr_4032_ = '2026-02-16' ORDER BY id DESC;