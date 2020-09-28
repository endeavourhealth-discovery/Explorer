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
  p_filtertype INT  
)
RETURNS VARCHAR(1000)
NOT DETERMINISTIC READS SQL DATA
BEGIN

DECLARE includeexcludestring VARCHAR(1000);

SET p_includedExclude = UPPER(p_includedExclude);
SET p_includedExclude = IF(p_includedExclude = 'EXCLUDE','NOT',IF(p_includedExclude = 'INCLUDE','',''));
SET p_includedAnyAll = UPPER(p_includedAnyAll);

SET p_includedAnyAllTested = UPPER(p_includedAnyAllTested);

IF p_filtertype = 1 THEN 

SET includeexcludestring = CONCAT(p_includedExclude,
' o.patient_id = ', p_includedAnyAll, 
' (SELECT o2.patient_id FROM ', p_observationcohorttab,
' o2 JOIN ',p_concepttab,
' c ON o2.non_core_concept_id = c.non_core_concept_id  WHERE ', p_timeperioddaterange,' )');

ELSEIF p_filtertype = 2 THEN  

SET includeexcludestring = CONCAT(p_includedExclude,
' o.patient_id = ', p_includedAnyAll, 
' (SELECT o2.patient_id FROM ', p_earliestlatestobservationtab,' o2 )');

ELSEIF p_filtertype = 3 THEN  

SET includeexcludestring = CONCAT(p_includedExclude,
' o.patient_id = ', p_includedAnyAll, 
' (SELECT o2.patient_id 
   FROM ', p_earliestlatestobservationtab,' o2 
   WHERE o2.non_core_concept_id = ',p_includedAnyAllTested, 
   ' (SELECT c.non_core_concept_id FROM ',p_concepttab,' c))');

END IF;

RETURN includeexcludestring;

END//
DELIMITER ;
