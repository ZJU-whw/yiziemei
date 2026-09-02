CREATE OR REPLACE PROCEDURE PRO_TJBB_DT_B03111_CSH_NEW
/*************************************************
 * 浙江省出口企业函调情况统计表
 ************************************************/
(
  V_SWCODE  IN  VARCHAR2,
  V_SSNY    IN  VARCHAR2,
  V_ERROR   OUT NUMBER,
  V_MSG     OUT VARCHAR2
)
AS
  LC_THISMONTH     VARCHAR2(6);
  LD_SYSDATE       DATE;
  LN_I             NUMBER(2);
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
    DELETE FROM TJBB_DT_B03111 WHERE SWJGDM=V_SWCODE AND SSNY=LC_THISMONTH;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      V_ERROR := SQLCODE;
      V_MSG   := SQLERRM;
      RETURN;
  END;

  --1、插入两行空行
  BEGIN
    LN_I := 0;
    FOR LN_I IN 1 .. 8 LOOP
      BEGIN
        INSERT INTO TJBB_DT_B03111(SSNY,BBLC,SWJGDM,FP_SL,FP_SL_HZ,HSHFH_SL,HSHFH_SL_HZ,JS_JE,JS_JE_HZ,TS_JE,TS_JE_HZ)
        SELECT LC_THISMONTH, '0'||TO_CHAR(LN_I), V_SWCODE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
          FROM DUAL;
      END;
    END LOOP;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      V_ERROR := SQLCODE;
      V_MSG   := SQLERRM;
  END;

  RETURN;
END;
/
