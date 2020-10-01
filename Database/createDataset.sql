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

    IF p_datasetconcepttab IS NOT NULL THEN

       SET @sql = CONCAT('INSERT INTO ', p_datasettab,'  
       SELECT DISTINCT
              p.query_id, 
              o.id
       FROM ', p_sourcetab,' o JOIN ', p_patientcohorttab,' p ON ', p_col,' = p.patient_id 
                               JOIN ', p_datasetconcepttab,' c ON o.non_core_concept_id = c.non_core_concept_id 
       WHERE o.non_core_concept_id IS NOT NULL 
         AND ', p_daterange,
       ' AND ', p_activeString);

    ELSE

       SET @sql = CONCAT('INSERT INTO ', p_datasettab,'  
       SELECT DISTINCT
              p.query_id, 
              o.id
       FROM ', p_sourcetab,' o JOIN ', p_patientcohorttab,' p ON ', p_col,' = p.patient_id 
       WHERE ', p_daterange,
       ' AND ', p_activeString);

    END IF;

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

END //
DELIMITER ;