USE dashboards;

DROP FUNCTION IF EXISTS getTimePeriodDateRange;

DELIMITER //
CREATE FUNCTION getTimePeriodDateRange(
  p_includedDateFrom VARCHAR(20), 
  p_includedDateTo VARCHAR(20), 
  p_includedPeriodValue VARCHAR(20), 
  p_includedPeriodType VARCHAR(20)
  )
RETURNS VARCHAR(255)
NOT DETERMINISTIC READS SQL DATA
BEGIN

DECLARE daterange VARCHAR(255);

SET p_includedPeriodType = IF(p_includedPeriodType = 'Days','DAY', IF(p_includedPeriodType = 'Weeks','WEEK',IF(p_includedPeriodType = 'Months','MONTH',NULL)));

IF p_includedDateFrom IS NOT NULL AND p_includedPeriodValue IS NOT NULL THEN
 SET daterange = CONCAT('((o2.clinical_effective_date >= DATE_SUB(NOW(), INTERVAL ',p_includedPeriodValue,
 ' ', p_includedPeriodType,')) OR (o2.clinical_effective_date BETWEEN ',QUOTE(p_includedDateFrom) ,' AND ',QUOTE(p_includedDateTo),'))' );
ELSEIF p_includedDateFrom IS NOT NULL AND p_includedPeriodValue IS NULL THEN
 SET daterange = CONCAT('o2.clinical_effective_date BETWEEN ',QUOTE(p_includedDateFrom) ,
 ' AND ',QUOTE(p_includedDateTo));
ELSEIF p_includedDateFrom IS NULL AND p_includedPeriodValue IS NOT NULL THEN
 SET daterange = CONCAT('o2.clinical_effective_date >= DATE_SUB(NOW(), INTERVAL ',p_includedPeriodValue,' ', p_includedPeriodType,')');
ELSEIF p_includedDateFrom IS NULL AND p_includedPeriodValue IS NULL THEN 
 SET daterange = '1';
END IF;

RETURN daterange;

END//
DELIMITER ;