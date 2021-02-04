USE dashboards;

DROP PROCEDURE IF EXISTS buildRegistries;

DELIMITER //

CREATE PROCEDURE buildRegistries (
    IN p_query_id INT,
    IN p_patientcohorttab VARCHAR(64),
    IN p_targetPercentage VARCHAR(10)
)

BEGIN

  DECLARE parentregistry VARCHAR(500) DEFAULT NULL;
  DECLARE targetPercentage VARCHAR(10) DEFAULT NULL;

  DECLARE query VARCHAR(500) DEFAULT NULL;
  DECLARE registry_name VARCHAR(500) DEFAULT NULL;
  DECLARE parent_registry VARCHAR(500) DEFAULT NULL;
  DECLARE parent_qry_id INT DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(p_query_id,'buildRegistries', @code, @msg, now());
        RESIGNAL; -- rethrow the error
    END;   

  IF p_targetPercentage IS NULL OR p_targetPercentage = '' THEN
     SET targetPercentage = NULL;
  ELSE
     SET targetPercentage = p_targetPercentage;
  END IF;
  
  SELECT q1.name, 
         q1.registry_name, 
         q2.registry_name AS parent_registry,
         q2.id AS parent_qry_id
         INTO query, registry_name, parent_registry, parent_qry_id
  FROM query_library q1 LEFT JOIN query_library q2 ON q1.denominator_query = q2.name
  WHERE q1.id = p_query_id;

  IF parent_registry IS NULL THEN
     SET parentregistry = NULL;
     SET parent_registry = 'reg.parent_registry IS NULL';
  ELSE
     SET parentregistry = parent_registry;
     SET parent_registry = CONCAT('reg.parent_registry = ', QUOTE(parent_registry));
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
  SET @sql = CONCAT("DELETE reg FROM registries reg 
                    WHERE reg.query = ", QUOTE(query)," AND reg.registry = ", QUOTE(registry_name)," AND ", parent_registry,
                    " AND EXISTS (SELECT 1 FROM qry_reg q WHERE reg.ods_code = q.ods_code)");
  PREPARE stmt FROM @sql;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

  IF parent_qry_id IS NOT NULL THEN

    DROP TEMPORARY TABLE IF EXISTS qry_list_size;
    SET @sql = CONCAT("CREATE TEMPORARY TABLE qry_list_size AS 
    SELECT pd.query_id, COUNT(DISTINCT(pd.patient_id)) AS list_size 
    FROM person_dataset pd WHERE EXISTS (SELECT 1 FROM query_library q WHERE q.id = pd.query_id) 
    AND pd.query_id = ", parent_qry_id," GROUP BY pd.query_id" ); 
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @list_size = NULL;

    SELECT list_size INTO @list_size FROM qry_list_size;

            -- add new entries to registries
          INSERT INTO registries (registry, query, ccg, practice_name, ods_code, list_size, registry_size, updated, parent_registry, target_percentage) 
          SELECT registry_name, query, q.ccg, q.registered_practice, q.ods_code, @list_size, q.registry_size, now(), parentregistry, targetPercentage  
          FROM qry_reg q;
  ELSE
          -- add new entries to registries
          INSERT INTO registries (registry, query, ccg, practice_name, ods_code, list_size, registry_size, updated, parent_registry, target_percentage) 
          SELECT registry_name, query, q.ccg, q.registered_practice, q.ods_code, MAX(pls.list_size), q.registry_size, now(), parentregistry, targetPercentage  
          FROM qry_reg q LEFT JOIN practice_list_sizes pls ON q.ods_code = pls.ods_code GROUP BY registry_name, query, q.ccg, q.registered_practice, q.ods_code, q.registry_size, now(), parentregistry, targetPercentage;
  END IF;

  -- add a new entry for registry trend
  INSERT INTO dashboard_results_0 (`grouping`, name, series_name, series_value)
  SELECT 'registry_trend', CONCAT(UPPER(q.registered_practice),' (', q.ods_code,') - ', registry_name), curdate(), q.registry_size 
  FROM qry_reg q;


END//
DELIMITER ;
