create or replace function TEMP_DATA_INIT(sbqb varchar2) return varchar2 is
  Result varchar2(1);
  TYPE Type_Cursor IS REF CURSOR;
  my_cursor Type_Cursor;
  dyn_select varchar2(1500);
  v_id number(18);
  v_sbqb varchar2(6);
  v_value number(12);
  v_sbywbDm varchar2(8);
  v_swjgDm varchar2(11);
  PRAGMA AUTONOMOUS_TRANSACTION;
begin
  dyn_select:=' select trunc(DBMS_RANDOM.VALUE(1,9999999999))+to_number(substr(sbywb_dm,2,7)) as id, '||sbqb||' as sbqb,
   count(1) as value, sbywb_dm as sbywbDm, swjg_dm as swjgDm
    from (
       select distinct dj.swjg_dm,t.nsrdzdah,t.sbywb_dm, t.sssq, t.sbpc
       from SB_SBXX_HZ t,gs_dj_cktmsdab dj
       where t.nsrdzdah=dj.nsrdzdah
       and to_char(t.sbrq, ''YYYYMM'') = '||sbqb||' ) b
    group by swjg_dm, sbywb_dm ';
    OPEN my_cursor FOR dyn_select;
  LOOP
    FETCH my_cursor INTO v_id,v_sbqb,v_value,v_sbywbDm,v_swjgDm;
    EXIT WHEN my_cursor%NOTFOUND;
    insert into TB_REPORT_DATA values(v_id,v_sbqb,v_value,v_sbywbDm,v_swjgDm,'0',sysdate);
    commit;
  END LOOP;
  CLOSE my_cursor;
  Result:='1';
  return(Result);
end TEMP_DATA_INIT;
/
