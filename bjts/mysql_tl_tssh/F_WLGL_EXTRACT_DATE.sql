DELIMITER $$

DROP FUNCTION IF EXISTS F_WLGL_EXTRACT_DATE$$

CREATE FUNCTION f_wlgl_extract_date
-- ============================================
-- 函数：提取并标准化起运日
-- ============================================
(
  p_text VARCHAR(4000),
  p_date DATETIME
)
RETURNS DATETIME
NOT DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';
  DECLARE v_date_ck     VARCHAR(100);
  DECLARE v_text_nock   VARCHAR(2000);
  DECLARE v_pattern     VARCHAR(200);
  DECLARE v_date_str    VARCHAR(30);
  DECLARE v_result      DATETIME;


  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
  RETURN NULL; -- 日期解析失败返回空

  END;
IF p_text IS NULL THEN
    RETURN NULL;
  END IF;

  -- 为防止出口日期干扰，将出口日期相关信息先置换掉
  SET v_pattern = '(出口日期)[:：[:space:]]*(\\d{8}|\\d{4}[-/\\.,]\\d{1,2}[-/\\.,]\\d{1,2}|\\d{4}年\\d{1,2}月\\d{1,2}日)';
  SET v_date_ck = REGEXP_SUBSTR(p_text, v_pattern, 1, 1, 'i');
  SET v_text_nock = REGEXP_REPLACE(p_text, v_date_ck, '');

  -- 1、有日期格式(Mon-dd-yyyy OR YYYY-Mon-DD)
  SET v_pattern = ORA_CONCAT('((Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Mon|Nov|Dec)[-/\\.,]\\d{1,2}[-/\\.,]\\d{4}|', '\\d{4}[-/\\.,](Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Mon|Nov|Dec)[-/\\.,]\\d{1,2})');
  SET v_date_str = UPPER(REGEXP_SUBSTR(v_text_nock, v_pattern, 1, 1, 'i'));
  IF v_date_str IS NULL THEN
    -- 2、有日期格式(Y.M.D OR Y年M月D日(号) OR M月D日(号))
    SET v_pattern = '(\\d{2,4}[-/\\.]\\d{1,2}[-/\\.]\\d{1,2}|\\d{2,4}年\\d{1,2}月\\d{1,2}(日|号)|\\d{1,2}月\\d{1,2}(日|号))';
    SET v_date_str = REGEXP_REPLACE(REGEXP_SUBSTR(v_text_nock, v_pattern, 1, 1, 'i'),'号','日');
  END IF;
  IF v_date_str IS NULL THEN
    -- 3、纯8位数字YYYYMMDD，为了准确分割，要求提取的8位数据前后均为非数字，然后将前后的非数字替换掉
    SET v_pattern = '[^0-9]\\d{8}([^0-9]|$)';
    SET v_date_str = REGEXP_REPLACE(REGEXP_SUBSTR(v_text_nock, v_pattern, 1, 1, 'i'),'[^0-9]+','');
  END IF;
  IF v_date_str IS NULL THEN
    -- 4、带前缀日期标识的6位YYMMDD、4位MMDD，为了准确分割，要求提取的数据后面为非数字
    SET v_pattern = '(起运|启运|出运|起始|起送|始运|发车|发货|装货|送货|拉货|装运|装柜|装箱)(日|日期|时间)[:：[:space:]]*(\\d{6}|\\d{4})([^0-9]|$)';
    SET v_date_str = REGEXP_REPLACE(REGEXP_SUBSTR(v_text_nock, v_pattern, 1, 1, 'i'),'[^0-9]+','');
  END IF;
  IF v_date_str IS NULL THEN
    -- 5、带前缀日期标识的 MM.DD，为了准确分割，要求提取的数据后面为非数字
    SET v_pattern = '(起运|启运|出运|起始|起送|始运|发车|发货|装货|送货|拉货|装运|装柜|装箱)(日|日期|时间)[:：[:space:]]*\\d{1,2}[-/\\.]\\d{1,2}([^0-9]|$)';
    SET v_date_str = REGEXP_REPLACE(REGEXP_SUBSTR(v_text_nock, v_pattern, 1, 1, 'i'),'[^0-9/\\.-]+','');
  END IF;

  -- 统一标准化为 YYYY-MM-DD
  -- 情况1.1: APR.13.2026
  IF REGEXP_LIKE(v_date_str, '^(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|MON|NOV|DEC)[-/\\.,]\\d{1,2}[-/\\.,]\\d{4}$') THEN
    SELECT STR_TO_DATE(REGEXP_REPLACE(v_date_str, '[-/\\.,]', '-'), '%b-%d-%Y')
      INTO v_result
;
  -- 情况1.2: 2026.APR.13
  ELSEIF REGEXP_LIKE(v_date_str, '^\\d{4}[-/\\.,](JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|MON|NOV|DEC)[-/\\.,]\\d{1,2}$') THEN
    SELECT STR_TO_DATE(REGEXP_REPLACE(v_date_str, '[-/\\.]', '-'), '%Y-%b-%d')
      INTO v_result
;
  -- 情况2.1: 2023-01-15 / 2023/01/15 / 2023.01.15
  ELSEIF REGEXP_LIKE(v_date_str, '^\\d{4}[-/\\.]\\d{1,2}[-/\\.]\\d{1,2}$') THEN
    SELECT STR_TO_DATE(REGEXP_REPLACE(v_date_str, '[-/\\.]', '-'), '%Y-%m-%d')
      INTO v_result
;
  -- 情况2.2: 23-01-15 / 23/01/15 / 23.01.15
  ELSEIF REGEXP_LIKE(v_date_str, '^\\d{2}[-/\\.]\\d{1,2}[-/\\.]\\d{1,2}$') THEN
    SELECT STR_TO_DATE(REGEXP_REPLACE(ORA_CONCAT('20', v_date_str), '[-/\\.]', '-'), '%Y-%m-%d')
      INTO v_result
;
  -- 情况2.3: 2023年1月15日
  ELSEIF REGEXP_LIKE(v_date_str, '^\\d{4}年\\d{1,2}月\\d{1,2}日$') THEN
    SELECT STR_TO_DATE(v_date_str, '%Y年%m月%d日')
      INTO v_result
;
  -- 情况2.4: 23年1月15日
  ELSEIF REGEXP_LIKE(v_date_str, '^\\d{2}年\\d{1,2}月\\d{1,2}日$') THEN
    SELECT STR_TO_DATE(ORA_CONCAT('20', v_date_str), '%Y年%m月%d日')
      INTO v_result
;
  -- 情况2.5: 1月15日
  ELSEIF REGEXP_LIKE(v_date_str, '^\\d{1,2}月\\d{1,2}日$') THEN
    SELECT STR_TO_DATE(ORA_CONCAT(ORA_CONCAT(DATE_FORMAT(p_date, '%Y'), '年'), v_date_str), '%Y年%m月%d日')
      INTO v_result
;
  -- 情况3: 纯8位数字 20230115
  ELSEIF REGEXP_LIKE(v_date_str, '^\\d{8}$') THEN
    SELECT STR_TO_DATE(v_date_str, '%Y%m%d')
      INTO v_result
;
  -- 情况4.1: 纯6位数字 230115
  ELSEIF REGEXP_LIKE(v_date_str, '^\\d{6}$') THEN
    SELECT STR_TO_DATE(ORA_CONCAT('20', v_date_str), '%Y%m%d')
      INTO v_result
;
  -- 情况4.2: 纯4位数字 0115
  ELSEIF REGEXP_LIKE(v_date_str, '^\\d{4}$') THEN
    SELECT STR_TO_DATE(ORA_CONCAT(DATE_FORMAT(p_date, '%Y'), v_date_str), '%Y%m%d')
      INTO v_result
;
  -- 情况5: 01-15 / 01/15 / 01.15
  ELSEIF REGEXP_LIKE(v_date_str, '^\\d{1,2}[-/\\.]\\d{1,2}$') THEN
    SELECT STR_TO_DATE(ORA_CONCAT(ORA_CONCAT(DATE_FORMAT(p_date, '%Y'), '-'), REGEXP_REPLACE(v_date_str, '[-/\\.]', '-')), '%Y-%m-%d')
      INTO v_result
;
  END IF;

  RETURN v_result;

END$$

DELIMITER ;
