USE dashboards;

DROP PROCEDURE IF EXISTS processReportQueue;

DELIMITER //
CREATE PROCEDURE processReportQueue()

BEGIN

DECLARE queryid INT;
DECLARE query_text TEXT;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

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
AND q.status <> 'A';  -- i.e. not already processing

-- add to queue if any new query exists
INSERT INTO queue(query_id, query, query_last_updated, next_run_date)
SELECT id, query, updated, CURDATE() 
FROM query_library 
WHERE id NOT IN (SELECT query_id FROM queue);  

-- remove from queue if any query been removed
DELETE FROM queue 
WHERE query_id NOT IN (SELECT id FROM query_library)
AND status <> 'A'; -- i.e. not already processing

START TRANSACTION;

SELECT query_id, query INTO queryid, query_text
FROM queue 
WHERE status = 'N' 
AND next_run_date = CURDATE()
AND 2 >= (SELECT COUNT(*) FROM queue WHERE status = 'A')  -- less than 3 query ids to process
LIMIT 1 FOR UPDATE;

-- set status to active i.e. processing and commit record

IF queryid IS NOT NULL THEN
 UPDATE queue SET status = 'A' 
 WHERE query_id = queryid;
END IF;

-- allowing only 3 query ids to process if run concurrently

COMMIT;

IF queryid IS NOT NULL THEN

UPDATE queue SET timesubmit = now() WHERE query_id = queryid;

CALL reportgenerator(queryid, query_text);

UPDATE queue SET timefinish = now() WHERE query_id = queryid;
UPDATE queue SET timeexecute = STR_TO_DATE(TIMEDIFF(timefinish, timesubmit),'%H:%i:%s') WHERE query_id = queryid;

END IF;

END //
DELIMITER ;

