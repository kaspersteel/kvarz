CASE WHEN o.attr_2626_ is NOT NULL THEN o.attr_2626_ ELSE
CASE
          WHEN tech_card_prod.attr_2554_ IS TRUE THEN (
          tech_card_prod.attr_1879_ * CEILING (
          comp_order.attr_1896_::NUMERIC(5, 2) / tech_card_prod.attr_2907_::NUMERIC(5, 2)
          )
          ) + (
          COALESCE(tech_card_prod.attr_2884_, 0) * CEILING (
          comp_order.attr_1896_::NUMERIC(5, 2) / tech_card_prod.attr_2555_::NUMERIC(5, 2)
          )
          )
          WHEN tech_card_prod.attr_2554_ IS FALSE THEN comp_order.attr_1896_ * tech_card_prod.attr_1879_
END END
