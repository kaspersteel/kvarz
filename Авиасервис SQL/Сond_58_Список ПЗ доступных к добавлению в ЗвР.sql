WITH params AS (
    SELECT
        NULLIF({id_pos_task}, 'null')::int AS id_pos_task,
        NULLIF({id_task}, 'null')::int AS id_task,
        NULLIF({standard}, 'null')::int AS standard,
        NULLIF({typesize}, 'null')::int AS typesize,
        NULLIF({length}, 'null')::numeric AS length
)
SELECT o.id
FROM registry.object_593_ o
LEFT JOIN registry.object_75_ nomen ON nomen.id = o.attr_604_ AND NOT nomen.is_deleted
LEFT JOIN registry.object_630_ tab_worktask ON tab_worktask.attr_631_ = o.id AND NOT tab_worktask.is_deleted
LEFT JOIN registry.object_186_ worktask ON worktask.id = tab_worktask.attr_50_ AND NOT worktask.is_deleted
CROSS JOIN params
WHERE NOT o.is_deleted
  AND (
    (params.id_pos_task IS NOT NULL AND tab_worktask.id = params.id_pos_task)
    OR (
      params.id_pos_task IS NULL
      AND (nomen.attr_81_ IS NULL OR nomen.attr_81_ = params.standard)
      AND (nomen.attr_500_ IS NULL OR nomen.attr_500_ = params.typesize)
      AND (nomen.attr_85_ IS NULL OR nomen.attr_85_ = params.length)
      AND o.attr_799_ > 0
      AND (worktask.id IS NULL OR worktask.id != params.id_task)
    )
  );
