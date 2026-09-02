CREATE OR REPLACE PROCEDURE PRO_FXGL_COMPUTE_C07001
/*
 * 生产企业货源地异常模型
 * 货源地不在本地市，免抵退明细未申报视同自产
 * 数据量有点大，全省202508月申报的类似数据有6512条
 */
(
  P_SWJGDM  IN VARCHAR2, --可空，空默认全省，前台手工刷新需传入
  P_DJXH    IN VARCHAR2, --可空，空默认税务机关下所有有申报企业，前台当个企业刷新需传入
  P_SMLX    IN VARCHAR2 --可空，空默认自动扫描，前台人工扫描输入1
)
AS
  V_MYLAJ_MIN     NUMBER(18,2);    --预警参数：连续3个月内美元出口额
  V_PARAMS        VARCHAR(4000);
  V_SWJGDM        VARCHAR(11);
BEGIN
  -- 取本次风险扫描的参数
  SELECT NVL(S.VAL_DEF,T.VAL_DEF) / DECODE(T.CSTYPE,'百分比',100, 1)
    INTO V_MYLAJ_MIN
    FROM FXGL_PZ_ZB_CS T
    LEFT JOIN FXGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJGDM AND S.YXBZ='Y'
   WHERE T.CSBM='C07001_MYLAJ_MIN';
  V_PARAMS:='[d]报关单最低货值（美元）=' || V_MYLAJ_MIN;
  
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
     WHERE T.ZBID='C07001'
       AND T.TSSWJG_DM LIKE V_SWJGDM
       AND (P_DJXH IS NULL OR T.DJXH=P_DJXH)
       AND TRUNC(T.SMRQ,'MM')=TRUNC(SYSDATE,'MM')
       AND T.HSJGLX='0';
    COMMIT;
  END IF;
  
  --上月申报的免抵退数据
  BEGIN
    INSERT INTO FXGL_DATA_ZXZB(ID,TSSWJG_DM,DJXH,NSRSBH,NSRMC,SMLX,SMRQ,ZBID,ZBCS,SMJG)
         SELECT SEQ_FXGL_DATA_ZXZB.NEXTVAL,CK.TSSWJG_DM,CK.DJXH,NVL(DJ.SHXYNO,DJ.NSRDJNO),DJ.NSRMC,NVL(P_SMLX,'0'),SYSDATE,'C07001',
                V_PARAMS,'[d]报关单或代理证明号=' || NVL(CK.CKBGDH,CK.DLCKHWZMHM) || '|美元离岸价=' || CK.MYLAJ ||
                '|货源地=' ||CK.HZDWDQDM || '(' || NVL(DM.HGHYD_MC,CK.HZDWDQDM) || ')|出口退免税业务类型 = ' || NVL(CK.CKTMSYWLXDMJH,' ')
         FROM CKTS_SB_MDT_CKMX CK
        INNER JOIN GLXT_BB_SHXT_DJXX DJ
           ON DJ.DJXH_JS=CK.DJXH
         LEFT JOIN TL_ADMIN.DM_HGHYD DM
           ON DM.HGHYD_DM=CK.HZDWDQDM
        WHERE CK.TSSWJG_DM LIKE V_SWJGDM --税务机关范围扫描
          AND CK.SBRQ>=TRUNC(ADD_MONTHS(SYSDATE,-1),'MM')
          AND CK.SBRQ<TRUNC(SYSDATE,'MM') --上月申报免抵退，所属期为当前月份-2
          AND (P_DJXH IS NULL OR CK.DJXH=P_DJXH) --是否单个企业扫描
          AND CK.MYLAJ>=V_MYLAJ_MIN -- 报关单最低货值
          AND NVL(DM.XZQH_DM,CK.HZDWDQDM) <> SUBSTR(CK.TSSWJG_DM,2,4)
          AND NOT REGEXP_LIKE(NVL(CK.CKTMSYWLXDMJH,' '),'ST')
          AND NOT EXISTS (SELECT 1 -- 去重处理
                            FROM FXGL_DATA_ZXZB ZB
                           WHERE ZB.DJXH=CK.DJXH
                             AND ZB.ZBID='C07001'
                             AND REGEXP_LIKE(ZB.SMJG,NVL(CK.CKBGDH,CK.DLCKHWZMHM))
                             AND ZB.HSJGLX='0');
    COMMIT;
  END;

  RETURN;
END;
/
