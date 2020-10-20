USE subscriber_pi_rv;

-- function to retrieve the patient's current address
DROP FUNCTION IF EXISTS getCurrentAddress;

DELIMITER //
CREATE FUNCTION getCurrentAddress(p_address_id INT)
RETURNS VARCHAR(1000)
NOT DETERMINISTIC READS SQL DATA
BEGIN
DECLARE l_address VARCHAR(1000);

SELECT  CONCAT_WS(', ', address_line_1, address_line_2, address_line_3, address_line_4, city)  INTO l_address
FROM patient_address 
WHERE id = p_address_id;

RETURN l_address;

END//
DELIMITER ;