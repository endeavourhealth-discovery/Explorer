-- USE subscriber_pi_rv;

-- function to retrieve the name field on the concept table based on the concept id
DROP FUNCTION IF EXISTS getConceptName;

DELIMITER //
CREATE FUNCTION getConceptName(p_concept_id INT)
RETURNS VARCHAR(255)
DETERMINISTIC READS SQL DATA
BEGIN
DECLARE l_name VARCHAR(255);

SELECT name INTO l_name
FROM concept cpt
WHERE cpt.dbid = p_concept_id;

RETURN l_name;

END//
DELIMITER ;