DELIMITER $$

DROP PROCEDURE IF EXISTS P_ETL_GS_JLJG_JHFPL$$

CREATE PROCEDURE P_ETL_GS_JLJG_JHFPL
routine_body: BEGIN
  DECLARE pv_tbpc DECIMAL(20,0);
  DECLARE pv_nsrdzdah DECIMAL(20,0);
  DECLARE pv_qyhgdm VARCHAR(32);
  DECLARE pv_cnt integer;
  DECLARE pc_nsr CURSOR FOR SELECT DISTINCT CPCODE FROM TB_CKTS_GC_JLJG_JHFPL WHERE CPCODE IS NOT NULL;
  DECLARE rs_nsr pc_nsr%ROWTYPE;

  --已取消
  --UPDATE TB_CKTS_GC_JLJG_JHFPL SET TBPC = 6 WHERE TBPC = 0;
  --COMMIT;
  --同步进料加工计划分配率表
  --进料加工计划分配率表
  DELETE FROM GS_JLJG_JHFPL WHERE tbpc not in (SELECT mainid FROM tb_dtbsj WHERE tblx_dm = 'GS_JLJG_JHFPLToYun');
  COMMIT;
  DBMS_OUTPUT.put_line('进料加工计划分配率表历史数据清理成功');

  --ETL调用
  --初始化
  SET pv_cnt = 0;
  SELECT count(DISTINCT CPCODE) INTO pv_cnt FROM TB_CKTS_GC_JLJG_JHFPL;
  DBMS_OUTPUT.put_line('同步进料加工计划分配率表同步开始 ['||CAST(pv_cnt AS CHAR)||'] 户');
  IF pv_cnt = 0 THEN
     LEAVE routine_body;
  END IF;

  OPEN pc_nsr;
  LOOP
    FETCH pc_nsr INTO rs_nsr;
    EXIT WHEN pc_nsr%NOTFOUND;
    SET pv_qyhgdm = rs_nsr.cpcode;

    --获取NSRDZDAH
    BEGIN
      SELECT NSRDZDAH INTO pv_nsrdzdah FROM GS_DJ_CKTMSDAB WHERE CPCODE = pv_qyhgdm AND NSRDZDAH > 0 AND IFNULL(ZX_FLAG, 'N') <> 'Y';
      EXCEPTION
        WHEN others THEN
        CONTINUE;
    END;

    BEGIN
      --获取同步批次
      SET pv_tbpc = SEQ_NEXTVAL('SEQ_TB_TBPC');

      --开始同步
      --开始同步,增量同步
      --单户
      --每次维护TSSH.GC_JLJG_JHFPL最新
      --每次维护tssh.gc_jljg_jhfpl_his，历史信息
      --pv_czrq := sysdate;
      INSERT INTO GS_JLJG_JHFPL
      (
        TBPC,
        NSRDZDAH,
        SSSQ,
        JHFPLV,
        JHFPLV_NEW,
        UPTIME
      )
      SELECT
        pv_tbpc,
        pv_nsrdzdah,
        SB_YM,
        JHFPL,
        JHFPL_NEW,
        OP_DATE
      FROM TB_CKTS_GC_JLJG_JHFPL
      WHERE CPCODE = pv_qyhgdm;

      --插入待同步数据
      INSERT INTO tb_dtbsj(id,tblx_dm,mainid,cjsj,tbcs,yxj)
      VALUES(SEQ_NEXTVAL('SEQ_TB_DTBSJ_ID'),'GS_JLJG_JHFPLToYun',pv_tbpc,CURRENT_TIMESTAMP,0,1);
      COMMIT;
      DBMS_OUTPUT.put_line(pv_qyhgdm || '同步成功');

      EXCEPTION
      WHEN OTHERS THEN
        ROLLBACK;
        --记录日志，同步失败
        execute immediate 'UPDATE TB_CKTS_GC_JLJG_JHFPL SET TBPC=9,TBERR=:1 WHERE CPCODE=:2'
        using sqlerrm, pv_qyhgdm;
        COMMIT;
        DBMS_OUTPUT.put_line('进料加工计划分配率表同步失败:' || pv_qyhgdm || sqlerrm);
        CONTINUE;
    END;
  END LOOP;
  CLOSE pc_nsr;

  --DELETE FROM TB_CKTS_GC_JLJG_JHFPL WHERE TBPC = 1;
  --UPDATE TB_CKTS_GC_JLJG_JHFPL SET TBPC = 1 WHERE TBPC = 6;
  COMMIT;
  DBMS_OUTPUT.put_line('进料加工计划分配率表同步成功');
  EXCEPTION
    WHEN others THEN
    rollback;
    --记录日志，同步失败
    execute immediate 'INSERT INTO TB_GS_TBSB_RZ(tblx_dm,sbyy) VALUES(:1,:2)'
      using 'GS_JLJG_JHFPLToYun','失败:' || sqlerrm;
    DBMS_OUTPUT.put_line('进料加工计划分配率表同步失败:' || sqlerrm);
    commit;
END$$

DELIMITER ;
