USE dashboards;

DROP PROCEDURE IF EXISTS buildRegistries;

DELIMITER //

CREATE PROCEDURE buildRegistries (
    IN p_query_id INT,
    IN p_patientcohorttab VARCHAR(64)
)

BEGIN

  DECLARE parentregistry VARCHAR(500) DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(p_query_id,'buildRegistries',@code,@msg,now());
        RESIGNAL; -- rethrow the error
    END;   

  SELECT q1.name, 
         q1.registry_name, 
         q2.registry_name AS parent_registry 
         INTO @query, @registry_name, @parent_registry
  FROM query_library q1 LEFT JOIN query_library q2 ON q1.denominator_query = q2.name
  WHERE q1.id = p_query_id;

  IF @parent_registry IS NULL THEN
     SET parentregistry = NULL;
     SET @parent_registry = 'reg.parent_registry IS NULL';
  ELSE
     SET parentregistry = @parent_registry;
     SET @parent_registry = CONCAT('reg.parent_registry = ', BINARY QUOTE(@parent_registry));
  END IF;

  DROP TEMPORARY TABLE IF EXISTS qry_reg;
  SET @sql = CONCAT("CREATE TEMPORARY TABLE qry_reg AS 
  SELECT ccg, registered_practice, ods_code, COUNT(DISTINCT(patient_id)) AS registry_size 
  FROM ", p_patientcohorttab," GROUP BY ccg, registered_practice, ods_code");
  PREPARE stmt FROM @sql;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

  ALTER TABLE qry_reg ADD INDEX ods_idx(ods_code);

  -- delete previous entries if exist
  SET @sql = CONCAT("DELETE FROM registries reg 
                    WHERE reg.query = ", BINARY QUOTE(@query)," AND reg.registry = ", BINARY QUOTE(@registry_name)," AND ", @parent_registry,
                    " AND EXISTS (SELECT 1 FROM qry_reg q WHERE reg.ods_code = q.ods_code)");
  PREPARE stmt FROM @sql;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

  -- add new entries to registries
  INSERT INTO registries (registry, query, ccg, practice_name, ods_code, list_size, registry_size, updated, parent_registry) 
  SELECT @registry_name, @query, q.ccg, q.registered_practice, q.ods_code, pls.list_size, q.registry_size, now(), parentregistry 
  FROM qry_reg q LEFT JOIN practice_list_sizes pls ON q.ods_code = pls.ods_code;


END//
DELIMITER ;
