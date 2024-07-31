/*несохраняемая с базовой в attr_3185_*/
--SELECT
remnants.attr_3128_ -
CASE
          WHEN o.attr_3231_ IS FALSE THEN CASE
                    WHEN remnants.attr_2943_ = 6 THEN COALESCE(
                    SUM( comp_poz_work.attr_2103_ 
                    ) FILTER (
                        WHERE comp_poz_work.attr_3176_ IS FALSE
                    ) , 0 )
                    ELSE COALESCE(
                    SUM( comp_poz_work.attr_2108_
                    ) FILTER (
                        WHERE comp_poz_work.attr_3176_ IS FALSE
                    ) , 0 )
          END
          ELSE CASE
                    WHEN remnants.attr_2943_ = 6 THEN COALESCE(
                    SUM( comp_poz_work.attr_2103_
                    ), 0 )
                    ELSE COALESCE(
                    SUM( comp_poz_work.attr_2108_ 
                    ) , 0 )
          END
END
--FROM registry.object__ o
--GROUP BY