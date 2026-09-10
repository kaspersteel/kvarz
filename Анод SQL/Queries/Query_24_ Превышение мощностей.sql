WITH week_power AS (
         SELECT norm_nch.attr_2638_ AS date_start,
            norm_nch.attr_2639_ AS date_end,
                CASE
                    WHEN (sum((table_marsh_card.attr_1443_ * (COALESCE(comp_ord.attr_1896_, 0))::numeric)) FILTER (WHERE ((table_marsh_card.attr_586_ = 39) AND (norm_nch.attr_2639_ >= comp_ord.attr_1548_) AND (norm_nch.attr_2638_ <= comp_ord.attr_1548_))) > norm_nch.attr_2640_) THEN true
                    ELSE false
                END AS overload_cut,
                CASE
                    WHEN (sum((table_marsh_card.attr_1443_ * (COALESCE(comp_ord.attr_1896_, 0))::numeric)) FILTER (WHERE ((table_marsh_card.attr_586_ = 46) AND (norm_nch.attr_2639_ >= comp_ord.attr_1551_) AND (norm_nch.attr_2638_ <= comp_ord.attr_1551_))) > norm_nch.attr_2641_) THEN true
                    ELSE false
                END AS overload_tok1,
                CASE
                    WHEN (sum((table_marsh_card.attr_1443_ * (COALESCE(comp_ord.attr_1896_, 0))::numeric)) FILTER (WHERE ((table_marsh_card.attr_586_ = ANY (ARRAY[33, 40])) AND (norm_nch.attr_2639_ >= comp_ord.attr_1554_) AND (norm_nch.attr_2638_ <= comp_ord.attr_1554_))) > norm_nch.attr_2642_) THEN true
                    ELSE false
                END AS overload_tok,
                CASE
                    WHEN (sum((table_marsh_card.attr_1443_ * (COALESCE(comp_ord.attr_1896_, 0))::numeric)) FILTER (WHERE ((table_marsh_card.attr_586_ = ANY (ARRAY[42, 43, 45, 59, 60])) AND (norm_nch.attr_2639_ >= comp_ord.attr_1557_) AND (norm_nch.attr_2638_ <= comp_ord.attr_1557_))) > norm_nch.attr_2643_) THEN true
                    ELSE false
                END AS overload_rast,
                CASE
                    WHEN (sum((table_marsh_card.attr_1443_ * (COALESCE(comp_ord.attr_1896_, 0))::numeric)) FILTER (WHERE ((table_marsh_card.attr_586_ = ANY (ARRAY[51, 63])) AND (norm_nch.attr_2639_ >= comp_ord.attr_1560_) AND (norm_nch.attr_2638_ <= comp_ord.attr_1560_))) > norm_nch.attr_2644_) THEN true
                    ELSE false
                END AS overload_shlif,
                CASE
                    WHEN (sum((table_marsh_card.attr_1443_ * (COALESCE(comp_ord.attr_1896_, 0))::numeric)) FILTER (WHERE ((table_marsh_card.attr_586_ = 55) AND (norm_nch.attr_2639_ >= comp_ord.attr_1563_) AND (norm_nch.attr_2638_ <= comp_ord.attr_1563_))) > norm_nch.attr_2645_) THEN true
                    ELSE false
                END AS overload_sles
           FROM ((((registry.object_2637_ norm_nch
             LEFT JOIN registry.object_1409_ comp_ord ON (((((norm_nch.attr_2639_ >= comp_ord.attr_1548_) AND (norm_nch.attr_2638_ <= comp_ord.attr_1548_)) OR ((norm_nch.attr_2639_ >= comp_ord.attr_1551_) AND (norm_nch.attr_2638_ <= comp_ord.attr_1551_)) OR ((norm_nch.attr_2639_ >= comp_ord.attr_1554_) AND (norm_nch.attr_2638_ <= comp_ord.attr_1554_)) OR ((norm_nch.attr_2639_ >= comp_ord.attr_1557_) AND (norm_nch.attr_2638_ <= comp_ord.attr_1557_)) OR ((norm_nch.attr_2639_ >= comp_ord.attr_1560_) AND (norm_nch.attr_2638_ <= comp_ord.attr_1560_)) OR ((norm_nch.attr_2639_ >= comp_ord.attr_1563_) AND (norm_nch.attr_2638_ <= comp_ord.attr_1563_))) AND ((comp_ord.attr_1421_ IS NULL) OR (comp_ord.attr_1421_ <> 1)) AND (comp_ord.attr_1650_ IS NOT NULL) AND (comp_ord.attr_2042_ = 2))))
             LEFT JOIN registry.object_301_ nom_in_comp ON (((comp_ord.attr_1458_ = nom_in_comp.id) AND (nom_in_comp.is_deleted IS FALSE))))
             LEFT JOIN registry.object_519_ tech_card ON (((
                CASE
                    WHEN ((comp_ord.attr_1463_ = 2) OR (comp_ord.attr_1421_ = ANY (ARRAY[6, 4]))) THEN tech_card.attr_1466_
                    ELSE tech_card.attr_520_
                END =
                CASE
                    WHEN ((comp_ord.attr_1463_ = 2) OR (comp_ord.attr_1421_ = ANY (ARRAY[6, 4]))) THEN comp_ord.id
                    ELSE nom_in_comp.id
 END) AND (tech_card.is_deleted IS FALSE) AND (tech_card.attr_2908_ IS TRUE))))
             LEFT JOIN registry.object_527_ table_marsh_card ON (((table_marsh_card.attr_538_ = tech_card.id) AND (table_marsh_card.is_deleted IS FALSE))))
          WHERE (norm_nch.is_deleted IS FALSE)
          GROUP BY norm_nch.id
          ORDER BY norm_nch.id DESC
  )
 SELECT o.id AS comp_id,
    week_cut.overload_cut,
    week_tok1.overload_tok1,
    week_tok.overload_tok,
    week_rast.overload_rast,
    week_shlif.overload_shlif,
    week_sles.overload_sles
   FROM ((((((registry.object_1409_ o
     LEFT JOIN week_power week_cut ON (((week_cut.date_end >= o.attr_1548_) AND (week_cut.date_start <= o.attr_1548_))))
     LEFT JOIN week_power week_tok1 ON (((week_tok1.date_end >= o.attr_1551_) AND (week_tok1.date_start <= o.attr_1551_))))
     LEFT JOIN week_power week_tok ON (((week_tok.date_end >= o.attr_1554_) AND (week_tok.date_start <= o.attr_1554_))))
     LEFT JOIN week_power week_rast ON (((week_rast.date_end >= o.attr_1557_) AND (week_rast.date_start <= o.attr_1557_))))
     LEFT JOIN week_power week_shlif ON (((week_shlif.date_end >= o.attr_1560_) AND (week_shlif.date_start <= o.attr_1560_))))
     LEFT JOIN week_power week_sles ON (((week_sles.date_end >= o.attr_1563_) AND (week_sles.date_start <= o.attr_1563_))))
  WHERE ((o.is_deleted IS FALSE) AND (o.attr_2042_ = 2))
  ORDER BY o.id DESC              