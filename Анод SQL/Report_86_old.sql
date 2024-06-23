/*ПВ для кооперации*/
SELECT o.ID AS o_id,
       tab_part.ID AS tab_part_id,
       tech_op.attr_547_ AS name_to,
       ed_hran.attr_2204_ AS name_ed_hran,
       nom.attr_1223_ AS name_nom_ed,
       o.attr_3207_ AS COUNT,
       to_char(o.attr_2156_, 'DD.MM.YY') AS date_pv,
       array_to_string(ARRAY_AGG (DISTINCT (ord.attr_607_)), ', ') AS ord_list,
       array_to_string(ARRAY_AGG (DISTINCT (izd.attr_1410_)), ', ') AS izd_list,
       mass.tech_card,
       n_t.norm_time,
       n_t.norm_time * o.attr_3207_ AS sum_norm_time
FROM registry.object_3426_ waybill
LEFT JOIN registry.object_2137_ o ON waybill.attr_3429_ = o. ID
LEFT JOIN registry.object_2138_ tab_part ON tab_part.attr_2148_ = o.ID
AND tab_part.is_deleted <> TRUE
LEFT JOIN registry.object_545_ tech_op ON tab_part.attr_2149_ = tech_op. ID
LEFT JOIN registry.object_1659_ ed_hran ON o.attr_2167_ = ed_hran. ID
LEFT JOIN registry.object_301_ nom ON o.attr_2632_ = nom. ID
LEFT JOIN registry.xref_2675_ mn_s_ord ON mn_s_ord.from_id = o. ID
LEFT JOIN registry.object_606_ ord ON mn_s_ord.to_id = ord. ID
LEFT JOIN registry.xref_3264_ mn_s_izd ON mn_s_izd.from_id = o. ID
LEFT JOIN registry.object_1409_ izd ON mn_s_izd.to_id = izd. ID
LEFT JOIN
  ( SELECT attr_3203_ AS nom_ed,
           attr_3204_ AS tech_card,
           attr_2173_ AS task,
           attr_3175_ AS pos_task,
           attr_2203_ AS ed_hran,
           attr_2104_ AS mat,
           attr_2105_ AS sort,
           attr_2106_ AS tr,
           SUM (attr_2103_)
   FROM registry.object_2094_ /*компоненты задания*/
   WHERE is_deleted <> TRUE
   GROUP BY attr_3203_,
            attr_3204_,
            attr_2173_,
            attr_2203_,
            attr_2104_,
            attr_2105_,
            attr_2106_,
            attr_3175_
   ORDER BY attr_3203_,
            attr_3204_,
            attr_2203_) mass ON mass.nom_ed = attr_2632_
AND mass.task = attr_2226_
AND mass.ed_hran = attr_2167_
AND mass.pos_task = attr_3193_
LEFT JOIN
  ( SELECT o.attr_538_ AS id_tech_card,
           o.attr_586_ AS id_to,
           o.attr_613_ AS n_step,
           o.attr_1443_ AS norm_time
   FROM registry.object_527_ o
   WHERE o.is_deleted <> TRUE) n_t ON mass.tech_card = n_t.id_tech_card
AND tab_part.attr_2149_ = n_t.id_to
AND tab_part.attr_3208_ = n_t.n_step
WHERE waybill.is_deleted <> TRUE
  AND waybill.ID = { ID }
  AND tab_part.attr_3433_ = waybill.attr_3431_
GROUP BY o.ID,
         tab_part.ID,
         tech_op.attr_547_,
         ed_hran.attr_2204_,
         nom.attr_1223_,
         o.attr_3207_,
         to_char(o.attr_2156_, 'DD.MM.YY'),
         mass.tech_card,
         n_t.norm_time,
         n_t.norm_time * o.attr_3207_