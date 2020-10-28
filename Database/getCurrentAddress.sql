USE subscriber_pi_rv;

-- function to retrieve the patient's current address
DROP FUNCTION IF EXISTS getCurrentAddress;

DELIMITER //
CREATE FUNCTION getCurrentAddress(p_address_id BIGINT, p_id BIGINT)
RETURNS VARCHAR(1000)
DETERMINISTIC READS SQL DATA
BEGIN
DECLARE l_address VARCHAR(1000);

SELECT  CONCAT_WS(', ', address_line_1, NULLIF(address_line_2,''), NULLIF(address_line_3,''), NULLIF(address_line_4,''), NULLIF(city,''))  INTO l_address
FROM patient_address 
WHERE id = p_address_id
AND patient_id = p_id;

RETURN l_address;

END//
DELIMITER ;