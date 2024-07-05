DECLARE 
deleted_ids INT[];

BEGIN
/*поиск всех составляющих узла, включая составы узлов*/
deleted_ids = (
    SELECT
        ARRAY_AGG(o.id)
    FROM
        registry.object_369_ o
    WHERE
        o.is_deleted IS FALSE
        AND o.attr_632_::INT = (parameters ->> 'id')::INT
);

UPDATE registry.object_369_
SET
    is_deleted = TRUE
    /*operation_user_id нужен для того, чтобы система проделала действия*/ 
    /*от имени пользователя и проставила его id в поле delete_user_id.*/
    /*delete_date система проставляет сама*/
  , operation_user_id = (parameters ->> 'user_id')::INT
WHERE
    id = ANY (deleted_ids);

END