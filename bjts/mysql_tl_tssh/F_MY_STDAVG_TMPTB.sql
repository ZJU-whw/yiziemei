DELIMITER $$

DROP PROCEDURE IF EXISTS F_MY_STDAVG_TMPTB$$

CREATE PROCEDURE F_MY_STDAVG_TMPTB(p_datasql VARCHAR(4000), OUT P_RESULT DECIMAL(38,10))
routine_body: BEGIN
-- 计算一组数据的标准值
-- 区别于算数平均值，是一组数中剔除和标准差偏离较大的坏点后，再取平均值
-- 输入数据组的脚本示例如下，对象必须别名为obj
-- 示例：select zb_total as obj from jkgl_pz_jkm
-- 示例：select to_number(zb_val) as obj from tl_tssh.jkgl_data_zb_jgb where zb_val is not null and zb_val<>0
-- select zb_val as obj from jkgl_data_tj_zb t where zb_id='W50202' and t.bgqid in (select bgqid from jkgl_data_bgq b,glxt_bb_shxt_djxx d where b.djxh=d.djxh_js and d.jsmode='2' and b.bgq_q=date'2019-01-01')
  DECLARE v_tmpSql VARCHAR(2000);
  DECLARE v_stddev DECIMAL(18,2);
  DECLARE v_avg DECIMAL(18,2);
  DECLARE v_deeps integer;-- 嵌套计算深度
  DECLARE v_id integer;
  DECLARE v_tablecnt integer;

  -- 创建临时表
  SET v_tmpSql ='SELECT 1';
  SET @BJTS_DYNAMIC_OUT_001_001 = NULL;
SET @BJTS_DYNAMIC_SQL_001 = CONCAT(TRIM(TRAILING ';' FROM v_tmpSql), ' INTO @BJTS_DYNAMIC_OUT_001_001');
PREPARE BJTS_DYNAMIC_STMT_001 FROM @BJTS_DYNAMIC_SQL_001;
EXECUTE BJTS_DYNAMIC_STMT_001;
DEALLOCATE PREPARE BJTS_DYNAMIC_STMT_001;
SET v_tablecnt = @BJTS_DYNAMIC_OUT_001_001;
  if v_tablecnt>0 then
    SET v_tmpSql ='DROP TEMPORARY TABLE IF EXISTS TMP_STDDEV';
    SET @BJTS_DYNAMIC_SQL_002 = v_tmpSql;
PREPARE BJTS_DYNAMIC_STMT_002 FROM @BJTS_DYNAMIC_SQL_002;
EXECUTE BJTS_DYNAMIC_STMT_002;
DEALLOCATE PREPARE BJTS_DYNAMIC_STMT_002;
  end if;

  SET v_tmpSql ='CREATE TEMPORARY TABLE TMP_STDDEV (id INTEGER,val DECIMAL(18,2),ybbz CHAR(1))';
  SET @BJTS_DYNAMIC_SQL_003 = v_tmpSql;
PREPARE BJTS_DYNAMIC_STMT_003 FROM @BJTS_DYNAMIC_SQL_003;
EXECUTE BJTS_DYNAMIC_STMT_003;
DEALLOCATE PREPARE BJTS_DYNAMIC_STMT_003;

--  v_tmpSql:='select nvl(max(id),0) from tmp_stddev';
--  EXECUTE IMMEDIATE v_tmpSql into v_id ;
--  v_id := v_id + 1;
  SET v_id =1;
  SET v_deeps =0;


  -- 首先，将数组写入临时表
  SET v_tmpSql = ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('insert into tmp_stddev(id,val,ybbz) ', ' select '), v_id), ',obj,''1'' from ('), p_datasql), ')') ;
  SET @BJTS_DYNAMIC_SQL_004 = v_tmpSql;
PREPARE BJTS_DYNAMIC_STMT_004 FROM @BJTS_DYNAMIC_SQL_004;
EXECUTE BJTS_DYNAMIC_STMT_004;
DEALLOCATE PREPARE BJTS_DYNAMIC_STMT_004;

  IF ROW_COUNT() = 0 THEN
    SET v_avg =null;
  ELSE
    BJTS_LOOP_001: LOOP IF (v_deeps>3) THEN LEAVE BJTS_LOOP_001; END IF;
      SET v_deeps =v_deeps+1;
      -- 计算标准差
      SET v_tmpSql =ORA_CONCAT(ORA_CONCAT('select stddev(val) from tmp_stddev where id=', v_id), ' and ybbz=''1''');
      SET @BJTS_DYNAMIC_OUT_005_001 = NULL;
SET @BJTS_DYNAMIC_SQL_005 = CONCAT(TRIM(TRAILING ';' FROM v_tmpSql), ' INTO @BJTS_DYNAMIC_OUT_005_001');
PREPARE BJTS_DYNAMIC_STMT_005 FROM @BJTS_DYNAMIC_SQL_005;
EXECUTE BJTS_DYNAMIC_STMT_005;
DEALLOCATE PREPARE BJTS_DYNAMIC_STMT_005;
SET v_stddev = @BJTS_DYNAMIC_OUT_005_001;
      -- 计算平均值
      SET v_tmpSql =ORA_CONCAT(ORA_CONCAT('select avg(val) from tmp_stddev where id=', v_id), ' and ybbz=''1''');
      SET @BJTS_DYNAMIC_OUT_006_001 = NULL;
SET @BJTS_DYNAMIC_SQL_006 = CONCAT(TRIM(TRAILING ';' FROM v_tmpSql), ' INTO @BJTS_DYNAMIC_OUT_006_001');
PREPARE BJTS_DYNAMIC_STMT_006 FROM @BJTS_DYNAMIC_SQL_006;
EXECUTE BJTS_DYNAMIC_STMT_006;
DEALLOCATE PREPARE BJTS_DYNAMIC_STMT_006;
SET v_avg = @BJTS_DYNAMIC_OUT_006_001;

      if IFNULL(v_stddev, 0) = 0 OR IFNULL(v_avg, 0)=0 then
        LEAVE BJTS_LOOP_001;
      end if;

      -- 和平均值的偏差 和标准差相比，偏差在一倍以上的剔除掉。
      SET v_tmpSql =ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT(ORA_CONCAT('update tmp_stddev t set ybbz=''0'' where id=', v_id), ' and '), ' abs(t.val - '), v_avg), ')/'), v_stddev), ' > 2 and ybbz=''1''') ;
      SET @BJTS_DYNAMIC_SQL_007 = v_tmpSql;
PREPARE BJTS_DYNAMIC_STMT_007 FROM @BJTS_DYNAMIC_SQL_007;
EXECUTE BJTS_DYNAMIC_STMT_007;
DEALLOCATE PREPARE BJTS_DYNAMIC_STMT_007;
      if (ROW_COUNT() = 0) then
        LEAVE BJTS_LOOP_001;
      end if;
    END LOOP BJTS_LOOP_001;

    SET v_tmpSql =ORA_CONCAT(ORA_CONCAT('select avg(val) from tmp_stddev where id=', v_id), ' and ybbz=''1''');
    SET @BJTS_DYNAMIC_OUT_008_001 = NULL;
SET @BJTS_DYNAMIC_SQL_008 = CONCAT(TRIM(TRAILING ';' FROM v_tmpSql), ' INTO @BJTS_DYNAMIC_OUT_008_001');
PREPARE BJTS_DYNAMIC_STMT_008 FROM @BJTS_DYNAMIC_SQL_008;
EXECUTE BJTS_DYNAMIC_STMT_008;
DEALLOCATE PREPARE BJTS_DYNAMIC_STMT_008;
SET v_avg = @BJTS_DYNAMIC_OUT_008_001;
  END IF;

--  delete from tmp_stddev where id=v_id;
  SET v_tmpSql ='DROP TEMPORARY TABLE IF EXISTS TMP_STDDEV';
  SET @BJTS_DYNAMIC_SQL_009 = v_tmpSql;
PREPARE BJTS_DYNAMIC_STMT_009 FROM @BJTS_DYNAMIC_SQL_009;
EXECUTE BJTS_DYNAMIC_STMT_009;
DEALLOCATE PREPARE BJTS_DYNAMIC_STMT_009;

  SET P_RESULT = (v_avg); LEAVE routine_body;
END$$

DELIMITER ;
