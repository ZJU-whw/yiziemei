create or replace function FUNC_ZB_TSJHZX_HZB_INIT__BAK
(p_tszb_ny in varchar2,p_zbjg_dm in varchar2) return integer is
  zbHzbCnt number;
  v_syjzjhe number(16,2);
  v_bnljbltse number(16,2);
  v_bnljzhtse number(16,2);
  v_bnljxdjhe number(16,2);
  v_bnljjhwcl number(6,2);
  v_nd varchar(4);
  cursor mycursor is select zbjg_dm from dm_zbjg
         where yxbz='Y' and (p_zbjg_dm is null or zbjg_dm=p_zbjg_dm);
  v_zbjg varchar2(11);
begin
  -- 退税指标计划执行汇总表，记录创建
  if length(p_tszb_ny)<>6 then
    return -1;
  end if;

  open mycursor;
  loop
      fetch mycursor into v_zbjg;
      exit when mycursor%notfound;

      begin
        select count(*) into zbHzbCnt from zb_tsjhzx_hzb
          where zbjg_dm=v_zbjg and tszb_yn=p_tszb_ny ;
        EXCEPTION
        WHEN no_data_found THEN
          zbHzbCnt:=0;
      end;

      if  zbHzbCnt=0 then
        v_nd := substr(p_tszb_ny,1,4);
        --取上月结转
        begin
          select nvl(byjhye,0) into v_syjzjhe from
          (select byjhye from zb_tsjhzx_hzb
                 where zbjg_dm=v_zbjg and tszb_yn like v_nd || '%' order by tszb_yn desc
          )pt where rownum=1;
          EXCEPTION
          WHEN no_data_found THEN
            v_syjzjhe:=0;
        end;

        --取截止上月的累计
        select nvl(sum(byybltse),0),nvl(sum(byzhtse),0),nvl(sum(byxdjhe),0) into v_bnljbltse,v_bnljzhtse,v_bnljxdjhe
        from zb_tsjhzx_hzb
                 where zbjg_dm=v_zbjg and tszb_yn like v_nd || '%';

    --本年累计计划完成率
    v_bnljjhwcl := case when v_bnljxdjhe+v_bnljzhtse=0 then 0
      else round((v_bnljbltse)/(v_bnljxdjhe+v_bnljzhtse)*100,2) end;

        --插入本月记录
        insert into zb_tsjhzx_hzb(zbjg_dm,tszb_yn,syjzjhe,byjhze,byjhye,bnljbltse,bnljzhtse,bnljxdjhe,bnljjhwcl)
               values(v_zbjg,p_tszb_ny,v_syjzjhe,v_syjzjhe,v_syjzjhe,v_bnljbltse,v_bnljzhtse,v_bnljxdjhe,v_bnljjhwcl);
      end if;

  end loop;
  close mycursor;

  return 1;
end FUNC_ZB_TSJHZX_HZB_INIT__BAK;
/
