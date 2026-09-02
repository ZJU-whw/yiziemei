create or replace function func_get_random_sbr(p_sbid number)
return varchar2
--随机接单人分配
is
  dyn_select varchar2(1500);
  v_ywlx varchar2(10);
  v_sbr varchar2(20);
  v_sbywbDm varchar2(20);
  v_swjgDm varchar2(11);
  v_tsjsfs_dm char(1);
  v_flglcd char(1);
  v_zs_swjg_dm varchar2(11);
  v_sjfd integer;
begin
  v_sbr:='';
  dyn_select:='select sb.sbywb_dm,dj.swjg_dm,dj.zs_swjg_dm,dj.tsjsfs_dm,sb.sbr,nvl(kz.kzxx,''C'') as flglcd '
  || ' from gs_dj_cktmsdab dj '
  || ' left join gs_dj_cktmsdab_kz kz on kz.nsrdzdah=dj.nsrdzdah '
  || ' and kzlx=''FLGLCD'' and sysdate between st_date and end_date and flag=''1'' '
  || ' ,sb_sbxx_hz sb '
  || ' where sb.id=' || to_char(p_sbid) || ' and sb.nsrdzdah=dj.nsrdzdah  and rownum=1';
  --DBMS_OUTPUT.put_line(dyn_select);
  execute immediate dyn_select into v_sbywbDm,v_swjgDm,v_zs_swjg_dm,v_tsjsfs_dm,v_sbr,v_flglcd;
  
  --判断税务机关是否启用随机分单
  dyn_select:='select count(1) from sys_cfg_sbdr_filemode '
  || ' where codetype=''GS'' and code=''' || v_swjgDm || ''' and jd_mode=''1''';
  --DBMS_OUTPUT.put_line(dyn_select);
  execute immediate dyn_select into v_sjfd;
  if v_sjfd = 0 then
    --DBMS_OUTPUT.put_line('未启用随机分单');
    return '000';
  end if;
  
  if coalesce(v_sbr,' ')<>' ' then
    --DBMS_OUTPUT.put_line('已有接单人'||v_sbr);
    return '001';
  end if;
  if v_sbywbDm='A0305001' then
    v_ywlx:='_sc';
  else if v_sbywbDm='A0301001' or v_sbywbDm='A0304001' then
    v_ywlx:='_wm';
  else
    v_ywlx:='_qt';
  end if;
  end if;
  dyn_select:='select czry_dm from ('
  || 'select czry_dm,row_number() OVER(order by nvl(cnt_sc,0)+nvl(cnt_wm,0)+nvl(cnt_qt,0)) as RN'
  || ' from SYS_CFG_CZRY_FPGL t1'
  || ' where t1.swjg_dm like ''%' || v_swjgDm || '%'''
  || ' and (limit' || v_ywlx || ' is null or nvl(cnt' || v_ywlx || ',0)<limit' || v_ywlx || ')'
  || ' and (coalesce(t1.zsjg_dm_set,'' '')='' '' or ''' || v_zs_swjg_dm || ''' is null or t1.zsjg_dm_set like ''%' || v_zs_swjg_dm || '%'') '
  || ' and (coalesce(t1.zgswry_dm_set,'' '')='' '') '
  || ' and (coalesce(t1.flgl_set,'' '')='' '' or t1.flgl_set like ''%' || v_flglcd || '%'') '
  || ' and (coalesce(t1.jsmode_set,'' '')='' '' or t1.jsmode_set like ''%' || v_tsjsfs_dm || '%'') '
  || ' and qybz=''Y'') TT where TT.RN=1';
  
  --DBMS_OUTPUT.put_line(dyn_select);
  execute immediate dyn_select into v_sbr;

  update sb_sbxx_hz set sbr=v_sbr where id=p_sbid;
  dyn_select:='update SYS_CFG_CZRY_FPGL set cnt' || v_ywlx || '= nvl(cnt' || v_ywlx || ',0) + 1'
  || ' where czry_dm=''' || v_sbr || '''';
  --DBMS_OUTPUT.put_line(dyn_select);
  execute immediate dyn_select;
  commit;
  
  --DBMS_OUTPUT.put_line('sbr='||v_sbr);
  return '000';
  
  Exception
  when no_data_found then
    --DBMS_OUTPUT.put_line('检索为空：'||sqlerrm);
    rollback;
    return '100';
  when others then
    rollback;
    --DBMS_OUTPUT.put_line('异常：'||sqlerrm);
    return '900';
          
end func_get_random_sbr;
/
