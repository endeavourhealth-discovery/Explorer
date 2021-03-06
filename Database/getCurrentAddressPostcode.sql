-- USE subscriber_pi_rv;

-- function to retrieve the patient's current address postcode
DROP FUNCTION IF EXISTS getCurrentAddressPostcode;

DELIMITER //
CREATE FUNCTION getCurrentAddressPostcode(p_address_id BIGINT, p_id BIGINT)
RETURNS VARCHAR(20)
DETERMINISTIC READS SQL DATA
BEGIN
DECLARE l_address VARCHAR(20);

SELECT  postcode  INTO l_address
FROM patient_address 
WHERE id = p_address_id
AND patient_id = p_id;

RETURN l_address;

END//
DELIMITER ;