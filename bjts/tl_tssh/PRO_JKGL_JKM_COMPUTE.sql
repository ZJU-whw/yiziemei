create or replace procedure PRO_JKGL_JKM_COMPUTE(
  p_djxh  in VARCHAR2,
  p_tsjsfs in VARCHAR2,
  p_swjg in VARCHAR2
) AS
/*
 * 单户企业健康码结果计算
 */

  --定义变量

  --指标分转健康码分的折算比例
  zsblv1 number(18,2);
  zsblv2 number(18,2);
  zsblv3 number(18,2);
  zsblv4 number(18,2);
  zsblv5 number(18,2);
  zsblv6 number(18,2);

  --六个分类的红线
  lineRed1 int;
  lineRed2 int;
  lineRed3 int;
  lineRed4 int;
  lineRed5 int;
  lineRed6 int;
  --六个分类的黄线
  lineYellow1 int;
  lineYellow2 int;
  lineYellow3 int;
  lineYellow4 int;
  lineYellow5 int;
  lineYellow6 int;

  lineRed_Zh integer;          --综合红线
  lineYellow_Zh integer;       --综合黄线

  --实际指标赋分
  zb_SCORE1 int;
  zb_SCORE2 int;
  zb_SCORE3 int;
  zb_SCORE4 int;
  zb_SCORE5 int;
  zb_SCORE6 int;

  --折算后的分数
  jk_SCORE1 int;
  jk_SCORE2 int;
  jk_SCORE3 int;
  jk_SCORE4 int;
  jk_SCORE5 int;
  jk_SCORE6 int;
  jk_SCORE_ZH integer;          ---折算后健康码综合赋分

  --健康码结果  1绿  2黄 3红
  V_level char(1);
  V_note varchar2(200);
begin

/*  -- 指标结果尚处于计算或赋分过程中，暂不能计算健康码结果
  select count1 into v_cnt
    from tl_tssh.jkgl_data_zb_jgb t
    where djxh=p_djxh and t.js_status='0' and t.ff_status='0' and rownum=1;
  if v_cnt > 0 then
    return;
  end if;
*/
  V_note:='';

  BEGIN

    --从健康码配置表，计算折算比率
    /*
    select
      sum(decode (ywfl_dm,'10',case when ZB_TOTAL=0 then 0 else JKM_TOTAL/ZB_TOTAL end,0)),
      sum(decode (ywfl_dm,'20',case when ZB_TOTAL=0 then 0 else JKM_TOTAL/ZB_TOTAL end,0)),
      sum(decode (ywfl_dm,'30',case when ZB_TOTAL=0 then 0 else JKM_TOTAL/ZB_TOTAL end,0)),
      sum(decode (ywfl_dm,'40',case when ZB_TOTAL=0 then 0 else JKM_TOTAL/ZB_TOTAL end,0)),
      sum(decode (ywfl_dm,'50',case when ZB_TOTAL=0 then 0 else JKM_TOTAL/ZB_TOTAL end,0)),
      sum(decode (ywfl_dm,'60',case when ZB_TOTAL=0 then 0 else JKM_TOTAL/ZB_TOTAL end,0)),
      sum(decode (ywfl_dm,'10',line_red,0)),
      sum(decode (ywfl_dm,'20',line_red,0)),
      sum(decode (ywfl_dm,'30',line_red,0)),
      sum(decode (ywfl_dm,'40',line_red,0)),
      sum(decode (ywfl_dm,'50',line_red,0)),
      sum(decode (ywfl_dm,'60',line_red,0)),
      sum(decode (ywfl_dm,'ZH',line_red,0)),
      sum(decode (ywfl_dm,'10',line_yellow,0)),
      sum(decode (ywfl_dm,'20',line_yellow,0)),
      sum(decode (ywfl_dm,'30',line_yellow,0)),
      sum(decode (ywfl_dm,'40',line_yellow,0)),
      sum(decode (ywfl_dm,'50',line_yellow,0)),
      sum(decode (ywfl_dm,'60',line_yellow,0)),
      sum(decode (ywfl_dm,'ZH',line_yellow,0))
    into zsblv1,zsblv2,zsblv3,zsblv4,zsblv5,zsblv6,
         lineRed1,lineRed2,lineRed3,lineRed4,lineRed5,lineRed6,lineRed_Zh,
         lineYellow1,lineYellow2,lineYellow3,lineYellow4,lineYellow5,lineYellow6,lineYellow_Zh
    from tl_tssh.jkgl_pz_jkm t
    where t.tsjsfs=p_tsjsfs ;
    */

    with TT as (
    select zb.ywfl_dm, sum(score) as zbScore
    from
      tl_tssh.jkgl_pz_zb zb left join
      (
      select t.zb_id,max(nvl(s.score,t.score)) as score
      from
      tl_tssh.jkgl_pz_zb_ycff t
      left join tl_tssh.jkgl_pz_zb_ycff_swjg s
           on s.swjg_dm =p_swjg
           and s.zb_id=t.zb_id and s.xh=t.xh and s.yxbz='Y'
      where t.yxbz='Y'
      group by t.zb_id
      ) pt on pt.zb_id=zb.zb_id
    where
      zb.yxbz='Y' and
      zb.apply_qy=p_tsjsfs
      group by zb.ywfl_dm
    )
    select
     sum(decode (jkm.ywfl_dm,'10',case when nvl(TT.zbScore,0)=0 then 0 else JKM_TOTAL/nvl(TT.zbScore,0) end,0)),
      sum(decode (jkm.ywfl_dm,'20',case when nvl(TT.zbScore,0)=0 then 0 else JKM_TOTAL/nvl(TT.zbScore,0) end,0)),
      sum(decode (jkm.ywfl_dm,'30',case when nvl(TT.zbScore,0)=0 then 0 else JKM_TOTAL/nvl(TT.zbScore,0) end,0)),
      sum(decode (jkm.ywfl_dm,'40',case when nvl(TT.zbScore,0)=0 then 0 else JKM_TOTAL/nvl(TT.zbScore,0) end,0)),
      sum(decode (jkm.ywfl_dm,'50',case when nvl(TT.zbScore,0)=0 then 0 else JKM_TOTAL/nvl(TT.zbScore,0) end,0)),
      sum(decode (jkm.ywfl_dm,'60',case when nvl(TT.zbScore,0)=0 then 0 else JKM_TOTAL/nvl(TT.zbScore,0) end,0)),
      sum(decode (jkm.ywfl_dm,'10',line_red,0)),
      sum(decode (jkm.ywfl_dm,'20',line_red,0)),
      sum(decode (jkm.ywfl_dm,'30',line_red,0)),
      sum(decode (jkm.ywfl_dm,'40',line_red,0)),
      sum(decode (jkm.ywfl_dm,'50',line_red,0)),
      sum(decode (jkm.ywfl_dm,'60',line_red,0)),
      sum(decode (jkm.ywfl_dm,'ZH',line_red,0)),
      sum(decode (jkm.ywfl_dm,'10',line_yellow,0)),
      sum(decode (jkm.ywfl_dm,'20',line_yellow,0)),
      sum(decode (jkm.ywfl_dm,'30',line_yellow,0)),
      sum(decode (jkm.ywfl_dm,'40',line_yellow,0)),
      sum(decode (jkm.ywfl_dm,'50',line_yellow,0)),
      sum(decode (jkm.ywfl_dm,'60',line_yellow,0)),
      sum(decode (jkm.ywfl_dm,'ZH',line_yellow,0))
    into zsblv1,zsblv2,zsblv3,zsblv4,zsblv5,zsblv6,
         lineRed1,lineRed2,lineRed3,lineRed4,lineRed5,lineRed6,lineRed_Zh,
         lineYellow1,lineYellow2,lineYellow3,lineYellow4,lineYellow5,lineYellow6,lineYellow_Zh
    from tl_tssh.jkgl_pz_jkm jkm
    left join TT on TT.ywfl_dm=jkm.ywfl_dm
    where jkm.tsjsfs=p_tsjsfs ;


    -- 获取该纳税人的指标赋分
    select
        nvl(sum(decode (ywfl_dm,'10',score,0)),0),
        nvl(sum(decode (ywfl_dm,'20',score,0)),0),
        nvl(sum(decode (ywfl_dm,'30',score,0)),0),
        nvl(sum(decode (ywfl_dm,'40',score,0)),0),
        nvl(sum(decode (ywfl_dm,'50',score,0)),0),
        nvl(sum(decode (ywfl_dm,'60',score,0)),0)
    into zb_SCORE1,zb_SCORE2,zb_SCORE3,zb_SCORE4,zb_SCORE5,zb_SCORE6
    from (
    select s.ywfl_dm,
      --   sum(t.score) as score
        sum(case when (k.fmyxq is null OR k.fmyxq>=trunc(sysdate)) and nvl(t.hcjg,'2')='1' then 0 else t.score end) as score
        from
        tl_tssh.jkgl_data_qyjkm_jgb k
        inner join tl_tssh.jkgl_data_zb_jgb t on t.djxh=k.djxh
        inner join tl_tssh.jkgl_pz_zb s on t.zb_id=s.zb_id and s.yxbz='Y'
        where t.djxh=p_djxh
        group by s.ywfl_dm
    );

    --计算健康码折算赋分
    jk_SCORE1 := zb_SCORE1 * zsblv1;
    jk_SCORE2 := zb_SCORE2 * zsblv2;
    jk_SCORE3 := zb_SCORE3 * zsblv3;
    jk_SCORE4 := zb_SCORE4 * zsblv4;
    jk_SCORE5 := zb_SCORE5 * zsblv5;
    jk_SCORE6 := zb_SCORE6 * zsblv6;
    jk_SCORE_ZH := jk_SCORE1+jk_SCORE2+jk_SCORE3+jk_SCORE4+jk_SCORE5+jk_SCORE6;

    if (lineRed_Zh<>0 and jk_SCORE_ZH >= lineRed_Zh)
      OR (lineRed1<>0 and jk_SCORE1 >= lineRed1)
      OR (lineRed2<>0 and jk_SCORE2 >= lineRed2)
      OR (lineRed3<>0 and jk_SCORE3 >= lineRed3)
      OR (lineRed4<>0 and jk_SCORE4 >= lineRed4)
      OR (lineRed5<>0 and jk_SCORE5 >= lineRed5)
      OR (lineRed6<>0 and jk_SCORE6 >= lineRed6)
    then
      V_level := '3';

      if (lineRed_Zh<>0 and jk_SCORE_ZH >= lineRed_Zh) then
        V_note:=V_note||'综合,';
      end if;
      if (lineRed1<>0 and jk_SCORE1 >= lineRed1) then
        V_note:=V_note||'信用,';
      end if;
      if (lineRed2<>0 and jk_SCORE2 >= lineRed2) then
        V_note:=V_note||'退税,';
      end if;
      if (lineRed3<>0 and jk_SCORE3 >= lineRed3) then
        V_note:=V_note||'出口,';
      end if;
      if (lineRed4<>0 and jk_SCORE4 >= lineRed4) then
        V_note:=V_note||'发票,';
      end if;
      if (lineRed5<>0 and jk_SCORE5 >= lineRed5) then
        V_note:=V_note||'财务,';
      end if;
      if (lineRed6<>0 and jk_SCORE6 >= lineRed6) then
        V_note:=V_note||'其他,';
      end if;

    else
      if (lineYellow_Zh<>0 and jk_SCORE_ZH >= lineYellow_Zh)
        OR (lineYellow1<>0 and jk_SCORE1 >= lineYellow1)
        OR (lineYellow2<>0 and jk_SCORE2 >= lineYellow2)
        OR (lineYellow3<>0 and jk_SCORE3 >= lineYellow3)
        OR (lineYellow4<>0 and jk_SCORE4 >= lineYellow4)
        OR (lineYellow5<>0 and jk_SCORE5 >= lineYellow5)
        OR (lineYellow6<>0 and jk_SCORE6 >= lineYellow6)
      then
        V_level := '2';
        if (lineYellow_Zh<>0 and jk_SCORE_ZH >= lineYellow_Zh) then
          V_note:=V_note||'综合,';
        end if;
        if (lineYellow1<>0 and jk_SCORE1 >= lineYellow1) then
          V_note:=V_note||'信用,';
        end if;
        if (lineYellow2<>0 and jk_SCORE2 >= lineYellow2) then
          V_note:=V_note||'退税,';
        end if;
        if (lineYellow3<>0 and jk_SCORE3 >= lineYellow3) then
          V_note:=V_note||'出口,';
        end if;
        if (lineYellow4<>0 and jk_SCORE4 >= lineYellow4) then
          V_note:=V_note||'发票,';
        end if;
        if (lineYellow5<>0 and jk_SCORE5 >= lineYellow5) then
          V_note:=V_note||'财务,';
        end if;
        if (lineYellow6<>0 and jk_SCORE6 >= lineYellow6) then
          V_note:=V_note||'其他,';
        end if;
      else
        V_level:='1';
      end if;
    end if;

    -- 保存健康码计算结果
    update tl_tssh.jkgl_data_qyjkm_jgb
      set jkm_level=V_level,
      score_10 = jk_SCORE1,
      score_20 = jk_SCORE2,
      score_30 = jk_SCORE3,
      score_40 = jk_SCORE4,
      score_50 = jk_SCORE5,
      score_60 = jk_SCORE6,
      score_ZH = jk_SCORE_ZH,
      uptime = sysdate,
      note = V_note
      where djxh = p_djxh;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      dbms_output.put_line('【健康码】等级评定：'||sqlerrm);
      ROLLBACK;
      RAISE_APPLICATION_ERROR(-20001,'【健康码】等级评定：'||P_djxh);
  END;

  return;
end PRO_JKGL_JKM_COMPUTE;
/
