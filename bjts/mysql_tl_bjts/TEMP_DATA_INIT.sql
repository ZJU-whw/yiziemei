DELIMITER $$

DROP PROCEDURE IF EXISTS TEMP_DATA_INIT$$

CREATE PROCEDURE TEMP_DATA_INIT(sbqb VARCHAR(4000), OUT P_RESULT VARCHAR(4000))
routine_body: BEGIN
  DECLARE Result VARCHAR(1);
  -- Oracle REF CURSOR type removed; target uses a result set;
  DECLARE my_cursor Type_Cursor;
  DECLARE dyn_select VARCHAR(1500);
  DECLARE v_id BIGINT;
  DECLARE v_sbqb VARCHAR(6);
  DECLARE v_value BIGINT;
  DECLARE v_sbywbDm VARCHAR(8);
  DECLARE v_swjgDm VARCHAR(11);
  DECLARE PRAGMA AUTONOMOUS_TRANSACTION;

  SET dyn_select =' select trunc(DBMS_RANDOM.VALUE(1,9999999999))+to_number(substr(sbywb_dm,2,7)) as id, '||sbqb||' as sbqb,
   count(1) as value, sbywb_dm as sbywbDm, swjg_dm as swjgDm
    from (
       select distinct dj.swjg_dm,t.nsrdzdah,t.sbywb_dm, t.sssq, t.sbpc
       from SB_SBXX_HZ t,gs_dj_cktmsdab dj
       where t.nsrdzdah=dj.nsrdzdah
       and to_char(t.sbrq, ''YYYYMM'') = '||sbqb||' ) b
    group by swjg_dm, sbywb_dm ';
    OPEN my_cursor FOR dyn_select;
  LOOP
    FETCH my_cursor INTO v_id,v_sbqb,v_value,v_sbywbDm,v_swjgDm;
    EXIT WHEN my_cursor%NOTFOUND;
    insert into TB_REPORT_DATA values(v_id,v_sbqb,v_value,v_sbywbDm,v_swjgDm,'0',CURRENT_TIMESTAMP);
    commit;
  END LOOP;
  CLOSE my_cursor;
  SET Result ='1';
  return(Result);
END$$

DELIMITER ;
