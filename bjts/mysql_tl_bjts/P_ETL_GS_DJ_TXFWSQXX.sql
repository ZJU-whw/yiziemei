DELIMITER $$

DROP PROCEDURE IF EXISTS P_ETL_GS_DJ_TXFWSQXX$$

CREATE PROCEDURE P_ETL_GS_DJ_TXFWSQXX
routine_body: BEGIN
  DECLARE pv_tbpc DECIMAL(20,0);
  DECLARE pv_nsrdzdah DECIMAL(20,0);
  DECLARE pv_qyhgdm VARCHAR(32);
  DECLARE pv_cnt BIGINT;
  --注销纳税人不导
  DECLARE pc_nsr CURSOR FOR SELECT DISTINCT CPCODE FROM GS_DJ_TXFWSQXX WHERE TBPC = 6 and CPCODE IS NOT NULL;
  DECLARE rs_nsr pc_nsr%ROWTYPE;

  ----已取消
  UPDATE GS_DJ_TXFWSQXX SET TBPC = 6 WHERE TBPC = 0;
  COMMIT;
  --同步提醒服务信息表,增量更新
  --提醒服务信息表
  --DELETE FROM GS_DJ_TXFWSQXX WHERE tbpc not in (SELECT mainid FROM tb_dtbsj WHERE tblx_dm = 'GS_DJ_TXFWSQXXToYun');
  --COMMIT;
  --DBMS_OUTPUT.put_line('提醒服务信息表历史数据清理成功');

  --ETL调用
  --初始化
  SET pv_cnt = 0;
  SELECT count(DISTINCT CPCODE) INTO pv_cnt FROM GS_DJ_TXFWSQXX WHERE TBPC = 6;
  DBMS_OUTPUT.put_line('同步提醒服务信息表同步开始 ['||CAST(pv_cnt AS CHAR)||'] 户');
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
      WHEN OTHERS THEN
        CONTINUE;
    END;

    BEGIN
      --获取同步批次
      SET pv_tbpc = SEQ_NEXTVAL('SEQ_TB_TBPC');
      --开始同步
      --增量
      --pv_czrq := sysdate;
      --TB_CKTS_GC_SQ_TXFW
      UPDATE GS_DJ_TXFWSQXX SET NSRDZDAH = pv_nsrdzdah WHERE CPCODE = pv_qyhgdm AND TBPC = 6;
      
      --插入待同步数据
      --INSERT INTO tb_dtbsj(id,tblx_dm,mainid,cjsj,tbcs,yxj)
      --VALUES(SEQ_TB_DTBSJ_ID.NEXTVAL,'GS_DJ_TXFWSQXXToYun',pv_tbpc,sysdate,0,1);
      --DBMS_OUTPUT.put_line(pv_qyhgdm || '同步成功');

      EXCEPTION
      WHEN OTHERS THEN
        ROLLBACK;
        --记录日志，同步失败
        DBMS_OUTPUT.put_line('提醒服务信息表同步失败:' || pv_qyhgdm || sqlerrm);
        CONTINUE;
    END;
  END LOOP;
  CLOSE pc_nsr;

  UPDATE GS_DJ_TXFWSQXX SET TBPC = 1 WHERE TBPC = 6;
  COMMIT;
  DBMS_OUTPUT.put_line('提醒服务信息表同步成功');
  EXCEPTION
    WHEN others THEN
    rollback;
    --记录日志，同步失败
    execute immediate 'INSERT INTO TB_GS_TBSB_RZ(tblx_dm,sbyy) VALUES(:1,:2)'
      using 'GS_DJ_TXFWSQXXToYun','失败:' || sqlerrm;
    DBMS_OUTPUT.put_line('提醒服务信息表同步失败:' || sqlerrm);
    commit;
END$$

DELIMITER ;
