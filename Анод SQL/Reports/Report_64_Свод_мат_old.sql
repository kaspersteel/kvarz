WITH DATA AS
  (SELECT o.id AS project_id,
SELECT j.prod_id,
       sprav_mat.attr_2976_ AS mat,
       sprav_sort.attr_2976_ AS sort,
       sprav_tr.attr_2976_ AS tr,
       SUM (j.massa)
FROM
  (SELECT o.ID AS prod_id,
          comp.ID AS comp_id,
          nom_in_comp.ID AS nom_in_comp_id,
          tech_card.ID AS tech_card_id,
          CASE
              WHEN comp.attr_1463_ = 2 THEN tech_card_comp.attr_2381_
              ELSE tech_card.attr_2381_
          END AS mat,
          CASE
              WHEN comp.attr_1463_ = 2 THEN tech_card_comp.attr_1876_
              ELSE tech_card.attr_1876_
          END AS sort,
          CASE
              WHEN comp.attr_1463_ = 2 THEN tech_card_comp.attr_1877_
              ELSE tech_card.attr_1877_
          END AS tr,
          CASE
              WHEN comp.attr_1463_ = 2 THEN round(tech_card_comp.attr_3271_ * comp.attr_1896_, 2)
              ELSE round(tech_card.attr_3271_ * comp.attr_1896_, 2)
          END AS massa
   FROM registry.object_1227_ o
   LEFT JOIN registry.object_1409_ comp ON comp.attr_1423_ = o.ID
   AND comp.is_deleted <> TRUE
   AND (comp.attr_1421_ IS NULL
        OR comp.attr_1421_ <> 1)
   LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_1458_ = nom_in_comp. ID
   LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = nom_in_comp.ID
   AND tech_card.is_deleted <> TRUE
   AND tech_card.attr_2908_ = TRUE
   LEFT JOIN registry.object_519_ tech_card_comp ON tech_card_comp.attr_1466_ = comp.ID
   AND tech_card_comp.is_deleted <> TRUE
   AND tech_card_comp.attr_2908_ = TRUE
   WHERE o.is_deleted <> TRUE
     AND o.ID = '{id_proj}') j
LEFT JOIN registry.object_400_ sprav_mat ON j.mat = sprav_mat. ID
LEFT JOIN registry.object_400_ sprav_sort ON j.sort = sprav_sort. ID
LEFT JOIN registry.object_400_ sprav_tr ON j.tr = sprav_tr.ID
WHERE sprav_mat.attr_2976_ IS NOT NULL
GROUP BY j.prod_id,
         sprav_mat.attr_2976_,
         sprav_sort.attr_2976_,
         sprav_tr.attr_2976_
ORDER BY sprav_mat.attr_2976_,
         sprav_sort.attr_2976_,
         sprav_tr.attr_2976_