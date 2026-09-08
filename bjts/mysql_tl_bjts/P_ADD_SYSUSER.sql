DELIMITER $$

DROP PROCEDURE IF EXISTS P_ADD_SYSUSER$$

CREATE procedure P_ADD_SYSUSER
routine_body: BEGIN
  DECLARE cnt integer;
  DECLARE swjc integer;
  DECLARE pid BIGINT;
  DECLARE v_czry_dm VARCHAR(11);
  DECLARE v_czry_mc VARCHAR(20);
  DECLARE v_swjg_dm VARCHAR(11);
  DECLARE v_password VARCHAR(50);
  DECLARE cur_czy CURSOR FOR
      select czry_dm,czry_mc,swjg_dm
         from tmp_sszj t
         where not exists(select 1 from sys_user s
         where s.czry_dm=t.czry_dm) ;
  

  -- default pwd: a1234567
  SET v_password ='a55a3975f293712e641eb838e4585c03';
  
  FOR cur IN cur_czy
  LOOP
      SET V_CZRY_DM =cur.czry_dm;
      SET V_CZRY_MC =cur.czry_mc;
      SET V_SWJG_DM =cur.swjg_dm;

    BEGIN
     select id into pid from sys_user t
      where t.czry_dm=v_CZRY_DM;
     EXCEPTION
      WHEN OTHERS THEN
        SET pid =0;
     END;

    -- 检查操作员
    if (pid=0) then
      SET pid = f_seq_nextval_admin('SYS_USER');
      insert into sys_user(id,czry_dm,czry_mc,password,swjg_dm,usrstate
             ,crtime,crname,uptime,upname,qybz,yhly)
        values(pid,
        v_czry_dm,v_czry_mc,v_password,v_swjg_dm,'3',
        CURRENT_TIMESTAMP,'admin',CURRENT_TIMESTAMP,'admin','1','0');

    end if;
    
      --检查角色
      if (pid>0) then
        select count(1) into cnt from sys_user_role r where r.czyid=pid;
        if cnt = 0 then
            SET swjc =case when substr(v_swjg_dm,-8)='00000000' then 1
                 when substr(v_swjg_dm,-6)='000000' then 2
                 when substr(v_swjg_dm,-4)='0000' then 3
                   else 0 end ;

            if swjc='1' then
              --省局专责
              insert into sys_user_role values(pid,'SHJZZ');
            else if swjc='2' then
              --市局专责
              insert into sys_user_role values(pid,'SJZZ');
            else if swjc='3' then
              --县局专责
              insert into sys_user_role values(pid,'XJZZ');
            end if;
            end if;
            end if;

            -- 单证备案, 2.0 ,1.0
            insert into sys_user_role values(pid,'DZBACZ');
            -- sszj
            insert into sys_group_user values('SSZJ',pid);


        end if;
      end if;
  END LOOP  

  LEAVE routine_body;

END$$

DELIMITER ;
