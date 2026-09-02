CREATE OR REPLACE PROCEDURE PRO_DEAL_JCFX_DATA_QYYHZ_INIT
/*
 * 每月月初，取JCFX_NSR_BADJ_TOHZ表中记录并初始化JCFX_DATA_QYYHZ
 */
AS
  LD_ENDMONTH          DATE;             --上上月，汇总截止月份，老企业汇总起始月份
  LD_DEALMONTH         DATE;             --按月汇总的控制时间（月初）
  LD_NEXTMONTH         DATE;             --按月汇总的控制时间（下月初）
  LC_NY                VARCHAR2(6);      --开票月份，财务报表、纳税申报表所属期止月份，免抵退申报所属期或免退税申报月份
  LD_NEWMONTH          DATE;             --新增商品、供应商的控制时间（月初）
  LC_NEWNY             VARCHAR2(6);      --新增商品、供应商的控制时间（月份）
  --JCFX_DATA_QYYHZ.ck
  LN_CK_SB_XSEMY        NUMBER(18,2);     --出口_销售美元
  LN_CK_SB_XSERMB       NUMBER(18,2);     --出口_销售人民币
  LN_CK_SB_JSJE         NUMBER(18,2);     --出口_计税金额
  LN_CK_SB_JHCB         NUMBER(18,2);     --出口_进货成本
  LN_CK_SB_TSE          NUMBER(18,2);     --出口_申报退税
  LN_CK_SB_MDE          NUMBER(18,2);     --出口_申报免抵
  LN_CK_HZ_TSE          NUMBER(18,2);     --出口_核准退税
  LN_CK_HZ_MDE          NUMBER(18,2);     --出口_核准免抵
  LN_CK_BL_TSE          NUMBER(18,2);     --出口_办理退税
  LN_CK_BL_MDE          NUMBER(18,2);     --出口_办理免抵
  LN_CK_XZSP_CKE        NUMBER(18,2);     --出口_新增商品出口额
  LN_CK_XZGHS_JSJE      NUMBER(18,2);     --出口_新增供应商计税金额
  LN_CK_TSSP_CKE        NUMBER(18,2);     --出口_特殊商品出口额
  LN_CK_MGSP_CKE        NUMBER(18,2);     --出口_敏感商品出口额
  LN_CK_MGKA_CKE        NUMBER(18,2);     --出口_敏感口岸出口额
  LN_CNT                INTEGER;          --统计数
BEGIN
  FOR CUR_NSR IN (SELECT DJXH,NSRSBH,NVL(SHXYDM,NSRSBH) AS SHXYDM,SWJGDM,JLXZSJ,BACHSJ,JCFXSJ FROM JCFX_NSR_BADJ_TOHZ)
  LOOP
    IF CUR_NSR.JCFXSJ IS NULL THEN --根据上一次监测分析时间是否为空判定是否新增企业
      LD_DEALMONTH:=ADD_MONTHS(TRUNC(CUR_NSR.JLXZSJ,'YY'),-24); --新增企业汇总起始月份，上上年
    ELSE
      BEGIN
        SELECT TO_DATE(MAX(S.NY)||'01','YYYYMMDD')
          INTO LD_DEALMONTH
          FROM JCFX_DATA_QYYHZ S
          WHERE S.DJXH=CUR_NSR.DJXH;
      EXCEPTION
        WHEN OTHERS THEN
          LD_DEALMONTH := NULL;
      END;
      IF LD_DEALMONTH IS NULL THEN
        LD_DEALMONTH:=ADD_MONTHS(TRUNC(CUR_NSR.JCFXSJ,'MM'),-2); --老企业汇总起始月份，上上月
      END IF;
    END IF;
    -- 终止月份，上上月、备案撤回月份（未撤回按系统日期比较）较小者
    LD_ENDMONTH:=LEAST(ADD_MONTHS(TRUNC(SYSDATE,'MM'),-2),TRUNC(NVL(CUR_NSR.BACHSJ,SYSDATE),'MM'));
    
    --DEBUG
    LOOP
      EXIT WHEN LD_DEALMONTH > LD_ENDMONTH;
      --日期赋值
      LD_NEXTMONTH:=ADD_MONTHS(LD_DEALMONTH,1);
      LC_NY:=TO_CHAR(LD_DEALMONTH,'YYYYMM');
      LD_NEWMONTH:=ADD_MONTHS(LD_DEALMONTH,-6);
      LC_NEWNY:=TO_CHAR(LD_NEWMONTH,'YYYYMM');

      --JCFX_DATA_QYYHZ
      BEGIN
        SELECT COUNT(*) INTO LN_CNT FROM JCFX_DATA_QYYHZ T WHERE T.DJXH=CUR_NSR.DJXH AND T.NY=LC_NY;
        IF LN_CNT = 0 THEN
          INSERT INTO JCFX_DATA_QYYHZ(DJXH,NY,NSRSBH,SHXYDM)
          VALUES(CUR_NSR.DJXH,LC_NY,CUR_NSR.NSRSBH,CUR_NSR.SHXYDM);
          COMMIT;
        END IF;

        SELECT COUNT(*) INTO LN_CNT FROM JCFX_DATA_QYYHZ T WHERE T.DJXH=CUR_NSR.DJXH AND T.NY=LC_NY AND NVL(T.BJTS_ZT,'N') <> 'Y';
        --本地BJTS抽取
        IF LN_CNT > 0 THEN
          --LN_CK_SB_XSEMY,LN_CK_SB_XSERMB,LN_CK_SB_JSJE,LN_CK_SB_JHCB
          BEGIN
            SELECT NVL(SUM(XSEMY),0),NVL(SUM(XSERMB),0),NVL(SUM(JSJE),0),NVL(SUM(JHCB),0)
              INTO LN_CK_SB_XSEMY, LN_CK_SB_XSERMB, LN_CK_SB_JSJE, LN_CK_SB_JHCB
              FROM (SELECT SUM(T.MYLAJ) AS XSEMY, SUM(T.RMBLAJ) AS XSERMB, SUM(T.RMBLAJ) AS JSJE, 0 AS JHCB
                      FROM CKTS_LC_SBXX S
                     INNER JOIN CKTS_SB_MDT_CKMX T ON T.LCSLID_SB=S.LCSLID_SB
                     WHERE S.DJXH=CUR_NSR.DJXH AND S.SBYWB_DM='A0305001' AND S.SSQ=LC_NY AND S.ZFBZ IS NULL
                     UNION ALL
                    SELECT SUM(T.YSFWYYEMY) AS XSEMY, SUM(T.YSFWYYERMB) AS XSERMB, SUM(T.YSFWYYERMB) AS JSJE, 0 AS JHCB
                      FROM CKTS_LC_SBXX S
                     INNER JOIN CKTS_SB_MDT_YFSJ T ON T.LCSLID_SB=S.LCSLID_SB
                     WHERE S.DJXH=CUR_NSR.DJXH AND S.SBYWB_DM='A0305001' AND S.SSQ=LC_NY AND S.ZFBZ IS NULL
                     UNION ALL
                    SELECT SUM(T.YSFWYYEMY) AS XSEMY, SUM(T.YSFWYYERMB) AS XSERMB, SUM(T.YSFWYYERMB) AS JSJE, 0 AS JHCB
                      FROM CKTS_LC_SBXX S
                     INNER JOIN CKTS_SB_MDT_GJYS T ON T.LCSLID_SB=S.LCSLID_SB
                     WHERE S.DJXH=CUR_NSR.DJXH AND S.SBYWB_DM='A0305001' AND S.SSQ=LC_NY AND S.ZFBZ IS NULL
                     UNION ALL
                    SELECT SUM(T.MYLAJ) AS XSEMY, SUM(T.MYLAJ * R.RMBLAJ / R.MYLAJ) AS XSERMB, 0 AS JSJE, 0 AS JHCB
                      FROM CKTS_LC_SBXX S
                     INNER JOIN CKTS_SB_MTS_CKMX T ON T.LCSLID_SB=S.LCSLID_SB
                     INNER JOIN CKTS_WBSJ_HG_BGD R ON R.DJXH=CUR_NSR.DJXH AND R.CKBGDH=T.CKBGDH
                     WHERE S.DJXH=CUR_NSR.DJXH AND S.SBYWB_DM='A0301001' AND S.SBRQ>=LD_DEALMONTH AND S.SBRQ<LD_NEXTMONTH AND S.ZFBZ IS NULL
                     UNION ALL
                    SELECT 0 AS XSEMY, 0 AS XSERMB, SUM(T.JSJE) AS JSJE, SUM(T.JSJE * (100+T.ZSSL-T.TSL) / 100) AS JHCB
                      FROM CKTS_LC_SBXX S
                     INNER JOIN CKTS_SB_MTS_JHMX T ON T.LCSLID_SB=S.LCSLID_SB AND T.SZ='V'
                     WHERE S.DJXH=CUR_NSR.DJXH AND S.SBYWB_DM='A0301001' AND S.SBRQ>=LD_DEALMONTH AND S.SBRQ<LD_NEXTMONTH AND S.ZFBZ IS NULL
                     UNION ALL
                    SELECT SUM(T.SKJEMY) AS XSEMY, SUM(T.BQQRYSFWYYSRRMBJE) AS XSERMB, SUM(T.JSJE) AS JSJE, SUM(T.JSJE * (100+T.ZSSL-T.TSL) / 100) AS JHCB
                      FROM CKTS_LC_SBXX S
                     INNER JOIN CKTS_SB_MTS_YSFW T ON T.LCSLID_SB=S.LCSLID_SB
                     WHERE S.DJXH=CUR_NSR.DJXH AND S.SBYWB_DM='A0301001' AND S.SBRQ>=LD_DEALMONTH AND S.SBRQ<LD_NEXTMONTH AND S.ZFBZ IS NULL
                     UNION ALL
                    SELECT SUM(T.MYLAJ) AS XSEMY, SUM(T.MYLAJ * R.RMBLAJ / R.MYLAJ) AS XSERMB, SUM(T.JSJE) AS JSJE, SUM(T.JSJE * (100+T.ZSSL-T.TSL) / 100) AS JHCB
                      FROM CKTS_LC_SBXX S
                     INNER JOIN CKTS_SB_WZF_CKMX T ON T.LCSLID_SB=S.LCSLID_SB
                     INNER JOIN CKTS_WBSJ_HG_BGD R ON R.DJXH=CUR_NSR.DJXH AND R.CKBGDH=T.CKBGDH
                     WHERE S.DJXH=CUR_NSR.DJXH AND S.SBYWB_DM='A0310001' AND S.SBRQ>=LD_DEALMONTH AND S.SBRQ<LD_NEXTMONTH AND S.ZFBZ IS NULL
                     UNION ALL
                    SELECT SUM(R.MYLAJ) AS XSEMY, SUM(R.RMBLAJ) AS XSERMB, SUM(T.SBZYJZ) AS JSJE, SUM(T.SBZYJZ * (100+T.ZSSL-T.TSL) / 100) AS JHCB
                      FROM CKTS_LC_SBXX S
                     INNER JOIN CKTS_SB_YS_SBMX T ON T.LCSLID=S.LCSLID_SB
                     INNER JOIN CKTS_WBSJ_HG_BGD R ON R.DJXH=CUR_NSR.DJXH AND R.CKBGDH=T.CKBGDH
                     WHERE S.DJXH=CUR_NSR.DJXH AND S.SBYWB_DM='A0303001' AND S.SBRQ>=LD_DEALMONTH AND S.SBRQ<LD_NEXTMONTH AND S.ZFBZ IS NULL
                     UNION ALL
                    SELECT 0 AS XSEMY, 0 AS XSERMB, SUM(T.JSJE) AS JSJE, SUM(T.JSJE) AS JHCB
                      FROM CKTS_LC_SBXX S
                     INNER JOIN CKTS_SB_GJ_SBMX T ON T.LCSLID=S.LCSLID_SB
                     WHERE S.DJXH=CUR_NSR.DJXH AND S.SBYWB_DM='A0304001' AND S.SBRQ>=LD_DEALMONTH AND S.SBRQ<LD_NEXTMONTH AND S.ZFBZ IS NULL) TT;
          EXCEPTION
            WHEN OTHERS THEN
              LN_CK_SB_XSEMY  :=0;
              LN_CK_SB_XSERMB :=0;
              LN_CK_SB_JSJE :=0;
              LN_CK_SB_JHCB :=0;
          END;

          --LN_CK_SB_TSE,LN_CK_SB_MDE
          SELECT NVL(SUM(S.SB_ZZSTSE+S.SB_XFSTSE),0),NVL(SUM(S.SB_MDSE),0)
            INTO LN_CK_SB_TSE,LN_CK_SB_MDE
            FROM CKTS_LC_SBXX S
           WHERE S.DJXH=CUR_NSR.DJXH
             AND ((S.SBYWB_DM='A0305001' AND S.SSQ=LC_NY) OR ( S.SBYWB_DM<>'A0305001' AND S.SBRQ>=LD_DEALMONTH AND S.SBRQ<LD_NEXTMONTH))
             AND S.ZFBZ IS NULL;

          --LN_CK_HZ_TSE,LN_CK_HZ_MDE
          SELECT NVL(SUM(S.SEHZ_ZZSTSE+S.SEHZ_XFSTSE),0),NVL(SUM(S.SEHZ_MDSE),0)
            INTO LN_CK_HZ_TSE,LN_CK_HZ_MDE
            FROM CKTS_LC_SEHZXX S
           WHERE S.DJXH=CUR_NSR.DJXH AND S.SEHZRQ>=LD_DEALMONTH AND S.SEHZRQ<LD_NEXTMONTH;

          --LN_CK_BL_TSE
          SELECT NVL(SUM(S.SE),0)
            INTO LN_CK_BL_TSE
            FROM CKTS_ZS_SRTHS S
           WHERE S.DJXH=CUR_NSR.DJXH AND S.THRQ_1>=LD_DEALMONTH AND S.THRQ_1<LD_NEXTMONTH AND S.TTSJLX_DM='01' AND S.TZLX_DM IN ('1','4');

          --LN_CK_BL_MDE
          SELECT NVL(SUM(S.JE),0)
            INTO LN_CK_BL_MDE
            FROM CKTS_ZS_TKGZ S
           WHERE S.DJXH=CUR_NSR.DJXH AND S.GKGZRQ>=LD_DEALMONTH AND S.GKGZRQ<LD_NEXTMONTH AND S.TZSLY='3' AND S.TZLX_DM='1' AND S.GZBZ='Y';

          --LN_CK_XZSP_CKE             --出口_新增商品出口额
          BEGIN
            SELECT NVL(SUM(XSEMY),0)
              INTO LN_CK_XZSP_CKE
              FROM (SELECT SUM(T.MYLAJ) AS XSEMY
                      FROM CKTS_LC_SBXX S
                     INNER JOIN CKTS_SB_MDT_CKMX T ON T.LCSLID_SB=S.LCSLID_SB
                     WHERE S.DJXH=CUR_NSR.DJXH AND S.SBYWB_DM='A0305001' AND S.SSQ=LC_NY AND S.ZFBZ IS NULL
                       AND NOT EXISTS (SELECT 1
                                         FROM CKTS_LC_SBXX S1
                                        INNER JOIN CKTS_SB_MDT_CKMX T1 ON T1.LCSLID_SB=S1.LCSLID_SB
                                        WHERE S1.DJXH=CUR_NSR.DJXH AND S1.SBYWB_DM='A0305001' AND S1.SSQ>=LC_NEWNY AND S1.SSQ<LC_NY AND S1.ZFBZ IS NULL
                                          AND T1.CKSP_DM LIKE SUBSTR(T.CKSP_DM,1,4)||'%')
                     UNION ALL
                    SELECT SUM(T.MYLAJ) AS XSEMY
                      FROM CKTS_LC_SBXX S
                     INNER JOIN CKTS_SB_MTS_CKMX T ON T.LCSLID_SB=S.LCSLID_SB
                     WHERE S.DJXH=CUR_NSR.DJXH AND S.SBYWB_DM='A0301001' AND S.SBRQ>=LD_DEALMONTH AND S.SBRQ<LD_NEXTMONTH AND S.ZFBZ IS NULL
                       AND NOT EXISTS (SELECT 1
                                         FROM CKTS_LC_SBXX S1
                                        INNER JOIN CKTS_SB_MTS_CKMX T1 ON T1.LCSLID_SB=S1.LCSLID_SB
                                        WHERE S1.DJXH=CUR_NSR.DJXH AND S1.SBYWB_DM='A0301001' AND S1.SBRQ>=LD_NEWMONTH AND S1.SBRQ<LD_DEALMONTH AND S1.ZFBZ IS NULL
                                          AND T1.CKSP_DM LIKE SUBSTR(T.CKSP_DM,1,4)||'%')
                     UNION ALL
                    SELECT SUM(T.MYLAJ) AS XSEMY
                      FROM CKTS_LC_SBXX S
                     INNER JOIN CKTS_SB_WZF_CKMX T ON T.LCSLID_SB=S.LCSLID_SB
                     WHERE S.DJXH=CUR_NSR.DJXH AND S.SBYWB_DM='A0310001' AND S.SBRQ>=LD_DEALMONTH AND S.SBRQ<LD_NEXTMONTH AND S.ZFBZ IS NULL
                       AND NOT EXISTS (SELECT 1
                                         FROM CKTS_LC_SBXX S1
                                        INNER JOIN CKTS_SB_WZF_CKMX T1 ON T1.LCSLID_SB=S1.LCSLID_SB
                                        WHERE S1.DJXH=CUR_NSR.DJXH AND S1.SBYWB_DM='A0310001' AND S1.SBRQ>=LD_NEWMONTH AND S1.SBRQ<LD_DEALMONTH AND S1.ZFBZ IS NULL
                                          AND T1.CKSP_DM LIKE SUBSTR(T.CKSP_DM,1,4)||'%'
                                          AND T1.WTDBTSSCQYNSRSBH=T.WTDBTSSCQYNSRSBH) ) TT;
          EXCEPTION
            WHEN OTHERS THEN
              LN_CK_XZSP_CKE  :=0;
          END;

          --LN_CK_XZGHS_JSJE           --出口_新增供应商计税金额
          BEGIN
            SELECT NVL(SUM(JSJE),0)
              INTO LN_CK_XZGHS_JSJE
              FROM (SELECT SUM(T.JSJE) AS JSJE
                      FROM CKTS_LC_SBXX S
                     INNER JOIN CKTS_SB_MTS_JHMX T ON T.LCSLID_SB=S.LCSLID_SB AND T.SZ='V'
                     WHERE S.DJXH=CUR_NSR.DJXH AND S.SBYWB_DM='A0301001' AND S.SBRQ>=LD_DEALMONTH AND S.SBRQ<LD_NEXTMONTH AND S.ZFBZ IS NULL
                       AND NOT EXISTS (SELECT 1
                                         FROM CKTS_LC_SBXX S1
                                        INNER JOIN CKTS_SB_MTS_JHMX T1 ON T1.LCSLID_SB=S1.LCSLID_SB
                                        WHERE S1.DJXH=CUR_NSR.DJXH AND S1.SBYWB_DM='A0301001' AND S1.SBRQ>=LD_NEWMONTH AND S1.SBRQ<LD_DEALMONTH AND S1.ZFBZ IS NULL
                                          AND T1.GHFNSRSBH_1=T.GHFNSRSBH_1) ) TT;
          EXCEPTION
            WHEN OTHERS THEN
              LN_CK_XZGHS_JSJE  :=0;
          END;

          --LN_CK_TSSP_CKE             --出口_特殊商品出口额
          BEGIN
            SELECT NVL(SUM(XSEMY),0)
              INTO LN_CK_TSSP_CKE
              FROM (SELECT SUM(T.MYLAJ) AS XSEMY
                      FROM CKTS_LC_SBXX S
                     INNER JOIN CKTS_SB_MDT_CKMX T ON T.LCSLID_SB=S.LCSLID_SB
                     WHERE S.DJXH=CUR_NSR.DJXH AND S.SBYWB_DM='A0305001' AND S.SSQ=LC_NY AND S.ZFBZ IS NULL
                       AND T.CKSP_DM IN (SELECT R.CKSP_DM FROM JCFX_CS_TSSP R WHERE R.SWJGDM=CUR_NSR.SWJGDM)
                     UNION ALL
                    SELECT SUM(T.MYLAJ) AS XSEMY
                      FROM CKTS_LC_SBXX S
                     INNER JOIN CKTS_SB_MTS_CKMX T ON T.LCSLID_SB=S.LCSLID_SB
                     WHERE S.DJXH=CUR_NSR.DJXH AND S.SBYWB_DM='A0301001' AND S.SBRQ>=LD_DEALMONTH AND S.SBRQ<LD_NEXTMONTH AND S.ZFBZ IS NULL
                       AND T.CKSP_DM IN (SELECT R.CKSP_DM FROM JCFX_CS_TSSP R WHERE R.SWJGDM=CUR_NSR.SWJGDM)
                     UNION ALL
                    SELECT SUM(T.MYLAJ) AS XSEMY
                      FROM CKTS_LC_SBXX S
                     INNER JOIN CKTS_SB_WZF_CKMX T ON T.LCSLID_SB=S.LCSLID_SB
                     WHERE S.DJXH=CUR_NSR.DJXH AND S.SBYWB_DM='A0310001' AND S.SBRQ>=LD_DEALMONTH AND S.SBRQ<LD_NEXTMONTH AND S.ZFBZ IS NULL
                       AND T.CKSP_DM IN (SELECT R.CKSP_DM FROM JCFX_CS_TSSP R WHERE R.SWJGDM=CUR_NSR.SWJGDM) ) TT;
          EXCEPTION
            WHEN OTHERS THEN
              LN_CK_TSSP_CKE  :=0;
          END;

          --LN_CK_MGSP_CKE             --出口_敏感商品出口额
          BEGIN
            SELECT NVL(SUM(XSEMY),0)
              INTO LN_CK_MGSP_CKE
              FROM (SELECT SUM(T.MYLAJ) AS XSEMY
                      FROM CKTS_LC_SBXX S
                     INNER JOIN CKTS_SB_MDT_CKMX T ON T.LCSLID_SB=S.LCSLID_SB
                     WHERE S.DJXH=CUR_NSR.DJXH AND S.SBYWB_DM='A0305001' AND S.SSQ=LC_NY AND S.ZFBZ IS NULL
                       AND T.CKSP_DM IN (SELECT R.CKSP_DM FROM JCFX_CS_MGSP R WHERE R.SWJGDM=CUR_NSR.SWJGDM)
                     UNION ALL
                    SELECT SUM(T.MYLAJ) AS XSEMY
                      FROM CKTS_LC_SBXX S
                     INNER JOIN CKTS_SB_MTS_CKMX T ON T.LCSLID_SB=S.LCSLID_SB
                     WHERE S.DJXH=CUR_NSR.DJXH AND S.SBYWB_DM='A0301001' AND S.SBRQ>=LD_DEALMONTH AND S.SBRQ<LD_NEXTMONTH AND S.ZFBZ IS NULL
                       AND T.CKSP_DM IN (SELECT R.CKSP_DM FROM JCFX_CS_MGSP R WHERE R.SWJGDM=CUR_NSR.SWJGDM)
                     UNION ALL
                    SELECT SUM(T.MYLAJ) AS XSEMY
                      FROM CKTS_LC_SBXX S
                     INNER JOIN CKTS_SB_WZF_CKMX T ON T.LCSLID_SB=S.LCSLID_SB
                     WHERE S.DJXH=CUR_NSR.DJXH AND S.SBYWB_DM='A0310001' AND S.SBRQ>=LD_DEALMONTH AND S.SBRQ<LD_NEXTMONTH AND S.ZFBZ IS NULL
                       AND T.CKSP_DM IN (SELECT R.CKSP_DM FROM JCFX_CS_MGSP R WHERE R.SWJGDM=CUR_NSR.SWJGDM) ) TT;
          EXCEPTION
            WHEN OTHERS THEN
              LN_CK_MGSP_CKE  :=0;
          END;

          --LN_CK_MGKA_CKE             --出口_敏感口岸出口额
          BEGIN
            SELECT NVL(SUM(XSEMY),0)
              INTO LN_CK_MGSP_CKE
              FROM (SELECT SUM(T.MYLAJ) AS XSEMY
                      FROM CKTS_LC_SBXX S
                     INNER JOIN CKTS_SB_MDT_CKMX T ON T.LCSLID_SB=S.LCSLID_SB
                     WHERE S.DJXH=CUR_NSR.DJXH AND S.SBYWB_DM='A0305001' AND S.SSQ=LC_NY AND S.ZFBZ IS NULL
                       AND T.HGCODE IN (SELECT R.HGGQKA_DM FROM JCFX_CS_MGKA R WHERE R.SWJGDM=CUR_NSR.SWJGDM)
                     UNION ALL
                    SELECT SUM(T.MYLAJ) AS XSEMY
                      FROM CKTS_LC_SBXX S
                     INNER JOIN CKTS_SB_MTS_CKMX T ON T.LCSLID_SB=S.LCSLID_SB
                     WHERE S.DJXH=CUR_NSR.DJXH AND S.SBYWB_DM='A0301001' AND S.SBRQ>=LD_DEALMONTH AND S.SBRQ<LD_NEXTMONTH AND S.ZFBZ IS NULL
                       AND T.HGCODE IN (SELECT R.HGGQKA_DM FROM JCFX_CS_MGKA R WHERE R.SWJGDM=CUR_NSR.SWJGDM)
                     UNION ALL
                    SELECT SUM(T.MYLAJ) AS XSEMY
                      FROM CKTS_LC_SBXX S
                     INNER JOIN CKTS_SB_WZF_CKMX T ON T.LCSLID_SB=S.LCSLID_SB
                     WHERE S.DJXH=CUR_NSR.DJXH AND S.SBYWB_DM='A0310001' AND S.SBRQ>=LD_DEALMONTH AND S.SBRQ<LD_NEXTMONTH AND S.ZFBZ IS NULL
                       AND T.HGCODE IN (SELECT R.HGGQKA_DM FROM JCFX_CS_MGKA R WHERE R.SWJGDM=CUR_NSR.SWJGDM) ) TT;
          EXCEPTION
            WHEN OTHERS THEN
              LN_CK_MGSP_CKE  :=0;
          END;

          UPDATE JCFX_DATA_QYYHZ A
             SET CK_SB_XSEMY=LN_CK_SB_XSEMY,
                 CK_SB_XSERMB=LN_CK_SB_XSERMB,
                 CK_SB_JSJE=LN_CK_SB_JSJE,
                 CK_SB_JHCB=LN_CK_SB_JHCB,
                 CK_SB_TSE=LN_CK_SB_TSE,
                 CK_SB_MDE=LN_CK_SB_MDE,
                 CK_HZ_TSE=LN_CK_HZ_TSE,
                 CK_HZ_MDE=LN_CK_HZ_MDE,
                 CK_BL_TSE=LN_CK_BL_TSE,
                 CK_BL_MDE=LN_CK_BL_MDE,
                 CK_XZSP_CKE=LN_CK_XZSP_CKE,
                 CK_XZGHS_JSJE=LN_CK_XZGHS_JSJE,
                 CK_TSSP_CKE=LN_CK_TSSP_CKE,
                 CK_MGSP_CKE=LN_CK_MGSP_CKE,
                 CK_MGKA_CKE=LN_CK_MGKA_CKE,
                 BJTS_ZT='Y',
                 BJTS_SJ=SYSDATE,
                 SJGXSJ=SYSDATE
          WHERE DJXH=CUR_NSR.DJXH AND NY=LC_NY;
          COMMIT;

        END IF;
      END;

      LD_DEALMONTH:=LD_NEXTMONTH;
    END LOOP;

    UPDATE JCFX_NSR_BADJ_TOHZ SET JCFXSJ = SYSDATE WHERE DJXH=CUR_NSR.DJXH;
    COMMIT;
  END LOOP;

  DBMS_OUTPUT.put_line('检测分析初始化完成');
  RETURN;
END;
/
