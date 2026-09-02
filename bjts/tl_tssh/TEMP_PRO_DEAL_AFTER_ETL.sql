CREATE OR REPLACE PROCEDURE TEMP_PRO_DEAL_AFTER_ETL
(
  V_ERROR   OUT NUMBER,
  V_MSG     OUT VARCHAR2
)
AS
  LC_SBYY          VARCHAR2(2000);
  LD_DEALDATA      DATE;          --用于基础数据处理的提前量
  LN_LOG           NUMBER(2);
  LC_BBNY          VARCHAR2(6);   --本期制表年月
  LD_BBNY_KSNF     DATE;          --本期制表年月年初
  LD_BBNY_KSRQ     DATE;          --本期制表年月开始日期，一般为制表年月的月初
  LD_BBNY_JZRQ     DATE;          --本期制表年月结束日期，一般为制表年月的下一个月初
  LC_DJZCLX        VARCHAR2(6);   --本期制表年月
  GLH_JSJE         NUMBER(18,2);
  GLH_TSL          NUMBER(18,2);
  GLH_TMSE         NUMBER(18,2);
  LN_ALLCK         NUMBER(18,2);
  LN_SNCK          NUMBER(18,2);
  LN_MYLAJ         NUMBER(18,2);
  LN_RMBLAJ        NUMBER(18,2);
  LN_MDTSE         NUMBER(18,2);
  LN_ZH_MDTSE      NUMBER(18,2);
  LN_BYTS_MDTSE    NUMBER(18,2);
  LN_BYBL_MDTSE    NUMBER(18,2);
  LN_ZZS           NUMBER(18,2);
  LN_XFS           NUMBER(18,2);
  LN_MDSE          NUMBER(18,2);
  SN_ZZS           NUMBER(18,2);
  SN_XFS           NUMBER(18,2);
  SN_MDSE          NUMBER(18,2);
  SY_ZZS           NUMBER(18,2);
  SY_XFS           NUMBER(18,2);
  SY_MDSE          NUMBER(18,2);
  ALL_SB_MDTSE     NUMBER(18,2);
  LD_LASTRQ        DATE;
  V_ZLC_FS         NUMBER(18,2);
  V_ZLC_TS_AMT     NUMBER(18,2);
  V_ZLC_MD_AMT     NUMBER(18,2);
  V_ZLC_ZK_AMT     NUMBER(18,2);
  V_FF_DATE        DATE;
  V_SL_DATE        DATE;
  V_FH_DATE        DATE;
  V_FH_USER        VARCHAR2(20);
  V_YWHZ_DATE      DATE;
  V_YWHZ_USER      VARCHAR2(20);
  V_SEHZ_DATE      DATE;
  V_SEHZ_USER      VARCHAR2(20);
  V_TSKP_DATE      DATE;
  V_TSTK_DATE      DATE;
  LN_I             NUMBER(10);
  LN_J             NUMBER(10);
  V_ZFBZ           CHAR(1);
  V_ZFR_DM         VARCHAR2(100);
  V_ZFRQ           DATE;
  V_CKSPTSSPLX_DM  CHAR(1);
  V_TSL            NUMBER(18,2);
  V_JGFSTSLX_DM    CHAR(1);
  V_HYDXZQH_DM     CHAR(4);
BEGIN
  V_ERROR :=0;
  V_MSG   := ' ';

  LD_DEALDATA:=TRUNC(SYSDATE) - 3;
  LN_LOG  :=2;

    --ZBBLBZ：需要根据CKTS_LC_SHYDDCL重新设置
    --20260730从CKTS_LC_SHYDDCL设置暂不办理，从CKTS_LC_JCZBBL解除暂不办理
    LN_I:=0;
    FOR CUR_MTS IN (SELECT DISTINCT T.DJXH, T.GLH, T.LCSLID
                      FROM (SELECT * FROM CKTS_LC_SHYDDCL WHERE SBYWB_DM='A0301001'
                             UNION ALL
                            SELECT * FROM CKTS_LC_SHYDDCL_SHXT WHERE SBYWB_DM='A0301001') T)
    LOOP
      BEGIN
        UPDATE CKTS_SB_MTS_JHMX R
           SET R.SJTB_SJ=SYSDATE, R.ZBBLBZ='Y'
         WHERE R.DJXH=CUR_MTS.DJXH AND R.GLH=CUR_MTS.GLH AND R.LCSLID=CUR_MTS.LCSLID AND R.ZBBLBZ='N';
        UPDATE CKTS_SB_MTS_CKMX R
           SET R.SJTB_SJ=SYSDATE, R.ZBBLBZ='Y'
         WHERE R.DJXH=CUR_MTS.DJXH AND R.GLH=CUR_MTS.GLH AND R.LCSLID=CUR_MTS.LCSLID AND R.ZBBLBZ='N';
        COMMIT;
        LN_I :=LN_I+1;
      END;
    END LOOP;

    LN_I:=0;
    FOR CUR_MTS IN (SELECT DISTINCT T.DJXH, T.GLH, T.LCSLID
                      FROM CKTS_LC_JCZBBL T
                     WHERE T.SBYWB_DM='A0301001')
    LOOP
      BEGIN
        UPDATE CKTS_SB_MTS_JHMX R
           SET R.SJTB_SJ=SYSDATE, R.ZBBLBZ='N'
         WHERE R.DJXH=CUR_MTS.DJXH AND R.GLH=CUR_MTS.GLH AND R.LCSLID=CUR_MTS.LCSLID AND R.ZBBLBZ='Y';
        UPDATE CKTS_SB_MTS_CKMX R
           SET R.SJTB_SJ=SYSDATE, R.ZBBLBZ='N'
         WHERE R.DJXH=CUR_MTS.DJXH AND R.GLH=CUR_MTS.GLH AND R.LCSLID=CUR_MTS.LCSLID AND R.ZBBLBZ='Y';
        COMMIT;
        LN_I :=LN_I+1;
      END;
    END LOOP;

  RETURN;
END;
/
