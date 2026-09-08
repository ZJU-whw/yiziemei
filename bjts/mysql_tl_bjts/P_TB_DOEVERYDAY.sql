DELIMITER $$

DROP PROCEDURE IF EXISTS P_TB_DOEVERYDAY$$

CREATE procedure P_TB_DOEVERYDAY()
routine_body: BEGIN
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';
  DECLARE v_msgtext VARCHAR(4000);

  -- 计划任务

--  if extract(day from sysdate) = 1 then
    -- 每个月1号执行一次
    -- 随机分单，每个账户月分配笔数，月初清0

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
    SET v_msgtext = BJTS_SQLERRM_001;
    rollback;
    DO ORA_CONCAT('Error: ', v_msgtext);
    LEAVE routine_body;

  END;
update sys_cfg_czry_fpgl set cnt_sc=0, cnt_wm=0, cnt_qt=0;
    commit;
    DO '随机分单月初清0';
--  end if;
  LEAVE routine_body;

  END$$

DELIMITER ;
