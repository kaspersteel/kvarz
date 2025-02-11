   SELECT CONCAT(
          'Общее состояние - ',
          obsh_sost1.attr_938_,
          ', ',
          'сознание - ',
          sozn1.attr_976_,
          CASE
                    WHEN prim_rew2.attr_3348_ IS TRUE THEN CONCAT(
                    ', ЧМН: ',
                    CONCAT(
                    CASE
                              WHEN prim_rew2.attr_847_ = 2
                                     OR prim_rew2.attr_848_ = 2 THEN 'I пара :'
                                        ELSE 'I пара: без патологий.'
                    END,
                    CASE
                              WHEN prim_rew2.attr_847_ = 2 THEN 'Обоняние нарушено. '
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew2.attr_848_ = 2 THEN ' Носовые ходы не проходимы. '
                              ELSE NULL
                    END
                    ),
                    CONCAT(
                    CASE
                              WHEN prim_rew2.attr_850_ <> 1
                                     OR prim_rew2.attr_3553_ <> 1
                                     OR prim_rew2.attr_852_ <> 1
                                     OR prim_rew2.attr_853_ <> 2
                                     OR prim_rew2.attr_856_ <> 2
                                     OR prim_rew2.attr_857_ <> 2
                                     OR prim_rew2.attr_2074_ <> 2 THEN 'II пара: '
                                        ELSE 'II пара: без патологий. '
                    END,
                    CASE
                              WHEN prim_rew2.attr_850_ = 2 THEN CONCAT(
                              'Поля зрения: частичная гемианопсия ',
                              CASE
                                        WHEN prim_rew2.attr_2110_ = 1 THEN 'справа.'
                                        WHEN prim_rew2.attr_2110_ = 2 THEN 'слева.'
                                        WHEN prim_rew2.attr_2110_ = 3 THEN 'с обеих сторон.'
                              END
                              )
                              WHEN prim_rew2.attr_850_ = 3 THEN CONCAT('Поля зрения: ', prim_rew2.attr_4223_, '. ')
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew2.attr_3553_ <> 1 THEN CONCAT(
                              'Зрачки: ',
                              zr1.attr_3501_,
                              ', ',
                              prim_rew2.attr_854_,
                              '. '
                              )
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew2.attr_852_ <> 1 THEN CONCAT('Фотореакции: ', fotoreak1.attr_1027_, '. ')
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew2.attr_853_ <> 2 THEN CONCAT(
                              'Птоз: ',
                              ptoz1.attr_3501_,
                              ', ',
                              ptoz_ur1.attr_1025_,
                              '. '
                              )
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew2.attr_856_ = 1 THEN CONCAT(
                              'Нистагм: ',
                              nis1.attr_3501_,
                              ', ',
                              prim_rew2.attr_3558_,
                              '. '
                              )
                              WHEN prim_rew2.attr_856_ = 3 THEN CONCAT('Нистагм: ', prim_rew2.attr_3558_, '. ')
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew2.attr_857_ = 1 THEN CONCAT(
                              'Экзофтальм: ',
                              exzoftalm1.attr_3501_,
                              ', ',
                              prim_rew2.attr_3561_,
                              '. '
                              )
                              WHEN prim_rew2.attr_857_ = 3 THEN CONCAT('Экзофтальм: ', prim_rew2.attr_3561_, '. ')
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew2.attr_2074_ = 1 THEN CONCAT(
                              'Энофтальм: ',
                              enoftalm1.attr_3501_,
                              ', ',
                              prim_rew2.attr_3560_,
                              '. '
                              )
                              WHEN prim_rew2.attr_2074_ = 3 THEN CONCAT('Энофтальм: ', prim_rew2.attr_3560_, '. ')
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew2.attr_3882_ IS NOT NULL THEN CONCAT(
                              'Дополнительная информация по глазодвигательной группе: ',
                              prim_rew2.attr_3882_
                              )
                              ELSE NULL
                    END
                    ),
                    CONCAT(
                    CASE
                              WHEN prim_rew2.attr_858_ <> 6
                                     OR prim_rew2.attr_859_ <> 2
                                     OR prim_rew2.attr_860_ <> 2
                                     OR prim_rew2.attr_861_ <> 2
                                     OR prim_rew2.attr_3575_ <> 1
                                     OR prim_rew2.attr_864_ <> 1
                                     OR prim_rew2.attr_865_ <> 2 THEN 'V пара: '
                                        ELSE 'V пара: без патологий. '
                    END,
                    CASE
                              WHEN prim_rew2.attr_858_ = 1 THEN 'Оценка V пары невозможна. '
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew2.attr_859_ <> 2 THEN CONCAT(
                              'Болезненность в точках выхода тройничного нерва: ',
                              troi_nerv1.attr_3501_,
                              ', ',
                              troi_nerv_cifra1.attr_3585_,
                              '. '
                              )
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew2.attr_860_ = 1 THEN 'Нарушение чувствительности по корешковому типу. '
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew2.attr_861_ = 1 THEN 'Нарушение чувствительности по зонам Зельдера. '
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew2.attr_3575_ <> 1 THEN CONCAT(
                              'Пальпебральные рефлексы, назопальпебральный: ',
                              p_n_ref1.attr_3501_,
                              ', ',
                              prim_rew2.attr_1056_,
                              '. '
                              )
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew2.attr_864_ <> 1 THEN CONCAT(
                              'Мандибулярный рефлекс: ',
                              mand_ref1.attr_1028_,
                              '. '
                              )
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew2.attr_865_ = 1 THEN 'Нарушена функция жевательной мускулатуры. '
                              ELSE NULL
                    END
                    ),
                    CONCAT(
                    CASE
                              WHEN prim_rew2.attr_866_ <> 1
                                     OR prim_rew2.attr_868_ <> 1
                                     OR prim_rew2.attr_869_ <> 2
                                     OR prim_rew2.attr_870_ <> 1
                                     OR prim_rew2.attr_871_ <> 2
                                     OR prim_rew2.attr_872_ <> 2
                                     OR prim_rew2.attr_874_ <> 2
                                     OR prim_rew2.attr_873_ <> 1 THEN 'VII пара: '
                                        ELSE 'VII пара: без патологий. '
                    END,
                    CASE
                              WHEN prim_rew2.attr_866_ = 2 THEN 'Лицо ассиметрично. '
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew2.attr_868_ = 2 THEN CONCAT(
                              'Глазные щели: ассиметричны, ',
                              glaz_shel1.attr_3501_,
                              '. '
                              )
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew2.attr_869_ = 1 THEN CONCAT(
                              'Есть сглаженность складок на лбу, ',
                              skladki1.attr_3501_,
                              '. '
                              )
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew2.attr_870_ = 2 THEN CONCAT(
                              'Невозможность зажмуривания век, ',
                              veki1.attr_3501_,
                              '. '
                              )
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew2.attr_871_ = 1 THEN CONCAT(
                              'Есть симптом ресниц, ',
                              recnitci1.attr_3501_,
                              '. '
                              )
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew2.attr_872_ = 1 THEN CONCAT(
                              'Есть симптом ракетки: ',
                              raketka1.attr_2076_,
                              '. '
                              )
                              WHEN prim_rew2.attr_872_ = 3 THEN CONCAT('Симптом ракетки: ', prim_rew2.attr_4223_, '. ')
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew2.attr_873_ = 2 THEN CONCAT(
                              'Тонус лицевой мускалатуры снижен, ',
                              tonus_litca1.attr_3501_,
                              '. '
                              )
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew2.attr_874_ = 1 THEN 'Вкус на передних 2/3 языка изменен. '
                              ELSE NULL
                    END
                    ),
                    CONCAT(
                    CASE
                              WHEN prim_rew2.attr_877_ <> 6 THEN CONCAT(
                              'VIII пара: ',
                              'Шёпотная речь оценка - ',
                              shepotnaya_rech1.attr_1026_,
                              ', D = ',
                              prim_rew2.attr_875_,
                              ', S = ',
                              prim_rew2.attr_876_
                              )
                              ELSE 'VIII пара: без патологий. '
                    END
                    ),
                    CONCAT(
                    CASE
                              WHEN prim_rew2.attr_878_ <> 2
                                     OR prim_rew2.attr_879_ <> 1 THEN 'IX пара: '
                                        ELSE 'IX пара: без патологий. '
                    END,
                    CASE
                              WHEN prim_rew2.attr_878_ = 1 THEN 'Глотание нарушено. '
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew2.attr_879_ = 2 THEN CONCAT(
                              'Глоточные рефлексы не вызываются, ',
                              glot_ref1.attr_3501_,
                              '. '
                              )
                              ELSE NULL
                    END
                    ),
                    CONCAT(
                    CASE
                              WHEN prim_rew2.attr_2106_ <> 2
                                     OR prim_rew2.attr_882_ <> 1
                                     OR prim_rew2.attr_883_ <> 1
                                     OR prim_rew2.attr_884_ <> 1
                                     OR prim_rew2.attr_885_ <> 1 THEN 'X пара: '
                                        ELSE 'X пара: без патологий. '
                    END,
                    CASE
                              WHEN prim_rew2.attr_2106_ <> 2 THEN CONCAT('Фонация: ', fonation1.attr_2105_, '. ')
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew2.attr_882_ <> 1 THEN CONCAT(
                              'Мягкое небо: ',
                              m_nebo1.attr_1038_,
                              ', ',
                              m_nebo_ds1.attr_3501_,
                              '. '
                              )
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew2.attr_883_ = 2 THEN 'Мягкое небо не симметрично. '
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew2.attr_884_ = 2 THEN 'Небные рефлексы снижены. '
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew2.attr_885_ = 2 THEN CONCAT('uvula1 - отклонен, ', uvula1.attr_3501_, '. ')
                              ELSE NULL
                    END
                    ),
                    CONCAT(
                    CASE
                              WHEN prim_rew2.attr_886_ <> 8 THEN CONCAT(
                              'XI пара: ',
                              'Повороты головы и движения плечами: ',
                              povorot_golovi1.attr_1026_,
                              '. '
                              )
                              ELSE 'XI пара: без патологий. '
                    END
                    ),
                    CONCAT(
                    CASE
                              WHEN prim_rew2.attr_887_ <> 2
                                     OR prim_rew2.attr_888_ <> 1
                                     OR prim_rew2.attr_889_ <> 2
                                     OR prim_rew2.attr_890_ <> 2 THEN 'XII пара: '
                                        ELSE 'XII пара: без патологий. '
                    END,
                    CASE
                              WHEN prim_rew2.attr_887_ = 1 THEN 'Дизартрия. '
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew2.attr_888_ = 2 THEN 'Движения языком ограничены. '
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew2.attr_889_ = 1 THEN CONCAT(
                              'Фибриллярные подёргивания, атрофии, ',
                              atrofii1.attr_3501_,
                              '. '
                              )
                              ELSE NULL
                    END,
                    CASE
                              WHEN prim_rew2.attr_890_ = 1 THEN 'Девиация языка. '
                              ELSE NULL
                    END
                    )
                    )
                    ELSE NULL
          END,
          'Афазия - ',
          afaz1.attr_1020_,
          ' ',
          prim_rew2.attr_3717_,
          ', ',
          'глотание - ',
          glot1.attr_1035_,
          ', ',
          'фонация - ',
          fonac1.attr_2105_,
          '. ',
          CASE
                    WHEN prim_rew2.attr_3898_ IS TRUE THEN CONCAT(
                    'Сила в конечностях: ',
                    'в проксимальных отделах верхних конечностей - ',
                    'D - ',
                    prim_rew2.attr_896_,
                    'б, ',
                    'S - ',
                    prim_rew2.attr_897_,
                    'б, ',
                    'в дистальных отделах верхних конечностей - ',
                    'D - ',
                    prim_rew2.attr_898_,
                    'б, ',
                    'S -',
                    prim_rew2.attr_899_,
                    'б, ',
                    'в проксимальных отделах нижних конечностей - ',
                    'D - ',
                    prim_rew2.attr_900_,
                    'б, ',
                    'S - ',
                    prim_rew2.attr_901_,
                    'б, ',
                    'в дистальных отделах нижних конечностей - ',
                    'D - ',
                    prim_rew2.attr_902_,
                    'б, ',
                    'S - ',
                    prim_rew2.attr_903_,
                    'б. '
                    )
                    ELSE NULL
          END,
          'Чувствительность: ',
          prim_rew2.attr_2118_,
          '. ',
          (
          CASE
                    WHEN prim_rew2.attr_910_ = 2 THEN 'Патологических рефлексов нет. '
                    ELSE CONCAT('Патологические рефлексы:', prim_rew2.attr_3570_)
          END
          ),
          'Тонус мышц: ',
          tonus1.attr_1049_,
          (
          CASE
                    WHEN prim_rew2.attr_3569_ IS NOT NULL THEN CONCAT(', ', tonus_ds1.attr_3501_, '. ')
                    ELSE '. '
          END
          ),
          'Походка - ',
          pohod1.attr_1054_,
          prim_rew2.attr_3897_,
          '. ',
          'Костно-суставная система: ',
          kost_sust.attr_2098_,
          '  ',
          CASE
                    WHEN prim_rew2.attr_3349_ IS NOT NULL THEN CONCAT(prim_rew2.attr_3349_, ', ')
                    ELSE NULL
          END,
          CASE
                    WHEN prim_rew2.attr_3350_ IS NOT NULL THEN CONCAT(prim_rew2.attr_3350_, ', ')
                    ELSE NULL
          END,
          CASE
                    WHEN prim_rew2.attr_2145_ IS NOT NULL THEN CONCAT(prim_rew2.attr_2145_, '.')
                    ELSE NULL
          END,
          'Координаторные пробы: поза Ромберга - ',
          romberg1.attr_1050_,
          ', ',
          'ПНП - ',
          pnp1.attr_1051_,
          ' ',
          pnp_storona1.attr_1052_,
          ' ',
          prim_rew2.attr_3659_,
          ' ',
          'ПКП - ',
          pkp1.attr_1051_,
          ' ',
          pkp_storona1.attr_1052_,
          ' ',
          prim_rew2.attr_3658_,
          '. ',
          'Функция тазовых органов: ',
          fun_taz_or1.attr_1055_,
          CASE
                    WHEN prim_rew2.attr_2100_ IS NOT NULL THEN CONCAT(' ', prim_rew2.attr_2100_, '. ')
                    ELSE '. '
          END
          )
     FROM registry.object_2993_ o
LEFT JOIN registry.object_793_ prim_rew2 ON prim_rew2.attr_1061_ = o.attr_3015_
      AND prim_rew2.attr_3038_ = 2
      AND prim_rew2.is_deleted <> TRUE
LEFT JOIN registry.object_937_ obsh_sost1 ON prim_rew2.attr_812_ = obsh_sost1.id
      AND obsh_sost1.is_deleted <> TRUE
LEFT JOIN registry.object_975_ sozn1 ON prim_rew2.attr_843_ = sozn1.id
      AND sozn1.is_deleted <> TRUE
LEFT JOIN registry.object_977_ afaz1 ON prim_rew2.attr_844_ = afaz1.id
      AND afaz1.is_deleted <> TRUE
LEFT JOIN registry.object_929_ kogn_nar1 ON prim_rew2.attr_845_ = kogn_nar1.id
      AND kogn_nar1.is_deleted <> TRUE
LEFT JOIN registry.object_995_ glot1 ON prim_rew2.attr_878_ = glot1.id
      AND glot1.is_deleted <> TRUE
LEFT JOIN registry.object_2104_ fonac1 ON prim_rew2.attr_2106_ = fonac1.id
      AND fonac1.is_deleted <> TRUE
LEFT JOIN registry.object_1018_ pohod1 ON prim_rew2.attr_917_ = pohod1.id
      AND pohod1.is_deleted <> TRUE
LEFT JOIN registry.object_2097_ kost_sust ON prim_rew2.attr_2099_ = kost_sust.id
      AND kost_sust.is_deleted <> TRUE
LEFT JOIN registry.object_1014_ romberg1 ON prim_rew2.attr_912_ = romberg1.id
      AND romberg1.is_deleted <> TRUE
LEFT JOIN registry.object_1015_ pnp1 ON prim_rew2.attr_913_ = pnp1.id
      AND pnp1.is_deleted <> TRUE
LEFT JOIN registry.object_1016_ pnp_storona1 ON prim_rew2.attr_2071_ = pnp_storona1.id
      AND pnp_storona1.is_deleted <> TRUE
LEFT JOIN registry.object_1015_ pkp1 ON prim_rew2.attr_914_ = pkp1.id
      AND pkp1.is_deleted <> TRUE
LEFT JOIN registry.object_1016_ pkp_storona1 ON prim_rew2.attr_2073_ = pkp_storona1.id
      AND pkp_storona1.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ zr1 ON zr1.id = prim_rew2.attr_3553_
      AND zr1.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ nis1 ON nis1.id = prim_rew2.attr_3565_
      AND nis1.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ ptoz1 ON ptoz1.id = prim_rew2.attr_3554_
      AND ptoz1.is_deleted <> TRUE
LEFT JOIN registry.object_984_ ptoz_ur1 ON ptoz_ur1.id = prim_rew2.attr_855_
      AND ptoz_ur1.is_deleted <> TRUE
LEFT JOIN registry.object_986_ fotoreak1 ON fotoreak1.id = prim_rew2.attr_852_
      AND fotoreak1.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ exzoftalm1 ON exzoftalm1.id = prim_rew2.attr_3566_
      AND exzoftalm1.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ enoftalm1 ON enoftalm1.id = prim_rew2.attr_3567_
      AND enoftalm1.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ troi_nerv1 ON troi_nerv1.id = prim_rew2.attr_3568_
      AND troi_nerv1.is_deleted <> TRUE
LEFT JOIN registry.object_3584_ troi_nerv_cifra1 ON troi_nerv_cifra1.id = prim_rew2.attr_3586_
      AND troi_nerv_cifra1.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ p_n_ref1 ON p_n_ref1.id = prim_rew2.attr_3575_
      AND p_n_ref1.is_deleted <> TRUE
LEFT JOIN registry.object_987_ mand_ref1 ON mand_ref1.id = prim_rew2.attr_864_
      AND mand_ref1.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ glaz_shel1 ON glaz_shel1.id = prim_rew2.attr_3579_
      AND glaz_shel1.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ skladki1 ON skladki1.id = prim_rew2.attr_3580_
      AND skladki1.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ veki1 ON veki1.id = prim_rew2.attr_3581_
      AND veki1.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ recnitci1 ON recnitci1.id = prim_rew2.attr_3582_
      AND recnitci1.is_deleted <> TRUE
LEFT JOIN registry.object_2075_ raketka1 ON raketka1.id = prim_rew2.attr_2077_
      AND raketka1.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ tonus_litca1 ON tonus_litca1.id = prim_rew2.attr_3583_
      AND tonus_litca1.is_deleted <> TRUE
LEFT JOIN registry.object_985_ shepotnaya_rech1 ON shepotnaya_rech1.id = prim_rew2.attr_877_
      AND shepotnaya_rech1.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ glot_ref1 ON glot_ref1.id = prim_rew2.attr_3578_
      AND glot_ref1.is_deleted <> TRUE
LEFT JOIN registry.object_999_ m_nebo1 ON m_nebo1.id = prim_rew2.attr_882_
      AND m_nebo1.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ m_nebo_ds1 ON m_nebo_ds1.id = prim_rew2.attr_3577_
      AND m_nebo_ds1.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ uvula1 ON uvula1.id = prim_rew2.attr_2109_
      AND uvula1.is_deleted <> TRUE
LEFT JOIN registry.object_2104_ fonation1 ON fonation1.id = prim_rew2.attr_2106_
      AND fonation1.is_deleted <> TRUE
LEFT JOIN registry.object_985_ povorot_golovi1 ON povorot_golovi1.id = prim_rew2.attr_886_
      AND povorot_golovi1.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ atrofii1 ON atrofii1.id = prim_rew2.attr_3576_
      AND atrofii1.is_deleted <> TRUE
LEFT JOIN registry.object_1013_ tonus1 ON tonus1.id = prim_rew2.attr_911_
      AND tonus1.is_deleted <> TRUE
LEFT JOIN registry.object_3500_ tonus_ds1 ON tonus_ds1.id = prim_rew2.attr_3569_
      AND tonus_ds1.is_deleted <> TRUE
LEFT JOIN registry.object_1019_ fun_taz_or1 ON fun_taz_or1.id = prim_rew2.attr_918_
      AND fun_taz_or1.is_deleted <> TRUE
    WHERE NOT o.is_deleted
 GROUP BY prim_rew2.id,
          obsh_sost1.id,
          sozn1.id,
          afaz1.id,
          kogn_nar1.id,
          glot1.id,
          fonac1.id,
          pohod1.id,
          kost_sust.id,
          pkp_storona1.id,
          pkp1.id,
          pnp_storona1.id,
          pnp1.id,
          romberg1.id,
          zr1.id,
          ptoz1.id,
          ptoz_ur1.id,
          nis1.id,
          fotoreak1.id,
          exzoftalm1.id,
          enoftalm1.id,
          troi_nerv1.id,
          troi_nerv_cifra1.id,
          p_n_ref1.id,
          mand_ref1.id,
          glaz_shel1.id,
          skladki1.id,
          veki1.id,
          recnitci1.id,
          raketka1.id,
          tonus_litca1.id,
          shepotnaya_rech1.id,
          glot_ref1.id,
          fonation1.id,
          m_nebo1.id,
          m_nebo_ds1.id,
          uvula1.id,
          povorot_golovi1.id,
          atrofii1.id,
          tonus1.id,
          tonus_ds1.id,
          fun_taz_or1.id