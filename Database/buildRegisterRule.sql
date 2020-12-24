USE dashboards;

DROP PROCEDURE IF EXISTS buildRegisterRule;

DELIMITER //
CREATE PROCEDURE buildRegisterRule(
  IN p_query_id INT,
  IN p_matching VARCHAR(600), 
  IN p_queryExpression VARCHAR(5000),  
  IN p_ruleTab VARCHAR(64)
)

BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(p_query_id,'buildRegisterRule', @code, @msg, now());
        RESIGNAL; -- rethrow the error
    END;

    SET p_matching = UPPER(p_matching);
    SET p_queryExpression = UPPER(p_queryExpression);
    SET p_queryExpression = REPLACE(REPLACE(REPLACE(p_queryExpression,' ','{}'),'}{',''),'{}',' '); -- remove extra white spaces
    SET p_queryExpression = REPLACE(p_queryExpression,'( ','(');
    SET p_queryExpression = REPLACE(p_queryExpression,') ',')');
    SET p_queryExpression = REPLACE(p_queryExpression,'(',' ( ');
    SET p_queryExpression = REPLACE(p_queryExpression,')',' ) ');
    SET p_queryExpression = TRIM(p_queryExpression);

    SET @sql = CONCAT('DROP TABLE IF EXISTS ', p_ruleTab);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt; 

    SET @sql = CONCAT('CREATE TABLE ', p_ruleTab,' ( 
    id INT(11) NOT NULL, query_id INT(11) NOT NULL, selectReject VARCHAR(30), 
    matching VARCHAR(30), queryExpression VARCHAR(255), ruleNumber VARCHAR(20), query VARCHAR(1000), queryNumber VARCHAR(255), queryTable VARCHAR(64), selectTable VARCHAR(64), 
    PRIMARY KEY (id)) ENGINE=InnoDB DEFAULT CHARSET=latin1');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt; 
    
    -- insert a record into the temporary rule table
    SET @sql = CONCAT("INSERT INTO ", p_ruleTab," (id, query_id, selectReject, matching, queryExpression) 
    VALUES ( 1 ",",", p_query_id,", 'REGISTER', ", QUOTE(p_matching),", ", QUOTE(p_queryExpression),") ");
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

END //
DELIMITER ;
