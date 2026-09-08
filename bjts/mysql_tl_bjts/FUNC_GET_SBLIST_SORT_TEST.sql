DELIMITER $$

DROP PROCEDURE IF EXISTS FUNC_GET_SBLIST_SORT_TEST$$

CREATE PROCEDURE func_get_sblist_Sort_test(p_czryDm VARCHAR(4000),p_sbywbDm VARCHAR(4000),
       p_sort VARCHAR(4000),p_offset DECIMAL(38,10),p_rows DECIMAL(38,10),p_filter VARCHAR(4000))
routine_body: BEGIN
  -- Oracle REF CURSOR type removed; target uses a result set;
  DECLARE dyn_select VARCHAR(1500);
  DECLARE sorting VARCHAR(200);
  DECLARE startRow DECIMAL(38,10);
  DECLARE endRow DECIMAL(38,10);
  DECLARE i DECIMAL(38,10) DEFAULT 0;
  DECLARE v_filter VARCHAR(100);
  DECLARE v_sbid BIGINT;
  DECLARE v_sssq VARCHAR(10);
  DECLARE v_sbpc BIGINT;
  DECLARE v_sbrq DATETIME;
  DECLARE v_qyhgdm VARCHAR(32);
  DECLARE v_nsrmc VARCHAR(100);
  DECLARE v_sbywbdm VARCHAR(20);
  DECLARE v_flglcd VARCHAR(2);
  DECLARE v_zzsbb char(1);
  DECLARE v_swjg_jc VARCHAR(80);
  DECLARE v_czry_qxswjg VARCHAR(11);
  DECLARE v_czry_swjg VARCHAR(11);


  -- 提取操作员的退税税务机关代码，并计算权限机关代码
  begin
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
       DO '操作员不存在';
       SELECT NULL AS SBID, NULL AS SSSQ, NULL AS SBRQ, NULL AS QYHGDM, NULL AS NSRMC, NULL AS SBYWBDM, NULL AS FLGLCD, NULL AS ZZSBB, NULL AS ZS_SWJG_MC, NULL AS TS_SWJG_MC, NULL AS TSJSFS, NULL AS SBYWBMC, NULL AS SBTMSE, NULL AS YDCNT, NULL AS YJCNT, NULL AS CQBZ WHERE 1 = 0; LEAVE routine_body;

  END;
select swjg_dm into v_czry_swjg
      from dm_czry where czry_dm =p_czryDm;
  end;
  SET v_czry_qxswjg =func_get_qxswjg(v_czry_swjg) ;

  if p_offset <= 0 then
    SET startRow =1;
  else
    SET startRow =p_offset;
  end if;
  if p_rows <= 0 then
    SET endRow =100000000;
  else
    SET endRow =startRow + p_rows -1;
  end if;
  if IFNULL(p_sort, ' ') = ' ' then
     SET sorting ='sbrq asc';
  else
     SET sorting =p_sort;
  end if;
  if (IFNULL(p_filter, ' ') = ' ')  then
     SET v_filter ='';
  else
     SET v_filter =ORA_CONCAT(ORA_CONCAT(' and ', p_filter), ' ');
  end if;
  SET dyn_select =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('select sbid,sssq,sbpc,sbrq,qyhgdm,nsrmc,sbywb_dm,flglcd,zzsbb,swjg_jc from ', '(select vs.sbid, vs.sssq, vs.sbpc, vs.sbrq, vs.qyhgdm, vs.nsrmc, vs.sbywb_dm,vs.flglcd,vs.zzsbb,vs.swjg_jc,'), '     row_number() over(ORDER BY '), sorting), ') rn '), 'from v_sbxx_sbdr_filemode vs '), 'where vs.swjg_dm like '''), v_czry_qxswjg), ''' and '), 'vs.sbywb_dm='''), p_sbywbDm), ''' '), v_filter), 'and ( '), ' (vs.sbr is not null and vs.sbr='''), p_czryDm), ''') or '), ' (vs.sbr is null and ( '), 'exists (select 1 from sys_cfg_czry_fpgl sc2 '), 'where sc2.czry_dm='''), p_czryDm), ''' and sc2.swjg_dm like ORA_CONCAT(ORA_CONCAT(''%'', vs.swjg_dm), ''%'') and sc2.qybz=''Y'' '), ' and (vs.sbywb_dm=''A0101001'' or '), '( (coalesce(sc2.zsjg_dm_set,'' '')='' '' or vs.zs_swjg_dm is null or sc2.zsjg_dm_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.zs_swjg_dm), ''%'')) '), 'and (coalesce(sc2.zgswry_dm_set,'' '')='' '') '), 'and (coalesce(sc2.flgl_set,'' '')='' '' or sc2.flgl_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.flglcd), ''%'')) '), 'and (coalesce(sc2.jsmode_set,'' '')='' '' or sc2.jsmode_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.tsjsfs_dm), ''%''))))))) '), ')) TT where rn between '), startRow), ' and '), endRow), ' order by rn');


  SET dyn_select = CONCAT('WITH BJTS_RESULT_SOURCE (v_sbid, v_sssq, v_sbpc, v_sbrq, v_qyhgdm, v_nsrmc, v_sbywbdm, v_flglcd, v_zzsbb, v_swjg_jc) AS (', dyn_select, ') SELECT v_sbid AS SBID,
       case when v_sbywbdm=''A0301001'' then ORA_CONCAT(v_sssq, LPAD(CAST(v_sbpc AS CHAR), 2, ''0'')) else v_sssq end AS SSSQ,
       v_sbrq AS SBRQ,
       v_qyhgdm AS QYHGDM,
       v_nsrmc AS NSRMC,
       v_sbywbdm AS SBYWBDM,
       v_flglcd AS FLGLCD,
       v_zzsbb AS ZZSBB,
       v_swjg_jc AS ZS_SWJG_MC,
       '''' AS TS_SWJG_MC,
       '''' AS TSJSFS,
       '''' AS SBYWBMC,
       0 AS SBTMSE,
       0 AS YDCNT,
       0 AS YJCNT,
       0 AS CQBZ FROM BJTS_RESULT_SOURCE');
  SET @BJTS_RESULT_SQL_001 = dyn_select;
  PREPARE BJTS_RESULT_STMT_001 FROM @BJTS_RESULT_SQL_001;
  EXECUTE BJTS_RESULT_STMT_001;
  DEALLOCATE PREPARE BJTS_RESULT_STMT_001;


END$$

DELIMITER ;
