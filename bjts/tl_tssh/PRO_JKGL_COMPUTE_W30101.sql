CREATE OR REPLACE PROCEDURE PRO_JKGL_COMPUTE_W30101
/*
 * 出口企业四同出口报关单数量（同一天同一口岸同一商品同一出口国）
 * ZB_VAL：TL_TSSH.JKGL_DATA_TJ_ZBU.CK_BGDSL_ST
 */
(
  P_BGQID   IN NUMBER,
  P_DJXH    IN NUMBER,
  P_BGQ_Q   IN DATE,
  P_BGQ_Z   IN DATE
)
AS
  V_ZB_VAL     NUMBER(18,2);
  V_ROWS       NUMBER(10);
  V_BADPOINT   CHAR(1);
  V_PARAMS     VARCHAR(4000);
BEGIN
  BEGIN
    SELECT T.CK_BGDSL_ST
      INTO V_ZB_VAL
      FROM TL_TSSH.JKGL_DATA_TJ_ZBU T
     WHERE T.BGQID=P_BGQID;
    IF V_ZB_VAL>0 THEN
      V_PARAMS := '[s]select distinct substr(hg.ckbgdh,1,18) as "报关单号", ' ||
                  'to_char(hg.ckrq_1,''yyyy-mm-dd'') as "出口日期", ' ||
                  'hg.mygdqsz_dm as "国别",hg.hggqka_dm as "口岸" ' ||
                  'from tl_tssh.ckts_wbsj_hg_bgd hg ' ||
                  'where hg.djxh=' || TO_CHAR(P_DJXH) ||
                  ' and hg.ckrq_1 between date''' || TO_CHAR(P_BGQ_Q,'YYYY-MM-DD') || ''' and date''' || TO_CHAR(P_BGQ_Z,'YYYY-MM-DD') ||
                  ''' and exists(select 1 from tl_tssh.ckts_wbsj_hg_bgd hg2 ' ||
                  'where hg.djxh=hg2.djxh and hg.ckrq_1=hg2.ckrq_1 and hg.mygdqsz_dm=hg2.mygdqsz_dm ' ||
                  'and hg.hggqka_dm=hg2.hggqka_dm and hg.cksp_dm=hg2.cksp_dm ' ||
                  'group by hg2.ckrq_1,hg2.mygdqsz_dm,hg2.hggqka_dm,hg2.cksp_dm ' ||
                  'having count(distinct substr(hg2.ckbgdh,1,18))>=3) ' ||
                  'order by to_char(hg.ckrq_1,''yyyy-mm-dd'')';
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
   WHERE T.BGQID=P_BGQID AND T.ZB_ID='W30101' AND ROWNUM=1;
  IF V_ROWS=0 THEN
    INSERT INTO JKGL_DATA_TJ_ZB(BGQID,ZB_ID,ZB_VAL,BADPOINT,PARAMS)
           VALUES(P_BGQID,'W30101',V_ZB_VAL,V_BADPOINT,V_PARAMS);
  ELSE
    UPDATE JKGL_DATA_TJ_ZB T
       SET T.ZB_VAL=V_ZB_VAL, T.BADPOINT=V_BADPOINT, T.PARAMS=V_PARAMS, T.UPTIME=SYSDATE
     WHERE T.BGQID=P_BGQID AND T.ZB_ID='W30101';
  END IF;
  COMMIT;

  RETURN;
END;
/
