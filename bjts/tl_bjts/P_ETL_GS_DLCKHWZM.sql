CREATE OR REPLACE PROCEDURE P_ETL_GS_DLCKHWZM
AS
  pv_tbpc NUMBER(20);
  pv_newpc NUMBER(20);
  pv_nsrdzdah NUMBER(20);
  pv_qyhgdm VARCHAR(32);
  pv_cnt NUMBER(12);
  --注销纳税人不导
  CURSOR pc_nsr IS SELECT DISTINCT WT_CPCODE FROM TB_CKTS_HISTORY_ZJDLZM WHERE TBPC = 6 and WT_CPCODE IS NOT NULL;
  rs_nsr pc_nsr%ROWTYPE;
BEGIN
  --已取消
  UPDATE TB_CKTS_HISTORY_ZJDLZM SET TBPC = 6 WHERE TBPC = 0;
  COMMIT;
  --代理出口货物证明表
  DELETE FROM GS_DLCKHWZM WHERE tbpc not in (SELECT mainid FROM tb_dtbsj WHERE tblx_dm = 'GS_DLCKHWZMToYun');
  COMMIT;
  DBMS_OUTPUT.put_line('代理出口货物证明表历史数据清理成功');

  --ETL调用
  --初始化
  pv_cnt := 0;
  SELECT count(DISTINCT WT_CPCODE) INTO pv_cnt FROM TB_CKTS_HISTORY_ZJDLZM WHERE TBPC = 6;
  DBMS_OUTPUT.put_line('同步代理出口货物证明表同步开始 ['||TO_CHAR(pv_cnt)||'] 户');
  IF pv_cnt = 0 THEN
     RETURN;
  END IF;

  OPEN pc_nsr;
  LOOP
    FETCH pc_nsr INTO rs_nsr;
    EXIT WHEN pc_nsr%NOTFOUND;
    pv_qyhgdm := rs_nsr.wt_cpcode;

    --获取NSRDZDAH
    BEGIN
      SELECT NSRDZDAH INTO pv_nsrdzdah FROM GS_DJ_CKTMSDAB WHERE CPCODE = pv_qyhgdm AND NSRDZDAH > 0 AND NVL(ZX_FLAG,'N') <> 'Y';
      EXCEPTION
      WHEN OTHERS THEN
        CONTINUE;
    END;

    BEGIN
      --获取同步批次
      pv_tbpc := SEQ_TB_TBPC.NEXTVAL;
      --开始同步
      --增量
      --开始同步
      --pv_czrq := sysdate;
      INSERT INTO GS_DLCKHWZM
      (
        TBPC,
        NSRDZDAH,
        DLCKHWZM,
        HGBGDH,
        CKRQ,
        HGMYXZ_DM,
        SPDM,
        SPMC,
        JLDW,
        SL,
        HBZL_DM,
        JE_LAJ_USD,
        HLV_USD,
        JE_LAJ_RMB,
        FLAG_PP
      )
      SELECT
        pv_tbpc,
        pv_nsrdzdah,
        dlzm_no,
        bgd_no,
        lj_date,
        tdcode,
        cmcode,
        cmname,
        cmunit,
        bg_qnt,
        bicode,
        usd_amt,
        null,
        null,
        null
      FROM TB_CKTS_HISTORY_ZJDLZM
      WHERE WT_CPCODE = pv_qyhgdm AND TBPC = 6;

      --超过1000条，分批
      LOOP
        SELECT count(*) INTO pv_cnt from GS_DLCKHWZM WHERE tbpc = pv_tbpc;
        EXIT WHEN pv_cnt < 1000;
        pv_newpc := SEQ_TB_TBPC.NEXTVAL;

        update GS_DLCKHWZM set tbpc = pv_newpc where tbpc = pv_tbpc and rownum < 1001;
        INSERT INTO tb_dtbsj(id,tblx_dm,mainid,cjsj,tbcs,yxj)
        VALUES(SEQ_TB_DTBSJ_ID.NEXTVAL,'GS_DLCKHWZMToYun',pv_newpc,sysdate,0,1);
        COMMIT;
      END LOOP;

      --插入待同步数据
      INSERT INTO tb_dtbsj(id,tblx_dm,mainid,cjsj,tbcs,yxj)
      VALUES(SEQ_TB_DTBSJ_ID.NEXTVAL,'GS_DLCKHWZMToYun',pv_tbpc,sysdate,0,1);
      COMMIT;
      DBMS_OUTPUT.put_line(pv_qyhgdm || '同步成功' || to_char(pv_cnt) || '条数据');

      EXCEPTION
      WHEN OTHERS THEN
        ROLLBACK;
        --记录日志，同步失败
        execute immediate 'UPDATE TB_CKTS_HISTORY_ZJDLZM SET TBPC=9,TBERR=:1 WHERE CPCODE=:2 AND TBPC=6'
        using sqlerrm, pv_qyhgdm;
        COMMIT;
        DBMS_OUTPUT.put_line('代理出口货物证明表同步失败:' || pv_qyhgdm || sqlerrm);
        CONTINUE;
    END;
  END LOOP;
  CLOSE pc_nsr;

  DELETE FROM TB_CKTS_HISTORY_ZJDLZM WHERE TBPC = 1;
  UPDATE TB_CKTS_HISTORY_ZJDLZM SET TBPC = 1 WHERE TBPC = 6;
  COMMIT;
  DBMS_OUTPUT.put_line('代理出口货物证明表同步成功');
  EXCEPTION
    WHEN others THEN
    rollback;
    --记录日志，同步失败
    execute immediate 'INSERT INTO TB_GS_TBSB_RZ(tblx_dm,sbyy) VALUES(:1,:2)'
      using 'GS_DLCKHWZMToYun','失败:' || sqlerrm;
    DBMS_OUTPUT.put_line('代理出口货物证明表同步失败:' || sqlerrm);
    commit;
END;
/
