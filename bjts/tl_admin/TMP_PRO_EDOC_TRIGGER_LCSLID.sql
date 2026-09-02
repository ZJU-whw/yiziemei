create or replace procedure TMP_PRO_EDOC_TRIGGER_LCSLID
AS
  LN_CNT           NUMBER;
  
begin
    LN_CNT:=0;
    FOR CUR_LCXX IN (
        select nvl(dj.shxyno,dj.nsrdjno) as NSRSBH,lc.sbywb_dm,lc.sb_ym,nvl(lc.sb_pc,'001') as sb_pc,lc.lcslid
               from tl_tssh.glxt_bb_shxt_lcxx lc,tl_tssh.glxt_bb_shxt_djxx dj
             where lc.djxh=dj.djxh_js and lc.sbywb_dm in ('A0301001','A0305001')  
                   and lc.sb_date >=date'2022-04-01'      
        )
    LOOP
      LN_CNT:=LN_CNT+1;
      update tl_admin.edoc_record_trigger_result r set r.lcslid=CUR_LCXX.Lcslid
             where r.busikey=
             CUR_LCXX.NSRSBH || '|' || CUR_LCXX.SBYWB_DM || '|' || CUR_LCXX.SB_YM || '|' || CUR_LCXX.SB_PC;
      
      IF LN_CNT=100 THEN
            commit;  
            LN_CNT:=0; 
            Exit;    
      END IF;
    END LOOP;
    commit;  
  
end ;
/
