CREATE OR REPLACE PROCEDURE PRO_JKGL_COMPUTE_W10403
/*
 * 法人兼营多家企业
 * ZB_VAL：企业法人兼营的企业户数，目前未计算股东兼营情况
 */
(
  P_BGQID   IN NUMBER,
  P_DJXH    IN NUMBER
)
AS
  V_ZB_VAL     NUMBER(18,2);
  V_ROWS       NUMBER(10);
  V_BADPOINT   CHAR(1);
  V_ZJHM       VARCHAR2(50);
  V_PARAMS     VARCHAR(4000);
BEGIN
  BEGIN
    SELECT T.FRDB_ZJHM,
           '[d]企业法人证件号码=' || T.FRDB_ZJHM || '，法人兼营企业列表：'
      INTO V_ZJHM, V_PARAMS
      FROM TL_TSSH.GLXT_BB_SHXT_DJXX T
     WHERE T.DJXH_JS=P_DJXH
       AND ROWNUM=1;

    V_ZB_VAL := 0;
    FOR CUR_SPDM IN (SELECT DISTINCT T.NSRSBH, T.NSRMC
                       FROM TL_TSSH.CKTS_DJ_NSRXX T
                      WHERE T.FDDBRSFZJHM = V_ZJHM
                        AND T.NSRZT_DM NOT IN ('07','13')
                        AND LENGTH(T.NSRSBH)=18
                        AND SUBSTR(T.NSRSBH,1,1)<>'L'
                        AND T.NSRMC NOT LIKE '%车购税%')
    LOOP
      V_ZB_VAL := V_ZB_VAL +1;
      IF V_ZB_VAL<=20 THEN
        V_PARAMS := V_PARAMS || '|税号=' || CUR_SPDM.NSRSBH || '，名称=' || CUR_SPDM.NSRMC;
      END IF;
    END LOOP;
    IF V_ZB_VAL>20 THEN
      V_PARAMS := V_PARAMS || '|...';
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      V_ZB_VAL := NULL;
  END;

  IF V_ZB_VAL IS NULL THEN
    V_BADPOINT := 'Y';
  ELSE
    V_BADPOINT := 'N';
  END IF;

  SELECT COUNT(1)
    INTO V_ROWS
    FROM JKGL_DATA_TJ_ZB T
   WHERE T.BGQID=P_BGQID AND T.ZB_ID='W10403' AND ROWNUM=1;
  IF V_ROWS=0 THEN
    INSERT INTO JKGL_DATA_TJ_ZB(BGQID,ZB_ID,ZB_VAL,BADPOINT,PARAMS)
           VALUES(P_BGQID,'W10403',V_ZB_VAL,V_BADPOINT,V_PARAMS);
  ELSE
    UPDATE JKGL_DATA_TJ_ZB T
       SET T.ZB_VAL=V_ZB_VAL, T.BADPOINT=V_BADPOINT, T.PARAMS=V_PARAMS, T.UPTIME=SYSDATE
     WHERE T.BGQID=P_BGQID AND T.ZB_ID='W10403';
  END IF;
  COMMIT;

  RETURN;
END;
/
