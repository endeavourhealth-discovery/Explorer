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
     p_dateFrom VARCHAR(20),
     p_dateTo VARCHAR(20),
     p_cohortValue VARCHAR(5000),
     p_organisationtab VARCHAR(64),
     p_valuesettab VARCHAR(64),
     p_concepttab VARCHAR(64),
     p_allvaluesettab VARCHAR(64),
     p_allconcepttab VARCHAR(64),
     p_cohorttab VARCHAR(64),
     p_observationtab VARCHAR(64),
     p_schema VARCHAR(255),
     p_storetab VARCHAR(64)
)

BEGIN

  DECLARE agerange VARCHAR(255) DEFAULT NULL;
  DECLARE daterange VARCHAR(255) DEFAULT NULL;
  DECLARE orgrange VARCHAR(255) DEFAULT NULL;
  DECLARE regstatus VARCHAR(255) DEFAULT NULL;
  DECLARE genderrange VARCHAR(255) DEFAULT NULL;
  DECLARE postcoderange VARCHAR(255) DEFAULT NULL;
  DECLARE cohortvalueset VARCHAR(5000) DEFAULT NULL;

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

-- age range
  SET p_ageFrom = IF(p_ageFrom = 'NaN-NaN-NaN', NULL, IF(p_ageFrom = '', NULL, p_ageFrom));
  SET p_ageTo = IF(p_ageTo = 'NaN-NaN-NaN', NULL, IF(p_ageTo = '', NULL, p_ageTo));
  IF (p_ageFrom IS NOT NULL) OR (p_ageTo IS NOT NULL) THEN
    SET agerange = getAgeDateRangeString(p_ageFrom, p_ageTo, 1);
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

-- date range
  SET p_dateFrom = IF(p_dateFrom = 'NaN-NaN-NaN',NULL, IF(p_dateFrom = '', NULL, SUBSTRING(p_dateFrom,1,10)));
  SET p_dateTo = IF(p_dateTo = 'NaN-NaN-NaN',NULL, IF(p_dateTo = '', NULL, SUBSTRING(p_dateTo,1,10)));

  IF p_dateFrom = '1970-01-01' AND p_dateTo = '1970-01-01' THEN
    SET p_dateFrom = NULL;
    SET p_dateTo = NULL;
  ELSEIF p_dateFrom <> '1970-01-01' AND p_dateTo = '1970-01-01' THEN
    SET p_dateTo = NULL;
  ELSEIF p_dateFrom = '1970-01-01' AND p_dateTo <> '1970-01-01' THEN
    SET p_dateFrom = NULL;
  END IF;

  IF (p_dateFrom IS NULL) AND (p_dateTo IS NULL) THEN
     SET daterange = '1';
  ELSE
    SET daterange = getAgeDateRangeString(p_dateFrom, p_dateTo, 2);
  END IF;

-- cohort value set
  SET p_cohortValue = IF(p_cohortValue = '', NULL, p_cohortValue); 
  IF p_cohortValue IS NOT NULL THEN
    CALL getValueSetString(p_cohortValue, p_storetab, @valueString);
    SET cohortvalueset = @valueString;
    -- create valueset cohort
    CALL createValueSet(cohortvalueset, p_valuesettab);
    -- create concept cohort from the valueset
    CALL createConcept(p_concepttab, p_valuesettab, p_schema);
  ELSE  -- if no value set is selected
    SET cohortvalueset = NULL;
    SET p_concepttab = NULL;
  END IF;

-- build cohort definition -- 

-- create the patient cohort
  CALL createPatientCohort(orgrange, regstatus, agerange, genderrange, postcoderange, daterange, p_concepttab, p_cohorttab, p_schema);

-- create all valueset cohort
  CALL createValueSet('1', p_allvaluesettab);
-- create all concept cohort from the valueset
  CALL createConcept(p_allconcepttab, p_allvaluesettab, p_schema);
-- create observation cohort from the patient cohort for all value set
  CALL createObservationCohort(p_observationtab, p_cohorttab, p_allconcepttab, p_schema);

END//
DELIMITER ;