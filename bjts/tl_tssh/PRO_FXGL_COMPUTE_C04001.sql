CREATE OR REPLACE PROCEDURE PRO_FXGL_COMPUTE_C04001
/*
 * 电子产品出口异常模型
 * 电子产品列表，在FXGL_SZ_SPFXCK中定义，规则名称为“电子产品_”
 * 20250610，修改扫描时间间隔条件，原先为不存在6个月内的自动扫描结果，改为人工扫描全部执行，自动扫描不存在6个月以内的数据
 * 20260327，自动扫描条件改为不存在6个月以内已人工核实的数据，因税务人员调整参数自动核实的数据不算
 */
(
  P_SWJGDM  IN VARCHAR2, --可空，空默认全省，前台手工刷新需传入
  P_DJXH    IN VARCHAR2, --可空，空默认税务机关下所有有申报企业，前台当个企业刷新需传入
  P_SMLX    IN VARCHAR2 --可空，空默认自动扫描，前台人工扫描输入1
)
AS
  V_MONTHS_YJJG   NUMBER(18,2);    --预警参数：预警间隔周期
  V_MYLAJ_LX3M    NUMBER(18,2);    --预警参数：连续3个月内美元出口额
  V_PARAMS        VARCHAR(4000);
  V_SWJGDM        VARCHAR(11);
  V_MYLAJ         NUMBER(18,2);    --统计结果：连续3个月内美元出口额
  V_CKSP          VARCHAR(200);
  V_CKSPDM        VARCHAR(200);
BEGIN
  -- 取本次风险扫描的参数
  SELECT NVL(S.VAL_DEF,T.VAL_DEF) / DECODE(T.CSTYPE,'百分比',100, 1)
    INTO V_MONTHS_YJJG
    FROM FXGL_PZ_ZB_CS T
    LEFT JOIN FXGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJGDM AND S.YXBZ='Y'
   WHERE T.CSBM='C04001_MONTHS_YJJG';
  SELECT NVL(S.VAL_DEF,T.VAL_DEF) / DECODE(T.CSTYPE,'百分比',100, 1)
    INTO V_MYLAJ_LX3M
    FROM FXGL_PZ_ZB_CS T
    LEFT JOIN FXGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJGDM AND S.YXBZ='Y'
   WHERE T.CSBM='C04001_MYLAJ_LX3M';
  V_PARAMS:='[d]预警间隔周期='||V_MONTHS_YJJG||
            '|连续3个月内美元出口额阈值=' || V_MYLAJ_LX3M;
  
  --取本次风险扫描的税务机关范围
  IF NVL(P_SWJGDM,'13300000000')='13300000000' THEN
    V_SWJGDM:='133%';
  ELSIF SUBSTR(P_SWJGDM,6)='000000' THEN
    V_SWJGDM:=SUBSTR(P_SWJGDM,1,5)||'%';
  ELSE
    V_SWJGDM:=SUBSTR(P_SWJGDM,1,7)||'%';
  END IF;
  
  IF P_SMLX=1 THEN
    UPDATE FXGL_DATA_ZXZB T
       SET T.HSJGLX='1', T.HSRQ=SYSDATE, T.HSRY='SYSTEM', T.HSCLQK='税务人员调整预警参数，重新刷新本次风险指标。'
     WHERE T.ZBID='C04001'
       AND T.TSSWJG_DM LIKE V_SWJGDM
       AND (P_DJXH IS NULL OR T.DJXH=P_DJXH)
       AND TRUNC(T.SMRQ,'MM')=TRUNC(SYSDATE,'MM')
       AND T.HSJGLX='0';
    COMMIT;
  END IF;
  
  -- 电子产品列表
  SELECT TO_CHAR(REPLACE(WM_CONCAT(T.GZ_SPDM),',','|'))
    INTO V_CKSP
    FROM FXGL_SZ_SPFXCK T
   WHERE T.GZ_MC LIKE '电子类产品%';

  --上月以来有申报的出口企业
  FOR CUR_CKQY IN (SELECT DISTINCT T.DJXH
                     FROM CKTS_LC_SBXX T
                    WHERE T.TSSWJG_DM LIKE V_SWJGDM --税务机关范围扫描
                      AND (P_DJXH IS NULL OR T.DJXH=P_DJXH) --是否单个企业扫描
                      AND NVL(T.ZFBZ, 'N') = 'N'
                      AND T.QDSJ >= ADD_MONTHS(TRUNC(SYSDATE,'MM'),-1)
                      AND (  (NVL(P_SMLX,'0')='1')
                          OR (NVL(P_SMLX,'0')='0'
                         AND NOT EXISTS (SELECT 1 --预警间隔期不自动扫描同一企业信息
                                           FROM FXGL_DATA_ZXZB B
                                          WHERE B.DJXH=T.DJXH
                                            AND B.ZBID='C04001'
                                            AND B.HSRQ>ADD_MONTHS(SYSDATE, (-1) * V_MONTHS_YJJG)
                                            AND B.HSRY!='SYSTEM'))))
  LOOP
    --统计连续三个月电子产品美元出口额，不包含当月数据
    SELECT NVL(SUM(MYLAJ),0), TO_CHAR(WM_CONCAT(CKSP_DM))
      INTO V_MYLAJ, V_CKSPDM
      FROM (SELECT CKSP_DM, SUM(MYLAJ) AS MYLAJ
              FROM CKTS_WBSJ_HG_BGD
             WHERE DJXH=CUR_CKQY.DJXH
               AND CKRQ_1>=ADD_MONTHS(TRUNC(SYSDATE,'MM'),-3)
               AND CKRQ_1<TRUNC(SYSDATE,'MM')
               AND ZMTBZ='T'
               AND REGEXP_LIKE(CKSP_DM,V_CKSP)
             GROUP BY CKSP_DM);
    --如果连续3个月美元出口额大于参数值，添加风险数据
    IF V_MYLAJ>=V_MYLAJ_LX3M THEN
      INSERT INTO FXGL_DATA_ZXZB(ID,TSSWJG_DM,DJXH,NSRSBH,NSRMC,SMLX,SMRQ,ZBID,ZBCS,SMJG)
           SELECT SEQ_FXGL_DATA_ZXZB.NEXTVAL,TT.SWJGDM,TT.DJXH_JS,NVL(TT.SHXYNO,TT.NSRDJNO),TT.NSRMC,NVL(P_SMLX,'0'),SYSDATE,'C04001',
                  V_PARAMS,'[d]连续三个月电子产品美元出口额=' || V_MYLAJ || '，主要出口商品代码：'||V_CKSPDM
             FROM GLXT_BB_SHXT_DJXX TT
            WHERE TT.DJXH_JS=CUR_CKQY.DJXH;
      COMMIT;
    END IF;
  END LOOP;
  
  RETURN;
END;
/
