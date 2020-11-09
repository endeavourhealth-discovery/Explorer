USE dashboards;

DROP PROCEDURE IF EXISTS reportGenerator;

DELIMITER //
CREATE PROCEDURE reportGenerator(query_id INT, query JSON)

BEGIN

-- declare variables --
DECLARE providerOrganisation VARCHAR(5000) DEFAULT NULL;
DECLARE includedOrganisation VARCHAR(5000) DEFAULT NULL; 
DECLARE registrationStatus VARCHAR(255) DEFAULT NULL; 

DECLARE registrationExclude VARCHAR(10) DEFAULT NULL; 
DECLARE registrationDateFrom VARCHAR(20) DEFAULT NULL;   
DECLARE registrationDateTo VARCHAR(20) DEFAULT NULL;   
DECLARE registrationPeriodValue VARCHAR(10) DEFAULT NULL; 
DECLARE registrationPeriodType VARCHAR(20) DEFAULT NULL; 

DECLARE ageFrom VARCHAR(20) DEFAULT NULL;   
DECLARE ageTo VARCHAR(20) DEFAULT NULL;  
DECLARE postcode VARCHAR(20) DEFAULT NULL; 
DECLARE gender VARCHAR(20) DEFAULT NULL;  
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

DECLARE schedule VARCHAR(100) DEFAULT NULL;
DECLARE delivery VARCHAR(100) DEFAULT NULL;

DECLARE includedExclude1 VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll1 VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet1 VARCHAR(1000) DEFAULT NULL; 
DECLARE includedDateFrom1 VARCHAR(30) DEFAULT NULL; 
DECLARE includedDateTo1 VARCHAR(30) DEFAULT NULL; 
DECLARE includedPeriodOperator1 VARCHAR(50) DEFAULT NULL;
DECLARE includedPeriodValue1 VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType1 VARCHAR(20) DEFAULT NULL; 

DECLARE includedExclude1a VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll1a VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet1a VARCHAR(1000) DEFAULT NULL; 
DECLARE includedDateFrom1a VARCHAR(30) DEFAULT NULL; 
DECLARE includedDateTo1a VARCHAR(30) DEFAULT NULL; 
DECLARE includedPeriodOperator1a VARCHAR(50) DEFAULT NULL;
DECLARE includedPeriodValue1a VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType1a VARCHAR(20) DEFAULT NULL; 

DECLARE includedExclude1b VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll1b VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet1b VARCHAR(1000) DEFAULT NULL; 
DECLARE includedDateFrom1b VARCHAR(30) DEFAULT NULL; 
DECLARE includedDateTo1b VARCHAR(30) DEFAULT NULL; 
DECLARE includedPeriodOperator1b VARCHAR(50) DEFAULT NULL;
DECLARE includedPeriodValue1b VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType1b VARCHAR(20) DEFAULT NULL; 

DECLARE includedExclude1c VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll1c VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet1c VARCHAR(1000) DEFAULT NULL; 
DECLARE includedDateFrom1c VARCHAR(30) DEFAULT NULL; 
DECLARE includedDateTo1c VARCHAR(30) DEFAULT NULL; 
DECLARE includedPeriodOperator1c VARCHAR(50) DEFAULT NULL;
DECLARE includedPeriodValue1c VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType1c VARCHAR(20) DEFAULT NULL; 

DECLARE includedExclude1d VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll1d VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet1d VARCHAR(1000) DEFAULT NULL; 
DECLARE includedDateFrom1d VARCHAR(30) DEFAULT NULL; 
DECLARE includedDateTo1d VARCHAR(30) DEFAULT NULL; 
DECLARE includedPeriodOperator1d VARCHAR(50) DEFAULT NULL;
DECLARE includedPeriodValue1d VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType1d VARCHAR(20) DEFAULT NULL; 

DECLARE includedExclude2 VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll2 VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet2 VARCHAR(1000) DEFAULT NULL; 
DECLARE includedEarliestLatest2 VARCHAR(20) DEFAULT NULL; 
DECLARE includedOperator2 VARCHAR(50) DEFAULT NULL; 
DECLARE includedEntryValue2 VARCHAR(20) DEFAULT NULL; 
DECLARE includedDateFrom2 VARCHAR(30) DEFAULT NULL; 
DECLARE includedDateTo2 VARCHAR(30) DEFAULT NULL; 
DECLARE includedPeriodOperator2 VARCHAR(50) DEFAULT NULL;
DECLARE includedPeriodValue2 VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType2 VARCHAR(20) DEFAULT NULL; 

DECLARE includedExclude2a VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll2a VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet2a VARCHAR(1000) DEFAULT NULL; 
DECLARE includedEarliestLatest2a VARCHAR(20) DEFAULT NULL; 
DECLARE includedOperator2a VARCHAR(50) DEFAULT NULL; 
DECLARE includedEntryValue2a VARCHAR(20) DEFAULT NULL; 
DECLARE includedDateFrom2a VARCHAR(30) DEFAULT NULL; 
DECLARE includedDateTo2a VARCHAR(30) DEFAULT NULL; 
DECLARE includedPeriodOperator2a VARCHAR(50) DEFAULT NULL;
DECLARE includedPeriodValue2a VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType2a VARCHAR(20) DEFAULT NULL; 

DECLARE includedExclude3 VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll3 VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet3 VARCHAR(1000) DEFAULT NULL; 
DECLARE includedEarliestLatest3 VARCHAR(20) DEFAULT NULL; 
DECLARE includedAnyAllTested3 VARCHAR(10) DEFAULT NULL; 
DECLARE includedTestedValueSet3 VARCHAR(1000) DEFAULT NULL;
DECLARE includedDateFrom3 VARCHAR(30) DEFAULT NULL; 
DECLARE includedDateTo3 VARCHAR(30) DEFAULT NULL; 
DECLARE includedPeriodOperator3 VARCHAR(50) DEFAULT NULL; 
DECLARE includedPeriodValue3 VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType3 VARCHAR(20) DEFAULT NULL; 

DECLARE includedExclude3a VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll3a VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet3a VARCHAR(1000) DEFAULT NULL; 
DECLARE includedEarliestLatest3a VARCHAR(20) DEFAULT NULL; 
DECLARE includedAnyAllTested3a VARCHAR(10) DEFAULT NULL; 
DECLARE includedTestedValueSet3a VARCHAR(1000) DEFAULT NULL;
DECLARE includedDateFrom3a VARCHAR(30) DEFAULT NULL; 
DECLARE includedDateTo3a VARCHAR(30) DEFAULT NULL; 
DECLARE includedPeriodOperator3a VARCHAR(50) DEFAULT NULL; 
DECLARE includedPeriodValue3a VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType3a VARCHAR(20) DEFAULT NULL; 

DECLARE includedExclude4 VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll4 VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet4 VARCHAR(1000) DEFAULT NULL; 
DECLARE includedAreNot4 VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAllFollowedBy4 VARCHAR(10) DEFAULT NULL; 
DECLARE includedFollowedByValueSet4 VARCHAR(1000) DEFAULT NULL; 
DECLARE includedDateFrom4 VARCHAR(30) DEFAULT NULL; 
DECLARE includedDateTo4 VARCHAR(30) DEFAULT NULL; 
DECLARE includedPeriodOperator4 VARCHAR(50) DEFAULT NULL;
DECLARE includedPeriodValue4 VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType4 VARCHAR(20) DEFAULT NULL; 

DECLARE includedExclude5 VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll5 VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet5 VARCHAR(1000) DEFAULT NULL; 
DECLARE includedOperator5 VARCHAR(50) DEFAULT NULL; 
DECLARE includedEntryValue5 VARCHAR(20) DEFAULT NULL; 
DECLARE includedDateFrom5 VARCHAR(30) DEFAULT NULL; 
DECLARE includedDateTo5 VARCHAR(30) DEFAULT NULL; 
DECLARE includedPeriodOperator5 VARCHAR(50) DEFAULT NULL;
DECLARE includedPeriodValue5 VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType5 VARCHAR(20) DEFAULT NULL; 

DECLARE includedExclude5a VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll5a VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet5a VARCHAR(1000) DEFAULT NULL; 
DECLARE includedOperator5a VARCHAR(50) DEFAULT NULL; 
DECLARE includedEntryValue5a VARCHAR(20) DEFAULT NULL; 
DECLARE includedDateFrom5a VARCHAR(30) DEFAULT NULL; 
DECLARE includedDateTo5a VARCHAR(30) DEFAULT NULL; 
DECLARE includedPeriodOperator5a VARCHAR(50) DEFAULT NULL;
DECLARE includedPeriodValue5a VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType5a VARCHAR(20) DEFAULT NULL; 

DECLARE includeExclude1String VARCHAR(1000) DEFAULT NULL; 
DECLARE includeExclude1aString VARCHAR(1000) DEFAULT NULL; 
DECLARE includeExclude1bString VARCHAR(1000) DEFAULT NULL; 
DECLARE includeExclude1cString VARCHAR(1000) DEFAULT NULL; 
DECLARE includeExclude1dString VARCHAR(1000) DEFAULT NULL; 

DECLARE includeExclude2String VARCHAR(1000) DEFAULT NULL; 
DECLARE includeExclude2aString VARCHAR(1000) DEFAULT NULL; 
DECLARE includeExclude3String VARCHAR(1000) DEFAULT NULL; 
DECLARE includeExclude3aString VARCHAR(1000) DEFAULT NULL; 
DECLARE includeExclude4String VARCHAR(1000) DEFAULT NULL; 
DECLARE includeExclude5String VARCHAR(1000) DEFAULT NULL; 
DECLARE includeExclude5aString VARCHAR(1000) DEFAULT NULL;

DECLARE sourceSchema VARCHAR(255) DEFAULT NULL;

DECLARE org_tmp VARCHAR(64) DEFAULT NULL;
DECLARE store_tmp VARCHAR(64) DEFAULT NULL;
DECLARE valueset_tmp VARCHAR(64) DEFAULT NULL;
DECLARE concept_tmp VARCHAR(64) DEFAULT NULL;
DECLARE all_valueset_tmp VARCHAR(64) DEFAULT NULL;
DECLARE all_concept_tmp VARCHAR(64) DEFAULT NULL;
DECLARE cohort_tmp VARCHAR(64) DEFAULT NULL;
DECLARE observation_tmp VARCHAR(64) DEFAULT NULL;

DECLARE incValueSet1_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incConcept1_tmp VARCHAR(64) DEFAULT NULL;
DECLARE observation1_tmp VARCHAR(64) DEFAULT NULL;

DECLARE incValueSet1a_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incConcept1a_tmp VARCHAR(64) DEFAULT NULL;
DECLARE observation1a_tmp VARCHAR(64) DEFAULT NULL;

DECLARE incValueSet1b_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incConcept1b_tmp VARCHAR(64) DEFAULT NULL;
DECLARE observation1b_tmp VARCHAR(64) DEFAULT NULL;

DECLARE incValueSet1c_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incConcept1c_tmp VARCHAR(64) DEFAULT NULL;
DECLARE observation1c_tmp VARCHAR(64) DEFAULT NULL;

DECLARE incValueSet1d_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incConcept1d_tmp VARCHAR(64) DEFAULT NULL;
DECLARE observation1d_tmp VARCHAR(64) DEFAULT NULL;

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

DECLARE incValueSet3a_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incConcept3a_tmp VARCHAR(64) DEFAULT NULL;
DECLARE observation3a_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incTestedValueset3a_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incTestedConcept3a_tmp VARCHAR(64) DEFAULT NULL;

DECLARE incValueSet4_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incConcept4_tmp VARCHAR(64) DEFAULT NULL;
DECLARE observation4_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incFollowedByValueSet4_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incFollowedByConcept4_tmp VARCHAR(64) DEFAULT NULL;

DECLARE incValueSet5_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incConcept5_tmp VARCHAR(64) DEFAULT NULL;
DECLARE observation5_tmp VARCHAR(64) DEFAULT NULL;

DECLARE incValueSet5a_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incConcept5a_tmp VARCHAR(64) DEFAULT NULL;
DECLARE observation5a_tmp VARCHAR(64) DEFAULT NULL;

DECLARE encounterValueSet_tmp VARCHAR(64) DEFAULT NULL;
DECLARE medicationValueSet_tmp VARCHAR(64) DEFAULT NULL;
DECLARE clinicalEventValueSet_tmp VARCHAR(64) DEFAULT NULL;
DECLARE clinicalTypes_tmp VARCHAR(64) DEFAULT NULL; 

DECLARE encounterConcept_tmp VARCHAR(64) DEFAULT NULL;
DECLARE medicationConcept_tmp VARCHAR(64) DEFAULT NULL;
DECLARE clinicalEventConcept_tmp VARCHAR(64) DEFAULT NULL;
DECLARE clinicalTypesConcept_tmp VARCHAR(64) DEFAULT NULL; 

DECLARE patient_cohort_tmp VARCHAR(64) DEFAULT NULL;

DECLARE tempTables VARCHAR(5000);

-- set variables -- 
SET sourceSchema = 'subscriber_pi_rv';

SET providerOrganisation = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.providerOrganisation'),'[',''),']',''),'"','');
SET includedOrganisation = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedOrganisation'),'[',''),']',''),'"','');
SET registrationStatus = JSON_UNQUOTE(JSON_EXTRACT(query,'$.registrationStatus'));

SET registrationExclude = JSON_UNQUOTE(JSON_EXTRACT(query,'$.registrationExclude')); 
SET registrationDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.registrationDateFrom'));   
SET registrationDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.registrationDateTo')); 
SET registrationPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.registrationPeriodValue'));
SET registrationPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.registrationPeriodType')); 

SET ageFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.ageFrom'));
SET ageTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.ageTo'));  
SET gender = LOWER(JSON_UNQUOTE(JSON_EXTRACT(query,'$.gender'))); 
SET postcode = JSON_UNQUOTE(JSON_EXTRACT(query,'$.postcode'));

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

SET schedule = JSON_UNQUOTE(JSON_EXTRACT(query,'$.schedule')); 
SET delivery = JSON_UNQUOTE(JSON_EXTRACT(query,'$.delivery')); 

SET includedExclude1 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedExclude1')); 
SET includedAnyAll1 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1')); 
SET includedValueSet1 = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1'),'[',''),']',''),'"','');
SET includedDateFrom1 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1'));  
SET includedDateTo1 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1'));  
SET includedPeriodOperator1 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator1'));
SET includedPeriodValue1 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1')); 
SET includedPeriodType1 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1'));

SET includedExclude1a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedExclude1a')); 
SET includedAnyAll1a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1a'));  
SET includedValueSet1a = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1a'),'[',''),']',''),'"','');
SET includedDateFrom1a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1a')); 
SET includedDateTo1a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1a')); 
SET includedPeriodOperator1a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator1a'));
SET includedPeriodValue1a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1a')); 
SET includedPeriodType1a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1a'));

SET includedExclude1b = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedExclude1b'));  
SET includedAnyAll1b = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1b')); 
SET includedValueSet1b = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1b'),'[',''),']',''),'"','');
SET includedDateFrom1b = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1b')); 
SET includedDateTo1b = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1b'));  
SET includedPeriodOperator1b = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator1b'));
SET includedPeriodValue1b = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1b'));
SET includedPeriodType1b = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1b'));

SET includedExclude1c = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedExclude1c'));  
SET includedAnyAll1c = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1c')); 
SET includedValueSet1c = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1c'),'[',''),']',''),'"','');
SET includedDateFrom1c = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1c')); 
SET includedDateTo1c = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1c'));  
SET includedPeriodOperator1c = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator1c'));
SET includedPeriodValue1c = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1c'));
SET includedPeriodType1c = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1c'));

SET includedExclude1d = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedExclude1d'));  
SET includedAnyAll1d = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1d')); 
SET includedValueSet1d = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1d'),'[',''),']',''),'"','');
SET includedDateFrom1d = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1d')); 
SET includedDateTo1d = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1d'));  
SET includedPeriodOperator1d = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator1d'));
SET includedPeriodValue1d = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1d'));
SET includedPeriodType1d = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1d'));

SET includedExclude2 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedExclude2'));
SET includedAnyAll2 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll2'));
SET includedValueSet2 = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet2'),'[',''),']',''),'"','');  
SET includedEarliestLatest2 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedEarliestLatest2')); 
SET includedOperator2 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedOperator2')); 
SET includedEntryValue2 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedEntryValue2')); 
SET includedDateFrom2 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom2'));  
SET includedDateTo2 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo2'));  
SET includedPeriodOperator2 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator2'));
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
SET includedPeriodOperator2a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator2a'));
SET includedPeriodValue2a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue2a'));
SET includedPeriodType2a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType2a'));

SET includedExclude3 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedExclude3')); 
SET includedAnyAll3 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll3'));
SET includedValueSet3 = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet3'),'[',''),']',''),'"','');
SET includedEarliestLatest3 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedEarliestLatest3'));
SET includedAnyAllTested3 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAllTested3'));
SET includedTestedValueSet3 = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedTestedValueSet3'),'[',''),']',''),'"','');
SET includedDateFrom3 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom3')); 
SET includedDateTo3 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo3')); 
SET includedPeriodOperator3 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator3'));
SET includedPeriodValue3 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue3')); 
SET includedPeriodType3 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType3')); 

SET includedExclude3a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedExclude3a')); 
SET includedAnyAll3a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll3a'));
SET includedValueSet3a = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet3a'),'[',''),']',''),'"','');
SET includedEarliestLatest3a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedEarliestLatest3a'));
SET includedAnyAllTested3a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAllTested3a'));
SET includedTestedValueSet3a = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedTestedValueSet3a'),'[',''),']',''),'"','');
SET includedDateFrom3a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom3a')); 
SET includedDateTo3a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo3a')); 
SET includedPeriodOperator3a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator3a'));
SET includedPeriodValue3a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue3a')); 
SET includedPeriodType3a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType3a')); 

SET includedExclude4 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedExclude4')); 
SET includedAnyAll4 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll4'));
SET includedValueSet4 = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet4'),'[',''),']',''),'"','');
SET includedAreNot4 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAreNot4'));
SET includedAnyAllFollowedBy4 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAllFollowedBy4'));
SET includedFollowedByValueSet4 = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedFollowedByValueSet4'),'[',''),']',''),'"','');
SET includedDateFrom4 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom4')); 
SET includedDateTo4 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo4')); 
SET includedPeriodOperator4 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator4'));
SET includedPeriodValue4 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue4')); 
SET includedPeriodType4 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType4')); 

SET includedExclude5 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedExclude5')); 
SET includedAnyAll5 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll5'));
SET includedValueSet5 = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet5'),'[',''),']',''),'"','');
SET includedOperator5 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedOperator5'));
SET includedEntryValue5 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedEntryValue5')); 
SET includedDateFrom5 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom5')); 
SET includedDateTo5 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo5')); 
SET includedPeriodOperator5 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator5'));
SET includedPeriodValue5 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue5')); 
SET includedPeriodType5 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType5')); 

SET includedExclude5a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedExclude5a')); 
SET includedAnyAll5a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll5a'));
SET includedValueSet5a = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet5a'),'[',''),']',''),'"','');
SET includedOperator5a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedOperator5a'));
SET includedEntryValue5a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedEntryValue5a')); 
SET includedDateFrom5a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom5a')); 
SET includedDateTo5a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo5a')); 
SET includedPeriodOperator5a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator5a'));
SET includedPeriodValue5a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue5a')); 
SET includedPeriodType5a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType5a')); 

SET org_tmp  = CONCAT('org_tmp_',query_id);
SET store_tmp  = CONCAT('store_tmp_',query_id);
SET valueset_tmp  = CONCAT('valueset_tmp_',query_id);
SET concept_tmp  = CONCAT('concept_tmp_',query_id);
SET all_valueset_tmp  = CONCAT('all_valueset_tmp_',query_id);
SET all_concept_tmp  = CONCAT('all_concept_tmp_',query_id);
SET cohort_tmp  = CONCAT('cohort_tmp_',query_id);
SET observation_tmp  = CONCAT('observation_tmp_',query_id);
-- 1
SET incValueSet1_tmp  = CONCAT('incValueSet1_tmp_',query_id);
SET incConcept1_tmp  = CONCAT('incConcept1_tmp_',query_id);
SET observation1_tmp  = CONCAT('observation1_tmp_',query_id);
-- 1a
SET incValueSet1a_tmp  = CONCAT('incValueSet1a_tmp_',query_id);
SET incConcept1a_tmp  = CONCAT('incConcept1a_tmp_',query_id);
SET observation1a_tmp  = CONCAT('observation1a_tmp_',query_id);
-- 1b
SET incValueSet1b_tmp  = CONCAT('incValueSet1b_tmp_',query_id);
SET incConcept1b_tmp  = CONCAT('incConcept1b_tmp_',query_id);
SET observation1b_tmp  = CONCAT('observation1b_tmp_',query_id);
-- 1c
SET incValueSet1c_tmp  = CONCAT('incValueSet1c_tmp_',query_id);
SET incConcept1c_tmp  = CONCAT('incConcept1c_tmp_',query_id);
SET observation1c_tmp  = CONCAT('observation1c_tmp_',query_id);
-- 1d
SET incValueSet1d_tmp  = CONCAT('incValueSet1d_tmp_',query_id);
SET incConcept1d_tmp  = CONCAT('incConcept1d_tmp_',query_id);
SET observation1d_tmp  = CONCAT('observation1d_tmp_',query_id);
-- 2
SET incValueSet2_tmp  = CONCAT('incValueSet2_tmp_',query_id);
SET incConcept2_tmp  = CONCAT('incConcept2_tmp_',query_id);
SET observation2_tmp  = CONCAT('observation2_tmp_',query_id);
-- 2a
SET incValueSet2a_tmp  = CONCAT('incValueSet2a_tmp_',query_id);
SET incConcept2a_tmp  = CONCAT('incConcept2a_tmp_',query_id);
SET observation2a_tmp  = CONCAT('observation2a_tmp_',query_id);
-- 3
SET incValueSet3_tmp  = CONCAT('incValueSet3_tmp_',query_id);
SET incConcept3_tmp  = CONCAT('incConcept3_tmp_',query_id);
SET observation3_tmp  = CONCAT('observation3_tmp_',query_id);
SET incTestedValueset3_tmp  = CONCAT('incTestedValueset3_tmp_',query_id);
SET incTestedConcept3_tmp  = CONCAT('incTestedConcept3_tmp_',query_id);
-- 3a
SET incValueSet3a_tmp  = CONCAT('incValueSet3a_tmp_',query_id);
SET incConcept3a_tmp  = CONCAT('incConcept3a_tmp_',query_id);
SET observation3a_tmp  = CONCAT('observation3a_tmp_',query_id);
SET incTestedValueset3a_tmp  = CONCAT('incTestedValueset3a_tmp_',query_id);
SET incTestedConcept3a_tmp  = CONCAT('incTestedConcept3a_tmp_',query_id);
-- 4
SET incValueSet4_tmp  = CONCAT('incValueSet4_tmp_',query_id);
SET incConcept4_tmp  = CONCAT('incConcept4_tmp_',query_id);
SET observation4_tmp  = CONCAT('observation4_tmp_',query_id);
SET incFollowedByValueSet4_tmp  = CONCAT('incFollowedByValueSet4_tmp_',query_id);
SET incFollowedByConcept4_tmp  = CONCAT('incFollowedByConcept4_tmp_',query_id);
-- 5
SET incValueSet5_tmp  = CONCAT('incValueSet5_tmp_',query_id);
SET incConcept5_tmp  = CONCAT('incConcept5_tmp_',query_id);
SET observation5_tmp  = CONCAT('observation5_tmp_',query_id);
-- 5a
SET incValueSet5a_tmp  = CONCAT('incValueSet5a_tmp_',query_id);
SET incConcept5a_tmp  = CONCAT('incConcept5a_tmp_',query_id);
SET observation5a_tmp  = CONCAT('observation5a_tmp_',query_id);

-- events
SET encounterValueSet_tmp  = CONCAT('encounterValueSet_tmp_',query_id);
SET medicationValueSet_tmp  = CONCAT('medicationValueSet_tmp_',query_id);
SET clinicalEventValueSet_tmp  = CONCAT('clinicalEventValueSet_tmp_',query_id);
SET clinicalTypes_tmp  = CONCAT('clinicalTypes_tmp_',query_id);

SET encounterConcept_tmp  = CONCAT('encounterConcept_tmp_',query_id);
SET medicationConcept_tmp  = CONCAT('medicationConcept_tmp_',query_id);
SET clinicalEventConcept_tmp  = CONCAT('clinicalEventConcept_tmp_',query_id);
SET clinicalTypesConcept_tmp  = CONCAT('clinicalTypesConcept_tmp_',query_id);

SET patient_cohort_tmp  = CONCAT('patient_cohort_tmp_',query_id);

-- cohort definition --
CALL buildCohortDefinition(query_id,providerOrganisation, includedOrganisation, registrationStatus, ageFrom, ageTo, gender, postcode, 
registrationExclude, registrationDateFrom, registrationDateTo, registrationPeriodValue, registrationPeriodType, org_tmp, valueset_tmp, 
concept_tmp, all_valueset_tmp, all_concept_tmp, cohort_tmp, observation_tmp, sourceSchema, store_tmp);

-- advance criteria --
-- rule 1 --
CALL getIncludeExcludeString(query_id,includedExclude1,includedAnyAll1,includedValueSet1, includedDateFrom1, includedDateTo1, includedPeriodOperator1,
includedPeriodValue1,includedPeriodType1,incValueSet1_tmp, incConcept1_tmp, observation_tmp, 
1, NULL, NULL, NULL, observation1_tmp, NULL, NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, sourceSchema , store_tmp, @includeExclude1String);
SET includeExclude1String = @includeExclude1String;
-- rule 1a --
CALL getIncludeExcludeString(query_id,includedExclude1a,includedAnyAll1a,includedValueSet1a, includedDateFrom1a, includedDateTo1a, includedPeriodOperator1a,
includedPeriodValue1a,includedPeriodType1a,incValueSet1a_tmp, incConcept1a_tmp, observation_tmp, 
1, NULL, NULL, NULL, observation1a_tmp, NULL, NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, sourceSchema , store_tmp, @includeExclude1aString);
SET includeExclude1aString = @includeExclude1aString;
-- rule 1b --
CALL getIncludeExcludeString(query_id,includedExclude1b,includedAnyAll1b,includedValueSet1b, includedDateFrom1b, includedDateTo1b, includedPeriodOperator1b,
includedPeriodValue1b,includedPeriodType1b, incValueSet1b_tmp, incConcept1b_tmp, observation_tmp, 
1, NULL, NULL, NULL, observation1b_tmp, NULL, NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, sourceSchema , store_tmp, @includeExclude1bString);
SET includeExclude1bString = @includeExclude1bString;
-- rule 1c --
CALL getIncludeExcludeString(query_id,includedExclude1c,includedAnyAll1c,includedValueSet1c, includedDateFrom1c, includedDateTo1c, includedPeriodOperator1c,
includedPeriodValue1c,includedPeriodType1c, incValueSet1c_tmp, incConcept1c_tmp, observation_tmp, 
1, NULL, NULL, NULL, observation1c_tmp, NULL, NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, sourceSchema , store_tmp, @includeExclude1cString);
SET includeExclude1cString = @includeExclude1cString;
-- rule 1d --
CALL getIncludeExcludeString(query_id,includedExclude1d,includedAnyAll1d,includedValueSet1d, includedDateFrom1d, includedDateTo1d, includedPeriodOperator1d,
includedPeriodValue1d,includedPeriodType1d, incValueSet1d_tmp, incConcept1d_tmp, observation_tmp, 
1, NULL, NULL, NULL, observation1d_tmp, NULL, NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, sourceSchema , store_tmp, @includeExclude1dString);
SET includeExclude1dString = @includeExclude1dString;
-- rule 2 -- 
CALL getIncludeExcludeString(query_id,includedExclude2,includedAnyAll2,includedValueSet2, includedDateFrom2, includedDateTo2, includedPeriodOperator2,
includedPeriodValue2,includedPeriodType2, incValueSet2_tmp, incConcept2_tmp, observation_tmp, 
2, includedEarliestLatest2, includedOperator2, includedEntryValue2, observation2_tmp,  NULL, NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, sourceSchema , store_tmp, @includeExclude2String);
SET includeExclude2String = @includeExclude2String;
-- rule 2a --
CALL getIncludeExcludeString(query_id,includedExclude2a,includedAnyAll2a,includedValueSet2a, includedDateFrom2a, includedDateTo2a, includedPeriodOperator2a,
includedPeriodValue2a,includedPeriodType2a, incValueSet2a_tmp, incConcept2a_tmp, observation_tmp, 
2, includedEarliestLatest2a, includedOperator2a, includedEntryValue2a, observation2a_tmp, NULL, NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, sourceSchema , store_tmp, @includeExclude2aString);
SET includeExclude2aString = @includeExclude2aString;
-- rule 3 --
CALL getIncludeExcludeString(query_id,includedExclude3,includedAnyAll3,includedValueSet3, includedDateFrom3, includedDateTo3, includedPeriodOperator3,
includedPeriodValue3, includedPeriodType3, incValueSet3_tmp, incConcept3_tmp, observation_tmp, 
3, includedEarliestLatest3, NULL, NULL, observation3_tmp, includedAnyAllTested3, includedTestedValueSet3, incTestedValueset3_tmp, incTestedConcept3_tmp, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, sourceSchema , store_tmp, @includeExclude3String);
SET includeExclude3String = @includeExclude3String;
-- rule 3a --
CALL getIncludeExcludeString(query_id,includedExclude3a,includedAnyAll3a,includedValueSet3a, includedDateFrom3a, includedDateTo3a, includedPeriodOperator3a,
includedPeriodValue3a, includedPeriodType3a, incValueSet3a_tmp, incConcept3a_tmp, observation_tmp, 
3, includedEarliestLatest3a, NULL, NULL, observation3a_tmp, includedAnyAllTested3a, includedTestedValueSet3a, incTestedValueset3a_tmp, incTestedConcept3a_tmp, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, sourceSchema , store_tmp, @includeExclude3aString);
SET includeExclude3aString = @includeExclude3aString;
-- rule 4 --
CALL getIncludeExcludeString(query_id,includedExclude4,includedAnyAll4,includedValueSet4, includedDateFrom4, includedDateTo4, includedPeriodOperator4,
includedPeriodValue4, includedPeriodType4, incValueSet4_tmp, incConcept4_tmp, observation_tmp, 
4, NULL, NULL, NULL, observation4_tmp, NULL, NULL, NULL, NULL, includedAreNot4, 
includedAnyAllFollowedBy4, includedFollowedByValueSet4, incFollowedByValueSet4_tmp, incFollowedByConcept4_tmp, NULL, NULL, sourceSchema , store_tmp, @includeExclude4String);
SET includeExclude4String = @includeExclude4String;
-- rule 5 --
CALL getIncludeExcludeString(query_id,includedExclude5,includedAnyAll5,includedValueSet5, includedDateFrom5, includedDateTo5, includedPeriodOperator5,
includedPeriodValue5, includedPeriodType5, incValueSet5_tmp, incConcept5_tmp, observation_tmp, 
5, NULL, NULL, NULL, observation5_tmp, NULL, NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, includedOperator5, includedEntryValue5, sourceSchema , store_tmp, @includeExclude5String);
SET includeExclude5String = @includeExclude5String;
-- rule 5a --
CALL getIncludeExcludeString(query_id,includedExclude5a,includedAnyAll5a,includedValueSet5a, includedDateFrom5a, includedDateTo5a, includedPeriodOperator5a,
includedPeriodValue5a, includedPeriodType5a, incValueSet5a_tmp, incConcept5a_tmp, observation_tmp, 
5, NULL, NULL, NULL, observation5a_tmp, NULL, NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, includedOperator5a, includedEntryValue5a, sourceSchema , store_tmp, @includeExclude5aString);
SET includeExclude5aString = @includeExclude5aString;

-- final patient cohort
CALL buildFinalPatientCohort(query_id, patient_cohort_tmp, observation_tmp, includeExclude1String, includeExclude1aString, includeExclude1bString, 
includeExclude1cString, includeExclude1dString,includeExclude2String, includeExclude2aString, includeExclude3String, includeExclude3aString, includeExclude4String, 
includeExclude5String, includeExclude5aString, sourceSchema);

-- result datasets
CALL buildResultDatasets(query_id, patient_cohort_tmp, demographics, encounters, medication, currentMedication, clinicalEvents, activeProblems, 
dateFromEncounters, dateToEncounters, dateFromMedication, dateToMedication, dateFromClinicalEvents, dateToClinicalEvents, selectedClinicalTypes, 
selectedEncounterValueSet, selectedMedicationValueSet, selectedClinicalEventValueSet, clinicalTypes_tmp,  clinicalTypesConcept_tmp, encounterValueSet_tmp, 
encounterConcept_tmp, medicationValueSet_tmp, medicationConcept_tmp, clinicalEventValueSet_tmp, clinicalEventConcept_tmp, sourceSchema, store_tmp, @eventTypes);
SET eventTypes = @eventTypes;

-- dataset outputs
CALL buildDatasetOutputTables(selectedDemographicFields, selectedEncounterFields, selectedMedicationFields, selectedClinicalEventFields, 
eventTypes, store_tmp, sourceSchema, query_id, patient_cohort_tmp);

-- update queue for next run date
CALL updateQueue(query_id, schedule);

-- clean up --
-- remove temp tables
 SET tempTables = CONCAT(org_tmp,',',store_tmp,',',cohort_tmp ,',',observation_tmp,',',valueset_tmp,',',concept_tmp ,',',all_valueset_tmp,',',all_concept_tmp,',',
 incValueSet1_tmp,',',incConcept1_tmp,',',observation1_tmp,',',incValueSet1a_tmp,',',incConcept1a_tmp,',',observation1a_tmp,',',
 incValueSet1b_tmp,',',incConcept1b_tmp,',',observation1b_tmp,',',incValueSet1c_tmp,',',incConcept1c_tmp,',',observation1c_tmp,',',
 incValueSet1d_tmp,',',incConcept1d_tmp,',',observation1d_tmp,',',incValueSet2_tmp,',',incConcept2_tmp,',',observation2_tmp,',',
 incValueSet2a_tmp,',',incConcept2a_tmp,',',observation2a_tmp,',',incValueSet3_tmp,',',incConcept3_tmp,',',incTestedValueSet3_tmp,',',
 incTestedConcept3_tmp,',',observation3_tmp,',',incValueSet3a_tmp,',',incConcept3a_tmp,',',incTestedValueSet3a_tmp,',',
 incTestedConcept3a_tmp,',',observation3a_tmp,',',incValueSet4_tmp,',',incConcept4_tmp,',',incFollowedByValueSet4_tmp,',',incFollowedByConcept4_tmp ,',',observation4_tmp,',',
 incValueSet5_tmp,',',incConcept5_tmp,',',observation5_tmp,',',incValueSet5a_tmp,',',incConcept5a_tmp,',',observation5a_tmp,',',encounterValueSet_tmp,',',encounterConcept_tmp,',',
 medicationValueSet_tmp,',',medicationConcept_tmp,',',clinicalTypes_tmp,',',clinicalTypesConcept_tmp,',',clinicalEventValueSet_tmp,',',clinicalEventConcept_tmp,',',
 patient_cohort_tmp);

CALL dropTempTables(tempTables);

END//
DELIMITER ;