USE dashboards;

DROP PROCEDURE IF EXISTS buildObservationCohort;

DELIMITER //
CREATE PROCEDURE buildObservationCohort (
    IN p_query_id INT,
    IN p_observationCohortTab VARCHAR(64), 
    IN p_queryCohort VARCHAR(64), 
    IN p_concepttab VARCHAR(64), 
    IN p_schema VARCHAR(255)
    )

BEGIN

DECLARE l_sql  VARCHAR(255) DEFAULT NULL;
DECLARE i INT;
DECLARE n INT;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(p_query_id, 'buildObservationCohort', @code, @msg, now());
        RESIGNAL; -- rethrow the error
    END;

      DROP TEMPORARY TABLE IF EXISTS datatype_tmp;
         
      SET @sql = CONCAT('CREATE TEMPORARY TABLE datatype_tmp AS 
      SELECT DISTINCT data_type FROM ', p_concepttab );
      PREPARE stmt FROM @sql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;    

      SELECT COUNT(data_type) INTO n FROM datatype_tmp;

      SET l_sql = '';
      SET i = 0;
      WHILE i < n DO 
        SET l_sql =  CONCAT(BINARY l_sql, (SELECT q.data_type FROM datatype_tmp q LIMIT i, 1));        
        SET l_sql =  CONCAT(BINARY l_sql, CASE WHEN LENGTH(l_sql)>0 THEN ',' ELSE '' END);
        SET i = i + 1;
      END WHILE;
      -- remove the last comma in the string
      SET l_sql = SUBSTRING(l_sql, 1, LENGTH(l_sql)-1);

      CALL createObservationCohort(p_query_id, p_observationCohortTab, p_queryCohort, p_concepttab, p_schema, l_sql);

END//
DELIMITER ;
