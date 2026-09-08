DELIMITER $$

DROP PROCEDURE IF EXISTS FUNC_GET_SBHZXX$$

CREATE PROCEDURE func_get_sbhzxx(p_czryDm VARCHAR(4000))
routine_body: BEGIN
  -- Oracle REF CURSOR type removed; target uses a result set;
  DECLARE dyn_select VARCHAR(1500);
  DECLARE i DECIMAL(38,10) DEFAULT 0;
  DECLARE v_ywzldm VARCHAR(20);
  DECLARE v_ywzlmc VARCHAR(50);
  DECLARE v_sbywdm VARCHAR(20);
  DECLARE v_sbywmc VARCHAR(50);
  DECLARE v_cnt BIGINT;
  DECLARE v_cqcnt BIGINT;
  DECLARE v_czry_qxswjg VARCHAR(11);
  DECLARE v_czry_swjg VARCHAR(11);


  begin
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
       -- DBMS_OUTPUT.put_line('操作员不存在');
       SELECT NULL AS YWZLDM, NULL AS YWZLMC, NULL AS SBYWDM, NULL AS SBYWMC, NULL AS NUM, NULL AS CQCNT WHERE 1 = 0; LEAVE routine_body;

  END;
select IFNULL(qx_swjg, swjg_dm) into v_czry_swjg
      from dm_czry where czry_dm =p_czryDm;
  end;
     SET v_czry_qxswjg =func_get_qxswjg(v_czry_swjg) ;

  SET dyn_select =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('select ', 'sd1.dcode as ywzldm,sd1.dname as ywzlmc,TT.sbywdm,TT.sbywmc,IFNULL(cnt, 0) as cnt,IFNULL(cqcnt, 0) as cqcnt '), 'from SYS_DICT sd1 '), 'left join   '), '(select sbzl_dm,sbywb_dm as sbywdm,sd2.dname as sbywmc,count(*) as cnt  '), ' ,sum(case when flglcd in (''A'',''B'') then case when sbzl_dm in (''TSSB'') and (ORA_DATE_DIFF(CURRENT_TIMESTAMP, sbrq))>5 then 1 else 0 end else case when sbzl_dm in (''TSSB'') and (ORA_DATE_DIFF(CURRENT_TIMESTAMP, sbrq))>10 then 1 else 0 end end) as cqcnt '), 'from v_sbxx_sbdr_filemode vs '), 'left join SYS_DICT sd2 on sd2.dtype=''ywlx_dm'' and sd2.dcode=vs.sbywb_dm '), 'where vs.swjg_dm like '''), v_czry_qxswjg), ''' and '), '( '), ' (vs.sbr is not null and vs.sbr='''), p_czryDm), ''') or '), ' (vs.sbr is null and ( '), 'exists (select 1 from sys_cfg_czry_fpgl sc2 '), 'where sc2.czry_dm='''), p_czryDm), ''' and sc2.swjg_dm like ORA_CONCAT(ORA_CONCAT(''%'', vs.swjg_dm), ''%'') and sc2.qybz=''Y'' '), ' and (vs.sbywb_dm=''A0101001'' or '), '( (coalesce(sc2.zsjg_dm_set,'' '')='' '' or vs.zs_swjg_dm is null or sc2.zsjg_dm_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.zs_swjg_dm), ''%'')) '), 'and (coalesce(sc2.zgswry_dm_set,'' '')='' '') '), 'and (coalesce(sc2.flgl_set,'' '')='' '' or sc2.flgl_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.flglcd), ''%'')) '), 'and (vs.sbzl_dm<>''TSSB'' OR (coalesce(sc2.jsmode_set,'' '')='' '' or sc2.jsmode_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.tsjsfs_dm), ''%'')))))))) '), ') '), 'group by sbzl_dm,sbywb_dm,sd2.dname '), ') TT on sd1.dtype=''ywzl_dm'' and sd1.dcode=TT.sbzl_dm '), 'where sd1.dtype=''ywzl_dm'' '), 'order by ywzldm,sbywdm');

  SET dyn_select = CONCAT('WITH BJTS_RESULT_SOURCE (v_ywzldm, v_ywzlmc, v_sbywdm, v_sbywmc, v_cnt, v_cqcnt) AS (', dyn_select, ') SELECT v_ywzldm AS YWZLDM,
       v_ywzlmc AS YWZLMC,
       v_sbywdm AS SBYWDM,
       v_sbywmc AS SBYWMC,
       v_cnt AS NUM,
       v_cqcnt AS CQCNT FROM BJTS_RESULT_SOURCE');
  SET @BJTS_RESULT_SQL_001 = dyn_select;
  PREPARE BJTS_RESULT_STMT_001 FROM @BJTS_RESULT_SQL_001;
  EXECUTE BJTS_RESULT_STMT_001;
  DEALLOCATE PREPARE BJTS_RESULT_STMT_001;


END$$

DELIMITER ;
