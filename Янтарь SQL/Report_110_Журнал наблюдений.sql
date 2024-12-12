   SELECT o.attr_319_ AS "id",
          TO_CHAR(o.attr_2490_, 'dd.MM.YY') AS "date",
          hist.attr_4440_ AS "rost",
          log_mor.ad AS "ad_m",
          log_mor.temp AS "t_m",
          log_ev.ad AS "ad",
          log_ev.temp AS "t_ev",
          log_mor.sugar AS "s",
          log_ev.def AS "d",
          log_mor.satur AS "sat_m",
          log_ev.satur AS "sat_ev",
          CASE
                    WHEN log_mor.weight IS NOT NULL THEN CONCAT(
                    log_mor.weight,
                    '/',
                    COALESCE(log_mor.imt::VARCHAR, '-')
                    )
          END AS "w_imt_mor",
          CASE
                    WHEN log_ev.weight IS NOT NULL THEN CONCAT(
                    log_ev.weight,
                    '/',
                    COALESCE(log_ev.imt::VARCHAR, '-')
                    )
          END AS "w_imt_ev",
          log_mor.liquid AS "l",
          log_mor.urine AS "u",
          CASE
                    WHEN log_ev.def = 1 THEN 'да'
                    ELSE 'нет'
          END AS "kak"
     FROM registry.object_316_ o
LEFT JOIN registry.object_303_ hist ON hist.id = o.attr_319_
      AND NOT hist.is_deleted
LEFT JOIN (
             SELECT o1.attr_319_ AS "hist_id",
                    o1.attr_2490_ AS "date",
                    o1.attr_1971_ AS "ad",
                    o1.attr_2988_ AS "temp",
                    o1.attr_2403_ AS "sugar",
                    o1.attr_615_ AS "satur",
                    o1.attr_616_ AS "weight",
                    o1.attr_617_ AS "liquid",
                    o1.attr_618_ AS "urine",
                    o1.attr_4439_ AS "imt"
               FROM registry.object_316_ o1
              WHERE NOT o1.is_deleted
                AND o1.attr_2400_ = 1
          ) log_mor ON log_mor.date = o.attr_2490_
      AND log_mor.hist_id = o.attr_319_
LEFT JOIN (
             SELECT o2.attr_319_ AS "hist_id",
                    o2.attr_2490_ AS "date",
                    o2.attr_1971_ AS "ad",
                    o2.attr_2988_ AS "temp",
                    o2.attr_2790_ AS "def",
                    o2.attr_615_ AS "satur",
                    o2.attr_616_ AS "weight",
                    o2.attr_4439_ AS "imt"
               FROM registry.object_316_ o2
              WHERE NOT o2.is_deleted
                AND o2.attr_2400_ = 2
          ) log_ev ON log_ev.date = o.attr_2490_
      AND log_ev.hist_id = o.attr_319_
    WHERE NOT o.is_deleted
      AND o.attr_319_ = '{id}'
 GROUP BY o.attr_319_,
          o.attr_2490_,
          "rost",
          log_mor.ad,
          log_mor.temp,
          log_mor.sugar,
          log_mor.satur,
          log_mor.weight,
          log_mor.liquid,
          log_mor.urine,
          log_mor.imt,
          log_ev.ad,
          log_ev.temp,
          log_ev.def,
          log_ev.satur,
          log_ev.weight,
          log_ev.imt