USE dashboards;

DROP PROCEDURE IF EXISTS filterEventsByRank;

DELIMITER //
CREATE PROCEDURE filterEventsByRank(
  p_patientcohorttab VARCHAR(64), 
  p_datasetconcepttab VARCHAR(64), 
  p_daterange VARCHAR(255), 
  p_activeString VARCHAR(255), 
  p_sourcetab VARCHAR(64), 
  p_schema VARCHAR(255), 
  p_occurrence VARCHAR(30),
  p_occurrenceNumber VARCHAR(10)
)

BEGIN

  DECLARE order_type VARCHAR(50);
  DECLARE rank_no VARCHAR(50);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(p_query_id, 'filterEventsByRank', @code, @msg, now());
        RESIGNAL; -- rethrow the error
    END; 

    IF UPPER(p_occurrence) = 'ALL' THEN
        SET order_type = 'DESC';
        -- IF p_occurrenceNumber IS NOT NULL OR  LENGTH(TRIM(p_occurrenceNumber))<> 0 THEN
        IF LENGTH(TRIM(p_occurrenceNumber))<> 0 THEN
           SET rank_no = CONCAT(' <= ', p_occurrenceNumber);
        ELSE
           SET rank_no = ' > 0 ';
        END IF;
    ELSEIF UPPER(p_occurrence) = 'LATEST' THEN 
        SET order_type = 'DESC';
        -- IF p_occurrenceNumber IS NOT NULL OR  LENGTH(TRIM(p_occurrenceNumber)) <> 0 THEN
        IF LENGTH(TRIM(p_occurrenceNumber)) <> 0 THEN
           SET rank_no = CONCAT(' <= ', p_occurrenceNumber);
        ELSE
           SET rank_no = ' = 1 ';  -- get latest if no number specified
        END IF;
    ELSEIF UPPER(p_occurrence) = 'EARLIEST' THEN 
        SET order_type = 'ASC';
        -- IF p_occurrenceNumber IS NOT NULL OR  LENGTH(TRIM(p_occurrenceNumber)) <> 0 THEN
        IF LENGTH(TRIM(p_occurrenceNumber)) <> 0 THEN
           SET rank_no = CONCAT(' <= ', p_occurrenceNumber);
        ELSE
           SET rank_no = ' = 1 ';  -- get earliest if no number specified
        END IF;
    ELSE  -- everything in ascending order
        SET order_type = 'ASC';   
        SET rank_no = ' > 0 ';
    END IF; 
       
    DROP TEMPORARY TABLE IF EXISTS qry_ob_tmp;

    SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_ob_tmp AS
    SELECT p.query_id, o.id, o.patient_id, o.clinical_effective_date, p.ods_code, c.value_set_code_type  
    FROM ', p_patientcohorttab,' p JOIN ', p_schema, '.', p_sourcetab,' o ON o.patient_id = p.patient_id 
    AND o.organization_id = p.organization_id AND o.person_id = p.person_id 
    JOIN ', p_datasetconcepttab,' c ON o.non_core_concept_id = c.non_core_concept_id  
    WHERE o.non_core_concept_id IS NOT NULL AND ', p_daterange,' AND ', p_activeString); 
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    DROP TEMPORARY TABLE IF EXISTS qry_eventsbyrank_tmp;

    SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_eventsbyrank_tmp AS 
    SELECT 
          ob.query_id,
          ob.id,
          ob.patient_id,
          ob.ods_code,
          ob.clinical_effective_date,
          ob.value_set_code_type,
          ob.rnk 
    FROM ( 
      SELECT 
          o2.query_id,
          o2.id,
          o2.patient_id,
          o2.ods_code,
          o2.clinical_effective_date,
          o2.value_set_code_type,
          @currank := IF(@curpatient = BINARY o2.patient_id AND @curvaluetype = BINARY o2.value_set_code_type, @currank + 1, 1) AS rnk,
          @curpatient := o2.patient_id AS cur_patient,
          @curvaluetype := o2.value_set_code_type AS cur_valuetype
          FROM qry_ob_tmp o2 JOIN (SELECT @currank := 0, @curpatient := 0, @curvaluetype := 0) r 
          WHERE o2.clinical_effective_date IS NOT NULL 
          ORDER BY o2.patient_id, o2.value_set_code_type, o2.clinical_effective_date ',order_type,', o2.id ', order_type,'  
          ) ob 
      WHERE ob.rnk ', rank_no);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

     ALTER TABLE qry_eventsbyrank_tmp ADD INDEX pat_idx(patient_id);

END//
DELIMITER ;