DELIMITER $$

DROP PROCEDURE IF EXISTS FUNC_GET_WJDR_COUNT$$

CREATE PROCEDURE func_get_wjdr_count(p_czryDm VARCHAR(4000), OUT P_RESULT integer)
routine_body: BEGIN
  DECLARE dyn_select VARCHAR(1500);
  DECLARE v_czry_qxswjg VARCHAR(11);
  DECLARE v_czry_swjg VARCHAR(11);
  DECLARE v_cnt BIGINT;


  begin
    select IFNULL(qx_swjg, swjg_dm) into v_czry_swjg
      from dm_czry where czry_dm =p_czryDm;
  EXCEPTION
  WHEN no_data_found THEN
       --DBMS_OUTPUT.put_line('操作员不存在');
       SET P_RESULT = 0; LEAVE routine_body;
  end;
  SET v_czry_qxswjg =func_get_qxswjg(v_czry_swjg) ;

  SET dyn_select ='select count(1) from v_sbxx_sbdr_filemode vs '
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

  SET P_RESULT = v_cnt; LEAVE routine_body;
END$$

DELIMITER ;
