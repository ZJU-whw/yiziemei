CREATE OR REPLACE PROCEDURE PRO_FXGL_SZYJ_WMQYCKLL_DQ_PERY
/*
 * 风险管理——事中预警——外贸企业出口链路统计（每年）
 */
AS
BEGIN
  delete from ckllfx_cs_wmqylsll_dq t;
  commit;

  insert into ckllfx_cs_wmqylsll_dq(
         ysfs_dm,spdl_dm,qycode_hyd,qycode_hg,qycode_mdg,
         qyhs_all,qyzb_all,bgdfs_all,bgdzb_all,mylaj_all,myzb_all,
         qyhs_sx,qyzb_sx,bgdfs_sx,bgdzb_sx,mylaj_sx,myzb_sx)
  with
  zygys as (
  --按关联号统计主要供应地区（供货金额最大）
  select a.djxh,a.glh,
         case
           --进口缴款书货源地按口岸提取2位行政区划
           when a.cktmspzlx_dm='04'
             then substr(ka.xzqh_dm,1,2)
           --未提取到销售方地市税务机关代码的，从供货方税号提取2位行政区划
           when length(a.xsfdsswjgdm)=4
             then substr(a.xsfdsswjgdm,1,2)
           --提取到销售方地市税务机关代码的，从地市税务机关代码提取2位行政区划
           when length(a.xsfdsswjgdm)=5
             then substr(a.xsfdsswjgdm,2,2)
         end as ghdz,
         row_number() over (partition by a.djxh,a.glh order by sum(a.jsje) desc) as pm
    from ckts_sb_mts_jhmx a
    --对进口缴款书，关联口岸代码表提取关区对应行政区划（省级）
    left join tl_admin.dm_hgcode ka on ka.hgcode=substr(a.jhpzh,1,2)||'00'
   where a.sbrq>=add_months(trunc(sysdate,'yy'),-24) and a.sbrq<trunc(sysdate,'yy')
   group by a.djxh,a.glh,
         case
           when a.cktmspzlx_dm='04'
             then substr(ka.xzqh_dm,1,2)
           when length(a.xsfdsswjgdm)=4
             then substr(a.xsfdsswjgdm,1,2)
           when length(a.xsfdsswjgdm)=5
             then substr(a.xsfdsswjgdm,2,2)
         end
  ),
  mx as (
  --按关联号提取出口链路明细
  select s.djxh,
         s.ckbgdh,
         s.mylaj,
         s.ysfs_dm,
         substr(s.cksp_dm,1,2) as spdl_dm,
         hyd.qycode as qycode_hyd,
         hg.qycode as qycode_hg,
         mdg.qycode as qycode_mdg
    from ckts_sb_mts_ckmx t
   inner join zygys on zygys.djxh=t.djxh and zygys.glh=t.glh and pm=1
   inner join ckts_wbsj_hg_bgd s on s.ckbgdh=t.ckbgdh and s.djxh=t.djxh
    left join tl_admin.dm_xzqh_dq hyd on hyd.dm=zygys.ghdz
    --启运港报关单从报关单号提取报关关区，否则取离境关区
    left join tl_admin.dm_hgcode ka on ka.hgcode=(case when s.qygbz='Y' then substr(s.ckbgdh,1,2) else substr(s.hggqka_dm,1,2) end)||'00'
    left join tl_admin.dm_xzqh_dq hg on hg.dm=ka.xzqh_dm
    left join tl_admin.dm_gbcode mdg on mdg.gb_code=s.zzmdgdqsz_dm
   where t.sbrq>=add_months(trunc(sysdate,'yy'),-24) and t.sbrq<trunc(sysdate,'yy')
     and t.ckbgdh is not null
   union all
  select s.djxh,
         s.dlckhwzmhm as ckbgdh,
         s.mylaj,
         s.ysfs_dm,
         substr(s.cksp_dm,1,2) as spdl_dm,
         hyd.qycode as qycode_hyd,
         hg.qycode as qycode_hg,
         mdg.qycode as qycode_mdg
    from ckts_sb_mts_ckmx t
   inner join zygys on zygys.djxh=t.djxh and zygys.glh=t.glh and pm=1
   inner join ckts_wbsj_zj_dlckhwzm s on s.dlckhwzmhm=t.dlckhwzmhm and s.djxh=t.djxh
    left join tl_admin.dm_xzqh_dq hyd on hyd.dm=zygys.ghdz
    left join tl_admin.dm_hgcode ka on ka.hgcode=substr(s.hggqka_dm,1,2)||'00'
    left join tl_admin.dm_xzqh_dq hg on hg.dm=ka.xzqh_dm
    left join tl_admin.dm_gbcode mdg on mdg.gb_code=s.zzmdgdqsz_dm
   where t.sbrq>=add_months(trunc(sysdate,'yy'),-24) and t.sbrq<trunc(sysdate,'yy')
     and t.ckbgdh is null
  ),
  tj1 as (
  -- 相同运输方式、商品大类、供货区域、目的区域总数
  select ysfs_dm,spdl_dm,qycode_hyd,qycode_mdg,
         count(distinct djxh) as qyhs_tj1,
         count(distinct ckbgdh) as bgdfs_tj1,
         sum(mylaj) as mylaj_tj1
    from mx
   group by ysfs_dm,spdl_dm,qycode_hyd,qycode_mdg
  ),
  tj2 as (
  -- 相同运输方式、商品大类、供货区域、目的区域大额报关单总数
  select ysfs_dm,spdl_dm,qycode_hyd,qycode_mdg,
         count(distinct djxh) as qyhs_tj2,
         count(distinct ckbgdh) as bgdfs_tj2,
         sum(mylaj) as mylaj_tj2
    from mx
   where mylaj>=30000
   group by ysfs_dm,spdl_dm,qycode_hyd,qycode_mdg
  ),
  tj3 as (
  -- 相同运输方式、商品大类、供货区域、目的区域大额报关单总数
  select ysfs_dm,spdl_dm,qycode_hyd,qycode_mdg,qycode_hg,
         count(distinct djxh) as qyhs_all,
         count(distinct ckbgdh) as bgdfs_all,
         sum(mylaj) as mylaj_all,
         count(distinct case when mylaj>=30000 then djxh else null end) as qyhs_sx,
         count(distinct case when mylaj>=30000 then ckbgdh else null end) as bgdfs_sx,
         sum(case when mylaj>=30000 then mylaj else 0 end) as mylaj_sx
    from mx
   group by ysfs_dm,spdl_dm,qycode_hyd,qycode_mdg,qycode_hg
  )
  select tj3.ysfs_dm,tj3.spdl_dm,tj3.qycode_hyd,tj3.qycode_hg,tj3.qycode_mdg,
         tj3.qyhs_all,case when nvl(tj1.qyhs_tj1,0)<=tj3.qyhs_all then 100.00 else round(100*tj3.qyhs_all/tj1.qyhs_tj1,2) end as qyzb_all,
         tj3.bgdfs_all,case when nvl(tj1.bgdfs_tj1,0)<=tj3.bgdfs_all then 100.00 else round(100*tj3.bgdfs_all/tj1.bgdfs_tj1,2) end as bgdzb_all,
         tj3.mylaj_all,case when nvl(tj1.mylaj_tj1,0)<=tj3.mylaj_all then 100.00 else round(100*tj3.mylaj_all/tj1.mylaj_tj1,2) end as myzb_all,
         tj3.qyhs_sx,case when nvl(tj2.qyhs_tj2,0)<=tj3.qyhs_sx then 100.00 else round(100*tj3.qyhs_sx/tj2.qyhs_tj2,2) end as qyzb_sx,
         tj3.bgdfs_sx,case when nvl(tj2.bgdfs_tj2,0)<=tj3.bgdfs_sx then 100.00 else round(100*tj3.bgdfs_sx/tj2.bgdfs_tj2,2) end as bgdzb_sx,
         tj3.mylaj_sx,case when nvl(tj2.mylaj_tj2,0)<=tj3.mylaj_sx then 100.00 else round(100*tj3.mylaj_sx/tj2.mylaj_tj2,2) end as myzb_sx
    from tj3
    left join tj1
      on tj1.ysfs_dm=tj3.ysfs_dm
     and tj1.spdl_dm=tj3.spdl_dm
     and tj1.qycode_hyd=tj3.qycode_hyd
     and tj1.qycode_mdg=tj3.qycode_mdg
    left join tj2
      on tj2.ysfs_dm=tj3.ysfs_dm
     and tj2.spdl_dm=tj3.spdl_dm
     and tj2.qycode_hyd=tj3.qycode_hyd
     and tj2.qycode_mdg=tj3.qycode_mdg
  ;
  commit;

  update ckllfx_cs_wmqylsll_dq t
     set t.fxdj_zhfxzs= t.qyzb_all * 0.1 + t.bgdzb_all * 0.2 + t.myzb_all * 0.2
                      + t.qyzb_sx  * 0.1 + t.bgdzb_sx  * 0.2 + t.myzb_sx  * 0.2;
  commit;
  -- 根据风险指数设置风险等级，对浙沪出口或货源地与出口地区域一致的降一级风险等级
  update ckllfx_cs_wmqylsll_dq t
     set t.fxdj_dm= case when t.fxdj_zhfxzs<=5
                         then (case when t.qycode_hg='08' or t.qycode_hyd=t.qycode_hg then '3' else '4' end)
                         when t.fxdj_zhfxzs<=10
                         then (case when t.qycode_hg='08' or t.qycode_hyd=t.qycode_hg then '2' else '3' end)
                         when t.fxdj_zhfxzs<=20
                         then (case when t.qycode_hg='08' or t.qycode_hyd=t.qycode_hg then '1' else '2' end)
                         else '1'
                    end;
  commit;

  RETURN;
END;
/
