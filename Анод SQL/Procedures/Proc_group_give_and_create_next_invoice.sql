  DECLARE 

storage_param INT := (parameters ->> 'storage_param')::INT;

do_user INT := (parameters ->> 'user_id')::INT;

invoice RECORD := (
   SELECT *
     FROM registry.object_2112_ current_invoice
    WHERE current_invoice.id = (parameters ->> 'id')::INT
);

tab_invoice_ids INT[] := (
   SELECT ARRAY_AGG(id)
     FROM registry.object_2111_
    WHERE attr_2126_ = invoice.id
      AND is_deleted IS FALSE
);

count_process_tab_invoice INT := 0;

copy_invoice_ids INT[];

copy_tab_invoice_ids INT[];

tab_invoice RECORD;

ostatok INT;

    BEGIN 
      FOR tab_invoice IN (
   SELECT tab.id AS id_tab_invoice,
          COALESCE(remnants.attr_3910_, 0) + COALESCE(tab.attr_3423_, 0) AS count_in_assemble,
          COALESCE(remnants.attr_1620_, 0) - COALESCE(tab.attr_3423_, 0) AS current_count_remnants,
          COALESCE(remnants.attr_1677_, 0) - COALESCE(tab.attr_3423_, 0) AS reserved_count_remnants,
          tab.attr_4128_ AS id_remnants,
          tab.attr_2115_ AS sign_nom,
          tab.attr_3421_ AS name_nom,
          tab.attr_3423_ AS COUNT
     FROM registry.object_2111_ tab
          /*ищем остатки для подбора по складу*/
LEFT JOIN registry.object_1617_ remnants ON remnants.id = tab.attr_4128_
      AND remnants.is_deleted IS FALSE
    WHERE tab.attr_2126_ = invoice.id
      AND tab.is_deleted IS FALSE
          /*ещё не выдано*/
      AND tab.attr_3450_ IS FALSE
          /*подбор по зафиксированному остатку и id склада, переданному при запуске команды в параметре storage_param*/
      AND CASE
                    WHEN storage_param IS NULL
                          AND remnants.attr_2574_ IS NOT NULL THEN TRUE
                              WHEN storage_param IS NOT NULL
                          AND remnants.attr_2574_ = storage_param THEN TRUE
          END
) LOOP
/*списание номенклатуры с остатка*/
   UPDATE registry.object_1617_
      SET attr_3910_ = tab_invoice.count_in_assemble,
          attr_1620_ = tab_invoice.current_count_remnants,
          attr_1677_ = tab_invoice.reserved_count_remnants,
          attr_2565_ = CURRENT_DATE,
          operation_user_id = do_user
    WHERE id = tab_invoice.id_remnants;

/*создание резолюции движения номенклатуры*/
   INSERT INTO registry.object_2181_ (
          attr_2182_,
          attr_2183_,
          attr_2184_,
          attr_2185_,
          attr_3447_,
          attr_3451_
          )
   VALUES (
          tab_invoice.id_remnants,
          tab_invoice.sign_nom,
          tab_invoice.name_nom,
          tab_invoice.count,
          1,
          tab_invoice.id_tab_invoice
          );

/*присвоение статуса "выдано" и фиксация id остатка*/
   UPDATE registry.object_2111_
      SET attr_3450_ = TRUE,
          attr_4123_ = tab_invoice.id_remnants,
          operation_user_id = do_user
    WHERE id = tab_invoice.id_tab_invoice;

/*подсчет количества обработанных записей*/
count_process_tab_invoice := count_process_tab_invoice + 1;

END LOOP;

/*стирание зафиксированного остатка*/
   UPDATE registry.object_2111_
      SET attr_4128_ = NULL,
          operation_user_id = do_user
    WHERE id = ANY (tab_invoice_ids);

/*если обработана хотя бы одна запись табличной части, то блокируем накладную и если есть остаток для выдачи, то создаем новую накладную*/
IF count_process_tab_invoice > 0 THEN
/*вычитаем из количества по заказу количество в накладных на тот же компонент*/
ostatok := invoice.attr_3420_ - (
   SELECT COUNT(invoices.attr_4125_)
     FROM registry.object_2112_ invoices
    WHERE invoices.attr_3415_ = invoice.attr_3415_
);

/*если есть остаток по сумме всех накладных и текущая накладная не заблокирована (она последняя), то создаем копию накладной с остатком*/
IF ostatok > 0
      AND invoice.attr_4132_ IS FALSE THEN
          /*копия текущей накладной вместе с табличной частью (последний флаг - TRUE) с отключенной блокировкой и количеством, равным остатку*/
          copy_invoice_ids := registry."copyRecord" (2112, invoice.id, 1, NULL, NULL, do_user, TRUE);

   UPDATE registry.object_2112_
      SET attr_4132_ = FALSE,
          attr_4125_ = ostatok,
          operation_user_id = do_user
    WHERE id = copy_invoice_ids[1];

/*сброс флагов "выдано" в табличной части*/
   UPDATE registry.object_2111_
      SET attr_3450_ = FALSE,
          operation_user_id = do_user
    WHERE attr_2126_ = copy_invoice_ids[1];

END IF;

   UPDATE registry.object_2112_
      SET attr_4132_ = TRUE,
          operation_user_id = do_user
    WHERE id = invoice.id;

END IF;

END