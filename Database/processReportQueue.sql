USE dashboards;

DROP PROCEDURE IF EXISTS processReportQueue;

DELIMITER //
CREATE PROCEDURE processReportQueue()

BEGIN

DECLARE queryid INT;
DECLARE query TEXT;

-- update queue if existing queries been updated - run report again by setting the next run date to today's date
UPDATE queue q JOIN query_library l ON q.query_id = l.id 
SET q.query = l.query, 
q.query_last_updated = l.updated, 
next_run_date = CURDATE(),
status = 'N',
timesubmit = NULL,
timefinish = NULL,
timeexecute = NULL
WHERE q.query_last_updated <> l.updated
AND q.status <> 'A';

-- add to queue if any new query exists and set the next run date as today's date
INSERT INTO queue(query_id, query, query_last_updated, next_run_date)
SELECT l.id, l.query, l.updated, CURDATE()
FROM query_library l
WHERE l.id NOT IN (SELECT q.query_id FROM queue q);

START TRANSACTION;

SELECT q.query_id, q.query INTO queryid, query
FROM queue q
WHERE q.status = 'N' 
AND q.next_run_date = CURDATE()
AND EXISTS (SELECT COUNT(*) FROM queue q WHERE q.status = 'A' HAVING COUNT(*) < 3)  -- less than 3 query ids to process
LIMIT 1 FOR UPDATE;

-- set status to active i.e. processing and commit record

IF queryid IS NOT NULL THEN
 UPDATE queue SET status = 'A' 
 WHERE query_id = queryid;
END IF;

-- and add one here to make 3 query ids allowed to process if run concurrently

COMMIT;

IF queryid IS NOT NULL THEN

UPDATE queue SET timesubmit = now() WHERE query_id = queryid;

CALL reportgenerator(queryid, query);

UPDATE queue SET timefinish = now() WHERE query_id = queryid;
UPDATE queue SET timeexecute = STR_TO_DATE(TIMEDIFF(timefinish, timesubmit),'%H:%i:%s') WHERE query_id = queryid;

END IF;

END //
DELIMITER ;

