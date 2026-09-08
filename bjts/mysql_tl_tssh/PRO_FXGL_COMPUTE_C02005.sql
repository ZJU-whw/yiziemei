DELIMITER $$

DROP PROCEDURE IF EXISTS PRO_FXGL_COMPUTE_C02005$$

CREATE PROCEDURE PRO_FXGL_COMPUTE_C02005
/*
 * 小规模期间供货开13%票
 * 20250912，从金三取数增加首次认定一般纳税人有效期起，模型增加小规模期间出口征税率大于3数据
 * 20260327，自动扫描条件改为不存在6个月以内已人工核实的数据，因税务人员调整参数自动核实的数据不算
 */
(
  IN P_SWJGDM VARCHAR(4000), -- 可空，空默认全省，前台手工刷新需传入
  IN P_DJXH VARCHAR(4000), -- 可空，空默认税务机关下所有有申报企业，前台当个企业刷新需传入
  IN P_SMLX VARCHAR(4000) -- 可空，空默认自动扫描，前台人工扫描输入1
)
routine_body: BEGIN
  DECLARE V_MONTHS_YJJG   DECIMAL(18,2);    -- 预警参数：预警间隔周期
  DECLARE V_PARAMS        VARCHAR(4000);
  DECLARE V_SWJGDM        VARCHAR(11);

  -- 取本次风险扫描的参数
  SELECT IFNULL(S.VAL_DEF, T.VAL_DEF) / (CASE T.CSTYPE WHEN '百分比' THEN 100 ELSE 1 END)
    INTO V_MONTHS_YJJG
    FROM FXGL_PZ_ZB_CS T
    LEFT JOIN FXGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJGDM AND S.YXBZ='Y'
   WHERE T.CSBM='C02005_MONTHS_YJJG';
  SET V_PARAMS =ORA_CONCAT('[d]预警间隔周期=', V_MONTHS_YJJG);

  -- 取本次风险扫描的税务机关范围
  IF IFNULL(P_SWJGDM, '13300000000')='13300000000' THEN
    SET V_SWJGDM ='133%';
  ELSEIF SUBSTR(P_SWJGDM,6)='000000' THEN
    SET V_SWJGDM =ORA_CONCAT(SUBSTR(P_SWJGDM,1,5), '%');
  ELSE
    SET V_SWJGDM =ORA_CONCAT(SUBSTR(P_SWJGDM,1,7), '%');
  END IF;

  IF P_SMLX=1 THEN
    UPDATE FXGL_DATA_ZXZB AS T
       SET HSJGLX='1',
    HSRQ=CURRENT_TIMESTAMP,
    HSRY='SYSTEM',
    HSCLQK='税务人员调整预警参数，重新刷新本次风险指标。'
     WHERE T.ZBID='C02005'
       AND T.TSSWJG_DM LIKE V_SWJGDM
       AND (P_DJXH IS NULL OR T.DJXH=P_DJXH)
       AND CAST(DATE_FORMAT(T.SMRQ, '%Y-%m-01') AS DATETIME)=CAST(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y-%m-01') AS DATETIME)
       AND T.HSJGLX='0';
    COMMIT;
  END IF;

  -- 上月以来有申报的外贸企业
  BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_CUR_CKQY_DJXH_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT DISTINCT T.DJXH
                     FROM CKTS_LC_SBXX T
                    WHERE T.TSSWJG_DM LIKE V_SWJGDM -- 税务机关范围扫描
                      AND (P_DJXH IS NULL OR T.DJXH=P_DJXH) -- 是否单个企业扫描
                      AND IFNULL(T.ZFBZ, 'N') = 'N'
                      AND T.QDSJ >= DATE_ADD(CAST(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y-%m-01') AS DATETIME), INTERVAL -1 MONTH)
                      AND T.SBYWB_DM='A0301001'
                      AND (  (IFNULL(P_SMLX, '0')='1')
                          OR (IFNULL(P_SMLX, '0')='0'
                         AND NOT EXISTS (SELECT 1 -- 预警间隔期不自动扫描同一企业信息
                                           FROM FXGL_DATA_ZXZB B
                                          WHERE B.DJXH=T.DJXH
                                            AND B.ZBID='C02005'
                                            AND B.HSRQ>DATE_ADD(CURRENT_TIMESTAMP, INTERVAL (-1) * V_MONTHS_YJJG MONTH)
                                            AND B.HSRY!='SYSTEM')));
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_CUR_CKQY_DJXH_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
    BEGIN
      INSERT INTO FXGL_DATA_ZXZB(ID,TSSWJG_DM,DJXH,NSRSBH,NSRMC,SMLX,SMRQ,ZBID,ZBCS,SMJG)
           SELECT SEQ_NEXTVAL('SEQ_FXGL_DATA_ZXZB'),DJ.SWJGDM,DJ.DJXH_JS,IFNULL(DJ.SHXYNO, DJ.NSRDJNO),DJ.NSRMC,IFNULL(P_SMLX, '0'),CURRENT_TIMESTAMP,'C02005',
                  V_PARAMS,ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('[d]所属期批次=', YC.SSQPC), '|供货方纳税人='), YC.GHFNSRSBH_1), '|登记日期='), DATE_FORMAT(YC.DJRQ, '%Y%m%d')), '|出口日期范围='), DATE_FORMAT(YC.MIN_CKRQ, '%Y%m%d')), '-'), DATE_FORMAT(YC.MAX_CKRQ, '%Y%m%d')), '|一般纳税人有效期起='), DATE_FORMAT(YC.YBNSRRDRQ, '%Y%m%d')), '发票征税税率='), ZSSL)
             FROM (SELECT DJXH,SSQPC,GHFNSRSBH_1,DJRQ,YBNSRRDRQ,ZSSL,MIN(CKRQ_1) AS MIN_CKRQ,MAX(CKRQ_1) AS MAX_CKRQ,SUM(TSE) AS TSE
                     FROM (SELECT DJXH,ORA_CONCAT(SSQ, SBPC) AS SSQPC,GHFNSRSBH_1,CKRQ_1,ZSSL,TSE,
                                  (SELECT MIN(GH.DJRQ)
                                     FROM CKTS_DJ_NSRXX GH
                                    WHERE GH.NSRSBH=SB.GHFNSRSBH_1
                                      AND GH.NSRZT_DM NOT IN ('09','10')
                                      AND IFNULL(GH.ZXRQ, CURRENT_TIMESTAMP)>SB.KPRQ) AS DJRQ,
                                  (SELECT MIN(GH.YBNSRRDRQ)
                                     FROM CKTS_DJ_NSRXX GH
                                    WHERE GH.NSRSBH=SB.GHFNSRSBH_1
                                      AND GH.NSRZT_DM NOT IN ('09','10')
                                      AND IFNULL(GH.ZXRQ, CURRENT_TIMESTAMP)>SB.KPRQ) AS YBNSRRDRQ
                             FROM CKTS_SB_MTS_JHMX SB
                             LEFT JOIN (SELECT MAX(SMRQ) AS SMRQ
                                          FROM FXGL_DATA_ZXZB
                                         WHERE DJXH=BJTS_CUR_CKQY_DJXH_001
                                           AND ZBID='C02005'
                                           AND IFNULL(HSRY, '1')!='SYSTEM') HS
                               ON 1=1
                            WHERE SB.DJXH=BJTS_CUR_CKQY_DJXH_001
                              AND SB.SBRQ > IFNULL(HS.SMRQ, DATE_ADD(CURRENT_TIMESTAMP, INTERVAL -12 MONTH))
                              AND CKRQ_1>CAST('1900-01-01' AS DATE) -- CKRQ_1是etl后置存储过程处理的，需要剔除还没赋值的情况
                              AND TSE>0) TT  -- 检查正数申报，红字冲减的去掉
                    WHERE CKRQ_1>=DATE(DJRQ)
                      AND CKRQ_1<DATE(YBNSRRDRQ)
                      AND ZSSL>3
                    GROUP BY DJXH,SSQPC,GHFNSRSBH_1,DJRQ,YBNSRRDRQ,ZSSL) YC
            INNER JOIN GLXT_BB_SHXT_DJXX DJ ON DJ.DJXH_JS=YC.DJXH;
      COMMIT;
    END;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;

  LEAVE routine_body;
END$$

DELIMITER ;
