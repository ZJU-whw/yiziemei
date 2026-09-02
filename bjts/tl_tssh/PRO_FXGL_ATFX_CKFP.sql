CREATE OR REPLACE PROCEDURE PRO_FXGL_ATFX_CKFP
/*
 * 风险管理——案头分析——出口电子信息补充发票号码、境外收货人信息
 */
(
  P_DJXH    IN VARCHAR2
)
AS
  LC_CKFP        VARCHAR2(30);
  LN_FGF         NUMBER(5);
  LC_WSMC        VARCHAR2(300);
BEGIN
  FOR CUR_CK IN (SELECT CK.DJXH,CK.CKBGDH,CK.DLCKHWZMHM
                   FROM TL_TSSH.ATFX_CK_YS_CKDZXX CK
                  WHERE CK.DJXH=P_DJXH
                    AND CK.CYTSSBJL IS NOT NULL AND CK.CKFPHM IS NULL)
  LOOP
    BEGIN
      IF CUR_CK.DLCKHWZMHM IS NULL THEN
        SELECT CKFPH
          INTO LC_CKFP
          FROM (SELECT MTS.CKFPH
                  FROM TL_TSSH.ATFX_TS_YS_CKMXSBB MTS
                 WHERE MTS.DJXH=CUR_CK.DJXH
                   AND MTS.CKBGDH=CUR_CK.CKBGDH
                 UNION ALL
                SELECT MDT.CKFPH
                  FROM TL_TSSH.ATFX_TS_YS_MDTSSBB MDT
                 WHERE MDT.DJXH=CUR_CK.DJXH
                   AND MDT.CKBGDH=CUR_CK.CKBGDH)
         WHERE ROWNUM=1;
      ELSE
        SELECT CKFPH
          INTO LC_CKFP
          FROM (SELECT MTS.CKFPH
                  FROM TL_TSSH.ATFX_TS_YS_CKMXSBB MTS
                 WHERE MTS.DJXH=CUR_CK.DJXH
                   AND MTS.DLZMH=CUR_CK.DLCKHWZMHM
                 UNION ALL
                SELECT MDT.CKFPH
                  FROM TL_TSSH.ATFX_TS_YS_MDTSSBB MDT
                 WHERE MDT.DJXH=CUR_CK.DJXH
                   AND MDT.DLCKHWZMHM=CUR_CK.DLCKHWZMHM)
         WHERE ROWNUM=1;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        LC_CKFP := NULL;
    END;
    
    IF LC_CKFP IS NOT NULL THEN
      LN_FGF := INSTR(LC_CKFP,',');
      IF LN_FGF>0 THEN
        LC_CKFP := SUBSTR(LC_CKFP,1,LN_FGF-1);
      END IF;
      LN_FGF := INSTR(LC_CKFP,'-');
      IF LN_FGF>0 THEN
        LC_CKFP := SUBSTR(LC_CKFP,1,LN_FGF-1);
      END IF;
      BEGIN
        IF LENGTH(LC_CKFP) IN (18,20) THEN
          SELECT FP.GMFMC
            INTO LC_WSMC
            FROM TL_TSSH.ATFX_FP_YS_XSFPXX FP
           WHERE FP.DJXH=CUR_CK.DJXH
             AND FP.FPHM=LC_CKFP
             AND ROWNUM=1;
        ELSE
          SELECT FP.GMFMC
            INTO LC_WSMC
            FROM TL_TSSH.ATFX_FP_YS_XSFPXX FP
           WHERE FP.DJXH=CUR_CK.DJXH
             AND FP.FPHM LIKE '%'||LC_CKFP
             AND ROWNUM=1;
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          LC_WSMC := NULL;
      END;
      
      UPDATE ATFX_CK_YS_CKDZXX T
         SET T.CKFPHM = LC_CKFP,
             T.JWSHR = LC_WSMC
       WHERE T.DJXH = CUR_CK.DJXH
         AND T.CKBGDH = CUR_CK.CKBGDH;
      COMMIT;
    END IF;
  END LOOP;
  
  RETURN;
END;
/
