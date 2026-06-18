SELECT 
    CASE 
        WHEN checkins.id IS NULL OR checkins.attr_136_ IS NULL THEN CONCAT('r', rooms.id) 
        ELSE CONCAT('z', checkins.id) 
    END AS id,
    rooms.attr_444_ AS room,
    rooms.attr_132_ AS bpr,
    EXTRACT(MONTH FROM CURRENT_DATE) AS current_month,
    EXTRACT(YEAR FROM CURRENT_DATE) AS current_year,
    EXTRACT(MONTH FROM checkins.attr_136_) AS checkin_month,
    
    CASE 
    WHEN checkins.id IS NULL OR checkins.attr_136_ IS NULL THEN CURRENT_DATE + INTERVAL '1 day' 
    ELSE GREATEST(checkins.attr_136_, DATE_TRUNC('month', CURRENT_DATE))
    END AS date_in
    
    CASE 
        WHEN checkins.id IS NULL OR checkins.attr_112_ IS NULL THEN CURRENT_DATE + INTERVAL '1 day' 
        ELSE checkins.attr_112_ 
    END AS date_out,
    
    COALESCE(checkins.attr_268_, '') AS label,
    
    CASE 
        WHEN checkins.id IS NULL OR checkins.attr_136_ IS NULL THEN '#FFFFFF' 
        WHEN checkins.attr_117_ IS NOT NULL AND checkins.attr_698_ IS NOT NULL AND checkins.attr_105_ = 25 THEN '#444547'
        ELSE COALESCE(checkins.attr_163_, '#FFFFFF') 
    END AS color

FROM registry.object_127_ rooms
LEFT JOIN registry.object_102_ checkins 
    ON checkins.attr_117_ = rooms.id 
    AND checkins.is_deleted IS NOT TRUE 
    AND (
        checkins.attr_105_ IN (7, 12, 19, 28, 36, 6) 
        OR (
            checkins.attr_105_ = 25 
            AND checkins.attr_136_ >= DATE_TRUNC('month', CURRENT_DATE)
        )
    )
WHERE rooms.is_deleted IS NOT TRUE 
  /* AND rooms.attr_135_ = 206 */
ORDER BY 
    rooms.attr_135_, 
    checkins.attr_136_, 
    checkins.id;