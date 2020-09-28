USE dashboards;

DROP PROCEDURE IF EXISTS storeString;

DELIMITER //
CREATE PROCEDURE storeString (
    IN stringValue VARCHAR(10000)
)

BEGIN

   DECLARE front       VARCHAR(5000) DEFAULT NULL;
   DECLARE frontlen    INT           DEFAULT NULL;
   DECLARE TempValue   VARCHAR(5000) DEFAULT NULL;

   DROP TABLE IF EXISTS store;
   CREATE TABLE store (id INT NOT NULL AUTO_INCREMENT,
                       code VARCHAR(255), 
                       PRIMARY KEY (id));
                                 
   ALTER TABLE store ADD INDEX code_idx(code);

    processloop:
    LOOP  
       IF LENGTH(TRIM(stringValue)) = 0 OR stringValue IS NULL THEN
         LEAVE processloop;
       END IF;

    SET front = SUBSTRING_INDEX(stringValue, ',', 1);
    SET frontlen = LENGTH(front);
    SET TempValue = TRIM(front);

       INSERT INTO store (code) 
       SELECT TempValue; 

    SET stringValue = INSERT(stringValue, 1, frontlen + 1, '');
    END LOOP;

    -- remove duplicates if exists
    DELETE s1 FROM store s1
    INNER JOIN store s2 
    WHERE s1.id > s2.id 
    AND s1.code = s2.code;


END//
DELIMITER ;