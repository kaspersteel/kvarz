     WITH comp_task AS (
             SELECT attr_3203_ AS nom_ed
                  , attr_3204_ AS tech_card
                  , attr_2173_ AS task
                  , attr_3175_ AS pos_task
                  , attr_2203_ AS ed_hran
                  , attr_2104_ AS mat
                  , attr_2105_ AS sort
                  , attr_2106_ AS tr
               FROM registry.object_2094_ /*компоненты задания*/
              WHERE is_deleted IS FALSE
           GROUP BY attr_3203_
                  , attr_3204_
                  , attr_2173_
                  , attr_2203_
                  , attr_2104_
                  , attr_2105_
                  , attr_2106_
                  , attr_3175_
           ORDER BY attr_3203_
                  , attr_3204_
                  , attr_2203_
          )
        , tech_op AS (
             SELECT attr_538_ AS id_tech_card
                  , attr_586_ AS type_to
                  , attr_613_ AS n_step
                  , attr_1443_ AS norm_time
                  , attr_2863_ AS description
               FROM registry.object_527_ /* технологические операции */
              WHERE is_deleted IS FALSE
          )
   SELECT accept_list.ID AS o_id
        , tab_accept_list.ID AS tab_accept_list_id
        , types_to.attr_547_ AS name_to
        , ed_hran.attr_2204_ AS name_ed_hran
        , nom.attr_1223_ AS name_nom_ed
        , accept_list.attr_3207_ AS COUNT
        , TO_CHAR(accept_list.attr_2156_, 'DD.MM.YY') AS date_pv
        , ARRAY_TO_STRING(ARRAY_AGG(DISTINCT (ord.attr_607_)), ', ') AS ord_list
        , ARRAY_TO_STRING(ARRAY_AGG(DISTINCT (izd.attr_1410_)), ', ') AS izd_list
        , comp_task.tech_card
        , tech_op.norm_time AS to_norm_time
        , tech_op.norm_time * accept_list.attr_3207_ AS sum_norm_time
        , tech_op.description AS to_description
     FROM registry.object_3426_ waybill
LEFT JOIN registry.object_2137_ accept_list ON waybill.attr_3429_ = accept_list.ID
LEFT JOIN registry.object_2138_ tab_accept_list ON tab_accept_list.attr_2148_ = accept_list.ID
      AND tab_accept_list.is_deleted IS FALSE
LEFT JOIN registry.object_545_ types_to ON tab_accept_list.attr_2149_ = types_to.ID
LEFT JOIN registry.object_1659_ ed_hran ON accept_list.attr_2167_ = ed_hran.ID
LEFT JOIN registry.object_301_ nom ON accept_list.attr_2632_ = nom.ID
LEFT JOIN registry.object_606_ ord ON ord.ID = ANY(accept_list.attr_2675_)
LEFT JOIN registry.object_1409_ izd ON izd.ID = ANY(accept_list.attr_4033_)
          /*отсутствует проверка на активность карты!*/
LEFT JOIN comp_task ON comp_task.nom_ed = attr_2632_
      AND comp_task.task = attr_2226_
      AND comp_task.ed_hran = attr_2167_
      AND comp_task.pos_task = attr_3193_
LEFT JOIN tech_op ON comp_task.tech_card = tech_op.id_tech_card
      AND tab_accept_list.attr_2149_ = tech_op.type_to
      AND tab_accept_list.attr_3208_ = tech_op.n_step
    WHERE waybill.is_deleted IS FALSE
      AND waybill.ID = 28
      AND tab_accept_list.attr_4075_ = waybill.id
 GROUP BY accept_list.ID
        , tab_accept_list.ID
        , types_to.attr_547_
        , ed_hran.attr_2204_
        , nom.attr_1223_
        , accept_list.attr_3207_
        , TO_CHAR(accept_list.attr_2156_, 'DD.MM.YY')
        , comp_task.tech_card
        , to_norm_time
        , sum_norm_time
        , to_description
