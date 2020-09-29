USE dashboards;

DROP FUNCTION IF EXISTS buildIncludeExcludeString;

DELIMITER //
CREATE FUNCTION buildIncludeExcludeString(
  p_includedExclude VARCHAR(10), 
  p_includedAnyAll VARCHAR(10), 
  p_timeperioddaterange VARCHAR(255),
  p_concepttab VARCHAR(64),
  p_observationcohorttab VARCHAR(64),
  p_earliestlatestobservationtab VARCHAR(64),
  p_includedAnyAllTested VARCHAR(10), 
  p_includedAnyAllTestedConcepttab VARCHAR(10), 
  p_includedAreNot VARCHAR(10), 
  p_includedAnyAllFollowedBy VARCHAR(10), 
  p_includedFollowedByConcepttab VARCHAR(64),
  p_filtertype INT  
)
RETURNS VARCHAR(1000)
NOT DETERMINISTIC READS SQL DATA
BEGIN

DECLARE includeexcludestring VARCHAR(1000);

SET p_includedExclude = UPPER(p_includedExclude);
SET p_includedExclude = IF(p_includedExclude = 'EXCLUDE','NOT EXISTS',IF(p_includedExclude = 'INCLUDE','EXISTS',''));
SET p_includedAnyAll = UPPER(p_includedAnyAll);

SET p_includedAnyAllTested = UPPER(p_includedAnyAllTested);
SET p_includedAnyAllFollowedBy = UPPER(p_includedAnyAllFollowedBy); 

SET p_includedAreNot = UPPER(p_includedAreNot);
SET p_includedAreNot = IF(p_includedAreNot = 'ARE',' ',IF(p_includedAreNot = 'ARE NOT','NOT',''));


IF p_filtertype = 1 THEN 

SET includeexcludestring = 
CONCAT(p_includedExclude,' (SELECT 1 FROM ', p_observationcohorttab, ' o1 
WHERE o1.non_core_concept_id = ', p_includedAnyAll,
' (SELECT o2.non_core_concept_id FROM ',p_observationcohorttab,' o2 
JOIN ', p_concepttab,' c ON o2.non_core_concept_id = c.non_core_concept_id 
WHERE o2.patient_id = o1.patient_id AND ',p_timeperioddaterange,' ) 
AND o.patient_id = o1.patient_id)');

ELSEIF p_filtertype = 2 THEN  

SET includeexcludestring = 
CONCAT(p_includedExclude,' (SELECT 1 FROM ', p_observationcohorttab, ' o1 
WHERE o1.non_core_concept_id = ', p_includedAnyAll,
' (SELECT o2.non_core_concept_id FROM ',p_earliestlatestobservationtab,' o2 
WHERE o2.patient_id = o1.patient_id ) 
AND o.patient_id = o1.patient_id)');

ELSEIF p_filtertype = 3 THEN  

SET includeexcludestring = 
CONCAT(p_includedExclude,' (SELECT 1 FROM ', p_observationcohorttab, ' o1 
WHERE o1.non_core_concept_id = ', p_includedAnyAll,
' (SELECT o2.non_core_concept_id FROM ',p_earliestlatestobservationtab,' o2 
WHERE o2.patient_id = o1.patient_id 
AND o2.non_core_concept_id = ',p_includedAnyAllTestedConcepttab,' (SELECT c.non_core_concept_id FROM ',p_concepttab,' c )) 
AND o.patient_id = o1.patient_id)'); 

ELSEIF p_filtertype = 4 THEN 

SET includeexcludestring = 
CONCAT(p_includedExclude,' (SELECT 1 FROM ', p_observationcohorttab, ' o1 
WHERE o1.non_core_concept_id = ', p_includedAnyAll,
' (SELECT o3.non_core_concept_id FROM ',p_observationcohorttab,' o3 
JOIN ', p_concepttab,' c ON o3.non_core_concept_id = c.non_core_concept_id 
WHERE o3.patient_id = o1.patient_id 
AND  ',p_includedAreNot,' o3.non_core_concept_id =  ',p_includedAnyAllFollowedBy,
' (SELECT o2.non_core_concept_id 
FROM ',p_observationcohorttab,' o2 JOIN ',p_includedFollowedByConcepttab,' c2 ON o2.non_core_concept_id = c2.non_core_concept_id 
WHERE o2.patient_id = o3.patient_id 
AND ',p_timeperioddaterange,')) 
AND o.patient_id = o1.patient_id)');


END IF;

RETURN includeexcludestring;

END//
DELIMITER ;
