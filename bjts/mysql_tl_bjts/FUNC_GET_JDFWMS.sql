DELIMITER $$

DROP FUNCTION IF EXISTS FUNC_GET_JDFWMS$$

CREATE function Func_Get_Jdfwms(pv_czry_dm VARCHAR(4000))
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
     from dm_czry
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
select swjg_jc into v_TmpVal from dm_swjg where swjg_dm=v_val;
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
     from sys_cfg_czry_fpgl
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
select jd_mode into v_JDMode from sys_cfg_sbdr_filemode where code=v_zsjgSet and qybz='Y';
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
select swjg_jc into v_TmpVal from dm_swjg where swjg_dm=v_val;
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
