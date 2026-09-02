CREATE OR REPLACE PROCEDURE PRO_JKGL_COMPUTE_ZBU_ND
/*
 * 年度指标元刷新算法
 * 202309，增加代理出口统计
 * 20260714，根据龙泉税局反馈，修正年度报表财务期初数据取数口径
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
  V_TS_BGDSL        NUMBER(10); --  退税_报关单数量
  V_TS_CKEUSD       NUMBER(18,2); --  退税_出口额USD
  V_TS_CKERMB       NUMBER(18,2); --  退税_出口额RMB
  V_TS_MTSCKE       NUMBER(18,2); --  退税_出口额RMB（免退税）
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
  V_LR_LXZC         NUMBER(18,2); --  利润_利息支出
  V_LR_YYLR         NUMBER(18,2); --  利润_营业利润
  V_LR_LRZE         NUMBER(18,2); --  利润_利润总额
  V_LR_QTSR         NUMBER(18,2); --  利润_其它收入
  V_LR_SJJFJ        NUMBER(18,2); --  利润_税金及附加
  V_LR_CWFY         NUMBER(18,2); --  利润_财务费用
  V_LR_JLR          NUMBER(18,2); --  利润_净利润
  V_LR_SDS          NUMBER(18,2); --  利润_所得税
  
  V_ROWS            NUMBER(10);  -- 待更新表中是否存在目标记录
  V_JDNUM           NUMBER(10);  -- 年度内季度报告期数量
  V_BGQ_Z           DATE;
  V_NDJQID          NUMBER(20);  --年度基期ID
BEGIN
  FOR CUR_BGQ IN (SELECT T.BGQID, T.ZQLX, T.DJXH, 
                         T.BGQ_Q, T.BGQ_Z, TO_CHAR(T.BGQ_Q,'YYYYMM') AS YF_Q, TO_CHAR(T.BGQ_Z,'YYYYMM') AS YF_Z
                    FROM TL_TSSH.JKGL_DATA_BGQ T
                   WHERE T.ZQLX='年' AND T.SXZT='0' AND T.TQBZ IS NULL
                     AND NOT EXISTS (SELECT 1
                                       FROM TL_TSSH.JKGL_DATA_BGQ T1
                                      WHERE T1.DJXH=T.DJXH AND T1.BGQ_Q>=T.BGQ_Q AND T1.BGQ_Z<=T.BGQ_Z
                                        AND T1.ZQLX='季'
                                        AND (T1.SXZT<>'3' OR T1.ZZS_ZT='N' OR T1.DZDZ_ZT='N' OR T1.DZSP_ZT='N'))
                 )
  LOOP
    --检查该企业该年度内季度报告期数量
    SELECT COUNT(1), MAX(T1.BGQ_Z)
      INTO V_JDNUM, V_BGQ_Z
      FROM TL_TSSH.JKGL_DATA_BGQ T1
     WHERE T1.DJXH=CUR_BGQ.DJXH AND T1.BGQ_Q>=CUR_BGQ.BGQ_Q AND T1.BGQ_Z<=CUR_BGQ.BGQ_Z
       AND T1.ZQLX='季'
       AND T1.SXZT='3' AND T1.ZZS_ZT='Y' AND T1.DZDZ_ZT='Y' AND T1.DZSP_ZT='Y';
    IF V_JDNUM=0 THEN
      CONTINUE;
    ELSIF V_JDNUM>4 THEN
      CONTINUE;
    END IF;
    
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
    
    SELECT SUM(T2.CK_BGDSL), SUM(T2.CK_CKEUSD), SUM(T2.CK_CKERMB), 
           SUM(T2.CK_BGDSL_DE), SUM(T2.CK_CKEUSD_DE), SUM(T2.CK_BGDSL_ST), 
           SUM(T2.CK_PXBGDSL), SUM(T2.CK_ZXBGDSL), 
           CASE WHEN SUM(T2.CK_ZXBGDSL)=0 THEN 0 ELSE SUM(T2.CK_PJDBHGZ * T2.CK_ZXBGDSL) / SUM(T2.CK_ZXBGDSL) END,
           SUM(T2.TS_BGDSL), SUM(T2.TS_CKEUSD), SUM(T2.TS_CKERMB), SUM(T2.TS_MTSCKE), SUM(T2.TS_JSJE),
           SUM(T2.TS_BGDSL_CQ), SUM(T2.TS_CKEUSD_CQ),
           SUM(T2.TS_TSE_SB), SUM(T2.TS_MDE_SB),
           SUM(T2.TS_TSE_HZ), SUM(T2.TS_MDE_HZ),
           SUM(T2.TS_TSE_BL), SUM(T2.TS_MDE_BL),
           SUM(T2.TS_CKERMB_STZC),
           SUM(T2.TS_JHFP_FS), SUM(T2.TS_JHFP_JE),
           SUM(T2.TS_JHFP_FS_CQ1), SUM(T2.TS_JHFP_JE_CQ1),
           SUM(T2.TS_JHFP_FS_CQ2), SUM(T2.TS_JHFP_JE_CQ2),
           SUM(T2.TS_JHFP_FS_DG), SUM(T2.TS_JHFP_JE_DG),
           SUM(T2.ZZS_XSE_QB), SUM(T2.ZZS_XSE_MDT), SUM(T2.ZZS_XSE_MS),
           SUM(T2.ZZS_XXSE), SUM(T2.ZZS_JXSE), SUM(T2.ZZS_JXSEZC), SUM(T2.ZZS_MDTBDDKJXSE), SUM(T2.ZZS_YNSE),
           SUM(T2.DZ_XXFS_ZY), SUM(T2.DZ_XXJE_ZY), SUM(T2.DZ_XXSE_ZY), 
           SUM(T2.DZ_XXFS_PT), SUM(T2.DZ_XXJE_PT), SUM(T2.DZ_XXSE_PT), 
           SUM(T2.DZ_XXFS_QB), SUM(T2.DZ_XXJE_QB), SUM(T2.DZ_XXSE_QB), 
           SUM(T2.DZ_XXFS_CK), SUM(T2.DZ_XXJE_CK),
           SUM(T2.DZ_JXFS_ZY), SUM(T2.DZ_JXJE_ZY), SUM(T2.DZ_JXSE_ZY), 
           SUM(T2.DZ_JXFS_PT), SUM(T2.DZ_JXJE_PT), SUM(T2.DZ_JXSE_PT), 
           SUM(T2.DZ_JXFS_QB), SUM(T2.DZ_JXJE_QB), SUM(T2.DZ_JXSE_QB), 
           SUM(T2.DZ_JXFS_DGKJ), SUM(T2.DZ_JXJE_DGKJ), SUM(T2.DZ_JXSE_DGKJ),
           SUM(T2.DZ_JXSE_JKS), SUM(T2.DZ_JXJE_NCP), SUM(T2.DZ_JXSE_NCP), 
           SUM(T2.DZ_DFJE_SR), SUM(T2.DZ_DFJE_ZC), SUM(T2.DZ_WTJG), SUM(T2.DZ_YFJE), 
           SUM(T2.DZ_JXJE_SN), SUM(T2.DZ_JXJE_SW),
           SUM(T2.LR_YYSR), SUM(T2.LR_YYCB), SUM(T2.LR_XSFY), SUM(T2.LR_GLFY), SUM(T2.LR_LRZE), SUM(T2.LR_YYLR), 
           SUM(T2.LR_QTSR), SUM(T2.LR_SJJFJ), SUM(T2.LR_CWFY), SUM(T2.LR_JLR), SUM(T2.LR_SDS), SUM(T2.LR_LXZC)
      INTO V_CK_BGDSL, V_CK_CKEUSD, V_CK_CKERMB, 
           V_CK_BGDSL_DE, V_CK_CKEUSD_DE, V_CK_BGDSL_ST,
           V_CK_PXBGDSL, V_CK_ZXBGDSL, 
           V_CK_PJDBHGZ,
           V_TS_BGDSL, V_TS_CKEUSD, V_TS_CKERMB, V_TS_MTSCKE, V_TS_JSJE, 
           V_TS_BGDSL_CQ, V_TS_CKEUSD_CQ,
           V_TS_TSE_SB, V_TS_MDE_SB,
           V_TS_TSE_HZ, V_TS_MDE_HZ,
           V_TS_TSE_BL, V_TS_MDE_BL,
           V_TS_CKERMB_STZC,
           V_TS_JHFP_FS, V_TS_JHFP_JE, 
           V_TS_JHFP_FS_CQ1, V_TS_JHFP_JE_CQ1,
           V_TS_JHFP_FS_CQ2, V_TS_JHFP_JE_CQ2,
           V_TS_JHFP_FS_DG, V_TS_JHFP_JE_DG,
           V_ZZS_XSE_QB, V_ZZS_XSE_MDT, V_ZZS_XSE_MS, 
           V_ZZS_XXSE, V_ZZS_JXSE, V_ZZS_JXSEZC, V_ZZS_MDTBDDKJXSE, V_ZZS_YNSE,
           V_DZ_XXFS_ZY, V_DZ_XXJE_ZY, V_DZ_XXSE_ZY, 
           V_DZ_XXFS_PT, V_DZ_XXJE_PT, V_DZ_XXSE_PT,
           V_DZ_XXFS_QB, V_DZ_XXJE_QB, V_DZ_XXSE_QB,
           V_DZ_XXFS_CK, V_DZ_XXJE_CK,
           V_DZ_JXFS_ZY, V_DZ_JXJE_ZY, V_DZ_JXSE_ZY, 
           V_DZ_JXFS_PT, V_DZ_JXJE_PT, V_DZ_JXSE_PT,
           V_DZ_JXFS_QB, V_DZ_JXJE_QB, V_DZ_JXSE_QB,
           V_DZ_JXFS_DGKJ, V_DZ_JXJE_DGKJ, V_DZ_JXSE_DGKJ,
           V_DZ_JXSE_JKS, V_DZ_JXJE_NCP, V_DZ_JXSE_NCP,
           V_DZ_DFJE_SR, V_DZ_DFJE_ZC, V_DZ_WTJG, V_DZ_YFJE,
           V_DZ_JXJE_SN, V_DZ_JXJE_SW,
           V_LR_YYSR, V_LR_YYCB, V_LR_XSFY, V_LR_GLFY, V_LR_LRZE, V_LR_YYLR,
           V_LR_QTSR, V_LR_SJJFJ, V_LR_CWFY, V_LR_JLR, V_LR_SDS, V_LR_LXZC
      FROM TL_TSSH.JKGL_DATA_BGQ T1
     INNER JOIN TL_TSSH.JKGL_DATA_TJ_ZBU T2 ON T2.BGQID=T1.BGQID
     WHERE T1.DJXH=CUR_BGQ.DJXH AND T1.BGQ_Q>=CUR_BGQ.BGQ_Q AND T1.BGQ_Z<=V_BGQ_Z
       AND T1.ZQLX='季';
    
    SELECT COUNT(DISTINCT SBDWDM), COUNT(DISTINCT MYGDQSZ_DM)
      INTO V_CK_SBDW_SL, V_CK_GB_SL
      FROM (SELECT T.CKBGDH,T.MYLAJ,T.RMBLAJ,T.SBDWDM,T.MYGDQSZ_DM
              FROM TL_TSSH.CKTS_WBSJ_HG_BGD T
             WHERE T.DJXH=CUR_BGQ.DJXH
               AND T.CKRQ_1>=CUR_BGQ.BGQ_Q AND T.CKRQ_1<CUR_BGQ.BGQ_Z+1
               AND T.JGFS_DM<>'1039'
             UNION ALL
            SELECT S.CKBGDH,S.MYLAJ,S.RMBLAJ,S.SBDWDM,S.MYGDQSZ_DM
              FROM TL_TSSH.CKTS_WBSJ_ZJ_DLCKHWZM S
             WHERE S.DJXH=CUR_BGQ.DJXH
               AND S.CKRQ_1>=CUR_BGQ.BGQ_Q AND S.CKRQ_1<CUR_BGQ.BGQ_Z+1
               AND S.JGFS_DM<>'1039'
           ) TT;

    SELECT CK_CKEUSD_LASTYEAR, 
           ZC_YSZK_QM, ZC_YFZK_QM, ZC_GDZC_QM, ZC_CH_QM, ZC_ZCZE_QM, ZC_FZZE_QM,
           ZC_SYZQY_QM, ZC_SSGDQY_QM, ZC_LDZC_QM, ZC_YUSZK_QM, ZC_YUFZK_QM, ZC_LDFZZE_QM
      INTO V_CK_CKEUSD_LASTYEAR, 
           V_ZC_YSZK_QM, V_ZC_YFZK_QM, V_ZC_GDZC_QM, V_ZC_CH_QM, V_ZC_ZCZE_QM, V_ZC_FZZE_QM,
           V_ZC_SYZQY_QM, V_ZC_SSGDQY_QM, V_ZC_LDZC_QM, V_ZC_YUSZK_QM, V_ZC_YUFZK_QM, V_ZC_LDFZZE_QM
      FROM (SELECT T2.*, T1.BGQ_Z
              FROM TL_TSSH.JKGL_DATA_BGQ T1
             INNER JOIN TL_TSSH.JKGL_DATA_TJ_ZBU T2 ON T2.BGQID=T1.BGQID
             WHERE T1.DJXH=CUR_BGQ.DJXH AND T1.BGQ_Q>=CUR_BGQ.BGQ_Q AND T1.BGQ_Z<=V_BGQ_Z
               AND T1.ZQLX='季'
             ORDER BY T1.BGQ_Z DESC)
     WHERE ROWNUM=1;

    SELECT ZC_YSZK_QC, ZC_YFZK_QC, ZC_GDZC_QC, ZC_CH_QC, ZC_ZCZE_QC, ZC_FZZE_QC, 
           ZC_SYZQY_QC, ZC_SSGDQY_QC, ZC_LDZC_QC, ZC_YUSZK_QC, ZC_YUFZK_QC, ZC_LDFZZE_QC
      INTO V_ZC_YSZK_QC, V_ZC_YFZK_QC, V_ZC_GDZC_QC, V_ZC_CH_QC, V_ZC_ZCZE_QC, V_ZC_FZZE_QC,
           V_ZC_SYZQY_QC, V_ZC_SSGDQY_QC, V_ZC_LDZC_QC, V_ZC_YUSZK_QC, V_ZC_YUFZK_QC, V_ZC_LDFZZE_QC
      FROM (SELECT T2.*, T1.BGQ_Z
              FROM TL_TSSH.JKGL_DATA_BGQ T1
             INNER JOIN TL_TSSH.JKGL_DATA_TJ_ZBU T2 ON T2.BGQID=T1.BGQID
             WHERE T1.DJXH=CUR_BGQ.DJXH AND T1.BGQ_Q>=CUR_BGQ.BGQ_Q AND T1.BGQ_Z<=V_BGQ_Z
               AND T1.ZQLX='季'
             ORDER BY T1.BGQ_Z ASC)
     WHERE ROWNUM=1;

    V_TS_HHCB := CASE WHEN V_TS_MTSCKE>0 AND V_TS_JSJE>0 THEN ROUND(100*V_TS_JSJE/V_TS_MTSCKE,2) ELSE NULL END;

    SELECT COUNT(DISTINCT T.GHFNSRSBH_1)
      INTO V_TS_GHS_NUM
      FROM TL_TSSH.CKTS_SB_MTS_JHMX T
     WHERE T.DJXH=CUR_BGQ.DJXH
       AND T.SBRQ>=CUR_BGQ.BGQ_Q AND T.SBRQ<V_BGQ_Z+1
       AND T.SZ='V' AND NVL(T.BYBLBZ,'N')='N';

    UPDATE TL_TSSH.JKGL_DATA_TJ_ZBU
       SET CK_BGDSL=V_CK_BGDSL,
           CK_CKEUSD=V_CK_CKEUSD,
           CK_CKERMB=V_CK_CKERMB,
           CK_BGDSL_DE=V_CK_BGDSL_DE,
           CK_CKEUSD_DE=V_CK_CKEUSD_DE,
           CK_BGDSL_ST=V_CK_BGDSL_ST,
           CK_PXBGDSL=V_CK_PXBGDSL,
           CK_ZXBGDSL=V_CK_ZXBGDSL,
           CK_PJDBHGZ=V_CK_PJDBHGZ,
           CK_SBDW_SL=V_CK_SBDW_SL,
           CK_GB_SL=V_CK_GB_SL,
           CK_CKEUSD_LASTYEAR=V_CK_CKEUSD_LASTYEAR,
           TS_BGDSL=V_TS_BGDSL,
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
           TS_JHFP_JE_DG=V_TS_JHFP_JE_DG,
           TS_JHFP_FS_DG=V_TS_JHFP_FS_DG,
           TS_JHFP_JE=V_TS_JHFP_JE,
           TS_JHFP_FS=V_TS_JHFP_FS,
           TS_GHS_NUM=V_TS_GHS_NUM,
           TS_JHFP_FS_CQ1=V_TS_JHFP_FS_CQ1,
           TS_JHFP_JE_CQ1=V_TS_JHFP_JE_CQ1,
           TS_JHFP_FS_CQ2=V_TS_JHFP_FS_CQ2,
           TS_JHFP_JE_CQ2=V_TS_JHFP_JE_CQ2,
           ZZS_XSE_QB=V_ZZS_XSE_QB, 
           ZZS_XSE_MDT=V_ZZS_XSE_MDT, 
           ZZS_XSE_MS=V_ZZS_XSE_MS, 
           ZZS_XXSE=V_ZZS_XXSE, 
           ZZS_JXSE=V_ZZS_JXSE,
           ZZS_JXSEZC=V_ZZS_JXSEZC,
           ZZS_YNSE=V_ZZS_YNSE,
           ZZS_MDTBDDKJXSE=V_ZZS_MDTBDDKJXSE,
           DZ_XXFS_ZY=V_DZ_XXFS_ZY, 
           DZ_XXJE_ZY=V_DZ_XXJE_ZY, 
           DZ_XXSE_ZY=V_DZ_XXSE_ZY, 
           DZ_XXFS_PT=V_DZ_XXFS_PT, 
           DZ_XXJE_PT=V_DZ_XXJE_PT,
           DZ_XXSE_PT=V_DZ_XXSE_PT,
           DZ_XXFS_QB=V_DZ_XXFS_QB,
           DZ_XXJE_QB=V_DZ_XXJE_QB,
           DZ_XXSE_QB=V_DZ_XXSE_QB,
           DZ_XXFS_CK=V_DZ_XXFS_CK,
           DZ_XXJE_CK=V_DZ_XXJE_CK,
           DZ_JXFS_ZY=V_DZ_JXFS_ZY, 
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
           DZ_JXJE_NCP=V_DZ_JXJE_NCP, 
           DZ_JXSE_NCP=V_DZ_JXSE_NCP,
           DZ_DFJE_SR=V_DZ_DFJE_SR, 
           DZ_DFJE_ZC=V_DZ_DFJE_ZC, 
           DZ_WTJG=V_DZ_WTJG, 
           DZ_YFJE=V_DZ_YFJE,
           DZ_JXJE_SN=V_DZ_JXJE_SN, 
           DZ_JXJE_SW=V_DZ_JXJE_SW, 
           ZC_YSZK_QC=V_ZC_YSZK_QC,
           ZC_YFZK_QC=V_ZC_YFZK_QC,
           ZC_GDZC_QC=V_ZC_GDZC_QC,
           ZC_CH_QC=V_ZC_CH_QC,
           ZC_ZCZE_QC=V_ZC_ZCZE_QC,
           ZC_FZZE_QC=V_ZC_FZZE_QC,
           ZC_SYZQY_QC=V_ZC_SYZQY_QC, 
           ZC_SSGDQY_QC=V_ZC_SSGDQY_QC, 
           ZC_LDZC_QC=V_ZC_LDZC_QC, 
           ZC_YUSZK_QC=V_ZC_YUSZK_QC, 
           ZC_YUFZK_QC=V_ZC_YUFZK_QC, 
           ZC_LDFZZE_QC=V_ZC_LDFZZE_QC,
           ZC_YSZK_QM=V_ZC_YSZK_QM,
           ZC_YFZK_QM=V_ZC_YFZK_QM,
           ZC_GDZC_QM=V_ZC_GDZC_QM,
           ZC_CH_QM=V_ZC_CH_QM,
           ZC_ZCZE_QM=V_ZC_ZCZE_QM,
           ZC_FZZE_QM=V_ZC_FZZE_QM,
           ZC_SYZQY_QM=V_ZC_SYZQY_QM, 
           ZC_SSGDQY_QM=V_ZC_SSGDQY_QM, 
           ZC_LDZC_QM=V_ZC_LDZC_QM, 
           ZC_YUSZK_QM=V_ZC_YUSZK_QM, 
           ZC_YUFZK_QM=V_ZC_YUFZK_QM, 
           ZC_LDFZZE_QM=V_ZC_LDFZZE_QM,
           LR_YYSR=V_LR_YYSR,
           LR_YYCB=V_LR_YYCB,
           LR_XSFY=V_LR_XSFY,
           LR_GLFY=V_LR_GLFY,
           LR_LRZE=V_LR_LRZE,
           LR_YYLR=V_LR_YYLR,
           LR_QTSR=V_LR_QTSR, 
           LR_SJJFJ=V_LR_SJJFJ, 
           LR_CWFY=V_LR_CWFY, 
           LR_JLR=V_LR_JLR, 
           LR_SDS=V_LR_SDS, 
           LR_LXZC=V_LR_LXZC
     WHERE BGQID=CUR_BGQ.BGQID;
    COMMIT;
    
    --年度基期ID
    BEGIN
      SELECT T.BGQID
        INTO V_NDJQID
        FROM TL_TSSH.JKGL_DATA_BGQ T
       WHERE T.DJXH=CUR_BGQ.DJXH AND T.BGQ_Q=ADD_MONTHS(CUR_BGQ.BGQ_Q,-12) AND T.BGQ_Z=CUR_BGQ.BGQ_Q-1
         AND T.SXZT='2';
    EXCEPTION
      WHEN OTHERS THEN
        V_NDJQID :=0;
    END;
    
    --计算 JKGL_DATA_TJ_ZBU_KZ.BGQID
    SELECT COUNT(1)
      INTO V_ROWS
      FROM TL_TSSH.JKGL_DATA_TJ_ZBU_KZ T
     WHERE T.BGQID=CUR_BGQ.BGQID AND ROWNUM=1;
    IF V_ROWS=0 THEN
      INSERT INTO TL_TSSH.JKGL_DATA_TJ_ZBU_KZ(BGQID) VALUES (CUR_BGQ.BGQID);
      COMMIT;
    END IF;
    
    UPDATE TL_TSSH.JKGL_DATA_TJ_ZBU_KZ T
       SET (CW_MLL,CW_HYSFL,CW_YYLRL,CW_CBFYLRL,CW_ZZCBCL,CW_JZCSYL,CW_ZZCZZL,CW_LDBL,CW_SDBL,CW_ZCFZL,CW_CHZZL,CW_YSZKZZL)=(
    SELECT --毛利率=100%*（主营业务收入-主营业务成本）/主营业务收入
           CASE WHEN (LR_YYSR IS NOT NULL) AND (LR_YYSR<>0) 
                THEN LEAST(GREATEST(ROUND(100*(LR_YYSR-LR_YYCB)/LR_YYSR,2),-900),100)
                ELSE NULL 
           END,
           --行业税负率=100%*（0.13*（增值税全部销售额+期末存货-期初存货）-进项税额+进项税额转出）/增值税全部销售额
           CASE WHEN (ZZS_XSE_QB IS NOT NULL) AND (ZZS_XSE_QB<>0)
                THEN LEAST(GREATEST(ROUND(100*(0.13*(ZZS_XSE_QB+ZC_CH_QM-ZC_CH_QC)-ZZS_JXSE+ZZS_JXSEZC)/ZZS_XSE_QB,2),-100),100)
                ELSE NULL 
           END,
           --营业利润率=100%*营业利润/全部收入=100%*营业利润/（主营业务收入+其它收入）
           CASE WHEN (LR_YYSR IS NOT NULL) AND (LR_QTSR IS NOT NULL) AND (LR_YYSR+LR_QTSR<>0)
                THEN LEAST(GREATEST(ROUND(100*LR_YYLR/(LR_YYSR+LR_QTSR),2),-900),100)
                ELSE NULL 
           END,
           --成本费用利润率=100%*利润总额/成本费用总额=100%*利润总额/（主营业务成本+税金及附加+销售费用+管理费用+财务费用）
           CASE WHEN (LR_YYCB IS NOT NULL) AND (LR_SJJFJ IS NOT NULL) AND (LR_XSFY IS NOT NULL) AND (LR_GLFY IS NOT NULL) 
                     AND (LR_CWFY IS NOT NULL) AND (LR_YYCB+LR_SJJFJ+LR_XSFY+LR_GLFY+LR_CWFY<>0)
                THEN LEAST(GREATEST(ROUND(100*LR_LRZE/(LR_YYCB+LR_SJJFJ+LR_XSFY+LR_GLFY+LR_CWFY),2),-1100),100)
                ELSE NULL 
           END,
           --总资产报酬率=100%*息税前利润/资产平均总额=200%*（净利润+所得税+利息支出）/（年初资产总额+年末资产总额）
           CASE WHEN (ZC_ZCZE_QC IS NOT NULL) AND (ZC_ZCZE_QM IS NOT NULL) AND (ZC_ZCZE_QC+ZC_ZCZE_QM<>0)
                THEN LEAST(GREATEST(ROUND(200*(LR_JLR+LR_SDS+LR_LXZC)/(ZC_ZCZE_QC+ZC_ZCZE_QM),2),-100),1000)
                ELSE NULL 
           END,
           --净资产收益率=100%*净利润/净资产=100%*净利润/（所有者权益+少数股东权益）
           CASE WHEN (ZC_SYZQY_QM IS NOT NULL) AND (ZC_SSGDQY_QM IS NOT NULL) AND (ZC_SYZQY_QM+ZC_SSGDQY_QM<>0)
                THEN LEAST(GREATEST(ROUND(100*LR_JLR/(ZC_SYZQY_QM+ZC_SSGDQY_QM),2),-100),1000)
                ELSE NULL 
           END,
           --总资产增长率=100%*（年末资产总额-年初资产总额）/年初资产总额
           CASE WHEN (ZC_ZCZE_QC IS NOT NULL) AND (ZC_ZCZE_QC<>0)
                THEN LEAST(GREATEST(ROUND(100*(ZC_ZCZE_QM-ZC_ZCZE_QC)/ZC_ZCZE_QC,2),-100),1000)
                ELSE NULL 
           END,
           --流动比率=100%*流动资产总额/流动负债总额
           CASE WHEN (ZC_LDFZZE_QM IS NOT NULL) AND (ZC_LDFZZE_QM<>0)
                THEN LEAST(GREATEST(ROUND(100*ZC_LDZC_QM/ZC_LDFZZE_QM,2),10),1000)
                ELSE NULL 
           END,
           --速动比率=100%*速动资产总额/流动负债总额=100%*（流动资产-预付账款-存货）/流动负债总额
           CASE WHEN (ZC_LDFZZE_QM IS NOT NULL) AND (ZC_LDFZZE_QM<>0)
                THEN LEAST(GREATEST(ROUND(100*(ZC_LDZC_QM-ZC_YUFZK_QM-ZC_CH_QM)/ZC_LDFZZE_QM,2),10),1000)
                ELSE NULL 
           END,
           --资产负债率=100%*负债总额/资产总额
           CASE WHEN (ZC_ZCZE_QM IS NOT NULL) AND (ZC_ZCZE_QM<>0)
                THEN LEAST(GREATEST(ROUND(100*ZC_FZZE_QM/ZC_ZCZE_QM,2),10),1000)
                ELSE NULL 
           END,
           --存货周转率=营业成本/平均存货=2*营业成本/(期末存货+期初存货)
           CASE WHEN (ZC_CH_QC IS NOT NULL) AND (ZC_CH_QM IS NOT NULL) AND (ZC_CH_QC+ZC_CH_QM<>0)
                THEN LEAST(GREATEST(ROUND(2*LR_YYCB/(ZC_CH_QC+ZC_CH_QM),2),0),360)
                ELSE NULL 
           END,
           --应收账款周转率=2*当期销售净收入/（期初应收账款+期末应收账款
           CASE WHEN (ZC_YSZK_QC IS NOT NULL) AND (ZC_YSZK_QM IS NOT NULL) AND (ZC_YSZK_QC+ZC_YSZK_QM<>0)
                THEN LEAST(GREATEST(ROUND(200*LR_YYSR/(ZC_YSZK_QC+ZC_YSZK_QM),2),0),360)
                ELSE NULL 
           END
      FROM TL_TSSH.JKGL_DATA_TJ_ZBU
     WHERE BGQID=CUR_BGQ.BGQID)
     WHERE BGQID=CUR_BGQ.BGQID;
           
    UPDATE TL_TSSH.JKGL_DATA_TJ_ZBU_KZ T
       SET (CW_YYSRTBZZL,CW_JLRTBZZL,CK_CKUSD_TB,TS_TMSE_TB)=(
    SELECT --营业收入同比增长率=100%*（当期营业收入-上期营业收入）/上期营业收入
           CASE WHEN (B.LR_YYSR IS NOT NULL) AND (B.LR_YYSR<>0) 
                THEN LEAST(GREATEST(ROUND(100*(A.LR_YYSR-B.LR_YYSR)/B.LR_YYSR,2),-6000),6000)
                ELSE NULL 
           END,
           --净利润同比增长率=100%*（当期净利润-上期净利润）/上期净利润
           CASE WHEN (B.LR_JLR IS NOT NULL) AND (B.LR_JLR<>0) 
                THEN LEAST(GREATEST(ROUND(100*(A.LR_JLR-B.LR_JLR)/B.LR_JLR,2),-6000),6000)
                ELSE NULL 
           END,
           --美元出口额同比=100%*当期出口额USD/上期出口额USD
           CASE WHEN (B.CK_CKEUSD IS NOT NULL) AND (B.CK_CKEUSD>0) 
                THEN LEAST(GREATEST(ROUND(100*A.CK_CKEUSD/B.CK_CKEUSD,2),0),6000)
                ELSE NULL 
           END,
           --申报退免税额同比=100%*当期申报退免税额/上期申报退免税额
           CASE WHEN (B.TS_MDE_SB IS NOT NULL) AND (B.TS_TSE_SB IS NOT NULL) AND (B.TS_MDE_SB+B.TS_TSE_SB>0) 
                THEN LEAST(GREATEST(ROUND(100*(A.TS_MDE_SB+A.TS_TSE_SB)/(B.TS_MDE_SB+B.TS_TSE_SB),2),0),6000)
                ELSE NULL 
           END
      FROM TL_TSSH.JKGL_DATA_TJ_ZBU A, TL_TSSH.JKGL_DATA_TJ_ZBU B
     WHERE A.BGQID=CUR_BGQ.BGQID AND B.BGQID=V_NDJQID)
     WHERE BGQID=CUR_BGQ.BGQID;

    --计算 JKGL_DATA_TJ_ZBU_CKGB.BGQID
    MERGE INTO JKGL_DATA_TJ_ZBU_CKGB A
         USING (SELECT CUR_BGQ.BGQID AS BGQID, MYGDQSZ_DM AS GB_DM, SUM(MYLAJ) AS CKEUSD, SUM(RMBLAJ) AS CKERMB,
                       COUNT(DISTINCT SUBSTR(HGGQKA_DM,1,2)) AS KASL, COUNT(DISTINCT SBDWDM) AS SBDWSL, COUNT(DISTINCT YSFS_DM) AS YSFSSL
                  FROM (SELECT T.CKBGDH,T.MYLAJ,T.RMBLAJ,T.SBDWDM,T.MYGDQSZ_DM,T.HGGQKA_DM,T.YSFS_DM,T.CKSP_DM,T.CKSL
                          FROM TL_TSSH.CKTS_WBSJ_HG_BGD T
                         WHERE T.DJXH=CUR_BGQ.DJXH
                           AND T.CKRQ_1>=CUR_BGQ.BGQ_Q AND T.CKRQ_1<CUR_BGQ.BGQ_Z+1
                           AND T.JGFS_DM<>'1039'
                         UNION ALL
                        SELECT S.CKBGDH,S.MYLAJ,S.RMBLAJ,S.SBDWDM,S.MYGDQSZ_DM,S.HGGQKA_DM,S.YSFS_DM,S.CKSP_DM,S.CKSL
                          FROM TL_TSSH.CKTS_WBSJ_ZJ_DLCKHWZM S
                         WHERE S.DJXH=CUR_BGQ.DJXH
                           AND S.CKRQ_1>=CUR_BGQ.BGQ_Q AND S.CKRQ_1<CUR_BGQ.BGQ_Z+1
                           AND S.JGFS_DM<>'1039'
                       ) TT
                 GROUP BY MYGDQSZ_DM) B
            ON (A.BGQID=B.BGQID AND A.GB_DM=B.GB_DM)
          WHEN MATCHED THEN
            UPDATE SET A.CKEUSD=B.CKEUSD, A.CKERMB=B.CKERMB, A.KASL=B.KASL, A.SBDWSL=B.SBDWSL, A.YSFSSL=B.YSFSSL
          WHEN NOT MATCHED THEN
            INSERT (ID,BGQID,GB_DM,CKEUSD,CKERMB,KASL,SBDWSL,YSFSSL)
            VALUES (SEQ_JKGL_DATA_TJ_ZBU_CKGB.NEXTVAL,B.BGQID,B.GB_DM,B.CKEUSD,B.CKERMB,B.KASL,B.SBDWSL,B.YSFSSL);
    COMMIT;
    
    --计算 JKGL_DATA_TJ_ZBU_CKKA.BGQID
    MERGE INTO JKGL_DATA_TJ_ZBU_CKKA A
         USING (SELECT CUR_BGQ.BGQID AS BGQID, HGGQKA_DM AS KA_DM, SUM(MYLAJ) AS CKEUSD, SUM(RMBLAJ) AS CKERMB,
                       COUNT(DISTINCT SBDWDM) AS SBDWSL
                  FROM (SELECT T.CKBGDH,T.MYLAJ,T.RMBLAJ,T.SBDWDM,T.MYGDQSZ_DM,T.HGGQKA_DM,T.YSFS_DM,T.CKSP_DM,T.CKSL
                          FROM TL_TSSH.CKTS_WBSJ_HG_BGD T
                         WHERE T.DJXH=CUR_BGQ.DJXH
                           AND T.CKRQ_1>=CUR_BGQ.BGQ_Q AND T.CKRQ_1<CUR_BGQ.BGQ_Z+1
                           AND T.JGFS_DM<>'1039'
                         UNION ALL
                        SELECT S.CKBGDH,S.MYLAJ,S.RMBLAJ,S.SBDWDM,S.MYGDQSZ_DM,S.HGGQKA_DM,S.YSFS_DM,S.CKSP_DM,S.CKSL
                          FROM TL_TSSH.CKTS_WBSJ_ZJ_DLCKHWZM S
                         WHERE S.DJXH=CUR_BGQ.DJXH
                           AND S.CKRQ_1>=CUR_BGQ.BGQ_Q AND S.CKRQ_1<CUR_BGQ.BGQ_Z+1
                           AND S.JGFS_DM<>'1039'
                       ) TT
                 GROUP BY HGGQKA_DM) B
            ON (A.BGQID=B.BGQID AND A.KA_DM=B.KA_DM)
          WHEN MATCHED THEN
            UPDATE SET A.CKEUSD=B.CKEUSD, A.CKERMB=B.CKERMB, A.SBDWSL=B.SBDWSL
          WHEN NOT MATCHED THEN
            INSERT (ID,BGQID,KA_DM,CKEUSD,CKERMB,SBDWSL)
            VALUES (SEQ_JKGL_DATA_TJ_ZBU_CKKA.NEXTVAL,B.BGQID,B.KA_DM,B.CKEUSD,B.CKERMB,B.SBDWSL);
    COMMIT;

    --计算 JKGL_DATA_TJ_ZBU_CKSP.BGQID
    MERGE INTO JKGL_DATA_TJ_ZBU_CKSP A
         USING (SELECT CUR_BGQ.BGQID AS BGQID, SUBSTR(CKSP_DM,1,8) AS SP8_DM, SUM(MYLAJ) AS CKEUSD, SUM(RMBLAJ) AS CKERMB,
                       SUM(CKSL) AS CKSL, CASE WHEN SUM(CKSL)=0 THEN NULL ELSE SUM(RMBLAJ)/SUM(CKSL) END AS CKDJ
                  FROM (SELECT T.CKBGDH,T.MYLAJ,T.RMBLAJ,T.SBDWDM,T.MYGDQSZ_DM,T.HGGQKA_DM,T.YSFS_DM,T.CKSP_DM,T.CKSL
                          FROM TL_TSSH.CKTS_WBSJ_HG_BGD T
                         WHERE T.DJXH=CUR_BGQ.DJXH
                           AND T.CKRQ_1>=CUR_BGQ.BGQ_Q AND T.CKRQ_1<CUR_BGQ.BGQ_Z+1
                           AND T.JGFS_DM<>'1039'
                         UNION ALL
                        SELECT S.CKBGDH,S.MYLAJ,S.RMBLAJ,S.SBDWDM,S.MYGDQSZ_DM,S.HGGQKA_DM,S.YSFS_DM,S.CKSP_DM,S.CKSL
                          FROM TL_TSSH.CKTS_WBSJ_ZJ_DLCKHWZM S
                         WHERE S.DJXH=CUR_BGQ.DJXH
                           AND S.CKRQ_1>=CUR_BGQ.BGQ_Q AND S.CKRQ_1<CUR_BGQ.BGQ_Z+1
                           AND S.JGFS_DM<>'1039'
                       ) TT
                 GROUP BY SUBSTR(CKSP_DM,1,8)) B
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
                       ROUND(MONTHS_BETWEEN(V_BGQ_Z,TRUNC(T.DJRQ,'MM'))) AS JYYFSL,
                       CASE WHEN NVL(T.SCCKRQ,DATE'2100-12-31')>V_BGQ_Z THEN NULL 
                            ELSE ROUND(MONTHS_BETWEEN(V_BGQ_Z,TRUNC(T.SCCKRQ,'MM'))) END AS CKYFSL,
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
    DELETE FROM TL_TSSH.JKGL_DATA_TJ_ZBU_TSGH T
     WHERE T.BGQID=CUR_BGQ.BGQID
       AND NOT EXISTS (SELECT 1 
                         FROM TL_TSSH.CKTS_SB_MTS_JHMX S 
                        WHERE S.DJXH=CUR_BGQ.DJXH AND S.SBRQ>=CUR_BGQ.BGQ_Q AND S.SBRQ<V_BGQ_Z+1
                          AND S.GHFNSRSBH_1=T.GHFSH);
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

    --解锁处理完成的报告期
    UPDATE TL_TSSH.JKGL_DATA_BGQ T
       SET T.TQBZ=NULL, T.WCSJ=SYSDATE, T.SXZT='2', 
           T.ZZS_ZT='Y', T.DZSP_ZT='Y', T.DZDZ_ZT='Y', 
           T.ZBU_DZGF_ZT='N', T.ZBU_DZXF_ZT='N', T.ZBU_DZSPJX_ZT='N', T.ZBU_DZSPXX_ZT='N'
     WHERE T.BGQID=CUR_BGQ.BGQID;
    COMMIT;

    -- 后续需要通过ETL抽取的数据
    --  V_SDS_

  END LOOP;

  RETURN;
END;
/
