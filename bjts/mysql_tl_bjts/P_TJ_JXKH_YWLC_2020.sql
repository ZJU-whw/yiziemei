DELIMITER $$

DROP PROCEDURE IF EXISTS P_TJ_JXKH_YWLC_2020$$

CREATE procedure p_tj_jxkh_ywlc_2020()
routine_body: BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';
  DECLARE v_msgtext VARCHAR(4000);


  DECLARE date_tjrq DATETIME;
  DECLARE date_slrq DATETIME;

  -- 5日前不统计
  -- if extract(day from date_tjrq) < 5 then
  --  return;
  -- end if;
  -- DELETE FROM JXKH_YWLC WHERE TO_CHAR(SL_DATE,'YYYY') = av_ssnd;
  -- COMMIT;

  -- 核准日期日,固定年初

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
    SET v_msgtext = BJTS_SQLERRM_001;
    rollback;
    DO ORA_CONCAT('Error: ', v_msgtext);
    LEAVE routine_body;

  END;
SET date_slrq = STR_TO_DATE('2020-01-01', '%Y-%m-%d');

  UPDATE JXKH_YWLC AS T
     SET NSRDZDAH = (SELECT NSRDZDAH
FROM GS_DJ_CKTMSDAB S WHERE S.CPCODE=T.CPCODE AND 1=1
LIMIT 1),
    QYHGDM = (SELECT QYHGDM
FROM GS_DJ_CKTMSDAB S WHERE S.CPCODE=T.CPCODE AND 1=1
LIMIT 1),
    NSRSBH = (SELECT NSRSBH
FROM GS_DJ_CKTMSDAB S WHERE S.CPCODE=T.CPCODE AND 1=1
LIMIT 1),
    NSRMC = (SELECT NSRMC
FROM GS_DJ_CKTMSDAB S WHERE S.CPCODE=T.CPCODE AND 1=1
LIMIT 1)
   WHERE SL_DATE > date_slrq and NSRDZDAH IS NULL;
  COMMIT;
  DO '完成名称设置';

  UPDATE JXKH_YWLC AS UU
JOIN (
select LCSLID, SBID, SBRQ
           from (select T.lcslid,
                        S.ID as SBID,
                        case when s.sbfs='0' then greatest(IFNULL(s.sbsj, s.sbrq),s.sbrq) else s.sbrq end as SBRQ,
                        ROW_NUMBER() OVER(partition by s.lcslid order by s.sbrq desc) as RN
                   FROM JXKH_YWLC T, SB_SBXX_HZ S
                  WHERE T.SL_DATE > date_slrq
                    and T.SBID IS NULL
                    and S.LCSLID = T.LCSLID)
          WHERE RN = 1
) AS ZZ
ON ZZ.lcslid = UU.LCSLID
SET SBID = ZZ.SBID, SBRQ = ZZ.SBRQ;
  COMMIT;

  DO '完成申报日期设置';

  -- 计算实际接单日期(实际申报日期)
  -- FLGLCD='D',WZHQY='0'，接单日期=MAX(受理日期,增值税日期)
  -- (免抵退)，接单日期=MAX(申报日期,增值税日期)
  -- (其他),   接单日期=申报日期
  UPDATE JXKH_YWLC AS T
     SET JD_DATE = CASE WHEN FLGLCD='D' OR WZHQY='0' THEN SL_DATE
                        WHEN FLGLCD<>'D' AND WZHQY<>'0' AND SBYWB_DM='A0305001' THEN least(greatest(IFNULL(SBRQ, SL_DATE),ZZS_DATE),SL_DATE)
                        ELSE least(IFNULL(SBRQ, SL_DATE),SL_DATE) END
    WHERE SL_DATE > date_slrq and JD_DATE=STR_TO_DATE('1900-01-01', '%Y-%m-%d');
  COMMIT;
  DO '完成实际接单日期设置';

  -- 参与计算表识 0 默认 1有评估 2退税额为0
/*  UPDATE JXKH_YWLC T
     SET JS_FLAG = '1'
     WHERE SL_DATE > date_slrq AND JS_FLAG = '0'
     AND NVL(PG_DATE,TO_DATE('1900-01-01','YYYY-MM-DD')) > TO_DATE('1900-01-02','YYYY-MM-DD');
  COMMIT;
*/
  UPDATE JXKH_YWLC AS T
     SET JS_FLAG = '2'
     WHERE SL_DATE > date_slrq AND JS_FLAG = '0' AND IFNULL(HZ_TSE, 0) = 0;
  COMMIT;
  UPDATE JXKH_YWLC AS T
     SET JS_FLAG = '0'
     WHERE SL_DATE > date_slrq AND JS_FLAG = '2' AND IFNULL(HZ_TSE, 0) <> 0;
  COMMIT;
  UPDATE JXKH_YWLC AS T
     SET JS_FLAG = '3'
     WHERE SL_DATE > date_slrq AND JS_FLAG = '0'
     AND IFNULL(KP_DATE, STR_TO_DATE('1900-01-01', '%Y-%m-%d')) = STR_TO_DATE('1900-01-01', '%Y-%m-%d');
  COMMIT;
  UPDATE JXKH_YWLC AS T
     SET JS_FLAG = '0'
     WHERE SL_DATE > date_slrq AND JS_FLAG = '3'
     AND IFNULL(KP_DATE, STR_TO_DATE('1900-01-01', '%Y-%m-%d')) > STR_TO_DATE('1900-01-02', '%Y-%m-%d');
  COMMIT;
  DO '完成参与计算表识统计';

  -- 退税退库日期没时间,默认统一设置成当天中午12点
  -- 合计周期=开票日期-接单日期
  UPDATE JXKH_YWLC AS T
     SET SUM_DAY = IFNULL(greatest(ORA_DATE_DIFF(KP_DATE, JD_DATE),0), 0),
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
   WHERE SL_DATE > date_slrq AND KP_DATE>STR_TO_DATE('1900-01-01', '%Y-%m-%d');
  COMMIT;
  DO '完成天数统计';

  -- 未减非工作日
  BEGIN
  DECLARE BJTS_FETCH_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_RS_JJR_JJR_DATE_001 LONGTEXT;
  DECLARE BJTS_FETCH_CURSOR_001 CURSOR FOR
select JJR_DATE from PUB_JJR where jjr_ssnd =  (DATE_FORMAT(date_slrq, '%Y')) order by JJR_DATE;
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

      UPDATE JXKH_YWLC AS T
         SET SUM_DAY = SUM_DAY - 1
         WHERE SL_DATE >= date_slrq and SUM_DAY >= 1 AND (date_tjrq < KP_DATE AND date_tjrq > JD_DATE);
      UPDATE JXKH_YWLC AS T
         SET SL_DAY = SL_DAY - 1
         WHERE SL_DATE >= date_slrq and SL_DAY >= 1 AND (date_tjrq < SL_DATE AND date_tjrq > JD_DATE);
      UPDATE JXKH_YWLC AS T
         SET SH_DAY = SH_DAY - 1
         WHERE SL_DATE >= date_slrq and SH_DAY >= 1 AND (date_tjrq < JS_DATE AND date_tjrq > SL_DATE);
      UPDATE JXKH_YWLC AS T
         SET PG_DAY = PG_DAY - 1
         WHERE SL_DATE >= date_slrq and PG_DAY >= 1 AND (date_tjrq < PG_DATE AND date_tjrq > JS_DATE);
      UPDATE JXKH_YWLC AS T
         SET FH_DAY = FH_DAY - 1
         WHERE SL_DATE >= date_slrq and FH_DAY >= 1 AND (date_tjrq < FH_DATE AND date_tjrq > greatest(JS_DATE,PG_DATE));
      UPDATE JXKH_YWLC AS T
         SET SRTHS_DAY = SRTHS_DAY - 1
         WHERE SL_DATE >= date_slrq and SRTHS_DAY >= 1 AND (date_tjrq < SRTHS_DATE AND date_tjrq > HZ_DATE);
      UPDATE JXKH_YWLC AS T
         SET KP_DAY = KP_DAY - 1
         WHERE SL_DATE >= date_slrq and KP_DAY >= 1 AND (date_tjrq < KP_DATE AND date_tjrq > SRTHS_DATE);
      UPDATE JXKH_YWLC AS T
         SET TK_DAY = TK_DAY - 1
         WHERE SL_DATE >= date_slrq and TK_DAY >= 1 AND (date_tjrq < TSTK_DATE AND date_tjrq > KP_DATE);

      COMMIT;

      END;

  END LOOP BJTS_FETCH_LOOP_001;
  CLOSE BJTS_FETCH_CURSOR_001;
END;
  DO '完成节假日扣除';

  -- 最后计算核准周期
  UPDATE JXKH_YWLC AS T
     SET SUM_DAY=SUM_DAY - PG_DAY,
    HZ_DAY = greatest(SUM_DAY - PG_DAY - KP_DAY - SRTHS_DAY - FH_DAY - SH_DAY - SL_DAY,0)
     WHERE SL_DATE > date_slrq AND KP_DATE>STR_TO_DATE('1900-01-01', '%Y-%m-%d');
  COMMIT;

  DO '同步成功';
  LEAVE routine_body;

  END$$

DELIMITER ;
