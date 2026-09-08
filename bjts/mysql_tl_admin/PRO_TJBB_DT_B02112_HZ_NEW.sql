DELIMITER $$

DROP PROCEDURE IF EXISTS PRO_TJBB_DT_B02112_HZ_NEW$$

CREATE PROCEDURE PRO_TJBB_DT_B02112_HZ_NEW
/*************************************************
 * 跨境电子商务零售出口退税情况统计表9710（省、市局汇总）
 ************************************************/
(
  IN V_SWCODE VARCHAR(4000),
  IN V_SSNY VARCHAR(4000),
  OUT V_ERROR DECIMAL(38,10),
  OUT V_MSG VARCHAR(4000)
)
routine_body: BEGIN
  DECLARE LD_SYSDATE       DATETIME;
  DECLARE LC_THISMONTH     VARCHAR(6);
  DECLARE LD_NEXTMONTH     DATETIME;
  DECLARE LC_SQL_UPDATEHZ  VARCHAR(4000);

  SET V_ERROR =0;
  SET V_MSG = ' ';
  
  IF V_SSNY IS NOT NULL THEN
    SET LD_SYSDATE =STR_TO_DATE(V_SSNY||'01', '%Y%m%d');
  ELSE
    SET LD_SYSDATE =CAST(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y-%m-01') AS DATETIME);
  END IF;
  SET LC_THISMONTH =DATE_FORMAT(LD_SYSDATE, '%Y%m');
  SET LD_NEXTMONTH =CAST(DATE_FORMAT(DATE_ADD(LD_SYSDATE, INTERVAL 1 MONTH), '%Y-%m-01') AS DATETIME);

  --0、清除原有制表数据，准备重新制表
  BEGIN
    DELETE FROM TJBB_DT_B02112 WHERE SWJGDM=V_SWCODE AND SSNY=LC_THISMONTH;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      SET V_ERROR = SQLCODE;
      SET V_MSG = SQLERRM;
      LEAVE routine_body;
  END;

  --1、统计
  BEGIN
    INSERT INTO TJBB_DT_B02112 (
           SSNY,BBLC,SWJGDM,
           BAHS, SBHS, SBTSCKE,
           SB_TMSE, SB_TSE, SB_MDSE,
           SH_TMSE, SH_TSE, SH_MDSE,
           BL_TMSE, BL_TSE, BL_MDSE)
    SELECT LC_THISMONTH,BBLC,V_SWCODE,
           SUM(BAHS), SUM(SBHS), SUM(SBTSCKE),
           SUM(SB_TMSE), SUM(SB_TSE), SUM(SB_MDSE),
           SUM(SH_TMSE), SUM(SH_TSE), SUM(SH_MDSE),
           SUM(BL_TMSE), SUM(BL_TSE), SUM(BL_MDSE)
      FROM TJBB_DT_B02112
     WHERE SWJGDM IN (SELECT SWJG_DM FROM TABLE(FUNC_GET_XJ_SWJG(V_SWCODE))) 
       AND SSNY=LC_THISMONTH
     GROUP BY BBLC;
    COMMIT;

    UPDATE TJBB_DT_B02112 
       SET ZYSP = (SELECT S1.MLMC
                     FROM DM_SPML S1, 
                          (SELECT SPML,SUM(MYLAJ) AS USD_TOTAL
                             FROM (SELECT C.SPML,B.MYLAJ
                                     FROM CKTS_LC_SHXX A
                                    INNER JOIN CKTS_WBSJ_BGD_9X10 B ON B.LCSLID=A.LCSLID AND B.TDCODE='9710' AND B.SBYWB_DM<>'A0305001'
                                    INNER JOIN DM_SPFL C ON C.SPDL=SUBSTR(B.CKSP_DM,1,2)
                                    WHERE A.TSSWJG_DM IN (SELECT SWJG_DM FROM TABLE(FUNC_GET_XJ_SWJG(V_SWCODE))) 
                                      AND A.QDSJ>=DATE'2013-01-01'
                                      AND A.QDSJ<LD_NEXTMONTH) S2
                            GROUP BY SPML
                            ORDER BY USD_TOTAL DESC) S3
                    WHERE S1.SPML=S3.SPML
                      AND ROWNUM=1)
     WHERE SWJGDM=V_SWCODE
       AND SSNY=LC_THISMONTH
       AND BBLC IN ('01','04','07');
    COMMIT;

    UPDATE TJBB_DT_B02112 
       SET ZYSP = (SELECT S1.MLMC
                     FROM DM_SPML S1, 
                          (SELECT SPML,SUM(MYLAJ) AS USD_TOTAL
                             FROM (SELECT C.SPML,B.MYLAJ
                                     FROM CKTS_LC_SHXX A
                                    INNER JOIN CKTS_WBSJ_BGD_9X10 B ON B.LCSLID=A.LCSLID AND B.TDCODE='9710' AND B.SBYWB_DM='A0305001'
                                    INNER JOIN DM_SPFL C ON C.SPDL=SUBSTR(B.CKSP_DM,1,2)
                                    WHERE A.TSSWJG_DM IN (SELECT SWJG_DM FROM TABLE(FUNC_GET_XJ_SWJG(V_SWCODE))) 
                                      AND A.QDSJ>=DATE'2013-01-01'
                                      AND A.QDSJ<LD_NEXTMONTH) S2
                            GROUP BY SPML
                            ORDER BY USD_TOTAL DESC) S3
                    WHERE S1.SPML=S3.SPML
                      AND ROWNUM=1)
     WHERE SWJGDM=V_SWCODE
       AND SSNY=LC_THISMONTH
       AND BBLC IN ('02','05','08');
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      SET V_ERROR = SQLCODE;
      SET V_MSG = SQLERRM;
      LEAVE routine_body;
  END;

  --11、更新汇总列
  BEGIN
    SET LC_SQL_UPDATEHZ = 'UPDATE TJBB_DT_B02112 SET ';

    FOR LSF_XX IN (SELECT FNAME FROM TJBB_HEADER_COLS WHERE BBDM='B02112' AND FTYPE='NUMBER' ORDER BY SHOWORDER)
    LOOP
      SET LC_SQL_UPDATEHZ = LC_SQL_UPDATEHZ || LSF_XX.FNAME || '_HZ=' || LSF_XX.FNAME || ', ';
    END LOOP;

    SET LC_SQL_UPDATEHZ = SUBSTR(LC_SQL_UPDATEHZ, 1, LENGTH(LC_SQL_UPDATEHZ)-2) ||
                       ' WHERE SWJGDM=''' || V_SWCODE || ''' AND SSNY=''' || LC_THISMONTH || '''';

    EXECUTE IMMEDIATE LC_SQL_UPDATEHZ;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      SET V_ERROR = SQLCODE;
      SET V_MSG = SQLERRM;
  END;

  LEAVE routine_body;
END$$

DELIMITER ;
