USE dashboards;

DROP PROCEDURE IF EXISTS buildIncludeExcludeString;

DELIMITER //
CREATE PROCEDURE buildIncludeExcludeString(
  IN p_includedExclude VARCHAR(10), 
  IN p_includedAnyAll VARCHAR(10), 
  IN p_timeperioddaterange VARCHAR(255),
  IN p_concepttab VARCHAR(64),
  IN p_observationcohorttab VARCHAR(64),
  IN p_filtertab VARCHAR(64),
  IN p_includedEarliestLatest VARCHAR(20),
  IN p_includedOperator VARCHAR(50),
  IN p_includedEntryValue VARCHAR(20), 
  IN p_includedAnyAllTested VARCHAR(10), 
  IN p_includedAnyAllTestedConcepttab VARCHAR(64), 
  IN p_includedAreNot VARCHAR(10), 
  IN p_includedAnyAllFollowedBy VARCHAR(10), 
  IN p_includedFollowedByConcepttab VARCHAR(64),
  IN p_greaterless VARCHAR(50), 
  IN p_greaterlessvalue VARCHAR(20), 
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
SET p_includedAreNot = IF(p_includedAreNot = 'ARE','EXISTS ',IF(p_includedAreNot = 'ARE NOT','NOT EXISTS',''));

SET p_greaterless = IF(p_greaterless = 'Greater than',' > ',' < '); 

IF p_filtertype = 1 THEN 

   SET @sql = CONCAT('DROP TABLE IF EXISTS ', p_filtertab);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   -- create a patient observation cohort which contains any or all the selected value sets in the selected time period if applicable
   SET @sql = CONCAT('CREATE TABLE ', p_filtertab, ' AS 
   SELECT DISTINCT o2.patient_id 
   FROM ', p_observationcohorttab,' o2 
   WHERE o2.value_set_code_type = ', p_includedAnyAll,' (SELECT DISTINCT c.value_set_code_type FROM ', p_concepttab,' c ) 
   AND ', p_timeperioddaterange);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('ALTER TABLE ', p_filtertab,' ADD INDEX pat_idx (patient_id)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET p_includeexcludestring = CONCAT(p_includedExclude,' (SELECT 1 FROM ', p_filtertab, ' o1 WHERE o1.patient_id = o.patient_id)');

ELSEIF p_filtertype = 2 THEN  

   DROP TEMPORARY TABLE IF EXISTS qry_tmp_1;
   -- create a temporary patient observation cohort which contains any or all of the selected value sets
   SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp_1 AS 
   SELECT o1.id, 
          o1.patient_id, 
          o1.clinical_effective_date, 
          o1.result_value, 
          o1.non_core_concept_id, 
          o1.value_set_code_type 
   FROM ', p_observationcohorttab,' o1 
   WHERE o1.value_set_code_type = ', p_includedAnyAll,' (SELECT DISTINCT c.value_set_code_type FROM ', p_concepttab,' c )');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   ALTER TABLE qry_tmp_1 ADD INDEX pat_idx (patient_id);
   ALTER TABLE qry_tmp_1 ADD INDEX non_core_concept_idx (non_core_concept_id);

   -- from the patient observation cohort:
   -- 1 filter out the patient observations with result values greater or less than the included value and within the selected time period if applicable
   -- 2 filter out the latest or earliest of these into a new table
   CALL filterObservationByEarliestLatest(p_concepttab, 'qry_tmp_1', p_filtertab, p_includedEarliestLatest, p_includedOperator, p_includedEntryValue, p_timeperioddaterange);

   SET p_includeexcludestring = CONCAT(p_includedExclude,' (SELECT 1 FROM ', p_filtertab,' o1 WHERE o.patient_id = o1.patient_id)');

ELSEIF p_filtertype = 3 THEN  

   DROP TEMPORARY TABLE IF EXISTS qry_tmp_1;
   -- create a temporary patient observation cohort which contains any or all of the selected value sets
   SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp_1 AS 
   SELECT o1.id, 
          o1.patient_id, 
          o1.clinical_effective_date, 
          o1.result_value, 
          o1.non_core_concept_id, 
          o1.value_set_code_type 
   FROM ', p_observationcohorttab,' o1 
   WHERE o1.value_set_code_type = ', p_includedAnyAll,' (SELECT DISTINCT c.value_set_code_type FROM ', p_concepttab,' c)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   ALTER TABLE qry_tmp_1 ADD INDEX pat_idx (patient_id);
   ALTER TABLE qry_tmp_1 ADD INDEX non_core_concept_idx (non_core_concept_id);

   -- from the patient observation cohort:
   -- 1 filter out the latest or earliest of these observation concepts within the selected time period if applicable
   CALL filterObservationByEarliestLatest(p_concepttab, 'qry_tmp_1', p_filtertab, p_includedEarliestLatest, NULL, NULL, p_timeperioddaterange);

   -- filter out the patients which contain any or all of the selected tested value sets which are then to be included or excluded
   SET p_includeexcludestring = CONCAT(p_includedExclude,' (SELECT 1 FROM ', p_filtertab, ' o1 WHERE o1.value_set_code_type = ', 
   p_includedAnyAllTested,' (SELECT DISTINCT c.value_set_code_type FROM ', p_includedAnyAllTestedConcepttab,' c ) AND o.patient_id = o1.patient_id)'); 

ELSEIF p_filtertype = 4 THEN 

   DROP TEMPORARY TABLE IF EXISTS qry_tmp_1;
   -- create a temporary patient observation cohort which contains any or all of the selected value sets
   SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp_1 AS 
   SELECT DISTINCT o1.patient_id 
   FROM ', p_observationcohorttab,' o1 
   WHERE o1.value_set_code_type = ', p_includedAnyAll,' (SELECT DISTINCT c.value_set_code_type FROM ', p_concepttab,' c )');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   ALTER TABLE qry_tmp_1 ADD INDEX pat_idx (patient_id);

   DROP TEMPORARY TABLE IF EXISTS qry_tmp_2;
   -- create a 2nd temporary patient observation cohort which contains any or all of the selected followed by value sets within the selected time period if applicable
   SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp_2 AS 
   SELECT DISTINCT o2.patient_id 
   FROM ', p_observationcohorttab,' o2 
   WHERE o2.value_set_code_type = ', p_includedAnyAllFollowedBy,' (SELECT DISTINCT c.value_set_code_type FROM ', p_includedFollowedByConcepttab,' c ) 
   AND ', p_timeperioddaterange);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   ALTER TABLE qry_tmp_2 ADD INDEX pat_idx (patient_id);

   SET @sql = CONCAT('DROP TABLE IF EXISTS ', p_filtertab);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   -- filter the 1st cohort to include or exclude patients from the 2nd cohort and put the result into a new table
   SET @sql = CONCAT('CREATE TABLE ', p_filtertab, ' AS SELECT DISTINCT q1.patient_id FROM qry_tmp_1 q1 WHERE ', p_includedAreNot, '(SELECT 1 FROM qry_tmp_2 q2 WHERE q2.patient_id = q1.patient_id)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET p_includeexcludestring = CONCAT(p_includedExclude,' (SELECT 1 FROM ', p_filtertab, ' f WHERE f.patient_id = o.patient_id)');

ELSEIF p_filtertype = 5 THEN

   DROP TEMPORARY TABLE IF EXISTS qry_tmp_1;
   -- create a temporary patient observation cohort which contains any or all of the selected value sets within the selected time period if applicable
   SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp_1 AS 
   SELECT DISTINCT o2.patient_id, o2.value_set_code_type, o2.non_core_concept_id, o2.clinical_effective_date 
   FROM ', p_observationcohorttab,' o2  
   WHERE o2.value_set_code_type = ', p_includedAnyAll,' (SELECT DISTINCT c.value_set_code_type FROM ', p_concepttab,' c) 
   AND ', p_timeperioddaterange);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('DROP TABLE IF EXISTS ', p_filtertab);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   -- filter out patients who have greater or less than the selected number of concept occurrences into a new table
   SET @sql = CONCAT('CREATE TABLE ', p_filtertab,' AS 
   SELECT DISTINCT b.patient_id 
   FROM (SELECT a.patient_id, COUNT(*) cnt FROM qry_tmp_1 a GROUP BY a.patient_id HAVING COUNT(*) ', p_greaterless,' ', p_greaterlessvalue,') b' );
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   
   SET @sql = CONCAT('ALTER TABLE ', p_filtertab,' ADD INDEX pat_idx (patient_id)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET p_includeexcludestring = CONCAT(p_includedExclude,' (SELECT 1 FROM ', p_filtertab, ' f WHERE f.patient_id = o.patient_id)');


END IF;

END//
DELIMITER ;
