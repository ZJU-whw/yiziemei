CREATE OR REPLACE PROCEDURE PRO_TJBB_DT_B02110_CSH_NEW
/**************************************************************
 * 海关特殊监管区域企业增值税一般纳税人资格试点情况统计表
 **************************************************************/
(
  V_SWCODE  IN  VARCHAR2,
  V_SSNY IN VARCHAR2,
  V_ERROR   OUT NUMBER,
  V_MSG     OUT VARCHAR2
)
AS
  LD_SYSDATE       DATE;
  LC_THISMONTH     VARCHAR2(6);
  LC_PREVMONTH     VARCHAR2(6);
  V_TEMP           NUMBER(5) := 0;
  LN_I             NUMBER(5);
BEGIN
  V_ERROR :=0;
  V_MSG   := ' ';

  IF V_SSNY IS NOT NULL THEN
    LD_SYSDATE:=TO_DATE(V_SSNY||'01','YYYYMMDD');
  ELSE
    LD_SYSDATE:=SYSDATE;
  END IF;

  LC_THISMONTH :=TO_CHAR(LD_SYSDATE,'YYYYMM');
  LC_PREVMONTH :=TO_CHAR(ADD_MONTHS(LD_SYSDATE,-1),'YYYYMM');
  
  --0、清除原有制表数据，准备重新制表
  BEGIN
    DELETE FROM TJBB_DT_B02110 WHERE SWJGDM=V_SWCODE AND SSNY=LC_THISMONTH;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      V_ERROR := SQLCODE;
      V_MSG   := SQLERRM;
      RETURN;
  END;

  --1、统计
  BEGIN
    --检查是否第一次使用该报表
    SELECT COUNT(1)
      INTO V_TEMP
      FROM TJBB_DT_B02110
     WHERE SWJGDM=V_SWCODE AND SSNY=LC_PREVMONTH AND ROWNUM=1;
    IF (V_TEMP = 0) OR (SUBSTR(LC_THISMONTH,5)='01') THEN
      --首次使用该报表，或每年****01所属期，插入20行空行数据
      BEGIN
        FOR LN_I IN 1 .. 20 LOOP
          BEGIN
            INSERT INTO TJBB_DT_B02110 (SSNY,BBLC,SWJGDM,BYS,BYS_HZ,SYLJS,SYLJS_HZ,LJS,LJS_HZ)
            SELECT LC_THISMONTH, CASE WHEN LN_I<10 THEN '0'||TO_CHAR(LN_I) ELSE ''||TO_CHAR(LN_I) END, V_SWCODE, 0, 0, 0, 0, 0, 0
              FROM DUAL;
          END;
        END LOOP;
      END;
    ELSE
      --其他情况，将上月报表拷贝本年累计数复制到本月的上月累计数及本月累计数
      BEGIN
        INSERT INTO TJBB_DT_B02110 (SSNY,BBLC,SWJGDM,BYS,BYS_HZ,SYLJS,SYLJS_HZ,LJS,LJS_HZ)
        SELECT LC_THISMONTH, BBLC, SWJGDM, 0, 0, LJS, LJS_HZ, LJS, LJS_HZ
          FROM TJBB_DT_B02110
         WHERE SWJGDM=V_SWCODE AND SSNY=LC_PREVMONTH;
      END;
    END IF;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      V_ERROR := SQLCODE;
      V_MSG   := SQLERRM;
      RETURN;
  END;

  RETURN;
END;
/
