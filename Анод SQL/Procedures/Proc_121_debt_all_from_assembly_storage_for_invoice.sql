  DECLARE 

do_user INT := (parameters ->> 'user_id')::INT;

invoice RECORD;

tab_invoice RECORD;

ostatok INT;

    BEGIN
    /*получаем запись накладной*/
   SELECT * INTO invoice
     FROM registry.object_2112_ current_invoice
    WHERE current_invoice.id = (parameters ->> 'id')::INT;

FOR tab_invoice IN (
   SELECT tab.id AS id_tab_invoice,
          assembly_storage.id AS id_assembly_storage ,
          tab.attr_3423_ AS count
     FROM registry.object_2111_ tab
          /*ищем склад сборки*/
LEFT JOIN registry.object_1617_ assembly_storage ON assembly_storage.is_deleted IS FALSE
      AND assembly_storage.attr_1618_ = tab.attr_2115_
      AND assembly_storage.attr_3951_ = tab.attr_4121_
      AND assembly_storage.attr_2574_ = 14
    WHERE tab.attr_2126_ = invoice.id
      AND tab.is_deleted IS FALSE

) LOOP
/*списываем количество НЕ по накладной с остатка склада сборки*/
   UPDATE registry.object_1617_
      SET attr_1620_ = attr_1620_ - tab_invoice.count,
          attr_3131_ = attr_3131_ - tab_invoice.count,
          attr_2565_ = CURRENT_DATE,
          operation_user_id = do_user
    WHERE id = tab_invoice.id_assembly_storage; 
END LOOP;
/*ставим флаг "списано со склада сборки"*/
   UPDATE registry.object_2112_
      SET attr_4133_ = TRUE,
          operation_user_id = do_user
    WHERE id = invoice.id;
END