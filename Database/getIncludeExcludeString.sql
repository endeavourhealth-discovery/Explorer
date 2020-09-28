USE dashboards;

DROP PROCEDURE IF EXISTS getIncludeExcludeString;

DELIMITER //
CREATE PROCEDURE getIncludeExcludeString(
IN p_includedExclude VARCHAR(10),
IN p_includedAnyAll VARCHAR(10),
IN p_includedValueSet VARCHAR(1000), 
IN p_includedDateFrom VARCHAR(20), 
IN p_includedDateTo VARCHAR(20), 
IN p_includedPeriodValue VARCHAR(10),
IN p_includedPeriodType VARCHAR(20),
IN p_includeValuesettab VARCHAR(64),
IN p_includeConcepttab VARCHAR(64),
IN p_observationcohorttab VARCHAR(64),
IN p_filterType INT,
IN p_includedEarliestLatest VARCHAR(20), 
IN p_includedOperator VARCHAR(50), 
IN p_includedEntryValue VARCHAR(20), 
IN p_earliestLatestObservationtab VARCHAR(64),
IN p_includedAnyAllTested VARCHAR(10),
IN p_includedTestedValueSet VARCHAR(1000), 
IN p_includeTestedValuesettab VARCHAR(64),
IN p_includeTestedConcepttab VARCHAR(64),
OUT p_includeExcludeString VARCHAR(1000)
)
BEGIN

DECLARE includedValueSetString VARCHAR(255);
DECLARE includedTestedValueSetString VARCHAR(255);
DECLARE timeperioddaterange VARCHAR(255);

SET p_includedExclude = IF(p_includedExclude = '', NULL, p_includedExclude);
SET p_includedAnyAll = IF(p_includedAnyAll = '', NULL, p_includedAnyAll); 
SET p_includedValueSet = IF(p_includedValueSet = '', NULL, p_includedValueSet); 
SET p_includedDateFrom = IF(p_includedDateFrom = 'NaN-NaN-NaN',NULL, IF(p_includedDateFrom = '', NULL, p_includedDateFrom));
SET p_includedDateTo = IF(p_includedDateTo = 'NaN-NaN-NaN',NULL, IF(p_includedDateTo = '', NULL, p_includedDateTo));
SET p_includedPeriodValue = IF(p_includedPeriodValue = '', NULL, p_includedPeriodValue);
SET p_includedPeriodType = IF(p_includedPeriodType = '', NULL, p_includedPeriodType); 

SET p_includedEarliestLatest = IF(p_includedEarliestLatest = '', NULL, p_includedEarliestLatest); 
SET p_includedOperator = IF(p_includedOperator = '', NULL, p_includedOperator); 
SET p_includedEntryValue = IF(p_includedEntryValue = '', NULL, p_includedEntryValue); 

 IF p_filterType = 1 THEN -- filter rule 1

    IF p_includedExclude IS NOT NULL AND
           p_includedAnyAll IS NOT NULL AND
           p_includedValueSet IS NOT NULL THEN
      
      CALL getValueSetString(p_includedValueSet, @includedValueSetString);
      SET includedValueSetString = @includedValueSetString;
      -- create includeexclude valueset
      CALL createValueSet(includedValueSetString, p_includeValuesettab);
      -- create concept from includeexclude valueset
      CALL createConcept(p_includeConcepttab, p_includeValuesettab);
      -- get time period date range string
      SET timeperioddaterange = getTimePeriodDateRange(p_includedDateFrom, p_includedDateTo, p_includedPeriodValue, p_includedPeriodType);
      -- build include exclud string
      SET p_includeExcludeString = buildIncludeExcludeString(p_includedExclude, p_includedAnyAll, timeperioddaterange, p_includeConcepttab, p_observationcohorttab, NULL, NULL, 1);
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

      CALL getValueSetString(p_includedValueSet, @includedValueSetString);
      SET includedValueSetString = @includedValueSetString;
      -- create includeexclude valueset
      CALL createValueSet(includedValueSetString, p_includeValuesettab);
      -- create concept from includeexclude valueset
      CALL createConcept(p_includeConcepttab, p_includeValuesettab);
      -- get time period date range string
      SET timeperioddaterange = getTimePeriodDateRange(p_includedDateFrom, p_includedDateTo, p_includedPeriodValue, p_includedPeriodType);
      -- filter out earliest and latest observations
      CALL filterObservationByEarliestLatest(p_includeConcepttab, p_observationcohorttab, p_earliestLatestObservationtab, p_includedEarliestLatest, p_includedOperator, p_includedEntryValue, timeperioddaterange);
      -- build include exclud string
      SET p_includeExcludeString = buildIncludeExcludeString(p_includedExclude, p_includedAnyAll, NULL, NULL, NULL, p_earliestLatestObservationtab, NULL, 2);

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
      CALL getValueSetString(p_includedValueSet, @includedValueSetString);
      SET includedValueSetString = @includedValueSetString;
      -- create includeexclude valueset
      CALL createValueSet(includedValueSetString, p_includeValuesettab);
      -- create concept from includeexclude valueset
      CALL createConcept(p_includeConcepttab, p_includeValuesettab);
      
      -- tested valueset
      CALL getValueSetString(p_includedTestedValueSet, @includedTestedValueSetString);
      SET includedTestedValueSetString = @includedTestedValueSetString;
      -- create includeexclude valueset
      CALL createValueSet(includedTestedValueSetString, p_includeTestedValuesettab);
      -- create concept from includeexclude valueset
      CALL createConcept(p_includeTestedConcepttab, p_includeTestedValuesettab);

      -- filter out earliest and latest observations
      CALL filterObservationByEarliestLatest(p_includeConcepttab, p_observationcohorttab, p_earliestLatestObservationtab, p_includedEarliestLatest, NULL, NULL, NULL);
      -- build include exclude string
      SET p_includeExcludeString = buildIncludeExcludeString(p_includedExclude, p_includedAnyAll, NULL, p_includeTestedConcepttab, NULL, p_earliestLatestObservationtab, p_includedAnyAllTested, 3);

    ELSE 
      SET p_includeExcludeString = '1';
    END IF;

 END IF;

END//
DELIMITER ;