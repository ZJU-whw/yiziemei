create or replace function func_get_wjdr_count(p_czryDm varchar2)
return integer
is
  dyn_select varchar2(1500);
  v_czry_qxswjg varchar2(11);
  v_czry_swjg varchar2(11);
  v_cnt number(8);

begin
  begin
    select nvl(qx_swjg,swjg_dm) into v_czry_swjg
      from dm_czry where czry_dm =p_czryDm;
  EXCEPTION
  WHEN no_data_found THEN
       --DBMS_OUTPUT.put_line('操作员不存在');
       return 0;
  end;
  v_czry_qxswjg:=func_get_qxswjg(v_czry_swjg) ;

  dyn_select:='select count(1) from v_sbxx_sbdr_filemode vs '
  ||' where vs.swjg_dm like '''||v_czry_qxswjg||''' and vs.sbr is null and ( '
  ||' (vs.zs_swjg_dm is not null and  '
  ||' not exists (select 1 from sys_cfg_czry_fpgl sc1 '
  ||' where sc1.swjg_dm like ''%''||vs.swjg_dm||''%'' and sc1.qybz=''Y'' '
  ||' and (coalesce(sc1.zsjg_dm_set,'' '')='' '' or sc1.zsjg_dm_set like ''%'' || vs.zs_swjg_dm || ''%'') '
  ||' and (coalesce(sc1.flgl_set,'' '')='' '' or sc1.flgl_set like ''%'' || vs.flglcd || ''%'') '
  ||' and (vs.sbzl_dm<>''TSSB'' OR (coalesce(sc1.jsmode_set,'' '')='' '' or sc1.jsmode_set like ''%'' || vs.tsjsfs_dm || ''%''))) '
  ||' ) or '
  ||' (vs.zs_swjg_dm is null and  '
  ||' not exists (select 1 from sys_cfg_czry_fpgl sc2 '
  ||' where sc2.swjg_dm like ''%''||vs.swjg_dm||''%'' and sc2.qybz=''Y'' '
  ||' and (coalesce(sc2.zsjg_dm_set,'' '')='' '') '
  ||' and (coalesce(sc2.flgl_set,'' '')='' '' or sc2.flgl_set like ''%'' || vs.flglcd || ''%'') '
  ||' and (vs.sbzl_dm<>''TSSB'' OR (coalesce(sc2.jsmode_set,'' '')='' '' or sc2.jsmode_set like ''%'' || vs.tsjsfs_dm || ''%''))) '
  ||' ))';

  execute immediate dyn_select into v_cnt;

  return v_cnt;
end func_get_wjdr_count;
/
