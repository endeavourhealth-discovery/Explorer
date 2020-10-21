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
('patient', 'getOrganizationName(registered_practice_organization_id)', 'Registered practice'),
('patient', 'title', 'Title'),
('patient', 'first_names', 'First Names'),
('patient', 'last_name', 'Last Name'),
('patient', 'getConceptName(gender_concept_id)', 'Gender'),
('patient', 'nhs_number', 'NHS Number'),
('patient', 'date_of_birth', 'Date Of Birth'),
('patient', 'date_of_death', 'Date Of Death'),
('patient', 'getCurrentAddress(current_address_id)', 'Current Address'),
('patient', 'getConceptName(ethnic_code_concept_id)', 'Ethnicity'),
('observation','getOrganizationName(organization_id)', 'Organization'),
('observation','getPatientName(patient_id)', 'Patient'),
('observation','getPractitionerName(practitioner_id)', 'Practitioner'),
('observation','clinical_effective_date', 'Effective date'), 
('observation','getConceptName(non_core_concept_id)', 'Concept term (i.e. Asthma, Systolic BP)'),
('observation','getConceptCode(non_core_concept_id)', 'Concept code (original code)'),
('observation','result_value', 'Result value'),
('observation','result_value_units', 'Result units'),
('observation','result_date', 'Result date'),
('observation','result_text', 'Result text'),
('observation','getConceptName(result_concept_id)', 'Result concept'),
('observation','is_problem',  'Is problem'),
('observation','is_review', 'Is review (i.e. problem review)'),
('observation','problem_end_date', 'Problem end date'),
('observation','age_at_event', 'Age of patient at event'),
('observation','getConceptName(episodicity_concept_id)', 'Episode (i.e. FIRST, NEW)'),
('observation','is_primary', 'Is primary (i.e. Primary diagnosis)'),
('medication_statement','getOrganizationName(organization_id)', 'Organization'),
('medication_statement','getPatientName(patient_id)', 'Patient'),
('medication_statement','getPractitionerName(practitioner_id)', 'Practitioner'),
('medication_statement','clinical_effective_date', 'Effective date'), 
('medication_statement','cancellation_date', 'Cancellation date'),
('medication_statement','dose', 'Dose'),
('medication_statement','quantity_value', 'Quantity value'),
('medication_statement','quantity_unit', 'Quantity unit'),
('medication_statement','getConceptName(authorisation_type_concept_id)', 'Authorisation type'),
('medication_statement','getConceptName(non_core_concept_id)', 'Drug name'),
('medication_statement','getConceptCode(non_core_concept_id)', 'Drug code'),
('medication_statement','bnf_reference', 'BNF reference'),
('medication_statement','age_at_event', 'Age at event'),
('medication_statement','getLastMedicationIssueDate(id)', 'Last issue date'),
('medication_statement','issue_method', 'Issue method'),
('encounter','getOrganizationName(organization_id)', 'Oragnization'),
('encounter','getPatientName(patient_id)', 'Patient'),
('encounter','getPractitionerName(practitioner_id)', 'Practitioner'),
('encounter','clinical_effective_date', 'Effective date' ),
('encounter','getConceptName(non_core_concept_id)', 'Encounter type'),
('encounter','age_at_event', 'Age at event'),
('encounter','admission_method', 'Admission method'),
('encounter','end_date', 'End date');
END //
DELIMITER ;