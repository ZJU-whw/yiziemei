DELIMITER $$

DROP FUNCTION IF EXISTS FUNC_ZB_TSJHZX_HZB_INIT__BAK$$

CREATE function FUNC_ZB_TSJHZX_HZB_INIT__BAK
(p_tszb_ny VARCHAR(4000),p_zbjg_dm VARCHAR(4000))
RETURNS integer
NOT DETERMINISTIC
MODIFIES SQL DATA
BEGIN
  DECLARE zbHzbCnt DECIMAL(38,10);
  DECLARE v_syjzjhe DECIMAL(16,2);
  DECLARE v_bnljbltse DECIMAL(16,2);
  DECLARE v_bnljzhtse DECIMAL(16,2);
  DECLARE v_bnljxdjhe DECIMAL(16,2);
  DECLARE v_bnljjhwcl DECIMAL(6,2);
  DECLARE v_nd varchar(4);
  DECLARE mycursor CURSOR FOR select zbjg_dm from dm_zbjg
         where yxbz='Y' and (p_zbjg_dm is null or zbjg_dm=p_zbjg_dm);
  DECLARE v_zbjg VARCHAR(11);

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
          SET zbHzbCnt =0;
      end;

      if  zbHzbCnt=0 then
        SET v_nd = substr(p_tszb_ny,1,4);
        --取上月结转
        begin
          select IFNULL(byjhye, 0) into v_syjzjhe from
          (select byjhye from zb_tsjhzx_hzb
                 where zbjg_dm=v_zbjg and tszb_yn like v_nd || '%' order by tszb_yn desc
          )pt where rownum=1;
          EXCEPTION
          WHEN no_data_found THEN
            SET v_syjzjhe =0;
        end;

        --取截止上月的累计
        select IFNULL(sum(byybltse), 0),IFNULL(sum(byzhtse), 0),IFNULL(sum(byxdjhe), 0) into v_bnljbltse,v_bnljzhtse,v_bnljxdjhe
        from zb_tsjhzx_hzb
                 where zbjg_dm=v_zbjg and tszb_yn like v_nd || '%';

    --本年累计计划完成率
    SET v_bnljjhwcl = case when v_bnljxdjhe+v_bnljzhtse=0 then 0
      else round((v_bnljbltse)/(v_bnljxdjhe+v_bnljzhtse)*100,2) end;

        --插入本月记录
        insert into zb_tsjhzx_hzb(zbjg_dm,tszb_yn,syjzjhe,byjhze,byjhye,bnljbltse,bnljzhtse,bnljxdjhe,bnljjhwcl)
               values(v_zbjg,p_tszb_ny,v_syjzjhe,v_syjzjhe,v_syjzjhe,v_bnljbltse,v_bnljzhtse,v_bnljxdjhe,v_bnljjhwcl);
      end if;

  end loop;
  close mycursor;

  return 1;
END$$

DELIMITER ;
