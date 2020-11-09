USE dashboards;

DROP FUNCTION IF EXISTS getTimePeriodDateRange;

DELIMITER //
CREATE FUNCTION getTimePeriodDateRange(
  p_includedDateFrom VARCHAR(20), 
  p_includedDateTo VARCHAR(20), 
  p_includedPeriodValue VARCHAR(20), 
  p_includedPeriodType VARCHAR(20),
  p_includedPeriodOperator VARCHAR(50)
  )
RETURNS VARCHAR(255)
NOT DETERMINISTIC READS SQL DATA
BEGIN

DECLARE daterange VARCHAR(255);

IF UPPER(p_includedPeriodOperator) = 'WITHIN' OR UPPER(p_includedPeriodOperator) IS NULL THEN
   SET p_includedPeriodOperator = '>=';
ELSEIF UPPER(p_includedPeriodOperator) = 'BEFORE' THEN
   SET p_includedPeriodOperator = '<=';
END IF;


SET p_includedPeriodType = IF(p_includedPeriodType = 'Days','DAY', IF(p_includedPeriodType = 'Weeks','WEEK',IF(p_includedPeriodType = 'Months','MONTH',NULL)));

IF p_includedDateFrom = '1970-01-01' AND p_includedDateTo = '1970-01-01' THEN
       SET p_includedDateFrom = NULL;
       SET p_includedDateTo = NULL;
ELSEIF p_includedDateFrom <> '1970-01-01' AND p_includedDateTo = '1970-01-01' THEN
       SET p_includedDateTo = NULL;
ELSEIF p_includedDateFrom = '1970-01-01' AND p_includedDateTo <> '1970-01-01' THEN
       SET p_includedDateFrom = NULL;
END IF;

IF p_includedDateFrom IS NOT NULL AND p_includedDateTo IS NOT NULL AND p_includedPeriodValue IS NOT NULL THEN

       SET daterange = CONCAT('((o2.clinical_effective_date ', p_includedPeriodOperator,' DATE_SUB( NOW(), INTERVAL ', p_includedPeriodValue,' ', p_includedPeriodType,')) 
       OR (o2.clinical_effective_date BETWEEN ', QUOTE(p_includedDateFrom),' AND ', QUOTE(p_includedDateTo),') )' );

ELSEIF p_includedDateFrom IS NOT NULL AND p_includedDateTo IS NULL AND p_includedPeriodValue IS NOT NULL THEN

       SET daterange = CONCAT('((o2.clinical_effective_date ', p_includedPeriodOperator,' DATE_SUB( NOW(), INTERVAL ', p_includedPeriodValue,' ', p_includedPeriodType,')) 
       OR (o2.clinical_effective_date >= ', QUOTE(p_includedDateFrom), ') )' );

ELSEIF p_includedDateFrom IS NULL AND p_includedDateTo IS NOT NULL AND p_includedPeriodValue IS NOT NULL THEN

       SET daterange = CONCAT('((o2.clinical_effective_date ', p_includedPeriodOperator,' DATE_SUB( NOW(), INTERVAL ', p_includedPeriodValue,' ', p_includedPeriodType,')) 
       OR (o2.clinical_effective_date <= ', QUOTE(p_includedDateTo), ') )' );

ELSEIF p_includedDateFrom IS NOT NULL AND p_includedDateTo IS NOT NULL AND p_includedPeriodValue IS NULL THEN

       SET daterange = CONCAT('o2.clinical_effective_date BETWEEN ', QUOTE(p_includedDateFrom) ,' AND ', QUOTE(p_includedDateTo));

ELSEIF p_includedDateFrom IS NOT NULL AND p_includedDateTo IS NULL AND p_includedPeriodValue IS NULL THEN

       SET daterange = CONCAT('o2.clinical_effective_date >= ', QUOTE(p_includedDateFrom) );

ELSEIF p_includedDateFrom IS NULL AND p_includedDateTo IS NOT NULL AND p_includedPeriodValue IS NULL THEN

       SET daterange = CONCAT('o2.clinical_effective_date <= ', QUOTE(p_includedDateTo) );

ELSEIF p_includedDateFrom IS NULL AND p_includedDateTo IS NULL AND p_includedPeriodValue IS NOT NULL THEN

       SET daterange = CONCAT('o2.clinical_effective_date ', p_includedPeriodOperator,' DATE_SUB(NOW(), INTERVAL ', p_includedPeriodValue,' ', p_includedPeriodType,')');

ELSEIF p_includedDateFrom IS NULL AND p_includedDateTo IS NULL AND p_includedPeriodValue IS NULL THEN 

       SET daterange = '1';

END IF;

RETURN daterange;

END//
DELIMITER ;