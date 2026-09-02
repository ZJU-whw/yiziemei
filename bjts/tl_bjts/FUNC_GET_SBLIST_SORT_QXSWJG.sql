create or replace function func_get_sblist_Sort_qxswjg(p_czryDm varchar2,p_sbywbDm varchar2,
       p_sort varchar2,p_offset number,p_rows number,p_filter varchar2)
return type_tb_sblist
is
  TYPE Type_Cursor IS REF CURSOR;
  my_cursor Type_Cursor;
  o_tb type_tb_sblist := type_tb_sblist();
  dyn_select varchar2(1500);
  sorting varchar2(200);
  startRow number;
  endRow number;
  i number := 0;
  v_filter varchar2(100);
  v_sbid number(18);
  v_sssq varchar2(10);
  v_sbpc number(9);
  v_sbrq date;
  v_qyhgdm varchar2(32);
  v_nsrmc varchar2(100);
  v_sbywbdm varchar2(20);
  v_flglcd varchar2(2);
  v_zzsbb char(1);
  v_swjg_jc varchar2(80);
  v_czry_qxswjg varchar2(11);
  v_czry_swjg varchar2(11);

begin
  --提取操作员的退税税务机关代码，并计算权限机关代码
  begin
    select swjg_dm into v_czry_swjg
      from dm_czry where czry_dm =p_czryDm;
  EXCEPTION
  WHEN no_data_found THEN
       DBMS_OUTPUT.put_line('操作员不存在');
       return o_tb;
  end;
  v_czry_qxswjg:=func_get_qxswjg(v_czry_swjg) ;

  if p_offset <= 0 then
    startRow :=1;
  else
    startRow :=p_offset;
  end if;
  if p_rows <= 0 then
    endRow :=100000000;
  else
    endRow :=startRow + p_rows -1;
  end if;
  if nvl(p_sort,' ') = ' ' then
     sorting:='sbrq asc';
  else
     sorting:=p_sort;
  end if;
  if (nvl(p_filter,' ') = ' ')  then
     v_filter:='';
  else
     v_filter:=' and ' || p_filter || ' ';
  end if;
  dyn_select:='select sbid,sssq,sbpc,sbrq,qyhgdm,nsrmc,sbywb_dm,flglcd,zzsbb,swjg_jc from '
      || '(select vs.sbid, vs.sssq, vs.sbpc, vs.sbrq, vs.qyhgdm, vs.nsrmc, vs.sbywb_dm,vs.flglcd,vs.zzsbb,vs.swjg_jc,'
      || '     row_number() over(ORDER BY ' ||  sorting ||  ') rn '
      || 'from v_sbxx_sbdr_filemode vs '
      || 'where vs.swjg_dm like ''' || v_czry_qxswjg || ''' and '
      || 'vs.sbywb_dm=''' || p_sbywbDm || ''' '
      || v_filter
      || 'and ( '
      || ' (vs.sbr is not null and vs.sbr=''' || p_czryDm || ''') or '
      || ' (vs.sbr is null and ( '
      || 'exists (select 1 from sys_cfg_czry_fpgl sc2 '
      || 'where sc2.czry_dm=''' || p_czryDm || ''' and sc2.swjg_dm like ''%'' || vs.swjg_dm || ''%'' and sc2.qybz=''Y'' '
      || 'and (coalesce(sc2.zsjg_dm_set,'' '')='' '' or vs.zs_swjg_dm is null or sc2.zsjg_dm_set like ''%'' || vs.zs_swjg_dm || ''%'') '
      || 'and (coalesce(sc2.zgswry_dm_set,'' '')='' '') '
      || 'and (coalesce(sc2.flgl_set,'' '')='' '' or sc2.flgl_set like ''%'' || vs.flglcd || ''%'') '
      || 'and (vs.sbzl_dm<>''TSSB'' OR (coalesce(sc2.jsmode_set,'' '')='' '' or sc2.jsmode_set like ''%'' || vs.tsjsfs_dm || ''%''))))) '
      || ')) TT where rn between ' || startRow || ' and ' || endRow || ' order by rn';


  OPEN my_cursor FOR dyn_select;
  LOOP
    FETCH my_cursor INTO v_sbid,v_sssq,v_sbpc,v_sbrq,v_qyhgdm,v_nsrmc,v_sbywbdm,v_flglcd,v_zzsbb,v_swjg_jc;
    EXIT WHEN my_cursor%NOTFOUND;
    o_tb.extend;
    i := i + 1;
    o_tb(i) := type_rec_sblist (v_sbid,
            case when v_sbywbdm='A0301001' then v_sssq || to_char(v_sbpc,'00') else v_sssq end,
            v_sbrq, v_qyhgdm,v_nsrmc,v_sbywbdm,v_flglcd,v_zzsbb,v_swjg_jc,'','','',0,0,0,0);
  END LOOP;
  CLOSE my_cursor;

  return o_tb;
end func_get_sblist_Sort_qxswjg;
/
