  DECLARE 
remnant RECORD;

    BEGIN
/*поиск существующих остатков по аутсорсеру*/
FOR remnant IN (
   SELECT remnants.id AS id
        , tab_act_expenditure.attr_4035_ AS quant
     FROM registry.object_1621_ act_expenditure
LEFT JOIN registry.object_1646_ tab_act_expenditure ON tab_act_expenditure.attr_4034_ = act_expenditure.ID
      AND tab_act_expenditure.attr_4038_ = act_expenditure.attr_2179_
      AND tab_act_expenditure.is_deleted IS FALSE
LEFT JOIN registry.object_1659_ remnants ON remnants.ID = tab_act_expenditure.attr_4036_
      AND remnants.is_deleted IS FALSE
    WHERE act_expenditure.id = (parameters ->> 'id')::INT
) LOOP
   UPDATE registry.object_1659_
      SET attr_1669_ = attr_1669_ - remnant.quant
        , attr_2566_ = CURRENT_DATE
    WHERE id = remnant.id;

     CALL registry."updateStoredFormulasByRow" (1659, remnant.id);

END LOOP;

/*ставим статус "проведен" акту*/
   UPDATE registry.object_1621_
      SET attr_4037_ = TRUE
    WHERE id = (parameters ->> 'id')::INT;

END