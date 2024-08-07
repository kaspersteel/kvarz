DECLARE 
copy_ids INT[] = registry."copyRecord"((parameters->>'registry_id')::int, (parameters->>'id')::int, 1, NULL, NULL, (parameters->>'user_id')::int, true);
do_user INT = (parameters ->> 'user_id')::INT;
BEGIN
UPDATE registry.object_1409_
SET 
attr_2433_ = (CASE WHEN attr_2433_ IS NOT NULL THEN attr_2433_ - attr_3946_ ELSE attr_1412_ - attr_3946_ END), 
attr_3946_ = NULL, 
attr_3938_ = NULL, 
attr_3933_ = false, 
attr_3934_ = false, 
attr_3937_ = NULL,
operation_user_id = do_user
WHERE id = (parameters->>'id')::int;
UPDATE registry.object_1409_
SET attr_2433_ = attr_3946_,
attr_3946_ = NULL,
operation_user_id = do_user
WHERE id = copy_ids[1]::int;
END