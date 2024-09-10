CONCAT(
material.attr_2976_
        , CASE
          WHEN sort.attr_401_ IS NOT NULL THEN CONCAT(' /', sort.attr_401_)
          ELSE NULL
END
        , CASE
          WHEN typer.attr_401_ IS NOT NULL THEN CONCAT(' /', typer.attr_401_)
          ELSE NULL
END
        , CASE
          WHEN o.attr_2212_ IS NOT NULL THEN CONCAT(' Ø', o.attr_2212_)
          ELSE NULL
END
        , CASE
          WHEN o.attr_1666_ IS NOT NULL THEN CONCAT('/ № плавки ', o.attr_1666_)
          ELSE NULL
END
        , CASE
          WHEN o.attr_1667_ IS NOT NULL THEN CONCAT(' / № серт.: ', o.attr_1667_)
          ELSE NULL
END
        , ' / Тек. остаток: '
        , CASE
          WHEN o.attr_3160_ THEN CONCAT(' длина, ', o.attr_2209_, ' мм')
          ELSE CONCAT(o.attr_1675_, ' ', sprav_units.attr_390_)
END
        , CASE
          WHEN o.attr_3952_ THEN ' (давальческое)'
          ELSE ''
END
)