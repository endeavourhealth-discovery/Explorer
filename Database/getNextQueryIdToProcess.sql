USE dashboards;

DROP PROCEDURE IF EXISTS getNextQueryIdToProcess;

DELIMITER //

CREATE PROCEDURE getNextQueryIdToProcess (IN p_query_id INT,  OUT p_query_next_id INT)
BEGIN

  DECLARE queryids VARCHAR(255);
  DECLARE query_id INT;
  DECLARE front VARCHAR(500) DEFAULT NULL;
  DECLARE frontlen INT DEFAULT NULL;
  DECLARE TempValue VARCHAR(500) DEFAULT NULL;
  
  
  SET p_query_next_id = p_query_id;

  -- get the latest non processed ancestor id of this query id
  CALL getParentQueryIds(p_query_id, @queryids); 
  
  SET queryids = @queryids;

   -- loop through each parent ids if found
 processloop:
 LOOP  

      IF LENGTH(TRIM(queryids)) = 0 OR queryids IS NULL THEN
         LEAVE processloop;
      END IF;

      -- fetch each id from comma separated list
      SET front = SUBSTRING_INDEX(queryids, ',', 1);
      SET frontlen = LENGTH(front);
      SET TempValue = TRIM(front);

      SET p_query_next_id = CAST(TempValue AS unsigned);

      -- fetch the next id
      SET queryids = INSERT(queryids, 1, frontlen + 1, '');

 END LOOP;

 -- return the next query id to process

END //
DELIMITER ;