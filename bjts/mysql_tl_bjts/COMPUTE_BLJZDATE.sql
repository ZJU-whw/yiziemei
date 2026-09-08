DELIMITER $$

DROP FUNCTION IF EXISTS COMPUTE_BLJZDATE$$

CREATE FUNCTION COMPUTE_BLJZDATE
/*
  编制人:毛小东
  编制日期:202109
  功能:根据分类管理等级，增加工作日，其中A+5, B+10, C+15, D+20，默认20，返回截止日期
  参数:CKQYGLLB_DM 分类管理等级A,B,C,D  ；SL_DATE 开始受理日期
  返回：date 办理截止日期
 */
(
  V_IN_CKQYGLLB_DM VARCHAR(4000),
  V_IN_SL_DATE DATETIME
)
RETURNS DATETIME
NOT DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE v_adddays integer;
  DECLARE v_jjrdays integer;
  DECLARE v_zz_date DATETIME;
  DECLARE i integer;

  IF V_IN_SL_DATE IS NULL THEN
    RETURN NULL;
  END IF;
  
  IF V_IN_CKQYGLLB_DM = 'A' OR V_IN_CKQYGLLB_DM = 'a' THEN
    SET v_adddays = 5;
  ELSEIF V_IN_CKQYGLLB_DM = 'B' OR V_IN_CKQYGLLB_DM = 'b' THEN
    SET v_adddays = 10;
  ELSEIF V_IN_CKQYGLLB_DM = 'C' OR V_IN_CKQYGLLB_DM = 'c' THEN
    SET v_adddays = 15;
  ELSEIF V_IN_CKQYGLLB_DM = 'D' OR V_IN_CKQYGLLB_DM = 'd' THEN
    SET v_adddays = 20;
  ELSE
    SET v_adddays = 20;
  END IF;
  
  --节假日
  SET v_zz_date = V_IN_SL_DATE;
  FOR i IN 1 .. v_adddays LOOP
    SET v_zz_date = v_zz_date + 1;
    SET v_jjrdays = 1;
    WHILE v_jjrdays = 1 LOOP
      select count(*) into v_jjrdays from PUB_JJR where jjr_date = DATE(v_zz_date);
      IF v_jjrdays > 0 THEN
        SET v_zz_date = v_zz_date + 1;
      END IF;
    END LOOP;
  END LOOP;

  return(v_zz_date);
END$$

DELIMITER ;
