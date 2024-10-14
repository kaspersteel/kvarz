   SELECT head_nom.attr_376_ AS designation_head,
          head_nom.attr_362_ AS denomination_head,
          child_nom.attr_376_ AS designation,
          child_nom.attr_362_ AS denomination,
          types_nom.attr_365_ AS type_child,
          sprav_mat.attr_401_ AS name_mat,
          CONCAT(
          sprav_mat.attr_401_,
          ' ',
          sprav_sort.attr_401_,
          ' ',
          sprav_tr.attr_401_
          ) AS name_blank,
          form.attr_430_ AS form_blank,
          /*D*/
          tech_card.attr_1873_ AS DIAMETER,
          /*d*/
          tech_card.attr_3220_ AS diameter_in,
          /*S*/
          tech_card.attr_1874_ AS thickness,
          /*B*/
          tech_card.attr_1875_ AS WIDTH,
          /*L*/
          tech_card.attr_1879_ AS lenght,
          tech_card.attr_3271_ AS mass,
          tech_card.attr_2907_ AS detail_in_blank,
          CONCAT(
          tech_card.attr_1879_::INT,
          '*N',
          CASE
                    WHEN tech_card.attr_2884_ > 0 THEN CONCAT('+', tech_card.attr_2884_::INT)
                    ELSE ''
          END,
          ', maxN=',
          tech_card.attr_2555_::INT
          ) AS formula_blank
     FROM registry.object_301_ head_nom
LEFT JOIN registry.object_369_ tree ON tree.attr_374_ = head_nom.ID
      AND NOT tree.is_deleted
LEFT JOIN registry.object_301_ child_nom ON child_nom.id = tree.attr_370_
      AND NOT child_nom.is_deleted
LEFT JOIN registry.object_364_ types_nom ON types_nom.id = child_nom.attr_363_
      AND NOT types_nom.is_deleted
LEFT JOIN registry.object_519_ tech_card ON tech_card.attr_520_ = child_nom.ID
      AND NOT tech_card.is_deleted
      AND tech_card.attr_2908_
LEFT JOIN registry.object_426_ form ON tech_card.attr_1878_ = form.ID
      AND NOT form.is_deleted
LEFT JOIN registry.object_400_ sprav_mat ON tech_card.attr_2381_ = sprav_mat.ID
      AND NOT sprav_mat.is_deleted
LEFT JOIN registry.object_400_ sprav_sort ON tech_card.attr_1876_ = sprav_sort.ID
      AND NOT sprav_sort.is_deleted
LEFT JOIN registry.object_400_ sprav_tr ON tech_card.attr_1877_ = sprav_tr.ID
      AND NOT sprav_tr.is_deleted
    WHERE NOT head_nom.is_deleted
      AND head_nom.id = {id}::int
      AND sprav_mat.id IS NOT NULL
 ORDER BY 1, 5, 3