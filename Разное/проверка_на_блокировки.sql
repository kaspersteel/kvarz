SELECT l.pid, l.mode, l.granted, relation::regclass AS locked_table, query, state
FROM pg_locks l
JOIN pg_stat_activity a ON l.pid = a.pid
WHERE relation = 'object_309_'::regclass