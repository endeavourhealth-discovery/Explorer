USE dashboards;


DROP PROCEDURE IF EXISTS createDataset;

DELIMITER //

CREATE PROCEDURE createDataset (
  p_query_id INT,
  p_patientcohorttab VARCHAR(64), 
  p_sourcetab VARCHAR(255), 
  p_col VARCHAR(64),
  p_event_type VARCHAR(50),
  p_datasetconcepttab VARCHAR(64), 
  p_codetypestab VARCHAR(64), 
  p_daterange VARCHAR(255), 
  p_activeString VARCHAR(255), 
  p_datasettab VARCHAR(64)
)

BEGIN 

    IF p_event_type = 'DEMOGRAPHICS' THEN
       SET @sql = CONCAT('INSERT INTO ', p_datasettab,'  
       SELECT DISTINCT p.query_id, o.id 
       FROM ', p_sourcetab,' o JOIN ', p_patientcohorttab,' p ON ', p_col,' = p.patient_id');
    END IF;

    IF p_event_type IN ('MEDICATION', 'ENCOUNTERS') THEN

       IF p_datasetconcepttab IS NOT NULL THEN
         SET @sql = CONCAT('INSERT INTO ', p_datasettab,' 
         SELECT DISTINCT p.query_id, o.id 
         FROM ', p_sourcetab,' o JOIN ', p_patientcohorttab,' p ON ', p_col,' = p.patient_id 
         JOIN ', p_datasetconcepttab,' c ON o.non_core_concept_id = c.non_core_concept_id 
         WHERE o.non_core_concept_id IS NOT NULL AND ', p_daterange,' AND ', p_activeString);
       ELSE
         SET @sql = CONCAT('INSERT INTO ', p_datasettab,' 
         SELECT DISTINCT p.query_id, o.id 
         FROM ', p_sourcetab,' o JOIN ', p_patientcohorttab,' p ON ', p_col,' = p.patient_id 
         WHERE o.non_core_concept_id IS NOT NULL AND ', p_daterange,' AND ', p_activeString);
       END IF;

    END IF;
    
    IF p_event_type = 'CLINICALEVENTS' THEN

       IF p_datasetconcepttab IS NOT NULL AND p_codetypestab IS NOT NULL THEN 
          SET @sql = CONCAT('INSERT INTO ', p_datasettab,' 
          SELECT DISTINCT p.query_id, o.id 
          FROM ', p_sourcetab,' o JOIN ', p_patientcohorttab,' p ON ', p_col,' = p.patient_id 
          JOIN ', p_datasetconcepttab,' c ON o.non_core_concept_id = c.non_core_concept_id  
          JOIN ', p_codetypestab,' ct ON o.non_core_concept_id = ct.non_core_concept_id 
          WHERE o.non_core_concept_id IS NOT NULL AND ', p_daterange,' AND ', p_activeString); 
       ELSEIF p_datasetconcepttab IS NOT NULL AND p_codetypestab IS NULL THEN 
          SET @sql = CONCAT('INSERT INTO ', p_datasettab,' 
          SELECT DISTINCT p.query_id, o.id 
          FROM ', p_sourcetab,' o JOIN ', p_patientcohorttab,' p ON ', p_col,' = p.patient_id 
          JOIN ', p_datasetconcepttab,' c ON o.non_core_concept_id = c.non_core_concept_id  
          WHERE o.non_core_concept_id IS NOT NULL AND ', p_daterange,' AND ', p_activeString);
       ELSEIF p_datasetconcepttab IS NULL AND p_codetypestab IS NOT NULL THEN 
          SET @sql = CONCAT('INSERT INTO ', p_datasettab,' 
          SELECT DISTINCT p.query_id, o.id 
          FROM ', p_sourcetab,' o JOIN ', p_patientcohorttab,' p ON ', p_col,' = p.patient_id 
          JOIN ', p_codetypestab,' ct ON o.non_core_concept_id = ct.non_core_concept_id 
          WHERE o.non_core_concept_id IS NOT NULL AND ', p_daterange,' AND ', p_activeString);
       ELSE
          SET @sql = CONCAT('INSERT INTO ', p_datasettab,' 
          SELECT DISTINCT p.query_id, o.id 
          FROM ', p_sourcetab,' o JOIN ', p_patientcohorttab,' p ON ', p_col,' = p.patient_id 
          WHERE o.non_core_concept_id IS NOT NULL AND ', p_daterange,' AND ', p_activeString);
       END IF;

    END IF;

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

END //
DELIMITER ;