USE dashboards;

DROP PROCEDURE IF EXISTS updateQueue;

DELIMITER //
CREATE PROCEDURE updateQueue (
    IN p_query_id INT,
    IN p_schedule VARCHAR(100)
)

BEGIN

  DECLARE nextrundate VARCHAR(255);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(p_query_id,'updateQueue',@code,@msg,now());
        RESIGNAL; -- rethrow the error
    END;

  IF p_schedule = 'Daily' THEN
      SET nextrundate = 'DATE_ADD(CURDATE(), INTERVAL 1 DAY)';
  ELSEIF p_schedule = 'Weekly' THEN
      SET nextrundate = 'DATE_ADD(CURDATE(), INTERVAL 1 WEEK)';
  ELSEIF p_schedule = 'Monthly' THEN
      SET nextrundate = 'DATE_ADD(CURDATE(), INTERVAL 1 MONTH)';
  ELSEIF p_schedule = 'Quarterly' THEN
      SET nextrundate = 'DATE_ADD(CURDATE(), INTERVAL 1 QUARTER)';
  ELSEIF p_schedule = 'One-off' THEN
      SET nextrundate = 'NULL'; 
  END IF;

  -- UPDATE queue table and reset status for next run
  SET @sql = CONCAT("UPDATE queue SET status = 'N', next_run_date = ", nextrundate," WHERE query_id = ", p_query_id);
  PREPARE stmt FROM @sql;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

END//
DELIMITER ;