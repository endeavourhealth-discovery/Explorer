USE dashboards;

DROP FUNCTION IF EXISTS getAgeDateRangeString;

DELIMITER //
CREATE FUNCTION getAgeDateRangeString(
   p_from VARCHAR(30), 
   p_to VARCHAR(30), 
   p_periodFrom VARCHAR(20), 
   p_periodTo VARCHAR(20),  
   p_periodValue VARCHAR(20), 
   p_periodType VARCHAR(20), 
   p_type INT) -- 1 = age, 2 = reg date
RETURNS VARCHAR(500)
NOT DETERMINISTIC READS SQL DATA
BEGIN

DECLARE ageDateString VARCHAR(500);

IF p_type = 1 THEN

     IF p_from IS NOT NULL AND p_to IS NOT NULL THEN
          SET ageDateString = CONCAT('FLOOR(DATEDIFF(IF(p.date_of_death IS NULL, NOW(), p.date_of_death), p.date_of_birth) / 365.25) BETWEEN ', p_from, ' AND ', p_to);
     ELSEIF p_from IS NOT NULL AND p_to IS NULL THEN  -- greater or equal to
          SET ageDateString = CONCAT('FLOOR(DATEDIFF(IF(p.date_of_death IS NULL, NOW(), p.date_of_death), p.date_of_birth) / 365.25) >= ', p_from);
     ELSEIF p_to IS NOT NULL AND p_from IS NULL THEN  -- less than or equal to
          SET ageDateString = CONCAT('FLOOR(DATEDIFF(IF(p.date_of_death IS NULL, NOW(), p.date_of_death), p.date_of_birth) / 365.25) <= ', p_to);
     END IF;
  
ELSEIF p_type = 2 THEN

     IF p_periodFrom IS NOT NULL AND p_periodTo IS NOT NULL AND p_periodValue IS NOT NULL THEN

         SET ageDateString = CONCAT('((c.date_registered >= DATE_SUB( NOW(), INTERVAL ', p_periodValue,' ', p_periodType,')) 
         OR (c.date_registered BETWEEN ', QUOTE(p_periodFrom) ,' AND ', QUOTE(p_periodTo),') )' );

     ELSEIF p_periodFrom IS NOT NULL AND p_periodTo IS NULL AND p_periodValue IS NOT NULL THEN

         SET ageDateString = CONCAT('((c.date_registered >= DATE_SUB( NOW(), INTERVAL ', p_periodValue,' ', p_periodType,')) 
         OR (c.date_registered >= ', QUOTE(p_periodFrom), ') )' );

     ELSEIF p_periodFrom IS NULL AND p_periodTo IS NOT NULL AND p_periodValue IS NOT NULL THEN

         SET ageDateString = CONCAT('((c.date_registered >= DATE_SUB( NOW(), INTERVAL ', p_periodValue,' ', p_periodType,')) 
         OR (c.date_registered <= ', QUOTE(p_periodTo), ') )' );

     ELSEIF p_periodFrom IS NOT NULL AND p_periodTo IS NOT NULL AND p_periodValue IS NULL THEN

         SET ageDateString = CONCAT('c.date_registered BETWEEN ', QUOTE(p_periodFrom) ,' AND ', QUOTE(p_periodTo));

     ELSEIF p_periodFrom IS NOT NULL AND p_periodTo IS NULL AND p_periodValue IS NULL THEN

         SET ageDateString = CONCAT('c.date_registered >= ', QUOTE(p_periodFrom) );

     ELSEIF p_periodFrom IS NULL AND p_periodTo IS NOT NULL AND p_periodValue IS NULL THEN

         SET ageDateString = CONCAT('c.date_registered <= ', QUOTE(p_periodTo) );

     ELSEIF p_periodFrom IS NULL AND p_periodTo IS NULL AND p_periodValue IS NOT NULL THEN

         SET ageDateString = CONCAT('c.date_registered >= DATE_SUB(NOW(), INTERVAL ', p_periodValue,' ', p_periodType,')');

     END IF;
     
END IF;

RETURN ageDateString;

END//
DELIMITER ;