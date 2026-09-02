CREATE OR REPLACE FUNCTION f_wlgl_extract_plate
-- ============================================
-- 函数：提取车牌号、物流单号（仅取第一个）
-- ============================================
(
  p_text IN  VARCHAR2,
  p_addr OUT NUMBER
)
RETURN VARCHAR2
IS
  v_pattern   VARCHAR2(200);
  v_result    VARCHAR2(500) := '';
BEGIN
  IF p_text IS NULL THEN
    RETURN NULL;
  END IF;

  -- 匹配车牌号
  -- 省份简称 + 字母 + 5或6位字母数字，包括 7 位燃油车 / 8 位新能源
  -- 允许省份与字母智检有一个空格、允许首字母与后续号码之间有。.·空格等
  -- 自动屏蔽 I、O 易混淆字母，不匹配军牌、警牌、使领馆黑牌、挂车
  -- v_pattern := '([京津冀晋蒙辽吉黑沪苏浙皖闽赣鲁豫鄂湘粤桂琼渝川贵云藏陕甘青宁新][.·[:space:]-]{0,1}[A-HJ-NP-Z][。？.·[:space:]-]{0,1}([0-9A-HJ-NP-Z]{5,6}))';

  -- 将I转换为1，O转换为0，不匹配军牌、警牌、使领馆黑牌、挂车
  v_pattern := '([京津冀晋蒙辽吉黑沪苏浙皖闽赣鲁豫鄂湘粤桂琼渝川贵云藏陕甘青宁新][.·[:space:]-]{0,1}[A-Z][。？.·[:space:]-]{0,1}([0-9A-Z]{5,6}))';
  v_result := REGEXP_SUBSTR(p_text, v_pattern, 1, 1, 'i');
  p_addr := REGEXP_INSTR(p_text,v_result,1);
  v_result := UPPER(REGEXP_REPLACE(v_result,'[。？.·[:space:]-]',''));
  v_result := REGEXP_REPLACE(v_result,'I','1');
  v_result := REGEXP_REPLACE(v_result,'O','0');

  RETURN UPPER(v_result);

END f_wlgl_extract_plate;
/
