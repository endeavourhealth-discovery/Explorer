USE dashboards;


DROP PROCEDURE IF EXISTS createDatasetOutputTables;

DELIMITER //

CREATE PROCEDURE createDatasetOutputTables()

BEGIN

DROP TABLE IF EXISTS dataset_tables;

CREATE TABLE dataset_tables (
  id  INT(11) NOT NULL AUTO_INCREMENT,       
  table_name VARCHAR(100) NOT NULL,
  column_name VARCHAR(100) NOT NULL,
  field_name VARCHAR(100) NOT NULL, 
  PRIMARY KEY (id) 
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;


ALTER TABLE dataset_tables ADD INDEX tab_idx(table_name);
ALTER TABLE dataset_tables ADD INDEX field_idx(field_name);

INSERT INTO dataset_tables (table_name, column_name, field_name)
VALUES
('patient', 'id', 'Patient ID'),
('patient', 'organization_id', 'Oraganization ID'),
('patient', 'person_id', 'Person ID'),
('patient', 'title', 'Title'),
('patient', 'first_names', 'First Names'),
('patient', 'last_name', 'Last Name'),
('patient', 'gender_concept_id', 'Gender Concept Code'),
('patient', 'getConceptName(gender_concept_id)', 'Gender Concept Name'),
('patient', 'nhs_number', 'NHS Number'),
('patient', 'date_of_birth', 'Date Of Birth'),
('patient', 'date_of_death', 'Date Of Death'),
('patient', 'current_address_id', 'Current Address'),
('patient', 'ethnic_code_concept_id', 'Ethnic Concept Code'),
('patient', 'getConceptName(ethnic_code_concept_id)', 'Ethnic Concept Name'),
('patient', 'registered_practice_organization_id', 'Registered Practice'),
('observation','id','Observation ID'), 
('observation','organization_id', 'Organization ID'),
('observation','patient_id', 'Patient ID'),
('observation','person_id', 'Person ID'),
('observation','encounter_id', 'Encounter ID'),
('observation','practitioner_id', 'Practitioner ID'),
('observation','clinical_effective_date', 'Effective Date'), 
('observation','date_precision_concept_id', 'Date Precision Code'),
('observation','getConceptName(date_precision_concept_id)', 'Date Precision Name'),
('observation','result_value', 'Result Value'),
('observation','result_value_units', 'Result Value Units'),
('observation','result_date', 'Result Date'),
('observation','result_text', 'Result Text'),
('observation','result_concept_id', 'Result Concept Code'),
('observation','getConceptName(result_concept_id)', 'Result Concept Name'),
('observation','is_problem',  'Is Problem'),
('observation','is_review', 'Is Review'),
('observation','problem_end_date', 'Problem End Date'),
('observation','parent_observation_id', 'Parent Observation ID'),
('observation','core_concept_id', 'Core Concept Code'),
('observation','getConceptName(core_concept_id)', 'Core Concept Name'),
('observation','non_core_concept_id', 'Non Core Concept ID'),
('observation','getConceptName(non_core_concept_id)', 'Non Core Concept Name'),
('observation','age_at_event', 'Age At Event'),
('observation','episodicity_concept_id', 'Episodicity Concept Code'),
('observation','getConceptName(episodicity_concept_id)', 'Episodicity Concept Code'),
('observation','is_primary', 'Is Primary'),
('medication_statement','id', 'Medication Statement ID'),
('medication_statement','organization_id', 'Organization ID'),
('medication_statement','patient_id', 'Patient ID'),
('medication_statement','person_id', 'Person ID'),
('medication_statement','encounter_id', 'Encounter ID'),
('medication_statement','practitioner_id', 'Practitioner ID'),
('medication_statement','clinical_effective_date', 'Effective Date'), 
('medication_statement','date_precision_concept_id', 'Date Precision Concept Code'),
('medication_statement','getConceptName(date_precision_concept_id)', 'Date Precision Concept Name'),
('medication_statement','cancellation_date', 'Cancellation Date'),
('medication_statement','dose', 'Dose'),
('medication_statement','quantity_value', 'Quantity Value'),
('medication_statement','quantity_unit', 'Quantity Unit'),
('medication_statement','authorisation_type_concept_id', 'Authorisation Type Concept Code'),
('medication_statement','getConceptName(authorisation_type_concept_id)', 'Authorisation Type Concept Code'),
('medication_statement','core_concept_id', 'Core Concept Code'),
('medication_statement','getConceptName(core_concept_id)', 'Core Concept Name'),
('medication_statement','non_core_concept_id', 'Non Vore Concept Code'),
('medication_statement','getConceptName(non_core_concept_id)', 'Non Vore Concept Name'),
('medication_statement','bnf_reference', 'BNF Reference'),
('medication_statement','age_at_event', 'Age At Event'),
('medication_statement','issue_method', 'Issue Method'),
('encounter','id', 'Encounter ID'),
('encounter','organization_id', 'Oragnization ID'),
('encounter','patient_id', 'Patient ID'),
('encounter','person_id', 'Person ID'),
('encounter','practitioner_id', 'Practitioner ID'),
('encounter','appointment_id', 'Appointment ID'),
('encounter','clinical_effective_date', 'Effective Date' ),
('encounter','date_precision_concept_id', 'Date Precision Concept Code' ),
('encounter','getConceptName(date_precision_concept_id)', 'Date Precision Concept Name' ),
('encounter','episode_of_care_id', 'Episode Of Care ID'),
('encounter','service_provider_organization_id', 'Service Provider Organization ID' ),
('encounter','core_concept_id', 'Core Concept Code'),
('encounter','getConceptName(core_concept_id)', 'Core Concept Name'),
('encounter','non_core_concept_id', 'Non Core Concept Code'),
('encounter','getConceptName(non_core_concept_id)', 'Non Core Concept Name'),
('encounter','age_at_event', 'Age At Event'),
('encounter','type', 'Type'),
('encounter','sub_type', 'Sub Type'),
('encounter','admission_method', 'Admission Method'),
('encounter','end_date', 'End Date'),
('encounter','institution_location_id', 'Institution Location ID')
;

END //
DELIMITER ;