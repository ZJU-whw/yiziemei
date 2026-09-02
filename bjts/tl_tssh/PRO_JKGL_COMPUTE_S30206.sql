CREATE OR REPLACE PROCEDURE PRO_JKGL_COMPUTE_S30206
/*
 * 企业出口商品跨大类（商品代码前两位）
 * ZB_VAL：生产企业跨大类(基期不存在该大类)数
 */
(
  P_BGQID   IN NUMBER,
  P_JQID    IN NUMBER
)
AS
  V_ZB_VAL     NUMBER(18,2);
  V_ROWS       NUMBER(10);
  V_BADPOINT   CHAR(1);
  V_PARAMS     VARCHAR(4000);
BEGIN
  BEGIN
    V_ZB_VAL := 0;
    FOR CUR_SPDM IN (SELECT DISTINCT T.SPDL, DM.CKSP_MC
                       FROM TL_TSSH.JKGL_DATA_TJ_ZBU_CKSP T
                       LEFT JOIN TL_TSSH.JCFX_DM_CKSPTREE DM ON DM.CKSP_DM=T.SPDL AND DM.CKSP_JC='2'
                      WHERE T.BGQID=P_BGQID
                        AND NOT EXISTS (SELECT 1
                                          FROM TL_TSSH.JKGL_DATA_TJ_ZBU_CKSP S
                                         WHERE S.BGQID=P_JQID
                                           AND S.SPDL=T.SPDL))
    LOOP
      V_ZB_VAL := V_ZB_VAL +1;
      IF V_ZB_VAL=1 THEN
        V_PARAMS := '[d]新增出口商品大类=' || CUR_SPDM.SPDL || '（' || CUR_SPDM.CKSP_MC ||'）';
      ELSIF V_ZB_VAL<=20 THEN
        V_PARAMS := V_PARAMS || '|新增出口商品大类=' || CUR_SPDM.SPDL || '（' || CUR_SPDM.CKSP_MC ||'）';
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
   WHERE T.BGQID=P_BGQID AND T.ZB_ID='S30206' AND ROWNUM=1;
  IF V_ROWS=0 THEN
    INSERT INTO JKGL_DATA_TJ_ZB(BGQID,ZB_ID,ZB_VAL,BADPOINT,PARAMS)
           VALUES(P_BGQID,'S30206',V_ZB_VAL,V_BADPOINT,V_PARAMS);
  ELSE
    UPDATE JKGL_DATA_TJ_ZB T
       SET T.ZB_VAL=V_ZB_VAL, T.BADPOINT=V_BADPOINT, T.PARAMS=V_PARAMS, T.UPTIME=SYSDATE
     WHERE T.BGQID=P_BGQID AND T.ZB_ID='S30206';
  END IF;
  COMMIT;

  RETURN;
END;
/
