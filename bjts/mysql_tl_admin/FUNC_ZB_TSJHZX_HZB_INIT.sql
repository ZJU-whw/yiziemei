DELIMITER $$

DROP FUNCTION IF EXISTS FUNC_ZB_TSJHZX_HZB_INIT$$

CREATE function FUNC_ZB_TSJHZX_HZB_INIT
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


  DECLARE v_zbjg VARCHAR(11);

  -- 退税指标计划执行汇总表，记录创建
  if length(p_tszb_ny)<>6 then
    return -1;
  end if;

  BEGIN
  DECLARE BJTS_FETCH_DONE_001 BOOLEAN DEFAULT FALSE;
  DECLARE BJTS_FETCH_CURSOR_001 CURSOR FOR
select zbjg_dm from dm_zbjg
         where yxbz='Y' and (p_zbjg_dm is null or zbjg_dm=p_zbjg_dm);
  OPEN BJTS_FETCH_CURSOR_001;
  BJTS_FETCH_LOOP_001: LOOP
      BEGIN
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET BJTS_FETCH_DONE_001 = TRUE;
      FETCH BJTS_FETCH_CURSOR_001 INTO v_zbjg;
    END;
    IF BJTS_FETCH_DONE_001 THEN
      LEAVE BJTS_FETCH_LOOP_001;
    END IF;


      begin
  DECLARE BJTS_SQLCODE_002 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_002 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_002 = MYSQL_ERRNO, BJTS_SQLERRM_002 = MESSAGE_TEXT;
          SET zbHzbCnt =0;

  END;
select count(*) into zbHzbCnt from zb_tsjhzx_hzb
          where zbjg_dm=v_zbjg and tszb_yn=p_tszb_ny ;
        end;

      if  zbHzbCnt=0 then
        SET v_nd = substr(p_tszb_ny,1,4);
        -- 取上月结转
        begin
  DECLARE BJTS_SQLCODE_001 INT DEFAULT 0;
  DECLARE BJTS_SQLERRM_001 TEXT DEFAULT '';

  DECLARE EXIT HANDLER FOR NOT FOUND
  BEGIN
    GET DIAGNOSTICS CONDITION 1 BJTS_SQLCODE_001 = MYSQL_ERRNO, BJTS_SQLERRM_001 = MESSAGE_TEXT;
            SET v_syjzjhe =0;
            SET v_bnljbltse =0;
            SET v_bnljzhtse =0;
            SET v_bnljxdjhe =0;

  END;
select IFNULL(byjhye, 0),
                 IFNULL(byybltse, 0)+IFNULL(bnljbltse, 0),
                 IFNULL(byzhtse, 0)+IFNULL(bnljzhtse, 0),
                 IFNULL(byxdjhe, 0)+IFNULL(bnljxdjhe, 0)
          into v_syjzjhe,v_bnljbltse,v_bnljzhtse,v_bnljxdjhe from
          (select byjhye,byybltse,byzhtse,byxdjhe,bnljbltse,bnljzhtse,bnljxdjhe from zb_tsjhzx_hzb
                 where zbjg_dm=v_zbjg and tszb_yn like ORA_CONCAT(v_nd, '%') order by tszb_yn desc
          )pt where 1=1
LIMIT 1;
          end;

        -- 取截止上月的累计
/*        select nvl(sum(byybltse),0),nvl(sum(byzhtse),0),nvl(sum(byxdjhe),0) into v_bnljbltse,v_bnljzhtse,v_bnljxdjhe
        from zb_tsjhzx_hzb
                 where zbjg_dm=v_zbjg and tszb_yn like v_nd || '%';
*/
        -- 本年累计计划完成率
        SET v_bnljjhwcl = case when v_bnljxdjhe+v_bnljzhtse=0 then 0
                       else round((v_bnljbltse)/(v_bnljxdjhe+v_bnljzhtse)*100,2) end;

        -- 插入本月记录
        insert into zb_tsjhzx_hzb(zbjg_dm,tszb_yn,syjzjhe,byjhze,byjhye,bnljbltse,bnljzhtse,bnljxdjhe,bnljjhwcl)
               values(v_zbjg,p_tszb_ny,v_syjzjhe,v_syjzjhe,v_syjzjhe,v_bnljbltse,v_bnljzhtse,v_bnljxdjhe,v_bnljjhwcl);
      end if;


  END LOOP BJTS_FETCH_LOOP_001;
  CLOSE BJTS_FETCH_CURSOR_001;
END;

  return 1;
END$$

DELIMITER ;
