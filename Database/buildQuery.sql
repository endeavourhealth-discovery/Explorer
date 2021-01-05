USE dashboards;

DROP PROCEDURE IF EXISTS buildQuery;

DELIMITER //
CREATE PROCEDURE buildQuery(
IN p_query_id INT,
IN p_withWithout VARCHAR(10),
IN p_includedAnyAll VARCHAR(10),
IN p_includedValueSet VARCHAR(1000), 
IN p_includedDateFrom VARCHAR(30), 
IN p_includedDateTo VARCHAR(30), 
IN p_includedPeriodOperator VARCHAR(50), 
IN p_includedPeriodValue VARCHAR(10),
IN p_includedPeriodType VARCHAR(20),
IN p_includeValuesettab VARCHAR(64),
IN p_includeConcepttab VARCHAR(64),
IN p_observationCohortTab VARCHAR(64),
IN p_queryType INT,
IN p_includedEarliestLatest VARCHAR(20), 
IN p_includedOperator VARCHAR(50), 
IN p_includedEntryValue VARCHAR(20), 
IN p_observation_tmp VARCHAR(64),
IN p_includedAnyAllTested VARCHAR(10),
IN p_includedTestedValueSet VARCHAR(1000), 
IN p_includeTestedValuesettab VARCHAR(64),
IN p_includeTestedConcepttab VARCHAR(64),
IN p_includedAreNot VARCHAR(10),
IN p_includedAnyAllFollowedBy VARCHAR(10),
IN p_includedFollowedByValueSet VARCHAR(1000),
IN p_includedFollowedByValuesettab VARCHAR(64),
IN p_includedFollowedByConcepttab VARCHAR(64),
IN p_greaterless VARCHAR(50), 
IN p_greaterlessvalue VARCHAR(20), 
IN p_registrationExclude VARCHAR(10),
IN p_registrationDateFrom VARCHAR(20),  
IN p_registrationDateTo VARCHAR(20),  
IN p_registrationPeriodValue VARCHAR(10),
IN p_registrationPeriodType VARCHAR(20),
IN p_schema VARCHAR(255),
IN p_storetab VARCHAR(64),
IN p_cohort VARCHAR(64),
IN p_queryNumber VARCHAR(20)
)
BEGIN

DECLARE includedValueSetString VARCHAR(255);
DECLARE includedTestedValueSetString VARCHAR(255);
DECLARE includedFollowedByValueSetString VARCHAR(255);
DECLARE timeperioddaterange VARCHAR(255);
DECLARE regPeriodRange VARCHAR(500) DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(p_query_id,'buildQuery',@code,@msg,now());
        RESIGNAL; -- rethrow the error
    END;

SET p_withWithout = IF(p_withWithout = '', NULL, p_withWithout);
SET p_includedAnyAll = IF(p_includedAnyAll = '', NULL, p_includedAnyAll); 
SET p_includedValueSet = IF(p_includedValueSet = '', NULL, p_includedValueSet); 
SET p_includedDateFrom = IF(p_includedDateFrom = '', NULL, SUBSTRING(p_includedDateFrom,1,10));
SET p_includedDateTo = IF(p_includedDateTo = '', NULL, SUBSTRING(p_includedDateTo,1,10));

SET p_includedPeriodOperator = IF(p_includedPeriodOperator = '', NULL, p_includedPeriodOperator); 

SET p_includedPeriodValue = IF(p_includedPeriodValue = '', NULL, p_includedPeriodValue);
SET p_includedPeriodType = IF(p_includedPeriodType = '', NULL, p_includedPeriodType); 

SET p_includedEarliestLatest = IF(p_includedEarliestLatest = '', NULL, p_includedEarliestLatest); 
SET p_includedOperator = IF(p_includedOperator = '', NULL, p_includedOperator); 
SET p_includedEntryValue = IF(p_includedEntryValue = '', NULL, p_includedEntryValue); 

SET p_includedAnyAllTested = IF(p_includedAnyAllTested = '', NULL, p_includedAnyAllTested);  
SET p_includedTestedValueSet = IF(p_includedTestedValueSet = '', NULL, p_includedTestedValueSet);  

SET p_includedAreNot = IF(p_includedAreNot = '', NULL, p_includedAreNot);  
SET p_includedAnyAllFollowedBy = IF(p_includedAnyAllFollowedBy = '', NULL, p_includedAnyAllFollowedBy);  
SET p_includedFollowedByValueSet = IF(p_includedFollowedByValueSet = '', NULL, p_includedFollowedByValueSet);  

SET p_greaterless = IF(p_greaterless = '', NULL, p_greaterless);  
SET p_greaterlessvalue = IF(p_greaterlessvalue = '', NULL, p_greaterlessvalue);  

 IF p_queryType = 1 THEN -- filter by query type 1

    IF p_withWithout IS NOT NULL AND
       p_includedAnyAll IS NOT NULL AND
       p_includedValueSet IS NOT NULL THEN
      
      CALL getValueSetString(p_includedValueSet, p_storetab, @includedValueSetString);
      SET includedValueSetString = @includedValueSetString;
      -- create includeexclude valueset
      CALL createValueSet(includedValueSetString, p_includeValuesettab);
      -- create concept from includeexclude valueset
      CALL createConcept(p_includeConcepttab, p_includeValuesettab, p_schema);
      -- get time period date range string
      SET timeperioddaterange = getTimePeriodDateRange(p_includedDateFrom, p_includedDateTo, p_includedPeriodValue, p_includedPeriodType, p_includedPeriodOperator);    
      -- build include exclude string
      CALL runBuildQuery(p_query_id, p_withWithout, p_includedAnyAll, timeperioddaterange, p_includeConcepttab, p_observationCohortTab, NULL, NULL, NULL, NULL, 
      NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 
      p_cohort, p_queryNumber);

    END IF;

 ELSEIF p_queryType = 2 THEN -- filter by query type 2

    IF p_withWithout IS NOT NULL AND
       p_includedAnyAll IS NOT NULL AND
       p_includedValueSet IS NOT NULL AND 
       p_includedEarliestLatest IS NOT NULL AND 
       p_includedOperator IS NOT NULL AND 
       p_includedEntryValue IS NOT NULL THEN

      CALL getValueSetString(p_includedValueSet, p_storetab, @includedValueSetString);
      SET includedValueSetString = @includedValueSetString;
      -- create includeexclude valueset
      CALL createValueSet(includedValueSetString, p_includeValuesettab);
      -- create concept from includeexclude valueset
      CALL createConcept(p_includeConcepttab, p_includeValuesettab, p_schema);
      -- get time period date range string
      SET timeperioddaterange = getTimePeriodDateRange(p_includedDateFrom, p_includedDateTo, p_includedPeriodValue, p_includedPeriodType, p_includedPeriodOperator);
      -- build include exclude string
      CALL runBuildQuery(p_query_id, p_withWithout, p_includedAnyAll, timeperioddaterange, p_includeConcepttab, p_observationCohortTab, p_observation_tmp, p_includedEarliestLatest, p_includedOperator, p_includedEntryValue, 
      NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, 
      p_cohort, p_queryNumber);

    END IF;

 ELSEIF p_queryType = 3 THEN -- filter by query type 3

    IF p_withWithout IS NOT NULL AND
       p_includedAnyAll IS NOT NULL AND
       p_includedValueSet IS NOT NULL AND 
       p_includedEarliestLatest IS NOT NULL AND
       p_includedAnyAllTested IS NOT NULL AND
       p_includedTestedValueSet IS NOT NULL THEN
      
      -- valueset
      CALL getValueSetString(p_includedValueSet, p_storetab, @includedValueSetString);
      SET includedValueSetString = @includedValueSetString;
      -- create includeexclude valueset
      CALL createValueSet(includedValueSetString, p_includeValuesettab);
      -- create concept from includeexclude valueset
      CALL createConcept(p_includeConcepttab, p_includeValuesettab, p_schema);
      -- tested valueset
      CALL getValueSetString(p_includedTestedValueSet, p_storetab, @includedTestedValueSetString);
      SET includedTestedValueSetString = @includedTestedValueSetString;
      -- create includeexclude valueset
      CALL createValueSet(includedTestedValueSetString, p_includeTestedValuesettab);
      -- create concept from includeexclude valueset
      CALL createConcept(p_includeTestedConcepttab, p_includeTestedValuesettab, p_schema);
      -- get time period date range string
      SET timeperioddaterange = getTimePeriodDateRange(p_includedDateFrom, p_includedDateTo, p_includedPeriodValue, p_includedPeriodType, p_includedPeriodOperator);
      -- build include exclude string
      CALL runBuildQuery(p_query_id, p_withWithout, p_includedAnyAll, timeperioddaterange, p_includeConcepttab, p_observationCohortTab, p_observation_tmp, p_includedEarliestLatest, NULL, NULL, 
      p_includedAnyAllTested, p_includeTestedConcepttab, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 
      p_cohort, p_queryNumber);

    END IF;

 ELSEIF p_queryType = 4 THEN -- filter by query type 4

    IF p_withWithout IS NOT NULL AND
       p_includedAnyAll IS NOT NULL AND
       p_includedValueSet IS NOT NULL AND 
       p_includedAreNot IS NOT NULL AND 
       p_includedAnyAllFollowedBy IS NOT NULL AND 
       p_includedFollowedByValueSet IS NOT NULL THEN

      -- valueset
      CALL getValueSetString(p_includedValueSet, p_storetab, @includedValueSetString);
      SET includedValueSetString = @includedValueSetString;
      -- create includeexclude valueset
      CALL createValueSet(includedValueSetString, p_includeValuesettab);
      -- create concept from includeexclude valueset
      CALL createConcept(p_includeConcepttab, p_includeValuesettab, p_schema);
      -- followed by valueset
      CALL getValueSetString(p_includedFollowedByValueSet, p_storetab, @includedFollowedByValueSetString);
      SET includedFollowedByValueSetString = @includedFollowedByValueSetString;
      -- create includeexclude valueset
      CALL createValueSet(includedFollowedByValueSetString, p_includedFollowedByValuesettab);
      -- create concept from includeexclude valueset
      CALL createConcept(p_includedFollowedByConcepttab, p_includedFollowedByValuesettab, p_schema);
      -- get time period date range string
      SET timeperioddaterange = getTimePeriodDateRange(p_includedDateFrom, p_includedDateTo, p_includedPeriodValue, p_includedPeriodType, p_includedPeriodOperator);
      -- build include exclude string
      CALL runBuildQuery(p_query_id, p_withWithout, p_includedAnyAll, timeperioddaterange, p_includeConcepttab, p_observationCohortTab, p_observation_tmp, NULL, NULL, NULL, 
      NULL, NULL, p_includedAreNot, p_includedAnyAllFollowedBy, p_includedFollowedByConcepttab, NULL, NULL, NULL, NULL, 4, 
      p_cohort, p_queryNumber);

    END IF;
    
 ELSEIF p_queryType = 5 THEN -- filter by query type 5
    
    IF p_withWithout IS NOT NULL AND
       p_includedAnyAll IS NOT NULL AND
       p_includedValueSet IS NOT NULL AND 
       p_greaterless IS NOT NULL AND 
       p_greaterlessvalue IS NOT NULL THEN

      CALL getValueSetString(p_includedValueSet, p_storetab, @includedValueSetString);
      SET includedValueSetString = @includedValueSetString;
      -- create includeexclude valueset
      CALL createValueSet(includedValueSetString, p_includeValuesettab);
      -- create concept from includeexclude valueset
      CALL createConcept(p_includeConcepttab, p_includeValuesettab, p_schema);
      -- get time period date range string
      SET timeperioddaterange = getTimePeriodDateRange(p_includedDateFrom, p_includedDateTo, p_includedPeriodValue, p_includedPeriodType, p_includedPeriodOperator);
      -- build include exclude string
      CALL runBuildQuery(p_query_id, p_withWithout, p_includedAnyAll, timeperioddaterange, p_includeConcepttab, p_observationCohortTab, p_observation_tmp, NULL, NULL, NULL, 
      NULL, NULL, NULL, NULL, NULL, p_greaterless, p_greaterlessvalue, NULL, NULL, 5, 
      p_cohort, p_queryNumber);

    END IF;   

 ELSEIF p_queryType = 0 THEN 

  SET p_registrationExclude = UPPER(p_registrationExclude);
  SET p_registrationExclude = IF(p_registrationExclude = 'EXCLUDE','NOT EXISTS', IF(p_registrationExclude = 'INCLUDE','EXISTS',''));

  -- get registration time period
  SET p_registrationDateFrom = IF(p_registrationDateFrom = '', NULL, p_registrationDateFrom);
  SET p_registrationDateTo = IF(p_registrationDateTo = '', NULL, p_registrationDateTo);
  SET p_registrationPeriodType = IF(p_registrationPeriodType = 'Days','DAY', IF(p_registrationPeriodType = 'Weeks','WEEK', IF(p_registrationPeriodType = 'Months', 'MONTH', NULL)));

  IF (p_registrationExclude IS NOT NULL AND (
     (p_registrationDateFrom IS NOT NULL OR p_registrationDateTo IS NOT NULL) OR 
     (p_registrationPeriodValue IS NOT NULL AND p_registrationPeriodType IS NOT NULL))) THEN 
     SET regPeriodRange = getAgeDateRangeString(NULL, NULL, p_registrationDateFrom, p_registrationDateTo, p_registrationPeriodValue, p_registrationPeriodType, 2);
  ELSE
     SET regPeriodRange = '1';
  END IF;

  CALL runBuildQuery(p_query_id, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
  NULL, NULL, NULL, NULL, NULL, NULL, NULL, regPeriodRange, p_registrationExclude, 0, 
  p_cohort, p_queryNumber);

 END IF;

END//
DELIMITER ;