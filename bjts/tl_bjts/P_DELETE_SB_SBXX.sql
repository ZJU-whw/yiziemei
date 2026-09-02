CREATE OR REPLACE PROCEDURE P_DELETE_SB_SBXX
AS
  CURSOR pc_nsr IS select id from sb_sbxx_hz hz where hz.sbzt_dm= '39';
  rs_nsr pc_nsr%ROWTYPE;
BEGIN
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
    DBMS_OUTPUT.put_line('Ê§°Ü:' || sqlerrm);
END;
/
