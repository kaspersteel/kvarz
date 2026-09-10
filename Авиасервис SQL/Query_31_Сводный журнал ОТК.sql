WITH invp_info AS (
    SELECT DISTINCT
        tab.attr_654_ AS jotk_id,
        i.id AS id,
        i.attr_638_ AS type,
        i.attr_952_ AS num_1c,
        i.attr_961_ AS num_accent,
        trim_scale(COALESCE(tab.attr_955_, 0)) AS amount
    FROM
        registry.object_633_ i
        JOIN registry.object_634_ tab ON tab.attr_640_ = i.id 
            AND NOT tab.is_deleted
    WHERE
        NOT i.is_deleted
)

, invp_agg AS (    
    SELECT 
        jotk_id,
        ARRAY_AGG(id ORDER BY id) FILTER (WHERE type = 1) AS "vysadka_ids",
        ARRAY_AGG(id ORDER BY id) FILTER (WHERE type = 2) AS "thermo_ids",
        ARRAY_AGG(id ORDER BY id) FILTER (WHERE type = 3) AS "pokrytie_ids",
        ARRAY_AGG(id ORDER BY id) FILTER (WHERE type = 4) AS "sklad_d_ids",
        ARRAY_AGG(id ORDER BY id) FILTER (WHERE type = 5) AS "sklad_g_ids",
        ARRAY_AGG(invp_amount ORDER BY id) FILTER (WHERE type = 1) AS "vysadka_amounts",
        ARRAY_AGG(invp_amount ORDER BY id) FILTER (WHERE type = 2) AS "thermo_amounts",
        ARRAY_AGG(invp_amount ORDER BY id) FILTER (WHERE type = 3) AS "pokrytie_amounts",
        ARRAY_AGG(invp_amount ORDER BY id) FILTER (WHERE type = 4) AS "sklad_d_amounts",
        ARRAY_AGG(invp_amount ORDER BY id) FILTER (WHERE type = 5) AS "sklad_g_amounts",
        ARRAY_AGG(CONCAT('№', COALESCE(num_1c, num_accent, 'б/н'), ' - ', amount)) FILTER (WHERE type = 1) AS "vysadka_nn",
        ARRAY_AGG(CONCAT('№', COALESCE(num_1c, num_accent, 'б/н'), ' - ', amount)) FILTER (WHERE type = 2) AS "thermo_nn",
        ARRAY_AGG(CONCAT('№', COALESCE(num_1c, num_accent, 'б/н'), ' - ', amount)) FILTER (WHERE type = 3) AS "pokrytie_nn",
        ARRAY_AGG(CONCAT('№', COALESCE(num_1c, num_accent, 'б/н'), ' - ', amount)) FILTER (WHERE type = 4) AS "sklad_d_nn",
        ARRAY_AGG(CONCAT('№', COALESCE(num_1c, num_accent, 'б/н'), ' - ', amount)) FILTER (WHERE type = 5) AS "sklad_g_nn"
    FROM (
        SELECT
            invp_info.*,
            SUM(invp_info.amount) OVER (PARTITION BY invp_info.id) AS invp_amount
        FROM invp_info
    ) invp_info
    GROUP BY jotk_id
)

, base AS (
SELECT 
  162 AS "jotk_obj",
  51 AS "jotk_card",
  127 AS "jotk_card_create_inv",
  o.id AS "jotk_id",
  o.attr_246_ AS "jotk_date",
  o.attr_485_ AS "jotk_result",
  trim_scale(o.attr_341_) ||' '||dir_units.attr_192_ AS "jotk_quant",
  worktask.attr_1003_ AS assembly_wt_id,
  165 AS "umk_obj",
  31 AS "umk_card",
  umk.id AS "umk_id",
  umk.attr_493_ AS "umk_num",
  CONCAT(umk.attr_493_, '\n (', vid_izd.attr_443_, ' ' || tsz.attr_499_, ' - ' || TRIM_SCALE(COALESCE(plan_serv.attr_1035_, worktask.attr_194_)), ' - ' || std.attr_69_, ')') AS "umk_name",
  umk.attr_893_ AS "umk_status",
  umk.attr_1002_ AS "umk_to_wh",
  (umk.attr_198_ IS NOT NULL )::boolean AS "third-party",
  worktask.attr_448_ AS "area", --участок
  std.id AS "std_id",
  std.attr_69_ AS "std_name",
  tsz.id AS "type_id",
  tsz.attr_499_ AS "type_name",
  COALESCE(plan_serv.attr_1035_, worktask.attr_194_) AS "length",
  techops.id AS "techop_id",
  techops.attr_23_ || CASE WHEN o.attr_793_ THEN ' (H)' ELSE '' END AS "techop_name",
  o.attr_793_ AS vysadka_naladka,
  dir_mech_p.id AS "mp_id",
  dir_mech_p.attr_494_ AS "mp_num",
  dir_thermo_p.attr_309_ AS "tp_num",
  dir_galvano_p.attr_313_ AS "gp_num",
  633 AS "i_obj",
  126 AS "i_card",
  CASE WHEN umk.attr_198_ IS NULL THEN 131 ELSE 152 END AS "i_new_card",
  1 AS "i_new_id",
  invp_agg.vysadka_ids[1] AS "vysadka_id",
  invp_agg.vysadka_amounts[1] AS "vysadka_amount",
  invp_agg.vysadka_nn[1] AS "vysadka_n",
  invp_agg.thermo_ids[1] AS "thermo_id",
  invp_agg.thermo_amounts[1] AS "thermo_amount",
  invp_agg.thermo_nn[1] AS "thermo_n",
  invp_agg.pokrytie_ids[1] AS "pokrytie_id",
  invp_agg.pokrytie_amounts[1] AS "pokrytie_amount",
  invp_agg.pokrytie_nn[1] AS "pokrytie_n",
  invp_agg.sklad_g_ids[1] AS "sklad_g_id",
  invp_agg.sklad_g_amounts[1] AS "sklad_g_amount",
  invp_agg.sklad_g_nn[1] AS "sklad_g_n",
  invp_agg.sklad_d_ids[1] AS "sklad_d_id",
  invp_agg.sklad_d_amounts[1] AS "sklad_d_amount",
  invp_agg.sklad_d_nn[1] AS "sklad_d_n",
  next_to_umk.attr_182_ AS "next_techop",
  
   CASE COALESCE(next_to_umk.attr_182_, 0) 
                 WHEN 5 THEN 2 -- если следующая т/о - на т/о
                 WHEN 8 THEN 3 -- если следующая покрытие - на покрытие (и на склад диспетчера)
                 WHEN 0 THEN CASE -- если дальше нет операций
                                  WHEN worktask.attr_1003_ IS NULL THEN 5 -- на склад ГП
                                  ELSE 4 -- если под сборку - на склад диспетчера
                              END
				 ELSE CASE WHEN to_umk.attr_182_ = 1 -- после высадки
                                THEN 1 -- высадка
                           ELSE 4 -- на склад диспетчера
                       END 
   END AS "inv_type_init",
   
   CASE COALESCE(next_to_umk.attr_182_, 0) 
                 WHEN 5 THEN '2, 4' -- если следующая т/о - на т/о и на склад диспетчера
                 WHEN 8 THEN '3, 4' -- если следующая покрытие - на покрытие и на склад диспетчера
                 WHEN 0 THEN CASE -- если дальше нет операций
                                  WHEN worktask.attr_1003_ IS NULL THEN '5, 4' -- на склад ГП и на склад диспетчера
                                  ELSE '4' -- если под сборку - на склад диспетчера
                              END
				 ELSE CASE WHEN to_umk.attr_182_ = 1 -- после высадки
                                THEN '1' -- высадка
                           ELSE '4' -- на склад диспетчера
                       END 
   END AS "inv_types"
  
FROM
    registry.object_162_ o
    LEFT JOIN registry.object_166_ to_umk ON to_umk.id = o.attr_241_
              AND NOT to_umk.is_deleted
    LEFT JOIN registry.object_22_ techops ON techops.id = to_umk.attr_182_
              AND NOT techops.is_deleted
    LEFT JOIN registry.object_165_ umk ON umk.id = to_umk.attr_176_
              AND NOT umk.is_deleted
    LEFT JOIN registry.object_1026_ plan_serv ON plan_serv.id = umk.attr_198_
              AND NOT plan_serv.is_deleted
    LEFT JOIN registry.object_186_ worktask ON worktask.id = umk.attr_195_
              AND NOT worktask.is_deleted
    LEFT JOIN registry.object_186_ a_worktask ON a_worktask.is_deleted IS NOT TRUE
              AND a_worktask.id = worktask.attr_1003_
    LEFT JOIN registry.object_68_ std ON std.id = COALESCE(plan_serv.attr_1033_, worktask.attr_190_)
              AND NOT std.is_deleted
    LEFT JOIN registry.object_73_ vid_izd ON vid_izd.is_deleted IS NOT TRUE
              AND vid_izd.id = std.attr_436_  
    LEFT JOIN registry.object_498_ tsz ON tsz.id = COALESCE(plan_serv.attr_1034_, worktask.attr_193_)
              AND NOT tsz.is_deleted 
    LEFT JOIN registry.object_191_ dir_units ON dir_units.id = COALESCE(plan_serv.attr_1037_, worktask.attr_810_)
              AND NOT dir_units.is_deleted
    LEFT JOIN registry.object_297_ dir_mech_p ON dir_mech_p.id = o.attr_345_
              AND NOT dir_mech_p.is_deleted
    LEFT JOIN registry.object_298_ dir_thermo_p ON dir_thermo_p.id = o.attr_347_
              AND NOT dir_thermo_p.is_deleted
    LEFT JOIN registry.object_299_ dir_galvano_p ON dir_galvano_p.id = o.attr_349_
              AND NOT dir_galvano_p.is_deleted
    LEFT JOIN invp_agg on invp_agg.jotk_id = o.id
    LEFT JOIN registry.object_166_ next_to_umk ON next_to_umk.attr_176_ = umk.id 
              AND next_to_umk.attr_181_ = (to_umk.attr_181_ + 1)
WHERE NOT o.is_deleted 
      AND o.attr_345_ is not null)

SELECT
    base.*,
    CASE
        WHEN jotk_result = 1 
             AND ((inv_type_init = 1 AND vysadka_naladka IS NOT TRUE AND assembly_wt_id IS NULL ) 
                 OR inv_type_init IN (2, 3, 4, 5)) 
             THEN '<div class="cell-btn scale-btn"><i class="el-icon-circle-plus-outline" style="color: #8b6962ff;"></i></div>'
    END AS "inv_btn"
FROM base
ORDER BY jotk_date DESC, umk_num