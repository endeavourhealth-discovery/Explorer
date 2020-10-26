USE dashboards;

DROP PROCEDURE IF EXISTS createErrorLogTab;

DELIMITER //

CREATE PROCEDURE createErrorLogTab()

BEGIN

DROP TABLE IF EXISTS error_log;

CREATE TABLE error_log (
  id BIGINT NOT NULL AUTO_INCREMENT,  
  query_id INT,
  proc_name VARCHAR(255) NOT NULL,     
  error_code VARCHAR(1000) NOT NULL,
  error_text VARCHAR(1000) NOT NULL,
  error_date DATETIME NOT NULL,
  PRIMARY KEY (id) 
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

ALTER TABLE error_log ADD INDEX query_idx(query_id);


END //
DELIMITER ;


