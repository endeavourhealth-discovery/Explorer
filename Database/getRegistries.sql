USE dashboards;

DROP PROCEDURE IF EXISTS getRegistries;

DELIMITER //
CREATE PROCEDURE getRegistries(IN filter_ccg VARCHAR(255),
  IN filter_registry VARCHAR(255),
  IN valid_orgs VARCHAR(1000),
  IN valid_orgs2 VARCHAR(1000))

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
	  dashboards.registries r
		where r.ods_code in
		(
			select distinct practice_ods_code from dashboards.population_denominators
			WHERE (find_in_set(stp_ods_code, valid_orgs2) or find_in_set(ccg_ods_code, valid_orgs2) or find_in_set(practice_ods_code, valid_orgs2))
		)
  	    AND registry in (select distinct registry from dashboards.registries r
	    WHERE parent_registry = ''
		AND r.ods_code in
		(
			select distinct practice_ods_code from dashboards.population_denominators
			WHERE (find_in_set(stp_ods_code, valid_orgs2) or find_in_set(ccg_ods_code, valid_orgs2) or find_in_set(practice_ods_code, valid_orgs2))
		)
      );

	SET @sql = CONCAT('create table dashboards.temp as SELECT IFNULL(r.ccg, "GRAND TOTAL") AS ccg, ', @sql,
	'FROM dashboards.registries r '
   'where r.parent_registry = \'\' and r.ods_code in '
   '(select distinct practice_ods_code from dashboards.population_denominators '
   'WHERE (stp_ods_code in (',valid_orgs,') or ccg_ods_code in (',valid_orgs,') or practice_ods_code in (',valid_orgs,'))) '
   'GROUP BY r.ccg with rollup');

	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	alter table dashboards.temp add column list_size int(11);

	create temporary table list_sizes engine=memory
	SELECT distinct r.ccg, r.practice_name, r.list_size
	FROM dashboards.registries r
      join dashboards.population_denominators p on p.practice_ods_code = r.ods_code
	  WHERE (find_in_set(stp_ods_code, valid_orgs2) or find_in_set(ccg_ods_code, valid_orgs2) or find_in_set(practice_ods_code, valid_orgs2)) and parent_registry = '';

	create temporary table list_sizes_ccg engine=memory
	select IFNULL(ccg, "GRAND TOTAL") AS ccg,sum(list_size) as list_size from list_sizes
	group by ccg with rollup;

	UPDATE dashboards.temp t
	JOIN
    list_sizes_ccg r ON r.ccg = t.ccg
	SET
    t.list_size = r.list_size;

	SELECT
    CONCAT('select \'Go to denominator registry\' as org,\'\' as list_size,\'\' as registry_size,\'',
            GROUP_CONCAT(CONCAT('', column_name, '')
                ORDER BY column_name
                SEPARATOR '~'),
            '\' as all_columns
                    UNION SELECT ccg as org, list_size, -1, CONCAT_WS(\'~\',',
            GROUP_CONCAT(CONCAT('`', column_name, '`')
                ORDER BY column_name),
            ') AS all_columns FROM dashboards.temp;')
FROM
    `information_schema`.`columns`
WHERE
    `table_schema` = 'dashboards'
        AND `table_name` = 'temp'
        AND column_name NOT IN ('ccg' , 'list_size') INTO @sql;

elseif filter_ccg != '' and filter_registry	 = '' THEN

	SELECT count(distinct(ccg)) into counter FROM dashboards.population_denominators where ccg in (filter_ccg);

	if counter = 0 then
		leave sp;
	end if;

	SELECT
    GROUP_CONCAT(DISTINCT CONCAT('ifnull(SUM(case when registry = \'',
                registry,
                '\' then registry_size end),0) AS `',
                registry,
                '`',
                ',ifnull(avg(case when registry = \'',
                registry,
                '\' then target_percentage end),0) AS `',
                registry,
                '.0000`'))
	INTO @sql
	FROM
	  dashboards.registries r
		where r.ods_code in
		(
			select distinct practice_ods_code from dashboards.population_denominators
			WHERE (find_in_set(stp_ods_code, valid_orgs2) or find_in_set(ccg_ods_code, valid_orgs2) or find_in_set(practice_ods_code, valid_orgs2))
		)
  	    AND registry in (select distinct registry from dashboards.registries r
	    WHERE parent_registry = ''
		AND r.ods_code in
		(
			select distinct practice_ods_code from dashboards.population_denominators
			WHERE (find_in_set(stp_ods_code, valid_orgs2) or find_in_set(ccg_ods_code, valid_orgs2) or find_in_set(practice_ods_code, valid_orgs2))
		)
      );

	SET @sql = CONCAT('create table dashboards.temp as SELECT IFNULL(r.practice_name, "GRAND TOTAL") AS practice_name, ', @sql,
                    'FROM dashboards.registries r '
                   'where r.ccg = \'',filter_ccg,'\' and r.parent_registry = \'\' and r.ods_code in '
                   '(select distinct practice_ods_code from dashboards.population_denominators '
                   'WHERE (stp_ods_code in (',valid_orgs,') or ccg_ods_code in (',valid_orgs,') or practice_ods_code in (',valid_orgs,'))) '
                   'GROUP BY r.practice_name with rollup');

	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	alter table dashboards.temp add column list_size int(11);

	create temporary table list_sizes engine=memory
	SELECT distinct r.ccg, r.practice_name, r.list_size
	FROM dashboards.registries r
      join dashboards.population_denominators p on p.practice_ods_code = r.ods_code
	  WHERE (find_in_set(stp_ods_code, valid_orgs2) or find_in_set(ccg_ods_code, valid_orgs2) or find_in_set(practice_ods_code, valid_orgs2)) and r.ccg = filter_ccg and parent_registry = '';

	create temporary table list_sizes_practice engine=memory
	select IFNULL(practice_name, "GRAND TOTAL") AS practice_name,sum(list_size) as list_size from list_sizes
	group by practice_name with rollup;

	UPDATE dashboards.temp t
	JOIN
    list_sizes_practice r ON r.practice_name = t.practice_name
	SET
    t.list_size = r.list_size;

	SELECT
    CONCAT('select \'Go to denominator registry\' as org,\'\' as list_size,\'\' as registry_size,\'',
            GROUP_CONCAT(CONCAT('', column_name, '')
                ORDER BY column_name
                SEPARATOR '~'),
            '\' as all_columns UNION SELECT IFNULL(concat(t.practice_name,\' (\',r.ods_code,\')\'), "GRAND TOTAL") as org, t.list_size, -1, CONCAT_WS(\'~\',',
            GROUP_CONCAT(CONCAT('`', column_name, '`')
                ORDER BY column_name),
            ') AS all_columns FROM dashboards.temp t left join dashboards.registries r on r.practice_name = t.practice_name;')
FROM
    `information_schema`.`columns`
WHERE
    `table_schema` = 'dashboards'
        AND `table_name` = 'temp'
        AND column_name NOT IN ('practice_name' , 'list_size') INTO @sql;

elseif filter_ccg='' and filter_registry != '' THEN

	SELECT count(distinct(registry)) into counter FROM dashboards.registries r
      join dashboards.population_denominators p on p.practice_ods_code = r.ods_code
	  WHERE (find_in_set(stp_ods_code, valid_orgs2) or find_in_set(ccg_ods_code, valid_orgs2) or find_in_set(practice_ods_code, valid_orgs2)) and registry in (filter_registry);

	if counter = 0 then
		leave sp;
	end if;

	SELECT
    GROUP_CONCAT(DISTINCT CONCAT('ifnull(SUM(case when registry = \'',
                registry,
                '\' then registry_size end),0) AS `',
                registry,
                '`',
                ',ifnull(avg(case when registry = \'',
                registry,
                '\' then target_percentage end),0) AS `',
                registry,
                '.0000`'))
	INTO @sql
	FROM
	  dashboards.registries r
		where r.ods_code in
		(
			select distinct practice_ods_code from dashboards.population_denominators
			WHERE (find_in_set(stp_ods_code, valid_orgs2) or find_in_set(ccg_ods_code, valid_orgs2) or find_in_set(practice_ods_code, valid_orgs2))
		)
  	    AND registry in (select distinct registry from dashboards.registries r
	    WHERE parent_registry = filter_registry
		AND r.ods_code in
		(
			select distinct practice_ods_code from dashboards.population_denominators
			WHERE (find_in_set(stp_ods_code, valid_orgs2) or find_in_set(ccg_ods_code, valid_orgs2) or find_in_set(practice_ods_code, valid_orgs2))
		)
      );

	SET @sql = CONCAT('create table dashboards.temp as SELECT IFNULL(r.ccg, "GRAND TOTAL") AS ccg, ', @sql,
	'FROM dashboards.registries r '
   'where r.parent_registry = \'',filter_registry,'\' and r.ods_code in '
   '(select distinct practice_ods_code from dashboards.population_denominators '
   'WHERE (stp_ods_code in (',valid_orgs,') or ccg_ods_code in (',valid_orgs,') or practice_ods_code in (',valid_orgs,'))) '
   'GROUP BY r.ccg with rollup');

	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	alter table dashboards.temp add column list_size int(11);
	alter table dashboards.temp add column registry_size int(11);

	create temporary table list_sizes engine=memory
	SELECT distinct r.ccg, r.practice_name, r.list_size
	FROM dashboards.registries r
      join dashboards.population_denominators p on p.practice_ods_code = r.ods_code
	  WHERE (find_in_set(stp_ods_code, valid_orgs2) or find_in_set(ccg_ods_code, valid_orgs2) or find_in_set(practice_ods_code, valid_orgs2)) and parent_registry = '';

	create temporary table registry_sizes engine=memory
	SELECT distinct r.ccg, r.practice_name, r.list_size as registry_size
	FROM dashboards.registries r
      join dashboards.population_denominators p on p.practice_ods_code = r.ods_code
	  WHERE (find_in_set(stp_ods_code, valid_orgs2) or find_in_set(ccg_ods_code, valid_orgs2) or find_in_set(practice_ods_code, valid_orgs2)) and parent_registry = filter_registry;

	create temporary table list_sizes_ccg engine=memory
	select IFNULL(ccg, "GRAND TOTAL") AS ccg,sum(list_size) as list_size from list_sizes
	group by ccg with rollup;

	create temporary table registry_sizes_ccg engine=memory
	select IFNULL(ccg, "GRAND TOTAL") AS ccg,sum(registry_size) as registry_size from registry_sizes
	group by ccg with rollup;

	UPDATE dashboards.temp t
	JOIN
    list_sizes_ccg r ON r.ccg = t.ccg
	SET
    t.list_size = r.list_size;

	UPDATE dashboards.temp t
	JOIN
    registry_sizes_ccg r ON r.ccg = t.ccg
	SET
    t.registry_size = r.registry_size;

SELECT
    CONCAT('select \'Go to denominator registry\' as org,\'\' as list_size,\'',
            filter_registry,
            '\' as registry_size,\'',
            GROUP_CONCAT(CONCAT('', column_name, '')
                ORDER BY column_name
                SEPARATOR '~'),
            '\' as all_columns
                    UNION SELECT ccg as org, list_size, registry_size, CONCAT_WS(\'~\',',
            GROUP_CONCAT(CONCAT('`', column_name, '`')
                ORDER BY column_name),
            ') AS all_columns FROM dashboards.temp;')
FROM
    `information_schema`.`columns`
WHERE
    `table_schema` = 'dashboards'
        AND `table_name` = 'temp'
        AND column_name NOT IN ('ccg' , 'list_size', 'registry_size') INTO @sql;

elseif filter_ccg != '' and filter_registry	 != '' THEN

	SELECT count(distinct(ccg)) into counter FROM dashboards.population_denominators where ccg in (filter_ccg);

	if counter = 0 then
		leave sp;
	end if;

	SELECT
    COUNT(DISTINCT (registry))
I	INTO counter FROM
    dashboards.registries
	WHERE
    registry IN (filter_registry);

	if counter = 0 then
		leave sp;
	end if;

	SELECT
    GROUP_CONCAT(DISTINCT CONCAT('ifnull(SUM(case when registry = \'',
                registry,
                '\' then registry_size end),0) AS `',
                registry,
                '`',
                ',ifnull(avg(case when registry = \'',
                registry,
                '\' then target_percentage end),0) AS `',
                registry,
                '.0000`'))
	INTO @sql
	FROM
	  dashboards.registries r
		where r.ods_code in
		(
			select distinct practice_ods_code from dashboards.population_denominators
			WHERE (find_in_set(stp_ods_code, valid_orgs2) or find_in_set(ccg_ods_code, valid_orgs2) or find_in_set(practice_ods_code, valid_orgs2))
		)
  	    AND registry in (select distinct registry from dashboards.registries r
	    WHERE parent_registry = filter_registry
		AND r.ods_code in
		(
			select distinct practice_ods_code from dashboards.population_denominators
			WHERE (find_in_set(stp_ods_code, valid_orgs2) or find_in_set(ccg_ods_code, valid_orgs2) or find_in_set(practice_ods_code, valid_orgs2))
		)
      );

	SET @sql = CONCAT('create table dashboards.temp as SELECT IFNULL(r.practice_name, "GRAND TOTAL") AS practice_name, ', @sql,
	'FROM dashboards.registries r '
   'where r.ccg = \'',filter_ccg,'\' and r.parent_registry = \'',filter_registry,'\' and r.ods_code in '
   '(select distinct practice_ods_code from dashboards.population_denominators '
   'WHERE (stp_ods_code in (',valid_orgs,') or ccg_ods_code in (',valid_orgs,') or practice_ods_code in (',valid_orgs,'))) '
   'GROUP BY r.practice_name with rollup');

	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	alter table dashboards.temp add column list_size int(11);
	alter table dashboards.temp add column registry_size int(11);

	create temporary table list_sizes engine=memory
	SELECT distinct r.ccg, r.practice_name, r.list_size
	FROM dashboards.registries r
      join dashboards.population_denominators p on p.practice_ods_code = r.ods_code
	  WHERE (find_in_set(stp_ods_code, valid_orgs2) or find_in_set(ccg_ods_code, valid_orgs2) or find_in_set(practice_ods_code, valid_orgs2)) and r.ccg = filter_ccg and parent_registry = '';

	create temporary table registry_sizes engine=memory
	SELECT distinct r.ccg, r.practice_name, r.list_size as registry_size
	FROM dashboards.registries r
      join dashboards.population_denominators p on p.practice_ods_code = r.ods_code
	  WHERE (find_in_set(stp_ods_code, valid_orgs2) or find_in_set(ccg_ods_code, valid_orgs2) or find_in_set(practice_ods_code, valid_orgs2)) and r.ccg = filter_ccg and parent_registry = filter_registry;

	create temporary table list_sizes_practice engine=memory
	select IFNULL(practice_name, "GRAND TOTAL") AS practice_name,sum(list_size) as list_size from list_sizes
	group by practice_name with rollup;

	create temporary table registry_sizes_practice engine=memory
	select IFNULL(practice_name, "GRAND TOTAL") AS practice_name,sum(registry_size) as registry_size from registry_sizes
	group by practice_name with rollup;

	UPDATE dashboards.temp t
        JOIN
    list_sizes_practice r ON r.practice_name = t.practice_name
SET
    t.list_size = r.list_size;

	UPDATE dashboards.temp t
        JOIN
    registry_sizes_practice r ON r.practice_name = t.practice_name
SET
    t.registry_size = r.registry_size;

	SELECT
    CONCAT('select \'Go to denominator registry\' as org,\'\' as list_size,\'',
            filter_registry,
            '\' as registry_size,\'',
            GROUP_CONCAT(CONCAT('', column_name, '')
                ORDER BY column_name
                SEPARATOR '~'),
            '\' as all_columns
                    UNION SELECT IFNULL(concat(t.practice_name,\' (\',r.ods_code,\')\'), "GRAND TOTAL") as org, t.list_size, t.registry_size,
                    CONCAT_WS(\'~\',',
            GROUP_CONCAT(CONCAT('`', column_name, '`')
                ORDER BY column_name),
            ') AS all_columns FROM dashboards.temp t left join dashboards.registries r on r.practice_name = t.practice_name;')
FROM
    `information_schema`.`columns`
WHERE
    `table_schema` = 'dashboards'
        AND `table_name` = 'temp'
        AND column_name NOT IN ('practice_name' , 'list_size', 'registry_size') INTO @sql;
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
