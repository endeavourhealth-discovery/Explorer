USE dashboards;

DROP PROCEDURE IF EXISTS buildCohortDefinition;

DELIMITER //
CREATE PROCEDURE buildCohortDefinition(
     p_query_id INT,
     p_providerOrganisation VARCHAR(5000),
     p_includedOrganisation VARCHAR(5000),
     p_registrationStatus VARCHAR(255),
     p_gender VARCHAR(20),
     p_postcode VARCHAR(20),
     p_organisationTab VARCHAR(64),
     p_practiceCohortTab VARCHAR(64),
     p_storeTab VARCHAR(64),
     p_schema VARCHAR(255)
)

BEGIN

  DECLARE orgrange VARCHAR(255) DEFAULT NULL;
  DECLARE regstatus VARCHAR(255) DEFAULT NULL;
  DECLARE genderrange VARCHAR(255) DEFAULT NULL;
  DECLARE postcoderange VARCHAR(255) DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(p_query_id, 'buildCohortDefinition', @code, @msg, now());
        RESIGNAL; -- rethrow the error
    END;

  -- get provider and include orgs
  SET p_includedOrganisation = IF(p_includedOrganisation = '', NULL, p_includedOrganisation);  
  IF p_includedOrganisation IS NOT NULL THEN
      CALL getOrgString(CONCAT(p_providerOrganisation,',',p_includedOrganisation), p_organisationTab, p_storeTab, @Org);
      SET orgrange = @Org;
  ELSE
      CALL getOrgString(p_providerOrganisation, p_organisationTab, p_storeTab, @Org);
      SET orgrange = @Org;
  END IF;

  -- registration status
  SET p_registrationStatus = IF(p_registrationStatus = '', NULL, p_registrationStatus);  
  IF p_registrationStatus IS NOT NULL THEN
      SET regstatus = getRegStatusString(p_registrationStatus);
  END IF;

  -- get gender
  SET p_gender = IF(p_gender = '', NULL, p_gender);
  SET genderrange = getGenderString(p_gender); 

  -- get postcode
  SET p_postcode = IF(p_postcode = '', NULL, p_postcode);
  IF p_postcode IS NOT NULL THEN
    SET postcoderange = getPostcodeString(p_postcode);
  ELSE
    SET postcoderange = '1';
  END IF;
  
  -- create the practice patient cohort
  CALL createPatientCohort(orgrange, regstatus, genderrange, postcoderange, p_practiceCohortTab, p_schema);

END//
DELIMITER ;