CREATE OR REPLACE PROCEDURE PRO_TJBB_DT_B02111_CSH_NEW
/**************************************************************
 * 跨境电商综试区跨境电商出口额统计表
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
  LD_INITDATE      DATE;
  LC_INITMONTH     VARCHAR2(6);
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
    DELETE FROM TJBB_DT_B02111 WHERE SWJGDM=V_SWCODE AND SSNY=LC_THISMONTH;
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
      FROM TJBB_DT_B02111
     WHERE SWJGDM=V_SWCODE AND SSNY=LC_PREVMONTH AND ROWNUM=1;
    IF V_TEMP = 0 THEN
      BEGIN
        --首次使用该报表，从201801开始每月一行记录初始化
        LD_INITDATE:= TO_DATE('2018-01-01','YYYY-MM-DD');
        LOOP
          EXIT WHEN LD_INITDATE >LD_SYSDATE;
          LC_INITMONTH :=TO_CHAR(LD_INITDATE,'YYYYMM');
          INSERT INTO TJBB_DT_B02111 (
                 SSNY,BBLC,SWJGDM,QJNY,
                 WPMS_CKE_HS,WPMS_CKE_HS_HZ,WPMS_CKE_JE,WPMS_CKE_JE_HZ,
                 XFSMS_CKE,XFSMS_CKE_HZ,ZZSMS_CKE,ZZSMS_CKE_HZ,
                 BGCK_HS,BGCK_HS_HZ,BGCK_JE,BGCK_JE_HZ,
                 CKTMS_HS,CKTMS_HS_HZ,CKTMS_JE,CKTMS_JE_HZ)
          SELECT LC_THISMONTH, LC_INITMONTH,V_SWCODE,LC_INITMONTH,
                 0,0,0,0,
                 0,0,0,0,
                 0,0,0,0,
                 0,0,0,0
                FROM DUAL;
          LD_INITDATE := ADD_MONTHS(LD_INITDATE,1);
        END LOOP;
      END;
    ELSE
      BEGIN
        --非首次使用该报表，从上月报表拷贝相同数据到本月
        INSERT INTO TJBB_DT_B02111 (
               SSNY,BBLC,SWJGDM,QJNY,
               WPMS_CKE_HS,WPMS_CKE_HS_HZ,WPMS_CKE_JE,WPMS_CKE_JE_HZ,
               XFSMS_CKE,XFSMS_CKE_HZ,ZZSMS_CKE,ZZSMS_CKE_HZ,
               BGCK_HS,BGCK_HS_HZ,BGCK_JE,BGCK_JE_HZ,
               CKTMS_HS,CKTMS_HS_HZ,CKTMS_JE,CKTMS_JE_HZ)
        SELECT LC_THISMONTH,BBLC,SWJGDM,QJNY,
               WPMS_CKE_HS,WPMS_CKE_HS_HZ,WPMS_CKE_JE,WPMS_CKE_JE_HZ,
               XFSMS_CKE,XFSMS_CKE_HZ,ZZSMS_CKE,ZZSMS_CKE_HZ,
               BGCK_HS,BGCK_HS_HZ,BGCK_JE,BGCK_JE_HZ,
               CKTMS_HS,CKTMS_HS_HZ,CKTMS_JE,CKTMS_JE_HZ
          FROM TJBB_DT_B02111
         WHERE SWJGDM=V_SWCODE AND SSNY=LC_PREVMONTH;
        --增加本月数据
        INSERT INTO TJBB_DT_B02111 (
               SSNY,BBLC,SWJGDM,QJNY,
               WPMS_CKE_HS,WPMS_CKE_HS_HZ,WPMS_CKE_JE,WPMS_CKE_JE_HZ,
               XFSMS_CKE,XFSMS_CKE_HZ,ZZSMS_CKE,ZZSMS_CKE_HZ,
               BGCK_HS,BGCK_HS_HZ,BGCK_JE,BGCK_JE_HZ,
               CKTMS_HS,CKTMS_HS_HZ,CKTMS_JE,CKTMS_JE_HZ)
        SELECT LC_THISMONTH, LC_THISMONTH,V_SWCODE,LC_THISMONTH,
               0,0,0,0,
               0,0,0,0,
               0,0,0,0,
               0,0,0,0
              FROM DUAL;
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
