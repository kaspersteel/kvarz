DECLARE
    do_user INT := (parameters ->> 'user_id')::INT;
    object_id INT := (parameters ->> 'registry_id')::INT;
    record_id INT := (parameters ->> 'id')::INT;
    quantity INT := (parameters ->> 'quantity')::INT;
    num_coil INT;
    num_coil_attr VARCHAR := 'attr_97_';
    volume_coil_attr VARCHAR := 'attr_98_';
    copy_ids INT[];
    copy_id INT;
BEGIN
    IF quantity IS NOT NULL THEN
        
        -- Извлечение номера бухты
         EXECUTE FORMAT(
            'SELECT COALESCE(%I, 1) FROM registry.object_%s_ WHERE id = %s',
            num_coil_attr,
            object_id,
            record_id
         ) INTO num_coil;

        -- Вызов функции копирования записей
        copy_ids := registry."copyRecord"(object_id, record_id, quantity, NULL, NULL, do_user, true);

        -- Перебор всех скопированных id
        FOREACH copy_id IN ARRAY copy_ids LOOP
            num_coil := num_coil + 1;

            EXECUTE FORMAT(
                'UPDATE registry.object_%s_ SET %I = %s, %I = %s WHERE id = %s',
                object_id,
                num_coil_attr,
                num_coil,
                volume_coil_attr,
                quote_nullable(NULL),
                copy_id
            );
        END LOOP;
    END IF;
END;