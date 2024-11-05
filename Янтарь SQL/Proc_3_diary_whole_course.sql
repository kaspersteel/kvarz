    BEGIN
   INSERT INTO registry.object_309_ (
          attr_311_, --ИБ
          attr_331_, --дата
          attr_650_, --дата создания
          attr_774_, --фио
          attr_2325_, --процедура
          attr_2352_, --сотрудник
          attr_2382_, --длительность
          attr_2389_, --отчет
          attr_2390_, --окончено
          operation_user_id
          )
   SELECT attr_827_, --ИБ
          gen_date, --дата
          gen_date, --дата создания
          attr_1949_, --фио
          attr_784_, --процедура
          (PARAMETERS ->> 'user_id')::INT, --сотрудник
          attr_2381_, --длительность
          '+', --отчет
          TRUE, --окончено
          (PARAMETERS ->> 'user_id')::INT --operation_user_id
     FROM registry.object_783_ plan
LEFT JOIN GENERATE_SERIES(
          plan.attr_785_::TIMESTAMP,
          plan.attr_786_::TIMESTAMP,
          '1 day'
          ) AS gen_date ON TRUE
    WHERE plan.ID = (PARAMETERS ->> 'id')::INT
      AND gen_date NOT IN (
             SELECT diary.attr_331_
               FROM registry.object_783_ plan
          LEFT JOIN registry.object_309_ diary ON diary.attr_311_ = plan.attr_827_
                AND diary.attr_2325_ = plan.attr_784_
              WHERE plan.ID = (PARAMETERS ->> 'id')::INT
          );

END