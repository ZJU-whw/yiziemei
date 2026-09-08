DELIMITER $$

DROP PROCEDURE IF EXISTS PRO_JKGL_COMPUTE_W30102$$

CREATE PROCEDURE PRO_JKGL_COMPUTE_W30102
/*
 * 企业出口货物单笔货柜值较高
 * ZB_VAL：TL_TSSH.JKGL_DATA_TJ_ZBU.CK_PJDBHGZ
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
    SELECT T.CK_PJDBHGZ
      INTO V_ZB_VAL
      FROM JKGL_DATA_TJ_ZBU T
     WHERE T.BGQID=P_BGQID;

    IF V_ZB_VAL>0 THEN
      SET V_PARAMS = '[s]select distinct hg.bgdhgbh as "报关单号" ' ||
                  'from tl_tssh.ckts_wbsj_hg_bgd204 hg ' ||
                  'where hg.djxh=' || CAST(P_DJXH AS CHAR) ||
                  ' and hg.ckrq_1 between date''' || DATE_FORMAT(P_BGQ_Q, '%Y-%m-%d') || ''' and date''' || DATE_FORMAT(P_BGQ_Z, '%Y-%m-%d') ||
                  ''' and not exists (select 1 from tl_tssh.ckts_wbsj_hg_bgd204 hg2 ' ||
                  'where hg.jzxh=hg2.jzxh and hg.ckrq_1=hg2.ckrq_1 and hg.djxh<>hg2.djxh)';
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      SET V_ZB_VAL = NULL;
  END;

  IF V_ZB_VAL IS NULL THEN
    SET V_BADPOINT = 'Y';
  ELSE
    SET V_BADPOINT = 'N';
  END IF;

  SELECT COUNT(1)
    INTO V_ROWS
    FROM JKGL_DATA_TJ_ZB T
   WHERE T.BGQID=P_BGQID AND T.ZB_ID='W30102' AND ROWNUM=1;
  IF V_ROWS=0 THEN
    INSERT INTO JKGL_DATA_TJ_ZB(BGQID,ZB_ID,ZB_VAL,BADPOINT,PARAMS)
           VALUES(P_BGQID,'W30102',V_ZB_VAL,V_BADPOINT,V_PARAMS);
  ELSE
    UPDATE JKGL_DATA_TJ_ZB T
       SET T.ZB_VAL=V_ZB_VAL, T.BADPOINT=V_BADPOINT, T.PARAMS=V_PARAMS, T.UPTIME=CURRENT_TIMESTAMP
     WHERE T.BGQID=P_BGQID AND T.ZB_ID='W30102';
  END IF;
  COMMIT;

  LEAVE routine_body;
END$$

DELIMITER ;
