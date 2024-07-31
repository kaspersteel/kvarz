/*отлов странных записей в 369*/
     WITH children AS (
          /*количество элементов состава у голов*/
             SELECT o.ID o_id
                  , COUNT(C.ID) COUNT
               FROM registry.object_369_ o
          LEFT JOIN registry.object_369_ C ON o.ID = C.attr_1455_
                AND C.is_deleted IS FALSE
           GROUP BY o.ID
          )
        , cte2 AS (
          /*компоненты и головы составов, куда они входят*/
             SELECT o.ID
                  , o.is_deleted o_is_deleted
                  , o.attr_1455_ o_head
                  , o.attr_1456_ o_type
                  , o.attr_632_ o_632
                  , o.attr_374_ o_374
                  , h.ID h_id
                  , h.is_deleted h_is_deleted
                  , h.attr_632_ h_632
                  , h.attr_374_ h_374
                    /*сколько голов нашлось для компонента, подходящих по НЕ*/

                  , COUNT(h.ID) OVER (
                    PARTITION BY o.ID
                    ) cte2_h_count
                    /*сколько дочерних компонентов у голов*/

                  , children.count cte2_c_count
               FROM registry.object_369_ o
          LEFT JOIN registry.object_369_ h ON h.attr_374_ = o.attr_374_
                AND h.attr_1455_ IS NULL
                AND h.is_deleted IS FALSE
          LEFT JOIN cte ON h.ID = cte.o_id
              WHERE o.is_deleted IS FALSE
           GROUP BY o.ID
                  , h.ID
                  , children.o_id
                  , children.count
           ORDER BY COUNT(h.ID) OVER (
                    PARTITION BY o.ID
                    )
          )
   SELECT cte2.*
        , ne.id AS ne_id
        , ne.attr_376_ AS ne_design
        , ne.attr_362_ AS ne_name
     FROM cte2
LEFT JOIN registry.object_301_ ne ON ne.id = h_374
    WHERE
          /*ловим составы, ссылающиеся на удаленные НЕ*/
          ne.is_deleted IS TRUE
       OR (
          /*Ловим компоненты, ссылающиеся на головы, имеющие ту же НЕ, но в других составах*/
          h_632 != o_632
      AND (
          /*ловим дубликаты составов */
          cte2_h_count > 1
          /*ловим дубликаты головы, не имеющие состава */
       OR cte2_c_count = 0
          )
          )