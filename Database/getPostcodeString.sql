USE dashboards;

DROP FUNCTION IF EXISTS getPostcodeString;

DELIMITER //
CREATE FUNCTION getPostcodeString(p_postcode VARCHAR(20)) 
RETURNS VARCHAR(255)
NOT DETERMINISTIC READS SQL DATA
BEGIN

DECLARE postcodestring VARCHAR(255);
DECLARE postcode VARCHAR(20);

SET postcode = TRIM(REPLACE(UPPER(p_postcode),' ',''));
SET postcode = CONCAT(postcode,'%');

SET postcodestring = CONCAT("TRIM(REPLACE(UPPER(pa.postcode),' ','')) LIKE ",QUOTE(postcode));

RETURN postcodestring;

END//
DELIMITER ;