USE dashboards;

DROP PROCEDURE IF EXISTS debug_msg;

DELIMITER //

CREATE PROCEDURE debug_msg(enabled INTEGER, msg VARCHAR(255))
BEGIN

-- usage: 
 -- SET @enabled = TRUE;
 -- call debug_msg(@enabled, 'my first debug message');
 -- call debug_msg(@enabled, (select concat_ws('','arg1:', arg1)));
 -- call debug_msg(TRUE, 'This message always shows up');
 -- call debug_msg(FALSE, 'This message will never show up');

  IF enabled THEN
    SELECT CONCAT('** ', msg,' **') AS '** DEBUG:';
  END IF;
END //
DELIMITER ;