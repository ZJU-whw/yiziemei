CREATE OR REPLACE PROCEDURE PROC_XXBD_MDT_GJYS_HKYS
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（生产企业免抵退税）
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
  LN_MXROW        NUMBER(10);
  LC_YDOBJECT     VARCHAR2(20);
  LC_MSG          VARCHAR2(200):=' ';
BEGIN
  V_OUT_STATUS :='00';
  V_OUT_MESSAGE:=' ';

  --国际运输明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_MDT_HKYS_QS_LSB T
     WHERE T.SBID=V_IN_SBID;
    IF LN_MXROW=0 THEN
      RETURN;
    END IF;
  END;
  LC_YDOBJECT :='航空运输';

END;
/
