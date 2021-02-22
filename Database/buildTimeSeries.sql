USE dashboards;

DROP PROCEDURE IF EXISTS buildTimeSeries;

DELIMITER //

CREATE PROCEDURE buildTimeSeries ( 
  p_timeSeries VARCHAR(30),
  p_seriesTable VARCHAR(50),
  p_seriesField VARCHAR(1000),
  p_seriesEncounterValueSet VARCHAR(1000),
  p_seriesMedicationValueSet VARCHAR(1000),
  p_seriesClinicalEventValueSet VARCHAR(1000),
  p_fromDate VARCHAR(30),
  p_toDate VARCHAR(30),
  p_periodOperator VARCHAR(50),
  p_periodValue VARCHAR(10), 
  p_periodType VARCHAR(20), 
  p_storetab VARCHAR(64),
  p_seriesValuesetTab VARCHAR(64),
  p_seriesConceptTab VARCHAR(64),
  p_schema VARCHAR(255),
  p_query_id INT,
  p_patientcohorttab VARCHAR(64)
)

BEGIN

  DECLARE dashboardResultsTab VARCHAR(64) DEFAULT NULL;
  DECLARE sourceTab VARCHAR(64) DEFAULT NULL;
  DECLARE seriesValueSetString VARCHAR(255) DEFAULT NULL;
  DECLARE seriesValueSet VARCHAR(1000) DEFAULT NULL;
  DECLARE seriesDateRange VARCHAR(255) DEFAULT NULL; 
  DECLARE seriesColumn VARCHAR(100) DEFAULT NULL;
  DECLARE join_clause_1 VARCHAR(255) DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(p_query_id, 'buildTimeSeries', @code, @msg, now());
        RESIGNAL; -- rethrow the error
    END;

  -- check date format passed
  SET p_fromDate = UPPER(p_fromDate);
  SET p_fromDate = IF(p_fromDate IN ('', 'NULL'), NULL, SUBSTRING(p_fromDate, 1, 10));
  SET p_toDate = UPPER(p_toDate);
  SET p_toDate = IF(p_toDate IN ('', 'NULL'), NULL, SUBSTRING(p_toDate, 1, 10));

  SET p_seriesTable = IF(p_seriesTable = '', NULL, p_seriesTable);
  SET p_seriesField = IF(p_seriesField = '', NULL, p_seriesField);

  SET p_seriesField = 'Concept term'; -- default value

   IF p_seriesTable = 'Clinical events' THEN
      SET seriesValueSet = p_seriesClinicalEventValueSet;
   ELSEIF p_seriesTable = 'Medication' THEN
      SET seriesValueSet = p_seriesMedicationValueSet;
   ELSEIF p_seriesTable = 'Encounters' THEN
      SET seriesValueSet = p_seriesEncounterValueSet;
   ELSE 
      SET seriesValueSet = NULL;
   END IF;

IF p_timeSeries = 'TRUE' AND 
   p_seriesTable IS NOT NULL AND
   p_seriesField IS NOT NULL AND 
   seriesValueSet IS NOT NULL THEN  -- if time series selected
  
   IF p_seriesTable = 'Clinical events' THEN
      SET sourceTab = 'observation';
   ELSEIF p_seriesTable = 'Medication' THEN
      SET sourceTab = 'medication_statement';
   ELSEIF p_seriesTable = 'Encounters' THEN
      SET sourceTab = 'encounter';
   END IF;
   -- get time series date range string
   SET seriesDateRange = getTimePeriodDateRange(p_fromDate, p_toDate, p_periodValue, p_periodType, p_periodOperator,'Y');    
   -- get time series value set string
   CALL getValueSetString(seriesValueSet, p_storetab, @seriesValueSetString);
   SET seriesValueSetString = @seriesValueSetString;
   -- create time series valueset
   CALL createValueSet(seriesValueSetString, p_seriesValuesetTab);
   -- create concept from time series valueset
   CALL createConcept(p_seriesConceptTab, p_seriesValuesetTab, p_schema);

   IF p_seriesField = 'Concept term' THEN -- to add more fields when available
      SET seriesColumn = 'cpt.value_set_code_type';
      SET join_clause_1 = CONCAT('JOIN ', p_seriesConceptTab,' cpt ON cpt.non_core_concept_id = o2.non_core_concept_id');
   END IF;
  
   SET dashboardResultsTab = CONCAT('dashboard_results_', p_query_id);
    -- drop dashboard results table if exists
   SET @sql = CONCAT('DROP TABLE IF EXISTS ', dashboardResultsTab);
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   -- create the dashboard results table
   SET @sql = CONCAT("CREATE TABLE ", dashboardResultsTab, " ( 
       `grouping` VARCHAR(100) DEFAULT NULL, 
       name VARCHAR(100) DEFAULT NULL, 
       series_name VARCHAR(100) DEFAULT NULL, 
       series_value INT DEFAULT NULL, 
       id BIGINT(20) NOT NULL AUTO_INCREMENT, 
       PRIMARY KEY (id), 
       KEY `grouping` (`grouping`), 
       KEY name (name), 
       KEY series_name (series_name) 
       ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1");
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   DROP TEMPORARY TABLE IF EXISTS qry_tmp;

   SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp ( 
       row_id INT, 
       `grouping` VARCHAR(100), 
       name VARCHAR(100), 
       series_name DATE,  
       series_value INT, PRIMARY KEY (row_id) 
   ) AS 
   SELECT (@row_no := @row_no + 1) AS row_id, 
         a.grouping,
         a.name,
         a.series_name,
         a.series_value
   FROM (SELECT  
         org2.name AS `grouping`,', 
         seriesColumn,' AS name, 
         o2.clinical_effective_date AS series_name, 
         COUNT(DISTINCT(o2.patient_id)) AS series_value 
   FROM ', p_patientcohorttab,' c JOIN ', p_schema,'.', sourceTab,' o2 
   ON c.patient_id = o2.patient_id AND c.organization_id = o2.organization_id ', 
   join_clause_1,' 
   JOIN ', p_schema,'.organization org ON org.id = o2.organization_id 
   LEFT JOIN ', p_schema,'.organization org2 ON org2.id = org.parent_organization_id 
   WHERE ', seriesDateRange,'  
   GROUP BY org2.name,', seriesColumn,', o2.clinical_effective_date) a JOIN (SELECT @row_no := 0) t 
   ORDER BY a.series_name, a.grouping'); 
   PREPARE stmt FROM @sql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @row_id = 0;
   
   WHILE EXISTS (SELECT row_id from qry_tmp WHERE row_id > @row_id AND row_id <= @row_id + 10000) DO

         SET @sql = CONCAT("INSERT INTO  ", dashboardResultsTab, " (`grouping`, name, series_name, series_value) 
         SELECT  q.grouping, q.name, q.series_name, q.series_value FROM qry_tmp q 
         WHERE q.row_id > @row_id AND q.row_id <= @row_id + 10000");
         PREPARE stmt FROM @sql;
         EXECUTE stmt;
         DEALLOCATE PREPARE stmt;

         SET @row_id = @row_id + 10000; 

   END WHILE; 

END IF;

END //
DELIMITER ;