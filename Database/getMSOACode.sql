-- USE subscriber_pi_rv;

-- function to retrieve the patient's msoa code
DROP FUNCTION IF EXISTS getMSOACode;

DELIMITER //
CREATE FUNCTION getMSOACode(p_id BIGINT)
RETURNS VARCHAR(20)
DETERMINISTIC READS SQL DATA
BEGIN
DECLARE l_msoa VARCHAR(20);

SELECT  pa.msoa_2011_code  INTO l_msoa
FROM patient p JOIN patient_address pa ON p.id = pa.patient_id AND p.current_address_id = pa.id
WHERE p.id = p_id;

RETURN l_msoa;

END//
DELIMITER ;