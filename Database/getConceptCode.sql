USE subscriber_pi_rv;

-- function to retrieve the code field on the concept table based on the concept id
DROP FUNCTION IF EXISTS getConceptCode;

DELIMITER //
CREATE FUNCTION getConceptCode(p_concept_id INT)
RETURNS VARCHAR(255)
DETERMINISTIC READS SQL DATA
BEGIN
DECLARE l_code VARCHAR(255);

SELECT code INTO l_code
FROM concept cpt
WHERE cpt.dbid = p_concept_id;

RETURN l_code;

END//
DELIMITER ;