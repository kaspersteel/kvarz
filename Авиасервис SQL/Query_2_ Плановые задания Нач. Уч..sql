SELECT 
plans.id AS id_plan,
plans.attr_600_ AS area,
plans.attr_597_, 
plans.attr_620_, 
plans.attr_599_, 
norton_partners.attr_588_ AS n_partner,
nom_dir.attr_88_ AS name_nomen,
nom_dir.attr_81_ AS id_standard,
nom_dir.attr_500_ AS id_typesize,
nom_dir.attr_85_ AS lenght_nomen,
coats.attr_563_ AS coat,
units.attr_192_ AS unit,
plans.attr_613_, 
plans.attr_614_, 
plans.attr_615_, 
plans.attr_616_, 
plans.attr_617_, 
plans.attr_618_, 
plans.attr_619_, 
plans.attr_623_, 
plans.attr_611_,
plans.attr_799_,
CASE WHEN plans.attr_799_ > 0 THEN '<div class="cell-btn scale-btn"><i class="el-icon-circle-plus-outline" style="color: #8b6962ff;"></i></div>' 
	 ELSE '' 
END AS "new_task",
  CASE
    WHEN up_nom_dir.attr_80_ IS NOT NULL THEN
      CASE
        WHEN count_operations > 0 THEN
          CASE
            WHEN count_params > 0 THEN '<div class="cell-icon"><i class="el-icon-tickets" style="color: rgba(117, 206, 0, 1);"></i></div>' 
            ELSE '<div class="cell-icon"><i class="el-icon-odometer" style="color: rgba(212, 160, 23, 1);"></i></div>' 
          END
        ELSE '<div class="cell-icon"><i class="icon4" style="color: rgba(255, 121, 11, 1);"></i></div>' 
      END
    ELSE '<div class="cell-icon"><i class="el-icon-tickets" style="color: rgba(255, 25, 44, 1);"></i></div>' 
  END AS pass_status,
186 AS object_task,
107 AS card_task,
593 AS object_plan,
79 AS card_plan

FROM registry.object_593_ plans
LEFT JOIN registry.object_580_ norton_partners ON norton_partners.id = plans.attr_601_ AND NOT  norton_partners.is_deleted
LEFT JOIN registry.object_75_ nom_dir ON nom_dir.id = plans.attr_604_ AND NOT nom_dir.is_deleted
LEFT JOIN registry.object_75_ up_nom_dir ON up_nom_dir.id = nom_dir.attr_77_ AND not up_nom_dir.is_deleted
LEFT JOIN LATERAL (
  SELECT COUNT(operations.id) AS count_operations
  FROM registry.object_170_ operations
  WHERE operations.attr_171_ = up_nom_dir.attr_80_
    AND not operations.is_deleted
) operations ON TRUE
LEFT JOIN LATERAL (
  SELECT COUNT(params.id) AS count_params
  FROM registry.object_508_ params
  WHERE params.attr_510_ IN (
    SELECT operations.id
    FROM registry.object_170_ operations
    WHERE operations.attr_171_ = up_nom_dir.attr_80_ AND not operations.is_deleted
  )
    AND not params.is_deleted
) params ON TRUE
LEFT JOIN registry.object_70_ coats ON coats.id = nom_dir.attr_87_ AND NOT coats.is_deleted
LEFT JOIN registry.object_191_ units ON units.id = plans.attr_610_ AND NOT units.is_deleted
WHERE NOT plans.is_deleted