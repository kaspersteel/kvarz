DECLARE 
/*parameters JSONB := '{"id": 10, "role_id": 1, "user_id": 46}';*/
do_user INT := (parameters ->> 'user_id')::INT;
id_invoice BIGINT := (parameters ->> 'id')::BIGINT;
npp_request INT; -- очередной номер создаваемой заявки
id_new_request BIGINT; -- id созданной заявки
tab_invoice RECORD; -- запись о материале в накладной
x BIGINT; -- id записи ед. хранения
i INT := 1; -- счётчик записей в табличной части заявки
/* переменные батч-цикла создания заявок */
lh_ids_tab_invoice INT; -- количество принятых единиц по ключу (поставщик-материал-плавка-партия)
v_batch_size INT := 10; -- количество образцов в одной заявке
v_from INT := 1;
v_to INT;
v_slice BIGINT[];

BEGIN

	/*получение очередного номера заявки*/
    SELECT COALESCE(MAX(attr_279_) + 1, 1)
           INTO npp_request
    FROM registry.object_118_
    WHERE NOT is_deleted
          AND DATE_PART('year', attr_121_) = DATE_PART('year', CURRENT_DATE);

/*получаем записи материалов со статусом "ВК" и группируем их в заявки по ключу (поставщик-материал-плавка-партия) */
FOR tab_invoice IN (
   SELECT array_agg(tab.id ORDER BY tab.attr_110_, tab.id) AS ids_tab_invoice,
          tab.attr_94_ AS id_material,
          tab.attr_96_ AS n_melting,
          tab.attr_267_ AS n_party
     FROM registry.object_30_ tab
    WHERE tab.attr_110_ = id_invoice
	  AND tab.attr_808_ = 2 
      AND NOT tab.is_deleted
 GROUP BY tab.attr_110_, tab.attr_94_, tab.attr_96_, tab.attr_267_
) LOOP

lh_ids_tab_invoice := array_length(tab_invoice.ids_tab_invoice, 1);

/* запускаем батч-цикл создания заявок с делением количества образцов */
WHILE v_from <= lh_ids_tab_invoice LOOP
    /* конец части массива */
	v_to := LEAST(v_from + v_batch_size - 1, lh_ids_tab_invoice);
    /* батч-массив */
    v_slice := tab_invoice.ids_tab_invoice[v_from:v_to];
    
    /*создание заявки на ВК*/
   INSERT INTO registry.object_118_ (
          attr_121_,
          attr_138_,
          attr_278_,
          attr_279_,
          attr_292_,
          attr_756_,
          attr_759_,
          attr_760_,
          attr_761_,
		  operation_user_id
          )
   VALUES (
   		  CURRENT_DATE,
		  1,
          id_invoice,
		  npp_request,
		  do_user,
		  1,
          tab_invoice.id_material,
          tab_invoice.n_melting,
          tab_invoice.n_party,
		  do_user
          )
RETURNING id INTO id_new_request;

/*создание таблицы заявки на ВК*/
FOREACH x IN ARRAY v_slice LOOP
   INSERT INTO registry.object_124_ (
          attr_126_, -- заявка
          attr_127_, -- ед. хран.
     	  attr_130_, -- кол-во образцов
          attr_131_, -- номера образцов
          attr_132_, -- лаборатории
          attr_272_, -- №пп
          attr_285_, -- приходная накладная
     	  attr_289_, -- на печать
     	  attr_762_, -- статус
		  operation_user_id
          )
   SELECT id_new_request,
   		  x,
          COALESCE(mat_dir.attr_856_, up_mat_dir.attr_856_, 1)::text,
          samples.n::text,
          COALESCE(mat_dir.attr_755_, up_mat_dir.attr_755_),
          i,
          id_invoice,
     	  TRUE,
          3, -- статус "допуск"
 		  do_user
     FROM registry.object_30_ smp
LEFT JOIN registry.object_58_ mat_dir ON mat_dir.id = smp.attr_94_ AND NOT mat_dir.is_deleted
LEFT JOIN registry.object_58_ up_mat_dir ON up_mat_dir.id = mat_dir.attr_61_ AND NOT up_mat_dir.is_deleted
LEFT JOIN LATERAL ( SELECT string_agg(concat_ws(', ', smp.attr_97_||'-'||gs.seq_num), ' ,') AS n
                      FROM generate_series(1, COALESCE(mat_dir.attr_856_, up_mat_dir.attr_856_, 1)) AS gs(seq_num) 
                    ) samples ON true
    WHERE smp.id = x; 

    UPDATE registry.object_30_
       SET attr_269_ = id_new_request,
		   operation_user_id = do_user
     WHERE id = x;
    	i := i + 1;
	END LOOP;
    /* начало новой части массива */
    v_from := v_from + v_batch_size;
    /* номер следующей заявки по тому же ключу (поставщик-материал-плавка-партия)*/
    npp_request := npp_request + 1; 
	i := 1;
END LOOP;
/* номер следующей заявки по новому ключу (поставщик-материал-плавка-партия)*/
npp_request := npp_request + 1; 
i := 1;
END LOOP;
END