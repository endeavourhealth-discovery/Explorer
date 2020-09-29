USE dashboards;

DROP PROCEDURE IF EXISTS buildIncludeExcludeString;

DELIMITER //
CREATE PROCEDURE buildIncludeExcludeString(
  IN p_includedExclude VARCHAR(10), 
  IN p_includedAnyAll VARCHAR(10), 
  IN p_timeperioddaterange VARCHAR(255),
  IN p_concepttab VARCHAR(64),
  IN p_observationcohorttab VARCHAR(64),
  IN p_earliestlatestobservationtab VARCHAR(64),
  IN p_includedAnyAllTested VARCHAR(10), 
  IN p_includedAnyAllTestedConcepttab VARCHAR(10), 
  IN p_includedAreNot VARCHAR(10), 
  IN p_includedAnyAllFollowedBy VARCHAR(10), 
  IN p_includedFollowedByConcepttab VARCHAR(64),
  IN p_incoccurrencestab VARCHAR(64), 
  IN p_greaterless VARCHAR(10), 
  IN p_greaterlessvalue VARCHAR(10), 
  IN p_filtertype INT,
  OUT p_includeexcludestring VARCHAR(1000)
)

BEGIN

SET p_includedExclude = UPPER(p_includedExclude);
SET p_includedExclude = IF(p_includedExclude = 'EXCLUDE','NOT EXISTS',IF(p_includedExclude = 'INCLUDE','EXISTS',''));
SET p_includedAnyAll = UPPER(p_includedAnyAll);

SET p_includedAnyAllTested = UPPER(p_includedAnyAllTested);
SET p_includedAnyAllFollowedBy = UPPER(p_includedAnyAllFollowedBy); 

SET p_includedAreNot = UPPER(p_includedAreNot);
SET p_includedAreNot = IF(p_includedAreNot = 'ARE',' ',IF(p_includedAreNot = 'ARE NOT','NOT',''));

IF p_filtertype = 1 THEN 

SET p_includeexcludestring = 
CONCAT(p_includedExclude,' (SELECT 1 FROM ', p_observationcohorttab, ' o1 
WHERE o1.non_core_concept_id = ', p_includedAnyAll,
' (SELECT o2.non_core_concept_id FROM ', p_observationcohorttab,' o2 
JOIN ', p_concepttab,' c ON o2.non_core_concept_id = c.non_core_concept_id 
WHERE o2.patient_id = o1.patient_id AND ', p_timeperioddaterange,' ) 
AND o.patient_id = o1.patient_id)');

ELSEIF p_filtertype = 2 THEN  

SET p_includeexcludestring = 
CONCAT(p_includedExclude,' (SELECT 1 FROM ', p_observationcohorttab, ' o1 
WHERE o1.non_core_concept_id = ', p_includedAnyAll,
' (SELECT o2.non_core_concept_id FROM ', p_earliestlatestobservationtab,' o2 
WHERE o2.patient_id = o1.patient_id ) 
AND o.patient_id = o1.patient_id)');

ELSEIF p_filtertype = 3 THEN  

SET p_includeexcludestring = 
CONCAT(p_includedExclude,' (SELECT 1 FROM ', p_observationcohorttab, ' o1 
WHERE o1.non_core_concept_id = ', p_includedAnyAll,
' (SELECT o2.non_core_concept_id FROM ',p_earliestlatestobservationtab,' o2 
WHERE o2.patient_id = o1.patient_id 
AND o2.non_core_concept_id = ', p_includedAnyAllTestedConcepttab,' (SELECT c.non_core_concept_id FROM ', p_concepttab,' c )) 
AND o.patient_id = o1.patient_id)'); 

ELSEIF p_filtertype = 4 THEN 

SET p_includeexcludestring = 
CONCAT(p_includedExclude,' (SELECT 1 FROM ', p_observationcohorttab, ' o1 
WHERE o1.non_core_concept_id = ', p_includedAnyAll,
' (SELECT o3.non_core_concept_id FROM ', p_observationcohorttab,' o3 
JOIN ', p_concepttab,' c ON o3.non_core_concept_id = c.non_core_concept_id 
WHERE o3.patient_id = o1.patient_id 
AND  ', p_includedAreNot,' o3.non_core_concept_id =  ', p_includedAnyAllFollowedBy,
' (SELECT o2.non_core_concept_id 
FROM ', p_observationcohorttab,' o2 JOIN ', p_includedFollowedByConcepttab,' c2 ON o2.non_core_concept_id = c2.non_core_concept_id 
WHERE o2.patient_id = o3.patient_id 
AND ', p_timeperioddaterange,')) 
AND o.patient_id = o1.patient_id)');

ELSEIF p_filtertype = 5 THEN

   SET @sql = CONCAT('DROP TABLE IF EXISTS ', p_incoccurrencestab);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('CREATE TABLE ', p_incoccurrencestab, ' AS 
   SELECT a.patient_id FROM (SELECT o2.patient_id, COUNT(DISTINCT c2.non_core_concept_id) 
   FROM ', p_observationcohorttab,' o2 JOIN ', p_concepttab,' c2 ON o2.non_core_concept_id = c2.non_core_concept_id 
   WHERE ', p_timeperioddaterange,' GROUP BY o2.patient_id 
   HAVING COUNT(DISTINCT c2.non_core_concept_id) ', p_greaterless,' ', p_greaterlessvalue,') a');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('ALTER TABLE ', p_incoccurrencestab,' ADD INDEX pat_idx(patient_id)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET p_includeexcludestring = 
   CONCAT(p_includedExclude,' (SELECT 1 FROM ', p_observationcohorttab, ' o1 
   WHERE o1.non_core_concept_id = ANY (SELECT o2.non_core_concept_id FROM ', 
   p_observationcohorttab,' o2 JOIN ', p_concepttab,' c ON o2.non_core_concept_id = c.non_core_concept_id 
   WHERE WHERE o2.patient_id = o1.patient_id 
   AND EXISTS (SELECT 1 FROM ', p_incoccurrencestab,' oc WHERE oc.patient_id = o2.patient_id ) ) 
   AND o.patient_id = o1.patient_id)'
   );


END IF;

END//
DELIMITER ;
