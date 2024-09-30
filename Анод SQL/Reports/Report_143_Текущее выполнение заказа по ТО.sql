   SELECT o.id
        , component.id AS component_id
        , component.attr_1414_ AS rod_component
        , component.attr_1410_ AS component
        , component.attr_1413_ AS NAME
        , project.attr_1394_ AS nn
        , nado.attr_3403_ AS pvn
        , CASE
                    WHEN component.attr_1411_ NOT IN (3, 6, 7, 82) THEN project.attr_1895_
                    ELSE component.attr_1896_
          END AS plan_count
        , nado.id AS pv_id
        , /*Отрезная*/
          (
             SELECT o1.attr_2609_
               FROM registry.object_2138_ o1
              WHERE o1.is_deleted <> TRUE
                AND o1.attr_2149_ = 39
                AND o1.attr_2148_ = nado.id
          ) AS otk_otrez
        , /*Токарная1*/
          (
             SELECT o1.attr_2609_
               FROM registry.object_2138_ o1
              WHERE o1.is_deleted <> TRUE
                AND o1.attr_2149_ = 46
                AND o1.attr_2148_ = nado.id
          ) AS otk_tok1
        , /*Термическая*/
          (
             SELECT o1.attr_2609_
               FROM registry.object_2138_ o1
              WHERE o1.is_deleted <> TRUE
                AND o1.attr_2149_ = 41
                AND o1.attr_2148_ = nado.id
          ) AS otk_term
        , /*Токарная*/
          (
             SELECT o1.attr_2609_
               FROM registry.object_2138_ o1
              WHERE o1.is_deleted <> TRUE
                AND o1.attr_2149_ = 40
                AND o1.attr_2148_ = nado.id
                AND o1.attr_3208_ = (
                       SELECT MIN(o2.attr_3208_)
                         FROM registry.object_2138_ o2
                        WHERE o2.is_deleted <> TRUE
                          AND o2.attr_2149_ = 40
                          AND o2.attr_2148_ = nado.id
                    )
          ) AS otk_tokr
        , /*Фрезерная*/
          (
             SELECT o1.attr_2609_
               FROM registry.object_2138_ o1
              WHERE o1.is_deleted <> TRUE
                AND o1.attr_2149_ = 42
                AND o1.attr_2148_ = nado.id
                AND o1.attr_3208_ = (
                       SELECT MIN(o2.attr_3208_)
                         FROM registry.object_2138_ o2
                        WHERE o2.is_deleted <> TRUE
                          AND o2.attr_2149_ = 42
                          AND o2.attr_2148_ = nado.id
                    )
          ) AS otk_frezer
        , /*Расточная*/
          (
             SELECT o1.attr_2609_
               FROM registry.object_2138_ o1
              WHERE o1.is_deleted <> TRUE
                AND o1.attr_2149_ = 43
                AND o1.attr_2148_ = nado.id
                AND o1.attr_3208_ = (
                       SELECT MIN(o2.attr_3208_)
                         FROM registry.object_2138_ o2
                        WHERE o2.is_deleted <> TRUE
                          AND o2.attr_2149_ = 43
                          AND o2.attr_2148_ = nado.id
                    )
          ) AS otk_rast
        , /*Долбежная*/
          (
             SELECT o1.attr_2609_
               FROM registry.object_2138_ o1
              WHERE o1.is_deleted <> TRUE
                AND o1.attr_2149_ = 45
                AND o1.attr_2148_ = nado.id
                AND o1.attr_3208_ = (
                       SELECT MIN(o2.attr_3208_)
                         FROM registry.object_2138_ o2
                        WHERE o2.is_deleted <> TRUE
                          AND o2.attr_2149_ = 45
                          AND o2.attr_2148_ = nado.id
                    )
          ) AS otk_dolb
        , /*Шлифовальная*/
          (
             SELECT o1.attr_2609_
               FROM registry.object_2138_ o1
              WHERE o1.is_deleted <> TRUE
                AND o1.attr_2149_ = 51
                AND o1.attr_2148_ = nado.id
                AND o1.attr_3208_ = (
                       SELECT MIN(o2.attr_3208_)
                         FROM registry.object_2138_ o2
                        WHERE o2.is_deleted <> TRUE
                          AND o2.attr_2149_ = 51
                          AND o2.attr_2148_ = nado.id
                    )
          ) AS otk_shlif
        , /*Сварочная*/
          (
             SELECT o1.attr_2609_
               FROM registry.object_2138_ o1
              WHERE o1.is_deleted <> TRUE
                AND o1.attr_2149_ = 49
                AND o1.attr_2148_ = nado.id
                AND o1.attr_3208_ = (
                       SELECT MIN(o2.attr_3208_)
                         FROM registry.object_2138_ o2
                        WHERE o2.is_deleted <> TRUE
                          AND o2.attr_2149_ = 49
                          AND o2.attr_2148_ = nado.id
                    )
          ) AS otk_svar
        , /*Слесарная*/
          (
             SELECT o1.attr_2609_
               FROM registry.object_2138_ o1
              WHERE o1.is_deleted <> TRUE
                AND o1.attr_2149_ = 44
                AND o1.attr_2148_ = nado.id
                AND o1.attr_3208_ = (
                       SELECT MIN(o2.attr_3208_)
                         FROM registry.object_2138_ o2
                        WHERE o2.is_deleted <> TRUE
                          AND o2.attr_2149_ = 44
                          AND o2.attr_2148_ = nado.id
                    )
          ) AS otk_sles
        , /*Притирочная*/
          (
             SELECT o1.attr_2609_
               FROM registry.object_2138_ o1
              WHERE o1.is_deleted <> TRUE
                AND o1.attr_2149_ = 63
                AND o1.attr_2148_ = nado.id
          ) AS otk_pritir
        , /*Опрессовочная*/
          (
             SELECT o1.attr_2609_
               FROM registry.object_2138_ o1
              WHERE o1.is_deleted <> TRUE
                AND o1.attr_2149_ = 56
                AND o1.attr_2148_ = nado.id
          ) AS otk_opress
        , /*Слесарно-сборочная*/
          (
             SELECT o1.attr_2609_
               FROM registry.object_2138_ o1
              WHERE o1.is_deleted <> TRUE
                AND o1.attr_2149_ = 55
                AND o1.attr_2148_ = nado.id
          ) AS otk_sles_sbor
        , /*Токарная ЧПУ*/
          (
             SELECT o1.attr_2609_
               FROM registry.object_2138_ o1
              WHERE o1.is_deleted <> TRUE
                AND o1.attr_2149_ = 33
                AND o1.attr_2148_ = nado.id
          ) AS otk_tokr_chpu
        , /*Расточная ЧПУ*/
          (
             SELECT o1.attr_2609_
               FROM registry.object_2138_ o1
              WHERE o1.is_deleted <> TRUE
                AND o1.attr_2149_ = 59
                AND o1.attr_2148_ = nado.id
          ) AS otk_rast_chpu
        , /*Фрезерная ЧПУ*/
          (
             SELECT o1.attr_2609_
               FROM registry.object_2138_ o1
              WHERE o1.is_deleted <> TRUE
                AND o1.attr_2149_ = 60
                AND o1.attr_2148_ = nado.id
          ) AS otk_frezer_chpu
        , /*Маршрутная*/
          (
             SELECT o1.attr_2609_
               FROM registry.object_2138_ o1
              WHERE o1.is_deleted <> TRUE
                AND o1.attr_2149_ = 53
                AND o1.attr_2148_ = nado.id
          ) AS otk_marsh
        , /*Комплектовочная*/
          (
             SELECT o1.attr_2609_
               FROM registry.object_2138_ o1
              WHERE o1.is_deleted <> TRUE
                AND o1.attr_2149_ = 54
                AND o1.attr_2148_ = nado.id
          ) AS otk_kom
        , /*Упаковочная*/
          (
             SELECT o1.attr_2609_
               FROM registry.object_2138_ o1
              WHERE o1.is_deleted <> TRUE
                AND o1.attr_2149_ = 67
                AND o1.attr_2148_ = nado.id
          ) AS otk_upakov
        , /*Прочие*/
          (
             SELECT SUM(o1.attr_2609_)
               FROM registry.object_2138_ o1
              WHERE o1.is_deleted <> TRUE
                AND o1.attr_2149_ IN (62, 38, 57, 50, 52, 48, 47, 61)
                AND o1.attr_2148_ = nado.id
           ORDER BY o.attr_1964_
              LIMIT 1
          ) AS otk_procheye
        , /*Прочие Токарные*/
          (
             SELECT SUM(o1.attr_2609_)
               FROM registry.object_2138_ o1
              WHERE o1.is_deleted <> TRUE
                AND o1.attr_2149_ = 40
                AND o1.attr_2148_ = nado.id
                AND o1.id != (
                       SELECT o1.id
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2149_ = 40
                          AND o1.attr_2148_ = nado.id
                          AND o1.attr_3208_ = (
                                 SELECT MIN(o2.attr_3208_)
                                   FROM registry.object_2138_ o2
                                  WHERE o2.is_deleted <> TRUE
                                    AND o2.attr_2149_ = 40
                                    AND o2.attr_2148_ = nado.id
                              )
                    )
          ) AS otk_tokr_procheye
        , /*Прочие Шлифовальные*/
          (
             SELECT SUM(o1.attr_2609_)
               FROM registry.object_2138_ o1
              WHERE o1.is_deleted <> TRUE
                AND o1.attr_2149_ = 51
                AND o1.attr_2148_ = nado.id
                AND o1.id != (
                       SELECT o1.id
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2149_ = 51
                          AND o1.attr_2148_ = nado.id
                          AND o1.attr_3208_ = (
                                 SELECT MIN(o2.attr_3208_)
                                   FROM registry.object_2138_ o2
                                  WHERE o2.is_deleted <> TRUE
                                    AND o2.attr_2149_ = 51
                                    AND o2.attr_2148_ = nado.id
                              )
                    )
          ) AS otk_shlif_procheye
        , /*Прочие Слесарные*/
          (
             SELECT SUM(o1.attr_2609_)
               FROM registry.object_2138_ o1
              WHERE o1.is_deleted <> TRUE
                AND o1.attr_2149_ = 44
                AND o1.attr_2148_ = nado.id
                AND o1.id != (
                       SELECT o1.id
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2149_ = 44
                          AND o1.attr_2148_ = nado.id
                          AND o1.attr_3208_ = (
                                 SELECT MIN(o2.attr_3208_)
                                   FROM registry.object_2138_ o2
                                  WHERE o2.is_deleted <> TRUE
                                    AND o2.attr_2149_ = 44
                                    AND o2.attr_2148_ = nado.id
                              )
                    )
          ) AS otk_sles_procheye
        , /*Прочие Фрезерные*/
          (
             SELECT SUM(o1.attr_2609_)
               FROM registry.object_2138_ o1
              WHERE o1.is_deleted <> TRUE
                AND o1.attr_2149_ = 42
                AND o1.attr_2148_ = nado.id
                AND o1.id != (
                       SELECT o1.id
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2149_ = 42
                          AND o1.attr_2148_ = nado.id
                          AND o1.attr_3208_ = (
                                 SELECT MIN(o2.attr_3208_)
                                   FROM registry.object_2138_ o2
                                  WHERE o2.is_deleted <> TRUE
                                    AND o2.attr_2149_ = 42
                                    AND o2.attr_2148_ = nado.id
                              )
                    )
          ) AS otk_frezer_procheye
        , /*Отрезная-Проверка*/
          CASE
                    WHEN '39' = ANY (
                    (
                       SELECT ARRAY_AGG(DISTINCT o1.attr_2149_)
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2148_ = nado.id
                          AND o1.attr_2150_ = nado.attr_2632_
                    )::TEXT[]
                    ) THEN (
                    CASE
                              WHEN (
                              CASE
                                        WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                                        ELSE component.attr_1896_
                              END
                              ) = (
                                 SELECT o1.attr_2609_
                                   FROM registry.object_2138_ o1
                                  WHERE o1.is_deleted <> TRUE
                                    AND o1.attr_2149_ = 39
                                    AND o1.attr_2148_ = nado.id
                              ) THEN 1
                              ELSE 0
                    END
                    )
          END AS proverka_otrez
        , /*Токарная1-Проверка*/
          CASE
                    WHEN '46' = ANY (
                    (
                       SELECT ARRAY_AGG(DISTINCT o1.attr_2149_)
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2148_ = nado.id
                          AND o1.attr_2150_ = nado.attr_2632_
                    )::TEXT[]
                    ) THEN (
                    CASE
                              WHEN (
                              CASE
                                        WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                                        ELSE component.attr_1896_
                              END
                              ) = (
                                 SELECT o1.attr_2609_
                                   FROM registry.object_2138_ o1
                                  WHERE o1.is_deleted <> TRUE
                                    AND o1.attr_2149_ = 46
                                    AND o1.attr_2148_ = nado.id
                              ) THEN 1
                              ELSE 0
                    END
                    )
          END AS proverka_tokr1
        , /*Термическая-Проверка*/
          CASE
                    WHEN '41' = ANY (
                    (
                       SELECT ARRAY_AGG(DISTINCT o1.attr_2149_)
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2148_ = nado.id
                          AND o1.attr_2150_ = nado.attr_2632_
                    )::TEXT[]
                    ) THEN (
                    CASE
                              WHEN (
                              CASE
                                        WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                                        ELSE component.attr_1896_
                              END
                              ) = (
                                 SELECT o1.attr_2609_
                                   FROM registry.object_2138_ o1
                                  WHERE o1.is_deleted <> TRUE
                                    AND o1.attr_2149_ = 41
                                    AND o1.attr_2148_ = nado.id
                              ) THEN 1
                              ELSE 0
                    END
                    )
          END AS proverka_term
        , /*Токарная-Проверка*/
          CASE
                    WHEN '40' = ANY (
                    (
                       SELECT ARRAY_AGG(DISTINCT o1.attr_2149_)
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2148_ = nado.id
                          AND o1.attr_2150_ = nado.attr_2632_
                    )::TEXT[]
                    ) THEN (
                    CASE
                              WHEN (
                              CASE
                                        WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                                        ELSE component.attr_1896_
                              END
                              ) = (
                                 SELECT o1.attr_2609_
                                   FROM registry.object_2138_ o1
                                  WHERE o1.is_deleted <> TRUE
                                    AND o1.attr_2149_ = 40
                                    AND o1.attr_2148_ = nado.id
                                    AND o1.attr_3208_ = (
                                           SELECT MIN(o2.attr_3208_)
                                             FROM registry.object_2138_ o2
                                            WHERE o2.is_deleted <> TRUE
                                              AND o2.attr_2149_ = 40
                                              AND o2.attr_2148_ = nado.id
                                        )
                              ) THEN 1
                              ELSE 0
                    END
                    )
          END AS proverka_tokr
        , /*Фрезерная-Проверка*/
          CASE
                    WHEN '42' = ANY (
                    (
                       SELECT ARRAY_AGG(DISTINCT o1.attr_2149_)
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2148_ = nado.id
                          AND o1.attr_2150_ = nado.attr_2632_
                    )::TEXT[]
                    ) THEN (
                    CASE
                              WHEN (
                              CASE
                                        WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                                        ELSE component.attr_1896_
                              END
                              ) = (
                                 SELECT o1.attr_2609_
                                   FROM registry.object_2138_ o1
                                  WHERE o1.is_deleted <> TRUE
                                    AND o1.attr_2149_ = 42
                                    AND o1.attr_2148_ = nado.id
                                    AND o1.attr_3208_ = (
                                           SELECT MIN(o2.attr_3208_)
                                             FROM registry.object_2138_ o2
                                            WHERE o2.is_deleted <> TRUE
                                              AND o2.attr_2149_ = 42
                                              AND o2.attr_2148_ = nado.id
                                        )
                              ) THEN 1
                              ELSE 0
                    END
                    )
          END AS proverka_frezer
        , /*Расточная-Проверка*/
          CASE
                    WHEN '43' = ANY (
                    (
                       SELECT ARRAY_AGG(DISTINCT o1.attr_2149_)
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2148_ = nado.id
                          AND o1.attr_2150_ = nado.attr_2632_
                    )::TEXT[]
                    ) THEN (
                    CASE
                              WHEN (
                              CASE
                                        WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                                        ELSE component.attr_1896_
                              END
                              ) = (
                                 SELECT o1.attr_2609_
                                   FROM registry.object_2138_ o1
                                  WHERE o1.is_deleted <> TRUE
                                    AND o1.attr_2149_ = 43
                                    AND o1.attr_2148_ = nado.id
                                    AND o1.attr_3208_ = (
                                           SELECT MIN(o2.attr_3208_)
                                             FROM registry.object_2138_ o2
                                            WHERE o2.is_deleted <> TRUE
                                              AND o2.attr_2149_ = 43
                                              AND o2.attr_2148_ = nado.id
                                        )
                              ) THEN 1
                              ELSE 0
                    END
                    )
          END AS proverka_rast
        , /*Долбежная-Проверка*/
          CASE
                    WHEN '45' = ANY (
                    (
                       SELECT ARRAY_AGG(DISTINCT o1.attr_2149_)
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2148_ = nado.id
                          AND o1.attr_2150_ = nado.attr_2632_
                    )::TEXT[]
                    ) THEN (
                    CASE
                              WHEN (
                              CASE
                                        WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                                        ELSE component.attr_1896_
                              END
                              ) = (
                                 SELECT o1.attr_2609_
                                   FROM registry.object_2138_ o1
                                  WHERE o1.is_deleted <> TRUE
                                    AND o1.attr_2149_ = 45
                                    AND o1.attr_2148_ = nado.id
                                    AND o1.attr_3208_ = (
                                           SELECT MIN(o2.attr_3208_)
                                             FROM registry.object_2138_ o2
                                            WHERE o2.is_deleted <> TRUE
                                              AND o2.attr_2149_ = 45
                                              AND o2.attr_2148_ = nado.id
                                        )
                              ) THEN 1
                              ELSE 0
                    END
                    )
          END AS proverka_dolb
        , /*Шлифовальная-Проверка*/
          CASE
                    WHEN '51' = ANY (
                    (
                       SELECT ARRAY_AGG(DISTINCT o1.attr_2149_)
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2148_ = nado.id
                          AND o1.attr_2150_ = nado.attr_2632_
                    )::TEXT[]
                    ) THEN (
                    CASE
                              WHEN (
                              CASE
                                        WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                                        ELSE component.attr_1896_
                              END
                              ) = (
                                 SELECT o1.attr_2609_
                                   FROM registry.object_2138_ o1
                                  WHERE o1.is_deleted <> TRUE
                                    AND o1.attr_2149_ = 51
                                    AND o1.attr_2148_ = nado.id
                                    AND o1.attr_3208_ = (
                                           SELECT MIN(o2.attr_3208_)
                                             FROM registry.object_2138_ o2
                                            WHERE o2.is_deleted <> TRUE
                                              AND o2.attr_2149_ = 51
                                              AND o2.attr_2148_ = nado.id
                                        )
                              ) THEN 1
                              ELSE 0
                    END
                    )
          END AS proverka_shlif
        , /*Сварочная-Проверка*/
          CASE
                    WHEN '49' = ANY (
                    (
                       SELECT ARRAY_AGG(DISTINCT o1.attr_2149_)
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2148_ = nado.id
                          AND o1.attr_2150_ = nado.attr_2632_
                    )::TEXT[]
                    ) THEN (
                    CASE
                              WHEN (
                              CASE
                                        WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                                        ELSE component.attr_1896_
                              END
                              ) = (
                                 SELECT o1.attr_2609_
                                   FROM registry.object_2138_ o1
                                  WHERE o1.is_deleted <> TRUE
                                    AND o1.attr_2149_ = 49
                                    AND o1.attr_2148_ = nado.id
                                    AND o1.attr_3208_ = (
                                           SELECT MIN(o2.attr_3208_)
                                             FROM registry.object_2138_ o2
                                            WHERE o2.is_deleted <> TRUE
                                              AND o2.attr_2149_ = 49
                                              AND o2.attr_2148_ = nado.id
                                        )
                              ) THEN 1
                              ELSE 0
                    END
                    )
          END AS proverka_svar
        , /*Слесарная-Проверка*/
          CASE
                    WHEN '44' = ANY (
                    (
                       SELECT ARRAY_AGG(DISTINCT o1.attr_2149_)
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2148_ = nado.id
                          AND o1.attr_2150_ = nado.attr_2632_
                    )::TEXT[]
                    ) THEN (
                    CASE
                              WHEN (
                              CASE
                                        WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                                        ELSE component.attr_1896_
                              END
                              ) = (
                                 SELECT o1.attr_2609_
                                   FROM registry.object_2138_ o1
                                  WHERE o1.is_deleted <> TRUE
                                    AND o1.attr_2149_ = 44
                                    AND o1.attr_2148_ = nado.id
                                    AND o1.attr_3208_ = (
                                           SELECT MIN(o2.attr_3208_)
                                             FROM registry.object_2138_ o2
                                            WHERE o2.is_deleted <> TRUE
                                              AND o2.attr_2149_ = 44
                                              AND o2.attr_2148_ = nado.id
                                        )
                              ) THEN 1
                              ELSE 0
                    END
                    )
          END AS proverka_sles
        , /*Притирочная-Проверка*/
          CASE
                    WHEN '63' = ANY (
                    (
                       SELECT ARRAY_AGG(DISTINCT o1.attr_2149_)
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2148_ = nado.id
                          AND o1.attr_2150_ = nado.attr_2632_
                    )::TEXT[]
                    ) THEN (
                    CASE
                              WHEN (
                              CASE
                                        WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                                        ELSE component.attr_1896_
                              END
                              ) = (
                                 SELECT o1.attr_2609_
                                   FROM registry.object_2138_ o1
                                  WHERE o1.is_deleted <> TRUE
                                    AND o1.attr_2149_ = 63
                                    AND o1.attr_2148_ = nado.id
                              ) THEN 1
                              ELSE 0
                    END
                    )
          END AS proverka_pritir
        , /*Опрессовочная-Проверка*/
          CASE
                    WHEN '56' = ANY (
                    (
                       SELECT ARRAY_AGG(DISTINCT o1.attr_2149_)
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2148_ = nado.id
                          AND o1.attr_2150_ = nado.attr_2632_
                    )::TEXT[]
                    ) THEN (
                    CASE
                              WHEN (
                              CASE
                                        WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                                        ELSE component.attr_1896_
                              END
                              ) = (
                                 SELECT o1.attr_2609_
                                   FROM registry.object_2138_ o1
                                  WHERE o1.is_deleted <> TRUE
                                    AND o1.attr_2149_ = 56
                                    AND o1.attr_2148_ = nado.id
                              ) THEN 1
                              ELSE 0
                    END
                    )
          END AS proverka_opress
        , /*Слесарно-сборочная-Проверка*/
          CASE
                    WHEN '55' = ANY (
                    (
                       SELECT ARRAY_AGG(DISTINCT o1.attr_2149_)
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2148_ = nado.id
                          AND o1.attr_2150_ = nado.attr_2632_
                    )::TEXT[]
                    ) THEN (
                    CASE
                              WHEN (
                              CASE
                                        WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                                        ELSE component.attr_1896_
                              END
                              ) = (
                                 SELECT o1.attr_2609_
                                   FROM registry.object_2138_ o1
                                  WHERE o1.is_deleted <> TRUE
                                    AND o1.attr_2149_ = 55
                                    AND o1.attr_2148_ = nado.id
                              ) THEN 1
                              ELSE 0
                    END
                    )
          END AS proverka_sles_sbor
        , /*Токарная ЧПУ-Проверка*/
          CASE
                    WHEN '33' = ANY (
                    (
                       SELECT ARRAY_AGG(DISTINCT o1.attr_2149_)
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2148_ = nado.id
                          AND o1.attr_2150_ = nado.attr_2632_
                    )::TEXT[]
                    ) THEN (
                    CASE
                              WHEN (
                              CASE
                                        WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                                        ELSE component.attr_1896_
                              END
                              ) = (
                                 SELECT o1.attr_2609_
                                   FROM registry.object_2138_ o1
                                  WHERE o1.is_deleted <> TRUE
                                    AND o1.attr_2149_ = 33
                                    AND o1.attr_2148_ = nado.id
                              ) THEN 1
                              ELSE 0
                    END
                    )
          END AS proverka_tokr_chpu
        , /*Расточная ЧПУ-Проверка*/
          CASE
                    WHEN '59' = ANY (
                    (
                       SELECT ARRAY_AGG(DISTINCT o1.attr_2149_)
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2148_ = nado.id
                          AND o1.attr_2150_ = nado.attr_2632_
                    )::TEXT[]
                    ) THEN (
                    CASE
                              WHEN (
                              CASE
                                        WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                                        ELSE component.attr_1896_
                              END
                              ) = (
                                 SELECT o1.attr_2609_
                                   FROM registry.object_2138_ o1
                                  WHERE o1.is_deleted <> TRUE
                                    AND o1.attr_2149_ = 59
                                    AND o1.attr_2148_ = nado.id
                              ) THEN 1
                              ELSE 0
                    END
                    )
          END AS proverka_rast_chpu
        , /*Фрезерная ЧПУ-Проверка*/
          CASE
                    WHEN '60' = ANY (
                    (
                       SELECT ARRAY_AGG(DISTINCT o1.attr_2149_)
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2148_ = nado.id
                          AND o1.attr_2150_ = nado.attr_2632_
                    )::TEXT[]
                    ) THEN (
                    CASE
                              WHEN (
                              CASE
                                        WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                                        ELSE component.attr_1896_
                              END
                              ) = (
                                 SELECT o1.attr_2609_
                                   FROM registry.object_2138_ o1
                                  WHERE o1.is_deleted <> TRUE
                                    AND o1.attr_2149_ = 60
                                    AND o1.attr_2148_ = nado.id
                              ) THEN 1
                              ELSE 0
                    END
                    )
          END AS proverka_frezer_chpu
        , /*Маршрутная-Проверка*/
          CASE
                    WHEN '53' = ANY (
                    (
                       SELECT ARRAY_AGG(DISTINCT o1.attr_2149_)
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2148_ = nado.id
                          AND o1.attr_2150_ = nado.attr_2632_
                    )::TEXT[]
                    ) THEN (
                    CASE
                              WHEN (
                              CASE
                                        WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                                        ELSE component.attr_1896_
                              END
                              ) = (
                                 SELECT o1.attr_2609_
                                   FROM registry.object_2138_ o1
                                  WHERE o1.is_deleted <> TRUE
                                    AND o1.attr_2149_ = 53
                                    AND o1.attr_2148_ = nado.id
                              ) THEN 1
                              ELSE 0
                    END
                    )
          END AS proverka_marsh
        , /*Комплектовочная-Проверка*/
          CASE
                    WHEN '54' = ANY (
                    (
                       SELECT ARRAY_AGG(DISTINCT o1.attr_2149_)
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2148_ = nado.id
                          AND o1.attr_2150_ = nado.attr_2632_
                    )::TEXT[]
                    ) THEN (
                    CASE
                              WHEN (
                              CASE
                                        WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                                        ELSE component.attr_1896_
                              END
                              ) = (
                                 SELECT o1.attr_2609_
                                   FROM registry.object_2138_ o1
                                  WHERE o1.is_deleted <> TRUE
                                    AND o1.attr_2149_ = 54
                                    AND o1.attr_2148_ = nado.id
                              ) THEN 1
                              ELSE 0
                    END
                    )
          END AS proverka_kom
        , /*Упаковочная-Проверка*/
          CASE
                    WHEN '67' = ANY (
                    (
                       SELECT ARRAY_AGG(DISTINCT o1.attr_2149_)
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2148_ = nado.id
                          AND o1.attr_2150_ = nado.attr_2632_
                    )::TEXT[]
                    ) THEN (
                    CASE
                              WHEN (
                              CASE
                                        WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                                        ELSE component.attr_1896_
                              END
                              ) = (
                                 SELECT o1.attr_2609_
                                   FROM registry.object_2138_ o1
                                  WHERE o1.is_deleted <> TRUE
                                    AND o1.attr_2149_ = 67
                                    AND o1.attr_2148_ = nado.id
                              ) THEN 1
                              ELSE 0
                    END
                    )
          END AS proverka_upakov
        , /*Отрезная_Проверка2 (Если кол-во больше, чем планове = синий)*/
          CASE
                    WHEN (
                       SELECT o1.attr_2609_
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2149_ = 39
                          AND o1.attr_2148_ = nado.id
                    ) > (
                    CASE
                              WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                              ELSE component.attr_1896_
                    END
                    ) THEN 'blue'
          END AS proverka2_otrez
        , /*Токарная1-Проверка2*/
          CASE
                    WHEN (
                       SELECT o1.attr_2609_
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2149_ = 46
                          AND o1.attr_2148_ = nado.id
                    ) > (
                    CASE
                              WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                              ELSE component.attr_1896_
                    END
                    ) THEN 'blue'
          END AS proverka2_tokr1
        , /*Термическая-Проверка2*/
          CASE
                    WHEN (
                       SELECT o1.attr_2609_
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2149_ = 41
                          AND o1.attr_2148_ = nado.id
                    ) > (
                    CASE
                              WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                              ELSE component.attr_1896_
                    END
                    ) THEN 'blue'
          END AS proverka2_term
        , /*Токарная-Проверка2*/
          CASE
                    WHEN (
                       SELECT o1.attr_2609_
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2149_ = 40
                          AND o1.attr_2148_ = nado.id
                          AND o1.attr_3208_ = (
                                 SELECT MIN(o2.attr_3208_)
                                   FROM registry.object_2138_ o2
                                  WHERE o2.is_deleted <> TRUE
                                    AND o2.attr_2149_ = 40
                                    AND o2.attr_2148_ = nado.id
                              )
                    ) > (
                    CASE
                              WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                              ELSE component.attr_1896_
                    END
                    ) THEN 'blue'
          END AS proverka2_tokr
        , /*Фрезерная-Проверка2*/
          CASE
                    WHEN (
                       SELECT o1.attr_2609_
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2149_ = 42
                          AND o1.attr_2148_ = nado.id
                          AND o1.attr_3208_ = (
                                 SELECT MIN(o2.attr_3208_)
                                   FROM registry.object_2138_ o2
                                  WHERE o2.is_deleted <> TRUE
                                    AND o2.attr_2149_ = 42
                                    AND o2.attr_2148_ = nado.id
                              )
                    ) > (
                    CASE
                              WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                              ELSE component.attr_1896_
                    END
                    ) THEN 'blue'
          END AS proverka2_frezer
        , /*Расточная-Проверка2*/
          CASE
                    WHEN (
                       SELECT o1.attr_2609_
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2149_ = 43
                          AND o1.attr_2148_ = nado.id
                          AND o1.attr_3208_ = (
                                 SELECT MIN(o2.attr_3208_)
                                   FROM registry.object_2138_ o2
                                  WHERE o2.is_deleted <> TRUE
                                    AND o2.attr_2149_ = 43
                                    AND o2.attr_2148_ = nado.id
                              )
                    ) > (
                    CASE
                              WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                              ELSE component.attr_1896_
                    END
                    ) THEN 'blue'
          END AS proverka2_rast
        , /*Долбежная-Проверка2*/
          CASE
                    WHEN (
                       SELECT o1.attr_2609_
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2149_ = 45
                          AND o1.attr_2148_ = nado.id
                          AND o1.attr_3208_ = (
                                 SELECT MIN(o2.attr_3208_)
                                   FROM registry.object_2138_ o2
                                  WHERE o2.is_deleted <> TRUE
                                    AND o2.attr_2149_ = 45
                                    AND o2.attr_2148_ = nado.id
                              )
                    ) > (
                    CASE
                              WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                              ELSE component.attr_1896_
                    END
                    ) THEN 'blue'
          END AS proverka2_dolb
        , /*Шлифовальная-Проверка2*/
          CASE
                    WHEN (
                       SELECT o1.attr_2609_
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2149_ = 51
                          AND o1.attr_2148_ = nado.id
                          AND o1.attr_3208_ = (
                                 SELECT MIN(o2.attr_3208_)
                                   FROM registry.object_2138_ o2
                                  WHERE o2.is_deleted <> TRUE
                                    AND o2.attr_2149_ = 51
                                    AND o2.attr_2148_ = nado.id
                              )
                    ) > (
                    CASE
                              WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                              ELSE component.attr_1896_
                    END
                    ) THEN 'blue'
          END AS proverka2_shlif
        , /*Сварочная-Проверка2*/
          CASE
                    WHEN (
                       SELECT o1.attr_2609_
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2149_ = 49
                          AND o1.attr_2148_ = nado.id
                          AND o1.attr_3208_ = (
                                 SELECT MIN(o2.attr_3208_)
                                   FROM registry.object_2138_ o2
                                  WHERE o2.is_deleted <> TRUE
                                    AND o2.attr_2149_ = 49
                                    AND o2.attr_2148_ = nado.id
                              )
                    ) > (
                    CASE
                              WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                              ELSE component.attr_1896_
                    END
                    ) THEN 'blue'
          END AS proverka2_svar
        , /*Слесарная-Проверка2*/
          CASE
                    WHEN (
                       SELECT o1.attr_2609_
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2149_ = 44
                          AND o1.attr_2148_ = nado.id
                          AND o1.attr_3208_ = (
                                 SELECT MIN(o2.attr_3208_)
                                   FROM registry.object_2138_ o2
                                  WHERE o2.is_deleted <> TRUE
                                    AND o2.attr_2149_ = 44
                                    AND o2.attr_2148_ = nado.id
                              )
                    ) > (
                    CASE
                              WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                              ELSE component.attr_1896_
                    END
                    ) THEN 'blue'
          END AS proverka2_sles
        , /*Притирочная-Проверка2*/
          CASE
                    WHEN (
                       SELECT o1.attr_2609_
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2149_ = 63
                          AND o1.attr_2148_ = nado.id
                    ) > (
                    CASE
                              WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                              ELSE component.attr_1896_
                    END
                    ) THEN 'blue'
          END AS proverka2_pritir
        , /*Опрессовочная-Проверка2*/
          CASE
                    WHEN (
                       SELECT o1.attr_2609_
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2149_ = 56
                          AND o1.attr_2148_ = nado.id
                    ) > (
                    CASE
                              WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                              ELSE component.attr_1896_
                    END
                    ) THEN 'blue'
          END AS proverka2_opress
        , /*Слесарно-сборочная-Проверка2*/
          CASE
                    WHEN (
                       SELECT o1.attr_2609_
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2149_ = 55
                          AND o1.attr_2148_ = nado.id
                    ) > (
                    CASE
                              WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                              ELSE component.attr_1896_
                    END
                    ) THEN 'blue'
          END AS proverka2_sles_sbor
        , /*Токарная ЧПУ-Проверка2*/
          CASE
                    WHEN (
                       SELECT o1.attr_2609_
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2149_ = 33
                          AND o1.attr_2148_ = nado.id
                    ) > (
                    CASE
                              WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                              ELSE component.attr_1896_
                    END
                    ) THEN 'blue'
          END AS proverka2_tokr_chpu
        , /*Расточная ЧПУ-Проверка2*/
          CASE
                    WHEN (
                       SELECT o1.attr_2609_
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2149_ = 59
                          AND o1.attr_2148_ = nado.id
                    ) > (
                    CASE
                              WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                              ELSE component.attr_1896_
                    END
                    ) THEN 'blue'
          END AS proverka2_rast_chpu
        , /*Фрезерная ЧПУ-Проверка2*/
          CASE
                    WHEN (
                       SELECT o1.attr_2609_
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2149_ = 60
                          AND o1.attr_2148_ = nado.id
                    ) > (
                    CASE
                              WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                              ELSE component.attr_1896_
                    END
                    ) THEN 'blue'
          END AS proverka2_frezer_chpu
        , /*Маршрутная-Проверка2*/
          CASE
                    WHEN (
                       SELECT o1.attr_2609_
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2149_ = 53
                          AND o1.attr_2148_ = nado.id
                    ) > (
                    CASE
                              WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                              ELSE component.attr_1896_
                    END
                    ) THEN 'blue'
          END AS proverka2_marsh
        , /*Комплектовочная-Проверка2*/
          CASE
                    WHEN (
                       SELECT o1.attr_2609_
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2149_ = 54
                          AND o1.attr_2148_ = nado.id
                    ) > (
                    CASE
                              WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                              ELSE component.attr_1896_
                    END
                    ) THEN 'blue'
          END AS proverka2_kom
        , /*Упаковочная-Проверка2*/
          CASE
                    WHEN (
                       SELECT o1.attr_2609_
                         FROM registry.object_2138_ o1
                        WHERE o1.is_deleted <> TRUE
                          AND o1.attr_2149_ = 67
                          AND o1.attr_2148_ = nado.id
                    ) > (
                    CASE
                              WHEN component.attr_1411_ IN (1, 2, 8, 9) THEN project.attr_1895_
                              ELSE component.attr_1896_
                    END
                    ) THEN 'blue'
          END AS proverka2_upakov
     FROM registry.object_606_ o
LEFT JOIN registry.object_1227_ project ON project.attr_1923_ = o.id
      AND project.is_deleted <> TRUE
LEFT JOIN registry.object_1409_ component ON component.attr_1423_ = project.id
      AND component.is_deleted <> TRUE
      AND component.attr_1896_ <> -0
          /*Ссылка на ПВ*/
LEFT JOIN registry.object_301_ orn ON component.attr_1458_ = orn.id
      AND orn.is_deleted <> TRUE




LEFT JOIN registry.object_2094_ comp_task ON comp_task.attr_2100_ = component.ID 
AND comp_task.is_deleted IS FALSE 


LEFT JOIN registry.object_2137_ nado ON nado.attr_2632_ = orn.id
      AND nado.is_deleted <> TRUE
      AND component.attr_1414_::INTEGER = ANY (nado.attr_4033_)
      AND nado.attr_3193_ =comp_task.attr_3175_


    WHERE o.is_deleted <> TRUE
      AND o.id = '{superid}'
      AND component.attr_1896_ <> 0