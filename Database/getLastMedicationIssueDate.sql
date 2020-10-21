USE subscriber_pi_rv;

-- function to get the last medication issue date

DROP FUNCTION IF EXISTS getLastMedicationIssueDate;

DELIMITER //
CREATE FUNCTION getLastMedicationIssueDate(p_medication_stmt_id BIGINT) 
RETURNS DATE
NOT DETERMINISTIC READS SQL DATA
BEGIN
DECLARE l_date DATE;
DECLARE l_rnk  INT;

-- get latest issue date

    SELECT 
           med.clinical_effective_date, med.rnk INTO l_date, l_rnk
    FROM (
           SELECT mo.id,
                  mo.medication_statement_id,
                  mo.clinical_effective_date,
                  @currank := IF(@curmedstmt = mo.medication_statement_id, @currank + 1, 1) AS rnk,
                  @curmedstmt := mo.medication_statement_id AS cur_med_stmt
           FROM medication_order mo, (SELECT @currank := 0, @curmedstmt := 0) r
           WHERE mo.medication_statement_id = p_medication_stmt_id
           ORDER BY mo.medication_statement_id DESC, mo.clinical_effective_date DESC, mo.id DESC -- latest
         ) med
    WHERE med.rnk = 1;

RETURN l_date;

END//
DELIMITER ;


