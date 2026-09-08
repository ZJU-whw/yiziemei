DELIMITER $$

DROP PROCEDURE IF EXISTS P_INPUT_JJR$$

CREATE procedure p_input_jjr()
routine_body: BEGIN
  DECLARE date_tjrq DATETIME;

  SET date_tjrq = STR_TO_DATE('2025-01-01', '%Y-%m-%d');
  BJTS_LOOP_001: LOOP
    IF date_tjrq >= STR_TO_DATE('2026-01-01', '%Y-%m-%d') THEN LEAVE BJTS_LOOP_001; END IF;
    DO DATE_FORMAT(date_tjrq, '%Y-%m-%d');
    SET date_tjrq = ORA_NEXT_DAY(date_tjrq, 'SATURDAY');
    insert into PUB_JJR(jjr_ssnd, jjr_date, memo)
    values('2025',date_tjrq,'星期六');
    SET date_tjrq = ORA_NEXT_DAY(date_tjrq, 'SUNDAY');
    insert into PUB_JJR(jjr_ssnd, jjr_date, memo)
    values('2025',date_tjrq,'星期日');
    commit;
  END LOOP BJTS_LOOP_001;
END$$

DELIMITER ;
