CREATE OR REPLACE PROCEDURE PRO_TJBB_DT_B01104_CSH_NEW
/*************************************************
 * 企业不欲申报出口退税情况统计月报表
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
  LC_PREVYEAR      VARCHAR2(4);
  TOTAL_USD_AMT    NUMBER(18,6);
  TOTAL_TS_AMT     NUMBER(18,6);
  LN_TSE_PER_USD   NUMBER(18,6);
  LC_SWJGMC        VARCHAR2(100);
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
  LC_PREVYEAR    :=TO_CHAR(ADD_MONTHS(LD_THISYEAR,-1),'YYYY');

  --0、清除原有制表数据，准备重新制表
  BEGIN
    DELETE FROM TJBB_DT_B01104 WHERE SWJGDM=V_SWCODE AND SSNY=LC_THISMONTH;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      V_ERROR := SQLCODE;
      V_MSG   := SQLERRM;
      RETURN;
  END;

  --1、全部以0填充
  BEGIN
    --税务机关名称
    SELECT SWJG_MC
      INTO LC_SWJGMC
      FROM DM_SWJG
     WHERE SWJG_DM=V_SWCODE;
    --每美元退税额
    SELECT SUM(T.SB_XSEMY), SUM(NVL(T.SB_ZZSTSE,0)+NVL(T.SB_XFSTSE,0))
      INTO TOTAL_USD_AMT, TOTAL_TS_AMT
      FROM TL_TSSH.CKTS_LC_SHXX T
     WHERE T.TSSWJG_DM=V_SWCODE
       AND T.SBYWB_DM IN ('A0301001','A0305001','A0310001')
       AND TO_CHAR(T.QDSJ,'YYYY') = LC_PREVYEAR;
    LN_TSE_PER_USD := CASE WHEN TOTAL_USD_AMT=0 THEN 1 ELSE TOTAL_TS_AMT/TOTAL_USD_AMT END;

    INSERT INTO TJBB_DT_B01104(SSNY,BBLC,SWJGDM,SWJGMC,
                QYHS_HJ,QYHS_WM,QYHS_WZF,QYHS_SC,QYHS_FWMY,
                CKE_HJ,
                CK_WM_XJ,CK_WM_HIS,CK_WM_CUR,
                CK_WZF_XJ,CK_WZF_HIS,CK_WZF_CUR,
                CK_SC_XJ,CK_SC_HIS,CK_SC_CUR,
                CK_FWMY_XJ,CK_FWMY_HIS,CK_FWMY_CUR,
                TSE_PER_USD,
                CSTSE_HJ,
                CSTSE_WM_XJ,CSTSE_WM_HIS,CSTSE_WM_CUR,
                CSTSE_WZF_XJ,CSTSE_WZF_HIS,CSTSE_WZF_CUR,
                CSTSE_SC_XJ,CSTSE_SC_HIS,CSTSE_SC_CUR,
                CSTSE_FWMY_XJ,CSTSE_FWMY_HIS,CSTSE_FWMY_CUR)
         SELECT LC_THISMONTH, '01', V_SWCODE,LC_SWJGMC, 
                0, 0, 0, 0, 0,
                0,
                0, 0, 0,
                0, 0, 0,
                0, 0, 0,
                0, 0, 0,
                LN_TSE_PER_USD,
                0,
                0, 0, 0,
                0, 0, 0,
                0, 0, 0,
                0, 0, 0
           FROM DUAL;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      V_ERROR := SQLCODE;
      V_MSG   := SQLERRM;
  END;

  --2、更新汇总列
  BEGIN
    LC_SQL_UPDATEHZ := 'UPDATE TJBB_DT_B01104 SET ';

    FOR LSF_XX IN (SELECT FNAME FROM TJBB_HEADER_COLS WHERE BBDM='B01104' AND FTYPE='NUMBER' ORDER BY SHOWORDER)
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
