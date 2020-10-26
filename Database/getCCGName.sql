USE subscriber_pi_rv;

-- function to retrieve the patient's registered practice
DROP FUNCTION IF EXISTS getCCGName;

DELIMITER //
CREATE FUNCTION getCCGName(p_org_id BIGINT)
RETURNS VARCHAR(255)
DETERMINISTIC READS SQL DATA
BEGIN
DECLARE l_org VARCHAR(255);

SELECT getOrganizationName(parent_organization_id) INTO l_org
FROM organization 
WHERE id = p_org_id;

RETURN l_org;

END//
DELIMITER ;