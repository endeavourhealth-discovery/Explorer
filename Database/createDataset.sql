USE dashboards;


DROP PROCEDURE IF EXISTS createDataset;

DELIMITER //

CREATE PROCEDURE createDataset (
  p_query_id INT,
  p_patientcohorttab VARCHAR(64), 
  p_sourcetab VARCHAR(255), 
  p_col VARCHAR(64),
  p_datasetconcepttab VARCHAR(64), 
  p_daterange VARCHAR(255), 
  p_activeString VARCHAR(255), 
  p_datasettab VARCHAR(64)
)

BEGIN

CREATE TABLE IF NOT EXISTS person_dataset (
  query_id INT(11) NOT NULL, patient_id BIGINT(20) NOT NULL,
  PRIMARY KEY (query_id, patient_id) ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS observation_dataset (
  query_id INT(11) NOT NULL, observation_id BIGINT(20) NOT NULL,
  PRIMARY KEY (query_id, observation_id) ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS medication_dataset (
  query_id INT(11) NOT NULL, medication_id BIGINT(20) NOT NULL,
  PRIMARY KEY (query_id, medication_id) ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS encounter_dataset (
  query_id INT(11) NOT NULL, encounter_id BIGINT(20) NOT NULL, 
  PRIMARY KEY (query_id, encounter_id) ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

    IF p_datasetconcepttab IS NOT NULL THEN

       SET @sql = CONCAT('INSERT INTO ', p_datasettab,'  
       SELECT DISTINCT 
              p.query_id, 
              o.id 
       FROM ', p_sourcetab,' o JOIN ', p_patientcohorttab,' p ON ', p_col,' = p.patient_id 
       JOIN ', p_datasetconcepttab,' c ON o.non_core_concept_id = c.non_core_concept_id 
       WHERE o.non_core_concept_id IS NOT NULL 
       AND ', p_daterange,' AND ', p_activeString);

    ELSE

       SET @sql = CONCAT('INSERT INTO ', p_datasettab,'  
       SELECT DISTINCT 
              p.query_id, 
              o.id 
       FROM ', p_sourcetab,' o JOIN ', p_patientcohorttab,' p ON ', p_col,' = p.patient_id 
       WHERE ', p_daterange,' AND ', p_activeString);

    END IF;

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

END //
DELIMITER ;