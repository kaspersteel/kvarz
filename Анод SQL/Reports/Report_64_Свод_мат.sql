WITH DATA AS
  (SELECT o.ID AS project_id,
          comp.ID AS comp_id,
          nom_in_comp.ID AS nom_in_comp_id,
          tech_card.ID AS tech_card_id,
          comp.attr_3934_ AS given_mat, /*давальческий*/
          /*если тип - МвС, взять данные из него*/
          CASE
              WHEN comp.attr_1452_ = 16 THEN comp_structure.attr_3967_
              ELSE tech_card.attr_2381_
          END AS mat, /*материал из техкарты или компонента состава ном. ед.*/
          tech_card.attr_1876_ AS sort, /*сортамент*/
          tech_card.attr_1877_ AS tr, /*типоразмер*/
          CASE
              WHEN comp.attr_1452_ = 16 THEN comp_structure.attr_3926_ /*расход МвС*/
              WHEN sprav_mat.attr_1354_ = 6 THEN comp.attr_1896_ /*количество заготовок*/
              ELSE round(tech_card.attr_3271_ * comp.attr_1896_, 2) /*списываемая масса материала*/
          END AS quant, /*количество материала различного типа*/
          CASE
              WHEN comp.attr_1452_ = 16 THEN comp_structure.attr_3925_ /*ед. изм. расхода МвС*/
              WHEN sprav_tr.ID IS NOT NULL THEN sprav_tr.attr_1673_ /*ед. изм. типоразмера*/
              ELSE sprav_mat.attr_1673_ /*ед. изм. материала*/
          END AS units /*ссылка на ед. измерения*/
   FROM registry.object_1227_ o
/*компонент без измененний или не удален из состава*/
   LEFT JOIN registry.object_1409_ comp ON comp.attr_1423_ = o.ID
   AND comp.is_deleted <> TRUE
   AND (comp.attr_1421_ IS NULL 
        OR comp.attr_1421_  !=1) 
   LEFT JOIN registry.object_301_ nom_in_comp ON comp.attr_1458_ = nom_in_comp.ID
   AND nom_in_comp.is_deleted <> TRUE
   LEFT JOIN registry.object_369_ comp_structure ON comp.attr_3969_ = comp_structure.ID
   AND comp_structure.is_deleted <> TRUE
   LEFT JOIN registry.object_519_ tech_card ON (CASE WHEN comp.attr_1463_ = 2
                                                OR comp.attr_1421_ IN (6,
                                                                       4) THEN tech_card.attr_1466_ ELSE tech_card.attr_520_ END 
                                                = 
                                                CASE WHEN comp.attr_1463_ = 2
                                                OR comp.attr_1421_ IN (6,
                                                                       4) THEN comp.ID ELSE nom_in_comp.ID END) /*выбираем карту из компонента, если его изменили или создали не из ном. ед.*/
   AND tech_card.is_deleted <> TRUE
   AND tech_card.attr_2908_ = TRUE /*активная карта*/
   LEFT JOIN registry.object_400_ sprav_mat ON CASE
                                                   WHEN comp.attr_1452_ = 16 THEN comp_structure.attr_3967_
                                                   ELSE tech_card.attr_2381_
                                               END = sprav_mat. ID
   LEFT JOIN registry.object_400_ sprav_sort ON tech_card.attr_1876_ = sprav_sort.ID
   LEFT JOIN registry.object_400_ sprav_tr ON tech_card.attr_1877_ = sprav_tr.ID
   WHERE o.is_deleted <> TRUE
     AND o.ID = '{id_proj}')
SELECT DATA.project_id AS project_id,
            string_agg (DATA.comp_id::text, ', ') AS comp_ids,
            sprav_mat.id mat_id,
            sprav_sort.id sort_id,
            sprav_tr.id tr_id,
            sprav_mat.attr_2976_ AS mat,
            sprav_sort.attr_2976_ AS sort,
            sprav_tr.attr_2976_ AS tr,
            COALESCE (sprav_units.attr_390_, '-') AS units,
            SUM (DATA.quant) AS sum_quant,
            DATA.given_mat AS given_mat
FROM DATA
LEFT JOIN registry.object_400_ sprav_mat ON DATA.mat = sprav_mat.id
LEFT JOIN registry.object_400_ sprav_sort ON DATA.sort = sprav_sort.id
LEFT JOIN registry.object_400_ sprav_tr ON DATA.tr = sprav_tr.ID
LEFT JOIN registry.object_389_ sprav_units ON DATA.units = sprav_units.id
WHERE sprav_mat.id IS NOT NULL
GROUP BY DATA.project_id,
         sprav_mat.id,
         sprav_sort.id,
         sprav_tr.id,
         sprav_units.id,
         DATA.given_mat
ORDER BY sprav_mat.attr_2976_,
         sprav_sort.attr_2976_,
         sprav_tr.attr_2976_