DELIMITER $$

DROP PROCEDURE IF EXISTS P_TB_DOEVERYDAY$$

CREATE procedure P_TB_DOEVERYDAY
routine_body: BEGIN
  DECLARE v_msgtext VARCHAR(4000);

  --计划任务

--  if extract(day from sysdate) = 1 then
    --每个月1号执行一次
    --随机分单，每个账户月分配笔数，月初清0
    update sys_cfg_czry_fpgl set cnt_sc=0,cnt_wm=0,cnt_qt=0;
    commit;
    sys.dbms_output.put_line('随机分单月初清0');
--  end if;
  LEAVE routine_body;

  exception
    When others then
    SET v_msgtext = sqlerrm;
    rollback;
    sys.dbms_output.put_line('Error: ' || v_msgtext);
    LEAVE routine_body;
END$$

DELIMITER ;
