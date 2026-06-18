DO $$
DECLARE
    parameters JSONB := '{"id": 12, "role_id": 1, "user_id": 31}';
    do_user INT := (parameters ->> 'user_id')::INT;
    spec_id BIGINT := (parameters ->> 'id')::BIGINT;
    need_id BIGINT;
    spec_row_count INT;
    need_row_count INT;
    row_rec RECORD;
    row_num INT := 0;
BEGIN
    -- ============================================
    -- ОСНОВНОЙ КОД ПРОЦЕДУРЫ
    -- ============================================
    
    -- Создаем шапку Потребности (реестр 621)
    INSERT INTO registry.object_621_ (
        attr_623_,  -- спецификация
        attr_625_,  -- номер (пустой)
        attr_626_,  -- дата
        attr_639_,  -- вид
        operation_user_id
    ) VALUES (
        spec_id,
        NULL,
        CURRENT_DATE,
        1,
        do_user
    )
    RETURNING id INTO need_id;

    IF need_id IS NULL THEN
        RAISE EXCEPTION 'Не удалось создать потребность из спецификации %', spec_id;
    END IF;

    -- Создаем табличную часть Потребности (реестр 622)
    INSERT INTO registry.object_622_ (
        attr_624_,  -- потребность (шапка)
        attr_629_,  -- материал под высадку
        attr_630_,  -- материал подката
        attr_633_,  -- номер строки по порядку
        attr_634_,  -- количество
        attr_636_,  -- ед. изм.
        attr_641_,  -- типоразмер
        attr_642_,  -- длина
        attr_643_,  -- партия
        attr_644_,  -- стандарт
        attr_646_,  -- номенклатура
        operation_user_id
    )
    SELECT 
        need_id,
        material_norm.attr_188_,  -- материал под высадку
        material_norm.attr_200_,  -- материал подката
        ROW_NUMBER() OVER (ORDER BY spec_row.id)::INT,  -- номер строки по порядку
        spec_row.attr_522_,  -- количество из спецификации
        spec_row.attr_521_,  -- ед. изм. из спецификации
        nomenclature.attr_431_,  -- типоразмер
        nomenclature.attr_104_,  -- длина
        batch.id,  -- партия (ближайшее меньшее к количеству в тыс. шт.)
        nomenclature.attr_109_,  -- стандарт
        nomenclature.id,  -- номенклатура
        do_user
    FROM registry.object_500_ spec_row
    LEFT JOIN registry.object_97_ nomenclature 
        ON spec_row.attr_520_ = nomenclature.id 
        AND nomenclature.is_deleted IS NOT TRUE
    LEFT JOIN LATERAL (
        SELECT id
        FROM registry.object_157_
        WHERE is_deleted IS NOT TRUE
          AND attr_158_ <= spec_row.attr_522_ * 1000
        ORDER BY attr_158_ DESC
        LIMIT 1
    ) batch ON TRUE
    LEFT JOIN LATERAL (
        SELECT attr_188_, attr_200_
        FROM registry.object_183_
        WHERE is_deleted IS NOT TRUE
          AND attr_246_ = nomenclature.attr_109_
          AND attr_185_ = nomenclature.attr_101_
          AND attr_186_ = nomenclature.attr_102_
          AND attr_184_ = nomenclature.attr_99_
          AND attr_197_ = batch.id
        ORDER BY attr_190_ ASC
        LIMIT 1
    ) material_norm ON TRUE
    WHERE spec_row.attr_519_ = spec_id
      AND spec_row.is_deleted IS NOT TRUE;

    -- ============================================
    -- ПРОВЕРКИ СОЗДАНИЯ ЗАПИСЕЙ
    -- ============================================
    
    -- Проверка 1: Количество строк в спецификации
    SELECT COUNT(*)
    INTO spec_row_count
    FROM registry.object_500_
    WHERE attr_519_ = spec_id
      AND is_deleted IS NOT TRUE;

    -- Проверка 2: Количество созданных строк в потребности
    SELECT COUNT(*)
    INTO need_row_count
    FROM registry.object_622_
    WHERE attr_624_ = need_id;

    -- Проверка 3: Все строки имеют корректную ссылку на шапку
    IF (SELECT COUNT(*) FROM registry.object_622_ WHERE attr_624_ = need_id) != need_row_count THEN
        RAISE EXCEPTION 'Не все строки ссылаются на шапку потребности';
    END IF;

    -- Проверка 4: Проверка заполнения обязательных полей
    IF (SELECT COUNT(*) FROM registry.object_622_ 
        WHERE attr_624_ = need_id 
          AND attr_634_ IS NOT NULL 
          AND attr_636_ IS NOT NULL) != need_row_count THEN
        RAISE EXCEPTION 'Не все обязательные поля заполнены';
    END IF;

    -- Проверка 5: Количество строк 
        RAISE NOTICE 'Количество строк: в спецификации %, в потребности %', spec_row_count, need_row_count;

    -- ============================================
    -- ДЕТАЛЬНАЯ ИНФОРМАЦИЯ О СОЗДАННЫХ ЗАПИСЯХ
    -- ============================================
    
    RAISE NOTICE '';
    RAISE NOTICE '========================================================';
    RAISE NOTICE 'ДЕТАЛЬНАЯ ИНФОРМАЦИЯ О СОЗДАННЫХ ЗАПИСЯХ';
    RAISE NOTICE '========================================================';
    
    -- Информация о шапке Потребности (реестр 621)
    RAISE NOTICE '';
    RAISE NOTICE '--- ШАПКА ПОТРЕБНОСТИ (реестр 621) ---';
    RAISE NOTICE 'ID потребности: %', need_id;
    
    SELECT attr_623_, attr_625_, attr_626_, attr_639_, create_date, create_user_id
    INTO row_rec
    FROM registry.object_621_
    WHERE id = need_id;
    
    RAISE NOTICE '  Спецификация (attr_623_): %', row_rec.attr_623_;
    RAISE NOTICE '  Номер (attr_625_): %', COALESCE(row_rec.attr_625_, '<пусто>');
    RAISE NOTICE '  Дата (attr_626_): %', row_rec.attr_626_;
    RAISE NOTICE '  Вид (attr_639_): %', row_rec.attr_639_;
    RAISE NOTICE '  Дата создания: %', row_rec.create_date;
    RAISE NOTICE '  Пользователь создания: %', row_rec.create_user_id;
    
    -- Информация о табличной части Потребности (реестр 622)
    RAISE NOTICE '';
    RAISE NOTICE '--- ТАБЛИЧНАЯ ЧАСТЬ ПОТРЕБНОСТИ (реестр 622) ---';
    RAISE NOTICE 'Всего строк создано: %', need_row_count;
    RAISE NOTICE '';
    
    FOR row_rec IN
        SELECT 
            id,
            attr_624_,  -- потребность
            attr_629_,  -- материал
            attr_630_,  -- норма расхода
            attr_631_,
            attr_632_,
            attr_633_,
            attr_634_,  -- количество
            attr_635_,
            attr_636_,  -- ед. изм.
            attr_637_,
            attr_640_,
            attr_641_,  -- из номенклатуры
            attr_642_,  -- из номенклатуры
            attr_643_,  -- партия
            attr_644_,  -- из номенклатуры
            create_date,
            create_user_id
        FROM registry.object_622_
        WHERE attr_624_ = need_id
        ORDER BY id
    LOOP
        row_num := row_num + 1;
        RAISE NOTICE '  Строка #%:', row_num;
        RAISE NOTICE '    ID строки: %', row_rec.id;
        RAISE NOTICE '    Потребность (attr_624_): %', row_rec.attr_624_;
        RAISE NOTICE '    Материал (attr_629_): %', COALESCE(row_rec.attr_629_::TEXT, '<NULL>');
        RAISE NOTICE '    Норма расхода (attr_630_): %', COALESCE(row_rec.attr_630_::TEXT, '<NULL>');
        RAISE NOTICE '    Количество (attr_634_): %', COALESCE(row_rec.attr_634_::TEXT, '<NULL>');
        RAISE NOTICE '    Ед. изм. (attr_636_): %', COALESCE(row_rec.attr_636_::TEXT, '<NULL>');
        RAISE NOTICE '    attr_641_ (из 97.attr_431_): %', COALESCE(row_rec.attr_641_::TEXT, '<NULL>');
        RAISE NOTICE '    attr_642_ (из 97.attr_104_): %', COALESCE(row_rec.attr_642_::TEXT, '<NULL>');
        RAISE NOTICE '    Партия (attr_643_): %', COALESCE(row_rec.attr_643_::TEXT, '<NULL>');
        RAISE NOTICE '    attr_644_ (из 97.attr_109_): %', COALESCE(row_rec.attr_644_::TEXT, '<NULL>');
        RAISE NOTICE '    attr_631_: %, attr_632_: %, attr_633_: %, attr_635_: %, attr_637_: %, attr_640_: %',
            COALESCE(row_rec.attr_631_::TEXT, '<NULL>'),
            COALESCE(row_rec.attr_632_::TEXT, '<NULL>'),
            COALESCE(row_rec.attr_633_::TEXT, '<NULL>'),
            COALESCE(row_rec.attr_635_::TEXT, '<NULL>'),
            COALESCE(row_rec.attr_637_::TEXT, '<NULL>'),
            COALESCE(row_rec.attr_640_::TEXT, '<NULL>');
        RAISE NOTICE '    Дата создания: %, Пользователь: %', row_rec.create_date, row_rec.create_user_id;
        RAISE NOTICE '    --------------------------------------------------';
    END LOOP;
    
    ROLLBACK;

END $$;