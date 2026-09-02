CREATE OR REPLACE PROCEDURE PRO_FXGL_COMPUTE_C02001
/*
 * 货物出口日期早于供货企业开业登记日期
 * 需要从金三同步DJ_NSRXX表中KZZTDJLX=1110，KQCCSZTDJBZ=N的名单
 * 20250610，修改扫描时间间隔条件，原先为不存在6个月内的自动扫描结果，改为人工扫描全部执行，自动扫描不存在6个月以内的数据
 * 20250829，原来根据上月申报的流程进行扫描，调整为对上月有申报的企业，自上一次相同指标扫描日期（没有扫描日期按系统日期前推一年）之后申报的数据
 * 20260327，自动扫描条件改为不存在6个月以内已人工核实的数据，因税务人员调整参数自动核实的数据不算
 */
(
  P_SWJGDM  IN VARCHAR2, --可空，空默认全省，前台手工刷新需传入
  P_DJXH    IN VARCHAR2, --可空，空默认税务机关下所有有申报企业，前台当个企业刷新需传入
  P_SMLX    IN VARCHAR2 --可空，空默认自动扫描，前台人工扫描输入1
)
AS
  V_MONTHS_YJJG   NUMBER(18,2);    --预警参数：预警间隔周期
  V_PARAMS        VARCHAR(4000);
  V_SWJGDM        VARCHAR(11);
BEGIN
  -- 取本次风险扫描的参数
  SELECT NVL(S.VAL_DEF,T.VAL_DEF) / DECODE(T.CSTYPE,'百分比',100, 1)
    INTO V_MONTHS_YJJG
    FROM FXGL_PZ_ZB_CS T
    LEFT JOIN FXGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJGDM AND S.YXBZ='Y'
   WHERE T.CSBM='C02001_MONTHS_YJJG';
  V_PARAMS:='[d]预警间隔周期='||V_MONTHS_YJJG;

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
     WHERE T.ZBID='C02001'
       AND T.TSSWJG_DM LIKE V_SWJGDM
       AND (P_DJXH IS NULL OR T.DJXH=P_DJXH)
       AND TRUNC(T.SMRQ,'MM')=TRUNC(SYSDATE,'MM')
       AND T.HSJGLX='0';
    COMMIT;
  END IF;

  --上月以来有申报的外贸企业
  FOR CUR_CKQY IN (SELECT DISTINCT T.DJXH
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
                                            AND B.ZBID='C02001'
                                            AND B.HSRQ>ADD_MONTHS(SYSDATE, (-1) * V_MONTHS_YJJG)
                                            AND B.HSRY!='SYSTEM'))))
  LOOP
    BEGIN
      INSERT INTO FXGL_DATA_ZXZB(ID,TSSWJG_DM,DJXH,NSRSBH,NSRMC,SMLX,SMRQ,ZBID,ZBCS,SMJG)
           SELECT SEQ_FXGL_DATA_ZXZB.NEXTVAL,DJ.SWJGDM,DJ.DJXH_JS,NVL(DJ.SHXYNO,DJ.NSRDJNO),DJ.NSRMC,NVL(P_SMLX,'0'),SYSDATE,'C02001',
                  V_PARAMS,'[d]所属期批次=' || YC.SSQPC || '|供货方纳税人=' ||YC.GHFNSRSBH_1||
                  '|登记日期=' ||TO_CHAR(YC.DJRQ,'YYYYMMDD')||
                  '|出口日期范围=' ||TO_CHAR(YC.MIN_CKRQ,'YYYYMMDD')||'-'||TO_CHAR(YC.MAX_CKRQ,'YYYYMMDD')||
                  '|涉及退税额='||TSE
             FROM (SELECT DJXH,SSQPC,GHFNSRSBH_1,DJRQ,MIN(CKRQ_1) AS MIN_CKRQ,MAX(CKRQ_1) AS MAX_CKRQ,SUM(TSE) AS TSE
                     FROM (SELECT DJXH,SSQ||SBPC AS SSQPC,GHFNSRSBH_1,CKRQ_1,TSE,
                                  (SELECT MIN(GH.DJRQ)
                                     FROM CKTS_DJ_NSRXX GH
                                    WHERE GH.NSRSBH=SB.GHFNSRSBH_1
                                      AND GH.NSRZT_DM NOT IN ('09','10')
                                      AND NVL(GH.ZXRQ,SYSDATE)>SB.KPRQ) AS DJRQ
                             FROM CKTS_SB_MTS_JHMX SB
                             LEFT JOIN (SELECT MAX(SMRQ) AS SMRQ
                                          FROM FXGL_DATA_ZXZB
                                         WHERE DJXH=CUR_CKQY.DJXH
                                           AND ZBID='C02001'
                                           AND NVL(HSRY,'1')!='SYSTEM') HS
                               ON 1=1
                            WHERE SB.DJXH=CUR_CKQY.DJXH
                              AND SB.SBRQ > NVL(HS.SMRQ, ADD_MONTHS(SYSDATE, -24))
                              AND CKRQ_1>DATE'1900-01-01' --CKRQ_1是etl后置存储过程处理的，需要剔除还没赋值的情况
                              AND TSE>0) TT  --检查正数申报，红字冲减的去掉
                    WHERE CKRQ_1<TRUNC(DJRQ)
                    GROUP BY DJXH,SSQPC,GHFNSRSBH_1,DJRQ) YC
            INNER JOIN GLXT_BB_SHXT_DJXX DJ ON DJ.DJXH_JS=YC.DJXH;
      COMMIT;
    END;
  END LOOP;

  RETURN;
END;
/
