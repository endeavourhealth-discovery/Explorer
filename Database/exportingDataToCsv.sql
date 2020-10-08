USE dashboards;

DROP PROCEDURE IF EXISTS exportingDataToCsv;

DELIMITER //

CREATE PROCEDURE exportingDataToCsv (
  p_outputtab VARCHAR(64)
)

BEGIN

DECLARE ts VARCHAR(100);
DECLARE folder VARCHAR(255);
DECLARE prefix VARCHAR(64);
DECLARE extension VARCHAR(50);

SET ts = DATE_FORMAT(NOW(),'_%Y_%m_%d_%H_%i_%s');
SET folder = 'c:/tmp/'; -- or '\tmp\';  -- linux location
SET prefix = p_outputtab;
SET extension = '.csv';

-- add header
SET @sql = CONCAT('SELECT GROUP_CONCAT(CONCAT("''','",COLUMN_NAME,"','''" ),"\n") 
INTO @header FROM information_schema.columns WHERE table_name = ', QUOTE(p_outputtab), ' ORDER BY ordinal_position');

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- create csv
SET @sql = CONCAT("SELECT ", BINARY @header," UNION ALL SELECT * FROM ", p_outputtab," INTO OUTFILE '", folder, prefix, ts, extension,
				   "' FIELDS ENCLOSED BY '\"' TERMINATED BY ',' ESCAPED BY '\"'",
				   "  LINES TERMINATED BY '\r\n';");

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


END //
DELIMITER ;