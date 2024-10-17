     WITH base AS (
             SELECT fio_pac.attr_1985_ AS fio,
                    PROCEDURES.attr_695_ AS name_proc,
                    plan.id AS id_proc,
                    nom_cat.attr_444_ AS nom,
                    o.attr_4005_ AS hist_id,
                    o.attr_4032_ AS date_rasp,
                    /*создается поле с массивами временных отрезков*/
                    CASE plan.id
                              WHEN o.attr_4008_ THEN o.attr_4007_
                              WHEN o.attr_4010_ THEN o.attr_4009_
                              WHEN o.attr_4012_ THEN o.attr_4011_
                              WHEN o.attr_4014_ THEN o.attr_4013_
                              WHEN o.attr_4016_ THEN o.attr_4015_
                              WHEN o.attr_4018_ THEN o.attr_4017_
                              WHEN o.attr_4020_ THEN o.attr_4019_
                              WHEN o.attr_4022_ THEN o.attr_4021_
                              WHEN o.attr_4024_ THEN o.attr_4023_
                              WHEN o.attr_4026_ THEN o.attr_4025_
                              WHEN o.attr_4028_ THEN o.attr_4027_
                              WHEN o.attr_4163_ THEN o.attr_4162_
                              WHEN o.attr_4166_ THEN o.attr_4165_
                              WHEN o.attr_4169_ THEN o.attr_4168_
                              WHEN o.attr_4252_ THEN o.attr_4251_
                              WHEN o.attr_4444_ THEN o.attr_4443_
                              WHEN o.attr_4447_ THEN o.attr_4446_
                              WHEN o.attr_4456_ THEN o.attr_4455_
                              WHEN o.attr_4459_ THEN o.attr_4458_
                    END AS array_time
               FROM registry.object_4000_ o
          LEFT JOIN registry.object_783_ plan ON o.attr_4005_ = plan.attr_827_
                AND NOT plan.is_deleted
          LEFT JOIN registry.object_694_ PROCEDURES ON plan.attr_784_ = PROCEDURES.id
                AND NOT PROCEDURES.is_deleted
          LEFT JOIN registry.object_45_ fio_pac ON o.attr_4004_ = fio_pac.id
                AND NOT fio_pac.is_deleted
          LEFT JOIN registry.object_127_ nom_cat ON o.attr_4006_ = nom_cat.id
                AND NOT nom_cat.is_deleted
              WHERE NOT o.is_deleted
                AND o.attr_4005_ = '{superid}'
                AND o.attr_4032_ = COALESCE(
                    (
                    CASE
                              WHEN '{date_rasp}' = '' THEN NULL
                              ELSE '{date_rasp}'::TEXT
                    END
                    ),
                    CURRENT_DATE::TEXT
                    )::date
          )
   SELECT base.*,
          /*создается поле с временными отрезками путем обработки массива*/
          CONCAT(
          CASE
                    WHEN base.array_time @> ARRAY[2, 3]
                          AND base.array_time @> ARRAY[4] <> TRUE THEN CONCAT('08:30 - 09:10', '\n')
                              WHEN base.array_time @> ARRAY[3, 4]
                          AND base.array_time @> ARRAY[2] <> TRUE THEN CONCAT('08:50 - 09:30', '\n')
                              ELSE CONCAT(
                              CASE
                                        WHEN base.array_time @> ARRAY[2] THEN CONCAT('08:30 - 08:50', '\n')
                              END,
                              CASE
                                        WHEN base.array_time @> ARRAY[3] THEN CONCAT('08:50 - 09:10', '\n')
                              END,
                              CASE
                                        WHEN base.array_time @> ARRAY[4] THEN CONCAT('09:10 - 09:30', '\n')
                              END
                              )
          END,
          CASE
                    WHEN base.array_time @> ARRAY[5, 6] THEN CONCAT('09:40 - 10:20', '\n')
                    WHEN base.array_time @> ARRAY[5]
                          AND base.array_time @> ARRAY[6] <> TRUE THEN CONCAT('09:40 - 10:00', '\n')
                              WHEN base.array_time @> ARRAY[6]
                          AND base.array_time @> ARRAY[5] <> TRUE THEN CONCAT('10:00 - 10:20', '\n')
          END,
          CASE
                    WHEN base.array_time @> ARRAY[7, 8] THEN CONCAT('10:30 - 11:10', '\n')
                    WHEN base.array_time @> ARRAY[7]
                          AND base.array_time @> ARRAY[8] <> TRUE THEN CONCAT('10:30 - 10:50', '\n')
                              WHEN base.array_time @> ARRAY[8]
                          AND base.array_time @> ARRAY[7] <> TRUE THEN CONCAT('10:50 - 11:10', '\n')
          END,
          CASE
                    WHEN base.array_time @> ARRAY[9, 10] THEN CONCAT('11:20 - 12:00', '\n')
                    WHEN base.array_time @> ARRAY[9]
                          AND base.array_time @> ARRAY[10] <> TRUE THEN CONCAT('11:20 - 11:40', '\n')
                              WHEN base.array_time @> ARRAY[10]
                          AND base.array_time @> ARRAY[9] <> TRUE THEN CONCAT('11:40 - 12:00', '\n')
          END,
          CASE
                    WHEN base.array_time @> ARRAY[11, 12] THEN CONCAT('13:00 - 13:40', '\n')
                    WHEN base.array_time @> ARRAY[11]
                          AND base.array_time @> ARRAY[12] <> TRUE THEN CONCAT('13:00 - 13:20', '\n')
                              WHEN base.array_time @> ARRAY[12]
                          AND base.array_time @> ARRAY[11] <> TRUE THEN CONCAT('13:20 - 13:40', '\n')
          END,
          CASE
                    WHEN base.array_time @> ARRAY[13, 14] THEN CONCAT('13:50 - 14:30', '\n')
                    WHEN base.array_time @> ARRAY[13]
                          AND base.array_time @> ARRAY[14] <> TRUE THEN CONCAT('13:50 - 14:10', '\n')
                              WHEN base.array_time @> ARRAY[14]
                          AND base.array_time @> ARRAY[13] <> TRUE THEN CONCAT('14:10 - 14:30', '\n')
          END,
          CASE
                    WHEN base.array_time @> ARRAY[15, 16] THEN CONCAT('14:40 - 15:20', '\n')
                    WHEN base.array_time @> ARRAY[15]
                          AND base.array_time @> ARRAY[16] <> TRUE THEN CONCAT('14:40 - 15:00', '\n')
                              WHEN base.array_time @> ARRAY[16]
                          AND base.array_time @> ARRAY[15] <> TRUE THEN CONCAT('15:00 - 15:20', '\n')
          END,
          CASE
                    WHEN base.array_time @> ARRAY[17, 18] THEN CONCAT('15:30 - 16:10', '\n')
                    WHEN base.array_time @> ARRAY[17]
                          AND base.array_time @> ARRAY[18] <> TRUE THEN CONCAT('15:30 - 15:50', '\n')
                              WHEN base.array_time @> ARRAY[18]
                          AND base.array_time @> ARRAY[17] <> TRUE THEN CONCAT('15:50 - 16:10', '\n')
          END,
          CASE
                    WHEN base.array_time @> ARRAY[19, 20] THEN CONCAT('16:20 - 17:00', '\n')
                    WHEN base.array_time @> ARRAY[19]
                          AND base.array_time @> ARRAY[20] <> TRUE THEN CONCAT('16:20 - 16:40', '\n')
                              WHEN base.array_time @> ARRAY[20]
                          AND base.array_time @> ARRAY[19] <> TRUE THEN CONCAT('16:40 - 17:00', '\n')
          END,
          CASE
                    WHEN base.array_time @> ARRAY[21, 22] THEN CONCAT('17:00 - 17:40', '\n')
                    WHEN base.array_time @> ARRAY[21]
                          AND base.array_time @> ARRAY[22] <> TRUE THEN CONCAT('17:00 - 17:20', '\n')
                              WHEN base.array_time @> ARRAY[22]
                          AND base.array_time @> ARRAY[21] <> TRUE THEN CONCAT('17:20 - 17:40', '\n')
          END,
          CASE
                    WHEN base.array_time @> ARRAY[23, 24] THEN CONCAT('17:40 - 18:20', '\n')
                    WHEN base.array_time @> ARRAY[23]
                          AND base.array_time @> ARRAY[24] <> TRUE THEN CONCAT('17:40 - 18:00', '\n')
                              WHEN base.array_time @> ARRAY[24]
                          AND base.array_time @> ARRAY[23] <> TRUE THEN CONCAT('18:00 - 18:20', '\n')
          END,
          CASE
                    WHEN base.array_time @> ARRAY[25, 26] THEN CONCAT('18:20 - 19:00', '\n')
                    WHEN base.array_time @> ARRAY[25]
                          AND base.array_time @> ARRAY[26] <> TRUE THEN CONCAT('18:20 - 18:40', '\n')
                              WHEN base.array_time @> ARRAY[26]
                          AND base.array_time @> ARRAY[25] <> TRUE THEN CONCAT('18:40 - 19:00', '\n')
          END
          ) AS time_proc
     FROM base