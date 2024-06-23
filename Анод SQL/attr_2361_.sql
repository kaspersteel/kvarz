SELECT
   greatest(
      o.update_date
   ,  dat_kp5.max_dat
   ,  dat_kp6.max_dat
   ,  dat_pot6.max_dat
   ,  dat_poz7.max_dat
   )
FROM
   registry.object_2233_ o
LEFT JOIN
   (
      SELECT
         max(kom_pr_ld.update_date) max_dat
      ,  kom_pr_ld.attr_2234_ zap_id
      FROM
         registry.object_2233_ kom_pr_ld
      WHERE
         kom_pr_ld.is_deleted <> TRUE
      GROUP BY
         kom_pr_ld.attr_2234_
   ) dat_kp5
      ON dat_kp5.zap_id = o.id
LEFT JOIN
   (
      SELECT
         max(max_poz_dat.max_poz_dat) max_dat
      ,  kom_pr_ld.attr_2234_ zap_id
      FROM
         registry.object_2233_ kom_pr_ld
      LEFT JOIN
         (
            SELECT
               max(poz_date.update_date) max_poz_dat
            ,  poz_date.attr_2247_ kp_id
            FROM
               registry.object_2245_ poz_date
            WHERE
               poz_date.is_deleted <> TRUE
            GROUP BY
               poz_date.attr_2247_
         ) max_poz_dat
            ON max_poz_dat.kp_id = kom_pr_ld.id
      WHERE
         kom_pr_ld.is_deleted <> TRUE
      GROUP BY
         kom_pr_ld.attr_2234_
   ) dat_kp6
      ON dat_kp6.zap_id = o.id
LEFT JOIN
   (
      SELECT
         max(pot_pr_ld.update_date) max_dat
      ,  pot_pr_ld.attr_728_ zap_id
      FROM
         registry.object_724_ pot_pr_ld
      WHERE
         pot_pr_ld.is_deleted <> TRUE
      GROUP BY
         pot_pr_ld.attr_728_
   ) dat_pot6
      ON dat_pot6.zap_id = o.id
LEFT JOIN
   (
      SELECT
         max(max_pred_dat.max_pred_dat) max_dat
      ,  potreb_pr_ld.attr_728_ zap_id
      FROM
         registry.object_724_ potreb_pr_ld
      LEFT JOIN
         (
            SELECT
               max(predl_date.update_date) max_pred_dat
            ,  predl_date.attr_834_ pot_id
            FROM
               registry.object_825_ predl_date
            WHERE
               predl_date.is_deleted <> TRUE
            GROUP BY
               predl_date.attr_834_
         ) max_pred_dat
            ON max_pred_dat.pot_id = potreb_pr_ld.id
      WHERE
         potreb_pr_ld.is_deleted <> TRUE
      GROUP BY
         potreb_pr_ld.attr_728_
   ) dat_poz7
      ON dat_poz7.zap_id = o.id
GROUP BY
   o.id
,  dat_kp5.max_dat
,  dat_kp6.max_dat
,  dat_pot6.max_dat
,  dat_poz7.max_dat;