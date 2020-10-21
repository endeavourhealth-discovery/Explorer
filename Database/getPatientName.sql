USE subscriber_pi_rv;

-- function to retrieve the patient's name
DROP FUNCTION IF EXISTS getPatientName;

DELIMITER //
CREATE FUNCTION getPatientName(p_id INT)
RETURNS VARCHAR(255)
NOT DETERMINISTIC READS SQL DATA
BEGIN
DECLARE l_name VARCHAR(255);

-- SMITH, Fred John (Mr)

SELECT CONCAT(UPPER(last_name),', ',initcap(first_names),' (',initcap(title),')') INTO l_name
FROM patient
WHERE id = p_id;

RETURN l_name;

END//
DELIMITER ;