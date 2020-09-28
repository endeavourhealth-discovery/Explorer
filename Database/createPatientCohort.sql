USE dashboards;

DROP PROCEDURE IF EXISTS createPatientCohort;

DELIMITER //
CREATE PROCEDURE createPatientCohort(
     p_org VARCHAR(255),
     p_regstatus VARCHAR(255),
     p_agerange VARCHAR(255),
     p_genderrange VARCHAR(255),
     p_postcoderange VARCHAR(255),
     p_cohorttab VARCHAR(64)
)

BEGIN

   DECLARE p_death VARCHAR(100) DEFAULT NULL;

   IF p_regstatus <> '1' THEN
    SET p_death = 'p.date_of_death IS NULL';
   ELSE
    SET p_death = '1';
   END IF;

   SET @sql = CONCAT('DROP TABLE IF EXISTS ',p_cohorttab);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('CREATE TABLE ',p_cohorttab, 
   ' AS SELECT DISTINCT 
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
   FROM subscriber_pi_rv.episode_of_care e 
   JOIN subscriber_pi_rv.organization org on org.id = e.organization_id 
   JOIN subscriber_pi_rv.concept c ON c.dbid = e.registration_type_concept_id
   JOIN subscriber_pi_rv.patient p ON p.id = e.patient_id
   JOIN subscriber_pi_rv.concept c2 ON c2.dbid = p.gender_concept_id
   LEFT JOIN subscriber_pi_rv.patient_address pa ON p.current_address_id = pa.id AND p.id = pa.patient_id
   WHERE ',p_regstatus,
   ' AND e.id >= (SELECT MAX(e2.id) 
                  FROM subscriber_pi_rv.episode_of_care e2
                  JOIN subscriber_pi_rv.organization org2 ON org2.id = e2.organization_id 
			            JOIN subscriber_pi_rv.concept c ON c.dbid = e2.registration_type_concept_id
                  WHERE ',p_regstatus,' AND e2.person_id = e.person_id) 
     AND ',p_org,' AND ',p_agerange,' AND ',p_genderrange,' AND ',p_postcoderange,' AND ',p_death);
     
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('ALTER TABLE ',p_cohorttab, ' ADD INDEX pat_idx(patient_id)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('ALTER TABLE ',p_cohorttab, ' ADD INDEX org_idx(organization_id)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

END//
DELIMITER ;