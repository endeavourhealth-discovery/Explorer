USE dashboards;

DROP PROCEDURE IF EXISTS createConcept;

DELIMITER //
CREATE PROCEDURE createConcept(p_clinicalTypesConceptTab VARCHAR(64), p_clinicalTypesTab VARCHAR(64), p_schema VARCHAR(255))
BEGIN

   SET @sql = CONCAT('DROP TABLE IF EXISTS ', p_clinicalTypesConceptTab);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT("CREATE TABLE ", p_clinicalTypesConceptTab, " AS 
   SELECT ct.code_type, cptm.legacy AS non_core_concept_id 
   FROM ", p_clinicalTypesTab," ct JOIN ", p_schema,".concept cpt ON cpt.id = ct.snomed_concept_id 
   JOIN ", p_schema,".concept_map cptm ON cptm.core = cpt.dbid "); 

   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('ALTER TABLE ', p_concepttab, ' ADD INDEX non_cpt_idx(non_core_concept_id)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

END//
DELIMITER ;
