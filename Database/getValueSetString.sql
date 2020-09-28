USE dashboards;

DROP PROCEDURE IF EXISTS getValueSetString;

DELIMITER //
CREATE PROCEDURE getValueSetString(p_value VARCHAR(1000), OUT p_valueString VARCHAR(255))

BEGIN
  
   CALL storeString(p_value);

   SET p_valueString = "EXISTS (SELECT 1 FROM store s WHERE vs.name LIKE CONCAT(s.code,'%'))";

END//
DELIMITER ;


