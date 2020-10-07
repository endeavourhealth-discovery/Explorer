USE dashboards;

DROP PROCEDURE IF EXISTS createQueueTab;

DELIMITER //

CREATE PROCEDURE createQueueTab()

BEGIN

DROP TABLE IF EXISTS queue;

CREATE TABLE queue (
id                  INT NOT NULL AUTO_INCREMENT,
query_id            INT,
query               TEXT,
query_last_updated  DATETIME,
next_run_date       DATE DEFAULT NULL,
status              VARCHAR(10) DEFAULT 'N', -- A active i.e. processing, N not processed
timesubmit          DATETIME DEFAULT NULL,
timefinish          DATETIME DEFAULT NULL,
timeexecute         VARCHAR(100) DEFAULT NULL, 
primary key (id)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;


END //
DELIMITER ;
