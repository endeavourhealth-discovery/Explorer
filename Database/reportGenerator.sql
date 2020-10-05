USE dashboards;

DROP PROCEDURE IF EXISTS reportGenerator;

DELIMITER //
CREATE PROCEDURE reportGenerator(query_id INT, query JSON)

BEGIN

-- declare variables --

DECLARE providerOrganisation VARCHAR(5000) DEFAULT NULL;
DECLARE includedOrganisation VARCHAR(5000) DEFAULT NULL; 
DECLARE registrationStatus VARCHAR(255) DEFAULT NULL; 

DECLARE cohortValue VARCHAR(5000) DEFAULT NULL; 
DECLARE valueDateFrom VARCHAR(20) DEFAULT NULL; 
DECLARE valueDateTo VARCHAR(20) DEFAULT NULL; 

DECLARE ageFrom VARCHAR(20) DEFAULT NULL;   
DECLARE ageTo VARCHAR(20) DEFAULT NULL;  
DECLARE postcode VARCHAR(20) DEFAULT NULL; 
DECLARE gender VARCHAR(20) DEFAULT NULL;  
DECLARE eventType VARCHAR(255) DEFAULT NULL; 
DECLARE active VARCHAR(10) DEFAULT NULL;

DECLARE datasetValue VARCHAR(1000) DEFAULT NULL;
DECLARE dateFrom VARCHAR(20) DEFAULT NULL; 
DECLARE dateTo VARCHAR(20) DEFAULT NULL; 

DECLARE outputField VARCHAR(1000) DEFAULT NULL;
DECLARE outputType VARCHAR(100) DEFAULT NULL;
DECLARE schedule VARCHAR(100) DEFAULT NULL;
DECLARE delivery VARCHAR(100) DEFAULT NULL;

DECLARE includedExclude1 VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll1 VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet1 VARCHAR(1000) DEFAULT NULL; 
DECLARE includedDateFrom1 VARCHAR(20) DEFAULT NULL; 
DECLARE includedDateTo1 VARCHAR(20) DEFAULT NULL; 
DECLARE includedPeriodValue1 VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType1 VARCHAR(20) DEFAULT NULL; 

DECLARE includedExclude1a VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll1a VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet1a VARCHAR(1000) DEFAULT NULL; 
DECLARE includedDateFrom1a VARCHAR(20) DEFAULT NULL; 
DECLARE includedDateTo1a VARCHAR(20) DEFAULT NULL; 
DECLARE includedPeriodValue1a VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType1a VARCHAR(20) DEFAULT NULL; 

DECLARE includedExclude1b VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll1b VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet1b VARCHAR(1000) DEFAULT NULL; 
DECLARE includedDateFrom1b VARCHAR(20) DEFAULT NULL; 
DECLARE includedDateTo1b VARCHAR(20) DEFAULT NULL; 
DECLARE includedPeriodValue1b VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType1b VARCHAR(20) DEFAULT NULL; 

DECLARE includedExclude2 VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll2 VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet2 VARCHAR(1000) DEFAULT NULL; 
DECLARE includedEarliestLatest2 VARCHAR(20) DEFAULT NULL; 
DECLARE includedOperator2 VARCHAR(50) DEFAULT NULL; 
DECLARE includedEntryValue2 VARCHAR(20) DEFAULT NULL; 
DECLARE includedDateFrom2 VARCHAR(20) DEFAULT NULL; 
DECLARE includedDateTo2 VARCHAR(20) DEFAULT NULL; 
DECLARE includedPeriodValue2 VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType2 VARCHAR(20) DEFAULT NULL; 

DECLARE includedExclude2a VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll2a VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet2a VARCHAR(1000) DEFAULT NULL; 
DECLARE includedEarliestLatest2a VARCHAR(20) DEFAULT NULL; 
DECLARE includedOperator2a VARCHAR(50) DEFAULT NULL; 
DECLARE includedEntryValue2a VARCHAR(20) DEFAULT NULL; 
DECLARE includedDateFrom2a VARCHAR(20) DEFAULT NULL; 
DECLARE includedDateTo2a VARCHAR(20) DEFAULT NULL; 
DECLARE includedPeriodValue2a VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType2a VARCHAR(20) DEFAULT NULL; 

DECLARE includedExclude3 VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll3 VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet3 VARCHAR(1000) DEFAULT NULL; 
DECLARE includedEarliestLatest3 VARCHAR(20) DEFAULT NULL; 
DECLARE includedAnyAllTested3 VARCHAR(10) DEFAULT NULL; 
DECLARE includedTestedValueSet3 VARCHAR(1000) DEFAULT NULL; 

DECLARE includedExclude4 VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll4 VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet4 VARCHAR(1000) DEFAULT NULL; 
DECLARE includedAreNot4 VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAllFollowedBy4 VARCHAR(10) DEFAULT NULL; 
DECLARE includedFollowedByValueSet4 VARCHAR(1000) DEFAULT NULL; 
DECLARE includedDateFrom4 VARCHAR(20) DEFAULT NULL; 
DECLARE includedDateTo4 VARCHAR(20) DEFAULT NULL; 
DECLARE includedPeriodValue4 VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType4 VARCHAR(20) DEFAULT NULL; 

DECLARE includedExclude5 VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll5 VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet5 VARCHAR(1000) DEFAULT NULL; 
DECLARE includedOperator5 VARCHAR(50) DEFAULT NULL; 
DECLARE includedEntryValue5 VARCHAR(20) DEFAULT NULL; 
DECLARE includedDateFrom5 VARCHAR(20) DEFAULT NULL; 
DECLARE includedDateTo5 VARCHAR(20) DEFAULT NULL; 
DECLARE includedPeriodValue5 VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType5 VARCHAR(20) DEFAULT NULL; 

DECLARE includeExclude1String VARCHAR(1000) DEFAULT NULL; 
DECLARE includeExclude1aString VARCHAR(1000) DEFAULT NULL; 
DECLARE includeExclude1bString VARCHAR(1000) DEFAULT NULL; 
DECLARE includeExclude2String VARCHAR(1000) DEFAULT NULL; 
DECLARE includeExclude2aString VARCHAR(1000) DEFAULT NULL; 
DECLARE includeExclude3String VARCHAR(1000) DEFAULT NULL; 
DECLARE includeExclude4String VARCHAR(1000) DEFAULT NULL; 
DECLARE includeExclude5String VARCHAR(1000) DEFAULT NULL; 

DECLARE sourceSchema VARCHAR(255) DEFAULT NULL;

DECLARE org_tmp VARCHAR(64) DEFAULT NULL;
DECLARE store_tmp VARCHAR(64) DEFAULT NULL;
DECLARE valueset_tmp VARCHAR(64) DEFAULT NULL;
DECLARE concept_tmp VARCHAR(64) DEFAULT NULL;
DECLARE cohort_tmp VARCHAR(64) DEFAULT NULL;
DECLARE observation_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incValueSet1_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incConcept1_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incValueSet1a_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incConcept1a_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incValueSet1b_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incConcept1b_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incValueSet2_tmp VARCHAR(64) DEFAULT NULL;

DECLARE incConcept2_tmp VARCHAR(64) DEFAULT NULL;
DECLARE observation2_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incValueSet2a_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incConcept2a_tmp VARCHAR(64) DEFAULT NULL;
DECLARE observation2a_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incValueSet3_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incConcept3_tmp VARCHAR(64) DEFAULT NULL;
DECLARE observation3_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incTestedValueset3_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incTestedConcept3_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incValueSet4_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incConcept4_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incFollowedByValueSet4_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incFollowedByConcept4_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incValueSet5_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incConcept5_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incOccurrences5_tmp VARCHAR(64) DEFAULT NULL;
DECLARE datasetValue_tmp VARCHAR(64) DEFAULT NULL;
DECLARE datasetConcept_tmp VARCHAR(64) DEFAULT NULL;
DECLARE patient_cohort_tmp VARCHAR(64) DEFAULT NULL;

DECLARE tempTables VARCHAR(5000);
-- set variables -- 
SET sourceSchema = 'subscriber_pi_rv';

SET providerOrganisation = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.providerOrganisation'),'[',''),']',''),'"','');
SET includedOrganisation = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedOrganisation'),'[',''),']',''),'"','');
SET registrationStatus = JSON_UNQUOTE(JSON_EXTRACT(query,'$.registrationStatus'));

SET cohortValue = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.cohortValue'),'[',''),']',''),'"','');
SET valueDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.valueDateFrom')); 
SET valueDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.valueDateTo')); 

SET ageFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.ageFrom'));
SET ageTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.ageTo'));  
SET gender = LOWER(JSON_UNQUOTE(JSON_EXTRACT(query,'$.gender'))); 
SET postcode = JSON_UNQUOTE(JSON_EXTRACT(query,'$.postcode'));
SET eventType = UPPER(REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.eventType'),'[',''),']',''),'"',''));
SET active = UPPER(JSON_EXTRACT(query,'$.active'));

SET datasetValue = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.datasetValue'),'[',''),']',''),'"','');
SET dateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.dateFrom')); 
SET dateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.dateTo')); 

SET outputField = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.outputField'),'[',''),']',''),'"',''); 
SET outputType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.outputType')); 
SET schedule = JSON_UNQUOTE(JSON_EXTRACT(query,'$.schedule')); 
SET delivery = JSON_UNQUOTE(JSON_EXTRACT(query,'$.delivery')); 

SET includedExclude1 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedExclude1')); 
SET includedAnyAll1 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1')); 
SET includedValueSet1 = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1'),'[',''),']',''),'"','');
SET includedDateFrom1 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1'));  
SET includedDateTo1 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1'));  
SET includedPeriodValue1 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1')); 
SET includedPeriodType1 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1'));

SET includedExclude1a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedExclude1a')); 
SET includedAnyAll1a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1a'));  
SET includedValueSet1a = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1a'),'[',''),']',''),'"','');
SET includedDateFrom1a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1a')); 
SET includedDateTo1a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1a')); 
SET includedPeriodValue1a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1a')); 
SET includedPeriodType1a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1a'));

SET includedExclude1b = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedExclude1b'));  
SET includedAnyAll1b = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1b')); 
SET includedValueSet1b = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1b'),'[',''),']',''),'"','');
SET includedDateFrom1b = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1b')); 
SET includedDateTo1b = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1b'));  
SET includedPeriodValue1b = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1b'));
SET includedPeriodType1b = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1b'));

SET includedExclude2 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedExclude2'));
SET includedAnyAll2 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll2'));
SET includedValueSet2 = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet2'),'[',''),']',''),'"','');  
SET includedEarliestLatest2 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedEarliestLatest2')); 
SET includedOperator2 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedOperator2')); 
SET includedEntryValue2 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedEntryValue2')); 
SET includedDateFrom2 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom2'));  
SET includedDateTo2 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo2'));  
SET includedPeriodValue2 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue2')); 
SET includedPeriodType2 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType2'));  

SET includedExclude2a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedExclude2a')); 
SET includedAnyAll2a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll2a'));
SET includedValueSet2a = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet2a'),'[',''),']',''),'"','');
SET includedEarliestLatest2a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedEarliestLatest2a'));
SET includedOperator2a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedOperator2a'));
SET includedEntryValue2a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedEntryValue2a')); 
SET includedDateFrom2a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom2a')); 
SET includedDateTo2a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo2a'));  
SET includedPeriodValue2a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue2a'));
SET includedPeriodType2a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType2a'));

SET includedExclude3 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedExclude3')); 
SET includedAnyAll3 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll3'));
SET includedValueSet3 = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet3'),'[',''),']',''),'"','');
SET includedEarliestLatest3 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedEarliestLatest3'));
SET includedAnyAllTested3 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAllTested3'));
SET includedTestedValueSet3 = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedTestedValueSet3'),'[',''),']',''),'"','');

SET includedExclude4 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedExclude4')); 
SET includedAnyAll4 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll4'));
SET includedValueSet4 = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet4'),'[',''),']',''),'"','');
SET includedAreNot4 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAreNot4'));
SET includedAnyAllFollowedBy4 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAllFollowedBy4'));
SET includedFollowedByValueSet4 = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedFollowedByValueSet4'),'[',''),']',''),'"','');
SET includedDateFrom4 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom4')); 
SET includedDateTo4 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo4')); 
SET includedPeriodValue4 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue4')); 
SET includedPeriodType4 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType4')); 

SET includedExclude5 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedExclude5')); 
SET includedAnyAll5 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll5'));
SET includedValueSet5 = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet5'),'[',''),']',''),'"','');
SET includedOperator5 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedOperator5'));
SET includedEntryValue5 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedEntryValue5')); 
SET includedDateFrom5 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom5')); 
SET includedDateTo5 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo5')); 
SET includedPeriodValue5 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue5')); 
SET includedPeriodType5 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType5')); 

SET org_tmp  = CONCAT('org_tmp_',query_id);
SET store_tmp  = CONCAT('store_tmp_',query_id);
SET valueset_tmp  = CONCAT('valueset_tmp_',query_id);
SET concept_tmp  = CONCAT('concept_tmp_',query_id);
SET cohort_tmp  = CONCAT('cohort_tmp_',query_id);
SET observation_tmp  = CONCAT('observation_tmp_',query_id);
SET incValueSet1_tmp  = CONCAT('incValueSet1_tmp_',query_id);
SET incConcept1_tmp  = CONCAT('incConcept1_tmp_',query_id);
SET incValueSet1a_tmp  = CONCAT('incValueSet1a_tmp_',query_id);
SET incConcept1a_tmp  = CONCAT('incConcept1a_tmp_',query_id);
SET incValueSet1b_tmp  = CONCAT('incValueSet1b_tmp_',query_id);
SET incConcept1b_tmp  = CONCAT('incConcept1b_tmp_',query_id);
SET incValueSet2_tmp  = CONCAT('incValueSet2_tmp_',query_id);

SET incConcept2_tmp  = CONCAT('incConcept2_tmp_',query_id);
SET observation2_tmp  = CONCAT('observation2_tmp_',query_id);
SET incValueSet2a_tmp  = CONCAT('incValueSet2a_tmp_',query_id);
SET incConcept2a_tmp  = CONCAT('incConcept2a_tmp_',query_id);
SET observation2a_tmp  = CONCAT('observation2a_tmp_',query_id);
SET incValueSet3_tmp  = CONCAT('incValueSet3_tmp_',query_id);
SET incConcept3_tmp  = CONCAT('incConcept3_tmp_',query_id);
SET observation3_tmp  = CONCAT('observation3_tmp_',query_id);
SET incTestedValueset3_tmp  = CONCAT('incTestedValueset3_tmp_',query_id);
SET incTestedConcept3_tmp  = CONCAT('incTestedConcept3_tmp_',query_id);
SET incValueSet4_tmp  = CONCAT('incValueSet4_tmp_',query_id);
SET incConcept4_tmp  = CONCAT('incConcept4_tmp_',query_id);
SET incFollowedByValueSet4_tmp  = CONCAT('incFollowedByValueSet4_tmp_',query_id);
SET incFollowedByConcept4_tmp  = CONCAT('incFollowedByConcept4_tmp_',query_id);
SET incValueSet5_tmp  = CONCAT('incValueSet5_tmp_',query_id);
SET incConcept5_tmp  = CONCAT('incConcept5_tmp_',query_id);
SET incOccurrences5_tmp  = CONCAT('incOccurrences5_tmp_',query_id);
SET datasetValue_tmp  = CONCAT('datasetValue_tmp_',query_id);
SET datasetConcept_tmp  = CONCAT('datasetConcept_tmp_',query_id);
SET patient_cohort_tmp  = CONCAT('patient_cohort_tmp_',query_id);

-- build cohort definition --

CALL buildCohortDefinition(providerOrganisation, includedOrganisation, registrationStatus, ageFrom, ageTo, gender, postcode, 
valueDateFrom, valueDateTo, cohortValue, org_tmp, valueset_tmp, concept_tmp, cohort_tmp, observation_tmp, sourceSchema, store_tmp);

-- build advance criteria --
-- 1 --
CALL getIncludeExcludeString(includedExclude1,includedAnyAll1,
includedValueSet1, includedDateFrom1, includedDateTo1, includedPeriodValue1,includedPeriodType1,
incValueSet1_tmp, incConcept1_tmp, observation_tmp, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, sourceSchema , store_tmp, @includeExclude1String);
SET includeExclude1String = @includeExclude1String;
-- 1a --
CALL getIncludeExcludeString(includedExclude1a,includedAnyAll1a,
includedValueSet1a, includedDateFrom1a, includedDateTo1a, includedPeriodValue1a,includedPeriodType1a,
incValueSet1a_tmp, incConcept1a_tmp, observation_tmp, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, sourceSchema , store_tmp, @includeExclude1aString);
SET includeExclude1aString = @includeExclude1aString;
-- 1b --
CALL getIncludeExcludeString(includedExclude1b,includedAnyAll1b,
includedValueSet1b, includedDateFrom1b, includedDateTo1b, includedPeriodValue1b,includedPeriodType1b, 
incValueSet1b_tmp, incConcept1b_tmp, observation_tmp, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, sourceSchema , store_tmp, @includeExclude1bString);
SET includeExclude1bString = @includeExclude1bString;

-- 2 -- 
CALL getIncludeExcludeString(includedExclude2,includedAnyAll2,
includedValueSet2, includedDateFrom2, includedDateTo2, includedPeriodValue2,includedPeriodType2, 
incValueSet2_tmp, incConcept2_tmp, observation_tmp, 2, includedEarliestLatest2, includedOperator2, includedEntryValue2, 
observation2_tmp,  NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, sourceSchema , store_tmp, @includeExclude2String);
SET includeExclude2String = @includeExclude2String;
-- 2a --
CALL getIncludeExcludeString(includedExclude2a,includedAnyAll2a,
includedValueSet2a, includedDateFrom2a, includedDateTo2a, includedPeriodValue2a,includedPeriodType2a, 
incValueSet2a_tmp, incConcept2a_tmp, observation_tmp, 2, includedEarliestLatest2a, includedOperator2a, includedEntryValue2a, 
observation2a_tmp, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, sourceSchema , store_tmp, @includeExclude2aString);
SET includeExclude2aString = @includeExclude2aString;

-- 3 --
CALL getIncludeExcludeString(includedExclude3,includedAnyAll3,
includedValueSet3, NULL, NULL, NULL, NULL, incValueSet3_tmp, incConcept3_tmp, observation_tmp, 3, includedEarliestLatest3, NULL, NULL, 
observation3_tmp, includedAnyAllTested3, includedTestedValueSet3, incTestedValueset3_tmp, incTestedConcept3_tmp, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, sourceSchema , store_tmp, @includeExclude3String);
SET includeExclude3String = @includeExclude3String;

-- 4 -- 
CALL getIncludeExcludeString(includedExclude4,includedAnyAll4,
includedValueSet4, includedDateFrom4, includedDateTo4, includedPeriodValue4, includedPeriodType4, incValueSet4_tmp, incConcept4_tmp, observation_tmp, 4, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, includedAreNot4, includedAnyAllFollowedBy4, includedFollowedByValueSet4, 
incFollowedByValueSet4_tmp, incFollowedByConcept4_tmp, NULL, NULL, NULL, sourceSchema , store_tmp, @includeExclude4String);
SET includeExclude4String = @includeExclude4String;

-- 5 -- 
CALL getIncludeExcludeString(includedExclude5,includedAnyAll5,
includedValueSet5, includedDateFrom5, includedDateTo5, includedPeriodValue5, includedPeriodType5, incValueSet5_tmp, incConcept5_tmp, 
observation_tmp, 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, incOccurrences5_tmp, 
includedOperator5, includedEntryValue5, sourceSchema , store_tmp, @includeExclude5String);
SET includeExclude5String = @includeExclude5String;

-- build final patient cohort based on advance criteria -- 
CALL buildFinalPatientCohort(query_id, patient_cohort_tmp, observation_tmp, includeExclude1String, includeExclude1aString, includeExclude1bString, 
includeExclude2String, includeExclude2aString, includeExclude3String, includeExclude4String, includeExclude5String);

-- build result datasets
CALL buildResultDatasets(query_id, patient_cohort_tmp, eventType, active, datasetValue, datasetValue_tmp, datasetConcept_tmp, dateFrom, dateTo, sourceSchema, store_tmp);

-- dataset output definition
CALL buildDatasetOutputTables(outputField, outputType, eventType, store_tmp, sourceSchema, query_id);

-- remove temp tables
 SET tempTables = CONCAT(org_tmp,',',store_tmp,',',valueset_tmp,',',concept_tmp ,',',cohort_tmp ,',',observation_tmp,',',incValueSet1_tmp,',',
 incConcept1_tmp,',',incValueSet1a_tmp,',',incConcept1a_tmp,',',incValueSet1b_tmp,',',incConcept1b_tmp,',',incValueSet2_tmp,',',
 incConcept2_tmp,',',observation2_tmp,',',incValueSet2a_tmp,',',incConcept2a_tmp,',',observation2a_tmp,',',incValueSet3_tmp,',',
 incConcept3_tmp,',',observation3_tmp,',',incTestedValueSet3_tmp,',',incTestedConcept3_tmp,',',incValueSet4_tmp,',',
 incConcept4_tmp,',',incFollowedByValueSet4_tmp,',',incFollowedByConcept4_tmp ,',',incValueSet5_tmp,',',
 incConcept5_tmp,',',incOccurrences5_tmp,',',datasetValue_tmp,',',datasetConcept_tmp,',',patient_cohort_tmp);

CALL dropTempTables(tempTables);

/*
select registrationStatus; 

select cohortValue;
select ageFrom ;
select ageTo ;
select postcode ;
select eventType  ;
select active 	  ;
select datasetValue  ;
select dateFrom   ;
select dateTo 	 ;
select outputField ;
select outputType ;
select schedule  ;
select delivery    ; 

select includedExclude1;
select includedAnyAll1 ;
select includedValueSet1 ;
select includedDateFrom1;
select includedDateTo1;
select includedPeriodValue1;
select includedPeriodType1;

select includedExclude1a;
select includedAnyAll1a ;
select includedValueSet1a ;
select includedDateFrom1a ;
select includedDateTo1a;
select includedPeriodValue1a ;
select includedPeriodType1a ;

select includedExclude1b ;
select includedAnyAll1b ;
select includedValueSet1b ;
select includedDateFrom1b ;
select includedDateTo1b ;
select includedPeriodValue1b;
select includedPeriodType1b ;


select includedExclude2;
select includedAnyAll2 ; 
select includedValueSet2;  
select includedEarliestLatest2;  
select includedOperator2; 
select includedEntryValue2; 
select includedDateFrom2; 
select includedDateTo2; 
select includedPeriodValue2; 
select includedPeriodType2;  

select includedExclude2a; 
select includedAnyAll2a;
select includedValueSet2a;
select includedEarliestLatest2a;
select includedOperator2a;
select includedEntryValue2a; 
select includedDateFrom2a;
select includedDateTo2a; 
select includedPeriodValue2a;
select includedPeriodType2a;

select includedExclude3; 
select  includedAnyAll3;
select  includedValueSet3;
select  includedEarliestLatest3;
select  includedAnyAllTested3;
select  includedTestedValueSet3;

select  includedExclude4; 
select  includedAnyAll4 ;
select  includedValueSet4;
select  includedAreNot4;
select  includedAnyAllFollowedBy4;
select  includedFollowedByValueSet4;
select  includedDateFrom4; 
select  includedDateTo4 ; 
select  includedPeriodValue4; 
select  includedPeriodType4; 

select  includedExclude5; 
select  includedAnyAll5;
select  includedValueSet5;
select  includedOperator5;
select  includedEntryValue5 ; 
select  includedDateFrom5 ; 
select  includedDateTo5 ; 
select  includedPeriodValue5 ; 
select  includedPeriodType5 ; 

*/

/* usuage: 

call reportGenerator(14, '{"providerOrganisation":["NHS CITY AND HACKNEY CCG","NHS Newham CCG","NHS TOWER HAMLETS CCG","NHS WALTHAM FOREST CCG"],
 "includedOrganisation":["BARTS HEALTH NHS TRUST","HOMERTON UNIVERSITY HOSPITAL NHS FOUNDATION TRUST"],
 "registrationStatus":"All patients included left and deads",
 "cohortValue":["Diabetes","Asthma","COPD"],
 "ageFrom":"60",
 "ageTo":"80",
 "gender":"All",
 "postcode":"WF2 6NL",
 "eventType":["Person","Clinical events","Medication"],
 "active":false,
 "datasetValue":["Diabetes","Asthma","COPD"],
 "dateFrom":"2020-08-01",
 "dateTo":"2020-08-31",
 "outputField":["Patient ID","Patient NHS number","Pseudo NHS number","Effective date","Concept name","Owning organisation","Numeric value","Post code","Age","Gender","Registered organisation","Death status"],
 "outputType":"",
 "schedule":"Weekly",
 "delivery":"NHS email"}');  */


END//
DELIMITER ;