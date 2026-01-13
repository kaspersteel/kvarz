WITH base AS (
SELECT *, count(*) over (PARTITION BY id)
FROM registry.object_303_main
where not is_deleted
)
 SELECT *
 FROM base
 where count > 1