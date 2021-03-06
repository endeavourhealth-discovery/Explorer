USE dashboards;

DROP PROCEDURE IF EXISTS getValueSetString;

DELIMITER //
CREATE PROCEDURE getValueSetString(p_value VARCHAR(1000), p_storetab VARCHAR(64), OUT p_valueString VARCHAR(255))

BEGIN
  
   CALL storeString(p_value, p_storetab);

   SET p_valueString = CONCAT('EXISTS (SELECT 1 FROM ', p_storetab,' s WHERE s.code = vsc.type)');

END//
DELIMITER ;


