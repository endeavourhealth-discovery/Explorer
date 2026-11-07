USE dashboards;

DROP PROCEDURE IF EXISTS matchAllValueSets;

DELIMITER //
CREATE PROCEDURE matchAllValueSets(
  IN p_query_id INT,
  IN p_qry_tmp VARCHAR(64),
  IN p_concepttab VARCHAR(64),
  IN p_qry_return_tmp VARCHAR(64)
)

BEGIN

  DECLARE done INT;
  DECLARE l_valueset VARCHAR(255);
  DECLARE cnt INT;
  DECLARE idx INT;
  DECLARE n INT DEFAULT 0;
  DECLARE patientString VARCHAR(255);

  DECLARE c_get_valueset CURSOR FOR SELECT value_set_code_type FROM qry_val_1;
    
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(p_query_id, 'matchAllValueSets', @code, @msg, now());
        RESIGNAL; -- rethrow the error
    END;

    DROP TEMPORARY TABLE IF EXISTS qry_val_1;
    SET @sql = CONCAT("CREATE TEMPORARY TABLE qry_val_1 AS
    SELECT DISTINCT value_set_code_type 
    FROM ", p_concepttab );
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt; 

  SET done = 0;

        OPEN c_get_valueset;
        
        SET cnt = 0;
        processloop: 
        WHILE (done = 0) DO

            FETCH c_get_valueset INTO l_valueset;

            IF done = 1 THEN 
               LEAVE processloop;
            END IF;
             
            SET cnt = cnt + 1;
            SET idx = 0;

            SET @sql = CONCAT("DROP TEMPORARY TABLE IF EXISTS qry_value_tmp_",cnt);
            PREPARE stmt FROM @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            IF cnt = 1 THEN
             SET patientString = '1';
            ELSE
             SET idx = cnt - 1;
             SET patientString = CONCAT("p.patient_id IN (SELECT patient_id FROM qry_value_tmp_", idx," )");
            END IF;

            SET @sql = CONCAT("CREATE TEMPORARY TABLE qry_value_tmp_",cnt," AS 
            SELECT p.id, p.patient_id, p.person_id, p.clinical_effective_date, p.result_value, p.non_core_concept_id, p.organization_id, p.value_set_code_type, p.cancellation_date 
            FROM ",p_qry_tmp," p WHERE p.value_set_code_type = ", QUOTE(l_valueset)," AND ", patientString); 
            PREPARE stmt FROM @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET n = cnt;

        END WHILE processloop;
        CLOSE c_get_valueset;
        SET done = 0;

        SET @sql = CONCAT("DROP TEMPORARY TABLE IF EXISTS ", p_qry_return_tmp);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

        SET @sql = CONCAT("CREATE TEMPORARY TABLE ", p_qry_return_tmp, " AS  
        SELECT id, patient_id, person_id, clinical_effective_date, result_value, non_core_concept_id, organization_id, value_set_code_type, cancellation_date 
        FROM qry_value_tmp_", n);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

        SET @sql = CONCAT("ALTER TABLE ", p_qry_return_tmp," ADD INDEX pat_idx (patient_id)");
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

END //
DELIMITER ;
