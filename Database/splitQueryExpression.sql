USE dashboards;


DROP PROCEDURE IF EXISTS splitQueryExpression;

DELIMITER //

CREATE PROCEDURE splitQueryExpression(
  IN p_query_id INT,
  IN p_ruleTab VARCHAR(64),
  IN p_ruleDetailTab VARCHAR(64)
)
BEGIN

  DECLARE done            INT;
  DECLARE l_id            INT;
  DECLARE l_query_id      INT;
  DECLARE l_selectReject  VARCHAR(30);
  DECLARE l_matching      VARCHAR(30);
  DECLARE l_queryExpression VARCHAR(255);
  DECLARE insFlag         VARCHAR(1) DEFAULT NULL;

  DECLARE front VARCHAR(500) DEFAULT NULL;
  DECLARE frontlen INT DEFAULT NULL;
  DECLARE TempValue VARCHAR(500) DEFAULT NULL;
  DECLARE counter INT DEFAULT 0;
  DECLARE seqCounter INT DEFAULT 0;
  DECLARE l_expression VARCHAR(10) DEFAULT NULL;
  DECLARE l_rule_id INT DEFAULT 0;

  DECLARE c_get_rules CURSOR FOR SELECT id, query_id, queryExpression FROM qry_tmp ORDER BY id ASC;
    
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(p_query_id,'splitQueryExpression', @code, @msg, now());
        RESIGNAL; -- rethrow the error
    END;

  DROP TEMPORARY TABLE IF EXISTS qry_tmp;

  SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp AS 
  SELECT id, query_id, queryExpression FROM ', p_ruleTab);
  PREPARE stmt FROM @sql;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt; 

  SET @sql = CONCAT("DROP TABLE IF EXISTS ", p_ruleDetailTab);
  PREPARE stmt FROM @sql;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

  SET @sql = CONCAT("CREATE TABLE ", p_ruleDetailTab," ( 
  id INT(11) NOT NULL, query_id INT(11), rule_id INT(11), seq_id INT, queryExpression VARCHAR(10),
  PRIMARY KEY (id)) ENGINE=InnoDB DEFAULT CHARSET=latin1");
  PREPARE stmt FROM @sql;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt; 

  SET done = 0;

        OPEN c_get_rules;

        processloop1: 
        WHILE (done = 0) DO

             FETCH c_get_rules INTO l_id, l_query_id, l_queryExpression;

             IF done = 1 THEN 
                  LEAVE processloop1;
             END IF;

             IF LENGTH(TRIM(l_queryExpression)) = 0 OR l_queryExpression IS NULL THEN
                 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Query expression not found';
                 CALL log_errors(l_query_id,'splitQueryExpression', '45000', MESSAGE_TEXT, now());
                 RESIGNAL; -- rethrow the error
             END IF;

                SET insFlag = NULL;

                processloop2:
                LOOP  

                     IF LENGTH(TRIM(l_queryExpression)) = 0 OR l_queryExpression IS NULL THEN
                              LEAVE processloop2;
                     END IF;
                     
                     -- split up the query expression and store each element into a table
                     SET front = SUBSTRING_INDEX(l_queryExpression, ' ', 1);
                     SET frontlen = LENGTH(front);
                     SET TempValue = TRIM(front);
                     SET TempValue = UPPER(TempValue);

                     IF TempValue IN ('AND','OR','(',')') OR TempValue Like 'Q%' THEN 
                        SET l_expression = QUOTE(TempValue);
                        SET insFlag = 'Y';
                     ELSE
                        SET insFlag = 'N';
                     END IF;

                     IF insFlag = 'Y' THEN

                           IF l_id != l_rule_id THEN
                             SET seqCounter = 0;
                           END IF;

                           SET counter = counter + 1;

                           SET seqCounter = seqCounter + 1;

                           SET @sql = CONCAT("INSERT INTO ", p_ruleDetailTab," VALUES ( ", counter,", ", p_query_id,", ", l_id,", ", seqCounter,",",l_expression," )");
                           PREPARE stmt FROM @sql;
                           EXECUTE stmt;
                           DEALLOCATE PREPARE stmt;

                     END IF;

                     SET l_rule_id = l_id;

                     SET l_queryExpression = INSERT(l_queryExpression, 1, frontlen + 1, '');
                
                END LOOP;

        END WHILE processloop1;
        CLOSE c_get_rules;
        SET done = 0;

END //
DELIMITER ;
