create or replace function func_get_xj_swjg(p_sj_swcode varchar2)
return TYPE_TB_SWJGLIST
is
  TYPE Type_Cursor IS REF CURSOR;
  my_cursor Type_Cursor;
  o_tb TYPE_TB_SWJGLIST := TYPE_TB_SWJGLIST();
  dyn_select varchar2(1500);
  v_swjg varchar2(11);
  i number := 0;
begin
  --根据传入的swcode，取下辖税务机关代码（列表）
  if substr(p_sj_swcode,1,1)='2' then
    dyn_select:='select VIR_SWJGDM from TL_ADMIN.DM_SWJG_VIRTUAL t '
             || '  where SWJG_DM=''' || p_sj_swcode || ''' and YXBZ=''Y'' and VIR_FLAG=''0'' ';
  else
    dyn_select:='select swjg_dm from TL_ADMIN.DM_SWJG t '
             || '  where SWJG_DM_SJ=''' || p_sj_swcode || ''' and TSJG_BZ=''1'' ';
  end if;

  OPEN my_cursor FOR dyn_select;
  LOOP
    FETCH my_cursor INTO v_swjg;
    EXIT WHEN my_cursor%NOTFOUND;
    o_tb.extend;
    i := i + 1;
    o_tb(i) := TYPE_REC_SWJGLIST (v_swjg);
  END LOOP;
  CLOSE my_cursor;

  return o_tb;
end func_get_xj_swjg;
/
