USE dashboards;

DROP PROCEDURE IF EXISTS createPatientCohort;

DELIMITER //
CREATE PROCEDURE createPatientCohort(
     p_org VARCHAR(255),
     p_regstatus VARCHAR(255),
     p_agerange VARCHAR(255),
     p_genderrange VARCHAR(255),
     p_postcoderange VARCHAR(255),
     p_regPeriodRange VARCHAR(500), 
     p_regIncludeExclude VARCHAR(10),
     p_cohorttab VARCHAR(64),
     p_schema VARCHAR(255)
)

BEGIN

   DECLARE p_death VARCHAR(100) DEFAULT NULL;
   DECLARE where_clause_1 VARCHAR(1000) DEFAULT NULL;

   SET p_regIncludeExclude = UPPER(p_regIncludeExclude);
   SET p_regIncludeExclude = IF(p_regIncludeExclude = 'EXCLUDE','NOT EXISTS', IF(p_regIncludeExclude = 'INCLUDE','EXISTS',''));

   IF p_regstatus <> '1' THEN
    SET p_death = 'p.date_of_death IS NULL';
   ELSE
    SET p_death = '1';
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
   WHERE ',p_regstatus, 
   ' AND e.id >= (SELECT MAX(e2.id) 
                  FROM ',p_schema,'.episode_of_care e2 
                  JOIN ',p_schema,'.organization org2 ON org2.id = e2.organization_id 
                  JOIN ',p_schema,'.concept c ON c.dbid = e2.registration_type_concept_id 
                  WHERE ',p_regstatus,' 
                  AND e2.person_id = e.person_id) 
     AND ',p_org,' 
     AND ',p_agerange,' 
     AND ',p_genderrange,' 
     AND ',p_postcoderange,' 
     AND ',p_death);

   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   ALTER TABLE qry_tmp ADD INDEX pat_idx(patient_id);
   ALTER TABLE qry_tmp ADD INDEX org_idx(organization_id);
  
   IF p_regPeriodRange <> '1' THEN 

        DROP TEMPORARY TABLE IF EXISTS qry_tmp_2;

        -- filter patients by registration date range
        SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp_2 AS 
        SELECT DISTINCT c.person_id, c.patient_id, c.organization_id 
        FROM qry_tmp c 
        WHERE ', p_regPeriodRange);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        
        -- set where clause
        SET where_clause_1 = CONCAT(p_regIncludeExclude,' (SELECT 1 FROM qry_tmp_2 c2 WHERE c2.patient_id = c.patient_id) ');
   ELSE
        SET where_clause_1 = '1';
   END IF;

   SET @sql = CONCAT('DROP TABLE IF EXISTS ', p_cohorttab);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   -- filter patients to create the patient cohort
   SET @sql = CONCAT('CREATE TABLE ', p_cohorttab, ' 
   AS SELECT DISTINCT c.person_id, c.patient_id, c.organization_id 
   FROM qry_tmp c 
   WHERE ', where_clause_1);

   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('ALTER TABLE ', p_cohorttab, ' ADD INDEX pat_idx (patient_id)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;


END//
DELIMITER ;