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
      AND tab_part.attr_2149_ <> 52 /*не преамбула*/
      AND tab_part.is_deleted IS FALSE
LEFT JOIN registry.object_545_ tech_op ON tab_part.attr_2149_ = tech_op.ID
      AND tech_op.is_deleted IS FALSE
LEFT JOIN registry.object_1659_ ed_hran ON o.attr_2167_ = ed_hran.ID
      AND ed_hran.is_deleted IS FALSE
LEFT JOIN registry.object_301_ nom ON o.attr_2632_ = nom.ID
      AND nom.is_deleted IS FALSE
LEFT JOIN registry.object_606_ ord ON ord.ID = ANY (o.attr_2675_)
      AND ord.is_deleted IS FALSE
LEFT JOIN registry.object_1409_ izd ON izd.ID = ANY (o.attr_4033_)
      AND izd.is_deleted IS FALSE
LEFT JOIN (
             SELECT comp_task.attr_3203_ AS nom_ed
                  , comp_task.attr_3204_ AS tech_card
                  , comp_task.attr_2173_
                  , comp_task.attr_3175_
                  , comp_task.attr_2203_ AS ed_hran
                  , comp_task.attr_2104_ AS mat
                  , comp_task.attr_2105_ AS sort
                  , comp_task.attr_2106_ AS tr
                  , SUM(comp_task.attr_2103_)
                  , ARRAY_TO_STRING(
                    ARRAY_AGG(
                    DISTINCT (CONCAT(zak.attr_607_, ' - ', gl_comp.attr_1896_))
                    )
                  , ', '
                    ) AS zakaz_list
               FROM registry.object_2094_ comp_task
          LEFT JOIN registry.object_1409_ gl_comp ON comp_task.attr_2100_ = gl_comp.ID
                AND gl_comp.is_deleted IS FALSE
          LEFT JOIN registry.object_1227_ comp_pr ON gl_comp.attr_1423_ = comp_pr.ID
                AND comp_pr.is_deleted IS FALSE
          LEFT JOIN registry.object_606_ zak ON comp_pr.attr_1923_ = zak.ID
              WHERE comp_task.is_deleted IS FALSE
           GROUP BY comp_task.attr_3203_
                  , comp_task.attr_3204_
                  , comp_task.attr_2173_
                  , comp_task.attr_2203_
                  , comp_task.attr_2104_
                  , comp_task.attr_2105_
                  , comp_task.attr_2106_
                  , comp_task.attr_3175_
           ORDER BY comp_task.attr_3203_
                  , comp_task.attr_3204_
                  , comp_task.attr_2203_
          ) mass ON mass.nom_ed = o.attr_2632_
      AND mass.attr_2173_ = o.attr_2226_
      AND COALESCE(mass.ed_hran, 0) = COALESCE(o.attr_2167_, 0)
      AND COALESCE(mass.attr_3175_, 0) = COALESCE(o.attr_3193_, 0)
LEFT JOIN (
             SELECT t_op.attr_538_ AS id_tech_card
                  , t_op.attr_586_ AS id_to
                  , t_op.attr_613_ AS n_step
                  , t_op.attr_1443_ AS norm_time
               FROM registry.object_527_ t_op
              WHERE t_op.is_deleted IS FALSE
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