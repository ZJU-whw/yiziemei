create or replace procedure tmp_pro_deal_20260113
as
  ln_mylaj2025    number(18,2);
  ln_mylaj2024    number(18,2);
  ln_dllaj2025    number(18,2);
  ln_dllaj2024    number(18,2);
  ln_tse2025      number(18,6);
  ln_tse2024      number(18,6);
  ln_mde2025      number(18,6);
  ln_mde2024      number(18,6);
begin
  for cur_lc in (select t.xh, t.djxh from tmp_20260113_zlqy t where t.mylaj2025 is null)
  loop
    select sum(case when bgd.ckrq_1<date'2025-01-01' then 0 else bgd.mylaj end),
           sum(case when bgd.ckrq_1<date'2025-01-01' then bgd.mylaj else 0 end)
      into ln_mylaj2025, ln_mylaj2024
      from hx_ckts.ckts_wbsj_hg_bgd201 bgd
     where bgd.djxh=cur_lc.djxh
       and bgd.ckrq_1>=date'2024-01-01' and bgd.ckrq_1<date'2026-01-01';

    select sum(case when zm.ckrq_1<date'2025-01-01' then 0 else zm.mylaj end),
           sum(case when zm.ckrq_1<date'2025-01-01' then zm.mylaj else 0 end)
      into ln_dllaj2025, ln_dllaj2024
      from hx_ckts.ckts_wbsj_zj_dlckhwzm zm
     where zm.djxh=cur_lc.djxh
       and zm.ckrq_1>=date'2024-01-01' and zm.ckrq_1<date'2026-01-01';
  
    select sum(case when se.sehzrq<date'2025-01-01' then 0 else se.sehzzzstse+se.sehzxfstse end),
           sum(case when se.sehzrq<date'2025-01-01' then 0 else se.sehzmdse end),
           sum(case when se.sehzrq<date'2025-01-01' then se.sehzzzstse+se.sehzxfstse else 0 end),
           sum(case when se.sehzrq<date'2025-01-01' then se.sehzmdse else 0 end)
      into ln_tse2025, ln_mde2025, ln_tse2024, ln_mde2024
      from hx_ckts.ckts_ty_sehzb se
     where se.djxh=cur_lc.djxh
       and se.sehzrq>=date'2024-01-01' and se.sehzrq<date'2026-01-01';
    
    update tmp_20260113_zlqy t
       set t.mylaj2025 = nvl(ln_mylaj2025,0)+nvl(ln_dllaj2025,0),
           t.mylaj2024 = nvl(ln_mylaj2024,0)+nvl(ln_dllaj2024,0),
           t.tse2025 = ln_tse2025,
           t.tse2024 = ln_tse2024,
           t.mde2025 = ln_mde2025,
           t.mde2024 = ln_mde2024
     where t.xh=cur_lc.xh;
    commit;
  end loop;

  return;
end;
/
