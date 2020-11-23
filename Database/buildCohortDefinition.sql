USE dashboards;

DROP PROCEDURE IF EXISTS buildCohortDefinition;

DELIMITER //
CREATE PROCEDURE buildCohortDefinition(
     p_query_id INT,
     p_providerOrganisation VARCHAR(5000),
     p_includedOrganisation VARCHAR(5000),
     p_registrationStatus VARCHAR(255),
     p_ageFrom VARCHAR(20),
     p_ageTo VARCHAR(20),
     p_gender VARCHAR(20),
     p_postcode VARCHAR(20),
     p_registrationExclude VARCHAR(10),
     p_registrationDateFrom VARCHAR(20),  
     p_registrationDateTo VARCHAR(20),  
     p_registrationPeriodValue VARCHAR(10),
     p_registrationPeriodType VARCHAR(20),
     p_organisationtab VARCHAR(64),
     p_allvaluesettab VARCHAR(64),
     p_allconcepttab VARCHAR(64),
     p_cohorttab VARCHAR(64),
     p_observationtab VARCHAR(64),
     p_schema VARCHAR(255),
     p_storetab VARCHAR(64)
)

BEGIN

  DECLARE agerange VARCHAR(500) DEFAULT NULL;
  DECLARE orgrange VARCHAR(255) DEFAULT NULL;
  DECLARE regstatus VARCHAR(255) DEFAULT NULL;
  DECLARE genderrange VARCHAR(255) DEFAULT NULL;
  DECLARE postcoderange VARCHAR(255) DEFAULT NULL;
  DECLARE regPeriodRange VARCHAR(500) DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(p_query_id,'buildCohortDefinition',@code,@msg,now());
        RESIGNAL; -- rethrow the error
    END;

-- provider and include orgs
  SET p_includedOrganisation = IF(p_includedOrganisation = '', NULL, p_includedOrganisation);  
  IF p_includedOrganisation IS NOT NULL THEN
      CALL getOrgString(CONCAT(p_providerOrganisation,',',p_includedOrganisation), p_organisationtab, p_storetab, @Org);
      SET orgrange = @Org;
  ELSE
      CALL getOrgString(p_providerOrganisation, p_organisationtab, p_storetab, @Org);
      SET orgrange = @Org;
  END IF;

-- reg status
  SET p_registrationStatus = IF(p_registrationStatus = '', NULL, p_registrationStatus);  
  IF p_registrationStatus IS NOT NULL THEN
    SET regstatus = getRegStatusString(p_registrationStatus);
  END IF;

-- get reg time period
  SET p_registrationDateFrom = IF(p_registrationDateFrom = 'NaN-NaN-NaN', NULL, IF(p_registrationDateFrom = '', NULL, p_registrationDateFrom));
  SET p_registrationDateTo = IF(p_registrationDateTo = 'NaN-NaN-NaN', NULL, IF(p_registrationDateTo = '', NULL, p_registrationDateTo));
  SET p_registrationPeriodType = IF(p_registrationPeriodType = 'Days','DAY', IF(p_registrationPeriodType = 'Weeks','WEEK', IF(p_registrationPeriodType = 'Months', 'MONTH', NULL)));

  IF (p_registrationExclude IS NOT NULL AND (
     (p_registrationDateFrom IS NOT NULL OR p_registrationDateTo IS NOT NULL) OR 
     (p_registrationPeriodValue IS NOT NULL AND p_registrationPeriodType IS NOT NULL))) THEN 
     SET regPeriodRange = getAgeDateRangeString(NULL, NULL, p_registrationDateFrom, p_registrationDateTo, p_registrationPeriodValue, p_registrationPeriodType, 2);
  ELSE
     SET regPeriodRange = '1';
  END IF;

-- age range
  SET p_ageFrom = IF(p_ageFrom = 'NaN-NaN-NaN', NULL, IF(p_ageFrom = '', NULL, p_ageFrom));
  SET p_ageTo = IF(p_ageTo = 'NaN-NaN-NaN', NULL, IF(p_ageTo = '', NULL, p_ageTo));

  IF (p_ageFrom IS NOT NULL) OR (p_ageTo IS NOT NULL) THEN
    SET agerange = getAgeDateRangeString(p_ageFrom, p_ageTo, NULL, NULL, NULL, NULL, 1);
  ELSE
    SET agerange = '1';
  END IF;

-- gender
  SET p_gender = IF(p_gender = '', NULL, p_gender);
  SET genderrange = getGenderString(p_gender); 

-- postcode
  SET p_postcode = IF(p_postcode = '', NULL, p_postcode);
  IF p_postcode IS NOT NULL THEN
   SET postcoderange = getPostcodeString(p_postcode);
  ELSE
   SET postcoderange = '1';
  END IF;

-- build cohort definition -- 

-- create the patient cohort
  CALL createPatientCohort(orgrange, regstatus, agerange, genderrange, postcoderange, regPeriodRange, p_registrationExclude, p_cohorttab, p_schema);

-- create the observation cohort for all the value sets to be used in the advance queries
  CALL createValueSet('1', p_allvaluesettab);
  CALL createConcept(p_allconcepttab, p_allvaluesettab, p_schema);
  CALL createObservationCohort(p_observationtab, p_cohorttab, p_allconcepttab, p_schema);

END//
DELIMITER ;