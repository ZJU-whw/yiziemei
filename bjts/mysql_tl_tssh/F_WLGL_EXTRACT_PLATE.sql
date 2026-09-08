DELIMITER $$

DROP PROCEDURE IF EXISTS F_WLGL_EXTRACT_PLATE$$

CREATE PROCEDURE f_wlgl_extract_plate
-- ============================================
-- 函数：提取车牌号、物流单号（仅取第一个）
-- ============================================
(
  IN p_text VARCHAR(4000),
  OUT p_addr DECIMAL(38,10)
, OUT P_RESULT VARCHAR(4000))
routine_body: BEGIN
  DECLARE v_pattern   VARCHAR(200);
  DECLARE v_result    VARCHAR(500) DEFAULT '';

  IF p_text IS NULL THEN
    SET P_RESULT = NULL; LEAVE routine_body;
  END IF;

  -- 匹配车牌号
  -- 省份简称 + 字母 + 5或6位字母数字，包括 7 位燃油车 / 8 位新能源
  -- 允许省份与字母智检有一个空格、允许首字母与后续号码之间有。.·空格等
  -- 自动屏蔽 I、O 易混淆字母，不匹配军牌、警牌、使领馆黑牌、挂车
  -- v_pattern := '([京津冀晋蒙辽吉黑沪苏浙皖闽赣鲁豫鄂湘粤桂琼渝川贵云藏陕甘青宁新][.·[:space:]-]{0,1}[A-HJ-NP-Z][。？.·[:space:]-]{0,1}([0-9A-HJ-NP-Z]{5,6}))';

  -- 将I转换为1，O转换为0，不匹配军牌、警牌、使领馆黑牌、挂车
  SET v_pattern = '([京津冀晋蒙辽吉黑沪苏浙皖闽赣鲁豫鄂湘粤桂琼渝川贵云藏陕甘青宁新][.·[:space:]-]{0,1}[A-Z][。？.·[:space:]-]{0,1}([0-9A-Z]{5,6}))';
  SET v_result = REGEXP_SUBSTR(p_text, v_pattern, 1, 1, 'i');
  SET p_addr = REGEXP_INSTR(p_text,v_result,1);
  SET v_result = UPPER(REGEXP_REPLACE(v_result,'[。？.·[:space:]-]',''));
  SET v_result = REGEXP_REPLACE(v_result,'I','1');
  SET v_result = REGEXP_REPLACE(v_result,'O','0');

  SET P_RESULT = UPPER(v_result); LEAVE routine_body;

END$$

DELIMITER ;
