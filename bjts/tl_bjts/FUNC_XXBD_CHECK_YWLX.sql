CREATE OR REPLACE FUNCTION FUNC_XXBD_CHECK_YWLX(V_CONT IN VARCHAR2)
  RETURN NUMBER
/*
 * 功  能：判断申报明细表中的出口业务类型是否包含特定业务类型
 * 返回值：是返回1，否返回0
 */
AS
BEGIN
  --ZB  中标机电
  --JGW 海洋结构物
  --WL  外轮货物
  --HKSP  航空食品
  --XTHH-XH 先退后核
  --XTHH-CJ 先退后核
  --XLXP 修理修配
  --HXWH 航线维护
  --HCWX 航次维修
  --WLMSP 未列明商品
  IF V_CONT LIKE '%,ZB,%' OR
     V_CONT LIKE '%,JGW,%' OR
     V_CONT LIKE '%,WL,%' OR
     V_CONT LIKE '%,HKSP,%' OR
     V_CONT LIKE '%,XTHH-XT,%' OR
     V_CONT LIKE '%,XTHH-CJ,%' OR
     V_CONT LIKE '%,HCWX,%' OR
     V_CONT LIKE '%,HXWH,%' OR
     V_CONT LIKE '%,WLMSP,%' THEN
    RETURN 1;
  END IF;
  RETURN 0;
END;
/
