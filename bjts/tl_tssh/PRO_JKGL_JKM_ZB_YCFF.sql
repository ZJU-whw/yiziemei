CREATE OR REPLACE PROCEDURE PRO_JKGL_JKM_ZB_YCFF
/*
 * 对单户企业健康码指标，做异常判定赋分处理
 */
(
  P_DJXH    IN VARCHAR2,
  P_TSJSFS  IN VARCHAR2,
  P_SWJG    IN VARCHAR2
)
AS
  V_ZB_ID      VARCHAR2(30);
  V_ZB_VAL     NUMBER(18,2);
  V_BADPOINT   CHAR(1);
  VAL1         NUMBER(18,2);    --参数1
  VAL2         NUMBER(18,2);    --参数2
  VAL3         NUMBER(18,2);    --参数3
  VALPJ        NUMBER(18,2);    --参数平均值
--  VTYPE        VARCHAR2(10);  --参数类型，区分百分比
  V_YC         INTEGER;         --异常判断规则XH
  V_SCORE      INTEGER;         --赋分
  V_SUCCESS    INTEGER;         --存储过程执行结果 1成功 0发生异常
--全省平均
  V_MLL        NUMBER(18,2);
  V_HYSFL      NUMBER(18,2);
  V_FYSRB      NUMBER(18,2);
  V_DWGDZCXSE    NUMBER(18,2);
  V_DWJYMJXSE    NUMBER(18,2);

  CURSOR CUR_ZB(A_DJXH NUMBER) IS
      SELECT T.ZB_ID,T.ZB_VAL,T.BADPOINT FROM JKGL_DATA_ZB_JGB T
        WHERE T.DJXH=A_DJXH;
BEGIN
  V_SUCCESS:=1;

  BEGIN
    SELECT MLL,HYSFL,FYSRB,DWGDZCXSE,DWJYMJXSE
      INTO  V_MLL,V_HYSFL,V_FYSRB,V_DWGDZCXSE,V_DWJYMJXSE
      FROM (
      SELECT T.MLL,T.HYSFL,T.FYSRB,T.DWGDZCXSE,T.DWJYMJXSE
      FROM JKGL_QSPJ_JGB T
      INNER JOIN JKGL_DATA_BGQ_QSPJ S ON S.BGQID=T.BGQID AND S.QYBJ='Y'
      WHERE S.QYLX=P_TSJSFS
      ORDER BY S.BGQ_Z DESC
      ) WHERE ROWNUM=1;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      SELECT NULL,NULL,NULL,NULL,NULL
        INTO V_MLL,V_HYSFL,V_FYSRB,V_DWGDZCXSE,V_DWJYMJXSE
        FROM DUAL;
  END;

  BEGIN
    OPEN CUR_ZB(P_DJXH);
    LOOP
      -- 取一条指标
      FETCH CUR_ZB INTO V_ZB_ID,V_ZB_VAL,V_BADPOINT;
      EXIT WHEN CUR_ZB%NOTFOUND;

      IF NVL(V_BADPOINT,'Y')<>'N' OR V_ZB_VAL IS NULL THEN
        CONTINUE;
      END IF;

      IF P_TSJSFS='1' THEN
        --生产L
      CASE V_ZB_ID
          WHEN 'S10101'  THEN    -- 企业经营稳定性
            SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
              FROM JKGL_PZ_ZB_CS T
              LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
              WHERE T.CSBM='YC_S10101_MONTHS_1';
            SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL2
              FROM JKGL_PZ_ZB_CS T
              LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
              WHERE T.CSBM='YC_S10101_MONTHS_3';
            SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL3
              FROM JKGL_PZ_ZB_CS T
              LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
              WHERE T.CSBM='YC_S10101_MONTHS_5';

            CASE
              WHEN VAL1 IS NULL OR VAL2 IS NULL OR VAL3 IS NULL THEN V_YC:=-1;
              WHEN V_ZB_VAL<VAL1 THEN V_YC:=1;
              WHEN V_ZB_VAL>=VAL1 AND V_ZB_VAL<VAL2 THEN V_YC:=2;
              WHEN V_ZB_VAL>=VAL2 AND V_ZB_VAL<VAL3 THEN V_YC:=3;
              ELSE V_YC:=0;
            END CASE;

          WHEN 'S10102'  THEN    -- 企业法人与实际经营人的一致性
            CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

          WHEN 'S10103'  THEN    -- 法定代表人是否来自敏感地区
            CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

          WHEN 'S10104'  THEN    -- 法定代表人年龄是否异常
            CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

          WHEN 'S10105'  THEN    -- 财务负责人或办税员是否兼职
            SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
              FROM JKGL_PZ_ZB_CS T
              LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
              WHERE T.CSBM='YC_S10105_CWJZQY_NUM';

            CASE
              WHEN VAL1 IS NULL THEN V_YC:=-1;
              WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
              ELSE V_YC:=0;
            END CASE;

          WHEN 'S10107'  THEN    -- 出口企业分类管理等级
            CASE V_ZB_VAL
              WHEN 1 THEN V_YC:=1;
              WHEN 2 THEN V_YC:=2;
              WHEN 3 THEN V_YC:=3;
              WHEN 4 THEN V_YC:=4;
              ELSE V_YC:=0;
            END CASE;
          WHEN 'S10201'  THEN    -- 平均固定资产销售额
            --取全省平均
            VALPJ:=V_DWGDZCXSE;

            SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
              FROM JKGL_PZ_ZB_CS T
              LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
              WHERE T.CSBM='YC_S10201_PJGDZCXS_1';
            SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL2
              FROM JKGL_PZ_ZB_CS T
              LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
              WHERE T.CSBM='YC_S10201_PJGDZCXS_2';

            CASE
              WHEN VAL1 IS NULL OR VAL2 IS NULL OR VALPJ IS NULL THEN V_YC:=-1;
              WHEN V_ZB_VAL<VALPJ * VAL1 /100  THEN V_YC:=1;
              WHEN V_ZB_VAL>=VALPJ * VAL1/100 AND V_ZB_VAL<VALPJ * VAL2/100 THEN V_YC:=2;
              WHEN V_ZB_VAL>=VALPJ * VAL2/100 THEN V_YC:=3;
              ELSE V_YC:=0;
            END CASE;

          WHEN 'S10202'  THEN    -- 平均生产面积销售额
            --取全省平均
            VALPJ:=V_DWJYMJXSE;

            SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
              FROM JKGL_PZ_ZB_CS T
              LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
              WHERE T.CSBM='YC_S10202_PJJYMJXS_1';
            SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL2
              FROM JKGL_PZ_ZB_CS T
              LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
              WHERE T.CSBM='YC_S10202_PJJYMJXS_2';

            CASE
              WHEN VAL1 IS NULL OR VAL2 IS NULL OR VALPJ IS NULL THEN V_YC:=-1;
              WHEN V_ZB_VAL<VALPJ * VAL1 /100  THEN V_YC:=1;
              WHEN V_ZB_VAL>=VALPJ * VAL1/100 AND V_ZB_VAL<VALPJ * VAL2/100 THEN V_YC:=2;
              WHEN V_ZB_VAL>=VALPJ * VAL2/100 THEN V_YC:=3;
              ELSE V_YC:=0;
            END CASE;

          WHEN 'S10203'  THEN    -- 销售额与电费支出变动趋势
            CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

          WHEN 'S10204'  THEN    -- 销售额与电费支出合理关系
            CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

          WHEN 'S20101'  THEN    -- 应退税额占比
            CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

          WHEN 'S20102'  THEN    -- 退税额增长Ⅰ
            CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

          WHEN 'S20103'  THEN    -- 退税额增长Ⅱ
            CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

    --      WHEN 'S30101'  THEN    -- 出口额变动率异常
    /*        IF V_ZB_VAL=1 THEN
              V_YC:=1;
            ELSE
              V_YC:=0;
            END IF;
    */
          WHEN 'S30102'  THEN    -- 大额报关占比异常
            CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

          WHEN 'S30103'  THEN    -- 出口额增长异常Ⅰ
            CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

          WHEN 'S30104'  THEN    -- 出口额增长异常Ⅱ
            CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

          WHEN 'S30105'  THEN    -- 出口额增长异常Ⅲ
            CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

          WHEN 'S30201'  THEN    -- 商品出口额变动率
            SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
              FROM JKGL_PZ_ZB_CS T
              LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
              WHERE T.CSBM='YC_S30201_SP_CKEBDL_NUM';

            CASE
              WHEN VAL1 IS NULL THEN V_YC:=-1;
              WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
              ELSE V_YC:=0;
            END CASE;
          WHEN 'S30202'  THEN    -- 新增商品出口占比
            SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
              FROM JKGL_PZ_ZB_CS T
              LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
              WHERE T.CSBM='YC_S30202_NEWSP_CKE_ZB';

            CASE
              WHEN VAL1 IS NULL THEN V_YC:=-1;
              WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
              ELSE V_YC:=0;
            END CASE;
          WHEN 'S30203'  THEN    -- 出口商品单价变动率
            SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
              FROM JKGL_PZ_ZB_CS T
              LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
              WHERE T.CSBM='YC_S30203_SP_PJDJBDL_NUM';

            CASE
              WHEN VAL1 IS NULL THEN V_YC:=-1;
              WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
              ELSE V_YC:=0;
            END CASE;
          WHEN 'S30204'  THEN    -- 本地区商品单价差异率
            SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
              FROM JKGL_PZ_ZB_CS T
              LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
              WHERE T.CSBM='YC_S30204_SP_QSPJCYL_NUM';

            CASE
              WHEN VAL1 IS NULL THEN V_YC:=-1;
              WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
              ELSE V_YC:=0;
            END CASE;
          WHEN 'S30205'  THEN    -- 敏感商品
            SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
              FROM JKGL_PZ_ZB_CS T
              LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
              WHERE T.CSBM='YC_S30205_MGSP_NUM_1';
            SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL2
              FROM JKGL_PZ_ZB_CS T
              LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
              WHERE T.CSBM='YC_S30205_MGSP_NUM_2';

            CASE
              WHEN VAL1 IS NULL OR VAL2 IS NULL THEN V_YC:=-1;
              WHEN V_ZB_VAL>=VAL1 AND V_ZB_VAL<VAL2 THEN V_YC:=1;
              WHEN V_ZB_VAL>=VAL2 THEN V_YC:=2;
              ELSE V_YC:=0;
            END CASE;
          WHEN 'S30206'  THEN    -- 出口商品跨大类Ⅰ
            SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
              FROM JKGL_PZ_ZB_CS T
              LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
              WHERE T.CSBM='YC_S30206_CKSPKDL_NUM';

            CASE
              WHEN VAL1 IS NULL THEN V_YC:=-1;
              WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
              ELSE V_YC:=0;
            END CASE;
    --      WHEN 'S30207'  THEN    -- 出口商品跨大类Ⅱ
    --        CONTINUE;
          WHEN 'S30301'  THEN    -- 口岸出口额变动率
            SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
              FROM JKGL_PZ_ZB_CS T
              LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
              WHERE T.CSBM='YC_S30301_KA_CKEBDL_NUM';

            CASE
              WHEN VAL1 IS NULL THEN V_YC:=-1;
              WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
              ELSE V_YC:=0;
            END CASE;
    --      WHEN 'S30302'  THEN    -- 转关出口额占比
    --        CONTINUE;
          WHEN 'S30303'  THEN    -- 敏感口岸出口额占比
            SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
              FROM JKGL_PZ_ZB_CS T
              LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
              WHERE T.CSBM='YC_S30303_MGKA_NUM_1';
            SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL2
              FROM JKGL_PZ_ZB_CS T
              LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
              WHERE T.CSBM='YC_S30303_MGKA_NUM_2';

            CASE
              WHEN VAL1 IS NULL OR VAL2 IS NULL THEN V_YC:=-1;
              WHEN V_ZB_VAL>=VAL1 AND V_ZB_VAL<VAL2 THEN V_YC:=1;
              WHEN V_ZB_VAL>=VAL2 THEN V_YC:=2;
              ELSE V_YC:=0;
            END CASE;
          WHEN 'S30304'  THEN    -- 出口同一国别口岸数量
            SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
              FROM JKGL_PZ_ZB_CS T
              LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
              WHERE T.CSBM='YC_S30304_GB_KASL';

            CASE
              WHEN VAL1 IS NULL THEN V_YC:=-1;
              WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
              ELSE V_YC:=0;
            END CASE;
          WHEN 'S30401'  THEN    -- 出口目的国数量变动
            SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
              FROM JKGL_PZ_ZB_CS T
              LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
              WHERE T.CSBM='YC_S30401_MDGSLBDL';

            CASE
              WHEN VAL1 IS NULL THEN V_YC:=-1;
              WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
              ELSE V_YC:=0;
            END CASE;
          WHEN 'S30402'  THEN    -- 出口到香港商品占比
            SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
              FROM JKGL_PZ_ZB_CS T
              LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
              WHERE T.CSBM='YC_S30402_DXGCKZB';

            CASE
              WHEN VAL1 IS NULL THEN V_YC:=-1;
              WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
              ELSE V_YC:=0;
            END CASE;
          WHEN 'S30403'  THEN    -- 出口国别和增幅预警
            CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

    --      WHEN 'S30501'  THEN    -- 两高两不符
    --        CONTINUE;
          WHEN 'S30601'  THEN    -- 运费匹配度
            CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

          WHEN 'S30602'  THEN    -- 出口同一个国别货代数量
            SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
              FROM JKGL_PZ_ZB_CS T
              LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
              WHERE T.CSBM='YC_S30602_GB_SBDWSL';

            CASE
              WHEN VAL1 IS NULL THEN V_YC:=-1;
              WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
              ELSE V_YC:=0;
            END CASE;
          WHEN 'S30603'  THEN    -- 二异出口
            SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
              FROM JKGL_PZ_ZB_CS T
              LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
              WHERE T.CSBM='YC_S30603_EYBG_CKE';

            CASE
              WHEN VAL1 IS NULL THEN V_YC:=-1;
              WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
              ELSE V_YC:=0;
            END CASE;
    --      WHEN 'S40101'  THEN    -- 货源地不一致占比
    --        CONTINUE;
          WHEN 'S40102'  THEN    -- 进项产成品异常
            SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
              FROM JKGL_PZ_ZB_CS T
              LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
              WHERE T.CSBM='YC_S40102_JXCCPBLV';

            CASE
              WHEN VAL1 IS NULL THEN V_YC:=-1;
              WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
              ELSE V_YC:=0;
            END CASE;
    --      WHEN 'S40103'  THEN    -- 视同自产出口额占比
    --        CONTINUE;
    --      WHEN 'S40201'  THEN    -- 上游供货企业涉及贵金属
    --        CONTINUE;
          WHEN 'S40202'  THEN    -- 农产品进项税额占比
            SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
              FROM JKGL_PZ_ZB_CS T
              LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
              WHERE T.CSBM='YC_S40202_NCPJXZB';

            CASE
              WHEN VAL1 IS NULL THEN V_YC:=-1;
              WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
              ELSE V_YC:=0;
            END CASE;
          WHEN 'S40203'  THEN    -- 农产品进项税额增幅
            SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
              FROM JKGL_PZ_ZB_CS T
              LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
              WHERE T.CSBM='YC_S40203_NCPJXZF';

            CASE
              WHEN VAL1 IS NULL THEN V_YC:=-1;
              WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
              ELSE V_YC:=0;
            END CASE;
    --      WHEN 'S40301'  THEN    -- 生产企业风险供货情况Ⅰ
    --        CONTINUE;
    --      WHEN 'S40302'  THEN    -- 生产企业风险供货情况Ⅱ
    --        CONTINUE;
    --      WHEN 'S50101'  THEN    -- 外销比重
    --        CONTINUE;
          WHEN 'S50201'  THEN    -- 期末存货占比变动率
            SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
              FROM JKGL_PZ_ZB_CS T
              LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
              WHERE T.CSBM='YC_S50201_CW_CHBDL';

            CASE
              WHEN VAL1 IS NULL THEN V_YC:=-1;
              WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
              ELSE V_YC:=0;
            END CASE;
          WHEN 'S50301'  THEN    -- 还原税负率
            --取全省平均
            VALPJ:=V_HYSFL;

            IF VALPJ IS NULL OR VALPJ=0 THEN
              V_YC:=-1;
            ELSE
              VAL1 :=(VALPJ - V_ZB_VAL)/VALPJ;
              CASE
                WHEN V_ZB_VAL>=VALPJ OR (V_ZB_VAL<VALPJ AND VAL1<=0.2)  THEN V_YC:=1;
                WHEN V_ZB_VAL>=VALPJ OR (V_ZB_VAL<VALPJ AND VAL1>0.2 AND VAL1<=0.5)  THEN V_YC:=2;
                WHEN V_ZB_VAL<VALPJ AND (V_ZB_VAL<VALPJ AND VAL1>0.5 AND VAL1<=1)  THEN V_YC:=3;
                WHEN VAL1>1 THEN V_YC:=4;
                ELSE V_YC:=0;
              END CASE;
            END IF;

          WHEN 'S60101'  THEN    -- 同一业务员备案备案多家出口企业
            SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
              FROM JKGL_PZ_ZB_CS T
              LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
              WHERE T.CSBM='YC_S60101_YWY_JZ_NUM';

            CASE
              WHEN VAL1 IS NULL THEN V_YC:=-1;
              WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
              ELSE V_YC:=0;
            END CASE;

          ELSE
            CONTINUE;
        END CASE;
      ELSE
        --外贸W类指标
        CASE V_ZB_ID
            WHEN 'W10101'  THEN    -- 企业存续时间是否较短
              SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
                FROM JKGL_PZ_ZB_CS T
                LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
                WHERE T.CSBM='YC_W10101_MONTHS_1';
              SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL2
                FROM JKGL_PZ_ZB_CS T
                LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
                WHERE T.CSBM='YC_W10101_MONTHS_3';
              SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL3
                FROM JKGL_PZ_ZB_CS T
                LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
                WHERE T.CSBM='YC_W10101_MONTHS_5';

              CASE
                WHEN VAL1 IS NULL OR VAL2 IS NULL OR VAL3 IS NULL THEN V_YC:=-1;
                WHEN V_ZB_VAL<VAL1 THEN V_YC:=1;
                WHEN V_ZB_VAL>=VAL1 AND V_ZB_VAL<VAL2 THEN V_YC:=2;
                WHEN V_ZB_VAL>=VAL2 AND V_ZB_VAL<VAL3 THEN V_YC:=3;
                ELSE V_YC:=0;
              END CASE;

            WHEN 'W10201'  THEN    -- 多个企业共用一个经营地址
              SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
                FROM JKGL_PZ_ZB_CS T
                LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
                WHERE T.CSBM='YC_W10201_QYHS';

              CASE
                WHEN VAL1 IS NULL THEN V_YC:=-1;
                WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
                ELSE V_YC:=0;
              END CASE;

            WHEN 'W10202'  THEN    -- 注册地址与生产经营地址不一致
              CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

            WHEN 'W10301'  THEN    -- 法定代表人年龄是否异常
              CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

            WHEN 'W10302'  THEN    -- 法定代表人是否来自敏感地区
              CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

            WHEN 'W10303'  THEN    -- 法定代表人是否为企业实际控制人
              CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

            WHEN 'W10304'  THEN    -- 企业是否经常变更法定代表人
              SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
                FROM JKGL_PZ_ZB_CS T
                LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
                WHERE T.CSBM='YC_W10304_FRBG_NUM';

              CASE
                WHEN VAL1 IS NULL THEN V_YC:=-1;
                WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
                ELSE V_YC:=0;
              END CASE;

            WHEN 'W10401'  THEN    -- 企业四员是否来自敏感地区
              CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

            WHEN 'W10402'  THEN    -- 业务员是否缴纳社保
              CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

            WHEN 'W10403'  THEN    -- 法人、股东同时兼营多家企业
              SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
                FROM JKGL_PZ_ZB_CS T
                LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
                WHERE T.CSBM='YC_W10403';

              CASE
                WHEN VAL1 IS NULL THEN V_YC:=-1;
                WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
                ELSE V_YC:=0;
              END CASE;
            WHEN 'W10501'  THEN    -- 分类管理等级
              CASE V_ZB_VAL
                WHEN 1 THEN V_YC:=1;
                WHEN 2 THEN V_YC:=2;
                WHEN 3 THEN V_YC:=3;
                WHEN 4 THEN V_YC:=4;
                ELSE V_YC:=0;
              END CASE;
            WHEN 'W20101'  THEN    -- 退税额增长Ⅱ
              CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

      --      WHEN 'W20102'  THEN    -- 超期申报的报关单异常
      --        CONTINUE;
            WHEN 'W20103'  THEN    -- 退税额增长Ⅰ
              CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

            WHEN 'W20201'  THEN    -- 每美元利润
              SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
                FROM JKGL_PZ_ZB_CS T
                LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
                WHERE T.CSBM='YC_W20201_MMYLR_YCZB';

              CASE
                WHEN VAL1 IS NULL THEN V_YC:=-1;
                WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
                ELSE V_YC:=0;
              END CASE;

            WHEN 'W20202'  THEN    -- 超期申报报关单多、金额占比高
              CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

            WHEN 'W20203'  THEN    -- 换汇成本异常
              SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
                FROM JKGL_PZ_ZB_CS T
                LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
                WHERE T.CSBM='YC_W20203_HHCB_HIGH';
              SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL2
                FROM JKGL_PZ_ZB_CS T
                LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
                WHERE T.CSBM='YC_W20203_HHCB_LOW';

              CASE
                WHEN VAL1 IS NULL OR VAL2 IS NULL OR V_ZB_VAL<=0 THEN V_YC:=-1;
                WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
                WHEN V_ZB_VAL<VAL2 THEN V_YC:=2;
                ELSE V_YC:=0;
              END CASE;

            WHEN 'W30101'  THEN    -- 涉及四同出口的报关单数量
              SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
                FROM JKGL_PZ_ZB_CS T
                LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
                WHERE T.CSBM='YC_W30101_STBGD_NUM';

              CASE
                WHEN VAL1 IS NULL THEN V_YC:=-1;
                WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
                ELSE V_YC:=0;
              END CASE;

            WHEN 'W30102'  THEN    -- 出口货物单笔货柜值较高
              SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
                FROM JKGL_PZ_ZB_CS T
                LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
                WHERE T.CSBM='YC_W30102_DBHGZ';

              CASE
                WHEN VAL1 IS NULL THEN V_YC:=-1;
                WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
                ELSE V_YC:=0;
              END CASE;

            WHEN 'W30103'  THEN    -- 大额出口报关单数量占比较高
              SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
                FROM JKGL_PZ_ZB_CS T
                LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
                WHERE T.CSBM='YC_W30103_DEGDZB';

              CASE
                WHEN VAL1 IS NULL THEN V_YC:=-1;
                WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
                ELSE V_YC:=0;
              END CASE;

            WHEN 'W30104'  THEN    -- 出口货物拼箱情况
              SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
                FROM JKGL_PZ_ZB_CS T
                LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
                WHERE T.CSBM='YC_W30104_PXGDZB';

              CASE
                WHEN VAL1 IS NULL THEN V_YC:=-1;
                WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
                ELSE V_YC:=0;
              END CASE;

            WHEN 'W30105'  THEN    -- 平均每单出口额
              SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
                FROM JKGL_PZ_ZB_CS T
                LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
                WHERE T.CSBM='YC_W30105_PJMD_CKEUSD';

              CASE
                WHEN VAL1 IS NULL THEN V_YC:=-1;
                WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
                ELSE V_YC:=0;
              END CASE;

            WHEN 'W30106'  THEN    -- 报关行数量与报关次数的比值偏高
              CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

            WHEN 'W30107'  THEN    -- 同一出口国别的口岸数量偏多
              SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
                FROM JKGL_PZ_ZB_CS T
                LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
                WHERE T.CSBM='YC_W30107_CKGB_KAYC_NUM';

              CASE
                WHEN VAL1 IS NULL THEN V_YC:=-1;
                WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
                ELSE V_YC:=0;
              END CASE;

            WHEN 'W30108'  THEN    -- 敏感口岸
              SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
                FROM JKGL_PZ_ZB_CS T
                LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
                WHERE T.CSBM='YC_W30108_MGKA_NUM_1';
              SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL2
                FROM JKGL_PZ_ZB_CS T
                LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
                WHERE T.CSBM='YC_W30108_MGKA_NUM_2';

              CASE
                WHEN VAL1 IS NULL OR VAL2 IS NULL THEN V_YC:=-1;
                WHEN V_ZB_VAL>=VAL1 AND V_ZB_VAL<VAL2 THEN V_YC:=1;
                WHEN V_ZB_VAL>=VAL2 THEN V_YC:=2;
                ELSE V_YC:=0;
              END CASE;

            WHEN 'W30109'  THEN    -- 二异出口（舍近求远）
              SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
                FROM JKGL_PZ_ZB_CS T
                LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
                WHERE T.CSBM='YC_W30109_EYCKZB';

              CASE
                WHEN VAL1 IS NULL THEN V_YC:=-1;
                WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
                ELSE V_YC:=0;
              END CASE;

            WHEN 'W30110'  THEN    -- 同一国别的运输方式偏多
              SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
                FROM JKGL_PZ_ZB_CS T
                LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
                WHERE T.CSBM='YC_W30110_CKGB_YSYC_NUM';

              CASE
                WHEN VAL1 IS NULL THEN V_YC:=-1;
                WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
                ELSE V_YC:=0;
              END CASE;

            WHEN 'W30201'  THEN    -- 出口额过高且同比增长较快
              CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

            WHEN 'W30202'  THEN    -- 新办企业季度出口额过高且环比增幅较大
              CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

            WHEN 'W30203'  THEN    -- 新办企业当年度出口额异常
              CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

      --      WHEN 'W30204'  THEN    -- 出口额异常（重复定义）
      --        CONTINUE;
            WHEN 'W30205'  THEN    -- 僵尸企业出口额异常
              CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

            WHEN 'W30206'  THEN    -- 年度出口额变动率异常
              CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

            WHEN 'W30301'  THEN    -- 国别预警
              CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

            WHEN 'W30401'  THEN    -- 敏感商品占比重过高
              SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
                FROM JKGL_PZ_ZB_CS T
                LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
                WHERE T.CSBM='YC_W30401_MGSP_NUM_1';
              SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL2
                FROM JKGL_PZ_ZB_CS T
                LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
                WHERE T.CSBM='YC_W30401_MGSP_NUM_2';

              CASE
                WHEN VAL1 IS NULL OR VAL2 IS NULL THEN V_YC:=-1;
                WHEN V_ZB_VAL>=VAL1 AND V_ZB_VAL<VAL2 THEN V_YC:=1;
                WHEN V_ZB_VAL>=VAL2 THEN V_YC:=2;
                ELSE V_YC:=0;
              END CASE;

            WHEN 'W30402'  THEN    -- 出口商品单价与同行业相比偏离较大
              SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
                FROM JKGL_PZ_ZB_CS T
                LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
                WHERE T.CSBM='YC_W30402_CKSPDJYC_NUM';

              CASE
                WHEN VAL1 IS NULL THEN V_YC:=-1;
                WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
                ELSE V_YC:=0;
              END CASE;

      --      WHEN 'W30403'  THEN    -- 单位重量的商品单价与同行业相比偏离较大
      --        CONTINUE;
            WHEN 'W30404'  THEN    -- 出口商品跨大类Ⅰ
              SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
                FROM JKGL_PZ_ZB_CS T
                LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
                WHERE T.CSBM='YC_W30404_CKSP_KDL_NUM';

              CASE
                WHEN VAL1 IS NULL THEN V_YC:=-1;
                WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
                ELSE V_YC:=0;
              END CASE;

            WHEN 'W30501'  THEN    -- 运费匹配度
              CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

            WHEN 'W30502'  THEN    -- 同一口岸货代预警
              SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
                FROM JKGL_PZ_ZB_CS T
                LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
                WHERE T.CSBM='YC_W30502_TYCAHDYJ_NUM';

              CASE
                WHEN VAL1 IS NULL THEN V_YC:=-1;
                WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
                ELSE V_YC:=0;
              END CASE;

      --      WHEN 'W30601'  THEN    -- 两高两不符
      --        CONTINUE;
            WHEN 'W40101'  THEN    -- 供货企业是否来自预警地区
              CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

            WHEN 'W40102'  THEN    -- 省外供货占比
              SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
                FROM JKGL_PZ_ZB_CS T
                LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
                WHERE T.CSBM='YC_W40102_SWGH_ZB';

              CASE
                WHEN VAL1 IS NULL THEN V_YC:=-1;
                WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
                ELSE V_YC:=0;
              END CASE;

            WHEN 'W40103'  THEN    -- 供货企业数量预警
              CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

            WHEN 'W40104'  THEN    -- 风险供货Ⅰ
              CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

            WHEN 'W40105'  THEN    -- 风险供货Ⅱ
              CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

            WHEN 'W40201'  THEN    -- 超期开票Ⅰ
              V_YC := V_ZB_VAL;

      --      WHEN 'W40202'  THEN    -- 超期开票Ⅱ
      --        CONTINUE;

            WHEN 'W40203'  THEN    -- 顶格开票
              CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

      --      WHEN 'W40204'  THEN    -- 发票IP及MAC地址
      --        CONTINUE;
      --      WHEN 'W40301'  THEN    -- 上游供货企业涉及贵金属
      --        CONTINUE;
            WHEN 'W50101'  THEN    -- 同一商品每美元利润与全省平均相比偏离较大
              SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
                FROM JKGL_PZ_ZB_CS T
                LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
                WHERE T.CSBM='YC_W50101_SPMLR_NUM';

              CASE
                WHEN VAL1 IS NULL THEN V_YC:=-1;
                WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
                ELSE V_YC:=0;
              END CASE;

            WHEN 'W50102'  THEN    -- 总体毛利率与全省平均相比偏离较大
              --取全省平均
              VALPJ:=V_MLL;

              IF VALPJ IS NULL OR VALPJ=0 THEN
                V_YC:=-1;
              ELSE
                VAL1 :=(VALPJ - V_ZB_VAL)/VALPJ;
                CASE
                  WHEN V_ZB_VAL>=VALPJ OR (V_ZB_VAL<VALPJ AND VAL1<=0.2)  THEN V_YC:=1;
                  WHEN V_ZB_VAL>=VALPJ OR (V_ZB_VAL<VALPJ AND VAL1>0.2 AND VAL1<=0.5)  THEN V_YC:=2;
                  WHEN V_ZB_VAL<VALPJ AND (V_ZB_VAL<VALPJ AND VAL1>0.5 AND VAL1<=1)  THEN V_YC:=3;
                  WHEN VAL1>1 THEN V_YC:=4;
                  ELSE V_YC:=0;
                END CASE;
              END IF;

      --      WHEN 'W50201'  THEN    -- 出口企业税负率与全省平均值相比偏离是否较大
      --        CONTINUE;
            WHEN 'W50202'  THEN    -- 企业还原税负率异常
              --取全省平均
              VALPJ:=V_HYSFL;

              IF VALPJ IS NULL OR VALPJ=0 THEN
                V_YC:=-1;
              ELSE
                VAL1 :=(VALPJ - V_ZB_VAL)/VALPJ;
                CASE
                  WHEN V_ZB_VAL>=VALPJ OR (V_ZB_VAL<VALPJ AND VAL1<=0.2)  THEN V_YC:=1;
                  WHEN V_ZB_VAL>=VALPJ OR (V_ZB_VAL<VALPJ AND VAL1>0.2 AND VAL1<=0.5)  THEN V_YC:=2;
                  WHEN V_ZB_VAL<VALPJ AND (V_ZB_VAL<VALPJ AND VAL1>0.5 AND VAL1<=1)  THEN V_YC:=3;
                  WHEN VAL1>1 THEN V_YC:=4;
                  ELSE V_YC:=0;
                END CASE;
              END IF;

    --        WHEN 'W50301'  THEN    -- 应收账款周转率
    --          CONTINUE;
            WHEN 'W50302'  THEN    -- 应收账款占营业收入比重
              SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
                FROM JKGL_PZ_ZB_CS T
                LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
                WHERE T.CSBM='YC_W50302_YSZK_YYSR_ZB';

              CASE
                WHEN VAL1 IS NULL THEN V_YC:=-1;
                WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
                ELSE V_YC:=0;
              END CASE;
              
    --        WHEN 'W50303'  THEN    -- 应付账款周转率
    --          CONTINUE;
            WHEN 'W50304'  THEN    -- 应付账款占营业成本额比重
              SELECT NVL(S.VAL_DEF,T.VAL_DEF) INTO VAL1
                FROM JKGL_PZ_ZB_CS T
                LEFT JOIN JKGL_PZ_ZB_CS_SWJG S ON S.CSBM=T.CSBM AND S.SWJG_DM=P_SWJG AND S.YXBZ='Y'
                WHERE T.CSBM='YC_W50304_YFZK_YYCB_ZB';

              CASE
                WHEN VAL1 IS NULL THEN V_YC:=-1;
                WHEN V_ZB_VAL>=VAL1 THEN V_YC:=1;
                ELSE V_YC:=0;
              END CASE;
              
      --      WHEN 'W50401'  THEN    -- 企业是否按规定缴纳社保
      --        CONTINUE;
            WHEN 'W50402'  THEN    -- 企业缴纳社保的人员与企业实际人员是否匹配
              CASE WHEN V_ZB_VAL=1 THEN V_YC:=1; ELSE V_YC:=0; END CASE;

            WHEN 'W50501'  THEN    -- 企业销售费用与企业营业收入的比值是否异常
              --取全省平均
              VALPJ:=V_FYSRB;

              IF VALPJ IS NULL OR VALPJ=0 THEN
                V_YC:=-1;
              ELSE
                VAL1 :=(VALPJ - V_ZB_VAL)/VALPJ;
                CASE
                  WHEN V_ZB_VAL>=VALPJ OR (V_ZB_VAL<VALPJ AND VAL1<=0.2)  THEN V_YC:=1;
                  WHEN V_ZB_VAL>=VALPJ OR (V_ZB_VAL<VALPJ AND VAL1>0.2 AND VAL1<=0.5)  THEN V_YC:=2;
                  WHEN V_ZB_VAL<VALPJ AND (V_ZB_VAL<VALPJ AND VAL1>0.5 AND VAL1<=1)  THEN V_YC:=3;
                  WHEN VAL1>1 THEN V_YC:=4;
                  ELSE V_YC:=0;
                END CASE;
              END IF;

      --      WHEN 'W60101'  THEN    -- 业务员挂靠企业户数
      --        CONTINUE;
      --      WHEN 'W60102'  THEN    -- 业务员出口额变动率
      --        CONTINUE;
      --      WHEN 'W60103'  THEN    -- 业务员商品出口数量变动
      --        CONTINUE;
      --      WHEN 'W60104'  THEN    -- 业务员商品出口额变动率
      --        CONTINUE;
      --      WHEN 'W60105'  THEN    -- 业务员出口目的国数量
      --        CONTINUE;
      --      WHEN 'W60106'  THEN    -- 业务员出口目的国出口额变动率
      --        CONTINUE;
      --      WHEN 'W60107'  THEN    -- 业务员供货企业户数
      --        CONTINUE;
      --      WHEN 'W60108'  THEN    -- 业务员供货金额变动率
      --        CONTINUE;
      --      WHEN 'W60201'  THEN    -- 是否被公安、海关、外管、税务稽查等部门查处
      --        CONTINUE;
      --      WHEN 'W60202'  THEN    -- 存在各类企业异常信息
      --        CONTINUE;
      --      WHEN 'W60301'  THEN    -- 是否存在外管部门反馈的异常外汇数据
      --        CONTINUE;
              ELSE
                V_YC:=-1;
--                CONTINUE;
          END CASE;
      END IF;

      --提取异常XH的赋分
      IF V_YC>0 THEN
        BEGIN
          SELECT NVL(NVL(S.SCORE,T.SCORE),0) INTO V_SCORE
            FROM JKGL_PZ_ZB_YCFF T
            LEFT JOIN JKGL_PZ_ZB_YCFF_SWJG S
              ON S.ZB_ID = T.ZB_ID
             AND S.XH = T.XH
             AND S.SWJG_DM = P_SWJG
             AND S.YXBZ = 'Y'
           WHERE T.ZB_ID = V_ZB_ID AND T.XH=V_YC
             AND T.YXBZ = 'Y';
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
             V_SCORE:=0;
         END;
       ELSE
         V_SCORE:=0;
       END IF;

       --更新健康码指标赋分表
       UPDATE JKGL_DATA_ZB_JGB T SET T.YC_RESULT=V_YC, T.SCORE=V_SCORE, T.FF_STATUS='1',T.UPTIME=SYSDATE
         WHERE T.DJXH=P_DJXH AND T.ZB_ID=V_ZB_ID;

    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
        V_SUCCESS:=0;
        DBMS_OUTPUT.PUT_LINE('Exception!'||SQLCODE || SQLERRM);
  END;

  IF V_SUCCESS=1 THEN
     COMMIT;
  ELSE
     ROLLBACK;
     RAISE_APPLICATION_ERROR(-20001,'【健康码】指标判定：'||P_DJXH);
  END IF;

  RETURN;
END;
/
