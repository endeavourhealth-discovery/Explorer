USE dashboards;

DROP PROCEDURE IF EXISTS createValueSet;

DELIMITER //
CREATE PROCEDURE createValueSet(p_valueString VARCHAR(255), p_tab_name VARCHAR(64))
BEGIN
  
   SET @sql = CONCAT('DROP TABLE IF EXISTS ', p_tab_name);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT("CREATE TABLE ", p_tab_name, 
   " AS SELECT DISTINCT vsc.original_code, vsc.original_term, 
   vsc.snomed_id, vsc.type AS value_set_code_type 
   FROM value_set_codes vsc WHERE ", p_valueString);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT("UPDATE ", p_tab_name,
   " SET original_code = CONCAT('FHIR_EC_', original_code) 
   WHERE snomed_id ='0' AND original_code REGEXP '^[A-Z]$' ");
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT("UPDATE ", p_tab_name,
   " SET original_code = CONCAT('EMLOC_', original_code) 
   WHERE snomed_id ='0' AND LEFT(original_code, 5) = '^ESCT' ");
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT("UPDATE ", p_tab_name,
   " SET original_code = CONCAT('SN_', snomed_id) WHERE snomed_id <> '0' ");
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;


   SET @sql = CONCAT("ALTER TABLE ", p_tab_name," ADD INDEX org_code_idx(original_code)");
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;



END//
DELIMITER ;
