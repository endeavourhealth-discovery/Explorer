USE subscriber_pi_rv;

-- function to retrieve the patient's registered practice
DROP FUNCTION IF EXISTS getPractitionerName;

DELIMITER //
CREATE FUNCTION getPractitionerName(p_id BIGINT)
RETURNS VARCHAR(255)
NOT DETERMINISTIC READS SQL DATA
BEGIN
DECLARE l_name VARCHAR(255);

SELECT name INTO l_name
FROM practitioner 
WHERE id = p_id;

RETURN l_name;

END//
DELIMITER ;