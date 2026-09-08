DELIMITER $$

DROP PROCEDURE IF EXISTS FUNC_GET_WJDR_SBLIST$$

CREATE PROCEDURE func_get_wjdr_sblist(p_czryDm VARCHAR(4000),
       p_sort VARCHAR(4000),p_offset DECIMAL(38,10),p_rows DECIMAL(38,10),p_filter VARCHAR(4000))
routine_body: BEGIN
  -- Oracle REF CURSOR type removed; target uses a result set;
  DECLARE my_cursor Type_Cursor;
  DECLARE o_tb type_tb_sblist DEFAULT type_tb_sblist();
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

  --提取操作员的退税税务机关代码，并计算权限机关代码
  begin
    select IFNULL(qx_swjg, swjg_dm) into v_czry_swjg
      from dm_czry where czry_dm =p_czryDm;  
  EXCEPTION
  WHEN no_data_found THEN
       DBMS_OUTPUT.put_line('操作员不存在');
       LEAVE routine_body;
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
     SET v_filter =' and ' || p_filter || ' ';
  end if;

  SET dyn_select ='select sbid,sssq,sbpc,sbrq,qyhgdm,nsrmc,sbywb_dm,flglcd,zzsbb,TT.swjg_jc as zs_swjg_mc,ds.swjg_jc as ts_swjg_mc,tsjsfs_dm,sd1.dname as sbywbmc,sbtmse from '
  ||' (select vs.sbid, vs.sssq, vs.sbpc, vs.sbrq, vs.qyhgdm, vs.nsrmc, vs.sbywb_dm,vs.flglcd,vs.zzsbb,vs.swjg_jc,vs.tsjsfs_dm,vs.swjg_dm,vs.sbtmse,'
  ||' row_number() over(ORDER BY ' ||  sorting ||  ') rn '
  ||' from v_sbxx_sbdr_filemode vs '
  ||' where vs.swjg_dm like '''||v_czry_qxswjg||''' and vs.sbr is null '
  || v_filter
  ||' and ( '
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
  ||' ))) TT '
  ||' left join dm_swjg ds on (ds.swjg_dm=TT.swjg_dm) '
  ||' left join sys_dict sd1 on sd1.dtype=''ywlx_dm'' and sd1.dcode=TT.sbywb_dm '
  ||' where rn between ' || startRow || ' and ' || endRow || ' order by rn';
  
  OPEN my_cursor FOR dyn_select;
  LOOP 
    FETCH my_cursor INTO v_sbid,v_sssq,v_sbpc,v_sbrq,v_qyhgdm,v_nsrmc,v_sbywbdm,v_flglcd,v_zzsbb,v_zs_swjg_mc,v_ts_swjg_mc,v_tsjsfs,v_sbywbmc,v_sbtmse;
    EXIT WHEN my_cursor%NOTFOUND;
    o_tb.extend;
    SET i = i + 1;
    o_tb(i) := type_rec_sblist (v_sbid,
            case when v_sbywbdm='A0301001' then v_sssq || DATE_FORMAT(v_sbpc, '00') else v_sssq end,
            v_sbrq, v_qyhgdm,v_nsrmc,v_sbywbdm,v_flglcd,v_zzsbb,v_zs_swjg_mc,v_ts_swjg_mc,v_tsjsfs,v_sbywbmc,v_sbtmse,0,0,0);
  END LOOP;
  CLOSE my_cursor;

  LEAVE routine_body;
END$$

DELIMITER ;
