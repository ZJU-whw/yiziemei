CREATE OR REPLACE PROCEDURE PRO_DXTX_JJYQ
/*
 * 20260515，根据杭州市局王薇意见，每年4月申报期增加卷烟免税核销的提醒
 */
AS
  LL_JJR        NUMBER(10);
  LL_TSSB       NUMBER(10);
  LL_FUH        NUMBER(10);
  LL_FUHCL      NUMBER(10);
  LL_SDHC       NUMBER(10);
  LL_FXCK       NUMBER(10);
  LL_NKSQTX     NUMBER(10);
  LL_NKSHJD     NUMBER(10);
  LL_MSZMHX     NUMBER(10);
  LC_SWJGDM     VARCHAR2(11);
  LC_MSG        VARCHAR2(200);
BEGIN
  SELECT COUNT(1)
    INTO LL_JJR
    FROM TL_BJTS.PUB_JJR T
   WHERE T.JJR_DATE=TRUNC(SYSDATE);

  FOR CUR_USER IN (SELECT T.ID,T.JOB_TYPE,T.PHONE,T.SWJG_DM,T.SWJG_MC,T.USERNAME,
                          T.JJYQ_TSSB,T.JJYQ_FUH,T.JJYQ_FUHCL,T.JJYQ_SDHC,T.FXCK,T.NKSQTX,T.NKSHJD,T.JJRTXBZ
                    FROM TL_TSSH.MSG_PUSH_USER T
                   WHERE T.QYBZ='Y')
  LOOP
    IF CUR_USER.JJRTXBZ='N' AND LL_JJR>0 THEN
      CONTINUE;
    END IF;
    IF CUR_USER.JOB_TYPE IN ('1','2') THEN -- 区县局
      BEGIN
        IF CUR_USER.JJYQ_TSSB='Y' THEN
          BEGIN
            SELECT COUNT(1)
              INTO LL_TSSB
              FROM MSG_PUSH_DATA S
             WHERE S.SWJG_DM=CUR_USER.SWJG_DM AND S.BIZTYPE='退税办理' AND S.SJTBSJ>=TRUNC(SYSDATE);
            IF LL_TSSB>0 THEN
              INSERT INTO MSG_PUSH_PLAN(ID,USERID,CONTENT,SEND_TYPE,SEND_TARG,CRTIME,PLAN_FLAG,QYBZ,PLAN_TAG,SWJG_DM,USERNAME)
                   SELECT SEQ_MSG_PUSH_PLAN.NEXTVAL,CUR_USER.ID,
                          '温馨提醒：['||CUR_USER.SWJG_MC||']，有'||LL_TSSB||'笔出口退(免)税业务即将超期，请及时办理。谢谢！',
                          '0',CUR_USER.PHONE,SYSDATE,'0','Y',TO_CHAR(SYSDATE,'YYYY-MM-DD')||'-01',
                          CUR_USER.SWJG_DM,CUR_USER.USERNAME
                     FROM DUAL;
              COMMIT;
            END IF;
          END;
        END IF;

        IF CUR_USER.JJYQ_FUH='Y' THEN
          BEGIN
            SELECT COUNT(1)
              INTO LL_FUH
              FROM MSG_PUSH_DATA S
             WHERE S.SWJG_DM=CUR_USER.SWJG_DM AND S.BIZTYPE='函调复函' AND S.SJTBSJ>=TRUNC(SYSDATE);
            IF LL_FUH>0 THEN
              INSERT INTO MSG_PUSH_PLAN(ID,USERID,CONTENT,SEND_TYPE,SEND_TARG,CRTIME,PLAN_FLAG,QYBZ,PLAN_TAG,SWJG_DM,USERNAME)
                   SELECT SEQ_MSG_PUSH_PLAN.NEXTVAL,CUR_USER.ID,
                          '温馨提醒：['||CUR_USER.SWJG_MC||']，'||S.YWBZ||'的函调业务即将超期，请及时办理。谢谢！',
                          '0',CUR_USER.PHONE,SYSDATE,'0','Y',TO_CHAR(SYSDATE,'YYYY-MM-DD')||'-02-'||S.BIZKEY,CUR_USER.SWJG_DM,CUR_USER.USERNAME
                     FROM MSG_PUSH_DATA S
                    WHERE S.SWJG_DM=CUR_USER.SWJG_DM AND S.BIZTYPE='函调复函' AND S.SJTBSJ>=TRUNC(SYSDATE);
              COMMIT;
            END IF;
          END;
        END IF;

        IF CUR_USER.JJYQ_FUHCL='Y' THEN
          BEGIN
            SELECT COUNT(1)
              INTO LL_FUHCL
              FROM MSG_PUSH_DATA S
             WHERE S.SWJG_DM=CUR_USER.SWJG_DM AND S.BIZTYPE='函调处理' AND S.SJTBSJ>=TRUNC(SYSDATE);
            IF LL_FUHCL>0 THEN
              INSERT INTO MSG_PUSH_PLAN(ID,USERID,CONTENT,SEND_TYPE,SEND_TARG,CRTIME,PLAN_FLAG,QYBZ,PLAN_TAG,SWJG_DM,USERNAME)
                   SELECT SEQ_MSG_PUSH_PLAN.NEXTVAL,CUR_USER.ID,
                          '温馨提醒：['||CUR_USER.SWJG_MC||']，'||S.YWBZ||'已于'||TO_CHAR(QDSJ,'YYYY-MM-DD')||'回函，请及时办理。谢谢！',
                          '0',CUR_USER.PHONE,SYSDATE,'0','Y',TO_CHAR(SYSDATE,'YYYY-MM-DD')||'-05-'||S.BIZKEY,CUR_USER.SWJG_DM,CUR_USER.USERNAME
                     FROM MSG_PUSH_DATA S
                    WHERE S.SWJG_DM=CUR_USER.SWJG_DM AND S.BIZTYPE='函调处理' AND S.SJTBSJ>=TRUNC(SYSDATE);
              COMMIT;
            END IF;
          END;
        END IF;

        IF CUR_USER.JJYQ_SDHC='Y' THEN
          BEGIN
            SELECT COUNT(1)
              INTO LL_SDHC
              FROM MSG_PUSH_DATA S
             WHERE S.SWJG_DM=CUR_USER.SWJG_DM AND S.BIZTYPE='容缺办理' AND S.SJTBSJ>=TRUNC(SYSDATE);
            IF LL_SDHC>0 THEN
              INSERT INTO MSG_PUSH_PLAN(ID,USERID,CONTENT,SEND_TYPE,SEND_TARG,CRTIME,PLAN_FLAG,QYBZ,PLAN_TAG,SWJG_DM,USERNAME)
                   SELECT SEQ_MSG_PUSH_PLAN.NEXTVAL,CUR_USER.ID,
                          '温馨提醒：['||CUR_USER.SWJG_MC||']，税号['||S.NSRSBH||']的容缺办理退税业务，实地核查即将超期，请及时办理。谢谢！',
                          '0',CUR_USER.PHONE,SYSDATE,'0','Y',TO_CHAR(SYSDATE,'YYYY-MM-DD')||'-03-'||S.BIZKEY,CUR_USER.SWJG_DM,CUR_USER.USERNAME
                     FROM MSG_PUSH_DATA S
                    WHERE S.SWJG_DM=CUR_USER.SWJG_DM AND S.BIZTYPE='容缺办理' AND S.SJTBSJ>=TRUNC(SYSDATE);
              COMMIT;
            END IF;
          END;
        END IF;

        IF CUR_USER.FXCK='Y' THEN
          BEGIN
            SELECT COUNT(1)
              INTO LL_FXCK
              FROM MSG_PUSH_DATA S
             WHERE S.SWJG_DM=CUR_USER.SWJG_DM AND S.BIZTYPE='风险出口电子信息' AND S.SJTBSJ>=TRUNC(SYSDATE);
            IF LL_FXCK>0 THEN
              INSERT INTO MSG_PUSH_PLAN(ID,USERID,CONTENT,SEND_TYPE,SEND_TARG,CRTIME,PLAN_FLAG,QYBZ,PLAN_TAG,SWJG_DM,USERNAME)
                   SELECT SEQ_MSG_PUSH_PLAN.NEXTVAL,CUR_USER.ID,
                          '温馨提醒：['||CUR_USER.SWJG_MC||']，您部门扫描到['||LL_FXCK||']笔风险出口电子信息，请加强监管。详情请到便捷退税管理系统的短信关联业务查询！',
                          '0',CUR_USER.PHONE,SYSDATE,'0','Y',TO_CHAR(SYSDATE,'YYYY-MM-DD')||'-04',CUR_USER.SWJG_DM,CUR_USER.USERNAME
                     FROM DUAL;
              COMMIT;
            END IF;
          END;
        END IF;

        IF CUR_USER.NKSQTX='Y' THEN
          BEGIN
            SELECT COUNT(1)
              INTO LL_NKSQTX
              FROM MSG_PUSH_DATA S
             WHERE S.SWJG_DM=CUR_USER.SWJG_DM AND S.BIZTYPE='内控提醒' AND S.SJTBSJ>=TRUNC(SYSDATE);
            IF LL_NKSQTX>0 THEN
              INSERT INTO MSG_PUSH_PLAN(ID,USERID,CONTENT,SEND_TYPE,SEND_TARG,CRTIME,PLAN_FLAG,QYBZ,PLAN_TAG,SWJG_DM,USERNAME)
                   SELECT SEQ_MSG_PUSH_PLAN.NEXTVAL,CUR_USER.ID,
                          '温馨提醒：['||CUR_USER.SWJG_MC||']，您部门扫描到['||LL_FXCK||']笔内控风险事前提醒业务，请及时处理。详情请到便捷退税管理系统的内控管理——内控风险处理——事前提醒信息管理查询！',
                          '0',CUR_USER.PHONE,SYSDATE,'0','Y',TO_CHAR(SYSDATE,'YYYY-MM-DD')||'-04',CUR_USER.SWJG_DM,CUR_USER.USERNAME
                     FROM DUAL;
              COMMIT;
            END IF;
          END;
        END IF;

        IF CUR_USER.NKSHJD='Y' THEN
          BEGIN
            SELECT COUNT(1)
              INTO LL_NKSHJD
              FROM MSG_PUSH_DATA S
             WHERE S.SWJG_DM=CUR_USER.SWJG_DM AND S.BIZTYPE='内控监督' AND S.SJTBSJ>=TRUNC(SYSDATE);
            IF LL_NKSHJD>0 THEN
              INSERT INTO MSG_PUSH_PLAN(ID,USERID,CONTENT,SEND_TYPE,SEND_TARG,CRTIME,PLAN_FLAG,QYBZ,PLAN_TAG,SWJG_DM,USERNAME)
                   SELECT SEQ_MSG_PUSH_PLAN.NEXTVAL,CUR_USER.ID,
                          '温馨提醒：['||CUR_USER.SWJG_MC||']，您部门扫描到['||LL_FXCK||']笔内控风险事后监督业务，请及时处理。详情请到便捷退税管理系统的内控管理——内控风险处理——事后风险信息管理查询！',
                          '0',CUR_USER.PHONE,SYSDATE,'0','Y',TO_CHAR(SYSDATE,'YYYY-MM-DD')||'-04',CUR_USER.SWJG_DM,CUR_USER.USERNAME
                     FROM DUAL;
              COMMIT;
            END IF;
          END;
        END IF;

        IF CUR_USER.JJYQ_TSSB='Y' THEN
          BEGIN
            SELECT COUNT(1)
              INTO LL_MSZMHX
              FROM MSG_PUSH_DATA S
             WHERE S.SWJG_DM=CUR_USER.SWJG_DM AND S.BIZTYPE='免税核销' AND S.SJTBSJ>=TRUNC(SYSDATE);
            IF LL_MSZMHX>0 THEN
              INSERT INTO MSG_PUSH_PLAN(ID,USERID,CONTENT,SEND_TYPE,SEND_TARG,CRTIME,PLAN_FLAG,QYBZ,PLAN_TAG,SWJG_DM,USERNAME)
                   SELECT SEQ_MSG_PUSH_PLAN.NEXTVAL,CUR_USER.ID,
                          '温馨提醒：['||CUR_USER.SWJG_MC||']，您部门扫描到['||LL_FXCK||']笔企业（出口卷烟/来料加工证明）未免税核销的提醒，请提醒企业及时核销。详情请到便捷退税管理系统的内控管理——内控风险处理——事后风险信息管理查询！',
                          '0',CUR_USER.PHONE,SYSDATE,'0','Y',TO_CHAR(SYSDATE,'YYYY-MM-DD')||'-04',CUR_USER.SWJG_DM,CUR_USER.USERNAME
                     FROM DUAL;
              COMMIT;
            END IF;
          END;
        END IF;

      END;
    ELSE
      BEGIN
        IF CUR_USER.JOB_TYPE = '3' THEN
          LC_SWJGDM :=SUBSTR(CUR_USER.SWJG_DM, 1, 5)||'%';
        ELSE
          LC_SWJGDM :=SUBSTR(CUR_USER.SWJG_DM, 1, 3)||'%';
        END IF;
        SELECT COUNT(1)
          INTO LL_TSSB
          FROM MSG_PUSH_DATA S
         WHERE S.SWJG_DM LIKE LC_SWJGDM AND S.BIZTYPE='退税办理' AND S.SJTBSJ>=TRUNC(SYSDATE)
           AND CUR_USER.JJYQ_TSSB='Y';
        SELECT COUNT(1)
          INTO LL_FUH
          FROM MSG_PUSH_DATA S
         WHERE S.SWJG_DM LIKE LC_SWJGDM AND S.BIZTYPE='函调复函' AND S.SJTBSJ>=TRUNC(SYSDATE)
           AND CUR_USER.JJYQ_FUH='Y';
        SELECT COUNT(1)
          INTO LL_FUHCL
          FROM MSG_PUSH_DATA S
         WHERE S.SWJG_DM LIKE LC_SWJGDM AND S.BIZTYPE='函调处理' AND S.SJTBSJ>=TRUNC(SYSDATE)
           AND CUR_USER.JJYQ_FUHCL='Y';
        SELECT COUNT(1)
          INTO LL_SDHC
          FROM MSG_PUSH_DATA S
         WHERE S.SWJG_DM LIKE LC_SWJGDM AND S.BIZTYPE='容缺办理' AND S.SJTBSJ>=TRUNC(SYSDATE)
           AND CUR_USER.JJYQ_SDHC='Y';
        SELECT COUNT(1)
          INTO LL_MSZMHX
          FROM MSG_PUSH_DATA S
         WHERE S.SWJG_DM LIKE LC_SWJGDM AND S.BIZTYPE='免税核销' AND S.SJTBSJ>=TRUNC(SYSDATE)
           AND CUR_USER.JJYQ_TSSB='Y';
        IF (LL_TSSB + LL_FUH + LL_FUHCL + LL_SDHC + LL_MSZMHX) >0 THEN
          LC_MSG := '温馨提醒：[' || CUR_USER.SWJG_MC || ']，下属各局共有';
          IF LL_TSSB > 0 THEN
            LC_MSG := LC_MSG || LL_TSSB || '笔出口退(免)税业务，';
          END IF;
          IF LL_FUH > 0 THEN
            LC_MSG := LC_MSG || LL_FUH || '笔函调复函业务，';
          END IF;
          IF LL_FUHCL > 0 THEN
            LC_MSG := LC_MSG || LL_FUHCL || '笔复函处理业务，';
          END IF;
          IF LL_SDHC > 0 THEN
            LC_MSG := LC_MSG || LL_SDHC || '笔容缺办理的实地核查业务，';
          END IF;
          IF LL_MSZMHX > 0 THEN
            LC_MSG := LC_MSG || LL_MSZMHX || '笔企业免税核销提醒，';
          END IF;
          LC_MSG := LC_MSG || '即将超期，请督促办理。谢谢！';
          INSERT INTO MSG_PUSH_PLAN(ID,USERID,CONTENT,SEND_TYPE,SEND_TARG,CRTIME,PLAN_FLAG,QYBZ,PLAN_TAG,SWJG_DM,USERNAME)
               SELECT SEQ_MSG_PUSH_PLAN.NEXTVAL,CUR_USER.ID,LC_MSG,'0',CUR_USER.PHONE,
                      SYSDATE,'0','Y',TO_CHAR(SYSDATE,'YYYY-MM-DD'),CUR_USER.SWJG_DM,CUR_USER.USERNAME
                 FROM DUAL;
          COMMIT;
        END IF;
      END;
    END IF;
  END LOOP;

  RETURN;
END;
/
