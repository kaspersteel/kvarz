  DECLARE 

id_give_ras INT := (parameters ->> 'id')::INT;

do_user INT := (parameters ->> 'user_id')::INT;

ras_arr INT[];

ras_arr_filter INT[];

    BEGIN
   SELECT attr_4738_ INTO ras_arr
     FROM registry.object_4187_ give_ras
    WHERE give_ras.id = id_give_ras;

ras_arr_filter := ARRAY (
   SELECT arr
     FROM UNNEST(ras_arr) AS arr
    WHERE arr NOT IN (
             SELECT attr_4734_
               FROM registry.object_4732_
              WHERE attr_4733_ = id_give_ras
                AND NOT is_deleted
          )
      AND arr IS NOT NULL
);

IF ARRAY_LENGTH(ras_arr_filter, 1) > 0 THEN
   INSERT INTO registry.object_4732_ (attr_4733_, attr_4734_, operation_user_id)
   SELECT id_give_ras,
          UNNEST(ras_arr_filter),
          do_user;

END IF;

   UPDATE registry.object_4187_
      SET attr_4738_ = NULL,
          operation_user_id = do_user
    WHERE id = id_give_ras;

END