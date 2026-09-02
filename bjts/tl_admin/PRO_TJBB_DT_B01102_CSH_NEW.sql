CREATE OR REPLACE PROCEDURE PRO_TJBB_DT_B01102_CSH_NEW
/*************************************************
 * 不予办理退（免）税统计月报表
 * 202202，针对同时申报出口货物劳务以及服务贸易的企业，调整lctjjc
 ************************************************/
(
  V_SWCODE  IN  VARCHAR2,
  V_SSNY IN VARCHAR2,
  V_ERROR   OUT NUMBER,
  V_MSG     OUT VARCHAR2
)
AS
  LD_SYSDATE       DATE;
  LC_THISMONTH     VARCHAR2(6);
  LD_THISYEAR      DATE;
  LD_NEXTMONTH     DATE;

  LN_BAHS          NUMBER(10);
  LN_SBHS          NUMBER(10);
  LN_BY_ZZS_HIS    NUMBER(18,6);
  LN_BY_ZZS_CUR    NUMBER(18,6);
  LN_BY_XFS_HIS    NUMBER(18,6);
  LN_BY_XFS_CUR    NUMBER(18,6);

  LC_SQL           VARCHAR2(4000);
  LC_SQL_UPDATEHZ  VARCHAR2(4000);
BEGIN
  V_ERROR :=0;
  V_MSG   := ' ';
  
  IF V_SSNY IS NOT NULL THEN
    LD_SYSDATE:=TO_DATE(V_SSNY||'01','YYYYMMDD');
  ELSE
    LD_SYSDATE:=TRUNC(SYSDATE,'MM');
  END IF;
  LC_THISMONTH :=TO_CHAR(LD_SYSDATE,'YYYYMM');
  LD_THISYEAR  :=TRUNC(LD_SYSDATE,'YY');
  LD_NEXTMONTH :=TRUNC(ADD_MONTHS(LD_SYSDATE,1),'MM');

  --0、初始化
  BEGIN
    --清除原有制表数据、准备重新制表
    DELETE FROM TJBB_DT_B01102 WHERE SWJGDM=V_SWCODE AND SSNY=LC_THISMONTH;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      V_ERROR := SQLCODE;
      V_MSG   := SQLERRM;
      RETURN;
  END;

  --1-1、外贸企业
  BEGIN
    SELECT COUNT(DISTINCT DJXH), COUNT(DISTINCT(CASE WHEN T.SZ='V' THEN DJXH ELSE NULL END)),
           ROUND(NVL(SUM(CASE WHEN T.SZ='V' AND T.CKRQ_1< LD_THISYEAR THEN T.TSE ELSE 0 END),0)/10000,6), --不予
           ROUND(NVL(SUM(CASE WHEN T.SZ='V' AND T.CKRQ_1>=LD_THISYEAR THEN T.TSE ELSE 0 END),0)/10000,6), --不予
           ROUND(NVL(SUM(CASE WHEN T.SZ='C' AND T.CKRQ_1< LD_THISYEAR THEN T.TSE ELSE 0 END),0)/10000,6), --不予
           ROUND(NVL(SUM(CASE WHEN T.SZ='C' AND T.CKRQ_1>=LD_THISYEAR THEN T.TSE ELSE 0 END),0)/10000,6) --不予
      INTO LN_BAHS, LN_SBHS, LN_BY_ZZS_HIS, LN_BY_ZZS_CUR, LN_BY_XFS_HIS, LN_BY_XFS_CUR
      FROM (SELECT A.DJXH,B.SBXH,B.CKRQ_1,B.SZ,
                   CASE WHEN TRIM(A.LCSLID_FS) IS NOT NULL AND B.ZBBLBZ='Y' THEN 14 
                        WHEN TRIM(A.LCSLID_FS) IS NOT NULL AND B.BYTSBZ='Y' THEN 20 
                        WHEN TRIM(A.LCSLID_FS) IS NOT NULL THEN 30 
                        WHEN TRIM(A.LCSLID_FS) IS NULL AND A.LCSLID_SB<>A.LCSLID THEN 11 
                        ELSE 40 END AS SHZT, 
                   B.TSE * CASE WHEN B.SZ='V' THEN (CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN 1 
                                                         WHEN A.ZY_ZZSTSE=0 THEN 1
                                                         WHEN A.SNBL_ZZSTSE=0 THEN 1
                                                         WHEN A.SNBL_ZZSTSE>0 AND (B.ZBBLBZ='Y' OR B.BYTSBZ='Y') THEN 0
                                                         ELSE LEAST(GREATEST(1 - A.SNBL_ZZSTSE / A.ZY_ZZSTSE,0),1)
                                                    END)
                           ELSE (CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN 1 
                                      WHEN A.ZY_XFSTSE=0 THEN 1
                                      WHEN A.SNBL_XFSTSE=0 THEN 1
                                      WHEN A.SNBL_XFSTSE>0 AND (B.ZBBLBZ='Y' OR B.BYTSBZ='Y') THEN 0
                                      ELSE LEAST(GREATEST(1 - A.SNBL_XFSTSE / A.ZY_XFSTSE,0),1)
                                 END)
                           END AS TSE
              FROM TL_TSSH.CKTS_LC_SHXX A
             INNER JOIN TL_TSSH.CKTS_SB_MTS_JHMX B ON B.LCSLID=A.LCSLID AND B.BYBLBZ='N'
             WHERE A.TSSWJG_DM=V_SWCODE
               AND A.LCTJJC IN ('10','40','50')
               AND A.QDSJ<LD_NEXTMONTH
               AND A.LCJSRQ>=LD_THISYEAR) T
     WHERE T.SHZT = '20';

    INSERT INTO TJBB_DT_B01102 (SSNY, BBLC, SWJGDM,
           HJ_QYHS, HJ_TSE,
           HH_QYHS, HH_TSE_XJ, HH_TSE_HIS, HH_TSE_CUR,
           BA_QYHS, BA_TSE_XJ, BA_TSE_HIS, BA_TSE_CUR,
           PZ_QYHS, PZ_TSE_XJ, PZ_TSE_HIS, PZ_TSE_CUR,
           DL_QYHS, DL_TSE_XJ, DL_TSE_HIS, DL_TSE_CUR,
           SH_QYHS, SH_TSE_XJ, SH_TSE_HIS, SH_TSE_CUR,
           DC_QYHS, DC_TSE_XJ, DC_TSE_HIS, DC_TSE_CUR,
           QT_QYHS, QT_TSE_XJ, QT_TSE_HIS, QT_TSE_CUR)
    SELECT LC_THISMONTH, '05', V_SWCODE, 
           LN_SBHS, LN_BY_ZZS_HIS + LN_BY_ZZS_CUR, 
           LN_SBHS, LN_BY_ZZS_HIS + LN_BY_ZZS_CUR, LN_BY_ZZS_HIS, LN_BY_ZZS_CUR,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0
      FROM DUAL
     UNION ALL
    SELECT LC_THISMONTH, '06', V_SWCODE, 
           LN_BAHS - LN_SBHS, LN_BY_XFS_HIS + LN_BY_XFS_CUR, 
           LN_BAHS - LN_SBHS, LN_BY_XFS_HIS + LN_BY_XFS_CUR, LN_BY_XFS_HIS, LN_BY_XFS_CUR, 
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0
      FROM DUAL;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      V_ERROR := SQLCODE;
      V_MSG   := SQLERRM;
  END;

  --1-2、外综服企业
  BEGIN
    SELECT COUNT(DISTINCT DJXH), COUNT(DISTINCT(CASE WHEN T.SZ='V' THEN DJXH ELSE NULL END)),
           ROUND(NVL(SUM(CASE WHEN T.SZ='V' AND T.CKRQ_1< LD_THISYEAR THEN T.TSE ELSE 0 END),0)/10000,6), --不予
           ROUND(NVL(SUM(CASE WHEN T.SZ='V' AND T.CKRQ_1>=LD_THISYEAR THEN T.TSE ELSE 0 END),0)/10000,6), --不予
           ROUND(NVL(SUM(CASE WHEN T.SZ='C' AND T.CKRQ_1< LD_THISYEAR THEN T.TSE ELSE 0 END),0)/10000,6), --不予
           ROUND(NVL(SUM(CASE WHEN T.SZ='C' AND T.CKRQ_1>=LD_THISYEAR THEN T.TSE ELSE 0 END),0)/10000,6) --不予
      INTO LN_BAHS, LN_SBHS, LN_BY_ZZS_HIS, LN_BY_ZZS_CUR, LN_BY_XFS_HIS, LN_BY_XFS_CUR
      FROM (SELECT A.DJXH,B.SBXH,B.CKRQ_1,B.SZ,
                   CASE WHEN TRIM(A.LCSLID_FS) IS NOT NULL AND B.ZBBLBZ='Y' THEN 14 
                        WHEN TRIM(A.LCSLID_FS) IS NOT NULL AND B.BYTSBZ='Y' THEN 20 
                        WHEN TRIM(A.LCSLID_FS) IS NOT NULL THEN 30 
                        WHEN TRIM(A.LCSLID_FS) IS NULL AND A.LCSLID_SB<>A.LCSLID THEN 11 
                        ELSE 40 END AS SHZT, 
                   B.TSE * CASE WHEN B.SZ='V' THEN (CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN 1 
                                                         WHEN A.ZY_ZZSTSE=0 THEN 1
                                                         WHEN A.SNBL_ZZSTSE=0 THEN 1
                                                         WHEN A.SNBL_ZZSTSE>0 AND (B.ZBBLBZ='Y' OR B.BYTSBZ='Y') THEN 0
                                                         ELSE LEAST(GREATEST(1 - A.SNBL_ZZSTSE / A.ZY_ZZSTSE,0),1)
                                                    END)
                           ELSE (CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN 1 
                                      WHEN A.ZY_XFSTSE=0 THEN 1
                                      WHEN A.SNBL_XFSTSE=0 THEN 1
                                      WHEN A.SNBL_XFSTSE>0 AND (B.ZBBLBZ='Y' OR B.BYTSBZ='Y') THEN 0
                                      ELSE LEAST(GREATEST(1 - A.SNBL_XFSTSE / A.ZY_XFSTSE,0),1)
                                 END)
                           END AS TSE
              FROM TL_TSSH.CKTS_LC_SHXX A
             INNER JOIN TL_TSSH.CKTS_SB_MTS_JHMX B ON B.LCSLID=A.LCSLID AND B.BYBLBZ='N'
             WHERE A.TSSWJG_DM=V_SWCODE
               AND A.LCTJJC IN ('70','71')
               AND A.QDSJ<LD_NEXTMONTH
               AND A.LCJSRQ>=LD_THISYEAR
             UNION ALL
            SELECT A.DJXH,B.SBXH,B.CKRQ_1,'V' AS SZ,
                   CASE WHEN TRIM(A.LCSLID_FS) IS NOT NULL AND B.ZBBLBZ='Y' THEN 14 
                        WHEN TRIM(A.LCSLID_FS) IS NOT NULL AND B.BYTSBZ='Y' THEN 20 
                        WHEN TRIM(A.LCSLID_FS) IS NOT NULL THEN 30 
                        WHEN TRIM(A.LCSLID_FS) IS NULL AND A.LCSLID_SB<>A.LCSLID THEN 11 
                        ELSE 40 END AS SHZT, 
                   B.TSE * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN 1 
                                WHEN A.ZY_MDTSE=0 THEN 1
                                WHEN A.SNBL_MDTSE=0 THEN 1
                                WHEN A.SNBL_MDTSE>0 AND (B.ZBBLBZ='Y' OR B.BYTSBZ='Y') THEN 0
                                ELSE LEAST(GREATEST(1 - A.SNBL_MDTSE / A.ZY_MDTSE,0),1)
                           END AS TSE
              FROM TL_TSSH.CKTS_LC_SHXX A
             INNER JOIN TL_TSSH.CKTS_SB_WZF_CKMX B ON B.LCSLID=A.LCSLID AND B.BYBLBZ='N'
             WHERE A.TSSWJG_DM=V_SWCODE
               AND A.LCTJJC = '72'
               AND A.QDSJ<LD_NEXTMONTH
               AND A.LCJSRQ>=LD_THISYEAR) T
     WHERE T.SHZT = '20';

    INSERT INTO TJBB_DT_B01102 (SSNY, BBLC, SWJGDM,
           HJ_QYHS, HJ_TSE,
           HH_QYHS, HH_TSE_XJ, HH_TSE_HIS, HH_TSE_CUR,
           BA_QYHS, BA_TSE_XJ, BA_TSE_HIS, BA_TSE_CUR,
           PZ_QYHS, PZ_TSE_XJ, PZ_TSE_HIS, PZ_TSE_CUR,
           DL_QYHS, DL_TSE_XJ, DL_TSE_HIS, DL_TSE_CUR,
           SH_QYHS, SH_TSE_XJ, SH_TSE_HIS, SH_TSE_CUR,
           DC_QYHS, DC_TSE_XJ, DC_TSE_HIS, DC_TSE_CUR,
           QT_QYHS, QT_TSE_XJ, QT_TSE_HIS, QT_TSE_CUR)
    SELECT LC_THISMONTH, '08', V_SWCODE, 
           LN_SBHS, LN_BY_ZZS_HIS + LN_BY_ZZS_CUR, 
           LN_SBHS, LN_BY_ZZS_HIS + LN_BY_ZZS_CUR, LN_BY_ZZS_HIS, LN_BY_ZZS_CUR,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0
      FROM DUAL
     UNION ALL
    SELECT LC_THISMONTH, '09', V_SWCODE, 
           LN_BAHS - LN_SBHS, LN_BY_XFS_HIS + LN_BY_XFS_CUR, 
           LN_BAHS - LN_SBHS, LN_BY_XFS_HIS + LN_BY_XFS_CUR, LN_BY_XFS_HIS, LN_BY_XFS_CUR, 
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0
      FROM DUAL;

    -- 1-2-1 符合13号公告规定业务
    SELECT COUNT(DISTINCT DJXH), 
           ROUND(NVL(SUM(CASE WHEN T.CKRQ_1< LD_THISYEAR THEN T.TSE ELSE 0 END),0)/10000,6), --不予
           ROUND(NVL(SUM(CASE WHEN T.CKRQ_1>=LD_THISYEAR THEN T.TSE ELSE 0 END),0)/10000,6) --不予
      INTO LN_SBHS, LN_BY_ZZS_HIS, LN_BY_ZZS_CUR
      FROM (SELECT A.DJXH,B.SBXH,B.CKRQ_1,B.SZ,
                   CASE WHEN TRIM(A.LCSLID_FS) IS NOT NULL AND B.ZBBLBZ='Y' THEN 14 
                        WHEN TRIM(A.LCSLID_FS) IS NOT NULL AND B.BYTSBZ='Y' THEN 20 
                        WHEN TRIM(A.LCSLID_FS) IS NOT NULL THEN 30 
                        WHEN TRIM(A.LCSLID_FS) IS NULL AND A.LCSLID_SB<>A.LCSLID THEN 11 
                        ELSE 40 END AS SHZT, 
                   B.TSE * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN 1 
                                  WHEN A.ZY_MDTSE=0 THEN 1
                                  WHEN A.SNBL_MDTSE=0 THEN 1
                                  WHEN A.SNBL_MDTSE>0 AND (B.ZBBLBZ='Y' OR B.BYTSBZ='Y') THEN 0
                                  ELSE LEAST(GREATEST(1 - A.SNBL_MDTSE / A.ZY_MDTSE,0),1)
                             END AS TSE
              FROM TL_TSSH.CKTS_LC_SHXX A
             INNER JOIN TL_TSSH.CKTS_SB_MTS_JHMX B ON B.LCSLID=A.LCSLID AND B.BYBLBZ='N'
             WHERE A.TSSWJG_DM=V_SWCODE
               AND A.LCTJJC = '71'
               AND A.QDSJ<LD_NEXTMONTH
               AND A.LCJSRQ>=LD_THISYEAR) T
     WHERE T.SHZT = '20';

    INSERT INTO TJBB_DT_B01102 (SSNY, BBLC, SWJGDM,
           HJ_QYHS, HJ_TSE,
           HH_QYHS, HH_TSE_XJ, HH_TSE_HIS, HH_TSE_CUR,
           BA_QYHS, BA_TSE_XJ, BA_TSE_HIS, BA_TSE_CUR,
           PZ_QYHS, PZ_TSE_XJ, PZ_TSE_HIS, PZ_TSE_CUR,
           DL_QYHS, DL_TSE_XJ, DL_TSE_HIS, DL_TSE_CUR,
           SH_QYHS, SH_TSE_XJ, SH_TSE_HIS, SH_TSE_CUR,
           DC_QYHS, DC_TSE_XJ, DC_TSE_HIS, DC_TSE_CUR,
           QT_QYHS, QT_TSE_XJ, QT_TSE_HIS, QT_TSE_CUR)
    SELECT LC_THISMONTH, '10', V_SWCODE, 
           LN_SBHS, LN_BY_ZZS_HIS + LN_BY_ZZS_CUR, 
           LN_SBHS, LN_BY_ZZS_HIS + LN_BY_ZZS_CUR, LN_BY_ZZS_HIS, LN_BY_ZZS_CUR, 
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0
      FROM DUAL;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      V_ERROR := SQLCODE;
      V_MSG   := SQLERRM;
  END;

  --1-3、自营出口的生产企业
  BEGIN
    SELECT COUNT(DISTINCT DJXH), COUNT(DISTINCT(CASE WHEN T.TSE>0 THEN DJXH ELSE NULL END)),
           ROUND(NVL(SUM(CASE WHEN T.CKRQ_1< LD_THISYEAR THEN T.TSE ELSE 0 END),0)/10000,6), --不予
           ROUND(NVL(SUM(CASE WHEN T.CKRQ_1>=LD_THISYEAR THEN T.TSE ELSE 0 END),0)/10000,6), --不予
           ROUND(NVL(SUM(CASE WHEN T.CKRQ_1< LD_THISYEAR THEN T.MDE ELSE 0 END),0)/10000,6), --不予
           ROUND(NVL(SUM(CASE WHEN T.CKRQ_1>=LD_THISYEAR THEN T.MDE ELSE 0 END),0)/10000,6) --不予
      INTO LN_BAHS, LN_SBHS, LN_BY_ZZS_HIS, LN_BY_ZZS_CUR, LN_BY_XFS_HIS, LN_BY_XFS_CUR
      FROM (SELECT A.DJXH,B.LCSLID,B.SBXH,B.CKRQ_1,
                   CASE WHEN TRIM(A.LCSLID_FS) IS NOT NULL AND B.ZBBLBZ='Y' THEN 14 
                        WHEN TRIM(A.LCSLID_FS) IS NOT NULL AND B.BYTSBZ='Y' THEN 20 
                        WHEN TRIM(A.LCSLID_FS) IS NOT NULL THEN 30 
                        WHEN TRIM(A.LCSLID_FS) IS NULL AND A.LCSLID_SB<>A.LCSLID THEN 14 --生产企业全部归类为：有疑点核查中 
                        ELSE 40 END AS SHZT, 
                   B.MYLAJ * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN 1 
                                  WHEN A.ZY_MDTSE=0 THEN 1
                                  WHEN A.SNBL_MDTSE=0 THEN 1
                                  WHEN A.SNBL_MDTSE>0 AND (B.ZBBLBZ='Y' OR B.BYTSBZ='Y') THEN 0
                                  ELSE LEAST(GREATEST(1 - A.SNBL_MDTSE / A.ZY_MDTSE,0),1)
                             END AS MYLAJ,
                   B.MDTSE * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN (CASE WHEN A.SB_MDTSE=0 THEN 0 ELSE A.SB_ZZSTSE/A.SB_MDTSE END)
                                                           ELSE (CASE WHEN A.ZY_MDTSE=0 THEN 0 ELSE A.ZY_ZZSTSE/A.ZY_MDTSE END) 
                             END --根据是否复审用申报数或复审数计算退税部分
                           * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN 1 
                                  WHEN A.ZY_ZZSTSE=0 THEN 1
                                  WHEN A.SNBL_ZZSTSE=0 THEN 1 
                                  WHEN A.SNBL_ZZSTSE>0 AND (B.ZBBLBZ='Y' OR B.BYTSBZ='Y') THEN 0
                                  ELSE LEAST(GREATEST(1 - A.SNBL_ZZSTSE / A.ZY_ZZSTSE,0),1) 
                             END AS TSE,
                   B.MDTSE * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN (CASE WHEN A.SB_MDTSE=0 THEN 1 ELSE A.SB_MDSE/A.SB_MDTSE END)
                                                           ELSE (CASE WHEN A.ZY_MDTSE=0 THEN 1 ELSE A.ZY_MDSE/A.ZY_MDTSE END) 
                             END
                           * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN 1 
                                  WHEN A.ZY_MDSE=0 THEN 1
                                  WHEN A.SNBL_MDSE=0 THEN 1 
                                  WHEN A.SNBL_MDSE>0 AND (B.ZBBLBZ='Y' OR B.BYTSBZ='Y') THEN 0
                                  ELSE LEAST(GREATEST(1 - A.SNBL_MDSE / A.ZY_MDSE,0),1) 
                             END AS MDE
              FROM TL_TSSH.CKTS_LC_SHXX A
             INNER JOIN TL_TSSH.CKTS_SB_MDT_CKMX B ON B.LCSLID=A.LCSLID AND B.BYBLBZ='N' 
             WHERE A.TSSWJG_DM=V_SWCODE
               AND A.LCTJJC IN ('21','41','51','61')
               AND A.QDSJ<LD_NEXTMONTH
               AND A.LCJSRQ>=LD_THISYEAR) T
     WHERE T.SHZT = '20';

    INSERT INTO TJBB_DT_B01102 (SSNY, BBLC, SWJGDM,
           HJ_QYHS, HJ_TSE,
           HH_QYHS, HH_TSE_XJ, HH_TSE_HIS, HH_TSE_CUR,
           BA_QYHS, BA_TSE_XJ, BA_TSE_HIS, BA_TSE_CUR,
           PZ_QYHS, PZ_TSE_XJ, PZ_TSE_HIS, PZ_TSE_CUR,
           DL_QYHS, DL_TSE_XJ, DL_TSE_HIS, DL_TSE_CUR,
           SH_QYHS, SH_TSE_XJ, SH_TSE_HIS, SH_TSE_CUR,
           DC_QYHS, DC_TSE_XJ, DC_TSE_HIS, DC_TSE_CUR,
           QT_QYHS, QT_TSE_XJ, QT_TSE_HIS, QT_TSE_CUR)
    SELECT LC_THISMONTH, '15', V_SWCODE, 
           LN_SBHS, LN_BY_ZZS_HIS + LN_BY_ZZS_CUR,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           LN_SBHS, LN_BY_ZZS_HIS + LN_BY_ZZS_CUR, LN_BY_ZZS_HIS, LN_BY_ZZS_CUR
      FROM DUAL
     UNION ALL
    SELECT LC_THISMONTH, '16', V_SWCODE, 
           LN_BAHS - LN_SBHS, LN_BY_XFS_HIS + LN_BY_XFS_CUR, 
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           LN_BAHS - LN_SBHS, LN_BY_XFS_HIS + LN_BY_XFS_CUR, LN_BY_XFS_HIS, LN_BY_XFS_CUR
      FROM DUAL;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      V_ERROR := SQLCODE;
      V_MSG   := SQLERRM;
  END;

  --1-4、委托出口的生产企业
  BEGIN
    SELECT COUNT(DISTINCT DJXH), COUNT(DISTINCT(CASE WHEN T.TSE>0 THEN DJXH ELSE NULL END)),
           ROUND(NVL(SUM(CASE WHEN T.CKRQ_1< LD_THISYEAR THEN T.TSE ELSE 0 END),0)/10000,6), --不予
           ROUND(NVL(SUM(CASE WHEN T.CKRQ_1>=LD_THISYEAR THEN T.TSE ELSE 0 END),0)/10000,6), --不予
           ROUND(NVL(SUM(CASE WHEN T.CKRQ_1< LD_THISYEAR THEN T.MDE ELSE 0 END),0)/10000,6), --不予
           ROUND(NVL(SUM(CASE WHEN T.CKRQ_1>=LD_THISYEAR THEN T.MDE ELSE 0 END),0)/10000,6) --不予
      INTO LN_BAHS, LN_SBHS, LN_BY_ZZS_HIS, LN_BY_ZZS_CUR, LN_BY_XFS_HIS, LN_BY_XFS_CUR
      FROM (SELECT A.DJXH,B.LCSLID,B.SBXH,B.CKRQ_1,
                   CASE WHEN TRIM(A.LCSLID_FS) IS NOT NULL AND B.ZBBLBZ='Y' THEN 14 
                        WHEN TRIM(A.LCSLID_FS) IS NOT NULL AND B.BYTSBZ='Y' THEN 20 
                        WHEN TRIM(A.LCSLID_FS) IS NOT NULL THEN 30 
                        WHEN TRIM(A.LCSLID_FS) IS NULL AND A.LCSLID_SB<>A.LCSLID THEN 14 --生产企业全部归类为：有疑点核查中 
                        ELSE 40 END AS SHZT, 
                   B.MYLAJ * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN 1 
                                  WHEN A.ZY_MDTSE=0 THEN 1
                                  WHEN A.SNBL_MDTSE=0 THEN 1
                                  WHEN A.SNBL_MDTSE>0 AND (B.ZBBLBZ='Y' OR B.BYTSBZ='Y') THEN 0
                                  ELSE LEAST(GREATEST(1 - A.SNBL_MDTSE / A.ZY_MDTSE,0),1)
                             END AS MYLAJ,
                   B.MDTSE * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN (CASE WHEN A.SB_MDTSE=0 THEN 0 ELSE A.SB_ZZSTSE/A.SB_MDTSE END)
                                                           ELSE (CASE WHEN A.ZY_MDTSE=0 THEN 0 ELSE A.ZY_ZZSTSE/A.ZY_MDTSE END) 
                             END --根据是否复审用申报数或复审数计算退税部分
                           * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN 1 
                                  WHEN A.ZY_ZZSTSE=0 THEN 1
                                  WHEN A.SNBL_ZZSTSE=0 THEN 1 
                                  WHEN A.SNBL_ZZSTSE>0 AND (B.ZBBLBZ='Y' OR B.BYTSBZ='Y') THEN 0
                                  ELSE LEAST(GREATEST(1 - A.SNBL_ZZSTSE / A.ZY_ZZSTSE,0),1) 
                             END AS TSE,
                   B.MDTSE * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN (CASE WHEN A.SB_MDTSE=0 THEN 1 ELSE A.SB_MDSE/A.SB_MDTSE END)
                                                           ELSE (CASE WHEN A.ZY_MDTSE=0 THEN 1 ELSE A.ZY_MDSE/A.ZY_MDTSE END) 
                             END
                           * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN 1 
                                  WHEN A.ZY_MDSE=0 THEN 1
                                  WHEN A.SNBL_MDSE=0 THEN 1 
                                  WHEN A.SNBL_MDSE>0 AND (B.ZBBLBZ='Y' OR B.BYTSBZ='Y') THEN 0
                                  ELSE LEAST(GREATEST(1 - A.SNBL_MDSE / A.ZY_MDSE,0),1) 
                             END AS MDE
              FROM TL_TSSH.CKTS_LC_SHXX A
             INNER JOIN TL_TSSH.CKTS_SB_MDT_CKMX B ON B.LCSLID=A.LCSLID AND B.BYBLBZ='N' 
             WHERE A.TSSWJG_DM=V_SWCODE
               AND A.LCTJJC IN ('22','42','52','62')
               AND A.QDSJ<LD_NEXTMONTH
               AND A.LCJSRQ>=LD_THISYEAR) T
     WHERE T.SHZT = '20';

    INSERT INTO TJBB_DT_B01102 (SSNY, BBLC, SWJGDM,
           HJ_QYHS, HJ_TSE,
           HH_QYHS, HH_TSE_XJ, HH_TSE_HIS, HH_TSE_CUR,
           BA_QYHS, BA_TSE_XJ, BA_TSE_HIS, BA_TSE_CUR,
           PZ_QYHS, PZ_TSE_XJ, PZ_TSE_HIS, PZ_TSE_CUR,
           DL_QYHS, DL_TSE_XJ, DL_TSE_HIS, DL_TSE_CUR,
           SH_QYHS, SH_TSE_XJ, SH_TSE_HIS, SH_TSE_CUR,
           DC_QYHS, DC_TSE_XJ, DC_TSE_HIS, DC_TSE_CUR,
           QT_QYHS, QT_TSE_XJ, QT_TSE_HIS, QT_TSE_CUR)
    SELECT LC_THISMONTH, '18', V_SWCODE, 
           LN_SBHS, LN_BY_ZZS_HIS + LN_BY_ZZS_CUR,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           LN_SBHS, LN_BY_ZZS_HIS + LN_BY_ZZS_CUR, LN_BY_ZZS_HIS, LN_BY_ZZS_CUR
      FROM DUAL
     UNION ALL
    SELECT LC_THISMONTH, '19', V_SWCODE, 
           LN_BAHS - LN_SBHS, LN_BY_XFS_HIS + LN_BY_XFS_CUR, 
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           LN_BAHS - LN_SBHS, LN_BY_XFS_HIS + LN_BY_XFS_CUR, LN_BY_XFS_HIS, LN_BY_XFS_CUR
      FROM DUAL;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      V_ERROR := SQLCODE;
      V_MSG   := SQLERRM;
  END;

  --1-5、外商投资的生产企业
  BEGIN
    SELECT COUNT(DISTINCT DJXH), COUNT(DISTINCT(CASE WHEN T.TSE>0 THEN DJXH ELSE NULL END)),
           ROUND(NVL(SUM(CASE WHEN T.CKRQ_1< LD_THISYEAR THEN T.TSE ELSE 0 END),0)/10000,6), --不予
           ROUND(NVL(SUM(CASE WHEN T.CKRQ_1>=LD_THISYEAR THEN T.TSE ELSE 0 END),0)/10000,6), --不予
           ROUND(NVL(SUM(CASE WHEN T.CKRQ_1< LD_THISYEAR THEN T.MDE ELSE 0 END),0)/10000,6), --不予
           ROUND(NVL(SUM(CASE WHEN T.CKRQ_1>=LD_THISYEAR THEN T.MDE ELSE 0 END),0)/10000,6) --不予
      INTO LN_BAHS, LN_SBHS, LN_BY_ZZS_HIS, LN_BY_ZZS_CUR, LN_BY_XFS_HIS, LN_BY_XFS_CUR
      FROM (SELECT A.DJXH,B.SBXH,B.CKRQ_1,
                   CASE WHEN TRIM(A.LCSLID_FS) IS NOT NULL AND B.ZBBLBZ='Y' THEN 14 
                        WHEN TRIM(A.LCSLID_FS) IS NOT NULL AND B.BYTSBZ='Y' THEN 20 
                        WHEN TRIM(A.LCSLID_FS) IS NOT NULL THEN 30 
                        WHEN TRIM(A.LCSLID_FS) IS NULL AND A.LCSLID_SB<>A.LCSLID THEN 14 --生产企业全部归类为：有疑点核查中  
                        ELSE 40 END AS SHZT, 
                   B.MDTSE * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN (CASE WHEN A.SB_MDTSE=0 THEN 0 ELSE A.SB_ZZSTSE/A.SB_MDTSE END)
                                                           ELSE (CASE WHEN A.ZY_MDTSE=0 THEN 0 ELSE A.ZY_ZZSTSE/A.ZY_MDTSE END) 
                             END --根据是否复审用申报数或复审数计算退税部分
                           * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN 1 
                                  WHEN A.ZY_ZZSTSE=0 THEN 1
                                  WHEN A.SNBL_ZZSTSE=0 THEN 1 
                                  WHEN A.SNBL_ZZSTSE>0 AND (B.ZBBLBZ='Y' OR B.BYTSBZ='Y') THEN 0
                                  ELSE LEAST(GREATEST(1 - A.SNBL_ZZSTSE / A.ZY_ZZSTSE,0),1) 
                             END AS TSE,
                   B.MDTSE * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN (CASE WHEN A.SB_MDTSE=0 THEN 1 ELSE A.SB_MDSE/A.SB_MDTSE END)
                                                           ELSE (CASE WHEN A.ZY_MDTSE=0 THEN 1 ELSE A.ZY_MDSE/A.ZY_MDTSE END) 
                             END
                           * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN 1 
                                  WHEN A.ZY_MDSE=0 THEN 1
                                  WHEN A.SNBL_MDSE=0 THEN 1 
                                  WHEN A.SNBL_MDSE>0 AND (B.ZBBLBZ='Y' OR B.BYTSBZ='Y') THEN 0
                                  ELSE LEAST(GREATEST(1 - A.SNBL_MDSE / A.ZY_MDSE,0),1) 
                             END AS MDE
              FROM TL_TSSH.CKTS_LC_SHXX A
             INNER JOIN TL_TSSH.CKTS_SB_MDT_CKMX B ON B.LCSLID=A.LCSLID AND B.BYBLBZ='N' 
             WHERE A.TSSWJG_DM=V_SWCODE
               AND A.LCTJJC IN ('23','43','53','63')
               AND A.QDSJ<LD_NEXTMONTH
               AND A.LCJSRQ>=LD_THISYEAR) T
     WHERE T.SHZT = '20';

    INSERT INTO TJBB_DT_B01102 (SSNY, BBLC, SWJGDM,
           HJ_QYHS, HJ_TSE,
           HH_QYHS, HH_TSE_XJ, HH_TSE_HIS, HH_TSE_CUR,
           BA_QYHS, BA_TSE_XJ, BA_TSE_HIS, BA_TSE_CUR,
           PZ_QYHS, PZ_TSE_XJ, PZ_TSE_HIS, PZ_TSE_CUR,
           DL_QYHS, DL_TSE_XJ, DL_TSE_HIS, DL_TSE_CUR,
           SH_QYHS, SH_TSE_XJ, SH_TSE_HIS, SH_TSE_CUR,
           DC_QYHS, DC_TSE_XJ, DC_TSE_HIS, DC_TSE_CUR,
           QT_QYHS, QT_TSE_XJ, QT_TSE_HIS, QT_TSE_CUR)
    SELECT LC_THISMONTH, '21', V_SWCODE, 
           LN_SBHS, LN_BY_ZZS_HIS + LN_BY_ZZS_CUR,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           LN_SBHS, LN_BY_ZZS_HIS + LN_BY_ZZS_CUR, LN_BY_ZZS_HIS, LN_BY_ZZS_CUR
      FROM DUAL
     UNION ALL
    SELECT LC_THISMONTH, '22', V_SWCODE, 
           LN_BAHS - LN_SBHS, LN_BY_XFS_HIS + LN_BY_XFS_CUR,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0, 
           LN_BAHS - LN_SBHS, LN_BY_XFS_HIS + LN_BY_XFS_CUR, LN_BY_XFS_HIS, LN_BY_XFS_CUR
      FROM DUAL;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      V_ERROR := SQLCODE;
      V_MSG   := SQLERRM;
  END;

  --1-6、国际运输服务
  BEGIN
    SELECT COUNT(DISTINCT DJXH), COUNT(DISTINCT(CASE WHEN T.TSE>0 THEN DJXH ELSE NULL END)),
           ROUND(NVL(SUM(CASE WHEN T.CKRQ_1< LD_THISYEAR THEN T.TSE ELSE 0 END),0)/10000,6), --不予
           ROUND(NVL(SUM(CASE WHEN T.CKRQ_1>=LD_THISYEAR THEN T.TSE ELSE 0 END),0)/10000,6), --不予
           ROUND(NVL(SUM(CASE WHEN T.CKRQ_1< LD_THISYEAR THEN T.MDE ELSE 0 END),0)/10000,6), --不予
           ROUND(NVL(SUM(CASE WHEN T.CKRQ_1>=LD_THISYEAR THEN T.MDE ELSE 0 END),0)/10000,6) --不予
      INTO LN_BAHS, LN_SBHS, LN_BY_ZZS_HIS, LN_BY_ZZS_CUR, LN_BY_XFS_HIS, LN_BY_XFS_CUR
      FROM (SELECT A.DJXH,B.SBXH,B.CKRQ_1,
                   CASE WHEN TRIM(A.LCSLID_FS) IS NOT NULL AND B.ZBBLBZ='Y' THEN 14 
                        WHEN TRIM(A.LCSLID_FS) IS NOT NULL AND B.BYTSBZ='Y' THEN 20 
                        WHEN TRIM(A.LCSLID_FS) IS NOT NULL THEN 30 
                        WHEN TRIM(A.LCSLID_FS) IS NULL AND A.LCSLID_SB<>A.LCSLID THEN 14 --生产企业全部归类为：有疑点核查中  
                        ELSE 40 END AS SHZT, 
                   B.MDTSE * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN (CASE WHEN A.SB_MDTSE=0 THEN 0 ELSE A.SB_ZZSTSE/A.SB_MDTSE END)
                                                           ELSE (CASE WHEN A.ZY_MDTSE=0 THEN 0 ELSE A.ZY_ZZSTSE/A.ZY_MDTSE END) 
                             END --根据是否复审用申报数或复审数计算退税部分
                           * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN 1 
                                  WHEN A.ZY_ZZSTSE=0 THEN 1
                                  WHEN A.SNBL_ZZSTSE=0 THEN 1 
                                  WHEN A.SNBL_ZZSTSE>0 AND (B.ZBBLBZ='Y' OR B.BYTSBZ='Y') THEN 0
                                  ELSE LEAST(GREATEST(1 - A.SNBL_ZZSTSE / A.ZY_ZZSTSE,0),1) 
                             END AS TSE,
                   B.MDTSE * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN (CASE WHEN A.SB_MDTSE=0 THEN 1 ELSE A.SB_MDSE/A.SB_MDTSE END)
                                                           ELSE (CASE WHEN A.ZY_MDTSE=0 THEN 1 ELSE A.ZY_MDSE/A.ZY_MDTSE END) 
                             END
                           * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN 1 
                                  WHEN A.ZY_MDSE=0 THEN 1
                                  WHEN A.SNBL_MDSE=0 THEN 1 
                                  WHEN A.SNBL_MDSE>0 AND (B.ZBBLBZ='Y' OR B.BYTSBZ='Y') THEN 0
                                  ELSE LEAST(GREATEST(1 - A.SNBL_MDSE / A.ZY_MDSE,0),1) 
                             END AS MDE
              FROM TL_TSSH.CKTS_LC_SHXX A
             INNER JOIN TL_TSSH.CKTS_SB_MDT_GJYS B ON B.LCSLID=A.LCSLID AND B.BYBLBZ='N' 
             WHERE A.TSSWJG_DM=V_SWCODE
               AND A.LCTJJC IN ('61','62','63')
               AND A.QDSJ<LD_NEXTMONTH
               AND A.LCJSRQ>=LD_THISYEAR) T
     WHERE T.SHZT = '20';

    INSERT INTO TJBB_DT_B01102 (SSNY, BBLC, SWJGDM,
           HJ_QYHS, HJ_TSE,
           HH_QYHS, HH_TSE_XJ, HH_TSE_HIS, HH_TSE_CUR,
           BA_QYHS, BA_TSE_XJ, BA_TSE_HIS, BA_TSE_CUR,
           PZ_QYHS, PZ_TSE_XJ, PZ_TSE_HIS, PZ_TSE_CUR,
           DL_QYHS, DL_TSE_XJ, DL_TSE_HIS, DL_TSE_CUR,
           SH_QYHS, SH_TSE_XJ, SH_TSE_HIS, SH_TSE_CUR,
           DC_QYHS, DC_TSE_XJ, DC_TSE_HIS, DC_TSE_CUR,
           QT_QYHS, QT_TSE_XJ, QT_TSE_HIS, QT_TSE_CUR)
    SELECT LC_THISMONTH, '27', V_SWCODE, 
           LN_SBHS, LN_BY_ZZS_HIS + LN_BY_ZZS_CUR,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           LN_SBHS, LN_BY_ZZS_HIS + LN_BY_ZZS_CUR, LN_BY_ZZS_HIS, LN_BY_ZZS_CUR
      FROM DUAL
     UNION ALL
    SELECT LC_THISMONTH, '28', V_SWCODE, 
           LN_BAHS - LN_SBHS, LN_BY_XFS_HIS + LN_BY_XFS_CUR,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0, 
           LN_BAHS - LN_SBHS, LN_BY_XFS_HIS + LN_BY_XFS_CUR, LN_BY_XFS_HIS, LN_BY_XFS_CUR
      FROM DUAL;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      V_ERROR := SQLCODE;
      V_MSG   := SQLERRM;
  END;

  --1-7、研发设计服务
  BEGIN
    SELECT COUNT(DISTINCT DJXH), COUNT(DISTINCT(CASE WHEN T.TSE>0 THEN DJXH ELSE NULL END)),
           ROUND(NVL(SUM(CASE WHEN T.CKRQ_1< LD_THISYEAR THEN T.TSE ELSE 0 END),0)/10000,6), --不予
           ROUND(NVL(SUM(CASE WHEN T.CKRQ_1>=LD_THISYEAR THEN T.TSE ELSE 0 END),0)/10000,6), --不予
           ROUND(NVL(SUM(CASE WHEN T.CKRQ_1< LD_THISYEAR THEN T.MDE ELSE 0 END),0)/10000,6), --不予
           ROUND(NVL(SUM(CASE WHEN T.CKRQ_1>=LD_THISYEAR THEN T.MDE ELSE 0 END),0)/10000,6) --不予
      INTO LN_BAHS, LN_SBHS, LN_BY_ZZS_HIS, LN_BY_ZZS_CUR, LN_BY_XFS_HIS, LN_BY_XFS_CUR
      FROM (SELECT A.DJXH,B.SBXH,B.CKRQ_1,
                   CASE WHEN TRIM(A.LCSLID_FS) IS NOT NULL AND B.ZBBLBZ='Y' THEN 14 
                        WHEN TRIM(A.LCSLID_FS) IS NOT NULL AND B.BYTSBZ='Y' THEN 20 
                        WHEN TRIM(A.LCSLID_FS) IS NOT NULL THEN 30 
                        WHEN TRIM(A.LCSLID_FS) IS NULL AND A.LCSLID_SB<>A.LCSLID THEN 14 --生产企业全部归类为：有疑点核查中  
                        ELSE 40 END AS SHZT, 
                   B.MDTSE * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN (CASE WHEN A.SB_MDTSE=0 THEN 0 ELSE A.SB_ZZSTSE/A.SB_MDTSE END)
                                                           ELSE (CASE WHEN A.ZY_MDTSE=0 THEN 0 ELSE A.ZY_ZZSTSE/A.ZY_MDTSE END) 
                             END --根据是否复审用申报数或复审数计算退税部分
                           * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN 1 
                                  WHEN A.ZY_ZZSTSE=0 THEN 1
                                  WHEN A.SNBL_ZZSTSE=0 THEN 1 
                                  WHEN A.SNBL_ZZSTSE>0 AND (B.ZBBLBZ='Y' OR B.BYTSBZ='Y') THEN 0
                                  ELSE LEAST(GREATEST(1 - A.SNBL_ZZSTSE / A.ZY_ZZSTSE,0),1) 
                             END AS TSE,
                   B.MDTSE * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN (CASE WHEN A.SB_MDTSE=0 THEN 1 ELSE A.SB_MDSE/A.SB_MDTSE END)
                                                           ELSE (CASE WHEN A.ZY_MDTSE=0 THEN 1 ELSE A.ZY_MDSE/A.ZY_MDTSE END) 
                             END
                           * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN 1 
                                  WHEN A.ZY_MDSE=0 THEN 1
                                  WHEN A.SNBL_MDSE=0 THEN 1 
                                  WHEN A.SNBL_MDSE>0 AND (B.ZBBLBZ='Y' OR B.BYTSBZ='Y') THEN 0
                                  ELSE LEAST(GREATEST(1 - A.SNBL_MDSE / A.ZY_MDSE,0),1) 
                             END AS MDE
              FROM TL_TSSH.CKTS_LC_SHXX A
             INNER JOIN TL_TSSH.CKTS_SB_MDT_YFSJ B ON B.LCSLID=A.LCSLID AND B.BYBLBZ='N' 
             WHERE A.TSSWJG_DM=V_SWCODE
               AND A.LCTJJC IN ('51','52','53')
               AND A.QDSJ<LD_NEXTMONTH
               AND A.LCJSRQ>=LD_THISYEAR
             UNION ALL
             SELECT A.DJXH,B.SBXH,B.CKRQ_1,
                   CASE WHEN TRIM(A.LCSLID_FS) IS NOT NULL AND B.BYTSBZ='Y' THEN 20 
                        WHEN TRIM(A.LCSLID_FS) IS NOT NULL THEN 30 
                        WHEN TRIM(A.LCSLID_FS) IS NULL AND A.LCSLID_SB<>A.LCSLID THEN 14 --外贸企业服务贸易归类为：有疑点核查中  
                        ELSE 40 END AS SHZT, 
                   B.ZZSTSE * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN 1 
                                    WHEN A.ZY_ZZSTSE=0 THEN 1
                                    WHEN A.SNBL_ZZSTSE=0 THEN 1 
                                    WHEN A.SNBL_ZZSTSE>0 AND B.BYTSBZ='Y' THEN 0
                                    ELSE LEAST(GREATEST(1 - A.SNBL_ZZSTSE / A.ZY_ZZSTSE,0),1) 
                               END AS TSE,
                   0 AS MDE
              FROM TL_TSSH.CKTS_LC_SHXX A
             INNER JOIN TL_TSSH.CKTS_SB_MTS_YSFW B ON B.LCSLID=A.LCSLID AND B.BYBLBZ='N' 
             WHERE A.TSSWJG_DM=V_SWCODE
               AND A.LCTJJC='50'
               AND A.QDSJ<LD_NEXTMONTH
               AND A.LCJSRQ>=LD_THISYEAR) T
     WHERE T.SHZT = '20';

    INSERT INTO TJBB_DT_B01102 (SSNY, BBLC, SWJGDM,
           HJ_QYHS, HJ_TSE,
           HH_QYHS, HH_TSE_XJ, HH_TSE_HIS, HH_TSE_CUR,
           BA_QYHS, BA_TSE_XJ, BA_TSE_HIS, BA_TSE_CUR,
           PZ_QYHS, PZ_TSE_XJ, PZ_TSE_HIS, PZ_TSE_CUR,
           DL_QYHS, DL_TSE_XJ, DL_TSE_HIS, DL_TSE_CUR,
           SH_QYHS, SH_TSE_XJ, SH_TSE_HIS, SH_TSE_CUR,
           DC_QYHS, DC_TSE_XJ, DC_TSE_HIS, DC_TSE_CUR,
           QT_QYHS, QT_TSE_XJ, QT_TSE_HIS, QT_TSE_CUR)
    SELECT LC_THISMONTH, '30', V_SWCODE, 
           LN_SBHS, LN_BY_ZZS_HIS + LN_BY_ZZS_CUR,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           LN_SBHS, LN_BY_ZZS_HIS + LN_BY_ZZS_CUR, LN_BY_ZZS_HIS, LN_BY_ZZS_CUR
      FROM DUAL
     UNION ALL
    SELECT LC_THISMONTH, '31', V_SWCODE, 
           LN_BAHS - LN_SBHS, LN_BY_XFS_HIS + LN_BY_XFS_CUR,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0, 
           LN_BAHS - LN_SBHS, LN_BY_XFS_HIS + LN_BY_XFS_CUR, LN_BY_XFS_HIS, LN_BY_XFS_CUR
      FROM DUAL;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      V_ERROR := SQLCODE;
      V_MSG   := SQLERRM;
  END;

  --1-8、其他服务贸易
  BEGIN
    SELECT COUNT(DISTINCT DJXH), COUNT(DISTINCT(CASE WHEN T.TSE>0 THEN DJXH ELSE NULL END)),
           ROUND(NVL(SUM(CASE WHEN T.CKRQ_1< LD_THISYEAR THEN T.TSE ELSE 0 END),0)/10000,6), --不予
           ROUND(NVL(SUM(CASE WHEN T.CKRQ_1>=LD_THISYEAR THEN T.TSE ELSE 0 END),0)/10000,6), --不予
           ROUND(NVL(SUM(CASE WHEN T.CKRQ_1< LD_THISYEAR THEN T.MDE ELSE 0 END),0)/10000,6), --不予
           ROUND(NVL(SUM(CASE WHEN T.CKRQ_1>=LD_THISYEAR THEN T.MDE ELSE 0 END),0)/10000,6) --不予
      INTO LN_BAHS, LN_SBHS, LN_BY_ZZS_HIS, LN_BY_ZZS_CUR, LN_BY_XFS_HIS, LN_BY_XFS_CUR
      FROM (SELECT A.DJXH,B.SBXH,B.CKRQ_1,
                   CASE WHEN TRIM(A.LCSLID_FS) IS NOT NULL AND B.ZBBLBZ='Y' THEN 14 
                        WHEN TRIM(A.LCSLID_FS) IS NOT NULL AND B.BYTSBZ='Y' THEN 20 
                        WHEN TRIM(A.LCSLID_FS) IS NOT NULL THEN 30 
                        WHEN TRIM(A.LCSLID_FS) IS NULL AND A.LCSLID_SB<>A.LCSLID THEN 14 --生产企业全部归类为：有疑点核查中  
                        ELSE 40 END AS SHZT, 
                   B.MDTSE * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN (CASE WHEN A.SB_MDTSE=0 THEN 0 ELSE A.SB_ZZSTSE/A.SB_MDTSE END)
                                                           ELSE (CASE WHEN A.ZY_MDTSE=0 THEN 0 ELSE A.ZY_ZZSTSE/A.ZY_MDTSE END) 
                             END --根据是否复审用申报数或复审数计算退税部分
                           * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN 1 
                                  WHEN A.ZY_ZZSTSE=0 THEN 1
                                  WHEN A.SNBL_ZZSTSE=0 THEN 1 
                                  WHEN A.SNBL_ZZSTSE>0 AND (B.ZBBLBZ='Y' OR B.BYTSBZ='Y') THEN 0
                                  ELSE LEAST(GREATEST(1 - A.SNBL_ZZSTSE / A.ZY_ZZSTSE,0),1) 
                             END AS TSE,
                   B.MDTSE * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN (CASE WHEN A.SB_MDTSE=0 THEN 1 ELSE A.SB_MDSE/A.SB_MDTSE END)
                                                           ELSE (CASE WHEN A.ZY_MDTSE=0 THEN 1 ELSE A.ZY_MDSE/A.ZY_MDTSE END) 
                             END
                           * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN 1 
                                  WHEN A.ZY_MDSE=0 THEN 1
                                  WHEN A.SNBL_MDSE=0 THEN 1 
                                  WHEN A.SNBL_MDSE>0 AND (B.ZBBLBZ='Y' OR B.BYTSBZ='Y') THEN 0
                                  ELSE LEAST(GREATEST(1 - A.SNBL_MDSE / A.ZY_MDSE,0),1) 
                             END AS MDE
              FROM TL_TSSH.CKTS_LC_SHXX A
             INNER JOIN TL_TSSH.CKTS_SB_MDT_YFSJ B ON B.LCSLID=A.LCSLID AND B.BYBLBZ='N' 
             WHERE A.TSSWJG_DM=V_SWCODE
               AND A.LCTJJC IN ('41','42','43')
               AND A.QDSJ<LD_NEXTMONTH
               AND A.LCJSRQ>=LD_THISYEAR
             UNION ALL
             SELECT A.DJXH,B.SBXH,B.CKRQ_1,
                   CASE WHEN TRIM(A.LCSLID_FS) IS NOT NULL AND B.BYTSBZ='Y' THEN 20 
                        WHEN TRIM(A.LCSLID_FS) IS NOT NULL THEN 30 
                        WHEN TRIM(A.LCSLID_FS) IS NULL AND A.LCSLID_SB<>A.LCSLID THEN 14 --外贸企业服务贸易归类为：有疑点核查中  
                        ELSE 40 END AS SHZT, 
                   B.ZZSTSE * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN 1 
                                    WHEN A.ZY_ZZSTSE=0 THEN 1
                                    WHEN A.SNBL_ZZSTSE=0 THEN 1 
                                    WHEN A.SNBL_ZZSTSE>0 AND B.BYTSBZ='Y' THEN 0
                                    ELSE LEAST(GREATEST(1 - A.SNBL_ZZSTSE / A.ZY_ZZSTSE,0),1) 
                               END AS TSE,
                   0 AS MDE
              FROM TL_TSSH.CKTS_LC_SHXX A
             INNER JOIN TL_TSSH.CKTS_SB_MTS_YSFW B ON B.LCSLID=A.LCSLID AND B.BYBLBZ='N' 
             WHERE A.TSSWJG_DM=V_SWCODE
               AND A.LCTJJC='40'
               AND A.QDSJ<LD_NEXTMONTH
               AND A.LCJSRQ>=LD_THISYEAR) T
     WHERE T.SHZT = '20';

    INSERT INTO TJBB_DT_B01102 (SSNY, BBLC, SWJGDM,
           HJ_QYHS, HJ_TSE,
           HH_QYHS, HH_TSE_XJ, HH_TSE_HIS, HH_TSE_CUR,
           BA_QYHS, BA_TSE_XJ, BA_TSE_HIS, BA_TSE_CUR,
           PZ_QYHS, PZ_TSE_XJ, PZ_TSE_HIS, PZ_TSE_CUR,
           DL_QYHS, DL_TSE_XJ, DL_TSE_HIS, DL_TSE_CUR,
           SH_QYHS, SH_TSE_XJ, SH_TSE_HIS, SH_TSE_CUR,
           DC_QYHS, DC_TSE_XJ, DC_TSE_HIS, DC_TSE_CUR,
           QT_QYHS, QT_TSE_XJ, QT_TSE_HIS, QT_TSE_CUR)
    SELECT LC_THISMONTH, '33', V_SWCODE, 
           LN_SBHS, LN_BY_ZZS_HIS + LN_BY_ZZS_CUR,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           LN_SBHS, LN_BY_ZZS_HIS + LN_BY_ZZS_CUR, LN_BY_ZZS_HIS, LN_BY_ZZS_CUR
      FROM DUAL
     UNION ALL
    SELECT LC_THISMONTH, '34', V_SWCODE, 
           LN_BAHS - LN_SBHS, LN_BY_XFS_HIS + LN_BY_XFS_CUR,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0, 
           LN_BAHS - LN_SBHS, LN_BY_XFS_HIS + LN_BY_XFS_CUR, LN_BY_XFS_HIS, LN_BY_XFS_CUR
      FROM DUAL;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      V_ERROR := SQLCODE;
      V_MSG   := SQLERRM;
  END;

  --1-9、其他企业
  BEGIN
    SELECT COUNT(DISTINCT DJXH), 
           ROUND(NVL(SUM(CASE WHEN T.CKRQ_1< LD_THISYEAR THEN T.TSE ELSE 0 END),0)/10000,6), --不予
           ROUND(NVL(SUM(CASE WHEN T.CKRQ_1>=LD_THISYEAR THEN T.TSE ELSE 0 END),0)/10000,6) --不予
      INTO LN_SBHS, LN_BY_ZZS_HIS, LN_BY_ZZS_CUR
      FROM (SELECT A.DJXH,B.SBXH,B.KPRQ AS CKRQ_1,
                   CASE WHEN TRIM(A.LCSLID_FS) IS NOT NULL AND B.ZBBLBZ='Y' THEN 14 
                        WHEN TRIM(A.LCSLID_FS) IS NOT NULL AND B.BYTSBZ='Y' THEN 20 
                        WHEN TRIM(A.LCSLID_FS) IS NOT NULL THEN 30 
                        WHEN TRIM(A.LCSLID_FS) IS NULL AND A.LCSLID_SB<>A.LCSLID THEN 14 --周边业务归类为：有疑点核查中  
                        ELSE 40 END AS SHZT, 
                   B.XFSTSE *  CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN 1 
                                    WHEN A.ZY_MDTSE=0 THEN 1
                                    WHEN A.SNBL_MDTSE=0 THEN 1
                                    WHEN A.SNBL_MDTSE>0 AND (B.ZBBLBZ='Y' OR B.BYTSBZ='Y') THEN 0
                                    ELSE LEAST(GREATEST(1 - A.SNBL_MDTSE / A.ZY_MDTSE,0),1)
                               END AS TSE
              FROM TL_TSSH.CKTS_LC_SHXX A
             INNER JOIN TL_TSSH.CKTS_SB_FZC_SBMX B ON B.LCSLID=A.LCSLID AND B.BYBLBZ='N' 
             WHERE A.TSSWJG_DM=V_SWCODE
               AND A.LCTJJC='30'
               AND A.QDSJ<LD_NEXTMONTH
               AND A.LCJSRQ>=LD_THISYEAR
             UNION ALL
            SELECT A.DJXH,B.SBXH,B.KPRQ AS CKRQ_1,
                   CASE WHEN TRIM(A.LCSLID_FS) IS NOT NULL AND B.ZBBLBZ='Y' THEN 14 
                        WHEN TRIM(A.LCSLID_FS) IS NOT NULL AND B.BYTSBZ='Y' THEN 20 
                        WHEN TRIM(A.LCSLID_FS) IS NOT NULL THEN 30 
                        WHEN TRIM(A.LCSLID_FS) IS NULL AND A.LCSLID_SB<>A.LCSLID THEN 14  --周边业务归类为：有疑点核查中  
                        ELSE 40 END AS SHZT, 
                   B.TSE * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN 1 
                                WHEN A.ZY_MDTSE=0 THEN 1
                                WHEN A.SNBL_MDTSE=0 THEN 1
                                WHEN A.SNBL_MDTSE>0 AND (B.ZBBLBZ='Y' OR B.BYTSBZ='Y') THEN 0
                                ELSE LEAST(GREATEST(1 - A.SNBL_MDTSE / A.ZY_MDTSE,0),1)
                           END AS TSE
              FROM TL_TSSH.CKTS_LC_SHXX A
             INNER JOIN TL_TSSH.CKTS_SB_GJ_SBMX B ON B.LCSLID=A.LCSLID AND B.BYBLBZ='N' 
             WHERE A.TSSWJG_DM=V_SWCODE
               AND A.LCTJJC='30'
               AND A.QDSJ<LD_NEXTMONTH
               AND A.LCJSRQ>=LD_THISYEAR
             UNION ALL
            SELECT A.DJXH,B.SBXH,B.CKRQ_1,
                   CASE WHEN TRIM(A.LCSLID_FS) IS NOT NULL AND B.ZBBLBZ='Y' THEN 14 
                        WHEN TRIM(A.LCSLID_FS) IS NOT NULL AND B.BYTSBZ='Y' THEN 20 
                        WHEN TRIM(A.LCSLID_FS) IS NOT NULL THEN 30 
                        WHEN TRIM(A.LCSLID_FS) IS NULL AND A.LCSLID_SB<>A.LCSLID THEN 14  --周边业务归类为：有疑点核查中  
                        ELSE 40 END AS SHZT, 
                   B.TSE * CASE WHEN TRIM(A.LCSLID_FS) IS NULL THEN 1 
                                  WHEN A.ZY_MDTSE=0 THEN 1
                                WHEN A.SNBL_MDTSE=0 THEN 1
                                WHEN A.SNBL_MDTSE>0 AND (B.ZBBLBZ='Y' OR B.BYTSBZ='Y') THEN 0
                                ELSE LEAST(GREATEST(1 - A.SNBL_MDTSE / A.ZY_MDTSE,0),1)
                           END AS TSE
              FROM TL_TSSH.CKTS_LC_SHXX A
             INNER JOIN TL_TSSH.CKTS_SB_YS_SBMX B ON B.LCSLID=A.LCSLID AND B.BYBLBZ='N' 
             WHERE A.TSSWJG_DM=V_SWCODE
               AND A.LCTJJC='30'
               AND A.QDSJ<LD_NEXTMONTH
               AND A.LCJSRQ>=LD_THISYEAR) T
     WHERE T.SHZT = '20';

    INSERT INTO TJBB_DT_B01102 (SSNY, BBLC, SWJGDM,
           HJ_QYHS, HJ_TSE,
           HH_QYHS, HH_TSE_XJ, HH_TSE_HIS, HH_TSE_CUR,
           BA_QYHS, BA_TSE_XJ, BA_TSE_HIS, BA_TSE_CUR,
           PZ_QYHS, PZ_TSE_XJ, PZ_TSE_HIS, PZ_TSE_CUR,
           DL_QYHS, DL_TSE_XJ, DL_TSE_HIS, DL_TSE_CUR,
           SH_QYHS, SH_TSE_XJ, SH_TSE_HIS, SH_TSE_CUR,
           DC_QYHS, DC_TSE_XJ, DC_TSE_HIS, DC_TSE_CUR,
           QT_QYHS, QT_TSE_XJ, QT_TSE_HIS, QT_TSE_CUR)
    SELECT LC_THISMONTH, '36', V_SWCODE, 
           LN_SBHS, LN_BY_ZZS_HIS + LN_BY_ZZS_CUR,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           LN_SBHS, LN_BY_ZZS_HIS + LN_BY_ZZS_CUR, LN_BY_ZZS_HIS, LN_BY_ZZS_CUR
      FROM DUAL
     UNION ALL
    SELECT LC_THISMONTH, '37', V_SWCODE, 
           0, 0, 
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0,
           0, 0, 0, 0
      FROM DUAL;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      V_ERROR := SQLCODE;
      V_MSG   := SQLERRM;
  END;

  --1-10、计算行
  BEGIN
    FOR LSF_XX IN (SELECT TRIM(TO_CHAR(SUBSTR(T.FORMULA,2,INSTR(T.FORMULA,')')-2),'00')) AS BBLC,
                          '('||REPLACE(REPLACE(REPLACE(SUBSTR(T.FORMULA,INSTR(T.FORMULA,'=')+1),'(',''''),'+',','),')','''')||')' AS BBCS
                     FROM TJBB_REPORT_FORMULA T 
                    WHERE T.BBDM='B01102' 
                      AND T.TYPE=2
                    ORDER BY T.YXJ) 
    LOOP
      BEGIN
        LC_SQL := 'INSERT INTO TJBB_DT_B01102 (SSNY, BBLC, SWJGDM, 
                          HJ_QYHS, HJ_TSE,
                          HH_QYHS, HH_TSE_XJ, HH_TSE_HIS, HH_TSE_CUR,
                          BA_QYHS, BA_TSE_XJ, BA_TSE_HIS, BA_TSE_CUR,
                          PZ_QYHS, PZ_TSE_XJ, PZ_TSE_HIS, PZ_TSE_CUR,
                          DL_QYHS, DL_TSE_XJ, DL_TSE_HIS, DL_TSE_CUR,
                          SH_QYHS, SH_TSE_XJ, SH_TSE_HIS, SH_TSE_CUR,
                          DC_QYHS, DC_TSE_XJ, DC_TSE_HIS, DC_TSE_CUR,
                          QT_QYHS, QT_TSE_XJ, QT_TSE_HIS, QT_TSE_CUR)
                   SELECT '''||LC_THISMONTH||''', '''||LSF_XX.BBLC||''', '''||V_SWCODE||''', 
                          SUM(HJ_QYHS), SUM(HJ_TSE),
                          SUM(HH_QYHS), SUM(HH_TSE_XJ), SUM(HH_TSE_HIS), SUM(HH_TSE_CUR),
                          SUM(BA_QYHS), SUM(BA_TSE_XJ), SUM(BA_TSE_HIS), SUM(BA_TSE_CUR),
                          SUM(PZ_QYHS), SUM(PZ_TSE_XJ), SUM(PZ_TSE_HIS), SUM(PZ_TSE_CUR),
                          SUM(DL_QYHS), SUM(DL_TSE_XJ), SUM(DL_TSE_HIS), SUM(DL_TSE_CUR),
                          SUM(SH_QYHS), SUM(SH_TSE_XJ), SUM(SH_TSE_HIS), SUM(SH_TSE_CUR),
                          SUM(DC_QYHS), SUM(DC_TSE_XJ), SUM(DC_TSE_HIS), SUM(DC_TSE_CUR),
                          SUM(QT_QYHS), SUM(QT_TSE_XJ), SUM(QT_TSE_HIS), SUM(QT_TSE_CUR)
                     FROM TJBB_DT_B01102
                    WHERE SWJGDM='''||V_SWCODE||'''
                      AND SSNY='''||LC_THISMONTH||'''
                      AND TRIM(TO_CHAR(TO_NUMBER(BBLC))) IN '||LSF_XX.BBCS;
        
        EXECUTE IMMEDIATE LC_SQL;
        COMMIT;
      END;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      V_ERROR := SQLCODE;
      V_MSG   := SQLERRM;
  END;

  --2、更新汇总列
  BEGIN
    LC_SQL_UPDATEHZ := 'UPDATE TJBB_DT_B01102 SET ';

    FOR LSF_XX IN (SELECT FNAME FROM TJBB_HEADER_COLS WHERE BBDM='B01102' AND FTYPE='NUMBER' ORDER BY SHOWORDER)
    LOOP
      LC_SQL_UPDATEHZ := LC_SQL_UPDATEHZ || LSF_XX.FNAME || '_HZ=' || LSF_XX.FNAME || ', ';
    END LOOP;

    LC_SQL_UPDATEHZ := SUBSTR(LC_SQL_UPDATEHZ, 1, LENGTH(LC_SQL_UPDATEHZ)-2) ||
                       ' WHERE SWJGDM=''' || V_SWCODE || ''' AND SSNY=''' || LC_THISMONTH || '''';

    EXECUTE IMMEDIATE LC_SQL_UPDATEHZ;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      V_ERROR := SQLCODE;
      V_MSG   := SQLERRM;
  END;

  RETURN;
END;
/
