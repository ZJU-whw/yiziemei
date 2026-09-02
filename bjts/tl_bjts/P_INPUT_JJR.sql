create or replace procedure p_input_jjr
as
  date_tjrq date;
begin
  date_tjrq := to_date('2025-01-01','yyyy-mm-dd');
  loop
    exit when date_tjrq >= to_date('2026-01-01','yyyy-mm-dd');
    DBMS_OUTPUT.put_line(to_char(date_tjrq,'yyyy-mm-dd'));
    date_tjrq := next_day(date_tjrq, 'SATURDAY');
    insert into PUB_JJR(jjr_ssnd, jjr_date, memo)
    values('2025',date_tjrq,'ÐÇÆÚÁù');
    date_tjrq := next_day(date_tjrq, 'SUNDAY');
    insert into PUB_JJR(jjr_ssnd, jjr_date, memo)
    values('2025',date_tjrq,'ÐÇÆÚÈÕ');
    commit;
  end loop;
end;
/
