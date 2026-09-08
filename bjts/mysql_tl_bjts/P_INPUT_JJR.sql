DELIMITER $$

DROP PROCEDURE IF EXISTS P_INPUT_JJR$$

CREATE procedure p_input_jjr
routine_body: BEGIN
  DECLARE date_tjrq DATETIME;

  SET date_tjrq = STR_TO_DATE('2025-01-01', '%Y-%m-%d');
  loop
    exit when date_tjrq >= STR_TO_DATE('2026-01-01', '%Y-%m-%d');
    DBMS_OUTPUT.put_line(DATE_FORMAT(date_tjrq, '%Y-%m-%d'));
    SET date_tjrq = next_day(date_tjrq, 'SATURDAY');
    insert into PUB_JJR(jjr_ssnd, jjr_date, memo)
    values('2025',date_tjrq,'星期六');
    SET date_tjrq = next_day(date_tjrq, 'SUNDAY');
    insert into PUB_JJR(jjr_ssnd, jjr_date, memo)
    values('2025',date_tjrq,'星期日');
    commit;
  end loop;
END$$

DELIMITER ;
