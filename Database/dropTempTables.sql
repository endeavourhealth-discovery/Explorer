USE dashboards;

DROP PROCEDURE IF EXISTS dropTempTables;

DELIMITER //

CREATE PROCEDURE dropTempTables (
  p_tempString VARCHAR(5000)
)
BEGIN

  DECLARE front VARCHAR(500) DEFAULT NULL;
  DECLARE frontlen INT DEFAULT NULL;
  DECLARE TempValue VARCHAR(500) DEFAULT NULL;

    processloop:
    LOOP  

       IF LENGTH(TRIM(p_tempString)) = 0 OR p_tempString IS NULL THEN
         LEAVE processloop;
       END IF;

      -- retrieve temp tables from comma separated list
      SET front = SUBSTRING_INDEX(p_tempString, ',', 1);
      SET frontlen = LENGTH(front);
      SET TempValue = TRIM(front);

              SET @sql = CONCAT('DROP TABLE IF EXISTS `', TempValue,'`');

              PREPARE stmt FROM @sql;
              EXECUTE stmt;
              DEALLOCATE PREPARE stmt;

    SET p_tempString = INSERT(p_tempString, 1, frontlen + 1, '');
    
    END LOOP;

END //
DELIMITER ;