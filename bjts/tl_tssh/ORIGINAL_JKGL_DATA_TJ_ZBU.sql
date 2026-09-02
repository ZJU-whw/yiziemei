CREATE OR REPLACE PROCEDURE ORIGINAL_JKGL_DATA_TJ_ZBU
/*
 * 指标元刷新口径
 * 金三、电子抵账部分数据的统计，通过ETL实现。
 */
AS
  V_CK_BGDSL        NUMBER(10); --  出口_报关单数量
  V_CK_CKEUSD       NUMBER(18,2); --  出口_出口额USD
  V_CK_CKERMB       NUMBER(18,2); --  出口_出口额
  V_CK_SBDW_SL      NUMBER(10); --  出口_申报单位数量
  V_CK_GB_SL        NUMBER(10); --  出口_目的国数量
  V_CK_BGDSL_DE     NUMBER(10); --  出口_大额报关单数量
  V_CK_CKEUSD_DE    NUMBER(18,2); --  出口_大额报关单出口额USD
  V_CK_BGDSL_ST     NUMBER(10); --  出口_四同报关单数量
  V_CK_PXBGDSL      NUMBER(10); --  出口_拼箱报关单数量
  V_CK_ZXBGDSL      NUMBER(18,2); --  出口_整箱报关单数量
  V_CK_PJDBHGZ      NUMBER(18,2); --  出口_平均单笔货柜值
  V_CK_CKEUSD_LASTYEAR	NUMBER(18,2); --	出口_最近12个月出口额USD
  V_ZZS_XSE_QB      NUMBER(18,2); --  增值税_全部销售
  V_ZZS_XSE_MDT     NUMBER(18,2); --  增值税_免抵退出口销售
  V_ZZS_XSE_MS      NUMBER(18,2); --  增值税_免税销售
  V_ZZS_XXSE        NUMBER(18,2); --  增值税_销项税额
  V_ZZS_JXSE        NUMBER(18,2); --  增值税_进项税额
  V_ZZS_JXSEZC      NUMBER(18,2); --  增值税_进项税额转出
  V_ZZS_MDTBDDKJXSE NUMBER(18,2); --  增值税_免抵退不得抵扣进项税额
  V_ZZS_YNSE        NUMBER(18,2); --  增值税_应纳税额
  V_DZ_XXFS_QB      NUMBER(10); --  底账_销项份数_全部
  V_DZ_XXJE_QB      NUMBER(18,2); --  底账_销项金额_全部
  V_DZ_XXSE_QB      NUMBER(18,2); --  底账_销项税额_全部
  V_DZ_XXFS_ZY      NUMBER(10); --  底账_销项份数_专票
  V_DZ_XXJE_ZY      NUMBER(18,2); --  底账_销项金额_专票
  V_DZ_XXSE_ZY      NUMBER(18,2); --  底账_销项税额_专票
  V_DZ_XXFS_PT      NUMBER(10); --  底账_销项份数_普票
  V_DZ_XXJE_PT      NUMBER(18,2); --  底账_销项金额_普票
  V_DZ_XXSE_PT      NUMBER(18,2); --  底账_销项税额_普票
  V_DZ_XXFS_CK      NUMBER(10); --  底账_销项份数_出口
  V_DZ_XXJE_CK      NUMBER(18,2); --  底账_销项金额_出口
  V_DZ_JXFS_QB      NUMBER(10); --  底账_全部进项份数
  V_DZ_JXJE_QB      NUMBER(18,2); --  底账_全部进项金额
  V_DZ_JXSE_QB      NUMBER(18,2); --  底账_全部进项税额
  V_DZ_JXFS_ZY      NUMBER(10); --  底账_进项份数_专票
  V_DZ_JXJE_ZY      NUMBER(18,2); --  底账_进项金额_专票
  V_DZ_JXSE_ZY      NUMBER(18,2); --  底账_进项税额_专票
  V_DZ_JXFS_PT      NUMBER(10); --  底账_进项份数_普票
  V_DZ_JXJE_PT      NUMBER(18,2); --  底账_进项金额_普票
  V_DZ_JXSE_PT      NUMBER(18,2); --  底账_进项税额_普票
  V_DZ_JXFS_DGKJ    NUMBER(10); --  底账_进项份数_专票顶格开具
  V_DZ_JXJE_DGKJ    NUMBER(18,2); --  底账_进项金额_专票顶格开具
  V_DZ_JXSE_DGKJ    NUMBER(18,2); --  底账_进项税额_专票顶格开具
  V_DZ_JXSE_JKS     NUMBER(18,2); --  底账_进项税额_缴款书
  V_DZ_JXJE_NCP     NUMBER(18,2); --  底账_进项金额_农产品
  V_DZ_JXSE_NCP     NUMBER(18,2); --  底账_进项税额_农产品
  V_DZ_DFJE_SR      NUMBER(18,2); --  底账_电费收入（销项）
  V_DZ_DFJE_ZC      NUMBER(18,2); --  底账_电费支出（进项）
  V_DZ_WTJG         NUMBER(18,2); --  底账_委托加工费支出
  V_DZ_YFJE         NUMBER(18,2); --  底账_运费支出
  V_DZ_JXJE_SN      NUMBER(18,2); --  底账_进项金额_省内
  V_DZ_JXJE_SW      NUMBER(18,2); --  底账_进项金额_省外
  V_TS_BGDSL        NUMBER(10); --  退税_报关单数量
  V_TS_CKEUSD       NUMBER(18,2); --  退税_出口额USD
  V_TS_CKERMB       NUMBER(18,2); --  退税_出口额RMB
  V_TS_JSJE         NUMBER(18,2); --  退税_计税金额（免退税）
  V_TS_HHCB         NUMBER(18,2); --  退税_换汇成本（免退税）
  V_TS_BGDSL_CQ     NUMBER(10); --  退税_报关单数量_超期申报
  V_TS_CKEUSD_CQ    NUMBER(18,2); --  退税_出口额USD_超期申报
  V_TS_TSE_SB       NUMBER(18,2); --  退税_退税额_申报
  V_TS_MDE_SB       NUMBER(18,2); --  退税_免抵额_申报
  V_TS_TSE_HZ       NUMBER(18,2); --  退税_退税_核准
  V_TS_MDE_HZ       NUMBER(18,2); --  退税_免抵_核准
  V_TS_TSE_BL       NUMBER(18,2); --  退税_退税_办理
  V_TS_MDE_BL       NUMBER(18,2); --  退税_免抵_办理
  V_TS_CKERMB_STZC  NUMBER(18,2); --  退税_视同自产出口额
  V_TS_JHFP_JE_DG   NUMBER(18,2); --  退税_顶格开票金额
  V_TS_JHFP_FS_DG   NUMBER(10); --  退税_顶格开票份数
  V_TS_JHFP_JE      NUMBER(18,2); --  退税_发票总金额
  V_TS_JHFP_FS      NUMBER(10); --  退税_发票总份数
  V_TS_JHFP_JE_CQ1  NUMBER(18,2); --  退税_超期1发票金额
  V_TS_JHFP_FS_CQ1  NUMBER(10); --  退税_超期1发票份数
  V_TS_JHFP_JE_CQ2  NUMBER(18,2); --  退税_超期2发票金额
  V_TS_JHFP_FS_CQ2  NUMBER(10); --  退税_超期2发票份数
  V_TS_GHS_NUM      NUMBER(10); --  退税_供货商个数
  V_ZC_YSZK_QC      NUMBER(18,2); --  资产_应收账款_期初
  V_ZC_YSZK_QM      NUMBER(18,2); --  资产_应收账款_期末
  V_ZC_YFZK_QC      NUMBER(18,2); --  资产_应付账款_期初
  V_ZC_YFZK_QM      NUMBER(18,2); --  资产_应付账款_期末
  V_ZC_GDZC_QC      NUMBER(18,2); --  资产_固定资产_期初
  V_ZC_GDZC_QM      NUMBER(18,2); --  资产_固定资产_期末
  V_ZC_CH_QC        NUMBER(18,2); --  资产_存货_期初
  V_ZC_CH_QM        NUMBER(18,2); --  资产_存货_期末
  V_ZC_ZCZE_QC      NUMBER(18,2); --  资产_资产总额_期初
  V_ZC_ZCZE_QM      NUMBER(18,2); --  资产_资产总额_期末
  V_ZC_FZZE_QC      NUMBER(18,2); --  资产_负债总额_期初
  V_ZC_FZZE_QM      NUMBER(18,2); --  资产_负债总额_期末
  V_ZC_SYZQY_QC     NUMBER(18,2); --  资产_所有者权益_期初
  V_ZC_SYZQY_QM     NUMBER(18,2); --  资产_所有者权益_期末
  V_ZC_SSGDQY_QC    NUMBER(18,2); --  资产_少数股东权益_期初
  V_ZC_SSGDQY_QM    NUMBER(18,2); --  资产_少数股东权益_期末
  V_ZC_LDZC_QC      NUMBER(18,2); --  资产_流动资产_期初
  V_ZC_LDZC_QM      NUMBER(18,2); --  资产_流动资产_期末
  V_ZC_YUSZK_QC     NUMBER(18,2); --  资产_预收账款_期初
  V_ZC_YUSZK_QM     NUMBER(18,2); --  资产_预收账款_期末
  V_ZC_YUFZK_QC     NUMBER(18,2); --  资产_预付账款_期初
  V_ZC_YUFZK_QM     NUMBER(18,2); --  资产_预付账款_期末
  V_ZC_LDFZZE_QC    NUMBER(18,2); --  资产_流动负债总额_期初
  V_ZC_LDFZZE_QM    NUMBER(18,2); --  资产_流动负债总额_期末
  
  V_LR_YYSR         NUMBER(18,2); --  利润_营业收入
  V_LR_YYCB         NUMBER(18,2); --  利润_营业成本
  V_LR_XSFY         NUMBER(18,2); --  利润_销售费用
  V_LR_GLFY         NUMBER(18,2); --  利润_管理费用
  V_LR_YYLR         NUMBER(18,2); --  利润_营业利润
  V_LR_LRZE         NUMBER(18,2); --  利润_利润总额
  V_LR_QTSR         NUMBER(18,2); --  利润_其它收入
  V_LR_SJJFJ        NUMBER(18,2); --  利润_税金及附加
  V_LR_CWFY         NUMBER(18,2); --  利润_财务费用
  V_LR_JLR          NUMBER(18,2); --  利润_净利润
  V_LR_SDS          NUMBER(18,2); --  利润_所得税
  V_LR_LXZC         NUMBER(18,2); --  利润_利息支出
  
  V_CW_MLL          NUMBER(8,2); --  财务_毛利率
  V_CW_HYSFL        NUMBER(8,2); --  财务_还原税负率
  
  V_ROWS            NUMBER(10);  -- 待更新表中是否存在目标记录
  V_CK_BGDSL_SN     NUMBER(10);  -- 出口_上年报关单数量，用于确定大额报关单阈值
  V_CK_CKEUSD_SN    NUMBER(18,2); -- 出口_上年报关单出口额USD，用于确定大额报关单阈值
  V_CK_DEBGD_YZ     NUMBER(18,2); -- 出口_大额报关单阈值
  V_SDS_YYSR        NUMBER(18,2); --     所得税_营业收入
  V_SDS_YNSSDE      NUMBER(18,2); --     所得税_应纳税所得额
BEGIN
  FOR CUR_BGQ IN (SELECT T.BGQID, T.DJXH, S.NSRDJNO, S.SHXYNO, T.ZQLX, 
                         T.BGQ_Q, T.BGQ_Z, TO_CHAR(T.BGQ_Q,'YYYYMM') AS YF_Q, TO_CHAR(T.BGQ_Z,'YYYYMM') AS YF_Z
                    FROM TL_TSSH.JKGL_DATA_BGQ T
                   INNER JOIN TL_TSSH.GLXT_BB_SHXT_DJXX S ON S.DJXH_JS=T.DJXH
                   WHERE T.SXZT='0' AND T.TQBZ IS NULL AND T.BGQ_Z<TRUNC(SYSDATE,'MM'))
  LOOP
    --锁定正在处理的报告期
    UPDATE TL_TSSH.JKGL_DATA_BGQ T
       SET T.TQBZ=SYS_GUID(), T.TQSJ=SYSDATE, T.SXZT='1'
     WHERE T.BGQID=CUR_BGQ.BGQID;
    COMMIT;
    
    --计算 JKGL_DATA_TJ_ZBU.BGQID
    SELECT COUNT(1)
      INTO V_ROWS
      FROM TL_TSSH.JKGL_DATA_TJ_ZBU T
     WHERE T.BGQID=CUR_BGQ.BGQID AND ROWNUM=1;
    IF V_ROWS=0 THEN
      INSERT INTO TL_TSSH.JKGL_DATA_TJ_ZBU(BGQID) VALUES (CUR_BGQ.BGQID);
      COMMIT;
    END IF;
    
    --  V_CK_
    BEGIN
      --  V_CK_BGDSL  NUMBER(10)  出口_报关单数量
      --  V_CK_CKEUSD NUMBER(18,2)  出口_出口额USD
      --  V_CK_CKERMB NUMBER(18,2)  出口_出口额
      --  V_CK_SBDW_SL  NUMBER(10)  出口_申报单位数量
      --  V_CK_GB_SL  NUMBER(10)  出口_目的国数量
      SELECT COUNT(DISTINCT SUBSTR(T.CKBGDH,1,18)), NVL(SUM(T.MYLAJ),0), NVL(SUM(T.RMBLAJ),0), 
             COUNT(DISTINCT T.SBDWDM), COUNT(DISTINCT T.MYGDQSZ_DM)
        INTO V_CK_BGDSL, V_CK_CKEUSD, V_CK_CKERMB, V_CK_SBDW_SL, V_CK_GB_SL
        FROM TL_TSSH.CKTS_WBSJ_HG_BGD T
       WHERE T.DJXH=CUR_BGQ.DJXH
         AND T.CKRQ_1>=CUR_BGQ.BGQ_Q AND T.CKRQ_1<CUR_BGQ.BGQ_Z+1
         AND T.JGFS_DM<>'1039';

      --  V_CK_BGDSL_DE NUMBER(10)  出口_大额报关单数量
      --  V_CK_CKEUSD_DE  NUMBER(18,2)  出口_大额报关单出口额USD
      --  每单超10W美金算大额报关单
      SELECT COUNT(1), NVL(SUM(MYLAJ18),0)
        INTO V_CK_BGDSL_DE, V_CK_CKEUSD_DE
        FROM (SELECT SUBSTR(T.CKBGDH,1,18) AS BGD18, SUM(T.MYLAJ) AS MYLAJ18
                FROM TL_TSSH.CKTS_WBSJ_HG_BGD T
               WHERE T.DJXH=CUR_BGQ.DJXH
                 AND T.CKRQ_1>=CUR_BGQ.BGQ_Q AND T.CKRQ_1<CUR_BGQ.BGQ_Z+1
                 AND T.JGFS_DM<>'1039'
               GROUP BY SUBSTR(T.CKBGDH,1,18)
              HAVING SUM(T.MYLAJ)>100000) T2;

      --  V_CK_BGDSL_ST NUMBER(10)  出口_四同报关单数量
      SELECT COUNT(1)
        INTO V_CK_BGDSL_ST
        FROM (SELECT T.CKRQ_1,T.HGGQKA_DM,T.CKSP_DM,T.MYGDQSZ_DM, COUNT(DISTINCT SUBSTR(T.CKBGDH,1,18)) AS STNUM
                FROM TL_TSSH.CKTS_WBSJ_HG_BGD T
               WHERE T.DJXH=CUR_BGQ.DJXH
                 AND T.CKRQ_1>=CUR_BGQ.BGQ_Q AND T.CKRQ_1<CUR_BGQ.BGQ_Z+1
                 AND T.JGFS_DM<>'1039'
               GROUP BY T.CKRQ_1,T.HGGQKA_DM,T.CKSP_DM,T.MYGDQSZ_DM)
       WHERE STNUM>=3;

      --  V_CK_PXBGDSL  NUMBER(10)  出口_拼箱报关单数量
      SELECT COUNT(DISTINCT T.BGDHGBH)
        INTO V_CK_PXBGDSL
        FROM TL_TSSH.CKTS_WBSJ_HG_BGD204 T
       WHERE T.DJXH=CUR_BGQ.DJXH
         AND T.CKRQ_1>=CUR_BGQ.BGQ_Q AND T.CKRQ_1<CUR_BGQ.BGQ_Z+1
         AND EXISTS (SELECT 1
                       FROM TL_TSSH.CKTS_WBSJ_HG_BGD204 S
                      WHERE S.JZXH=T.JZXH AND S.CKRQ_1=T.CKRQ_1 AND S.DJXH<>T.DJXH);

      --  V_CK_ZXBGDSL  NUMBER(18,2)  出口_整箱报关单数量
      --  V_CK_PJDBHGZ  NUMBER(18,2)  出口_平均单笔货柜值
      WITH JZXHXX AS (SELECT T2.BGDHGBH, COUNT(DISTINCT T2.JZXH) AS JZXSL
                        FROM TL_TSSH.CKTS_WBSJ_HG_BGD204 T2
                       WHERE T2.DJXH=CUR_BGQ.DJXH
                         AND T2.CKRQ_1>=CUR_BGQ.BGQ_Q AND T2.CKRQ_1<CUR_BGQ.BGQ_Z+1
                         AND NOT EXISTS (SELECT 1
                                           FROM TL_TSSH.CKTS_WBSJ_HG_BGD204 T3
                                          WHERE T3.JZXH=T2.JZXH AND T3.CKRQ_1=T2.CKRQ_1 AND T3.DJXH<>T2.DJXH)
                       GROUP BY T2.BGDHGBH),
           CKBGXX AS (SELECT SUBSTR(T.CKBGDH,1,18) AS BGDHGBH, SUM(T.MYLAJ) AS TOTALMY
                        FROM TL_TSSH.CKTS_WBSJ_HG_BGD T
                       WHERE T.DJXH=CUR_BGQ.DJXH
                         AND T.CKRQ_1>=CUR_BGQ.BGQ_Q AND T.CKRQ_1<CUR_BGQ.BGQ_Z+1
                         AND T.JGFS_DM<>'1039'
                       GROUP BY SUBSTR(T.CKBGDH,1,18))
      SELECT COUNT(DISTINCT JZXHXX.BGDHGBH), 
             NVL((CASE WHEN SUM(JZXHXX.JZXSL)=0 THEN 0 ELSE SUM(CKBGXX.TOTALMY)/SUM(JZXHXX.JZXSL) END),0)
        INTO V_CK_ZXBGDSL, V_CK_PJDBHGZ
        FROM JZXHXX
       INNER JOIN CKBGXX ON JZXHXX.BGDHGBH=CKBGXX.BGDHGBH;

      --  V_CK_CKEUSD_LASTYEAR	NUMBER(18,2); --	出口_最近12个月出口额USD
      IF CUR_BGQ.BGQ_Q = ADD_MONTHS(TRUNC(CUR_BGQ.BGQ_Z,'MM'), -11) THEN
        V_CK_CKEUSD_LASTYEAR:=V_CK_CKEUSD;
      ELSE
        SELECT NVL(SUM(T.MYLAJ),0)
          INTO V_CK_CKEUSD_LASTYEAR
          FROM TL_TSSH.CKTS_WBSJ_HG_BGD T
         WHERE T.DJXH=CUR_BGQ.DJXH
           AND T.CKRQ_1>=ADD_MONTHS(TRUNC(CUR_BGQ.BGQ_Z,'MM'), -11) AND T.CKRQ_1<CUR_BGQ.BGQ_Z+1
           AND T.JGFS_DM<>'1039';
      END IF;

      UPDATE TL_TSSH.JKGL_DATA_TJ_ZBU
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
      --  V_TS_JSJE NUMBER(18,2)  退税_计税金额（免退税）
      --  V_TS_BGDSL_CQ NUMBER(10) 退税_报关单数量_超期申报
      --  V_TS_CKEUSD_CQ NUMBER(18,2)  退税_出口额USD_超期申报
      SELECT COUNT(DISTINCT SUBSTR(T.CKBGDH,1,18)), NVL(SUM(T.MYLAJ),0), NVL(SUM(T.RMBLAJ),0), NVL(SUM(T.JSJE),0),
             COUNT(DISTINCT CASE WHEN T.SBRQ>TO_DATE(TO_CHAR(ADD_MONTHS(T.CKRQ,12),'YYYY')||'0420','YYYYMMDD') AND T.MYLAJ>0 THEN SUBSTR(T.CKBGDH,1,18) ELSE NULL END),
             NVL(SUM(CASE WHEN T.SBRQ>TO_DATE(TO_CHAR(ADD_MONTHS(T.CKRQ,12),'YYYY')||'0420','YYYYMMDD') AND T.MYLAJ>0 THEN T.MYLAJ ELSE NULL END),0)
        INTO V_TS_BGDSL, V_TS_CKEUSD, V_TS_CKERMB, V_TS_JSJE, V_TS_BGDSL_CQ, V_TS_CKEUSD_CQ
        FROM TL_TSSH.JCFX_DATA_TSSBMX T
       WHERE T.DJXH=CUR_BGQ.DJXH
         AND T.SBRQ>=CUR_BGQ.BGQ_Q AND T.SBRQ<CUR_BGQ.BGQ_Z+1;

      --  V_TS_HHCB NUMBER(18,2)  退税_换汇成本（免退税）
      V_TS_HHCB := CASE WHEN V_TS_CKERMB >0 AND V_TS_JSJE>0 THEN V_TS_JSJE / V_TS_CKERMB ELSE 0 END;

      --  V_TS_TSE_SB NUMBER(18,2)  退税_退税额_申报
      --  V_TS_MDE_SB NUMBER(18,2)  退税_免抵额_申报
      --  CKTS_LC_SBXX.SBRQ为便捷退税申报日期，部分数据没有，改用流程启动时间
      SELECT NVL(SUM(T.SB_ZZSTSE+T.SB_XFSTSE),0), NVL(SUM(T.SB_MDSE),0)
        INTO V_TS_TSE_SB, V_TS_MDE_SB
        FROM TL_TSSH.CKTS_LC_SBXX T
       WHERE T.DJXH=CUR_BGQ.DJXH
         AND T.QDSJ>=CUR_BGQ.BGQ_Q AND T.QDSJ<CUR_BGQ.BGQ_Z+1 
         AND NVL(T.ZFBZ,'N')='N';

      --  V_TS_TSE_HZ NUMBER(18,2)  退税_退税_核准
      --  V_TS_MDE_HZ NUMBER(18,2)  退税_免抵_核准
      SELECT NVL(SUM(S.SEHZ_ZZSTSE+S.SEHZ_XFSTSE),0), NVL(SUM(S.SEHZ_MDSE),0)
        INTO V_TS_TSE_HZ, V_TS_MDE_HZ
        FROM TL_TSSH.CKTS_LC_SEHZXX S
       WHERE S.DJXH=CUR_BGQ.DJXH
         AND S.SEHZRQ>=CUR_BGQ.BGQ_Q AND S.SEHZRQ<CUR_BGQ.BGQ_Z+1;

      --  V_TS_TSE_BL NUMBER(18,2)  退税_退税_办理
      SELECT NVL(SUM(S.SE),0)
        INTO V_TS_TSE_BL
        FROM TL_TSSH.CKTS_ZS_SRTHS S
       WHERE S.DJXH=CUR_BGQ.DJXH
         AND S.THRQ_1>=CUR_BGQ.BGQ_Q AND S.THRQ_1<CUR_BGQ.BGQ_Z+1
         AND S.TTSJLX_DM='01' AND S.TZLX_DM IN ('1','4');

      --  V_TS_MDE_BL NUMBER(18,2)  退税_免抵_办理
      SELECT NVL(SUM(S.JE),0)
        INTO V_TS_MDE_BL
        FROM TL_TSSH.CKTS_ZS_TKGZ S
       WHERE S.DJXH=CUR_BGQ.DJXH
         AND S.GKGZRQ>=CUR_BGQ.BGQ_Q AND S.GKGZRQ<CUR_BGQ.BGQ_Z+1
         AND S.TZSLY='3' AND S.TZLX_DM='1' AND S.GZBZ='Y';

      --  V_TS_CKERMB_STZC  NUMBER(18,2)  退税_视同自产出口额
      SELECT NVL(SUM(MYLAJ),0)
        INTO V_TS_CKERMB_STZC
        FROM TL_TSSH.CKTS_SB_MDT_CKMX T
       WHERE T.DJXH=CUR_BGQ.DJXH
         AND T.SBRQ>=CUR_BGQ.BGQ_Q AND T.SBRQ<CUR_BGQ.BGQ_Z+1
         AND T.CKTMSYWLXDMJH LIKE '%STZC%';

      --  V_TS_JHFP_JE  NUMBER(18,2)  退税_发票总金额
      --  V_TS_JHFP_FS  NUMBER(10)  退税_发票总份数
      --  V_TS_GHS_NUM  NUMBER(10)  退税_供货商个数
      SELECT COUNT(DISTINCT T.JHPZH), NVL(SUM(T.JSJE),0), COUNT(DISTINCT T.GHFNSRSBH_1)
        INTO V_TS_JHFP_FS, V_TS_JHFP_JE, V_TS_GHS_NUM
        FROM TL_TSSH.CKTS_SB_MTS_JHMX T
       WHERE T.DJXH=CUR_BGQ.DJXH
         AND T.SBRQ>=CUR_BGQ.BGQ_Q AND T.SBRQ<CUR_BGQ.BGQ_Z+1;

      --  V_TS_JHFP_FS_CQ1  NUMBER(10)  退税_超期1发票份数
      --  V_TS_JHFP_JE_CQ1  NUMBER(18,2)  退税_超期1发票金额
      SELECT COUNT(DISTINCT T.JHPZH), NVL(SUM(T.JSJE),0)
        INTO V_TS_JHFP_FS_CQ1, V_TS_JHFP_JE_CQ1
        FROM TL_TSSH.CKTS_SB_MTS_JHMX T
       WHERE T.DJXH=CUR_BGQ.DJXH
         AND T.SBRQ>=CUR_BGQ.BGQ_Q AND T.SBRQ<CUR_BGQ.BGQ_Z+1
         AND T.KPRQ - T.CKRQ_1 >= 30
         AND T.KPRQ - T.CKRQ_1 < 60;

      --  V_TS_JHFP_FS_CQ2  NUMBER(10)  退税_超期2发票份数
      --  V_TS_JHFP_JE_CQ2  NUMBER(18,2)  退税_超期2发票金额
      SELECT COUNT(DISTINCT T.JHPZH), NVL(SUM(T.JSJE),0)
        INTO V_TS_JHFP_FS_CQ2, V_TS_JHFP_JE_CQ2
        FROM TL_TSSH.CKTS_SB_MTS_JHMX T
       WHERE T.DJXH=CUR_BGQ.DJXH
         AND T.SBRQ>=CUR_BGQ.BGQ_Q AND T.SBRQ<CUR_BGQ.BGQ_Z+1
         AND T.KPRQ - T.CKRQ_1 >= 60;

      UPDATE TL_TSSH.JKGL_DATA_TJ_ZBU
         SET TS_BGDSL=V_TS_BGDSL,
             TS_CKEUSD=V_TS_CKEUSD,
             TS_CKERMB=V_TS_CKERMB,
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
             TS_JHFP_JE_DG=V_TS_JHFP_JE_DG,
             TS_JHFP_FS_DG=V_TS_JHFP_FS_DG,
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
    
    --  V_ZZS_
    BEGIN
      --  V_ZZS_XSE_QB  NUMBER(18,2)  增值税_全部销售
      --  V_ZZS_XSE_MDT NUMBER(18,2)  增值税_免抵退出口销售
      --  V_ZZS_XSE_MS  NUMBER(18,2)  增值税_免税销售
      --  V_ZZS_XXSE  NUMBER(18,2)  增值税_销项税额
      --  V_ZZS_JXSE  NUMBER(18,2)  增值税_进项税额
      --  V_ZZS_JXSEZC  NUMBER(18,2)  增值税_进项税额转出
      --  V_ZZS_YNSE  NUMBER(18,2)  增值税_应纳税额
      SELECT NVL(SUM(ASYSLJSXSE+AJYBFJSXSE+MDTBFCKXSE+MSXSE),0), NVL(SUM(MDTBFCKXSE),0), NVL(SUM(MSXSE),0), 
             NVL(SUM(XXSE),0), NVL(SUM(JXSE),0),  NVL(SUM(JXSEZC),0), NVL(SUM(YNSE),0)
        INTO V_ZZS_XSE_QB, V_ZZS_XSE_MDT, V_ZZS_XSE_MS, V_ZZS_XXSE, V_ZZS_JXSE, V_ZZS_JXSEZC, V_ZZS_YNSE
        FROM HX_SB.SB_ZZS_YBNSR
       WHERE SBUUID IN (SELECT DISTINCT SBUUID
                          FROM HX_SB.SB_SBXX
                         WHERE DJXH=CUR_BGQ.DJXH
                           AND SKSSQQ>=CUR_BGQ.BGQ_Q AND SKSSQZ<CUR_BGQ.BGQ_Z+1
                           AND ZSXM_DM='10101' 
                           AND YZPZZL_DM='BDA0610606'
                           AND GZLX_DM_1 IN ('1','5')
                           AND ZFBZ_1='N' )
         AND EWBLXH IN (1, 3);
        
      --  V_ZZS_MDTBDDKJXSE NUMBER(18,2)  增值税_免抵退不得抵扣进项税额
      --  V_DZ_JXJE_NCP NUMBER(18,2)  底账_进项金额_农产品
      --  V_DZ_JXSE_NCP NUMBER(18,2)  底账_进项税额_农产品
      SELECT NVL(SUM(CASE WHEN EWBHXH = 18 THEN SE ELSE 0 END),0), 
             NVL(SUM(CASE WHEN EWBHXH = 6 THEN JE ELSE 0 END),0), 
             NVL(SUM(CASE WHEN EWBHXH = 6 THEN SE ELSE 0 END),0)
        INTO V_ZZS_MDTBDDKJXSE, V_DZ_JXJE_NCP, V_DZ_JXSE_NCP
        FROM HX_SB.SB_ZZS_YBNSR_FB2_BQJXSEMX
       WHERE SBUUID IN (SELECT DISTINCT SBUUID
                          FROM HX_SB.SB_SBXX
                         WHERE DJXH=CUR_BGQ.DJXH
                           AND SKSSQQ>=CUR_BGQ.BGQ_Q AND SKSSQZ<CUR_BGQ.BGQ_Z+1
                           AND ZSXM_DM='10101' 
                           AND YZPZZL_DM='BDA0610606'
                           AND GZLX_DM_1 IN ('1','5')
                           AND ZFBZ_1='N' );
        
      UPDATE TL_TSSH.JKGL_DATA_TJ_ZBU
         SET ZZS_XSE_QB=V_ZZS_XSE_QB, 
             ZZS_XSE_MDT=V_ZZS_XSE_MDT, 
             ZZS_XSE_MS=V_ZZS_XSE_MS, 
             ZZS_XXSE=V_ZZS_XXSE, 
             ZZS_JXSE=V_ZZS_JXSE,
             ZZS_JXSEZC=V_ZZS_JXSEZC,
             ZZS_YNSE=V_ZZS_YNSE,
             ZZS_MDTBDDKJXSE=V_ZZS_MDTBDDKJXSE,
             DZ_JXJE_NCP=V_DZ_JXJE_NCP,
             DZ_JXSE_NCP=V_DZ_JXSE_NCP
       WHERE BGQID=CUR_BGQ.BGQID;
      COMMIT;
    END;
    
    --  V_FP_1             (DZDZ_ZT)
    BEGIN
      --  V_DZ_XXFS_ZY  NUMBER(10)  底账_销项份数_专票
      --  V_DZ_XXJE_ZY  NUMBER(18,2)  底账_销项金额_专票
      --  V_DZ_XXSE_ZY  NUMBER(18,2)  底账_销项税额_专票
      SELECT COUNT(1), NVL(SUM(TT.JE),0), NVL(SUM(TT.SE),0)
        INTO V_DZ_XXFS_ZY, V_DZ_XXJE_ZY, V_DZ_XXSE_ZY
        FROM (SELECT T1.JE, T1.SE
                FROM DZDZ.DZDZ_FPXX_DZZP T1 --电子专票
               WHERE T1.KPYF>=CUR_BGQ.YF_Q AND T1.KPYF<=CUR_BGQ.YF_Z 
                 AND T1.XSFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T1.FPZTBZ IN ('0','1')
               UNION ALL
              SELECT T2.JE, T2.SE
                FROM DZDZ.DZDZ_FPXX_ZZSFP T2 --纸质专票
               WHERE T2.KPYF>=CUR_BGQ.YF_Q AND T2.KPYF<=CUR_BGQ.YF_Z 
                 AND T2.XFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T2.FPZT_BZ IN ('0','1')
             ) TT;
        
      --  V_DZ_XXFS_PT  NUMBER(10)  底账_销项份数_普票
      --  V_DZ_XXJE_PT  NUMBER(18,2)  底账_销项金额_普票
      --  V_DZ_XXSE_PT  NUMBER(18,2)  底账_销项税额_普票
      SELECT COUNT(1), NVL(SUM(TT.JE),0), NVL(SUM(TT.SE),0)
        INTO V_DZ_XXFS_PT, V_DZ_XXJE_PT, V_DZ_XXSE_PT
        FROM (SELECT T1.JE, T1.SE
                FROM DZDZ.DZDZ_FPXX_DZFP T1 --电子普票
               WHERE T1.KPYF>=CUR_BGQ.YF_Q AND T1.KPYF<=CUR_BGQ.YF_Z 
                 AND T1.XFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T1.FPZT_BZ IN ('0','1')
               UNION ALL
              SELECT T2.JE, T2.SE
                FROM DZDZ.DZDZ_FPXX_PTFP T2 --纸质普票
               WHERE T2.KPYF>=CUR_BGQ.YF_Q AND T2.KPYF<=CUR_BGQ.YF_Z 
                 AND T2.XFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T2.FPZT_BZ IN ('0','1')
             ) TT;
        
      --  V_DZ_XXFS_QB  NUMBER(10)  底账_销项份数_全部
      --  V_DZ_XXJE_QB  NUMBER(18,2)  底账_销项金额_全部
      --  V_DZ_XXSE_QB  NUMBER(18,2)  底账_销项税额_全部
      V_DZ_XXFS_QB := V_DZ_XXFS_ZY + V_DZ_XXFS_PT;
      V_DZ_XXJE_QB := V_DZ_XXJE_ZY + V_DZ_XXJE_PT;
      V_DZ_XXSE_QB := V_DZ_XXSE_ZY + V_DZ_XXSE_PT;
        
      --  V_DZ_XXFS_CK  NUMBER(10)  底账_销项份数_出口
      --  V_DZ_XXJE_CK  NUMBER(18,2)  底账_销项金额_出口
      SELECT COUNT(1),NVL(SUM(T.JE),0) 
        INTO V_DZ_XXFS_CK,V_DZ_XXJE_CK
        FROM DZDZ.DZDZ_FPXX_DZFP T 
       WHERE T.KPYF>=CUR_BGQ.YF_Q AND T.KPYF<=CUR_BGQ.YF_Z 
         AND T.XFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
         AND T.FPZT_BZ IN ('0','1')
         AND T.BZ LIKE '出口业务%';
        
      UPDATE TL_TSSH.JKGL_DATA_TJ_ZBU
         SET DZ_XXFS_ZY=V_DZ_XXFS_ZY, 
             DZ_XXJE_ZY=V_DZ_XXJE_ZY, 
             DZ_XXSE_ZY=V_DZ_XXSE_ZY, 
             DZ_XXFS_PT=V_DZ_XXFS_PT, 
             DZ_XXJE_PT=V_DZ_XXJE_PT,
             DZ_XXSE_PT=V_DZ_XXSE_PT,
             DZ_XXFS_QB=V_DZ_XXFS_QB,
             DZ_XXJE_QB=V_DZ_XXJE_QB,
             DZ_XXSE_QB=V_DZ_XXSE_QB,
             DZ_XXFS_CK=V_DZ_XXFS_CK,
             DZ_XXJE_CK=V_DZ_XXJE_CK
       WHERE BGQID=CUR_BGQ.BGQID;
      COMMIT;
        
      --  V_DZ_JXFS_ZY  NUMBER(10)  底账_进项份数_专票
      --  V_DZ_JXJE_ZY  NUMBER(18,2)  底账_进项金额_专票
      --  V_DZ_JXSE_ZY  NUMBER(18,2)  底账_进项税额_专票
      SELECT COUNT(1), NVL(SUM(TT.JE),0), NVL(SUM(TT.SE),0)
        INTO V_DZ_JXFS_ZY, V_DZ_JXJE_ZY, V_DZ_JXSE_ZY
        FROM (SELECT T1.JE, T1.SE
                FROM DZDZ.DZDZ_FPXX_DZZP T1  --电子专票
               WHERE T1.KPYF>=CUR_BGQ.YF_Q AND T1.KPYF<=CUR_BGQ.YF_Z 
                 AND T1.GMFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T1.FPZTBZ IN ('0','1')
               UNION ALL
              SELECT T2.JE, T2.SE
                FROM DZDZ.DZDZ_FPXX_DZZP_YD T2
               WHERE T2.KPYF>=CUR_BGQ.YF_Q AND T2.KPYF<=CUR_BGQ.YF_Z 
                 AND T2.GMFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T2.FPZTBZ IN ('0','1')
               UNION ALL
              SELECT T3.JE, T3.SE
                FROM DZDZ.DZDZ_FPXX_ZZSFP T3 --纸质专票
               WHERE T3.KPYF>=CUR_BGQ.YF_Q AND T3.KPYF<=CUR_BGQ.YF_Z 
                 AND T3.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T3.FPZT_BZ IN ('0','1')
               UNION ALL
              SELECT T4.JE, T4.SE
                FROM DZDZ.DZDZ_FPXX_ZZSFP_YD T4
               WHERE T4.KPYF>=CUR_BGQ.YF_Q AND T4.KPYF<=CUR_BGQ.YF_Z 
                 AND T4.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T4.FPZT_BZ IN ('0','1')
             ) TT;
        
      --  V_DZ_JXFS_PT  NUMBER(10)  底账_进项份数_普票
      --  V_DZ_JXJE_PT  NUMBER(18,2)  底账_进项金额_普票
      --  V_DZ_JXSE_PT  NUMBER(18,2)  底账_进项税额_普票
      SELECT COUNT(1), NVL(SUM(TT.JE),0), NVL(SUM(TT.SE),0)
        INTO V_DZ_JXFS_ZY, V_DZ_JXJE_ZY, V_DZ_JXSE_ZY
        FROM (SELECT T1.JE, T1.SE
                FROM DZDZ.DZDZ_FPXX_DZFP T1  --电子普票
               WHERE T1.KPYF>=CUR_BGQ.YF_Q AND T1.KPYF<=CUR_BGQ.YF_Z 
                 AND T1.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T1.FPZTBZ IN ('0','1')
               UNION ALL
              SELECT T2.JE, T2.SE
                FROM DZDZ.DZDZ_FPXX_DZFP_YD T2
               WHERE T2.KPYF>=CUR_BGQ.YF_Q AND T2.KPYF<=CUR_BGQ.YF_Z 
                 AND T2.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T2.FPZTBZ IN ('0','1')
               UNION ALL
              SELECT T3.JE, T3.SE
                FROM DZDZ.DZDZ_FPXX_PTFP T3 --纸质普票
               WHERE T3.KPYF>=CUR_BGQ.YF_Q AND T3.KPYF<=CUR_BGQ.YF_Z 
                 AND T3.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T3.FPZT_BZ IN ('0','1')
               UNION ALL
              SELECT T4.JE, T4.SE
                FROM DZDZ.DZDZ_FPXX_PTFP_YD T4
               WHERE T4.KPYF>=CUR_BGQ.YF_Q AND T4.KPYF<=CUR_BGQ.YF_Z 
                 AND T4.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T4.FPZT_BZ IN ('0','1')
             ) TT;
        
      --  V_DZ_JXFS_QB  NUMBER(10)  底账_全部进项份数
      --  V_DZ_JXJE_QB  NUMBER(18,2)  底账_全部进项金额
      --  V_DZ_JXSE_QB  NUMBER(18,2)  底账_全部进项税额
      V_DZ_JXFS_QB := V_DZ_JXFS_ZY + V_DZ_JXFS_PT;
      V_DZ_JXJE_QB := V_DZ_JXJE_ZY + V_DZ_JXJE_PT;
      V_DZ_JXSE_QB := V_DZ_JXSE_ZY + V_DZ_JXSE_PT;
        
      --  V_DZ_JXFS_DGKJ  NUMBER(10)  底账_进项份数_专票顶格开具
      --  V_DZ_JXJE_DGKJ  NUMBER(18,2)  底账_进项金额_专票顶格开具
      --  V_DZ_JXSE_DGKJ  NUMBER(18,2)  底账_进项税额_专票顶格开具
      SELECT COUNT(1), NVL(SUM(TT.JE),0), NVL(SUM(TT.SE),0)
        INTO V_DZ_JXFS_DGKJ, V_DZ_JXJE_DGKJ, V_DZ_JXSE_DGKJ
        FROM (SELECT T1.JE, T1.SE
                FROM DZDZ.DZDZ_FPXX_DZZP T1  --电子专票
               WHERE T1.KPYF>=CUR_BGQ.YF_Q AND T1.KPYF<=CUR_BGQ.YF_Z 
                 AND T1.GMFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T1.FPZTBZ IN ('0','1')
                 AND SUBSTR(TO_CHAR(T1.JE),1,1)='9'
               UNION ALL
              SELECT T2.JE, T2.SE
                FROM DZDZ.DZDZ_FPXX_DZZP_YD T2
               WHERE T2.KPYF>=CUR_BGQ.YF_Q AND T2.KPYF<=CUR_BGQ.YF_Z 
                 AND T2.GMFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T2.FPZTBZ IN ('0','1')
                 AND SUBSTR(TO_CHAR(T2.JE),1,1)='9'
               UNION ALL
              SELECT T3.JE, T3.SE
                FROM DZDZ.DZDZ_FPXX_ZZSFP T3 --纸质专票
               WHERE T3.KPYF>=CUR_BGQ.YF_Q AND T3.KPYF<=CUR_BGQ.YF_Z 
                 AND T3.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T3.FPZT_BZ IN ('0','1')
                 AND SUBSTR(TO_CHAR(T3.JE),1,1)='9'
               UNION ALL
              SELECT T4.JE, T4.SE
                FROM DZDZ.DZDZ_FPXX_ZZSFP_YD T4
               WHERE T4.KPYF>=CUR_BGQ.YF_Q AND T4.KPYF<=CUR_BGQ.YF_Z 
                 AND T4.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T4.FPZT_BZ IN ('0','1')
                 AND SUBSTR(TO_CHAR(T4.JE),1,1)='9'
             ) TT;
        
      --  V_DZ_JXSE_JKS NUMBER(18,2)  底账_进项税额_缴款书
      SELECT NVL(SUM(T.SJJE),0)
        INTO V_DZ_JXSE_JKS
        FROM DZDZ.DZDZ_HGWS4 T
       WHERE T.JKDW_SH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO)
         AND T.JSRQ>=CUR_BGQ.BGQ_Q AND T.JSRQ<CUR_BGQ.BGQ_Z+1;
        
      --  V_DZ_JXJE_SN  NUMBER(18,2)  底账_进项金额_省内
      SELECT NVL(SUM(TT.JE),0)
        INTO V_DZ_JXJE_SN
        FROM (SELECT T1.JE
                FROM DZDZ.DZDZ_FPXX_DZZP T1  --电子专票
               WHERE T1.KPYF>=CUR_BGQ.YF_Q AND T1.KPYF<=CUR_BGQ.YF_Z 
                 AND T1.GMFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T1.FPZTBZ IN ('0','1')
               UNION ALL
              SELECT T2.JE
                FROM DZDZ.DZDZ_FPXX_DZFP T2  --电子普票
               WHERE T1.KPYF>=CUR_BGQ.YF_Q AND T1.KPYF<=CUR_BGQ.YF_Z 
                 AND T1.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T1.FPZTBZ IN ('0','1')
               UNION ALL
              SELECT T3.JE
                FROM DZDZ.DZDZ_FPXX_ZZSFP T3 --纸质专票
               WHERE T3.KPYF>=CUR_BGQ.YF_Q AND T3.KPYF<=CUR_BGQ.YF_Z 
                 AND T3.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T3.FPZT_BZ IN ('0','1')
               UNION ALL
              SELECT T4.JE
                FROM DZDZ.DZDZ_FPXX_PTFP T4 --纸质普票
               WHERE T4.KPYF>=CUR_BGQ.YF_Q AND T4.KPYF<=CUR_BGQ.YF_Z 
                 AND T4.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T4.FPZT_BZ IN ('0','1')
             ) TT;
        
      --  V_DZ_JXJE_SW  NUMBER(18,2)  底账_进项金额_省外
      SELECT NVL(SUM(TT.JE),0)
        INTO V_DZ_JXJE_SN
        FROM (SELECT T1.JE
                FROM DZDZ.DZDZ_FPXX_DZZP_YD T1  --电子专票
               WHERE T1.KPYF>=CUR_BGQ.YF_Q AND T1.KPYF<=CUR_BGQ.YF_Z 
                 AND T1.GMFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T1.FPZTBZ IN ('0','1')
               UNION ALL
              SELECT T2.JE
                FROM DZDZ.DZDZ_FPXX_DZFP_YD T2  --电子普票
               WHERE T1.KPYF>=CUR_BGQ.YF_Q AND T1.KPYF<=CUR_BGQ.YF_Z 
                 AND T1.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T1.FPZTBZ IN ('0','1')
               UNION ALL
              SELECT T3.JE
                FROM DZDZ.DZDZ_FPXX_ZZSFP_YD T3 --纸质专票
               WHERE T3.KPYF>=CUR_BGQ.YF_Q AND T3.KPYF<=CUR_BGQ.YF_Z 
                 AND T3.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T3.FPZT_BZ IN ('0','1')
               UNION ALL
              SELECT T4.JE
                FROM DZDZ.DZDZ_FPXX_PTFP_YD T4 --纸质普票
               WHERE T4.KPYF>=CUR_BGQ.YF_Q AND T4.KPYF<=CUR_BGQ.YF_Z 
                 AND T4.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T4.FPZT_BZ IN ('0','1')
             ) TT;
        
      UPDATE TL_TSSH.JKGL_DATA_TJ_ZBU
         SET DZ_JXFS_ZY=V_DZ_JXFS_ZY, 
             DZ_JXJE_ZY=V_DZ_JXJE_ZY, 
             DZ_JXSE_ZY=V_DZ_JXSE_ZY, 
             DZ_JXFS_PT=V_DZ_JXFS_PT, 
             DZ_JXJE_PT=V_DZ_JXJE_PT,
             DZ_JXSE_PT=V_DZ_JXSE_PT,
             DZ_JXFS_QB=V_DZ_JXFS_QB,
             DZ_JXJE_QB=V_DZ_JXJE_QB,
             DZ_JXSE_QB=V_DZ_JXSE_QB,
             DZ_JXFS_DGKJ=V_DZ_JXFS_DGKJ,
             DZ_JXJE_DGKJ=V_DZ_JXJE_DGKJ,
             DZ_JXSE_DGKJ=V_DZ_JXSE_DGKJ,
             DZ_JXSE_JKS=V_DZ_JXSE_JKS,
             DZ_JXJE_SN=V_DZ_JXJE_SN,
             DZ_JXJE_SW=V_DZ_JXJE_SW
       WHERE BGQID=CUR_BGQ.BGQID;
      COMMIT;
    END;
    
    --  V_FP_2             (DZSP_ZT)
    BEGIN
      --  V_DZ_DFJE_SR  NUMBER(18,2)  底账_电费收入（销项）
      SELECT NVL(SUM(TT.JE),0)
        INTO V_DZ_DFJE_SR
        FROM (SELECT S1.JE
                FROM DZDZ.DZDZ_FPXX_DZZP T1  --电子专票
               INNER JOIN DZDZ.DZDZ_HWXX_DZZP S1 ON S1.FPDM=T1.FPDM AND S1.FPHM=T1.FPHM AND S1.KPYF=T1.KPYF
               WHERE T1.KPYF>=CUR_BGQ.YF_Q AND T1.KPYF<=CUR_BGQ.YF_Z 
                 AND T1.XSFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T1.FPZTBZ IN ('0','1')
                 AND S1.SPBM LIKE '110010102%'
               UNION ALL
              SELECT S2.JE
                FROM DZDZ.DZDZ_FPXX_ZZSFP T2 --纸质专票
               INNER JOIN DZDZ.DZDZ_HWXX_ZZSFP S2 ON S2.FPDM=T2.FPDM AND S2.FPHM=T2.FPHM AND S2.KPYF=T2.KPYF
               WHERE T2.KPYF>=CUR_BGQ.YF_Q AND T2.KPYF<=CUR_BGQ.YF_Z 
                 AND T2.XSFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T2.FPZT_BZ IN ('0','1')
                 AND S2.SPBM LIKE '110010102%'
               UNION ALL
              SELECT S3.JE
                FROM DZDZ.DZDZ_FPXX_DZFP T3 --电子普票
               INNER JOIN DZDZ.DZDZ_HWXX_DZFP S3 ON S3.FPDM=T3.FPDM AND S3.FPHM=T3.FPHM AND S3.KPYF=T3.KPYF
               WHERE T3.KPYF>=CUR_BGQ.YF_Q AND T3.KPYF<=CUR_BGQ.YF_Z 
                 AND T3.XFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T3.FPZT_BZ IN ('0','1')
                 AND S3.SPBM LIKE '110010102%'
               UNION ALL
              SELECT S4.JE
                FROM DZDZ.DZDZ_FPXX_PTFP T4 --纸质普票
               INNER JOIN DZDZ.DZDZ_HWXX_PTFP S4 ON S4.FPDM=T4.FPDM AND S4.FPHM=T4.FPHM AND S4.KPYF=T4.KPYF
               WHERE T4.KPYF>=CUR_BGQ.YF_Q AND T4.KPYF<=CUR_BGQ.YF_Z 
                 AND T4.XFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T4.FPZT_BZ IN ('0','1')
                 AND S4.SPBM LIKE '110010102%'
             ) TT;
        
      --  V_DZ_DFJE_ZC  NUMBER(18,2)  底账_电费支出（进项）
      SELECT NVL(SUM(TT.JE),0)
        INTO V_DZ_DFJE_ZC
        FROM (SELECT S1.JE
                FROM DZDZ.DZDZ_FPXX_DZZP T1  --电子专票
               INNER JOIN DZDZ.DZDZ_HWXX_DZZP S1 ON S1.FPDM=T1.FPDM AND S1.FPHM=T1.FPHM AND S1.KPYF=T1.KPYF
               WHERE T1.KPYF>=CUR_BGQ.YF_Q AND T1.KPYF<=CUR_BGQ.YF_Z 
                 AND T1.GMFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T1.FPZTBZ IN ('0','1')
                 AND S1.SPBM LIKE '110010102%'
               UNION ALL
              SELECT S2.JE
                FROM DZDZ.DZDZ_FPXX_DZZP_YD T2
               INNER JOIN DZDZ.DZDZ_HWXX_DZZP_YD S2 ON S2.FPDM=T2.FPDM AND S2.FPHM=T2.FPHM AND S2.KPYF=T2.KPYF
               WHERE T2.KPYF>=CUR_BGQ.YF_Q AND T2.KPYF<=CUR_BGQ.YF_Z 
                 AND T2.GMFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T2.FPZTBZ IN ('0','1')
                 AND S2.SPBM LIKE '110010102%'
               UNION ALL
              SELECT S3.JE
                FROM DZDZ.DZDZ_FPXX_ZZSFP T3 --纸质专票
               INNER JOIN DZDZ.DZDZ_HWXX_ZZSFP S3 ON S3.FPDM=T3.FPDM AND S3.FPHM=T3.FPHM AND S3.KPYF=T3.KPYF
               WHERE T3.KPYF>=CUR_BGQ.YF_Q AND T3.KPYF<=CUR_BGQ.YF_Z 
                 AND T3.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T3.FPZT_BZ IN ('0','1')
                 AND S3.SPBM LIKE '110010102%'
               UNION ALL
              SELECT S4.JE
                FROM DZDZ.DZDZ_FPXX_ZZSFP_YD T4
               INNER JOIN DZDZ.DZDZ_HWXX_ZZSFP_YD S4 ON S4.FPDM=T4.FPDM AND S4.FPHM=T4.FPHM AND S4.KPYF=T4.KPYF
               WHERE T4.KPYF>=CUR_BGQ.YF_Q AND T4.KPYF<=CUR_BGQ.YF_Z 
                 AND T4.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T4.FPZT_BZ IN ('0','1')
                 AND S4.SPBM LIKE '110010102%'
               UNION ALL
              SELECT S5.JE
                FROM DZDZ.DZDZ_FPXX_DZFP T5 --电子普票
               INNER JOIN DZDZ.DZDZ_HWXX_DZFP S5 ON S5.FPDM=T5.FPDM AND S5.FPHM=T5.FPHM AND S5.KPYF=T5.KPYF
               WHERE T5.KPYF>=CUR_BGQ.YF_Q AND T5.KPYF<=CUR_BGQ.YF_Z 
                 AND T5.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T5.FPZT_BZ IN ('0','1')
                 AND S5.SPBM LIKE '110010102%'
               UNION ALL
              SELECT S6.JE
                FROM DZDZ.DZDZ_FPXX_DZFP_YD T6
               INNER JOIN DZDZ.DZDZ_HWXX_DZFP_YD S6 ON S6.FPDM=T6.FPDM AND S6.FPHM=T6.FPHM AND S6.KPYF=T6.KPYF
               WHERE T6.KPYF>=CUR_BGQ.YF_Q AND T6.KPYF<=CUR_BGQ.YF_Z 
                 AND T6.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T6.FPZT_BZ IN ('0','1')
                 AND S6.SPBM LIKE '110010102%'
               UNION ALL
              SELECT S7.JE
                FROM DZDZ.DZDZ_FPXX_PTFP T7 --纸质普票
               INNER JOIN DZDZ.DZDZ_HWXX_PTFP S7 ON S7.FPDM=T7.FPDM AND S7.FPHM=T7.FPHM AND S7.KPYF=T7.KPYF
               WHERE T7.KPYF>=CUR_BGQ.YF_Q AND T7.KPYF<=CUR_BGQ.YF_Z 
                 AND T7.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T7.FPZT_BZ IN ('0','1')
                 AND S7.SPBM LIKE '110010102%'
               UNION ALL
              SELECT S8.JE
                FROM DZDZ.DZDZ_FPXX_PTFP_YD T8
               INNER JOIN DZDZ.DZDZ_HWXX_PTFP_YD S8 ON S8.FPDM=T8.FPDM AND S8.FPHM=T8.FPHM AND S8.KPYF=T8.KPYF
               WHERE T8.KPYF>=CUR_BGQ.YF_Q AND T8.KPYF<=CUR_BGQ.YF_Z 
                 AND T8.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T8.FPZT_BZ IN ('0','1')
                 AND S8.SPBM LIKE '110010102%'
             ) TT;
        
      --  V_DZ_WTJG NUMBER(18,2)  底账_委托加工费支出
      SELECT NVL(SUM(TT.JE),0)
        INTO V_DZ_JXSE_NCP
        FROM (SELECT S1.JE
                FROM DZDZ.DZDZ_FPXX_DZZP T1  --电子专票
               INNER JOIN DZDZ.DZDZ_HWXX_DZZP S1 ON S1.FPDM=T1.FPDM AND S1.FPHM=T1.FPHM AND S1.KPYF=T1.KPYF
               WHERE T1.KPYF>=CUR_BGQ.YF_Q AND T1.KPYF<=CUR_BGQ.YF_Z 
                 AND T1.GMFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T1.FPZTBZ IN ('0','1')
                 AND S1.SPBM LIKE '201%'
               UNION ALL
              SELECT S2.JE
                FROM DZDZ.DZDZ_FPXX_DZZP_YD T2
               INNER JOIN DZDZ.DZDZ_HWXX_DZZP_YD S2 ON S2.FPDM=T2.FPDM AND S2.FPHM=T2.FPHM AND S2.KPYF=T2.KPYF
               WHERE T2.KPYF>=CUR_BGQ.YF_Q AND T2.KPYF<=CUR_BGQ.YF_Z 
                 AND T2.GMFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T2.FPZTBZ IN ('0','1')
                 AND S2.SPBM LIKE '201%'
               UNION ALL
              SELECT S3.JE
                FROM DZDZ.DZDZ_FPXX_ZZSFP T3 --纸质专票
               INNER JOIN DZDZ.DZDZ_HWXX_ZZSFP S3 ON S3.FPDM=T3.FPDM AND S3.FPHM=T3.FPHM AND S3.KPYF=T3.KPYF
               WHERE T3.KPYF>=CUR_BGQ.YF_Q AND T3.KPYF<=CUR_BGQ.YF_Z 
                 AND T3.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T3.FPZT_BZ IN ('0','1')
                 AND S3.SPBM LIKE '201%'
               UNION ALL
              SELECT S4.JE
                FROM DZDZ.DZDZ_FPXX_ZZSFP_YD T4
               INNER JOIN DZDZ.DZDZ_HWXX_ZZSFP_YD S4 ON S4.FPDM=T4.FPDM AND S4.FPHM=T4.FPHM AND S4.KPYF=T4.KPYF
               WHERE T4.KPYF>=CUR_BGQ.YF_Q AND T4.KPYF<=CUR_BGQ.YF_Z 
                 AND T4.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T4.FPZT_BZ IN ('0','1')
                 AND S4.SPBM LIKE '201%'
               UNION ALL
              SELECT S5.JE
                FROM DZDZ.DZDZ_FPXX_DZFP T5 --电子普票
               INNER JOIN DZDZ.DZDZ_HWXX_DZFP S5 ON S5.FPDM=T5.FPDM AND S5.FPHM=T5.FPHM AND S5.KPYF=T5.KPYF
               WHERE T5.KPYF>=CUR_BGQ.YF_Q AND T5.KPYF<=CUR_BGQ.YF_Z 
                 AND T5.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T5.FPZT_BZ IN ('0','1')
                 AND S5.SPBM LIKE '201%'
               UNION ALL
              SELECT S6.JE
                FROM DZDZ.DZDZ_FPXX_DZFP_YD T6
               INNER JOIN DZDZ.DZDZ_HWXX_DZFP_YD S6 ON S6.FPDM=T6.FPDM AND S6.FPHM=T6.FPHM AND S6.KPYF=T6.KPYF
               WHERE T6.KPYF>=CUR_BGQ.YF_Q AND T6.KPYF<=CUR_BGQ.YF_Z 
                 AND T6.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T6.FPZT_BZ IN ('0','1')
                 AND S6.SPBM LIKE '201%'
               UNION ALL
              SELECT S7.JE
                FROM DZDZ.DZDZ_FPXX_PTFP T7 --纸质普票
               INNER JOIN DZDZ.DZDZ_HWXX_PTFP S7 ON S7.FPDM=T7.FPDM AND S7.FPHM=T7.FPHM AND S7.KPYF=T7.KPYF
               WHERE T7.KPYF>=CUR_BGQ.YF_Q AND T7.KPYF<=CUR_BGQ.YF_Z 
                 AND T7.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T7.FPZT_BZ IN ('0','1')
                 AND S7.SPBM LIKE '201%'
               UNION ALL
              SELECT S8.JE
                FROM DZDZ.DZDZ_FPXX_PTFP_YD T8
               INNER JOIN DZDZ.DZDZ_HWXX_PTFP_YD S8 ON S8.FPDM=T8.FPDM AND S8.FPHM=T8.FPHM AND S8.KPYF=T8.KPYF
               WHERE T8.KPYF>=CUR_BGQ.YF_Q AND T8.KPYF<=CUR_BGQ.YF_Z 
                 AND T8.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T8.FPZT_BZ IN ('0','1')
                 AND S8.SPBM LIKE '201%'
             ) TT;
        
      --  V_DZ_YFJE NUMBER(18,2)  底账_运费支出
      SELECT NVL(SUM(TT.JE),0)
        INTO V_DZ_YFJE
        FROM (SELECT S1.JE
                FROM DZDZ.DZDZ_FPXX_DZZP T1  --电子专票
               INNER JOIN DZDZ.DZDZ_HWXX_DZZP S1 ON S1.FPDM=T1.FPDM AND S1.FPHM=T1.FPHM AND S1.KPYF=T1.KPYF
               WHERE T1.KPYF>=CUR_BGQ.YF_Q AND T1.KPYF<=CUR_BGQ.YF_Z 
                 AND T1.GMFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T1.FPZTBZ IN ('0','1')
                 AND (S1.SPBM LIKE '301%' OR S1.SPBM LIKE '304080201%')
               UNION ALL
              SELECT S2.JE
                FROM DZDZ.DZDZ_FPXX_DZZP_YD T2
               INNER JOIN DZDZ.DZDZ_HWXX_DZZP_YD S2 ON S2.FPDM=T2.FPDM AND S2.FPHM=T2.FPHM AND S2.KPYF=T2.KPYF
               WHERE T2.KPYF>=CUR_BGQ.YF_Q AND T2.KPYF<=CUR_BGQ.YF_Z 
                 AND T2.GMFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T2.FPZTBZ IN ('0','1')
                 AND (S2.SPBM LIKE '301%' OR S2.SPBM LIKE '304080201%')
               UNION ALL
              SELECT S3.JE
                FROM DZDZ.DZDZ_FPXX_ZZSFP T3 --纸质专票
               INNER JOIN DZDZ.DZDZ_HWXX_ZZSFP S3 ON S3.FPDM=T3.FPDM AND S3.FPHM=T3.FPHM AND S3.KPYF=T3.KPYF
               WHERE T3.KPYF>=CUR_BGQ.YF_Q AND T3.KPYF<=CUR_BGQ.YF_Z 
                 AND T3.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T3.FPZT_BZ IN ('0','1')
                 AND (S3.SPBM LIKE '301%' OR S3.SPBM LIKE '304080201%')
               UNION ALL
              SELECT S4.JE
                FROM DZDZ.DZDZ_FPXX_ZZSFP_YD T4
               INNER JOIN DZDZ.DZDZ_HWXX_ZZSFP_YD S4 ON S4.FPDM=T4.FPDM AND S4.FPHM=T4.FPHM AND S4.KPYF=T4.KPYF
               WHERE T4.KPYF>=CUR_BGQ.YF_Q AND T4.KPYF<=CUR_BGQ.YF_Z 
                 AND T4.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T4.FPZT_BZ IN ('0','1')
                 AND (S4.SPBM LIKE '301%' OR S4.SPBM LIKE '304080201%')
               UNION ALL
              SELECT S5.JE
                FROM DZDZ.DZDZ_FPXX_DZFP T5 --电子普票
               INNER JOIN DZDZ.DZDZ_HWXX_DZFP S5 ON S5.FPDM=T5.FPDM AND S5.FPHM=T5.FPHM AND S5.KPYF=T5.KPYF
               WHERE T5.KPYF>=CUR_BGQ.YF_Q AND T5.KPYF<=CUR_BGQ.YF_Z 
                 AND T5.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T5.FPZT_BZ IN ('0','1')
                 AND (S5.SPBM LIKE '301%' OR S5.SPBM LIKE '304080201%')
               UNION ALL
              SELECT S6.JE
                FROM DZDZ.DZDZ_FPXX_DZFP_YD T6
               INNER JOIN DZDZ.DZDZ_HWXX_DZFP_YD S6 ON S6.FPDM=T6.FPDM AND S6.FPHM=T6.FPHM AND S6.KPYF=T6.KPYF
               WHERE T6.KPYF>=CUR_BGQ.YF_Q AND T6.KPYF<=CUR_BGQ.YF_Z 
                 AND T6.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T6.FPZT_BZ IN ('0','1')
                 AND (S6.SPBM LIKE '301%' OR S6.SPBM LIKE '304080201%')
               UNION ALL
              SELECT S7.JE
                FROM DZDZ.DZDZ_FPXX_PTFP T7 --纸质普票
               INNER JOIN DZDZ.DZDZ_HWXX_PTFP S7 ON S7.FPDM=T7.FPDM AND S7.FPHM=T7.FPHM AND S7.KPYF=T7.KPYF
               WHERE T7.KPYF>=CUR_BGQ.YF_Q AND T7.KPYF<=CUR_BGQ.YF_Z 
                 AND T7.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T7.FPZT_BZ IN ('0','1')
                 AND (S7.SPBM LIKE '301%' OR S7.SPBM LIKE '304080201%')
               UNION ALL
              SELECT S8.JE
                FROM DZDZ.DZDZ_FPXX_PTFP_YD T8
               INNER JOIN DZDZ.DZDZ_HWXX_PTFP_YD S8 ON S8.FPDM=T8.FPDM AND S8.FPHM=T8.FPHM AND S8.KPYF=T8.KPYF
               WHERE T8.KPYF>=CUR_BGQ.YF_Q AND T8.KPYF<=CUR_BGQ.YF_Z 
                 AND T8.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                 AND T8.FPZT_BZ IN ('0','1')
                 AND (S8.SPBM LIKE '301%' OR S8.SPBM LIKE '304080201%')
             ) TT;
        
      UPDATE TL_TSSH.JKGL_DATA_TJ_ZBU
         SET DZ_DFJE_SR=V_DZ_DFJE_SR,
             DZ_DFJE_ZC=V_DZ_DFJE_ZC,
             DZ_WTJG=V_DZ_WTJG,
             DZ_YFJE=V_DZ_YFJE
       WHERE BGQID=CUR_BGQ.BGQID;
      COMMIT;
    END;
    
    --  V_ZC_
    BEGIN
      IF EXTRACT(MONTH FROM CUR_BGQ.BGQ_Q) IN (1,4,7,10) AND EXTRACT(MONTH FROM CUR_BGQ.BGQ_Z) IN (3,6,9,12) THEN
        --  V_ZC_YSZK_QC    资产_应收账款_期初
        --  V_ZC_YUFZK_QC   资产_预付账款_期初
        --  V_ZC_CH_QC      资产_存货_期初
        --  V_ZC_LDZC_QC    资产_流动资产_期初
        --  V_ZC_GDZC_QC    资产_固定资产_期初
        --  V_ZC_ZCZE_QC    资产_资产总额_期初
        --  V_ZC_YFZK_QC    资产_应付账款_期初
        --  V_ZC_YUSZK_QC   资产_预收账款_期初
        --  V_ZC_LDFZZE_QC  资产_流动负债总额_期初
        --  V_ZC_FZZE_QC    资产_负债总额_期初
        --  V_ZC_SYZQY_QC   资产_所有者权益_期初
        SELECT NVL(SUM(ZC_YSZK),0), NVL(SUM(ZC_YUFZK),0), NVL(SUM(ZC_CH),0), NVL(SUM(ZC_LDZC),0), 
               NVL(SUM(ZC_GDZC),0), NVL(SUM(ZC_ZCZE),0), NVL(SUM(ZC_YFZK),0), NVL(SUM(ZC_YUSZK),0), 
               NVL(SUM(ZC_LDFZZE),0), NVL(SUM(ZC_FZZE),0), NVL(SUM(ZC_SYZQY),0)
          INTO V_ZC_YSZK_QC, V_ZC_YUFZK_QC, V_ZC_CH_QC, V_ZC_LDZC_QC, V_ZC_GDZC_QC, V_ZC_ZCZE_QC,
               V_ZC_YFZK_QC, V_ZC_YUSZK_QC, V_ZC_LDFZZE_QC, V_ZC_FZZE_QC, V_ZC_SYZQY_QC
          FROM (SELECT DECODE(B.EWBHXH,4,B.QMYE_ZC,0) AS ZC_YSZK, 
                       DECODE(B.EWBHXH,5,B.QMYE_ZC,0) AS ZC_YUFZK, 
                       DECODE(B.EWBHXH,9,B.QMYE_ZC,0) AS ZC_CH, 
                       DECODE(B.EWBHXH,12,B.QMYE_ZC,0) AS ZC_LDZC, 
                       DECODE(B.EWBHXH,19,B.QMYE_ZC,0) AS ZC_GDZC, 
                       DECODE(B.EWBHXH,32,B.QMYE_ZC,0) AS ZC_ZCZE, 
                       DECODE(B.EWBHXH,4,B.QMYE_QY,0) AS ZC_YFZK, 
                       DECODE(B.EWBHXH,5,B.QMYE_QY,0) AS ZC_YUSZK, 
                       DECODE(B.EWBHXH,13,B.QMYE_QY,0) AS ZC_LDFZZE,
                       DECODE(B.EWBHXH,23,B.QMYE_QY,0) AS ZC_FZZE, 
                       DECODE(B.EWBHXH,30,B.QMYE_QY,0) AS ZC_SYZQY 
                  FROM HX_SB.SB_ZLBSCJB A
                 INNER JOIN HX_SB.SB_CWBB_QYKJZZYBQY_ZCFZB B ON B.ZLBSCJUUID=A.ZLBSCJUUID
                 WHERE A.DJXH=CUR_BGQ.DJXH 
                   AND A.SSQQ>=ADD_MONTHS(CUR_BGQ.BGQ_Q,-3) AND A.SSQZ=CUR_BGQ.BGQ_Q-1
                   AND A.ZFBZ_1 IS NULL
                 UNION ALL
                SELECT DECODE(B.EWBHXH,6,B.QMS_ZC,0) AS ZC_YSZK, 
                       DECODE(B.EWBHXH,8,B.QMS_ZC,0) AS ZC_YUFZK, 
                       DECODE(B.EWBHXH,10,B.QMS_ZC,0) AS ZC_CH, 
                       DECODE(B.EWBHXH,14,B.QMS_ZC,0) AS ZC_LDZC, 
                       DECODE(B.EWBHXH,27,B.QMS_ZC,0) AS ZC_GDZC, 
                       DECODE(B.EWBHXH,36,B.QMS_ZC,0) AS ZC_ZCZE, 
                       DECODE(B.EWBHXH,3,B.QMS_QY,0) AS ZC_YFZK, 
                       DECODE(B.EWBHXH,4,B.QMS_QY,0) AS ZC_YUSZK, 
                       DECODE(B.EWBHXH,15,B.QMS_QY,0) AS ZC_LDFZZE,
                       DECODE(B.EWBHXH,25,B.QMS_QY,0) AS ZC_FZZE, 
                       DECODE(B.EWBHXH,35,B.QMS_QY,0) AS ZC_SYZQY 
                  FROM HX_SB.SB_ZLBSCJB A
                 INNER JOIN HX_SB.SB_CWBB_QYKJZZ_ZCFZB B ON B.ZLBSCJUUID=A.ZLBSCJUUID
                 WHERE A.DJXH=CUR_BGQ.DJXH 
                   AND A.SSQQ>=ADD_MONTHS(CUR_BGQ.BGQ_Q,-3) AND A.SSQZ=CUR_BGQ.BGQ_Q-1
                   AND A.ZFBZ_1 IS NULL
                 UNION ALL
                SELECT DECODE(B.EWBHXH,4,B.QMYE_ZC,0) AS ZC_YSZK, 
                       DECODE(B.EWBHXH,5,B.QMYE_ZC,0) AS ZC_YUFZK, 
                       DECODE(B.EWBHXH,9,B.QMYE_ZC,0) AS ZC_CH, 
                       DECODE(B.EWBHXH,15,B.QMYE_ZC,0) AS ZC_LDZC, 
                       DECODE(B.EWBHXH,21,B.QMYE_ZC,0) AS ZC_GDZC, 
                       DECODE(B.EWBHXH,31,B.QMYE_ZC,0) AS ZC_ZCZE, 
                       DECODE(B.EWBHXH,3,B.QMYE_QY,0) AS ZC_YFZK, 
                       DECODE(B.EWBHXH,4,B.QMYE_QY,0) AS ZC_YUSZK, 
                       DECODE(B.EWBHXH,11,B.QMYE_QY,0) AS ZC_LDFZZE,
                       DECODE(B.EWBHXH,18,B.QMYE_QY,0) AS ZC_FZZE, 
                       DECODE(B.EWBHXH,30,B.QMYE_QY,0) AS ZC_SYZQY 
                  FROM HX_SB.SB_ZLBSCJB A
                 INNER JOIN HX_SB.SB_CWBB_XQYKJZZ_ZCFZB B ON B.ZLBSCJUUID=A.ZLBSCJUUID
                 WHERE A.DJXH=CUR_BGQ.DJXH 
                   AND A.SSQQ>=ADD_MONTHS(CUR_BGQ.BGQ_Q,-3) AND A.SSQZ=CUR_BGQ.BGQ_Q-1
                   AND A.ZFBZ_1 IS NULL
                 UNION ALL
                SELECT DECODE(B.EWBHXH,5,B.QMYE_ZC,0) AS ZC_YSZK, 
                       DECODE(B.EWBHXH,7,B.QMYE_ZC,0) AS ZC_YUFZK, 
                       DECODE(B.EWBHXH,9,B.QMYE_ZC,0) AS ZC_CH, 
                       DECODE(B.EWBHXH,14,B.QMYE_ZC,0) AS ZC_LDZC, 
                       DECODE(B.EWBHXH,22,B.QMYE_ZC,0) AS ZC_GDZC, 
                       DECODE(B.EWBHXH,34,B.QMYE_ZC,0) AS ZC_ZCZE, 
                       DECODE(B.EWBHXH,5,B.QMYE_QY,0) AS ZC_YFZK, 
                       DECODE(B.EWBHXH,6,B.QMYE_QY,0) AS ZC_YUSZK, 
                       DECODE(B.EWBHXH,14,B.QMYE_QY,0) AS ZC_LDFZZE,
                       DECODE(B.EWBHXH,26,B.QMYE_QY,0) AS ZC_FZZE, 
                       DECODE(B.EWBHXH,38,B.QMYE_QY,0) AS ZC_SYZQY 
                  FROM HX_SB.SB_ZLBSCJB A
                 INNER JOIN HX_SB.SB_CWBB_QYKJZZYBQY_ZCFZBZX B ON B.ZLBSCJUUID=A.ZLBSCJUUID
                 WHERE A.DJXH=CUR_BGQ.DJXH 
                   AND A.SSQQ>=ADD_MONTHS(CUR_BGQ.BGQ_Q,-3) AND A.SSQZ=CUR_BGQ.BGQ_Q-1
                   AND A.ZFBZ_1 IS NULL
               ) T;
        
        UPDATE TL_TSSH.JKGL_DATA_TJ_ZBU
           SET ZC_YSZK_QC=V_ZC_YSZK_QC,
               ZC_YUFZK_QC=V_ZC_YUFZK_QC,
               ZC_CH_QC=V_ZC_CH_QC, 
               ZC_LDZC_QC=V_ZC_LDZC_QC, 
               ZC_GDZC_QC=V_ZC_GDZC_QC, 
               ZC_ZCZE_QC=V_ZC_ZCZE_QC,
               ZC_YFZK_QC=V_ZC_YFZK_QC, 
               ZC_YUSZK_QC=V_ZC_YUSZK_QC, 
               ZC_LDFZZE_QC=V_ZC_LDFZZE_QC, 
               ZC_FZZE_QC=V_ZC_FZZE_QC, 
               ZC_SYZQY_QC=V_ZC_SYZQY_QC,
               ZC_SSGDQY_QC=0
         WHERE BGQID=CUR_BGQ.BGQID;
        COMMIT;
          
        --  V_ZC_YSZK_QM    资产_应收账款_期末
        --  V_ZC_YUFZK_QM   资产_预付账款_期末
        --  V_ZC_CH_QM      资产_存货_期末
        --  V_ZC_LDZC_QM    资产_流动资产_期末
        --  V_ZC_GDZC_QM    资产_固定资产_期末
        --  V_ZC_ZCZE_QM    资产_资产总额_期末
        --  V_ZC_YFZK_QM    资产_应付账款_期末
        --  V_ZC_YUSZK_QM   资产_预收账款_期末
        --  V_ZC_LDFZZE_QM  资产_流动负债总额_期末
        --  V_ZC_FZZE_QM    资产_负债总额_期末
        --  V_ZC_SYZQY_QM   资产_所有者权益_期末
        SELECT NVL(SUM(ZC_YSZK),0), NVL(SUM(ZC_YUFZK),0), NVL(SUM(ZC_CH),0), NVL(SUM(ZC_LDZC),0), 
               NVL(SUM(ZC_GDZC),0), NVL(SUM(ZC_ZCZE),0), NVL(SUM(ZC_YFZK),0), NVL(SUM(ZC_YUSZK),0), 
               NVL(SUM(ZC_LDFZZE),0), NVL(SUM(ZC_FZZE),0), NVL(SUM(ZC_SYZQY),0)
          INTO V_ZC_YSZK_QM, V_ZC_YUFZK_QM, V_ZC_CH_QM, V_ZC_LDZC_QM, V_ZC_GDZC_QM, V_ZC_ZCZE_QM,
               V_ZC_YFZK_QM, V_ZC_YUSZK_QM, V_ZC_LDFZZE_QM, V_ZC_FZZE_QM, V_ZC_SYZQY_QM
          FROM (SELECT DECODE(B.EWBHXH,4,B.QMYE_ZC,0) AS ZC_YSZK, 
                       DECODE(B.EWBHXH,5,B.QMYE_ZC,0) AS ZC_YUFZK, 
                       DECODE(B.EWBHXH,9,B.QMYE_ZC,0) AS ZC_CH, 
                       DECODE(B.EWBHXH,12,B.QMYE_ZC,0) AS ZC_LDZC, 
                       DECODE(B.EWBHXH,19,B.QMYE_ZC,0) AS ZC_GDZC, 
                       DECODE(B.EWBHXH,32,B.QMYE_ZC,0) AS ZC_ZCZE, 
                       DECODE(B.EWBHXH,4,B.QMYE_QY,0) AS ZC_YFZK, 
                       DECODE(B.EWBHXH,5,B.QMYE_QY,0) AS ZC_YUSZK, 
                       DECODE(B.EWBHXH,13,B.QMYE_QY,0) AS ZC_LDFZZE,
                       DECODE(B.EWBHXH,23,B.QMYE_QY,0) AS ZC_FZZE, 
                       DECODE(B.EWBHXH,30,B.QMYE_QY,0) AS ZC_SYZQY 
                  FROM HX_SB.SB_ZLBSCJB A
                 INNER JOIN HX_SB.SB_CWBB_QYKJZZYBQY_ZCFZB B ON B.ZLBSCJUUID=A.ZLBSCJUUID
                 WHERE A.DJXH=CUR_BGQ.DJXH 
                   AND A.SSQQ>=TRUNC(ADD_MONTHS(CUR_BGQ.BGQ_Z,-2),'MM') AND A.SSQZ=CUR_BGQ.BGQ_Z
                   AND A.ZFBZ_1 IS NULL
                 UNION ALL
                SELECT DECODE(B.EWBHXH,6,B.QMS_ZC,0) AS ZC_YSZK, 
                       DECODE(B.EWBHXH,8,B.QMS_ZC,0) AS ZC_YUFZK, 
                       DECODE(B.EWBHXH,10,B.QMS_ZC,0) AS ZC_CH, 
                       DECODE(B.EWBHXH,14,B.QMS_ZC,0) AS ZC_LDZC, 
                       DECODE(B.EWBHXH,27,B.QMS_ZC,0) AS ZC_GDZC, 
                       DECODE(B.EWBHXH,36,B.QMS_ZC,0) AS ZC_ZCZE, 
                       DECODE(B.EWBHXH,3,B.QMS_QY,0) AS ZC_YFZK, 
                       DECODE(B.EWBHXH,4,B.QMS_QY,0) AS ZC_YUSZK, 
                       DECODE(B.EWBHXH,15,B.QMS_QY,0) AS ZC_LDFZZE,
                       DECODE(B.EWBHXH,25,B.QMS_QY,0) AS ZC_FZZE, 
                       DECODE(B.EWBHXH,35,B.QMS_QY,0) AS ZC_SYZQY 
                  FROM HX_SB.SB_ZLBSCJB A
                 INNER JOIN HX_SB.SB_CWBB_QYKJZZ_ZCFZB B ON B.ZLBSCJUUID=A.ZLBSCJUUID
                 WHERE A.DJXH=CUR_BGQ.DJXH 
                   AND A.SSQQ>=TRUNC(ADD_MONTHS(CUR_BGQ.BGQ_Z,-3),'MM') AND A.SSQZ=CUR_BGQ.BGQ_Z
                   AND A.ZFBZ_1 IS NULL
                 UNION ALL
                SELECT DECODE(B.EWBHXH,4,B.QMYE_ZC,0) AS ZC_YSZK, 
                       DECODE(B.EWBHXH,5,B.QMYE_ZC,0) AS ZC_YUFZK, 
                       DECODE(B.EWBHXH,9,B.QMYE_ZC,0) AS ZC_CH, 
                       DECODE(B.EWBHXH,15,B.QMYE_ZC,0) AS ZC_LDZC, 
                       DECODE(B.EWBHXH,21,B.QMYE_ZC,0) AS ZC_GDZC, 
                       DECODE(B.EWBHXH,31,B.QMYE_ZC,0) AS ZC_ZCZE, 
                       DECODE(B.EWBHXH,3,B.QMYE_QY,0) AS ZC_YFZK, 
                       DECODE(B.EWBHXH,4,B.QMYE_QY,0) AS ZC_YUSZK, 
                       DECODE(B.EWBHXH,11,B.QMYE_QY,0) AS ZC_LDFZZE,
                       DECODE(B.EWBHXH,18,B.QMYE_QY,0) AS ZC_FZZE, 
                       DECODE(B.EWBHXH,30,B.QMYE_QY,0) AS ZC_SYZQY 
                  FROM HX_SB.SB_ZLBSCJB A
                 INNER JOIN HX_SB.SB_CWBB_XQYKJZZ_ZCFZB B ON B.ZLBSCJUUID=A.ZLBSCJUUID
                 WHERE A.DJXH=CUR_BGQ.DJXH 
                   AND A.SSQQ>=TRUNC(ADD_MONTHS(CUR_BGQ.BGQ_Z,-3),'MM') AND A.SSQZ=CUR_BGQ.BGQ_Z
                   AND A.ZFBZ_1 IS NULL
                 UNION ALL
                SELECT DECODE(B.EWBHXH,5,B.QMYE_ZC,0) AS ZC_YSZK, 
                       DECODE(B.EWBHXH,7,B.QMYE_ZC,0) AS ZC_YUFZK, 
                       DECODE(B.EWBHXH,9,B.QMYE_ZC,0) AS ZC_CH, 
                       DECODE(B.EWBHXH,14,B.QMYE_ZC,0) AS ZC_LDZC, 
                       DECODE(B.EWBHXH,22,B.QMYE_ZC,0) AS ZC_GDZC, 
                       DECODE(B.EWBHXH,34,B.QMYE_ZC,0) AS ZC_ZCZE, 
                       DECODE(B.EWBHXH,5,B.QMYE_QY,0) AS ZC_YFZK, 
                       DECODE(B.EWBHXH,6,B.QMYE_QY,0) AS ZC_YUSZK, 
                       DECODE(B.EWBHXH,14,B.QMYE_QY,0) AS ZC_LDFZZE,
                       DECODE(B.EWBHXH,26,B.QMYE_QY,0) AS ZC_FZZE, 
                       DECODE(B.EWBHXH,38,B.QMYE_QY,0) AS ZC_SYZQY 
                  FROM HX_SB.SB_ZLBSCJB A
                 INNER JOIN HX_SB.SB_CWBB_QYKJZZYBQY_ZCFZBZX B ON B.ZLBSCJUUID=A.ZLBSCJUUID
                 WHERE A.DJXH=CUR_BGQ.DJXH 
                   AND A.SSQQ>=TRUNC(ADD_MONTHS(CUR_BGQ.BGQ_Z,-3),'MM') AND A.SSQZ=CUR_BGQ.BGQ_Z
                   AND A.ZFBZ_1 IS NULL
               ) T;
        
        UPDATE TL_TSSH.JKGL_DATA_TJ_ZBU
           SET ZC_YSZK_QM=V_ZC_YSZK_QM,
               ZC_YUFZK_QM=V_ZC_YUFZK_QM,
               ZC_CH_QM=V_ZC_CH_QM, 
               ZC_LDZC_QM=V_ZC_LDZC_QM, 
               ZC_GDZC_QM=V_ZC_GDZC_QM, 
               ZC_ZCZE_QM=V_ZC_ZCZE_QM,
               ZC_YFZK_QM=V_ZC_YFZK_QM, 
               ZC_YUSZK_QM=V_ZC_YUSZK_QM, 
               ZC_LDFZZE_QM=V_ZC_LDFZZE_QM, 
               ZC_FZZE_QM=V_ZC_FZZE_QM, 
               ZC_SYZQY_QM=V_ZC_SYZQY_QM,
               ZC_SSGDQY_QM=0
         WHERE BGQID=CUR_BGQ.BGQID;
        COMMIT;
      END IF;  
    END;
    
    --  V_LR_
    BEGIN
      IF EXTRACT(MONTH FROM CUR_BGQ.BGQ_Q) IN (1,4,7,10) AND EXTRACT(MONTH FROM CUR_BGQ.BGQ_Z) IN (3,6,9,12) THEN
        --  V_LR_YYSR NUMBER(18,2)  利润_营业收入
        --  V_LR_YYCB NUMBER(18,2)  利润_营业成本
        --  V_LR_SJJFJ  NUMBER(18,2)  利润_税金及附加
        --  V_LR_XSFY NUMBER(18,2)  利润_销售费用
        --  V_LR_GLFY NUMBER(18,2)  利润_管理费用
        --  V_LR_CWFY NUMBER(18,2)  利润_财务费用
        --  V_LR_LXZC NUMBER(18,2)  利润_利息支出
        --  V_LR_YYLR NUMBER(18,2)  利润_营业利润
        --  V_LR_QTSR NUMBER(18,2)  利润_其它收入
        --  V_LR_LRZE NUMBER(18,2)  利润_利润总额
        --  V_LR_SDS  NUMBER(18,2)  利润_所得税
        --  V_LR_JLR  NUMBER(18,2)  利润_净利润
        SELECT NVL(SUM(LR_YYSR),0), NVL(SUM(LR_YYCB),0), NVL(SUM(LR_SJJFJ),0), NVL(SUM(LR_XSFY),0), 
               NVL(SUM(LR_GLFY),0), NVL(SUM(LR_CWFY),0), NVL(SUM(LR_LXZC),0), NVL(SUM(LR_YYLR),0),
               NVL(SUM(LR_QTSR),0), NVL(SUM(LR_LRZE),0), NVL(SUM(LR_SDS),0), NVL(SUM(LR_JLR),0)
          INTO V_LR_YYSR, V_LR_YYCB, V_LR_SJJFJ, V_LR_XSFY, V_LR_GLFY, V_LR_CWFY, 
               V_LR_LXZC, V_LR_YYLR, V_LR_QTSR, V_LR_LRZE, V_LR_SDS, V_LR_JLR
          FROM (-- +期末数
                SELECT DECODE(B.EWBHXH,1, B.BNLJS,0) AS LR_YYSR, 
                       DECODE(B.EWBHXH,2, B.BNLJS,0) AS LR_YYCB, 
                       DECODE(B.EWBHXH,3, B.BNLJS,0) AS LR_SJJFJ, 
                       DECODE(B.EWBHXH,6, B.BNLJS,0) AS LR_XSFY, 
                       DECODE(B.EWBHXH,7, B.BNLJS,0) AS LR_GLFY, 
                       DECODE(B.EWBHXH,8, B.BNLJS,0) AS LR_CWFY, 
                       0 AS LR_LXZC,
                       DECODE(B.EWBHXH,9, B.BNLJS,0) AS LR_YYLR, 
                       DECODE(B.EWBHXH,12, B.BNLJS,0) AS LR_QTSR, 
                       DECODE(B.EWBHXH,14, B.BNLJS,0) AS LR_LRZE, 
                       DECODE(B.EWBHXH,15, B.BNLJS,0) AS LR_SDS, 
                       DECODE(B.EWBHXH,16, B.BNLJS,0) AS LR_JLR 
                  FROM HX_SB.SB_ZLBSCJB A
                 INNER JOIN HX_SB.SB_CWBB_QYKJZZ_LRB B ON B.ZLBSCJUUID = A.ZLBSCJUUID
                 WHERE A.DJXH=CUR_BGQ.DJXH 
                   AND A.SSQQ>=TRUNC(ADD_MONTHS(CUR_BGQ.BGQ_Z,-2),'MM') 
                   AND A.SSQZ=CUR_BGQ.BGQ_Z
                   AND A.ZFBZ_1 IS NULL
                 UNION ALL
                SELECT DECODE(B.EWBHXH,1, B.BNLJJE,0) AS LR_YYSR, 
                       DECODE(B.EWBHXH,2, B.BNLJJE,0) AS LR_YYCB, 
                       DECODE(B.EWBHXH,3, B.BNLJJE,0) AS LR_SJJFJ, 
                       DECODE(B.EWBHXH,11, B.BNLJJE,0) AS LR_XSFY, 
                       DECODE(B.EWBHXH,14, B.BNLJJE,0) AS LR_GLFY, 
                       DECODE(B.EWBHXH,18, B.BNLJJE,0) AS LR_CWFY, 
                       DECODE(B.EWBHXH,19, B.BNLJJE,0) AS LR_LXZC, 
                       DECODE(B.EWBHXH,21, B.BNLJJE,0) AS LR_YYLR, 
                       DECODE(B.EWBHXH,22, B.BNLJJE,0) AS LR_QTSR, 
                       DECODE(B.EWBHXH,30, B.BNLJJE,0) AS LR_LRZE, 
                       DECODE(B.EWBHXH,31, B.BNLJJE,0) AS LR_SDS, 
                       DECODE(B.EWBHXH,32, B.BNLJJE,0) AS LR_JLR 
                  FROM HX_SB.SB_ZLBSCJB A
                 INNER JOIN HX_SB.SB_CWBB_XQYKJZZ_LRB B ON B.ZLBSCJUUID = A.ZLBSCJUUID
                 WHERE A.DJXH=CUR_BGQ.DJXH 
                   AND A.SSQQ>=TRUNC(ADD_MONTHS(CUR_BGQ.BGQ_Z,-3),'MM') 
                   AND A.SSQZ=CUR_BGQ.BGQ_Z
                   AND A.ZFBZ_1 IS NULL
                 UNION ALL
                SELECT DECODE(B.EWBHXH,1, B.BQJE,0) AS LR_YYSR, 
                       DECODE(B.EWBHXH,2, B.BQJE,0) AS LR_YYCB, 
                       DECODE(B.EWBHXH,3, B.BQJE,0) AS LR_SJJFJ, 
                       DECODE(B.EWBHXH,4, B.BQJE,0) AS LR_XSFY, 
                       DECODE(B.EWBHXH,5, B.BQJE,0) AS LR_GLFY, 
                       DECODE(B.EWBHXH,6, B.BQJE,0) AS LR_CWFY, 
                       0 AS LR_LXZC,
                       DECODE(B.EWBHXH,11, B.BQJE,0) AS LR_YYLR, 
                       DECODE(B.EWBHXH,12, B.BQJE,0) AS LR_QTSR, 
                       DECODE(B.EWBHXH,15, B.BQJE,0) AS LR_LRZE, 
                       DECODE(B.EWBHXH,16, B.BQJE,0) AS LR_SDS, 
                       DECODE(B.EWBHXH,17, B.BQJE,0) AS LR_JLR 
                  FROM HX_SB.SB_ZLBSCJB A
                 INNER JOIN HX_SB.SB_CWBB_QYKJZZYBQY_LRB B ON B.ZLBSCJUUID = A.ZLBSCJUUID
                 WHERE A.DJXH=CUR_BGQ.DJXH 
                   AND A.SSQQ>=TRUNC(ADD_MONTHS(CUR_BGQ.BGQ_Z,-3),'MM') 
                   AND A.SSQZ=CUR_BGQ.BGQ_Z
                   AND A.ZFBZ_1 IS NULL
                 UNION ALL
                SELECT DECODE(B.EWBHXH,1, B.BQJE,0) AS LR_YYSR, 
                       DECODE(B.EWBHXH,2, B.BQJE,0) AS LR_YYCB, 
                       DECODE(B.EWBHXH,3, B.BQJE,0) AS LR_SJJFJ, 
                       DECODE(B.EWBHXH,4, B.BQJE,0) AS LR_XSFY, 
                       DECODE(B.EWBHXH,5, B.BQJE,0) AS LR_GLFY, 
                       DECODE(B.EWBHXH,7, B.BQJE,0) AS LR_CWFY, 
                       DECODE(B.EWBHXH,8, B.BQJE,0) AS LR_LXZC,
                       DECODE(B.EWBHXH,19, B.BQJE,0) AS LR_YYLR, 
                       DECODE(B.EWBHXH,20, B.BQJE,0) AS LR_QTSR, 
                       DECODE(B.EWBHXH,22, B.BQJE,0) AS LR_LRZE, 
                       DECODE(B.EWBHXH,23, B.BQJE,0) AS LR_SDS, 
                       DECODE(B.EWBHXH,24, B.BQJE,0) AS LR_JLR 
                  FROM HX_SB.SB_ZLBSCJB A
                 INNER JOIN HX_SB.SB_CWBB_QYKJZZYBQY_LRBYZX B ON B.ZLBSCJUUID = A.ZLBSCJUUID
                 WHERE A.DJXH=CUR_BGQ.DJXH 
                   AND A.SSQQ>=TRUNC(ADD_MONTHS(CUR_BGQ.BGQ_Z,-3),'MM') 
                   AND A.SSQZ=CUR_BGQ.BGQ_Z
                   AND A.ZFBZ_1 IS NULL
                 UNION ALL
                -- -期初数
                SELECT DECODE(B.EWBHXH,1, - B.BNLJS,0) AS LR_YYSR, 
                       DECODE(B.EWBHXH,2, - B.BNLJS,0) AS LR_YYCB, 
                       DECODE(B.EWBHXH,3, - B.BNLJS,0) AS LR_SJJFJ, 
                       DECODE(B.EWBHXH,6, - B.BNLJS,0) AS LR_XSFY, 
                       DECODE(B.EWBHXH,7, - B.BNLJS,0) AS LR_GLFY, 
                       DECODE(B.EWBHXH,8, - B.BNLJS,0) AS LR_CWFY, 
                       0 AS LR_LXZC,
                       DECODE(B.EWBHXH,9, - B.BNLJS,0) AS LR_YYLR, 
                       DECODE(B.EWBHXH,12, - B.BNLJS,0) AS LR_QTSR, 
                       DECODE(B.EWBHXH,14, - B.BNLJS,0) AS LR_LRZE, 
                       DECODE(B.EWBHXH,15, - B.BNLJS,0) AS LR_SDS, 
                       DECODE(B.EWBHXH,16, - B.BNLJS,0) AS LR_JLR 
                  FROM HX_SB.SB_ZLBSCJB A
                 INNER JOIN HX_SB.SB_CWBB_QYKJZZ_LRB B ON B.ZLBSCJUUID = A.ZLBSCJUUID
                 WHERE A.DJXH=CUR_BGQ.DJXH 
                   AND A.SSQQ>=ADD_MONTHS(CUR_BGQ.BGQ_Q,-3) AND A.SSQZ=CUR_BGQ.BGQ_Q-1
                   AND A.ZFBZ_1 IS NULL
                   AND EXTRACT(MONTH FROM CUR_BGQ.BGQ_Q)>1
                 UNION ALL
                SELECT DECODE(B.EWBHXH,1, - B.BNLJJE,0) AS LR_YYSR, 
                       DECODE(B.EWBHXH,2, - B.BNLJJE,0) AS LR_YYCB, 
                       DECODE(B.EWBHXH,3, - B.BNLJJE,0) AS LR_SJJFJ, 
                       DECODE(B.EWBHXH,11, - B.BNLJJE,0) AS LR_XSFY, 
                       DECODE(B.EWBHXH,14, - B.BNLJJE,0) AS LR_GLFY, 
                       DECODE(B.EWBHXH,18, - B.BNLJJE,0) AS LR_CWFY, 
                       DECODE(B.EWBHXH,19, - B.BNLJJE,0) AS LR_LXZC, 
                       DECODE(B.EWBHXH,21, - B.BNLJJE,0) AS LR_YYLR, 
                       DECODE(B.EWBHXH,22, - B.BNLJJE,0) AS LR_QTSR, 
                       DECODE(B.EWBHXH,30, - B.BNLJJE,0) AS LR_LRZE, 
                       DECODE(B.EWBHXH,31, - B.BNLJJE,0) AS LR_SDS, 
                       DECODE(B.EWBHXH,32, - B.BNLJJE,0) AS LR_JLR 
                  FROM HX_SB.SB_ZLBSCJB A
                 INNER JOIN HX_SB.SB_CWBB_XQYKJZZ_LRB B ON B.ZLBSCJUUID = A.ZLBSCJUUID
                 WHERE A.DJXH=CUR_BGQ.DJXH 
                   AND A.SSQQ>=ADD_MONTHS(CUR_BGQ.BGQ_Q,-3) AND A.SSQZ=CUR_BGQ.BGQ_Q-1
                   AND A.ZFBZ_1 IS NULL
                   AND EXTRACT(MONTH FROM CUR_BGQ.BGQ_Q)>1
                 UNION ALL
                SELECT DECODE(B.EWBHXH,1, - B.BQJE,0) AS LR_YYSR, 
                       DECODE(B.EWBHXH,2, - B.BQJE,0) AS LR_YYCB, 
                       DECODE(B.EWBHXH,3, - B.BQJE,0) AS LR_SJJFJ, 
                       DECODE(B.EWBHXH,4, - B.BQJE,0) AS LR_XSFY, 
                       DECODE(B.EWBHXH,5, - B.BQJE,0) AS LR_GLFY, 
                       DECODE(B.EWBHXH,6, - B.BQJE,0) AS LR_CWFY, 
                       0 AS LR_LXZC,
                       DECODE(B.EWBHXH,11, - B.BQJE,0) AS LR_YYLR, 
                       DECODE(B.EWBHXH,12, - B.BQJE,0) AS LR_QTSR, 
                       DECODE(B.EWBHXH,15, - B.BQJE,0) AS LR_LRZE, 
                       DECODE(B.EWBHXH,16, - B.BQJE,0) AS LR_SDS, 
                       DECODE(B.EWBHXH,17, - B.BQJE,0) AS LR_JLR 
                  FROM HX_SB.SB_ZLBSCJB A
                 INNER JOIN HX_SB.SB_CWBB_QYKJZZYBQY_LRB B ON B.ZLBSCJUUID = A.ZLBSCJUUID
                 WHERE A.DJXH=CUR_BGQ.DJXH 
                   AND A.SSQQ>=ADD_MONTHS(CUR_BGQ.BGQ_Q,-3) AND A.SSQZ=CUR_BGQ.BGQ_Q-1
                   AND A.ZFBZ_1 IS NULL
                   AND EXTRACT(MONTH FROM CUR_BGQ.BGQ_Q)>1
                 UNION ALL
                SELECT DECODE(B.EWBHXH,1, - B.BQJE,0) AS LR_YYSR, 
                       DECODE(B.EWBHXH,2, - B.BQJE,0) AS LR_YYCB, 
                       DECODE(B.EWBHXH,3, - B.BQJE,0) AS LR_SJJFJ, 
                       DECODE(B.EWBHXH,4, - B.BQJE,0) AS LR_XSFY, 
                       DECODE(B.EWBHXH,5, - B.BQJE,0) AS LR_GLFY, 
                       DECODE(B.EWBHXH,7, - B.BQJE,0) AS LR_CWFY, 
                       DECODE(B.EWBHXH,8, - B.BQJE,0) AS LR_LXZC,
                       DECODE(B.EWBHXH,19, - B.BQJE,0) AS LR_YYLR, 
                       DECODE(B.EWBHXH,20, - B.BQJE,0) AS LR_QTSR, 
                       DECODE(B.EWBHXH,22, - B.BQJE,0) AS LR_LRZE, 
                       DECODE(B.EWBHXH,23, - B.BQJE,0) AS LR_SDS, 
                       DECODE(B.EWBHXH,24, - B.BQJE,0) AS LR_JLR 
                  FROM HX_SB.SB_ZLBSCJB A
                 INNER JOIN HX_SB.SB_CWBB_QYKJZZYBQY_LRBYZX B ON B.ZLBSCJUUID = A.ZLBSCJUUID
                 WHERE A.DJXH=CUR_BGQ.DJXH 
                   AND A.SSQQ>=ADD_MONTHS(CUR_BGQ.BGQ_Q,-3) AND A.SSQZ=CUR_BGQ.BGQ_Q-1
                   AND A.ZFBZ_1 IS NULL
                   AND EXTRACT(MONTH FROM CUR_BGQ.BGQ_Q)>1
               ) T;
        
        UPDATE TL_TSSH.JKGL_DATA_TJ_ZBU
           SET LR_YYSR=V_LR_YYSR,
               LR_YYCB=V_LR_YYCB,
               LR_SJJFJ=V_LR_SJJFJ,
               LR_XSFY=V_LR_XSFY,
               LR_GLFY=V_LR_GLFY,
               LR_CWFY=V_LR_CWFY,
               LR_LXZC=V_LR_LXZC,
               LR_YYLR=V_LR_YYLR,
               LR_QTSR=V_LR_QTSR,
               LR_LRZE=V_LR_LRZE,
               LR_SDS=V_LR_SDS,
               LR_JLR=V_LR_JLR
         WHERE BGQID=CUR_BGQ.BGQID;
        COMMIT;
      END IF;
    END;
    
    -- V_CW_
    BEGIN
      -- V_CW_MLL  NUMBER(8,2) 财务_毛利率
      IF (V_LR_YYSR IS NOT NULL) AND (V_LR_YYCB IS NOT NULL) AND (V_LR_YYSR<>0) THEN
        V_CW_MLL := LEAST(GREATEST(ROUND(100*(V_LR_YYSR-V_LR_YYCB)/V_LR_YYSR,2),-100),100);
      ELSE
        V_CW_MLL := NULL;
      END IF;

      --  V_CW_HYSFL  NUMBER(8,2) 财务_还原税负率
      -- 还原税负率=(全部销售收入 * 13% - (进项税额 - 进项税额转出) + (期末存货 - 期初存货) * 13%)/全部销售收入
      IF (V_ZZS_XSE_QB IS NOT NULL) AND (V_ZZS_XSE_QB<>0) THEN
        V_CW_HYSFL := LEAST(GREATEST(ROUND(100 * (0.13 * (V_ZZS_XSE_QB + V_ZC_CH_QM - V_ZC_CH_QC) - V_ZZS_JXSE + V_ZZS_JXSEZC) / V_ZZS_XSE_QB, 2),0),100);
      ELSE
        V_CW_HYSFL := NULL;
      END IF;
          
      UPDATE TL_TSSH.JKGL_DATA_TJ_ZBU
         SET V_CW_MLL=V_CW_MLL,
             V_CW_HYSFL=V_CW_HYSFL
       WHERE BGQID=CUR_BGQ.BGQID;
      COMMIT;
    END;
    
    -- V_SDS_
    BEGIN
      IF CUR_BGQ.ZQLX='年' THEN
        -- V_SDS_YYSR        NUMBER(18,2); --     所得税_营业收入
        -- V_SDS_YNSSDE      NUMBER(18,2); --     所得税_应纳税所得额
        SELECT NVL(T.YSX,0), NVL(T.JSYJ,0) 
          INTO V_SDS_YYSR, V_SDS_YNSSDE
          FROM HX_SB.SB_SBXX T 
         WHERE T.DJXH=CUR_BGQ.DJXH
           AND T.ZSXM_DM='10104' AND T.YZPZZL_DM='BDA0610994'
           AND T.SKSSQQ=CUR_BGQ.BGQ_Q AND T.SKSSQZ=CUR_BGQ.BGQ_Z
           AND T.ZFBZ_1='N' AND T.GZLX_DM_1 IN ('1','5')
           AND ROWNUM=1;
        
        UPDATE TL_TSSH.JKGL_DATA_TJ_ZBU
           SET SDS_YYSR=V_SDS_YYSR,
               SDS_YNSSDE=V_SDS_YNSSDE
         WHERE BGQID=CUR_BGQ.BGQID;
        COMMIT;
      END IF;
    END;
    
    
    --计算 JKGL_DATA_TJ_ZBU_CKGB.BGQID
    MERGE INTO JKGL_DATA_TJ_ZBU_CKGB A
         USING (SELECT CUR_BGQ.BGQID AS BGQID, T.MYGDQSZ_DM AS GB_DM, SUM(T.MYLAJ) AS CKEUSD, SUM(T.RMBLAJ) AS CKERMB,
                       COUNT(DISTINCT T.HGGQKA_DM) AS KASL, COUNT(DISTINCT T.SBDWDM) AS SBDWSL, COUNT(DISTINCT T.YSFS_DM) AS YSFSSL
                  FROM TL_TSSH.CKTS_WBSJ_HG_BGD T
                 WHERE T.DJXH=CUR_BGQ.DJXH
                   AND T.CKRQ_1>=CUR_BGQ.BGQ_Q AND T.CKRQ_1<V_BGQ_Z+1
                   AND T.JGFS_DM<>'1039'
                 GROUP BY T.MYGDQSZ_DM) B
            ON (A.BGQID=B.BGQID AND A.GB_DM=B.GB_DM)
          WHEN MATCHED THEN
            UPDATE SET A.CKEUSD=B.CKEUSD, A.CKERMB=B.CKERMB, A.KASL=B.KASL, A.SBDWSL=B.SBDWSL, A.YSFSSL=B.YSFSSL
          WHEN NOT MATCHED THEN
            INSERT (ID,BGQID,GB_DM,CKEUSD,CKERMB,KASL,SBDWSL,YSFSSL)
            VALUES (SEQ_JKGL_DATA_TJ_ZBU_CKGB.NEXTVAL,B.BGQID,B.GB_DM,B.CKEUSD,B.CKERMB,B.KASL,B.SBDWSL,B.YSFSSL);
    COMMIT;
    
    --计算 JKGL_DATA_TJ_ZBU_CKKA.BGQID
    MERGE INTO JKGL_DATA_TJ_ZBU_CKKA A
         USING (SELECT CUR_BGQ.BGQID AS BGQID, T.HGGQKA_DM AS KA_DM, SUM(T.MYLAJ) AS CKEUSD, SUM(T.RMBLAJ) AS CKERMB,
                       COUNT(DISTINCT T.SBDWDM) AS SBDWSL
                  FROM TL_TSSH.CKTS_WBSJ_HG_BGD T
                 WHERE T.DJXH=CUR_BGQ.DJXH
                   AND T.CKRQ_1>=CUR_BGQ.BGQ_Q AND T.CKRQ_1<V_BGQ_Z+1
                   AND T.JGFS_DM<>'1039'
                 GROUP BY T.HGGQKA_DM) B
            ON (A.BGQID=B.BGQID AND A.KA_DM=B.KA_DM)
          WHEN MATCHED THEN
            UPDATE SET A.CKEUSD=B.CKEUSD, A.CKERMB=B.CKERMB, A.SBDWSL=B.SBDWSL
          WHEN NOT MATCHED THEN
            INSERT (ID,BGQID,KA_DM,CKEUSD,CKERMB,SBDWSL)
            VALUES (SEQ_JKGL_DATA_TJ_ZBU_CKKA.NEXTVAL,B.BGQID,B.KA_DM,B.CKEUSD,B.CKERMB,B.SBDWSL);
    COMMIT;

    --计算 JKGL_DATA_TJ_ZBU_CKSP.BGQID
    MERGE INTO JKGL_DATA_TJ_ZBU_CKSP A
         USING (SELECT CUR_BGQ.BGQID AS BGQID, SUBSTR(T.CKSP_DM,1,8) AS SP8_DM, SUM(T.MYLAJ) AS CKEUSD, SUM(T.RMBLAJ) AS CKERMB,
                       SUM(T.CKSL) AS CKSL, CASE WHEN SUM(T.CKSL)=0 THEN NULL ELSE SUM(T.RMBLAJ)/SUM(T.CKSL) END AS CKDJ
                  FROM TL_TSSH.CKTS_WBSJ_HG_BGD T
                 WHERE T.DJXH=CUR_BGQ.DJXH
                   AND T.CKRQ_1>=CUR_BGQ.BGQ_Q AND T.CKRQ_1<V_BGQ_Z+1
                   AND T.JGFS_DM<>'1039'
                 GROUP BY SUBSTR(T.CKSP_DM,1,8)) B
            ON (A.BGQID=B.BGQID AND A.SP8_DM=B.SP8_DM)
          WHEN MATCHED THEN
            UPDATE SET A.CKEUSD=B.CKEUSD, A.CKERMB=B.CKERMB, A.CKSL=B.CKSL, A.CKDJ=B.CKDJ
          WHEN NOT MATCHED THEN
            INSERT (ID,BGQID,SP8_DM,CKEUSD,CKERMB,CKSL,CKDJ)
            VALUES (SEQ_JKGL_DATA_TJ_ZBU_CKSP.NEXTVAL,B.BGQID,B.SP8_DM,B.CKEUSD,B.CKERMB,B.CKSL,B.CKDJ);
    COMMIT;
    UPDATE TL_TSSH.JKGL_DATA_TJ_ZBU_CKSP A
       SET A.SPDL=SUBSTR(A.SP8_DM,1,2),
           A.SPMC=(SELECT B.CKSP_MC FROM TL_TSSH.JCFX_DM_CKSP B WHERE B.CKSP_DM=A.SP8_DM AND ROWNUM=1)
     WHERE A.BGQID=CUR_BGQ.BGQID AND A.SPDL IS NULL;
    COMMIT;

    --计算 JKGL_DATA_TJ_ZBU_QYXX.BGQID
    MERGE INTO JKGL_DATA_TJ_ZBU_QYXX A
         USING (SELECT CUR_BGQ.BGQID AS BGQID, T.FDDBRMC  AS FR_XM, T.FRZJHM AS FR_ZJHM, 
                       T.CWFZRXM AS CWR_XM, T.CWFZRSFZJHM AS CWR_ZJHM, 
                       T.BSRXM AS BSR_XM, T.BSRSFZJHM AS BSR_ZJHM,
                       MONTHS_BETWEEN(V_BGQ_Z,TRUNC(T.DJRQ,'MM')) AS JYYFSL,
                       MONTHS_BETWEEN(V_BGQ_Z,TRUNC(T.SCCKRQ,'MM')) AS CKYFSL,
                       T.ZCDZ,T.SCJYDZ AS JYDZ,
                       S.SJJYR_XM AS SKR_XM, S.SJJYR_SFZH AS SKR_ZJHM, S.YJBGCS_MJ AS JYCDMJ 
                  FROM TL_BJTS.GS_DJ_CKTMSDAB T
                  LEFT JOIN TL_TSSH.JKGL_ZLCJ_JGB S ON TO_CHAR(S.DJXH)=T.CPCODE
                 WHERE T.CPCODE=TO_CHAR(CUR_BGQ.DJXH)) B
            ON (A.BGQID=B.BGQID)
          WHEN MATCHED THEN
            UPDATE SET A.FR_XM=B.FR_XM, A.FR_ZJHM=B.FR_ZJHM, A.CWR_XM=B.CWR_XM, A.CWR_ZJHM=B.CWR_ZJHM, 
                       A.BSR_XM=B.BSR_XM, A.BSR_ZJHM=B.BSR_ZJHM, A.JYYFSL=B.JYYFSL, A.CKYFSL=B.CKYFSL, 
                       A.ZCDZ=B.ZCDZ, A.JYDZ=B.JYDZ, A.SKR_XM=B.SKR_XM, A.SKR_ZJHM=B.SKR_ZJHM, A.JYCDMJ=B.JYCDMJ
          WHEN NOT MATCHED THEN
            INSERT (BGQID,FR_XM,FR_ZJHM,CWR_XM,CWR_ZJHM,BSR_XM,BSR_ZJHM,JYYFSL,CKYFSL,ZCDZ,JYDZ,SKR_XM,SKR_ZJHM,JYCDMJ)
            VALUES (B.BGQID,B.FR_XM,B.FR_ZJHM,B.CWR_XM,B.CWR_ZJHM,B.BSR_XM,B.BSR_ZJHM,B.JYYFSL,B.CKYFSL,B.ZCDZ,B.JYDZ,B.SKR_XM,B.SKR_ZJHM,B.JYCDMJ);
    COMMIT;
    UPDATE TL_TSSH.JKGL_DATA_TJ_ZBU_QYXX
       SET FLGLCD =
           (SELECT S.KZXX 
              FROM TL_BJTS.GS_DJ_CKTMSDAB T, TL_BJTS.GS_DJ_CKTMSDAB_KZ S
             WHERE T.CPCODE=TO_CHAR(CUR_BGQ.DJXH) 
               AND S.NSRDZDAH=T.NSRDZDAH
               AND S.KZLX='FLGLCD' AND (V_BGQ_Z BETWEEN S.ST_DATE AND S.END_DATE) AND S.FLAG='1'
               AND ROWNUM=1)
     WHERE BGQID=CUR_BGQ.BGQID;
    COMMIT;

    --计算 JKGL_DATA_TJ_ZBU_TSGH.BGQID
    MERGE INTO JKGL_DATA_TJ_ZBU_TSGH A
         USING (SELECT CUR_BGQ.BGQID AS BGQID, S.GHFNSRSBH_1 AS GHFSH, SUM(S.JSJE) AS JHJE, SUM(S.TSE) AS TSE
                  FROM TL_TSSH.CKTS_SB_MTS_JHMX S 
                 WHERE S.DJXH=CUR_BGQ.DJXH
                   AND S.SBRQ>=CUR_BGQ.BGQ_Q AND S.SBRQ<V_BGQ_Z+1
                 GROUP BY S.GHFNSRSBH_1) B
            ON (A.BGQID=B.BGQID AND A.GHFSH=B.GHFSH)
          WHEN MATCHED THEN
            UPDATE SET A.JHJE=B.JHJE, A.TSE=B.TSE
          WHEN NOT MATCHED THEN
            INSERT (ID,BGQID,GHFSH,JHJE,TSE)
            VALUES (SEQ_JKGL_DATA_TJ_ZBU_TSGH.NEXTVAL,B.BGQID,B.GHFSH,B.JHJE,B.TSE);
    COMMIT;
    UPDATE TL_TSSH.JKGL_DATA_TJ_ZBU_TSGH T
       SET T.FXQYBZ='1'
     WHERE T.BGQID=CUR_BGQ.BGQID
       AND EXISTS (SELECT 1
                     FROM TL_TSSH.JKGL_GY_FXQY_SWJG S
                    WHERE S.QYSBH=T.GHFSH
                      AND NVL(S.YXQ_Z,SYSDATE)>CUR_BGQ.BGQ_Q);
    COMMIT;
    UPDATE TL_TSSH.JKGL_DATA_TJ_ZBU_TSGH T
       SET T.FXDQBZ='1'
     WHERE T.BGQID=CUR_BGQ.BGQID
       AND EXISTS (SELECT 1
                     FROM TL_TSSH.JKGL_GY_FXDQ_SWJG S
                    WHERE S.XZQH_DM= CASE WHEN LENGTH(T.GHFSH)=15
                                          THEN SUBSTR(T.GHFSH,1,LENGTH(S.XZQH_DM))
                                          ELSE SUBSTR(T.GHFSH,3,LENGTH(S.XZQH_DM)) END
                      AND NVL(S.YXQ_Z,SYSDATE)>CUR_BGQ.BGQ_Q);
    COMMIT;
    UPDATE TL_TSSH.JKGL_DATA_TJ_ZBU_TSGH T
       SET T.SNWBZ='1'
     WHERE T.BGQID=CUR_BGQ.BGQID
       AND '33' <> (CASE WHEN LENGTH(T.GHFSH)=15 THEN SUBSTR(T.GHFSH,1,2) ELSE SUBSTR(T.GHFSH,3,2) END);
    COMMIT;
    UPDATE TL_TSSH.JKGL_DATA_TJ_ZBU_TSGH T
       SET T.FZCHBZ='1'
     WHERE T.BGQID=CUR_BGQ.BGQID
       AND EXISTS (SELECT 1
                     FROM TL_TSSH.JKGL_GY_GHQYXX S
                    WHERE S.QYSBH=T.GHFSH AND NVL(S.NSRZT_DM,'03')='05');
    COMMIT;

    --计算 JKGL_DATA_TJ_ZBU_TSSP.BGQID
    MERGE INTO JKGL_DATA_TJ_ZBU_TSSP A
         USING (SELECT CUR_BGQ.BGQID AS BGQID, SUBSTR(T.CKSP_DM,1,8) AS SP8_DM, SUM(T.MYLAJ) AS CKEUSD, SUM(T.RMBLAJ) AS CKERMB,
                       SUM(S.RMBLAJ) AS CKERMB_STZC, SUM(T.CKSL) AS CKSL, SUM(T.TMSE) AS SBTMSE, SUM(T.JSJE) AS JHJE,
                       CASE WHEN SUM(T.CKSL)<=0 THEN 0 ELSE ROUND(SUM(T.MYLAJ) / SUM(T.CKSL), 2) END AS CKDJ,
                       CASE WHEN SUM(T.CKSL)<=0 THEN 0 ELSE ROUND(SUM(T.JSJE) / SUM(T.CKSL), 2) END AS JHDJ,
                       CASE WHEN SUM(T.MYLAJ)<=0 THEN 0 ELSE ROUND((SUM(T.RMBLAJ) - SUM(T.JSJE)) / SUM(T.MYLAJ),2) END AS MMYLR
                  FROM TL_TSSH.JCFX_DATA_TSSBMX T
                  LEFT JOIN TL_TSSH.CKTS_SB_MDT_CKMX S ON S.UUID=T.UUID AND S.CKTMSYWLXDMJH LIKE '%STZC%'
                 WHERE T.DJXH=CUR_BGQ.DJXH
                   AND T.SBRQ>=CUR_BGQ.BGQ_Q AND T.SBRQ<V_BGQ_Z+1
                 GROUP BY SUBSTR(T.CKSP_DM,1,8)) B
            ON (A.BGQID=B.BGQID AND A.SP8_DM=B.SP8_DM)
          WHEN MATCHED THEN
            UPDATE SET A.CKEUSD=B.CKEUSD, A.CKERMB=B.CKERMB, A.CKERMB_STZC=B.CKERMB_STZC, A.CKSL=B.CKSL, 
                       A.SBTMSE=B.SBTMSE, A.JHJE=B.JHJE, A.CKDJ=B.CKDJ, A.JHDJ=B.JHDJ, A.MMYLR=B.MMYLR
          WHEN NOT MATCHED THEN
            INSERT (ID,BGQID,SP8_DM,CKEUSD,CKERMB,CKERMB_STZC,CKSL,SBTMSE,JHJE,SP_DL,MMYLR,CKDJ,JHDJ)
            VALUES (SEQ_JKGL_DATA_TJ_ZBU_TSSP.NEXTVAL,B.BGQID,B.SP8_DM,B.CKEUSD,B.CKERMB,B.CKERMB_STZC,
                    B.CKSL,B.SBTMSE,B.JHJE,SUBSTR(B.SP8_DM,1,2),B.MMYLR,B.CKDJ,B.JHDJ);
    COMMIT;
    UPDATE TL_TSSH.JKGL_DATA_TJ_ZBU_TSSP T
       SET T.MGBZ='1'
     WHERE T.BGQID=CUR_BGQ.BGQID
       AND EXISTS (SELECT 1
                     FROM TL_TSSH.JKGL_GY_MGSP_SWJG S
                    WHERE SUBSTR(T.SP8_DM,1,LENGTH(S.MGSP_DM)) = S.MGSP_DM
                      AND NVL(S.YXQ_Z,SYSDATE)>CUR_BGQ.BGQ_Q);
    COMMIT;
    
    --计算 JKGL_DATA_TJ_ZBU_DZGF.BGQID
    MERGE INTO JKGL_DATA_TJ_ZBU_DZGF A
         USING (SELECT CUR_BGQ.BGQID AS BGQID, GFSBH,GFMC,FS,JE,SE,ZYSPMC,ZYSPJE
                  FROM (SELECT Z.GFSBH, MAX(Z.GFMC) AS GFMC, COUNT(1) AS FS, SUM(Z.JE) AS JE, SUM(Z.SE) AS SE,
                               MAX(CASE WHEN Z.RN = 1 THEN Z.SPMC ELSE NULL END) AS ZYSPMC,
                               MAX(CASE WHEN Z.RN = 1 THEN Z.JE   ELSE NULL END) AS ZYSPJE
                          FROM (SELECT P.GFSBH, MAX(P.GFMC) AS GFMC, P.SPMC, SUM(P.JE) AS JE, SUM(P.SE) AS SE,
                                       ROW_NUMBER() OVER(PARTITION BY P.GFSBH ORDER BY SUM(P.JE) DESC) AS RN
                                  FROM (SELECT /*+ PARALLEL(3) */ T1.GMFSBH AS GFSBH,T1.GMFMC AS GFMC,UPPER(S1.MC) AS SPMC,S1.JE,S1.SE
                                          FROM DZDZ.DZDZ_FPXX_DZZP T1 --电子专票
                                         INNER JOIN DZDZ.DZDZ_HWXX_DZZP S1 ON S1.FPDM=T1.FPDM AND S1.FPHM=T1.FPHM 
                                         WHERE T1.KPYF>=CUR_BGQ.YF_Q AND T1.KPYF<=CUR_BGQ.YF_Z 
                                           AND T1.XSFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                                           AND T1.FPZTBZ IN ('0','1')
                                           AND S1.KPYF>=CUR_BGQ.YF_Q AND S1.KPYF<=CUR_BGQ.YF_Z 
                                           AND S1.SPBM LIKE '1%'
                                         UNION ALL
                                        SELECT /*+ PARALLEL(3) */ T2.GFSBH, T2.GFMC, UPPER(S2.MC) AS SPMC, S2.JE, S2.SE
                                          FROM DZDZ.DZDZ_FPXX_ZZSFP T2 --纸质专票
                                         INNER JOIN DZDZ.DZDZ_HWXX_ZZSFP S2 ON S2.FPDM=T2.FPDM AND S2.FPHM=T2.FPHM 
                                         WHERE T2.KPYF>=CUR_BGQ.YF_Q AND T2.KPYF<=CUR_BGQ.YF_Z 
                                           AND T2.XFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                                           AND T2.FPZT_BZ IN ('0','1')
                                           AND S2.KPYF>=CUR_BGQ.YF_Q AND S2.KPYF<=CUR_BGQ.YF_Z 
                                           AND S2.SPBM LIKE '1%') P
                                 GROUP BY P.GFSBH, P.SPMC) Z
                         GROUP BY Z.GFSBH
                         ORDER BY SUM(Z.JE) DESC) TT
                 WHERE ROWNUM<=20) B
            ON (A.BGQID=B.BGQID AND A.GFSBH=B.GFSBH)
          WHEN MATCHED THEN
            UPDATE SET A.GFMC=B.GFMC, A.FS=B.FS, A.JE=B.JE, A.SE=B.SE, A.ZYSPMC=B.ZYSPMC, A.ZYSPJE=B.ZYSPJE
          WHEN NOT MATCHED THEN
            INSERT (ID,BGQID,GFSBH,GFMC,FS,JE,SE,ZYSPMC,ZYSPJE)
            VALUES (SEQ_JKGL_DATA_TJ_ZBU_DZGF.NEXTVAL,B.BGQID,B.GFSBH,B.GFMC,B.FS,B.JE,B.SE,B.ZYSPMC,B.ZYSPJE);
    COMMIT;
    
    --计算 JKGL_DATA_TJ_ZBU_DZXF.BGQID
    MERGE INTO JKGL_DATA_TJ_ZBU_DZXF A
         USING (SELECT CUR_BGQ.BGQID AS BGQID, XFSBH,XFMC,FS,JE,SE,ZYSPMC,ZYSPJE
                  FROM (SELECT Z.XFSBH, MAX(Z.XFMC) AS XFMC, COUNT(1) AS FS, SUM(Z.JE) AS JE, SUM(Z.SE) AS SE,
                               MAX(CASE WHEN Z.RN = 1 THEN Z.SPMC ELSE NULL END) AS ZYSPMC,
                               MAX(CASE WHEN Z.RN = 1 THEN Z.JE   ELSE NULL END) AS ZYSPJE
                          FROM (SELECT P.XFSBH, MAX(P.XFMC) AS XFMC, P.SPMC, SUM(P.JE) AS JE, SUM(P.SE) AS SE,
                                       ROW_NUMBER() OVER(PARTITION BY P.XFSBH ORDER BY SUM(P.JE) DESC) AS RN
                                  FROM (SELECT /*+ PARALLEL(3) */ T1.XSFSBH AS XFSBH,T1.XSFMC AS XFMC,UPPER(S1.MC) AS SPMC,S1.JE,S1.SE
                                          FROM DZDZ.DZDZ_FPXX_DZZP T1 --电子专票
                                         INNER JOIN DZDZ.DZDZ_HWXX_DZZP S1 ON S1.FPDM=T1.FPDM AND S1.FPHM=T1.FPHM 
                                         WHERE T1.KPYF>=CUR_BGQ.YF_Q AND T1.KPYF<=CUR_BGQ.YF_Z 
                                           AND T1.GMFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                                           AND T1.FPZTBZ IN ('0','1')
                                           AND S1.KPYF>=CUR_BGQ.YF_Q AND S1.KPYF<=CUR_BGQ.YF_Z 
                                           AND S1.SPBM LIKE '1%'
                                         UNION ALL
                                        SELECT /*+ PARALLEL(3) */ T1.XSFSBH AS XFSBH,T1.XSFMC AS XFMC,UPPER(S1.MC) AS SPMC,S1.JE,S1.SE
                                          FROM DZDZ.DZDZ_FPXX_DZZP_YD T1 --电子专票（异地）
                                         INNER JOIN DZDZ.DZDZ_HWXX_DZZP_YD S1 ON S1.FPDM=T1.FPDM AND S1.FPHM=T1.FPHM 
                                         WHERE T1.KPYF>=CUR_BGQ.YF_Q AND T1.KPYF<=CUR_BGQ.YF_Z 
                                           AND T1.GMFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                                           AND T1.FPZTBZ IN ('0','1')
                                           AND S1.KPYF>=CUR_BGQ.YF_Q AND S1.KPYF<=CUR_BGQ.YF_Z 
                                           AND S1.SPBM LIKE '1%'
                                         UNION ALL
                                        SELECT /*+ PARALLEL(3) */ T2.XFSBH, T2.XFMC, UPPER(S2.MC) AS SPMC, S2.JE, S2.SE
                                          FROM DZDZ.DZDZ_FPXX_ZZSFP T2 --纸质专票
                                         INNER JOIN DZDZ.DZDZ_HWXX_ZZSFP S2 ON S2.FPDM=T2.FPDM AND S2.FPHM=T2.FPHM 
                                         WHERE T2.KPYF>=CUR_BGQ.YF_Q AND T2.KPYF<=CUR_BGQ.YF_Z 
                                           AND T2.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                                           AND T2.FPZT_BZ IN ('0','1')
                                           AND S2.KPYF>=CUR_BGQ.YF_Q AND S2.KPYF<=CUR_BGQ.YF_Z 
                                           AND S2.SPBM LIKE '1%'
                                         UNION ALL
                                        SELECT /*+ PARALLEL(3) */ T2.XFSBH, T2.XFMC, UPPER(S2.MC) AS SPMC, S2.JE, S2.SE
                                          FROM DZDZ.DZDZ_FPXX_ZZSFP_YD T2 --纸质专票（异地）
                                         INNER JOIN DZDZ.DZDZ_HWXX_ZZSFP_YD S2 ON S2.FPDM=T2.FPDM AND S2.FPHM=T2.FPHM 
                                         WHERE T2.KPYF>=CUR_BGQ.YF_Q AND T2.KPYF<=CUR_BGQ.YF_Z 
                                           AND T2.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                                           AND T2.FPZT_BZ IN ('0','1')
                                           AND S2.KPYF>=CUR_BGQ.YF_Q AND S2.KPYF<=CUR_BGQ.YF_Z 
                                           AND S2.SPBM LIKE '1%') P
                                 GROUP BY P.XFSBH, P.SPMC) Z
                         GROUP BY Z.XFSBH
                         ORDER BY SUM(Z.JE) DESC) TT
                 WHERE ROWNUM<=20) B
            ON (A.BGQID=B.BGQID AND A.XFSBH=B.XFSBH)
          WHEN MATCHED THEN
            UPDATE SET A.XFMC=B.XFMC, A.FS=B.FS, A.JE=B.JE, A.SE=B.SE, A.ZYSPMC=B.ZYSPMC, A.ZYSPJE=B.ZYSPJE
          WHEN NOT MATCHED THEN
            INSERT (ID,BGQID,XFSBH,XFMC,FS,JE,SE,ZYSPMC,ZYSPJE)
            VALUES (SEQ_JKGL_DATA_TJ_ZBU_DZXF.NEXTVAL,B.BGQID,B.XFSBH,B.XFMC,B.FS,B.JE,B.SE,B.ZYSPMC,B.ZYSPJE);
    COMMIT;
    
    --计算 JKGL_DATA_TJ_ZBU_DZSPJX.BGQID
    MERGE INTO JKGL_DATA_TJ_ZBU_DZSPJX A
         USING (SELECT CUR_BGQ.BGQID AS BGQID, SPSM, SPMC, JE, SE
                  FROM (SELECT SPMC, MIN(SPSM) AS SPSM, NVL(SUM(TT.JE),0) AS JE, NVL(SUM(TT.SE),0) AS SE
                          FROM (SELECT /*+ PARALLEL(3) */ S1.SPBM AS SPSM, UPPER(S1.MC) AS SPMC, S1.JE, S1.SE
                                  FROM DZDZ.DZDZ_FPXX_DZZP T1 --电子专票
                                 INNER JOIN DZDZ.DZDZ_HWXX_DZZP S1 ON S1.FPDM=T1.FPDM AND S1.FPHM=T1.FPHM 
                                 WHERE T1.KPYF>=CUR_BGQ.YF_Q AND T1.KPYF<=CUR_BGQ.YF_Z 
                                   AND T1.GMFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                                   AND T1.FPZTBZ IN ('0','1')
                                   AND S1.KPYF>=CUR_BGQ.YF_Q AND S1.KPYF<=CUR_BGQ.YF_Z 
                                   AND S1.SPBM LIKE '1%'
                                 UNION ALL
                                SELECT /*+ PARALLEL(3) */ S1.SPBM AS SPSM, UPPER(S1.MC) AS SPMC, S1.JE, S1.SE
                                  FROM DZDZ.DZDZ_FPXX_DZZP_YD T1 --电子专票（异地）
                                 INNER JOIN DZDZ.DZDZ_HWXX_DZZP_YD S1 ON S1.FPDM=T1.FPDM AND S1.FPHM=T1.FPHM 
                                 WHERE T1.KPYF>=CUR_BGQ.YF_Q AND T1.KPYF<=CUR_BGQ.YF_Z 
                                   AND T1.GMFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                                   AND T1.FPZTBZ IN ('0','1')
                                   AND S1.KPYF>=CUR_BGQ.YF_Q AND S1.KPYF<=CUR_BGQ.YF_Z 
                                   AND S1.SPBM LIKE '1%'
                                 UNION ALL
                                SELECT /*+ PARALLEL(3) */ S2.SPBM AS SPSM, UPPER(S2.MC) AS SPMC, S2.JE, S2.SE
                                  FROM DZDZ.DZDZ_FPXX_ZZSFP T2 --纸质专票
                                 INNER JOIN DZDZ.DZDZ_HWXX_ZZSFP S2 ON S2.FPDM=T2.FPDM AND S2.FPHM=T2.FPHM 
                                 WHERE T2.KPYF>=CUR_BGQ.YF_Q AND T2.KPYF<=CUR_BGQ.YF_Z 
                                   AND T2.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                                   AND T2.FPZT_BZ IN ('0','1')
                                   AND S2.KPYF>=CUR_BGQ.YF_Q AND S2.KPYF<=CUR_BGQ.YF_Z 
                                   AND S2.SPBM LIKE '1%'
                                 UNION ALL
                                SELECT /*+ PARALLEL(3) */ S2.SPBM AS SPSM, UPPER(S2.MC) AS SPMC, S2.JE, S2.SE
                                  FROM DZDZ.DZDZ_FPXX_ZZSFP_YD T2 --纸质专票（异地）
                                 INNER JOIN DZDZ.DZDZ_HWXX_ZZSFP_YD S2 ON S2.FPDM=T2.FPDM AND S2.FPHM=T2.FPHM 
                                 WHERE T2.KPYF>=CUR_BGQ.YF_Q AND T2.KPYF<=CUR_BGQ.YF_Z 
                                   AND T2.GFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                                   AND T2.FPZT_BZ IN ('0','1')
                                   AND S2.KPYF>=CUR_BGQ.YF_Q AND S2.KPYF<=CUR_BGQ.YF_Z 
                                   AND S2.SPBM LIKE '1%') TT
                         GROUP BY SPMC
                         ORDER BY NVL(SUM(TT.SE),0) DESC) TTT
                 WHERE ROWNUM<=20) B
            ON (A.BGQID=B.BGQID AND A.SPMC=B.SPMC)
          WHEN MATCHED THEN
            UPDATE SET A.SPSM=B.SPSM, A.JE=B.JE, A.SE=B.SE
          WHEN NOT MATCHED THEN
            INSERT (ID,BGQID,SPMC,SPSM,JE,SE)
            VALUES (SEQ_JKGL_DATA_TJ_ZBU_DZSPJX.NEXTVAL,B.BGQID,B.SPMC,B.SPSM,B.JE,B.SE);
    COMMIT;
    
    --计算 JKGL_DATA_TJ_ZBU_DZSPXX.BGQID
    MERGE INTO JKGL_DATA_TJ_ZBU_DZSPXX A
         USING (SELECT CUR_BGQ.BGQID AS BGQID, SPSM, SPMC, JE, SE
                  FROM (SELECT SPMC, MIN(SPSM) AS SPSM, NVL(SUM(TT.JE),0) AS JE, NVL(SUM(TT.SE),0) AS SE
                          FROM (SELECT /*+ PARALLEL(3) */ S1.SPBM AS SPSM, UPPER(S1.MC) AS SPMC, S1.JE, S1.SE
                                  FROM DZDZ.DZDZ_FPXX_DZZP T1 --电子专票
                                 INNER JOIN DZDZ.DZDZ_HWXX_DZZP S1 ON S1.FPDM=T1.FPDM AND S1.FPHM=T1.FPHM 
                                 WHERE T1.KPYF>=CUR_BGQ.YF_Q AND T1.KPYF<=CUR_BGQ.YF_Z 
                                   AND T1.XSFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                                   AND T1.FPZTBZ IN ('0','1')
                                   AND S1.KPYF>=CUR_BGQ.YF_Q AND S1.KPYF<=CUR_BGQ.YF_Z 
                                   AND S1.SPBM LIKE '1%'
                                 UNION ALL
                                SELECT /*+ PARALLEL(3) */ S2.SPBM AS SPSM, UPPER(S2.MC) AS SPMC, S2.JE, S2.SE
                                  FROM DZDZ.DZDZ_FPXX_ZZSFP T2 --纸质专票
                                 INNER JOIN DZDZ.DZDZ_HWXX_ZZSFP S2 ON S2.FPDM=T2.FPDM AND S2.FPHM=T2.FPHM 
                                 WHERE T2.KPYF>=CUR_BGQ.YF_Q AND T2.KPYF<=CUR_BGQ.YF_Z 
                                   AND T2.XFSBH IN (CUR_BGQ.NSRDJNO,CUR_BGQ.SHXYNO) 
                                   AND T2.FPZT_BZ IN ('0','1')
                                   AND S2.KPYF>=CUR_BGQ.YF_Q AND S2.KPYF<=CUR_BGQ.YF_Z 
                                   AND S2.SPBM LIKE '1%') TT
                         GROUP BY SPMC
                         ORDER BY NVL(SUM(TT.SE),0) DESC) TTT
                 WHERE ROWNUM<=20) B
            ON (A.BGQID=B.BGQID AND A.SPMC=B.SPMC)
          WHEN MATCHED THEN
            UPDATE SET A.SPSM=B.SPSM, A.JE=B.JE, A.SE=B.SE
          WHEN NOT MATCHED THEN
            INSERT (ID,BGQID,SPMC,SPSM,JE,SE)
            VALUES (SEQ_JKGL_DATA_TJ_ZBU_DZSPXX.NEXTVAL,B.BGQID,B.SPMC,B.SPSM,B.JE,B.SE);
     COMMIT;
    
    --解锁处理完成的报告期
    UPDATE TL_TSSH.JKGL_DATA_BGQ T
       SET T.TQBZ=NULL, T.WCSJ=SYSDATE, T.SXZT='2'
     WHERE T.BGQID=CUR_BGQ.BGQID;
    COMMIT;
    
  END LOOP;
  
  RETURN;
END;
/
