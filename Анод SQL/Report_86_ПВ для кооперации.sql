WITH  
mass AS (
  SELECT 
    attr_3203_ AS nom_ed,
    attr_3204_ AS tech_card,
    attr_2173_ AS task,
    attr_3175_ AS pos_task,
    attr_2203_ AS ed_hran,
    attr_2104_ AS mat,
    attr_2105_ AS sort,
    attr_2106_ AS tr
  FROM 
    registry.object_2094_ /*компоненты задания*/
  WHERE 
    is_deleted <> TRUE
  GROUP BY 
    attr_3203_, attr_3204_, attr_2173_, attr_2203_, attr_2104_, attr_2105_, attr_2106_, attr_3175_
  ORDER BY 
    attr_3203_, attr_3204_, attr_2203_ ),
tech_op AS (
  SELECT 
    attr_538_ AS id_tech_card,
    attr_586_ AS type_to,
    attr_613_ AS n_step,
    attr_1443_ AS norm_time,
    attr_2863_ AS description
  FROM 
    registry.object_527_ /* технологические операции */
  WHERE 
    is_deleted <> TRUE)
SELECT 
  o.ID AS o_id,
  tab_part.ID AS tab_part_id,
  types_to.attr_547_ AS name_to,
  ed_hran.attr_2204_ AS name_ed_hran,
  nom.attr_1223_ AS name_nom_ed,
  o.attr_3207_ AS COUNT,
  to_char(o.attr_2156_, 'DD.MM.YY') AS date_pv,
  array_to_string(ARRAY_AGG (DISTINCT (ord.attr_607_)), ', ') AS ord_list,
  array_to_string(ARRAY_AGG (DISTINCT (izd.attr_1410_)), ', ') AS izd_list,
  mass.tech_card,
  tech_op.norm_time AS to_norm_time,
  tech_op.norm_time * o.attr_3207_ AS sum_norm_time,
  tech_op.description AS to_description
FROM 
  registry.object_3426_ waybill
  LEFT JOIN registry.object_2137_ o 
    ON waybill.attr_3429_ = o. ID
  LEFT JOIN registry.object_2138_ tab_part 
    ON tab_part.attr_2148_ = o.ID AND
    tab_part.is_deleted <> TRUE
  LEFT JOIN registry.object_545_ types_to ON tab_part.attr_2149_ = types_to. ID
  LEFT JOIN registry.object_1659_ ed_hran ON o.attr_2167_ = ed_hran. ID
  LEFT JOIN registry.object_301_ nom ON o.attr_2632_ = nom. ID
  LEFT JOIN registry.xref_2675_ mn_s_ord ON mn_s_ord.from_id = o. ID
  LEFT JOIN registry.object_606_ ord ON mn_s_ord.to_id = ord. ID
  LEFT JOIN registry.xref_3264_ mn_s_izd ON mn_s_izd.from_id = o. ID
  LEFT JOIN registry.object_1409_ izd ON mn_s_izd.to_id = izd. ID
  /*отсутствует проверка на активность карты!*/
  LEFT JOIN mass ON mass.nom_ed = attr_2632_ AND
    mass.task = attr_2226_ AND
    mass.ed_hran = attr_2167_ AND
    mass.pos_task = attr_3193_
  LEFT JOIN tech_op ON mass.tech_card = tech_op.id_tech_card AND
    tab_part.attr_2149_ = tech_op.type_to AND
    tab_part.attr_3208_ = tech_op.n_step
WHERE 
  waybill.is_deleted <> TRUE AND 
  waybill.ID = {ID} AND
  tab_part.attr_3433_ = waybill.attr_3431_
GROUP BY 
  o.ID, tab_part.ID, types_to.attr_547_, ed_hran.attr_2204_,
  nom.attr_1223_, o.attr_3207_, to_char(o.attr_2156_, 'DD.MM.YY'),
  mass.tech_card, to_norm_time, sum_norm_time, to_description