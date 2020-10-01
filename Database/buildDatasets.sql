USE dashboards;

DROP PROCEDURE IF EXISTS buildDatasets;

DELIMITER //

CREATE PROCEDURE buildDatasets (
  p_query_id INT,
  p_patientcohorttab VARCHAR(64),
  p_event_type VARCHAR(500),
  p_datasetconcepttab VARCHAR(64),
  p_daterange VARCHAR(255),
  p_active VARCHAR(10),
  p_schema VARCHAR(255)
)
BEGIN

  DECLARE sourcetab VARCHAR(255);
  DECLARE activeString VARCHAR(255);
  DECLARE datasettab VARCHAR(255);
  DECLARE datasetconcepttab VARCHAR(255);
  DECLARE daterange VARCHAR(255);
  DECLARE sourcecol VARCHAR(64);

  DECLARE front VARCHAR(500) DEFAULT NULL;
  DECLARE frontlen INT DEFAULT NULL;
  DECLARE TempValue VARCHAR(500) DEFAULT NULL;

    processloop:
    LOOP  

       IF LENGTH(TRIM(p_event_type)) = 0 OR p_event_type IS NULL THEN
         LEAVE processloop;
       END IF;

      -- retrieve event type from comma separated list
      SET front = SUBSTRING_INDEX(p_event_type, ',', 1);
      SET frontlen = LENGTH(front);
      SET TempValue = TRIM(front);

             -- process each event type if exists
             IF TempValue = 'PERSON'THEN
                SET sourcetab = CONCAT(p_schema,'.patient');
                SET sourcecol = 'o.id';
                SET activeString = '1';  -- not applicable
                SET datasettab = 'person_dataset';
                SET datasetconcepttab = NULL;  -- no valueset for patient
                SET daterange = '1';  -- no valueset date range for patient
             ELSEIF TempValue = 'CLINICAL EVENTS' THEN
                SET sourcetab = CONCAT(p_schema,'.observation');
                SET sourcecol = 'o.patient_id';
                IF p_active = 'TRUE' THEN
                   SET activeString = 'o.problem_end_date IS NULL';
                ELSE
                   SET activeString = '1';
                END IF;
                SET datasettab = 'observation_dataset';
                SET datasetconcepttab = p_datasetconcepttab;
                SET daterange = p_daterange;
             ELSEIF TempValue = 'MEDICATION' THEN
                SET sourcetab = CONCAT(p_schema,'.medication_statement');
                SET sourcecol = 'o.patient_id';
                IF p_active = 'TRUE' THEN
                   SET activeString = 'o.cancellation_date is NULL';
                ELSE
                   SET activeString = '1';
                END IF;
                SET datasettab = 'medication_dataset';
                SET datasetconcepttab = p_datasetconcepttab;
                SET daterange = p_daterange;
             ELSEIF TempValue = 'ENCOUNTERS' THEN
                SET sourcetab = CONCAT(p_schema,'.encounter');
                SET sourcecol = 'o.patient_id';
                SET activeString = '1';  -- not applicable
                SET datasettab = 'encounters_dataset';
                SET datasetconcepttab = p_datasetconcepttab;
                SET daterange = p_daterange;
             END IF;

    CALL createDataset(p_query_id, p_patientcohorttab, sourcetab, sourcecol, datasetconcepttab, daterange, activeString, datasettab);
    SET p_event_type = INSERT(p_event_type, 1, frontlen + 1, '');
    
    END LOOP;


END //
DELIMITER ;