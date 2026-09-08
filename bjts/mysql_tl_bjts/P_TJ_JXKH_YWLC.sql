DELIMITER $$

DROP PROCEDURE IF EXISTS P_TJ_JXKH_YWLC$$

CREATE procedure p_tj_jxkh_ywlc
routine_body: BEGIN
  DECLARE v_msgtext VARCHAR(4000);
  DECLARE pc_jjr(pssnd in VARCHAR(4000)) CURSOR FOR select JJR_DATE from PUB_JJR where jjr_ssnd =  pssnd order by JJR_DATE;
  DECLARE rs_jjr pc_jjr%ROWTYPE;
  DECLARE date_tjrq DATETIME;
  DECLARE date_slrq DATETIME;

  --5日前不统计
  --if extract(day from date_tjrq) < 5 then
  --  return;
  --end if;
  --DELETE FROM JXKH_YWLC WHERE TO_CHAR(SL_DATE,'YYYY') = av_ssnd;
  --COMMIT;

  --核准日期日,固定年初
  SET date_slrq = STR_TO_DATE('2021-01-01', '%Y-%m-%d');

  UPDATE JXKH_YWLC T
     SET (NSRDZDAH,QYHGDM,NSRSBH,NSRMC)=(SELECT NSRDZDAH,QYHGDM,NSRSBH,NSRMC FROM GS_DJ_CKTMSDAB S WHERE S.CPCODE=T.CPCODE AND ROWNUM = 1)
   WHERE SL_DATE > date_slrq and NSRDZDAH IS NULL;
  COMMIT;
  SYS.DBMS_OUTPUT.PUT_LINE('完成名称设置');

  merge into JXKH_YWLC UU
  using (select LCSLID, SBID, SBRQ
           from (select T.lcslid,
                        S.ID as SBID,
                        case when s.sbfs='0' then greatest(IFNULL(s.sbsj, s.sbrq),s.sbrq) else s.sbrq end as SBRQ,
                        ROW_NUMBER() OVER(partition by s.lcslid order by s.sbrq desc) as RN
                   FROM JXKH_YWLC T, SB_SBXX_HZ S
                  WHERE T.SL_DATE > date_slrq
                    and T.SBID IS NULL
                    and S.LCSLID = T.LCSLID)
          WHERE RN = 1) ZZ
  on (ZZ.lcslid = UU.LCSLID)
  when matched then
    update set UU.SBID = ZZ.SBID, UU.SBRQ = ZZ.SBRQ;
  COMMIT;

  SYS.DBMS_OUTPUT.PUT_LINE('完成申报日期设置');

  --计算实际接单日期(实际申报日期)
  --FLGLCD='D',WZHQY='0'，接单日期=MAX(受理日期,增值税日期)
  --(免抵退)，接单日期=MAX(申报日期,增值税日期)
  --(其他),   接单日期=申报日期
  UPDATE JXKH_YWLC T
     SET JD_DATE = CASE WHEN FLGLCD='D' OR WZHQY='0' THEN SL_DATE
                        WHEN FLGLCD<>'D' AND WZHQY<>'0' AND SBYWB_DM='A0305001' THEN least(greatest(IFNULL(SBRQ, SL_DATE),ZZS_DATE),SL_DATE)
                        ELSE least(IFNULL(SBRQ, SL_DATE),SL_DATE) END
    WHERE SL_DATE > date_slrq and JD_DATE=STR_TO_DATE('1900-01-01', '%Y-%m-%d');
  COMMIT;
  SYS.DBMS_OUTPUT.PUT_LINE('完成实际接单日期设置');

  --参与计算表识 0 默认 1有评估 2退税额为0
/*  UPDATE JXKH_YWLC T
     SET JS_FLAG = '1'
     WHERE SL_DATE > date_slrq AND JS_FLAG = '0'
     AND NVL(PG_DATE,TO_DATE('1900-01-01','YYYY-MM-DD')) > TO_DATE('1900-01-02','YYYY-MM-DD');
  COMMIT;
*/
  UPDATE JXKH_YWLC T
     SET JS_FLAG = '2'
     WHERE SL_DATE > date_slrq AND JS_FLAG = '0' AND IFNULL(HZ_TSE, 0) = 0;
  COMMIT;
  UPDATE JXKH_YWLC T
     SET JS_FLAG = '0'
     WHERE SL_DATE > date_slrq AND JS_FLAG = '2' AND IFNULL(HZ_TSE, 0) <> 0;
  COMMIT;
  UPDATE JXKH_YWLC T
     SET JS_FLAG = '3'
     WHERE SL_DATE > date_slrq AND JS_FLAG = '0'
     AND IFNULL(KP_DATE, STR_TO_DATE('1900-01-01', '%Y-%m-%d')) = STR_TO_DATE('1900-01-01', '%Y-%m-%d');
  COMMIT;
  UPDATE JXKH_YWLC T
     SET JS_FLAG = '0'
     WHERE SL_DATE > date_slrq AND JS_FLAG = '3'
     AND IFNULL(KP_DATE, STR_TO_DATE('1900-01-01', '%Y-%m-%d')) > STR_TO_DATE('1900-01-02', '%Y-%m-%d');
  COMMIT;
  SYS.DBMS_OUTPUT.PUT_LINE('完成参与计算表识统计');

  --退税退库日期没时间,默认统一设置成当天中午12点
  --合计周期=开票日期-接单日期
  UPDATE JXKH_YWLC T
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
   WHERE SL_DATE > date_slrq AND KP_DATE>STR_TO_DATE('1900-01-01', '%Y-%m-%d');
  COMMIT;
  SYS.DBMS_OUTPUT.PUT_LINE('完成天数统计');

  --未减非工作日
  OPEN pc_jjr(DATE_FORMAT(date_slrq, '%Y'));
  LOOP
    BEGIN
      FETCH pc_jjr INTO rs_jjr;
      EXIT WHEN pc_jjr%NOTFOUND;
      SET date_tjrq = rs_jjr.JJR_DATE;
      sys.dbms_output.put_line('假日:'||DATE_FORMAT(date_tjrq, '%Y-%m-%d'));

      UPDATE JXKH_YWLC T
         SET SUM_DAY = SUM_DAY - 1
         WHERE SL_DATE >= date_slrq and SUM_DAY >= 1 AND (date_tjrq < KP_DATE AND date_tjrq > JD_DATE);
      UPDATE JXKH_YWLC T
         SET SL_DAY = SL_DAY - 1
         WHERE SL_DATE >= date_slrq and SL_DAY >= 1 AND (date_tjrq < SL_DATE AND date_tjrq > JD_DATE);
      UPDATE JXKH_YWLC T
         SET SH_DAY = SH_DAY - 1
         WHERE SL_DATE >= date_slrq and SH_DAY >= 1 AND (date_tjrq < JS_DATE AND date_tjrq > SL_DATE);
      UPDATE JXKH_YWLC T
         SET PG_DAY = PG_DAY - 1
         WHERE SL_DATE >= date_slrq and PG_DAY >= 1 AND (date_tjrq < PG_DATE AND date_tjrq > JS_DATE);
      UPDATE JXKH_YWLC T
         SET FH_DAY = FH_DAY - 1
         WHERE SL_DATE >= date_slrq and FH_DAY >= 1 AND (date_tjrq < FH_DATE AND date_tjrq > greatest(JS_DATE,PG_DATE));
      UPDATE JXKH_YWLC T
         SET SRTHS_DAY = SRTHS_DAY - 1
         WHERE SL_DATE >= date_slrq and SRTHS_DAY >= 1 AND (date_tjrq < SRTHS_DATE AND date_tjrq > HZ_DATE);
      UPDATE JXKH_YWLC T
         SET KP_DAY = KP_DAY - 1
         WHERE SL_DATE >= date_slrq and KP_DAY >= 1 AND (date_tjrq < KP_DATE AND date_tjrq > SRTHS_DATE);
      UPDATE JXKH_YWLC T
         SET TK_DAY = TK_DAY - 1
         WHERE SL_DATE >= date_slrq and TK_DAY >= 1 AND (date_tjrq < TSTK_DATE AND date_tjrq > KP_DATE);

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
  UPDATE JXKH_YWLC T
     SET SUM_DAY=SUM_DAY - PG_DAY,
         HZ_DAY = greatest(SUM_DAY - PG_DAY - KP_DAY - SRTHS_DAY - FH_DAY - SH_DAY - SL_DAY,0)
     WHERE SL_DATE > date_slrq AND KP_DATE>STR_TO_DATE('1900-01-01', '%Y-%m-%d');
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
