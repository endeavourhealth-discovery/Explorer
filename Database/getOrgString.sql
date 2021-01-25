USE dashboards;

DROP PROCEDURE IF EXISTS getOrgString;

DELIMITER //
CREATE PROCEDURE getOrgString(IN p_org VARCHAR(1000), IN p_org_tab_name VARCHAR(64), IN p_storetab VARCHAR(64), OUT p_orgstring VARCHAR(255))
BEGIN

   CALL storeString(p_org, p_storetab);
   

   SET @sql = CONCAT('DROP TABLE IF EXISTS ', p_org_tab_name);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT("CREATE TABLE ", p_org_tab_name," AS 
   SELECT org.ods_code 
   FROM organisation_groups org_grp 
   JOIN organisations org ON org_grp.id = org.organisation_group_id 
   WHERE EXISTS (SELECT 1 FROM ", p_storetab," s WHERE s.code = UPPER(org_grp.name))");

   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT("ALTER TABLE ", p_org_tab_name, " ADD INDEX ods_idx(ods_code)");
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET p_orgstring = CONCAT('EXISTS (SELECT 1 FROM ', p_org_tab_name,' ot WHERE ot.ods_code = org.ods_code)');

END//
DELIMITER ;