USE dashboards;

DROP FUNCTION IF EXISTS getAgeDateRangeString;

DELIMITER //
CREATE FUNCTION getAgeDateRangeString(
   p_from VARCHAR(30), 
   p_to VARCHAR(30), 
   p_dateFrom VARCHAR(20), 
   p_dateTo VARCHAR(20),  
   p_periodValue VARCHAR(20), 
   p_periodType VARCHAR(20), 
   p_baselineDate VARCHAR(30),
   p_type INT) -- 1 = age, 2 = reg date, 3 = other date range
RETURNS VARCHAR(500)
NOT DETERMINISTIC READS SQL DATA
BEGIN

DECLARE ageDateString VARCHAR(500);
DECLARE effectiveDate VARCHAR(30);

IF p_type = 1 THEN

    IF p_from IS NOT NULL AND p_to IS NOT NULL THEN
        IF  p_from > p_to THEN
            SET ageDateString = CONCAT('p.age > ', p_from,' OR p.age < ', p_to,')');
        ELSE
            SET ageDateString = CONCAT('p.age BETWEEN ', p_from, ' AND ', p_to);
        END IF;
    ELSEIF p_from IS NOT NULL AND p_to IS NULL THEN  -- greater or equal to
        SET ageDateString = CONCAT('p.age >= ', p_from);
    ELSEIF p_to IS NOT NULL AND p_from IS NULL THEN  -- less than or equal to
        SET ageDateString = CONCAT('p.age <= ', p_to);
    END IF;
  
ELSEIF p_type = 2 THEN

    IF LENGTH(TRIM(p_baselineDate)) = 0  OR p_baselineDate IS NULL THEN
      SET effectiveDate = CURDATE();
    ELSE
      SET effectiveDate = p_baselineDate;
    END IF;

    -- additional checks for default date values

    IF p_dateFrom = '1970-01-01' THEN SET p_dateFrom = NULL; END IF;
    IF p_dateTo = '1970-01-01' THEN SET p_dateTo = NULL; END IF;

    IF p_dateFrom IS NOT NULL AND p_dateTo IS NOT NULL AND p_periodValue IS NOT NULL THEN
        SET ageDateString = CONCAT('((c.date_registered >= DATE_SUB( ', QUOTE(effectiveDate),', INTERVAL ', p_periodValue,' ', p_periodType,')) 
        OR (c.date_registered BETWEEN ', QUOTE(p_dateFrom) ,' AND ', QUOTE(p_dateTo),') )' );
    ELSEIF p_dateFrom IS NOT NULL AND p_dateTo IS NULL AND p_periodValue IS NOT NULL THEN
        SET ageDateString = CONCAT('((c.date_registered >= DATE_SUB( ', QUOTE(effectiveDate),', INTERVAL ', p_periodValue,' ', p_periodType,')) 
        OR (c.date_registered >= ', QUOTE(p_dateFrom), ') )' );
    ELSEIF p_dateFrom IS NULL AND p_dateTo IS NOT NULL AND p_periodValue IS NOT NULL THEN
        SET ageDateString = CONCAT('((c.date_registered >= DATE_SUB( ', QUOTE(effectiveDate),', INTERVAL ', p_periodValue,' ', p_periodType,')) 
        OR (c.date_registered <= ', QUOTE(p_dateTo), ') )' );
    ELSEIF p_dateFrom IS NOT NULL AND p_dateTo IS NOT NULL AND p_periodValue IS NULL THEN
        SET ageDateString = CONCAT('c.date_registered BETWEEN ', QUOTE(p_dateFrom) ,' AND ', QUOTE(p_dateTo));
    ELSEIF p_dateFrom IS NOT NULL AND p_dateTo IS NULL AND p_periodValue IS NULL THEN
        SET ageDateString = CONCAT('c.date_registered >= ', QUOTE(p_dateFrom) );
    ELSEIF p_dateFrom IS NULL AND p_dateTo IS NOT NULL AND p_periodValue IS NULL THEN
        SET ageDateString = CONCAT('c.date_registered <= ', QUOTE(p_dateTo) );
    ELSEIF p_dateFrom IS NULL AND p_dateTo IS NULL AND p_periodValue IS NOT NULL THEN
        SET ageDateString = CONCAT('c.date_registered >= DATE_SUB( ', QUOTE(effectiveDate),', INTERVAL ', p_periodValue,' ', p_periodType,')');
    END IF;

ELSEIF p_type = 3 THEN

    IF p_dateFrom IS NOT NULL AND p_dateTo IS NOT NULL THEN
        SET ageDateString = CONCAT('o.clinical_effective_date BETWEEN ', QUOTE(p_dateFrom),' AND ', QUOTE(p_dateTo));
    ELSEIF p_dateFrom IS NOT NULL AND p_dateTo IS NULL THEN
        SET ageDateString = CONCAT('o.clinical_effective_date >= ', QUOTE(p_dateFrom));
    ELSEIF p_dateTo IS NOT NULL AND p_dateFrom IS NULL THEN
        SET ageDateString = CONCAT('o.clinical_effective_date <= ', QUOTE(p_dateTo));
    END IF;
   
END IF;

RETURN ageDateString;

END//
DELIMITER ;