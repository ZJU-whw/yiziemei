CREATE OR REPLACE PROCEDURE PRO_FXGL_COMPUTE_C01001
/*
 * 新办企业出口异常模型
 * 需要从金三同步CKTS_BA_BABGQK_JGB表中变更退税机关记录
 * 20250610，修改扫描时间间隔条件，原先为不存在6个月内的自动扫描结果，改为人工扫描全部执行，自动扫描不存在6个月以内的数据
 */
(
  P_SWJGDM  IN VARCHAR2, --可空，空默认全省，前台手工刷新需传入
  P_DJXH    IN VARCHAR2, --可空，空默认税务机关下所有有申报企业，前台当个企业刷新需传入
  P_SMLX    IN VARCHAR2 --可空，空默认自动扫描，前台人工扫描输入1
)
AS
  V_MONTHS_YJJG   NUMBER(18,2);    --预警参数：预警间隔周期
  V_MYLAJ_LX3M    NUMBER(18,2);    --预警参数：连续3个月内美元出口额
  V_MONTHS_ZDCK   NUMBER(18,2);    --预警参数：中断出口后复出口的企业中断期
  V_MONTHS_SCSB   NUMBER(18,2);    --预警参数：新办类企业首次申报以后有效期
  V_PARAMS        VARCHAR(4000);
  V_SWJGDM        VARCHAR(11);
  V_MYLAJ         NUMBER(18,2);    --统计结果：连续3个月内美元出口额
BEGIN
  -- 取本次风险扫描的参数
  SELECT NVL(S.VAL_DEF,T.VAL_DEF) / DECODE(T.CSTYPE,'百分比',100, 1)
    INTO V_MONTHS_YJJG
    FROM FXGL_PZ_ZB_CS T
    LEFT JOIN FXGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJGDM AND S.YXBZ='Y'
   WHERE T.CSBM='C01001_MONTHS_YJJG';
  SELECT NVL(S.VAL_DEF,T.VAL_DEF) / DECODE(T.CSTYPE,'百分比',100, 1)
    INTO V_MYLAJ_LX3M
    FROM FXGL_PZ_ZB_CS T
    LEFT JOIN FXGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJGDM AND S.YXBZ='Y'
   WHERE T.CSBM='C01001_MYLAJ_LX3M';
  SELECT NVL(S.VAL_DEF,T.VAL_DEF) / DECODE(T.CSTYPE,'百分比',100, 1)
    INTO V_MONTHS_ZDCK
    FROM FXGL_PZ_ZB_CS T
    LEFT JOIN FXGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJGDM AND S.YXBZ='Y'
   WHERE T.CSBM='C01001_MONTHS_ZDCK';
  SELECT NVL(S.VAL_DEF,T.VAL_DEF) / DECODE(T.CSTYPE,'百分比',100, 1)
    INTO V_MONTHS_SCSB
    FROM FXGL_PZ_ZB_CS T
    LEFT JOIN FXGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJGDM AND S.YXBZ='Y'
   WHERE T.CSBM='C01001_MONTHS_SCSB';
  V_PARAMS:='[d]预警间隔周期='||V_MONTHS_YJJG||
            '|连续3个月内美元出口额阈值=' || V_MYLAJ_LX3M||
            '|中断后复出口间隔周期=' || V_MONTHS_ZDCK||
            '|首次申报后检查有效期=' || V_MONTHS_SCSB;
  
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
     WHERE T.ZBID='C01001'
       AND T.TSSWJG_DM LIKE V_SWJGDM
       AND (P_DJXH IS NULL OR T.DJXH=P_DJXH)
       AND TRUNC(T.SMRQ,'MM')=TRUNC(SYSDATE,'MM')
       AND T.HSJGLX='0';
    COMMIT;
  END IF;
  
  --首次申报不足V_MONTHS_SCSB个月的出口企业
  FOR CUR_CKQY IN (SELECT T.DJXH,TRUNC(MIN(T.QDSJ)) AS SCSBRQ
                     FROM CKTS_LC_SBXX T
                    WHERE T.TSSWJG_DM LIKE V_SWJGDM --税务机关范围扫描
                      AND (P_DJXH IS NULL OR T.DJXH=P_DJXH) --是否单个企业扫描
                      AND NVL(T.ZFBZ, 'N') = 'N'
                      AND T.QDSJ >= ADD_MONTHS(SYSDATE, (-1) * V_MONTHS_SCSB) --检查24个月内的申报流程
                      AND NOT EXISTS (SELECT 1 --不存在更早的申报流程
                                        FROM CKTS_LC_SBXX A
                                       WHERE A.DJXH = T.DJXH
                                         AND NVL(A.ZFBZ, 'N') = 'N'
                                         AND A.QDSJ < T.QDSJ)
                      AND (  (NVL(P_SMLX,'0')='1')
                          OR (NVL(P_SMLX,'0')='0'
                         AND NOT EXISTS (SELECT 1 --预警间隔期不自动扫描同一企业信息
                                           FROM FXGL_DATA_ZXZB B
                                          WHERE B.DJXH=T.DJXH
                                            AND B.ZBID='C01001'
                                            AND B.HSRQ>ADD_MONTHS(SYSDATE, (-1) * V_MONTHS_YJJG)
                                            AND B.HSRY!='SYSTEM')))
                    GROUP BY T.DJXH)
  LOOP
    --统计连续三个月美元出口额，不包含当月数据
    SELECT NVL(SUM(MYLAJ),0)
      INTO V_MYLAJ
      FROM CKTS_WBSJ_HG_BGD
     WHERE DJXH=CUR_CKQY.DJXH
       AND CKRQ_1>=ADD_MONTHS(TRUNC(SYSDATE,'MM'),-3)
       AND CKRQ_1<TRUNC(SYSDATE,'MM')
       AND ZMTBZ='T';
    --如果连续3个月美元出口额大于参数值，添加风险数据
    IF V_MYLAJ>=V_MYLAJ_LX3M THEN
      INSERT INTO FXGL_DATA_ZXZB(ID,TSSWJG_DM,DJXH,NSRSBH,NSRMC,SMLX,SMRQ,ZBID,ZBCS,SMJG)
           SELECT SEQ_FXGL_DATA_ZXZB.NEXTVAL,TT.SWJGDM,TT.DJXH_JS,NVL(TT.SHXYNO,TT.NSRDJNO),TT.NSRMC,NVL(P_SMLX,'0'),SYSDATE,'C01001',
                  V_PARAMS,'[d]出口企业首次申报日期=' || TO_CHAR(CUR_CKQY.SCSBRQ,'YYYYMMDD')||'|最近三个月美元出口额=' ||V_MYLAJ
             FROM GLXT_BB_SHXT_DJXX TT
            WHERE TT.DJXH_JS=CUR_CKQY.DJXH;
      COMMIT;
    END IF;
  END LOOP;
  
  --中断后复出口不足V_MONTHS_SCSB个月的出口企业
  FOR CUR_CKQY IN (SELECT T.DJXH,TRUNC(MIN(T.QDSJ)) AS SCSBRQ
                     FROM CKTS_LC_SBXX T
                    WHERE T.TSSWJG_DM LIKE V_SWJGDM --税务机关范围扫描
                      AND (P_DJXH IS NULL OR T.DJXH=P_DJXH) --是否单个企业扫描
                      AND NVL(T.ZFBZ, 'N') = 'N'
                      AND T.QDSJ >= ADD_MONTHS(SYSDATE, (-1) * V_MONTHS_SCSB) --检查24个月内的申报流程
                      AND NOT EXISTS (SELECT 1 --不存在中断周期后更早的申报流程
                                        FROM CKTS_LC_SBXX A
                                       WHERE A.DJXH = T.DJXH
                                         AND NVL(A.ZFBZ, 'N') = 'N'
                                         AND A.QDSJ < T.QDSJ
                                         AND A.QDSJ >= ADD_MONTHS(T.QDSJ, (-1) * V_MONTHS_ZDCK))
                      AND EXISTS (SELECT 1 --存在中断周期前更早的申报流程
                                    FROM CKTS_LC_SBXX B
                                   WHERE B.DJXH = T.DJXH
                                     AND NVL(B.ZFBZ, 'N') = 'N'
                                     AND B.QDSJ < ADD_MONTHS(T.QDSJ, (-1) * V_MONTHS_ZDCK))
                      AND (  (NVL(P_SMLX,'0')='1')
                          OR (NVL(P_SMLX,'0')='0'
                         AND NOT EXISTS (SELECT 1 --预警间隔期不自动扫描同一企业信息
                                           FROM FXGL_DATA_ZXZB B
                                          WHERE B.DJXH=T.DJXH
                                            AND B.ZBID='C01001'
                                            AND B.HSRQ>ADD_MONTHS(SYSDATE, (-1) * V_MONTHS_YJJG)
                                            AND B.HSRY!='SYSTEM')))
                    GROUP BY T.DJXH)
  LOOP
    --统计连续三个月美元出口额，不包含当月数据
    SELECT NVL(SUM(MYLAJ),0)
      INTO V_MYLAJ
      FROM CKTS_WBSJ_HG_BGD
     WHERE DJXH=CUR_CKQY.DJXH
       AND CKRQ_1>=ADD_MONTHS(TRUNC(SYSDATE,'MM'),-3)
       AND CKRQ_1<TRUNC(SYSDATE,'MM')
       AND ZMTBZ='T';
    --如果连续3个月美元出口额大于参数值，添加风险数据
    IF V_MYLAJ>=V_MYLAJ_LX3M THEN
      INSERT INTO FXGL_DATA_ZXZB(ID,TSSWJG_DM,DJXH,NSRSBH,NSRMC,SMLX,SMRQ,ZBID,ZBCS,SMJG)
           SELECT SEQ_FXGL_DATA_ZXZB.NEXTVAL,TT.SWJGDM,TT.DJXH_JS,NVL(TT.SHXYNO,TT.NSRDJNO),TT.NSRMC,NVL(P_SMLX,'0'),SYSDATE,'C01001',
                  V_PARAMS,'[d]中断后复出口申报日期=' || TO_CHAR(CUR_CKQY.SCSBRQ,'YYYYMMDD')||'|最近三个月美元出口额=' ||V_MYLAJ
             FROM GLXT_BB_SHXT_DJXX TT
            WHERE TT.DJXH_JS=CUR_CKQY.DJXH;
      COMMIT;
    END IF;
  END LOOP;
  
  --迁移后不足V_MONTHS_SCSB个月的外贸企业
  FOR CUR_CKQY IN (SELECT T.DJXH,TRUNC(MIN(T.QDSJ)) AS SCSBRQ
                     FROM CKTS_LC_SBXX T
                    INNER JOIN (SELECT DJXH,MAX(LRRQ) AS QYRQ --最近24个月内最后一次迁移
                                  FROM CKTS_BA_BABGQK_JGB
                                 WHERE BABGZD_DM='TSSWJG_DM_1'
                                   AND LRRQ>=ADD_MONTHS(SYSDATE, (-1) * V_MONTHS_SCSB)
                                 GROUP BY DJXH) R ON R.DJXH=T.DJXH
                    WHERE T.TSSWJG_DM LIKE V_SWJGDM --税务机关范围扫描
                      AND (P_DJXH IS NULL OR T.DJXH=P_DJXH) --是否单个企业扫描
                      AND NVL(T.ZFBZ, 'N') = 'N'
                      AND T.QDSJ >= R.QYRQ --检查迁移以后的申报流程
                      AND T.SBYWB_DM='A0301001'
                      AND NOT EXISTS (SELECT 1 --不存在迁移以后更早的申报流程
                                        FROM CKTS_LC_SBXX A
                                       WHERE A.DJXH = T.DJXH
                                         AND NVL(A.ZFBZ, 'N') = 'N'
                                         AND A.QDSJ < T.QDSJ
                                         AND A.QDSJ >= R.QYRQ)
                      AND EXISTS (SELECT 1 --存在迁移以前更早的申报流程
                                    FROM CKTS_LC_SBXX B
                                   WHERE B.DJXH = T.DJXH
                                     AND NVL(B.ZFBZ, 'N') = 'N'
                                     AND B.QDSJ < R.QYRQ)
                      AND (  (NVL(P_SMLX,'0')='1')
                          OR (NVL(P_SMLX,'0')='0'
                         AND NOT EXISTS (SELECT 1 --预警间隔期不自动扫描同一企业信息
                                           FROM FXGL_DATA_ZXZB B
                                          WHERE B.DJXH=T.DJXH
                                            AND B.ZBID='C01001'
                                            AND B.HSRQ>ADD_MONTHS(SYSDATE, (-1) * V_MONTHS_YJJG)
                                            AND B.HSRY!='SYSTEM')))
                    GROUP BY T.DJXH)
  LOOP
    --统计连续三个月美元出口额，不包含当月数据
    SELECT NVL(SUM(MYLAJ),0)
      INTO V_MYLAJ
      FROM CKTS_WBSJ_HG_BGD
     WHERE DJXH=CUR_CKQY.DJXH
       AND CKRQ_1>=ADD_MONTHS(TRUNC(SYSDATE,'MM'),-3)
       AND CKRQ_1<TRUNC(SYSDATE,'MM')
       AND ZMTBZ='T';
    --如果连续3个月美元出口额大于参数值，添加风险数据
    IF V_MYLAJ>=V_MYLAJ_LX3M THEN
      INSERT INTO FXGL_DATA_ZXZB(ID,TSSWJG_DM,DJXH,NSRSBH,NSRMC,SMLX,SMRQ,ZBID,ZBCS,SMJG)
           SELECT SEQ_FXGL_DATA_ZXZB.NEXTVAL,TT.SWJGDM,TT.DJXH_JS,NVL(TT.SHXYNO,TT.NSRDJNO),TT.NSRMC,NVL(P_SMLX,'0'),SYSDATE,'C01001',
                  V_PARAMS,'[d]外贸迁移后首次申报日期=' || TO_CHAR(CUR_CKQY.SCSBRQ,'YYYYMMDD')||'|最近三个月美元出口额=' ||V_MYLAJ
             FROM GLXT_BB_SHXT_DJXX TT
            WHERE TT.DJXH_JS=CUR_CKQY.DJXH;
      COMMIT;
    END IF;
  END LOOP;
  
  RETURN;
END;
/
