CREATE OR REPLACE FUNCTION FUNC_XXBD_CHECK_NEEDSH(V_YWLX IN VARCHAR2)
  RETURN NUMBER
/*
 * 功  能：判断申报明细表中的出口业务类型是否需要收汇
 * 返回值：是返回1，否返回0
 */
AS
BEGIN
  -- DWYZ	对外援助
  -- DWCB	对外承包
  -- JWTZ	境外投资
  -- MSD	免税店
  -- ZB	中标机电
  -- JGW	海洋结构物
  -- WL	外轮货物
  -- HKSP	航空食品
  -- XLXP	修理修配
  -- XLXP-01	修飞机
  -- XLXP-02	修船舶
  -- HXWH	航线维护
  -- HCWX	航次维修
  -- GHQYTS	横琴平潭购进货物
  -- BM	边贸
  -- BMDL	边贸代理
  -- RZZL	融资租赁
  -- WLMSP	未列明商品
  -- HZCJ	红字冲减
  -- HZCJ-TY	红字冲减-退运
  -- XTHH-CJ	先退后核-冲减
  -- XTHH-XT	先退后核-先退
  IF V_YWLX LIKE '%,DWYZ,%' OR
     V_YWLX LIKE '%,DWCB,%' OR
     V_YWLX LIKE '%,JWTZ,%' OR
     V_YWLX LIKE '%,MSD,%' OR
     V_YWLX LIKE '%,ZB,%' OR
     V_YWLX LIKE '%,JGW,%' OR
     V_YWLX LIKE '%,WL,%' OR
     V_YWLX LIKE '%,HKSP,%' OR
	 V_YWLX LIKE '%,XLXP,%' OR
	 V_YWLX LIKE '%,XLXP-01,%' OR
	 V_YWLX LIKE '%,XLXP-02,%' OR
	 V_YWLX LIKE '%,HXWH,%' OR
	 V_YWLX LIKE '%,HCWX,%' OR
	 V_YWLX LIKE '%,GHQYTS,%' OR
	 V_YWLX LIKE '%,BM,%' OR
	 V_YWLX LIKE '%,BMDL,%' OR
	 V_YWLX LIKE '%,RZZL,%' OR
	 V_YWLX LIKE '%,WLMSP,%' OR
     V_YWLX LIKE '%,HZCJ,%' OR
     V_YWLX LIKE '%,HZCJ-TY,%' OR
     V_YWLX LIKE '%,XTHH-CJ,%' OR
     V_YWLX LIKE '%,XTHH-XT,%' THEN
    RETURN 0;
  END IF;
  RETURN 1;
END;
/
