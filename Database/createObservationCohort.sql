USE dashboards;

DROP PROCEDURE IF EXISTS createObservationCohort;

DELIMITER //
CREATE PROCEDURE createObservationCohort(
   p_observationtab VARCHAR(64), 
   p_cohorttab VARCHAR(64), 
   p_allconcepttab VARCHAR(64), 
   p_schema VARCHAR(255)
   )
BEGIN

   DECLARE data_types VARCHAR(255);
   DECLARE front VARCHAR(500) DEFAULT NULL;
   DECLARE frontlen INT DEFAULT NULL;
   DECLARE TempValue VARCHAR(500) DEFAULT NULL;

   SET data_types = 'Observation, Medication, Encounter, Ethnicity';

   SET @sql = CONCAT('DROP TABLE IF EXISTS ', p_observationtab);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   
   -- create an empty table
   SET @sql = CONCAT("CREATE TABLE ", p_observationtab, "  
   AS SELECT id, patient_id, person_id, clinical_effective_date, result_value, non_core_concept_id, organization_id
   FROM ", p_schema,".observation LIMIT 0");
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   -- add column
   SET @sql = CONCAT("ALTER TABLE ", p_observationtab, " ADD COLUMN value_set_code_type VARCHAR(255) AFTER organization_id ");
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

 processloop:
 LOOP 

      IF LENGTH(TRIM(data_types)) = 0 OR data_types IS NULL THEN
         LEAVE processloop;
      END IF;

      -- retrieve the table name from a comma separated list
      SET front = SUBSTRING_INDEX(data_types, ',', 1);
      SET frontlen = LENGTH(front);
      SET TempValue = TRIM(front);

   -- create a temporary table to hold the patient details
   DROP TEMPORARY TABLE IF EXISTS qry_tmp;

   SET @sql = CONCAT("
   CREATE TEMPORARY TABLE qry_tmp (
   row_id INT, id BIGINT, patient_id BIGINT, person_id BIGINT, organization_id BIGINT, PRIMARY KEY (row_id) ) AS 
   SELECT (@row_no := @row_no + 1) AS row_id, c.patient_id, c.person_id, c.organization_id 
   FROM ", p_cohorttab," c JOIN (SELECT @row_no := 0) t "); 
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   ALTER TABLE qry_tmp ADD INDEX pat_per_org_idx (patient_id, person_id, organization_id);

   SET @row_id = 0;

   WHILE EXISTS (SELECT row_id from qry_tmp WHERE row_id > @row_id AND row_id <= @row_id + 1000) DO

 IF TempValue = 'Observation' THEN  

         SET @sql = CONCAT("INSERT INTO  ", p_observationtab, " 
         SELECT o.id, q.patient_id, q.person_id, o.clinical_effective_date, o.result_value, o.non_core_concept_id, q.organization_id, c.value_set_code_type   
         FROM qry_tmp q JOIN ", p_schema,".observation o ON q.patient_id = o.patient_id AND q.person_id = o.person_id AND q.organization_id = o.organization_id 
         JOIN ", p_allconcepttab," c ON c.non_core_concept_id = o.non_core_concept_id  
         WHERE c.data_type = 'Observation' 
         AND q.row_id > @row_id AND q.row_id <= @row_id + 1000");

      ELSEIF TempValue = 'Medication' THEN  

         SET @sql = CONCAT("INSERT INTO  ", p_observationtab, " 
         SELECT m.id, q.patient_id, q.person_id, m.clinical_effective_date, m.quantity_value, m.non_core_concept_id, q.organization_id, c.value_set_code_type   
         FROM qry_tmp q JOIN ", p_schema,".medication_statement m ON q.patient_id = m.patient_id AND q.person_id = m.person_id AND q.organization_id = m.organization_id 
         JOIN ", p_allconcepttab," c ON c.non_core_concept_id = m.non_core_concept_id  
         WHERE c.data_type = 'Medication' 
         AND q.row_id > @row_id AND q.row_id <= @row_id + 1000");

      ELSEIF TempValue = 'Encounter' THEN

         SET @sql = CONCAT("INSERT INTO  ", p_observationtab, " 
         SELECT en.id, q.patient_id, q.person_id, en.clinical_effective_date, NULL, en.non_core_concept_id, q.organization_id, c.value_set_code_type   
         FROM qry_tmp q JOIN ", p_schema,".encounter en ON q.patient_id = en.patient_id AND q.person_id = en.person_id AND q.organization_id = en.organization_id 
         JOIN ", p_allconcepttab," c ON c.non_core_concept_id = en.non_core_concept_id  
         WHERE c.data_type = 'Encounter' 
         AND q.row_id > @row_id AND q.row_id <= @row_id + 1000");

      ELSEIF TempValue = 'Ethnicity' THEN

         SET @sql = CONCAT("INSERT INTO  ", p_observationtab, " 
         SELECT p.id, q.patient_id, q.person_id, NULL, NULL, p.ethnic_code_concept_id, q.organization_id, c.value_set_code_type   
         FROM qry_tmp q JOIN ", p_schema,".patient p ON q.patient_id = p.id AND q.person_id = p.person_id AND q.organization_id = p.organization_id 
         JOIN ", p_allconcepttab," c ON c.non_core_concept_id = p.ethnic_code_concept_id  
         WHERE c.data_type = 'Ethnicity' 
         AND q.row_id > @row_id AND q.row_id <= @row_id + 1000");

      END IF;

      PREPARE stmt FROM @sql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
   
      SET @row_id = @row_id + 1000; 

   END WHILE; 

      -- fetch the next data type
      SET data_types = INSERT(data_types, 1, frontlen + 1, '');

 END LOOP;

   DROP TEMPORARY TABLE IF EXISTS qry_tmp;

   SET @sql = CONCAT('ALTER TABLE ', p_observationtab, ' ADD INDEX value_set_code_type_idx(value_set_code_type)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('ALTER TABLE ', p_observationtab, ' ADD INDEX clinical_effective_date_idx(clinical_effective_date)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

END//
DELIMITER ;
