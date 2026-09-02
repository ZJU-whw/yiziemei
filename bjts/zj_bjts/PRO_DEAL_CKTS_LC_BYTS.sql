CREATE OR REPLACE PROCEDURE PRO_DEAL_CKTS_LC_BYTS
/*
 * 提取事中审核环节的不予退税及应追回已退免税款明细
 */
AS
BEGIN
  FOR CUR_BYMTS IN (SELECT T.TSSWJG_DM_1,T.DJXH,T.LCSLID,T.SSQ,T.SBPC,MIN(T.XGRQ) AS TBRQ
                      FROM HX_CKTS.CKTS_BL_MTS_SHYDCL_JGB T
                     WHERE T.ZHSHCLYJLX_DM = '9'
                       AND T.XGRQ>=SYSDATE-7
                     GROUP BY T.TSSWJG_DM_1,T.DJXH,T.LCSLID,T.SSQ,T.SBPC) LOOP
    MERGE INTO FXGL_DATA_FXYDJG A
         USING (SELECT (SELECT NVL(SHXYDM,NSRSBH)
                          FROM HX_DJ.DJ_NSRXX
                         WHERE DJXH=CUR_BYMTS.DJXH) AS SHXYDM,
                       (SELECT NSRMC
                          FROM HX_DJ.DJ_NSRXX
                         WHERE DJXH=CUR_BYMTS.DJXH) AS NSRMC,
                       (SELECT DECODE(CKTSQYLX_DM,'1','内资生产企业','2','外商投资企业','3','外贸企业','其他单位')
                          FROM HX_CKTS.CKTS_BA_BAXX_JGB
                         WHERE DJXH=CUR_BYMTS.DJXH) AS QYLX,
                       (SELECT SWJGJC
                          FROM HX_DM_ZDY.DM_GY_SWJG
                         WHERE SWJG_DM=CUR_BYMTS.TSSWJG_DM_1) AS TSSWJG_MC,
                       (SELECT ROUND(SUM(MYLAJ)/10000,2)
                          FROM HX_CKTS.CKTS_SB_MTS_TSSB_JGB
                         WHERE DJXH=CUR_BYMTS.DJXH AND SSQ=CUR_BYMTS.SSQ AND SBPC=CUR_BYMTS.SBPC) AS RWFXQJ_SBMYCKE,
                       (SELECT TO_CHAR(WM_CONCAT(TT.FXYDCS))
                          FROM (SELECT '自查表核查' AS FXYDCS
                                  FROM DUAL
                                 WHERE EXISTS (SELECT 1
                                                 FROM HX_CKTS.CKTS_BL_MTS_SHYDCL_JGB
                                                WHERE LCSLID=CUR_BYMTS.LCSLID AND ZCBHCCLYJLX_DM='9')
                                 UNION ALL
                                SELECT '函调核查' AS FXYDCS
                                  FROM DUAL
                                 WHERE EXISTS (SELECT 1
                                                 FROM HX_CKTS.CKTS_BL_MTS_SHYDCL_JGB
                                                WHERE LCSLID=CUR_BYMTS.LCSLID AND FHCLYJLX_DM='9')
                                 UNION ALL
                                SELECT '实地核查' AS FXYDCS
                                  FROM DUAL
                                 WHERE EXISTS (SELECT 1
                                                 FROM HX_CKTS.CKTS_BL_MTS_SHYDCL_JGB
                                                WHERE LCSLID=CUR_BYMTS.LCSLID AND SDHCCLYJLX_DM='9')
                                 UNION ALL
                                SELECT '其他核查' AS FXYDCS
                                  FROM DUAL
                                 WHERE EXISTS (SELECT 1
                                                 FROM HX_CKTS.CKTS_BL_MTS_SHYDCL_JGB T
                                                WHERE T.LCSLID=CUR_BYMTS.LCSLID AND QTHCCLYJLX_DM='9')) TT) AS FXYDCS_JH,
                       (SELECT ROUND(SUM(MYLAJ)/10000,2)
                          FROM HX_CKTS.CKTS_SB_MTS_TSSB_JGB
                         WHERE DJXH=CUR_BYMTS.DJXH AND SSQ=CUR_BYMTS.SSQ AND SBPC=CUR_BYMTS.SBPC
                           AND GLH IN (SELECT GLH
                                         FROM HX_CKTS.CKTS_BL_MTS_SHYDCL_JGB
                                        WHERE LCSLID=CUR_BYMTS.LCSLID AND ZHSHCLYJLX_DM = '9')) AS BYTSCKE,
                       (SELECT ROUND(SUM(TSE)/10000,2)
                          FROM HX_CKTS.CKTS_SB_MTS_TSJH_JGB
                         WHERE DJXH=CUR_BYMTS.DJXH AND SSQ=CUR_BYMTS.SSQ AND SBPC=CUR_BYMTS.SBPC
                           AND GLH IN (SELECT GLH
                                         FROM HX_CKTS.CKTS_BL_MTS_SHYDCL_JGB
                                        WHERE LCSLID=CUR_BYMTS.LCSLID AND ZHSHCLYJLX_DM = '9')) AS BYTS,
                       (SELECT TO_CHAR(WM_CONCAT(CKSP_DM))
                          FROM (SELECT DISTINCT CKSP_DM
                                  FROM HX_CKTS.CKTS_SB_MTS_TSSB_JGB
                                 WHERE DJXH=CUR_BYMTS.DJXH AND SSQ=CUR_BYMTS.SSQ AND SBPC=CUR_BYMTS.SBPC
                                   AND GLH IN (SELECT GLH
                                                 FROM HX_CKTS.CKTS_BL_MTS_SHYDCL_JGB
                                                WHERE LCSLID=CUR_BYMTS.LCSLID AND ZHSHCLYJLX_DM = '9'))
                         WHERE ROWNUM<=20) AS SPDM2MC
                  FROM DUAL) B
            ON (A.LCSLID=CUR_BYMTS.LCSLID)
          WHEN MATCHED THEN
               UPDATE SET A.RWFXQJ_SBMYCKE=B.RWFXQJ_SBMYCKE, A.FXYDCS_JH=B.FXYDCS_JH, A.BYTSCKE=B.BYTSCKE, A.BYTS=B.BYTS,A.SPDM2MC=B.SPDM2MC
          WHEN NOT MATCHED THEN
            INSERT (ID,TSSWJG_DM,TBR,TBRQ,SSNY,DJXH,SHXYNO,NSRMC,FXRWLY_DM,RWFXQJ_SBMYCKE,FXYDCS_JH,BYTSCKE,BYTS,BZ,LCSLID,TSSWJG_MC,SPDM2MC,QYLX,SFHCYWT)
            VALUES (SEQ_FXGL_DATA_FXYDJG.NEXTVAL,CUR_BYMTS.TSSWJG_DM_1,'SYSTEM',CUR_BYMTS.TBRQ,CUR_BYMTS.SSQ,CUR_BYMTS.DJXH,B.SHXYDM,B.NSRMC,
                   '05',B.RWFXQJ_SBMYCKE,B.FXYDCS_JH,B.BYTSCKE,B.BYTS,'免退税所属期-批次：'||CUR_BYMTS.SSQ||CUR_BYMTS.SBPC,CUR_BYMTS.LCSLID,
                   B.TSSWJG_MC,B.SPDM2MC,B.QYLX,'Y');
    COMMIT;
  END LOOP;
  
  FOR CUR_BYDBTS IN (SELECT T.TSSWJG_DM_1,T.DJXH,T.LCSLID,T.SSQ,T.SBPC,MIN(T.XGRQ) AS TBRQ
                       FROM HX_CKTS.CKTS_BL_DB_SHYDCL_JGB T
                      WHERE T.ZHSHCLYJLX_DM = '9'
                        AND T.XGRQ>=SYSDATE-7
                      GROUP BY T.TSSWJG_DM_1,T.DJXH,T.LCSLID,T.SSQ,T.SBPC) LOOP
    MERGE INTO FXGL_DATA_FXYDJG A
         USING (SELECT (SELECT NVL(SHXYDM,NSRSBH)
                          FROM HX_DJ.DJ_NSRXX
                         WHERE DJXH=CUR_BYDBTS.DJXH) AS SHXYDM,
                       (SELECT NSRMC
                          FROM HX_DJ.DJ_NSRXX
                         WHERE DJXH=CUR_BYDBTS.DJXH) AS NSRMC,
                       (SELECT DECODE(CKTSQYLX_DM,'1','内资生产企业','2','外商投资企业','3','外贸企业','其他单位')
                          FROM HX_CKTS.CKTS_BA_BAXX_JGB
                         WHERE DJXH=CUR_BYDBTS.DJXH) AS QYLX,
                       (SELECT SWJGJC
                          FROM HX_DM_ZDY.DM_GY_SWJG
                         WHERE SWJG_DM=CUR_BYDBTS.TSSWJG_DM_1) AS TSSWJG_MC,
                       (SELECT ROUND(SUM(MYLAJ)/10000,2)
                          FROM HX_CKTS.CKTS_SB_DB_TSSB_JGB
                         WHERE DJXH=CUR_BYDBTS.DJXH AND SSQ=CUR_BYDBTS.SSQ AND SBPC=CUR_BYDBTS.SBPC) AS RWFXQJ_SBMYCKE,
                       (SELECT TO_CHAR(WM_CONCAT(TT.FXYDCS))
                          FROM (SELECT '自查表核查' AS FXYDCS
                                  FROM DUAL
                                 WHERE EXISTS (SELECT 1
                                                 FROM HX_CKTS.CKTS_BL_DB_SHYDCL_JGB
                                                WHERE LCSLID=CUR_BYDBTS.LCSLID AND ZCBHCCLYJLX_DM='9')
                                 UNION ALL
                                SELECT '函调核查' AS FXYDCS
                                  FROM DUAL
                                 WHERE EXISTS (SELECT 1
                                                 FROM HX_CKTS.CKTS_BL_DB_SHYDCL_JGB
                                                WHERE LCSLID=CUR_BYDBTS.LCSLID AND FHCLYJLX_DM='9')
                                 UNION ALL
                                SELECT '实地核查' AS FXYDCS
                                  FROM DUAL
                                 WHERE EXISTS (SELECT 1
                                                 FROM HX_CKTS.CKTS_BL_DB_SHYDCL_JGB
                                                WHERE LCSLID=CUR_BYDBTS.LCSLID AND SDHCCLYJLX_DM='9')
                                 UNION ALL
                                SELECT '其他核查' AS FXYDCS
                                  FROM DUAL
                                 WHERE EXISTS (SELECT 1
                                                 FROM HX_CKTS.CKTS_BL_DB_SHYDCL_JGB T
                                                WHERE T.LCSLID=CUR_BYDBTS.LCSLID AND QTHCCLYJLX_DM='9')) TT) AS FXYDCS_JH,
                       (SELECT ROUND(SUM(MYLAJ)/10000,2)
                          FROM HX_CKTS.CKTS_SB_DB_TSSB_JGB
                         WHERE DJXH=CUR_BYDBTS.DJXH AND SSQ=CUR_BYDBTS.SSQ AND SBPC=CUR_BYDBTS.SBPC
                           AND SBXH IN (SELECT SBXH
                                         FROM HX_CKTS.CKTS_BL_DB_SHYDCL_JGB
                                        WHERE LCSLID=CUR_BYDBTS.LCSLID AND ZHSHCLYJLX_DM = '9')) AS BYTSCKE,
                       (SELECT ROUND(SUM(TSE)/10000,2)
                          FROM HX_CKTS.CKTS_SB_DB_TSSB_JGB
                         WHERE DJXH=CUR_BYDBTS.DJXH AND SSQ=CUR_BYDBTS.SSQ AND SBPC=CUR_BYDBTS.SBPC
                           AND SBXH IN (SELECT SBXH
                                         FROM HX_CKTS.CKTS_BL_DB_SHYDCL_JGB
                                        WHERE LCSLID=CUR_BYDBTS.LCSLID AND ZHSHCLYJLX_DM = '9')) AS BYTS,
                       (SELECT TO_CHAR(WM_CONCAT(CKSP_DM))
                          FROM (SELECT DISTINCT CKSP_DM
                                  FROM HX_CKTS.CKTS_SB_DB_TSSB_JGB
                                 WHERE DJXH=CUR_BYDBTS.DJXH AND SSQ=CUR_BYDBTS.SSQ AND SBPC=CUR_BYDBTS.SBPC
                                   AND SBXH IN (SELECT SBXH
                                                 FROM HX_CKTS.CKTS_BL_DB_SHYDCL_JGB
                                                WHERE LCSLID=CUR_BYDBTS.LCSLID AND ZHSHCLYJLX_DM = '9'))
                         WHERE ROWNUM<=20) AS SPDM2MC
                  FROM DUAL) B
            ON (A.LCSLID=CUR_BYDBTS.LCSLID)
          WHEN MATCHED THEN
               UPDATE SET A.RWFXQJ_SBMYCKE=B.RWFXQJ_SBMYCKE, A.FXYDCS_JH=B.FXYDCS_JH, A.BYTSCKE=B.BYTSCKE, A.BYTS=B.BYTS,A.SPDM2MC=B.SPDM2MC
          WHEN NOT MATCHED THEN
            INSERT (ID,TSSWJG_DM,TBR,TBRQ,SSNY,DJXH,SHXYNO,NSRMC,FXRWLY_DM,RWFXQJ_SBMYCKE,FXYDCS_JH,BYTSCKE,BYTS,BZ,LCSLID,TSSWJG_MC,SPDM2MC,QYLX,SFHCYWT)
            VALUES (SEQ_FXGL_DATA_FXYDJG.NEXTVAL,CUR_BYDBTS.TSSWJG_DM_1,'SYSTEM',CUR_BYDBTS.TBRQ,CUR_BYDBTS.SSQ,CUR_BYDBTS.DJXH,B.SHXYDM,B.NSRMC,
                   '05',B.RWFXQJ_SBMYCKE,B.FXYDCS_JH,B.BYTSCKE,B.BYTS,'代办退税所属期-批次：'||CUR_BYDBTS.SSQ||CUR_BYDBTS.SBPC,CUR_BYDBTS.LCSLID,
                   B.TSSWJG_MC,B.SPDM2MC,B.QYLX,'Y');
    COMMIT;
  END LOOP;
  
  FOR CUR_BYMDT IN (SELECT T.TSSWJG_DM_1,T.DJXH,T.LCSLID,T.SSQ,MIN(T.XGRQ) AS TBRQ
                      FROM HX_CKTS.CKTS_BL_MDT_SHYDCL_JGB T
                     WHERE T.ZHSHCLYJLX_DM = '9'
                       AND T.XGRQ>=SYSDATE-7
                     GROUP BY T.TSSWJG_DM_1,T.DJXH,T.LCSLID,T.SSQ) LOOP
    MERGE INTO FXGL_DATA_FXYDJG A
         USING (SELECT (SELECT NVL(SHXYDM,NSRSBH)
                          FROM HX_DJ.DJ_NSRXX
                         WHERE DJXH=CUR_BYMDT.DJXH) AS SHXYDM,
                       (SELECT NSRMC
                          FROM HX_DJ.DJ_NSRXX
                         WHERE DJXH=CUR_BYMDT.DJXH) AS NSRMC,
                       (SELECT DECODE(CKTSQYLX_DM,'1','内资生产企业','2','外商投资企业','3','外贸企业','其他单位')
                          FROM HX_CKTS.CKTS_BA_BAXX_JGB
                         WHERE DJXH=CUR_BYMDT.DJXH) AS QYLX,
                       (SELECT SWJGJC
                          FROM HX_DM_ZDY.DM_GY_SWJG
                         WHERE SWJG_DM=CUR_BYMDT.TSSWJG_DM_1) AS TSSWJG_MC,
                       (SELECT ROUND(SUM(MYLAJ)/10000,2)
                          FROM (SELECT SBXH,MYLAJ,MDTSE,CKSP_DM
                                  FROM HX_CKTS.CKTS_SB_MDT_TSSB_JGB
                                 WHERE DJXH=CUR_BYMDT.DJXH AND SSQ=CUR_BYMDT.SSQ
                                 UNION ALL
                                SELECT SBXH,MYLAJ,MDTSE,CKSP_DM
                                  FROM HX_CKTS.CKTS_SB_MDT_TSSB_GCB
                                 WHERE DJXH=CUR_BYMDT.DJXH AND SSQ=CUR_BYMDT.SSQ)) AS RWFXQJ_SBMYCKE,
                       (SELECT TO_CHAR(WM_CONCAT(TT.FXYDCS))
                          FROM (SELECT '自查表核查' AS FXYDCS
                                  FROM DUAL
                                 WHERE EXISTS (SELECT 1
                                                 FROM HX_CKTS.CKTS_BL_MDT_SHYDCL_JGB
                                                WHERE LCSLID=CUR_BYMDT.LCSLID AND ZCBHCCLYJLX_DM='9')
                                 UNION ALL
                                SELECT '函调核查' AS FXYDCS
                                  FROM DUAL
                                 WHERE EXISTS (SELECT 1
                                                 FROM HX_CKTS.CKTS_BL_MDT_SHYDCL_JGB
                                                WHERE LCSLID=CUR_BYMDT.LCSLID AND FHCLYJLX_DM='9')
                                 UNION ALL
                                SELECT '实地核查' AS FXYDCS
                                  FROM DUAL
                                 WHERE EXISTS (SELECT 1
                                                 FROM HX_CKTS.CKTS_BL_MDT_SHYDCL_JGB
                                                WHERE LCSLID=CUR_BYMDT.LCSLID AND SDHCCLYJLX_DM='9')
                                 UNION ALL
                                SELECT '其他核查' AS FXYDCS
                                  FROM DUAL
                                 WHERE EXISTS (SELECT 1
                                                 FROM HX_CKTS.CKTS_BL_MDT_SHYDCL_JGB T
                                                WHERE T.LCSLID=CUR_BYMDT.LCSLID AND QTHCCLYJLX_DM='9')) TT) AS FXYDCS_JH,
                       (SELECT ROUND(SUM(MYLAJ)/10000,2)
                          FROM (SELECT SBXH,MYLAJ,MDTSE,CKSP_DM
                                  FROM HX_CKTS.CKTS_SB_MDT_TSSB_JGB
                                 WHERE DJXH=CUR_BYMDT.DJXH AND SSQ=CUR_BYMDT.SSQ
                                 UNION ALL
                                SELECT SBXH,MYLAJ,MDTSE,CKSP_DM
                                  FROM HX_CKTS.CKTS_SB_MDT_TSSB_GCB
                                 WHERE DJXH=CUR_BYMDT.DJXH AND SSQ=CUR_BYMDT.SSQ) TT
                         WHERE SBXH IN (SELECT SBXH
                                          FROM HX_CKTS.CKTS_BL_MDT_SHYDCL_JGB
                                         WHERE LCSLID=CUR_BYMDT.LCSLID AND ZHSHCLYJLX_DM = '9')) AS BYTSCKE,
                       (SELECT ROUND(SUM(MDTSE)/10000,2)
                          FROM (SELECT SBXH,MYLAJ,MDTSE,CKSP_DM
                                  FROM HX_CKTS.CKTS_SB_MDT_TSSB_JGB
                                 WHERE DJXH=CUR_BYMDT.DJXH AND SSQ=CUR_BYMDT.SSQ
                                 UNION ALL
                                SELECT SBXH,MYLAJ,MDTSE,CKSP_DM
                                  FROM HX_CKTS.CKTS_SB_MDT_TSSB_GCB
                                 WHERE DJXH=CUR_BYMDT.DJXH AND SSQ=CUR_BYMDT.SSQ) TT
                         WHERE SBXH IN (SELECT SBXH
                                          FROM HX_CKTS.CKTS_BL_MDT_SHYDCL_JGB
                                         WHERE LCSLID=CUR_BYMDT.LCSLID AND ZHSHCLYJLX_DM = '9')) AS BYTS,
                       (SELECT TO_CHAR(WM_CONCAT(CKSP_DM))
                          FROM (SELECT DISTINCT CKSP_DM
                                  FROM (SELECT SBXH,MYLAJ,MDTSE,CKSP_DM
                                          FROM HX_CKTS.CKTS_SB_MDT_TSSB_JGB
                                         WHERE DJXH=CUR_BYMDT.DJXH AND SSQ=CUR_BYMDT.SSQ
                                         UNION ALL
                                        SELECT SBXH,MYLAJ,MDTSE,CKSP_DM
                                          FROM HX_CKTS.CKTS_SB_MDT_TSSB_GCB
                                         WHERE DJXH=CUR_BYMDT.DJXH AND SSQ=CUR_BYMDT.SSQ) TT
                                 WHERE SBXH IN (SELECT SBXH
                                                 FROM HX_CKTS.CKTS_BL_MDT_SHYDCL_JGB
                                                WHERE LCSLID=CUR_BYMDT.LCSLID AND ZHSHCLYJLX_DM = '9'))
                         WHERE ROWNUM<=20) AS SPDM2MC
                  FROM DUAL) B
            ON (A.LCSLID=CUR_BYMDT.LCSLID)
          WHEN MATCHED THEN
               UPDATE SET A.RWFXQJ_SBMYCKE=B.RWFXQJ_SBMYCKE, A.FXYDCS_JH=B.FXYDCS_JH, A.BYTSCKE=B.BYTSCKE, A.BYTS=B.BYTS,A.SPDM2MC=B.SPDM2MC
          WHEN NOT MATCHED THEN
            INSERT (ID,TSSWJG_DM,TBR,TBRQ,SSNY,DJXH,SHXYNO,NSRMC,FXRWLY_DM,RWFXQJ_SBMYCKE,FXYDCS_JH,BYTSCKE,BYTS,BZ,LCSLID,TSSWJG_MC,SPDM2MC,QYLX,SFHCYWT)
            VALUES (SEQ_FXGL_DATA_FXYDJG.NEXTVAL,CUR_BYMDT.TSSWJG_DM_1,'SYSTEM',CUR_BYMDT.TBRQ,CUR_BYMDT.SSQ,CUR_BYMDT.DJXH,B.SHXYDM,B.NSRMC,
                   '05',B.RWFXQJ_SBMYCKE,B.FXYDCS_JH,B.BYTSCKE,B.BYTS,'免抵退所属期：'||CUR_BYMDT.SSQ,CUR_BYMDT.LCSLID,
                   B.TSSWJG_MC,B.SPDM2MC,B.QYLX,'Y');
    COMMIT;
  END LOOP;
  
  FOR CUR_BYZBTS IN (SELECT T.TSSWJG_DM_1,T.DJXH,T.LCSLID,T.SSQ,MIN(T.XGRQ) AS TBRQ
                      FROM HX_CKTS.CKTS_BL_ZB_SHYDCL_JGB T
                     WHERE T.LCSWSX_DM='LCSXA081042002' AND T.ZHSHCLYJLX_DM = '9'
                       AND T.XGRQ>=SYSDATE-7
                     GROUP BY T.TSSWJG_DM_1,T.DJXH,T.LCSLID,T.SSQ) LOOP
    MERGE INTO FXGL_DATA_FXYDJG A
         USING (SELECT (SELECT NVL(SHXYDM,NSRSBH)
                          FROM HX_DJ.DJ_NSRXX
                         WHERE DJXH=CUR_BYZBTS.DJXH) AS SHXYDM,
                       (SELECT NSRMC
                          FROM HX_DJ.DJ_NSRXX
                         WHERE DJXH=CUR_BYZBTS.DJXH) AS NSRMC,
                       (SELECT DECODE(CKTSQYLX_DM,'1','内资生产企业','2','外商投资企业','3','外贸企业','其他单位')
                          FROM HX_CKTS.CKTS_BA_BAXX_JGB
                         WHERE DJXH=CUR_BYZBTS.DJXH) AS QYLX,
                       (SELECT SWJGJC
                          FROM HX_DM_ZDY.DM_GY_SWJG
                         WHERE SWJG_DM=CUR_BYZBTS.TSSWJG_DM_1) AS TSSWJG_MC,
                       (SELECT TO_CHAR(WM_CONCAT(TT.FXYDCS))
                          FROM (SELECT '自查表核查' AS FXYDCS
                                  FROM DUAL
                                 WHERE EXISTS (SELECT 1
                                                 FROM HX_CKTS.CKTS_BL_ZB_SHYDCL_JGB
                                                WHERE LCSLID=CUR_BYZBTS.LCSLID AND ZCBHCCLYJLX_DM='9')
                                 UNION ALL
                                SELECT '函调核查' AS FXYDCS
                                  FROM DUAL
                                 WHERE EXISTS (SELECT 1
                                                 FROM HX_CKTS.CKTS_BL_ZB_SHYDCL_JGB
                                                WHERE LCSLID=CUR_BYZBTS.LCSLID AND FHCLYJLX_DM='9')
                                 UNION ALL
                                SELECT '实地核查' AS FXYDCS
                                  FROM DUAL
                                 WHERE EXISTS (SELECT 1
                                                 FROM HX_CKTS.CKTS_BL_ZB_SHYDCL_JGB
                                                WHERE LCSLID=CUR_BYZBTS.LCSLID AND SDHCCLYJLX_DM='9')
                                 UNION ALL
                                SELECT '其他核查' AS FXYDCS
                                  FROM DUAL
                                 WHERE EXISTS (SELECT 1
                                                 FROM HX_CKTS.CKTS_BL_ZB_SHYDCL_JGB T
                                                WHERE T.LCSLID=CUR_BYZBTS.LCSLID AND QTHCCLYJLX_DM='9')) TT) AS FXYDCS_JH,
                       (SELECT ROUND(SUM(TSE)/10000,2)
                          FROM HX_CKTS.CKTS_SB_GJ_SBMX_JGB
                         WHERE DJXH=CUR_BYZBTS.DJXH AND SSQ=CUR_BYZBTS.SSQ
                           AND SBXH IN (SELECT SBXH
                                         FROM HX_CKTS.CKTS_BL_ZB_SHYDCL_JGB
                                        WHERE LCSLID=CUR_BYZBTS.LCSLID AND ZHSHCLYJLX_DM = '9')) AS BYTS
                  FROM DUAL) B
            ON (A.LCSLID=CUR_BYZBTS.LCSLID)
          WHEN MATCHED THEN
               UPDATE SET A.FXYDCS_JH=B.FXYDCS_JH, A.BYTS=B.BYTS
          WHEN NOT MATCHED THEN
            INSERT (ID,TSSWJG_DM,TBR,TBRQ,SSNY,DJXH,SHXYNO,NSRMC,FXRWLY_DM,FXYDCS_JH,BYTS,BZ,LCSLID,TSSWJG_MC,QYLX,SFHCYWT)
            VALUES (SEQ_FXGL_DATA_FXYDJG.NEXTVAL,CUR_BYZBTS.TSSWJG_DM_1,'SYSTEM',CUR_BYZBTS.TBRQ,CUR_BYZBTS.SSQ,CUR_BYZBTS.DJXH,B.SHXYDM,B.NSRMC,
                   '05',B.FXYDCS_JH,B.BYTS,'购进所属期：'||CUR_BYZBTS.SSQ,CUR_BYZBTS.LCSLID,B.TSSWJG_MC,B.QYLX,'Y');
    COMMIT;
  END LOOP;
  
  FOR CUR_YZHTS IN (SELECT T.TSSWJG_DM_1,T.DJXH,T.LCSLID,ROUND(SUM(T.YZHTMSK)/10000,2) YZHTMSK,MIN(T.XGRQ) AS TBRQ,
                           MIN(CASE WHEN LENGTH(T.SSQ)=7 THEN SUBSTR(T.SSQ,1,4)||SUBSTR(T.SSQ,6,2) ELSE T.SSQ END) AS SSQ_Q,
                           MAX(CASE WHEN LENGTH(T.SSQ)=7 THEN SUBSTR(T.SSQ,1,4)||SUBSTR(T.SSQ,6,2) ELSE T.SSQ END) AS SSQ_Z
                      FROM HX_CKTS.CKTS_TK_YZHYTSKMXB_JGB T
                     WHERE T.YZHYTMSKYY_DM<>'05' AND T.YZHYTMSKYY_DM<>'032' AND T.YZHTMSK<>0
                       AND T.XGRQ>=SYSDATE-7
                     GROUP BY T.TSSWJG_DM_1,T.DJXH,T.LCSLID) LOOP
    MERGE INTO FXGL_DATA_FXYDJG A
         USING (SELECT (SELECT NVL(SHXYDM,NSRSBH)
                          FROM HX_DJ.DJ_NSRXX
                         WHERE DJXH=CUR_YZHTS.DJXH) AS SHXYDM,
                       (SELECT NSRMC
                          FROM HX_DJ.DJ_NSRXX
                         WHERE DJXH=CUR_YZHTS.DJXH) AS NSRMC,
                       (SELECT DECODE(CKTSQYLX_DM,'1','内资生产企业','2','外商投资企业','3','外贸企业','其他单位')
                          FROM HX_CKTS.CKTS_BA_BAXX_JGB
                         WHERE DJXH=CUR_YZHTS.DJXH) AS QYLX,
                       (SELECT SWJGJC
                          FROM HX_DM_ZDY.DM_GY_SWJG
                         WHERE SWJG_DM=CUR_YZHTS.TSSWJG_DM_1) AS TSSWJG_MC
                  FROM DUAL) B
            ON (A.LCSLID=CUR_YZHTS.LCSLID)
          WHEN MATCHED THEN
               UPDATE SET A.YZHTS=CUR_YZHTS.YZHTMSK
          WHEN NOT MATCHED THEN
            INSERT (ID,TSSWJG_DM,TBR,TBRQ,SSNY,DJXH,SHXYNO,NSRMC,FXRWLY_DM,FXYDCS_JH,YZHTS,BZ,LCSLID,TSSWJG_MC,QYLX,SFHCYWT)
            VALUES (SEQ_FXGL_DATA_FXYDJG.NEXTVAL,CUR_YZHTS.TSSWJG_DM_1,'SYSTEM',CUR_YZHTS.TBRQ,CUR_YZHTS.SSQ_Z,
                   CUR_YZHTS.DJXH,B.SHXYDM,B.NSRMC,'06','其他核查',CUR_YZHTS.YZHTMSK,
                   '应追回所属期起止：'||CUR_YZHTS.SSQ_Q||'-'||CUR_YZHTS.SSQ_Z,CUR_YZHTS.LCSLID,B.TSSWJG_MC,B.QYLX,'Y');
    COMMIT;
  END LOOP;
END;
/
