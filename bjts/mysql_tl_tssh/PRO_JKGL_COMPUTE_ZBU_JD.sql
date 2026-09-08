DELIMITER $$

DROP PROCEDURE IF EXISTS PRO_JKGL_COMPUTE_ZBU_JD$$

CREATE PROCEDURE PRO_JKGL_COMPUTE_ZBU_JD
/*
 * 季度指标元刷新算法
 * 202309，增加判断是否新开业的出口企业
 * 202309，增加代理出口统计
 * 20250919，调整拼箱与整柜报关单的计算口径
 */
routine_body: BEGIN
  DECLARE V_CK_BGDSL        BIGINT; --  出口_报关单数量
  DECLARE V_CK_CKEUSD       DECIMAL(18,2); --  出口_出口额USD
  DECLARE V_CK_CKERMB       DECIMAL(18,2); --  出口_出口额
  DECLARE V_CK_SBDW_SL      BIGINT; --  出口_申报单位数量
  DECLARE V_CK_GB_SL        BIGINT; --  出口_目的国数量
  DECLARE V_CK_BGDSL_DE     BIGINT; --  出口_大额报关单数量
  DECLARE V_CK_CKEUSD_DE    DECIMAL(18,2); --  出口_大额报关单出口额USD
  DECLARE V_CK_BGDSL_ST     BIGINT; --  出口_四同报关单数量
  DECLARE V_CK_PXBGDSL      BIGINT; --  出口_拼箱报关单数量
  DECLARE V_CK_ZXBGDSL      DECIMAL(18,2); --  出口_整箱报关单数量
  DECLARE V_CK_PJDBHGZ      DECIMAL(18,2); --  出口_平均单笔货柜值
  DECLARE V_CK_CKEUSD_LASTYEAR	DECIMAL(18,2); --	出口_最近12个月出口额USD
  DECLARE V_TS_BGDSL        BIGINT; --  退税_报关单数量
  DECLARE V_TS_CKEUSD       DECIMAL(18,2); --  退税_出口额USD
  DECLARE V_TS_CKERMB       DECIMAL(18,2); --  退税_出口额RMB
  DECLARE V_TS_MTSCKE       DECIMAL(18,2); --  退税_出口额RMB（免退税）
  DECLARE V_TS_JSJE         DECIMAL(18,2); --  退税_计税金额（免退税）
  DECLARE V_TS_HHCB         DECIMAL(18,2); --  退税_换汇成本（免退税）
  DECLARE V_TS_BGDSL_CQ     BIGINT; --  退税_报关单数量_超期申报
  DECLARE V_TS_CKEUSD_CQ    DECIMAL(18,2); --  退税_出口额USD_超期申报
  DECLARE V_TS_TSE_SB       DECIMAL(18,2); --  退税_退税额_申报
  DECLARE V_TS_MDE_SB       DECIMAL(18,2); --  退税_免抵额_申报
  DECLARE V_TS_TSE_HZ       DECIMAL(18,2); --  退税_退税_核准
  DECLARE V_TS_MDE_HZ       DECIMAL(18,2); --  退税_免抵_核准
  DECLARE V_TS_TSE_BL       DECIMAL(18,2); --  退税_退税_办理
  DECLARE V_TS_MDE_BL       DECIMAL(18,2); --  退税_免抵_办理
  DECLARE V_TS_CKERMB_STZC  DECIMAL(18,2); --  退税_视同自产出口额
  DECLARE V_TS_JHFP_JE      DECIMAL(18,2); --  退税_发票总金额
  DECLARE V_TS_JHFP_FS      BIGINT; --  退税_发票总份数
  DECLARE V_TS_JHFP_JE_CQ1  DECIMAL(18,2); --  退税_超期1发票金额
  DECLARE V_TS_JHFP_FS_CQ1  BIGINT; --  退税_超期1发票份数
  DECLARE V_TS_JHFP_JE_CQ2  DECIMAL(18,2); --  退税_超期2发票金额
  DECLARE V_TS_JHFP_FS_CQ2  BIGINT; --  退税_超期2发票份数
  DECLARE V_TS_GHS_NUM      BIGINT; --  退税_供货商个数
  DECLARE V_BGQ_Q           DATETIME;
  
  DECLARE V_ROWS            BIGINT;  -- 待更新表中是否存在目标记录


  FOR CUR_BGQ IN (SELECT T.BGQID, T.DJXH, S.NSRDJNO, S.SHXYNO, T.ZQLX, 
                         T.BGQ_Q, T.BGQ_Z, DATE_FORMAT(T.BGQ_Q, '%Y%m') AS YF_Q, DATE_FORMAT(T.BGQ_Z, '%Y%m') AS YF_Z,
                         S.SQ_DATE
                    FROM JKGL_DATA_BGQ T
                   INNER JOIN GLXT_BB_SHXT_DJXX S ON S.DJXH_JS=T.DJXH
                   WHERE T.ZQLX='季' AND T.SXZT='0' AND T.TQBZ IS NULL
                 )
  LOOP
    --锁定正在处理的报告期
    UPDATE JKGL_DATA_BGQ T
       SET T.TQBZ=SYS_GUID(), T.TQSJ=CURRENT_TIMESTAMP, T.SXZT='1'
     WHERE T.BGQID=CUR_BGQ.BGQID;
    COMMIT;
    
    --检查报告期ZBU记录是否存在
    SELECT COUNT(1)
      INTO V_ROWS
      FROM JKGL_DATA_TJ_ZBU T
     WHERE T.BGQID=CUR_BGQ.BGQID AND ROWNUM=1;
    IF V_ROWS=0 THEN
      INSERT INTO JKGL_DATA_TJ_ZBU(BGQID) VALUES (CUR_BGQ.BGQID);
      COMMIT;
    END IF;
    
    --判断是否新开业的出口企业
    IF CUR_BGQ.SQ_DATE>=CUR_BGQ.BGQ_Q AND CUR_BGQ.SQ_DATE<CUR_BGQ.BGQ_Z+1 THEN
      --当年新办的出口企业，首次报告期统计范围从当年年初开始，防止先出口后备案，并与年度报告期分类统计一致
      SET V_BGQ_Q = TRUNCATE(CUR_BGQ.BGQ_Q, 'YY'); 
    ELSE
      SET V_BGQ_Q = CUR_BGQ.BGQ_Q;
    END IF;
      
    --  V_CK_
    BEGIN
      --  V_CK_BGDSL  NUMBER(10)  出口_报关单数量
      --  V_CK_CKEUSD NUMBER(18,2)  出口_出口额USD
      --  V_CK_CKERMB NUMBER(18,2)  出口_出口额
      --  V_CK_SBDW_SL  NUMBER(10)  出口_申报单位数量
      --  V_CK_GB_SL  NUMBER(10)  出口_目的国数量
      SELECT COUNT(DISTINCT SUBSTR(CKBGDH,1,18)), IFNULL(SUM(MYLAJ), 0), IFNULL(SUM(RMBLAJ), 0), 
             COUNT(DISTINCT SBDWDM), COUNT(DISTINCT MYGDQSZ_DM)
        INTO V_CK_BGDSL, V_CK_CKEUSD, V_CK_CKERMB, V_CK_SBDW_SL, V_CK_GB_SL
        FROM (SELECT T.CKBGDH,T.MYLAJ,T.RMBLAJ,T.SBDWDM,T.MYGDQSZ_DM
                FROM CKTS_WBSJ_HG_BGD T
               WHERE T.DJXH=CUR_BGQ.DJXH
                 AND T.CKRQ_1>=V_BGQ_Q AND T.CKRQ_1<CUR_BGQ.BGQ_Z+1
                 AND T.JGFS_DM<>'1039'
               UNION ALL
              SELECT S.CKBGDH,S.MYLAJ,S.RMBLAJ,S.SBDWDM,S.MYGDQSZ_DM
                FROM CKTS_WBSJ_ZJ_DLCKHWZM S
               WHERE S.DJXH=CUR_BGQ.DJXH
                 AND S.CKRQ_1>=V_BGQ_Q AND S.CKRQ_1<CUR_BGQ.BGQ_Z+1
                 AND S.JGFS_DM<>'1039'
             ) TT;

      --  V_CK_BGDSL_DE NUMBER(10)  出口_大额报关单数量
      --  V_CK_CKEUSD_DE  NUMBER(18,2)  出口_大额报关单出口额USD
      --  每单超10W美金算大额报关单
      SELECT COUNT(1), IFNULL(SUM(MYLAJ18), 0)
        INTO V_CK_BGDSL_DE, V_CK_CKEUSD_DE
        FROM (SELECT SUBSTR(TT.CKBGDH,1,18) AS BGD18, SUM(TT.MYLAJ) AS MYLAJ18
                FROM (SELECT T.CKBGDH,T.MYLAJ,T.RMBLAJ,T.SBDWDM,T.MYGDQSZ_DM
                        FROM CKTS_WBSJ_HG_BGD T
                       WHERE T.DJXH=CUR_BGQ.DJXH
                         AND T.CKRQ_1>=V_BGQ_Q AND T.CKRQ_1<CUR_BGQ.BGQ_Z+1
                         AND T.JGFS_DM<>'1039'
                       UNION ALL
                      SELECT S.CKBGDH,S.MYLAJ,S.RMBLAJ,S.SBDWDM,S.MYGDQSZ_DM
                        FROM CKTS_WBSJ_ZJ_DLCKHWZM S
                       WHERE S.DJXH=CUR_BGQ.DJXH
                         AND S.CKRQ_1>=V_BGQ_Q AND S.CKRQ_1<CUR_BGQ.BGQ_Z+1
                         AND S.JGFS_DM<>'1039'
                     ) TT
               GROUP BY SUBSTR(TT.CKBGDH,1,18)
              HAVING SUM(TT.MYLAJ)>100000
             ) T2;

      --  V_CK_BGDSL_ST NUMBER(10)  出口_四同报关单数量
      SELECT COUNT(1)
        INTO V_CK_BGDSL_ST
        FROM (SELECT T.HGCKHWBGDSBRQ,T.HGGQKA_DM,T.CKSP_DM,T.MYGDQSZ_DM, COUNT(DISTINCT SUBSTR(T.CKBGDH,1,18)) AS STNUM
                FROM CKTS_WBSJ_HG_BGD T
               WHERE T.DJXH=CUR_BGQ.DJXH
                 AND T.HGCKHWBGDSBRQ>=V_BGQ_Q AND T.HGCKHWBGDSBRQ<CUR_BGQ.BGQ_Z+1
                 AND T.JGFS_DM<>'1039'
               GROUP BY T.HGCKHWBGDSBRQ,T.HGGQKA_DM,T.CKSP_DM,T.MYGDQSZ_DM)
       WHERE STNUM>=3;

      --  V_CK_PXBGDSL  NUMBER(10)  出口_拼箱报关单数量
      SELECT COUNT(DISTINCT T.BGDHGBH)
        INTO V_CK_PXBGDSL
        FROM CKTS_WBSJ_HG_BGD204 T
       WHERE T.DJXH=CUR_BGQ.DJXH
         AND T.CKRQ_1>=V_BGQ_Q AND T.CKRQ_1<CUR_BGQ.BGQ_Z+1
         AND T.JZXH<>'无'
         AND (T.BJMMJBZ LIKE '%拼箱%' OR
             EXISTS (SELECT 1
                       FROM CKTS_WBSJ_HG_BGD204 S
                      WHERE S.JZXH=T.JZXH AND S.CKRQ_1=T.CKRQ_1 AND S.DJXH<>T.DJXH));

      --  V_CK_ZXBGDSL  NUMBER(18,2)  出口_整箱报关单数量
      --  V_CK_PJDBHGZ  NUMBER(18,2)  出口_平均单笔货柜值
      WITH JZXHXX AS (SELECT T2.BGDHGBH, COUNT(DISTINCT T2.JZXH) AS JZXSL
                        FROM CKTS_WBSJ_HG_BGD204 T2
                       WHERE T2.DJXH=CUR_BGQ.DJXH
                         AND T2.CKRQ_1>=V_BGQ_Q AND T2.CKRQ_1<CUR_BGQ.BGQ_Z+1
                         AND T2.JZXH<>'无'
                         AND T2.BJMMJBZ NOT LIKE '%拼箱%'
                         AND NOT EXISTS (SELECT 1
                                           FROM CKTS_WBSJ_HG_BGD204 T3
                                          WHERE T3.JZXH=T2.JZXH AND T3.CKRQ_1=T2.CKRQ_1 AND T3.DJXH<>T2.DJXH)
                       GROUP BY T2.BGDHGBH),
           CKBGXX AS (SELECT SUBSTR(T.CKBGDH,1,18) AS BGDHGBH, SUM(T.MYLAJ) AS TOTALMY
                        FROM CKTS_WBSJ_HG_BGD T
                       WHERE T.DJXH=CUR_BGQ.DJXH
                         AND T.CKRQ_1>=V_BGQ_Q AND T.CKRQ_1<CUR_BGQ.BGQ_Z+1
                         AND T.JGFS_DM<>'1039'
                       GROUP BY SUBSTR(T.CKBGDH,1,18))
      SELECT COUNT(DISTINCT JZXHXX.BGDHGBH), 
             IFNULL((CASE WHEN SUM(JZXHXX.JZXSL)=0 THEN 0 ELSE SUM(CKBGXX.TOTALMY)/SUM(JZXHXX.JZXSL) END), 0)
        INTO V_CK_ZXBGDSL, V_CK_PJDBHGZ
        FROM JZXHXX
       INNER JOIN CKBGXX ON JZXHXX.BGDHGBH=CKBGXX.BGDHGBH;

      --  V_CK_CKEUSD_LASTYEAR	NUMBER(18,2); --	出口_最近12个月出口额USD
      SELECT IFNULL(SUM(MYLAJ), 0)
        INTO V_CK_CKEUSD_LASTYEAR
        FROM (SELECT T.CKBGDH,T.MYLAJ,T.RMBLAJ,T.SBDWDM,T.MYGDQSZ_DM
                FROM CKTS_WBSJ_HG_BGD T
               WHERE T.DJXH=CUR_BGQ.DJXH
                 AND T.CKRQ_1>=DATE_ADD(CAST(DATE_FORMAT(CUR_BGQ.BGQ_Z, '%Y-%m-01') AS DATETIME), INTERVAL -11 MONTH) AND T.CKRQ_1<CUR_BGQ.BGQ_Z+1
                 AND T.JGFS_DM<>'1039'
               UNION ALL
              SELECT S.CKBGDH,S.MYLAJ,S.RMBLAJ,S.SBDWDM,S.MYGDQSZ_DM
                FROM CKTS_WBSJ_ZJ_DLCKHWZM S
               WHERE S.DJXH=CUR_BGQ.DJXH
                 AND S.CKRQ_1>=DATE_ADD(CAST(DATE_FORMAT(CUR_BGQ.BGQ_Z, '%Y-%m-01') AS DATETIME), INTERVAL -11 MONTH) AND S.CKRQ_1<CUR_BGQ.BGQ_Z+1
                 AND S.JGFS_DM<>'1039'
             ) TT;

      UPDATE JKGL_DATA_TJ_ZBU
         SET CK_BGDSL=V_CK_BGDSL,
             CK_CKEUSD=V_CK_CKEUSD,
             CK_CKERMB=V_CK_CKERMB,
             CK_SBDW_SL=V_CK_SBDW_SL,
             CK_GB_SL=V_CK_GB_SL,
             CK_BGDSL_DE=V_CK_BGDSL_DE,
             CK_CKEUSD_DE=V_CK_CKEUSD_DE,
             CK_BGDSL_ST=V_CK_BGDSL_ST,
             CK_PXBGDSL=V_CK_PXBGDSL,
             CK_ZXBGDSL=V_CK_ZXBGDSL,
             CK_PJDBHGZ=V_CK_PJDBHGZ,
             CK_CKEUSD_LASTYEAR=V_CK_CKEUSD_LASTYEAR
       WHERE BGQID=CUR_BGQ.BGQID;
      COMMIT;
    END;
    
    --  V_TS_
    BEGIN
      --  V_TS_BGDSL NUMBER(10) 退税_报关单数量
      --  V_TS_CKEUSD NUMBER(18,2)  退税_出口额USD
      --  V_TS_CKERMB NUMBER(18,2)  退税_出口额RMB
      --  V_TS_MTSCKE NUMBER(18,2)  退税_出口额RMB（免退税）
      --  V_TS_JSJE NUMBER(18,2)  退税_计税金额（免退税）
      --  V_TS_BGDSL_CQ NUMBER(10) 退税_报关单数量_超期申报
      --  V_TS_CKEUSD_CQ NUMBER(18,2)  退税_出口额USD_超期申报
      SELECT COUNT(DISTINCT SUBSTR(T.CKBGDH,1,18)), IFNULL(SUM(T.MYLAJ), 0), IFNULL(SUM(T.RMBLAJ), 0), 
             IFNULL(SUM(CASE WHEN T.SBYWLX='1' THEN 0 ELSE T.RMBLAJ END), 0), 
             IFNULL(SUM(CASE WHEN T.SBYWLX='1' THEN 0 ELSE T.JSJE END), 0),
             COUNT(DISTINCT CASE WHEN T.SBRQ>STR_TO_DATE(DATE_FORMAT(DATE_ADD(T.CKRQ, INTERVAL 12 MONTH), '%Y')||'0420', '%Y%m%d') AND T.MYLAJ>0 THEN SUBSTR(T.CKBGDH,1,18) ELSE NULL END),
             IFNULL(SUM(CASE WHEN T.SBRQ>STR_TO_DATE(DATE_FORMAT(DATE_ADD(T.CKRQ, INTERVAL 12 MONTH), '%Y')||'0420', '%Y%m%d') AND T.MYLAJ>0 THEN T.MYLAJ ELSE NULL END), 0)
        INTO V_TS_BGDSL, V_TS_CKEUSD, V_TS_CKERMB, V_TS_MTSCKE, V_TS_JSJE, V_TS_BGDSL_CQ, V_TS_CKEUSD_CQ
        FROM JCFX_DATA_TSSBMX T
       WHERE T.DJXH=CUR_BGQ.DJXH
         AND T.SBRQ>=V_BGQ_Q AND T.SBRQ<CUR_BGQ.BGQ_Z+1;

      --  V_TS_HHCB NUMBER(18,2)  退税_换汇成本（免退税）
      SET V_TS_HHCB = CASE WHEN V_TS_MTSCKE>0 AND V_TS_JSJE>0 THEN ROUND(100*V_TS_JSJE/V_TS_MTSCKE,2) ELSE NULL END;

      --  V_TS_TSE_SB NUMBER(18,2)  退税_退税额_申报
      --  V_TS_MDE_SB NUMBER(18,2)  退税_免抵额_申报
      --  CKTS_LC_SBXX.SBRQ为便捷退税申报日期，部分数据没有，改用流程启动时间
      SELECT IFNULL(SUM(T.SB_ZZSTSE+T.SB_XFSTSE), 0), IFNULL(SUM(T.SB_MDSE), 0)
        INTO V_TS_TSE_SB, V_TS_MDE_SB
        FROM CKTS_LC_SBXX T
       WHERE T.DJXH=CUR_BGQ.DJXH
         AND T.QDSJ>=V_BGQ_Q AND T.QDSJ<CUR_BGQ.BGQ_Z+1 
         AND IFNULL(T.ZFBZ, 'N')='N';

      --  V_TS_TSE_HZ NUMBER(18,2)  退税_退税_核准
      --  V_TS_MDE_HZ NUMBER(18,2)  退税_免抵_核准
      SELECT IFNULL(SUM(S.SEHZ_ZZSTSE+S.SEHZ_XFSTSE), 0), IFNULL(SUM(S.SEHZ_MDSE), 0)
        INTO V_TS_TSE_HZ, V_TS_MDE_HZ
        FROM CKTS_LC_SEHZXX S
       WHERE S.DJXH=CUR_BGQ.DJXH
         AND S.SEHZRQ>=V_BGQ_Q AND S.SEHZRQ<CUR_BGQ.BGQ_Z+1;

      --  V_TS_TSE_BL NUMBER(18,2)  退税_退税_办理
      SELECT IFNULL(SUM(S.SE), 0)
        INTO V_TS_TSE_BL
        FROM CKTS_ZS_SRTHS S
       WHERE S.DJXH=CUR_BGQ.DJXH
         AND S.THRQ_1>=V_BGQ_Q AND S.THRQ_1<CUR_BGQ.BGQ_Z+1
         AND S.TTSJLX_DM='01' AND S.TZLX_DM IN ('1','4');

      --  V_TS_MDE_BL NUMBER(18,2)  退税_免抵_办理
      SELECT IFNULL(SUM(S.JE), 0)
        INTO V_TS_MDE_BL
        FROM CKTS_ZS_TKGZ S
       WHERE S.DJXH=CUR_BGQ.DJXH
         AND S.GKGZRQ>=V_BGQ_Q AND S.GKGZRQ<CUR_BGQ.BGQ_Z+1
         AND S.TZSLY='3' AND S.TZLX_DM='1' AND S.GZBZ='Y';

      --  V_TS_CKERMB_STZC  NUMBER(18,2)  退税_视同自产出口额
      SELECT IFNULL(SUM(MYLAJ), 0)
        INTO V_TS_CKERMB_STZC
        FROM CKTS_SB_MDT_CKMX T
       WHERE T.DJXH=CUR_BGQ.DJXH
         AND T.SBRQ>=V_BGQ_Q AND T.SBRQ<CUR_BGQ.BGQ_Z+1
         AND T.CKTMSYWLXDMJH LIKE '%STZC%';

      --  V_TS_JHFP_JE  NUMBER(18,2)  退税_发票总金额
      --  V_TS_JHFP_FS  NUMBER(10)  退税_发票总份数
      --  V_TS_GHS_NUM  NUMBER(10)  退税_供货商个数
      SELECT COUNT(DISTINCT T.JHPZH), IFNULL(SUM(T.JSJE), 0), COUNT(DISTINCT T.GHFNSRSBH_1)
        INTO V_TS_JHFP_FS, V_TS_JHFP_JE, V_TS_GHS_NUM
        FROM CKTS_SB_MTS_JHMX T
       WHERE T.DJXH=CUR_BGQ.DJXH
         AND T.SBRQ>=V_BGQ_Q AND T.SBRQ<CUR_BGQ.BGQ_Z+1
         AND T.SZ='V' AND IFNULL(T.BYBLBZ, 'N')='N';

      --  V_TS_JHFP_FS_CQ1  NUMBER(10)  退税_超期1发票份数
      --  V_TS_JHFP_JE_CQ1  NUMBER(18,2)  退税_超期1发票金额
      SELECT COUNT(DISTINCT T.JHPZH), IFNULL(SUM(T.JSJE), 0)
        INTO V_TS_JHFP_FS_CQ1, V_TS_JHFP_JE_CQ1
        FROM CKTS_SB_MTS_JHMX T
       WHERE T.DJXH=CUR_BGQ.DJXH
         AND T.SBRQ>=V_BGQ_Q AND T.SBRQ<CUR_BGQ.BGQ_Z+1
         AND T.KPRQ - T.CKRQ_1 >= 60
         AND T.SZ='V' AND IFNULL(T.BYBLBZ, 'N')='N';

      --  V_TS_JHFP_FS_CQ2  NUMBER(10)  退税_超期2发票份数
      --  V_TS_JHFP_JE_CQ2  NUMBER(18,2)  退税_超期2发票金额
      SELECT COUNT(DISTINCT T.JHPZH), IFNULL(SUM(T.JSJE), 0)
        INTO V_TS_JHFP_FS_CQ2, V_TS_JHFP_JE_CQ2
        FROM CKTS_SB_MTS_JHMX T
       WHERE T.DJXH=CUR_BGQ.DJXH
         AND T.SBRQ>=V_BGQ_Q AND T.SBRQ<CUR_BGQ.BGQ_Z+1
         AND T.KPRQ - T.CKRQ_1 >= 90
         AND T.SZ='V' AND IFNULL(T.BYBLBZ, 'N')='N';

      UPDATE JKGL_DATA_TJ_ZBU
         SET TS_BGDSL=V_TS_BGDSL,
             TS_CKEUSD=V_TS_CKEUSD,
             TS_CKERMB=V_TS_CKERMB,
             TS_MTSCKE=V_TS_MTSCKE,
             TS_JSJE=V_TS_JSJE,
             TS_HHCB=V_TS_HHCB,
             TS_BGDSL_CQ=V_TS_BGDSL_CQ,
             TS_CKEUSD_CQ=V_TS_CKEUSD_CQ,
             TS_TSE_SB=V_TS_TSE_SB,
             TS_MDE_SB=V_TS_MDE_SB,
             TS_TSE_HZ=V_TS_TSE_HZ,
             TS_MDE_HZ=V_TS_MDE_HZ,
             TS_TSE_BL=V_TS_TSE_BL,
             TS_MDE_BL=V_TS_MDE_BL,
             TS_CKERMB_STZC=V_TS_CKERMB_STZC,
             TS_JHFP_JE=V_TS_JHFP_JE,
             TS_JHFP_FS=V_TS_JHFP_FS,
             TS_GHS_NUM=V_TS_GHS_NUM,
             TS_JHFP_FS_CQ1=V_TS_JHFP_FS_CQ1,
             TS_JHFP_JE_CQ1=V_TS_JHFP_JE_CQ1,
             TS_JHFP_FS_CQ2=V_TS_JHFP_FS_CQ2,
             TS_JHFP_JE_CQ2=V_TS_JHFP_JE_CQ2
       WHERE BGQID=CUR_BGQ.BGQID;
      COMMIT;
    END;

    --解锁处理完成的报告期
    UPDATE JKGL_DATA_BGQ T
       SET T.TQBZ=NULL, T.WCSJ=CURRENT_TIMESTAMP, T.SXZT='3', 
           T.ZBU_DZSPXX_ZT='Y', T.ZBU_DZSPJX_ZT='Y', T.ZBU_DZXF_ZT='Y', T.ZBU_DZGF_ZT='Y'
     WHERE T.BGQID=CUR_BGQ.BGQID;
    COMMIT;

    -- 后续需要通过ETL抽取的数据
    --  V_ZZS_，其中退税发票的顶格开具指标元，农产品指标元，在此处实现
    --  V_ZC_
    --  V_LR_
    --  V_DZ_

  END LOOP;

  LEAVE routine_body;
END$$

DELIMITER ;
