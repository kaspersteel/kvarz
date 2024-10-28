     WITH variables AS (
             SELECT '76УТ26 00.00' AS "text1",
                    '76УТ26 00.03' AS "text2"
          )
   SELECT CASE
                    WHEN variables.text2 LIKE (STRING_TO_ARRAY(variables.text1, ' ')) [1] || '%' THEN TRUE
                    ELSE FALSE
          END,
          CASE
                    WHEN variables.text2 LIKE SPLIT_PART(variables.text1, ' ', 1) || '%' THEN TRUE
                    ELSE FALSE
          END,
          CASE
                    WHEN variables.text2 LIKE LEFT(variables.text1, STRPOS(variables.text1, ' ')) || '%' THEN TRUE
                    ELSE FALSE
          END,
          CASE
                    WHEN variables.text2 LIKE SUBSTRING(variables.text1, '^[^ ]*') || '%' THEN TRUE
                    ELSE FALSE
          END
     FROM variables