CREATE OR REPLACE PROCEDURE PRO_FXGL_DATA_FZPCKQY
/*
 * 纺织品出口企业风险指标提取过程
 */
AS
BEGIN
  -- 1、先运行zj_bjts用户下的PRO_DEAL_FXGL_DATA_FZPCKQY存储过程，获取FXGL_DATA_FZPCKQY企业信息
  -- 2、调用ETL抽取进销项发票数据到FXGL_DATA_FZPCKQY_FPXX表中
  -- 数据抽取逻辑如下
/*
  INSERT INTO FXGL_DATA_FZPCKQY_FPXX
         (FPHM,XH,KPRQ,XSFNSRSBH,XSFMC,XHFDJXH,GMFNSRSBH,GMFMC,GMFDJXH,SPHFWSSFLHBBM,SPFWJC,XMMC,GGXH,DW,FPSPDJ,FPSPSL,JE,SL_1,SE,SPBM5,SL)
  SELECT HW.FPHM,HW.XH,HW.KPRQ,
         FP.XSFNSRSBH,FP.XSFMC,FP.XHFDJXH,
         FP.GMFNSRSBH,FP.GMFMC,FP.GMFDJXH,
         HW.SPHFWSSFLHBBM,HW.SPFWJC,HW.XMMC,HW.GGXH,
         UPPER(HW.DW),
         HW.FPSPDJ,HW.FPSPSL,HW.JE,HW.SL_1,HW.SE,
         SUBSTR(HW.SPHFWSSFLHBBM,1,5),TO_NUMBER(HW.FPSPSL)
    FROM DZFP_KPYW_FPJCXXB FP
   INNER JOIN DZFP_KPYW_FPMXXXB HW
      ON HW.FPHM=FP.FPHM
   WHERE FP.KPRQ >= LD_FXRQQ AND FP.KPRQ < LD_FXRQZ
     AND (FP.XSFNSRSBH IN (SELECT NSRSBH FROM FXGL_DATA_FZPCKQY) OR
         FP.GMFNSRSBH IN (SELECT NSRSBH FROM FXGL_DATA_FZPCKQY));
  COMMIT;
*/

  EXECUTE IMMEDIATE 'TRUNCATE TABLE FXGL_DATA_FZPCKQY_JXMX';
  COMMIT;

  -- 进项发票（采购原材料）按商品大类、名称分组
  INSERT INTO FXGL_DATA_FZPCKQY_JXMX
         (DJXH,SPBM5,XMMC,DW,SL,JE,SE)
  SELECT FP.GMFDJXH,FP.SPBM5,FP.XMMC,FP.DW,SUM(TO_NUMBER(FP.FPSPSL)),SUM(FP.JE),SUM(FP.SE)
    FROM FXGL_DATA_FZPCKQY_FPXX FP
   WHERE FP.GMFDJXH IS NOT NULL
     AND FP.SPBM5 IN ('10401', '10704')
     AND FP.SE <> 0 --出口单证不算
     AND (FP.DW NOT IN ('T', '吨', 'KM', '千米') OR
         (FP.DW IN ('T', '吨', 'KM', '千米') AND TO_NUMBER(FP.FPSPDJ)>100))  --单价过低的吨和千米，应该是发票开错，应为公斤或米，不参与计算
   GROUP BY FP.GMFDJXH,FP.SPBM5,FP.XMMC,FP.DW;
  COMMIT;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE FXGL_DATA_FZPCKQY_JXXX';
  COMMIT;

  -- 进项发票（采购原材料）按商品大类、名称分组统计
  INSERT INTO FXGL_DATA_FZPCKQY_JXXX
         (DJXH,SPBM5,JH_SL_KG,JH_JE_KG,JH_DJ_KG,JH_DJ_KG_PJ,JH_SL_M,JH_JE_M,JH_DJ_M,JH_DJ_M_PJ,JH_JE_NOTKG,JH_GJ_M)
  WITH
  MD AS (
  SELECT DJXH, NVL(CK_GJ_M,CK_GJ_M_PJ) AS JH_GJ_M, '10401' AS SPBM5
    FROM FXGL_DATA_FZPCKQY
   UNION
  SELECT DJXH, NVL(CK_GJ_M,CK_GJ_M_PJ) AS JH_GJ_M, '10704' AS SPBM5
    FROM FXGL_DATA_FZPCKQY
  ),
  JX_KG AS ( --重量单位计算
  SELECT DJXH,
         SPBM5,
         SUM(CASE
               WHEN DW IN ('T', '吨') THEN SL * 1000
               WHEN DW IN ('KG', '公斤', '千克') THEN SL
               ELSE 0
             END) AS JX_SL_KG,
         SUM(JE) AS JX_JE_KG,
         CASE
           WHEN SUM(ABS(JE)) =0
             OR SUM(ABS(JE)) IS NULL
             OR SUM(CASE
                      WHEN DW IN ('T', '吨') THEN
                        ABS(SL) * 1000
                      WHEN DW IN ('KG', '公斤', '千克') THEN
                        ABS(SL)
                      ELSE
                        0
                    END)=0
             OR SUM(CASE
                      WHEN DW IN ('T', '吨') THEN
                        ABS(SL) * 1000
                      WHEN DW IN ('KG', '公斤', '千克') THEN
                        ABS(SL)
                      ELSE
                        0
                    END) IS NULL
           THEN NULL
           ELSE SUM(ABS(JE)) /
                SUM(CASE
                      WHEN DW IN ('T', '吨') THEN
                        ABS(SL) * 1000
                      WHEN DW IN ('KG', '公斤', '千克') THEN
                        ABS(SL)
                      ELSE
                        0
                    END)
         END  AS JX_DJ_KG
    FROM FXGL_DATA_FZPCKQY_JXMX
   WHERE DW IN ('T', '吨', 'KG', '公斤', '千克')
   GROUP BY DJXH,SPBM5
  ),
  DJALL_KG AS (
  SELECT SPBM5,
         SUM(ABS(JX_JE_KG)) / SUM(ABS(JX_SL_KG)) AS JX_DJ_KG_PJ
    FROM JX_KG
   GROUP BY SPBM5
  ),
  JX_M AS ( --长度单位计算
  SELECT DJXH,
         SPBM5,
         SUM(CASE
               WHEN DW IN ('KM', '千米') THEN SL*1000
               WHEN DW IN ('百米') THEN SL*100
               WHEN DW IN ('M', '米') THEN SL
               WHEN DW IN ('码') THEN SL*0.9144
               ELSE 0
             END) AS JX_SL_M,
         SUM(JE) AS JX_JE_M,
         CASE
           WHEN SUM(ABS(JE)) =0
             OR SUM(ABS(JE)) IS NULL
             OR SUM(CASE
                      WHEN DW IN ('KM', '千米') THEN ABS(SL)*1000
                      WHEN DW IN ('百米') THEN ABS(SL)*100
                      WHEN DW IN ('M', '米') THEN ABS(SL)
                      WHEN DW IN ('码') THEN ABS(SL)*0.9144
                      ELSE 0
                    END)=0
             OR SUM(CASE
                      WHEN DW IN ('KM', '千米') THEN ABS(SL)*1000
                      WHEN DW IN ('百米') THEN ABS(SL)*100
                      WHEN DW IN ('M', '米') THEN ABS(SL)
                      WHEN DW IN ('码') THEN ABS(SL)*0.9144
                      ELSE 0
                    END) IS NULL
           THEN NULL
           ELSE SUM(ABS(JE)) /
                SUM(CASE
                      WHEN DW IN ('KM', '千米') THEN ABS(SL)*1000
                      WHEN DW IN ('百米') THEN ABS(SL)*100
                      WHEN DW IN ('M', '米') THEN ABS(SL)
                      WHEN DW IN ('码') THEN ABS(SL)*0.9144
                      ELSE 0
                    END)
         END AS JX_DJ_M
    FROM FXGL_DATA_FZPCKQY_JXMX
   WHERE DW IN ('KM', '千米', '百米', 'M', '米', '码')
     AND XMMC NOT LIKE '%带'
     AND XMMC NOT LIKE '%线'
   GROUP BY DJXH, SPBM5
  ),
  DJALL_M AS (
  SELECT SPBM5,
         SUM(ABS(JX_JE_M)) / SUM(ABS(JX_SL_M)) AS JX_DJ_M_PJ
    FROM JX_M
   GROUP BY SPBM5
  ),
  JX_NOTKG AS ( --非重量计，非长度计部分采购，从金额算重量
  SELECT DJXH, SPBM5, SUM(JE) AS JX_JE_NOTKG
    FROM FXGL_DATA_FZPCKQY_JXMX
   WHERE DW NOT IN ('T', '吨', 'KG', '公斤', '千克', 'KM', '千米', '百米', 'M', '米', '码')
   GROUP BY DJXH, SPBM5
  )
  SELECT MD.DJXH,
         MD.SPBM5,
         NVL(JX_KG.JX_SL_KG,0),
         NVL(JX_KG.JX_JE_KG,0),
         NVL(JX_KG.JX_DJ_KG,DJALL_KG.JX_DJ_KG_PJ),
         DJALL_KG.JX_DJ_KG_PJ,
         NVL(JX_M.JX_SL_M,0),
         NVL(JX_M.JX_JE_M,0),
         NVL(JX_M.JX_DJ_M,DJALL_M.JX_DJ_M_PJ),
         DJALL_M.JX_DJ_M_PJ,
         NVL(JX_NOTKG.JX_JE_NOTKG,0),
         MD.JH_GJ_M
    FROM MD
    LEFT JOIN JX_KG ON JX_KG.DJXH=MD.DJXH AND JX_KG.SPBM5=MD.SPBM5
    LEFT JOIN DJALL_KG ON DJALL_KG.SPBM5=MD.SPBM5
    LEFT JOIN JX_M ON JX_M.DJXH=MD.DJXH AND JX_M.SPBM5=MD.SPBM5
    LEFT JOIN DJALL_M ON DJALL_M.SPBM5=MD.SPBM5
    LEFT JOIN JX_NOTKG ON JX_NOTKG.DJXH=MD.DJXH AND JX_NOTKG.SPBM5=MD.SPBM5;
  COMMIT;

  -- 更新原材料采购指标
  UPDATE FXGL_DATA_FZPCKQY T
     SET (T.JH_ZZL,T.JH_ZJE,T.JH_DJ_GJ,T.JH_DJ_GJ_PJ,T.JH_DJ_M,T.JH_DJ_M_PJ) = (
  SELECT SUM(S.JH_SL_KG + S.JH_SL_M * S.JH_GJ_M + S.JH_JE_NOTKG / S.JH_DJ_KG),
         SUM(S.JH_JE_KG + S.JH_JE_M + S.JH_JE_NOTKG),
         AVG(S.JH_DJ_KG),
         AVG(S.JH_DJ_KG_PJ),
         AVG(S.JH_DJ_M),
         AVG(S.JH_DJ_M_PJ)
    FROM FXGL_DATA_FZPCKQY_JXXX S
   WHERE S.DJXH=T.DJXH);
  COMMIT;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE FXGL_DATA_FZPCKQY_NXMX';
  COMMIT;

  -- 内销发票按商品大类、名称分组
  INSERT INTO FXGL_DATA_FZPCKQY_NXMX
         (DJXH,SPBM5,XMMC,DW,SL,JE,SE)
  SELECT FP.XHFDJXH,FP.SPBM5,FP.XMMC,FP.DW,SUM(TO_NUMBER(FP.FPSPSL)),SUM(FP.JE),SUM(FP.SE)
    FROM FXGL_DATA_FZPCKQY_FPXX FP
   WHERE FP.XHFDJXH IS NOT NULL
     AND FP.SPBM5 IN ('10401', '10402', '10704')
     AND FP.SE <> 0 --出口单证不算
     AND (FP.DW NOT IN ('T', '吨', 'KM', '千米') OR
         (FP.DW IN ('T', '吨', 'KM', '千米') AND TO_NUMBER(FP.FPSPDJ)>100))  --单价过低的吨和千米，应该是发票开错，应为公斤或米，不参与计算
   GROUP BY FP.XHFDJXH,FP.SPBM5,FP.XMMC,FP.DW;
  COMMIT;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE FXGL_DATA_FZPCKQY_NXXX';
  COMMIT;

  -- 内销发票按商品大类、名称分组统计
  INSERT INTO FXGL_DATA_FZPCKQY_NXXX
         (DJXH,SPBM5,NX_SL_KG,NX_JE_KG,NX_DJ_KG,NX_DJ_KG_PJ,NX_JE_NOTKG)
  WITH
  MD AS (
  SELECT DJXH, SPBM5
    FROM FXGL_DATA_FZPCKQY_NXMX
   GROUP BY DJXH, SPBM5
  ),
  NX_KG AS ( --重量单位计算
  SELECT DJXH,
         SPBM5,
         SUM(CASE
               WHEN DW IN ('T', '吨') THEN SL * 1000
               WHEN DW IN ('KG', '公斤', '千克') THEN SL
               ELSE 0
             END) AS NX_SL_KG,
         SUM(JE) AS NX_JE_KG,
         CASE
           WHEN SUM(ABS(JE)) =0
             OR SUM(ABS(JE)) IS NULL
             OR SUM(CASE
                      WHEN DW IN ('T', '吨') THEN
                        ABS(SL) * 1000
                      WHEN DW IN ('KG', '公斤', '千克') THEN
                        ABS(SL)
                      ELSE
                        0
                    END)=0
             OR SUM(CASE
                      WHEN DW IN ('T', '吨') THEN
                        ABS(SL) * 1000
                      WHEN DW IN ('KG', '公斤', '千克') THEN
                        ABS(SL)
                      ELSE
                        0
                    END) IS NULL
           THEN NULL
           ELSE SUM(ABS(JE)) /
                SUM(CASE
                      WHEN DW IN ('T', '吨') THEN
                        ABS(SL) * 1000
                      WHEN DW IN ('KG', '公斤', '千克') THEN
                        ABS(SL)
                      ELSE
                        0
                    END)
         END  AS NX_DJ_KG
    FROM FXGL_DATA_FZPCKQY_NXMX
   WHERE DW IN ('T', '吨', 'KG', '公斤', '千克')
   GROUP BY DJXH,SPBM5
  ),
  DJALL_KG AS (
  SELECT SPBM5,
         SUM(ABS(NX_JE_KG)) / SUM(ABS(NX_SL_KG)) AS NX_DJ_KG_PJ
    FROM NX_KG
   GROUP BY SPBM5
  ),
  NX_NOTKG AS ( --非重量计，从金额算重量
  SELECT DJXH, SPBM5, SUM(JE) AS NX_JE_NOTKG
    FROM FXGL_DATA_FZPCKQY_NXMX
   WHERE DW NOT IN ('T', '吨', 'KG', '公斤', '千克')
   GROUP BY DJXH, SPBM5
  )
  SELECT MD.DJXH,
         MD.SPBM5,
         NVL(NX_KG.NX_SL_KG,0),
         NVL(NX_KG.NX_JE_KG,0),
         NVL(NX_KG.NX_DJ_KG,DJALL_KG.NX_DJ_KG_PJ),
         DJALL_KG.NX_DJ_KG_PJ,
         NVL(NX_NOTKG.NX_JE_NOTKG,0)
    FROM MD
    LEFT JOIN NX_KG ON NX_KG.DJXH=MD.DJXH AND NX_KG.SPBM5=MD.SPBM5
    LEFT JOIN DJALL_KG ON DJALL_KG.SPBM5=MD.SPBM5
    LEFT JOIN NX_NOTKG ON NX_NOTKG.DJXH=MD.DJXH AND NX_NOTKG.SPBM5=MD.SPBM5;
  COMMIT;

  -- 更新内销指标
  UPDATE FXGL_DATA_FZPCKQY T
     SET (T.NX_ZZL,T.NX_ZJE) = (
  SELECT SUM(S.NX_SL_KG + S.NX_JE_NOTKG / S.NX_DJ_KG_PJ),
         SUM(S.NX_JE_KG + S.NX_JE_NOTKG)
    FROM FXGL_DATA_FZPCKQY_NXXX S
   WHERE S.DJXH=T.DJXH);
  COMMIT;

  -- 更新耗电指标
  UPDATE FXGL_DATA_FZPCKQY T
     SET T.DL_JE = (
  SELECT SUM(S.JE)
    FROM FXGL_DATA_FZPCKQY_FPXX S
   WHERE (S.XHFDJXH = T.DJXH OR
          S.GMFDJXH = T.DJXH)
     AND ((REGEXP_LIKE(S.SPHFWSSFLHBBM,'^110010102') AND REGEXP_LIKE(S.XMMC,'电')) OR
          REGEXP_LIKE(S.XMMC,'电能耗|电( )*[费量价补能谷峰购]|[水风售份耗谷峰]电|([水风用月季年份发供耗]电|能耗|空调费|力)(费|收入)?[0-9A-Z [:punct:]]*$|电.*月'))
     AND S.SPFWJC = '供电' );
  COMMIT;

END;
/
