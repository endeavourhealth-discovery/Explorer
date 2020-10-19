USE dashboards;


DROP PROCEDURE IF EXISTS createClinicalTypesTable;

DELIMITER //

CREATE PROCEDURE createClinicalTypesTable()

BEGIN

DROP TABLE IF EXISTS clinical_code_types;

CREATE TABLE clinical_code_types (
   local_code VARCHAR(50),
   read_code  VARCHAR(50),
   read_term  VARCHAR(300),
   snomed_concept_id  VARCHAR(50),
   snomed_term  VARCHAR(300),
   code_type  VARCHAR(255)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

ALTER TABLE clinical_code_types ADD INDEX snomed_concept_idx(snomed_concept_id);
ALTER TABLE clinical_code_types ADD INDEX code_type_idx(code_type);

/* 

load data infile 'C:\\emis_clinical_codes.csv'
into table clinical_code_types
fields terminated by ','
optionally enclosed by '"'
escaped by '"'
lines terminated by '\r\n'
ignore 1 lines;

*/


END //
DELIMITER ;