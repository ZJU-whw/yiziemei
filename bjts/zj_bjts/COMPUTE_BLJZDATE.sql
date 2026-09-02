CREATE OR REPLACE FUNCTION COMPUTE_BLJZDATE
/*
  编制人:毛小东
  编制日期:202109
  功能:根据分类管理等级，增加工作日，其中A+5, B+10, C+15, D+20，默认20，返回截止日期
  参数:CKQYGLLB_DM 分类管理等级A,B,C,D  ；SL_DATE 开始受理日期
  返回：date 办理截止日期
 */
(
  V_IN_CKQYGLLB_DM varchar2,
  V_IN_SL_DATE date
)
return date
is
  v_adddays integer;
  v_jjrdays integer;
  v_zz_date date;
  i integer;
begin
  IF V_IN_SL_DATE IS NULL THEN
    RETURN NULL;
  END IF;

  IF V_IN_CKQYGLLB_DM = 'A' OR V_IN_CKQYGLLB_DM = 'a' THEN
    v_adddays := 5;
  ELSIF V_IN_CKQYGLLB_DM = 'B' OR V_IN_CKQYGLLB_DM = 'b' THEN
    v_adddays := 10;
  ELSIF V_IN_CKQYGLLB_DM = 'C' OR V_IN_CKQYGLLB_DM = 'c' THEN
    v_adddays := 15;
  ELSIF V_IN_CKQYGLLB_DM = 'D' OR V_IN_CKQYGLLB_DM = 'd' THEN
    v_adddays := 20;
  ELSE
    v_adddays := 20;
  END IF;

  v_zz_date := V_IN_SL_DATE;
  --传递的开始日期只有日期，没有时间，以当天8点30分为开始时间
  IF v_zz_date=TRUNC(v_zz_date, 'DD') THEN
    v_zz_date:=TRUNC(v_zz_date, 'DD') + 0.3542;
  END IF;
  --传递的开始日期在下午17点30分之后，以次日8点30分为开始时间
  IF v_zz_date>=TRUNC(v_zz_date, 'DD') + 0.7295 THEN
    v_zz_date:=TRUNC(v_zz_date, 'DD') + 1.3542;
  END IF;
  --剔除开始日期是节假日，以后续第一个工作日8点30分为开始时间
  SELECT COUNT(*) INTO V_JJRDAYS FROM PUB_JJR WHERE JJR_DATE = TRUNC(v_zz_date,'DD');
  LOOP
    EXIT WHEN V_JJRDAYS=0;
    v_zz_date := v_zz_date + 1;
    SELECT COUNT(*) INTO V_JJRDAYS FROM PUB_JJR WHERE JJR_DATE = TRUNC(v_zz_date,'DD');
  END LOOP;

  FOR i IN 1 .. v_adddays LOOP
    v_zz_date := v_zz_date + 1;
    v_jjrdays := 1;
    WHILE v_jjrdays = 1 LOOP
      select count(*) into v_jjrdays from PUB_JJR where jjr_date = trunc(v_zz_date,'dd');
      IF v_jjrdays > 0 THEN
        v_zz_date := v_zz_date + 1;
      END IF;
    END LOOP;
  END LOOP;

  return(v_zz_date);
end COMPUTE_BLJZDATE;
/
