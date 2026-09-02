CREATE OR REPLACE PROCEDURE TEMP_JKGL_COMPUTE_ZBU_JD
/*
 * 季度指标元刷新算法
 * 202309，增加判断是否新开业的出口企业
 * 202309，增加代理出口统计
 * 20250919，调整拼箱与整柜报关单的计算口径
 */
AS
  V_CK_PXBGDSL      NUMBER(10); --  出口_拼箱报关单数量
  V_CK_ZXBGDSL      NUMBER(18,2); --  出口_整箱报关单数量
  V_CK_PJDBHGZ      NUMBER(18,2); --  出口_平均单笔货柜值
  V_BGQ_Q           DATE;
BEGIN
  FOR CUR_BGQ IN (SELECT T.BGQID, T.DJXH, T.BGQ_Q, T.BGQ_Z+1 AS BGQ_Z, S.SQ_DATE
                    FROM TL_TSSH.JKGL_DATA_BGQ T
                   INNER JOIN TL_TSSH.GLXT_BB_SHXT_DJXX S ON S.DJXH_JS=T.DJXH
                   WHERE T.ZQLX='季' AND TRUNC(T.BGQ_Q,'YY')>=DATE'2020-01-01'
                 )
  LOOP
    --判断是否新开业的出口企业
    IF CUR_BGQ.SQ_DATE>=CUR_BGQ.BGQ_Q AND CUR_BGQ.SQ_DATE<CUR_BGQ.BGQ_Z THEN
      --当年新办的出口企业，首次报告期统计范围从当年年初开始，防止先出口后备案，并与年度报告期分类统计一致
      V_BGQ_Q := TRUNC(CUR_BGQ.BGQ_Q,'YY'); 
    ELSE
      V_BGQ_Q := CUR_BGQ.BGQ_Q;
    END IF;
      
    --  V_CK_
    BEGIN
      --  V_CK_PXBGDSL  NUMBER(10)  出口_拼箱报关单数量
      SELECT COUNT(DISTINCT T.BGDHGBH)
        INTO V_CK_PXBGDSL
        FROM TL_TSSH.CKTS_WBSJ_HG_BGD204 T
       WHERE T.DJXH=CUR_BGQ.DJXH
         AND T.CKRQ_1>=V_BGQ_Q AND T.CKRQ_1<CUR_BGQ.BGQ_Z
         AND T.JZXH<>'无'
         AND (T.BJMMJBZ LIKE '%拼箱%' OR
             EXISTS (SELECT 1
                       FROM TL_TSSH.CKTS_WBSJ_HG_BGD204 S
                      WHERE S.JZXH=T.JZXH AND S.CKRQ_1=T.CKRQ_1 AND S.DJXH<>T.DJXH));

      --  V_CK_ZXBGDSL  NUMBER(18,2)  出口_整箱报关单数量
      --  V_CK_PJDBHGZ  NUMBER(18,2)  出口_平均单笔货柜值
      WITH JZXHXX AS (SELECT T2.BGDHGBH, COUNT(DISTINCT T2.JZXH) AS JZXSL
                        FROM TL_TSSH.CKTS_WBSJ_HG_BGD204 T2
                       WHERE T2.DJXH=CUR_BGQ.DJXH
                         AND T2.CKRQ_1>=V_BGQ_Q AND T2.CKRQ_1<CUR_BGQ.BGQ_Z
                         AND T2.JZXH<>'无'
                         AND T2.BJMMJBZ NOT LIKE '%拼箱%'
                         AND NOT EXISTS (SELECT 1
                                           FROM TL_TSSH.CKTS_WBSJ_HG_BGD204 T3
                                          WHERE T3.JZXH=T2.JZXH AND T3.CKRQ_1=T2.CKRQ_1 AND T3.DJXH<>T2.DJXH)
                       GROUP BY T2.BGDHGBH),
           CKBGXX AS (SELECT SUBSTR(T.CKBGDH,1,18) AS BGDHGBH, SUM(T.MYLAJ) AS TOTALMY
                        FROM TL_TSSH.CKTS_WBSJ_HG_BGD T
                       WHERE T.DJXH=CUR_BGQ.DJXH
                         AND T.CKRQ_1>=V_BGQ_Q AND T.CKRQ_1<CUR_BGQ.BGQ_Z
                         AND T.JGFS_DM<>'1039'
                       GROUP BY SUBSTR(T.CKBGDH,1,18))
      SELECT COUNT(DISTINCT JZXHXX.BGDHGBH), 
             NVL((CASE WHEN SUM(JZXHXX.JZXSL)=0 THEN 0 ELSE SUM(CKBGXX.TOTALMY)/SUM(JZXHXX.JZXSL) END),0)
        INTO V_CK_ZXBGDSL, V_CK_PJDBHGZ
        FROM JZXHXX
       INNER JOIN CKBGXX ON JZXHXX.BGDHGBH=CKBGXX.BGDHGBH;

      UPDATE TL_TSSH.JKGL_DATA_TJ_ZBU
         SET CK_PXBGDSL=V_CK_PXBGDSL,
             CK_ZXBGDSL=V_CK_ZXBGDSL,
             CK_PJDBHGZ=V_CK_PJDBHGZ
       WHERE BGQID=CUR_BGQ.BGQID;
      COMMIT;
    END;
  END LOOP;

  RETURN;
END;
/
