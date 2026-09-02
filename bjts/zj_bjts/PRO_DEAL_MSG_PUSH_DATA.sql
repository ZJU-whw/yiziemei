CREATE OR REPLACE PROCEDURE PRO_DEAL_MSG_PUSH_DATA
/*
 * 提取即将逾期出口退税审核流程、容缺实地核查报告、复函流程、复函处理流程
 * 20250722, 复函处理流程增加回函类型不等于“3-延期回函”的筛选条件。
 * 20250821，复函处理因不在本表回写复函处理日期，暂时取消短信提醒
 * 20260515，根据杭州市局王薇意见，每年4月申报期增加卷烟免税核销的提醒
 * 20260519，根据杭州市局王薇意见，每年4月申报期增加来料加工免税证明核销的提醒
 */
AS
BEGIN
  -- 短信提醒数据
  EXECUTE IMMEDIATE 'TRUNCATE TABLE MSG_PUSH_DATA';
  COMMIT;

  -- 出口退税审核流程
  -- PRO_DEAL_CKTS_LC_TSSB();
  INSERT INTO MSG_PUSH_DATA(ID,SWJG_DM,NSRSBH,NSRMC,BIZTYPE,BIZKEY,QDSJ,JZSJ,YWBZ,SJTBSJ)
       SELECT SEQ_MSG_PUSH_DATA.NEXTVAL,TSSWJG_DM_1,NSRSBH,NSRMC,'退税办理',
              LCSLID,QDSJ,KHJZSJ,
              DECODE(LCSWSX_DM,'LCSXA081038001','免抵退税：'||SSQ||'('||CKQYGLLB_DM||')',
                               'LCSXA081039001','免退税：'||SSQ||'-'||SBPC||'('||CKQYGLLB_DM||')',
                               'LCSXA081042006','退消费税：'||SSQ||'('||CKQYGLLB_DM||')',
                               'LCSXA081042001','已使用设备退税：'||SSQ||'('||CKQYGLLB_DM||')',
                               'LCSXA081042002','购进自用货物退税：'||SSQ||'('||CKQYGLLB_DM||')',
                               'LCSXA081040001','代办退税：'||SSQ||'-'||SBPC||'('||CKQYGLLB_DM||')'),SYSDATE
         FROM CKTS_LC_TSSB T
        WHERE T.LCZT='01';
  COMMIT;

  -- 容缺实地核查流程（新管理办法出台以后，容缺办理已经取消）
/*
  -- PRO_DEAL_FXNK_LC_SDHC();
  INSERT INTO MSG_PUSH_DATA(ID,SWJG_DM,NSRSBH,NSRMC,BIZTYPE,BIZKEY,QDSJ,JZSJ,YWBZ,SJTBSJ)
       SELECT SEQ_MSG_PUSH_DATA.NEXTVAL,TSSWJG_DM_1,NSRSBH,NSRMC,'容缺办理',
              LCSLID,RQQRSJ,COMPUTE_BLJZDATE(NULL,RQQRSJ),
              '实地核查容缺台账编号：'||SDHCRQTZBH,SYSDATE
         FROM CKTS_LC_SDHC T
        WHERE T.LCZT='01';
  COMMIT;
*/
  -- 即将逾期复函
  -- PRO_DEAL_CKTS_HD_JJYQ()
  INSERT INTO MSG_PUSH_DATA(ID,SWJG_DM,NSRSBH,NSRMC,BIZTYPE,BIZKEY,QDSJ,JZSJ,YWBZ,SJTBSJ)
       SELECT SEQ_MSG_PUSH_DATA.NEXTVAL,GHFZGSWJG_DM,GHQYNSRSBH_1,GHFQYMC_1,'函调复函',
              FHXXBUUID,NULL,NVL(YQRQ_1,FUHJZRQ),
              '核实函编号：'||WSBH,SYSDATE
         FROM CKTS_HD_JJYQ;
  COMMIT;

  -- 即将逾期复函处理（金三升级，复函处理不再回写ZH_CKTS_FUHXXB表，已取消）
/*
  INSERT INTO MSG_PUSH_DATA(ID,SWJG_DM,NSRSBH,NSRMC,BIZTYPE,BIZKEY,QDSJ,JZSJ,YWBZ,SJTBSJ)
       SELECT SEQ_MSG_PUSH_DATA.NEXTVAL,H1.FAHDSWJG_DM,F1.GHQYNSRSBH,F1.GHFQYMC,'函调处理',
              H1.FUHXXBUUID,H1.QFRQ,COMPUTE_BLJZDATE('C',H1.QFRQ),
              '【核实函编号】'||H1.HSHBH,SYSDATE
         FROM HX_ZH.ZH_CKTS_FUHXXB H1
        INNER JOIN HX_ZH.ZH_CKTS_FHXXB F1 ON F1.FHXXBUUID=H1.FHXXBUUID
        WHERE H1.FAHDSWJG_DM LIKE '133%' AND H1.FAHDSWJG_DM NOT LIKE '13302%'
          AND NVL(H1.ZFBZ_1,'N')='N'
          AND H1.FHBH IS NOT NULL
          AND H1.DZBZDSZL_DM='BDA1320283' --非向上游发函的回函
          AND NVL(H1.FHLX_DM,'3')<>'3'
          AND H1.FHCLRQ IS NULL
          AND (COMPUTE_BLDATE(SYSDATE,TRUNC(H1.QFRQ)) BETWEEN 5 AND 15);
  COMMIT;
*/
  IF SYSDATE>=TO_DATE(TO_CHAR(SYSDATE,'YYYY')||'0401','YYYYMMDD') AND SYSDATE<TO_DATE(TO_CHAR(SYSDATE,'YYYY')||'0420','YYYYMMDD') THEN
    -- 卷烟免税证明核销提醒
    INSERT INTO MSG_PUSH_DATA(ID,SWJG_DM,NSRSBH,NSRMC,BIZTYPE,BIZKEY,QDSJ,JZSJ,YWBZ,SJTBSJ)
         SELECT SEQ_MSG_PUSH_DATA.NEXTVAL,T.ZGSWJ_DM,T.NSRSBH,T.NSRMC,'免税核销',
                NULL,NULL,TO_DATE(TO_CHAR(SYSDATE,'YYYY')||'0420','YYYYMMDD'),
                '卷烟免税证明核销提醒',SYSDATE
           FROM HX_DJ.DJ_NSRXX T
          WHERE T.DJXH=10113301000049506708 --全省仅中烟公司
            AND NOT EXISTS (SELECT 1 -- 当年不存在已申报未作废的卷烟免税证明核销流程
                              FROM HX_CKTS.CKTS_TY_YWBLXX S
                             WHERE S.DJXH=T.DJXH
                               AND S.LCSWSX_DM='LCSXA081048003' 
                               AND S.QDSJ>=TO_DATE(TO_CHAR(SYSDATE,'YYYY')||'0101','YYYYMMDD')
                               AND S.ZFRQ_1 IS NULL);
    COMMIT;
    
    -- 来料加工免税证明核销提醒
    INSERT INTO MSG_PUSH_DATA(ID,SWJG_DM,NSRSBH,NSRMC,BIZTYPE,BIZKEY,QDSJ,JZSJ,YWBZ,SJTBSJ)
           WITH WHXZM AS (
         SELECT DISTINCT T.DJXH,S.LLJGSZCH,T.LLJGMSZMBH
           FROM HX_CKTS.CKTS_ZM_LLJG_JGB T
          INNER JOIN HX_CKTS.CKTS_ZM_LLJG_JGMXB S ON S.ZBUUID=T.UUID
          WHERE TRUNC(T.KJRQ,'YY')=ADD_MONTHS(TRUNC(SYSDATE,'YY'),-12) AND T.ZFRQ_1 IS NULL --上年度已开具证明及对应手帐册号
            AND EXISTS
                (SELECT 1
                   FROM HX_CKTS.CKTS_WBSJ_HG_DZSCHXXX A
                  WHERE A.DJXH=S.DJXH AND A.BAH=S.LLJGSZCH AND TRUNC(A.JARQ,'YY')=ADD_MONTHS(TRUNC(SYSDATE,'YY'),-12) --手册号上年度核销
                  UNION ALL
                 SELECT 1
                   FROM HX_CKTS.CKTS_WBSJ_HG_DZZCHXXX B
                  WHERE B.DJXH=S.DJXH AND B.BAH=S.LLJGSZCH AND TRUNC(B.HXJZRQ,'YY')=ADD_MONTHS(TRUNC(SYSDATE,'YY'),-12)) --账册号上年度核销
            AND NOT EXISTS
                (SELECT 1
                   FROM HX_CKTS.CKTS_ZM_LLJGHX_JGMXB B
                  WHERE B.DJXH=T.DJXH AND B.LLJGMSZMBH=T.LLJGMSZMBH AND B.JGFFPHM=S.JGFFPHM --证明未核销
                  UNION ALL
                 SELECT 1
                   FROM HX_CKTS.CKTS_ZM_LLJGHX_GCMXB B
                  WHERE B.DJXH=T.DJXH AND B.LLJGMSZMBH=T.LLJGMSZMBH AND B.JGFFPHM=S.JGFFPHM)) --证明未申报
         SELECT SEQ_MSG_PUSH_DATA.NEXTVAL,T.ZGSWJ_DM,T.NSRSBH,T.NSRMC,'免税核销',
                WHXZM.LLJGSZCH||'-'||WHXZM.LLJGMSZMBH,NULL,TO_DATE(TO_CHAR(SYSDATE,'YYYY')||'0420','YYYYMMDD'),
                '卷烟免税证明核销提醒',SYSDATE
           FROM WHXZM
          INNER JOIN HX_DJ.DJ_NSRXX T ON T.DJXH=WHXZM.DJXH;
    COMMIT;
  END IF;

  RETURN;
END;
/
