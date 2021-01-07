USE dashboards;

DROP PROCEDURE IF EXISTS runBuildQuery;

DELIMITER //
CREATE PROCEDURE runBuildQuery(
  IN p_query_id INT,
  IN p_withWithout VARCHAR(10), 
  IN p_includedAnyAll VARCHAR(10), 
  IN p_timeperioddaterange VARCHAR(255),
  IN p_concepttab VARCHAR(64),
  IN p_observationCohortTab VARCHAR(64),
  IN p_observation_tmp VARCHAR(64),
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
  IN p_regPeriodRange VARCHAR(500), 
  IN p_regIncludeExclude VARCHAR(10),
  IN p_queryType INT,
  IN p_cohort VARCHAR(64),
  IN p_queryNumber VARCHAR(20)
)

BEGIN

DECLARE p_whereString VARCHAR(255) DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(p_query_id, 'runBuildQuery', @code, @msg, now());
        RESIGNAL; -- rethrow the error
    END;

SET p_withWithout = UPPER(p_withWithout);
SET p_withWithout = IF(p_withWithout = 'WITHOUT','NOT EXISTS',IF(p_withWithout = 'WITH','EXISTS',''));
SET p_includedAnyAll = UPPER(p_includedAnyAll);

SET p_includedAnyAllTested = UPPER(p_includedAnyAllTested);
SET p_includedAnyAllFollowedBy = UPPER(p_includedAnyAllFollowedBy); 

SET p_includedAreNot = UPPER(p_includedAreNot);
SET p_includedAreNot = IF(p_includedAreNot = 'ARE','EXISTS ',IF(p_includedAreNot = 'ARE NOT','NOT EXISTS',''));

SET p_greaterless = IF(p_greaterless = 'Greater than',' > ',' < '); 

IF p_queryType = 1 THEN 

   DROP TEMPORARY TABLE IF EXISTS qry_tmp;
   -- create an obervation cohort for any or all the selected valuesets in the selected time period if applicable
   SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp AS 
   SELECT DISTINCT o2.patient_id, o2.organization_id 
   FROM ', p_observationCohortTab,' o2 JOIN ', p_cohort,' p ON p.patient_id = o2.patient_id AND p.organization_id = o2.organization_id 
   WHERE o2.value_set_code_type = ', p_includedAnyAll,' (SELECT DISTINCT c.value_set_code_type FROM ', p_concepttab,' c ) 
   AND ', p_timeperioddaterange);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   ALTER TABLE qry_tmp ADD INDEX pat_idx (patient_id);

   SET p_whereString = CONCAT(p_withWithout,' (SELECT 1 FROM qry_tmp q WHERE q.patient_id = o.patient_id AND q.organization_id = o.organization_id)');

   SET @sql = CONCAT('DROP TABLE IF EXISTS Q', p_queryNumber,'_',p_query_id);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('CREATE TABLE Q', p_queryNumber, '_', p_query_id,' AS 
   SELECT DISTINCT o.patient_id, o.person_id, o.organization_id
   FROM ', p_cohort,' o 
   WHERE ', p_whereString);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('ALTER TABLE Q', p_queryNumber,'_',p_query_id,' ADD INDEX pat_idx(patient_id)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

ELSEIF p_queryType = 2 THEN  

   DROP TEMPORARY TABLE IF EXISTS qry_tmp_1;
   -- create an observation cohort containing any or all of the selected valuesets
   SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp_1 AS 
   SELECT o1.id, 
          o1.patient_id, 
          o1.clinical_effective_date, 
          o1.result_value, 
          o1.non_core_concept_id, 
          o1.organization_id,
          o1.value_set_code_type 
   FROM ', p_observationCohortTab,' o1 JOIN ', p_cohort,' p ON p.patient_id = o1.patient_id AND p.organization_id = o1.organization_id 
   WHERE o1.value_set_code_type = ', p_includedAnyAll,' (SELECT DISTINCT c.value_set_code_type FROM ', p_concepttab,' c )');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   ALTER TABLE qry_tmp_1 ADD INDEX pat_idx (patient_id);
   ALTER TABLE qry_tmp_1 ADD INDEX non_core_concept_idx (non_core_concept_id);

   -- from the patient observation cohort:
   -- 1 filter out the patient observations with result values greater or less than the included value and within the selected time period if applicable
   -- 2 filter out the latest or earliest of these into a new table
   CALL filterObservationByEarliestLatest(p_concepttab, 'qry_tmp_1', p_observation_tmp, p_includedEarliestLatest, p_includedOperator, p_includedEntryValue, p_timeperioddaterange);

   SET p_whereString = CONCAT(p_withWithout,' (SELECT 1 FROM ', p_observation_tmp,' o1 WHERE o.patient_id = o1.patient_id AND o.organization_id = o1.organization_id)');

   SET @sql = CONCAT('DROP TABLE IF EXISTS Q', p_queryNumber,'_',p_query_id);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('CREATE TABLE Q', p_queryNumber, '_', p_query_id,' AS 
   SELECT DISTINCT o.patient_id, o.person_id, o.organization_id
   FROM ', p_cohort,' o 
   WHERE ', p_whereString);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('ALTER TABLE Q', p_queryNumber,'_',p_query_id,' ADD INDEX pat_idx(patient_id)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

ELSEIF p_queryType = 3 THEN  

   DROP TEMPORARY TABLE IF EXISTS qry_tmp_1;
   -- create a temporary patient observation cohort containing any or all of the selected value sets
   SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp_1 AS 
   SELECT o1.id, 
          o1.patient_id, 
          o1.clinical_effective_date, 
          o1.result_value, 
          o1.non_core_concept_id, 
          o1.organization_id,
          o1.value_set_code_type 
   FROM ', p_observationCohortTab,' o1 JOIN ', p_cohort,' p ON p.patient_id = o1.patient_id AND p.organization_id = o1.organization_id 
   WHERE o1.value_set_code_type = ', p_includedAnyAll,' (SELECT DISTINCT c.value_set_code_type FROM ', p_concepttab,' c)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   ALTER TABLE qry_tmp_1 ADD INDEX pat_idx (patient_id);
   ALTER TABLE qry_tmp_1 ADD INDEX non_core_concept_idx (non_core_concept_id);

   -- from the patient observation cohort:
   -- 1 filter out the latest or earliest of these observation concepts within the selected time period if applicable
   CALL filterObservationByEarliestLatest(p_concepttab, 'qry_tmp_1', p_observation_tmp, p_includedEarliestLatest, NULL, NULL, p_timeperioddaterange);

   -- filter out the patients containing any or all of the selected tested valuesets which are then to be included or excluded
   SET p_whereString = CONCAT(p_withWithout,' (SELECT 1 FROM ', p_observation_tmp, ' o1 WHERE o1.value_set_code_type = ', 
   p_includedAnyAllTested,' (SELECT DISTINCT c.value_set_code_type FROM ', p_includedAnyAllTestedConcepttab,' c ) AND o.patient_id = o1.patient_id AND o.organization_id = o1.organization_id)'); 

   SET @sql = CONCAT('DROP TABLE IF EXISTS Q', p_queryNumber,'_',p_query_id);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('CREATE TABLE Q', p_queryNumber, '_', p_query_id,' AS 
   SELECT DISTINCT o.patient_id, o.person_id, o.organization_id
   FROM ', p_cohort,' o 
   WHERE ', p_whereString);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('ALTER TABLE Q', p_queryNumber,'_',p_query_id,' ADD INDEX pat_idx(patient_id)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

ELSEIF p_queryType = 4 THEN 

   DROP TEMPORARY TABLE IF EXISTS qry_tmp_1;
   -- create a temporary patient observation cohort containing any or all of the selected value sets
   SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp_1 AS 
   SELECT o1.id, 
          o1.patient_id, 
          o1.clinical_effective_date, 
          o1.result_value, 
          o1.non_core_concept_id, 
          o1.organization_id,
          o1.value_set_code_type 
   FROM ', p_observationCohortTab,' o1 JOIN ', p_cohort,' p ON p.patient_id = o1.patient_id AND p.organization_id = o1.organization_id  
   WHERE o1.value_set_code_type = ', p_includedAnyAll,' (SELECT DISTINCT c.value_set_code_type FROM ', p_concepttab,' c )');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   ALTER TABLE qry_tmp_1 ADD INDEX pat_idx (patient_id);
   ALTER TABLE qry_tmp_1 ADD INDEX non_core_concept_idx (non_core_concept_id);

   -- filter out the latest of these observational concepts 
   CALL filterObservationByEarliestLatest(p_concepttab, 'qry_tmp_1', p_observation_tmp, 'Latest', NULL, NULL, '1');

   DROP TEMPORARY TABLE IF EXISTS qry_tmp_2;
   -- create a temporary patient observation cohort containing any or all of the followed by value sets
   SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp_2 AS 
   SELECT 
          o2.patient_id, 
          o2.clinical_effective_date, 
          o2.organization_id
   FROM ', p_observationCohortTab,' o2 JOIN ', p_cohort,' p ON p.patient_id = o2.patient_id AND p.organization_id = o2.organization_id  
   WHERE o2.value_set_code_type = ', p_includedAnyAllFollowedBy,' (SELECT DISTINCT c.value_set_code_type FROM ', p_includedFollowedByConcepttab,' c ) ');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt; 

   ALTER TABLE qry_tmp_2 ADD INDEX pat_idx (patient_id);

   DROP TEMPORARY TABLE IF EXISTS qry_tmp_3;

   -- create a temporary patient cohort where one value set is compared to another over a time period
   SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp_3 AS 
   SELECT DISTINCT o.patient_id, o.organization_id 
   FROM ', p_observation_tmp,' o WHERE ', p_includedAreNot, '(SELECT 1 FROM qry_tmp_2 o2 WHERE o2.patient_id = o.patient_id AND o2.organization_id = o.organization_id AND ', p_timeperioddaterange,')');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET p_whereString = CONCAT(p_withWithout,' (SELECT 1 FROM qry_tmp_3 q WHERE q.patient_id = o.patient_id AND q.organization_id = o.organization_id)');

   SET @sql = CONCAT('DROP TABLE IF EXISTS Q', p_queryNumber,'_',p_query_id);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   
   -- include or exclude patients from the cohort
   SET @sql = CONCAT('CREATE TABLE Q', p_queryNumber, '_', p_query_id,' AS 
   SELECT DISTINCT o.patient_id, o.person_id, o.organization_id
   FROM ', p_cohort,' o 
   WHERE ', p_whereString);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('ALTER TABLE Q', p_queryNumber,'_',p_query_id,' ADD INDEX pat_idx(patient_id)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

ELSEIF p_queryType = 5 THEN

   DROP TEMPORARY TABLE IF EXISTS qry_tmp;
   -- create a temporary patient observation cohort containing any or all of the selected value sets within the selected time period if applicable
   SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp AS 
   SELECT DISTINCT o2.patient_id, o2.value_set_code_type, o2.non_core_concept_id, o2.clinical_effective_date, o2.organization_id  
   FROM ', p_observationCohortTab,' o2 JOIN ', p_cohort,' p ON p.patient_id = o2.patient_id AND p.organization_id = o2.organization_id    
   WHERE o2.value_set_code_type = ', p_includedAnyAll,' (SELECT DISTINCT c.value_set_code_type FROM ', p_concepttab,' c) 
   AND ', p_timeperioddaterange);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('DROP TABLE IF EXISTS ', p_observation_tmp);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   -- filter out patients who have greater or less than the selected number of concept occurrences into a new table
   SET @sql = CONCAT('CREATE TABLE ', p_observation_tmp,' AS 
   SELECT DISTINCT b.patient_id, b.organization_id 
   FROM (SELECT a.patient_id, a.organization_id, COUNT(*) cnt FROM qry_tmp a GROUP BY a.patient_id, a.organization_id HAVING COUNT(*) ', p_greaterless,' ', p_greaterlessvalue,') b' );
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   
   SET @sql = CONCAT('ALTER TABLE ', p_observation_tmp,' ADD INDEX pat_idx (patient_id)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET p_whereString = CONCAT(p_withWithout,' (SELECT 1 FROM ', p_observation_tmp, ' f WHERE f.patient_id = o.patient_id AND f.organization_id = o.organization_id)');

   SET @sql = CONCAT('DROP TABLE IF EXISTS Q', p_queryNumber,'_',p_query_id);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('CREATE TABLE Q', p_queryNumber, '_', p_query_id,' AS 
   SELECT DISTINCT o.patient_id, o.person_id, o.organization_id
   FROM ', p_cohort,' o 
   WHERE ', p_whereString);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('ALTER TABLE Q', p_queryNumber,'_',p_query_id,' ADD INDEX pat_idx(patient_id)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

ELSEIF p_queryType = 0 THEN

   IF p_regPeriodRange <> '1' THEN 

        DROP TEMPORARY TABLE IF EXISTS qry_tmp;
        -- filter patients by registration date range
        SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp AS 
        SELECT DISTINCT c.person_id, c.patient_id, c.organization_id 
        FROM ', p_cohort,' c WHERE ', p_regPeriodRange);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        -- set where clause
        SET p_whereString = CONCAT(p_regIncludeExclude,' (SELECT 1 FROM qry_tmp c2 WHERE c2.patient_id = c.patient_id AND c2.organization_id = c.organization_id) ');
   ELSE
        SET p_whereString = '1';
   END IF;

   SET @sql = CONCAT('DROP TABLE IF EXISTS Q', p_queryNumber,'_',p_query_id);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('CREATE TABLE Q', p_queryNumber, '_', p_query_id,' AS 
   SELECT DISTINCT c.patient_id, c.person_id, c.organization_id
   FROM ', p_cohort,' c 
   WHERE ', p_whereString);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('ALTER TABLE Q', p_queryNumber,'_',p_query_id,' ADD INDEX pat_idx(patient_id)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   

END IF;

END//
DELIMITER ;
