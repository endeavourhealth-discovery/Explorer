USE dashboards;

DROP PROCEDURE IF EXISTS createValueSet;

DELIMITER //
CREATE PROCEDURE createValueSet(p_valueString VARCHAR(255), p_tab_name VARCHAR(64))
BEGIN

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(p_query_id, 'createValueSet', @code, @msg, now());
        RESIGNAL; -- rethrow the error
    END;

   SET @sql = CONCAT('DROP TABLE IF EXISTS ', p_tab_name);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

-- observation, encounter, medication
   SET @sql = CONCAT("CREATE TABLE ", p_tab_name, 
   " AS SELECT DISTINCT vsc.original_code, vsc.original_term, vsc.type AS value_set_code_type, vsc.data_type  
   FROM value_set_codes vsc WHERE ", p_valueString);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT("ALTER TABLE ", p_tab_name," ADD INDEX org_code_idx (original_code)"); 
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT("ALTER TABLE ", p_tab_name," ADD INDEX data_type_idx (data_type)"); 
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

-- Ethnicity
   SET @sql = CONCAT("UPDATE ", p_tab_name,
   " SET original_code = CONCAT('FHIR_EC_', original_code) 
   WHERE original_code REGEXP '^[A-Z]$' ");
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

-- observation
   SET @sql = CONCAT("UPDATE ", p_tab_name,
   " SET original_code = CONCAT('EMLOC_', original_code) 
   WHERE LEFT(original_code, 5) = '^ESCT' ");
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

-- medication
   SET @sql = CONCAT("INSERT INTO ", p_tab_name, 
   " SELECT REPLACE(vsc.original_code,'SN','DMD'), vsc.original_term, vsc.value_set_code_type, vsc.data_type 
   FROM ", p_tab_name," vsc 
   WHERE vsc.data_type = 'Medication' 
   AND vsc.original_code LIKE 'SN\_%' 
   AND NOT EXISTS ( SELECT 1 FROM ", p_tab_name," vsc1 WHERE vsc1.data_type = 'Medication' 
                    AND vsc1.original_code = CONCAT('DMD_', SUBSTRING(vsc.original_code, 4)) )"); 
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

END//
DELIMITER ;
