USE dashboards;

DROP PROCEDURE IF EXISTS createObservationCohort;

DELIMITER //
CREATE PROCEDURE createObservationCohort(
   p_daterange VARCHAR(255), 
   p_observationtab VARCHAR(64), 
   p_cohorttab VARCHAR(64), 
   p_concepttab VARCHAR(64),
   p_schema VARCHAR(255)
   )
BEGIN

   SET @sql = CONCAT('DROP TABLE IF EXISTS ', p_observationtab);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('CREATE TABLE ', p_observationtab, ' AS 
      SELECT DISTINCT
          o.id,
          c.patient_id,
          c.person_id,
          c.nhs_number,
          c.date_of_birth,
          c.date_of_death,
          c.age,
          c.gender,
          c.organization_name,
          c.organization_id,
          c.ods_code,
          c.postcode,
          o.clinical_effective_date,
          ct.original_code,
          ct.original_term,
          o.result_value,
          o.result_value_units,
          o.non_core_concept_id
      FROM ',p_cohorttab ,' c JOIN ',p_schema ,'.observation o ON c.patient_id = o.patient_id AND c.organization_id = o.organization_id AND c.person_id = o.person_id
      JOIN ',p_concepttab ,' ct ON ct.non_core_concept_id = o.non_core_concept_id
      WHERE ',p_daterange);

   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('ALTER TABLE ', p_observationtab, ' ADD INDEX pat_idx(patient_id)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('ALTER TABLE ', p_observationtab, ' ADD INDEX non_core_cpt_idx(non_core_concept_id)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('ALTER TABLE ', p_observationtab, ' ADD INDEX clinical_date_idx(clinical_effective_date)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;


END//
DELIMITER ;
