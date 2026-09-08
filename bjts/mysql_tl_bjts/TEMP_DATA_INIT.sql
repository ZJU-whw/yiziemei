DELIMITER $$

DROP PROCEDURE IF EXISTS TEMP_DATA_INIT$$

CREATE PROCEDURE TEMP_DATA_INIT(sbqb VARCHAR(4000), OUT P_RESULT VARCHAR(4000))
routine_body: BEGIN
  DECLARE Result VARCHAR(1);
  -- Oracle REF CURSOR type removed; target uses a result set;
  DECLARE dyn_select VARCHAR(1500);
  DECLARE v_id BIGINT;
  DECLARE v_sbqb VARCHAR(6);
  DECLARE v_value BIGINT;
  DECLARE v_sbywbDm VARCHAR(8);
  DECLARE v_swjgDm VARCHAR(11);

  SET dyn_select =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(' select TRUNCATE((RAND() * ((9999999999) - (1)) + (1)), 0)+CAST(substr(sbywb_dm,2,7) AS DECIMAL(65,30)) as id, ', sbqb), ' as sbqb,
   count(1) as value, sbywb_dm as sbywbDm, swjg_dm as swjgDm
    from (
       select distinct dj.swjg_dm,t.nsrdzdah,t.sbywb_dm, t.sssq, t.sbpc
       from SB_SBXX_HZ t,gs_dj_cktmsdab dj
       where t.nsrdzdah=dj.nsrdzdah
       and DATE_FORMAT(t.sbrq, ''%Y%m'') = '), sbqb), ' ) b
    group by swjg_dm, sbywb_dm ');
    SET dyn_select = CONCAT('INSERT INTO TB_REPORT_DATA SELECT BJTS_REPORT_SOURCE.id, BJTS_REPORT_SOURCE.sbqb, BJTS_REPORT_SOURCE.value, BJTS_REPORT_SOURCE.sbywbDm, BJTS_REPORT_SOURCE.swjgDm, ''0'', CURRENT_TIMESTAMP FROM (', dyn_select, ') AS BJTS_REPORT_SOURCE');
  SET @BJTS_DYNAMIC_SQL_001 = dyn_select;
  PREPARE BJTS_DYNAMIC_STMT_001 FROM @BJTS_DYNAMIC_SQL_001;
  EXECUTE BJTS_DYNAMIC_STMT_001;
  DEALLOCATE PREPARE BJTS_DYNAMIC_STMT_001;
  COMMIT;
  SET Result ='1';
  SET P_RESULT = (Result); LEAVE routine_body;
END$$

DELIMITER ;
