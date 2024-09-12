  DECLARE do_user INT := (parameters ->> 'user_id')::INT;

tab_invoice RECORD;

invoice RECORD;

remnant RECORD;

copy_invoice_ids INT[];

copy_tab_invoice_ids INT[];

assembly_storage RECORD;

assembly_storage_ids INT[];

ostatok INT;

    BEGIN
   SELECT * INTO tab_invoice
     FROM registry.object_2111_
    WHERE id = (parameters ->> 'id')::INT;

   SELECT * INTO invoice
     FROM registry.object_2112_
    WHERE id = tab_invoice.attr_2126_;

/*запись остатка по зафиксированному на момент выдачи id остатка*/
   SELECT * INTO remnant
     FROM registry.object_1617_
    WHERE id = tab_invoice.attr_4128_;

   SELECT * INTO assembly_storage
     FROM registry.object_1617_
    WHERE attr_1618_ = tab_invoice.attr_2115_
      AND attr_2574_ = 14
      AND attr_3951_ = tab_invoice.attr_4121_;

IF remnants.attr_3131_ >= tab_invoice.attr_3423_ THEN
/*запись кол-ва на склад сборки. если для такой НЕ нет записи на складе сборки, то создаем её*/
IF assembly_storage.id IS NOT NULL THEN
   UPDATE registry.object_1617_
      SET attr_1620_ = attr_1620_ + tab_invoice.attr_3423_,
          attr_3131_ = attr_3131_ + tab_invoice.attr_3423_,
          attr_2565_ = CURRENT_DATE,
          operation_user_id = do_user
    WHERE id = assembly_storage.id;

ELSE assembly_storage_ids := registry."copyRecord" (1617, remnant.id, 1, NULL, NULL, do_user, TRUE);

   UPDATE registry.object_1617_
      SET attr_1620_ = tab_invoice.attr_3423_,
          attr_3131_ = tab_invoice.attr_3423_,
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
    WHERE id = remnant.id;

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
          remnant.id,
          tab_invoice.attr_2115_,
          tab_invoice.attr_3421_,
          tab_invoice.attr_3423_,
          1,
          tab_invoice.id
          );

/*присвоение статуса "выдано", стирание зафиксированного остатка и фиксация id остатка в накладной*/
   UPDATE registry.object_2111_
      SET attr_3450_ = TRUE,
          attr_4128_ = NULL,
          attr_4123_ = remnant.id,
          operation_user_id = do_user
    WHERE id = tab_invoice.id;

/*блокируем накладную и если есть остаток для выдачи, то создаем новую накладную*/
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