CREATE OR REPLACE PROCEDURE PRO_TJBB_DT_B02113_HZ_NEW
/*************************************************
 * 跨境电子商务零售出口退税情况统计表9810（省、市局汇总）
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
  LD_NEXTMONTH     DATE;
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
  LD_NEXTMONTH :=TRUNC(ADD_MONTHS(LD_SYSDATE,1),'MM');

  --0、清除原有制表数据，准备重新制表
  BEGIN
    DELETE FROM TJBB_DT_B02113 WHERE SWJGDM=V_SWCODE AND SSNY=LC_THISMONTH;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      V_ERROR := SQLCODE;
      V_MSG   := SQLERRM;
      RETURN;
  END;

  --1、统计
  BEGIN
    INSERT INTO TJBB_DT_B02113 (
           SSNY,BBLC,SWJGDM,
           BAHS, SBHS, SBTSCKE,
           SB_TMSE, SB_TSE, SB_MDSE,
           SH_TMSE, SH_TSE, SH_MDSE,
           BL_TMSE, BL_TSE, BL_MDSE)
    SELECT LC_THISMONTH,BBLC,V_SWCODE,
           SUM(BAHS), SUM(SBHS), SUM(SBTSCKE),
           SUM(SB_TMSE), SUM(SB_TSE), SUM(SB_MDSE),
           SUM(SH_TMSE), SUM(SH_TSE), SUM(SH_MDSE),
           SUM(BL_TMSE), SUM(BL_TSE), SUM(BL_MDSE)
      FROM TJBB_DT_B02113
     WHERE SWJGDM IN (SELECT SWJG_DM FROM TABLE(TL_ADMIN.FUNC_GET_XJ_SWJG(V_SWCODE))) 
       AND SSNY=LC_THISMONTH
     GROUP BY BBLC;
    COMMIT;

    UPDATE TJBB_DT_B02113 
       SET ZYSP = (SELECT S1.MLMC
                     FROM DM_SPML S1, 
                          (SELECT SPML,SUM(MYLAJ) AS USD_TOTAL
                             FROM (SELECT C.SPML,B.MYLAJ
                                     FROM TL_TSSH.CKTS_LC_SHXX A
                                    INNER JOIN TL_TSSH.CKTS_WBSJ_BGD_9X10 B ON B.LCSLID=A.LCSLID AND B.TDCODE='9810' AND B.SBYWB_DM<>'A0305001'
                                    INNER JOIN TL_ADMIN.DM_SPFL C ON C.SPDL=SUBSTR(B.CKSP_DM,1,2)
                                    WHERE A.TSSWJG_DM IN (SELECT SWJG_DM FROM TABLE(TL_ADMIN.FUNC_GET_XJ_SWJG(V_SWCODE))) 
                                      AND A.QDSJ>=DATE'2013-01-01'
                                      AND A.QDSJ<LD_NEXTMONTH) S2
                            GROUP BY SPML
                            ORDER BY USD_TOTAL DESC) S3
                    WHERE S1.SPML=S3.SPML
                      AND ROWNUM=1)
     WHERE SWJGDM=V_SWCODE
       AND SSNY=LC_THISMONTH
       AND BBLC IN ('01','04','07');
    COMMIT;

    UPDATE TJBB_DT_B02113 
       SET ZYSP = (SELECT S1.MLMC
                     FROM DM_SPML S1, 
                          (SELECT SPML,SUM(MYLAJ) AS USD_TOTAL
                             FROM (SELECT C.SPML,B.MYLAJ
                                     FROM TL_TSSH.CKTS_LC_SHXX A
                                    INNER JOIN TL_TSSH.CKTS_WBSJ_BGD_9X10 B ON B.LCSLID=A.LCSLID AND B.TDCODE='9810' AND B.SBYWB_DM='A0305001'
                                    INNER JOIN TL_ADMIN.DM_SPFL C ON C.SPDL=SUBSTR(B.CKSP_DM,1,2)
                                    WHERE A.TSSWJG_DM IN (SELECT SWJG_DM FROM TABLE(TL_ADMIN.FUNC_GET_XJ_SWJG(V_SWCODE))) 
                                      AND A.QDSJ>=DATE'2013-01-01'
                                      AND A.QDSJ<LD_NEXTMONTH) S2
                            GROUP BY SPML
                            ORDER BY USD_TOTAL DESC) S3
                    WHERE S1.SPML=S3.SPML
                      AND ROWNUM=1)
     WHERE SWJGDM=V_SWCODE
       AND SSNY=LC_THISMONTH
       AND BBLC IN ('02','05','08');
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      V_ERROR := SQLCODE;
      V_MSG   := SQLERRM;
      RETURN;
  END;

  --11、更新汇总列
  BEGIN
    LC_SQL_UPDATEHZ := 'UPDATE TJBB_DT_B02113 SET ';

    FOR LSF_XX IN (SELECT FNAME FROM TJBB_HEADER_COLS WHERE BBDM='B02113' AND FTYPE='NUMBER' ORDER BY SHOWORDER)
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
