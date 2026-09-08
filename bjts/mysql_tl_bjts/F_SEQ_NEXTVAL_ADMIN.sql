DELIMITER $$

DROP FUNCTION IF EXISTS F_SEQ_NEXTVAL_ADMIN$$

CREATE function f_seq_nextval_admin(ptablename VARCHAR(4000))
RETURNS integer
NOT DETERMINISTIC
MODIFIES SQL DATA
BEGIN
  DECLARE FunctionResult integer;
  DECLARE PRAGMA AUTONOMOUS_TRANSACTION;

   update sys_sequence set curvalue = curvalue + 1
    where tblname = ptablename;

   select curvalue into FunctionResult from sys_sequence where tblname=ptablename;
   commit;

  return(FunctionResult);
END$$

DELIMITER ;
