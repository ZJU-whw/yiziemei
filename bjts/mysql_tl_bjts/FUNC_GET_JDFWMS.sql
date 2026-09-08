DELIMITER $$

DROP FUNCTION IF EXISTS FUNC_GET_JDFWMS$$

CREATE function Func_Get_Jdfwms(pv_czry_dm VARCHAR(4000))
RETURNS VARCHAR(4000)
NOT DETERMINISTIC
READS SQL DATA
BEGIN
--函数：操作员的接单范围描述
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
  DECLARE p_cur(param in VARCHAR(4000),pfgf in VARCHAR(4000)) CURSOR FOR select * from table(Func_StrSplit(param,pfgf));
  DECLARE rs_cur p_cur%ROWTYPE;

  
  begin
     select swjg_dm
     into v_swjgSet
     from dm_czry
     where czry_dm=pv_czry_dm;
  exception
  WHEN no_data_found THEN
     return '未获取操作员的税务机关';
  end;
    
  SET v_Result ='';

  --处理退税机关集合
  if v_swjgSet is not null then
    SET v_TmpStr ='';
    OPEN p_cur(v_swjgSet,',');
    LOOP
      FETCH p_cur INTO rs_cur;
      EXIT WHEN p_cur%NOTFOUND;
      SET v_val = rs_cur.column_value;
      begin
        select swjg_jc into v_TmpVal from dm_swjg where swjg_dm=v_val;
      EXCEPTION
      WHEN no_data_found THEN
        SET v_TmpVal =v_val;
      end;
      if v_TmpStr is null then
        SET v_TmpStr =v_TmpVal;
      else
        SET v_TmpStr =v_TmpStr||','||v_TmpVal;
      end if;
    END LOOP;
    CLOSE p_cur;
    SET v_Result =v_Result||' 退税机关【'||v_TmpStr||'】';
  else
    SET v_Result =v_Result||' 退税机关【全部】';
  end if;

  begin
     select zsjg_dm_set,flgl_set,jsmode_set
     into v_zsjgSet,v_flglSet,v_jsModeSet
     from sys_cfg_czry_fpgl
     where czry_dm=pv_czry_dm and qybz='Y';
     
     SET v_ISJDR ='1';

  EXCEPTION
  WHEN no_data_found THEN
     --DBMS_OUTPUT.put_line('操作员未设定为接单人');
     SET v_Result = v_Result||' 操作员未设定为受理岗接单人';
     SET v_ISJDR ='0';
  end;

  if v_ISJDR ='1' then
    --处理接单方式
      begin
        select jd_mode into v_JDMode from sys_cfg_sbdr_filemode where code=v_zsjgSet and qybz='Y';
        if v_JDMode = '1' then
            SET v_Result =v_Result||' 接单方式【随机分配】';
        else
            SET v_Result =v_Result||' 接单方式【分组接单】';
        end if;    
      EXCEPTION
      WHEN no_data_found THEN
            SET v_Result =v_Result||' 接单方式【未设置】';
      end;
    
    --处理征收分组集合
    if v_zsjgSet is not null then
      SET v_TmpStr ='';
      OPEN p_cur(v_zsjgSet,',');
      LOOP
        FETCH p_cur INTO rs_cur;
        EXIT WHEN p_cur%NOTFOUND;
        SET v_val = rs_cur.column_value;
        begin
          select swjg_jc into v_TmpVal from dm_swjg where swjg_dm=v_val;
        EXCEPTION
        WHEN no_data_found THEN
          SET v_TmpVal =v_val;
        end;
        if v_TmpStr is null then
          SET v_TmpStr =v_TmpVal;
        else
          SET v_TmpStr =v_TmpStr||','||v_TmpVal;
        end if;
      END LOOP;
      CLOSE p_cur;
      SET v_Result =v_Result||' 分片分组【'||v_TmpStr||'】';
    else
      SET v_Result =v_Result||' 分片分组【全部】';
    end if;

    --处理分类管理集合
    if v_flglSet is not null then
      SET v_TmpStr ='';
      OPEN p_cur(v_flglSet,'.');
      LOOP
        FETCH p_cur INTO rs_cur;
        EXIT WHEN p_cur%NOTFOUND;
        SET v_val = rs_cur.column_value;
        --DBMS_OUTPUT.put_line('flgl:' || v_val);
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
          SET v_TmpStr =v_TmpStr||','||v_TmpVal;
        end if;
      END LOOP;
      CLOSE p_cur;
      SET v_Result =v_Result||' 分类管理【'||v_TmpStr||'】';
    else
      SET v_Result =v_Result||' 分类管理【全部】';
    end if;
    --处理企业类型集合
    if v_jsModeSet is not null then
      SET v_TmpStr ='';
      OPEN p_cur(v_jsModeSet,'.');
      LOOP
        FETCH p_cur INTO rs_cur;
        EXIT WHEN p_cur%NOTFOUND;
        SET v_val = rs_cur.column_value;
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
          SET v_TmpStr =v_TmpStr||','||v_TmpVal;
        end if;
      END LOOP;
      CLOSE p_cur;
      SET v_Result =v_Result||' 企业类型【'||v_TmpStr||'】';
    else
      SET v_Result =v_Result||' 企业类型【全部】';
    end if;
  
  end if;
  return(v_Result);
END$$

DELIMITER ;
