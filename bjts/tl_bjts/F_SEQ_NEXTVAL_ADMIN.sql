create or replace function f_seq_nextval_admin(ptablename varchar2) return integer is
  FunctionResult integer;
  PRAGMA AUTONOMOUS_TRANSACTION;
begin
   update tl_admin.sys_sequence set curvalue = curvalue + 1
    where tblname = ptablename;

   select curvalue into FunctionResult from tl_admin.sys_sequence where tblname=ptablename;
   commit;

  return(FunctionResult);
end f_seq_nextval_admin;
/
