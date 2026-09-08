DELIMITER $$

DROP PROCEDURE IF EXISTS PRO_FXGL_COMPUTE_C01001$$

CREATE PROCEDURE PRO_FXGL_COMPUTE_C01001
/*
 * 新办企业出口异常模型
 * 需要从金三同步CKTS_BA_BABGQK_JGB表中变更退税机关记录
 * 20250610，修改扫描时间间隔条件，原先为不存在6个月内的自动扫描结果，改为人工扫描全部执行，自动扫描不存在6个月以内的数据
 */
(
  IN P_SWJGDM VARCHAR(4000), -- 可空，空默认全省，前台手工刷新需传入
  IN P_DJXH VARCHAR(4000), -- 可空，空默认税务机关下所有有申报企业，前台当个企业刷新需传入
  IN P_SMLX VARCHAR(4000) -- 可空，空默认自动扫描，前台人工扫描输入1
)
routine_body: BEGIN
  DECLARE V_MONTHS_YJJG   DECIMAL(18,2);    -- 预警参数：预警间隔周期
  DECLARE V_MYLAJ_LX3M    DECIMAL(18,2);    -- 预警参数：连续3个月内美元出口额
  DECLARE V_MONTHS_ZDCK   DECIMAL(18,2);    -- 预警参数：中断出口后复出口的企业中断期
  DECLARE V_MONTHS_SCSB   DECIMAL(18,2);    -- 预警参数：新办类企业首次申报以后有效期
  DECLARE V_PARAMS        VARCHAR(4000);
  DECLARE V_SWJGDM        VARCHAR(11);
  DECLARE V_MYLAJ         DECIMAL(18,2);    -- 统计结果：连续3个月内美元出口额

  -- 取本次风险扫描的参数
  SELECT IFNULL(S.VAL_DEF, T.VAL_DEF) / (CASE T.CSTYPE WHEN '百分比' THEN 100 ELSE 1 END)
    INTO V_MONTHS_YJJG
    FROM FXGL_PZ_ZB_CS T
    LEFT JOIN FXGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJGDM AND S.YXBZ='Y'
   WHERE T.CSBM='C01001_MONTHS_YJJG';
  SELECT IFNULL(S.VAL_DEF, T.VAL_DEF) / (CASE T.CSTYPE WHEN '百分比' THEN 100 ELSE 1 END)
    INTO V_MYLAJ_LX3M
    FROM FXGL_PZ_ZB_CS T
    LEFT JOIN FXGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJGDM AND S.YXBZ='Y'
   WHERE T.CSBM='C01001_MYLAJ_LX3M';
  SELECT IFNULL(S.VAL_DEF, T.VAL_DEF) / (CASE T.CSTYPE WHEN '百分比' THEN 100 ELSE 1 END)
    INTO V_MONTHS_ZDCK
    FROM FXGL_PZ_ZB_CS T
    LEFT JOIN FXGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJGDM AND S.YXBZ='Y'
   WHERE T.CSBM='C01001_MONTHS_ZDCK';
  SELECT IFNULL(S.VAL_DEF, T.VAL_DEF) / (CASE T.CSTYPE WHEN '百分比' THEN 100 ELSE 1 END)
    INTO V_MONTHS_SCSB
    FROM FXGL_PZ_ZB_CS T
    LEFT JOIN FXGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJGDM AND S.YXBZ='Y'
   WHERE T.CSBM='C01001_MONTHS_SCSB';
  SET V_PARAMS =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('[d]预警间隔周期=', V_MONTHS_YJJG), '|连续3个月内美元出口额阈值='), V_MYLAJ_LX3M), '|中断后复出口间隔周期='), V_MONTHS_ZDCK), '|首次申报后检查有效期='), V_MONTHS_SCSB);

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
     WHERE T.ZBID='C01001'
       AND T.TSSWJG_DM LIKE V_SWJGDM
       AND (P_DJXH IS NULL OR T.DJXH=P_DJXH)
       AND CAST(DATE_FORMAT(T.SMRQ, '%Y-%m-01') AS DATETIME)=CAST(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y-%m-01') AS DATETIME)
       AND T.HSJGLX='0';
    COMMIT;
  END IF;

  -- 首次申报不足V_MONTHS_SCSB个月的出口企业
  BEGIN
  DECLARE BJTS_CURSOR_DONE_003 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_CUR_CKQY_DJXH_003 LONGTEXT;
  DECLARE BJTS_CUR_CKQY_SCSBRQ_003 LONGTEXT;
  DECLARE BJTS_CURSOR_003 CURSOR FOR
SELECT T.DJXH,DATE(MIN(T.QDSJ)) AS SCSBRQ
                     FROM CKTS_LC_SBXX T
                    WHERE T.TSSWJG_DM LIKE V_SWJGDM -- 税务机关范围扫描
                      AND (P_DJXH IS NULL OR T.DJXH=P_DJXH) -- 是否单个企业扫描
                      AND IFNULL(T.ZFBZ, 'N') = 'N'
                      AND T.QDSJ >= DATE_ADD(CURRENT_TIMESTAMP, INTERVAL (-1) * V_MONTHS_SCSB MONTH) -- 检查24个月内的申报流程
                      AND NOT EXISTS (SELECT 1 -- 不存在更早的申报流程
                                        FROM CKTS_LC_SBXX A
                                       WHERE A.DJXH = T.DJXH
                                         AND IFNULL(A.ZFBZ, 'N') = 'N'
                                         AND A.QDSJ < T.QDSJ)
                      AND (  (IFNULL(P_SMLX, '0')='1')
                          OR (IFNULL(P_SMLX, '0')='0'
                         AND NOT EXISTS (SELECT 1 -- 预警间隔期不自动扫描同一企业信息
                                           FROM FXGL_DATA_ZXZB B
                                          WHERE B.DJXH=T.DJXH
                                            AND B.ZBID='C01001'
                                            AND B.HSRQ>DATE_ADD(CURRENT_TIMESTAMP, INTERVAL (-1) * V_MONTHS_YJJG MONTH)
                                            AND B.HSRY!='SYSTEM')))
                    GROUP BY T.DJXH;
  OPEN BJTS_CURSOR_003;
  BJTS_CURSOR_LOOP_003: LOOP
    SET BJTS_CURSOR_DONE_003 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_003 = TRUE;
      FETCH BJTS_CURSOR_003 INTO BJTS_CUR_CKQY_DJXH_003, BJTS_CUR_CKQY_SCSBRQ_003;
    END;
    IF BJTS_CURSOR_DONE_003 THEN
      LEAVE BJTS_CURSOR_LOOP_003;
    END IF;
    -- 统计连续三个月美元出口额，不包含当月数据
    SELECT IFNULL(SUM(MYLAJ), 0)
      INTO V_MYLAJ
      FROM CKTS_WBSJ_HG_BGD
     WHERE DJXH=BJTS_CUR_CKQY_DJXH_003
       AND CKRQ_1>=DATE_ADD(CAST(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y-%m-01') AS DATETIME), INTERVAL -3 MONTH)
       AND CKRQ_1<CAST(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y-%m-01') AS DATETIME)
       AND ZMTBZ='T';
    -- 如果连续3个月美元出口额大于参数值，添加风险数据
    IF V_MYLAJ>=V_MYLAJ_LX3M THEN
      INSERT INTO FXGL_DATA_ZXZB(ID,TSSWJG_DM,DJXH,NSRSBH,NSRMC,SMLX,SMRQ,ZBID,ZBCS,SMJG)
           SELECT SEQ_NEXTVAL('SEQ_FXGL_DATA_ZXZB'),TT.SWJGDM,TT.DJXH_JS,IFNULL(TT.SHXYNO, TT.NSRDJNO),TT.NSRMC,IFNULL(P_SMLX, '0'),CURRENT_TIMESTAMP,'C01001',
                  V_PARAMS,ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('[d]出口企业首次申报日期=', DATE_FORMAT(BJTS_CUR_CKQY_SCSBRQ_003, '%Y%m%d')), '|最近三个月美元出口额='), V_MYLAJ)
             FROM GLXT_BB_SHXT_DJXX TT
            WHERE TT.DJXH_JS=BJTS_CUR_CKQY_DJXH_003;
      COMMIT;
    END IF;

  END LOOP BJTS_CURSOR_LOOP_003;
  CLOSE BJTS_CURSOR_003;
END;

  -- 中断后复出口不足V_MONTHS_SCSB个月的出口企业
  BEGIN
  DECLARE BJTS_CURSOR_DONE_002 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_CUR_CKQY_DJXH_002 LONGTEXT;
  DECLARE BJTS_CUR_CKQY_SCSBRQ_002 LONGTEXT;
  DECLARE BJTS_CURSOR_002 CURSOR FOR
SELECT T.DJXH,DATE(MIN(T.QDSJ)) AS SCSBRQ
                     FROM CKTS_LC_SBXX T
                    WHERE T.TSSWJG_DM LIKE V_SWJGDM -- 税务机关范围扫描
                      AND (P_DJXH IS NULL OR T.DJXH=P_DJXH) -- 是否单个企业扫描
                      AND IFNULL(T.ZFBZ, 'N') = 'N'
                      AND T.QDSJ >= DATE_ADD(CURRENT_TIMESTAMP, INTERVAL (-1) * V_MONTHS_SCSB MONTH) -- 检查24个月内的申报流程
                      AND NOT EXISTS (SELECT 1 -- 不存在中断周期后更早的申报流程
                                        FROM CKTS_LC_SBXX A
                                       WHERE A.DJXH = T.DJXH
                                         AND IFNULL(A.ZFBZ, 'N') = 'N'
                                         AND A.QDSJ < T.QDSJ
                                         AND A.QDSJ >= DATE_ADD(T.QDSJ, INTERVAL (-1) * V_MONTHS_ZDCK MONTH))
                      AND EXISTS (SELECT 1 -- 存在中断周期前更早的申报流程
                                    FROM CKTS_LC_SBXX B
                                   WHERE B.DJXH = T.DJXH
                                     AND IFNULL(B.ZFBZ, 'N') = 'N'
                                     AND B.QDSJ < DATE_ADD(T.QDSJ, INTERVAL (-1) * V_MONTHS_ZDCK MONTH))
                      AND (  (IFNULL(P_SMLX, '0')='1')
                          OR (IFNULL(P_SMLX, '0')='0'
                         AND NOT EXISTS (SELECT 1 -- 预警间隔期不自动扫描同一企业信息
                                           FROM FXGL_DATA_ZXZB B
                                          WHERE B.DJXH=T.DJXH
                                            AND B.ZBID='C01001'
                                            AND B.HSRQ>DATE_ADD(CURRENT_TIMESTAMP, INTERVAL (-1) * V_MONTHS_YJJG MONTH)
                                            AND B.HSRY!='SYSTEM')))
                    GROUP BY T.DJXH;
  OPEN BJTS_CURSOR_002;
  BJTS_CURSOR_LOOP_002: LOOP
    SET BJTS_CURSOR_DONE_002 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_002 = TRUE;
      FETCH BJTS_CURSOR_002 INTO BJTS_CUR_CKQY_DJXH_002, BJTS_CUR_CKQY_SCSBRQ_002;
    END;
    IF BJTS_CURSOR_DONE_002 THEN
      LEAVE BJTS_CURSOR_LOOP_002;
    END IF;
    -- 统计连续三个月美元出口额，不包含当月数据
    SELECT IFNULL(SUM(MYLAJ), 0)
      INTO V_MYLAJ
      FROM CKTS_WBSJ_HG_BGD
     WHERE DJXH=BJTS_CUR_CKQY_DJXH_002
       AND CKRQ_1>=DATE_ADD(CAST(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y-%m-01') AS DATETIME), INTERVAL -3 MONTH)
       AND CKRQ_1<CAST(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y-%m-01') AS DATETIME)
       AND ZMTBZ='T';
    -- 如果连续3个月美元出口额大于参数值，添加风险数据
    IF V_MYLAJ>=V_MYLAJ_LX3M THEN
      INSERT INTO FXGL_DATA_ZXZB(ID,TSSWJG_DM,DJXH,NSRSBH,NSRMC,SMLX,SMRQ,ZBID,ZBCS,SMJG)
           SELECT SEQ_NEXTVAL('SEQ_FXGL_DATA_ZXZB'),TT.SWJGDM,TT.DJXH_JS,IFNULL(TT.SHXYNO, TT.NSRDJNO),TT.NSRMC,IFNULL(P_SMLX, '0'),CURRENT_TIMESTAMP,'C01001',
                  V_PARAMS,ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('[d]中断后复出口申报日期=', DATE_FORMAT(BJTS_CUR_CKQY_SCSBRQ_002, '%Y%m%d')), '|最近三个月美元出口额='), V_MYLAJ)
             FROM GLXT_BB_SHXT_DJXX TT
            WHERE TT.DJXH_JS=BJTS_CUR_CKQY_DJXH_002;
      COMMIT;
    END IF;

  END LOOP BJTS_CURSOR_LOOP_002;
  CLOSE BJTS_CURSOR_002;
END;

  -- 迁移后不足V_MONTHS_SCSB个月的外贸企业
  BEGIN
  DECLARE BJTS_CURSOR_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_CUR_CKQY_DJXH_001 LONGTEXT;
  DECLARE BJTS_CUR_CKQY_SCSBRQ_001 LONGTEXT;
  DECLARE BJTS_CURSOR_001 CURSOR FOR
SELECT T.DJXH,DATE(MIN(T.QDSJ)) AS SCSBRQ
                     FROM CKTS_LC_SBXX T
                    INNER JOIN (SELECT DJXH,MAX(LRRQ) AS QYRQ -- 最近24个月内最后一次迁移
                                  FROM CKTS_BA_BABGQK_JGB
                                 WHERE BABGZD_DM='TSSWJG_DM_1'
                                   AND LRRQ>=DATE_ADD(CURRENT_TIMESTAMP, INTERVAL (-1) * V_MONTHS_SCSB MONTH)
                                 GROUP BY DJXH) R ON R.DJXH=T.DJXH
                    WHERE T.TSSWJG_DM LIKE V_SWJGDM -- 税务机关范围扫描
                      AND (P_DJXH IS NULL OR T.DJXH=P_DJXH) -- 是否单个企业扫描
                      AND IFNULL(T.ZFBZ, 'N') = 'N'
                      AND T.QDSJ >= R.QYRQ -- 检查迁移以后的申报流程
                      AND T.SBYWB_DM='A0301001'
                      AND NOT EXISTS (SELECT 1 -- 不存在迁移以后更早的申报流程
                                        FROM CKTS_LC_SBXX A
                                       WHERE A.DJXH = T.DJXH
                                         AND IFNULL(A.ZFBZ, 'N') = 'N'
                                         AND A.QDSJ < T.QDSJ
                                         AND A.QDSJ >= R.QYRQ)
                      AND EXISTS (SELECT 1 -- 存在迁移以前更早的申报流程
                                    FROM CKTS_LC_SBXX B
                                   WHERE B.DJXH = T.DJXH
                                     AND IFNULL(B.ZFBZ, 'N') = 'N'
                                     AND B.QDSJ < R.QYRQ)
                      AND (  (IFNULL(P_SMLX, '0')='1')
                          OR (IFNULL(P_SMLX, '0')='0'
                         AND NOT EXISTS (SELECT 1 -- 预警间隔期不自动扫描同一企业信息
                                           FROM FXGL_DATA_ZXZB B
                                          WHERE B.DJXH=T.DJXH
                                            AND B.ZBID='C01001'
                                            AND B.HSRQ>DATE_ADD(CURRENT_TIMESTAMP, INTERVAL (-1) * V_MONTHS_YJJG MONTH)
                                            AND B.HSRY!='SYSTEM')))
                    GROUP BY T.DJXH;
  OPEN BJTS_CURSOR_001;
  BJTS_CURSOR_LOOP_001: LOOP
    SET BJTS_CURSOR_DONE_001 = FALSE;
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_CURSOR_DONE_001 = TRUE;
      FETCH BJTS_CURSOR_001 INTO BJTS_CUR_CKQY_DJXH_001, BJTS_CUR_CKQY_SCSBRQ_001;
    END;
    IF BJTS_CURSOR_DONE_001 THEN
      LEAVE BJTS_CURSOR_LOOP_001;
    END IF;
    -- 统计连续三个月美元出口额，不包含当月数据
    SELECT IFNULL(SUM(MYLAJ), 0)
      INTO V_MYLAJ
      FROM CKTS_WBSJ_HG_BGD
     WHERE DJXH=BJTS_CUR_CKQY_DJXH_001
       AND CKRQ_1>=DATE_ADD(CAST(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y-%m-01') AS DATETIME), INTERVAL -3 MONTH)
       AND CKRQ_1<CAST(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y-%m-01') AS DATETIME)
       AND ZMTBZ='T';
    -- 如果连续3个月美元出口额大于参数值，添加风险数据
    IF V_MYLAJ>=V_MYLAJ_LX3M THEN
      INSERT INTO FXGL_DATA_ZXZB(ID,TSSWJG_DM,DJXH,NSRSBH,NSRMC,SMLX,SMRQ,ZBID,ZBCS,SMJG)
           SELECT SEQ_NEXTVAL('SEQ_FXGL_DATA_ZXZB'),TT.SWJGDM,TT.DJXH_JS,IFNULL(TT.SHXYNO, TT.NSRDJNO),TT.NSRMC,IFNULL(P_SMLX, '0'),CURRENT_TIMESTAMP,'C01001',
                  V_PARAMS,ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('[d]外贸迁移后首次申报日期=', DATE_FORMAT(BJTS_CUR_CKQY_SCSBRQ_001, '%Y%m%d')), '|最近三个月美元出口额='), V_MYLAJ)
             FROM GLXT_BB_SHXT_DJXX TT
            WHERE TT.DJXH_JS=BJTS_CUR_CKQY_DJXH_001;
      COMMIT;
    END IF;

  END LOOP BJTS_CURSOR_LOOP_001;
  CLOSE BJTS_CURSOR_001;
END;

  LEAVE routine_body;
END$$

DELIMITER ;
