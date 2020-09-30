USE dashboards;


DROP PROCEDURE IF EXISTS buildResultDatasets;

DELIMITER //

CREATE PROCEDURE buildResultDatasets (
  p_query_id INT,
  p_patientcohorttab VARCHAR(64),
  p_event_type VARCHAR(500),
  p_active VARCHAR(20),
  p_datasetValue VARCHAR(1000),
  p_datasetValuetab VARCHAR(64),
  p_datasetconcepttab VARCHAR(64),  
  p_dateFrom VARCHAR(20),
  p_dateTo VARCHAR(20),
  p_schema VARCHAR(255)
  )

BEGIN

  DECLARE datasetValueString VARCHAR(255);

  -- set date range
  IF p_dateFrom IS NOT NULL AND p_dateTo IS NOT NULL THEN
    SET datasetValueString = getAgeDateRangeString(p_dateFrom, p_dateTo, 2); 
  ELSE
    SET datasetValueString = '1';
  END IF;

  IF p_datasetValue IS NOT NULL THEN
      -- get valueset string
      CALL getValueSetString(p_datasetValue, @datasetValueString);
      SET datasetValueString = @datasetValueString;
      -- create datset valueset
      CALL createValueSet(datasetValueString, p_datasetValuetab);
      -- create concept from dataset valueset
      CALL createConcept(p_datasetconcepttab, p_datasetValuetab, p_schema);
  ELSE
      -- no valueset filtering
      SET p_datasetconcepttab = NULL;
  END IF;
      
  -- build datasets from event types
  CALL buildDatasets(p_query_id, p_patientcohorttab, p_event_type, p_datasetconcepttab, datasetValueString, p_active, p_schema);


END //
DELIMITER ;