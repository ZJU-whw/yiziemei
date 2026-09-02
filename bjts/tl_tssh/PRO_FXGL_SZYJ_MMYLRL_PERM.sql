CREATE OR REPLACE PROCEDURE PRO_FXGL_SZYJ_MMYLRL_PERM
/*
 * 风险管理——事中预警——外贸企业每美元利润率刷新（每月）
 */
AS
BEGIN
  delete from tl_admin.yj_cs_wmqymmylrl;
  delete from tl_admin.yj_cs_wmqymmylrl_fqy;
  commit;

  insert into tl_admin.yj_cs_wmqymmylrl_fqy(swjg_dm,djxh,sbywbs,mmylrl_max,mmylrl_min,mmylrl_mid,mmylrl_avg,mmylrl_std,mylaj,rmblaj,jhcb,mmylrl_yjx)
  with
  jh as (
  select a.djxh,a.glh,sum(a.jsje*(100+a.zssl-a.tsl)/100) as jhcb
    from ckts_sb_mts_jhmx a
   where a.sbrq>=add_months(trunc(sysdate,'mm'),-12) and a.sbrq<trunc(sysdate,'mm')
   group by a.djxh,a.glh
  )
  ,mx as (
  select b.tsswjg_dm,b.djxh,b.ckbgdh,b.mylaj,round(c.rmblaj*b.mylaj/c.mylaj,2) as rmblaj,jh.jhcb,
         round((round(c.rmblaj*b.mylaj/c.mylaj,2)-jh.jhcb)/b.mylaj,2) as mmylrl
    from ckts_sb_mts_ckmx b
   inner join jh on jh.djxh=b.djxh and jh.glh=b.glh
   inner join ckts_wbsj_hg_bgd c on c.ckbgdh=b.ckbgdh and c.djxh=b.djxh
   where b.sbrq>=add_months(trunc(sysdate,'mm'),-12) and b.sbrq<trunc(sysdate,'mm')
     and b.ckbgdh is not null
     and c.mylaj>0 and b.mylaj>0
   union all
  select b.tsswjg_dm,b.djxh,b.dlckhwzmhm as ckbgdh,b.mylaj,round(c.rmblaj*b.mylaj/c.mylaj,2) as rmblaj,jh.jhcb,
         round((round(c.rmblaj*b.mylaj/c.mylaj,2)-jh.jhcb)/b.mylaj,2) as mmylrl
    from ckts_sb_mts_ckmx b
   inner join jh on jh.djxh=b.djxh and jh.glh=b.glh
   inner join ckts_wbsj_zj_dlckhwzm c on c.dlckhwzmhm=b.dlckhwzmhm and c.djxh=b.djxh
   where b.sbrq>=add_months(trunc(sysdate,'mm'),-12) and b.sbrq<trunc(sysdate,'mm')
     and b.ckbgdh is null
     and c.mylaj>0 and b.mylaj>0
  )
  select tsswjg_dm,djxh,
         count(distinct ckbgdh) as sbywbs,max(mmylrl) as mmylrl_max,min(mmylrl) as mmylrl_min,
         median(mmylrl) as mmylrl_mid,avg(mmylrl) as mmylrl_avg,stddev(mmylrl) as mmylrl_std,
         sum(mylaj) as mylaj,sum(rmblaj) as rmblaj,sum(jhcb) as jhcb,
         round((sum(rmblaj)-sum(jhcb))/sum(mylaj),2) as mmylrl_yjx
    from mx
   group by tsswjg_dm,djxh
  ;
  commit;
    
  insert into tl_admin.yj_cs_wmqymmylrl(swjg_dm,sbqyhs,sbywbs,mmylrl_max,mmylrl_min,mmylrl_mid,mmylrl_avg,mmylrl_std,mylaj,rmblaj,jhcb,mmylrl_yjx)
  select swjg_dm,
         count(distinct djxh) as sbqyhs,sum(sbywbs) as sbywbs,
         max(mmylrl_yjx) as mmylrl_max,min(mmylrl_yjx) as mmylrl_min,
         median(mmylrl_yjx) as mmylrl_mid,avg(mmylrl_yjx) as mmylrl_avg,stddev(mmylrl_yjx) as mmylrl_std,
         sum(mylaj) as mylaj,sum(rmblaj) as rmblaj,sum(jhcb) as jhcb,
         round((sum(rmblaj)-sum(jhcb))/sum(mylaj),2) as mmylrl_yjx
    from tl_admin.yj_cs_wmqymmylrl_fqy
   group by swjg_dm
   union all
  select substr(swjg_dm,1,5)||'000000',
         count(distinct djxh) as sbqyhs,sum(sbywbs) as sbywbs,
         max(mmylrl_yjx) as mmylrl_max,min(mmylrl_yjx) as mmylrl_min,
         median(mmylrl_yjx) as mmylrl_mid,avg(mmylrl_yjx) as mmylrl_avg,stddev(mmylrl_yjx) as mmylrl_std,
         sum(mylaj) as mylaj,sum(rmblaj) as rmblaj,sum(jhcb) as jhcb,
         round((sum(rmblaj)-sum(jhcb))/sum(mylaj),2) as mmylrl_yjx
    from tl_admin.yj_cs_wmqymmylrl_fqy
   group by substr(swjg_dm,1,5)
   union all
  select '13300000000',
         count(distinct djxh) as sbqyhs,sum(sbywbs) as sbywbs,
         max(mmylrl_yjx) as mmylrl_max,min(mmylrl_yjx) as mmylrl_min,
         median(mmylrl_yjx) as mmylrl_mid,avg(mmylrl_yjx) as mmylrl_avg,stddev(mmylrl_yjx) as mmylrl_std,
         sum(mylaj) as mylaj,sum(rmblaj) as rmblaj,sum(jhcb) as jhcb,
         round((sum(rmblaj)-sum(jhcb))/sum(mylaj),2) as mmylrl_yjx
    from tl_admin.yj_cs_wmqymmylrl_fqy
  ;
  commit;

  RETURN;
END;
/
