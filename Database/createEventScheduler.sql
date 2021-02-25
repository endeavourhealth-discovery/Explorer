USE dashboards;

DROP EVENT IF EXISTS `runReportGeneratorEveryMinute`;

DELIMITER //

CREATE EVENT `runReportGeneratorEveryMinute`
ON SCHEDULE EVERY 1 MINUTE STARTS '2020-10-01 00:00:00'
ON COMPLETION PRESERVE
DO BEGIN
  -- add schema name in <schema name>
  CALL processReportQueue('<schema name>', FALSE);
END //
DELIMITER ;