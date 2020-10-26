USE subscriber_pi_rv;

-- function to retrieve the patient's registered practice
DROP FUNCTION IF EXISTS getOrganizationName;

DELIMITER //
CREATE FUNCTION getOrganizationName(p_org_id BIGINT)
RETURNS VARCHAR(255)
DETERMINISTIC READS SQL DATA
BEGIN
DECLARE l_org VARCHAR(255);

SELECT name INTO l_org
FROM organization 
WHERE id = p_org_id;

RETURN l_org;

END//
DELIMITER ;