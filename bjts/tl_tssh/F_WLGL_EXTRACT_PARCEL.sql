CREATE OR REPLACE FUNCTION f_wlgl_extract_parcel
-- ============================================
-- 函数：物流、快递单号（仅取第一个）
-- ============================================
(
  p_text IN VARCHAR2
)
RETURN VARCHAR2
IS
  v_pattern   VARCHAR2(200);
  v_result    VARCHAR2(500) := '';
BEGIN
  IF p_text IS NULL THEN
    RETURN NULL;
  END IF;

  -- 1.1、UPS(1Z+16位编码）
  v_pattern := '(1Z|IZ)[[:space:]]?[A-Z0-9]{3}[[:space:]]?[A-Z0-9]{3}[[:space:]]?[A-Z0-9]{2}[[:space:]]?[A-Z0-9]{4}[[:space:]]?[A-Z0-9]{4}';
  v_result := REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_SUBSTR(p_text, v_pattern, 1, 1, 'i'),'[[:space:]]',''),'IZ','1Z');
  IF v_result IS NOT NULL THEN
    RETURN UPPER(v_result);
  END IF;

  -- 1.2、DHL(10位数字)
  IF REGEXP_INSTR(UPPER(p_text),'DHL|WAYBILL') > 0 THEN
    v_pattern := '(DHL|DHL NO.|WAYBILL|快递|快递号|快递单|快递单号|国际快件|提单|[^(报关|报关单|报送|报送单)]单号)[#:：_[:space:]-]{0,3}(\d{2}[[:space:]]?\d{4}[[:space:]]?\d{4})';
    v_result := REGEXP_REPLACE(REGEXP_SUBSTR(p_text, v_pattern, 1, 1, 'i', 2),'[[:space:]]','');
  END IF; 
  IF v_result IS NOT NULL THEN
    RETURN 'DHL' || UPPER(v_result);
  END IF;

  -- 1.3、FEDEX(10-12位数字)
  IF REGEXP_INSTR(UPPER(p_text),'联邦|FEDEX|TRK') > 0 THEN
    v_pattern := '(FEDEX|FEDEX NO.|联邦|TRK|快递|快递号|快递单|快递单号|国际快件|提单|[^(报关|报关单|报送|报送单)]单号)[#:：_[:space:]-]{0,3}(\d{4}[[:space:]]?\d{4}[[:space:]]?\d{2,4})';
    v_result := REGEXP_REPLACE(REGEXP_SUBSTR(p_text, v_pattern, 1, 1, 'i', 2),'[[:space:]]','');
  END IF; 
  IF v_result IS NOT NULL THEN
    RETURN 'FEDEX' || UPPER(v_result);
  END IF;

  -- 1.4、顺丰(SF+12,13位数字）
  IF REGEXP_INSTR(UPPER(p_text),'顺丰|SF') > 0 THEN
    v_pattern := '(顺丰|SF|快递|快递号|快递单|快递单号|国际快件|提单|[^(报关|报关单|报送|报送单)]单号)[#:：_[:space:]-]{0,3}(\d{3}[[:space:]]?\d{3}[[:space:]]?\d{3}[[:space:]]?\d{3,4})';
    v_result := REGEXP_REPLACE(REGEXP_SUBSTR(p_text, v_pattern, 1, 1, 'i', 2),'[[:space:]]','');
  END IF; 
  IF v_result IS NOT NULL THEN
    RETURN 'SF' || UPPER(v_result);
  END IF;

  -- 1.5、德邦(DPK|DPL+12位数字）
  v_pattern := '(DPK|DPL)\d{12}';
  v_result := REGEXP_SUBSTR(p_text, v_pattern, 1, 1, 'i');
  IF v_result IS NOT NULL THEN
    RETURN UPPER(v_result);
  END IF;

  -- 1.6、跨越(KY+13位数字 or KYE+12位数字）
  v_pattern := '(KY)(\d{13}|E\d{12})';
  v_result := REGEXP_SUBSTR(p_text, v_pattern, 1, 1, 'i');
  IF v_result IS NOT NULL THEN
    RETURN UPPER(v_result);
  END IF;

  -- 1.7、中通快运（ZY+12位数字）
  v_pattern := '(ZY)\d{12}';
  v_result := REGEXP_SUBSTR(p_text, v_pattern, 1, 1, 'i');
  IF v_result IS NOT NULL THEN
    RETURN UPPER(v_result);
  END IF;

  -- 1.8、京东(JD+13-18位字符）
  v_pattern := '(JD)[A-Z0-9]{13,18}';
  v_result := REGEXP_SUBSTR(p_text, v_pattern, 1, 1, 'i');
  IF v_result IS NOT NULL THEN
    RETURN UPPER(v_result);
  END IF;

  -- 1.9、安能|中通|申通|百世|韵达
  v_pattern := '(安能|中通|申通|百世|韵达)[物流快速运递单号#:：;；_[:space:]-]*([0-9]{6,20})';
  v_result := REGEXP_REPLACE(REGEXP_SUBSTR(p_text, v_pattern, 1, 1, 'i'),'[物流快速运递单号#:：;；_[:space:]-]','');
  IF v_result IS NOT NULL THEN
    RETURN UPPER(v_result);
  END IF;

  -- 1.10、速腾|速通|汇森速运|嘉里大通|顺心捷达|融辉
  v_pattern := '(速腾|速通|汇森速运|嘉里大通|顺心捷达|融辉)[物流快递单号#:：;；_[:space:]-]*([A-Z0-9]{6,20})';
  v_result := REGEXP_REPLACE(REGEXP_SUBSTR(p_text, v_pattern, 1, 1, 'i'),'[物流快递单号#:：;；_[:space:]-]','');
  IF v_result IS NOT NULL THEN
    RETURN UPPER(v_result);
  END IF;

  --2.1、其他快递
  v_pattern := '(快递|快递单|快递号|快递单号|快递运单|快递运单号)[:：[:space:]]{0,3}([A-Z0-9]{6,20}|\d{2,4}[[:space:]-]?\d{3,4}[[:space:]]?\d{4}|\d{2}[[:space:]-]?\d{3}[[:space:]-]?\d{3}[[:space:]-]?\d{3})';
  v_result := UPPER(REGEXP_REPLACE(REGEXP_SUBSTR(p_text, v_pattern, 1, 1, 'i', 2),'[[:space:]-]',''));
  IF v_result IS NOT NULL THEN
    RETURN '(快递)' || UPPER(v_result);
  END IF;

  --2.2、其他物流
  v_pattern := '(物流|物流单|物流号|物流单号)[:：[:space:]]{0,3}([A-Z0-9]{6,20}|\d{2,4}[[:space:]-]?\d{3,4}[[:space:]]?\d{4}|\d{2}[[:space:]-]?\d{3}[[:space:]-]?\d{3}[[:space:]-]?\d{3})';
  v_result := UPPER(REGEXP_REPLACE(REGEXP_SUBSTR(p_text, v_pattern, 1, 1, 'i', 2),'[[:space:]-]',''));
  IF v_result IS NOT NULL THEN
    RETURN '(物流)' || UPPER(v_result);
  END IF;

  RETURN UPPER(v_result);

END f_wlgl_extract_parcel;
/
