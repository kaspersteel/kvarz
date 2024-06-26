SELECT
    o.id
  , o.attr_374_
  , o.attr_1455_    AS rod_id
  , nomen.attr_362_ AS name_nom
  , o.attr_371_     AS kol_vo
  , CASE
        WHEN nomen.attr_363_ = 6 THEN CASE
            WHEN nomen.attr_1094_ <> 216 THEN concat (
                nomen.attr_362_
              , ' '
              , gost.attr_428_
              , ' '
              , nomen.attr_376_
            )
            WHEN nomen.attr_1094_ = 216 THEN concat (nomen.attr_376_, '; ', mat.attr_401_)
        END
        WHEN nomen.attr_363_ = 9 THEN concat (nomen.attr_376_, ' ', nomen.attr_362_)
        ELSE nomen.attr_376_
    END AS obz
  , /*Отрезная*/ (
        CASE
            WHEN (t_otrez.sum_time_op * o.attr_371_) IS NULL THEN 0
            ELSE (t_otrez.sum_time_op * o.attr_371_)
        END
    ) + (
        (
            SELECT
                SUM(
                    CASE
                        WHEN j.otr_op_st IS NULL THEN 0
                        ELSE j.otr_op_st
                    END
                )
            FROM
                (
                    SELECT
                        comp.id
                      , nom_in_comp.id AS nom_in_comp_id
                      , tech_card.id   AS tech_card_id
                      , CASE
                            WHEN (otr_op.sum_time * comp.attr_371_) IS NULL THEN 0
                            ELSE otr_op.sum_time * comp.attr_371_
                        END AS otr_op_st
                    FROM
                        registry.object_369_ comp
                        LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                        LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                        AND tech_card.is_deleted <> TRUE
                        AND tech_card.attr_2908_ = TRUE
                        LEFT JOIN (
                            SELECT
                                o.attr_538_
                              , SUM(o.attr_1443_) AS sum_time
                            FROM
                                registry.object_527_ o
                            WHERE
                                o.is_deleted <> TRUE
                                AND o.attr_586_ = 39
                            GROUP BY
                                o.attr_538_
                        ) otr_op ON otr_op.attr_538_ = tech_card.id
                    WHERE
                        comp.is_deleted <> TRUE
                        AND comp.attr_1455_ = o.id
                        AND nom_in_comp.attr_363_ NOT IN (2)
                ) j
        ) * o.attr_371_
    ) AS otr_op_st
  , /*Токарная*/ (
        CASE
            WHEN (t_tokrn.sum_time_op * o.attr_371_) IS NULL THEN 0
            ELSE (t_tokrn.sum_time_op * o.attr_371_)
        END
    ) + (
        (
            SELECT
                SUM(
                    CASE
                        WHEN j.tokr_op_st IS NULL THEN 0
                        ELSE j.tokr_op_st
                    END
                )
            FROM
                (
                    SELECT
                        comp.id
                      , nom_in_comp.id AS nom_in_comp_id
                      , tech_card.id   AS tech_card_id
                      , CASE
                            WHEN (tokr_op.sum_time * comp.attr_371_) IS NULL THEN 0
                            ELSE tokr_op.sum_time * comp.attr_371_
                        END AS tokr_op_st
                    FROM
                        registry.object_369_ comp
                        LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                        LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                        AND tech_card.is_deleted <> TRUE
                        AND tech_card.attr_2908_ = TRUE
                        LEFT JOIN (
                            SELECT
                                o.attr_538_
                              , SUM(o.attr_1443_) AS sum_time
                            FROM
                                registry.object_527_ o
                            WHERE
                                o.is_deleted <> TRUE
                                AND o.attr_586_ = 40
                            GROUP BY
                                o.attr_538_
                        ) tokr_op ON tokr_op.attr_538_ = tech_card.id
                    WHERE
                        comp.is_deleted <> TRUE
                        AND comp.attr_1455_ = o.id
                        AND nom_in_comp.attr_363_ NOT IN (2)
                ) j
        ) * o.attr_371_
    ) AS tokrn_op
  , /*Фрезерная*/ (
        CASE
            WHEN (t_frez.sum_time_op * o.attr_371_) IS NULL THEN 0
            ELSE (t_frez.sum_time_op * o.attr_371_)
        END
    ) + (
        (
            SELECT
                SUM(
                    CASE
                        WHEN j.frez_op_st IS NULL THEN 0
                        ELSE j.frez_op_st
                    END
                )
            FROM
                (
                    SELECT
                        comp.id
                      , nom_in_comp.id AS nom_in_comp_id
                      , tech_card.id   AS tech_card_id
                      , CASE
                            WHEN (frez_op.sum_time * comp.attr_371_) IS NULL THEN 0
                            ELSE frez_op.sum_time * comp.attr_371_
                        END AS frez_op_st
                    FROM
                        registry.object_369_ comp
                        LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                        LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                        AND tech_card.is_deleted <> TRUE
                        AND tech_card.attr_2908_ = TRUE
                        LEFT JOIN (
                            SELECT
                                o.attr_538_
                              , SUM(o.attr_1443_) AS sum_time
                            FROM
                                registry.object_527_ o
                            WHERE
                                o.is_deleted <> TRUE
                                AND o.attr_586_ = 42
                            GROUP BY
                                o.attr_538_
                        ) frez_op ON frez_op.attr_538_ = tech_card.id
                    WHERE
                        comp.is_deleted <> TRUE
                        AND comp.attr_1455_ = o.id
                        AND nom_in_comp.attr_363_ NOT IN (2)
                ) j
        ) * o.attr_371_
    ) AS frez_op
  , /*Расточная*/ (
        CASE
            WHEN (t_rast.sum_time_op * o.attr_371_) IS NULL THEN 0
            ELSE (t_rast.sum_time_op * o.attr_371_)
        END
    ) + (
        (
            SELECT
                SUM(
                    CASE
                        WHEN j.rast_op_st IS NULL THEN 0
                        ELSE j.rast_op_st
                    END
                )
            FROM
                (
                    SELECT
                        comp.id
                      , nom_in_comp.id AS nom_in_comp_id
                      , tech_card.id   AS tech_card_id
                      , CASE
                            WHEN (rast_op.sum_time * comp.attr_371_) IS NULL THEN 0
                            ELSE rast_op.sum_time * comp.attr_371_
                        END AS rast_op_st
                    FROM
                        registry.object_369_ comp
                        LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                        LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                        AND tech_card.is_deleted <> TRUE
                        AND tech_card.attr_2908_ = TRUE
                        LEFT JOIN (
                            SELECT
                                o.attr_538_
                              , SUM(o.attr_1443_) AS sum_time
                            FROM
                                registry.object_527_ o
                            WHERE
                                o.is_deleted <> TRUE
                                AND o.attr_586_ = 43
                            GROUP BY
                                o.attr_538_
                        ) rast_op ON rast_op.attr_538_ = tech_card.id
                    WHERE
                        comp.is_deleted <> TRUE
                        AND comp.attr_1455_ = o.id
                        AND nom_in_comp.attr_363_ NOT IN (2)
                ) j
        ) * o.attr_371_
    ) AS rast_op
  , /*Сверлильная*/ (
        CASE
            WHEN (t_sverl.sum_time_op * o.attr_371_) IS NULL THEN 0
            ELSE (t_sverl.sum_time_op * o.attr_371_)
        END
    ) + (
        (
            SELECT
                SUM(
                    CASE
                        WHEN j.sverl_op_st IS NULL THEN 0
                        ELSE j.sverl_op_st
                    END
                )
            FROM
                (
                    SELECT
                        comp.id
                      , nom_in_comp.id AS nom_in_comp_id
                      , tech_card.id   AS tech_card_id
                      , CASE
                            WHEN (sverl_op.sum_time * comp.attr_371_) IS NULL THEN 0
                            ELSE sverl_op.sum_time * comp.attr_371_
                        END AS sverl_op_st
                    FROM
                        registry.object_369_ comp
                        LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                        LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                        AND tech_card.is_deleted <> TRUE
                        AND tech_card.attr_2908_ = TRUE
                        LEFT JOIN (
                            SELECT
                                o.attr_538_
                              , SUM(o.attr_1443_) AS sum_time
                            FROM
                                registry.object_527_ o
                            WHERE
                                o.is_deleted <> TRUE
                                AND o.attr_586_ = 47
                            GROUP BY
                                o.attr_538_
                        ) sverl_op ON sverl_op.attr_538_ = tech_card.id
                    WHERE
                        comp.is_deleted <> TRUE
                        AND comp.attr_1455_ = o.id
                        AND nom_in_comp.attr_363_ NOT IN (2)
                ) j
        ) * o.attr_371_
    ) AS sverl_op
  , /*Долбежная*/ (
        CASE
            WHEN (t_dolb.sum_time_op * o.attr_371_) IS NULL THEN 0
            ELSE (t_dolb.sum_time_op * o.attr_371_)
        END
    ) + (
        (
            SELECT
                SUM(
                    CASE
                        WHEN j.dolb_op_st IS NULL THEN 0
                        ELSE j.dolb_op_st
                    END
                )
            FROM
                (
                    SELECT
                        comp.id
                      , nom_in_comp.id AS nom_in_comp_id
                      , tech_card.id   AS tech_card_id
                      , CASE
                            WHEN (dolb_op.sum_time * comp.attr_371_) IS NULL THEN 0
                            ELSE dolb_op.sum_time * comp.attr_371_
                        END AS dolb_op_st
                    FROM
                        registry.object_369_ comp
                        LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                        LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                        AND tech_card.is_deleted <> TRUE
                        AND tech_card.attr_2908_ = TRUE
                        LEFT JOIN (
                            SELECT
                                o.attr_538_
                              , SUM(o.attr_1443_) AS sum_time
                            FROM
                                registry.object_527_ o
                            WHERE
                                o.is_deleted <> TRUE
                                AND o.attr_586_ = 45
                            GROUP BY
                                o.attr_538_
                        ) dolb_op ON dolb_op.attr_538_ = tech_card.id
                    WHERE
                        comp.is_deleted <> TRUE
                        AND comp.attr_1455_ = o.id
                        AND nom_in_comp.attr_363_ NOT IN (2)
                ) j
        ) * o.attr_371_
    ) AS dolb_op
  , /*Шлифовальная*/ (
        CASE
            WHEN (t_shlif.sum_time_op * o.attr_371_) IS NULL THEN 0
            ELSE (t_shlif.sum_time_op * o.attr_371_)
        END
    ) + (
        (
            SELECT
                SUM(
                    CASE
                        WHEN j.shlif_op_st IS NULL THEN 0
                        ELSE j.shlif_op_st
                    END
                )
            FROM
                (
                    SELECT
                        comp.id
                      , nom_in_comp.id AS nom_in_comp_id
                      , tech_card.id   AS tech_card_id
                      , CASE
                            WHEN (shlif_op.sum_time * comp.attr_371_) IS NULL THEN 0
                            ELSE shlif_op.sum_time * comp.attr_371_
                        END AS shlif_op_st
                    FROM
                        registry.object_369_ comp
                        LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                        LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                        AND tech_card.is_deleted <> TRUE
                        AND tech_card.attr_2908_ = TRUE
                        LEFT JOIN (
                            SELECT
                                o.attr_538_
                              , SUM(o.attr_1443_) AS sum_time
                            FROM
                                registry.object_527_ o
                            WHERE
                                o.is_deleted <> TRUE
                                AND o.attr_586_ = 51
                            GROUP BY
                                o.attr_538_
                        ) shlif_op ON shlif_op.attr_538_ = tech_card.id
                    WHERE
                        comp.is_deleted <> TRUE
                        AND comp.attr_1455_ = o.id
                        AND nom_in_comp.attr_363_ NOT IN (2)
                ) j
        ) * o.attr_371_
    ) AS shlif_op
  , /*Сварочная*/ (
        CASE
            WHEN (t_svar.sum_time_op * o.attr_371_) IS NULL THEN 0
            ELSE (t_svar.sum_time_op * o.attr_371_)
        END
    ) + (
        (
            SELECT
                SUM(
                    CASE
                        WHEN j.svar_op_st IS NULL THEN 0
                        ELSE j.svar_op_st
                    END
                )
            FROM
                (
                    SELECT
                        comp.id
                      , nom_in_comp.id AS nom_in_comp_id
                      , tech_card.id   AS tech_card_id
                      , CASE
                            WHEN (svar_op.sum_time * comp.attr_371_) IS NULL THEN 0
                            ELSE svar_op.sum_time * comp.attr_371_
                        END AS svar_op_st
                    FROM
                        registry.object_369_ comp
                        LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                        LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                        AND tech_card.is_deleted <> TRUE
                        AND tech_card.attr_2908_ = TRUE
                        LEFT JOIN (
                            SELECT
                                o.attr_538_
                              , SUM(o.attr_1443_) AS sum_time
                            FROM
                                registry.object_527_ o
                            WHERE
                                o.is_deleted <> TRUE
                                AND o.attr_586_ = 49
                            GROUP BY
                                o.attr_538_
                        ) svar_op ON svar_op.attr_538_ = tech_card.id
                    WHERE
                        comp.is_deleted <> TRUE
                        AND comp.attr_1455_ = o.id
                        AND nom_in_comp.attr_363_ NOT IN (2)
                ) j
        ) * o.attr_371_
    ) AS svar_op
  , /*Слесарная*/ (
        CASE
            WHEN (t_sles.sum_time_op * o.attr_371_) IS NULL THEN 0
            ELSE (t_sles.sum_time_op * o.attr_371_)
        END
    ) + (
        (
            SELECT
                SUM(
                    CASE
                        WHEN j.sles_op_st IS NULL THEN 0
                        ELSE j.sles_op_st
                    END
                )
            FROM
                (
                    SELECT
                        comp.id
                      , nom_in_comp.id AS nom_in_comp_id
                      , tech_card.id   AS tech_card_id
                      , CASE
                            WHEN (sles_op.sum_time * comp.attr_371_) IS NULL THEN 0
                            ELSE sles_op.sum_time * comp.attr_371_
                        END AS sles_op_st
                    FROM
                        registry.object_369_ comp
                        LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                        LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                        AND tech_card.is_deleted <> TRUE
                        AND tech_card.attr_2908_ = TRUE
                        LEFT JOIN (
                            SELECT
                                o.attr_538_
                              , SUM(o.attr_1443_) AS sum_time
                            FROM
                                registry.object_527_ o
                            WHERE
                                o.is_deleted <> TRUE
                                AND o.attr_586_ = 44
                            GROUP BY
                                o.attr_538_
                        ) sles_op ON sles_op.attr_538_ = tech_card.id
                    WHERE
                        comp.is_deleted <> TRUE
                        AND comp.attr_1455_ = o.id
                        AND nom_in_comp.attr_363_ NOT IN (2)
                ) j
        ) * o.attr_371_
    ) AS sles_op
  , /*Термическая*/ (
        CASE
            WHEN (t_term.sum_time_op * o.attr_371_) IS NULL THEN 0
            ELSE (t_term.sum_time_op * o.attr_371_)
        END
    ) + (
        (
            SELECT
                SUM(
                    CASE
                        WHEN j.term_op_st IS NULL THEN 0
                        ELSE j.term_op_st
                    END
                )
            FROM
                (
                    SELECT
                        comp.id
                      , nom_in_comp.id AS nom_in_comp_id
                      , tech_card.id   AS tech_card_id
                      , CASE
                            WHEN (term_op.sum_time * comp.attr_371_) IS NULL THEN 0
                            ELSE term_op.sum_time * comp.attr_371_
                        END AS term_op_st
                    FROM
                        registry.object_369_ comp
                        LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                        LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                        AND tech_card.is_deleted <> TRUE
                        AND tech_card.attr_2908_ = TRUE
                        LEFT JOIN (
                            SELECT
                                o.attr_538_
                              , SUM(o.attr_1443_) AS sum_time
                            FROM
                                registry.object_527_ o
                            WHERE
                                o.is_deleted <> TRUE
                                AND o.attr_586_ = 41
                            GROUP BY
                                o.attr_538_
                        ) term_op ON term_op.attr_538_ = tech_card.id
                    WHERE
                        comp.is_deleted <> TRUE
                        AND comp.attr_1455_ = o.id
                        AND nom_in_comp.attr_363_ NOT IN (2)
                ) j
        ) * o.attr_371_
    ) AS term_op
  , /*Покрытие*/ (
        CASE
            WHEN (t_pokr.sum_time_op * o.attr_371_) IS NULL THEN 0
            ELSE (t_pokr.sum_time_op * o.attr_371_)
        END
    ) + (
        (
            SELECT
                SUM(
                    CASE
                        WHEN j.pokr_op_st IS NULL THEN 0
                        ELSE j.pokr_op_st
                    END
                )
            FROM
                (
                    SELECT
                        comp.id
                      , nom_in_comp.id AS nom_in_comp_id
                      , tech_card.id   AS tech_card_id
                      , CASE
                            WHEN (pokr_op.sum_time * comp.attr_371_) IS NULL THEN 0
                            ELSE pokr_op.sum_time * comp.attr_371_
                        END AS pokr_op_st
                    FROM
                        registry.object_369_ comp
                        LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                        LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                        AND tech_card.is_deleted <> TRUE
                        AND tech_card.attr_2908_ = TRUE
                        LEFT JOIN (
                            SELECT
                                o.attr_538_
                              , SUM(o.attr_1443_) AS sum_time
                            FROM
                                registry.object_527_ o
                            WHERE
                                o.is_deleted <> TRUE
                                AND o.attr_586_ = 50
                            GROUP BY
                                o.attr_538_
                        ) pokr_op ON pokr_op.attr_538_ = tech_card.id
                    WHERE
                        comp.is_deleted <> TRUE
                        AND comp.attr_1455_ = o.id
                        AND nom_in_comp.attr_363_ NOT IN (2)
                ) j
        ) * o.attr_371_
    ) AS pokr_op
  , /*Слесарно-Сборочная*/ (
        CASE
            WHEN (t_sles_sbor.sum_time_op * o.attr_371_) IS NULL THEN 0
            ELSE (t_sles_sbor.sum_time_op * o.attr_371_)
        END
    ) + (
        (
            SELECT
                SUM(
                    CASE
                        WHEN j.sles_sbor_op_st IS NULL THEN 0
                        ELSE j.sles_sbor_op_st
                    END
                )
            FROM
                (
                    SELECT
                        comp.id
                      , nom_in_comp.id AS nom_in_comp_id
                      , tech_card.id   AS tech_card_id
                      , CASE
                            WHEN (sles_sbor_op.sum_time * comp.attr_371_) IS NULL THEN 0
                            ELSE sles_sbor_op.sum_time * comp.attr_371_
                        END AS sles_sbor_op_st
                    FROM
                        registry.object_369_ comp
                        LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                        LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                        AND tech_card.is_deleted <> TRUE
                        AND tech_card.attr_2908_ = TRUE
                        LEFT JOIN (
                            SELECT
                                o.attr_538_
                              , SUM(o.attr_1443_) AS sum_time
                            FROM
                                registry.object_527_ o
                            WHERE
                                o.is_deleted <> TRUE
                                AND o.attr_586_ = 55
                            GROUP BY
                                o.attr_538_
                        ) sles_sbor_op ON sles_sbor_op.attr_538_ = tech_card.id
                    WHERE
                        comp.is_deleted <> TRUE
                        AND comp.attr_1455_ = o.id
                        AND nom_in_comp.attr_363_ NOT IN (2)
                ) j
        ) * o.attr_371_
    ) AS sles_sbor_op
  , /*Токарная1*/ (
        CASE
            WHEN (t_tokr1.sum_time_op * o.attr_371_) IS NULL THEN 0
            ELSE (t_tokr1.sum_time_op * o.attr_371_)
        END
    ) + (
        (
            SELECT
                SUM(
                    CASE
                        WHEN j.tokr1_op_st IS NULL THEN 0
                        ELSE j.tokr1_op_st
                    END
                )
            FROM
                (
                    SELECT
                        comp.id
                      , nom_in_comp.id AS nom_in_comp_id
                      , tech_card.id   AS tech_card_id
                      , CASE
                            WHEN (tokr1_op.sum_time * comp.attr_371_) IS NULL THEN 0
                            ELSE tokr1_op.sum_time * comp.attr_371_
                        END AS tokr1_op_st
                    FROM
                        registry.object_369_ comp
                        LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                        LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                        AND tech_card.is_deleted <> TRUE
                        AND tech_card.attr_2908_ = TRUE
                        LEFT JOIN (
                            SELECT
                                o.attr_538_
                              , SUM(o.attr_1443_) AS sum_time
                            FROM
                                registry.object_527_ o
                            WHERE
                                o.is_deleted <> TRUE
                                AND o.attr_586_ = 46
                            GROUP BY
                                o.attr_538_
                        ) tokr1_op ON tokr1_op.attr_538_ = tech_card.id
                    WHERE
                        comp.is_deleted <> TRUE
                        AND comp.attr_1455_ = o.id
                        AND nom_in_comp.attr_363_ NOT IN (2)
                ) j
        ) * o.attr_371_
    ) AS tokr1_op
  , /*Токарная с ЧПУ*/ (
        CASE
            WHEN (t_tokr_s_chpy.sum_time_op * o.attr_371_) IS NULL THEN 0
            ELSE (t_tokr_s_chpy.sum_time_op * o.attr_371_)
        END
    ) + (
        (
            SELECT
                SUM(
                    CASE
                        WHEN j.tokr_chpy_op_st IS NULL THEN 0
                        ELSE j.tokr_chpy_op_st
                    END
                )
            FROM
                (
                    SELECT
                        comp.id
                      , nom_in_comp.id AS nom_in_comp_id
                      , tech_card.id   AS tech_card_id
                      , CASE
                            WHEN (tokr_chpy_op.sum_time * comp.attr_371_) IS NULL THEN 0
                            ELSE tokr_chpy_op.sum_time * comp.attr_371_
                        END AS tokr_chpy_op_st
                    FROM
                        registry.object_369_ comp
                        LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                        LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                        AND tech_card.is_deleted <> TRUE
                        AND tech_card.attr_2908_ = TRUE
                        LEFT JOIN (
                            SELECT
                                o.attr_538_
                              , SUM(o.attr_1443_) AS sum_time
                            FROM
                                registry.object_527_ o
                            WHERE
                                o.is_deleted <> TRUE
                                AND o.attr_586_ = 33
                            GROUP BY
                                o.attr_538_
                        ) tokr_chpy_op ON tokr_chpy_op.attr_538_ = tech_card.id
                    WHERE
                        comp.is_deleted <> TRUE
                        AND comp.attr_1455_ = o.id
                        AND nom_in_comp.attr_363_ NOT IN (2)
                ) j
        ) * o.attr_371_
    ) AS tokr_chpy_op
  , /*Фрезерная с ЧПУ*/ (
        CASE
            WHEN (t_frez_s_chpy.sum_time_op * o.attr_371_) IS NULL THEN 0
            ELSE (t_frez_s_chpy.sum_time_op * o.attr_371_)
        END
    ) + (
        (
            SELECT
                SUM(
                    CASE
                        WHEN j.frez_chpy_op_st IS NULL THEN 0
                        ELSE j.frez_chpy_op_st
                    END
                )
            FROM
                (
                    SELECT
                        comp.id
                      , nom_in_comp.id AS nom_in_comp_id
                      , tech_card.id   AS tech_card_id
                      , CASE
                            WHEN (frez_chpy_op.sum_time * comp.attr_371_) IS NULL THEN 0
                            ELSE frez_chpy_op.sum_time * comp.attr_371_
                        END AS frez_chpy_op_st
                    FROM
                        registry.object_369_ comp
                        LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                        LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                        AND tech_card.is_deleted <> TRUE
                        AND tech_card.attr_2908_ = TRUE
                        LEFT JOIN (
                            SELECT
                                o.attr_538_
                              , SUM(o.attr_1443_) AS sum_time
                            FROM
                                registry.object_527_ o
                            WHERE
                                o.is_deleted <> TRUE
                                AND o.attr_586_ = 60
                            GROUP BY
                                o.attr_538_
                        ) frez_chpy_op ON frez_chpy_op.attr_538_ = tech_card.id
                    WHERE
                        comp.is_deleted <> TRUE
                        AND comp.attr_1455_ = o.id
                        AND nom_in_comp.attr_363_ NOT IN (2)
                ) j
        ) * o.attr_371_
    ) AS frez_chpy_op
  , /*Расточная с ЧПУ*/ (
        CASE
            WHEN (t_rast_s_chpy.sum_time_op * o.attr_371_) IS NULL THEN 0
            ELSE (t_rast_s_chpy.sum_time_op * o.attr_371_)
        END
    ) + (
        (
            SELECT
                SUM(
                    CASE
                        WHEN j.rast_chpy_op_st IS NULL THEN 0
                        ELSE j.rast_chpy_op_st
                    END
                )
            FROM
                (
                    SELECT
                        comp.id
                      , nom_in_comp.id AS nom_in_comp_id
                      , tech_card.id   AS tech_card_id
                      , CASE
                            WHEN (rast_chpy_op.sum_time * comp.attr_371_) IS NULL THEN 0
                            ELSE rast_chpy_op.sum_time * comp.attr_371_
                        END AS rast_chpy_op_st
                    FROM
                        registry.object_369_ comp
                        LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                        LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                        AND tech_card.is_deleted <> TRUE
                        AND tech_card.attr_2908_ = TRUE
                        LEFT JOIN (
                            SELECT
                                o.attr_538_
                              , SUM(o.attr_1443_) AS sum_time
                            FROM
                                registry.object_527_ o
                            WHERE
                                o.is_deleted <> TRUE
                                AND o.attr_586_ = 59
                            GROUP BY
                                o.attr_538_
                        ) rast_chpy_op ON rast_chpy_op.attr_538_ = tech_card.id
                    WHERE
                        comp.is_deleted <> TRUE
                        AND comp.attr_1455_ = o.id
                        AND nom_in_comp.attr_363_ NOT IN (2)
                ) j
        ) * o.attr_371_
    ) AS rast_chpy_op
  , /*Прочие*/ (
        CASE
            WHEN (t_another.sum_time_op * o.attr_371_) IS NULL THEN 0
            ELSE (t_another.sum_time_op * o.attr_371_)
        END
    ) + (
        (
            SELECT
                SUM(
                    CASE
                        WHEN j.another_op_st IS NULL THEN 0
                        ELSE j.another_op_st
                    END
                )
            FROM
                (
                    SELECT
                        comp.id
                      , nom_in_comp.id AS nom_in_comp_id
                      , tech_card.id   AS tech_card_id
                      , CASE
                            WHEN (another_op.sum_time * comp.attr_371_) IS NULL THEN 0
                            ELSE another_op.sum_time * comp.attr_371_
                        END AS another_op_st
                    FROM
                        registry.object_369_ comp
                        LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                        LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                        AND tech_card.is_deleted <> TRUE
                        AND tech_card.attr_2908_ = TRUE
                        LEFT JOIN (
                            SELECT
                                o.attr_538_
                              , SUM(o.attr_1443_) AS sum_time
                            FROM
                                registry.object_527_ o
                            WHERE
                                o.is_deleted <> TRUE
                                AND o.attr_586_ NOT IN (
                                    39
                                  , 40
                                  , 42
                                  , 43
                                  , 47
                                  , 45
                                  , 51
                                  , 49
                                  , 44
                                  , 41
                                  , 50
                                  , 55
                                  , 53
                                  , 46
                                  , 33
                                  , 60
                                  , 59
                                )
                            GROUP BY
                                o.attr_538_
                        ) another_op ON another_op.attr_538_ = tech_card.id
                    WHERE
                        comp.is_deleted <> TRUE
                        AND comp.attr_1455_ = o.id
                        AND nom_in_comp.attr_363_ NOT IN (2)
                ) j
        ) * o.attr_371_
    ) AS another_op
  , /*ИТОГО*/ (
        (
            CASE
                WHEN (t_otrez.sum_time_op * o.attr_371_) IS NULL THEN 0
                ELSE (t_otrez.sum_time_op * o.attr_371_)
            END
        ) + (
            (
                SELECT
                    SUM(
                        CASE
                            WHEN j.otr_op_st IS NULL THEN 0
                            ELSE j.otr_op_st
                        END
                    )
                FROM
                    (
                        SELECT
                            comp.id
                          , nom_in_comp.id AS nom_in_comp_id
                          , tech_card.id   AS tech_card_id
                          , CASE
                                WHEN (otr_op.sum_time * comp.attr_371_) IS NULL THEN 0
                                ELSE otr_op.sum_time * comp.attr_371_
                            END AS otr_op_st
                        FROM
                            registry.object_369_ comp
                            LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                            LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                            AND tech_card.is_deleted <> TRUE
                            AND tech_card.attr_2908_ = TRUE
                            LEFT JOIN (
                                SELECT
                                    o.attr_538_
                                  , SUM(o.attr_1443_) AS sum_time
                                FROM
                                    registry.object_527_ o
                                WHERE
                                    o.is_deleted <> TRUE
                                    AND o.attr_586_ = 39
                                GROUP BY
                                    o.attr_538_
                            ) otr_op ON otr_op.attr_538_ = tech_card.id
                        WHERE
                            comp.is_deleted <> TRUE
                            AND comp.attr_1455_ = o.id
                            AND nom_in_comp.attr_363_ NOT IN (2)
                    ) j
            ) * o.attr_371_
        )
    ) + (
        (
            CASE
                WHEN (t_tokrn.sum_time_op * o.attr_371_) IS NULL THEN 0
                ELSE (t_tokrn.sum_time_op * o.attr_371_)
            END
        ) + (
            (
                SELECT
                    SUM(
                        CASE
                            WHEN j.tokr_op_st IS NULL THEN 0
                            ELSE j.tokr_op_st
                        END
                    )
                FROM
                    (
                        SELECT
                            comp.id
                          , nom_in_comp.id AS nom_in_comp_id
                          , tech_card.id   AS tech_card_id
                          , CASE
                                WHEN (tokr_op.sum_time * comp.attr_371_) IS NULL THEN 0
                                ELSE tokr_op.sum_time * comp.attr_371_
                            END AS tokr_op_st
                        FROM
                            registry.object_369_ comp
                            LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                            LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                            AND tech_card.is_deleted <> TRUE
                            AND tech_card.attr_2908_ = TRUE
                            LEFT JOIN (
                                SELECT
                                    o.attr_538_
                                  , SUM(o.attr_1443_) AS sum_time
                                FROM
                                    registry.object_527_ o
                                WHERE
                                    o.is_deleted <> TRUE
                                    AND o.attr_586_ = 40
                                GROUP BY
                                    o.attr_538_
                            ) tokr_op ON tokr_op.attr_538_ = tech_card.id
                        WHERE
                            comp.is_deleted <> TRUE
                            AND comp.attr_1455_ = o.id
                            AND nom_in_comp.attr_363_ NOT IN (2)
                    ) j
            ) * o.attr_371_
        )
    ) + (
        (
            CASE
                WHEN (t_frez.sum_time_op * o.attr_371_) IS NULL THEN 0
                ELSE (t_frez.sum_time_op * o.attr_371_)
            END
        ) + (
            (
                SELECT
                    SUM(
                        CASE
                            WHEN j.frez_op_st IS NULL THEN 0
                            ELSE j.frez_op_st
                        END
                    )
                FROM
                    (
                        SELECT
                            comp.id
                          , nom_in_comp.id AS nom_in_comp_id
                          , tech_card.id   AS tech_card_id
                          , CASE
                                WHEN (frez_op.sum_time * comp.attr_371_) IS NULL THEN 0
                                ELSE frez_op.sum_time * comp.attr_371_
                            END AS frez_op_st
                        FROM
                            registry.object_369_ comp
                            LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                            LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                            AND tech_card.is_deleted <> TRUE
                            AND tech_card.attr_2908_ = TRUE
                            LEFT JOIN (
                                SELECT
                                    o.attr_538_
                                  , SUM(o.attr_1443_) AS sum_time
                                FROM
                                    registry.object_527_ o
                                WHERE
                                    o.is_deleted <> TRUE
                                    AND o.attr_586_ = 42
                                GROUP BY
                                    o.attr_538_
                            ) frez_op ON frez_op.attr_538_ = tech_card.id
                        WHERE
                            comp.is_deleted <> TRUE
                            AND comp.attr_1455_ = o.id
                            AND nom_in_comp.attr_363_ NOT IN (2)
                    ) j
            ) * o.attr_371_
        )
    ) + (
        (
            CASE
                WHEN (t_rast.sum_time_op * o.attr_371_) IS NULL THEN 0
                ELSE (t_rast.sum_time_op * o.attr_371_)
            END
        ) + (
            (
                SELECT
                    SUM(
                        CASE
                            WHEN j.rast_op_st IS NULL THEN 0
                            ELSE j.rast_op_st
                        END
                    )
                FROM
                    (
                        SELECT
                            comp.id
                          , nom_in_comp.id AS nom_in_comp_id
                          , tech_card.id   AS tech_card_id
                          , CASE
                                WHEN (rast_op.sum_time * comp.attr_371_) IS NULL THEN 0
                                ELSE rast_op.sum_time * comp.attr_371_
                            END AS rast_op_st
                        FROM
                            registry.object_369_ comp
                            LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                            LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                            AND tech_card.is_deleted <> TRUE
                            AND tech_card.attr_2908_ = TRUE
                            LEFT JOIN (
                                SELECT
                                    o.attr_538_
                                  , SUM(o.attr_1443_) AS sum_time
                                FROM
                                    registry.object_527_ o
                                WHERE
                                    o.is_deleted <> TRUE
                                    AND o.attr_586_ = 43
                                GROUP BY
                                    o.attr_538_
                            ) rast_op ON rast_op.attr_538_ = tech_card.id
                        WHERE
                            comp.is_deleted <> TRUE
                            AND comp.attr_1455_ = o.id
                            AND nom_in_comp.attr_363_ NOT IN (2)
                    ) j
            ) * o.attr_371_
        )
    ) + (
        (
            CASE
                WHEN (t_sverl.sum_time_op * o.attr_371_) IS NULL THEN 0
                ELSE (t_sverl.sum_time_op * o.attr_371_)
            END
        ) + (
            (
                SELECT
                    SUM(
                        CASE
                            WHEN j.sverl_op_st IS NULL THEN 0
                            ELSE j.sverl_op_st
                        END
                    )
                FROM
                    (
                        SELECT
                            comp.id
                          , nom_in_comp.id AS nom_in_comp_id
                          , tech_card.id   AS tech_card_id
                          , CASE
                                WHEN (sverl_op.sum_time * comp.attr_371_) IS NULL THEN 0
                                ELSE sverl_op.sum_time * comp.attr_371_
                            END AS sverl_op_st
                        FROM
                            registry.object_369_ comp
                            LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                            LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                            AND tech_card.is_deleted <> TRUE
                            AND tech_card.attr_2908_ = TRUE
                            LEFT JOIN (
                                SELECT
                                    o.attr_538_
                                  , SUM(o.attr_1443_) AS sum_time
                                FROM
                                    registry.object_527_ o
                                WHERE
                                    o.is_deleted <> TRUE
                                    AND o.attr_586_ = 47
                                GROUP BY
                                    o.attr_538_
                            ) sverl_op ON sverl_op.attr_538_ = tech_card.id
                        WHERE
                            comp.is_deleted <> TRUE
                            AND comp.attr_1455_ = o.id
                            AND nom_in_comp.attr_363_ NOT IN (2)
                    ) j
            ) * o.attr_371_
        )
    ) + (
        (
            CASE
                WHEN (t_dolb.sum_time_op * o.attr_371_) IS NULL THEN 0
                ELSE (t_dolb.sum_time_op * o.attr_371_)
            END
        ) + (
            (
                SELECT
                    SUM(
                        CASE
                            WHEN j.dolb_op_st IS NULL THEN 0
                            ELSE j.dolb_op_st
                        END
                    )
                FROM
                    (
                        SELECT
                            comp.id
                          , nom_in_comp.id AS nom_in_comp_id
                          , tech_card.id   AS tech_card_id
                          , CASE
                                WHEN (dolb_op.sum_time * comp.attr_371_) IS NULL THEN 0
                                ELSE dolb_op.sum_time * comp.attr_371_
                            END AS dolb_op_st
                        FROM
                            registry.object_369_ comp
                            LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                            LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                            AND tech_card.is_deleted <> TRUE
                            AND tech_card.attr_2908_ = TRUE
                            LEFT JOIN (
                                SELECT
                                    o.attr_538_
                                  , SUM(o.attr_1443_) AS sum_time
                                FROM
                                    registry.object_527_ o
                                WHERE
                                    o.is_deleted <> TRUE
                                    AND o.attr_586_ = 45
                                GROUP BY
                                    o.attr_538_
                            ) dolb_op ON dolb_op.attr_538_ = tech_card.id
                        WHERE
                            comp.is_deleted <> TRUE
                            AND comp.attr_1455_ = o.id
                            AND nom_in_comp.attr_363_ NOT IN (2)
                    ) j
            ) * o.attr_371_
        )
    ) + (
        (
            CASE
                WHEN (t_shlif.sum_time_op * o.attr_371_) IS NULL THEN 0
                ELSE (t_shlif.sum_time_op * o.attr_371_)
            END
        ) + (
            (
                SELECT
                    SUM(
                        CASE
                            WHEN j.shlif_op_st IS NULL THEN 0
                            ELSE j.shlif_op_st
                        END
                    )
                FROM
                    (
                        SELECT
                            comp.id
                          , nom_in_comp.id AS nom_in_comp_id
                          , tech_card.id   AS tech_card_id
                          , CASE
                                WHEN (shlif_op.sum_time * comp.attr_371_) IS NULL THEN 0
                                ELSE shlif_op.sum_time * comp.attr_371_
                            END AS shlif_op_st
                        FROM
                            registry.object_369_ comp
                            LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                            LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                            AND tech_card.is_deleted <> TRUE
                            AND tech_card.attr_2908_ = TRUE
                            LEFT JOIN (
                                SELECT
                                    o.attr_538_
                                  , SUM(o.attr_1443_) AS sum_time
                                FROM
                                    registry.object_527_ o
                                WHERE
                                    o.is_deleted <> TRUE
                                    AND o.attr_586_ = 51
                                GROUP BY
                                    o.attr_538_
                            ) shlif_op ON shlif_op.attr_538_ = tech_card.id
                        WHERE
                            comp.is_deleted <> TRUE
                            AND comp.attr_1455_ = o.id
                            AND nom_in_comp.attr_363_ NOT IN (2)
                    ) j
            ) * o.attr_371_
        )
    ) + (
        (
            CASE
                WHEN (t_svar.sum_time_op * o.attr_371_) IS NULL THEN 0
                ELSE (t_svar.sum_time_op * o.attr_371_)
            END
        ) + (
            (
                SELECT
                    SUM(
                        CASE
                            WHEN j.svar_op_st IS NULL THEN 0
                            ELSE j.svar_op_st
                        END
                    )
                FROM
                    (
                        SELECT
                            comp.id
                          , nom_in_comp.id AS nom_in_comp_id
                          , tech_card.id   AS tech_card_id
                          , CASE
                                WHEN (svar_op.sum_time * comp.attr_371_) IS NULL THEN 0
                                ELSE svar_op.sum_time * comp.attr_371_
                            END AS svar_op_st
                        FROM
                            registry.object_369_ comp
                            LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                            LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                            AND tech_card.is_deleted <> TRUE
                            AND tech_card.attr_2908_ = TRUE
                            LEFT JOIN (
                                SELECT
                                    o.attr_538_
                                  , SUM(o.attr_1443_) AS sum_time
                                FROM
                                    registry.object_527_ o
                                WHERE
                                    o.is_deleted <> TRUE
                                    AND o.attr_586_ = 49
                                GROUP BY
                                    o.attr_538_
                            ) svar_op ON svar_op.attr_538_ = tech_card.id
                        WHERE
                            comp.is_deleted <> TRUE
                            AND comp.attr_1455_ = o.id
                            AND nom_in_comp.attr_363_ NOT IN (2)
                    ) j
            ) * o.attr_371_
        )
    ) + (
        (
            CASE
                WHEN (t_sles.sum_time_op * o.attr_371_) IS NULL THEN 0
                ELSE (t_sles.sum_time_op * o.attr_371_)
            END
        ) + (
            (
                SELECT
                    SUM(
                        CASE
                            WHEN j.sles_op_st IS NULL THEN 0
                            ELSE j.sles_op_st
                        END
                    )
                FROM
                    (
                        SELECT
                            comp.id
                          , nom_in_comp.id AS nom_in_comp_id
                          , tech_card.id   AS tech_card_id
                          , CASE
                                WHEN (sles_op.sum_time * comp.attr_371_) IS NULL THEN 0
                                ELSE sles_op.sum_time * comp.attr_371_
                            END AS sles_op_st
                        FROM
                            registry.object_369_ comp
                            LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                            LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                            AND tech_card.is_deleted <> TRUE
                            AND tech_card.attr_2908_ = TRUE
                            LEFT JOIN (
                                SELECT
                                    o.attr_538_
                                  , SUM(o.attr_1443_) AS sum_time
                                FROM
                                    registry.object_527_ o
                                WHERE
                                    o.is_deleted <> TRUE
                                    AND o.attr_586_ = 44
                                GROUP BY
                                    o.attr_538_
                            ) sles_op ON sles_op.attr_538_ = tech_card.id
                        WHERE
                            comp.is_deleted <> TRUE
                            AND comp.attr_1455_ = o.id
                            AND nom_in_comp.attr_363_ NOT IN (2)
                    ) j
            ) * o.attr_371_
        )
    ) + (
        (
            CASE
                WHEN (t_term.sum_time_op * o.attr_371_) IS NULL THEN 0
                ELSE (t_term.sum_time_op * o.attr_371_)
            END
        ) + (
            (
                SELECT
                    SUM(
                        CASE
                            WHEN j.term_op_st IS NULL THEN 0
                            ELSE j.term_op_st
                        END
                    )
                FROM
                    (
                        SELECT
                            comp.id
                          , nom_in_comp.id AS nom_in_comp_id
                          , tech_card.id   AS tech_card_id
                          , CASE
                                WHEN (term_op.sum_time * comp.attr_371_) IS NULL THEN 0
                                ELSE term_op.sum_time * comp.attr_371_
                            END AS term_op_st
                        FROM
                            registry.object_369_ comp
                            LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                            LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                            AND tech_card.is_deleted <> TRUE
                            AND tech_card.attr_2908_ = TRUE
                            LEFT JOIN (
                                SELECT
                                    o.attr_538_
                                  , SUM(o.attr_1443_) AS sum_time
                                FROM
                                    registry.object_527_ o
                                WHERE
                                    o.is_deleted <> TRUE
                                    AND o.attr_586_ = 41
                                GROUP BY
                                    o.attr_538_
                            ) term_op ON term_op.attr_538_ = tech_card.id
                        WHERE
                            comp.is_deleted <> TRUE
                            AND comp.attr_1455_ = o.id
                            AND nom_in_comp.attr_363_ NOT IN (2)
                    ) j
            ) * o.attr_371_
        )
    ) + (
        (
            CASE
                WHEN (t_pokr.sum_time_op * o.attr_371_) IS NULL THEN 0
                ELSE (t_pokr.sum_time_op * o.attr_371_)
            END
        ) + (
            (
                SELECT
                    SUM(
                        CASE
                            WHEN j.pokr_op_st IS NULL THEN 0
                            ELSE j.pokr_op_st
                        END
                    )
                FROM
                    (
                        SELECT
                            comp.id
                          , nom_in_comp.id AS nom_in_comp_id
                          , tech_card.id   AS tech_card_id
                          , CASE
                                WHEN (pokr_op.sum_time * comp.attr_371_) IS NULL THEN 0
                                ELSE pokr_op.sum_time * comp.attr_371_
                            END AS pokr_op_st
                        FROM
                            registry.object_369_ comp
                            LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                            LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                            AND tech_card.is_deleted <> TRUE
                            AND tech_card.attr_2908_ = TRUE
                            LEFT JOIN (
                                SELECT
                                    o.attr_538_
                                  , SUM(o.attr_1443_) AS sum_time
                                FROM
                                    registry.object_527_ o
                                WHERE
                                    o.is_deleted <> TRUE
                                    AND o.attr_586_ = 50
                                GROUP BY
                                    o.attr_538_
                            ) pokr_op ON pokr_op.attr_538_ = tech_card.id
                        WHERE
                            comp.is_deleted <> TRUE
                            AND comp.attr_1455_ = o.id
                            AND nom_in_comp.attr_363_ NOT IN (2)
                    ) j
            ) * o.attr_371_
        )
    ) + (
        (
            CASE
                WHEN (t_sles_sbor.sum_time_op * o.attr_371_) IS NULL THEN 0
                ELSE (t_sles_sbor.sum_time_op * o.attr_371_)
            END
        ) + (
            (
                SELECT
                    SUM(
                        CASE
                            WHEN j.sles_sbor_op_st IS NULL THEN 0
                            ELSE j.sles_sbor_op_st
                        END
                    )
                FROM
                    (
                        SELECT
                            comp.id
                          , nom_in_comp.id AS nom_in_comp_id
                          , tech_card.id   AS tech_card_id
                          , CASE
                                WHEN (sles_sbor_op.sum_time * comp.attr_371_) IS NULL THEN 0
                                ELSE sles_sbor_op.sum_time * comp.attr_371_
                            END AS sles_sbor_op_st
                        FROM
                            registry.object_369_ comp
                            LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                            LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                            AND tech_card.is_deleted <> TRUE
                            AND tech_card.attr_2908_ = TRUE
                            LEFT JOIN (
                                SELECT
                                    o.attr_538_
                                  , SUM(o.attr_1443_) AS sum_time
                                FROM
                                    registry.object_527_ o
                                WHERE
                                    o.is_deleted <> TRUE
                                    AND o.attr_586_ = 55
                                GROUP BY
                                    o.attr_538_
                            ) sles_sbor_op ON sles_sbor_op.attr_538_ = tech_card.id
                        WHERE
                            comp.is_deleted <> TRUE
                            AND comp.attr_1455_ = o.id
                            AND nom_in_comp.attr_363_ NOT IN (2)
                    ) j
            ) * o.attr_371_
        )
    ) + (
        (
            CASE
                WHEN (t_tokr1.sum_time_op * o.attr_371_) IS NULL THEN 0
                ELSE (t_tokr1.sum_time_op * o.attr_371_)
            END
        ) + (
            (
                SELECT
                    SUM(
                        CASE
                            WHEN j.tokr1_op_st IS NULL THEN 0
                            ELSE j.tokr1_op_st
                        END
                    )
                FROM
                    (
                        SELECT
                            comp.id
                          , nom_in_comp.id AS nom_in_comp_id
                          , tech_card.id   AS tech_card_id
                          , CASE
                                WHEN (tokr1_op.sum_time * comp.attr_371_) IS NULL THEN 0
                                ELSE tokr1_op.sum_time * comp.attr_371_
                            END AS tokr1_op_st
                        FROM
                            registry.object_369_ comp
                            LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                            LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                            AND tech_card.is_deleted <> TRUE
                            AND tech_card.attr_2908_ = TRUE
                            LEFT JOIN (
                                SELECT
                                    o.attr_538_
                                  , SUM(o.attr_1443_) AS sum_time
                                FROM
                                    registry.object_527_ o
                                WHERE
                                    o.is_deleted <> TRUE
                                    AND o.attr_586_ = 46
                                GROUP BY
                                    o.attr_538_
                            ) tokr1_op ON tokr1_op.attr_538_ = tech_card.id
                        WHERE
                            comp.is_deleted <> TRUE
                            AND comp.attr_1455_ = o.id
                            AND nom_in_comp.attr_363_ NOT IN (2)
                    ) j
            ) * o.attr_371_
        )
    ) + (
        (
            CASE
                WHEN (t_tokr_s_chpy.sum_time_op * o.attr_371_) IS NULL THEN 0
                ELSE (t_tokr_s_chpy.sum_time_op * o.attr_371_)
            END
        ) + (
            (
                SELECT
                    SUM(
                        CASE
                            WHEN j.tokr_chpy_op_st IS NULL THEN 0
                            ELSE j.tokr_chpy_op_st
                        END
                    )
                FROM
                    (
                        SELECT
                            comp.id
                          , nom_in_comp.id AS nom_in_comp_id
                          , tech_card.id   AS tech_card_id
                          , CASE
                                WHEN (tokr_chpy_op.sum_time * comp.attr_371_) IS NULL THEN 0
                                ELSE tokr_chpy_op.sum_time * comp.attr_371_
                            END AS tokr_chpy_op_st
                        FROM
                            registry.object_369_ comp
                            LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                            LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                            AND tech_card.is_deleted <> TRUE
                            AND tech_card.attr_2908_ = TRUE
                            LEFT JOIN (
                                SELECT
                                    o.attr_538_
                                  , SUM(o.attr_1443_) AS sum_time
                                FROM
                                    registry.object_527_ o
                                WHERE
                                    o.is_deleted <> TRUE
                                    AND o.attr_586_ = 33
                                GROUP BY
                                    o.attr_538_
                            ) tokr_chpy_op ON tokr_chpy_op.attr_538_ = tech_card.id
                        WHERE
                            comp.is_deleted <> TRUE
                            AND comp.attr_1455_ = o.id
                            AND nom_in_comp.attr_363_ NOT IN (2)
                    ) j
            ) * o.attr_371_
        )
    ) + (
        (
            CASE
                WHEN (t_frez_s_chpy.sum_time_op * o.attr_371_) IS NULL THEN 0
                ELSE (t_frez_s_chpy.sum_time_op * o.attr_371_)
            END
        ) + (
            (
                SELECT
                    SUM(
                        CASE
                            WHEN j.frez_chpy_op_st IS NULL THEN 0
                            ELSE j.frez_chpy_op_st
                        END
                    )
                FROM
                    (
                        SELECT
                            comp.id
                          , nom_in_comp.id AS nom_in_comp_id
                          , tech_card.id   AS tech_card_id
                          , CASE
                                WHEN (frez_chpy_op.sum_time * comp.attr_371_) IS NULL THEN 0
                                ELSE frez_chpy_op.sum_time * comp.attr_371_
                            END AS frez_chpy_op_st
                        FROM
                            registry.object_369_ comp
                            LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                            LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                            AND tech_card.is_deleted <> TRUE
                            AND tech_card.attr_2908_ = TRUE
                            LEFT JOIN (
                                SELECT
                                    o.attr_538_
                                  , SUM(o.attr_1443_) AS sum_time
                                FROM
                                    registry.object_527_ o
                                WHERE
                                    o.is_deleted <> TRUE
                                    AND o.attr_586_ = 60
                                GROUP BY
                                    o.attr_538_
                            ) frez_chpy_op ON frez_chpy_op.attr_538_ = tech_card.id
                        WHERE
                            comp.is_deleted <> TRUE
                            AND comp.attr_1455_ = o.id
                            AND nom_in_comp.attr_363_ NOT IN (2)
                    ) j
            ) * o.attr_371_
        )
    ) + (
        (
            CASE
                WHEN (t_rast_s_chpy.sum_time_op * o.attr_371_) IS NULL THEN 0
                ELSE (t_rast_s_chpy.sum_time_op * o.attr_371_)
            END
        ) + (
            (
                SELECT
                    SUM(
                        CASE
                            WHEN j.rast_chpy_op_st IS NULL THEN 0
                            ELSE j.rast_chpy_op_st
                        END
                    )
                FROM
                    (
                        SELECT
                            comp.id
                          , nom_in_comp.id AS nom_in_comp_id
                          , tech_card.id   AS tech_card_id
                          , CASE
                                WHEN (rast_chpy_op.sum_time * comp.attr_371_) IS NULL THEN 0
                                ELSE rast_chpy_op.sum_time * comp.attr_371_
                            END AS rast_chpy_op_st
                        FROM
                            registry.object_369_ comp
                            LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                            LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                            AND tech_card.is_deleted <> TRUE
                            AND tech_card.attr_2908_ = TRUE
                            LEFT JOIN (
                                SELECT
                                    o.attr_538_
                                  , SUM(o.attr_1443_) AS sum_time
                                FROM
                                    registry.object_527_ o
                                WHERE
                                    o.is_deleted <> TRUE
                                    AND o.attr_586_ = 59
                                GROUP BY
                                    o.attr_538_
                            ) rast_chpy_op ON rast_chpy_op.attr_538_ = tech_card.id
                        WHERE
                            comp.is_deleted <> TRUE
                            AND comp.attr_1455_ = o.id
                            AND nom_in_comp.attr_363_ NOT IN (2)
                    ) j
            ) * o.attr_371_
        )
    ) + (
        (
            CASE
                WHEN (t_another.sum_time_op * o.attr_371_) IS NULL THEN 0
                ELSE (t_another.sum_time_op * o.attr_371_)
            END
        ) + (
            (
                SELECT
                    SUM(
                        CASE
                            WHEN j.another_op_st IS NULL THEN 0
                            ELSE j.another_op_st
                        END
                    )
                FROM
                    (
                        SELECT
                            comp.id
                          , nom_in_comp.id AS nom_in_comp_id
                          , tech_card.id   AS tech_card_id
                          , CASE
                                WHEN (another_op.sum_time * comp.attr_371_) IS NULL THEN 0
                                ELSE another_op.sum_time * comp.attr_371_
                            END AS another_op_st
                        FROM
                            registry.object_369_ comp
                            LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_370_ = nom_in_comp.id
                            LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.id
                            AND tech_card.is_deleted <> TRUE
                            AND tech_card.attr_2908_ = TRUE
                            LEFT JOIN (
                                SELECT
                                    o.attr_538_
                                  , SUM(o.attr_1443_) AS sum_time
                                FROM
                                    registry.object_527_ o
                                WHERE
                                    o.is_deleted <> TRUE
                                    AND o.attr_586_ NOT IN (
                                        39
                                      , 40
                                      , 42
                                      , 43
                                      , 47
                                      , 45
                                      , 51
                                      , 49
                                      , 44
                                      , 41
                                      , 50
                                      , 55
                                      , 53
                                      , 46
                                      , 33
                                      , 60
                                      , 59
                                    )
                                GROUP BY
                                    o.attr_538_
                            ) another_op ON another_op.attr_538_ = tech_card.id
                        WHERE
                            comp.is_deleted <> TRUE
                            AND comp.attr_1455_ = o.id
                            AND nom_in_comp.attr_363_ NOT IN (2)
                    ) j
            ) * o.attr_371_
        )
    ) AS sum_time
  , CASE
        WHEN nomen.attr_363_ = 9 THEN 2
        WHEN nomen.attr_363_ = 6
        AND nomen.attr_1094_ = 216 THEN 34
        ELSE nomen.attr_363_
    END AS id_type_ne
  , CASE
        WHEN nomen.attr_363_ = 9 THEN 'Сборочная единица'
        WHEN nomen.attr_363_ = 6
        AND nomen.attr_1094_ = 216 THEN 'Стандартные РТИ'
        ELSE type_ne.attr_365_
    END AS type_ne_name
FROM
    registry.object_369_ o
    LEFT JOIN registry.object_301_ nomen ON o.attr_370_ = nomen.id
    AND nomen.is_deleted <> TRUE
    LEFT JOIN registry.object_424_ gost ON nomen.attr_1492_ = gost.id
    AND gost.is_deleted <> TRUE
    LEFT JOIN registry.object_400_ mat ON nomen.attr_526_ = mat.id
    AND mat.is_deleted <> TRUE
    LEFT JOIN registry.object_364_ type_ne ON nomen.attr_363_ = type_ne.id
    AND type_ne.is_deleted <> TRUE
    LEFT JOIN registry.object_519_ marsh_card ON marsh_card.attr_520_ = nomen.id
    AND marsh_card.is_deleted <> TRUE
    AND marsh_card.attr_2908_ = TRUE
    LEFT JOIN (
        SELECT
            o.attr_538_       AS marsh_card_id
          , SUM(o.attr_1443_) AS sum_time_op
        FROM
            registry.object_527_ o
        WHERE
            o.is_deleted <> TRUE
            AND o.attr_586_ = 39
        GROUP BY
            o.attr_538_
    ) t_otrez ON t_otrez.marsh_card_id = marsh_card.id
    LEFT JOIN (
        SELECT
            o.attr_538_       AS marsh_card_id
          , SUM(o.attr_1443_) AS sum_time_op
        FROM
            registry.object_527_ o
        WHERE
            o.is_deleted <> TRUE
            AND o.attr_586_ = 40
        GROUP BY
            o.attr_538_
    ) t_tokrn ON t_tokrn.marsh_card_id = marsh_card.id
    LEFT JOIN (
        SELECT
            o.attr_538_       AS marsh_card_id
          , SUM(o.attr_1443_) AS sum_time_op
        FROM
            registry.object_527_ o
        WHERE
            o.is_deleted <> TRUE
            AND o.attr_586_ = 42
        GROUP BY
            o.attr_538_
    ) t_frez ON t_frez.marsh_card_id = marsh_card.id
    LEFT JOIN (
        SELECT
            o.attr_538_       AS marsh_card_id
          , SUM(o.attr_1443_) AS sum_time_op
        FROM
            registry.object_527_ o
        WHERE
            o.is_deleted <> TRUE
            AND o.attr_586_ = 43
        GROUP BY
            o.attr_538_
    ) t_rast ON t_rast.marsh_card_id = marsh_card.id
    LEFT JOIN (
        SELECT
            o.attr_538_       AS marsh_card_id
          , SUM(o.attr_1443_) AS sum_time_op
        FROM
            registry.object_527_ o
        WHERE
            o.is_deleted <> TRUE
            AND o.attr_586_ = 47
        GROUP BY
            o.attr_538_
    ) t_sverl ON t_sverl.marsh_card_id = marsh_card.id
    LEFT JOIN (
        SELECT
            o.attr_538_       AS marsh_card_id
          , SUM(o.attr_1443_) AS sum_time_op
        FROM
            registry.object_527_ o
        WHERE
            o.is_deleted <> TRUE
            AND o.attr_586_ = 45
        GROUP BY
            o.attr_538_
    ) t_dolb ON t_dolb.marsh_card_id = marsh_card.id
    LEFT JOIN (
        SELECT
            o.attr_538_       AS marsh_card_id
          , SUM(o.attr_1443_) AS sum_time_op
        FROM
            registry.object_527_ o
        WHERE
            o.is_deleted <> TRUE
            AND o.attr_586_ = 51
        GROUP BY
            o.attr_538_
    ) t_shlif ON t_shlif.marsh_card_id = marsh_card.id
    LEFT JOIN (
        SELECT
            o.attr_538_       AS marsh_card_id
          , SUM(o.attr_1443_) AS sum_time_op
        FROM
            registry.object_527_ o
        WHERE
            o.is_deleted <> TRUE
            AND o.attr_586_ = 49
        GROUP BY
            o.attr_538_
    ) t_svar ON t_svar.marsh_card_id = marsh_card.id
    LEFT JOIN (
        SELECT
            o.attr_538_       AS marsh_card_id
          , SUM(o.attr_1443_) AS sum_time_op
        FROM
            registry.object_527_ o
        WHERE
            o.is_deleted <> TRUE
            AND o.attr_586_ = 44
        GROUP BY
            o.attr_538_
    ) t_sles ON t_sles.marsh_card_id = marsh_card.id
    LEFT JOIN (
        SELECT
            o.attr_538_       AS marsh_card_id
          , SUM(o.attr_1443_) AS sum_time_op
        FROM
            registry.object_527_ o
        WHERE
            o.is_deleted <> TRUE
            AND o.attr_586_ = 41
        GROUP BY
            o.attr_538_
    ) t_term ON t_term.marsh_card_id = marsh_card.id
    LEFT JOIN (
        SELECT
            o.attr_538_       AS marsh_card_id
          , SUM(o.attr_1443_) AS sum_time_op
        FROM
            registry.object_527_ o
        WHERE
            o.is_deleted <> TRUE
            AND o.attr_586_ = 50
        GROUP BY
            o.attr_538_
    ) t_pokr ON t_pokr.marsh_card_id = marsh_card.id
    LEFT JOIN (
        SELECT
            o.attr_538_       AS marsh_card_id
          , SUM(o.attr_1443_) AS sum_time_op
        FROM
            registry.object_527_ o
        WHERE
            o.is_deleted <> TRUE
            AND o.attr_586_ = 55
        GROUP BY
            o.attr_538_
    ) t_sles_sbor ON t_sles_sbor.marsh_card_id = marsh_card.id
    LEFT JOIN (
        SELECT
            o.attr_538_     AS marsh_card_id
          , array_to_string (
                array_agg (
                    concat ('Шаг №', o.attr_613_, ' - ', o.attr_2863_)
                )
              , '\n'
            ) AS content_op
        FROM
            registry.object_527_ o
        WHERE
            o.is_deleted <> TRUE
            AND o.attr_586_ = 53
        GROUP BY
            o.attr_538_
    ) t_marsh ON t_marsh.marsh_card_id = marsh_card.id
    LEFT JOIN (
        SELECT
            o.attr_538_       AS marsh_card_id
          , SUM(o.attr_1443_) AS sum_time_op
        FROM
            registry.object_527_ o
        WHERE
            o.is_deleted <> TRUE
            AND o.attr_586_ = 46
        GROUP BY
            o.attr_538_
    ) t_tokr1 ON t_tokr1.marsh_card_id = marsh_card.id
    LEFT JOIN (
        SELECT
            o.attr_538_       AS marsh_card_id
          , SUM(o.attr_1443_) AS sum_time_op
        FROM
            registry.object_527_ o
        WHERE
            o.is_deleted <> TRUE
            AND o.attr_586_ = 33
        GROUP BY
            o.attr_538_
    ) t_tokr_s_chpy ON t_tokr_s_chpy.marsh_card_id = marsh_card.id
    LEFT JOIN (
        SELECT
            o.attr_538_       AS marsh_card_id
          , SUM(o.attr_1443_) AS sum_time_op
        FROM
            registry.object_527_ o
        WHERE
            o.is_deleted <> TRUE
            AND o.attr_586_ = 60
        GROUP BY
            o.attr_538_
    ) t_frez_s_chpy ON t_frez_s_chpy.marsh_card_id = marsh_card.id
    LEFT JOIN (
        SELECT
            o.attr_538_       AS marsh_card_id
          , SUM(o.attr_1443_) AS sum_time_op
        FROM
            registry.object_527_ o
        WHERE
            o.is_deleted <> TRUE
            AND o.attr_586_ = 59
        GROUP BY
            o.attr_538_
    ) t_rast_s_chpy ON t_rast_s_chpy.marsh_card_id = marsh_card.id
    LEFT JOIN (
        SELECT
            o.attr_538_       AS marsh_card_id
          , SUM(o.attr_1443_) AS sum_time_op
        FROM
            registry.object_527_ o
        WHERE
            o.is_deleted <> TRUE
            AND o.attr_586_ NOT IN (
                39
              , 40
              , 42
              , 43
              , 47
              , 45
              , 51
              , 49
              , 44
              , 41
              , 50
              , 55
              , 53
              , 46
              , 33
              , 60
              , 59
            )
        GROUP BY
            o.attr_538_
    ) t_another ON t_another.marsh_card_id = marsh_card.id
WHERE
    o.is_deleted <> TRUE /*and o.attr_374_ = '{superid}'*/
    AND nomen.attr_363_ IN (2, 9)
    AND o.attr_1455_ = (
        SELECT
            o1.id
        FROM
            registry.object_369_ o1
        WHERE
            o1.is_deleted <> TRUE
            AND o1.attr_1455_ IS NULL
            AND o1.attr_374_ = '{superid}'
    )