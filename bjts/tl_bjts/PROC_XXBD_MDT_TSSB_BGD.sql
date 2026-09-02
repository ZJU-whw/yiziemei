CREATE OR REPLACE PROCEDURE PROC_XXBD_MDT_TSSB_BGD
/*
  编制人:严国平
  编制日期:202009
  功能:信息比对（生产企业免抵退税）
  调整日期：20201106，1、对HZCJ不判断剩余数量和美元离岸价，2、对金额增加null判断，3、监管方式1200列入进料加工
  调整日期：20201109，1、历史已申报记录本期冲减本期重新申报，对重新申报记录的数量、金额比对逻辑调整
  调整日期：20201119，1、调整改单报关单监控条件，由bgd202不存在改为bgd201.gdbz_1<>Y，2、调整MDT_CKHW_BGD_XLXP_NOT为可挑过提示性疑点
  调整日期：20201201，1、调整报关单总量控制疑点的疑点对象赋值，原来自动用了进料加工，现调整回出口报关单
  调整日期：20210113，1、调整改单报关单监控条件，改为bgd202不存在 且 bgd201.gdbz_1<>Y
  调整日期：20210416，1、MDT_CKHW_BDG_CKRQ的监控条件，剔除经保税区出口业务类型，该业务类型采用出境货物备案清单的日期，与报关单离境日期不一样
  调整日期：20210512，1、调整MDT_CKHW_BGD_USDLAJ监控条件，对本期红字冲减本期正数申报的数据当合计离岸价小于0的时候也校验差异说明
  调整日期：20210812，1、调整MDT_CKHW_BGD_CD、MDT_CKHW_BGD_GD监控条件，对红字冲减业务不判断
  调整日期：20211108，1、调整MDT_CKHW_BGD_WDZXX监控条件，对红字冲减业务不判断（永康徐育泽反应有企业已申报数据海关作废，导致冲减时201找不到）
  调整日期：20211111，1、与魏浩确认，调整离岸价差异表监控条件，增加疑点MDT_CKHW_BGD_USDLAJ_CY
                       2、增加红字冲减与原申报数的比较疑点MDT_CKHW_BGD_HZCJ_BYZ
                       3、调整MDT_CKHW_BGD_USDLAJ监控条件与说明
  调整日期：20211123，对疑点MDT_LACY_BGD_USDLAJ的校验逻辑进行修正，仅校验bgd201表，不校验bgd202表，与202表的校验改到PROC_XXBD_MDT_TSSB_BGD中进行
                       （通过增加MDT_CKHW_BGD_USDLAJ_GD疑点，在企业申报数据与201不一致需要差异说明时，如果存在改单数据与申报一致，提示）
  调整日期：20211213，对疑点MDT_CKHW_BGD_BYTS的校验逻辑进行修正，仅针对非红字冲减或红字冲减退运的业务进行判断
  调整日期：20211214，对疑点MDT_JLJG_SCH_NOJLJG的校验逻辑进行修正，同时判断企业是否填了加工贸易手册号或计划分配率
  调整日期：20220707, 增加非红字冲减报关单历史是否曾经申报退税的判断，疑点代码MDT_CKHW_BGD_LSSBJL
  调整日期：20220720，1、出口日期不一致疑点代码，由MDT_CKHW_BDG_CKRQ改为MDT_CKHW_BGD_CKRQ
  调整日期：20230308，1、针对启运港业务的负数冲减，不判断MDT_CKHW_BGD_QYGTS_CXCK、MDT_CKHW_BGD_QYGTS_FLGLCD、MDT_CKHW_BGD_QYGTS_CKRQ、MDT_CKHW_BGD_QYGTS_WDD
  调整日期：20230313，增加MDT_CKHW_BGD_BSQ_BAQD、MDT_CKHW_BGD_BSQ_BANR、MDT_CKHW_BGD_RMBLAJ、MDT_CKHW_BGD_HZCJ_TY疑点判断
 */
(
  V_IN_NSRDZDAH   IN  NUMBER, /*纳税人电子档案号*/
  V_IN_DJXH       IN  NUMBER, /*登记序号*/
  V_IN_SBYWBDM    IN  VARCHAR2, /*申报业务表代码*/
  V_IN_SSSQ       IN  VARCHAR2, /*申报年月*/
  V_IN_SBPC       IN  NUMBER, /*申报批次*/
  V_IN_SBID       IN  NUMBER, /*申报ID*/
  V_OUT_STATUS    OUT VARCHAR2, /*00:成功; 其他:执行失败*/
  V_OUT_MESSAGE   OUT VARCHAR2
)
AS
  LN_MXROW        NUMBER(10);
  LC_YDOBJECT     VARCHAR2(20);
  LN_CPCODEKZ     NUMBER(10);
  LC_FLGLCD       VARCHAR2(20);
  LC_KZXX         VARCHAR2(20);
  LN_CMCD_LEN     NUMBER(10);
  LN_ZHJHFPL      NUMBER(16,6);
BEGIN
  V_OUT_STATUS :='00';
  V_OUT_MESSAGE:=' ';


  --报关单出口货物劳务明细表记录为空，不需要比对
  BEGIN
    SELECT COUNT(1)
      INTO LN_MXROW
      FROM CKTS_SB_MDT_TSSB_LSB T
     WHERE T.SBID=V_IN_SBID
       AND T.CKBGDH IS NOT NULL;
    IF LN_MXROW=0 THEN
      RETURN;
    END IF;
  END;
  LC_YDOBJECT :='出口报关单';

  --获取进料加工企业最新调整计划分配律
  BEGIN
    SELECT ZHJHFPL
      INTO LN_ZHJHFPL
      FROM (SELECT CASE WHEN T.JHFPLV_NEW=0 THEN T.JHFPLV ELSE T.JHFPLV_NEW END AS ZHJHFPL
              FROM GS_JLJG_JHFPL T
             WHERE T.NSRDZDAH=V_IN_NSRDZDAH
             ORDER BY T.UPTIME DESC)
     WHERE ROWNUM=1;
  EXCEPTION
    WHEN OTHERS THEN
      LN_ZHJHFPL :=0;
  END;

  BEGIN
    INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
         SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,T.SBXH,NULL,'MDT_CKHW_BGD_WDZXX','E',
                '出口货物报关单号[' || T.CKBGDH || ']无电子信息！','N',SYSDATE
           FROM CKTS_SB_MDT_TSSB_LSB T
          WHERE T.SBID=V_IN_SBID
            AND T.CKBGDH IS NOT NULL
            AND FUNC_XXBD_CHECK_YWLX(',' || T.CKTMSYWLXDMJH || ',') = 0 
            AND INSTR(NVL(T.CKTMSYWLXDMJH,' '),'HZCJ')=0
            AND NOT EXISTS (SELECT 1 FROM CKTS_WBSJ_HG_BGD201 S WHERE S.DJXH=V_IN_DJXH AND S.CKBGDH=T.CKBGDH);
    COMMIT;
  END;

  BEGIN
    FOR LSF_XX IN (SELECT A.SBXH,
                          A.CKBGDH,
                          B.BYTSBZ,
                          B.CYTSSBJL,
                          TRUNC(A.CKRQ_1,'DD') AS CKRQ_SB,
                          TRUNC(B.CKRQ_1,'DD') AS CKRQ_SH,
                          TRUNC(B.QYRQ_2,'DD') AS QYRQ_SH,
                          NVL(A.CKTMSYWLXDMJH,' ') AS CKTMSYWLXDMJH,
                          A.CKSP_DM AS CKSP_DM_SB,
                          B.CKSP_DM AS CKSP_DM_SH,
                          D.TYYBSWTSTYLX_DM,
                          NVL(B.GDBZ_1,' ') AS GDBZ_1,
                          E.CKBGDH AS CKBGDH_GD,
                          E.MYLAJ AS MYLAJ_GD,
                          C.JGFS_DM,
                          C.JGFSTSLX_DM,
                          B.ZZMDGDQSZ_DM,
                          B.QYGBZ,
                          B.QYGCXCKBZ,
                          B.QYGWDDBZ,
                          B.QYGZCJGBZ,
                          B.YSFS_DM,
                          A.JLJGSZCH,
                          A.TZHJHFPL,
                          B.BAH,
                          G.SJFPL,
                          A.CKSL AS CKSL_SB,
                          A.MYLAJ AS MYLAJ_SB,
                          A.RMBLAJ AS RMBLAJ_SB,
                          B.MYLAJ,
                          NVL(B.TSSBSL,0) AS TSSBSL,
                          NVL(B.TSSBMYLAJ,0) AS TSSBMYLAJ,
                          NVL(B.TSSBRMBLAJ,0) AS TSSBRMBLAJ,
                          F.CKFPMYLAJ
                     FROM CKTS_SB_MDT_TSSB_LSB A
                    INNER JOIN CKTS_WBSJ_HG_BGD201 B ON B.DJXH=V_IN_DJXH AND B.CKBGDH=A.CKBGDH
                     LEFT JOIN CKTS_DM_HGJGFS C ON C.JGFS_DM=B.JGFS_DM
                     LEFT JOIN CKTS_JGB_ZM_TYYBSWTS D ON D.DJXH=V_IN_DJXH AND D.CKBGDH=A.CKBGDH AND NVL(D.ZFBZ_1,'N')='N'
                     LEFT JOIN CKTS_WBSJ_HG_BGD202 E ON D.DJXH=V_IN_DJXH AND E.CKBGDH=A.CKBGDH
                     LEFT JOIN CKTS_SB_MDT_CYSM_LSB F ON F.SBID=V_IN_SBID AND F.CKBGDH=A.CKBGDH
                     LEFT JOIN (SELECT JGMYSCH, HXQSRQ, HXJZRQ, SJFPL,
                                       ROW_NUMBER() OVER (PARTITION BY JGMYSCH, 
                                       CASE WHEN SUBSTR(JGMYSCH,1,1)='C' THEN NULL ELSE HXQSRQ END, 
                                       CASE WHEN SUBSTR(JGMYSCH,1,1)='C' THEN NULL ELSE HXJZRQ END ORDER BY LRRQ DESC) AS RN
                                  FROM GS_JLJG_HXJG
                                 WHERE NSRDZDAH=V_IN_NSRDZDAH) G ON G.JGMYSCH=A.JLJGSZCH AND RN=1 AND (SUBSTR(A.JLJGSZCH,1,1)='C' OR (A.CKRQ_1 BETWEEN G.HXQSRQ AND G.HXJZRQ))
                    WHERE A.SBID=V_IN_SBID
                      AND A.CKBGDH IS NOT NULL 
                      AND FUNC_XXBD_CHECK_YWLX(',' || A.CKTMSYWLXDMJH || ',') = 0) LOOP
      BEGIN
        LC_YDOBJECT :='出口报关单';
        
        IF (INSTR(LSF_XX.CKTMSYWLXDMJH,'HZCJ')>0) THEN
          IF (INSTR(LSF_XX.CKTMSYWLXDMJH,'HZCJ-TY')=0) THEN
            --20211111, 增加红字冲减与原申报数的比较
            BEGIN
              IF (LSF_XX.CKSL_SB + LSF_XX.TSSBSL <>0) THEN
                INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                     SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                            'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_HZCJ_BYZ','E',
                            '出口货物报关单号[' || LSF_XX.CKBGDH || ']业务类型选择红字冲减，出口数量与已申报出口数量[' || LSF_XX.TSSBSL || ']不一致！','N',SYSDATE
                       FROM DUAL;
                COMMIT;
              END IF;
              IF (LSF_XX.MYLAJ_SB + LSF_XX.TSSBMYLAJ <>0) THEN
                INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                     SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                            'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_HZCJ_BYZ','E',
                            '出口货物报关单号[' || LSF_XX.CKBGDH || ']业务类型选择红字冲减，美元离岸价与已申报美元离岸价[' || LSF_XX.TSSBMYLAJ || ']不一致！','N',SYSDATE
                       FROM DUAL;
                COMMIT;
              END IF;
              IF (LSF_XX.RMBLAJ_SB + LSF_XX.TSSBRMBLAJ <>0) THEN
                INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                     SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                            'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_HZCJ_BYZ','E',
                            '出口货物报关单号[' || LSF_XX.CKBGDH || ']业务类型选择红字冲减，人民币离岸价与已申报人民币离岸价[' || LSF_XX.TSSBRMBLAJ || ']不一致！','N',SYSDATE
                       FROM DUAL;
                COMMIT;
              END IF;
            END;
          ELSE
            --20230314, 增加红字冲减-退运与原退运证明一致性的提示
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                        'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_HZCJ_TY','I',
                        '出口货物报关单号[' || LSF_XX.CKBGDH || ']业务类型选择红字冲减-退运，请核实退运冲减的人民币离岸价与应冲减的退运证明对应的实际出口销售额是否一致！','Y',SYSDATE
                   FROM DUAL;
            COMMIT;
          END IF;
        ELSE
          BEGIN
            --20211111，与魏浩确认，离岸价差异只比对申报数与海关出口数，不关联申报数量、已申报数量（包括退税、代理、退运）
            IF (ABS(LSF_XX.MYLAJ_SB-LSF_XX.MYLAJ)>1) AND (ABS(LSF_XX.MYLAJ_SB-LSF_XX.MYLAJ)>0.05 * LSF_XX.MYLAJ) AND (LSF_XX.CKFPMYLAJ IS NULL) THEN
              BEGIN
                INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                     SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                            'CKTS_SB_MDT_TSSB_LSB','CKTS_SB_MDT_CYSM_LSB',NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_USDLAJ_CY','E',
                            '出口货物报关单号[' || LSF_XX.CKBGDH || ']美元离岸价[' || LSF_XX.MYLAJ_SB || ']超过电子信息中[' || LSF_XX.MYLAJ || ']合理范围，需提供《出口货物离岸价差异原因说明表》！','N',SYSDATE
                       FROM DUAL;
                COMMIT;
                
                --存在离岸价差异且未填报差异说明表的情况下，判断是否因改单引起
                IF (LSF_XX.CKBGDH_GD IS NOT NULL) AND ((ABS(LSF_XX.MYLAJ_SB-LSF_XX.MYLAJ_GD)<=1) OR (ABS(LSF_XX.MYLAJ_SB-LSF_XX.MYLAJ_GD)<=0.05 * LSF_XX.MYLAJ_GD)) THEN
                  INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                       SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                              'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_USDLAJ_GD','I',
                              '出口货物报关单号[' || LSF_XX.CKBGDH || ']存在改单后信息，且改单后信息未同步到报关单电子信息中！','Y',SYSDATE
                         FROM DUAL;
                  COMMIT;
                END IF;
              END;
            END IF;
            --20220707, 增加非红字冲减报关单历史是否曾经申报退税的判断
            IF (TRIM(LSF_XX.CYTSSBJL) IS NOT NULL) AND (LSF_XX.TSSBSL>0) THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                          'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_LSSBJL','I',
                          '出口货物报关单号[' || LSF_XX.CKBGDH || ']曾经参与历史申报，请确认是否重复！','Y',SYSDATE
                     FROM DUAL;
              COMMIT;
            END IF;
            -- 20211213，对红字冲减、红字冲减退运业务，不判断已经标注“不予退税”
            IF (LSF_XX.BYTSBZ='Y') THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                          'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_BYTS','E',
                          '出口货物报关单号[' || LSF_XX.CKBGDH || ']已被标注为“不予退税”！','N',SYSDATE
                     FROM DUAL;
              COMMIT;
            END IF;
            --1退运; 2改单; 3撤单
            IF (LSF_XX.TYYBSWTSTYLX_DM='3') THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                          'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_CD','E',
                          '出口货物报关单号[' || LSF_XX.CKBGDH || ']曾办理过用途为”撤单“的有效的退运证明！','N',SYSDATE
                     FROM DUAL;
              COMMIT;
            ELSIF (LSF_XX.TYYBSWTSTYLX_DM='2' AND LSF_XX.GDBZ_1<>'Y' AND LSF_XX.CKBGDH_GD IS NULL) THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                          'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_GD','E',
                          '出口货物报关单号[' || LSF_XX.CKBGDH || ']曾办理过用途为“改单”的有效的退运证明，且在“海关出口报关单改单数据”中不存在！','N',SYSDATE
                     FROM DUAL;
              COMMIT;
            END IF;
          END;
        END IF;

        LN_CMCD_LEN := CASE WHEN LENGTH(LSF_XX.CKSP_DM_SB) > LENGTH(LSF_XX.CKSP_DM_SH) THEN LENGTH(LSF_XX.CKSP_DM_SH) ELSE LENGTH(LSF_XX.CKSP_DM_SB) END;
        IF SUBSTR(LSF_XX.CKSP_DM_SB,1,LN_CMCD_LEN)<>SUBSTR(LSF_XX.CKSP_DM_SH,1,LN_CMCD_LEN) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_SPDM','E',
                      '出口货物报关单号[' || LSF_XX.CKBGDH || ']商品代码[' || LSF_XX.CKSP_DM_SB || ']与电子信息中[' || LSF_XX.CKSP_DM_SH || ']不一致！','N',SYSDATE
                 FROM DUAL;
          COMMIT;
        END IF;

        IF (TRIM(LSF_XX.JGFS_DM) IS NULL) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_MYXZ_BCZ','E',
                      '出口货物报关单号[' || LSF_XX.CKBGDH || ']在电子信息中监管方式不存在！','N',SYSDATE
                 FROM DUAL;
          COMMIT;
        ELSE
          IF (TRIM(LSF_XX.JGFSTSLX_DM)='0') THEN
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                        'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_MYXZ_BTS','E',
                        '出口货物报关单号[' || LSF_XX.CKBGDH || ']在电子信息中监管方式[' || LSF_XX.JGFS_DM || ']不退税！','N',SYSDATE
                   FROM DUAL;
            COMMIT;
          END IF;
        END IF;

        IF LSF_XX.ZZMDGDQSZ_DM<>'142' AND INSTR(LSF_XX.CKTMSYWLXDMJH,'LMYCL')>0 THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MTS_CKHW_BGD_LMYCL_ZZMDG','E',
                      '出口货物报关单号[' || LSF_XX.CKBGDH || ']贸易国别非中国，“业务类型”不应包含“LMYCL”！','N',SYSDATE
                 FROM DUAL;
          COMMIT;
        END IF;

        IF (INSTR(LSF_XX.CKTMSYWLXDMJH,'QYGTS')>0) THEN
          BEGIN
            IF (LSF_XX.CKRQ_SB<>LSF_XX.QYRQ_SH) AND (INSTR(LSF_XX.CKTMSYWLXDMJH,'BSQ')=0) THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                          'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_CKRQ','E',
                          '出口货物报关单号[' || LSF_XX.CKBGDH || ']出口日期[' || TO_CHAR(LSF_XX.CKRQ_SB,'YYYY-MM-DD') || ']与电子信息中[' || TO_CHAR(LSF_XX.QYRQ_SH,'YYYY-MM-DD') || ']不一致！','N',SYSDATE
                     FROM DUAL;
              COMMIT;
            END IF;
            IF LSF_XX.QYGBZ<>'Y' THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                          'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_QYGTS_NOT',
                          'E','出口货物报关单号[' || LSF_XX.CKBGDH || ']非启运港业务，“业务类型”不应包含“QYGTS”！','N',SYSDATE
                     FROM DUAL;
              COMMIT;
            ELSIF (INSTR(LSF_XX.CKTMSYWLXDMJH,'HZCJ')=0) THEN
              BEGIN
                IF LSF_XX.QYGCXCKBZ='Y' THEN
                  INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                       SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                              'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_QYGTS_CXCK','E',
                              '出口货物报关单号[' || LSF_XX.CKBGDH || ']为启运港业务，已经撤销出口！','N',SYSDATE
                         FROM DUAL;
                  COMMIT;
                END IF;
                LN_CPCODEKZ:=FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH,'FLGLCD',LSF_XX.QYRQ_SH,LC_FLGLCD);
                IF (LC_FLGLCD<>'A' AND LC_FLGLCD<>'B') THEN
                  INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                       SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                              'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_QYGTS_FLGLCD','E',
                              '出口货物报关单号[' || LSF_XX.CKBGDH || ']启运日当天该企业分类管理类别非一、二类，“业务类型”不应包含“QYGTS”！','N',SYSDATE
                         FROM DUAL;
                  COMMIT;
                END IF;
                IF MONTHS_BETWEEN(TRUNC(SYSDATE),LSF_XX.QYRQ_SH)>2 THEN
                  INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                       SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                              'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_QYGTS_CKRQ','E',
                              '出口货物报关单号[' || LSF_XX.CKBGDH || ']超过启运日两月，“业务类型”不应包含“QYGTS”！','N',SYSDATE
                         FROM DUAL;
                  COMMIT;
                END IF;
                IF LSF_XX.QYGWDDBZ='Y' THEN
                  INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                       SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                              'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_QYGTS_WDD','E',
                              '出口货物报关单号[' || LSF_XX.CKBGDH || ']未实际到达离境港，“业务类型”不应包含“QYGTS”！','N',SYSDATE
                         FROM DUAL;
                  COMMIT;
                END IF;
              END;
            END IF;
          END;
        ELSE
          BEGIN
            IF (LSF_XX.CKRQ_SB<>LSF_XX.CKRQ_SH) AND (INSTR(LSF_XX.CKTMSYWLXDMJH,'BSQ')=0) THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                          'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_CKRQ','E',
                          '出口货物报关单号[' || LSF_XX.CKBGDH || ']出口日期[' || TO_CHAR(LSF_XX.CKRQ_SB,'YYYY-MM-DD') || ']与电子信息中[' || TO_CHAR(LSF_XX.CKRQ_SH,'YYYY-MM-DD') || ']不一致！','N',SYSDATE
                     FROM DUAL;
              COMMIT;
            END IF;
            IF (LSF_XX.QYGBZ='Y' AND LSF_XX.QYGZCJGBZ='N') THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                          'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_QYGTS_NULL','E',
                          '出口货物报关单号[' || LSF_XX.CKBGDH || ']为启运港业务，目前尚未收到结关信息，“业务类型”应包含“QYGTS”！','N',SYSDATE
                     FROM DUAL;
              COMMIT;
            END IF;
          END;
        END IF;

        IF (INSTR(LSF_XX.CKTMSYWLXDMJH,'DWCB')>0 AND LSF_XX.JGFS_DM<>'3422' AND LSF_XX.JGFS_DM<>'22') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_DWCB_NOT','E',
                      '出口货物报关单号[' || LSF_XX.CKBGDH || ']非对外承包业务，“业务类型”不应包含“DWCB”！','N',SYSDATE
                 FROM DUAL;
          COMMIT;
        END IF;
        IF (INSTR(LSF_XX.CKTMSYWLXDMJH,'DWCB')=0 AND (LSF_XX.JGFS_DM='3422' OR LSF_XX.JGFS_DM='22')) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_DWCB_NULL','E',
                      '出口货物报关单号[' || LSF_XX.CKBGDH || ']为对外承包业务，“业务类型”应包含“DWCB”！','N',SYSDATE
                 FROM DUAL;
          COMMIT;
        END IF;

        IF (INSTR(LSF_XX.CKTMSYWLXDMJH,'BSQ')>0) THEN
          IF (LSF_XX.YSFS_DM<>'0') THEN
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                        'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_BSQ_NOT','E',
                        '出口货物报关单号[' || LSF_XX.CKBGDH || ']非经保税区出口业务，“业务类型”不应包含“BSQ”！','N',SYSDATE
                   FROM DUAL;
            COMMIT;
          ELSE
            BEGIN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                          'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_BSQ_BAQD','I',
                          '出口货物报关单号[' || LSF_XX.CKBGDH || ']业务类型包含保税区BSQ，请核实是否附送《出境货物备案清单》！','Y',SYSDATE
                     FROM DUAL;
              COMMIT;
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                          'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_BSQ_BANR','I',
                          '出口货物报关单号[' || LSF_XX.CKBGDH || ']业务类型包含保税区BSQ，请核实出境货物备案清单的内容是否与报关单相关内容相符,出口日期填报是否准确！','Y',SYSDATE
                     FROM DUAL;
              COMMIT;
            END;
          END IF;
        END IF;
        IF (INSTR(LSF_XX.CKTMSYWLXDMJH,'BSQ')=0 AND LSF_XX.YSFS_DM='0') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_BSQ_NULL','E',
                      '出口货物报关单号[' || LSF_XX.CKBGDH || ']为经保税区出口业务，“业务类型”应包含“BSQ”！','N',SYSDATE
                 FROM DUAL;
          COMMIT;
        END IF;

        IF (INSTR(LSF_XX.CKTMSYWLXDMJH,'JWTZ')>0 AND LSF_XX.JGFS_DM<>'2210') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_JWTZ_NOT','E',
                      '出口货物报关单号[' || LSF_XX.CKBGDH || ']非境外投资业务，“业务类型”不应包含“JWTZ”！','N',SYSDATE
                 FROM DUAL;
          COMMIT;
        END IF;
        IF (INSTR(LSF_XX.CKTMSYWLXDMJH,'JWTZ')=0 AND LSF_XX.JGFS_DM='2210') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_JWTZ_NULL','E',
                      '出口货物报关单号[' || LSF_XX.CKBGDH || ']为境外投资业务，“业务类型”应包含“JWTZ”！','N',SYSDATE
                 FROM DUAL;
          COMMIT;
        END IF;

        IF (INSTR(LSF_XX.CKTMSYWLXDMJH,'DWYZ')>0 AND LSF_XX.JGFS_DM<>'3511') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_DWYZ_NOT','E',
                      '出口货物报关单号[' || LSF_XX.CKBGDH || ']非对外援助业务，“业务类型”不应包含“DWYZ”！','N',SYSDATE
                 FROM DUAL;
          COMMIT;
        END IF;
        IF (INSTR(LSF_XX.CKTMSYWLXDMJH,'DWYZ')=0 AND LSF_XX.JGFS_DM='3511') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_DWYZ_NULL','E',
                      '出口货物报关单号[' || LSF_XX.CKBGDH || ']为对外援助业务，“业务类型”应包含“DWYZ”！','N',SYSDATE
                 FROM DUAL;
          COMMIT;
        END IF;

        IF (INSTR(LSF_XX.CKTMSYWLXDMJH,'XLXP')>0 AND LSF_XX.JGFS_DM<>'1300') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_XLXP_NOT','I',
                      '出口货物报关单号[' || LSF_XX.CKBGDH || ']非修理修配业务，请确认“业务类型”是否选择正确！','Y',SYSDATE
                 FROM DUAL;
          COMMIT;
        END IF;
        IF (INSTR(LSF_XX.CKTMSYWLXDMJH,'XLXP')=0 AND LSF_XX.JGFS_DM='1300') THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_XLXP_NULL','E',
                      '出口货物报关单号[' || LSF_XX.CKBGDH || ']为修理修配业务，“业务类型”应包含“XLXP”！','N',SYSDATE
                 FROM DUAL;
          COMMIT;
        END IF;

        IF LSF_XX.YSFS_DM='8' AND LSF_XX.ZZMDGDQSZ_DM='142' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_BSCKZNX','E',
                      '出口货物报关单号[' || LSF_XX.CKBGDH || ']为保税仓库转内销！','N',SYSDATE
                 FROM DUAL;
          COMMIT;
        END IF;

        IF LSF_XX.YSFS_DM='T' THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_CKPZH_YSFS','E',
                      '出口货物报关单号[' || LSF_XX.CKBGDH || ']为出口到综合试验区（横琴平潭地区）的报关单！','N',SYSDATE
                 FROM DUAL;
          COMMIT;
        END IF;

        LC_YDOBJECT :='进料加工';
        IF LSF_XX.JGFS_DM IN ('0615','0715') THEN
          BEGIN
            IF LSF_XX.JLJGSZCH IS NULL THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                          'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_JLJG_BDG_NOSCH','E',
                          '出口货物报关单号[' || LSF_XX.CKBGDH || ']在电子信息中监管方式为0615/0715，出口明细未申报进料加工手册号！','N',SYSDATE
                     FROM DUAL;
              COMMIT;
            ELSIF LSF_XX.JLJGSZCH <> LSF_XX.BAH THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                          'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_JLJG_JGMYSCH','E',
                          '出口货物报关单号[' || LSF_XX.CKBGDH || ']申报的进料加工手账册号与电子信息中不一致！','N',SYSDATE
                     FROM DUAL;
              COMMIT;
            END IF;

            IF LSF_XX.TZHJHFPL IS NULL THEN
              INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                   SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                          'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_JLJG_BDG_NOFPLV','E',
                          '出口货物报关单号[' || LSF_XX.CKBGDH || ']在电子信息中监管方式为0615/0715，出口明细未申报计划分配率！','N',SYSDATE
                     FROM DUAL;
              COMMIT;
            ELSE
              BEGIN
                IF (LSF_XX.SJFPL IS NOT NULL) AND (LSF_XX.TZHJHFPL<>LSF_XX.SJFPL) THEN
                  INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                       SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                              'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_JLJG_SJFPLV_YHX','E',
                              '该手（账）册号已完成核销，请按照对应的实际分配率修改后后重新申报！','N',SYSDATE
                         FROM DUAL;
                  COMMIT;
                END IF;
                IF (LSF_XX.SJFPL IS NULL) AND (LSF_XX.TZHJHFPL<>LN_ZHJHFPL) THEN
                  INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                       SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                              'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_JLJG_SJFPLV_WHX','E',
                              '申报的进料加工计划分配率与当前有效的计划分配率[' || LN_ZHJHFPL || ']不一致，请反馈计划分配率后重新申报！','N',SYSDATE
                         FROM DUAL;
                  COMMIT;
                END IF;
              END;
            END IF;
          END;
        ELSE
          --20211214，针对企业导入的数据，有可能手册号为空但是存在分配率的，增加分配率的判断
          IF (LSF_XX.JLJGSZCH IS NOT NULL) OR (NVL(LSF_XX.TZHJHFPL,0)<>0) THEN
            INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
                 SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                        'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_JLJG_SCH_NOJLJG','I',
                        '出口货物报关单号[' || LSF_XX.CKBGDH || ']申报了手册号（或计划分配率），电子信息中监管方式非0615/0715，请确认！','Y',SYSDATE
                   FROM DUAL;
            COMMIT;
          END IF;
        END IF;
      END;
    END LOOP;
  END;

  BEGIN
    LC_YDOBJECT :='出口报关单';
    FOR LSF_XX IN (SELECT A.CKBGDH,
                          A.SBXH,
                          A.CKSL_SB,
                          B.CKSL,
                          NVL(B.TSSBSL,0) AS TSSBSL,
                          NVL(B.DLSBSL,0) AS DLSBSL,
                          NVL(B.TYSL,0) AS TYSL,
                          B.CKSL-NVL(B.TSSBSL,0)-NVL(B.DLSBSL,0)-NVL(B.TYSL,0) AS SYSL_SH,
                          A.MYLAJ_SB,
                          B.MYLAJ,
                          NVL(B.TSSBMYLAJ,0) AS TSSBMYLAJ,
                          NVL(B.DLSBMYLAJ,0) AS DLSBMYLAJ,
                          NVL(B.TYMYLAJ,0) AS TYMYLAJ,
                          B.MYLAJ-NVL(B.TSSBMYLAJ,0)-NVL(B.DLSBMYLAJ,0)-NVL(B.TYMYLAJ,0) AS MYLAJ_SH,
                          A.RMBLAJ_SB,
                          B.RMBLAJ,
                          NVL(B.TSSBRMBLAJ,0) AS TSSBRMBLAJ,
                          NVL(B.DLSBRMBLAJ,0) AS DLSBRMBLAJ,
                          NVL(B.TYRMBLAJ,0) AS TYRMBLAJ,
                          B.RMBLAJ-NVL(B.TSSBRMBLAJ,0)-NVL(B.DLSBRMBLAJ,0)-NVL(B.TYRMBLAJ,0) AS RMBLAJ_SH
                     FROM (SELECT A.CKBGDH, MIN(A.SBXH) AS SBXH, SUM(A.CKSL) AS CKSL_SB, SUM(A.MYLAJ) AS MYLAJ_SB, SUM(A.RMBLAJ) AS RMBLAJ_SB
                             FROM CKTS_SB_MDT_TSSB_LSB A
                            WHERE A.SBID=V_IN_SBID
                              AND A.CKBGDH IS NOT NULL
                              AND FUNC_XXBD_CHECK_YWLX(',' || A.CKTMSYWLXDMJH || ',') = 0
                            GROUP BY A.CKBGDH) A
                    INNER JOIN CKTS_WBSJ_HG_BGD201 B ON B.DJXH=V_IN_DJXH AND B.CKBGDH=A.CKBGDH) LOOP
      BEGIN
        IF (LSF_XX.CKSL_SB > 0) AND (LSF_XX.CKSL_SB - LSF_XX.SYSL_SH > 0) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_CKSL','I',
                      '出口货物报关单号[' || LSF_XX.CKBGDH || ']申报退税数量[' || LSF_XX.CKSL_SB || ']超过电子信息中剩余数量[' || LSF_XX.SYSL_SH ||
                      ']（其中出口[' || LSF_XX.CKSL || ']退税申报[' || LSF_XX.TSSBSL || ']退运[' || LSF_XX.TYSL || ']代理出口[' || LSF_XX.DLSBSL || ']）！','Y',SYSDATE
                 FROM DUAL;
          COMMIT;
        END IF;
        
        IF (LSF_XX.MYLAJ_SB>0) AND (LSF_XX.MYLAJ_SB - LSF_XX.MYLAJ_SH > 1) AND (LSF_XX.MYLAJ > LSF_XX.MYLAJ_SH) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_USDLAJ','I',
                      '出口货物报关单号[' || LSF_XX.CKBGDH || ']申报美元离岸价[' || LSF_XX.MYLAJ_SB || ']超过电子信息中剩余美元离岸价[' || LSF_XX.MYLAJ_SH ||
                      ']（其中出口[' || LSF_XX.MYLAJ || ']退税申报[' || LSF_XX.TSSBMYLAJ || ']退运[' || LSF_XX.TYMYLAJ || ']代理出口[' || LSF_XX.DLSBMYLAJ || ']）！','Y',SYSDATE
                 FROM DUAL;
          COMMIT;
        END IF;
        
        IF (LSF_XX.RMBLAJ_SB>0) AND (LSF_XX.RMBLAJ_SB - LSF_XX.RMBLAJ_SH > 1) AND (LSF_XX.RMBLAJ > LSF_XX.RMBLAJ_SH) THEN
          INSERT INTO CKTS_XXBD_SHQ_YDXX(DJXH,SBYWB_DM,SSSQ,SBPC,SBID,ERR_LY,XH,ERR_OBJ,GLYWB1,GLYWB2,GLYWB3,GLYWZ1,GLYWZ2,YDCODE,ERR_LEV,ERR_MSG,PASS_FLAG,CRTIME)
               SELECT V_IN_DJXH,V_IN_SBYWBDM,V_IN_SSSQ,V_IN_SBPC,V_IN_SBID,'1',SEQ_XXBD_SHQ_YDID.NEXTVAL,LC_YDOBJECT,
                      'CKTS_SB_MDT_TSSB_LSB',NULL,NULL,LSF_XX.SBXH,NULL,'MDT_CKHW_BGD_RMBLAJ','I',
                      '出口货物报关单号[' || LSF_XX.CKBGDH || ']申报人民币离岸价[' || LSF_XX.RMBLAJ_SB || ']超过电子信息中剩余人民币离岸价[' || LSF_XX.RMBLAJ_SH ||
                      ']（其中出口[' || LSF_XX.RMBLAJ || ']退税申报[' || LSF_XX.TSSBRMBLAJ || ']退运[' || LSF_XX.TYRMBLAJ || ']代理出口[' || LSF_XX.DLSBRMBLAJ || ']）！','Y',SYSDATE
                 FROM DUAL;
          COMMIT;
        END IF;
      END;
    END LOOP;
  END;
END;
/
