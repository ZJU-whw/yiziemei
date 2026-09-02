create or replace procedure tmp_pro_deal_20260509
as
begin
  insert into tmp_20260509_1039_1(djxh,ckyear,mylaj_1039,sjly)
  select t.djxh,to_char(t.ckrq_1,'YYYY'),sum(t.mylaj),'BGD'
    from hx_ckts.ckts_wbsj_hg_bgd201 t
   where t.ckrq_1>=date'2023-01-01'
     and t.ckrq_1<date'2026-05-01'
     and t.jgfs_dm='1039'
   group by t.djxh,to_char(t.ckrq_1,'YYYY')
   union all
  select t.djxh,to_char(t.ckrq_1,'YYYY'),sum(t.mylaj),'WQF'
    from hx_ckts.ckts_wbsj_hg_wqfbgd201 t
   where t.djxh is not null
     and t.ckrq_1>=date'2023-01-01'
     and t.ckrq_1<date'2026-05-01'
     and t.jgfs_dm='1039'
   group by t.djxh,to_char(t.ckrq_1,'YYYY')
   union all
  select t.djxh,to_char(t.ckrq_1,'YYYY'),sum(t.mylaj),'DLZM'
    from hx_ckts.ckts_wbsj_zj_dlckhwzm t
   where t.ckrq_1>=date'2023-01-01'
     and t.ckrq_1<date'2026-05-01'
     and t.jgfs_dm='1039'
   group by t.djxh,to_char(t.ckrq_1,'YYYY');
  commit;
  
  update tmp_20260509_1039_1 t
     set t.mylaj_all= (select sum(s.mylaj)
                         from hx_ckts.ckts_wbsj_hg_bgd201 s
                        where s.djxh=t.djxh
                          and s.ckrq_1>=to_date(t.ckyear||'0101','YYYYMMDD')
                          and s.ckrq_1<add_months(to_date(t.ckyear||'0101','YYYYMMDD'),12)
                          and s.ckrq_1<date'2026-05-01')
   where t.sjly='BGD';
  commit;
  update tmp_20260509_1039_1 t
     set t.mylaj_all= (select sum(s.mylaj)
                         from hx_ckts.ckts_wbsj_hg_wqfbgd201 s
                        where s.djxh=t.djxh
                          and s.ckrq_1>=to_date(t.ckyear||'0101','YYYYMMDD')
                          and s.ckrq_1<add_months(to_date(t.ckyear||'0101','YYYYMMDD'),12)
                          and s.ckrq_1<date'2026-05-01')
   where t.sjly='WQF';
  commit;
  update tmp_20260509_1039_1 t
     set t.mylaj_all= (select sum(s.mylaj)
                         from hx_ckts.ckts_wbsj_zj_dlckhwzm s
                        where s.djxh=t.djxh
                          and s.ckrq_1>=to_date(t.ckyear||'0101','YYYYMMDD')
                          and s.ckrq_1<add_months(to_date(t.ckyear||'0101','YYYYMMDD'),12)
                          and s.ckrq_1<date'2026-05-01')
   where t.sjly='DLZM';
  commit;
  
  insert into tmp_20260509_1039_2(djxh,ckyear,mylaj_1039,mylaj_all,sjly)
  select djxh,ckyear,sum(mylaj_1039),sum(mylaj_all),listagg(sjly,';') within group(order by djxh,ckyear)
    from tmp_20260509_1039_1 t
   group by djxh,ckyear;
  commit;
  
  update tmp_20260509_1039_2 t
     set t.shjemy=nvl((select sum(wh.ckshjemy)
                         from hx_ckts.ckts_wbsj_wh_hwshzbsj wh
                        where wh.djxh=t.djxh
                          and wh.ckshrq>=to_date(t.ckyear||'0101','YYYYMMDD')
                          and wh.ckshrq<add_months(to_date(t.ckyear||'0101','YYYYMMDD'),12)
                          and wh.ckshrq<date'2026-05-01'),0)+
                  nvl((select sum(round(zj.skzje * 100 / hl.rmbhl,2))
                         from hx_ckts.ckts_wbsj_zj_kjmysrxx zj
                        inner join hx_cs_zdy.cs_ckts_hl hl
                           on hl.hbzm_dm='USD' and hl.hlny=to_char(zj.skrq,'yyyymm')
                        where zj.djxh=t.djxh
                          and zj.skrq>=to_date(t.ckyear||'0101','YYYYMMDD')
                          and zj.skrq<add_months(to_date(t.ckyear||'0101','YYYYMMDD'),12)
                          and zj.skrq<date'2026-05-01'),0);
  commit; 
end;
/
