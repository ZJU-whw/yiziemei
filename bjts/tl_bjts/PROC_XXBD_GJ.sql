CREATE OR REPLACE PROCEDURE PROC_XXBD_GJ
/*
  编制人:严国平
  编制日期:202010
  功能:信息比对（购进自用货物免退税）
  调整日期：20201221，1、根据宁波加工区内退水电气大部分为小规模以及研发中心退国产设备政策第十三条，非增值税一般纳税人允许申报购进自用货物退税，对涉及一般纳税人资格的疑点进行调整
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
  LDT_TODAY       DATE;

  LC_QYHGDM       VARCHAR2(20);
  LC_QYLXDM       VARCHAR2(20);
  LC_TSJSFSDM     VARCHAR2(20);
  LC_WMZHFWQYBZ   VARCHAR2(20);
  LC_SFYSFW       VARCHAR2(20);
  LC_YSFW         VARCHAR2(50);
  LC_YSFS         VARCHAR2(50);
  LC_YFSJ         VARCHAR2(50);
  LC_ZXFLAG       VARCHAR2(20);

  LN_CPCODEKZ     NUMBER(10);
  LN_SDQ          NUMBER(10);
  LC_KZXX         VARCHAR2(20);
  LC_FLGLCD       VARCHAR2(20);
  LN_ROWNUM_TSSB  NUMBER(10);
BEGIN
  V_OUT_STATUS :='00';
  V_OUT_MESSAGE:=' ';
  LDT_TODAY:=TRUNC(SYSDATE,'DD');

  IF V_IN_SSSQ>TO_CHAR(SYSDATE,'YYYYMM') THEN
    BEGIN
      V_OUT_STATUS :='05';
      V_OUT_MESSAGE:='申报所属时期超出合理范围！';
      RETURN;
    END;
  END IF;

  --取各申报明细表数据记录
  BEGIN
    SELECT COUNT(1)
      INTO LN_ROWNUM_TSSB
      FROM CKTS_SB_GJ_SBMX_LSB
     WHERE SBID=V_IN_SBID;
  EXCEPTION
    WHEN OTHERS THEN
      V_OUT_STATUS :='06';
      V_OUT_MESSAGE:='查询申报记录数据失败！';
      RETURN;
  END;
  IF LN_ROWNUM_TSSB=0 THEN
    BEGIN
      V_OUT_STATUS :='07';
      V_OUT_MESSAGE:='申报数据为空！';
      RETURN;
    END;
  END IF;

  --查询企业基本信息
  BEGIN
    SELECT T.QYHGDM, T.QYLX_DM, T.TSJSFS_DM, T.WMZHFWQYBZ, T.SFYSFW, T.YSFW, T.YSFS, T.YFSJ, T.ZX_FLAG
      INTO LC_QYHGDM, LC_QYLXDM, LC_TSJSFSDM, LC_WMZHFWQYBZ, LC_SFYSFW, LC_YSFW, LC_YSFS, LC_YFSJ, LC_ZXFLAG
      FROM GS_DJ_CKTMSDAB T
     WHERE T.NSRDZDAH=V_IN_NSRDZDAH;
  EXCEPTION
    WHEN OTHERS THEN
      V_OUT_STATUS :='08';
      V_OUT_MESSAGE:='企业当前未进行出口退（免）税备案，不允许申报除出口退（免）税备案以外的其他业务！';
      RETURN;
  END;
  IF LC_ZXFLAG='R' THEN
    BEGIN
      V_OUT_STATUS :='09';
      V_OUT_MESSAGE:='企业当前已出口退（免）税备案撤回，不允许申报除出口退（免）税备案以外的其他业务！';
      RETURN;
    END;
  END IF;

  --取企业的FLGLCD信息, TGSHZL信息，判断是否需要申报收汇
  LN_CPCODEKZ:=FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',LDT_TODAY,LC_FLGLCD);
  IF LN_CPCODEKZ=0 THEN
    BEGIN
      V_OUT_STATUS :='10';
      V_OUT_MESSAGE:='查询出口企业分类管理类型出错！';
      RETURN;
    END;
  END IF;

  LN_CPCODEKZ:=FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'TQQY',LDT_TODAY,LC_KZXX);
  IF LN_CPCODEKZ=1 THEN
    BEGIN
      V_OUT_STATUS :='13';
      V_OUT_MESSAGE:='企业当前处于出口退税停权期间，不允许申报出口退（免）税业务！';
      RETURN;
    END;
  END IF;
  LN_CPCODEKZ:=FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTSSXMS',LDT_TODAY,LC_KZXX);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_TSSB>0 THEN
    BEGIN
      V_OUT_STATUS :='14';
      V_OUT_MESSAGE:='企业当前处于放弃退（免）税权选择免税期间，不允许申报出口货物劳务免退税业务！';
      RETURN;
    END;
  END IF;
  LN_CPCODEKZ:=FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTSSXZS',LDT_TODAY,LC_KZXX);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_TSSB>0 THEN
    BEGIN
      V_OUT_STATUS :='15';
      V_OUT_MESSAGE:='企业当前处于放弃退（免）税权选择征税期间，不允许申报出口货物劳务免退税业务！';
      RETURN;
    END;
  END IF;
  LN_CPCODEKZ:=FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FQTMS',LDT_TODAY,LC_KZXX);
  IF LN_CPCODEKZ=1 AND LN_ROWNUM_TSSB>0 THEN
    BEGIN
      V_OUT_STATUS :='16';
      V_OUT_MESSAGE:='企业当前处于放弃退（免）税权期间，不允许申报出口货物劳务免退税业务！';
      RETURN;
    END;
  END IF;

  BEGIN
    PROC_XXBD_GJ_ZZSFP(V_IN_NSRDZDAH,V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,V_OUT_STATUS,V_OUT_MESSAGE);
  EXCEPTION
    WHEN OTHERS THEN
      V_OUT_STATUS :='52';
      V_OUT_MESSAGE:='增值税发票自检出错：'||SQLCODE||' - '||SQLERRM;
      RETURN;
  END;

END;
/
