USE dashboards;

DROP PROCEDURE IF EXISTS createClinicalTypesSet;

DELIMITER //
CREATE PROCEDURE createClinicalTypesSet(p_valueString VARCHAR(255), p_tab_name VARCHAR(64))
BEGIN
  
   SET @sql = CONCAT('DROP TABLE IF EXISTS ', p_tab_name);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT("CREATE TABLE ", p_tab_name, 
   " AS SELECT DISTINCT cct.code_type, cct.snomed_concept_id
   FROM clinical_code_types cct WHERE ", p_valueString);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT("UPDATE ", p_tab_name,
   " SET snomed_concept_id = CONCAT('SN_', snomed_concept_id) ");
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT("ALTER TABLE ", p_tab_name," ADD INDEX snomed_concept_idx(snomed_concept_id)");
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;



END//
DELIMITER ;
