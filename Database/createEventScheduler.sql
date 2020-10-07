USE dashboards;

DELIMITER //

DROP EVENT IF EXISTS `runReportGeneratorEvery5Minutes`;

CREATE EVENT `runReportGeneratorEvery5Minutes`
ON SCHEDULE EVERY 5 MINUTE STARTS '2020-10-01 00:00:00'
ON COMPLETION PRESERVE
DO BEGIN
  CALL processReportQueue();
END //
DELIMITER ;