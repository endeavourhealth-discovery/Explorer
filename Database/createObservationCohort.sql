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

   -- create a temporary table to hold the table ids
   DROP TEMPORARY TABLE IF EXISTS qry_tmp;

   IF TempValue = 'Observation' THEN  

     SET @sql = CONCAT('
     CREATE TEMPORARY TABLE qry_tmp (
        row_id INT, id BIGINT, 
        patient_id BIGINT, person_id BIGINT, 
        clinical_effective_date DATE, result_value DOUBLE, 
        non_core_concept_id INT, organization_id BIGINT,
        value_set_code_type VARCHAR(255), 
        PRIMARY KEY (row_id) ) AS 
     SELECT (@row_no := @row_no + 1) AS row_id, 
          o.id AS id, o.patient_id, o.person_id, o.clinical_effective_date, 
          o.result_value, o.non_core_concept_id, o.organization_id, 
          cpt.value_set_code_type AS value_set_code_type 
     FROM ', p_cohorttab,' c JOIN ', p_schema,'.observation o ON c.patient_id = o.patient_id AND c.person_id = o.person_id AND c.organization_id = o.organization_id 
     JOIN ', p_allconcepttab,' cpt ON cpt.non_core_concept_id = o.non_core_concept_id 
     JOIN (SELECT @row_no := 0) t 
     WHERE cpt.data_type = ', QUOTE(TempValue));

   ELSEIF TempValue = 'Medication' THEN

     SET @sql = CONCAT('
     CREATE TEMPORARY TABLE qry_tmp (
        row_id INT, id BIGINT, 
        patient_id BIGINT, person_id BIGINT, 
        clinical_effective_date DATE, result_value DOUBLE, 
        non_core_concept_id INT, organization_id BIGINT,
        value_set_code_type VARCHAR(255), 
        PRIMARY KEY (row_id) ) AS 
     SELECT (@row_no := @row_no + 1) AS row_id, 
          o.id AS id, o.patient_id, o.person_id, o.clinical_effective_date, 
          o.quantity_value AS result_value, o.non_core_concept_id, o.organization_id, 
          cpt.value_set_code_type AS value_set_code_type 
     FROM ', p_cohorttab,' c JOIN ', p_schema,'.medication_statement o ON c.patient_id = o.patient_id AND c.person_id = o.person_id AND c.organization_id = o.organization_id 
     JOIN ', p_allconcepttab,' cpt ON cpt.non_core_concept_id = o.non_core_concept_id 
     JOIN (SELECT @row_no := 0) t 
     WHERE cpt.data_type = ', QUOTE(TempValue));

   ELSEIF TempValue = 'Encounter' THEN

     SET @sql = CONCAT('
     CREATE TEMPORARY TABLE qry_tmp (
        row_id INT, id BIGINT, 
        patient_id BIGINT, person_id BIGINT, 
        clinical_effective_date DATE, 
        non_core_concept_id INT, organization_id BIGINT,
        value_set_code_type VARCHAR(255), 
        PRIMARY KEY (row_id) ) AS 
     SELECT (@row_no := @row_no + 1) AS row_id, 
          o.id AS id, o.patient_id, o.person_id, o.clinical_effective_date, 
          o.non_core_concept_id, o.organization_id, 
          cpt.value_set_code_type AS value_set_code_type 
     FROM ', p_cohorttab,' c JOIN ', p_schema,'.encounter o ON c.patient_id = o.patient_id AND c.person_id = o.person_id AND c.organization_id = o.organization_id 
     JOIN ', p_allconcepttab,' cpt ON cpt.non_core_concept_id = o.non_core_concept_id 
     JOIN (SELECT @row_no := 0) t 
     WHERE cpt.data_type = ', QUOTE(TempValue));

   ELSEIF TempValue = 'Ethnicity' THEN

     SET @sql = CONCAT('
     CREATE TEMPORARY TABLE qry_tmp (
        row_id INT, id BIGINT, 
        patient_id BIGINT, person_id BIGINT, 
        non_core_concept_id INT, organization_id BIGINT,
        value_set_code_type VARCHAR(255), 
        PRIMARY KEY (row_id) ) AS 
     SELECT (@row_no := @row_no + 1) AS row_id, 
          o.id AS id, o.id AS patient_id, o.person_id,
          o.ethnic_code_concept_id AS non_core_concept_id, o.organization_id, 
          cpt.value_set_code_type AS value_set_code_type 
     FROM ', p_cohorttab,' c JOIN ', p_schema,'.patient o ON c.patient_id = o.id AND c.person_id = o.person_id AND c.organization_id = o.organization_id 
     JOIN ', p_allconcepttab,' cpt ON cpt.non_core_concept_id = o.ethnic_code_concept_id
     JOIN (SELECT @row_no := 0) t 
     WHERE cpt.data_type = ', QUOTE(TempValue));

   END IF;

   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @row_id = 0;

   
   WHILE EXISTS (SELECT row_id from qry_tmp WHERE row_id > @row_id AND row_id <= @row_id + 1000) DO

      IF TempValue IN ('Observation','Medication') THEN  

         SET @sql = CONCAT("INSERT INTO  ", p_observationtab, " 
         SELECT q.id, q.patient_id, q.person_id, q.clinical_effective_date, q.result_value, q.non_core_concept_id, 
         q.organization_id, q.value_set_code_type FROM qry_tmp q 
         WHERE q.row_id > @row_id AND q.row_id <= @row_id + 1000");

      ELSEIF TempValue = 'Encounter' THEN

         SET @sql = CONCAT("INSERT INTO  ", p_observationtab, " 
         SELECT q.id, q.patient_id, q.person_id, q.clinical_effective_date, NULL, q.non_core_concept_id, q.organization_id, q.value_set_code_type 
         FROM qry_tmp q WHERE q.row_id > @row_id AND q.row_id <= @row_id + 1000");

      ELSEIF TempValue = 'Encounter' THEN

         SET @sql = CONCAT("INSERT INTO  ", p_observationtab, " 
         SELECT q.id, q.patient_id, q.person_id, q.clinical_effective_date, NULL, q.non_core_concept_id, q.organization_id, q.value_set_code_type 
         FROM qry_tmp q WHERE q.row_id > @row_id AND q.row_id <= @row_id + 1000");

      ELSEIF TempValue = 'Ethnicity' THEN

         SET @sql = CONCAT("INSERT INTO  ", p_observationtab, " 
         SELECT q.id, q.patient_id, q.person_id, NULL, NULL, q.non_core_concept_id, q.organization_id, q.value_set_code_type 
         FROM qry_tmp q WHERE q.row_id > @row_id AND q.row_id <= @row_id + 1000");

      END IF;

      PREPARE stmt FROM @sql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
   
      SET @row_id = @row_id + 1000; 

   END WHILE; 

   

      -- fetch next table
      SET data_types = INSERT(data_types, 1, frontlen + 1, '');

 END LOOP;

  -- add index
   SET @sql = CONCAT('ALTER TABLE ', p_observationtab, ' ADD INDEX patient_idx(patient_id)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('ALTER TABLE ', p_observationtab, ' ADD INDEX org_idx(organization_id)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('ALTER TABLE ', p_observationtab, ' ADD INDEX non_core_concept_idx(non_core_concept_id)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

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