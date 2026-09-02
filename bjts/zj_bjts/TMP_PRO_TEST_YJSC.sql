CREATE OR REPLACE PROCEDURE TMP_PRO_TEST_YJSC
/*
 * 预警处理效率测试
 */
AS
BEGIN
  FOR CUR_LC IN (SELECT TSSWJG_DM_1,DJXH,SSQ,SBPC,LCSWSX_DM,LCSLID
                   FROM HX_CKTS.CKTS_TY_YWBLXX T
                  WHERE T.LCSWSX_DM='LCSXA081038001'
                    AND T.QDSJ>TRUNC(SYSDATE,'MM')
                    AND T.ZLCLCSLID=T.LCSLID
                    AND EXISTS (SELECT 1
                                  FROM HX_CKTS.CKTS_SB_MDT_TSSB_GCB S1
                                 WHERE S1.LCSLID=T.LCSLID)
                    AND NOT EXISTS (SELECT 1
                                      FROM CKTS_YJRZ_LCSLID S2
                                     WHERE S2.LCSLID=T.LCSLID))
  LOOP
    --新增出口商品（生产）
    INSERT INTO CKTS_YJRZ_LCSLID(TSSWJG_DM_1,DJXH,SSQ,SBPC,LCSWSX_DM,LCSLID,ZBCODE)
         VALUES (CUR_LC.TSSWJG_DM_1,CUR_LC.DJXH,CUR_LC.SSQ,CUR_LC.SBPC,CUR_LC.LCSWSX_DM,CUR_LC.LCSLID,'10101');
    COMMIT;
    UPDATE CKTS_YJRZ_LCSLID S
       SET S.YJ_COUNT=(SELECT COUNT(1) FROM (
/*********************************************************************************************************************************/
           SELECT T.LCSLID,T.YJ_OBJECT,T.YJ_RECORD,T.YJ_COUNT,T.YJ_AMT,T.YJ_TAX,
                  (SELECT B.SBHGSPMC FROM HX_CKTS.CKTS_SB_MDT_TSSB_GCB B WHERE B.LCSLID=T.LCSLID AND B.SBXH=T.YJ_RECORD) AS CMNAME
             FROM (SELECT A.DJXH,
                          A.LCSLID,
                          SUBSTR(A.CKSP_DM,1,8) AS YJ_OBJECT,
                          MIN(A.SBXH) AS YJ_RECORD,
                          COUNT(1) AS YJ_COUNT,
                          SUM(A.MYLAJ) AS YJ_AMT,
                          SUM(A.MDTSE) AS YJ_TAX,
                          MIN(A.CKRQ_1) AS CKRQ0
                     FROM HX_CKTS.CKTS_SB_MDT_TSSB_GCB A
                    WHERE LCSLID = CUR_LC.LCSLID --#{LCSLID}
                    GROUP BY A.DJXH,A.LCSLID,SUBSTR(A.CKSP_DM,1,8)
                   HAVING SUM(A.MDTSE) > 1 --#{PVAL1}
                  ) T
            WHERE NOT EXISTS (SELECT 1
                                FROM HX_CKTS.CKTS_SB_MDT_TSSB_JGB S
                               WHERE S.DJXH = T.DJXH
                                 AND SUBSTR(S.CKSP_DM,1,8) = T.YJ_OBJECT
                                 AND S.CKRQ_1 >=ADD_MONTHS(TRUNC(T.CKRQ0,'YY'),-24))
              AND NOT EXISTS (SELECT 1
                                FROM HX_CKTS.CKTS_SB_MDT_TSSB_GCB S
                               INNER JOIN HX_CKTS.CKTS_BL_MDT_SHYDCL_JGB R
                                  ON R.DJXH=S.DJXH AND R.SSQ=S.SSQ AND R.SBXH=S.SBXH AND R.ZHSHCLYJLX_DM='4'
                               WHERE S.DJXH = T.DJXH AND S.LCSLID<>T.LCSLID
                                 AND SUBSTR(S.CKSP_DM,1,8) = T.YJ_OBJECT
                                 AND S.CKRQ_1 >=ADD_MONTHS(TRUNC(T.CKRQ0,'YY'),-24))
/*********************************************************************************************************************************/
                      ))
     WHERE S.LCSLID=CUR_LC.LCSLID AND S.ZBCODE='10101';
    COMMIT;
    UPDATE CKTS_YJRZ_LCSLID S
       SET S.END_TIME=SYSDATE
     WHERE S.LCSLID=CUR_LC.LCSLID AND S.ZBCODE='10101';
    COMMIT;

    --首次申报出口退税
    INSERT INTO CKTS_YJRZ_LCSLID(TSSWJG_DM_1,DJXH,SSQ,SBPC,LCSWSX_DM,LCSLID,ZBCODE)
         VALUES (CUR_LC.TSSWJG_DM_1,CUR_LC.DJXH,CUR_LC.SSQ,CUR_LC.SBPC,CUR_LC.LCSWSX_DM,CUR_LC.LCSLID,'10301');
    COMMIT;
    UPDATE CKTS_YJRZ_LCSLID S
       SET S.YJ_COUNT=(
/*********************************************************************************************************************************/
           WITH
           SCSBQK AS (
           SELECT B.DJXH, B.LCSWSX_DM, NVL(B.SDHCWCBZ,'0') AS SDHCWCBZ, B.QYZTLX, TRUNC(B.QYZTBGSJ) AS QYZTBGSJ
             FROM (SELECT T.DJXH, T.LCSWSX_DM, T.LCSLID, T.QDSJ, A.SDHCWCBZ, A.QYZTLX, A.QYZTBGSJ, A.LRRQ
                     FROM HX_CKTS.CKTS_TY_YWBLXX T
                    INNER JOIN HX_CKTS.CKTS_TY_SCSBQK A ON A.DJXH=T.DJXH
                    WHERE T.LCSLID=CUR_LC.LCSLID --#{LCSLID}
                    ORDER BY A.LRRQ DESC) B
            WHERE ROWNUM=1),
           SDHCBG AS (
           SELECT D.DJXH, D.HCYYSM, D.HCJGSM
             FROM (SELECT C.DJXH, C.HCYYSM, C.HCJGSM, C.LRRQ
                     FROM SCSBQK
                    INNER JOIN HX_CKTS.CKTS_SDHC_SDHCBG_JGB C ON C.DJXH=SCSBQK.DJXH
                    WHERE SCSBQK.SDHCWCBZ<>'2'
                      AND C.HCYYSM LIKE DECODE(SCSBQK.QYZTLX,'1','%01%','2',DECODE(SCSBQK.LCSWSX_DM,'LCSXA081038001','%17%','%18%'),'3','%12%')
                      AND C.LRRQ >=SCSBQK.QYZTBGSJ
                    ORDER BY C.LRRQ DESC) D
            WHERE ROWNUM=1)
           SELECT COUNT(1)
             FROM DUAL
            WHERE NOT EXISTS (SELECT 1 FROM SCSBQK WHERE SCSBQK.SDHCWCBZ='2'
                              UNION
                              SELECT 1 FROM SDHCBG WHERE REGEXP_LIKE(SDHCBG.HCJGSM,'01|02|03|04'))
              AND EXISTS (SELECT 1
                            FROM HX_CKTS.CKTS_SB_MDT_SBHZ_GCB
                           WHERE LCSLID=CUR_LC.LCSLID --#{LCSLID}
                             AND MDTSE>0)
/*********************************************************************************************************************************/
           )
     WHERE S.LCSLID=CUR_LC.LCSLID AND S.ZBCODE='10301';
    COMMIT;
    UPDATE CKTS_YJRZ_LCSLID S
       SET S.END_TIME=SYSDATE
     WHERE S.LCSLID=CUR_LC.LCSLID AND S.ZBCODE='10301';
    COMMIT;
  END LOOP;
END;
/
