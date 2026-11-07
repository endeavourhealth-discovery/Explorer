USE dashboards;

DROP PROCEDURE IF EXISTS buildRegistries;

DELIMITER //

CREATE PROCEDURE buildRegistries (
    IN p_query_id INT,
    IN p_patientcohorttab VARCHAR(64),
    IN p_targetPercentage VARCHAR(10),
    IN p_schema VARCHAR(255),
    IN p_org_tmp VARCHAR(64) 
)

BEGIN

  DECLARE parent_registry VARCHAR(500) DEFAULT NULL;
  DECLARE parent_qry_id INT DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(p_query_id, 'buildRegistries', @code, @msg, now());
        RESIGNAL; -- rethrow the error
    END;   

  IF p_targetPercentage IS NULL OR p_targetPercentage = '' THEN
     SET @targetPercentage = NULL;
  ELSE
     SET @targetPercentage = p_targetPercentage;
  END IF;
  
  SELECT q1.name, 
         q1.registry_name, 
         q2.registry_name AS parent_registry,
         q2.id AS parent_qry_id
         INTO @query, @registry_name, parent_registry, parent_qry_id
  FROM query_library q1 LEFT JOIN query_library q2 ON q1.denominator_query = q2.name
  WHERE q1.id = p_query_id;

  IF parent_registry IS NULL THEN
     SET @parentregistry = NULL;
     SET parent_registry = 'reg.parent_registry IS NULL';
  ELSE
     SET @parentregistry = parent_registry;
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
  SET @sql = CONCAT("DELETE reg FROM registries reg WHERE reg.query = ", QUOTE(@query),
  " AND reg.registry = ", QUOTE(@registry_name)," AND ", parent_registry,
  " AND EXISTS (SELECT 1 FROM qry_reg q WHERE reg.ods_code = q.ods_code)");
  PREPARE stmt FROM @sql;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

  IF parent_qry_id IS NOT NULL THEN

    DROP TEMPORARY TABLE IF EXISTS qry_list_size;
    SET @sql = CONCAT("CREATE TEMPORARY TABLE qry_list_size AS 
    SELECT COALESCE(pd.query_id, ", parent_qry_id,") AS query_id, COALESCE(pd.ods_code, org.code) AS ods_code, COUNT(DISTINCT(pd.patient_id)) AS list_size 
    FROM ", p_org_tmp," org LEFT JOIN person_dataset pd ON pd.ods_code = org.code AND pd.query_id = ", parent_qry_id," 
    GROUP BY 1,2"); 
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

            -- add new entries to registries
          SET @sql = CONCAT(" INSERT INTO registries (registry, query, ccg, practice_name, ods_code, list_size, registry_size, updated, parent_registry, target_percentage) 
          SELECT @registry_name, @query, ", p_schema, ".getCCGName(org.id) AS CCG, ", p_schema, ".getOrganizationName(org.id) AS registered_practice, l.ods_code, l.list_size, 
          IFNULL(q.registry_size,0) AS registry_size, now(), @parentregistry, @targetPercentage  
          FROM qry_list_size l JOIN ", p_schema, ".organization org ON org.ods_code = l.ods_code 
          LEFT JOIN qry_reg q ON q.ods_code = l.ods_code");
          PREPARE stmt FROM @sql;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;      

          -- add a new entry for registry trend
          SET @sql = CONCAT(" INSERT INTO dashboard_results_0 (`grouping`, ods_code, name, series_name, series_value)
          SELECT 'registry_trend', l.ods_code , @registry_name, CURDATE(), IFNULL(q.registry_size,0)  
          FROM qry_list_size l LEFT JOIN qry_reg q ON q.ods_code = l.ods_code");
          PREPARE stmt FROM @sql;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;   

  ELSE
          -- add new entries to registries
          SET @sql = CONCAT(" INSERT INTO registries (registry, query, ccg, practice_name, ods_code, list_size, registry_size, updated, parent_registry, target_percentage) 
          SELECT @registry_name, @query, pls.ccg, pls.practice, pls.practice_ods_code, SUM(pls.list_size), IFNULL(q.registry_size,0) AS registry_size, now(), @parentregistry, @targetPercentage
          FROM population_denominators pls JOIN ", p_org_tmp ," org ON pls.practice_ods_code = org.code 
          LEFT JOIN qry_reg q ON q.ods_code = pls.practice_ods_code 
          GROUP BY @registry_name, @query, pls.ccg, pls.practice, pls.practice_ods_code, IFNULL(q.registry_size,0), now(), @parentregistry, @targetPercentage");
          PREPARE stmt FROM @sql;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;   

            -- add a new entry for registry trend
          SET @sql = CONCAT(" INSERT INTO dashboard_results_0 (`grouping`, ods_code, name, series_name, series_value)
          SELECT 'registry_trend', org.code, @registry_name, CURDATE(), IFNULL(q.registry_size,0)  
          FROM ", p_org_tmp, " org LEFT JOIN qry_reg q ON org.code = q.ods_code");
          PREPARE stmt FROM @sql;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;   
  
  END IF;

  -- remove registries duplicates if exists
  DELETE s1 FROM registries s1 JOIN registries s2 WHERE s1.id < s2.id AND s1.ods_code = s2.ods_code AND s1.registry = s2.registry;

    -- remove dashboard_results_0 duplicates if exists
  DELETE s1 FROM dashboard_results_0 s1 JOIN dashboard_results_0 s2 WHERE s1.id < s2.id AND s1.ods_code = s2.ods_code AND s1.name = s2.name AND s1.grouping = s2.grouping AND s1.series_name = s2.series_name;


END//
DELIMITER ;