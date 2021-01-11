USE dashboards;

DROP PROCEDURE IF EXISTS populateRules;

DELIMITER //
CREATE PROCEDURE populateRules(
  IN p_query_id INT,
  IN p_selectRejects VARCHAR(600), 
  IN p_matchings VARCHAR(600), 
  IN p_queryExpressions VARCHAR(5000), 
  IN p_ruleNumbers VARCHAR(600), 
  IN p_ruleTab VARCHAR(64)
)

BEGIN

  DECLARE front VARCHAR(500) DEFAULT NULL;
  DECLARE frontlen INT DEFAULT NULL;
  DECLARE TempValue VARCHAR(500) DEFAULT NULL;
  DECLARE counter INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(p_query_id, 'populateRules', @code, @msg, now());
        RESIGNAL; -- rethrow the error
    END;

    SET counter = 1;

    SET p_selectRejects = REPLACE(p_selectRejects,',,',',NULL');
    SET p_selectRejects = REPLACE(p_selectRejects,',NULL','');

    processloop1:
    LOOP  

       IF LENGTH(TRIM(p_selectRejects)) = 0 OR p_selectRejects IS NULL THEN
         LEAVE processloop1;
       END IF;
    
      -- retrieve temp tables from comma separated list
      SET front = SUBSTRING_INDEX(p_selectRejects, ',', 1);
      SET frontlen = LENGTH(front);
      SET TempValue = TRIM(front);
      SET TempValue = UPPER(TempValue);

      SET counter = counter + 1;

              SET @sql = CONCAT('INSERT INTO ', p_ruleTab,' (id, query_id, selectReject) VALUES (', counter,',', p_query_id,',', QUOTE(TempValue),')');
              PREPARE stmt FROM @sql;
              EXECUTE stmt;
              DEALLOCATE PREPARE stmt;

    SET p_selectRejects = INSERT(p_selectRejects, 1, frontlen + 1, '');
    
    END LOOP;

    SET counter = 1;
    SET p_matchings = REPLACE(p_matchings,',,',',NULL');
    SET p_matchings = REPLACE(p_matchings,',NULL','');

    processloop2:
    LOOP  

       IF LENGTH(TRIM(p_matchings)) = 0 OR p_matchings IS NULL THEN
         LEAVE processloop2;
       END IF;
    
      -- retrieve temp tables from comma separated list
      SET front = SUBSTRING_INDEX(p_matchings, ',', 1);
      SET frontlen = LENGTH(front);
      SET TempValue = TRIM(front);
      SET TempValue = UPPER(TempValue);

      SET counter = counter + 1;

              SET @sql = CONCAT('UPDATE ', p_ruleTab,' SET matching = ', QUOTE(TempValue),' WHERE id = ', counter,' AND selectReject IS NOT NULL');
              PREPARE stmt FROM @sql;
              EXECUTE stmt;
              DEALLOCATE PREPARE stmt;

    SET p_matchings = INSERT(p_matchings, 1, frontlen + 1, '');
    
    END LOOP;

    SET counter = 1;
    SET p_queryExpressions = REPLACE(p_queryExpressions,',,',',NULL');
    SET p_queryExpressions = REPLACE(p_queryExpressions,',NULL','');

    processloop3:
    LOOP  

       IF LENGTH(TRIM(p_queryExpressions)) = 0 OR p_queryExpressions IS NULL THEN
         LEAVE processloop3;
       END IF;
    
      -- retrieve temp tables from comma separated list
      SET front = SUBSTRING_INDEX(p_queryExpressions, ',', 1);
      SET frontlen = LENGTH(front);
      SET TempValue = TRIM(front);
      SET TempValue = UPPER(TempValue);
      SET TempValue = REPLACE(REPLACE(REPLACE(TempValue,' ','{}'),'}{',''),'{}',' '); -- remove extra white spaces
      SET TempValue = REPLACE(TempValue,'( ','(');
      SET TempValue = REPLACE(TempValue,') ',')');
      SET TempValue = REPLACE(TempValue,'(',' ( ');
      SET TempValue = REPLACE(TempValue,')',' ) ');
      SET TempValue = TRIM(TempValue);

      SET counter = counter + 1;

              SET @sql = CONCAT('UPDATE ', p_ruleTab,' SET queryExpression = ', QUOTE(TempValue),' WHERE id = ', counter,' AND matching IS NOT NULL');
              PREPARE stmt FROM @sql;
              EXECUTE stmt;
              DEALLOCATE PREPARE stmt;

    SET p_queryExpressions = INSERT(p_queryExpressions, 1, frontlen + 1, '');
    
    END LOOP;

    SET counter = 1;
    SET p_ruleNumbers = REPLACE(p_ruleNumbers,',,',',NULL');
    SET p_ruleNumbers = REPLACE(p_ruleNumbers,',NULL','');

    processloop4:
    LOOP  

       IF LENGTH(TRIM(p_ruleNumbers)) = 0 OR p_ruleNumbers IS NULL THEN
         LEAVE processloop4;
       END IF;
    
      -- retrieve temp tables from comma separated list
      SET front = SUBSTRING_INDEX(p_ruleNumbers, ',', 1);
      SET frontlen = LENGTH(front);
      SET TempValue = TRIM(front);
      SET TempValue = UPPER(TempValue);

      SET counter = counter + 1;

              SET @sql = CONCAT("UPDATE ", p_ruleTab," SET ruleNumber = ", QUOTE(TempValue)," WHERE id = ", counter," AND queryExpression IS NOT NULL");
              PREPARE stmt FROM @sql;
              EXECUTE stmt;
              DEALLOCATE PREPARE stmt;

    SET p_ruleNumbers = INSERT(p_ruleNumbers, 1, frontlen + 1, '');
    
    END LOOP;


END //
DELIMITER ;
