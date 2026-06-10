WITH data_comp AS (
    SELECT 
        comp.id,
        comp.attr_1896_ AS quant,
        tech_card.id AS tech_card_id,
        comp.attr_1548_ AS date_cut,
        comp.attr_1551_ AS date_tok1,
        comp.attr_1554_ AS date_tok,
        comp.attr_1557_ AS date_rast_frez,
        comp.attr_1560_ AS date_shlif_pritir,
        comp.attr_1563_ AS date_sles_sbor,
        comp.attr_1945_
    FROM registry.object_1409_ comp
    LEFT JOIN registry.object_301_ nom_in_comp 
        ON comp.attr_1458_ = nom_in_comp.ID AND nom_in_comp.is_deleted IS FALSE
    LEFT JOIN registry.object_519_ tech_card 
        ON /*(CASE WHEN comp.attr_1463_ = 2 OR comp.attr_1421_ IN (6, 4) 
                 THEN tech_card.attr_1466_ ELSE tech_card.attr_520_ END)
           =
           (CASE WHEN comp.attr_1463_ = 2 OR comp.attr_1421_ IN (6, 4) 
                 THEN comp.ID ELSE nom_in_comp.ID END)*/
            tech_card.id = comp.attr_4085_
           AND tech_card.is_deleted IS FALSE
           AND tech_card.attr_2908_ IS TRUE
    WHERE comp.is_deleted IS FALSE
      AND (comp.attr_1421_ IS NULL OR comp.attr_1421_ not in(1, 9))
      AND (comp.attr_1945_ IS NULL OR comp.attr_1945_ != 1)
      AND comp.attr_1650_ IS NOT NULL
      AND comp.attr_2042_ = 2
),
weeks AS (
    SELECT 
        EXTRACT('week' FROM gs) AS num,
        DATE_TRUNC('week', gs::TIMESTAMP)::DATE AS date_begin,
        (DATE_TRUNC('week', gs::TIMESTAMP) + '6 days'::INTERVAL)::DATE AS date_end,
        CONCAT(
            TO_CHAR(DATE_TRUNC('week', gs::TIMESTAMP)::DATE, 'dd.mm.yy'), ' - ',
            TO_CHAR((DATE_TRUNC('week', gs::TIMESTAMP) + '6 days'::INTERVAL)::DATE, 'dd.mm.yy')
        ) AS week_int
    FROM GENERATE_SERIES(
        '01.01.23',
        (SELECT MAX(zp.attr_1964_) FROM registry.object_606_ zp WHERE zp.is_deleted <> TRUE),
        '1 week'::INTERVAL
    ) gs
),
op_agg AS (
    SELECT 
        DATE_TRUNC('week', src.op_date::DATE)::DATE AS week_start,
        COALESCE(SUM(CASE WHEN src.attr_586_ = 39 THEN src.attr_1443_ * src.quant END), 0) AS predict_sum_norm_cut,
        COALESCE(SUM(CASE WHEN src.attr_586_ = 46 THEN src.attr_1443_ * src.quant END), 0) AS predict_sum_norm_tok1,
        COALESCE(SUM(CASE WHEN src.attr_586_ IN (33, 40) THEN src.attr_1443_ * src.quant END), 0) AS predict_sum_norm_tok,
        COALESCE(SUM(CASE WHEN src.attr_586_ IN (42, 43, 45, 59, 60) THEN src.attr_1443_ * src.quant END), 0) AS predict_sum_norm_rast_frez,
        COALESCE(SUM(CASE WHEN src.attr_586_ IN (51, 63) THEN src.attr_1443_ * src.quant END), 0) AS predict_sum_norm_shlif_pritir,
        COALESCE(SUM(CASE WHEN src.attr_586_ = 55 THEN src.attr_1443_ * src.quant END), 0) AS predict_sum_norm_sles_sbor
    FROM (
        SELECT 
            dc.quant,
            t_op.attr_586_,
            t_op.attr_1443_,
            CASE 
                WHEN t_op.attr_586_ = 39 THEN dc.date_cut
                WHEN t_op.attr_586_ = 46 THEN dc.date_tok1
                WHEN t_op.attr_586_ IN (33, 40) THEN dc.date_tok
                WHEN t_op.attr_586_ IN (42, 43, 45, 59, 60) THEN dc.date_rast_frez
                WHEN t_op.attr_586_ IN (51, 63) THEN dc.date_shlif_pritir
                WHEN t_op.attr_586_ = 55 THEN dc.date_sles_sbor
            END AS op_date
        FROM data_comp dc
        JOIN registry.object_527_ t_op 
            ON t_op.attr_538_ = dc.tech_card_id
            AND t_op.attr_586_ IN (39, 46, 33, 40, 42, 43, 45, 59, 60, 51, 63, 55)
            AND t_op.attr_1443_ IS NOT NULL
    ) src
    WHERE src.op_date IS NOT NULL
    GROUP BY DATE_TRUNC('week', src.op_date::DATE)::DATE
),
base_data AS (
    SELECT 
        w.num AS week_num,
        w.week_int AS week_interval,
        w.date_begin AS date_begin,
        w.date_end AS date_end,
        COALESCE(op.predict_sum_norm_cut, 0) AS predict_sum_norm_cut,
        COALESCE(op.predict_sum_norm_tok1, 0) AS predict_sum_norm_tok1,
        COALESCE(op.predict_sum_norm_tok, 0) AS predict_sum_norm_tok,
        COALESCE(op.predict_sum_norm_rast_frez, 0) AS predict_sum_norm_rast_frez,
        COALESCE(op.predict_sum_norm_shlif_pritir, 0) AS predict_sum_norm_shlif_pritir,
        COALESCE(op.predict_sum_norm_sles_sbor, 0) AS predict_sum_norm_sles_sbor,
        COALESCE(n.attr_2640_, 0) AS norm_rez,
        COALESCE(n.attr_2641_, 0) AS norm_tok1,
        COALESCE(n.attr_2642_, 0) AS norm_tok,
        COALESCE(n.attr_2643_, 0) AS norm_rast_frez,
        COALESCE(n.attr_2644_, 0) AS norm_shlif_pritir,
        COALESCE(n.attr_2645_, 0) AS norm_sles_sbor
    FROM weeks w
    LEFT JOIN op_agg op ON w.date_begin = op.week_start
    LEFT JOIN registry.object_2637_ n 
        ON n.attr_2638_ = w.date_begin AND n.is_deleted IS NOT TRUE
)
SELECT 
    week_num,
    week_interval,
    date_begin,
    date_end,
    predict_sum_norm_cut AS cut_int,
    norm_rez,
    ROUND(COALESCE(predict_sum_norm_cut / NULLIF(norm_rez, 0) * 100, 0), 0) AS cut_progress,
    predict_sum_norm_tok1 AS tok1_int,
    norm_tok1,
    ROUND(COALESCE(predict_sum_norm_tok1 / NULLIF(norm_tok1, 0) * 100, 0), 0) AS tok1_progress,
    predict_sum_norm_tok AS tok_int,
    norm_tok,
    ROUND(COALESCE(predict_sum_norm_tok / NULLIF(norm_tok, 0) * 100, 0), 0) AS tok_progress,
    predict_sum_norm_rast_frez AS rast_frez_int,
    norm_rast_frez,
    ROUND(COALESCE(predict_sum_norm_rast_frez / NULLIF(norm_rast_frez, 0) * 100, 0), 0) AS rast_frez_progress,
    predict_sum_norm_shlif_pritir AS shlif_pritir_int,
    norm_shlif_pritir,
    ROUND(COALESCE(predict_sum_norm_shlif_pritir / NULLIF(norm_shlif_pritir, 0) * 100, 0), 0) AS shlif_pritir_progress,
    predict_sum_norm_sles_sbor AS sles_sbor_int,
    norm_sles_sbor,
    ROUND(COALESCE(predict_sum_norm_sles_sbor / NULLIF(norm_sles_sbor, 0) * 100, 0), 0) AS sles_sbor_progress,
    predict_sum_norm_cut + predict_sum_norm_tok1 + predict_sum_norm_tok + 
    predict_sum_norm_rast_frez + predict_sum_norm_shlif_pritir + predict_sum_norm_sles_sbor AS sum_,
    ROUND(
        COALESCE(
            (predict_sum_norm_cut + predict_sum_norm_tok1 + predict_sum_norm_tok + 
             predict_sum_norm_rast_frez + predict_sum_norm_shlif_pritir + predict_sum_norm_sles_sbor) 
            / NULLIF(norm_rez + norm_tok1 + norm_tok + norm_rast_frez + norm_shlif_pritir + norm_sles_sbor, 0) * 100
        , 0), 0
    ) AS sum_progress
FROM base_data
--WHERE date_begin >= '2026-01-01'::date AND date_end <= '2026-12-31'::date
ORDER BY EXTRACT('year' FROM date_begin), date_begin;