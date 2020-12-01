
USE dashboards;

DROP TRIGGER IF EXISTS buQueryLibraryTrg;

DELIMITER //

CREATE TRIGGER buQueryLibraryTrg
    BEFORE UPDATE
    ON query_library FOR EACH ROW 
BEGIN

      IF old.query <> new.query THEN
        SET new.updated = now();
      END IF;

END//
DELIMITER ;