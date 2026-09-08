DELIMITER $$

DROP PROCEDURE IF EXISTS FUNC_GET_RANDOM_SBR$$

CREATE PROCEDURE func_get_random_sbr(p_sbid DECIMAL(38,10), OUT P_RESULT VARCHAR(4000))
routine_body: BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';
  DECLARE dyn_select VARCHAR(1500);
  DECLARE v_ywlx VARCHAR(10);
  DECLARE v_sbr VARCHAR(20);
  DECLARE v_sbywbDm VARCHAR(20);
  DECLARE v_swjgDm VARCHAR(11);
  DECLARE v_tsjsfs_dm char(1);
  DECLARE v_flglcd char(1);
  DECLARE v_zs_swjg_dm VARCHAR(11);
  DECLARE v_sjfd integer;


  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
    -- DBMS_OUTPUT.put_line('检索为空：'||sqlerrm);
    rollback;
    SET P_RESULT = '100'; LEAVE routine_body;

  END;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
    rollback;
    -- DBMS_OUTPUT.put_line('异常：'||sqlerrm);
    SET P_RESULT = '900'; LEAVE routine_body;


  END;
SET v_sbr ='';
  SET dyn_select =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('select sb.sbywb_dm,dj.swjg_dm,dj.zs_swjg_dm,dj.tsjsfs_dm,sb.sbr,IFNULL(kz.kzxx, ''C'') as flglcd ', ' from gs_dj_cktmsdab dj '), ' left join gs_dj_cktmsdab_kz kz on kz.nsrdzdah=dj.nsrdzdah '), ' and kzlx=''FLGLCD'' and CURRENT_TIMESTAMP between st_date and end_date and flag=''1'' '), ' ,sb_sbxx_hz sb '), ' where sb.id='), CAST(p_sbid AS CHAR)), ' and sb.nsrdzdah=dj.nsrdzdah  and 1=1 LIMIT 1');
  -- DBMS_OUTPUT.put_line(dyn_select);
  SET @BJTS_DYNAMIC_OUT_001_001 = NULL;
SET @BJTS_DYNAMIC_OUT_001_002 = NULL;
SET @BJTS_DYNAMIC_OUT_001_003 = NULL;
SET @BJTS_DYNAMIC_OUT_001_004 = NULL;
SET @BJTS_DYNAMIC_OUT_001_005 = NULL;
SET @BJTS_DYNAMIC_OUT_001_006 = NULL;
SET @BJTS_DYNAMIC_SQL_001 = CONCAT(TRIM(TRAILING ';' FROM dyn_select), ' INTO @BJTS_DYNAMIC_OUT_001_001, @BJTS_DYNAMIC_OUT_001_002, @BJTS_DYNAMIC_OUT_001_003, @BJTS_DYNAMIC_OUT_001_004, @BJTS_DYNAMIC_OUT_001_005, @BJTS_DYNAMIC_OUT_001_006');
PREPARE BJTS_DYNAMIC_STMT_001 FROM @BJTS_DYNAMIC_SQL_001;
EXECUTE BJTS_DYNAMIC_STMT_001;
DEALLOCATE PREPARE BJTS_DYNAMIC_STMT_001;
SET v_sbywbDm = @BJTS_DYNAMIC_OUT_001_001;
SET v_swjgDm = @BJTS_DYNAMIC_OUT_001_002;
SET v_zs_swjg_dm = @BJTS_DYNAMIC_OUT_001_003;
SET v_tsjsfs_dm = @BJTS_DYNAMIC_OUT_001_004;
SET v_sbr = @BJTS_DYNAMIC_OUT_001_005;
SET v_flglcd = @BJTS_DYNAMIC_OUT_001_006;

  -- 判断税务机关是否启用随机分单
  SET dyn_select =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('select count(1) from sys_cfg_sbdr_filemode ', ' where codetype=''GS'' and code='''), v_swjgDm), ''' and jd_mode=''1''');
  -- DBMS_OUTPUT.put_line(dyn_select);
  SET @BJTS_DYNAMIC_OUT_002_001 = NULL;
SET @BJTS_DYNAMIC_SQL_002 = CONCAT(TRIM(TRAILING ';' FROM dyn_select), ' INTO @BJTS_DYNAMIC_OUT_002_001');
PREPARE BJTS_DYNAMIC_STMT_002 FROM @BJTS_DYNAMIC_SQL_002;
EXECUTE BJTS_DYNAMIC_STMT_002;
DEALLOCATE PREPARE BJTS_DYNAMIC_STMT_002;
SET v_sjfd = @BJTS_DYNAMIC_OUT_002_001;
  if v_sjfd = 0 then
    -- DBMS_OUTPUT.put_line('未启用随机分单');
    SET P_RESULT = '000'; LEAVE routine_body;
  end if;

  if coalesce(v_sbr,' ')<>' ' then
    -- DBMS_OUTPUT.put_line('已有接单人'||v_sbr);
    SET P_RESULT = '001'; LEAVE routine_body;
  end if;
  if v_sbywbDm='A0305001' then
    SET v_ywlx ='_sc';
  else if v_sbywbDm='A0301001' or v_sbywbDm='A0304001' then
    SET v_ywlx ='_wm';
  else
    SET v_ywlx ='_qt';
  end if;
  end if;
  SET dyn_select =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('select czry_dm from (', 'select czry_dm,row_number() OVER(order by IFNULL(cnt_sc, 0)+IFNULL(cnt_wm, 0)+IFNULL(cnt_qt, 0)) as RN'), ' from SYS_CFG_CZRY_FPGL t1'), ' where t1.swjg_dm like ''%'), v_swjgDm), '%'''), ' and (limit'), v_ywlx), ' is null or IFNULL(cnt'), v_ywlx), ',0)<limit'), v_ywlx), ')'), ' and (coalesce(t1.zsjg_dm_set,'' '')='' '' or '''), v_zs_swjg_dm), ''' is null or t1.zsjg_dm_set like ''%'), v_zs_swjg_dm), '%'') '), ' and (coalesce(t1.zgswry_dm_set,'' '')='' '') '), ' and (coalesce(t1.flgl_set,'' '')='' '' or t1.flgl_set like ''%'), v_flglcd), '%'') '), ' and (coalesce(t1.jsmode_set,'' '')='' '' or t1.jsmode_set like ''%'), v_tsjsfs_dm), '%'') '), ' and qybz=''Y'') TT where TT.RN=1');

  -- DBMS_OUTPUT.put_line(dyn_select);
  SET @BJTS_DYNAMIC_OUT_003_001 = NULL;
SET @BJTS_DYNAMIC_SQL_003 = CONCAT(TRIM(TRAILING ';' FROM dyn_select), ' INTO @BJTS_DYNAMIC_OUT_003_001');
PREPARE BJTS_DYNAMIC_STMT_003 FROM @BJTS_DYNAMIC_SQL_003;
EXECUTE BJTS_DYNAMIC_STMT_003;
DEALLOCATE PREPARE BJTS_DYNAMIC_STMT_003;
SET v_sbr = @BJTS_DYNAMIC_OUT_003_001;

  update sb_sbxx_hz set sbr=v_sbr where id=p_sbid;
  SET dyn_select =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('update SYS_CFG_CZRY_FPGL set cnt', v_ywlx), '= IFNULL(cnt'), v_ywlx), ',0) + 1'), ' where czry_dm='''), v_sbr), '''');
  -- DBMS_OUTPUT.put_line(dyn_select);
  SET @BJTS_DYNAMIC_SQL_004 = dyn_select;
PREPARE BJTS_DYNAMIC_STMT_004 FROM @BJTS_DYNAMIC_SQL_004;
EXECUTE BJTS_DYNAMIC_STMT_004;
DEALLOCATE PREPARE BJTS_DYNAMIC_STMT_004;
  commit;

  -- DBMS_OUTPUT.put_line('sbr='||v_sbr);
  SET P_RESULT = '000'; LEAVE routine_body;

  END$$

DELIMITER ;
