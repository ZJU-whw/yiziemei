CREATE OR REPLACE PROCEDURE PROC_XXBD_XFS_TSSB_ZJJKS
/*
  编制人:严国平
  编制日期:202010
  功能:信息比对（出口非自产货物退消费税）
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
BEGIN
  V_OUT_STATUS :='00';
  V_OUT_MESSAGE:=' ';

  --总局专用缴款书记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_FZC_SBMX_LSB T
     WHERE T.SBID=V_IN_SBID
       AND T.CKTMSPZLX_DM='06';
    IF LN_MXROW=0 THEN
      RETURN;
    END IF;
  END;

  LC_YDOBJECT :='税收缴款书';
  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                'CKTS_SB_FZC_SBMX_LSB',NULL,NULL,T.SBXH,NULL,'XFS_CKMX_XFSSP_WDZXX','E','消费税税票[' || T.XFSPZH || ']无电子信息！','N',SYSDATE
           FROM CKTS_SB_FZC_SBMX_LSB T
          WHERE T.SBID=V_IN_SBID
            AND T.CKTMSPZLX_DM='06'
            AND NOT EXISTS (SELECT 1
                              FROM CKTS_WBSJ_ZJ_ZJZYJKS S
                             WHERE S.DJXH=V_IN_DJXH
                               AND S.JKSHM=T.XFSPZH);
    COMMIT;
  END;
END;
/
