USE dashboards;

DELIMITER //

DROP EVENT IF EXISTS `runReportGeneratorEveryMinute`;

CREATE EVENT `runReportGeneratorEveryMinute`
ON SCHEDULE EVERY 1 MINUTE STARTS '2020-10-01 00:00:00'
ON COMPLETION PRESERVE
DO BEGIN
  CALL processReportQueue();
END //
DELIMITER ;