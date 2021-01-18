USE dashboards;

DROP PROCEDURE IF EXISTS getRegistries;

DELIMITER //
CREATE PROCEDURE getRegistries(IN filter_ccg VARCHAR(255),
  IN filter_registry VARCHAR(255))

sp: BEGIN

DECLARE counter DECIMAL DEFAULT 0;

drop table if exists dashboards.temp;
drop temporary table if exists tmp1;
drop temporary table if exists list_sizes;
drop temporary table if exists registry_sizes;
drop temporary table if exists list_sizes_ccg;
drop temporary table if exists registry_sizes_ccg;
drop temporary table if exists registry_sizes_practice;
drop temporary table if exists list_sizes_practice;


SET session group_concat_max_len=15000;

IF filter_ccg='' and filter_registry = '' THEN

	SELECT
	  GROUP_CONCAT(DISTINCT
		CONCAT(
		  'ifnull(SUM(case when registry = ''',
		  registry,
		  ''' then registry_size end),0) AS `',
		  registry, '`',
          ',ifnull(avg(case when registry = ''',
		  registry,
		  ''' then target_percentage end),0) AS `',
		  registry, '.0000`'
		)
	  ) INTO @sql
	FROM
	  dashboards.registries where registry in (select distinct registry from dashboards.registries where parent_registry = '');

	SET @sql = CONCAT('create table dashboards.temp as SELECT IFNULL(ccg, "GRAND TOTAL") AS ccg, ', @sql, '
                  FROM dashboards.registries where parent_registry = \'\' GROUP BY ccg with rollup');

	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	alter table dashboards.temp add column list_size int(11);

	create temporary table list_sizes engine=memory
	SELECT distinct ccg, practice_name, list_size
	FROM dashboards.registries where parent_registry = '';

	create temporary table list_sizes_ccg engine=memory
	select IFNULL(ccg, "GRAND TOTAL") AS ccg,sum(list_size) as list_size from list_sizes
	group by ccg with rollup;

	update dashboards.temp t
	join list_sizes_ccg r on r.ccg = t.ccg
	set t.list_size = r.list_size;

	SELECT
	  CONCAT(
		'select ''Go to denominator registry'' as org,'''' as list_size,'''' as registry_size,''',GROUP_CONCAT(CONCAT('', column_name, '') ORDER BY column_name SEPARATOR '~'),''' as all_columns
        UNION SELECT ccg as org, list_size, -1, CONCAT_WS(\'~\',',
		GROUP_CONCAT(CONCAT('`', column_name, '`') ORDER BY column_name),
		') AS all_columns FROM dashboards.temp;')
	FROM   `information_schema`.`columns`
	WHERE  `table_schema`='dashboards'
		   AND `table_name`='temp'
		   AND column_name not in ('ccg','list_size')

	INTO @sql;

elseif filter_ccg != '' and filter_registry	 = '' THEN

	SELECT count(distinct(ccg)) into counter FROM dashboards.practice_list_sizes where ccg in (filter_ccg);

	if counter = 0 then
		leave sp;
	end if;

	SELECT
	  GROUP_CONCAT(DISTINCT
		CONCAT(
		  'ifnull(SUM(case when registry = ''',
		  registry,
		  ''' then registry_size end),0) AS `',
		  registry, '`',
          ',ifnull(avg(case when registry = ''',
		  registry,
		  ''' then target_percentage end),0) AS `',
		  registry, '.0000`'
		)
	  ) INTO @sql
	FROM
	  dashboards.registries where registry in (select distinct registry from dashboards.registries where parent_registry = '');

	SET @sql = CONCAT('create table dashboards.temp as SELECT IFNULL(practice_name, "GRAND TOTAL") AS practice_name, ', @sql, '
                  FROM dashboards.registries where ccg = \'',filter_ccg,'\' and parent_registry = \'\' GROUP BY practice_name with rollup');

	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	alter table dashboards.temp add column list_size int(11);

	create temporary table list_sizes engine=memory
	SELECT distinct ccg, practice_name, list_size
	FROM dashboards.registries where ccg = filter_ccg and parent_registry = '';

	create temporary table list_sizes_practice engine=memory
	select IFNULL(practice_name, "GRAND TOTAL") AS practice_name,sum(list_size) as list_size from list_sizes
	group by practice_name with rollup;

	update dashboards.temp t
	join list_sizes_practice r on r.practice_name = t.practice_name
	set t.list_size = r.list_size;

	SELECT
	  CONCAT(
		'select ''Go to denominator registry'' as org,'''' as list_size,'''' as registry_size,''',GROUP_CONCAT(CONCAT('', column_name, '') ORDER BY column_name SEPARATOR '~'),
        ''' as all_columns UNION SELECT IFNULL(concat(t.practice_name,\' (\',r.ods_code,\')\'), "GRAND TOTAL") as org, t.list_size, -1, CONCAT_WS(\'~\',',
		GROUP_CONCAT(CONCAT('`', column_name, '`') ORDER BY column_name),
		') AS all_columns FROM dashboards.temp t left join dashboards.registries r on r.practice_name = t.practice_name;')
	FROM   `information_schema`.`columns`
	WHERE  `table_schema`='dashboards'
		   AND `table_name`='temp'
		   AND column_name not in ('practice_name','list_size')

	INTO @sql;

elseif filter_ccg='' and filter_registry != '' THEN

	SELECT count(distinct(registry)) into counter FROM dashboards.registries where registry in (filter_registry);

	if counter = 0 then
		leave sp;
	end if;

	SELECT
	  GROUP_CONCAT(DISTINCT
		CONCAT(
		  'ifnull(SUM(case when registry = ''',
		  registry,
		  ''' then registry_size end),0) AS `',
		  registry, '`',
          ',ifnull(avg(case when registry = ''',
		  registry,
		  ''' then target_percentage end),0) AS `',
		  registry, '.0000`'
		)
	  ) INTO @sql
	FROM
	  dashboards.registries where registry in (select distinct registry from dashboards.registries where parent_registry = filter_registry);

	SET @sql = CONCAT('create table dashboards.temp as SELECT IFNULL(ccg, "GRAND TOTAL") AS ccg, ', @sql, '
                  FROM dashboards.registries where parent_registry = \'',filter_registry,'\' GROUP BY ccg with rollup');

	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	alter table dashboards.temp add column list_size int(11);
	alter table dashboards.temp add column registry_size int(11);

	create temporary table list_sizes engine=memory
	SELECT distinct ccg, practice_name, list_size
	FROM dashboards.registries where parent_registry = '';

	create temporary table registry_sizes engine=memory
	SELECT distinct ccg, practice_name, list_size as registry_size
	FROM dashboards.registries where parent_registry = filter_registry;

	create temporary table list_sizes_ccg engine=memory
	select IFNULL(ccg, "GRAND TOTAL") AS ccg,sum(list_size) as list_size from list_sizes
	group by ccg with rollup;

	create temporary table registry_sizes_ccg engine=memory
	select IFNULL(ccg, "GRAND TOTAL") AS ccg,sum(registry_size) as registry_size from registry_sizes
	group by ccg with rollup;

	update dashboards.temp t
	join list_sizes_ccg r on r.ccg = t.ccg
	set t.list_size = r.list_size;

	update dashboards.temp t
	join registry_sizes_ccg r on r.ccg = t.ccg
	set t.registry_size = r.registry_size;

SELECT
	  CONCAT(
		'select ''Go to denominator registry'' as org,'''' as list_size,''',filter_registry,''' as registry_size,''',
        GROUP_CONCAT(CONCAT('', column_name, '') ORDER BY column_name SEPARATOR '~'),''' as all_columns
        UNION SELECT ccg as org, list_size, registry_size, CONCAT_WS(\'~\',',
		GROUP_CONCAT(CONCAT('`', column_name, '`') ORDER BY column_name),
		') AS all_columns FROM dashboards.temp;')
	FROM   `information_schema`.`columns`
	WHERE  `table_schema`='dashboards'
		   AND `table_name`='temp'
		   AND column_name not in ('ccg','list_size','registry_size')

	INTO @sql;

elseif filter_ccg != '' and filter_registry	 != '' THEN

	SELECT count(distinct(ccg)) into counter FROM dashboards.practice_list_sizes where ccg in (filter_ccg);

	if counter = 0 then
		leave sp;
	end if;

	SELECT count(distinct(registry)) into counter FROM dashboards.registries where registry in (filter_registry);

	if counter = 0 then
		leave sp;
	end if;


	SELECT
	  GROUP_CONCAT(DISTINCT
		CONCAT(
		  'ifnull(SUM(case when registry = ''',
		  registry,
		  ''' then registry_size end),0) AS `',
		  registry, '`',
          ',ifnull(avg(case when registry = ''',
		  registry,
		  ''' then target_percentage end),0) AS `',
		  registry, '.0000`'
		)
	  ) INTO @sql
	FROM
	  dashboards.registries where registry in (select distinct registry from dashboards.registries where parent_registry = filter_registry);

	SET @sql = CONCAT('create table dashboards.temp as SELECT IFNULL(practice_name, "GRAND TOTAL") AS practice_name, ', @sql, '
                  FROM dashboards.registries where ccg = \'',filter_ccg,'\' and parent_registry = \'',filter_registry,'\' GROUP BY practice_name with rollup');

	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	alter table dashboards.temp add column list_size int(11);
	alter table dashboards.temp add column registry_size int(11);

	create temporary table list_sizes engine=memory
	SELECT distinct ccg, practice_name, list_size
	FROM dashboards.registries where ccg = filter_ccg and parent_registry = '';

	create temporary table registry_sizes engine=memory
	SELECT distinct ccg, practice_name, list_size as registry_size
	FROM dashboards.registries where ccg = filter_ccg and parent_registry = filter_registry;

	create temporary table list_sizes_practice engine=memory
	select IFNULL(practice_name, "GRAND TOTAL") AS practice_name,sum(list_size) as list_size from list_sizes
	group by practice_name with rollup;

	create temporary table registry_sizes_practice engine=memory
	select IFNULL(practice_name, "GRAND TOTAL") AS practice_name,sum(registry_size) as registry_size from registry_sizes
	group by practice_name with rollup;

	update dashboards.temp t
	join list_sizes_practice r on r.practice_name = t.practice_name
	set t.list_size = r.list_size;

	update dashboards.temp t
	join registry_sizes_practice r on r.practice_name = t.practice_name
	set t.registry_size = r.registry_size;

	SELECT
	  CONCAT(
		'select ''Go to denominator registry'' as org,'''' as list_size,''',filter_registry,''' as registry_size,''',
        GROUP_CONCAT(CONCAT('', column_name, '') ORDER BY column_name SEPARATOR '~'),''' as all_columns
        UNION SELECT IFNULL(concat(t.practice_name,\' (\',r.ods_code,\')\'), "GRAND TOTAL") as org, t.list_size, t.registry_size,
        CONCAT_WS(\'~\',',
		GROUP_CONCAT(CONCAT('`', column_name, '`') ORDER BY column_name),
		') AS all_columns FROM dashboards.temp t left join dashboards.registries r on r.practice_name = t.practice_name;')
	FROM   `information_schema`.`columns`
	WHERE  `table_schema`='dashboards'
		   AND `table_name`='temp'
		   AND column_name not in ('practice_name','list_size','registry_size')

	INTO @sql;
END IF;


PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

drop temporary table if exists tmp1;
drop temporary table if exists list_sizes;
drop temporary table if exists registry_sizes;
drop temporary table if exists list_sizes_ccg;
drop temporary table if exists registry_sizes_ccg;
drop temporary table if exists registry_sizes_practice;
drop temporary table if exists list_sizes_practice;
drop table if exists temp;


END//
DELIMITER ;
