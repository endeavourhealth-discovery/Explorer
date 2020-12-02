USE dashboards;

DROP PROCEDURE IF EXISTS processReportQueue;

DELIMITER //
CREATE PROCEDURE processReportQueue()

BEGIN

DECLARE queryid INT;
DECLARE query_text TEXT;
DECLARE flag VARCHAR(1) DEFAULT NULL;

-- update queue if any existing query been updated
UPDATE queue q JOIN query_library l ON q.query_id = l.id 
SET q.query = l.query, 
    q.query_last_updated = l.updated, 
    q.next_run_date = CURDATE(),
    q.status = 'N',
    q.timesubmit = NULL,
    q.timefinish = NULL,
    q.timeexecute = NULL
WHERE q.query_last_updated <> l.updated
AND l.id >= 0
AND q.status <> 'A';  -- i.e. not already processing

-- add to queue if any new query exists
INSERT INTO queue(query_id, query, query_last_updated, next_run_date)
SELECT id, query, updated, CURDATE() 
FROM query_library 
WHERE id >= 0
AND id NOT IN (SELECT query_id FROM queue);  

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
LIMIT 1;

-- check for parent ids
CALL getNextQueryIdToProcess(queryid,  @next_query_id);
-- if found, override query id with the latest parent ancestor id
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
SET @@session.sql_log_bin=0;

CALL reportgenerator(queryid, query_text);

-- enable binary logging
SET @@session.sql_log_bin=1;

UPDATE queue SET timefinish = now() WHERE query_id = queryid;
UPDATE queue SET timeexecute = STR_TO_DATE(TIMEDIFF(timefinish, timesubmit),'%H:%i:%s') WHERE query_id = queryid;

END IF;

END //
DELIMITER ;

