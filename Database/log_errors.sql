USE dashboards;

DROP PROCEDURE IF EXISTS log_errors;

DELIMITER //

CREATE PROCEDURE log_errors(p_query_id INT, p_proc_name VARCHAR(255), p_error_code VARCHAR(1000), p_error_text VARCHAR(1000), p_error_date DATETIME)

BEGIN

INSERT INTO error_log (query_id, proc_name, error_code, error_text, error_date)
VALUES (p_query_id, p_proc_name, p_error_code, p_error_text, p_error_date);

END //
DELIMITER ;