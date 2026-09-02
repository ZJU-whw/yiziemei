CREATE OR REPLACE PROCEDURE PROC_XXBD_MTS_HZCJ
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（外贸企业免退税）
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
  LN_SQLCODE NUMBER := 0;
  LC_SQLERRM VARCHAR2(8000);
BEGIN
  V_OUT_STATUS :='00';
  V_OUT_MESSAGE:=' ';
END;
/
