CREATE OR REPLACE PROCEDURE PRO_DEAL_CKTS_DATA
/*
 * 预处理金三流程信息
 */
AS
  LD_SJCL_M     DATE;
  LD_SJCL_Y     DATE;
BEGIN
  LD_SJCL_M := TRUNC(ADD_MONTHS(SYSDATE,-1),'MM');
  LD_SJCL_Y := TRUNC(ADD_MONTHS(SYSDATE,-1),'YY');

  -- 即将逾期函调（复函）
  PRO_DEAL_CKTS_HD_JJYQ;
  -- 先发函后申报退税数据
  PRO_DEAL_CKTS_HD_XFHHSB(LD_SJCL_M);
  -- 本年度四类企业法人代表
  PRO_DEAL_CKTS_KZ_SLQY(LD_SJCL_Y);
  -- 不予退税及应追回已退免税款
  PRO_DEAL_CKTS_LC_BYTS;
  -- 容缺实地核查流程（新管理办法出台以后，容缺办理已经取消）
  --PRO_DEAL_CKTS_LC_SDHC;
  -- 视同自产审核流程
  PRO_DEAL_CKTS_LC_STZC;
  -- 出口退税审核流程
  PRO_DEAL_CKTS_LC_TSSB;
  
  PRO_DEAL_MSG_PUSH_DATA;
  PRO_DEAL_FXNK_NBFXDMX_SH;
  PRO_DEAL_FXNK_NBFXDMX_SQ;
END;
/
