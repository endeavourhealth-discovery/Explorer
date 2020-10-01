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
   " AS SELECT DISTINCT
              vsc.original_code, 
              vsc.original_term, 
              vsc.snomed_id,
              vsc.type AS value_set_code_type
        FROM value_set_codes vsc 
        WHERE ", p_valueString);

   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;


END//
DELIMITER ;
