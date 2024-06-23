>select

CASE
    WHEN o.attr_3933_ THEN 6
    ELSE CASE
    		 /*Стандартная/типовая деталь или Материал в спецификации*/
             WHEN o.attr_1411_ IN (6, 82) THEN 3 /*Закупка*/
             /*остальное*/
             WHEN o.attr_1411_ IN (1, 2, 3, 7, 8, 9, 10, 11) THEN 2 /*Производство*/
         END
END

>join

>group by
