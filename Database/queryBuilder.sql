USE dashboards;


DROP PROCEDURE IF EXISTS queryBuilder;

DELIMITER //

CREATE PROCEDURE queryBuilder(
  IN p_query_id INT,
  IN query JSON,
  IN p_queryNumber VARCHAR(20),
  IN p_queryCohort VARCHAR(64),
  IN p_observationCohort_tmp VARCHAR(64),
  IN p_store_tmp VARCHAR(64),
  IN p_schema VARCHAR(255)
)

BEGIN

-- query variables

DECLARE withWithout VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAll VARCHAR(10) DEFAULT NULL; 
DECLARE includedValueSet VARCHAR(1000) DEFAULT NULL; 
DECLARE includedDateFrom VARCHAR(30) DEFAULT NULL; 
DECLARE includedDateTo VARCHAR(30) DEFAULT NULL; 
DECLARE includedPeriodOperator VARCHAR(50) DEFAULT NULL;
DECLARE includedPeriodValue VARCHAR(10) DEFAULT NULL; 
DECLARE includedPeriodType VARCHAR(20) DEFAULT NULL; 
DECLARE includedEarliestLatest VARCHAR(20) DEFAULT NULL; 
DECLARE includedOperator VARCHAR(50) DEFAULT NULL; 
DECLARE includedEntryValue VARCHAR(20) DEFAULT NULL; 
DECLARE includedAnyAllTested VARCHAR(10) DEFAULT NULL; 
DECLARE includedTestedValueSet VARCHAR(1000) DEFAULT NULL;
DECLARE includedDob VARCHAR(20) DEFAULT NULL; 
DECLARE includedDiagnosisAnyAll VARCHAR(10) DEFAULT NULL; 
DECLARE includedDiagnosisValueSet VARCHAR(1000) DEFAULT NULL;
DECLARE includedDiagnosisAgeFrom VARCHAR(30) DEFAULT NULL; 
DECLARE includedDiagnosisAgeTo VARCHAR(30) DEFAULT NULL; 
DECLARE includedAreNot VARCHAR(10) DEFAULT NULL; 
DECLARE includedAnyAllFollowedBy VARCHAR(10) DEFAULT NULL; 
DECLARE includedFollowedByValueSet VARCHAR(1000) DEFAULT NULL; 

DECLARE incValueSet_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incConcept_tmp VARCHAR(64) DEFAULT NULL;
DECLARE observation_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incTestedValueset_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incTestedConcept_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incFollowedByValueSet_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incFollowedByConcept_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incDiagnosisValueSet_tmp VARCHAR(64) DEFAULT NULL;
DECLARE incDiagnosisConcept_tmp VARCHAR(64) DEFAULT NULL;
DECLARE diagnosis_tmp VARCHAR(64) DEFAULT NULL; 

-- registration period
DECLARE registrationExclude VARCHAR(10) DEFAULT NULL; 
DECLARE registrationDateFrom VARCHAR(20) DEFAULT NULL;   
DECLARE registrationDateTo VARCHAR(20) DEFAULT NULL;   
DECLARE registrationPeriodValue VARCHAR(10) DEFAULT NULL; 
DECLARE registrationPeriodType VARCHAR(20) DEFAULT NULL; 

-- patient's age range
DECLARE ageFrom VARCHAR(20) DEFAULT NULL;   
DECLARE ageTo VARCHAR(20) DEFAULT NULL;  

DECLARE tempTables VARCHAR(5000);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      GET DIAGNOSTICS CONDITION 1
        @code = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        CALL log_errors(p_query_id, 'queryBuilder', @code, @msg, now());
        RESIGNAL; -- rethrow the error
    END;

    IF p_queryNumber = '1' THEN 

        SET withWithout = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout1')); 
        SET includedAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1')); 
        SET includedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1'),'[',''),']',''),'"','');
        SET includedDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1'));  
        SET includedDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1'));  
        SET includedPeriodOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator1'));
        SET includedPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1')); 
        SET includedPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1'));
        -- 1
        SET incValueSet_tmp = CONCAT('incvalueset1_tmp_',p_query_id);
        SET incConcept_tmp  = CONCAT('incconcept1_tmp_',p_query_id);

    -- Q1 --
        CALL buildQuery(p_query_id, withWithout, includedAnyAll, includedValueSet, includedDateFrom, includedDateTo, includedPeriodOperator,includedPeriodValue, includedPeriodType, incValueSet_tmp, 
        incConcept_tmp, p_observationCohort_tmp, '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, p_schema, p_store_tmp, p_queryCohort, p_queryNumber);

    -- remove tmp tables
    SET tempTables = CONCAT(incValueSet_tmp,',',incConcept_tmp);
    CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '1A' THEN 

        SET withWithout = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout1a')); 
        SET includedAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1a'));  
        SET includedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1a'),'[',''),']',''),'"','');
        SET includedDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1a')); 
        SET includedDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1a')); 
        SET includedPeriodOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator1a'));
        SET includedPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1a')); 
        SET includedPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1a'));
        -- 1a
        SET incValueSet_tmp = CONCAT('incvalueset1a_tmp_',p_query_id);
        SET incConcept_tmp = CONCAT('incconcept1a_tmp_',p_query_id);

    -- Q1a --
        CALL buildQuery(p_query_id, withWithout, includedAnyAll, includedValueSet, includedDateFrom, includedDateTo, includedPeriodOperator,includedPeriodValue, includedPeriodType, incValueSet_tmp, 
        incConcept_tmp, p_observationCohort_tmp, '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, p_schema, p_store_tmp, p_queryCohort, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet_tmp,',',incConcept_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '1B' THEN 

        SET withWithout = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout1b'));  
        SET includedAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1b')); 
        SET includedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1b'),'[',''),']',''),'"','');
        SET includedDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1b')); 
        SET includedDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1b'));  
        SET includedPeriodOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator1b'));
        SET includedPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1b'));
        SET includedPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1b'));
        -- 1b
        SET incValueSet_tmp = CONCAT('incvalueset1b_tmp_',p_query_id);
        SET incConcept_tmp = CONCAT('incconcept1b_tmp_',p_query_id);

    -- Q1b --
        CALL buildQuery(p_query_id, withWithout, includedAnyAll, includedValueSet, includedDateFrom, includedDateTo, includedPeriodOperator,includedPeriodValue, includedPeriodType, incValueSet_tmp, 
        incConcept_tmp, p_observationCohort_tmp, '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, p_schema, p_store_tmp, p_queryCohort, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet_tmp,',',incConcept_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '1C' THEN 

        SET withWithout = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout1c'));  
        SET includedAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1c')); 
        SET includedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1c'),'[',''),']',''),'"','');
        SET includedDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1c')); 
        SET includedDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1c'));  
        SET includedPeriodOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator1c'));
        SET includedPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1c'));
        SET includedPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1c'));
        -- 1c
        SET incValueSet_tmp = CONCAT('incvalueset1c_tmp_',p_query_id);
        SET incConcept_tmp = CONCAT('incconcept1c_tmp_',p_query_id);

    -- Q1c --
        CALL buildQuery(p_query_id, withWithout, includedAnyAll, includedValueSet, includedDateFrom, includedDateTo, includedPeriodOperator,includedPeriodValue, includedPeriodType, incValueSet_tmp, 
        incConcept_tmp, p_observationCohort_tmp, '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, p_schema, p_store_tmp, p_queryCohort, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet_tmp,',',incConcept_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '1D' THEN

        SET withWithout = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout1d'));  
        SET includedAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1d')); 
        SET includedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1d'),'[',''),']',''),'"','');
        SET includedDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1d')); 
        SET includedDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1d'));  
        SET includedPeriodOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator1d'));
        SET includedPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1d'));
        SET includedPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1d')); 
        -- 1d
        SET incValueSet_tmp = CONCAT('incvalueset1d_tmp_',p_query_id);
        SET incConcept_tmp = CONCAT('incconcept1d_tmp_',p_query_id);

    -- Q1d --
        CALL buildQuery(p_query_id, withWithout, includedAnyAll, includedValueSet, includedDateFrom, includedDateTo, includedPeriodOperator,includedPeriodValue, includedPeriodType, incValueSet_tmp, 
        incConcept_tmp, p_observationCohort_tmp, '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, p_schema, p_store_tmp, p_queryCohort, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet_tmp,',',incConcept_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '1E' THEN

        SET withWithout = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout1e'));  
        SET includedAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1e')); 
        SET includedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1e'),'[',''),']',''),'"','');
        SET includedDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1e')); 
        SET includedDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1e'));  
        SET includedPeriodOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator1e'));
        SET includedPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1e'));
        SET includedPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1e')); 
        -- 1e
        SET incValueSet_tmp = CONCAT('incvalueset1e_tmp_',p_query_id);
        SET incConcept_tmp = CONCAT('incconcept1e_tmp_',p_query_id);

    -- Q1e --
        CALL buildQuery(p_query_id, withWithout, includedAnyAll, includedValueSet, includedDateFrom, includedDateTo, includedPeriodOperator,includedPeriodValue, includedPeriodType, incValueSet_tmp, 
        incConcept_tmp, p_observationCohort_tmp, '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, p_schema, p_store_tmp, p_queryCohort, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet_tmp,',',incConcept_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '1F' THEN

        SET withWithout = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout1f'));  
        SET includedAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1f')); 
        SET includedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1f'),'[',''),']',''),'"','');
        SET includedDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1f')); 
        SET includedDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1f'));  
        SET includedPeriodOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator1f'));
        SET includedPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1f'));
        SET includedPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1f')); 
        -- 1f
        SET incValueSet_tmp = CONCAT('incvalueset1f_tmp_',p_query_id);
        SET incConcept_tmp = CONCAT('incconcept1f_tmp_',p_query_id);

    -- Q1f --
        CALL buildQuery(p_query_id, withWithout, includedAnyAll, includedValueSet, includedDateFrom, includedDateTo, includedPeriodOperator,includedPeriodValue, includedPeriodType, incValueSet_tmp, 
        incConcept_tmp, p_observationCohort_tmp, '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, p_schema, p_store_tmp, p_queryCohort, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet_tmp,',',incConcept_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '1G' THEN

        SET withWithout = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout1g'));  
        SET includedAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1g')); 
        SET includedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1g'),'[',''),']',''),'"','');
        SET includedDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1g')); 
        SET includedDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1g'));  
        SET includedPeriodOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator1g'));
        SET includedPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1g'));
        SET includedPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1g')); 
        -- 1g
        SET incValueSet_tmp = CONCAT('incvalueset1g_tmp_',p_query_id);
        SET incConcept_tmp = CONCAT('incconcept1g_tmp_',p_query_id);

    -- Q1g --
        CALL buildQuery(p_query_id, withWithout, includedAnyAll, includedValueSet, includedDateFrom, includedDateTo, includedPeriodOperator,includedPeriodValue, includedPeriodType, incValueSet_tmp, 
        incConcept_tmp, p_observationCohort_tmp, '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, p_schema, p_store_tmp, p_queryCohort, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet_tmp,',',incConcept_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '1H' THEN

        SET withWithout = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout1h'));  
        SET includedAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1h')); 
        SET includedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1h'),'[',''),']',''),'"','');
        SET includedDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1h')); 
        SET includedDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1h'));  
        SET includedPeriodOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator1h'));
        SET includedPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1h'));
        SET includedPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1h')); 
        -- 1h
        SET incValueSet_tmp = CONCAT('incvalueset1h_tmp_',p_query_id);
        SET incConcept_tmp = CONCAT('incconcept1h_tmp_',p_query_id);

    -- Q1h --
        CALL buildQuery(p_query_id, withWithout, includedAnyAll, includedValueSet, includedDateFrom, includedDateTo, includedPeriodOperator,includedPeriodValue, includedPeriodType, incValueSet_tmp, 
        incConcept_tmp, p_observationCohort_tmp, '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, p_schema, p_store_tmp, p_queryCohort, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet_tmp,',',incConcept_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '1I' THEN

        SET withWithout = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout1i'));  
        SET includedAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1i')); 
        SET includedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1i'),'[',''),']',''),'"','');
        SET includedDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1i')); 
        SET includedDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1i'));  
        SET includedPeriodOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator1i'));
        SET includedPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1i'));
        SET includedPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1i')); 
        -- 1i
        SET incValueSet_tmp = CONCAT('incvalueset1i_tmp_',p_query_id);
        SET incConcept_tmp = CONCAT('incconcept1i_tmp_',p_query_id);

    -- Q1i --
        CALL buildQuery(p_query_id, withWithout, includedAnyAll, includedValueSet, includedDateFrom, includedDateTo, includedPeriodOperator,includedPeriodValue, includedPeriodType, incValueSet_tmp, 
        incConcept_tmp, p_observationCohort_tmp, '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, p_schema, p_store_tmp, p_queryCohort, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet_tmp,',',incConcept_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '1J' THEN

        SET withWithout = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout1j'));  
        SET includedAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1j')); 
        SET includedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1j'),'[',''),']',''),'"','');
        SET includedDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1j')); 
        SET includedDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1j'));  
        SET includedPeriodOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator1j'));
        SET includedPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1j'));
        SET includedPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1j')); 
        -- 1j
        SET incValueSet_tmp = CONCAT('incvalueset1j_tmp_',p_query_id);
        SET incConcept_tmp = CONCAT('incconcept1j_tmp_',p_query_id);

    -- Q1j --
        CALL buildQuery(p_query_id, withWithout, includedAnyAll, includedValueSet, includedDateFrom, includedDateTo, includedPeriodOperator,includedPeriodValue, includedPeriodType, incValueSet_tmp, 
        incConcept_tmp, p_observationCohort_tmp, '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, p_schema, p_store_tmp, p_queryCohort, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet_tmp,',',incConcept_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '1K' THEN

        SET withWithout = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout1k'));  
        SET includedAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1k')); 
        SET includedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1k'),'[',''),']',''),'"','');
        SET includedDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1k')); 
        SET includedDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1k'));  
        SET includedPeriodOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator1k'));
        SET includedPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1k'));
        SET includedPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1k')); 
        -- 1k
        SET incValueSet_tmp = CONCAT('incvalueset1k_tmp_',p_query_id);
        SET incConcept_tmp = CONCAT('incconcept1k_tmp_',p_query_id);

    -- Q1k --
        CALL buildQuery(p_query_id, withWithout, includedAnyAll, includedValueSet, includedDateFrom, includedDateTo, includedPeriodOperator,includedPeriodValue, includedPeriodType, incValueSet_tmp, 
        incConcept_tmp, p_observationCohort_tmp, '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, p_schema, p_store_tmp, p_queryCohort, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet_tmp,',',incConcept_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '1L' THEN

        SET withWithout = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout1l'));  
        SET includedAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll1l')); 
        SET includedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet1l'),'[',''),']',''),'"','');
        SET includedDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom1l')); 
        SET includedDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo1l'));  
        SET includedPeriodOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator1l'));
        SET includedPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue1l'));
        SET includedPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType1l')); 
        -- 1l
        SET incValueSet_tmp = CONCAT('incvalueset1l_tmp_',p_query_id);
        SET incConcept_tmp = CONCAT('incconcept1l_tmp_',p_query_id);

    -- Q1l --
        CALL buildQuery(p_query_id, withWithout, includedAnyAll, includedValueSet, includedDateFrom, includedDateTo, includedPeriodOperator,includedPeriodValue, includedPeriodType, incValueSet_tmp, 
        incConcept_tmp, p_observationCohort_tmp, '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, p_schema, p_store_tmp, p_queryCohort, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet_tmp,',',incConcept_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '2' THEN 

        SET withWithout = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout2'));
        SET includedAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll2'));
        SET includedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet2'),'[',''),']',''),'"','');  
        SET includedEarliestLatest = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedEarliestLatest2')); 
        SET includedOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedOperator2')); 
        SET includedEntryValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedEntryValue2')); 
        SET includedDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom2'));  
        SET includedDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo2'));  
        SET includedPeriodOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator2'));
        SET includedPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue2')); 
        SET includedPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType2'));  
        -- 2
        SET incValueSet_tmp = CONCAT('incvalueset2_tmp_',p_query_id);
        SET incConcept_tmp = CONCAT('incconcept2_tmp_',p_query_id);
        SET observation_tmp = CONCAT('observation2_tmp_',p_query_id);

    -- Q2 -- 
        CALL buildQuery(p_query_id, withWithout, includedAnyAll, includedValueSet, includedDateFrom, includedDateTo, includedPeriodOperator, includedPeriodValue,includedPeriodType, incValueSet_tmp, 
        incConcept_tmp, p_observationCohort_tmp, '2', includedEarliestLatest, includedOperator, includedEntryValue, observation_tmp,  NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, p_schema, p_store_tmp, p_queryCohort, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet_tmp,',',incConcept_tmp,',', observation_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '2A' THEN 

        SET withWithout = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout2a')); 
        SET includedAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll2a'));
        SET includedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet2a'),'[',''),']',''),'"','');
        SET includedEarliestLatest = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedEarliestLatest2a'));
        SET includedOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedOperator2a'));
        SET includedEntryValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedEntryValue2a')); 
        SET includedDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom2a')); 
        SET includedDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo2a'));  
        SET includedPeriodOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator2a'));
        SET includedPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue2a'));
        SET includedPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType2a'));
        -- 2a
        SET incValueSet_tmp = CONCAT('incvalueset2a_tmp_',p_query_id);
        SET incConcept_tmp = CONCAT('incconcept2a_tmp_',p_query_id);
        SET observation_tmp = CONCAT('observation2a_tmp_',p_query_id);

    -- Q2a --
        CALL buildQuery(p_query_id, withWithout, includedAnyAll, includedValueSet, includedDateFrom, includedDateTo, includedPeriodOperator, includedPeriodValue,includedPeriodType, incValueSet_tmp, 
        incConcept_tmp, p_observationCohort_tmp, '2', includedEarliestLatest, includedOperator, includedEntryValue, observation_tmp,  NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, p_schema, p_store_tmp, p_queryCohort, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet_tmp,',',incConcept_tmp,',', observation_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '3' THEN 

        SET withWithout = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout3')); 
        SET includedAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll3'));
        SET includedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet3'),'[',''),']',''),'"','');
        SET includedEarliestLatest = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedEarliestLatest3'));
        SET includedAnyAllTested = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAllTested3'));
        SET includedTestedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedTestedValueSet3'),'[',''),']',''),'"','');
        SET includedDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom3')); 
        SET includedDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo3')); 
        SET includedPeriodOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator3'));
        SET includedPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue3')); 
        SET includedPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType3')); 

        SET includedDob = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDob3'));
        SET includedDiagnosisAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDiagnosisAnyAll3'));
        SET includedDiagnosisValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedDiagnosisValueSet3'),'[',''),']',''),'"','');
        SET includedDiagnosisAgeFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDiagnosisAgeFrom3')); 
        SET includedDiagnosisAgeTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDiagnosisAgeTo3')); 

        -- 3
        SET incValueSet_tmp = CONCAT('incvalueset3_tmp_',p_query_id);
        SET incConcept_tmp = CONCAT('incconcept3_tmp_',p_query_id);
        SET observation_tmp = CONCAT('observation3_tmp_',p_query_id);
        SET incTestedValueset_tmp = CONCAT('inctestedvalueset3_tmp_',p_query_id);
        SET incTestedConcept_tmp = CONCAT('inctestedconcept3_tmp_',p_query_id);
        SET incDiagnosisValueSet_tmp = CONCAT('incdiagnosisvalueset3_tmp_',p_query_id);
        SET incDiagnosisConcept_tmp = CONCAT('incdiagnosisconcept3_tmp_',p_query_id);
        SET diagnosis_tmp = CONCAT('diagnosis3_tmp_',p_query_id);

    -- Q3 --
        CALL buildQuery(p_query_id, withWithout, includedAnyAll, includedValueSet, includedDateFrom, includedDateTo, includedPeriodOperator, includedPeriodValue, includedPeriodType, incValueSet_tmp, 
        incConcept_tmp, p_observationCohort_tmp, '3', includedEarliestLatest, NULL, NULL, observation_tmp, includedAnyAllTested, includedTestedValueSet, incTestedValueset_tmp, 
        incTestedConcept_tmp, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, includedDiagnosisAgeFrom, includedDiagnosisAgeTo, includedDob, includedDiagnosisAnyAll, includedDiagnosisValueSet,
        incDiagnosisValueSet_tmp, incDiagnosisConcept_tmp, diagnosis_tmp, p_schema, p_store_tmp, p_queryCohort, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet_tmp,',',incConcept_tmp,',', observation_tmp,',',incTestedValueset_tmp,',',incTestedConcept_tmp,',',incDiagnosisValueSet_tmp,',',incDiagnosisConcept_tmp,',',diagnosis_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '3A' THEN 

        SET withWithout = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout3a')); 
        SET includedAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll3a'));
        SET includedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet3a'),'[',''),']',''),'"','');
        SET includedEarliestLatest = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedEarliestLatest3a'));
        SET includedAnyAllTested = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAllTested3a'));
        SET includedTestedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedTestedValueSet3a'),'[',''),']',''),'"','');
        SET includedDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom3a')); 
        SET includedDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo3a')); 
        SET includedPeriodOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator3a'));
        SET includedPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue3a')); 
        SET includedPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType3a')); 

        SET includedDob = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDob3a'));
        SET includedDiagnosisAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDiagnosisAnyAll3a'));
        SET includedDiagnosisValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedDiagnosisValueSet3a'),'[',''),']',''),'"','');
        SET includedDiagnosisAgeFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDiagnosisAgeFrom3a')); 
        SET includedDiagnosisAgeTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDiagnosisAgeTo3a')); 

        -- 3a
        SET incValueSet_tmp = CONCAT('incvalueset3a_tmp_',p_query_id);
        SET incConcept_tmp = CONCAT('incconcept3a_tmp_',p_query_id);
        SET observation_tmp = CONCAT('observation3a_tmp_',p_query_id);
        SET incTestedValueset_tmp = CONCAT('inctestedvalueset3a_tmp_',p_query_id);
        SET incTestedConcept_tmp = CONCAT('inctestedconcept3a_tmp_',p_query_id);
        SET incDiagnosisValueSet_tmp = CONCAT('incdiagnosisvalueset3a_tmp_',p_query_id);
        SET incDiagnosisConcept_tmp = CONCAT('incdiagnosisconcept3a_tmp_',p_query_id);
        SET diagnosis_tmp = CONCAT('diagnosis3a_tmp_',p_query_id);

    -- Q3a --
        CALL buildQuery(p_query_id, withWithout, includedAnyAll, includedValueSet, includedDateFrom, includedDateTo, includedPeriodOperator, includedPeriodValue, includedPeriodType, incValueSet_tmp, 
        incConcept_tmp, p_observationCohort_tmp, '3', includedEarliestLatest, NULL, NULL, observation_tmp, includedAnyAllTested, includedTestedValueSet, incTestedValueset_tmp, 
        incTestedConcept_tmp, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, includedDiagnosisAgeFrom, includedDiagnosisAgeTo, includedDob, includedDiagnosisAnyAll, includedDiagnosisValueSet,
        incDiagnosisValueSet_tmp, incDiagnosisConcept_tmp, diagnosis_tmp, p_schema, p_store_tmp, p_queryCohort, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet_tmp,',',incConcept_tmp,',', observation_tmp,',',incTestedValueset_tmp,',',incTestedConcept_tmp,',',incDiagnosisValueSet_tmp,',',incDiagnosisConcept_tmp,',',diagnosis_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '3B' THEN 

        SET withWithout = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout3b')); 
        SET includedAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll3b'));
        SET includedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet3b'),'[',''),']',''),'"','');
        SET includedEarliestLatest = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedEarliestLatest3b'));
        SET includedAnyAllTested = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAllTested3b'));
        SET includedTestedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedTestedValueSet3b'),'[',''),']',''),'"','');
        SET includedDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom3b')); 
        SET includedDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo3b')); 
        SET includedPeriodOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator3b'));
        SET includedPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue3b')); 
        SET includedPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType3b')); 

        SET includedDob = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDob3b'));
        SET includedDiagnosisAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDiagnosisAnyAll3b'));
        SET includedDiagnosisValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedDiagnosisValueSet3b'),'[',''),']',''),'"','');
        SET includedDiagnosisAgeFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDiagnosisAgeFrom3b')); 
        SET includedDiagnosisAgeTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDiagnosisAgeTo3b')); 

        -- 3b
        SET incValueSet_tmp = CONCAT('incvalueset3b_tmp_',p_query_id);
        SET incConcept_tmp = CONCAT('incconcept3b_tmp_',p_query_id);
        SET observation_tmp = CONCAT('observation3b_tmp_',p_query_id);
        SET incTestedValueset_tmp = CONCAT('inctestedvalueset3b_tmp_',p_query_id);
        SET incTestedConcept_tmp = CONCAT('inctestedconcept3b_tmp_',p_query_id);
        SET incDiagnosisValueSet_tmp = CONCAT('incdiagnosisvalueset3b_tmp_',p_query_id);
        SET incDiagnosisConcept_tmp = CONCAT('incdiagnosisconcept3b_tmp_',p_query_id);
        SET diagnosis_tmp = CONCAT('diagnosis3b_tmp_',p_query_id);

    -- Q3b --
        CALL buildQuery(p_query_id, withWithout, includedAnyAll, includedValueSet, includedDateFrom, includedDateTo, includedPeriodOperator, includedPeriodValue, includedPeriodType, incValueSet_tmp, 
        incConcept_tmp, p_observationCohort_tmp, '3', includedEarliestLatest, NULL, NULL, observation_tmp, includedAnyAllTested, includedTestedValueSet, incTestedValueset_tmp, 
        incTestedConcept_tmp, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, includedDiagnosisAgeFrom, includedDiagnosisAgeTo, includedDob, includedDiagnosisAnyAll, includedDiagnosisValueSet,
        incDiagnosisValueSet_tmp, incDiagnosisConcept_tmp, diagnosis_tmp, p_schema, p_store_tmp, p_queryCohort, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet_tmp,',',incConcept_tmp,',', observation_tmp,',',incTestedValueset_tmp,',',incTestedConcept_tmp,',',incDiagnosisValueSet_tmp,',',incDiagnosisConcept_tmp,',',diagnosis_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '3C' THEN 

        SET withWithout = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout3c')); 
        SET includedAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll3c'));
        SET includedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet3c'),'[',''),']',''),'"','');
        SET includedEarliestLatest = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedEarliestLatest3c'));
        SET includedAnyAllTested = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAllTested3c'));
        SET includedTestedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedTestedValueSet3c'),'[',''),']',''),'"','');
        SET includedDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom3c')); 
        SET includedDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo3c')); 
        SET includedPeriodOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator3c'));
        SET includedPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue3c')); 
        SET includedPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType3c')); 

        SET includedDob = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDob3c'));
        SET includedDiagnosisAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDiagnosisAnyAll3c'));
        SET includedDiagnosisValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedDiagnosisValueSet3c'),'[',''),']',''),'"','');
        SET includedDiagnosisAgeFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDiagnosisAgeFrom3c')); 
        SET includedDiagnosisAgeTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDiagnosisAgeTo3c')); 

        -- 3c
        SET incValueSet_tmp = CONCAT('incvalueset3c_tmp_',p_query_id);
        SET incConcept_tmp = CONCAT('incconcept3c_tmp_',p_query_id);
        SET observation_tmp = CONCAT('observation3c_tmp_',p_query_id);
        SET incTestedValueset_tmp = CONCAT('inctestedvalueset3c_tmp_',p_query_id);
        SET incTestedConcept_tmp = CONCAT('inctestedconcept3c_tmp_',p_query_id);
        SET incDiagnosisValueSet_tmp = CONCAT('incdiagnosisvalueset3c_tmp_',p_query_id);
        SET incDiagnosisConcept_tmp = CONCAT('incdiagnosisconcept3c_tmp_',p_query_id);
        SET diagnosis_tmp = CONCAT('diagnosis3c_tmp_',p_query_id);

    -- Q3c --
        CALL buildQuery(p_query_id, withWithout, includedAnyAll, includedValueSet, includedDateFrom, includedDateTo, includedPeriodOperator, includedPeriodValue, includedPeriodType, incValueSet_tmp, 
        incConcept_tmp, p_observationCohort_tmp, '3', includedEarliestLatest, NULL, NULL, observation_tmp, includedAnyAllTested, includedTestedValueSet, incTestedValueset_tmp, 
        incTestedConcept_tmp, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, includedDiagnosisAgeFrom, includedDiagnosisAgeTo, includedDob, includedDiagnosisAnyAll, includedDiagnosisValueSet,
        incDiagnosisValueSet_tmp, incDiagnosisConcept_tmp, diagnosis_tmp, p_schema, p_store_tmp, p_queryCohort, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet_tmp,',',incConcept_tmp,',', observation_tmp,',',incTestedValueset_tmp,',',incTestedConcept_tmp,',',incDiagnosisValueSet_tmp,',',incDiagnosisConcept_tmp,',',diagnosis_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '3D' THEN 

        SET withWithout = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout3d')); 
        SET includedAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll3d'));
        SET includedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet3d'),'[',''),']',''),'"','');
        SET includedEarliestLatest = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedEarliestLatest3d'));
        SET includedAnyAllTested = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAllTested3d'));
        SET includedTestedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedTestedValueSet3d'),'[',''),']',''),'"','');
        SET includedDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom3d')); 
        SET includedDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo3d')); 
        SET includedPeriodOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator3d'));
        SET includedPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue3d')); 
        SET includedPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType3d')); 

        SET includedDob = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDob3d'));
        SET includedDiagnosisAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDiagnosisAnyAll3d'));
        SET includedDiagnosisValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedDiagnosisValueSet3d'),'[',''),']',''),'"','');
        SET includedDiagnosisAgeFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDiagnosisAgeFrom3d')); 
        SET includedDiagnosisAgeTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDiagnosisAgeTo3d')); 

        -- 3d
        SET incValueSet_tmp = CONCAT('incvalueset3d_tmp_',p_query_id);
        SET incConcept_tmp = CONCAT('incconcept3d_tmp_',p_query_id);
        SET observation_tmp = CONCAT('observation3d_tmp_',p_query_id);
        SET incTestedValueset_tmp = CONCAT('inctestedvalueset3d_tmp_',p_query_id);
        SET incTestedConcept_tmp = CONCAT('inctestedconcept3d_tmp_',p_query_id);
        SET incDiagnosisValueSet_tmp = CONCAT('incdiagnosisvalueset3d_tmp_',p_query_id);
        SET incDiagnosisConcept_tmp = CONCAT('incdiagnosisconcept3d_tmp_',p_query_id);
        SET diagnosis_tmp = CONCAT('diagnosis3d_tmp_',p_query_id);

    -- Q3d --
        CALL buildQuery(p_query_id, withWithout, includedAnyAll, includedValueSet, includedDateFrom, includedDateTo, includedPeriodOperator, includedPeriodValue, includedPeriodType, incValueSet_tmp, 
        incConcept_tmp, p_observationCohort_tmp, '3', includedEarliestLatest, NULL, NULL, observation_tmp, includedAnyAllTested, includedTestedValueSet, incTestedValueset_tmp, 
        incTestedConcept_tmp, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, includedDiagnosisAgeFrom, includedDiagnosisAgeTo, includedDob, includedDiagnosisAnyAll, includedDiagnosisValueSet,
        incDiagnosisValueSet_tmp, incDiagnosisConcept_tmp, diagnosis_tmp, p_schema, p_store_tmp, p_queryCohort, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet_tmp,',',incConcept_tmp,',', observation_tmp,',',incTestedValueset_tmp,',',incTestedConcept_tmp,',',incDiagnosisValueSet_tmp,',',incDiagnosisConcept_tmp,',',diagnosis_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '3E' THEN 

        SET withWithout = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout3e')); 
        SET includedAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll3e'));
        SET includedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet3e'),'[',''),']',''),'"','');
        SET includedEarliestLatest = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedEarliestLatest3e'));
        SET includedAnyAllTested = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAllTested3e'));
        SET includedTestedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedTestedValueSet3e'),'[',''),']',''),'"','');
        SET includedDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom3e')); 
        SET includedDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo3e')); 
        SET includedPeriodOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator3e'));
        SET includedPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue3e')); 
        SET includedPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType3e')); 

        SET includedDob = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDob3e'));
        SET includedDiagnosisAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDiagnosisAnyAll3e'));
        SET includedDiagnosisValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedDiagnosisValueSet3e'),'[',''),']',''),'"','');
        SET includedDiagnosisAgeFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDiagnosisAgeFrom3e')); 
        SET includedDiagnosisAgeTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDiagnosisAgeTo3e')); 

        -- 3e
        SET incValueSet_tmp = CONCAT('incvalueset3e_tmp_',p_query_id);
        SET incConcept_tmp = CONCAT('incconcept3e_tmp_',p_query_id);
        SET observation_tmp = CONCAT('observation3e_tmp_',p_query_id);
        SET incTestedValueset_tmp = CONCAT('inctestedvalueset3e_tmp_',p_query_id);
        SET incTestedConcept_tmp = CONCAT('inctestedconcept3e_tmp_',p_query_id);
        SET incDiagnosisValueSet_tmp = CONCAT('incdiagnosisvalueset3e_tmp_',p_query_id);
        SET incDiagnosisConcept_tmp = CONCAT('incdiagnosisconcept3e_tmp_',p_query_id);
        SET diagnosis_tmp = CONCAT('diagnosis3e_tmp_',p_query_id);

    -- Q3e --
        CALL buildQuery(p_query_id, withWithout, includedAnyAll, includedValueSet, includedDateFrom, includedDateTo, includedPeriodOperator, includedPeriodValue, includedPeriodType, incValueSet_tmp, 
        incConcept_tmp, p_observationCohort_tmp, '3', includedEarliestLatest, NULL, NULL, observation_tmp, includedAnyAllTested, includedTestedValueSet, incTestedValueset_tmp, 
        incTestedConcept_tmp, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, includedDiagnosisAgeFrom, includedDiagnosisAgeTo, includedDob, includedDiagnosisAnyAll, includedDiagnosisValueSet,
        incDiagnosisValueSet_tmp, incDiagnosisConcept_tmp, diagnosis_tmp, p_schema, p_store_tmp, p_queryCohort, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet_tmp,',',incConcept_tmp,',', observation_tmp,',',incTestedValueset_tmp,',',incTestedConcept_tmp,',',incDiagnosisValueSet_tmp,',',incDiagnosisConcept_tmp,',',diagnosis_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '3F' THEN 

        SET withWithout = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout3f')); 
        SET includedAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll3f'));
        SET includedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet3f'),'[',''),']',''),'"','');
        SET includedEarliestLatest = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedEarliestLatest3f'));
        SET includedAnyAllTested = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAllTested3f'));
        SET includedTestedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedTestedValueSet3f'),'[',''),']',''),'"','');
        SET includedDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom3f')); 
        SET includedDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo3f')); 
        SET includedPeriodOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator3f'));
        SET includedPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue3f')); 
        SET includedPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType3f')); 

        SET includedDob = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDob3f'));
        SET includedDiagnosisAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDiagnosisAnyAll3f'));
        SET includedDiagnosisValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedDiagnosisValueSet3f'),'[',''),']',''),'"','');
        SET includedDiagnosisAgeFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDiagnosisAgeFrom3f')); 
        SET includedDiagnosisAgeTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDiagnosisAgeTo3f')); 

        -- 3f
        SET incValueSet_tmp = CONCAT('incvalueset3f_tmp_',p_query_id);
        SET incConcept_tmp = CONCAT('incconcept3f_tmp_',p_query_id);
        SET observation_tmp = CONCAT('observation3f_tmp_',p_query_id);
        SET incTestedValueset_tmp = CONCAT('inctestedvalueset3f_tmp_',p_query_id);
        SET incTestedConcept_tmp = CONCAT('inctestedconcept3f_tmp_',p_query_id);
        SET incDiagnosisValueSet_tmp = CONCAT('incdiagnosisvalueset3f_tmp_',p_query_id);
        SET incDiagnosisConcept_tmp = CONCAT('incdiagnosisconcept3f_tmp_',p_query_id);
        SET diagnosis_tmp = CONCAT('diagnosis3f_tmp_',p_query_id);

    -- Q3f --
        CALL buildQuery(p_query_id, withWithout, includedAnyAll, includedValueSet, includedDateFrom, includedDateTo, includedPeriodOperator, includedPeriodValue, includedPeriodType, incValueSet_tmp, 
        incConcept_tmp, p_observationCohort_tmp, '3', includedEarliestLatest, NULL, NULL, observation_tmp, includedAnyAllTested, includedTestedValueSet, incTestedValueset_tmp, 
        incTestedConcept_tmp, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, includedDiagnosisAgeFrom, includedDiagnosisAgeTo, includedDob, includedDiagnosisAnyAll, includedDiagnosisValueSet,
        incDiagnosisValueSet_tmp, incDiagnosisConcept_tmp, diagnosis_tmp, p_schema, p_store_tmp, p_queryCohort, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet_tmp,',',incConcept_tmp,',', observation_tmp,',',incTestedValueset_tmp,',',incTestedConcept_tmp,',',incDiagnosisValueSet_tmp,',',incDiagnosisConcept_tmp,',',diagnosis_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '3G' THEN 

        SET withWithout = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout3g')); 
        SET includedAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll3g'));
        SET includedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet3g'),'[',''),']',''),'"','');
        SET includedEarliestLatest = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedEarliestLatest3g'));
        SET includedAnyAllTested = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAllTested3g'));
        SET includedTestedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedTestedValueSet3g'),'[',''),']',''),'"','');
        SET includedDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom3g')); 
        SET includedDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo3g')); 
        SET includedPeriodOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator3g'));
        SET includedPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue3g')); 
        SET includedPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType3g')); 

        SET includedDob = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDob3g'));
        SET includedDiagnosisAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDiagnosisAnyAll3g'));
        SET includedDiagnosisValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedDiagnosisValueSet3g'),'[',''),']',''),'"','');
        SET includedDiagnosisAgeFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDiagnosisAgeFrom3g')); 
        SET includedDiagnosisAgeTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDiagnosisAgeTo3g')); 

        -- 3g
        SET incValueSet_tmp = CONCAT('incvalueset3g_tmp_',p_query_id);
        SET incConcept_tmp = CONCAT('incconcept3g_tmp_',p_query_id);
        SET observation_tmp = CONCAT('observation3g_tmp_',p_query_id);
        SET incTestedValueset_tmp = CONCAT('inctestedvalueset3g_tmp_',p_query_id);
        SET incTestedConcept_tmp = CONCAT('inctestedconcept3g_tmp_',p_query_id);
        SET incDiagnosisValueSet_tmp = CONCAT('incdiagnosisvalueset3g_tmp_',p_query_id);
        SET incDiagnosisConcept_tmp = CONCAT('incdiagnosisconcept3g_tmp_',p_query_id);
        SET diagnosis_tmp = CONCAT('diagnosis3g_tmp_',p_query_id);

    -- Q3g --
        CALL buildQuery(p_query_id, withWithout, includedAnyAll, includedValueSet, includedDateFrom, includedDateTo, includedPeriodOperator, includedPeriodValue, includedPeriodType, incValueSet_tmp, 
        incConcept_tmp, p_observationCohort_tmp, '3', includedEarliestLatest, NULL, NULL, observation_tmp, includedAnyAllTested, includedTestedValueSet, incTestedValueset_tmp, 
        incTestedConcept_tmp, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, includedDiagnosisAgeFrom, includedDiagnosisAgeTo, includedDob, includedDiagnosisAnyAll, includedDiagnosisValueSet,
        incDiagnosisValueSet_tmp, incDiagnosisConcept_tmp, diagnosis_tmp, p_schema, p_store_tmp, p_queryCohort, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet_tmp,',',incConcept_tmp,',', observation_tmp,',',incTestedValueset_tmp,',',incTestedConcept_tmp,',',incDiagnosisValueSet_tmp,',',incDiagnosisConcept_tmp,',',diagnosis_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '3H' THEN 

        SET withWithout = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout3h')); 
        SET includedAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll3h'));
        SET includedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet3h'),'[',''),']',''),'"','');
        SET includedEarliestLatest = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedEarliestLatest3h'));
        SET includedAnyAllTested = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAllTested3h'));
        SET includedTestedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedTestedValueSet3h'),'[',''),']',''),'"','');
        SET includedDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom3h')); 
        SET includedDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo3h')); 
        SET includedPeriodOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator3h'));
        SET includedPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue3h')); 
        SET includedPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType3h')); 

        SET includedDob = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDob3h'));
        SET includedDiagnosisAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDiagnosisAnyAll3h'));
        SET includedDiagnosisValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedDiagnosisValueSet3h'),'[',''),']',''),'"','');
        SET includedDiagnosisAgeFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDiagnosisAgeFrom3h')); 
        SET includedDiagnosisAgeTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDiagnosisAgeTo3h')); 

        -- 3h
        SET incValueSet_tmp = CONCAT('incvalueset3h_tmp_',p_query_id);
        SET incConcept_tmp = CONCAT('incconcept3h_tmp_',p_query_id);
        SET observation_tmp = CONCAT('observation3h_tmp_',p_query_id);
        SET incTestedValueset_tmp = CONCAT('inctestedvalueset3h_tmp_',p_query_id);
        SET incTestedConcept_tmp = CONCAT('inctestedconcept3h_tmp_',p_query_id);
        SET incDiagnosisValueSet_tmp = CONCAT('incdiagnosisvalueset3h_tmp_',p_query_id);
        SET incDiagnosisConcept_tmp = CONCAT('incdiagnosisconcept3h_tmp_',p_query_id);
        SET diagnosis_tmp = CONCAT('diagnosis3h_tmp_',p_query_id);

    -- Q3h --
        CALL buildQuery(p_query_id, withWithout, includedAnyAll, includedValueSet, includedDateFrom, includedDateTo, includedPeriodOperator, includedPeriodValue, includedPeriodType, incValueSet_tmp, 
        incConcept_tmp, p_observationCohort_tmp, '3', includedEarliestLatest, NULL, NULL, observation_tmp, includedAnyAllTested, includedTestedValueSet, incTestedValueset_tmp, 
        incTestedConcept_tmp, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, includedDiagnosisAgeFrom, includedDiagnosisAgeTo, includedDob, includedDiagnosisAnyAll, includedDiagnosisValueSet,
        incDiagnosisValueSet_tmp, incDiagnosisConcept_tmp, diagnosis_tmp, p_schema, p_store_tmp, p_queryCohort, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet_tmp,',',incConcept_tmp,',', observation_tmp,',',incTestedValueset_tmp,',',incTestedConcept_tmp,',',incDiagnosisValueSet_tmp,',',incDiagnosisConcept_tmp,',',diagnosis_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '4' THEN 

        SET withWithout = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout4')); 
        SET includedAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll4'));
        SET includedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet4'),'[',''),']',''),'"','');
        SET includedAreNot = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAreNot4'));
        SET includedAnyAllFollowedBy = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAllFollowedBy4'));
        SET includedFollowedByValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedFollowedByValueSet4'),'[',''),']',''),'"','');
        SET includedDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom4')); 
        SET includedDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo4')); 
        SET includedPeriodOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator4'));
        SET includedPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue4')); 
        SET includedPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType4')); 
        -- 4
        SET incValueSet_tmp = CONCAT('incvalueset4_tmp_',p_query_id);
        SET incConcept_tmp = CONCAT('incconcept4_tmp_',p_query_id);
        SET observation_tmp = CONCAT('observation4_tmp_',p_query_id);
        SET incFollowedByValueSet_tmp = CONCAT('incfollowedbyvalueset4_tmp_',p_query_id);
        SET incFollowedByConcept_tmp = CONCAT('incfollowedbyconcept4_tmp_',p_query_id);

    -- Q4 --
        CALL buildQuery(p_query_id, withWithout, includedAnyAll, includedValueSet, includedDateFrom, includedDateTo, includedPeriodOperator, includedPeriodValue, includedPeriodType, incValueSet_tmp, 
        incConcept_tmp, p_observationCohort_tmp, '4', NULL, NULL, NULL, observation_tmp, NULL, NULL, NULL, 
        NULL, includedAreNot, includedAnyAllFollowedBy, includedFollowedByValueSet, incFollowedByValueSet_tmp, incFollowedByConcept_tmp, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, NULL, p_schema , p_store_tmp, p_queryCohort, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet_tmp,',',incConcept_tmp,',', observation_tmp,',',incFollowedByValueSet_tmp,',',incFollowedByConcept_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '4A' THEN 

        SET withWithout = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout4a')); 
        SET includedAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll4a'));
        SET includedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet4a'),'[',''),']',''),'"','');
        SET includedAreNot = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAreNot4a'));
        SET includedAnyAllFollowedBy = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAllFollowedBy4a'));
        SET includedFollowedByValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedFollowedByValueSet4a'),'[',''),']',''),'"','');
        SET includedDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom4a')); 
        SET includedDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo4a')); 
        SET includedPeriodOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator4a'));
        SET includedPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue4a')); 
        SET includedPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType4a')); 
        -- 4a
        SET incValueSet_tmp = CONCAT('incvalueset4a_tmp_',p_query_id);
        SET incConcept_tmp = CONCAT('incconcept4a_tmp_',p_query_id);
        SET observation_tmp = CONCAT('observation4a_tmp_',p_query_id);
        SET incFollowedByValueSet_tmp = CONCAT('incfollowedbyvalueset4a_tmp_',p_query_id);
        SET incFollowedByConcept_tmp = CONCAT('incfollowedbyconcept4a_tmp_',p_query_id);

    -- Q4 --
        CALL buildQuery(p_query_id, withWithout, includedAnyAll, includedValueSet, includedDateFrom, includedDateTo, includedPeriodOperator, includedPeriodValue, includedPeriodType, incValueSet_tmp, 
        incConcept_tmp, p_observationCohort_tmp, '4', NULL, NULL, NULL, observation_tmp, NULL, NULL, NULL, 
        NULL, includedAreNot, includedAnyAllFollowedBy, includedFollowedByValueSet, incFollowedByValueSet_tmp, incFollowedByConcept_tmp, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, NULL, p_schema , p_store_tmp, p_queryCohort, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet_tmp,',',incConcept_tmp,',', observation_tmp,',',incFollowedByValueSet_tmp,',',incFollowedByConcept_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '4B' THEN 

        SET withWithout = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout4b')); 
        SET includedAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll4b'));
        SET includedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet4b'),'[',''),']',''),'"','');
        SET includedAreNot = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAreNot4b'));
        SET includedAnyAllFollowedBy = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAllFollowedBy4b'));
        SET includedFollowedByValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedFollowedByValueSet4b'),'[',''),']',''),'"','');
        SET includedDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom4b')); 
        SET includedDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo4b')); 
        SET includedPeriodOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator4b'));
        SET includedPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue4b')); 
        SET includedPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType4b')); 
        -- 4b
        SET incValueSet_tmp = CONCAT('incvalueset4b_tmp_',p_query_id);
        SET incConcept_tmp = CONCAT('incconcept4b_tmp_',p_query_id);
        SET observation_tmp = CONCAT('observation4b_tmp_',p_query_id);
        SET incFollowedByValueSet_tmp = CONCAT('incfollowedbyvalueset4b_tmp_',p_query_id);
        SET incFollowedByConcept_tmp = CONCAT('incfollowedbyconcept4b_tmp_',p_query_id);

    -- Q4 --
        CALL buildQuery(p_query_id, withWithout, includedAnyAll, includedValueSet, includedDateFrom, includedDateTo, includedPeriodOperator, includedPeriodValue, includedPeriodType, incValueSet_tmp, 
        incConcept_tmp, p_observationCohort_tmp, '4', NULL, NULL, NULL, observation_tmp, NULL, NULL, NULL, 
        NULL, includedAreNot, includedAnyAllFollowedBy, includedFollowedByValueSet, incFollowedByValueSet_tmp, incFollowedByConcept_tmp, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, NULL, p_schema , p_store_tmp, p_queryCohort, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet_tmp,',',incConcept_tmp,',', observation_tmp,',',incFollowedByValueSet_tmp,',',incFollowedByConcept_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '5' THEN 

        SET withWithout = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout5')); 
        SET includedAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll5'));
        SET includedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet5'),'[',''),']',''),'"','');
        SET includedOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedOperator5'));
        SET includedEntryValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedEntryValue5')); 
        SET includedDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom5')); 
        SET includedDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo5')); 
        SET includedPeriodOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator5'));
        SET includedPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue5')); 
        SET includedPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType5')); 
        -- 5
        SET incValueSet_tmp = CONCAT('incvalueset5_tmp_',p_query_id);
        SET incConcept_tmp = CONCAT('incconcept5_tmp_',p_query_id);
        SET observation_tmp = CONCAT('observation5_tmp_',p_query_id);

    -- Q5 --
        CALL buildQuery(p_query_id, withWithout, includedAnyAll, includedValueSet, includedDateFrom, includedDateTo, includedPeriodOperator, includedPeriodValue, includedPeriodType, incValueSet_tmp, 
        incConcept_tmp, p_observationCohort_tmp, '5', NULL, NULL, NULL, observation_tmp, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, includedOperator, includedEntryValue, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, NULL, p_schema , p_store_tmp, p_queryCohort, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet_tmp,',',incConcept_tmp,',', observation_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '5A' THEN 

        SET withWithout = JSON_UNQUOTE(JSON_EXTRACT(query,'$.withWithout5a')); 
        SET includedAnyAll = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedAnyAll5a'));
        SET includedValueSet = REPLACE(REPLACE(REPLACE(JSON_EXTRACT(query,'$.includedValueSet5a'),'[',''),']',''),'"','');
        SET includedOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedOperator5a'));
        SET includedEntryValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedEntryValue5a')); 
        SET includedDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateFrom5a')); 
        SET includedDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedDateTo5a')); 
        SET includedPeriodOperator = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodOperator5a'));
        SET includedPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodValue5a')); 
        SET includedPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.includedPeriodType5a'));
        -- 5a
        SET incValueSet_tmp = CONCAT('incvalueset5a_tmp_',p_query_id);
        SET incConcept_tmp = CONCAT('incconcept5a_tmp_',p_query_id);
        SET observation_tmp = CONCAT('observation5a_tmp_',p_query_id);

    -- Q5a --
        CALL buildQuery(p_query_id, withWithout, includedAnyAll, includedValueSet, includedDateFrom, includedDateTo, includedPeriodOperator, includedPeriodValue, includedPeriodType, incValueSet_tmp, 
        incConcept_tmp, p_observationCohort_tmp, '5', NULL, NULL, NULL, observation_tmp, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, includedOperator, includedEntryValue, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, p_schema , p_store_tmp, p_queryCohort, p_queryNumber);

        -- remove tmp tables
        SET tempTables = CONCAT(incValueSet_tmp,',',incConcept_tmp,',', observation_tmp);
        CALL dropTempTables(tempTables);

    ELSEIF p_queryNumber = '0' THEN -- registration date range

        SET registrationExclude = JSON_UNQUOTE(JSON_EXTRACT(query,'$.registrationExclude')); 
        SET registrationDateFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.registrationDateFrom'));   
        SET registrationDateTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.registrationDateTo')); 
        SET registrationPeriodValue = JSON_UNQUOTE(JSON_EXTRACT(query,'$.registrationPeriodValue'));
        SET registrationPeriodType = JSON_UNQUOTE(JSON_EXTRACT(query,'$.registrationPeriodType'));
    -- Q0 --
        CALL buildQuery(p_query_id, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, registrationExclude, registrationDateFrom, 
        registrationDateTo, registrationPeriodValue, registrationPeriodType, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, p_schema, NULL, p_queryCohort, p_queryNumber);

    ELSEIF p_queryNumber = 'A1' THEN 

        SET ageFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.ageFrom1'));
        SET ageTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.ageTo1'));  

    -- A1 --
        CALL buildQuery(p_query_id, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, 'A', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, ageFrom, ageTo, NULL, NULL, NULL,
        NULL, NULL, NULL, p_schema, NULL, p_queryCohort, p_queryNumber);

    ELSEIF p_queryNumber = 'A2' THEN 

        SET ageFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.ageFrom2'));
        SET ageTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.ageTo2'));  

    -- A2 --
        CALL buildQuery(p_query_id, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, 'A', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, ageFrom, ageTo, NULL, NULL, NULL,
        NULL, NULL, NULL, p_schema, NULL, p_queryCohort, p_queryNumber);

    ELSEIF p_queryNumber = 'A3' THEN 

        SET ageFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.ageFrom3'));
        SET ageTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.ageTo3'));  

    -- A3 --
        CALL buildQuery(p_query_id, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, 'A', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, ageFrom, ageTo, NULL, NULL, NULL,
        NULL, NULL, NULL, p_schema, NULL, p_queryCohort, p_queryNumber);

    ELSEIF p_queryNumber = 'A4' THEN 

        SET ageFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.ageFrom4'));
        SET ageTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.ageTo4'));  

    -- A4 --
        CALL buildQuery(p_query_id, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, 'A', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, ageFrom, ageTo, NULL, NULL, NULL,
        NULL, NULL, NULL, p_schema, NULL, p_queryCohort, p_queryNumber);

    ELSEIF p_queryNumber = 'A5' THEN 

        SET ageFrom = JSON_UNQUOTE(JSON_EXTRACT(query,'$.ageFrom5'));
        SET ageTo = JSON_UNQUOTE(JSON_EXTRACT(query,'$.ageTo5'));  

    -- A5 --
        CALL buildQuery(p_query_id, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, 'A', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, ageFrom, ageTo, NULL, NULL, NULL,
        NULL, NULL, NULL, p_schema, NULL, p_queryCohort, p_queryNumber);

    END IF;

END //
DELIMITER ;