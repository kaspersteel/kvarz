BEGIN;

DO $$
DECLARE 
    /*parameters JSONB := '{"id": 183, "role_id": 1, "user_id": 46, "tab-mat_rows": [{"attr_115_":1496},{"attr_115_":1497},{"attr_115_":1498}]}';*/
    do_user INT := (parameters ->> 'user_id')::INT;
    invoice_id BIGINT := (parameters ->> 'id')::BIGINT;
    npp_request INT; -- очередной номер создаваемой заявки
    new_request_id BIGINT; -- id созданной заявки
    tab_invoice RECORD; -- запись о материале в накладной
    old_rems BOOLEAN; -- флаг ввода первичных остатков
    v_mat_rows_ids BIGINT[]; -- переданный массив записей материалов
    
    /* переменные батч-цикла создания заявок */
    lh_ids_tab_invoice INT; -- количество принятых единиц по ключу (поставщик-материал-плавка-партия)
    v_batch_size INT := 1000; -- количество образцов в одной заявке (1000 - чтобы не делились)
    v_from INT := 1;
    v_to INT;
    v_slice BIGINT[];
    
    /* Переменные для проверок */
    v_rows_affected INT;
    v_loop_executed BOOLEAN := FALSE;

BEGIN

    /* 1. Преобразование JSON-массива в BIGINT[] с фильтрацией уже существующих записей */
    SELECT array_agg(raw_ids.id_val)
      INTO v_mat_rows_ids
      FROM (
          SELECT (elem->>'attr_115_')::BIGINT AS id_val
          FROM jsonb_array_elements(parameters -> 'tab-mat_rows') AS elem
          WHERE elem->>'attr_115_' IS NOT NULL
      ) AS raw_ids
      WHERE NOT EXISTS (
          -- Оставляем только те ID, которых НЕТ в attr_127_ реестра 124 (исключая удаленные)
          SELECT 1
          FROM registry.object_124_ t124
          WHERE t124.attr_127_ = raw_ids.id_val
            AND NOT t124.is_deleted
      );

    /* 2. Проверка: массив ID материалов пуст или не указан */
    IF v_mat_rows_ids IS NULL OR cardinality(v_mat_rows_ids) = 0 THEN
        RAISE EXCEPTION 'Список ID материалов (tab-mat_rows) пуст или не указан в parameters. Либо переданные материалы уже есть в заявках';
    END IF;

    /* 3. Получение очередного номера заявки */
    SELECT COALESCE(MAX(attr_279_) + 1, 1)
           INTO npp_request
      FROM registry.object_118_
     WHERE is_deleted IS NOT TRUE
       AND attr_121_ >= date_trunc('year', CURRENT_DATE)::date
       AND attr_121_ <  (date_trunc('year', CURRENT_DATE)::date + interval '1 year');
       
    SELECT attr_872_ INTO old_rems FROM registry.object_103_ WHERE id = invoice_id;

    /* 4. Получаем записи материалов со статусом "ВК" по переданным ID и группируем их */
    FOR tab_invoice IN (
       SELECT array_agg(tab.id ORDER BY tab.attr_110_, tab.id) AS ids_tab_invoice,
              tab.attr_94_ AS id_material,
              tab.attr_96_ AS n_melting,
              tab.attr_267_ AS n_party
         FROM registry.object_30_ tab
        WHERE tab.id = ANY(v_mat_rows_ids)
          AND (old_rems is true OR tab.attr_808_ = 2)
          AND tab.is_deleted is not true
     GROUP BY tab.attr_110_, tab.attr_94_, tab.attr_96_, tab.attr_267_
    ) LOOP
        v_loop_executed := TRUE;
        lh_ids_tab_invoice := array_length(tab_invoice.ids_tab_invoice, 1);
        v_from := 1;
        /* запускаем батч-цикл создания заявок с делением количества образцов */
        WHILE v_from <= lh_ids_tab_invoice LOOP
            /* конец части массива */
            v_to := LEAST(v_from + v_batch_size - 1, lh_ids_tab_invoice);
            /* батч-массив */
            v_slice := tab_invoice.ids_tab_invoice[v_from:v_to];
            
            /* создание заявки на ВК */
            INSERT INTO registry.object_118_ (
                attr_121_, -- дата
                attr_138_, -- статус (1-создана)
                attr_278_, -- приходная накладная
                attr_279_, -- №пп
                attr_292_, -- автор
                attr_756_, -- приоритет
                attr_759_, -- материал
                attr_760_, -- плавка
                attr_761_, -- партия,
                attr_999_, -- флаг ввода первичных остатков
                attr_950_, -- параметры с фронта
                operation_user_id
            )
            VALUES (
                CASE WHEN old_rems THEN NULL ELSE CURRENT_DATE END, 
                1, 
                invoice_id, 
                CASE WHEN old_rems THEN 0 ELSE npp_request END,
                do_user, 
                1,
                tab_invoice.id_material, 
                tab_invoice.n_melting, 
                tab_invoice.n_party,
                old_rems,
                jsonb_pretty(parameters), 
                do_user
            )
            RETURNING id INTO new_request_id;

            /* Проверка: запись в registry.object_118_ создана */
            IF new_request_id IS NULL THEN
                RAISE EXCEPTION 'Не удалось создать запись заявки в object_118_';
            END IF;

            /* создание таблицы заявки на ВК */
            /* Массовая вставка всех строк заявки за один запрос */
            INSERT INTO registry.object_124_ (
                attr_126_, -- заявка
                attr_127_, -- ед. хранения
                attr_130_, -- количество
                attr_131_, -- №№ образцов
                attr_132_, -- лабораторные испытания
                attr_272_, -- №пп
                attr_285_, -- приходная накладная
                attr_289_, -- на печать
                attr_762_, -- статус заключения
                operation_user_id
			)
            SELECT new_request_id, 
                arr.id,
                COALESCE(mat_dir.attr_856_, up_mat_dir.attr_856_, 1)::text,
                samples.n::text,
                COALESCE(mat_dir.attr_755_, up_mat_dir.attr_755_),
                arr.rn,
                invoice_id, 
                TRUE, 
                3, 
                do_user
            FROM unnest(v_slice) WITH ORDINALITY AS arr(id, rn)
            JOIN registry.object_30_ smp ON smp.id = arr.id
            LEFT JOIN registry.object_58_ mat_dir ON mat_dir.id = smp.attr_94_ AND NOT mat_dir.is_deleted
            LEFT JOIN registry.object_58_ up_mat_dir ON up_mat_dir.id = mat_dir.attr_61_ AND NOT up_mat_dir.is_deleted
            LEFT JOIN LATERAL ( 
                SELECT string_agg(concat_ws(', ', smp.attr_97_||'-'||gs.seq_num), ' ,') AS n
                FROM generate_series(1, COALESCE(mat_dir.attr_856_, up_mat_dir.attr_856_, 1)) AS gs(seq_num) 
            ) samples ON true;

            /* Проверка */
            GET DIAGNOSTICS v_rows_affected = ROW_COUNT;
            IF v_rows_affected != array_length(v_slice, 1) THEN
                RAISE EXCEPTION 'Не все записи созданы в object_124_. Ожидалось %, создано %', 
                                array_length(v_slice, 1), v_rows_affected;
            END IF;

            /* Массовое обновление всех единиц хранения за один запрос */
            UPDATE registry.object_30_
            SET attr_269_ = new_request_id,
                operation_user_id = do_user
            WHERE id = ANY(v_slice);

            /* Проверка */
            GET DIAGNOSTICS v_rows_affected = ROW_COUNT;
            IF v_rows_affected != array_length(v_slice, 1) THEN
                RAISE EXCEPTION 'Не все записи обновлены в object_30_. Ожидалось %, обновлено %', 
                                array_length(v_slice, 1), v_rows_affected;
            END IF;
            
            /* начало новой части массива */
            v_from := v_from + v_batch_size;
            /* номер следующей заявки */
            npp_request := npp_request + 1; 
        END LOOP;
        
    END LOOP;
    
    /* Проверка: цикл по записям вообще выполнился */
    IF NOT v_loop_executed THEN
        RAISE EXCEPTION 'Не найдено записей для обработки в object_30_ по переданным ID со статусом "ВК" (attr_808_ = 2).';
    END IF;

END $$;

-- 1. Просмотр созданных заявок (реестр 118)
SELECT 
    id AS id_zayavki,
    attr_279_ AS npp_zayavki,
    attr_278_ AS id_nakladnoy,
    attr_756_ AS id_materiala,
    attr_759_ AS nomer_plavki,
    attr_760_ AS nomer_partii,
    attr_121_ AS data_zayavki
FROM registry.object_118_
WHERE attr_278_ = 183 -- <-- ЗАМЕНИТЕ на ваш invoice_id
  AND NOT is_deleted
ORDER BY id DESC;

-- 2. Просмотр созданных строк табличной части заявок (реестр 124)
SELECT 
    id AS id_stroki,
    attr_126_ AS id_zayavki,
    attr_127_ AS id_ed_hr,
    attr_272_ AS npp,
    attr_285_ AS id_nakladnoy
FROM registry.object_124_
WHERE attr_285_ = 183 -- <-- ЗАМЕНИТЕ на ваш invoice_id
  AND NOT is_deleted
ORDER BY id DESC;

-- 3. Просмотр обновленных записей материалов (реестр 30)
SELECT 
    id AS id_materiala_v_nakladnoy,
    attr_110_ AS id_nakladnoy,
    attr_808_ AS status,
    attr_269_ AS id_privyazannoy_zayavki
FROM registry.object_30_
WHERE attr_269_ IN (
    SELECT id 
    FROM registry.object_118_ 
    WHERE attr_278_ = 183 -- <-- ЗАМЕНИТЕ на ваш invoice_id
      AND NOT is_deleted
)
ORDER BY id;

ROLLBACK;