CREATE OR REPLACE PROCEDURE PRO_FXGL_SZYJ_WLXX
/*
 * 从出口发票备注或申报明细备注提取物流信息（车牌号、起运日期、起运地、快递单号）
 * LN_WLBZ : 初始NULL，
 *           备注（发票+出口）空白99，
 *           从发票备注提取到车牌号，初始10；日期大于出口日期+1；大于系统日期+2；日期空+3；地址空+5
 *           从发票备注提取到快递信息20
 *           从出口明细备注提取到车牌号，初始30；日期大于出口日期+1；大于系统日期+2；日期空+3；地址空+5
 *           从出口明细备注提取到快递信息40
 *           备注非空白，未提取到物流98
 */
AS
  LC_WLXX    VARCHAR2(1000);
  LN_WLBZ    NUMBER(2);
  LC_WLDM    CHAR(1);
  LC_CPH     VARCHAR2(500);
  LD_QYR     DATE;
  LC_QYD     VARCHAR2(500);
  LN_ADDR    NUMBER(3);
  LC_PATTERN VARCHAR2(500);
BEGIN
  FOR CUR_BGD IN (SELECT DJXH,BGDHGBH,CKFPBZ,CKMXBZ,WLXXLY_DM,CPH,QYRQ,QYD,CKRQ_1
                    FROM CKLLFX_DATA_BGDWL
                   WHERE WLXXLY_BZ IS NULL
                   ORDER BY SJGXSJ)
  LOOP
    LN_WLBZ := NULL;
    LC_WLDM := NULL;
    LC_CPH := NULL;
    LD_QYR := NULL;
    LC_QYD := NULL;
    
    -- 1、发票备注+出口明细备注 为空
    IF (TRIM(CUR_BGD.CKFPBZ) IS NULL) AND (TRIM(CUR_BGD.CKMXBZ) IS NULL) THEN
      LN_WLBZ := 99;
      LC_WLDM := '0';
      UPDATE CKLLFX_DATA_BGDWL T
         SET T.WLXXLY_BZ=LN_WLBZ,
             T.WLXXLY_DM=LC_WLDM,
             T.CPH=LC_CPH,
             T.QYRQ=LD_QYR,
             T.QYD=LC_QYD
       WHERE T.DJXH=CUR_BGD.DJXH AND T.BGDHGBH=CUR_BGD.BGDHGBH;
      COMMIT;
      CONTINUE;
    END IF;

    -- 2、发票备注提取到车牌号
    LC_CPH := f_wlgl_extract_plate(CUR_BGD.CKFPBZ,LN_ADDR);
    IF LC_CPH IS NOT NULL THEN
      -- 2.1、从车牌号以后备注内容提取起运日、起运地信息，剔除前面的干扰因素
      LC_WLXX := SUBSTR(CUR_BGD.CKFPBZ,LN_ADDR);
      LD_QYR := f_wlgl_extract_date(LC_WLXX,CUR_BGD.CKRQ_1);
      LC_QYD := f_wlgl_extract_from(LC_WLXX);

      -- 2.2、起运日或起运地为空，提取物流关键字位置，从关键字位置以后再提取一次
      LC_PATTERN := '车牌|车号|车辆|起运|起始|起送|起至运|启运|始运|始发|出发|出运|出货|发车|发货|装车|装货|装柜|装箱|装运|送货|拉货|货源地|托运';
      LN_ADDR := REGEXP_INSTR(CUR_BGD.CKFPBZ,LC_PATTERN,1);
      IF LN_ADDR > 0 THEN
        LC_WLXX := SUBSTR(CUR_BGD.CKFPBZ,LN_ADDR);
        IF LD_QYR IS NULL THEN
          LD_QYR := f_wlgl_extract_date(LC_WLXX,CUR_BGD.CKRQ_1);
        END IF;
        IF LC_QYD IS NULL THEN
          LC_QYD := f_wlgl_extract_from(LC_WLXX);
        END IF;
      END IF;

      -- 2.3、如果起运日或起运地还是为空，从完整备注中再提取一次
      IF LD_QYR IS NULL THEN
        LD_QYR := f_wlgl_extract_date(CUR_BGD.CKFPBZ,CUR_BGD.CKRQ_1);
      END IF;
      IF LC_QYD IS NULL THEN
        LC_QYD := f_wlgl_extract_from(CUR_BGD.CKFPBZ);
      END IF;

      -- 2.4、根据起运日或起运地是否为空，记录不同结果
      LC_WLDM := '1';
      LN_WLBZ := 10;
      IF LD_QYR IS NULL THEN
        LN_WLBZ := LN_WLBZ + 3;
      ELSIF LD_QYR>=SYSDATE THEN
        LN_WLBZ := LN_WLBZ + 2;
      ELSIF LD_QYR>=CUR_BGD.CKRQ_1 THEN
        LN_WLBZ := LN_WLBZ + 1;
      END IF;
      IF LC_QYD IS NULL THEN
        LN_WLBZ := LN_WLBZ + 5;
      END IF;
      UPDATE CKLLFX_DATA_BGDWL T
         SET T.WLXXLY_BZ=LN_WLBZ,
             T.WLXXLY_DM=LC_WLDM,
             T.CPH=LC_CPH,
             T.QYRQ=LD_QYR,
             T.QYD=LC_QYD
       WHERE T.DJXH=CUR_BGD.DJXH AND T.BGDHGBH=CUR_BGD.BGDHGBH;
      COMMIT;
      CONTINUE;
    END IF;

    -- 2、发票备注未提取到车牌号，但提取到快递信息
    LC_CPH := f_wlgl_extract_parcel(CUR_BGD.CKFPBZ);
    IF LC_CPH IS NOT NULL THEN
      LN_WLBZ := 20;
      LC_WLDM := '1';
      UPDATE CKLLFX_DATA_BGDWL T
         SET T.WLXXLY_BZ=LN_WLBZ,
             T.WLXXLY_DM=LC_WLDM,
             T.CPH=LC_CPH,
             T.QYRQ=LD_QYR,
             T.QYD=LC_QYD
       WHERE T.DJXH=CUR_BGD.DJXH AND T.BGDHGBH=CUR_BGD.BGDHGBH;
      COMMIT;
      CONTINUE;
    END IF;

    -- 3、出口明细备注提取到车牌号
    LC_CPH := f_wlgl_extract_plate(CUR_BGD.CKMXBZ,LN_ADDR);
    IF LC_CPH IS NOT NULL THEN
      LN_WLBZ := 30;
      LC_WLDM := '2';
      LD_QYR := f_wlgl_extract_date(CUR_BGD.CKMXBZ,CUR_BGD.CKRQ_1);
      IF LD_QYR IS NULL THEN
        LN_WLBZ := LN_WLBZ + 3;
      ELSIF LD_QYR>=SYSDATE THEN
        LN_WLBZ := LN_WLBZ + 2;
      ELSIF LD_QYR>=CUR_BGD.CKRQ_1 THEN
        LN_WLBZ := LN_WLBZ + 1;
      END IF;
      LC_QYD := f_wlgl_extract_from(CUR_BGD.CKMXBZ);
      IF LC_QYD IS NULL THEN
        LN_WLBZ := LN_WLBZ + 5;
      END IF;
      UPDATE CKLLFX_DATA_BGDWL T
         SET T.WLXXLY_BZ=LN_WLBZ,
             T.WLXXLY_DM=LC_WLDM,
             T.CPH=LC_CPH,
             T.QYRQ=LD_QYR,
             T.QYD=LC_QYD
       WHERE T.DJXH=CUR_BGD.DJXH AND T.BGDHGBH=CUR_BGD.BGDHGBH;
      COMMIT;
      CONTINUE;
    END IF;

    -- 4、出口明细备注未提取到车牌号，但提取到快递信息
    LC_CPH := f_wlgl_extract_parcel(CUR_BGD.CKMXBZ);
    IF LC_CPH IS NOT NULL THEN
      LN_WLBZ := 40;
      LC_WLDM := '2';
      UPDATE CKLLFX_DATA_BGDWL T
         SET T.WLXXLY_BZ=LN_WLBZ,
             T.WLXXLY_DM=LC_WLDM,
             T.CPH=LC_CPH,
             T.QYRQ=LD_QYR,
             T.QYD=LC_QYD
       WHERE T.DJXH=CUR_BGD.DJXH AND T.BGDHGBH=CUR_BGD.BGDHGBH;
      COMMIT;
      CONTINUE;
    END IF;

    -- 5、发票备注+出口明细备注 不包含物流关键字
    LN_WLBZ := 98;
    UPDATE CKLLFX_DATA_BGDWL T
       SET T.WLXXLY_BZ=LN_WLBZ,
           T.WLXXLY_DM=LC_WLDM,
           T.CPH=LC_CPH,
           T.QYRQ=LD_QYR,
           T.QYD=LC_QYD
     WHERE T.DJXH=CUR_BGD.DJXH AND T.BGDHGBH=CUR_BGD.BGDHGBH;
    COMMIT;
  END LOOP;
  
  RETURN;
END;
/
