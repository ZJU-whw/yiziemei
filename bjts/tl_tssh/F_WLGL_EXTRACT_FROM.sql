CREATE OR REPLACE FUNCTION f_wlgl_extract_from
-- ============================================
-- 函数：提取起运地
-- ============================================
(
  p_text IN VARCHAR2
)
RETURN VARCHAR2
IS
  v_pattern   VARCHAR2(200);
  v_result    VARCHAR2(500) := '';
  v_end       NUMBER(3);
BEGIN
  IF p_text IS NULL THEN
    RETURN NULL;
  END IF;

  -- 方式1: 匹配关键词前缀，取到下一个分隔符(逗号/分号/空白字符)为止
  v_pattern := '(起至运|起运|启运|起始|起送|始发|始运|出发|出运|发货|出货|发车|装货|装运|装车|装柜|装箱|托运)(地点|地址|地区|地|点)[:：;；[:space:]]*\s*([^A-Z0-9,，;；：.．。、/[:space:]]+)';
  v_result := REGEXP_SUBSTR(p_text, v_pattern, 1, 1, 'i', 3);
  IF v_result IS NULL OR LENGTH(v_result)<2 THEN
    v_pattern := '(货源地|产地)[:：;；[:space:]]*\s*([^A-Z0-9,，;；：.．。、/[:space:]]+)';
    v_result := REGEXP_SUBSTR(p_text, v_pattern, 1, 1, 'i', 2);
  END IF;
  -- 起运地后无分隔，直接跟其他汉字，根据目前备注的标签截取
  v_end := REGEXP_INSTR(v_result,'起运|启运|起始|起送|始发|始运|出发|出运|发货|出货|发车|装货|装运|装车|币种|车牌|快递|报关',1);
  IF v_end>1 THEN
    v_result := SUBSTR(v_result,1,v_end-1);
  END IF;
  
  -- 方式2.1: 匹配"从XX出发/起运"
  IF v_result IS NULL OR LENGTH(v_result)<2 THEN
    v_pattern := '(从|在)([^A-Z0-9,，;；.．。[:space:]]+)(到|至|出发|起运|发运|发货|发车|装车|发往)';
    v_result := REGEXP_SUBSTR(p_text, v_pattern, 1, 1, 'i', 2);
  END IF;
  
  -- 方式2.2: 匹配"从XX出发/起运"
  IF v_result IS NULL OR LENGTH(v_result)<2 THEN
    v_pattern := '([^A-Z0-9,，;；.．。[:space:]]+)(到|至|出发|起运|发运|发货|发车|装车|发往)';
    v_result := REGEXP_SUBSTR(p_text, v_pattern, 1, 1, 'i', 1);
  END IF;

  -- 方式3: 兜底 - 匹配常见省/市后缀地名（可按需扩展字典）
  IF v_result IS NULL OR LENGTH(v_result)<2 THEN
    v_pattern := '[^A-Z0-9,，;；:：.．。[:space:]]*(省|市|自治区|州|县|区)';
    v_result := REGEXP_SUBSTR(p_text, v_pattern, 1, 1, 'i');
  END IF;

  -- 方式4: 兜底 - 省内地市、绍兴区县
  IF v_result IS NULL OR LENGTH(v_result)<2 THEN
    v_pattern := '(浙江|杭州|宁波|温州|嘉兴|湖州|绍兴|金华|衢州|舟山|台州|丽水|越城|柯桥|上虞|新昌|诸暨|上虞|嵊州)($|[^A-Z0-9,，;；：.．。、[:space:]]*)';
    v_result := REGEXP_SUBSTR(p_text, v_pattern, 1, 1, 'i');
  END IF;

  RETURN v_result;

END f_wlgl_extract_from;
/
