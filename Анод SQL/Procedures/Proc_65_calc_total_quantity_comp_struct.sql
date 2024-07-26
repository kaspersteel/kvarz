DECLARE 
do_user INT := (parameters ->> 'user_id')::INT;
head_id INT := (parameters ->> 'id')::INT;
parents INT[];
children INT[];
child RECORD;
parent_total_quant INT;
x INT;

BEGIN 
          children := ARRAY[head_id];
   UPDATE registry.object_369_
      SET attr_4079_ = attr_371_
        , operation_user_id = do_user
    WHERE id = head_id;

WHILE ARRAY_LENGTH(children, 1) > 0 LOOP 
          parents := children; 
          children := ARRAY[];

FOREACH x IN ARRAY parents LOOP
   SELECT INTO parent_total_quant attr_4079_
     FROM registry.object_369_
    WHERE id = x;

FOR child IN (
   SELECT id AS id
        , attr_371_ AS quant
     FROM registry.object_369_
    WHERE attr_1455_ = x
) LOOP
   UPDATE registry.object_369_
      SET attr_4079_ = child.quant * parent_total_quant
        , operation_user_id = do_user
    WHERE id = child.id;

children := children || child.id;
END LOOP;
END LOOP;
END LOOP;
END