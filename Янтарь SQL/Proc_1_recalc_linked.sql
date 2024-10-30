  DECLARE recalc_ids RECORD;

do_user INT = (parameters ->> 'user_id')::INT;

    BEGIN recalc_ids = (
   SELECT INTO recalc_ids 
ARRAY_AGG(DISTINCT hist.id) AS hist,
ARRAY_AGG(DISTINCT frd.id) AS frd,
ARRAY_AGG(DISTINCT mdb.id) AS mdb
     FROM registry.object_102_ zaezd
LEFT JOIN registry.object_303_ hist ON hist.attr_765_ = zaezd.id
      AND NOT hist.is_deleted
LEFT JOIN registry.object_1497_ frd ON frd.attr_1799_ = hist.id
      AND NOT frd.is_deleted
LEFT JOIN registry.object_1063_ mdb ON mdb.attr_1141_ = hist.id
      AND NOT mdb.is_deleted
    WHERE zaezd.ID = (PARAMETERS ->> 'id')::INT
);

     CALL registry."updateStoredFormulasByRows" (303, recalc_ids.hist);

     CALL registry."updateStoredFormulasByRows" (1497, recalc_ids.frd);

     CALL registry."updateStoredFormulasByRows" (1063, recalc_ids.mdb);

END