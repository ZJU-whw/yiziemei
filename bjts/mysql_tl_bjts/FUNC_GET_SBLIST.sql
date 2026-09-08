DELIMITER $$

DROP PROCEDURE IF EXISTS FUNC_GET_SBLIST$$

CREATE PROCEDURE func_get_sblist(p_czryDm VARCHAR(4000),p_sbywbDm VARCHAR(4000),p_offset DECIMAL(38,10),p_rows DECIMAL(38,10))
routine_body: BEGIN
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

  SELECT BJTS_RESULT_SOURCE.sbid AS SBID,
       case when BJTS_RESULT_SOURCE.sbywb_dm='A0301001' then ORA_CONCAT(BJTS_RESULT_SOURCE.sssq, LPAD(CAST(BJTS_RESULT_SOURCE.sbpc AS CHAR), 2, '0')) else BJTS_RESULT_SOURCE.sssq end AS SSSQ,
       BJTS_RESULT_SOURCE.sbrq AS SBRQ,
       BJTS_RESULT_SOURCE.qyhgdm AS QYHGDM,
       BJTS_RESULT_SOURCE.nsrmc AS NSRMC,
       BJTS_RESULT_SOURCE.sbywb_dm AS SBYWBDM,
       BJTS_RESULT_SOURCE.flglcd AS FLGLCD,
       BJTS_RESULT_SOURCE.zzsbb AS ZZSBB,
       BJTS_RESULT_SOURCE.swjg_jc AS ZS_SWJG_MC,
       '' AS TS_SWJG_MC,
       '' AS TSJSFS,
       '' AS SBYWBMC,
       0 AS SBTMSE,
       0 AS YDCNT,
       0 AS YJCNT,
       0 AS CQBZ
  FROM (
select TT.* from
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
      and (coalesce(sc2.zsjg_dm_set,' ')=' ' or vs.zs_swjg_dm is null or sc2.zsjg_dm_set like ORA_CONCAT(ORA_CONCAT('%', vs.zs_swjg_dm), '%'))
      and (coalesce(sc2.zgswry_dm_set,' ')=' ')
      and (coalesce(sc2.flgl_set,' ')=' ' or sc2.flgl_set like ORA_CONCAT(ORA_CONCAT('%', vs.flglcd), '%'))
      and (vs.sbzl_dm<>'TSSB' OR (coalesce(sc2.jsmode_set,' ')=' ' or sc2.jsmode_set like ORA_CONCAT(ORA_CONCAT('%', vs.tsjsfs_dm), '%'))))))
      ))TT where rn between startRow and endRow
  ) AS BJTS_RESULT_SOURCE;

END$$

DELIMITER ;
