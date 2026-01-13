--SELECT
CASE remnants_save.attr_2214_
          /*Круг/цилиндр*/
          WHEN 1 THEN (
          PI() * (remnants_save.attr_2212_ / 2 / 1000) ^ 2 * o.attr_3251_ / 1000
          ) * material.attr_1359_
          /*Лист*/
          WHEN 2 THEN (
          remnants_save.attr_2210_ / 1000 * o.attr_3251_ / 1000 * remnants_save.attr_2211_ / 1000
          ) * material.attr_1359_
          /*Уголок*/
          WHEN 3 THEN (
          remnants_save.attr_2211_ / 1000 * (
          remnants_save.attr_2210_ / 1000 + remnants_save.attr_2932_ / 1000 - remnants_save.attr_2211_ / 1000
          ) * o.attr_3251_ / 1000
          ) * material.attr_1359_
          /*Шестигранник*/
          WHEN 4 THEN (
          2 * SQRT(3) * (remnants_save.attr_2932_ / 1000 / 2) ^ 2 * o.attr_3251_ / 1000
          ) * material.attr_1359_
          /*Труба/кольцо*/
          WHEN 5 THEN (
          PI() * (
          (remnants_save.attr_2212_ / 1000 / 2) ^ 2 - (
          COALESCE(
          remnants_save.attr_2928_
        , remnants_save.attr_2212_ - remnants_save.attr_2211_
          ) / 1000 / 2
          ) ^ 2
          ) * (o.attr_3251_ / 1000)
          ) / 4 * material.attr_1359_
          /*Труба проф. квадратная*/
          WHEN 7 THEN (
          4 * remnants_save.attr_2211_ / 1000 * (
          (remnants_save.attr_2210_ / 1000) - (remnants_save.attr_2211_ / 1000)
          ) * (o.attr_3251_ / 1000)
          ) * material.attr_1359_
          /*Труба проф. прямоугольная*/
          WHEN 8 THEN (
          2 * (remnants_save.attr_2211_ / 1000) * (
          remnants_save.attr_2210_ / 1000 + remnants_save.attr_2932_ / 1000 -2 * remnants_save.attr_2211_ / 1000
          ) * (o.attr_3251_ / 1000)
          ) * material.attr_1359_
          /*Швеллер*/
          WHEN 9 THEN (
          (remnants_save.attr_2932_ / 1000) * (remnants_save.attr_2211_ / 1000) -2 * (remnants_save.attr_2211_ / 1000) * (
          remnants_save.attr_2210_ / 1000 - remnants_save.attr_2211_ / 1000
          ) * (o.attr_3251_ / 1000)
          ) * material.attr_1359_
          ELSE NULL
END
--FROM registry.object_3168_ o
LEFT JOIN registry.object_1659_ remnants_save ON remnants_save.id = o.attr_3169_
      AND remnants_save.is_deleted IS FALSE
LEFT JOIN registry.object_400_ material ON material.id = remnants_save.attr_1663_
      AND material.is_deleted IS FALSE
--GROUP BY
          remnants_save.id
        , material.id