DECLARE 
	remnant RECORD;
	do_user INT := (parameters ->> 'user_id')::INT;
    mode CHAR := (parameters ->> 'mode')::CHAR; -- "r" - проведение, "с" - отмена проведения
BEGIN

FOR remnant IN (
   SELECT remnants.id AS "id",
          mat_dir.attr_62_ AS "type"
     FROM registry.object_30_ remnants
     LEFT JOIN registry.object_58_ mat_dir ON mat_dir.id = remnants.attr_94_ AND not mat_dir.is_deleted
     WHERE remnants.attr_110_ = (parameters ->> 'id')::INT 
     AND not remnants.is_deleted 
) LOOP
   UPDATE registry.object_30_
      SET attr_808_ = CASE mode WHEN r THEN 
                                     CASE WHEN remnant.type = 2 THEN 2 
                                          WHEN remnant.type = 5 THEN 3 
                                     END
                                WHEN c THEN 
                                     1
                      END,
		  operation_user_id = do_user
    WHERE id = remnant.id;

     CALL registry."updateStoredFormulasByRow" (30, remnant.id);

END LOOP;

/*ставим статус "проведен" накладной*/
   UPDATE registry.object_103_
      SET attr_669_ = CASE mode WHEN r THEN 2
                                WHEN c THEN 1
                      END,
		  operation_user_id = do_user
    WHERE id = (parameters ->> 'id')::INT;

END