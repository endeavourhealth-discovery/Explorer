-- USE subscriber_pi_rv;

-- function to retrieve the patient's registered practice
DROP FUNCTION IF EXISTS getOrganizationId;

DELIMITER //
CREATE FUNCTION getOrganizationId(p_ods_code VARCHAR(50))
RETURNS BIGINT
DETERMINISTIC READS SQL DATA
BEGIN
DECLARE l_org_id BIGINT;

SELECT id INTO l_org_id
FROM organization 
WHERE ods_code = p_ods_code;

RETURN l_org_id;

END//
DELIMITER ;