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
  p_patientcohorttab VARCHAR(64)
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
  
  DECLARE front VARCHAR(500) DEFAULT NULL;
  DECLARE frontlen INT DEFAULT NULL;
  DECLARE TempValue VARCHAR(500) DEFAULT NULL;

  DECLARE n INT DEFAULT 0;
  DECLARE i INT DEFAULT 0;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(p_query_id,'buildDatasetOutputTables',@code,@msg,now());
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
         WHERE med.rnk = 1 AND EXISTS (SELECT 1 FROM ", p_patientcohorttab," pc WHERE  pc.patient_id = med.patient_id) ");
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

      SELECT COUNT(*) FROM qry_tmp INTO n;

      SET @sql := '';
      SET i = 0;
      WHILE i < n DO 
        -- build column list from output fields
        SET @sql =  CONCAT(BINARY @sql,(SELECT CONCAT(IF (INSTR(q.column_name,'(') = 0, q.column_name, CONCAT(p_schema ,'.', q.column_name)),' AS ',QUOTE(q.field_name)) FROM  qry_tmp q LIMIT i, 1));        
        SET @sql =  CONCAT(BINARY @sql,CASE WHEN LENGTH(@sql)>0 THEN ',' ELSE '' END);
        SET i = i + 1;
      END WHILE;

      IF LENGTH(@sql)>0 THEN  -- continues if output field exists


         IF LOCATE('Current address', @sql) > 0 THEN
            SET @sql = INSERT (@sql,LOCATE('Current address', @sql)+16,0,", p.postcode AS 'Postcode'");
         END IF;

      -- remove the last comma in the string
         SET @sql = SUBSTRING(@sql, 1, LENGTH(@sql)-1);

         -- create an empty table output table
         SET @output = CONCAT('CREATE TABLE ', output_table ,' AS 
         SELECT DISTINCT r.', event_table,'_id AS id, ', BINARY @sql ,' FROM ', p_schema,'.', event_table,
         ' t JOIN ', result_dataset,' r ON t.id = r.', event_table,'_id 
         JOIN ', p_patientcohorttab,' p ON p.patient_id = ', event_id,' AND p.organization_id = t.organization_id '
         , join_clause_1,' '
         , join_clause_2,' '
         , join_clause_3,' '
         , join_clause_4,' '
         , join_clause_5,' '
         , join_clause_6,' WHERE r.query_id = ', p_query_id,' LIMIT 0');

         PREPARE stmt FROM @output;
         EXECUTE stmt;
         DEALLOCATE PREPARE stmt;
         
         -- create a temporary table to hold the ids
         DROP TEMPORARY TABLE IF EXISTS qry_output_tmp;
         SET @tmp = CONCAT('CREATE TEMPORARY TABLE qry_output_tmp ( row_id INT, id BIGINT, PRIMARY KEY(row_id) ) AS 
         SELECT (@row_no := @row_no + 1) AS row_id, ', event_table,'_id AS id FROM ', result_dataset,' r JOIN (SELECT @row_no := 0) t 
         WHERE r.query_id = ', p_query_id);
         PREPARE stmt FROM @tmp;
         EXECUTE stmt;
         DEALLOCATE PREPARE stmt;

         SET @row_id = 0;

         -- loop through the ids and insert data into the output table in batches
         WHILE EXISTS (SELECT row_id from qry_output_tmp WHERE row_id > @row_id AND row_id <= @row_id + 10000) DO

               SET @ins = CONCAT("INSERT INTO  ", output_table, " 
               SELECT q.id AS Id, ", BINARY @sql , " FROM ", p_schema,".", event_table," t 
               JOIN qry_output_tmp q ON t.id = q.id 
               JOIN ", p_patientcohorttab," p ON p.patient_id = ", event_id," AND p.organization_id = t.organization_id "
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

         SET @alt = CONCAT('ALTER TABLE ', output_table,' ADD PRIMARY KEY(Id)' );
         PREPARE stmt FROM @alt;
         EXECUTE stmt;
         DEALLOCATE PREPARE stmt;    

      END IF;

      -- fetch next event type
      SET p_event_type = INSERT(p_event_type, 1, frontlen + 1, '');

 END LOOP;

END //
DELIMITER ;