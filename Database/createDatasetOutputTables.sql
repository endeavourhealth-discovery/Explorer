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
('patient', 't.id', 'Patient ID'),
('patient', 't.person_id', 'Person ID'),
('patient', 'getCCGName(t.organization_id)', 'CCG'),
('patient', 'getOrganizationName(t.registered_practice_organization_id)', 'Registered practice'),
('patient', 't.title', 'Title'),
('patient', 't.first_names', 'First names'),
('patient', 't.last_name', 'Last name'),
('patient', 'getConceptName(t.gender_concept_id)', 'Gender'),
('patient', 't.nhs_number', 'NHS number'),
('patient', 't.date_of_birth', 'Date of birth'),
('patient', 't.date_of_death', 'Date of death'),
('patient', 'getCurrentAddress(t.current_address_id)', 'Current address'),
('patient', 'getConceptName(t.ethnic_code_concept_id)', 'Ethnicity'),
('observation','t.patient_id', 'Patient ID'),
('observation','t.person_id', 'Person ID'),
('observation','getCCGName(t.organization_id)', 'CCG'),
('observation','getOrganizationName(t.organization_id)', 'Organization'),
('observation','getPatientName(t.patient_id)', 'Patient'),
('observation','getPractitionerName(t.practitioner_id)', 'Practitioner'),
('observation','t.clinical_effective_date', 'Effective date'), 
('observation','getConceptName(t.non_core_concept_id)', 'Concept term'),
('observation','getConceptCode(t.non_core_concept_id)', 'Concept code'),
('observation','t.result_value', 'Result value'),
('observation','t.result_value_units', 'Result units'),
('observation','t.result_date', 'Result date'),
('observation','t.result_text', 'Result text'),
('observation','getConceptName(t.result_concept_id)', 'Result concept'),
('observation','t.is_problem',  'Is problem'),
('observation','t.is_review', 'Is review'),
('observation','t.problem_end_date', 'Problem end date'),
('observation','t.age_at_event', 'Age at event'),
('observation','getConceptName(t.episodicity_concept_id)', 'Episode'),
('observation','t.is_primary', 'Is primary'),
('medication_statement','t.patient_id', 'Patient ID'),
('medication_statement','t.person_id', 'Person ID'),
('medication_statement','getCCGName(t.organization_id)', 'CCG'),
('medication_statement','getOrganizationName(t.organization_id)', 'Organization'),
('medication_statement','getPatientName(t.patient_id)', 'Patient'),
('medication_statement','getPractitionerName(t.practitioner_id)', 'Practitioner'),
('medication_statement','t.clinical_effective_date', 'Effective date'), 
('medication_statement','t.cancellation_date', 'Cancellation date'),
('medication_statement','t.dose', 'Dose'),
('medication_statement','t.quantity_value', 'Quantity value'),
('medication_statement','t.quantity_unit', 'Quantity unit'),
('medication_statement','getConceptName(t.authorisation_type_concept_id)', 'Authorisation type'),
('medication_statement','getConceptName(t.non_core_concept_id)', 'Drug name'),
('medication_statement','getConceptCode(t.non_core_concept_id)', 'Drug code'),
('medication_statement','t.bnf_reference', 'BNF reference'),
('medication_statement','t.age_at_event', 'Age at event'),
('medication_statement','getLastMedicationIssueDate(t.id, t.patient_id)', 'Last issue date'),
('medication_statement','t.issue_method', 'Issue method'),
('encounter','t.patient_id', 'Patient ID'),
('encounter','t.person_id', 'Person ID'),
('encounter','getCCGName(t.organization_id)', 'CCG'),
('encounter','getOrganizationName(t.organization_id)', 'Oragnization'),
('encounter','getPatientName(t.patient_id)', 'Patient'),
('encounter','getPractitionerName(t.practitioner_id)', 'Practitioner'),
('encounter','t.clinical_effective_date', 'Effective date' ),
('encounter','getConceptName(t.non_core_concept_id)', 'Encounter type'),
('encounter','t.age_at_event', 'Age at event'),
('encounter','t.admission_method', 'Admission method'),
('encounter','t.end_date', 'End date');
END //
DELIMITER ;