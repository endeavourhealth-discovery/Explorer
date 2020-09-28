USE dashboards;

DROP FUNCTION IF EXISTS getGenderString;

DELIMITER //
CREATE FUNCTION getGenderString(p_gender VARCHAR(20)) 
RETURNS VARCHAR(100)
NOT DETERMINISTIC READS SQL DATA
BEGIN

DECLARE gender VARCHAR(100);

IF p_gender = 'all' OR p_gender IS NULL THEN
  SET gender = '1';
ELSEIF p_gender = 'other' THEN
  SET gender = CONCAT("c2.code IN ('other','unknown')");
ELSE
  SET gender = CONCAT('c2.code = ',QUOTE(p_gender));
END IF;

RETURN gender;

END//
DELIMITER ;