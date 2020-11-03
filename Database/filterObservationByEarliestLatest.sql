USE dashboards;

DROP PROCEDURE IF EXISTS filterObservationByEarliestLatest;

DELIMITER //
CREATE PROCEDURE filterObservationByEarliestLatest(
  p_concepttab VARCHAR(64),
  p_observationcohorttab VARCHAR(64),
  p_earliestlatestobservationtab VARCHAR(64),
  p_includedEarliestLatest VARCHAR(20),
  p_includedOperator VARCHAR(50),
  p_includedEntryValue VARCHAR(20),
  p_timeperioddaterange VARCHAR(255)
)

BEGIN

   DECLARE resultvaluestring VARCHAR(300) DEFAULT NULL;

   SET p_includedOperator = IF(p_includedOperator = 'Greater than','>','<');

   IF p_includedOperator IS NOT NULL AND p_includedEntryValue IS NOT NULL THEN
      SET resultvaluestring = CONCAT('o2.result_value IS NOT NULL AND o2.result_value ',p_includedOperator,' ',p_includedEntryValue);
   ELSE
      SET resultvaluestring = '1';
   END IF;

   SET p_timeperioddaterange = IF(p_timeperioddaterange IS NULL,'1',p_timeperioddaterange);

   SET @sql = CONCAT('DROP TABLE IF EXISTS ', p_earliestlatestobservationtab);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

  IF p_includedEarliestLatest = 'Latest' THEN

     DROP TEMPORARY TABLE IF EXISTS qry_tmp;
     SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp AS 
     SELECT o2.id, o2.patient_id, o2.clinical_effective_date, o2.result_value, o2.non_core_concept_id, c.value_set_code_type 
     FROM ', p_observationcohorttab,' o2 JOIN ', p_concepttab,' c ON o2.non_core_concept_id = c.non_core_concept_id 
     WHERE ', resultvaluestring,' AND ', p_timeperioddaterange);
     PREPARE stmt FROM @sql;
     EXECUTE stmt;
     DEALLOCATE PREPARE stmt;

     SET @sql = CONCAT('CREATE TABLE ', p_earliestlatestobservationtab,' AS 
     SELECT 
          ob.id,
          ob.patient_id,
          ob.clinical_effective_date,
          ob.result_value,
          ob.non_core_concept_id,
          ob.value_set_code_type,
          ob.rnk 
     FROM ( 
      SELECT 
          o2.id,
          o2.patient_id,
          o2.clinical_effective_date,
          o2.result_value,
          o2.non_core_concept_id,
          o2.value_set_code_type,
          @currank := IF(@curpatient = BINARY o2.patient_id, @currank + 1, 1) AS rnk,
          @curpatient := o2.patient_id AS cur_patient
          FROM qry_tmp o2 JOIN (SELECT @currank := 0, @curpatient := 0) r 
          ORDER BY o2.patient_id, o2.clinical_effective_date DESC, o2.id DESC 
          ) ob 
     WHERE ob.rnk = 1');
     PREPARE stmt FROM @sql;
     EXECUTE stmt;
     DEALLOCATE PREPARE stmt;
  
  ELSEIF p_includedEarliestLatest = 'Earliest' THEN

     DROP TEMPORARY TABLE IF EXISTS qry_tmp;
     SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp AS 
     SELECT o2.id, o2.patient_id, o2.clinical_effective_date, o2.result_value, o2.non_core_concept_id, c.value_set_code_type 
     FROM ', p_observationcohorttab,' o2 JOIN ', p_concepttab,' c ON o2.non_core_concept_id = c.non_core_concept_id 
     WHERE ', resultvaluestring,' AND ', p_timeperioddaterange);
     PREPARE stmt FROM @sql;
     EXECUTE stmt;
     DEALLOCATE PREPARE stmt;

     SET @sql = CONCAT('CREATE TABLE ', p_earliestlatestobservationtab,' AS 
     SELECT 
          ob.id,
          ob.patient_id,
          ob.clinical_effective_date,
          ob.result_value,
          ob.non_core_concept_id,
          ob.value_set_code_type,
          ob.rnk  
     FROM (
      SELECT 
          o2.id,
          o2.patient_id,
          o2.clinical_effective_date,
          o2.result_value,
          o2.non_core_concept_id,
          o2.value_set_code_type,
          @currank := IF(@curpatient = BINARY o2.patient_id, @currank + 1, 1) AS rnk,
          @curpatient := o2.patient_id AS cur_patient
          FROM qry_tmp o2 JOIN (SELECT @currank := 0, @curpatient := 0) r 
          ORDER BY o2.patient_id, o2.clinical_effective_date ASC, o2.id ASC 
          ) ob 
     WHERE ob.rnk = 1');
     PREPARE stmt FROM @sql;
     EXECUTE stmt;
     DEALLOCATE PREPARE stmt;

  END IF;

     SET @sql = CONCAT('ALTER TABLE ', p_earliestlatestobservationtab,' ADD INDEX pat_idx(patient_id)');
     PREPARE stmt FROM @sql;
     EXECUTE stmt;
     DEALLOCATE PREPARE stmt;


END//
DELIMITER ;