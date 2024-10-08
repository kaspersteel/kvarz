  DECLARE 

storage_param INT := (parameters ->> 'storage_param')::INT;

do_user INT := (parameters ->> 'user_id')::INT;

invoice RECORD;

tab_invoice_ids INT[];

count_process_tab_invoice INT := 0;

copy_invoice_ids INT[];

copy_tab_invoice_ids INT[];

assembly_storage RECORD;

assembly_storage_ids INT[];

tab_invoice RECORD;

ostatok INT;

    BEGIN
/*получаем запись накладной*/
   SELECT * INTO invoice
     FROM registry.object_2112_ current_invoice
    WHERE current_invoice.id = (parameters ->> 'id')::INT;

/*получаем id всех записей табличной части*/
tab_invoice_ids := (
   SELECT ARRAY_AGG(id)
     FROM registry.object_2111_
    WHERE attr_2126_ = invoice.id
      AND is_deleted IS FALSE
);

/*обрабатываем записи табличной части, подходящие под заданные пользователем условия*/
FOR tab_invoice IN (
   SELECT tab.id AS id_tab_invoice,
          tab.attr_4128_ AS id_remnants,
          tab.attr_2115_ AS sign_nom,
          tab.attr_3421_ AS name_nom,
          tab.attr_3423_ AS count,
          tab.attr_4121_ AS given
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
    /*ожидаемый остаток на складе не меньше требуемого к выдаче*/
      AND remnants.attr_3131_ >= tab.attr_3423_
) LOOP
   SELECT * INTO assembly_storage
     FROM registry.object_1617_
    WHERE attr_1618_ = tab_invoice.sign_nom
      AND attr_2574_ = 14
      AND attr_3951_ = tab_invoice.given;

/*запись кол-ва на склад сборки. если для такой НЕ нет записи на складе сборки, то создаем её*/
IF assembly_storage.id IS NOT NULL THEN
   UPDATE registry.object_1617_
      SET attr_1620_ = attr_1620_ + tab_invoice.count,
          attr_3131_ = attr_3131_ + tab_invoice.count,
          attr_2565_ = CURRENT_DATE,
          operation_user_id = do_user
    WHERE id = assembly_storage.id;

ELSE assembly_storage_ids := registry."copyRecord" (1617, tab_invoice.id_remnants, 1, NULL, NULL, do_user, TRUE);

   UPDATE registry.object_1617_
      SET attr_1620_ = tab_invoice.count,
          attr_3131_ = tab_invoice.count,
          attr_1677_ = 0,
          attr_2574_ = 14,
          attr_2565_ = CURRENT_DATE,
          operation_user_id = do_user
    WHERE id = assembly_storage_ids[1];

END IF;

/*списание номенклатуры с остатка*/
   UPDATE registry.object_1617_
      SET attr_1620_ = attr_1620_ - tab_invoice.count,
          attr_3131_ = attr_3131_ - tab_invoice.count,
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
   SELECT SUM(invoices.attr_4125_)
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
          attr_4134_ = ostatok,
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