USE dashboards;


DROP PROCEDURE IF EXISTS buildQueryExpression;

DELIMITER //

CREATE PROCEDURE buildQueryExpression(
  IN p_query_id INT,
  IN p_ruleTab VARCHAR(64),
  IN p_ruleDetailTab VARCHAR(64),
  IN p_practiceChortTab VARCHAR(64)
)
BEGIN

  DECLARE done INT;
  DECLARE l_id INT;
  DECLARE l_query_id INT;
  DECLARE l_selectReject VARCHAR(30);
  DECLARE l_ruleNumber VARCHAR(20);
  DECLARE l_matching VARCHAR(30);

  DECLARE done2 INT;
  DECLARE l_id_det INT;
  DECLARE l_query_id_det INT;
  DECLARE l_rule_id_det INT; 
  DECLARE l_seq_id_det INT;
  DECLARE l_queryExpression_det VARCHAR(10);
  DECLARE l_previousExpression VARCHAR(10);

  DECLARE l_string VARCHAR(2000) DEFAULT NULL;
  DECLARE l_qryNo VARCHAR(255) DEFAULT NULL;
  DECLARE l_sql VARCHAR(2000) DEFAULT NULL;
  DECLARE l_main VARCHAR(1000) DEFAULT NULL;
  DECLARE l_tab VARCHAR(100) DEFAULT NULL;
  DECLARE inNotIn VARCHAR(20) DEFAULT NULL;

  DECLARE c_get_rules CURSOR FOR SELECT id, query_id, selectReject, matching, ruleNumber FROM qry_rules ORDER BY id ASC;
    
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(p_query_id, 'buildQueryExpression', @code, @msg, now());
        RESIGNAL; -- rethrow the error
    END;

  DROP TEMPORARY TABLE IF EXISTS qry_rules;
  SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_rules AS 
  SELECT id, query_id, selectReject, matching, ruleNumber FROM ', p_ruleTab,' WHERE query_id = ', p_query_id);
  PREPARE stmt FROM @sql;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt; 

  DROP TEMPORARY TABLE IF EXISTS qry_rule_dets;
  SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_rule_dets AS 
  SELECT id, query_id, rule_id, seq_id, queryExpression FROM ', p_ruleDetailTab,' WHERE query_id = ', p_query_id);
  PREPARE stmt FROM @sql;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt; 

  SET done = 0;

        OPEN c_get_rules;

        processRules: 
        WHILE (done = 0) DO

            FETCH c_get_rules INTO l_id, l_query_id, l_selectReject, l_matching, l_ruleNumber;

            IF done = 1 THEN 
               LEAVE processRules;
            END IF;

                IF l_selectReject = 'REGISTER' THEN
                  SET l_tab = p_practiceChortTab;
                ELSE
                  SET l_tab = 'placeholder_tmp';
                END IF;

                IF l_matching = 'MATCHING' THEN
                  SET inNotIn = ' IN ';
                ELSE
                  SET inNotIn = ' NOT IN ';
                END IF;

            BEGIN

                DECLARE c_get_dets CURSOR FOR SELECT id, query_id, rule_id, seq_id, queryExpression FROM qry_rule_dets WHERE rule_id = l_id ORDER BY id ASC;
                DECLARE CONTINUE HANDLER FOR NOT FOUND SET done2 = 1;

                SET done2 = 0;
                
                OPEN c_get_dets;

                SET l_string = ' ';
                SET l_main = CONCAT('SELECT patient_id, person_id, organization_id FROM ', l_tab,' WHERE 1 AND ');
                SET l_sql = '';
                SET l_previousExpression = '';
                SET l_qryNo = '';

                processRuleDets: 
                WHILE (done2 = 0) DO

                  FETCH c_get_dets INTO l_id_det, l_query_id_det, l_rule_id_det, l_seq_id_det, l_queryExpression_det;

                  IF done2 = 1 THEN 
                     LEAVE processRuleDets;
                  END IF;
                  
                  SET @exp = NULL;
                  SET @exp2 = NULL;
                  
                  IF  l_queryExpression_det LIKE 'Q%' THEN
                    
                        SET @sql = CONCAT('SELECT queryExpression INTO @exp FROM ', p_ruleDetailTab,' WHERE seq_id = ', l_seq_id_det + 1,' AND rule_id = ',l_rule_id_det);
                        PREPARE stmt FROM @sql;
                        EXECUTE stmt;
                        DEALLOCATE PREPARE stmt;   

                              IF l_seq_id_det = 1 THEN

                                    IF @exp = 'AND' OR @exp IS NULL OR @exp = 'OR' THEN
                                          SET l_sql = CONCAT(l_main,' patient_id', inNotIn,' (SELECT patient_id FROM ', l_queryExpression_det,'_',l_query_id,')');
                                          SET l_string = CONCAT(l_string, l_sql);
                                    ELSE
                                          SET l_sql = CONCAT(l_main,' ( patient_id ', inNotIn,' (SELECT patient_id FROM ', l_queryExpression_det,'_',l_query_id,')');
                                          SET l_string = CONCAT(l_string, l_sql);
                                    END IF;

                              ELSEIF l_seq_id_det > 1 THEN

                                    IF l_previousExpression = 'OR' AND @exp IS NULL THEN
                                    
                                          SET @sql = CONCAT('SELECT queryExpression INTO @exp2 FROM ', p_ruleDetailTab,' WHERE seq_id = ', l_seq_id_det - 2,' AND rule_id = ',l_rule_id_det);
                                          PREPARE stmt FROM @sql;
                                          EXECUTE stmt;
                                          DEALLOCATE PREPARE stmt;   
                                    
                                          IF @exp2 = ')' THEN
                                                SET l_sql = CONCAT(' patient_id ', inNotIn,' (SELECT patient_id FROM ', l_queryExpression_det,'_',l_query_id,')');
                                                SET l_string = CONCAT(l_string, l_sql);  
                                          ELSEIF @exp IS NULL THEN
                                                SET l_sql = CONCAT(' patient_id ', inNotIn,' (SELECT patient_id FROM ', l_queryExpression_det,'_',l_query_id,')');
                                                SET l_string = CONCAT(l_string, l_sql);  
                                          ELSE
                                                SET l_sql = CONCAT(' patient_id ', inNotIn,' (SELECT patient_id FROM ', l_queryExpression_det,'_',l_query_id,') )');
                                                SET l_string = CONCAT(l_string, l_sql);  
                                          END IF;
                                    ELSE
                                          SET l_sql = CONCAT(' patient_id ', inNotIn,' (SELECT patient_id FROM ', l_queryExpression_det,'_',l_query_id,')');
                                          SET l_string = CONCAT(l_string, l_sql);  
                                    END IF;

                              END IF;

                              -- build qry number list
                              SET l_qryNo =  CONCAT(l_qryNo, SUBSTRING(l_queryExpression_det,2) );        
                              SET l_qryNo =  CONCAT(l_qryNo,CASE WHEN LENGTH(l_qryNo)>0 THEN ',' ELSE '' END);
  
                  ELSEIF  l_queryExpression_det = 'AND' THEN
                         SET l_string = CONCAT(l_string, ' AND ');
                  ELSEIF  l_queryExpression_det = 'OR' THEN
                         SET l_string = CONCAT(l_string, ' OR ');
                  ELSEIF  l_queryExpression_det = '(' THEN

                        IF l_seq_id_det  = 1 THEN  
                           SET l_string = CONCAT(l_string, l_main, ' ( ');
                        ELSE
                           SET l_string = CONCAT(l_string, ' ( ');
                        END IF;
                         
                  ELSEIF  l_queryExpression_det = ')' THEN
                        SET l_string = CONCAT(l_string, ' ) ');
                  END IF;
    
                  SET l_previousExpression = l_queryExpression_det;

                END WHILE processRuleDets;
                CLOSE c_get_dets;
                SET done2 = 0;

            END;

              -- remove the last comma in the string
              SET l_qryNo = SUBSTRING(l_qryNo, 1, LENGTH(l_qryNo)-1);

              SET @sql = CONCAT('UPDATE ', p_ruleTab,' SET query = ', QUOTE(l_string),' , queryNumber = ', QUOTE(l_qryNo),' WHERE id = ', l_id);
              PREPARE stmt FROM @sql;
              EXECUTE stmt;
              DEALLOCATE PREPARE stmt; 

        END WHILE processRules;
        CLOSE c_get_rules;
        SET done = 0;

END //
DELIMITER ;