    ( SELECT array_to_string(array_agg(concat(proc_for_rasp.attr_695_, ' -  ', sotr2_rasp.attr_1984_, '',
                CASE
                    WHEN ((hist_rasp.attr_2319_ IS TRUE) AND (hist_rasp.attr_2320_ IS NOT TRUE)) THEN 'с 8:30 до 8:50'::text
                    ELSE
                    CASE
                        WHEN ((hist_rasp.attr_2319_ IS TRUE) AND (hist_rasp.attr_2320_ IS TRUE)) THEN 'c 8:30 до 9:10'::text
                        ELSE
                        CASE
                            WHEN ((hist_rasp.attr_2320_ IS TRUE) AND (hist_rasp.attr_2321_ IS NOT TRUE)) THEN 'с 8:50 до 9:10'::text
                            ELSE
                            CASE
                                WHEN ((hist_rasp.attr_2320_ IS TRUE) AND (hist_rasp.attr_2321_ IS TRUE)) THEN 'c 8:50 до 9:30'::text
                                ELSE
                                CASE
                                    WHEN ((hist_rasp.attr_2321_ IS TRUE) AND (hist_rasp.attr_2336_ IS NOT TRUE)) THEN 'с 9:10 до 9:30'::text
                                    ELSE
                                    CASE
WHEN ((hist_rasp.attr_2321_ IS TRUE) AND (hist_rasp.attr_2336_ IS TRUE)) THEN 'c 9:10 до 10:00'::text
ELSE
CASE
 WHEN ((hist_rasp.attr_2336_ IS TRUE) AND (hist_rasp.attr_2337_ IS NOT TRUE)) THEN 'с 9:40 до 10:00'::text
 ELSE
 CASE
  WHEN ((hist_rasp.attr_2336_ IS TRUE) AND (hist_rasp.attr_2337_ IS TRUE)) THEN 'c 9:40 до 10:20'::text
  ELSE
  CASE
   WHEN ((hist_rasp.attr_2337_ IS TRUE) AND (hist_rasp.attr_2338_ IS NOT TRUE)) THEN 'с 10:00 до 10:20'::text
   ELSE
   CASE
    WHEN ((hist_rasp.attr_2337_ IS TRUE) AND (hist_rasp.attr_2338_ IS TRUE)) THEN 'c 10:00 до 10:50'::text
    ELSE
    CASE
     WHEN ((hist_rasp.attr_2338_ IS TRUE) AND (hist_rasp.attr_2339_ IS NOT TRUE)) THEN 'с 10:30 до 10:50'::text
     ELSE
     CASE
      WHEN ((hist_rasp.attr_2338_ IS TRUE) AND (hist_rasp.attr_2339_ IS TRUE)) THEN 'c 10:30 до 11:10'::text
      ELSE
      CASE
       WHEN ((hist_rasp.attr_2339_ IS TRUE) AND (hist_rasp.attr_2340_ IS NOT TRUE)) THEN 'с 10:50 до 11:10'::text
       ELSE
       CASE
        WHEN ((hist_rasp.attr_2339_ IS TRUE) AND (hist_rasp.attr_2340_ IS TRUE)) THEN 'c 10:50 до 11:40'::text
        ELSE
        CASE
         WHEN ((hist_rasp.attr_2340_ IS TRUE) AND (hist_rasp.attr_2341_ IS NOT TRUE)) THEN 'с 11:20 до 11:40'::text
         ELSE
         CASE
          WHEN ((hist_rasp.attr_2340_ IS TRUE) AND (hist_rasp.attr_2341_ IS TRUE)) THEN 'c 11:20 до 12:00'::text
          ELSE
          CASE
           WHEN ((hist_rasp.attr_2341_ IS TRUE) AND (hist_rasp.attr_2342_ IS NOT TRUE)) THEN 'с 11:40 до 12:00'::text
           ELSE
           CASE
            WHEN ((hist_rasp.attr_2341_ IS TRUE) AND (hist_rasp.attr_2342_ IS TRUE)) THEN 'c 11:40 до 13:20'::text
            ELSE
            CASE
             WHEN ((hist_rasp.attr_2342_ IS TRUE) AND (hist_rasp.attr_2343_ IS NOT TRUE)) THEN 'с 13:00 до 13:20'::text
             ELSE
             CASE
              WHEN ((hist_rasp.attr_2342_ IS TRUE) AND (hist_rasp.attr_2343_ IS TRUE)) THEN 'c 13:00 до 13:40'::text
              ELSE
              CASE
               WHEN ((hist_rasp.attr_2343_ IS TRUE) AND (hist_rasp.attr_2344_ IS NOT TRUE)) THEN 'с 13:20 до 13:40'::text
               ELSE
               CASE
                WHEN ((hist_rasp.attr_2343_ IS TRUE) AND (hist_rasp.attr_2344_ IS TRUE)) THEN 'c 13:20 до 14:10'::text
                ELSE
                CASE
                 WHEN ((hist_rasp.attr_2344_ IS TRUE) AND (hist_rasp.attr_2345_ IS NOT TRUE)) THEN 'с 13:50 до 14:10'::text
                 ELSE
                 CASE
                  WHEN ((hist_rasp.attr_2344_ IS TRUE) AND (hist_rasp.attr_2345_ IS TRUE)) THEN 'c 13:50 до 14:30'::text
                  ELSE
                  CASE
                   WHEN ((hist_rasp.attr_2345_ IS TRUE) AND (hist_rasp.attr_2346_ IS NOT TRUE)) THEN 'с 14:10 до 14:30'::text
                   ELSE
                   CASE
                    WHEN ((hist_rasp.attr_2345_ IS TRUE) AND (hist_rasp.attr_2346_ IS TRUE)) THEN 'c 14:10 до 15:00'::text
                    ELSE
                    CASE
                     WHEN ((hist_rasp.attr_2346_ IS TRUE) AND (hist_rasp.attr_2347_ IS NOT TRUE)) THEN 'с 14:40 до 15:00'::text
                     ELSE
                     CASE
                      WHEN ((hist_rasp.attr_2346_ IS TRUE) AND (hist_rasp.attr_2347_ IS TRUE)) THEN 'c 14:40 до 15:20'::text
                      ELSE
                      CASE
                       WHEN ((hist_rasp.attr_2347_ IS TRUE) AND (hist_rasp.attr_2348_ IS NOT TRUE)) THEN 'с 15:00 до 15:20'::text
                       ELSE
                       CASE
                        WHEN ((hist_rasp.attr_2347_ IS TRUE) AND (hist_rasp.attr_2348_ IS TRUE)) THEN 'c 15:00 до 15:50'::text
                        ELSE
                        CASE
                         WHEN ((hist_rasp.attr_2348_ IS TRUE) AND (hist_rasp.attr_2349_ IS NOT TRUE)) THEN 'с 15:30 до 15:50'::text
                         ELSE
                         CASE
                          WHEN ((hist_rasp.attr_2348_ IS TRUE) AND (hist_rasp.attr_2349_ IS TRUE)) THEN 'c 15:30 до 16:10'::text
                          ELSE
                          CASE
                           WHEN ((hist_rasp.attr_2349_ IS TRUE) AND (hist_rasp.attr_2350_ IS NOT TRUE)) THEN 'с 15:50 до 16:10'::text
                           ELSE
                           CASE
                            WHEN ((hist_rasp.attr_2349_ IS TRUE) AND (hist_rasp.attr_2350_ IS TRUE)) THEN 'c 15:50 до 16:40'::text
                            ELSE
                            CASE
                             WHEN ((hist_rasp.attr_2350_ IS TRUE) AND (hist_rasp.attr_2351_ IS NOT TRUE)) THEN 'с 16:20 до 16:40'::text
                             ELSE
                             CASE
                              WHEN ((hist_rasp.attr_2350_ IS TRUE) AND (hist_rasp.attr_2351_ IS TRUE)) THEN 'c 16:20 до 17:00'::text
                              ELSE
                              CASE
                               WHEN ((hist_rasp.attr_2351_ IS TRUE) AND (hist_rasp.attr_2350_ IS NOT TRUE)) THEN 'с 16:40 до 17:00'::text
                               ELSE NULL::text
                              END
                             END
                            END
                           END
                          END
                         END
                        END
                       END
                      END
                     END
                    END
                   END
                  END
                 END
                END
               END
              END
             END
            END
           END
          END
         END
        END
       END
      END
     END
    END
   END
  END
 END
END
                                    END
                                END
                            END
                        END
                    END
                END)) FILTER (WHERE (hist_rasp.attr_2352_ IS NOT NULL)), '
'::text) AS array_to_string
           FROM ((((registry.object_303_ o2
             LEFT JOIN registry.object_309_ hist_rasp ON (((hist_rasp.attr_311_ = o2.id) AND (hist_rasp.is_deleted <> true) AND (hist_rasp.attr_331_ =
                CASE
                    WHEN (EXTRACT(dow FROM o2.attr_2331_) = (1)::numeric) THEN (o2.attr_2331_ - 3)
                    ELSE
                    CASE
                        WHEN (EXTRACT(dow FROM o2.attr_2331_) = (0)::numeric) THEN (o2.attr_2331_ - 2)
                        ELSE (o2.attr_2331_ - 1)
                    END
                END) AND (hist_rasp.attr_774_ = o2.attr_304_) AND (hist_rasp.attr_2352_ IS NOT NULL))))
             LEFT JOIN registry.object_694_ proc_for_rasp ON (((proc_for_rasp.id = hist_rasp.attr_2325_) AND (proc_for_rasp.is_deleted <> true))))
             LEFT JOIN registry.object_9_ sotr2_rasp ON (((hist_rasp.attr_2352_ = sotr2_rasp.id) AND (sotr2_rasp.is_deleted <> true))))
             LEFT JOIN registry.object_2195_ func1 ON (((func1.id = hist_rasp.attr_2375_) AND (func1.is_deleted <> true))))
          WHERE ((o2.id = o.id) AND (o2.is_deleted <> true))
          GROUP BY o2.id) AS attr_2401_