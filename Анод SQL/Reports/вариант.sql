SELECT-->>
o.id,
norm_nch.id AS norm_nch_id
/*CASE
		
		WHEN SUM (
			(
			SELECT SUM
				( table_marsh_card.attr_1443_ ) 
			FROM
				registry.object_527_ table_marsh_card 
			WHERE
				table_marsh_card.is_deleted <> TRUE 
				AND table_marsh_card.attr_586_ IN (33, 40)
				AND table_marsh_card.attr_538_ = marsh_card.ID 
			GROUP BY
				table_marsh_card.attr_538_ 
			) * COALESCE ( o.attr_1896_, 0 ) 
			) > norm_nch.attr_2642_ THEN
			1 ELSE 0 
		END */
		, sum(table_marsh_card.attr_1443_) FILTER (WHERE table_marsh_card.attr_586_ in (39)) OVER (PARTITION BY norm_nch.id) AS sum_norm_cut
		, sum(table_marsh_card.attr_1443_) FILTER (WHERE table_marsh_card.attr_586_ in (46)) OVER (PARTITION BY norm_nch.id) AS sum_norm_tok1
		, sum(table_marsh_card.attr_1443_) FILTER (WHERE table_marsh_card.attr_586_ in (33, 40)) OVER (PARTITION BY norm_nch.id) AS sum_norm_tok
		, sum(table_marsh_card.attr_1443_) FILTER (WHERE table_marsh_card.attr_586_ in (42, 43, 45, 59, 60)) OVER (PARTITION BY norm_nch.id) AS sum_norm_rast
		, sum(table_marsh_card.attr_1443_) FILTER (WHERE table_marsh_card.attr_586_ in (51, 63)) OVER (PARTITION BY norm_nch.id) AS sum_norm_shlif
		, sum(table_marsh_card.attr_1443_) FILTER (WHERE table_marsh_card.attr_586_ in (55)) OVER (PARTITION BY norm_nch.id) AS sum_norm_sles
		FROM
			registry.object_1409_ o -->>
			LEFT JOIN registry.object_301_ nomenclature ON o.attr_1458_ = nomenclature.ID 
			AND nomenclature.is_deleted <> TRUE 
			LEFT JOIN registry.object_519_ marsh_card ON marsh_card.attr_520_ = nomenclature.ID 
			AND marsh_card.is_deleted <> TRUE 
			AND marsh_card.attr_2908_	IS TRUE 
			LEFT JOIN registry.object_527_ table_marsh_card ON table_marsh_card.attr_538_ = marsh_card.ID 
			AND table_marsh_card.is_deleted IS FALSE 
			LEFT JOIN registry.object_2637_ norm_nch ON norm_nch.attr_2639_ >= o.attr_1554_ 
			AND norm_nch.attr_2638_ <= o.attr_1554_ 
			AND norm_nch.is_deleted <> TRUE 
		WHERE
			o.is_deleted <> TRUE 
			AND ( o.attr_1421_ IS NULL OR o.attr_1421_ != 1 ) 
			AND o.attr_1650_ IS NOT NULL 
			AND o.attr_2042_ = 2
			AND o.attr_1423_ = 2019
			
		GROUP BY-->>
	norm_nch.id--, table_marsh_card.attr_1443_, table_marsh_card.attr_586_
	, o.id, nomenclature.id, marsh_card.id, table_marsh_card.id