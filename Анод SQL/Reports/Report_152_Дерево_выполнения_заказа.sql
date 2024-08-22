   SELECT DISTINCT o.id
        , o.attr_607_ AS number_order
        , project.id AS project_id
        , components.id AS components_id
        , components.attr_1414_ AS parent_id
        , project.attr_1574_ AS name_position
        , CASE
                    WHEN components.attr_1463_ = 1 THEN components.attr_1413_
                    ELSE components.attr_1839_
          END NAME
        , CASE
                    WHEN components.attr_1463_ = 1 THEN components.attr_1410_
                    ELSE components.attr_1518_
          END designation
        , type_operation.attr_547_ AS type_operation
        , pv.attr_3207_ AS plan_count
        , table_pv.attr_3208_ AS n_step
        , COALESCE((table_pv.attr_3373_ * pv.attr_3207_), 0) AS norma_nch
        , COALESCE((table_pv.attr_3373_ * table_pv.attr_2152_), 0) AS done_nch
        , CASE
                    WHEN COALESCE((table_pv.attr_3373_ * pv.attr_3207_), 0) > COALESCE((table_pv.attr_3373_ * table_pv.attr_2152_), 0) THEN COALESCE((table_pv.attr_3373_ * pv.attr_3207_), 0) - COALESCE((table_pv.attr_3373_ * table_pv.attr_2152_), 0)
                    ELSE 0
          END AS duty_nch
     FROM registry.object_606_ o
LEFT JOIN registry.object_1227_ project ON o.id = project.attr_1923_
      AND project.is_deleted <> TRUE
LEFT JOIN registry.object_1409_ components ON project.id = components.attr_1423_
      AND components.is_deleted <> TRUE
LEFT JOIN registry.object_2137_ pv ON pv.attr_2632_ = components.attr_1482_
      AND components.attr_1414_::INTEGER = ANY (pv.attr_4033_)
      AND pv.attr_3207_ > 0
LEFT JOIN registry.object_2138_ table_pv ON table_pv.attr_2148_ = pv.id
      AND table_pv.is_deleted <> TRUE
LEFT JOIN registry.object_545_ type_operation ON table_pv.attr_2149_ = type_operation.id
      AND type_operation.is_deleted <> TRUE
LEFT JOIN registry.object_3273_ resolutions ON resolutions.attr_3277_ = table_pv.id
      AND resolutions.is_deleted <> TRUE
    WHERE o.is_deleted <> TRUE
      AND o.id = '{superid}'
      AND components.attr_2042_ = 2
      AND components.attr_1896_ <> 0
      AND table_pv.attr_2149_ != 52