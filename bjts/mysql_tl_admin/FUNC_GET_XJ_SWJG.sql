DELIMITER $$

DROP PROCEDURE IF EXISTS FUNC_GET_XJ_SWJG$$

CREATE PROCEDURE func_get_xj_swjg(p_sj_swcode VARCHAR(4000))
routine_body: BEGIN
  -- Oracle REF CURSOR type removed; target uses a result set;
  DECLARE my_cursor Type_Cursor;
  DECLARE o_tb TYPE_TB_SWJGLIST DEFAULT TYPE_TB_SWJGLIST();
  DECLARE dyn_select VARCHAR(1500);
  DECLARE v_swjg VARCHAR(11);
  DECLARE i DECIMAL(38,10) DEFAULT 0;

  --根据传入的swcode，取下辖税务机关代码（列表）
  if substr(p_sj_swcode,1,1)='2' then
    SET dyn_select ='select VIR_SWJGDM from TL_ADMIN.DM_SWJG_VIRTUAL t '
             || '  where SWJG_DM=''' || p_sj_swcode || ''' and YXBZ=''Y'' and VIR_FLAG=''0'' ';
  else
    SET dyn_select ='select swjg_dm from TL_ADMIN.DM_SWJG t '
             || '  where SWJG_DM_SJ=''' || p_sj_swcode || ''' and TSJG_BZ=''1'' ';
  end if;

  OPEN my_cursor FOR dyn_select;
  LOOP
    FETCH my_cursor INTO v_swjg;
    EXIT WHEN my_cursor%NOTFOUND;
    o_tb.extend;
    SET i = i + 1;
    o_tb(i) := TYPE_REC_SWJGLIST (v_swjg);
  END LOOP;
  CLOSE my_cursor;

  LEAVE routine_body;
END$$

DELIMITER ;
