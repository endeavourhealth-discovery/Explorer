CREATE DEFINER=`darren`@`%` PROCEDURE `covid_dashboards_summary`(IN consultations INT)
BEGIN

-- covid vaccinations
DROP TABLE IF EXISTS dashboards.covid_results_1;
CREATE TABLE dashboards.covid_results_1 (
  stp varchar(255) DEFAULT NULL,
  ccg varchar(255) DEFAULT NULL,
  pcn varchar(255) DEFAULT NULL,
  practice varchar(255) DEFAULT NULL,stp_ods_code varchar(45) DEFAULT NULL,ccg_ods_code varchar(45) DEFAULT NULL,practice_ods_code varchar(45) DEFAULT NULL,
  name varchar(255) DEFAULT NULL,
  ethnic varchar(100) DEFAULT NULL,
  age varchar(30) DEFAULT NULL,
  sex varchar(30) DEFAULT NULL,
  series_name varchar(100) DEFAULT NULL,
  series_value int(11) DEFAULT NULL,
  id bigint(20) auto_increment NOT NULL,
  PRIMARY KEY (id),
  KEY stp (stp),
  KEY ccg (ccg),
  KEY pcn (pcn),
  KEY practice (practice),KEY stp_ods_code (stp_ods_code),KEY ccg_ods_code (ccg_ods_code),KEY practice_ods_code (practice_ods_code),
  KEY name (name),KEY ethnic (ethnic),KEY age (age),KEY sex (sex),
  KEY series_name (series_name)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
insert into dashboards.covid_results_1 (stp,ccg,pcn,practice,stp_ods_code,ccg_ods_code,practice_ods_code,name,ethnic,age,sex,series_name,series_value)
SELECT 'North East London STP' as stp,org2.name as ccg,po.pcn,org.name as practice,'NEL' as stp_ods_code,org2.ods_code as ccg_ods_code,org.ods_code as practice_ods_code,c.original_term,el.ethnic_group as ethnic,
CASE WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) IS NULL THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 0 AND 4 THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 5 AND 9 THEN '5-9' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 10 AND 14 THEN '10-14' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 15 AND 19 THEN '15-19' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 20 AND 24 THEN '20-24' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 25 AND 29 THEN '25-29' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 30 AND 34 THEN '30-34' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 35 AND 39 THEN '35-39' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 40 AND 44 THEN '40-44' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 45 AND 49 THEN '45-49' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 50 AND 54 THEN '50-54' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 55 AND 59 THEN '55-59' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 60 AND 64 THEN '60-64' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 65 AND 69 THEN '65-69' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 70 AND 74 THEN '70-74' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 75 AND 79 THEN '75-79' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 80 AND 84 THEN '80-84' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 85 AND 89 THEN '85-89' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 90 AND 94 THEN '90-94' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 95 AND 99 THEN '95-99' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) > 99 THEN '>100' END as age,
cg.name as sex,
clinical_effective_date,count(distinct(o.patient_id)) 
FROM observation o
join patient p on p.id = o.patient_id
join organization org on org.id = p.organization_id
left join organization org2 on org2.id = org.parent_organization_id
left join pcn_ods po on po.ods_code = org.ods_code
join concept co on co.dbid = o.non_core_concept_id
join corona_terms c on c.original_code = co.id
left join concept ce on ce.dbid = p.ethnic_code_concept_id
left join ethnicity_lookup el on el.ethnic_name = ce.name
left join concept cg on cg.dbid = p.gender_concept_id
where o.clinical_effective_date > '20201201'
and corona_status in ('COVID-19 vaccination')
group by stp,org2.name,pcn,org.name,c.original_term,el.ethnic_group,
CASE WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) IS NULL THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 0 AND 4 THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 5 AND 9 THEN '5-9' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 10 AND 14 THEN '10-14' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 15 AND 19 THEN '15-19' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 20 AND 24 THEN '20-24' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 25 AND 29 THEN '25-29' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 30 AND 34 THEN '30-34' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 35 AND 39 THEN '35-39' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 40 AND 44 THEN '40-44' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 45 AND 49 THEN '45-49' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 50 AND 54 THEN '50-54' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 55 AND 59 THEN '55-59' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 60 AND 64 THEN '60-64' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 65 AND 69 THEN '65-69' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 70 AND 74 THEN '70-74' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 75 AND 79 THEN '75-79' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 80 AND 84 THEN '80-84' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 85 AND 89 THEN '85-89' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 90 AND 94 THEN '90-94' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 95 AND 99 THEN '95-99' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) > 99 THEN '>100' END,
cg.name,clinical_effective_date
order by clinical_effective_date;

insert into dashboards.covid_results_1 (stp,ccg,pcn,practice,stp_ods_code,ccg_ods_code,practice_ods_code,name,ethnic,age,sex,series_name,series_value)
SELECT 'North East London STP' as stp,org2.name as ccg,po.pcn,org.name as practice,'NEL' as stp_ods_code,org2.ods_code as ccg_ods_code,org.ods_code as practice_ods_code,c.original_term,el.ethnic_group as ethnic,
CASE WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) IS NULL THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 0 AND 4 THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 5 AND 9 THEN '5-9' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 10 AND 14 THEN '10-14' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 15 AND 19 THEN '15-19' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 20 AND 24 THEN '20-24' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 25 AND 29 THEN '25-29' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 30 AND 34 THEN '30-34' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 35 AND 39 THEN '35-39' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 40 AND 44 THEN '40-44' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 45 AND 49 THEN '45-49' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 50 AND 54 THEN '50-54' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 55 AND 59 THEN '55-59' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 60 AND 64 THEN '60-64' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 65 AND 69 THEN '65-69' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 70 AND 74 THEN '70-74' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 75 AND 79 THEN '75-79' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 80 AND 84 THEN '80-84' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 85 AND 89 THEN '85-89' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 90 AND 94 THEN '90-94' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 95 AND 99 THEN '95-99' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) > 99 THEN '>100' END as age,
cg.name as sex,
clinical_effective_date,count(distinct(o.patient_id)) 
FROM medication_statement o
join patient p on p.id = o.patient_id
join organization org on org.id = p.organization_id
left join organization org2 on org2.id = org.parent_organization_id
left join pcn_ods po on po.ods_code = org.ods_code
join concept co on co.dbid = o.non_core_concept_id
join corona_terms c on c.original_code = co.id
left join concept ce on ce.dbid = p.ethnic_code_concept_id
left join ethnicity_lookup el on el.ethnic_name = ce.name
left join concept cg on cg.dbid = p.gender_concept_id
where o.clinical_effective_date > '20201201'
and corona_status in ('COVID-19 vaccination')
group by stp,org2.name,pcn,org.name,c.original_term,el.ethnic_group,
CASE WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) IS NULL THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 0 AND 4 THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 5 AND 9 THEN '5-9' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 10 AND 14 THEN '10-14' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 15 AND 19 THEN '15-19' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 20 AND 24 THEN '20-24' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 25 AND 29 THEN '25-29' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 30 AND 34 THEN '30-34' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 35 AND 39 THEN '35-39' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 40 AND 44 THEN '40-44' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 45 AND 49 THEN '45-49' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 50 AND 54 THEN '50-54' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 55 AND 59 THEN '55-59' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 60 AND 64 THEN '60-64' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 65 AND 69 THEN '65-69' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 70 AND 74 THEN '70-74' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 75 AND 79 THEN '75-79' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 80 AND 84 THEN '80-84' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 85 AND 89 THEN '85-89' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 90 AND 94 THEN '90-94' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 95 AND 99 THEN '95-99' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) > 99 THEN '>100' END,
cg.name,clinical_effective_date
order by clinical_effective_date;

-- confirmed, suspected, tested covid
DROP TABLE IF EXISTS dashboards.covid_results_2;
CREATE TABLE dashboards.covid_results_2 (
  stp varchar(255) DEFAULT NULL,
  ccg varchar(255) DEFAULT NULL,
  pcn varchar(255) DEFAULT NULL,
  practice varchar(255) DEFAULT NULL,stp_ods_code varchar(45) DEFAULT NULL,ccg_ods_code varchar(45) DEFAULT NULL,practice_ods_code varchar(45) DEFAULT NULL,
  name varchar(255) DEFAULT NULL,
  ethnic varchar(100) DEFAULT NULL,
  age varchar(30) DEFAULT NULL,
  sex varchar(30) DEFAULT NULL,
  series_name varchar(100) DEFAULT NULL,
  series_value int(11) DEFAULT NULL,
  id bigint(20) auto_increment NOT NULL,
  PRIMARY KEY (id),
  KEY stp (stp),
  KEY ccg (ccg),
  KEY pcn (pcn),
  KEY practice (practice),KEY stp_ods_code (stp_ods_code),KEY ccg_ods_code (ccg_ods_code),KEY practice_ods_code (practice_ods_code),
  KEY name (name),KEY ethnic (ethnic),KEY age (age),KEY sex (sex),
  KEY series_name (series_name)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
insert into dashboards.covid_results_2 (stp,ccg,pcn,practice,stp_ods_code,ccg_ods_code,practice_ods_code,name,ethnic,age,sex,series_name,series_value)
SELECT 'North East London STP' as stp,org2.name as ccg,po.pcn,org.name as practice,'NEL' as stp_ods_code,org2.ods_code as ccg_ods_code,org.ods_code as practice_ods_code,corona_status,el.ethnic_group as ethnic,
CASE WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) IS NULL THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 0 AND 4 THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 5 AND 9 THEN '5-9' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 10 AND 14 THEN '10-14' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 15 AND 19 THEN '15-19' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 20 AND 24 THEN '20-24' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 25 AND 29 THEN '25-29' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 30 AND 34 THEN '30-34' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 35 AND 39 THEN '35-39' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 40 AND 44 THEN '40-44' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 45 AND 49 THEN '45-49' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 50 AND 54 THEN '50-54' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 55 AND 59 THEN '55-59' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 60 AND 64 THEN '60-64' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 65 AND 69 THEN '65-69' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 70 AND 74 THEN '70-74' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 75 AND 79 THEN '75-79' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 80 AND 84 THEN '80-84' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 85 AND 89 THEN '85-89' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 90 AND 94 THEN '90-94' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 95 AND 99 THEN '95-99' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) > 99 THEN '>100' END as age,
cg.name as sex,
clinical_effective_date,count(distinct(o.patient_id)) 
FROM observation o
join patient p on p.id = o.patient_id
join organization org on org.id = p.organization_id
left join organization org2 on org2.id = org.parent_organization_id
left join pcn_ods po on po.ods_code = org.ods_code
join concept co on co.dbid = o.non_core_concept_id
join corona_terms c on c.original_code = co.id
left join concept ce on ce.dbid = p.ethnic_code_concept_id
left join ethnicity_lookup el on el.ethnic_name = ce.name
left join concept cg on cg.dbid = p.gender_concept_id
where o.clinical_effective_date > '20200101'
and corona_status in ('Suspected coronavirus infection','Confirmed Covid 19','Tested for coronavirus infection')
group by stp,org2.name,pcn,org.name,corona_status,el.ethnic_group,
CASE WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) IS NULL THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 0 AND 4 THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 5 AND 9 THEN '5-9' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 10 AND 14 THEN '10-14' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 15 AND 19 THEN '15-19' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 20 AND 24 THEN '20-24' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 25 AND 29 THEN '25-29' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 30 AND 34 THEN '30-34' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 35 AND 39 THEN '35-39' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 40 AND 44 THEN '40-44' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 45 AND 49 THEN '45-49' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 50 AND 54 THEN '50-54' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 55 AND 59 THEN '55-59' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 60 AND 64 THEN '60-64' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 65 AND 69 THEN '65-69' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 70 AND 74 THEN '70-74' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 75 AND 79 THEN '75-79' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 80 AND 84 THEN '80-84' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 85 AND 89 THEN '85-89' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 90 AND 94 THEN '90-94' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 95 AND 99 THEN '95-99' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) > 99 THEN '>100' END,
cg.name,clinical_effective_date
order by clinical_effective_date;

IF consultations = 1 THEN
-- gp consultations
DROP TABLE IF EXISTS dashboards.covid_results_3;
CREATE TABLE dashboards.covid_results_3 (
  stp varchar(255) DEFAULT NULL,
  ccg varchar(255) DEFAULT NULL,
  pcn varchar(255) DEFAULT NULL,
  practice varchar(255) DEFAULT NULL,stp_ods_code varchar(45) DEFAULT NULL,ccg_ods_code varchar(45) DEFAULT NULL,practice_ods_code varchar(45) DEFAULT NULL,
  name varchar(255) DEFAULT NULL,
  ethnic varchar(100) DEFAULT NULL,
  age varchar(30) DEFAULT NULL,
  sex varchar(30) DEFAULT NULL,
  series_name varchar(100) DEFAULT NULL,
  series_value int(11) DEFAULT NULL,
  id bigint(20) auto_increment NOT NULL,
  PRIMARY KEY (id),
  KEY stp (stp),
  KEY ccg (ccg),
  KEY pcn (pcn),
  KEY practice (practice),KEY stp_ods_code (stp_ods_code),KEY ccg_ods_code (ccg_ods_code),KEY practice_ods_code (practice_ods_code),
  KEY name (name),KEY ethnic (ethnic),KEY age (age),KEY sex (sex),
  KEY series_name (series_name)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
insert into dashboards.covid_results_3 (stp,ccg,pcn,practice,stp_ods_code,ccg_ods_code,practice_ods_code,name,ethnic,age,sex,series_name,series_value)
SELECT 'North East London STP' as stp,org2.name as ccg,po.pcn,org.name as practice,'NEL' as stp_ods_code,org2.ods_code as ccg_ods_code,org.ods_code as practice_ods_code,encounter_type,'All',
'All','All',
clinical_effective_date,count(o.clinical_effective_date) 
FROM encounter o
join patient p on p.id = o.patient_id
join organization org on org.id = p.organization_id
left join organization org2 on org2.id = org.parent_organization_id
left join pcn_ods po on po.ods_code = org.ods_code
join concept co on co.dbid = o.non_core_concept_id
join consultation_types c on c.original_code = co.id
where o.clinical_effective_date >= '20200101'
group by stp,org2.name,pcn,org.name,encounter_type,'All',
'All','All',o.clinical_effective_date
order by o.clinical_effective_date;

END IF;

-- deaths for confirmed, suspected covid
DROP TABLE IF EXISTS dashboards.covid_results_4;
CREATE TABLE dashboards.covid_results_4 (
  stp varchar(255) DEFAULT NULL,
  ccg varchar(255) DEFAULT NULL,
  pcn varchar(255) DEFAULT NULL,
  practice varchar(255) DEFAULT NULL,stp_ods_code varchar(45) DEFAULT NULL,ccg_ods_code varchar(45) DEFAULT NULL,practice_ods_code varchar(45) DEFAULT NULL,
  name varchar(255) DEFAULT NULL,
  ethnic varchar(100) DEFAULT NULL,
  age varchar(30) DEFAULT NULL,
  sex varchar(30) DEFAULT NULL,
  series_name varchar(100) DEFAULT NULL,
  series_value int(11) DEFAULT NULL,
  id bigint(20) auto_increment NOT NULL,
  PRIMARY KEY (id),
  KEY stp (stp),
  KEY ccg (ccg),
  KEY pcn (pcn),
  KEY practice (practice),KEY stp_ods_code (stp_ods_code),KEY ccg_ods_code (ccg_ods_code),KEY practice_ods_code (practice_ods_code),
  KEY name (name),KEY ethnic (ethnic),KEY age (age),KEY sex (sex),
  KEY series_name (series_name)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
insert into dashboards.covid_results_4 (stp,ccg,pcn,practice,stp_ods_code,ccg_ods_code,practice_ods_code,name,ethnic,age,sex,series_name,series_value)
SELECT 'North East London STP' as stp,org2.name as ccg,po.pcn,org.name as practice,'NEL' as stp_ods_code,org2.ods_code as ccg_ods_code,org.ods_code as practice_ods_code,'covid_death_daily',el.ethnic_group as ethnic,
CASE WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) IS NULL THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 0 AND 4 THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 5 AND 9 THEN '5-9' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 10 AND 14 THEN '10-14' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 15 AND 19 THEN '15-19' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 20 AND 24 THEN '20-24' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 25 AND 29 THEN '25-29' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 30 AND 34 THEN '30-34' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 35 AND 39 THEN '35-39' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 40 AND 44 THEN '40-44' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 45 AND 49 THEN '45-49' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 50 AND 54 THEN '50-54' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 55 AND 59 THEN '55-59' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 60 AND 64 THEN '60-64' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 65 AND 69 THEN '65-69' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 70 AND 74 THEN '70-74' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 75 AND 79 THEN '75-79' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 80 AND 84 THEN '80-84' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 85 AND 89 THEN '85-89' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 90 AND 94 THEN '90-94' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 95 AND 99 THEN '95-99' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) > 99 THEN '>100' END as age,
cg.name as sex,
date_of_death,count(distinct(o.patient_id)) 
FROM observation o
join patient p on p.id = o.patient_id
join organization org on org.id = p.organization_id
left join organization org2 on org2.id = org.parent_organization_id
left join pcn_ods po on po.ods_code = org.ods_code
join concept co on co.dbid = o.non_core_concept_id
join corona_terms c on c.original_code = co.id
left join concept ce on ce.dbid = p.ethnic_code_concept_id
left join ethnicity_lookup el on el.ethnic_name = ce.name
left join concept cg on cg.dbid = p.gender_concept_id
where o.clinical_effective_date > '20200101'
and corona_status in ('Suspected coronavirus infection','Confirmed Covid 19')
and p.date_of_death between o.clinical_effective_date and date_add(o.clinical_effective_date, interval 28 DAY) 
group by stp,org2.name,pcn,org.name,'covid_death_daily',el.ethnic_group,
CASE WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) IS NULL THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 0 AND 4 THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 5 AND 9 THEN '5-9' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 10 AND 14 THEN '10-14' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 15 AND 19 THEN '15-19' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 20 AND 24 THEN '20-24' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 25 AND 29 THEN '25-29' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 30 AND 34 THEN '30-34' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 35 AND 39 THEN '35-39' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 40 AND 44 THEN '40-44' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 45 AND 49 THEN '45-49' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 50 AND 54 THEN '50-54' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 55 AND 59 THEN '55-59' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 60 AND 64 THEN '60-64' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 65 AND 69 THEN '65-69' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 70 AND 74 THEN '70-74' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 75 AND 79 THEN '75-79' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 80 AND 84 THEN '80-84' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 85 AND 89 THEN '85-89' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 90 AND 94 THEN '90-94' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 95 AND 99 THEN '95-99' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) > 99 THEN '>100' END,
cg.name,date_of_death
order by date_of_death;

-- epinephrine_terms
DROP TABLE IF EXISTS dashboards.covid_results_5;
CREATE TABLE dashboards.covid_results_5 (
  stp varchar(255) DEFAULT NULL,
  ccg varchar(255) DEFAULT NULL,
  pcn varchar(255) DEFAULT NULL,
  practice varchar(255) DEFAULT NULL,stp_ods_code varchar(45) DEFAULT NULL,ccg_ods_code varchar(45) DEFAULT NULL,practice_ods_code varchar(45) DEFAULT NULL,
  name varchar(255) DEFAULT NULL,
  ethnic varchar(100) DEFAULT NULL,
  age varchar(30) DEFAULT NULL,
  sex varchar(30) DEFAULT NULL,
  series_name varchar(100) DEFAULT NULL,
  series_value int(11) DEFAULT NULL,
  id bigint(20) auto_increment NOT NULL,
  PRIMARY KEY (id),
  KEY stp (stp),
  KEY ccg (ccg),
  KEY pcn (pcn),
  KEY practice (practice),KEY stp_ods_code (stp_ods_code),KEY ccg_ods_code (ccg_ods_code),KEY practice_ods_code (practice_ods_code),
  KEY name (name),KEY ethnic (ethnic),KEY age (age),KEY sex (sex),
  KEY series_name (series_name)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
insert into dashboards.covid_results_5 (stp,ccg,pcn,practice,stp_ods_code,ccg_ods_code,practice_ods_code,name,ethnic,age,sex,series_name,series_value)
SELECT 'North East London STP' as stp,org2.name as ccg,po.pcn,org.name as practice,'NEL' as stp_ods_code,org2.ods_code as ccg_ods_code,org.ods_code as practice_ods_code,corona_status,el.ethnic_group as ethnic,
CASE WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) IS NULL THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 0 AND 4 THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 5 AND 9 THEN '5-9' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 10 AND 14 THEN '10-14' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 15 AND 19 THEN '15-19' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 20 AND 24 THEN '20-24' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 25 AND 29 THEN '25-29' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 30 AND 34 THEN '30-34' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 35 AND 39 THEN '35-39' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 40 AND 44 THEN '40-44' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 45 AND 49 THEN '45-49' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 50 AND 54 THEN '50-54' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 55 AND 59 THEN '55-59' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 60 AND 64 THEN '60-64' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 65 AND 69 THEN '65-69' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 70 AND 74 THEN '70-74' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 75 AND 79 THEN '75-79' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 80 AND 84 THEN '80-84' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 85 AND 89 THEN '85-89' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 90 AND 94 THEN '90-94' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 95 AND 99 THEN '95-99' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) > 99 THEN '>100' END as age,
cg.name as sex,
clinical_effective_date,count(distinct(o.patient_id)) 
FROM medication_statement o
join patient p on p.id = o.patient_id
join organization org on org.id = p.organization_id
left join organization org2 on org2.id = org.parent_organization_id
left join pcn_ods po on po.ods_code = org.ods_code
join concept co on co.dbid = o.non_core_concept_id
join epinephrine_terms c on c.original_code = co.id
left join concept ce on ce.dbid = p.ethnic_code_concept_id
left join ethnicity_lookup el on el.ethnic_name = ce.name
left join concept cg on cg.dbid = p.gender_concept_id
where o.clinical_effective_date > '20200101'
group by stp,org2.name,pcn,org.name,corona_status,el.ethnic_group,
CASE WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) IS NULL THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 0 AND 4 THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 5 AND 9 THEN '5-9' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 10 AND 14 THEN '10-14' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 15 AND 19 THEN '15-19' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 20 AND 24 THEN '20-24' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 25 AND 29 THEN '25-29' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 30 AND 34 THEN '30-34' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 35 AND 39 THEN '35-39' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 40 AND 44 THEN '40-44' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 45 AND 49 THEN '45-49' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 50 AND 54 THEN '50-54' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 55 AND 59 THEN '55-59' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 60 AND 64 THEN '60-64' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 65 AND 69 THEN '65-69' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 70 AND 74 THEN '70-74' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 75 AND 79 THEN '75-79' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 80 AND 84 THEN '80-84' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 85 AND 89 THEN '85-89' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 90 AND 94 THEN '90-94' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 95 AND 99 THEN '95-99' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) > 99 THEN '>100' END,
cg.name,clinical_effective_date
order by clinical_effective_date;

-- NHS111
DROP TABLE IF EXISTS dashboards.covid_results_6;
CREATE TABLE dashboards.covid_results_6 (
  stp varchar(255) DEFAULT NULL,
  ccg varchar(255) DEFAULT NULL,
  pcn varchar(255) DEFAULT NULL,
  practice varchar(255) DEFAULT NULL,stp_ods_code varchar(45) DEFAULT NULL,ccg_ods_code varchar(45) DEFAULT NULL,practice_ods_code varchar(45) DEFAULT NULL,
  name varchar(255) DEFAULT NULL,
  ethnic varchar(100) DEFAULT NULL,
  age varchar(30) DEFAULT NULL,
  sex varchar(30) DEFAULT NULL,
  series_name varchar(100) DEFAULT NULL,
  series_value int(11) DEFAULT NULL,
  id bigint(20) auto_increment NOT NULL,
  PRIMARY KEY (id),
  KEY stp (stp),
  KEY ccg (ccg),
  KEY pcn (pcn),
  KEY practice (practice),KEY stp_ods_code (stp_ods_code),KEY ccg_ods_code (ccg_ods_code),KEY practice_ods_code (practice_ods_code),
  KEY name (name),KEY ethnic (ethnic),KEY age (age),KEY sex (sex),
  KEY series_name (series_name)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
insert into dashboards.covid_results_6 (stp,ccg,pcn,practice,stp_ods_code,ccg_ods_code,practice_ods_code,name,ethnic,age,sex,series_name,series_value)
SELECT 'North East London STP' as stp,'NEL NHS111' as ccg,'NEL NHS111' as pcn,org.name as practice,'NEL' as stp_ods_code,'RRU' as ccg_ods_code,'RRU' as practice_ods_code,c.name,el.ethnic_group as ethnic,
CASE WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) IS NULL THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 0 AND 4 THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 5 AND 9 THEN '5-9' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 10 AND 14 THEN '10-14' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 15 AND 19 THEN '15-19' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 20 AND 24 THEN '20-24' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 25 AND 29 THEN '25-29' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 30 AND 34 THEN '30-34' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 35 AND 39 THEN '35-39' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 40 AND 44 THEN '40-44' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 45 AND 49 THEN '45-49' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 50 AND 54 THEN '50-54' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 55 AND 59 THEN '55-59' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 60 AND 64 THEN '60-64' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 65 AND 69 THEN '65-69' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 70 AND 74 THEN '70-74' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 75 AND 79 THEN '75-79' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 80 AND 84 THEN '80-84' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 85 AND 89 THEN '85-89' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 90 AND 94 THEN '90-94' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 95 AND 99 THEN '95-99' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) > 99 THEN '>100' END as age,
cg.name as sex,
e.clinical_effective_date,count(distinct(o.patient_id)) 
FROM internal_nel_unscheduled_pid.encounter e
join internal_nel_unscheduled_pid.patient p on p.id = e.patient_id
join internal_nel_unscheduled_pid.observation o on (o.patient_id = p.id and o.encounter_id = e.id)
join internal_nel_unscheduled_pid.organization org on org.id = p.organization_id
join internal_nel_gp_pid.concept c on c.dbid = o.non_core_concept_id
left join internal_nel_gp_pid.concept ce on ce.dbid = p.ethnic_code_concept_id
left join internal_nel_gp_pid.ethnicity_lookup el on el.ethnic_name = ce.name
left join internal_nel_gp_pid.concept cg on cg.dbid = p.gender_concept_id
where e.clinical_effective_date > '20170901'
and org.ods_code = 'RRU'
and o.non_core_concept_id in (1111272,1111604,1414813,1418784) -- ('[D]Cough','[D]Fever NOS')
group by stp,'NEL NHS111','NEL NHS111',org.name,c.name,el.ethnic_group,
CASE WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) IS NULL THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 0 AND 4 THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 5 AND 9 THEN '5-9' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 10 AND 14 THEN '10-14' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 15 AND 19 THEN '15-19' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 20 AND 24 THEN '20-24' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 25 AND 29 THEN '25-29' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 30 AND 34 THEN '30-34' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 35 AND 39 THEN '35-39' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 40 AND 44 THEN '40-44' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 45 AND 49 THEN '45-49' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 50 AND 54 THEN '50-54' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 55 AND 59 THEN '55-59' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 60 AND 64 THEN '60-64' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 65 AND 69 THEN '65-69' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 70 AND 74 THEN '70-74' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 75 AND 79 THEN '75-79' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 80 AND 84 THEN '80-84' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 85 AND 89 THEN '85-89' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 90 AND 94 THEN '90-94' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 95 AND 99 THEN '95-99' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) > 99 THEN '>100' END,
cg.name,e.clinical_effective_date
order by e.clinical_effective_date;

-- ADT
DROP TABLE IF EXISTS dashboards.covid_results_7;
CREATE TABLE dashboards.covid_results_7 (
  stp varchar(255) DEFAULT NULL,
  ccg varchar(255) DEFAULT NULL,
  pcn varchar(255) DEFAULT NULL,
  practice varchar(255) DEFAULT NULL,stp_ods_code varchar(45) DEFAULT NULL,ccg_ods_code varchar(45) DEFAULT NULL,practice_ods_code varchar(45) DEFAULT NULL,
  name varchar(255) DEFAULT NULL,
  ethnic varchar(100) DEFAULT NULL,
  age varchar(30) DEFAULT NULL,
  sex varchar(30) DEFAULT NULL,
  series_name varchar(100) DEFAULT NULL,
  series_value int(11) DEFAULT NULL,
  id bigint(20) auto_increment NOT NULL,
  PRIMARY KEY (id),
  KEY stp (stp),
  KEY ccg (ccg),
  KEY pcn (pcn),
  KEY practice (practice),KEY stp_ods_code (stp_ods_code),KEY ccg_ods_code (ccg_ods_code),KEY practice_ods_code (practice_ods_code),
  KEY name (name),KEY ethnic (ethnic),KEY age (age),KEY sex (sex),
  KEY series_name (series_name)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
insert into dashboards.covid_results_7 (stp,ccg,pcn,practice,stp_ods_code,ccg_ods_code,practice_ods_code,name,ethnic,age,sex,series_name,series_value)
SELECT 'North East London STP' as stp,org.name as ccg,org.name as pcn,org.name as practice,'NEL' as stp_ods_code,org.ods_code as ccg_ods_code,org.ods_code as practice_ods_code,el.name,el.ethnic_group as ethnic,
CASE WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) IS NULL THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 0 AND 4 THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 5 AND 9 THEN '5-9' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 10 AND 14 THEN '10-14' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 15 AND 19 THEN '15-19' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 20 AND 24 THEN '20-24' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 25 AND 29 THEN '25-29' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 30 AND 34 THEN '30-34' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 35 AND 39 THEN '35-39' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 40 AND 44 THEN '40-44' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 45 AND 49 THEN '45-49' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 50 AND 54 THEN '50-54' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 55 AND 59 THEN '55-59' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 60 AND 64 THEN '60-64' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 65 AND 69 THEN '65-69' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 70 AND 74 THEN '70-74' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 75 AND 79 THEN '75-79' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 80 AND 84 THEN '80-84' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 85 AND 89 THEN '85-89' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 90 AND 94 THEN '90-94' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 95 AND 99 THEN '95-99' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) > 99 THEN '>100' END as age,
cg.name as sex,
DATE_FORMAT(ee.clinical_effective_date, '%Y-%m-%d'),count(distinct(p.id)) 
FROM internal_nel_secondary_pid.patient p
join internal_nel_secondary_pid.organization org on org.id = p.organization_id
join internal_nel_secondary_pid.encounter_event ee on ee.patient_id = p.id
join internal_nel_gp_pid.concept c on c.dbid = ee.non_core_concept_id
join internal_nel_secondary_pid.encounter_lookup el on el.original_code = c.id
left join internal_nel_gp_pid.concept ce on ce.dbid = p.ethnic_code_concept_id
left join internal_nel_gp_pid.ethnicity_lookup el on el.ethnic_name = ce.name
left join internal_nel_gp_pid.concept cg on cg.dbid = p.gender_concept_id
where ee.clinical_effective_date >= '2020-01-01'
group by stp,org.name,org.name,org.name,el.name,el.ethnic_group,
CASE WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) IS NULL THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 0 AND 4 THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 5 AND 9 THEN '5-9' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 10 AND 14 THEN '10-14' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 15 AND 19 THEN '15-19' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 20 AND 24 THEN '20-24' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 25 AND 29 THEN '25-29' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 30 AND 34 THEN '30-34' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 35 AND 39 THEN '35-39' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 40 AND 44 THEN '40-44' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 45 AND 49 THEN '45-49' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 50 AND 54 THEN '50-54' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 55 AND 59 THEN '55-59' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 60 AND 64 THEN '60-64' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 65 AND 69 THEN '65-69' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 70 AND 74 THEN '70-74' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 75 AND 79 THEN '75-79' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 80 AND 84 THEN '80-84' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 85 AND 89 THEN '85-89' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 90 AND 94 THEN '90-94' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 95 AND 99 THEN '95-99' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) > 99 THEN '>100' END,
cg.name,DATE_FORMAT(ee.clinical_effective_date, '%Y-%m-%d')
order by DATE_FORMAT(ee.clinical_effective_date, '%Y-%m-%d');

-- covid/hospitals
drop table if exists dashboards.temp_observations;
create table dashboards.temp_observations
select o.person_id,o.clinical_effective_date
from internal_nel_gp_pid.observation o
join internal_nel_gp_pid.concept co on co.dbid = o.non_core_concept_id
join internal_nel_gp_pid.corona_terms c on c.original_code = co.id
where c.corona_status in ('Suspected coronavirus infection','Confirmed Covid 19');

ALTER TABLE `dashboards`.`temp_observations` 
ADD INDEX `person_id` (`person_id` ASC),
ADD INDEX `clinical_date` (`clinical_effective_date` ASC);

DROP TABLE IF EXISTS dashboards.covid_results_8;
CREATE TABLE dashboards.covid_results_8 (
  stp varchar(255) DEFAULT NULL,
  ccg varchar(255) DEFAULT NULL,
  pcn varchar(255) DEFAULT NULL,
  practice varchar(255) DEFAULT NULL,stp_ods_code varchar(45) DEFAULT NULL,ccg_ods_code varchar(45) DEFAULT NULL,practice_ods_code varchar(45) DEFAULT NULL,
  name varchar(255) DEFAULT NULL,
  ethnic varchar(100) DEFAULT NULL,
  age varchar(30) DEFAULT NULL,
  sex varchar(30) DEFAULT NULL,
  series_name varchar(100) DEFAULT NULL,
  series_value int(11) DEFAULT NULL,
  id bigint(20) auto_increment NOT NULL,
  PRIMARY KEY (id),
  KEY stp (stp),
  KEY ccg (ccg),
  KEY pcn (pcn),
  KEY practice (practice),KEY stp_ods_code (stp_ods_code),KEY ccg_ods_code (ccg_ods_code),KEY practice_ods_code (practice_ods_code),
  KEY name (name),KEY ethnic (ethnic),KEY age (age),KEY sex (sex),
  KEY series_name (series_name)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
insert into dashboards.covid_results_8 (stp,ccg,pcn,practice,stp_ods_code,ccg_ods_code,practice_ods_code,name,ethnic,age,sex,series_name,series_value)
SELECT 'North East London STP' as stp,org.name as ccg,org.name as pcn,org.name as practice,'NEL' as stp_ods_code,org.ods_code as ccg_ods_code,org.ods_code as practice_ods_code,concat(el.name,' for Covid'),el.ethnic_group as ethnic,
CASE WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) IS NULL THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 0 AND 4 THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 5 AND 9 THEN '5-9' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 10 AND 14 THEN '10-14' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 15 AND 19 THEN '15-19' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 20 AND 24 THEN '20-24' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 25 AND 29 THEN '25-29' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 30 AND 34 THEN '30-34' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 35 AND 39 THEN '35-39' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 40 AND 44 THEN '40-44' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 45 AND 49 THEN '45-49' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 50 AND 54 THEN '50-54' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 55 AND 59 THEN '55-59' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 60 AND 64 THEN '60-64' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 65 AND 69 THEN '65-69' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 70 AND 74 THEN '70-74' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 75 AND 79 THEN '75-79' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 80 AND 84 THEN '80-84' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 85 AND 89 THEN '85-89' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 90 AND 94 THEN '90-94' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 95 AND 99 THEN '95-99' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) > 99 THEN '>100' END as age,
cg.name as sex,
DATE_FORMAT(ee.clinical_effective_date, '%Y-%m-%d'),count(distinct(p.person_id)) 
FROM internal_nel_secondary_pid.patient p
join internal_nel_secondary_pid.organization org on org.id = p.organization_id
join internal_nel_secondary_pid.encounter_event ee on ee.patient_id = p.id
join internal_nel_gp_pid.concept c on c.dbid = ee.non_core_concept_id
join internal_nel_secondary_pid.encounter_lookup el on el.original_code = c.id
left join internal_nel_gp_pid.concept ce on ce.dbid = p.ethnic_code_concept_id
left join internal_nel_gp_pid.ethnicity_lookup el on el.ethnic_name = ce.name
left join internal_nel_gp_pid.concept cg on cg.dbid = p.gender_concept_id
join dashboards.temp_observations o on o.person_id = p.person_id
where ee.clinical_effective_date >= '2020-01-01'
and el.name in ('A&E attendance','Hospital inpatient admission')
and ((ee.clinical_effective_date <= o.clinical_effective_date and 
DATE(o.clinical_effective_date - INTERVAL 14 DAY) <= o.clinical_effective_date)
or
(o.clinical_effective_date <= ee.clinical_effective_date and 
DATE(o.clinical_effective_date + INTERVAL 14 DAY) >= ee.clinical_effective_date))
group by stp,org.name,org.name,org.name,el.name,el.ethnic_group,
CASE WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) IS NULL THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 0 AND 4 THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 5 AND 9 THEN '5-9' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 10 AND 14 THEN '10-14' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 15 AND 19 THEN '15-19' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 20 AND 24 THEN '20-24' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 25 AND 29 THEN '25-29' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 30 AND 34 THEN '30-34' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 35 AND 39 THEN '35-39' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 40 AND 44 THEN '40-44' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 45 AND 49 THEN '45-49' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 50 AND 54 THEN '50-54' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 55 AND 59 THEN '55-59' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 60 AND 64 THEN '60-64' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 65 AND 69 THEN '65-69' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 70 AND 74 THEN '70-74' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 75 AND 79 THEN '75-79' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 80 AND 84 THEN '80-84' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 85 AND 89 THEN '85-89' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 90 AND 94 THEN '90-94' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 95 AND 99 THEN '95-99' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) > 99 THEN '>100' END,
cg.name,DATE_FORMAT(ee.clinical_effective_date, '%Y-%m-%d')
order by DATE_FORMAT(ee.clinical_effective_date, '%Y-%m-%d');

DROP TABLE if exists dashboards.lsoa_covid;
create table dashboards.lsoa_covid as
select 
org2.name as ccg,o.person_id,o.clinical_effective_date as covid_date,
c.corona_status,0 as uprn,0 as latitude,0 as longitude,lsoa_2011_code as lsoa_code,0 as xcoordinate,0 as ycoordinate
FROM observation o
join patient p on p.id = o.patient_id
join organization org on org.id = p.organization_id
left join organization org2 on org2.id = org.parent_organization_id
join concept co on co.dbid = o.non_core_concept_id
join corona_terms c on c.original_code = co.id
join patient_address a on a.id = p.current_address_id
where o.clinical_effective_date >= DATE(NOW() - INTERVAL 30 DAY)
and c.corona_status in ('Suspected coronavirus infection','Confirmed Covid 19')
group by o.person_id, c.corona_status
order by ccg,lsoa_2011_code,c.corona_status;

DROP TABLE if exists dashboards.lsoa_covid_shielded;
create table dashboards.lsoa_covid_shielded as
select 
org2.name as ccg,o.person_id,o.clinical_effective_date as covid_date,
c.corona_status,0 as uprn,0 as latitude,0 as longitude,lsoa_2011_code as lsoa_code,0 as xcoordinate,0 as ycoordinate
FROM observation o
join patient p on p.id = o.patient_id
join organization org on org.id = p.organization_id
left join organization org2 on org2.id = org.parent_organization_id
join concept co on co.dbid = o.non_core_concept_id
join corona_terms c on c.original_code = co.id
join patient_address a on a.id = p.current_address_id
where o.clinical_effective_date >= DATE(NOW() - INTERVAL 30 DAY)
and c.corona_status like 'Recorded as%'
group by o.person_id, c.corona_status
order by ccg,lsoa_2011_code,c.corona_status;

DROP TABLE if exists dashboards.lsoa_registrations;
create table dashboards.lsoa_registrations as
select lsoa_2011_code as lsoa_code, count(distinct p.id) as count,DATE(NOW()) as date
from patient p
join organization o on o.id = p.organization_id
join organization o2 on o2.id = o.parent_organization_id
join episode_of_care e on e.patient_id = p.id
join concept c2 on c2.dbid = e.registration_type_concept_id
join patient_address a on a.id = p.current_address_id
where p.date_of_death IS NULL
and c2.id = 'FHIR_RT_R'
and e.date_registered <= now()
and (e.date_registered_end > now() or e.date_registered_end IS NULL)
and 
e.id >=
(select max(e2.id)
from
episode_of_care e2
join patient p on p.id = e2.patient_id
join concept c2 on c2.dbid = e2.registration_type_concept_id
where p.date_of_death IS NULL
and c2.id = 'FHIR_RT_R'
and e2.date_registered <= now()
and (e2.date_registered_end > now() or e2.date_registered_end IS NULL)
and e2.patient_id = e.patient_id)
group by lsoa_2011_code;

drop table if exists dashboards.population_denominators;
create table dashboards.population_denominators
select 'North East London STP' as stp,o2.name as ccg,po.pcn,o.name as practice,'NEL' as stp_ods_code,o2.ods_code as ccg_ods_code,o.ods_code as practice_ods_code,el.ethnic_group as ethnic,
CASE WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) IS NULL THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 0 AND 4 THEN '0-4' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 5 AND 9 THEN '5-9' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 10 AND 14 THEN '10-14' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 15 AND 19 THEN '15-19' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 20 AND 24 THEN '20-24' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 25 AND 29 THEN '25-29' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 30 AND 34 THEN '30-34' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 35 AND 39 THEN '35-39' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 40 AND 44 THEN '40-44' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 45 AND 49 THEN '45-49' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 50 AND 54 THEN '50-54' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 55 AND 59 THEN '55-59' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 60 AND 64 THEN '60-64' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 65 AND 69 THEN '65-69' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 70 AND 74 THEN '70-74' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 75 AND 79 THEN '75-79' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 80 AND 84 THEN '80-84' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 85 AND 89 THEN '85-89' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 90 AND 94 THEN '90-94' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) BETWEEN 95 AND 99 THEN '95-99' 
WHEN truncate(DATEDIFF(now(), p.date_of_birth) / 365.25,0) > 99 THEN '>100' END as age,
cg.name as sex, count(distinct p.id) as list_size
from patient p
join organization o on o.id = p.organization_id
join organization o2 on o2.id = o.parent_organization_id
left join pcn_ods po on po.ods_code = o.ods_code
join episode_of_care e on e.patient_id = p.id
join concept c2 on c2.dbid = e.registration_type_concept_id
left join concept ce on ce.dbid = p.ethnic_code_concept_id
left join ethnicity_lookup el on el.ethnic_name = ce.name
left join concept cg on cg.dbid = p.gender_concept_id
where p.date_of_death IS NULL
and c2.id = 'FHIR_RT_R'
and e.date_registered <= now()
and (e.date_registered_end > now() or e.date_registered_end IS NULL)
and 
e.id >=
(select max(e2.id)
from
episode_of_care e2
join patient p on p.id = e2.patient_id
join concept c2 on c2.dbid = e2.registration_type_concept_id
where p.date_of_death IS NULL
and c2.id = 'FHIR_RT_R'
and e2.date_registered <= now()
and (e2.date_registered_end > now() or e2.date_registered_end IS NULL)
and e2.patient_id = e.patient_id)
group by stp,o2.name,pcn,o.name,el.ethnic_group,age,cg.name;

ALTER TABLE `dashboards`.`population_denominators` 
ADD INDEX `stp` (`stp` ASC),
ADD INDEX `ccg` (`ccg` ASC),
ADD INDEX `pcn` (`pcn` ASC),
ADD INDEX `practice` (`practice` ASC),
ADD INDEX `stp_ods_code` (`stp_ods_code` ASC),
ADD INDEX `ccg_ods_code` (`ccg_ods_code` ASC),
ADD INDEX `practice_ods_code` (`practice_ods_code` ASC),
ADD INDEX `ethnic` (`ethnic` ASC),
ADD INDEX `age` (`age` ASC),
ADD INDEX `sex` (`sex` ASC);

update dashboards.population_denominators set ethnic = 'Not recorded' where ethnic is null;
update dashboards.population_denominators set ethnic = 'Not recorded' where ethnic = 'NULL';
update dashboards.covid_results_1 set ethnic = 'Not recorded' where ethnic is null;
update dashboards.covid_results_1 set ethnic = 'Not recorded' where ethnic = 'NULL';
update dashboards.covid_results_2 set ethnic = 'Not recorded' where ethnic is null;
update dashboards.covid_results_2 set ethnic = 'Not recorded' where ethnic = 'NULL';
update dashboards.covid_results_3 set ethnic = 'Not recorded' where ethnic is null;
update dashboards.covid_results_3 set ethnic = 'Not recorded' where ethnic = 'NULL';
update dashboards.covid_results_4 set ethnic = 'Not recorded' where ethnic is null;
update dashboards.covid_results_4 set ethnic = 'Not recorded' where ethnic = 'NULL';
update dashboards.covid_results_5 set ethnic = 'Not recorded' where ethnic is null;
update dashboards.covid_results_5 set ethnic = 'Not recorded' where ethnic = 'NULL';
update dashboards.covid_results_6 set ethnic = 'Not recorded' where ethnic is null;
update dashboards.covid_results_6 set ethnic = 'Not recorded' where ethnic = 'NULL';
update dashboards.covid_results_7 set ethnic = 'Not recorded' where ethnic is null;
update dashboards.covid_results_7 set ethnic = 'Not recorded' where ethnic = 'NULL';
update dashboards.covid_results_8 set ethnic = 'Not recorded' where ethnic is null;
update dashboards.covid_results_8 set ethnic = 'Not recorded' where ethnic = 'NULL';

update dashboards.covid_results_3 set name = 'Other' where name is null;
update dashboards.covid_results_3 set name = 'Other' where name = 'NULL';

update dashboards.covid_results_6 set practice = 'NEL NHS111' where practice = 'LONDON AMBULANCE SERVICE NHS TRUST';
update dashboards.covid_results_7 set ccg = 'BHRUT' where ccg = 'BARKING, HAVERING AND REDBRIDGE UNIVERSITY HOSPITALS NHS TRUST';
update dashboards.covid_results_7 set ccg = 'BARTS' where ccg = 'BARTS AND THE LONDON NHS TRUST';
update dashboards.covid_results_7 set ccg = 'HOMERTON' where ccg = 'HOMERTON UNIVERSITY HOSPITAL NHS FOUNDATION TRUST';
update dashboards.covid_results_8 set ccg = 'BHRUT' where ccg = 'BARKING, HAVERING AND REDBRIDGE UNIVERSITY HOSPITALS NHS TRUST';
update dashboards.covid_results_8 set ccg = 'BARTS' where ccg = 'BARTS AND THE LONDON NHS TRUST';
update dashboards.covid_results_8 set ccg = 'HOMERTON' where ccg = 'HOMERTON UNIVERSITY HOSPITAL NHS FOUNDATION TRUST';
update dashboards.covid_results_7 set pcn = 'BHRUT' where pcn = 'BARKING, HAVERING AND REDBRIDGE UNIVERSITY HOSPITALS NHS TRUST';
update dashboards.covid_results_7 set pcn = 'BARTS' where pcn = 'BARTS AND THE LONDON NHS TRUST';
update dashboards.covid_results_7 set pcn = 'HOMERTON' where pcn = 'HOMERTON UNIVERSITY HOSPITAL NHS FOUNDATION TRUST';
update dashboards.covid_results_8 set pcn = 'BHRUT' where pcn = 'BARKING, HAVERING AND REDBRIDGE UNIVERSITY HOSPITALS NHS TRUST';
update dashboards.covid_results_8 set pcn = 'BARTS' where pcn = 'BARTS AND THE LONDON NHS TRUST';
update dashboards.covid_results_8 set pcn = 'HOMERTON' where pcn = 'HOMERTON UNIVERSITY HOSPITAL NHS FOUNDATION TRUST';
update dashboards.covid_results_7 set practice = 'BHRUT' where practice = 'BARKING, HAVERING AND REDBRIDGE UNIVERSITY HOSPITALS NHS TRUST';
update dashboards.covid_results_7 set practice = 'BARTS' where practice = 'BARTS AND THE LONDON NHS TRUST';
update dashboards.covid_results_7 set practice = 'HOMERTON' where practice = 'HOMERTON UNIVERSITY HOSPITAL NHS FOUNDATION TRUST';
update dashboards.covid_results_8 set practice = 'BHRUT' where practice = 'BARKING, HAVERING AND REDBRIDGE UNIVERSITY HOSPITALS NHS TRUST';
update dashboards.covid_results_8 set practice = 'BARTS' where practice = 'BARTS AND THE LONDON NHS TRUST';
update dashboards.covid_results_8 set practice = 'HOMERTON' where practice = 'HOMERTON UNIVERSITY HOSPITAL NHS FOUNDATION TRUST';


insert into dashboards.population_denominators (stp,ccg,pcn,practice,stp_ods_code,ccg_ods_code,practice_ods_code)
values ('North East London STP', 'NEL NHS111','NEL NHS111','NEL NHS111','NEL','RRU','RRU');
insert into dashboards.population_denominators (stp,ccg,pcn,practice,stp_ods_code,ccg_ods_code,practice_ods_code)
values ('North East London STP', 'BHRUT','BHRUT','BHRUT','NEL','RF4','RF4');
insert into dashboards.population_denominators (stp,ccg,pcn,practice,stp_ods_code,ccg_ods_code,practice_ods_code)
values ('North East London STP', 'BARTS','BARTS','BARTS','NEL','RNJ','RNJ');
insert into dashboards.population_denominators (stp,ccg,pcn,practice,stp_ods_code,ccg_ods_code,practice_ods_code)
values ('North East London STP', 'HOMERTON','HOMERTON','HOMERTON','NEL','RQX','RQX');

drop table if exists dashboards.organisation_breakdown;
create table dashboards.organisation_breakdown
select distinct stp, stp_ods_code, ccg, ccg_ods_code, pcn, practice, practice_ods_code from dashboards.population_denominators;

update dashboards.organisation_breakdown set ccg_ods_code = '08F' where practice_ods_code in ('F82663','F82033');

ALTER TABLE `dashboards`.`organisation_breakdown` 
ADD INDEX `stp` (`stp` ASC),
ADD INDEX `ccg` (`ccg` ASC),
ADD INDEX `pcn` (`pcn` ASC),
ADD INDEX `practice` (`practice` ASC),
ADD INDEX `stp_ods_code` (`stp_ods_code` ASC),
ADD INDEX `ccg_ods_code` (`ccg_ods_code` ASC),
ADD INDEX `practice_ods_code` (`practice_ods_code` ASC);

delete from dashboards.organisation_breakdown where ccg_ods_code is null;


END