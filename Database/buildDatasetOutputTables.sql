USE dashboards;

DROP PROCEDURE IF EXISTS buildDatasetOutputTables;

DELIMITER //

CREATE PROCEDURE buildDatasetOutputTables (
  p_outputField VARCHAR(1000), 
  p_outputType VARCHAR(100),
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

  CALL storeString(p_outputField, p_storetab);

    processloop:
    LOOP  

       IF LENGTH(TRIM(p_event_type)) = 0 
          OR p_event_type IS NULL 
          OR LENGTH(TRIM(p_outputField)) = 0 
          OR p_outputField IS NULL THEN
         LEAVE processloop;
       END IF;

      -- retrieve event type from comma separated list
      SET front = SUBSTRING_INDEX(p_event_type, ',', 1);
      SET frontlen = LENGTH(front);
      SET TempValue = TRIM(front);

      IF TempValue = 'PERSON'THEN
         SET event_table = 'patient';
         SET result_dataset = 'person_dataset';
         SET output_table = CONCAT('person_output_',p_query_id);
      ELSEIF TempValue = 'CLINICAL EVENTS' THEN
         SET event_table = 'observation';
         SET result_dataset = 'observation_dataset';
         SET output_table = CONCAT('observation_output_',p_query_id);
      ELSEIF TempValue = 'MEDICATION' THEN
         SET event_table = 'medication_statement';
         SET result_dataset = 'medication_dataset';
         SET output_table = CONCAT('medication_output_',p_query_id);
      ELSEIF TempValue = 'ENCOUNTERS' THEN
         SET event_table = 'encounter';
         SET result_dataset = 'encounter_dataset';
         SET output_table = CONCAT('encounter_output_',p_query_id);
      END IF;

      -- drop output table if exists
      SET @sql = CONCAT('DROP TABLE IF EXISTS ', output_table); 

      PREPARE stmt FROM @sql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
      -- match column to output field
      DROP TEMPORARY TABLE IF EXISTS qry_tmp;

      SET @sql = CONCAT(
      'CREATE TEMPORARY TABLE qry_tmp (column_name VARCHAR(300), field_name VARCHAR(300)) 
      AS SELECT table_name, column_name, field_name FROM dataset_tables dt JOIN ', p_storetab,' s 
      ON s.code =  dt.field_name WHERE dt.table_name = ', QUOTE(event_table),' ORDER BY dt.id');

      PREPARE stmt FROM @sql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;

      SELECT COUNT(*) FROM qry_tmp INTO n;

      SET @sql := '';
      SET i = 0;
      WHILE i < n DO 
        -- build column list from output fields
        SET @sql =  CONCAT(BINARY @sql,(SELECT CONCAT(IF (INSTR(q.column_name,'(') = 0, CONCAT('t.',q.column_name), CONCAT(p_schema ,'.',INSERT(q.column_name,INSTR(q.column_name,'('),1,'(t.'))),' AS ',QUOTE(q.field_name)) FROM  qry_tmp q LIMIT i, 1));
        SET @sql =  CONCAT(BINARY @sql,CASE WHEN LENGTH(@sql)>0 THEN ',' ELSE '' END);

        SET i = i + 1;
      END WHILE;

      -- remove the last comma in string
      SET @sql = SUBSTRING(@sql, 1, LENGTH(@sql)-1);

      -- create output table for the selected output fields
      IF LENGTH(@sql)>0 THEN
         SET @sql = CONCAT('CREATE TABLE ', output_table ,' AS 
         SELECT DISTINCT ', BINARY @sql ,' FROM ', p_schema ,'.', event_table,' t JOIN ', result_dataset,' r ON t.id = r.', event_table,'_id');
         
         PREPARE stmt FROM @sql;
         EXECUTE stmt;
         DEALLOCATE PREPARE stmt;
      END IF;

      SET p_event_type = INSERT(p_event_type, 1, frontlen + 1, '');

    END LOOP;
END //
DELIMITER ;