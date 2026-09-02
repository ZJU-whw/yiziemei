create or replace function func_get_sbhzxx_tsswjg(p_czryDm varchar2)
return type_tb_sbhzxx
is
  TYPE Type_Cursor IS REF CURSOR;
  my_cursor Type_Cursor;
  o_tb type_tb_sbhzxx := type_tb_sbhzxx();
  dyn_select varchar2(1500);
  i number := 0;
  v_ywzldm varchar2(20);
  v_ywzlmc varchar2(50);
  v_sbywdm varchar2(20);
  v_sbywmc varchar2(50);
  v_cnt number(8);

begin
  dyn_select:='select '
      ||'sd1.dcode as ywzldm,sd1.dname as ywzlmc,TT.sbywdm,TT.sbywmc,nvl(cnt,0) as cnt '
      ||'from SYS_DICT sd1 '
      ||'left join   '
      ||'(select sbzl_dm,sbywb_dm as sbywdm,sd2.dname as sbywmc,count(*) as cnt  '
      ||'from v_sbxx_sbdr_filemode vs '
      ||'inner join dm_czry dc on dc.czry_dm='''|| p_czryDm || ''' and vs.swjg_dm =dc.swjg_dm '
      ||'left join SYS_DICT sd2 on sd2.dtype=''ywlx_dm'' and sd2.dcode=vs.sbywb_dm '
      ||'where '
      ||'( '
      || ' (vs.sbr is not null and vs.sbr=''' || p_czryDm || ''') or '
      || ' (vs.sbr is null and ( '
      ||'not exists (select 1 from sys_cfg_czry_fpgl sc1 '
      ||'where sc1.czry_dm=dc.czry_dm and sc1.swjg_dm=dc.swjg_dm and sc1.qybz=''Y'') or '
      ||'exists (select 1 from sys_cfg_czry_fpgl sc2 '
      ||'where sc2.czry_dm=dc.czry_dm and sc2.swjg_dm=dc.swjg_dm and sc2.qybz=''Y'' '
      ||'and (coalesce(sc2.zsjg_dm_set,'' '')='' '' or vs.zs_swjg_dm is null or sc2.zsjg_dm_set like ''%'' || vs.zs_swjg_dm || ''%'') '
      ||'and (coalesce(sc2.zgswry_dm_set,'' '')='' '') '
      ||'and (coalesce(sc2.flgl_set,'' '')='' '' or sc2.flgl_set like ''%'' || vs.flglcd || ''%'') '
      ||'and (coalesce(sc2.jsmode_set,'' '')='' '' or sc2.jsmode_set like ''%'' || vs.tsjsfs_dm || ''%'')))) '
      ||') '
      ||'group by sbzl_dm,sbywb_dm,sd2.dname '
      ||') TT on sd1.dtype=''ywzl_dm'' and sd1.dcode=TT.sbzl_dm '
      ||'where sd1.dtype=''ywzl_dm'' '
      ||'order by ywzldm,sbywdm';

  OPEN my_cursor FOR dyn_select;
  LOOP
    FETCH my_cursor INTO v_ywzldm,v_ywzlmc,v_sbywdm,v_sbywmc,v_cnt;
    EXIT WHEN my_cursor%NOTFOUND;
    o_tb.extend;
    i := i + 1;
    o_tb(i) := type_rec_sbhzxx(v_ywzldm,v_ywzlmc,v_sbywdm,v_sbywmc,v_cnt);
  END LOOP;
  CLOSE my_cursor;

  return o_tb;
end func_get_sbhzxx_tsswjg;
/
