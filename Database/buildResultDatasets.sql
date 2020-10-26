USE dashboards;


DROP PROCEDURE IF EXISTS buildResultDatasets;

DELIMITER //

CREATE PROCEDURE buildResultDatasets (
  IN p_query_id INT,
  IN p_patientcohorttab VARCHAR(64),
  IN p_demographics VARCHAR(20),
  IN p_encounters VARCHAR(20),
  IN p_medication VARCHAR(20),
  IN p_currentMedication VARCHAR(20),
  IN p_clinicalEvents VARCHAR(20),
  IN p_activeProblems VARCHAR(20),
  IN p_dateFromEncounters VARCHAR(30),
  IN p_dateToEncounters VARCHAR(30),
  IN p_dateFromMedication VARCHAR(30),
  IN p_dateToMedication VARCHAR(30),
  IN p_dateFromClinicalEvents VARCHAR(30),
  IN p_dateToClinicalEvents VARCHAR(30),
  IN p_selectedClinicalTypes VARCHAR(1000),
  IN p_selectedEncounterValueSet VARCHAR(1000),
  IN p_selectedMedicationValueSet VARCHAR(1000),
  IN p_selectedClinicalEventValueSet VARCHAR(1000),
  IN p_clinicalTypes_tmp VARCHAR(64),
  IN p_clinicalTypesConcept_tmp VARCHAR(64),
  IN p_encounterValueSet_tmp VARCHAR(64),
  IN p_encounterConcept_tmp VARCHAR(64),
  IN p_medicationValueSet_tmp VARCHAR(64),
  IN p_medicationConcept_tmp VARCHAR(64),
  IN p_clinicalEventValueSet_tmp VARCHAR(64),
  IN p_clinicalEventConcept_tmp VARCHAR(64),
  IN p_schema VARCHAR(255),
  IN p_storetab VARCHAR(64),
  OUT p_eventTypes VARCHAR(255)
  )

BEGIN
  
  DECLARE eventTypeString VARCHAR(255) DEFAULT '';
  DECLARE encountersValueSetString VARCHAR(255);
  DECLARE encountersDateRangeString VARCHAR(255); 
  DECLARE medicationValueSetString VARCHAR(255);
  DECLARE medicationDateRangeString VARCHAR(255); 
  DECLARE clinicalEventsValueSetString VARCHAR(255);
  DECLARE clinicalEventsDateRangeString VARCHAR(255); 
  DECLARE clinicalTypesSetString VARCHAR(255); 

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(p_query_id,'buildResultDatasets',@code,@msg,now());
        RESIGNAL; -- rethrow the error
    END;  

SET p_dateFromEncounters = IF(p_dateFromEncounters = 'NaN-NaN-NaN',NULL, IF(p_dateFromEncounters = '', NULL, SUBSTRING(p_dateFromEncounters,1,10)));
SET p_dateToEncounters = IF(p_dateToEncounters = 'NaN-NaN-NaN',NULL, IF(p_dateToEncounters = '', NULL, SUBSTRING(p_dateToEncounters,1,10)));
SET p_dateFromMedication = IF(p_dateFromMedication = 'NaN-NaN-NaN',NULL, IF(p_dateFromMedication = '', NULL, SUBSTRING(p_dateFromMedication,1,10)));
SET p_dateToMedication = IF(p_dateToMedication = 'NaN-NaN-NaN',NULL, IF(p_dateToMedication = '', NULL, SUBSTRING(p_dateToMedication,1,10)));
SET p_dateFromClinicalEvents = IF(p_dateFromClinicalEvents = 'NaN-NaN-NaN',NULL, IF(p_dateFromClinicalEvents = '', NULL, SUBSTRING(p_dateFromClinicalEvents,1,10)));
SET p_dateToClinicalEvents = IF(p_dateToClinicalEvents = 'NaN-NaN-NaN',NULL, IF(p_dateToClinicalEvents = '', NULL, SUBSTRING(p_dateToClinicalEvents,1,10)));

IF p_demographics = 'TRUE' THEN
   SET eventTypeString = CONCAT(eventTypeString,'DEMOGRAPHICS,');
END IF;

IF p_encounters = 'TRUE' THEN
   SET eventTypeString = CONCAT(eventTypeString,'ENCOUNTERS,');
  -- get date range string for encounters
  IF p_dateFromEncounters IS NOT NULL AND p_dateToEncounters IS NOT NULL THEN
    SET encountersDateRangeString = getAgeDateRangeString(p_dateFromEncounters, p_dateToEncounters, 2); 
  ELSE
    SET encountersDateRangeString = '1';
  END IF;

  -- get valueset string for encounters
  SET p_selectedEncounterValueSet = IF(p_selectedEncounterValueSet = '', NULL, p_selectedEncounterValueSet); 
  IF p_selectedEncounterValueSet IS NOT NULL THEN
    CALL getValueSetString(p_selectedEncounterValueSet, p_storetab, @selectedEncounterValueSetString);
    SET encountersValueSetString = @selectedEncounterValueSetString;
  ELSE  -- bring back everything
    SET encountersValueSetString = '1';
  END IF;
  -- create encounters valueset 
  CALL createValueSet(encountersValueSetString, p_encounterValueSet_tmp);
  -- create concept from encounters valueset
  CALL createConcept(p_encounterConcept_tmp, p_encounterValueSet_tmp, p_schema);
END IF;

IF p_medication = 'TRUE' THEN
   SET eventTypeString = CONCAT(eventTypeString,'MEDICATION,');
  -- get date range string for medication
  IF p_dateFromMedication IS NOT NULL AND p_dateToMedication IS NOT NULL THEN
    SET medicationDateRangeString = getAgeDateRangeString(p_dateFromMedication, p_dateToMedication, 2); 
  ELSE
    SET medicationDateRangeString = '1';
  END IF;
  -- get valueset string for medication
  SET p_selectedMedicationValueSet = IF(p_selectedMedicationValueSet = '', NULL, p_selectedMedicationValueSet); 
  IF p_selectedMedicationValueSet IS NOT NULL THEN
    CALL getValueSetString(p_selectedMedicationValueSet, p_storetab, @selectedMedicationValueSetString);
    SET medicationValueSetString = @selectedMedicationValueSetString;
  ELSE  -- bring back everything
    SET medicationValueSetString = '1';
  END IF;
  -- create medication valueset 
  CALL createValueSet(medicationValueSetString, p_medicationValueSet_tmp);
  -- create concept from medication valueset
  CALL createConcept(p_medicationConcept_tmp, p_medicationValueSet_tmp, p_schema);
END IF;

IF p_clinicalEvents = 'TRUE' THEN
   SET eventTypeString = CONCAT(eventTypeString,'CLINICALEVENTS,');
  -- get date range string for clinical events
  IF p_dateFromClinicalEvents IS NOT NULL AND p_dateToClinicalEvents IS NOT NULL THEN
    SET clinicalEventsDateRangeString = getAgeDateRangeString(p_dateFromClinicalEvents, p_dateToClinicalEvents, 2); 
  ELSE
    SET clinicalEventsDateRangeString = '1';
  END IF;
  -- get valueset string for clinical events
  SET p_selectedClinicalEventValueSet = IF(p_selectedClinicalEventValueSet = '', NULL, p_selectedClinicalEventValueSet); 
  IF p_selectedClinicalEventValueSet IS NOT NULL THEN
    CALL getValueSetString(p_selectedClinicalEventValueSet, p_storetab, @selectedClinicalEventValueSetString);
    SET clinicalEventsValueSetString = @selectedClinicalEventValueSetString;
  ELSE  -- bring back everything
    SET clinicalEventsValueSetString = '1';
  END IF;
  -- create clinical events valueset 
  CALL createValueSet(clinicalEventsValueSetString, p_clinicalEventValueSet_tmp);
  -- create concept from clinical events valueset
  CALL createConcept(p_clinicalEventConcept_tmp, p_clinicalEventValueSet_tmp, p_schema);
  -- get clinical type string for clinical events
  SET p_selectedClinicalTypes = IF(p_selectedClinicalTypes = '', NULL, p_selectedClinicalTypes); 
  IF p_selectedClinicalTypes IS NOT NULL THEN
    CALL getClinicalTypesSetString(p_selectedClinicalTypes, p_storetab, @selectedClinicalTypesString);
    SET clinicalTypesSetString = @selectedClinicalTypesString;
  ELSE  -- bring back everything
    SET clinicalTypesSetString = '1';
  END IF;
  -- create clinical types set
  CALL createclinicalTypesSet(clinicalTypesSetString, p_clinicalTypes_tmp);
  -- create concept from clinical events valueset
  CALL createClinicalTypesConcept(p_clinicalTypesConcept_tmp, p_clinicalTypes_tmp, p_schema);
END IF;

      IF LENGTH(eventTypeString)>0 THEN
      -- remove the last comma in string
         SET eventTypeString = SUBSTRING(eventTypeString, 1, LENGTH(eventTypeString)-1);
      END IF;

  -- build datasets from event types
  CALL buildDatasets(p_query_id, p_patientcohorttab, eventTypeString, encountersDateRangeString, p_encounterConcept_tmp, medicationDateRangeString, 
  p_medicationConcept_tmp, p_currentMedication, clinicalEventsDateRangeString, p_clinicalEventConcept_tmp, p_clinicalTypesConcept_tmp, 
  p_activeProblems, p_schema);

  SET p_eventTypes = eventTypeString;

END //
DELIMITER ;