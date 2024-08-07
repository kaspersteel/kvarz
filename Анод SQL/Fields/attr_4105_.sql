CASE mat_for_mk.attr_1373_
                              WHEN 1 THEN (
                              PI() * (o.attr_1873_ / 2000) ^ 2 * o.attr_2884_ / 1000
                              ) * dens_for_mk.attr_1359_
                              WHEN 2 THEN (
                              o.attr_1875_ / 1000 * o.attr_2884_ / 1000 * o.attr_1874_ / 1000
                              ) * dens_for_mk.attr_1359_
                              WHEN 3 THEN (
                              o.attr_1874_ / 1000 * (
                              o.attr_1875_ / 1000 + o.attr_3270_ / 1000 - o.attr_1874_ / 1000
                              ) * o.attr_2884_ / 1000
                              ) * dens_for_mk.attr_1359_
                              WHEN 4 THEN (
                              2 * SQRT(3) * (o.attr_3270_ / 1000 / 2) ^ 2 * o.attr_2884_ / 1000
                              ) * dens_for_mk.attr_1359_
                              WHEN 5 THEN (
                              PI() * (
                              (o.attr_1873_ / 1000 / 2) ^ 2 - (
                              COALESCE(o.attr_3220_, (o.attr_1873_ - o.attr_1874_)) / 1000 / 2
                              ) ^ 2
                              ) * (o.attr_2884_ / 1000)
                              ) / 4 * dens_for_mk.attr_1359_
                              WHEN 7 THEN (
                              4 * o.attr_1874_ / 1000 * ((o.attr_1875_ / 1000) - (o.attr_1874_ / 1000)) * (o.attr_2884_ / 1000)
                              ) * dens_for_mk.attr_1359_
                              WHEN 8 THEN (
                              2 * (o.attr_1874_ / 1000) * (
                              o.attr_1875_ / 1000 + o.attr_3270_ / 1000 -2 * o.attr_1874_ / 1000
                              ) * (o.attr_2884_ / 1000)
                              ) * dens_for_mk.attr_1359_
                              WHEN 9 THEN (
                              (o.attr_3270_ / 1000) * (o.attr_1874_ / 1000) -2 * (o.attr_1874_ / 1000) * (o.attr_1875_ / 1000 - o.attr_1874_ / 1000) * (o.attr_2884_ / 1000)
                              ) * dens_for_mk.attr_1359_
                              ELSE NULL
                    END