USE dashboards;

DROP PROCEDURE IF EXISTS buildFinalPatientCohort;

DELIMITER //

CREATE PROCEDURE buildFinalPatientCohort (
    IN p_query_id INT,
    IN p_patientcohorttab VARCHAR(64),    
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

    SET @sql = CONCAT('DROP TABLE IF EXISTS ',p_patientcohorttab);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @sql = CONCAT('CREATE TABLE ',p_patientcohorttab,' AS 
    SELECT DISTINCT ',p_query_id ,' AS query_id, o.patient_id
    FROM ',p_observationcohorttab ,' o  
    WHERE ',p_includeExclude1String ,' AND ',p_includeExclude1aString ,
    ' AND ',p_includeExclude1bString ,' AND ',p_includeExclude2String ,
    ' AND ',p_includeExclude2aString ,' AND ',p_includeExclude3String ,
    ' AND ',p_includeExclude4String ,' AND ',p_includeExclude5String);

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @sql = CONCAT('ALTER TABLE ',p_patientcohorttab ,' ADD INDEX pat_idx(patient_id)');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;


END//
DELIMITER ;
