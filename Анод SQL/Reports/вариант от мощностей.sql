SELECT
o.id AS comp_id
, norm_nch.overpower_cut
, norm_nch.overpower_tok1
, norm_nch.overpower_tok
, norm_nch.overpower_rast
, norm_nch.overpower_shlif
, norm_nch.overpower_sles
FROM
			registry.object_1409_ o
			LEFT JOIN (
SELECT
	norm_nch.*
		, CASE WHEN sum(table_marsh_card.attr_1443_ * COALESCE ( comp_ord.attr_1896_, 0 )) FILTER (WHERE table_marsh_card.attr_586_ in (39)) > norm_nch.attr_2640_ THEN 1 ELSE 0 END AS overpower_cut
		, CASE WHEN sum(table_marsh_card.attr_1443_ * COALESCE ( comp_ord.attr_1896_, 0 )) FILTER (WHERE table_marsh_card.attr_586_ in (46)) > norm_nch.attr_2641_ THEN 1 ELSE 0 END AS overpower_tok1
		, CASE WHEN sum(table_marsh_card.attr_1443_ * COALESCE ( comp_ord.attr_1896_, 0 )) FILTER (WHERE table_marsh_card.attr_586_ in (33, 40)) > norm_nch.attr_2642_ THEN 1 ELSE 0 END AS overpower_tok
		, CASE WHEN sum(table_marsh_card.attr_1443_ * COALESCE ( comp_ord.attr_1896_, 0 )) FILTER (WHERE table_marsh_card.attr_586_ in (42, 43, 45, 59, 60)) > norm_nch.attr_2643_ THEN 1 ELSE 0 END AS overpower_rast
		, CASE WHEN sum(table_marsh_card.attr_1443_ * COALESCE ( comp_ord.attr_1896_, 0 )) FILTER (WHERE table_marsh_card.attr_586_ in (51, 63)) > norm_nch.attr_2644_ THEN 1 ELSE 0 END AS overpower_shlif
		, CASE WHEN sum(table_marsh_card.attr_1443_ * COALESCE ( comp_ord.attr_1896_, 0 )) FILTER (WHERE table_marsh_card.attr_586_ in (55)) > norm_nch.attr_2645_ THEN 1 ELSE 0 END AS overpower_sles
FROM
	registry.object_2637_ norm_nch 
	/* дата токарной, а надо все компоненты в периоде

	LEFT JOIN registry.object_1409_ comp_ord ON norm_nch.attr_2639_ >= comp_ord.attr_1554_
	AND norm_nch.attr_2638_ <= comp_ord.attr_1554_*/
                        AND (comp_ord.attr_1421_ IS NULL OR comp_ord.attr_1421_ != 1 ) 
			AND comp_ord.attr_1650_ IS NOT NULL 
			AND comp_ord.attr_2042_ = 2
	LEFT JOIN registry.object_301_ nom_in_comp ON comp_ord.attr_1458_ = nom_in_comp.ID
	AND nom_in_comp.is_deleted IS FALSE
	LEFT JOIN registry.object_519_ tech_card ON (
		CASE
			WHEN comp_ord.attr_1463_ = 2
			OR comp_ord.attr_1421_ IN (6, 4) THEN tech_card.attr_1466_
			ELSE tech_card.attr_520_
		END = CASE
			WHEN comp_ord.attr_1463_ = 2
			OR comp_ord.attr_1421_ IN (6, 4) THEN comp_ord.ID
			ELSE nom_in_comp.ID
		END
	) /*выбираем карту из компонента, если его изменили или создали не из ном. ед.*/
	AND tech_card.is_deleted IS FALSE
	AND tech_card.attr_2908_ IS TRUE /*активная карта*/
	LEFT JOIN registry.object_527_ table_marsh_card ON table_marsh_card.attr_538_ = tech_card.ID
	AND table_marsh_card.is_deleted IS FALSE
WHERE
	norm_nch.is_deleted IS FALSE
GROUP BY
	norm_nch.id
) norm_nch ON norm_nch.attr_2639_ >= o.attr_1554_ 	AND norm_nch.attr_2638_ <= o.attr_1554_ 
		WHERE
			o.is_deleted <> TRUE 
AND o.attr_2042_ = 2
ORDER BY o.id desc