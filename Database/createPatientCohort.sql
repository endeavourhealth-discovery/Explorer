USE dashboards;

DROP PROCEDURE IF EXISTS createPatientCohort;

DELIMITER //
CREATE PROCEDURE createPatientCohort(
     p_org VARCHAR(255),
     p_regstatus VARCHAR(255),
     p_agerange VARCHAR(255),
     p_genderrange VARCHAR(255),
     p_postcoderange VARCHAR(255),
     p_daterange VARCHAR(255), 
     p_concepttab VARCHAR(64),
     p_cohorttab VARCHAR(64),
     p_schema VARCHAR(255)
)

BEGIN

   DECLARE p_death VARCHAR(100) DEFAULT NULL;

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

   SET @sql = CONCAT('DROP TABLE IF EXISTS ', p_cohorttab);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   -- filter patients by observations to create the patient cohort
   SET @sql = CONCAT('CREATE TABLE ', p_cohorttab, ' AS 
      SELECT DISTINCT o.person_id, o.patient_id, o.organization_id 
      FROM qry_tmp c JOIN ',p_schema ,'.observation o 
      ON c.patient_id = o.patient_id AND c.organization_id = o.organization_id AND c.person_id = o.person_id 
      JOIN ',p_concepttab ,' ct ON ct.non_core_concept_id = o.non_core_concept_id 
      WHERE ',p_daterange);

   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('ALTER TABLE ', p_cohorttab, ' ADD INDEX pat_idx(patient_id)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

END//
DELIMITER ;