   SELECT o.ID AS o_id
        , o.attr_2632_
        , tab_part.ID AS tab_part_id
        , tech_op.attr_547_ AS name_to
        , ed_hran.attr_2204_ AS name_ed_hran
        , nom.attr_1223_ AS name_nom_ed
        , CONCAT(o.attr_3207_, ' шт') AS COUNT
        , TO_CHAR(o.attr_2156_, 'DD.MM.YY') AS date_pv
        , ARRAY_TO_STRING(ARRAY_AGG(DISTINCT (ord.attr_607_)), ', ') AS ord_list
        , ARRAY_TO_STRING(ARRAY_AGG(DISTINCT (izd.attr_1410_)), ', ') AS izd_list
        , mass.tech_card
        , n_t.norm_time
        , n_t.norm_time * o.attr_3207_ AS sum_norm_time
        , zakaz_list
     FROM registry.object_2137_ o
LEFT JOIN registry.object_2138_ tab_part ON tab_part.attr_2148_ = o.ID
      AND tab_part.is_deleted <> TRUE
LEFT JOIN registry.object_545_ tech_op ON tab_part.attr_2149_ = tech_op.ID
LEFT JOIN registry.object_1659_ ed_hran ON o.attr_2167_ = ed_hran.ID
LEFT JOIN registry.object_301_ nom ON o.attr_2632_ = nom.ID
LEFT JOIN registry.object_606_ ord ON ord.ID = ANY (o.attr_2675_)
LEFT JOIN registry.object_1409_ izd ON izd.ID = ANY (o.attr_4033_)
LEFT JOIN (
             SELECT o.attr_3203_ AS nom_ed
                  , o.attr_3204_ AS tech_card
                  , o.attr_2173_
                  , o.attr_3175_
                  , o.attr_2203_ AS ed_hran
                  , o.attr_2104_ AS mat
                  , o.attr_2105_ AS sort
                  , o.attr_2106_ AS tr
                  , SUM(o.attr_2103_)
                  , ARRAY_TO_STRING(
                    ARRAY_AGG(
                    DISTINCT (CONCAT(zak.attr_607_, ' - ', gl_comp.attr_1896_))
                    )
                  , ', '
                    ) AS zakaz_list
               FROM registry.object_2094_ o
          LEFT JOIN registry.object_1409_ gl_comp ON o.attr_2100_ = gl_comp.ID
          LEFT JOIN registry.object_1227_ comp_pr ON gl_comp.attr_1423_ = comp_pr.ID
          LEFT JOIN registry.object_606_ zak ON comp_pr.attr_1923_ = zak.ID
              WHERE o.is_deleted IS FALSE
           GROUP BY o.attr_3203_
                  , o.attr_3204_
                  , o.attr_2173_
                  , o.attr_2203_
                  , o.attr_2104_
                  , o.attr_2105_
                  , o.attr_2106_
                  , o.attr_3175_
           ORDER BY o.attr_3203_
                  , o.attr_3204_
                  , o.attr_2203_
          ) mass ON mass.nom_ed = o.attr_2632_
      AND mass.attr_2173_ = o.attr_2226_
      AND COALESCE(mass.ed_hran, 0) = COALESCE(o.attr_2167_, 0)
      AND COALESCE(mass.attr_3175_, 0) = COALESCE(o.attr_3193_, 0)
LEFT JOIN (
             SELECT o.attr_538_ AS id_tech_card
                  , o.attr_586_ AS id_to
                  , o.attr_613_ AS n_step
                  , o.attr_1443_ AS norm_time
               FROM registry.object_527_ o
              WHERE o.is_deleted IS FALSE
          ) n_t ON mass.tech_card = n_t.id_tech_card
      AND tab_part.attr_2149_ = n_t.id_to
      AND tab_part.attr_3208_ = n_t.n_step
    WHERE o.is_deleted IS FALSE
    AND o.id = {id}
 GROUP BY o.ID
        , tab_part.ID
        , tech_op.attr_547_
        , ed_hran.attr_2204_
        , nom.attr_1223_
        , o.attr_3207_
        , TO_CHAR(o.attr_2156_, 'DD.MM.YY')
        , mass.tech_card
        , n_t.norm_time
        , n_t.norm_time * o.attr_3207_
        , zakaz_list