   WITH tech_ops AS (SELECT t_op.attr_538_ AS marsh_card_id,
          SUM(CASE WHEN t_op.attr_586_ = 33 THEN t_op.attr_1443_ ELSE 0 END) AS t_tokr_s_chpy,
          SUM(CASE WHEN t_op.attr_586_ = 38 THEN t_op.attr_1443_ ELSE 0 END) AS t_kontrol,
          SUM(CASE WHEN t_op.attr_586_ = 39 THEN t_op.attr_1443_ ELSE 0 END) AS t_otrez,
          SUM(CASE WHEN t_op.attr_586_ = 40 THEN t_op.attr_1443_ ELSE 0 END) AS t_tokrn,
          SUM(CASE WHEN t_op.attr_586_ = 41 THEN t_op.attr_1443_ ELSE 0 END) AS t_term,
          SUM(CASE WHEN t_op.attr_586_ = 42 THEN t_op.attr_1443_ ELSE 0 END) AS t_frez,
          SUM(CASE WHEN t_op.attr_586_ = 43 THEN t_op.attr_1443_ ELSE 0 END) AS t_rast,
          SUM(CASE WHEN t_op.attr_586_ = 44 THEN t_op.attr_1443_ ELSE 0 END) AS t_sles,
          SUM(CASE WHEN t_op.attr_586_ = 45 THEN t_op.attr_1443_ ELSE 0 END) AS t_dolb,
          SUM(CASE WHEN t_op.attr_586_ = 46 THEN t_op.attr_1443_ ELSE 0 END) AS t_tokr1,
          SUM(CASE WHEN t_op.attr_586_ = 47 THEN t_op.attr_1443_ ELSE 0 END) AS t_sverl,
          SUM(CASE WHEN t_op.attr_586_ = 48 THEN t_op.attr_1443_ ELSE 0 END) AS t_razval,
          SUM(CASE WHEN t_op.attr_586_ = 49 THEN t_op.attr_1443_ ELSE 0 END) AS t_svar,
          SUM(CASE WHEN t_op.attr_586_ = 50 THEN t_op.attr_1443_ ELSE 0 END) AS t_pokr,
          SUM(CASE WHEN t_op.attr_586_ = 51 THEN t_op.attr_1443_ ELSE 0 END) AS t_shlif,
          SUM(CASE WHEN t_op.attr_586_ = 52 THEN t_op.attr_1443_ ELSE 0 END) AS t_preamb,
          string_agg(CASE WHEN t_op.attr_586_ = 53 THEN concat('Шаг №', t_op.attr_613_,' - ', t_op.attr_2863_) END, '\n') as marsh_op,
          SUM(CASE WHEN t_op.attr_586_ = 54 THEN t_op.attr_1443_ ELSE 0 END) AS t_komplekt,
          SUM(CASE WHEN t_op.attr_586_ = 55 THEN t_op.attr_1443_ ELSE 0 END) AS t_sles_sbor,
          SUM(CASE WHEN t_op.attr_586_ = 56 THEN t_op.attr_1443_ ELSE 0 END) AS t_opres,
          SUM(CASE WHEN t_op.attr_586_ = 57 THEN t_op.attr_1443_ ELSE 0 END) AS t_markir,
          SUM(CASE WHEN t_op.attr_586_ = 59 THEN t_op.attr_1443_ ELSE 0 END) AS t_rast_s_chpy,
          SUM(CASE WHEN t_op.attr_586_ = 60 THEN t_op.attr_1443_ ELSE 0 END) AS t_frez_s_chpy,
          SUM(CASE WHEN t_op.attr_586_ = 61 THEN t_op.attr_1443_ ELSE 0 END) AS t_elektro,
          SUM(CASE WHEN t_op.attr_586_ = 62 THEN t_op.attr_1443_ ELSE 0 END) AS t_gravirov,
          SUM(CASE WHEN t_op.attr_586_ = 63 THEN t_op.attr_1443_ ELSE 0 END) AS t_pritir,
          SUM(CASE WHEN t_op.attr_586_ NOT IN (33, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 59, 60, 61, 62, 63) THEN t_op.attr_1443_ ELSE 0 END) AS t_another
     FROM registry.object_527_ t_op
    WHERE NOT t_op.is_deleted
 GROUP BY t_op.attr_538_)

   SELECT o.id,
          head.attr_376_ AS HEADER,
          o.attr_1455_,
          nomen.attr_1223_ AS obz,
          nomen.attr_376_ AS obz2,
          o.attr_2905_ AS typ,
          o.attr_582_ AS NAME,
          code.attr_1525_ AS kod,
          o.attr_4079_ AS COUNT,

CASE
          WHEN nomen.attr_363_ IN (84, 85, 86, 87, 1, 10) THEN 1
          WHEN nomen.attr_363_ = 2 THEN 2
          WHEN nomen.attr_363_ = 3
                AND nomen.attr_376_ LIKE SPLIT_PART(head.attr_376_, ' ', 1) || '%' THEN 3
          WHEN nomen.attr_363_ = 3
                AND nomen.attr_376_ NOT LIKE SPLIT_PART(head.attr_376_, ' ', 1) || '%' THEN 4
          WHEN nomen.attr_363_ = 6
                AND NOT nomen.attr_4157_ THEN 5
          WHEN nomen.attr_363_ = 6
                AND nomen.attr_4157_ THEN 6
          WHEN nomen.attr_363_ IN (7, 88) THEN 7
          WHEN nomen.attr_363_ = 82 THEN 8
          WHEN nomen.attr_363_ IN (8, 9, 11, 83) THEN 9
          ELSE 10
END type_nom,
CASE
          WHEN nomen.attr_363_ IN (84, 85, 86, 87, 1, 10) THEN 'изд'
          WHEN nomen.attr_363_ = 2 THEN 'сб'
          WHEN nomen.attr_363_ = 3 THEN 'дет'
          WHEN nomen.attr_363_ = 6
                AND NOT nomen.attr_4157_ THEN 'ГД'
          WHEN nomen.attr_363_ = 6
                AND nomen.attr_4157_ THEN 'СтД'
          WHEN nomen.attr_363_ IN (7, 88) THEN 'прч'
          WHEN nomen.attr_363_ = 82 THEN 'МвС'
          WHEN nomen.attr_363_ IN (8, 9, 11, 83) THEN 'К'
          ELSE 'др'
END name_type_nom,
CASE
          WHEN o.attr_1456_ IN (3, 8, 9.10) THEN 4
          WHEN o.attr_1456_ = 1 THEN 2
          WHEN o.attr_1456_ IN (2, 15, 16) THEN 1
          WHEN o.attr_1456_ IN (6, 7) THEN 3
          ELSE o.attr_1456_
END typk,
o.attr_4079_ AS kol_vo,
CASE
          WHEN nomen.attr_363_ <> 6 THEN mat.attr_401_
          ELSE NULL
END AS mat_name,
CASE
          WHEN tech_ops.marsh_op IS NOT NULL THEN 'М'
          ELSE NULL
END AS have_marsh,
CASE
          WHEN marsh_card.attr_2554_ = TRUE THEN CONCAT(
          ROUND(marsh_card.attr_1879_, 0),
          '*N',
          CASE
                    WHEN marsh_card.attr_2884_ IS NOT NULL THEN CONCAT('+', ROUND(marsh_card.attr_2884_, 0))
                    ELSE NULL
          END,
          ', maxN=',
          marsh_card.attr_2555_
          )
END AS formula_izg,
ROUND(marsh_card.attr_1879_, 0) AS L,
ROUND(marsh_card.attr_1873_, 0) AS D,
ROUND(marsh_card.attr_3220_, 0) AS d_in,
ROUND(marsh_card.attr_1875_, 0) AS B,
ROUND(marsh_card.attr_1874_, 0) AS s,
ROUND(marsh_card.attr_3271_, 4) AS massa,
tech_ops.t_otrez * o.attr_4079_ AS otrez_op,
tech_ops.t_tokrn * o.attr_4079_ AS tokrn_op,
tech_ops.t_frez * o.attr_4079_ AS frez_op,
tech_ops.t_rast * o.attr_4079_ AS rast_op,
tech_ops.t_sverl * o.attr_4079_ AS sverl_op,
tech_ops.t_dolb * o.attr_4079_ AS dolb_op,
tech_ops.t_shlif * o.attr_4079_ AS shlif_op,
tech_ops.t_svar * o.attr_4079_ AS svar_op,
tech_ops.t_sles * o.attr_4079_ AS sles_op,
tech_ops.t_term * o.attr_4079_ AS term_op,
tech_ops.t_pokr * o.attr_4079_ AS pokr_op,
tech_ops.t_sles_sbor * o.attr_4079_ AS sles_sbor_op,
tech_ops.t_tokr1 * o.attr_4079_ AS tokr1_op,
tech_ops.t_tokr_s_chpy * o.attr_4079_ AS tokr_s_chpy_op,
tech_ops.t_frez_s_chpy * o.attr_4079_ AS frez_s_chpy_op,
tech_ops.t_rast_s_chpy * o.attr_4079_ AS rast_s_chpy_op,
tech_ops.t_gravirov * o.attr_4079_ AS gravirov_op,
tech_ops.t_komplekt * o.attr_4079_ AS komplekt_op,
tech_ops.t_kontrol * o.attr_4079_ AS kontrol_op,
tech_ops.t_markir * o.attr_4079_ AS markir_op,
tech_ops.t_opres * o.attr_4079_ AS opres_op,
tech_ops.t_preamb * o.attr_4079_ AS preamb_op,
tech_ops.t_pritir * o.attr_4079_ AS pritir_op,
tech_ops.t_razval * o.attr_4079_ AS razval_op,
tech_ops.t_elektro * o.attr_4079_ AS elektro_op,
tech_ops.t_another * o.attr_4079_ AS another_op,
tech_ops.marsh_op AS marsh_op,

tech_ops.t_otrez * o.attr_4079_ + tech_ops.t_tokrn * o.attr_4079_ + tech_ops.t_frez * o.attr_4079_ + 
tech_ops.t_rast * o.attr_4079_ + tech_ops.t_sverl * o.attr_4079_ + tech_ops.t_dolb * o.attr_4079_ + 
tech_ops.t_shlif * o.attr_4079_ + tech_ops.t_svar * o.attr_4079_ + tech_ops.t_sles * o.attr_4079_ + 
tech_ops.t_term * o.attr_4079_ + tech_ops.t_pokr * o.attr_4079_ + tech_ops.t_sles_sbor * o.attr_4079_ + 
tech_ops.t_tokr1 * o.attr_4079_ + tech_ops.t_tokr_s_chpy * o.attr_4079_ + tech_ops.t_frez_s_chpy * o.attr_4079_ + 
tech_ops.t_rast_s_chpy * o.attr_4079_ + tech_ops.t_another * o.attr_4079_ AS sum_time

     FROM registry.object_369_ o
LEFT JOIN registry.object_301_ nomen ON o.attr_370_ = nomen.id
      AND nomen.is_deleted <> TRUE
LEFT JOIN registry.object_519_ mk2 ON mk2.attr_520_ = o.attr_370_
      AND mk2.attr_2908_ IS TRUE
      AND mk2.is_deleted = FALSE
LEFT JOIN registry.object_301_ code ON o.attr_370_ = code.id
LEFT JOIN registry.object_301_ head ON o.attr_374_ = head.id
LEFT JOIN registry.object_400_ mat ON nomen.attr_526_ = mat.id
      AND mat.is_deleted <> TRUE
LEFT JOIN registry.object_519_ marsh_card ON marsh_card.attr_520_ = nomen.id
      AND marsh_card.is_deleted <> TRUE
      AND marsh_card.attr_2908_ = TRUE
LEFT JOIN tech_ops ON tech_ops.marsh_card_id = marsh_card.id
    WHERE o.is_deleted <> TRUE
      AND o.attr_374_ = '{superid}'
 ORDER BY type_nom,
          CASE
                    WHEN nomen.attr_363_ = 3 THEN nomen.attr_376_
                    ELSE o.attr_582_
          END