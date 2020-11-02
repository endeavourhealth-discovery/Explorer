USE dashboards;


DROP PROCEDURE IF EXISTS createDatsetResultsHist;

DELIMITER //

CREATE PROCEDURE createDatsetResultsHist()

BEGIN

DROP TABLE IF EXISTS dataset_results_hist;

CREATE TABLE dataset_results_hist (
  id  INT(11) NOT NULL AUTO_INCREMENT,       
  query_id INT(11) NOT NULL,
  dataset VARCHAR(100) NOT NULL,
  total INT(11) NOT NULL,
  date DATETIME NOT NULL, 
  PRIMARY KEY (id) 
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;


ALTER TABLE dataset_results_hist ADD INDEX query_idx(query_id);


END //
DELIMITER ;