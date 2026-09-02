create or replace function FUNC_ZB_TSJHZX_HZB_HZJS(p_tszb_yn in varchar2,p_zbjg_dm in varchar2) return integer is
begin
  --退税指标计划执行汇总表，汇总计算LX=2汇总类指标机关
  if length(p_tszb_yn)<>6 then
    return -1;
  end if;
  if p_zbjg_dm is null then
    --计算市辖区小计
    update zb_tsjhzx_hzb A set (byxdjhe,byzhtse,byybltse)=
        (select sum(nvl(byxdjhe,0)),sum(nvl(byzhtse,0)),sum(nvl(byybltse,0))
         from zb_tsjhzx_hzb B where B.Tszb_yn=A.Tszb_yn and
         B.ZBJG_DM in (select zbjg_dm from dm_zbjg C where C.SJ_ZBJG=A.Zbjg_Dm and C.Yxbz='Y'))
         where A.Tszb_yn=p_tszb_yn and
         exists(select 1 from dm_zbjg D where D.zbjg_dm=A.zbjg_dm and D.lx='2' and substr(D.zbjg_dm,-1,1)='X');

    --计算各地市小计
    update zb_tsjhzx_hzb A set (byxdjhe,byzhtse,byybltse)=
        (select sum(nvl(byxdjhe,0)),sum(nvl(byzhtse,0)),sum(nvl(byybltse,0))
         from zb_tsjhzx_hzb B where B.Tszb_yn=A.Tszb_yn and
         B.ZBJG_DM in (select zbjg_dm from dm_zbjg C where C.SJ_ZBJG=A.Zbjg_Dm and C.Yxbz='Y'))
         where A.Tszb_yn=p_tszb_yn and
         exists(select 1 from dm_zbjg D where D.zbjg_dm=A.zbjg_dm and D.lx='2' and D.Sj_Zbjg='13300');

    --计算全省所有地区（除直属分局外）小计
    update zb_tsjhzx_hzb A set (byxdjhe,byzhtse,byybltse)=
        (select sum(nvl(byxdjhe,0)),sum(nvl(byzhtse,0)),sum(nvl(byybltse,0))
         from zb_tsjhzx_hzb B where B.Tszb_yn=A.Tszb_yn and
         B.ZBJG_DM in (select zbjg_dm from dm_zbjg C where C.SJ_ZBJG=A.Zbjg_Dm and C.Yxbz='Y'))
         where A.Tszb_yn=p_tszb_yn and
         exists(select 1 from dm_zbjg D where D.zbjg_dm=A.zbjg_dm and D.lx='2' and D.Sj_Zbjg='133');

    --计算全省小计
    update zb_tsjhzx_hzb A set (byxdjhe,byzhtse,byybltse)=
        (select sum(nvl(byxdjhe,0)),sum(nvl(byzhtse,0)),sum(nvl(byybltse,0))
         from zb_tsjhzx_hzb B where B.Tszb_yn=A.Tszb_yn and
         B.ZBJG_DM in (select zbjg_dm from dm_zbjg C where C.SJ_ZBJG=A.Zbjg_Dm and C.Yxbz='Y'))
         where A.Tszb_yn=p_tszb_yn and
         exists(select 1 from dm_zbjg D where D.zbjg_dm=A.zbjg_dm and D.lx='2' and D.Sj_Zbjg='1');

  end if;

  return 1;
end FUNC_ZB_TSJHZX_HZB_HZJS;
/
