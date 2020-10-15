USE dashboards;

DROP PROCEDURE IF EXISTS createConcept;

DELIMITER //
CREATE PROCEDURE createConcept(p_concepttab VARCHAR(64), p_valuesettab VARCHAR(64), p_schema VARCHAR(255))
BEGIN

   SET @sql = CONCAT('DROP TABLE IF EXISTS ',p_concepttab);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT("CREATE TABLE ", p_concepttab, " AS 
   SELECT vc.value_set_code_type, 
          cptm.legacy AS non_core_concept_id 
   FROM ",p_valuesettab," vc JOIN ", p_schema,".concept cpt ON cpt.id = vc.original_code 
   JOIN ", p_schema,".concept_map cptm ON cptm.core = cpt.dbid 
   WHERE vc.original_code LIKE 'SN\_%' 
   UNION 
   SELECT vc.value_set_code_type, 
          cpt.dbid AS non_core_concept_id 
   FROM ", p_valuesettab," vc JOIN ", p_schema,".concept cpt ON cpt.id = vc.original_code 
   UNION 
   SELECT vc.value_set_code_type, 
          cpt.dbid AS non_core_concept_id 
   FROM ", p_valuesettab," vc JOIN ", p_schema,".concept cpt ON cpt.id = CONCAT('R2_',vc.original_code) 
   WHERE vc.snomed_id = '0' AND vc.value_set_code_type = 'Blood Pressure' 
   UNION 
   SELECT vc.value_set_code_type, 
          cpt.dbid AS non_core_concept_id 
   FROM ", p_valuesettab," vc JOIN ", p_schema,".concept cpt ON cpt.id = CONCAT('R3_',vc.original_code) 
   WHERE vc.snomed_id = '0' AND vc.value_set_code_type = 'Blood Pressure'");
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('ALTER TABLE ', p_concepttab, ' ADD INDEX non_cpt_idx(non_core_concept_id)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;


END//
DELIMITER ;
