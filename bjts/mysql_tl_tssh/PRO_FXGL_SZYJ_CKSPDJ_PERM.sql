DELIMITER $$

DROP PROCEDURE IF EXISTS PRO_FXGL_SZYJ_CKSPDJ_PERM$$

CREATE PROCEDURE PRO_FXGL_SZYJ_CKSPDJ_PERM()
/*
 * 风险管理——事中预警——出口商品平均单价模型刷新（每月）
 */
routine_body: BEGIN

  delete from yj_cs_qspjdj_wm;
  commit;

  insert into yj_cs_qspjdj_wm(spdm,qnt,amt,dj,qyhs,ywbs,spmc,sbspmc)
  with
  tj as (
  select a.cksp_dm,
         sum(case when a.sz='V' then a.sl else 0 end) as qnt,
         sum(a.jsje) as amt,
         count(distinct a.djxh) as qyhs,
         count(distinct ORA_CONCAT(a.djxh, a.glh)) as ywbs
    from ckts_sb_mts_jhmx a
   where a.sbrq>=DATE_ADD(CAST(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y-%m-01') AS DATETIME), INTERVAL -12 MONTH) and a.sbrq<CAST(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y-%m-01') AS DATETIME)
     and a.sl>0
   group by a.cksp_dm
  ),
  zymc as (
  select a.cksp_dm,a.sbhgspmc,sum(a.jsje) as amt,
         row_number() over (partition by a.cksp_dm order by sum(a.jsje) desc) as pm
    from ckts_sb_mts_jhmx a
   where a.sbrq>=DATE_ADD(CAST(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y-%m-01') AS DATETIME), INTERVAL -12 MONTH) and a.sbrq<CAST(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y-%m-01') AS DATETIME)
   group by a.cksp_dm,a.sbhgspmc
  ),
  wkmc as (
  select tj.cksp_dm,wk.ckspmc,row_number() over (partition by tj.cksp_dm order by wk.yxqq desc) as pm
    from tj
    left join ckts_dm_tslvwk wk on wk.cksp_dm=tj.cksp_dm
  )
  select tj.cksp_dm,tj.qnt,tj.amt,round(tj.amt/tj.qnt,2),tj.qyhs,tj.ywbs,wkmc.ckspmc,zymc.sbhgspmc
    from tj
   inner join zymc on zymc.cksp_dm=tj.cksp_dm and zymc.pm=1
   inner join wkmc on wkmc.cksp_dm=tj.cksp_dm and wkmc.pm=1
  ;
  commit;

  delete from yj_cs_qspjdj_sc;
  commit;

  insert into yj_cs_qspjdj_sc(spdm,qnt,amt,dj,qyhs,ywbs,spmc,sbspmc)
  with
  tj as (
  select a.cksp_dm,
         sum(a.cksl) as qnt,
         sum(a.mylaj) as amt,
         count(distinct a.djxh) as qyhs,
         count(distinct IFNULL(a.ckbgdh, a.dlckhwzmhm)) as ywbs
    from ckts_sb_mdt_ckmx a
   where a.sbrq>=DATE_ADD(CAST(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y-%m-01') AS DATETIME), INTERVAL -12 MONTH) and a.sbrq<CAST(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y-%m-01') AS DATETIME)
     and a.cksl>0
   group by a.cksp_dm
  ),
  zymc as (
  select a.cksp_dm,a.sbhgspmc,sum(a.mylaj) as amt,
         row_number() over (partition by a.cksp_dm order by sum(a.mylaj) desc) as pm
    from ckts_sb_mdt_ckmx a
   where a.sbrq>=DATE_ADD(CAST(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y-%m-01') AS DATETIME), INTERVAL -12 MONTH) and a.sbrq<CAST(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y-%m-01') AS DATETIME)
   group by a.cksp_dm,a.sbhgspmc
  ),
  wkmc as (
  select tj.cksp_dm,wk.ckspmc,row_number() over (partition by tj.cksp_dm order by wk.yxqq desc) as pm
    from tj
    left join ckts_dm_tslvwk wk on wk.cksp_dm=tj.cksp_dm
  )
  select tj.cksp_dm,tj.qnt,tj.amt,round(tj.amt/tj.qnt,2),tj.qyhs,tj.ywbs,wkmc.ckspmc,zymc.sbhgspmc
    from tj
   inner join zymc on zymc.cksp_dm=tj.cksp_dm and zymc.pm=1
   inner join wkmc on wkmc.cksp_dm=tj.cksp_dm and wkmc.pm=1
  ;
  commit;

  LEAVE routine_body;
END$$

DELIMITER ;
