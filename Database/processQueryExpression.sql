USE dashboards;

DROP PROCEDURE IF EXISTS processQueryExpression;

DELIMITER //

CREATE PROCEDURE processQueryExpression(
  IN p_query_id INT,
  IN jsonQuery JSON,
  IN p_ruleTab VARCHAR(64),
  IN p_practiceChortTab VARCHAR(64),
  IN p_registerCohortTab VARCHAR(64),
  IN p_observationCohort_tmp VARCHAR(64), 
  IN p_store_tmp VARCHAR(64),
  IN p_conceptAllTab VARCHAR(64), 
  IN p_schema VARCHAR(255),
  IN p_baselineDate VARCHAR(30),
  IN enabled INTEGER
)

BEGIN

  DECLARE done INT;
  DECLARE l_id INT;
  DECLARE l_query_id INT;
  DECLARE l_selectReject VARCHAR(30);
  DECLARE l_ruleNumber VARCHAR(20);
  DECLARE l_matching VARCHAR(30);
  DECLARE l_query VARCHAR(2000);
  DECLARE l_queryNumber VARCHAR(255);

  DECLARE l_cohort VARCHAR(64) DEFAULT NULL;
  DECLARE l_selecttab VARCHAR(64) DEFAULT NULL;
  DECLARE l_rejecttab VARCHAR(64) DEFAULT NULL;
  DECLARE l_observationtab VARCHAR(64) DEFAULT NULL;

  DECLARE counter INT DEFAULT 0;
  DECLARE l_tmp VARCHAR(1000) DEFAULT NULL;

  DECLARE front VARCHAR(500) DEFAULT NULL;
  DECLARE frontlen INT DEFAULT NULL;
  DECLARE TempValue VARCHAR(500) DEFAULT NULL;

  DECLARE c_get_rules CURSOR FOR SELECT id, query_id, selectReject, matching, ruleNumber, query, queryNumber FROM qry_rules ORDER BY id ASC;
    
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(p_query_id, 'processQueryExpression', @code, @msg, now());
        RESIGNAL; -- rethrow the error
    END;

  DROP TEMPORARY TABLE IF EXISTS qry_rules;
  SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_rules AS 
  SELECT id, query_id, selectReject, matching, ruleNumber, query, queryNumber FROM ', p_ruleTab);
  PREPARE stmt FROM @sql;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt; 

  SET done = 0;

    OPEN c_get_rules;

    SET counter = 0;
    SET l_tmp = '';

    processQueryExpression: 
    WHILE (done = 0) DO

    FETCH c_get_rules INTO l_id, l_query_id, l_selectReject, l_matching, l_ruleNumber, l_query, l_queryNumber;

          IF done = 1 THEN 
              LEAVE processQueryExpression;
          END IF;

          SET counter = counter + 1;

          IF l_id = 1 THEN
            SET l_cohort = p_practiceChortTab;
          END IF;

              processloop:
              LOOP  

                  IF LENGTH(TRIM(l_queryNumber)) = 0 OR l_queryNumber IS NULL THEN
                        LEAVE processloop;
                  END IF;

                  -- retrieve the query number from the comma separated list
                  SET front = SUBSTRING_INDEX(l_queryNumber, ',', 1);
                  SET frontlen = LENGTH(front);
                  SET TempValue = TRIM(front); 

                  IF l_id = 1 AND l_selectReject = 'REGISTER' THEN

                        SET l_observationtab = CONCAT(p_schema,'.observation');
                        CALL queryBuilder(l_query_id, jsonQuery, TempValue, l_cohort, l_observationtab, p_store_tmp, p_conceptAllTab, p_schema, p_baselineDate, 1);

                  ELSE 
                        SET l_observationtab = p_observationCohort_tmp;
                        CALL queryBuilder(l_query_id, jsonQuery, TempValue, l_cohort, l_observationtab, p_store_tmp, NULL, p_schema, p_baselineDate, 2);

                  END IF;                  

                  -- fetch the next query number
                  SET l_queryNumber = INSERT(l_queryNumber, 1, frontlen + 1, '');

              END LOOP;

        IF l_id = 1 AND l_selectReject = 'REGISTER' THEN  -- create the register cohort

          SET l_selecttab = NULL;
          SET l_rejecttab = NULL;

          SET l_selecttab = p_registerCohortTab;

          SET @sql = CONCAT('DROP TABLE IF EXISTS ', l_selecttab);
          PREPARE stmt FROM @sql;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;

          SET @sql = CONCAT('CREATE TABLE ', l_selecttab,' AS ', l_query);
          PREPARE stmt FROM @sql;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;

          SET @sql = CONCAT('UPDATE ', p_ruleTab,' SET queryTable = ', QUOTE(l_selecttab),' , selectTable = ', QUOTE(l_selecttab),' WHERE id  =  ', l_id,' AND query_id = ', l_query_id);
          PREPARE stmt FROM @sql;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;

          SET l_cohort = l_selecttab;

          SET @cnt = 0;
          SET @sql = CONCAT('SELECT COUNT(*) INTO @cnt FROM ', p_ruleTab);
          PREPARE stmt FROM @sql;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt; 

          IF @cnt > 1 THEN 
            -- build observation cohort 
            CALL createObservationCohort(l_query_id, p_observationCohort_tmp, l_selecttab, p_conceptAllTab, p_schema);
          END IF;

        ELSEIF l_id > 1 AND l_selectReject IN ('SELECT', 'REJECT') THEN

          SET l_selecttab = NULL;
          SET l_rejecttab = NULL;

          SET @queryTable = NULL;
            
            -- check rule number 
            IF LENGTH(TRIM(l_ruleNumber)) = 0 OR l_ruleNumber IS NULL THEN
              SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Rule number not found';
              CALL log_errors(l_query_id, 'processQueryExpression', '45000', MESSAGE_TEXT, now());
              RESIGNAL; -- rethrow the error
            ELSEIF SUBSTRING(l_ruleNumber,2) >= l_id THEN
              SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Rule number cannot be the same as or greater than the rule';
              CALL log_errors(l_query_id, 'processQueryExpression', '45000', MESSAGE_TEXT, now());
              RESIGNAL; -- rethrow the error
            END IF;

          SET @sql = CONCAT('SELECT queryTable INTO @queryTable FROM ', p_ruleTab,' WHERE id = SUBSTRING(', QUOTE(l_ruleNumber),',2)');
          PREPARE stmt FROM @sql;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;

          SET l_query = REPLACE(l_query,'placeholder_tmp', @queryTable);

            IF l_selectReject = 'SELECT' THEN

                SET l_selecttab = CONCAT('select_tmp_', l_id,'_', l_query_id);
            
                SET @sql = CONCAT('DROP TABLE IF EXISTS ', l_selecttab);
                PREPARE stmt FROM @sql;
                EXECUTE stmt;
                DEALLOCATE PREPARE stmt;

                SET @sql = CONCAT('CREATE TABLE ', l_selecttab,' AS ', l_query);
                PREPARE stmt FROM @sql;
                EXECUTE stmt;
                DEALLOCATE PREPARE stmt;   

            ELSEIF l_selectReject = 'REJECT' THEN

                DROP TEMPORARY TABLE IF EXISTS qry_tmp;

                SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp AS ', l_query);
                PREPARE stmt FROM @sql;
                EXECUTE stmt;
                DEALLOCATE PREPARE stmt;   

                SET l_selecttab = 'qry_tmp';

            END IF;

                SET l_rejecttab = CONCAT('reject_tmp_', l_id,'_', l_query_id);
                SET l_cohort = l_rejecttab;

                SET @sql = CONCAT('DROP TABLE IF EXISTS ', l_rejecttab);
                PREPARE stmt FROM @sql;
                EXECUTE stmt;
                DEALLOCATE PREPARE stmt;          

                SET @sql = CONCAT('CREATE TABLE ', l_rejecttab,' AS 
                SELECT patient_id, person_id, organization_id , date_registered, age, date_of_birth, date_of_death FROM ', @queryTable,'  
                WHERE patient_id NOT IN (SELECT patient_id FROM ', l_selecttab,' )');
                PREPARE stmt FROM @sql;
                EXECUTE stmt;
                DEALLOCATE PREPARE stmt;   

                IF l_selectReject = 'SELECT' THEN

                      SET @sql = CONCAT('UPDATE ', p_ruleTab,' SET queryTable = ', QUOTE(l_rejecttab),' , selectTable = ', QUOTE(l_selecttab),' WHERE id  =  ', l_id,' AND query_id = ', l_query_id);
                      PREPARE stmt FROM @sql;
                      EXECUTE stmt;
                      DEALLOCATE PREPARE stmt;

                      SET l_tmp = CONCAT(l_tmp, l_rejecttab);
                      SET l_tmp = CONCAT(l_tmp, CASE WHEN LENGTH(l_rejecttab)>0 THEN ',' ELSE '' END);

                ELSEIF l_selectReject = 'REJECT' THEN

                      SET @sql = CONCAT('UPDATE ', p_ruleTab,' SET queryTable = ', QUOTE(l_rejecttab),' , selectTable = NULL WHERE id  =  ', l_id,' AND query_id = ', l_query_id);
                      PREPARE stmt FROM @sql;
                      EXECUTE stmt;
                      DEALLOCATE PREPARE stmt;

                      SET l_tmp = CONCAT(l_tmp, l_rejecttab);
                      SET l_tmp = CONCAT(l_tmp, CASE WHEN LENGTH(l_rejecttab)>0 THEN ',' ELSE '' END);

                END IF;

        END IF;

    END WHILE processQueryExpression;
    CLOSE c_get_rules;
    SET done = 0;

    -- clean up tmp tables
    SET l_tmp = SUBSTRING(l_tmp, 1, LENGTH(l_tmp)-1);
    IF enabled = 0 THEN 
      CALL dropTempTables(l_tmp);
    END IF;

END //
DELIMITER ;