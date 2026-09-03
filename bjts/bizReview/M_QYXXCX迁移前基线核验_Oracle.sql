/*
  文件：M_QYXXCX迁移前基线核验_Oracle.sql
  用途：在 Oracle 迁移前，对 M_QYXXCX 企业信息一户式查询涉及的核心表、
        字典和列表配置形成聚合基线。

  安全约束：
  1. 本脚本只有 SELECT 和 SQL*Plus 展示指令，不修改业务数据。
  2. 输出不包含企业名称、识别号、身份证、电话、地址、银行账号等明细值。
  3. 请由 DBA 在批准的账号、时间窗和一致性快照中执行；将执行时间、数据库、
     SCN/备份点、脚本 Git 版本和输出文件一并归档。
  4. TL_TSSH、TL_ADMIN 跨 schema 查询需要相应只读权限。某一节无权限时应记录，
     不得以“跳过”代替补证。
  5. 本脚本未在生产数据库执行；SQL 审核和结果解释仍需 DBA/业务负责人确认。
*/

SET ECHO ON
SET FEEDBACK ON
SET VERIFY OFF
SET PAGESIZE 50000
SET LINESIZE 260
SET TRIMSPOOL ON
SET TAB OFF
SET NULL '<NULL>'

PROMPT ================================================================
PROMPT B00 执行上下文（归档时另补一致性 SCN/备份点）
PROMPT ================================================================

SELECT 'B00' AS check_id,
       SYS_CONTEXT('USERENV', 'DB_NAME') AS database_name,
       SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS current_schema,
       SYSTIMESTAMP AS executed_at
  FROM dual;

PROMPT ================================================================
PROMPT B01 核心表总量、备案日期范围
PROMPT 注意：SQ_DATE 是业务备案日期，不是 ETL 装载时间，不能代表数据新鲜度。
PROMPT ================================================================

SELECT 'B01' AS check_id,
       COUNT(*) AS total_rows,
       MIN(sq_date) AS min_sq_date,
       MAX(sq_date) AS max_sq_date,
       SUM(CASE WHEN sq_date IS NULL THEN 1 ELSE 0 END) AS null_sq_date_rows
  FROM TL_TSSH.GLXT_BB_SHXT_DJXX;

PROMPT ================================================================
PROMPT B02 关键身份字段空值与基数
PROMPT ================================================================

SELECT 'B02' AS check_id,
       COUNT(*) AS total_rows,
       SUM(CASE WHEN cpcode IS NULL THEN 1 ELSE 0 END) AS null_cpcode,
       COUNT(DISTINCT cpcode) AS distinct_cpcode,
       SUM(CASE WHEN djxh_js IS NULL THEN 1 ELSE 0 END) AS null_djxh_js,
       COUNT(DISTINCT djxh_js) AS distinct_djxh_js,
       SUM(CASE WHEN nsrdjno IS NULL THEN 1 ELSE 0 END) AS null_nsrdjno,
       COUNT(DISTINCT nsrdjno) AS distinct_nsrdjno,
       SUM(CASE WHEN shxyno IS NULL THEN 1 ELSE 0 END) AS null_shxyno,
       COUNT(DISTINCT shxyno) AS distinct_shxyno,
       SUM(CASE WHEN qyhgdm IS NULL THEN 1 ELSE 0 END) AS null_qyhgdm,
       COUNT(DISTINCT qyhgdm) AS distinct_qyhgdm
  FROM TL_TSSH.GLXT_BB_SHXT_DJXX;

PROMPT ================================================================
PROMPT B03 页面长度限制与数据库现存长度的冲突基线
PROMPT 页面：QYHGDM<=10、SHXY_NO<=21、NAME<=30；DDL：32、20、200。
PROMPT ================================================================

SELECT 'B03' AS check_id,
       MAX(LENGTH(qyhgdm)) AS max_qyhgdm_len,
       SUM(CASE WHEN LENGTH(qyhgdm) > 10 THEN 1 ELSE 0 END) AS qyhgdm_over_ui_limit,
       MAX(LENGTH(shxyno)) AS max_shxyno_len,
       SUM(CASE WHEN LENGTH(shxyno) > 20 THEN 1 ELSE 0 END) AS shxyno_over_ddl_len_20,
       MAX(LENGTH(nsrmc)) AS max_nsrmc_len,
       SUM(CASE WHEN LENGTH(nsrmc) > 30 THEN 1 ELSE 0 END) AS nsrmc_over_ui_limit
  FROM TL_TSSH.GLXT_BB_SHXT_DJXX;

PROMPT ================================================================
PROMPT B04 候选键重复摘要（仅输出重复组数和行数，不输出键值）
PROMPT excess_rows 表示每组保留一行后多出的行数。
PROMPT ================================================================

SELECT 'B04_CPCODE' AS check_id,
       COUNT(*) AS duplicated_values,
       NVL(SUM(cnt), 0) AS duplicated_rows,
       NVL(SUM(cnt - 1), 0) AS excess_rows
  FROM (
        SELECT cpcode, COUNT(*) AS cnt
          FROM TL_TSSH.GLXT_BB_SHXT_DJXX
         WHERE cpcode IS NOT NULL
         GROUP BY cpcode
        HAVING COUNT(*) > 1
       );

SELECT 'B04_DJXH_JS' AS check_id,
       COUNT(*) AS duplicated_values,
       NVL(SUM(cnt), 0) AS duplicated_rows,
       NVL(SUM(cnt - 1), 0) AS excess_rows
  FROM (
        SELECT djxh_js, COUNT(*) AS cnt
          FROM TL_TSSH.GLXT_BB_SHXT_DJXX
         WHERE djxh_js IS NOT NULL
         GROUP BY djxh_js
        HAVING COUNT(*) > 1
       );

SELECT 'B04_NSRDJNO_DETAIL_API_KEY' AS check_id,
       COUNT(*) AS duplicated_values,
       NVL(SUM(cnt), 0) AS duplicated_rows,
       NVL(SUM(cnt - 1), 0) AS excess_rows
  FROM (
        SELECT nsrdjno, COUNT(*) AS cnt
          FROM TL_TSSH.GLXT_BB_SHXT_DJXX
         WHERE nsrdjno IS NOT NULL
         GROUP BY nsrdjno
        HAVING COUNT(*) > 1
       );

SELECT 'B04_SHXYNO' AS check_id,
       COUNT(*) AS duplicated_values,
       NVL(SUM(cnt), 0) AS duplicated_rows,
       NVL(SUM(cnt - 1), 0) AS excess_rows
  FROM (
        SELECT shxyno, COUNT(*) AS cnt
          FROM TL_TSSH.GLXT_BB_SHXT_DJXX
         WHERE shxyno IS NOT NULL
         GROUP BY shxyno
        HAVING COUNT(*) > 1
       );

SELECT 'B04_QYHGDM' AS check_id,
       COUNT(*) AS duplicated_values,
       NVL(SUM(cnt), 0) AS duplicated_rows,
       NVL(SUM(cnt - 1), 0) AS excess_rows
  FROM (
        SELECT qyhgdm, COUNT(*) AS cnt
          FROM TL_TSSH.GLXT_BB_SHXT_DJXX
         WHERE qyhgdm IS NOT NULL
         GROUP BY qyhgdm
        HAVING COUNT(*) > 1
       );

SELECT 'B04_CPCODE_DJXH_JS' AS check_id,
       COUNT(*) AS duplicated_values,
       NVL(SUM(cnt), 0) AS duplicated_rows,
       NVL(SUM(cnt - 1), 0) AS excess_rows
  FROM (
        SELECT cpcode, djxh_js, COUNT(*) AS cnt
          FROM TL_TSSH.GLXT_BB_SHXT_DJXX
         WHERE cpcode IS NOT NULL OR djxh_js IS NOT NULL
         GROUP BY cpcode, djxh_js
        HAVING COUNT(*) > 1
       );

PROMPT ================================================================
PROMPT B05 主要分类代码分布（用于冻结 Oracle 码值及空值语义）
PROMPT ================================================================

SELECT field_name, field_value, row_count
  FROM (
        SELECT 'QYLX' AS field_name, NVL(TRIM(qylx), '<NULL>') AS field_value, COUNT(*) AS row_count
          FROM TL_TSSH.GLXT_BB_SHXT_DJXX GROUP BY NVL(TRIM(qylx), '<NULL>')
        UNION ALL
        SELECT 'NSRLX_JS', NVL(TRIM(nsrlx_js), '<NULL>'), COUNT(*)
          FROM TL_TSSH.GLXT_BB_SHXT_DJXX GROUP BY NVL(TRIM(nsrlx_js), '<NULL>')
        UNION ALL
        SELECT 'NSRZT_JS', NVL(TRIM(nsrzt_js), '<NULL>'), COUNT(*)
          FROM TL_TSSH.GLXT_BB_SHXT_DJXX GROUP BY NVL(TRIM(nsrzt_js), '<NULL>')
        UNION ALL
        SELECT 'JSMODE', NVL(TRIM(jsmode), '<NULL>'), COUNT(*)
          FROM TL_TSSH.GLXT_BB_SHXT_DJXX GROUP BY NVL(TRIM(jsmode), '<NULL>')
        UNION ALL
        SELECT 'FLGLCD', NVL(TRIM(flglcd), '<NULL>'), COUNT(*)
          FROM TL_TSSH.GLXT_BB_SHXT_DJXX GROUP BY NVL(TRIM(flglcd), '<NULL>')
        UNION ALL
        SELECT 'YSJCCODE', NVL(TRIM(ysjccode), '<NULL>'), COUNT(*)
          FROM TL_TSSH.GLXT_BB_SHXT_DJXX GROUP BY NVL(TRIM(ysjccode), '<NULL>')
        UNION ALL
        SELECT 'TKJCCODE', NVL(TRIM(tkjccode), '<NULL>'), COUNT(*)
          FROM TL_TSSH.GLXT_BB_SHXT_DJXX GROUP BY NVL(TRIM(tkjccode), '<NULL>')
        UNION ALL
        SELECT 'MDJCCODE', NVL(TRIM(mdjccode), '<NULL>'), COUNT(*)
          FROM TL_TSSH.GLXT_BB_SHXT_DJXX GROUP BY NVL(TRIM(mdjccode), '<NULL>')
       )
 ORDER BY field_name, field_value;

PROMPT ================================================================
PROMPT B06 标志代码分布，重点识别页面 0/1 与过程 Y/N 的冲突
PROMPT ================================================================

SELECT field_name, field_value, row_count
  FROM (
        SELECT 'WZFQY' AS field_name, NVL(TRIM(wzfqy), '<NULL>') AS field_value, COUNT(*) AS row_count
          FROM TL_TSSH.GLXT_BB_SHXT_DJXX GROUP BY NVL(TRIM(wzfqy), '<NULL>')
        UNION ALL
        SELECT 'WZHQY', NVL(TRIM(wzhqy), '<NULL>'), COUNT(*)
          FROM TL_TSSH.GLXT_BB_SHXT_DJXX GROUP BY NVL(TRIM(wzhqy), '<NULL>')
        UNION ALL
        SELECT 'SDQQY', NVL(TRIM(sdqqy), '<NULL>'), COUNT(*)
          FROM TL_TSSH.GLXT_BB_SHXT_DJXX GROUP BY NVL(TRIM(sdqqy), '<NULL>')
        UNION ALL
        SELECT 'YFJG', NVL(TRIM(yfjg), '<NULL>'), COUNT(*)
          FROM TL_TSSH.GLXT_BB_SHXT_DJXX GROUP BY NVL(TRIM(yfjg), '<NULL>')
        UNION ALL
        SELECT 'YSFW', NVL(TRIM(ysfw), '<NULL>'), COUNT(*)
          FROM TL_TSSH.GLXT_BB_SHXT_DJXX GROUP BY NVL(TRIM(ysfw), '<NULL>')
        UNION ALL
        SELECT 'ZX_FLAG', NVL(TRIM(zx_flag), '<NULL>'), COUNT(*)
          FROM TL_TSSH.GLXT_BB_SHXT_DJXX GROUP BY NVL(TRIM(zx_flag), '<NULL>')
        UNION ALL
        SELECT 'SFCKQY_JS', NVL(TRIM(sfckqy_js), '<NULL>'), COUNT(*)
          FROM TL_TSSH.GLXT_BB_SHXT_DJXX GROUP BY NVL(TRIM(sfckqy_js), '<NULL>')
        UNION ALL
        SELECT 'YXBAFLAG', NVL(TRIM(yxbaflag), '<NULL>'), COUNT(*)
          FROM TL_TSSH.GLXT_BB_SHXT_DJXX GROUP BY NVL(TRIM(yxbaflag), '<NULL>')
       )
 ORDER BY field_name, field_value;

PROMPT ================================================================
PROMPT B07 账号一致性候选基线（仅输出分类计数，不输出账号）
PROMPT 此处只是字符串 TRIM 后的技术比较，不代表已确认的业务算法。
PROMPT ================================================================

SELECT CASE
         WHEN accno IS NULL AND accno_js IS NULL THEN 'BOTH_NULL'
         WHEN accno IS NULL THEN 'ORACLE_AUDIT_ACCOUNT_NULL'
         WHEN accno_js IS NULL THEN 'JINSAN_ACCOUNT_NULL'
         WHEN TRIM(accno) = TRIM(accno_js) THEN 'EQUAL_AFTER_TRIM'
         ELSE 'DIFFERENT_AFTER_TRIM'
       END AS compare_class,
       COUNT(*) AS row_count
  FROM TL_TSSH.GLXT_BB_SHXT_DJXX
 GROUP BY CASE
            WHEN accno IS NULL AND accno_js IS NULL THEN 'BOTH_NULL'
            WHEN accno IS NULL THEN 'ORACLE_AUDIT_ACCOUNT_NULL'
            WHEN accno_js IS NULL THEN 'JINSAN_ACCOUNT_NULL'
            WHEN TRIM(accno) = TRIM(accno_js) THEN 'EQUAL_AFTER_TRIM'
            ELSE 'DIFFERENT_AFTER_TRIM'
          END
 ORDER BY compare_class;

PROMPT ================================================================
PROMPT B08 撤回/注销候选状态交叉分布
PROMPT 仅提供原始代码组合，不在脚本中擅自判定“一致”。
PROMPT ================================================================

SELECT NVL(TRIM(zx_flag), '<NULL>') AS zx_flag,
       NVL(TRIM(nsrzt_js), '<NULL>') AS nsrzt_js,
       CASE WHEN zx_date IS NULL THEN 'ZX_DATE_NULL' ELSE 'ZX_DATE_NOT_NULL' END AS zx_date_state,
       COUNT(*) AS row_count
  FROM TL_TSSH.GLXT_BB_SHXT_DJXX
 GROUP BY NVL(TRIM(zx_flag), '<NULL>'),
          NVL(TRIM(nsrzt_js), '<NULL>'),
          CASE WHEN zx_date IS NULL THEN 'ZX_DATE_NULL' ELSE 'ZX_DATE_NOT_NULL' END
 ORDER BY zx_flag, nsrzt_js, zx_date_state;

PROMPT ================================================================
PROMPT B09 备案/金三归类候选状态交叉分布
PROMPT ================================================================

SELECT NVL(TRIM(yxbaflag), '<NULL>') AS yxbaflag,
       NVL(TRIM(zx_flag), '<NULL>') AS zx_flag,
       NVL(TRIM(sfckqy_js), '<NULL>') AS sfckqy_js,
       COUNT(*) AS row_count
  FROM TL_TSSH.GLXT_BB_SHXT_DJXX
 GROUP BY NVL(TRIM(yxbaflag), '<NULL>'),
          NVL(TRIM(zx_flag), '<NULL>'),
          NVL(TRIM(sfckqy_js), '<NULL>')
 ORDER BY yxbaflag, zx_flag, sfckqy_js;

PROMPT ================================================================
PROMPT B10 税务机关和街道字典孤儿记录
PROMPT ================================================================

SELECT 'B10_SWJGDM' AS check_id, COUNT(*) AS orphan_rows
  FROM TL_TSSH.GLXT_BB_SHXT_DJXX t
 WHERE t.swjgdm IS NOT NULL
   AND NOT EXISTS (
       SELECT 1 FROM TL_ADMIN.DM_SWJG d WHERE d.swjg_dm = t.swjgdm
   );

SELECT 'B10_ZGSWJGDM' AS check_id, COUNT(*) AS orphan_rows
  FROM TL_TSSH.GLXT_BB_SHXT_DJXX t
 WHERE t.zgswjgdm IS NOT NULL
   AND NOT EXISTS (
       SELECT 1 FROM TL_ADMIN.DM_SWJG d WHERE d.swjg_dm = t.zgswjgdm
   );

SELECT 'B10_ZGSWSKFJ_DM' AS check_id, COUNT(*) AS orphan_rows
  FROM TL_TSSH.GLXT_BB_SHXT_DJXX t
 WHERE t.zgswskfj_dm IS NOT NULL
   AND NOT EXISTS (
       SELECT 1 FROM TL_ADMIN.DM_SWJG d WHERE d.swjg_dm = t.zgswskfj_dm
   );

SELECT 'B10_JDXZ_DM' AS check_id, COUNT(*) AS orphan_rows
  FROM TL_TSSH.GLXT_BB_SHXT_DJXX t
 WHERE t.jdxz_dm IS NOT NULL
   AND NOT EXISTS (
       SELECT 1 FROM TL_ADMIN.DM_JDXZ d WHERE d.jdxz_dm = t.jdxz_dm
   );

PROMPT ================================================================
PROMPT B11 日期质量摘要
PROMPT 1900-01-01/2100-12-31 对应现前端粗粒度年份边界，不代表业务有效期。
PROMPT ================================================================

SELECT 'B11' AS check_id,
       SUM(CASE WHEN sq_date < DATE '1900-01-01' THEN 1 ELSE 0 END) AS before_ui_min,
       SUM(CASE WHEN sq_date >= DATE '2101-01-01' THEN 1 ELSE 0 END) AS after_ui_max,
       SUM(CASE WHEN sq_date <> TRUNC(sq_date) THEN 1 ELSE 0 END) AS sq_date_has_time,
       SUM(CASE WHEN zx_date <> TRUNC(zx_date) THEN 1 ELSE 0 END) AS zx_date_has_time,
       SUM(CASE WHEN zx_flag IS NOT NULL AND zx_date IS NULL THEN 1 ELSE 0 END) AS flag_without_date,
       SUM(CASE WHEN zx_flag IS NULL AND zx_date IS NOT NULL THEN 1 ELSE 0 END) AS date_without_flag
  FROM TL_TSSH.GLXT_BB_SHXT_DJXX;

PROMPT ================================================================
PROMPT B12 核心表约束数量与明细
PROMPT 结构脚本显示无约束；本节用于以实际数据库定真。
PROMPT ================================================================

SELECT 'B12' AS check_id,
       COUNT(*) AS constraint_count,
       SUM(CASE WHEN constraint_type = 'P' THEN 1 ELSE 0 END) AS primary_key_count,
       SUM(CASE WHEN constraint_type = 'U' THEN 1 ELSE 0 END) AS unique_key_count,
       SUM(CASE WHEN constraint_type = 'R' THEN 1 ELSE 0 END) AS foreign_key_count,
       SUM(CASE WHEN constraint_type = 'C' THEN 1 ELSE 0 END) AS check_constraint_count
  FROM ALL_CONSTRAINTS
 WHERE owner = 'TL_TSSH'
   AND table_name = 'GLXT_BB_SHXT_DJXX';

SELECT constraint_name, constraint_type, status, validated, deferrable, deferred
  FROM ALL_CONSTRAINTS
 WHERE owner = 'TL_TSSH'
   AND table_name = 'GLXT_BB_SHXT_DJXX'
 ORDER BY constraint_type, constraint_name;

PROMPT ================================================================
PROMPT B13 核心表索引与索引列
PROMPT ================================================================

SELECT i.index_name,
       i.uniqueness,
       i.status,
       c.column_position,
       c.column_name,
       c.descend
  FROM ALL_INDEXES i
  JOIN ALL_IND_COLUMNS c
    ON c.index_owner = i.owner
   AND c.index_name = i.index_name
   AND c.table_owner = i.table_owner
   AND c.table_name = i.table_name
 WHERE i.table_owner = 'TL_TSSH'
   AND i.table_name = 'GLXT_BB_SHXT_DJXX'
 ORDER BY i.index_name, c.column_position;

PROMPT ================================================================
PROMPT B14 优化器统计信息（NUM_ROWS 只是最近统计估值，不等于实时 COUNT）
PROMPT ================================================================

SELECT owner,
       table_name,
       num_rows,
       blocks,
       avg_row_len,
       sample_size,
       last_analyzed,
       stale_stats
  FROM ALL_TAB_STATISTICS
 WHERE owner = 'TL_TSSH'
   AND table_name = 'GLXT_BB_SHXT_DJXX';

PROMPT ================================================================
PROMPT B15 生产实际列定义（与导出 DDL/数据字典对比）
PROMPT ================================================================

SELECT column_id,
       column_name,
       data_type,
       data_length,
       char_length,
       data_precision,
       data_scale,
       nullable,
       data_default
  FROM ALL_TAB_COLUMNS
 WHERE owner = 'TL_TSSH'
   AND table_name = 'GLXT_BB_SHXT_DJXX'
 ORDER BY column_id;

PROMPT ================================================================
PROMPT B16 qyxx 列表配置（无用户敏感信息）
PROMPT 必须归档本结果，仓库中只有表结构，没有生产配置数据。
PROMPT ================================================================

SELECT t_code,
       t_c_code,
       t_c_name,
       c_min_size,
       c_max_size,
       c_std_size,
       no,
       is_fixed,
       is_order,
       align,
       isvaild,
       degree,
       d_config
  FROM TL_ADMIN.SYS_CFG_TABLE_COLUMN
 WHERE t_code = 'qyxx'
 ORDER BY no, t_c_code;

PROMPT ================================================================
PROMPT B17 qyxx 用户偏好聚合（不输出 USER_ID 或 CS 内容）
PROMPT ================================================================

SELECT 'B17' AS check_id,
       COUNT(*) AS preference_rows,
       COUNT(DISTINCT user_id) AS distinct_users,
       SUM(CASE WHEN isvaild = '1' THEN 1 ELSE 0 END) AS active_rows,
       SUM(CASE WHEN cs IS NULL THEN 1 ELSE 0 END) AS null_cs_rows,
       SUM(CASE WHEN LENGTH(cs) > 1000 THEN 1 ELSE 0 END) AS cs_over_ddl_limit,
       MAX(LENGTH(cs)) AS max_cs_length,
       MIN(create_time) AS min_create_time,
       MAX(update_time) AS max_update_time
  FROM TL_ADMIN.SYS_CFG_TABLE_USER
 WHERE t_code = 'qyxx';

PROMPT ================================================================
PROMPT B18 配置完整性：偏好中的字段代码需另在安全环境拆分校验
PROMPT Oracle 版本和字符串拆分实现不明，本脚本只先给出结构性摘要。
PROMPT ================================================================

SELECT 'B18' AS check_id,
       (SELECT COUNT(*)
          FROM TL_ADMIN.SYS_CFG_TABLE_COLUMN
         WHERE t_code = 'qyxx'
           AND isvaild = '1') AS active_column_count,
       (SELECT COUNT(*)
          FROM TL_ADMIN.SYS_CFG_TABLE_USER
         WHERE t_code = 'qyxx'
           AND isvaild = '1') AS active_preference_count,
       (SELECT COUNT(*)
          FROM TL_ADMIN.SYS_CFG_TABLE_USER
         WHERE t_code = 'qyxx'
           AND isvaild = '1'
           AND (cs IS NULL OR TRIM(cs) IS NULL)) AS blank_preference_count
  FROM dual;

PROMPT ================================================================
PROMPT 执行结束
PROMPT 后续：以业务批准的规则补充脱敏黄金样本，并在 MySQL 用同口径复跑。
PROMPT 不要把含企业明细或个人敏感数据的查询结果提交到 Git 仓库。
PROMPT ================================================================
