USE dashboards;

DROP PROCEDURE IF EXISTS buildCohortDefinition;

DELIMITER //
CREATE PROCEDURE buildCohortDefinition(
     p_query_id INT,
     p_providerOrganisation VARCHAR(5000),
     p_registrationStatus VARCHAR(255),
     p_gender VARCHAR(20),
     p_postcode VARCHAR(20),
     p_selectedEthnicFields VARCHAR(2000), 
     p_lsoa VARCHAR(50),
     p_organisationTab VARCHAR(64),
     p_practiceCohortTab VARCHAR(64),
     p_ethnicFieldsTab VARCHAR(64), 
     p_schema VARCHAR(255)
)

BEGIN

  DECLARE orgrange VARCHAR(255) DEFAULT NULL;
  DECLARE regstatus VARCHAR(255) DEFAULT NULL;
  DECLARE genderrange VARCHAR(255) DEFAULT NULL;
  DECLARE postcoderange VARCHAR(255) DEFAULT NULL;
  DECLARE ethnicgroups VARCHAR(255) DEFAULT NULL; 
  DECLARE lsoaString VARCHAR(255) DEFAULT NULL;  

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(p_query_id, 'buildCohortDefinition', @code, @msg, now());
        RESIGNAL; -- rethrow the error
    END;

  -- ethnic groups
  SET p_selectedEthnicFields = IF(p_selectedEthnicFields = '', NULL, p_selectedEthnicFields);  
  IF p_selectedEthnicFields IS NOT NULL THEN
      CALL storeString(p_selectedEthnicFields, p_ethnicFieldsTab);
      SET ethnicgroups = CONCAT('el.ethnic_group IN (SELECT code FROM ', p_ethnicFieldsTab,')');
  ELSE
      SET ethnicgroups = '1';
  END IF;

  -- lsoa code
  SET p_lsoa = IF(p_lsoa = '', NULL, p_lsoa);  
  IF p_lsoa IS NOT NULL THEN
     SET p_lsoa = TRIM(REPLACE(UPPER(p_lsoa),' ',''));
     SET p_lsoa = CONCAT(p_lsoa,'%');
     SET lsoaString = CONCAT("pa.lsoa_2011_code LIKE ", QUOTE(p_lsoa));
  ELSE
     SET lsoaString = '1';
  END IF;

  -- get provider orgs
  CALL storeString(p_providerOrganisation, p_organisationTab);
  SET orgrange = CONCAT('JOIN ', p_organisationTab, ' ot ON ot.code = org.ods_code ');

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
  CALL createPatientCohort(p_query_id, orgrange, regstatus, genderrange, postcoderange, p_practiceCohortTab, ethnicgroups, lsoaString, p_schema);

END//
DELIMITER ;