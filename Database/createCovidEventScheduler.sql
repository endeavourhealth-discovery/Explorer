-- use appropriate database

USE nwl_subscriber_pid;
USE internal_nel_gp_pid;
USE internal_sel_gp_pid;

DROP EVENT IF EXISTS `runCovidDashboardsEveryDay`;

DELIMITER //

CREATE EVENT `runCovidDashboardsEveryDay`
ON SCHEDULE EVERY 1 DAY STARTS '2021-06-10 00:00:00'
ON COMPLETION PRESERVE
DO BEGIN
  CALL covid_dashboards_summary(1);
END //
DELIMITER ;