create or replace procedure P_TB_DOEVERYDAY
as
  v_msgtext varchar2(4000);
begin
  --计划任务

--  if extract(day from sysdate) = 1 then
    --每个月1号执行一次
    --随机分单，每个账户月分配笔数，月初清0
    update sys_cfg_czry_fpgl set cnt_sc=0,cnt_wm=0,cnt_qt=0;
    commit;
    sys.dbms_output.put_line('随机分单月初清0');
--  end if;
  return;

  exception
    When others then
    v_msgtext := sqlerrm;
    rollback;
    sys.dbms_output.put_line('Error: ' || v_msgtext);
    return;
end;
/
