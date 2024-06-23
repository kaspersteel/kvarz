/*вариант через СТЕ. Работает только в одном поле, не виден из других*/
WITH grades(aim, activity, perform1, satisf1, perform2, satisf2) AS (
     VALUES (o.attr_4293_, o.attr_4291_, o.attr_4294_, o.attr_4295_, o.attr_4296_, o.attr_4297_),
     (o.attr_4300_, o.attr_4298_, o.attr_4301_, o.attr_4302_, o.attr_4303_, o.attr_4304_),
     (o.attr_4307_, o.attr_4305_, o.attr_4308_, o.attr_4309_, o.attr_4310_, o.attr_4311_),
     (o.attr_4314_, o.attr_4312_, o.attr_4315_, o.attr_4316_, o.attr_4317_, o.attr_4318_),
     (o.attr_4321_, o.attr_4319_, o.attr_4322_, o.attr_4323_, o.attr_4324_, o.attr_4325_),
     (o.attr_4328_, o.attr_4326_, o.attr_4329_, o.attr_4330_, o.attr_4331_, o.attr_4332_),
     (o.attr_4335_, o.attr_4333_, o.attr_4336_, o.attr_4337_, o.attr_4338_, o.attr_4339_),
     (o.attr_4342_, o.attr_4340_, o.attr_4343_, o.attr_4344_, o.attr_4345_, o.attr_4346_),
     (o.attr_4349_, o.attr_4347_, o.attr_4350_, o.attr_4351_, o.attr_4352_, o.attr_4353_),
     (o.attr_4356_, o.attr_4354_, o.attr_4357_, o.attr_4358_, o.attr_4359_, o.attr_4360_),
     (o.attr_4363_, o.attr_4361_, o.attr_4364_, o.attr_4365_, o.attr_4366_, o.attr_4367_),
     (o.attr_4370_, o.attr_4368_, o.attr_4371_, o.attr_4372_, o.attr_4373_, o.attr_4374_),
     (o.attr_4377_, o.attr_4375_, o.attr_4378_, o.attr_4379_, o.attr_4380_, o.attr_4381_),
     (o.attr_4384_, o.attr_4382_, o.attr_4385_, o.attr_4386_, o.attr_4387_, o.attr_4388_),
     (o.attr_4391_, o.attr_4389_, o.attr_4392_, o.attr_4393_, o.attr_4394_, o.attr_4395_)
)

/*вариант через базовую формулу и соединение таблиц*/
FROM registry.object_4269_ o
/*LATERAL можно использовать в SELECT- и JOIN-частях запроса. Ключевое слово позволяет ссылаться на строки, извлеченные из таблиц остальной частью запроса. Обычные SELECT и JOIN так не умеют. https://eax.me/postgresql-lateral-join/*/
LEFT JOIN LATERAL (VALUES (o.id, o.attr_4293_, o.attr_4291_, o.attr_4294_, o.attr_4295_, o.attr_4296_, o.attr_4297_),
     (o.id, o.attr_4300_, o.attr_4298_, o.attr_4301_, o.attr_4302_, o.attr_4303_, o.attr_4304_),
     (o.id, o.attr_4307_, o.attr_4305_, o.attr_4308_, o.attr_4309_, o.attr_4310_, o.attr_4311_),
     (o.id, o.attr_4314_, o.attr_4312_, o.attr_4315_, o.attr_4316_, o.attr_4317_, o.attr_4318_),
     (o.id, o.attr_4321_, o.attr_4319_, o.attr_4322_, o.attr_4323_, o.attr_4324_, o.attr_4325_),
     (o.id, o.attr_4328_, o.attr_4326_, o.attr_4329_, o.attr_4330_, o.attr_4331_, o.attr_4332_),
     (o.id, o.attr_4335_, o.attr_4333_, o.attr_4336_, o.attr_4337_, o.attr_4338_, o.attr_4339_),
     (o.id, o.attr_4342_, o.attr_4340_, o.attr_4343_, o.attr_4344_, o.attr_4345_, o.attr_4346_),
     (o.id, o.attr_4349_, o.attr_4347_, o.attr_4350_, o.attr_4351_, o.attr_4352_, o.attr_4353_),
     (o.id, o.attr_4356_, o.attr_4354_, o.attr_4357_, o.attr_4358_, o.attr_4359_, o.attr_4360_),
     (o.id, o.attr_4363_, o.attr_4361_, o.attr_4364_, o.attr_4365_, o.attr_4366_, o.attr_4367_),
     (o.id, o.attr_4370_, o.attr_4368_, o.attr_4371_, o.attr_4372_, o.attr_4373_, o.attr_4374_),
     (o.id, o.attr_4377_, o.attr_4375_, o.attr_4378_, o.attr_4379_, o.attr_4380_, o.attr_4381_),
     (o.id, o.attr_4384_, o.attr_4382_, o.attr_4385_, o.attr_4386_, o.attr_4387_, o.attr_4388_),
     (o.id, o.attr_4391_, o.attr_4389_, o.attr_4392_, o.attr_4393_, o.attr_4394_, o.attr_4395_)
) AS grades(rec, aim, activity, perform1, satisf1, perform2, satisf2) ON o.id = grades.rec AND grades.aim is true

/*разные функции для подсчетов*/
count (grades.aim)
SUM(grades.perform1)
string_agg (grades.activity, '.\n')

/*вариант отдельного поля вместо "string_agg (grades.activity, '.\n')"*/
concat_ws ('.\n', case when o.attr_4293_ then concat (o.attr_4291_) end,
        case when o.attr_4300_ then concat (o.attr_4298_) end,
        case when o.attr_4307_ then concat (o.attr_4305_) end,
        case when o.attr_4314_ then concat (o.attr_4312_) end,
        case when o.attr_4321_ then concat (o.attr_4319_) end,
        case when o.attr_4328_ then concat (o.attr_4326_) end,
        case when o.attr_4335_ then concat (o.attr_4333_) end,
        case when o.attr_4342_ then concat (o.attr_4340_) end,
        case when o.attr_4349_ then concat (o.attr_4347_) end,
        case when o.attr_4356_ then concat (o.attr_4354_) end,
        case when o.attr_4363_ then concat (o.attr_4361_) end,
        case when o.attr_4370_ then concat (o.attr_4368_) end,
        case when o.attr_4377_ then concat (o.attr_4375_) end,
        case when o.attr_4384_ then concat (o.attr_4382_) end,
        case when o.attr_4391_ then concat (o.attr_4389_) end)
      */