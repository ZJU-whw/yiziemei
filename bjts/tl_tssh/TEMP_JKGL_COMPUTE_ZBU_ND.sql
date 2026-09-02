CREATE OR REPLACE PROCEDURE TEMP_JKGL_COMPUTE_ZBU_ND
/*
 * 年度指标元刷新算法
 * 202309，增加代理出口统计
 * 20260714，根据龙泉税局反馈，修正年度报表财务期初数据取数口径
 */
AS
  V_ZC_YSZK_QC      NUMBER(18,2); --  资产_应收账款_期初
  V_ZC_YFZK_QC      NUMBER(18,2); --  资产_应付账款_期初
  V_ZC_GDZC_QC      NUMBER(18,2); --  资产_固定资产_期初
  V_ZC_CH_QC        NUMBER(18,2); --  资产_存货_期初
  V_ZC_ZCZE_QC      NUMBER(18,2); --  资产_资产总额_期初
  V_ZC_FZZE_QC      NUMBER(18,2); --  资产_负债总额_期初
  V_ZC_SYZQY_QC     NUMBER(18,2); --  资产_所有者权益_期初
  V_ZC_SSGDQY_QC    NUMBER(18,2); --  资产_少数股东权益_期初
  V_ZC_LDZC_QC      NUMBER(18,2); --  资产_流动资产_期初
  V_ZC_YUSZK_QC     NUMBER(18,2); --  资产_预收账款_期初
  V_ZC_YUFZK_QC     NUMBER(18,2); --  资产_预付账款_期初
  V_ZC_LDFZZE_QC    NUMBER(18,2); --  资产_流动负债总额_期初
BEGIN
  FOR CUR_BGQ IN (SELECT T.BGQID, T.ZQLX, T.DJXH, 
                         T.BGQ_Q, T.BGQ_Z, TO_CHAR(T.BGQ_Q,'YYYYMM') AS YF_Q, TO_CHAR(T.BGQ_Z,'YYYYMM') AS YF_Z
                    FROM TL_TSSH.JKGL_DATA_BGQ T
                   WHERE T.ZQLX='年' AND T.SXZT='0' AND T.TQBZ IS NULL
                 )
  LOOP
    --锁定正在处理的报告期
    UPDATE TL_TSSH.JKGL_DATA_BGQ T
       SET T.TQBZ=SYS_GUID(), T.TQSJ=SYSDATE, T.SXZT='1'
     WHERE T.BGQID=CUR_BGQ.BGQID;
    COMMIT;

    SELECT ZC_YSZK_QC, ZC_YFZK_QC, ZC_GDZC_QC, ZC_CH_QC, ZC_ZCZE_QC, ZC_FZZE_QC, 
           ZC_SYZQY_QC, ZC_SSGDQY_QC, ZC_LDZC_QC, ZC_YUSZK_QC, ZC_YUFZK_QC, ZC_LDFZZE_QC
      INTO V_ZC_YSZK_QC, V_ZC_YFZK_QC, V_ZC_GDZC_QC, V_ZC_CH_QC, V_ZC_ZCZE_QC, V_ZC_FZZE_QC,
           V_ZC_SYZQY_QC, V_ZC_SSGDQY_QC, V_ZC_LDZC_QC, V_ZC_YUSZK_QC, V_ZC_YUFZK_QC, V_ZC_LDFZZE_QC
      FROM (SELECT T2.*, T1.BGQ_Z
              FROM TL_TSSH.JKGL_DATA_BGQ T1
             INNER JOIN TL_TSSH.JKGL_DATA_TJ_ZBU T2 ON T2.BGQID=T1.BGQID
             WHERE T1.DJXH=CUR_BGQ.DJXH AND T1.BGQ_Q>=CUR_BGQ.BGQ_Q AND T1.BGQ_Z<=CUR_BGQ.BGQ_Z
               AND T1.ZQLX='季'
             ORDER BY T1.BGQ_Z ASC)
     WHERE ROWNUM=1;

    UPDATE TL_TSSH.JKGL_DATA_TJ_ZBU
       SET ZC_YSZK_QC=V_ZC_YSZK_QC,
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
           ZC_LDFZZE_QC=V_ZC_LDFZZE_QC
     WHERE BGQID=CUR_BGQ.BGQID;
    COMMIT;
    
    UPDATE TL_TSSH.JKGL_DATA_TJ_ZBU_KZ T
       SET (CW_HYSFL,CW_ZZCBCL,CW_ZZCZZL,CW_CHZZL,CW_YSZKZZL)=(
    SELECT --行业税负率=100%*（0.13*（增值税全部销售额+期末存货-期初存货）-进项税额+进项税额转出）/增值税全部销售额
           CASE WHEN (ZZS_XSE_QB IS NOT NULL) AND (ZZS_XSE_QB<>0)
                THEN LEAST(GREATEST(ROUND(100*(0.13*(ZZS_XSE_QB+ZC_CH_QM-ZC_CH_QC)-ZZS_JXSE+ZZS_JXSEZC)/ZZS_XSE_QB,2),-100),100)
                ELSE NULL 
           END,
           --总资产报酬率=100%*息税前利润/资产平均总额=200%*（净利润+所得税+利息支出）/（年初资产总额+年末资产总额）
           CASE WHEN (ZC_ZCZE_QC IS NOT NULL) AND (ZC_ZCZE_QM IS NOT NULL) AND (ZC_ZCZE_QC+ZC_ZCZE_QM<>0)
                THEN LEAST(GREATEST(ROUND(200*(LR_JLR+LR_SDS+LR_LXZC)/(ZC_ZCZE_QC+ZC_ZCZE_QM),2),-100),1000)
                ELSE NULL 
           END,
           --总资产增长率=100%*（年末资产总额-年初资产总额）/年初资产总额
           CASE WHEN (ZC_ZCZE_QC IS NOT NULL) AND (ZC_ZCZE_QC<>0)
                THEN LEAST(GREATEST(ROUND(100*(ZC_ZCZE_QM-ZC_ZCZE_QC)/ZC_ZCZE_QC,2),-100),1000)
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
