USE dashboards;


DROP PROCEDURE IF EXISTS createDataset;

DELIMITER //

CREATE PROCEDURE createDataset (
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

    SET @sql = CONCAT('DROP TABLE IF EXISTS ', p_datasettab);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @sql = CONCAT('CREATE TABLE ', p_datasettab,' AS 
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

    SET @sql = CONCAT('ALTER TABLE ',p_datasettab ,' ADD PRIMARY KEY id_ix(id)');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

END //
DELIMITER ;