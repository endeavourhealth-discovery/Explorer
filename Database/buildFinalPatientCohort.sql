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
    IN p_includeExclude2String VARCHAR(1000),
    IN p_includeExclude2aString VARCHAR(1000),
    IN p_includeExclude3String VARCHAR(1000),
    IN p_includeExclude4String VARCHAR(1000),
    IN p_includeExclude5String VARCHAR(1000) 
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
    SELECT DISTINCT ', p_query_id,' AS query_id, o.patient_id FROM ', p_observationcohorttab,' o ');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    ALTER TABLE qry_tmp ADD INDEX pat_idx(patient_id);

    SET qrytabname = 'qry_tmp';
-- 1

    IF p_includeExclude1String <> '1' THEN

      DROP TEMPORARY TABLE IF EXISTS qry_tmp_1;
      SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp_1 AS 
      SELECT DISTINCT o.query_id, o.patient_id FROM ', qrytabname,' o WHERE ', p_includeExclude1String);
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
      SELECT DISTINCT o.query_id, o.patient_id FROM ', qrytabname,' o WHERE ', p_includeExclude1aString);
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
      SELECT DISTINCT o.query_id, o.patient_id FROM ', qrytabname,' o WHERE ', p_includeExclude1bString);
      PREPARE stmt FROM @sql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
      ALTER TABLE qry_tmp_1b ADD INDEX pat_idx(patient_id);

      SET qrytabname = 'qry_tmp_1b';

    END IF;
-- 2

    IF p_includeExclude2String <> '1' THEN

      DROP TEMPORARY TABLE IF EXISTS qry_tmp_2;
      SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp_2 AS 
      SELECT DISTINCT o.query_id, o.patient_id FROM ', qrytabname,' o WHERE ', p_includeExclude2String);
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
      SELECT DISTINCT o.query_id, o.patient_id FROM ', qrytabname,' o WHERE ', p_includeExclude2aString);
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
      SELECT DISTINCT o.query_id, o.patient_id FROM ', qrytabname,' o WHERE ', p_includeExclude3String);
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
      SELECT DISTINCT o.query_id, o.patient_id FROM ', qrytabname,' o WHERE ', p_includeExclude4String);
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
      SELECT DISTINCT o.query_id, o.patient_id FROM ', qrytabname,' o WHERE ', p_includeExclude5String);
      PREPARE stmt FROM @sql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
      ALTER TABLE qry_tmp_5 ADD INDEX pat_idx(patient_id);

      SET qrytabname = 'qry_tmp_5';

    END IF;
    
-- build patient cohort table

    SET @sql = CONCAT('DROP TABLE IF EXISTS ', p_patientcohorttab);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @sql = CONCAT('CREATE TABLE ', p_patientcohorttab,' AS 
    SELECT DISTINCT o.query_id, o.patient_id FROM ', qrytabname,' o ');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @sql = CONCAT('ALTER TABLE ', p_patientcohorttab,' ADD INDEX pat_idx(patient_id)');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

END//
DELIMITER ;
