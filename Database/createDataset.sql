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

 DECLARE datasetconceptString VARCHAR(500);

    IF p_datasetconcepttab IS NOT NULL THEN
      SET datasetconceptString = CONCAT('EXISTS (SELECT 1 FROM ',p_datasetconcepttab ,' c WHERE o.non_core_concept_id = c.non_core_concept_id )');
    ELSE
      SET datasetconceptString = '1';
    END IF;

    SET @sql = CONCAT('DELETE FROM ', p_datasettab ,' WHERE query_id = ',p_query_id);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @sql = CONCAT('INSERT INTO ', p_datasettab,'  
    SELECT DISTINCT
           p.query_id, 
           o.id
    FROM ',p_sourcetab ,' o JOIN ', p_patientcohorttab ,' p ON ',p_col ,' = p.patient_id 
    WHERE ', datasetconceptString ,
    ' AND ', p_daterange,
    ' AND ', p_activeString);

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

END //
DELIMITER ;