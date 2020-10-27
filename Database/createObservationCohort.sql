USE dashboards;

DROP PROCEDURE IF EXISTS createObservationCohort;

DELIMITER //
CREATE PROCEDURE createObservationCohort(
   p_observationtab VARCHAR(64), 
   p_cohorttab VARCHAR(64), 
   p_schema VARCHAR(255)
   )
BEGIN

   SET @sql = CONCAT('DROP TABLE IF EXISTS ', p_observationtab);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   
   -- create an empty table
   SET @sql = CONCAT('CREATE TABLE ', p_observationtab, ' AS SELECT id, patient_id, clinical_effective_date, result_value, non_core_concept_id 
   FROM ', p_schema,'.observation LIMIT 0');

   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   DROP TEMPORARY TABLE IF EXISTS qry_tmp;
   
   -- create a temporary table to hold the observation ids
   SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp ( row_id INT, id BIGINT, primary key(row_id) ) AS 
   SELECT (@row_no := @row_no + 1) AS row_id, o.id AS id FROM ', p_cohorttab,' c JOIN ',p_schema ,'.observation o 
   ON c.patient_id = o.patient_id AND c.organization_id = o.organization_id JOIN (SELECT @row_no := 0) t');

   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @row_id = 0;
   
   WHILE EXISTS (SELECT row_id from qry_tmp WHERE row_id > @row_id AND row_id <= @row_id + 10000) DO

     SET @sql = CONCAT("INSERT INTO  ", p_observationtab, " 
     SELECT o.id, o.patient_id, o.clinical_effective_date, o.result_value, o.non_core_concept_id FROM ", p_schema,".observation o 
     JOIN qry_tmp q ON o.id = q.id WHERE q.row_id > @row_id AND q.row_id <= @row_id + 10000");

     PREPARE stmt FROM @sql;
     EXECUTE stmt;
     DEALLOCATE PREPARE stmt;

     SET @row_id = @row_id + 10000; 

   END WHILE; 

   SET @sql = CONCAT('ALTER TABLE ', p_observationtab, ' ADD INDEX pat_idx(patient_id)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('ALTER TABLE ', p_observationtab, ' ADD INDEX non_core_cpt_idx(non_core_concept_id)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('ALTER TABLE ', p_observationtab, ' ADD INDEX clinical_date_idx(clinical_effective_date)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;


END//
DELIMITER ;
