USE dashboards;

DROP PROCEDURE IF EXISTS createObservationCohort;

DELIMITER //
CREATE PROCEDURE createObservationCohort(
   p_query_id INT,
   p_observationTab VARCHAR(64), 
   p_cohortTab VARCHAR(64), 
   p_conceptTab VARCHAR(64), 
   p_schema VARCHAR(255)
   )
BEGIN

   DECLARE data_types VARCHAR(255);
   DECLARE front VARCHAR(500) DEFAULT NULL;
   DECLARE frontlen INT DEFAULT NULL;
   DECLARE TempValue VARCHAR(500) DEFAULT NULL;

   DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(p_query_id, 'createObservationCohort', @code, @msg, now());
        RESIGNAL; -- rethrow the error
   END;

   SET data_types = 'Observation, Medication, Encounter, Ethnicity, Referral';

   SET @sql = CONCAT('DROP TABLE IF EXISTS ', p_observationTab);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   
   -- create an empty table
   SET @sql = CONCAT("CREATE TABLE ", p_observationTab, "  
   AS SELECT id, patient_id, person_id, clinical_effective_date, result_value, non_core_concept_id, organization_id
   FROM ", p_schema,".observation LIMIT 0");
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   -- add column
   SET @sql = CONCAT("ALTER TABLE ", p_observationTab, " ADD COLUMN value_set_code_type VARCHAR(255) AFTER organization_id ");
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

      -- add column
   SET @sql = CONCAT("ALTER TABLE ", p_observationTab, " ADD COLUMN cancellation_date DATE AFTER value_set_code_type ");
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

      -- add column
   SET @sql = CONCAT("ALTER TABLE ", p_observationTab, " ADD COLUMN data_type VARCHAR(255) AFTER cancellation_date ");
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   -- create a temporary table to hold the patient details
   DROP TEMPORARY TABLE IF EXISTS qry_tmp;

   SET @sql = CONCAT("
   CREATE TEMPORARY TABLE qry_tmp (
   row_id INT, patient_id BIGINT, person_id BIGINT, organization_id BIGINT, PRIMARY KEY (row_id) ) AS 
   SELECT (@row_no := @row_no + 1) AS row_id, c.patient_id, c.person_id, c.organization_id 
   FROM ", p_cohortTab," c JOIN (SELECT @row_no := 0) t "); 
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   ALTER TABLE qry_tmp ADD INDEX pat_idx (patient_id);

processloop:
LOOP 

      IF LENGTH(TRIM(data_types)) = 0 OR data_types IS NULL THEN
         LEAVE processloop;
      END IF;

      -- retrieve the table name from a comma separated list
      SET front = SUBSTRING_INDEX(data_types, ',', 1);
      SET frontlen = LENGTH(front);
      SET TempValue = TRIM(front);


   SET @row_id = 0;

   WHILE EXISTS (SELECT row_id from qry_tmp WHERE row_id > @row_id AND row_id <= @row_id + 50) DO

      IF TempValue = 'Observation' THEN  

         SET @sql = CONCAT("INSERT INTO  ", p_observationTab, " 
         SELECT o.id, q.patient_id, q.person_id, o.clinical_effective_date, o.result_value, o.non_core_concept_id, q.organization_id, c.value_set_code_type, NULL, c.data_type     
         FROM qry_tmp q JOIN ", p_schema,".observation o FORCE INDEX FOR JOIN (ix_observation_index_2, ix_observation_index_5) ON q.patient_id = o.patient_id AND q.organization_id = o.organization_id 
         JOIN ", p_conceptTab," c ON c.non_core_concept_id = o.non_core_concept_id  
         WHERE c.data_type = 'Observation' 
         AND q.row_id > @row_id AND q.row_id <= @row_id + 50");

      ELSEIF TempValue = 'Medication' THEN  

         SET @sql = CONCAT("INSERT INTO  ", p_observationTab, " 
         SELECT m.id, q.patient_id, q.person_id, m.clinical_effective_date, m.quantity_value, m.non_core_concept_id, q.organization_id, c.value_set_code_type, m.cancellation_date, c.data_type      
         FROM qry_tmp q JOIN ", p_schema,".medication_statement m FORCE INDEX FOR JOIN (ix_medication_statement_index_2, ix_medication_statement_index_4) ON q.patient_id = m.patient_id AND q.organization_id = m.organization_id 
         JOIN ", p_conceptTab," c ON c.non_core_concept_id = m.non_core_concept_id  
         WHERE c.data_type = 'Medication' 
         AND q.row_id > @row_id AND q.row_id <= @row_id + 50");

      ELSEIF TempValue = 'Encounter' THEN

         SET @sql = CONCAT("INSERT INTO  ", p_observationTab, " 
         SELECT en.id, q.patient_id, q.person_id, en.clinical_effective_date, NULL, en.non_core_concept_id, q.organization_id, c.value_set_code_type, NULL, c.data_type     
         FROM qry_tmp q JOIN ", p_schema,".encounter en FORCE INDEX FOR JOIN (ix_encounter_index_2, ix_encounter_index_4) ON q.patient_id = en.patient_id AND q.organization_id = en.organization_id 
         JOIN ", p_conceptTab," c ON c.non_core_concept_id = en.non_core_concept_id  
         WHERE c.data_type = 'Encounter' 
         AND q.row_id > @row_id AND q.row_id <= @row_id + 50");

      ELSEIF TempValue = 'Ethnicity' THEN

         SET @sql = CONCAT("INSERT INTO  ", p_observationTab, " 
         SELECT p.id, q.patient_id, q.person_id, NULL, NULL, p.ethnic_code_concept_id, q.organization_id, c.value_set_code_type, NULL, c.data_type     
         FROM qry_tmp q JOIN ", p_schema,".patient p FORCE INDEX FOR JOIN (patient_id, ethnic_concept) ON q.patient_id = p.id AND q.organization_id = p.organization_id 
         JOIN ", p_conceptTab," c ON c.non_core_concept_id = p.ethnic_code_concept_id  
         WHERE c.data_type = 'Ethnicity' 
         AND q.row_id > @row_id AND q.row_id <= @row_id + 50");
      
      ELSEIF TempValue = 'Referral' THEN

         SET @sql = CONCAT("INSERT INTO  ", p_observationTab, " 
         SELECT ref.id, q.patient_id, q.person_id, ref.clinical_effective_date, NULL, ref.non_core_concept_id, q.organization_id, c.value_set_code_type, NULL, c.data_type     
         FROM qry_tmp q JOIN ", p_schema,".referral_request ref FORCE INDEX FOR JOIN (referral_request_patient_id, referral_request_non_core_concept_id) ON q.patient_id = ref.patient_id AND q.organization_id = ref.organization_id 
         JOIN ", p_conceptTab," c ON c.non_core_concept_id = ref.non_core_concept_id  
         WHERE c.data_type = 'Referral' 
         AND q.row_id > @row_id AND q.row_id <= @row_id + 50");

      END IF;

      PREPARE stmt FROM @sql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
   
      SET @row_id = @row_id + 50; 

   END WHILE; 

      -- fetch the next data type
      SET data_types = INSERT(data_types, 1, frontlen + 1, '');

END LOOP;

   DROP TEMPORARY TABLE IF EXISTS qry_tmp;

   SET @sql = CONCAT('ALTER TABLE ', p_observationTab, ' ADD INDEX pat_idx (patient_id)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('ALTER TABLE ', p_observationTab, ' ADD INDEX org_idx (organization_id)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;  

   SET @sql = CONCAT('ALTER TABLE ', p_observationTab, ' ADD INDEX valset_idx (value_set_code_type)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;  

END//
DELIMITER ;
