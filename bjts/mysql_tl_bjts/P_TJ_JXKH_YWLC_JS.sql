DELIMITER $$

DROP PROCEDURE IF EXISTS P_TJ_JXKH_YWLC_JS$$

CREATE procedure p_tj_jxkh_ywlc_js()
routine_body: BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';
  DECLARE v_msgtext VARCHAR(4000);


  DECLARE date_tjrq DATETIME;
  DECLARE date_begin DATETIME;

  -- 每月5号之前，从上月1号开始取，每月5号以后，从本月1号开始取

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
    SET v_msgtext = BJTS_SQLERRM_001;
    rollback;
    DO ORA_CONCAT('Error: ', v_msgtext);
    LEAVE routine_body;

  END;
if extract(day from CURRENT_TIMESTAMP) <= 5 then
    SET date_begin = DATE_ADD(CAST(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y-%m-01') AS DATETIME), INTERVAL -1 MONTH);
  else
    SET date_begin = CAST(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y-%m-01') AS DATETIME);
  end if;

  delete from JXKH_YWLC_JS AS t;
  commit;

  insert into JXKH_YWLC_JS
  select t.lcslid_sb,t.tsswjg_dm,p.cpcode,t.ckqygllb_dm,substr(t.ssq,1,4),p.nsrdzdah,p.qyhgdm,p.nsrsbh,p.nsrmc,t.sbywb_dm,t.ssq,t.sbpc,0,
         least(t.sbrq,s.qdsj),case when s.lcslid=s.lcslid_sb then s.qdsj else least(t.sbrq,s.qdsj) end,case when s.lcslid=s.lcslid_sb then s.qdsj else least(t.sbrq,s.qdsj) end,
         case when s.lcslid=s.lcslid_sb then CAST('1900-01-01' AS DATE) else s.qdsj end,r.fsrq,q.sehzrq,q.sehzrq,least(q.xhrq_tk,q.xhrq_md),q.xhrq_tk,q.xhrq_md,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,
         s.sb_zzstse+s.sb_xfstse,s.sb_mdse,s.zh_mdtse,s.by_mdtse,q.sehz_zzstse+q.sehz_xfstse,q.sehz_mdse,q.gkbl_zzstse+q.gkbl_xfstse,q.gkbl_mdse,
         null,null,null,null,null,null,null,null,0,'system',s.sb_xsermb,s.sb_xsemy,s.wzhbz,least(t.sbrq,s.qdsj),least(t.sbrq,s.qdsj),null,null
  from ckts_lc_sbxx t
  inner join ckts_lc_shxx s on s.lcslid_sb=t.lcslid_sb
  left join ckts_lc_ywhzxx r on r.lcslid_fs=s.lcslid_fs
  left join ckts_lc_sehzxx q on q.ywhzbuuid=r.ywhzbuuid
  inner join gs_dj_cktmsdab p on p.cpcode=CAST(t.djxh AS CHAR)
  where t.sbrq>=date_begin;
  commit;

  update JXKH_YWLC_JS AS t set fh_date=CAST('1900-01-01' AS DATE) where t.fh_date=CAST('2100-12-31' AS DATE);
  update JXKH_YWLC_JS AS t set hz_date=CAST('1900-01-01' AS DATE) where t.hz_date=CAST('2100-12-31' AS DATE);
  update JXKH_YWLC_JS AS t set srths_date=CAST('1900-01-01' AS DATE) where t.srths_date=CAST('2100-12-31' AS DATE);
  update JXKH_YWLC_JS AS t set kp_date=CAST('1900-01-01' AS DATE) where t.kp_date=CAST('2100-12-31' AS DATE);
  update JXKH_YWLC_JS AS t set tstk_date=CAST('1900-01-01' AS DATE) where t.tstk_date=CAST('2100-12-31' AS DATE);
  update JXKH_YWLC_JS AS t set mdtk_date=CAST('1900-01-01' AS DATE) where t.mdtk_date=CAST('2100-12-31' AS DATE);
  commit;
  DO '完成数据插入';

  UPDATE JXKH_YWLC_JS AS T
     SET JS_FLAG = '2'
     WHERE JS_FLAG = '0' AND IFNULL(HZ_TSE, 0) = 0;
  COMMIT;
  UPDATE JXKH_YWLC_JS AS T
     SET JS_FLAG = '0'
     WHERE JS_FLAG = '2' AND IFNULL(HZ_TSE, 0) <> 0;
  COMMIT;
  UPDATE JXKH_YWLC_JS AS T
     SET JS_FLAG = '3'
     WHERE JS_FLAG = '0' AND IFNULL(KP_DATE, STR_TO_DATE('1900-01-01', '%Y-%m-%d')) = STR_TO_DATE('1900-01-01', '%Y-%m-%d');
  COMMIT;
  UPDATE JXKH_YWLC_JS AS T
     SET JS_FLAG = '0'
     WHERE JS_FLAG = '3' AND IFNULL(KP_DATE, STR_TO_DATE('1900-01-01', '%Y-%m-%d')) > STR_TO_DATE('1900-01-02', '%Y-%m-%d');
  COMMIT;
  DO '完成参与计算表识统计';

  -- 退税退库日期没时间,默认统一设置成当天中午12点
  -- 合计周期=开票日期-接单日期
  UPDATE JXKH_YWLC_JS AS T
     SET SUM_DAY = IFNULL(greatest(ORA_DATE_DIFF(GREATEST(KP_DATE,SRTHS_DATE), JD_DATE),0), 0),
    SL_DAY = greatest(ORA_DATE_DIFF(SL_DATE, JD_DATE),0),
    SH_DAY = CASE WHEN IFNULL(JS_DATE, STR_TO_DATE('1900-01-01', '%Y-%m-%d'))= STR_TO_DATE('1900-01-01', '%Y-%m-%d')
                  or JS_DATE>SRTHS_DATE
                  THEN 0 ELSE greatest(ORA_DATE_DIFF(JS_DATE, SL_DATE),0) END,
    PG_DAY = CASE WHEN IFNULL(PG_DATE, STR_TO_DATE('1900-01-01', '%Y-%m-%d'))= STR_TO_DATE('1900-01-01', '%Y-%m-%d')
                  or PG_DATE>SRTHS_DATE
                  THEN 0 ELSE greatest(ORA_DATE_DIFF(PG_DATE, JS_DATE),0) END,
    FH_DAY = CASE WHEN IFNULL(FH_DATE, STR_TO_DATE('1900-01-01', '%Y-%m-%d'))= STR_TO_DATE('1900-01-01', '%Y-%m-%d')
                  or FH_DATE>SRTHS_DATE
                  THEN 0 ELSE greatest(ORA_DATE_DIFF(FH_DATE, greatest(SL_DATE,JS_DATE,PG_DATE)),0) END,
    SRTHS_DAY = greatest(ORA_DATE_DIFF(SRTHS_DATE, HZ_DATE),0),
    KP_DAY = greatest(ORA_DATE_DIFF(KP_DATE, SRTHS_DATE),0),
    TK_DAY = greatest((ORA_DATE_ADD(TSTK_DATE, 0.5))-greatest(SRTHS_DATE,KP_DATE),0),
    SSYEAR = DATE_FORMAT(SL_DATE, '%Y'),
    TJ_DATE = CURRENT_TIMESTAMP
   WHERE KP_DATE>STR_TO_DATE('1900-01-01', '%Y-%m-%d');
  COMMIT;
  DO '完成天数统计';

  -- 未减非工作日
  BEGIN
  DECLARE BJTS_FETCH_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_RS_JJR_JJR_DATE_001 LONGTEXT;
  DECLARE BJTS_FETCH_CURSOR_001 CURSOR FOR
select JJR_DATE from PUB_JJR where jjr_ssnd =  (DATE_FORMAT(date_begin, '%Y')) order by JJR_DATE;
  OPEN BJTS_FETCH_CURSOR_001;
  BJTS_FETCH_LOOP_001: LOOP
    BEGIN
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
        SET v_msgtext = BJTS_SQLERRM_002;
        rollback;
        DO ORA_CONCAT('Error: ', v_msgtext);

  END;
BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_FETCH_DONE_001 = TRUE;
      FETCH BJTS_FETCH_CURSOR_001 INTO BJTS_RS_JJR_JJR_DATE_001;
    END;
    IF BJTS_FETCH_DONE_001 THEN
      LEAVE BJTS_FETCH_LOOP_001;
    END IF;

      SET date_tjrq = BJTS_RS_JJR_JJR_DATE_001;
      DO ORA_CONCAT('假日:', DATE_FORMAT(date_tjrq, '%Y-%m-%d'));

      UPDATE JXKH_YWLC_JS AS T
         SET SUM_DAY = SUM_DAY - 1
         WHERE  SUM_DAY >= 1 AND (date_tjrq < KP_DATE AND date_tjrq > JD_DATE);
      UPDATE JXKH_YWLC_JS AS T
         SET SL_DAY = SL_DAY - 1
         WHERE  SL_DAY >= 1 AND (date_tjrq < SL_DATE AND date_tjrq > JD_DATE);
      UPDATE JXKH_YWLC_JS AS T
         SET SH_DAY = SH_DAY - 1
         WHERE  SH_DAY >= 1 AND (date_tjrq < JS_DATE AND date_tjrq > SL_DATE);
      UPDATE JXKH_YWLC_JS AS T
         SET PG_DAY = PG_DAY - 1
         WHERE  PG_DAY >= 1 AND (date_tjrq < PG_DATE AND date_tjrq > JS_DATE);
      UPDATE JXKH_YWLC_JS AS T
         SET FH_DAY = FH_DAY - 1
         WHERE  FH_DAY >= 1 AND (date_tjrq < FH_DATE AND date_tjrq > greatest(JS_DATE,PG_DATE));
      UPDATE JXKH_YWLC_JS AS T
         SET SRTHS_DAY = SRTHS_DAY - 1
         WHERE  SRTHS_DAY >= 1 AND (date_tjrq < SRTHS_DATE AND date_tjrq > HZ_DATE);
      UPDATE JXKH_YWLC_JS AS T
         SET KP_DAY = KP_DAY - 1
         WHERE  KP_DAY >= 1 AND (date_tjrq < KP_DATE AND date_tjrq > SRTHS_DATE);
      UPDATE JXKH_YWLC_JS AS T
         SET TK_DAY = TK_DAY - 1
         WHERE  TK_DAY >= 1 AND (date_tjrq < TSTK_DATE AND date_tjrq > KP_DATE);

      COMMIT;

      END;

  END LOOP BJTS_FETCH_LOOP_001;
  CLOSE BJTS_FETCH_CURSOR_001;
END;
  DO '完成节假日扣除';

  -- 最后计算核准周期
  UPDATE JXKH_YWLC_JS AS T
     SET SUM_DAY=SUM_DAY - PG_DAY,
    HZ_DAY = greatest(SUM_DAY - PG_DAY - KP_DAY - SRTHS_DAY - FH_DAY - SH_DAY - SL_DAY,0)
     WHERE KP_DATE>STR_TO_DATE('1900-01-01', '%Y-%m-%d');
  COMMIT;

  DO '同步成功';
  LEAVE routine_body;

  END$$

DELIMITER ;
