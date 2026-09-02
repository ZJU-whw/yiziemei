create or replace function FunC_StrSplit(p_value varchar2,p_split varchar2 := ',')
return strsplit_type pipelined is
  v_idx       integer;
  v_str       varchar2(500);
  v_strs_last varchar2(4000) := p_value;
begin
  loop
    if v_strs_last is null then exit; end if;
    v_idx := instr(v_strs_last, p_split);
    exit when v_idx = 0;
    v_str       := substr(v_strs_last, 1, v_idx - 1);
    v_strs_last := substr(v_strs_last, v_idx + 1);
    if v_str is not null then
      pipe row(v_str);
    end if;
  end loop;
  if v_strs_last is not null then pipe row(v_strs_last); end if;
  return;
end FunC_StrSplit;
/
