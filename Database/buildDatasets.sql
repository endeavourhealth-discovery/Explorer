USE dashboards;

DROP PROCEDURE IF EXISTS buildDatasets;

DELIMITER //

CREATE PROCEDURE buildDatasets (
  p_query_id INT,
  p_patientcohorttab VARCHAR(64),
  p_eventTypeString VARCHAR(500),
  p_encountersDateRangeString VARCHAR(255),
  p_encounterConcept_tmp VARCHAR(64),
  p_medicationDateRangeString VARCHAR(255),
  p_medicationConcept_tmp VARCHAR(64),
  p_currentMedication VARCHAR(10),
  p_clinicalEventsDateRangeString VARCHAR(255),
  p_clinicalEventConcept_tmp VARCHAR(64),
  p_selectedClinicalTypes VARCHAR(1000),
  p_procedure_req_tmp VARCHAR(64),
  p_diagnostic_tmp VARCHAR(64),
  p_warning_tmp VARCHAR(64),
  p_allergy_tmp VARCHAR(64),
  p_referral_req_tmp VARCHAR(64),
  p_activeProblems VARCHAR(10),
  p_org_tmp VARCHAR(64), 
  p_schema VARCHAR(255)
)

BEGIN

  DECLARE sourcetab VARCHAR(255);
  DECLARE activeString VARCHAR(255);
  DECLARE datasettab VARCHAR(255);
  DECLARE datasetconcepttab VARCHAR(255);
  DECLARE daterange VARCHAR(255);

  DECLARE front VARCHAR(500) DEFAULT NULL;
  DECLARE frontlen INT DEFAULT NULL;
  DECLARE TempValue VARCHAR(500) DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(p_query_id, 'buildDatasets', @code, @msg, now());
        RESIGNAL; -- rethrow the error
    END;  

CREATE TABLE IF NOT EXISTS person_dataset (
  query_id INT(11) NOT NULL, patient_id BIGINT(20) NOT NULL, ods_code VARCHAR(50) NOT NULL, 
  PRIMARY KEY (query_id, patient_id, ods_code), INDEX pat_idx (patient_id) ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS observation_dataset (
  query_id INT(11) NOT NULL, observation_id BIGINT(20) NOT NULL, ods_code VARCHAR(50) NOT NULL, 
  PRIMARY KEY (query_id, observation_id, ods_code), INDEX obs_idx (observation_id)  ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS medication_dataset (
  query_id INT(11) NOT NULL, medication_statement_id BIGINT(20) NOT NULL, ods_code VARCHAR(50) NOT NULL, 
  PRIMARY KEY (query_id, medication_statement_id, ods_code), INDEX med_idx (medication_statement_id)  ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS encounter_dataset (
  query_id INT(11) NOT NULL, encounter_id BIGINT(20) NOT NULL, ods_code VARCHAR(50) NOT NULL,  
  PRIMARY KEY (query_id, encounter_id, ods_code), INDEX enc_idx (encounter_id)  ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
  
    -- remove previous query id data
    SET @sql = CONCAT('DELETE FROM person_dataset WHERE query_id = ', p_query_id, ' AND ods_code IN (SELECT code FROM ', p_org_tmp,')');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @sql = CONCAT('DELETE FROM observation_dataset WHERE query_id = ', p_query_id, ' AND ods_code IN (SELECT code FROM ', p_org_tmp,')');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @sql = CONCAT('DELETE FROM medication_dataset WHERE query_id = ', p_query_id, ' AND ods_code IN (SELECT code FROM ', p_org_tmp,')');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @sql = CONCAT('DELETE FROM encounter_dataset WHERE query_id = ', p_query_id, ' AND ods_code IN (SELECT code FROM ', p_org_tmp,')');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

   -- always process DEMOGRAPHICS to get result dataset
   IF LENGTH(TRIM(p_eventTypeString)) = 0 OR p_eventTypeString IS NULL THEN
      SET p_eventTypeString = 'DEMOGRAPHICS';
   ELSE
        IF LOCATE('DEMOGRAPHICS', p_eventTypeString) = 0 THEN
           SET p_eventTypeString = CONCAT(p_eventTypeString,',DEMOGRAPHICS');
        END IF;
   END IF;

    processloop:
    LOOP  

       IF LENGTH(TRIM(p_eventTypeString)) = 0 OR p_eventTypeString IS NULL THEN
         LEAVE processloop;
       END IF;

      -- retrieve event type from comma separated list
      SET front = SUBSTRING_INDEX(p_eventTypeString, ',', 1);
      SET frontlen = LENGTH(front);
      SET TempValue = TRIM(front);

         -- process each event type if exists
         IF TempValue = 'DEMOGRAPHICS'THEN
            SET sourcetab ='patient';
            SET activeString = '1';  -- not applicable
            SET datasettab = 'person_dataset';
            SET datasetconcepttab = NULL;  -- no valueset for patient
            SET daterange = '1';  -- no valueset date range for patient
         ELSEIF TempValue = 'CLINICALEVENTS' THEN
            SET sourcetab ='observation';
            IF p_activeProblems = 'TRUE' THEN
               SET activeString = 'o.problem_end_date IS NULL';
            ELSE
               SET activeString = '1';
            END IF;
            SET datasettab = 'observation_dataset';
            SET datasetconcepttab = p_clinicalEventConcept_tmp;
            SET daterange = p_clinicalEventsDateRangeString;
         ELSEIF TempValue = 'MEDICATION' THEN
            SET sourcetab ='medication_statement';
            IF p_currentMedication = 'TRUE' THEN
               SET activeString = 'o.cancellation_date is NULL';
            ELSE
               SET activeString = '1';
            END IF;
            SET datasettab = 'medication_dataset';
            SET datasetconcepttab = p_medicationConcept_tmp;
            SET daterange = p_medicationDateRangeString;
         ELSEIF TempValue = 'ENCOUNTERS' THEN
            SET sourcetab ='encounter';
            SET activeString = '1';  -- not applicable
            SET datasettab = 'encounter_dataset';
            SET datasetconcepttab = p_encounterConcept_tmp;
            SET daterange = p_encountersDateRangeString;
         END IF;

    -- create dataset
    CALL createDataset(p_query_id, p_patientcohorttab, sourcetab, TempValue, datasetconcepttab, p_selectedClinicalTypes, daterange, activeString, datasettab,
    p_procedure_req_tmp, p_diagnostic_tmp, p_warning_tmp, p_allergy_tmp, p_referral_req_tmp, p_schema);
    -- fetch next event type
    SET p_eventTypeString = INSERT(p_eventTypeString, 1, frontlen + 1, '');
    
    END LOOP;

END //
DELIMITER ;