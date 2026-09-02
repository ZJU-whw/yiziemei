CREATE OR REPLACE PROCEDURE P_ETL_GS_HBZL_HLV
AS
  pv_tbpc NUMBER(20);
  pv_cnt integer;
BEGIN
  --已取消
  --货币种类，汇率表，按月更新
  --初始化
  UPDATE TB_CKTS_BICODE_SUB SET TBPC = 6 WHERE TBPC = 0;
  COMMIT;
  --同步汇率表,增量更新
  --提醒服务信息表
  DELETE FROM GS_HBZL_HLV WHERE tbpc not in (SELECT mainid FROM tb_dtbsj WHERE tblx_dm = 'GS_HBZL_HLVToYun');
  COMMIT;
  DBMS_OUTPUT.put_line('提醒汇率表历史数据清理成功');

  SELECT count(*) INTO pv_cnt FROM TB_CKTS_BICODE_SUB WHERE tbpc = 6;
  IF pv_cnt > 0 THEN
    --获取同步批次
    pv_tbpc := SEQ_TB_TBPC.NEXTVAL;

    --开始同步,全表刷新
    INSERT INTO GS_HBZL_HLV
    (
      TBPC,
      HL_YM,
      CODE,
      HL_RMB,
      HL_USD,
      HL_RANGE
    )
    SELECT
      pv_tbpc,
      HL_YM,
      CODE,
      HL_RMB,
      HL_USD,
      HL_RANGE
    FROM TB_CKTS_BICODE_SUB
    WHERE TBPC = 6;

    --插入待同步数据
    INSERT INTO tb_dtbsj(id,tblx_dm,mainid,cjsj,tbcs,yxj)
    VALUES(SEQ_TB_DTBSJ_ID.NEXTVAL,'GS_HBZL_HLVToYun',pv_tbpc,sysdate,0,1);
  END IF;

  DELETE FROM TB_CKTS_BICODE_SUB WHERE TBPC = 1;
  UPDATE TB_CKTS_BICODE_SUB SET TBPC = 1 WHERE TBPC = 6;
  COMMIT;
  DBMS_OUTPUT.put_line('货币种类，汇率表同步成功');
  EXCEPTION
    WHEN others THEN
    rollback;
    --记录日志，同步失败
    execute immediate 'INSERT INTO TB_GS_TBSB_RZ(tblx_dm,sbyy) VALUES(:1,:2)'
      using 'GS_HBZL_HLVToYun','失败:' || sqlerrm;
    DBMS_OUTPUT.put_line('货币种类，汇率表同步失败:' || sqlerrm);
    commit;
END;
/
