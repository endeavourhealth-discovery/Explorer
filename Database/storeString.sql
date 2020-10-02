USE dashboards;

DROP PROCEDURE IF EXISTS storeString;

DELIMITER //
CREATE PROCEDURE storeString (
    IN stringValue VARCHAR(10000),
    IN p_storetab VARCHAR(64)
)

BEGIN

   DECLARE front       VARCHAR(5000) DEFAULT NULL;
   DECLARE frontlen    INT           DEFAULT NULL;
   DECLARE TempValue   VARCHAR(5000) DEFAULT NULL;

   SET @sql = CONCAT('DROP TABLE IF EXISTS ', p_storetab);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @sql = CONCAT('CREATE TABLE ', p_storetab,' (id INT NOT NULL AUTO_INCREMENT, 
   code VARCHAR(255), PRIMARY KEY (id))');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
                                 
   SET @sql = CONCAT('ALTER TABLE ', p_storetab,' ADD INDEX code_idx(code)');
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

    processloop:
    LOOP  
       IF LENGTH(TRIM(stringValue)) = 0 OR stringValue IS NULL THEN
         LEAVE processloop;
       END IF;

    SET front = SUBSTRING_INDEX(stringValue, ',', 1);
    SET frontlen = LENGTH(front);
    SET TempValue = TRIM(front);

       SET @sql = CONCAT('INSERT INTO ', p_storetab,' (code) SELECT ', QUOTE(TempValue) );
       PREPARE stmt FROM @sql;
       EXECUTE stmt;
       DEALLOCATE PREPARE stmt;

    SET stringValue = INSERT(stringValue, 1, frontlen + 1, '');
    END LOOP;

    -- remove duplicates if exists
    SET @sql = CONCAT('DELETE s1 FROM ', p_storetab,' s1 
    INNER JOIN ', p_storetab,' s2 WHERE s1.id > s2.id AND s1.code = s2.code');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

END//
DELIMITER ;