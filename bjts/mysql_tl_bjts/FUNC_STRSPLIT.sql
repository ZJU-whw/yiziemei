DELIMITER $$

DROP PROCEDURE IF EXISTS FUNC_STRSPLIT$$

CREATE PROCEDURE FunC_StrSplit(p_value VARCHAR(4000),p_split VARCHAR(4000) := ',')
routine_body: BEGIN
  DECLARE v_idx       integer;
  DECLARE v_str       VARCHAR(500);
  DECLARE v_strs_last VARCHAR(4000) DEFAULT p_value;

  loop
    if v_strs_last is null then exit; end if;
    SET v_idx = instr(v_strs_last, p_split);
    exit when v_idx = 0;
    SET v_str = substr(v_strs_last, 1, v_idx - 1);
    SET v_strs_last = substr(v_strs_last, v_idx + 1);
    if v_str is not null then
      pipe row(v_str);
    end if;
  end loop;
  if v_strs_last is not null then pipe row(v_strs_last); end if;
  LEAVE routine_body;
END$$

DELIMITER ;
