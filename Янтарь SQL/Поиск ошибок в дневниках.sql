with base AS (SELECT
    o.id AS diary_id, o.create_date AS diary_cd, o.attr_311_ AS hist_id, o.attr_2325_ AS proc_code,
case o.attr_2325_
  when 1 then rasp.attr_4008_     -- ЛФК 1
  when 2 then rasp.attr_4012_     -- Бассейн
  when 3 then rasp.attr_4014_     -- Гидромассаж
  when 4 then rasp.attr_4016_     -- Эрготерапия
  when 5 then rasp.attr_4018_     -- Занятия с логопедом
  when 6 then rasp.attr_4020_     -- Занятия с психологом
  when 7 then rasp.attr_4022_     -- ИРТ
  when 8 then rasp.attr_4024_     -- Массаж
  when 9 then rasp.attr_4026_     -- Физиотерапия
  when 12 then rasp.attr_4028_    -- Грязетерапия
  when 13 then rasp.attr_4030_    -- Спелеотерапия  
  when 14 then rasp.attr_4163_    -- Гирудотерапия
  when 15 then rasp.attr_4166_    -- Фитотерапия
  when 17 then rasp.attr_4252_    -- Социокультурное мероприятие
  when 16 then rasp.attr_4169_    -- Кислородный коктейль
  when 18 then rasp.attr_4444_    -- Ингаляция
  when 19 then rasp.attr_4447_    -- Прессотерапия
  when 20 then rasp.attr_4456_    -- Сухая Игла
  when 21 then rasp.attr_4459_    -- ВТЭС
end as plan_id
FROM
    "registry"."object_309_" o
    LEFT JOIN registry.object_4000_ rasp ON rasp.attr_4032_ = o.attr_331_ 
    AND rasp.attr_4005_ = o.attr_311_ 
    AND not rasp.is_deleted
    WHERE not o.is_deleted
	--AND o.attr_3918_ is null
    --AND o.create_date >= '2025-08-05'::date
	AND rasp.id is not null --
    )
    
    
    SELECT base.*, plan.attr_1949_ AS patient_id, clients.attr_69_ AS patient_fio, plan.create_date AS plan_cd, plan.is_deleted, plan.attr_785_ AS date_start, plan.attr_786_ date_end, plan.attr_2177_ AS date_cancel
    FROM base
    LEFT JOIN registry.object_783_ plan ON plan.id = base.plan_id
    LEFT JOIN registry.object_45_ clients ON clients.id = plan.attr_1949_
	WHERE plan.id is null --
	ORDER BY 2 desc