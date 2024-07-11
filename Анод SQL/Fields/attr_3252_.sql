--SELECT
CASE o.attr_3171_
          /*Круг/цилиндр*/
          WHEN 1 THEN (
          PI() * (remnants.attr_2212_ / 2 / 1000) ^ 2 * o.attr_3251_ / 1000
          ) * material.attr_1359_
          /*Лист*/
          WHEN 2 THEN (
          remnants.attr_2210_ / 1000 * o.attr_3251_ / 1000 * remnants.attr_2211_ / 1000
          ) * material.attr_1359_
          /*Уголок*/
          WHEN 3 THEN (
          remnants.attr_2211_ / 1000 * (
          remnants.attr_2210_ / 1000 + remnants.attr_2932_ / 1000 - remnants.attr_2211_ / 1000
          ) * o.attr_3251_ / 1000
          ) * material.attr_1359_
          /*Шестигранник*/
          WHEN 4 THEN (
          2 * SQRT(3) * (remnants.attr_2932_ / 1000 / 2) ^ 2 * o.attr_3251_ / 1000
          ) * material.attr_1359_
          /*Труба/кольцо*/
          WHEN 5 THEN (
          PI() * (
          (remnants.attr_2212_ / 1000 / 2) ^ 2 - (
          COALESCE(
          remnants.attr_2928_
        , remnants.attr_2212_ - remnants.attr_2211_
          ) / 1000 / 2
          ) ^ 2
          ) * (o.attr_3251_ / 1000)
          ) / 4 * material.attr_1359_
          /*Труба проф. квадратная*/
          WHEN 7 THEN (
          4 * remnants.attr_2211_ / 1000 * (
          (remnants.attr_2210_ / 1000) - (remnants.attr_2211_ / 1000)
          ) * (o.attr_3251_ / 1000)
          ) * material.attr_1359_
          /*Труба проф. прямоугольная*/
          WHEN 8 THEN (
          2 * (remnants.attr_2211_ / 1000) * (
          remnants.attr_2210_ / 1000 + remnants.attr_2932_ / 1000 -2 * remnants.attr_2211_ / 1000
          ) * (o.attr_3251_ / 1000)
          ) * material.attr_1359_
          /*Швеллер*/
          WHEN 9 THEN (
          (remnants.attr_2932_ / 1000) * (remnants.attr_2211_ / 1000) -2 * (remnants.attr_2211_ / 1000) * (
          remnants.attr_2210_ / 1000 - remnants.attr_2211_ / 1000
          ) * (o.attr_3251_ / 1000)
          ) * material.attr_1359_
          ELSE NULL
END
--FROM registry.object_3168_ o
LEFT JOIN registry.object_1659_ remnants ON remnants.id = o.attr_3169_
      AND remnants.is_deleted IS FALSE
LEFT JOIN registry.object_400_ material ON material.id = remnants.attr_1663_
      AND material.is_deleted IS FALSE
--GROUP BY
          remnants.id
        , material.id