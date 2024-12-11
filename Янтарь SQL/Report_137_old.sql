   SELECT CONCAT(
          CASE
                    WHEN o.attr_4007_ && ARRAY[1] THEN NULL
                    ELSE CONCAT(
                    CASE
                              WHEN o.attr_4007_ @> ARRAY[2, 3]
                                    AND o.attr_4007_ @> ARRAY[4] <> TRUE THEN '08:30 - 09:10 '
                                        WHEN o.attr_4007_ @> ARRAY[3, 4]
                                    AND o.attr_4007_ @> ARRAY[2] <> TRUE THEN '08:50 - 09:30 '
                                        ELSE CONCAT(
                                        CASE
                                                  WHEN o.attr_4007_ @> ARRAY[2] THEN '08:30 - 08:50 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4007_ @> ARRAY[3] THEN '08:50 - 09:10 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4007_ @> ARRAY[4] THEN '09:10 - 09:30 '
                                                  ELSE NULL
                                        END
                                        )
                    END
                  , CASE
                              WHEN o.attr_4007_ @> ARRAY[5, 6] THEN '09:40-10:20 '
                              WHEN o.attr_4007_ @> ARRAY[5]
                                    AND o.attr_4007_ @> ARRAY[6] <> TRUE THEN '09:40 - 10:00 '
                                        WHEN o.attr_4007_ @> ARRAY[6]
                                    AND o.attr_4007_ @> ARRAY[5] <> TRUE THEN '10:00 - 10:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4007_ @> ARRAY[7, 8] THEN '10:30 - 11:10 '
                              WHEN o.attr_4007_ @> ARRAY[7]
                                    AND o.attr_4007_ @> ARRAY[8] <> TRUE THEN '10:30 - 10:50 '
                                        WHEN o.attr_4007_ @> ARRAY[8]
                                    AND o.attr_4007_ @> ARRAY[7] <> TRUE THEN '10:50 - 11:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4007_ @> ARRAY[9, 10] THEN '11:20 - 12:00 '
                              WHEN o.attr_4007_ @> ARRAY[9]
                                    AND o.attr_4007_ @> ARRAY[10] <> TRUE THEN '11:20 - 11:40 '
                                        WHEN o.attr_4007_ @> ARRAY[10]
                                    AND o.attr_4007_ @> ARRAY[9] <> TRUE THEN '11:40 - 12:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4007_ @> ARRAY[11, 12] THEN '13:00 - 13:40 '
                              WHEN o.attr_4007_ @> ARRAY[11]
                                    AND o.attr_4007_ @> ARRAY[12] <> TRUE THEN '13:00 - 13:20 '
                                        WHEN o.attr_4007_ @> ARRAY[12]
                                    AND o.attr_4007_ @> ARRAY[11] <> TRUE THEN '13:20 - 13:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4007_ @> ARRAY[13, 14] THEN '13:50 - 14:30 '
                              WHEN o.attr_4007_ @> ARRAY[13]
                                    AND o.attr_4007_ @> ARRAY[14] <> TRUE THEN '13:50 - 14:10 '
                                        WHEN o.attr_4007_ @> ARRAY[14]
                                    AND o.attr_4007_ @> ARRAY[13] <> TRUE THEN '14:10 - 14:30 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4007_ @> ARRAY[15, 16] THEN '14:40 - 15:20 '
                              WHEN o.attr_4007_ @> ARRAY[15]
                                    AND o.attr_4007_ @> ARRAY[16] <> TRUE THEN '14:40 - 15:00 '
                                        WHEN o.attr_4007_ @> ARRAY[16]
                                    AND o.attr_4007_ @> ARRAY[15] <> TRUE THEN '15:00 - 15:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4007_ @> ARRAY[17, 18] THEN '15:30 - 16:10 '
                              WHEN o.attr_4007_ @> ARRAY[17]
                                    AND o.attr_4007_ @> ARRAY[18] <> TRUE THEN '15:30 - 15:50 '
                                        WHEN o.attr_4007_ @> ARRAY[18]
                                    AND o.attr_4007_ @> ARRAY[17] <> TRUE THEN '15:50 - 16:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4007_ @> ARRAY[19, 20] THEN '16:20 - 17:00 '
                              WHEN o.attr_4007_ @> ARRAY[19]
                                    AND o.attr_4007_ @> ARRAY[20] <> TRUE THEN '16:20 - 16:40 '
                                        WHEN o.attr_4007_ @> ARRAY[20]
                                    AND o.attr_4007_ @> ARRAY[19] <> TRUE THEN '16:40 - 17:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4007_ @> ARRAY[21, 22] THEN '17:00 - 17:40 '
                              WHEN o.attr_4007_ @> ARRAY[21]
                                    AND o.attr_4007_ @> ARRAY[22] <> TRUE THEN '17:00 - 17:20 '
                                        WHEN o.attr_4007_ @> ARRAY[22]
                                    AND o.attr_4007_ @> ARRAY[21] <> TRUE THEN '17:20 - 17:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4007_ @> ARRAY[23, 24] THEN '17:40 - 18:20 '
                              WHEN o.attr_4007_ @> ARRAY[23]
                                    AND o.attr_4007_ @> ARRAY[24] <> TRUE THEN '17:40 - 18:00 '
                                        WHEN o.attr_4007_ @> ARRAY[24]
                                    AND o.attr_4007_ @> ARRAY[23] <> TRUE THEN '18:00 - 18:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4007_ @> ARRAY[25, 26] THEN '18:20 - 19:00 '
                              WHEN o.attr_4007_ @> ARRAY[25]
                                    AND o.attr_4007_ @> ARRAY[26] <> TRUE THEN '18:20 - 18:40 '
                                        WHEN o.attr_4007_ @> ARRAY[26]
                                    AND o.attr_4007_ @> ARRAY[25] <> TRUE THEN '18:40 - 19:00 '
                                        ELSE NULL
                    END
                    )
          END
        , o.attr_4062_
          ) AS lfk1
        , CONCAT(
          CASE
                    WHEN o.attr_4009_ && ARRAY[1] THEN NULL
                    ELSE CONCAT(
                    CASE
                              WHEN o.attr_4009_ @> ARRAY[2, 3]
                                    AND o.attr_4009_ @> ARRAY[4] <> TRUE THEN '08:30 - 09:10 '
                                        WHEN o.attr_4009_ @> ARRAY[3, 4]
                                    AND o.attr_4009_ @> ARRAY[2] <> TRUE THEN '08:50 - 09:30 '
                                        ELSE CONCAT(
                                        CASE
                                                  WHEN o.attr_4009_ @> ARRAY[2] THEN '08:30 - 08:50 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4009_ @> ARRAY[3] THEN '08:50 - 09:10 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4009_ @> ARRAY[4] THEN '09:10 - 09:30 '
                                                  ELSE NULL
                                        END
                                        )
                    END
                  , CASE
                              WHEN o.attr_4009_ @> ARRAY[5, 6] THEN '09:40-10:20 '
                              WHEN o.attr_4009_ @> ARRAY[5]
                                    AND o.attr_4009_ @> ARRAY[6] <> TRUE THEN '09:40 - 10:00 '
                                        WHEN o.attr_4009_ @> ARRAY[6]
                                    AND o.attr_4009_ @> ARRAY[5] <> TRUE THEN '10:00 - 10:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4009_ @> ARRAY[7, 8] THEN '10:30 - 11:10 '
                              WHEN o.attr_4009_ @> ARRAY[7]
                                    AND o.attr_4009_ @> ARRAY[8] <> TRUE THEN '10:30 - 10:50 '
                                        WHEN o.attr_4009_ @> ARRAY[8]
                                    AND o.attr_4009_ @> ARRAY[7] <> TRUE THEN '10:50 - 11:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4009_ @> ARRAY[9, 10] THEN '11:20 - 12:00 '
                              WHEN o.attr_4009_ @> ARRAY[9]
                                    AND o.attr_4009_ @> ARRAY[10] <> TRUE THEN '11:20 - 11:40 '
                                        WHEN o.attr_4009_ @> ARRAY[10]
                                    AND o.attr_4009_ @> ARRAY[9] <> TRUE THEN '11:40 - 12:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4009_ @> ARRAY[11, 12] THEN '13:00 - 13:40 '
                              WHEN o.attr_4009_ @> ARRAY[11]
                                    AND o.attr_4009_ @> ARRAY[12] <> TRUE THEN '13:00 - 13:20 '
                                        WHEN o.attr_4009_ @> ARRAY[12]
                                    AND o.attr_4009_ @> ARRAY[11] <> TRUE THEN '13:20 - 13:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4009_ @> ARRAY[13, 14] THEN '13:50 - 14:30 '
                              WHEN o.attr_4009_ @> ARRAY[13]
                                    AND o.attr_4009_ @> ARRAY[14] <> TRUE THEN '13:50 - 14:10 '
                                        WHEN o.attr_4009_ @> ARRAY[14]
                                    AND o.attr_4009_ @> ARRAY[13] <> TRUE THEN '14:10 - 14:30 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4009_ @> ARRAY[15, 16] THEN '14:40 - 15:20 '
                              WHEN o.attr_4009_ @> ARRAY[15]
                                    AND o.attr_4009_ @> ARRAY[16] <> TRUE THEN '14:40 - 15:00 '
                                        WHEN o.attr_4009_ @> ARRAY[16]
                                    AND o.attr_4009_ @> ARRAY[15] <> TRUE THEN '15:00 - 15:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4009_ @> ARRAY[17, 18] THEN '15:30 - 16:10 '
                              WHEN o.attr_4009_ @> ARRAY[17]
                                    AND o.attr_4009_ @> ARRAY[18] <> TRUE THEN '15:30 - 15:50 '
                                        WHEN o.attr_4009_ @> ARRAY[18]
                                    AND o.attr_4009_ @> ARRAY[17] <> TRUE THEN '15:50 - 16:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4009_ @> ARRAY[19, 20] THEN '16:20 - 17:00 '
                              WHEN o.attr_4009_ @> ARRAY[19]
                                    AND o.attr_4009_ @> ARRAY[20] <> TRUE THEN '16:20 - 16:40 '
                                        WHEN o.attr_4009_ @> ARRAY[20]
                                    AND o.attr_4009_ @> ARRAY[19] <> TRUE THEN '16:40 - 17:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4009_ @> ARRAY[21, 22] THEN '17:00 - 17:40 '
                              WHEN o.attr_4009_ @> ARRAY[21]
                                    AND o.attr_4009_ @> ARRAY[22] <> TRUE THEN '17:00 - 17:20 '
                                        WHEN o.attr_4009_ @> ARRAY[22]
                                    AND o.attr_4009_ @> ARRAY[21] <> TRUE THEN '17:20 - 17:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4009_ @> ARRAY[23, 24] THEN '17:40 - 18:20 '
                              WHEN o.attr_4009_ @> ARRAY[23]
                                    AND o.attr_4009_ @> ARRAY[24] <> TRUE THEN '17:40 - 18:00 '
                                        WHEN o.attr_4009_ @> ARRAY[24]
                                    AND o.attr_4009_ @> ARRAY[23] <> TRUE THEN '18:00 - 18:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4009_ @> ARRAY[25, 26] THEN '18:20 - 19:00 '
                              WHEN o.attr_4009_ @> ARRAY[25]
                                    AND o.attr_4009_ @> ARRAY[26] <> TRUE THEN '18:20 - 18:40 '
                                        WHEN o.attr_4009_ @> ARRAY[26]
                                    AND o.attr_4009_ @> ARRAY[25] <> TRUE THEN '18:40 - 19:00 '
                                        ELSE NULL
                    END
                    )
          END
        , o.attr_4063_
          ) AS lfk2
        , CONCAT(
          CASE
                    WHEN o.attr_4011_ && ARRAY[1] THEN NULL
                    ELSE CONCAT(
                    CASE
                              WHEN o.attr_4011_ @> ARRAY[2, 3]
                                    AND o.attr_4011_ @> ARRAY[4] <> TRUE THEN '08:30 - 09:10 '
                                        WHEN o.attr_4011_ @> ARRAY[3, 4]
                                    AND o.attr_4011_ @> ARRAY[2] <> TRUE THEN '08:50 - 09:30 '
                                        ELSE CONCAT(
                                        CASE
                                                  WHEN o.attr_4011_ @> ARRAY[2] THEN '08:30 - 08:50 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4011_ @> ARRAY[3] THEN '08:50 - 09:10 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4011_ @> ARRAY[4] THEN '09:10 - 09:30 '
                                                  ELSE NULL
                                        END
                                        )
                    END
                  , CASE
                              WHEN o.attr_4011_ @> ARRAY[5, 6] THEN '09:40-10:20 '
                              WHEN o.attr_4011_ @> ARRAY[5]
                                    AND o.attr_4011_ @> ARRAY[6] <> TRUE THEN '09:40 - 10:00 '
                                        WHEN o.attr_4011_ @> ARRAY[6]
                                    AND o.attr_4011_ @> ARRAY[5] <> TRUE THEN '10:00 - 10:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4011_ @> ARRAY[7, 8] THEN '10:30 - 11:10 '
                              WHEN o.attr_4011_ @> ARRAY[7]
                                    AND o.attr_4011_ @> ARRAY[8] <> TRUE THEN '10:30 - 10:50 '
                                        WHEN o.attr_4011_ @> ARRAY[8]
                                    AND o.attr_4011_ @> ARRAY[7] <> TRUE THEN '10:50 - 11:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4011_ @> ARRAY[9, 10] THEN '11:20 - 12:00 '
                              WHEN o.attr_4011_ @> ARRAY[9]
                                    AND o.attr_4011_ @> ARRAY[10] <> TRUE THEN '11:20 - 11:40 '
                                        WHEN o.attr_4011_ @> ARRAY[10]
                                    AND o.attr_4011_ @> ARRAY[9] <> TRUE THEN '11:40 - 12:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4011_ @> ARRAY[11, 12] THEN '13:00 - 13:40 '
                              WHEN o.attr_4011_ @> ARRAY[11]
                                    AND o.attr_4011_ @> ARRAY[12] <> TRUE THEN '13:00 - 13:20 '
                                        WHEN o.attr_4011_ @> ARRAY[12]
                                    AND o.attr_4011_ @> ARRAY[11] <> TRUE THEN '13:20 - 13:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4011_ @> ARRAY[13, 14] THEN '13:50 - 14:30 '
                              WHEN o.attr_4011_ @> ARRAY[13]
                                    AND o.attr_4011_ @> ARRAY[14] <> TRUE THEN '13:50 - 14:10 '
                                        WHEN o.attr_4011_ @> ARRAY[14]
                                    AND o.attr_4011_ @> ARRAY[13] <> TRUE THEN '14:10 - 14:30 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4011_ @> ARRAY[15, 16] THEN '14:40 - 15:20 '
                              WHEN o.attr_4011_ @> ARRAY[15]
                                    AND o.attr_4011_ @> ARRAY[16] <> TRUE THEN '14:40 - 15:00 '
                                        WHEN o.attr_4011_ @> ARRAY[16]
                                    AND o.attr_4011_ @> ARRAY[15] <> TRUE THEN '15:00 - 15:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4011_ @> ARRAY[17, 18] THEN '15:30 - 16:10 '
                              WHEN o.attr_4011_ @> ARRAY[17]
                                    AND o.attr_4011_ @> ARRAY[18] <> TRUE THEN '15:30 - 15:50 '
                                        WHEN o.attr_4011_ @> ARRAY[18]
                                    AND o.attr_4011_ @> ARRAY[17] <> TRUE THEN '15:50 - 16:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4011_ @> ARRAY[19, 20] THEN '16:20 - 17:00 '
                              WHEN o.attr_4011_ @> ARRAY[19]
                                    AND o.attr_4011_ @> ARRAY[20] <> TRUE THEN '16:20 - 16:40 '
                                        WHEN o.attr_4011_ @> ARRAY[20]
                                    AND o.attr_4011_ @> ARRAY[19] <> TRUE THEN '16:40 - 17:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4011_ @> ARRAY[21, 22] THEN '17:00 - 17:40 '
                              WHEN o.attr_4011_ @> ARRAY[21]
                                    AND o.attr_4011_ @> ARRAY[22] <> TRUE THEN '17:00 - 17:20 '
                                        WHEN o.attr_4011_ @> ARRAY[22]
                                    AND o.attr_4011_ @> ARRAY[21] <> TRUE THEN '17:20 - 17:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4011_ @> ARRAY[23, 24] THEN '17:40 - 18:20 '
                              WHEN o.attr_4011_ @> ARRAY[23]
                                    AND o.attr_4011_ @> ARRAY[24] <> TRUE THEN '17:40 - 18:00 '
                                        WHEN o.attr_4011_ @> ARRAY[24]
                                    AND o.attr_4011_ @> ARRAY[23] <> TRUE THEN '18:00 - 18:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4011_ @> ARRAY[25, 26] THEN '18:20 - 19:00 '
                              WHEN o.attr_4011_ @> ARRAY[25]
                                    AND o.attr_4011_ @> ARRAY[26] <> TRUE THEN '18:20 - 18:40 '
                                        WHEN o.attr_4011_ @> ARRAY[26]
                                    AND o.attr_4011_ @> ARRAY[25] <> TRUE THEN '18:40 - 19:00 '
                                        ELSE NULL
                    END
                    )
          END
        , o.attr_4068_
          ) AS bass
        , CONCAT(
          CASE
                    WHEN o.attr_4013_ && ARRAY[1] THEN NULL
                    ELSE CONCAT(
                    CASE
                              WHEN o.attr_4013_ @> ARRAY[2, 3]
                                    AND o.attr_4013_ @> ARRAY[4] <> TRUE THEN '08:30 - 09:10 '
                                        WHEN o.attr_4013_ @> ARRAY[3, 4]
                                    AND o.attr_4013_ @> ARRAY[2] <> TRUE THEN '08:50 - 09:30 '
                                        ELSE CONCAT(
                                        CASE
                                                  WHEN o.attr_4013_ @> ARRAY[2] THEN '08:30 - 08:50 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4013_ @> ARRAY[3] THEN '08:50 - 09:10 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4013_ @> ARRAY[4] THEN '09:10 - 09:30 '
                                                  ELSE NULL
                                        END
                                        )
                    END
                  , CASE
                              WHEN o.attr_4013_ @> ARRAY[5, 6] THEN '09:40-10:20 '
                              WHEN o.attr_4013_ @> ARRAY[5]
                                    AND o.attr_4013_ @> ARRAY[6] <> TRUE THEN '09:40 - 10:00 '
                                        WHEN o.attr_4013_ @> ARRAY[6]
                                    AND o.attr_4013_ @> ARRAY[5] <> TRUE THEN '10:00 - 10:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4013_ @> ARRAY[7, 8] THEN '10:30 - 11:10 '
                              WHEN o.attr_4013_ @> ARRAY[7]
                                    AND o.attr_4013_ @> ARRAY[8] <> TRUE THEN '10:30 - 10:50 '
                                        WHEN o.attr_4013_ @> ARRAY[8]
                                    AND o.attr_4013_ @> ARRAY[7] <> TRUE THEN '10:50 - 11:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4013_ @> ARRAY[9, 10] THEN '11:20 - 12:00 '
                              WHEN o.attr_4013_ @> ARRAY[9]
                                    AND o.attr_4013_ @> ARRAY[10] <> TRUE THEN '11:20 - 11:40 '
                                        WHEN o.attr_4013_ @> ARRAY[10]
                                    AND o.attr_4013_ @> ARRAY[9] <> TRUE THEN '11:40 - 12:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4013_ @> ARRAY[11, 12] THEN '13:00 - 13:40 '
                              WHEN o.attr_4013_ @> ARRAY[11]
                                    AND o.attr_4013_ @> ARRAY[12] <> TRUE THEN '13:00 - 13:20 '
                                        WHEN o.attr_4013_ @> ARRAY[12]
                                    AND o.attr_4013_ @> ARRAY[11] <> TRUE THEN '13:20 - 13:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4013_ @> ARRAY[13, 14] THEN '13:50 - 14:30 '
                              WHEN o.attr_4013_ @> ARRAY[13]
                                    AND o.attr_4013_ @> ARRAY[14] <> TRUE THEN '13:50 - 14:10 '
                                        WHEN o.attr_4013_ @> ARRAY[14]
                                    AND o.attr_4013_ @> ARRAY[13] <> TRUE THEN '14:10 - 14:30 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4013_ @> ARRAY[15, 16] THEN '14:40 - 15:20 '
                              WHEN o.attr_4013_ @> ARRAY[15]
                                    AND o.attr_4013_ @> ARRAY[16] <> TRUE THEN '14:40 - 15:00 '
                                        WHEN o.attr_4013_ @> ARRAY[16]
                                    AND o.attr_4013_ @> ARRAY[15] <> TRUE THEN '15:00 - 15:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4013_ @> ARRAY[17, 18] THEN '15:30 - 16:10 '
                              WHEN o.attr_4013_ @> ARRAY[17]
                                    AND o.attr_4013_ @> ARRAY[18] <> TRUE THEN '15:30 - 15:50 '
                                        WHEN o.attr_4013_ @> ARRAY[18]
                                    AND o.attr_4013_ @> ARRAY[17] <> TRUE THEN '15:50 - 16:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4013_ @> ARRAY[19, 20] THEN '16:20 - 17:00 '
                              WHEN o.attr_4013_ @> ARRAY[19]
                                    AND o.attr_4013_ @> ARRAY[20] <> TRUE THEN '16:20 - 16:40 '
                                        WHEN o.attr_4013_ @> ARRAY[20]
                                    AND o.attr_4013_ @> ARRAY[19] <> TRUE THEN '16:40 - 17:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4013_ @> ARRAY[21, 22] THEN '17:00 - 17:40 '
                              WHEN o.attr_4013_ @> ARRAY[21]
                                    AND o.attr_4013_ @> ARRAY[22] <> TRUE THEN '17:00 - 17:20 '
                                        WHEN o.attr_4013_ @> ARRAY[22]
                                    AND o.attr_4013_ @> ARRAY[21] <> TRUE THEN '17:20 - 17:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4013_ @> ARRAY[23, 24] THEN '17:40 - 18:20 '
                              WHEN o.attr_4013_ @> ARRAY[23]
                                    AND o.attr_4013_ @> ARRAY[24] <> TRUE THEN '17:40 - 18:00 '
                                        WHEN o.attr_4013_ @> ARRAY[24]
                                    AND o.attr_4013_ @> ARRAY[23] <> TRUE THEN '18:00 - 18:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4013_ @> ARRAY[25, 26] THEN '18:20 - 19:00 '
                              WHEN o.attr_4013_ @> ARRAY[25]
                                    AND o.attr_4013_ @> ARRAY[26] <> TRUE THEN '18:20 - 18:40 '
                                        WHEN o.attr_4013_ @> ARRAY[26]
                                    AND o.attr_4013_ @> ARRAY[25] <> TRUE THEN '18:40 - 19:00 '
                                        ELSE NULL
                    END
                    )
          END
        , o.attr_4069_
          ) AS hidro
        , CONCAT(
          CASE
                    WHEN o.attr_4015_ && ARRAY[1] THEN NULL
                    ELSE CONCAT(
                    CASE
                              WHEN o.attr_4015_ @> ARRAY[2, 3]
                                    AND o.attr_4015_ @> ARRAY[4] <> TRUE THEN '08:30 - 09:10 '
                                        WHEN o.attr_4015_ @> ARRAY[3, 4]
                                    AND o.attr_4015_ @> ARRAY[2] <> TRUE THEN '08:50 - 09:30 '
                                        ELSE CONCAT(
                                        CASE
                                                  WHEN o.attr_4015_ @> ARRAY[2] THEN '08:30 - 08:50 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4015_ @> ARRAY[3] THEN '08:50 - 09:10 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4015_ @> ARRAY[4] THEN '09:10 - 09:30 '
                                                  ELSE NULL
                                        END
                                        )
                    END
                  , CASE
                              WHEN o.attr_4015_ @> ARRAY[5, 6] THEN '09:40-10:20 '
                              WHEN o.attr_4015_ @> ARRAY[5]
                                    AND o.attr_4015_ @> ARRAY[6] <> TRUE THEN '09:40 - 10:00 '
                                        WHEN o.attr_4015_ @> ARRAY[6]
                                    AND o.attr_4015_ @> ARRAY[5] <> TRUE THEN '10:00 - 10:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4015_ @> ARRAY[7, 8] THEN '10:30 - 11:10 '
                              WHEN o.attr_4015_ @> ARRAY[7]
                                    AND o.attr_4015_ @> ARRAY[8] <> TRUE THEN '10:30 - 10:50 '
                                        WHEN o.attr_4015_ @> ARRAY[8]
                                    AND o.attr_4015_ @> ARRAY[7] <> TRUE THEN '10:50 - 11:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4015_ @> ARRAY[9, 10] THEN '11:20 - 12:00 '
                              WHEN o.attr_4015_ @> ARRAY[9]
                                    AND o.attr_4015_ @> ARRAY[10] <> TRUE THEN '11:20 - 11:40 '
                                        WHEN o.attr_4015_ @> ARRAY[10]
                                    AND o.attr_4015_ @> ARRAY[9] <> TRUE THEN '11:40 - 12:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4015_ @> ARRAY[11, 12] THEN '13:00 - 13:40 '
                              WHEN o.attr_4015_ @> ARRAY[11]
                                    AND o.attr_4015_ @> ARRAY[12] <> TRUE THEN '13:00 - 13:20 '
                                        WHEN o.attr_4015_ @> ARRAY[12]
                                    AND o.attr_4015_ @> ARRAY[11] <> TRUE THEN '13:20 - 13:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4015_ @> ARRAY[13, 14] THEN '13:50 - 14:30 '
                              WHEN o.attr_4015_ @> ARRAY[13]
                                    AND o.attr_4015_ @> ARRAY[14] <> TRUE THEN '13:50 - 14:10 '
                                        WHEN o.attr_4015_ @> ARRAY[14]
                                    AND o.attr_4015_ @> ARRAY[13] <> TRUE THEN '14:10 - 14:30 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4015_ @> ARRAY[15, 16] THEN '14:40 - 15:20 '
                              WHEN o.attr_4015_ @> ARRAY[15]
                                    AND o.attr_4015_ @> ARRAY[16] <> TRUE THEN '14:40 - 15:00 '
                                        WHEN o.attr_4015_ @> ARRAY[16]
                                    AND o.attr_4015_ @> ARRAY[15] <> TRUE THEN '15:00 - 15:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4015_ @> ARRAY[17, 18] THEN '15:30 - 16:10 '
                              WHEN o.attr_4015_ @> ARRAY[17]
                                    AND o.attr_4015_ @> ARRAY[18] <> TRUE THEN '15:30 - 15:50 '
                                        WHEN o.attr_4015_ @> ARRAY[18]
                                    AND o.attr_4015_ @> ARRAY[17] <> TRUE THEN '15:50 - 16:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4015_ @> ARRAY[19, 20] THEN '16:20 - 17:00 '
                              WHEN o.attr_4015_ @> ARRAY[19]
                                    AND o.attr_4015_ @> ARRAY[20] <> TRUE THEN '16:20 - 16:40 '
                                        WHEN o.attr_4015_ @> ARRAY[20]
                                    AND o.attr_4015_ @> ARRAY[19] <> TRUE THEN '16:40 - 17:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4015_ @> ARRAY[21, 22] THEN '17:00 - 17:40 '
                              WHEN o.attr_4015_ @> ARRAY[21]
                                    AND o.attr_4015_ @> ARRAY[22] <> TRUE THEN '17:00 - 17:20 '
                                        WHEN o.attr_4015_ @> ARRAY[22]
                                    AND o.attr_4015_ @> ARRAY[21] <> TRUE THEN '17:20 - 17:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4015_ @> ARRAY[23, 24] THEN '17:40 - 18:20 '
                              WHEN o.attr_4015_ @> ARRAY[23]
                                    AND o.attr_4015_ @> ARRAY[24] <> TRUE THEN '17:40 - 18:00 '
                                        WHEN o.attr_4015_ @> ARRAY[24]
                                    AND o.attr_4015_ @> ARRAY[23] <> TRUE THEN '18:00 - 18:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4015_ @> ARRAY[25, 26] THEN '18:20 - 19:00 '
                              WHEN o.attr_4015_ @> ARRAY[25]
                                    AND o.attr_4015_ @> ARRAY[26] <> TRUE THEN '18:20 - 18:40 '
                                        WHEN o.attr_4015_ @> ARRAY[26]
                                    AND o.attr_4015_ @> ARRAY[25] <> TRUE THEN '18:40 - 19:00 '
                                        ELSE NULL
                    END
                    )
          END
        , o.attr_4064_
          ) AS ergo
        , CONCAT(
          CASE
                    WHEN o.attr_4017_ && ARRAY[1] THEN NULL
                    ELSE CONCAT(
                    CASE
                              WHEN o.attr_4017_ @> ARRAY[2, 3]
                                    AND o.attr_4017_ @> ARRAY[4] <> TRUE THEN '08:30 - 09:10 '
                                        WHEN o.attr_4017_ @> ARRAY[3, 4]
                                    AND o.attr_4017_ @> ARRAY[2] <> TRUE THEN '08:50 - 09:30 '
                                        ELSE CONCAT(
                                        CASE
                                                  WHEN o.attr_4017_ @> ARRAY[2] THEN '08:30 - 08:50 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4017_ @> ARRAY[3] THEN '08:50 - 09:10 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4017_ @> ARRAY[4] THEN '09:10 - 09:30 '
                                                  ELSE NULL
                                        END
                                        )
                    END
                  , CASE
                              WHEN o.attr_4017_ @> ARRAY[5, 6] THEN '09:40-10:20 '
                              WHEN o.attr_4017_ @> ARRAY[5]
                                    AND o.attr_4017_ @> ARRAY[6] <> TRUE THEN '09:40 - 10:00 '
                                        WHEN o.attr_4017_ @> ARRAY[6]
                                    AND o.attr_4017_ @> ARRAY[5] <> TRUE THEN '10:00 - 10:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4017_ @> ARRAY[7, 8] THEN '10:30 - 11:10 '
                              WHEN o.attr_4017_ @> ARRAY[7]
                                    AND o.attr_4017_ @> ARRAY[8] <> TRUE THEN '10:30 - 10:50 '
                                        WHEN o.attr_4017_ @> ARRAY[8]
                                    AND o.attr_4017_ @> ARRAY[7] <> TRUE THEN '10:50 - 11:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4017_ @> ARRAY[9, 10] THEN '11:20 - 12:00 '
                              WHEN o.attr_4017_ @> ARRAY[9]
                                    AND o.attr_4017_ @> ARRAY[10] <> TRUE THEN '11:20 - 11:40 '
                                        WHEN o.attr_4017_ @> ARRAY[10]
                                    AND o.attr_4017_ @> ARRAY[9] <> TRUE THEN '11:40 - 12:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4017_ @> ARRAY[11, 12] THEN '13:00 - 13:40 '
                              WHEN o.attr_4017_ @> ARRAY[11]
                                    AND o.attr_4017_ @> ARRAY[12] <> TRUE THEN '13:00 - 13:20 '
                                        WHEN o.attr_4017_ @> ARRAY[12]
                                    AND o.attr_4017_ @> ARRAY[11] <> TRUE THEN '13:20 - 13:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4017_ @> ARRAY[13, 14] THEN '13:50 - 14:30 '
                              WHEN o.attr_4017_ @> ARRAY[13]
                                    AND o.attr_4017_ @> ARRAY[14] <> TRUE THEN '13:50 - 14:10 '
                                        WHEN o.attr_4017_ @> ARRAY[14]
                                    AND o.attr_4017_ @> ARRAY[13] <> TRUE THEN '14:10 - 14:30 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4017_ @> ARRAY[15, 16] THEN '14:40 - 15:20 '
                              WHEN o.attr_4017_ @> ARRAY[15]
                                    AND o.attr_4017_ @> ARRAY[16] <> TRUE THEN '14:40 - 15:00 '
                                        WHEN o.attr_4017_ @> ARRAY[16]
                                    AND o.attr_4017_ @> ARRAY[15] <> TRUE THEN '15:00 - 15:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4017_ @> ARRAY[17, 18] THEN '15:30 - 16:10 '
                              WHEN o.attr_4017_ @> ARRAY[17]
                                    AND o.attr_4017_ @> ARRAY[18] <> TRUE THEN '15:30 - 15:50 '
                                        WHEN o.attr_4017_ @> ARRAY[18]
                                    AND o.attr_4017_ @> ARRAY[17] <> TRUE THEN '15:50 - 16:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4017_ @> ARRAY[19, 20] THEN '16:20 - 17:00 '
                              WHEN o.attr_4017_ @> ARRAY[19]
                                    AND o.attr_4017_ @> ARRAY[20] <> TRUE THEN '16:20 - 16:40 '
                                        WHEN o.attr_4017_ @> ARRAY[20]
                                    AND o.attr_4017_ @> ARRAY[19] <> TRUE THEN '16:40 - 17:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4017_ @> ARRAY[21, 22] THEN '17:00 - 17:40 '
                              WHEN o.attr_4017_ @> ARRAY[21]
                                    AND o.attr_4017_ @> ARRAY[22] <> TRUE THEN '17:00 - 17:20 '
                                        WHEN o.attr_4017_ @> ARRAY[22]
                                    AND o.attr_4017_ @> ARRAY[21] <> TRUE THEN '17:20 - 17:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4017_ @> ARRAY[23, 24] THEN '17:40 - 18:20 '
                              WHEN o.attr_4017_ @> ARRAY[23]
                                    AND o.attr_4017_ @> ARRAY[24] <> TRUE THEN '17:40 - 18:00 '
                                        WHEN o.attr_4017_ @> ARRAY[24]
                                    AND o.attr_4017_ @> ARRAY[23] <> TRUE THEN '18:00 - 18:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4017_ @> ARRAY[25, 26] THEN '18:20 - 19:00 '
                              WHEN o.attr_4017_ @> ARRAY[25]
                                    AND o.attr_4017_ @> ARRAY[26] <> TRUE THEN '18:20 - 18:40 '
                                        WHEN o.attr_4017_ @> ARRAY[26]
                                    AND o.attr_4017_ @> ARRAY[25] <> TRUE THEN '18:40 - 19:00 '
                                        ELSE NULL
                    END
                    )
          END
        , o.attr_4067_
          ) AS logo
        , CONCAT(
          CASE
                    WHEN o.attr_4019_ && ARRAY[1] THEN NULL
                    ELSE CONCAT(
                    CASE
                              WHEN o.attr_4019_ @> ARRAY[2, 3]
                                    AND o.attr_4019_ @> ARRAY[4] <> TRUE THEN '08:30 - 09:10 '
                                        WHEN o.attr_4019_ @> ARRAY[3, 4]
                                    AND o.attr_4019_ @> ARRAY[2] <> TRUE THEN '08:50 - 09:30 '
                                        ELSE CONCAT(
                                        CASE
                                                  WHEN o.attr_4019_ @> ARRAY[2] THEN '08:30 - 08:50 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4019_ @> ARRAY[3] THEN '08:50 - 09:10 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4019_ @> ARRAY[4] THEN '09:10 - 09:30 '
                                                  ELSE NULL
                                        END
                                        )
                    END
                  , CASE
                              WHEN o.attr_4019_ @> ARRAY[5, 6] THEN '09:40-10:20 '
                              WHEN o.attr_4019_ @> ARRAY[5]
                                    AND o.attr_4019_ @> ARRAY[6] <> TRUE THEN '09:40 - 10:00 '
                                        WHEN o.attr_4019_ @> ARRAY[6]
                                    AND o.attr_4019_ @> ARRAY[5] <> TRUE THEN '10:00 - 10:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4019_ @> ARRAY[7, 8] THEN '10:30 - 11:10 '
                              WHEN o.attr_4019_ @> ARRAY[7]
                                    AND o.attr_4019_ @> ARRAY[8] <> TRUE THEN '10:30 - 10:50 '
                                        WHEN o.attr_4019_ @> ARRAY[8]
                                    AND o.attr_4019_ @> ARRAY[7] <> TRUE THEN '10:50 - 11:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4019_ @> ARRAY[9, 10] THEN '11:20 - 12:00 '
                              WHEN o.attr_4019_ @> ARRAY[9]
                                    AND o.attr_4019_ @> ARRAY[10] <> TRUE THEN '11:20 - 11:40 '
                                        WHEN o.attr_4019_ @> ARRAY[10]
                                    AND o.attr_4019_ @> ARRAY[9] <> TRUE THEN '11:40 - 12:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4019_ @> ARRAY[11, 12] THEN '13:00 - 13:40 '
                              WHEN o.attr_4019_ @> ARRAY[11]
                                    AND o.attr_4019_ @> ARRAY[12] <> TRUE THEN '13:00 - 13:20 '
                                        WHEN o.attr_4019_ @> ARRAY[12]
                                    AND o.attr_4019_ @> ARRAY[11] <> TRUE THEN '13:20 - 13:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4019_ @> ARRAY[13, 14] THEN '13:50 - 14:30 '
                              WHEN o.attr_4019_ @> ARRAY[13]
                                    AND o.attr_4019_ @> ARRAY[14] <> TRUE THEN '13:50 - 14:10 '
                                        WHEN o.attr_4019_ @> ARRAY[14]
                                    AND o.attr_4019_ @> ARRAY[13] <> TRUE THEN '14:10 - 14:30 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4019_ @> ARRAY[15, 16] THEN '14:40 - 15:20 '
                              WHEN o.attr_4019_ @> ARRAY[15]
                                    AND o.attr_4019_ @> ARRAY[16] <> TRUE THEN '14:40 - 15:00 '
                                        WHEN o.attr_4019_ @> ARRAY[16]
                                    AND o.attr_4019_ @> ARRAY[15] <> TRUE THEN '15:00 - 15:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4019_ @> ARRAY[17, 18] THEN '15:30 - 16:10 '
                              WHEN o.attr_4019_ @> ARRAY[17]
                                    AND o.attr_4019_ @> ARRAY[18] <> TRUE THEN '15:30 - 15:50 '
                                        WHEN o.attr_4019_ @> ARRAY[18]
                                    AND o.attr_4019_ @> ARRAY[17] <> TRUE THEN '15:50 - 16:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4019_ @> ARRAY[19, 20] THEN '16:20 - 17:00 '
                              WHEN o.attr_4019_ @> ARRAY[19]
                                    AND o.attr_4019_ @> ARRAY[20] <> TRUE THEN '16:20 - 16:40 '
                                        WHEN o.attr_4019_ @> ARRAY[20]
                                    AND o.attr_4019_ @> ARRAY[19] <> TRUE THEN '16:40 - 17:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4019_ @> ARRAY[21, 22] THEN '17:00 - 17:40 '
                              WHEN o.attr_4019_ @> ARRAY[21]
                                    AND o.attr_4019_ @> ARRAY[22] <> TRUE THEN '17:00 - 17:20 '
                                        WHEN o.attr_4019_ @> ARRAY[22]
                                    AND o.attr_4019_ @> ARRAY[21] <> TRUE THEN '17:20 - 17:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4019_ @> ARRAY[23, 24] THEN '17:40 - 18:20 '
                              WHEN o.attr_4019_ @> ARRAY[23]
                                    AND o.attr_4019_ @> ARRAY[24] <> TRUE THEN '17:40 - 18:00 '
                                        WHEN o.attr_4019_ @> ARRAY[24]
                                    AND o.attr_4019_ @> ARRAY[23] <> TRUE THEN '18:00 - 18:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4019_ @> ARRAY[25, 26] THEN '18:20 - 19:00 '
                              WHEN o.attr_4019_ @> ARRAY[25]
                                    AND o.attr_4019_ @> ARRAY[26] <> TRUE THEN '18:20 - 18:40 '
                                        WHEN o.attr_4019_ @> ARRAY[26]
                                    AND o.attr_4019_ @> ARRAY[25] <> TRUE THEN '18:40 - 19:00 '
                                        ELSE NULL
                    END
                    )
          END
        , o.attr_4066_
          ) AS pshich
        , CONCAT(
          CASE
                    WHEN o.attr_4021_ && ARRAY[1] THEN NULL
                    ELSE CONCAT(
                    CASE
                              WHEN o.attr_4021_ @> ARRAY[2, 3]
                                    AND o.attr_4021_ @> ARRAY[4] <> TRUE THEN '08:30 - 09:10 '
                                        WHEN o.attr_4021_ @> ARRAY[3, 4]
                                    AND o.attr_4021_ @> ARRAY[2] <> TRUE THEN '08:50 - 09:30 '
                                        ELSE CONCAT(
                                        CASE
                                                  WHEN o.attr_4021_ @> ARRAY[2] THEN '08:30 - 08:50 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4021_ @> ARRAY[3] THEN '08:50 - 09:10 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4021_ @> ARRAY[4] THEN '09:10 - 09:30 '
                                                  ELSE NULL
                                        END
                                        )
                    END
                  , CASE
                              WHEN o.attr_4021_ @> ARRAY[5, 6] THEN '09:40-10:20 '
                              WHEN o.attr_4021_ @> ARRAY[5]
                                    AND o.attr_4021_ @> ARRAY[6] <> TRUE THEN '09:40 - 10:00 '
                                        WHEN o.attr_4021_ @> ARRAY[6]
                                    AND o.attr_4021_ @> ARRAY[5] <> TRUE THEN '10:00 - 10:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4021_ @> ARRAY[7, 8] THEN '10:30 - 11:10 '
                              WHEN o.attr_4021_ @> ARRAY[7]
                                    AND o.attr_4021_ @> ARRAY[8] <> TRUE THEN '10:30 - 10:50 '
                                        WHEN o.attr_4021_ @> ARRAY[8]
                                    AND o.attr_4021_ @> ARRAY[7] <> TRUE THEN '10:50 - 11:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4021_ @> ARRAY[9, 10] THEN '11:20 - 12:00 '
                              WHEN o.attr_4021_ @> ARRAY[9]
                                    AND o.attr_4021_ @> ARRAY[10] <> TRUE THEN '11:20 - 11:40 '
                                        WHEN o.attr_4021_ @> ARRAY[10]
                                    AND o.attr_4021_ @> ARRAY[9] <> TRUE THEN '11:40 - 12:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4021_ @> ARRAY[11, 12] THEN '13:00 - 13:40 '
                              WHEN o.attr_4021_ @> ARRAY[11]
                                    AND o.attr_4021_ @> ARRAY[12] <> TRUE THEN '13:00 - 13:20 '
                                        WHEN o.attr_4021_ @> ARRAY[12]
                                    AND o.attr_4021_ @> ARRAY[11] <> TRUE THEN '13:20 - 13:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4021_ @> ARRAY[13, 14] THEN '13:50 - 14:30 '
                              WHEN o.attr_4021_ @> ARRAY[13]
                                    AND o.attr_4021_ @> ARRAY[14] <> TRUE THEN '13:50 - 14:10 '
                                        WHEN o.attr_4021_ @> ARRAY[14]
                                    AND o.attr_4021_ @> ARRAY[13] <> TRUE THEN '14:10 - 14:30 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4021_ @> ARRAY[15, 16] THEN '14:40 - 15:20 '
                              WHEN o.attr_4021_ @> ARRAY[15]
                                    AND o.attr_4021_ @> ARRAY[16] <> TRUE THEN '14:40 - 15:00 '
                                        WHEN o.attr_4021_ @> ARRAY[16]
                                    AND o.attr_4021_ @> ARRAY[15] <> TRUE THEN '15:00 - 15:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4021_ @> ARRAY[17, 18] THEN '15:30 - 16:10 '
                              WHEN o.attr_4021_ @> ARRAY[17]
                                    AND o.attr_4021_ @> ARRAY[18] <> TRUE THEN '15:30 - 15:50 '
                                        WHEN o.attr_4021_ @> ARRAY[18]
                                    AND o.attr_4021_ @> ARRAY[17] <> TRUE THEN '15:50 - 16:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4021_ @> ARRAY[19, 20] THEN '16:20 - 17:00 '
                              WHEN o.attr_4021_ @> ARRAY[19]
                                    AND o.attr_4021_ @> ARRAY[20] <> TRUE THEN '16:20 - 16:40 '
                                        WHEN o.attr_4021_ @> ARRAY[20]
                                    AND o.attr_4021_ @> ARRAY[19] <> TRUE THEN '16:40 - 17:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4021_ @> ARRAY[21, 22] THEN '17:00 - 17:40 '
                              WHEN o.attr_4021_ @> ARRAY[21]
                                    AND o.attr_4021_ @> ARRAY[22] <> TRUE THEN '17:00 - 17:20 '
                                        WHEN o.attr_4021_ @> ARRAY[22]
                                    AND o.attr_4021_ @> ARRAY[21] <> TRUE THEN '17:20 - 17:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4021_ @> ARRAY[23, 24] THEN '17:40 - 18:20 '
                              WHEN o.attr_4021_ @> ARRAY[23]
                                    AND o.attr_4021_ @> ARRAY[24] <> TRUE THEN '17:40 - 18:00 '
                                        WHEN o.attr_4021_ @> ARRAY[24]
                                    AND o.attr_4021_ @> ARRAY[23] <> TRUE THEN '18:00 - 18:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4021_ @> ARRAY[25, 26] THEN '18:20 - 19:00 '
                              WHEN o.attr_4021_ @> ARRAY[25]
                                    AND o.attr_4021_ @> ARRAY[26] <> TRUE THEN '18:20 - 18:40 '
                                        WHEN o.attr_4021_ @> ARRAY[26]
                                    AND o.attr_4021_ @> ARRAY[25] <> TRUE THEN '18:40 - 19:00 '
                                        ELSE NULL
                    END
                    )
          END
        , o.attr_4070_
          ) AS irt
        , CONCAT(
          CASE
                    WHEN o.attr_4023_ && ARRAY[1] THEN NULL
                    ELSE CONCAT(
                    CASE
                              WHEN o.attr_4023_ @> ARRAY[2, 3]
                                    AND o.attr_4023_ @> ARRAY[4] <> TRUE THEN '08:30 - 09:10 '
                                        WHEN o.attr_4023_ @> ARRAY[3, 4]
                                    AND o.attr_4023_ @> ARRAY[2] <> TRUE THEN '08:50 - 09:30 '
                                        ELSE CONCAT(
                                        CASE
                                                  WHEN o.attr_4023_ @> ARRAY[2] THEN '08:30 - 08:50 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4023_ @> ARRAY[3] THEN '08:50 - 09:10 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4023_ @> ARRAY[4] THEN '09:10 - 09:30 '
                                                  ELSE NULL
                                        END
                                        )
                    END
                  , CASE
                              WHEN o.attr_4023_ @> ARRAY[5, 6] THEN '09:40-10:20 '
                              WHEN o.attr_4023_ @> ARRAY[5]
                                    AND o.attr_4023_ @> ARRAY[6] <> TRUE THEN '09:40 - 10:00 '
                                        WHEN o.attr_4023_ @> ARRAY[6]
                                    AND o.attr_4023_ @> ARRAY[5] <> TRUE THEN '10:00 - 10:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4023_ @> ARRAY[7, 8] THEN '10:30 - 11:10 '
                              WHEN o.attr_4023_ @> ARRAY[7]
                                    AND o.attr_4023_ @> ARRAY[8] <> TRUE THEN '10:30 - 10:50 '
                                        WHEN o.attr_4023_ @> ARRAY[8]
                                    AND o.attr_4023_ @> ARRAY[7] <> TRUE THEN '10:50 - 11:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4023_ @> ARRAY[9, 10] THEN '11:20 - 12:00 '
                              WHEN o.attr_4023_ @> ARRAY[9]
                                    AND o.attr_4023_ @> ARRAY[10] <> TRUE THEN '11:20 - 11:40 '
                                        WHEN o.attr_4023_ @> ARRAY[10]
                                    AND o.attr_4023_ @> ARRAY[9] <> TRUE THEN '11:40 - 12:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4023_ @> ARRAY[11, 12] THEN '13:00 - 13:40 '
                              WHEN o.attr_4023_ @> ARRAY[11]
                                    AND o.attr_4023_ @> ARRAY[12] <> TRUE THEN '13:00 - 13:20 '
                                        WHEN o.attr_4023_ @> ARRAY[12]
                                    AND o.attr_4023_ @> ARRAY[11] <> TRUE THEN '13:20 - 13:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4023_ @> ARRAY[13, 14] THEN '13:50 - 14:30 '
                              WHEN o.attr_4023_ @> ARRAY[13]
                                    AND o.attr_4023_ @> ARRAY[14] <> TRUE THEN '13:50 - 14:10 '
                                        WHEN o.attr_4023_ @> ARRAY[14]
                                    AND o.attr_4023_ @> ARRAY[13] <> TRUE THEN '14:10 - 14:30 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4023_ @> ARRAY[15, 16] THEN '14:40 - 15:20 '
                              WHEN o.attr_4023_ @> ARRAY[15]
                                    AND o.attr_4023_ @> ARRAY[16] <> TRUE THEN '14:40 - 15:00 '
                                        WHEN o.attr_4023_ @> ARRAY[16]
                                    AND o.attr_4023_ @> ARRAY[15] <> TRUE THEN '15:00 - 15:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4023_ @> ARRAY[17, 18] THEN '15:30 - 16:10 '
                              WHEN o.attr_4023_ @> ARRAY[17]
                                    AND o.attr_4023_ @> ARRAY[18] <> TRUE THEN '15:30 - 15:50 '
                                        WHEN o.attr_4023_ @> ARRAY[18]
                                    AND o.attr_4023_ @> ARRAY[17] <> TRUE THEN '15:50 - 16:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4023_ @> ARRAY[19, 20] THEN '16:20 - 17:00 '
                              WHEN o.attr_4023_ @> ARRAY[19]
                                    AND o.attr_4023_ @> ARRAY[20] <> TRUE THEN '16:20 - 16:40 '
                                        WHEN o.attr_4023_ @> ARRAY[20]
                                    AND o.attr_4023_ @> ARRAY[19] <> TRUE THEN '16:40 - 17:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4023_ @> ARRAY[21, 22] THEN '17:00 - 17:40 '
                              WHEN o.attr_4023_ @> ARRAY[21]
                                    AND o.attr_4023_ @> ARRAY[22] <> TRUE THEN '17:00 - 17:20 '
                                        WHEN o.attr_4023_ @> ARRAY[22]
                                    AND o.attr_4023_ @> ARRAY[21] <> TRUE THEN '17:20 - 17:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4023_ @> ARRAY[23, 24] THEN '17:40 - 18:20 '
                              WHEN o.attr_4023_ @> ARRAY[23]
                                    AND o.attr_4023_ @> ARRAY[24] <> TRUE THEN '17:40 - 18:00 '
                                        WHEN o.attr_4023_ @> ARRAY[24]
                                    AND o.attr_4023_ @> ARRAY[23] <> TRUE THEN '18:00 - 18:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4023_ @> ARRAY[25, 26] THEN '18:20 - 19:00 '
                              WHEN o.attr_4023_ @> ARRAY[25]
                                    AND o.attr_4023_ @> ARRAY[26] <> TRUE THEN '18:20 - 18:40 '
                                        WHEN o.attr_4023_ @> ARRAY[26]
                                    AND o.attr_4023_ @> ARRAY[25] <> TRUE THEN '18:40 - 19:00 '
                                        ELSE NULL
                    END
                    )
          END
        , o.attr_4065_
          ) AS mass
        , CONCAT(
          CASE
                    WHEN o.attr_4025_ && ARRAY[1] THEN NULL
                    ELSE CONCAT(
                    CASE
                              WHEN o.attr_4025_ @> ARRAY[2, 3]
                                    AND o.attr_4025_ @> ARRAY[4] <> TRUE THEN '08:30 - 09:10 '
                                        WHEN o.attr_4025_ @> ARRAY[3, 4]
                                    AND o.attr_4025_ @> ARRAY[2] <> TRUE THEN '08:50 - 09:30 '
                                        ELSE CONCAT(
                                        CASE
                                                  WHEN o.attr_4025_ @> ARRAY[2] THEN '08:30 - 08:50 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4025_ @> ARRAY[3] THEN '08:50 - 09:10 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4025_ @> ARRAY[4] THEN '09:10 - 09:30 '
                                                  ELSE NULL
                                        END
                                        )
                    END
                  , CASE
                              WHEN o.attr_4025_ @> ARRAY[5, 6] THEN '09:40-10:20 '
                              WHEN o.attr_4025_ @> ARRAY[5]
                                    AND o.attr_4025_ @> ARRAY[6] <> TRUE THEN '09:40 - 10:00 '
                                        WHEN o.attr_4025_ @> ARRAY[6]
                                    AND o.attr_4025_ @> ARRAY[5] <> TRUE THEN '10:00 - 10:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4025_ @> ARRAY[7, 8] THEN '10:30 - 11:10 '
                              WHEN o.attr_4025_ @> ARRAY[7]
                                    AND o.attr_4025_ @> ARRAY[8] <> TRUE THEN '10:30 - 10:50 '
                                        WHEN o.attr_4025_ @> ARRAY[8]
                                    AND o.attr_4025_ @> ARRAY[7] <> TRUE THEN '10:50 - 11:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4025_ @> ARRAY[9, 10] THEN '11:20 - 12:00 '
                              WHEN o.attr_4025_ @> ARRAY[9]
                                    AND o.attr_4025_ @> ARRAY[10] <> TRUE THEN '11:20 - 11:40 '
                                        WHEN o.attr_4025_ @> ARRAY[10]
                                    AND o.attr_4025_ @> ARRAY[9] <> TRUE THEN '11:40 - 12:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4025_ @> ARRAY[11, 12] THEN '13:00 - 13:40 '
                              WHEN o.attr_4025_ @> ARRAY[11]
                                    AND o.attr_4025_ @> ARRAY[12] <> TRUE THEN '13:00 - 13:20 '
                                        WHEN o.attr_4025_ @> ARRAY[12]
                                    AND o.attr_4025_ @> ARRAY[11] <> TRUE THEN '13:20 - 13:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4025_ @> ARRAY[13, 14] THEN '13:50 - 14:30 '
                              WHEN o.attr_4025_ @> ARRAY[13]
                                    AND o.attr_4025_ @> ARRAY[14] <> TRUE THEN '13:50 - 14:10 '
                                        WHEN o.attr_4025_ @> ARRAY[14]
                                    AND o.attr_4025_ @> ARRAY[13] <> TRUE THEN '14:10 - 14:30 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4025_ @> ARRAY[15, 16] THEN '14:40 - 15:20 '
                              WHEN o.attr_4025_ @> ARRAY[15]
                                    AND o.attr_4025_ @> ARRAY[16] <> TRUE THEN '14:40 - 15:00 '
                                        WHEN o.attr_4025_ @> ARRAY[16]
                                    AND o.attr_4025_ @> ARRAY[15] <> TRUE THEN '15:00 - 15:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4025_ @> ARRAY[17, 18] THEN '15:30 - 16:10 '
                              WHEN o.attr_4025_ @> ARRAY[17]
                                    AND o.attr_4025_ @> ARRAY[18] <> TRUE THEN '15:30 - 15:50 '
                                        WHEN o.attr_4025_ @> ARRAY[18]
                                    AND o.attr_4025_ @> ARRAY[17] <> TRUE THEN '15:50 - 16:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4025_ @> ARRAY[19, 20] THEN '16:20 - 17:00 '
                              WHEN o.attr_4025_ @> ARRAY[19]
                                    AND o.attr_4025_ @> ARRAY[20] <> TRUE THEN '16:20 - 16:40 '
                                        WHEN o.attr_4025_ @> ARRAY[20]
                                    AND o.attr_4025_ @> ARRAY[19] <> TRUE THEN '16:40 - 17:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4025_ @> ARRAY[21, 22] THEN '17:00 - 17:40 '
                              WHEN o.attr_4025_ @> ARRAY[21]
                                    AND o.attr_4025_ @> ARRAY[22] <> TRUE THEN '17:00 - 17:20 '
                                        WHEN o.attr_4025_ @> ARRAY[22]
                                    AND o.attr_4025_ @> ARRAY[21] <> TRUE THEN '17:20 - 17:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4025_ @> ARRAY[23, 24] THEN '17:40 - 18:20 '
                              WHEN o.attr_4025_ @> ARRAY[23]
                                    AND o.attr_4025_ @> ARRAY[24] <> TRUE THEN '17:40 - 18:00 '
                                        WHEN o.attr_4025_ @> ARRAY[24]
                                    AND o.attr_4025_ @> ARRAY[23] <> TRUE THEN '18:00 - 18:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4025_ @> ARRAY[25, 26] THEN '18:20 - 19:00 '
                              WHEN o.attr_4025_ @> ARRAY[25]
                                    AND o.attr_4025_ @> ARRAY[26] <> TRUE THEN '18:20 - 18:40 '
                                        WHEN o.attr_4025_ @> ARRAY[26]
                                    AND o.attr_4025_ @> ARRAY[25] <> TRUE THEN '18:40 - 19:00 '
                                        ELSE NULL
                    END
                    )
          END
        , o.attr_4071_
          ) AS ft
        , CONCAT(
          CASE
                    WHEN o.attr_4027_ && ARRAY[1] THEN NULL
                    ELSE CONCAT(
                    CASE
                              WHEN o.attr_4027_ @> ARRAY[2, 3]
                                    AND o.attr_4027_ @> ARRAY[4] <> TRUE THEN '08:30 - 09:10 '
                                        WHEN o.attr_4027_ @> ARRAY[3, 4]
                                    AND o.attr_4027_ @> ARRAY[2] <> TRUE THEN '08:50 - 09:30 '
                                        ELSE CONCAT(
                                        CASE
                                                  WHEN o.attr_4027_ @> ARRAY[2] THEN '08:30 - 08:50 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4027_ @> ARRAY[3] THEN '08:50 - 09:10 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4027_ @> ARRAY[4] THEN '09:10 - 09:30 '
                                                  ELSE NULL
                                        END
                                        )
                    END
                  , CASE
                              WHEN o.attr_4027_ @> ARRAY[5, 6] THEN '09:40-10:20 '
                              WHEN o.attr_4027_ @> ARRAY[5]
                                    AND o.attr_4027_ @> ARRAY[6] <> TRUE THEN '09:40 - 10:00 '
                                        WHEN o.attr_4027_ @> ARRAY[6]
                                    AND o.attr_4027_ @> ARRAY[5] <> TRUE THEN '10:00 - 10:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4027_ @> ARRAY[7, 8] THEN '10:30 - 11:10 '
                              WHEN o.attr_4027_ @> ARRAY[7]
                                    AND o.attr_4027_ @> ARRAY[8] <> TRUE THEN '10:30 - 10:50 '
                                        WHEN o.attr_4027_ @> ARRAY[8]
                                    AND o.attr_4027_ @> ARRAY[7] <> TRUE THEN '10:50 - 11:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4027_ @> ARRAY[9, 10] THEN '11:20 - 12:00 '
                              WHEN o.attr_4027_ @> ARRAY[9]
                                    AND o.attr_4027_ @> ARRAY[10] <> TRUE THEN '11:20 - 11:40 '
                                        WHEN o.attr_4027_ @> ARRAY[10]
                                    AND o.attr_4027_ @> ARRAY[9] <> TRUE THEN '11:40 - 12:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4027_ @> ARRAY[11, 12] THEN '13:00 - 13:40 '
                              WHEN o.attr_4027_ @> ARRAY[11]
                                    AND o.attr_4027_ @> ARRAY[12] <> TRUE THEN '13:00 - 13:20 '
                                        WHEN o.attr_4027_ @> ARRAY[12]
                                    AND o.attr_4027_ @> ARRAY[11] <> TRUE THEN '13:20 - 13:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4027_ @> ARRAY[13, 14] THEN '13:50 - 14:30 '
                              WHEN o.attr_4027_ @> ARRAY[13]
                                    AND o.attr_4027_ @> ARRAY[14] <> TRUE THEN '13:50 - 14:10 '
                                        WHEN o.attr_4027_ @> ARRAY[14]
                                    AND o.attr_4027_ @> ARRAY[13] <> TRUE THEN '14:10 - 14:30 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4027_ @> ARRAY[15, 16] THEN '14:40 - 15:20 '
                              WHEN o.attr_4027_ @> ARRAY[15]
                                    AND o.attr_4027_ @> ARRAY[16] <> TRUE THEN '14:40 - 15:00 '
                                        WHEN o.attr_4027_ @> ARRAY[16]
                                    AND o.attr_4027_ @> ARRAY[15] <> TRUE THEN '15:00 - 15:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4027_ @> ARRAY[17, 18] THEN '15:30 - 16:10 '
                              WHEN o.attr_4027_ @> ARRAY[17]
                                    AND o.attr_4027_ @> ARRAY[18] <> TRUE THEN '15:30 - 15:50 '
                                        WHEN o.attr_4027_ @> ARRAY[18]
                                    AND o.attr_4027_ @> ARRAY[17] <> TRUE THEN '15:50 - 16:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4027_ @> ARRAY[19, 20] THEN '16:20 - 17:00 '
                              WHEN o.attr_4027_ @> ARRAY[19]
                                    AND o.attr_4027_ @> ARRAY[20] <> TRUE THEN '16:20 - 16:40 '
                                        WHEN o.attr_4027_ @> ARRAY[20]
                                    AND o.attr_4027_ @> ARRAY[19] <> TRUE THEN '16:40 - 17:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4027_ @> ARRAY[21, 22] THEN '17:00 - 17:40 '
                              WHEN o.attr_4027_ @> ARRAY[21]
                                    AND o.attr_4027_ @> ARRAY[22] <> TRUE THEN '17:00 - 17:20 '
                                        WHEN o.attr_4027_ @> ARRAY[22]
                                    AND o.attr_4027_ @> ARRAY[21] <> TRUE THEN '17:20 - 17:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4027_ @> ARRAY[23, 24] THEN '17:40 - 18:20 '
                              WHEN o.attr_4027_ @> ARRAY[23]
                                    AND o.attr_4027_ @> ARRAY[24] <> TRUE THEN '17:40 - 18:00 '
                                        WHEN o.attr_4027_ @> ARRAY[24]
                                    AND o.attr_4027_ @> ARRAY[23] <> TRUE THEN '18:00 - 18:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4027_ @> ARRAY[25, 26] THEN '18:20 - 19:00 '
                              WHEN o.attr_4027_ @> ARRAY[25]
                                    AND o.attr_4027_ @> ARRAY[26] <> TRUE THEN '18:20 - 18:40 '
                                        WHEN o.attr_4027_ @> ARRAY[26]
                                    AND o.attr_4027_ @> ARRAY[25] <> TRUE THEN '18:40 - 19:00 '
                                        ELSE NULL
                    END
                    )
          END
        , o.attr_4072_
          ) AS gt
        , CONCAT(
          CASE
                    WHEN o.attr_4029_ && ARRAY[1] THEN NULL
                    ELSE CONCAT(
                    CASE
                              WHEN o.attr_4029_ @> ARRAY[2, 3]
                                    AND o.attr_4029_ @> ARRAY[4] <> TRUE THEN '08:30 - 09:10 '
                                        WHEN o.attr_4029_ @> ARRAY[3, 4]
                                    AND o.attr_4029_ @> ARRAY[2] <> TRUE THEN '08:50 - 09:30 '
                                        ELSE CONCAT(
                                        CASE
                                                  WHEN o.attr_4029_ @> ARRAY[2] THEN '08:30 - 08:50 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4029_ @> ARRAY[3] THEN '08:50 - 09:10 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4029_ @> ARRAY[4] THEN '09:10 - 09:30 '
                                                  ELSE NULL
                                        END
                                        )
                    END
                  , CASE
                              WHEN o.attr_4029_ @> ARRAY[5, 6] THEN '09:40-10:20 '
                              WHEN o.attr_4029_ @> ARRAY[5]
                                    AND o.attr_4029_ @> ARRAY[6] <> TRUE THEN '09:40 - 10:00 '
                                        WHEN o.attr_4029_ @> ARRAY[6]
                                    AND o.attr_4029_ @> ARRAY[5] <> TRUE THEN '10:00 - 10:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4029_ @> ARRAY[7, 8] THEN '10:30 - 11:10 '
                              WHEN o.attr_4029_ @> ARRAY[7]
                                    AND o.attr_4029_ @> ARRAY[8] <> TRUE THEN '10:30 - 10:50 '
                                        WHEN o.attr_4029_ @> ARRAY[8]
                                    AND o.attr_4029_ @> ARRAY[7] <> TRUE THEN '10:50 - 11:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4029_ @> ARRAY[9, 10] THEN '11:20 - 12:00 '
                              WHEN o.attr_4029_ @> ARRAY[9]
                                    AND o.attr_4029_ @> ARRAY[10] <> TRUE THEN '11:20 - 11:40 '
                                        WHEN o.attr_4029_ @> ARRAY[10]
                                    AND o.attr_4029_ @> ARRAY[9] <> TRUE THEN '11:40 - 12:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4029_ @> ARRAY[11, 12] THEN '13:00 - 13:40 '
                              WHEN o.attr_4029_ @> ARRAY[11]
                                    AND o.attr_4029_ @> ARRAY[12] <> TRUE THEN '13:00 - 13:20 '
                                        WHEN o.attr_4029_ @> ARRAY[12]
                                    AND o.attr_4029_ @> ARRAY[11] <> TRUE THEN '13:20 - 13:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4029_ @> ARRAY[13, 14] THEN '13:50 - 14:30 '
                              WHEN o.attr_4029_ @> ARRAY[13]
                                    AND o.attr_4029_ @> ARRAY[14] <> TRUE THEN '13:50 - 14:10 '
                                        WHEN o.attr_4029_ @> ARRAY[14]
                                    AND o.attr_4029_ @> ARRAY[13] <> TRUE THEN '14:10 - 14:30 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4029_ @> ARRAY[15, 16] THEN '14:40 - 15:20 '
                              WHEN o.attr_4029_ @> ARRAY[15]
                                    AND o.attr_4029_ @> ARRAY[16] <> TRUE THEN '14:40 - 15:00 '
                                        WHEN o.attr_4029_ @> ARRAY[16]
                                    AND o.attr_4029_ @> ARRAY[15] <> TRUE THEN '15:00 - 15:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4029_ @> ARRAY[17, 18] THEN '15:30 - 16:10 '
                              WHEN o.attr_4029_ @> ARRAY[17]
                                    AND o.attr_4029_ @> ARRAY[18] <> TRUE THEN '15:30 - 15:50 '
                                        WHEN o.attr_4029_ @> ARRAY[18]
                                    AND o.attr_4029_ @> ARRAY[17] <> TRUE THEN '15:50 - 16:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4029_ @> ARRAY[19, 20] THEN '16:20 - 17:00 '
                              WHEN o.attr_4029_ @> ARRAY[19]
                                    AND o.attr_4029_ @> ARRAY[20] <> TRUE THEN '16:20 - 16:40 '
                                        WHEN o.attr_4029_ @> ARRAY[20]
                                    AND o.attr_4029_ @> ARRAY[19] <> TRUE THEN '16:40 - 17:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4029_ @> ARRAY[21, 22] THEN '17:00 - 17:40 '
                              WHEN o.attr_4029_ @> ARRAY[21]
                                    AND o.attr_4029_ @> ARRAY[22] <> TRUE THEN '17:00 - 17:20 '
                                        WHEN o.attr_4029_ @> ARRAY[22]
                                    AND o.attr_4029_ @> ARRAY[21] <> TRUE THEN '17:20 - 17:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4029_ @> ARRAY[23, 24] THEN '17:40 - 18:20 '
                              WHEN o.attr_4029_ @> ARRAY[23]
                                    AND o.attr_4029_ @> ARRAY[24] <> TRUE THEN '17:40 - 18:00 '
                                        WHEN o.attr_4029_ @> ARRAY[24]
                                    AND o.attr_4029_ @> ARRAY[23] <> TRUE THEN '18:00 - 18:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4029_ @> ARRAY[25, 26] THEN '18:20 - 19:00 '
                              WHEN o.attr_4029_ @> ARRAY[25]
                                    AND o.attr_4029_ @> ARRAY[26] <> TRUE THEN '18:20 - 18:40 '
                                        WHEN o.attr_4029_ @> ARRAY[26]
                                    AND o.attr_4029_ @> ARRAY[25] <> TRUE THEN '18:40 - 19:00 '
                                        ELSE NULL
                    END
                    )
          END
        , o.attr_4073_
          ) AS sol_p
        , CONCAT(
          CASE
                    WHEN o.attr_4162_ && ARRAY[1] THEN NULL
                    ELSE CONCAT(
                    CASE
                              WHEN o.attr_4162_ @> ARRAY[2, 3]
                                    AND o.attr_4162_ @> ARRAY[4] <> TRUE THEN '08:30 - 09:10 '
                                        WHEN o.attr_4162_ @> ARRAY[3, 4]
                                    AND o.attr_4162_ @> ARRAY[2] <> TRUE THEN '08:50 - 09:30 '
                                        ELSE CONCAT(
                                        CASE
                                                  WHEN o.attr_4162_ @> ARRAY[2] THEN '08:30 - 08:50 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4162_ @> ARRAY[3] THEN '08:50 - 09:10 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4162_ @> ARRAY[4] THEN '09:10 - 09:30 '
                                                  ELSE NULL
                                        END
                                        )
                    END
                  , CASE
                              WHEN o.attr_4162_ @> ARRAY[5, 6] THEN '09:40-10:20 '
                              WHEN o.attr_4162_ @> ARRAY[5]
                                    AND o.attr_4162_ @> ARRAY[6] <> TRUE THEN '09:40 - 10:00 '
                                        WHEN o.attr_4162_ @> ARRAY[6]
                                    AND o.attr_4162_ @> ARRAY[5] <> TRUE THEN '10:00 - 10:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4162_ @> ARRAY[7, 8] THEN '10:30 - 11:10 '
                              WHEN o.attr_4162_ @> ARRAY[7]
                                    AND o.attr_4162_ @> ARRAY[8] <> TRUE THEN '10:30 - 10:50 '
                                        WHEN o.attr_4162_ @> ARRAY[8]
                                    AND o.attr_4162_ @> ARRAY[7] <> TRUE THEN '10:50 - 11:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4162_ @> ARRAY[9, 10] THEN '11:20 - 12:00 '
                              WHEN o.attr_4162_ @> ARRAY[9]
                                    AND o.attr_4162_ @> ARRAY[10] <> TRUE THEN '11:20 - 11:40 '
                                        WHEN o.attr_4162_ @> ARRAY[10]
                                    AND o.attr_4162_ @> ARRAY[9] <> TRUE THEN '11:40 - 12:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4162_ @> ARRAY[11, 12] THEN '13:00 - 13:40 '
                              WHEN o.attr_4162_ @> ARRAY[11]
                                    AND o.attr_4162_ @> ARRAY[12] <> TRUE THEN '13:00 - 13:20 '
                                        WHEN o.attr_4162_ @> ARRAY[12]
                                    AND o.attr_4162_ @> ARRAY[11] <> TRUE THEN '13:20 - 13:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4162_ @> ARRAY[13, 14] THEN '13:50 - 14:30 '
                              WHEN o.attr_4162_ @> ARRAY[13]
                                    AND o.attr_4162_ @> ARRAY[14] <> TRUE THEN '13:50 - 14:10 '
                                        WHEN o.attr_4162_ @> ARRAY[14]
                                    AND o.attr_4162_ @> ARRAY[13] <> TRUE THEN '14:10 - 14:30 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4162_ @> ARRAY[15, 16] THEN '14:40 - 15:20 '
                              WHEN o.attr_4162_ @> ARRAY[15]
                                    AND o.attr_4162_ @> ARRAY[16] <> TRUE THEN '14:40 - 15:00 '
                                        WHEN o.attr_4162_ @> ARRAY[16]
                                    AND o.attr_4162_ @> ARRAY[15] <> TRUE THEN '15:00 - 15:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4162_ @> ARRAY[17, 18] THEN '15:30 - 16:10 '
                              WHEN o.attr_4162_ @> ARRAY[17]
                                    AND o.attr_4162_ @> ARRAY[18] <> TRUE THEN '15:30 - 15:50 '
                                        WHEN o.attr_4162_ @> ARRAY[18]
                                    AND o.attr_4162_ @> ARRAY[17] <> TRUE THEN '15:50 - 16:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4162_ @> ARRAY[19, 20] THEN '16:20 - 17:00 '
                              WHEN o.attr_4162_ @> ARRAY[19]
                                    AND o.attr_4162_ @> ARRAY[20] <> TRUE THEN '16:20 - 16:40 '
                                        WHEN o.attr_4162_ @> ARRAY[20]
                                    AND o.attr_4162_ @> ARRAY[19] <> TRUE THEN '16:40 - 17:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4162_ @> ARRAY[21, 22] THEN '17:00 - 17:40 '
                              WHEN o.attr_4162_ @> ARRAY[21]
                                    AND o.attr_4162_ @> ARRAY[22] <> TRUE THEN '17:00 - 17:20 '
                                        WHEN o.attr_4162_ @> ARRAY[22]
                                    AND o.attr_4162_ @> ARRAY[21] <> TRUE THEN '17:20 - 17:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4162_ @> ARRAY[23, 24] THEN '17:40 - 18:20 '
                              WHEN o.attr_4162_ @> ARRAY[23]
                                    AND o.attr_4162_ @> ARRAY[24] <> TRUE THEN '17:40 - 18:00 '
                                        WHEN o.attr_4162_ @> ARRAY[24]
                                    AND o.attr_4162_ @> ARRAY[23] <> TRUE THEN '18:00 - 18:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4162_ @> ARRAY[25, 26] THEN '18:20 - 19:00 '
                              WHEN o.attr_4162_ @> ARRAY[25]
                                    AND o.attr_4162_ @> ARRAY[26] <> TRUE THEN '18:20 - 18:40 '
                                        WHEN o.attr_4162_ @> ARRAY[26]
                                    AND o.attr_4162_ @> ARRAY[25] <> TRUE THEN '18:40 - 19:00 '
                                        ELSE NULL
                    END
                    )
          END
        , o.attr_4164_
          ) AS girudoterapy
        , CONCAT(
          CASE
                    WHEN o.attr_4165_ && ARRAY[1] THEN NULL
                    ELSE CONCAT(
                    CASE
                              WHEN o.attr_4165_ @> ARRAY[2, 3]
                                    AND o.attr_4165_ @> ARRAY[4] <> TRUE THEN '08:30 - 09:10 '
                                        WHEN o.attr_4165_ @> ARRAY[3, 4]
                                    AND o.attr_4165_ @> ARRAY[2] <> TRUE THEN '08:50 - 09:30 '
                                        ELSE CONCAT(
                                        CASE
                                                  WHEN o.attr_4165_ @> ARRAY[2] THEN '08:30 - 08:50 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4165_ @> ARRAY[3] THEN '08:50 - 09:10 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4165_ @> ARRAY[4] THEN '09:10 - 09:30 '
                                                  ELSE NULL
                                        END
                                        )
                    END
                  , CASE
                              WHEN o.attr_4165_ @> ARRAY[5, 6] THEN '09:40-10:20 '
                              WHEN o.attr_4165_ @> ARRAY[5]
                                    AND o.attr_4165_ @> ARRAY[6] <> TRUE THEN '09:40 - 10:00 '
                                        WHEN o.attr_4165_ @> ARRAY[6]
                                    AND o.attr_4165_ @> ARRAY[5] <> TRUE THEN '10:00 - 10:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4165_ @> ARRAY[7, 8] THEN '10:30 - 11:10 '
                              WHEN o.attr_4165_ @> ARRAY[7]
                                    AND o.attr_4165_ @> ARRAY[8] <> TRUE THEN '10:30 - 10:50 '
                                        WHEN o.attr_4165_ @> ARRAY[8]
                                    AND o.attr_4165_ @> ARRAY[7] <> TRUE THEN '10:50 - 11:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4165_ @> ARRAY[9, 10] THEN '11:20 - 12:00 '
                              WHEN o.attr_4165_ @> ARRAY[9]
                                    AND o.attr_4165_ @> ARRAY[10] <> TRUE THEN '11:20 - 11:40 '
                                        WHEN o.attr_4165_ @> ARRAY[10]
                                    AND o.attr_4165_ @> ARRAY[9] <> TRUE THEN '11:40 - 12:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4165_ @> ARRAY[11, 12] THEN '13:00 - 13:40 '
                              WHEN o.attr_4165_ @> ARRAY[11]
                                    AND o.attr_4165_ @> ARRAY[12] <> TRUE THEN '13:00 - 13:20 '
                                        WHEN o.attr_4165_ @> ARRAY[12]
                                    AND o.attr_4165_ @> ARRAY[11] <> TRUE THEN '13:20 - 13:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4165_ @> ARRAY[13, 14] THEN '13:50 - 14:30 '
                              WHEN o.attr_4165_ @> ARRAY[13]
                                    AND o.attr_4165_ @> ARRAY[14] <> TRUE THEN '13:50 - 14:10 '
                                        WHEN o.attr_4165_ @> ARRAY[14]
                                    AND o.attr_4165_ @> ARRAY[13] <> TRUE THEN '14:10 - 14:30 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4165_ @> ARRAY[15, 16] THEN '14:40 - 15:20 '
                              WHEN o.attr_4165_ @> ARRAY[15]
                                    AND o.attr_4165_ @> ARRAY[16] <> TRUE THEN '14:40 - 15:00 '
                                        WHEN o.attr_4165_ @> ARRAY[16]
                                    AND o.attr_4165_ @> ARRAY[15] <> TRUE THEN '15:00 - 15:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4165_ @> ARRAY[17, 18] THEN '15:30 - 16:10 '
                              WHEN o.attr_4165_ @> ARRAY[17]
                                    AND o.attr_4165_ @> ARRAY[18] <> TRUE THEN '15:30 - 15:50 '
                                        WHEN o.attr_4165_ @> ARRAY[18]
                                    AND o.attr_4165_ @> ARRAY[17] <> TRUE THEN '15:50 - 16:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4165_ @> ARRAY[19, 20] THEN '16:20 - 17:00 '
                              WHEN o.attr_4165_ @> ARRAY[19]
                                    AND o.attr_4165_ @> ARRAY[20] <> TRUE THEN '16:20 - 16:40 '
                                        WHEN o.attr_4165_ @> ARRAY[20]
                                    AND o.attr_4165_ @> ARRAY[19] <> TRUE THEN '16:40 - 17:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4165_ @> ARRAY[21, 22] THEN '17:00 - 17:40 '
                              WHEN o.attr_4165_ @> ARRAY[21]
                                    AND o.attr_4165_ @> ARRAY[22] <> TRUE THEN '17:00 - 17:20 '
                                        WHEN o.attr_4165_ @> ARRAY[22]
                                    AND o.attr_4165_ @> ARRAY[21] <> TRUE THEN '17:20 - 17:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4165_ @> ARRAY[23, 24] THEN '17:40 - 18:20 '
                              WHEN o.attr_4165_ @> ARRAY[23]
                                    AND o.attr_4165_ @> ARRAY[24] <> TRUE THEN '17:40 - 18:00 '
                                        WHEN o.attr_4165_ @> ARRAY[24]
                                    AND o.attr_4165_ @> ARRAY[23] <> TRUE THEN '18:00 - 18:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4165_ @> ARRAY[25, 26] THEN '18:20 - 19:00 '
                              WHEN o.attr_4165_ @> ARRAY[25]
                                    AND o.attr_4165_ @> ARRAY[26] <> TRUE THEN '18:20 - 18:40 '
                                        WHEN o.attr_4165_ @> ARRAY[26]
                                    AND o.attr_4165_ @> ARRAY[25] <> TRUE THEN '18:40 - 19:00 '
                                        ELSE NULL
                    END
                    )
          END
        , o.attr_4167_
          ) AS fitoterapy
        , CONCAT(
          CASE
                    WHEN o.attr_4168_ && ARRAY[1] THEN NULL
                    ELSE CONCAT(
                    CASE
                              WHEN o.attr_4168_ @> ARRAY[2, 3]
                                    AND o.attr_4168_ @> ARRAY[4] <> TRUE THEN '08:30 - 09:10 '
                                        WHEN o.attr_4168_ @> ARRAY[3, 4]
                                    AND o.attr_4168_ @> ARRAY[2] <> TRUE THEN '08:50 - 09:30 '
                                        ELSE CONCAT(
                                        CASE
                                                  WHEN o.attr_4168_ @> ARRAY[2] THEN '08:30 - 08:50 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4168_ @> ARRAY[3] THEN '08:50 - 09:10 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4168_ @> ARRAY[4] THEN '09:10 - 09:30 '
                                                  ELSE NULL
                                        END
                                        )
                    END
                  , CASE
                              WHEN o.attr_4168_ @> ARRAY[5, 6] THEN '09:40-10:20 '
                              WHEN o.attr_4168_ @> ARRAY[5]
                                    AND o.attr_4168_ @> ARRAY[6] <> TRUE THEN '09:40 - 10:00 '
                                        WHEN o.attr_4168_ @> ARRAY[6]
                                    AND o.attr_4168_ @> ARRAY[5] <> TRUE THEN '10:00 - 10:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4168_ @> ARRAY[7, 8] THEN '10:30 - 11:10 '
                              WHEN o.attr_4168_ @> ARRAY[7]
                                    AND o.attr_4168_ @> ARRAY[8] <> TRUE THEN '10:30 - 10:50 '
                                        WHEN o.attr_4168_ @> ARRAY[8]
                                    AND o.attr_4168_ @> ARRAY[7] <> TRUE THEN '10:50 - 11:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4168_ @> ARRAY[9, 10] THEN '11:20 - 12:00 '
                              WHEN o.attr_4168_ @> ARRAY[9]
                                    AND o.attr_4168_ @> ARRAY[10] <> TRUE THEN '11:20 - 11:40 '
                                        WHEN o.attr_4168_ @> ARRAY[10]
                                    AND o.attr_4168_ @> ARRAY[9] <> TRUE THEN '11:40 - 12:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4168_ @> ARRAY[11, 12] THEN '13:00 - 13:40 '
                              WHEN o.attr_4168_ @> ARRAY[11]
                                    AND o.attr_4168_ @> ARRAY[12] <> TRUE THEN '13:00 - 13:20 '
                                        WHEN o.attr_4168_ @> ARRAY[12]
                                    AND o.attr_4168_ @> ARRAY[11] <> TRUE THEN '13:20 - 13:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4168_ @> ARRAY[13, 14] THEN '13:50 - 14:30 '
                              WHEN o.attr_4168_ @> ARRAY[13]
                                    AND o.attr_4168_ @> ARRAY[14] <> TRUE THEN '13:50 - 14:10 '
                                        WHEN o.attr_4168_ @> ARRAY[14]
                                    AND o.attr_4168_ @> ARRAY[13] <> TRUE THEN '14:10 - 14:30 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4168_ @> ARRAY[15, 16] THEN '14:40 - 15:20 '
                              WHEN o.attr_4168_ @> ARRAY[15]
                                    AND o.attr_4168_ @> ARRAY[16] <> TRUE THEN '14:40 - 15:00 '
                                        WHEN o.attr_4168_ @> ARRAY[16]
                                    AND o.attr_4168_ @> ARRAY[15] <> TRUE THEN '15:00 - 15:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4168_ @> ARRAY[17, 18] THEN '15:30 - 16:10 '
                              WHEN o.attr_4168_ @> ARRAY[17]
                                    AND o.attr_4168_ @> ARRAY[18] <> TRUE THEN '15:30 - 15:50 '
                                        WHEN o.attr_4168_ @> ARRAY[18]
                                    AND o.attr_4168_ @> ARRAY[17] <> TRUE THEN '15:50 - 16:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4168_ @> ARRAY[19, 20] THEN '16:20 - 17:00 '
                              WHEN o.attr_4168_ @> ARRAY[19]
                                    AND o.attr_4168_ @> ARRAY[20] <> TRUE THEN '16:20 - 16:40 '
                                        WHEN o.attr_4168_ @> ARRAY[20]
                                    AND o.attr_4168_ @> ARRAY[19] <> TRUE THEN '16:40 - 17:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4168_ @> ARRAY[21, 22] THEN '17:00 - 17:40 '
                              WHEN o.attr_4168_ @> ARRAY[21]
                                    AND o.attr_4168_ @> ARRAY[22] <> TRUE THEN '17:00 - 17:20 '
                                        WHEN o.attr_4168_ @> ARRAY[22]
                                    AND o.attr_4168_ @> ARRAY[21] <> TRUE THEN '17:20 - 17:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4168_ @> ARRAY[23, 24] THEN '17:40 - 18:20 '
                              WHEN o.attr_4168_ @> ARRAY[23]
                                    AND o.attr_4168_ @> ARRAY[24] <> TRUE THEN '17:40 - 18:00 '
                                        WHEN o.attr_4168_ @> ARRAY[24]
                                    AND o.attr_4168_ @> ARRAY[23] <> TRUE THEN '18:00 - 18:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4168_ @> ARRAY[25, 26] THEN '18:20 - 19:00 '
                              WHEN o.attr_4168_ @> ARRAY[25]
                                    AND o.attr_4168_ @> ARRAY[26] <> TRUE THEN '18:20 - 18:40 '
                                        WHEN o.attr_4168_ @> ARRAY[26]
                                    AND o.attr_4168_ @> ARRAY[25] <> TRUE THEN '18:40 - 19:00 '
                                        ELSE NULL
                    END
                    )
          END
        , o.attr_4170_
          ) AS kislorod_cocteil
        , CONCAT(
          CASE
                    WHEN o.attr_4251_ && ARRAY[1] THEN NULL
                    ELSE CONCAT(
                    CASE
                              WHEN o.attr_4251_ @> ARRAY[2, 3]
                                    AND o.attr_4251_ @> ARRAY[4] <> TRUE THEN '08:30 - 09:10 '
                                        WHEN o.attr_4251_ @> ARRAY[3, 4]
                                    AND o.attr_4251_ @> ARRAY[2] <> TRUE THEN '08:50 - 09:30 '
                                        ELSE CONCAT(
                                        CASE
                                                  WHEN o.attr_4251_ @> ARRAY[2] THEN '08:30 - 08:50 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4251_ @> ARRAY[3] THEN '08:50 - 09:10 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4251_ @> ARRAY[4] THEN '09:10 - 09:30 '
                                                  ELSE NULL
                                        END
                                        )
                    END
                  , CASE
                              WHEN o.attr_4251_ @> ARRAY[5, 6] THEN '09:40-10:20 '
                              WHEN o.attr_4251_ @> ARRAY[5]
                                    AND o.attr_4251_ @> ARRAY[6] <> TRUE THEN '09:40 - 10:00 '
                                        WHEN o.attr_4251_ @> ARRAY[6]
                                    AND o.attr_4251_ @> ARRAY[5] <> TRUE THEN '10:00 - 10:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4251_ @> ARRAY[7, 8] THEN '10:30 - 11:10 '
                              WHEN o.attr_4251_ @> ARRAY[7]
                                    AND o.attr_4251_ @> ARRAY[8] <> TRUE THEN '10:30 - 10:50 '
                                        WHEN o.attr_4251_ @> ARRAY[8]
                                    AND o.attr_4251_ @> ARRAY[7] <> TRUE THEN '10:50 - 11:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4251_ @> ARRAY[9, 10] THEN '11:20 - 12:00 '
                              WHEN o.attr_4251_ @> ARRAY[9]
                                    AND o.attr_4251_ @> ARRAY[10] <> TRUE THEN '11:20 - 11:40 '
                                        WHEN o.attr_4251_ @> ARRAY[10]
                                    AND o.attr_4251_ @> ARRAY[9] <> TRUE THEN '11:40 - 12:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4251_ @> ARRAY[11, 12] THEN '13:00 - 13:40 '
                              WHEN o.attr_4251_ @> ARRAY[11]
                                    AND o.attr_4251_ @> ARRAY[12] <> TRUE THEN '13:00 - 13:20 '
                                        WHEN o.attr_4251_ @> ARRAY[12]
                                    AND o.attr_4251_ @> ARRAY[11] <> TRUE THEN '13:20 - 13:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4251_ @> ARRAY[13, 14] THEN '13:50 - 14:30 '
                              WHEN o.attr_4251_ @> ARRAY[13]
                                    AND o.attr_4251_ @> ARRAY[14] <> TRUE THEN '13:50 - 14:10 '
                                        WHEN o.attr_4251_ @> ARRAY[14]
                                    AND o.attr_4251_ @> ARRAY[13] <> TRUE THEN '14:10 - 14:30 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4251_ @> ARRAY[15, 16] THEN '14:40 - 15:20 '
                              WHEN o.attr_4251_ @> ARRAY[15]
                                    AND o.attr_4251_ @> ARRAY[16] <> TRUE THEN '14:40 - 15:00 '
                                        WHEN o.attr_4251_ @> ARRAY[16]
                                    AND o.attr_4251_ @> ARRAY[15] <> TRUE THEN '15:00 - 15:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4251_ @> ARRAY[17, 18] THEN '15:30 - 16:10 '
                              WHEN o.attr_4251_ @> ARRAY[17]
                                    AND o.attr_4251_ @> ARRAY[18] <> TRUE THEN '15:30 - 15:50 '
                                        WHEN o.attr_4251_ @> ARRAY[18]
                                    AND o.attr_4251_ @> ARRAY[17] <> TRUE THEN '15:50 - 16:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4251_ @> ARRAY[19, 20] THEN '16:20 - 17:00 '
                              WHEN o.attr_4251_ @> ARRAY[19]
                                    AND o.attr_4251_ @> ARRAY[20] <> TRUE THEN '16:20 - 16:40 '
                                        WHEN o.attr_4251_ @> ARRAY[20]
                                    AND o.attr_4251_ @> ARRAY[19] <> TRUE THEN '16:40 - 17:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4251_ @> ARRAY[21, 22] THEN '17:00 - 17:40 '
                              WHEN o.attr_4251_ @> ARRAY[21]
                                    AND o.attr_4251_ @> ARRAY[22] <> TRUE THEN '17:00 - 17:20 '
                                        WHEN o.attr_4251_ @> ARRAY[22]
                                    AND o.attr_4251_ @> ARRAY[21] <> TRUE THEN '17:20 - 17:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4251_ @> ARRAY[23, 24] THEN '17:40 - 18:20 '
                              WHEN o.attr_4251_ @> ARRAY[23]
                                    AND o.attr_4251_ @> ARRAY[24] <> TRUE THEN '17:40 - 18:00 '
                                        WHEN o.attr_4251_ @> ARRAY[24]
                                    AND o.attr_4251_ @> ARRAY[23] <> TRUE THEN '18:00 - 18:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4251_ @> ARRAY[25, 26] THEN '18:20 - 19:00 '
                              WHEN o.attr_4251_ @> ARRAY[25]
                                    AND o.attr_4251_ @> ARRAY[26] <> TRUE THEN '18:20 - 18:40 '
                                        WHEN o.attr_4251_ @> ARRAY[26]
                                    AND o.attr_4251_ @> ARRAY[25] <> TRUE THEN '18:40 - 19:00 '
                                        ELSE NULL
                    END
                    )
          END
        , o.attr_4253_
          ) AS soc_cult
        , CONCAT(
          CASE
                    WHEN o.attr_4443_ && ARRAY[1] THEN NULL
                    ELSE CONCAT(
                    CASE
                              WHEN o.attr_4443_ @> ARRAY[2, 3]
                                    AND o.attr_4443_ @> ARRAY[4] <> TRUE THEN '08:30 - 09:10 '
                                        WHEN o.attr_4443_ @> ARRAY[3, 4]
                                    AND o.attr_4443_ @> ARRAY[2] <> TRUE THEN '08:50 - 09:30 '
                                        ELSE CONCAT(
                                        CASE
                                                  WHEN o.attr_4443_ @> ARRAY[2] THEN '08:30 - 08:50 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4443_ @> ARRAY[3] THEN '08:50 - 09:10 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4443_ @> ARRAY[4] THEN '09:10 - 09:30 '
                                                  ELSE NULL
                                        END
                                        )
                    END
                  , CASE
                              WHEN o.attr_4443_ @> ARRAY[5, 6] THEN '09:40-10:20 '
                              WHEN o.attr_4443_ @> ARRAY[5]
                                    AND o.attr_4443_ @> ARRAY[6] <> TRUE THEN '09:40 - 10:00 '
                                        WHEN o.attr_4443_ @> ARRAY[6]
                                    AND o.attr_4443_ @> ARRAY[5] <> TRUE THEN '10:00 - 10:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4443_ @> ARRAY[7, 8] THEN '10:30 - 11:10 '
                              WHEN o.attr_4443_ @> ARRAY[7]
                                    AND o.attr_4443_ @> ARRAY[8] <> TRUE THEN '10:30 - 10:50 '
                                        WHEN o.attr_4443_ @> ARRAY[8]
                                    AND o.attr_4443_ @> ARRAY[7] <> TRUE THEN '10:50 - 11:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4443_ @> ARRAY[9, 10] THEN '11:20 - 12:00 '
                              WHEN o.attr_4443_ @> ARRAY[9]
                                    AND o.attr_4443_ @> ARRAY[10] <> TRUE THEN '11:20 - 11:40 '
                                        WHEN o.attr_4443_ @> ARRAY[10]
                                    AND o.attr_4443_ @> ARRAY[9] <> TRUE THEN '11:40 - 12:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4443_ @> ARRAY[11, 12] THEN '13:00 - 13:40 '
                              WHEN o.attr_4443_ @> ARRAY[11]
                                    AND o.attr_4443_ @> ARRAY[12] <> TRUE THEN '13:00 - 13:20 '
                                        WHEN o.attr_4443_ @> ARRAY[12]
                                    AND o.attr_4443_ @> ARRAY[11] <> TRUE THEN '13:20 - 13:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4443_ @> ARRAY[13, 14] THEN '13:50 - 14:30 '
                              WHEN o.attr_4443_ @> ARRAY[13]
                                    AND o.attr_4443_ @> ARRAY[14] <> TRUE THEN '13:50 - 14:10 '
                                        WHEN o.attr_4443_ @> ARRAY[14]
                                    AND o.attr_4443_ @> ARRAY[13] <> TRUE THEN '14:10 - 14:30 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4443_ @> ARRAY[15, 16] THEN '14:40 - 15:20 '
                              WHEN o.attr_4443_ @> ARRAY[15]
                                    AND o.attr_4443_ @> ARRAY[16] <> TRUE THEN '14:40 - 15:00 '
                                        WHEN o.attr_4443_ @> ARRAY[16]
                                    AND o.attr_4443_ @> ARRAY[15] <> TRUE THEN '15:00 - 15:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4443_ @> ARRAY[17, 18] THEN '15:30 - 16:10 '
                              WHEN o.attr_4443_ @> ARRAY[17]
                                    AND o.attr_4443_ @> ARRAY[18] <> TRUE THEN '15:30 - 15:50 '
                                        WHEN o.attr_4443_ @> ARRAY[18]
                                    AND o.attr_4443_ @> ARRAY[17] <> TRUE THEN '15:50 - 16:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4443_ @> ARRAY[19, 20] THEN '16:20 - 17:00 '
                              WHEN o.attr_4443_ @> ARRAY[19]
                                    AND o.attr_4443_ @> ARRAY[20] <> TRUE THEN '16:20 - 16:40 '
                                        WHEN o.attr_4443_ @> ARRAY[20]
                                    AND o.attr_4443_ @> ARRAY[19] <> TRUE THEN '16:40 - 17:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4443_ @> ARRAY[21, 22] THEN '17:00 - 17:40 '
                              WHEN o.attr_4443_ @> ARRAY[21]
                                    AND o.attr_4443_ @> ARRAY[22] <> TRUE THEN '17:00 - 17:20 '
                                        WHEN o.attr_4443_ @> ARRAY[22]
                                    AND o.attr_4443_ @> ARRAY[21] <> TRUE THEN '17:20 - 17:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4443_ @> ARRAY[23, 24] THEN '17:40 - 18:20 '
                              WHEN o.attr_4443_ @> ARRAY[23]
                                    AND o.attr_4443_ @> ARRAY[24] <> TRUE THEN '17:40 - 18:00 '
                                        WHEN o.attr_4443_ @> ARRAY[24]
                                    AND o.attr_4443_ @> ARRAY[23] <> TRUE THEN '18:00 - 18:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4443_ @> ARRAY[25, 26] THEN '18:20 - 19:00 '
                              WHEN o.attr_4443_ @> ARRAY[25]
                                    AND o.attr_4443_ @> ARRAY[26] <> TRUE THEN '18:20 - 18:40 '
                                        WHEN o.attr_4443_ @> ARRAY[26]
                                    AND o.attr_4443_ @> ARRAY[25] <> TRUE THEN '18:40 - 19:00 '
                                        ELSE NULL
                    END
                    )
          END
        , o.attr_4445_
          ) AS inhal
        , CONCAT(
          CASE
                    WHEN o.attr_4446_ && ARRAY[1] THEN NULL
                    ELSE CONCAT(
                    CASE
                              WHEN o.attr_4446_ @> ARRAY[2, 3]
                                    AND o.attr_4446_ @> ARRAY[4] <> TRUE THEN '08:30 - 09:10 '
                                        WHEN o.attr_4446_ @> ARRAY[3, 4]
                                    AND o.attr_4446_ @> ARRAY[2] <> TRUE THEN '08:50 - 09:30 '
                                        ELSE CONCAT(
                                        CASE
                                                  WHEN o.attr_4446_ @> ARRAY[2] THEN '08:30 - 08:50 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4446_ @> ARRAY[3] THEN '08:50 - 09:10 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4446_ @> ARRAY[4] THEN '09:10 - 09:30 '
                                                  ELSE NULL
                                        END
                                        )
                    END
                  , CASE
                              WHEN o.attr_4446_ @> ARRAY[5, 6] THEN '09:40-10:20 '
                              WHEN o.attr_4446_ @> ARRAY[5]
                                    AND o.attr_4446_ @> ARRAY[6] <> TRUE THEN '09:40 - 10:00 '
                                        WHEN o.attr_4446_ @> ARRAY[6]
                                    AND o.attr_4446_ @> ARRAY[5] <> TRUE THEN '10:00 - 10:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4446_ @> ARRAY[7, 8] THEN '10:30 - 11:10 '
                              WHEN o.attr_4446_ @> ARRAY[7]
                                    AND o.attr_4446_ @> ARRAY[8] <> TRUE THEN '10:30 - 10:50 '
                                        WHEN o.attr_4446_ @> ARRAY[8]
                                    AND o.attr_4446_ @> ARRAY[7] <> TRUE THEN '10:50 - 11:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4446_ @> ARRAY[9, 10] THEN '11:20 - 12:00 '
                              WHEN o.attr_4446_ @> ARRAY[9]
                                    AND o.attr_4446_ @> ARRAY[10] <> TRUE THEN '11:20 - 11:40 '
                                        WHEN o.attr_4446_ @> ARRAY[10]
                                    AND o.attr_4446_ @> ARRAY[9] <> TRUE THEN '11:40 - 12:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4446_ @> ARRAY[11, 12] THEN '13:00 - 13:40 '
                              WHEN o.attr_4446_ @> ARRAY[11]
                                    AND o.attr_4446_ @> ARRAY[12] <> TRUE THEN '13:00 - 13:20 '
                                        WHEN o.attr_4446_ @> ARRAY[12]
                                    AND o.attr_4446_ @> ARRAY[11] <> TRUE THEN '13:20 - 13:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4446_ @> ARRAY[13, 14] THEN '13:50 - 14:30 '
                              WHEN o.attr_4446_ @> ARRAY[13]
                                    AND o.attr_4446_ @> ARRAY[14] <> TRUE THEN '13:50 - 14:10 '
                                        WHEN o.attr_4446_ @> ARRAY[14]
                                    AND o.attr_4446_ @> ARRAY[13] <> TRUE THEN '14:10 - 14:30 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4446_ @> ARRAY[15, 16] THEN '14:40 - 15:20 '
                              WHEN o.attr_4446_ @> ARRAY[15]
                                    AND o.attr_4446_ @> ARRAY[16] <> TRUE THEN '14:40 - 15:00 '
                                        WHEN o.attr_4446_ @> ARRAY[16]
                                    AND o.attr_4446_ @> ARRAY[15] <> TRUE THEN '15:00 - 15:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4446_ @> ARRAY[17, 18] THEN '15:30 - 16:10 '
                              WHEN o.attr_4446_ @> ARRAY[17]
                                    AND o.attr_4446_ @> ARRAY[18] <> TRUE THEN '15:30 - 15:50 '
                                        WHEN o.attr_4446_ @> ARRAY[18]
                                    AND o.attr_4446_ @> ARRAY[17] <> TRUE THEN '15:50 - 16:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4446_ @> ARRAY[19, 20] THEN '16:20 - 17:00 '
                              WHEN o.attr_4446_ @> ARRAY[19]
                                    AND o.attr_4446_ @> ARRAY[20] <> TRUE THEN '16:20 - 16:40 '
                                        WHEN o.attr_4446_ @> ARRAY[20]
                                    AND o.attr_4446_ @> ARRAY[19] <> TRUE THEN '16:40 - 17:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4446_ @> ARRAY[21, 22] THEN '17:00 - 17:40 '
                              WHEN o.attr_4446_ @> ARRAY[21]
                                    AND o.attr_4446_ @> ARRAY[22] <> TRUE THEN '17:00 - 17:20 '
                                        WHEN o.attr_4446_ @> ARRAY[22]
                                    AND o.attr_4446_ @> ARRAY[21] <> TRUE THEN '17:20 - 17:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4446_ @> ARRAY[23, 24] THEN '17:40 - 18:20 '
                              WHEN o.attr_4446_ @> ARRAY[23]
                                    AND o.attr_4446_ @> ARRAY[24] <> TRUE THEN '17:40 - 18:00 '
                                        WHEN o.attr_4446_ @> ARRAY[24]
                                    AND o.attr_4446_ @> ARRAY[23] <> TRUE THEN '18:00 - 18:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4446_ @> ARRAY[25, 26] THEN '18:20 - 19:00 '
                              WHEN o.attr_4446_ @> ARRAY[25]
                                    AND o.attr_4446_ @> ARRAY[26] <> TRUE THEN '18:20 - 18:40 '
                                        WHEN o.attr_4446_ @> ARRAY[26]
                                    AND o.attr_4446_ @> ARRAY[25] <> TRUE THEN '18:40 - 19:00 '
                                        ELSE NULL
                    END
                    )
          END
        , o.attr_4448_
          ) AS presso
        , CONCAT(
          CASE
                    WHEN o.attr_4455_ && ARRAY[1] THEN NULL
                    ELSE CONCAT(
                    CASE
                              WHEN o.attr_4455_ @> ARRAY[2, 3]
                                    AND o.attr_4455_ @> ARRAY[4] <> TRUE THEN '08:30 - 09:10 '
                                        WHEN o.attr_4455_ @> ARRAY[3, 4]
                                    AND o.attr_4455_ @> ARRAY[2] <> TRUE THEN '08:50 - 09:30 '
                                        ELSE CONCAT(
                                        CASE
                                                  WHEN o.attr_4455_ @> ARRAY[2] THEN '08:30 - 08:50 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4455_ @> ARRAY[3] THEN '08:50 - 09:10 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4455_ @> ARRAY[4] THEN '09:10 - 09:30 '
                                                  ELSE NULL
                                        END
                                        )
                    END
                  , CASE
                              WHEN o.attr_4455_ @> ARRAY[5, 6] THEN '09:40-10:20 '
                              WHEN o.attr_4455_ @> ARRAY[5]
                                    AND o.attr_4455_ @> ARRAY[6] <> TRUE THEN '09:40 - 10:00 '
                                        WHEN o.attr_4455_ @> ARRAY[6]
                                    AND o.attr_4455_ @> ARRAY[5] <> TRUE THEN '10:00 - 10:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4455_ @> ARRAY[7, 8] THEN '10:30 - 11:10 '
                              WHEN o.attr_4455_ @> ARRAY[7]
                                    AND o.attr_4455_ @> ARRAY[8] <> TRUE THEN '10:30 - 10:50 '
                                        WHEN o.attr_4455_ @> ARRAY[8]
                                    AND o.attr_4455_ @> ARRAY[7] <> TRUE THEN '10:50 - 11:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4455_ @> ARRAY[9, 10] THEN '11:20 - 12:00 '
                              WHEN o.attr_4455_ @> ARRAY[9]
                                    AND o.attr_4455_ @> ARRAY[10] <> TRUE THEN '11:20 - 11:40 '
                                        WHEN o.attr_4455_ @> ARRAY[10]
                                    AND o.attr_4455_ @> ARRAY[9] <> TRUE THEN '11:40 - 12:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4455_ @> ARRAY[11, 12] THEN '13:00 - 13:40 '
                              WHEN o.attr_4455_ @> ARRAY[11]
                                    AND o.attr_4455_ @> ARRAY[12] <> TRUE THEN '13:00 - 13:20 '
                                        WHEN o.attr_4455_ @> ARRAY[12]
                                    AND o.attr_4455_ @> ARRAY[11] <> TRUE THEN '13:20 - 13:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4455_ @> ARRAY[13, 14] THEN '13:50 - 14:30 '
                              WHEN o.attr_4455_ @> ARRAY[13]
                                    AND o.attr_4455_ @> ARRAY[14] <> TRUE THEN '13:50 - 14:10 '
                                        WHEN o.attr_4455_ @> ARRAY[14]
                                    AND o.attr_4455_ @> ARRAY[13] <> TRUE THEN '14:10 - 14:30 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4455_ @> ARRAY[15, 16] THEN '14:40 - 15:20 '
                              WHEN o.attr_4455_ @> ARRAY[15]
                                    AND o.attr_4455_ @> ARRAY[16] <> TRUE THEN '14:40 - 15:00 '
                                        WHEN o.attr_4455_ @> ARRAY[16]
                                    AND o.attr_4455_ @> ARRAY[15] <> TRUE THEN '15:00 - 15:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4455_ @> ARRAY[17, 18] THEN '15:30 - 16:10 '
                              WHEN o.attr_4455_ @> ARRAY[17]
                                    AND o.attr_4455_ @> ARRAY[18] <> TRUE THEN '15:30 - 15:50 '
                                        WHEN o.attr_4455_ @> ARRAY[18]
                                    AND o.attr_4455_ @> ARRAY[17] <> TRUE THEN '15:50 - 16:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4455_ @> ARRAY[19, 20] THEN '16:20 - 17:00 '
                              WHEN o.attr_4455_ @> ARRAY[19]
                                    AND o.attr_4455_ @> ARRAY[20] <> TRUE THEN '16:20 - 16:40 '
                                        WHEN o.attr_4455_ @> ARRAY[20]
                                    AND o.attr_4455_ @> ARRAY[19] <> TRUE THEN '16:40 - 17:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4455_ @> ARRAY[21, 22] THEN '17:00 - 17:40 '
                              WHEN o.attr_4455_ @> ARRAY[21]
                                    AND o.attr_4455_ @> ARRAY[22] <> TRUE THEN '17:00 - 17:20 '
                                        WHEN o.attr_4455_ @> ARRAY[22]
                                    AND o.attr_4455_ @> ARRAY[21] <> TRUE THEN '17:20 - 17:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4455_ @> ARRAY[23, 24] THEN '17:40 - 18:20 '
                              WHEN o.attr_4455_ @> ARRAY[23]
                                    AND o.attr_4455_ @> ARRAY[24] <> TRUE THEN '17:40 - 18:00 '
                                        WHEN o.attr_4455_ @> ARRAY[24]
                                    AND o.attr_4455_ @> ARRAY[23] <> TRUE THEN '18:00 - 18:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4455_ @> ARRAY[25, 26] THEN '18:20 - 19:00 '
                              WHEN o.attr_4455_ @> ARRAY[25]
                                    AND o.attr_4455_ @> ARRAY[26] <> TRUE THEN '18:20 - 18:40 '
                                        WHEN o.attr_4455_ @> ARRAY[26]
                                    AND o.attr_4455_ @> ARRAY[25] <> TRUE THEN '18:40 - 19:00 '
                                        ELSE NULL
                    END
                    )
          END
        , o.attr_4457_
          ) AS dry_needle
        , CONCAT(
          CASE
                    WHEN o.attr_4458_ && ARRAY[1] THEN NULL
                    ELSE CONCAT(
                    CASE
                              WHEN o.attr_4458_ @> ARRAY[2, 3]
                                    AND o.attr_4458_ @> ARRAY[4] <> TRUE THEN '08:30 - 09:10 '
                                        WHEN o.attr_4458_ @> ARRAY[3, 4]
                                    AND o.attr_4458_ @> ARRAY[2] <> TRUE THEN '08:50 - 09:30 '
                                        ELSE CONCAT(
                                        CASE
                                                  WHEN o.attr_4458_ @> ARRAY[2] THEN '08:30 - 08:50 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4458_ @> ARRAY[3] THEN '08:50 - 09:10 '
                                                  ELSE NULL
                                        END
                                      , CASE
                                                  WHEN o.attr_4458_ @> ARRAY[4] THEN '09:10 - 09:30 '
                                                  ELSE NULL
                                        END
                                        )
                    END
                  , CASE
                              WHEN o.attr_4458_ @> ARRAY[5, 6] THEN '09:40-10:20 '
                              WHEN o.attr_4458_ @> ARRAY[5]
                                    AND o.attr_4458_ @> ARRAY[6] <> TRUE THEN '09:40 - 10:00 '
                                        WHEN o.attr_4458_ @> ARRAY[6]
                                    AND o.attr_4458_ @> ARRAY[5] <> TRUE THEN '10:00 - 10:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4458_ @> ARRAY[7, 8] THEN '10:30 - 11:10 '
                              WHEN o.attr_4458_ @> ARRAY[7]
                                    AND o.attr_4458_ @> ARRAY[8] <> TRUE THEN '10:30 - 10:50 '
                                        WHEN o.attr_4458_ @> ARRAY[8]
                                    AND o.attr_4458_ @> ARRAY[7] <> TRUE THEN '10:50 - 11:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4458_ @> ARRAY[9, 10] THEN '11:20 - 12:00 '
                              WHEN o.attr_4458_ @> ARRAY[9]
                                    AND o.attr_4458_ @> ARRAY[10] <> TRUE THEN '11:20 - 11:40 '
                                        WHEN o.attr_4458_ @> ARRAY[10]
                                    AND o.attr_4458_ @> ARRAY[9] <> TRUE THEN '11:40 - 12:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4458_ @> ARRAY[11, 12] THEN '13:00 - 13:40 '
                              WHEN o.attr_4458_ @> ARRAY[11]
                                    AND o.attr_4458_ @> ARRAY[12] <> TRUE THEN '13:00 - 13:20 '
                                        WHEN o.attr_4458_ @> ARRAY[12]
                                    AND o.attr_4458_ @> ARRAY[11] <> TRUE THEN '13:20 - 13:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4458_ @> ARRAY[13, 14] THEN '13:50 - 14:30 '
                              WHEN o.attr_4458_ @> ARRAY[13]
                                    AND o.attr_4458_ @> ARRAY[14] <> TRUE THEN '13:50 - 14:10 '
                                        WHEN o.attr_4458_ @> ARRAY[14]
                                    AND o.attr_4458_ @> ARRAY[13] <> TRUE THEN '14:10 - 14:30 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4458_ @> ARRAY[15, 16] THEN '14:40 - 15:20 '
                              WHEN o.attr_4458_ @> ARRAY[15]
                                    AND o.attr_4458_ @> ARRAY[16] <> TRUE THEN '14:40 - 15:00 '
                                        WHEN o.attr_4458_ @> ARRAY[16]
                                    AND o.attr_4458_ @> ARRAY[15] <> TRUE THEN '15:00 - 15:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4458_ @> ARRAY[17, 18] THEN '15:30 - 16:10 '
                              WHEN o.attr_4458_ @> ARRAY[17]
                                    AND o.attr_4458_ @> ARRAY[18] <> TRUE THEN '15:30 - 15:50 '
                                        WHEN o.attr_4458_ @> ARRAY[18]
                                    AND o.attr_4458_ @> ARRAY[17] <> TRUE THEN '15:50 - 16:10 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4458_ @> ARRAY[19, 20] THEN '16:20 - 17:00 '
                              WHEN o.attr_4458_ @> ARRAY[19]
                                    AND o.attr_4458_ @> ARRAY[20] <> TRUE THEN '16:20 - 16:40 '
                                        WHEN o.attr_4458_ @> ARRAY[20]
                                    AND o.attr_4458_ @> ARRAY[19] <> TRUE THEN '16:40 - 17:00 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4458_ @> ARRAY[21, 22] THEN '17:00 - 17:40 '
                              WHEN o.attr_4458_ @> ARRAY[21]
                                    AND o.attr_4458_ @> ARRAY[22] <> TRUE THEN '17:00 - 17:20 '
                                        WHEN o.attr_4458_ @> ARRAY[22]
                                    AND o.attr_4458_ @> ARRAY[21] <> TRUE THEN '17:20 - 17:40 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4458_ @> ARRAY[23, 24] THEN '17:40 - 18:20 '
                              WHEN o.attr_4458_ @> ARRAY[23]
                                    AND o.attr_4458_ @> ARRAY[24] <> TRUE THEN '17:40 - 18:00 '
                                        WHEN o.attr_4458_ @> ARRAY[24]
                                    AND o.attr_4458_ @> ARRAY[23] <> TRUE THEN '18:00 - 18:20 '
                                        ELSE NULL
                    END
                  , CASE
                              WHEN o.attr_4458_ @> ARRAY[25, 26] THEN '18:20 - 19:00 '
                              WHEN o.attr_4458_ @> ARRAY[25]
                                    AND o.attr_4458_ @> ARRAY[26] <> TRUE THEN '18:20 - 18:40 '
                                        WHEN o.attr_4458_ @> ARRAY[26]
                                    AND o.attr_4458_ @> ARRAY[25] <> TRUE THEN '18:40 - 19:00 '
                                        ELSE NULL
                    END
                    )
          END
        , o.attr_4460_
          ) AS vtes
        , fio_pac.attr_1985_ AS fio
        , nomer.attr_135_ AS nom_and_category
     FROM registry.object_4000_ o
LEFT JOIN registry.object_303_ hist ON o.attr_4005_ = hist.id
LEFT JOIN registry.object_102_ zaezd ON hist.attr_765_ = zaezd.id
LEFT JOIN registry.object_45_ fio_pac ON o.attr_4004_ = fio_pac.id
      AND fio_pac.is_deleted <> TRUE
LEFT JOIN registry.object_127_ nomer ON zaezd.attr_117_ = nomer.id
      AND nomer.is_deleted <> TRUE
    WHERE o.is_deleted <> TRUE
      AND o.attr_4032_ = '{day_rasp}'
 ORDER BY fio_pac.attr_1985_