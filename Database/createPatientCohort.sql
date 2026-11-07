USE dashboards;

DROP PROCEDURE IF EXISTS createPatientCohort;

DELIMITER //
CREATE PROCEDURE createPatientCohort(
     p_query_id INT,
     p_org VARCHAR(255),
     p_regStatus VARCHAR(255),
     p_genderRange VARCHAR(255),
     p_postcodeRange VARCHAR(255),
     p_practiceCohortTab VARCHAR(64),
     p_ethnicGroups VARCHAR(255), 
     p_lsoaString VARCHAR(255), 
     p_msoaString VARCHAR(255), 
     p_baselineDate VARCHAR(30),
     p_schema VARCHAR(255)
)

BEGIN

   DECLARE p_death VARCHAR(100) DEFAULT NULL;
   DECLARE regstatus_1 VARCHAR(255) DEFAULT NULL;
   DECLARE regstatus_2 VARCHAR(255) DEFAULT NULL;
   DECLARE denominatorPatientCohort_tmp VARCHAR(64) DEFAULT NULL;
   DECLARE join_clause_1 VARCHAR(1000) DEFAULT NULL;
   DECLARE baselineDate VARCHAR(255) DEFAULT NULL;
   DECLARE age_col_1 VARCHAR(500) DEFAULT NULL;

   DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(p_query_id, 'createPatientCohort', @code, @msg, now());
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

   IF p_baselineDate IS NULL OR p_baselineDate = '' THEN
      SET baselineDate = ' 1 ';
      SET age_col_1 = 'IF(p.date_of_death IS NULL, FLOOR(DATEDIFF(NOW(), p.date_of_birth) / 365.25), FLOOR(DATEDIFF(p.date_of_death, p.date_of_birth) / 365.25)) AS age, ';
   ELSE
      SET baselineDate = p_baselineDate;
      SET regstatus_1 = CONCAT(REPLACE(regstatus_1,"NOW()",QUOTE(baselineDate))," AND e.date_registered <= ", QUOTE(baselineDate));
      SET regstatus_2 = CONCAT(REPLACE(regstatus_2,"NOW()",QUOTE(baselineDate))," AND e2.date_registered <= ", QUOTE(baselineDate));
      SET age_col_1 = CONCAT("IF(p.date_of_death IS NULL OR p.date_of_death > ",QUOTE(baselineDate),", FLOOR(DATEDIFF( ",QUOTE(baselineDate)," , p.date_of_birth) / 365.25), IF(p.date_of_death IS NOT NULL OR p.date_of_death <= ", QUOTE(baselineDate)," , FLOOR(DATEDIFF(p.date_of_death, p.date_of_birth) / 365.25), NULL)) AS age, ");
      IF p_death <> '1' THEN
         SET p_death = CONCAT("(p.date_of_death IS NULL OR p.date_of_death > ",QUOTE(baselineDate),")");
      END IF;
   END IF;

   -- check if the query had a denominator as the base query

   SET @denominator_id = NULL;

   SET @sql = CONCAT("SELECT id INTO @denominator_id
   FROM query_library WHERE name = (
   SELECT denominator_query FROM query_library WHERE id = ", p_query_id,')' );
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   IF @denominator_id IS NOT NULL THEN
      SET denominatorPatientCohort_tmp = CONCAT('patientcohort_tmp_',@denominator_id);
      SET join_clause_1 = CONCAT('JOIN ', denominatorPatientCohort_tmp, ' d ON d.patient_id = p.id AND d.organization_id = p.organization_id AND d.person_id = p.person_id ');
   ELSE
      SET join_clause_1 = 'JOIN (SELECT 1 ) d '; -- dummy join
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
          p.date_of_death, ',age_col_1,' 
          c2.code AS gender, 
          el.ethnic_group, 
          pa.lsoa_2011_code AS lsoa_code, 
          pa.msoa_2011_code AS msoa_code,
          pa.postcode 
   FROM ', p_schema,'.episode_of_care e 
   JOIN ', p_schema,'.organization org on org.id = e.organization_id 
   JOIN ', p_schema,'.concept c ON c.dbid = e.registration_type_concept_id 
   JOIN ', p_schema,'.patient p ON p.id = e.patient_id ', join_clause_1,'
   JOIN ', p_schema,'.concept c2 ON c2.dbid = p.gender_concept_id ', p_org, ' 
   LEFT JOIN ', p_schema,'.patient_address pa ON p.current_address_id = pa.id AND p.id = pa.patient_id 
   LEFT JOIN ', p_schema,'.concept c3 ON c3.dbid = p.ethnic_code_concept_id
   LEFT JOIN ', p_schema,'.ethnicity_lookup el ON el.ethnic_name = c3.name 
   WHERE ', regstatus_1, 
   ' AND e.id >= (SELECT MAX(e2.id) 
                  FROM ', p_schema,'.episode_of_care e2 
                  JOIN ', p_schema,'.organization org2 ON org2.id = e2.organization_id 
                  JOIN ', p_schema,'.concept c3 ON c3.dbid = e2.registration_type_concept_id 
                  WHERE ', regstatus_2,' 
                  AND e2.person_id = e.person_id AND e2.organization_id = e.organization_id) 
     AND ', p_genderRange,' 
     AND ', p_ethnicGroups,' 
     AND ', p_lsoaString,' 
     AND ', p_msoaString,' 
     AND ', p_postcodeRange,' 
     AND ', p_death);

   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   ALTER TABLE qry_tmp ADD INDEX pat_idx (patient_id);
   ALTER TABLE qry_tmp ADD INDEX org_idx (organization_id);
  
   SET @sql = CONCAT('DROP TABLE IF EXISTS ', p_practiceCohortTab);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   -- filter patients to create the practice cohort
   SET @sql = CONCAT('CREATE TABLE ', p_practiceCohortTab, ' 
   AS SELECT DISTINCT c.person_id, c.patient_id, c.organization_id, c.date_registered, c.age, c.date_of_birth, c.date_of_death FROM qry_tmp c ');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('ALTER TABLE ', p_practiceCohortTab, ' ADD INDEX pat_idx (patient_id)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('ALTER TABLE ', p_practiceCohortTab, ' ADD INDEX org_idx (organization_id)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

END//
DELIMITER ;