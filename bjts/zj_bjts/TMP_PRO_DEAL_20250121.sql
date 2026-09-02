CREATE OR REPLACE PROCEDURE TMP_PRO_DEAL_20250121
AS
BEGIN

  INSERT INTO TMP_20250121_QY_01(DJXH)
    SELECT DISTINCT DJXH
      FROM HX_CKTS.CKTS_SB_MDT_SBDSHZ_JGB T
     WHERE T.DJXH = T.DJXH
       AND T.SSQ >= '201501'
       AND T.MDTSE > 0;
   COMMIT;

  INSERT INTO TMP_20250121_QY_02(DJXH)
    SELECT DJXH
      FROM TMP_20250121_QY_01 T
     WHERE EXISTS (SELECT 1
                     FROM HX_CKTS.CKTS_WBSJ_HG_BGD201 S
                    WHERE S.DJXH = T.DJXH
                      AND S.CKRQ_1 >= DATE '2015-01-01');
   COMMIT;

  FOR CUR_QY IN (SELECT DJXH FROM TMP_20250121_QY_02 WHERE AJYBFJSXSE IS NULL ORDER BY TSSWJG_DM_1)
  LOOP
    update TMP_20250121_QY_02 t
       set t.ajybfjsxse =
           (SELECT NVL(SUM(AJYBFJSXSE),0)
              FROM HX_SB.SB_ZZS_YBNSR
             WHERE SBUUID IN (SELECT DISTINCT SBUUID
                                FROM HX_SB.SB_SBXX
                               WHERE DJXH=CUR_QY.DJXH
                                 AND SKSSQQ>=DATE'2015-01-01' AND SKSSQZ<DATE '2025-01-01'
                                 AND ZSXM_DM='10101'
                                 AND YZPZZL_DM='BDA0610606'
                                 AND GZLX_DM_1 IN ('1','5')
                                 AND ZFBZ_1='N' )
               AND EWBLXH IN (1, 3))
     where t.djxh=CUR_QY.DJXH;
     commit;
  END LOOP;
  
  DELETE FROM TMP_20250121_QY_02 T WHERE T.AJYBFJSXSE<=0;
  COMMIT;

  FOR CUR_QY IN (SELECT DJXH FROM TMP_20250121_QY_02 WHERE MYLAJ IS NULL ORDER BY TSSWJG_DM_1)
  LOOP
    update TMP_20250121_QY_02 t
       set (T.MYLAJ,T.RMBLAJ) =
           (SELECT NVL(SUM(MYLAJ),0),NVL(SUM(RMBLAJ),0)
              FROM HX_CKTS.CKTS_WBSJ_HG_BGD201 S
             WHERE S.DJXH = T.DJXH
               AND S.CKRQ_1 >= DATE '2015-01-01')
     where t.djxh=CUR_QY.DJXH;
    update TMP_20250121_QY_02 t
       set (T.CKXSEMY,T.CKXSERMB,T.YTSE_1,T.MDSE) =
           (SELECT NVL(SUM(CKXSEMY),0),NVL(SUM(CKXSERMB),0),NVL(SUM(YTSE_1),0),NVL(SUM(MDSE),0)
              FROM HX_CKTS.CKTS_SB_MDT_SBDSHZ_JGB S
             WHERE S.DJXH = T.DJXH
               AND S.SSQ>='201501')
     where t.djxh=CUR_QY.DJXH;
     commit;
  END LOOP;
/*
  select t.tsswjg_dm_1,t.djxh,nvl(s.shxydm,s.nsrsbh) as nsrsbh,s.nsrmc,ba.barq,ba.bachbz,ba.bachrq,
         t.ajybfjsxse,t.mylaj,t.rmblaj,t.ckxsemy,t.ckxsermb,t.ytse_1,t.mdse
    from TMP_20250121_QY_02 t
   inner join hx_dj.dj_nsrxx s on s.djxh=t.djxh
   inner join hx_ckts.ckts_ba_baxx_jgb ba on ba.djxh=t.djxh
   order by t.tsswjg_dm_1,t.djxh;
*/
  RETURN;
END;
/
