USE dashboards;

DROP PROCEDURE IF EXISTS createPatientCohort;

DELIMITER //
CREATE PROCEDURE createPatientCohort(
     p_org VARCHAR(255),
     p_regStatus VARCHAR(255),
     p_ageRange VARCHAR(255),
     p_genderRange VARCHAR(255),
     p_postcodeRange VARCHAR(255),
     p_practiceCohortTab VARCHAR(64),
     p_schema VARCHAR(255)
)

BEGIN

   DECLARE p_death VARCHAR(100) DEFAULT NULL;
   -- DECLARE where_clause_1 VARCHAR(1000) DEFAULT NULL;
   DECLARE regstatus_1 VARCHAR(255) DEFAULT NULL;
   DECLARE regstatus_2 VARCHAR(255) DEFAULT NULL;

   DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(p_query_id, 'createPatientCohort',@code,@msg,now());
        RESIGNAL; -- rethrow the error
   END;

   IF p_regStatus <> '1' THEN
    SET p_death = 'p.date_of_death IS NULL';
    SET regstatus_1 = p_regStatus;
    SET regstatus_2 = REPLACE(p_regStatus,'e.','e2.');
    SET regstatus_2 = REPLACE(regstatus_2,'c.','c3.');
   ELSE
    SET p_death = '1';
    SET regstatus_1 = '1';
    SET regstatus_2 = '1';
   END IF;

   DROP TEMPORARY TABLE IF EXISTS qry_tmp;
  
   SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp  
   AS SELECT DISTINCT 
          e.person_id, 
          e.patient_id, 
          e.date_registered, 
          e.date_registered_end, 
          org.name AS organization_name, 
          org.id AS organization_id, 
          org.ods_code, 
          p.nhs_number, 
          p.date_of_birth, 
          p.date_of_death, 
          IF(p.date_of_death IS NULL, FLOOR(DATEDIFF(NOW(), p.date_of_birth) / 365.25), FLOOR(DATEDIFF(p.date_of_death, p.date_of_birth) / 365.25)) AS age, 
          c2.code AS gender, 
          pa.postcode 
   FROM ',p_schema,'.episode_of_care e 
   JOIN ',p_schema,'.organization org on org.id = e.organization_id 
   JOIN ',p_schema,'.concept c ON c.dbid = e.registration_type_concept_id 
   JOIN ',p_schema,'.patient p ON p.id = e.patient_id 
   JOIN ',p_schema,'.concept c2 ON c2.dbid = p.gender_concept_id 
   LEFT JOIN ',p_schema,'.patient_address pa ON p.current_address_id = pa.id AND p.id = pa.patient_id 
   WHERE ',regstatus_1, 
   ' AND e.id >= (SELECT MAX(e2.id) 
                  FROM ',p_schema,'.episode_of_care e2 
                  JOIN ',p_schema,'.organization org2 ON org2.id = e2.organization_id 
                  JOIN ',p_schema,'.concept c3 ON c3.dbid = e2.registration_type_concept_id 
                  WHERE ',regstatus_2,' 
                  AND e2.person_id = e.person_id AND e2.organization_id = e.organization_id) 
     AND ',p_org,' 
     AND ',p_ageRange,' 
     AND ',p_genderRange,' 
     AND ',p_postcodeRange,' 
     AND ',p_death);

   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   ALTER TABLE qry_tmp ADD INDEX pat_idx(patient_id);
   ALTER TABLE qry_tmp ADD INDEX org_idx(organization_id);
  

   SET @sql = CONCAT('DROP TABLE IF EXISTS ', p_practiceCohortTab);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   -- filter patients to create the patient cohort
   SET @sql = CONCAT('CREATE TABLE ', p_practiceCohortTab, ' 
   AS SELECT DISTINCT c.person_id, c.patient_id, c.organization_id, c.date_registered, c.age 
   FROM qry_tmp c ');

   -- WHERE ', where_clause_1);

   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('ALTER TABLE ', p_practiceCohortTab, ' ADD INDEX pat_idx(patient_id)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('ALTER TABLE ', p_practiceCohortTab, ' ADD INDEX org_idx(organization_id)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;


END//
DELIMITER ;