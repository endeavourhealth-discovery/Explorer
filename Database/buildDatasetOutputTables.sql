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
  p_query_id INT
)
BEGIN

  DECLARE event_table VARCHAR(64);
  DECLARE output_table VARCHAR(64);
  DECLARE result_dataset VARCHAR(64);
  
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
         CALL storeString(p_selectedDemographicFields, p_storetab);
      ELSEIF TempValue = 'CLINICALEVENTS' THEN
         SET event_table = 'observation';
         SET result_dataset = 'observation_dataset';
         SET output_table = CONCAT('observation_output_',p_query_id);
         CALL storeString(p_selectedClinicalEventFields, p_storetab);
      ELSEIF TempValue = 'MEDICATION' THEN
         SET event_table = 'medication_statement';
         SET result_dataset = 'medication_dataset';
         SET output_table = CONCAT('medication_output_',p_query_id);
         CALL storeString(p_selectedMedicationFields, p_storetab);
      ELSEIF TempValue = 'ENCOUNTERS' THEN
         SET event_table = 'encounter';
         SET result_dataset = 'encounter_dataset';
         SET output_table = CONCAT('encounter_output_',p_query_id);
         CALL storeString(p_selectedEncounterFields, p_storetab);
      END IF;
   
      -- drop the output table if exists (from previous run)
      SET @sql = CONCAT('DROP TABLE IF EXISTS ', output_table); 
      PREPARE stmt FROM @sql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;

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

      -- check for current address -- if found add postcode as a separate field
         IF LOCATE('Current Address', @sql) > 0 THEN
            SET @sql = INSERT (@sql,LOCATE('Current Address', @sql)+16,0,CONCAT(',', p_schema,".getCurrentAddressPostcode(t.current_address_id) AS 'Postcode'"));
         END IF;

      -- remove the last comma in the string
         SET @sql = SUBSTRING(@sql, 1, LENGTH(@sql)-1);

      -- create output table for the selected output fields
         SET @sql = CONCAT('CREATE TABLE ', output_table ,' AS 
         SELECT DISTINCT ', event_table,'_id AS Id, ', BINARY @sql ,' FROM ', p_schema,'.', event_table,' t JOIN ', result_dataset,' r ON t.id = r.', event_table,'_id 
         WHERE r.query_id = ', p_query_id);
         PREPARE stmt FROM @sql;
         EXECUTE stmt;
         DEALLOCATE PREPARE stmt;

         SET @sql = CONCAT('ALTER TABLE ', output_table,' ADD PRIMARY KEY(Id)' );
         PREPARE stmt FROM @sql;
         EXECUTE stmt;
         DEALLOCATE PREPARE stmt;

      END IF;

      -- fetch next event type
      SET p_event_type = INSERT(p_event_type, 1, frontlen + 1, '');

 END LOOP;

END //
DELIMITER ;