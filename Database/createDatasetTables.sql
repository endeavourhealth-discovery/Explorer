USE dashboards;


DROP PROCEDURE IF EXISTS createDatasetTables;

DELIMITER //

CREATE PROCEDURE createDatasetTables()

BEGIN

DROP TABLE IF EXISTS person_dataset;

CREATE TABLE person_dataset (
  query_id INT(11) NOT NULL,
  patient_id BIGINT(20) NOT NULL,
  PRIMARY KEY (query_id, patient_id)
) ENGINE=InnoDB CHARSET=latin1;

DROP TABLE IF EXISTS observation_dataset;

CREATE TABLE observation_dataset (
  query_id INT(11) NOT NULL,
  observation_id BIGINT(20) NOT NULL,
  PRIMARY KEY (query_id, observation_id)
) ENGINE=InnoDB CHARSET=latin1;

DROP TABLE IF EXISTS medication_dataset;

CREATE TABLE medication_dataset (
  query_id INT(11) NOT NULL,
  medication_id BIGINT(20) NOT NULL,
  PRIMARY KEY (query_id, medication_id)
) ENGINE=InnoDB CHARSET=latin1;

DROP TABLE IF EXISTS encounter_dataset;

CREATE TABLE encounter_dataset (
  query_id INT(11) NOT NULL,
  encounter_id BIGINT(20) NOT NULL,
  PRIMARY KEY (query_id, encounter_id)
) ENGINE=InnoDB CHARSET=latin1;



END //
DELIMITER ;