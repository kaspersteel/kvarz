WITH
    data_comp AS (
        SELECT
            comp.id
          , comp.attr_1896_ AS quant
          , tech_card.id AS tech_card_id
          , comp.attr_1548_ AS date_cut
          , comp.attr_1551_ AS date_tok1
          , comp.attr_1554_ AS date_tok
          , comp.attr_1557_ AS date_rast_frez
          , comp.attr_1560_ AS date_shlif_pritir
          , comp.attr_1563_ AS date_sles_sbor
        FROM
            registry.object_1409_ comp
            LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_1458_ = nom_in_comp.ID
            AND nom_in_comp.is_deleted IS FALSE
            /*выбираем карту из компонента, если его изменили или создали не из ном. ед.*/
            LEFT JOIN registry.object_519_ tech_card ON (
                CASE
                    WHEN comp.attr_1463_ = 2
                    OR comp.attr_1421_ IN (6, 4) THEN tech_card.attr_1466_
                    ELSE tech_card.attr_520_
                END = CASE
                    WHEN comp.attr_1463_ = 2
                    OR comp.attr_1421_ IN (6, 4) THEN comp.ID
                    ELSE nom_in_comp.ID
                END
            )
            AND tech_card.is_deleted IS FALSE
            /*активная карта*/
            AND tech_card.attr_2908_ IS TRUE
        WHERE
            comp.is_deleted IS FALSE
            AND (
                comp.attr_1421_ IS NULL
                OR comp.attr_1421_ != 1
            )
            AND comp.attr_1650_ IS NOT NULL /*входит в заказ в производство*/
            AND comp.attr_2042_ = 2 /*компонент собственного производства*/
    )
  , weeks AS (
        SELECT
            EXTRACT(
                'week'
                FROM
                    gs
            ) num
          , DATE_TRUNC('week', gs::TIMESTAMP)::date date_begin
          , (
                DATE_TRUNC('week', gs::TIMESTAMP) + '6 days'::INTERVAL
            )::date date_end
          , CONCAT(
                TO_CHAR(
                    DATE_TRUNC('week', gs::TIMESTAMP)::date
                  , 'dd.mm.yy'
                )
              , ' - '
              , TO_CHAR(
                    (
                        DATE_TRUNC('week', gs::TIMESTAMP) + '6 days'::INTERVAL
                    )::date
                  , 'dd.mm.yy'
                )
            ) week_int
        FROM
            GENERATE_SERIES(
                '01.01.23'
              , (
                    SELECT
                        MAX(zp.attr_1964_) max_date
                    FROM
                        registry.object_606_ zp
                    WHERE
                        zp.is_deleted <> TRUE
                )
              , '1 week'::INTERVAL
            ) gs
    )
SELECT
    weeks.num AS week_num
  , weeks.week_int AS week_interval
  , weeks.date_begin AS date_begin
  , weeks.date_end AS date_end
  , COALESCE(cut_sum.predict_sum_norm_cut, 0) AS cut_int
  , norm_pow.attr_2640_ AS norm_rez
  , ROUND(
        cut_sum.predict_sum_norm_cut / norm_pow.attr_2640_ * 100
      , 2
    ) AS cut_progress
  , COALESCE(tok1_sum.predict_sum_norm_tok1, 0) AS tok1_int
  , norm_pow.attr_2641_ AS norm_tok1
  , tok1_sum.predict_sum_norm_tok1 / norm_pow.attr_2641_ * 100 AS tok1_progress
  , COALESCE(tok_sum.predict_sum_norm_tok, 0) AS tok_int
  , norm_pow.attr_2642_ AS norm_tok
  , tok_sum.predict_sum_norm_tok / norm_pow.attr_2642_ * 100 AS tok_progress
  , COALESCE(rast_frez_sum.predict_sum_norm_rast_frez, 0) AS rast_frez_int
  , norm_pow.attr_2643_ norm_rast_frez
  , rast_frez_sum.predict_sum_norm_rast_frez / norm_pow.attr_2643_ * 100 AS rast_frez_progress
  , COALESCE(shlif_pritir_sum.predict_sum_norm_shlif_pritir, 0) AS shlif_pritir_int
  , norm_pow.attr_2644_ AS norm_shlif_pritir
  , shlif_pritir_sum.predict_sum_norm_shlif_pritir / norm_pow.attr_2644_ * 100 AS shlif_pritir_progress
  , COALESCE(sles_sbor_sum.predict_sum_norm_sles_sbor, 0) AS sles_sbor_int
  , norm_pow.attr_2645_ AS norm_sles_sbor
  , sles_sbor_sum.predict_sum_norm_sles_sbor / norm_pow.attr_2645_ * 100 AS sles_sbor_progress
  , COALESCE(cut_sum.predict_sum_norm_cut, 0) + COALESCE(tok1_sum.predict_sum_norm_tok1, 0) + COALESCE(tok_sum.predict_sum_norm_tok, 0) + COALESCE(rast_frez_sum.predict_sum_norm_rast_frez, 0) + COALESCE(shlif_pritir_sum.predict_sum_norm_shlif_pritir, 0) + COALESCE(sles_sbor_sum.predict_sum_norm_sles_sbor, 0) AS sum_
  , COALESCE(
        ROUND(
            (
                COALESCE(cut_sum.predict_sum_norm_cut, 0) + COALESCE(tok1_sum.predict_sum_norm_tok1, 0) + COALESCE(tok_sum.predict_sum_norm_tok, 0) + COALESCE(rast_frez_sum.predict_sum_norm_rast_frez, 0) + COALESCE(shlif_pritir_sum.predict_sum_norm_shlif_pritir, 0) + COALESCE(sles_sbor_sum.predict_sum_norm_sles_sbor, 0)
            ) / (
                norm_pow.attr_2640_ + norm_pow.attr_2641_ + norm_pow.attr_2642_ + norm_pow.attr_2643_ + norm_pow.attr_2644_ + norm_pow.attr_2645_
            ) * 100
        )
      , 0
    ) AS sum_progress
FROM
    weeks
    LEFT JOIN (
        SELECT
            /*здесь и далее - отладочная информация в комментариях*/
            /*			  data_comp.id comp_id
            , data_comp.quant quant
            , t_op.attr_1443_				
            , t_op.attr_1443_ * data_comp.quant      AS norm_cut,				*/
            data_comp.date_cut AS date_cut
          , SUM(t_op.attr_1443_ * data_comp.quant) AS predict_sum_norm_cut
        FROM
            data_comp
            LEFT JOIN registry.object_527_ t_op ON t_op.attr_538_ = data_comp.tech_card_id
            AND t_op.attr_586_ = 39
        WHERE
            t_op.attr_1443_ IS NOT NULL
        GROUP BY
            data_comp.date_cut
            /*		, data_comp.id
            , t_op.attr_1443_
            , data_comp.quant*/
    ) cut_sum ON cut_sum.date_cut >= weeks.date_begin
    AND cut_sum.date_cut <= weeks.date_end
    LEFT JOIN (
        SELECT
            data_comp.date_tok1 AS date_tok1
          , SUM(t_op.attr_1443_ * data_comp.quant) AS predict_sum_norm_tok1
        FROM
            data_comp
            LEFT JOIN registry.object_527_ t_op ON t_op.attr_538_ = data_comp.tech_card_id
            AND t_op.attr_586_ = 46
        GROUP BY
            data_comp.date_tok1
    ) tok1_sum ON tok1_sum.date_tok1 >= weeks.date_begin
    AND tok1_sum.date_tok1 <= weeks.date_end
    LEFT JOIN (
        SELECT
            data_comp.date_tok date_tok
          , SUM(t_op.attr_1443_ * data_comp.quant) predict_sum_norm_tok
        FROM
            data_comp
            LEFT JOIN registry.object_527_ t_op ON t_op.attr_538_ = data_comp.tech_card_id
            AND t_op.attr_586_ IN (33, 40, 41)
        GROUP BY
            data_comp.date_tok
    ) tok_sum ON tok_sum.date_tok >= weeks.date_begin
    AND tok_sum.date_tok <= weeks.date_end
    LEFT JOIN (
        SELECT
            data_comp.date_rast_frez AS date_rast_frez
          , SUM(t_op.attr_1443_ * data_comp.quant) AS predict_sum_norm_rast_frez
        FROM
            data_comp
            LEFT JOIN registry.object_527_ t_op ON t_op.attr_538_ = data_comp.tech_card_id
            AND t_op.attr_586_ IN (42, 43, 45, 59, 60)
        GROUP BY
            data_comp.date_rast_frez
    ) rast_frez_sum ON rast_frez_sum.date_rast_frez >= weeks.date_begin
    AND rast_frez_sum.date_rast_frez <= weeks.date_end
    LEFT JOIN (
        SELECT
            data_comp.date_shlif_pritir AS date_shlif_pritir
          , SUM(t_op.attr_1443_ * data_comp.quant) AS predict_sum_norm_shlif_pritir
        FROM
            data_comp
            LEFT JOIN registry.object_527_ t_op ON t_op.attr_538_ = data_comp.tech_card_id
            AND t_op.attr_586_ IN (51, 63)
        GROUP BY
            data_comp.date_shlif_pritir
    ) shlif_pritir_sum ON shlif_pritir_sum.date_shlif_pritir >= weeks.date_begin
    AND shlif_pritir_sum.date_shlif_pritir <= weeks.date_end
    LEFT JOIN (
        SELECT
            data_comp.date_sles_sbor date_sles_sbor
          , SUM(t_op.attr_1443_ * data_comp.quant) predict_sum_norm_sles_sbor
        FROM
            data_comp
            LEFT JOIN registry.object_527_ t_op ON t_op.attr_538_ = data_comp.tech_card_id
            AND t_op.attr_586_ IN (62, 54, 57, 56, 48, 49, 47, 44, 55)
        GROUP BY
            data_comp.date_sles_sbor
    ) sles_sbor_sum ON sles_sbor_sum.date_sles_sbor >= weeks.date_begin
    AND sles_sbor_sum.date_sles_sbor <= weeks.date_end
    LEFT JOIN registry.object_2637_ norm_pow ON norm_pow.attr_2639_ = weeks.date_end
    AND norm_pow.is_deleted <> TRUE