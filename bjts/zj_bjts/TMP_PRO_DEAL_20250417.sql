CREATE OR REPLACE PROCEDURE TMP_PRO_DEAL_20250417
AS
  LN_MSXSE  NUMBER(18,6);
BEGIN
  FOR CUR_LC IN (SELECT T.XH,T.DJXH FROM tmp_20250417_qy_01 T)
  LOOP
    BEGIN
      LN_MSXSE :=0;
      SELECT NVL(SUM(MSXSE+MDTBFCKXSE),0)
        INTO LN_MSXSE
        FROM HX_SB.SB_ZZS_YBNSR
       WHERE SBUUID IN (SELECT DISTINCT SBUUID
                          FROM HX_SB.SB_SBXX
                         WHERE DJXH=CUR_LC.DJXH
                           AND SKSSQQ>=date'2024-01-01'
                           AND ZSXM_DM='10101' 
                           AND YZPZZL_DM ='BDA0610606'
                           AND GZLX_DM_1 IN ('1','5')
                           AND ZFBZ_1='N' )
         AND EWBLXH=1;
      SELECT LN_MSXSE+ NVL(SUM(MSXSE),0)
        INTO LN_MSXSE
        FROM HX_SB.SB_ZZS_XGM
       WHERE SBUUID IN (SELECT DISTINCT SBUUID
                          FROM HX_SB.SB_SBXX
                         WHERE DJXH=CUR_LC.DJXH
                           AND SKSSQQ>=date'2024-01-01'
                           AND ZSXM_DM='10101' 
                           AND YZPZZL_DM ='BDA0610611'
                           AND GZLX_DM_1 IN ('1','5')
                           AND ZFBZ_1='N' )
         AND EWBLXH=1;
      UPDATE tmp_20250417_qy_01 S
         SET S.ZZSMSE=LN_MSXSE
       WHERE S.XH=CUR_LC.XH;
      COMMIT;
    END;
  END LOOP;

END;
/
