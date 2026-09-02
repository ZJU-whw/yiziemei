CREATE OR REPLACE PROCEDURE PRO_JKGL_COMPUTE_ZB
/*
 * 指标计算总入口
 * P_ZBYEAR: 指标年度，空的时候默认为最新的企业年度报告期，否则按YYYY格式
 * P_SWJGDM: 税务机关范围，空的时候默认为133（全省），否则按省级前3位，地市级传前5位，区县级传前7位
 * P_QYLX: 企业类型范围，空的时候默认为全部，否则按生产1外贸2
 * P_DJXH：企业登记序号，空的时候默认为全部，否则单个企业刷新
 * P_ZB_ID：指标标识，可空，空默认为全部指标
 * P_ERROR：输出参数，0执行成功，其他执行失败
 * P_MSG：  输出参数，执行失败时的错误信息
 */
(
  P_ZBYEAR  IN VARCHAR2,
  P_SWJGDM  IN VARCHAR2,
  P_QYLX    IN VARCHAR2,
  P_DJXH    IN NUMBER,
  P_ZB_ID   IN VARCHAR2,
  P_ERROR   OUT NUMBER,
  P_MSG     OUT VARCHAR2
)
AS
  V_ZBYEAR  VARCHAR(4);
  V_SWJGDM  VARCHAR(12);
  V_NDJQID  NUMBER(20);     --年度基期ID
  V_JDBGQID NUMBER(20);     --季度报告期ID
  V_JDJQID  NUMBER(20);     --季度基期ID
  V_QSPJID  NUMBER(20);     --全省平均报告期ID
  V_JDBGQQ  DATE;           --季度报告期起
  V_JDBGQZ  DATE;           --季度报告期止
  V_NDBGQQ  DATE;           --年度报告期起
  V_NDBGQZ  DATE;           --年度报告期止
BEGIN
  P_ERROR :=0;
  P_MSG   := ' ';
  
  IF TRIM(P_ZBYEAR) IS NULL THEN
    V_ZBYEAR := TO_CHAR(ADD_MONTHS(SYSDATE,-4),'YYYY');
  ELSIF LENGTH(TRIM(P_ZBYEAR))=4 AND P_ZBYEAR>='2019' AND P_ZBYEAR<=TO_CHAR(ADD_MONTHS(SYSDATE,-4),'YYYY') THEN
    V_ZBYEAR := TRIM(P_ZBYEAR);
  ELSE
    P_ERROR := -1;
    P_MSG   := '参数（指标年度）请按YYYY格式输入！';
    RETURN;
  END IF;
  IF TRIM(P_SWJGDM) IS NULL THEN
    V_SWJGDM := '133%';
  ELSIF LENGTH(TRIM(P_SWJGDM)) IN (3,5,7) THEN
    V_SWJGDM := TRIM(P_SWJGDM) || '%';
  ELSE
    P_ERROR := -2;
    P_MSG   := '参数（税务机关代码）请按省级前3位，地市级传前5位，区县级传前7位输入！';
    RETURN;
  END IF;
  IF TRIM(P_QYLX) IS NOT NULL AND TRIM(P_QYLX)!='1' AND TRIM(P_QYLX)!='2' THEN
    P_ERROR := -3;
    P_MSG   := '参数（企业类型）请按生产1外贸2输入！';
    RETURN;
  END IF;

  V_NDBGQQ := TO_DATE(V_ZBYEAR||'-01-01','YYYY-MM-DD');
  V_NDBGQZ := TO_DATE(V_ZBYEAR||'-12-31','YYYY-MM-DD');
  
  DELETE FROM CKTS_DJ_BGDJMX T
  WHERE T.BGQNR=T.BGHNR;
  COMMIT;
  DELETE FROM CKTS_DJ_BGDJMX T
  WHERE LENGTH(T.BGQNR)=15 AND LENGTH(T.BGHNR)=18
  AND T.BGQNR=SUBSTR(T.BGHNR,1,6)||SUBSTR(T.BGHNR,9,9);
  COMMIT;
  DELETE FROM CKTS_DJ_BGDJMX T
  WHERE LENGTH(T.BGHNR)=15 AND LENGTH(T.BGQNR)=18
  AND T.BGHNR=SUBSTR(T.BGQNR,1,6)||SUBSTR(T.BGQNR,9,9);
  COMMIT;
  
  FOR CUR_BGQ IN (SELECT S.DJXH, S.BGQID, T.SWJGDM, T.JSMODE
                    FROM TL_TSSH.GLXT_BB_SHXT_DJXX T 
                   INNER JOIN TL_TSSH.JKGL_DATA_BGQ S ON S.DJXH=T.DJXH_JS
                   WHERE T.SWJGDM LIKE V_SWJGDM 
                     AND ((TRIM(P_QYLX) IS NULL) OR (DECODE(T.JSMODE,'1','1','2') = TRIM(P_QYLX)))
                     AND ((P_DJXH IS NULL) OR (T.DJXH_JS=P_DJXH))
                     AND S.BGQ_Q=V_NDBGQQ AND S.BGQ_Z=V_NDBGQZ
                     AND S.SXZT='2')
  LOOP
    --年度报告期ID : CUR_BGQ.BGQID
    --年度基期ID
    BEGIN
      SELECT T.BGQID
        INTO V_NDJQID
        FROM TL_TSSH.JKGL_DATA_BGQ T
       WHERE T.DJXH=CUR_BGQ.DJXH AND T.BGQ_Q=ADD_MONTHS(V_NDBGQQ,-12) AND T.BGQ_Z=V_NDBGQQ-1
         AND T.SXZT='2';
    EXCEPTION
      WHEN OTHERS THEN
        V_NDJQID :=0;
    END;
    --季度报告期ID
    BEGIN
      SELECT BGQID, BGQ_Q, BGQ_Z
        INTO V_JDBGQID, V_JDBGQQ, V_JDBGQZ
        FROM (SELECT *
                FROM TL_TSSH.JKGL_DATA_BGQ T
               WHERE T.DJXH=CUR_BGQ.DJXH AND T.BGQ_Q>=V_NDBGQQ AND T.BGQ_Q<V_NDBGQZ
                 AND T.ZQLX='季' AND T.SXZT='3'
               ORDER BY T.BGQ_Q DESC) TT
       WHERE ROWNUM=1;
    EXCEPTION
      WHEN OTHERS THEN
        V_JDBGQID :=0;
    END;
    --季度基期ID
    BEGIN
      SELECT T.BGQID
        INTO V_JDJQID
        FROM TL_TSSH.JKGL_DATA_BGQ T
       WHERE T.DJXH=CUR_BGQ.DJXH AND T.BGQ_Q>=ADD_MONTHS(V_JDBGQQ,-3) AND T.BGQ_Z=V_JDBGQQ-1
         AND T.SXZT='3';
    EXCEPTION
      WHEN OTHERS THEN
        V_JDJQID :=0;
    END;
    --全省平均报告期ID
    BEGIN
      SELECT T.BGQID
        INTO V_QSPJID
        FROM TL_TSSH.JKGL_DATA_BGQ_QSPJ T
       WHERE T.QYLX=DECODE(CUR_BGQ.JSMODE,'1','1','2')
         AND T.BGQ_Q=V_NDBGQQ AND T.BGQ_Z=V_NDBGQZ;
    EXCEPTION
      WHEN OTHERS THEN
        V_QSPJID :=0;
    END;
    
    IF CUR_BGQ.JSMODE='1' THEN
      BEGIN
        IF NVL(P_ZB_ID,'S10101')='S10101' THEN -- 数量，最后一次变更法人代表时间（未变更按税务登记时间）至报告期止月数
          PRO_JKGL_COMPUTE_S10101(CUR_BGQ.BGQID,CUR_BGQ.DJXH,V_JDBGQZ);
        END IF;
        IF NVL(P_ZB_ID,'S10102')='S10102' THEN -- 布尔，出口企业填报采集表，以填报结果为准，一致为0，不一致为1, 未填报查看股东占股比例，小于10%为1，否则为0
          PRO_JKGL_COMPUTE_S10102(CUR_BGQ.BGQID,CUR_BGQ.DJXH);
        END IF;
        IF NVL(P_ZB_ID,'S10103')='S10103' THEN -- 布尔，法定代表人身份证行政区划是否来自敏感地区，是返回1
          PRO_JKGL_COMPUTE_S10103(CUR_BGQ.BGQID,CUR_BGQ.DJXH);
        END IF;
        IF NVL(P_ZB_ID,'S10104')='S10104' THEN -- 布尔，法定代表人年龄小于19周岁；企业经营期未满三年且法人代表年龄大于65周岁，返回1
          PRO_JKGL_COMPUTE_S10104(CUR_BGQ.BGQID,CUR_BGQ.DJXH,V_JDBGQZ,CUR_BGQ.SWJGDM);
        END IF;
        IF NVL(P_ZB_ID,'S10105')='S10105' THEN -- 数量，财务负责人是否兼职(兼任其他企业财务负责人或法人)，返回兼职企业数量
          PRO_JKGL_COMPUTE_S10105(CUR_BGQ.BGQID,CUR_BGQ.DJXH);
        END IF;
        IF NVL(P_ZB_ID,'S10107')='S10107' THEN -- 数量，出口企业分类管理等级，返回A-1,B-2,C-3,D-4，无类别返回5
          PRO_JKGL_COMPUTE_S10107(CUR_BGQ.BGQID,CUR_BGQ.DJXH,V_JDBGQZ);
        END IF;
        IF NVL(P_ZB_ID,'S10108')='S10108' THEN -- 布尔，报告期内是否变更法人代表
          PRO_JKGL_COMPUTE_S10108(CUR_BGQ.BGQID,CUR_BGQ.DJXH,V_NDBGQQ,V_JDBGQZ);
        END IF;

        IF NVL(P_ZB_ID,'S10201')='S10201' THEN -- 数量，返回增值税全部销售额/固定资产期初期末平均数
          PRO_JKGL_COMPUTE_S10201(CUR_BGQ.BGQID);
        END IF;
        IF NVL(P_ZB_ID,'S10202')='S10202' THEN -- 数量，平均生产面积销售额，未填报采集表返回坏点标志
          PRO_JKGL_COMPUTE_S10202(CUR_BGQ.BGQID,CUR_BGQ.DJXH);
        END IF;
        IF NVL(P_ZB_ID,'S10203')='S10203' THEN -- 布尔，销售额(扣除委托加工费)升降趋势与电费升降趋势不一致返回1，否则0
          PRO_JKGL_COMPUTE_S10203(CUR_BGQ.BGQID,V_NDJQID);
        END IF;
        IF NVL(P_ZB_ID,'S10204')='S10204' THEN -- 布尔，报告期内电费支出小于等于5万元且外销收入减委托加工费用大于700W
          PRO_JKGL_COMPUTE_S10204(CUR_BGQ.BGQID,CUR_BGQ.SWJGDM);
        END IF;

        IF NVL(P_ZB_ID,'S20101')='S20101' THEN -- 布尔，出口销售额占全部销售额比例90%以下但应退税额占免抵退税额比例达90%以上。
          PRO_JKGL_COMPUTE_S20101(CUR_BGQ.BGQID,CUR_BGQ.SWJGDM);
        END IF;
        IF NVL(P_ZB_ID,'S20102')='S20102' THEN -- 布尔，环比大于150%且退税额大于50万元。
          PRO_JKGL_COMPUTE_S20102(CUR_BGQ.BGQID,V_NDJQID,CUR_BGQ.SWJGDM);
        END IF;
        IF NVL(P_ZB_ID,'S20103')='S20103' THEN -- 布尔，跨大类商品退税额>100W AND 跨大类商品退税额/报告期_退税额>50%
          PRO_JKGL_COMPUTE_S20103(CUR_BGQ.BGQID,V_NDJQID,CUR_BGQ.SWJGDM);
        END IF;

        IF NVL(P_ZB_ID,'S30101')='S30101' THEN -- 百分比，出口额变动率异常，取消
          PRO_JKGL_COMPUTE_S30101(CUR_BGQ.BGQID,V_NDJQID);
        END IF;
        IF NVL(P_ZB_ID,'S30102')='S30102' THEN -- 布尔，出口_大额报关单出口额USD / 出口_出口额USD > 80%
          PRO_JKGL_COMPUTE_S30102(CUR_BGQ.BGQID,CUR_BGQ.SWJGDM);
        END IF;
        IF NVL(P_ZB_ID,'S30103')='S30103' THEN -- 布尔，首笔出口满一年 and  出口_出口额USD>100万美元 and  出口_出口额USD环比>150%
          PRO_JKGL_COMPUTE_S30103(CUR_BGQ.BGQID,V_NDJQID,CUR_BGQ.DJXH,V_NDBGQQ,CUR_BGQ.SWJGDM);
        END IF;
        IF NVL(P_ZB_ID,'S30104')='S30104' THEN -- 布尔，首笔出口未满一年企业,季度出口额达100万美元且环比超150%。
          PRO_JKGL_COMPUTE_S30104(CUR_BGQ.BGQID,V_JDBGQID,V_JDJQID,CUR_BGQ.DJXH,V_NDBGQQ,CUR_BGQ.SWJGDM);
        END IF;
        IF NVL(P_ZB_ID,'S30105')='S30105' THEN -- 布尔，首笔出口未满一年企业,出口额超1000万美元。
          PRO_JKGL_COMPUTE_S30105(CUR_BGQ.BGQID,CUR_BGQ.DJXH,V_NDBGQQ,CUR_BGQ.SWJGDM);
        END IF;

        IF NVL(P_ZB_ID,'S30201')='S30201' THEN -- 数量，商品出口额超1WUSD且商品_出口额USD环比>150% 的商品数量
          PRO_JKGL_COMPUTE_S30201(CUR_BGQ.BGQID,V_NDJQID,CUR_BGQ.SWJGDM);
        END IF;
        IF NVL(P_ZB_ID,'S30202')='S30202' THEN -- 百分比，商品_新增出口额USD/商品_出口额USD
          PRO_JKGL_COMPUTE_S30202(CUR_BGQ.BGQID,V_NDJQID);
        END IF;
        IF NVL(P_ZB_ID,'S30203')='S30203' THEN -- 数量，商品出口额超1WUSD且单价环比>150% 的商品个数
          PRO_JKGL_COMPUTE_S30203(CUR_BGQ.BGQID,V_NDJQID,CUR_BGQ.SWJGDM);
        END IF;
        IF NVL(P_ZB_ID,'S30204')='S30204' THEN -- 数量，商品出口额超1WUSD且出口单价与全省平均差异超50%的商品个数
          PRO_JKGL_COMPUTE_S30204(CUR_BGQ.BGQID,V_QSPJID,CUR_BGQ.SWJGDM);
        END IF;
        IF NVL(P_ZB_ID,'S30205')='S30205' THEN -- 数量，商品出口额超1WUSD且商品_出口额USD环比>150% 的敏感商品数量
          PRO_JKGL_COMPUTE_S30205(CUR_BGQ.BGQID,V_NDJQID,CUR_BGQ.SWJGDM);
        END IF;
        IF NVL(P_ZB_ID,'S30206')='S30206' THEN --数量，生产企业跨大类(基期不存在该大类)数
          PRO_JKGL_COMPUTE_S30206(CUR_BGQ.BGQID,V_NDJQID);
        END IF;
        IF NVL(P_ZB_ID,'S30207')='S30207' THEN  -- 百分比，出口跨大类商品金额占比，取消
          PRO_JKGL_COMPUTE_S30207(CUR_BGQ.BGQID,V_NDJQID);
        END IF;

        IF NVL(P_ZB_ID,'S30301')='S30301' THEN -- 数量，出口额环比超150%的口岸个数
          PRO_JKGL_COMPUTE_S30301(CUR_BGQ.BGQID,V_NDJQID,CUR_BGQ.SWJGDM);
        END IF;
        -- IF NVL(P_ZB_ID,'S30302')='S30302' THEN -- 转关出口额占比，取消
        IF NVL(P_ZB_ID,'S30303')='S30303' THEN -- 数量，敏感口岸数量
          PRO_JKGL_COMPUTE_S30303(CUR_BGQ.BGQID);
        END IF;
        IF NVL(P_ZB_ID,'S30304')='S30304' THEN -- 数量，国别_口岸数量>5 的国别数量
          PRO_JKGL_COMPUTE_S30304(CUR_BGQ.BGQID,CUR_BGQ.SWJGDM);
        END IF;

        IF NVL(P_ZB_ID,'S30401')='S30401' THEN -- 百分比，出口目的国数量变动，取消
          PRO_JKGL_COMPUTE_S30401(CUR_BGQ.BGQID,V_NDJQID);
        END IF;
        IF NVL(P_ZB_ID,'S30402')='S30402' THEN -- 百分比，出口到香港商品占比
          PRO_JKGL_COMPUTE_S30402(CUR_BGQ.BGQID);
        END IF;
        IF NVL(P_ZB_ID,'S30403')='S30403' THEN -- 布尔，出口国别（地区）数大于10个且增幅超50%。
          PRO_JKGL_COMPUTE_S30403(CUR_BGQ.BGQID,V_NDJQID,CUR_BGQ.SWJGDM);
        END IF;

        -- IF NVL(P_ZB_ID,'S30501')='S30501' THEN -- 两高两不符，取消

        IF NVL(P_ZB_ID,'S30601')='S30601' THEN  -- 布尔，报告期出口额大于100万美元但运费小于500元。
          PRO_JKGL_COMPUTE_S30601(CUR_BGQ.BGQID,CUR_BGQ.SWJGDM);
        END IF;
        IF NVL(P_ZB_ID,'S30602')='S30602' THEN  -- 数量，出口同一国别（地区）货代（申报单位）数量超5个。
          PRO_JKGL_COMPUTE_S30602(CUR_BGQ.BGQID,CUR_BGQ.SWJGDM);
        END IF;
        --IF NVL(P_ZB_ID,'S30603')='S30603' THEN -- 数量，返回二异报关USD出口额

        -- IF NVL(P_ZB_ID,'S40101')='S40101' THEN -- 百分比，非视同自产且货源地行政区划<>企业所在地的申报出口MY占比。
        -- IF NVL(P_ZB_ID,'S40102')='S40102' THEN -- 底账_商品名称 与退税_出口商品名称相同 且 退税_视同自产出口额=0，的底账_该商品进项金额合计/底账_进项总金额
        IF NVL(P_ZB_ID,'S40103')='S40103' THEN -- 百分比，退税_视同自产出口额RMB/退税_出口额RMB
          PRO_JKGL_COMPUTE_S40103(CUR_BGQ.BGQID);
        END IF;
        
        -- IF NVL(P_ZB_ID,'S40201')='S40201' THEN -- 底账_供货企业 涉及贵金属的数量
        IF NVL(P_ZB_ID,'S40202')='S40202' THEN -- 百分比，增值税_农产品进项税额/增值税_全部进项税额
          PRO_JKGL_COMPUTE_S40202(CUR_BGQ.BGQID);
        END IF;
        IF NVL(P_ZB_ID,'S40203')='S40203' THEN -- 百分比，(底账_农产品进项税额-底账_农产品进项税额[基期])/底账_农产品进项税额[基期])
          PRO_JKGL_COMPUTE_S40203(CUR_BGQ.BGQID,V_NDJQID);
        END IF;
        
        -- IF NVL(P_ZB_ID,'S40301')='S40301' THEN -- 退税_退税额>100万 且 (底账_供货企业汇总中涉及非正常户的税额合计>100万 或 底账_供货企业汇总中涉及非正常户的税额合计/底账_总进项税额>15%)
        -- IF NVL(P_ZB_ID,'S40302')='S40302' THEN -- 底账_供货企业汇总中涉及非正常户的户数合计>=3  且 底账_供货企业汇总中涉及非正常户的户数合计/底账_供货企业总数>10%
        
        IF NVL(P_ZB_ID,'S50101')='S50101' THEN -- 百分比，(增值税_免抵销售+增值税_免税销售)/增值税_全部销售
          PRO_JKGL_COMPUTE_S50101(CUR_BGQ.BGQID);
        END IF;
        IF NVL(P_ZB_ID,'S50201')='S50201' THEN -- 百分比，(资产_期末存货-资产_期末存货[基期])/资产_期末存货[基期]
          PRO_JKGL_COMPUTE_S50201(CUR_BGQ.BGQID);
        END IF;
        IF NVL(P_ZB_ID,'S50301')='S50301' THEN -- 百分比，还原税负率
          PRO_JKGL_COMPUTE_S50301(CUR_BGQ.BGQID);
        END IF;
        
        -- IF NVL(P_ZB_ID,'S60101')='S60101' THEN -- 同一业务员备案3个以上非关联外贸公司的出口企业。
      EXCEPTION
        WHEN OTHERS THEN
          CONTINUE;
      END;
    ELSE
      BEGIN
        IF NVL(P_ZB_ID,'W10101')='W10101' THEN -- 数量，最后一次变更法人代表时间（未变更按税务登记时间）至报告期止月数
          PRO_JKGL_COMPUTE_W10101(CUR_BGQ.BGQID,CUR_BGQ.DJXH,V_JDBGQZ);
        END IF;
        IF NVL(P_ZB_ID,'W10102')='W10102' THEN -- 布尔，报告期内是否变更法人代表
          PRO_JKGL_COMPUTE_W10102(CUR_BGQ.BGQID,CUR_BGQ.DJXH,V_NDBGQQ,V_JDBGQZ);
        END IF;

        IF NVL(P_ZB_ID,'W10201')='W10201' THEN -- 数量，是否存在多个企业共用一个经营地址的情况，出口企业范围内经营地址相同的企业数量
          PRO_JKGL_COMPUTE_W10201(CUR_BGQ.BGQID,CUR_BGQ.DJXH);
        END IF;
        IF NVL(P_ZB_ID,'W10202')='W10202' THEN -- 布尔，企业基础登记信息中注册地址与生产经营地址不一致，则返回1
          PRO_JKGL_COMPUTE_W10202(CUR_BGQ.BGQID,CUR_BGQ.DJXH);
        END IF;

        IF NVL(P_ZB_ID,'W10301')='W10301' THEN -- 布尔，法定代表人年龄小于19周岁；企业经营期未满三年且法人代表年龄大于65周岁，返回1
          PRO_JKGL_COMPUTE_W10301(CUR_BGQ.BGQID,CUR_BGQ.DJXH,V_JDBGQZ,CUR_BGQ.SWJGDM);
        END IF;
        IF NVL(P_ZB_ID,'W10302')='W10302' THEN -- 布尔，法定代表人是否来自敏感地区
          PRO_JKGL_COMPUTE_W10302(CUR_BGQ.BGQID,CUR_BGQ.DJXH);
        END IF;
        IF NVL(P_ZB_ID,'W10303')='W10303' THEN -- 布尔，法定代表人与实际经营人的一致性
          PRO_JKGL_COMPUTE_W10303(CUR_BGQ.BGQID,CUR_BGQ.DJXH);
        END IF;
        IF NVL(P_ZB_ID,'W10304')='W10304' THEN -- 数量，企业是否经常变更法定代表人
          PRO_JKGL_COMPUTE_W10304(CUR_BGQ.BGQID,CUR_BGQ.DJXH,V_JDBGQZ);
        END IF;

        IF NVL(P_ZB_ID,'W10401')='W10401' THEN -- 布尔，企业四员是否来自敏感地区
          PRO_JKGL_COMPUTE_W10401(CUR_BGQ.BGQID,CUR_BGQ.DJXH);
        END IF;
        -- IF NVL(P_ZB_ID,'W10402')='W10402' THEN -- 业务员是否缴纳社保
        IF NVL(P_ZB_ID,'W10403')='W10403' THEN -- 数量，法人是否同时兼营多家企业（含内销企业）
          PRO_JKGL_COMPUTE_W10403(CUR_BGQ.BGQID,CUR_BGQ.DJXH);
        END IF;

        IF NVL(P_ZB_ID,'W10501')='W10501' THEN -- 数量，出口企业分类管理等级
          PRO_JKGL_COMPUTE_W10501(CUR_BGQ.BGQID,CUR_BGQ.DJXH,V_JDBGQZ);
        END IF;

        IF NVL(P_ZB_ID,'W20101')='W20101' THEN -- 布尔，跨大类商品退税额>XX AND 跨大类商品退税额/报告期_退税额>YY%
          PRO_JKGL_COMPUTE_W20101(CUR_BGQ.BGQID,V_NDJQID,CUR_BGQ.SWJGDM);
        END IF;
        -- IF NVL(P_ZB_ID,'W20102')='W20102' THEN -- 百分比，超期申报的报关单/报告期申报报关数量，参考W20202
        IF NVL(P_ZB_ID,'W20103')='W20103' THEN -- 布尔，季度环比大于150%且退税额大于50万元。
          PRO_JKGL_COMPUTE_W20103(CUR_BGQ.BGQID,V_NDJQID,CUR_BGQ.SWJGDM);
        END IF;

        IF NVL(P_ZB_ID,'W20201')='W20201' THEN -- (报关单每单的每美元利润<本企业每美元利润中位数*下限% or 报关单每单的每美元利润>本企业每美元利润中位数*上限%）的出口额合计/报告期_出口额>
          PRO_JKGL_COMPUTE_W20201(CUR_BGQ.BGQID,CUR_BGQ.DJXH,V_NDBGQQ,V_JDBGQZ);
        END IF;
        IF NVL(P_ZB_ID,'W20202')='W20202' THEN -- 布尔，超期申报报关单数量>XX and 超期申报出口额/报告期出口额>YY%
          PRO_JKGL_COMPUTE_W20202(CUR_BGQ.BGQID,CUR_BGQ.SWJGDM);
        END IF;
        IF NVL(P_ZB_ID,'W20203')='W20203' THEN -- 数值，综合换汇成本异常=申报退税的总计税金额/申报退税的报关单人民币出口额
          PRO_JKGL_COMPUTE_W20203(CUR_BGQ.BGQID);
        END IF;

        IF NVL(P_ZB_ID,'W30101')='W30101' THEN -- 数值，涉及四同出口的报关单数量
          PRO_JKGL_COMPUTE_W30101(CUR_BGQ.BGQID,CUR_BGQ.DJXH,V_NDBGQQ,V_JDBGQZ);
        END IF;
        IF NVL(P_ZB_ID,'W30102')='W30102' THEN -- 美元，出口货物单笔货柜值较高
          PRO_JKGL_COMPUTE_W30102(CUR_BGQ.BGQID,CUR_BGQ.DJXH,V_NDBGQQ,V_JDBGQZ);
        END IF;
        IF NVL(P_ZB_ID,'W30103')='W30103' THEN -- 百分比，出口_大额报关单出口额USD / 出口_出口额USD*100%
          PRO_JKGL_COMPUTE_W30103(CUR_BGQ.BGQID);
        END IF;
        IF NVL(P_ZB_ID,'W30104')='W30104' THEN -- 百分比，拼箱报关单份数/总份数*100%
          PRO_JKGL_COMPUTE_W30104(CUR_BGQ.BGQID);
        END IF;
        IF NVL(P_ZB_ID,'W30105')='W30105' THEN -- 美元，出口_出口额USD/出口_报关单数量
          PRO_JKGL_COMPUTE_W30105(CUR_BGQ.BGQID);
        END IF;
        IF NVL(P_ZB_ID,'W30106')='W30106' THEN -- 布尔，出口_申报单位数量/出口_报关单数量>XX% and 出口_报关单数量>YY
          PRO_JKGL_COMPUTE_W30106(CUR_BGQ.BGQID,CUR_BGQ.SWJGDM);
        END IF;
        IF NVL(P_ZB_ID,'W30107')='W30107' THEN -- 数量，统计(国别_口岸数量>5)的国别个数
          PRO_JKGL_COMPUTE_W30107(CUR_BGQ.BGQID,CUR_BGQ.SWJGDM);
        END IF;
        IF NVL(P_ZB_ID,'W30108')='W30108' THEN -- 数量，敏感口岸数量
          PRO_JKGL_COMPUTE_W30108(CUR_BGQ.BGQID);
        END IF;
        --IF NVL(P_ZB_ID,'W30109')='W30109' THEN -- 二异出口（舍近求远）
        IF NVL(P_ZB_ID,'W30110')='W30110' THEN -- 数量，(国别_运输方式数量>2 and 国别代码 not in ('142'))的国别数量
          PRO_JKGL_COMPUTE_W30110(CUR_BGQ.BGQID,CUR_BGQ.SWJGDM);
        END IF;

        IF NVL(P_ZB_ID,'W30201')='W30201' THEN -- 布尔，首笔出口满一年企业,出口额USD>100万美元,年度报告期增幅>50%
          PRO_JKGL_COMPUTE_W30201(CUR_BGQ.BGQID,V_NDJQID,CUR_BGQ.DJXH,V_NDBGQQ,CUR_BGQ.SWJGDM);
        END IF;
        IF NVL(P_ZB_ID,'W30202')='W30202' THEN -- 布尔，首笔出口未满一年,出口额USD>100万美元,季度报告期增幅>50%
          PRO_JKGL_COMPUTE_W30202(CUR_BGQ.BGQID,V_JDBGQID,V_JDJQID,CUR_BGQ.DJXH,V_NDBGQQ,CUR_BGQ.SWJGDM);
        END IF;
        IF NVL(P_ZB_ID,'W30203')='W30203' THEN -- 布尔，首笔出口未满一年企业,出口额超1000万美元。
          PRO_JKGL_COMPUTE_W30203(CUR_BGQ.BGQID,CUR_BGQ.DJXH,V_NDBGQQ,CUR_BGQ.SWJGDM);
        END IF;
        -- IF NVL(P_ZB_ID,'W30204')='W30204' THEN -- 出口额异常（重复？）
        IF NVL(P_ZB_ID,'W30205')='W30205' THEN -- 布尔，僵尸企业出口额增长异常
          PRO_JKGL_COMPUTE_W30205(CUR_BGQ.BGQID,V_NDJQID,CUR_BGQ.DJXH,V_NDBGQQ,CUR_BGQ.SWJGDM);
        END IF;
        IF NVL(P_ZB_ID,'W30206')='W30206' THEN -- 布尔，报告期_出口额>100W and (基期_出口额<>0) and (报告期_出口额>1.5*基期_出口额)
          PRO_JKGL_COMPUTE_W30206(CUR_BGQ.BGQID,V_NDJQID,CUR_BGQ.SWJGDM);
        END IF;

        IF NVL(P_ZB_ID,'W30301')='W30301' THEN -- 布尔，出口目的国数量>10,出口目的国数量增幅>50%
          PRO_JKGL_COMPUTE_W30301(CUR_BGQ.BGQID,V_NDJQID,CUR_BGQ.SWJGDM);
        END IF;

        IF NVL(P_ZB_ID,'W30401')='W30401' THEN -- 数量，商品出口额超1WUSD且商品_出口额USD环比>150% 的敏感商品数量
          PRO_JKGL_COMPUTE_W30401(CUR_BGQ.BGQID,V_NDJQID,CUR_BGQ.SWJGDM);
        END IF;
        IF NVL(P_ZB_ID,'W30402')='W30402' THEN -- 数量，商品出口额超1WUSD且出口单价与全省平均差异超50%的商品个数
          PRO_JKGL_COMPUTE_W30402(CUR_BGQ.BGQID,V_QSPJID,CUR_BGQ.SWJGDM);
        END IF;
        -- IF NVL(P_ZB_ID,'W30403')='W30403' THEN -- 单位重量的商品单价与同行业相比偏离较大
        IF NVL(P_ZB_ID,'W30404')='W30404' THEN -- 数量，外贸企业跨大类数大于10个
          PRO_JKGL_COMPUTE_W30404(CUR_BGQ.BGQID,V_NDJQID);
        END IF;

        IF NVL(P_ZB_ID,'W30501')='W30501' THEN  -- 布尔，报告期出口额大于100万美元但运费小于500元。
          PRO_JKGL_COMPUTE_W30501(CUR_BGQ.BGQID,CUR_BGQ.SWJGDM);
        END IF;
        IF NVL(P_ZB_ID,'W30502')='W30502' THEN  -- 数量，同一口岸货代预警，口岸_申报单位数量>5
          PRO_JKGL_COMPUTE_W30502(CUR_BGQ.BGQID,CUR_BGQ.SWJGDM);
        END IF;

        -- IF NVL(P_ZB_ID,'W30601')='W30601' THEN  -- 两高两不符

        IF NVL(P_ZB_ID,'W40101')='W40101' THEN -- 布尔，供货企业是否来自预警地区(退税_计税金额>50W AND 风险地区供货企业数量>50%)
          PRO_JKGL_COMPUTE_W40101(CUR_BGQ.BGQID,CUR_BGQ.SWJGDM);
        END IF;
        IF NVL(P_ZB_ID,'W40102')='W40102' THEN -- 百分比，报告期_省外进货金额/报告期_进货金额
          PRO_JKGL_COMPUTE_W40102(CUR_BGQ.BGQID);
        END IF;
        IF NVL(P_ZB_ID,'W40103')='W40103' THEN -- 布尔，退税_供货商个数>=20 and (退税_供货商个数 - 退税_供货商个数[基期])/退税_供货商个数[基期]>50%
          PRO_JKGL_COMPUTE_W40103(CUR_BGQ.BGQID,V_NDJQID,CUR_BGQ.SWJGDM);
        END IF;
        IF NVL(P_ZB_ID,'W40104')='W40104' THEN -- 布尔，非正常企业供货退税额合计>100万元 or 非正常企业供货退税额合计/报告期_退免税额>15%
          PRO_JKGL_COMPUTE_W40104(CUR_BGQ.BGQID,CUR_BGQ.SWJGDM);
        END IF;
        IF NVL(P_ZB_ID,'W40105')='W40105' THEN -- 布尔，非正常企业供货户数合计>3 or 非正常企业供货户数合计/报告期_供货企业户数>10%
          PRO_JKGL_COMPUTE_W40105(CUR_BGQ.BGQID,CUR_BGQ.SWJGDM);
        END IF;

        IF NVL(P_ZB_ID,'W40201')='W40201' THEN -- 布尔，退税_超期1发票金额>XX元 or 退税_超期1发票金额/退税_进项金额>XX% or 退税_超期1发票份数>XX份 
          PRO_JKGL_COMPUTE_W40201(CUR_BGQ.BGQID,CUR_BGQ.SWJGDM);
        END IF;
        -- IF NVL(P_ZB_ID,'W40202')='W40202' THEN -- 与W40201合并成一个指标，取消
        IF NVL(P_ZB_ID,'W40203')='W40203' THEN -- 布尔，退税_顶格开票总金额>XX元 and 退税_顶格开票总金额/退税_发票总金额>YY%
          PRO_JKGL_COMPUTE_W40203(CUR_BGQ.BGQID,CUR_BGQ.SWJGDM);
        END IF;
        -- IF NVL(P_ZB_ID,'W40204')='W40204' THEN -- 发票ip及mac地址

        IF NVL(P_ZB_ID,'W40301')='W40301' THEN -- 数量，上游供货企业涉及贵金属，取消
          PRO_JKGL_COMPUTE_W40301(CUR_BGQ.BGQID);
        END IF;

        IF NVL(P_ZB_ID,'W50101')='W50101' THEN -- 数量，毛利率与同行业相比偏离较大的商品数量
          PRO_JKGL_COMPUTE_W50101(CUR_BGQ.BGQID,V_QSPJID,CUR_BGQ.SWJGDM);
        END IF;
        IF NVL(P_ZB_ID,'W50102')='W50102' THEN -- 百分比，总体毛利率与同行业相比偏离较大
          PRO_JKGL_COMPUTE_W50102(CUR_BGQ.BGQID,V_QSPJID);
        END IF;

        -- IF NVL(P_ZB_ID,'W50201')='W50201' THEN -- 出口企业税负率与同行业平均值相比偏离是否较大
        IF NVL(P_ZB_ID,'W50202')='W50202' THEN -- 百分比，企业还原税负率与同行业平均值相比偏离是否较大
          PRO_JKGL_COMPUTE_W50202(CUR_BGQ.BGQID);
        END IF;

        IF NVL(P_ZB_ID,'W50301')='W50301' THEN -- 百分比，应收账款周转率
          PRO_JKGL_COMPUTE_W50301(CUR_BGQ.BGQID);
        END IF;
        IF NVL(P_ZB_ID,'W50302')='W50302' THEN -- 百分比，应收账款占营业收入比重
          PRO_JKGL_COMPUTE_W50302(CUR_BGQ.BGQID);
        END IF;
        IF NVL(P_ZB_ID,'W50303')='W50303' THEN -- 百分比，应付账款周转率
          PRO_JKGL_COMPUTE_W50303(CUR_BGQ.BGQID);
        END IF;
        IF NVL(P_ZB_ID,'W50304')='W50304' THEN -- 百分比，应付账款占营业成本比重
          PRO_JKGL_COMPUTE_W50304(CUR_BGQ.BGQID);
        END IF;

        -- IF NVL(P_ZB_ID,'W50401')='W50401' THEN -- 企业是否按规定缴纳社保
        -- IF NVL(P_ZB_ID,'W50402')='W50402' THEN -- 企业缴纳社保的人员与企业实际人员是否匹配

        IF NVL(P_ZB_ID,'W50501')='W50501' THEN --百分比，企业销售费用与企业营业收入的比值是否异常
          PRO_JKGL_COMPUTE_W50501(CUR_BGQ.BGQID);
        END IF;

        -- IF NVL(P_ZB_ID,'W60101')='W60101' THEN -- 业务员挂靠企业户数
        -- IF NVL(P_ZB_ID,'W60102')='W60102' THEN -- 业务员出口额变动率
        -- IF NVL(P_ZB_ID,'W60103')='W60103' THEN -- 业务员商品出口数量变动
        -- IF NVL(P_ZB_ID,'W60104')='W60104' THEN -- 业务员商品出口额变动率
        -- IF NVL(P_ZB_ID,'W60105')='W60105' THEN -- 业务员出口目的国数量
        -- IF NVL(P_ZB_ID,'W60106')='W60106' THEN -- 业务员出口目的国出口额变动率
        -- IF NVL(P_ZB_ID,'W60107')='W60107' THEN -- 业务员供货企业户数
        -- IF NVL(P_ZB_ID,'W60108')='W60108' THEN -- 业务员供货金额变动率

        -- IF NVL(P_ZB_ID,'W60201')='W60201' THEN -- 是否被公安海关外管税务稽查等部门查处
        -- IF NVL(P_ZB_ID,'W60202')='W60202' THEN -- 存在各类企业异常信息

        -- IF NVL(P_ZB_ID,'W60301')='W60301' THEN -- 是否存在外管部门反馈的异常外汇数据
      EXCEPTION
        WHEN OTHERS THEN
          CONTINUE;
      END;
    END IF;
  END LOOP;
  RETURN;
END;
/
