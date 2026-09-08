DELIMITER $$

DROP PROCEDURE IF EXISTS FUNC_GET_WJDR_COUNT$$

CREATE PROCEDURE func_get_wjdr_count(p_czryDm VARCHAR(4000), OUT P_RESULT integer)
routine_body: BEGIN
  DECLARE dyn_select VARCHAR(1500);
  DECLARE v_czry_qxswjg VARCHAR(11);
  DECLARE v_czry_swjg VARCHAR(11);
  DECLARE v_cnt BIGINT;


  begin
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
       -- DBMS_OUTPUT.put_line('操作员不存在');
       SET P_RESULT = 0; LEAVE routine_body;

  END;
select IFNULL(qx_swjg, swjg_dm) into v_czry_swjg
      from dm_czry where czry_dm =p_czryDm;
  end;
  SET v_czry_qxswjg =func_get_qxswjg(v_czry_swjg) ;

  SET dyn_select =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('select count(1) from v_sbxx_sbdr_filemode vs ', ' where vs.swjg_dm like '''), v_czry_qxswjg), ''' and vs.sbr is null and ( '), ' (vs.zs_swjg_dm is not null and  '), ' not exists (select 1 from sys_cfg_czry_fpgl sc1 '), ' where sc1.swjg_dm like ORA_CONCAT(ORA_CONCAT(''%'', vs.swjg_dm), ''%'') and sc1.qybz=''Y'' '), ' and (coalesce(sc1.zsjg_dm_set,'' '')='' '' or sc1.zsjg_dm_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.zs_swjg_dm), ''%'')) '), ' and (coalesce(sc1.flgl_set,'' '')='' '' or sc1.flgl_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.flglcd), ''%'')) '), ' and (vs.sbzl_dm<>''TSSB'' OR (coalesce(sc1.jsmode_set,'' '')='' '' or sc1.jsmode_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.tsjsfs_dm), ''%'')))) '), ' ) or '), ' (vs.zs_swjg_dm is null and  '), ' not exists (select 1 from sys_cfg_czry_fpgl sc2 '), ' where sc2.swjg_dm like ORA_CONCAT(ORA_CONCAT(''%'', vs.swjg_dm), ''%'') and sc2.qybz=''Y'' '), ' and (coalesce(sc2.zsjg_dm_set,'' '')='' '') '), ' and (coalesce(sc2.flgl_set,'' '')='' '' or sc2.flgl_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.flglcd), ''%'')) '), ' and (vs.sbzl_dm<>''TSSB'' OR (coalesce(sc2.jsmode_set,'' '')='' '' or sc2.jsmode_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.tsjsfs_dm), ''%'')))) '), ' ))');

  SET @BJTS_DYNAMIC_OUT_001_001 = NULL;
SET @BJTS_DYNAMIC_SQL_001 = CONCAT(TRIM(TRAILING ';' FROM dyn_select), ' INTO @BJTS_DYNAMIC_OUT_001_001');
PREPARE BJTS_DYNAMIC_STMT_001 FROM @BJTS_DYNAMIC_SQL_001;
EXECUTE BJTS_DYNAMIC_STMT_001;
DEALLOCATE PREPARE BJTS_DYNAMIC_STMT_001;
SET v_cnt = @BJTS_DYNAMIC_OUT_001_001;

  SET P_RESULT = v_cnt; LEAVE routine_body;
END$$

DELIMITER ;
