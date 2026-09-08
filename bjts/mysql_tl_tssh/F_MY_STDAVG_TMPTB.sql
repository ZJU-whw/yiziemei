DELIMITER $$

DROP PROCEDURE IF EXISTS F_MY_STDAVG_TMPTB$$

CREATE PROCEDURE F_MY_STDAVG_TMPTB(p_datasql VARCHAR(4000), OUT P_RESULT DECIMAL(38,10))
routine_body: BEGIN
--计算一组数据的标准值
--区别于算数平均值，是一组数中剔除和标准差偏离较大的坏点后，再取平均值
-- 输入数据组的脚本示例如下，对象必须别名为obj
-- 示例：select zb_total as obj from jkgl_pz_jkm
-- 示例：select to_number(zb_val) as obj from tl_tssh.jkgl_data_zb_jgb where zb_val is not null and zb_val<>0
-- select zb_val as obj from jkgl_data_tj_zb t where zb_id='W50202' and t.bgqid in (select bgqid from jkgl_data_bgq b,glxt_bb_shxt_djxx d where b.djxh=d.djxh_js and d.jsmode='2' and b.bgq_q=date'2019-01-01')
  DECLARE v_tmpSql VARCHAR(2000);
  DECLARE v_stddev DECIMAL(18,2);
  DECLARE v_avg DECIMAL(18,2);
  DECLARE v_deeps integer;--嵌套计算深度
  DECLARE v_id integer;
  DECLARE v_tablecnt integer;

  --创建临时表
  SET v_tmpSql ='select count(1) from user_tables where table_name=''TMP_STDDEV''';
  EXECUTE IMMEDIATE v_tmpSql into v_tablecnt;
  if v_tablecnt>0 then
    SET v_tmpSql ='drop table TMP_STDDEV';
    EXECUTE IMMEDIATE v_tmpSql;
  end if;

  SET v_tmpSql ='CREATE GLOBAL TEMPORARY TABLE TMP_STDDEV (id INTEGER,val NUMBER(18,2),ybbz CHAR(1)) ON COMMIT DELETE ROWS';
  EXECUTE IMMEDIATE v_tmpSql;

--  v_tmpSql:='select nvl(max(id),0) from tmp_stddev';
--  EXECUTE IMMEDIATE v_tmpSql into v_id ;
--  v_id := v_id + 1;
  SET v_id =1;
  SET v_deeps =0;


  --首先，将数组写入临时表
  SET v_tmpSql = 'insert into tmp_stddev(id,val,ybbz) '
           || ' select ' || v_id || ',obj,''1'' from (' || p_datasql || ')' ;
  EXECUTE IMMEDIATE v_tmpSql;

  IF ROW_COUNT() = 0 THEN
    SET v_avg =null;
  ELSE
    LOOP Exit When(v_deeps>3);
      SET v_deeps =v_deeps+1;
      --计算标准差
      SET v_tmpSql ='select stddev(val) from tmp_stddev where id=' || v_id || ' and ybbz=''1''';
      EXECUTE IMMEDIATE v_tmpSql into v_stddev;
      --计算平均值
      SET v_tmpSql ='select avg(val) from tmp_stddev where id=' || v_id || ' and ybbz=''1''';
      EXECUTE IMMEDIATE v_tmpSql into v_avg ;

      if IFNULL(v_stddev, 0) = 0 OR IFNULL(v_avg, 0)=0 then
        Exit;
      end if;

      --和平均值的偏差 和标准差相比，偏差在一倍以上的剔除掉。
      SET v_tmpSql ='update tmp_stddev t set ybbz=''0'' where id=' || v_id || ' and '
                 || ' abs(t.val - ' || v_avg ||')/' || v_stddev ||' > 2 and ybbz=''1''' ;
      EXECUTE IMMEDIATE v_tmpSql;
      if (ROW_COUNT() = 0) then
        Exit;
      end if;
    END LOOP;

    SET v_tmpSql ='select avg(val) from tmp_stddev where id=' || v_id || ' and ybbz=''1''';
    EXECUTE IMMEDIATE v_tmpSql into v_avg ;
  END IF;
  
--  delete from tmp_stddev where id=v_id;
  SET v_tmpSql ='DROP TABLE TMP_STDDEV';
  EXECUTE IMMEDIATE v_tmpSql;

  return(v_avg);
END$$

DELIMITER ;
