CREATE OR REPLACE FUNCTION FUNC_XXBD_QUERY_CPCODEKZ(V_IN_NSRDZDAH NUMBER, V_IN_KZLX VARCHAR2, V_IN_YXQ DATE, V_OUT_KZXX OUT VARCHAR2)
  RETURN NUMBER
/*
  功    能：查询企业备案扩展信息
  返 回 值：有结果返回1，无结果返回0
            输出参数V_OUT_KZXX：企业分类管理等级
  修改日期：20220803，针对部分企业分类管理评定数据金三数据重复或冲突，按相同时间有效数据取等级低的一条为准
 */
IS
  LN_R NUMBER(10,0):=0;
  LN_ERROR NUMBER(10,0):=0;
BEGIN
  BEGIN
    SELECT KZXX
      INTO V_OUT_KZXX
      FROM (SELECT KZXX
              FROM GS_DJ_CKTMSDAB_KZ
             WHERE NSRDZDAH = V_IN_NSRDZDAH
               AND KZLX = V_IN_KZLX
               AND FLAG ='1'
               AND V_IN_YXQ BETWEEN ST_DATE AND END_DATE
             ORDER BY KZXX DESC)
     WHERE ROWNUM=1;
  EXCEPTION
    WHEN OTHERS THEN
      LN_ERROR := SQLCODE;
      V_OUT_KZXX:='C';
  END;
  IF LN_ERROR=0 THEN
    LN_R:=1;
  END IF;
  RETURN LN_R;
END;
/
