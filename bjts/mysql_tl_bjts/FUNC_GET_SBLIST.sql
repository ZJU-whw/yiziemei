DELIMITER $$

DROP PROCEDURE IF EXISTS FUNC_GET_SBLIST$$

CREATE PROCEDURE func_get_sblist(p_czryDm VARCHAR(4000),p_sbywbDm VARCHAR(4000),p_offset DECIMAL(38,10),p_rows DECIMAL(38,10))
routine_body: BEGIN
  DECLARE o_tb type_tb_sblist DEFAULT type_tb_sblist();
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
   
  for v_rec in (select TT.* from 
    (select vs.sbid, vs.sssq, vs.sbpc, vs.sbrq, vs.qyhgdm, vs.nsrmc, vs.sbywb_dm,vs.flglcd,vs.zzsbb,vs.swjg_jc,
           row_number() over(ORDER BY vs.sbrq asc) rn
      from v_sbxx_sbdr_filemode vs
      inner join dm_czry dc on dc.czry_dm=p_czryDm and vs.swjg_dm =dc.swjg_dm
      where
      vs.sbywb_dm=p_sbywbDm
      and (
      (vs.sbr is not null and vs.sbr=p_czryDm) or
      (vs.sbr is null and (
      not exists (select 1 from sys_cfg_czry_fpgl sc1
      where sc1.czry_dm=dc.czry_dm and sc1.swjg_dm=dc.swjg_dm and sc1.qybz='Y') or
      exists (select 1 from sys_cfg_czry_fpgl sc2
      where sc2.czry_dm=dc.czry_dm and sc2.swjg_dm=dc.swjg_dm and sc2.qybz='Y'
      and (coalesce(sc2.zsjg_dm_set,' ')=' ' or vs.zs_swjg_dm is null or sc2.zsjg_dm_set like '%' || vs.zs_swjg_dm || '%')
      and (coalesce(sc2.zgswry_dm_set,' ')=' ')
      and (coalesce(sc2.flgl_set,' ')=' ' or sc2.flgl_set like '%' || vs.flglcd || '%')
      and (vs.sbzl_dm<>'TSSB' OR (coalesce(sc2.jsmode_set,' ')=' ' or sc2.jsmode_set like '%' || vs.tsjsfs_dm || '%')))))
      ))TT where rn between startRow and endRow
    ) loop
    o_tb.extend;
    SET i = i + 1;
    o_tb(i) := type_rec_sblist (v_rec.sbid,
            case when v_rec.sbywb_dm='A0301001' then v_rec.sssq || DATE_FORMAT(v_rec.sbpc, '00') else v_rec.sssq end,
            v_rec.sbrq, v_rec.qyhgdm,v_rec.nsrmc,v_rec.sbywb_dm,v_rec.flglcd,v_rec.zzsbb,v_rec.swjg_jc,'','','',0,0,0,0);
  end loop;
  LEAVE routine_body;
END$$

DELIMITER ;
