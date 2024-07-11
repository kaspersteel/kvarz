/*несохраняемая с базовой в attr_3185_*/
--SELECT
o.attr_3251_ -
CASE
          WHEN o.attr_3231_ IS FALSE THEN CASE
                    WHEN remnants.attr_2943_ = 6 THEN NULL
                    ELSE COALESCE(
                    SUM( comp_poz_work.attr_2626_
                    ) FILTER (
                        WHERE comp_poz_work.attr_3176_ IS FALSE
                    ) , 0 )
          END
          ELSE CASE
                    WHEN remnants.attr_2943_ = 6 THEN NULL
                    ELSE COALESCE(
                    SUM( comp_poz_work.attr_2626_
                    ) , 0 )
          END
END
--FROM registry.object__ o
--GROUP BY