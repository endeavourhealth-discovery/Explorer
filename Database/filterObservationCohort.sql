USE dashboards;

DROP PROCEDURE IF EXISTS filterObservationCohort;

DELIMITER //

CREATE PROCEDURE filterObservationCohort (
    IN p_filterobservationtab VARCHAR(64),    
    IN p_observationcohorttab VARCHAR(64),    
    IN p_includeExclude1String VARCHAR(1000),
    IN p_includeExclude1aString VARCHAR(1000),
    IN p_includeExclude1bString VARCHAR(1000),
    IN p_includeExclude2String VARCHAR(1000),
    IN p_includeExclude2aString VARCHAR(1000),
    IN p_includeExclude3String VARCHAR(1000),
    IN p_includeExclude4String VARCHAR(1000),
    IN p_includeExclude5String VARCHAR(1000) 
)

BEGIN

    SET @sql = CONCAT('DROP TABLE IF EXISTS ',p_filterobservationtab);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @sql = CONCAT('CREATE TABLE ',p_filterobservationtab,' AS 
    SELECT DISTINCT
          o.patient_id,
          o.person_id,
          o.nhs_number,
          o.date_of_birth,
          o.date_of_death,
          o.age,
          o.gender,
          o.organization_name,
          o.organization_id,
          o.ods_code,
          o.postcode,
          o.clinical_effective_date,
          o.original_code,
          o.original_term,
          o.result_value,
          o.result_value_units,
          o.non_core_concept_id
    FROM ',p_observationcohorttab ,' o  
    WHERE ',p_includeExclude1String ,' AND ',p_includeExclude1aString ,
    ' AND ',p_includeExclude1bString ,' AND ',p_includeExclude2String ,
    ' AND ',p_includeExclude2aString ,' AND ',p_includeExclude3String ,
    ' AND ',p_includeExclude4String ,' AND ',p_includeExclude5String);

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @sql = CONCAT('ALTER TABLE ',p_filterobservationtab ,' ADD INDEX pat_idx(patient_id)');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @sql = CONCAT('ALTER TABLE ',p_filterobservationtab ,' ADD INDEX non_core_concept_idx(non_core_concept_id)');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @sql = CONCAT('ALTER TABLE ',p_filterobservationtab ,' ADD INDEX clinical_eff_date_idx(clinical_effective_date)');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

END//
DELIMITER ;


 