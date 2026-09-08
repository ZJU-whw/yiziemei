DELIMITER $$

DROP PROCEDURE IF EXISTS PRO_JKGL_COMPUTE_W30101$$

CREATE PROCEDURE PRO_JKGL_COMPUTE_W30101
/*
 * 出口企业四同出口报关单数量（同一天同一口岸同一商品同一出口国）
 * ZB_VAL：TL_TSSH.JKGL_DATA_TJ_ZBU.CK_BGDSL_ST
 */
(
  IN P_BGQID DECIMAL(38,10),
  IN P_DJXH DECIMAL(38,10),
  IN P_BGQ_Q DATETIME,
  IN P_BGQ_Z DATETIME
)
routine_body: BEGIN
  DECLARE V_ZB_VAL     DECIMAL(18,2);
  DECLARE V_ROWS       BIGINT;
  DECLARE V_BADPOINT   CHAR(1);
  DECLARE V_PARAMS     VARCHAR(4000);

  BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
      SET V_ZB_VAL = NULL;

  END;
SELECT T.CK_BGDSL_ST
      INTO V_ZB_VAL
      FROM JKGL_DATA_TJ_ZBU T
     WHERE T.BGQID=P_BGQID;
    IF V_ZB_VAL>0 THEN
      SET V_PARAMS = ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('[s]select distinct substr(hg.ckbgdh,1,18) as "报关单号", ', 'DATE_FORMAT(hg.ckrq_1, ''%Y-%m-%d'') as "出口日期", '), 'hg.mygdqsz_dm as "国别",hg.hggqka_dm as "口岸" '), 'from ckts_wbsj_hg_bgd hg '), 'where hg.djxh='), CAST(P_DJXH AS CHAR)), ' and hg.ckrq_1 between '''), DATE_FORMAT(P_BGQ_Q, '%Y-%m-%d')), ''' and '''), DATE_FORMAT(P_BGQ_Z, '%Y-%m-%d')), ''' and exists(select 1 from ckts_wbsj_hg_bgd hg2 '), 'where hg.djxh=hg2.djxh and hg.ckrq_1=hg2.ckrq_1 and hg.mygdqsz_dm=hg2.mygdqsz_dm '), 'and hg.hggqka_dm=hg2.hggqka_dm and hg.cksp_dm=hg2.cksp_dm '), 'group by hg2.ckrq_1,hg2.mygdqsz_dm,hg2.hggqka_dm,hg2.cksp_dm '), 'having count(distinct substr(hg2.ckbgdh,1,18))>=3) '), 'order by DATE_FORMAT(hg.ckrq_1, ''%Y-%m-%d'')');
     END IF;
  END;

  IF V_ZB_VAL IS NULL THEN
    SET V_BADPOINT = 'Y';
  ELSE
    SET V_BADPOINT = 'N';
  END IF;

  SELECT LEAST(COUNT(1), 1)
    INTO V_ROWS
    FROM JKGL_DATA_TJ_ZB T
   WHERE T.BGQID=P_BGQID AND T.ZB_ID='W30101' AND 1=1;
  IF V_ROWS=0 THEN
    INSERT INTO JKGL_DATA_TJ_ZB(BGQID,ZB_ID,ZB_VAL,BADPOINT,PARAMS)
           VALUES(P_BGQID,'W30101',V_ZB_VAL,V_BADPOINT,V_PARAMS);
  ELSE
    UPDATE JKGL_DATA_TJ_ZB AS T
       SET ZB_VAL=V_ZB_VAL,
    BADPOINT=V_BADPOINT,
    PARAMS=V_PARAMS,
    UPTIME=CURRENT_TIMESTAMP
     WHERE T.BGQID=P_BGQID AND T.ZB_ID='W30101';
  END IF;
  COMMIT;

  LEAVE routine_body;
END$$

DELIMITER ;
