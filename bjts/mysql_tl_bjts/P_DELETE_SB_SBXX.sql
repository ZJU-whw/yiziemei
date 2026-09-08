DELIMITER $$

DROP PROCEDURE IF EXISTS P_DELETE_SB_SBXX$$

CREATE PROCEDURE P_DELETE_SB_SBXX
routine_body: BEGIN
  DECLARE pc_nsr CURSOR FOR select id from sb_sbxx_hz hz where hz.sbzt_dm= '39';
  DECLARE rs_nsr pc_nsr%ROWTYPE;

  OPEN pc_nsr;
  LOOP
    FETCH pc_nsr INTO rs_nsr;
    EXIT WHEN pc_nsr%NOTFOUND;

    delete from sb_sbxx_sbsj where id = rs_nsr.id;
    delete from sb_sbxx_fksj where id = rs_nsr.id;
    commit;
  END LOOP;
  CLOSE pc_nsr;
  COMMIT;
  EXCEPTION
    WHEN others THEN
    DBMS_OUTPUT.put_line('失败:' || sqlerrm);
END$$

DELIMITER ;
