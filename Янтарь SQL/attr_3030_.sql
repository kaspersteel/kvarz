   SELECT CONCAT(
          'Общее состояние - ',
          obsh_sost.attr_938_,
          ', ',
          'сознание - ',
          sozn.attr_976_,
          CASE
                    WHEN prim_rew1.attr_3348_ IS TRUE THEN CONCAT(
                    ', ЧМН: ',
                    CONCAT(
                    CASE
                              WHEN prim_rew1.attr_847_ = 2
                                     OR prim_rew1.attr_848_ = 2 THEN 'I пара :'
                                        ELSE 'I пара: без патологий.'
                    END,
                    CASE
                              WHEN prim_rew1.attr_847_ = 2 THEN 'Обоняние нарушено. '
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew1.attr_848_ = 2 THEN ' Носовые ходы не проходимы. '
                              ELSE NULL
                    END
                    ),
                    CONCAT(
                    CASE
                              WHEN prim_rew1.attr_850_ <> 1
                                     OR prim_rew1.attr_3553_ <> 1
                                     OR prim_rew1.attr_852_ <> 1
                                     OR prim_rew1.attr_853_ <> 2
                                     OR prim_rew1.attr_856_ <> 2
                                     OR prim_rew1.attr_857_ <> 2
                                     OR prim_rew1.attr_2074_ <> 2 THEN 'II пара: '
                                        ELSE 'II пара: без патологий. '
                    END,
                    CASE
                              WHEN prim_rew1.attr_850_ = 2 THEN CONCAT(
                              'Поля зрения: частичная гемианопсия ',
                              CASE
                                        WHEN prim_rew1.attr_2110_ = 1 THEN 'справа.'
                                        WHEN prim_rew1.attr_2110_ = 2 THEN 'слева.'
                                        WHEN prim_rew1.attr_2110_ = 3 THEN 'с обеих сторон.'
                              END
                              )
                              WHEN prim_rew1.attr_850_ = 3 THEN CONCAT('Поля зрения: ', prim_rew1.attr_4223_, '. ')
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew1.attr_3553_ <> 1 THEN CONCAT(
                              'Зрачки: ',
                              zr.attr_3501_,
                              ', ',
                              prim_rew1.attr_854_,
                              '. '
                              )
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew1.attr_852_ <> 1 THEN CONCAT('Фотореакции: ', fotoreak.attr_1027_, '. ')
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew1.attr_853_ <> 2 THEN CONCAT(
                              'Птоз: ',
                              ptoz.attr_3501_,
                              ', ',
                              ptoz_ur.attr_1025_,
                              '. '
                              )
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew1.attr_856_ = 1 THEN CONCAT(
                              'Нистагм: ',
                              nis.attr_3501_,
                              ', ',
                              prim_rew1.attr_3558_,
                              '. '
                              )
                              WHEN prim_rew1.attr_856_ = 3 THEN CONCAT('Нистагм: ', prim_rew1.attr_3558_, '. ')
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew1.attr_857_ = 1 THEN CONCAT(
                              'Экзофтальм: ',
                              exzoftalm.attr_3501_,
                              ', ',
                              prim_rew1.attr_3561_,
                              '. '
                              )
                              WHEN prim_rew1.attr_857_ = 3 THEN CONCAT('Экзофтальм: ', prim_rew1.attr_3561_, '. ')
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew1.attr_2074_ = 1 THEN CONCAT(
                              'Энофтальм: ',
                              enoftalm.attr_3501_,
                              ', ',
                              prim_rew1.attr_3560_,
                              '. '
                              )
                              WHEN prim_rew1.attr_2074_ = 3 THEN CONCAT('Энофтальм: ', prim_rew1.attr_3560_, '. ')
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew1.attr_3882_ IS NOT NULL THEN CONCAT(
                              'Дополнительная информация по глазодвигательной группе: ',
                              prim_rew1.attr_3882_
                              )
                              ELSE NULL
                    END
                    ),
                    CONCAT(
                    CASE
                              WHEN prim_rew1.attr_858_ <> 6
                                     OR prim_rew1.attr_859_ <> 2
                                     OR prim_rew1.attr_860_ <> 2
                                     OR prim_rew1.attr_861_ <> 2
                                     OR prim_rew1.attr_3575_ <> 1
                                     OR prim_rew1.attr_864_ <> 1
                                     OR prim_rew1.attr_865_ <> 2 THEN 'V пара: '
                                        ELSE 'V пара: без патологий. '
                    END,
                    CASE
                              WHEN prim_rew1.attr_858_ = 1 THEN 'Оценка V пары невозможна. '
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew1.attr_859_ <> 2 THEN CONCAT(
                              'Болезненность в точках выхода тройничного нерва: ',
                              troi_nerv.attr_3501_,
                              ', ',
                              troi_nerv_cifra.attr_3585_,
                              '. '
                              )
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew1.attr_860_ = 1 THEN 'Нарушение чувствительности по корешковому типу. '
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew1.attr_861_ = 1 THEN 'Нарушение чувствительности по зонам Зельдера. '
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew1.attr_3575_ <> 1 THEN CONCAT(
                              'Пальпебральные рефлексы, назопальпебральный: ',
                              p_n_ref.attr_3501_,
                              ', ',
                              prim_rew1.attr_1056_,
                              '. '
                              )
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew1.attr_864_ <> 1 THEN CONCAT(
                              'Мандибулярный рефлекс: ',
                              mand_ref.attr_1028_,
                              '. '
                              )
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew1.attr_865_ = 1 THEN 'Нарушена функция жевательной мускулатуры. '
                              ELSE NULL
                    END
                    ),
                    CONCAT(
                    CASE
                              WHEN prim_rew1.attr_866_ <> 1
                                     OR prim_rew1.attr_868_ <> 1
                                     OR prim_rew1.attr_869_ <> 2
                                     OR prim_rew1.attr_870_ <> 1
                                     OR prim_rew1.attr_871_ <> 2
                                     OR prim_rew1.attr_872_ <> 2
                                     OR prim_rew1.attr_874_ <> 2
                                     OR prim_rew1.attr_873_ <> 1 THEN 'VII пара: '
                                        ELSE 'VII пара: без патологий. '
                    END,
                    CASE
                              WHEN prim_rew1.attr_866_ = 2 THEN 'Лицо ассиметрично. '
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew1.attr_868_ = 2 THEN CONCAT(
                              'Глазные щели: ассиметричны, ',
                              glaz_shel.attr_3501_,
                              '. '
                              )
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew1.attr_869_ = 1 THEN CONCAT(
                              'Есть сглаженность складок на лбу, ',
                              skladki.attr_3501_,
                              '. '
                              )
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew1.attr_870_ = 2 THEN CONCAT(
                              'Невозможность зажмуривания век, ',
                              veki.attr_3501_,
                              '. '
                              )
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew1.attr_871_ = 1 THEN CONCAT(
                              'Есть симптом ресниц, ',
                              recnitci.attr_3501_,
                              '. '
                              )
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew1.attr_872_ = 1 THEN CONCAT(
                              'Есть симптом ракетки, ',
                              raketka.attr_2076_,
                              '. '
                              )
                              WHEN prim_rew1.attr_872_ = 3 THEN CONCAT('Симптом ракетки, ', prim_rew1.attr_4223_, '. ')
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew1.attr_873_ = 2 THEN CONCAT(
                              'Тонус лицевой мускалатуры снижен, ',
                              tonus_litca.attr_3501_,
                              '. '
                              )
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew1.attr_874_ = 1 THEN 'Вкус на передних 2/3 языка изменен. '
                              ELSE NULL
                    END
                    ),
                    CONCAT(
                    CASE
                              WHEN prim_rew1.attr_877_ <> 6 THEN CONCAT(
                              'VIII пара: ',
                              'Шёпотная речь оценка - ',
                              shepotnaya_rech.attr_1026_,
                              ', D = ',
                              prim_rew1.attr_875_,
                              ', S = ',
                              prim_rew1.attr_876_
                              )
                              ELSE 'VIII пара: без патологий. '
                    END
                    ),
                    CONCAT(
                    CASE
                              WHEN prim_rew1.attr_878_ <> 2
                                     OR prim_rew1.attr_879_ <> 1 THEN 'IX пара: '
                                        ELSE 'IX пара: без патологий. '
                    END,
                    CASE
                              WHEN prim_rew1.attr_878_ = 1 THEN 'Глотание нарушено. '
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew1.attr_879_ = 2 THEN CONCAT(
                              'Глоточные рефлексы не вызываются, ',
                              glot_ref.attr_3501_,
                              '. '
                              )
                              ELSE NULL
                    END
                    ),
                    CONCAT(
                    CASE
                              WHEN prim_rew1.attr_2106_ <> 2
                                     OR prim_rew1.attr_882_ <> 1
                                     OR prim_rew1.attr_883_ <> 1
                                     OR prim_rew1.attr_884_ <> 1
                                     OR prim_rew1.attr_885_ <> 1 THEN 'X пара: '
                                        ELSE 'X пара: без патологий. '
                    END,
                    CASE
                              WHEN prim_rew1.attr_2106_ <> 2 THEN CONCAT('Фонация: ', fonation.attr_2105_, '. ')
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew1.attr_882_ <> 1 THEN CONCAT(
                              'Мягкое небо: ',
                              m_nebo.attr_1038_,
                              ', ',
                              m_nebo_ds.attr_3501_,
                              '. '
                              )
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew1.attr_883_ = 2 THEN 'Мягкое небо не симметрично. '
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew1.attr_884_ = 2 THEN 'Небные рефлексы снижены. '
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew1.attr_885_ = 2 THEN CONCAT('Uvula - отклонен, ', uvula.attr_3501_, '. ')
                              ELSE NULL
                    END
                    ),
                    CONCAT(
                    CASE
                              WHEN prim_rew1.attr_886_ <> 8 THEN CONCAT(
                              'XI пара: ',
                              'Повороты головы и движения плечами: ',
                              povorot_golovi.attr_1026_,
                              '. '
                              )
                              ELSE 'XI пара: без патологий. '
                    END
                    ),
                    CONCAT(
                    CASE
                              WHEN prim_rew1.attr_887_ <> 2
                                     OR prim_rew1.attr_888_ <> 1
                                     OR prim_rew1.attr_889_ <> 2
                                     OR prim_rew1.attr_890_ <> 2 THEN 'XII пара: '
                                        ELSE 'XII пара: без патологий. '
                    END,
                    CASE
                              WHEN prim_rew1.attr_887_ = 1 THEN 'Дизартрия. '
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew1.attr_888_ = 2 THEN 'Движения языком ограничены. '
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew1.attr_889_ = 1 THEN CONCAT(
                              'Фибриллярные подёргивания, атрофии, ',
                              atrofii.attr_3501_,
                              '. '
                              )
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew1.attr_890_ = 1 THEN 'Девиация языка. '
                              ELSE NULL
                    END
                    )
                    )
                    ELSE NULL
          END,
          'Афазия - ',
          afaz.attr_1020_,
          ' ',
          prim_rew1.attr_3717_,
          ', ',
          'глотание - ',
          glot.attr_1035_,
          ', ',
          'фонация - ',
          fonac.attr_2105_,
          '. ',
          CASE
                    WHEN prim_rew1.attr_3898_ IS TRUE THEN CONCAT(
                    'Сила в конечностях: ',
                    'в проксимальных отделах верхних конечностей: D - ',
                    prim_rew1.attr_896_,
                    'б, ',
                    'S - ',
                    prim_rew1.attr_897_,
                    'б, ',
                    'в дистальных отделах верхних конечностей: D - ',
                    prim_rew1.attr_898_,
                    'б, ',
                    'S -',
                    prim_rew1.attr_899_,
                    'б, ',
                    'в проксимальных отделах нижних конечностей: D - ',
                    prim_rew1.attr_900_,
                    'б, ',
                    'S - ',
                    prim_rew1.attr_901_,
                    'б, ',
                    'в дистальных отделах нижних конечностей: D - ',
                    prim_rew1.attr_902_,
                    'б, ',
                    'S - ',
                    prim_rew1.attr_903_,
                    'б. '
                    )
                    ELSE NULL
          END,
          'Чувствительность: ',
          prim_rew1.attr_2118_,
          '. ',
          (
          CASE
                    WHEN prim_rew1.attr_910_ = 2 THEN 'Патологических рефлексов нет. '
                    ELSE CONCAT('Патологические рефлексы:', prim_rew1.attr_3570_)
          END
          ),
          'Тонус мышц: ',
          tonus.attr_1049_,
          (
          CASE
                    WHEN prim_rew1.attr_3569_ IS NOT NULL THEN CONCAT(', ', tonus_ds.attr_3501_, '. ')
                    ELSE '. '
          END
          ),
          'Походка - ',
          pohod.attr_1054_,
          prim_rew1.attr_3897_,
          '. ',
          'Костно-суставная система: ',
          kost_sust1.attr_2098_,
          CASE
                    WHEN prim_rew1.attr_3349_ IS NOT NULL THEN CONCAT(' ', prim_rew1.attr_3349_, ', ')
                    ELSE '. '
          END,
          'Координаторные пробы: поза Ромберга - ',
          romberg.attr_1050_,
          ', ',
          'ПНП - ',
          pnp.attr_1051_,
          ' ',
          pnp_storona.attr_1052_,
          ' ',
          prim_rew1.attr_3659_,
          ' ',
          'ПКП - ',
          pkp.attr_1051_,
          ' ',
          pkp_storona.attr_1052_,
          ' ',
          prim_rew1.attr_3658_,
          '. ',
          'Функция тазовых органов: ',
          fun_taz_or.attr_1055_,
          CASE
                    WHEN prim_rew1.attr_2100_ IS NOT NULL THEN CONCAT(' ', prim_rew1.attr_2100_)
                    ELSE NULL
          END,
          '. '
          )
     FROM registry.object_2993_ o
LEFT JOIN registry.object_793_ prim_rew1 ON prim_rew1.attr_1061_ = o.attr_3015_
      AND prim_rew1.attr_3038_ = 1
      AND prim_rew1.is_deleted <> TRUE
      AND prim_rew1.attr_3038_ = 1
LEFT JOIN registry.object_937_ obsh_sost ON prim_rew1.attr_812_ = obsh_sost.id
      AND obsh_sost.is_deleted <> TRUE
LEFT JOIN registry.object_975_ sozn ON prim_rew1.attr_843_ = sozn.id
      AND sozn.is_deleted <> TRUE
LEFT JOIN registry.object_977_ afaz ON prim_rew1.attr_844_ = afaz.id
      AND afaz.is_deleted <> TRUE
LEFT JOIN registry.object_929_ kogn_nar ON prim_rew1.attr_845_ = kogn_nar.id
      AND kogn_nar.is_deleted <> TRUE
LEFT JOIN registry.object_995_ glot ON prim_rew1.attr_878_ = glot.id
      AND glot.is_deleted <> TRUE
LEFT JOIN registry.object_2104_ fonac ON prim_rew1.attr_2106_ = fonac.id
      AND fonac.is_deleted <> TRUE
LEFT JOIN registry.object_1018_ pohod ON prim_rew1.attr_917_ = pohod.id
      AND pohod.is_deleted <> TRUE
LEFT JOIN registry.object_2097_ kost_sust1 ON prim_rew1.attr_2099_ = kost_sust1.id
      AND kost_sust1.is_deleted <> TRUE
LEFT JOIN registry.object_1014_ romberg ON prim_rew1.attr_912_ = romberg.id
      AND romberg.is_deleted <> TRUE
LEFT JOIN registry.object_1015_ pnp ON prim_rew1.attr_913_ = pnp.id
      AND pnp.is_deleted <> TRUE
LEFT JOIN registry.object_1016_ pnp_storona ON prim_rew1.attr_2071_ = pnp_storona.id
      AND pnp_storona.is_deleted <> TRUE
LEFT JOIN registry.object_1015_ pkp ON prim_rew1.attr_914_ = pkp.id
      AND pkp.is_deleted <> TRUE
LEFT JOIN registry.object_1016_ pkp_storona ON prim_rew1.attr_2073_ = pkp_storona.id
      AND pkp_storona.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ zr ON zr.id = prim_rew1.attr_3553_
      AND zr.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ nis ON nis.id = prim_rew1.attr_3565_
      AND nis.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ ptoz ON ptoz.id = prim_rew1.attr_3554_
      AND ptoz.is_deleted <> TRUE
LEFT JOIN registry.object_984_ ptoz_ur ON ptoz_ur.id = prim_rew1.attr_855_
      AND ptoz_ur.is_deleted <> TRUE
LEFT JOIN registry.object_986_ fotoreak ON fotoreak.id = prim_rew1.attr_852_
      AND fotoreak.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ exzoftalm ON exzoftalm.id = prim_rew1.attr_3566_
      AND exzoftalm.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ enoftalm ON enoftalm.id = prim_rew1.attr_3567_
      AND enoftalm.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ troi_nerv ON troi_nerv.id = prim_rew1.attr_3568_
      AND troi_nerv.is_deleted <> TRUE
LEFT JOIN registry.object_3584_ troi_nerv_cifra ON troi_nerv_cifra.id = prim_rew1.attr_3586_
      AND troi_nerv_cifra.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ p_n_ref ON p_n_ref.id = prim_rew1.attr_3575_
      AND p_n_ref.is_deleted <> TRUE
LEFT JOIN registry.object_987_ mand_ref ON mand_ref.id = prim_rew1.attr_864_
      AND mand_ref.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ glaz_shel ON glaz_shel.id = prim_rew1.attr_3579_
      AND glaz_shel.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ skladki ON skladki.id = prim_rew1.attr_3580_
      AND skladki.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ veki ON veki.id = prim_rew1.attr_3581_
      AND veki.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ recnitci ON recnitci.id = prim_rew1.attr_3582_
      AND recnitci.is_deleted <> TRUE
LEFT JOIN registry.object_2075_ raketka ON raketka.id = prim_rew1.attr_2077_
      AND raketka.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ tonus_litca ON tonus_litca.id = prim_rew1.attr_3583_
      AND tonus_litca.is_deleted <> TRUE
LEFT JOIN registry.object_985_ shepotnaya_rech ON shepotnaya_rech.id = prim_rew1.attr_877_
      AND shepotnaya_rech.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ glot_ref ON glot_ref.id = prim_rew1.attr_3578_
      AND glot_ref.is_deleted <> TRUE
LEFT JOIN registry.object_999_ m_nebo ON m_nebo.id = prim_rew1.attr_882_
      AND m_nebo.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ m_nebo_ds ON m_nebo_ds.id = prim_rew1.attr_3577_
      AND m_nebo_ds.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ uvula ON uvula.id = prim_rew1.attr_2109_
      AND uvula.is_deleted <> TRUE
LEFT JOIN registry.object_2104_ fonation ON fonation.id = prim_rew1.attr_2106_
      AND fonation.is_deleted <> TRUE
LEFT JOIN registry.object_985_ povorot_golovi ON povorot_golovi.id = prim_rew1.attr_886_
      AND povorot_golovi.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ atrofii ON atrofii.id = prim_rew1.attr_3576_
      AND atrofii.is_deleted <> TRUE
LEFT JOIN registry.object_1013_ tonus ON tonus.id = prim_rew1.attr_911_
      AND tonus.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ tonus_ds ON tonus_ds.id = prim_rew1.attr_3569_
      AND tonus_ds.is_deleted <> TRUE
LEFT JOIN registry.object_1019_ fun_taz_or ON fun_taz_or.id = prim_rew1.attr_918_
      AND fun_taz_or.is_deleted <> TRUE
    WHERE NOT o.is_deleted
 GROUP BY prim_rew1.id,
          obsh_sost.id,
          sozn.id,
          afaz.id,
          kogn_nar.id,
          glot.id,
          fonac.id,
          pohod.id,
          kost_sust1.id,
          pkp_storona.id,
          pkp.id,
          pnp_storona.id,
          pnp.id,
          romberg.id,
          zr.id,
          ptoz.id,
          ptoz_ur.id,
          nis.id,
          fotoreak.id,
          exzoftalm.id,
          enoftalm.id,
          troi_nerv.id,
          troi_nerv_cifra.id,
          p_n_ref.id,
          mand_ref.id,
          glaz_shel.id,
          skladki.id,
          veki.id,
          recnitci.id,
          raketka.id,
          tonus_litca.id,
          shepotnaya_rech.id,
          glot_ref.id,
          fonation.id,
          m_nebo.id,
          m_nebo_ds.id,
          uvula.id,
          povorot_golovi.id,
          atrofii.id,
          tonus.id,
          tonus_ds.id,
          fun_taz_or.id