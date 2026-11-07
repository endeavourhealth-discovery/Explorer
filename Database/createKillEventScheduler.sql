USE dashboards;

DROP EVENT IF EXISTS `runKillProcessEveryMinute`;

DELIMITER //

CREATE EVENT `runKillProcessEveryMinute`
ON SCHEDULE EVERY 1 MINUTE STARTS '2020-10-01 00:00:00'
ON COMPLETION PRESERVE
DO BEGIN
  CALL kill_process_proc();
END //
DELIMITER ;