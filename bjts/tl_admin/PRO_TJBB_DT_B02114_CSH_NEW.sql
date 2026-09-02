CREATE OR REPLACE PROCEDURE PRO_TJBB_DT_B02114_CSH_NEW
/*************************************************
 * 外贸综合服务企业退税情况统计表
 * 返纳数据从金三系统缴款书获取的情形
 * 202302，在B02108基础上调整13号公告为35号公告
 ************************************************/
(
  V_SSNY IN VARCHAR2
)
AS
  LD_SYSDATE         DATE;
  LC_THISMONTH       VARCHAR2(6);
  LD_THISYEAR        DATE;
  LD_NEXTMONTH       DATE;
  LN_BAHS            NUMBER(3);

  FN_YEAR            NUMBER(18,6);
  
  LN_SB_CKE_MON      NUMBER(18,6);
  LN_SB_CKE_YEAR     NUMBER(18,6);
  LN_SB_CKE35_MON    NUMBER(18,6);
  LN_SB_CKE35_YEAR   NUMBER(18,6);
  
  LN_SB_TSE_MON      NUMBER(18,6);
  LN_SB_TSE_YEAR     NUMBER(18,6);
  LN_SB_TSE35_MON    NUMBER(18,6);
  LN_SB_TSE35_YEAR   NUMBER(18,6);
  
  LN_SH_TSE_MON      NUMBER(18,6);
  LN_SH_TSE_YEAR     NUMBER(18,6);
  LN_SH_TSE35_MON    NUMBER(18,6);
  LN_SH_TSE35_YEAR   NUMBER(18,6);
  
  LN_BYBL_TSE_MON    NUMBER(18,6);
  LN_BYBL_TSE_YEAR   NUMBER(18,6);
  LN_BYBL_TSE35_MON  NUMBER(18,6);
  LN_BYBL_TSE35_YEAR NUMBER(18,6);
  
  LN_SP_TSE_MON      NUMBER(18,6);
  LN_SP_TSE_YEAR     NUMBER(18,6);
  LN_SP_TSE35_MON    NUMBER(18,6);
  LN_SP_TSE35_YEAR   NUMBER(18,6);
  
  LN_YS_TKE_YEAR     NUMBER(18,6);
  LN_YS_TKE35_YEAR   NUMBER(18,6);
BEGIN
  IF V_SSNY IS NOT NULL THEN
    LD_SYSDATE:=TO_DATE(V_SSNY||'01','YYYYMMDD');
  ELSE
    LD_SYSDATE:=TRUNC(SYSDATE,'MM');
  END IF;
  LC_THISMONTH :=TO_CHAR(LD_SYSDATE,'YYYYMM');
  LD_THISYEAR  :=TRUNC(LD_SYSDATE,'YY');
  LD_NEXTMONTH :=TRUNC(ADD_MONTHS(LD_SYSDATE,1),'MM');
  LN_BAHS:=0;

  --0、清除原有制表数据，准备重新制表
  BEGIN
    DELETE FROM TJBB_DT_B02114 WHERE SSNY=LC_THISMONTH;
    COMMIT;
  END;

  --1、统计
  FOR LSF_WZFQY IN (SELECT DJXH_JS, NVL(SHXYNO,NSRDJNO) AS NSRSBH, NSRMC, SWJGDM
                      FROM TL_TSSH.GLXT_BB_SHXT_DJXX T
                     WHERE ZX_FLAG ='N' AND T.BAJC_YEAR IN ('71','72')
                     ORDER BY SWJGDM, DJXH_JS) LOOP
    BEGIN
      LN_BAHS:=LN_BAHS +1;
      
      -- 返纳
      SELECT NVL(ROUND(SUM(SJJE)/10000,6),0)
        INTO FN_YEAR
        FROM FG_CKTSFN_HXZG T
       WHERE T.DJXH=LSF_WZFQY.DJXH_JS
         AND T.RKRQ>=LD_THISYEAR
         AND T.RKRQ<LD_NEXTMONTH;

      -- 申报退税出口额 (万美元)
      SELECT ROUND(NVL(SUM(CASE WHEN T.LCJSRQ>=LD_SYSDATE THEN T.MYLAJ ELSE 0 END),0)/10000,6), 
             ROUND(NVL(SUM(T.MYLAJ),0)/10000,6), 
             ROUND(NVL(SUM(CASE WHEN T.LCTJJC='72' AND T.LCJSRQ>=LD_SYSDATE THEN T.MYLAJ ELSE 0 END),0)/10000,6),
             ROUND(NVL(SUM(CASE WHEN T.LCTJJC='72' THEN T.MYLAJ ELSE 0 END),0)/10000,6)
        INTO LN_SB_CKE_MON, LN_SB_CKE_YEAR, LN_SB_CKE35_MON, LN_SB_CKE35_YEAR
        FROM (SELECT A.LCJSRQ,A.LCTJJC,B.LCSLID,B.SBXH,
                     B.MYLAJ * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN 1 
                                    WHEN A.ZY_MDTSE=0 THEN 0
                                    WHEN A.SNBL_MDTSE=0 THEN 1
                                    WHEN A.SNBL_MDTSE>0 AND (B.ZBBLBZ='Y' OR B.BYTSBZ='Y') THEN 0
                                    ELSE LEAST(GREATEST(1 - A.SNBL_MDTSE / A.ZY_MDTSE,0),1)
                               END AS MYLAJ
                FROM TL_TSSH.CKTS_LC_SHXX A
               INNER JOIN TL_TSSH.CKTS_SB_MTS_CKMX B ON B.LCSLID=A.LCSLID AND B.BYBLBZ='N'
               WHERE A.DJXH=LSF_WZFQY.DJXH_JS
                 AND A.LCTJJC IN ('70','71')
                 AND A.QDSJ<LD_NEXTMONTH
                 AND A.LCJSRQ>=LD_THISYEAR
               UNION ALL
              SELECT A.LCJSRQ,A.LCTJJC,B.LCSLID,B.SBXH,
                     B.MYLAJ * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN 1 
                                    WHEN A.ZY_MDTSE=0 THEN 0
                                    WHEN A.SNBL_MDTSE=0 THEN 1
                                    WHEN A.SNBL_MDTSE>0 AND (B.ZBBLBZ='Y' OR B.BYTSBZ='Y') THEN 0
                                    ELSE LEAST(GREATEST(1 - A.SNBL_MDTSE / A.ZY_MDTSE,0),1)
                               END AS MYLAJ
                FROM TL_TSSH.CKTS_LC_SHXX A
               INNER JOIN TL_TSSH.CKTS_SB_WZF_CKMX B ON B.LCSLID=A.LCSLID AND B.BYBLBZ='N'
               WHERE A.DJXH=LSF_WZFQY.DJXH_JS
                 AND A.LCTJJC = '72'
                 AND A.QDSJ<LD_NEXTMONTH
                 AND A.LCJSRQ>=LD_THISYEAR) T;
      
      --申报、审核通过、暂缓、不予、在途退税额
      SELECT ROUND(NVL(SUM(CASE WHEN T.LCJSRQ>=LD_SYSDATE THEN T.TSE ELSE 0 END),0)/10000,6), --申报退税额
             ROUND(NVL(SUM(T.TSE),0)/10000,6), --申报退税额
             ROUND(NVL(SUM(CASE WHEN T.LCTJJC='72' AND T.LCJSRQ>=LD_SYSDATE THEN T.TSE ELSE 0 END),0)/10000,6), --申报退税额
             ROUND(NVL(SUM(CASE WHEN T.LCTJJC='72' THEN T.TSE ELSE 0 END),0)/10000,6), --申报退税额
             ROUND(NVL(SUM(CASE WHEN T.SHZT=30 AND T.LCJSRQ>=LD_SYSDATE THEN T.TSE ELSE 0 END),0)/10000,6), --审核通过
             ROUND(NVL(SUM(CASE WHEN T.SHZT=30 THEN T.TSE ELSE 0 END),0)/10000,6), --审核通过
             ROUND(NVL(SUM(CASE WHEN T.SHZT=30 AND T.LCTJJC='72' AND T.LCJSRQ>=LD_SYSDATE THEN T.TSE ELSE 0 END),0)/10000,6), --审核通过
             ROUND(NVL(SUM(CASE WHEN T.SHZT=30 AND T.LCTJJC='72' THEN T.TSE ELSE 0 END),0)/10000,6), --审核通过
             ROUND(NVL(SUM(CASE WHEN T.SHZT=20 AND T.LCJSRQ>=LD_SYSDATE THEN T.TSE ELSE 0 END),0)/10000,6), --不予
             ROUND(NVL(SUM(CASE WHEN T.SHZT=20 THEN T.TSE ELSE 0 END),0)/10000,6), --不予
             ROUND(NVL(SUM(CASE WHEN T.SHZT=20 AND T.LCTJJC='72' AND T.LCJSRQ>=LD_SYSDATE THEN T.TSE ELSE 0 END),0)/10000,6), --不予
             ROUND(NVL(SUM(CASE WHEN T.SHZT=20 AND T.LCTJJC='72' THEN T.TSE ELSE 0 END),0)/10000,6) --不予
        INTO LN_SB_TSE_MON, LN_SB_TSE_YEAR, LN_SB_TSE35_MON, LN_SB_TSE35_YEAR,
             LN_SH_TSE_MON, LN_SH_TSE_YEAR, LN_SH_TSE35_MON, LN_SH_TSE35_YEAR,
             LN_BYBL_TSE_MON, LN_BYBL_TSE_YEAR, LN_BYBL_TSE35_MON, LN_BYBL_TSE35_YEAR
        FROM (SELECT B.DJXH,B.SBXH,B.CKRQ_1,B.SZ,A.LCJSRQ,A.LCTJJC,
                     CASE WHEN TRIM(A.LCSLID_FS) IS NOT NULL AND B.ZBBLBZ='Y' THEN 10 
                          WHEN TRIM(A.LCSLID_FS) IS NOT NULL AND B.BYTSBZ='Y' THEN 20 
                          WHEN TRIM(A.LCSLID_FS) IS NOT NULL THEN 30 
                          WHEN TRIM(A.LCSLID_FS) IS NULL AND A.LCSLID_SB<>A.LCSLID THEN 10 
                          ELSE 40 END AS SHZT, 
                     B.TSE * CASE WHEN B.SZ='V' THEN (CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN 1 
                                                           WHEN A.ZY_ZZSTSE=0 THEN 0
                                                           WHEN A.SNBL_ZZSTSE=0 THEN 1
                                                           WHEN A.SNBL_ZZSTSE>0 AND (B.ZBBLBZ='Y' OR B.BYTSBZ='Y') THEN 0
                                                           ELSE LEAST(GREATEST(1 - A.SNBL_ZZSTSE / A.ZY_ZZSTSE,0),1)
                                                      END)
                             ELSE (CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN 1 
                                        WHEN A.ZY_XFSTSE=0 THEN 0
                                        WHEN A.SNBL_XFSTSE=0 THEN 1
                                        WHEN A.SNBL_XFSTSE>0 AND (B.ZBBLBZ='Y' OR B.BYTSBZ='Y') THEN 0
                                        ELSE LEAST(GREATEST(1 - A.SNBL_XFSTSE / A.ZY_XFSTSE,0),1)
                                   END)
                             END AS TSE
                FROM TL_TSSH.CKTS_LC_SHXX A
               INNER JOIN TL_TSSH.CKTS_SB_MTS_JHMX B ON B.LCSLID=A.LCSLID AND B.BYBLBZ='N'
               WHERE A.DJXH=LSF_WZFQY.DJXH_JS
                 AND A.LCTJJC IN ('70','71')
                 AND A.QDSJ<LD_NEXTMONTH
                 AND A.LCJSRQ>=LD_THISYEAR
               UNION ALL
              SELECT B.DJXH,B.SBXH,B.CKRQ_1,'V' AS SZ,A.LCJSRQ,A.LCTJJC,
                     CASE WHEN TRIM(A.LCSLID_FS) IS NOT NULL AND B.ZBBLBZ='Y' THEN 10 
                          WHEN TRIM(A.LCSLID_FS) IS NOT NULL AND B.BYTSBZ='Y' THEN 20 
                          WHEN TRIM(A.LCSLID_FS) IS NOT NULL THEN 30 
                          WHEN TRIM(A.LCSLID_FS) IS NULL AND A.LCSLID_SB<>A.LCSLID THEN 10 
                          ELSE 40 END AS SHZT, 
                     B.TSE * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN 1 
                                  WHEN A.ZY_MDTSE=0 THEN 0
                                  WHEN A.SNBL_MDTSE=0 THEN 1
                                  WHEN A.SNBL_MDTSE>0 AND (B.ZBBLBZ='Y' OR B.BYTSBZ='Y') THEN 0
                                  ELSE LEAST(GREATEST(1 - A.SNBL_MDTSE / A.ZY_MDTSE,0),1)
                             END AS TSE
                FROM TL_TSSH.CKTS_LC_SHXX A
               INNER JOIN TL_TSSH.CKTS_SB_WZF_CKMX B ON B.LCSLID=A.LCSLID AND B.BYBLBZ='N'
               WHERE A.DJXH=LSF_WZFQY.DJXH_JS
                 AND A.LCTJJC = '72'
                 AND A.QDSJ<LD_NEXTMONTH
                 AND A.LCJSRQ>=LD_THISYEAR) T;

      --审批、移送国库、国库办理
      SELECT ROUND(NVL(SUM(CASE WHEN T.SEHZRQ>=LD_SYSDATE THEN T.SEHZ_ZZSTSE+T.SEHZ_XFSTSE ELSE 0 END),0)/10000,6), --审批
             ROUND(NVL(SUM(T.SEHZ_ZZSTSE+T.SEHZ_XFSTSE),0)/10000,6), --审批
             ROUND(NVL(SUM(CASE WHEN T.LCTJJC='72' AND T.SEHZRQ>=LD_SYSDATE THEN T.SEHZ_ZZSTSE+T.SEHZ_XFSTSE ELSE 0 END),0)/10000,6), --审批
             ROUND(NVL(SUM(CASE WHEN T.LCTJJC='72' THEN T.SEHZ_ZZSTSE+T.SEHZ_XFSTSE ELSE 0 END),0)/10000,6), --审批
             ROUND(NVL(SUM(CASE WHEN T.XHRQ_TK<LD_NEXTMONTH THEN T.GKBL_ZZSTSE+T.GKBL_XFSTSE ELSE 0 END),0)/10000,6), --移送国库
             ROUND(NVL(SUM(CASE WHEN T.LCTJJC='72' AND T.XHRQ_TK<LD_NEXTMONTH THEN T.GKBL_ZZSTSE+T.GKBL_XFSTSE ELSE 0 END),0)/10000,6) --移送国库
        INTO LN_SP_TSE_MON, LN_SP_TSE_YEAR, LN_SP_TSE35_MON, LN_SP_TSE35_YEAR, 
             LN_YS_TKE_YEAR, LN_YS_TKE35_YEAR
        FROM TL_TSSH.CKTS_LC_SEHZXX T
       WHERE T.DJXH=LSF_WZFQY.DJXH_JS
         AND T.LCTJJC IN ('70','71','72')
         AND T.XHRQ_TK>=LD_THISYEAR
         AND T.SEHZRQ<LD_NEXTMONTH;

      INSERT INTO TJBB_DT_B02114 (SSNY, BBLC, SWJGDM, XH, NSRMC, NSRSBH,
             SB_CKE_MON, SB_CKE_YEAR, SB_CKE35_MON, SB_CKE35_YEAR, 
             SB_TSE_MON, SB_TSE_YEAR, SB_TSE35_MON, SB_TSE35_YEAR,
             SH_TSE_MON, SH_TSE_YEAR, SH_TSE35_MON, SH_TSE35_YEAR,
             BYBL_TSE_MON, BYBL_TSE_YEAR, BYBL_TSE35_MON, BYBL_TSE35_YEAR,
             SHZT_TSE_XJ, SHZT_TSE35_XJ, 
             SP_TSE_MON, SP_TSE_YEAR, SP_TSE35_MON, SP_TSE35_YEAR, 
             YS_TKE_YEAR, YS_TKE35_YEAR, 
             WS_TKE_YEAR, WS_TKE35_YEAR, 
             BL_TKE_YEAR, BL_TKE35_YEAR, 
             ZT_TKE_YEAR, ZT_TKE35_YEAR)
      SELECT LC_THISMONTH, SUBSTR('000000'||LN_BAHS, LENGTH('000000'||LN_BAHS)-5, 6), LSF_WZFQY.SWJGDM, LN_BAHS, LSF_WZFQY.NSRMC, LSF_WZFQY.NSRSBH,
             LN_SB_CKE_MON, LN_SB_CKE_YEAR, LN_SB_CKE35_MON, LN_SB_CKE35_YEAR, 
             LN_SB_TSE_MON, LN_SB_TSE_YEAR, LN_SB_TSE35_MON, LN_SB_TSE35_YEAR,
             LN_SH_TSE_MON, LN_SH_TSE_YEAR, LN_SH_TSE35_MON, LN_SH_TSE35_YEAR,
             LN_BYBL_TSE_MON, LN_BYBL_TSE_YEAR, LN_BYBL_TSE35_MON, LN_BYBL_TSE35_YEAR,
             LN_SB_TSE_YEAR - LN_SH_TSE_YEAR - LN_BYBL_TSE_YEAR, LN_SB_TSE35_YEAR - LN_SH_TSE35_YEAR - LN_BYBL_TSE35_YEAR, 
             LN_SP_TSE_MON, LN_SP_TSE_YEAR, LN_SP_TSE35_MON, LN_SP_TSE35_YEAR, 
             LN_YS_TKE_YEAR - FN_YEAR, LN_YS_TKE35_YEAR, 
             0, 0, 
             LN_YS_TKE_YEAR - FN_YEAR, LN_YS_TKE35_YEAR, 
             0, 0
        FROM DUAL;
        COMMIT;
    END;
  END LOOP;

  RETURN;
END;
/
