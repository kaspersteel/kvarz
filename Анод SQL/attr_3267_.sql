--Кол-во принятое по послед. выпол. ТО 

/*новый корректный для трёх параметров*/
SELECT 
o.id,
--t_op.attr_2152_ AS prinyato_master, /*принято мастером*/
t_op.attr_3208_ AS step, /*последний шаг*/
sprav_to.attr_547_ AS name_to /*последняя операция*/
,CASE WHEN t_op.attr_2609_ IS NOT NULL THEN t_op.attr_2609_ else t_op.attr_2152_ END AS quant_to /*принято по последней операции*/
FROM registry.object_2137_ o
LEFT JOIN registry.object_2138_ t_op ON t_op.attr_2148_ = o.id
AND t_op.attr_3208_ = (SELECT MAX (a.attr_3208_) FROM registry.object_2138_ a WHERE a.is_deleted=false AND a.attr_2152_ IS NOT NULL AND a.attr_2148_ = o.id) 
LEFT JOIN registry.object_545_ sprav_to ON t_op.attr_2149_= sprav_to.id
--WHERE t_op.attr_3208_ = (SELECT MAX (a.attr_3208_) FROM registry.object_2138_ a WHERE a.is_deleted=false AND a.attr_2152_ IS NOT NULL AND a.attr_2148_ = o.id)
GROUP BY 
o.id, 
step, 
name_to, 
quant_to 
--,prinyato_master
HAVING t_op.attr_3208_ is not null

--новый для плагина
public function getDataStepAndTO(int $id): ?array{    return $this->entityManager->getConnection()->createQueryBuilder()        
->select("t_op.attr_3208_ AS step /*последний шаг*/, 
	sprav_to.attr_547_ AS name_to /*последняя операция*/")
>from("registry.object_2137_ o
LEFT JOIN registry.object_2138_ t_op ON t_op.attr_2148_ = :id
AND t_op.attr_3208_ = (SELECT MAX (a.attr_3208_) FROM registry.object_2138_ a WHERE a.is_deleted=false AND a.attr_2152_ IS NOT NULL AND a.attr_2148_ = :id) 
LEFT JOIN registry.object_545_ sprav_to ON t_op.attr_2149_= sprav_to.id")
>groupBy("step, name_to")


--Старый вариант для кол-ва
(SELECT
/*если принималось ОТК, то взять количество, принятого ОТК, иначе - принятое мастером*/
CASE WHEN o1.attr_2609_ IS NOT NULL THEN o1.attr_2609_ ELSE o1.attr_2152_ END 
FROM 
 /*Технологические операции по ПВ*/
 registry.object_2138_ o1
 /*по этой ПВ где что-то принято*/
 where o1.is_deleted<>true AND o1.attr_2152_ IS NOT NULL AND o1.attr_2148_ = o.id 
 /*количество из последнего шага*/
 order by o1.attr_2148_, o1.attr_3208_ DESC LIMIT 1)

/*новый с подзапросом не доделанный*/
SELECT 
o.id
, last_oper.maxs
, last_oper.prinyato
, last_oper.step --последний шаг
, last_oper.name_to --последняя операция
, last_oper.quant_to --принято по последней операции
FROM registry.object_2137_ o
LEFT JOIN (SELECT
/*если принималось ОТК, то взять количество, принятого ОТК, иначе - принятое мастером*/
o1.attr_2148_ AS nop, o1.attr_2152_ AS prinyato, o1.attr_3208_ AS step, sprav_to.attr_547_ AS name_to, CASE WHEN o1.attr_2609_ IS NOT NULL THEN o1.attr_2609_ else o1.attr_2152_ END AS quant_to, MAX(o1.attr_3208_) as maxs
FROM
 /*Технологические операции по ПВ*/
 registry.object_2137_ o, registry.object_2138_ o1
 LEFT JOIN registry.object_545_ sprav_to ON o1.attr_2149_= sprav_to.id AND o1.is_deleted<>true AND o1.attr_2152_ IS NOT NULL
 /*по этой ПВ где что-то принято*/
 WHERE o1.is_deleted<>true AND o1.attr_2152_ IS NOT NULL AND o.is_deleted = false AND o1.attr_2148_ = o.id 
 /*количество из последнего шага*/
 GROUP BY o1.attr_2148_, o1.attr_3208_, o1.attr_2152_, sprav_to.attr_547_, o1.attr_2609_
 ORDER BY o1.attr_2148_, o1.attr_3208_ DESC /*limit 1*/
 ) AS last_oper ON last_oper.nop = o.id and 
 --GROUP BY last_oper.step, last_oper.name_to, last_oper.quant_to