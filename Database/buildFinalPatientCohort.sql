USE dashboards;

DROP PROCEDURE IF EXISTS buildFinalPatientCohort;

DELIMITER //

CREATE PROCEDURE buildFinalPatientCohort (
    IN p_query_id INT,
    IN p_patientcohorttab VARCHAR(64),
    IN p_practiceChortTab VARCHAR(64), 
    IN p_ruleTab VARCHAR(64),   
    IN p_schema VARCHAR(255)
)


BEGIN

  DECLARE done INT;
  DECLARE l_id INT;
  DECLARE l_query_id INT;
  DECLARE l_selectTable VARCHAR(64);
  DECLARE l_ruleTab_id INT DEFAULT 0;
  DECLARE l_qryString VARCHAR(2000);
  DECLARE l_tmp VARCHAR(1000) DEFAULT NULL;


  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(p_query_id,'buildFinalPatientCohort', @code, @msg,now());
        RESIGNAL; -- rethrow the error
    END;   

  DROP TEMPORARY TABLE IF EXISTS qry_selectTables;
  SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_selectTables AS 
  SELECT id, query_id, selectTable FROM ', p_ruleTab,' WHERE query_id = ',p_query_id);
  PREPARE stmt FROM @sql;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt; 

  SET @id = 0;
  SET @cnt = 0;

  -- check rule table exists
  SET @sql = CONCAT('SELECT count(*) INTO @cnt FROM information_schema.TABLES 
  WHERE TABLE_NAME = ', QUOTE(p_ruleTab));
  PREPARE stmt FROM @sql;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt; 

  IF @cnt > 0 THEN
       -- check if more than 1 ids
       SET @sql = CONCAT('SELECT id INTO @id FROM ', p_ruleTab,' 
       WHERE selectTable IS NOT NULL AND query_id = ', p_query_id,' ORDER BY id DESC LIMIT 1');
       PREPARE stmt FROM @sql;
       EXECUTE stmt;
       DEALLOCATE PREPARE stmt; 

       IF @id > 1 THEN
          SET l_ruleTab_id = 1;
       ELSE 
          SET l_ruleTab_id = 0;
       END IF;
   
      BEGIN

        DECLARE c_get_selectTables CURSOR FOR SELECT id, query_id, selectTable FROM qry_selectTables WHERE selectTable IS NOT NULL AND id > l_ruleTab_id ORDER BY id ASC;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

        SET done = 0;

        OPEN c_get_selectTables;
        SET l_qryString = '';
        SET l_tmp = '';

        processSelects: 
        WHILE (done = 0) DO

        FETCH c_get_selectTables INTO l_id, l_query_id, l_selectTable;

              IF done = 1 THEN 
                  LEAVE processSelects;
              END IF;

              -- build qry string
              SET l_qryString =  CONCAT(l_qryString, 'SELECT patient_id, person_id, organization_id FROM ', l_selectTable);        
              SET l_qryString =  CONCAT(l_qryString,CASE WHEN LENGTH(l_qryString)>0 THEN ' UNION ' ELSE '' END);

              -- build tmp table list
              SET l_tmp = CONCAT(l_tmp, l_selectTable);
              SET l_tmp = CONCAT(l_tmp, CASE WHEN LENGTH(l_selectTable)>0 THEN ',' ELSE '' END);

        END WHILE processSelects;
        CLOSE c_get_selectTables;
        SET done = 0;

        -- remove the last UNION in the string
        SET l_qryString = SUBSTRING(l_qryString, 1, LENGTH(l_qryString)-6);

      END;
  
  ELSE

      SET l_qryString = '';
      SET l_qryString =  CONCAT(l_qryString, 'SELECT patient_id, person_id, organization_id FROM ', p_practiceChortTab);  
    
  END IF;

    DROP TEMPORARY TABLE IF EXISTS qry_patientCohort;

    SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_patientCohort AS 
    SELECT p.patient_id, p.person_id, p.organization_id FROM (', l_qryString,' ) p ');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt; 

    SET @sql = CONCAT('DROP TABLE IF EXISTS ', p_patientcohorttab);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @sql = CONCAT('CREATE TABLE ', p_patientcohorttab,' AS 
    SELECT DISTINCT '
           , p_query_id,' AS query_id,   
           p.id AS patient_id, 
           p.person_id, 
           p.organization_id, '
           ,p_schema,'.getOrganizationName(p.organization_id) AS Organization, ' 
           ,p_schema,'.getCCGName(p.organization_id) AS CCG, ' 
           ,p_schema,'.getOrganizationName(p.organization_id) AS registered_practice, ' 
           ,p_schema,'.getOrganizationOds(p.organization_id) AS ods_code, ' 
           ,p_schema,'.getConceptName(p.gender_concept_id) AS gender,  
           p.nhs_number, 
           p.date_of_birth, 
           p.date_of_death, ' 
           ,p_schema,'.getCurrentAddress(p.current_address_id, p.id) AS current_address, ' 
           ,p_schema,'.getCurrentAddressPostcode(p.current_address_id, p.id) AS postcode, ' 
           ,p_schema,'.getLSOACode(p.id) AS lsoa_code, '
           ,p_schema,'.getConceptName(p.ethnic_code_concept_id) AS ethnicity, 
           p.title, 
           p.first_names, 
           p.last_name, ' 
           ,p_schema,'.getPatientName(p.id) AS patient_name 
    FROM qry_patientCohort q JOIN ', p_schema,'.patient p ON p.id = q.patient_id AND p.person_id = q.person_id AND p.organization_id = q.organization_id ');

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @sql = CONCAT('ALTER TABLE ', p_patientcohorttab,' ADD INDEX pat_idx(patient_id)');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @sql = CONCAT('ALTER TABLE ', p_patientcohorttab,' ADD INDEX org_idx(organization_id)');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

        -- clean up tmp tables
    SET l_tmp = SUBSTRING(l_tmp, 1, LENGTH(l_tmp)-1);
    CALL dropTempTables(l_tmp);


END//
DELIMITER ;
