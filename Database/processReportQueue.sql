USE dashboards;

DROP PROCEDURE IF EXISTS processReportQueue;

DELIMITER //
CREATE PROCEDURE processReportQueue(p_sourceSchema VARCHAR(255), p_enableDebug INTEGER)

BEGIN

DECLARE queryid INT;
DECLARE query_text TEXT;
DECLARE flag VARCHAR(1) DEFAULT NULL;

DECLARE done INT;

DECLARE l_query TEXT;
DECLARE l_type VARCHAR(255);
DECLARE l_id INT;
DECLARE l_submitQuery VARCHAR(255);
DECLARE l_updated DATE;

DECLARE l_qry_id INT DEFAULT NULL;
DECLARE l_parent_qry_id INT DEFAULT NULL;
DECLARE l_denominator_qry VARCHAR(500) DEFAULT NULL;
DECLARE l_parent_exists_flag VARCHAR(1) DEFAULT NULL;

DROP TEMPORARY TABLE IF EXISTS qry_process_upd;
CREATE TEMPORARY TABLE qry_process_upd AS 
SELECT ql.id, ql.type, ql.query, ql.updated 
FROM query_library ql JOIN queue q ON ql.id = q.query_id
WHERE ql.updated <> q.query_last_updated 
AND ql.query <> q.query 
AND ql.id >=0
AND q.status <> 'A'; -- not already processing

DROP TEMPORARY TABLE IF EXISTS qry_process_ins;
CREATE TEMPORARY TABLE qry_process_ins AS 
SELECT id, `type`, query, updated
FROM query_library 
WHERE id >= 0
AND id NOT IN (SELECT query_id FROM queue);  

  BEGIN

      DECLARE c_chk_queryforupdate CURSOR FOR SELECT id, `type`, query, updated FROM qry_process_upd;
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
      
          SET done = 0;

            OPEN c_chk_queryforupdate;

            processloop1: 
            WHILE (done = 0) DO

                FETCH c_chk_queryforupdate INTO l_id, l_type, l_query, l_updated;

                IF done = 1 THEN 
                  LEAVE processloop1;
                END IF;

                -- get submit query flag
                SET l_submitQuery = UPPER(JSON_UNQUOTE(JSON_EXTRACT(l_query,'$.submitQuery'))); 

                IF l_submitQuery = 'YES' THEN  

                  UPDATE queue q SET q.query = l_query, q.query_last_updated = l_updated, q.next_run_date = CURDATE(), q.status = 'N', q.timesubmit = NULL, q.timefinish = NULL, q.timeexecute = NULL 
                  WHERE q.query_id = l_id;

                END IF;

            END WHILE processloop1;
            CLOSE c_chk_queryforupdate;
            SET done = 0;

  END;

  DROP TEMPORARY TABLE IF EXISTS qry_process_upd;

  BEGIN

      DECLARE c_chk_queryforinsert CURSOR FOR SELECT id, `type`, query, updated FROM qry_process_ins;
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
      
      SET done = 0;

        OPEN c_chk_queryforinsert;

        processloop2: 
        WHILE (done = 0) DO

            FETCH c_chk_queryforinsert INTO l_id, l_type, l_query, l_updated;

            IF done = 1 THEN 
              LEAVE processloop2;
            END IF;

            SET l_parent_exists_flag = NULL;

            -- get submit query flag
            SET l_submitQuery = UPPER(JSON_UNQUOTE(JSON_EXTRACT(l_query,'$.submitQuery'))); 

            IF l_submitQuery = 'YES' THEN  

                    -- check if type is top level
                      SELECT q1.id, q1.denominator_query, q2.id INTO l_qry_id, l_denominator_qry, l_parent_qry_id 
                      FROM query_library q1 LEFT JOIN query_library q2 ON q1.denominator_query = q2.name
                      WHERE q1.id = l_id;
                    
                      IF l_qry_id IS NOT NULL AND (LENGTH(TRIM(l_denominator_qry)) = 0 OR l_denominator_qry IS NULL)  AND l_parent_qry_id IS NULL THEN   -- is top level
                          -- add to queue
                          INSERT INTO queue (query_id, query, query_last_updated, next_run_date)
                          VALUES (l_id, l_query, l_updated, CURDATE());
                      
                      ELSEIF l_qry_id IS NOT NULL AND l_denominator_qry IS NOT NULL AND l_parent_qry_id IS NOT NULL THEN  -- could be numerator or denominator
                          -- check if parent exists in queue
                          SELECT 'Y' INTO l_parent_exists_flag FROM queue WHERE query_id = l_parent_qry_id;

                            IF l_parent_exists_flag = 'Y' THEN  -- parent found

                              INSERT INTO queue (query_id, query, query_last_updated, next_run_date)
                              VALUES (l_id, l_query, l_updated, CURDATE());

                            ELSE
                                -- do nothing
                                -- reset handler for not found
                                SET done = 0;

                            END IF;

                      END IF;

            END IF;

        END WHILE processloop2;
        CLOSE c_chk_queryforinsert;
        SET done = 0;

  END;

DROP TEMPORARY TABLE IF EXISTS qry_process_ins;

-- remove from queue if any query been removed
DELETE FROM queue 
WHERE query_id NOT IN (SELECT id FROM query_library)
AND status <> 'A'; -- i.e. not already processing

-- fetch the next id to process
SELECT query_id INTO queryid
FROM queue 
WHERE status = 'N' 
AND next_run_date = CURDATE()
AND 2 >= (SELECT COUNT(*) FROM queue WHERE status = 'A')  -- less than 3 query ids to process
ORDER BY query_id ASC -- to ensure numerator fetches first
LIMIT 1;

-- check for parent ids
CALL getNextQueryIdToProcess(queryid,  @next_query_id);
-- if found, override the query id with the latest parent ancestor query id
SET queryid = @next_query_id;

  -- check if the parent id is already running
  SELECT 'Y' INTO flag 
  FROM queue WHERE status = 'A' AND query_id = queryid;

  -- if yes, set the query id to null and skip the run
  IF flag = 'Y' THEN
    SET queryid = NULL;
  END IF;

IF queryid IS NOT NULL THEN

SELECT query INTO query_text FROM queue WHERE query_id = queryid;

UPDATE queue SET status = 'A' WHERE query_id = queryid;

UPDATE queue SET timesubmit = now() WHERE query_id = queryid;

-- disable binary logging
-- SET @@session.sql_log_bin=0;

CALL reportgenerator(queryid, query_text, p_sourceSchema, p_enableDebug);

-- enable binary logging
-- SET @@session.sql_log_bin=1;

UPDATE queue SET timefinish = now() WHERE query_id = queryid;
UPDATE queue SET timeexecute = STR_TO_DATE(TIMEDIFF(timefinish, timesubmit),'%H:%i:%s') WHERE query_id = queryid;

END IF;

END //
DELIMITER ;

