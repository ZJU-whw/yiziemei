CREATE OR REPLACE PROCEDURE PRO_TJBB_DT_B02104_CSH_NEW
/*************************************************
 * 市场采购贸易方式出口货物免税情况统计表
 ************************************************/
(
  V_SWCODE  IN  VARCHAR2,
  V_SSNY IN VARCHAR2,
  V_ERROR   OUT NUMBER,
  V_MSG     OUT VARCHAR2
)
AS
  LC_THISMONTH       VARCHAR2(6);
  LD_SYSDATE       DATE;
BEGIN
  V_ERROR :=0;
  V_MSG   := ' ';

  IF V_SSNY IS NOT NULL THEN
    LD_SYSDATE:=TO_DATE(V_SSNY||'01','YYYYMMDD');
  ELSE
    LD_SYSDATE:=SYSDATE;
  END IF;

  LC_THISMONTH   :=TO_CHAR(LD_SYSDATE,'YYYYMM');

  --0、清除原有制表数据，准备重新制表
  BEGIN
    DELETE FROM TJBB_DT_B02104 WHERE SWJGDM=V_SWCODE AND SSNY=LC_THISMONTH;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      V_ERROR := SQLCODE;
      V_MSG   := SQLERRM;
  END;
  IF V_ERROR <> 0 THEN
    RETURN;
  END IF;

  --1、插入两行空行
  BEGIN
    INSERT INTO TJBB_DT_B02104 (SSNY,BBLC,SWJGDM,BAHS,BAHS_HZ,SBHS,SBHS_HZ,SBTSCKE,SBTSCKE_HZ,ZYSP)
    SELECT LC_THISMONTH, '01', V_SWCODE, 0, 0, 0, 0, 0, 0, ''
      FROM DUAL
     UNION ALL
    SELECT LC_THISMONTH, '02', V_SWCODE, 0, 0, 0, 0, 0, 0, ''
      FROM DUAL
     UNION ALL
    SELECT LC_THISMONTH, '03', V_SWCODE, 0, 0, 0, 0, 0, 0, ''
      FROM DUAL
     UNION ALL
    SELECT LC_THISMONTH, '04', V_SWCODE, 0, 0, 0, 0, 0, 0, ''
      FROM DUAL
      ;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      V_ERROR := SQLCODE;
      V_MSG   := SQLERRM;
  END;

  RETURN;
END;
/
