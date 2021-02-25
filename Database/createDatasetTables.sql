USE dashboards;


DROP PROCEDURE IF EXISTS createDatasetTables;

DELIMITER //

CREATE PROCEDURE createDatasetTables()

BEGIN

DROP TABLE IF EXISTS person_dataset;

CREATE TABLE person_dataset (
  query_id INT(11) NOT NULL, patient_id BIGINT(20) NOT NULL, ods_code VARCHAR(50) NOT NULL, 
  PRIMARY KEY (query_id, patient_id, ods_code), INDEX pat_idx (patient_id) ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS observation_dataset;

CREATE TABLE observation_dataset (
  query_id INT(11) NOT NULL, observation_id BIGINT(20) NOT NULL, ods_code VARCHAR(50) NOT NULL, 
  PRIMARY KEY (query_id, observation_id, ods_code), INDEX obs_idx (observation_id) ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS medication_dataset;

CREATE TABLE medication_dataset (
  query_id INT(11) NOT NULL, medication_statement_id BIGINT(20) NOT NULL, ods_code VARCHAR(50) NOT NULL, 
  PRIMARY KEY (query_id, medication_statement_id, ods_code), INDEX med_idx (medication_statement_id) ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS encounter_dataset;

CREATE TABLE encounter_dataset (
  query_id INT(11) NOT NULL, encounter_id BIGINT(20) NOT NULL, ods_code VARCHAR(50) NOT NULL,  
  PRIMARY KEY (query_id, encounter_id, ods_code), INDEX enc_idx (encounter_id) ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

END //
DELIMITER ;

