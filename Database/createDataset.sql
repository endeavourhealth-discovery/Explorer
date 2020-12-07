USE dashboards;


DROP PROCEDURE IF EXISTS createDataset;

DELIMITER //

CREATE PROCEDURE createDataset (
  p_query_id INT,
  p_patientcohorttab VARCHAR(64), 
  p_sourcetab VARCHAR(255), 
  p_event_type VARCHAR(50),
  p_datasetconcepttab VARCHAR(64), 
  p_selectedClinicalTypes VARCHAR(1000), 
  p_daterange VARCHAR(255), 
  p_activeString VARCHAR(255), 
  p_datasettab VARCHAR(64),
  p_procedure_req_tmp VARCHAR(64),
  p_diagnostic_tmp VARCHAR(64),
  p_warning_tmp VARCHAR(64),
  p_allergy_tmp VARCHAR(64),
  p_referral_req_tmp VARCHAR(64),
  p_schema VARCHAR(255)
)

BEGIN 

DECLARE clinicalTypeString VARCHAR(1000);

DECLARE front VARCHAR(500) DEFAULT NULL;
DECLARE frontlen INT DEFAULT NULL;
DECLARE clinicalType VARCHAR(100);

    IF p_event_type = 'DEMOGRAPHICS' THEN
       SET @sql = CONCAT('INSERT INTO ', p_datasettab,'  
       SELECT DISTINCT p.query_id, o.id 
       FROM ', p_sourcetab,' o JOIN ', p_patientcohorttab,' p ON o.id = p.patient_id AND o.person_id = p.person_id AND o.organization_id = p.organization_id');
       PREPARE stmt FROM @sql;
       EXECUTE stmt;
       DEALLOCATE PREPARE stmt;
    END IF;

    IF p_event_type IN ('MEDICATION', 'ENCOUNTERS') THEN

       IF p_datasetconcepttab IS NOT NULL THEN
         SET @sql = CONCAT('INSERT INTO ', p_datasettab,' 
         SELECT DISTINCT p.query_id, o.id 
         FROM ', p_sourcetab,' o JOIN ', p_patientcohorttab,' p ON o.patient_id = p.patient_id AND o.person_id = p.person_id AND o.organization_id = p.organization_id 
         JOIN ', p_datasetconcepttab,' c ON o.non_core_concept_id = c.non_core_concept_id 
         WHERE o.non_core_concept_id IS NOT NULL AND ', p_daterange,' AND ', p_activeString);
         PREPARE stmt FROM @sql;
         EXECUTE stmt;
         DEALLOCATE PREPARE stmt;
       ELSE
         SET @sql = CONCAT('INSERT INTO ', p_datasettab,' 
         SELECT DISTINCT p.query_id, o.id 
         FROM ', p_sourcetab,' o JOIN ', p_patientcohorttab,' p ON o.patient_id = p.patient_id AND o.person_id = p.person_id AND o.organization_id = p.organization_id 
         WHERE o.non_core_concept_id IS NOT NULL AND ', p_daterange,' AND ', p_activeString);
         PREPARE stmt FROM @sql;
         EXECUTE stmt;
         DEALLOCATE PREPARE stmt;
       END IF;

    END IF;

    SET clinicalTypeString = p_selectedClinicalTypes;
    
    IF p_event_type = 'CLINICALEVENTS' THEN

      -- create a temporary dataset table 
      DROP TEMPORARY TABLE IF EXISTS qry_dataset;
      CREATE TEMPORARY TABLE qry_dataset 
      (query_id INT(11) NOT NULL, id BIGINT(20) NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=latin1;

         IF LENGTH(TRIM(clinicalTypeString)) <> 0 OR clinicalTypeString IS NOT NULL THEN

            -- create a copy of concept map and add index to core
            DROP TEMPORARY TABLE IF EXISTS qry_cpt_map;
            SET @sql = CONCAT("CREATE TEMPORARY TABLE qry_cpt_map AS
            SELECT legacy, core FROM ", p_schema,".concept_map 
            WHERE deleted = 0");
            PREPARE stmt FROM @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            ALTER TABLE qry_cpt_map ADD INDEX core_idx(core);

            -- create a temporary table to hold code category values
            DROP TEMPORARY TABLE IF EXISTS qry_code_cat;
            SET @sql = CONCAT("CREATE TEMPORARY TABLE qry_code_cat AS 
            SELECT cv.code_category_id, cv.concept_dbid, cc.description 
            FROM ", p_schema,".code_category_values cv JOIN ", p_schema,".code_category cc ON cv.code_category_id = cc.id");
            PREPARE stmt FROM @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            ALTER TABLE qry_code_cat ADD INDEX cpt_idx(concept_dbid); 
            ALTER TABLE qry_code_cat ADD INDEX descr_idx(description);  

                  -- loop through each selected clinical type to process if exists
                  processloop:
                  LOOP  

                       IF LENGTH(TRIM(clinicalTypeString)) = 0 OR clinicalTypeString IS NULL THEN
                          LEAVE processloop;
                       END IF;

                       SET front = SUBSTRING_INDEX(clinicalTypeString, ',', 1);
                       SET frontlen = LENGTH(front);
                       SET clinicalType = TRIM(front);

                       IF clinicalType IN ('Biochemistry', 'Biological values', 'Cytology/histology','Haematology', 'Immunology', 
                       'Microbiology','Obstetrics/birth', 'Pathology', 'Personal health/social', 'Radiology', 'Diagnostic results') THEN 

                              IF clinicalType = 'Cytology/histology' THEN
                                    SET clinicalType = 'Cytology/Histology';
                              ELSEIF clinicalType = 'Obstetrics/birth' THEN
                                    SET clinicalType = 'Obstetrics and Birth';
                              ELSEIF clinicalType = 'Pathology' THEN
                                    SET clinicalType = 'Pathology specimen';
                              ELSEIF clinicalType = 'Personal health/social' THEN
                                    SET clinicalType = 'Personal Health and Social';
                              ELSEIF clinicalType = 'Diagnostic results' THEN
                                    SET clinicalType = 'Diagnostics';
                              END IF;

                              -- find all concepts for the clinical type
                              DROP TEMPORARY TABLE IF EXISTS qry_concept;
                              SET @sql = CONCAT("CREATE TEMPORARY TABLE qry_concept AS 
                              SELECT COALESCE(cm.legacy, cv.concept_dbid) non_core_concept_id 
                              FROM qry_code_cat cv JOIN ", p_schema,".concept c ON c.dbid = cv.concept_dbid 
                              LEFT JOIN qry_cpt_map cm ON cv.concept_dbid = cm.core 
                              WHERE cv.description = ", QUOTE(clinicalType));
                              PREPARE stmt FROM @sql;
                              EXECUTE stmt;
                              DEALLOCATE PREPARE stmt;

                              ALTER TABLE qry_concept ADD INDEX cpt_idx(non_core_concept_id);

                              -- insert observation results into a temporary table
                              SET @sql = CONCAT('INSERT INTO qry_dataset 
                              SELECT DISTINCT p.query_id, o.id 
                              FROM ', p_sourcetab,' o JOIN ', p_patientcohorttab,' p ON o.patient_id = p.patient_id 
                              AND o.person_id = p.person_id AND o.organization_id = p.organization_id 
                              JOIN qry_concept cpt ON o.non_core_concept_id = cpt.non_core_concept_id 
                              WHERE o.non_core_concept_id IS NOT NULL AND ', p_daterange,' AND ', p_activeString); 
                              PREPARE stmt FROM @sql;
                              EXECUTE stmt;
                              DEALLOCATE PREPARE stmt;

                       ELSEIF clinicalType = 'Observations' THEN

                              DROP TEMPORARY TABLE IF EXISTS qry_concept;
                              SET @sql = CONCAT("CREATE TEMPORARY TABLE qry_concept AS 
                              SELECT cv.code_category_id, COALESCE(cm.legacy, cv.concept_dbid) non_core_concept_id 
                              FROM qry_code_cat cv JOIN ", p_schema,".concept c ON c.dbid = cv.concept_dbid 
                              LEFT JOIN qry_cpt_map cm ON cv.concept_dbid = cm.core 
                              WHERE cv.code_category_id IN (17,21,37) "); -- Family history, Immunisations, Procedure code
                              PREPARE stmt FROM @sql;
                              EXECUTE stmt;
                              DEALLOCATE PREPARE stmt;

                              ALTER TABLE qry_concept ADD INDEX cpt_idx(non_core_concept_id);

                              SET @sql = CONCAT("INSERT INTO qry_dataset 
                              SELECT DISTINCT p.query_id, o.id 
                              FROM ", p_sourcetab," o JOIN ", p_patientcohorttab," p ON o.patient_id = p.patient_id 
                              AND o.person_id = p.person_id AND o.organization_id = p.organization_id 
                              JOIN ", p_schema,".concept cpt ON o.non_core_concept_id = cpt.non_core_concept_id 
                              WHERE ( cpt.name NOT LIKE '%procedure%' 
                              AND cpt.name NOT LIKE '%family history%' 
                              AND cpt.name NOT LIKE '%FH:%'  
                              AND cpt.name NOT LIKE '%immunisation%' 
                              AND cpt.name NOT LIKE '%vaccination%' 
                              OR NOT EXISTS (SELECT 1 FROM qry_concept q WHERE q.non_core_concept_id = o.non_core_concept_id) )
                              AND o.is_problem = 0 
                              AND o.non_core_concept_id IS NOT NULL AND ", p_daterange," AND ", p_activeString); 
                              PREPARE stmt FROM @sql;
                              EXECUTE stmt;
                              DEALLOCATE PREPARE stmt;

                       ELSEIF clinicalType = 'Conditions/diseases' THEN

                              SET @sql = CONCAT("INSERT INTO qry_dataset 
                              SELECT DISTINCT p.query_id, o.id 
                              FROM ", p_sourcetab," o JOIN ", p_patientcohorttab," p ON o.patient_id = p.patient_id 
                              AND o.person_id = p.person_id AND o.organization_id = p.organization_id 
                              JOIN ", p_schema,".concept cpt ON o.non_core_concept_id = cpt.non_core_concept_id 
                              WHERE o.is_problem = 1 
                              AND o.is_review = 0 
                              AND o.non_core_concept_id IS NOT NULL AND ", p_daterange," AND ", p_activeString); 
                              PREPARE stmt FROM @sql;
                              EXECUTE stmt;
                              DEALLOCATE PREPARE stmt;

                       ELSEIF clinicalType = 'Procedures' THEN 

                              DROP TEMPORARY TABLE IF EXISTS qry_concept;
                              SET @sql = CONCAT("CREATE TEMPORARY TABLE qry_concept AS 
                              SELECT cv.code_category_id, COALESCE(cm.legacy, cv.concept_dbid) non_core_concept_id 
                              FROM qry_code_cat cv JOIN ", p_schema,".concept c ON c.dbid = cv.concept_dbid 
                              LEFT JOIN qry_cpt_map cm ON cv.concept_dbid = cm.core 
                              WHERE cv.code_category_id = 37 "); -- Procedure code
                              PREPARE stmt FROM @sql;
                              EXECUTE stmt;
                              DEALLOCATE PREPARE stmt;

                              ALTER TABLE qry_concept ADD INDEX cpt_idx(non_core_concept_id);
                                 
                              SET @sql = CONCAT("INSERT INTO qry_dataset 
                              SELECT DISTINCT p.query_id, o.id 
                              FROM ", p_sourcetab," o JOIN ", p_patientcohorttab," p ON o.patient_id = p.patient_id 
                              AND o.person_id = p.person_id AND o.organization_id = p.organization_id 
                              JOIN ", p_schema,".concept cpt ON o.non_core_concept_id = cpt.non_core_concept_id 
                              WHERE ( cpt.name LIKE '%procedure%' 
                              OR EXISTS (SELECT 1 FROM qry_concept q WHERE q.non_core_concept_id = o.non_core_concept_id) ) 
                              AND o.non_core_concept_id IS NOT NULL AND ", p_daterange," AND ", p_activeString); 
                              PREPARE stmt FROM @sql;
                              EXECUTE stmt;
                              DEALLOCATE PREPARE stmt;
        
                       ELSEIF clinicalType = 'Family history' THEN   

                              DROP TEMPORARY TABLE IF EXISTS qry_concept;
                              SET @sql = CONCAT("CREATE TEMPORARY TABLE qry_concept AS 
                              SELECT cv.code_category_id, COALESCE(cm.legacy, cv.concept_dbid) non_core_concept_id 
                              FROM qry_code_cat cv JOIN ", p_schema,".concept c ON c.dbid = cv.concept_dbid 
                              LEFT JOIN qry_cpt_map cm ON cv.concept_dbid = cm.core 
                              WHERE cv.code_category_id = 17 "); -- Family history
                              PREPARE stmt FROM @sql;
                              EXECUTE stmt;
                              DEALLOCATE PREPARE stmt;

                              ALTER TABLE qry_concept ADD INDEX cpt_idx(non_core_concept_id);
                                 
                              SET @sql = CONCAT("INSERT INTO qry_dataset 
                              SELECT DISTINCT p.query_id, o.id 
                              FROM ", p_sourcetab," o JOIN ", p_patientcohorttab," p ON o.patient_id = p.patient_id 
                              AND o.person_id = p.person_id AND o.organization_id = p.organization_id 
                              JOIN ", p_schema,".concept cpt ON o.non_core_concept_id = cpt.non_core_concept_id 
                              WHERE ( cpt.name LIKE '%family history%' OR cpt.name LIKE '%FH:%' 
                              OR EXISTS (SELECT 1 FROM qry_concept q WHERE q.non_core_concept_id = o.non_core_concept_id) ) 
                              AND o.non_core_concept_id IS NOT NULL AND ", p_daterange," AND ", p_activeString); 
                              PREPARE stmt FROM @sql;
                              EXECUTE stmt;
                              DEALLOCATE PREPARE stmt;

                       ELSEIF clinicalType = 'Immunisations' THEN   

                              DROP TEMPORARY TABLE IF EXISTS qry_concept;
                              SET @sql = CONCAT("CREATE TEMPORARY TABLE qry_concept AS 
                              SELECT cv.code_category_id, COALESCE(cm.legacy, cv.concept_dbid) non_core_concept_id 
                              FROM qry_code_cat cv JOIN ", p_schema,".concept c ON c.dbid = cv.concept_dbid 
                              LEFT JOIN qry_cpt_map cm ON cv.concept_dbid = cm.core 
                              WHERE cv.code_category_id = 21 "); -- Immunisations
                              PREPARE stmt FROM @sql;
                              EXECUTE stmt;
                              DEALLOCATE PREPARE stmt;

                              ALTER TABLE qry_concept ADD INDEX cpt_idx(non_core_concept_id);
            
                              SET @sql = CONCAT("INSERT INTO qry_dataset 
                              SELECT DISTINCT p.query_id, o.id 
                              FROM ", p_sourcetab," o JOIN ", p_patientcohorttab," p ON o.patient_id = p.patient_id 
                              AND o.person_id = p.person_id AND o.organization_id = p.organization_id 
                              JOIN ", p_schema,".concept cpt ON o.non_core_concept_id = cpt.non_core_concept_id 
                              WHERE ( cpt.name LIKE '%immunisation%' OR cpt.name LIKE '%vaccination%' 
                              OR EXISTS (SELECT 1 FROM qry_concept q WHERE q.non_core_concept_id = o.non_core_concept_id) ) 
                              AND o.non_core_concept_id IS NOT NULL AND ", p_daterange," AND ", p_activeString); 
                              PREPARE stmt FROM @sql;
                              EXECUTE stmt;
                              DEALLOCATE PREPARE stmt;   

                       ELSEIF clinicalType = 'Procedure requests' THEN  

                              SET @sql = CONCAT("DROP TABLE IF EXISTS ", p_procedure_req_tmp);
                              PREPARE stmt FROM @sql;
                              EXECUTE stmt;
                              DEALLOCATE PREPARE stmt; 

                              SET @sql = CONCAT("CREATE TABLE ", p_procedure_req_tmp," 
                              SELECT DISTINCT p.query_id, 
                              o.id AS id, 
                              o.organization_id, 
                              org.name AS `Organization`, 
                              p.patient_name AS `Patient`, 
                              c2.name AS `Status`, 
                              c.name AS `Concept term`, 
                              o.non_core_concept_id AS `Concept code`, 
                              o.age_at_event AS `Age at event`,
                              o.clinical_effective_date AS `Effective date`,
                              o.patient_id AS `Patient ID`,
                              o.person_id AS `Person ID`,
                              pr.name AS `Practitioner`,
                              p.CCG AS `CCG`,
                              NULL AS `Result value`,
                              NULL AS `Result units`,
                              NULL AS `Result date`,
                              NULL AS `Result text`,
                              NULL AS `Result concept`,
                              NULL AS `Is problem`,
                              NULL AS `Is review`,
                              NULL AS `Problem end date`,
                              NULL AS `Episode`,
                              NULL AS `Is primary` 
                              FROM ", p_schema,".procedure_request o JOIN ", p_patientcohorttab, " p ON o.patient_id = p.patient_id 
                              AND o.person_id = p.person_id AND o.organization_id = p.organization_id 
                              JOIN ", p_schema,".concept c ON c.dbid = o.non_core_concept_id 
                              LEFT JOIN ", p_schema,".concept c2 ON c2.dbid = o.status_concept_id 
                              JOIN ", p_schema,".organization org ON org.id = o.organization_id 
                              LEFT JOIN ", p_schema,".practitioner pr ON pr.id = o.practitioner_id 
                              WHERE o.non_core_concept_id IS NOT NULL AND ", p_daterange); 
                              PREPARE stmt FROM @sql;
                              EXECUTE stmt;
                              DEALLOCATE PREPARE stmt; 

                       ELSEIF clinicalType = 'Diagnostic orders' THEN  

                              SET @sql = CONCAT("DROP TABLE IF EXISTS ", p_diagnostic_tmp);
                              PREPARE stmt FROM @sql;
                              EXECUTE stmt;
                              DEALLOCATE PREPARE stmt; 

                              SET @sql = CONCAT("CREATE TABLE ", p_diagnostic_tmp," 
                              SELECT DISTINCT p.query_id, 
                              o.id AS id, 
                              o.organization_id, 
                              org.name AS `Organization`, 
                              p.patient_name AS `Patient`, 
                              NULL AS `Status`, 
                              c.name AS `Concept term`, 
                              o.non_core_concept_id AS `Concept code`, 
                              o.age_at_event AS `Age at event`,
                              o.clinical_effective_date AS `Effective date`,
                              o.patient_id AS `Patient ID`,
                              o.person_id AS `Person ID`,
                              pr.name AS `Practitioner`,
                              p.CCG AS `CCG`,
                              o.result_value AS `Result value`,
                              o.result_value_units AS `Result units`,
                              o.result_date AS `Result date`,
                              o.result_text AS `Result text`,
                              c2.name AS `Result concept`,
                              is_problem AS `Is problem`,
                              o.is_review AS `Is review`,
                              o.problem_end_date AS `Problem end date`,
                              c3.name AS `Episode`,
                              o.is_primary AS `Is primary` 
                              FROM ", p_schema,".diagnostic_order o JOIN ", p_patientcohorttab, " p ON o.patient_id = p.patient_id 
                              AND o.person_id = p.person_id AND o.organization_id = p.organization_id 
                              JOIN ", p_schema,".concept c ON c.dbid = o.non_core_concept_id 
                              LEFT JOIN ", p_schema,".concept c2 ON c2.dbid = o.result_concept_id 
                              LEFT JOIN ", p_schema,".concept c3 ON c3.dbid = o.episodicity_concept_id 
                              JOIN ", p_schema,".organization org ON org.id = o.organization_id 
                              LEFT JOIN ", p_schema,".practitioner pr ON pr.id = o.practitioner_id 
                              WHERE o.non_core_concept_id IS NOT NULL AND ", p_daterange," AND ", p_activeString);  
                              PREPARE stmt FROM @sql;
                              EXECUTE stmt;
                              DEALLOCATE PREPARE stmt; 

                       ELSEIF clinicalType = 'Warnings' THEN 

                              SET @sql = CONCAT("DROP TABLE IF EXISTS ", p_warning_tmp);
                              PREPARE stmt FROM @sql;
                              EXECUTE stmt;
                              DEALLOCATE PREPARE stmt; 

                              SET p_daterange = REPLACE(p_daterange,'clinical_effective_date','effective_date');

                              SET @sql = CONCAT("CREATE TABLE ", p_warning_tmp," 
                              SELECT DISTINCT p.query_id, 
                              o.id AS id, 
                              o.organization_id, 
                              org.name AS `Organization`, 
                              p.patient_name AS `Patient`, 
                              o.is_active AS `Status`, 
                              NULL AS `Concept term`, 
                              NULL AS `Concept code`, 
                              NULL AS `Age at event`,
                              o.effective_date AS `Effective date`,
                              o.patient_id AS `Patient ID`,
                              o.person_id AS `Person ID`,
                              NULL AS `Practitioner`,
                              p.CCG AS `CCG`,
                              NULL AS `Result value`,
                              NULL AS `Result units`,
                              NULL AS `Result date`,
                              NULL AS `Result text`,
                              NULL AS `Result concept`,
                              NULL AS `Is problem`,
                              NULL AS `Is review`,
                              NULL AS `Problem end date`,
                              NULL AS `Episode`,
                              NULL AS `Is primary`,
                              o.flag_text AS `Flag text`
                              FROM ", p_schema,".flag o JOIN ", p_patientcohorttab, " p ON o.patient_id = p.patient_id 
                              AND o.person_id = p.person_id AND o.organization_id = p.organization_id 
                              JOIN ", p_schema,".organization org ON org.id = o.organization_id 
                              WHERE ", p_daterange);  
                              PREPARE stmt FROM @sql;
                              EXECUTE stmt;
                              DEALLOCATE PREPARE stmt; 

                       ELSEIF clinicalType = 'Allergies' THEN    

                              SET @sql = CONCAT("DROP TABLE IF EXISTS ", p_allergy_tmp);
                              PREPARE stmt FROM @sql;
                              EXECUTE stmt;
                              DEALLOCATE PREPARE stmt; 

                              SET @sql = CONCAT("CREATE TABLE ", p_allergy_tmp," 
                              SELECT DISTINCT p.query_id, 
                              o.id AS id, 
                              o.organization_id, 
                              org.name AS `Organization`, 
                              p.patient_name AS `Patient`, 
                              NULL AS `Status`, 
                              c.name AS `Concept term`, 
                              o.non_core_concept_id AS `Concept code`, 
                              o.age_at_event AS `Age at event`,
                              o.clinical_effective_date AS `Effective date`,
                              o.patient_id AS `Patient ID`,
                              o.person_id AS `Person ID`,
                              pr.name AS `Practitioner`,
                              p.CCG AS `CCG`,
                              NULL AS `Result value`,
                              NULL AS `Result units`,
                              NULL AS `Result date`,
                              NULL AS `Result text`,
                              NULL AS `Result concept`,
                              NULL AS `Is problem`,
                              o.is_review AS `Is review`,
                              NULL AS `Problem end date`,
                              NULL AS `Episode`,
                              NULL AS `Is primary` 
                              FROM ", p_schema,".allergy_intolerance o JOIN ", p_patientcohorttab, " p ON o.patient_id = p.patient_id 
                              AND o.person_id = p.person_id AND o.organization_id = p.organization_id 
                              JOIN ", p_schema,".concept c ON c.dbid = o.non_core_concept_id 
                              JOIN ", p_schema,".organization org ON org.id = o.organization_id 
                              LEFT JOIN ", p_schema,".practitioner pr ON pr.id = o.practitioner_id 
                              WHERE o.non_core_concept_id IS NOT NULL AND ", p_daterange); 
                              PREPARE stmt FROM @sql;
                              EXECUTE stmt;
                              DEALLOCATE PREPARE stmt; 

                       ELSEIF clinicalType = 'Referral requests' THEN   

                              SET @sql = CONCAT("DROP TABLE IF EXISTS ", p_referral_req_tmp);
                              PREPARE stmt FROM @sql;
                              EXECUTE stmt;
                              DEALLOCATE PREPARE stmt; 

                              SET @sql = CONCAT("CREATE TABLE ", p_referral_req_tmp," 
                              SELECT DISTINCT p.query_id, 
                              o.id AS id, 
                              o.organization_id, 
                              org.name AS `Organization`, 
                              p.patient_name AS `Patient`, 
                              c2.name AS `Status`, 
                              c.name AS `Concept term`, 
                              o.non_core_concept_id AS `Concept code`, 
                              o.age_at_event AS `Age at event`,
                              o.clinical_effective_date AS `Effective date`,
                              o.patient_id AS `Patient ID`,
                              o.person_id AS `Person ID`,
                              pr.name AS `Practitioner`,
                              p.CCG AS `CCG`,
                              NULL AS `Result value`,
                              NULL AS `Result units`,
                              NULL AS `Result date`,
                              NULL AS `Result text`,
                              NULL AS `Result concept`,
                              NULL AS `Is problem`,
                              o.is_review AS `Is review`,
                              NULL AS `Problem end date`,
                              NULL AS `Episode`,
                              NULL AS `Is primary`,
                              o.requester_organization_id,
                              o.recipient_organization_id,
                              o.referral_request_priority_concept_id,
                              o.referral_request_type_concept_id,
                              o.mode,
                              o.outgoing_referral 
                              FROM ", p_schema,".referral_request o JOIN ", p_patientcohorttab, " p ON o.patient_id = p.patient_id 
                              AND o.person_id = p.person_id AND o.organization_id = p.organization_id 
                              JOIN ", p_schema,".concept c ON c.dbid = o.non_core_concept_id 
                              LEFT JOIN ", p_schema,".concept c2 ON c2.dbid = o.status_concept_id 
                              JOIN ", p_schema,".organization org ON org.id = o.organization_id 
                              LEFT JOIN ", p_schema,".practitioner pr ON pr.id = o.practitioner_id 
                              WHERE o.non_core_concept_id IS NOT NULL AND ", p_daterange); 
                              PREPARE stmt FROM @sql;
                              EXECUTE stmt;
                              DEALLOCATE PREPARE stmt; 

                       END IF;

                              -- fetch the next clinical type
                              SET clinicalTypeString = INSERT(clinicalTypeString, 1, frontlen + 1, '');

                  END LOOP;

         END IF;

         IF p_datasetconcepttab IS NOT NULL THEN 

            SET @sql = CONCAT('INSERT INTO qry_dataset 
            SELECT DISTINCT p.query_id, o.id 
            FROM ', p_sourcetab,' o JOIN ', p_patientcohorttab,' p ON o.patient_id = p.patient_id 
            AND o.person_id = p.person_id AND o.organization_id = p.organization_id 
            JOIN ', p_datasetconcepttab,' c ON o.non_core_concept_id = c.non_core_concept_id  
            WHERE o.non_core_concept_id IS NOT NULL AND ', p_daterange,' AND ', p_activeString); 
            PREPARE stmt FROM @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

         ELSEIF p_datasetconcepttab IS NULL AND (LENGTH(TRIM(p_selectedClinicalTypes)) = 0 OR p_selectedClinicalTypes IS NULL) THEN 

            SET @sql = CONCAT('INSERT INTO qry_dataset 
            SELECT DISTINCT p.query_id, o.id 
            FROM ', p_sourcetab,' o JOIN ', p_patientcohorttab,' p ON o.patient_id = p.patient_id 
            AND o.person_id = p.person_id AND o.organization_id = p.organization_id 
            WHERE o.non_core_concept_id IS NOT NULL AND ', p_daterange,' AND ', p_activeString);
            PREPARE stmt FROM @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

         END IF;

         -- create a temporary table to hold the ids
         DROP TEMPORARY TABLE IF EXISTS qry_dataset_fin;
         CREATE TEMPORARY TABLE qry_dataset_fin (
            row_id INT, 
            query_id INT, 
            id BIGINT, PRIMARY KEY(row_id) 
            ) AS 
         SELECT (@row_no := @row_no + 1) AS row_id, 
            a.query_id,
            a.id 
         FROM (SELECT DISTINCT query_id, id 
               FROM qry_dataset ) a JOIN (SELECT @row_no := 0) t;

         SET @row_id = 0;

         -- loop through the ids and insert data into the output table in batches
         WHILE EXISTS (SELECT row_id from qry_dataset_fin WHERE row_id > @row_id AND row_id <= @row_id + 1000) DO

               SET @ins = CONCAT("INSERT INTO  ", p_datasettab, " 
               SELECT q.query_id, q.id FROM qry_dataset_fin q WHERE q.row_id > @row_id AND q.row_id <= @row_id + 1000");
               PREPARE stmt FROM @ins;
               EXECUTE stmt;
               DEALLOCATE PREPARE stmt;

               SET @row_id = @row_id + 1000; 

         END WHILE; 


    END IF;


END //
DELIMITER ;