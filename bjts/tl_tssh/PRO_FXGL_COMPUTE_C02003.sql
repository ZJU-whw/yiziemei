CREATE OR REPLACE PROCEDURE PRO_FXGL_COMPUTE_C02003
/*
 * 供货企业存在复函异常情形
 * 需要从金三同步函调异常数据到TL_ADMIN.YJ_CS_YCHD_JS表中
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
  V_MONTHS_YCFUH  NUMBER(18,2);    --预警参数：异常复函情形起监控周期
  V_PARAMS        VARCHAR(4000);
  V_SWJGDM        VARCHAR(11);
BEGIN
  -- 取本次风险扫描的参数
  SELECT NVL(S.VAL_DEF,T.VAL_DEF) / DECODE(T.CSTYPE,'百分比',100, 1)
    INTO V_MONTHS_YJJG
    FROM FXGL_PZ_ZB_CS T
    LEFT JOIN FXGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJGDM AND S.YXBZ='Y'
   WHERE T.CSBM='C02003_MONTHS_YJJG';
  SELECT NVL(S.VAL_DEF,T.VAL_DEF) / DECODE(T.CSTYPE,'百分比',100, 1)
    INTO V_MONTHS_YCFUH
    FROM FXGL_PZ_ZB_CS T
    LEFT JOIN FXGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJGDM AND S.YXBZ='Y'
   WHERE T.CSBM='C02003_MONTHS_YCFUH';
  V_PARAMS:='[d]预警间隔周期='||V_MONTHS_YJJG||
            '|异常复函情形起监控周期=' || V_MONTHS_YCFUH;

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
     WHERE T.ZBID='C02003'
       AND T.TSSWJG_DM LIKE V_SWJGDM
       AND (P_DJXH IS NULL OR T.DJXH=P_DJXH)
       AND TRUNC(T.SMRQ,'MM')=TRUNC(SYSDATE,'MM')
       AND T.HSJGLX='0';
    COMMIT;
  END IF;

  --上月以来有申报的外贸企业
  FOR CUR_CKQY IN (SELECT T.DJXH,T.LCSLID_SB,T.QDSJ
                     FROM CKTS_LC_SBXX T
                    WHERE T.TSSWJG_DM LIKE V_SWJGDM --税务机关范围扫描
                      AND (P_DJXH IS NULL OR T.DJXH=P_DJXH) --是否单个企业扫描
                      AND NVL(T.ZFBZ, 'N') = 'N'
                      AND T.QDSJ >= ADD_MONTHS(TRUNC(SYSDATE,'MM'),-1)
                      AND T.SBYWB_DM='A0301001'
                      AND (  (NVL(P_SMLX,'0')='1')
                          OR (NVL(P_SMLX,'0')='0'
                         AND NOT EXISTS (SELECT 1 --预警间隔期不自动扫描同一企业信息
                                           FROM FXGL_DATA_ZXZB B
                                          WHERE B.DJXH=T.DJXH
                                            AND B.ZBID='C02003'
                                            AND B.HSRQ>ADD_MONTHS(SYSDATE, (-1) * V_MONTHS_YJJG)
                                            AND B.HSRY!='SYSTEM'))))
  LOOP
    BEGIN
      INSERT INTO FXGL_DATA_ZXZB(ID,TSSWJG_DM,DJXH,NSRSBH,NSRMC,SMLX,SMRQ,ZBID,ZBCS,SMJG)
           SELECT SEQ_FXGL_DATA_ZXZB.NEXTVAL,DJ.SWJGDM,DJ.DJXH_JS,NVL(DJ.SHXYNO,DJ.NSRDJNO),DJ.NSRMC,NVL(P_SMLX,'0'),SYSDATE,'C02003',
                  V_PARAMS,'[d]所属期批次=' || YC.SSQPC || '|供货方纳税人=' ||YC.GHFNSRSBH_1||
                  '|退税额合计=' ||YC.TSE||'|风险情况=供货企业存在复函异常情形'
             FROM (SELECT SB.DJXH,SB.SSQ||SB.SBPC AS SSQPC,SB.GHFNSRSBH_1,SUM(TSE) AS TSE
                     FROM CKTS_SB_MTS_JHMX SB
                    WHERE LCSLID_SB=CUR_CKQY.LCSLID_SB
                      AND EXISTS (SELECT 1
                                    FROM TL_ADMIN.YJ_CS_YCHD_JS HD
                                   WHERE HD.GHQYNSRSBH_1=SB.GHFNSRSBH_1
                                     AND HD.FUHLX_DM='2'
                                     AND ADD_MONTHS(HD.FUHQFRQ,V_MONTHS_YCFUH)>CUR_CKQY.QDSJ)
                    GROUP BY SB.DJXH,SB.SSQ,SB.SBPC,SB.GHFNSRSBH_1
                   HAVING SUM(SB.TSE)>0) YC
            INNER JOIN GLXT_BB_SHXT_DJXX DJ ON DJ.DJXH_JS=YC.DJXH;
      COMMIT;
    END;
  END LOOP;

  RETURN;
END;
/
