USE dashboards;

DELIMITER //

DROP EVENT IF EXISTS `runReportGeneratorEvery1Minute`;

CREATE EVENT `runReportGeneratorEvery1Minute`
ON SCHEDULE EVERY 1 MINUTE STARTS '2020-10-01 00:00:00'
ON COMPLETION PRESERVE
DO BEGIN
  CALL processReportQueue();
END //
DELIMITER ;