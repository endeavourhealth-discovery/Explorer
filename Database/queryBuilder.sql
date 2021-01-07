USE dashboards;


DROP PROCEDURE IF EXISTS queryBuilder;

DELIMITER //

CREATE PROCEDURE queryBuilder(
  IN p_query_id INT,
  IN query JSON,
  IN p_queryNumber VARCHAR(20),
  IN p_cohortTab VARCHAR(64),
  IN p_observationCohort_tmp VARCHAR(64),
  IN p_store_tmp VARCHAR(64),
  IN p_schema VARCHAR(255)
)

BEGIN

-- query variables
DECLARE withWithout1 VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll1 VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet1 VARCHAR(1000) DEFAULT NULL; 
DECLARE includedDateFrom1 VARCHAR(30) DEFAULT NULL; 
DECLARE includedDateTo1 VARCHAR(30) DEFAULT NULL; 
DECLARE includedPeriodOperator1 VARCHAR(50) DEFAULT NULL;
DECLARE includedPeriodValue1 VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType1 VARCHAR(20) DEFAULT NULL; 

DECLARE withWithout1a VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll1a VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet1a VARCHAR(1000) DEFAULT NULL; 
DECLARE includedDateFrom1a VARCHAR(30) DEFAULT NULL; 
DECLARE includedDateTo1a VARCHAR(30) DEFAULT NULL; 
DECLARE includedPeriodOperator1a VARCHAR(50) DEFAULT NULL;
DECLARE includedPeriodValue1a VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType1a VARCHAR(20) DEFAULT NULL; 

DECLARE withWithout1b VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll1b VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet1b VARCHAR(1000) DEFAULT NULL; 
DECLARE includedDateFrom1b VARCHAR(30) DEFAULT NULL; 
DECLARE includedDateTo1b VARCHAR(30) DEFAULT NULL; 
DECLARE includedPeriodOperator1b VARCHAR(50) DEFAULT NULL;
DECLARE includedPeriodValue1b VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType1b VARCHAR(20) DEFAULT NULL; 

DECLARE withWithout1c VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll1c VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet1c VARCHAR(1000) DEFAULT NULL; 
DECLARE includedDateFrom1c VARCHAR(30) DEFAULT NULL; 
DECLARE includedDateTo1c VARCHAR(30) DEFAULT NULL; 
DECLARE includedPeriodOperator1c VARCHAR(50) DEFAULT NULL;
DECLARE includedPeriodValue1c VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType1c VARCHAR(20) DEFAULT NULL; 

DECLARE withWithout1d VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll1d VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet1d VARCHAR(1000) DEFAULT NULL; 
DECLARE includedDateFrom1d VARCHAR(30) DEFAULT NULL; 
DECLARE includedDateTo1d VARCHAR(30) DEFAULT NULL; 
DECLARE includedPeriodOperator1d VARCHAR(50) DEFAULT NULL;
DECLARE includedPeriodValue1d VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType1d VARCHAR(20) DEFAULT NULL; 




DECLARE withWithout1e VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll1e VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet1e VARCHAR(1000) DEFAULT NULL; 
DECLARE includedDateFrom1e VARCHAR(30) DEFAULT NULL; 
DECLARE includedDateTo1e VARCHAR(30) DEFAULT NULL; 
DECLARE includedPeriodOperator1e VARCHAR(50) DEFAULT NULL;
DECLARE includedPeriodValue1e VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType1e VARCHAR(20) DEFAULT NULL; 

DECLARE withWithout1f VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll1f VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet1f VARCHAR(1000) DEFAULT NULL; 
DECLARE includedDateFrom1f VARCHAR(30) DEFAULT NULL; 
DECLARE includedDateTo1f VARCHAR(30) DEFAULT NULL; 
DECLARE includedPeriodOperator1f VARCHAR(50) DEFAULT NULL;
DECLARE includedPeriodValue1f VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType1f VARCHAR(20) DEFAULT NULL; 

DECLARE withWithout1g VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll1g VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet1g VARCHAR(1000) DEFAULT NULL; 
DECLARE includedDateFrom1g VARCHAR(30) DEFAULT NULL; 
DECLARE includedDateTo1g VARCHAR(30) DEFAULT NULL; 
DECLARE includedPeriodOperator1g VARCHAR(50) DEFAULT NULL;
DECLARE includedPeriodValue1g VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType1g VARCHAR(20) DEFAULT NULL; 

DECLARE withWithout1h VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll1h VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet1h VARCHAR(1000) DEFAULT NULL; 
DECLARE includedDateFrom1h VARCHAR(30) DEFAULT NULL; 
DECLARE includedDateTo1h VARCHAR(30) DEFAULT NULL; 
DECLARE includedPeriodOperator1h VARCHAR(50) DEFAULT NULL;
DECLARE includedPeriodValue1h VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType1h VARCHAR(20) DEFAULT NULL; 

DECLARE withWithout1i VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll1i VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet1i VARCHAR(1000) DEFAULT NULL; 
DECLARE includedDateFrom1i VARCHAR(30) DEFAULT NULL; 
DECLARE includedDateTo1i VARCHAR(30) DEFAULT NULL; 
DECLARE includedPeriodOperator1i VARCHAR(50) DEFAULT NULL;
DECLARE includedPeriodValue1i VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType1i VARCHAR(20) DEFAULT NULL; 

DECLARE withWithout1j VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll1j VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet1j VARCHAR(1000) DEFAULT NULL; 
DECLARE includedDateFrom1j VARCHAR(30) DEFAULT NULL; 
DECLARE includedDateTo1j VARCHAR(30) DEFAULT NULL; 
DECLARE includedPeriodOperator1j VARCHAR(50) DEFAULT NULL;
DECLARE includedPeriodValue1j VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType1j VARCHAR(20) DEFAULT NULL; 

DECLARE withWithout1k VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll1k VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet1k VARCHAR(1000) DEFAULT NULL; 
DECLARE includedDateFrom1k VARCHAR(30) DEFAULT NULL; 
DECLARE includedDateTo1k VARCHAR(30) DEFAULT NULL; 
DECLARE includedPeriodOperator1k VARCHAR(50) DEFAULT NULL;
DECLARE includedPeriodValue1k VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType1k VARCHAR(20) DEFAULT NULL; 

DECLARE withWithout1l VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll1l VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet1l VARCHAR(1000) DEFAULT NULL; 
DECLARE includedDateFrom1l VARCHAR(30) DEFAULT NULL; 
DECLARE includedDateTo1l VARCHAR(30) DEFAULT NULL; 
DECLARE includedPeriodOperator1l VARCHAR(50) DEFAULT NULL;
DECLARE includedPeriodValue1l VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType1l VARCHAR(20) DEFAULT NULL; 

DECLARE withWithout2 VARCHAR(10) DEFAULT NULL; 
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

DECLARE withWithout2a VARCHAR(10) DEFAULT NULL; 
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

DECLARE withWithout3 VARCHAR(10) DEFAULT NULL; 
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

DECLARE withWithout3a VARCHAR(10) DEFAULT NULL; 
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

DECLARE withWithout4 VARCHAR(10) DEFAULT NULL; 
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

DECLARE withWithout5 VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll5 VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet5 VARCHAR(1000) DEFAULT NULL; 
DECLARE includedOperator5 VARCHAR(50) DEFAULT NULL; 
DECLARE includedEntryValue5 VARCHAR(20) DEFAULT NULL; 
DECLARE includedDateFrom5 VARCHAR(30) DEFAULT NULL; 
DECLARE includedDateTo5 VARCHAR(30) DEFAULT NULL; 
DECLARE includedPeriodOperator5 VARCHAR(50) DEFAULT NULL;
DECLARE includedPeriodValue5 VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType5 VARCHAR(20) DEFAULT NULL; 

DECLARE withWithout5a VARCHAR(10) DEFAULT NULL; 
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

DECLARE incValueSet1_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incConcept1_tmp VARCHAR(64) DEFAULT NULL;

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

DECLARE incValueSet1e_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incConcept1e_tmp VARCHAR(64) DEFAULT NULL;
DECLARE observation1e_tmp VARCHAR(64) DEFAULT NULL;

DECLARE incValueSet1f_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incConcept1f_tmp VARCHAR(64) DEFAULT NULL;
DECLARE observation1f_tmp VARCHAR(64) DEFAULT NULL;

DECLARE incValueSet1g_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incConcept1g_tmp VARCHAR(64) DEFAULT NULL;
DECLARE observation1g_tmp VARCHAR(64) DEFAULT NULL;

DECLARE incValueSet1h_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incConcept1h_tmp VARCHAR(64) DEFAULT NULL;
DECLARE observation1h_tmp VARCHAR(64) DEFAULT NULL;

DECLARE incValueSet1i_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incConcept1i_tmp VARCHAR(64) DEFAULT NULL;
DECLARE observation1i_tmp VARCHAR(64) DEFAULT NULL;

DECLARE incValueSet1j_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incConcept1j_tmp VARCHAR(64) DEFAULT NULL;
DECLARE observation1j_tmp VARCHAR(64) DEFAULT NULL;

DECLARE incValueSet1k_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incConcept1k_tmp VARCHAR(64) DEFAULT NULL;
DECLARE observation1k_tmp VARCHAR(64) DEFAULT NULL;

DECLARE incValueSet1l_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incConcept1l_tmp VARCHAR(64) DEFAULT NULL;
DECLARE observation1l_tmp VARCHAR(64) DEFAULT NULL;

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

-- registration period
DECLARE registrationExclude VARCHAR(10) DEFAULT NULL; 
DECLARE registrationDateFrom VARCHAR(20) DEFAULT NULL;   
DECLARE registrationDateTo VARCHAR(20) DEFAULT NULL;   
DECLARE registrationPeriodValue VARCHAR(10) DEFAULT NULL; 
DECLARE registrationPeriodType VARCHAR(20) DEFAULT NULL; 



DECLARE tempTables VARCHAR(5000);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(p_query_id, 'queryBuilder', @code, @msg, now());
        RESIGNAL; -- rethrow the error
    END;

    IF p_queryNumber = '1' THEN 

        SET withWithout1 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout1')); 
        SET includedAnyAll1 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1')); 
        SET includedValueSet1 = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1'),'[',''),']',''),'"','');
        SET includedDateFrom1 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1'));  
        SET includedDateTo1 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1'));  
        SET includedPeriodOperator1 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator1'));
        SET includedPeriodValue1 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1')); 
        SET includedPeriodType1 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1'));
        -- 1
        SET incValueSet1_tmp = CONCAT('incValueSet1_tmp_',p_query_id);
        SET incConcept1_tmp  = CONCAT('incConcept1_tmp_',p_query_id);

    -- Q1 --
        CALL buildQuery(p_query_id, withWithout1, includedAnyAll1, includedValueSet1, includedDateFrom1, includedDateTo1, includedPeriodOperator1,
        includedPeriodValue1, includedPeriodType1, incValueSet1_tmp, incConcept1_tmp, p_observationCohort_tmp, 
        1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, p_schema , p_store_tmp, p_cohortTab, p_queryNumber);

    -- remove tmp tables
    SET tempTables = CONCAT(incValueSet1_tmp,',',incConcept1_tmp);
    CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '1A' THEN 

        SET withWithout1a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout1a')); 
        SET includedAnyAll1a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1a'));  
        SET includedValueSet1a = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1a'),'[',''),']',''),'"','');
        SET includedDateFrom1a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1a')); 
        SET includedDateTo1a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1a')); 
        SET includedPeriodOperator1a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator1a'));
        SET includedPeriodValue1a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1a')); 
        SET includedPeriodType1a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1a'));
        -- 1a
        SET incValueSet1a_tmp = CONCAT('incValueSet1a_tmp_',p_query_id);
        SET incConcept1a_tmp = CONCAT('incConcept1a_tmp_',p_query_id);
        SET observation1a_tmp = CONCAT('observation1a_tmp_',p_query_id);

    -- Q1a --
        CALL buildQuery(p_query_id, withWithout1a, includedAnyAll1a, includedValueSet1a, includedDateFrom1a, includedDateTo1a, includedPeriodOperator1a,
        includedPeriodValue1a, includedPeriodType1a,incValueSet1a_tmp, incConcept1a_tmp, p_observationCohort_tmp, 
        1, NULL, NULL, NULL, observation1a_tmp, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, p_schema , p_store_tmp, p_cohortTab, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet1a_tmp,',',incConcept1a_tmp,',', observation1a_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '1B' THEN 

        SET withWithout1b = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout1b'));  
        SET includedAnyAll1b = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1b')); 
        SET includedValueSet1b = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1b'),'[',''),']',''),'"','');
        SET includedDateFrom1b = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1b')); 
        SET includedDateTo1b = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1b'));  
        SET includedPeriodOperator1b = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator1b'));
        SET includedPeriodValue1b = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1b'));
        SET includedPeriodType1b = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1b'));
        -- 1b
        SET incValueSet1b_tmp = CONCAT('incValueSet1b_tmp_',p_query_id);
        SET incConcept1b_tmp = CONCAT('incConcept1b_tmp_',p_query_id);
        SET observation1b_tmp = CONCAT('observation1b_tmp_',p_query_id);

    -- Q1b --
        CALL buildQuery(p_query_id, withWithout1b, includedAnyAll1b, includedValueSet1b, includedDateFrom1b, includedDateTo1b, includedPeriodOperator1b,
        includedPeriodValue1b,includedPeriodType1b, incValueSet1b_tmp, incConcept1b_tmp, p_observationCohort_tmp, 
        1, NULL, NULL, NULL, observation1b_tmp, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, p_schema, p_store_tmp, p_cohortTab, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet1b_tmp,',',incConcept1b_tmp,',', observation1b_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '1C' THEN 

        SET withWithout1c = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout1c'));  
        SET includedAnyAll1c = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1c')); 
        SET includedValueSet1c = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1c'),'[',''),']',''),'"','');
        SET includedDateFrom1c = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1c')); 
        SET includedDateTo1c = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1c'));  
        SET includedPeriodOperator1c = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator1c'));
        SET includedPeriodValue1c = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1c'));
        SET includedPeriodType1c = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1c'));
        -- 1c
        SET incValueSet1c_tmp = CONCAT('incValueSet1c_tmp_',p_query_id);
        SET incConcept1c_tmp = CONCAT('incConcept1c_tmp_',p_query_id);
        SET observation1c_tmp = CONCAT('observation1c_tmp_',p_query_id);

    -- Q1c --
        CALL buildQuery(p_query_id, withWithout1c, includedAnyAll1c, includedValueSet1c, includedDateFrom1c, includedDateTo1c, includedPeriodOperator1c,
        includedPeriodValue1c, includedPeriodType1c, incValueSet1c_tmp, incConcept1c_tmp, p_observationCohort_tmp, 
        1, NULL, NULL, NULL, observation1c_tmp, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, p_schema, p_store_tmp, p_cohortTab, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet1c_tmp,',',incConcept1c_tmp,',', observation1c_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '1D' THEN

        SET withWithout1d = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout1d'));  
        SET includedAnyAll1d = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1d')); 
        SET includedValueSet1d = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1d'),'[',''),']',''),'"','');
        SET includedDateFrom1d = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1d')); 
        SET includedDateTo1d = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1d'));  
        SET includedPeriodOperator1d = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator1d'));
        SET includedPeriodValue1d = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1d'));
        SET includedPeriodType1d = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1d')); 
        -- 1d
        SET incValueSet1d_tmp = CONCAT('incValueSet1d_tmp_',p_query_id);
        SET incConcept1d_tmp = CONCAT('incConcept1d_tmp_',p_query_id);
        SET observation1d_tmp = CONCAT('observation1d_tmp_',p_query_id);

    -- Q1d --
        CALL buildQuery(p_query_id, withWithout1d, includedAnyAll1d, includedValueSet1d, includedDateFrom1d, includedDateTo1d, includedPeriodOperator1d,
        includedPeriodValue1d,includedPeriodType1d, incValueSet1d_tmp, incConcept1d_tmp, p_observationCohort_tmp, 
        1, NULL, NULL, NULL, observation1d_tmp, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, p_schema, p_store_tmp, p_cohortTab, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet1d_tmp,',',incConcept1d_tmp,',', observation1d_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '1E' THEN

        SET withWithout1e = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout1e'));  
        SET includedAnyAll1e = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1e')); 
        SET includedValueSet1e = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1e'),'[',''),']',''),'"','');
        SET includedDateFrom1e = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1e')); 
        SET includedDateTo1e = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1e'));  
        SET includedPeriodOperator1e = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator1e'));
        SET includedPeriodValue1e = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1e'));
        SET includedPeriodType1e = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1e')); 
        -- 1e
        SET incValueSet1e_tmp = CONCAT('incValueSet1e_tmp_',p_query_id);
        SET incConcept1e_tmp = CONCAT('incConcept1e_tmp_',p_query_id);
        SET observation1e_tmp = CONCAT('observation1e_tmp_',p_query_id);

    -- Q1e --
        CALL buildQuery(p_query_id, withWithout1e, includedAnyAll1e, includedValueSet1e, includedDateFrom1e, includedDateTo1e, includedPeriodOperator1e,
        includedPeriodValue1e,includedPeriodType1e, incValueSet1e_tmp, incConcept1e_tmp, p_observationCohort_tmp, 
        1, NULL, NULL, NULL, observation1e_tmp, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, p_schema, p_store_tmp, p_cohortTab, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet1e_tmp,',',incConcept1e_tmp,',', observation1e_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '1F' THEN

        SET withWithout1f = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout1f'));  
        SET includedAnyAll1f = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1f')); 
        SET includedValueSet1f = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1f'),'[',''),']',''),'"','');
        SET includedDateFrom1f = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1f')); 
        SET includedDateTo1f = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1f'));  
        SET includedPeriodOperator1f = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator1f'));
        SET includedPeriodValue1f = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1f'));
        SET includedPeriodType1f = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1f')); 
        -- 1f
        SET incValueSet1f_tmp = CONCAT('incValueSet1f_tmp_',p_query_id);
        SET incConcept1f_tmp = CONCAT('incConcept1f_tmp_',p_query_id);
        SET observation1f_tmp = CONCAT('observation1f_tmp_',p_query_id);

    -- Q1f --
        CALL buildQuery(p_query_id, withWithout1f, includedAnyAll1f, includedValueSet1f, includedDateFrom1f, includedDateTo1f, includedPeriodOperator1f,
        includedPeriodValue1f,includedPeriodType1f, incValueSet1f_tmp, incConcept1f_tmp, p_observationCohort_tmp, 
        1, NULL, NULL, NULL, observation1f_tmp, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, p_schema, p_store_tmp, p_cohortTab, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet1f_tmp,',',incConcept1f_tmp,',', observation1f_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '1G' THEN

        SET withWithout1g = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout1g'));  
        SET includedAnyAll1g = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1g')); 
        SET includedValueSet1g = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1g'),'[',''),']',''),'"','');
        SET includedDateFrom1g = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1g')); 
        SET includedDateTo1g = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1g'));  
        SET includedPeriodOperator1g = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator1g'));
        SET includedPeriodValue1g = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1g'));
        SET includedPeriodType1g = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1g')); 
        -- 1g
        SET incValueSet1g_tmp = CONCAT('incValueSet1g_tmp_',p_query_id);
        SET incConcept1g_tmp = CONCAT('incConcept1g_tmp_',p_query_id);
        SET observation1g_tmp = CONCAT('observation1g_tmp_',p_query_id);

    -- Q1g --
        CALL buildQuery(p_query_id, withWithout1g, includedAnyAll1g, includedValueSet1g, includedDateFrom1g, includedDateTo1g, includedPeriodOperator1g,
        includedPeriodValue1g,includedPeriodType1g, incValueSet1g_tmp, incConcept1g_tmp, p_observationCohort_tmp, 
        1, NULL, NULL, NULL, observation1g_tmp, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, p_schema, p_store_tmp, p_cohortTab, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet1g_tmp,',',incConcept1g_tmp,',', observation1g_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '1H' THEN

        SET withWithout1h = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout1h'));  
        SET includedAnyAll1h = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1h')); 
        SET includedValueSet1h = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1h'),'[',''),']',''),'"','');
        SET includedDateFrom1h = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1h')); 
        SET includedDateTo1h = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1h'));  
        SET includedPeriodOperator1h = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator1h'));
        SET includedPeriodValue1h = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1h'));
        SET includedPeriodType1h = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1h')); 
        -- 1h
        SET incValueSet1h_tmp = CONCAT('incValueSet1h_tmp_',p_query_id);
        SET incConcept1h_tmp = CONCAT('incConcept1h_tmp_',p_query_id);
        SET observation1h_tmp = CONCAT('observation1h_tmp_',p_query_id);

    -- Q1h --
        CALL buildQuery(p_query_id, withWithout1h, includedAnyAll1h, includedValueSet1h, includedDateFrom1h, includedDateTo1h, includedPeriodOperator1h,
        includedPeriodValue1h,includedPeriodType1h, incValueSet1h_tmp, incConcept1h_tmp, p_observationCohort_tmp, 
        1, NULL, NULL, NULL, observation1h_tmp, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, p_schema, p_store_tmp, p_cohortTab, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet1h_tmp,',',incConcept1h_tmp,',', observation1h_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '1I' THEN

        SET withWithout1i = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout1i'));  
        SET includedAnyAll1i = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1i')); 
        SET includedValueSet1i = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1i'),'[',''),']',''),'"','');
        SET includedDateFrom1i = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1i')); 
        SET includedDateTo1i = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1i'));  
        SET includedPeriodOperator1i = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator1i'));
        SET includedPeriodValue1i = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1i'));
        SET includedPeriodType1i = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1i')); 
        -- 1i
        SET incValueSet1i_tmp = CONCAT('incValueSet1i_tmp_',p_query_id);
        SET incConcept1i_tmp = CONCAT('incConcept1i_tmp_',p_query_id);
        SET observation1i_tmp = CONCAT('observation1i_tmp_',p_query_id);

    -- Q1i --
        CALL buildQuery(p_query_id, withWithout1i, includedAnyAll1i, includedValueSet1i, includedDateFrom1i, includedDateTo1i, includedPeriodOperator1i,
        includedPeriodValue1i,includedPeriodType1i, incValueSet1i_tmp, incConcept1i_tmp, p_observationCohort_tmp, 
        1, NULL, NULL, NULL, observation1i_tmp, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, p_schema, p_store_tmp, p_cohortTab, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet1i_tmp,',',incConcept1i_tmp,',', observation1i_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '1J' THEN

        SET withWithout1j = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout1j'));  
        SET includedAnyAll1j = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1j')); 
        SET includedValueSet1j = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1j'),'[',''),']',''),'"','');
        SET includedDateFrom1j = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1j')); 
        SET includedDateTo1j = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1j'));  
        SET includedPeriodOperator1j = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator1j'));
        SET includedPeriodValue1j = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1j'));
        SET includedPeriodType1j = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1j')); 
        -- 1j
        SET incValueSet1j_tmp = CONCAT('incValueSet1j_tmp_',p_query_id);
        SET incConcept1j_tmp = CONCAT('incConcept1j_tmp_',p_query_id);
        SET observation1j_tmp = CONCAT('observation1j_tmp_',p_query_id);

    -- Q1j --
        CALL buildQuery(p_query_id, withWithout1j, includedAnyAll1j, includedValueSet1j, includedDateFrom1j, includedDateTo1j, includedPeriodOperator1j,
        includedPeriodValue1j,includedPeriodType1j, incValueSet1j_tmp, incConcept1j_tmp, p_observationCohort_tmp, 
        1, NULL, NULL, NULL, observation1j_tmp, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, p_schema, p_store_tmp, p_cohortTab, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet1j_tmp,',',incConcept1j_tmp,',', observation1j_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '1K' THEN

        SET withWithout1k = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout1k'));  
        SET includedAnyAll1k = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1k')); 
        SET includedValueSet1k = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1k'),'[',''),']',''),'"','');
        SET includedDateFrom1k = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1k')); 
        SET includedDateTo1k = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1k'));  
        SET includedPeriodOperator1k = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator1k'));
        SET includedPeriodValue1k = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1k'));
        SET includedPeriodType1k = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1k')); 
        -- 1k
        SET incValueSet1k_tmp = CONCAT('incValueSet1k_tmp_',p_query_id);
        SET incConcept1k_tmp = CONCAT('incConcept1k_tmp_',p_query_id);
        SET observation1k_tmp = CONCAT('observation1k_tmp_',p_query_id);

    -- Q1k --
        CALL buildQuery(p_query_id, withWithout1k, includedAnyAll1k, includedValueSet1k, includedDateFrom1k, includedDateTo1k, includedPeriodOperator1k,
        includedPeriodValue1k,includedPeriodType1k, incValueSet1k_tmp, incConcept1k_tmp, p_observationCohort_tmp, 
        1, NULL, NULL, NULL, observation1k_tmp, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, p_schema, p_store_tmp, p_cohortTab, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet1k_tmp,',',incConcept1k_tmp,',', observation1k_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '1L' THEN

        SET withWithout1l = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout1l'));  
        SET includedAnyAll1l = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1l')); 
        SET includedValueSet1l = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1l'),'[',''),']',''),'"','');
        SET includedDateFrom1l = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1l')); 
        SET includedDateTo1l = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1l'));  
        SET includedPeriodOperator1l = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator1l'));
        SET includedPeriodValue1l = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1l'));
        SET includedPeriodType1l = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1l')); 
        -- 1l
        SET incValueSet1l_tmp = CONCAT('incValueSet1l_tmp_',p_query_id);
        SET incConcept1l_tmp = CONCAT('incConcept1l_tmp_',p_query_id);
        SET observation1l_tmp = CONCAT('observation1l_tmp_',p_query_id);

    -- Q1l --
        CALL buildQuery(p_query_id, withWithout1l, includedAnyAll1l, includedValueSet1l, includedDateFrom1l, includedDateTo1l, includedPeriodOperator1l,
        includedPeriodValue1l,includedPeriodType1l, incValueSet1l_tmp, incConcept1l_tmp, p_observationCohort_tmp, 
        1, NULL, NULL, NULL, observation1l_tmp, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, p_schema, p_store_tmp, p_cohortTab, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet1l_tmp,',',incConcept1l_tmp,',', observation1l_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '2' THEN 

        SET withWithout2 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout2'));
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
        -- 2
        SET incValueSet2_tmp = CONCAT('incValueSet2_tmp_',p_query_id);
        SET incConcept2_tmp = CONCAT('incConcept2_tmp_',p_query_id);
        SET observation2_tmp = CONCAT('observation2_tmp_',p_query_id);

    -- Q2 -- 
        CALL buildQuery(p_query_id, withWithout2, includedAnyAll2, includedValueSet2, includedDateFrom2, includedDateTo2, includedPeriodOperator2,
        includedPeriodValue2,includedPeriodType2, incValueSet2_tmp, incConcept2_tmp, p_observationCohort_tmp, 
        2, includedEarliestLatest2, includedOperator2, includedEntryValue2, observation2_tmp,  NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, p_schema, p_store_tmp, p_cohortTab, p_queryNumber);

            -- remove tmp tables
        SET tempTables = CONCAT(incValueSet2_tmp,',',incConcept2_tmp,',', observation2_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '2A' THEN 

        SET withWithout2a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout2a')); 
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
        -- 2a
        SET incValueSet2a_tmp = CONCAT('incValueSet2a_tmp_',p_query_id);
        SET incConcept2a_tmp = CONCAT('incConcept2a_tmp_',p_query_id);
        SET observation2a_tmp = CONCAT('observation2a_tmp_',p_query_id);

    -- Q2a --
        CALL buildQuery(p_query_id, withWithout2a, includedAnyAll2a, includedValueSet2a, includedDateFrom2a, includedDateTo2a, includedPeriodOperator2a,
        includedPeriodValue2a,includedPeriodType2a, incValueSet2a_tmp, incConcept2a_tmp, p_observationCohort_tmp, 
        2, includedEarliestLatest2a, includedOperator2a, includedEntryValue2a, observation2a_tmp, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, p_schema, p_store_tmp, p_cohortTab, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet2a_tmp,',',incConcept2a_tmp,',', observation2a_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '3' THEN 

        SET withWithout3 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout3')); 
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
        -- 3
        SET incValueSet3_tmp = CONCAT('incValueSet3_tmp_',p_query_id);
        SET incConcept3_tmp = CONCAT('incConcept3_tmp_',p_query_id);
        SET observation3_tmp = CONCAT('observation3_tmp_',p_query_id);
        SET incTestedValueset3_tmp = CONCAT('incTestedValueset3_tmp_',p_query_id);
        SET incTestedConcept3_tmp = CONCAT('incTestedConcept3_tmp_',p_query_id);

    -- Q3 --
        CALL buildQuery(p_query_id, withWithout3, includedAnyAll3, includedValueSet3, includedDateFrom3, includedDateTo3, includedPeriodOperator3,
        includedPeriodValue3, includedPeriodType3, incValueSet3_tmp, incConcept3_tmp, p_observationCohort_tmp, 
        3, includedEarliestLatest3, NULL, NULL, observation3_tmp, includedAnyAllTested3, includedTestedValueSet3, incTestedValueset3_tmp, incTestedConcept3_tmp, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, p_schema, p_store_tmp, p_cohortTab, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet3_tmp,',',incConcept3_tmp,',', observation3_tmp,',',incTestedValueset3_tmp,',',incTestedConcept3_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '3A' THEN 

        SET withWithout3a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout3a')); 
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
        -- 3a
        SET incValueSet3a_tmp = CONCAT('incValueSet3a_tmp_',p_query_id);
        SET incConcept3a_tmp = CONCAT('incConcept3a_tmp_',p_query_id);
        SET observation3a_tmp = CONCAT('observation3a_tmp_',p_query_id);
        SET incTestedValueset3a_tmp = CONCAT('incTestedValueset3a_tmp_',p_query_id);
        SET incTestedConcept3a_tmp = CONCAT('incTestedConcept3a_tmp_',p_query_id);

    -- Q3a --
        CALL buildQuery(p_query_id, withWithout3a, includedAnyAll3a, includedValueSet3a, includedDateFrom3a, includedDateTo3a, includedPeriodOperator3a,
        includedPeriodValue3a, includedPeriodType3a, incValueSet3a_tmp, incConcept3a_tmp, p_observationCohort_tmp, 
        3, includedEarliestLatest3a, NULL, NULL, observation3a_tmp, includedAnyAllTested3a, includedTestedValueSet3a, incTestedValueset3a_tmp, incTestedConcept3a_tmp, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, p_schema , p_store_tmp, p_cohortTab, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet3a_tmp,',',incConcept3a_tmp,',', observation3a_tmp,',',incTestedValueset3a_tmp,',',incTestedConcept3a_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '4' THEN 

        SET withWithout4 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout4')); 
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
        -- 4
        SET incValueSet4_tmp = CONCAT('incValueSet4_tmp_',p_query_id);
        SET incConcept4_tmp = CONCAT('incConcept4_tmp_',p_query_id);
        SET observation4_tmp = CONCAT('observation4_tmp_',p_query_id);
        SET incFollowedByValueSet4_tmp = CONCAT('incFollowedByValueSet4_tmp_',p_query_id);
        SET incFollowedByConcept4_tmp = CONCAT('incFollowedByConcept4_tmp_',p_query_id);

    -- Q4 --
        CALL buildQuery(p_query_id, withWithout4, includedAnyAll4, includedValueSet4, includedDateFrom4, includedDateTo4, includedPeriodOperator4,
        includedPeriodValue4, includedPeriodType4, incValueSet4_tmp, incConcept4_tmp, p_observationCohort_tmp, 
        4, NULL, NULL, NULL, observation4_tmp, NULL, NULL, NULL, NULL, includedAreNot4, 
        includedAnyAllFollowedBy4, includedFollowedByValueSet4, incFollowedByValueSet4_tmp, incFollowedByConcept4_tmp, NULL, NULL, NULL, NULL, NULL, NULL, NULL, p_schema , p_store_tmp, p_cohortTab, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet4_tmp,',',incConcept4_tmp,',', observation4_tmp,',',incFollowedByValueSet4_tmp,',',incFollowedByConcept4_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '5' THEN 

        SET withWithout5 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout5')); 
        SET includedAnyAll5 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll5'));
        SET includedValueSet5 = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet5'),'[',''),']',''),'"','');
        SET includedOperator5 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedOperator5'));
        SET includedEntryValue5 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedEntryValue5')); 
        SET includedDateFrom5 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom5')); 
        SET includedDateTo5 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo5')); 
        SET includedPeriodOperator5 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator5'));
        SET includedPeriodValue5 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue5')); 
        SET includedPeriodType5 = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType5')); 
        -- 5
        SET incValueSet5_tmp = CONCAT('incValueSet5_tmp_',p_query_id);
        SET incConcept5_tmp = CONCAT('incConcept5_tmp_',p_query_id);
        SET observation5_tmp = CONCAT('observation5_tmp_',p_query_id);

    -- Q5 --
        CALL buildQuery(p_query_id, withWithout5, includedAnyAll5, includedValueSet5, includedDateFrom5, includedDateTo5, includedPeriodOperator5,
        includedPeriodValue5, includedPeriodType5, incValueSet5_tmp, incConcept5_tmp, p_observationCohort_tmp, 
        5, NULL, NULL, NULL, observation5_tmp, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, includedOperator5, includedEntryValue5, NULL, NULL, NULL, NULL, NULL, p_schema , p_store_tmp, p_cohortTab, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet5_tmp,',',incConcept5_tmp,',', observation5_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '5A' THEN 

        SET withWithout5a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout5a')); 
        SET includedAnyAll5a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll5a'));
        SET includedValueSet5a = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet5a'),'[',''),']',''),'"','');
        SET includedOperator5a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedOperator5a'));
        SET includedEntryValue5a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedEntryValue5a')); 
        SET includedDateFrom5a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom5a')); 
        SET includedDateTo5a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo5a')); 
        SET includedPeriodOperator5a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator5a'));
        SET includedPeriodValue5a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue5a')); 
        SET includedPeriodType5a = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType5a'));
        -- 5a
        SET incValueSet5a_tmp = CONCAT('incValueSet5a_tmp_',p_query_id);
        SET incConcept5a_tmp = CONCAT('incConcept5a_tmp_',p_query_id);
        SET observation5a_tmp = CONCAT('observation5a_tmp_',p_query_id);

    -- Q5a --
        CALL buildQuery(p_query_id, withWithout5a, includedAnyAll5a, includedValueSet5a, includedDateFrom5a, includedDateTo5a, includedPeriodOperator5a,
        includedPeriodValue5a, includedPeriodType5a, incValueSet5a_tmp, incConcept5a_tmp, p_observationCohort_tmp, 
        5, NULL, NULL, NULL, observation5a_tmp, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, includedOperator5a, includedEntryValue5a, NULL, NULL, NULL, NULL, NULL, p_schema , p_store_tmp, p_cohortTab, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet5a_tmp,',',incConcept5a_tmp,',', observation5a_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '0' THEN -- registration date range

        SET registrationExclude = JSON_UNQUOTE(JSON_EXTRACT(query,'$.registrationExclude')); 
        SET registrationDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.registrationDateFrom'));   
        SET registrationDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.registrationDateTo')); 
        SET registrationPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.registrationPeriodValue'));
        SET registrationPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.registrationPeriodType'));
    -- Q0 --
        CALL buildQuery(p_query_id, NULL, NULL, NULL, NULL, NULL, NULL,NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, registrationExclude, registrationDateFrom, registrationDateTo, registrationPeriodValue, registrationPeriodType, p_schema, 
        NULL, p_cohortTab, p_queryNumber);

    END IF;


END //
DELIMITER ;