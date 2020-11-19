USE dashboards;

DROP PROCEDURE IF EXISTS buildRegistries;

DELIMITER //

CREATE PROCEDURE buildRegistries (
    IN p_query_id INT,
    IN p_patientcohorttab VARCHAR(64), 
    IN p_denominator VARCHAR(255),
    IN p_registryName VARCHAR(500)
)

BEGIN

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(p_query_id,'buildRegistries',@code,@msg,now());
        RESIGNAL; -- rethrow the error
    END;   

  SELECT name INTO @qry_name
  FROM query_library WHERE id = p_query_id;

  SET @sql = CONCAT("DELETE FROM registries WHERE query = ", BINARY QUOTE(@qry_name));
  PREPARE stmt FROM @sql;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

  DROP TEMPORARY TABLE IF EXISTS qry_reg;
  SET @sql = CONCAT("CREATE TEMPORARY TABLE qry_reg AS 
  SELECT ccg, registered_practice, ods_code, COUNT(DISTINCT(patient_id)) AS registry_size 
  FROM ", p_patientcohorttab," GROUP BY ccg, registered_practice, ods_code");
  PREPARE stmt FROM @sql;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

  ALTER TABLE qry_reg ADD INDEX ods_idx(ods_code);

  INSERT INTO registries (registry, query, ccg, practice_name, ods_code, list_size, registry_size, updated, parent_registry) 
  SELECT p_registryName, @qry_name, q.ccg, q.registered_practice, q.ods_code, pls.list_size, q.registry_size, now(), p_denominator 
  FROM qry_reg q LEFT JOIN practice_list_sizes pls ON q.ods_code = pls.ods_code;


END//
DELIMITER ;
