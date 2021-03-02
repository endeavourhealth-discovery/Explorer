USE dashboards;

DROP FUNCTION IF EXISTS getTimePeriodDateRange;

DELIMITER //
CREATE FUNCTION getTimePeriodDateRange(
  p_includedDateFrom VARCHAR(20), 
  p_includedDateTo VARCHAR(20), 
  p_includedPeriodValue VARCHAR(20), 
  p_includedPeriodType VARCHAR(20),
  p_includedPeriodOperator VARCHAR(50),
  p_baselineDate VARCHAR(30)
  )
RETURNS VARCHAR(255)
NOT DETERMINISTIC READS SQL DATA
BEGIN

DECLARE daterange VARCHAR(255);
DECLARE effectiveDate VARCHAR(30);
DECLARE signString VARCHAR(3);
DECLARE clinicalEffectiveDateString VARCHAR(255);

IF p_baselineDate = 'N' THEN  -- for query pattern 4

  SET effectiveDate = 'o.clinical_effective_date';
  SET signString = '-';
  SET clinicalEffectiveDateString = 'o2.clinical_effective_date';

  IF UPPER(p_includedPeriodOperator) = 'WITHIN' OR UPPER(p_includedPeriodOperator) IS NULL THEN
       SET p_includedPeriodOperator = '<=';
       ELSEIF UPPER(p_includedPeriodOperator) = 'BEFORE' THEN
       SET p_includedPeriodOperator = '>=';
  END IF;

ELSEIF LENGTH(TRIM(p_baselineDate)) = 0  OR p_baselineDate IS NULL THEN

  -- set current date as the default date if no date specified
  SET effectiveDate = CURDATE();
  SET effectiveDate = QUOTE(effectiveDate);

  SET signString = '';
  SET clinicalEffectiveDateString = 'o2.clinical_effective_date';

  IF UPPER(p_includedPeriodOperator) = 'WITHIN' OR UPPER(p_includedPeriodOperator) IS NULL THEN
       SET p_includedPeriodOperator = '>=';
       ELSEIF UPPER(p_includedPeriodOperator) = 'BEFORE' THEN
       SET p_includedPeriodOperator = '<=';
  END IF;

ELSE

  -- set baseline run date
  SET effectiveDate = p_baselineDate;
  SET effectiveDate = QUOTE(effectiveDate);

  SET signString = '';
  SET clinicalEffectiveDateString = 'o2.clinical_effective_date';

  IF UPPER(p_includedPeriodOperator) = 'WITHIN' OR UPPER(p_includedPeriodOperator) IS NULL THEN
       SET p_includedPeriodOperator = '>=';
       ELSEIF UPPER(p_includedPeriodOperator) = 'BEFORE' THEN
       SET p_includedPeriodOperator = '<=';
  END IF;

END IF;

SET p_includedPeriodType = IF(p_includedPeriodType = 'Days','DAY', IF(p_includedPeriodType = 'Weeks','WEEK',IF(p_includedPeriodType = 'Months','MONTH',NULL)));

IF p_includedDateFrom = '1970-01-01' THEN SET p_includedDateFrom = NULL; END IF;
IF p_includedDateTo = '1970-01-01' THEN SET p_includedDateTo = NULL; END IF;

IF p_includedDateFrom IS NOT NULL AND p_includedDateTo IS NOT NULL AND p_includedPeriodValue IS NOT NULL THEN

       SET daterange = CONCAT("((", clinicalEffectiveDateString, " ", p_includedPeriodOperator," DATE_SUB( ", effectiveDate," , INTERVAL ", signString," ",p_includedPeriodValue," ", p_includedPeriodType,")) 
       OR (", clinicalEffectiveDateString," BETWEEN ", QUOTE(p_includedDateFrom)," AND ", QUOTE(p_includedDateTo),") )" );

ELSEIF p_includedDateFrom IS NOT NULL AND p_includedDateTo IS NULL AND p_includedPeriodValue IS NOT NULL THEN

       SET daterange = CONCAT("((", clinicalEffectiveDateString, " ", p_includedPeriodOperator," DATE_SUB( ", effectiveDate," , INTERVAL ", signString," ",p_includedPeriodValue," ", p_includedPeriodType,")) 
       OR (", clinicalEffectiveDateString," >= ", QUOTE(p_includedDateFrom), ") )" );

ELSEIF p_includedDateFrom IS NULL AND p_includedDateTo IS NOT NULL AND p_includedPeriodValue IS NOT NULL THEN

       SET daterange = CONCAT("((", clinicalEffectiveDateString, " ", p_includedPeriodOperator," DATE_SUB( ", effectiveDate," , INTERVAL ", signString," ",p_includedPeriodValue," ", p_includedPeriodType,")) 
       OR (", clinicalEffectiveDateString," <= ", QUOTE(p_includedDateTo), ") )" );

ELSEIF p_includedDateFrom IS NOT NULL AND p_includedDateTo IS NOT NULL AND p_includedPeriodValue IS NULL THEN

       SET daterange = CONCAT(clinicalEffectiveDateString," BETWEEN ", QUOTE(p_includedDateFrom) ," AND ", QUOTE(p_includedDateTo));

ELSEIF p_includedDateFrom IS NOT NULL AND p_includedDateTo IS NULL AND p_includedPeriodValue IS NULL THEN

       SET daterange = CONCAT(clinicalEffectiveDateString, " >= ", QUOTE(p_includedDateFrom) );

ELSEIF p_includedDateFrom IS NULL AND p_includedDateTo IS NOT NULL AND p_includedPeriodValue IS NULL THEN

       SET daterange = CONCAT(clinicalEffectiveDateString, " <= ", QUOTE(p_includedDateTo) );

ELSEIF p_includedDateFrom IS NULL AND p_includedDateTo IS NULL AND p_includedPeriodValue IS NOT NULL THEN

       SET daterange = CONCAT(clinicalEffectiveDateString, " ", p_includedPeriodOperator," DATE_SUB( ", effectiveDate," , INTERVAL ", signString," ",p_includedPeriodValue," ", p_includedPeriodType,")");

ELSEIF p_includedDateFrom IS NULL AND p_includedDateTo IS NULL AND p_includedPeriodValue IS NULL THEN 

       SET daterange = '1';

END IF;

RETURN daterange;

END//
DELIMITER ;