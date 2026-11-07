USE dashboards;

DROP PROCEDURE IF EXISTS kill_process_proc;

DELIMITER //

CREATE PROCEDURE kill_process_proc()
BEGIN
    DECLARE kill_done INT;
    DECLARE done INT;
    DECLARE queryId INT;
    DECLARE numeratorId INT;
    DECLARE cnt INT;
    DECLARE MESSAGE_TEXT VARCHAR(255);
    DECLARE EXIT HANDLER FOR NOT FOUND SET kill_done = 1;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
       BEGIN
        GET DIAGNOSTICS CONDITION 1
		@code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(queryId,'kill_process_proc', @code, @msg,now());
        RESIGNAL; -- rethrow the error
       END;

    BEGIN

    DECLARE processId INT;
    DECLARE get_process_id CURSOR FOR
    SELECT process_id, query_id FROM queue WHERE process_id IS NOT NULL AND kill_process = 'Y' ORDER BY process_id DESC; 

    OPEN get_process_id;
        processloop:
        LOOP
            FETCH get_process_id INTO processId, queryId;
            KILL CONNECTION processId;

            SET @sql = CONCAT("UPDATE queue SET next_run_date = NULL, status = 'N', timesubmit = NULL, timefinish = NULL, timeexecute = NULL, process_id = NULL, kill_process = NULL WHERE query_id = ", queryId);
            PREPARE stmt FROM @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            
            -- if this is a denominator then check for numerators that are due to run
            DROP TEMPORARY TABLE IF EXISTS qry_tmp;
            SET @sql = CONCAT("CREATE TEMPORARY TABLE qry_tmp AS 
            SELECT q.query_id, q.next_run_date FROM queue q JOIN (SELECT id FROM query_library 
            WHERE denominator_query IN (SELECT name FROM query_library WHERE id = ",queryId,")
            ) qlib ON q.query_id = qlib.id AND q.next_run_date = curdate()");
            PREPARE stmt FROM @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            
            SELECT COUNT(*) INTO cnt FROM qry_tmp;

            -- if found then update the next run date to null
            IF cnt > 0 THEN
               UPDATE queue q JOIN qry_tmp qt ON q.query_id = qt.query_id SET q.next_run_date = NULL;
            END IF;

            IF kill_done THEN
               LEAVE processloop;
            END IF;
        END LOOP;
    CLOSE get_process_id;
    END;

END//
DELIMITER ;