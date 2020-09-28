USE dashboards;

DROP PROCEDURE IF EXISTS reportGenerator;

DELIMITER //
CREATE PROCEDURE reportGenerator(query JSON)

BEGIN

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

DECLARE eventOutput VARCHAR(1000) DEFAULT NULL;
DECLARE aggregateOutput VARCHAR(50) DEFAULT NULL;
DECLARE schedule VARCHAR(50) DEFAULT NULL;
DECLARE delivery VARCHAR(50) DEFAULT NULL;

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


/*
includedExclude4
includedAnyAll4
includedValueSet4
includedAreNot4
includedAnyAllFollowedBy4
includedFollowedByValueSet4
includedDateFrom4
includedDateTo4
includedPeriodValue4
includedPeriodType4

includedExclude5
includedAnyAll5
includedValueSet5
includedOperator5
includedEntryValue5
includedDateFrom5
includedDateTo5
includedPeriodValue5
includedPeriodType5

*/

DECLARE includeExclude1String VARCHAR(1000) DEFAULT NULL; 
DECLARE includeExclude1aString VARCHAR(1000) DEFAULT NULL; 
DECLARE includeExclude1bString VARCHAR(1000) DEFAULT NULL; 

DECLARE includeExclude2String VARCHAR(1000) DEFAULT NULL; 
DECLARE includeExclude2aString VARCHAR(1000) DEFAULT NULL; 

DECLARE includeExclude3String VARCHAR(1000) DEFAULT NULL; 

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
SET eventType = REPLACE(REPLACE(JSON_EXTRACT(query,'$.eventType'),'[',''),']','');
SET active = JSON_EXTRACT(query,'$.active');

SET datasetValue = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.datasetValue'),'[',''),']',''),'"','');
SET dateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.dateFrom')); 
SET dateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.dateTo')); 

SET eventOutput = JSON_EXTRACT(query,'$.eventOutput');
SET aggregateOutput = JSON_EXTRACT(query,'$.aggregateOutput');
SET schedule = JSON_EXTRACT(query,'$.schedule');
SET delivery = JSON_EXTRACT(query,'$.delivery');

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

-- build cohort definition --
CALL buildCohortDefinition(providerOrganisation,includedOrganisation,registrationStatus,
ageFrom,ageTo,gender,postcode,valueDateFrom,valueDateTo,cohortValue,'org_tmp','valueset_tmp','concept_tmp','cohort_tmp','observation_tmp');
-- build advance query --
-- 1 to 1b -- 
CALL getIncludeExcludeString(includedExclude1,includedAnyAll1,
includedValueSet1, includedDateFrom1, includedDateTo1, includedPeriodValue1,includedPeriodType1,
'incValueSet1_tmp', 'incConcept1_tmp', 'observation_tmp', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, @includeExclude1String);
SET includeExclude1String = @includeExclude1String;

CALL getIncludeExcludeString(includedExclude1a,includedAnyAll1a,
includedValueSet1a, includedDateFrom1a, includedDateTo1a, includedPeriodValue1a,includedPeriodType1a,
'incValueSet1a_tmp', 'incConcept1a_tmp', 'observation_tmp', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, @includeExclude1aString);
SET includeExclude1aString = @includeExclude1aString;

CALL getIncludeExcludeString(includedExclude1b,includedAnyAll1b,
includedValueSet1b, includedDateFrom1b, includedDateTo1b, includedPeriodValue1b,includedPeriodType1b, 
'incValueSet1b_tmp', 'incConcept1b_tmp', 'observation_tmp', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, @includeExclude1bString);
SET includeExclude1bString = @includeExclude1bString;

-- 2 to 2a -- 
CALL getIncludeExcludeString(includedExclude2,includedAnyAll2,
includedValueSet2, includedDateFrom2, includedDateTo2, includedPeriodValue2,includedPeriodType2, 
'incValueSet2_tmp', 'incConcept2_tmp', 'observation_tmp', 2, includedEarliestLatest2, includedOperator2, includedEntryValue2, 
'observation2_tmp',  NULL, NULL, NULL, NULL, @includeExclude2String);
SET includeExclude2String = @includeExclude2String;

CALL getIncludeExcludeString(includedExclude2a,includedAnyAll2a,
includedValueSet2a, includedDateFrom2a, includedDateTo2a, includedPeriodValue2a,includedPeriodType2a, 
'incValueSet2a_tmp', 'incConcept2a_tmp', 'observation_tmp', 2, includedEarliestLatest2a, includedOperator2a, includedEntryValue2a, 
'observation2a_tmp', NULL, NULL, NULL, NULL, @includeExclude2aString);
SET includeExclude2aString = @includeExclude2aString;

-- 3 --
CALL getIncludeExcludeString(includedExclude3,includedAnyAll3,
includedValueSet3, NULL, NULL, NULL, NULL, 'incValueSet3_tmp', 'incConcept3_tmp', 'observation_tmp', 3, includedEarliestLatest3, NULL, NULL, 
'observation3_tmp', includedAnyAllTested3, includedTestedValueSet3, 'incTestedValueset3_tmp', 'incTestedConcept3_tmp', @includeExclude3String);
SET includeExclude3String = @includeExclude3String;



/*
  -- testing
SELECT includeExclude1String;
SELECT includeExclude1aString;
SELECT includeExclude1bString;

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
select eventOutput ;
select aggregateOutput ;
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









*/

/* usuage: 

call reportGenerator('{"providerOrganisation":["NHS CITY AND HACKNEY CCG","NHS Newham CCG","NHS TOWER HAMLETS CCG","NHS WALTHAM FOREST CCG"],
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
 "eventOutput":["Patient ID","Patient NHS number","Pseudo NHS number","Effective date","Concept name","Owning organisation","Numeric value","Post code","Age","Gender","Registered organisation","Death status"],
 "aggregateOutput":"",
 "schedule":"Weekly",
 "delivery":"NHS email"}');  */


-- clean up
--  DROP TABLE IF EXISTS org_tmp;
--  DROP TABLE IF EXISTS valueset_tmp;
--  DROP TABLE IF EXISTS concept_tmp;
--  DROP TABLE IF EXISTS observation_tmp;

END//
DELIMITER ;