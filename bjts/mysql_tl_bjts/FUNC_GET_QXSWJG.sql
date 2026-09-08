DELIMITER $$

DROP FUNCTION IF EXISTS FUNC_GET_QXSWJG$$

CREATE function Func_Get_Qxswjg(swjg_dm VARCHAR(4000))
RETURNS VARCHAR(4000)
NOT DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE v_qxSwjg VARCHAR(11);
  DECLARE i integer;

  if length(swjg_dm)<11 then
     SET v_qxSwjg =swjg_dm;
  else
    begin
      SET i =5;
      while i> 1 loop
        --DBMS_OUTPUT.put_line('For:'|| to_char(i) || '--' || substr(swjg_dm,2+(i*2),2));
        if substr(swjg_dm,(i*2),2)<>'00' then
          begin
            SET v_qxSwjg =substr(swjg_dm,1,(i*2)+1);
            exit;
          end;
        end if;
        SET i =i-1;
      end loop;
      if (i=1) then SET v_qxSwjg = substr(swjg_dm,1,3); end if;
      --DBMS_OUTPUT.put_line('Result:' || v_qxSwjg);
    end;
  end if;
  if length(v_qxSwjg)<11 then
    SET v_qxSwjg =v_qxSwjg || '%';
  end if;
  return(v_qxSwjg);
END$$

DELIMITER ;
