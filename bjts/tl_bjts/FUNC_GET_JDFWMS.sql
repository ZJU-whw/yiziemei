create or replace function Func_Get_Jdfwms(pv_czry_dm varchar2) return varchar2 is
--函数：操作员的接单范围描述
  v_Result varchar2(1000);
  v_swjgSet varchar2(200);
  v_zsjgSet varchar2(500);
  v_flglSet varchar2(20);
  v_jsModeSet varchar2(20);
  v_val varchar2(20);
  v_TmpStr varchar2(2000);
  v_TmpVal varchar2(100);
  v_JDMode Char(1);
  v_ISJDR char(1);
--  i integer;
  CURSOR p_cur(param in VARCHAR2,pfgf in VARCHAR2) IS select * from table(Func_StrSplit(param,pfgf));
  rs_cur p_cur%ROWTYPE;
begin
  
  begin
     select swjg_dm
     into v_swjgSet
     from dm_czry
     where czry_dm=pv_czry_dm;
  exception
  WHEN no_data_found THEN
     return '未获取操作员的税务机关';
  end;
    
  v_Result:='';

  --处理退税机关集合
  if v_swjgSet is not null then
    v_TmpStr:='';
    OPEN p_cur(v_swjgSet,',');
    LOOP
      FETCH p_cur INTO rs_cur;
      EXIT WHEN p_cur%NOTFOUND;
      v_val := rs_cur.column_value;
      begin
        select swjg_jc into v_TmpVal from dm_swjg where swjg_dm=v_val;
      EXCEPTION
      WHEN no_data_found THEN
        v_TmpVal:=v_val;
      end;
      if v_TmpStr is null then
        v_TmpStr:=v_TmpVal;
      else
        v_TmpStr:=v_TmpStr||','||v_TmpVal;
      end if;
    END LOOP;
    CLOSE p_cur;
    v_Result:=v_Result||' 退税机关【'||v_TmpStr||'】';
  else
    v_Result:=v_Result||' 退税机关【全部】';
  end if;

  begin
     select zsjg_dm_set,flgl_set,jsmode_set
     into v_zsjgSet,v_flglSet,v_jsModeSet
     from sys_cfg_czry_fpgl
     where czry_dm=pv_czry_dm and qybz='Y';
     
     v_ISJDR:='1';

  EXCEPTION
  WHEN no_data_found THEN
     --DBMS_OUTPUT.put_line('操作员未设定为接单人');
     v_Result := v_Result||' 操作员未设定为受理岗接单人';
     v_ISJDR:='0';
  end;

  if v_ISJDR ='1' then
    --处理接单方式
      begin
        select jd_mode into v_JDMode from sys_cfg_sbdr_filemode where code=v_zsjgSet and qybz='Y';
        if v_JDMode = '1' then
            v_Result:=v_Result||' 接单方式【随机分配】';
        else
            v_Result:=v_Result||' 接单方式【分组接单】';
        end if;    
      EXCEPTION
      WHEN no_data_found THEN
            v_Result:=v_Result||' 接单方式【未设置】';
      end;
    
    --处理征收分组集合
    if v_zsjgSet is not null then
      v_TmpStr:='';
      OPEN p_cur(v_zsjgSet,',');
      LOOP
        FETCH p_cur INTO rs_cur;
        EXIT WHEN p_cur%NOTFOUND;
        v_val := rs_cur.column_value;
        begin
          select swjg_jc into v_TmpVal from dm_swjg where swjg_dm=v_val;
        EXCEPTION
        WHEN no_data_found THEN
          v_TmpVal:=v_val;
        end;
        if v_TmpStr is null then
          v_TmpStr:=v_TmpVal;
        else
          v_TmpStr:=v_TmpStr||','||v_TmpVal;
        end if;
      END LOOP;
      CLOSE p_cur;
      v_Result:=v_Result||' 分片分组【'||v_TmpStr||'】';
    else
      v_Result:=v_Result||' 分片分组【全部】';
    end if;

    --处理分类管理集合
    if v_flglSet is not null then
      v_TmpStr:='';
      OPEN p_cur(v_flglSet,'.');
      LOOP
        FETCH p_cur INTO rs_cur;
        EXIT WHEN p_cur%NOTFOUND;
        v_val := rs_cur.column_value;
        --DBMS_OUTPUT.put_line('flgl:' || v_val);
        Case
          when v_val='A' then
            v_TmpVal:='一类';
          when v_val='B' then
            v_TmpVal:='二类';
          when v_val='C' then
            v_TmpVal:='三类';
          when v_val='D' then
            v_TmpVal:='四类';
          else
            v_TmpVal:=v_val;
        End Case;
        if v_TmpStr is null then
          v_TmpStr:=v_TmpVal;
        else
          v_TmpStr:=v_TmpStr||','||v_TmpVal;
        end if;
      END LOOP;
      CLOSE p_cur;
      v_Result:=v_Result||' 分类管理【'||v_TmpStr||'】';
    else
      v_Result:=v_Result||' 分类管理【全部】';
    end if;
    --处理企业类型集合
    if v_jsModeSet is not null then
      v_TmpStr:='';
      OPEN p_cur(v_jsModeSet,'.');
      LOOP
        FETCH p_cur INTO rs_cur;
        EXIT WHEN p_cur%NOTFOUND;
        v_val := rs_cur.column_value;
        Case
          when v_val='1' then
            v_TmpVal:='生产';
          when v_val='2' then
            v_TmpVal:='外贸';
          else
            v_TmpVal:=v_val;
        End Case;
        if v_TmpStr is null then
          v_TmpStr:=v_TmpVal;
        else
          v_TmpStr:=v_TmpStr||','||v_TmpVal;
        end if;
      END LOOP;
      CLOSE p_cur;
      v_Result:=v_Result||' 企业类型【'||v_TmpStr||'】';
    else
      v_Result:=v_Result||' 企业类型【全部】';
    end if;
  
  end if;
  return(v_Result);
end Func_Get_Jdfwms;
/
