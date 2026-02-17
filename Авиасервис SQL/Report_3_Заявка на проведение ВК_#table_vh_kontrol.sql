SELECT
    o.attr_272_ AS nom_pp,
    dir_mat.attr_283_ AS material_name,
    material.attr_96_  AS material_plavka,
    material.attr_267_ AS material_partia,
    o.attr_129_ AS diametr,
    o.attr_130_ AS col,
    o.attr_131_ AS nom_obr,
    o.attr_270_ AS ispitanie,
    COALESCE(list.labs, '') AS labs

FROM registry.object_124_ o

LEFT JOIN registry.object_30_ material ON material.id = o.attr_127_
      AND NOT material.is_deleted

LEFT JOIN registry.object_58_ dir_mat ON dir_mat.id = material.attr_94_
      AND NOT dir_mat.is_deleted

/* ✨ магия */
LEFT JOIN LATERAL (
    SELECT string_agg(
       '* ' || CASE 
                   WHEN t.attr_917_ IS TRUE
                        THEN t.attr_916_ || ' ' || u.attr_55_
                   ELSE t.attr_916_
               END,
               E'\n'
               ORDER BY ord
           ) AS labs
    /* разворачиваем массив лабораторных испытаний в пронумерованную таблицу */       
    FROM unnest(o.attr_132_) WITH ORDINALITY AS a(lab_id, ord)
    /* лабораторные испытания */
    JOIN registry.object_915_ t ON t.id = a.lab_id
     AND NOT t.is_deleted
    /* стандарты материалов */
    LEFT JOIN registry.object_54_ u ON u.id = dir_mat.attr_63_
     AND NOT u.is_deleted
    WHERE a.lab_id > 0
) list ON TRUE

WHERE
    NOT o.is_deleted
    AND o.attr_289_
    AND o.attr_126_ = {id_vh_kontrol}

ORDER BY nom_pp;