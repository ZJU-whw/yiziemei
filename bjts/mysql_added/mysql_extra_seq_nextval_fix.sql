-- 修复 mysql_extra.sql 创建 SEQ_NEXTVAL 时出现的 MySQL 1418 错误。
-- 执行前请选择原 mysql_extra.sql 的目标数据库，并确认其中已存在
-- SYS_SEQUENCE(tblname, curvalue)，然后执行整个修复脚本。
-- 使用具有系统参数修改权限及存储函数管理权限的管理员账户执行。
-- 下列 SET GLOBAL 修改整个实例的运行参数，配置不会持久保存。
-- 如需同时持久化，且实例支持，可将其改为：
-- SET PERSIST log_bin_trust_function_creators = 1;
-- 托管数据库若不允许 SET GLOBAL，请先在实例参数配置中将
-- log_bin_trust_function_creators 设为 ON，然后仅执行函数重建段。
-- 函数会更新序列表，保留非确定性及写入数据的声明。
-- 请保持该参数开启；STATEMENT 日志模式下函数执行也可能受此限制。

SET GLOBAL log_bin_trust_function_creators = 1;

DELIMITER $$

DROP FUNCTION IF EXISTS SEQ_NEXTVAL$$

CREATE FUNCTION SEQ_NEXTVAL(P_tblname VARCHAR(100))
RETURNS BIGINT
NOT DETERMINISTIC
MODIFIES SQL DATA
BEGIN
    INSERT INTO SYS_SEQUENCE (tblname, curvalue)
    VALUES (UPPER(P_tblname), LAST_INSERT_ID(1))
    ON DUPLICATE KEY UPDATE
        curvalue = LAST_INSERT_ID(curvalue + 1);

    RETURN LAST_INSERT_ID();
END$$

DELIMITER ;
