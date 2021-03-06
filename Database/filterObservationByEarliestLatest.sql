USE dashboards;

DROP PROCEDURE IF EXISTS filterObservationByEarliestLatest;

DELIMITER //
CREATE PROCEDURE filterObservationByEarliestLatest(
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
      SET resultvaluestring = CONCAT('ob.result_value IS NOT NULL AND ob.result_value ',p_includedOperator,' ',p_includedEntryValue);
   ELSE
      SET resultvaluestring = '1';
   END IF;

   SET p_timeperioddaterange = IF(p_timeperioddaterange IS NULL,'1',p_timeperioddaterange);

   SET @sql = CONCAT('DROP TEMPORARY TABLE IF EXISTS ', p_earliestlatestobservationtab);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

  IF p_includedEarliestLatest = 'Latest' THEN

     DROP TEMPORARY TABLE IF EXISTS qry_tmp_filter;

     SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp_filter AS 
     SELECT 
          ob.id,
          ob.patient_id,
          ob.clinical_effective_date,
          ob.result_value,
          ob.non_core_concept_id,
          ob.organization_id,
          ob.value_set_code_type,
          ob.cancellation_date, 
          ob.rnk 
     FROM ( 
      SELECT 
          o2.id,
          o2.patient_id,
          o2.clinical_effective_date,
          o2.result_value,
          o2.non_core_concept_id,
          o2.organization_id,
          o2.value_set_code_type,
          o2.cancellation_date, 
          @currank := IF(@curpatient = BINARY o2.patient_id, @currank + 1, 1) AS rnk,
          @curpatient := o2.patient_id AS cur_patient
          FROM ', p_observationcohorttab,' o2 JOIN (SELECT @currank := 0, @curpatient := 0) r 
          WHERE o2.clinical_effective_date IS NOT NULL 
          ORDER BY o2.patient_id, o2.clinical_effective_date DESC, o2.id DESC 
          ) ob 
     WHERE ob.rnk = 1 
     AND ', resultvaluestring);
     PREPARE stmt FROM @sql;
     EXECUTE stmt;
     DEALLOCATE PREPARE stmt;

     SET @sql = CONCAT('CREATE TEMPORARY TABLE ', p_earliestlatestobservationtab,' AS 
     SELECT o2.id, o2.patient_id, o2.clinical_effective_date, o2.result_value, o2.non_core_concept_id, o2.organization_id, o2.value_set_code_type, o2.cancellation_date 
     FROM qry_tmp_filter o2 
     WHERE ', p_timeperioddaterange);
     PREPARE stmt FROM @sql;
     EXECUTE stmt;
     DEALLOCATE PREPARE stmt;

  ELSEIF p_includedEarliestLatest = 'Earliest' THEN

     DROP TEMPORARY TABLE IF EXISTS qry_tmp_filter;

     SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp_filter AS 
     SELECT 
          ob.id,
          ob.patient_id,
          ob.clinical_effective_date,
          ob.result_value,
          ob.non_core_concept_id,
          ob.organization_id,
          ob.value_set_code_type,
          ob.cancellation_date, 
          ob.rnk  
     FROM (
      SELECT 
          o2.id,
          o2.patient_id,
          o2.clinical_effective_date,
          o2.result_value,
          o2.non_core_concept_id,
          o2.organization_id,
          o2.value_set_code_type,
          o2.cancellation_date, 
          @currank := IF(@curpatient = BINARY o2.patient_id, @currank + 1, 1) AS rnk,
          @curpatient := o2.patient_id AS cur_patient
          FROM ', p_observationcohorttab,' o2 JOIN (SELECT @currank := 0, @curpatient := 0) r 
          WHERE o2.clinical_effective_date IS NOT NULL 
          ORDER BY o2.patient_id, o2.clinical_effective_date ASC, o2.id ASC 
          ) ob 
     WHERE ob.rnk = 1 
     AND ', resultvaluestring);
     PREPARE stmt FROM @sql;
     EXECUTE stmt;
     DEALLOCATE PREPARE stmt;

     SET @sql = CONCAT('CREATE TEMPORARY TABLE ', p_earliestlatestobservationtab,' AS 
     SELECT o2.id, o2.patient_id, o2.clinical_effective_date, o2.result_value, o2.non_core_concept_id, o2.organization_id, o2.value_set_code_type, o2.cancellation_date  
     FROM qry_tmp_filter o2 
     WHERE ', p_timeperioddaterange);
     PREPARE stmt FROM @sql;
     EXECUTE stmt;
     DEALLOCATE PREPARE stmt;

  END IF;

     SET @sql = CONCAT('ALTER TABLE ', p_earliestlatestobservationtab,' ADD INDEX pat_idx (patient_id)');
     PREPARE stmt FROM @sql;
     EXECUTE stmt;
     DEALLOCATE PREPARE stmt;

     SET @sql = CONCAT('ALTER TABLE ', p_earliestlatestobservationtab,' ADD INDEX org_idx (organization_id)');
     PREPARE stmt FROM @sql;
     EXECUTE stmt;
     DEALLOCATE PREPARE stmt;


END//
DELIMITER ;