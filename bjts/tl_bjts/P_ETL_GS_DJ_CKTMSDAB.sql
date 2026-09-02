CREATE OR REPLACE PROCEDURE P_ETL_GS_DJ_CKTMSDAB
AS
  --pv_tbpc NUMBER(20);
  pv_cpcode VARCHAR(40);
  pv_cpcodetssh VARCHAR(40);

  pv_nsrdzdah NUMBER(20);
  pv_nsrsbh VARCHAR(20);
  pv_cntnsr_new integer;
  pv_zs_swjg_dm VARCHAR(11);
  pv_swjg_dm VARCHAR(11);
  pv_dqinit NUMBER(20);

  pv_name VARCHAR2(4000);
  pv_qydm VARCHAR2(18);
  pv_swcode VARCHAR2(11);
  pv_zxflag VARCHAR2(1);
  pv_tag VARCHAR2(30);

  --先处理新增加
  CURSOR pc_nsr IS SELECT CPCODE, NSRMC, QYHGDM, NSRSBH, SWJG_DM, NVL(ZX_FLAG,'N') AS ZX_FLAG
  FROM GS_DJ_CKTMSDAB_TB WHERE CPCODE NOT IN (SELECT CPCODE FROM TB_GS_NSRXX t WHERE YXBZ = 'N') ORDER BY NVL(ZX_FLAG,'N') DESC;
  rs_nsr pc_nsr%ROWTYPE;
BEGIN
  --同步出口退税纳税人档案表
  pv_dqinit := 3300000000;

  OPEN pc_nsr;
  LOOP
    FETCH pc_nsr INTO rs_nsr;
    EXIT WHEN pc_nsr%NOTFOUND;
    pv_cpcode := rs_nsr.cpcode;
    pv_name := rs_nsr.nsrmc;
    pv_qydm := rs_nsr.qyhgdm;
    pv_nsrsbh := rs_nsr.nsrsbh;
    pv_swcode := rs_nsr.swjg_dm;
    pv_zxflag := rs_nsr.zx_flag;

    --DBMS_OUTPUT.put_line(pv_cpcode || pv_name);

    --初始化参数
    pv_cntnsr_new := 0;
    pv_nsrdzdah := 0;
    pv_cpcodetssh := '';
    pv_swjg_dm := '';
    pv_zs_swjg_dm := '';
    --获取NSRDZDAH
    BEGIN
      --CPCODE
      SELECT NSRDZDAH, SWJG_DM, ZS_SWJG_DM, CPCODETSSH, TAG INTO pv_nsrdzdah, pv_swjg_dm, pv_zs_swjg_dm, pv_cpcodetssh, pv_tag FROM GS_DJ_CKTMSDAB
      WHERE CPCODE = pv_cpcode AND NSRDZDAH > 0 AND rownum = 1 ORDER BY NVL(ZX_FLAG,'N');
      --DBMS_OUTPUT.put_line('CPCODE');
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
        BEGIN
          --五证合一检查,NSRSBH
          SELECT NSRDZDAH, SWJG_DM, ZS_SWJG_DM, CPCODETSSH, TAG INTO pv_nsrdzdah, pv_swjg_dm, pv_zs_swjg_dm, pv_cpcodetssh, pv_tag FROM GS_DJ_CKTMSDAB
          WHERE NSRSBH = pv_nsrsbh AND NSRDZDAH > 0 AND rownum = 1 ORDER BY NVL(ZX_FLAG,'N');
          --DBMS_OUTPUT.put_line('NSRSBH');
          EXCEPTION
          WHEN NO_DATA_FOUND THEN
              --新增企业
              pv_cntnsr_new := 1;
              BEGIN
                SELECT NSRDZDAH, '', '', NULL INTO pv_nsrdzdah, pv_swjg_dm, pv_zs_swjg_dm, pv_tag FROM TB_GS_NSRXX WHERE CPCODE = pv_cpcode;
                --DELETE FROM TB_GS_NSRXX WHERE QYHGDM = pv_qydm;
                EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  --IF pv_zxflag = 'Y' THEN
                  --  CONTINUE;
                  --END IF;
                  pv_nsrdzdah := pv_dqinit + SEQ_GS_TB_NSRDZDAH.NEXTVAL;
                  INSERT INTO TB_GS_NSRXX(QYHGDM, NSRMC, TBRQ, YXBZ, NSRDZDAH, CPCODE)
                  VALUES(pv_qydm, pv_name, sysdate, 'Y', pv_nsrdzdah, pv_cpcode);
                WHEN OTHERS THEN
                  --记录日志，同步失败
                  DBMS_OUTPUT.put_line('出口退税企业初始化失败4:' || pv_cpcode || sqlerrm);
              END;
          WHEN OTHERS THEN
            --记录日志，同步失败
            DBMS_OUTPUT.put_line('出口退税企业初始化失败2:' || pv_cpcode || sqlerrm);
            COMMIT;
        END;
      WHEN OTHERS THEN
        --记录日志，同步失败
        DBMS_OUTPUT.put_line('出口退税企业初始化失败1:' || pv_cpcode || sqlerrm);
        COMMIT;
    END;

    IF pv_nsrdzdah > 0 THEN
      BEGIN
        --获取同步批次, 取消
        --pv_tbpc := SEQ_TB_TBPC.NEXTVAL;

        IF pv_cntnsr_new = 0 THEN
          IF (pv_swjg_dm <> pv_swcode) THEN
            pv_zs_swjg_dm := null;
          END IF;
        ELSE
          pv_zs_swjg_dm := null;
        END IF;

        --开始同步,增量同步
        --单户
        --删除同海关代码、档案号
        --DBMS_OUTPUT.put_line(pv_nsrsbh);
        --删除同税号，只保留1条最新
        DELETE FROM GS_DJ_CKTMSDAB WHERE NSRDZDAH = pv_nsrdzdah;
        DELETE FROM GS_DJ_CKTMSDAB WHERE CPCODE = pv_cpcode;
        DELETE FROM GS_DJ_CKTMSDAB WHERE NSRSBH = pv_nsrsbh;
        --DELETE FROM GS_DJ_CKTMSDAB WHERE QYHGDM = pv_qydm;

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
          fddbr_cgbl,
          FDDBRSFZJLX_DM,
          YBNSRRDSJQ,
          FIRST_SB_YM,
          NSRZT_DM,
          ZX_DATE,
          ZGSWJ_DM,
          note
        )
        SELECT
          0,
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
          sysdate,
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
          fddbr_cgbl,
          FDDBRSFZJLX_DM,
          YBNSRRDSJQ,
          FIRST_SB_YM,
          NSRZT_DM,
          ZX_DATE,
          ZGSWJ_DM,
          '1'
        FROM GS_DJ_CKTMSDAB_TB
        WHERE CPCODE = pv_cpcode AND NVL(ZX_FLAG,'N') = pv_zxflag;

        --20260623新增
        --FDDBRSFZJLX_DM  N CHAR(3) Y     法人证件类型-NEW
        --YBNSRRDSJQ  N DATE  Y     一般纳税人认定日期-NEW
        --FIRST_SB_YM N VARCHAR2(6) Y     首次申报年月-NEW
        --NSRZT_DM  N CHAR(2) Y     纳税人状态-NEW
        --ZX_DATE N DATE  Y     备案撤回日期-NEW
        --ZGSWJ_DM  N CHAR(11)  Y     征管税务机关代码-NEW

        --插入待同步数据,取消
        --INSERT INTO tb_dtbsj(id,tblx_dm,mainid,cjsj,tbcs,yxj)
        --VALUES(SEQ_TB_DTBSJ_ID.NEXTVAL,'GS_DJ_CKTMSDABToYun',pv_tbpc,sysdate,0,1);

        --记录日志，同步成功
        --DBMS_OUTPUT.put_line(pv_cpcode || nvl(pv_zxflag,'null') || '同步成功' || pv_qydm);
        COMMIT;

        EXCEPTION
        WHEN OTHERS THEN
          ROLLBACK;
          --记录日志，同步失败
          execute immediate 'INSERT INTO TB_GS_TBSB_RZ(tblx_dm,sbyy) VALUES(:1,:2)'
          using 'GS_DJ_CKTMSDAB','失败2:'|| pv_cpcode ||  sqlerrm;
          DBMS_OUTPUT.put_line('出口退税企业同步失败2:' || pv_cpcode || sqlerrm);
      END;
    END IF;
  END LOOP;
  CLOSE pc_nsr;

  COMMIT;
  DBMS_OUTPUT.put_line('出口退税企业同步成功');
  EXCEPTION
    WHEN others THEN
    rollback;
    --记录日志，同步失败
    execute immediate 'INSERT INTO TB_GS_TBSB_RZ(tblx_dm,sbyy) VALUES(:1,:2)'
    using 'GS_DJ_CKTMSDAB','失败:' ||  sqlerrm;
    DBMS_OUTPUT.put_line('出口退税企业同步失败:' || sqlerrm);
    COMMIT;
END;
/
