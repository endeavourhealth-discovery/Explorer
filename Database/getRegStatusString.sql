USE dashboards;

DROP FUNCTION IF EXISTS getRegStatusString;

DELIMITER //
CREATE FUNCTION getRegStatusString(p_status VARCHAR(100)) 
RETURNS VARCHAR(255)
NOT DETERMINISTIC READS SQL DATA
BEGIN

DECLARE regStatusString VARCHAR(255);

IF UPPER(p_status) = 'CURRENTLY REGISTERED PATIENTS' THEN
  SET regStatusString = " c.id = 'FHIR_RT_R' AND (e.date_registered_end > NOW() OR e.date_registered_end IS NULL)";
ELSEIF UPPER(p_status) = 'ALL PATIENTS INCLUDED LEFT AND DEADS' THEN
  SET regStatusString = '1';
END IF;

RETURN regStatusString;

END//
DELIMITER ;