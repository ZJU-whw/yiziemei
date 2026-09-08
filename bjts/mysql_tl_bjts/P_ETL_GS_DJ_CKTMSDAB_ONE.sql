DELIMITER $$

DROP PROCEDURE IF EXISTS P_ETL_GS_DJ_CKTMSDAB_ONE$$

CREATE PROCEDURE P_ETL_GS_DJ_CKTMSDAB_ONE
(
  IN av_nsrsbh VARCHAR
)
routine_body: BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';
  DECLARE pv_tbpc DECIMAL(20,0);
  DECLARE pv_cpcode VARCHAR(40);
  DECLARE pv_cpcodetssh VARCHAR(40);

  DECLARE pv_nsrdzdah DECIMAL(20,0);
  DECLARE pv_nsrsbh VARCHAR(20);
  DECLARE pv_cntnsr_new integer;
  DECLARE pv_zs_swjg_dm VARCHAR(11);
  DECLARE pv_swjg_dm VARCHAR(11);
  DECLARE pv_dqinit DECIMAL(20,0);

  DECLARE pv_name VARCHAR(4000);
  DECLARE pv_qydm VARCHAR(18);
  DECLARE pv_swcode VARCHAR(11);
  DECLARE pv_zxflag VARCHAR(1);
  DECLARE pv_tag VARCHAR(30);

  -- 先处理注销，再处理新增加




  -- 同步出口退税纳税人档案表

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
    rollback;
    -- 记录日志，同步失败
    SET @BJTS_DYNAMIC_SQL_001 = 'INSERT INTO TB_GS_TBSB_RZ(tblx_dm,sbyy) VALUES(?,?)';
PREPARE BJTS_DYNAMIC_STMT_001 FROM @BJTS_DYNAMIC_SQL_001;
SET @BJTS_BIND_001_001 = 'GS_DJ_CKTMSDABToYun';
SET @BJTS_BIND_001_002 = ORA_CONCAT('失败:', BJTS_SQLERRM_001);
EXECUTE BJTS_DYNAMIC_STMT_001 USING @BJTS_BIND_001_001, @BJTS_BIND_001_002;
DEALLOCATE PREPARE BJTS_DYNAMIC_STMT_001;
    DO ORA_CONCAT('出口退税企业同步失败:', BJTS_SQLERRM_001);
    COMMIT;

  END;
SET pv_dqinit = 3300000000;

  BEGIN
  DECLARE BJTS_FETCH_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_RS_NSR_CPCODE_001 LONGTEXT;
  DECLARE BJTS_RS_NSR_NSRMC_001 LONGTEXT;
  DECLARE BJTS_RS_NSR_QYHGDM_001 LONGTEXT;
  DECLARE BJTS_RS_NSR_NSRSBH_001 LONGTEXT;
  DECLARE BJTS_RS_NSR_SWJG_DM_001 LONGTEXT;
  DECLARE BJTS_RS_NSR_ZX_FLAG_001 LONGTEXT;
  DECLARE BJTS_FETCH_CURSOR_001 CURSOR FOR
SELECT CPCODE, NSRMC, QYHGDM, NSRSBH, SWJG_DM, ZX_FLAG
  FROM GS_DJ_CKTMSDAB_TB WHERE CPCODE NOT IN (SELECT CPCODE FROM TB_GS_NSRXX t WHERE YXBZ = 'N') AND NSRSBH = av_nsrsbh ORDER BY IFNULL(ZX_FLAG, 'N') DESC;
  OPEN BJTS_FETCH_CURSOR_001;
  BJTS_FETCH_LOOP_001: LOOP
    BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_FETCH_DONE_001 = TRUE;
      FETCH BJTS_FETCH_CURSOR_001 INTO BJTS_RS_NSR_CPCODE_001, BJTS_RS_NSR_NSRMC_001, BJTS_RS_NSR_QYHGDM_001, BJTS_RS_NSR_NSRSBH_001, BJTS_RS_NSR_SWJG_DM_001, BJTS_RS_NSR_ZX_FLAG_001;
    END;
    IF BJTS_FETCH_DONE_001 THEN
      LEAVE BJTS_FETCH_LOOP_001;
    END IF;

    SET pv_cpcode = BJTS_RS_NSR_CPCODE_001;
    SET pv_name = BJTS_RS_NSR_NSRMC_001;
    SET pv_qydm = BJTS_RS_NSR_QYHGDM_001;
    SET pv_nsrsbh = BJTS_RS_NSR_NSRSBH_001;
    SET pv_swcode = BJTS_RS_NSR_SWJG_DM_001;
    SET pv_zxflag = BJTS_RS_NSR_ZX_FLAG_001;

    -- DBMS_OUTPUT.put_line(pv_cpcode || pv_name);

    -- 初始化参数
    SET pv_cntnsr_new = 0;
    SET pv_nsrdzdah = 0;
    -- 获取NSRDZDAH
    BEGIN
  DECLARE BJTS_SQLCODE_005 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_005 TEXT DEFAULT '';
      -- CPCODE

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_005 = MYSQL_ERRNO, BJTS_SQLERRM_005 = MESSAGE_TEXT;
        BEGIN
  DECLARE BJTS_SQLCODE_004 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_004 TEXT DEFAULT '';
          -- 五证合一检查,NSRSBH

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_004 = MYSQL_ERRNO, BJTS_SQLERRM_004 = MESSAGE_TEXT;
              -- 新增企业
              SET pv_cntnsr_new = 1;
              BEGIN
  DECLARE BJTS_SQLCODE_003 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_003 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_003 = MYSQL_ERRNO, BJTS_SQLERRM_003 = MESSAGE_TEXT;
                  -- IF pv_zxflag = 'R' THEN
                  --  CONTINUE;
                  -- END IF;
                  SET pv_nsrdzdah = pv_dqinit + SEQ_NEXTVAL('SEQ_GS_TB_NSRDZDAH');
                  INSERT INTO TB_GS_NSRXX(QYHGDM, NSRMC, TBRQ, YXBZ, NSRDZDAH, CPCODE)
                  VALUES(pv_qydm, pv_name, CURRENT_TIMESTAMP, 'Y', pv_nsrdzdah, pv_cpcode);

  END;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_003 = MYSQL_ERRNO, BJTS_SQLERRM_003 = MESSAGE_TEXT;
                  -- 记录日志，同步失败
                  DO ORA_CONCAT(ORA_CONCAT('出口退税企业初始化失败4:', pv_cpcode), BJTS_SQLERRM_003);

  END;
SELECT NSRDZDAH, '', '', NULL INTO pv_nsrdzdah, pv_swjg_dm, pv_zs_swjg_dm, pv_tag FROM TB_GS_NSRXX WHERE CPCODE = pv_cpcode;
                -- DELETE FROM TB_GS_NSRXX WHERE QYHGDM = pv_qydm;
                END;

  END;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_004 = MYSQL_ERRNO, BJTS_SQLERRM_004 = MESSAGE_TEXT;
            -- 记录日志，同步失败
            DO ORA_CONCAT(ORA_CONCAT('出口退税企业初始化失败2:', pv_cpcode), BJTS_SQLERRM_004);
            COMMIT;

  END;
SELECT NSRDZDAH, SWJG_DM, ZS_SWJG_DM, CPCODETSSH, TAG INTO pv_nsrdzdah, pv_swjg_dm, pv_zs_swjg_dm, pv_cpcodetssh, pv_tag FROM GS_DJ_CKTMSDAB
          WHERE NSRSBH = pv_nsrsbh AND NSRDZDAH > 0 AND 1=1 ORDER BY IFNULL(ZX_FLAG, 'N')
LIMIT 1;
          -- DBMS_OUTPUT.put_line('NSRSBH');
          END;

  END;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_005 = MYSQL_ERRNO, BJTS_SQLERRM_005 = MESSAGE_TEXT;
        -- 记录日志，同步失败
        DO ORA_CONCAT(ORA_CONCAT('出口退税企业初始化失败1:', pv_cpcode), BJTS_SQLERRM_005);
        COMMIT;

  END;
SELECT NSRDZDAH, SWJG_DM, ZS_SWJG_DM, CPCODETSSH, TAG INTO pv_nsrdzdah, pv_swjg_dm, pv_zs_swjg_dm, pv_cpcodetssh, pv_tag FROM GS_DJ_CKTMSDAB
      WHERE CPCODE = pv_cpcode AND QYHGDM = pv_qydm AND NSRDZDAH > 0 AND 1=1 ORDER BY IFNULL(ZX_FLAG, 'N')
LIMIT 1;
      -- DBMS_OUTPUT.put_line('CPCODE');
      END;

    IF pv_nsrdzdah > 0 THEN
      BEGIN
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';
        -- 获取同步批次

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
          ROLLBACK;
          -- 记录日志，同步失败
          DO ORA_CONCAT(ORA_CONCAT('出口退税企业同步失败2:', pv_cpcode), BJTS_SQLERRM_002);

  END;
SET pv_tbpc = SEQ_NEXTVAL('SEQ_TB_TBPC');

        IF pv_cntnsr_new = 0 THEN
          IF (pv_swjg_dm <> pv_swcode) THEN
            SET pv_zs_swjg_dm = null;
          END IF;
        ELSE
          SET pv_zs_swjg_dm = null;
        END IF;

        -- 开始同步,增量同步
        -- 单户
        -- 删除同海关代码、档案号
        -- DBMS_OUTPUT.put_line(pv_nsrsbh);
        -- 删除同税号，只保留1条最新
        DELETE FROM GS_DJ_CKTMSDAB WHERE NSRDZDAH = pv_nsrdzdah;
        DELETE FROM GS_DJ_CKTMSDAB WHERE CPCODE = pv_cpcode;
        DELETE FROM GS_DJ_CKTMSDAB WHERE NSRSBH = pv_nsrsbh;
        -- DELETE FROM GS_DJ_CKTMSDAB WHERE QYHGDM = pv_qydm;

        INSERT INTO GS_DJ_CKTMSDAB
        (
          TBPC,
          NSRDZDAH,
          NSRMC,
          NSRMCYW,
          QYHGDM,
          NSRDH,
          NSRCZ,
          NSRYB,
          NSRYX,
          ZCDZ,
          SCJYDZ,
          NSRSBH,
          NSRLX_DM,
          SWJG_DM,
          NSRXYDJ_DM,
          DJZCLX_DM,
          HY_DM,
          LSGX_DM,
          JYZLX_DM,
          BADJBBH,
          SFYSFW,
          YSFW,
          YSFS,
          YFSJ,
          GSDJZZH,
          GSKYRQ,
          GSYXQZ,
          GSDJYXQ,
          GSZCZB,
          FDDBRMC,
          FRZJHM,
          FRDHHM,
          YHMC,
          YHZH,
          BSY1_MC,
          BSY1_ID,
          BSY1_DH,
          BSY2_MC,
          BSY2_ID,
          BSY2_DH,
          ZZSYHZC,
          ZGWHJ,
          FSZL,
          TSJSFS_DM,
          SBFS_MC_ZZBZ,
          SBFS_MC_SJDW,
          SFFBHS,
          FBHSDM,
          QYLX_DM,
          CPCODE,
          NSRDJNO,
          SHXYNO,
          ZS_SWJG_DM,
          ZX_FLAG,
          TSGLLX_DM,
          ZSQYBBSRBZ,
          YHZHTGBZ,
          WMZHFWQYBZ,
          SCSBRQ,
          ZTXTHHBZ,
          ZGSWSKFJ_DM,
          JDXZ_DM,
          XGRQ,
          CPCODETSSH,
          TAG,
          READIN_DATE,
          cwfzrxm,
          cwfzrsfzjhm,
          cwfzrgddh,
          cwfzryddh,
          bsrxm,
          bsrsfzjhm,
          bsrgddh,
          bsryddh,
          djrq,
          scckrq,
          barq,
          fddbr_cgbl
        )
        SELECT
          pv_tbpc,
          pv_nsrdzdah,
          NSRMC,
          NSRMCYW,
          QYHGDM,
          NSRDH,
          NSRCZ,
          NSRYB,
          NSRYX,
          ZCDZ,
          SCJYDZ,
          NSRSBH,
          NSRLX_DM,
          SWJG_DM,
          NSRXYDJ_DM,
          DJZCLX_DM,
          HY_DM,
          LSGX_DM,
          JYZLX_DM,
          BADJBBH,
          SFYSFW,
          YSFW,
          YSFS,
          YFSJ,
          GSDJZZH,
          GSKYRQ,
          GSYXQZ,
          GSDJYXQ,
          GSZCZB,
          FDDBRMC,
          FRZJHM,
          FRDHHM,
          YHMC,
          YHZH,
          BSY1_MC,
          BSY1_ID,
          BSY1_DH,
          BSY2_MC,
          BSY2_ID,
          BSY2_DH,
          ZZSYHZC,
          ZGWHJ,
          FSZL,
          TSJSFS_DM,
          SBFS_MC_ZZBZ,
          SBFS_MC_SJDW,
          SFFBHS,
          FBHSDM,
          QYLX_DM,
          CPCODE,
          NSRDJNO,
          SHXYNO,
          pv_zs_swjg_dm,
          ZX_FLAG,
          TSGLLX_DM,
          ZSQYBBSRBZ,
          YHZHTGBZ,
          WMZHFWQYBZ,
          SCSBRQ,
          ZTXTHHBZ,
          ZGSWSKFJ_DM,
          JDXZ_DM,
          XGRQ,
          pv_cpcodetssh,
          pv_tag,
          CURRENT_TIMESTAMP,
          cwfzrxm,
          cwfzrsfzjhm,
          cwfzrgddh,
          cwfzryddh,
          bsrxm,
          bsrsfzjhm,
          bsrgddh,
          bsryddh,
          djrq,
          scckrq,
          barq,
          fddbr_cgbl
        FROM GS_DJ_CKTMSDAB_TB
        WHERE CPCODE = pv_cpcode AND QYHGDM = pv_qydm;

        -- 插入待同步数据
        INSERT INTO tb_dtbsj(id,tblx_dm,mainid,cjsj,tbcs,yxj)
        VALUES(SEQ_NEXTVAL('SEQ_TB_DTBSJ_ID'),'GS_DJ_CKTMSDABToYun',pv_tbpc,CURRENT_TIMESTAMP,0,1);

        -- 记录日志，同步成功
        DO ORA_CONCAT(ORA_CONCAT(pv_cpcode, '同步成功'), pv_qydm);
        COMMIT;

        END;
    END IF;

  END LOOP BJTS_FETCH_LOOP_001;
  CLOSE BJTS_FETCH_CURSOR_001;
END;

  COMMIT;
  DO '出口退税企业同步成功';
  END$$

DELIMITER ;
