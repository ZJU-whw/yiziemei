-- mysql_tl_bjts_汇总.sql
-- 汇总 mysql_tl_bjts 目录的 114 个函数/存储过程脚本，按原文件名排序。
-- 执行前请选择目标数据库，并在同一数据库中依次安装共享对象：
-- bjts/mysql_added/mysql_extra.sql
-- bjts/mysql_added/mysql_extra_seq_nextval_fix.sql
-- 使用支持 DELIMITER 的客户端一次执行整个文件。
-- 各段保留原脚本的 DROP/CREATE、注释及 DELIMITER 语句。
-- 单独脚本更新后，应重新生成本汇总文件。

-- ======================================================================
-- [001/114] BEGIN SOURCE: COMPUTE_BLDATE.sql
-- ======================================================================
DELIMITER $$

DROP FUNCTION IF EXISTS COMPUTE_BLDATE$$

CREATE FUNCTION COMPUTE_BLDATE
/*
  编制人:毛小东
  编制日期:202109
  功能:计算两个日期之间，减去节假日，返回工作日天数
  参数:SL_DATE 开始日期，SB_DATE 结束日期
  返回：NUMBER 天数
 */
(
  END_DATE DATETIME,
  BEGIN_DATE DATETIME
)
RETURNS DECIMAL(38,10)
NOT DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE V_END_DATE DATETIME;
  DECLARE V_BEGIN_DATE DATETIME;
  DECLARE V_BETWEENDAYS DECIMAL(38,10);
  DECLARE V_JJRDAYS INTEGER;

  SET V_END_DATE =END_DATE;
  IF V_END_DATE IS NULL THEN
    SET V_END_DATE =CURRENT_TIMESTAMP;
  END IF;

  SET V_BEGIN_DATE =BEGIN_DATE;
  IF V_BEGIN_DATE IS NULL THEN
    SET V_BEGIN_DATE =CURRENT_TIMESTAMP;
  END IF;

  -- 传递的开始日期只有日期，没有时间，以当天8点30分为开始时间
  IF V_BEGIN_DATE=DATE(V_BEGIN_DATE) THEN
    SET V_BEGIN_DATE =ORA_DATE_ADD(DATE(V_BEGIN_DATE), 0.3542);
  END IF;
  -- 传递的开始日期在下午17点30分之后，以次日8点30分为开始时间
  IF V_BEGIN_DATE>=ORA_DATE_ADD(DATE(V_BEGIN_DATE), 0.7295) THEN
    SET V_BEGIN_DATE =ORA_DATE_ADD(DATE(V_BEGIN_DATE), 1.3542);
  END IF;
  -- 剔除开始日期是节假日，以后续第一个工作日8点30分为开始时间
  SELECT COUNT(*) INTO V_JJRDAYS FROM PUB_JJR WHERE JJR_DATE = DATE(V_BEGIN_DATE);
  BJTS_LOOP_002: LOOP
    IF V_JJRDAYS=0 THEN LEAVE BJTS_LOOP_002; END IF;
    SET V_BEGIN_DATE = ORA_DATE_ADD(DATE(V_BEGIN_DATE), 1.3542);
    SELECT COUNT(*) INTO V_JJRDAYS FROM PUB_JJR WHERE JJR_DATE = DATE(V_BEGIN_DATE);
  END LOOP BJTS_LOOP_002;

  -- 传递的结束日期只有日期，没有时间，以当天17点30分为结束时间
  IF V_END_DATE=DATE(V_END_DATE) THEN
    SET V_END_DATE =ORA_DATE_ADD(DATE(V_END_DATE), 0.7295);
  END IF;
  -- 传递的结束日期在下午17点30分之后，以当天17点30分为结束时间
  IF V_END_DATE>=ORA_DATE_ADD(DATE(V_END_DATE), 0.7295) THEN
    SET V_END_DATE =ORA_DATE_ADD(DATE(V_END_DATE), 0.7295);
  END IF;
  -- 剔除结束日期是节假日，以前一个工作日17点30分为结束时间
  SELECT COUNT(*) INTO V_JJRDAYS FROM PUB_JJR WHERE JJR_DATE = DATE(V_END_DATE);
  BJTS_LOOP_001: LOOP
    IF V_JJRDAYS=0 THEN LEAVE BJTS_LOOP_001; END IF;
    SET V_END_DATE = ORA_DATE_ADD(ORA_DATE_ADD(DATE(V_END_DATE), -(1)), 0.7295);
    SELECT COUNT(*) INTO V_JJRDAYS FROM PUB_JJR WHERE JJR_DATE = DATE(V_END_DATE);
  END LOOP BJTS_LOOP_001;

  -- 起始、截止日期均非节假日时，计算日期差
  SET V_BETWEENDAYS = ORA_DATE_DIFF(V_END_DATE, V_BEGIN_DATE);

  -- 剔除日期间隔中的节假日天数
  SELECT COUNT(*) INTO V_JJRDAYS FROM PUB_JJR WHERE JJR_DATE > V_BEGIN_DATE AND JJR_DATE < V_END_DATE;
  SET V_BETWEENDAYS = V_BETWEENDAYS - V_JJRDAYS;

  IF V_BETWEENDAYS < 0 THEN
    RETURN (0);
  ELSE
    RETURN(V_BETWEENDAYS);
  END IF;
END$$

DELIMITER ;

-- END SOURCE: COMPUTE_BLDATE.sql

-- ======================================================================
-- [002/114] BEGIN SOURCE: COMPUTE_BLJZDATE.sql
-- ======================================================================
DELIMITER $$

DROP FUNCTION IF EXISTS COMPUTE_BLJZDATE$$

CREATE FUNCTION COMPUTE_BLJZDATE
/*
  编制人:毛小东
  编制日期:202109
  功能:根据分类管理等级，增加工作日，其中A+5, B+10, C+15, D+20，默认20，返回截止日期
  参数:CKQYGLLB_DM 分类管理等级A,B,C,D  ；SL_DATE 开始受理日期
  返回：date 办理截止日期
 */
(
  V_IN_CKQYGLLB_DM VARCHAR(4000),
  V_IN_SL_DATE DATETIME
)
RETURNS DATETIME
NOT DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE v_adddays integer;
  DECLARE v_jjrdays integer;
  DECLARE v_zz_date DATETIME;
  DECLARE i integer;

  IF V_IN_SL_DATE IS NULL THEN
    RETURN NULL;
  END IF;

  IF V_IN_CKQYGLLB_DM = 'A' OR V_IN_CKQYGLLB_DM = 'a' THEN
    SET v_adddays = 5;
  ELSEIF V_IN_CKQYGLLB_DM = 'B' OR V_IN_CKQYGLLB_DM = 'b' THEN
    SET v_adddays = 10;
  ELSEIF V_IN_CKQYGLLB_DM = 'C' OR V_IN_CKQYGLLB_DM = 'c' THEN
    SET v_adddays = 15;
  ELSEIF V_IN_CKQYGLLB_DM = 'D' OR V_IN_CKQYGLLB_DM = 'd' THEN
    SET v_adddays = 20;
  ELSE
    SET v_adddays = 20;
  END IF;

  -- 节假日
  SET v_zz_date = V_IN_SL_DATE;
  BEGIN
  DECLARE BJTS_FOR_I_001 DECIMAL(65,30) DEFAULT 1;
  DECLARE BJTS_FOR_END_001 DECIMAL(65,30) DEFAULT v_adddays;
  WHILE BJTS_FOR_I_001 <= BJTS_FOR_END_001 DO
    SET v_zz_date = ORA_DATE_ADD(v_zz_date, 1);
    SET v_jjrdays = 1;
    BJTS_WHILE_001: WHILE v_jjrdays = 1 DO
      select count(*) into v_jjrdays from PUB_JJR where jjr_date = DATE(v_zz_date);
      IF v_jjrdays > 0 THEN
        SET v_zz_date = ORA_DATE_ADD(v_zz_date, 1);
      END IF;

END WHILE BJTS_WHILE_001;

    SET BJTS_FOR_I_001 = BJTS_FOR_I_001 + 1;
  END WHILE;
END;

  return(v_zz_date);
END$$

DELIMITER ;

-- END SOURCE: COMPUTE_BLJZDATE.sql

-- ======================================================================
-- [003/114] BEGIN SOURCE: FUNC_GET_JDFWMS.sql
-- ======================================================================
DELIMITER $$

DROP FUNCTION IF EXISTS FUNC_GET_JDFWMS$$

CREATE function FUNC_GET_JDFWMS(pv_czry_dm VARCHAR(4000))
RETURNS VARCHAR(4000)
NOT DETERMINISTIC
READS SQL DATA
BEGIN
-- 函数：操作员的接单范围描述
  DECLARE v_Result VARCHAR(1000);
  DECLARE v_swjgSet VARCHAR(200);
  DECLARE v_zsjgSet VARCHAR(500);
  DECLARE v_flglSet VARCHAR(20);
  DECLARE v_jsModeSet VARCHAR(20);
  DECLARE v_val VARCHAR(20);
  DECLARE v_TmpStr VARCHAR(2000);
  DECLARE v_TmpVal VARCHAR(100);
  DECLARE v_JDMode Char(1);
  DECLARE v_ISJDR char(1);
--  i integer;







  begin
  DECLARE BJTS_SQLCODE_005 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_005 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_005 = MYSQL_ERRNO, BJTS_SQLERRM_005 = MESSAGE_TEXT;
     return '未获取操作员的税务机关';

  END;
select swjg_dm
     into v_swjgSet
     from DM_CZRY
     where czry_dm=pv_czry_dm;
  end;

  SET v_Result ='';

  -- 处理退税机关集合
  if v_swjgSet is not null then
    SET v_TmpStr ='';
    BEGIN
  DECLARE BJTS_FETCH_DONE_004 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_RS_CUR_COLUMN_VALUE_004 LONGTEXT;
  DECLARE BJTS_FETCH_CURSOR_004 CURSOR FOR
SELECT BJTS_SPLIT_ITEM.COLUMN_VALUE
  FROM JSON_TABLE(ORA_SPLIT_JSON((v_swjgSet), (',')),
       '$[*]' COLUMNS (COLUMN_VALUE VARCHAR(4000) PATH '$')
  ) AS BJTS_SPLIT_ITEM;
  OPEN BJTS_FETCH_CURSOR_004;
  BJTS_FETCH_LOOP_004: LOOP
      BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_FETCH_DONE_004 = TRUE;
      FETCH BJTS_FETCH_CURSOR_004 INTO BJTS_RS_CUR_COLUMN_VALUE_004;
    END;
    IF BJTS_FETCH_DONE_004 THEN
      LEAVE BJTS_FETCH_LOOP_004;
    END IF;

      SET v_val = BJTS_RS_CUR_COLUMN_VALUE_004;
      begin
  DECLARE BJTS_SQLCODE_004 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_004 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_004 = MYSQL_ERRNO, BJTS_SQLERRM_004 = MESSAGE_TEXT;
        SET v_TmpVal =v_val;

  END;
select swjg_jc into v_TmpVal from DM_SWJG where swjg_dm=v_val;
      end;
      if v_TmpStr is null then
        SET v_TmpStr =v_TmpVal;
      else
        SET v_TmpStr =ORA_CONCAT(ORA_CONCAT(v_TmpStr, ','), v_TmpVal);
      end if;

  END LOOP BJTS_FETCH_LOOP_004;
  CLOSE BJTS_FETCH_CURSOR_004;
END;
    SET v_Result =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(v_Result, ' 退税机关【'), v_TmpStr), '】');
  else
    SET v_Result =ORA_CONCAT(v_Result, ' 退税机关【全部】');
  end if;

  begin
  DECLARE BJTS_SQLCODE_003 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_003 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_003 = MYSQL_ERRNO, BJTS_SQLERRM_003 = MESSAGE_TEXT;
     -- DBMS_OUTPUT.put_line('操作员未设定为接单人');
     SET v_Result = ORA_CONCAT(v_Result, ' 操作员未设定为受理岗接单人');
     SET v_ISJDR ='0';

  END;
select zsjg_dm_set,flgl_set,jsmode_set
     into v_zsjgSet,v_flglSet,v_jsModeSet
     from SYS_CFG_CZRY_FPGL
     where czry_dm=pv_czry_dm and qybz='Y';

     SET v_ISJDR ='1';

  end;

  if v_ISJDR ='1' then
    -- 处理接单方式
      begin
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
            SET v_Result =ORA_CONCAT(v_Result, ' 接单方式【未设置】');

  END;
select jd_mode into v_JDMode from SYS_CFG_SBDR_FILEMODE where code=v_zsjgSet and qybz='Y';
        if v_JDMode = '1' then
            SET v_Result =ORA_CONCAT(v_Result, ' 接单方式【随机分配】');
        else
            SET v_Result =ORA_CONCAT(v_Result, ' 接单方式【分组接单】');
        end if;
      end;

    -- 处理征收分组集合
    if v_zsjgSet is not null then
      SET v_TmpStr ='';
      BEGIN
  DECLARE BJTS_FETCH_DONE_003 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_RS_CUR_COLUMN_VALUE_003 LONGTEXT;
  DECLARE BJTS_FETCH_CURSOR_003 CURSOR FOR
SELECT BJTS_SPLIT_ITEM.COLUMN_VALUE
  FROM JSON_TABLE(ORA_SPLIT_JSON((v_zsjgSet), (',')),
       '$[*]' COLUMNS (COLUMN_VALUE VARCHAR(4000) PATH '$')
  ) AS BJTS_SPLIT_ITEM;
  OPEN BJTS_FETCH_CURSOR_003;
  BJTS_FETCH_LOOP_003: LOOP
        BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_FETCH_DONE_003 = TRUE;
      FETCH BJTS_FETCH_CURSOR_003 INTO BJTS_RS_CUR_COLUMN_VALUE_003;
    END;
    IF BJTS_FETCH_DONE_003 THEN
      LEAVE BJTS_FETCH_LOOP_003;
    END IF;

        SET v_val = BJTS_RS_CUR_COLUMN_VALUE_003;
        begin
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
          SET v_TmpVal =v_val;

  END;
select swjg_jc into v_TmpVal from DM_SWJG where swjg_dm=v_val;
        end;
        if v_TmpStr is null then
          SET v_TmpStr =v_TmpVal;
        else
          SET v_TmpStr =ORA_CONCAT(ORA_CONCAT(v_TmpStr, ','), v_TmpVal);
        end if;

  END LOOP BJTS_FETCH_LOOP_003;
  CLOSE BJTS_FETCH_CURSOR_003;
END;
      SET v_Result =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(v_Result, ' 分片分组【'), v_TmpStr), '】');
    else
      SET v_Result =ORA_CONCAT(v_Result, ' 分片分组【全部】');
    end if;

    -- 处理分类管理集合
    if v_flglSet is not null then
      SET v_TmpStr ='';
      BEGIN
  DECLARE BJTS_FETCH_DONE_002 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_RS_CUR_COLUMN_VALUE_002 LONGTEXT;
  DECLARE BJTS_FETCH_CURSOR_002 CURSOR FOR
SELECT BJTS_SPLIT_ITEM.COLUMN_VALUE
  FROM JSON_TABLE(ORA_SPLIT_JSON((v_flglSet), ('.')),
       '$[*]' COLUMNS (COLUMN_VALUE VARCHAR(4000) PATH '$')
  ) AS BJTS_SPLIT_ITEM;
  OPEN BJTS_FETCH_CURSOR_002;
  BJTS_FETCH_LOOP_002: LOOP
        BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_FETCH_DONE_002 = TRUE;
      FETCH BJTS_FETCH_CURSOR_002 INTO BJTS_RS_CUR_COLUMN_VALUE_002;
    END;
    IF BJTS_FETCH_DONE_002 THEN
      LEAVE BJTS_FETCH_LOOP_002;
    END IF;

        SET v_val = BJTS_RS_CUR_COLUMN_VALUE_002;
        -- DBMS_OUTPUT.put_line('flgl:' || v_val);
        Case
          when v_val='A' then
            SET v_TmpVal ='一类';
          when v_val='B' then
            SET v_TmpVal ='二类';
          when v_val='C' then
            SET v_TmpVal ='三类';
          when v_val='D' then
            SET v_TmpVal ='四类';
          else
            SET v_TmpVal =v_val;
        End Case;
        if v_TmpStr is null then
          SET v_TmpStr =v_TmpVal;
        else
          SET v_TmpStr =ORA_CONCAT(ORA_CONCAT(v_TmpStr, ','), v_TmpVal);
        end if;

  END LOOP BJTS_FETCH_LOOP_002;
  CLOSE BJTS_FETCH_CURSOR_002;
END;
      SET v_Result =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(v_Result, ' 分类管理【'), v_TmpStr), '】');
    else
      SET v_Result =ORA_CONCAT(v_Result, ' 分类管理【全部】');
    end if;
    -- 处理企业类型集合
    if v_jsModeSet is not null then
      SET v_TmpStr ='';
      BEGIN
  DECLARE BJTS_FETCH_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_RS_CUR_COLUMN_VALUE_001 LONGTEXT;
  DECLARE BJTS_FETCH_CURSOR_001 CURSOR FOR
SELECT BJTS_SPLIT_ITEM.COLUMN_VALUE
  FROM JSON_TABLE(ORA_SPLIT_JSON((v_jsModeSet), ('.')),
       '$[*]' COLUMNS (COLUMN_VALUE VARCHAR(4000) PATH '$')
  ) AS BJTS_SPLIT_ITEM;
  OPEN BJTS_FETCH_CURSOR_001;
  BJTS_FETCH_LOOP_001: LOOP
        BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_FETCH_DONE_001 = TRUE;
      FETCH BJTS_FETCH_CURSOR_001 INTO BJTS_RS_CUR_COLUMN_VALUE_001;
    END;
    IF BJTS_FETCH_DONE_001 THEN
      LEAVE BJTS_FETCH_LOOP_001;
    END IF;

        SET v_val = BJTS_RS_CUR_COLUMN_VALUE_001;
        Case
          when v_val='1' then
            SET v_TmpVal ='生产';
          when v_val='2' then
            SET v_TmpVal ='外贸';
          else
            SET v_TmpVal =v_val;
        End Case;
        if v_TmpStr is null then
          SET v_TmpStr =v_TmpVal;
        else
          SET v_TmpStr =ORA_CONCAT(ORA_CONCAT(v_TmpStr, ','), v_TmpVal);
        end if;

  END LOOP BJTS_FETCH_LOOP_001;
  CLOSE BJTS_FETCH_CURSOR_001;
END;
      SET v_Result =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(v_Result, ' 企业类型【'), v_TmpStr), '】');
    else
      SET v_Result =ORA_CONCAT(v_Result, ' 企业类型【全部】');
    end if;

  end if;
  return(v_Result);
END$$

DELIMITER ;

-- END SOURCE: FUNC_GET_JDFWMS.sql

-- ======================================================================
-- [004/114] BEGIN SOURCE: FUNC_GET_QXSWJG.sql
-- ======================================================================
DELIMITER $$

DROP FUNCTION IF EXISTS FUNC_GET_QXSWJG$$

CREATE function FUNC_GET_QXSWJG(swjg_dm VARCHAR(4000))
RETURNS VARCHAR(4000)
NOT DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE v_qxSwjg VARCHAR(11);
  DECLARE i integer;

  if length(swjg_dm)<11 then
     SET v_qxSwjg =swjg_dm;
  else
    begin
      SET i =5;
      BJTS_WHILE_001: WHILE i> 1 DO
        -- DBMS_OUTPUT.put_line('For:'|| to_char(i) || '--' || substr(swjg_dm,2+(i*2),2));
        if substr(swjg_dm,(i*2),2)<>'00' then
          begin
            SET v_qxSwjg =substr(swjg_dm,1,(i*2)+1);
            LEAVE BJTS_WHILE_001;
          end;
        end if;
        SET i =i-1;

END WHILE BJTS_WHILE_001;
      if (i=1) then SET v_qxSwjg = substr(swjg_dm,1,3); end if;
      -- DBMS_OUTPUT.put_line('Result:' || v_qxSwjg);
    end;
  end if;
  if length(v_qxSwjg)<11 then
    SET v_qxSwjg =ORA_CONCAT(v_qxSwjg, '%');
  end if;
  return(v_qxSwjg);
END$$

DELIMITER ;

-- END SOURCE: FUNC_GET_QXSWJG.sql

-- ======================================================================
-- [005/114] BEGIN SOURCE: FUNC_GET_RANDOM_SBR.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS FUNC_GET_RANDOM_SBR$$

CREATE PROCEDURE FUNC_GET_RANDOM_SBR(p_sbid DECIMAL(38,10), OUT P_RESULT VARCHAR(4000))
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
    SET P_RESULT = '100'; -- EXIT HANDLER exits routine_body after preserving the result.

  END;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
    rollback;
    -- DBMS_OUTPUT.put_line('异常：'||sqlerrm);
    SET P_RESULT = '900'; -- EXIT HANDLER exits routine_body after preserving the result.


  END;
SET v_sbr ='';
  SET dyn_select =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('select sb.sbywb_dm,dj.swjg_dm,dj.zs_swjg_dm,dj.tsjsfs_dm,sb.sbr,IFNULL(kz.kzxx, ''C'') as flglcd ', ' from GS_DJ_CKTMSDAB dj '), ' left join GS_DJ_CKTMSDAB_KZ kz on kz.nsrdzdah=dj.nsrdzdah '), ' and kzlx=''FLGLCD'' and CURRENT_TIMESTAMP between st_date and end_date and flag=''1'' '), ' ,SB_SBXX_HZ sb '), ' where sb.id='), CAST(p_sbid AS CHAR)), ' and sb.nsrdzdah=dj.nsrdzdah  and 1=1 LIMIT 1');
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
  SET dyn_select =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('select count(1) from SYS_CFG_SBDR_FILEMODE ', ' where codetype=''GS'' and code='''), v_swjgDm), ''' and jd_mode=''1''');
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

  update SB_SBXX_HZ set sbr=v_sbr where id=p_sbid;
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

-- END SOURCE: FUNC_GET_RANDOM_SBR.sql

-- ======================================================================
-- [006/114] BEGIN SOURCE: FUNC_GET_SBHZXX.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS FUNC_GET_SBHZXX$$

CREATE PROCEDURE FUNC_GET_SBHZXX(p_czryDm VARCHAR(4000))
routine_body: BEGIN
  DECLARE BJTS_ROUTINE_EXIT BOOLEAN DEFAULT FALSE;
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
       SELECT NULL AS YWZLDM, NULL AS YWZLMC, NULL AS SBYWDM, NULL AS SBYWMC, NULL AS NUM, NULL AS CQCNT WHERE 1 = 0; SET BJTS_ROUTINE_EXIT = TRUE;

  END;
select IFNULL(qx_swjg, swjg_dm) into v_czry_swjg
      from DM_CZRY where czry_dm =p_czryDm;
  end;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
     SET v_czry_qxswjg =FUNC_GET_QXSWJG(v_czry_swjg) ;

  SET dyn_select =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('select ', 'sd1.dcode as ywzldm,sd1.dname as ywzlmc,TT.sbywdm,TT.sbywmc,IFNULL(cnt, 0) as cnt,IFNULL(cqcnt, 0) as cqcnt '), 'from SYS_DICT sd1 '), 'left join   '), '(select sbzl_dm,sbywb_dm as sbywdm,sd2.dname as sbywmc,count(*) as cnt  '), ' ,sum(case when flglcd in (''A'',''B'') then case when sbzl_dm in (''TSSB'') and (ORA_DATE_DIFF(CURRENT_TIMESTAMP, sbrq))>5 then 1 else 0 end else case when sbzl_dm in (''TSSB'') and (ORA_DATE_DIFF(CURRENT_TIMESTAMP, sbrq))>10 then 1 else 0 end end) as cqcnt '), 'from V_SBXX_SBDR_FILEMODE vs '), 'left join SYS_DICT sd2 on sd2.dtype=''ywlx_dm'' and sd2.dcode=vs.sbywb_dm '), 'where vs.swjg_dm like '''), v_czry_qxswjg), ''' and '), '( '), ' (vs.sbr is not null and vs.sbr='''), p_czryDm), ''') or '), ' (vs.sbr is null and ( '), 'exists (select 1 from SYS_CFG_CZRY_FPGL sc2 '), 'where sc2.czry_dm='''), p_czryDm), ''' and sc2.swjg_dm like ORA_CONCAT(ORA_CONCAT(''%'', vs.swjg_dm), ''%'') and sc2.qybz=''Y'' '), ' and (vs.sbywb_dm=''A0101001'' or '), '( (coalesce(sc2.zsjg_dm_set,'' '')='' '' or vs.zs_swjg_dm is null or sc2.zsjg_dm_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.zs_swjg_dm), ''%'')) '), 'and (coalesce(sc2.zgswry_dm_set,'' '')='' '') '), 'and (coalesce(sc2.flgl_set,'' '')='' '' or sc2.flgl_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.flglcd), ''%'')) '), 'and (vs.sbzl_dm<>''TSSB'' OR (coalesce(sc2.jsmode_set,'' '')='' '' or sc2.jsmode_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.tsjsfs_dm), ''%'')))))))) '), ') '), 'group by sbzl_dm,sbywb_dm,sd2.dname '), ') TT on sd1.dtype=''ywzl_dm'' and sd1.dcode=TT.sbzl_dm '), 'where sd1.dtype=''ywzl_dm'' '), 'order by ywzldm,sbywdm');

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

-- END SOURCE: FUNC_GET_SBHZXX.sql

-- ======================================================================
-- [007/114] BEGIN SOURCE: FUNC_GET_SBHZXX_QXSWJG.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS FUNC_GET_SBHZXX_QXSWJG$$

CREATE PROCEDURE FUNC_GET_SBHZXX_QXSWJG(p_czryDm VARCHAR(4000))
routine_body: BEGIN
  DECLARE BJTS_ROUTINE_EXIT BOOLEAN DEFAULT FALSE;
  -- Oracle REF CURSOR type removed; target uses a result set;
  DECLARE dyn_select VARCHAR(1500);
  DECLARE i DECIMAL(38,10) DEFAULT 0;
  DECLARE v_ywzldm VARCHAR(20);
  DECLARE v_ywzlmc VARCHAR(50);
  DECLARE v_sbywdm VARCHAR(20);
  DECLARE v_sbywmc VARCHAR(50);
  DECLARE v_cnt BIGINT;
  DECLARE v_czry_qxswjg VARCHAR(11);
  DECLARE v_czry_swjg VARCHAR(11);


  begin
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
       -- DBMS_OUTPUT.put_line('操作员不存在');
       SELECT NULL AS YWZLDM, NULL AS YWZLMC, NULL AS SBYWDM, NULL AS SBYWMC, NULL AS NUM, NULL AS CQCNT WHERE 1 = 0; SET BJTS_ROUTINE_EXIT = TRUE;

  END;
select swjg_dm into v_czry_swjg
      from DM_CZRY where czry_dm =p_czryDm;
  end;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  SET v_czry_qxswjg =FUNC_GET_QXSWJG(v_czry_swjg) ;

  SET dyn_select =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('select ', 'sd1.dcode as ywzldm,sd1.dname as ywzlmc,TT.sbywdm,TT.sbywmc,IFNULL(cnt, 0) as cnt '), 'from SYS_DICT sd1 '), 'left join   '), '(select sbzl_dm,sbywb_dm as sbywdm,sd2.dname as sbywmc,count(*) as cnt  '), 'from V_SBXX_SBDR_FILEMODE vs '), 'left join SYS_DICT sd2 on sd2.dtype=''ywlx_dm'' and sd2.dcode=vs.sbywb_dm '), 'where vs.swjg_dm like '''), v_czry_qxswjg), ''' and '), '( '), ' (vs.sbr is not null and vs.sbr='''), p_czryDm), ''') or '), ' (vs.sbr is null and ( '), 'exists (select 1 from SYS_CFG_CZRY_FPGL sc2 '), 'where sc2.czry_dm='''), p_czryDm), ''' and sc2.swjg_dm like ORA_CONCAT(ORA_CONCAT(''%'', vs.swjg_dm), ''%'') and sc2.qybz=''Y'' '), 'and (coalesce(sc2.zsjg_dm_set,'' '')='' '' or vs.zs_swjg_dm is null or sc2.zsjg_dm_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.zs_swjg_dm), ''%'')) '), 'and (coalesce(sc2.zgswry_dm_set,'' '')='' '') '), 'and (coalesce(sc2.flgl_set,'' '')='' '' or sc2.flgl_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.flglcd), ''%'')) '), 'and (coalesce(sc2.jsmode_set,'' '')='' '' or sc2.jsmode_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.tsjsfs_dm), ''%''))))) '), ') '), 'group by sbzl_dm,sbywb_dm,sd2.dname '), ') TT on sd1.dtype=''ywzl_dm'' and sd1.dcode=TT.sbzl_dm '), 'where sd1.dtype=''ywzl_dm'' '), 'order by ywzldm,sbywdm');

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

-- END SOURCE: FUNC_GET_SBHZXX_QXSWJG.sql

-- ======================================================================
-- [008/114] BEGIN SOURCE: FUNC_GET_SBHZXX_TEST.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS FUNC_GET_SBHZXX_TEST$$

CREATE PROCEDURE FUNC_GET_SBHZXX_TEST(p_czryDm VARCHAR(4000))
routine_body: BEGIN
  DECLARE BJTS_ROUTINE_EXIT BOOLEAN DEFAULT FALSE;
  -- Oracle REF CURSOR type removed; target uses a result set;
  DECLARE dyn_select VARCHAR(1500);
  DECLARE i DECIMAL(38,10) DEFAULT 0;
  DECLARE v_ywzldm VARCHAR(20);
  DECLARE v_ywzlmc VARCHAR(50);
  DECLARE v_sbywdm VARCHAR(20);
  DECLARE v_sbywmc VARCHAR(50);
  DECLARE v_cnt BIGINT;
  DECLARE v_czry_qxswjg VARCHAR(11);
  DECLARE v_czry_swjg VARCHAR(11);


  begin
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
       -- DBMS_OUTPUT.put_line('操作员不存在');
       SELECT NULL AS YWZLDM, NULL AS YWZLMC, NULL AS SBYWDM, NULL AS SBYWMC, NULL AS NUM, NULL AS CQCNT WHERE 1 = 0; SET BJTS_ROUTINE_EXIT = TRUE;

  END;
select swjg_dm into v_czry_swjg
      from DM_CZRY where czry_dm =p_czryDm;
  end;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  SET v_czry_qxswjg =FUNC_GET_QXSWJG(v_czry_swjg) ;

  SET dyn_select =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('select ', 'sd1.dcode as ywzldm,sd1.dname as ywzlmc,TT.sbywdm,TT.sbywmc,IFNULL(cnt, 0) as cnt '), 'from SYS_DICT sd1 '), 'left join   '), '(select sbzl_dm,sbywb_dm as sbywdm,sd2.dname as sbywmc,count(*) as cnt  '), 'from V_SBXX_SBDR_FILEMODE vs '), 'left join SYS_DICT sd2 on sd2.dtype=''ywlx_dm'' and sd2.dcode=vs.sbywb_dm '), 'where vs.swjg_dm like '''), v_czry_qxswjg), ''' and '), '( '), ' (vs.sbr is not null and vs.sbr='''), p_czryDm), ''') or '), ' (vs.sbr is null and ( '), 'exists (select 1 from SYS_CFG_CZRY_FPGL sc2 '), 'where sc2.czry_dm='''), p_czryDm), ''' and sc2.swjg_dm like ORA_CONCAT(ORA_CONCAT(''%'', vs.swjg_dm), ''%'') and sc2.qybz=''Y'' '), ' and (vs.sbywb_dm=''A0101001'' or '), '( (coalesce(sc2.zsjg_dm_set,'' '')='' '' or vs.zs_swjg_dm is null or sc2.zsjg_dm_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.zs_swjg_dm), ''%'')) '), 'and (coalesce(sc2.zgswry_dm_set,'' '')='' '') '), 'and (coalesce(sc2.flgl_set,'' '')='' '' or sc2.flgl_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.flglcd), ''%'')) '), 'and (coalesce(sc2.jsmode_set,'' '')='' '' or sc2.jsmode_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.tsjsfs_dm), ''%''))))))) '), ') '), 'group by sbzl_dm,sbywb_dm,sd2.dname '), ') TT on sd1.dtype=''ywzl_dm'' and sd1.dcode=TT.sbzl_dm '), 'where sd1.dtype=''ywzl_dm'' '), 'order by ywzldm,sbywdm');

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

-- END SOURCE: FUNC_GET_SBHZXX_TEST.sql

-- ======================================================================
-- [009/114] BEGIN SOURCE: FUNC_GET_SBHZXX_TSSWJG.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS FUNC_GET_SBHZXX_TSSWJG$$

CREATE PROCEDURE FUNC_GET_SBHZXX_TSSWJG(p_czryDm VARCHAR(4000))
routine_body: BEGIN
  -- Oracle REF CURSOR type removed; target uses a result set;
  DECLARE dyn_select VARCHAR(1500);
  DECLARE i DECIMAL(38,10) DEFAULT 0;
  DECLARE v_ywzldm VARCHAR(20);
  DECLARE v_ywzlmc VARCHAR(50);
  DECLARE v_sbywdm VARCHAR(20);
  DECLARE v_sbywmc VARCHAR(50);
  DECLARE v_cnt BIGINT;


  SET dyn_select =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('select ', 'sd1.dcode as ywzldm,sd1.dname as ywzlmc,TT.sbywdm,TT.sbywmc,IFNULL(cnt, 0) as cnt '), 'from SYS_DICT sd1 '), 'left join   '), '(select sbzl_dm,sbywb_dm as sbywdm,sd2.dname as sbywmc,count(*) as cnt  '), 'from V_SBXX_SBDR_FILEMODE vs '), 'inner join DM_CZRY dc on dc.czry_dm='''), p_czryDm), ''' and vs.swjg_dm =dc.swjg_dm '), 'left join SYS_DICT sd2 on sd2.dtype=''ywlx_dm'' and sd2.dcode=vs.sbywb_dm '), 'where '), '( '), ' (vs.sbr is not null and vs.sbr='''), p_czryDm), ''') or '), ' (vs.sbr is null and ( '), 'not exists (select 1 from SYS_CFG_CZRY_FPGL sc1 '), 'where sc1.czry_dm=dc.czry_dm and sc1.swjg_dm=dc.swjg_dm and sc1.qybz=''Y'') or '), 'exists (select 1 from SYS_CFG_CZRY_FPGL sc2 '), 'where sc2.czry_dm=dc.czry_dm and sc2.swjg_dm=dc.swjg_dm and sc2.qybz=''Y'' '), 'and (coalesce(sc2.zsjg_dm_set,'' '')='' '' or vs.zs_swjg_dm is null or sc2.zsjg_dm_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.zs_swjg_dm), ''%'')) '), 'and (coalesce(sc2.zgswry_dm_set,'' '')='' '') '), 'and (coalesce(sc2.flgl_set,'' '')='' '' or sc2.flgl_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.flglcd), ''%'')) '), 'and (coalesce(sc2.jsmode_set,'' '')='' '' or sc2.jsmode_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.tsjsfs_dm), ''%''))))) '), ') '), 'group by sbzl_dm,sbywb_dm,sd2.dname '), ') TT on sd1.dtype=''ywzl_dm'' and sd1.dcode=TT.sbzl_dm '), 'where sd1.dtype=''ywzl_dm'' '), 'order by ywzldm,sbywdm');

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

-- END SOURCE: FUNC_GET_SBHZXX_TSSWJG.sql

-- ======================================================================
-- [010/114] BEGIN SOURCE: FUNC_GET_SBLIST.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS FUNC_GET_SBLIST$$

CREATE PROCEDURE FUNC_GET_SBLIST(p_czryDm VARCHAR(4000),p_sbywbDm VARCHAR(4000),p_offset DECIMAL(38,10),p_rows DECIMAL(38,10))
routine_body: BEGIN
  DECLARE i DECIMAL(38,10) DEFAULT 0;
  DECLARE startRow DECIMAL(38,10);
  DECLARE endRow DECIMAL(38,10);


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

  SELECT BJTS_RESULT_SOURCE.sbid AS SBID,
       case when BJTS_RESULT_SOURCE.sbywb_dm='A0301001' then ORA_CONCAT(BJTS_RESULT_SOURCE.sssq, LPAD(CAST(BJTS_RESULT_SOURCE.sbpc AS CHAR), 2, '0')) else BJTS_RESULT_SOURCE.sssq end AS SSSQ,
       BJTS_RESULT_SOURCE.sbrq AS SBRQ,
       BJTS_RESULT_SOURCE.qyhgdm AS QYHGDM,
       BJTS_RESULT_SOURCE.nsrmc AS NSRMC,
       BJTS_RESULT_SOURCE.sbywb_dm AS SBYWBDM,
       BJTS_RESULT_SOURCE.flglcd AS FLGLCD,
       BJTS_RESULT_SOURCE.zzsbb AS ZZSBB,
       BJTS_RESULT_SOURCE.swjg_jc AS ZS_SWJG_MC,
       '' AS TS_SWJG_MC,
       '' AS TSJSFS,
       '' AS SBYWBMC,
       0 AS SBTMSE,
       0 AS YDCNT,
       0 AS YJCNT,
       0 AS CQBZ
  FROM (
select TT.* from
    (select vs.sbid, vs.sssq, vs.sbpc, vs.sbrq, vs.qyhgdm, vs.nsrmc, vs.sbywb_dm,vs.flglcd,vs.zzsbb,vs.swjg_jc,
           row_number() over(ORDER BY vs.sbrq asc) rn
      from V_SBXX_SBDR_FILEMODE vs
      inner join DM_CZRY dc on dc.czry_dm=p_czryDm and vs.swjg_dm =dc.swjg_dm
      where
      vs.sbywb_dm=p_sbywbDm
      and (
      (vs.sbr is not null and vs.sbr=p_czryDm) or
      (vs.sbr is null and (
      not exists (select 1 from SYS_CFG_CZRY_FPGL sc1
      where sc1.czry_dm=dc.czry_dm and sc1.swjg_dm=dc.swjg_dm and sc1.qybz='Y') or
      exists (select 1 from SYS_CFG_CZRY_FPGL sc2
      where sc2.czry_dm=dc.czry_dm and sc2.swjg_dm=dc.swjg_dm and sc2.qybz='Y'
      and (coalesce(sc2.zsjg_dm_set,' ')=' ' or vs.zs_swjg_dm is null or sc2.zsjg_dm_set like ORA_CONCAT(ORA_CONCAT('%', vs.zs_swjg_dm), '%'))
      and (coalesce(sc2.zgswry_dm_set,' ')=' ')
      and (coalesce(sc2.flgl_set,' ')=' ' or sc2.flgl_set like ORA_CONCAT(ORA_CONCAT('%', vs.flglcd), '%'))
      and (vs.sbzl_dm<>'TSSB' OR (coalesce(sc2.jsmode_set,' ')=' ' or sc2.jsmode_set like ORA_CONCAT(ORA_CONCAT('%', vs.tsjsfs_dm), '%'))))))
      ))TT where rn between startRow and endRow
  ) AS BJTS_RESULT_SOURCE;

END$$

DELIMITER ;

-- END SOURCE: FUNC_GET_SBLIST.sql

-- ======================================================================
-- [011/114] BEGIN SOURCE: FUNC_GET_SBLIST_SORT.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS FUNC_GET_SBLIST_SORT$$

CREATE PROCEDURE FUNC_GET_SBLIST_SORT(p_czryDm VARCHAR(4000),p_sbywbDm VARCHAR(4000),
       p_sort VARCHAR(4000),p_offset DECIMAL(38,10),p_rows DECIMAL(38,10),p_filter VARCHAR(4000))
routine_body: BEGIN
  DECLARE BJTS_ROUTINE_EXIT BOOLEAN DEFAULT FALSE;
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
  DECLARE v_ydcnt BIGINT;
  DECLARE v_yjcnt BIGINT;
  DECLARE v_cqbz BIGINT;
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
       SELECT NULL AS SBID, NULL AS SSSQ, NULL AS SBRQ, NULL AS QYHGDM, NULL AS NSRMC, NULL AS SBYWBDM, NULL AS FLGLCD, NULL AS ZZSBB, NULL AS ZS_SWJG_MC, NULL AS TS_SWJG_MC, NULL AS TSJSFS, NULL AS SBYWBMC, NULL AS SBTMSE, NULL AS YDCNT, NULL AS YJCNT, NULL AS CQBZ WHERE 1 = 0; SET BJTS_ROUTINE_EXIT = TRUE;

  END;
select IFNULL(qx_swjg, swjg_dm) into v_czry_swjg
      from DM_CZRY where czry_dm =p_czryDm;
  end;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  SET v_czry_qxswjg =FUNC_GET_QXSWJG(v_czry_swjg) ;

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
  SET dyn_select =
      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('select ZZ.*,', ' (select count(*) from CKTS_XXBD_YDXX YD where ZZ.sbid=YD.Sbid) AS ydcnt, '), ' (select count(*) from YJ_DATA_YJXX YJ where ZZ.sbid=YJ.Sbid) AS yjcnt'), '  from ('), '  select sbid,sssq,sbpc,sbrq,qyhgdm,nsrmc,sbywb_dm,flglcd,zzsbb,swjg_jc,cqbz from '), '(select vs.sbid, vs.sssq, vs.sbpc, vs.sbrq, vs.qyhgdm, vs.nsrmc, vs.sbywb_dm,vs.flglcd,vs.zzsbb,vs.swjg_jc,vs.sbzl_dm,'), ' case when flglcd in (''A'',''B'') then case when sbzl_dm in (''TSSB'') and (ORA_DATE_DIFF(CURRENT_TIMESTAMP, sbrq))>5 then 1 else 0 end else case when sbzl_dm in (''TSSB'') and  (ORA_DATE_DIFF(CURRENT_TIMESTAMP, sbrq))>10 then 1 else 0 end end as cqbz,'), '     row_number() over(ORDER BY '), sorting), ') rn '), 'from V_SBXX_SBDR_FILEMODE vs '), ' where vs.swjg_dm like '''), v_czry_qxswjg), ''' and '), 'vs.sbywb_dm='''), p_sbywbDm), ''' '), v_filter), 'and ( '), ' (vs.sbr is not null and vs.sbr='''), p_czryDm), ''') or '), ' (vs.sbr is null and ( '), 'exists (select 1 from SYS_CFG_CZRY_FPGL sc2 '), 'where sc2.czry_dm='''), p_czryDm), ''' and sc2.swjg_dm like ORA_CONCAT(ORA_CONCAT(''%'', vs.swjg_dm), ''%'') and sc2.qybz=''Y'' '), ' and (vs.sbywb_dm=''A0101001'' or '), '( (coalesce(sc2.zsjg_dm_set,'' '')='' '' or vs.zs_swjg_dm is null or sc2.zsjg_dm_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.zs_swjg_dm), ''%'')) '), 'and (coalesce(sc2.zgswry_dm_set,'' '')='' '') '), 'and (coalesce(sc2.flgl_set,'' '')='' '' or sc2.flgl_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.flglcd), ''%'')) '), 'and (vs.sbzl_dm<>''TSSB'' OR (coalesce(sc2.jsmode_set,'' '')='' '' or sc2.jsmode_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.tsjsfs_dm), ''%'')))))))) '), ')) TT where rn between '), startRow), ' and '), endRow), ' order by rn'), ')ZZ');


  SET dyn_select = CONCAT('WITH BJTS_RESULT_SOURCE (v_sbid, v_sssq, v_sbpc, v_sbrq, v_qyhgdm, v_nsrmc, v_sbywbdm, v_flglcd, v_zzsbb, v_swjg_jc, v_cqbz, v_ydcnt, v_yjcnt) AS (', dyn_select, ') SELECT v_sbid AS SBID,
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
       v_ydcnt AS YDCNT,
       v_yjcnt AS YJCNT,
       v_cqbz AS CQBZ FROM BJTS_RESULT_SOURCE');
  SET @BJTS_RESULT_SQL_001 = dyn_select;
  PREPARE BJTS_RESULT_STMT_001 FROM @BJTS_RESULT_SQL_001;
  EXECUTE BJTS_RESULT_STMT_001;
  DEALLOCATE PREPARE BJTS_RESULT_STMT_001;


END$$

DELIMITER ;

-- END SOURCE: FUNC_GET_SBLIST_SORT.sql

-- ======================================================================
-- [012/114] BEGIN SOURCE: FUNC_GET_SBLIST_SORT_QXSWJG.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS FUNC_GET_SBLIST_SORT_QXSWJG$$

CREATE PROCEDURE FUNC_GET_SBLIST_SORT_QXSWJG(p_czryDm VARCHAR(4000),p_sbywbDm VARCHAR(4000),
       p_sort VARCHAR(4000),p_offset DECIMAL(38,10),p_rows DECIMAL(38,10),p_filter VARCHAR(4000))
routine_body: BEGIN
  DECLARE BJTS_ROUTINE_EXIT BOOLEAN DEFAULT FALSE;
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
       SELECT NULL AS SBID, NULL AS SSSQ, NULL AS SBRQ, NULL AS QYHGDM, NULL AS NSRMC, NULL AS SBYWBDM, NULL AS FLGLCD, NULL AS ZZSBB, NULL AS ZS_SWJG_MC, NULL AS TS_SWJG_MC, NULL AS TSJSFS, NULL AS SBYWBMC, NULL AS SBTMSE, NULL AS YDCNT, NULL AS YJCNT, NULL AS CQBZ WHERE 1 = 0; SET BJTS_ROUTINE_EXIT = TRUE;

  END;
select swjg_dm into v_czry_swjg
      from DM_CZRY where czry_dm =p_czryDm;
  end;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  SET v_czry_qxswjg =FUNC_GET_QXSWJG(v_czry_swjg) ;

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
  SET dyn_select =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('select sbid,sssq,sbpc,sbrq,qyhgdm,nsrmc,sbywb_dm,flglcd,zzsbb,swjg_jc from ', '(select vs.sbid, vs.sssq, vs.sbpc, vs.sbrq, vs.qyhgdm, vs.nsrmc, vs.sbywb_dm,vs.flglcd,vs.zzsbb,vs.swjg_jc,'), '     row_number() over(ORDER BY '), sorting), ') rn '), 'from V_SBXX_SBDR_FILEMODE vs '), 'where vs.swjg_dm like '''), v_czry_qxswjg), ''' and '), 'vs.sbywb_dm='''), p_sbywbDm), ''' '), v_filter), 'and ( '), ' (vs.sbr is not null and vs.sbr='''), p_czryDm), ''') or '), ' (vs.sbr is null and ( '), 'exists (select 1 from SYS_CFG_CZRY_FPGL sc2 '), 'where sc2.czry_dm='''), p_czryDm), ''' and sc2.swjg_dm like ORA_CONCAT(ORA_CONCAT(''%'', vs.swjg_dm), ''%'') and sc2.qybz=''Y'' '), 'and (coalesce(sc2.zsjg_dm_set,'' '')='' '' or vs.zs_swjg_dm is null or sc2.zsjg_dm_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.zs_swjg_dm), ''%'')) '), 'and (coalesce(sc2.zgswry_dm_set,'' '')='' '') '), 'and (coalesce(sc2.flgl_set,'' '')='' '' or sc2.flgl_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.flglcd), ''%'')) '), 'and (vs.sbzl_dm<>''TSSB'' OR (coalesce(sc2.jsmode_set,'' '')='' '' or sc2.jsmode_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.tsjsfs_dm), ''%'')))))) '), ')) TT where rn between '), startRow), ' and '), endRow), ' order by rn');


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

-- END SOURCE: FUNC_GET_SBLIST_SORT_QXSWJG.sql

-- ======================================================================
-- [013/114] BEGIN SOURCE: FUNC_GET_SBLIST_SORT_TEST.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS FUNC_GET_SBLIST_SORT_TEST$$

CREATE PROCEDURE FUNC_GET_SBLIST_SORT_TEST(p_czryDm VARCHAR(4000),p_sbywbDm VARCHAR(4000),
       p_sort VARCHAR(4000),p_offset DECIMAL(38,10),p_rows DECIMAL(38,10),p_filter VARCHAR(4000))
routine_body: BEGIN
  DECLARE BJTS_ROUTINE_EXIT BOOLEAN DEFAULT FALSE;
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
       SELECT NULL AS SBID, NULL AS SSSQ, NULL AS SBRQ, NULL AS QYHGDM, NULL AS NSRMC, NULL AS SBYWBDM, NULL AS FLGLCD, NULL AS ZZSBB, NULL AS ZS_SWJG_MC, NULL AS TS_SWJG_MC, NULL AS TSJSFS, NULL AS SBYWBMC, NULL AS SBTMSE, NULL AS YDCNT, NULL AS YJCNT, NULL AS CQBZ WHERE 1 = 0; SET BJTS_ROUTINE_EXIT = TRUE;

  END;
select swjg_dm into v_czry_swjg
      from DM_CZRY where czry_dm =p_czryDm;
  end;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  SET v_czry_qxswjg =FUNC_GET_QXSWJG(v_czry_swjg) ;

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
  SET dyn_select =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('select sbid,sssq,sbpc,sbrq,qyhgdm,nsrmc,sbywb_dm,flglcd,zzsbb,swjg_jc from ', '(select vs.sbid, vs.sssq, vs.sbpc, vs.sbrq, vs.qyhgdm, vs.nsrmc, vs.sbywb_dm,vs.flglcd,vs.zzsbb,vs.swjg_jc,'), '     row_number() over(ORDER BY '), sorting), ') rn '), 'from V_SBXX_SBDR_FILEMODE vs '), 'where vs.swjg_dm like '''), v_czry_qxswjg), ''' and '), 'vs.sbywb_dm='''), p_sbywbDm), ''' '), v_filter), 'and ( '), ' (vs.sbr is not null and vs.sbr='''), p_czryDm), ''') or '), ' (vs.sbr is null and ( '), 'exists (select 1 from SYS_CFG_CZRY_FPGL sc2 '), 'where sc2.czry_dm='''), p_czryDm), ''' and sc2.swjg_dm like ORA_CONCAT(ORA_CONCAT(''%'', vs.swjg_dm), ''%'') and sc2.qybz=''Y'' '), ' and (vs.sbywb_dm=''A0101001'' or '), '( (coalesce(sc2.zsjg_dm_set,'' '')='' '' or vs.zs_swjg_dm is null or sc2.zsjg_dm_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.zs_swjg_dm), ''%'')) '), 'and (coalesce(sc2.zgswry_dm_set,'' '')='' '') '), 'and (coalesce(sc2.flgl_set,'' '')='' '' or sc2.flgl_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.flglcd), ''%'')) '), 'and (coalesce(sc2.jsmode_set,'' '')='' '' or sc2.jsmode_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.tsjsfs_dm), ''%''))))))) '), ')) TT where rn between '), startRow), ' and '), endRow), ' order by rn');


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

-- END SOURCE: FUNC_GET_SBLIST_SORT_TEST.sql

-- ======================================================================
-- [014/114] BEGIN SOURCE: FUNC_GET_SBLIST_SORT_TSSWJG.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS FUNC_GET_SBLIST_SORT_TSSWJG$$

CREATE PROCEDURE FUNC_GET_SBLIST_SORT_TSSWJG(p_czryDm VARCHAR(4000),p_sbywbDm VARCHAR(4000),
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
  SET dyn_select =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('select sbid,sssq,sbpc,sbrq,qyhgdm,nsrmc,sbywb_dm,flglcd,zzsbb,swjg_jc from ', '(select vs.sbid, vs.sssq, vs.sbpc, vs.sbrq, vs.qyhgdm, vs.nsrmc, vs.sbywb_dm,vs.flglcd,vs.zzsbb,vs.swjg_jc,'), '     row_number() over(ORDER BY '), sorting), ') rn '), 'from V_SBXX_SBDR_FILEMODE vs '), 'inner join DM_CZRY dc on dc.czry_dm='''), p_czryDm), ''' and vs.swjg_dm =dc.swjg_dm '), 'where '), 'vs.sbywb_dm='''), p_sbywbDm), ''' '), v_filter), 'and ( '), ' (vs.sbr is not null and vs.sbr='''), p_czryDm), ''') or '), ' (vs.sbr is null and ( '), 'not exists (select 1 from SYS_CFG_CZRY_FPGL sc1 '), 'where sc1.czry_dm=dc.czry_dm and sc1.swjg_dm=dc.swjg_dm and sc1.qybz=''Y'') or '), 'exists (select 1 from SYS_CFG_CZRY_FPGL sc2 '), 'where sc2.czry_dm=dc.czry_dm and sc2.swjg_dm=dc.swjg_dm and sc2.qybz=''Y'' '), 'and (coalesce(sc2.zsjg_dm_set,'' '')='' '' or vs.zs_swjg_dm is null or sc2.zsjg_dm_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.zs_swjg_dm), ''%'')) '), 'and (coalesce(sc2.zgswry_dm_set,'' '')='' '') '), 'and (coalesce(sc2.flgl_set,'' '')='' '' or sc2.flgl_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.flglcd), ''%'')) '), 'and (vs.sbzl_dm<>''TSSB'' OR (coalesce(sc2.jsmode_set,'' '')='' '' or sc2.jsmode_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.tsjsfs_dm), ''%'')))))) '), ')) TT where rn between '), startRow), ' and '), endRow), ' order by rn');


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

-- END SOURCE: FUNC_GET_SBLIST_SORT_TSSWJG.sql

-- ======================================================================
-- [015/114] BEGIN SOURCE: FUNC_GET_WJDR_COUNT.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS FUNC_GET_WJDR_COUNT$$

CREATE PROCEDURE FUNC_GET_WJDR_COUNT(p_czryDm VARCHAR(4000), OUT P_RESULT integer)
routine_body: BEGIN
  DECLARE BJTS_ROUTINE_EXIT BOOLEAN DEFAULT FALSE;
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
       SET P_RESULT = 0; SET BJTS_ROUTINE_EXIT = TRUE;

  END;
select IFNULL(qx_swjg, swjg_dm) into v_czry_swjg
      from DM_CZRY where czry_dm =p_czryDm;
  end;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  SET v_czry_qxswjg =FUNC_GET_QXSWJG(v_czry_swjg) ;

  SET dyn_select =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('select count(1) from V_SBXX_SBDR_FILEMODE vs ', ' where vs.swjg_dm like '''), v_czry_qxswjg), ''' and vs.sbr is null and ( '), ' (vs.zs_swjg_dm is not null and  '), ' not exists (select 1 from SYS_CFG_CZRY_FPGL sc1 '), ' where sc1.swjg_dm like ORA_CONCAT(ORA_CONCAT(''%'', vs.swjg_dm), ''%'') and sc1.qybz=''Y'' '), ' and (coalesce(sc1.zsjg_dm_set,'' '')='' '' or sc1.zsjg_dm_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.zs_swjg_dm), ''%'')) '), ' and (coalesce(sc1.flgl_set,'' '')='' '' or sc1.flgl_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.flglcd), ''%'')) '), ' and (vs.sbzl_dm<>''TSSB'' OR (coalesce(sc1.jsmode_set,'' '')='' '' or sc1.jsmode_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.tsjsfs_dm), ''%'')))) '), ' ) or '), ' (vs.zs_swjg_dm is null and  '), ' not exists (select 1 from SYS_CFG_CZRY_FPGL sc2 '), ' where sc2.swjg_dm like ORA_CONCAT(ORA_CONCAT(''%'', vs.swjg_dm), ''%'') and sc2.qybz=''Y'' '), ' and (coalesce(sc2.zsjg_dm_set,'' '')='' '') '), ' and (coalesce(sc2.flgl_set,'' '')='' '' or sc2.flgl_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.flglcd), ''%'')) '), ' and (vs.sbzl_dm<>''TSSB'' OR (coalesce(sc2.jsmode_set,'' '')='' '' or sc2.jsmode_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.tsjsfs_dm), ''%'')))) '), ' ))');

  SET @BJTS_DYNAMIC_OUT_001_001 = NULL;
SET @BJTS_DYNAMIC_SQL_001 = CONCAT(TRIM(TRAILING ';' FROM dyn_select), ' INTO @BJTS_DYNAMIC_OUT_001_001');
PREPARE BJTS_DYNAMIC_STMT_001 FROM @BJTS_DYNAMIC_SQL_001;
EXECUTE BJTS_DYNAMIC_STMT_001;
DEALLOCATE PREPARE BJTS_DYNAMIC_STMT_001;
SET v_cnt = @BJTS_DYNAMIC_OUT_001_001;

  SET P_RESULT = v_cnt; LEAVE routine_body;
END$$

DELIMITER ;

-- END SOURCE: FUNC_GET_WJDR_COUNT.sql

-- ======================================================================
-- [016/114] BEGIN SOURCE: FUNC_GET_WJDR_SBLIST.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS FUNC_GET_WJDR_SBLIST$$

CREATE PROCEDURE FUNC_GET_WJDR_SBLIST(p_czryDm VARCHAR(4000),
       p_sort VARCHAR(4000),p_offset DECIMAL(38,10),p_rows DECIMAL(38,10),p_filter VARCHAR(4000))
routine_body: BEGIN
  DECLARE BJTS_ROUTINE_EXIT BOOLEAN DEFAULT FALSE;
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
  DECLARE v_zs_swjg_mc VARCHAR(80);
  DECLARE v_czry_qxswjg VARCHAR(11);
  DECLARE v_czry_swjg VARCHAR(11);
  DECLARE v_tsjsfs char(1);
  DECLARE v_sbywbmc VARCHAR(80);
  DECLARE v_ts_swjg_mc VARCHAR(80);
  DECLARE v_sbtmse BIGINT;

  -- 提取操作员的退税税务机关代码，并计算权限机关代码
  begin
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
       DO '操作员不存在';
       SELECT NULL AS SBID, NULL AS SSSQ, NULL AS SBRQ, NULL AS QYHGDM, NULL AS NSRMC, NULL AS SBYWBDM, NULL AS FLGLCD, NULL AS ZZSBB, NULL AS ZS_SWJG_MC, NULL AS TS_SWJG_MC, NULL AS TSJSFS, NULL AS SBYWBMC, NULL AS SBTMSE, NULL AS YDCNT, NULL AS YJCNT, NULL AS CQBZ WHERE 1 = 0; SET BJTS_ROUTINE_EXIT = TRUE;

  END;
select IFNULL(qx_swjg, swjg_dm) into v_czry_swjg
      from DM_CZRY where czry_dm =p_czryDm;
  end;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  SET v_czry_qxswjg =FUNC_GET_QXSWJG(v_czry_swjg) ;

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

  SET dyn_select =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('select sbid,sssq,sbpc,sbrq,qyhgdm,nsrmc,sbywb_dm,flglcd,zzsbb,TT.swjg_jc as zs_swjg_mc,ds.swjg_jc as ts_swjg_mc,tsjsfs_dm,sd1.dname as sbywbmc,sbtmse from ', ' (select vs.sbid, vs.sssq, vs.sbpc, vs.sbrq, vs.qyhgdm, vs.nsrmc, vs.sbywb_dm,vs.flglcd,vs.zzsbb,vs.swjg_jc,vs.tsjsfs_dm,vs.swjg_dm,vs.sbtmse,'), ' row_number() over(ORDER BY '), sorting), ') rn '), ' from V_SBXX_SBDR_FILEMODE vs '), ' where vs.swjg_dm like '''), v_czry_qxswjg), ''' and vs.sbr is null '), v_filter), ' and ( '), ' (vs.zs_swjg_dm is not null and  '), ' not exists (select 1 from SYS_CFG_CZRY_FPGL sc1 '), ' where sc1.swjg_dm like ORA_CONCAT(ORA_CONCAT(''%'', vs.swjg_dm), ''%'') and sc1.qybz=''Y'' '), ' and (coalesce(sc1.zsjg_dm_set,'' '')='' '' or sc1.zsjg_dm_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.zs_swjg_dm), ''%'')) '), ' and (coalesce(sc1.flgl_set,'' '')='' '' or sc1.flgl_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.flglcd), ''%'')) '), ' and (vs.sbzl_dm<>''TSSB'' OR (coalesce(sc1.jsmode_set,'' '')='' '' or sc1.jsmode_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.tsjsfs_dm), ''%'')))) '), ' ) or '), ' (vs.zs_swjg_dm is null and  '), ' not exists (select 1 from SYS_CFG_CZRY_FPGL sc2 '), ' where sc2.swjg_dm like ORA_CONCAT(ORA_CONCAT(''%'', vs.swjg_dm), ''%'') and sc2.qybz=''Y'' '), ' and (coalesce(sc2.zsjg_dm_set,'' '')='' '') '), ' and (coalesce(sc2.flgl_set,'' '')='' '' or sc2.flgl_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.flglcd), ''%'')) '), ' and (vs.sbzl_dm<>''TSSB'' OR (coalesce(sc2.jsmode_set,'' '')='' '' or sc2.jsmode_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.tsjsfs_dm), ''%'')))) '), ' ))) TT '), ' left join DM_SWJG ds on (ds.swjg_dm=TT.swjg_dm) '), ' left join SYS_DICT sd1 on sd1.dtype=''ywlx_dm'' and sd1.dcode=TT.sbywb_dm '), ' where rn between '), startRow), ' and '), endRow), ' order by rn');

  SET dyn_select = CONCAT('WITH BJTS_RESULT_SOURCE (v_sbid, v_sssq, v_sbpc, v_sbrq, v_qyhgdm, v_nsrmc, v_sbywbdm, v_flglcd, v_zzsbb, v_zs_swjg_mc, v_ts_swjg_mc, v_tsjsfs, v_sbywbmc, v_sbtmse) AS (', dyn_select, ') SELECT v_sbid AS SBID,
       case when v_sbywbdm=''A0301001'' then ORA_CONCAT(v_sssq, LPAD(CAST(v_sbpc AS CHAR), 2, ''0'')) else v_sssq end AS SSSQ,
       v_sbrq AS SBRQ,
       v_qyhgdm AS QYHGDM,
       v_nsrmc AS NSRMC,
       v_sbywbdm AS SBYWBDM,
       v_flglcd AS FLGLCD,
       v_zzsbb AS ZZSBB,
       v_zs_swjg_mc AS ZS_SWJG_MC,
       v_ts_swjg_mc AS TS_SWJG_MC,
       v_tsjsfs AS TSJSFS,
       v_sbywbmc AS SBYWBMC,
       v_sbtmse AS SBTMSE,
       0 AS YDCNT,
       0 AS YJCNT,
       0 AS CQBZ FROM BJTS_RESULT_SOURCE');
  SET @BJTS_RESULT_SQL_001 = dyn_select;
  PREPARE BJTS_RESULT_STMT_001 FROM @BJTS_RESULT_SQL_001;
  EXECUTE BJTS_RESULT_STMT_001;
  DEALLOCATE PREPARE BJTS_RESULT_STMT_001;


END$$

DELIMITER ;

-- END SOURCE: FUNC_GET_WJDR_SBLIST.sql

-- ======================================================================
-- [017/114] BEGIN SOURCE: FUNC_GET_WJDR_SBLIST_TEST.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS FUNC_GET_WJDR_SBLIST_TEST$$

CREATE PROCEDURE FUNC_GET_WJDR_SBLIST_TEST(p_czryDm VARCHAR(4000),
       p_sort VARCHAR(4000),p_offset DECIMAL(38,10),p_rows DECIMAL(38,10),p_filter VARCHAR(4000))
routine_body: BEGIN
  DECLARE BJTS_ROUTINE_EXIT BOOLEAN DEFAULT FALSE;
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
  DECLARE v_zs_swjg_mc VARCHAR(80);
  DECLARE v_czry_qxswjg VARCHAR(11);
  DECLARE v_czry_swjg VARCHAR(11);
  DECLARE v_tsjsfs char(1);
  DECLARE v_sbywbmc VARCHAR(80);
  DECLARE v_ts_swjg_mc VARCHAR(80);
  DECLARE v_sbtmse BIGINT;

  -- 提取操作员的退税税务机关代码，并计算权限机关代码
  begin
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
       DO '操作员不存在';
       SELECT NULL AS SBID, NULL AS SSSQ, NULL AS SBRQ, NULL AS QYHGDM, NULL AS NSRMC, NULL AS SBYWBDM, NULL AS FLGLCD, NULL AS ZZSBB, NULL AS ZS_SWJG_MC, NULL AS TS_SWJG_MC, NULL AS TSJSFS, NULL AS SBYWBMC, NULL AS SBTMSE, NULL AS YDCNT, NULL AS YJCNT, NULL AS CQBZ WHERE 1 = 0; SET BJTS_ROUTINE_EXIT = TRUE;

  END;
select IFNULL(qx_swjg, swjg_dm) into v_czry_swjg
      from DM_CZRY where czry_dm =p_czryDm;
  end;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  SET v_czry_qxswjg =FUNC_GET_QXSWJG(v_czry_swjg) ;

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

  SET dyn_select =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('select sbid,sssq,sbpc,sbrq,qyhgdm,nsrmc,sbywb_dm,flglcd,zzsbb,TT.swjg_jc as zs_swjg_mc,ds.swjg_jc as ts_swjg_mc,tsjsfs_dm,sd1.dname as sbywbmc,sbtmse from ', ' (select vs.sbid, vs.sssq, vs.sbpc, vs.sbrq, vs.qyhgdm, vs.nsrmc, vs.sbywb_dm,vs.flglcd,vs.zzsbb,vs.swjg_jc,vs.tsjsfs_dm,vs.swjg_dm,vs.sbtmse,'), ' row_number() over(ORDER BY '), sorting), ') rn '), ' from V_SBXX_SBDR_FILEMODE vs '), ' where vs.swjg_dm like '''), v_czry_qxswjg), ''' and vs.sbr is null '), v_filter), ' and ( '), ' (vs.zs_swjg_dm is not null and  '), ' not exists (select 1 from SYS_CFG_CZRY_FPGL sc1 '), ' where sc1.swjg_dm like ORA_CONCAT(ORA_CONCAT(''%'', vs.swjg_dm), ''%'') and sc1.qybz=''Y'' '), ' and (coalesce(sc1.zsjg_dm_set,'' '')='' '' or sc1.zsjg_dm_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.zs_swjg_dm), ''%'')) '), ' and (coalesce(sc1.flgl_set,'' '')='' '' or sc1.flgl_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.flglcd), ''%'')) '), ' and (vs.sbzl_dm<>''TSSB'' OR (coalesce(sc1.jsmode_set,'' '')='' '' or sc1.jsmode_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.tsjsfs_dm), ''%'')))) '), ' ) or '), ' (vs.zs_swjg_dm is null and  '), ' not exists (select 1 from SYS_CFG_CZRY_FPGL sc2 '), ' where sc2.swjg_dm like ORA_CONCAT(ORA_CONCAT(''%'', vs.swjg_dm), ''%'') and sc2.qybz=''Y'' '), ' and (coalesce(sc2.zsjg_dm_set,'' '')='' '') '), ' and (coalesce(sc2.flgl_set,'' '')='' '' or sc2.flgl_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.flglcd), ''%'')) '), ' and (vs.sbzl_dm<>''TSSB'' OR (coalesce(sc2.jsmode_set,'' '')='' '' or sc2.jsmode_set like ORA_CONCAT(ORA_CONCAT(''%'', vs.tsjsfs_dm), ''%'')))) '), ' ))) TT '), ' left join DM_SWJG ds on (ds.swjg_dm=TT.swjg_dm) '), ' left join SYS_DICT sd1 on sd1.dtype=''ywlx_dm'' and sd1.dcode=TT.sbywb_dm '), ' where rn between '), startRow), ' and '), endRow), ' order by rn');

  SET dyn_select = CONCAT('WITH BJTS_RESULT_SOURCE (v_sbid, v_sssq, v_sbpc, v_sbrq, v_qyhgdm, v_nsrmc, v_sbywbdm, v_flglcd, v_zzsbb, v_zs_swjg_mc, v_ts_swjg_mc, v_tsjsfs, v_sbywbmc, v_sbtmse) AS (', dyn_select, ') SELECT v_sbid AS SBID,
       case when v_sbywbdm=''A0301001'' then ORA_CONCAT(v_sssq, LPAD(CAST(v_sbpc AS CHAR), 2, ''0'')) else v_sssq end AS SSSQ,
       v_sbrq AS SBRQ,
       v_qyhgdm AS QYHGDM,
       v_nsrmc AS NSRMC,
       v_sbywbdm AS SBYWBDM,
       v_flglcd AS FLGLCD,
       v_zzsbb AS ZZSBB,
       v_zs_swjg_mc AS ZS_SWJG_MC,
       v_ts_swjg_mc AS TS_SWJG_MC,
       v_tsjsfs AS TSJSFS,
       v_sbywbmc AS SBYWBMC,
       v_sbtmse AS SBTMSE,
       0 AS YDCNT,
       0 AS YJCNT,
       0 AS CQBZ FROM BJTS_RESULT_SOURCE');
  SET @BJTS_RESULT_SQL_001 = dyn_select;
  PREPARE BJTS_RESULT_STMT_001 FROM @BJTS_RESULT_SQL_001;
  EXECUTE BJTS_RESULT_STMT_001;
  DEALLOCATE PREPARE BJTS_RESULT_STMT_001;


END$$

DELIMITER ;

-- END SOURCE: FUNC_GET_WJDR_SBLIST_TEST.sql

-- ======================================================================
-- [018/114] BEGIN SOURCE: FUNC_SHZS_RWWP.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS FUNC_SHZS_RWWP$$

CREATE PROCEDURE FUNC_SHZS_RWWP(p_swjg_dm VARCHAR(4000),p_gwdm VARCHAR(4000),p_nsrsbh VARCHAR(4000),p_lcswsxdm VARCHAR(4000))
routine_body: BEGIN
  DECLARE v_WTDXMC VARCHAR(30);   -- 委托对象
  DECLARE v_WTDXSFDM VARCHAR(13); -- 委托对象身份代码
  DECLARE v_JDMODE CHAR(1);        -- 接单方式  0分组 1随机
  DECLARE v_FLGLCD CHAR(1);        -- 分类管理等级
  DECLARE v_JSMODE CHAR(1);        -- 退税计算方式 1生产 2外贸
  DECLARE v_QYFZDM VARCHAR(11);   -- 企业分组代码
  DECLARE v_QYFZMC VARCHAR(11);   -- 企业分组名称
  DECLARE v_sbywbdm varchar(32);   -- 申报业务表代码
  DECLARE v_ErrMsg VARCHAR(100);

  SET v_ErrMsg ='';
  SET v_WTDXSFDM ='';
  -- 根据流程税务事项，取申报业务表代码
  begin
  DECLARE BJTS_SQLCODE_007 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_007 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_007 = MYSQL_ERRNO, BJTS_SQLERRM_007 = MESSAGE_TEXT;
    SET v_sbywbdm ='NODEF';

  END;
select t.sbyw_dm into v_sbywbdm from DM_GT3_XML_CONFIG t where t.lcsx_dm=p_lcswsxdm;
  end;

  -- 根据税务机关，获得接单方式（2本月已分配过 0分组 1随机）
    Begin
  DECLARE BJTS_SQLCODE_006 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_006 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_006 = MYSQL_ERRNO, BJTS_SQLERRM_006 = MESSAGE_TEXT;
       SET v_JDMODE ='';

  END;
select d.jd_mode into V_JDMODE from SYS_CFG_SBDR_FILEMODE d where d.code = p_swjg_dm and d.qybz='Y';
    End;

  -- 根据税号，获取分类管理等级和企业分组。
  begin
  DECLARE BJTS_SQLCODE_005 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_005 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_005 = MYSQL_ERRNO, BJTS_SQLERRM_005 = MESSAGE_TEXT;
    SET v_QYFZDM ='NOFZ';
    SET v_JSMODE ='';
    SET v_FLGLCD ='';

  END;
select IFNULL(dj.zs_swjg_dm, 'NONE'),dj.tsjsfs_dm,dk.kzxx
           into v_QYFZDM,v_JSMODE,v_FLGLCD
      from GS_DJ_CKTMSDAB dj
      left join GS_DJ_CKTMSDAB_KZ dk
        on (dj.nsrdzdah = dk.nsrdzdah and dk.kzlx = 'FLGLCD' and dk.flag = '1' and
           CURRENT_TIMESTAMP between dk.st_date and dk.end_date and 1=1)
     where dj.nsrsbh = p_nsrsbh
LIMIT 1;
  end;
--  DBMS_OUTPUT.put_line('v_JSMODE='||v_JSMODE);

  -- 判断税号当月有没有被委派过，且该人在线，有则继续委派给同一个人员
  -- 此规则只针对v_sbywbdm属于申报类业务A03开头，或证明类业务A02开头，或A0410002撤销申报
-- DBMS_OUTPUT.put_line('V_JDMODE='||V_JDMODE);
  if V_JDMODE !='0' and (substr(v_sbywbdm,1,3)='A03' or substr(v_sbywbdm,1,3)='A02' or v_sbywbdm='A0410002') then
    begin
  DECLARE BJTS_SQLCODE_004 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_004 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_004 = MYSQL_ERRNO, BJTS_SQLERRM_004 = MESSAGE_TEXT;
       -- DBMS_OUTPUT.put_line('该企业本月尚未被委派过');
       SET v_WTDXSFDM ='';

  END;
select wpsfdm,swrymc into v_WTDXSFDM,v_WTDXMC
        from (select t.wpsfdm,s.swrymc
                from SHZS_WP_TASK t, SHZS_WP_SWRY s
               where t.wpsfdm = s.sfdm
                 and s.status = '1'
                 and s.gwdm = p_gwdm
                 and t.nsrsbh = p_nsrsbh
                 and DATE_FORMAT(t.wpsj, '%Y%m') = DATE_FORMAT(CURRENT_TIMESTAMP, '%Y%m')
               order by t.wpsj desc) AS BJTS_DERIVED_001
       where 1=1
LIMIT 1;
    end;
  else
     SET v_WTDXSFDM ='';
  end if;

-- DBMS_OUTPUT.put_line('v_WTDXSFDM=' || v_WTDXSFDM);

  IF Length(v_WTDXSFDM)>0 THEN
    -- 本月已委派过，则沿用此人
    BEGIN
        SET V_JDMODE ='2';
-- DBMS_OUTPUT.put_line('fenzhi=1');
    END;
  ELSE
    BEGIN
-- DBMS_OUTPUT.put_line('fenzhi=2');

      IF v_JDMODE='1' THEN
    -- 1.随机分单
    --  1）按税务机关+岗位序号+在线+分类管理等级+税务事项代码,获取接单人列表
    --  2) 再结合委派日志表, 按当天已委派+预分配的企业数量 排序，取第一个人作为委派对象
    --  注：随机分单时，分两步检索：
    --     先根据接单人设置的规则，看有没有指定条件的接单人（如分类管理限定四类、退税计算方式限定外贸等）
    --     再根据在岗大名单去取数。
        BEGIN
  DECLARE BJTS_SQLCODE_003 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_003 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_003 = MYSQL_ERRNO, BJTS_SQLERRM_003 = MESSAGE_TEXT;
             SET v_WTDXSFDM ='';
             SET v_WTDXMC ='';

  END;
with RY as
           (select t.sfdm, t.swrymc
              from SHZS_WP_SWRY t
              inner join SYS_CFG_CZRY_FPGL s
                on s.swjg_dm = t.swjgdm
               and s.czry_dm = substr(t.sfdm, 1, 11)
               and s.qybz = 'Y'
               and (v_FLGLCD is not null and s.flgl_set like ORA_CONCAT(ORA_CONCAT('%', v_FLGLCD), '%'))
               and (v_JSMODE is not null and s.jsmode_set like ORA_CONCAT(ORA_CONCAT('%', v_JSMODE), '%'))
             where t.swjgdm = p_swjg_dm
               and t.gwdm = p_gwdm
               and t.status = '1')
          select SFDM, SWRYMC into v_WTDXSFDM,v_WTDXMC
            FROM (select RY.SFDM, RY.swrymc, count(distinct(TK.nsrsbh)) as CNT
                    from RY
                    LEFT JOIN SHZS_WP_TASK TK
                      ON RY.SFDM = TK.WPSFDM
                     AND DATE_FORMAT(TK.Wpsj, '%Y%m%d') = DATE_FORMAT(CURRENT_TIMESTAMP, '%Y%m%d')
                   group by RY.SFDM, RY.swrymc
                   order by CNT) AS BJTS_DERIVED_002
           WHERE 1=1
LIMIT 1;

-- DBMS_OUTPUT.put_line('随机分单=已找到指定规则的接单人！');
        END;

        IF v_WTDXSFDM is null THEN
-- DBMS_OUTPUT.put_line('随机分单=未找到指定规则接单人，继续找在岗人');
        BEGIN
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
             SET v_WTDXSFDM ='';
             SET v_WTDXMC ='';
             SET v_ErrMsg ='未找到可随机分配的接单人！';

  END;
with RY as
           (select t.sfdm, t.swrymc
              from SHZS_WP_SWRY t
              left join SYS_CFG_CZRY_FPGL s
                on s.swjg_dm = t.swjgdm
               and s.czry_dm = substr(t.sfdm, 1, 11)
               and s.qybz = 'Y'
               and (s.flgl_set is null or s.flgl_set like ORA_CONCAT(ORA_CONCAT('%', v_FLGLCD), '%'))
               and (s.jsmode_set is null or s.jsmode_set like ORA_CONCAT(ORA_CONCAT('%', v_JSMODE), '%'))
             where t.swjgdm = p_swjg_dm
               and t.gwdm = p_gwdm
               and t.status = '1')
          select SFDM, SWRYMC into v_WTDXSFDM,v_WTDXMC
            FROM (select RY.SFDM, RY.swrymc, count(distinct(TK.nsrsbh)) as CNT
                    from RY
                    LEFT JOIN SHZS_WP_TASK TK
                      ON RY.SFDM = TK.WPSFDM
                     AND DATE_FORMAT(TK.Wpsj, '%Y%m%d') = DATE_FORMAT(CURRENT_TIMESTAMP, '%Y%m%d')
                   group by RY.SFDM, RY.swrymc
                   order by CNT) AS BJTS_DERIVED_003
           WHERE 1=1
LIMIT 1;
-- DBMS_OUTPUT.put_line('随机分单=找到在岗接单人');
          END;
        END IF;
      ELSE
        IF v_JDMODE='0' THEN
        BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';
    -- 0.分组接单
    --  1）按分组+分类管理+税务事项代码，获取接单人
    --  2）判断接单人是否在岗和在线。

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
           SET v_WTDXSFDM ='';
           SET v_WTDXMC ='';
           SET v_ErrMsg ='未找到分组对应的接单人！';

  END;
with RY as
           (select t.sfdm, t.swrymc
              from SHZS_WP_SWRY t
             inner join SYS_CFG_CZRY_FPGL s
                on s.swjg_dm = t.swjgdm
               and s.czry_dm = substr(t.sfdm, 1, 11)
               and s.qybz = 'Y'
               and (s.flgl_set is null or s.flgl_set like ORA_CONCAT(ORA_CONCAT('%', v_FLGLCD), '%'))
               and (s.jsmode_set is null or s.jsmode_set like ORA_CONCAT(ORA_CONCAT('%', v_JSMODE), '%'))
               and (IFNULL(s.zsjg_dm_set, 'NOFZ') like ORA_CONCAT(ORA_CONCAT('%', v_QYFZDM), '%'))
             where t.swjgdm = p_swjg_dm
               and t.gwdm = p_gwdm
               and t.status = '1')
          select SFDM, SWRYMC into v_WTDXSFDM,v_WTDXMC
            FROM (select RY.SFDM, RY.swrymc, count(distinct(TK.nsrsbh)) as CNT
                    from RY
                    LEFT JOIN SHZS_WP_TASK TK
                      ON RY.SFDM = TK.WPSFDM
                     AND DATE_FORMAT(TK.Wpsj, '%m') = DATE_FORMAT(CURRENT_TIMESTAMP, '%m')
                   group by RY.SFDM, RY.swrymc
                   order by CNT) AS BJTS_DERIVED_004
           WHERE 1=1
LIMIT 1;

        END;
        ELSE
        BEGIN
          SET v_WTDXSFDM ='';
          SET v_WTDXMC ='';
          SET v_ErrMsg =ORA_CONCAT(ORA_CONCAT('税务机关', p_swjg_dm), '未设置接单方式！');
        END;
        END IF;
      END IF;

    END;
  END IF;

  SELECT v_WTDXSFDM AS WPDXSFDM,
       v_WTDXMC AS WPDXMC,
       p_nsrsbh AS NSRSBH,
       v_QYFZDM AS QYFZMC,
       v_JDMODE AS JDMODE,
       v_ErrMsg AS ERRMSG;

-- DBMS_OUTPUT.put_line('结束--'||v_ErrMsg||'-'||v_WTDXSFDM||v_WTDXMC);


END$$

DELIMITER ;

-- END SOURCE: FUNC_SHZS_RWWP.sql

-- ======================================================================
-- [019/114] BEGIN SOURCE: FUNC_SHZS_RWWP_BAK20250609.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS FUNC_SHZS_RWWP_BAK20250609$$

CREATE PROCEDURE FUNC_SHZS_RWWP_BAK20250609(p_swjg_dm VARCHAR(4000),p_gwdm VARCHAR(4000),p_nsrsbh VARCHAR(4000),p_lcswsxdm VARCHAR(4000))
routine_body: BEGIN
  DECLARE v_WTDXMC VARCHAR(30);   -- 委托对象
  DECLARE v_WTDXSFDM VARCHAR(13); -- 委托对象身份代码
  DECLARE v_JDMODE CHAR(1);        -- 接单方式  0分组 1随机
  DECLARE v_FLGLCD CHAR(1);        -- 分类管理等级
  DECLARE v_JSMODE CHAR(1);        -- 退税计算方式 1生产 2外贸
  DECLARE v_QYFZDM VARCHAR(11);   -- 企业分组代码
  DECLARE v_QYFZMC VARCHAR(11);   -- 企业分组名称
  DECLARE v_sbywbdm varchar(32);   -- 申报业务表代码
  DECLARE v_ErrMsg VARCHAR(100);

  SET v_ErrMsg ='';
  SET v_WTDXSFDM ='';
  -- 根据流程税务事项，取申报业务表代码
  begin
  DECLARE BJTS_SQLCODE_007 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_007 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_007 = MYSQL_ERRNO, BJTS_SQLERRM_007 = MESSAGE_TEXT;
    SET v_sbywbdm ='NODEF';

  END;
select t.sbyw_dm into v_sbywbdm from DM_GT3_XML_CONFIG t where t.lcsx_dm=p_lcswsxdm;
  end;

  -- 根据税务机关，获得接单方式（2本月已分配过 0分组 1随机）
    Begin
  DECLARE BJTS_SQLCODE_006 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_006 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_006 = MYSQL_ERRNO, BJTS_SQLERRM_006 = MESSAGE_TEXT;
       SET v_JDMODE ='';

  END;
select d.jd_mode into V_JDMODE from SYS_CFG_SBDR_FILEMODE d where d.code = p_swjg_dm and d.qybz='Y';
    End;

  -- 根据税号，获取分类管理等级和企业分组。
  begin
  DECLARE BJTS_SQLCODE_005 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_005 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_005 = MYSQL_ERRNO, BJTS_SQLERRM_005 = MESSAGE_TEXT;
    SET v_QYFZDM ='NOFZ';
    SET v_JSMODE ='';
    SET v_FLGLCD ='';

  END;
select IFNULL(dj.zs_swjg_dm, 'NONE'),dj.tsjsfs_dm,dk.kzxx
           into v_QYFZDM,v_JSMODE,v_FLGLCD
      from GS_DJ_CKTMSDAB dj
      left join GS_DJ_CKTMSDAB_KZ dk
        on (dj.nsrdzdah = dk.nsrdzdah and dk.kzlx = 'FLGLCD' and dk.flag = '1' and
           CURRENT_TIMESTAMP between dk.st_date and dk.end_date and 1=1)
     where dj.nsrsbh = p_nsrsbh
LIMIT 1;
  end;
--  DBMS_OUTPUT.put_line('v_JSMODE='||v_JSMODE);

  -- 判断税号当月有没有被委派过，且该人在线，有则继续委派给同一个人员
  -- 此规则只针对v_sbywbdm属于申报类业务A03开头，或证明类业务A02开头，或A0410002撤销申报
-- DBMS_OUTPUT.put_line('V_JDMODE='||V_JDMODE);
  if V_JDMODE !='0' and (substr(v_sbywbdm,1,3)='A03' or substr(v_sbywbdm,1,3)='A02' or v_sbywbdm='A0410002') then
    begin
  DECLARE BJTS_SQLCODE_004 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_004 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_004 = MYSQL_ERRNO, BJTS_SQLERRM_004 = MESSAGE_TEXT;
       -- DBMS_OUTPUT.put_line('该企业本月尚未被委派过');
       SET v_WTDXSFDM ='';

  END;
select wpsfdm,swrymc into v_WTDXSFDM,v_WTDXMC
        from (select t.wpsfdm,s.swrymc
                from SHZS_WP_TASK t, SHZS_WP_SWRY s
               where t.wpsfdm = s.sfdm
                 and s.status = '1'
                 and s.gwdm = p_gwdm
                 and t.nsrsbh = p_nsrsbh
                 and DATE_FORMAT(t.wpsj, '%m') = DATE_FORMAT(CURRENT_TIMESTAMP, '%m')
               order by t.wpsj desc) AS BJTS_DERIVED_001
       where 1=1
LIMIT 1;
    end;
  else
     SET v_WTDXSFDM ='';
  end if;

-- DBMS_OUTPUT.put_line('v_WTDXSFDM=' || v_WTDXSFDM);

  IF Length(v_WTDXSFDM)>0 THEN
    -- 本月已委派过，则沿用此人
    BEGIN
        SET V_JDMODE ='2';
-- DBMS_OUTPUT.put_line('fenzhi=1');
    END;
  ELSE
    BEGIN
-- DBMS_OUTPUT.put_line('fenzhi=2');

      IF v_JDMODE='1' THEN
    -- 1.随机分单
    --  1）按税务机关+岗位序号+在线+分类管理等级+税务事项代码,获取接单人列表
    --  2) 再结合委派日志表, 按当天已委派+预分配的企业数量 排序，取第一个人作为委派对象
    --  注：随机分单时，分两步检索：
    --     先根据接单人设置的规则，看有没有指定条件的接单人（如分类管理限定四类、退税计算方式限定外贸等）
    --     再根据在岗大名单去取数。
        BEGIN
  DECLARE BJTS_SQLCODE_003 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_003 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_003 = MYSQL_ERRNO, BJTS_SQLERRM_003 = MESSAGE_TEXT;
             SET v_WTDXSFDM ='';
             SET v_WTDXMC ='';

  END;
with RY as
           (select t.sfdm, t.swrymc
              from SHZS_WP_SWRY t
              inner join SYS_CFG_CZRY_FPGL s
                on s.swjg_dm = t.swjgdm
               and s.czry_dm = substr(t.sfdm, 1, 11)
               and s.qybz = 'Y'
               and (v_FLGLCD is not null and s.flgl_set like ORA_CONCAT(ORA_CONCAT('%', v_FLGLCD), '%'))
               and (v_JSMODE is not null and s.jsmode_set like ORA_CONCAT(ORA_CONCAT('%', v_JSMODE), '%'))
             where t.swjgdm = p_swjg_dm
               and t.gwdm = p_gwdm
               and t.status = '1')
          select SFDM, SWRYMC into v_WTDXSFDM,v_WTDXMC
            FROM (select RY.SFDM, RY.swrymc, count(distinct(TK.nsrsbh)) as CNT
                    from RY
                    LEFT JOIN SHZS_WP_TASK TK
                      ON RY.SFDM = TK.WPSFDM
                     AND DATE_FORMAT(TK.Wpsj, '%Y%m%d') = DATE_FORMAT(CURRENT_TIMESTAMP, '%Y%m%d')
                   group by RY.SFDM, RY.swrymc
                   order by CNT) AS BJTS_DERIVED_002
           WHERE 1=1
LIMIT 1;

-- DBMS_OUTPUT.put_line('随机分单=已找到指定规则的接单人！');
        END;

        IF v_WTDXSFDM is null THEN
-- DBMS_OUTPUT.put_line('随机分单=未找到指定规则接单人，继续找在岗人');
        BEGIN
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
             SET v_WTDXSFDM ='';
             SET v_WTDXMC ='';
             SET v_ErrMsg ='未找到可随机分配的接单人！';

  END;
with RY as
           (select t.sfdm, t.swrymc
              from SHZS_WP_SWRY t
              left join SYS_CFG_CZRY_FPGL s
                on s.swjg_dm = t.swjgdm
               and s.czry_dm = substr(t.sfdm, 1, 11)
               and s.qybz = 'Y'
               and (s.flgl_set is null or s.flgl_set like ORA_CONCAT(ORA_CONCAT('%', v_FLGLCD), '%'))
               and (s.jsmode_set is null or s.jsmode_set like ORA_CONCAT(ORA_CONCAT('%', v_JSMODE), '%'))
             where t.swjgdm = p_swjg_dm
               and t.gwdm = p_gwdm
               and t.status = '1')
          select SFDM, SWRYMC into v_WTDXSFDM,v_WTDXMC
            FROM (select RY.SFDM, RY.swrymc, count(distinct(TK.nsrsbh)) as CNT
                    from RY
                    LEFT JOIN SHZS_WP_TASK TK
                      ON RY.SFDM = TK.WPSFDM
                     AND DATE_FORMAT(TK.Wpsj, '%Y%m%d') = DATE_FORMAT(CURRENT_TIMESTAMP, '%Y%m%d')
                   group by RY.SFDM, RY.swrymc
                   order by CNT) AS BJTS_DERIVED_003
           WHERE 1=1
LIMIT 1;
-- DBMS_OUTPUT.put_line('随机分单=找到在岗接单人');
          END;
        END IF;
      ELSE
        IF v_JDMODE='0' THEN
        BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';
    -- 0.分组接单
    --  1）按分组+分类管理+税务事项代码，获取接单人
    --  2）判断接单人是否在岗和在线。

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
           SET v_WTDXSFDM ='';
           SET v_WTDXMC ='';
           SET v_ErrMsg ='未找到分组对应的接单人！';

  END;
with RY as
           (select t.sfdm, t.swrymc
              from SHZS_WP_SWRY t
             inner join SYS_CFG_CZRY_FPGL s
                on s.swjg_dm = t.swjgdm
               and s.czry_dm = substr(t.sfdm, 1, 11)
               and s.qybz = 'Y'
               and (s.flgl_set is null or s.flgl_set like ORA_CONCAT(ORA_CONCAT('%', v_FLGLCD), '%'))
               and (s.jsmode_set is null or s.jsmode_set like ORA_CONCAT(ORA_CONCAT('%', v_JSMODE), '%'))
               and (IFNULL(s.zsjg_dm_set, 'NOFZ') like ORA_CONCAT(ORA_CONCAT('%', v_QYFZDM), '%'))
             where t.swjgdm = p_swjg_dm
               and t.gwdm = p_gwdm
               and t.status = '1')
          select SFDM, SWRYMC into v_WTDXSFDM,v_WTDXMC
            FROM (select RY.SFDM, RY.swrymc, count(distinct(TK.nsrsbh)) as CNT
                    from RY
                    LEFT JOIN SHZS_WP_TASK TK
                      ON RY.SFDM = TK.WPSFDM
                     AND DATE_FORMAT(TK.Wpsj, '%m') = DATE_FORMAT(CURRENT_TIMESTAMP, '%m')
                   group by RY.SFDM, RY.swrymc
                   order by CNT) AS BJTS_DERIVED_004
           WHERE 1=1
LIMIT 1;

        END;
        ELSE
        BEGIN
          SET v_WTDXSFDM ='';
          SET v_WTDXMC ='';
          SET v_ErrMsg =ORA_CONCAT(ORA_CONCAT('税务机关', p_swjg_dm), '未设置接单方式！');
        END;
        END IF;
      END IF;

    END;
  END IF;

  SELECT v_WTDXSFDM AS WPDXSFDM,
       v_WTDXMC AS WPDXMC,
       p_nsrsbh AS NSRSBH,
       v_QYFZDM AS QYFZMC,
       v_JDMODE AS JDMODE,
       v_ErrMsg AS ERRMSG;

-- DBMS_OUTPUT.put_line('结束--'||v_ErrMsg||'-'||v_WTDXSFDM||v_WTDXMC);


END$$

DELIMITER ;

-- END SOURCE: FUNC_SHZS_RWWP_BAK20250609.sql

-- ======================================================================
-- [020/114] BEGIN SOURCE: FUNC_SHZS_RWWP_BAK_OLD2025.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS FUNC_SHZS_RWWP_BAK_OLD2025$$

CREATE PROCEDURE FUNC_SHZS_RWWP_BAK_OLD2025(p_swjg_dm VARCHAR(4000),p_gwdm VARCHAR(4000),p_nsrsbh VARCHAR(4000),p_lcswsxdm VARCHAR(4000))
routine_body: BEGIN
  DECLARE v_WTDXMC VARCHAR(30);   -- 委托对象
  DECLARE v_WTDXSFDM VARCHAR(13); -- 委托对象身份代码
  DECLARE v_JDMODE CHAR(1);        -- 接单方式  0分组 1随机
  DECLARE v_FLGLCD CHAR(1);        -- 分类管理等级
  DECLARE v_JSMODE CHAR(1);        -- 退税计算方式 1生产 2外贸
  DECLARE v_QYFZDM VARCHAR(11);   -- 企业分组代码
  DECLARE v_QYFZMC VARCHAR(11);   -- 企业分组名称
  DECLARE v_sbywbdm varchar(32);   -- 申报业务表代码
  DECLARE v_ErrMsg VARCHAR(100);

  SET v_ErrMsg ='';
  -- 根据流程税务事项，取申报业务表代码
  begin
  DECLARE BJTS_SQLCODE_007 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_007 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_007 = MYSQL_ERRNO, BJTS_SQLERRM_007 = MESSAGE_TEXT;
    SET v_sbywbdm ='NODEF';

  END;
select t.sbyw_dm into v_sbywbdm from DM_GT3_XML_CONFIG t where t.lcsx_dm=p_lcswsxdm;
  end;

  -- 根据税号，获取分类管理等级和企业分组。
  begin
  DECLARE BJTS_SQLCODE_006 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_006 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_006 = MYSQL_ERRNO, BJTS_SQLERRM_006 = MESSAGE_TEXT;
    SET v_QYFZDM ='NOFZ';
    SET v_JSMODE ='';
    SET v_FLGLCD ='';

  END;
select IFNULL(dj.zs_swjg_dm, 'NONE'),dj.tsjsfs_dm,dk.kzxx
           into v_QYFZDM,v_JSMODE,v_FLGLCD
      from GS_DJ_CKTMSDAB dj
      left join GS_DJ_CKTMSDAB_KZ dk
        on (dj.nsrdzdah = dk.nsrdzdah and dk.kzlx = 'FLGLCD' and dk.flag = '1' and
           CURRENT_TIMESTAMP between dk.st_date and dk.end_date and 1=1)
     where dj.nsrsbh = p_nsrsbh
LIMIT 1;
  end;
  DO ORA_CONCAT('v_JSMODE=', v_JSMODE);

  -- 判断税号当月有没有被委派过，且该人在线，有则继续委派给同一个人员
  -- 此规则只针对v_sbywbdm属于申报类业务A03开头，或证明类业务A02开头，或A0410002撤销申报
  if substr(v_sbywbdm,1,3)='A03' or substr(v_sbywbdm,1,3)='A02' or v_sbywbdm='A0410002' then
    begin
  DECLARE BJTS_SQLCODE_005 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_005 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_005 = MYSQL_ERRNO, BJTS_SQLERRM_005 = MESSAGE_TEXT;
       -- DBMS_OUTPUT.put_line('该企业本月尚未被委派过');
       SET v_WTDXSFDM ='';

  END;
select wpsfdm,swrymc into v_WTDXSFDM,v_WTDXMC
        from (select t.wpsfdm,s.swrymc
                from SHZS_WP_TASK t, SHZS_WP_SWRY s
               where t.wpsfdm = s.sfdm
                 and s.status = '1'
                 and s.gwdm = p_gwdm
                 and t.nsrsbh = p_nsrsbh
                 and DATE_FORMAT(t.wpsj, '%m') = DATE_FORMAT(CURRENT_TIMESTAMP, '%m')
               order by t.wpsj desc) AS BJTS_DERIVED_001
       where 1=1
LIMIT 1;
    end;
    DO ORA_CONCAT('v_WTDXSFDM=', v_WTDXSFDM);
  else
     SET v_WTDXSFDM ='';
  end if;

  IF Length(v_WTDXSFDM)>0 THEN
    -- 本月已委派过，则沿用此人
    BEGIN
        SET V_JDMODE ='2';
-- DBMS_OUTPUT.put_line('fenzhi=1');
    END;
  ELSE
    BEGIN
-- DBMS_OUTPUT.put_line('fenzhi=2');
    -- 根据税务机关，获得接单方式（2本月已分配过 0分组 1随机）
      Begin
  DECLARE BJTS_SQLCODE_004 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_004 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_004 = MYSQL_ERRNO, BJTS_SQLERRM_004 = MESSAGE_TEXT;
         SET v_JDMODE ='';

  END;
select d.jd_mode into V_JDMODE from SYS_CFG_SBDR_FILEMODE d where d.code = p_swjg_dm and d.qybz='Y';
      End;

      IF v_JDMODE='1' THEN
    -- 1.随机分单
    --  1）按税务机关+岗位序号+在线+分类管理等级+税务事项代码,获取接单人列表
    --  2) 再结合委派日志表, 按当天已委派+预分配的企业数量 排序，取第一个人作为委派对象
    --  注：随机分单时，分两步检索：
    --     先根据接单人设置的规则，看有没有指定条件的接单人（如分类管理限定四类、退税计算方式限定外贸等）
    --     再根据在岗大名单去取数。
        BEGIN
  DECLARE BJTS_SQLCODE_003 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_003 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_003 = MYSQL_ERRNO, BJTS_SQLERRM_003 = MESSAGE_TEXT;
             SET v_WTDXSFDM ='';
             SET v_WTDXMC ='';

  END;
with RY as
           (select t.sfdm, t.swrymc
              from SHZS_WP_SWRY t
              inner join SYS_CFG_CZRY_FPGL s
                on s.swjg_dm = t.swjgdm
               and s.czry_dm = substr(t.sfdm, 1, 11)
               and s.qybz = 'Y'
               and (v_FLGLCD is not null and s.flgl_set like ORA_CONCAT(ORA_CONCAT('%', v_FLGLCD), '%'))
               and (v_JSMODE is not null and s.jsmode_set like ORA_CONCAT(ORA_CONCAT('%', v_JSMODE), '%'))
             where t.swjgdm = p_swjg_dm
               and t.gwdm = p_gwdm
               and t.status = '1')
          select SFDM, SWRYMC into v_WTDXSFDM,v_WTDXMC
            FROM (select RY.SFDM, RY.swrymc, count(distinct(TK.nsrsbh)) as CNT
                    from RY
                    LEFT JOIN SHZS_WP_TASK TK
                      ON RY.SFDM = TK.WPSFDM
                     AND DATE_FORMAT(TK.Wpsj, '%Y%m%d') = DATE_FORMAT(CURRENT_TIMESTAMP, '%Y%m%d')
                   group by RY.SFDM, RY.swrymc
                   order by CNT) AS BJTS_DERIVED_002
           WHERE 1=1
LIMIT 1;

-- DBMS_OUTPUT.put_line('随机分单=已找到指定规则的接单人！');
        END;

        IF v_WTDXSFDM is null THEN
-- DBMS_OUTPUT.put_line('随机分单=未找到指定规则接单人，继续找在岗人');
        BEGIN
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
             SET v_WTDXSFDM ='';
             SET v_WTDXMC ='';
             SET v_ErrMsg ='未找到可随机分配的接单人！';

  END;
with RY as
           (select t.sfdm, t.swrymc
              from SHZS_WP_SWRY t
              left join SYS_CFG_CZRY_FPGL s
                on s.swjg_dm = t.swjgdm
               and s.czry_dm = substr(t.sfdm, 1, 11)
               and s.qybz = 'Y'
               and (s.flgl_set is null or s.flgl_set like ORA_CONCAT(ORA_CONCAT('%', v_FLGLCD), '%'))
               and (s.jsmode_set is null or s.jsmode_set like ORA_CONCAT(ORA_CONCAT('%', v_JSMODE), '%'))
             where t.swjgdm = p_swjg_dm
               and t.gwdm = p_gwdm
               and t.status = '1')
          select SFDM, SWRYMC into v_WTDXSFDM,v_WTDXMC
            FROM (select RY.SFDM, RY.swrymc, count(distinct(TK.nsrsbh)) as CNT
                    from RY
                    LEFT JOIN SHZS_WP_TASK TK
                      ON RY.SFDM = TK.WPSFDM
                     AND DATE_FORMAT(TK.Wpsj, '%Y%m%d') = DATE_FORMAT(CURRENT_TIMESTAMP, '%Y%m%d')
                   group by RY.SFDM, RY.swrymc
                   order by CNT) AS BJTS_DERIVED_003
           WHERE 1=1
LIMIT 1;
-- DBMS_OUTPUT.put_line('随机分单=找到在岗接单人');
          END;
        END IF;
      ELSE
        IF v_JDMODE='0' THEN
        BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';
    -- 0.分组接单
    --  1）按分组+分类管理+税务事项代码，获取接单人
    --  2）判断接单人是否在岗和在线。

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
           SET v_WTDXSFDM ='';
           SET v_WTDXMC ='';
           SET v_ErrMsg ='未找到分组对应的接单人！';

  END;
with RY as
           (select t.sfdm, t.swrymc
              from SHZS_WP_SWRY t
             inner join SYS_CFG_CZRY_FPGL s
                on s.swjg_dm = t.swjgdm
               and s.czry_dm = substr(t.sfdm, 1, 11)
               and s.qybz = 'Y'
               and (s.flgl_set is null or s.flgl_set like ORA_CONCAT(ORA_CONCAT('%', v_FLGLCD), '%'))
               and (s.jsmode_set is null or s.jsmode_set like ORA_CONCAT(ORA_CONCAT('%', v_JSMODE), '%'))
               and (IFNULL(s.zsjg_dm_set, 'NOFZ') like ORA_CONCAT(ORA_CONCAT('%', v_QYFZDM), '%'))
             where t.swjgdm = p_swjg_dm
               and t.gwdm = p_gwdm
               and t.status = '1')
          select SFDM, SWRYMC into v_WTDXSFDM,v_WTDXMC
            FROM (select RY.SFDM, RY.swrymc, count(distinct(TK.nsrsbh)) as CNT
                    from RY
                    LEFT JOIN SHZS_WP_TASK TK
                      ON RY.SFDM = TK.WPSFDM
                     AND DATE_FORMAT(TK.Wpsj, '%m') = DATE_FORMAT(CURRENT_TIMESTAMP, '%m')
                   group by RY.SFDM, RY.swrymc
                   order by CNT) AS BJTS_DERIVED_004
           WHERE 1=1
LIMIT 1;

        END;
        ELSE
        BEGIN
          SET v_WTDXSFDM ='';
          SET v_WTDXMC ='';
          SET v_ErrMsg =ORA_CONCAT(ORA_CONCAT('税务机关', p_swjg_dm), '未设置接单方式！');
        END;
        END IF;
      END IF;

    END;
  END IF;

  SELECT v_WTDXSFDM AS WPDXSFDM,
       v_WTDXMC AS WPDXMC,
       p_nsrsbh AS NSRSBH,
       v_QYFZMC AS QYFZMC,
       v_JDMODE AS JDMODE,
       v_ErrMsg AS ERRMSG;

-- DBMS_OUTPUT.put_line('结束--'||v_ErrMsg||'-'||v_WTDXSFDM||v_WTDXMC);


END$$

DELIMITER ;

-- END SOURCE: FUNC_SHZS_RWWP_BAK_OLD2025.sql

-- ======================================================================
-- [021/114] BEGIN SOURCE: FUNC_STRSPLIT.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS FUNC_STRSPLIT$$

CREATE PROCEDURE FUNC_STRSPLIT(
    IN P_VALUE VARCHAR(4000),
    IN P_SPLIT VARCHAR(4000)
)
routine_body: BEGIN
    SET P_SPLIT = COALESCE(NULLIF(P_SPLIT, ''), ',');

    WITH RECURSIVE BJTS_SPLIT (TOKEN, REST_VALUE, DEPTH_NO) AS (
        SELECT CAST(NULL AS CHAR(4000)), P_VALUE, 0
        UNION ALL
        SELECT CASE
                   WHEN LOCATE(P_SPLIT, REST_VALUE) = 0 THEN REST_VALUE
                   ELSE LEFT(REST_VALUE, LOCATE(P_SPLIT, REST_VALUE) - 1)
               END,
               CASE
                   WHEN LOCATE(P_SPLIT, REST_VALUE) = 0 THEN NULL
                   ELSE SUBSTRING(
                       REST_VALUE,
                       LOCATE(P_SPLIT, REST_VALUE) + CHAR_LENGTH(P_SPLIT)
                   )
               END,
               DEPTH_NO + 1
          FROM BJTS_SPLIT
         WHERE REST_VALUE IS NOT NULL
           AND REST_VALUE <> ''
    )
    SELECT TOKEN AS COLUMN_VALUE
      FROM BJTS_SPLIT
     WHERE DEPTH_NO > 0
       AND TOKEN IS NOT NULL
       AND TOKEN <> '';
END$$

DELIMITER ;

-- END SOURCE: FUNC_STRSPLIT.sql

-- ======================================================================
-- [022/114] BEGIN SOURCE: FUNC_XXBD_CHECK_GCSBKPRQ.sql
-- ======================================================================
DELIMITER $$

DROP FUNCTION IF EXISTS FUNC_XXBD_CHECK_GCSBKPRQ$$

CREATE FUNCTION FUNC_XXBD_CHECK_GCSBKPRQ(V_KPRQ DATETIME)
RETURNS DECIMAL(38,10)
NOT DETERMINISTIC
READS SQL DATA
BEGIN

  IF V_KPRQ>=CAST('2016-01-01' AS DATE) AND V_KPRQ<=CAST('2017-03-14' AS DATE) THEN
    RETURN 1;
  END IF;
  IF V_KPRQ>=CAST('2019-01-01' AS DATE) AND V_KPRQ<=CAST('2020-03-01' AS DATE) THEN
    RETURN 1;
  END IF;
  IF V_KPRQ>=CAST('2021-01-01' AS DATE) AND V_KPRQ<=CAST('2021-06-22' AS DATE) THEN
    RETURN 1;
  END IF;
  RETURN 0;
END$$

DELIMITER ;

-- END SOURCE: FUNC_XXBD_CHECK_GCSBKPRQ.sql

-- ======================================================================
-- [023/114] BEGIN SOURCE: FUNC_XXBD_CHECK_JLDW.sql
-- ======================================================================
DELIMITER $$

DROP FUNCTION IF EXISTS FUNC_XXBD_CHECK_JLDW$$

CREATE FUNCTION FUNC_XXBD_CHECK_JLDW(V_JLDWMC VARCHAR(4000), V_JLDWDM VARCHAR(4000))
RETURNS DECIMAL(38,10)
NOT DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE V_NUMBER BIGINT;

/*
  SELECT COUNT(*)
    INTO V_NUMBER
    FROM CKTS_DM_HGJLDW T
   WHERE T.HGJLDW_DM=V_JLDWDM
     AND '.'||T.HGJLDWQC||'.' LIKE '%.'||UPPER(V_JLDWMC)||'.%';
*/
  SELECT COUNT(*)
    INTO V_NUMBER
    FROM CKTS_DM_HGJLDW T
   WHERE T.HGJLDW_DM IN (SELECT S.HGJLDW_DM
                           FROM CKTS_DM_HGJLDW S
                          WHERE ORA_CONCAT(ORA_CONCAT('.', S.HGJLDWQC), '.') LIKE ORA_CONCAT(ORA_CONCAT('%.', UPPER(V_JLDWMC)), '.%'))
     AND T.HGJLDW_DM IN (SELECT S.HGJLDW_DM
                           FROM CKTS_DM_HGJLDW S
                          WHERE ORA_CONCAT(ORA_CONCAT('.', S.HGJLDWQC), '.') LIKE ORA_CONCAT(ORA_CONCAT('%.', (SELECT R.HGJLDWQC FROM CKTS_DM_HGJLDW R WHERE R.HGJLDW_DM=V_JLDWDM)), '.%'));

  RETURN V_NUMBER;
END$$

DELIMITER ;

-- END SOURCE: FUNC_XXBD_CHECK_JLDW.sql

-- ======================================================================
-- [024/114] BEGIN SOURCE: FUNC_XXBD_CHECK_NEEDSH.sql
-- ======================================================================
DELIMITER $$

DROP FUNCTION IF EXISTS FUNC_XXBD_CHECK_NEEDSH$$

CREATE FUNCTION FUNC_XXBD_CHECK_NEEDSH(V_YWLX VARCHAR(4000))
RETURNS DECIMAL(38,10)
NOT DETERMINISTIC
READS SQL DATA
BEGIN

  -- DWYZ	对外援助
  -- DWCB	对外承包
  -- JWTZ	境外投资
  -- MSD	免税店
  -- ZB	中标机电
  -- JGW	海洋结构物
  -- WL	外轮货物
  -- HKSP	航空食品
  -- XLXP	修理修配
  -- XLXP-01	修飞机
  -- XLXP-02	修船舶
  -- HXWH	航线维护
  -- HCWX	航次维修
  -- GHQYTS	横琴平潭购进货物
  -- BM	边贸
  -- BMDL	边贸代理
  -- RZZL	融资租赁
  -- WLMSP	未列明商品
  -- HZCJ	红字冲减
  -- HZCJ-TY	红字冲减-退运
  -- XTHH-CJ	先退后核-冲减
  -- XTHH-XT	先退后核-先退
  IF V_YWLX LIKE '%,DWYZ,%' OR
     V_YWLX LIKE '%,DWCB,%' OR
     V_YWLX LIKE '%,JWTZ,%' OR
     V_YWLX LIKE '%,MSD,%' OR
     V_YWLX LIKE '%,ZB,%' OR
     V_YWLX LIKE '%,JGW,%' OR
     V_YWLX LIKE '%,WL,%' OR
     V_YWLX LIKE '%,HKSP,%' OR
	 V_YWLX LIKE '%,XLXP,%' OR
	 V_YWLX LIKE '%,XLXP-01,%' OR
	 V_YWLX LIKE '%,XLXP-02,%' OR
	 V_YWLX LIKE '%,HXWH,%' OR
	 V_YWLX LIKE '%,HCWX,%' OR
	 V_YWLX LIKE '%,GHQYTS,%' OR
	 V_YWLX LIKE '%,BM,%' OR
	 V_YWLX LIKE '%,BMDL,%' OR
	 V_YWLX LIKE '%,RZZL,%' OR
	 V_YWLX LIKE '%,WLMSP,%' OR
     V_YWLX LIKE '%,HZCJ,%' OR
     V_YWLX LIKE '%,HZCJ-TY,%' OR
     V_YWLX LIKE '%,XTHH-CJ,%' OR
     V_YWLX LIKE '%,XTHH-XT,%' THEN
    RETURN 0;
  END IF;
  RETURN 1;
END$$

DELIMITER ;

-- END SOURCE: FUNC_XXBD_CHECK_NEEDSH.sql

-- ======================================================================
-- [025/114] BEGIN SOURCE: FUNC_XXBD_CHECK_YWLX.sql
-- ======================================================================
DELIMITER $$

DROP FUNCTION IF EXISTS FUNC_XXBD_CHECK_YWLX$$

CREATE FUNCTION FUNC_XXBD_CHECK_YWLX(V_CONT VARCHAR(4000))
RETURNS DECIMAL(38,10)
NOT DETERMINISTIC
READS SQL DATA
BEGIN

  -- ZB  中标机电
  -- JGW 海洋结构物
  -- WL  外轮货物
  -- HKSP  航空食品
  -- XTHH-XH 先退后核
  -- XTHH-CJ 先退后核
  -- XLXP 修理修配
  -- HXWH 航线维护
  -- HCWX 航次维修
  -- WLMSP 未列明商品
  IF V_CONT LIKE '%,ZB,%' OR
     V_CONT LIKE '%,JGW,%' OR
     V_CONT LIKE '%,WL,%' OR
     V_CONT LIKE '%,HKSP,%' OR
     V_CONT LIKE '%,XTHH-XT,%' OR
     V_CONT LIKE '%,XTHH-CJ,%' OR
     V_CONT LIKE '%,HCWX,%' OR
     V_CONT LIKE '%,HXWH,%' OR
     V_CONT LIKE '%,WLMSP,%' THEN
    RETURN 1;
  END IF;
  RETURN 0;
END$$

DELIMITER ;

-- END SOURCE: FUNC_XXBD_CHECK_YWLX.sql

-- ======================================================================
-- [026/114] BEGIN SOURCE: FUNC_XXBD_COMPUTE_CHUFA.sql
-- ======================================================================
DELIMITER $$

DROP FUNCTION IF EXISTS FUNC_XXBD_COMPUTE_CHUFA$$

CREATE FUNCTION FUNC_XXBD_COMPUTE_CHUFA(V_IN_NUMBER1 DECIMAL(38,10), V_IN_NUMBER2 DECIMAL(38,10))
RETURNS DECIMAL(38,10)
NOT DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE V_NUMBER DECIMAL(38,10);

  IF V_IN_NUMBER2=0 THEN
    SET V_NUMBER = V_IN_NUMBER1;
  ELSE
    SET V_NUMBER = V_IN_NUMBER1 / V_IN_NUMBER2;
  END IF;

  RETURN V_NUMBER;
END$$

DELIMITER ;

-- END SOURCE: FUNC_XXBD_COMPUTE_CHUFA.sql

-- ======================================================================
-- [027/114] BEGIN SOURCE: FUNC_XXBD_QUERY_CPCODEKZ.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS FUNC_XXBD_QUERY_CPCODEKZ$$

CREATE PROCEDURE FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH DECIMAL(38,10), V_IN_KZLX VARCHAR(4000), V_IN_YXQ DATETIME, OUT V_OUT_KZXX VARCHAR(4000), OUT P_RESULT DECIMAL(38,10))
routine_body: BEGIN
  DECLARE LN_R BIGINT DEFAULT 0;
  DECLARE LN_ERROR BIGINT DEFAULT 0;

  BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
      SET LN_ERROR = BJTS_SQLCODE_001;
      SET V_OUT_KZXX ='C';

  END;
SELECT KZXX
      INTO V_OUT_KZXX
      FROM (SELECT KZXX
              FROM GS_DJ_CKTMSDAB_KZ
             WHERE NSRDZDAH = V_IN_NSRDZDAH
               AND KZLX = V_IN_KZLX
               AND FLAG ='1'
               AND V_IN_YXQ BETWEEN ST_DATE AND END_DATE
             ORDER BY KZXX DESC) AS BJTS_DERIVED_001
     WHERE 1=1
LIMIT 1;
  END;
  IF LN_ERROR=0 THEN
    SET LN_R =1;
  END IF;
  SET P_RESULT = LN_R; LEAVE routine_body;
END$$

DELIMITER ;

-- END SOURCE: FUNC_XXBD_QUERY_CPCODEKZ.sql

-- ======================================================================
-- [028/114] BEGIN SOURCE: F_SEQ_NEXTVAL_ADMIN.sql
-- ======================================================================
DELIMITER $$

DROP FUNCTION IF EXISTS F_SEQ_NEXTVAL_ADMIN$$

CREATE FUNCTION F_SEQ_NEXTVAL_ADMIN(P_TABLENAME VARCHAR(4000))
RETURNS BIGINT
NOT DETERMINISTIC
MODIFIES SQL DATA
BEGIN
    RETURN SEQ_NEXTVAL(UPPER(P_TABLENAME));
END$$

DELIMITER ;

-- END SOURCE: F_SEQ_NEXTVAL_ADMIN.sql

-- ======================================================================
-- [029/114] BEGIN SOURCE: PROC_XXBD_BNSH.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_BNSH$$

CREATE PROCEDURE PROC_XXBD_BNSH
/*
  编制人:严国平
  编制日期:202010
  功能:信息比对（非需收汇企业不能收汇原因申报）
  调整日期：20201130，1、根据金三疑点清单，将非需收汇的两个疑点调整为可挑过疑点
  调整日期：20220419，将不能收汇申报期限从原先设定的4月18日调整为为4月20日。
  调整日期：20220422，鉴于目前全国各地4月征期都在延期，将不能收汇申报期限从原先设定的4月20日调整为为4月30日。
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE BJTS_ROUTINE_EXIT BOOLEAN DEFAULT FALSE;
  DECLARE LDT_TODAY    DATETIME;

  DECLARE LC_QYHGDM       VARCHAR(20);
  DECLARE LC_QYLXDM       VARCHAR(20);
  DECLARE LC_TSJSFSDM     VARCHAR(20);
  DECLARE LC_WMZHFWQYBZ   VARCHAR(20);
  DECLARE LC_SFYSFW       VARCHAR(20);
  DECLARE LC_YSFW         VARCHAR(50);
  DECLARE LC_YSFS         VARCHAR(50);
  DECLARE LC_YFSJ         VARCHAR(50);
  DECLARE LC_ZXFLAG       VARCHAR(20);

  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LN_ROWNUM_TSSB  BIGINT;
  DECLARE LC_SHSB         VARCHAR(20) DEFAULT 'N';

  DECLARE LDT_CQSB     DATETIME;
  DECLARE LDT_TOYEAR   DATETIME;
  DECLARE LDT_LAYEAR   DATETIME;
  DECLARE LC_YDOBJECT     VARCHAR(20);

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);
  SET LDT_CQSB =STR_TO_DATE(ORA_CONCAT(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y'), '0430'), '%Y%m%d');
  SET LDT_TOYEAR =MAKEDATE(YEAR(CURRENT_TIMESTAMP), 1);
  SET LDT_LAYEAR =DATE_ADD(MAKEDATE(YEAR(CURRENT_TIMESTAMP), 1), INTERVAL -12 MONTH);

  IF V_IN_SSSQ>DATE_FORMAT(CURRENT_TIMESTAMP, '%Y%m') THEN
    BEGIN
      SET V_OUT_STATUS ='05';
      SET V_OUT_MESSAGE ='申报所属时期超出合理范围！';
      LEAVE routine_body;
    END;
  END IF;

  -- 取各申报明细表数据记录
  BEGIN
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='06';
      SET V_OUT_MESSAGE ='查询申报记录数据失败！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT COUNT(1)
      INTO LN_ROWNUM_TSSB
      FROM CKTS_SB_BNSHSB_LSB
     WHERE SBID=V_IN_SBID;
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LN_ROWNUM_TSSB=0 THEN
    BEGIN
      SET V_OUT_STATUS ='07';
      SET V_OUT_MESSAGE ='申报数据为空！';
      LEAVE routine_body;
    END;
  END IF;

  -- 查询企业基本信息
  BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='08';
      SET V_OUT_MESSAGE ='企业当前未进行出口退（免）税备案，不允许申报除出口退（免）税备案以外的其他业务！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT T.QYHGDM, T.QYLX_DM, T.TSJSFS_DM, T.WMZHFWQYBZ, T.SFYSFW, T.YSFW, T.YSFS, T.YFSJ, T.ZX_FLAG
      INTO LC_QYHGDM, LC_QYLXDM, LC_TSJSFSDM, LC_WMZHFWQYBZ, LC_SFYSFW, LC_YSFW, LC_YSFS, LC_YFSJ, LC_ZXFLAG
      FROM GS_DJ_CKTMSDAB T
     WHERE T.NSRDZDAH=V_IN_NSRDZDAH;
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LC_ZXFLAG='R' THEN
    BEGIN
      SET V_OUT_STATUS ='09';
      SET V_OUT_MESSAGE ='企业当前已出口退（免）税备案撤回，不允许申报除出口退（免）税备案以外的其他业务！';
      LEAVE routine_body;
    END;
  END IF;

  -- 取企业的FLGLCD信息, TGSHZL信息，判断是否需要申报收汇
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',LDT_TODAY,LC_FLGLCD, LN_CPCODEKZ);
  IF LN_CPCODEKZ=0 THEN
    BEGIN
      SET V_OUT_STATUS ='10';
      SET V_OUT_MESSAGE ='查询出口企业分类管理类型出错！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TGSHZL',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF (LC_FLGLCD='D') OR (LN_CPCODEKZ>0) THEN
    SET LC_SHSB ='Y';
  END IF;

  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'YBNSRRD',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=0 THEN
    BEGIN
      SET V_OUT_STATUS ='12';
      SET V_OUT_MESSAGE ='企业当前非增值税一般纳税人，不允许申报出口退（免）税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TQQY',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 THEN
    BEGIN
      SET V_OUT_STATUS ='13';
      SET V_OUT_MESSAGE ='企业当前处于出口退税停权期间，不允许申报出口退（免）税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTSSXMS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_TSSB>0 THEN
    BEGIN
      SET V_OUT_STATUS ='14';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权选择免税期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTSSXZS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_TSSB>0 THEN
    BEGIN
      SET V_OUT_STATUS ='15';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权选择征税期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTMS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_TSSB>0 THEN
    BEGIN
      SET V_OUT_STATUS ='16';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;

  IF LC_SHSB='Y' THEN
    BEGIN
      SET V_OUT_STATUS ='18';
      SET V_OUT_MESSAGE ='被认定为须提供收汇企业，请通过对应退（免）税业务附表资料与退（免）税申报明细一起申报收汇资料！';
      LEAVE routine_body;
    END;
  END IF;

  SET LC_YDOBJECT ='非需收汇';
  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_BNSHSB_LSB',NULL,NULL,T.SBXH,NULL,'FXSH_BNSH_BGD_WDZXX','I',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), ']无电子信息！'),'Y',CURRENT_TIMESTAMP
           FROM CKTS_SB_BNSHSB_LSB T
          WHERE T.SBID=V_IN_SBID
            AND NOT EXISTS (SELECT 1 FROM CKTS_WBSJ_HG_BGD201 S WHERE S.DJXH=V_IN_DJXH AND S.CKBGDH=T.CKBGDH);
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_BNSHSB_LSB',NULL,NULL,T.SBXH,NULL,'FXSH_BNSH_CKRQ_CQSB','I',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), ']已超过不能收汇申报期限！'),'Y',CURRENT_TIMESTAMP
           FROM CKTS_SB_BNSHSB_LSB T
          INNER JOIN CKTS_WBSJ_HG_BGD201 S ON S.DJXH=V_IN_DJXH AND S.CKBGDH=T.CKBGDH
          WHERE T.SBID=V_IN_SBID
            AND ((S.CKRQ_1<LDT_TOYEAR AND LDT_CQSB<LDT_TODAY) OR (S.CKRQ_1<LDT_LAYEAR));
    COMMIT;
  END;

END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_BNSH.sql

-- ======================================================================
-- [030/114] BEGIN SOURCE: PROC_XXBD_CHECK_SBB.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_CHECK_SBB$$

CREATE PROCEDURE PROC_XXBD_CHECK_SBB
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对统一入口
  修改日期：20220524，根据2022年9号公告，增加备案变更、备案撤回的直接返回（实际比对在java中进行）
  修改日期：20220615，根据2022年9号公告，取消非需收汇企业视同收汇申报、外综服企业代办退税备案
  修改日期：20220909，增加退税贷企业变更银行账号的控制需求
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='04';
      SET V_OUT_MESSAGE = ORA_CONCAT(ORA_CONCAT(BJTS_SQLCODE_001, ' : '), BJTS_SQLERRM_001);

  END;
IF V_IN_SBYWBDM ='A0301001' THEN
      CALL PROC_XXBD_MTS(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
    ELSEIF V_IN_SBYWBDM ='A0302001' THEN
      CALL PROC_XXBD_XFS(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
    ELSEIF V_IN_SBYWBDM ='A0303001' THEN
      CALL PROC_XXBD_JSB(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
    ELSEIF V_IN_SBYWBDM ='A0304001' THEN
      CALL PROC_XXBD_GJ(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
    ELSEIF V_IN_SBYWBDM ='A0305001' THEN
      CALL PROC_XXBD_MDT(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
    ELSEIF V_IN_SBYWBDM ='A0310001' THEN
      CALL PROC_XXBD_WZF(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
    ELSEIF V_IN_SBYWBDM ='A0404001' THEN -- 非需收汇企业视同收汇申报，根据2022年9号公告取消
      LEAVE routine_body;

    ELSEIF V_IN_SBYWBDM ='A0201001' THEN
      CALL PROC_XXBD_TSZM_DLCKHWZM(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
    ELSEIF V_IN_SBYWBDM ='A0201002' THEN -- 代理进口证明，金三所有疑点要求都暂时取消了
      LEAVE routine_body;
    ELSEIF V_IN_SBYWBDM ='A0201003' THEN -- 委托出口证明，原来通过java实现，为后续运维方便改存储过程
      CALL PROC_XXBD_TSZM_WTCKHWZM(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
    ELSEIF V_IN_SBYWBDM ='A0201004' THEN
      CALL PROC_XXBD_TSZM_CKHWZNXZM(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
    ELSEIF V_IN_SBYWBDM ='A0201005' THEN
      CALL PROC_XXBD_TSZM_TYYBSWTS(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
    ELSEIF V_IN_SBYWBDM ='A0203001' THEN
      CALL PROC_XXBD_MSZM_LLJGHX(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
    ELSEIF V_IN_SBYWBDM ='A0203002' THEN
      CALL PROC_XXBD_MSZM_LLJG(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
    ELSEIF V_IN_SBYWBDM ='A0202001' THEN -- 补办有关证明，仅需要服务端完成证明种类和证明编号的有效性校验
      LEAVE routine_body;
    ELSEIF V_IN_SBYWBDM ='Z0202002' THEN -- 作废有关证明，仅需要服务端完成证明种类和证明编号的有效性校验
      LEAVE routine_body;

    ELSEIF V_IN_SBYWBDM ='A0102001' THEN -- 备案变更，仅需要服务端完成有效性校验
      CALL PROC_XXBD_ZG_CKTMSBABG(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
    ELSEIF V_IN_SBYWBDM ='A0103001' THEN -- 备案撤回，仅需要服务端完成有效性校验
      LEAVE routine_body;
    ELSEIF V_IN_SBYWBDM ='A0109001' THEN -- 委托代办退税情况备案申请
      CALL PROC_XXBD_ZG_SCWTDBBA(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
    ELSEIF V_IN_SBYWBDM ='A0109002' THEN -- 委托代办退税情况备案撤回
      CALL PROC_XXBD_ZG_SCWTDBCH(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
    ELSEIF V_IN_SBYWBDM ='A0110001' THEN -- 代办退税情况备案申请，根据2022年9号公告取消
      LEAVE routine_body;
    ELSEIF V_IN_SBYWBDM ='A0410001' THEN -- 进货凭证信息回退申请
      CALL PROC_XXBD_JHPZHT(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
    ELSE
      SET V_OUT_STATUS ='03';
      SET V_OUT_MESSAGE ='本业务暂未开通申报自检服务！';
    END IF;
  END;

END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_CHECK_SBB.sql

-- ======================================================================
-- [031/114] BEGIN SOURCE: PROC_XXBD_CHECK_SHQ.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_CHECK_SHQ$$

CREATE PROCEDURE PROC_XXBD_CHECK_SHQ
/*
  编制人:严国平
  编制日期:202009
  功能:检查、创建、取消审核区
 */
(
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  IN V_IN_YWLX VARCHAR(4000), /*01：创建审核区；02：取消审核区*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 01:创建审核区失败；02：取消审核区失败*/
  OUT V_OUT_SBYWBDM VARCHAR(4000),
  OUT V_OUT_SSSQ VARCHAR(4000),
  OUT V_OUT_SBPC DECIMAL(38,10),
  OUT V_OUT_SBID DECIMAL(38,10),
  OUT V_OUT_CRTIME DATETIME
)
routine_body: BEGIN
  DECLARE V_TEMP      BIGINT DEFAULT 0;

  SET V_TEMP = 0;

  IF V_IN_YWLX='01' THEN
    /*创建审核区*/
    BEGIN
      BEGIN
  DECLARE BJTS_SQLCODE_003 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_003 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_003 = MYSQL_ERRNO, BJTS_SQLERRM_003 = MESSAGE_TEXT;
          SET V_TEMP = BJTS_SQLCODE_003;

  END;
INSERT INTO CKTS_XXBD_SHQ (DJXH, SBYWB_DM, SSSQ, SBPC, SBID, CRTIME, NOTE)
             VALUES (V_IN_DJXH, V_IN_SBYWBDM, V_IN_SSSQ, V_IN_SBPC, V_IN_SBID, CURRENT_TIMESTAMP, '信息比对');
      END;
      IF V_TEMP=0 THEN
         SET V_OUT_STATUS ='00';
         COMMIT;
      ELSE
         SET V_OUT_STATUS ='01';
         ROLLBACK;
      END IF;
      IF V_OUT_STATUS <> '00' THEN
        BEGIN
          BEGIN
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
              DO 0;

  END;
SELECT SBYWB_DM, SSSQ, SBPC, SBID, CRTIME
              INTO V_OUT_SBYWBDM, V_OUT_SSSQ, V_OUT_SBPC, V_OUT_SBID, V_OUT_CRTIME
              FROM CKTS_XXBD_SHQ
             WHERE DJXH = V_IN_DJXH;
          END;
        END;
      END IF;
      LEAVE routine_body;
    END;
  ELSE
    /*取消审核区*/
    BEGIN
      SELECT COUNT(1)
        INTO V_TEMP
        FROM CKTS_XXBD_SHQ
       WHERE DJXH = V_IN_DJXH;

      IF V_TEMP>0 THEN
        BEGIN
          SET V_TEMP =0;
          BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
              SET V_TEMP = BJTS_SQLCODE_001;

  END;
DELETE FROM CKTS_XXBD_SHQ WHERE DJXH = V_IN_DJXH;
            DELETE FROM CKTS_XXBD_SHQ_YDXX WHERE DJXH = V_IN_DJXH;

            DELETE FROM CKTS_GCB_ZM_TYYBSWTS WHERE DJXH = V_IN_DJXH;

            DELETE FROM CKTS_JGB_BA_SCQYWTDBTS WHERE DJXH = V_IN_DJXH;
            DELETE FROM CKTS_JGB_BA_WMZHFWDBTS WHERE DJXH = V_IN_DJXH;
            DELETE FROM CKTS_JGB_BA_XTHHZG WHERE DJXH = V_IN_DJXH;
            DELETE FROM CKTS_JGB_ZM_TYYBSWTS WHERE DJXH = V_IN_DJXH;
            DELETE FROM CKTS_JGB_ZM_LLJG WHERE DJXH = V_IN_DJXH;

            DELETE FROM CKTS_WBSJ_FP_YCKSPZXX WHERE DJXH = V_IN_DJXH;
            DELETE FROM CKTS_WBSJ_FP_ZZSZYFPXX WHERE DJXH = V_IN_DJXH;
            DELETE FROM CKTS_WBSJ_FP_ZZSFPHWXX WHERE DJXH = V_IN_DJXH;
            DELETE FROM CKTS_WBSJ_GT3_ZS_JKS WHERE DJXH = V_IN_DJXH;
            DELETE FROM CKTS_WBSJ_HG_BGD201 WHERE DJXH = V_IN_DJXH;
            DELETE FROM CKTS_WBSJ_HG_BGD202 WHERE DJXH = V_IN_DJXH;
            DELETE FROM CKTS_WBSJ_HG_DZSZCBAXX WHERE DJXH = V_IN_DJXH;
            DELETE FROM CKTS_WBSJ_HG_JKJKS WHERE DJXH = V_IN_DJXH;
            DELETE FROM CKTS_WBSJ_ZJ_DLCKHWZM WHERE DJXH = V_IN_DJXH;
            DELETE FROM CKTS_WBSJ_ZJ_JHBFXCJG WHERE DJXH = V_IN_DJXH;
            DELETE FROM CKTS_WBSJ_ZJ_SCWTDBBA WHERE DJXH = V_IN_DJXH;
            DELETE FROM CKTS_WBSJ_ZJ_TYYBSWTSZM WHERE DJXH = V_IN_DJXH;
            DELETE FROM CKTS_WBSJ_ZJ_WTCKHWZM WHERE DJXH = V_IN_DJXH;
            DELETE FROM CKTS_WBSJ_ZJ_XKFP WHERE DJXH = V_IN_DJXH;
            DELETE FROM CKTS_WBSJ_ZJ_ZJZYJKS WHERE DJXH = V_IN_DJXH;

            COMMIT;
          END;
        END;
      END IF;

      IF V_TEMP=0 THEN
         SET V_OUT_STATUS ='00';
         COMMIT;
      ELSE
         SET V_OUT_STATUS ='02';
         ROLLBACK;
      END IF;
    END;
  END IF;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_CHECK_SHQ.sql

-- ======================================================================
-- [032/114] BEGIN SOURCE: PROC_XXBD_GJ.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_GJ$$

CREATE PROCEDURE PROC_XXBD_GJ
/*
  编制人:严国平
  编制日期:202010
  功能:信息比对（购进自用货物免退税）
  调整日期：20201221，1、根据宁波加工区内退水电气大部分为小规模以及研发中心退国产设备政策第十三条，非增值税一般纳税人允许申报购进自用货物退税，对涉及一般纳税人资格的疑点进行调整
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE BJTS_ROUTINE_EXIT BOOLEAN DEFAULT FALSE;
  DECLARE LDT_TODAY       DATETIME;

  DECLARE LC_QYHGDM       VARCHAR(20);
  DECLARE LC_QYLXDM       VARCHAR(20);
  DECLARE LC_TSJSFSDM     VARCHAR(20);
  DECLARE LC_WMZHFWQYBZ   VARCHAR(20);
  DECLARE LC_SFYSFW       VARCHAR(20);
  DECLARE LC_YSFW         VARCHAR(50);
  DECLARE LC_YSFS         VARCHAR(50);
  DECLARE LC_YFSJ         VARCHAR(50);
  DECLARE LC_ZXFLAG       VARCHAR(20);

  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LN_SDQ          BIGINT;
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LN_ROWNUM_TSSB  BIGINT;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';
  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  IF V_IN_SSSQ>DATE_FORMAT(CURRENT_TIMESTAMP, '%Y%m') THEN
    BEGIN
      SET V_OUT_STATUS ='05';
      SET V_OUT_MESSAGE ='申报所属时期超出合理范围！';
      LEAVE routine_body;
    END;
  END IF;

  -- 取各申报明细表数据记录
  BEGIN
  DECLARE BJTS_SQLCODE_003 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_003 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_003 = MYSQL_ERRNO, BJTS_SQLERRM_003 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='06';
      SET V_OUT_MESSAGE ='查询申报记录数据失败！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT COUNT(1)
      INTO LN_ROWNUM_TSSB
      FROM CKTS_SB_GJ_SBMX_LSB
     WHERE SBID=V_IN_SBID;
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LN_ROWNUM_TSSB=0 THEN
    BEGIN
      SET V_OUT_STATUS ='07';
      SET V_OUT_MESSAGE ='申报数据为空！';
      LEAVE routine_body;
    END;
  END IF;

  -- 查询企业基本信息
  BEGIN
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='08';
      SET V_OUT_MESSAGE ='企业当前未进行出口退（免）税备案，不允许申报除出口退（免）税备案以外的其他业务！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT T.QYHGDM, T.QYLX_DM, T.TSJSFS_DM, T.WMZHFWQYBZ, T.SFYSFW, T.YSFW, T.YSFS, T.YFSJ, T.ZX_FLAG
      INTO LC_QYHGDM, LC_QYLXDM, LC_TSJSFSDM, LC_WMZHFWQYBZ, LC_SFYSFW, LC_YSFW, LC_YSFS, LC_YFSJ, LC_ZXFLAG
      FROM GS_DJ_CKTMSDAB T
     WHERE T.NSRDZDAH=V_IN_NSRDZDAH;
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LC_ZXFLAG='R' THEN
    BEGIN
      SET V_OUT_STATUS ='09';
      SET V_OUT_MESSAGE ='企业当前已出口退（免）税备案撤回，不允许申报除出口退（免）税备案以外的其他业务！';
      LEAVE routine_body;
    END;
  END IF;

  -- 取企业的FLGLCD信息, TGSHZL信息，判断是否需要申报收汇
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',LDT_TODAY,LC_FLGLCD, LN_CPCODEKZ);
  IF LN_CPCODEKZ=0 THEN
    BEGIN
      SET V_OUT_STATUS ='10';
      SET V_OUT_MESSAGE ='查询出口企业分类管理类型出错！';
      LEAVE routine_body;
    END;
  END IF;

  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TQQY',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 THEN
    BEGIN
      SET V_OUT_STATUS ='13';
      SET V_OUT_MESSAGE ='企业当前处于出口退税停权期间，不允许申报出口退（免）税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTSSXMS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_TSSB>0 THEN
    BEGIN
      SET V_OUT_STATUS ='14';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权选择免税期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTSSXZS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_TSSB>0 THEN
    BEGIN
      SET V_OUT_STATUS ='15';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权选择征税期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTMS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_TSSB>0 THEN
    BEGIN
      SET V_OUT_STATUS ='16';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='52';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('增值税发票自检出错：', BJTS_SQLCODE_001), ' - '), BJTS_SQLERRM_001);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_GJ_ZZSFP(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_GJ.sql

-- ======================================================================
-- [033/114] BEGIN SOURCE: PROC_XXBD_GJ_ZZSFP.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_GJ_ZZSFP$$

CREATE PROCEDURE PROC_XXBD_GJ_ZZSFP
/*
  编制人:严国平
  编制日期:202010
  功能:信息比对（购进自用货物免退税）
  调整日期：20201221，1、根据宁波加工区内退水电气大部分为小规模以及研发中心退国产设备政策第十三条，非增值税一般纳税人允许申报购进自用货物退税，对涉及一般纳税人资格的疑点进行调整
                      2、有关GJZY_BJGX_ZG_SDQ、GJZY_BJGX_ZG_GCSB这两个疑点的判断改成用当前日期，取消开票日期的判断
  调整日期：20201230，1、校验发票稽核信息时，剔除代开发票的稽核信息，代开发票开票人税号含DK
  调整日期：20220701，1、根据全电票规则调整发票的关联，用JHPZH代替FPDM+FPHM
  调整日期：20230207，1、修改全电发票关联虚开发票时的BUG。
  调整日期：20230315，调整出口企业首次申报日期取数口径，改为按税务机关+企业+业务代码查询首次发放日期
  调整日期：20230317，根据钱塘区项灵燕反应有企业发票重复申报进金三重复退税的问题，增加总量控制疑点
  调整日期：20230515，解决增值税发票外部数据部分数据稽核相符标志为空的问题（赋默认值N）
  调整日期：20230518，解决按税务机关+企业+业务代码查询首次发放日期有结果但日期为空的问题（赋默认值SYSDATE）
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LN_CPCODEKZ1    BIGINT;
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LDT_TODAY       DATETIME;
  DECLARE LDT_SCSBRQ      DATETIME;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';
  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  -- 购进自用货物发票记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_GJ_SBMX_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;

  -- 查询企业首次申报日期
  BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
      SET LDT_SCSBRQ =LDT_TODAY;

  END;
SELECT IFNULL(T.FFRQ, CURRENT_TIMESTAMP)
      INTO LDT_SCSBRQ
      FROM CKTS_TY_YWBLXX_SCFFRQ T
     WHERE T.TSSWJG_DM_1=(SELECT SWJG_DM FROM GS_DJ_CKTMSDAB WHERE NSRDZDAH=V_IN_NSRDZDAH)
       AND T.DJXH=V_IN_DJXH AND T.LCSWSX_DM='LCSXA081042002';
  END;

  SET LC_YDOBJECT ='购进自用';
  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_GJ_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'GJZY_JHMX_ZZSFP_WDZXX','E',ORA_CONCAT(ORA_CONCAT('进货凭证号码[', T.JHPZH), ']无电子信息！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_GJ_SBMX_LSB T
          WHERE T.SBID=V_IN_SBID
            AND T.JHPZZL_DM='1'
            AND NOT EXISTS (SELECT 1
                              FROM CKTS_WBSJ_FP_ZZSZYFPXX S
                             WHERE S.DJXH=V_IN_DJXH
                               AND S.JHPZH=T.JHPZH);
    COMMIT;
  END;

  BEGIN
    CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',LDT_TODAY,LC_FLGLCD, LN_CPCODEKZ);
    BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_SBXH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKTMSYWLXDMJH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_JHPZH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_KPRQ_SB_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_KPRQ_SH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_GHFNSRSBH_1_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_XFNSRSBH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_JHXFZZSZYFPBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_BYTSBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_FPYT_DM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_FPSJBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_NXZCKBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_GHFNSRSBH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_JSJE_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_SYJE_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TSE_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_SE_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT A.SBXH,
                          IFNULL(A.CKTMSYWLXDMJH, ' ') AS CKTMSYWLXDMJH,
                          A.JHPZH,
                          DATE(A.KPRQ) AS KPRQ_SB,
                          DATE(B.KPRQ) AS KPRQ_SH,
                          A.GHFNSRSBH_1,
                          B.XFNSRSBH,
                          IFNULL(B.JHXFZZSZYFPBZ, 'N') AS JHXFZZSZYFPBZ,
                          B.BYTSBZ,
                          B.FPYT_DM,
                          IFNULL(B.FPSJBBZ, 'N') AS FPSJBZ,
                          IFNULL(B.NXZCKBZ, 'N') AS NXZCKBZ,
                          C.GHFNSRSBH,
                          A.JSJE,
                          B.JE - IFNULL(B.HZCJJE, 0) - IFNULL(B.SBFPJSJE, 0) - IFNULL(B.LSLSBFPJSJE, 0) AS SYJE,
                          A.TSE,
                          B.SE
                     FROM CKTS_SB_GJ_SBMX_LSB A
                    INNER JOIN CKTS_WBSJ_FP_ZZSZYFPXX B ON B.DJXH=V_IN_DJXH AND B.JHPZH=A.JHPZH
                     LEFT JOIN CKTS_WBSJ_ZJ_XKFP C ON ORA_CONCAT(C.FP_DM, C.FPHM)=A.JHPZH
                    WHERE A.SBID=V_IN_SBID
                      AND A.JHPZZL_DM='1';
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_LSF_XX_SBXH_001, BJTS_LSF_XX_CKTMSYWLXDMJH_001, BJTS_LSF_XX_JHPZH_001, BJTS_LSF_XX_KPRQ_SB_001, BJTS_LSF_XX_KPRQ_SH_001, BJTS_LSF_XX_GHFNSRSBH_1_001, BJTS_LSF_XX_XFNSRSBH_001, BJTS_LSF_XX_JHXFZZSZYFPBZ_001, BJTS_LSF_XX_BYTSBZ_001, BJTS_LSF_XX_FPYT_DM_001, BJTS_LSF_XX_FPSJBZ_001, BJTS_LSF_XX_NXZCKBZ_001, BJTS_LSF_XX_GHFNSRSBH_001, BJTS_LSF_XX_JSJE_001, BJTS_LSF_XX_SYJE_001, BJTS_LSF_XX_TSE_001, BJTS_LSF_XX_SE_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
      BEGIN
        -- 20230317，根据钱塘区项灵燕反应有企业发票重复申报进金三重复退税的问题，增加总量控制疑点
        IF (BJTS_LSF_XX_JSJE_001 > BJTS_LSF_XX_SYJE_001) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_GJ_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'GJZY_JHMX_ZZSFP_SBJE','I',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('进货凭证号码[', BJTS_LSF_XX_JHPZH_001), ']申报退税的计税金额['), BJTS_LSF_XX_JSJE_001), ']超过电子信息中剩余数['), BJTS_LSF_XX_SYJE_001), ']，请检查是否重复申报！'),'Y',CURRENT_TIMESTAMP
;
          COMMIT;
        ELSEIF (BJTS_LSF_XX_TSE_001 > BJTS_LSF_XX_SE_001) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_GJ_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'GJZY_JHMX_ZZSFP_SBSE','E',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('进货凭证号码[', BJTS_LSF_XX_JHPZH_001), ']申报退税额['), BJTS_LSF_XX_TSE_001), ']超过电子信息中税额['), BJTS_LSF_XX_SE_001), ']！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (BJTS_LSF_XX_JHXFZZSZYFPBZ_001='N' AND INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_001,'GCSB')>0 AND INSTR(BJTS_LSF_XX_XFNSRSBH_001,'DK')=0 AND (LC_FLGLCD='D' OR (LC_FLGLCD='C' AND TIMESTAMPDIFF(MONTH, LDT_SCSBRQ, LDT_TODAY)<=12))) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_GJ_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'GJZY_JHMX_ZZSFP_WDZXX','E',ORA_CONCAT(ORA_CONCAT('进货凭证号码[', BJTS_LSF_XX_JHPZH_001), ']无稽核相符电子信息！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_BYTSBZ_001='Y' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_GJ_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'GJZY_JHMX_ZZSFP_BYTS','E',ORA_CONCAT(ORA_CONCAT('进货凭证号码[', BJTS_LSF_XX_JHPZH_001), ']已被标注为“不予退税”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_GHFNSRSBH_1_001<>BJTS_LSF_XX_XFNSRSBH_001 THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_GJ_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'GJZY_JHMX_ZZSFP_GHFNSR','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('进货凭证号码[', BJTS_LSF_XX_JHPZH_001), ']供货方纳税人['), BJTS_LSF_XX_GHFNSRSBH_1_001), ']与电子信息中['), BJTS_LSF_XX_XFNSRSBH_001), ']不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_KPRQ_SB_001<>BJTS_LSF_XX_KPRQ_SH_001 THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_GJ_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'WZF_DBTS_ZZSFP_KPRQ','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('进货凭证号码[', BJTS_LSF_XX_JHPZH_001), ']开票日期['), DATE_FORMAT(BJTS_LSF_XX_KPRQ_SB_001, '%Y-%m-%d')), ']与电子信息中['), DATE_FORMAT(BJTS_LSF_XX_KPRQ_SH_001, '%Y-%m-%d')), ']不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_FPYT_DM_001='3' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_GJ_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'WZF_DBTS_ZZSFP_DBTS','E',ORA_CONCAT(ORA_CONCAT('进货凭证号码[', BJTS_LSF_XX_JHPZH_001), ']在电子信息中申报用途代码为“3-代办退税”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
        IF (BJTS_LSF_XX_FPYT_DM_001='1' AND BJTS_LSF_XX_FPSJBZ_001='Y' AND BJTS_LSF_XX_NXZCKBZ_001='N') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_GJ_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'WZF_DBTS_ZZSFP_YDK','E',ORA_CONCAT(ORA_CONCAT('进货凭证号码[', BJTS_LSF_XX_JHPZH_001), ']在电子信息中已勾选用于抵扣！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_GHFNSRSBH_001 IS NOT NULL THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_GJ_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'WZF_DBTS_ZZSFP_XKFP','E',ORA_CONCAT(ORA_CONCAT('进货凭证号码[', BJTS_LSF_XX_JHPZH_001), ']在电子信息中为虚开增值税专用发票！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
      END;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;
  END;

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_GJ_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'GJZY_JHMX_CKYWLX_GCSB_PTFP','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('申报的增值税普通发票[', T.JHPZH), ']开票日期['), DATE_FORMAT(T.KPRQ, '%Y-%m-%d')), ']不符合申报条件，请检查确认！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_GJ_SBMX_LSB T
          WHERE T.SBID=V_IN_SBID
            AND INSTR(T.CKTMSYWLXDMJH,'GCSB')>0
            AND T.JHPZZL_DM='2'
            AND FUNC_XXBD_CHECK_GCSBKPRQ(T.KPRQ)=0;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_GJ_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'GJZY_JHMX_KPRQ_NSRZG','I',ORA_CONCAT(ORA_CONCAT('开票日期[', DATE_FORMAT(T.KPRQ, '%Y-%m-%d')), ']企业非增值税一般纳税人，请确认是否符合退税政策！'),'Y',CURRENT_TIMESTAMP
           FROM CKTS_SB_GJ_SBMX_LSB T
           LEFT JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='YBNSRRD' AND S.FLAG='1' AND T.KPRQ BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID
            AND INSTR(T.CKTMSYWLXDMJH,'GCSB')>0
            AND S.KZLX IS NULL;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_GJ_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'GJZY_JHMX_KPRQ_TQQY','E',ORA_CONCAT(ORA_CONCAT('开票日期[', DATE_FORMAT(T.KPRQ, '%Y-%m-%d')), ']企业处于出口退税停权期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_GJ_SBMX_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='TQQY' AND S.FLAG='1' AND T.KPRQ BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_GJ_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'GJZY_JHMX_KPRQ_MSQY','E',ORA_CONCAT(ORA_CONCAT('开票日期[', DATE_FORMAT(T.KPRQ, '%Y-%m-%d')), ']企业处于免税期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_GJ_SBMX_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='TSGMS' AND S.FLAG='1' AND T.KPRQ BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_GJ_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'GJZY_JHMX_KPRQ_FQTS','E',ORA_CONCAT(ORA_CONCAT('开票日期[', DATE_FORMAT(T.KPRQ, '%Y-%m-%d')), ']企业处于放弃退（免）税权选择免税期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_GJ_SBMX_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='FQTSSXMS' AND S.FLAG='1' AND T.KPRQ BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_GJ_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'GJZY_JHMX_KPRQ_FQTS','E',ORA_CONCAT(ORA_CONCAT('开票日期[', DATE_FORMAT(T.KPRQ, '%Y-%m-%d')), ']企业处于放弃退（免）税权选择征税期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_GJ_SBMX_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='FQTSSXZS' AND S.FLAG='1' AND T.KPRQ BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_GJ_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'GJZY_JHMX_KPRQ_FQTS','E',ORA_CONCAT(ORA_CONCAT('开票日期[', DATE_FORMAT(T.KPRQ, '%Y-%m-%d')), ']企业处于放弃退（免）税权期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_GJ_SBMX_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='FQTMS' AND S.FLAG='1' AND T.KPRQ BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_GJ_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'GJZY_BJGX_KZ_SDQ','E',ORA_CONCAT(ORA_CONCAT('出口业务类型为“水电气”，开票日期[', DATE_FORMAT(T.KPRQ, '%Y-%m-%d')), ']企业属于“海关特殊监管区域内的试点企业”！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_GJ_SBMX_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='TSQYYBNSRSDQY' AND S.FLAG='1' AND T.KPRQ BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID
            AND INSTR(T.CKTMSYWLXDMJH,'SDQ')>0;
    COMMIT;
  END;

  BEGIN
    CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'SDQ',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
    IF LN_CPCODEKZ=0 THEN
      INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
           SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                  'CKTS_SB_GJ_SBMX_LSB',NULL,NULL,NULL,NULL,'GJZY_BJGX_ZG_SDQ','E','出口业务类型为“水电气”，企业备案出口退（免）税管理类型未勾选“特殊区域内申报水电气退税业务的生产企业”！','N',CURRENT_TIMESTAMP

            WHERE EXISTS (SELECT 1
                            FROM CKTS_SB_GJ_SBMX_LSB T
                           WHERE T.SBID=V_IN_SBID
                             AND INSTR(T.CKTMSYWLXDMJH,'SDQ')>0);
      COMMIT;
    END IF;

    CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'NZYFJG',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
    CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'WZYFJG',LDT_TODAY,LC_KZXX, LN_CPCODEKZ1);
    IF LN_CPCODEKZ=0 AND LN_CPCODEKZ1=0 THEN
      INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
           SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                  'CKTS_SB_GJ_SBMX_LSB',NULL,NULL,NULL,NULL,'GJZY_BJGX_ZG_GCSB','E','出口业务类型为“国产设备”，企业备案出口退（免）税管理类型未勾选“内资研发机构”或“外资研发中心”！','N',CURRENT_TIMESTAMP

            WHERE EXISTS (SELECT 1
                            FROM CKTS_SB_GJ_SBMX_LSB T
                           WHERE T.SBID=V_IN_SBID
                             AND INSTR(T.CKTMSYWLXDMJH,'GCSB')>0);
      COMMIT;
    END IF;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_GJ_ZZSFP.sql

-- ======================================================================
-- [034/114] BEGIN SOURCE: PROC_XXBD_JHPZHT.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_JHPZHT$$

CREATE PROCEDURE PROC_XXBD_JHPZHT
/*
  编制人:严国平
  编制日期:202010
  功能:信息比对（进货凭证信息回退申请）
  调整日期：20220714，1、根据全电票规则调整发票的关联，用JHPZH代替FPDM+FPHM
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE BJTS_ROUTINE_EXIT BOOLEAN DEFAULT FALSE;
  DECLARE LDT_TODAY    DATETIME;

  DECLARE LC_QYHGDM       VARCHAR(20);
  DECLARE LC_QYLXDM       VARCHAR(20);
  DECLARE LC_TSJSFSDM     VARCHAR(20);
  DECLARE LC_WMZHFWQYBZ   VARCHAR(20);
  DECLARE LC_SFYSFW       VARCHAR(20);
  DECLARE LC_YSFW         VARCHAR(50);
  DECLARE LC_YSFS         VARCHAR(50);
  DECLARE LC_YFSJ         VARCHAR(50);
  DECLARE LC_ZXFLAG       VARCHAR(20);

  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LN_ROWNUM_TSSB  BIGINT;

  DECLARE LC_YDOBJECT     VARCHAR(20);

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  IF V_IN_SSSQ>DATE_FORMAT(CURRENT_TIMESTAMP, '%Y%m') THEN
    BEGIN
      SET V_OUT_STATUS ='05';
      SET V_OUT_MESSAGE ='申报所属时期超出合理范围！';
      LEAVE routine_body;
    END;
  END IF;

  -- 取各申报明细表数据记录
  BEGIN
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='06';
      SET V_OUT_MESSAGE ='查询申报记录数据失败！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT COUNT(1)
      INTO LN_ROWNUM_TSSB
      FROM CKTS_SB_MTS_JHPZHT_LSB
     WHERE SBID=V_IN_SBID;
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LN_ROWNUM_TSSB=0 THEN
    BEGIN
      SET V_OUT_STATUS ='07';
      SET V_OUT_MESSAGE ='申报数据为空！';
      LEAVE routine_body;
    END;
  END IF;

  -- 查询企业基本信息
  BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='08';
      SET V_OUT_MESSAGE ='企业当前未进行出口退（免）税备案，不允许申报除出口退（免）税备案以外的其他业务！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT T.QYHGDM, T.QYLX_DM, T.TSJSFS_DM, T.WMZHFWQYBZ, T.SFYSFW, T.YSFW, T.YSFS, T.YFSJ, T.ZX_FLAG
      INTO LC_QYHGDM, LC_QYLXDM, LC_TSJSFSDM, LC_WMZHFWQYBZ, LC_SFYSFW, LC_YSFW, LC_YSFS, LC_YFSJ, LC_ZXFLAG
      FROM GS_DJ_CKTMSDAB T
     WHERE T.NSRDZDAH=V_IN_NSRDZDAH;
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LC_ZXFLAG='R' THEN
    BEGIN
      SET V_OUT_STATUS ='09';
      SET V_OUT_MESSAGE ='企业当前已出口退（免）税备案撤回，不允许申报除出口退（免）税备案以外的其他业务！';
      LEAVE routine_body;
    END;
  END IF;

  -- 取企业的FLGLCD信息, TGSHZL信息，判断是否需要申报收汇
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',LDT_TODAY,LC_FLGLCD, LN_CPCODEKZ);
  IF LN_CPCODEKZ=0 THEN
    BEGIN
      SET V_OUT_STATUS ='10';
      SET V_OUT_MESSAGE ='查询出口企业分类管理类型出错！';
      LEAVE routine_body;
    END;
  END IF;

  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TQQY',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 THEN
    BEGIN
      SET V_OUT_STATUS ='13';
      SET V_OUT_MESSAGE ='企业当前处于出口退税停权期间，不允许申报出口退（免）税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTSSXMS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_TSSB>0 THEN
    BEGIN
      SET V_OUT_STATUS ='14';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权选择免税期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTSSXZS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_TSSB>0 THEN
    BEGIN
      SET V_OUT_STATUS ='15';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权选择征税期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTMS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_TSSB>0 THEN
    BEGIN
      SET V_OUT_STATUS ='16';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;

  SET LC_YDOBJECT ='勾选撤回';
  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_JHPZHT_LSB',NULL,NULL,T.SBXH,NULL,'GXCH_PZHM_ZYFP_BZC','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('发票代码[', T.FP_DM), ']发票号码['), T.FPHM), ']在电子信息中不存在！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_JHPZHT_LSB T
          WHERE T.SBID=V_IN_SBID
            AND T.FPHM IS NOT NULL
            AND NOT EXISTS (SELECT 1
                              FROM CKTS_WBSJ_FP_ZZSZYFPXX S
                             WHERE S.DJXH=V_IN_DJXH
                               AND S.JHPZH=ORA_CONCAT(T.FP_DM, T.FPHM));
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_JHPZHT_LSB',NULL,NULL,T.SBXH,NULL,'GXCH_PZHM_XHFSH_BYZ','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('发票代码[', T.FP_DM), ']发票号码['), T.FPHM), ']销货方税号['), T.XHFSHXYDM), ']与电子信息中['), S.XFNSRSBH), ']不一致！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_JHPZHT_LSB T
          INNER JOIN CKTS_WBSJ_FP_ZZSZYFPXX S ON S.DJXH=V_IN_DJXH AND S.JHPZH=ORA_CONCAT(T.FP_DM, T.FPHM)
          WHERE T.SBID=V_IN_SBID
            AND T.XHFSHXYDM <> S.XFNSRSBH;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_JHPZHT_LSB',NULL,NULL,T.SBXH,NULL,'GXCH_PZHM_JKS_BZC','E',ORA_CONCAT(ORA_CONCAT('缴款书号码[', T.HGZYJKSHM), ']在电子信息中不存在！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_JHPZHT_LSB T
          WHERE T.SBID=V_IN_SBID
            AND T.HGZYJKSHM IS NOT NULL
            AND NOT EXISTS (SELECT 1
                              FROM CKTS_WBSJ_HG_JKJKS S
                             WHERE S.DJXH=V_IN_DJXH
                               AND S.HGZYJKSHM=T.HGZYJKSHM);
    COMMIT;
  END;

END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_JHPZHT.sql

-- ======================================================================
-- [035/114] BEGIN SOURCE: PROC_XXBD_JSB.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_JSB$$

CREATE PROCEDURE PROC_XXBD_JSB
/*
  编制人:严国平
  编制日期:202010
  功能:信息比对（出口已使用旧设备退税）
  修改日期：20220615，根据2022年9号公告，合并收汇与不能收汇
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE BJTS_ROUTINE_EXIT BOOLEAN DEFAULT FALSE;
  DECLARE LDT_TODAY       DATETIME;

  DECLARE LC_QYHGDM       VARCHAR(20);
  DECLARE LC_QYLXDM       VARCHAR(20);
  DECLARE LC_TSJSFSDM     VARCHAR(20);
  DECLARE LC_WMZHFWQYBZ   VARCHAR(20);
  DECLARE LC_SFYSFW       VARCHAR(20);
  DECLARE LC_YSFW         VARCHAR(50);
  DECLARE LC_YSFS         VARCHAR(50);
  DECLARE LC_YFSJ         VARCHAR(50);
  DECLARE LC_ZXFLAG       VARCHAR(20);

  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LN_TGSHZL       BIGINT;
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LN_ROWNUM_CKMX  BIGINT;
  DECLARE LN_ROWNUM_CKSH  BIGINT;
  DECLARE LN_ROWNUM_CQSB  BIGINT;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';
  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  IF V_IN_SSSQ>DATE_FORMAT(CURRENT_TIMESTAMP, '%Y%m') THEN
    BEGIN
      SET V_OUT_STATUS ='05';
      SET V_OUT_MESSAGE ='申报所属时期超出合理范围！';
      LEAVE routine_body;
    END;
  END IF;

  -- 取各申报明细表数据记录
  BEGIN
  DECLARE BJTS_SQLCODE_009 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_009 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_009 = MYSQL_ERRNO, BJTS_SQLERRM_009 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='06';
      SET V_OUT_MESSAGE ='查询申报记录数据失败！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT COUNT(1)
      INTO LN_ROWNUM_CKMX
      FROM CKTS_SB_YS_SBMX_LSB
     WHERE SBID=V_IN_SBID;
    SELECT COUNT(1)
      INTO LN_ROWNUM_CKSH
      FROM CKTS_SB_YS_CKSH_LSB
     WHERE SBID=V_IN_SBID;
    SELECT COUNT(1)
      INTO LN_ROWNUM_CQSB
      FROM CKTS_SB_YS_SBMX_LSB
     WHERE SBID=V_IN_SBID
       AND (((STR_TO_DATE(ORA_CONCAT(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y'), '0420'), '%Y%m%d')<DATE(CURRENT_TIMESTAMP)) AND (CKRQ_1<MAKEDATE(YEAR(CURRENT_TIMESTAMP), 1))) OR (CKRQ_1<DATE_ADD(MAKEDATE(YEAR(CURRENT_TIMESTAMP), 1), INTERVAL -12 MONTH)));
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LN_ROWNUM_CKMX=0 THEN
    BEGIN
      SET V_OUT_STATUS ='07';
      SET V_OUT_MESSAGE ='申报数据为空！';
      LEAVE routine_body;
    END;
  END IF;

  -- 查询企业基本信息
  BEGIN
  DECLARE BJTS_SQLCODE_008 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_008 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_008 = MYSQL_ERRNO, BJTS_SQLERRM_008 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='08';
      SET V_OUT_MESSAGE ='企业当前未进行出口退（免）税备案，不允许申报除出口退（免）税备案以外的其他业务！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT T.QYHGDM, T.QYLX_DM, T.TSJSFS_DM, T.WMZHFWQYBZ, T.SFYSFW, T.YSFW, T.YSFS, T.YFSJ, T.ZX_FLAG
      INTO LC_QYHGDM, LC_QYLXDM, LC_TSJSFSDM, LC_WMZHFWQYBZ, LC_SFYSFW, LC_YSFW, LC_YSFS, LC_YFSJ, LC_ZXFLAG
      FROM GS_DJ_CKTMSDAB T
     WHERE T.NSRDZDAH=V_IN_NSRDZDAH;
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LC_ZXFLAG='Y' THEN
    BEGIN
      SET V_OUT_STATUS ='09';
      SET V_OUT_MESSAGE ='企业当前已出口退（免）税备案撤回，不允许申报除出口退（免）税备案以外的其他业务！';
      LEAVE routine_body;
    END;
  END IF;

  -- 取企业的FLGLCD信息, TGSHZL信息，判断是否需要申报收汇
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',LDT_TODAY,LC_FLGLCD, LN_CPCODEKZ);
  IF LN_CPCODEKZ=0 THEN
    BEGIN
      SET V_OUT_STATUS ='10';
      SET V_OUT_MESSAGE ='查询出口企业分类管理类型出错！';
      LEAVE routine_body;
    END;
  END IF;

  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'YBNSRRD',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=0 THEN
    BEGIN
      SET V_OUT_STATUS ='12';
      SET V_OUT_MESSAGE ='企业当前非增值税一般纳税人，不允许申报出口退（免）税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TQQY',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 THEN
    BEGIN
      SET V_OUT_STATUS ='13';
      SET V_OUT_MESSAGE ='企业当前处于出口退税停权期间，不允许申报出口退（免）税业务！';
      LEAVE routine_body;
    END;
  END IF;

  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTSSXMS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_CKMX>0 THEN
    BEGIN
      SET V_OUT_STATUS ='14';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权选择免税期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTSSXZS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_CKMX>0 THEN
    BEGIN
      SET V_OUT_STATUS ='15';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权选择征税期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTMS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_CKMX>0 THEN
    BEGIN
      SET V_OUT_STATUS ='16';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;

  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TGSHZL',LDT_TODAY,LC_KZXX, LN_TGSHZL);
  IF (LC_FLGLCD='D') AND LN_ROWNUM_CKMX>0 AND LN_ROWNUM_CKSH=0 THEN
    BEGIN
      SET V_OUT_STATUS ='27';
      SET V_OUT_MESSAGE ='出口退（免）税管理类别为四类的企业，申报出口退免税时必须申报收汇情况表！';
      LEAVE routine_body;
    END;
  ELSEIF (LN_TGSHZL>0) AND LN_ROWNUM_CKMX>0 AND LN_ROWNUM_CKSH=0 THEN
    BEGIN
      SET V_OUT_STATUS ='28';
      SET V_OUT_MESSAGE ='被认定为需提供收汇资料的企业，申报出口退免税时必须申报收汇情况表！';
      LEAVE routine_body;
    END;
  ELSEIF (LN_ROWNUM_CQSB>0) AND LN_ROWNUM_CKMX>0 AND LN_ROWNUM_CKSH=0 THEN
    BEGIN
      SET V_OUT_STATUS ='29';
      SET V_OUT_MESSAGE ='超期申报数据，申报出口退免税时必须申报收汇情况表！';
      LEAVE routine_body;
    END;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_007 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_007 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_007 = MYSQL_ERRNO, BJTS_SQLERRM_007 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='51';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口已使用旧设备退税明细自检出错：', BJTS_SQLCODE_007), ' - '), BJTS_SQLERRM_007);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_JSB_TSSB(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_006 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_006 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_006 = MYSQL_ERRNO, BJTS_SQLERRM_006 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='52';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口报关单自检出错：', BJTS_SQLCODE_006), ' - '), BJTS_SQLERRM_006);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_JSB_TSSB_BGD(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_005 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_005 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_005 = MYSQL_ERRNO, BJTS_SQLERRM_005 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='53';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口证明自检出错：', BJTS_SQLCODE_005), ' - '), BJTS_SQLERRM_005);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_JSB_TSSB_DLZM(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_004 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_004 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_004 = MYSQL_ERRNO, BJTS_SQLERRM_004 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='54';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('增值税专用发票自检出错：', BJTS_SQLCODE_004), ' - '), BJTS_SQLERRM_004);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_JSB_TSSB_ZZSFP(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_003 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_003 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_003 = MYSQL_ERRNO, BJTS_SQLERRM_003 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='55';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('海关进口增值税缴款书自检出错：', BJTS_SQLCODE_003), ' - '), BJTS_SQLERRM_003);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_JSB_TSSB_JKZZS(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='62';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口收汇申报资料自检出错：', BJTS_SQLCODE_002), ' - '), BJTS_SQLERRM_002);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_JSB_CKSH(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='63';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('海关商品代码调整表自检出错：', BJTS_SQLCODE_001), ' - '), BJTS_SQLERRM_001);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_JSB_HGSPTZ(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_JSB.sql

-- ======================================================================
-- [036/114] BEGIN SOURCE: PROC_XXBD_JSB_BNSH.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_JSB_BNSH$$

CREATE PROCEDURE PROC_XXBD_JSB_BNSH
/*
  编制人:严国平
  编制日期:202010
  功能:信息比对（出口已使用旧设备退税）
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 不能收汇明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_YS_BNSH_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;
  SET LC_YDOBJECT ='不能收汇';

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_YS_BNSH_LSB','CKTS_SB_YS_SBMX_LSB',NULL,T.SBXH,NULL,'JSB_BJGX_SHZL_CKMX_CKPZ','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', T.CKBGDH), ']未申报已使用旧设备出口明细！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_BNSH_LSB T
          WHERE T.SBID=V_IN_SBID
            AND T.CKBGDH IS NOT NULL
            AND NOT EXISTS (SELECT 1 FROM CKTS_SB_YS_SBMX_LSB S WHERE S.SBID=T.SBID AND IFNULL(S.CKBGDH, S.DLCKHWZMHM)=T.CKBGDH);
    COMMIT;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_JSB_BNSH.sql

-- ======================================================================
-- [037/114] BEGIN SOURCE: PROC_XXBD_JSB_CKSH.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_JSB_CKSH$$

CREATE PROCEDURE PROC_XXBD_JSB_CKSH
/*
  编制人:严国平
  编制日期:202010
  功能:信息比对（出口已使用旧设备退税）
  修改日期：20220615，根据2022年9号公告，四类企业，需提供银行水单企业收汇情况表必须申报本期出口退税，非上述企业改为提示性疑点
  修改日期：20230207，修改代理证明出口申报收汇表的疑点逻辑和提示
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LDT_TODAY       DATETIME;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';
  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  -- 收汇明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_YS_CKSH_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;

  SET LC_YDOBJECT ='出口收汇';
  BEGIN
    CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',LDT_TODAY,LC_FLGLCD, LN_CPCODEKZ);
    CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TGSHZL',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
    IF (LC_FLGLCD='D') OR (LN_CPCODEKZ>0) THEN
      BEGIN
        INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
             SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                    'CKTS_SB_YS_CKSH_LSB','CKTS_SB_YS_SBMX_LSB',NULL,T.SBXH,NULL,'JSB_BJGX_SHZL_CKMX_CKPZ','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', IFNULL(T.DLCKHWZMHM, T.CKBGDH)), ']未申报退税！'),'N',CURRENT_TIMESTAMP
               FROM CKTS_SB_YS_CKSH_LSB T
              WHERE T.SBID=V_IN_SBID
                AND NOT EXISTS (SELECT 1 FROM CKTS_SB_YS_SBMX_LSB S WHERE S.SBID=T.SBID AND IFNULL(S.DLCKHWZMHM, S.CKBGDH)=IFNULL(T.DLCKHWZMHM, T.CKBGDH));
        COMMIT;
      END;
    ELSE
      BEGIN
        INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
             SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                    'CKTS_SB_YS_CKSH_LSB','CKTS_SB_YS_SBMX_LSB',NULL,T.SBXH,NULL,'JSB_BJGX_SHZL_CKMX_CKPZ','I',ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', IFNULL(T.DLCKHWZMHM, T.CKBGDH)), ']本期未申报退税！'),'Y',CURRENT_TIMESTAMP
               FROM CKTS_SB_YS_CKSH_LSB T
              WHERE T.SBID=V_IN_SBID
                AND NOT EXISTS (SELECT 1 FROM CKTS_SB_YS_SBMX_LSB S WHERE S.SBID=T.SBID AND IFNULL(S.DLCKHWZMHM, S.CKBGDH)=IFNULL(T.DLCKHWZMHM, T.CKBGDH));
        COMMIT;
      END;
    END IF;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_JSB_CKSH.sql

-- ======================================================================
-- [038/114] BEGIN SOURCE: PROC_XXBD_JSB_HGSPTZ.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_JSB_HGSPTZ$$

CREATE PROCEDURE PROC_XXBD_JSB_HGSPTZ
/*
  编制人:严国平
  编制日期:202010
  功能:信息比对（出口已使用旧设备退税）
  修改日期：20230207，修改代理证明出口申报调整表的疑点逻辑和提示
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 海关代码调整明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_YS_HGSPTZ_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;
  SET LC_YDOBJECT ='代码调整';

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_YS_HGSPTZ_LSB','CKTS_SB_YS_SBMX_LSB',NULL,T.SBXH,NULL,'JSB_BJGX_DMTZ_CKMX_CKPZ','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', IFNULL(T.DLCKHWZMHM, T.CKBGDH)), ']未申报免退税出口明细！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_YS_HGSPTZ_LSB T
          WHERE T.SBID=V_IN_SBID
            AND NOT EXISTS (SELECT 1 FROM CKTS_SB_YS_SBMX_LSB S WHERE S.SBID=T.SBID AND IFNULL(S.DLCKHWZMHM, S.CKBGDH)=IFNULL(T.DLCKHWZMHM, T.CKBGDH));
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_YS_HGSPTZ_LSB','CKTS_SB_YS_SBMX_LSB',NULL,T.SBXH,NULL,'JSB_BJGX_DMTZ_CKMX_CKRQ','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', IFNULL(T.DLCKHWZMHM, T.CKBGDH)), ']的出口日期与免退税出口明细表中不一致！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_YS_HGSPTZ_LSB T
          INNER JOIN CKTS_SB_YS_SBMX_LSB S ON S.SBID=T.SBID AND IFNULL(S.DLCKHWZMHM, S.CKBGDH)=IFNULL(T.DLCKHWZMHM, T.CKBGDH)
          WHERE T.SBID=V_IN_SBID
            AND DATE(T.CKRQ_1)<>DATE(S.CKRQ_1);
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_YS_HGSPTZ_LSB','CKTS_SB_YS_SBMX_LSB',NULL,T.SBXH,NULL,'JSB_BJGX_DMTZ_CKMX_SPDM','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', IFNULL(T.DLCKHWZMHM, T.CKBGDH)), ']调整前商品代码与免退税出口明细表中不一致！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_YS_HGSPTZ_LSB T
          INNER JOIN CKTS_SB_YS_SBMX_LSB S ON S.SBID=T.SBID AND IFNULL(S.DLCKHWZMHM, S.CKBGDH)=IFNULL(T.DLCKHWZMHM, T.CKBGDH)
          WHERE T.SBID=V_IN_SBID
            AND T.CKSP_DM<>S.CKSP_DM;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_YS_HGSPTZ_LSB','CKTS_SB_YS_SBMX_LSB',NULL,T.SBXH,NULL,'JSB_BJGX_DMTZ_CKMX_ZSLV','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', IFNULL(T.DLCKHWZMHM, T.CKBGDH)), ']调整后商品代码在对应出口日期的退税率文库中的征税率与货物出口明细表中不一致！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_YS_HGSPTZ_LSB T
          INNER JOIN CKTS_SB_YS_SBMX_LSB S ON S.SBID=T.SBID AND IFNULL(S.DLCKHWZMHM, S.CKBGDH)=IFNULL(T.DLCKHWZMHM, T.CKBGDH)
           LEFT JOIN CKTS_DM_TSLVWK C ON C.CKSP_DM=T.TZHCKSP_DM AND S.CKRQ_1 BETWEEN C.YXQQ AND C.YXQZ
           LEFT JOIN CKTS_DM_TSLVTZ D ON D.CKSP_DM=T.TZHCKSP_DM AND S.CKRQ_1 BETWEEN D.KSSJ AND D.JSSJ
          WHERE T.SBID=V_IN_SBID
            AND IFNULL(IFNULL(D.ZSSL, C.ZSSL), 0)<>S.ZSSL;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_YS_HGSPTZ_LSB','CKTS_SB_YS_SBMX_LSB',NULL,T.SBXH,NULL,'JSB_BJGX_DMTZ_CKMX_TSLV','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', IFNULL(T.DLCKHWZMHM, T.CKBGDH)), ']调整后退税率与免退税进货明细表中不一致！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_YS_HGSPTZ_LSB T
          INNER JOIN CKTS_SB_YS_SBMX_LSB S ON S.SBID=T.SBID AND IFNULL(S.DLCKHWZMHM, S.CKBGDH)=IFNULL(T.DLCKHWZMHM, T.CKBGDH)
          WHERE T.SBID=V_IN_SBID
            AND T.TZHTSL<>S.TSL;
    COMMIT;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_JSB_HGSPTZ.sql

-- ======================================================================
-- [039/114] BEGIN SOURCE: PROC_XXBD_JSB_TSSB.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_JSB_TSSB$$

CREATE PROCEDURE PROC_XXBD_JSB_TSSB
/*
  编制人:严国平
  编制日期:202010
  功能:信息比对（出口已使用旧设备退税）
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LDT_TODAY       DATETIME;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';
  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  -- 出口明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_YS_SBMX_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;

  SET LC_YDOBJECT ='已用设备';
  BEGIN
    CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',LDT_TODAY,LC_FLGLCD, LN_CPCODEKZ);
    CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TGSHZL',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
    IF (LC_FLGLCD='D') OR (LN_CPCODEKZ>0) THEN
      BEGIN
        INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
             SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                    'CKTS_SB_YS_SBMX_LSB','CKTS_SB_YS_CKSH_LSB',NULL,T.SBXH,NULL,'JSB_BJGX_CKMX_SHZL_CKPZ','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), T.DLCKHWZMHM), ']未申报收汇资料！'),'N',CURRENT_TIMESTAMP
               FROM CKTS_SB_YS_SBMX_LSB T
              WHERE T.SBID=V_IN_SBID
                AND NOT EXISTS (SELECT 1 FROM CKTS_SB_YS_CKSH_LSB S WHERE S.SBID=T.SBID AND ORA_CONCAT(S.CKBGDH, S.DLCKHWZMHM)=ORA_CONCAT(T.CKBGDH, T.DLCKHWZMHM));
        COMMIT;
      END;
    ELSE
      BEGIN
        INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
             SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                    'CKTS_SB_YS_SBMX_LSB','CKTS_SB_YS_CKSH_LSB',NULL,T.SBXH,NULL,'JSB_BJGX_CKMX_SHZL_CKPZ','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), T.DLCKHWZMHM), ']未申报收汇资料！'),'N',CURRENT_TIMESTAMP
               FROM CKTS_SB_YS_SBMX_LSB T
              WHERE T.SBID=V_IN_SBID
                AND (((STR_TO_DATE(ORA_CONCAT(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y'), '0419'), '%Y%m%d')<CURRENT_TIMESTAMP) AND (CKRQ_1<MAKEDATE(YEAR(CURRENT_TIMESTAMP), 1))) OR (CKRQ_1<DATE_ADD(MAKEDATE(YEAR(CURRENT_TIMESTAMP), 1), INTERVAL -12 MONTH)))
                AND NOT EXISTS (SELECT 1 FROM CKTS_SB_YS_CKSH_LSB S WHERE S.SBID=T.SBID AND ORA_CONCAT(S.CKBGDH, S.DLCKHWZMHM)=ORA_CONCAT(T.CKBGDH, T.DLCKHWZMHM));
        COMMIT;
      END;
    END IF;
  END;

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_YS_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'JSB_CKMX_CKRQ_NSRZG','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.CKRQ_1, '%Y-%m-%d')), ']企业非增值税一般纳税人！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_YS_SBMX_LSB T
           LEFT JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='YBNSRRD' AND S.FLAG='1' AND T.CKRQ_1 BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID
            AND S.KZLX IS NULL;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_YS_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'JSB_CKMX_CKRQ_TQQY','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.CKRQ_1, '%Y-%m-%d')), ']企业处于出口退税停权期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_YS_SBMX_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='TQQY' AND S.FLAG='1' AND T.CKRQ_1 BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_YS_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'JSB_CKMX_CKRQ_MSQY','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.CKRQ_1, '%Y-%m-%d')), ']企业处于免税期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_YS_SBMX_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='TSGMS' AND S.FLAG='1' AND T.CKRQ_1 BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_YS_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'JSB_CKMX_CKRQ_FQTS','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.CKRQ_1, '%Y-%m-%d')), ']企业处于放弃退（免）税权选择免税期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_YS_SBMX_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='FQTSSXMS' AND S.FLAG='1' AND T.CKRQ_1 BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_YS_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'JSB_CKMX_CKRQ_FQTS','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.CKRQ_1, '%Y-%m-%d')), ']企业处于放弃退（免）税权选择征税期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_YS_SBMX_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='FQTSSXZS' AND S.FLAG='1' AND T.CKRQ_1 BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_YS_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'JSB_CKMX_CKRQ_FQTS','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.CKRQ_1, '%Y-%m-%d')), ']企业处于放弃退（免）税权期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_YS_SBMX_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='FQTMS' AND S.FLAG='1' AND T.CKRQ_1 BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_JSB_TSSB.sql

-- ======================================================================
-- [040/114] BEGIN SOURCE: PROC_XXBD_JSB_TSSB_BGD.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_JSB_TSSB_BGD$$

CREATE PROCEDURE PROC_XXBD_JSB_TSSB_BGD
/*
  编制人:严国平
  编制日期:202010
  功能:信息比对（出口已使用旧设备退税）
  调整日期：20201119，1、调整改单报关单监控条件，由bgd202不存在改为bgd201.gdbz_1<>Y
  调整日期：20210113，1、调整改单报关单监控条件，改为bgd202不存在 且 bgd201.gdbz_1<>Y
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LN_CMCD_LEN     BIGINT;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 报关单出口明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_YS_SBMX_LSB T
     WHERE T.SBID=V_IN_SBID
       AND T.CKBGDH IS NOT NULL;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;

  SET LC_YDOBJECT ='出口报关单';
  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_YS_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'JSB_CKMX_BGD_WDZXX','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), ']无电子信息！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_YS_SBMX_LSB T
          WHERE T.SBID=V_IN_SBID
            AND T.CKBGDH IS NOT NULL
            AND NOT EXISTS (SELECT 1 FROM CKTS_WBSJ_HG_BGD201 S WHERE S.DJXH=V_IN_DJXH AND S.CKBGDH=T.CKBGDH);
    COMMIT;
  END;

  BEGIN
    BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_SBXH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKBGDH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_BYTSBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKRQ_SB_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKRQ_SH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSP_DM_SB_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSP_DM_SH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TYYBSWTSTYLX_DM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_GDBZ_1_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKBGDH_GD_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_JGFS_DM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_JGFSTSLX_DM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_YSFS_DM_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT A.SBXH,
                          A.CKBGDH,
                          B.BYTSBZ,
                          DATE(A.CKRQ_1) AS CKRQ_SB,
                          DATE(B.CKRQ_1) AS CKRQ_SH,
                          A.CKSP_DM AS CKSP_DM_SB,
                          B.CKSP_DM AS CKSP_DM_SH,
                          D.TYYBSWTSTYLX_DM,
                          IFNULL(B.GDBZ_1, ' ') AS GDBZ_1,
                          E.CKBGDH AS CKBGDH_GD,
                          C.JGFS_DM,
                          C.JGFSTSLX_DM,
                          B.YSFS_DM
                     FROM CKTS_SB_YS_SBMX_LSB A
                    INNER JOIN CKTS_WBSJ_HG_BGD201 B ON B.DJXH=V_IN_DJXH AND B.CKBGDH=A.CKBGDH
                     LEFT JOIN CKTS_DM_HGJGFS C ON C.JGFS_DM=B.JGFS_DM
                     LEFT JOIN CKTS_JGB_ZM_TYYBSWTS D ON D.DJXH=V_IN_DJXH AND D.CKBGDH=A.CKBGDH AND IFNULL(D.ZFBZ_1, 'N')='N'
                     LEFT JOIN CKTS_WBSJ_HG_BGD202 E ON D.DJXH=V_IN_DJXH AND E.CKBGDH=A.CKBGDH
                    WHERE A.SBID=V_IN_SBID
                      AND A.CKBGDH IS NOT NULL;
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_LSF_XX_SBXH_001, BJTS_LSF_XX_CKBGDH_001, BJTS_LSF_XX_BYTSBZ_001, BJTS_LSF_XX_CKRQ_SB_001, BJTS_LSF_XX_CKRQ_SH_001, BJTS_LSF_XX_CKSP_DM_SB_001, BJTS_LSF_XX_CKSP_DM_SH_001, BJTS_LSF_XX_TYYBSWTSTYLX_DM_001, BJTS_LSF_XX_GDBZ_1_001, BJTS_LSF_XX_CKBGDH_GD_001, BJTS_LSF_XX_JGFS_DM_001, BJTS_LSF_XX_JGFSTSLX_DM_001, BJTS_LSF_XX_YSFS_DM_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
      BEGIN
        IF BJTS_LSF_XX_BYTSBZ_001='Y' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_YS_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'JSB_CKMX_BGD_BYTS','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']已被标注为“不予退税”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (BJTS_LSF_XX_CKRQ_SB_001<>BJTS_LSF_XX_CKRQ_SH_001) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_YS_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'JSB_CKMX_BGD_CKRQ','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']出口日期['), DATE_FORMAT(BJTS_LSF_XX_CKRQ_SB_001, '%Y-%m-%d')), ']与电子信息中['), DATE_FORMAT(BJTS_LSF_XX_CKRQ_SH_001, '%Y-%m-%d')), ']不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        SET LN_CMCD_LEN = CASE WHEN LENGTH(BJTS_LSF_XX_CKSP_DM_SB_001) > LENGTH(BJTS_LSF_XX_CKSP_DM_SH_001) THEN LENGTH(BJTS_LSF_XX_CKSP_DM_SH_001) ELSE LENGTH(BJTS_LSF_XX_CKSP_DM_SB_001) END;
        IF SUBSTR(BJTS_LSF_XX_CKSP_DM_SB_001,1,LN_CMCD_LEN)<>SUBSTR(BJTS_LSF_XX_CKSP_DM_SH_001,1,LN_CMCD_LEN) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_YS_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'JSB_CKMX_BGD_SPDM','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']商品代码['), BJTS_LSF_XX_CKSP_DM_SB_001), ']与电子信息中['), BJTS_LSF_XX_CKSP_DM_SH_001), ']不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        -- 1退运; 2改单; 3撤单
        IF BJTS_LSF_XX_TYYBSWTSTYLX_DM_001='3' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_YS_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'JSB_CKMX_BGD_CD','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']曾办理过用途为”撤单“的有效的退运证明！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        ELSEIF (BJTS_LSF_XX_TYYBSWTSTYLX_DM_001='2' AND BJTS_LSF_XX_GDBZ_1_001<>'Y' AND BJTS_LSF_XX_CKBGDH_GD_001 IS NULL) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_YS_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'JSB_CKMX_BGD_GD','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']曾办理过用途为“改单”的有效的退运证明，且在“海关出口报关单改单数据”中不存在！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (TRIM(BJTS_LSF_XX_JGFS_DM_001) IS NULL) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_YS_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'JSB_CKMX_BGD_MYXZ_BCZ','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']在电子信息中监管方式不存在！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        ELSE
          IF (TRIM(BJTS_LSF_XX_JGFSTSLX_DM_001)='0') THEN
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                        'CKTS_SB_YS_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'JSB_CKMX_BGD_MYXZ_BTS','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']在电子信息中监管方式['), BJTS_LSF_XX_JGFS_DM_001), ']不退税！'),'N',CURRENT_TIMESTAMP
;
            COMMIT;
          END IF;
        END IF;

        IF BJTS_LSF_XX_YSFS_DM_001='T' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_YS_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'JSB_CKMX_CKPZH_YSFS','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']为出口到综合试验区（横琴平潭地区）的报关单！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
      END;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_JSB_TSSB_BGD.sql

-- ======================================================================
-- [041/114] BEGIN SOURCE: PROC_XXBD_JSB_TSSB_DLZM.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_JSB_TSSB_DLZM$$

CREATE PROCEDURE PROC_XXBD_JSB_TSSB_DLZM
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（出口已使用旧设备退税）
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LN_CMCD_LEN     BIGINT;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 代理证明号出口明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_YS_SBMX_LSB T
     WHERE T.SBID=V_IN_SBID
       AND T.DLCKHWZMHM IS NOT NULL;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;

  SET LC_YDOBJECT ='代理证明';
  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_YS_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'JSB_CKMX_DLZM_WDZXX','E',ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', T.DLCKHWZMHM), ']无电子信息！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_YS_SBMX_LSB T
          WHERE T.SBID=V_IN_SBID
            AND T.DLCKHWZMHM IS NOT NULL
            AND NOT EXISTS (SELECT 1 FROM CKTS_WBSJ_ZJ_DLCKHWZM S WHERE S.DJXH=V_IN_DJXH AND S.DLCKHWZMHM=T.DLCKHWZMHM);
    COMMIT;
  END;

  BEGIN
    BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_SBXH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_DLCKHWZMHM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_BYTSBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKRQ_SB_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKRQ_SH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSP_DM_SB_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSP_DM_SH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_JGFS_DM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_JGFSTSLX_DM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_YSFS_DM_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT A.SBXH,
                          A.DLCKHWZMHM,
                          B.BYTSBZ,
                          DATE(A.CKRQ_1) AS CKRQ_SB,
                          DATE(B.CKRQ_1) AS CKRQ_SH,
                          A.CKSP_DM AS CKSP_DM_SB,
                          B.CKSP_DM AS CKSP_DM_SH,
                          C.JGFS_DM,
                          C.JGFSTSLX_DM,
                          B.YSFS_DM
                     FROM CKTS_SB_YS_SBMX_LSB A
                    INNER JOIN CKTS_WBSJ_ZJ_DLCKHWZM B ON B.DJXH=V_IN_DJXH AND B.DLCKHWZMHM=A.DLCKHWZMHM
                     LEFT JOIN CKTS_DM_HGJGFS C ON C.JGFS_DM=B.JGFS_DM
                    WHERE A.SBID=V_IN_SBID
                      AND A.DLCKHWZMHM IS NOT NULL;
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_LSF_XX_SBXH_001, BJTS_LSF_XX_DLCKHWZMHM_001, BJTS_LSF_XX_BYTSBZ_001, BJTS_LSF_XX_CKRQ_SB_001, BJTS_LSF_XX_CKRQ_SH_001, BJTS_LSF_XX_CKSP_DM_SB_001, BJTS_LSF_XX_CKSP_DM_SH_001, BJTS_LSF_XX_JGFS_DM_001, BJTS_LSF_XX_JGFSTSLX_DM_001, BJTS_LSF_XX_YSFS_DM_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
      BEGIN
        IF BJTS_LSF_XX_BYTSBZ_001='Y' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_YS_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'JSB_CKMX_DLZM_BYTS','E',ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_001), ']已被标注为“不予退税”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF ((BJTS_LSF_XX_CKRQ_SB_001<>BJTS_LSF_XX_CKRQ_SH_001)) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_YS_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'JSB_CKMX_DLZM_CKRQ','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_001), ']出口日期['), DATE_FORMAT(BJTS_LSF_XX_CKRQ_SB_001, '%Y-%m-%d')), ']与电子信息中['), DATE_FORMAT(BJTS_LSF_XX_CKRQ_SH_001, '%Y-%m-%d')), ']不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        SET LN_CMCD_LEN = CASE WHEN LENGTH(BJTS_LSF_XX_CKSP_DM_SB_001) > LENGTH(BJTS_LSF_XX_CKSP_DM_SH_001) THEN LENGTH(BJTS_LSF_XX_CKSP_DM_SH_001) ELSE LENGTH(BJTS_LSF_XX_CKSP_DM_SB_001) END;
        IF SUBSTR(BJTS_LSF_XX_CKSP_DM_SB_001,1,LN_CMCD_LEN)<>SUBSTR(BJTS_LSF_XX_CKSP_DM_SH_001,1,LN_CMCD_LEN) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_YS_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'JSB_CKMX_DLZM_SPDM','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_001), ']商品代码['), BJTS_LSF_XX_CKSP_DM_SB_001), ']与电子信息中['), BJTS_LSF_XX_CKSP_DM_SH_001), ']不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (TRIM(BJTS_LSF_XX_JGFS_DM_001) IS NULL) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_YS_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'JSB_CKMX_DLZM_MYXZ_BCZ','E',ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_001), ']在电子信息中监管方式不存在！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        ELSE
          IF (TRIM(BJTS_LSF_XX_JGFSTSLX_DM_001)='0') THEN
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                        'CKTS_SB_YS_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'JSB_CKMX_DLZM_MYXZ_BTS','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_001), ']在电子信息中监管方式['), BJTS_LSF_XX_JGFS_DM_001), ']不退税！'),'N',CURRENT_TIMESTAMP
;
            COMMIT;
          END IF;
        END IF;

        IF BJTS_LSF_XX_YSFS_DM_001='T' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_YS_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'JSB_CKMX_CKPZH_YSFS','E',ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_001), ']为出口到综合试验区（横琴平潭地区）的报关单！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
      END;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_JSB_TSSB_DLZM.sql

-- ======================================================================
-- [042/114] BEGIN SOURCE: PROC_XXBD_JSB_TSSB_JKZZS.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_JSB_TSSB_JKZZS$$

CREATE PROCEDURE PROC_XXBD_JSB_TSSB_JKZZS
/*
  编制人:严国平
  编制日期:202010
  功能:信息比对（出口已使用旧设备退税）
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 进口增值税缴款书记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_YS_SBMX_LSB T
     WHERE T.SBID=V_IN_SBID
       AND LENGTH(T.YSYGDSBPZHM)=22;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;

  SET LC_YDOBJECT ='进口增值税';
  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_YS_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'JSB_CKMX_JKZZS_WDZXX','E',ORA_CONCAT(ORA_CONCAT('海关进口增值税缴款书[', T.YSYGDSBPZHM), ']无电子信息！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_YS_SBMX_LSB T
          WHERE T.SBID=V_IN_SBID
            AND LENGTH(T.YSYGDSBPZHM)=22
            AND NOT EXISTS (SELECT 1
                              FROM CKTS_WBSJ_HG_JKJKS S
                             WHERE S.DJXH=V_IN_DJXH
                               AND S.HGZYJKSHM=T.YSYGDSBPZHM);
    COMMIT;
  END;

  BEGIN
    BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_SBXH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_YSYGDSBPZHM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_BYTSBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_HGJKJKSCLJG_DM_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT A.SBXH,
                          A.YSYGDSBPZHM,
                          B.BYTSBZ,
                          B.HGJKJKSCLJG_DM
                     FROM CKTS_SB_YS_SBMX_LSB A
                    INNER JOIN CKTS_WBSJ_HG_JKJKS B ON B.DJXH=V_IN_DJXH AND B.HGZYJKSHM=A.YSYGDSBPZHM
                    WHERE A.SBID=V_IN_SBID
                      AND LENGTH(A.YSYGDSBPZHM)=22;
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_LSF_XX_SBXH_001, BJTS_LSF_XX_YSYGDSBPZHM_001, BJTS_LSF_XX_BYTSBZ_001, BJTS_LSF_XX_HGJKJKSCLJG_DM_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
      BEGIN
        IF BJTS_LSF_XX_BYTSBZ_001='Y' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_YS_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'JSB_CKMX_JKZZS_BYTS','E',ORA_CONCAT(ORA_CONCAT('海关进口增值税缴款书[', BJTS_LSF_XX_YSYGDSBPZHM_001), ']已被标注为“不予退税”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_HGJKJKSCLJG_DM_001 IN ('001','200') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_YS_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'JSB_CKMX_JKZZS_YDK','E',ORA_CONCAT(ORA_CONCAT('海关进口增值税缴款书[', BJTS_LSF_XX_YSYGDSBPZHM_001), ']在电子信息中已勾选用于抵扣！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_HGJKJKSCLJG_DM_001 IN ('100','500') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_YS_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'JSB_CKMX_JKZZS_DUP','E',ORA_CONCAT(ORA_CONCAT('海关进口增值税缴款书[', BJTS_LSF_XX_YSYGDSBPZHM_001), ']在电子信息中重复申请退税！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
      END;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_JSB_TSSB_JKZZS.sql

-- ======================================================================
-- [043/114] BEGIN SOURCE: PROC_XXBD_JSB_TSSB_ZZSFP.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_JSB_TSSB_ZZSFP$$

CREATE PROCEDURE PROC_XXBD_JSB_TSSB_ZZSFP
/*
  编制人:严国平
  编制日期:202010
  功能:信息比对（出口已使用旧设备退税）
  调整日期：20201230，1、校验发票稽核信息时，剔除代开发票的稽核信息，代开发票开票人税号含DK
  调整日期：20220701，1、根据全电票规则调整发票的关联，用JHPZH代替FPDM+FPHM
  调整日期：20230207，1、修改全电发票关联虚开发票时的BUG。
  调整日期：20230315，调整出口企业首次申报日期取数口径，改为按税务机关+企业+业务代码查询首次发放日期
  调整日期：20230515，解决增值税发票外部数据部分数据稽核相符标志为空的问题（赋默认值N）
  调整日期：20230518，解决按税务机关+企业+业务代码查询首次发放日期有结果但日期为空的问题（赋默认值SYSDATE）
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LDT_TODAY       DATETIME;
  DECLARE LDT_SCSBRQ      DATETIME;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';
  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  -- 增值税专用发票记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_YS_SBMX_LSB T
     WHERE T.SBID=V_IN_SBID
       AND (LENGTH(T.YSYGDSBPZHM)=20 OR LENGTH(T.YSYGDSBPZHM)=18);
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;

  -- 查询企业首次申报日期
  BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
      SET LDT_SCSBRQ =LDT_TODAY;

  END;
SELECT IFNULL(T.FFRQ, CURRENT_TIMESTAMP)
      INTO LDT_SCSBRQ
      FROM CKTS_TY_YWBLXX_SCFFRQ T
     WHERE T.TSSWJG_DM_1=(SELECT SWJG_DM FROM GS_DJ_CKTMSDAB WHERE NSRDZDAH=V_IN_NSRDZDAH)
       AND T.DJXH=V_IN_DJXH AND T.LCSWSX_DM='LCSXA081042001';
  END;

  SET LC_YDOBJECT ='增值税发票';
  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_YS_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'JSB_CKMX_ZZSFP_WDZXX','E',ORA_CONCAT(ORA_CONCAT('增值税专用发票[', T.YSYGDSBPZHM), ']无电子信息！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_YS_SBMX_LSB T
          WHERE T.SBID=V_IN_SBID
            AND (LENGTH(T.YSYGDSBPZHM)=20 OR LENGTH(T.YSYGDSBPZHM)=18)
            AND NOT EXISTS (SELECT 1
                              FROM CKTS_WBSJ_FP_ZZSZYFPXX S
                             WHERE S.DJXH=V_IN_DJXH
                               AND S.JHPZH=T.YSYGDSBPZHM);
    COMMIT;
  END;

  BEGIN
    CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',LDT_TODAY,LC_FLGLCD, LN_CPCODEKZ);
    BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_SBXH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_YSYGDSBPZHM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_XFNSRSBH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_JHXFZZSZYFPBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_BYTSBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_KPRQ_SB_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_KPRQ_SH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_FPYT_DM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_FPSJBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_NXZCKBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_GHFNSRSBH_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT A.SBXH,
                          A.YSYGDSBPZHM,
                          B.XFNSRSBH,
                          IFNULL(B.JHXFZZSZYFPBZ, 'N') AS JHXFZZSZYFPBZ,
                          B.BYTSBZ,
                          DATE(A.KPRQ) AS KPRQ_SB,
                          DATE(B.KPRQ) AS KPRQ_SH,
                          B.FPYT_DM,
                          IFNULL(B.FPSJBBZ, 'N') AS FPSJBZ,
                          IFNULL(B.NXZCKBZ, 'N') AS NXZCKBZ,
                          C.GHFNSRSBH
                     FROM CKTS_SB_YS_SBMX_LSB A
                    INNER JOIN CKTS_WBSJ_FP_ZZSZYFPXX B ON B.DJXH=V_IN_DJXH AND B.JHPZH=A.YSYGDSBPZHM
                     LEFT JOIN CKTS_WBSJ_ZJ_XKFP C ON ORA_CONCAT(C.FP_DM, C.FPHM)=A.YSYGDSBPZHM
                    WHERE A.SBID=V_IN_SBID
                      AND (LENGTH(A.YSYGDSBPZHM)=20 OR LENGTH(A.YSYGDSBPZHM)=18);
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_LSF_XX_SBXH_001, BJTS_LSF_XX_YSYGDSBPZHM_001, BJTS_LSF_XX_XFNSRSBH_001, BJTS_LSF_XX_JHXFZZSZYFPBZ_001, BJTS_LSF_XX_BYTSBZ_001, BJTS_LSF_XX_KPRQ_SB_001, BJTS_LSF_XX_KPRQ_SH_001, BJTS_LSF_XX_FPYT_DM_001, BJTS_LSF_XX_FPSJBZ_001, BJTS_LSF_XX_NXZCKBZ_001, BJTS_LSF_XX_GHFNSRSBH_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
      BEGIN
        IF (BJTS_LSF_XX_JHXFZZSZYFPBZ_001='N' AND INSTR(BJTS_LSF_XX_XFNSRSBH_001,'DK')=0 AND (LC_FLGLCD='D' OR (LC_FLGLCD='C' AND TIMESTAMPDIFF(MONTH, LDT_SCSBRQ, LDT_TODAY)<=12))) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_YS_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'JSB_CKMX_ZZSFP_WDZXX','E',ORA_CONCAT(ORA_CONCAT('增值税专用发票[', BJTS_LSF_XX_YSYGDSBPZHM_001), ']无稽核相符电子信息！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_BYTSBZ_001='Y' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_YS_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'JSB_CKMX_ZZSFP_BYTS','E',ORA_CONCAT(ORA_CONCAT('增值税专用发票[', BJTS_LSF_XX_YSYGDSBPZHM_001), ']已被标注为“不予退税”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_KPRQ_SB_001<>BJTS_LSF_XX_KPRQ_SH_001 THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_YS_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'JSB_CKMX_ZZSFP_KPRQ','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('增值税专用发票[', BJTS_LSF_XX_YSYGDSBPZHM_001), ']开票日期['), DATE_FORMAT(BJTS_LSF_XX_KPRQ_SB_001, '%Y-%m-%d')), ']与电子信息中['), DATE_FORMAT(BJTS_LSF_XX_KPRQ_SH_001, '%Y-%m-%d')), ']不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_FPYT_DM_001='3' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_YS_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'JSB_CKMX_ZZSFP_DBTS','E',ORA_CONCAT(ORA_CONCAT('增值税专用发票[', BJTS_LSF_XX_YSYGDSBPZHM_001), ']在电子信息中申报用途代码为“3-增值税专用”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
        IF (BJTS_LSF_XX_FPYT_DM_001='1' AND BJTS_LSF_XX_FPSJBZ_001='Y' AND BJTS_LSF_XX_NXZCKBZ_001='N') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_YS_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'JSB_CKMX_ZZSFP_YDK','E',ORA_CONCAT(ORA_CONCAT('增值税专用发票[', BJTS_LSF_XX_YSYGDSBPZHM_001), ']在电子信息中已勾选用于抵扣！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_GHFNSRSBH_001 IS NOT NULL THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_YS_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'JSB_CKMX_ZZSFP_XKFP','E',ORA_CONCAT(ORA_CONCAT('增值税专用发票[', BJTS_LSF_XX_YSYGDSBPZHM_001), ']在电子信息中为虚开增值税专用发票！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
      END;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_JSB_TSSB_ZZSFP.sql

-- ======================================================================
-- [044/114] BEGIN SOURCE: PROC_XXBD_MDT.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MDT$$

CREATE PROCEDURE PROC_XXBD_MDT
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（生产企业免抵退税）
  调整日期：20210603，1、非四类企业超期申报允许提交收汇信息
  修改日期：20220615，根据2022年9号公告，合并收汇与不能收汇
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE BJTS_ROUTINE_EXIT BOOLEAN DEFAULT FALSE;
  DECLARE LDT_TODAY       DATETIME;

  DECLARE LC_QYHGDM       VARCHAR(20);
  DECLARE LC_QYLXDM       VARCHAR(20);
  DECLARE LC_TSJSFSDM     VARCHAR(20);
  DECLARE LC_WMZHFWQYBZ   VARCHAR(20);
  DECLARE LC_SFYSFW       VARCHAR(20);
  DECLARE LC_YSFW         VARCHAR(50);
  DECLARE LC_YSFS         VARCHAR(50);
  DECLARE LC_YFSJ         VARCHAR(50);
  DECLARE LC_ZXFLAG       VARCHAR(20);

  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LN_TGSHZL       BIGINT;
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LN_ROWNUM_SBHZ  BIGINT;
  DECLARE LN_ROWNUM_TSSB  BIGINT;
  DECLARE LN_ROWNUM_YFSJ  BIGINT;
  DECLARE LN_ROWNUM_GJYS  BIGINT;
  DECLARE LN_ROWNUM_CKSH  BIGINT;
  DECLARE LN_ROWNUM_CQSB  BIGINT;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';
  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  IF V_IN_SSSQ<DATE_FORMAT(DATE_ADD(CURRENT_TIMESTAMP, INTERVAL -1 MONTH), '%Y%m') OR V_IN_SSSQ>DATE_FORMAT(CURRENT_TIMESTAMP, '%Y%m') THEN
    BEGIN
      SET V_OUT_STATUS ='05';
      SET V_OUT_MESSAGE ='申报所属时期超出合理范围！';
      LEAVE routine_body;
    END;
  END IF;

  -- 取各申报明细表数据记录
  BEGIN
  DECLARE BJTS_SQLCODE_016 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_016 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_016 = MYSQL_ERRNO, BJTS_SQLERRM_016 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='06';
      SET V_OUT_MESSAGE ='查询申报记录数据失败！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT COUNT(1)
      INTO LN_ROWNUM_SBHZ
      FROM CKTS_SB_MDT_SBHZ_LSB
     WHERE SBID=V_IN_SBID;
    SELECT COUNT(1)
      INTO LN_ROWNUM_TSSB
      FROM CKTS_SB_MDT_TSSB_LSB
     WHERE SBID=V_IN_SBID;
    SELECT COUNT(1)
      INTO LN_ROWNUM_YFSJ
      FROM CKTS_SB_MDT_YFSJ_LSB
     WHERE SBID=V_IN_SBID;
    SELECT COUNT(1)
      INTO LN_ROWNUM_GJYS
      FROM CKTS_SB_MDT_GJYS_LSB
     WHERE SBID=V_IN_SBID;
    SELECT COUNT(1)
      INTO LN_ROWNUM_CKSH
      FROM CKTS_SB_MDT_CKSH_LSB
     WHERE SBID=V_IN_SBID;
    SELECT COUNT(1)
      INTO LN_ROWNUM_CQSB
      FROM CKTS_SB_MDT_TSSB_LSB
     WHERE SBID=V_IN_SBID
       AND FUNC_XXBD_CHECK_NEEDSH(ORA_CONCAT(ORA_CONCAT(',', CKTMSYWLXDMJH), ',')) = 1
       AND (((STR_TO_DATE(ORA_CONCAT(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y'), '0420'), '%Y%m%d')<DATE(CURRENT_TIMESTAMP)) AND (CKRQ_1<MAKEDATE(YEAR(CURRENT_TIMESTAMP), 1))) OR (CKRQ_1<DATE_ADD(MAKEDATE(YEAR(CURRENT_TIMESTAMP), 1), INTERVAL -12 MONTH)));
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LN_ROWNUM_SBHZ=0 THEN
    BEGIN
      SET V_OUT_STATUS ='07';
      SET V_OUT_MESSAGE ='申报数据为空！';
      LEAVE routine_body;
    END;
  END IF;

  -- 查询企业基本信息
  BEGIN
  DECLARE BJTS_SQLCODE_015 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_015 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_015 = MYSQL_ERRNO, BJTS_SQLERRM_015 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='08';
      SET V_OUT_MESSAGE ='企业当前未进行出口退（免）税备案，不允许申报除出口退（免）税备案以外的其他业务！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT T.QYHGDM, T.QYLX_DM, T.TSJSFS_DM, T.WMZHFWQYBZ, T.SFYSFW, T.YSFW, T.YSFS, T.YFSJ, T.ZX_FLAG
      INTO LC_QYHGDM, LC_QYLXDM, LC_TSJSFSDM, LC_WMZHFWQYBZ, LC_SFYSFW, LC_YSFW, LC_YSFS, LC_YFSJ, LC_ZXFLAG
      FROM GS_DJ_CKTMSDAB T
     WHERE T.NSRDZDAH=V_IN_NSRDZDAH;
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LC_ZXFLAG='R' THEN
    BEGIN
      SET V_OUT_STATUS ='09';
      SET V_OUT_MESSAGE ='企业当前已出口退（免）税备案撤回，不允许申报除出口退（免）税备案以外的其他业务！';
      LEAVE routine_body;
    END;
  END IF;

  -- 取企业的FLGLCD信息, TGSHZL信息，判断是否需要申报收汇
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',LDT_TODAY,LC_FLGLCD, LN_CPCODEKZ);
  IF LN_CPCODEKZ=0 THEN
    BEGIN
      SET V_OUT_STATUS ='10';
      SET V_OUT_MESSAGE ='查询出口企业分类管理类型出错！';
      LEAVE routine_body;
    END;
  END IF;

  IF ((LC_QYLXDM<>'1' AND LC_QYLXDM<>'2') OR LC_TSJSFSDM<>'1') THEN
    BEGIN
      SET V_OUT_STATUS ='11';
      SET V_OUT_MESSAGE ='备案信息中企业类型、退免税计算方法与当前申报业务冲突！';
      LEAVE routine_body;
    END;
  END IF;

  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'YBNSRRD',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=0 THEN
    BEGIN
      SET V_OUT_STATUS ='12';
      SET V_OUT_MESSAGE ='企业当前非增值税一般纳税人，不允许申报出口退（免）税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TQQY',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 THEN
    BEGIN
      SET V_OUT_STATUS ='13';
      SET V_OUT_MESSAGE ='企业当前处于出口退税停权期间，不允许申报出口退（免）税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTSSXMS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_TSSB>0 THEN
    BEGIN
      SET V_OUT_STATUS ='14';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权选择免税期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTSSXZS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_TSSB>0 THEN
    BEGIN
      SET V_OUT_STATUS ='15';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权选择征税期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTMS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_TSSB>0 THEN
    BEGIN
      SET V_OUT_STATUS ='16';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;

  IF LN_ROWNUM_YFSJ>0 THEN
    BEGIN
      IF LC_SFYSFW='N' THEN
        BEGIN
          SET V_OUT_STATUS ='20';
          SET V_OUT_MESSAGE ='非零税率应税服务提供者，不允许申报零税率应税服务退税！';
          LEAVE routine_body;
        END;
      ELSE
        IF INSTR(LC_YSFW,'03')=0 THEN
          BEGIN
            SET V_OUT_STATUS ='21';
            SET V_OUT_MESSAGE ='零税率应税服务提供者，但未认定提供研发设计类服务，不允许申报零税率应税服务退税！';
            LEAVE routine_body;
          END;
        END IF;
      END IF;
      CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQLSL',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
      IF LN_CPCODEKZ=1 THEN
        BEGIN
          SET V_OUT_STATUS ='22';
          SET V_OUT_MESSAGE ='该企业已放弃零税率应税服务退税，不能申报零税率应税服务退税！';
          LEAVE routine_body;
        END;
      END IF;
    END;
  END IF;
  IF LN_ROWNUM_GJYS>0 THEN
    BEGIN
      IF LC_SFYSFW='N' THEN
        BEGIN
          SET V_OUT_STATUS ='23';
          SET V_OUT_MESSAGE ='非零税率应税服务提供者，不允许申报国际（港澳台）运输服务退税！';
          LEAVE routine_body;
        END;
      ELSE
        IF INSTR(LC_YSFW,'01')=0 THEN
          BEGIN
            SET V_OUT_STATUS ='24';
            SET V_OUT_MESSAGE ='零税率应税服务提供者，但未认定提供国际（港澳台）运输服务，不允许申报国际（港澳台）运输服务退税！';
            LEAVE routine_body;
          END;
        END IF;
      END IF;
      CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQLSL',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
      IF LN_CPCODEKZ=1 THEN
        BEGIN
          SET V_OUT_STATUS ='25';
          SET V_OUT_MESSAGE ='该企业已放弃零税率应税服务退税，不能申报国际（港澳台）运输服务退税！';
          LEAVE routine_body;
        END;
      END IF;
    END;
  END IF;

  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TGSHZL',LDT_TODAY,LC_KZXX, LN_TGSHZL);
  IF (LC_FLGLCD='D') AND LN_ROWNUM_TSSB>0 AND LN_ROWNUM_CKSH=0 THEN
    BEGIN
      SET V_OUT_STATUS ='27';
      SET V_OUT_MESSAGE ='出口退（免）税管理类别为四类的企业，申报出口退免税时必须申报收汇情况表！';
      LEAVE routine_body;
    END;
  ELSEIF (LN_TGSHZL>0) AND LN_ROWNUM_TSSB>0 AND LN_ROWNUM_CKSH=0 THEN
    BEGIN
      SET V_OUT_STATUS ='28';
      SET V_OUT_MESSAGE ='被认定为需提供收汇资料的企业，申报出口退免税时必须申报收汇情况表！';
      LEAVE routine_body;
    END;
  ELSEIF (LN_ROWNUM_CQSB>0) AND LN_ROWNUM_TSSB>0 AND LN_ROWNUM_CKSH=0 THEN
    BEGIN
      SET V_OUT_STATUS ='29';
      SET V_OUT_MESSAGE ='超期申报数据，申报出口退免税时必须申报收汇情况表！';
      LEAVE routine_body;
    END;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_014 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_014 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_014 = MYSQL_ERRNO, BJTS_SQLERRM_014 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='51';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('退税出口明细自检出错：', BJTS_SQLCODE_014), ' - '), BJTS_SQLERRM_014);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_MDT_TSSB(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_013 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_013 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_013 = MYSQL_ERRNO, BJTS_SQLERRM_013 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='52';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口报关单自检出错：', BJTS_SQLCODE_013), ' - '), BJTS_SQLERRM_013);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_MDT_TSSB_BGD(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_012 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_012 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_012 = MYSQL_ERRNO, BJTS_SQLERRM_012 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='53';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口证明自检出错：', BJTS_SQLCODE_012), ' - '), BJTS_SQLERRM_012);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_MDT_TSSB_DLZM(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_011 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_011 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_011 = MYSQL_ERRNO, BJTS_SQLERRM_011 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='62';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口收汇申报资料自检出错：', BJTS_SQLCODE_011), ' - '), BJTS_SQLERRM_011);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_MDT_CKSH(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_010 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_010 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_010 = MYSQL_ERRNO, BJTS_SQLERRM_010 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='63';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('海关商品代码调整表自检出错：', BJTS_SQLCODE_010), ' - '), BJTS_SQLERRM_010);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_MDT_HGSPTZ(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_009 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_009 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_009 = MYSQL_ERRNO, BJTS_SQLERRM_009 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='64';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('离岸价差异说明表自检出错：', BJTS_SQLCODE_009), ' - '), BJTS_SQLERRM_009);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_MDT_CYSM(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_008 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_008 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_008 = MYSQL_ERRNO, BJTS_SQLERRM_008 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='65';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('先退后核申报资料自检出错：', BJTS_SQLCODE_008), ' - '), BJTS_SQLERRM_008);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_MDT_XTHH(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_007 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_007 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_007 = MYSQL_ERRNO, BJTS_SQLERRM_007 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='66';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('视同自产清单自检出错：', BJTS_SQLCODE_007), ' - '), BJTS_SQLERRM_007);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_MDT_STZC(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_006 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_006 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_006 = MYSQL_ERRNO, BJTS_SQLERRM_006 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='71';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('零税率应税服务明细自检出错：', BJTS_SQLCODE_006), ' - '), BJTS_SQLERRM_006);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_MDT_YFSJ(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,LC_YFSJ,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_005 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_005 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_005 = MYSQL_ERRNO, BJTS_SQLERRM_005 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='72';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('零税率应税服务收讫自检出错：', BJTS_SQLCODE_005), ' - '), BJTS_SQLERRM_005);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_MDT_YFSJ_SYYK(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_004 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_004 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_004 = MYSQL_ERRNO, BJTS_SQLERRM_004 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='81';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('国际（港澳台）运输服务明细自检出错：', BJTS_SQLCODE_004), ' - '), BJTS_SQLERRM_004);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_MDT_GJYS(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,LC_YSFS,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_003 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_003 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_003 = MYSQL_ERRNO, BJTS_SQLERRM_003 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='82';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('航空运输清算账单自检出错：', BJTS_SQLCODE_003), ' - '), BJTS_SQLERRM_003);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_MDT_GJYS_HKYS(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='83';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('国际客运清算函件自检出错：', BJTS_SQLCODE_002), ' - '), BJTS_SQLERRM_002);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_MDT_GJYS_KYHJ(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='84';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('中铁国际货运明细自检出错：', BJTS_SQLCODE_001), ' - '), BJTS_SQLERRM_001);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_MDT_GJYS_THLY(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MDT.sql

-- ======================================================================
-- [045/114] BEGIN SOURCE: PROC_XXBD_MDT_BNSH.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MDT_BNSH$$

CREATE PROCEDURE PROC_XXBD_MDT_BNSH
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（生产企业免抵退税）
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 不能收汇明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_MDT_BNSH_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;
  SET LC_YDOBJECT ='不能收汇';

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_BNSH_LSB','CKTS_SB_MDT_TSSB_LSB',NULL,T.SBXH,NULL,'MDT_BJGX_SHZL_CKHW_CKPZ','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), ']未申报免退税出口明细！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_BNSH_LSB T
          WHERE T.SBID=V_IN_SBID
            AND T.CKBGDH IS NOT NULL
            AND NOT EXISTS (SELECT 1 FROM CKTS_SB_MDT_TSSB_LSB S WHERE S.SBID=T.SBID AND IFNULL(S.CKBGDH, S.DLCKHWZMHM)=T.CKBGDH);
    COMMIT;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MDT_BNSH.sql

-- ======================================================================
-- [046/114] BEGIN SOURCE: PROC_XXBD_MDT_CKSH.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MDT_CKSH$$

CREATE PROCEDURE PROC_XXBD_MDT_CKSH
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（生产企业免抵退税）
  修改日期：20220615，根据2022年9号公告，四类企业，需提供银行水单企业收汇情况表必须申报本期出口退税，非上述企业改为提示性疑点
  修改日期：20230207，修改代理证明出口申报收汇表的疑点逻辑和提示
  调整日期：20230313，增加MDT_BJGX_SHZL_CKHW_CJBZ、MDT_BJGX_SHZL_CKHW_CJJE的疑点判断
  调整日期：20230526，币种不一致、折人民币不一致疑点改成错误类，不可挑过。
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LDT_TODAY       DATETIME;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';
  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  -- 收汇明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_MDT_CKSH_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;

  SET LC_YDOBJECT ='出口收汇';
  BEGIN
    CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',LDT_TODAY,LC_FLGLCD, LN_CPCODEKZ);
    CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TGSHZL',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
    IF (LC_FLGLCD='D') OR (LN_CPCODEKZ>0) THEN
      BEGIN
        INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
             SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                    'CKTS_SB_MDT_CKSH_LSB','CKTS_SB_MDT_TSSB_LSB',NULL,T.SBXH,NULL,'MDT_BJGX_SHZL_CKHW_CKPZ','E',
                    ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', IFNULL(T.DLCKHWZMHM, T.CKBGDH)), ']未申报退税！'),'N',CURRENT_TIMESTAMP
               FROM CKTS_SB_MDT_CKSH_LSB T
              WHERE T.SBID=V_IN_SBID
                AND NOT EXISTS (SELECT 1 FROM CKTS_SB_MDT_TSSB_LSB S WHERE S.SBID=T.SBID AND IFNULL(S.DLCKHWZMHM, S.CKBGDH)=IFNULL(T.DLCKHWZMHM, T.CKBGDH));
        COMMIT;
      END;
    ELSE
      BEGIN
        INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
             SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                    'CKTS_SB_MDT_CKSH_LSB','CKTS_SB_MDT_TSSB_LSB',NULL,T.SBXH,NULL,'MDT_BJGX_SHZL_CKHW_CKPZ','I',
                    ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', IFNULL(T.DLCKHWZMHM, T.CKBGDH)), ']本期未申报退税！'),'Y',CURRENT_TIMESTAMP
               FROM CKTS_SB_MDT_CKSH_LSB T
              WHERE T.SBID=V_IN_SBID
                AND NOT EXISTS (SELECT 1 FROM CKTS_SB_MDT_TSSB_LSB S WHERE S.SBID=T.SBID AND IFNULL(S.DLCKHWZMHM, S.CKBGDH)=IFNULL(T.DLCKHWZMHM, T.CKBGDH));
        COMMIT;
      END;
    END IF;
    BEGIN
  DECLARE BJTS_CURSOR_DONE_002 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_SBXH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKPZH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CJHBZM_DM_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_HBZL_DM_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKXSERMB_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_RMBLAJ_002 LONGTEXT;
  DECLARE BJTS_CURSOR_002 CURSOR FOR
SELECT A.SBXH,
                          A.CKBGDH AS CKPZH,
                          A.CJHBZM_DM,
                          E.HBZL_DM,
                          A.CKXSERMB,
                          B.RMBLAJ
                     FROM CKTS_SB_MDT_CKSH_LSB A
                    INNER JOIN CKTS_SB_MDT_TSSB_LSB B ON B.SBID=A.SBID AND B.CKBGDH = A.CKBGDH AND B.RMBLAJ>0
                    INNER JOIN CKTS_WBSJ_HG_BGD201 D ON D.DJXH=V_IN_DJXH AND D.CKBGDH=A.CKBGDH
                    INNER JOIN DM_HBZL_HG E ON E.HBZL_HG=D.CJHGHBSZ_DM
                    WHERE A.SBID=V_IN_SBID AND A.DLCKHWZMHM IS NULL;
  OPEN BJTS_CURSOR_002;
  BJTS_CURSOR_LOOP_002: LOOP
    SET BJTS_CURSOR_DONE_002 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_002 = TRUE;
      FETCH BJTS_CURSOR_002 INTO BJTS_LSF_XX_SBXH_002, BJTS_LSF_XX_CKPZH_002, BJTS_LSF_XX_CJHBZM_DM_002, BJTS_LSF_XX_HBZL_DM_002, BJTS_LSF_XX_CKXSERMB_002, BJTS_LSF_XX_RMBLAJ_002;
    END;
    IF BJTS_CURSOR_DONE_002 THEN
      LEAVE BJTS_CURSOR_LOOP_002;
    END IF;
      BEGIN
        IF BJTS_LSF_XX_CJHBZM_DM_002<>BJTS_LSF_XX_HBZL_DM_002 THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_CKSH_LSB','CKTS_SB_MDT_TSSB_LSB',NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_BJGX_SHZL_CKHW_CJBZ','E',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', BJTS_LSF_XX_CKPZH_002), ']的出口退（免）税销售额币种['), BJTS_LSF_XX_CJHBZM_DM_002), ']与电子信息中的币制['), BJTS_LSF_XX_HBZL_DM_002), ']不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
        IF BJTS_LSF_XX_CKXSERMB_002<>BJTS_LSF_XX_RMBLAJ_002 THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_CKSH_LSB','CKTS_SB_MDT_TSSB_LSB',NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_BJGX_SHZL_CKHW_CJJE','E',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', BJTS_LSF_XX_CKPZH_002), ']的出口退（免）税销售额折人民币['), BJTS_LSF_XX_CKXSERMB_002), ']与免抵退税明细表中出口销售额人民币['), BJTS_LSF_XX_RMBLAJ_002), ']不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
      END;

  END LOOP BJTS_CURSOR_LOOP_002;
  CLOSE BJTS_CURSOR_002;
END;
    BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_SBXH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKPZH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CJHBZM_DM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_HBZL_DM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKXSERMB_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_RMBLAJ_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT A.SBXH,
                          A.DLCKHWZMHM AS CKPZH,
                          A.CJHBZM_DM,
                          E.HBZL_DM,
                          A.CKXSERMB,
                          B.RMBLAJ
                     FROM CKTS_SB_MDT_CKSH_LSB A
                    INNER JOIN CKTS_SB_MDT_TSSB_LSB B ON B.SBID=A.SBID AND B.DLCKHWZMHM=A.DLCKHWZMHM AND B.RMBLAJ>0
                    INNER JOIN CKTS_WBSJ_ZJ_DLCKHWZM D ON D.DJXH=V_IN_DJXH AND D.DLCKHWZMHM=A.DLCKHWZMHM
                    INNER JOIN DM_HBZL_HG E ON E.HBZL_HG=D.CJHGHBSZ_DM
                    WHERE A.SBID=V_IN_SBID AND A.DLCKHWZMHM IS NOT NULL;
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_LSF_XX_SBXH_001, BJTS_LSF_XX_CKPZH_001, BJTS_LSF_XX_CJHBZM_DM_001, BJTS_LSF_XX_HBZL_DM_001, BJTS_LSF_XX_CKXSERMB_001, BJTS_LSF_XX_RMBLAJ_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
      BEGIN
        IF BJTS_LSF_XX_CJHBZM_DM_001<>BJTS_LSF_XX_HBZL_DM_001 THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_CKSH_LSB','CKTS_SB_MDT_TSSB_LSB',NULL,BJTS_LSF_XX_SBXH_001,NULL,'MDT_BJGX_SHZL_CKHW_CJBZ','E',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', BJTS_LSF_XX_CKPZH_001), ']的出口退（免）税销售额币种['), BJTS_LSF_XX_CJHBZM_DM_001), ']与电子信息中的币制['), BJTS_LSF_XX_HBZL_DM_001), ']不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
        IF BJTS_LSF_XX_CKXSERMB_001<>BJTS_LSF_XX_RMBLAJ_001 THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_CKSH_LSB','CKTS_SB_MDT_TSSB_LSB',NULL,BJTS_LSF_XX_SBXH_001,NULL,'MDT_BJGX_SHZL_CKHW_CJJE','E',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', BJTS_LSF_XX_CKPZH_001), ']的出口退（免）税销售额折人民币['), BJTS_LSF_XX_CKXSERMB_001), ']与免抵退税明细表中出口销售额人民币['), BJTS_LSF_XX_RMBLAJ_001), ']不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
      END;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MDT_CKSH.sql

-- ======================================================================
-- [047/114] BEGIN SOURCE: PROC_XXBD_MDT_CYSM.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MDT_CYSM$$

CREATE PROCEDURE PROC_XXBD_MDT_CYSM
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（生产企业免抵退税）
  调整日期：20201119，对疑点MDT_BJGX_LACY_CKHW_USD、MDT_BJGX_LACY_CKHW_RMB的校验逻辑进行修正，原来用了报关单离岸价与明细表比较，修正为发票离岸价与明细表比较
  调整日期：20201201，对疑点MDT_BJGX_LACY_CKHW_USD、MDT_BJGX_LACY_CKHW_RMB的校验逻辑进行修正，取消明细表为红字冲减时的比较
  调整日期：20201215，对疑点MDT_BJGX_LACY_CKHW_CKFP的校验逻辑进行修正，取消明细表为红字冲减时的比较
  调整日期：20211123，对疑点MDT_LACY_BGD_USDLAJ的校验逻辑进行修正，仅校验bgd201表，不校验bgd202表，与202表的校验改到PROC_XXBD_MDT_TSSB_BGD中进行
  修改日期：20230207，修改代理证明出口申报离岸价差异表的疑点逻辑和提示
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 离岸价差异明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_MDT_CYSM_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;
  SET LC_YDOBJECT ='离岸差异';

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_CYSM_LSB','CKTS_SB_MDT_TSSB_LSB',NULL,T.SBXH,NULL,'MDT_BJGX_LACY_CKHW_CKPZ','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', IFNULL(T.DLCKHWZMHM, T.CKBGDH)), ']未申报免退税出口明细！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_CYSM_LSB T
          WHERE T.SBID=V_IN_SBID
            AND NOT EXISTS (SELECT 1 FROM CKTS_SB_MDT_TSSB_LSB S WHERE S.SBID=T.SBID AND IFNULL(S.DLCKHWZMHM, S.CKBGDH)=IFNULL(T.DLCKHWZMHM, T.CKBGDH));
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_CYSM_LSB','CKTS_SB_MDT_TSSB_LSB',NULL,T.SBXH,NULL,'MDT_BJGX_LACY_CKHW_CKFP','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', IFNULL(T.DLCKHWZMHM, T.CKBGDH)), ']出口发票号码与货物出口明细不一致！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_CYSM_LSB T
          INNER JOIN CKTS_SB_MDT_TSSB_LSB S ON S.SBID=T.SBID AND IFNULL(S.DLCKHWZMHM, S.CKBGDH)=IFNULL(T.DLCKHWZMHM, T.CKBGDH) AND INSTR(S.CKTMSYWLXDMJH,'HZCJ')=0
          WHERE T.SBID=V_IN_SBID
            AND T.CKFPH<>S.CKFPH;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_CYSM_LSB','CKTS_SB_MDT_TSSB_LSB',NULL,T.SBXH,NULL,'MDT_BJGX_LACY_CKHW_USD','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', IFNULL(T.DLCKHWZMHM, T.CKBGDH)), ']出口发票美元离岸价与货物出口明细不一致！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_CYSM_LSB T
          INNER JOIN CKTS_SB_MDT_TSSB_LSB S ON S.SBID=T.SBID AND IFNULL(S.DLCKHWZMHM, S.CKBGDH)=IFNULL(T.DLCKHWZMHM, T.CKBGDH) AND INSTR(S.CKTMSYWLXDMJH,'HZCJ')=0
          WHERE T.SBID=V_IN_SBID
            AND T.CKFPMYLAJ<>S.MYLAJ;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_CYSM_LSB','CKTS_SB_MDT_TSSB_LSB',NULL,T.SBXH,NULL,'MDT_BJGX_LACY_CKHW_RMB','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', IFNULL(T.DLCKHWZMHM, T.CKBGDH)), ']出口发票人民币离岸价与货物出口明细不一致！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_CYSM_LSB T
          INNER JOIN CKTS_SB_MDT_TSSB_LSB S ON S.SBID=T.SBID AND IFNULL(S.DLCKHWZMHM, S.CKBGDH)=IFNULL(T.DLCKHWZMHM, T.CKBGDH) AND INSTR(S.CKTMSYWLXDMJH,'HZCJ')=0
          WHERE T.SBID=V_IN_SBID
            AND T.CKFPRMBLAJ<>S.RMBLAJ;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_CYSM_LSB',NULL,NULL,T.SBXH,NULL,'MDT_LACY_BGD_USDLAJ','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), ']美元离岸价['), T.MYLAJ), ']与电子信息中['), S.MYLAJ), ']不一致！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_CYSM_LSB T
          INNER JOIN CKTS_WBSJ_HG_BGD201 S ON S.DJXH=V_IN_DJXH AND S.CKBGDH=T.CKBGDH
          WHERE T.SBID=V_IN_SBID
            AND LENGTH(T.CKBGDH)=21
            AND T.MYLAJ<>S.MYLAJ;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_CYSM_LSB',NULL,NULL,T.SBXH,NULL,'MDT_LACY_DLZM_USDLAJ','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', T.DLCKHWZMHM), ']美元离岸价['), T.MYLAJ), ']与电子信息中['), S.MYLAJ), ']不一致！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_CYSM_LSB T
          INNER JOIN CKTS_WBSJ_ZJ_DLCKHWZM S ON S.DJXH=V_IN_DJXH AND S.DLCKHWZMHM=T.DLCKHWZMHM
          WHERE T.SBID=V_IN_SBID
            AND LENGTH(T.DLCKHWZMHM)=20
            AND T.MYLAJ<>S.MYLAJ;
    COMMIT;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MDT_CYSM.sql

-- ======================================================================
-- [048/114] BEGIN SOURCE: PROC_XXBD_MDT_GJYS.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MDT_GJYS$$

CREATE PROCEDURE PROC_XXBD_MDT_GJYS
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（生产企业免抵退税）
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  IN V_IN_GJYSFW VARCHAR(4000), /*出口企业备案国际运输类应税服务类型代码*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LC_MSG          VARCHAR(200) DEFAULT ' ';

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 国际运输明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_MDT_GJYS_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;
  SET LC_YDOBJECT ='国际运输';

  BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_GJYSFWDM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_GJYSFWJC_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_GJYSFWMC_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT GJYSFWDM, GJYSFWJC, GJYSFWMC FROM CKTS_DM_GJYSFW A WHERE A.YXBZ='Y';
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_LSF_XX_GJYSFWDM_001, BJTS_LSF_XX_GJYSFWJC_001, BJTS_LSF_XX_GJYSFWMC_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
    BEGIN
      SELECT COUNT(1)
        INTO LN_MXROW
        FROM CKTS_SB_MDT_GJYS_LSB T
       WHERE T.SBID=V_IN_SBID AND T.YSFW_DM LIKE ORA_CONCAT(BJTS_LSF_XX_GJYSFWJC_001, '%');
      IF LN_MXROW>0 AND INSTR(V_IN_GJYSFW,BJTS_LSF_XX_GJYSFWDM_001)=0 THEN
        SET LC_MSG =ORA_CONCAT(ORA_CONCAT(LC_MSG, BJTS_LSF_XX_GJYSFWMC_001), ',');
      END IF;
    END;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;
  IF LC_MSG<>' ' OR TRIM(LC_MSG) IS NOT NULL THEN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
     SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
            'CKTS_SB_MDT_GJYS_LSB',NULL,NULL,NULL,NULL,'MDT_BJGX_GJYS_SPDM','E',ORA_CONCAT(ORA_CONCAT('不允许申报未备案的国际运输服务[', LC_MSG), ']。'),'N',CURRENT_TIMESTAMP
;
    COMMIT;
  END IF;

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_GJYS_LSB','CKTS_SB_MDT_TLHY_LSB',NULL,T.SBXH,NULL,'MDT_BJGX_GJYS_TLHY_SPDM','E','应提供国际联运运输收入的《清算资金通知清单》！','N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_GJYS_LSB T
          WHERE T.SBID=V_IN_SBID
            AND T.YSFW_DM IN ('9901300011','9901300012','9901300013')
            AND NOT EXISTS (SELECT 1
                              FROM CKTS_SB_MDT_TLHY_LSB S
                             WHERE S.SBID=V_IN_SBID);
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_GJYS_LSB',NULL,NULL,T.SBXH,NULL,'MDT_GJYS_CKRQ_NSRZG','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.KPRQ, '%Y-%m-%d')), ']企业非增值税一般纳税人！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_GJYS_LSB T
           LEFT JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='YBNSRRD' AND S.FLAG='1' AND T.KPRQ BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID
            AND S.KZLX IS NULL;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_GJYS_LSB',NULL,NULL,T.SBXH,NULL,'MDT_GJYS_CKRQ_TQQY','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.KPRQ, '%Y-%m-%d')), ']企业处于出口退税停权期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_GJYS_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='TQQY' AND S.FLAG='1' AND T.KPRQ BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_GJYS_LSB',NULL,NULL,T.SBXH,NULL,'MDT_GJYS_CKRQ_MSQY','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.KPRQ, '%Y-%m-%d')), ']企业处于免税期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_GJYS_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='TSGMS' AND S.FLAG='1' AND T.KPRQ BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_GJYS_LSB',NULL,NULL,T.SBXH,NULL,'MDT_GJYS_CKRQ_FQTS','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.KPRQ, '%Y-%m-%d')), ']放弃零税率应税服务退税期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_GJYS_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='FQLSL' AND S.FLAG='1' AND T.KPRQ BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MDT_GJYS.sql

-- ======================================================================
-- [049/114] BEGIN SOURCE: PROC_XXBD_MDT_GJYS_HKYS.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MDT_GJYS_HKYS$$

CREATE PROCEDURE PROC_XXBD_MDT_GJYS_HKYS
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（生产企业免抵退税）
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LC_MSG          VARCHAR(200) DEFAULT ' ';

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 国际运输明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_MDT_HKYS_QS_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;
  SET LC_YDOBJECT ='航空运输';

END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MDT_GJYS_HKYS.sql

-- ======================================================================
-- [050/114] BEGIN SOURCE: PROC_XXBD_MDT_GJYS_KYHJ.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MDT_GJYS_KYHJ$$

CREATE PROCEDURE PROC_XXBD_MDT_GJYS_KYHJ
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（生产企业免抵退税）
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LC_MSG          VARCHAR(200) DEFAULT ' ';

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 国际运输明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_MDT_KYHJ_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;
  SET LC_YDOBJECT ='国际客运';

END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MDT_GJYS_KYHJ.sql

-- ======================================================================
-- [051/114] BEGIN SOURCE: PROC_XXBD_MDT_GJYS_THLY.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MDT_GJYS_THLY$$

CREATE PROCEDURE PROC_XXBD_MDT_GJYS_THLY
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（生产企业免抵退税）
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LC_MSG          VARCHAR(200) DEFAULT ' ';

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 国际运输明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_MDT_TLHY_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;
  SET LC_YDOBJECT ='中铁货运';

END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MDT_GJYS_THLY.sql

-- ======================================================================
-- [052/114] BEGIN SOURCE: PROC_XXBD_MDT_HGSPTZ.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MDT_HGSPTZ$$

CREATE PROCEDURE PROC_XXBD_MDT_HGSPTZ
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（生产企业免抵退税）
  修改日期：20230207，修改代理证明出口申报调整表的疑点逻辑和提示
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 海关代码调整明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_MDT_HGSPTZ_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;
  SET LC_YDOBJECT ='代码调整';

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_HGSPTZ_LSB','CKTS_SB_MDT_TSSB_LSB',NULL,T.SBXH,NULL,'MDT_BJGX_DMTZ_CKHW_CKPZ','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', IFNULL(T.DLCKHWZMHM, T.CKBGDH)), ']未申报免退税出口明细！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_HGSPTZ_LSB T
          WHERE T.SBID=V_IN_SBID
            AND NOT EXISTS (SELECT 1 FROM CKTS_SB_MDT_TSSB_LSB S WHERE S.SBID=T.SBID AND IFNULL(S.DLCKHWZMHM, S.CKBGDH)=IFNULL(T.DLCKHWZMHM, T.CKBGDH));
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_HGSPTZ_LSB','CKTS_SB_MDT_TSSB_LSB',NULL,T.SBXH,NULL,'MDT_BJGX_DMTZ_CKHW_CKRQ','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', IFNULL(T.DLCKHWZMHM, T.CKBGDH)), ']的出口日期与免退税出口明细表中不一致！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_HGSPTZ_LSB T
          INNER JOIN CKTS_SB_MDT_TSSB_LSB S ON S.SBID=T.SBID AND IFNULL(S.DLCKHWZMHM, S.CKBGDH)=IFNULL(T.DLCKHWZMHM, T.CKBGDH)
          WHERE T.SBID=V_IN_SBID
            AND DATE(T.CKRQ_1)<>DATE(S.CKRQ_1);
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_HGSPTZ_LSB','CKTS_SB_MDT_TSSB_LSB',NULL,T.SBXH,NULL,'MDT_BJGX_DMTZ_CKHW_SPDM','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', IFNULL(T.DLCKHWZMHM, T.CKBGDH)), ']调整前商品代码与免退税出口明细表中不一致！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_HGSPTZ_LSB T
          INNER JOIN CKTS_SB_MDT_TSSB_LSB S ON S.SBID=T.SBID AND IFNULL(S.DLCKHWZMHM, S.CKBGDH)=IFNULL(T.DLCKHWZMHM, T.CKBGDH)
          WHERE T.SBID=V_IN_SBID
            AND T.CKSP_DM<>S.CKSP_DM;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_HGSPTZ_LSB','CKTS_SB_MDT_TSSB_LSB',NULL,T.SBXH,NULL,'MDT_BJGX_DMTZ_CKHW_ZSLV','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', IFNULL(T.DLCKHWZMHM, T.CKBGDH)), ']调整后商品代码在对应出口日期的退税率文库中的征税率与货物出口明细表中不一致！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_HGSPTZ_LSB T
          INNER JOIN CKTS_SB_MDT_TSSB_LSB S ON S.SBID=T.SBID AND IFNULL(S.DLCKHWZMHM, S.CKBGDH)=IFNULL(T.DLCKHWZMHM, T.CKBGDH)
           LEFT JOIN CKTS_DM_TSLVWK C ON C.CKSP_DM=T.TZHCKSP_DM AND S.CKRQ_1 BETWEEN C.YXQQ AND C.YXQZ
           LEFT JOIN CKTS_DM_TSLVTZ D ON D.CKSP_DM=T.TZHCKSP_DM AND S.CKRQ_1 BETWEEN D.KSSJ AND D.JSSJ
          WHERE T.SBID=V_IN_SBID
            AND IFNULL(IFNULL(D.ZSSL, C.ZSSL), 0)<>S.ZSSL;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_HGSPTZ_LSB','CKTS_SB_MDT_TSSB_LSB',NULL,T.SBXH,NULL,'MDT_BJGX_DMTZ_CKHW_TSLV','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', IFNULL(T.DLCKHWZMHM, T.CKBGDH)), ']调整后退税率与免退税进货明细表中不一致！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_HGSPTZ_LSB T
          INNER JOIN CKTS_SB_MDT_TSSB_LSB S ON S.SBID=T.SBID AND IFNULL(S.DLCKHWZMHM, S.CKBGDH)=IFNULL(T.DLCKHWZMHM, T.CKBGDH)
          WHERE T.SBID=V_IN_SBID
            AND T.TZHTSL<>S.TSL;
    COMMIT;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MDT_HGSPTZ.sql

-- ======================================================================
-- [053/114] BEGIN SOURCE: PROC_XXBD_MDT_STZC.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MDT_STZC$$

CREATE PROCEDURE PROC_XXBD_MDT_STZC
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（生产企业免抵退税）
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 视同自产明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_MDT_STZCQD_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;
  SET LC_YDOBJECT ='视同自产';

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_STZCQD_LSB','CKTS_SB_MDT_TSSB_LSB',NULL,T.SBXH,NULL,'MDT_BJGX_STZC_CKHW_SBNO','E','对应出口明细表申报序号在货物出口明细中业务类型非视同自产','N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_STZCQD_LSB T
          WHERE T.SBID=V_IN_SBID
            AND NOT EXISTS (SELECT 1 FROM CKTS_SB_MDT_TSSB_LSB S WHERE S.SBID=T.SBID AND S.SBXH=T.MXSBXH AND INSTR(S.CKTMSYWLXDMJH,'STZC')>0);
    COMMIT;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MDT_STZC.sql

-- ======================================================================
-- [054/114] BEGIN SOURCE: PROC_XXBD_MDT_TSSB.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MDT_TSSB$$

CREATE PROCEDURE PROC_XXBD_MDT_TSSB
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（生产企业免抵退税）
  调整日期：20220323，1、根据总局货劳司关于加强启运港出口退（免）税统计分析功能的业务要求，增加MDT_CKHW_CKYWLX_QYGTS疑点
  修改日期：20220615，根据2022年9号公告，合并收汇与不能收汇
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LDT_TODAY       DATETIME;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';
  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  IF V_IN_SSSQ<>DATE_FORMAT(DATE_ADD(CURRENT_TIMESTAMP, INTERVAL -1 MONTH), '%Y%m') THEN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),'前置检查',
                NULL,NULL,NULL,NULL,NULL,'QZJC_SBYWB_SSSQ','E','免抵退申报所属时期必须与当月增值税纳税申报所属时期一致！','N',CURRENT_TIMESTAMP
 T;
    COMMIT;
  END IF;

  -- 出口货物劳务明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_MDT_TSSB_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;
  SET LC_YDOBJECT ='出口明细';

  BEGIN
    CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',LDT_TODAY,LC_FLGLCD, LN_CPCODEKZ);
    CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TGSHZL',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
    IF (LC_FLGLCD='D') OR (LN_CPCODEKZ>0) THEN
      BEGIN
        INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
             SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                    'CKTS_SB_MDT_TSSB_LSB','CKTS_SB_MDT_CKSH_LSB',NULL,T.SBXH,NULL,'MDT_BJGX_CKHW_SHZL_CKPZ','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', T.CKBGDH), T.DLCKHWZMHM), ']未申报收汇资料！'),'N',CURRENT_TIMESTAMP
               FROM CKTS_SB_MDT_TSSB_LSB T
              WHERE T.SBID=V_IN_SBID
                AND FUNC_XXBD_CHECK_NEEDSH(ORA_CONCAT(ORA_CONCAT(',', T.CKTMSYWLXDMJH), ',')) = 1
                AND NOT EXISTS (SELECT 1 FROM CKTS_SB_MDT_CKSH_LSB S WHERE S.SBID=T.SBID AND ORA_CONCAT(S.CKBGDH, S.DLCKHWZMHM)=ORA_CONCAT(T.CKBGDH, T.DLCKHWZMHM));
        COMMIT;

        INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
             SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                    'CKTS_SB_MDT_TSSB_LSB','CKTS_SB_MDT_STZCQD_LSB',NULL,T.SBXH,NULL,'MDT_BJGX_CKHW_STZC_SBNO','E','业务类型为视同自产，对应序号未申报视同自产进货清单！','N',CURRENT_TIMESTAMP
               FROM CKTS_SB_MDT_TSSB_LSB T
              WHERE T.SBID=V_IN_SBID
                AND INSTR(T.CKTMSYWLXDMJH,'STZC')>0
                AND NOT EXISTS (SELECT 1 FROM CKTS_SB_MDT_STZCQD_LSB S WHERE S.SBID=T.SBID AND S.MXSBXH=T.SBXH);
        COMMIT;
      END;
    ELSE
      BEGIN
        INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
             SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                    'CKTS_SB_MDT_TSSB_LSB','CKTS_SB_MDT_CKSH_LSB',NULL,T.SBXH,NULL,'MDT_BJGX_CKHW_SHZL_CKPZ','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', T.CKBGDH), T.DLCKHWZMHM), ']未申报收汇资料！'),'N',CURRENT_TIMESTAMP
               FROM CKTS_SB_MDT_TSSB_LSB T
              WHERE T.SBID=V_IN_SBID
                AND (((STR_TO_DATE(ORA_CONCAT(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y'), '0419'), '%Y%m%d')<CURRENT_TIMESTAMP) AND (CKRQ_1<MAKEDATE(YEAR(CURRENT_TIMESTAMP), 1))) OR (CKRQ_1<DATE_ADD(MAKEDATE(YEAR(CURRENT_TIMESTAMP), 1), INTERVAL -12 MONTH)))
                AND FUNC_XXBD_CHECK_NEEDSH(ORA_CONCAT(ORA_CONCAT(',', T.CKTMSYWLXDMJH), ',')) = 1
                AND NOT EXISTS (SELECT 1 FROM CKTS_SB_MDT_CKSH_LSB S WHERE S.SBID=T.SBID AND ORA_CONCAT(S.CKBGDH, S.DLCKHWZMHM)=ORA_CONCAT(T.CKBGDH, T.DLCKHWZMHM));
        COMMIT;
      END;
    END IF;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_TSSB_LSB','CKTS_SB_MDT_XTHH_LSB',NULL,T.SBXH,NULL,'MDT_BJGX_CKHW_XTHH_HTH','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('业务类型为“先退后核-先退”，先退后核合同号[', T.CKBGDH), ']出口货物报关单号['), T.CKBGDH), ']未申报先退后核附表！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_TSSB_LSB T
          WHERE T.SBID=V_IN_SBID
            AND INSTR(T.CKTMSYWLXDMJH,'XTHH-XT')>0
            AND NOT EXISTS (SELECT 1 FROM CKTS_SB_MDT_XTHH_LSB S WHERE S.SBID=T.SBID AND S.CKHTH=T.CKHTH AND S.CKBGDH=T.CKBGDH);
    COMMIT;
  END;

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,T.SBXH,NULL,'MDT_CKHW_CKRQ_NSRZG','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.CKRQ_1, '%Y-%m-%d')), ']企业非增值税一般纳税人！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_TSSB_LSB T
           LEFT JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='YBNSRRD' AND S.FLAG='1' AND T.CKRQ_1 BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID
            AND (T.CKTMSYWLXDMJH IS NULL OR INSTR(T.CKTMSYWLXDMJH,'HZCJ')=0)
            AND S.KZLX IS NULL;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,T.SBXH,NULL,'MDT_CKHW_CKRQ_TQQY','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.CKRQ_1, '%Y-%m-%d')), ']企业处于出口退税停权期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_TSSB_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='TQQY' AND S.FLAG='1' AND T.CKRQ_1 BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID
            AND (T.CKTMSYWLXDMJH IS NULL OR INSTR(T.CKTMSYWLXDMJH,'HZCJ')=0);
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,T.SBXH,NULL,'MTS_CKMX_CKRQ_MSQY','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.CKRQ_1, '%Y-%m-%d')), ']企业处于免税期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_TSSB_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='TSGMS' AND S.FLAG='1' AND T.CKRQ_1 BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID
            AND (T.CKTMSYWLXDMJH IS NULL OR INSTR(T.CKTMSYWLXDMJH,'HZCJ')=0);
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,T.SBXH,NULL,'MDT_CKHW_CKRQ_FQTS','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.CKRQ_1, '%Y-%m-%d')), ']放弃退（免）税权选择免税期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_TSSB_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='FQTSSXMS' AND S.FLAG='1' AND T.CKRQ_1 BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID
            AND (T.CKTMSYWLXDMJH IS NULL OR INSTR(T.CKTMSYWLXDMJH,'HZCJ')=0);
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,T.SBXH,NULL,'MDT_CKHW_CKRQ_FQTS','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.CKRQ_1, '%Y-%m-%d')), ']放弃退（免）税权选择征税期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_TSSB_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='FQTSSXZS' AND S.FLAG='1' AND T.CKRQ_1 BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID
            AND (T.CKTMSYWLXDMJH IS NULL OR INSTR(T.CKTMSYWLXDMJH,'HZCJ')=0);
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,T.SBXH,NULL,'MDT_CKHW_CKRQ_FQTS','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.CKRQ_1, '%Y-%m-%d')), ']放弃退（免）税权期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_TSSB_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='FQTMS' AND S.FLAG='1' AND T.CKRQ_1 BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID
            AND (T.CKTMSYWLXDMJH IS NULL OR INSTR(T.CKTMSYWLXDMJH,'HZCJ')=0);
    COMMIT;
  END;

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,T.SBXH,NULL,'MDT_CKHW_CKYWLX_QYGTS','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', IFNULL(T.CKBGDH, T.DLCKHWZMHM)), ']为启运港业务，需确认国内启运方式及海关总署认证企业类型！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_TSSB_LSB T
          WHERE T.SBID=V_IN_SBID
            AND INSTR(T.CKTMSYWLXDMJH,'QYGTS')>0
            AND (T.GNQYFS_DM IS NULL OR T.HGZSRZQYLX_DM IS NULL);
    COMMIT;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MDT_TSSB.sql

-- ======================================================================
-- [055/114] BEGIN SOURCE: PROC_XXBD_MDT_TSSB_BGD.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MDT_TSSB_BGD$$

CREATE PROCEDURE PROC_XXBD_MDT_TSSB_BGD
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（生产企业免抵退税）
  调整日期：20201106，1、对HZCJ不判断剩余数量和美元离岸价，2、对金额增加null判断，3、监管方式1200列入进料加工
  调整日期：20201109，1、历史已申报记录本期冲减本期重新申报，对重新申报记录的数量、金额比对逻辑调整
  调整日期：20201119，1、调整改单报关单监控条件，由bgd202不存在改为bgd201.gdbz_1<>Y，2、调整MDT_CKHW_BGD_XLXP_NOT为可挑过提示性疑点
  调整日期：20201201，1、调整报关单总量控制疑点的疑点对象赋值，原来自动用了进料加工，现调整回出口报关单
  调整日期：20210113，1、调整改单报关单监控条件，改为bgd202不存在 且 bgd201.gdbz_1<>Y
  调整日期：20210416，1、MDT_CKHW_BDG_CKRQ的监控条件，剔除经保税区出口业务类型，该业务类型采用出境货物备案清单的日期，与报关单离境日期不一样
  调整日期：20210512，1、调整MDT_CKHW_BGD_USDLAJ监控条件，对本期红字冲减本期正数申报的数据当合计离岸价小于0的时候也校验差异说明
  调整日期：20210812，1、调整MDT_CKHW_BGD_CD、MDT_CKHW_BGD_GD监控条件，对红字冲减业务不判断
  调整日期：20211108，1、调整MDT_CKHW_BGD_WDZXX监控条件，对红字冲减业务不判断（永康徐育泽反应有企业已申报数据海关作废，导致冲减时201找不到）
  调整日期：20211111，1、与魏浩确认，调整离岸价差异表监控条件，增加疑点MDT_CKHW_BGD_USDLAJ_CY
                       2、增加红字冲减与原申报数的比较疑点MDT_CKHW_BGD_HZCJ_BYZ
                       3、调整MDT_CKHW_BGD_USDLAJ监控条件与说明
  调整日期：20211123，对疑点MDT_LACY_BGD_USDLAJ的校验逻辑进行修正，仅校验bgd201表，不校验bgd202表，与202表的校验改到PROC_XXBD_MDT_TSSB_BGD中进行
                       （通过增加MDT_CKHW_BGD_USDLAJ_GD疑点，在企业申报数据与201不一致需要差异说明时，如果存在改单数据与申报一致，提示）
  调整日期：20211213，对疑点MDT_CKHW_BGD_BYTS的校验逻辑进行修正，仅针对非红字冲减或红字冲减退运的业务进行判断
  调整日期：20211214，对疑点MDT_JLJG_SCH_NOJLJG的校验逻辑进行修正，同时判断企业是否填了加工贸易手册号或计划分配率
  调整日期：20220707, 增加非红字冲减报关单历史是否曾经申报退税的判断，疑点代码MDT_CKHW_BGD_LSSBJL
  调整日期：20220720，1、出口日期不一致疑点代码，由MDT_CKHW_BDG_CKRQ改为MDT_CKHW_BGD_CKRQ
  调整日期：20230308，1、针对启运港业务的负数冲减，不判断MDT_CKHW_BGD_QYGTS_CXCK、MDT_CKHW_BGD_QYGTS_FLGLCD、MDT_CKHW_BGD_QYGTS_CKRQ、MDT_CKHW_BGD_QYGTS_WDD
  调整日期：20230313，增加MDT_CKHW_BGD_BSQ_BAQD、MDT_CKHW_BGD_BSQ_BANR、MDT_CKHW_BGD_RMBLAJ、MDT_CKHW_BGD_HZCJ_TY疑点判断
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LN_CMCD_LEN     BIGINT;
  DECLARE LN_ZHJHFPL      DECIMAL(16,6);

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';


  -- 报关单出口货物劳务明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_MDT_TSSB_LSB T
     WHERE T.SBID=V_IN_SBID
       AND T.CKBGDH IS NOT NULL;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;
  SET LC_YDOBJECT ='出口报关单';

  -- 获取进料加工企业最新调整计划分配律
  BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
      SET LN_ZHJHFPL =0;

  END;
SELECT ZHJHFPL
      INTO LN_ZHJHFPL
      FROM (SELECT CASE WHEN T.JHFPLV_NEW=0 THEN T.JHFPLV ELSE T.JHFPLV_NEW END AS ZHJHFPL
              FROM GS_JLJG_JHFPL T
             WHERE T.NSRDZDAH=V_IN_NSRDZDAH
             ORDER BY T.UPTIME DESC) AS BJTS_DERIVED_001
     WHERE 1=1
LIMIT 1;
  END;

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,T.SBXH,NULL,'MDT_CKHW_BGD_WDZXX','E',
                ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), ']无电子信息！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_TSSB_LSB T
          WHERE T.SBID=V_IN_SBID
            AND T.CKBGDH IS NOT NULL
            AND FUNC_XXBD_CHECK_YWLX(ORA_CONCAT(ORA_CONCAT(',', T.CKTMSYWLXDMJH), ',')) = 0
            AND INSTR(IFNULL(T.CKTMSYWLXDMJH, ' '),'HZCJ')=0
            AND NOT EXISTS (SELECT 1 FROM CKTS_WBSJ_HG_BGD201 S WHERE S.DJXH=V_IN_DJXH AND S.CKBGDH=T.CKBGDH);
    COMMIT;
  END;

  BEGIN
    BEGIN
  DECLARE BJTS_CURSOR_DONE_002 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_SBXH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKBGDH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_BYTSBZ_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CYTSSBJL_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKRQ_SB_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKRQ_SH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_QYRQ_SH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKTMSYWLXDMJH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSP_DM_SB_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSP_DM_SH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_TYYBSWTSTYLX_DM_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_GDBZ_1_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKBGDH_GD_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_MYLAJ_GD_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_JGFS_DM_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_JGFSTSLX_DM_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_ZZMDGDQSZ_DM_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_QYGBZ_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_QYGCXCKBZ_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_QYGWDDBZ_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_QYGZCJGBZ_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_YSFS_DM_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_JLJGSZCH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_TZHJHFPL_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_BAH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_SJFPL_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSL_SB_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_MYLAJ_SB_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_RMBLAJ_SB_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_MYLAJ_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_TSSBSL_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_TSSBMYLAJ_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_TSSBRMBLAJ_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKFPMYLAJ_002 LONGTEXT;
  DECLARE BJTS_CURSOR_002 CURSOR FOR
SELECT A.SBXH,
                          A.CKBGDH,
                          B.BYTSBZ,
                          B.CYTSSBJL,
                          DATE(A.CKRQ_1) AS CKRQ_SB,
                          DATE(B.CKRQ_1) AS CKRQ_SH,
                          DATE(B.QYRQ_2) AS QYRQ_SH,
                          IFNULL(A.CKTMSYWLXDMJH, ' ') AS CKTMSYWLXDMJH,
                          A.CKSP_DM AS CKSP_DM_SB,
                          B.CKSP_DM AS CKSP_DM_SH,
                          D.TYYBSWTSTYLX_DM,
                          IFNULL(B.GDBZ_1, ' ') AS GDBZ_1,
                          E.CKBGDH AS CKBGDH_GD,
                          E.MYLAJ AS MYLAJ_GD,
                          C.JGFS_DM,
                          C.JGFSTSLX_DM,
                          B.ZZMDGDQSZ_DM,
                          B.QYGBZ,
                          B.QYGCXCKBZ,
                          B.QYGWDDBZ,
                          B.QYGZCJGBZ,
                          B.YSFS_DM,
                          A.JLJGSZCH,
                          A.TZHJHFPL,
                          B.BAH,
                          G.SJFPL,
                          A.CKSL AS CKSL_SB,
                          A.MYLAJ AS MYLAJ_SB,
                          A.RMBLAJ AS RMBLAJ_SB,
                          B.MYLAJ,
                          IFNULL(B.TSSBSL, 0) AS TSSBSL,
                          IFNULL(B.TSSBMYLAJ, 0) AS TSSBMYLAJ,
                          IFNULL(B.TSSBRMBLAJ, 0) AS TSSBRMBLAJ,
                          F.CKFPMYLAJ
                     FROM CKTS_SB_MDT_TSSB_LSB A
                    INNER JOIN CKTS_WBSJ_HG_BGD201 B ON B.DJXH=V_IN_DJXH AND B.CKBGDH=A.CKBGDH
                     LEFT JOIN CKTS_DM_HGJGFS C ON C.JGFS_DM=B.JGFS_DM
                     LEFT JOIN CKTS_JGB_ZM_TYYBSWTS D ON D.DJXH=V_IN_DJXH AND D.CKBGDH=A.CKBGDH AND IFNULL(D.ZFBZ_1, 'N')='N'
                     LEFT JOIN CKTS_WBSJ_HG_BGD202 E ON D.DJXH=V_IN_DJXH AND E.CKBGDH=A.CKBGDH
                     LEFT JOIN CKTS_SB_MDT_CYSM_LSB F ON F.SBID=V_IN_SBID AND F.CKBGDH=A.CKBGDH
                     LEFT JOIN (SELECT JGMYSCH, HXQSRQ, HXJZRQ, SJFPL,
                                       ROW_NUMBER() OVER (PARTITION BY JGMYSCH,
                                       CASE WHEN SUBSTR(JGMYSCH,1,1)='C' THEN NULL ELSE HXQSRQ END,
                                       CASE WHEN SUBSTR(JGMYSCH,1,1)='C' THEN NULL ELSE HXJZRQ END ORDER BY LRRQ DESC) AS RN
                                  FROM GS_JLJG_HXJG
                                 WHERE NSRDZDAH=V_IN_NSRDZDAH) G ON G.JGMYSCH=A.JLJGSZCH AND RN=1 AND (SUBSTR(A.JLJGSZCH,1,1)='C' OR (A.CKRQ_1 BETWEEN G.HXQSRQ AND G.HXJZRQ))
                    WHERE A.SBID=V_IN_SBID
                      AND A.CKBGDH IS NOT NULL
                      AND FUNC_XXBD_CHECK_YWLX(ORA_CONCAT(ORA_CONCAT(',', A.CKTMSYWLXDMJH), ',')) = 0;
  OPEN BJTS_CURSOR_002;
  BJTS_CURSOR_LOOP_002: LOOP
    SET BJTS_CURSOR_DONE_002 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_002 = TRUE;
      FETCH BJTS_CURSOR_002 INTO BJTS_LSF_XX_SBXH_002, BJTS_LSF_XX_CKBGDH_002, BJTS_LSF_XX_BYTSBZ_002, BJTS_LSF_XX_CYTSSBJL_002, BJTS_LSF_XX_CKRQ_SB_002, BJTS_LSF_XX_CKRQ_SH_002, BJTS_LSF_XX_QYRQ_SH_002, BJTS_LSF_XX_CKTMSYWLXDMJH_002, BJTS_LSF_XX_CKSP_DM_SB_002, BJTS_LSF_XX_CKSP_DM_SH_002, BJTS_LSF_XX_TYYBSWTSTYLX_DM_002, BJTS_LSF_XX_GDBZ_1_002, BJTS_LSF_XX_CKBGDH_GD_002, BJTS_LSF_XX_MYLAJ_GD_002, BJTS_LSF_XX_JGFS_DM_002, BJTS_LSF_XX_JGFSTSLX_DM_002, BJTS_LSF_XX_ZZMDGDQSZ_DM_002, BJTS_LSF_XX_QYGBZ_002, BJTS_LSF_XX_QYGCXCKBZ_002, BJTS_LSF_XX_QYGWDDBZ_002, BJTS_LSF_XX_QYGZCJGBZ_002, BJTS_LSF_XX_YSFS_DM_002, BJTS_LSF_XX_JLJGSZCH_002, BJTS_LSF_XX_TZHJHFPL_002, BJTS_LSF_XX_BAH_002, BJTS_LSF_XX_SJFPL_002, BJTS_LSF_XX_CKSL_SB_002, BJTS_LSF_XX_MYLAJ_SB_002, BJTS_LSF_XX_RMBLAJ_SB_002, BJTS_LSF_XX_MYLAJ_002, BJTS_LSF_XX_TSSBSL_002, BJTS_LSF_XX_TSSBMYLAJ_002, BJTS_LSF_XX_TSSBRMBLAJ_002, BJTS_LSF_XX_CKFPMYLAJ_002;
    END;
    IF BJTS_CURSOR_DONE_002 THEN
      LEAVE BJTS_CURSOR_LOOP_002;
    END IF;
      BEGIN
        SET LC_YDOBJECT ='出口报关单';

        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'HZCJ')>0) THEN
          IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'HZCJ-TY')=0) THEN
            -- 20211111, 增加红字冲减与原申报数的比较
            BEGIN
              IF (BJTS_LSF_XX_CKSL_SB_002 + BJTS_LSF_XX_TSSBSL_002 <>0) THEN
                INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                     SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                            'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_HZCJ_BYZ','E',
                            ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']业务类型选择红字冲减，出口数量与已申报出口数量['), BJTS_LSF_XX_TSSBSL_002), ']不一致！'),'N',CURRENT_TIMESTAMP
;
                COMMIT;
              END IF;
              IF (BJTS_LSF_XX_MYLAJ_SB_002 + BJTS_LSF_XX_TSSBMYLAJ_002 <>0) THEN
                INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                     SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                            'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_HZCJ_BYZ','E',
                            ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']业务类型选择红字冲减，美元离岸价与已申报美元离岸价['), BJTS_LSF_XX_TSSBMYLAJ_002), ']不一致！'),'N',CURRENT_TIMESTAMP
;
                COMMIT;
              END IF;
              IF (BJTS_LSF_XX_RMBLAJ_SB_002 + BJTS_LSF_XX_TSSBRMBLAJ_002 <>0) THEN
                INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                     SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                            'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_HZCJ_BYZ','E',
                            ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']业务类型选择红字冲减，人民币离岸价与已申报人民币离岸价['), BJTS_LSF_XX_TSSBRMBLAJ_002), ']不一致！'),'N',CURRENT_TIMESTAMP
;
                COMMIT;
              END IF;
            END;
          ELSE
            -- 20230314, 增加红字冲减-退运与原退运证明一致性的提示
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                        'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_HZCJ_TY','I',
                        ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']业务类型选择红字冲减-退运，请核实退运冲减的人民币离岸价与应冲减的退运证明对应的实际出口销售额是否一致！'),'Y',CURRENT_TIMESTAMP
;
            COMMIT;
          END IF;
        ELSE
          BEGIN
            -- 20211111，与魏浩确认，离岸价差异只比对申报数与海关出口数，不关联申报数量、已申报数量（包括退税、代理、退运）
            IF (ABS(BJTS_LSF_XX_MYLAJ_SB_002-BJTS_LSF_XX_MYLAJ_002)>1) AND (ABS(BJTS_LSF_XX_MYLAJ_SB_002-BJTS_LSF_XX_MYLAJ_002)>0.05 * BJTS_LSF_XX_MYLAJ_002) AND (BJTS_LSF_XX_CKFPMYLAJ_002 IS NULL) THEN
              BEGIN
                INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                     SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                            'CKTS_SB_MDT_TSSB_LSB','CKTS_SB_MDT_CYSM_LSB',NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_USDLAJ_CY','E',
                            ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']美元离岸价['), BJTS_LSF_XX_MYLAJ_SB_002), ']超过电子信息中['), BJTS_LSF_XX_MYLAJ_002), ']合理范围，需提供《出口货物离岸价差异原因说明表》！'),'N',CURRENT_TIMESTAMP
;
                COMMIT;

                -- 存在离岸价差异且未填报差异说明表的情况下，判断是否因改单引起
                IF (BJTS_LSF_XX_CKBGDH_GD_002 IS NOT NULL) AND ((ABS(BJTS_LSF_XX_MYLAJ_SB_002-BJTS_LSF_XX_MYLAJ_GD_002)<=1) OR (ABS(BJTS_LSF_XX_MYLAJ_SB_002-BJTS_LSF_XX_MYLAJ_GD_002)<=0.05 * BJTS_LSF_XX_MYLAJ_GD_002)) THEN
                  INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                       SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                              'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_USDLAJ_GD','I',
                              ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']存在改单后信息，且改单后信息未同步到报关单电子信息中！'),'Y',CURRENT_TIMESTAMP
;
                  COMMIT;
                END IF;
              END;
            END IF;
            -- 20220707, 增加非红字冲减报关单历史是否曾经申报退税的判断
            IF (TRIM(BJTS_LSF_XX_CYTSSBJL_002) IS NOT NULL) AND (BJTS_LSF_XX_TSSBSL_002>0) THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_LSSBJL','I',
                          ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']曾经参与历史申报，请确认是否重复！'),'Y',CURRENT_TIMESTAMP
;
              COMMIT;
            END IF;
            -- 20211213，对红字冲减、红字冲减退运业务，不判断已经标注“不予退税”
            IF (BJTS_LSF_XX_BYTSBZ_002='Y') THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_BYTS','E',
                          ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']已被标注为“不予退税”！'),'N',CURRENT_TIMESTAMP
;
              COMMIT;
            END IF;
            -- 1退运; 2改单; 3撤单
            IF (BJTS_LSF_XX_TYYBSWTSTYLX_DM_002='3') THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_CD','E',
                          ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']曾办理过用途为”撤单“的有效的退运证明！'),'N',CURRENT_TIMESTAMP
;
              COMMIT;
            ELSEIF (BJTS_LSF_XX_TYYBSWTSTYLX_DM_002='2' AND BJTS_LSF_XX_GDBZ_1_002<>'Y' AND BJTS_LSF_XX_CKBGDH_GD_002 IS NULL) THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_GD','E',
                          ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']曾办理过用途为“改单”的有效的退运证明，且在“海关出口报关单改单数据”中不存在！'),'N',CURRENT_TIMESTAMP
;
              COMMIT;
            END IF;
          END;
        END IF;

        SET LN_CMCD_LEN = CASE WHEN LENGTH(BJTS_LSF_XX_CKSP_DM_SB_002) > LENGTH(BJTS_LSF_XX_CKSP_DM_SH_002) THEN LENGTH(BJTS_LSF_XX_CKSP_DM_SH_002) ELSE LENGTH(BJTS_LSF_XX_CKSP_DM_SB_002) END;
        IF SUBSTR(BJTS_LSF_XX_CKSP_DM_SB_002,1,LN_CMCD_LEN)<>SUBSTR(BJTS_LSF_XX_CKSP_DM_SH_002,1,LN_CMCD_LEN) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_SPDM','E',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']商品代码['), BJTS_LSF_XX_CKSP_DM_SB_002), ']与电子信息中['), BJTS_LSF_XX_CKSP_DM_SH_002), ']不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (TRIM(BJTS_LSF_XX_JGFS_DM_002) IS NULL) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_MYXZ_BCZ','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']在电子信息中监管方式不存在！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        ELSE
          IF (TRIM(BJTS_LSF_XX_JGFSTSLX_DM_002)='0') THEN
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                        'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_MYXZ_BTS','E',
                        ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']在电子信息中监管方式['), BJTS_LSF_XX_JGFS_DM_002), ']不退税！'),'N',CURRENT_TIMESTAMP
;
            COMMIT;
          END IF;
        END IF;

        IF BJTS_LSF_XX_ZZMDGDQSZ_DM_002<>'142' AND INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'LMYCL')>0 THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MTS_CKHW_BGD_LMYCL_ZZMDG','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']贸易国别非中国，“业务类型”不应包含“LMYCL”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'QYGTS')>0) THEN
          BEGIN
            IF (BJTS_LSF_XX_CKRQ_SB_002<>BJTS_LSF_XX_QYRQ_SH_002) AND (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'BSQ')=0) THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_CKRQ','E',
                          ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']出口日期['), DATE_FORMAT(BJTS_LSF_XX_CKRQ_SB_002, '%Y-%m-%d')), ']与电子信息中['), DATE_FORMAT(BJTS_LSF_XX_QYRQ_SH_002, '%Y-%m-%d')), ']不一致！'),'N',CURRENT_TIMESTAMP
;
              COMMIT;
            END IF;
            IF BJTS_LSF_XX_QYGBZ_002<>'Y' THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_QYGTS_NOT',
                          'E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']非启运港业务，“业务类型”不应包含“QYGTS”！'),'N',CURRENT_TIMESTAMP
;
              COMMIT;
            ELSEIF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'HZCJ')=0) THEN
              BEGIN
                IF BJTS_LSF_XX_QYGCXCKBZ_002='Y' THEN
                  INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                       SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                              'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_QYGTS_CXCK','E',
                              ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']为启运港业务，已经撤销出口！'),'N',CURRENT_TIMESTAMP
;
                  COMMIT;
                END IF;
                CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',BJTS_LSF_XX_QYRQ_SH_002,LC_FLGLCD, LN_CPCODEKZ);
                IF (LC_FLGLCD<>'A' AND LC_FLGLCD<>'B') THEN
                  INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                       SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                              'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_QYGTS_FLGLCD','E',
                              ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']启运日当天该企业分类管理类别非一、二类，“业务类型”不应包含“QYGTS”！'),'N',CURRENT_TIMESTAMP
;
                  COMMIT;
                END IF;
                IF TIMESTAMPDIFF(MONTH, BJTS_LSF_XX_QYRQ_SH_002, DATE(CURRENT_TIMESTAMP))>2 THEN
                  INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                       SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                              'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_QYGTS_CKRQ','E',
                              ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']超过启运日两月，“业务类型”不应包含“QYGTS”！'),'N',CURRENT_TIMESTAMP
;
                  COMMIT;
                END IF;
                IF BJTS_LSF_XX_QYGWDDBZ_002='Y' THEN
                  INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                       SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                              'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_QYGTS_WDD','E',
                              ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']未实际到达离境港，“业务类型”不应包含“QYGTS”！'),'N',CURRENT_TIMESTAMP
;
                  COMMIT;
                END IF;
              END;
            END IF;
          END;
        ELSE
          BEGIN
            IF (BJTS_LSF_XX_CKRQ_SB_002<>BJTS_LSF_XX_CKRQ_SH_002) AND (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'BSQ')=0) THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_CKRQ','E',
                          ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']出口日期['), DATE_FORMAT(BJTS_LSF_XX_CKRQ_SB_002, '%Y-%m-%d')), ']与电子信息中['), DATE_FORMAT(BJTS_LSF_XX_CKRQ_SH_002, '%Y-%m-%d')), ']不一致！'),'N',CURRENT_TIMESTAMP
;
              COMMIT;
            END IF;
            IF (BJTS_LSF_XX_QYGBZ_002='Y' AND BJTS_LSF_XX_QYGZCJGBZ_002='N') THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_QYGTS_NULL','E',
                          ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']为启运港业务，目前尚未收到结关信息，“业务类型”应包含“QYGTS”！'),'N',CURRENT_TIMESTAMP
;
              COMMIT;
            END IF;
          END;
        END IF;

        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'DWCB')>0 AND BJTS_LSF_XX_JGFS_DM_002<>'3422' AND BJTS_LSF_XX_JGFS_DM_002<>'22') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_DWCB_NOT','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']非对外承包业务，“业务类型”不应包含“DWCB”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'DWCB')=0 AND (BJTS_LSF_XX_JGFS_DM_002='3422' OR BJTS_LSF_XX_JGFS_DM_002='22')) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_DWCB_NULL','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']为对外承包业务，“业务类型”应包含“DWCB”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'BSQ')>0) THEN
          IF (BJTS_LSF_XX_YSFS_DM_002<>'0') THEN
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                        'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_BSQ_NOT','E',
                        ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']非经保税区出口业务，“业务类型”不应包含“BSQ”！'),'N',CURRENT_TIMESTAMP
;
            COMMIT;
          ELSE
            BEGIN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_BSQ_BAQD','I',
                          ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']业务类型包含保税区BSQ，请核实是否附送《出境货物备案清单》！'),'Y',CURRENT_TIMESTAMP
;
              COMMIT;
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_BSQ_BANR','I',
                          ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']业务类型包含保税区BSQ，请核实出境货物备案清单的内容是否与报关单相关内容相符,出口日期填报是否准确！'),'Y',CURRENT_TIMESTAMP
;
              COMMIT;
            END;
          END IF;
        END IF;
        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'BSQ')=0 AND BJTS_LSF_XX_YSFS_DM_002='0') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_BSQ_NULL','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']为经保税区出口业务，“业务类型”应包含“BSQ”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'JWTZ')>0 AND BJTS_LSF_XX_JGFS_DM_002<>'2210') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_JWTZ_NOT','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']非境外投资业务，“业务类型”不应包含“JWTZ”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'JWTZ')=0 AND BJTS_LSF_XX_JGFS_DM_002='2210') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_JWTZ_NULL','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']为境外投资业务，“业务类型”应包含“JWTZ”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'DWYZ')>0 AND BJTS_LSF_XX_JGFS_DM_002<>'3511') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_DWYZ_NOT','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']非对外援助业务，“业务类型”不应包含“DWYZ”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'DWYZ')=0 AND BJTS_LSF_XX_JGFS_DM_002='3511') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_DWYZ_NULL','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']为对外援助业务，“业务类型”应包含“DWYZ”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'XLXP')>0 AND BJTS_LSF_XX_JGFS_DM_002<>'1300') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_XLXP_NOT','I',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']非修理修配业务，请确认“业务类型”是否选择正确！'),'Y',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'XLXP')=0 AND BJTS_LSF_XX_JGFS_DM_002='1300') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_XLXP_NULL','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']为修理修配业务，“业务类型”应包含“XLXP”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_YSFS_DM_002='8' AND BJTS_LSF_XX_ZZMDGDQSZ_DM_002='142' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_BGD_BSCKZNX','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']为保税仓库转内销！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_YSFS_DM_002='T' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_CKPZH_YSFS','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']为出口到综合试验区（横琴平潭地区）的报关单！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        SET LC_YDOBJECT ='进料加工';
        IF BJTS_LSF_XX_JGFS_DM_002 IN ('0615','0715') THEN
          BEGIN
            IF BJTS_LSF_XX_JLJGSZCH_002 IS NULL THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_JLJG_BDG_NOSCH','E',
                          ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']在电子信息中监管方式为0615/0715，出口明细未申报进料加工手册号！'),'N',CURRENT_TIMESTAMP
;
              COMMIT;
            ELSEIF BJTS_LSF_XX_JLJGSZCH_002 <> BJTS_LSF_XX_BAH_002 THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_JLJG_JGMYSCH','E',
                          ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']申报的进料加工手账册号与电子信息中不一致！'),'N',CURRENT_TIMESTAMP
;
              COMMIT;
            END IF;

            IF BJTS_LSF_XX_TZHJHFPL_002 IS NULL THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_JLJG_BDG_NOFPLV','E',
                          ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']在电子信息中监管方式为0615/0715，出口明细未申报计划分配率！'),'N',CURRENT_TIMESTAMP
;
              COMMIT;
            ELSE
              BEGIN
                IF (BJTS_LSF_XX_SJFPL_002 IS NOT NULL) AND (BJTS_LSF_XX_TZHJHFPL_002<>BJTS_LSF_XX_SJFPL_002) THEN
                  INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                       SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                              'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_JLJG_SJFPLV_YHX','E',
                              '该手（账）册号已完成核销，请按照对应的实际分配率修改后后重新申报！','N',CURRENT_TIMESTAMP
;
                  COMMIT;
                END IF;
                IF (BJTS_LSF_XX_SJFPL_002 IS NULL) AND (BJTS_LSF_XX_TZHJHFPL_002<>LN_ZHJHFPL) THEN
                  INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                       SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                              'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_JLJG_SJFPLV_WHX','E',
                              ORA_CONCAT(ORA_CONCAT('申报的进料加工计划分配率与当前有效的计划分配率[', LN_ZHJHFPL), ']不一致，请反馈计划分配率后重新申报！'),'N',CURRENT_TIMESTAMP
;
                  COMMIT;
                END IF;
              END;
            END IF;
          END;
        ELSE
          -- 20211214，针对企业导入的数据，有可能手册号为空但是存在分配率的，增加分配率的判断
          IF (BJTS_LSF_XX_JLJGSZCH_002 IS NOT NULL) OR (IFNULL(BJTS_LSF_XX_TZHJHFPL_002, 0)<>0) THEN
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                        'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_JLJG_SCH_NOJLJG','I',
                        ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']申报了手册号（或计划分配率），电子信息中监管方式非0615/0715，请确认！'),'Y',CURRENT_TIMESTAMP
;
            COMMIT;
          END IF;
        END IF;
      END;

  END LOOP BJTS_CURSOR_LOOP_002;
  CLOSE BJTS_CURSOR_002;
END;
  END;

  BEGIN
    SET LC_YDOBJECT ='出口报关单';
    BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_CKBGDH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_SBXH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSL_SB_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSL_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TSSBSL_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_DLSBSL_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TYSL_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_SYSL_SH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_MYLAJ_SB_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_MYLAJ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TSSBMYLAJ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_DLSBMYLAJ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TYMYLAJ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_MYLAJ_SH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_RMBLAJ_SB_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_RMBLAJ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TSSBRMBLAJ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_DLSBRMBLAJ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TYRMBLAJ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_RMBLAJ_SH_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT A.CKBGDH,
                          A.SBXH,
                          A.CKSL_SB,
                          B.CKSL,
                          IFNULL(B.TSSBSL, 0) AS TSSBSL,
                          IFNULL(B.DLSBSL, 0) AS DLSBSL,
                          IFNULL(B.TYSL, 0) AS TYSL,
                          B.CKSL-IFNULL(B.TSSBSL, 0)-IFNULL(B.DLSBSL, 0)-IFNULL(B.TYSL, 0) AS SYSL_SH,
                          A.MYLAJ_SB,
                          B.MYLAJ,
                          IFNULL(B.TSSBMYLAJ, 0) AS TSSBMYLAJ,
                          IFNULL(B.DLSBMYLAJ, 0) AS DLSBMYLAJ,
                          IFNULL(B.TYMYLAJ, 0) AS TYMYLAJ,
                          B.MYLAJ-IFNULL(B.TSSBMYLAJ, 0)-IFNULL(B.DLSBMYLAJ, 0)-IFNULL(B.TYMYLAJ, 0) AS MYLAJ_SH,
                          A.RMBLAJ_SB,
                          B.RMBLAJ,
                          IFNULL(B.TSSBRMBLAJ, 0) AS TSSBRMBLAJ,
                          IFNULL(B.DLSBRMBLAJ, 0) AS DLSBRMBLAJ,
                          IFNULL(B.TYRMBLAJ, 0) AS TYRMBLAJ,
                          B.RMBLAJ-IFNULL(B.TSSBRMBLAJ, 0)-IFNULL(B.DLSBRMBLAJ, 0)-IFNULL(B.TYRMBLAJ, 0) AS RMBLAJ_SH
                     FROM (SELECT A.CKBGDH, MIN(A.SBXH) AS SBXH, SUM(A.CKSL) AS CKSL_SB, SUM(A.MYLAJ) AS MYLAJ_SB, SUM(A.RMBLAJ) AS RMBLAJ_SB
                             FROM CKTS_SB_MDT_TSSB_LSB A
                            WHERE A.SBID=V_IN_SBID
                              AND A.CKBGDH IS NOT NULL
                              AND FUNC_XXBD_CHECK_YWLX(ORA_CONCAT(ORA_CONCAT(',', A.CKTMSYWLXDMJH), ',')) = 0
                            GROUP BY A.CKBGDH) A
                    INNER JOIN CKTS_WBSJ_HG_BGD201 B ON B.DJXH=V_IN_DJXH AND B.CKBGDH=A.CKBGDH;
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_LSF_XX_CKBGDH_001, BJTS_LSF_XX_SBXH_001, BJTS_LSF_XX_CKSL_SB_001, BJTS_LSF_XX_CKSL_001, BJTS_LSF_XX_TSSBSL_001, BJTS_LSF_XX_DLSBSL_001, BJTS_LSF_XX_TYSL_001, BJTS_LSF_XX_SYSL_SH_001, BJTS_LSF_XX_MYLAJ_SB_001, BJTS_LSF_XX_MYLAJ_001, BJTS_LSF_XX_TSSBMYLAJ_001, BJTS_LSF_XX_DLSBMYLAJ_001, BJTS_LSF_XX_TYMYLAJ_001, BJTS_LSF_XX_MYLAJ_SH_001, BJTS_LSF_XX_RMBLAJ_SB_001, BJTS_LSF_XX_RMBLAJ_001, BJTS_LSF_XX_TSSBRMBLAJ_001, BJTS_LSF_XX_DLSBRMBLAJ_001, BJTS_LSF_XX_TYRMBLAJ_001, BJTS_LSF_XX_RMBLAJ_SH_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
      BEGIN
        IF (BJTS_LSF_XX_CKSL_SB_001 > 0) AND (BJTS_LSF_XX_CKSL_SB_001 - BJTS_LSF_XX_SYSL_SH_001 > 0) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'MDT_CKHW_BGD_CKSL','I',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']申报退税数量['), BJTS_LSF_XX_CKSL_SB_001), ']超过电子信息中剩余数量['), BJTS_LSF_XX_SYSL_SH_001), ']（其中出口['), BJTS_LSF_XX_CKSL_001), ']退税申报['), BJTS_LSF_XX_TSSBSL_001), ']退运['), BJTS_LSF_XX_TYSL_001), ']代理出口['), BJTS_LSF_XX_DLSBSL_001), ']）！'),'Y',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (BJTS_LSF_XX_MYLAJ_SB_001>0) AND (BJTS_LSF_XX_MYLAJ_SB_001 - BJTS_LSF_XX_MYLAJ_SH_001 > 1) AND (BJTS_LSF_XX_MYLAJ_001 > BJTS_LSF_XX_MYLAJ_SH_001) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'MDT_CKHW_BGD_USDLAJ','I',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']申报美元离岸价['), BJTS_LSF_XX_MYLAJ_SB_001), ']超过电子信息中剩余美元离岸价['), BJTS_LSF_XX_MYLAJ_SH_001), ']（其中出口['), BJTS_LSF_XX_MYLAJ_001), ']退税申报['), BJTS_LSF_XX_TSSBMYLAJ_001), ']退运['), BJTS_LSF_XX_TYMYLAJ_001), ']代理出口['), BJTS_LSF_XX_DLSBMYLAJ_001), ']）！'),'Y',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (BJTS_LSF_XX_RMBLAJ_SB_001>0) AND (BJTS_LSF_XX_RMBLAJ_SB_001 - BJTS_LSF_XX_RMBLAJ_SH_001 > 1) AND (BJTS_LSF_XX_RMBLAJ_001 > BJTS_LSF_XX_RMBLAJ_SH_001) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'MDT_CKHW_BGD_RMBLAJ','I',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']申报人民币离岸价['), BJTS_LSF_XX_RMBLAJ_SB_001), ']超过电子信息中剩余人民币离岸价['), BJTS_LSF_XX_RMBLAJ_SH_001), ']（其中出口['), BJTS_LSF_XX_RMBLAJ_001), ']退税申报['), BJTS_LSF_XX_TSSBRMBLAJ_001), ']退运['), BJTS_LSF_XX_TYRMBLAJ_001), ']代理出口['), BJTS_LSF_XX_DLSBRMBLAJ_001), ']）！'),'Y',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
      END;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MDT_TSSB_BGD.sql

-- ======================================================================
-- [056/114] BEGIN SOURCE: PROC_XXBD_MDT_TSSB_DLZM.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MDT_TSSB_DLZM$$

CREATE PROCEDURE PROC_XXBD_MDT_TSSB_DLZM
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（生产企业免抵退税）
  调整日期：20201106，1、对HZCJ不判断剩余数量和美元离岸价，2、对金额增加null判断，3、监管方式1200列入进料加工
  调整日期：20211111，与报关单疑点一致，1、调整MDT_CKHW_BGD_WDZXX监控条件，对红字冲减业务不判断；
                                        2、增加MDT_CKHW_DLZM_USDLAJ_CY、MDT_CKHW_DLZM_HZCJ_BYZ
                                        3、增加MDT_CKHW_DLCK_CKSL、MDT_CKHW_DLZM_USDLAJ
  调整日期：20211213，对疑点MDT_CKHW_DLZM_BYTS的校验逻辑进行修正，仅针对非红字冲减或红字冲减退运的业务进行判断
  调整日期：20211214，对疑点MDT_JLJG_SCH_NOJLJG的校验逻辑进行修正，同时判断企业是否填了加工贸易手册号或计划分配率
  调整日期：20230313，增加MDT_CKHW_DLZM_BSQ_BAQD、MDT_CKHW_DLZM_BSQ_BANR、MDT_CKHW_DLZM_RMBLAJ、MDT_CKHW_DLZM_HZCJ_TY疑点判断
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LN_CMCD_LEN     BIGINT;
  DECLARE LN_ZHJHFPL      DECIMAL(16,6);

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';


  -- 代理证明出口货物劳务明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_MDT_TSSB_LSB T
     WHERE T.SBID=V_IN_SBID
       AND T.DLCKHWZMHM IS NOT NULL;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;
  SET LC_YDOBJECT ='代理证明';

  -- 获取进料加工企业最新调整计划分配律
  BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
      SET LN_ZHJHFPL =0;

  END;
SELECT ZHJHFPL
      INTO LN_ZHJHFPL
      FROM (SELECT CASE WHEN T.JHFPLV_NEW=0 THEN T.JHFPLV ELSE T.JHFPLV_NEW END AS ZHJHFPL
              FROM GS_JLJG_JHFPL T
             WHERE T.NSRDZDAH=V_IN_NSRDZDAH
             ORDER BY T.UPTIME DESC) AS BJTS_DERIVED_001
     WHERE 1=1
LIMIT 1;
  END;

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,T.SBXH,NULL,'MDT_CKHW_DLZM_WDZXX','E',ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', T.DLCKHWZMHM), ']无电子信息！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_TSSB_LSB T
          WHERE T.SBID=V_IN_SBID
            AND T.DLCKHWZMHM IS NOT NULL
            AND FUNC_XXBD_CHECK_YWLX(ORA_CONCAT(ORA_CONCAT(',', T.CKTMSYWLXDMJH), ',')) = 0
            AND INSTR(IFNULL(T.CKTMSYWLXDMJH, ' '),'HZCJ')=0
            AND NOT EXISTS (SELECT 1 FROM CKTS_WBSJ_ZJ_DLCKHWZM S WHERE S.DJXH=V_IN_DJXH AND S.DLCKHWZMHM=T.DLCKHWZMHM);
    COMMIT;
  END;

  BEGIN
    BEGIN
  DECLARE BJTS_CURSOR_DONE_002 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_SBXH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_DLCKHWZMHM_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_BYTSBZ_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKRQ_SB_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKRQ_SH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKTMSYWLXDMJH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSP_DM_SB_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSP_DM_SH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_JGFS_DM_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_JGFSTSLX_DM_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_ZZMDGDQSZ_DM_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_YSFS_DM_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSL_SB_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_MYLAJ_SB_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_RMBLAJ_SB_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_MYLAJ_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKFPMYLAJ_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_TSSBSL_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_TSSBMYLAJ_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_TSSBRMBLAJ_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_JLJGSZCH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_TZHJHFPL_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_SJFPL_002 LONGTEXT;
  DECLARE BJTS_CURSOR_002 CURSOR FOR
SELECT A.SBXH,
                          A.DLCKHWZMHM,
                          B.BYTSBZ,
                          DATE(A.CKRQ_1) AS CKRQ_SB,
                          DATE(B.CKRQ_1) AS CKRQ_SH,
                          IFNULL(A.CKTMSYWLXDMJH, ' ') AS CKTMSYWLXDMJH,
                          A.CKSP_DM AS CKSP_DM_SB,
                          B.CKSP_DM AS CKSP_DM_SH,
                          C.JGFS_DM,
                          C.JGFSTSLX_DM,
                          B.ZZMDGDQSZ_DM,
                          B.YSFS_DM,
                          A.CKSL AS CKSL_SB,
                          A.MYLAJ AS MYLAJ_SB,
                          A.RMBLAJ AS RMBLAJ_SB,
                          B.MYLAJ,
                          F.CKFPMYLAJ,
                          IFNULL(B.TSSBSL, 0) AS TSSBSL,
                          IFNULL(B.TSSBMYLAJ, 0) AS TSSBMYLAJ,
                          IFNULL(B.TSSBRMBLAJ, 0) AS TSSBRMBLAJ,
                          A.JLJGSZCH,
                          A.TZHJHFPL,
                          G.SJFPL
                     FROM CKTS_SB_MDT_TSSB_LSB A
                    INNER JOIN CKTS_WBSJ_ZJ_DLCKHWZM B ON B.DJXH=V_IN_DJXH AND B.DLCKHWZMHM=A.DLCKHWZMHM
                     LEFT JOIN CKTS_DM_HGJGFS C ON C.JGFS_DM=B.JGFS_DM
                     LEFT JOIN CKTS_SB_MDT_CYSM_LSB F ON F.SBID=V_IN_SBID AND F.DLCKHWZMHM=A.DLCKHWZMHM
                     LEFT JOIN (SELECT NSRDZDAH, JGMYSCH, HXQSRQ, HXJZRQ, SJFPL, ROW_NUMBER() OVER (PARTITION BY NSRDZDAH, JGMYSCH, HXQSRQ, HXJZRQ ORDER BY LRRQ DESC) AS RN
                                  FROM GS_JLJG_HXJG) G ON G.NSRDZDAH=V_IN_NSRDZDAH AND G.JGMYSCH=A.JLJGSZCH AND RN=1 AND (SUBSTR(A.JLJGSZCH,1,1)='C' OR (A.CKRQ_1 BETWEEN G.HXQSRQ AND G.HXJZRQ))
                    WHERE A.SBID=V_IN_SBID
                      AND A.DLCKHWZMHM IS NOT NULL
                      AND FUNC_XXBD_CHECK_YWLX(ORA_CONCAT(ORA_CONCAT(',', A.CKTMSYWLXDMJH), ',')) = 0;
  OPEN BJTS_CURSOR_002;
  BJTS_CURSOR_LOOP_002: LOOP
    SET BJTS_CURSOR_DONE_002 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_002 = TRUE;
      FETCH BJTS_CURSOR_002 INTO BJTS_LSF_XX_SBXH_002, BJTS_LSF_XX_DLCKHWZMHM_002, BJTS_LSF_XX_BYTSBZ_002, BJTS_LSF_XX_CKRQ_SB_002, BJTS_LSF_XX_CKRQ_SH_002, BJTS_LSF_XX_CKTMSYWLXDMJH_002, BJTS_LSF_XX_CKSP_DM_SB_002, BJTS_LSF_XX_CKSP_DM_SH_002, BJTS_LSF_XX_JGFS_DM_002, BJTS_LSF_XX_JGFSTSLX_DM_002, BJTS_LSF_XX_ZZMDGDQSZ_DM_002, BJTS_LSF_XX_YSFS_DM_002, BJTS_LSF_XX_CKSL_SB_002, BJTS_LSF_XX_MYLAJ_SB_002, BJTS_LSF_XX_RMBLAJ_SB_002, BJTS_LSF_XX_MYLAJ_002, BJTS_LSF_XX_CKFPMYLAJ_002, BJTS_LSF_XX_TSSBSL_002, BJTS_LSF_XX_TSSBMYLAJ_002, BJTS_LSF_XX_TSSBRMBLAJ_002, BJTS_LSF_XX_JLJGSZCH_002, BJTS_LSF_XX_TZHJHFPL_002, BJTS_LSF_XX_SJFPL_002;
    END;
    IF BJTS_CURSOR_DONE_002 THEN
      LEAVE BJTS_CURSOR_LOOP_002;
    END IF;
      BEGIN
        SET LC_YDOBJECT ='代理证明';

        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'HZCJ')>0) THEN
          IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'HZCJ-TY')=0) THEN
            -- 20211111, 增加红字冲减与原申报数的比较
            BEGIN
              IF (BJTS_LSF_XX_CKSL_SB_002 + BJTS_LSF_XX_TSSBSL_002 <>0) THEN
                INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                     SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                            'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_DLZM_HZCJ_BYZ','E',
                            ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_002), ']业务类型选择红字冲减，出口数量与已申报出口数量['), BJTS_LSF_XX_TSSBSL_002), ']不一致！'),'N',CURRENT_TIMESTAMP
;
                COMMIT;
              END IF;
              IF (BJTS_LSF_XX_MYLAJ_SB_002 + BJTS_LSF_XX_TSSBMYLAJ_002 <>0) THEN
                INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                     SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                            'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_DLZM_HZCJ_BYZ','E',
                            ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_002), ']业务类型选择红字冲减，美元离岸价与已申报美元离岸价['), BJTS_LSF_XX_TSSBMYLAJ_002), ']不一致！'),'N',CURRENT_TIMESTAMP
;
                COMMIT;
              END IF;
              IF (BJTS_LSF_XX_RMBLAJ_SB_002 + BJTS_LSF_XX_TSSBRMBLAJ_002 <>0) THEN
                INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                     SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                            'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_DLZM_HZCJ_BYZ','E',
                            ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_002), ']业务类型选择红字冲减，人民币离岸价与已申报人民币离岸价['), BJTS_LSF_XX_TSSBRMBLAJ_002), ']不一致！'),'N',CURRENT_TIMESTAMP
;
                COMMIT;
              END IF;
            END;
          ELSE
            -- 20230314, 增加红字冲减-退运与原退运证明一致性的提示
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                        'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_DLZM_HZCJ_TY','I',
                        ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_002), ']业务类型选择红字冲减-退运，请核实退运冲减的人民币离岸价与应冲减的退运证明对应的实际出口销售额是否一致！'),'Y',CURRENT_TIMESTAMP
;
            COMMIT;
          END IF;
        ELSE
          BEGIN
            -- 20211111，与MDT_CKHW_BGD_USDLAJ_CY一致
            IF (ABS(BJTS_LSF_XX_MYLAJ_SB_002-BJTS_LSF_XX_MYLAJ_002)>1) AND (ABS(BJTS_LSF_XX_MYLAJ_SB_002-BJTS_LSF_XX_MYLAJ_002)>0.05 * BJTS_LSF_XX_MYLAJ_002) AND (BJTS_LSF_XX_CKFPMYLAJ_002 IS NULL) THEN
                INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                     SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                            'CKTS_SB_MDT_TSSB_LSB','CKTS_SB_MDT_CYSM_LSB',NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_DLZM_USDLAJ_CY','E',
                            ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_002), ']美元离岸价['), BJTS_LSF_XX_MYLAJ_SB_002), ']超过电子信息中['), BJTS_LSF_XX_MYLAJ_002), ']合理范围，需提供《出口货物离岸价差异原因说明表》！'),'N',CURRENT_TIMESTAMP
;
              COMMIT;
            END IF;
            -- 20211213，对红字冲减、红字冲减退运业务，不判断已经标注“不予退税”
            IF (BJTS_LSF_XX_BYTSBZ_002='Y') THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_DLZM_BYTS','E',
                          ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_002), ']已被标注为“不予退税”！'),'N',CURRENT_TIMESTAMP
;
              COMMIT;
            END IF;
          END;
        END IF;

        IF (BJTS_LSF_XX_CKRQ_SB_002<>BJTS_LSF_XX_CKRQ_SH_002) AND (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'BSQ')=0) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_DLZM_CKRQ','E',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_002), ']出口日期['), DATE_FORMAT(BJTS_LSF_XX_CKRQ_SB_002, '%Y-%m-%d')), ']与电子信息中['), DATE_FORMAT(BJTS_LSF_XX_CKRQ_SH_002, '%Y-%m-%d')), ']不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        SET LN_CMCD_LEN = CASE WHEN LENGTH(BJTS_LSF_XX_CKSP_DM_SB_002) > LENGTH(BJTS_LSF_XX_CKSP_DM_SH_002) THEN LENGTH(BJTS_LSF_XX_CKSP_DM_SH_002) ELSE LENGTH(BJTS_LSF_XX_CKSP_DM_SB_002) END;
        IF SUBSTR(BJTS_LSF_XX_CKSP_DM_SB_002,1,LN_CMCD_LEN)<>SUBSTR(BJTS_LSF_XX_CKSP_DM_SH_002,1,LN_CMCD_LEN) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_DLZM_SPDM','E',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_002), ']商品代码['), BJTS_LSF_XX_CKSP_DM_SB_002), ']与电子信息中['), BJTS_LSF_XX_CKSP_DM_SH_002), ']不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (TRIM(BJTS_LSF_XX_JGFS_DM_002) IS NULL) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_DLZM_MYXZ_BCZ','E',
                      ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_002), ']在电子信息中监管方式不存在！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        ELSEIF (TRIM(BJTS_LSF_XX_JGFSTSLX_DM_002)='0') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_DLZM_MYXZ_BTS','E',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_002), ']在电子信息中监管方式['), BJTS_LSF_XX_JGFS_DM_002), ']不退税！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'DWCB')>0 AND BJTS_LSF_XX_JGFS_DM_002<>'3422' AND BJTS_LSF_XX_JGFS_DM_002<>'22') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_DLZM_DWCB_NOT','E',
                      ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_002), ']非对外承包业务，“业务类型”不应包含“DWCB”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'DWCB')=0 AND (BJTS_LSF_XX_JGFS_DM_002='3422' OR BJTS_LSF_XX_JGFS_DM_002='22')) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_DLZM_DWCB_NULL','E',
                      ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_002), ']为对外承包业务，“业务类型”应包含“DWCB”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'BSQ')>0) THEN
          IF (BJTS_LSF_XX_YSFS_DM_002<>'0') THEN
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                        'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_DLZM_BSQ_NOT','E',
                        ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_002), ']非经保税区出口业务，“业务类型”不应包含“BSQ”！'),'N',CURRENT_TIMESTAMP
;
            COMMIT;
          ELSE
            BEGIN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_DLZM_BSQ_BAQD','I',
                          ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_002), ']业务类型包含保税区BSQ，请核实是否附送《出境货物备案清单》！'),'Y',CURRENT_TIMESTAMP
;
              COMMIT;
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_DLZM_BSQ_BANR','I',
                          ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_002), ']业务类型包含保税区BSQ，请核实出境货物备案清单的内容是否与报关单相关内容相符,出口日期填报是否准确！'),'Y',CURRENT_TIMESTAMP
;
              COMMIT;
            END;
          END IF;
        END IF;
        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'BSQ')=0 AND BJTS_LSF_XX_YSFS_DM_002='0') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_DLZM_BSQ_NULL','E',
                      ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_002), ']为经保税区出口业务，“业务类型”应包含“BSQ”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'JWTZ')>0 AND BJTS_LSF_XX_JGFS_DM_002<>'2210') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_DLZM_JWTZ_NOT','E',
                      ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_002), ']非境外投资业务，“业务类型”不应包含“JWTZ”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'JWTZ')=0 AND BJTS_LSF_XX_JGFS_DM_002='2210') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_DLZM_JWTZ_NULL','E',
                      ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_002), ']为境外投资业务，“业务类型”应包含“JWTZ”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'DWYZ')>0 AND BJTS_LSF_XX_JGFS_DM_002<>'3511') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_DLZM_DWYZ_NOT','E',
                      ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_002), ']非对外援助业务，“业务类型”不应包含“DWYZ”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'DWYZ')=0 AND BJTS_LSF_XX_JGFS_DM_002='3511') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_DLZM_DWYZ_NULL','E',
                      ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_002), ']为对外援助业务，“业务类型”应包含“DWYZ”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'XLXP')>0 AND BJTS_LSF_XX_JGFS_DM_002<>'1300') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_DLZM_XLXP_NOT','E',
                      ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_002), ']非修理修配业务，“业务类型”不应包含“XLXP”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'XLXP')=0 AND BJTS_LSF_XX_JGFS_DM_002='1300') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_DLZM_XLXP_NULL','E',
                      ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_002), ']为修理修配业务，“业务类型”应包含“XLXP”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_YSFS_DM_002='8' AND BJTS_LSF_XX_ZZMDGDQSZ_DM_002='142' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_CKHW_DLZM_BSCKZNX','E',
                      ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_002), ']为保税仓库转内销！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        SET LC_YDOBJECT ='进料加工';
        IF BJTS_LSF_XX_JGFS_DM_002 IN ('0615','0715','1200') THEN
          BEGIN
            IF BJTS_LSF_XX_JLJGSZCH_002 IS NULL THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_JLJG_DLZM_NOSCH','E',
                          ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_002), ']在电子信息中监管方式为0615/0715，出口明细未申报进料加工手册号！'),'N',CURRENT_TIMESTAMP
;
              COMMIT;
            END IF;

            IF BJTS_LSF_XX_TZHJHFPL_002 IS NULL THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_JLJG_DLZM_NOFPLV','E',
                          ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_002), ']在电子信息中监管方式为0615/0715，出口明细未申报计划分配率！'),'N',CURRENT_TIMESTAMP
;
              COMMIT;
            ELSE
              BEGIN
                IF (BJTS_LSF_XX_SJFPL_002 IS NOT NULL) AND (BJTS_LSF_XX_TZHJHFPL_002<>BJTS_LSF_XX_SJFPL_002) THEN
                  INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                       SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                              'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_JLJG_SJFPLV_YHX','E',
                              '该手（账）册号已完成核销，请按照对应的实际分配率修改后后重新申报！','N',CURRENT_TIMESTAMP
;
                  COMMIT;
                END IF;
                IF (BJTS_LSF_XX_SJFPL_002 IS NULL) AND (BJTS_LSF_XX_TZHJHFPL_002<>LN_ZHJHFPL) THEN
                  INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                       SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                              'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_JLJG_SJFPLV_WHX','E',
                              '申报的进料加工计划分配率与当前有效的计划分配率不一致，请反馈计划分配率后重新申报！','N',CURRENT_TIMESTAMP
;
                  COMMIT;
                END IF;
              END;
            END IF;
          END;
        ELSE
          -- 20211214，针对企业导入的数据，有可能手册号为空但是存在分配率的，增加分配率的判断
          IF (BJTS_LSF_XX_JLJGSZCH_002 IS NOT NULL) OR (IFNULL(BJTS_LSF_XX_TZHJHFPL_002, 0)<>0) THEN
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                        'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'MDT_JLJG_SCH_NOJLJG','I',
                        ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_002), ']申报了手册号（或计划分配率），电子信息中监管方式非0615/0715，请确认！'),'Y',CURRENT_TIMESTAMP
;
            COMMIT;
          END IF;
        END IF;
      END;

  END LOOP BJTS_CURSOR_LOOP_002;
  CLOSE BJTS_CURSOR_002;
END;
  END;

  BEGIN
    SET LC_YDOBJECT ='代理证明';
    BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_DLCKHWZMHM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_SBXH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSL_SB_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSL_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TSSBSL_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TYSL_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_SYSL_SH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_MYLAJ_SB_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_MYLAJ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TSSBMYLAJ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TYMYLAJ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_MYLAJ_SH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_RMBLAJ_SB_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_RMBLAJ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TSSBRMBLAJ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TYRMBLAJ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_RMBLAJ_SH_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT A.DLCKHWZMHM,
                          A.SBXH,
                          A.CKSL_SB,
                          B.CKSL,
                          IFNULL(B.TSSBSL, 0) AS TSSBSL,
                          IFNULL(B.TYSL, 0) AS TYSL,
                          B.CKSL-IFNULL(B.TSSBSL, 0)-IFNULL(B.TYSL, 0) AS SYSL_SH,
                          A.MYLAJ_SB,
                          B.MYLAJ,
                          IFNULL(B.TSSBMYLAJ, 0) AS TSSBMYLAJ,
                          IFNULL(B.TYMYLAJ, 0) AS TYMYLAJ,
                          B.MYLAJ-IFNULL(B.TSSBMYLAJ, 0)-IFNULL(B.TYMYLAJ, 0) AS MYLAJ_SH,
                          A.RMBLAJ_SB,
                          B.RMBLAJ,
                          IFNULL(B.TSSBRMBLAJ, 0) AS TSSBRMBLAJ,
                          IFNULL(B.TYRMBLAJ, 0) AS TYRMBLAJ,
                          B.RMBLAJ-IFNULL(B.TSSBRMBLAJ, 0)-IFNULL(B.TYRMBLAJ, 0) AS RMBLAJ_SH
                     FROM (SELECT A.DLCKHWZMHM, MIN(A.SBXH) AS SBXH, SUM(A.CKSL) AS CKSL_SB, SUM(A.MYLAJ) AS MYLAJ_SB, SUM(A.RMBLAJ) AS RMBLAJ_SB
                             FROM CKTS_SB_MDT_TSSB_LSB A
                            WHERE A.SBID=V_IN_SBID
                              AND A.DLCKHWZMHM IS NOT NULL
                              AND FUNC_XXBD_CHECK_YWLX(ORA_CONCAT(ORA_CONCAT(',', A.CKTMSYWLXDMJH), ',')) = 0
                            GROUP BY A.DLCKHWZMHM) A
                    INNER JOIN CKTS_WBSJ_ZJ_DLCKHWZM B ON B.DJXH=V_IN_DJXH AND B.DLCKHWZMHM=A.DLCKHWZMHM;
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_LSF_XX_DLCKHWZMHM_001, BJTS_LSF_XX_SBXH_001, BJTS_LSF_XX_CKSL_SB_001, BJTS_LSF_XX_CKSL_001, BJTS_LSF_XX_TSSBSL_001, BJTS_LSF_XX_TYSL_001, BJTS_LSF_XX_SYSL_SH_001, BJTS_LSF_XX_MYLAJ_SB_001, BJTS_LSF_XX_MYLAJ_001, BJTS_LSF_XX_TSSBMYLAJ_001, BJTS_LSF_XX_TYMYLAJ_001, BJTS_LSF_XX_MYLAJ_SH_001, BJTS_LSF_XX_RMBLAJ_SB_001, BJTS_LSF_XX_RMBLAJ_001, BJTS_LSF_XX_TSSBRMBLAJ_001, BJTS_LSF_XX_TYRMBLAJ_001, BJTS_LSF_XX_RMBLAJ_SH_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
      BEGIN
        IF (BJTS_LSF_XX_CKSL_SB_001 > 0) AND (BJTS_LSF_XX_CKSL_SB_001 - BJTS_LSF_XX_SYSL_SH_001 > 0) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'MDT_CKHW_DLZM_CKSL','E',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_001), ']申报退税数量['), BJTS_LSF_XX_CKSL_SB_001), ']超过电子信息中剩余数量['), BJTS_LSF_XX_SYSL_SH_001), ']（其中出口['), BJTS_LSF_XX_CKSL_001), ']退税申报['), BJTS_LSF_XX_TSSBSL_001), ']退运['), BJTS_LSF_XX_TYSL_001), ']）！'),'Y',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (BJTS_LSF_XX_MYLAJ_SB_001>0) AND (BJTS_LSF_XX_MYLAJ_SB_001 - BJTS_LSF_XX_MYLAJ_SH_001 > 1) AND (BJTS_LSF_XX_MYLAJ_001 > BJTS_LSF_XX_MYLAJ_SH_001) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'MDT_CKHW_DLZM_USDLAJ','I',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_001), ']申报美元离岸价['), BJTS_LSF_XX_MYLAJ_SB_001), ']超过电子信息中剩余美元离岸价['), BJTS_LSF_XX_MYLAJ_SH_001), ']（其中出口['), BJTS_LSF_XX_MYLAJ_001), ']退税申报['), BJTS_LSF_XX_TSSBMYLAJ_001), ']退运['), BJTS_LSF_XX_TYMYLAJ_001), ']）！'),'Y',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (BJTS_LSF_XX_RMBLAJ_SB_001>0) AND (BJTS_LSF_XX_RMBLAJ_SB_001 - BJTS_LSF_XX_RMBLAJ_SH_001 > 1) AND (BJTS_LSF_XX_RMBLAJ_001 > BJTS_LSF_XX_RMBLAJ_SH_001) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'MDT_CKHW_DLZM_RMBLAJ','I',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_001), ']申报人民币离岸价['), BJTS_LSF_XX_RMBLAJ_SB_001), ']超过电子信息中剩余人民币离岸价['), BJTS_LSF_XX_RMBLAJ_SH_001), ']（其中出口['), BJTS_LSF_XX_RMBLAJ_001), ']退税申报['), BJTS_LSF_XX_TSSBRMBLAJ_001), ']退运['), BJTS_LSF_XX_TYRMBLAJ_001), ']）！'),'Y',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
      END;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MDT_TSSB_DLZM.sql

-- ======================================================================
-- [057/114] BEGIN SOURCE: PROC_XXBD_MDT_XTHH.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MDT_XTHH$$

CREATE PROCEDURE PROC_XXBD_MDT_XTHH
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（生产企业免抵退税）
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LC_ZTXTHHBZ     VARCHAR(20);

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 先退后核明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_MDT_XTHH_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;
  SET LC_YDOBJECT ='先退后核';

  BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
      SET LC_ZTXTHHBZ ='N';

  END;
SELECT T.ZTXTHHBZ
      INTO LC_ZTXTHHBZ
      FROM GS_DJ_CKTMSDAB T
     WHERE T.NSRDZDAH=V_IN_NSRDZDAH;
  END;
  IF LC_ZTXTHHBZ='Y' THEN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_XTHH_LSB','GS_DJ_CKTMSDAB',NULL,T.SBXH,NULL,'MDT_XTHH_ZGBA','E','企业已被暂停先退税后核销业务！','N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_XTHH_LSB T
          WHERE T.SBID=V_IN_SBID;
    COMMIT;
  ELSE
    BEGIN
      INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
           SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                  'CKTS_SB_MDT_XTHH_LSB','CKTS_SB_MDT_XTHHZG_JGB',NULL,T.SBXH,NULL,'MDT_XTHH_HTBA','E',ORA_CONCAT(ORA_CONCAT('申报先退税后核销合同号[', T.CKHTH), ']未备案！'),'N',CURRENT_TIMESTAMP
             FROM CKTS_SB_MDT_XTHH_LSB T
            WHERE T.SBID=V_IN_SBID
              AND NOT EXISTS (SELECT 1 FROM CKTS_JGB_BA_XTHHZG S WHERE S.DJXH=V_IN_DJXH AND S.CKHTH=T.CKHTH);
      COMMIT;
      INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
           SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                  'CKTS_SB_MDT_XTHH_LSB','CKTS_SB_MDT_XTHHZG_JGB',NULL,T.SBXH,NULL,'MDT_XTHH_HTZF','E',ORA_CONCAT(ORA_CONCAT('申报先退税后核销合同号[', T.CKHTH), ']的资格申请已作废！'),'N',CURRENT_TIMESTAMP
             FROM CKTS_SB_MDT_XTHH_LSB T
            WHERE T.SBID=V_IN_SBID
              AND EXISTS (SELECT 1 FROM CKTS_JGB_BA_XTHHZG S WHERE S.DJXH=V_IN_DJXH AND S.CKHTH=T.CKHTH AND S.ZFBZ_1='Y')
              AND NOT EXISTS (SELECT 1 FROM CKTS_JGB_BA_XTHHZG S WHERE S.DJXH=V_IN_DJXH AND S.CKHTH=T.CKHTH AND S.ZFBZ_1='N');
      COMMIT;

      INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
           SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                  'CKTS_SB_MDT_XTHH_LSB','CKTS_SB_MDT_TSSB_LSB',NULL,T.SBXH,NULL,'MDT_BJGX_XTHH_CKHW_HTH','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('先退后核附表中合同号[', T.CKHTH), ']出口货物报关单号['), T.CKBGDH), ']未申报免退税出口明细！'),'N',CURRENT_TIMESTAMP
             FROM CKTS_SB_MDT_XTHH_LSB T
            WHERE T.SBID=V_IN_SBID
              AND NOT EXISTS (SELECT 1 FROM CKTS_SB_MDT_TSSB_LSB S WHERE S.SBID=T.SBID AND S.CKHTH=T.CKHTH AND S.CKBGDH=T.CKBGDH);
      COMMIT;
    END;
  END IF;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MDT_XTHH.sql

-- ======================================================================
-- [058/114] BEGIN SOURCE: PROC_XXBD_MDT_YFSJ.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MDT_YFSJ$$

CREATE PROCEDURE PROC_XXBD_MDT_YFSJ
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（生产企业免抵退税）
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  IN V_IN_YFSJFW VARCHAR(4000), /*出口企业备案研发设计类应税服务类型代码*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LC_MSG          VARCHAR(200) DEFAULT ' ';

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 研发设计明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_MDT_YFSJ_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;
  SET LC_YDOBJECT ='应税服务';

  BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_YFSJFWDM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_YFSJFWJC_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_YFSJFWMC_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT YFSJFWDM, YFSJFWJC, YFSJFWMC FROM CKTS_DM_YFSJFW A WHERE A.YXBZ='Y';
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_LSF_XX_YFSJFWDM_001, BJTS_LSF_XX_YFSJFWJC_001, BJTS_LSF_XX_YFSJFWMC_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
    BEGIN
      SELECT COUNT(1)
        INTO LN_MXROW
        FROM CKTS_SB_MDT_YFSJ_LSB T
       WHERE T.SBID=V_IN_SBID AND T.CKTMSYWLXDMJH LIKE ORA_CONCAT(ORA_CONCAT('%', BJTS_LSF_XX_YFSJFWJC_001), '%');
      IF LN_MXROW>0 AND INSTR(V_IN_YFSJFW,BJTS_LSF_XX_YFSJFWDM_001)=0 THEN
        SET LC_MSG =ORA_CONCAT(ORA_CONCAT(LC_MSG, BJTS_LSF_XX_YFSJFWMC_001), ',');
      END IF;
    END;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;
  IF LC_MSG<>' ' OR TRIM(LC_MSG) IS NOT NULL THEN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
     SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
            'CKTS_SB_MDT_YFSJ_LSB',NULL,NULL,NULL,NULL,'MDT_BJGX_YSFW_SPDM','E',ORA_CONCAT(ORA_CONCAT('不允许申报未备案的应税服务[', LC_MSG), ']。'),'N',CURRENT_TIMESTAMP
;
    COMMIT;
  END IF;

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_YFSJ_LSB','CKTS_SB_MDT_SYYK_LSB',NULL,T.SBXH,NULL,'MDT_BJGX_YSFW_FWSQ_HTH','E',ORA_CONCAT(ORA_CONCAT('此合同号[', T.HTH), ']在零税率应税服务收讫明细中不存在！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_YFSJ_LSB T
          WHERE T.SBID=V_IN_SBID
            AND NOT EXISTS (SELECT 1
                              FROM CKTS_SB_MDT_SYYK_LSB S
                             WHERE S.SBID=V_IN_SBID
                               AND S.HTH=T.HTH);
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_YFSJ_LSB',NULL,NULL,T.SBXH,NULL,'MDT_YSFW_CKRQ_NSRZG','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.KPRQ, '%Y-%m-%d')), ']企业非增值税一般纳税人！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_YFSJ_LSB T
           LEFT JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='YBNSRRD' AND S.FLAG='1' AND T.KPRQ BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID
            AND S.KZLX IS NULL;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_YFSJ_LSB',NULL,NULL,T.SBXH,NULL,'MDT_YSFW_CKRQ_TQQY','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.KPRQ, '%Y-%m-%d')), ']企业处于出口退税停权期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_YFSJ_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='TQQY' AND S.FLAG='1' AND T.KPRQ BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_YFSJ_LSB',NULL,NULL,T.SBXH,NULL,'MDT_YSFW_CKRQ_MSQY','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.KPRQ, '%Y-%m-%d')), ']企业处于免税期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_YFSJ_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='TSGMS' AND S.FLAG='1' AND T.KPRQ BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_YFSJ_LSB',NULL,NULL,T.SBXH,NULL,'MDT_YSFW_CKRQ_FQTS','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.KPRQ, '%Y-%m-%d')), ']放弃零税率应税服务退税期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_YFSJ_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='FQLSL' AND S.FLAG='1' AND T.KPRQ BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MDT_YFSJ.sql

-- ======================================================================
-- [059/114] BEGIN SOURCE: PROC_XXBD_MDT_YFSJ_SYYK.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MDT_YFSJ_SYYK$$

CREATE PROCEDURE PROC_XXBD_MDT_YFSJ_SYYK
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（生产企业免抵退税）
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 收营业款明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_MDT_SYYK_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;
  SET LC_YDOBJECT ='服务收讫';

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_SYYK_LSB','CKTS_SB_MDT_YFSJ_LSB',NULL,T.SBXH,NULL,'MDT_BJGX_FWSQ_YSFW_HTH','E',ORA_CONCAT(ORA_CONCAT('此合同号[', T.HTH), ']在零税率应税服务申报明细中不存在！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_SYYK_LSB T
          WHERE T.SBID=V_IN_SBID
            AND NOT EXISTS (SELECT 1
                              FROM CKTS_SB_MDT_YFSJ_LSB S
                             WHERE S.SBID=V_IN_SBID
                               AND S.HTH=T.HTH);
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_SYYK_LSB','CKTS_SB_MDT_YFSJ_LSB',NULL,T.SBXH,NULL,'MDT_BJGX_FWSQ_YSFW_SKRMB','E',ORA_CONCAT(ORA_CONCAT('此合同号[', T.HTH), ']当期收款金额（折人民币）合计与应税服务申报明细表应税服务营业额折人民币不一致！！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_YFSJ_LSB T
          INNER JOIN (SELECT S.HTH, SUM(S.SKJERMB) AS SKJERMBHJ
                        FROM CKTS_SB_MDT_SYYK_LSB S
                       WHERE S.SBID=V_IN_SBID
                       GROUP BY S.HTH) SS ON SS.HTH=T.HTH
          WHERE T.SBID=V_IN_SBID
            AND T.BQQRYSFWYYSRRMBJE<>SS.SKJERMBHJ;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_SYYK_LSB','CKTS_SB_MDT_YFSJ_LSB',NULL,T.SBXH,NULL,'MDT_BJGX_FWSQ_YSFW_SKUSD','E',ORA_CONCAT(ORA_CONCAT('此合同号[', T.HTH), ']当期收款金额（折美元）合计与应税服务申报明细表应税服务营业额折美元不一致！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_YFSJ_LSB T
          INNER JOIN (SELECT S.HTH, SUM(S.SKJEMY) AS SKJEMYHJ
                        FROM CKTS_SB_MDT_SYYK_LSB S
                       WHERE S.SBID=V_IN_SBID
                       GROUP BY S.HTH) SS ON SS.HTH=T.HTH
          WHERE T.SBID=V_IN_SBID
            AND T.BQSKJEMY<>SS.SKJEMYHJ;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_SYYK_LSB','CKTS_SB_MDT_YFSJ_LSB',NULL,T.SBXH,NULL,'MDT_BJGX_FWSQ_YSFW_DFDWMC','E',ORA_CONCAT(ORA_CONCAT('此合同号[', T.HTH), ']与零税率应税服务申报明细中同一合同号的境外单位名称不符！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_SYYK_LSB T
          INNER JOIN CKTS_SB_MDT_YFSJ_LSB S ON S.SBID=V_IN_SBID AND S.HTH=T.HTH
          WHERE T.SBID=V_IN_SBID
            AND T.FKDWMC <> S.JWDWMC;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MDT_SYYK_LSB','CKTS_SB_MDT_YFSJ_LSB',NULL,T.SBXH,NULL,'MDT_BJGX_FWSQ_YSFW_DFDWGJ','E',ORA_CONCAT(ORA_CONCAT('此合同号[', T.HTH), ']与零税率应税服务申报明细中同一合同号的境外单位所在国家不符！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MDT_SYYK_LSB T
          INNER JOIN CKTS_SB_MDT_YFSJ_LSB S ON S.SBID=V_IN_SBID AND S.HTH=T.HTH
          WHERE T.SBID=V_IN_SBID
            AND T.GJHDQSZ_DM <> S.GJHDQSZ_DM;
    COMMIT;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MDT_YFSJ_SYYK.sql

-- ======================================================================
-- [060/114] BEGIN SOURCE: PROC_XXBD_MSZM_LLJG.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MSZM_LLJG$$

CREATE PROCEDURE PROC_XXBD_MSZM_LLJG
/*
  编制人:严国平
  编制日期:202010
  功能:信息比对（来料加工免税证明）
  调整日期：20210526，1、增加疑点MSZM_LLZM_LLJGSZCH_NULL,未找到对应的来料加工手账册电子信息，请检查是否输入正确。
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE BJTS_ROUTINE_EXIT BOOLEAN DEFAULT FALSE;
  DECLARE LDT_TODAY    DATETIME;

  DECLARE LC_QYHGDM       VARCHAR(20);
  DECLARE LC_QYLXDM       VARCHAR(20);
  DECLARE LC_TSJSFSDM     VARCHAR(20);
  DECLARE LC_WMZHFWQYBZ   VARCHAR(20);
  DECLARE LC_SFYSFW       VARCHAR(20);
  DECLARE LC_YSFW         VARCHAR(50);
  DECLARE LC_YSFS         VARCHAR(50);
  DECLARE LC_YFSJ         VARCHAR(50);
  DECLARE LC_ZXFLAG       VARCHAR(20);

  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LN_ROWNUM_TSSB  BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  IF V_IN_SSSQ>DATE_FORMAT(CURRENT_TIMESTAMP, '%Y%m') THEN
    BEGIN
      SET V_OUT_STATUS ='05';
      SET V_OUT_MESSAGE ='申报所属时期超出合理范围！';
      LEAVE routine_body;
    END;
  END IF;

  -- 取各申报明细表数据记录
  BEGIN
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='06';
      SET V_OUT_MESSAGE ='查询申报记录数据失败！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT COUNT(1)
      INTO LN_ROWNUM_TSSB
      FROM CKTS_ZM_LLJG_LSB
     WHERE SBID=V_IN_SBID;
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LN_ROWNUM_TSSB=0 THEN
    BEGIN
      SET V_OUT_STATUS ='07';
      SET V_OUT_MESSAGE ='申报数据为空！';
      LEAVE routine_body;
    END;
  END IF;

  -- 查询企业基本信息
  BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='08';
      SET V_OUT_MESSAGE ='企业当前未进行出口退（免）税备案，不允许申报除出口退（免）税备案以外的其他业务！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT T.QYHGDM, T.QYLX_DM, T.TSJSFS_DM, T.WMZHFWQYBZ, T.SFYSFW, T.YSFW, T.YSFS, T.YFSJ, T.ZX_FLAG
      INTO LC_QYHGDM, LC_QYLXDM, LC_TSJSFSDM, LC_WMZHFWQYBZ, LC_SFYSFW, LC_YSFW, LC_YSFS, LC_YFSJ, LC_ZXFLAG
      FROM GS_DJ_CKTMSDAB T
     WHERE T.NSRDZDAH=V_IN_NSRDZDAH;
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LC_ZXFLAG='R' THEN
    BEGIN
      SET V_OUT_STATUS ='09';
      SET V_OUT_MESSAGE ='企业当前已出口退（免）税备案撤回，不允许申报除出口退（免）税备案以外的其他业务！';
      LEAVE routine_body;
    END;
  END IF;

  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TQQY',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 THEN
    BEGIN
      SET V_OUT_STATUS ='13';
      SET V_OUT_MESSAGE ='企业当前处于出口退税停权期间，不允许申报出口退（免）税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQMSQ',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_TSSB>0 THEN
    BEGIN
      SET V_OUT_STATUS ='17';
      SET V_OUT_MESSAGE ='企业当前处于放弃免税权期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;

  SET LC_YDOBJECT ='来料加工';
  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_ZM_LLJG_LSB',NULL,NULL,T.SBXH,NULL,'MSZM_LLZM_LLJGSZCH_NULL','W','未找到对应的来料加工手账册电子信息，请检查是否输入正确！','Y',CURRENT_TIMESTAMP
           FROM CKTS_ZM_LLJG_LSB T
          WHERE T.SBID=V_IN_SBID
            AND NOT EXISTS (SELECT 1 FROM CKTS_WBSJ_HG_DZSZCBAXX S WHERE S.DJXH=V_IN_DJXH AND S.BAH=T.LLJGSZCH);
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_ZM_LLJG_LSB',NULL,NULL,T.SBXH,NULL,'MSZM_LLZM_DFDWSH_BYZ','W','来料加工免税证明的加工单位名称与来料加工手册电子信息上的加工单位不一致！','Y',CURRENT_TIMESTAMP
           FROM CKTS_ZM_LLJG_LSB T
          INNER JOIN CKTS_WBSJ_HG_DZSZCBAXX S ON S.DJXH=V_IN_DJXH AND S.BAH=T.LLJGSZCH
          WHERE T.SBID=V_IN_SBID
            AND T.STFMC<>S.JGDWMC;
    COMMIT;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MSZM_LLJG.sql

-- ======================================================================
-- [061/114] BEGIN SOURCE: PROC_XXBD_MSZM_LLJGHX.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MSZM_LLJGHX$$

CREATE PROCEDURE PROC_XXBD_MSZM_LLJGHX
/*
  编制人:严国平
  编制日期:202010
  功能:信息比对（来料加工免税核销）
  调整:20210414，根据金三疑点级别，调整MSZM_LLHX_BGD_WDZXX、MSZM_LLHX_LLJGSZCH_WDZXX、MSZM_LLHX_SL_YKFPHWSL为可挑过疑点
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE BJTS_ROUTINE_EXIT BOOLEAN DEFAULT FALSE;
  DECLARE LDT_TODAY    DATETIME;

  DECLARE LC_QYHGDM       VARCHAR(20);
  DECLARE LC_QYLXDM       VARCHAR(20);
  DECLARE LC_TSJSFSDM     VARCHAR(20);
  DECLARE LC_WMZHFWQYBZ   VARCHAR(20);
  DECLARE LC_SFYSFW       VARCHAR(20);
  DECLARE LC_YSFW         VARCHAR(50);
  DECLARE LC_YSFS         VARCHAR(50);
  DECLARE LC_YFSJ         VARCHAR(50);
  DECLARE LC_ZXFLAG       VARCHAR(20);

  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LN_ROWNUM_TSSB  BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  IF V_IN_SSSQ>DATE_FORMAT(CURRENT_TIMESTAMP, '%Y%m') THEN
    BEGIN
      SET V_OUT_STATUS ='05';
      SET V_OUT_MESSAGE ='申报所属时期超出合理范围！';
      LEAVE routine_body;
    END;
  END IF;

  -- 取各申报明细表数据记录
  BEGIN
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='06';
      SET V_OUT_MESSAGE ='查询申报记录数据失败！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT COUNT(1)
      INTO LN_ROWNUM_TSSB
      FROM CKTS_ZM_LLJGHX_LSB
     WHERE SBID=V_IN_SBID;
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LN_ROWNUM_TSSB=0 THEN
    BEGIN
      SET V_OUT_STATUS ='07';
      SET V_OUT_MESSAGE ='申报数据为空！';
      LEAVE routine_body;
    END;
  END IF;

  -- 查询企业基本信息
  BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='08';
      SET V_OUT_MESSAGE ='企业当前未进行出口退（免）税备案，不允许申报除出口退（免）税备案以外的其他业务！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT T.QYHGDM, T.QYLX_DM, T.TSJSFS_DM, T.WMZHFWQYBZ, T.SFYSFW, T.YSFW, T.YSFS, T.YFSJ, T.ZX_FLAG
      INTO LC_QYHGDM, LC_QYLXDM, LC_TSJSFSDM, LC_WMZHFWQYBZ, LC_SFYSFW, LC_YSFW, LC_YSFS, LC_YFSJ, LC_ZXFLAG
      FROM GS_DJ_CKTMSDAB T
     WHERE T.NSRDZDAH=V_IN_NSRDZDAH;
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LC_ZXFLAG='R' THEN
    BEGIN
      SET V_OUT_STATUS ='09';
      SET V_OUT_MESSAGE ='企业当前已出口退（免）税备案撤回，不允许申报除出口退（免）税备案以外的其他业务！';
      LEAVE routine_body;
    END;
  END IF;

  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TQQY',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 THEN
    BEGIN
      SET V_OUT_STATUS ='13';
      SET V_OUT_MESSAGE ='企业当前处于出口退税停权期间，不允许申报出口退（免）税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQMSQ',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_TSSB>0 THEN
    BEGIN
      SET V_OUT_STATUS ='17';
      SET V_OUT_MESSAGE ='企业当前处于放弃免税权期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;

  SET LC_YDOBJECT ='来料核销';
  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_ZM_LLJGHX_LSB',NULL,NULL,T.SBXH,NULL,'MSZM_LLHX_BGD_WDZXX','W',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), ']无电子信息！'),'Y',CURRENT_TIMESTAMP
           FROM CKTS_ZM_LLJGHX_LSB T
          WHERE T.SBID=V_IN_SBID
            AND NOT EXISTS (SELECT 1 FROM CKTS_WBSJ_HG_BGD201 S WHERE S.DJXH=V_IN_DJXH AND S.CKBGDH=T.CKBGDH);
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_ZM_LLJGHX_LSB',NULL,NULL,T.SBXH,NULL,'MSZM_LLHX_LLJGMSZMBH_WDZXX','E',ORA_CONCAT(ORA_CONCAT('来料加工免税证明号[', T.LLJGMSZMBH), ']无电子信息！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_ZM_LLJGHX_LSB T
          WHERE T.SBID=V_IN_SBID
            AND NOT EXISTS (SELECT 1 FROM CKTS_JGB_ZM_LLJG S WHERE S.DJXH=V_IN_DJXH AND S.LLJGMSZMBH=T.LLJGMSZMBH);
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_ZM_LLJGHX_LSB',NULL,NULL,T.SBXH,NULL,'MSZM_LLHX_LLJGSZCH_WDZXX','W',ORA_CONCAT(ORA_CONCAT('来料登记册号[', T.LLJGSZCH), ']无电子信息！'),'Y',CURRENT_TIMESTAMP
           FROM CKTS_ZM_LLJGHX_LSB T
          WHERE T.SBID=V_IN_SBID
            AND NOT EXISTS (SELECT 1 FROM CKTS_JGB_ZM_LLJG S WHERE S.DJXH=V_IN_DJXH AND S.LLJGSZCH=T.LLJGSZCH);
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
           WITH LLJGMSZM AS (SELECT B.LLJGSZCH AS ZM_SZCH, SUM(B.YKFPHWSL) AS ZM_SL
                               FROM CKTS_JGB_ZM_LLJG B
                              WHERE B.DJXH=V_IN_DJXH
                              GROUP BY B.LLJGSZCH),
                LLJGZMHX AS (SELECT A.LLJGSZCH AS HX_SZCH, SUM(A.SL) AS HX_SL, MIN(A.SBXH) AS SBXH
                               FROM CKTS_ZM_LLJGHX_LSB A
                              WHERE A.SBID=V_IN_SBID
                              GROUP BY A.LLJGSZCH)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_ZM_LLJGHX_LSB',NULL,NULL,LLJGZMHX.SBXH,NULL,'MSZM_LLHX_SL_YKFPHWSL','W',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('来料登记册号[', LLJGZMHX.HX_SZCH), ']的核销数量['), LLJGZMHX.HX_SL), ']小于来料加工免税证明发票开具数量['), LLJGMSZM.ZM_SL), ']！'),'Y',CURRENT_TIMESTAMP
           FROM LLJGZMHX
          INNER JOIN LLJGMSZM ON LLJGMSZM.ZM_SZCH=LLJGZMHX.HX_SZCH
          WHERE LLJGMSZM.ZM_SL>LLJGZMHX.HX_SL;
    COMMIT;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MSZM_LLJGHX.sql

-- ======================================================================
-- [062/114] BEGIN SOURCE: PROC_XXBD_MTS.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MTS$$

CREATE PROCEDURE PROC_XXBD_MTS
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（外贸企业免退税）
  调整日期：20201111，增加关联号下进货、出口的商品名称、计量单位校验，发票代码号码赋值移到主存储过程中
  调整日期：20210603，1、非四类企业超期申报允许提交收汇信息
  修改日期：20220615，根据2022年9号公告，合并收汇与不能收汇
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE BJTS_ROUTINE_EXIT BOOLEAN DEFAULT FALSE;
  DECLARE LDT_TODAY       DATETIME;

  DECLARE LC_QYHGDM       VARCHAR(20);
  DECLARE LC_QYLXDM       VARCHAR(20);
  DECLARE LC_TSJSFSDM     VARCHAR(20);
  DECLARE LC_WMZHFWQYBZ   VARCHAR(20);
  DECLARE LC_SFYSFW       VARCHAR(20);
  DECLARE LC_YSFW         VARCHAR(50);
  DECLARE LC_YSFS         VARCHAR(50);
  DECLARE LC_YFSJ         VARCHAR(50);
  DECLARE LC_ZXFLAG       VARCHAR(20);

  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LN_TGSHZL       BIGINT;
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LN_ROWNUM_CKMX  BIGINT;
  DECLARE LN_ROWNUM_JHMX  BIGINT;
  DECLARE LN_ROWNUM_LSLV  BIGINT;
  DECLARE LN_ROWNUM_HZCJ  BIGINT;
  DECLARE LN_ROWNUM_CKSH  BIGINT;
  DECLARE LN_ROWNUM_CQSB  BIGINT;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';
  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  IF V_IN_SSSQ>DATE_FORMAT(CURRENT_TIMESTAMP, '%Y%m') THEN
    BEGIN
      SET V_OUT_STATUS ='05';
      SET V_OUT_MESSAGE ='申报所属时期超出合理范围！';
      LEAVE routine_body;
    END;
  END IF;

  -- 取各申报明细表数据记录
  BEGIN
  DECLARE BJTS_SQLCODE_015 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_015 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_015 = MYSQL_ERRNO, BJTS_SQLERRM_015 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='06';
      SET V_OUT_MESSAGE ='查询申报记录数据失败！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT COUNT(1)
      INTO LN_ROWNUM_CKMX
      FROM CKTS_SB_MTS_TSSB_LSB
     WHERE SBID=V_IN_SBID;
    SELECT COUNT(1)
      INTO LN_ROWNUM_JHMX
      FROM CKTS_SB_MTS_TSJH_LSB
     WHERE SBID=V_IN_SBID;
    SELECT COUNT(1)
      INTO LN_ROWNUM_LSLV
      FROM CKTS_SB_MTS_YSFWCK_LSB
     WHERE SBID=V_IN_SBID;
    SELECT COUNT(1)
      INTO LN_ROWNUM_HZCJ
      FROM CKTS_SB_MTS_TZSB_LSB
     WHERE SBID=V_IN_SBID;
    SELECT COUNT(1)
      INTO LN_ROWNUM_CKSH
      FROM CKTS_SB_MTS_CKSH_LSB
     WHERE SBID=V_IN_SBID;
    SELECT COUNT(1)
      INTO LN_ROWNUM_CQSB
      FROM CKTS_SB_MTS_TSSB_LSB
     WHERE SBID=V_IN_SBID
       AND (((STR_TO_DATE(ORA_CONCAT(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y'), '0420'), '%Y%m%d')<DATE(CURRENT_TIMESTAMP)) AND (CKRQ_1<MAKEDATE(YEAR(CURRENT_TIMESTAMP), 1))) OR (CKRQ_1<DATE_ADD(MAKEDATE(YEAR(CURRENT_TIMESTAMP), 1), INTERVAL -12 MONTH)))
       AND FUNC_XXBD_CHECK_NEEDSH(ORA_CONCAT(ORA_CONCAT(',', CKTMSYWLXDMJH), ',')) = 1;
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF (LN_ROWNUM_CKMX + LN_ROWNUM_LSLV + LN_ROWNUM_HZCJ)=0 THEN
    BEGIN
      SET V_OUT_STATUS ='07';
      SET V_OUT_MESSAGE ='申报数据为空！';
      LEAVE routine_body;
    END;
  END IF;

  -- 查询企业基本信息
  BEGIN
  DECLARE BJTS_SQLCODE_014 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_014 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_014 = MYSQL_ERRNO, BJTS_SQLERRM_014 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='08';
      SET V_OUT_MESSAGE ='企业当前未进行出口退（免）税备案，不允许申报除出口退（免）税备案以外的其他业务！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT T.QYHGDM, T.QYLX_DM, T.TSJSFS_DM, T.WMZHFWQYBZ, T.SFYSFW, T.YSFW, T.YSFS, T.YFSJ, T.ZX_FLAG
      INTO LC_QYHGDM, LC_QYLXDM, LC_TSJSFSDM, LC_WMZHFWQYBZ, LC_SFYSFW, LC_YSFW, LC_YSFS, LC_YFSJ, LC_ZXFLAG
      FROM GS_DJ_CKTMSDAB T
     WHERE T.NSRDZDAH=V_IN_NSRDZDAH;
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LC_ZXFLAG='Y' THEN
    BEGIN
      SET V_OUT_STATUS ='09';
      SET V_OUT_MESSAGE ='企业当前已出口退（免）税备案撤回，不允许申报除出口退（免）税备案以外的其他业务！';
      LEAVE routine_body;
    END;
  END IF;

  -- 取企业的FLGLCD信息, TGSHZL信息，判断是否需要申报收汇
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',LDT_TODAY,LC_FLGLCD, LN_CPCODEKZ);
  IF LN_CPCODEKZ=0 THEN
    BEGIN
      SET V_OUT_STATUS ='10';
      SET V_OUT_MESSAGE ='查询出口企业分类管理类型出错！';
      LEAVE routine_body;
    END;
  END IF;

  IF LC_QYLXDM<>'3' OR LC_TSJSFSDM<>'2' THEN
    BEGIN
      SET V_OUT_STATUS ='11';
      SET V_OUT_MESSAGE ='备案信息中企业类型、退免税计算方法与当前申报业务冲突！';
      LEAVE routine_body;
    END;
  END IF;

  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'YBNSRRD',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=0 THEN
    BEGIN
      SET V_OUT_STATUS ='12';
      SET V_OUT_MESSAGE ='企业当前非增值税一般纳税人，不允许申报出口退（免）税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TQQY',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 THEN
    BEGIN
      SET V_OUT_STATUS ='13';
      SET V_OUT_MESSAGE ='企业当前处于出口退税停权期间，不允许申报出口退（免）税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTSSXMS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND (LN_ROWNUM_CKMX + LN_ROWNUM_HZCJ)>0 THEN
    BEGIN
      SET V_OUT_STATUS ='14';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权选择免税期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTSSXZS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND (LN_ROWNUM_CKMX + LN_ROWNUM_HZCJ)>0 THEN
    BEGIN
      SET V_OUT_STATUS ='15';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权选择征税期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTMS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND (LN_ROWNUM_CKMX + LN_ROWNUM_HZCJ)>0 THEN
    BEGIN
      SET V_OUT_STATUS ='16';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;

  IF LN_ROWNUM_LSLV>0 THEN
    BEGIN
      IF LC_SFYSFW='N' THEN
        BEGIN
          SET V_OUT_STATUS ='20';
          SET V_OUT_MESSAGE ='非零税率应税服务提供者，不允许申报零税率应税服务退税！';
          LEAVE routine_body;
        END;
      END IF;
      CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQLSL',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
      IF LN_CPCODEKZ=1 THEN
        BEGIN
          SET V_OUT_STATUS ='22';
          SET V_OUT_MESSAGE ='该企业已放弃零税率应税服务退税，不能申报零税率应税服务退税！';
          LEAVE routine_body;
        END;
      END IF;
    END;
  END IF;

  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TGSHZL',LDT_TODAY,LC_KZXX, LN_TGSHZL);
  IF (LC_FLGLCD='D') AND LN_ROWNUM_CKMX>0 AND LN_ROWNUM_CKSH=0 THEN
    BEGIN
      SET V_OUT_STATUS ='27';
      SET V_OUT_MESSAGE ='出口退（免）税管理类别为四类的企业，申报出口退免税时必须申报收汇情况表！';
      LEAVE routine_body;
    END;
  ELSEIF (LN_TGSHZL>0) AND LN_ROWNUM_CKMX>0 AND LN_ROWNUM_CKSH=0 THEN
    BEGIN
      SET V_OUT_STATUS ='28';
      SET V_OUT_MESSAGE ='被认定为需提供收汇资料的企业，申报出口退免税时必须申报收汇情况表！';
      LEAVE routine_body;
    END;
  ELSEIF (LN_ROWNUM_CQSB>0) AND LN_ROWNUM_CKMX>0 AND LN_ROWNUM_CKSH=0 THEN
    BEGIN
      SET V_OUT_STATUS ='29';
      SET V_OUT_MESSAGE ='超期申报数据，申报出口退免税时必须申报收汇情况表！';
      LEAVE routine_body;
    END;
  END IF;

  -- 初始化增值税发票代码、号码
  BEGIN
    UPDATE CKTS_SB_MTS_TSJH_LSB AS T
       SET FPDM=SUBSTR(T.JHPZH,1,12),
    FPHM=SUBSTR(T.JHPZH,13,20)
     WHERE T.SBID=V_IN_SBID AND T.CKTMSPZLX_DM='02' AND LENGTH(T.JHPZH)=20;
    COMMIT;
    UPDATE CKTS_SB_MTS_TSJH_LSB AS T
       SET FPDM=SUBSTR(T.JHPZH,1,10),
    FPHM=SUBSTR(T.JHPZH,11,18)
     WHERE T.SBID=V_IN_SBID AND T.CKTMSPZLX_DM='02' AND LENGTH(T.JHPZH)=18;
    COMMIT;
  END;

  BEGIN
  DECLARE BJTS_SQLCODE_013 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_013 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_013 = MYSQL_ERRNO, BJTS_SQLERRM_013 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='51';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('退税出口明细自检出错：', BJTS_SQLCODE_013), ' - '), BJTS_SQLERRM_013);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_MTS_TSSB(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_012 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_012 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_012 = MYSQL_ERRNO, BJTS_SQLERRM_012 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='52';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口报关单自检出错：', BJTS_SQLCODE_012), ' - '), BJTS_SQLERRM_012);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_MTS_TSSB_BGD(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_011 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_011 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_011 = MYSQL_ERRNO, BJTS_SQLERRM_011 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='53';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口证明自检出错：', BJTS_SQLCODE_011), ' - '), BJTS_SQLERRM_011);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_MTS_TSSB_DLZM(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_010 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_010 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_010 = MYSQL_ERRNO, BJTS_SQLERRM_010 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='62';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口收汇情况表自检出错：', BJTS_SQLCODE_010), ' - '), BJTS_SQLERRM_010);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_MTS_CKSH(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_009 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_009 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_009 = MYSQL_ERRNO, BJTS_SQLERRM_009 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='63';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('海关商品代码调整表自检出错：', BJTS_SQLCODE_009), ' - '), BJTS_SQLERRM_009);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_MTS_HGSPTZ(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_008 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_008 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_008 = MYSQL_ERRNO, BJTS_SQLERRM_008 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='71';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('退税进货明细自检出错：', BJTS_SQLCODE_008), ' - '), BJTS_SQLERRM_008);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_MTS_TSJH(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_007 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_007 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_007 = MYSQL_ERRNO, BJTS_SQLERRM_007 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='72';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('增值税专用发票自检出错：', BJTS_SQLCODE_007), ' - '), BJTS_SQLERRM_007);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_MTS_TSJH_ZZSFP(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_006 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_006 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_006 = MYSQL_ERRNO, BJTS_SQLERRM_006 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='73';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('海关进口增值税缴款书自检出错：', BJTS_SQLCODE_006), ' - '), BJTS_SQLERRM_006);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_MTS_TSJH_JKZZS(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_005 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_005 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_005 = MYSQL_ERRNO, BJTS_SQLERRM_005 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='74';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('海关进口消费税税缴款书自检出错：', BJTS_SQLCODE_005), ' - '), BJTS_SQLERRM_005);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_MTS_TSJH_JKXFS(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_004 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_004 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_004 = MYSQL_ERRNO, BJTS_SQLERRM_004 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='75';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('总局税收缴款书自检出错：', BJTS_SQLCODE_004), ' - '), BJTS_SQLERRM_004);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_MTS_TSJH_ZJJKS(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_003 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_003 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_003 = MYSQL_ERRNO, BJTS_SQLERRM_003 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='81';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('外购服务出口明细自检出错：', BJTS_SQLCODE_003), ' - '), BJTS_SQLERRM_003);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_MTS_LSLV(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,LC_YFSJ,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='82';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('外购服务增值税专用发票自检出错：', BJTS_SQLCODE_002), ' - '), BJTS_SQLERRM_002);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_MTS_LSLV_ZZSFP(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='91';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('调整申报自检出错：', BJTS_SQLCODE_001), ' - '), BJTS_SQLERRM_001);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_MTS_HZCJ(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MTS.sql

-- ======================================================================
-- [063/114] BEGIN SOURCE: PROC_XXBD_MTS_BNSH.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MTS_BNSH$$

CREATE PROCEDURE PROC_XXBD_MTS_BNSH
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（外贸企业免退税）
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 不能收汇明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_MTS_BNSH_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;

  BEGIN
    SET LC_YDOBJECT ='不能收汇';

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_BNSH_LSB','CKTS_SB_MTS_TSSB_LSB',NULL,T.SBXH,NULL,'MTS_BJGX_SHZL_CKMX_CKPZ','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', T.CKBGDH), ']未申报免退税出口明细！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_BNSH_LSB T
          WHERE T.SBID=V_IN_SBID
            AND T.CKBGDH IS NOT NULL
            AND NOT EXISTS (SELECT 1 FROM CKTS_SB_MTS_TSSB_LSB S WHERE S.SBID=T.SBID AND IFNULL(S.CKBGDH, S.DLZMH)=T.CKBGDH);
    COMMIT;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MTS_BNSH.sql

-- ======================================================================
-- [064/114] BEGIN SOURCE: PROC_XXBD_MTS_CKSH.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MTS_CKSH$$

CREATE PROCEDURE PROC_XXBD_MTS_CKSH
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（外贸企业免退税）
  修改日期：20220615，根据2022年9号公告，四类企业，需提供银行水单企业收汇情况表必须申报本期出口退税，非上述企业改为提示性疑点
  修改日期：20230207，修改代理证明出口申报收汇表的疑点逻辑和提示
  调整日期：20230313，增加MTS_BJGX_SHZL_CKMX_CJBZ、MTS_BJGX_SHZL_CKMX_CJJE的疑点判断
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LDT_TODAY       DATETIME;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';
  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  -- 收汇明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_MTS_CKSH_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;

  SET LC_YDOBJECT ='出口收汇';
  BEGIN
    CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',LDT_TODAY,LC_FLGLCD, LN_CPCODEKZ);
    CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TGSHZL',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
    IF (LC_FLGLCD='D') OR (LN_CPCODEKZ>0) THEN
      BEGIN
        INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
             SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                    'CKTS_SB_MTS_CKSH_LSB','CKTS_SB_MTS_TSSB_LSB',NULL,T.SBXH,NULL,'MTS_BJGX_SHZL_CKMX_CKPZ','E',
                    ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', IFNULL(T.DLCKHWZMHM, T.CKBGDH)), ']未申报退税！'),'N',CURRENT_TIMESTAMP
               FROM CKTS_SB_MTS_CKSH_LSB T
              WHERE T.SBID=V_IN_SBID
                AND NOT EXISTS (SELECT 1 FROM CKTS_SB_MTS_TSSB_LSB S WHERE S.SBID=T.SBID AND IFNULL(S.DLZMH, S.CKBGDH) = IFNULL(T.DLCKHWZMHM, T.CKBGDH));
        COMMIT;
      END;
    ELSE
      BEGIN
        INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
             SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                    'CKTS_SB_MTS_CKSH_LSB','CKTS_SB_MTS_TSSB_LSB',NULL,T.SBXH,NULL,'MTS_BJGX_SHZL_CKMX_CKPZ','I',
                    ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', IFNULL(T.DLCKHWZMHM, T.CKBGDH)), ']本期未申报退税！'),'Y',CURRENT_TIMESTAMP
               FROM CKTS_SB_MTS_CKSH_LSB T
              WHERE T.SBID=V_IN_SBID
                AND NOT EXISTS (SELECT 1 FROM CKTS_SB_MTS_TSSB_LSB S WHERE S.SBID=T.SBID AND IFNULL(S.DLZMH, S.CKBGDH) = IFNULL(T.DLCKHWZMHM, T.CKBGDH));
        COMMIT;
      END;
    END IF;
    BEGIN
  DECLARE BJTS_CURSOR_DONE_002 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_SBXH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKPZH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CJHBZM_DM_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_HBZL_DM_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKXSERMB_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_MYLAJZRMB_002 LONGTEXT;
  DECLARE BJTS_CURSOR_002 CURSOR FOR
SELECT A.SBXH,
                          A.CKBGDH AS CKPZH,
                          A.CJHBZM_DM,
                          E.HBZL_DM,
                          A.CKXSERMB,
                          ROUND(B.MYLAJ * C.HL_RMB / 100,2) AS MYLAJZRMB
                     FROM CKTS_SB_MTS_CKSH_LSB A
                    INNER JOIN CKTS_SB_MTS_TSSB_LSB B ON B.SBID=A.SBID AND B.CKBGDH = A.CKBGDH
                    INNER JOIN GS_HBZL_HLV C ON C.CODE='USD' AND C.HL_YM=DATE_FORMAT(B.CKRQ_1, '%Y%m')
                    INNER JOIN CKTS_WBSJ_HG_BGD201 D ON D.DJXH=V_IN_DJXH AND D.CKBGDH=A.CKBGDH
                    INNER JOIN DM_HBZL_HG E ON E.HBZL_HG=D.CJHGHBSZ_DM
                    WHERE A.SBID=V_IN_SBID AND A.DLCKHWZMHM IS NULL;
  OPEN BJTS_CURSOR_002;
  BJTS_CURSOR_LOOP_002: LOOP
    SET BJTS_CURSOR_DONE_002 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_002 = TRUE;
      FETCH BJTS_CURSOR_002 INTO BJTS_LSF_XX_SBXH_002, BJTS_LSF_XX_CKPZH_002, BJTS_LSF_XX_CJHBZM_DM_002, BJTS_LSF_XX_HBZL_DM_002, BJTS_LSF_XX_CKXSERMB_002, BJTS_LSF_XX_MYLAJZRMB_002;
    END;
    IF BJTS_CURSOR_DONE_002 THEN
      LEAVE BJTS_CURSOR_LOOP_002;
    END IF;
      BEGIN
        IF BJTS_LSF_XX_CJHBZM_DM_002<>BJTS_LSF_XX_HBZL_DM_002 THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_CKSH_LSB','CKTS_SB_MTS_TSSB_LSB',NULL,BJTS_LSF_XX_SBXH_002,NULL,'MTS_BJGX_SHZL_CKMX_CJBZ','I',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', BJTS_LSF_XX_CKPZH_002), ']的出口退（免）税销售额币种['), BJTS_LSF_XX_CJHBZM_DM_002), ']与电子信息中的币制['), BJTS_LSF_XX_HBZL_DM_002), ']不一致！'),'Y',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
        IF BJTS_LSF_XX_CKXSERMB_002>1.05*BJTS_LSF_XX_MYLAJZRMB_002 OR BJTS_LSF_XX_CKXSERMB_002<0.95*BJTS_LSF_XX_MYLAJZRMB_002 THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_CKSH_LSB','CKTS_SB_MTS_TSSB_LSB',NULL,BJTS_LSF_XX_SBXH_002,NULL,'MTS_BJGX_SHZL_CKMX_CJJE','I',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', BJTS_LSF_XX_CKPZH_002), ']的出口退（免）税销售额折人民币['), BJTS_LSF_XX_CKXSERMB_002), ']与出口明细表中美元离岸价折算的人民币金额['), BJTS_LSF_XX_MYLAJZRMB_002), ']超过合理区间！'),'Y',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
      END;

  END LOOP BJTS_CURSOR_LOOP_002;
  CLOSE BJTS_CURSOR_002;
END;
    BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_SBXH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKPZH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CJHBZM_DM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_HBZL_DM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKXSERMB_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_MYLAJZRMB_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT A.SBXH,
                          A.DLCKHWZMHM AS CKPZH,
                          A.CJHBZM_DM,
                          E.HBZL_DM,
                          A.CKXSERMB,
                          ROUND(B.MYLAJ * C.HL_RMB / 100,2) AS MYLAJZRMB
                     FROM CKTS_SB_MTS_CKSH_LSB A
                    INNER JOIN CKTS_SB_MTS_TSSB_LSB B ON B.SBID=A.SBID AND B.DLZMH = A.DLCKHWZMHM
                    INNER JOIN GS_HBZL_HLV C ON C.CODE='USD' AND C.HL_YM=DATE_FORMAT(B.CKRQ_1, '%Y%m')
                    INNER JOIN CKTS_WBSJ_ZJ_DLCKHWZM D ON D.DJXH=V_IN_DJXH AND D.DLCKHWZMHM=A.DLCKHWZMHM
                    INNER JOIN DM_HBZL_HG E ON E.HBZL_HG=D.CJHGHBSZ_DM
                    WHERE A.SBID=V_IN_SBID AND A.DLCKHWZMHM IS NOT NULL;
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_LSF_XX_SBXH_001, BJTS_LSF_XX_CKPZH_001, BJTS_LSF_XX_CJHBZM_DM_001, BJTS_LSF_XX_HBZL_DM_001, BJTS_LSF_XX_CKXSERMB_001, BJTS_LSF_XX_MYLAJZRMB_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
      BEGIN
        IF BJTS_LSF_XX_CJHBZM_DM_001<>BJTS_LSF_XX_HBZL_DM_001 THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_CKSH_LSB','CKTS_SB_MTS_TSSB_LSB',NULL,BJTS_LSF_XX_SBXH_001,NULL,'MTS_BJGX_SHZL_CKMX_CJBZ','I',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', BJTS_LSF_XX_CKPZH_001), ']的出口退（免）税销售额币种['), BJTS_LSF_XX_CJHBZM_DM_001), ']与电子信息中的币制['), BJTS_LSF_XX_HBZL_DM_001), ']不一致！'),'Y',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
        IF BJTS_LSF_XX_CKXSERMB_001>1.05*BJTS_LSF_XX_MYLAJZRMB_001 OR BJTS_LSF_XX_CKXSERMB_001<0.95*BJTS_LSF_XX_MYLAJZRMB_001 THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_CKSH_LSB','CKTS_SB_MTS_TSSB_LSB',NULL,BJTS_LSF_XX_SBXH_001,NULL,'MTS_BJGX_SHZL_CKMX_CJJE','I',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', BJTS_LSF_XX_CKPZH_001), ']的出口退（免）税销售额折人民币['), BJTS_LSF_XX_CKXSERMB_001), ']与出口明细表中美元离岸价折算的人民币金额['), BJTS_LSF_XX_MYLAJZRMB_001), ']超过合理区间！'),'Y',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
      END;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MTS_CKSH.sql

-- ======================================================================
-- [065/114] BEGIN SOURCE: PROC_XXBD_MTS_HGSPTZ.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MTS_HGSPTZ$$

CREATE PROCEDURE PROC_XXBD_MTS_HGSPTZ
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（外贸企业免退税）
  修改日期：20230207，修改代理证明出口申报调整表的疑点逻辑和提示
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 海关代码调整明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_MTS_HGSPTZ_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;
  SET LC_YDOBJECT ='代码调整';

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_HGSPTZ_LSB','CKTS_SB_MTS_TSSB_LSB',NULL,T.SBXH,NULL,'MTS_BJGX_DMTZ_CKMX_CKPZ','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', IFNULL(T.DLCKHWZMHM, T.CKBGDH)), ']未申报免退税出口明细！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_HGSPTZ_LSB T
          WHERE T.SBID=V_IN_SBID
            AND NOT EXISTS (SELECT 1 FROM CKTS_SB_MTS_TSSB_LSB S WHERE S.SBID=T.SBID AND IFNULL(S.DLZMH, S.CKBGDH)=IFNULL(T.DLCKHWZMHM, T.CKBGDH));
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_HGSPTZ_LSB','CKTS_SB_MTS_TSSB_LSB',NULL,T.SBXH,NULL,'MTS_BJGX_DMTZ_CKMX_CKRQ','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', IFNULL(T.DLCKHWZMHM, T.CKBGDH)), ']的出口日期与免退税出口明细表中不一致！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_HGSPTZ_LSB T
          INNER JOIN CKTS_SB_MTS_TSSB_LSB S ON S.SBID=T.SBID AND IFNULL(S.DLZMH, S.CKBGDH)=IFNULL(T.DLCKHWZMHM, T.CKBGDH)
          WHERE T.SBID=V_IN_SBID
            AND DATE(T.CKRQ_1)<>DATE(S.CKRQ_1);
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_HGSPTZ_LSB','CKTS_SB_MTS_TSSB_LSB',NULL,T.SBXH,NULL,'MTS_BJGX_DMTZ_CKMX_SPDM','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', IFNULL(T.DLCKHWZMHM, T.CKBGDH)), ']调整前商品代码与免退税出口明细表中不一致！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_HGSPTZ_LSB T
          INNER JOIN CKTS_SB_MTS_TSSB_LSB S ON S.SBID=T.SBID AND IFNULL(S.DLZMH, S.CKBGDH)=IFNULL(T.DLCKHWZMHM, T.CKBGDH)
          WHERE T.SBID=V_IN_SBID
            AND T.CKSP_DM<>S.CKSP_DM;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_HGSPTZ_LSB','CKTS_SB_MTS_TSSB_LSB',NULL,T.SBXH,NULL,'MTS_BJGX_DMTZ_CKMX_TSLV','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', IFNULL(T.DLCKHWZMHM, T.CKBGDH)), ']调整后退税率与免退税进货明细表中不一致！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_HGSPTZ_LSB T
          INNER JOIN CKTS_SB_MTS_TSSB_LSB S ON S.SBID=T.SBID AND IFNULL(S.DLZMH, S.CKBGDH)=IFNULL(T.DLCKHWZMHM, T.CKBGDH)
          WHERE T.SBID=V_IN_SBID
            AND T.TZHTSL<>S.TSL;
    COMMIT;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MTS_HGSPTZ.sql

-- ======================================================================
-- [066/114] BEGIN SOURCE: PROC_XXBD_MTS_HZCJ.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MTS_HZCJ$$

CREATE PROCEDURE PROC_XXBD_MTS_HZCJ
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（外贸企业免退税）
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_SQLCODE DECIMAL(38,10) DEFAULT 0;
  DECLARE LC_SQLERRM VARCHAR(8000);

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MTS_HZCJ.sql

-- ======================================================================
-- [067/114] BEGIN SOURCE: PROC_XXBD_MTS_LSLV.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MTS_LSLV$$

CREATE PROCEDURE PROC_XXBD_MTS_LSLV
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（外贸企业免退税）
  调整日期：20211208，1、调整免退税疑点描述字段中申报序号与关联单证号的顺序，使其与客户端疑点展示一致
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  IN V_IN_YFSJFW VARCHAR(4000), /*出口企业备案研发设计类应税服务类型代码*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LC_MSG          VARCHAR(200) DEFAULT ' ';

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 外购服务明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_MTS_YSFWCK_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;
  SET LC_YDOBJECT ='外购服务';

  -- 初始化增值税发票代码、号码，以备后续使用
  BEGIN
    UPDATE CKTS_SB_MTS_YSFWCK_LSB AS T
       SET FPDM=SUBSTR(T.JHPZH,1,12),
    FPHM=SUBSTR(T.JHPZH,13,20)
     WHERE T.SBID=V_IN_SBID AND LENGTH(T.JHPZH)=20;
    COMMIT;
    UPDATE CKTS_SB_MTS_YSFWCK_LSB AS T
       SET FPDM=SUBSTR(T.JHPZH,1,10),
    FPHM=SUBSTR(T.JHPZH,11,18)
     WHERE T.SBID=V_IN_SBID AND LENGTH(T.JHPZH)=18;
    COMMIT;
  END;

  BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_YFSJFWDM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_YFSJFWJC_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_YFSJFWMC_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT YFSJFWDM, YFSJFWJC, YFSJFWMC FROM CKTS_DM_YFSJFW A WHERE A.YXBZ='Y';
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_LSF_XX_YFSJFWDM_001, BJTS_LSF_XX_YFSJFWJC_001, BJTS_LSF_XX_YFSJFWMC_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
    BEGIN
      SELECT COUNT(1)
        INTO LN_MXROW
        FROM CKTS_SB_MTS_YSFWCK_LSB T
       WHERE T.SBID=V_IN_SBID AND T.CKTMSYWLXDMJH LIKE ORA_CONCAT(ORA_CONCAT('%', BJTS_LSF_XX_YFSJFWJC_001), '%');
      IF LN_MXROW>0 AND INSTR(V_IN_YFSJFW,BJTS_LSF_XX_YFSJFWDM_001)=0 THEN
        SET LC_MSG =ORA_CONCAT(ORA_CONCAT(LC_MSG, BJTS_LSF_XX_YFSJFWMC_001), ',');
      END IF;
    END;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;
  IF LC_MSG<>' ' OR TRIM(LC_MSG) IS NOT NULL THEN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
     SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
            'CKTS_SB_MTS_YSFWCK_LSB',NULL,NULL,NULL,NULL,'MTS_BJGX_YSFW_SPDM','E',ORA_CONCAT(ORA_CONCAT('不允许申报未备案的应税服务[', LC_MSG), ']。'),'N',CURRENT_TIMESTAMP
;
    COMMIT;
  END IF;

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_YSFWCK_LSB',NULL,NULL,T.SBXH,NULL,'MTS_YSFW_CKRQ_NSRZG','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.CKRQ_1, '%Y-%m-%d')), ']企业非增值税一般纳税人！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_YSFWCK_LSB T
           LEFT JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='YBNSRRD' AND S.FLAG='1' AND T.CKRQ_1 BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID
            AND S.KZLX IS NULL;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_YSFWCK_LSB',NULL,NULL,T.SBXH,NULL,'MTS_YSFW_CKRQ_TQQY','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.CKRQ_1, '%Y-%m-%d')), ']企业处于出口退税停权期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_YSFWCK_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='TQQY' AND S.FLAG='1' AND T.CKRQ_1 BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_YSFWCK_LSB',NULL,NULL,T.SBXH,NULL,'MTS_YSFW_CKRQ_MSQY','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.CKRQ_1, '%Y-%m-%d')), ']企业处于免税期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_YSFWCK_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='TSGMS' AND S.FLAG='1' AND T.CKRQ_1 BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_YSFWCK_LSB',NULL,NULL,T.SBXH,NULL,'MTS_YSFW_CKRQ_FQTS','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.CKRQ_1, '%Y-%m-%d')), ']放弃零税率应税服务退税期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_YSFWCK_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='FQLSL' AND S.FLAG='1' AND T.CKRQ_1 BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MTS_LSLV.sql

-- ======================================================================
-- [068/114] BEGIN SOURCE: PROC_XXBD_MTS_LSLV_ZZSFP.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MTS_LSLV_ZZSFP$$

CREATE PROCEDURE PROC_XXBD_MTS_LSLV_ZZSFP
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（外贸企业免退税）
  调整日期：20201125，增加疑点MTS_JHMX_ZZSFP_SBJE的描述进行调整，细化企业发票开票数、已申报数据提示
  调整日期：20201230，1、校验发票稽核信息时，剔除代开发票的稽核信息，代开发票开票人税号含DK
  调整日期：20210603，1、调整MTS_YSFW_ZZSFP_SBJE计税金额总量控制误差
  调整日期：20211208，1、调整免退税疑点描述字段中申报序号与关联单证号的顺序，使其与客户端疑点展示一致
  调整日期：20220228，1、增加MTS_YSFW_ZZSFP_SBSE疑点，当发票本次申报总退税额大于发票总开票税额（误差+1）时提醒，不可挑过
  调整日期：20220701，1、根据全电票规则调整发票的关联，用JHPZH代替FPDM+FPHM
  调整日期：20230207，1、修改全电发票关联虚开发票时的BUG。
  调整日期：20230315，调整出口企业首次申报日期取数口径，改为按税务机关+企业+业务代码查询首次发放日期
  调整日期：20230515，解决增值税发票外部数据部分数据稽核相符标志为空的问题（赋默认值N）
  调整日期：20230518，解决按税务机关+企业+业务代码查询首次发放日期有结果但日期为空的问题（赋默认值SYSDATE）
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LDT_TODAY       DATETIME;
  DECLARE LDT_SCSBRQ      DATETIME;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';
  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  -- 外购服务明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_MTS_YSFWCK_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;

  -- 查询企业首次申报日期
  BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
      SET LDT_SCSBRQ =LDT_TODAY;

  END;
SELECT IFNULL(T.FFRQ, CURRENT_TIMESTAMP)
      INTO LDT_SCSBRQ
      FROM CKTS_TY_YWBLXX_SCFFRQ T
     WHERE T.TSSWJG_DM_1=(SELECT SWJG_DM FROM GS_DJ_CKTMSDAB WHERE NSRDZDAH=V_IN_NSRDZDAH)
       AND T.DJXH=V_IN_DJXH AND T.LCSWSX_DM='LCSXA081039001';
  END;

  SET LC_YDOBJECT ='服务进货';
  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_YSFWCK_LSB',NULL,NULL,T.SBXH,NULL,'MTS_YSFW_JHPZH_WDZXX','E',ORA_CONCAT(ORA_CONCAT('进货凭证号[', T.JHPZH), ']无电子信息！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_YSFWCK_LSB T
          WHERE T.SBID=V_IN_SBID
            AND NOT EXISTS (SELECT 1
                              FROM CKTS_WBSJ_FP_ZZSZYFPXX S
                             WHERE S.DJXH=V_IN_DJXH
                               AND S.JHPZH=T.JHPZH);
    COMMIT;
  END;

  BEGIN
    CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',LDT_TODAY,LC_FLGLCD, LN_CPCODEKZ);
    BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_SBXH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_JHPZH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKTMSYWLXDMJH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_JHXFZZSZYFPBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_BYTSBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_GHFNSRSBH_1_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_XFNSRSBH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_KPRQ_SB_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_KPRQ_SH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_FPYT_DM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_FPSJBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_NXZCKBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_GHFNSRSBH_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT A.SBXH,
                          A.JHPZH,
                          IFNULL(A.CKTMSYWLXDMJH, ' ') AS CKTMSYWLXDMJH,
                          IFNULL(B.JHXFZZSZYFPBZ, 'N') AS JHXFZZSZYFPBZ,
                          B.BYTSBZ,
                          A.GHFNSRSBH_1,
                          B.XFNSRSBH,
                          DATE(A.KPRQ) AS KPRQ_SB,
                          DATE(B.KPRQ) AS KPRQ_SH,
                          B.FPYT_DM,
                          IFNULL(B.FPSJBBZ, 'N') AS FPSJBZ,
                          IFNULL(B.NXZCKBZ, 'N') AS NXZCKBZ,
                          C.GHFNSRSBH
                     FROM CKTS_SB_MTS_YSFWCK_LSB A
                    INNER JOIN CKTS_WBSJ_FP_ZZSZYFPXX B ON B.DJXH=V_IN_DJXH AND B.JHPZH=A.JHPZH
                     LEFT JOIN CKTS_WBSJ_ZJ_XKFP C ON ORA_CONCAT(C.FP_DM, C.FPHM)=A.JHPZH
                    WHERE A.SBID=V_IN_SBID;
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_LSF_XX_SBXH_001, BJTS_LSF_XX_JHPZH_001, BJTS_LSF_XX_CKTMSYWLXDMJH_001, BJTS_LSF_XX_JHXFZZSZYFPBZ_001, BJTS_LSF_XX_BYTSBZ_001, BJTS_LSF_XX_GHFNSRSBH_1_001, BJTS_LSF_XX_XFNSRSBH_001, BJTS_LSF_XX_KPRQ_SB_001, BJTS_LSF_XX_KPRQ_SH_001, BJTS_LSF_XX_FPYT_DM_001, BJTS_LSF_XX_FPSJBZ_001, BJTS_LSF_XX_NXZCKBZ_001, BJTS_LSF_XX_GHFNSRSBH_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
      BEGIN
        IF (BJTS_LSF_XX_JHXFZZSZYFPBZ_001='N' AND INSTR(BJTS_LSF_XX_XFNSRSBH_001,'DK')=0 AND (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_001,'RZZL')>0 OR LC_FLGLCD='D' OR (LC_FLGLCD='C' AND TIMESTAMPDIFF(MONTH, LDT_SCSBRQ, LDT_TODAY)<=12))) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_YSFWCK_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'MTS_YSFW_JHPZH_WDZXX','E',ORA_CONCAT(ORA_CONCAT('进货凭证号[', BJTS_LSF_XX_JHPZH_001), ']无稽核相符电子信息！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_BYTSBZ_001='Y' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_YSFWCK_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'MTS_YSFW_JHPZH_BYTS','E',ORA_CONCAT(ORA_CONCAT('进货凭证号[', BJTS_LSF_XX_JHPZH_001), ']已被标注为“不予退税”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_GHFNSRSBH_1_001<>BJTS_LSF_XX_XFNSRSBH_001 THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_YSFWCK_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'MTS_YSFW_JHPZH_GHFNSR','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('进货凭证号[', BJTS_LSF_XX_JHPZH_001), ']供货方纳税人['), BJTS_LSF_XX_GHFNSRSBH_1_001), ']与电子信息中['), BJTS_LSF_XX_XFNSRSBH_001), ']不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_KPRQ_SB_001<>BJTS_LSF_XX_KPRQ_SH_001 THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_YSFWCK_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'MTS_YSFW_JHPZH_KPRQ','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('进货凭证号[', BJTS_LSF_XX_JHPZH_001), ']开票日期['), DATE_FORMAT(BJTS_LSF_XX_KPRQ_SB_001, '%Y-%m-%d')), ']与电子信息中['), DATE_FORMAT(BJTS_LSF_XX_KPRQ_SH_001, '%Y-%m-%d')), ']不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_FPYT_DM_001='3' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_YSFWCK_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'MTS_YSFW_JHPZH_DBTS','E',ORA_CONCAT(ORA_CONCAT('进货凭证号[', BJTS_LSF_XX_JHPZH_001), ']在电子信息中申报用途代码为“3-代办退税”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        ELSEIF (BJTS_LSF_XX_FPYT_DM_001='1' AND BJTS_LSF_XX_FPSJBZ_001='Y' AND BJTS_LSF_XX_NXZCKBZ_001='N') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_YSFWCK_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'MTS_YSFW_JHPZH_YDK','E',ORA_CONCAT(ORA_CONCAT('进货凭证号[', BJTS_LSF_XX_JHPZH_001), ']在电子信息中已勾选用于抵扣！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_GHFNSRSBH_001 IS NOT NULL THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_YSFWCK_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'MTS_YSFW_JHPZH_XKFP','E',ORA_CONCAT(ORA_CONCAT('进货凭证号[', BJTS_LSF_XX_JHPZH_001), ']在电子信息中为虚开进货凭证号！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
      END;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;
  END;

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_YSFWCK_LSB',NULL,NULL,NULL,T.JHPZH,'MTS_YSFW_ZZSFP_SBJE','E',
                ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('增值税专用发票[', T.JHPZH), ']申报退税的计税金额['), T.JSJE), ']超过电子信息中剩余数['), GREATEST(0,S.JE - IFNULL(S.HZCJJE, 0) - IFNULL(S.SBFPJSJE, 0) - IFNULL(S.LSLSBFPJSJE, 0))), ']（其中开票['), S.JE), ']红字冲减['), IFNULL(S.HZCJJE, 0)), ']出口货物劳务已申报['), IFNULL(S.SBFPJSJE, 0)), ']外购应税服务已申报['), IFNULL(S.LSLSBFPJSJE, 0)), ']）！'),'Y',CURRENT_TIMESTAMP
           FROM (SELECT A.JHPZH, SUM(A.JSJE) AS JSJE
                   FROM CKTS_SB_MTS_YSFWCK_LSB A
                  WHERE A.SBID=V_IN_SBID
                  GROUP BY A.JHPZH) T
          INNER JOIN CKTS_WBSJ_FP_ZZSZYFPXX S ON S.DJXH=V_IN_DJXH AND S.JHPZH=T.JHPZH
          WHERE T.JSJE > S.JE - IFNULL(S.HZCJJE, 0) - IFNULL(S.SBFPJSJE, 0) - IFNULL(S.LSLSBFPJSJE, 0);
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_YSFWCK_LSB',NULL,NULL,NULL,T.JHPZH,'MTS_YSFW_ZZSFP_SBSE','E',
                ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('增值税专用发票[', T.JHPZH), ']申报退税额['), T.TSE), ']超过电子信息中税额['), IFNULL(S.SE, 0)), ']！'),'N',CURRENT_TIMESTAMP
           FROM (SELECT A.JHPZH, SUM(A.ZZSTSE) AS TSE
                   FROM CKTS_SB_MTS_YSFWCK_LSB A
                  WHERE A.SBID=V_IN_SBID
                  GROUP BY A.JHPZH) T
          INNER JOIN CKTS_WBSJ_FP_ZZSZYFPXX S ON S.DJXH=V_IN_DJXH AND S.JHPZH=T.JHPZH
          WHERE T.TSE > S.SE + 1;
    COMMIT;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MTS_LSLV_ZZSFP.sql

-- ======================================================================
-- [069/114] BEGIN SOURCE: PROC_XXBD_MTS_TSJH.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MTS_TSJH$$

CREATE PROCEDURE PROC_XXBD_MTS_TSJH
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（外贸企业免退税）
  调整日期：20210603，1、调整疑点关联业务字段，关联号+申报序号
  调整日期：20211208，1、调整免退税疑点描述字段中申报序号与关联单证号的顺序，使其与客户端疑点展示一致
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LDT_TODAY       DATETIME;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 进货明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_MTS_TSJH_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;
  SET LC_YDOBJECT ='进货明细';

  -- 初始化进货明细出口业务类型、出口日期，以备后续使用
  BEGIN
    UPDATE CKTS_SB_MTS_TSJH_LSB AS T
       SET CKTMSYWLXDMJH = (SELECT S.CKTMSYWLXDMJH
FROM CKTS_SB_MTS_TSSB_LSB S
                                        WHERE S.SBID=T.SBID
                                          AND S.GLH=T.GLH
                                          AND 1=1
LIMIT 1),
    CKRQ_1 = (SELECT S.CKRQ_1
FROM CKTS_SB_MTS_TSSB_LSB S
                                        WHERE S.SBID=T.SBID
                                          AND S.GLH=T.GLH
                                          AND 1=1
LIMIT 1)
     WHERE T.SBID=V_IN_SBID;
    COMMIT;
  END;

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_TSJH_LSB','CKTS_SB_MTS_TSSB_LSB',NULL,T.SBXH,T.GLH,'MTS_BJGX_JHMX_CKMX_GLH','E',ORA_CONCAT(ORA_CONCAT('进货明细中的关联号[', T.GLH), ']在出口明细中不存在！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_TSJH_LSB T
          WHERE T.SBID=V_IN_SBID
            AND NOT EXISTS (SELECT 1 FROM CKTS_SB_MTS_TSSB_LSB S WHERE S.SBID=T.SBID AND S.GLH=T.GLH);
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_TSJH_LSB','CKTS_SB_MTS_TSSB_LSB',NULL,T.SBXH,T.GLH,'MTS_BJGX_JHMX_CKMX_SPDM','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('进货明细中的关联号[', T.GLH), ']商品代码['), T.CKSP_DM), ']在出口明细中不存在！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_TSJH_LSB T
          WHERE T.SBID=V_IN_SBID
            AND NOT EXISTS (SELECT 1 FROM CKTS_SB_MTS_TSSB_LSB S WHERE S.SBID=T.SBID AND S.GLH=T.GLH AND S.CKSP_DM=T.CKSP_DM);
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_TSJH_LSB','CKTS_SB_MTS_TSSB_LSB',NULL,T.SBXH,T.GLH,'MTS_BJGX_JHMX_CKMX_JLDW','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('进货明细中的关联号[', T.GLH), ']计量单位['), T.HGJLDWMC), ']在出口明细中不存在！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_TSJH_LSB T
          WHERE T.SBID=V_IN_SBID
            AND NOT EXISTS (SELECT 1 FROM CKTS_SB_MTS_TSSB_LSB S WHERE S.SBID=T.SBID AND S.GLH=T.GLH AND S.HGJLDWMC=T.HGJLDWMC);
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
           WITH CK AS (SELECT T.SBID,T.GLH,T.CKSP_DM,SUM(T.CKSL) AS CKSL FROM CKTS_SB_MTS_TSSB_LSB T WHERE T.SBID=V_IN_SBID GROUP BY T.SBID,T.GLH,T.CKSP_DM),
                JH AS (SELECT S.SBID,S.GLH,S.CKSP_DM,SUM(S.SL) AS JHSL FROM CKTS_SB_MTS_TSJH_LSB S WHERE S.SBID=V_IN_SBID AND S.SZ='V' GROUP BY S.SBID,S.GLH,S.CKSP_DM)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_TSJH_LSB','CKTS_SB_MTS_TSSB_LSB',NULL,NULL,JH.GLH,'MTS_BJGX_JHMX_CKMX_CKSL','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('进货明细中的关联号[', JH.GLH), ']商品代码['), JH.CKSP_DM), ']进货数量['), JH.JHSL), ']大于出口数量['), IFNULL(CK.CKSL, 0.00)), ']！'),'N',CURRENT_TIMESTAMP
           FROM JH
           LEFT JOIN CK ON JH.SBID=CK.SBID AND JH.GLH=CK.GLH AND JH.CKSP_DM=CK.CKSP_DM
          WHERE CK.SBID=V_IN_SBID AND JH.JHSL>IFNULL(CK.CKSL, 0);
    COMMIT;
  END;

END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MTS_TSJH.sql

-- ======================================================================
-- [070/114] BEGIN SOURCE: PROC_XXBD_MTS_TSJH_JKXFS.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MTS_TSJH_JKXFS$$

CREATE PROCEDURE PROC_XXBD_MTS_TSJH_JKXFS
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（外贸企业免退税）
  调整日期：20210603，1、调整疑点关联业务字段，关联号+申报序号
  调整日期：20211019，1、增加MTS_JHMX_JKXFS_GHFNSR疑点判断，海关进口税收凭证填写缴款单位纳税人识别号
  调整日期：20211208，1、调整免退税疑点描述字段中申报序号与关联单证号的顺序，使其与客户端疑点展示一致
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LDT_TODAY       DATETIME;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';
  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  -- 进口消费税缴款书记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_MTS_TSJH_LSB T
     WHERE T.SBID=V_IN_SBID
       AND T.CKTMSPZLX_DM='05';
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;

  SET LC_YDOBJECT ='进口消费税';
  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_TSJH_LSB',NULL,NULL,T.SBXH,T.GLH,'MTS_JHMX_JKXFS_WDZXX','E',ORA_CONCAT(ORA_CONCAT('海关进口消费税缴款书[', T.JHPZH), ']无电子信息！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_TSJH_LSB T
          WHERE T.SBID=V_IN_SBID
            AND T.CKTMSPZLX_DM='05'
            AND NOT EXISTS (SELECT 1
                              FROM CKTS_WBSJ_HG_JKJKS S
                             WHERE S.DJXH=V_IN_DJXH
                               AND S.HGZYJKSHM=T.JHPZH);
    COMMIT;
  END;

  BEGIN
    BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_SBXH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_GLH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_JHPZH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_GHFNSRSBH_1_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_BYTSBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_HGJKJKSCLJG_DM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_NSRSBH_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT A.SBXH,A.GLH,
                          A.JHPZH,
                          A.GHFNSRSBH_1,
                          B.BYTSBZ,
                          B.HGJKJKSCLJG_DM,
                          B.NSRSBH
                     FROM CKTS_SB_MTS_TSJH_LSB A
                    INNER JOIN CKTS_WBSJ_HG_JKJKS B ON B.DJXH=V_IN_DJXH AND B.HGZYJKSHM=A.JHPZH
                    WHERE A.SBID=V_IN_SBID
                      AND A.CKTMSPZLX_DM='05';
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_LSF_XX_SBXH_001, BJTS_LSF_XX_GLH_001, BJTS_LSF_XX_JHPZH_001, BJTS_LSF_XX_GHFNSRSBH_1_001, BJTS_LSF_XX_BYTSBZ_001, BJTS_LSF_XX_HGJKJKSCLJG_DM_001, BJTS_LSF_XX_NSRSBH_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
      BEGIN
        IF BJTS_LSF_XX_BYTSBZ_001='Y' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSJH_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,BJTS_LSF_XX_GLH_001,'MTS_JHMX_JKXFS_BYTS','E',ORA_CONCAT(ORA_CONCAT('海关进口消费税缴款书[', BJTS_LSF_XX_JHPZH_001), ']已被标注为“不予退税”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_HGJKJKSCLJG_DM_001 IN ('100','500') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSJH_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,BJTS_LSF_XX_GLH_001,'MTS_JHMX_JKXFS_DUP','E',ORA_CONCAT(ORA_CONCAT('海关进口消费税缴款书[', BJTS_LSF_XX_JHPZH_001), ']在电子信息中重复申请退税！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_GHFNSRSBH_1_001<>BJTS_LSF_XX_NSRSBH_001 THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSJH_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,BJTS_LSF_XX_GLH_001,'MTS_JHMX_JKXFS_GHFNSR','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('海关进口消费税缴款书[', BJTS_LSF_XX_JHPZH_001), ']供货方纳税人['), BJTS_LSF_XX_GHFNSRSBH_1_001), ']与电子信息中['), BJTS_LSF_XX_NSRSBH_001), ']不一致！'),'Y',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
      END;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MTS_TSJH_JKXFS.sql

-- ======================================================================
-- [071/114] BEGIN SOURCE: PROC_XXBD_MTS_TSJH_JKZZS.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MTS_TSJH_JKZZS$$

CREATE PROCEDURE PROC_XXBD_MTS_TSJH_JKZZS
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（外贸企业免退税）
  调整日期：20210603，1、调整疑点关联业务字段，关联号+申报序号
  调整日期：20211019，1、增加MTS_JHMX_JKZZS_GHFNSR疑点判断，海关进口税收凭证填写缴款单位纳税人识别号
  调整日期：20211208，1、调整免退税疑点描述字段中申报序号与关联单证号的顺序，使其与客户端疑点展示一致
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LDT_TODAY       DATETIME;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';
  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  -- 进口增值税缴款书记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_MTS_TSJH_LSB T
     WHERE T.SBID=V_IN_SBID
       AND T.CKTMSPZLX_DM='04';
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;

  SET LC_YDOBJECT ='进口增值税';
  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_TSJH_LSB',NULL,NULL,T.SBXH,T.GLH,'MTS_JHMX_JKZZS_WDZXX','E',ORA_CONCAT(ORA_CONCAT('海关进口增值税缴款书[', T.JHPZH), ']无电子信息！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_TSJH_LSB T
          WHERE T.SBID=V_IN_SBID
            AND T.CKTMSPZLX_DM='04'
            AND NOT EXISTS (SELECT 1
                              FROM CKTS_WBSJ_HG_JKJKS S
                             WHERE S.DJXH=V_IN_DJXH
                               AND S.HGZYJKSHM=T.JHPZH);
    COMMIT;
  END;

  BEGIN
    BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_SBXH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_GLH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_JHPZH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_GHFNSRSBH_1_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_BYTSBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_HGJKJKSCLJG_DM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_NSRSBH_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT A.SBXH,A.GLH,
                          A.JHPZH,
                          A.GHFNSRSBH_1,
                          B.BYTSBZ,
                          B.HGJKJKSCLJG_DM,
                          B.NSRSBH
                     FROM CKTS_SB_MTS_TSJH_LSB A
                    INNER JOIN CKTS_WBSJ_HG_JKJKS B ON B.DJXH=V_IN_DJXH AND B.HGZYJKSHM=A.JHPZH
                    WHERE A.SBID=V_IN_SBID
                      AND A.CKTMSPZLX_DM='04';
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_LSF_XX_SBXH_001, BJTS_LSF_XX_GLH_001, BJTS_LSF_XX_JHPZH_001, BJTS_LSF_XX_GHFNSRSBH_1_001, BJTS_LSF_XX_BYTSBZ_001, BJTS_LSF_XX_HGJKJKSCLJG_DM_001, BJTS_LSF_XX_NSRSBH_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
      BEGIN
        IF BJTS_LSF_XX_BYTSBZ_001='Y' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSJH_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,BJTS_LSF_XX_GLH_001,'MTS_JHMX_JKZZS_BYTS','E',ORA_CONCAT(ORA_CONCAT('海关进口增值税缴款书[', BJTS_LSF_XX_JHPZH_001), ']已被标注为“不予退税”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_HGJKJKSCLJG_DM_001 IN ('001','200') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSJH_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,BJTS_LSF_XX_GLH_001,'MTS_JHMX_JKZZS_YDK','E',ORA_CONCAT(ORA_CONCAT('海关进口增值税缴款书[', BJTS_LSF_XX_JHPZH_001), ']在电子信息中已勾选用于抵扣！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_HGJKJKSCLJG_DM_001 IN ('100','500') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSJH_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,BJTS_LSF_XX_GLH_001,'MTS_JHMX_JKZZS_DUP','E',ORA_CONCAT(ORA_CONCAT('海关进口增值税缴款书[', BJTS_LSF_XX_JHPZH_001), ']在电子信息中重复申请退税！'),'Y',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_GHFNSRSBH_1_001<>BJTS_LSF_XX_NSRSBH_001 THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSJH_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,BJTS_LSF_XX_GLH_001,'MTS_JHMX_JKZZS_GHFNSR','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('海关进口增值税缴款书[', BJTS_LSF_XX_JHPZH_001), ']供货方纳税人['), BJTS_LSF_XX_GHFNSRSBH_1_001), ']与电子信息中['), BJTS_LSF_XX_NSRSBH_001), ']不一致！'),'Y',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
      END;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MTS_TSJH_JKZZS.sql

-- ======================================================================
-- [072/114] BEGIN SOURCE: PROC_XXBD_MTS_TSJH_ZJJKS.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MTS_TSJH_ZJJKS$$

CREATE PROCEDURE PROC_XXBD_MTS_TSJH_ZJJKS
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（外贸企业免退税）
  调整日期：20210603，1、调整疑点关联业务字段，关联号+申报序号
  调整日期：20211208，1、调整免退税疑点描述字段中申报序号与关联单证号的顺序，使其与客户端疑点展示一致
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 总局专用缴款书记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_MTS_TSJH_LSB T
     WHERE T.SBID=V_IN_SBID
       AND T.CKTMSPZLX_DM='06';
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;

  SET LC_YDOBJECT ='税收缴款书';
  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_TSJH_LSB',NULL,NULL,T.SBXH,T.GLH,'MTS_JHMX_XFSSP_WDZXX','E',ORA_CONCAT(ORA_CONCAT('消费税税票[', T.JHPZH), ']无电子信息！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_TSJH_LSB T
          WHERE T.SBID=V_IN_SBID
            AND T.CKTMSPZLX_DM='06'
            AND NOT EXISTS (SELECT 1
                              FROM CKTS_WBSJ_ZJ_ZJZYJKS S
                             WHERE S.DJXH=V_IN_DJXH
                               AND S.JKSHM=T.JHPZH);
    COMMIT;
  END;

  BEGIN
    BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_SBXH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_GLH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_JHPZH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_GHFNSRSBH_1_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_JKDWRNSRSBH_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT A.SBXH,A.GLH,
                          A.JHPZH,
                          A.GHFNSRSBH_1,
                          B.JKDWRNSRSBH
                     FROM CKTS_SB_MTS_TSJH_LSB A
                    INNER JOIN CKTS_WBSJ_ZJ_ZJZYJKS B ON B.DJXH=V_IN_DJXH AND B.JKSHM=A.JHPZH
                    WHERE A.SBID=V_IN_SBID
                      AND A.CKTMSPZLX_DM='06';
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_LSF_XX_SBXH_001, BJTS_LSF_XX_GLH_001, BJTS_LSF_XX_JHPZH_001, BJTS_LSF_XX_GHFNSRSBH_1_001, BJTS_LSF_XX_JKDWRNSRSBH_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
      BEGIN
        IF BJTS_LSF_XX_GHFNSRSBH_1_001<>BJTS_LSF_XX_JKDWRNSRSBH_001 THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSJH_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,BJTS_LSF_XX_GLH_001,'MTS_JHMX_XFSSP_GHFNSR','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('消费税税票[', BJTS_LSF_XX_JHPZH_001), ']供货方纳税人['), BJTS_LSF_XX_GHFNSRSBH_1_001), ']与电子信息中['), BJTS_LSF_XX_JKDWRNSRSBH_001), ']不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
      END;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MTS_TSJH_ZJJKS.sql

-- ======================================================================
-- [073/114] BEGIN SOURCE: PROC_XXBD_MTS_TSJH_ZZSFP.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MTS_TSJH_ZZSFP$$

CREATE PROCEDURE PROC_XXBD_MTS_TSJH_ZZSFP
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（外贸企业免退税）
  调整日期：20201106，对金额增加null判断
  调整日期：20201111，增加关联号下进货、出口的商品名称、计量单位校验，发票代码号码赋值移到主存储过程中
  调整日期：20201119，对疑点MTS_JHMX_ZZSFP_SBJE的描述进行调整，细化企业发票开票数、已申报数据提示
  调整日期：20201230，1、校验发票稽核信息时，剔除代开发票的稽核信息，代开发票开票人税号含DK
  调整日期：20210603，1、调整MTS_YSFW_ZZSFP_SBJE计税金额总量控制误差；2、调整疑点关联业务字段，关联号+申报序号
  调整日期：20211208，1、调整免退税疑点描述字段中申报序号与关联单证号的顺序，使其与客户端疑点展示一致
  调整日期：20220228，1、增加MTS_JHMX_ZZSFP_SBSE疑点，当发票本次申报总退税额大于发票总开票税额（误差+1）时提醒，不可挑过
  调整日期：20220517，1、疑点MTS_JHMX_ZZSFP_SBSE、MTS_JHMX_ZZSFP_SBSE提示信息增加关联业务字段1为申报序号
  调整日期：20220701，1、根据全电票规则调整发票的关联，用JHPZH代替FPDM+FPHM
  调整日期：20230207，1、修改全电发票关联虚开发票时的BUG。
  调整日期：20230315，调整出口企业首次申报日期取数口径，改为按税务机关+企业+业务代码查询首次发放日期
  调整日期：20230515，解决增值税发票外部数据部分数据稽核相符标志为空的问题（赋默认值N）
  调整日期：20230518，解决按税务机关+企业+业务代码查询首次发放日期有结果但日期为空的问题（赋默认值SYSDATE）
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LDT_TODAY       DATETIME;
  DECLARE LDT_SCSBRQ      DATETIME;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';
  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  -- 增值税专用发票记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_MTS_TSJH_LSB T
     WHERE T.SBID=V_IN_SBID
       AND T.CKTMSPZLX_DM='02';
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;

  -- 查询企业首次申报日期
  BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
      SET LDT_SCSBRQ =LDT_TODAY;

  END;
SELECT IFNULL(T.FFRQ, CURRENT_TIMESTAMP)
      INTO LDT_SCSBRQ
      FROM CKTS_TY_YWBLXX_SCFFRQ T
     WHERE T.TSSWJG_DM_1=(SELECT SWJG_DM FROM GS_DJ_CKTMSDAB WHERE NSRDZDAH=V_IN_NSRDZDAH)
       AND T.DJXH=V_IN_DJXH AND T.LCSWSX_DM='LCSXA081039001';
  END;

  SET LC_YDOBJECT ='增值税发票';
  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_TSJH_LSB',NULL,NULL,T.SBXH,T.GLH,'MTS_JHMX_ZZSFP_WDZXX','E',ORA_CONCAT(ORA_CONCAT('增值税专用发票[', T.JHPZH), ']无电子信息！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_TSJH_LSB T
          WHERE T.SBID=V_IN_SBID
            AND T.CKTMSPZLX_DM='02'
            AND NOT EXISTS (SELECT 1
                              FROM CKTS_WBSJ_FP_ZZSZYFPXX S
                             WHERE S.DJXH=V_IN_DJXH
                               AND S.JHPZH=T.JHPZH);
    COMMIT;
  END;

  BEGIN
    CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',LDT_TODAY,LC_FLGLCD, LN_CPCODEKZ);
    BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_SBXH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_GLH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_JHPZH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKTMSYWLXDMJH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_JHXFZZSZYFPBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_BYTSBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_GHFNSRSBH_1_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_XFNSRSBH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_KPRQ_SB_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_KPRQ_SH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_FPYT_DM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_FPSJBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_NXZCKBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_GHFNSRSBH_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT A.SBXH,A.GLH,
                          A.JHPZH,
                          IFNULL(A.CKTMSYWLXDMJH, ' ') AS CKTMSYWLXDMJH,
                          IFNULL(B.JHXFZZSZYFPBZ, 'N') AS JHXFZZSZYFPBZ,
                          B.BYTSBZ,
                          A.GHFNSRSBH_1,
                          B.XFNSRSBH,
                          DATE(A.KPRQ) AS KPRQ_SB,
                          DATE(B.KPRQ) AS KPRQ_SH,
                          B.FPYT_DM,
                          IFNULL(B.FPSJBBZ, 'N') AS FPSJBZ,
                          IFNULL(B.NXZCKBZ, 'N') AS NXZCKBZ,
                          C.GHFNSRSBH
                     FROM CKTS_SB_MTS_TSJH_LSB A
                    INNER JOIN CKTS_WBSJ_FP_ZZSZYFPXX B ON B.DJXH=V_IN_DJXH AND B.JHPZH=A.JHPZH
                     LEFT JOIN CKTS_WBSJ_ZJ_XKFP C ON ORA_CONCAT(C.FP_DM, C.FPHM)=A.JHPZH
                    WHERE A.SBID=V_IN_SBID
                      AND A.CKTMSPZLX_DM='02';
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_LSF_XX_SBXH_001, BJTS_LSF_XX_GLH_001, BJTS_LSF_XX_JHPZH_001, BJTS_LSF_XX_CKTMSYWLXDMJH_001, BJTS_LSF_XX_JHXFZZSZYFPBZ_001, BJTS_LSF_XX_BYTSBZ_001, BJTS_LSF_XX_GHFNSRSBH_1_001, BJTS_LSF_XX_XFNSRSBH_001, BJTS_LSF_XX_KPRQ_SB_001, BJTS_LSF_XX_KPRQ_SH_001, BJTS_LSF_XX_FPYT_DM_001, BJTS_LSF_XX_FPSJBZ_001, BJTS_LSF_XX_NXZCKBZ_001, BJTS_LSF_XX_GHFNSRSBH_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
      BEGIN
        IF (BJTS_LSF_XX_JHXFZZSZYFPBZ_001='N' AND INSTR(BJTS_LSF_XX_XFNSRSBH_001,'DK')=0 AND (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_001,'RZZL')>0 OR LC_FLGLCD='D' OR (LC_FLGLCD='C' AND TIMESTAMPDIFF(MONTH, LDT_SCSBRQ, LDT_TODAY)<=12))) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSJH_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,BJTS_LSF_XX_GLH_001,'MTS_JHMX_ZZSFP_WDZXX','E',ORA_CONCAT(ORA_CONCAT('增值税专用发票[', BJTS_LSF_XX_JHPZH_001), ']无稽核相符电子信息！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_BYTSBZ_001='Y' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSJH_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,BJTS_LSF_XX_GLH_001,'MTS_JHMX_ZZSFP_BYTS','E',ORA_CONCAT(ORA_CONCAT('增值税专用发票[', BJTS_LSF_XX_JHPZH_001), ']已被标注为“不予退税”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_GHFNSRSBH_1_001<>BJTS_LSF_XX_XFNSRSBH_001 THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSJH_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,BJTS_LSF_XX_GLH_001,'MTS_JHMX_ZZSFP_GHFNSR','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('增值税专用发票[', BJTS_LSF_XX_JHPZH_001), ']供货方纳税人['), BJTS_LSF_XX_GHFNSRSBH_1_001), ']与电子信息中['), BJTS_LSF_XX_XFNSRSBH_001), ']不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_KPRQ_SB_001<>BJTS_LSF_XX_KPRQ_SH_001 THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSJH_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,BJTS_LSF_XX_GLH_001,'MTS_JHMX_ZZSFP_KPRQ','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('增值税专用发票[', BJTS_LSF_XX_JHPZH_001), ']开票日期['), DATE_FORMAT(BJTS_LSF_XX_KPRQ_SB_001, '%Y-%m-%d')), ']与电子信息中['), DATE_FORMAT(BJTS_LSF_XX_KPRQ_SH_001, '%Y-%m-%d')), ']不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_FPYT_DM_001='3' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSJH_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,BJTS_LSF_XX_GLH_001,'MTS_JHMX_ZZSFP_DBTS','E',ORA_CONCAT(ORA_CONCAT('增值税专用发票[', BJTS_LSF_XX_JHPZH_001), ']在电子信息中申报用途代码为“3-代办退税”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        ELSEIF (BJTS_LSF_XX_FPYT_DM_001='1' AND BJTS_LSF_XX_FPSJBZ_001='Y' AND BJTS_LSF_XX_NXZCKBZ_001='N') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSJH_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,BJTS_LSF_XX_GLH_001,'MTS_JHMX_ZZSFP_YDK','E',ORA_CONCAT(ORA_CONCAT('增值税专用发票[', BJTS_LSF_XX_JHPZH_001), ']在电子信息中已勾选用于抵扣！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_GHFNSRSBH_001 IS NOT NULL THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSJH_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,BJTS_LSF_XX_GLH_001,'MTS_JHMX_ZZSFP_XKFP','E',ORA_CONCAT(ORA_CONCAT('增值税专用发票[', BJTS_LSF_XX_JHPZH_001), ']在电子信息中为虚开增值税专用发票！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
      END;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;
  END;

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_TSJH_LSB',NULL,NULL,T.SBXH,T.JHPZH,'MTS_JHMX_ZZSFP_SBJE','I',
                ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('增值税专用发票[', T.JHPZH), ']申报退税的计税金额['), T.JSJE), ']超过电子信息中剩余数['), GREATEST(0,S.JE - IFNULL(S.HZCJJE, 0) - IFNULL(S.SBFPJSJE, 0) - IFNULL(S.LSLSBFPJSJE, 0))), ']（其中开票['), S.JE), ']红字冲减['), IFNULL(S.HZCJJE, 0)), ']出口货物劳务已申报['), IFNULL(S.SBFPJSJE, 0)), ']外购应税服务已申报['), IFNULL(S.LSLSBFPJSJE, 0)), ']）！'),'Y',CURRENT_TIMESTAMP
           FROM (SELECT A.JHPZH, SUM(A.JSJE) AS JSJE, MIN(A.SBXH) AS SBXH
                   FROM CKTS_SB_MTS_TSJH_LSB A
                  WHERE A.SBID=V_IN_SBID
                    AND A.CKTMSPZLX_DM='02'
                  GROUP BY A.JHPZH) T
          INNER JOIN CKTS_WBSJ_FP_ZZSZYFPXX S ON S.DJXH=V_IN_DJXH AND S.JHPZH=T.JHPZH
          WHERE T.JSJE > S.JE - IFNULL(S.HZCJJE, 0) - IFNULL(S.SBFPJSJE, 0) - IFNULL(S.LSLSBFPJSJE, 0);
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_TSJH_LSB',NULL,NULL,T.SBXH,T.JHPZH,'MTS_JHMX_ZZSFP_SBSE','E',
                ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('增值税专用发票[', T.JHPZH), ']申报退税额['), T.TSE), ']超过电子信息中税额['), IFNULL(S.SE, 0)), ']！'),'N',CURRENT_TIMESTAMP
           FROM (SELECT A.JHPZH, SUM(A.TSE) AS TSE, MIN(A.SBXH) AS SBXH
                   FROM CKTS_SB_MTS_TSJH_LSB A
                  WHERE A.SBID=V_IN_SBID
                    AND A.CKTMSPZLX_DM='02'
                  GROUP BY A.JHPZH) T
          INNER JOIN CKTS_WBSJ_FP_ZZSZYFPXX S ON S.DJXH=V_IN_DJXH AND S.JHPZH=T.JHPZH
          WHERE T.TSE > S.SE + 1;
    COMMIT;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MTS_TSJH_ZZSFP.sql

-- ======================================================================
-- [074/114] BEGIN SOURCE: PROC_XXBD_MTS_TSSB.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MTS_TSSB$$

CREATE PROCEDURE PROC_XXBD_MTS_TSSB
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（外贸企业免退税）
  调整日期：20210603，1、调整疑点关联业务字段，关联号+申报序号
  调整日期：20211208，1、调整免退税疑点描述字段中申报序号与关联单证号的顺序，使其与客户端疑点展示一致
  调整日期：20220323，1、根据总局货劳司关于加强启运港出口退（免）税统计分析功能的业务要求，增加MTS_CKMX_CKYWLX_QYGTS疑点
  修改日期：20220615，根据2022年9号公告，合并收汇与不能收汇
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LDT_TODAY       DATETIME;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';
  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  -- 出口明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_MTS_TSSB_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;

  SET LC_YDOBJECT ='出口明细';
  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_TSSB_LSB','CKTS_SB_MTS_TSJH_LSB',NULL,T.SBXH,T.GLH,'MTS_BJGX_CKMX_JHMX_GLH','E',ORA_CONCAT(ORA_CONCAT('出口明细中的关联号[', T.GLH), ']在进货明细中不存在！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_TSSB_LSB T
          WHERE T.SBID=V_IN_SBID
            AND NOT EXISTS (SELECT 1 FROM CKTS_SB_MTS_TSJH_LSB S WHERE S.SBID=T.SBID AND S.GLH=T.GLH);
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_TSSB_LSB','CKTS_SB_MTS_TSJH_LSB',NULL,T.SBXH,T.GLH,'MTS_BJGX_CKMX_JHMX_SPDM','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口明细中的关联号[', T.GLH), ']商品代码['), T.CKSP_DM), ']在进货明细中不存在！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_TSSB_LSB T
          WHERE T.SBID=V_IN_SBID
            AND NOT EXISTS (SELECT 1 FROM CKTS_SB_MTS_TSJH_LSB S WHERE S.SBID=T.SBID AND S.GLH=T.GLH AND S.CKSP_DM=T.CKSP_DM);
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_TSSB_LSB','CKTS_SB_MTS_TSJH_LSB',NULL,T.SBXH,T.GLH,'MTS_BJGX_CKMX_JHMX_JLDW','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口明细中的关联号[', T.GLH), ']计量单位['), T.HGJLDWMC), ']在进货明细中不存在！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_TSSB_LSB T
          WHERE T.SBID=V_IN_SBID
            AND NOT EXISTS (SELECT 1 FROM CKTS_SB_MTS_TSJH_LSB S WHERE S.SBID=T.SBID AND S.GLH=T.GLH AND S.HGJLDWMC=T.HGJLDWMC);
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
           WITH CK AS (SELECT T.SBID,T.GLH,T.CKSP_DM,SUM(T.CKSL) AS CKSL FROM CKTS_SB_MTS_TSSB_LSB T WHERE T.SBID=V_IN_SBID GROUP BY T.SBID,T.GLH,T.CKSP_DM),
                JH AS (SELECT S.SBID,S.GLH,S.CKSP_DM,SUM(S.SL) AS JHSL FROM CKTS_SB_MTS_TSJH_LSB S WHERE S.SBID=V_IN_SBID AND S.SZ='V' GROUP BY S.SBID,S.GLH,S.CKSP_DM)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_TSSB_LSB','CKTS_SB_MTS_TSJH_LSB',NULL,NULL,CK.GLH,'MTS_BJGX_CKMX_JHMX_CKSL','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口明细中的关联号[', CK.GLH), ']商品代码['), CK.CKSP_DM), ']出口数量['), CK.CKSL), ']大于进货数量['), IFNULL(JH.JHSL, 0.00)), ']！'),'N',CURRENT_TIMESTAMP
           FROM CK
           LEFT JOIN JH ON JH.SBID=CK.SBID AND JH.GLH=CK.GLH AND JH.CKSP_DM=CK.CKSP_DM
          WHERE CK.SBID=V_IN_SBID AND CK.CKSL>IFNULL(JH.JHSL, 0);
    COMMIT;

    CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',LDT_TODAY,LC_FLGLCD, LN_CPCODEKZ);
    CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TGSHZL',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
    IF (LC_FLGLCD='D') OR (LN_CPCODEKZ>0) THEN
      BEGIN
        INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
             SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                    'CKTS_SB_MTS_TSSB_LSB','CKTS_SB_MTS_CKSH_LSB',NULL,T.SBXH,T.GLH,'MTS_BJGX_CKMX_SHZL_CKPZ','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', T.CKBGDH), T.DLZMH), ']未申报收汇资料！'),'N',CURRENT_TIMESTAMP
               FROM CKTS_SB_MTS_TSSB_LSB T
              WHERE T.SBID=V_IN_SBID
                AND FUNC_XXBD_CHECK_NEEDSH(ORA_CONCAT(ORA_CONCAT(',', T.CKTMSYWLXDMJH), ',')) = 1
                AND NOT EXISTS (SELECT 1 FROM CKTS_SB_MTS_CKSH_LSB S WHERE S.SBID=T.SBID AND ORA_CONCAT(S.CKBGDH, S.DLCKHWZMHM) = ORA_CONCAT(T.CKBGDH, T.DLZMH));
        COMMIT;
      END;
    ELSE
      BEGIN
        INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
             SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                    'CKTS_SB_MTS_TSSB_LSB','CKTS_SB_MTS_CKSH_LSB',NULL,T.SBXH,T.GLH,'MTS_BJGX_CKMX_SHZL_CKPZ','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', T.CKBGDH), T.DLZMH), ']未申报收汇资料！'),'N',CURRENT_TIMESTAMP
               FROM CKTS_SB_MTS_TSSB_LSB T
              WHERE T.SBID=V_IN_SBID
                AND (((STR_TO_DATE(ORA_CONCAT(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y'), '0419'), '%Y%m%d')<CURRENT_TIMESTAMP) AND (CKRQ_1<MAKEDATE(YEAR(CURRENT_TIMESTAMP), 1))) OR (CKRQ_1<DATE_ADD(MAKEDATE(YEAR(CURRENT_TIMESTAMP), 1), INTERVAL -12 MONTH)))
                AND FUNC_XXBD_CHECK_NEEDSH(ORA_CONCAT(ORA_CONCAT(',', T.CKTMSYWLXDMJH), ',')) = 1
                AND NOT EXISTS (SELECT 1 FROM CKTS_SB_MTS_CKSH_LSB S WHERE S.SBID=T.SBID AND ORA_CONCAT(S.CKBGDH, S.DLCKHWZMHM) = ORA_CONCAT(T.CKBGDH, T.DLZMH));
        COMMIT;
      END;
    END IF;
  END;

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,T.SBXH,T.GLH,'MTS_CKMX_CKRQ_NSRZG','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.CKRQ_1, '%Y-%m-%d')), ']企业非增值税一般纳税人！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_TSSB_LSB T
           LEFT JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='YBNSRRD' AND S.FLAG='1' AND T.CKRQ_1 BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID
            AND S.KZLX IS NULL;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,T.SBXH,T.GLH,'MTS_CKMX_CKRQ_TQQY','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.CKRQ_1, '%Y-%m-%d')), ']企业处于出口退税停权期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_TSSB_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='TQQY' AND S.FLAG='1' AND T.CKRQ_1 BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,T.SBXH,T.GLH,'MTS_CKMX_CKRQ_MSQY','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.CKRQ_1, '%Y-%m-%d')), ']企业处于免税期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_TSSB_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='TSGMS' AND S.FLAG='1' AND T.CKRQ_1 BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,T.SBXH,T.GLH,'MTS_CKMX_CKRQ_FQTS','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.CKRQ_1, '%Y-%m-%d')), ']企业处于放弃退（免）税权选择免税期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_TSSB_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='FQTSSXMS' AND S.FLAG='1' AND T.CKRQ_1 BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,T.SBXH,T.GLH,'MTS_CKMX_CKRQ_FQTS','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.CKRQ_1, '%Y-%m-%d')), ']企业处于放弃退（免）税权选择征税期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_TSSB_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='FQTSSXZS' AND S.FLAG='1' AND T.CKRQ_1 BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,T.SBXH,T.GLH,'MTS_CKMX_CKRQ_FQTS','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.CKRQ_1, '%Y-%m-%d')), ']企业处于放弃退（免）税权期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_TSSB_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='FQTMS' AND S.FLAG='1' AND T.CKRQ_1 BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;
  END;

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,T.SBXH,NULL,'MTS_CKMX_CKYWLX_QYGTS','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', IFNULL(T.CKBGDH, T.DLZMH)), ']为启运港业务，需确认国内启运方式及海关总署认证企业类型！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_TSSB_LSB T
          WHERE T.SBID=V_IN_SBID
            AND INSTR(T.CKTMSYWLXDMJH,'QYGTS')>0
            AND (T.GNQYFS_DM IS NULL OR T.HGZSRZQYLX_DM IS NULL);
    COMMIT;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MTS_TSSB.sql

-- ======================================================================
-- [075/114] BEGIN SOURCE: PROC_XXBD_MTS_TSSB_BGD.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MTS_TSSB_BGD$$

CREATE PROCEDURE PROC_XXBD_MTS_TSSB_BGD
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（外贸企业免退税）
  调整日期：20201106，对金额增加null判断
  调整日期：20201111，增加关联号下进货、出口的商品名称、计量单位校验
  调整日期：20201119，调整改单报关单监控条件，由bgd202不存在改为bgd201.gdbz_1<>Y
  调整日期：20210113，调整改单报关单监控条件，改为bgd202不存在 且 bgd201.gdbz_1<>Y
  调整日期：20210528，修改进出口明细商品名称、计量单位比较的疑点代码
  调整日期：20210603，调整疑点关联业务字段，关联号+申报序号
  调整日期：20210707，MTS_CKMX_BGD_USDLAJ，对数量部分申报的美元离岸价进行折算，疑点为可挑过
  调整日期：20211208，调整免退税疑点描述字段中申报序号与关联单证号的顺序，使其与客户端疑点展示一致
  调整日期：20220615，MTS_CKMX_DLZM_CKSL分层级，申报数量大于出口数量不可挑过，否则大于剩余数量可挑过
  调整日期：20220701，根据全电票规则调整发票的关联，用JHPZH代替FPDM+FPHM
  调整日期：20230313，增加MTS_CKMX_BGD_BSQ_BAQD、MTS_CKMX_BGD_BSQ_BANR疑点判断
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE BJTS_ITERATE_001 BOOLEAN DEFAULT FALSE;
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LN_CMCD_LEN     BIGINT;
  DECLARE LC_JHPZHJLDW    VARCHAR(75);

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 报关单出口明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_MTS_TSSB_LSB T
     WHERE T.SBID=V_IN_SBID
       AND T.CKBGDH IS NOT NULL;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;

  SET LC_YDOBJECT ='出口报关单';
  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,T.SBXH,T.GLH,'MTS_CKMX_BGD_WDZXX','E',
                ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), ']无电子信息！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_TSSB_LSB T
          WHERE T.SBID=V_IN_SBID
            AND T.CKBGDH IS NOT NULL
            AND FUNC_XXBD_CHECK_YWLX(ORA_CONCAT(ORA_CONCAT(',', T.CKTMSYWLXDMJH), ',')) = 0
            AND NOT EXISTS (SELECT 1 FROM CKTS_WBSJ_HG_BGD201 S WHERE S.DJXH=V_IN_DJXH AND S.CKBGDH=T.CKBGDH);
    COMMIT;
  END;

  BEGIN
    BEGIN
  DECLARE BJTS_CURSOR_DONE_002 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_SBXH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKBGDH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_BYTSBZ_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKRQ_SB_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKRQ_SH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_QYRQ_SH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKTMSYWLXDMJH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSP_DM_SB_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSP_DM_SH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSL_SB_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSL_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_TSSBSL_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_DLSBSL_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_TYSL_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_SYSL_SH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_MYLAJ_SB_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_MYLAJ_SH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_MYLAJ_JS_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_TYYBSWTSTYLX_DM_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_GDBZ_1_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKBGDH_GD_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_JGFS_DM_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_JGFSTSLX_DM_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_ZZMDGDQSZ_DM_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_QYGBZ_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_QYGCXCKBZ_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_QYGWDDBZ_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_QYGZCJGBZ_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_YSFS_DM_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_GLH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_DYJLDW_DM_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_DEJLDW_DM_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_SBJLDW_DM_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_GFHHGSPMC_002 LONGTEXT;
  DECLARE BJTS_CURSOR_002 CURSOR FOR
SELECT A.SBXH,
                          A.CKBGDH,
                          B.BYTSBZ,
                          DATE(A.CKRQ_1) AS CKRQ_SB,
                          DATE(B.CKRQ_1) AS CKRQ_SH,
                          DATE(B.QYRQ_2) AS QYRQ_SH,
                          IFNULL(A.CKTMSYWLXDMJH, ' ') AS CKTMSYWLXDMJH,
                          A.CKSP_DM AS CKSP_DM_SB,
                          B.CKSP_DM AS CKSP_DM_SH,
                          A.CKSL AS CKSL_SB,
                          B.CKSL,
                          IFNULL(B.TSSBSL, 0) AS TSSBSL,
                          IFNULL(B.DLSBSL, 0) AS DLSBSL,
                          IFNULL(B.TYSL, 0) AS TYSL,
                          B.CKSL-IFNULL(B.TSSBSL, 0)-IFNULL(B.DLSBSL, 0)-IFNULL(B.TYSL, 0) AS SYSL_SH,
                          A.MYLAJ AS MYLAJ_SB,
                          B.MYLAJ-IFNULL(B.TSSBMYLAJ, 0)-IFNULL(B.DLSBMYLAJ, 0)-IFNULL(B.TYMYLAJ, 0) AS MYLAJ_SH,
                          (B.MYLAJ-IFNULL(B.TSSBMYLAJ, 0)-IFNULL(B.DLSBMYLAJ, 0)-IFNULL(B.TYMYLAJ, 0)) *
                          (CASE WHEN (A.CKSL=0) OR (B.CKSL-IFNULL(B.TSSBSL, 0)-IFNULL(B.DLSBSL, 0)-IFNULL(B.TYSL, 0)=0) THEN 0
                                ELSE A.CKSL / (B.CKSL-IFNULL(B.TSSBSL, 0)-IFNULL(B.DLSBSL, 0)-IFNULL(B.TYSL, 0)) END) AS MYLAJ_JS,
                          D.TYYBSWTSTYLX_DM,
                          IFNULL(B.GDBZ_1, ' ') AS GDBZ_1,
                          E.CKBGDH AS CKBGDH_GD,
                          C.JGFS_DM,
                          C.JGFSTSLX_DM,
                          B.ZZMDGDQSZ_DM,
                          B.QYGBZ,
                          B.QYGCXCKBZ,
                          B.QYGWDDBZ,
                          B.QYGZCJGBZ,
                          B.YSFS_DM,
                          A.GLH,
                          IFNULL(B.DYJLDW_DM, ' ') AS DYJLDW_DM,
                          IFNULL(B.DEJLDW_DM, ' ') AS DEJLDW_DM,
                          IFNULL(B.SBJLDW_DM, ' ') AS SBJLDW_DM,
                          B.GFHHGSPMC
                     FROM CKTS_SB_MTS_TSSB_LSB A
                    INNER JOIN CKTS_WBSJ_HG_BGD201 B ON B.DJXH=V_IN_DJXH AND B.CKBGDH=A.CKBGDH
                     LEFT JOIN CKTS_DM_HGJGFS C ON C.JGFS_DM=B.JGFS_DM
                     LEFT JOIN CKTS_JGB_ZM_TYYBSWTS D ON D.DJXH=V_IN_DJXH AND D.CKBGDH=B.CKBGDH AND IFNULL(D.ZFBZ_1, 'N')='N'
                     LEFT JOIN CKTS_WBSJ_HG_BGD202 E ON E.DJXH=V_IN_DJXH AND E.CKBGDH=B.CKBGDH
                    WHERE A.SBID=V_IN_SBID
                      AND A.CKBGDH IS NOT NULL
                      AND FUNC_XXBD_CHECK_YWLX(ORA_CONCAT(ORA_CONCAT(',', A.CKTMSYWLXDMJH), ',')) = 0;
  OPEN BJTS_CURSOR_002;
  BJTS_CURSOR_LOOP_002: LOOP
    SET BJTS_CURSOR_DONE_002 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_002 = TRUE;
      FETCH BJTS_CURSOR_002 INTO BJTS_LSF_XX_SBXH_002, BJTS_LSF_XX_CKBGDH_002, BJTS_LSF_XX_BYTSBZ_002, BJTS_LSF_XX_CKRQ_SB_002, BJTS_LSF_XX_CKRQ_SH_002, BJTS_LSF_XX_QYRQ_SH_002, BJTS_LSF_XX_CKTMSYWLXDMJH_002, BJTS_LSF_XX_CKSP_DM_SB_002, BJTS_LSF_XX_CKSP_DM_SH_002, BJTS_LSF_XX_CKSL_SB_002, BJTS_LSF_XX_CKSL_002, BJTS_LSF_XX_TSSBSL_002, BJTS_LSF_XX_DLSBSL_002, BJTS_LSF_XX_TYSL_002, BJTS_LSF_XX_SYSL_SH_002, BJTS_LSF_XX_MYLAJ_SB_002, BJTS_LSF_XX_MYLAJ_SH_002, BJTS_LSF_XX_MYLAJ_JS_002, BJTS_LSF_XX_TYYBSWTSTYLX_DM_002, BJTS_LSF_XX_GDBZ_1_002, BJTS_LSF_XX_CKBGDH_GD_002, BJTS_LSF_XX_JGFS_DM_002, BJTS_LSF_XX_JGFSTSLX_DM_002, BJTS_LSF_XX_ZZMDGDQSZ_DM_002, BJTS_LSF_XX_QYGBZ_002, BJTS_LSF_XX_QYGCXCKBZ_002, BJTS_LSF_XX_QYGWDDBZ_002, BJTS_LSF_XX_QYGZCJGBZ_002, BJTS_LSF_XX_YSFS_DM_002, BJTS_LSF_XX_GLH_002, BJTS_LSF_XX_DYJLDW_DM_002, BJTS_LSF_XX_DEJLDW_DM_002, BJTS_LSF_XX_SBJLDW_DM_002, BJTS_LSF_XX_GFHHGSPMC_002;
    END;
    IF BJTS_CURSOR_DONE_002 THEN
      LEAVE BJTS_CURSOR_LOOP_002;
    END IF;
      BEGIN
        SET LC_YDOBJECT ='出口报关单';

        IF BJTS_LSF_XX_BYTSBZ_002='Y' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_BYTS','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']已被标注为“不予退税”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        SET LN_CMCD_LEN = CASE WHEN LENGTH(BJTS_LSF_XX_CKSP_DM_SB_002) > LENGTH(BJTS_LSF_XX_CKSP_DM_SH_002) THEN LENGTH(BJTS_LSF_XX_CKSP_DM_SH_002) ELSE LENGTH(BJTS_LSF_XX_CKSP_DM_SB_002) END;
        IF SUBSTR(BJTS_LSF_XX_CKSP_DM_SB_002,1,LN_CMCD_LEN)<>SUBSTR(BJTS_LSF_XX_CKSP_DM_SH_002,1,LN_CMCD_LEN) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_SPDM','E',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']商品代码['), BJTS_LSF_XX_CKSP_DM_SB_002), ']与电子信息中['), BJTS_LSF_XX_CKSP_DM_SH_002), ']不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (BJTS_LSF_XX_CKSL_SB_002 > BJTS_LSF_XX_CKSL_002 + 1) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_CKSL','E',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']申报退税数量['), BJTS_LSF_XX_CKSL_SB_002), ']超过电子信息中出口数量['), BJTS_LSF_XX_CKSL_002), ']！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        ELSEIF (BJTS_LSF_XX_CKSL_SB_002 > BJTS_LSF_XX_SYSL_SH_002 + 1) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_CKSL','I',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']申报退税数量['), BJTS_LSF_XX_CKSL_SB_002), ']超过电子信息中剩余数['), BJTS_LSF_XX_SYSL_SH_002), ']（其中出口['), BJTS_LSF_XX_CKSL_002), ']退税申报['), BJTS_LSF_XX_TSSBSL_002), ']退运['), BJTS_LSF_XX_TYSL_002), ']代理申报['), BJTS_LSF_XX_DLSBSL_002), ']）！'),'Y',CURRENT_TIMESTAMP
;
          COMMIT;
        ELSEIF (ABS(BJTS_LSF_XX_MYLAJ_SB_002-BJTS_LSF_XX_MYLAJ_JS_002)>1 AND ABS(BJTS_LSF_XX_MYLAJ_SB_002-BJTS_LSF_XX_MYLAJ_JS_002)>0.05 * BJTS_LSF_XX_MYLAJ_JS_002) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_USDLAJ','I',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']美元离岸价['), BJTS_LSF_XX_MYLAJ_SB_002), ']超过电子信息中合理范围，其中剩余数量['), BJTS_LSF_XX_SYSL_SH_002), ']，剩余美元离岸价['), BJTS_LSF_XX_MYLAJ_SH_002), ']，本次申报数量['), BJTS_LSF_XX_CKSL_SB_002), ']！'),'Y',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        -- 1退运; 2改单; 3撤单
        IF BJTS_LSF_XX_TYYBSWTSTYLX_DM_002='3' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_CD','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']曾办理过用途为”撤单“的有效的退运证明！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        ELSEIF (BJTS_LSF_XX_TYYBSWTSTYLX_DM_002='2' AND BJTS_LSF_XX_GDBZ_1_002<>'Y' AND BJTS_LSF_XX_CKBGDH_GD_002 IS NULL) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_GD','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']曾办理过用途为“改单”的有效的退运证明，且在“海关出口报关单改单数据”中不存在！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (TRIM(BJTS_LSF_XX_JGFS_DM_002) IS NULL) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_MYXZ_BCZ','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']在电子信息中监管方式不存在！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        ELSE
          IF (TRIM(BJTS_LSF_XX_JGFSTSLX_DM_002)='0') THEN
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                        'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_MYXZ_BTS','E',
                        ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']在电子信息中监管方式['), BJTS_LSF_XX_JGFS_DM_002), ']不退税！'),'N',CURRENT_TIMESTAMP
;
            COMMIT;
          END IF;
        END IF;

        IF BJTS_LSF_XX_ZZMDGDQSZ_DM_002<>'142' AND INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'LMYCL')>0 THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_LMYCL_ZZMDG','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']贸易国别非中国，“业务类型”不应包含“LMYCL”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'QYGTS')>0) THEN
          BEGIN
            IF (BJTS_LSF_XX_CKRQ_SB_002<>BJTS_LSF_XX_QYRQ_SH_002) AND (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'BSQ')=0) THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_CKRQ','E',
                          ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']出口日期['), DATE_FORMAT(BJTS_LSF_XX_CKRQ_SB_002, '%Y-%m-%d')), ']与电子信息中['), DATE_FORMAT(BJTS_LSF_XX_QYRQ_SH_002, '%Y-%m-%d')), ']不一致！'),'N',CURRENT_TIMESTAMP
;
              COMMIT;
            END IF;
            IF BJTS_LSF_XX_QYGBZ_002<>'Y' THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_QYGTS_NOT','E',
                          ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']非启运港业务，“业务类型”不应包含“QYGTS”！'),'N',CURRENT_TIMESTAMP
;
              COMMIT;
            ELSE
              BEGIN
                IF BJTS_LSF_XX_QYGCXCKBZ_002='Y' THEN
                  INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                       SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                              'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_QYGTS_CXCK','E',
                              ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']为启运港业务，已经撤销出口！'),'N',CURRENT_TIMESTAMP
;
                  COMMIT;
                END IF;
                CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',BJTS_LSF_XX_QYRQ_SH_002,LC_FLGLCD, LN_CPCODEKZ);
                IF (LC_FLGLCD<>'A' AND LC_FLGLCD<>'B') THEN
                  INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                       SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                              'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_QYGTS_FLGLCD','E',
                              ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']启运日当天该企业分类管理类别非一、二类，“业务类型”不应包含“QYGTS”！'),'N',CURRENT_TIMESTAMP
;
                  COMMIT;
                END IF;
                IF TIMESTAMPDIFF(MONTH, BJTS_LSF_XX_QYRQ_SH_002, DATE(CURRENT_TIMESTAMP))>2 THEN
                  INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                       SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                              'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_QYGTS_CKRQ','E',
                              ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']超过启运日两月，“业务类型”不应包含“QYGTS”！'),'N',CURRENT_TIMESTAMP
;
                  COMMIT;
                END IF;
                IF BJTS_LSF_XX_QYGWDDBZ_002='Y' THEN
                  INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                       SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                              'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_QYGTS_WDD','E',
                              ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']未实际到达离境港，“业务类型”不应包含“QYGTS”！'),'N',CURRENT_TIMESTAMP
;
                  COMMIT;
                END IF;
              END;
            END IF;
          END;
        ELSE
          BEGIN
            IF (BJTS_LSF_XX_CKRQ_SB_002<>BJTS_LSF_XX_CKRQ_SH_002) AND (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'BSQ')=0) THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_CKRQ','E',
                          ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']出口日期['), DATE_FORMAT(BJTS_LSF_XX_CKRQ_SB_002, '%Y-%m-%d')), ']与电子信息中['), DATE_FORMAT(BJTS_LSF_XX_CKRQ_SH_002, '%Y-%m-%d')), ']不一致！'),'N',CURRENT_TIMESTAMP
;
              COMMIT;
            END IF;
            IF (BJTS_LSF_XX_QYGBZ_002='Y' AND BJTS_LSF_XX_QYGZCJGBZ_002='N') THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_QYGTS_NULL','E',
                          ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']为启运港业务，目前尚未收到结关信息，“业务类型”应包含“QYGTS”！'),'N',CURRENT_TIMESTAMP
;
              COMMIT;
            END IF;
          END;
        END IF;

        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'DWCB')>0 AND BJTS_LSF_XX_JGFS_DM_002<>'3422' AND BJTS_LSF_XX_JGFS_DM_002<>'22') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_DWCB_NOT','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']非对外承包业务，“业务类型”不应包含“DWCB”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'DWCB')=0 AND (BJTS_LSF_XX_JGFS_DM_002='3422' OR BJTS_LSF_XX_JGFS_DM_002='22')) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_DWCB_NULL','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']为对外承包业务，“业务类型”应包含“DWCB”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'BSQ')>0 THEN
          IF BJTS_LSF_XX_YSFS_DM_002<>'0' THEN
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                        'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_BSQ_NOT','E',
                        ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']非经保税区出口业务，“业务类型”不应包含“BSQ”！'),'N',CURRENT_TIMESTAMP
;
            COMMIT;
          ELSE
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                        'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_BSQ_BAQD','I',
                        ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']业务类型包含保税区BSQ，请核实是否附送《出境货物备案清单》！'),'Y',CURRENT_TIMESTAMP
;
            COMMIT;
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                        'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_BSQ_BANR','I',
                        ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']业务类型包含保税区BSQ，请核实出境货物备案清单的内容是否与报关单相关内容相符,出口日期填报是否准确！'),'Y',CURRENT_TIMESTAMP
;
            COMMIT;
          END IF;
        END IF;
        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'BSQ')=0 AND BJTS_LSF_XX_YSFS_DM_002='0') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_BSQ_NULL','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']为经保税区出口业务，“业务类型”应包含“BSQ”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'RZZL')>0 THEN
          BEGIN
            CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'RZZL',BJTS_LSF_XX_CKRQ_SH_002,LC_KZXX, LN_CPCODEKZ);
            IF LN_CPCODEKZ=0 THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_RZZL_ZG','E',
                          '企业备案扩展信息中未做融资租赁备案，“业务类型”不应包含“RZZL”！','N',CURRENT_TIMESTAMP
;
              COMMIT;
            END IF;
            IF BJTS_LSF_XX_JGFS_DM_002<>'1523' THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_RZZL_NOT','E',
                          ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']非融资租赁业务，“业务类型”不应包含“RZZL”！'),'N',CURRENT_TIMESTAMP
;
              COMMIT;
            END IF;
          END;
        ELSE
          IF BJTS_LSF_XX_JGFS_DM_002='1523' THEN
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                        'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_RZZL_NOT','E',
                        ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']为融资租赁业务，“业务类型”应包含“RZZL”！'),'N',CURRENT_TIMESTAMP
;
            COMMIT;
          END IF;
        END IF;

        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'JWTZ')>0 AND BJTS_LSF_XX_JGFS_DM_002<>'2210') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_JWTZ_NOT','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']非境外投资业务，“业务类型”不应包含“JWTZ”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'JWTZ')=0 AND BJTS_LSF_XX_JGFS_DM_002='2210') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_JWTZ_NULL','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']为境外投资业务，“业务类型”应包含“JWTZ”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'DWYZ')>0 AND BJTS_LSF_XX_JGFS_DM_002<>'3511') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_DWYZ_NOT','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']非对外援助业务，“业务类型”不应包含“DWYZ”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'DWYZ')=0 AND BJTS_LSF_XX_JGFS_DM_002='3511') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_DWYZ_NULL','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']为对外援助业务，“业务类型”应包含“DWYZ”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'XLXP')>0 AND BJTS_LSF_XX_JGFS_DM_002<>'1300') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_XLXP_NOT','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']非修理修配业务，“业务类型”不应包含“XLXP”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'XLXP')=0 AND BJTS_LSF_XX_JGFS_DM_002='1300') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_BGD_XLXP_NULL','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']为修理修配业务，“业务类型”应包含“XLXP”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_YSFS_DM_002='T' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_CKPZH_YSFS','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']为出口到综合试验区（横琴平潭地区）的报关单！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
      END;

      -- 2020.11.11 增加关联号下进货、出口的商品名称、计量单位校验
      SET LC_YDOBJECT ='增值税发票';
      BEGIN
        BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_YY_SBXH_001 LONGTEXT;
  DECLARE BJTS_LSF_YY_GLH_001 LONGTEXT;
  DECLARE BJTS_LSF_YY_JHPZH_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT A.SBXH, A.GLH, A.JHPZH FROM CKTS_SB_MTS_TSJH_LSB A WHERE A.SBID=V_IN_SBID AND A.GLH=BJTS_LSF_XX_GLH_002 AND A.CKTMSPZLX_DM='02';
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_LSF_YY_SBXH_001, BJTS_LSF_YY_GLH_001, BJTS_LSF_YY_JHPZH_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
          BEGIN
            SELECT COUNT(1)
              INTO LN_MXROW
              FROM CKTS_WBSJ_FP_ZZSFPHWXX B
             WHERE B.DJXH=V_IN_DJXH AND B.JHPZH=BJTS_LSF_YY_JHPZH_001;
            IF LN_MXROW>0 THEN
              SET BJTS_ITERATE_001 = FALSE;
    BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
                  INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                       SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                              'CKTS_SB_MTS_TSJH_LSB',NULL,NULL,BJTS_LSF_YY_SBXH_001,BJTS_LSF_YY_GLH_001,'MTS_JHMX_ZZSFP_SPMC_BGD','I',
                              ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('增值税专用发票[', BJTS_LSF_YY_JHPZH_001), ']商品名称与出口报关单商品名称['), BJTS_LSF_XX_GFHHGSPMC_002), ']不一致，请核对确认！'),'Y',CURRENT_TIMESTAMP
;
                  COMMIT;

  END;

  DECLARE EXIT HANDLER FOR 1172
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
                  INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                       SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                              'CKTS_SB_MTS_TSJH_LSB',NULL,NULL,BJTS_LSF_YY_SBXH_001,BJTS_LSF_YY_GLH_001,'MTS_JHMX_ZZSFP_SPMC_JLDW','I',
                              ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('增值税专用发票[', BJTS_LSF_YY_JHPZH_001), ']存在同一商品名称['), BJTS_LSF_XX_GFHHGSPMC_002), ']但计量单位不同的情形，请核对确认！'),'Y',CURRENT_TIMESTAMP
;
                  COMMIT;

  END;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
                  SET BJTS_ITERATE_001 = TRUE;

  END;
SELECT DISTINCT B.JLDWMC
                  INTO LC_JHPZHJLDW
                  FROM CKTS_WBSJ_FP_ZZSFPHWXX B
                 WHERE B.DJXH=V_IN_DJXH AND B.JHPZH=BJTS_LSF_YY_JHPZH_001 AND B.GFHHWHYSLWMC=BJTS_LSF_XX_GFHHGSPMC_002;

                IF FUNC_XXBD_CHECK_JLDW(LC_JHPZHJLDW,BJTS_LSF_XX_DYJLDW_DM_002)=0 AND FUNC_XXBD_CHECK_JLDW(LC_JHPZHJLDW,BJTS_LSF_XX_DEJLDW_DM_002)=0 AND FUNC_XXBD_CHECK_JLDW(LC_JHPZHJLDW,BJTS_LSF_XX_SBJLDW_DM_002)=0 THEN
                  INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                       SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                              'CKTS_SB_MTS_TSJH_LSB',NULL,NULL,BJTS_LSF_YY_SBXH_001,BJTS_LSF_YY_GLH_001,'MTS_JHMX_ZZSFP_JLDW_BGD','I',
                              ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('增值税专用发票[', BJTS_LSF_YY_JHPZH_001), ']的计量单位['), LC_JHPZHJLDW), ']与出口报关单计量单位不符，请核对确认！'),'Y',CURRENT_TIMESTAMP
;
                  COMMIT;
                END IF;
              END;
  IF BJTS_ITERATE_001 THEN
    ITERATE BJTS_CURSOR_LOOP_001;
  END IF;
            END IF;
          END;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;
      END;

  END LOOP BJTS_CURSOR_LOOP_002;
  CLOSE BJTS_CURSOR_002;
END;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MTS_TSSB_BGD.sql

-- ======================================================================
-- [076/114] BEGIN SOURCE: PROC_XXBD_MTS_TSSB_DLZM.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_MTS_TSSB_DLZM$$

CREATE PROCEDURE PROC_XXBD_MTS_TSSB_DLZM
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（外贸企业免退税）
  调整日期：20201106，对金额增加null判断
  调整日期：20201111，增加关联号下进货、出口的商品名称、计量单位校验
  调整日期：20210528，修改进出口明细商品名称、计量单位比较的疑点代码
  调整日期：20210603，调整疑点关联业务字段，关联号+申报序号
  调整日期：20210707，MTS_CKMX_DLZM_USDLAJ，对数量部分申报的美元离岸价进行折算，疑点为可挑过
  调整日期：20211208，调整免退税疑点描述字段中申报序号与关联单证号的顺序，使其与客户端疑点展示一致
  调整日期：20220615，MTS_CKMX_DLZM_CKSL分层级，申报数量大于出口数量不可挑过，否则大于剩余数量可挑过
  调整日期：20220701，根据全电票规则调整发票的关联，用JHPZH代替FPDM+FPHM
  调整日期：20230313，增加MTS_CKMX_DLZM_BSQ_BAQD、MTS_CKMX_DLZM_BSQ_BANR疑点判断
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE BJTS_ITERATE_001 BOOLEAN DEFAULT FALSE;
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LN_CMCD_LEN     BIGINT;
  DECLARE LC_JHPZHJLDW    VARCHAR(75);

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 代理证明号出口明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_MTS_TSSB_LSB T
     WHERE T.SBID=V_IN_SBID
       AND T.DLZMH IS NOT NULL;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;

  SET LC_YDOBJECT ='代理证明';
  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,T.SBXH,T.GLH,'MTS_CKMX_DLZM_WDZXX','E',
                ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', T.DLZMH), ']无电子信息！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_TSSB_LSB T
          WHERE T.SBID=V_IN_SBID
            AND T.DLZMH IS NOT NULL
            AND FUNC_XXBD_CHECK_YWLX(ORA_CONCAT(ORA_CONCAT(',', T.CKTMSYWLXDMJH), ',')) = 0
            AND NOT EXISTS (SELECT 1 FROM CKTS_WBSJ_ZJ_DLCKHWZM S WHERE S.DJXH=V_IN_DJXH AND S.DLCKHWZMHM=T.DLZMH);
    COMMIT;
  END;

  BEGIN
    BEGIN
  DECLARE BJTS_CURSOR_DONE_002 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_SBXH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_DLZMH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_BYTSBZ_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKRQ_SB_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKRQ_SH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKTMSYWLXDMJH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSP_DM_SB_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSP_DM_SH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSL_SB_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSL_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_TSSBSL_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_TYSL_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_SYSL_SH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_MYLAJ_SB_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_MYLAJ_SH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_MYLAJ_JS_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_JGFS_DM_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_JGFSTSLX_DM_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_YSFS_DM_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_GLH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_DYJLDW_DM_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_DEJLDW_DM_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_SBJLDW_DM_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_GFHHGSPMC_002 LONGTEXT;
  DECLARE BJTS_CURSOR_002 CURSOR FOR
SELECT A.SBXH,
                          A.DLZMH,
                          B.BYTSBZ,
                          DATE(A.CKRQ_1) AS CKRQ_SB,
                          DATE(B.CKRQ_1) AS CKRQ_SH,
                          IFNULL(A.CKTMSYWLXDMJH, ' ') AS CKTMSYWLXDMJH,
                          A.CKSP_DM AS CKSP_DM_SB,
                          B.CKSP_DM AS CKSP_DM_SH,
                          A.CKSL AS CKSL_SB,
                          B.CKSL,
                          IFNULL(B.TSSBSL, 0) AS TSSBSL,
                          IFNULL(B.TYSL, 0) AS TYSL,
                          B.CKSL-IFNULL(B.TSSBSL, 0)-IFNULL(B.TYSL, 0) AS SYSL_SH,
                          A.MYLAJ AS MYLAJ_SB,
                          B.MYLAJ-IFNULL(B.TSSBMYLAJ, 0)-IFNULL(B.TYMYLAJ, 0) AS MYLAJ_SH,
                          (B.MYLAJ-IFNULL(B.TSSBMYLAJ, 0)-IFNULL(B.TYMYLAJ, 0)) *
                          (CASE WHEN (A.CKSL=0) OR (B.CKSL-IFNULL(B.TSSBSL, 0)-IFNULL(B.TYSL, 0)=0) THEN 0
                                ELSE A.CKSL / (B.CKSL-IFNULL(B.TSSBSL, 0)-IFNULL(B.TYSL, 0)) END) AS MYLAJ_JS,
                          C.JGFS_DM,
                          C.JGFSTSLX_DM,
                          B.YSFS_DM,
                          A.GLH,
                          IFNULL(B.DYJLDW_DM, ' ') AS DYJLDW_DM,
                          IFNULL(B.DEJLDW_DM, ' ') AS DEJLDW_DM,
                          IFNULL(B.SBJLDW_DM, ' ') AS SBJLDW_DM,
                          B.GFHHGSPMC
                     FROM CKTS_SB_MTS_TSSB_LSB A
                    INNER JOIN CKTS_WBSJ_ZJ_DLCKHWZM B ON B.DJXH=V_IN_DJXH AND B.DLCKHWZMHM=A.DLZMH
                     LEFT JOIN CKTS_DM_HGJGFS C ON C.JGFS_DM=B.JGFS_DM
                    WHERE A.SBID=V_IN_SBID
                      AND A.DLZMH IS NOT NULL
                      AND FUNC_XXBD_CHECK_YWLX(ORA_CONCAT(ORA_CONCAT(',', A.CKTMSYWLXDMJH), ',')) = 0;
  OPEN BJTS_CURSOR_002;
  BJTS_CURSOR_LOOP_002: LOOP
    SET BJTS_CURSOR_DONE_002 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_002 = TRUE;
      FETCH BJTS_CURSOR_002 INTO BJTS_LSF_XX_SBXH_002, BJTS_LSF_XX_DLZMH_002, BJTS_LSF_XX_BYTSBZ_002, BJTS_LSF_XX_CKRQ_SB_002, BJTS_LSF_XX_CKRQ_SH_002, BJTS_LSF_XX_CKTMSYWLXDMJH_002, BJTS_LSF_XX_CKSP_DM_SB_002, BJTS_LSF_XX_CKSP_DM_SH_002, BJTS_LSF_XX_CKSL_SB_002, BJTS_LSF_XX_CKSL_002, BJTS_LSF_XX_TSSBSL_002, BJTS_LSF_XX_TYSL_002, BJTS_LSF_XX_SYSL_SH_002, BJTS_LSF_XX_MYLAJ_SB_002, BJTS_LSF_XX_MYLAJ_SH_002, BJTS_LSF_XX_MYLAJ_JS_002, BJTS_LSF_XX_JGFS_DM_002, BJTS_LSF_XX_JGFSTSLX_DM_002, BJTS_LSF_XX_YSFS_DM_002, BJTS_LSF_XX_GLH_002, BJTS_LSF_XX_DYJLDW_DM_002, BJTS_LSF_XX_DEJLDW_DM_002, BJTS_LSF_XX_SBJLDW_DM_002, BJTS_LSF_XX_GFHHGSPMC_002;
    END;
    IF BJTS_CURSOR_DONE_002 THEN
      LEAVE BJTS_CURSOR_LOOP_002;
    END IF;
      BEGIN
        SET LC_YDOBJECT ='代理证明';

        IF BJTS_LSF_XX_BYTSBZ_002='Y' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_DLZM_BYTS','E',
                      ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLZMH_002), ']已被标注为“不予退税”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (BJTS_LSF_XX_CKRQ_SB_002<>BJTS_LSF_XX_CKRQ_SH_002) AND (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'BSQ')=0) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_DLZM_CKRQ','E',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLZMH_002), ']出口日期['), DATE_FORMAT(BJTS_LSF_XX_CKRQ_SB_002, '%Y-%m-%d')), ']与电子信息中['), DATE_FORMAT(BJTS_LSF_XX_CKRQ_SH_002, '%Y-%m-%d')), ']不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        SET LN_CMCD_LEN = CASE WHEN LENGTH(BJTS_LSF_XX_CKSP_DM_SB_002) > LENGTH(BJTS_LSF_XX_CKSP_DM_SH_002) THEN LENGTH(BJTS_LSF_XX_CKSP_DM_SH_002) ELSE LENGTH(BJTS_LSF_XX_CKSP_DM_SB_002) END;
        IF SUBSTR(BJTS_LSF_XX_CKSP_DM_SB_002,1,LN_CMCD_LEN)<>SUBSTR(BJTS_LSF_XX_CKSP_DM_SH_002,1,LN_CMCD_LEN) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_DLZM_SPDM','E',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLZMH_002), ']商品代码['), BJTS_LSF_XX_CKSP_DM_SB_002), ']与电子信息中['), BJTS_LSF_XX_CKSP_DM_SH_002), ']不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (BJTS_LSF_XX_CKSL_SB_002 > BJTS_LSF_XX_CKSL_002 +1) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_DLZM_CKSL','E',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLZMH_002), ']申报退税数量['), BJTS_LSF_XX_CKSL_SB_002), ']超过电子信息中出口数量['), BJTS_LSF_XX_CKSL_002), ']！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        ELSEIF (BJTS_LSF_XX_CKSL_SB_002 > BJTS_LSF_XX_SYSL_SH_002 + 1) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_DLZM_CKSL','I',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLZMH_002), ']申报退税数量['), BJTS_LSF_XX_CKSL_SB_002), ']超过电子信息中剩余数['), BJTS_LSF_XX_SYSL_SH_002), ']（其中出口['), BJTS_LSF_XX_CKSL_002), ']退税申报['), BJTS_LSF_XX_TSSBSL_002), ']退运['), BJTS_LSF_XX_TYSL_002), ']）！'),'Y',CURRENT_TIMESTAMP
;
          COMMIT;
        ELSEIF (ABS(BJTS_LSF_XX_MYLAJ_SB_002-BJTS_LSF_XX_MYLAJ_JS_002)>1 AND ABS(BJTS_LSF_XX_MYLAJ_SB_002-BJTS_LSF_XX_MYLAJ_JS_002)>0.05 * BJTS_LSF_XX_MYLAJ_JS_002) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_DLZM_USDLAJ','I',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLZMH_002), ']美元离岸价['), BJTS_LSF_XX_MYLAJ_SB_002), ']超过电子信息中合理范围，其中剩余数量['), BJTS_LSF_XX_SYSL_SH_002), ']，剩余美元离岸价['), BJTS_LSF_XX_MYLAJ_SH_002), ']，本次申报数量['), BJTS_LSF_XX_CKSL_SB_002), ']！'),'Y',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (TRIM(BJTS_LSF_XX_JGFS_DM_002) IS NULL) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_DLZM_MYXZ_BCZ','E',
                      ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLZMH_002), ']在电子信息中监管方式不存在！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        ELSE
          IF (TRIM(BJTS_LSF_XX_JGFSTSLX_DM_002)='0') THEN
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                        'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_DLZM_MYXZ_BTS','E',
                        ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLZMH_002), ']在电子信息中监管方式['), BJTS_LSF_XX_JGFS_DM_002), ']不退税！'),'N',CURRENT_TIMESTAMP
;
            COMMIT;
          END IF;
        END IF;

        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'DWCB')>0 AND BJTS_LSF_XX_JGFS_DM_002<>'3422' AND BJTS_LSF_XX_JGFS_DM_002<>'22') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_DLZM_DWCB_NOT','E',
                      ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLZMH_002), ']非对外承包业务，“业务类型”不应包含“DWCB”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'DWCB')=0 AND (BJTS_LSF_XX_JGFS_DM_002='3422' OR BJTS_LSF_XX_JGFS_DM_002='22')) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_DLZM_DWCB_NULL','E',
                      ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLZMH_002), ']为对外承包业务，“业务类型”应包含“DWCB”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'BSQ')>0 THEN
          IF BJTS_LSF_XX_YSFS_DM_002<>'0' THEN
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                        'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_DLZM_BSQ_NOT','E',
                        ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLZMH_002), ']非经保税区出口业务，“业务类型”不应包含“BSQ”！'),'N',CURRENT_TIMESTAMP
;
            COMMIT;
          ELSE
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                        'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_DLZM_BSQ_BAQD','I',
                        ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLZMH_002), ']业务类型包含保税区BSQ，请核实是否附送《出境货物备案清单》！'),'Y',CURRENT_TIMESTAMP
;
            COMMIT;
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                        'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_DLZM_BSQ_BANR','I',
                        ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLZMH_002), ']业务类型包含保税区BSQ，请核实出境货物备案清单的内容是否与报关单相关内容相符,出口日期填报是否准确！'),'Y',CURRENT_TIMESTAMP
;
            COMMIT;
          END IF;
        END IF;
        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'BSQ')=0 AND BJTS_LSF_XX_YSFS_DM_002='0') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_DLZM_BSQ_NULL','E',
                      ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLZMH_002), ']为经保税区出口业务，“业务类型”应包含“BSQ”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'JWTZ')>0 AND BJTS_LSF_XX_JGFS_DM_002<>'2210') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_DLZM_JWTZ_NOT','E',
                      ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLZMH_002), ']非境外投资业务，“业务类型”不应包含“JWTZ”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'JWTZ')=0 AND BJTS_LSF_XX_JGFS_DM_002='2210') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_DLZM_JWTZ_NULL','E',
                      ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLZMH_002), ']为境外投资业务，“业务类型”应包含“JWTZ”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'DWYZ')>0 AND BJTS_LSF_XX_JGFS_DM_002<>'3511') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_DLZM_DWYZ_NOT','E',
                      ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLZMH_002), ']非对外援助业务，“业务类型”不应包含“DWYZ”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'DWYZ')=0 AND BJTS_LSF_XX_JGFS_DM_002='3511') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_DLZM_DWYZ_NULL','E',
                      ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLZMH_002), ']为对外援助业务，“业务类型”应包含“DWYZ”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'XLXP')>0 AND BJTS_LSF_XX_JGFS_DM_002<>'1300') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_DLZM_XLXP_NOT','E',
                      ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLZMH_002), ']非修理修配业务，“业务类型”不应包含“XLXP”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'XLXP')=0 AND BJTS_LSF_XX_JGFS_DM_002='1300') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_DLZM_XLXP_NULL','E',
                      ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLZMH_002), ']为修理修配业务，“业务类型”应包含“XLXP”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_YSFS_DM_002='T' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_MTS_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,BJTS_LSF_XX_GLH_002,'MTS_CKMX_CKPZH_YSFS','E',
                      ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLZMH_002), ']为出口到综合试验区（横琴平潭地区）的报关单！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
      END;

      -- 2020.11.11 增加关联号下进货、出口的商品名称、计量单位校验
      SET LC_YDOBJECT ='增值税发票';
      BEGIN
        BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_YY_SBXH_001 LONGTEXT;
  DECLARE BJTS_LSF_YY_GLH_001 LONGTEXT;
  DECLARE BJTS_LSF_YY_JHPZH_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT A.SBXH, A.GLH, A.JHPZH FROM CKTS_SB_MTS_TSJH_LSB A WHERE A.SBID=V_IN_SBID AND A.GLH=BJTS_LSF_XX_GLH_002 AND A.CKTMSPZLX_DM='02';
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_LSF_YY_SBXH_001, BJTS_LSF_YY_GLH_001, BJTS_LSF_YY_JHPZH_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
          BEGIN
            SELECT COUNT(1)
              INTO LN_MXROW
              FROM CKTS_WBSJ_FP_ZZSFPHWXX B
             WHERE B.DJXH=V_IN_DJXH AND B.JHPZH=BJTS_LSF_YY_JHPZH_001;
            IF LN_MXROW>0 THEN
              SET BJTS_ITERATE_001 = FALSE;
    BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
                  INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                       SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                              'CKTS_SB_MTS_TSJH_LSB',NULL,NULL,BJTS_LSF_YY_SBXH_001,BJTS_LSF_YY_GLH_001,'MTS_JHMX_ZZSFP_SPMC_DLZM','I',
                              ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('增值税专用发票[', BJTS_LSF_YY_JHPZH_001), ']商品名称与代理证明商品名称['), BJTS_LSF_XX_GFHHGSPMC_002), ']不一致，请核对确认！'),'Y',CURRENT_TIMESTAMP
;
                  COMMIT;

  END;

  DECLARE EXIT HANDLER FOR 1172
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
                  INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                       SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                              'CKTS_SB_MTS_TSJH_LSB',NULL,NULL,BJTS_LSF_YY_SBXH_001,BJTS_LSF_YY_GLH_001,'MTS_JHMX_ZZSFP_SPMC_JLDW','I',
                              ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('增值税专用发票[', BJTS_LSF_YY_JHPZH_001), ']存在同一商品名称['), BJTS_LSF_XX_GFHHGSPMC_002), ']但计量单位不同的情形，请核对确认！'),'Y',CURRENT_TIMESTAMP
;
                  COMMIT;

  END;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
                  SET BJTS_ITERATE_001 = TRUE;

  END;
SELECT DISTINCT B.JLDWMC
                  INTO LC_JHPZHJLDW
                  FROM CKTS_WBSJ_FP_ZZSFPHWXX B
                 WHERE B.DJXH=V_IN_DJXH AND B.JHPZH=BJTS_LSF_YY_JHPZH_001 AND B.GFHHWHYSLWMC=BJTS_LSF_XX_GFHHGSPMC_002;

                IF FUNC_XXBD_CHECK_JLDW(LC_JHPZHJLDW,BJTS_LSF_XX_DYJLDW_DM_002)=0 AND FUNC_XXBD_CHECK_JLDW(LC_JHPZHJLDW,BJTS_LSF_XX_DEJLDW_DM_002)=0 AND FUNC_XXBD_CHECK_JLDW(LC_JHPZHJLDW,BJTS_LSF_XX_SBJLDW_DM_002)=0 THEN
                  INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                       SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                              'CKTS_SB_MTS_TSJH_LSB',NULL,NULL,BJTS_LSF_YY_SBXH_001,BJTS_LSF_YY_GLH_001,'MTS_JHMX_ZZSFP_JLDW_DLZM','I',
                              ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('增值税专用发票[', BJTS_LSF_YY_JHPZH_001), ']的计量单位['), LC_JHPZHJLDW), ']与代理证明计量单位不符，请核对确认！'),'Y',CURRENT_TIMESTAMP
;
                  COMMIT;
                END IF;
              END;
  IF BJTS_ITERATE_001 THEN
    ITERATE BJTS_CURSOR_LOOP_001;
  END IF;
            END IF;
          END;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;
      END;

  END LOOP BJTS_CURSOR_LOOP_002;
  CLOSE BJTS_CURSOR_002;
END;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_MTS_TSSB_DLZM.sql

-- ======================================================================
-- [077/114] BEGIN SOURCE: PROC_XXBD_TSZM_CKHWZNXZM.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_TSZM_CKHWZNXZM$$

CREATE PROCEDURE PROC_XXBD_TSZM_CKHWZNXZM
/*
  编制人:严国平
  编制日期:202010
  功能:信息比对（出口货物转内销证明）
  调整日期：20230207，1、根据全电票规则调整发票的关联，用JHPZH代替FPDM+FPHM
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE BJTS_ROUTINE_EXIT BOOLEAN DEFAULT FALSE;
  DECLARE LDT_TODAY    DATETIME;

  DECLARE LC_QYHGDM       VARCHAR(20);
  DECLARE LC_QYLXDM       VARCHAR(20);
  DECLARE LC_TSJSFSDM     VARCHAR(20);
  DECLARE LC_WMZHFWQYBZ   VARCHAR(20);
  DECLARE LC_SFYSFW       VARCHAR(20);
  DECLARE LC_YSFW         VARCHAR(50);
  DECLARE LC_YSFS         VARCHAR(50);
  DECLARE LC_YFSJ         VARCHAR(50);
  DECLARE LC_ZXFLAG       VARCHAR(20);

  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LN_ROWNUM_TSSB  BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  IF V_IN_SSSQ>DATE_FORMAT(CURRENT_TIMESTAMP, '%Y%m') THEN
    BEGIN
      SET V_OUT_STATUS ='05';
      SET V_OUT_MESSAGE ='申报所属时期超出合理范围！';
      LEAVE routine_body;
    END;
  END IF;

  -- 取各申报明细表数据记录
  BEGIN
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='06';
      SET V_OUT_MESSAGE ='查询申报记录数据失败！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT COUNT(1)
      INTO LN_ROWNUM_TSSB
      FROM CKTS_ZM_CKHWZNX_LSB
     WHERE SBID=V_IN_SBID;
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LN_ROWNUM_TSSB=0 THEN
    BEGIN
      SET V_OUT_STATUS ='07';
      SET V_OUT_MESSAGE ='申报数据为空！';
      LEAVE routine_body;
    END;
  END IF;

  -- 查询企业基本信息
  BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='08';
      SET V_OUT_MESSAGE ='企业当前未进行出口退（免）税备案，不允许申报除出口退（免）税备案以外的其他业务！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT T.QYHGDM, T.QYLX_DM, T.TSJSFS_DM, T.WMZHFWQYBZ, T.SFYSFW, T.YSFW, T.YSFS, T.YFSJ, T.ZX_FLAG
      INTO LC_QYHGDM, LC_QYLXDM, LC_TSJSFSDM, LC_WMZHFWQYBZ, LC_SFYSFW, LC_YSFW, LC_YSFS, LC_YFSJ, LC_ZXFLAG
      FROM GS_DJ_CKTMSDAB T
     WHERE T.NSRDZDAH=V_IN_NSRDZDAH;
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LC_ZXFLAG='R' THEN
    BEGIN
      SET V_OUT_STATUS ='09';
      SET V_OUT_MESSAGE ='企业当前已出口退（免）税备案撤回，不允许申报除出口退（免）税备案以外的其他业务！';
      LEAVE routine_body;
    END;
  END IF;

  -- 取企业的FLGLCD信息, TGSHZL信息，判断是否需要申报收汇
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',LDT_TODAY,LC_FLGLCD, LN_CPCODEKZ);
  IF LN_CPCODEKZ=0 THEN
    BEGIN
      SET V_OUT_STATUS ='10';
      SET V_OUT_MESSAGE ='查询出口企业分类管理类型出错！';
      LEAVE routine_body;
    END;
  END IF;

  IF LC_QYLXDM<>'3' OR LC_TSJSFSDM<>'2' THEN
    BEGIN
      SET V_OUT_STATUS ='11';
      SET V_OUT_MESSAGE ='备案信息中企业类型、退免税计算方法与当前申报业务冲突！';
      LEAVE routine_body;
    END;
  END IF;

  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'YBNSRRD',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=0 THEN
    BEGIN
      SET V_OUT_STATUS ='12';
      SET V_OUT_MESSAGE ='企业当前非增值税一般纳税人，不允许申报出口退（免）税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TQQY',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 THEN
    BEGIN
      SET V_OUT_STATUS ='13';
      SET V_OUT_MESSAGE ='企业当前处于出口退税停权期间，不允许申报出口退（免）税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTSSXMS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_TSSB>0 THEN
    BEGIN
      SET V_OUT_STATUS ='14';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权选择免税期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTSSXZS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_TSSB>0 THEN
    BEGIN
      SET V_OUT_STATUS ='15';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权选择征税期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTMS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_TSSB>0 THEN
    BEGIN
      SET V_OUT_STATUS ='16';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;

  SET LC_YDOBJECT ='出口转内销';
  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_ZM_CKHWZNX_LSB',NULL,NULL,T.SBXH,NULL,'TSZM_CKNX_ZZSFP_WDZXX','E',ORA_CONCAT(ORA_CONCAT('原购货发票[', T.YGHPZH), ']无电子信息！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_ZM_CKHWZNX_LSB T
          WHERE T.SBID=V_IN_SBID
            AND (LENGTH(T.YGHPZH)=18 OR LENGTH(T.YGHPZH)=20)
            AND NOT EXISTS (SELECT 1
                              FROM CKTS_WBSJ_FP_ZZSZYFPXX S
                             WHERE S.DJXH=V_IN_DJXH
                               AND S.JHPZH=T.YGHPZH);
    COMMIT;

    BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_YGHPZH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_SBXH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_KPRQ_SB_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_GHJE_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_KDKSE_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_KPRQ_SH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_SYJE_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_SYSE_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_JCJHBFBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_YCKSPZBZ_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT A.YGHPZH, A.SBXH, A.KPRQ_SB, A.GHJE, A.KDKSE,
                          DATE(B.KPRQ) AS KPRQ_SH, B.JE-B.SBFPJSJE AS SYJE, B.SE-B.SBFPSJSK AS SYSE,
                          B.JCJHBFBZ, B.YCKSPZBZ
                     FROM (SELECT YGHPZH,
                                  MIN(SBXH) AS SBXH,
                                  DATE(MIN(GHKPRQ)) AS KPRQ_SB,
                                  SUM(GHJE) AS GHJE,
                                  SUM(KDKSE) AS KDKSE
                             FROM CKTS_ZM_CKHWZNX_LSB
                            WHERE SBID=V_IN_SBID
                              AND LENGTH(YGHPZH) IN (18,20)
                            GROUP BY YGHPZH, FPDM, FPHM) A
                    INNER JOIN CKTS_WBSJ_FP_ZZSZYFPXX B ON B.DJXH=V_IN_DJXH AND B.JHPZH=A.YGHPZH;
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_LSF_XX_YGHPZH_001, BJTS_LSF_XX_SBXH_001, BJTS_LSF_XX_KPRQ_SB_001, BJTS_LSF_XX_GHJE_001, BJTS_LSF_XX_KDKSE_001, BJTS_LSF_XX_KPRQ_SH_001, BJTS_LSF_XX_SYJE_001, BJTS_LSF_XX_SYSE_001, BJTS_LSF_XX_JCJHBFBZ_001, BJTS_LSF_XX_YCKSPZBZ_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
      BEGIN
        IF BJTS_LSF_XX_KPRQ_SB_001<>BJTS_LSF_XX_KPRQ_SH_001 THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_ZM_CKHWZNX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'TSZM_CKNX_ZZSFP_KPRQ','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('原购货发票[', BJTS_LSF_XX_YGHPZH_001), ']开票日期['), DATE_FORMAT(BJTS_LSF_XX_KPRQ_SB_001, '%Y-%m-%d')), ']与电子信息中['), DATE_FORMAT(BJTS_LSF_XX_KPRQ_SH_001, '%Y-%m-%d')), ']不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_GHJE_001>BJTS_LSF_XX_SYJE_001 THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_ZM_CKHWZNX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'TSZM_CKNX_ZZSFP_JHJE','I',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('原购货发票[', BJTS_LSF_XX_YGHPZH_001), ']申报金额['), BJTS_LSF_XX_GHJE_001), ']大于电子信息中剩余数['), BJTS_LSF_XX_SYJE_001), ']！'),'Y',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_KDKSE_001>BJTS_LSF_XX_SYSE_001 THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_ZM_CKHWZNX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'TSZM_CKNX_ZZSFP_NXSE','I',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('原购货发票[', BJTS_LSF_XX_YGHPZH_001), ']申报可抵扣税额['), BJTS_LSF_XX_KDKSE_001), ']大于电子信息中剩余数['), BJTS_LSF_XX_SYSE_001), ']！'),'Y',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_JCJHBFBZ_001='Y' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_ZM_CKHWZNX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'TSZM_CKNX_ZZSFP_JCJHBF','E',ORA_CONCAT(ORA_CONCAT('原购货发票[', BJTS_LSF_XX_YGHPZH_001), ']为“交叉稽核不符发票”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_YCKSPZBZ_001='Y' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_ZM_CKHWZNX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'TSZM_CKNX_ZZSFP_YCDKPZ','I',ORA_CONCAT(ORA_CONCAT('原购货发票[', BJTS_LSF_XX_YGHPZH_001), ']为“异常抵扣凭证”！'),'Y',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
      END;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_TSZM_CKHWZNXZM.sql

-- ======================================================================
-- [078/114] BEGIN SOURCE: PROC_XXBD_TSZM_DLCKHWZM.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_TSZM_DLCKHWZM$$

CREATE PROCEDURE PROC_XXBD_TSZM_DLCKHWZM
/*
  编制人:严国平
  编制日期:202010
  功能:信息比对（代理出口货物证明）
  调整日期：20201221，1、调整TSZM_DLCK_CKSL_BYZ疑点，提示信息精确化，加出口数量、退税数量、退运数量、代理数量；
                      2、调整TSZM_DLCK_JLDW_BYZ疑点，取消与报关单第一计量单位名称（金三中为NULL）的比较，改用第一计量单位代码对应名称集比较；
                      3、恢复TSZM_DLCK_CKRQ_TQQY疑点，具体出口日期采用报关单电子信息中的出口日期；
                      4、增加TSZM_DLCK_WTFNSH_NULL提示性疑点；
  调整日期：20201222，1、增加TSZM_DLCK_CKRQ_BYZ错误性疑点；
  调整日期：20201225，1、增加TSZM_DLCK_CKDJ_BYZ提示性疑点。
  调整日期：20201228，1、增加TSZM_BJGX_DLCK_WZFZG提示性疑点(电子税务局已实现，兼容离线版申报自检）。TSZM_DLCK_CKRQ_BYZ
  调整日期：20210526，1、调整疑点TSZM_DLCK_CKRQ_BYZ内容的日期格式，限定为YYYY-MM-DD。
  调整日期：20210715，1、调整疑点TSZM_DLCK_WTFNSR_NULL判断逻辑，先判断本地企业再判断全国备案信息
  调整日期：20210923，1、调整疑点TSZM_DLCK_BTSSP_WTZM判断逻辑，增加委托方税号与代理出口证明中社会信用代码的关联
  调整日期：20211011，1、调整疑点TSZM_DLCK_BTSSP_WTZM判断逻辑，针对10位商品代码为取消退税商品且不为基本商品，如果11位扩展码存在退税则不跳疑点，否则照旧。
  调整日期：20211020，1、调整疑点TSZM_DLCK_BTSSP_SPDM判断逻辑，针对委托证明存在8位商品代码的情况，按委托证明、代理证明商品代码长度短的部分进行判断
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE BJTS_ROUTINE_EXIT BOOLEAN DEFAULT FALSE;
  DECLARE LDT_TODAY    DATETIME;

  DECLARE LC_QYHGDM       VARCHAR(20);
  DECLARE LC_QYLXDM       VARCHAR(20);
  DECLARE LC_TSJSFSDM     VARCHAR(20);
  DECLARE LC_WMZHFWQYBZ   VARCHAR(20);
  DECLARE LC_SFYSFW       VARCHAR(20);
  DECLARE LC_YSFW         VARCHAR(50);
  DECLARE LC_YSFS         VARCHAR(50);
  DECLARE LC_YFSJ         VARCHAR(50);
  DECLARE LC_ZXFLAG       VARCHAR(20);

  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LN_ROWNUM_TSSB  BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);

  DECLARE LN_DJ1          DECIMAL(38,10);
  DECLARE LN_DJ2          DECIMAL(38,10);

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  IF V_IN_SSSQ>DATE_FORMAT(CURRENT_TIMESTAMP, '%Y%m') THEN
    BEGIN
      SET V_OUT_STATUS ='05';
      SET V_OUT_MESSAGE ='申报所属时期超出合理范围！';
      LEAVE routine_body;
    END;
  END IF;

  -- 取各申报明细表数据记录
  BEGIN
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='06';
      SET V_OUT_MESSAGE ='查询申报记录数据失败！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT COUNT(1)
      INTO LN_ROWNUM_TSSB
      FROM CKTS_ZM_DLCK_LSB
     WHERE SBID=V_IN_SBID;
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LN_ROWNUM_TSSB=0 THEN
    BEGIN
      SET V_OUT_STATUS ='07';
      SET V_OUT_MESSAGE ='申报数据为空！';
      LEAVE routine_body;
    END;
  END IF;

  -- 查询企业基本信息
  BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='08';
      SET V_OUT_MESSAGE ='企业当前未进行出口退（免）税备案，不允许申报除出口退（免）税备案以外的其他业务！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT T.QYHGDM, T.QYLX_DM, T.TSJSFS_DM, T.WMZHFWQYBZ, T.SFYSFW, T.YSFW, T.YSFS, T.YFSJ, T.ZX_FLAG
      INTO LC_QYHGDM, LC_QYLXDM, LC_TSJSFSDM, LC_WMZHFWQYBZ, LC_SFYSFW, LC_YSFW, LC_YSFS, LC_YFSJ, LC_ZXFLAG
      FROM GS_DJ_CKTMSDAB T
     WHERE T.NSRDZDAH=V_IN_NSRDZDAH;
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LC_ZXFLAG='R' THEN
    BEGIN
      SET V_OUT_STATUS ='09';
      SET V_OUT_MESSAGE ='企业当前已出口退（免）税备案撤回，不允许申报除出口退（免）税备案以外的其他业务！';
      LEAVE routine_body;
    END;
  END IF;

  -- 取企业的FLGLCD信息, TGSHZL信息，判断是否需要申报收汇
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',LDT_TODAY,LC_FLGLCD, LN_CPCODEKZ);
  IF LN_CPCODEKZ=0 THEN
    BEGIN
      SET V_OUT_STATUS ='10';
      SET V_OUT_MESSAGE ='查询出口企业分类管理类型出错！';
      LEAVE routine_body;
    END;
  END IF;

  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'YBNSRRD',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=0 THEN
    BEGIN
      SET V_OUT_STATUS ='12';
      SET V_OUT_MESSAGE ='企业当前非增值税一般纳税人，不允许申报出口退（免）税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TQQY',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 THEN
    BEGIN
      SET V_OUT_STATUS ='13';
      SET V_OUT_MESSAGE ='企业当前处于出口退税停权期间，不允许申报出口退（免）税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTSSXMS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_TSSB>0 THEN
    BEGIN
      SET V_OUT_STATUS ='14';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权选择免税期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTSSXZS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_TSSB>0 THEN
    BEGIN
      SET V_OUT_STATUS ='15';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权选择征税期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTMS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_TSSB>0 THEN
    BEGIN
      SET V_OUT_STATUS ='16';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;

  SET LC_YDOBJECT ='代理出口';
  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_ZM_DLCK_LSB',NULL,NULL,T.SBXH,NULL,'TSZM_DLCK_BGD_WDZXX','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), ']无电子信息！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_ZM_DLCK_LSB T
          WHERE T.SBID=V_IN_SBID
            AND NOT EXISTS (SELECT 1 FROM CKTS_WBSJ_HG_BGD201 S WHERE S.DJXH=V_IN_DJXH AND S.CKBGDH=T.CKBGDH);
    COMMIT;

    BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_SBXH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKBGDH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKRQ_SB_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKRQ_SH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSP_DM_SB_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSP_DM_SH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSL_SB_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSL_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TSSBSL_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TYSL_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_DLSBSL_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_SYSL_SH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_MYLAJ_SB_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_MYLAJ_SH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_HGJLDWMC_SB_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_HGJLDWMC_WK_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSP_DM_QXTS_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_WTCKHWZMBH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSP_DM_WT_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TQQY_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_WTQY_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_BZ_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT A.SBXH,
                          A.CKBGDH,
                          DATE(A.CKRQ_1) AS CKRQ_SB,
                          DATE(B.CKRQ_1) AS CKRQ_SH,
                          A.CKSP_DM AS CKSP_DM_SB,
                          B.CKSP_DM AS CKSP_DM_SH,
                          A.CKSL AS CKSL_SB,
                          B.CKSL,
                          IFNULL(B.TSSBSL, 0) AS TSSBSL,
                          IFNULL(B.TYSL, 0) AS TYSL,
                          IFNULL(B.DLSBSL, 0) AS DLSBSL,
                          GREATEST(0, B.CKSL-IFNULL(B.TSSBSL, 0)-IFNULL(B.TYSL, 0)-IFNULL(B.DLSBSL, 0)) AS SYSL_SH,
                          A.MYLAJ AS MYLAJ_SB,
                          GREATEST(0, B.MYLAJ-IFNULL(B.TSSBMYLAJ, 0)-IFNULL(B.DLSBMYLAJ, 0)-IFNULL(B.TYMYLAJ, 0)) AS MYLAJ_SH,
                          TRIM(UPPER(A.HGJLDWMC)) AS HGJLDWMC_SB,
                          F.HGJLDWQC AS HGJLDWMC_WK,
                          IFNULL(C.CKSP_DM, D.CKSP_DM) AS CKSP_DM_QXTS,
                          E.WTCKHWZMBH,
                          E.CKSP_DM AS CKSP_DM_WT,
                          G.UUID AS TQQY,
                          IFNULL(I.NSRSBH, H.UUID) AS WTQY,
                          A.BZ
                     FROM CKTS_ZM_DLCK_LSB A
                    INNER JOIN CKTS_WBSJ_HG_BGD201 B ON B.DJXH=V_IN_DJXH AND B.CKBGDH=A.CKBGDH
                     LEFT JOIN CKTS_DM_TSLVWK C ON C.CKSP_DM=A.CKSP_DM AND (B.CKRQ_1 BETWEEN C.YXQQ AND C.YXQZ) AND C.ZSSL>0 AND C.TSL=0 AND C.CKSPTSSPLX_DM='1'
                     LEFT JOIN CKTS_DM_TSLVWK D ON D.CKSP_DM=SUBSTR(A.CKSP_DM,1,8) AND (B.CKRQ_1 BETWEEN D.YXQQ AND D.YXQZ) AND D.ZSSL>0 AND D.TSL=0 AND D.CKSPTSSPLX_DM='1'
                     LEFT JOIN CKTS_WBSJ_ZJ_WTCKHWZM E ON E.DJXH=V_IN_DJXH AND (E.WTFNSRSBH=A.WTFNSRSBH OR E.WTFSHXYDM=A.WTFNSRSBH) AND E.WTCKHWZMBH=A.WTCKHWZMBH
                    INNER JOIN CKTS_DM_HGJLDW F ON F.HGJLDW_DM=B.DYJLDW_DM
                     LEFT JOIN GS_DJ_CKTMSDAB_KZ G ON G.NSRDZDAH=V_IN_NSRDZDAH AND G.KZLX='TQQY' AND G.FLAG='1' AND (B.CKRQ_1 BETWEEN G.ST_DATE AND G.END_DATE)
                     LEFT JOIN CKTS_WBSJ_ZJ_CKTSBAQGXX H ON H.NSRSBH=A.WTFNSRSBH OR H.SHXYDM=A.WTFNSRSBH
                     LEFT JOIN GS_DJ_CKTMSDAB I ON I.NSRDJNO=A.WTFNSRSBH OR I.SHXYNO=A.WTFNSRSBH
                    WHERE A.SBID=V_IN_SBID;
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_LSF_XX_SBXH_001, BJTS_LSF_XX_CKBGDH_001, BJTS_LSF_XX_CKRQ_SB_001, BJTS_LSF_XX_CKRQ_SH_001, BJTS_LSF_XX_CKSP_DM_SB_001, BJTS_LSF_XX_CKSP_DM_SH_001, BJTS_LSF_XX_CKSL_SB_001, BJTS_LSF_XX_CKSL_001, BJTS_LSF_XX_TSSBSL_001, BJTS_LSF_XX_TYSL_001, BJTS_LSF_XX_DLSBSL_001, BJTS_LSF_XX_SYSL_SH_001, BJTS_LSF_XX_MYLAJ_SB_001, BJTS_LSF_XX_MYLAJ_SH_001, BJTS_LSF_XX_HGJLDWMC_SB_001, BJTS_LSF_XX_HGJLDWMC_WK_001, BJTS_LSF_XX_CKSP_DM_QXTS_001, BJTS_LSF_XX_WTCKHWZMBH_001, BJTS_LSF_XX_CKSP_DM_WT_001, BJTS_LSF_XX_TQQY_001, BJTS_LSF_XX_WTQY_001, BJTS_LSF_XX_BZ_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
      BEGIN
        IF (BJTS_LSF_XX_CKSP_DM_SB_001<>BJTS_LSF_XX_CKSP_DM_SH_001) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_ZM_DLCK_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'TSZM_DLCK_SPDM_BYZ','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']商品代码['), BJTS_LSF_XX_CKSP_DM_SB_001), ']与电子信息中['), BJTS_LSF_XX_CKSP_DM_SH_001), ']不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (BJTS_LSF_XX_CKRQ_SB_001<>BJTS_LSF_XX_CKRQ_SH_001) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_ZM_DLCK_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'TSZM_DLCK_CKRQ_BYZ','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']出口日期['), DATE_FORMAT(BJTS_LSF_XX_CKRQ_SB_001, '%Y-%m-%d')), ']与电子信息中['), DATE_FORMAT(BJTS_LSF_XX_CKRQ_SH_001, '%Y-%m-%d')), ']不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (BJTS_LSF_XX_CKSL_SB_001>BJTS_LSF_XX_SYSL_SH_001) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_ZM_DLCK_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'TSZM_DLCK_CKSL_BYZ','E',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']申报数量['), BJTS_LSF_XX_CKSL_SB_001), ']超过电子信息中剩余数['), BJTS_LSF_XX_SYSL_SH_001), ']（其中出口['), BJTS_LSF_XX_CKSL_001), ']退税申报['), BJTS_LSF_XX_TSSBSL_001), ']退运['), BJTS_LSF_XX_TYSL_001), ']代理申报['), BJTS_LSF_XX_DLSBSL_001), ']）！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (BJTS_LSF_XX_MYLAJ_SB_001 >= BJTS_LSF_XX_MYLAJ_SH_001 + 1) AND (BJTS_LSF_XX_MYLAJ_SB_001 >= BJTS_LSF_XX_MYLAJ_SH_001 * 1.05) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_ZM_DLCK_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'TSZM_DLCK_USDJE_OVER','W',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']申报美元离岸价['), BJTS_LSF_XX_MYLAJ_SB_001), ']大于电子信息中剩余数['), BJTS_LSF_XX_MYLAJ_SH_001), ']！'),'Y',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (BJTS_LSF_XX_MYLAJ_SB_001 <= BJTS_LSF_XX_MYLAJ_SH_001 - 1) AND (BJTS_LSF_XX_MYLAJ_SB_001 <= BJTS_LSF_XX_MYLAJ_SH_001 * 0.95) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_ZM_DLCK_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'TSZM_DLCK_USDJE_LOW','W',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']申报美元离岸价['), BJTS_LSF_XX_MYLAJ_SB_001), ']小于电子信息中剩余数['), BJTS_LSF_XX_MYLAJ_SH_001), ']！'),'Y',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        SET LN_DJ1 = FUNC_XXBD_COMPUTE_CHUFA(BJTS_LSF_XX_MYLAJ_SB_001, BJTS_LSF_XX_CKSL_SB_001);
        SET LN_DJ2 = FUNC_XXBD_COMPUTE_CHUFA(BJTS_LSF_XX_MYLAJ_SH_001, BJTS_LSF_XX_SYSL_SH_001);
        IF (LN_DJ1 > LN_DJ2 * 1.05) OR (LN_DJ1 < LN_DJ2 * 0.95) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_ZM_DLCK_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'TSZM_DLCK_CKDJ_BYZ','W',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']申报单价与海关信息不匹配！'),'Y',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF INSTR(ORA_CONCAT(ORA_CONCAT('.', BJTS_LSF_XX_HGJLDWMC_WK_001), '.'), ORA_CONCAT(ORA_CONCAT('.', BJTS_LSF_XX_HGJLDWMC_SB_001), '.'))=0 THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_ZM_DLCK_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'TSZM_DLCK_JLDW_BYZ','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']申报计量单位['), BJTS_LSF_XX_HGJLDWMC_SB_001), ']与报关单第一计量单位不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (BJTS_LSF_XX_CKSP_DM_QXTS_001 IS NOT NULL) THEN
          IF (BJTS_LSF_XX_WTCKHWZMBH_001 IS NULL) THEN
            SELECT COUNT(1)
              INTO LN_ROWNUM_TSSB
              FROM CKTS_DM_TSLVWK T
             WHERE T.CKSP_DM LIKE ORA_CONCAT(BJTS_LSF_XX_CKSP_DM_QXTS_001, '%')
               AND (BJTS_LSF_XX_CKRQ_SB_001 BETWEEN T.YXQQ AND T.YXQZ)
               AND (T.ZSSL=0 OR T.TSL>0);
            IF LN_ROWNUM_TSSB=0 THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_ZM_DLCK_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'TSZM_DLCK_BTSSP_WTZM','W',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']商品代码['), BJTS_LSF_XX_CKSP_DM_SB_001), ']为取消退税商品，未找到对应的委托证明信息！'),'Y',CURRENT_TIMESTAMP
;
              COMMIT;
            END IF;
          ELSE
            SET LN_ROWNUM_TSSB = LEAST(LENGTH(BJTS_LSF_XX_CKSP_DM_SB_001),LENGTH(BJTS_LSF_XX_CKSP_DM_WT_001));
            IF (SUBSTR(BJTS_LSF_XX_CKSP_DM_SB_001,1,LN_ROWNUM_TSSB)<>SUBSTR(BJTS_LSF_XX_CKSP_DM_WT_001,1,LN_ROWNUM_TSSB)) THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_ZM_DLCK_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'TSZM_DLCK_BTSSP_SPDM','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']商品代码['), BJTS_LSF_XX_CKSP_DM_SB_001), ']与委托出口货物证明的同一报关单的商品代码['), BJTS_LSF_XX_CKSP_DM_WT_001), ']不一致！'),'N',CURRENT_TIMESTAMP
;
              COMMIT;
            END IF;
          END IF;
        END IF;

        IF (BJTS_LSF_XX_TQQY_001 IS NOT NULL) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_ZM_DLCK_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'TSZM_DLCK_CKRQ_TQQY','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']对应出口日期为被停止出口退税权期间，不得办理《代理出口证明》！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (BJTS_LSF_XX_WTQY_001 IS NULL) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_ZM_DLCK_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'TSZM_DLCK_WTFNSR_NULL','W','未查询到委托企业信息，请核实委托企业纳税社会信用码（识别号）是否准确！','Y',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF LC_WMZHFWQYBZ='Y' AND INSTR(BJTS_LSF_XX_BZ_001, 'WMZHFW')=0 THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_ZM_DLCK_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'TSZM_BJGX_DLCK_WZFZG','W','外综服企业申请开具代理出口货物证明，备注栏未录入“WMZHFW”标识”，请确认！','Y',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
      END;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_TSZM_DLCKHWZM.sql

-- ======================================================================
-- [079/114] BEGIN SOURCE: PROC_XXBD_TSZM_TYYBSWTS.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_TSZM_TYYBSWTS$$

CREATE PROCEDURE PROC_XXBD_TSZM_TYYBSWTS
/*
  编制人:严国平
  编制日期:202010
  功能:信息比对（退运已补税未退税证明）
  调整日期：20211025，根据金三H65**疑点，调整部分疑点级别，由错误类疑点改为警告类疑点
  调整日期：20211215，根据临安生产企业已办理退免税后改单导致后续免抵退申报退运冲减无法正常进行的问题，咨询魏浩原业务思路（默认改单或撤单的都是未办理退免税的），增加疑点判断
  调整日期：20230511，1、根据全电票规则调整发票的关联，用JHPZH代替FPDM+FPHM
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE BJTS_ROUTINE_EXIT BOOLEAN DEFAULT FALSE;
  DECLARE LDT_TODAY    DATETIME;

  DECLARE LC_QYHGDM       VARCHAR(20);
  DECLARE LC_QYLXDM       VARCHAR(20);
  DECLARE LC_TSJSFSDM     VARCHAR(20);
  DECLARE LC_WMZHFWQYBZ   VARCHAR(20);
  DECLARE LC_SFYSFW       VARCHAR(20);
  DECLARE LC_YSFW         VARCHAR(50);
  DECLARE LC_YSFS         VARCHAR(50);
  DECLARE LC_YFSJ         VARCHAR(50);
  DECLARE LC_ZXFLAG       VARCHAR(20);

  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LN_ROWNUM_TSSB  BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  IF V_IN_SSSQ>DATE_FORMAT(CURRENT_TIMESTAMP, '%Y%m') THEN
    BEGIN
      SET V_OUT_STATUS ='05';
      SET V_OUT_MESSAGE ='申报所属时期超出合理范围！';
      LEAVE routine_body;
    END;
  END IF;

  -- 取各申报明细表数据记录
  BEGIN
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='06';
      SET V_OUT_MESSAGE ='查询申报记录数据失败！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT COUNT(1)
      INTO LN_ROWNUM_TSSB
      FROM CKTS_ZM_TYYBSWTS_LSB
     WHERE SBID=V_IN_SBID;
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LN_ROWNUM_TSSB=0 THEN
    BEGIN
      SET V_OUT_STATUS ='07';
      SET V_OUT_MESSAGE ='申报数据为空！';
      LEAVE routine_body;
    END;
  END IF;

  -- 查询企业基本信息
  BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='08';
      SET V_OUT_MESSAGE ='企业当前未进行出口退（免）税备案，不允许申报除出口退（免）税备案以外的其他业务！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT T.QYHGDM, T.QYLX_DM, T.TSJSFS_DM, T.WMZHFWQYBZ, T.SFYSFW, T.YSFW, T.YSFS, T.YFSJ, T.ZX_FLAG
      INTO LC_QYHGDM, LC_QYLXDM, LC_TSJSFSDM, LC_WMZHFWQYBZ, LC_SFYSFW, LC_YSFW, LC_YSFS, LC_YFSJ, LC_ZXFLAG
      FROM GS_DJ_CKTMSDAB T
     WHERE T.NSRDZDAH=V_IN_NSRDZDAH;
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LC_ZXFLAG='R' THEN
    BEGIN
      SET V_OUT_STATUS ='09';
      SET V_OUT_MESSAGE ='企业当前已出口退（免）税备案撤回，不允许申报除出口退（免）税备案以外的其他业务！';
      LEAVE routine_body;
    END;
  END IF;

  -- 取企业的FLGLCD信息, TGSHZL信息，判断是否需要申报收汇
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',LDT_TODAY,LC_FLGLCD, LN_CPCODEKZ);
  IF LN_CPCODEKZ=0 THEN
    BEGIN
      SET V_OUT_STATUS ='10';
      SET V_OUT_MESSAGE ='查询出口企业分类管理类型出错！';
      LEAVE routine_body;
    END;
  END IF;

  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'YBNSRRD',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=0 THEN
    BEGIN
      SET V_OUT_STATUS ='12';
      SET V_OUT_MESSAGE ='企业当前非增值税一般纳税人，不允许申报出口退（免）税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TQQY',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 THEN
    BEGIN
      SET V_OUT_STATUS ='13';
      SET V_OUT_MESSAGE ='企业当前处于出口退税停权期间，不允许申报出口退（免）税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTSSXMS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_TSSB>0 THEN
    BEGIN
      SET V_OUT_STATUS ='14';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权选择免税期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTSSXZS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_TSSB>0 THEN
    BEGIN
      SET V_OUT_STATUS ='15';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权选择征税期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTMS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_TSSB>0 THEN
    BEGIN
      SET V_OUT_STATUS ='16';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;

  SET LC_YDOBJECT ='退运证明';
  BEGIN
    -- 报关单
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_ZM_TYYBSWTS_LSB',NULL,NULL,T.SBXH,NULL,'TSZM_TYBS_BGD_WDZXX','I',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), ']无电子信息！'),'Y',CURRENT_TIMESTAMP
           FROM CKTS_ZM_TYYBSWTS_LSB T
          WHERE T.SBID=V_IN_SBID
            AND LENGTH(T.CKBGDH)=21
            AND NOT EXISTS (SELECT 1 FROM CKTS_WBSJ_HG_BGD201 S WHERE S.DJXH=V_IN_DJXH AND S.CKBGDH=T.CKBGDH);
    COMMIT;

    BEGIN
  DECLARE BJTS_CURSOR_DONE_002 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_SBXH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKBGDH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKRQ_SH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_TMSZTBZ_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_TYYBSWTSTYLX_DM_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_TSSBSL_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_TYSL_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_KTYSL_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_TYYBSWTSTYLXDM_C_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_DLSBSL_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKHWTYYBSWTSZMBH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_QYGBZ_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_QYGWDDBZ_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_QYGCXCKBZ_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_UUID_002 LONGTEXT;
  DECLARE BJTS_CURSOR_002 CURSOR FOR
SELECT A.SBXH,
                          A.CKBGDH,
                          DATE(B.CKRQ_1) AS CKRQ_SH,
                          A.TMSZTBZ,
                          A.TYYBSWTSTYLX_DM,
                          B.TSSBSL,
                          A.TYSL,
                          B.CKSL-B.TYSL AS KTYSL,
                          C.TYYBSWTSTYLX_DM AS TYYBSWTSTYLXDM_C,
                          B.DLSBSL,
                          D.CKHWTYYBSWTSZMBH,
                          B.QYGBZ,
                          B.QYGWDDBZ,
                          B.QYGCXCKBZ,
                          E.UUID
                     FROM CKTS_ZM_TYYBSWTS_LSB A
                    INNER JOIN CKTS_WBSJ_HG_BGD201 B ON B.DJXH=V_IN_DJXH AND B.CKBGDH=A.CKBGDH
                     LEFT JOIN CKTS_WBSJ_HG_ZLKZDCLXX_JGB C ON C.DJXH=V_IN_DJXH AND C.CKBGDH=A.CKBGDH
                     LEFT JOIN CKTS_WBSJ_ZJ_TYYBSWTSZM D ON D.DJXH=V_IN_DJXH AND D.CKBGDH=A.CKBGDH
                     LEFT JOIN CKTS_GCB_ZM_TYYBSWTS E ON E.DJXH=V_IN_DJXH AND E.CKBGDH=A.CKBGDH
                    WHERE A.SBID=V_IN_SBID
                      AND LENGTH(A.CKBGDH)=21;
  OPEN BJTS_CURSOR_002;
  BJTS_CURSOR_LOOP_002: LOOP
    SET BJTS_CURSOR_DONE_002 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_002 = TRUE;
      FETCH BJTS_CURSOR_002 INTO BJTS_LSF_XX_SBXH_002, BJTS_LSF_XX_CKBGDH_002, BJTS_LSF_XX_CKRQ_SH_002, BJTS_LSF_XX_TMSZTBZ_002, BJTS_LSF_XX_TYYBSWTSTYLX_DM_002, BJTS_LSF_XX_TSSBSL_002, BJTS_LSF_XX_TYSL_002, BJTS_LSF_XX_KTYSL_002, BJTS_LSF_XX_TYYBSWTSTYLXDM_C_002, BJTS_LSF_XX_DLSBSL_002, BJTS_LSF_XX_CKHWTYYBSWTSZMBH_002, BJTS_LSF_XX_QYGBZ_002, BJTS_LSF_XX_QYGWDDBZ_002, BJTS_LSF_XX_QYGCXCKBZ_002, BJTS_LSF_XX_UUID_002;
    END;
    IF BJTS_CURSOR_DONE_002 THEN
      LEAVE BJTS_CURSOR_LOOP_002;
    END IF;
      BEGIN
        IF (TIMESTAMPDIFF(MONTH, BJTS_LSF_XX_CKRQ_SH_002, LDT_TODAY)>12) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_ZM_TYYBSWTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'TSZM_TYBS_BGD_CKRQ_CQSB','I',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']退运日期离出口日期['), DATE_FORMAT(BJTS_LSF_XX_CKRQ_SH_002, '%Y-%m-%d')), ']超过12个月！'),'Y',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (BJTS_LSF_XX_TMSZTBZ_002='已办理退（免）税' AND BJTS_LSF_XX_TSSBSL_002=0) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_ZM_TYYBSWTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'TSZM_TYBS_BGD_TMSZT_YSB','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']未退税，但退运证明选择“已办理退（免）税”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        ELSEIF (BJTS_LSF_XX_TMSZTBZ_002='尚未申报退（免）税' AND BJTS_LSF_XX_TSSBSL_002>0) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_ZM_TYYBSWTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'TSZM_TYBS_BGD_TMSZT_WSB','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']已退税，但退运证明选择“尚未申报退（免）税”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (BJTS_LSF_XX_TYSL_002>BJTS_LSF_XX_KTYSL_002) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_ZM_TYYBSWTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'TSZM_TYBS_BGD_TYSL_OVER','I',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']申报退运数量['), BJTS_LSF_XX_TYSL_002), ']大于可办理退运数量['), BJTS_LSF_XX_KTYSL_002), ']！'),'Y',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (BJTS_LSF_XX_DLSBSL_002>0 AND BJTS_LSF_XX_CKHWTYYBSWTSZMBH_002 IS NULL) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_ZM_TYYBSWTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'TSZM_TYBS_BGD_DLCK','I',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']为代理出口业务，没有委托方开具的出口货物已补税（未退税）证明！'),'Y',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (BJTS_LSF_XX_QYGBZ_002='Y' AND BJTS_LSF_XX_QYGWDDBZ_002='Y' AND BJTS_LSF_XX_QYGCXCKBZ_002='Y') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_ZM_TYYBSWTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'TSZM_TYBS_BGD_QYG','I',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']为启运港业务，出口货物未运抵离境港不再实际出口且海关撤销出口货物报关单！'),'Y',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_TYYBSWTSTYLXDM_C_002 IN ('1','2','3') OR BJTS_LSF_XX_UUID_002 IS NOT NULL THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_ZM_TYYBSWTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'TSZM_TYBS_BGD_TYZM_DUP','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']存在未处理完毕的退运、改单或撤单标识！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        -- 20211215，根据临安生产企业已办理退免税后改单导致后续免抵退申报退运冲减无法正常进行的问题，咨询魏浩原业务思路（默认改单或撤单的都是未办理退免税的），增加疑点判断
        IF LC_TSJSFSDM='1' AND BJTS_LSF_XX_TYYBSWTSTYLX_DM_002 IN ('2','3') AND BJTS_LSF_XX_TSSBSL_002>0 THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_ZM_TYYBSWTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'TSZM_TYBS_BGD_TMSZT_TYLX','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_002), ']已退税，请先红字冲减申报以后办理改单或撤单证明！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
      END;

  END LOOP BJTS_CURSOR_LOOP_002;
  CLOSE BJTS_CURSOR_002;
END;
  END;

  BEGIN
    -- 代理证明
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_ZM_TYYBSWTS_LSB',NULL,NULL,T.SBXH,NULL,'TSZM_TYBS_DLZM_WDZXX','I',ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', T.CKBGDH), ']无电子信息！'),'Y',CURRENT_TIMESTAMP
           FROM CKTS_ZM_TYYBSWTS_LSB T
          WHERE T.SBID=V_IN_SBID
            AND LENGTH(T.CKBGDH)=20
            AND NOT EXISTS (SELECT 1 FROM CKTS_WBSJ_ZJ_DLCKHWZM S WHERE S.DJXH=V_IN_DJXH AND S.DLCKHWZMHM=T.CKBGDH);
    COMMIT;

    BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_SBXH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_DLCKHWZMHM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKRQ_SH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TMSZTBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TYYBSWTSTYLX_DM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TSSBSL_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TYSL_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_KTYSL_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_UUID_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT A.SBXH,
                          A.CKBGDH AS DLCKHWZMHM,
                          DATE(B.CKRQ_1) AS CKRQ_SH,
                          A.TMSZTBZ,
                          A.TYYBSWTSTYLX_DM,
                          B.TSSBSL,
                          A.TYSL,
                          B.CKSL-B.TYSL AS KTYSL,
                          E.UUID
                     FROM CKTS_ZM_TYYBSWTS_LSB A
                    INNER JOIN CKTS_WBSJ_ZJ_DLCKHWZM B ON B.DJXH=V_IN_DJXH AND B.DLCKHWZMHM=A.CKBGDH
                     LEFT JOIN CKTS_GCB_ZM_TYYBSWTS E ON E.DJXH=V_IN_DJXH AND E.CKBGDH=A.CKBGDH
                    WHERE A.SBID=V_IN_SBID
                      AND LENGTH(A.CKBGDH)=20;
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_LSF_XX_SBXH_001, BJTS_LSF_XX_DLCKHWZMHM_001, BJTS_LSF_XX_CKRQ_SH_001, BJTS_LSF_XX_TMSZTBZ_001, BJTS_LSF_XX_TYYBSWTSTYLX_DM_001, BJTS_LSF_XX_TSSBSL_001, BJTS_LSF_XX_TYSL_001, BJTS_LSF_XX_KTYSL_001, BJTS_LSF_XX_UUID_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
      BEGIN
        IF (TIMESTAMPDIFF(MONTH, BJTS_LSF_XX_CKRQ_SH_001, LDT_TODAY)>12) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_ZM_TYYBSWTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'TSZM_TYBS_DLZM_CKRQ_CQSB','I',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_001), ']退运日期离出口日期['), DATE_FORMAT(BJTS_LSF_XX_CKRQ_SH_001, '%Y-%m-%d')), ']超过12个月！'),'Y',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (BJTS_LSF_XX_TMSZTBZ_001='已办理退（免）税' AND BJTS_LSF_XX_TSSBSL_001=0) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_ZM_TYYBSWTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'TSZM_TYBS_DLZM_TMSZT_YSB','E',ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_001), ']未退税，但退运证明选择“已办理退（免）税”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        ELSEIF (BJTS_LSF_XX_TMSZTBZ_001='尚未申报退（免）税' AND BJTS_LSF_XX_TSSBSL_001>0) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_ZM_TYYBSWTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'TSZM_TYBS_DLZM_TMSZT_WSB','E',ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_001), ']已退税，但退运证明选择“尚未申报退（免）税”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (BJTS_LSF_XX_TYSL_001>BJTS_LSF_XX_KTYSL_001) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_ZM_TYYBSWTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'TSZM_TYBS_DLZM_TYSL_OVER','I',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_001), ']申报退运数量['), BJTS_LSF_XX_TYSL_001), ']大于可办理退运数量['), BJTS_LSF_XX_KTYSL_001), ']！'),'Y',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_UUID_001 IS NOT NULL THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_ZM_TYYBSWTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'TSZM_TYBS_DLZM_TYZM_DUP','E',ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_001), ']存在未处理完毕的退运、改单或撤单标识！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        -- 20211215，根据临安生产企业已办理退免税后改单导致后续免抵退申报退运冲减无法正常进行的问题，咨询魏浩原业务思路（默认改单或撤单的都是未办理退免税的），增加疑点判断
        IF LC_TSJSFSDM='1' AND BJTS_LSF_XX_TYYBSWTSTYLX_DM_001 IN ('2','3') AND BJTS_LSF_XX_TSSBSL_001>0 THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_ZM_TYYBSWTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'TSZM_TYBS_DLZM_TMSZT_TYLX','E',ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_001), ']已退税，请先红字冲减申报以后办理改单或撤单证明！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
      END;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;
  END;

  BEGIN
    -- 增值税发票
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_ZM_TYYBSWTS_LSB',NULL,NULL,T.SBXH,NULL,'TSZM_TYBS_JHPZH_WDZXX','E',ORA_CONCAT(ORA_CONCAT('进货凭证号码[', T.JHPZH), ']无电子信息！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_ZM_TYYBSWTS_LSB T
          WHERE T.SBID=V_IN_SBID
            AND (LENGTH(T.JHPZH)=20 OR LENGTH(T.JHPZH)=18)
            AND NOT EXISTS (SELECT 1
                              FROM CKTS_WBSJ_FP_ZZSZYFPXX S
                             WHERE S.DJXH=V_IN_DJXH
                               AND S.JHPZH=T.JHPZH);
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_ZM_TYYBSWTS_LSB',NULL,NULL,T.SBXH,NULL,'TSZM_TYBS_SBTMSE_OVER','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('申报的原退（免）税额[', T.YSBMDTSE), ']大于进货凭证的税额['), S.SE), ']！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_ZM_TYYBSWTS_LSB T
          INNER JOIN CKTS_WBSJ_FP_ZZSZYFPXX S ON S.DJXH=V_IN_DJXH AND S.JHPZH=T.JHPZH
          WHERE T.SBID=V_IN_SBID
            AND (LENGTH(T.JHPZH)=20 OR LENGTH(T.JHPZH)=18)
            AND T.YSBMDTSE>S.SE+0.01;
    COMMIT;
  END;

  BEGIN
    -- 进口增值税
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_ZM_TYYBSWTS_LSB',NULL,NULL,T.SBXH,NULL,'TSZM_TYBS_JHPZH_WDZXX','E',ORA_CONCAT(ORA_CONCAT('进货凭证号码[', T.JHPZH), ']无电子信息！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_ZM_TYYBSWTS_LSB T
          WHERE T.SBID=V_IN_SBID
            AND LENGTH(T.JHPZH)=22
            AND NOT EXISTS (SELECT 1
                              FROM CKTS_WBSJ_HG_JKJKS S
                             WHERE S.DJXH=V_IN_DJXH
                               AND S.HGZYJKSHM=T.JHPZH);
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_ZM_TYYBSWTS_LSB',NULL,NULL,T.SBXH,NULL,'TSZM_TYBS_SBTMSE_OVER','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('申报的原退（免）税额[', T.YSBMDTSE), ']大于进货凭证的税额['), S.SKJE), ']！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_ZM_TYYBSWTS_LSB T
          INNER JOIN CKTS_WBSJ_HG_JKJKS S ON S.DJXH=V_IN_DJXH AND S.HGZYJKSHM=T.JHPZH
          WHERE T.SBID=V_IN_SBID
            AND LENGTH(T.JHPZH)=22
            AND T.YSBMDTSE>S.SKJE;
    COMMIT;
  END;

  BEGIN
    -- 缴款书号码
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_ZM_TYYBSWTS_LSB',NULL,NULL,T.SBXH,NULL,'TSZM_TYBS_JKSHM_WDZXX','E',ORA_CONCAT(ORA_CONCAT('该缴款书号码[', T.JKSHM), ']不存在！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_ZM_TYYBSWTS_LSB T
          WHERE T.SBID=V_IN_SBID
            AND T.JKSHM IS NOT NULL
            AND NOT EXISTS (SELECT 1
                              FROM CKTS_WBSJ_GT3_ZS_JKS S
                             WHERE S.DJXH=V_IN_DJXH
                               AND S.DZSPHM=T.JKSHM);
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_ZM_TYYBSWTS_LSB',NULL,NULL,T.SBXH,NULL,'TSZM_TYBS_JKSE_BYZ','I',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('补缴税额[', T.YBJTMSK), ']与实际缴纳税款['), S.SJJE), ']不符！'),'Y',CURRENT_TIMESTAMP
           FROM CKTS_ZM_TYYBSWTS_LSB T
          INNER JOIN CKTS_WBSJ_GT3_ZS_JKS S ON S.DJXH=V_IN_DJXH AND S.DZSPHM=T.JKSHM
          WHERE T.SBID=V_IN_SBID
            AND T.YBJTMSK>S.SJJE+0.01;
    COMMIT;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_TSZM_TYYBSWTS.sql

-- ======================================================================
-- [080/114] BEGIN SOURCE: PROC_XXBD_TSZM_WTCKHWZM.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_TSZM_WTCKHWZM$$

CREATE PROCEDURE PROC_XXBD_TSZM_WTCKHWZM
/*
  编制人:严国平
  编制日期:202101
  功能:信息比对（委托出口货物证明）
  说明：其中TSZM_WTCK_SPDM_RANK提示性疑点电子税务局已实现，主要为了兼容离线版申报自检；
            TSZM_WTCK_DFDWSH_VALID疑点原来通过java代码实现，修改维护比较麻烦，改为存储过程实现。
  调整日期：20210715，1、调整疑点TSZM_WTCK_DFDWSH_VALID判断逻辑，先判断本地企业再判断全国备案信息
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE BJTS_ROUTINE_EXIT BOOLEAN DEFAULT FALSE;
  DECLARE LDT_TODAY    DATETIME;

  DECLARE LC_QYHGDM       VARCHAR(20);
  DECLARE LC_QYLXDM       VARCHAR(20);
  DECLARE LC_TSJSFSDM     VARCHAR(20);
  DECLARE LC_WMZHFWQYBZ   VARCHAR(20);
  DECLARE LC_SFYSFW       VARCHAR(20);
  DECLARE LC_YSFW         VARCHAR(50);
  DECLARE LC_YSFS         VARCHAR(50);
  DECLARE LC_YFSJ         VARCHAR(50);
  DECLARE LC_ZXFLAG       VARCHAR(20);

  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LN_ROWNUM_TSSB  BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  IF V_IN_SSSQ>DATE_FORMAT(CURRENT_TIMESTAMP, '%Y%m') THEN
    BEGIN
      SET V_OUT_STATUS ='05';
      SET V_OUT_MESSAGE ='申报所属时期超出合理范围！';
      LEAVE routine_body;
    END;
  END IF;

  -- 取各申报明细表数据记录
  BEGIN
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='06';
      SET V_OUT_MESSAGE ='查询申报记录数据失败！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT COUNT(1)
      INTO LN_ROWNUM_TSSB
      FROM CKTS_ZM_WTCK_LSB
     WHERE SBID=V_IN_SBID;
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LN_ROWNUM_TSSB=0 THEN
    BEGIN
      SET V_OUT_STATUS ='07';
      SET V_OUT_MESSAGE ='申报数据为空！';
      LEAVE routine_body;
    END;
  END IF;

  -- 查询企业基本信息
  BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='08';
      SET V_OUT_MESSAGE ='企业当前未进行出口退（免）税备案，不允许申报除出口退（免）税备案以外的其他业务！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT T.QYHGDM, T.QYLX_DM, T.TSJSFS_DM, T.WMZHFWQYBZ, T.SFYSFW, T.YSFW, T.YSFS, T.YFSJ, T.ZX_FLAG
      INTO LC_QYHGDM, LC_QYLXDM, LC_TSJSFSDM, LC_WMZHFWQYBZ, LC_SFYSFW, LC_YSFW, LC_YSFS, LC_YFSJ, LC_ZXFLAG
      FROM GS_DJ_CKTMSDAB T
     WHERE T.NSRDZDAH=V_IN_NSRDZDAH;
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LC_ZXFLAG='R' THEN
    BEGIN
      SET V_OUT_STATUS ='09';
      SET V_OUT_MESSAGE ='企业当前已出口退（免）税备案撤回，不允许申报除出口退（免）税备案以外的其他业务！';
      LEAVE routine_body;
    END;
  END IF;

  -- 取企业的FLGLCD信息, TGSHZL信息，判断是否需要申报收汇
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',LDT_TODAY,LC_FLGLCD, LN_CPCODEKZ);
  IF LN_CPCODEKZ=0 THEN
    BEGIN
      SET V_OUT_STATUS ='10';
      SET V_OUT_MESSAGE ='查询出口企业分类管理类型出错！';
      LEAVE routine_body;
    END;
  END IF;


  SET LC_YDOBJECT ='委托出口';
  BEGIN
    BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_SBXH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKBGDH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_STFNSRSBH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_STQY_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSP_DM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSP_DM_QSTS_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT DISTINCT A.SBXH,
                          A.CKBGDH,
                          A.STFNSRSBH,
                          IFNULL(E.NSRSBH, B.UUID) AS STQY,
                          A.CKSP_DM,
                          IFNULL(C.CKSP_DM, D.CKSP_DM) AS CKSP_DM_QSTS
                     FROM CKTS_ZM_WTCK_LSB A
                     LEFT JOIN CKTS_WBSJ_ZJ_CKTSBAQGXX B ON B.NSRSBH=A.STFNSRSBH OR B.SHXYDM=A.STFNSRSBH
                     LEFT JOIN CKTS_DM_TSLVWK C ON C.CKSP_DM=A.CKSP_DM AND (CURRENT_TIMESTAMP BETWEEN C.YXQQ AND C.YXQZ) AND C.ZSSL>0 AND C.TSL=0 AND C.CKSPTSSPLX_DM='1'
                     LEFT JOIN CKTS_DM_TSLVWK D ON D.CKSP_DM=SUBSTR(A.CKSP_DM,1,8) AND (CURRENT_TIMESTAMP BETWEEN D.YXQQ AND D.YXQZ) AND D.ZSSL>0 AND D.TSL=0 AND D.CKSPTSSPLX_DM='1'
                     LEFT JOIN GS_DJ_CKTMSDAB E ON E.NSRDJNO=A.STFNSRSBH OR E.SHXYNO=A.STFNSRSBH
                    WHERE A.SBID=V_IN_SBID;
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_LSF_XX_SBXH_001, BJTS_LSF_XX_CKBGDH_001, BJTS_LSF_XX_STFNSRSBH_001, BJTS_LSF_XX_STQY_001, BJTS_LSF_XX_CKSP_DM_001, BJTS_LSF_XX_CKSP_DM_QSTS_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
      BEGIN
        IF (BJTS_LSF_XX_STQY_001 IS NULL) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_ZM_WTCK_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'TSZM_WTCK_DFDWSH_VALID','E',ORA_CONCAT(ORA_CONCAT('未查询到受托企业[', BJTS_LSF_XX_STFNSRSBH_001), ']的出口退（免）税备案信息，请核实受托企业纳税人社会信用码（识别号）是否准确！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (BJTS_LSF_XX_CKSP_DM_QSTS_001 IS NULL) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_ZM_WTCK_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'TSZM_WTCK_SPDM_RANK','I',ORA_CONCAT(ORA_CONCAT('出口商品代码[', BJTS_LSF_XX_CKSP_DM_001), ']不是取消退税商品，请确认是否需要申请委托出口货物证明！'),'Y',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
      END;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_TSZM_WTCKHWZM.sql

-- ======================================================================
-- [081/114] BEGIN SOURCE: PROC_XXBD_WZF.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_WZF$$

CREATE PROCEDURE PROC_XXBD_WZF
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（外综服代办退税）
  调整日期：20210603，1、非四类企业超期申报允许提交收汇信息
  修改日期：20220615，根据2022年9号公告，合并收汇与不能收汇
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE BJTS_ROUTINE_EXIT BOOLEAN DEFAULT FALSE;
  DECLARE LDT_TODAY       DATETIME;

  DECLARE LC_QYHGDM       VARCHAR(20);
  DECLARE LC_QYLXDM       VARCHAR(20);
  DECLARE LC_TSJSFSDM     VARCHAR(20);
  DECLARE LC_WMZHFWQYBZ   VARCHAR(20);
  DECLARE LC_SFYSFW       VARCHAR(20);
  DECLARE LC_YSFW         VARCHAR(50);
  DECLARE LC_YSFS         VARCHAR(50);
  DECLARE LC_YFSJ         VARCHAR(50);
  DECLARE LC_ZXFLAG       VARCHAR(20);

  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LN_TGSHZL       BIGINT;
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LN_ROWNUM_CKMX  BIGINT;
  DECLARE LN_ROWNUM_CKSH  BIGINT;
  DECLARE LN_ROWNUM_CQSB  BIGINT;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';
  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  IF V_IN_SSSQ>DATE_FORMAT(CURRENT_TIMESTAMP, '%Y%m') THEN
    BEGIN
      SET V_OUT_STATUS ='05';
      SET V_OUT_MESSAGE ='申报所属时期超出合理范围！';
      LEAVE routine_body;
    END;
  END IF;

  -- 取各申报明细表数据记录
  BEGIN
  DECLARE BJTS_SQLCODE_007 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_007 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_007 = MYSQL_ERRNO, BJTS_SQLERRM_007 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='06';
      SET V_OUT_MESSAGE ='查询申报记录数据失败！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT COUNT(1)
      INTO LN_ROWNUM_CKMX
      FROM CKTS_SB_DB_TSSB_LSB
     WHERE SBID=V_IN_SBID;
    SELECT COUNT(1)
      INTO LN_ROWNUM_CKSH
      FROM CKTS_SB_DB_CKHWSH_LSB
     WHERE SBID=V_IN_SBID;
    SELECT COUNT(1)
      INTO LN_ROWNUM_CQSB
      FROM CKTS_SB_DB_TSSB_LSB
     WHERE SBID=V_IN_SBID
       AND (((STR_TO_DATE(ORA_CONCAT(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y'), '0420'), '%Y%m%d')<DATE(CURRENT_TIMESTAMP)) AND (CKRQ_1<MAKEDATE(YEAR(CURRENT_TIMESTAMP), 1))) OR (CKRQ_1<DATE_ADD(MAKEDATE(YEAR(CURRENT_TIMESTAMP), 1), INTERVAL -12 MONTH)))
       AND FUNC_XXBD_CHECK_NEEDSH(ORA_CONCAT(ORA_CONCAT(',', CKTMSYWLXDMJH), ',')) = 1;
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LN_ROWNUM_CKMX=0 THEN
    BEGIN
      SET V_OUT_STATUS ='07';
      SET V_OUT_MESSAGE ='申报数据为空！';
      LEAVE routine_body;
    END;
  END IF;

  -- 查询企业基本信息
  BEGIN
  DECLARE BJTS_SQLCODE_006 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_006 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_006 = MYSQL_ERRNO, BJTS_SQLERRM_006 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='08';
      SET V_OUT_MESSAGE ='企业当前未进行出口退（免）税备案，不允许申报除出口退（免）税备案以外的其他业务！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT T.QYHGDM, T.QYLX_DM, T.TSJSFS_DM, T.WMZHFWQYBZ, T.SFYSFW, T.YSFW, T.YSFS, T.YFSJ, T.ZX_FLAG
      INTO LC_QYHGDM, LC_QYLXDM, LC_TSJSFSDM, LC_WMZHFWQYBZ, LC_SFYSFW, LC_YSFW, LC_YSFS, LC_YFSJ, LC_ZXFLAG
      FROM GS_DJ_CKTMSDAB T
     WHERE T.NSRDZDAH=V_IN_NSRDZDAH;
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LC_ZXFLAG='Y' THEN
    BEGIN
      SET V_OUT_STATUS ='09';
      SET V_OUT_MESSAGE ='企业当前已出口退（免）税备案撤回，不允许申报除出口退（免）税备案以外的其他业务！';
      LEAVE routine_body;
    END;
  END IF;

  -- 取企业的FLGLCD信息, TGSHZL信息，判断是否需要申报收汇
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',LDT_TODAY,LC_FLGLCD, LN_CPCODEKZ);
  IF LN_CPCODEKZ=0 THEN
    BEGIN
      SET V_OUT_STATUS ='10';
      SET V_OUT_MESSAGE ='查询出口企业分类管理类型出错！';
      LEAVE routine_body;
    END;
  END IF;

  IF LC_QYLXDM<>'3' OR LC_TSJSFSDM<>'2' THEN
    BEGIN
      SET V_OUT_STATUS ='11';
      SET V_OUT_MESSAGE ='备案信息中企业类型、退免税计算方法与当前申报业务冲突！';
      LEAVE routine_body;
    END;
  END IF;

  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'YBNSRRD',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=0 THEN
    BEGIN
      SET V_OUT_STATUS ='12';
      SET V_OUT_MESSAGE ='企业当前非增值税一般纳税人，不允许申报出口退（免）税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TQQY',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 THEN
    BEGIN
      SET V_OUT_STATUS ='13';
      SET V_OUT_MESSAGE ='企业当前处于出口退税停权期间，不允许申报出口退（免）税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTSSXMS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_CKMX>0 THEN
    BEGIN
      SET V_OUT_STATUS ='14';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权选择免税期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTSSXZS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_CKMX>0 THEN
    BEGIN
      SET V_OUT_STATUS ='15';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权选择征税期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTMS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_CKMX>0 THEN
    BEGIN
      SET V_OUT_STATUS ='16';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;

  IF LC_WMZHFWQYBZ='N' THEN
    BEGIN
      SET V_OUT_STATUS ='26';
      SET V_OUT_MESSAGE ='出口企业未备案为外贸综合服务企业，不允许申报外贸综合服务企业代办退税！';
      LEAVE routine_body;
    END;
  END IF;

  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TGSHZL',LDT_TODAY,LC_KZXX, LN_TGSHZL);
  IF (LC_FLGLCD='D') AND LN_ROWNUM_CKMX>0 AND LN_ROWNUM_CKSH=0 THEN
    BEGIN
      SET V_OUT_STATUS ='27';
      SET V_OUT_MESSAGE ='出口退（免）税管理类别为四类的企业，申报出口退免税时必须申报收汇情况表！';
      LEAVE routine_body;
    END;
  ELSEIF (LN_TGSHZL>0) AND LN_ROWNUM_CKMX>0 AND LN_ROWNUM_CKSH=0 THEN
    BEGIN
      SET V_OUT_STATUS ='28';
      SET V_OUT_MESSAGE ='被认定为需提供收汇资料的企业，申报出口退免税时必须申报收汇情况表！';
      LEAVE routine_body;
    END;
  ELSEIF (LN_ROWNUM_CQSB>0) AND LN_ROWNUM_CKMX>0 AND LN_ROWNUM_CKSH=0 THEN
    BEGIN
      SET V_OUT_STATUS ='29';
      SET V_OUT_MESSAGE ='超期申报数据，申报出口退免税时必须申报收汇情况表！';
      LEAVE routine_body;
    END;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_005 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_005 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_005 = MYSQL_ERRNO, BJTS_SQLERRM_005 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='51';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代办退税明细自检出错：', BJTS_SQLCODE_005), ' - '), BJTS_SQLERRM_005);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_WZF_TSSB(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_004 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_004 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_004 = MYSQL_ERRNO, BJTS_SQLERRM_004 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='52';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口报关单自检出错：', BJTS_SQLCODE_004), ' - '), BJTS_SQLERRM_004);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_WZF_TSSB_BGD(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_003 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_003 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_003 = MYSQL_ERRNO, BJTS_SQLERRM_003 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='53';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代办退税发票自检出错：', BJTS_SQLCODE_003), ' - '), BJTS_SQLERRM_003);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_WZF_TSSB_ZZSFP(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='62';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口收汇申报资料自检出错：', BJTS_SQLCODE_002), ' - '), BJTS_SQLERRM_002);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_WZF_CKSH(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='63';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('海关商品代码调整表自检出错：', BJTS_SQLCODE_001), ' - '), BJTS_SQLERRM_001);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_WZF_HGSPTZ(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_WZF.sql

-- ======================================================================
-- [082/114] BEGIN SOURCE: PROC_XXBD_WZF_BNSH.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_WZF_BNSH$$

CREATE PROCEDURE PROC_XXBD_WZF_BNSH
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（外综服代办退税）
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 不能收汇明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_MTS_BNSH_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;

  BEGIN
    SET LC_YDOBJECT ='不能收汇';

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_DB_CKHWBNSH_LSB','CKTS_SB_DB_TSSB_LSB',NULL,T.SBXH,NULL,'WZF_BJGX_SHZL_DBTS_CKPZ','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), ']未申报代办退税明细！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_DB_CKHWBNSH_LSB T
          WHERE T.SBID=V_IN_SBID
            AND T.CKBGDH IS NOT NULL
            AND NOT EXISTS (SELECT 1 FROM CKTS_SB_DB_TSSB_LSB S WHERE S.SBID=T.SBID AND S.CKBGDH=T.CKBGDH);
    COMMIT;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_WZF_BNSH.sql

-- ======================================================================
-- [083/114] BEGIN SOURCE: PROC_XXBD_WZF_CKSH.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_WZF_CKSH$$

CREATE PROCEDURE PROC_XXBD_WZF_CKSH
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（外综服代办退税）
  修改日期：20220615，根据2022年9号公告，四类企业，需提供银行水单企业收汇情况表必须申报本期出口退税，非上述企业改为提示性疑点
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LDT_TODAY       DATETIME;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';
  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  -- 收汇明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_DB_CKHWSH_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;

  SET LC_YDOBJECT ='出口收汇';
  BEGIN
    CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',LDT_TODAY,LC_FLGLCD, LN_CPCODEKZ);
    CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TGSHZL',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
    IF (LC_FLGLCD='D') OR (LN_CPCODEKZ>0) THEN
      BEGIN
        INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
             SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                    'CKTS_SB_DB_CKHWSH_LSB','CKTS_SB_DB_TSSB_LSB',NULL,T.SBXH,NULL,'WZF_BJGX_SHZL_DBTS_CKPZ','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), ']未申报退税！'),'N',CURRENT_TIMESTAMP
               FROM CKTS_SB_DB_CKHWSH_LSB T
              WHERE T.SBID=V_IN_SBID
                AND NOT EXISTS (SELECT 1 FROM CKTS_SB_DB_TSSB_LSB S WHERE S.SBID=T.SBID AND S.CKBGDH=T.CKBGDH);
        COMMIT;
      END;
    ELSE
      BEGIN
        INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
             SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                    'CKTS_SB_DB_CKHWSH_LSB','CKTS_SB_DB_TSSB_LSB',NULL,T.SBXH,NULL,'WZF_BJGX_SHZL_DBTS_CKPZ','I',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), ']本期未申报退税！'),'Y',CURRENT_TIMESTAMP
               FROM CKTS_SB_DB_CKHWSH_LSB T
              WHERE T.SBID=V_IN_SBID
                AND NOT EXISTS (SELECT 1 FROM CKTS_SB_DB_TSSB_LSB S WHERE S.SBID=T.SBID AND S.CKBGDH=T.CKBGDH);
        COMMIT;
      END;
    END IF;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_WZF_CKSH.sql

-- ======================================================================
-- [084/114] BEGIN SOURCE: PROC_XXBD_WZF_HGSPTZ.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_WZF_HGSPTZ$$

CREATE PROCEDURE PROC_XXBD_WZF_HGSPTZ
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（外综服代办退税）
  修改日期：20230207，外综服代办退税不需要比较代理证明
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 海关代码调整明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_DB_HGSPTZ_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;
  SET LC_YDOBJECT ='代码调整';

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_DB_HGSPTZ_LSB','CKTS_SB_DB_TSSB_LSB',NULL,T.SBXH,NULL,'WZF_BJGX_DMTZ_DBTS_CKPZ','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), ']未申报代办退税明细！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_DB_HGSPTZ_LSB T
          WHERE T.SBID=V_IN_SBID
            AND NOT EXISTS (SELECT 1 FROM CKTS_SB_DB_TSSB_LSB S WHERE S.SBID=T.SBID AND S.CKBGDH=T.CKBGDH);
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_DB_HGSPTZ_LSB','CKTS_SB_DB_TSSB_LSB',NULL,T.SBXH,NULL,'WZF_BJGX_DMTZ_DBTS_CKRQ','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), ']的出口日期与代办退税明细表中不一致！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_DB_HGSPTZ_LSB T
          INNER JOIN CKTS_SB_DB_TSSB_LSB S ON S.SBID=T.SBID AND S.CKBGDH=T.CKBGDH
          WHERE T.SBID=V_IN_SBID
            AND DATE(T.CKRQ_1)<>DATE(S.CKRQ_1);
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_DB_HGSPTZ_LSB','CKTS_SB_DB_TSSB_LSB',NULL,T.SBXH,NULL,'WZF_BJGX_DMTZ_DBTS_SPDM','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), ']调整前商品代码与代办退税明细表中不一致！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_DB_HGSPTZ_LSB T
          INNER JOIN CKTS_SB_DB_TSSB_LSB S ON S.SBID=T.SBID AND S.CKBGDH=T.CKBGDH
          WHERE T.SBID=V_IN_SBID
            AND T.CKSP_DM<>S.CKSP_DM;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_DB_HGSPTZ_LSB','CKTS_SB_DB_TSSB_LSB',NULL,T.SBXH,NULL,'WZF_BJGX_DMTZ_DBTS_ZSLV','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), ']调整后商品代码在对应出口日期的退税率文库中的征税率与货物出口明细表中不一致！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_DB_HGSPTZ_LSB T
          INNER JOIN CKTS_SB_DB_TSSB_LSB S ON S.SBID=T.SBID AND S.CKBGDH=T.CKBGDH
           LEFT JOIN CKTS_DM_TSLVWK C ON C.CKSP_DM=T.TZHCKSP_DM AND S.CKRQ_1 BETWEEN C.YXQQ AND C.YXQZ
           LEFT JOIN CKTS_DM_TSLVTZ D ON D.CKSP_DM=T.TZHCKSP_DM AND S.CKRQ_1 BETWEEN D.KSSJ AND D.JSSJ
          WHERE T.SBID=V_IN_SBID
            AND IFNULL(IFNULL(D.ZSSL, C.ZSSL), 0)<>S.ZSSL;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_DB_HGSPTZ_LSB','CKTS_SB_DB_TSSB_LSB',NULL,T.SBXH,NULL,'WZF_BJGX_DMTZ_DBTS_TSLV','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), ']调整后退税率与代办退税明细表中不一致！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_DB_HGSPTZ_LSB T
          INNER JOIN CKTS_SB_DB_TSSB_LSB S ON S.SBID=T.SBID AND S.CKBGDH=T.CKBGDH
          WHERE T.SBID=V_IN_SBID
            AND T.TZHTSL<>S.TSL;
    COMMIT;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_WZF_HGSPTZ.sql

-- ======================================================================
-- [085/114] BEGIN SOURCE: PROC_XXBD_WZF_TSSB.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_WZF_TSSB$$

CREATE PROCEDURE PROC_XXBD_WZF_TSSB
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（外综服代办退税）
  调整日期：20220323，1、根据总局货劳司关于加强启运港出口退（免）税统计分析功能的业务要求，增加WZF_DBTS_CKYWLX_QYGTS疑点
  修改日期：20220615，根据2022年9号公告，合并收汇与不能收汇
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LDT_TODAY       DATETIME;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';
  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  -- 代办退税明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_DB_TSSB_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;

  SET LC_YDOBJECT ='代办退税';
  BEGIN
    CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',LDT_TODAY,LC_FLGLCD, LN_CPCODEKZ);
    CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TGSHZL',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
    IF (LC_FLGLCD='D') OR (LN_CPCODEKZ>0) THEN
      BEGIN
        INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
             SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                    'CKTS_SB_DB_TSSB_LSB','CKTS_SB_DB_CKHWSH_LSB',NULL,T.SBXH,NULL,'WZF_BJGX_DBTS_SHZL_CKPZ','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), ']未申报收汇资料！'),'N',CURRENT_TIMESTAMP
               FROM CKTS_SB_DB_TSSB_LSB T
              WHERE T.SBID=V_IN_SBID
                AND FUNC_XXBD_CHECK_NEEDSH(ORA_CONCAT(ORA_CONCAT(',', T.CKTMSYWLXDMJH), ',')) = 1
                AND NOT EXISTS (SELECT 1 FROM CKTS_SB_DB_CKHWSH_LSB S WHERE S.SBID=T.SBID AND S.CKBGDH=T.CKBGDH);
        COMMIT;
      END;
    ELSE
      BEGIN
        INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
             SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                    'CKTS_SB_DB_TSSB_LSB','CKTS_SB_DB_CKHWSH_LSB',NULL,T.SBXH,NULL,'WZF_BJGX_DBTS_SHZL_CKPZ','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), ']未申报收汇资料！'),'N',CURRENT_TIMESTAMP
               FROM CKTS_SB_DB_TSSB_LSB T
              WHERE T.SBID=V_IN_SBID
                AND (((STR_TO_DATE(ORA_CONCAT(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y'), '0419'), '%Y%m%d')<CURRENT_TIMESTAMP) AND (CKRQ_1<MAKEDATE(YEAR(CURRENT_TIMESTAMP), 1))) OR (CKRQ_1<DATE_ADD(MAKEDATE(YEAR(CURRENT_TIMESTAMP), 1), INTERVAL -12 MONTH)))
                AND FUNC_XXBD_CHECK_NEEDSH(ORA_CONCAT(ORA_CONCAT(',', T.CKTMSYWLXDMJH), ',')) = 1
                AND NOT EXISTS (SELECT 1 FROM CKTS_SB_DB_CKHWSH_LSB S WHERE S.SBID=T.SBID AND S.CKBGDH=T.CKBGDH);
        COMMIT;
      END;
    END IF;
  END;

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_DB_TSSB_LSB',NULL,NULL,T.SBXH,NULL,'WZF_DBTS_CKRQ_NSRZG','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.CKRQ_1, '%Y-%m-%d')), ']企业非增值税一般纳税人！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_DB_TSSB_LSB T
           LEFT JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='YBNSRRD' AND S.FLAG='1' AND T.CKRQ_1 BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID
            AND S.KZLX IS NULL;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_DB_TSSB_LSB',NULL,NULL,T.SBXH,NULL,'WZF_DBTS_CKRQ_TQQY','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.CKRQ_1, '%Y-%m-%d')), ']企业处于出口退税停权期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_DB_TSSB_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='TQQY' AND S.FLAG='1' AND T.CKRQ_1 BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_DB_TSSB_LSB',NULL,NULL,T.SBXH,NULL,'WZF_DBTS_CKRQ_TQDB','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.CKRQ_1, '%Y-%m-%d')), ']属于综服企业被依职权停权期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_DB_TSSB_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='TZCSDBTS' AND S.FLAG='1' AND T.CKRQ_1 BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_DB_TSSB_LSB',NULL,NULL,T.SBXH,NULL,'WZF_DBTS_CKRQ_MSQY','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.CKRQ_1, '%Y-%m-%d')), ']企业处于免税期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_DB_TSSB_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='TSGMS' AND S.FLAG='1' AND T.CKRQ_1 BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_DB_TSSB_LSB',NULL,NULL,T.SBXH,NULL,'WZF_DBTS_CKRQ_FQTS','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.CKRQ_1, '%Y-%m-%d')), ']企业处于放弃退（免）税权选择免税期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_DB_TSSB_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='FQTSSXMS' AND S.FLAG='1' AND T.CKRQ_1 BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_DB_TSSB_LSB',NULL,NULL,T.SBXH,NULL,'WZF_DBTS_CKRQ_FQTS','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.CKRQ_1, '%Y-%m-%d')), ']企业处于放弃退（免）税权选择征税期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_DB_TSSB_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='FQTSSXZS' AND S.FLAG='1' AND T.CKRQ_1 BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_DB_TSSB_LSB',NULL,NULL,T.SBXH,NULL,'WZF_DBTS_CKRQ_FQTS','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(T.CKRQ_1, '%Y-%m-%d')), ']企业处于放弃退（免）税权期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_DB_TSSB_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='FQTMS' AND S.FLAG='1' AND T.CKRQ_1 BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;
  END;

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_DB_TSSB_LSB',NULL,NULL,T.SBXH,NULL,'WZF_DBTS_CKYWLX_QYGTS','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), ']为启运港业务，需确认国内启运方式及海关总署认证企业类型！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_DB_TSSB_LSB T
          WHERE T.SBID=V_IN_SBID
            AND INSTR(T.CKTMSYWLXDMJH,'QYGTS')>0
            AND (T.GNQYFS_DM IS NULL OR T.HGZSRZQYLX_DM IS NULL);
    COMMIT;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_WZF_TSSB.sql

-- ======================================================================
-- [086/114] BEGIN SOURCE: PROC_XXBD_WZF_TSSB_BGD.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_WZF_TSSB_BGD$$

CREATE PROCEDURE PROC_XXBD_WZF_TSSB_BGD
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（外综服代办退税）
  调整日期：20201106，1、对金额增加null判断
  调整日期：20201119，1、调整改单报关单监控条件，由bgd202不存在改为bgd201.gdbz_1<>Y
  调整日期：20210113，1、调整改单报关单监控条件，改为bgd202不存在 且 bgd201.gdbz_1<>Y
  调整日期：20230313，增加WZF_DBTS_BGD_BSQ_BAQD、WZF_DBTS_BGD_BSQ_BANR疑点判断
  调整日期：20230814，针对异常扣税凭证做了追回处理后解除异常重新申报退税的总量控制bug，拆分WZF_DBTS_BGD_CKSL疑点、调整WZF_DBTS_BGD_MYLAJ疑点
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LN_CMCD_LEN     BIGINT;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 报关单出口明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_DB_TSSB_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;

  SET LC_YDOBJECT ='代办出口';
  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_DB_TSSB_LSB',NULL,NULL,T.SBXH,NULL,'WZF_DBTS_BGD_WDZXX','E',
                ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), ']无电子信息！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_DB_TSSB_LSB T
          WHERE T.SBID=V_IN_SBID
            AND FUNC_XXBD_CHECK_YWLX(ORA_CONCAT(ORA_CONCAT(',', T.CKTMSYWLXDMJH), ',')) = 0
            AND NOT EXISTS (SELECT 1 FROM CKTS_WBSJ_HG_BGD201 S WHERE S.DJXH=V_IN_DJXH AND S.CKBGDH=T.CKBGDH);
    COMMIT;
  END;

  BEGIN
    BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_SBXH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKBGDH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_BYTSBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKRQ_SB_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKRQ_SH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_QYRQ_SH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKTMSYWLXDMJH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSP_DM_SB_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSP_DM_SH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TYYBSWTSTYLX_DM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_GDBZ_1_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKBGDH_GD_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_JGFS_DM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_JGFSTSLX_DM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_QYGBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_QYGCXCKBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_QYGWDDBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_QYGZCJGBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_YSFS_DM_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT A.SBXH,
                          A.CKBGDH,
                          B.BYTSBZ,
                          DATE(A.CKRQ_1) AS CKRQ_SB,
                          DATE(B.CKRQ_1) AS CKRQ_SH,
                          DATE(B.QYRQ_2) AS QYRQ_SH,
                          IFNULL(A.CKTMSYWLXDMJH, ' ') AS CKTMSYWLXDMJH,
                          A.CKSP_DM AS CKSP_DM_SB,
                          B.CKSP_DM AS CKSP_DM_SH,
                          D.TYYBSWTSTYLX_DM,
                          IFNULL(B.GDBZ_1, ' ') AS GDBZ_1,
                          E.CKBGDH AS CKBGDH_GD,
                          C.JGFS_DM,
                          C.JGFSTSLX_DM,
                          B.QYGBZ,
                          B.QYGCXCKBZ,
                          B.QYGWDDBZ,
                          B.QYGZCJGBZ,
                          B.YSFS_DM
                     FROM CKTS_SB_DB_TSSB_LSB A
                    INNER JOIN CKTS_WBSJ_HG_BGD201 B ON B.DJXH=V_IN_DJXH AND B.CKBGDH=A.CKBGDH
                     LEFT JOIN CKTS_DM_HGJGFS C ON C.JGFS_DM=B.JGFS_DM
                     LEFT JOIN CKTS_JGB_ZM_TYYBSWTS D ON D.DJXH=V_IN_DJXH AND D.CKBGDH=A.CKBGDH AND IFNULL(D.ZFBZ_1, 'N')='N'
                     LEFT JOIN CKTS_WBSJ_HG_BGD202 E ON D.DJXH=V_IN_DJXH AND E.CKBGDH=A.CKBGDH
                    WHERE A.SBID=V_IN_SBID
                      AND FUNC_XXBD_CHECK_YWLX(ORA_CONCAT(ORA_CONCAT(',', A.CKTMSYWLXDMJH), ',')) = 0;
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_LSF_XX_SBXH_001, BJTS_LSF_XX_CKBGDH_001, BJTS_LSF_XX_BYTSBZ_001, BJTS_LSF_XX_CKRQ_SB_001, BJTS_LSF_XX_CKRQ_SH_001, BJTS_LSF_XX_QYRQ_SH_001, BJTS_LSF_XX_CKTMSYWLXDMJH_001, BJTS_LSF_XX_CKSP_DM_SB_001, BJTS_LSF_XX_CKSP_DM_SH_001, BJTS_LSF_XX_TYYBSWTSTYLX_DM_001, BJTS_LSF_XX_GDBZ_1_001, BJTS_LSF_XX_CKBGDH_GD_001, BJTS_LSF_XX_JGFS_DM_001, BJTS_LSF_XX_JGFSTSLX_DM_001, BJTS_LSF_XX_QYGBZ_001, BJTS_LSF_XX_QYGCXCKBZ_001, BJTS_LSF_XX_QYGWDDBZ_001, BJTS_LSF_XX_QYGZCJGBZ_001, BJTS_LSF_XX_YSFS_DM_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
      BEGIN
        IF BJTS_LSF_XX_BYTSBZ_001='Y' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_DB_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'WZF_DBTS_BGD_BYTS','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']已被标注为“不予退税”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        SET LN_CMCD_LEN = CASE WHEN LENGTH(BJTS_LSF_XX_CKSP_DM_SB_001) > LENGTH(BJTS_LSF_XX_CKSP_DM_SH_001) THEN LENGTH(BJTS_LSF_XX_CKSP_DM_SH_001) ELSE LENGTH(BJTS_LSF_XX_CKSP_DM_SB_001) END;
        IF SUBSTR(BJTS_LSF_XX_CKSP_DM_SB_001,1,LN_CMCD_LEN)<>SUBSTR(BJTS_LSF_XX_CKSP_DM_SH_001,1,LN_CMCD_LEN) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_DB_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'WZF_DBTS_BGD_SPDM','E',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']商品代码['), BJTS_LSF_XX_CKSP_DM_SB_001), ']与电子信息中['), BJTS_LSF_XX_CKSP_DM_SH_001), ']不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        -- 1退运; 2改单; 3撤单
        IF BJTS_LSF_XX_TYYBSWTSTYLX_DM_001='3' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_DB_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'WZF_DBTS_BGD_CD','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']曾办理过用途为”撤单“的有效的退运证明！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        ELSEIF (BJTS_LSF_XX_TYYBSWTSTYLX_DM_001='2' AND BJTS_LSF_XX_GDBZ_1_001<>'Y' AND BJTS_LSF_XX_CKBGDH_GD_001 IS NULL) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_DB_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'WZF_DBTS_BGD_GD','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']曾办理过用途为“改单”的有效的退运证明，且在“海关出口报关单改单数据”中不存在！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (TRIM(BJTS_LSF_XX_JGFS_DM_001) IS NULL) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_DB_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'WZF_DBTS_BGD_MYXZ_BCZ','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']在电子信息中监管方式不存在！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        ELSEIF (TRIM(BJTS_LSF_XX_JGFSTSLX_DM_001)='0') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_DB_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'WZF_DBTS_BGD_MYXZ_BTS','E',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']在电子信息中监管方式['), BJTS_LSF_XX_JGFS_DM_001), ']不退税！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_001,'QYGTS')>0) THEN
          BEGIN
            IF (BJTS_LSF_XX_CKRQ_SB_001<>BJTS_LSF_XX_QYRQ_SH_001) AND (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_001,'BSQ')=0) THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_DB_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'WZF_DBTS_BGD_CKRQ','E',
                          ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']出口日期['), DATE_FORMAT(BJTS_LSF_XX_CKRQ_SB_001, '%Y-%m-%d')), ']与电子信息中['), DATE_FORMAT(BJTS_LSF_XX_QYRQ_SH_001, '%Y-%m-%d')), ']不一致！'),'N',CURRENT_TIMESTAMP
;
              COMMIT;
            END IF;
            IF BJTS_LSF_XX_QYGBZ_001<>'Y' THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_DB_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'WZF_DBTS_BGD_QYGTS_NOT','E',
                          ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']非启运港业务，“业务类型”不应包含“QYGTS”！'),'N',CURRENT_TIMESTAMP
;
              COMMIT;
            ELSE
              BEGIN
                IF BJTS_LSF_XX_QYGCXCKBZ_001='Y' THEN
                  INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                       SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                              'CKTS_SB_DB_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'WZF_DBTS_BGD_QYGTS_CXCK','E',
                              ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']为启运港业务，已经撤销出口！'),'N',CURRENT_TIMESTAMP
;
                  COMMIT;
                END IF;
                CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',BJTS_LSF_XX_QYRQ_SH_001,LC_FLGLCD, LN_CPCODEKZ);
                IF (LC_FLGLCD<>'A' AND LC_FLGLCD<>'B') THEN
                  INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                       SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                              'CKTS_SB_DB_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'WZF_DBTS_BGD_QYGTS_FLGLCD','E',
                              ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']启运日当天该企业分类管理类别非一、二类，“业务类型”不应包含“QYGTS”！'),'N',CURRENT_TIMESTAMP
;
                  COMMIT;
                END IF;
                IF TIMESTAMPDIFF(MONTH, BJTS_LSF_XX_QYRQ_SH_001, DATE(CURRENT_TIMESTAMP))>2 THEN
                  INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                       SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                              'CKTS_SB_DB_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'WZF_DBTS_BGD_QYGTS_CKRQ','E',
                              ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']超过启运日两月，“业务类型”不应包含“QYGTS”！'),'N',CURRENT_TIMESTAMP
;
                  COMMIT;
                END IF;
                IF BJTS_LSF_XX_QYGWDDBZ_001='Y' THEN
                  INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                       SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                              'CKTS_SB_DB_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'WZF_DBTS_BGD_QYGTS_WDD','E',
                              ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']未实际到达离境港，“业务类型”不应包含“QYGTS”！'),'N',CURRENT_TIMESTAMP
;
                  COMMIT;
                END IF;
              END;
            END IF;
          END;
        ELSE
          BEGIN
            IF (BJTS_LSF_XX_CKRQ_SB_001<>BJTS_LSF_XX_CKRQ_SH_001) AND (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_001,'BSQ')=0) THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_DB_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'WZF_DBTS_BGD_CKRQ','E',
                          ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']出口日期['), DATE_FORMAT(BJTS_LSF_XX_CKRQ_SB_001, '%Y-%m-%d')), ']与电子信息中['), DATE_FORMAT(BJTS_LSF_XX_CKRQ_SH_001, '%Y-%m-%d')), ']不一致！'),'N',CURRENT_TIMESTAMP
;
              COMMIT;
            END IF;
            IF (BJTS_LSF_XX_QYGBZ_001='Y' AND BJTS_LSF_XX_QYGZCJGBZ_001='N') THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_DB_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'WZF_DBTS_BGD_QYGTS_NULL','E',
                          ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']为启运港业务，目前尚未收到结关信息，“业务类型”应包含“QYGTS”！'),'N',CURRENT_TIMESTAMP
;
              COMMIT;
            END IF;
          END;
        END IF;

        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_001,'BSQ')>0) THEN
          IF (BJTS_LSF_XX_YSFS_DM_001<>'0') THEN
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                        'CKTS_SB_DB_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'WZF_DBTS_BGD_BSQ_NOT','E',
                        ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']非经保税区出口业务，“业务类型”不应包含“BSQ”！'),'N',CURRENT_TIMESTAMP
;
            COMMIT;
           ELSE
            BEGIN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_DB_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'WZF_DBTS_BGD_BSQ_BAQD','I',
                          ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']业务类型包含保税区BSQ，请核实是否附送《出境货物备案清单》！'),'Y',CURRENT_TIMESTAMP
;
              COMMIT;
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_DB_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'WZF_DBTS_BGD_BSQ_BANR','I',
                          ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']业务类型包含保税区BSQ，请核实出境货物备案清单的内容是否与报关单相关内容相符,出口日期填报是否准确！'),'Y',CURRENT_TIMESTAMP
;
              COMMIT;
            END;
           END IF;
        END IF;
        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_001,'BSQ')=0 AND BJTS_LSF_XX_YSFS_DM_001='0') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_DB_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'WZF_DBTS_BGD_BSQ_NULL','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']为经保税区出口业务，“业务类型”应包含“BSQ”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_YSFS_DM_001='T' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_DB_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'WZF_DBTS_BGD_YSFS','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']为出口到综合试验区（横琴平潭地区）的报关单！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
      END;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;
  END;

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_DB_TSSB_LSB',NULL,NULL,NULL,T.CKBGDH,'WZF_DBTS_BGD_CKSL','E',
                ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), ']申报退税数量['), T.CKSL_SB), ']超过报关单出口数量['), S.CKSL), ']）！'),'N',CURRENT_TIMESTAMP
           FROM (SELECT A.CKBGDH, SUM(A.CKSL) AS CKSL_SB
                   FROM CKTS_SB_DB_TSSB_LSB A
                  WHERE A.SBID=V_IN_SBID
                   AND FUNC_XXBD_CHECK_YWLX(ORA_CONCAT(ORA_CONCAT(',', A.CKTMSYWLXDMJH), ',')) = 0
                  GROUP BY A.CKBGDH) T
          INNER JOIN CKTS_WBSJ_HG_BGD201 S ON S.DJXH=V_IN_DJXH AND S.CKBGDH=T.CKBGDH
          WHERE T.CKSL_SB > S.CKSL + 1.0;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_DB_TSSB_LSB',NULL,NULL,NULL,T.CKBGDH,'WZF_DBTS_BGD_CKSL','W',
                ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), ']申报退税数量['), T.CKSL_SB), ']超过电子信息中剩余数['), GREATEST(0,S.CKSL - IFNULL(S.TSSBSL, 0) - IFNULL(S.TYSL, 0) - IFNULL(S.DLSBSL, 0))), ']（其中出口['), S.CKSL), ']退税申报['), IFNULL(S.TSSBSL, 0)), ']退运['), IFNULL(S.TYSL, 0)), ']代理申报['), IFNULL(S.DLSBSL, 0)), ']）！'),'Y',CURRENT_TIMESTAMP
           FROM (SELECT A.CKBGDH, SUM(A.CKSL) AS CKSL_SB
                   FROM CKTS_SB_DB_TSSB_LSB A
                  WHERE A.SBID=V_IN_SBID
                   AND FUNC_XXBD_CHECK_YWLX(ORA_CONCAT(ORA_CONCAT(',', A.CKTMSYWLXDMJH), ',')) = 0
                  GROUP BY A.CKBGDH) T
          INNER JOIN CKTS_WBSJ_HG_BGD201 S ON S.DJXH=V_IN_DJXH AND S.CKBGDH=T.CKBGDH
          WHERE T.CKSL_SB <= S.CKSL + 1.0
            AND T.CKSL_SB > S.CKSL - IFNULL(S.TSSBSL, 0) - IFNULL(S.TYSL, 0) - IFNULL(S.DLSBSL, 0) + 1.0;
    COMMIT;


    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_DB_TSSB_LSB',NULL,NULL,NULL,T.CKBGDH,'WZF_DBTS_BGD_MYLAJ','W',
                ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), ']申报美元离岸价['), T.MYLAJ_SB), ']超过电子信息中剩余数['), GREATEST(0,S.MYLAJ - IFNULL(S.TSSBMYLAJ, 0) - IFNULL(S.TYMYLAJ, 0) - IFNULL(S.DLSBMYLAJ, 0))), ']（其中出口['), S.MYLAJ), ']退税申报['), IFNULL(S.TSSBMYLAJ, 0)), ']退运['), IFNULL(S.TYMYLAJ, 0)), ']代理申报['), IFNULL(S.DLSBMYLAJ, 0)), ']）！'),'Y',CURRENT_TIMESTAMP
           FROM (SELECT A.CKBGDH, SUM(A.MYLAJ) AS MYLAJ_SB
                   FROM CKTS_SB_DB_TSSB_LSB A
                  WHERE A.SBID=V_IN_SBID
                   AND FUNC_XXBD_CHECK_YWLX(ORA_CONCAT(ORA_CONCAT(',', A.CKTMSYWLXDMJH), ',')) = 0
                  GROUP BY A.CKBGDH) T
          INNER JOIN CKTS_WBSJ_HG_BGD201 S ON S.DJXH=V_IN_DJXH AND S.CKBGDH=T.CKBGDH
          WHERE T.MYLAJ_SB > S.MYLAJ - IFNULL(S.TSSBMYLAJ, 0) - IFNULL(S.TYMYLAJ, 0) - IFNULL(S.DLSBMYLAJ, 0) + 1.0;
    COMMIT;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_WZF_TSSB_BGD.sql

-- ======================================================================
-- [087/114] BEGIN SOURCE: PROC_XXBD_WZF_TSSB_ZZSFP.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_WZF_TSSB_ZZSFP$$

CREATE PROCEDURE PROC_XXBD_WZF_TSSB_ZZSFP
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（外综服代办退税）
  调整日期：20201106，对金额增加null判断
  调整日期：20201112，CKTS_WBSJ_ZJ_SCWTDBBA表中一般纳税人认定日期不准确，取消出口日期生产企业非一般纳税人校验
  调整日期：20201119，对疑点MTS_JHMX_ZZSFP_SBJE的描述进行调整，细化企业发票开票数、已申报数据提示
  调整日期：20201230，1、校验发票稽核信息时，剔除代开发票的稽核信息，代开发票开票人税号含DK
  修改日期：20210830，WZF_DBTS_WTFSH_YHZH疑点拆分为两个，名称不一致的（有可能全称与简称的区别）可挑过，账号不一致的不可跳过
  调整日期：20220701，1、根据全电票规则调整发票的关联，用JHPZH代替FPDM+FPHM
  调整日期：20220808，1、根据外综服代办退税备案取消的政策，调整原先与外综服代办退税备案结果表比对的口径，
                      改为与外综服企业备案信息、生产企业委托代办退税备案外部数据比对
  调整日期：20220830，1、取消综服企业银行名称的校验，只保留银行账号的校验
  调整日期：20230207，1、修改全电发票关联虚开发票时的BUG。
  调整日期：20230315，调整出口企业首次申报日期取数口径，改为按税务机关+企业+业务代码查询首次发放日期
  调整日期：20230515，解决增值税发票外部数据部分数据稽核相符标志为空的问题（赋默认值N）
  调整日期：20230518，解决按税务机关+企业+业务代码查询首次发放日期有结果但日期为空的问题（赋默认值SYSDATE）
  调整日期：20230814，针对异常扣税凭证做了追回处理后解除异常重新申报退税的总量控制bug，拆分WZF_DBTS_ZZSFP_SBJE疑点
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LDT_TODAY       DATETIME;
  DECLARE LDT_SCSBRQ      DATETIME;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';
  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  -- 代办退税发票记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_DB_TSSB_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;

  -- 查询企业首次申报日期
  BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
      SET LDT_SCSBRQ =LDT_TODAY;

  END;
SELECT IFNULL(T.FFRQ, CURRENT_TIMESTAMP)
      INTO LDT_SCSBRQ
      FROM CKTS_TY_YWBLXX_SCFFRQ T
     WHERE T.TSSWJG_DM_1=(SELECT SWJG_DM FROM GS_DJ_CKTMSDAB WHERE NSRDZDAH=V_IN_NSRDZDAH)
       AND T.DJXH=V_IN_DJXH AND T.LCSWSX_DM='LCSXA081040001';
  END;

  SET LC_YDOBJECT ='代办发票';
  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_DB_TSSB_LSB',NULL,NULL,T.SBXH,NULL,'WZF_DBTS_ZZSFP_WDZXX','E',ORA_CONCAT(ORA_CONCAT('代办退税发票[', T.DBTSWSPZHM), ']无电子信息！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_DB_TSSB_LSB T
          WHERE T.SBID=V_IN_SBID
            AND NOT EXISTS (SELECT 1
                              FROM CKTS_WBSJ_FP_ZZSZYFPXX S
                             WHERE S.DJXH=V_IN_DJXH
                               AND S.JHPZH=T.DBTSWSPZHM);
    COMMIT;
  END;

  BEGIN
    CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',LDT_TODAY,LC_FLGLCD, LN_CPCODEKZ);
    BEGIN
  DECLARE BJTS_CURSOR_DONE_002 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_SBXH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_DBTSWSPZHM_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKTMSYWLXDMJH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_JHXFZZSZYFPBZ_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_BYTSBZ_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_WTDBTSSCQYNSRSBH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_XFNSRSBH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_KPRQ_SB_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_KPRQ_SH_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_FPYT_DM_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_FPSJBZ_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_NXZCKBZ_002 LONGTEXT;
  DECLARE BJTS_LSF_XX_GHFNSRSBH_002 LONGTEXT;
  DECLARE BJTS_CURSOR_002 CURSOR FOR
SELECT A.SBXH,
                          A.DBTSWSPZHM,
                          IFNULL(A.CKTMSYWLXDMJH, ' ') AS CKTMSYWLXDMJH,
                          IFNULL(B.JHXFZZSZYFPBZ, 'N') AS JHXFZZSZYFPBZ,
                          B.BYTSBZ,
                          A.WTDBTSSCQYNSRSBH,
                          B.XFNSRSBH,
                          DATE(A.KPRQ) AS KPRQ_SB,
                          DATE(B.KPRQ) AS KPRQ_SH,
                          B.FPYT_DM,
                          IFNULL(B.FPSJBBZ, 'N') AS FPSJBZ,
                          IFNULL(B.NXZCKBZ, 'N') AS NXZCKBZ,
                          C.GHFNSRSBH
                     FROM CKTS_SB_DB_TSSB_LSB A
                    INNER JOIN CKTS_WBSJ_FP_ZZSZYFPXX B ON B.DJXH=V_IN_DJXH AND B.JHPZH=A.DBTSWSPZHM
                     LEFT JOIN CKTS_WBSJ_ZJ_XKFP C ON ORA_CONCAT(C.FP_DM, C.FPHM)=A.DBTSWSPZHM
                    WHERE A.SBID=V_IN_SBID;
  OPEN BJTS_CURSOR_002;
  BJTS_CURSOR_LOOP_002: LOOP
    SET BJTS_CURSOR_DONE_002 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_002 = TRUE;
      FETCH BJTS_CURSOR_002 INTO BJTS_LSF_XX_SBXH_002, BJTS_LSF_XX_DBTSWSPZHM_002, BJTS_LSF_XX_CKTMSYWLXDMJH_002, BJTS_LSF_XX_JHXFZZSZYFPBZ_002, BJTS_LSF_XX_BYTSBZ_002, BJTS_LSF_XX_WTDBTSSCQYNSRSBH_002, BJTS_LSF_XX_XFNSRSBH_002, BJTS_LSF_XX_KPRQ_SB_002, BJTS_LSF_XX_KPRQ_SH_002, BJTS_LSF_XX_FPYT_DM_002, BJTS_LSF_XX_FPSJBZ_002, BJTS_LSF_XX_NXZCKBZ_002, BJTS_LSF_XX_GHFNSRSBH_002;
    END;
    IF BJTS_CURSOR_DONE_002 THEN
      LEAVE BJTS_CURSOR_LOOP_002;
    END IF;
      BEGIN
        IF (BJTS_LSF_XX_JHXFZZSZYFPBZ_002='N' AND INSTR(BJTS_LSF_XX_XFNSRSBH_002,'DK')=0 AND (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_002,'RZZL')>0 OR LC_FLGLCD='D' OR (LC_FLGLCD='C' AND TIMESTAMPDIFF(MONTH, LDT_SCSBRQ, LDT_TODAY)<=12))) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_DB_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'WZF_DBTS_ZZSFP_WDZXX','E',ORA_CONCAT(ORA_CONCAT('代办退税发票[', BJTS_LSF_XX_DBTSWSPZHM_002), ']无稽核相符电子信息！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_BYTSBZ_002='Y' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_DB_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'WZF_DBTS_ZZSFP_BYTS','E',ORA_CONCAT(ORA_CONCAT('代办退税发票[', BJTS_LSF_XX_DBTSWSPZHM_002), ']已被标注为“不予退税”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_WTDBTSSCQYNSRSBH_002<>BJTS_LSF_XX_XFNSRSBH_002 THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_DB_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'WZF_DBTS_ZZSFP_GHFNSR','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代办退税发票[', BJTS_LSF_XX_DBTSWSPZHM_002), ']供货方纳税人['), BJTS_LSF_XX_WTDBTSSCQYNSRSBH_002), ']与电子信息中['), BJTS_LSF_XX_XFNSRSBH_002), ']不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_KPRQ_SB_002<>BJTS_LSF_XX_KPRQ_SH_002 THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_DB_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'WZF_DBTS_ZZSFP_KPRQ','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代办退税发票[', BJTS_LSF_XX_DBTSWSPZHM_002), ']开票日期['), DATE_FORMAT(BJTS_LSF_XX_KPRQ_SB_002, '%Y-%m-%d')), ']与电子信息中['), DATE_FORMAT(BJTS_LSF_XX_KPRQ_SH_002, '%Y-%m-%d')), ']不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_FPYT_DM_002<>'3' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_DB_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'WZF_DBTS_ZZSFP_DBTS','E',ORA_CONCAT(ORA_CONCAT('代办退税发票[', BJTS_LSF_XX_DBTSWSPZHM_002), ']在电子信息中申报用途代码不是“3-代办退税”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
        IF (BJTS_LSF_XX_FPYT_DM_002='1' AND BJTS_LSF_XX_FPSJBZ_002='Y' AND BJTS_LSF_XX_NXZCKBZ_002='N') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_DB_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'WZF_DBTS_ZZSFP_YDK','E',ORA_CONCAT(ORA_CONCAT('代办退税发票[', BJTS_LSF_XX_DBTSWSPZHM_002), ']在电子信息中已勾选用于抵扣！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_GHFNSRSBH_002 IS NOT NULL THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_DB_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_002,NULL,'WZF_DBTS_ZZSFP_XKFP','E',ORA_CONCAT(ORA_CONCAT('代办退税发票[', BJTS_LSF_XX_DBTSWSPZHM_002), ']在电子信息中为虚开增值税专用发票！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
      END;

  END LOOP BJTS_CURSOR_LOOP_002;
  CLOSE BJTS_CURSOR_002;
END;
  END;

  BEGIN
    BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_SBXH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_WTDBTSSCQYNSRSBH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKRQ_1_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_NSRSBH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_BACHBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_BACHRQ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_NSRRDSJQ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_NSRRDSJZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_YBNSRZXGMNSRSJQ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_YBNSRZXGMNSRSJZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TZCKTMSQBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TZCKTMSQQSRQ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TZCKTMSQJZRQ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TSGMSBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TSGMSQSRQ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TSGMSJZRQ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_FQCKTMSQBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_FQCKTMSQQSRQ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_FQCKTMSQJZRQ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TSKHYHMC_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TSKHYHZH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_YHMC_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_YHZH_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT DISTINCT
                          A.SBXH,
                          A.WTDBTSSCQYNSRSBH,
                          A.CKRQ_1,
                          C.NSRSBH,
                          C.BACHBZ,
                          C.BACHRQ,
                          C.NSRRDSJQ,
                          C.NSRRDSJZ,
                          C.YBNSRZXGMNSRSJQ,
                          C.YBNSRZXGMNSRSJZ,
                          C.TZCKTMSQBZ,
                          C.TZCKTMSQQSRQ,
                          C.TZCKTMSQJZRQ,
                          C.TSGMSBZ,
                          C.TSGMSQSRQ,
                          C.TSGMSJZRQ,
                          C.FQCKTMSQBZ,
                          C.FQCKTMSQQSRQ,
                          C.FQCKTMSQJZRQ,
                          IFNULL(C.TSKHYHMC, '1') AS TSKHYHMC,
                          IFNULL(C.TSKHYHZH, '1') AS TSKHYHZH,
                          B.YHMC,
                          B.YHZH
                     FROM CKTS_SB_DB_TSSB_LSB A
                    INNER JOIN GS_DJ_CKTMSDAB B ON B.NSRDZDAH=V_IN_NSRDZDAH
                     LEFT JOIN CKTS_WBSJ_ZJ_SCWTDBBA C ON C.DJXH=V_IN_DJXH AND (C.NSRSBH=A.WTDBTSSCQYNSRSBH OR C.SHXYDM=A.WTDBTSSCQYNSRSBH)
                    WHERE A.SBID=V_IN_SBID;
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_LSF_XX_SBXH_001, BJTS_LSF_XX_WTDBTSSCQYNSRSBH_001, BJTS_LSF_XX_CKRQ_1_001, BJTS_LSF_XX_NSRSBH_001, BJTS_LSF_XX_BACHBZ_001, BJTS_LSF_XX_BACHRQ_001, BJTS_LSF_XX_NSRRDSJQ_001, BJTS_LSF_XX_NSRRDSJZ_001, BJTS_LSF_XX_YBNSRZXGMNSRSJQ_001, BJTS_LSF_XX_YBNSRZXGMNSRSJZ_001, BJTS_LSF_XX_TZCKTMSQBZ_001, BJTS_LSF_XX_TZCKTMSQQSRQ_001, BJTS_LSF_XX_TZCKTMSQJZRQ_001, BJTS_LSF_XX_TSGMSBZ_001, BJTS_LSF_XX_TSGMSQSRQ_001, BJTS_LSF_XX_TSGMSJZRQ_001, BJTS_LSF_XX_FQCKTMSQBZ_001, BJTS_LSF_XX_FQCKTMSQQSRQ_001, BJTS_LSF_XX_FQCKTMSQJZRQ_001, BJTS_LSF_XX_TSKHYHMC_001, BJTS_LSF_XX_TSKHYHZH_001, BJTS_LSF_XX_YHMC_001, BJTS_LSF_XX_YHZH_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
      BEGIN
        IF (BJTS_LSF_XX_NSRSBH_001 IS NULL) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_DB_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'WZF_DBTS_WTFSH_DBBA','E',ORA_CONCAT(ORA_CONCAT('“未收到该委托代办退税生产企业”[', BJTS_LSF_XX_WTDBTSSCQYNSRSBH_001), ']的委托代办退税备案信息！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        ELSEIF (BJTS_LSF_XX_BACHBZ_001='Y' AND BJTS_LSF_XX_CKRQ_1_001>BJTS_LSF_XX_BACHRQ_001) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_DB_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'WZF_DBTS_WTFSH_TMSBA','E',ORA_CONCAT(ORA_CONCAT('“委托代办退税的生产企业”[', BJTS_LSF_XX_WTDBTSSCQYNSRSBH_001), ']已经办理备案撤回！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        ELSEIF (BJTS_LSF_XX_TSKHYHZH_001<>BJTS_LSF_XX_YHZH_001) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_DB_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'WZF_DBTS_WTFSH_YHZH','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('“综服企业备案银行账号”[', BJTS_LSF_XX_YHZH_001), ']与委托代办退税备案信息中的账号”['), BJTS_LSF_XX_TSKHYHZH_001), ']不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
/*        ELSIF (LSF_XX.TSKHYHMC<>LSF_XX.YHMC) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                      'CKTS_SB_DB_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'WZF_DBTS_WTFSH_YHZH','E','“综服企业备案银行名称”[' || LSF_XX.YHMC || ']与委托代办退税备案信息中的名称”[' || LSF_XX.TSKHYHMC || ']不一致！','N',SYSDATE
                 FROM DUAL;
          COMMIT;*/
        END IF;

        IF (BJTS_LSF_XX_TZCKTMSQBZ_001 IN ('Y','1') AND BJTS_LSF_XX_CKRQ_1_001>BJTS_LSF_XX_TZCKTMSQQSRQ_001 AND BJTS_LSF_XX_CKRQ_1_001<BJTS_LSF_XX_TZCKTMSQJZRQ_001) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_DB_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'WZF_DBTS_CKRQ_TQQY_SC','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(BJTS_LSF_XX_CKRQ_1_001, '%Y-%m-%d')), ']委托代办退税的生产企业处于出口退税停权期间！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (BJTS_LSF_XX_TSGMSBZ_001 IN ('Y','1') AND BJTS_LSF_XX_CKRQ_1_001>BJTS_LSF_XX_TSGMSQSRQ_001 AND BJTS_LSF_XX_CKRQ_1_001<BJTS_LSF_XX_TSGMSJZRQ_001) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_DB_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'WZF_DBTS_CKRQ_MSQY_SC','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(BJTS_LSF_XX_CKRQ_1_001, '%Y-%m-%d')), ']委托代办退税的生产企业处于免税期间！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (BJTS_LSF_XX_FQCKTMSQBZ_001 IN ('Y','1') AND BJTS_LSF_XX_CKRQ_1_001>BJTS_LSF_XX_FQCKTMSQQSRQ_001 AND BJTS_LSF_XX_CKRQ_1_001<BJTS_LSF_XX_FQCKTMSQJZRQ_001) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_DB_TSSB_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'WZF_DBTS_CKRQ_FQTS_SC','E',ORA_CONCAT(ORA_CONCAT('出口日期[', DATE_FORMAT(BJTS_LSF_XX_CKRQ_1_001, '%Y-%m-%d')), ']委托代办退税的生产企业处于放弃退（免）税权期间！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
      END;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;
  END;

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_DB_TSSB_LSB',NULL,NULL,NULL,T.DBTSWSPZHM,'WZF_DBTS_ZZSFP_SBJE','E',
                ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('增值税专用发票[', T.DBTSWSPZHM), ']申报退税的计税金额['), T.JSJE), ']超过电子信息中开票金额['), S.JE), ']）！'),'N',CURRENT_TIMESTAMP
           FROM (SELECT A.DBTSWSPZHM, SUM(A.JSJE) AS JSJE
                   FROM CKTS_SB_DB_TSSB_LSB A
                  WHERE A.SBID=V_IN_SBID
                  GROUP BY A.DBTSWSPZHM) T
          INNER JOIN CKTS_WBSJ_FP_ZZSZYFPXX S ON S.DJXH=V_IN_DJXH AND S.JHPZH=T.DBTSWSPZHM
          WHERE T.JSJE > S.JE + 0.1;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_DB_TSSB_LSB',NULL,NULL,NULL,T.DBTSWSPZHM,'WZF_DBTS_ZZSFP_SBJE','W',
                ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('增值税专用发票[', T.DBTSWSPZHM), ']申报退税的计税金额['), T.JSJE), ']超过电子信息中剩余数['), GREATEST(0,S.JE - IFNULL(S.HZCJJE, 0) - IFNULL(S.SBFPJSJE, 0) - IFNULL(S.LSLSBFPJSJE, 0))), ']（其中开票['), S.JE), ']红字冲减['), IFNULL(S.HZCJJE, 0)), ']出口货物劳务已申报['), IFNULL(S.SBFPJSJE, 0)), ']外购应税服务已申报['), IFNULL(S.LSLSBFPJSJE, 0)), ']）！'),'Y',CURRENT_TIMESTAMP
           FROM (SELECT A.DBTSWSPZHM, SUM(A.JSJE) AS JSJE
                   FROM CKTS_SB_DB_TSSB_LSB A
                  WHERE A.SBID=V_IN_SBID
                  GROUP BY A.DBTSWSPZHM) T
          INNER JOIN CKTS_WBSJ_FP_ZZSZYFPXX S ON S.DJXH=V_IN_DJXH AND S.JHPZH=T.DBTSWSPZHM
          WHERE T.JSJE <= S.JE + 0.1
            AND T.JSJE > S.JE - IFNULL(S.HZCJJE, 0) - IFNULL(S.SBFPJSJE, 0) - IFNULL(S.LSLSBFPJSJE, 0) + 0.1;
    COMMIT;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_WZF_TSSB_ZZSFP.sql

-- ======================================================================
-- [088/114] BEGIN SOURCE: PROC_XXBD_XFS.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_XFS$$

CREATE PROCEDURE PROC_XXBD_XFS
/*
  编制人:严国平
  编制日期:202010
  功能:信息比对（出口非自产货物退消费税）
  修改日期：20220615，根据2022年9号公告，合并收汇与不能收汇
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE BJTS_ROUTINE_EXIT BOOLEAN DEFAULT FALSE;
  DECLARE LDT_TODAY       DATETIME;

  DECLARE LC_QYHGDM       VARCHAR(20);
  DECLARE LC_QYLXDM       VARCHAR(20);
  DECLARE LC_TSJSFSDM     VARCHAR(20);
  DECLARE LC_WMZHFWQYBZ   VARCHAR(20);
  DECLARE LC_SFYSFW       VARCHAR(20);
  DECLARE LC_YSFW         VARCHAR(50);
  DECLARE LC_YSFS         VARCHAR(50);
  DECLARE LC_YFSJ         VARCHAR(50);
  DECLARE LC_ZXFLAG       VARCHAR(20);

  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LN_TGSHZL       BIGINT;
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LN_ROWNUM_CKMX  BIGINT;
  DECLARE LN_ROWNUM_CKSH  BIGINT;
  DECLARE LN_ROWNUM_CQSB  BIGINT;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';
  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  IF V_IN_SSSQ>DATE_FORMAT(CURRENT_TIMESTAMP, '%Y%m') THEN
    BEGIN
      SET V_OUT_STATUS ='05';
      SET V_OUT_MESSAGE ='申报所属时期超出合理范围！';
      LEAVE routine_body;
    END;
  END IF;

  -- 取各申报明细表数据记录
  BEGIN
  DECLARE BJTS_SQLCODE_009 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_009 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_009 = MYSQL_ERRNO, BJTS_SQLERRM_009 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='06';
      SET V_OUT_MESSAGE ='查询申报记录数据失败！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT COUNT(1)
      INTO LN_ROWNUM_CKMX
      FROM CKTS_SB_FZC_SBMX_LSB
     WHERE SBID=V_IN_SBID;
    SELECT COUNT(1)
      INTO LN_ROWNUM_CKSH
      FROM CKTS_SB_FZC_CKSH_LSB
     WHERE SBID=V_IN_SBID;
    SELECT COUNT(1)
      INTO LN_ROWNUM_CQSB
      FROM CKTS_SB_FZC_SBMX_LSB
     WHERE SBID=V_IN_SBID
       AND FUNC_XXBD_CHECK_NEEDSH(ORA_CONCAT(ORA_CONCAT(',', CKTMSYWLXDMJH), ',')) = 1
       AND (((STR_TO_DATE(ORA_CONCAT(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y'), '0420'), '%Y%m%d')<DATE(CURRENT_TIMESTAMP)) AND (KPRQ<MAKEDATE(YEAR(CURRENT_TIMESTAMP), 1))) OR (KPRQ<DATE_ADD(MAKEDATE(YEAR(CURRENT_TIMESTAMP), 1), INTERVAL -12 MONTH)));
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LN_ROWNUM_CKMX=0 THEN
    BEGIN
      SET V_OUT_STATUS ='07';
      SET V_OUT_MESSAGE ='申报数据为空！';
      LEAVE routine_body;
    END;
  END IF;

  -- 查询企业基本信息
  BEGIN
  DECLARE BJTS_SQLCODE_008 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_008 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_008 = MYSQL_ERRNO, BJTS_SQLERRM_008 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='08';
      SET V_OUT_MESSAGE ='企业当前未进行出口退（免）税备案，不允许申报除出口退（免）税备案以外的其他业务！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT T.QYHGDM, T.QYLX_DM, T.TSJSFS_DM, T.WMZHFWQYBZ, T.SFYSFW, T.YSFW, T.YSFS, T.YFSJ, T.ZX_FLAG
      INTO LC_QYHGDM, LC_QYLXDM, LC_TSJSFSDM, LC_WMZHFWQYBZ, LC_SFYSFW, LC_YSFW, LC_YSFS, LC_YFSJ, LC_ZXFLAG
      FROM GS_DJ_CKTMSDAB T
     WHERE T.NSRDZDAH=V_IN_NSRDZDAH;
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LC_ZXFLAG='Y' THEN
    BEGIN
      SET V_OUT_STATUS ='09';
      SET V_OUT_MESSAGE ='企业当前已出口退（免）税备案撤回，不允许申报除出口退（免）税备案以外的其他业务！';
      LEAVE routine_body;
    END;
  END IF;

  -- 取企业的FLGLCD信息, TGSHZL信息，判断是否需要申报收汇
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',LDT_TODAY,LC_FLGLCD, LN_CPCODEKZ);
  IF LN_CPCODEKZ=0 THEN
    BEGIN
      SET V_OUT_STATUS ='10';
      SET V_OUT_MESSAGE ='查询出口企业分类管理类型出错！';
      LEAVE routine_body;
    END;
  END IF;

  IF ((LC_QYLXDM<>'1' AND LC_QYLXDM<>'2') OR LC_TSJSFSDM<>'1') THEN
    BEGIN
      SET V_OUT_STATUS ='11';
      SET V_OUT_MESSAGE ='备案信息中企业类型、退免税计算方法与当前申报业务冲突！';
      LEAVE routine_body;
    END;
  END IF;

  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'YBNSRRD',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=0 THEN
    BEGIN
      SET V_OUT_STATUS ='12';
      SET V_OUT_MESSAGE ='企业当前非增值税一般纳税人，不允许申报出口退（免）税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TQQY',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 THEN
    BEGIN
      SET V_OUT_STATUS ='13';
      SET V_OUT_MESSAGE ='企业当前处于出口退税停权期间，不允许申报出口退（免）税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTSSXMS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_CKMX>0 THEN
    BEGIN
      SET V_OUT_STATUS ='14';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权选择免税期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTSSXZS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_CKMX>0 THEN
    BEGIN
      SET V_OUT_STATUS ='15';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权选择征税期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTMS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_CKMX>0 THEN
    BEGIN
      SET V_OUT_STATUS ='16';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;

  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TGSHZL',LDT_TODAY,LC_KZXX, LN_TGSHZL);
  IF (LC_FLGLCD='D') AND LN_ROWNUM_CKMX>0 AND LN_ROWNUM_CKSH=0 THEN
    BEGIN
      SET V_OUT_STATUS ='27';
      SET V_OUT_MESSAGE ='出口退（免）税管理类别为四类的企业，申报出口退免税时必须申报收汇情况表！';
      LEAVE routine_body;
    END;
  ELSEIF (LN_TGSHZL>0) AND LN_ROWNUM_CKMX>0 AND LN_ROWNUM_CKSH=0 THEN
    BEGIN
      SET V_OUT_STATUS ='28';
      SET V_OUT_MESSAGE ='被认定为需提供收汇资料的企业，申报出口退免税时必须申报收汇情况表！';
      LEAVE routine_body;
    END;
  ELSEIF (LN_ROWNUM_CQSB>0) AND LN_ROWNUM_CKMX>0 AND LN_ROWNUM_CKSH=0 THEN
    BEGIN
      SET V_OUT_STATUS ='29';
      SET V_OUT_MESSAGE ='超期申报数据，申报出口退免税时必须申报收汇情况表！';
      LEAVE routine_body;
    END;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_007 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_007 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_007 = MYSQL_ERRNO, BJTS_SQLERRM_007 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='51';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口非自产货物退消费税明细自检出错：', BJTS_SQLCODE_007), ' - '), BJTS_SQLERRM_007);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_XFS_TSSB(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_006 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_006 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_006 = MYSQL_ERRNO, BJTS_SQLERRM_006 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='52';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口报关单自检出错：', BJTS_SQLCODE_006), ' - '), BJTS_SQLERRM_006);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_XFS_TSSB_BGD(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_005 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_005 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_005 = MYSQL_ERRNO, BJTS_SQLERRM_005 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='53';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口证明自检出错：', BJTS_SQLCODE_005), ' - '), BJTS_SQLERRM_005);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_XFS_TSSB_DLZM(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_004 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_004 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_004 = MYSQL_ERRNO, BJTS_SQLERRM_004 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='54';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('海关进口消费税缴款书自检出错：', BJTS_SQLCODE_004), ' - '), BJTS_SQLERRM_004);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_XFS_TSSB_JKXFS(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_003 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_003 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_003 = MYSQL_ERRNO, BJTS_SQLERRM_003 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='55';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('总局税收缴款书自检出错：', BJTS_SQLCODE_003), ' - '), BJTS_SQLERRM_003);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_XFS_TSSB_ZJJKS(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='62';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口收汇申报资料自检出错：', BJTS_SQLCODE_002), ' - '), BJTS_SQLERRM_002);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_XFS_CKSH(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='63';
      SET V_OUT_MESSAGE =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('海关商品代码调整表自检出错：', BJTS_SQLCODE_001), ' - '), BJTS_SQLERRM_001);
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
CALL PROC_XXBD_XFS_HGSPTZ(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;

END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_XFS.sql

-- ======================================================================
-- [089/114] BEGIN SOURCE: PROC_XXBD_XFS_BNSH.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_XFS_BNSH$$

CREATE PROCEDURE PROC_XXBD_XFS_BNSH
/*
  编制人:严国平
  编制日期:202010
  功能:信息比对（出口非自产货物退消费税）
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 不能收汇明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_FZC_BNSH_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;
  SET LC_YDOBJECT ='不能收汇';

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_FZC_BNSH_LSB','CKTS_SB_FZC_SBMX_LSB',NULL,T.SBXH,NULL,'XFS_BJGX_SHZL_CKMX_CKPZ','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', T.CKBGDH), ']未申报出口非自产货物退消费税明细！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_MTS_BNSH_LSB T
          WHERE T.SBID=V_IN_SBID
            AND T.CKBGDH IS NOT NULL
            AND NOT EXISTS (SELECT 1 FROM CKTS_SB_FZC_SBMX_LSB S WHERE S.SBID=T.SBID AND IFNULL(S.CKBGDH, S.DLCKHWZMHM)=T.CKBGDH);
    COMMIT;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_XFS_BNSH.sql

-- ======================================================================
-- [090/114] BEGIN SOURCE: PROC_XXBD_XFS_CKSH.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_XFS_CKSH$$

CREATE PROCEDURE PROC_XXBD_XFS_CKSH
/*
  编制人:严国平
  编制日期:202010
  功能:信息比对（出口非自产货物退消费税）
  修改日期：20220615，根据2022年9号公告，四类企业，需提供银行水单企业收汇情况表必须申报本期出口退税，非上述企业改为提示性疑点
  修改日期：20230207，修改代理证明出口申报收汇表的疑点逻辑和提示
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LDT_TODAY       DATETIME;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';
  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  -- 收汇明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_FZC_CKSH_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;

  SET LC_YDOBJECT ='出口收汇';
  BEGIN
    CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',LDT_TODAY,LC_FLGLCD, LN_CPCODEKZ);
    CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TGSHZL',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
    IF (LC_FLGLCD='D') OR (LN_CPCODEKZ>0) THEN
      BEGIN
        INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
             SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                    'CKTS_SB_FZC_CKSH_LSB','CKTS_SB_FZC_SBMX_LSB',NULL,T.SBXH,NULL,'XFS_BJGX_SHZL_CKMX_CKPZ','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', IFNULL(T.DLCKHWZMHM, T.CKBGDH)), ']未申报退税！'),'N',CURRENT_TIMESTAMP
               FROM CKTS_SB_FZC_CKSH_LSB T
              WHERE T.SBID=V_IN_SBID
                AND NOT EXISTS (SELECT 1 FROM CKTS_SB_FZC_SBMX_LSB S WHERE S.SBID=T.SBID AND IFNULL(S.DLCKHWZMHM, S.CKBGDH)=IFNULL(T.DLCKHWZMHM, T.CKBGDH));
        COMMIT;
      END;
    ELSE
      BEGIN
        INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
             SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                    'CKTS_SB_FZC_CKSH_LSB','CKTS_SB_FZC_SBMX_LSB',NULL,T.SBXH,NULL,'XFS_BJGX_SHZL_CKMX_CKPZ','I',ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', IFNULL(T.DLCKHWZMHM, T.CKBGDH)), ']本期未申报退税！'),'Y',CURRENT_TIMESTAMP
               FROM CKTS_SB_FZC_CKSH_LSB T
              WHERE T.SBID=V_IN_SBID
                AND NOT EXISTS (SELECT 1 FROM CKTS_SB_FZC_SBMX_LSB S WHERE S.SBID=T.SBID AND IFNULL(S.DLCKHWZMHM, S.CKBGDH)=IFNULL(T.DLCKHWZMHM, T.CKBGDH));
        COMMIT;
      END;
    END IF;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_XFS_CKSH.sql

-- ======================================================================
-- [091/114] BEGIN SOURCE: PROC_XXBD_XFS_HGSPTZ.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_XFS_HGSPTZ$$

CREATE PROCEDURE PROC_XXBD_XFS_HGSPTZ
/*
  编制人:严国平
  编制日期:202010
  功能:信息比对（出口非自产货物退消费税）
  修改日期：20230207，修改代理证明出口申报调整表的疑点逻辑和提示
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 海关代码调整明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_FZC_HGSPTZ_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;
  SET LC_YDOBJECT ='代码调整';

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_FZC_HGSPTZ_LSB','CKTS_SB_FZC_SBMX_LSB',NULL,T.SBXH,NULL,'XFS_BJGX_DMTZ_CKMX_CKPZ','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', IFNULL(T.DLCKHWZMHM, T.CKBGDH)), ']未申报退消费税明细！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_FZC_HGSPTZ_LSB T
          WHERE T.SBID=V_IN_SBID
            AND NOT EXISTS (SELECT 1 FROM CKTS_SB_FZC_SBMX_LSB S WHERE S.SBID=T.SBID AND IFNULL(S.DLCKHWZMHM, S.CKBGDH)=IFNULL(T.DLCKHWZMHM, T.CKBGDH));
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_FZC_HGSPTZ_LSB','CKTS_SB_FZC_SBMX_LSB',NULL,T.SBXH,NULL,'XFS_BJGX_DMTZ_CKMX_SPDM','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', IFNULL(T.DLCKHWZMHM, T.CKBGDH)), ']调整前商品代码与退消费税明细表中不一致！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_FZC_HGSPTZ_LSB T
          INNER JOIN CKTS_SB_FZC_SBMX_LSB S ON S.SBID=T.SBID AND IFNULL(S.DLCKHWZMHM, S.CKBGDH)=IFNULL(T.DLCKHWZMHM, T.CKBGDH)
          WHERE T.SBID=V_IN_SBID
            AND T.CKSP_DM<>S.CKSP_DM;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_FZC_HGSPTZ_LSB',NULL,NULL,T.SBXH,NULL,'XFS_BJGX_DMTZ_CKMX_ZSLV','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', IFNULL(T.DLCKHWZMHM, T.CKBGDH)), ']调整后商品代码在对应出口日期的退税率文库中的消费税税率与退消费税明细表中不一致！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_FZC_HGSPTZ_LSB T
          INNER JOIN CKTS_SB_FZC_SBMX_LSB S ON S.SBID=T.SBID AND IFNULL(S.DLCKHWZMHM, S.CKBGDH)=IFNULL(T.DLCKHWZMHM, T.CKBGDH)
           LEFT JOIN CKTS_DM_TSLVWK C ON C.CKSP_DM=T.TZHCKSP_DM AND T.CKRQ_1 BETWEEN C.YXQQ AND C.YXQZ
          WHERE T.SBID=V_IN_SBID
            AND IFNULL(C.CLDEZS, 0)<>S.ZSSL
            AND IFNULL(C.CJDLZS, 0)<>S.ZSSL;
    COMMIT;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_XFS_HGSPTZ.sql

-- ======================================================================
-- [092/114] BEGIN SOURCE: PROC_XXBD_XFS_TSSB.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_XFS_TSSB$$

CREATE PROCEDURE PROC_XXBD_XFS_TSSB
/*
  编制人:严国平
  编制日期:202010
  功能:信息比对（出口非自产货物退消费税）
  调整日期：20220323，1、根据总局货劳司关于加强启运港出口退（免）税统计分析功能的业务要求，增加XFS_CKMX_CKYWLX_QYGTS疑点
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LDT_TODAY       DATETIME;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';
  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  -- 出口明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_FZC_SBMX_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;

  SET LC_YDOBJECT ='退消费税';
  BEGIN
    CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',LDT_TODAY,LC_FLGLCD, LN_CPCODEKZ);
    CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TGSHZL',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
    IF (LC_FLGLCD='D') OR (LN_CPCODEKZ>0) THEN
      BEGIN
        INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
             SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                    'CKTS_SB_FZC_SBMX_LSB','CKTS_SB_FZC_CKSH_LSB',NULL,T.SBXH,NULL,'XFS_BJGX_CKMX_SHZL_CKPZ','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', T.CKBGDH), T.DLCKHWZMHM), ']未申报收汇资料！'),'N',CURRENT_TIMESTAMP
               FROM CKTS_SB_FZC_SBMX_LSB T
              WHERE T.SBID=V_IN_SBID
                AND FUNC_XXBD_CHECK_NEEDSH(ORA_CONCAT(ORA_CONCAT(',', T.CKTMSYWLXDMJH), ',')) = 1
                AND NOT EXISTS (SELECT 1 FROM CKTS_SB_FZC_CKSH_LSB S WHERE S.SBID=T.SBID AND ORA_CONCAT(S.CKBGDH, S.DLCKHWZMHM)=ORA_CONCAT(T.CKBGDH, T.DLCKHWZMHM));
        COMMIT;
      END;
    ELSE
      BEGIN
        INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
             SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                    'CKTS_SB_FZC_SBMX_LSB','CKTS_SB_FZC_CKSH_LSB',NULL,T.SBXH,NULL,'XFS_BJGX_CKMX_SHZL_CKPZ','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号/代理出口货物证明号[', T.CKBGDH), T.DLCKHWZMHM), ']未申报收汇资料！'),'N',CURRENT_TIMESTAMP
               FROM CKTS_SB_FZC_SBMX_LSB T
              WHERE T.SBID=V_IN_SBID
                AND (((STR_TO_DATE(ORA_CONCAT(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y'), '0419'), '%Y%m%d')<CURRENT_TIMESTAMP) AND (KPRQ<MAKEDATE(YEAR(CURRENT_TIMESTAMP), 1))) OR (KPRQ<DATE_ADD(MAKEDATE(YEAR(CURRENT_TIMESTAMP), 1), INTERVAL -12 MONTH)))
                AND FUNC_XXBD_CHECK_NEEDSH(ORA_CONCAT(ORA_CONCAT(',', T.CKTMSYWLXDMJH), ',')) = 1
                AND NOT EXISTS (SELECT 1 FROM CKTS_SB_FZC_CKSH_LSB S WHERE S.SBID=T.SBID AND ORA_CONCAT(S.CKBGDH, S.DLCKHWZMHM)=ORA_CONCAT(T.CKBGDH, T.DLCKHWZMHM));
        COMMIT;
      END;
    END IF;
  END;

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'XFS_CKMX_CKYWLX_QYGTS','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', IFNULL(T.CKBGDH, T.DLCKHWZMHM)), ']为启运港业务，需确认国内启运方式及海关总署认证企业类型！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_FZC_SBMX_LSB T
          WHERE T.SBID=V_IN_SBID
            AND INSTR(T.CKTMSYWLXDMJH,'QYGTS')>0
            AND (T.GNQYFS_DM IS NULL OR T.HGZSRZQYLX_DM IS NULL);
    COMMIT;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_XFS_TSSB.sql

-- ======================================================================
-- [093/114] BEGIN SOURCE: PROC_XXBD_XFS_TSSB_BGD.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_XFS_TSSB_BGD$$

CREATE PROCEDURE PROC_XXBD_XFS_TSSB_BGD
/*
  编制人:严国平
  编制日期:202010
  功能:信息比对（出口非自产货物退消费税）
  调整日期：20201119，1、调整改单报关单监控条件，由bgd202不存在改为bgd201.gdbz_1<>Y
  调整日期：20210113，1、调整改单报关单监控条件，改为bgd202不存在 且 bgd201.gdbz_1<>Y
  调整日期：20220720，1、增加疑点XFS_CKMX_BGD_CKRQ，报关单出口日期与电子信息不一致；
                      2、调整出口日期无退税资格疑点的口径，直接用企业申报的出口日期
  调整日期：20230313，增加XFS_CKMX_BGD_BSQ_BAQD、XFS_CKMX_BGD_BSQ_BANR疑点判断
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LN_CMCD_LEN     BIGINT;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 报关单出口明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_FZC_SBMX_LSB T
     WHERE T.SBID=V_IN_SBID
       AND T.CKBGDH IS NOT NULL;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;

  SET LC_YDOBJECT ='出口报关单';
  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'XFS_CKMX_BGD_WDZXX','E',
                ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), ']无电子信息！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_FZC_SBMX_LSB T
          WHERE T.SBID=V_IN_SBID
            AND T.CKBGDH IS NOT NULL
            AND NOT EXISTS (SELECT 1 FROM CKTS_WBSJ_HG_BGD201 S WHERE S.DJXH=V_IN_DJXH AND S.CKBGDH=T.CKBGDH);
    COMMIT;
  END;

  BEGIN
    BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_SBXH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKBGDH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_BYTSBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSP_DM_SB_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSP_DM_SH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKRQ_SB_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKRQ_SH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_QYRQ_SH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TYYBSWTSTYLX_DM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_GDBZ_1_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKBGDH_GD_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_JGFS_DM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_JGFSTSLX_DM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_YSFS_DM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKTMSYWLXDMJH_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT A.SBXH,
                          A.CKBGDH,
                          B.BYTSBZ,
                          A.CKSP_DM AS CKSP_DM_SB,
                          B.CKSP_DM AS CKSP_DM_SH,
                          DATE(A.KPRQ) AS CKRQ_SB,
                          DATE(B.CKRQ_1) AS CKRQ_SH,
                          DATE(B.QYRQ_2) AS QYRQ_SH,
                          D.TYYBSWTSTYLX_DM,
                          IFNULL(B.GDBZ_1, ' ') AS GDBZ_1,
                          E.CKBGDH AS CKBGDH_GD,
                          C.JGFS_DM,
                          C.JGFSTSLX_DM,
                          B.YSFS_DM,
                          IFNULL(A.CKTMSYWLXDMJH, ' ') AS CKTMSYWLXDMJH
                     FROM CKTS_SB_FZC_SBMX_LSB A
                    INNER JOIN CKTS_WBSJ_HG_BGD201 B ON B.DJXH=V_IN_DJXH AND B.CKBGDH=A.CKBGDH
                     LEFT JOIN CKTS_DM_HGJGFS C ON C.JGFS_DM=B.JGFS_DM
                     LEFT JOIN CKTS_JGB_ZM_TYYBSWTS D ON D.DJXH=V_IN_DJXH AND D.CKBGDH=A.CKBGDH AND IFNULL(D.ZFBZ_1, 'N')='N'
                     LEFT JOIN CKTS_WBSJ_HG_BGD202 E ON D.DJXH=V_IN_DJXH AND E.CKBGDH=A.CKBGDH
                    WHERE A.SBID=V_IN_SBID
                      AND A.CKBGDH IS NOT NULL;
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_LSF_XX_SBXH_001, BJTS_LSF_XX_CKBGDH_001, BJTS_LSF_XX_BYTSBZ_001, BJTS_LSF_XX_CKSP_DM_SB_001, BJTS_LSF_XX_CKSP_DM_SH_001, BJTS_LSF_XX_CKRQ_SB_001, BJTS_LSF_XX_CKRQ_SH_001, BJTS_LSF_XX_QYRQ_SH_001, BJTS_LSF_XX_TYYBSWTSTYLX_DM_001, BJTS_LSF_XX_GDBZ_1_001, BJTS_LSF_XX_CKBGDH_GD_001, BJTS_LSF_XX_JGFS_DM_001, BJTS_LSF_XX_JGFSTSLX_DM_001, BJTS_LSF_XX_YSFS_DM_001, BJTS_LSF_XX_CKTMSYWLXDMJH_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
      BEGIN
        IF BJTS_LSF_XX_BYTSBZ_001='Y' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'XFS_CKMX_BGD_BYTS','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']已被标注为“不予退税”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        SET LN_CMCD_LEN = CASE WHEN LENGTH(BJTS_LSF_XX_CKSP_DM_SB_001) > LENGTH(BJTS_LSF_XX_CKSP_DM_SH_001) THEN LENGTH(BJTS_LSF_XX_CKSP_DM_SH_001) ELSE LENGTH(BJTS_LSF_XX_CKSP_DM_SB_001) END;
        IF SUBSTR(BJTS_LSF_XX_CKSP_DM_SB_001,1,LN_CMCD_LEN)<>SUBSTR(BJTS_LSF_XX_CKSP_DM_SH_001,1,LN_CMCD_LEN) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'XFS_CKMX_BGD_SPDM','E',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']商品代码['), BJTS_LSF_XX_CKSP_DM_SB_001), ']与电子信息中['), BJTS_LSF_XX_CKSP_DM_SH_001), ']不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_001,'QYGTS')>0) THEN
          IF (BJTS_LSF_XX_CKRQ_SB_001<>BJTS_LSF_XX_QYRQ_SH_001) AND (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_001,'BSQ')=0) THEN
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                        'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'XFS_CKMX_BGD_CKRQ','E',
                        ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']出口日期['), DATE_FORMAT(BJTS_LSF_XX_CKRQ_SB_001, '%Y-%m-%d')), ']与电子信息中['), DATE_FORMAT(BJTS_LSF_XX_QYRQ_SH_001, '%Y-%m-%d')), ']不一致！'),'N',CURRENT_TIMESTAMP
;
            COMMIT;
          END IF;
        ELSE
          IF (BJTS_LSF_XX_CKRQ_SB_001<>BJTS_LSF_XX_CKRQ_SH_001) AND (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_001,'BSQ')=0) THEN
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                        'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'XFS_CKMX_BGD_CKRQ','E',
                        ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']出口日期['), DATE_FORMAT(BJTS_LSF_XX_CKRQ_SB_001, '%Y-%m-%d')), ']与电子信息中['), DATE_FORMAT(BJTS_LSF_XX_CKRQ_SH_001, '%Y-%m-%d')), ']不一致！'),'N',CURRENT_TIMESTAMP
;
            COMMIT;
          END IF;
        END IF;

        -- 1退运; 2改单; 3撤单
        IF BJTS_LSF_XX_TYYBSWTSTYLX_DM_001='3' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'XFS_CKMX_BGD_CD','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']曾办理过用途为”撤单“的有效的退运证明！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        ELSEIF (BJTS_LSF_XX_TYYBSWTSTYLX_DM_001='2' AND BJTS_LSF_XX_GDBZ_1_001<>'Y' AND BJTS_LSF_XX_CKBGDH_GD_001 IS NULL) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'XFS_CKMX_BGD_GD','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']曾办理过用途为“改单”的有效的退运证明，且在“海关出口报关单改单数据”中不存在！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (TRIM(BJTS_LSF_XX_JGFS_DM_001) IS NULL) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'XFS_CKMX_BGD_MYXZ_BCZ','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']在电子信息中监管方式不存在！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        ELSEIF (TRIM(BJTS_LSF_XX_JGFSTSLX_DM_001)='0') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'XFS_CKMX_BGD_MYXZ_BTS','E',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']在电子信息中监管方式['), BJTS_LSF_XX_JGFS_DM_001), ']不退税！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_YSFS_DM_001='T' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'XFS_CKMX_CKPZH_YSFS','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']为出口到综合试验区（横琴平潭地区）的报关单！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_001,'BSQ')>0) THEN
          IF (BJTS_LSF_XX_YSFS_DM_001<>'0') THEN
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                        'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'XFS_CKMX_BGD_BSQ_NOT','E',ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']非经保税区出口业务，“业务类型”不应包含“BSQ”！'),'N',CURRENT_TIMESTAMP
;
            COMMIT;
          ELSE
            BEGIN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'XFS_CKMX_BGD_BSQ_BAQD','I',
                          ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']业务类型包含保税区BSQ，请核实是否附送《出境货物备案清单》！'),'Y',CURRENT_TIMESTAMP
;
              COMMIT;
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'XFS_CKMX_BGD_BSQ_BANR','I',
                          ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']业务类型包含保税区BSQ，请核实出境货物备案清单的内容是否与报关单相关内容相符,出口日期填报是否准确！'),'Y',CURRENT_TIMESTAMP
;
              COMMIT;
            END;
          END IF;
        END IF;
        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_001,'BSQ')=0 AND BJTS_LSF_XX_YSFS_DM_001='0') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'XFS_CKMX_BGD_BSQ_NULL','E',
                      ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', BJTS_LSF_XX_CKBGDH_001), ']为经保税区出口业务，“业务类型”应包含“BSQ”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
      END;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;
  END;

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'XFS_CKMX_CKRQ_NSRZG','E',
                ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), ']对应的出口日期['), DATE_FORMAT(T.KPRQ, '%Y-%m-%d')), ']企业非增值税一般纳税人！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_FZC_SBMX_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='YBNSRRD' AND S.FLAG='1' AND T.KPRQ BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID
            AND S.KZLX IS NULL;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'XFS_CKMX_CKRQ_TQQY','E',
                ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), ']对应的出口日期['), DATE_FORMAT(T.KPRQ, '%Y-%m-%d')), ']企业处于出口退税停权期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_FZC_SBMX_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='TQQY' AND S.FLAG='1' AND T.KPRQ BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'XFS_CKMX_CKRQ_MSQY','E',
                ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), ']对应的出口日期['), DATE_FORMAT(T.KPRQ, '%Y-%m-%d')), ']企业处于免税期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_FZC_SBMX_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='TSGMS' AND S.FLAG='1' AND T.KPRQ BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'XFS_CKMX_CKRQ_FQTS','E',
                ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), ']对应的出口日期['), DATE_FORMAT(T.KPRQ, '%Y-%m-%d')), ']企业处于放弃退（免）税权选择免税期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_FZC_SBMX_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='FQTSSXMS' AND S.FLAG='1' AND T.KPRQ BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'XFS_CKMX_CKRQ_FQTS','E',
                ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), ']对应的出口日期['), DATE_FORMAT(T.KPRQ, '%Y-%m-%d')), ']企业处于放弃退（免）税权选择征税期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_FZC_SBMX_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='FQTSSXZS' AND S.FLAG='1' AND T.KPRQ BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'XFS_CKMX_CKRQ_FQTS','E',
                ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('出口货物报关单号[', T.CKBGDH), ']对应的出口日期['), DATE_FORMAT(T.KPRQ, '%Y-%m-%d')), ']企业处于放弃退（免）税权期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_FZC_SBMX_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='FQTMS' AND S.FLAG='1' AND T.KPRQ BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_XFS_TSSB_BGD.sql

-- ======================================================================
-- [094/114] BEGIN SOURCE: PROC_XXBD_XFS_TSSB_DLZM.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_XFS_TSSB_DLZM$$

CREATE PROCEDURE PROC_XXBD_XFS_TSSB_DLZM
/*
  编制人:严国平
  编制日期:202010
  功能:信息比对（出口非自产货物退消费税）
  调整日期：20220720，1、增加疑点XFS_CKMX_DLZM_CKRQ，代理证明出口日期与电子信息不一致；
                      2、调整出口日期无退税资格疑点的口径，直接用企业申报的出口日期
  调整日期：20230313，增加XFS_CKMX_BGD_DLZM_BAQD、XFS_CKMX_DLZM_BSQ_BANR疑点判断
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);
  DECLARE LN_CMCD_LEN     BIGINT;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 代理证明号出口明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_FZC_SBMX_LSB T
     WHERE T.SBID=V_IN_SBID
       AND T.DLCKHWZMHM IS NOT NULL;
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;

  SET LC_YDOBJECT ='代理证明';
  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'XFS_CKMX_DLZM_WDZXX','E',
                ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', T.DLCKHWZMHM), ']无电子信息！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_FZC_SBMX_LSB T
          WHERE T.SBID=V_IN_SBID
            AND T.DLCKHWZMHM IS NOT NULL
            AND NOT EXISTS (SELECT 1 FROM CKTS_WBSJ_ZJ_DLCKHWZM S WHERE S.DJXH=V_IN_DJXH AND S.DLCKHWZMHM=T.DLCKHWZMHM);
    COMMIT;
  END;

  BEGIN
    BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_SBXH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_DLCKHWZMHM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_BYTSBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSP_DM_SB_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKSP_DM_SH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKRQ_SB_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKRQ_SH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_JGFS_DM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_JGFSTSLX_DM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_YSFS_DM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_CKTMSYWLXDMJH_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT A.SBXH,
                          A.DLCKHWZMHM,
                          B.BYTSBZ,
                          A.CKSP_DM AS CKSP_DM_SB,
                          B.CKSP_DM AS CKSP_DM_SH,
                          DATE(A.KPRQ) AS CKRQ_SB,
                          DATE(B.CKRQ_1) AS CKRQ_SH,
                          C.JGFS_DM,
                          C.JGFSTSLX_DM,
                          B.YSFS_DM,
                          IFNULL(A.CKTMSYWLXDMJH, ' ') AS CKTMSYWLXDMJH
                     FROM CKTS_SB_FZC_SBMX_LSB A
                    INNER JOIN CKTS_WBSJ_ZJ_DLCKHWZM B ON B.DJXH=V_IN_DJXH AND B.DLCKHWZMHM=A.DLCKHWZMHM
                     LEFT JOIN CKTS_DM_HGJGFS C ON C.JGFS_DM=B.JGFS_DM
                    WHERE A.SBID=V_IN_SBID
                      AND A.DLCKHWZMHM IS NOT NULL;
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_LSF_XX_SBXH_001, BJTS_LSF_XX_DLCKHWZMHM_001, BJTS_LSF_XX_BYTSBZ_001, BJTS_LSF_XX_CKSP_DM_SB_001, BJTS_LSF_XX_CKSP_DM_SH_001, BJTS_LSF_XX_CKRQ_SB_001, BJTS_LSF_XX_CKRQ_SH_001, BJTS_LSF_XX_JGFS_DM_001, BJTS_LSF_XX_JGFSTSLX_DM_001, BJTS_LSF_XX_YSFS_DM_001, BJTS_LSF_XX_CKTMSYWLXDMJH_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
      BEGIN
        IF BJTS_LSF_XX_BYTSBZ_001='Y' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'XFS_CKMX_DLZM_BYTS','E',
                      ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_001), ']已被标注为“不予退税”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        SET LN_CMCD_LEN = CASE WHEN LENGTH(BJTS_LSF_XX_CKSP_DM_SB_001) > LENGTH(BJTS_LSF_XX_CKSP_DM_SH_001) THEN LENGTH(BJTS_LSF_XX_CKSP_DM_SH_001) ELSE LENGTH(BJTS_LSF_XX_CKSP_DM_SB_001) END;
        IF SUBSTR(BJTS_LSF_XX_CKSP_DM_SB_001,1,LN_CMCD_LEN)<>SUBSTR(BJTS_LSF_XX_CKSP_DM_SH_001,1,LN_CMCD_LEN) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'XFS_CKMX_DLZM_SPDM','E',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_001), ']商品代码['), BJTS_LSF_XX_CKSP_DM_SB_001), ']与电子信息中['), BJTS_LSF_XX_CKSP_DM_SH_001), ']不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (BJTS_LSF_XX_CKRQ_SB_001<>BJTS_LSF_XX_CKRQ_SH_001) AND (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_001,'BSQ')=0) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'XFS_CKMX_DLZM_CKRQ','E',
                      ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_001), ']出口日期['), DATE_FORMAT(BJTS_LSF_XX_CKRQ_SB_001, '%Y-%m-%d')), ']与电子信息中['), DATE_FORMAT(BJTS_LSF_XX_CKRQ_SH_001, '%Y-%m-%d')), ']不一致！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (TRIM(BJTS_LSF_XX_JGFS_DM_001) IS NULL) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'XFS_CKMX_DLZM_MYXZ_BCZ','E',
                      ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_001), ']在电子信息中监管方式不存在！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        ELSE
          IF (TRIM(BJTS_LSF_XX_JGFSTSLX_DM_001)='0') THEN
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                        'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'XFS_CKMX_DLZM_MYXZ_BTS','E',
                        ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_001), ']在电子信息中监管方式['), BJTS_LSF_XX_JGFS_DM_001), ']不退税！'),'N',CURRENT_TIMESTAMP
;
            COMMIT;
          END IF;
        END IF;

        IF BJTS_LSF_XX_YSFS_DM_001='T' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'XFS_CKMX_CKPZH_YSFS','E',
                      ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_001), ']为出口到综合试验区（横琴平潭地区）的报关单！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_001,'BSQ')>0) THEN
          IF (BJTS_LSF_XX_YSFS_DM_001<>'0') THEN
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                        'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'XFS_CKMX_DLZM_BSQ_NOT','E',
                        ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_001), ']非经保税区出口业务，“业务类型”不应包含“BSQ”！'),'N',CURRENT_TIMESTAMP
;
            COMMIT;
          ELSE
            BEGIN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'XFS_CKMX_DLZM_BSQ_BAQD','I',
                          ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_001), ']业务类型包含保税区BSQ，请核实是否附送《出境货物备案清单》！'),'Y',CURRENT_TIMESTAMP
;
              COMMIT;
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'XFS_CKMX_DLZM_BSQ_BANR','I',
                          ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_001), ']业务类型包含保税区BSQ，请核实出境货物备案清单的内容是否与报关单相关内容相符,出口日期填报是否准确！'),'Y',CURRENT_TIMESTAMP
;
              COMMIT;
            END;
          END IF;
        END IF;
        IF (INSTR(BJTS_LSF_XX_CKTMSYWLXDMJH_001,'BSQ')=0 AND BJTS_LSF_XX_YSFS_DM_001='0') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'XFS_CKMX_DLZM_BSQ_NULL','E',
                      ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', BJTS_LSF_XX_DLCKHWZMHM_001), ']为经保税区出口业务，“业务类型”应包含“BSQ”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
      END;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;
  END;

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'XFS_CKMX_CKRQ_NSRZG','E',
                ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', T.DLCKHWZMHM), ']对应的出口日期['), DATE_FORMAT(T.KPRQ, '%Y-%m-%d')), ']企业非增值税一般纳税人！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_FZC_SBMX_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='YBNSRRD' AND S.FLAG='1' AND T.KPRQ BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID
            AND S.KZLX IS NULL;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'XFS_CKMX_CKRQ_TQQY','E',
                ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', T.DLCKHWZMHM), ']对应的出口日期['), DATE_FORMAT(T.KPRQ, '%Y-%m-%d')), ']企业处于出口退税停权期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_FZC_SBMX_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='TQQY' AND S.FLAG='1' AND T.KPRQ BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'XFS_CKMX_CKRQ_MSQY','E',
                ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', T.DLCKHWZMHM), ']对应的出口日期['), DATE_FORMAT(T.KPRQ, '%Y-%m-%d')), ']企业处于免税期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_FZC_SBMX_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='TSGMS' AND S.FLAG='1' AND T.KPRQ BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'XFS_CKMX_CKRQ_FQTS','E',
                ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', T.DLCKHWZMHM), ']对应的出口日期['), DATE_FORMAT(T.KPRQ, '%Y-%m-%d')), ']企业处于放弃退（免）税权选择免税期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_FZC_SBMX_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='FQTSSXMS' AND S.FLAG='1' AND T.KPRQ BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'XFS_CKMX_CKRQ_FQTS','E',
                ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', T.DLCKHWZMHM), ']对应的出口日期['), DATE_FORMAT(T.KPRQ, '%Y-%m-%d')), ']企业处于放弃退（免）税权选择征税期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_FZC_SBMX_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='FQTSSXZS' AND S.FLAG='1' AND T.KPRQ BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;

    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'XFS_CKMX_CKRQ_FQTS','E',
                ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('代理出口货物证明号[', T.DLCKHWZMHM), ']对应的出口日期['), DATE_FORMAT(T.KPRQ, '%Y-%m-%d')), ']企业处于放弃退（免）税权期间！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_FZC_SBMX_LSB T
          INNER JOIN GS_DJ_CKTMSDAB_KZ S ON S.NSRDZDAH=V_IN_NSRDZDAH AND S.KZLX='FQTMS' AND S.FLAG='1' AND T.KPRQ BETWEEN S.ST_DATE AND S.END_DATE
          WHERE T.SBID=V_IN_SBID;
    COMMIT;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_XFS_TSSB_DLZM.sql

-- ======================================================================
-- [095/114] BEGIN SOURCE: PROC_XXBD_XFS_TSSB_JKXFS.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_XFS_TSSB_JKXFS$$

CREATE PROCEDURE PROC_XXBD_XFS_TSSB_JKXFS
/*
  编制人:严国平
  编制日期:202010
  功能:信息比对（出口非自产货物退消费税）
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 进口消费税缴款书记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_FZC_SBMX_LSB T
     WHERE T.SBID=V_IN_SBID
       AND T.CKTMSPZLX_DM='05';
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;

  SET LC_YDOBJECT ='进口消费税';
  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'XFS_CKMX_XFSJKS_WDZXX','E',ORA_CONCAT(ORA_CONCAT('海关进口消费税缴款书[', T.XFSPZH), ']无电子信息！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_FZC_SBMX_LSB T
          WHERE T.SBID=V_IN_SBID
            AND T.CKTMSPZLX_DM='05'
            AND NOT EXISTS (SELECT 1
                              FROM CKTS_WBSJ_HG_JKJKS S
                             WHERE S.DJXH=V_IN_DJXH
                               AND S.HGZYJKSHM=T.XFSPZH);
    COMMIT;
  END;

  BEGIN
    BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_SBXH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_XFSPZH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_BYTSBZ_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_HGJKJKSCLJG_DM_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT A.SBXH,
                          A.XFSPZH,
                          B.BYTSBZ,
                          B.HGJKJKSCLJG_DM
                     FROM CKTS_SB_FZC_SBMX_LSB A
                    INNER JOIN CKTS_WBSJ_HG_JKJKS B ON B.DJXH=V_IN_DJXH AND B.HGZYJKSHM=A.XFSPZH
                    WHERE A.SBID=V_IN_SBID
                      AND A.CKTMSPZLX_DM='05';
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_LSF_XX_SBXH_001, BJTS_LSF_XX_XFSPZH_001, BJTS_LSF_XX_BYTSBZ_001, BJTS_LSF_XX_HGJKJKSCLJG_DM_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
      BEGIN
        IF BJTS_LSF_XX_BYTSBZ_001='Y' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'XFS_CKMX_JKXFS_BYTS','E',ORA_CONCAT(ORA_CONCAT('海关进口消费税缴款书[', BJTS_LSF_XX_XFSPZH_001), ']已被标注为“不予退税”！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF BJTS_LSF_XX_HGJKJKSCLJG_DM_001 IN ('100','500') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'XFS_CKMX_JKXFS_DUP','E',ORA_CONCAT(ORA_CONCAT('海关进口消费税缴款书[', BJTS_LSF_XX_XFSPZH_001), ']在电子信息中重复申请退税！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
      END;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_XFS_TSSB_JKXFS.sql

-- ======================================================================
-- [096/114] BEGIN SOURCE: PROC_XXBD_XFS_TSSB_ZJJKS.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_XFS_TSSB_ZJJKS$$

CREATE PROCEDURE PROC_XXBD_XFS_TSSB_ZJJKS
/*
  编制人:严国平
  编制日期:202010
  功能:信息比对（出口非自产货物退消费税）
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LN_MXROW        BIGINT;
  DECLARE LC_YDOBJECT     VARCHAR(20);

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 总局专用缴款书记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_FZC_SBMX_LSB T
     WHERE T.SBID=V_IN_SBID
       AND T.CKTMSPZLX_DM='06';
    IF LN_MXROW=0 THEN
      LEAVE routine_body;
    END IF;
  END;

  SET LC_YDOBJECT ='税收缴款书';
  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'XFS_CKMX_XFSSP_WDZXX','E',ORA_CONCAT(ORA_CONCAT('消费税税票[', T.XFSPZH), ']无电子信息！'),'N',CURRENT_TIMESTAMP
           FROM CKTS_SB_FZC_SBMX_LSB T
          WHERE T.SBID=V_IN_SBID
            AND T.CKTMSPZLX_DM='06'
            AND NOT EXISTS (SELECT 1
                              FROM CKTS_WBSJ_ZJ_ZJZYJKS S
                             WHERE S.DJXH=V_IN_DJXH
                               AND S.JKSHM=T.XFSPZH);
    COMMIT;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_XFS_TSSB_ZJJKS.sql

-- ======================================================================
-- [097/114] BEGIN SOURCE: PROC_XXBD_ZG_CKTMSBABG.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_ZG_CKTMSBABG$$

CREATE PROCEDURE PROC_XXBD_ZG_CKTMSBABG
/*
  编制人:严国平
  编制日期:202209
  功能:信息比对（备案变更），针对退税贷用户变更银行信息加以控制
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE BJTS_ROUTINE_EXIT BOOLEAN DEFAULT FALSE;
  DECLARE LN_ROWNUM_CKMX  BIGINT;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';

  -- 取各申报明细表数据记录
  BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='06';
      SET V_OUT_MESSAGE ='查询申报记录数据失败！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT COUNT(1)
      INTO LN_ROWNUM_CKMX
      FROM CKTS_BA_BABGQK_LSB
     WHERE SBID=V_IN_SBID;
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LN_ROWNUM_CKMX=0 THEN
    BEGIN
      SET V_OUT_STATUS ='07';
      SET V_OUT_MESSAGE ='申报数据为空！';
      LEAVE routine_body;
    END;
  END IF;

  SELECT COUNT(1)
    INTO LN_ROWNUM_CKMX
    FROM CKTS_BA_BABGQK_LSB
   WHERE SBID=V_IN_SBID
     AND BABGZD_DM='TSKHYHZH';
  IF LN_ROWNUM_CKMX=0 THEN
    LEAVE routine_body;
  END IF;

  SELECT COUNT(1)
    INTO LN_ROWNUM_CKMX
    FROM GS_DJ_CKTMSDAB T
   INNER JOIN FG_TSDQY_JGB S ON T.NSRSBH=S.NSRSBH OR T.SHXYNO=S.NSRSBH
   WHERE T.NSRDZDAH=V_IN_NSRDZDAH
     AND S.JGBZ='1';

  IF LN_ROWNUM_CKMX>0 THEN
    BEGIN
      SET V_OUT_STATUS ='17';
      SET V_OUT_MESSAGE ='企业尚未解除退税贷业务监管，暂不允许变更退税银行账号！';
      LEAVE routine_body;
    END;
  END IF;

  LEAVE routine_body;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_ZG_CKTMSBABG.sql

-- ======================================================================
-- [098/114] BEGIN SOURCE: PROC_XXBD_ZG_SCWTDBBA.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_ZG_SCWTDBBA$$

CREATE PROCEDURE PROC_XXBD_ZG_SCWTDBBA
/*
  编制人:严国平
  编制日期:202010
  功能:信息比对（委托代办退税情况备案）
  调整日期：20201217，1、在校验生产企业是否已委托某外综服企业代办时，按生产企业、综服企业分组，按办理时间排序，取最后一条，如果最后一条是撤回备案，默认为可以新增
  调整日期：20210526，1、细化生产企业提供的委托代办退税备案的外综服企业信息与出口退（免）税备案信息不一致的疑点提示
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE BJTS_ROUTINE_EXIT BOOLEAN DEFAULT FALSE;
  DECLARE LDT_TODAY       DATETIME;

  DECLARE LC_QYHGDM       VARCHAR(20);
  DECLARE LC_QYLXDM       VARCHAR(20);
  DECLARE LC_TSJSFSDM     VARCHAR(20);
  DECLARE LC_WMZHFWQYBZ   VARCHAR(20);
  DECLARE LC_SFYSFW       VARCHAR(20);
  DECLARE LC_YSFW         VARCHAR(50);
  DECLARE LC_YSFS         VARCHAR(50);
  DECLARE LC_YFSJ         VARCHAR(50);
  DECLARE LC_ZXFLAG       VARCHAR(20);

  DECLARE LC_YDOBJECT     VARCHAR(20);

  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LN_ROWNUM_CKMX  BIGINT;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';
  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  IF V_IN_SSSQ>DATE_FORMAT(CURRENT_TIMESTAMP, '%Y%m') THEN
    BEGIN
      SET V_OUT_STATUS ='05';
      SET V_OUT_MESSAGE ='申报所属时期超出合理范围！';
      LEAVE routine_body;
    END;
  END IF;

  -- 取各申报明细表数据记录
  BEGIN
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='06';
      SET V_OUT_MESSAGE ='查询申报记录数据失败！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT COUNT(1)
      INTO LN_ROWNUM_CKMX
      FROM CKTS_BA_SCQYWTDBTS_LSB
     WHERE SBID=V_IN_SBID;
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LN_ROWNUM_CKMX=0 THEN
    BEGIN
      SET V_OUT_STATUS ='07';
      SET V_OUT_MESSAGE ='申报数据为空！';
      LEAVE routine_body;
    END;
  END IF;

  -- 查询企业基本信息
  BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='08';
      SET V_OUT_MESSAGE ='企业当前未进行出口退（免）税备案，不允许申报除出口退（免）税备案以外的其他业务！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT T.QYHGDM, T.QYLX_DM, T.TSJSFS_DM, T.WMZHFWQYBZ, T.SFYSFW, T.YSFW, T.YSFS, T.YFSJ, T.ZX_FLAG
      INTO LC_QYHGDM, LC_QYLXDM, LC_TSJSFSDM, LC_WMZHFWQYBZ, LC_SFYSFW, LC_YSFW, LC_YSFS, LC_YFSJ, LC_ZXFLAG
      FROM GS_DJ_CKTMSDAB T
     WHERE T.NSRDZDAH=V_IN_NSRDZDAH;
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LC_ZXFLAG='Y' THEN
    BEGIN
      SET V_OUT_STATUS ='09';
      SET V_OUT_MESSAGE ='企业当前已出口退（免）税备案撤回，不允许申报除出口退（免）税备案以外的其他业务！';
      LEAVE routine_body;
    END;
  END IF;

  -- 取企业的FLGLCD信息, TGSHZL信息，判断是否需要申报收汇
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',LDT_TODAY,LC_FLGLCD, LN_CPCODEKZ);
  IF LN_CPCODEKZ=0 THEN
    BEGIN
      SET V_OUT_STATUS ='10';
      SET V_OUT_MESSAGE ='查询出口企业分类管理类型出错！';
      LEAVE routine_body;
    END;
  END IF;

  IF ((LC_QYLXDM<>'1' AND LC_QYLXDM<>'2') OR LC_TSJSFSDM<>'1') THEN
    BEGIN
      SET V_OUT_STATUS ='11';
      SET V_OUT_MESSAGE ='备案信息中企业类型、退免税计算方法与当前申报业务冲突！';
      LEAVE routine_body;
    END;
  END IF;

  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'YBNSRRD',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=0 THEN
    BEGIN
      SET V_OUT_STATUS ='12';
      SET V_OUT_MESSAGE ='企业当前非增值税一般纳税人，不允许申报出口退（免）税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TQQY',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 THEN
    BEGIN
      SET V_OUT_STATUS ='13';
      SET V_OUT_MESSAGE ='企业当前处于出口退税停权期间，不允许申报出口退（免）税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTSSXMS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_CKMX>0 THEN
    BEGIN
      SET V_OUT_STATUS ='14';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权选择免税期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTSSXZS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_CKMX>0 THEN
    BEGIN
      SET V_OUT_STATUS ='15';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权选择征税期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTMS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_CKMX>0 THEN
    BEGIN
      SET V_OUT_STATUS ='16';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;

  SET LC_YDOBJECT ='委托代办';
  BEGIN
    BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_SBXH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_DBTSBALCZT_DM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_WMZHFWQYNSRMC_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_WMZHFWQYHGQYDM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_WMZHFWQYNSRSBH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TSKHYHMC_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TSKHYHZH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_FDDBRXM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_YDBTSBALCZTDM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_NSRSBH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_NSRMC_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_QYHGDM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_YHMC_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_YHZH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_NSRSBH_QG_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_NSRMC_QG_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_HGQY_DM_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT A.SBXH, A.DBTSBALCZT_DM, A.WMZHFWQYNSRMC, A.WMZHFWQYHGQYDM, A.WMZHFWQYNSRSBH, A.TSKHYHMC, A.TSKHYHZH, A.FDDBRXM,
                          B.DBTSBALCZT_DM AS YDBTSBALCZTDM,
                          C.NSRSBH, C.NSRMC, C.QYHGDM, C.YHMC, C.YHZH,
                          D.NSRSBH AS NSRSBH_QG, D.NSRMC AS NSRMC_QG, D.HGQY_DM
                     FROM CKTS_BA_SCQYWTDBTS_LSB A
                     LEFT JOIN (SELECT WMZHFWQYNSRSBH,DBTSBALCZT_DM,ROW_NUMBER() OVER (PARTITION BY WMZHFWQYNSRSBH ORDER BY LRRQ DESC) AS RN
                                  FROM CKTS_JGB_BA_SCQYWTDBTS WHERE DJXH=V_IN_DJXH) B ON B.WMZHFWQYNSRSBH=A.WMZHFWQYNSRSBH AND B.RN=1
                     LEFT JOIN GS_DJ_CKTMSDAB C ON C.NSRDJNO=A.WMZHFWQYNSRSBH OR C.SHXYNO=A.WMZHFWQYNSRSBH
                     LEFT JOIN CKTS_WBSJ_ZJ_CKTSBAQGXX D ON D.NSRSBH=A.WMZHFWQYNSRSBH OR D.SHXYDM=A.WMZHFWQYNSRSBH
                    WHERE A.SBID=V_IN_SBID;
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_LSF_XX_SBXH_001, BJTS_LSF_XX_DBTSBALCZT_DM_001, BJTS_LSF_XX_WMZHFWQYNSRMC_001, BJTS_LSF_XX_WMZHFWQYHGQYDM_001, BJTS_LSF_XX_WMZHFWQYNSRSBH_001, BJTS_LSF_XX_TSKHYHMC_001, BJTS_LSF_XX_TSKHYHZH_001, BJTS_LSF_XX_FDDBRXM_001, BJTS_LSF_XX_YDBTSBALCZTDM_001, BJTS_LSF_XX_NSRSBH_001, BJTS_LSF_XX_NSRMC_001, BJTS_LSF_XX_QYHGDM_001, BJTS_LSF_XX_YHMC_001, BJTS_LSF_XX_YHZH_001, BJTS_LSF_XX_NSRSBH_QG_001, BJTS_LSF_XX_NSRMC_QG_001, BJTS_LSF_XX_HGQY_DM_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
      BEGIN
        IF (BJTS_LSF_XX_FDDBRXM_001 IS NULL) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_BA_SCQYWTDBTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'BA_DBTS_SC_FRDB_NULL','E','法人代表不允许为空，请反馈企业备案信息以后重新申报！','N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (BJTS_LSF_XX_DBTSBALCZT_DM_001='3') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_BA_SCQYWTDBTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'BA_DBTS_SC_BALC_ERR','E','备案流程与申报业务不一致！','N',CURRENT_TIMESTAMP
;
          COMMIT;
        ELSE
          IF (BJTS_LSF_XX_DBTSBALCZT_DM_001='1' AND BJTS_LSF_XX_YDBTSBALCZTDM_001 IS NOT NULL AND BJTS_LSF_XX_YDBTSBALCZTDM_001<>'3') THEN
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                        'CKTS_BA_SCQYWTDBTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'BA_DBTS_SC_WTBAXX_DUP','E',ORA_CONCAT(ORA_CONCAT('生产企业已办理该外综服企业[', BJTS_LSF_XX_WMZHFWQYNSRSBH_001), ']的委托代办退税备案，请选择变更流程！'),'N',CURRENT_TIMESTAMP
;
            COMMIT;
          ELSEIF(BJTS_LSF_XX_DBTSBALCZT_DM_001='2' AND (BJTS_LSF_XX_YDBTSBALCZTDM_001 IS NULL OR BJTS_LSF_XX_YDBTSBALCZTDM_001='3')) THEN
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                        'CKTS_BA_SCQYWTDBTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'BA_DBTS_SC_WTBAXX_NULL','E',ORA_CONCAT(ORA_CONCAT('生产企业未办理该外综服企业[', BJTS_LSF_XX_WMZHFWQYNSRSBH_001), ']的委托代办退税备案，请选择备案流程！'),'N',CURRENT_TIMESTAMP
;
            COMMIT;
          END IF;

          IF (BJTS_LSF_XX_NSRSBH_001 IS NOT NULL) THEN
            -- 外综服企业为本地出口企业
            IF TRIM(BJTS_LSF_XX_WMZHFWQYNSRMC_001) <> TRIM(BJTS_LSF_XX_NSRMC_001) THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_BA_SCQYWTDBTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'BA_DBTS_SC_ZFQYXX_BYZ','E',ORA_CONCAT(ORA_CONCAT('生产企业提供的委托代办退税的外综服企业名称[', BJTS_LSF_XX_WMZHFWQYNSRMC_001), ']与该外综服企业出口退（免）税备案信息不一致！'),'N',CURRENT_TIMESTAMP
;
              COMMIT;
            END IF;
            IF TRIM(BJTS_LSF_XX_WMZHFWQYHGQYDM_001) <> TRIM(BJTS_LSF_XX_QYHGDM_001) THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_BA_SCQYWTDBTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'BA_DBTS_SC_ZFQYXX_BYZ','E',ORA_CONCAT(ORA_CONCAT('生产企业提供的委托代办退税的外综服企业海关代码[', BJTS_LSF_XX_WMZHFWQYHGQYDM_001), ']与该外综服企业出口退（免）税备案信息不一致！'),'N',CURRENT_TIMESTAMP
;
              COMMIT;
            END IF;
            IF (TRIM(BJTS_LSF_XX_TSKHYHMC_001) <> TRIM(BJTS_LSF_XX_YHMC_001)) OR (TRIM(BJTS_LSF_XX_TSKHYHZH_001) <> TRIM(BJTS_LSF_XX_YHZH_001)) THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_BA_SCQYWTDBTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'BA_DBTS_SC_ZFQYXX_BYZ','E',ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('生产企业提供的代办退税银行账号[', BJTS_LSF_XX_TSKHYHMC_001), BJTS_LSF_XX_TSKHYHZH_001), ']与该外综服企业出口退（免）税备案信息不一致！'),'N',CURRENT_TIMESTAMP
;
              COMMIT;
            END IF;
          ELSEIF (BJTS_LSF_XX_NSRSBH_QG_001 IS NOT NULL) THEN
            -- 外综服企业为外地出口企业
            IF TRIM(BJTS_LSF_XX_WMZHFWQYNSRMC_001) <> TRIM(BJTS_LSF_XX_NSRMC_QG_001) THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_BA_SCQYWTDBTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'BA_DBTS_SC_ZFQYXX_BYZ','E',ORA_CONCAT(ORA_CONCAT('生产企业提供的委托代办退税的外综服企业名称[', BJTS_LSF_XX_WMZHFWQYNSRMC_001), ']与该外综服企业出口退（免）税备案信息不一致！'),'N',CURRENT_TIMESTAMP
;
              COMMIT;
            END IF;
            IF TRIM(BJTS_LSF_XX_WMZHFWQYHGQYDM_001) <> TRIM(BJTS_LSF_XX_HGQY_DM_001) THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                          'CKTS_BA_SCQYWTDBTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'BA_DBTS_SC_ZFQYXX_BYZ','E',ORA_CONCAT(ORA_CONCAT('生产企业提供的委托代办退税的外综服企业海关代码[', BJTS_LSF_XX_WMZHFWQYHGQYDM_001), ']与该外综服企业出口退（免）税备案信息不一致！'),'N',CURRENT_TIMESTAMP
;
              COMMIT;
            END IF;
          ELSE
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                        'CKTS_BA_SCQYWTDBTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'BA_DBTS_SC_ZFQYXX_NULL','W',ORA_CONCAT(ORA_CONCAT('未查到该综服企业[', BJTS_LSF_XX_WMZHFWQYNSRSBH_001), ']的出口退（免）税备案信息，请确认是否输入正确！'),'Y',CURRENT_TIMESTAMP
;
            COMMIT;
          END IF;
        END IF;
      END;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_ZG_SCWTDBBA.sql

-- ======================================================================
-- [099/114] BEGIN SOURCE: PROC_XXBD_ZG_SCWTDBCH.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_ZG_SCWTDBCH$$

CREATE PROCEDURE PROC_XXBD_ZG_SCWTDBCH
/*
  编制人:严国平
  编制日期:202010
  功能:信息比对（委托代办退税情况备案撤回）
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE BJTS_ROUTINE_EXIT BOOLEAN DEFAULT FALSE;
  DECLARE LDT_TODAY       DATETIME;

  DECLARE LC_QYHGDM       VARCHAR(20);
  DECLARE LC_QYLXDM       VARCHAR(20);
  DECLARE LC_TSJSFSDM     VARCHAR(20);
  DECLARE LC_WMZHFWQYBZ   VARCHAR(20);
  DECLARE LC_SFYSFW       VARCHAR(20);
  DECLARE LC_YSFW         VARCHAR(50);
  DECLARE LC_YSFS         VARCHAR(50);
  DECLARE LC_YFSJ         VARCHAR(50);
  DECLARE LC_ZXFLAG       VARCHAR(20);

  DECLARE LC_YDOBJECT     VARCHAR(20);

  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LN_ROWNUM_CKMX  BIGINT;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';
  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  IF V_IN_SSSQ>DATE_FORMAT(CURRENT_TIMESTAMP, '%Y%m') THEN
    BEGIN
      SET V_OUT_STATUS ='05';
      SET V_OUT_MESSAGE ='申报所属时期超出合理范围！';
      LEAVE routine_body;
    END;
  END IF;

  -- 取各申报明细表数据记录
  BEGIN
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='06';
      SET V_OUT_MESSAGE ='查询申报记录数据失败！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT COUNT(1)
      INTO LN_ROWNUM_CKMX
      FROM CKTS_BA_SCQYWTDBTS_LSB
     WHERE SBID=V_IN_SBID;
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LN_ROWNUM_CKMX=0 THEN
    BEGIN
      SET V_OUT_STATUS ='07';
      SET V_OUT_MESSAGE ='申报数据为空！';
      LEAVE routine_body;
    END;
  END IF;

  -- 查询企业基本信息
  BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='08';
      SET V_OUT_MESSAGE ='企业当前未进行出口退（免）税备案，不允许申报除出口退（免）税备案以外的其他业务！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT T.QYHGDM, T.QYLX_DM, T.TSJSFS_DM, T.WMZHFWQYBZ, T.SFYSFW, T.YSFW, T.YSFS, T.YFSJ, T.ZX_FLAG
      INTO LC_QYHGDM, LC_QYLXDM, LC_TSJSFSDM, LC_WMZHFWQYBZ, LC_SFYSFW, LC_YSFW, LC_YSFS, LC_YFSJ, LC_ZXFLAG
      FROM GS_DJ_CKTMSDAB T
     WHERE T.NSRDZDAH=V_IN_NSRDZDAH;
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LC_ZXFLAG='Y' THEN
    BEGIN
      SET V_OUT_STATUS ='09';
      SET V_OUT_MESSAGE ='企业当前已出口退（免）税备案撤回，不允许申报除出口退（免）税备案以外的其他业务！';
      LEAVE routine_body;
    END;
  END IF;

  -- 取企业的FLGLCD信息, TGSHZL信息，判断是否需要申报收汇
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',LDT_TODAY,LC_FLGLCD, LN_CPCODEKZ);
  IF LN_CPCODEKZ=0 THEN
    BEGIN
      SET V_OUT_STATUS ='10';
      SET V_OUT_MESSAGE ='查询出口企业分类管理类型出错！';
      LEAVE routine_body;
    END;
  END IF;

  IF ((LC_QYLXDM<>'1' AND LC_QYLXDM<>'2') OR LC_TSJSFSDM<>'1') THEN
    BEGIN
      SET V_OUT_STATUS ='11';
      SET V_OUT_MESSAGE ='备案信息中企业类型、退免税计算方法与当前申报业务冲突！';
      LEAVE routine_body;
    END;
  END IF;

  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'YBNSRRD',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=0 THEN
    BEGIN
      SET V_OUT_STATUS ='12';
      SET V_OUT_MESSAGE ='企业当前非增值税一般纳税人，不允许申报出口退（免）税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TQQY',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 THEN
    BEGIN
      SET V_OUT_STATUS ='13';
      SET V_OUT_MESSAGE ='企业当前处于出口退税停权期间，不允许申报出口退（免）税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTSSXMS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_CKMX>0 THEN
    BEGIN
      SET V_OUT_STATUS ='14';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权选择免税期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTSSXZS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_CKMX>0 THEN
    BEGIN
      SET V_OUT_STATUS ='15';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权选择征税期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTMS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_CKMX>0 THEN
    BEGIN
      SET V_OUT_STATUS ='16';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;

  SET LC_YDOBJECT ='委托代办';
  BEGIN
    BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_SBXH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_DBTSBALCZT_DM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_WMZHFWQYNSRMC_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_WMZHFWQYHGQYDM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_WMZHFWQYNSRSBH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TSKHYHMC_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TSKHYHZH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_FDDBRXM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_WMZHFWHTXYHM_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT A.SBXH, A.DBTSBALCZT_DM, A.WMZHFWQYNSRMC, A.WMZHFWQYHGQYDM, A.WMZHFWQYNSRSBH, A.TSKHYHMC, A.TSKHYHZH, A.FDDBRXM,
                          B.WMZHFWHTXYHM
                     FROM CKTS_BA_SCQYWTDBTS_LSB A
                     LEFT JOIN CKTS_JGB_BA_SCQYWTDBTS B ON B.DJXH=V_IN_DJXH AND B.WMZHFWQYNSRSBH=A.WMZHFWQYNSRSBH
                    WHERE A.SBID=V_IN_SBID;
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_LSF_XX_SBXH_001, BJTS_LSF_XX_DBTSBALCZT_DM_001, BJTS_LSF_XX_WMZHFWQYNSRMC_001, BJTS_LSF_XX_WMZHFWQYHGQYDM_001, BJTS_LSF_XX_WMZHFWQYNSRSBH_001, BJTS_LSF_XX_TSKHYHMC_001, BJTS_LSF_XX_TSKHYHZH_001, BJTS_LSF_XX_FDDBRXM_001, BJTS_LSF_XX_WMZHFWHTXYHM_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
      BEGIN
        IF (BJTS_LSF_XX_FDDBRXM_001 IS NULL) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_BA_SCQYWTDBTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'BA_DBTS_SC_FRDB_NULL','E','法人代表不允许为空，请反馈企业备案信息以后重新申报！','N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (BJTS_LSF_XX_DBTSBALCZT_DM_001<>'3') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_BA_SCQYWTDBTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'BA_DBTS_SC_BALC_ERR','E','备案流程与申报业务不一致！','N',CURRENT_TIMESTAMP
;
          COMMIT;
        ELSEIF (BJTS_LSF_XX_WMZHFWHTXYHM_001 IS NULL) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_BA_SCQYWTDBTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'BA_DBTS_SC_WTBAXX_NULL','E',ORA_CONCAT(ORA_CONCAT('委托[', BJTS_LSF_XX_WMZHFWQYNSRSBH_001), ']代办退税的备案信息不存在！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
      END;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_ZG_SCWTDBCH.sql

-- ======================================================================
-- [100/114] BEGIN SOURCE: PROC_XXBD_ZG_WZFDBTSBA.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS PROC_XXBD_ZG_WZFDBTSBA$$

CREATE PROCEDURE PROC_XXBD_ZG_WZFDBTSBA
/*
  编制人:严国平
  编制日期:202010
  功能:信息比对（代办退税情况备案）
  修改日期：20210618，企业端提交的代办退税银行、账号未落地CKTS_BA_WMZHFWDBTS_LSB，增加对应字段接收数据并调整比对逻辑
  修改日期：20210830，BA_DBTS_WZF_YHXX_BYZ疑点拆分为两个，名称不一致的（有可能全称与简称的区别）可挑过，账号不一致的不可跳过
 */
(
  IN V_IN_NSRDZDAH DECIMAL(38,10), /*纳税人电子档案号*/
  IN V_IN_DJXH DECIMAL(38,10), /*登记序号*/
  IN V_IN_SBYWBDM VARCHAR(4000), /*申报业务表代码*/
  IN V_IN_SSSQ VARCHAR(4000), /*申报年月*/
  IN V_IN_SBPC DECIMAL(38,10), /*申报批次*/
  IN V_IN_SBID DECIMAL(38,10), /*申报ID*/
  OUT V_OUT_STATUS VARCHAR(4000), /*00:成功; 其他:执行失败*/
  OUT V_OUT_MESSAGE VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE BJTS_ROUTINE_EXIT BOOLEAN DEFAULT FALSE;
  DECLARE LDT_TODAY       DATETIME;

  DECLARE LC_QYHGDM       VARCHAR(20);
  DECLARE LC_QYLXDM       VARCHAR(20);
  DECLARE LC_TSJSFSDM     VARCHAR(20);
  DECLARE LC_WMZHFWQYBZ   VARCHAR(20);
  DECLARE LC_SFYSFW       VARCHAR(20);
  DECLARE LC_YSFW         VARCHAR(50);
  DECLARE LC_YSFS         VARCHAR(50);
  DECLARE LC_YFSJ         VARCHAR(50);
  DECLARE LC_ZXFLAG       VARCHAR(20);
  DECLARE LC_YHMC         VARCHAR(200);
  DECLARE LC_YHZH         VARCHAR(100);
  DECLARE LC_YDOBJECT     VARCHAR(20);

  DECLARE LN_CPCODEKZ     BIGINT;
  DECLARE LC_KZXX         VARCHAR(20);
  DECLARE LC_FLGLCD       VARCHAR(20);
  DECLARE LN_ROWNUM_CKMX  BIGINT;

  SET V_OUT_STATUS ='00';
  SET V_OUT_MESSAGE =' ';
  SET LDT_TODAY =DATE(CURRENT_TIMESTAMP);

  IF V_IN_SSSQ>DATE_FORMAT(CURRENT_TIMESTAMP, '%Y%m') THEN
    BEGIN
      SET V_OUT_STATUS ='05';
      SET V_OUT_MESSAGE ='申报所属时期超出合理范围！';
      LEAVE routine_body;
    END;
  END IF;

  -- 取各申报明细表数据记录
  BEGIN
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='06';
      SET V_OUT_MESSAGE ='查询申报记录数据失败！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT COUNT(1)
      INTO LN_ROWNUM_CKMX
      FROM CKTS_BA_WMZHFWDBTS_LSB
     WHERE SBID=V_IN_SBID;
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LN_ROWNUM_CKMX=0 THEN
    BEGIN
      SET V_OUT_STATUS ='07';
      SET V_OUT_MESSAGE ='申报数据为空！';
      LEAVE routine_body;
    END;
  END IF;

  -- 查询企业基本信息
  BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
      SET V_OUT_STATUS ='08';
      SET V_OUT_MESSAGE ='企业当前未进行出口退（免）税备案，不允许申报除出口退（免）税备案以外的其他业务！';
      SET BJTS_ROUTINE_EXIT = TRUE;

  END;
SELECT T.QYHGDM, T.QYLX_DM, T.TSJSFS_DM, T.WMZHFWQYBZ, T.SFYSFW, T.YSFW, T.YSFS, T.YFSJ, T.ZX_FLAG, T.YHMC, T.YHZH
      INTO LC_QYHGDM, LC_QYLXDM, LC_TSJSFSDM, LC_WMZHFWQYBZ, LC_SFYSFW, LC_YSFW, LC_YSFS, LC_YFSJ, LC_ZXFLAG, LC_YHMC, LC_YHZH
      FROM GS_DJ_CKTMSDAB T
     WHERE T.NSRDZDAH=V_IN_NSRDZDAH;
  END;
  IF BJTS_ROUTINE_EXIT THEN
    LEAVE routine_body;
  END IF;
  IF LC_ZXFLAG='Y' THEN
    BEGIN
      SET V_OUT_STATUS ='09';
      SET V_OUT_MESSAGE ='企业当前已出口退（免）税备案撤回，不允许申报除出口退（免）税备案以外的其他业务！';
      LEAVE routine_body;
    END;
  END IF;

  -- 取企业的FLGLCD信息, TGSHZL信息，判断是否需要申报收汇
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',LDT_TODAY,LC_FLGLCD, LN_CPCODEKZ);
  IF LN_CPCODEKZ=0 THEN
    BEGIN
      SET V_OUT_STATUS ='10';
      SET V_OUT_MESSAGE ='查询出口企业分类管理类型出错！';
      LEAVE routine_body;
    END;
  END IF;

  IF LC_QYLXDM<>'3' OR LC_TSJSFSDM<>'2' THEN
    BEGIN
      SET V_OUT_STATUS ='11';
      SET V_OUT_MESSAGE ='备案信息中企业类型、退免税计算方法与当前申报业务冲突！';
      LEAVE routine_body;
    END;
  END IF;

  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'YBNSRRD',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=0 THEN
    BEGIN
      SET V_OUT_STATUS ='12';
      SET V_OUT_MESSAGE ='企业当前非增值税一般纳税人，不允许申报出口退（免）税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TQQY',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 THEN
    BEGIN
      SET V_OUT_STATUS ='13';
      SET V_OUT_MESSAGE ='企业当前处于出口退税停权期间，不允许申报出口退（免）税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTSSXMS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_CKMX>0 THEN
    BEGIN
      SET V_OUT_STATUS ='14';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权选择免税期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTSSXZS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_CKMX>0 THEN
    BEGIN
      SET V_OUT_STATUS ='15';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权选择征税期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;
  CALL FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTMS',LDT_TODAY,LC_KZXX, LN_CPCODEKZ);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_CKMX>0 THEN
    BEGIN
      SET V_OUT_STATUS ='16';
      SET V_OUT_MESSAGE ='企业当前处于放弃退（免）税权期间，不允许申报出口货物劳务免退税业务！';
      LEAVE routine_body;
    END;
  END IF;

  SET LC_YDOBJECT ='代办备案';
  BEGIN
    BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_LSF_XX_SBXH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_DBTSBALCZT_DM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_WTDBTSSCQYNSRMC_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_WTDBTSSCQYHGQYDM_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_WTDBTSSCQYNSRSBH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_WTDBTSSCQYDBTSKHYHMC_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_WTDBTSSCQYDBTSKHYHZH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_WMZHFWHTXYHM_NEW_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_WMZHFWHTXYHM_OLD_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_NSRSBH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_NSRMC_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TSKHYHMC_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_TSKHYHZH_001 LONGTEXT;
  DECLARE BJTS_LSF_XX_WMZHFWHTXYHM_SC_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT A.SBXH, A.DBTSBALCZT_DM, A.WTDBTSSCQYNSRMC, A.WTDBTSSCQYHGQYDM, A.WTDBTSSCQYNSRSBH, A.TSKHYHMC AS WTDBTSSCQYDBTSKHYHMC, A.TSKHYHZH AS WTDBTSSCQYDBTSKHYHZH,
                          A.WMZHFWHTXYHM AS WMZHFWHTXYHM_NEW,
                          B.WMZHFWHTXYHM AS WMZHFWHTXYHM_OLD,
                          C.NSRSBH, C.NSRMC, C.TSKHYHMC, C.TSKHYHZH, C.WMZHFWHTXYHM AS WMZHFWHTXYHM_SC
                     FROM CKTS_BA_WMZHFWDBTS_LSB A
                     LEFT JOIN CKTS_JGB_BA_WMZHFWDBTS B ON B.DJXH=V_IN_DJXH AND (B.WTDBTSSCQYNSRSBH=A.WTDBTSSCQYNSRSBH OR B.WTDBTSSCQYSHXYDM=A.WTDBTSSCQYNSRSBH)
                     LEFT JOIN CKTS_WBSJ_ZJ_SCWTDBBA C ON C.DJXH=V_IN_DJXH AND (C.NSRSBH=A.WTDBTSSCQYNSRSBH OR C.SHXYDM=A.WTDBTSSCQYNSRSBH)
                    WHERE A.SBID=V_IN_SBID;
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_LSF_XX_SBXH_001, BJTS_LSF_XX_DBTSBALCZT_DM_001, BJTS_LSF_XX_WTDBTSSCQYNSRMC_001, BJTS_LSF_XX_WTDBTSSCQYHGQYDM_001, BJTS_LSF_XX_WTDBTSSCQYNSRSBH_001, BJTS_LSF_XX_WTDBTSSCQYDBTSKHYHMC_001, BJTS_LSF_XX_WTDBTSSCQYDBTSKHYHZH_001, BJTS_LSF_XX_WMZHFWHTXYHM_NEW_001, BJTS_LSF_XX_WMZHFWHTXYHM_OLD_001, BJTS_LSF_XX_NSRSBH_001, BJTS_LSF_XX_NSRMC_001, BJTS_LSF_XX_TSKHYHMC_001, BJTS_LSF_XX_TSKHYHZH_001, BJTS_LSF_XX_WMZHFWHTXYHM_SC_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
      BEGIN
        IF (BJTS_LSF_XX_DBTSBALCZT_DM_001='1' AND BJTS_LSF_XX_WMZHFWHTXYHM_OLD_001 IS NOT NULL) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_BA_WMZHFWDBTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'BA_DBTS_WZF_BAXX_DUP','E',ORA_CONCAT(ORA_CONCAT('生产企业[', BJTS_LSF_XX_WTDBTSSCQYNSRSBH_001), ']代办退税的备案信息已存在，请选择变更流程！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        ELSEIF(BJTS_LSF_XX_DBTSBALCZT_DM_001='2' AND BJTS_LSF_XX_WMZHFWHTXYHM_OLD_001 IS NULL) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_BA_WMZHFWDBTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'BA_DBTS_WZF_BAXX_NULL','E',ORA_CONCAT(ORA_CONCAT('生产企业[', BJTS_LSF_XX_WTDBTSSCQYNSRSBH_001), ']代办退税的备案信息不存在，请选择备案流程！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;

        IF (BJTS_LSF_XX_NSRSBH_001 IS NOT NULL) THEN
          IF TRIM(BJTS_LSF_XX_WTDBTSSCQYNSRMC_001) <> TRIM(BJTS_LSF_XX_NSRMC_001) THEN
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                        'CKTS_BA_WMZHFWDBTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'BA_DBTS_WZF_BAXX_BYZ','E',ORA_CONCAT(ORA_CONCAT('生产企业[', BJTS_LSF_XX_WTDBTSSCQYNSRSBH_001), ']对应的名称与该企业委托代办备案信息不一致！'),'N',CURRENT_TIMESTAMP
;
            COMMIT;
          END IF;

          IF (BJTS_LSF_XX_WTDBTSSCQYDBTSKHYHZH_001<>BJTS_LSF_XX_TSKHYHZH_001) THEN
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                        'CKTS_BA_WMZHFWDBTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'BA_DBTS_WZF_YHXX_BYZ','E',ORA_CONCAT(ORA_CONCAT('生产企业[', BJTS_LSF_XX_WTDBTSSCQYNSRSBH_001), ']对应的退税银行账户与该企业委托代办备案信息不一致！'),'N',CURRENT_TIMESTAMP
;
            COMMIT;
          END IF;

          IF (BJTS_LSF_XX_WTDBTSSCQYDBTSKHYHMC_001 <> BJTS_LSF_XX_TSKHYHMC_001) THEN
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                        'CKTS_BA_WMZHFWDBTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'BA_DBTS_WZF_YHXX_BYZ','E',ORA_CONCAT(ORA_CONCAT('生产企业[', BJTS_LSF_XX_WTDBTSSCQYNSRSBH_001), ']对应的退税银行名称与该企业委托代办备案信息不一致！'),'Y',CURRENT_TIMESTAMP
;
            COMMIT;
          END IF;

          IF (BJTS_LSF_XX_WMZHFWHTXYHM_NEW_001 <> BJTS_LSF_XX_WMZHFWHTXYHM_SC_001) THEN
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                        'CKTS_BA_WMZHFWDBTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'BA_DBTS_WZF_HTXX_BYZ','E',ORA_CONCAT(ORA_CONCAT('生产企业[', BJTS_LSF_XX_WTDBTSSCQYNSRSBH_001), ']对应的代办退税协议与该企业委托代办备案信息不一致！'),'N',CURRENT_TIMESTAMP
;
            COMMIT;
          END IF;
        ELSE
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_NEXTVAL('SEQ_XXBD_SHQ_YDID'),LC_YDOBJECT,
                      'CKTS_BA_WMZHFWDBTS_LSB',NULL,NULL,BJTS_LSF_XX_SBXH_001,NULL,'BA_DBTS_WZF_SCQYWBA','E',ORA_CONCAT(ORA_CONCAT('缺少生产企业[', BJTS_LSF_XX_WTDBTSSCQYNSRSBH_001), ']的委托代办备案信息！'),'N',CURRENT_TIMESTAMP
;
          COMMIT;
        END IF;
      END;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;
  END;
END$$

DELIMITER ;

-- END SOURCE: PROC_XXBD_ZG_WZFDBTSBA.sql

-- ======================================================================
-- [101/114] BEGIN SOURCE: P_ADD_SYSUSER.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS P_ADD_SYSUSER$$

CREATE procedure P_ADD_SYSUSER()
routine_body: BEGIN
  DECLARE cnt integer;
  DECLARE swjc integer;
  DECLARE pid BIGINT;
  DECLARE v_czry_dm VARCHAR(11);
  DECLARE v_czry_mc VARCHAR(20);
  DECLARE v_swjg_dm VARCHAR(11);
  DECLARE v_password VARCHAR(50);



  -- default pwd: a1234567
  SET v_password ='a55a3975f293712e641eb838e4585c03';

  BEGIN
  DECLARE BJTS_NAMED_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_CUR_CZRY_DM_001 LONGTEXT;
  DECLARE BJTS_CUR_CZRY_MC_001 LONGTEXT;
  DECLARE BJTS_CUR_SWJG_DM_001 LONGTEXT;
  DECLARE BJTS_NAMED_CURSOR_001 CURSOR FOR
select czry_dm,czry_mc,swjg_dm
         from TMP_SSZJ t
         where not exists(select 1 from SYS_USER s
         where s.czry_dm=t.czry_dm);
  OPEN BJTS_NAMED_CURSOR_001;
  BJTS_NAMED_CURSOR_LOOP_001: LOOP
    SET BJTS_NAMED_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_NAMED_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_NAMED_CURSOR_001 INTO BJTS_CUR_CZRY_DM_001, BJTS_CUR_CZRY_MC_001, BJTS_CUR_SWJG_DM_001;
    END;
    IF BJTS_NAMED_CURSOR_DONE_001 THEN
      LEAVE BJTS_NAMED_CURSOR_LOOP_001;
    END IF;
      SET V_CZRY_DM =BJTS_CUR_CZRY_DM_001;
      SET V_CZRY_MC =BJTS_CUR_CZRY_MC_001;
      SET V_SWJG_DM =BJTS_CUR_SWJG_DM_001;

    BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
        SET pid =0;

  END;
select id into pid from SYS_USER t
      where t.czry_dm=v_CZRY_DM;
     END;

    -- 检查操作员
    if (pid=0) then
      SET pid = F_SEQ_NEXTVAL_ADMIN('SYS_USER');
      insert into SYS_USER(id,czry_dm,czry_mc,password,swjg_dm,usrstate
             ,crtime,crname,uptime,upname,qybz,yhly)
        values(pid,
        v_czry_dm,v_czry_mc,v_password,v_swjg_dm,'3',
        CURRENT_TIMESTAMP,'admin',CURRENT_TIMESTAMP,'admin','1','0');

    end if;

      -- 检查角色
      if (pid>0) then
        select count(1) into cnt from SYS_USER_ROLE r where r.czyid=pid;
        if cnt = 0 then
            SET swjc =case when substr(v_swjg_dm,-8)='00000000' then 1
                 when substr(v_swjg_dm,-6)='000000' then 2
                 when substr(v_swjg_dm,-4)='0000' then 3
                   else 0 end ;

            if swjc='1' then
              -- 省局专责
              insert into SYS_USER_ROLE values(pid,'SHJZZ');
            else if swjc='2' then
              -- 市局专责
              insert into SYS_USER_ROLE values(pid,'SJZZ');
            else if swjc='3' then
              -- 县局专责
              insert into SYS_USER_ROLE values(pid,'XJZZ');
            end if;
            end if;
            end if;

            -- 单证备案, 2.0 ,1.0
            insert into SYS_USER_ROLE values(pid,'DZBACZ');
            -- sszj
            insert into SYS_GROUP_USER values('SSZJ',pid);


        end if;
      end if;

  END LOOP BJTS_NAMED_CURSOR_LOOP_001;
  CLOSE BJTS_NAMED_CURSOR_001;
END;

  LEAVE routine_body;

END$$

DELIMITER ;

-- END SOURCE: P_ADD_SYSUSER.sql

-- ======================================================================
-- [102/114] BEGIN SOURCE: P_DELETE_SB_SBXX.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS P_DELETE_SB_SBXX$$

CREATE PROCEDURE P_DELETE_SB_SBXX()
routine_body: BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';




  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
    DO ORA_CONCAT('失败:', BJTS_SQLERRM_001);

  END;
BEGIN
  DECLARE BJTS_FETCH_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_RS_NSR_ID_001 LONGTEXT;
  DECLARE BJTS_FETCH_CURSOR_001 CURSOR FOR
select id from SB_SBXX_HZ hz where hz.sbzt_dm= '39';
  OPEN BJTS_FETCH_CURSOR_001;
  BJTS_FETCH_LOOP_001: LOOP
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_FETCH_DONE_001 = TRUE;
      FETCH BJTS_FETCH_CURSOR_001 INTO BJTS_RS_NSR_ID_001;
    END;
    IF BJTS_FETCH_DONE_001 THEN
      LEAVE BJTS_FETCH_LOOP_001;
    END IF;


    delete from SB_SBXX_SBSJ where id = BJTS_RS_NSR_ID_001;
    delete from SB_SBXX_FKSJ where id = BJTS_RS_NSR_ID_001;
    commit;

  END LOOP BJTS_FETCH_LOOP_001;
  CLOSE BJTS_FETCH_CURSOR_001;
END;
  COMMIT;
  END$$

DELIMITER ;

-- END SOURCE: P_DELETE_SB_SBXX.sql

-- ======================================================================
-- [103/114] BEGIN SOURCE: P_ETL_GS_DJ_CKTMSDAB.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS P_ETL_GS_DJ_CKTMSDAB$$

CREATE PROCEDURE P_ETL_GS_DJ_CKTMSDAB()
routine_body: BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';
  -- pv_tbpc NUMBER(20);
  DECLARE pv_cpcode VARCHAR(40);
  DECLARE pv_cpcodetssh VARCHAR(40);

  DECLARE pv_nsrdzdah DECIMAL(20,0);
  DECLARE pv_nsrsbh VARCHAR(20);
  DECLARE pv_cntnsr_new integer;
  DECLARE pv_zs_swjg_dm VARCHAR(11);
  DECLARE pv_swjg_dm VARCHAR(11);
  DECLARE pv_dqinit DECIMAL(20,0);

  DECLARE pv_name VARCHAR(4000);
  DECLARE pv_qydm VARCHAR(18);
  DECLARE pv_swcode VARCHAR(11);
  DECLARE pv_zxflag VARCHAR(1);
  DECLARE pv_tag VARCHAR(30);

  -- 先处理新增加




  -- 同步出口退税纳税人档案表

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
    rollback;
    -- 记录日志，同步失败
    SET @BJTS_DYNAMIC_SQL_001 = 'INSERT INTO TB_GS_TBSB_RZ(tblx_dm,sbyy) VALUES(?,?)';
PREPARE BJTS_DYNAMIC_STMT_001 FROM @BJTS_DYNAMIC_SQL_001;
SET @BJTS_BIND_001_001 = 'GS_DJ_CKTMSDAB';
SET @BJTS_BIND_001_002 = ORA_CONCAT('失败:', BJTS_SQLERRM_001);
EXECUTE BJTS_DYNAMIC_STMT_001 USING @BJTS_BIND_001_001, @BJTS_BIND_001_002;
DEALLOCATE PREPARE BJTS_DYNAMIC_STMT_001;
    DO ORA_CONCAT('出口退税企业同步失败:', BJTS_SQLERRM_001);
    COMMIT;

  END;
SET pv_dqinit = 3300000000;

  BEGIN
  DECLARE BJTS_FETCH_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_RS_NSR_CPCODE_001 LONGTEXT;
  DECLARE BJTS_RS_NSR_NSRMC_001 LONGTEXT;
  DECLARE BJTS_RS_NSR_QYHGDM_001 LONGTEXT;
  DECLARE BJTS_RS_NSR_NSRSBH_001 LONGTEXT;
  DECLARE BJTS_RS_NSR_SWJG_DM_001 LONGTEXT;
  DECLARE BJTS_RS_NSR_ZX_FLAG_001 LONGTEXT;
  DECLARE BJTS_FETCH_CURSOR_001 CURSOR FOR
SELECT CPCODE, NSRMC, QYHGDM, NSRSBH, SWJG_DM, IFNULL(ZX_FLAG, 'N') AS ZX_FLAG
  FROM GS_DJ_CKTMSDAB_TB WHERE CPCODE NOT IN (SELECT CPCODE FROM TB_GS_NSRXX t WHERE YXBZ = 'N') ORDER BY IFNULL(ZX_FLAG, 'N') DESC;
  OPEN BJTS_FETCH_CURSOR_001;
  BJTS_FETCH_LOOP_001: LOOP
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_FETCH_DONE_001 = TRUE;
      FETCH BJTS_FETCH_CURSOR_001 INTO BJTS_RS_NSR_CPCODE_001, BJTS_RS_NSR_NSRMC_001, BJTS_RS_NSR_QYHGDM_001, BJTS_RS_NSR_NSRSBH_001, BJTS_RS_NSR_SWJG_DM_001, BJTS_RS_NSR_ZX_FLAG_001;
    END;
    IF BJTS_FETCH_DONE_001 THEN
      LEAVE BJTS_FETCH_LOOP_001;
    END IF;

    SET pv_cpcode = BJTS_RS_NSR_CPCODE_001;
    SET pv_name = BJTS_RS_NSR_NSRMC_001;
    SET pv_qydm = BJTS_RS_NSR_QYHGDM_001;
    SET pv_nsrsbh = BJTS_RS_NSR_NSRSBH_001;
    SET pv_swcode = BJTS_RS_NSR_SWJG_DM_001;
    SET pv_zxflag = BJTS_RS_NSR_ZX_FLAG_001;

    -- DBMS_OUTPUT.put_line(pv_cpcode || pv_name);

    -- 初始化参数
    SET pv_cntnsr_new = 0;
    SET pv_nsrdzdah = 0;
    SET pv_cpcodetssh = '';
    SET pv_swjg_dm = '';
    SET pv_zs_swjg_dm = '';
    -- 获取NSRDZDAH
    BEGIN
  DECLARE BJTS_SQLCODE_005 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_005 TEXT DEFAULT '';
      -- CPCODE

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_005 = MYSQL_ERRNO, BJTS_SQLERRM_005 = MESSAGE_TEXT;
        BEGIN
  DECLARE BJTS_SQLCODE_004 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_004 TEXT DEFAULT '';
          -- 五证合一检查,NSRSBH

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_004 = MYSQL_ERRNO, BJTS_SQLERRM_004 = MESSAGE_TEXT;
              -- 新增企业
              SET pv_cntnsr_new = 1;
              BEGIN
  DECLARE BJTS_SQLCODE_003 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_003 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_003 = MYSQL_ERRNO, BJTS_SQLERRM_003 = MESSAGE_TEXT;
                  -- IF pv_zxflag = 'Y' THEN
                  --  CONTINUE;
                  -- END IF;
                  SET pv_nsrdzdah = pv_dqinit + SEQ_NEXTVAL('SEQ_GS_TB_NSRDZDAH');
                  INSERT INTO TB_GS_NSRXX(QYHGDM, NSRMC, TBRQ, YXBZ, NSRDZDAH, CPCODE)
                  VALUES(pv_qydm, pv_name, CURRENT_TIMESTAMP, 'Y', pv_nsrdzdah, pv_cpcode);

  END;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_003 = MYSQL_ERRNO, BJTS_SQLERRM_003 = MESSAGE_TEXT;
                  -- 记录日志，同步失败
                  DO ORA_CONCAT(ORA_CONCAT('出口退税企业初始化失败4:', pv_cpcode), BJTS_SQLERRM_003);

  END;
SELECT NSRDZDAH, '', '', NULL INTO pv_nsrdzdah, pv_swjg_dm, pv_zs_swjg_dm, pv_tag FROM TB_GS_NSRXX WHERE CPCODE = pv_cpcode;
                -- DELETE FROM TB_GS_NSRXX WHERE QYHGDM = pv_qydm;
                END;

  END;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_004 = MYSQL_ERRNO, BJTS_SQLERRM_004 = MESSAGE_TEXT;
            -- 记录日志，同步失败
            DO ORA_CONCAT(ORA_CONCAT('出口退税企业初始化失败2:', pv_cpcode), BJTS_SQLERRM_004);
            COMMIT;

  END;
SELECT NSRDZDAH, SWJG_DM, ZS_SWJG_DM, CPCODETSSH, TAG INTO pv_nsrdzdah, pv_swjg_dm, pv_zs_swjg_dm, pv_cpcodetssh, pv_tag FROM GS_DJ_CKTMSDAB
          WHERE NSRSBH = pv_nsrsbh AND NSRDZDAH > 0 AND 1=1 ORDER BY IFNULL(ZX_FLAG, 'N')
LIMIT 1;
          -- DBMS_OUTPUT.put_line('NSRSBH');
          END;

  END;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_005 = MYSQL_ERRNO, BJTS_SQLERRM_005 = MESSAGE_TEXT;
        -- 记录日志，同步失败
        DO ORA_CONCAT(ORA_CONCAT('出口退税企业初始化失败1:', pv_cpcode), BJTS_SQLERRM_005);
        COMMIT;

  END;
SELECT NSRDZDAH, SWJG_DM, ZS_SWJG_DM, CPCODETSSH, TAG INTO pv_nsrdzdah, pv_swjg_dm, pv_zs_swjg_dm, pv_cpcodetssh, pv_tag FROM GS_DJ_CKTMSDAB
      WHERE CPCODE = pv_cpcode AND NSRDZDAH > 0 AND 1=1 ORDER BY IFNULL(ZX_FLAG, 'N')
LIMIT 1;
      -- DBMS_OUTPUT.put_line('CPCODE');
      END;

    IF pv_nsrdzdah > 0 THEN
      BEGIN
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';
        -- 获取同步批次, 取消
        -- pv_tbpc := SEQ_TB_TBPC.NEXTVAL;


  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
          ROLLBACK;
          -- 记录日志，同步失败
          SET @BJTS_DYNAMIC_SQL_002 = 'INSERT INTO TB_GS_TBSB_RZ(tblx_dm,sbyy) VALUES(?,?)';
PREPARE BJTS_DYNAMIC_STMT_002 FROM @BJTS_DYNAMIC_SQL_002;
SET @BJTS_BIND_002_001 = 'GS_DJ_CKTMSDAB';
SET @BJTS_BIND_002_002 = ORA_CONCAT(ORA_CONCAT('失败2:', pv_cpcode), BJTS_SQLERRM_002);
EXECUTE BJTS_DYNAMIC_STMT_002 USING @BJTS_BIND_002_001, @BJTS_BIND_002_002;
DEALLOCATE PREPARE BJTS_DYNAMIC_STMT_002;
          DO ORA_CONCAT(ORA_CONCAT('出口退税企业同步失败2:', pv_cpcode), BJTS_SQLERRM_002);

  END;
IF pv_cntnsr_new = 0 THEN
          IF (pv_swjg_dm <> pv_swcode) THEN
            SET pv_zs_swjg_dm = null;
          END IF;
        ELSE
          SET pv_zs_swjg_dm = null;
        END IF;

        -- 开始同步,增量同步
        -- 单户
        -- 删除同海关代码、档案号
        -- DBMS_OUTPUT.put_line(pv_nsrsbh);
        -- 删除同税号，只保留1条最新
        DELETE FROM GS_DJ_CKTMSDAB WHERE NSRDZDAH = pv_nsrdzdah;
        DELETE FROM GS_DJ_CKTMSDAB WHERE CPCODE = pv_cpcode;
        DELETE FROM GS_DJ_CKTMSDAB WHERE NSRSBH = pv_nsrsbh;
        -- DELETE FROM GS_DJ_CKTMSDAB WHERE QYHGDM = pv_qydm;

        INSERT INTO GS_DJ_CKTMSDAB
        (
          TBPC,
          NSRDZDAH,
          NSRMC,
          NSRMCYW,
          QYHGDM,
          NSRDH,
          NSRCZ,
          NSRYB,
          NSRYX,
          ZCDZ,
          SCJYDZ,
          NSRSBH,
          NSRLX_DM,
          SWJG_DM,
          NSRXYDJ_DM,
          DJZCLX_DM,
          HY_DM,
          LSGX_DM,
          JYZLX_DM,
          BADJBBH,
          SFYSFW,
          YSFW,
          YSFS,
          YFSJ,
          GSDJZZH,
          GSKYRQ,
          GSYXQZ,
          GSDJYXQ,
          GSZCZB,
          FDDBRMC,
          FRZJHM,
          FRDHHM,
          YHMC,
          YHZH,
          BSY1_MC,
          BSY1_ID,
          BSY1_DH,
          BSY2_MC,
          BSY2_ID,
          BSY2_DH,
          ZZSYHZC,
          ZGWHJ,
          FSZL,
          TSJSFS_DM,
          SBFS_MC_ZZBZ,
          SBFS_MC_SJDW,
          SFFBHS,
          FBHSDM,
          QYLX_DM,
          CPCODE,
          NSRDJNO,
          SHXYNO,
          ZS_SWJG_DM,
          ZX_FLAG,
          TSGLLX_DM,
          ZSQYBBSRBZ,
          YHZHTGBZ,
          WMZHFWQYBZ,
          SCSBRQ,
          ZTXTHHBZ,
          ZGSWSKFJ_DM,
          JDXZ_DM,
          XGRQ,
          CPCODETSSH,
          TAG,
          READIN_DATE,
          cwfzrxm,
          cwfzrsfzjhm,
          cwfzrgddh,
          cwfzryddh,
          bsrxm,
          bsrsfzjhm,
          bsrgddh,
          bsryddh,
          djrq,
          scckrq,
          barq,
          fddbr_cgbl,
          FDDBRSFZJLX_DM,
          YBNSRRDSJQ,
          FIRST_SB_YM,
          NSRZT_DM,
          ZX_DATE,
          ZGSWJ_DM,
          note
        )
        SELECT
          0,
          pv_nsrdzdah,
          NSRMC,
          NSRMCYW,
          QYHGDM,
          NSRDH,
          NSRCZ,
          NSRYB,
          NSRYX,
          ZCDZ,
          SCJYDZ,
          NSRSBH,
          NSRLX_DM,
          SWJG_DM,
          NSRXYDJ_DM,
          DJZCLX_DM,
          HY_DM,
          LSGX_DM,
          JYZLX_DM,
          BADJBBH,
          SFYSFW,
          YSFW,
          YSFS,
          YFSJ,
          GSDJZZH,
          GSKYRQ,
          GSYXQZ,
          GSDJYXQ,
          GSZCZB,
          FDDBRMC,
          FRZJHM,
          FRDHHM,
          YHMC,
          YHZH,
          BSY1_MC,
          BSY1_ID,
          BSY1_DH,
          BSY2_MC,
          BSY2_ID,
          BSY2_DH,
          ZZSYHZC,
          ZGWHJ,
          FSZL,
          TSJSFS_DM,
          SBFS_MC_ZZBZ,
          SBFS_MC_SJDW,
          SFFBHS,
          FBHSDM,
          QYLX_DM,
          CPCODE,
          NSRDJNO,
          SHXYNO,
          pv_zs_swjg_dm,
          ZX_FLAG,
          TSGLLX_DM,
          ZSQYBBSRBZ,
          YHZHTGBZ,
          WMZHFWQYBZ,
          SCSBRQ,
          ZTXTHHBZ,
          ZGSWSKFJ_DM,
          JDXZ_DM,
          XGRQ,
          pv_cpcodetssh,
          pv_tag,
          CURRENT_TIMESTAMP,
          cwfzrxm,
          cwfzrsfzjhm,
          cwfzrgddh,
          cwfzryddh,
          bsrxm,
          bsrsfzjhm,
          bsrgddh,
          bsryddh,
          djrq,
          scckrq,
          barq,
          fddbr_cgbl,
          FDDBRSFZJLX_DM,
          YBNSRRDSJQ,
          FIRST_SB_YM,
          NSRZT_DM,
          ZX_DATE,
          ZGSWJ_DM,
          '1'
        FROM GS_DJ_CKTMSDAB_TB
        WHERE CPCODE = pv_cpcode AND IFNULL(ZX_FLAG, 'N') = pv_zxflag;

        -- 20260623新增
        -- FDDBRSFZJLX_DM  N CHAR(3) Y     法人证件类型-NEW
        -- YBNSRRDSJQ  N DATE  Y     一般纳税人认定日期-NEW
        -- FIRST_SB_YM N VARCHAR2(6) Y     首次申报年月-NEW
        -- NSRZT_DM  N CHAR(2) Y     纳税人状态-NEW
        -- ZX_DATE N DATE  Y     备案撤回日期-NEW
        -- ZGSWJ_DM  N CHAR(11)  Y     征管税务机关代码-NEW

        -- 插入待同步数据,取消
        -- INSERT INTO TB_DTBSJ(id,tblx_dm,mainid,cjsj,tbcs,yxj)
        -- VALUES(SEQ_TB_DTBSJ_ID.NEXTVAL,'GS_DJ_CKTMSDABToYun',pv_tbpc,sysdate,0,1);

        -- 记录日志，同步成功
        -- DBMS_OUTPUT.put_line(pv_cpcode || nvl(pv_zxflag,'null') || '同步成功' || pv_qydm);
        COMMIT;

        END;
    END IF;

  END LOOP BJTS_FETCH_LOOP_001;
  CLOSE BJTS_FETCH_CURSOR_001;
END;

  COMMIT;
  DO '出口退税企业同步成功';
  END$$

DELIMITER ;

-- END SOURCE: P_ETL_GS_DJ_CKTMSDAB.sql

-- ======================================================================
-- [104/114] BEGIN SOURCE: P_ETL_GS_DJ_CKTMSDAB_ONE.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS P_ETL_GS_DJ_CKTMSDAB_ONE$$

CREATE PROCEDURE P_ETL_GS_DJ_CKTMSDAB_ONE
(
  IN av_nsrsbh VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';
  DECLARE pv_tbpc DECIMAL(20,0);
  DECLARE pv_cpcode VARCHAR(40);
  DECLARE pv_cpcodetssh VARCHAR(40);

  DECLARE pv_nsrdzdah DECIMAL(20,0);
  DECLARE pv_nsrsbh VARCHAR(20);
  DECLARE pv_cntnsr_new integer;
  DECLARE pv_zs_swjg_dm VARCHAR(11);
  DECLARE pv_swjg_dm VARCHAR(11);
  DECLARE pv_dqinit DECIMAL(20,0);

  DECLARE pv_name VARCHAR(4000);
  DECLARE pv_qydm VARCHAR(18);
  DECLARE pv_swcode VARCHAR(11);
  DECLARE pv_zxflag VARCHAR(1);
  DECLARE pv_tag VARCHAR(30);

  -- 先处理注销，再处理新增加




  -- 同步出口退税纳税人档案表

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
    rollback;
    -- 记录日志，同步失败
    SET @BJTS_DYNAMIC_SQL_001 = 'INSERT INTO TB_GS_TBSB_RZ(tblx_dm,sbyy) VALUES(?,?)';
PREPARE BJTS_DYNAMIC_STMT_001 FROM @BJTS_DYNAMIC_SQL_001;
SET @BJTS_BIND_001_001 = 'GS_DJ_CKTMSDABToYun';
SET @BJTS_BIND_001_002 = ORA_CONCAT('失败:', BJTS_SQLERRM_001);
EXECUTE BJTS_DYNAMIC_STMT_001 USING @BJTS_BIND_001_001, @BJTS_BIND_001_002;
DEALLOCATE PREPARE BJTS_DYNAMIC_STMT_001;
    DO ORA_CONCAT('出口退税企业同步失败:', BJTS_SQLERRM_001);
    COMMIT;

  END;
SET pv_dqinit = 3300000000;

  BEGIN
  DECLARE BJTS_FETCH_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_RS_NSR_CPCODE_001 LONGTEXT;
  DECLARE BJTS_RS_NSR_NSRMC_001 LONGTEXT;
  DECLARE BJTS_RS_NSR_QYHGDM_001 LONGTEXT;
  DECLARE BJTS_RS_NSR_NSRSBH_001 LONGTEXT;
  DECLARE BJTS_RS_NSR_SWJG_DM_001 LONGTEXT;
  DECLARE BJTS_RS_NSR_ZX_FLAG_001 LONGTEXT;
  DECLARE BJTS_FETCH_CURSOR_001 CURSOR FOR
SELECT CPCODE, NSRMC, QYHGDM, NSRSBH, SWJG_DM, ZX_FLAG
  FROM GS_DJ_CKTMSDAB_TB WHERE CPCODE NOT IN (SELECT CPCODE FROM TB_GS_NSRXX t WHERE YXBZ = 'N') AND NSRSBH = av_nsrsbh ORDER BY IFNULL(ZX_FLAG, 'N') DESC;
  OPEN BJTS_FETCH_CURSOR_001;
  BJTS_FETCH_LOOP_001: LOOP
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_FETCH_DONE_001 = TRUE;
      FETCH BJTS_FETCH_CURSOR_001 INTO BJTS_RS_NSR_CPCODE_001, BJTS_RS_NSR_NSRMC_001, BJTS_RS_NSR_QYHGDM_001, BJTS_RS_NSR_NSRSBH_001, BJTS_RS_NSR_SWJG_DM_001, BJTS_RS_NSR_ZX_FLAG_001;
    END;
    IF BJTS_FETCH_DONE_001 THEN
      LEAVE BJTS_FETCH_LOOP_001;
    END IF;

    SET pv_cpcode = BJTS_RS_NSR_CPCODE_001;
    SET pv_name = BJTS_RS_NSR_NSRMC_001;
    SET pv_qydm = BJTS_RS_NSR_QYHGDM_001;
    SET pv_nsrsbh = BJTS_RS_NSR_NSRSBH_001;
    SET pv_swcode = BJTS_RS_NSR_SWJG_DM_001;
    SET pv_zxflag = BJTS_RS_NSR_ZX_FLAG_001;

    -- DBMS_OUTPUT.put_line(pv_cpcode || pv_name);

    -- 初始化参数
    SET pv_cntnsr_new = 0;
    SET pv_nsrdzdah = 0;
    -- 获取NSRDZDAH
    BEGIN
  DECLARE BJTS_SQLCODE_005 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_005 TEXT DEFAULT '';
      -- CPCODE

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_005 = MYSQL_ERRNO, BJTS_SQLERRM_005 = MESSAGE_TEXT;
        BEGIN
  DECLARE BJTS_SQLCODE_004 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_004 TEXT DEFAULT '';
          -- 五证合一检查,NSRSBH

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_004 = MYSQL_ERRNO, BJTS_SQLERRM_004 = MESSAGE_TEXT;
              -- 新增企业
              SET pv_cntnsr_new = 1;
              BEGIN
  DECLARE BJTS_SQLCODE_003 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_003 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_003 = MYSQL_ERRNO, BJTS_SQLERRM_003 = MESSAGE_TEXT;
                  -- IF pv_zxflag = 'R' THEN
                  --  CONTINUE;
                  -- END IF;
                  SET pv_nsrdzdah = pv_dqinit + SEQ_NEXTVAL('SEQ_GS_TB_NSRDZDAH');
                  INSERT INTO TB_GS_NSRXX(QYHGDM, NSRMC, TBRQ, YXBZ, NSRDZDAH, CPCODE)
                  VALUES(pv_qydm, pv_name, CURRENT_TIMESTAMP, 'Y', pv_nsrdzdah, pv_cpcode);

  END;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_003 = MYSQL_ERRNO, BJTS_SQLERRM_003 = MESSAGE_TEXT;
                  -- 记录日志，同步失败
                  DO ORA_CONCAT(ORA_CONCAT('出口退税企业初始化失败4:', pv_cpcode), BJTS_SQLERRM_003);

  END;
SELECT NSRDZDAH, '', '', NULL INTO pv_nsrdzdah, pv_swjg_dm, pv_zs_swjg_dm, pv_tag FROM TB_GS_NSRXX WHERE CPCODE = pv_cpcode;
                -- DELETE FROM TB_GS_NSRXX WHERE QYHGDM = pv_qydm;
                END;

  END;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_004 = MYSQL_ERRNO, BJTS_SQLERRM_004 = MESSAGE_TEXT;
            -- 记录日志，同步失败
            DO ORA_CONCAT(ORA_CONCAT('出口退税企业初始化失败2:', pv_cpcode), BJTS_SQLERRM_004);
            COMMIT;

  END;
SELECT NSRDZDAH, SWJG_DM, ZS_SWJG_DM, CPCODETSSH, TAG INTO pv_nsrdzdah, pv_swjg_dm, pv_zs_swjg_dm, pv_cpcodetssh, pv_tag FROM GS_DJ_CKTMSDAB
          WHERE NSRSBH = pv_nsrsbh AND NSRDZDAH > 0 AND 1=1 ORDER BY IFNULL(ZX_FLAG, 'N')
LIMIT 1;
          -- DBMS_OUTPUT.put_line('NSRSBH');
          END;

  END;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_005 = MYSQL_ERRNO, BJTS_SQLERRM_005 = MESSAGE_TEXT;
        -- 记录日志，同步失败
        DO ORA_CONCAT(ORA_CONCAT('出口退税企业初始化失败1:', pv_cpcode), BJTS_SQLERRM_005);
        COMMIT;

  END;
SELECT NSRDZDAH, SWJG_DM, ZS_SWJG_DM, CPCODETSSH, TAG INTO pv_nsrdzdah, pv_swjg_dm, pv_zs_swjg_dm, pv_cpcodetssh, pv_tag FROM GS_DJ_CKTMSDAB
      WHERE CPCODE = pv_cpcode AND QYHGDM = pv_qydm AND NSRDZDAH > 0 AND 1=1 ORDER BY IFNULL(ZX_FLAG, 'N')
LIMIT 1;
      -- DBMS_OUTPUT.put_line('CPCODE');
      END;

    IF pv_nsrdzdah > 0 THEN
      BEGIN
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';
        -- 获取同步批次

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
          ROLLBACK;
          -- 记录日志，同步失败
          DO ORA_CONCAT(ORA_CONCAT('出口退税企业同步失败2:', pv_cpcode), BJTS_SQLERRM_002);

  END;
SET pv_tbpc = SEQ_NEXTVAL('SEQ_TB_TBPC');

        IF pv_cntnsr_new = 0 THEN
          IF (pv_swjg_dm <> pv_swcode) THEN
            SET pv_zs_swjg_dm = null;
          END IF;
        ELSE
          SET pv_zs_swjg_dm = null;
        END IF;

        -- 开始同步,增量同步
        -- 单户
        -- 删除同海关代码、档案号
        -- DBMS_OUTPUT.put_line(pv_nsrsbh);
        -- 删除同税号，只保留1条最新
        DELETE FROM GS_DJ_CKTMSDAB WHERE NSRDZDAH = pv_nsrdzdah;
        DELETE FROM GS_DJ_CKTMSDAB WHERE CPCODE = pv_cpcode;
        DELETE FROM GS_DJ_CKTMSDAB WHERE NSRSBH = pv_nsrsbh;
        -- DELETE FROM GS_DJ_CKTMSDAB WHERE QYHGDM = pv_qydm;

        INSERT INTO GS_DJ_CKTMSDAB
        (
          TBPC,
          NSRDZDAH,
          NSRMC,
          NSRMCYW,
          QYHGDM,
          NSRDH,
          NSRCZ,
          NSRYB,
          NSRYX,
          ZCDZ,
          SCJYDZ,
          NSRSBH,
          NSRLX_DM,
          SWJG_DM,
          NSRXYDJ_DM,
          DJZCLX_DM,
          HY_DM,
          LSGX_DM,
          JYZLX_DM,
          BADJBBH,
          SFYSFW,
          YSFW,
          YSFS,
          YFSJ,
          GSDJZZH,
          GSKYRQ,
          GSYXQZ,
          GSDJYXQ,
          GSZCZB,
          FDDBRMC,
          FRZJHM,
          FRDHHM,
          YHMC,
          YHZH,
          BSY1_MC,
          BSY1_ID,
          BSY1_DH,
          BSY2_MC,
          BSY2_ID,
          BSY2_DH,
          ZZSYHZC,
          ZGWHJ,
          FSZL,
          TSJSFS_DM,
          SBFS_MC_ZZBZ,
          SBFS_MC_SJDW,
          SFFBHS,
          FBHSDM,
          QYLX_DM,
          CPCODE,
          NSRDJNO,
          SHXYNO,
          ZS_SWJG_DM,
          ZX_FLAG,
          TSGLLX_DM,
          ZSQYBBSRBZ,
          YHZHTGBZ,
          WMZHFWQYBZ,
          SCSBRQ,
          ZTXTHHBZ,
          ZGSWSKFJ_DM,
          JDXZ_DM,
          XGRQ,
          CPCODETSSH,
          TAG,
          READIN_DATE,
          cwfzrxm,
          cwfzrsfzjhm,
          cwfzrgddh,
          cwfzryddh,
          bsrxm,
          bsrsfzjhm,
          bsrgddh,
          bsryddh,
          djrq,
          scckrq,
          barq,
          fddbr_cgbl
        )
        SELECT
          pv_tbpc,
          pv_nsrdzdah,
          NSRMC,
          NSRMCYW,
          QYHGDM,
          NSRDH,
          NSRCZ,
          NSRYB,
          NSRYX,
          ZCDZ,
          SCJYDZ,
          NSRSBH,
          NSRLX_DM,
          SWJG_DM,
          NSRXYDJ_DM,
          DJZCLX_DM,
          HY_DM,
          LSGX_DM,
          JYZLX_DM,
          BADJBBH,
          SFYSFW,
          YSFW,
          YSFS,
          YFSJ,
          GSDJZZH,
          GSKYRQ,
          GSYXQZ,
          GSDJYXQ,
          GSZCZB,
          FDDBRMC,
          FRZJHM,
          FRDHHM,
          YHMC,
          YHZH,
          BSY1_MC,
          BSY1_ID,
          BSY1_DH,
          BSY2_MC,
          BSY2_ID,
          BSY2_DH,
          ZZSYHZC,
          ZGWHJ,
          FSZL,
          TSJSFS_DM,
          SBFS_MC_ZZBZ,
          SBFS_MC_SJDW,
          SFFBHS,
          FBHSDM,
          QYLX_DM,
          CPCODE,
          NSRDJNO,
          SHXYNO,
          pv_zs_swjg_dm,
          ZX_FLAG,
          TSGLLX_DM,
          ZSQYBBSRBZ,
          YHZHTGBZ,
          WMZHFWQYBZ,
          SCSBRQ,
          ZTXTHHBZ,
          ZGSWSKFJ_DM,
          JDXZ_DM,
          XGRQ,
          pv_cpcodetssh,
          pv_tag,
          CURRENT_TIMESTAMP,
          cwfzrxm,
          cwfzrsfzjhm,
          cwfzrgddh,
          cwfzryddh,
          bsrxm,
          bsrsfzjhm,
          bsrgddh,
          bsryddh,
          djrq,
          scckrq,
          barq,
          fddbr_cgbl
        FROM GS_DJ_CKTMSDAB_TB
        WHERE CPCODE = pv_cpcode AND QYHGDM = pv_qydm;

        -- 插入待同步数据
        INSERT INTO TB_DTBSJ(id,tblx_dm,mainid,cjsj,tbcs,yxj)
        VALUES(SEQ_NEXTVAL('SEQ_TB_DTBSJ_ID'),'GS_DJ_CKTMSDABToYun',pv_tbpc,CURRENT_TIMESTAMP,0,1);

        -- 记录日志，同步成功
        DO ORA_CONCAT(ORA_CONCAT(pv_cpcode, '同步成功'), pv_qydm);
        COMMIT;

        END;
    END IF;

  END LOOP BJTS_FETCH_LOOP_001;
  CLOSE BJTS_FETCH_CURSOR_001;
END;

  COMMIT;
  DO '出口退税企业同步成功';
  END$$

DELIMITER ;

-- END SOURCE: P_ETL_GS_DJ_CKTMSDAB_ONE.sql

-- ======================================================================
-- [105/114] BEGIN SOURCE: P_ETL_GS_DJ_TXFWSQXX.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS P_ETL_GS_DJ_TXFWSQXX$$

CREATE PROCEDURE P_ETL_GS_DJ_TXFWSQXX()
routine_body: BEGIN
  DECLARE BJTS_ITERATE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_ITERATE_002 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';
  DECLARE pv_tbpc DECIMAL(20,0);
  DECLARE pv_nsrdzdah DECIMAL(20,0);
  DECLARE pv_qyhgdm VARCHAR(32);
  DECLARE pv_cnt BIGINT;
  -- 注销纳税人不导



  -- --已取消

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
    rollback;
    -- 记录日志，同步失败
    SET @BJTS_DYNAMIC_SQL_001 = 'INSERT INTO TB_GS_TBSB_RZ(tblx_dm,sbyy) VALUES(?,?)';
PREPARE BJTS_DYNAMIC_STMT_001 FROM @BJTS_DYNAMIC_SQL_001;
SET @BJTS_BIND_001_001 = 'GS_DJ_TXFWSQXXToYun';
SET @BJTS_BIND_001_002 = ORA_CONCAT('失败:', BJTS_SQLERRM_001);
EXECUTE BJTS_DYNAMIC_STMT_001 USING @BJTS_BIND_001_001, @BJTS_BIND_001_002;
DEALLOCATE PREPARE BJTS_DYNAMIC_STMT_001;
    DO ORA_CONCAT('提醒服务信息表同步失败:', BJTS_SQLERRM_001);
    commit;

  END;
UPDATE GS_DJ_TXFWSQXX SET TBPC = 6 WHERE TBPC = 0;
  COMMIT;
  -- 同步提醒服务信息表,增量更新
  -- 提醒服务信息表
  -- DELETE FROM GS_DJ_TXFWSQXX WHERE tbpc not in (SELECT mainid FROM TB_DTBSJ WHERE tblx_dm = 'GS_DJ_TXFWSQXXToYun');
  -- COMMIT;
  -- DBMS_OUTPUT.put_line('提醒服务信息表历史数据清理成功');

  -- ETL调用
  -- 初始化
  SET pv_cnt = 0;
  SELECT count(DISTINCT CPCODE) INTO pv_cnt FROM GS_DJ_TXFWSQXX WHERE TBPC = 6;
  DO ORA_CONCAT(ORA_CONCAT('同步提醒服务信息表同步开始 [', CAST(pv_cnt AS CHAR)), '] 户');
  IF pv_cnt = 0 THEN
     LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_FETCH_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_RS_NSR_CPCODE_001 LONGTEXT;
  DECLARE BJTS_FETCH_CURSOR_001 CURSOR FOR
SELECT DISTINCT CPCODE FROM GS_DJ_TXFWSQXX WHERE TBPC = 6 and CPCODE IS NOT NULL;
  OPEN BJTS_FETCH_CURSOR_001;
  BJTS_FETCH_LOOP_001: LOOP
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_FETCH_DONE_001 = TRUE;
      FETCH BJTS_FETCH_CURSOR_001 INTO BJTS_RS_NSR_CPCODE_001;
    END;
    IF BJTS_FETCH_DONE_001 THEN
      LEAVE BJTS_FETCH_LOOP_001;
    END IF;

    SET pv_qyhgdm = BJTS_RS_NSR_CPCODE_001;

    -- 获取NSRDZDAH
    SET BJTS_ITERATE_001 = FALSE;
    BEGIN
  DECLARE BJTS_SQLCODE_003 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_003 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_003 = MYSQL_ERRNO, BJTS_SQLERRM_003 = MESSAGE_TEXT;
        SET BJTS_ITERATE_001 = TRUE;

  END;
SELECT NSRDZDAH INTO pv_nsrdzdah FROM GS_DJ_CKTMSDAB WHERE CPCODE = pv_qyhgdm AND NSRDZDAH > 0 AND IFNULL(ZX_FLAG, 'N') <> 'Y';
      END;
  IF BJTS_ITERATE_001 THEN
    ITERATE BJTS_FETCH_LOOP_001;
  END IF;

    SET BJTS_ITERATE_002 = FALSE;
    BEGIN
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';
      -- 获取同步批次

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
        ROLLBACK;
        -- 记录日志，同步失败
        DO ORA_CONCAT(ORA_CONCAT('提醒服务信息表同步失败:', pv_qyhgdm), BJTS_SQLERRM_002);
        SET BJTS_ITERATE_002 = TRUE;

  END;
SET pv_tbpc = SEQ_NEXTVAL('SEQ_TB_TBPC');
      -- 开始同步
      -- 增量
      -- pv_czrq := sysdate;
      -- TB_CKTS_GC_SQ_TXFW
      UPDATE GS_DJ_TXFWSQXX SET NSRDZDAH = pv_nsrdzdah WHERE CPCODE = pv_qyhgdm AND TBPC = 6;

      -- 插入待同步数据
      -- INSERT INTO TB_DTBSJ(id,tblx_dm,mainid,cjsj,tbcs,yxj)
      -- VALUES(SEQ_TB_DTBSJ_ID.NEXTVAL,'GS_DJ_TXFWSQXXToYun',pv_tbpc,sysdate,0,1);
      -- DBMS_OUTPUT.put_line(pv_qyhgdm || '同步成功');

      END;
  IF BJTS_ITERATE_002 THEN
    ITERATE BJTS_FETCH_LOOP_001;
  END IF;

  END LOOP BJTS_FETCH_LOOP_001;
  CLOSE BJTS_FETCH_CURSOR_001;
END;

  UPDATE GS_DJ_TXFWSQXX SET TBPC = 1 WHERE TBPC = 6;
  COMMIT;
  DO '提醒服务信息表同步成功';
  END$$

DELIMITER ;

-- END SOURCE: P_ETL_GS_DJ_TXFWSQXX.sql

-- ======================================================================
-- [106/114] BEGIN SOURCE: P_ETL_GS_DLCKHWZM.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS P_ETL_GS_DLCKHWZM$$

CREATE PROCEDURE P_ETL_GS_DLCKHWZM()
routine_body: BEGIN
  DECLARE BJTS_ITERATE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_ITERATE_002 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';
  DECLARE pv_tbpc DECIMAL(20,0);
  DECLARE pv_newpc DECIMAL(20,0);
  DECLARE pv_nsrdzdah DECIMAL(20,0);
  DECLARE pv_qyhgdm VARCHAR(32);
  DECLARE pv_cnt BIGINT;
  -- 注销纳税人不导



  -- 已取消

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
    rollback;
    -- 记录日志，同步失败
    SET @BJTS_DYNAMIC_SQL_001 = 'INSERT INTO TB_GS_TBSB_RZ(tblx_dm,sbyy) VALUES(?,?)';
PREPARE BJTS_DYNAMIC_STMT_001 FROM @BJTS_DYNAMIC_SQL_001;
SET @BJTS_BIND_001_001 = 'GS_DLCKHWZMToYun';
SET @BJTS_BIND_001_002 = ORA_CONCAT('失败:', BJTS_SQLERRM_001);
EXECUTE BJTS_DYNAMIC_STMT_001 USING @BJTS_BIND_001_001, @BJTS_BIND_001_002;
DEALLOCATE PREPARE BJTS_DYNAMIC_STMT_001;
    DO ORA_CONCAT('代理出口货物证明表同步失败:', BJTS_SQLERRM_001);
    commit;

  END;
UPDATE TB_CKTS_HISTORY_ZJDLZM SET TBPC = 6 WHERE TBPC = 0;
  COMMIT;
  -- 代理出口货物证明表
  DELETE FROM GS_DLCKHWZM WHERE tbpc not in (SELECT mainid FROM TB_DTBSJ WHERE tblx_dm = 'GS_DLCKHWZMToYun');
  COMMIT;
  DO '代理出口货物证明表历史数据清理成功';

  -- ETL调用
  -- 初始化
  SET pv_cnt = 0;
  SELECT count(DISTINCT WT_CPCODE) INTO pv_cnt FROM TB_CKTS_HISTORY_ZJDLZM WHERE TBPC = 6;
  DO ORA_CONCAT(ORA_CONCAT('同步代理出口货物证明表同步开始 [', CAST(pv_cnt AS CHAR)), '] 户');
  IF pv_cnt = 0 THEN
     LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_FETCH_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_RS_NSR_WT_CPCODE_001 LONGTEXT;
  DECLARE BJTS_FETCH_CURSOR_001 CURSOR FOR
SELECT DISTINCT WT_CPCODE FROM TB_CKTS_HISTORY_ZJDLZM WHERE TBPC = 6 and WT_CPCODE IS NOT NULL;
  OPEN BJTS_FETCH_CURSOR_001;
  BJTS_FETCH_LOOP_001: LOOP
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_FETCH_DONE_001 = TRUE;
      FETCH BJTS_FETCH_CURSOR_001 INTO BJTS_RS_NSR_WT_CPCODE_001;
    END;
    IF BJTS_FETCH_DONE_001 THEN
      LEAVE BJTS_FETCH_LOOP_001;
    END IF;

    SET pv_qyhgdm = BJTS_RS_NSR_WT_CPCODE_001;

    -- 获取NSRDZDAH
    SET BJTS_ITERATE_001 = FALSE;
    BEGIN
  DECLARE BJTS_SQLCODE_003 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_003 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_003 = MYSQL_ERRNO, BJTS_SQLERRM_003 = MESSAGE_TEXT;
        SET BJTS_ITERATE_001 = TRUE;

  END;
SELECT NSRDZDAH INTO pv_nsrdzdah FROM GS_DJ_CKTMSDAB WHERE CPCODE = pv_qyhgdm AND NSRDZDAH > 0 AND IFNULL(ZX_FLAG, 'N') <> 'Y';
      END;
  IF BJTS_ITERATE_001 THEN
    ITERATE BJTS_FETCH_LOOP_001;
  END IF;

    SET BJTS_ITERATE_002 = FALSE;
    BEGIN
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';
      -- 获取同步批次

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
        ROLLBACK;
        -- 记录日志，同步失败
        SET @BJTS_DYNAMIC_SQL_002 = 'UPDATE TB_CKTS_HISTORY_ZJDLZM SET TBPC=9,TBERR=? WHERE CPCODE=? AND TBPC=6';
PREPARE BJTS_DYNAMIC_STMT_002 FROM @BJTS_DYNAMIC_SQL_002;
SET @BJTS_BIND_002_001 = BJTS_SQLERRM_002;
SET @BJTS_BIND_002_002 = pv_qyhgdm;
EXECUTE BJTS_DYNAMIC_STMT_002 USING @BJTS_BIND_002_001, @BJTS_BIND_002_002;
DEALLOCATE PREPARE BJTS_DYNAMIC_STMT_002;
        COMMIT;
        DO ORA_CONCAT(ORA_CONCAT('代理出口货物证明表同步失败:', pv_qyhgdm), BJTS_SQLERRM_002);
        SET BJTS_ITERATE_002 = TRUE;

  END;
SET pv_tbpc = SEQ_NEXTVAL('SEQ_TB_TBPC');
      -- 开始同步
      -- 增量
      -- 开始同步
      -- pv_czrq := sysdate;
      INSERT INTO GS_DLCKHWZM
      (
        TBPC,
        NSRDZDAH,
        DLCKHWZM,
        HGBGDH,
        CKRQ,
        HGMYXZ_DM,
        SPDM,
        SPMC,
        JLDW,
        SL,
        HBZL_DM,
        JE_LAJ_USD,
        HLV_USD,
        JE_LAJ_RMB,
        FLAG_PP
      )
      SELECT
        pv_tbpc,
        pv_nsrdzdah,
        dlzm_no,
        bgd_no,
        lj_date,
        tdcode,
        cmcode,
        cmname,
        cmunit,
        bg_qnt,
        bicode,
        usd_amt,
        null,
        null,
        null
      FROM TB_CKTS_HISTORY_ZJDLZM
      WHERE WT_CPCODE = pv_qyhgdm AND TBPC = 6;

      -- 超过1000条，分批
      BJTS_LOOP_001: LOOP
        SELECT count(*) INTO pv_cnt from GS_DLCKHWZM WHERE tbpc = pv_tbpc;
        IF pv_cnt < 1000 THEN LEAVE BJTS_LOOP_001; END IF;
        SET pv_newpc = SEQ_NEXTVAL('SEQ_TB_TBPC');

        update GS_DLCKHWZM set tbpc = pv_newpc where tbpc = pv_tbpc and 1=1
LIMIT 1000;
        INSERT INTO TB_DTBSJ(id,tblx_dm,mainid,cjsj,tbcs,yxj)
        VALUES(SEQ_NEXTVAL('SEQ_TB_DTBSJ_ID'),'GS_DLCKHWZMToYun',pv_newpc,CURRENT_TIMESTAMP,0,1);
        COMMIT;
      END LOOP BJTS_LOOP_001;

      -- 插入待同步数据
      INSERT INTO TB_DTBSJ(id,tblx_dm,mainid,cjsj,tbcs,yxj)
      VALUES(SEQ_NEXTVAL('SEQ_TB_DTBSJ_ID'),'GS_DLCKHWZMToYun',pv_tbpc,CURRENT_TIMESTAMP,0,1);
      COMMIT;
      DO ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(pv_qyhgdm, '同步成功'), CAST(pv_cnt AS CHAR)), '条数据');

      END;
  IF BJTS_ITERATE_002 THEN
    ITERATE BJTS_FETCH_LOOP_001;
  END IF;

  END LOOP BJTS_FETCH_LOOP_001;
  CLOSE BJTS_FETCH_CURSOR_001;
END;

  DELETE FROM TB_CKTS_HISTORY_ZJDLZM WHERE TBPC = 1;
  UPDATE TB_CKTS_HISTORY_ZJDLZM SET TBPC = 1 WHERE TBPC = 6;
  COMMIT;
  DO '代理出口货物证明表同步成功';
  END$$

DELIMITER ;

-- END SOURCE: P_ETL_GS_DLCKHWZM.sql

-- ======================================================================
-- [107/114] BEGIN SOURCE: P_ETL_GS_HBZL_HLV.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS P_ETL_GS_HBZL_HLV$$

CREATE PROCEDURE P_ETL_GS_HBZL_HLV()
routine_body: BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';
  DECLARE pv_tbpc DECIMAL(20,0);
  DECLARE pv_cnt integer;

  -- 已取消
  -- 货币种类，汇率表，按月更新
  -- 初始化

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
    rollback;
    -- 记录日志，同步失败
    SET @BJTS_DYNAMIC_SQL_001 = 'INSERT INTO TB_GS_TBSB_RZ(tblx_dm,sbyy) VALUES(?,?)';
PREPARE BJTS_DYNAMIC_STMT_001 FROM @BJTS_DYNAMIC_SQL_001;
SET @BJTS_BIND_001_001 = 'GS_HBZL_HLVToYun';
SET @BJTS_BIND_001_002 = ORA_CONCAT('失败:', BJTS_SQLERRM_001);
EXECUTE BJTS_DYNAMIC_STMT_001 USING @BJTS_BIND_001_001, @BJTS_BIND_001_002;
DEALLOCATE PREPARE BJTS_DYNAMIC_STMT_001;
    DO ORA_CONCAT('货币种类，汇率表同步失败:', BJTS_SQLERRM_001);
    commit;

  END;
UPDATE TB_CKTS_BICODE_SUB SET TBPC = 6 WHERE TBPC = 0;
  COMMIT;
  -- 同步汇率表,增量更新
  -- 提醒服务信息表
  DELETE FROM GS_HBZL_HLV WHERE tbpc not in (SELECT mainid FROM TB_DTBSJ WHERE tblx_dm = 'GS_HBZL_HLVToYun');
  COMMIT;
  DO '提醒汇率表历史数据清理成功';

  SELECT count(*) INTO pv_cnt FROM TB_CKTS_BICODE_SUB WHERE tbpc = 6;
  IF pv_cnt > 0 THEN
    -- 获取同步批次
    SET pv_tbpc = SEQ_NEXTVAL('SEQ_TB_TBPC');

    -- 开始同步,全表刷新
    INSERT INTO GS_HBZL_HLV
    (
      TBPC,
      HL_YM,
      CODE,
      HL_RMB,
      HL_USD,
      HL_RANGE
    )
    SELECT
      pv_tbpc,
      HL_YM,
      CODE,
      HL_RMB,
      HL_USD,
      HL_RANGE
    FROM TB_CKTS_BICODE_SUB
    WHERE TBPC = 6;

    -- 插入待同步数据
    INSERT INTO TB_DTBSJ(id,tblx_dm,mainid,cjsj,tbcs,yxj)
    VALUES(SEQ_NEXTVAL('SEQ_TB_DTBSJ_ID'),'GS_HBZL_HLVToYun',pv_tbpc,CURRENT_TIMESTAMP,0,1);
  END IF;

  DELETE FROM TB_CKTS_BICODE_SUB WHERE TBPC = 1;
  UPDATE TB_CKTS_BICODE_SUB SET TBPC = 1 WHERE TBPC = 6;
  COMMIT;
  DO '货币种类，汇率表同步成功';
  END$$

DELIMITER ;

-- END SOURCE: P_ETL_GS_HBZL_HLV.sql

-- ======================================================================
-- [108/114] BEGIN SOURCE: P_ETL_GS_JLJG_JHFPL.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS P_ETL_GS_JLJG_JHFPL$$

CREATE PROCEDURE P_ETL_GS_JLJG_JHFPL()
routine_body: BEGIN
  DECLARE BJTS_ITERATE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_ITERATE_002 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';
  DECLARE pv_tbpc DECIMAL(20,0);
  DECLARE pv_nsrdzdah DECIMAL(20,0);
  DECLARE pv_qyhgdm VARCHAR(32);
  DECLARE pv_cnt integer;



  -- 已取消
  -- UPDATE TB_CKTS_GC_JLJG_JHFPL SET TBPC = 6 WHERE TBPC = 0;
  -- COMMIT;
  -- 同步进料加工计划分配率表
  -- 进料加工计划分配率表

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
    rollback;
    -- 记录日志，同步失败
    SET @BJTS_DYNAMIC_SQL_001 = 'INSERT INTO TB_GS_TBSB_RZ(tblx_dm,sbyy) VALUES(?,?)';
PREPARE BJTS_DYNAMIC_STMT_001 FROM @BJTS_DYNAMIC_SQL_001;
SET @BJTS_BIND_001_001 = 'GS_JLJG_JHFPLToYun';
SET @BJTS_BIND_001_002 = ORA_CONCAT('失败:', BJTS_SQLERRM_001);
EXECUTE BJTS_DYNAMIC_STMT_001 USING @BJTS_BIND_001_001, @BJTS_BIND_001_002;
DEALLOCATE PREPARE BJTS_DYNAMIC_STMT_001;
    DO ORA_CONCAT('进料加工计划分配率表同步失败:', BJTS_SQLERRM_001);
    commit;

  END;
DELETE FROM GS_JLJG_JHFPL WHERE tbpc not in (SELECT mainid FROM TB_DTBSJ WHERE tblx_dm = 'GS_JLJG_JHFPLToYun');
  COMMIT;
  DO '进料加工计划分配率表历史数据清理成功';

  -- ETL调用
  -- 初始化
  SET pv_cnt = 0;
  SELECT count(DISTINCT CPCODE) INTO pv_cnt FROM TB_CKTS_GC_JLJG_JHFPL;
  DO ORA_CONCAT(ORA_CONCAT('同步进料加工计划分配率表同步开始 [', CAST(pv_cnt AS CHAR)), '] 户');
  IF pv_cnt = 0 THEN
     LEAVE routine_body;
  END IF;

  BEGIN
  DECLARE BJTS_FETCH_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_RS_NSR_CPCODE_001 LONGTEXT;
  DECLARE BJTS_FETCH_CURSOR_001 CURSOR FOR
SELECT DISTINCT CPCODE FROM TB_CKTS_GC_JLJG_JHFPL WHERE CPCODE IS NOT NULL;
  OPEN BJTS_FETCH_CURSOR_001;
  BJTS_FETCH_LOOP_001: LOOP
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_FETCH_DONE_001 = TRUE;
      FETCH BJTS_FETCH_CURSOR_001 INTO BJTS_RS_NSR_CPCODE_001;
    END;
    IF BJTS_FETCH_DONE_001 THEN
      LEAVE BJTS_FETCH_LOOP_001;
    END IF;

    SET pv_qyhgdm = BJTS_RS_NSR_CPCODE_001;

    -- 获取NSRDZDAH
    SET BJTS_ITERATE_001 = FALSE;
    BEGIN
  DECLARE BJTS_SQLCODE_003 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_003 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_003 = MYSQL_ERRNO, BJTS_SQLERRM_003 = MESSAGE_TEXT;
        SET BJTS_ITERATE_001 = TRUE;

  END;
SELECT NSRDZDAH INTO pv_nsrdzdah FROM GS_DJ_CKTMSDAB WHERE CPCODE = pv_qyhgdm AND NSRDZDAH > 0 AND IFNULL(ZX_FLAG, 'N') <> 'Y';
      END;
  IF BJTS_ITERATE_001 THEN
    ITERATE BJTS_FETCH_LOOP_001;
  END IF;

    SET BJTS_ITERATE_002 = FALSE;
    BEGIN
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';
      -- 获取同步批次

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
        ROLLBACK;
        -- 记录日志，同步失败
        SET @BJTS_DYNAMIC_SQL_002 = 'UPDATE TB_CKTS_GC_JLJG_JHFPL SET TBPC=9,TBERR=? WHERE CPCODE=?';
PREPARE BJTS_DYNAMIC_STMT_002 FROM @BJTS_DYNAMIC_SQL_002;
SET @BJTS_BIND_002_001 = BJTS_SQLERRM_002;
SET @BJTS_BIND_002_002 = pv_qyhgdm;
EXECUTE BJTS_DYNAMIC_STMT_002 USING @BJTS_BIND_002_001, @BJTS_BIND_002_002;
DEALLOCATE PREPARE BJTS_DYNAMIC_STMT_002;
        COMMIT;
        DO ORA_CONCAT(ORA_CONCAT('进料加工计划分配率表同步失败:', pv_qyhgdm), BJTS_SQLERRM_002);
        SET BJTS_ITERATE_002 = TRUE;

  END;
SET pv_tbpc = SEQ_NEXTVAL('SEQ_TB_TBPC');

      -- 开始同步
      -- 开始同步,增量同步
      -- 单户
      -- 每次维护TSSH.GC_JLJG_JHFPL最新
      -- 每次维护tssh.gc_jljg_jhfpl_his，历史信息
      -- pv_czrq := sysdate;
      INSERT INTO GS_JLJG_JHFPL
      (
        TBPC,
        NSRDZDAH,
        SSSQ,
        JHFPLV,
        JHFPLV_NEW,
        UPTIME
      )
      SELECT
        pv_tbpc,
        pv_nsrdzdah,
        SB_YM,
        JHFPL,
        JHFPL_NEW,
        OP_DATE
      FROM TB_CKTS_GC_JLJG_JHFPL
      WHERE CPCODE = pv_qyhgdm;

      -- 插入待同步数据
      INSERT INTO TB_DTBSJ(id,tblx_dm,mainid,cjsj,tbcs,yxj)
      VALUES(SEQ_NEXTVAL('SEQ_TB_DTBSJ_ID'),'GS_JLJG_JHFPLToYun',pv_tbpc,CURRENT_TIMESTAMP,0,1);
      COMMIT;
      DO ORA_CONCAT(pv_qyhgdm, '同步成功');

      END;
  IF BJTS_ITERATE_002 THEN
    ITERATE BJTS_FETCH_LOOP_001;
  END IF;

  END LOOP BJTS_FETCH_LOOP_001;
  CLOSE BJTS_FETCH_CURSOR_001;
END;

  -- DELETE FROM TB_CKTS_GC_JLJG_JHFPL WHERE TBPC = 1;
  -- UPDATE TB_CKTS_GC_JLJG_JHFPL SET TBPC = 1 WHERE TBPC = 6;
  COMMIT;
  DO '进料加工计划分配率表同步成功';
  END$$

DELIMITER ;

-- END SOURCE: P_ETL_GS_JLJG_JHFPL.sql

-- ======================================================================
-- [109/114] BEGIN SOURCE: P_INPUT_JJR.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS P_INPUT_JJR$$

CREATE procedure P_INPUT_JJR()
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

-- END SOURCE: P_INPUT_JJR.sql

-- ======================================================================
-- [110/114] BEGIN SOURCE: P_TB_DOEVERYDAY.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS P_TB_DOEVERYDAY$$

CREATE procedure P_TB_DOEVERYDAY()
routine_body: BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';
  DECLARE v_msgtext VARCHAR(4000);

  -- 计划任务

--  if extract(day from sysdate) = 1 then
    -- 每个月1号执行一次
    -- 随机分单，每个账户月分配笔数，月初清0

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
    SET v_msgtext = BJTS_SQLERRM_001;
    rollback;
    DO ORA_CONCAT('Error: ', v_msgtext);
    -- EXIT HANDLER exits routine_body after preserving the result.

  END;
update SYS_CFG_CZRY_FPGL set cnt_sc=0, cnt_wm=0, cnt_qt=0;
    commit;
    DO '随机分单月初清0';
--  end if;
  LEAVE routine_body;

  END$$

DELIMITER ;

-- END SOURCE: P_TB_DOEVERYDAY.sql

-- ======================================================================
-- [111/114] BEGIN SOURCE: P_TJ_JXKH_YWLC.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS P_TJ_JXKH_YWLC$$

CREATE procedure P_TJ_JXKH_YWLC()
routine_body: BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';
  DECLARE v_msgtext VARCHAR(4000);


  DECLARE date_tjrq DATETIME;
  DECLARE date_slrq DATETIME;

  -- 5日前不统计
  -- if extract(day from date_tjrq) < 5 then
  --  return;
  -- end if;
  -- DELETE FROM JXKH_YWLC WHERE TO_CHAR(SL_DATE,'YYYY') = av_ssnd;
  -- COMMIT;

  -- 核准日期日,固定年初

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
    SET v_msgtext = BJTS_SQLERRM_001;
    rollback;
    DO ORA_CONCAT('Error: ', v_msgtext);
    -- EXIT HANDLER exits routine_body after preserving the result.

  END;
SET date_slrq = STR_TO_DATE('2021-01-01', '%Y-%m-%d');

  UPDATE JXKH_YWLC AS T
     SET NSRDZDAH = (SELECT NSRDZDAH
FROM GS_DJ_CKTMSDAB S WHERE S.CPCODE=T.CPCODE AND 1=1
LIMIT 1),
    QYHGDM = (SELECT QYHGDM
FROM GS_DJ_CKTMSDAB S WHERE S.CPCODE=T.CPCODE AND 1=1
LIMIT 1),
    NSRSBH = (SELECT NSRSBH
FROM GS_DJ_CKTMSDAB S WHERE S.CPCODE=T.CPCODE AND 1=1
LIMIT 1),
    NSRMC = (SELECT NSRMC
FROM GS_DJ_CKTMSDAB S WHERE S.CPCODE=T.CPCODE AND 1=1
LIMIT 1)
   WHERE SL_DATE > date_slrq and NSRDZDAH IS NULL;
  COMMIT;
  DO '完成名称设置';

  UPDATE JXKH_YWLC AS UU
JOIN (
select LCSLID, SBID, SBRQ
           from (select T.lcslid,
                        S.ID as SBID,
                        case when S.sbfs='0' then greatest(IFNULL(S.sbsj, S.sbrq),S.sbrq) else S.sbrq end as SBRQ,
                        ROW_NUMBER() OVER(partition by S.lcslid order by S.sbrq desc) as RN
                   FROM JXKH_YWLC T, SB_SBXX_HZ S
                  WHERE T.SL_DATE > date_slrq
                    and T.SBID IS NULL
                    and S.LCSLID = T.LCSLID) AS BJTS_DERIVED_001
          WHERE RN = 1
) AS ZZ
ON ZZ.lcslid = UU.LCSLID
SET SBID = ZZ.SBID, SBRQ = ZZ.SBRQ;
  COMMIT;

  DO '完成申报日期设置';

  -- 计算实际接单日期(实际申报日期)
  -- FLGLCD='D',WZHQY='0'，接单日期=MAX(受理日期,增值税日期)
  -- (免抵退)，接单日期=MAX(申报日期,增值税日期)
  -- (其他),   接单日期=申报日期
  UPDATE JXKH_YWLC AS T
     SET JD_DATE = CASE WHEN FLGLCD='D' OR WZHQY='0' THEN SL_DATE
                        WHEN FLGLCD<>'D' AND WZHQY<>'0' AND SBYWB_DM='A0305001' THEN least(greatest(IFNULL(SBRQ, SL_DATE),ZZS_DATE),SL_DATE)
                        ELSE least(IFNULL(SBRQ, SL_DATE),SL_DATE) END
    WHERE SL_DATE > date_slrq and JD_DATE=STR_TO_DATE('1900-01-01', '%Y-%m-%d');
  COMMIT;
  DO '完成实际接单日期设置';

  -- 参与计算表识 0 默认 1有评估 2退税额为0
/*  UPDATE JXKH_YWLC T
     SET JS_FLAG = '1'
     WHERE SL_DATE > date_slrq AND JS_FLAG = '0'
     AND NVL(PG_DATE,TO_DATE('1900-01-01','YYYY-MM-DD')) > TO_DATE('1900-01-02','YYYY-MM-DD');
  COMMIT;
*/
  UPDATE JXKH_YWLC AS T
     SET JS_FLAG = '2'
     WHERE SL_DATE > date_slrq AND JS_FLAG = '0' AND IFNULL(HZ_TSE, 0) = 0;
  COMMIT;
  UPDATE JXKH_YWLC AS T
     SET JS_FLAG = '0'
     WHERE SL_DATE > date_slrq AND JS_FLAG = '2' AND IFNULL(HZ_TSE, 0) <> 0;
  COMMIT;
  UPDATE JXKH_YWLC AS T
     SET JS_FLAG = '3'
     WHERE SL_DATE > date_slrq AND JS_FLAG = '0'
     AND IFNULL(KP_DATE, STR_TO_DATE('1900-01-01', '%Y-%m-%d')) = STR_TO_DATE('1900-01-01', '%Y-%m-%d');
  COMMIT;
  UPDATE JXKH_YWLC AS T
     SET JS_FLAG = '0'
     WHERE SL_DATE > date_slrq AND JS_FLAG = '3'
     AND IFNULL(KP_DATE, STR_TO_DATE('1900-01-01', '%Y-%m-%d')) > STR_TO_DATE('1900-01-02', '%Y-%m-%d');
  COMMIT;
  DO '完成参与计算表识统计';

  -- 退税退库日期没时间,默认统一设置成当天中午12点
  -- 合计周期=开票日期-接单日期
  UPDATE JXKH_YWLC AS T
     SET SUM_DAY = IFNULL(greatest(ORA_DATE_DIFF(GREATEST(KP_DATE,SRTHS_DATE), JD_DATE),0), 0),
    SL_DAY = greatest(ORA_DATE_DIFF(SL_DATE, JD_DATE),0),
    SH_DAY = CASE WHEN IFNULL(JS_DATE, STR_TO_DATE('1900-01-01', '%Y-%m-%d'))= STR_TO_DATE('1900-01-01', '%Y-%m-%d')
                  or JS_DATE>SRTHS_DATE
                  THEN 0 ELSE greatest(ORA_DATE_DIFF(JS_DATE, SL_DATE),0) END,
    PG_DAY = CASE WHEN IFNULL(PG_DATE, STR_TO_DATE('1900-01-01', '%Y-%m-%d'))= STR_TO_DATE('1900-01-01', '%Y-%m-%d')
                  or PG_DATE>SRTHS_DATE
                  THEN 0 ELSE greatest(ORA_DATE_DIFF(PG_DATE, JS_DATE),0) END,
    FH_DAY = CASE WHEN IFNULL(FH_DATE, STR_TO_DATE('1900-01-01', '%Y-%m-%d'))= STR_TO_DATE('1900-01-01', '%Y-%m-%d')
                  or FH_DATE>SRTHS_DATE
                  THEN 0 ELSE greatest(ORA_DATE_DIFF(FH_DATE, greatest(SL_DATE,JS_DATE,PG_DATE)),0) END,
    SRTHS_DAY = greatest(ORA_DATE_DIFF(SRTHS_DATE, HZ_DATE),0),
    KP_DAY = greatest(ORA_DATE_DIFF(KP_DATE, SRTHS_DATE),0),
    TK_DAY = greatest((ORA_DATE_ADD(TSTK_DATE, 0.5))-greatest(SRTHS_DATE,KP_DATE),0),
    SSYEAR = DATE_FORMAT(SL_DATE, '%Y'),
    TJ_DATE = CURRENT_TIMESTAMP
   WHERE SL_DATE > date_slrq AND KP_DATE>STR_TO_DATE('1900-01-01', '%Y-%m-%d');
  COMMIT;
  DO '完成天数统计';

  -- 未减非工作日
  BEGIN
  DECLARE BJTS_FETCH_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_RS_JJR_JJR_DATE_001 LONGTEXT;
  DECLARE BJTS_FETCH_CURSOR_001 CURSOR FOR
select JJR_DATE from PUB_JJR where jjr_ssnd =  (DATE_FORMAT(date_slrq, '%Y')) order by JJR_DATE;
  OPEN BJTS_FETCH_CURSOR_001;
  BJTS_FETCH_LOOP_001: LOOP
    BEGIN
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
        SET v_msgtext = BJTS_SQLERRM_002;
        rollback;
        DO ORA_CONCAT('Error: ', v_msgtext);

  END;
BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_FETCH_DONE_001 = TRUE;
      FETCH BJTS_FETCH_CURSOR_001 INTO BJTS_RS_JJR_JJR_DATE_001;
    END;
    IF BJTS_FETCH_DONE_001 THEN
      LEAVE BJTS_FETCH_LOOP_001;
    END IF;

      SET date_tjrq = BJTS_RS_JJR_JJR_DATE_001;
      DO ORA_CONCAT('假日:', DATE_FORMAT(date_tjrq, '%Y-%m-%d'));

      UPDATE JXKH_YWLC AS T
         SET SUM_DAY = SUM_DAY - 1
         WHERE SL_DATE >= date_slrq and SUM_DAY >= 1 AND (date_tjrq < KP_DATE AND date_tjrq > JD_DATE);
      UPDATE JXKH_YWLC AS T
         SET SL_DAY = SL_DAY - 1
         WHERE SL_DATE >= date_slrq and SL_DAY >= 1 AND (date_tjrq < SL_DATE AND date_tjrq > JD_DATE);
      UPDATE JXKH_YWLC AS T
         SET SH_DAY = SH_DAY - 1
         WHERE SL_DATE >= date_slrq and SH_DAY >= 1 AND (date_tjrq < JS_DATE AND date_tjrq > SL_DATE);
      UPDATE JXKH_YWLC AS T
         SET PG_DAY = PG_DAY - 1
         WHERE SL_DATE >= date_slrq and PG_DAY >= 1 AND (date_tjrq < PG_DATE AND date_tjrq > JS_DATE);
      UPDATE JXKH_YWLC AS T
         SET FH_DAY = FH_DAY - 1
         WHERE SL_DATE >= date_slrq and FH_DAY >= 1 AND (date_tjrq < FH_DATE AND date_tjrq > greatest(JS_DATE,PG_DATE));
      UPDATE JXKH_YWLC AS T
         SET SRTHS_DAY = SRTHS_DAY - 1
         WHERE SL_DATE >= date_slrq and SRTHS_DAY >= 1 AND (date_tjrq < SRTHS_DATE AND date_tjrq > HZ_DATE);
      UPDATE JXKH_YWLC AS T
         SET KP_DAY = KP_DAY - 1
         WHERE SL_DATE >= date_slrq and KP_DAY >= 1 AND (date_tjrq < KP_DATE AND date_tjrq > SRTHS_DATE);
      UPDATE JXKH_YWLC AS T
         SET TK_DAY = TK_DAY - 1
         WHERE SL_DATE >= date_slrq and TK_DAY >= 1 AND (date_tjrq < TSTK_DATE AND date_tjrq > KP_DATE);

      COMMIT;

      END;

  END LOOP BJTS_FETCH_LOOP_001;
  CLOSE BJTS_FETCH_CURSOR_001;
END;
  DO '完成节假日扣除';

  -- 最后计算核准周期
  UPDATE JXKH_YWLC AS T
     SET SUM_DAY=SUM_DAY - PG_DAY,
    HZ_DAY = greatest(SUM_DAY - PG_DAY - KP_DAY - SRTHS_DAY - FH_DAY - SH_DAY - SL_DAY,0)
     WHERE SL_DATE > date_slrq AND KP_DATE>STR_TO_DATE('1900-01-01', '%Y-%m-%d');
  COMMIT;

  DO '同步成功';
  LEAVE routine_body;

  END$$

DELIMITER ;

-- END SOURCE: P_TJ_JXKH_YWLC.sql

-- ======================================================================
-- [112/114] BEGIN SOURCE: P_TJ_JXKH_YWLC_2020.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS P_TJ_JXKH_YWLC_2020$$

CREATE procedure P_TJ_JXKH_YWLC_2020()
routine_body: BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';
  DECLARE v_msgtext VARCHAR(4000);


  DECLARE date_tjrq DATETIME;
  DECLARE date_slrq DATETIME;

  -- 5日前不统计
  -- if extract(day from date_tjrq) < 5 then
  --  return;
  -- end if;
  -- DELETE FROM JXKH_YWLC WHERE TO_CHAR(SL_DATE,'YYYY') = av_ssnd;
  -- COMMIT;

  -- 核准日期日,固定年初

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
    SET v_msgtext = BJTS_SQLERRM_001;
    rollback;
    DO ORA_CONCAT('Error: ', v_msgtext);
    -- EXIT HANDLER exits routine_body after preserving the result.

  END;
SET date_slrq = STR_TO_DATE('2020-01-01', '%Y-%m-%d');

  UPDATE JXKH_YWLC AS T
     SET NSRDZDAH = (SELECT NSRDZDAH
FROM GS_DJ_CKTMSDAB S WHERE S.CPCODE=T.CPCODE AND 1=1
LIMIT 1),
    QYHGDM = (SELECT QYHGDM
FROM GS_DJ_CKTMSDAB S WHERE S.CPCODE=T.CPCODE AND 1=1
LIMIT 1),
    NSRSBH = (SELECT NSRSBH
FROM GS_DJ_CKTMSDAB S WHERE S.CPCODE=T.CPCODE AND 1=1
LIMIT 1),
    NSRMC = (SELECT NSRMC
FROM GS_DJ_CKTMSDAB S WHERE S.CPCODE=T.CPCODE AND 1=1
LIMIT 1)
   WHERE SL_DATE > date_slrq and NSRDZDAH IS NULL;
  COMMIT;
  DO '完成名称设置';

  UPDATE JXKH_YWLC AS UU
JOIN (
select LCSLID, SBID, SBRQ
           from (select T.lcslid,
                        S.ID as SBID,
                        case when S.sbfs='0' then greatest(IFNULL(S.sbsj, S.sbrq),S.sbrq) else S.sbrq end as SBRQ,
                        ROW_NUMBER() OVER(partition by S.lcslid order by S.sbrq desc) as RN
                   FROM JXKH_YWLC T, SB_SBXX_HZ S
                  WHERE T.SL_DATE > date_slrq
                    and T.SBID IS NULL
                    and S.LCSLID = T.LCSLID) AS BJTS_DERIVED_001
          WHERE RN = 1
) AS ZZ
ON ZZ.lcslid = UU.LCSLID
SET SBID = ZZ.SBID, SBRQ = ZZ.SBRQ;
  COMMIT;

  DO '完成申报日期设置';

  -- 计算实际接单日期(实际申报日期)
  -- FLGLCD='D',WZHQY='0'，接单日期=MAX(受理日期,增值税日期)
  -- (免抵退)，接单日期=MAX(申报日期,增值税日期)
  -- (其他),   接单日期=申报日期
  UPDATE JXKH_YWLC AS T
     SET JD_DATE = CASE WHEN FLGLCD='D' OR WZHQY='0' THEN SL_DATE
                        WHEN FLGLCD<>'D' AND WZHQY<>'0' AND SBYWB_DM='A0305001' THEN least(greatest(IFNULL(SBRQ, SL_DATE),ZZS_DATE),SL_DATE)
                        ELSE least(IFNULL(SBRQ, SL_DATE),SL_DATE) END
    WHERE SL_DATE > date_slrq and JD_DATE=STR_TO_DATE('1900-01-01', '%Y-%m-%d');
  COMMIT;
  DO '完成实际接单日期设置';

  -- 参与计算表识 0 默认 1有评估 2退税额为0
/*  UPDATE JXKH_YWLC T
     SET JS_FLAG = '1'
     WHERE SL_DATE > date_slrq AND JS_FLAG = '0'
     AND NVL(PG_DATE,TO_DATE('1900-01-01','YYYY-MM-DD')) > TO_DATE('1900-01-02','YYYY-MM-DD');
  COMMIT;
*/
  UPDATE JXKH_YWLC AS T
     SET JS_FLAG = '2'
     WHERE SL_DATE > date_slrq AND JS_FLAG = '0' AND IFNULL(HZ_TSE, 0) = 0;
  COMMIT;
  UPDATE JXKH_YWLC AS T
     SET JS_FLAG = '0'
     WHERE SL_DATE > date_slrq AND JS_FLAG = '2' AND IFNULL(HZ_TSE, 0) <> 0;
  COMMIT;
  UPDATE JXKH_YWLC AS T
     SET JS_FLAG = '3'
     WHERE SL_DATE > date_slrq AND JS_FLAG = '0'
     AND IFNULL(KP_DATE, STR_TO_DATE('1900-01-01', '%Y-%m-%d')) = STR_TO_DATE('1900-01-01', '%Y-%m-%d');
  COMMIT;
  UPDATE JXKH_YWLC AS T
     SET JS_FLAG = '0'
     WHERE SL_DATE > date_slrq AND JS_FLAG = '3'
     AND IFNULL(KP_DATE, STR_TO_DATE('1900-01-01', '%Y-%m-%d')) > STR_TO_DATE('1900-01-02', '%Y-%m-%d');
  COMMIT;
  DO '完成参与计算表识统计';

  -- 退税退库日期没时间,默认统一设置成当天中午12点
  -- 合计周期=开票日期-接单日期
  UPDATE JXKH_YWLC AS T
     SET SUM_DAY = IFNULL(greatest(ORA_DATE_DIFF(KP_DATE, JD_DATE),0), 0),
    SL_DAY = greatest(ORA_DATE_DIFF(SL_DATE, JD_DATE),0),
    SH_DAY = CASE WHEN IFNULL(JS_DATE, STR_TO_DATE('1900-01-01', '%Y-%m-%d'))= STR_TO_DATE('1900-01-01', '%Y-%m-%d')
                  or JS_DATE>SRTHS_DATE
                  THEN 0 ELSE greatest(ORA_DATE_DIFF(JS_DATE, SL_DATE),0) END,
    PG_DAY = CASE WHEN IFNULL(PG_DATE, STR_TO_DATE('1900-01-01', '%Y-%m-%d'))= STR_TO_DATE('1900-01-01', '%Y-%m-%d')
                  or PG_DATE>SRTHS_DATE
                  THEN 0 ELSE greatest(ORA_DATE_DIFF(PG_DATE, JS_DATE),0) END,
    FH_DAY = CASE WHEN IFNULL(FH_DATE, STR_TO_DATE('1900-01-01', '%Y-%m-%d'))= STR_TO_DATE('1900-01-01', '%Y-%m-%d')
                  or FH_DATE>SRTHS_DATE
                  THEN 0 ELSE greatest(ORA_DATE_DIFF(FH_DATE, greatest(SL_DATE,JS_DATE,PG_DATE)),0) END,
    SRTHS_DAY = greatest(ORA_DATE_DIFF(SRTHS_DATE, HZ_DATE),0),
    KP_DAY = greatest(ORA_DATE_DIFF(KP_DATE, SRTHS_DATE),0),
    TK_DAY = greatest((ORA_DATE_ADD(TSTK_DATE, 0.5))-greatest(SRTHS_DATE,KP_DATE),0),
    SSYEAR = DATE_FORMAT(SL_DATE, '%Y'),
    TJ_DATE = CURRENT_TIMESTAMP
   WHERE SL_DATE > date_slrq AND KP_DATE>STR_TO_DATE('1900-01-01', '%Y-%m-%d');
  COMMIT;
  DO '完成天数统计';

  -- 未减非工作日
  BEGIN
  DECLARE BJTS_FETCH_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_RS_JJR_JJR_DATE_001 LONGTEXT;
  DECLARE BJTS_FETCH_CURSOR_001 CURSOR FOR
select JJR_DATE from PUB_JJR where jjr_ssnd =  (DATE_FORMAT(date_slrq, '%Y')) order by JJR_DATE;
  OPEN BJTS_FETCH_CURSOR_001;
  BJTS_FETCH_LOOP_001: LOOP
    BEGIN
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
        SET v_msgtext = BJTS_SQLERRM_002;
        rollback;
        DO ORA_CONCAT('Error: ', v_msgtext);

  END;
BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_FETCH_DONE_001 = TRUE;
      FETCH BJTS_FETCH_CURSOR_001 INTO BJTS_RS_JJR_JJR_DATE_001;
    END;
    IF BJTS_FETCH_DONE_001 THEN
      LEAVE BJTS_FETCH_LOOP_001;
    END IF;

      SET date_tjrq = BJTS_RS_JJR_JJR_DATE_001;
      DO ORA_CONCAT('假日:', DATE_FORMAT(date_tjrq, '%Y-%m-%d'));

      UPDATE JXKH_YWLC AS T
         SET SUM_DAY = SUM_DAY - 1
         WHERE SL_DATE >= date_slrq and SUM_DAY >= 1 AND (date_tjrq < KP_DATE AND date_tjrq > JD_DATE);
      UPDATE JXKH_YWLC AS T
         SET SL_DAY = SL_DAY - 1
         WHERE SL_DATE >= date_slrq and SL_DAY >= 1 AND (date_tjrq < SL_DATE AND date_tjrq > JD_DATE);
      UPDATE JXKH_YWLC AS T
         SET SH_DAY = SH_DAY - 1
         WHERE SL_DATE >= date_slrq and SH_DAY >= 1 AND (date_tjrq < JS_DATE AND date_tjrq > SL_DATE);
      UPDATE JXKH_YWLC AS T
         SET PG_DAY = PG_DAY - 1
         WHERE SL_DATE >= date_slrq and PG_DAY >= 1 AND (date_tjrq < PG_DATE AND date_tjrq > JS_DATE);
      UPDATE JXKH_YWLC AS T
         SET FH_DAY = FH_DAY - 1
         WHERE SL_DATE >= date_slrq and FH_DAY >= 1 AND (date_tjrq < FH_DATE AND date_tjrq > greatest(JS_DATE,PG_DATE));
      UPDATE JXKH_YWLC AS T
         SET SRTHS_DAY = SRTHS_DAY - 1
         WHERE SL_DATE >= date_slrq and SRTHS_DAY >= 1 AND (date_tjrq < SRTHS_DATE AND date_tjrq > HZ_DATE);
      UPDATE JXKH_YWLC AS T
         SET KP_DAY = KP_DAY - 1
         WHERE SL_DATE >= date_slrq and KP_DAY >= 1 AND (date_tjrq < KP_DATE AND date_tjrq > SRTHS_DATE);
      UPDATE JXKH_YWLC AS T
         SET TK_DAY = TK_DAY - 1
         WHERE SL_DATE >= date_slrq and TK_DAY >= 1 AND (date_tjrq < TSTK_DATE AND date_tjrq > KP_DATE);

      COMMIT;

      END;

  END LOOP BJTS_FETCH_LOOP_001;
  CLOSE BJTS_FETCH_CURSOR_001;
END;
  DO '完成节假日扣除';

  -- 最后计算核准周期
  UPDATE JXKH_YWLC AS T
     SET SUM_DAY=SUM_DAY - PG_DAY,
    HZ_DAY = greatest(SUM_DAY - PG_DAY - KP_DAY - SRTHS_DAY - FH_DAY - SH_DAY - SL_DAY,0)
     WHERE SL_DATE > date_slrq AND KP_DATE>STR_TO_DATE('1900-01-01', '%Y-%m-%d');
  COMMIT;

  DO '同步成功';
  LEAVE routine_body;

  END$$

DELIMITER ;

-- END SOURCE: P_TJ_JXKH_YWLC_2020.sql

-- ======================================================================
-- [113/114] BEGIN SOURCE: P_TJ_JXKH_YWLC_JS.sql
-- ======================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS P_TJ_JXKH_YWLC_JS$$

CREATE procedure P_TJ_JXKH_YWLC_JS()
routine_body: BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';
  DECLARE v_msgtext VARCHAR(4000);


  DECLARE date_tjrq DATETIME;
  DECLARE date_begin DATETIME;

  -- 每月5号之前，从上月1号开始取，每月5号以后，从本月1号开始取

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
    SET v_msgtext = BJTS_SQLERRM_001;
    rollback;
    DO ORA_CONCAT('Error: ', v_msgtext);
    -- EXIT HANDLER exits routine_body after preserving the result.

  END;
if extract(day from CURRENT_TIMESTAMP) <= 5 then
    SET date_begin = DATE_ADD(CAST(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y-%m-01') AS DATETIME), INTERVAL -1 MONTH);
  else
    SET date_begin = CAST(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y-%m-01') AS DATETIME);
  end if;

  delete from JXKH_YWLC_JS AS t;
  commit;

  insert into JXKH_YWLC_JS
  select t.lcslid_sb,t.tsswjg_dm,p.cpcode,t.ckqygllb_dm,substr(t.ssq,1,4),p.nsrdzdah,p.qyhgdm,p.nsrsbh,p.nsrmc,t.sbywb_dm,t.ssq,t.sbpc,0,
         least(t.sbrq,s.qdsj),case when s.lcslid=s.lcslid_sb then s.qdsj else least(t.sbrq,s.qdsj) end,case when s.lcslid=s.lcslid_sb then s.qdsj else least(t.sbrq,s.qdsj) end,
         case when s.lcslid=s.lcslid_sb then CAST('1900-01-01' AS DATE) else s.qdsj end,r.fsrq,q.sehzrq,q.sehzrq,least(q.xhrq_tk,q.xhrq_md),q.xhrq_tk,q.xhrq_md,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,
         s.sb_zzstse+s.sb_xfstse,s.sb_mdse,s.zh_mdtse,s.by_mdtse,q.sehz_zzstse+q.sehz_xfstse,q.sehz_mdse,q.gkbl_zzstse+q.gkbl_xfstse,q.gkbl_mdse,
         null,null,null,null,null,null,null,null,0,'system',s.sb_xsermb,s.sb_xsemy,s.wzhbz,least(t.sbrq,s.qdsj),least(t.sbrq,s.qdsj),null,null
  from CKTS_LC_SBXX t
  inner join CKTS_LC_SHXX s on s.lcslid_sb=t.lcslid_sb
  left join CKTS_LC_YWHZXX r on r.lcslid_fs=s.lcslid_fs
  left join CKTS_LC_SEHZXX q on q.ywhzbuuid=r.ywhzbuuid
  inner join GS_DJ_CKTMSDAB p on p.cpcode=CAST(t.djxh AS CHAR)
  where t.sbrq>=date_begin;
  commit;

  update JXKH_YWLC_JS AS t set fh_date=CAST('1900-01-01' AS DATE) where t.fh_date=CAST('2100-12-31' AS DATE);
  update JXKH_YWLC_JS AS t set hz_date=CAST('1900-01-01' AS DATE) where t.hz_date=CAST('2100-12-31' AS DATE);
  update JXKH_YWLC_JS AS t set srths_date=CAST('1900-01-01' AS DATE) where t.srths_date=CAST('2100-12-31' AS DATE);
  update JXKH_YWLC_JS AS t set kp_date=CAST('1900-01-01' AS DATE) where t.kp_date=CAST('2100-12-31' AS DATE);
  update JXKH_YWLC_JS AS t set tstk_date=CAST('1900-01-01' AS DATE) where t.tstk_date=CAST('2100-12-31' AS DATE);
  update JXKH_YWLC_JS AS t set mdtk_date=CAST('1900-01-01' AS DATE) where t.mdtk_date=CAST('2100-12-31' AS DATE);
  commit;
  DO '完成数据插入';

  UPDATE JXKH_YWLC_JS AS T
     SET JS_FLAG = '2'
     WHERE JS_FLAG = '0' AND IFNULL(HZ_TSE, 0) = 0;
  COMMIT;
  UPDATE JXKH_YWLC_JS AS T
     SET JS_FLAG = '0'
     WHERE JS_FLAG = '2' AND IFNULL(HZ_TSE, 0) <> 0;
  COMMIT;
  UPDATE JXKH_YWLC_JS AS T
     SET JS_FLAG = '3'
     WHERE JS_FLAG = '0' AND IFNULL(KP_DATE, STR_TO_DATE('1900-01-01', '%Y-%m-%d')) = STR_TO_DATE('1900-01-01', '%Y-%m-%d');
  COMMIT;
  UPDATE JXKH_YWLC_JS AS T
     SET JS_FLAG = '0'
     WHERE JS_FLAG = '3' AND IFNULL(KP_DATE, STR_TO_DATE('1900-01-01', '%Y-%m-%d')) > STR_TO_DATE('1900-01-02', '%Y-%m-%d');
  COMMIT;
  DO '完成参与计算表识统计';

  -- 退税退库日期没时间,默认统一设置成当天中午12点
  -- 合计周期=开票日期-接单日期
  UPDATE JXKH_YWLC_JS AS T
     SET SUM_DAY = IFNULL(greatest(ORA_DATE_DIFF(GREATEST(KP_DATE,SRTHS_DATE), JD_DATE),0), 0),
    SL_DAY = greatest(ORA_DATE_DIFF(SL_DATE, JD_DATE),0),
    SH_DAY = CASE WHEN IFNULL(JS_DATE, STR_TO_DATE('1900-01-01', '%Y-%m-%d'))= STR_TO_DATE('1900-01-01', '%Y-%m-%d')
                  or JS_DATE>SRTHS_DATE
                  THEN 0 ELSE greatest(ORA_DATE_DIFF(JS_DATE, SL_DATE),0) END,
    PG_DAY = CASE WHEN IFNULL(PG_DATE, STR_TO_DATE('1900-01-01', '%Y-%m-%d'))= STR_TO_DATE('1900-01-01', '%Y-%m-%d')
                  or PG_DATE>SRTHS_DATE
                  THEN 0 ELSE greatest(ORA_DATE_DIFF(PG_DATE, JS_DATE),0) END,
    FH_DAY = CASE WHEN IFNULL(FH_DATE, STR_TO_DATE('1900-01-01', '%Y-%m-%d'))= STR_TO_DATE('1900-01-01', '%Y-%m-%d')
                  or FH_DATE>SRTHS_DATE
                  THEN 0 ELSE greatest(ORA_DATE_DIFF(FH_DATE, greatest(SL_DATE,JS_DATE,PG_DATE)),0) END,
    SRTHS_DAY = greatest(ORA_DATE_DIFF(SRTHS_DATE, HZ_DATE),0),
    KP_DAY = greatest(ORA_DATE_DIFF(KP_DATE, SRTHS_DATE),0),
    TK_DAY = greatest((ORA_DATE_ADD(TSTK_DATE, 0.5))-greatest(SRTHS_DATE,KP_DATE),0),
    SSYEAR = DATE_FORMAT(SL_DATE, '%Y'),
    TJ_DATE = CURRENT_TIMESTAMP
   WHERE KP_DATE>STR_TO_DATE('1900-01-01', '%Y-%m-%d');
  COMMIT;
  DO '完成天数统计';

  -- 未减非工作日
  BEGIN
  DECLARE BJTS_FETCH_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_RS_JJR_JJR_DATE_001 LONGTEXT;
  DECLARE BJTS_FETCH_CURSOR_001 CURSOR FOR
select JJR_DATE from PUB_JJR where jjr_ssnd =  (DATE_FORMAT(date_begin, '%Y')) order by JJR_DATE;
  OPEN BJTS_FETCH_CURSOR_001;
  BJTS_FETCH_LOOP_001: LOOP
    BEGIN
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
        SET v_msgtext = BJTS_SQLERRM_002;
        rollback;
        DO ORA_CONCAT('Error: ', v_msgtext);

  END;
BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_FETCH_DONE_001 = TRUE;
      FETCH BJTS_FETCH_CURSOR_001 INTO BJTS_RS_JJR_JJR_DATE_001;
    END;
    IF BJTS_FETCH_DONE_001 THEN
      LEAVE BJTS_FETCH_LOOP_001;
    END IF;

      SET date_tjrq = BJTS_RS_JJR_JJR_DATE_001;
      DO ORA_CONCAT('假日:', DATE_FORMAT(date_tjrq, '%Y-%m-%d'));

      UPDATE JXKH_YWLC_JS AS T
         SET SUM_DAY = SUM_DAY - 1
         WHERE  SUM_DAY >= 1 AND (date_tjrq < KP_DATE AND date_tjrq > JD_DATE);
      UPDATE JXKH_YWLC_JS AS T
         SET SL_DAY = SL_DAY - 1
         WHERE  SL_DAY >= 1 AND (date_tjrq < SL_DATE AND date_tjrq > JD_DATE);
      UPDATE JXKH_YWLC_JS AS T
         SET SH_DAY = SH_DAY - 1
         WHERE  SH_DAY >= 1 AND (date_tjrq < JS_DATE AND date_tjrq > SL_DATE);
      UPDATE JXKH_YWLC_JS AS T
         SET PG_DAY = PG_DAY - 1
         WHERE  PG_DAY >= 1 AND (date_tjrq < PG_DATE AND date_tjrq > JS_DATE);
      UPDATE JXKH_YWLC_JS AS T
         SET FH_DAY = FH_DAY - 1
         WHERE  FH_DAY >= 1 AND (date_tjrq < FH_DATE AND date_tjrq > greatest(JS_DATE,PG_DATE));
      UPDATE JXKH_YWLC_JS AS T
         SET SRTHS_DAY = SRTHS_DAY - 1
         WHERE  SRTHS_DAY >= 1 AND (date_tjrq < SRTHS_DATE AND date_tjrq > HZ_DATE);
      UPDATE JXKH_YWLC_JS AS T
         SET KP_DAY = KP_DAY - 1
         WHERE  KP_DAY >= 1 AND (date_tjrq < KP_DATE AND date_tjrq > SRTHS_DATE);
      UPDATE JXKH_YWLC_JS AS T
         SET TK_DAY = TK_DAY - 1
         WHERE  TK_DAY >= 1 AND (date_tjrq < TSTK_DATE AND date_tjrq > KP_DATE);

      COMMIT;

      END;

  END LOOP BJTS_FETCH_LOOP_001;
  CLOSE BJTS_FETCH_CURSOR_001;
END;
  DO '完成节假日扣除';

  -- 最后计算核准周期
  UPDATE JXKH_YWLC_JS AS T
     SET SUM_DAY=SUM_DAY - PG_DAY,
    HZ_DAY = greatest(SUM_DAY - PG_DAY - KP_DAY - SRTHS_DAY - FH_DAY - SH_DAY - SL_DAY,0)
     WHERE KP_DATE>STR_TO_DATE('1900-01-01', '%Y-%m-%d');
  COMMIT;

  DO '同步成功';
  LEAVE routine_body;

  END$$

DELIMITER ;

-- END SOURCE: P_TJ_JXKH_YWLC_JS.sql

-- ======================================================================
-- [114/114] BEGIN SOURCE: TEMP_DATA_INIT.sql
-- ======================================================================
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
       from SB_SBXX_HZ t,GS_DJ_CKTMSDAB dj
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

-- END SOURCE: TEMP_DATA_INIT.sql
