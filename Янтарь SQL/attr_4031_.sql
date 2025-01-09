/*Пересечение процедур*/
/*SELECT*/
STRING_AGG(DISTINCT proc3."intersect", '\n')
/*JOIN*/
LEFT JOIN (
          /*собираем таблицу интервалов из строки, LATERAL позволяет обратиться из подзапроса к таблице, вызванной вне его */
               WITH proc AS (
                       SELECT o.id       AS "record"
                            , tab_proc.*
                         FROM registry.object_4000_ o
                    LEFT JOIN LATERAL (
                                 VALUES ('ЛФК 1', o.attr_4007_, 1)
                                      , ('ЛФК 2', o.attr_4009_, 2)
                                      , ('Бассейн', o.attr_4011_, 3)
                                      , ('Гидромассаж', o.attr_4013_, 4)
                                      , ('Эрготерапия', o.attr_4015_, 5)
                                      , ('Логопед', o.attr_4017_, 6)
                                      , ('Психолог', o.attr_4019_, 7)
                                      , ('ИРТ', o.attr_4021_, 8)
                                      , ('Массаж', o.attr_4023_, 9)
                                      , ('ФТ', o.attr_4025_, 10)
                                      , ('Грязетерапия', o.attr_4027_, 11)
                                      , ('Спелеотерапия', o.attr_4029_, 12)
                                      , ('Гирудотерапия', o.attr_4162_, 13)
                                      , ('Социокульт.', o.attr_4251_, 14)
                                      , ('Ингаляция', o.attr_4443_, 15)
                                      , ('Прессотерапия', o.attr_4446_, 16)
                                      , ('Сухая Игла', o.attr_4455_, 17)
                                      , ('ВТЭС', o.attr_4458_, 18)
                              ) AS tab_proc ("name", "interval", "id") ON o.is_deleted IS FALSE /*не трогаем удаленные*/
                        WHERE o.is_deleted IS FALSE /*не включаем удаленные в итог*/
                    )
             SELECT DISTINCT proc."record" AS record
                  , CONCAT(
                    CASE
                              WHEN proc."id" < proc2."id" THEN proc."name"
                              ELSE proc2."name"
                    END
                  , ' || '
                  , CASE
                              WHEN proc."id" > proc2."id" THEN proc."name"
                              ELSE proc2."name"
                    END
                    ) AS "intersect" /*разворачиваем зеркальные пары, чтобы исключить их при агрегации*/
               FROM proc /*к таблице интервалов цепляем по условию пересечения интервалов строки из неё же, исключая одинаковые строки*/
          LEFT JOIN proc proc2 ON proc."name" != proc2."name"
                AND proc."record" = proc2."record"
                AND proc."interval" && proc2."interval"
                AND (
                    proc."interval" && ARRAY[1]
                 OR proc2."interval" && ARRAY[1]
                    ) <> TRUE
              WHERE proc2."name" IS NOT NULL /*очищаем от строк, куда не прикрепилось ни одной записи*/
          ) proc3 ON proc3."record" = o.id