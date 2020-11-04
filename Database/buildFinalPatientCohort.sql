USE dashboards;

DROP PROCEDURE IF EXISTS buildFinalPatientCohort;

DELIMITER //

CREATE PROCEDURE buildFinalPatientCohort (
    IN p_query_id INT,
    IN p_patientcohorttab VARCHAR(64),    
    IN p_observationcohorttab VARCHAR(64),    
    IN p_includeExclude1String VARCHAR(1000),
    IN p_includeExclude1aString VARCHAR(1000),
    IN p_includeExclude1bString VARCHAR(1000),
    IN p_includeExclude1cString VARCHAR(1000),
    IN p_includeExclude1dString VARCHAR(1000),
    IN p_includeExclude2String VARCHAR(1000),
    IN p_includeExclude2aString VARCHAR(1000),
    IN p_includeExclude3String VARCHAR(1000),
    IN p_includeExclude4String VARCHAR(1000),
    IN p_includeExclude5String VARCHAR(1000),
    IN p_schema VARCHAR(255)
)

BEGIN

  DECLARE qrytabname VARCHAR(64);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(p_query_id,'buildFinalPatientCohort',@code,@msg,now());
        RESIGNAL; -- rethrow the error
    END;   

    DROP TEMPORARY TABLE IF EXISTS qry_tmp;
    SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp AS 
    SELECT DISTINCT ', p_query_id,' AS query_id, o.patient_id, o.person_id, o.organization_id FROM ', p_observationcohorttab,' o ');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    ALTER TABLE qry_tmp ADD INDEX pat_idx(patient_id);

    SET qrytabname = 'qry_tmp';
-- 1

    IF p_includeExclude1String <> '1' THEN

      DROP TEMPORARY TABLE IF EXISTS qry_tmp_1;
      SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp_1 AS 
      SELECT DISTINCT o.query_id, o.patient_id, o.person_id, o.organization_id FROM ', qrytabname,' o WHERE ', p_includeExclude1String);
      PREPARE stmt FROM @sql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
      ALTER TABLE qry_tmp_1 ADD INDEX pat_idx(patient_id);

      SET qrytabname = 'qry_tmp_1';

    END IF;
-- 1a

    IF p_includeExclude1aString <> '1' THEN

      DROP TEMPORARY TABLE IF EXISTS qry_tmp_1a;
      SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp_1a AS 
      SELECT DISTINCT o.query_id, o.patient_id, o.person_id, o.organization_id FROM ', qrytabname,' o WHERE ', p_includeExclude1aString);
      PREPARE stmt FROM @sql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
      ALTER TABLE qry_tmp_1a ADD INDEX pat_idx(patient_id);

      SET qrytabname = 'qry_tmp_1a';

    END IF;
-- 1b

    IF p_includeExclude1bString <> '1' THEN

      DROP TEMPORARY TABLE IF EXISTS qry_tmp_1b;
      SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp_1b AS 
      SELECT DISTINCT o.query_id, o.patient_id, o.person_id, o.organization_id FROM ', qrytabname,' o WHERE ', p_includeExclude1bString);
      PREPARE stmt FROM @sql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
      ALTER TABLE qry_tmp_1b ADD INDEX pat_idx(patient_id);

      SET qrytabname = 'qry_tmp_1b';

    END IF;

-- 1c

    IF p_includeExclude1cString <> '1' THEN

      DROP TEMPORARY TABLE IF EXISTS qry_tmp_1c;
      SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp_1c AS 
      SELECT DISTINCT o.query_id, o.patient_id, o.person_id, o.organization_id FROM ', qrytabname,' o WHERE ', p_includeExclude1cString);
      PREPARE stmt FROM @sql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
      ALTER TABLE qry_tmp_1c ADD INDEX pat_idx(patient_id);

      SET qrytabname = 'qry_tmp_1c';

    END IF;

-- 1d

    IF p_includeExclude1dString <> '1' THEN

      DROP TEMPORARY TABLE IF EXISTS qry_tmp_1d;
      SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp_1d AS 
      SELECT DISTINCT o.query_id, o.patient_id, o.person_id, o.organization_id FROM ', qrytabname,' o WHERE ', p_includeExclude1dString);
      PREPARE stmt FROM @sql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
      ALTER TABLE qry_tmp_1d ADD INDEX pat_idx(patient_id);

      SET qrytabname = 'qry_tmp_1d';

    END IF;

-- 2

    IF p_includeExclude2String <> '1' THEN

      DROP TEMPORARY TABLE IF EXISTS qry_tmp_2;
      SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp_2 AS 
      SELECT DISTINCT o.query_id, o.patient_id, o.person_id, o.organization_id FROM ', qrytabname,' o WHERE ', p_includeExclude2String);
      PREPARE stmt FROM @sql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
      ALTER TABLE qry_tmp_2 ADD INDEX pat_idx(patient_id);

      SET qrytabname = 'qry_tmp_2';

    END IF;
-- 2a    

    IF p_includeExclude2aString <> '1' THEN

      DROP TEMPORARY TABLE IF EXISTS qry_tmp_2a;
      SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp_2a AS 
      SELECT DISTINCT o.query_id, o.patient_id, o.person_id, o.organization_id FROM ', qrytabname,' o WHERE ', p_includeExclude2aString);
      PREPARE stmt FROM @sql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
      ALTER TABLE qry_tmp_2a ADD INDEX pat_idx(patient_id);

      SET qrytabname = 'qry_tmp_2a';

    END IF;
-- 3

    IF p_includeExclude3String <> '1' THEN

      DROP TEMPORARY TABLE IF EXISTS qry_tmp_3;
      SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp_3 AS 
      SELECT DISTINCT o.query_id, o.patient_id, o.person_id, o.organization_id FROM ', qrytabname,' o WHERE ', p_includeExclude3String);
      PREPARE stmt FROM @sql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
      ALTER TABLE qry_tmp_3 ADD INDEX pat_idx(patient_id);

      SET qrytabname = 'qry_tmp_3';

    END IF;
-- 4

    IF p_includeExclude4String <> '1' THEN

      DROP TEMPORARY TABLE IF EXISTS qry_tmp_4;
      SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp_4 AS 
      SELECT DISTINCT o.query_id, o.patient_id, o.person_id, o.organization_id FROM ', qrytabname,' o WHERE ', p_includeExclude4String);
      PREPARE stmt FROM @sql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
      ALTER TABLE qry_tmp_4 ADD INDEX pat_idx(patient_id);

      SET qrytabname = 'qry_tmp_4';

    END IF;
-- 5

    IF p_includeExclude5String <> '1' THEN

      DROP TEMPORARY TABLE IF EXISTS qry_tmp_5;
      SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp_5 AS 
      SELECT DISTINCT o.query_id, o.patient_id, o.person_id, o.organization_id FROM ', qrytabname,' o WHERE ', p_includeExclude5String);
      PREPARE stmt FROM @sql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
      ALTER TABLE qry_tmp_5 ADD INDEX pat_idx(patient_id);

      SET qrytabname = 'qry_tmp_5';

    END IF;
    
-- build final patient cohort table

    DROP TEMPORARY TABLE IF EXISTS qry_tmp_6;

    SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp_6 AS 
    SELECT DISTINCT o.query_id, o.patient_id, o.person_id, o.organization_id FROM ', qrytabname,' o ');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt; 
    
    SET @sql = CONCAT('DROP TABLE IF EXISTS ', p_patientcohorttab);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @sql = CONCAT('CREATE TABLE ', p_patientcohorttab,' AS 
    SELECT DISTINCT q.query_id, 
           p.id AS patient_id, 
           p.person_id, 
           p.organization_id, '
           ,p_schema,'.getOrganizationName(p.organization_id) AS Organization, ' 
           ,p_schema,'.getCCGName(p.organization_id) AS CCG, ' 
           ,p_schema,'.getOrganizationName(p.registered_practice_organization_id) AS registered_practice, '  
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
    FROM qry_tmp_6 q JOIN ', p_schema,'.patient p ON p.id = q.patient_id AND p.person_id = q.person_id AND p.organization_id = q.organization_id ');

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


END//
DELIMITER ;
