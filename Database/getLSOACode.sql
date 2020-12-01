-- USE subscriber_pi_rv;

-- function to retrieve the patient's current address postcode
DROP FUNCTION IF EXISTS getLSOACode;

DELIMITER //
CREATE FUNCTION getLSOACode(p_id BIGINT)
RETURNS VARCHAR(20)
DETERMINISTIC READS SQL DATA
BEGIN
DECLARE l_lsoa VARCHAR(20);

SELECT  pa.lsoa_2011_code  INTO l_lsoa
FROM patient p JOIN patient_address pa ON p.id = pa.patient_id AND p.current_address_id = pa.id
WHERE p.id = p_id;

RETURN l_lsoa;

END//
DELIMITER ;