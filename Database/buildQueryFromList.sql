USE dashboards;

DROP PROCEDURE IF EXISTS buildQueryFromList;

DELIMITER //

CREATE PROCEDURE buildQueryFromList (
  IN p_query_id  INT,
  IN p_queryNumber VARCHAR(20),
  IN query_list_tmp VARCHAR(64),
  IN p_schema VARCHAR(255)
  )

BEGIN

  DECLARE done INT;
  DECLARE l_query_id INT;
  DECLARE l_patientcohort_tmp VARCHAR(64);
  DECLARE l_qryString VARCHAR(2000);
  DECLARE _messageText VARCHAR(128);
  DECLARE cnt INT DEFAULT 0;
  DECLARE l_patientcohort_tmp_1 VARCHAR(64);
  DECLARE group_by_clause VARCHAR(255);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(p_query_id,'buildQueryFromList', @code, @msg,now());
        RESIGNAL; -- rethrow the error
    END;   

  DROP TEMPORARY TABLE IF EXISTS qry_list;
  SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_list AS 
  SELECT q.id AS query_id FROM query_library q JOIN ', query_list_tmp,' l WHERE l.code = q.name');
  PREPARE stmt FROM @sql;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt; 

    BEGIN

        DECLARE c_get_qry_ids CURSOR FOR SELECT query_id FROM qry_list;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

        SET done = 0;

        OPEN c_get_qry_ids;
        SET l_qryString = '';
        SET cnt = 0;

        processList: 
        WHILE (done = 0) DO

        FETCH c_get_qry_ids INTO l_query_id;

            IF done = 1 THEN 
                LEAVE processList;
            END IF;
            
            SET l_patientcohort_tmp = CONCAT('patientcohort_tmp_',l_query_id);
            
            -- check if the patientcohort table exists 

            SET @chk = '';
            SET @sql = CONCAT("SELECT 1 INTO @chk FROM information_schema.tables WHERE table_name = '", l_patientcohort_tmp,"'");
            PREPARE stmt FROM @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            IF @chk != 1 THEN
               -- raise error
               SELECT CONCAT('Table ', l_patientcohort_tmp, ' not found') INTO _messageText;
               SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = _messageText;
               CALL log_errors(l_query_id, 'buildQueryFromList', '45000', MESSAGE_TEXT, now());
               RESIGNAL; -- rethrow the error
            END IF;

            SET cnt = cnt + 1;

            IF cnt = 1 THEN
                 SET l_qryString =  CONCAT(l_qryString, 'SELECT patient_id, person_id, organization_id FROM ', l_patientcohort_tmp);   
                 SET l_patientcohort_tmp_1 = l_patientcohort_tmp; 
            ELSEIF cnt > 1 THEN
                 -- create intersection for mysql using union all and group by
                 IF cnt = 2 THEN SET l_qryString = ''; END IF;
                 SET l_qryString =  CONCAT(l_qryString, '(SELECT p.patient_id, p.person_id, p.organization_id 
                 FROM ', l_patientcohort_tmp_1,' p JOIN ', l_patientcohort_tmp,' p',cnt,' ON p.patient_id = p',cnt,'.patient_id AND p.organization_id = p',cnt,'.organization_id)' ); 
                 SET l_qryString =  CONCAT(l_qryString, CASE WHEN LENGTH(l_qryString)>0 THEN ' UNION ALL ' ELSE '' END);
            END IF;

        END WHILE processList;
        CLOSE c_get_qry_ids;
        SET done = 0;
        
        IF cnt = 1 THEN

            SET group_by_clause = '';

        ELSEIF cnt > 1 THEN 
            -- remove the last UNION ALL in the string
            SET l_qryString = SUBSTRING(l_qryString, 1, LENGTH(l_qryString)-10);
            SET group_by_clause = CONCAT(' GROUP BY p.patient_id, p.organization_id HAVING COUNT(*) = ', cnt-1);
        END IF;

    END;

    DROP TEMPORARY TABLE IF EXISTS qry_tmp;
    SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp AS 
    SELECT p.patient_id, p.person_id, p.organization_id FROM (', l_qryString,' ) p ',group_by_clause);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt; 

    ALTER TABLE qry_tmp ADD INDEX org_idx (organization_id);

    DROP TEMPORARY TABLE IF EXISTS qry_org;
    SET @sql = CONCAT("CREATE TEMPORARY TABLE qry_org AS 
    SELECT ", p_schema,".getOrganizationId(code) organization_id FROM org_tmp_", p_query_id);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt; 

    SET @sql = CONCAT('DROP TABLE IF EXISTS ', p_queryNumber, '_', p_query_id);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt; 

    SET @sql = CONCAT("CREATE TABLE ", p_queryNumber, "_", p_query_id," AS 
    SELECT p.patient_id, p.person_id, p.organization_id FROM qry_tmp p JOIN qry_org o ON p.organization_id = o.organization_id");
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt; 

    SET @sql = CONCAT('ALTER TABLE ', p_queryNumber, '_', p_query_id, ' ADD INDEX pat_idx (patient_id)');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

END//
DELIMITER ;
