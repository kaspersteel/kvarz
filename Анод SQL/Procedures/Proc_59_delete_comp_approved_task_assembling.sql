DECLARE 
rec RECORD;
remnant RECORD;
do_user INT = (parameters ->> 'user_id')::INT;

BEGIN
   SELECT INTO rec comp_task.ID AS comp_task_id
        , accept_list.id AS accept_id
        , nakladnaya.id AS nakl
        , ARRAY_AGG(tab_nakladnaya.ID) AS tab_nakl
        , COUNT(tab_nakladnaya.ID) FILTER (
    WHERE tab_nakladnaya.attr_3450_ IS TRUE
) AS count_given
     FROM registry.object_2094_ comp_task
     JOIN registry.object_2137_ accept_list ON comp_task.id = ANY (accept_list.attr_3904_)
      AND accept_list.is_deleted IS FALSE
     JOIN registry.object_2112_ nakladnaya ON nakladnaya.attr_3415_ = comp_task.id
      AND nakladnaya.is_deleted IS FALSE
     JOIN registry.object_2111_ tab_nakladnaya ON tab_nakladnaya.attr_2126_ = nakladnaya.id
      AND tab_nakladnaya.is_deleted IS FALSE
    WHERE comp_task.id = (parameters ->> 'id')::INT
 GROUP BY comp_task.id
        , accept_list.id
        , nakladnaya.id;

IF rec.count_given = 0 THEN 
FOR remnant IN (
   SELECT remnants.id AS remnants_id
        , tab_nakladnaya.attr_3423_ AS tab_nakladnaya_quant
     FROM registry.object_2111_ tab_nakladnaya
LEFT JOIN registry.object_1617_ remnants ON remnants.id = tab_nakladnaya.attr_3443_
      AND remnants.is_deleted IS FALSE
    WHERE tab_nakladnaya.id = ANY (rec.tab_nakl)
) LOOP
   UPDATE registry.object_1617_
      SET attr_1677_ = attr_1677_ - remnant.tab_nakladnaya_quant
        , attr_3131_ = attr_3131_ + remnant.tab_nakladnaya_quant
        , attr_2565_ = CURRENT_DATE
        , operation_user_id = do_user
    WHERE id = remnant.remnants_id;

END LOOP;

   UPDATE registry.object_2111_
      SET is_deleted = TRUE
        , operation_user_id = do_user
    WHERE id = ANY (rec.tab_nakl);

   UPDATE registry.object_2112_
      SET is_deleted = TRUE
        , operation_user_id = do_user
    WHERE id = rec.nakl;

   UPDATE registry.object_2137_
      SET attr_3207_ = 0
        , operation_user_id = do_user
    WHERE id = rec.accept_id;

   UPDATE registry.object_2094_
      SET is_deleted = TRUE
        , operation_user_id = do_user
    WHERE id = rec.comp_task_id;

END IF;

END