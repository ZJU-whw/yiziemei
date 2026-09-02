CREATE OR REPLACE PROCEDURE PROC_XXBD_ZG_CKTMSBABG
/*
  编制人:严国平
  编制日期:202209
  功能:信息比对（备案变更），针对退税贷用户变更银行信息加以控制
 */
(
  V_IN_NSRDZDAH   IN  NUMBER, /*纳税人电子档案号*/
  V_IN_DJXH       IN  NUMBER, /*登记序号*/
  V_IN_SBYWBDM    IN  VARCHAR2, /*申报业务表代码*/
  V_IN_SSSQ       IN  VARCHAR2, /*申报年月*/
  V_IN_SBPC       IN  NUMBER, /*申报批次*/
  V_IN_SBID       IN  NUMBER, /*申报ID*/
  V_OUT_STATUS    OUT VARCHAR2, /*00:成功; 其他:执行失败*/
  V_OUT_MESSAGE   OUT VARCHAR2
)
AS
  LN_ROWNUM_CKMX  NUMBER(10);
BEGIN
  V_OUT_STATUS :='00';
  V_OUT_MESSAGE:=' ';

  --取各申报明细表数据记录
  BEGIN
    SELECT COUNT(1)
      INTO LN_ROWNUM_CKMX
      FROM CKTS_BA_BABGQK_LSB
     WHERE SBID=V_IN_SBID;
  EXCEPTION
    WHEN OTHERS THEN
      V_OUT_STATUS :='06';
      V_OUT_MESSAGE:='查询申报记录数据失败！';
      RETURN;
  END;
  IF LN_ROWNUM_CKMX=0 THEN
    BEGIN
      V_OUT_STATUS :='07';
      V_OUT_MESSAGE:='申报数据为空！';
      RETURN;
    END;
  END IF;

  SELECT COUNT(1)
    INTO LN_ROWNUM_CKMX
    FROM CKTS_BA_BABGQK_LSB
   WHERE SBID=V_IN_SBID
     AND BABGZD_DM='TSKHYHZH';
  IF LN_ROWNUM_CKMX=0 THEN
    RETURN;
  END IF;

  SELECT COUNT(1)
    INTO LN_ROWNUM_CKMX
    FROM GS_DJ_CKTMSDAB T
   INNER JOIN TL_ADMIN.FG_TSDQY_JGB S ON T.NSRSBH=S.NSRSBH OR T.SHXYNO=S.NSRSBH
   WHERE T.NSRDZDAH=V_IN_NSRDZDAH
     AND S.JGBZ='1';

  IF LN_ROWNUM_CKMX>0 THEN
    BEGIN
      V_OUT_STATUS :='17';
      V_OUT_MESSAGE:='企业尚未解除退税贷业务监管，暂不允许变更退税银行账号！';
      RETURN;
    END;
  END IF;

  RETURN;
END;
/
