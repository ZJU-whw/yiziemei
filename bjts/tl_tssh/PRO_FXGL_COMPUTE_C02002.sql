CREATE OR REPLACE PROCEDURE PRO_FXGL_COMPUTE_C02002
/*
 * 已申报退税但发票状态非正常
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
   WHERE T.CSBM='C02002_MONTHS_YJJG';
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
     WHERE T.ZBID='C02002'
       AND T.TSSWJG_DM LIKE V_SWJGDM
       AND (P_DJXH IS NULL OR T.DJXH=P_DJXH)
       AND TRUNC(T.SMRQ,'MM')=TRUNC(SYSDATE,'MM')
       AND T.HSJGLX='0';
    COMMIT;
  END IF;

  INSERT INTO FXGL_DATA_ZXZB(ID,TSSWJG_DM,DJXH,NSRSBH,NSRMC,SMLX,SMRQ,ZBID,ZBCS,SMJG)
       SELECT SEQ_FXGL_DATA_ZXZB.NEXTVAL,T.TSSWJG_DM,T.DJXH,T.GFNSRSBH,T.GHFMC,NVL(P_SMLX,'0'),SYSDATE,'C02002',
              V_PARAMS,'[d]进货凭证号=' || T.JHPZH || '|供货方纳税人=' ||T.XFNSRSBH||
              '|原始发票计税金额=' || T.JE || '|红字冲减计税金额=' || T.HZCJJSJE || '|申报退税计税金额=' || T.SBFPJSJE ||
              '|红字冲减日期=' || TO_CHAR(T.HZCJRQ,'YYYYMMDD')
         FROM FXGL_DATA_YCFP T
        WHERE T.TSSWJG_DM LIKE V_SWJGDM
          AND (P_DJXH IS NULL OR T.DJXH=P_DJXH)
          AND T.JE + T.HZCJJSJE < T.SBFPJSJE - 0.1
          AND NOT EXISTS 
              (SELECT 1 -- 如果存在未处理的相同进货凭证号，就不再重复插入
                 FROM FXGL_DATA_ZXZB A
                WHERE A.ZBID='C02002'
                  AND A.DJXH=T.DJXH
                  AND REGEXP_LIKE(A.SMJG,T.JHPZH)
                  AND A.HSJGLX='0')
          AND NOT EXISTS 
              (SELECT 1 -- 如果存在已处理的相同进货凭证号，预警周期内就不再重复插入
                 FROM FXGL_DATA_ZXZB B
                WHERE B.ZBID='C02002'
                  AND B.DJXH=T.DJXH
                  AND REGEXP_LIKE(B.SMJG,T.JHPZH)
                  AND B.HSJGLX='1'
                  AND B.HSRQ>ADD_MONTHS(SYSDATE, (-1) * V_MONTHS_YJJG)
                  AND B.HSRY!='SYSTEM');
  COMMIT;

  RETURN;
END;
/
