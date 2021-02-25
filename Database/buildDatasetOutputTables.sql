USE dashboards;

DROP PROCEDURE IF EXISTS buildDatasetOutputTables;

DELIMITER //

CREATE PROCEDURE buildDatasetOutputTables ( 
  p_selectedDemographicFields VARCHAR(2000),
  p_selectedEncounterFields VARCHAR(2000),
  p_selectedMedicationFields VARCHAR(2000),
  p_selectedClinicalEventFields VARCHAR(2000),
  p_event_type VARCHAR(255),
  p_storetab VARCHAR(64),
  p_schema VARCHAR(255),
  p_query_id INT,
  p_patientcohorttab VARCHAR(64),
  p_procedure_req_tmp VARCHAR(64),
  p_diagnostic_tmp VARCHAR(64),
  p_warning_tmp VARCHAR(64),
  p_allergy_tmp VARCHAR(64),
  p_referral_req_tmp VARCHAR(64)
)
BEGIN

  DECLARE event_table VARCHAR(64) DEFAULT NULL;
  DECLARE output_table VARCHAR(64) DEFAULT NULL;
  DECLARE result_dataset VARCHAR(64) DEFAULT NULL;
  DECLARE event_id VARCHAR(64) DEFAULT NULL;
  DECLARE join_clause_1 VARCHAR(1000) DEFAULT NULL;
  DECLARE join_clause_2 VARCHAR(1000) DEFAULT NULL;
  DECLARE join_clause_3 VARCHAR(1000) DEFAULT NULL;
  DECLARE join_clause_4 VARCHAR(1000) DEFAULT NULL;
  DECLARE join_clause_5 VARCHAR(1000) DEFAULT NULL;
  DECLARE join_clause_6 VARCHAR(1000) DEFAULT NULL;

  DECLARE clinicalTypeTableString VARCHAR(2000) DEFAULT NULL;
  DECLARE columnNameString VARCHAR(2000) DEFAULT NULL;
  
  DECLARE front VARCHAR(500) DEFAULT NULL;
  DECLARE frontlen INT DEFAULT NULL;
  DECLARE TempValue VARCHAR(500) DEFAULT NULL;

  DECLARE front2 VARCHAR(500) DEFAULT NULL;
  DECLARE frontlen2 INT DEFAULT NULL;
  DECLARE clinicalTypeTable VARCHAR(100);

  DECLARE front3 VARCHAR(500) DEFAULT NULL;
  DECLARE frontlen3 INT DEFAULT NULL;
  DECLARE columnName VARCHAR(100);


  DECLARE n INT DEFAULT 0;
  DECLARE i INT DEFAULT 0;
  DECLARE l_sql VARCHAR(2000) DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(p_query_id, 'buildDatasetOutputTables', @code, @msg, now());
        RESIGNAL; -- rethrow the error
    END;

 IF LENGTH(TRIM(p_event_type)) <> 0 OR p_event_type IS NOT NULL THEN
         
      -- drop all output tables from previous run

      SET @sql = CONCAT('DROP TABLE IF EXISTS person_output_',p_query_id); 
      PREPARE stmt FROM @sql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;

      SET @sql = CONCAT('DROP TABLE IF EXISTS observation_output_',p_query_id); 
      PREPARE stmt FROM @sql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;

      SET @sql = CONCAT('DROP TABLE IF EXISTS medication_output_',p_query_id); 
      PREPARE stmt FROM @sql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;

      SET @sql = CONCAT('DROP TABLE IF EXISTS encounter_output_',p_query_id); 
      PREPARE stmt FROM @sql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;

 END IF;

 processloop:
 LOOP  

       IF LENGTH(TRIM(p_event_type)) = 0 OR p_event_type IS NULL THEN
         LEAVE processloop;
       END IF;

      -- retrieve event type from comma separated list
      SET front = SUBSTRING_INDEX(p_event_type, ',', 1);
      SET frontlen = LENGTH(front);
      SET TempValue = TRIM(front);

      IF TempValue = 'DEMOGRAPHICS'THEN
         SET event_table = 'patient';
         SET result_dataset = 'person_dataset';
         SET output_table = CONCAT('person_output_',p_query_id);
         SET event_id = 't.id';
         SET join_clause_1 = 'JOIN (SELECT 1 ) prac '; -- dummy join
         SET join_clause_2 = 'JOIN (SELECT 2 ) cpt '; -- dummy join
         SET join_clause_3 = 'JOIN (SELECT 3 ) cpt2 '; -- dummy join
         SET join_clause_4 = 'JOIN (SELECT 4 ) cpt3 '; -- dummy join
         SET join_clause_5 = 'JOIN (SELECT 5 ) cpt4 '; -- dummy join
         SET join_clause_6 = 'JOIN (SELECT 6 ) mo '; -- dummy join
         CALL storeString(p_selectedDemographicFields, p_storetab);
      ELSEIF TempValue = 'CLINICALEVENTS' THEN
         SET event_table = 'observation';
         SET result_dataset = 'observation_dataset';
         SET output_table = CONCAT('observation_output_',p_query_id);
         SET event_id = 't.patient_id';
         SET join_clause_1 = CONCAT("LEFT JOIN ",p_schema,'.practitioner prac ON t.practitioner_id = prac.id ');
         SET join_clause_2 = CONCAT("LEFT JOIN ",p_schema,'.concept cpt ON t.non_core_concept_id = cpt.dbid ');
         SET join_clause_3 = CONCAT("LEFT JOIN ",p_schema,'.concept cpt2 ON t.result_concept_id = cpt2.dbid ');
         SET join_clause_4 = CONCAT("LEFT JOIN ",p_schema,'.concept cpt3 ON t.episodicity_concept_id = cpt3.dbid ');
         SET join_clause_5 = 'JOIN (SELECT 5 ) cpt4 '; -- dummy join
         SET join_clause_6 = 'JOIN (SELECT 6 ) mo '; -- dummy join
         CALL storeString(p_selectedClinicalEventFields, p_storetab);
      ELSEIF TempValue = 'MEDICATION' THEN
         SET event_table = 'medication_statement';
         SET result_dataset = 'medication_dataset';
         SET output_table = CONCAT('medication_output_',p_query_id);
         SET event_id = 't.patient_id';
         SET join_clause_1 = CONCAT("LEFT JOIN ",p_schema,'.practitioner prac ON t.practitioner_id = prac.id ');
         SET join_clause_2 = CONCAT("LEFT JOIN ",p_schema,'.concept cpt ON t.non_core_concept_id = cpt.dbid ');
         SET join_clause_3 = 'JOIN (SELECT 3 ) cpt2 '; -- dummy join
         SET join_clause_4 = 'JOIN (SELECT 4 ) cpt3 '; -- dummy join
         SET join_clause_5 = CONCAT("LEFT JOIN ",p_schema,'.concept cpt4 ON t.authorisation_type_concept_id = cpt4.dbid ');

         DROP TEMPORARY TABLE IF EXISTS qry_med_issue_date;

         SET @med = CONCAT("CREATE TEMPORARY TABLE qry_med_issue_date AS 
         SELECT med.clinical_effective_date, med.patient_id, med.medication_statement_id, med.organization_id, med.rnk 
         FROM (SELECT mo.id, mo.medication_statement_id, mo.patient_id, mo.clinical_effective_date, mo.organization_id, 
         @currank := IF(@curmedstmt = BINARY mo.medication_statement_id, @currank + 1, 1) AS rnk, 
         @curmedstmt := mo.medication_statement_id AS cur_med_stmt 
         FROM ", p_schema,".medication_order mo, (SELECT @currank := 0, @curmedstmt := 0) r 
         ORDER BY mo.medication_statement_id DESC, mo.clinical_effective_date DESC, mo.id DESC) med 
         WHERE med.rnk = 1 AND EXISTS (SELECT 1 FROM ", p_patientcohorttab," pc WHERE  pc.patient_id = med.patient_id AND pc.organization_id = med.organization_id) ");
         PREPARE stmt FROM @med;
         EXECUTE stmt;
         DEALLOCATE PREPARE stmt;

         ALTER TABLE qry_med_issue_date ADD INDEX pat_med_idx(patient_id, medication_statement_id, organization_id);

         SET join_clause_6 = CONCAT("LEFT JOIN qry_med_issue_date mo ON mo.patient_id = t.patient_id AND mo.medication_statement_id = t.id AND mo.organization_id = t.organization_id ");
         CALL storeString(p_selectedMedicationFields, p_storetab);
      ELSEIF TempValue = 'ENCOUNTERS' THEN
         SET event_table = 'encounter';
         SET result_dataset = 'encounter_dataset';
         SET output_table = CONCAT('encounter_output_',p_query_id);
         SET event_id = 't.patient_id';
         SET join_clause_1 = CONCAT("LEFT JOIN ",p_schema,'.practitioner prac ON t.practitioner_id = prac.id ');
         SET join_clause_2 = CONCAT("LEFT JOIN ",p_schema,'.concept cpt ON t.non_core_concept_id = cpt.dbid ');
         SET join_clause_3 = 'JOIN (SELECT 3 ) cpt2 '; -- dummy join
         SET join_clause_4 = 'JOIN (SELECT 4 ) cpt3 '; -- dummy join
         SET join_clause_5 = 'JOIN (SELECT 5 ) cpt4 '; -- dummy join
         SET join_clause_6 = 'JOIN (SELECT 6 ) mo '; -- dummy join
         CALL storeString(p_selectedEncounterFields, p_storetab);
      END IF;

      -- match the columns to the output fields
      DROP TEMPORARY TABLE IF EXISTS qry_tmp;

      SET @sql = CONCAT(
      'CREATE TEMPORARY TABLE qry_tmp (column_name VARCHAR(300), field_name VARCHAR(300)) 
      AS SELECT dt.column_name, dt.field_name FROM dataset_tables dt JOIN ', p_storetab,' s 
      ON s.code =  dt.field_name WHERE dt.table_name = ', QUOTE(event_table),' ORDER BY dt.id');
      PREPARE stmt FROM @sql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;

      SELECT COUNT(*) INTO n FROM qry_tmp;

      SET l_sql = '';
      SET i = 0;
      WHILE i < n DO 
        -- build column list from output fields
        SET l_sql =  CONCAT(BINARY l_sql,(SELECT CONCAT(IF (INSTR(q.column_name,'(') = 0, q.column_name, CONCAT(p_schema ,'.', q.column_name)),' AS ',QUOTE(q.field_name)) FROM  qry_tmp q LIMIT i, 1));        
        SET l_sql =  CONCAT(BINARY l_sql,CASE WHEN LENGTH(l_sql)>0 THEN ',' ELSE '' END);
        SET i = i + 1;
      END WHILE;

      IF LENGTH(l_sql)>0 THEN  -- continues if any output field exists


         IF LOCATE('Current address', l_sql) > 0 THEN
            SET l_sql = INSERT (l_sql,LOCATE('Current address', l_sql)+16,0,", p.postcode AS 'Postcode'");
         END IF;

         -- remove the last comma in the string
         SET l_sql = SUBSTRING(l_sql, 1, LENGTH(l_sql)-1);

         SET l_sql = REPLACE(l_sql, 'procedure_request_status', 'NULL');
         SET l_sql = REPLACE(l_sql, 'referral_requester_organisation', 'NULL');
         SET l_sql = REPLACE(l_sql, 'referral_recipient_organisation', 'NULL');
         SET l_sql = REPLACE(l_sql, 'referral_request_priority', 'NULL');
         SET l_sql = REPLACE(l_sql, 'referral_request_type', 'NULL');
         SET l_sql = REPLACE(l_sql, 'referral_mode', 'NULL');
         SET l_sql = REPLACE(l_sql, 'referral_outgoing_status', 'NULL');
         SET l_sql = REPLACE(l_sql, 'warning_flag_status', 'NULL');
         SET l_sql = REPLACE(l_sql, 'warning_flag_text', 'NULL');

         -- create an empty output table
         SET @output = CONCAT('CREATE TABLE ', output_table ,' AS 
         SELECT DISTINCT r.', event_table,'_id AS id, ', BINARY l_sql ,' FROM ', p_schema,'.', event_table,' t JOIN '
         , p_patientcohorttab,' p ON p.patient_id = ', event_id,' AND p.organization_id = t.organization_id JOIN '
         , result_dataset,' r ON t.id = r.', event_table,'_id AND p.ods_code = r.ods_code '
         , join_clause_1,' '
         , join_clause_2,' '
         , join_clause_3,' '
         , join_clause_4,' '
         , join_clause_5,' '
         , join_clause_6,' WHERE r.query_id = ', p_query_id,' LIMIT 0');

         PREPARE stmt FROM @output;
         EXECUTE stmt;
         DEALLOCATE PREPARE stmt;

         IF TempValue = 'CLINICALEVENTS' THEN

         SET columnNameString = "Procedure request status,Referral requester organisation,Referral recipient organisation,Referral request priority,Referral request type,Referral mode,Referral outgoing status,Warning flag status,Warning flag text,Is review,Is problem,Is primary";

         processloop3:
         LOOP  

                  IF LENGTH(TRIM(columnNameString)) = 0 OR columnNameString IS NULL THEN
                  LEAVE processloop3;
                  END IF;

                  -- retrieve the column name from comma separated list
                  SET front3 = SUBSTRING_INDEX(columnNameString, ',', 1);
                  SET frontlen3 = LENGTH(front3);
                  SET columnName = TRIM(front3);
                  
                  SET @col = NULL;

                  SET @chkCol = CONCAT("SELECT 'Y' INTO @col FROM information_schema.columns 
                  WHERE table_name = ", QUOTE(output_table)," AND column_name = ", QUOTE(columnName));
                  PREPARE stmt FROM @chkCol;
                  EXECUTE stmt;
                  DEALLOCATE PREPARE stmt;

                 -- if Y then modify the data type of the column
                 IF @col = 'Y' THEN

                    IF columnName IN ('Procedure request status','Referral requester organisation','Referral recipient organisation','Referral request priority','Referral request type') THEN

                         SET @mod = CONCAT("ALTER TABLE ", output_table," MODIFY COLUMN `", columnName,"` VARCHAR(255)");
                         PREPARE stmt FROM @mod;
                         EXECUTE stmt;
                         DEALLOCATE PREPARE stmt;

                    ELSEIF columnName IN ('Referral outgoing status','Warning flag status', 'Is review', 'Is problem', 'Is primary') THEN

                         SET @mod = CONCAT("ALTER TABLE ", output_table," MODIFY COLUMN `", columnName,"` TINYINT(1) DEFAULT NULL");
                         PREPARE stmt FROM @mod;
                         EXECUTE stmt;
                         DEALLOCATE PREPARE stmt;
                    
                    ELSEIF columnName IN ('Referral mode') THEN

                         SET @mod = CONCAT("ALTER TABLE ", output_table," MODIFY COLUMN `", columnName,"` VARCHAR(50)");
                         PREPARE stmt FROM @mod;
                         EXECUTE stmt;
                         DEALLOCATE PREPARE stmt;
                    
                    ELSEIF columnName IN ('Warning flag text') THEN

                         SET @mod = CONCAT("ALTER TABLE ", output_table," MODIFY COLUMN `", columnName,"` TEXT");
                         PREPARE stmt FROM @mod;
                         EXECUTE stmt;
                         DEALLOCATE PREPARE stmt;                   
                    
                    END IF;

                 END IF;
                       -- fetch next column name
                      SET columnNameString = INSERT(columnNameString, 1, frontlen3 + 1, '');
         END LOOP;

         END IF;

         -- create a temporary table to hold the ids
         DROP TEMPORARY TABLE IF EXISTS qry_output_tmp;
         SET @tmp = CONCAT('CREATE TEMPORARY TABLE qry_output_tmp ( row_id INT, ods_code VARCHAR(50), id BIGINT, PRIMARY KEY(row_id) ) AS 
         SELECT (@row_no := @row_no + 1) AS row_id, ods_code, ', event_table,'_id AS id 
         FROM ', result_dataset,' r JOIN (SELECT @row_no := 0) t 
         WHERE r.query_id = ', p_query_id);
         PREPARE stmt FROM @tmp;
         EXECUTE stmt;
         DEALLOCATE PREPARE stmt;

         SET @row_id = 0;

         -- loop through the ids and insert data into the output table in batches
         WHILE EXISTS (SELECT row_id from qry_output_tmp WHERE row_id > @row_id AND row_id <= @row_id + 10000) DO

               SET @ins = CONCAT("INSERT INTO  ", output_table, " 
               SELECT q.id AS Id, ", BINARY l_sql , " FROM ", p_schema,".", event_table," t JOIN "
               , p_patientcohorttab," p ON p.patient_id = ", event_id," AND p.organization_id = t.organization_id JOIN qry_output_tmp q ON t.id = q.id AND q.ods_code = p.ods_code "
               , join_clause_1," "
               , join_clause_2," "
               , join_clause_3," "
               , join_clause_4," "
               , join_clause_5," "
               , join_clause_6," WHERE q.row_id > @row_id AND q.row_id <= @row_id + 10000");

               PREPARE stmt FROM @ins;
               EXECUTE stmt;
               DEALLOCATE PREPARE stmt;

               SET @row_id = @row_id + 10000; 

         END WHILE; 

         SET @alt = CONCAT('ALTER TABLE ', output_table,' ADD INDEX id_idx(Id)' );
         PREPARE stmt FROM @alt;
         EXECUTE stmt;
         DEALLOCATE PREPARE stmt;   

            -- check clinical events for clinical types
            IF TempValue = 'CLINICALEVENTS' THEN

                  -- retrieve the columns of the output table
                  DROP TEMPORARY TABLE IF EXISTS qry_tmp2;

                  SET @sql = CONCAT('CREATE TEMPORARY TABLE qry_tmp2 (column_name VARCHAR(300)) AS 
                  SELECT column_name FROM information_schema.columns 
                  WHERE table_name = ', QUOTE(output_table));
                  PREPARE stmt FROM @sql;
                  EXECUTE stmt;
                  DEALLOCATE PREPARE stmt;

                  SET n = 0;

                  SELECT COUNT(*) FROM qry_tmp2 INTO n;

                  -- only continues if any column exists
                  IF n > 0 THEN

                        SET l_sql := '';
                        SET i = 0;
                        WHILE i < n DO 
                              -- build column list from the output table fields
                              SET l_sql =  CONCAT(BINARY l_sql,(SELECT CONCAT('`',q.column_name,'`') FROM  qry_tmp2 q LIMIT i, 1));        
                              SET l_sql =  CONCAT(BINARY l_sql,CASE WHEN LENGTH(l_sql)>0 THEN ',' ELSE '' END);
                              SET i = i + 1;
                        END WHILE;

                        -- remove the last comma in the string
                        SET l_sql = SUBSTRING(l_sql, 1, LENGTH(l_sql)-1);

                        -- build a list of clinical type tables that might exist
                        SET clinicalTypeTableString = CONCAT(p_procedure_req_tmp,',',p_diagnostic_tmp,',',p_warning_tmp,',',p_allergy_tmp,',',p_referral_req_tmp);

                        -- loop through each and process if exists
                        processloop2:
                        LOOP  

                              IF LENGTH(TRIM(clinicalTypeTableString)) = 0 OR clinicalTypeTableString IS NULL THEN
                                 LEAVE processloop2;
                              END IF;

                              -- fetch the name of the clinical type table from a comma separated list
                              SET front2 = SUBSTRING_INDEX(clinicalTypeTableString, ',', 1);
                              SET frontlen2 = LENGTH(front2);
                              SET clinicalTypeTable = TRIM(front2);

                              SET @flag = NULL;

                              -- check if the clinical type table exists
                              SET @chk = CONCAT("SELECT 'Y' INTO @flag FROM information_schema.tables 
                              WHERE table_name = ", QUOTE(clinicalTypeTable));
                              PREPARE stmt FROM @chk;
                              EXECUTE stmt;
                              DEALLOCATE PREPARE stmt;

                              -- if Y then load data into the output table
                              IF @flag = 'Y' THEN

                                    -- create a temporary table to hold the data from the clinical type table
                                    DROP TEMPORARY TABLE IF EXISTS qry_clinicalTypeTab_tmp;
                                    SET @tmp = CONCAT("CREATE TEMPORARY TABLE qry_clinicalTypeTab_tmp (
                                           row_id INT, 
                                          `id` BIGINT,
                                          `Organisation` VARCHAR(255), 
                                          `Patient` VARCHAR(255), 
                                          `Procedure request status` VARCHAR(255), 
                                          `Warning flag status` TINYINT(1), 
                                          `Concept term` VARCHAR(255), 
                                          `Concept code` VARCHAR(40),
                                          `Age at event` DECIMAL(5,2), 
                                          `Effective date` DATE,  
                                          `Patient ID` BIGINT, 
                                          `Person ID` BIGINT, 
                                          `Practitioner` VARCHAR(255),
                                          `CCG` VARCHAR(255), 
                                          `Result value` DOUBLE, 
                                          `Result units` VARCHAR(50), 
                                          `Result date` DATE, 
                                          `Result text` TEXT, 
                                          `Result concept` VARCHAR(255), 
                                          `Is problem` TINYINT(1), 
                                          `Is review` TINYINT(1), 
                                          `Problem end date` DATE, 
                                          `Episode` VARCHAR(255), 
                                          `Is primary` TINYINT(1), 
                                          `Warning flag text` TEXT,
                                          `Referral requester organisation` VARCHAR(255),
                                          `Referral recipient organisation` VARCHAR(255),
                                          `Referral request priority` VARCHAR(255),
                                          `Referral request type` VARCHAR(255),
                                          `Referral mode` VARCHAR(50),
                                          `Referral outgoing status` TINYINT(1), 
                                           PRIMARY KEY(row_id) ) AS  
                                    SELECT (@row_no := @row_no + 1) AS row_id, 
                                          `id`,
                                          `Organisation`, 
                                          `Patient`, 
                                          `Procedure request status`, 
                                          `Warning flag status`, 
                                          `Concept term`, 
                                          `Concept code`,
                                          `Age at event`, 
                                          `Effective date`,  
                                          `Patient ID`, 
                                          `Person ID`, 
                                          `Practitioner`,
                                          `CCG`, 
                                          `Result value`, 
                                          `Result units`, 
                                          `Result date`, 
                                          `Result text`, 
                                          `Result concept`, 
                                          `Is problem`, 
                                          `Is review`, 
                                          `Problem end date`, 
                                          `Episode`, 
                                          `Is primary`, 
                                          `Warning flag text`,
                                          `Referral requester organisation`,
                                          `Referral recipient organisation`,
                                          `Referral request priority`,
                                          `Referral request type`,
                                          `Referral mode`,
                                          `Referral outgoing status` 
                                    FROM ", clinicalTypeTable," JOIN (SELECT @row_no := 0) t ");
                                    PREPARE stmt FROM @tmp;
                                    EXECUTE stmt;
                                    DEALLOCATE PREPARE stmt;

                                    SET @row_id = 0;

                                    -- loop through the row ids and insert the clinical type table data into the output table in batches
                                    WHILE EXISTS (SELECT row_id from qry_clinicalTypeTab_tmp WHERE row_id > @row_id AND row_id <= @row_id + 10000) DO

                                          SET @ins = CONCAT("INSERT INTO  ", output_table, "(", BINARY l_sql," )  
                                          SELECT ", BINARY l_sql , " FROM qry_clinicalTypeTab_tmp 
                                          WHERE row_id > @row_id AND row_id <= @row_id + 10000");
                                          PREPARE stmt FROM @ins;
                                          EXECUTE stmt;
                                          DEALLOCATE PREPARE stmt;

                                          SET @row_id = @row_id + 10000; 

                                    END WHILE; 

                              END IF;
                                    -- fetch the next clinical type table 
                                    SET clinicalTypeTableString = INSERT(clinicalTypeTableString, 1, frontlen2 + 1, '');
                        END LOOP;

                  END IF;
            
            END IF;
      
      END IF;

      -- fetch next event type
      SET p_event_type = INSERT(p_event_type, 1, frontlen + 1, '');

 END LOOP;

END //
DELIMITER ;