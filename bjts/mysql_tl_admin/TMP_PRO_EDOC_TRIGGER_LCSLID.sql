DELIMITER $$

DROP PROCEDURE IF EXISTS TMP_PRO_EDOC_TRIGGER_LCSLID$$

CREATE procedure TMP_PRO_EDOC_TRIGGER_LCSLID
routine_body: BEGIN
  DECLARE LN_CNT           DECIMAL(38,10);
  

    SET LN_CNT =0;
    FOR CUR_LCXX IN (
        select IFNULL(dj.shxyno, dj.nsrdjno) as NSRSBH,lc.sbywb_dm,lc.sb_ym,IFNULL(lc.sb_pc, '001') as sb_pc,lc.lcslid
               from glxt_bb_shxt_lcxx lc,glxt_bb_shxt_djxx dj
             where lc.djxh=dj.djxh_js and lc.sbywb_dm in ('A0301001','A0305001')  
                   and lc.sb_date >=date'2022-04-01'      
        )
    LOOP
      SET LN_CNT =LN_CNT+1;
      update edoc_record_trigger_result r set r.lcslid=CUR_LCXX.Lcslid
             where r.busikey=
             CUR_LCXX.NSRSBH || '|' || CUR_LCXX.SBYWB_DM || '|' || CUR_LCXX.SB_YM || '|' || CUR_LCXX.SB_PC;
      
      IF LN_CNT=100 THEN
            commit;  
            SET LN_CNT =0; 
            Exit;    
      END IF;
    END LOOP;
    commit;  
  
END$$

DELIMITER ;
