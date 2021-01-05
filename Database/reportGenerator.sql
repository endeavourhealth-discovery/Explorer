USE dashboards;

DROP PROCEDURE IF EXISTS reportGenerator;

DELIMITER //
CREATE PROCEDURE reportGenerator(query_id INT, query JSON)

BEGIN

DECLARE sourceSchema VARCHAR(255) DEFAULT NULL;
-- variables for patient cohort
DECLARE targetPercentage VARCHAR(10) DEFAULT NULL;
DECLARE providerOrganisation VARCHAR(5000) DEFAULT NULL;
DECLARE includedOrganisation VARCHAR(5000) DEFAULT NULL; 
DECLARE registrationStatus VARCHAR(255) DEFAULT NULL; 

DECLARE ageFrom VARCHAR(20) DEFAULT NULL;   
DECLARE ageTo VARCHAR(20) DEFAULT NULL;  
DECLARE postcode VARCHAR(20) DEFAULT NULL; 
DECLARE gender VARCHAR(20) DEFAULT NULL;  

-- variables for rules builder
DECLARE matching1 VARCHAR(30) DEFAULT NULL;
DECLARE queryExpression1 VARCHAR(255) DEFAULT NULL;

DECLARE selectReject2 VARCHAR(30) DEFAULT NULL;
DECLARE matching2 VARCHAR(30) DEFAULT NULL;
DECLARE queryExpression2 VARCHAR(255) DEFAULT NULL;
DECLARE ruleNumber2 VARCHAR(20) DEFAULT NULL;

DECLARE selectReject3 VARCHAR(30) DEFAULT NULL;
DECLARE matching3 VARCHAR(30) DEFAULT NULL;
DECLARE queryExpression3 VARCHAR(255) DEFAULT NULL;
DECLARE ruleNumber3 VARCHAR(20) DEFAULT NULL;

DECLARE selectReject4 VARCHAR(30) DEFAULT NULL;
DECLARE matching4 VARCHAR(30) DEFAULT NULL;
DECLARE queryExpression4 VARCHAR(255) DEFAULT NULL;
DECLARE ruleNumber4 VARCHAR(20) DEFAULT NULL;

DECLARE selectReject5 VARCHAR(30) DEFAULT NULL;
DECLARE matching5 VARCHAR(30) DEFAULT NULL;
DECLARE queryExpression5 VARCHAR(255) DEFAULT NULL;
DECLARE ruleNumber5 VARCHAR(20) DEFAULT NULL;

DECLARE selectReject6 VARCHAR(30) DEFAULT NULL;
DECLARE matching6 VARCHAR(30) DEFAULT NULL;
DECLARE queryExpression6 VARCHAR(255) DEFAULT NULL;
DECLARE ruleNumber6 VARCHAR(20) DEFAULT NULL;

DECLARE selectReject7 VARCHAR(30) DEFAULT NULL;
DECLARE matching7 VARCHAR(30) DEFAULT NULL;
DECLARE queryExpression7 VARCHAR(255) DEFAULT NULL;
DECLARE ruleNumber7 VARCHAR(20) DEFAULT NULL;

DECLARE selectReject8 VARCHAR(30) DEFAULT NULL;
DECLARE matching8 VARCHAR(30) DEFAULT NULL;
DECLARE queryExpression8 VARCHAR(255) DEFAULT NULL;
DECLARE ruleNumber8 VARCHAR(20) DEFAULT NULL;

DECLARE selectReject9 VARCHAR(30) DEFAULT NULL;
DECLARE matching9 VARCHAR(30) DEFAULT NULL;
DECLARE queryExpression9 VARCHAR(255) DEFAULT NULL;
DECLARE ruleNumber9 VARCHAR(20) DEFAULT NULL;

DECLARE selectReject10 VARCHAR(30) DEFAULT NULL;
DECLARE matching10 VARCHAR(30) DEFAULT NULL;
DECLARE queryExpression10 VARCHAR(255) DEFAULT NULL;
DECLARE ruleNumber10 VARCHAR(20) DEFAULT NULL;

DECLARE selectReject11 VARCHAR(30) DEFAULT NULL;
DECLARE matching11 VARCHAR(30) DEFAULT NULL;
DECLARE queryExpression11 VARCHAR(255) DEFAULT NULL;
DECLARE ruleNumber11 VARCHAR(20) DEFAULT NULL;

DECLARE selectReject12 VARCHAR(30) DEFAULT NULL;
DECLARE matching12 VARCHAR(30) DEFAULT NULL;
DECLARE queryExpression12 VARCHAR(255) DEFAULT NULL;
DECLARE ruleNumber12 VARCHAR(20) DEFAULT NULL;

DECLARE selectReject13 VARCHAR(30) DEFAULT NULL;
DECLARE matching13 VARCHAR(30) DEFAULT NULL;
DECLARE queryExpression13 VARCHAR(255) DEFAULT NULL;
DECLARE ruleNumber13 VARCHAR(20) DEFAULT NULL;

DECLARE selectReject14 VARCHAR(30) DEFAULT NULL;
DECLARE matching14 VARCHAR(30) DEFAULT NULL;
DECLARE queryExpression14 VARCHAR(255) DEFAULT NULL;
DECLARE ruleNumber14 VARCHAR(20) DEFAULT NULL;

DECLARE selectReject15 VARCHAR(30) DEFAULT NULL;
DECLARE matching15 VARCHAR(30) DEFAULT NULL;
DECLARE queryExpression15 VARCHAR(255) DEFAULT NULL;
DECLARE ruleNumber15 VARCHAR(20) DEFAULT NULL;

DECLARE selectReject16 VARCHAR(30) DEFAULT NULL;
DECLARE matching16 VARCHAR(30) DEFAULT NULL;
DECLARE queryExpression16 VARCHAR(255) DEFAULT NULL;
DECLARE ruleNumber16 VARCHAR(20) DEFAULT NULL;

DECLARE selectRejects VARCHAR(600) DEFAULT NULL; 
DECLARE matchings VARCHAR(600) DEFAULT NULL; 
DECLARE queryExpressions VARCHAR(5000) DEFAULT NULL;
DECLARE ruleNumbers VARCHAR(600) DEFAULT NULL;  

-- variables for datasets
DECLARE eventTypes VARCHAR(255) DEFAULT NULL; 
DECLARE demographics VARCHAR(10) DEFAULT NULL;
DECLARE encounters VARCHAR(10) DEFAULT NULL;
DECLARE medication VARCHAR(10) DEFAULT NULL;
DECLARE currentMedication VARCHAR(10) DEFAULT NULL;
DECLARE clinicalEvents VARCHAR(10) DEFAULT NULL;
DECLARE activeProblems VARCHAR(10) DEFAULT NULL;
DECLARE dateFromEncounters VARCHAR(30) DEFAULT NULL; 
DECLARE dateToEncounters VARCHAR(30) DEFAULT NULL; 
DECLARE dateFromMedication VARCHAR(30) DEFAULT NULL; 
DECLARE dateToMedication VARCHAR(30) DEFAULT NULL; 
DECLARE dateFromClinicalEvents VARCHAR(30) DEFAULT NULL; 
DECLARE dateToClinicalEvents VARCHAR(30) DEFAULT NULL; 
DECLARE selectedDemographicFields VARCHAR(2000) DEFAULT NULL;
DECLARE selectedEncounterFields VARCHAR(2000) DEFAULT NULL;
DECLARE selectedMedicationFields VARCHAR(2000) DEFAULT NULL;
DECLARE selectedClinicalEventFields VARCHAR(2000) DEFAULT NULL;
DECLARE selectedClinicalTypes VARCHAR(1000) DEFAULT NULL;
DECLARE selectedEncounterValueSet VARCHAR(1000) DEFAULT NULL;
DECLARE selectedMedicationValueSet VARCHAR(1000) DEFAULT NULL;
DECLARE selectedClinicalEventValueSet VARCHAR(1000) DEFAULT NULL;
DECLARE timeSeries VARCHAR(10) DEFAULT NULL;
DECLARE seriesTable VARCHAR(50) DEFAULT NULL; 
DECLARE seriesField VARCHAR(100) DEFAULT NULL; 
DECLARE seriesEncounterValueSet VARCHAR(1000) DEFAULT NULL; 
DECLARE seriesMedicationValueSet VARCHAR(1000) DEFAULT NULL; 
DECLARE seriesClinicalEventValueSet VARCHAR(1000) DEFAULT NULL; 
DECLARE seriesDateFrom VARCHAR(30) DEFAULT NULL;
DECLARE seriesDateTo VARCHAR(30) DEFAULT NULL;
DECLARE seriesPeriodOperator VARCHAR(50) DEFAULT NULL;
DECLARE seriesPeriodValue VARCHAR(10) DEFAULT NULL; 
DECLARE seriesPeriodType VARCHAR(20) DEFAULT NULL; 
-- variables for dataset outputs
DECLARE schedule VARCHAR(100) DEFAULT NULL;
DECLARE delivery VARCHAR(100) DEFAULT NULL;
-- variables for temp tables
DECLARE org_tmp VARCHAR(64) DEFAULT NULL;
DECLARE store_tmp VARCHAR(64) DEFAULT NULL;

DECLARE all_valueset_tmp VARCHAR(64) DEFAULT NULL;
DECLARE all_concept_tmp VARCHAR(64) DEFAULT NULL;
DECLARE practiceCohort_tmp VARCHAR(64) DEFAULT NULL;
DECLARE registerCohort_tmp VARCHAR(64) DEFAULT NULL;
DECLARE observationCohort_tmp VARCHAR(64) DEFAULT NULL;

DECLARE Q1 VARCHAR(64) DEFAULT NULL;
DECLARE Q1A VARCHAR(64) DEFAULT NULL;
DECLARE Q1B VARCHAR(64) DEFAULT NULL;
DECLARE Q1C VARCHAR(64) DEFAULT NULL;
DECLARE Q1D VARCHAR(64) DEFAULT NULL;
DECLARE Q2 VARCHAR(64) DEFAULT NULL;
DECLARE Q2A VARCHAR(64) DEFAULT NULL;
DECLARE Q3 VARCHAR(64) DEFAULT NULL;
DECLARE Q3A VARCHAR(64) DEFAULT NULL;
DECLARE Q4 VARCHAR(64) DEFAULT NULL;
DECLARE Q5 VARCHAR(64) DEFAULT NULL;
DECLARE Q5A VARCHAR(64) DEFAULT NULL;

DECLARE Q0 VARCHAR(64) DEFAULT NULL;

DECLARE encounterValueSet_tmp VARCHAR(64) DEFAULT NULL;
DECLARE medicationValueSet_tmp VARCHAR(64) DEFAULT NULL;
DECLARE clinicalEventValueSet_tmp VARCHAR(64) DEFAULT NULL;
DECLARE procedure_req_tmp VARCHAR(64) DEFAULT NULL;
DECLARE diagnostic_tmp VARCHAR(64) DEFAULT NULL;
DECLARE warning_tmp VARCHAR(64) DEFAULT NULL;
DECLARE allergy_tmp VARCHAR(64) DEFAULT NULL;
DECLARE referral_req_tmp VARCHAR(64) DEFAULT NULL;
DECLARE encounterConcept_tmp VARCHAR(64) DEFAULT NULL;
DECLARE medicationConcept_tmp VARCHAR(64) DEFAULT NULL;
DECLARE clinicalEventConcept_tmp VARCHAR(64) DEFAULT NULL;
DECLARE seriesValueset_tmp VARCHAR(64) DEFAULT NULL; 
DECLARE seriesConcept_tmp VARCHAR(64) DEFAULT NULL; 

DECLARE patientCohort_tmp VARCHAR(64) DEFAULT NULL;

DECLARE tempTables VARCHAR(5000);

DECLARE rule_tmp VARCHAR(64) DEFAULT NULL; 
DECLARE rule_det_tmp VARCHAR(64) DEFAULT NULL; 

-- Set Variables for Cohort definition -- 
SET sourceSchema = 'subscriber_pi_rv';

SET targetPercentage = JSON_UNQUOTE(JSON_EXTRACT(query,'$.targetPercentage')); 
SET providerOrganisation = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.providerOrganisation'),'[',''),']',''),'"','');
SET includedOrganisation = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedOrganisation'),'[',''),']',''),'"','');
SET registrationStatus = JSON_UNQUOTE(JSON_EXTRACT(query,'$.registrationStatus'));

SET ageFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.ageFrom'));
SET ageTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.ageTo'));  
SET gender = LOWER(JSON_UNQUOTE(JSON_EXTRACT(query,'$.gender'))); 
SET postcode = JSON_UNQUOTE(JSON_EXTRACT(query,'$.postcode'));
SET org_tmp = CONCAT('org_tmp_',query_id);
SET store_tmp = CONCAT('store_tmp_',query_id);

-- Set Variables for Query expression --
SET matching1 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.matching1'));
SET queryExpression1 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.queryExpression1')); 

SET selectReject2 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.selectReject2'));
SET matching2 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.matching2'));
SET queryExpression2 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.queryExpression2')); 
SET ruleNumber2 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.ruleNumber2'));

SET selectReject3 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.selectReject3'));
SET matching3 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.matching3'));
SET queryExpression3 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.queryExpression3')); 
SET ruleNumber3 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.ruleNumber3'));

SET selectReject4 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.selectReject4'));
SET matching4 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.matching4'));
SET queryExpression4 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.queryExpression4')); 
SET ruleNumber4 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.ruleNumber4'));

SET selectReject5 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.selectReject5'));
SET matching5 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.matching5'));
SET queryExpression5 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.queryExpression5'));
SET ruleNumber5 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.ruleNumber5'));

SET selectReject6 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.selectReject6'));
SET matching6 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.matching6'));
SET queryExpression6 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.queryExpression6')); 
SET ruleNumber6 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.ruleNumber6'));

SET selectReject7 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.selectReject7'));
SET matching7 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.matching7'));
SET queryExpression7 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.queryExpression7')); 
SET ruleNumber7 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.ruleNumber7'));

SET selectReject8 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.selectReject8'));
SET matching8 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.matching8'));
SET queryExpression8 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.queryExpression8')); 
SET ruleNumber8 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.ruleNumber8'));

SET selectReject9 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.selectReject9'));
SET matching9 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.matching9'));
SET queryExpression9 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.queryExpression9')); 
SET ruleNumber9 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.ruleNumber9'));

SET selectReject10 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.selectReject10'));
SET matching10 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.matching10'));
SET queryExpression10 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.queryExpression10')); 
SET ruleNumber10 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.ruleNumber10'));

SET selectReject11 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.selectReject11'));
SET matching11 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.matching11'));
SET queryExpression11 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.queryExpression11')); 
SET ruleNumber11 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.ruleNumber11'));

SET selectReject12 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.selectReject12'));
SET matching12 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.matching12'));
SET queryExpression12 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.queryExpression12')); 
SET ruleNumber12 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.ruleNumber12'));

SET selectReject13 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.selectReject13'));
SET matching13 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.matching13'));
SET queryExpression13 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.queryExpression13')); 
SET ruleNumber13 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.ruleNumber13'));

SET selectReject14 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.selectReject14'));
SET matching14 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.matching14'));
SET queryExpression14 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.queryExpression14')); 
SET ruleNumber14 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.ruleNumber14'));

SET selectReject15 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.selectReject15'));
SET matching15 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.matching15'));
SET queryExpression15 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.queryExpression15'));
SET ruleNumber15 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.ruleNumber15'));

SET selectReject16 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.selectReject16'));
SET matching16 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.matching16'));
SET queryExpression16 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.queryExpression16'));
SET ruleNumber16 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.ruleNumber16'));

-- Set Variables for Events --
SET demographics = UPPER(JSON_EXTRACT(query,'$.demographics')); 
SET encounters = UPPER(JSON_EXTRACT(query,'$.encounters')); 
SET medication = UPPER(JSON_EXTRACT(query,'$.medication')); 
SET currentMedication = UPPER(JSON_EXTRACT(query,'$.currentMedication')); 
SET clinicalEvents = UPPER(JSON_EXTRACT(query,'$.clinicalEvents')); 
SET activeProblems = UPPER(JSON_EXTRACT(query,'$.activeProblems')); 

SET dateFromEncounters = JSON_UNQUOTE(JSON_EXTRACT(query,'$.dateFromEncounters'));   
SET dateToEncounters = JSON_UNQUOTE(JSON_EXTRACT(query,'$.dateToEncounters'));   
SET dateFromMedication = JSON_UNQUOTE(JSON_EXTRACT(query,'$.dateFromMedication'));   
SET dateToMedication = JSON_UNQUOTE(JSON_EXTRACT(query,'$.dateToMedication'));   
SET dateFromClinicalEvents = JSON_UNQUOTE(JSON_EXTRACT(query,'$.dateFromClinicalEvents'));   
SET dateToClinicalEvents = JSON_UNQUOTE(JSON_EXTRACT(query,'$.dateToClinicalEvents'));   

SET selectedDemographicFields = REPLACE(REPLACE(JSON_EXTRACT(query,'$.selectedDemographicFields'),'[',''),']',''); 
SET selectedEncounterFields = REPLACE(REPLACE(JSON_EXTRACT(query,'$.selectedEncounterFields'),'[',''),']','');  
SET selectedMedicationFields = REPLACE(REPLACE(JSON_EXTRACT(query,'$.selectedMedicationFields'),'[',''),']','');  
SET selectedClinicalEventFields = REPLACE(REPLACE(JSON_EXTRACT(query,'$.selectedClinicalEventFields'),'[',''),']','');  

SET selectedClinicalTypes = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.selectedClinicalTypes'),'[',''),']',''),'"','');  

SET selectedEncounterValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.selectedEncounterValueSet'),'[',''),']',''),'"','');
SET selectedMedicationValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.selectedMedicationValueSet'),'[',''),']',''),'"','');
SET selectedClinicalEventValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.selectedClinicalEventValueSet'),'[',''),']',''),'"','');

SET timeSeries = UPPER(JSON_EXTRACT(query,'$.timeSeries')); 
SET seriesTable = JSON_UNQUOTE(JSON_EXTRACT(query,'$.seriesTable'));
SET seriesField = JSON_UNQUOTE(JSON_EXTRACT(query,'$.seriesField'));
SET seriesEncounterValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.seriesEncounterValueSet'),'[',''),']',''),'"','');
SET seriesMedicationValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.seriesMedicationValueSet'),'[',''),']',''),'"','');
SET seriesClinicalEventValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.seriesClinicalEventValueSet'),'[',''),']',''),'"','');

SET seriesDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.seriesDateFrom')); 
SET seriesDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.seriesDateTo')); 
SET seriesPeriodOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.seriesPeriodOperator'));
SET seriesPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.seriesPeriodValue')); 
SET seriesPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.seriesPeriodType'));

-- Set Variables for Output --
SET schedule = JSON_UNQUOTE(JSON_EXTRACT(query,'$.schedule')); 
SET delivery = JSON_UNQUOTE(JSON_EXTRACT(query,'$.delivery')); 

-- Set Variables for Query tmp tables --
SET Q1 = CONCAT('Q1_',query_id);
SET Q1A = CONCAT('Q1A_',query_id);
SET Q1B = CONCAT('Q1B_',query_id);
SET Q1C = CONCAT('Q1C_',query_id);
SET Q1D = CONCAT('Q1D_',query_id);
SET Q2 = CONCAT('Q2_',query_id);
SET Q2A = CONCAT('Q2A_',query_id);
SET Q3 = CONCAT('Q3_',query_id);
SET Q3A = CONCAT('Q3A_',query_id);
SET Q4 = CONCAT('Q4_',query_id);
SET Q5 = CONCAT('Q5_',query_id);
SET Q5A = CONCAT('Q5A_',query_id);

SET Q0 = CONCAT('Q0_',query_id);

SET all_valueset_tmp = CONCAT('all_valueset_tmp_',query_id);
SET all_concept_tmp = CONCAT('all_concept_tmp_',query_id);
SET practiceCohort_tmp  = CONCAT('practiceCohort_tmp_',query_id);
SET registerCohort_tmp  = CONCAT('registerCohort_tmp_',query_id);
SET observationCohort_tmp = CONCAT('observationCohort_tmp_',query_id);

-- event valuesets and concept tmp tables --
SET encounterValueSet_tmp = CONCAT('encounterValueSet_tmp_',query_id);
SET medicationValueSet_tmp = CONCAT('medicationValueSet_tmp_',query_id);
SET clinicalEventValueSet_tmp = CONCAT('clinicalEventValueSet_tmp_',query_id);

SET encounterConcept_tmp  = CONCAT('encounterConcept_tmp_',query_id);
SET medicationConcept_tmp  = CONCAT('medicationConcept_tmp_',query_id);
SET clinicalEventConcept_tmp  = CONCAT('clinicalEventConcept_tmp_',query_id);

SET procedure_req_tmp = CONCAT('procedure_req_tmp_',query_id);
SET diagnostic_tmp = CONCAT('diagnostic_tmp_',query_id);
SET warning_tmp = CONCAT('warning_tmp_',query_id);
SET allergy_tmp = CONCAT('allergy_tmp_',query_id);
SET referral_req_tmp = CONCAT('referral_req_tmp_',query_id);

-- time series value set and concept tmp tables --
SET seriesValueset_tmp = CONCAT('seriesValueset_tmp_',query_id); 
SET seriesConcept_tmp = CONCAT('seriesConcept_tmp_',query_id);

SET patientCohort_tmp = CONCAT('patientCohort_tmp_',query_id);

SET rule_tmp = CONCAT('rule_tmp_',query_id);
SET rule_det_tmp = CONCAT('rule_det_tmp_',query_id);

-- build practice cohort -- 
CALL buildCohortDefinition(query_id, providerOrganisation, includedOrganisation, registrationStatus, ageFrom, ageTo, gender, postcode, org_tmp, practiceCohort_tmp, store_tmp, sourceSchema);
-- build observation cohort for all valuesets to be used in the advance queries --
CALL createValueSet('1', all_valueset_tmp);
CALL createConcept(all_concept_tmp, all_valueset_tmp, sourceSchema);
CALL createObservationCohort(observationCohort_tmp, practiceCohort_tmp, all_concept_tmp, sourceSchema);

-- build register rule
CALL buildRegisterRule(query_id, matching1, queryExpression1, rule_tmp);
-- build rules 
SET selectRejects = CONCAT(selectReject2,',',selectReject3,',',selectReject4,',',selectReject5,',',selectReject6,',',selectReject7,',',selectReject8,',',selectReject9,',',
selectReject10,',',selectReject11,',',selectReject12,',',selectReject13,',',selectReject14,',',selectReject15,',',selectReject16);
SET matchings = CONCAT(matching2,',',matching3,',',matching4,',',matching5,',',matching6,',',matching7,',',matching8,',',matching9,',',
matching10,',',matching11,',',matching12,',',matching13,',',matching14,',',matching15,',',matching16);
SET queryExpressions = CONCAT(queryExpression2,',',queryExpression3,',',queryExpression4,',',queryExpression5,',',queryExpression6,',',queryExpression7,',',queryExpression8,',',queryExpression9,',',
queryExpression10,',',queryExpression11,',',queryExpression12,',',queryExpression13,',',queryExpression14,',',queryExpression15,',',queryExpression16);
SET ruleNumbers = CONCAT(ruleNumber2,',',ruleNumber3,',',ruleNumber4,',',ruleNumber5,',',ruleNumber6,',',ruleNumber7,',',ruleNumber8,',',ruleNumber9,',',
ruleNumber10,',',ruleNumber11,',',ruleNumber12,',',ruleNumber13,',',ruleNumber14,',',ruleNumber15,',',ruleNumber16);
-- populate rules into a table
CALL populateRules(query_id, selectRejects, matchings, queryExpressions, ruleNumbers, rule_tmp);
-- split query expression
CALL splitQueryExpression(query_id, rule_tmp, rule_det_tmp);
-- build query for rules
CALL buildQueryExpression(query_id, rule_tmp, rule_det_tmp, practiceCohort_tmp);
-- process the rules
CALL processQueryExpression(query_id, query, rule_tmp, practiceCohort_tmp, registerCohort_tmp, observationCohort_tmp, store_tmp, sourceSchema);

-- build final patient cohort
CALL buildFinalPatientCohort(query_id, patientCohort_tmp, practiceCohort_tmp, rule_tmp, sourceSchema);

-- remove tmp tables
SET tempTables = CONCAT(org_tmp,',',observationCohort_tmp,',',practiceCohort_tmp,',',registerCohort_tmp,',',Q1,',',Q1A,',',Q1B,',',Q1C,',',
Q1D,',',Q2,',',Q2A,',',Q3,',',Q3A,',',Q4,',',Q5,',',Q5A,',',Q0,',',rule_tmp,',',rule_det_tmp,',',all_valueset_tmp,',', all_concept_tmp);

CALL dropTempTables(tempTables);

-- build result datasets
CALL buildResultDatasets(query_id, patientCohort_tmp, demographics, encounters, medication, currentMedication, clinicalEvents, activeProblems, 
dateFromEncounters, dateToEncounters, dateFromMedication, dateToMedication, dateFromClinicalEvents, dateToClinicalEvents, selectedClinicalTypes, 
selectedEncounterValueSet, selectedMedicationValueSet, selectedClinicalEventValueSet, procedure_req_tmp, diagnostic_tmp, warning_tmp ,allergy_tmp,referral_req_tmp,
encounterValueSet_tmp, encounterConcept_tmp, medicationValueSet_tmp, medicationConcept_tmp, clinicalEventValueSet_tmp, clinicalEventConcept_tmp, 
sourceSchema, store_tmp, @eventTypes);
SET eventTypes = @eventTypes;

-- update registries
CALL buildRegistries(query_id, patientCohort_tmp, targetPercentage);

-- build dataset outputs
CALL buildDatasetOutputTables(selectedDemographicFields, selectedEncounterFields, selectedMedicationFields, selectedClinicalEventFields, 
eventTypes, store_tmp, sourceSchema, query_id, patientCohort_tmp,procedure_req_tmp,diagnostic_tmp,warning_tmp,allergy_tmp,referral_req_tmp);
  
-- build time series
CALL buildTimeSeries(timeSeries, seriesTable, seriesField, seriesEncounterValueSet, seriesMedicationValueSet, seriesClinicalEventValueSet, 
seriesDateFrom, seriesDateTo, seriesPeriodOperator, seriesPeriodValue, seriesPeriodType, store_tmp, seriesValueset_tmp, seriesConcept_tmp, 
sourceSchema, query_id, patientCohort_tmp); 

-- update queue for next run date
CALL updateQueue(query_id, schedule);

-- remove temp tables
SET tempTables = CONCAT(store_tmp,',',encounterValueSet_tmp,',',encounterConcept_tmp,',',
medicationValueSet_tmp,',',medicationConcept_tmp,',',clinicalEventValueSet_tmp,',',clinicalEventConcept_tmp,',',
seriesValueset_tmp,',',seriesConcept_tmp,',',patientCohort_tmp,',',procedure_req_tmp,',',diagnostic_tmp,',',warning_tmp,',',allergy_tmp,',',referral_req_tmp);

CALL dropTempTables(tempTables);

END//
DELIMITER ;