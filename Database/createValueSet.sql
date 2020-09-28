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
   " AS SELECT 
              vsc.value_set_id, 
              vsc.original_code, 
              vsc.original_term, 
              vsc.snomed_id,
              vs.name AS value_name,
              vs.type AS value_type
        FROM value_set_codes vsc JOIN value_sets vs ON vsc.value_set_id = vs.id
        WHERE ", p_valueString);

   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;


END//
DELIMITER ;
