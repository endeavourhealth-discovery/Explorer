USE dashboards;

-- procedure to retrieve all the parent query ids
DROP PROCEDURE IF EXISTS getParentQueryIds;

DELIMITER //
CREATE PROCEDURE getParentQueryIds (IN p_query_id INT, OUT p_ids VARCHAR(255)) 
BEGIN
    DECLARE rv VARCHAR(255);
    DECLARE cm VARCHAR(10);
    DECLARE ch varchar(10);

    SET rv = '';
    SET cm = '';
    SET ch = p_query_id;

    WHILE ch > 0 DO

        SELECT IFNULL(b.parent_id, -1) INTO ch
        FROM (
        SELECT a.parent_id as parent_id
        FROM (
              SELECT q.id AS parent_id 
              FROM query_library q 
              WHERE q.name = (SELECT q2.denominator_query FROM query_library q2 WHERE q2.id = ch)
              AND NOT EXISTS (SELECT 1 FROM queue que 
                              WHERE que.query_id = q.id 
                              AND que.status = 'N' 
                              AND DATE_FORMAT(que.timefinish,'%Y-%m-%d') = curdate())
              ) a
       UNION
       SELECT NULL AS parent_id
        ) b   LIMIT 1;                  
                                      
                         
        IF ch > 0 THEN
            SET rv = CONCAT(rv,cm,ch);
            SET cm = ',';
        END IF;
    END WHILE;

    SET p_ids = rv;
    
END //
DELIMITER ;