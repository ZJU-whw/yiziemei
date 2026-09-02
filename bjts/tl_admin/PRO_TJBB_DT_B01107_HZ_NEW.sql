CREATE OR REPLACE PROCEDURE PRO_TJBB_DT_B01107_HZ_NEW
/****************************************************
 * 全国出口退税专设机构设置及专职人员配备年度统计表
 * 202202，调整口径，按用户表中金三国地税用户筛选，原审核系统或其他用户不统计，其中原国税以133开始，原地税以233开始
 ***************************************************/
(
  V_SWCODE  IN  VARCHAR2,
  V_SSNY IN VARCHAR2,
  V_ERROR   OUT NUMBER,
  V_MSG     OUT VARCHAR2
)
AS
  LD_SYSDATE       DATE;
  LC_THISMONTH     VARCHAR2(6);

  LC_SWJGMC        VARCHAR2(100);
  LN_USERS         NUMBER(10);
BEGIN
  V_ERROR :=0;
  V_MSG   := ' ';

  IF V_SSNY IS NOT NULL THEN
    LD_SYSDATE:=TO_DATE(V_SSNY||'01','YYYYMMDD');
  ELSE
    LD_SYSDATE:=TRUNC(SYSDATE,'MM');
  END IF;
  LC_THISMONTH :=TO_CHAR(LD_SYSDATE,'YYYYMM');

  --0、清除原有制表数据，准备重新制表
  BEGIN
    DELETE FROM TJBB_DT_B01107 WHERE SWJGDM=V_SWCODE AND SSNY=LC_THISMONTH;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      V_ERROR := SQLCODE;
      V_MSG   := SQLERRM;
      RETURN;
  END;

  --1、计算列
  BEGIN
    --税务机关名称
    IF SUBSTR(V_SWCODE,1,1)='1' THEN
      BEGIN
        SELECT SWJG_JC
          INTO LC_SWJGMC
          FROM DM_SWJG
         WHERE SWJG_DM=V_SWCODE;
      END;
    ELSE
      BEGIN
        SELECT VIR_NAME
          INTO LC_SWJGMC
          FROM DM_SWJG_VIRTUAL
         WHERE VIR_SWJGDM=V_SWCODE;
      END;
    END IF;

    --本级税务机关人数
    SELECT COUNT(1)
      INTO LN_USERS
      FROM SYS_USER T
     WHERE T.SWJG_DM=V_SWCODE
       AND T.USRSTATE='3' AND (T.CZRY_DM LIKE '133%' OR T.CZRY_DM LIKE '233%');

    IF V_SWCODE='13300000000' THEN
      BEGIN
        INSERT INTO TJBB_DT_B01107(SSNY,BBLC,SWJGDM,SWJGMC,
                    JG_HJ,JG_HJ_HZ,
                    JG_DS_CITY,JG_DS_CITY_HZ,JG_DS_JG,JG_DS_JG_HZ,JG_DS_LV,JG_DS_LV_HZ,
                    JG_XJ_CITY,JG_XJ_CITY_HZ,JG_XJ_JG,JG_XJ_JG_HZ,JG_XJ_LV,JG_XJ_LV_HZ,
                    RY_HJ,RY_HJ_HZ,
                    RY_DS,RY_DS_HZ,RY_DS_LV,RY_DS_LV_HZ,
                    RY_XJ,RY_XJ_HZ,RY_XJ_LV,RY_XJ_LV_HZ,
                    PER_SE,PER_SE_HZ)
             SELECT LC_THISMONTH, '01', V_SWCODE, LC_SWJGMC,
                    SUM(JG_HJ)+1,SUM(JG_HJ_HZ)+1,
                    SUM(JG_DS_CITY),SUM(JG_DS_CITY_HZ),SUM(JG_DS_JG)+1,SUM(JG_DS_JG_HZ)+1,
                    100*(SUM(JG_DS_JG)+1)/SUM(JG_DS_CITY),100*(SUM(JG_DS_JG_HZ)+1)/SUM(JG_DS_CITY_HZ),
                    SUM(JG_XJ_CITY),SUM(JG_XJ_CITY_HZ),SUM(JG_XJ_JG),SUM(JG_XJ_JG_HZ),
                    100*SUM(JG_XJ_JG)/SUM(JG_XJ_CITY),100*SUM(JG_XJ_JG_HZ)/SUM(JG_XJ_CITY_HZ),
                    SUM(RY_HJ)+LN_USERS,SUM(RY_HJ_HZ)+LN_USERS,
                    SUM(RY_DS)+LN_USERS,SUM(RY_DS_HZ)+LN_USERS,
                    100*(SUM(RY_DS)+LN_USERS)/(SUM(RY_HJ)+LN_USERS),100*(SUM(RY_DS_HZ)+LN_USERS)/(SUM(RY_HJ_HZ)+LN_USERS),
                    SUM(RY_XJ),SUM(RY_XJ_HZ),
                    100*SUM(RY_XJ)/(SUM(RY_HJ)+LN_USERS),100*SUM(RY_XJ_HZ)/(SUM(RY_HJ_HZ)+LN_USERS),
                    SUM(PER_SE * RY_HJ)/(SUM(RY_HJ)+LN_USERS),SUM(PER_SE_HZ * RY_HJ)/(SUM(RY_HJ)+LN_USERS)
               FROM TJBB_DT_B01107 T
              WHERE T.SSNY=LC_THISMONTH
                AND T.SWJGDM IN (SELECT SWJG_DM FROM TABLE(TL_ADMIN.FUNC_GET_XJ_SWJG(V_SWCODE)));
      END;
    ELSE
      BEGIN
        INSERT INTO TJBB_DT_B01107(SSNY,BBLC,SWJGDM,SWJGMC,
                    JG_HJ,JG_HJ_HZ,
                    JG_DS_CITY,JG_DS_CITY_HZ,JG_DS_JG,JG_DS_JG_HZ,JG_DS_LV,JG_DS_LV_HZ,
                    JG_XJ_CITY,JG_XJ_CITY_HZ,JG_XJ_JG,JG_XJ_JG_HZ,JG_XJ_LV,JG_XJ_LV_HZ,
                    RY_HJ,RY_HJ_HZ,
                    RY_DS,RY_DS_HZ,RY_DS_LV,RY_DS_LV_HZ,
                    RY_XJ,RY_XJ_HZ,RY_XJ_LV,RY_XJ_LV_HZ,
                    PER_SE,PER_SE_HZ)
             SELECT LC_THISMONTH, '01', V_SWCODE, LC_SWJGMC,
                    SUM(JG_HJ)+1,SUM(JG_HJ_HZ)+1,
                    1,1,1,1,1,1,
                    SUM(JG_XJ_CITY),SUM(JG_XJ_CITY_HZ),SUM(JG_XJ_JG),SUM(JG_XJ_JG_HZ),
                    100*SUM(JG_XJ_JG)/SUM(JG_XJ_CITY),100*SUM(JG_XJ_JG_HZ)/SUM(JG_XJ_CITY_HZ),
                    SUM(RY_HJ)+LN_USERS,SUM(RY_HJ_HZ)+LN_USERS,
                    LN_USERS,LN_USERS,
                    100*LN_USERS/(SUM(RY_HJ)+LN_USERS),100*LN_USERS/(SUM(RY_HJ_HZ)+LN_USERS),
                    SUM(RY_XJ),SUM(RY_XJ_HZ),
                    100*SUM(RY_XJ)/(SUM(RY_HJ)+LN_USERS),100*SUM(RY_XJ_HZ)/(SUM(RY_HJ_HZ)+LN_USERS),
                    SUM(PER_SE * RY_HJ)/(SUM(RY_HJ)+LN_USERS),SUM(PER_SE_HZ * RY_HJ)/(SUM(RY_HJ)+LN_USERS)
               FROM TJBB_DT_B01107 T
              WHERE T.SSNY=LC_THISMONTH
                AND T.SWJGDM IN (SELECT SWJG_DM FROM TABLE(TL_ADMIN.FUNC_GET_XJ_SWJG(V_SWCODE)));
      END;
    END IF;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      V_ERROR := SQLCODE;
      V_MSG   := SQLERRM;
  END;

  RETURN;
END;
/
