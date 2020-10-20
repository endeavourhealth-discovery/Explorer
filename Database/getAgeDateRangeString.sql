USE dashboards;

DROP FUNCTION IF EXISTS getAgeDateRangeString;

DELIMITER //
CREATE FUNCTION getAgeDateRangeString(p_from VARCHAR(30), p_to VARCHAR(30), p_type INT) -- 1 = age, 2 = date
RETURNS VARCHAR(255)
NOT DETERMINISTIC READS SQL DATA
BEGIN

DECLARE ageDateString VARCHAR(255);

IF p_type = 1 THEN

  IF p_from IS NOT NULL AND p_to IS NOT NULL THEN
     SET ageDateString = CONCAT('FLOOR(DATEDIFF(IF(p.date_of_death IS NULL, NOW(), p.date_of_death), p.date_of_birth) / 365.25) BETWEEN ', p_from, ' AND ', p_to);
  ELSEIF p_from IS NOT NULL AND p_to IS NULL THEN  -- greater or equal to
     SET ageDateString = CONCAT('FLOOR(DATEDIFF(IF(p.date_of_death IS NULL, NOW(), p.date_of_death), p.date_of_birth) / 365.25) >= ', p_from);
  ELSEIF p_to IS NOT NULL AND p_from IS NULL THEN  -- less than or equal to
     SET ageDateString = CONCAT('FLOOR(DATEDIFF(IF(p.date_of_death IS NULL, NOW(), p.date_of_death), p.date_of_birth) / 365.25) <= ', p_to);
  END IF;
  
ELSEIF p_type = 2 THEN
  SET ageDateString = CONCAT('o.clinical_effective_date BETWEEN ', QUOTE(p_from),' AND ', QUOTE(p_to));
END IF;

RETURN ageDateString;

END//
DELIMITER ;