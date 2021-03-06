USE dashboards;

DROP PROCEDURE IF EXISTS getIncludeExcludeString;

DELIMITER //
CREATE PROCEDURE getIncludeExcludeString(
IN p_query_id INT,
IN p_includedExclude VARCHAR(10),
IN p_includedAnyAll VARCHAR(10),
IN p_includedValueSet VARCHAR(1000), 
IN p_includedDateFrom VARCHAR(30), 
IN p_includedDateTo VARCHAR(30), 
IN p_includedPeriodOperator VARCHAR(50), 
IN p_includedPeriodValue VARCHAR(10),
IN p_includedPeriodType VARCHAR(20),
IN p_includeValuesettab VARCHAR(64),
IN p_includeConcepttab VARCHAR(64),
IN p_observationcohorttab VARCHAR(64),
IN p_filterType INT,
IN p_includedEarliestLatest VARCHAR(20), 
IN p_includedOperator VARCHAR(50), 
IN p_includedEntryValue VARCHAR(20), 
IN p_filtertab VARCHAR(64),
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
IN p_schema VARCHAR(255),
IN p_storetab VARCHAR(64),
OUT p_includeExcludeString VARCHAR(1000)
)
BEGIN

DECLARE includedValueSetString VARCHAR(255);
DECLARE includedTestedValueSetString VARCHAR(255);
DECLARE includedFollowedByValueSetString VARCHAR(255);
DECLARE timeperioddaterange VARCHAR(255);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_error(p_query_id,'getIncludeExcludeString',@code,@msg,now());
        RESIGNAL; -- rethrow the error
    END;

SET p_includedExclude = IF(p_includedExclude = '', NULL, p_includedExclude);
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

 IF p_filterType = 1 THEN -- filter rule 1

    IF p_includedExclude IS NOT NULL AND
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
      CALL buildIncludeExcludeString(p_includedExclude, p_includedAnyAll, timeperioddaterange, p_includeConcepttab, p_observationcohorttab, 
      p_filtertab, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, @includeExcludeString);
      SET p_includeExcludeString = @includeExcludeString;
    ELSE 
      SET p_includeExcludeString = '1';
    END IF;

 ELSEIF p_filterType = 2 THEN -- filter rule 2

    IF p_includedExclude IS NOT NULL AND
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
      CALL buildIncludeExcludeString(p_includedExclude, p_includedAnyAll, timeperioddaterange, p_includeConcepttab, p_observationcohorttab, 
      p_filtertab, p_includedEarliestLatest, p_includedOperator, p_includedEntryValue, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, @includeExcludeString);
      SET p_includeExcludeString = @includeExcludeString;
    ELSE 
      SET p_includeExcludeString = '1';
    END IF;

 ELSEIF p_filterType = 3 THEN -- filter rule 3

    IF p_includedExclude IS NOT NULL AND
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
      CALL buildIncludeExcludeString(p_includedExclude, p_includedAnyAll, timeperioddaterange, p_includeConcepttab, p_observationcohorttab, 
      p_filtertab, p_includedEarliestLatest, NULL, NULL, p_includedAnyAllTested, p_includeTestedConcepttab, NULL, NULL, NULL, NULL, NULL, 3, @includeExcludeString);
      SET p_includeExcludeString = @includeExcludeString;

    ELSE 
      SET p_includeExcludeString = '1';
    END IF;

 ELSEIF p_filterType = 4 THEN -- filter rule 4

    IF p_includedExclude IS NOT NULL AND
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
      CALL buildIncludeExcludeString(p_includedExclude, p_includedAnyAll, timeperioddaterange, p_includeConcepttab, p_observationcohorttab, 
      p_filtertab, NULL, NULL, NULL, NULL, NULL, p_includedAreNot, p_includedAnyAllFollowedBy, p_includedFollowedByConcepttab, NULL, NULL, 4, @includeExcludeString);
      SET p_includeExcludeString = @includeExcludeString;

    ELSE
      SET p_includeExcludeString = '1';
    END IF;
    
 ELSEIF p_filterType = 5 THEN -- filter rule 5
    
    IF p_includedExclude IS NOT NULL AND
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
      CALL buildIncludeExcludeString(p_includedExclude, p_includedAnyAll, timeperioddaterange, p_includeConcepttab, p_observationcohorttab, 
      p_filtertab, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, p_greaterless, p_greaterlessvalue, 5, @includeExcludeString);
      SET p_includeExcludeString = @includeExcludeString;
    ELSE
      SET p_includeExcludeString = '1';
    END IF;   

 END IF;

END//
DELIMITER ;