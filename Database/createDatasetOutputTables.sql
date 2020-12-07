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
('patient', 'p.ccg', 'CCG'),
('patient', 'p.registered_practice', 'Registered practice'),
('patient', 't.title', 'Title'),
('patient', 't.first_names', 'First names'),
('patient', 't.last_name', 'Last name'),
('patient', 'p.gender', 'Gender'),
('patient', 't.nhs_number', 'NHS number'),
('patient', 't.date_of_birth', 'Date of birth'),
('patient', 't.date_of_death', 'Date of death'),
('patient', 'p.current_address', 'Current address'),
('patient', 'p.ethnicity', 'Ethnicity'),
('patient','p.lsoa_code', 'LSOA code'),
('observation','t.patient_id', 'Patient ID'),
('observation','t.person_id', 'Person ID'),
('observation','p.ccg', 'CCG'),
('observation','p.organization', 'Organization'),
('observation','p.patient_name', 'Patient'),
('observation','prac.name', 'Practitioner'),
('observation','t.clinical_effective_date', 'Effective date'), 
('observation','cpt.name', 'Concept term'),
('observation','cpt.code', 'Concept code'),
('observation','t.result_value', 'Result value'),
('observation','t.result_value_units', 'Result units'),
('observation','t.result_date', 'Result date'),
('observation','t.result_text', 'Result text'),
('observation','cpt2.name', 'Result concept'),
('observation','t.is_problem',  'Is problem'),
('observation','t.is_review', 'Is review'),
('observation','t.problem_end_date', 'Problem end date'),
('observation','t.age_at_event', 'Age at event'),
('observation','cpt3.name', 'Episode'),
('observation','t.is_primary', 'Is primary'),
('observation','procedure_request_status', 'Procedure request status'),
('observation','referral_requester_organisation', 'Referral requester organisation'),
('observation','referral_recipient_organisation', 'Referral recipient organisation'),
('observation','referral_request_priority', 'Referral request priority'),
('observation','referral_request_type', 'Referral request type'),
('observation','referral_mode', 'Referral mode'),
('observation','referral_outgoing_status', 'Referral outgoing status'),
('observation','warning_flag_status', 'Warning flag status'),
('observation','warning_flag_text', 'Warning flag text'),
('medication_statement','t.patient_id', 'Patient ID'),
('medication_statement','t.person_id', 'Person ID'),
('medication_statement','p.ccg', 'CCG'),
('medication_statement','p.organization', 'Organization'),
('medication_statement','p.patient_name', 'Patient'),
('medication_statement','prac.name', 'Practitioner'),
('medication_statement','t.clinical_effective_date', 'Effective date'), 
('medication_statement','t.cancellation_date', 'Cancellation date'),
('medication_statement','t.dose', 'Dose'),
('medication_statement','t.quantity_value', 'Quantity value'),
('medication_statement','t.quantity_unit', 'Quantity unit'),
('medication_statement','cpt4.name', 'Authorisation type'),
('medication_statement','cpt.name', 'Drug name'),
('medication_statement','cpt.code', 'Drug code'),
('medication_statement','t.bnf_reference', 'BNF reference'),
('medication_statement','t.age_at_event', 'Age at event'),
('medication_statement','mo.clinical_effective_date', 'Last issue date'),
('medication_statement','t.issue_method', 'Issue method'),
('encounter','t.patient_id', 'Patient ID'),
('encounter','t.person_id', 'Person ID'),
('encounter','p.ccg', 'CCG'),
('encounter','p.organization', 'Oragnization'),
('encounter','p.patient_name', 'Patient'),
('encounter','prac.name', 'Practitioner'),
('encounter','t.clinical_effective_date', 'Effective date' ),
('encounter','cpt.name', 'Encounter type'),
('encounter','t.age_at_event', 'Age at event'),
('encounter','t.admission_method', 'Admission method'),
('encounter','t.end_date', 'End date');
END //
DELIMITER ;