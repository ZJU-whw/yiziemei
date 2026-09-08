DELIMITER $$

DROP PROCEDURE IF EXISTS P_TJ_JXKH_YWLC_JS$$

CREATE procedure p_tj_jxkh_ywlc_js
routine_body: BEGIN
  DECLARE v_msgtext VARCHAR(4000);
  DECLARE pc_jjr(pssnd in VARCHAR(4000)) CURSOR FOR select JJR_DATE from PUB_JJR where jjr_ssnd =  pssnd order by JJR_DATE;
  DECLARE rs_jjr pc_jjr%ROWTYPE;
  DECLARE date_tjrq DATETIME;
  DECLARE date_begin DATETIME;

  --每月5号之前，从上月1号开始取，每月5号以后，从本月1号开始取
  if extract(day from CURRENT_TIMESTAMP) <= 5 then
    SET date_begin = DATE_ADD(CAST(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y-%m-01') AS DATETIME), INTERVAL -1 MONTH);
  else
    SET date_begin = CAST(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y-%m-01') AS DATETIME);
  end if;
  
  delete from JXKH_YWLC_JS t;
  commit;

  insert into JXKH_YWLC_JS
  select t.lcslid_sb,t.tsswjg_dm,p.cpcode,t.ckqygllb_dm,substr(t.ssq,1,4),p.nsrdzdah,p.qyhgdm,p.nsrsbh,p.nsrmc,t.sbywb_dm,t.ssq,t.sbpc,0,
         least(t.sbrq,s.qdsj),case when s.lcslid=s.lcslid_sb then s.qdsj else least(t.sbrq,s.qdsj) end,case when s.lcslid=s.lcslid_sb then s.qdsj else least(t.sbrq,s.qdsj) end,
         case when s.lcslid=s.lcslid_sb then date'1900-01-01' else s.qdsj end,r.fsrq,q.sehzrq,q.sehzrq,least(q.xhrq_tk,q.xhrq_md),q.xhrq_tk,q.xhrq_md,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,
         s.sb_zzstse+s.sb_xfstse,s.sb_mdse,s.zh_mdtse,s.by_mdtse,q.sehz_zzstse+q.sehz_xfstse,q.sehz_mdse,q.gkbl_zzstse+q.gkbl_xfstse,q.gkbl_mdse,
         null,null,null,null,null,null,null,null,0,'system',s.sb_xsermb,s.sb_xsemy,s.wzhbz,least(t.sbrq,s.qdsj),least(t.sbrq,s.qdsj),null,null
  from ckts_lc_sbxx t
  inner join ckts_lc_shxx s on s.lcslid_sb=t.lcslid_sb
  left join ckts_lc_ywhzxx r on r.lcslid_fs=s.lcslid_fs
  left join ckts_lc_sehzxx q on q.ywhzbuuid=r.ywhzbuuid
  inner join gs_dj_cktmsdab p on p.cpcode=CAST(t.djxh AS CHAR)
  where t.sbrq>=date_begin; 
  commit;

  update JXKH_YWLC_JS t set t.fh_date=date'1900-01-01' where t.fh_date=date'2100-12-31';
  update JXKH_YWLC_JS t set t.hz_date=date'1900-01-01' where t.hz_date=date'2100-12-31';
  update JXKH_YWLC_JS t set t.srths_date=date'1900-01-01' where t.srths_date=date'2100-12-31';
  update JXKH_YWLC_JS t set t.kp_date=date'1900-01-01' where t.kp_date=date'2100-12-31';
  update JXKH_YWLC_JS t set t.tstk_date=date'1900-01-01' where t.tstk_date=date'2100-12-31';
  update JXKH_YWLC_JS t set t.mdtk_date=date'1900-01-01' where t.mdtk_date=date'2100-12-31';
  commit;
  SYS.DBMS_OUTPUT.PUT_LINE('完成数据插入');

  UPDATE JXKH_YWLC_JS T
     SET JS_FLAG = '2'
     WHERE JS_FLAG = '0' AND IFNULL(HZ_TSE, 0) = 0;
  COMMIT;
  UPDATE JXKH_YWLC_JS T
     SET JS_FLAG = '0'
     WHERE JS_FLAG = '2' AND IFNULL(HZ_TSE, 0) <> 0;
  COMMIT;
  UPDATE JXKH_YWLC_JS T
     SET JS_FLAG = '3'
     WHERE JS_FLAG = '0' AND IFNULL(KP_DATE, STR_TO_DATE('1900-01-01', '%Y-%m-%d')) = STR_TO_DATE('1900-01-01', '%Y-%m-%d');
  COMMIT;
  UPDATE JXKH_YWLC_JS T
     SET JS_FLAG = '0'
     WHERE JS_FLAG = '3' AND IFNULL(KP_DATE, STR_TO_DATE('1900-01-01', '%Y-%m-%d')) > STR_TO_DATE('1900-01-02', '%Y-%m-%d');
  COMMIT;
  SYS.DBMS_OUTPUT.PUT_LINE('完成参与计算表识统计');

  --退税退库日期没时间,默认统一设置成当天中午12点
  --合计周期=开票日期-接单日期
  UPDATE JXKH_YWLC_JS T
     SET SUM_DAY = IFNULL(greatest(GREATEST(KP_DATE,SRTHS_DATE)-JD_DATE,0), 0),
         SL_DAY = greatest(SL_DATE-JD_DATE,0),
         SH_DAY = CASE WHEN IFNULL(JS_DATE, STR_TO_DATE('1900-01-01', '%Y-%m-%d'))= STR_TO_DATE('1900-01-01', '%Y-%m-%d')
                  or JS_DATE>SRTHS_DATE
                  THEN 0 ELSE greatest(JS_DATE - SL_DATE,0) END,
         PG_DAY = CASE WHEN IFNULL(PG_DATE, STR_TO_DATE('1900-01-01', '%Y-%m-%d'))= STR_TO_DATE('1900-01-01', '%Y-%m-%d')
                  or PG_DATE>SRTHS_DATE
                  THEN 0 ELSE greatest(PG_DATE - JS_DATE,0) END,
         FH_DAY = CASE WHEN IFNULL(FH_DATE, STR_TO_DATE('1900-01-01', '%Y-%m-%d'))= STR_TO_DATE('1900-01-01', '%Y-%m-%d')
                  or FH_DATE>SRTHS_DATE
                  THEN 0 ELSE greatest(FH_DATE - greatest(SL_DATE,JS_DATE,PG_DATE),0) END,
         SRTHS_DAY = greatest(SRTHS_DATE - HZ_DATE,0),
         KP_DAY = greatest(KP_DATE-SRTHS_DATE,0),
         TK_DAY = greatest((TSTK_DATE + 0.5)-greatest(SRTHS_DATE,KP_DATE),0),
         SSYEAR = DATE_FORMAT(SL_DATE, '%Y'),
         TJ_DATE = CURRENT_TIMESTAMP
   WHERE KP_DATE>STR_TO_DATE('1900-01-01', '%Y-%m-%d');
  COMMIT;
  SYS.DBMS_OUTPUT.PUT_LINE('完成天数统计');

  --未减非工作日
  OPEN pc_jjr(DATE_FORMAT(date_begin, '%Y'));
  LOOP
    BEGIN
      FETCH pc_jjr INTO rs_jjr;
      EXIT WHEN pc_jjr%NOTFOUND;
      SET date_tjrq = rs_jjr.JJR_DATE;
      sys.dbms_output.put_line('假日:'||DATE_FORMAT(date_tjrq, '%Y-%m-%d'));

      UPDATE JXKH_YWLC_JS T
         SET SUM_DAY = SUM_DAY - 1
         WHERE  SUM_DAY >= 1 AND (date_tjrq < KP_DATE AND date_tjrq > JD_DATE);
      UPDATE JXKH_YWLC_JS T
         SET SL_DAY = SL_DAY - 1
         WHERE  SL_DAY >= 1 AND (date_tjrq < SL_DATE AND date_tjrq > JD_DATE);
      UPDATE JXKH_YWLC_JS T
         SET SH_DAY = SH_DAY - 1
         WHERE  SH_DAY >= 1 AND (date_tjrq < JS_DATE AND date_tjrq > SL_DATE);
      UPDATE JXKH_YWLC_JS T
         SET PG_DAY = PG_DAY - 1
         WHERE  PG_DAY >= 1 AND (date_tjrq < PG_DATE AND date_tjrq > JS_DATE);
      UPDATE JXKH_YWLC_JS T
         SET FH_DAY = FH_DAY - 1
         WHERE  FH_DAY >= 1 AND (date_tjrq < FH_DATE AND date_tjrq > greatest(JS_DATE,PG_DATE));
      UPDATE JXKH_YWLC_JS T
         SET SRTHS_DAY = SRTHS_DAY - 1
         WHERE  SRTHS_DAY >= 1 AND (date_tjrq < SRTHS_DATE AND date_tjrq > HZ_DATE);
      UPDATE JXKH_YWLC_JS T
         SET KP_DAY = KP_DAY - 1
         WHERE  KP_DAY >= 1 AND (date_tjrq < KP_DATE AND date_tjrq > SRTHS_DATE);
      UPDATE JXKH_YWLC_JS T
         SET TK_DAY = TK_DAY - 1
         WHERE  TK_DAY >= 1 AND (date_tjrq < TSTK_DATE AND date_tjrq > KP_DATE);

      COMMIT;

      Exception
      When others then
        SET v_msgtext = sqlerrm;
        rollback;
        sys.dbms_output.put_line('Error: ' || v_msgtext);
    END;
  END LOOP;
  CLOSE pc_jjr;
  SYS.DBMS_OUTPUT.PUT_LINE('完成节假日扣除');

  --最后计算核准周期
  UPDATE JXKH_YWLC_JS T
     SET SUM_DAY=SUM_DAY - PG_DAY,
         HZ_DAY = greatest(SUM_DAY - PG_DAY - KP_DAY - SRTHS_DAY - FH_DAY - SH_DAY - SL_DAY,0)
     WHERE KP_DATE>STR_TO_DATE('1900-01-01', '%Y-%m-%d');
  COMMIT;

  SYS.DBMS_OUTPUT.PUT_LINE('同步成功');
  LEAVE routine_body;

  Exception
    When others then
    SET v_msgtext = sqlerrm;
    rollback;
    sys.dbms_output.put_line('Error: ' || v_msgtext);
    LEAVE routine_body;
END$$

DELIMITER ;
