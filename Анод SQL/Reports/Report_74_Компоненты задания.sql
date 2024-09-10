     WITH dataset1 AS (
             SELECT o.ID
                  , o.attr_3175_ AS position_task
                  , ord_man.attr_607_
                  , obz_izd.attr_1410_ AS izd
                  , obz_det.attr_1410_ AS det
                  , tech_card_prod.ID AS tech_card_prod_id
                  , o.attr_2175_ AS name_det
                  , o.attr_2103_ AS amount
                  , ed_hran.attr_2204_ AS full_name_ed_hran
                  , CONCAT(
                    s_mat.attr_2976_
                  , ' '
                  , s_sort.attr_401_
                  , ' '
                  , s_tr.attr_401_
                    ) AS name_mat
                  , ed_hran.attr_1666_ AS n_cast
                  , ed_hran.attr_1667_ AS n_qcert
                  , TO_CHAR(ed_hran.attr_1668_, 'DD.MM.YY') AS date_qcert
                  , CASE
                              WHEN ed_hran.attr_1667_ IS NOT NULL THEN CONCAT(
                              ed_hran.attr_1667_
                            , ' от '
                            , TO_CHAR(ed_hran.attr_1668_, 'DD.MM.YY')
                              )
                    END AS info_qcert
                  , tech_card_prod.attr_2554_ AS GR_zag
                  , obz_det.attr_1896_::NUMERIC(5, 2) AS Q_comp_ord
                  , tech_card_prod.attr_2555_::NUMERIC(5, 2) AS N_max
                  , tech_card_prod.attr_2907_ AS q_det_v_zag
                  , tech_card_prod.attr_1879_::NUMERIC(5, 2) AS l_zag
                  , tech_card_prod.attr_2884_::NUMERIC(5, 2) AS S_dop
                  , CASE
                              WHEN ed_hran.attr_2214_ IN (1, 4, 5) THEN ed_hran.attr_2212_
                              WHEN ed_hran.attr_2214_ = 2 THEN ed_hran.attr_2211_
                    END AS fact_size
                  
                  , o.attr_2107_ AS m_blank
                  , o.attr_2108_ AS sum_m_blank
                  , o.attr_2109_ AS nc
                  , o.attr_2110_ AS sum_nc
               FROM registry.object_2094_ o
          LEFT JOIN registry.object_606_ ord_man ON o.attr_2102_ = ord_man.ID
          LEFT JOIN registry.object_1409_ obz_izd ON o.attr_2101_ = obz_izd.ID
          LEFT JOIN registry.object_1409_ obz_det ON o.attr_2100_ = obz_det.ID
          LEFT JOIN registry.object_1659_ ed_hran ON o.attr_2203_ = ed_hran.ID
          LEFT JOIN registry.object_400_ s_mat ON ed_hran.attr_1663_ = s_mat.ID
          LEFT JOIN registry.object_400_ s_sort ON ed_hran.attr_1664_ = s_sort.ID
          LEFT JOIN registry.object_400_ s_tr ON ed_hran.attr_1665_ = s_tr.ID
          LEFT JOIN registry.object_519_ tech_card_prod ON obz_det.attr_4085_ = tech_card_prod.ID
              WHERE o.is_deleted IS FALSE
          )
        , dataset2 AS (
             SELECT *
                  , CASE
                              WHEN FLOOR(Q_comp_ord / N_max) = 0 THEN 1
                              ELSE FLOOR(Q_comp_ord / N_max)
                    END AS N_gr_ceiling /*количество полных групповых заготовок*//*если ближайшее меньшее количество полных заготовок- 0, то заготовка одна неполная*/
                  , CASE
                              WHEN FLOOR(Q_comp_ord / N_max) = 0 THEN (
                              (
                              CEILING(Q_comp_ord / q_det_v_zag) - FLOOR(Q_comp_ord / N_max) * N_max / q_det_v_zag
                              ) * l_zag + COALESCE(S_dop, 0)
                              )
                              ELSE l_zag * N_max / q_det_v_zag + COALESCE(S_dop, 0)
                    END::int AS L_gr_ceiling /*длина полных групповых заготовок*//*если полных заготовок - 0, то считается по формуле неполной*/
                  , CASE
                              WHEN FLOOR(Q_comp_ord / N_max) = 0 THEN 0
                              ELSE (
                              (
                              CEILING(Q_comp_ord / q_det_v_zag) - FLOOR(Q_comp_ord / N_max) * N_max / q_det_v_zag
                              ) * l_zag + COALESCE(S_dop, 0)
                              )
                    END::int AS L_gr_floor /*длина неполных групповых заготовок*//*если полных заготовок - 0, то дополнительных неполных тоже 0, и их длина - 0*/
               FROM dataset1
          )
   SELECT *
        , CASE
                    WHEN GR_zag IS TRUE THEN CONCAT(
                    N_gr_ceiling
                  , ' гр. з. - '
                  , L_gr_ceiling
                  , CASE
                              WHEN (
                              CEILING(Q_comp_ord / N_max) - FLOOR(Q_comp_ord / N_max)
                              ) <> 0
                                    AND FLOOR(Q_comp_ord / N_max) <> 0 THEN CONCAT('\n', '1 гр. з. - ', L_gr_floor)
                                        ELSE ''
                    END
                    )
                    WHEN GR_zag IS FALSE THEN ROUND(l_zag)::VARCHAR
                    ELSE ''
          END AS l_blank
        , CASE
                    WHEN GR_zag IS TRUE THEN N_gr_ceiling * L_gr_ceiling + L_gr_floor
                    WHEN GR_zag IS FALSE THEN l_zag * Q_comp_ord
          END::int AS sum_l_blank
     FROM dataset2
    WHERE position_task IN (1540, 1561)