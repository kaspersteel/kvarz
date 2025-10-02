    BEGIN
   INSERT INTO registry.object_309_ (
          attr_311_, --ИБ
          attr_331_, --дата
          attr_650_, --дата созд
          attr_774_, --фио
          attr_2325_, --процедура
          attr_2352_, --сотрудник
          attr_2382_, --длительность
          attr_2389_, --отчет
          attr_2390_, --окончено
          attr_3918_, --ссылка на план
          operation_user_id
          )
SELECT attr_827_, --ИБ
          calend.attr_4084_, --дата
          calend.attr_4084_, --дата созд
          attr_1949_, --фио
          attr_784_, --процедура
          (PARAMETERS ->> 'user_id')::INT, --сотрудник
          attr_2381_, --длительность
          '+', --отчет
          TRUE, --окончено
          (PARAMETERS ->> 'id')::INT, --ссылка на план
          (PARAMETERS ->> 'user_id')::INT --operation_user_id
     FROM registry.object_783_ plan
     LEFT JOIN registry.object_4079_ calend ON calend.attr_4089_ = plan.id
WHERE plan.ID = (PARAMETERS ->> 'id')::INT
      AND 
      calend.attr_4084_ NOT IN (
             SELECT COALESCE(diary.attr_331_, '01-01-1600')
               FROM registry.object_783_ plan
          LEFT JOIN registry.object_309_ diary ON diary.attr_311_ = plan.attr_827_
                AND diary.attr_2325_ = plan.attr_784_
              WHERE plan.ID = (PARAMETERS ->> 'id')::INT
          )
          AND (calend.attr_4087_ <> true OR calend.attr_4087_ is null)
;

END