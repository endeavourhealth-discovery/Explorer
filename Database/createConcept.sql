USE dashboards;

DROP PROCEDURE IF EXISTS createConcept;

DELIMITER //
CREATE PROCEDURE createConcept(p_concepttab VARCHAR(64), p_valuesettab VARCHAR(64))
BEGIN

   SET @sql = CONCAT('DROP TABLE IF EXISTS ',p_concepttab);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT("CREATE TABLE ",p_concepttab , " AS 
   SELECT vc.value_set_id, 
          cpt.code AS original_code, 
          cpt.name AS original_term, 
          vc.snomed_id,
          cpt.dbid,
          cptm.legacy AS non_core_concept_id
   FROM ",p_valuesettab," vc JOIN subscriber_pi_rv.concept cpt ON cpt.id = CONCAT('SN_', vc.snomed_id) 
   JOIN subscriber_pi_rv.concept_map cptm ON cptm.core = cpt.dbid
   WHERE vc.snomed_id <> '0'
   UNION 
   SELECT vc.value_set_id, 
          cpt.code AS original_code,  
          cpt.name AS original_term, 
          vc.snomed_id,
          cpt.dbid,
          cpt.dbid AS non_core_concept_id
   FROM ", p_valuesettab," vc JOIN subscriber_pi_rv.concept cpt ON cpt.id = CONCAT('EMLOC_', vc.original_code) 
   WHERE vc.snomed_id = '0' 
   AND LEFT(vc.original_code, 5) = '^ESCT' 
   UNION 
   SELECT vc.value_set_id, 
          cpt.code AS original_code,  
          cpt.name AS original_term, 
          vc.snomed_id,
          cpt.dbid,
          cpt.dbid AS non_core_concept_id
   FROM ", p_valuesettab," vc JOIN subscriber_pi_rv.concept cpt ON cpt.id = CONCAT('FHIR_EC_', vc.original_code) 
   WHERE vc.snomed_id = '0' 
   AND vc.original_code REGEXP '[A-Z]'
   UNION 
   SELECT vc.value_set_id, 
          cpt.code AS original_code,  
          cpt.name AS original_term, 
          vc.snomed_id,
          cpt.dbid,
          cpt.dbid AS non_core_concept_id
   FROM ", p_valuesettab," vc JOIN subscriber_pi_rv.concept cpt ON cpt.id = vc.original_code
   WHERE vc.snomed_id = '0' 
   AND vc.original_code LIKE 'LE\_%'
   UNION 
   SELECT vc.value_set_id, 
          cpt.code AS original_code,  
          cpt.name AS original_term,
          vc.snomed_id,
          cpt.dbid,
          cpt.dbid AS non_core_concept_id
   FROM ", p_valuesettab," vc JOIN subscriber_pi_rv.concept cpt ON cpt.id = vc.original_code
   WHERE vc.snomed_id = '0' 
   AND vc.original_code LIKE 'CM\_%'
   UNION 
   SELECT vc.value_set_id, 
          cpt.code AS original_code, 
          cpt.name AS original_term, 
          vc.snomed_id,
          cpt.dbid,
          cpt.dbid AS non_core_concept_id
   FROM ", p_valuesettab," vc JOIN subscriber_pi_rv.concept cpt ON cpt.id = vc.original_code
   WHERE vc.snomed_id = '0' 
   AND vc.original_code LIKE 'DC\_%'
   UNION 
   SELECT vc.value_set_id, 
          cpt.code AS original_code,  
          cpt.name AS original_term,
          vc.snomed_id,
          cpt.dbid,
          cpt.dbid AS non_core_concept_id
   FROM ", p_valuesettab," vc JOIN subscriber_pi_rv.concept cpt ON cpt.id = CONCAT('R2_',vc.original_code)
   WHERE vc.snomed_id = '0' 
   AND vc.value_type = 'Blood Pressure'
   UNION 
   SELECT vc.value_set_id, 
          cpt.code AS original_code,  
          cpt.name AS original_term,
          vc.snomed_id,
          cpt.dbid,
          cpt.dbid AS non_core_concept_id
   FROM ", p_valuesettab," vc JOIN subscriber_pi_rv.concept cpt ON cpt.id = CONCAT('R3_',vc.original_code)
   WHERE vc.snomed_id = '0' 
   AND vc.value_type = 'Blood Pressure'");
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('ALTER TABLE ', p_concepttab, ' ADD INDEX n_cpt_idx(non_core_concept_id)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;


END//
DELIMITER ;
