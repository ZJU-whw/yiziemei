DELIMITER $$

DROP PROCEDURE IF EXISTS FUNC_GET_SBHZXX_TSSWJG$$

CREATE PROCEDURE func_get_sbhzxx_tsswjg(p_czryDm VARCHAR(4000))
routine_body: BEGIN
  -- Oracle REF CURSOR type removed; target uses a result set;
  DECLARE dyn_select VARCHAR(1500);
  DECLARE i DECIMAL(38,10) DEFAULT 0;
  DECLARE v_ywzldm VARCHAR(20);
  DECLARE v_ywzlmc VARCHAR(50);
  DECLARE v_sbywdm VARCHAR(20);
  DECLARE v_sbywmc VARCHAR(50);
  DECLARE v_cnt BIGINT;


  SET dyn_select =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('select ', 'sd1.dcode as ywzldm,sd1.dname as ywzlmc,TT.sbywdm,TT.sbywmc,IFNULL(cnt, 0) as cnt '), 'from SYS_DICT sd1 '), 'left join   '), '(select sbzl_dm,sbywb_dm as sbywdm,sd2.dname as sbywmc,count(*) as cnt  '), 'from v_sbxx_sbdr_filemode vs '), 'inner join dm_czry dc on dc.czry_dm='''), p_czryDm), ''' and vs.swjg_dm =dc.swjg_dm '), 'left join SYS_DICT sd2 on sd2.dtype=''ywlx_dm'' and sd2.dcode=vs.sbywb_dm '), 'where '), '( '), ' (vs.sbr is not null and vs.sbr='''), p_czryDm), ''') or '), ' (vs.sbr is null and ( '), 'not exists (select 1 from sys_cfg_czry_fpgl sc1 '), 'where sc1.czry_dm=dc.czry_dm and sc1.swjg_dm=dc.swjg_dm and sc1.qybz=''Y'') or '), 'exists (select 1 from sys_cfg_czry_fpgl sc2 '), 'where sc2.czry_dm=dc.czry_dm and sc2.swjg_dm=dc.swjg_dm and sc2.qybz=''Y'' '), 'and (coalesce(sc2.zsjg_dm_set,'' '')='' '' or vs.zs_swjg_dm is null or sc2.zsjg_dm_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.zs_swjg_dm), ''%'')) '), 'and (coalesce(sc2.zgswry_dm_set,'' '')='' '') '), 'and (coalesce(sc2.flgl_set,'' '')='' '' or sc2.flgl_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.flglcd), ''%'')) '), 'and (coalesce(sc2.jsmode_set,'' '')='' '' or sc2.jsmode_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.tsjsfs_dm), ''%''))))) '), ') '), 'group by sbzl_dm,sbywb_dm,sd2.dname '), ') TT on sd1.dtype=''ywzl_dm'' and sd1.dcode=TT.sbzl_dm '), 'where sd1.dtype=''ywzl_dm'' '), 'order by ywzldm,sbywdm');

  SET dyn_select = CONCAT('WITH BJTS_RESULT_SOURCE (v_ywzldm, v_ywzlmc, v_sbywdm, v_sbywmc, v_cnt) AS (', dyn_select, ') SELECT v_ywzldm AS YWZLDM,
       v_ywzlmc AS YWZLMC,
       v_sbywdm AS SBYWDM,
       v_sbywmc AS SBYWMC,
       v_cnt AS NUM,
       NULL AS CQCNT FROM BJTS_RESULT_SOURCE');
  SET @BJTS_RESULT_SQL_001 = dyn_select;
  PREPARE BJTS_RESULT_STMT_001 FROM @BJTS_RESULT_SQL_001;
  EXECUTE BJTS_RESULT_STMT_001;
  DEALLOCATE PREPARE BJTS_RESULT_STMT_001;


END$$

DELIMITER ;
