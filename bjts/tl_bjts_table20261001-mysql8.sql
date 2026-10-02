-- MySQL 8.0.17+ / InnoDB; UTF-8 encoded.
-- Source: tl_bjts_table20261001-nodup.sql (strictly decoded from GBK).
-- Select the corresponding database before running; each file is a separate Oracle schema.
-- NUMBER(p,s) -> DECIMAL(p,s); NUMBER(p) -> DECIMAL(p,0), including p > 18.
-- Oracle INTEGER -> DECIMAL(38,0); never narrow Oracle INTEGER to MySQL INT.
-- Unspecified NUMBER -> DECIMAL(65,27): 38 integer and 27 fractional digits.
-- This chosen bound cannot represent the full exponent/scale range of Oracle NUMBER.
-- DATE -> DATETIME; TIMESTAMP(6) -> DATETIME(6); CLOB/BLOB -> LONGTEXT/LONGBLOB.
-- Original table/column comment text, primary-key columns, named indexes and unique keys are retained.
-- Auxiliary expression UNIQUE indexes retain Oracle uniqueness for partially-NULL composite keys.
-- MySQL names its primary index PRIMARY; original constraint names remain in CONSTRAINT clauses and notes.
-- Oracle TABLESPACE/NOLOGGING are physical options with no equivalent here.
-- utf8mb4_0900_bin preserves case-sensitive, non-padding VARCHAR comparisons.
SET NAMES utf8mb4;
SET @yiziemei_mysql8_saved_sql_mode = @@SESSION.sql_mode;
SET SESSION sql_mode = IF(FIND_IN_SET('NO_BACKSLASH_ESCAPES', @@SESSION.sql_mode), @@SESSION.sql_mode, CONCAT_WS(',', NULLIF(@@SESSION.sql_mode, ''), 'NO_BACKSLASH_ESCAPES'));

-- Creating table BJTS_TASK
-- Original Oracle primary-key constraint: PK_BJTS_TASK (MySQL index name: PRIMARY).
CREATE TABLE `BJTS_TASK` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '主键',
  `nsrsbh` VARCHAR(20) NOT NULL COMMENT '纳税人识别号',
  `type` CHAR(3) NOT NULL COMMENT '任务类型(操作类型)001-准入，002-贷中',
  `name` VARCHAR(50) COMMENT '任务名称',
  `hash` VARCHAR(50) NOT NULL COMMENT '任务hash  nsrsbh+czny_type',
  `status` CHAR(1) NOT NULL DEFAULT '0' COMMENT '任务状态 (0:待处理 1:处理中 2:处理失败   9:处理完毕)',
  `tqbz` VARCHAR(32) COMMENT '提取标志',
  `tqsj` DATETIME(6) DEFAULT (CAST(CURRENT_TIMESTAMP(0) AS DATETIME)) COMMENT '提取时间',
  `tqcs` DECIMAL(6,0) DEFAULT 0 COMMENT '提取次数',
  `qqcs` DECIMAL(6,0) DEFAULT 0 COMMENT '请求次数',
  `zjfwsj` DATETIME(6) COMMENT '最近访问时间',
  `cjsj` DATETIME(6) DEFAULT (CAST(CURRENT_TIMESTAMP(0) AS DATETIME)) COMMENT '创建时间',
  `xgsj` DATETIME(6) COMMENT '修改时间',
  `bz` VARCHAR(500) COMMENT '备注',
  `qqbw` LONGTEXT COMMENT '请求报文，json格式存储',
  `xybw` LONGTEXT COMMENT '响应报文，根据bwgs确定',
  `bwgs` VARCHAR(5) COMMENT 'zip：对json格式进行压缩，json等格式',
  KEY `IDX_BJTS_TASK_NT` (`NSRSBH`, `TYPE`),
  UNIQUE KEY `UK_BJTS_TASK_HASH` (`HASH`),
  CONSTRAINT `PK_BJTS_TASK` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='便捷退税-任务表';

-- Creating table BJTS_TASK_HIS
-- Original Oracle primary-key constraint: PK_BJTS_TASK_HIS (MySQL index name: PRIMARY).
CREATE TABLE `BJTS_TASK_HIS` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '主键',
  `nsrsbh` VARCHAR(20) NOT NULL COMMENT '纳税人识别号',
  `type` CHAR(3) NOT NULL COMMENT '任务类型(操作类型)001-准入，002-贷中',
  `name` VARCHAR(50) COMMENT '任务名称',
  `hash` VARCHAR(50) NOT NULL COMMENT '任务hash  nsrsbh+czny_type',
  `status` CHAR(1) NOT NULL DEFAULT '0' COMMENT '任务状态 (0:待处理 1:处理中 2:处理失败   9:处理完毕)',
  `tqbz` VARCHAR(32) COMMENT '提取标志',
  `tqsj` DATETIME(6) DEFAULT (CAST(CURRENT_TIMESTAMP(0) AS DATETIME)) COMMENT '提取时间',
  `tqcs` DECIMAL(6,0) DEFAULT 0 COMMENT '提取次数',
  `qqcs` DECIMAL(6,0) DEFAULT 0 COMMENT '请求次数',
  `zjfwsj` DATETIME(6) COMMENT '最近访问时间',
  `cjsj` DATETIME(6) DEFAULT (CAST(CURRENT_TIMESTAMP(0) AS DATETIME)) COMMENT '创建时间',
  `xgsj` DATETIME(6) COMMENT '修改时间',
  `bz` VARCHAR(500) COMMENT '备注',
  `qqbw` LONGTEXT COMMENT '请求报文，json格式存储',
  `xybw` LONGTEXT COMMENT '响应报文，根据bwgs确定',
  `bwgs` VARCHAR(5) COMMENT 'zip：对json格式进行压缩，json等格式',
  CONSTRAINT `PK_BJTS_TASK_HIS` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='便捷退税-历史任务表';

-- Creating table CALL_PROC_RET
-- Original Oracle primary-key constraint: PK_CALL_PROC_RET (MySQL index name: PRIMARY).
CREATE TABLE `CALL_PROC_RET` (
  `id` DECIMAL(18,0) NOT NULL,
  `ls_code` VARCHAR(20) COMMENT '调用存储过程返回代码',
  `ls_msg` VARCHAR(500) COMMENT '调用存储过程返回信息',
  `call_time` DATETIME COMMENT '调用时间',
  `note` VARCHAR(500) COMMENT '备注',
  `up_time` DATETIME COMMENT '修改时间',
  `sbid` DECIMAL(18,0) COMMENT '对应sb_sbxx_hz表id',
  CONSTRAINT `PK_CALL_PROC_RET` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='调用存储过程反馈表';

-- Creating table CKTS_BA_BABGQK_LSB
CREATE TABLE `CKTS_BA_BABGQK_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '企业海关代码',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `babgzd_dm` VARCHAR(30) COMMENT '变更字段',
  `babgzdmc` VARCHAR(150) COMMENT '变更字段说明',
  `bgq` VARCHAR(3000) COMMENT '变更前内容',
  `bgh` VARCHAR(3000) COMMENT '变更后内容',
  `bz` VARCHAR(3000) COMMENT '备注',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  KEY `IDX_CKTS_BA_BABGQK_LSB_1` (`SBID`),
  KEY `IDX_CKTS_BA_BABGQK_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口企业委备案变更临时表';

-- Creating table CKTS_BA_SCQYWTDBTS_LSB
CREATE TABLE `CKTS_BA_SCQYWTDBTS_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '企业海关代码',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `xh` DECIMAL(8,0) COMMENT '序号',
  `wmzhfwqynsrmc` VARCHAR(300) COMMENT '外贸综合服务企业纳税人名称',
  `wmzhfwqyhgqydm` VARCHAR(50) COMMENT '外贸综合服务企业海关企业代码',
  `wmzhfwqynsrsbh` VARCHAR(20) COMMENT '外贸综合服务企业纳税人识别号',
  `wmzhfwqyshxydm` VARCHAR(20) COMMENT '外贸综合服务企业社会信用代码',
  `wmzhfwhtxyhm` VARCHAR(60) COMMENT '外贸综合服务合同（协议）号码',
  `tskhyhmc` VARCHAR(120) COMMENT '退税开户银行名称',
  `tskhyhzh` VARCHAR(50) COMMENT '退税开户银行账号',
  `fddbrxm` VARCHAR(150) COMMENT '法定代表人姓名',
  `dbtsbalczt_dm` CHAR(1) COMMENT '代办退税备案流程状态代码',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `tbrq_1` DATETIME COMMENT '填表日期',
  KEY `IDX_CKTS_BA_SCQYWTDBTS_LSB_1` (`SBID`),
  KEY `IDX_CKTS_BA_SCQYWTDBTS_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='生产企业委托代办退税备案临时表';

-- Creating table CKTS_BA_WMZHFWDBTS_LSB
CREATE TABLE `CKTS_BA_WMZHFWDBTS_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '企业海关代码',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `xh` DECIMAL(8,0) COMMENT '序号',
  `wtdbtsscqynsrmc` VARCHAR(300) COMMENT '委托代办退税生产企业纳税人名称',
  `wtdbtsscqyhgqydm` VARCHAR(50) COMMENT '委托代办退税生产企业海关企业代码',
  `wtdbtsscqynsrsbh` VARCHAR(20) COMMENT '委托代办退税生产企业纳税人识别号',
  `wtdbtsscqyshxydm` VARCHAR(20) COMMENT '委托代办退税生产企业社会信用代码',
  `wmzhfwhtxyhm` VARCHAR(60) COMMENT '外贸综合服务合同（协议）号码',
  `wtdbtsscqydbtskhyhmc` VARCHAR(120) COMMENT '委托代办退税生产企业代办退税开户银行名称',
  `wtdbtsscqydbtskhyhzh` VARCHAR(50) COMMENT '委托代办退税生产企业代办退税开户银行账号',
  `fddbrxm` VARCHAR(150) COMMENT '法定代表人姓名',
  `dbtsbalczt_dm` CHAR(1) COMMENT '代办退税备案流程状态代码',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `tskhyhmc` VARCHAR(120) COMMENT '退税开户银行名称',
  `tskhyhzh` VARCHAR(50) COMMENT '退税开户银行账号',
  KEY `IDX_CKTS_BA_WMZHFWDBTS_LSB_1` (`SBID`),
  KEY `IDX_CKTS_BA_WMZHFWDBTS_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='外贸综合服务代办退税备案临时表';

-- Creating table CKTS_DM_FPHCJG
-- Original Oracle primary-key constraint: PK_CKTS_DM_FPHCJG (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_DM_FPHCJG` (
  `fphcjg_dm` CHAR(6) NOT NULL COMMENT '发票核查结果代码',
  `fphcjgmc` VARCHAR(150) NOT NULL COMMENT '发票核查结果名称',
  `yxbz` CHAR(1) NOT NULL COMMENT '有效标志',
  `xybz` CHAR(1) NOT NULL COMMENT '选用标志',
  CONSTRAINT `PK_CKTS_DM_FPHCJG` PRIMARY KEY (`FPHCJG_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='发票核查结果代码';

-- Creating table CKTS_DM_GJYSFW
-- Original Oracle primary-key constraint: PK_CKTS_DM_GJYSFW (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_DM_GJYSFW` (
  `gjysfwdm` CHAR(2) NOT NULL COMMENT '研发设计服务代码',
  `gjysfwjc` VARCHAR(20) NOT NULL COMMENT '研发设计服务简称',
  `gjysfwmc` VARCHAR(75) NOT NULL COMMENT '研发设计服务名称',
  `gjysfwsm` VARCHAR(200) NOT NULL COMMENT '研发设计服务说明',
  `yxbz` CHAR(1) NOT NULL COMMENT '有效标志',
  `xybz` CHAR(1) NOT NULL COMMENT '选用标志',
  CONSTRAINT `PK_CKTS_DM_GJYSFW` PRIMARY KEY (`GJYSFWDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='研发设计服务代码';

-- Creating table CKTS_DM_HGJGFS
-- Original Oracle primary-key constraint: PK_CKTS_DM_HGJGFS (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_DM_HGJGFS` (
  `jgfs_dm` CHAR(4) NOT NULL COMMENT '监管方式代码',
  `jgfsmc` VARCHAR(150) NOT NULL COMMENT '监管方式名称',
  `jgfsqc` VARCHAR(300) NOT NULL COMMENT '监管方式全称',
  `jgfssm` VARCHAR(4000) COMMENT '监管方式说明',
  `jgfstslx_dm` CHAR(1) NOT NULL COMMENT '监管方式退税类型代码',
  `yxbz` CHAR(1) NOT NULL COMMENT '有效标志',
  `xybz` CHAR(1) NOT NULL COMMENT '选用标志',
  CONSTRAINT `PK_CKTS_DM_HGJGFS` PRIMARY KEY (`JGFS_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='海关监管方式代码';

-- Creating table CKTS_DM_HGJLDW
-- Original Oracle primary-key constraint: PK_CKTS_DM_HGJLDW (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_DM_HGJLDW` (
  `hgjldw_dm` VARCHAR(3) NOT NULL COMMENT '海关计量单位代码',
  `hgjldwmc` VARCHAR(75) NOT NULL COMMENT '海关计量单位名称',
  `hgjldwqc` VARCHAR(300) NOT NULL COMMENT '海关计量单位全称',
  `yxbz` CHAR(1) NOT NULL COMMENT '有效标志',
  `xybz` CHAR(1) NOT NULL COMMENT '选用标志',
  CONSTRAINT `PK_CKTS_DM_HGJLDW` PRIMARY KEY (`HGJLDW_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='海关计量单位代码';

-- Creating table CKTS_DM_TSLVTZ
-- Original Oracle primary-key constraint: PK_CKTS_DM_TSLVTZ (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_DM_TSLVTZ` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID||uuid',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `ckspmc` VARCHAR(75) COMMENT '出口商品名称',
  `zcyj` VARCHAR(4000) COMMENT '政策依据',
  `kssj` DATETIME COMMENT '开始时间',
  `jssj` DATETIME COMMENT '结束时间',
  `tsl` DECIMAL(16,6) COMMENT '退税率',
  `zssl` DECIMAL(16,6) COMMENT '征税税率',
  `kpqsrq` DATETIME COMMENT '开票起始日期',
  `kpjzrq` DATETIME COMMENT '开票截止日期',
  `tzhtsl` DECIMAL(16,6) COMMENT '调整后退税率',
  `yxbz` CHAR(1) NOT NULL COMMENT '有效标志',
  `xybz` CHAR(1) NOT NULL COMMENT '选用标志',
  `lrrq` DATETIME NOT NULL COMMENT '录入日期',
  `lrr_dm` CHAR(11) NOT NULL COMMENT '录入人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  KEY `IDX_CKTS_DM_TSLVTZ_CQZ` (`CKSP_DM`, `KSSJ`, `JSSJ`),
  CONSTRAINT `PK_CKTS_DM_TSLVTZ` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口商品退税率调整表';

-- Creating table CKTS_DM_TSLVWK
-- Original Oracle primary-key constraint: PK_CKTS_DM_TSLVWK (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_DM_TSLVWK` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID||uuid',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `yxqq` DATETIME COMMENT '有效期起',
  `yxqz` DATETIME COMMENT '有效期止',
  `zhcksp_dm` VARCHAR(20) COMMENT '转换出口商品代码',
  `ckspmc` VARCHAR(75) COMMENT '出口商品名称',
  `hgjldw_dm` VARCHAR(3) COMMENT '海关计量单位代码',
  `hgjldwmc` VARCHAR(75) COMMENT '海关计量单位名称',
  `jbspbz` CHAR(1) COMMENT '基本商品标志',
  `bzspbz` CHAR(1) COMMENT '标准商品标志',
  `bzdwbz` CHAR(1) COMMENT '标准单位标志',
  `sz` CHAR(1) COMMENT '税种',
  `zssljh` VARCHAR(10) COMMENT '征税税率集合',
  `cldezs` DECIMAL(16,4) COMMENT '从量定额征税',
  `cjdlzs` DECIMAL(16,4) COMMENT '从价定率征税',
  `tsl` DECIMAL(16,6) COMMENT '退税率',
  `splb` CHAR(2) COMMENT '商品类别',
  `yxbz` CHAR(1) COMMENT '有效标志',
  `xybz` CHAR(1) COMMENT '选用标志',
  `lrrq` DATETIME NOT NULL COMMENT '录入日期',
  `lrr_dm` CHAR(11) NOT NULL COMMENT '录入人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `cksptssplx_dm` CHAR(1) COMMENT '出口商品特殊商品类型代码',
  `bz` VARCHAR(3000) COMMENT '备注',
  `spdmkbb` VARCHAR(75) COMMENT '商品代码库版本',
  `zssl` DECIMAL(16,6) COMMENT '征税税率',
  KEY `IDX_CKTS_DM_TSLVWK_CQZ` (`CKSP_DM`, `YXQQ`, `YXQZ`),
  CONSTRAINT `PK_CKTS_DM_TSLVWK` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口商品退税率文库';

-- Creating table CKTS_DM_TSLVWK_2026A
-- Original Oracle primary-key constraint: PK_CKTS_DM_TSLVWK_2026A (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_DM_TSLVWK_2026A` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID||uuid',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `yxqq` DATETIME COMMENT '有效期起',
  `yxqz` DATETIME COMMENT '有效期止',
  `zhcksp_dm` VARCHAR(20) COMMENT '转换出口商品代码',
  `ckspmc` VARCHAR(75) COMMENT '出口商品名称',
  `hgjldw_dm` VARCHAR(3) COMMENT '海关计量单位代码',
  `hgjldwmc` VARCHAR(75) COMMENT '海关计量单位名称',
  `jbspbz` CHAR(1) COMMENT '基本商品标志',
  `bzspbz` CHAR(1) COMMENT '标准商品标志',
  `bzdwbz` CHAR(1) COMMENT '标准单位标志',
  `sz` CHAR(1) COMMENT '税种',
  `zssljh` VARCHAR(10) COMMENT '征税税率集合',
  `cldezs` DECIMAL(16,4) COMMENT '从量定额征税',
  `cjdlzs` DECIMAL(16,4) COMMENT '从价定率征税',
  `tsl` DECIMAL(16,6) COMMENT '退税率',
  `splb` CHAR(2) COMMENT '商品类别',
  `yxbz` CHAR(1) COMMENT '有效标志',
  `xybz` CHAR(1) COMMENT '选用标志',
  `lrrq` DATETIME NOT NULL COMMENT '录入日期',
  `lrr_dm` CHAR(11) NOT NULL COMMENT '录入人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `cksptssplx_dm` CHAR(1) COMMENT '出口商品特殊商品类型代码',
  `bz` VARCHAR(3000) COMMENT '备注',
  `spdmkbb` VARCHAR(75) COMMENT '商品代码库版本',
  `zssl` DECIMAL(16,6) COMMENT '征税税率',
  KEY `IDX_CKTS_DM_TSLVWK_2026A_CQZ` (`CKSP_DM`, `YXQQ`, `YXQZ`),
  CONSTRAINT `PK_CKTS_DM_TSLVWK_2026A` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口商品退税率文库';

-- Creating table CKTS_DM_XCJG
-- Original Oracle primary-key constraint: PK_CKTS_DM_XCJG (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_DM_XCJG` (
  `xcjg_dm` CHAR(6) NOT NULL COMMENT '协查结果代码',
  `xcjgmc` VARCHAR(75) NOT NULL COMMENT '协查结果名称',
  `yxbz` CHAR(1) NOT NULL COMMENT '有效标志',
  `xybz` CHAR(1) NOT NULL COMMENT '选用标志',
  CONSTRAINT `PK_CKTS_DM_XCJG` PRIMARY KEY (`XCJG_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='协查结果代码';

-- Creating table CKTS_DM_YFSJFW
-- Original Oracle primary-key constraint: PK_CKTS_DM_YFSJFW (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_DM_YFSJFW` (
  `yfsjfwdm` CHAR(2) NOT NULL COMMENT '研发设计服务代码',
  `yfsjfwjc` VARCHAR(20) NOT NULL COMMENT '研发设计服务简称',
  `yfsjfwmc` VARCHAR(75) NOT NULL COMMENT '研发设计服务名称',
  `yfsjfwsm` VARCHAR(200) NOT NULL COMMENT '研发设计服务说明',
  `yxbz` CHAR(1) NOT NULL COMMENT '有效标志',
  `xybz` CHAR(1) NOT NULL COMMENT '选用标志',
  CONSTRAINT `PK_CKTS_DM_YFSJFW` PRIMARY KEY (`YFSJFWDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='研发设计服务代码';

-- Creating table CKTS_GCB_ZM_TYYBSWTS
CREATE TABLE `CKTS_GCB_ZM_TYYBSWTS` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `lcslid` CHAR(32) COMMENT '流程实例ID',
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID||uuid',
  `cktszmbh` VARCHAR(20) COMMENT '出口退税证明编号',
  `wtfcktszmbh` VARCHAR(20) COMMENT '委托方出口退税证明编号',
  `dlckhwzmhm` VARCHAR(20) COMMENT '代理出口货物证明号码',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `ckshhxdh` VARCHAR(30) COMMENT '出口收汇核销单号',
  `ckfph` VARCHAR(30) COMMENT '出口发票号',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `ckspmc` VARCHAR(75) COMMENT '出口商品名称',
  `hgjldwmc` VARCHAR(75) COMMENT '海关计量单位名称',
  `cksl` DECIMAL(17,5) COMMENT '出口数量',
  `hggqka_dm` CHAR(4) COMMENT '海关关区（口岸）代码',
  `yjsje` DECIMAL(18,2) COMMENT '原计税金额',
  `ysbmdtse` DECIMAL(18,6) COMMENT '原申报免抵退税额',
  `ytzzse_1` DECIMAL(18,6) COMMENT '原退增值税额',
  `ytxfse_1` DECIMAL(18,6) COMMENT '原退消费税额',
  `jhpzh` VARCHAR(75) COMMENT '进货凭证号',
  `tysl` DECIMAL(17,5) COMMENT '退运数量',
  `tyjsje` DECIMAL(18,2) COMMENT '退运计税金额',
  `ytsl_1` DECIMAL(16,6) COMMENT '原退税率',
  `ycjmdtse` DECIMAL(18,2) COMMENT '已冲减免抵退税额||应用于进出口退税',
  `cjssq` VARCHAR(60) COMMENT '冲减所属期',
  `ybzzse_1` DECIMAL(18,6) COMMENT '已补增值税额',
  `ybxfse_1` DECIMAL(18,6) COMMENT '已补消费税额',
  `jkshm` VARCHAR(20) COMMENT '缴款书号码',
  `rkrq` DATETIME COMMENT '入库日期',
  `tyybswtstylx_dm` CHAR(1) COMMENT '退运已补税（未退税）退运类型代码',
  `ysybs` CHAR(1) COMMENT '已使用标识',
  `bz` VARCHAR(3000) COMMENT '备注',
  `tsswjg_dm_1` CHAR(11) NOT NULL COMMENT '退税税务机关代码',
  `lrrq` DATETIME NOT NULL COMMENT '录入日期',
  `lrr_dm` CHAR(11) NOT NULL COMMENT '录入人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `sjgsdq` CHAR(11) NOT NULL COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `sbbh_1` VARCHAR(20) COMMENT '申报编号',
  `xh_4` VARCHAR(10) COMMENT '项号',
  `sbny` CHAR(6) COMMENT '申报年月',
  `ckemy` DECIMAL(18,2) COMMENT '出口额（美元）',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `hsjg` VARCHAR(20) COMMENT '核实结果',
  `sz` CHAR(1) COMMENT '税种',
  `tmsztbz` VARCHAR(50) COMMENT '退（免）税状态标志',
  `ybjtmsk` DECIMAL(18,6) COMMENT '应补缴退（免）税款',
  `ywclfs` VARCHAR(20) COMMENT '业务处理方式',
  `kjbz` CHAR(1) COMMENT '开具标志',
  `kjrq` DATETIME COMMENT '开具日期',
  `kjr_dm` CHAR(11) COMMENT '开具人代码',
  KEY `IDX_CKTS_GCB_ZM_TYYBSWTS_D` (`DJXH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口货物退运已补税(未退税)证明过程表';

-- Creating table CKTS_JGB_BA_SCQYWTDBTS
CREATE TABLE `CKTS_JGB_BA_SCQYWTDBTS` (
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `lcslid` CHAR(32) COMMENT '流程实例ID',
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID||uuid',
  `nsrmc` VARCHAR(300) COMMENT '纳税人名称',
  `hgqy_dm` VARCHAR(50) COMMENT '海关企业代码',
  `nsrsbh` VARCHAR(20) COMMENT '纳税人识别号',
  `shxydm` VARCHAR(20) COMMENT '社会信用代码',
  `wmzhfwqynsrmc` VARCHAR(300) COMMENT '外贸综合服务企业纳税人名称',
  `wmzhfwqyhgqydm` VARCHAR(50) COMMENT '外贸综合服务企业海关企业代码',
  `wmzhfwqynsrsbh` VARCHAR(20) COMMENT '外贸综合服务企业纳税人识别号',
  `wmzhfwqyshxydm` VARCHAR(20) COMMENT '外贸综合服务企业社会信用代码',
  `wmzhfwhtxyhm` VARCHAR(60) COMMENT '外贸综合服务合同（协议）号码',
  `tskhyhmc` VARCHAR(120) COMMENT '退税开户银行名称',
  `tskhyhzh` VARCHAR(50) COMMENT '退税开户银行账号',
  `fddbrxm` VARCHAR(150) COMMENT '法定代表人姓名',
  `dbtsbalczt_dm` CHAR(1) COMMENT '代办退税备案流程状态代码',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `bachbz` CHAR(1) COMMENT '备案撤回标志||备案撤回标志',
  `bachrq` DATETIME COMMENT '备案撤回日期',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  KEY `IDX_CKTS_JGB_BA_SCQYWTDBTS_D` (`DJXH`),
  KEY `IDX_CKTS_JGB_BA_SCQYWTDBTS_HG` (`HGQY_DM`),
  KEY `IDX_CKTS_JGB_BA_SCQYWTDBTS_WM` (`WMZHFWQYNSRSBH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='生产企业委托代办退税备案结果表';

-- Creating table CKTS_JGB_BA_WMZHFWDBTS
-- Original Oracle primary-key constraint: PK_CKTS_JGB_BA_WMZHFWDBTS (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_JGB_BA_WMZHFWDBTS` (
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `lcslid` CHAR(32) COMMENT '流程实例ID',
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID||uuid',
  `nsrmc` VARCHAR(300) COMMENT '纳税人名称',
  `hgqy_dm` VARCHAR(50) COMMENT '海关企业代码',
  `nsrsbh` VARCHAR(20) COMMENT '纳税人识别号',
  `shxydm` VARCHAR(20) COMMENT '社会信用代码',
  `wtdbtsscqynsrmc` VARCHAR(300) COMMENT '委托代办退税生产企业纳税人名称',
  `wtdbtsscqyhgqydm` VARCHAR(50) COMMENT '委托代办退税生产企业海关企业代码',
  `wtdbtsscqynsrsbh` VARCHAR(20) COMMENT '委托代办退税生产企业纳税人识别号',
  `wtdbtsscqyshxydm` VARCHAR(20) COMMENT '委托代办退税生产企业社会信用代码',
  `wmzhfwhtxyhm` VARCHAR(60) COMMENT '外贸综合服务合同（协议）号码',
  `wtdbtsscqydbtskhyhmc` VARCHAR(120) COMMENT '委托代办退税生产企业代办退税开户银行名称',
  `wtdbtsscqydbtskhyhzh` VARCHAR(50) COMMENT '委托代办退税生产企业代办退税开户银行账号',
  `fddbrxm` VARCHAR(150) COMMENT '法定代表人姓名',
  `dbtsbalczt_dm` CHAR(1) COMMENT '代办退税备案流程状态代码',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `bachbz` CHAR(1) COMMENT '备案撤回标志||备案撤回标志',
  `bachrq` DATETIME COMMENT '备案撤回日期',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `tskhyhmc` VARCHAR(120) COMMENT '退税开户银行名称',
  `tskhyhzh` VARCHAR(50) COMMENT '退税开户银行账号',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  KEY `IDX_CKTS_JGB_BA_WMZHFWDBTS_D` (`DJXH`),
  KEY `IDX_CKTS_JGB_BA_WMZHFWDBTS_L` (`LCSLID`),
  KEY `IDX_CKTS_JGB_BA_WMZHFWDBTS_WT` (`WTDBTSSCQYNSRSBH`),
  CONSTRAINT `PK_CKTS_JGB_BA_WMZHFWDBTS` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='外贸综合服务代办退税备案结果表';

-- Creating table CKTS_JGB_BA_XTHHZG
CREATE TABLE `CKTS_JGB_BA_XTHHZG` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID||uuid',
  `lcslid` CHAR(32) NOT NULL COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `sbxh` VARCHAR(50) NOT NULL COMMENT '申报序号',
  `ckhth` VARCHAR(60) NOT NULL COMMENT '出口合同号',
  `wsdwmc` VARCHAR(300) NOT NULL COMMENT '外商单位名称',
  `cksp_dm` VARCHAR(20) NOT NULL COMMENT '出口商品代码',
  `ckspmc` VARCHAR(75) NOT NULL COMMENT '出口商品名称',
  `tcrq` DATETIME NOT NULL COMMENT '投产日期',
  `wgrq` DATETIME NOT NULL COMMENT '完工日期',
  `ckemy` DECIMAL(18,2) NOT NULL COMMENT '出口额（美元）',
  `yjskcs` DECIMAL(10,0) NOT NULL COMMENT '预计收款次数',
  `dycskbl` DECIMAL(10,6) NOT NULL COMMENT '第一次收款比例',
  `decskbl` DECIMAL(10,6) NOT NULL COMMENT '第二次收款比例',
  `qyskbl` DECIMAL(10,6) NOT NULL COMMENT '其余收款比例',
  `cktmsywlxdmjh` VARCHAR(30) NOT NULL COMMENT '出口退（免）税业务类型代码集合',
  `cktmsywlxmcjh` VARCHAR(75) COMMENT '出口退（免）税业务类型名称集合',
  `bz` VARCHAR(3000) COMMENT '备注',
  `zfbz_1` CHAR(1) COMMENT '作废标志',
  `lrr_dm` CHAR(11) NOT NULL COMMENT '录入人代码',
  `lrrq` DATETIME NOT NULL COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `tsswjg_dm_1` CHAR(11) NOT NULL COMMENT '退税税务机关代码',
  `sjgsdq` CHAR(11) NOT NULL COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `sbljje` DECIMAL(18,2) COMMENT '申报累计金额',
  `cjljje` DECIMAL(18,2) COMMENT '冲减累计金额',
  `nd` VARCHAR(10) COMMENT '年度'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='先退税后核销资格申请结果表';

-- Creating table CKTS_JGB_SB_MDT_XTHHZG
-- Original Oracle primary-key constraint: PK_CKTS_JGB_SB_MDT_XTHHZG (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_JGB_SB_MDT_XTHHZG` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID||uuid',
  `lcslid` CHAR(32) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `ckhth` VARCHAR(60) COMMENT '出口合同号',
  `wsdwmc` VARCHAR(300) COMMENT '外商单位名称',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `ckspmc` VARCHAR(75) COMMENT '出口商品名称',
  `tcrq` DATETIME COMMENT '投产日期',
  `wgrq` DATETIME COMMENT '完工日期',
  `ckemy` DECIMAL(18,2) COMMENT '出口额（美元）',
  `yjskcs` DECIMAL(10,0) COMMENT '预计收款次数',
  `dycskbl` DECIMAL(10,6) COMMENT '第一次收款比例',
  `decskbl` DECIMAL(10,6) COMMENT '第二次收款比例',
  `qyskbl` DECIMAL(10,6) COMMENT '其余收款比例',
  `cktmsywlxdmjh` VARCHAR(30) COMMENT '出口退（免）税业务类型代码集合',
  `cktmsywlxmcjh` VARCHAR(75) COMMENT '出口退（免）税业务类型名称集合',
  `bz` VARCHAR(3000) COMMENT '备注',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `zfbz_1` CHAR(1) DEFAULT 'N' COMMENT '作废标志',
  `zfr_dm` CHAR(11) COMMENT '作废人代码',
  `zfsj` DATETIME COMMENT '作废时间||作废时间',
  `sbljje` DECIMAL(18,2) COMMENT '申报累计金额',
  `cjljje` DECIMAL(18,2) COMMENT '冲减累计金额',
  `nd` VARCHAR(10) COMMENT '年度',
  KEY `IDX_CKTS_JGB_SB_MDT_XTHHZG_D` (`DJXH`),
  KEY `IDX_CKTS_JGB_SB_MDT_XTHHZG_L` (`LCSLID`),
  CONSTRAINT `PK_CKTS_JGB_SB_MDT_XTHHZG` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='先退税后核销资格申请结果表';

-- Creating table CKTS_JGB_ZM_LLJG
CREATE TABLE `CKTS_JGB_ZM_LLJG` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID||uuid',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `lljgmszmbh` VARCHAR(20) COMMENT '来料加工免税证明编号',
  `xh_4` VARCHAR(10) COMMENT '项号',
  `lljgszch` VARCHAR(20) COMMENT '来料加工手（账）册号',
  `jgffphm` VARCHAR(30) COMMENT '加工费发票号码',
  `ykfphwmc` VARCHAR(150) COMMENT '已开发票货物名称',
  `ykfphwdw` VARCHAR(75) COMMENT '已开发票货物单位',
  `ykfphwsl` DECIMAL(17,5) COMMENT '已开发票货物数量',
  `jgfje` DECIMAL(18,2) COMMENT '加工费金额',
  `kjbz` CHAR(1) COMMENT '开具标志',
  `zfbz_1` CHAR(1) COMMENT '作废标志',
  KEY `IDX_CKTS_JGB_ZM_LLJG_DJXH_SZCH` (`DJXH`, `LLJGSZCH`),
  KEY `IDX_CKTS_JGB_ZM_LLJG_DJXH_ZMBH` (`DJXH`, `LLJGMSZMBH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='来料加工免税证明结果表';

-- Creating table CKTS_JGB_ZM_TYYBSWTS
-- Original Oracle primary-key constraint: PK_CKTS_JGB_ZM_TYYBSWTS (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_JGB_ZM_TYYBSWTS` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `lcslid` CHAR(32) COMMENT '流程实例ID',
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID||uuid',
  `cktszmbh` VARCHAR(20) COMMENT '出口退税证明编号',
  `wtfcktszmbh` VARCHAR(20) COMMENT '委托方出口退税证明编号',
  `dlckhwzmhm` VARCHAR(20) COMMENT '代理出口货物证明号码',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `ckshhxdh` VARCHAR(30) COMMENT '出口收汇核销单号',
  `ckfph` VARCHAR(30) COMMENT '出口发票号',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `ckspmc` VARCHAR(75) COMMENT '出口商品名称',
  `hgjldwmc` VARCHAR(75) COMMENT '海关计量单位名称',
  `cksl` DECIMAL(17,5) COMMENT '出口数量',
  `hggqka_dm` CHAR(4) COMMENT '海关关区（口岸）代码',
  `yjsje` DECIMAL(18,2) COMMENT '原计税金额',
  `ysbmdtse` DECIMAL(18,6) COMMENT '原申报免抵退税额',
  `ytzzse_1` DECIMAL(18,6) COMMENT '原退增值税额',
  `ytxfse_1` DECIMAL(18,6) COMMENT '原退消费税额',
  `jhpzh` VARCHAR(75) COMMENT '进货凭证号',
  `tysl` DECIMAL(17,5) COMMENT '退运数量',
  `tyjsje` DECIMAL(18,2) COMMENT '退运计税金额',
  `ytsl_1` DECIMAL(16,6) COMMENT '原退税率',
  `ycjmdtse` DECIMAL(18,2) COMMENT '已冲减免抵退税额||应用于进出口退税',
  `cjssq` VARCHAR(60) COMMENT '冲减所属期',
  `ybzzse_1` DECIMAL(18,6) COMMENT '已补增值税额',
  `ybxfse_1` DECIMAL(18,6) COMMENT '已补消费税额',
  `jkshm` VARCHAR(20) COMMENT '缴款书号码',
  `rkrq` DATETIME COMMENT '入库日期',
  `tyybswtstylx_dm` CHAR(1) COMMENT '退运已补税（未退税）退运类型代码',
  `ysybs` CHAR(1) COMMENT '已使用标识',
  `bz` VARCHAR(3000) COMMENT '备注',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `sjgsdq` CHAR(11) NOT NULL COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `sbbh_1` VARCHAR(20) COMMENT '申报编号',
  `zfbz_1` CHAR(1) COMMENT '作废标志',
  `zfr_dm` CHAR(11) COMMENT '作废人代码',
  `zfsj` DATETIME COMMENT '作废时间||作废时间',
  `xh_4` VARCHAR(10) COMMENT '项号',
  `sbny` CHAR(6) COMMENT '申报年月',
  `ckemy` DECIMAL(18,2) COMMENT '出口额（美元）',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `hsjg` VARCHAR(20) COMMENT '核实结果',
  `sz` CHAR(1) COMMENT '税种',
  `tmsztbz` VARCHAR(50) COMMENT '退（免）税状态标志',
  `ybjtmsk` DECIMAL(18,6) COMMENT '应补缴退（免）税款',
  `ywclfs` VARCHAR(20) COMMENT '业务处理方式',
  `kjbz` CHAR(1) COMMENT '开具标志',
  `kjrq` DATETIME COMMENT '开具日期',
  `kjr_dm` CHAR(11) COMMENT '开具人代码',
  KEY `IDX_CKTS_JGB_ZM_TYYBSWTS_DJXH` (`DJXH`),
  KEY `IDX_CKTS_JGB_ZM_TYYBSWTS_L` (`LCSLID`),
  KEY `IDX_CKTS_JGB_ZM_TYYBSWTS_SCC` (`SSQ`, `CKTSZMBH`, `CJSSQ`),
  CONSTRAINT `PK_CKTS_JGB_ZM_TYYBSWTS` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口货物退运已补税(未退税)证明结果表';

-- Creating table CKTS_SB_BNSHSB_LSB
CREATE TABLE `CKTS_SB_BNSHSB_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `ckfph` VARCHAR(30) COMMENT '出口发票号',
  `jckxszrq` DATETIME COMMENT '记出口销售账日期',
  `cjzj` DECIMAL(18,2) COMMENT '成交总价||成交总价',
  `cjhbhl` DECIMAL(16,6) COMMENT '成交货币汇率',
  `ckxsermb` DECIMAL(18,2) COMMENT '出口销售额（人民币）',
  `ckshhbzm_dm` CHAR(3) COMMENT '出口收汇货币字母代码',
  `yshje` DECIMAL(18,2) COMMENT '已收汇金额',
  `wshje` DECIMAL(18,2) COMMENT '未收汇金额',
  `wshbl` DECIMAL(10,6) COMMENT '未收汇比例',
  `bnshyy_dm` CHAR(2) COMMENT '不能收汇原因代码',
  `bnshyymc` VARCHAR(150) COMMENT '不能收汇原因名称',
  `htydqbshzzrq` DATETIME COMMENT '合同约定全部收汇最终日期',
  `ckhth` VARCHAR(60) COMMENT '出口合同号',
  `bz` VARCHAR(3000) COMMENT '备注',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `lrrq` DATETIME COMMENT '录入日期',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `cjhbzm_dm` CHAR(3) COMMENT '成交货币字母代码',
  `tgzmclzl` VARCHAR(300) COMMENT '提供证明材料种类',
  KEY `IDX_CKTS_SB_BNSHSB_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_BNSHSB_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='非收汇企业申报不能收汇申报临时表';

-- Creating table CKTS_SB_DB_CKHWBNSH_LSB
CREATE TABLE `CKTS_SB_DB_CKHWBNSH_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `ckfph` VARCHAR(30) COMMENT '出口发票号',
  `jckxszrq` DATETIME COMMENT '记出口销售账日期',
  `cjhbzm_dm` CHAR(3) COMMENT '成交货币字母代码',
  `cjzj` DECIMAL(18,2) COMMENT '成交总价||成交总价',
  `cjhbhl` DECIMAL(16,6) COMMENT '成交货币汇率',
  `ckxsermb` DECIMAL(18,2) COMMENT '出口销售额（人民币）',
  `ckshhbzm_dm` CHAR(3) COMMENT '出口收汇货币字母代码',
  `yshje` DECIMAL(18,2) COMMENT '已收汇金额',
  `wshje` DECIMAL(18,2) COMMENT '未收汇金额',
  `wshbl` DECIMAL(10,6) COMMENT '未收汇比例',
  `bnshyy_dm` CHAR(2) COMMENT '不能收汇原因代码',
  `bnshyymc` VARCHAR(150) COMMENT '不能收汇原因名称',
  `tgzmclzl` VARCHAR(300) COMMENT '提供证明材料种类',
  `htydqbshzzrq` DATETIME COMMENT '合同约定全部收汇最终日期',
  `ckhth` VARCHAR(60) COMMENT '出口合同号',
  `bz` VARCHAR(3000) COMMENT '备注',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgrq` DATETIME COMMENT '修改日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  KEY `IDX_CKTS_SB_DB_CKHWBNSH_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_DB_CKHWBNSH_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='外贸综合服务出口收汇不能收汇明细临时表';

-- Creating table CKTS_SB_DB_CKHWSH_LSB
CREATE TABLE `CKTS_SB_DB_CKHWSH_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `sbxh` VARCHAR(50) COMMENT '退免税申报情况||申报序号',
  `ckbgdh` VARCHAR(21) COMMENT '退免税申报情况||出口报关单号',
  `ckfph` VARCHAR(30) COMMENT '退免税申报情况||出口发票号',
  `jckxszrq` DATETIME COMMENT '记出口销售账日期',
  `cjhbzm_dm` CHAR(3) COMMENT '退免税申报情况||成交货币字母代码',
  `cjzj` DECIMAL(18,2) COMMENT '退免税申报情况||成交总价',
  `cjhbhl` DECIMAL(16,6) COMMENT '成交货币汇率',
  `ckxsermb` DECIMAL(18,2) COMMENT '退免税申报情况||出口销售额（人民币）',
  `pzhm_2` VARCHAR(40) COMMENT '已收汇情况||凭证号码',
  `ckshrq` DATETIME COMMENT '已收汇情况||出口收汇日期',
  `jhfs_dm` CHAR(1) COMMENT '结汇方式代码',
  `yhywbh` VARCHAR(50) COMMENT '银行业务编号',
  `ckshhbzm_dm` CHAR(3) COMMENT '已收汇情况||出口收汇货币字母代码',
  `ckshje` DECIMAL(18,2) COMMENT '已收汇情况||出口收汇金额',
  `ckshhbhl` DECIMAL(16,6) COMMENT '出口收汇货币汇率',
  `ckshjermb` DECIMAL(18,2) COMMENT '已收汇情况||出口收汇金额（人民币）',
  `fhr` VARCHAR(300) COMMENT '已收汇情况||付汇人',
  `fhgjdq` VARCHAR(300) COMMENT '付汇国家（地区）',
  `fjksfhyy` VARCHAR(75) COMMENT '已收汇情况||非进口商付汇原因',
  `fjkgjdqfhyy` VARCHAR(75) COMMENT '非进口国家（地区）付汇原因',
  `bz` VARCHAR(3000) COMMENT '退免税申报情况||备注',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgrq` DATETIME COMMENT '修改日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `jrjgdm` VARCHAR(20) COMMENT '金融机构代码',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `dlckhwzmhm` VARCHAR(20) COMMENT '退免税申报情况||代理出口货物证明号码',
  `yshqkpzzje` DECIMAL(18,2) COMMENT '已收汇情况||凭证总金额',
  `stshqkyy` VARCHAR(100) COMMENT '视同收汇情况||原因',
  `stshqkyyjtsm` VARCHAR(4000) COMMENT '视同收汇情况||原因具体说明',
  `stshqkjzclzl` VARCHAR(100) COMMENT '视同收汇情况||举证材料种类',
  `stshqkzrmbje` DECIMAL(18,2) COMMENT '视同收汇情况||折人民币金额',
  `stshqkhtydqbshzzrq` DATETIME COMMENT '视同收汇情况||合同约定全部收汇最终日期',
  `stshqkckhth` VARCHAR(60) COMMENT '视同收汇情况||出口合同号',
  KEY `IDX_CKTS_SB_DB_CKHWSH_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_DB_CKHWSH_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='外贸综合服务出口货物收汇申报临时表';

-- Creating table CKTS_SB_DB_HGSPTZ_LSB
CREATE TABLE `CKTS_SB_DB_HGSPTZ_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `hgspmc` VARCHAR(500) COMMENT '海关商品名称',
  `tsl` DECIMAL(16,6) COMMENT '退税率',
  `tzhcksp_dm` VARCHAR(20) COMMENT '调整后出口商品代码',
  `tzhhgspmc` VARCHAR(500) COMMENT '调整后海关商品名称',
  `tzhtsl` DECIMAL(16,6) COMMENT '调整后退税率',
  `dlckhwzmhm` VARCHAR(20) COMMENT '代理出口货物证明号码',
  `bz` VARCHAR(3000) COMMENT '备注',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgrq` DATETIME COMMENT '修改日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `hgckhwbgdsbrq` DATETIME COMMENT '海关出口货物报关单申报日期',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `sbhgspmc` VARCHAR(500) COMMENT '申报海关商品名称||申报海关商品名称',
  KEY `IDX_CKTS_SB_DB_HGSPTZ_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_DB_HGSPTZ_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='外贸综合服务海关出口商品调整对照临时表';

-- Creating table CKTS_SB_DB_TSSB_LSB
CREATE TABLE `CKTS_SB_DB_TSSB_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `wtdbtsscqynsrsbh` VARCHAR(20) COMMENT '委托代办退税生产企业纳税人识别号',
  `wtdbtsscqyshxydm` VARCHAR(20) COMMENT '委托代办退税生产企业社会信用代码',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `hgspmc` VARCHAR(500) COMMENT '海关商品名称',
  `hgjldwmc` VARCHAR(75) COMMENT '海关计量单位名称',
  `sbsp_dm` VARCHAR(20) COMMENT '申报商品代码',
  `sbspmc` VARCHAR(500) COMMENT '申报商品名称',
  `cksl` DECIMAL(17,5) COMMENT '出口数量',
  `mylaj` DECIMAL(18,2) COMMENT '美元离岸价',
  `dbtswspzhm` VARCHAR(40) COMMENT '代办退税完税凭证号码',
  `dbtsfpzs` DECIMAL(10,0) COMMENT '代办退税发票（张数）',
  `kprq` DATETIME COMMENT '开票日期',
  `jsje` DECIMAL(18,2) COMMENT '计税金额',
  `zssl` DECIMAL(16,6) COMMENT '征税税率',
  `tsl` DECIMAL(16,6) COMMENT '退税率',
  `tse` DECIMAL(18,6) COMMENT '退税额',
  `cktmsywlxdmjh` VARCHAR(30) COMMENT '出口退（免）税业务类型代码集合',
  `cktmsywlxmcjh` VARCHAR(75) COMMENT '出口退（免）税业务类型名称集合',
  `dbtsywlx_dm` VARCHAR(20) COMMENT '代办退税业务类型代码',
  `dbtsywlxmc` VARCHAR(75) COMMENT '代办退税业务类型名称',
  `bz` VARCHAR(3000) COMMENT '备注',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `dlsbjbr` VARCHAR(150) COMMENT '代理申报经办人',
  `sqrmc` VARCHAR(300) COMMENT '授权人名称',
  `sqrq_1` DATETIME COMMENT '授权日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgrq` DATETIME COMMENT '修改日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `jbrxm` VARCHAR(75) COMMENT '经办人姓名',
  `fpdm` VARCHAR(12) COMMENT '代办退税发票代码（信息比对的时候通过JHPZH分解）',
  `fphm` VARCHAR(8) COMMENT '代办退税发票号码（信息比对的时候通过JHPZH分解）',
  `hgcode` VARCHAR(4),
  `gbcode` VARCHAR(3),
  `zzmdg` VARCHAR(3),
  `hzdwdqdm` VARCHAR(5),
  `sbdwdm` VARCHAR(10),
  `gnqyfs_dm` VARCHAR(2) COMMENT '国内启运方式代码',
  `hgzsrzqylx_dm` VARCHAR(2) COMMENT '海关总署认证企业类型代码',
  KEY `IDX_CKTS_SB_DB_TSSB_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_DB_TSSB_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='外贸综合服务代办退税申报临时表';

-- Creating table CKTS_SB_FZC_BNSH_LSB
CREATE TABLE `CKTS_SB_FZC_BNSH_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75),
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `ckfph` VARCHAR(30) COMMENT '出口发票号',
  `jckxszrq` DATETIME COMMENT '记出口销售账日期',
  `cjhbzm_dm` CHAR(3) COMMENT '成交货币字母代码',
  `cjzj` DECIMAL(18,2) COMMENT '成交总价||成交总价',
  `cjhbhl` DECIMAL(16,6) COMMENT '成交货币汇率',
  `ckxsermb` DECIMAL(18,2) COMMENT '出口销售额（人民币）',
  `ckshhbzm_dm` CHAR(3) COMMENT '出口收汇货币字母代码',
  `yshje` DECIMAL(18,2) COMMENT '已收汇金额',
  `wshje` DECIMAL(18,2) COMMENT '未收汇金额',
  `wshbl` DECIMAL(10,6) COMMENT '未收汇比例',
  `bnshyy_dm` CHAR(2) COMMENT '不能收汇原因代码',
  `bnshyymc` VARCHAR(150) COMMENT '不能收汇原因名称',
  `tgzmclzl` VARCHAR(300) COMMENT '提供证明材料种类',
  `htydqbshzzrq` DATETIME COMMENT '合同约定全部收汇最终日期',
  `ckhth` VARCHAR(60) COMMENT '出口合同号',
  `bz` VARCHAR(3000) COMMENT '备注',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  KEY `IDX_CKTS_SB_FZC_BNSH_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_FZC_BNSH_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口非自产货物退消费税不能收汇申报临时表';

-- Creating table CKTS_SB_FZC_CKSH_LSB
CREATE TABLE `CKTS_SB_FZC_CKSH_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75),
  `sbxh` VARCHAR(50) COMMENT '退免税申报情况||申报序号',
  `ckbgdh` VARCHAR(21) COMMENT '退免税申报情况||出口报关单号',
  `ckfph` VARCHAR(30) COMMENT '退免税申报情况||出口发票号',
  `jckxszrq` DATETIME COMMENT '记出口销售账日期',
  `cjhbzm_dm` CHAR(3) COMMENT '退免税申报情况||成交货币字母代码',
  `cjzj` DECIMAL(18,2) COMMENT '退免税申报情况||成交总价',
  `cjhbhl` DECIMAL(16,6) COMMENT '成交货币汇率',
  `ckxsermb` DECIMAL(18,2) COMMENT '退免税申报情况||出口销售额（人民币）',
  `pzhm_2` VARCHAR(40) COMMENT '已收汇情况||凭证号码',
  `ckshrq` DATETIME COMMENT '已收汇情况||出口收汇日期',
  `jhfs_dm` CHAR(1) COMMENT '结汇方式代码',
  `jrjgdm` VARCHAR(20) COMMENT '金融机构代码',
  `yhywbh` VARCHAR(50) COMMENT '银行业务编号',
  `ckshhbzm_dm` CHAR(3) COMMENT '已收汇情况||出口收汇货币字母代码',
  `ckshje` DECIMAL(18,2) COMMENT '已收汇情况||出口收汇金额',
  `ckshhbhl` DECIMAL(16,6) COMMENT '出口收汇货币汇率',
  `ckshjermb` DECIMAL(18,2) COMMENT '已收汇情况||出口收汇金额（人民币）',
  `fhr` VARCHAR(300) COMMENT '已收汇情况||付汇人',
  `fhgjdq` VARCHAR(300) COMMENT '付汇国家（地区）',
  `fjksfhyy` VARCHAR(75) COMMENT '已收汇情况||非进口商付汇原因',
  `fjkgjdqfhyy` VARCHAR(75) COMMENT '非进口国家（地区）付汇原因',
  `bz` VARCHAR(3000) COMMENT '退免税申报情况||备注',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `dlckhwzmhm` VARCHAR(20) COMMENT '退免税申报情况||代理出口货物证明号码',
  `yshqkpzzje` DECIMAL(18,2) COMMENT '已收汇情况||凭证总金额',
  `stshqkyy` VARCHAR(100) COMMENT '视同收汇情况||原因',
  `stshqkyyjtsm` VARCHAR(4000) COMMENT '视同收汇情况||原因具体说明',
  `stshqkjzclzl` VARCHAR(100) COMMENT '视同收汇情况||举证材料种类',
  `stshqkzrmbje` DECIMAL(18,2) COMMENT '视同收汇情况||折人民币金额',
  `stshqkhtydqbshzzrq` DATETIME COMMENT '视同收汇情况||合同约定全部收汇最终日期',
  `stshqkckhth` VARCHAR(60) COMMENT '视同收汇情况||出口合同号',
  KEY `IDX_CKTS_SB_FZC_CKSH_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_FZC_CKSH_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口非自产货物退消费税收汇申报明细临时表';

-- Creating table CKTS_SB_FZC_HGSPTZ_LSB
CREATE TABLE `CKTS_SB_FZC_HGSPTZ_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75),
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `tsl` DECIMAL(16,6) COMMENT '退税率',
  `tzhcksp_dm` VARCHAR(20) COMMENT '调整后出口商品代码',
  `tzhhgspmc` VARCHAR(500) COMMENT '调整后海关商品名称',
  `tzhtsl` DECIMAL(16,6) COMMENT '调整后退税率',
  `dlckhwzmhm` VARCHAR(20) COMMENT '代理出口货物证明号码',
  `bz` VARCHAR(3000) COMMENT '备注',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `sbhgspmc` VARCHAR(500) COMMENT '申报海关商品名称||申报海关商品名称',
  `hgckhwbgdsbrq` DATETIME COMMENT '海关出口货物报关单申报日期',
  `tbrq_1` DATETIME COMMENT '填表日期',
  KEY `IDX_CKTS_SB_FZC_HGSPTZ_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_FZC_HGSPTZ_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口非自产货物退消费税海关出口商品代码名称退税率调整对应申报临时表';

-- Creating table CKTS_SB_FZC_SBMX_LSB
CREATE TABLE `CKTS_SB_FZC_SBMX_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75),
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `xfspzh` VARCHAR(40) COMMENT '消费税凭证号',
  `kprq` DATETIME COMMENT '开票日期',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `hgjldwmc` VARCHAR(75) COMMENT '海关计量单位名称',
  `sl` DECIMAL(17,5) COMMENT '数量',
  `zssl` DECIMAL(16,6) COMMENT '征税税率',
  `jsje` DECIMAL(18,2) COMMENT '计税金额',
  `se` DECIMAL(18,6) COMMENT '税额',
  `xfstse` DECIMAL(18,6) COMMENT '消费税退税额',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `dlckhwzmhm` VARCHAR(20) COMMENT '代理出口货物证明号码',
  `cksl` DECIMAL(17,5) COMMENT '出口数量',
  `cktmsywlxdmjh` VARCHAR(30) COMMENT '出口退（免）税业务类型代码集合',
  `cktmsywlxmcjh` VARCHAR(75) COMMENT '出口退（免）税业务类型名称集合',
  `bz` VARCHAR(3000) COMMENT '备注',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `sbhgspmc` VARCHAR(500) COMMENT '申报海关商品名称||申报海关商品名称',
  `cktmspzlx_dm` CHAR(2) COMMENT '出口退(免)税凭证类型代码',
  `gnqyfs_dm` VARCHAR(2) COMMENT '国内启运方式代码',
  `hgzsrzqylx_dm` VARCHAR(2) COMMENT '海关总署认证企业类型代码',
  KEY `IDX_CKTS_SB_FZC_SBMX_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_FZC_SBMX_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口非自产货物退消费税申报临时表';

-- Creating table CKTS_SB_GJ_SBMX_LSB
CREATE TABLE `CKTS_SB_GJ_SBMX_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75),
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `gjzyhwmc` VARCHAR(500) COMMENT '购进自用货物名称',
  `sl` DECIMAL(17,5) COMMENT '数量',
  `hgjldwmc` VARCHAR(75) COMMENT '海关计量单位名称',
  `dj` DECIMAL(18,2) COMMENT '单价',
  `jsje` DECIMAL(18,2) COMMENT '计税金额',
  `se` DECIMAL(18,6) COMMENT '税额',
  `zssl` DECIMAL(16,6) COMMENT '征税税率',
  `tse` DECIMAL(18,6) COMMENT '退税额',
  `fkpzhm` VARCHAR(40) COMMENT '付款凭证号码',
  `cktmsywlxdmjh` VARCHAR(30) COMMENT '出口退（免）税业务类型代码集合',
  `cktmsywlxmcjh` VARCHAR(75) COMMENT '出口退（免）税业务类型名称集合',
  `bz` VARCHAR(3000) COMMENT '备注',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `kprq` DATETIME COMMENT '开票日期',
  `ptfpbz` CHAR(1) COMMENT '普通发票标志',
  `ghfnsrsbh_1` VARCHAR(20) COMMENT '供货方纳税人识别号',
  `jhpzh` VARCHAR(75) COMMENT '进货凭证号',
  `jhpzzl_dm` CHAR(1) COMMENT '进货凭证种类代码',
  `zzszyfphm` VARCHAR(30) COMMENT '增值税专用发票号码',
  `fpdm` VARCHAR(12) COMMENT '发票代码（信息比对的时候通过JHPZH分解）',
  `fphm` VARCHAR(8) COMMENT '发票号码（信息比对的时候通过JHPZH分解）',
  KEY `IDX_CKTS_SB_GJ_SBMX_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_GJ_SBMX_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='购进自用货物退税申报临时表';

-- Creating table CKTS_SB_HT_SBMX_LSB
CREATE TABLE `CKTS_SB_HT_SBMX_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75),
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `jhpzh` VARCHAR(75) COMMENT '进货凭证号',
  `sl` DECIMAL(17,5) COMMENT '数量',
  `hgjldwmc` VARCHAR(75) COMMENT '海关计量单位名称',
  `dj` DECIMAL(18,2) COMMENT '单价',
  `jsje` DECIMAL(18,2) COMMENT '计税金额',
  `se` DECIMAL(18,6) COMMENT '税额',
  `zssl` DECIMAL(16,6) COMMENT '征税税率',
  `tse` DECIMAL(18,6) COMMENT '退税额',
  `cktmsywlxdmjh` VARCHAR(30) COMMENT '出口退（免）税业务类型代码集合',
  `cktmsywlxmcjh` VARCHAR(75) COMMENT '出口退（免）税业务类型名称集合',
  `bz` VARCHAR(3000) COMMENT '备注',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `sbhgspmc` VARCHAR(500) COMMENT '申报海关商品名称||申报海关商品名称',
  `kprq` DATETIME COMMENT '开票日期',
  `cktmspzlx_dm` CHAR(2) COMMENT '出口退(免)税凭证类型代码',
  KEY `IDX_CKTS_SB_HT_SBMX_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_HT_SBMX_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='航天发射退税申报临时表';

-- Creating table CKTS_SB_MDT_BNSH_LSB
CREATE TABLE `CKTS_SB_MDT_BNSH_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75),
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `ckfph` VARCHAR(30) COMMENT '出口发票号',
  `jckxszrq` DATETIME COMMENT '记出口销售账日期',
  `cjhbzm_dm` CHAR(3) COMMENT '成交货币字母代码',
  `cjzj` DECIMAL(18,2) COMMENT '成交总价||成交总价',
  `cjhbhl` DECIMAL(16,6) COMMENT '成交货币汇率',
  `ckxsermb` DECIMAL(18,2) COMMENT '出口销售额（人民币）',
  `ckshhbzm_dm` CHAR(3) COMMENT '出口收汇货币字母代码',
  `yshje` DECIMAL(18,2) COMMENT '已收汇金额',
  `wshje` DECIMAL(18,2) COMMENT '未收汇金额',
  `wshbl` DECIMAL(10,6) COMMENT '未收汇比例',
  `bnshyy_dm` CHAR(2) COMMENT '不能收汇原因代码',
  `bnshyymc` VARCHAR(150) COMMENT '不能收汇原因名称',
  `tgzmclzl` VARCHAR(300) COMMENT '提供证明材料种类',
  `htydqbshzzrq` DATETIME COMMENT '合同约定全部收汇最终日期',
  `ckhth` VARCHAR(60) COMMENT '出口合同号',
  `bz` VARCHAR(3000) COMMENT '备注',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `tbrq_1` DATETIME COMMENT '填表日期',
  KEY `IDX_CKTS_SB_MDT_BNSH_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_MDT_BNSH_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='免抵退出口货物不能收汇申报(临时表)';

-- Creating table CKTS_SB_MDT_CKSH_LSB
CREATE TABLE `CKTS_SB_MDT_CKSH_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75),
  `sbxh` VARCHAR(50) COMMENT '退免税申报情况||申报序号',
  `ckbgdh` VARCHAR(21) COMMENT '退免税申报情况||出口报关单号',
  `ckfph` VARCHAR(30) COMMENT '退免税申报情况||出口发票号',
  `jckxszrq` DATETIME COMMENT '记出口销售账日期',
  `cjhbzm_dm` CHAR(3) COMMENT '退免税申报情况||成交货币字母代码',
  `cjzj` DECIMAL(18,2) COMMENT '退免税申报情况||成交总价',
  `cjhbhl` DECIMAL(16,6) COMMENT '成交货币汇率',
  `ckxsermb` DECIMAL(18,2) COMMENT '退免税申报情况||出口销售额（人民币）',
  `pzhm_2` VARCHAR(40) COMMENT '已收汇情况||凭证号码',
  `ckshrq` DATETIME COMMENT '已收汇情况||出口收汇日期',
  `jhfs_dm` CHAR(1) COMMENT '结汇方式代码',
  `jrjgdm` VARCHAR(20) COMMENT '金融机构代码',
  `yhywbh` VARCHAR(50) COMMENT '银行业务编号',
  `ckshhbzm_dm` CHAR(3) COMMENT '已收汇情况||出口收汇货币字母代码',
  `ckshje` DECIMAL(18,2) COMMENT '已收汇情况||出口收汇金额',
  `ckshhbhl` DECIMAL(16,6) COMMENT '出口收汇货币汇率',
  `ckshjermb` DECIMAL(18,2) COMMENT '已收汇情况||出口收汇金额（人民币）',
  `fhr` VARCHAR(300) COMMENT '已收汇情况||付汇人',
  `fhgjdq` VARCHAR(300) COMMENT '付汇国家（地区）',
  `fjksfhyy` VARCHAR(75) COMMENT '已收汇情况||非进口商付汇原因',
  `fjkgjdqfhyy` VARCHAR(75) COMMENT '非进口国家（地区）付汇原因',
  `bz` VARCHAR(3000) COMMENT '退免税申报情况||备注',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `dlckhwzmhm` VARCHAR(20) COMMENT '退免税申报情况||代理出口货物证明号码',
  `yshqkpzzje` DECIMAL(18,2) COMMENT '已收汇情况||凭证总金额',
  `stshqkyy` VARCHAR(100) COMMENT '视同收汇情况||原因',
  `stshqkyyjtsm` VARCHAR(4000) COMMENT '视同收汇情况||原因具体说明',
  `stshqkjzclzl` VARCHAR(100) COMMENT '视同收汇情况||举证材料种类',
  `stshqkzrmbje` DECIMAL(18,2) COMMENT '视同收汇情况||折人民币金额',
  `stshqkhtydqbshzzrq` DATETIME COMMENT '视同收汇情况||合同约定全部收汇最终日期',
  `stshqkckhth` VARCHAR(60) COMMENT '视同收汇情况||出口合同号',
  KEY `IDX_CKTS_SB_MDT_CKSH_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_MDT_CKSH_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='免抵退出口货物收汇申报(临时表)';

-- Creating table CKTS_SB_MDT_CYSM_LSB
CREATE TABLE `CKTS_SB_MDT_CYSM_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `lajcysblx_dm` CHAR(1) COMMENT '离岸价差异申报类型代码',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `ckfph` VARCHAR(30) COMMENT '出口发票号',
  `ckfpmylaj` DECIMAL(18,2) COMMENT '出口发票美元离岸价',
  `ckfprmblaj` DECIMAL(18,2) COMMENT '出口发票人民币离岸价',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `dlckhwzmhm` VARCHAR(20) COMMENT '代理出口货物证明号码',
  `mylaj` DECIMAL(18,2) COMMENT '美元离岸价',
  `rmblaj` DECIMAL(18,2) COMMENT '人民币离岸价',
  `ckfphckbgdrmblajcye` DECIMAL(18,2) COMMENT '出口发票和出口报关单人民币离岸价差异额',
  `ckfphckbgdrmblajcyl` DECIMAL(22,6) COMMENT '出口发票和出口报关单人民币离岸价差异率',
  `yysm` VARCHAR(4000) COMMENT '原因说明',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `sbpc` VARCHAR(75),
  `ssq` VARCHAR(60) COMMENT '所属期',
  KEY `IDX_CKTS_SB_MDT_CYSM_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_MDT_CYSM_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口货物离岸价差异说明(临时表)';

-- Creating table CKTS_SB_MDT_GJYS_LSB
CREATE TABLE `CKTS_SB_MDT_GJYS_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75),
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `ysfw_dm` VARCHAR(20) COMMENT '应税服务代码',
  `ysfwmc` VARCHAR(500) COMMENT '应税服务名称',
  `bcyscs` DECIMAL(10,0) COMMENT '本次运输次数',
  `zycdfs` DECIMAL(10,0) COMMENT '自运舱单份数',
  `zytdydfshzkrs` DECIMAL(10,0) COMMENT '自运提单（运单）份数或载客人数',
  `ysfwyyermb` DECIMAL(18,2) COMMENT '应税服务营业额（人民币）',
  `zssl` DECIMAL(16,6) COMMENT '征税税率',
  `tsl` DECIMAL(16,6) COMMENT '退税率',
  `ztsce` DECIMAL(18,6) COMMENT '征退税差额',
  `ytse_1` DECIMAL(18,6) COMMENT '应退税额',
  `hth` VARCHAR(60) COMMENT '合同号',
  `bz` VARCHAR(3000) COMMENT '备注',
  `ckfph` VARCHAR(30) COMMENT '出口发票号',
  `kprq` DATETIME COMMENT '开票日期',
  `myhl` DECIMAL(16,6) COMMENT '美元汇率',
  `ysfwyyemy` DECIMAL(18,2) COMMENT '应税服务营业额（美元）',
  `mdtsny` CHAR(6) COMMENT '免抵退税年月',
  `cjhbzm_dm` CHAR(3) COMMENT '成交货币字母代码',
  `cjzj` DECIMAL(18,2) COMMENT '成交总价||成交总价',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `ysfwyyezfgfsdnsrjk` DECIMAL(18,2) COMMENT '应税服务营业额支付给非试点纳税人价款',
  `ysfwyyemdtsjsje` DECIMAL(18,2) COMMENT '应税服务营业额免抵退税计税金额',
  `zbblny` VARCHAR(6) COMMENT '暂不办理年月',
  `bytsny` CHAR(6) COMMENT '不予退税年月',
  `ckrq_1` DATETIME COMMENT '出口日期',
  KEY `IDX_CKTS_SB_MDT_GJYS_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_MDT_GJYS_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='国际运输明细申报(临时表)';

-- Creating table CKTS_SB_MDT_HGSPTZ_LSB
CREATE TABLE `CKTS_SB_MDT_HGSPTZ_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `ckspmc` VARCHAR(75) COMMENT '出口商品名称',
  `tsl` DECIMAL(16,6) COMMENT '退税率',
  `tzhcksp_dm` VARCHAR(20) COMMENT '调整后出口商品代码',
  `tzhhgspmc` VARCHAR(500) COMMENT '调整后海关商品名称',
  `tzhtsl` DECIMAL(16,6) COMMENT '调整后退税率',
  `dlckhwzmhm` VARCHAR(20) COMMENT '代理出口货物证明号码',
  `bz` VARCHAR(3000) COMMENT '备注',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75),
  `tbrq_1` DATETIME COMMENT '填表日期',
  `hgckhwbgdsbrq` DATETIME COMMENT '海关出口货物报关单申报日期',
  `sbhgspmc` VARCHAR(500) COMMENT '申报海关商品名称||申报海关商品名称',
  KEY `IDX_CKTS_SB_MDT_HGSPTZ_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_MDT_HGSPTZ_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='免抵退海关出口商品调整对应（临时表）';

-- Creating table CKTS_SB_MDT_HKYS_QS_LSB
CREATE TABLE `CKTS_SB_MDT_HKYS_QS_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75),
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `hkgjqszdlb_dm` CHAR(2) COMMENT '航空国际清算账单类别代码',
  `hkgjyslb_dm` CHAR(2) COMMENT '航空国际运输类别代码',
  `qszdbh` VARCHAR(32) COMMENT '清算账单编号',
  `kjrq` DATETIME COMMENT '开具日期',
  `gjhdqmc` VARCHAR(300) COMMENT '国家或地区名称',
  `hbzm_dm` CHAR(3) COMMENT '货币字母代码',
  `kpphhdhm` VARCHAR(60) COMMENT '客票票号/货单号码',
  `cjzj` DECIMAL(18,2) COMMENT '成交总价||成交总价',
  `cjhbhl` DECIMAL(16,6) COMMENT '成交货币汇率',
  `qsqkjermb` DECIMAL(18,2) COMMENT '清算情况金额（人民币）',
  `bz` VARCHAR(3000) COMMENT '备注',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  KEY `IDX_CKTS_SB_MDT_HKYS_QS_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_MDT_HKYS_QS_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='航空运输收入清算明细(临时表)';

-- Creating table CKTS_SB_MDT_KYHJ_LSB
CREATE TABLE `CKTS_SB_MDT_KYHJ_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75),
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `gjkyqshjlb_dm` CHAR(2) COMMENT '国际客运清算函件类别代码',
  `hjbh` VARCHAR(50) COMMENT '函件编号',
  `kjrq` DATETIME COMMENT '开具日期',
  `gjhdqmc` VARCHAR(300) COMMENT '国家或地区名称',
  `cjhbzm_dm` CHAR(3) COMMENT '成交货币字母代码',
  `cjzj` DECIMAL(18,2) COMMENT '成交总价||成交总价',
  `cjhbhl` DECIMAL(16,6) COMMENT '成交货币汇率',
  `gsyzfndjermb` DECIMAL(18,2) COMMENT '归属于中方（内地）金额人民币',
  `myhl` DECIMAL(16,6) COMMENT '美元汇率',
  `gsyzfndjemy` DECIMAL(18,2) COMMENT '归属于中方（内地）金额美元',
  `bz` VARCHAR(3000) COMMENT '备注',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  KEY `IDX_CKTS_SB_MDT_KYHJ_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_MDT_KYHJ_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='国际客运（含香港直通车）旅客、行李包裹运输清算函件明细受理表(临时表)';

-- Creating table CKTS_SB_MDT_SBHZ_LSB
CREATE TABLE `CKTS_SB_MDT_SBHZ_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75),
  `ckxsemy` DECIMAL(18,2) COMMENT '出口销售额（美元）',
  `ckhwxsemy` DECIMAL(18,2) COMMENT '出口货物销售额（美元）',
  `ysfwxsemy` DECIMAL(18,2) COMMENT '应税服务销售额（美元）',
  `ckxsermb` DECIMAL(18,2) COMMENT '出口销售额（人民币）',
  `mdtsbdmzhdkse` DECIMAL(18,6) COMMENT '免抵退税不得免征和抵扣税额',
  `ckhwbdmzhdkse` DECIMAL(18,6) COMMENT '出口货物不得免征和抵扣税额',
  `ysfwbdmzhdkse` DECIMAL(18,6) COMMENT '应税服务不得免征和抵扣税额',
  `jljghxytzbdmzhdkse` DECIMAL(18,6) COMMENT '进料加工核销应调整不得免征和抵扣税额',
  `mdtsbdmzhdksehj` DECIMAL(18,6) COMMENT '免抵退税不得免征和抵扣税额合计',
  `mdtse` DECIMAL(18,6) COMMENT '免抵退税额',
  `ckhwmdtse` DECIMAL(18,6) COMMENT '出口货物免抵退税额',
  `ysfwmdtse` DECIMAL(18,6) COMMENT '应税服务免抵退税额',
  `sqjzmdtse` DECIMAL(18,6) COMMENT '上期结转免抵退税额',
  `jljghxytzmdtse` DECIMAL(18,6) COMMENT '进料加工核销应调整免抵退税额',
  `mdtsehj` DECIMAL(18,6) COMMENT '免抵退税额合计',
  `jzxqmdtse` DECIMAL(18,6) COMMENT '结转下期免抵退税额',
  `zzsnssbbqmldse` DECIMAL(18,6) COMMENT '增值税纳税申报表期末留抵税额',
  `ytse_1` DECIMAL(18,6) COMMENT '应退税额',
  `mdse` DECIMAL(18,6) COMMENT '免抵税额',
  `bnljmdtckxsemy` DECIMAL(18,2) COMMENT '本年累计免抵退出口销售额（美元）',
  `bnljckhwxsemy` DECIMAL(18,2) COMMENT '本年累计出口货物销售额（美元）',
  `bnljysfwxsemy` DECIMAL(18,2) COMMENT '本年累计应税服务销售额（美元）',
  `bnljmdtckxsermb` DECIMAL(18,2) COMMENT '本年累计免抵退出口销售额（人民币）',
  `bnljmdtsbdmzhdkse` DECIMAL(18,6) COMMENT '本年累计免抵退税不得免征和抵扣税额',
  `bnljckhwbdmzhdkse` DECIMAL(18,6) COMMENT '本年累计出口货物不得免征和抵扣税额',
  `bnljysfwbdmzhdkse` DECIMAL(18,6) COMMENT '本年累计应税服务不得免征和抵扣税额',
  `bnljjljghxytzbdmzhdkse` DECIMAL(18,6) COMMENT '本年累计进料加工核销应调整不得免征和抵扣税额',
  `bnljmdtsbdmzhdksehj` DECIMAL(18,6) COMMENT '本年累计免抵退税不得免征和抵扣税额合计',
  `bnljmdtse` DECIMAL(18,6) COMMENT '本年累计免抵退税额',
  `bnljckhwmdtse` DECIMAL(18,6) COMMENT '本年累计出口货物免抵退税额',
  `bnljysfwmdtse` DECIMAL(18,6) COMMENT '本年累计应税服务免抵退税额',
  `bnljjljghxytzmdtse` DECIMAL(18,6) COMMENT '本年累计进料加工核销应调整免抵退税额',
  `bnljmdtsehj` DECIMAL(18,6) COMMENT '本年累计免抵退税额合计',
  `bnljytse` DECIMAL(18,6) COMMENT '本年累计应退税额',
  `bnljmdse` DECIMAL(18,6) COMMENT '本年累计免抵税额',
  `sqrmc` VARCHAR(300) COMMENT '授权人名称',
  `smrxm` VARCHAR(150) COMMENT '声明人姓名',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `bdmzdkseynsbce` DECIMAL(18,6) COMMENT '不得免征抵扣税额与纳税表差额',
  KEY `IDX_CKTS_SB_MDT_SBHZ_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_MDT_SBHZ_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='免抵退税申报汇总表(临时表)';

-- Creating table CKTS_SB_MDT_STZCQD_LSB
CREATE TABLE `CKTS_SB_MDT_STZCQD_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `xhfnsrsbh` VARCHAR(20) COMMENT '销货方纳税人识别号',
  `xhfnsrmc` VARCHAR(300) COMMENT '销货方纳税人名称',
  `kprq` DATETIME COMMENT '开票日期',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75),
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `mxsbxh` VARCHAR(50) COMMENT '明细申报序号',
  `jhpzh` VARCHAR(75) COMMENT '进货凭证号',
  KEY `IDX_CKTS_SB_MDT_STZCQD_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_MDT_STZCQD_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='视同自产进货明细清单临时表';

-- Creating table CKTS_SB_MDT_SYYK_LSB
CREATE TABLE `CKTS_SB_MDT_SYYK_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75),
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `hth` VARCHAR(60) COMMENT '合同号',
  `skrq` DATETIME COMMENT '收款日期',
  `skpzh` VARCHAR(60) COMMENT '收款凭证号',
  `skjermb` DECIMAL(18,2) COMMENT '收款金额（人民币）',
  `myhl` DECIMAL(16,6) COMMENT '美元汇率',
  `skyhmc` VARCHAR(120) COMMENT '收款银行名称',
  `fkdwmc` VARCHAR(150) COMMENT '付款单位名称',
  `gjhdqsz_dm` CHAR(3) COMMENT '国家或地区数字代码',
  `fkyhmc` VARCHAR(120) COMMENT '付款银行名称',
  `ljysyykrmb` DECIMAL(18,2) COMMENT '累计已收营业款（人民币）',
  `skjemy` DECIMAL(18,2) COMMENT '收款金额（美元）',
  `skpzzjemy` DECIMAL(18,2) COMMENT '收款凭证总金额（美元）',
  `ljysyykmy` DECIMAL(18,2) COMMENT '累计已收营业款（美元）',
  `hbzm_dm` CHAR(3) COMMENT '货币字母代码',
  `cjzj` DECIMAL(18,2) COMMENT '成交总价||成交总价',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `tbrq_1` DATETIME COMMENT '填表日期',
  KEY `IDX_CKTS_SB_MDT_SYYK_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_MDT_SYYK_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='提供增值税零税率应税服务收讫营业款明细清单(临时表)';

-- Creating table CKTS_SB_MDT_TLHY_LSB
CREATE TABLE `CKTS_SB_MDT_TLHY_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `yf` CHAR(2) COMMENT '月份',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `tlyslx_dm` CHAR(2) COMMENT '铁路运输类型代码',
  `tlyslxmc` VARCHAR(75) COMMENT '铁路运输类型名称',
  `hphzje` DECIMAL(18,2) COMMENT '货票汇总金额',
  `gsqttlysqyje` DECIMAL(18,2) COMMENT '归属其他铁路运输企业金额',
  `gshjcygtje` DECIMAL(18,2) COMMENT '归属汇缴成员国铁金额',
  `ykcje_1` DECIMAL(18,2) COMMENT '应扣除金额',
  `qshysfwjsje` DECIMAL(18,2) COMMENT '清算后应税服务计税金额',
  `bz` VARCHAR(3000) COMMENT '备注',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `sbpc` VARCHAR(75),
  `ssq` VARCHAR(60) COMMENT '所属期',
  KEY `IDX_CKTS_SB_MDT_TLHY_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_MDT_TLHY_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='中国国家铁路集团有限公司国际货物运输明细（临时表）';

-- Creating table CKTS_SB_MDT_TSSB_LSB
CREATE TABLE `CKTS_SB_MDT_TSSB_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75),
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `ckfph` VARCHAR(30) COMMENT '出口发票号',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `dlckhwzmhm` VARCHAR(20) COMMENT '代理出口货物证明号码',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `hgjldwmc` VARCHAR(75) COMMENT '海关计量单位名称',
  `cksl` DECIMAL(17,5) COMMENT '出口数量',
  `mylaj` DECIMAL(18,2) COMMENT '美元离岸价',
  `rmblaj` DECIMAL(18,2) COMMENT '人民币离岸价',
  `zssl` DECIMAL(16,6) COMMENT '征税税率',
  `tsl` DECIMAL(16,6) COMMENT '退税率',
  `tzhjhfpl` DECIMAL(10,6) COMMENT '调整后计划分配率',
  `jljgbsjkljzcjsjg` DECIMAL(18,2) COMMENT '进料加工保税进口料件组成计税价格',
  `gngjmsycljg` DECIMAL(18,2) COMMENT '国内购进免税原材料价格',
  `mdtsbdmzhdkse` DECIMAL(18,6) COMMENT '免抵退税不得免征和抵扣税额',
  `mdtse` DECIMAL(18,6) COMMENT '免抵退税额',
  `jljgszch` VARCHAR(20) COMMENT '进料加工手（账）册号',
  `cktmsywlxdmjh` VARCHAR(30) COMMENT '出口退（免）税业务类型代码集合',
  `cktmsywlxmcjh` VARCHAR(75) COMMENT '出口退（免）税业务类型名称集合',
  `ckhth` VARCHAR(60) COMMENT '出口合同号',
  `bz` VARCHAR(3000) COMMENT '备注',
  `cjhbzm_dm` CHAR(3) COMMENT '成交货币字母代码',
  `cjzj` DECIMAL(18,2) COMMENT '成交总价||成交总价',
  `cjhbhl` DECIMAL(16,6) COMMENT '成交货币汇率',
  `myhl` DECIMAL(16,6) COMMENT '美元汇率',
  `mdtsny` CHAR(6) COMMENT '免抵退税年月',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `sbhgspmc` VARCHAR(500) COMMENT '申报海关商品名称||申报海关商品名称',
  `zbblny` VARCHAR(6) COMMENT '暂不办理年月',
  `sbsp_dm` VARCHAR(20) COMMENT '申报商品代码',
  `sbspmc` VARCHAR(500) COMMENT '申报商品名称',
  `hgcode` VARCHAR(4),
  `gbcode` VARCHAR(3),
  `zzmdg` VARCHAR(3),
  `hzdwdqdm` VARCHAR(5),
  `sbdwdm` VARCHAR(10),
  `gnqyfs_dm` VARCHAR(2) COMMENT '国内启运方式代码',
  `hgzsrzqylx_dm` VARCHAR(2) COMMENT '海关总署认证企业类型代码',
  KEY `IDX_CKTS_SB_MDT_TSSB_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_MDT_TSSB_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='生产企业出口货物免抵退税申报明细(临时表)';

-- Creating table CKTS_SB_MDT_XTHH_LSB
CREATE TABLE `CKTS_SB_MDT_XTHH_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75),
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `ckhth` VARCHAR(60) COMMENT '出口合同号',
  `mylaj` DECIMAL(18,2) COMMENT '美元离岸价',
  `mdtse` DECIMAL(18,6) COMMENT '免抵退税额',
  `sbcs` DECIMAL(10,0) COMMENT '申报次数',
  `zbmc` VARCHAR(75) COMMENT '账簿名称',
  `jzrq` DATETIME COMMENT '记账日期',
  `rmblaj` DECIMAL(18,2) COMMENT '人民币离岸价',
  `pzfs` DECIMAL(10,0) COMMENT '凭证份数',
  `pzbh` VARCHAR(30) COMMENT '凭证编号',
  `skjemy` DECIMAL(18,2) COMMENT '收款金额（美元）',
  `cktmsywlxdmjh` VARCHAR(30) COMMENT '出口退（免）税业务类型代码集合',
  `cktmsywlxmcjh` VARCHAR(75) COMMENT '出口退（免）税业务类型名称集合',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `ljsbckemy` DECIMAL(18,2) COMMENT '累计申报出口额（美元）',
  `ljsbmdtse` DECIMAL(18,6) COMMENT '累计申报免抵退税额',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `pzhmjh` VARCHAR(3000) COMMENT '凭证号码集合',
  KEY `IDX_CKTS_SB_MDT_XTHH_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_MDT_XTHH_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='先退税后核销企业免抵退税申报附表(临时表)';

-- Creating table CKTS_SB_MDT_YFSJ_LSB
CREATE TABLE `CKTS_SB_MDT_YFSJ_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75),
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `hth` VARCHAR(60) COMMENT '合同号',
  `cktszmbh` VARCHAR(20) COMMENT '出口退税证明编号',
  `jwdwmc` VARCHAR(300) COMMENT '境外单位名称',
  `gjhdqsz_dm` CHAR(3) COMMENT '国家或地区数字代码',
  `myhl` DECIMAL(16,6) COMMENT '美元汇率',
  `skjemy` DECIMAL(18,2) COMMENT '收款金额（美元）',
  `htzjemy` DECIMAL(18,2) COMMENT '合同总金额（美元）',
  `htzjermb` DECIMAL(18,2) COMMENT '合同总金额（人民币）',
  `bqskpzfs` DECIMAL(10,0) COMMENT '本期收款凭证份数',
  `bqqrysfwyysrrmbje` DECIMAL(18,2) COMMENT '本期确认应税服务营业收入人民币金额',
  `bqskjemy` DECIMAL(18,2) COMMENT '本期收款金额（美元）',
  `ysfwyyermb` DECIMAL(18,2) COMMENT '应税服务营业额（人民币）',
  `ysfwyyemdtsjsje` DECIMAL(18,2) COMMENT '应税服务营业额免抵退税计税金额',
  `srybzm_dm` CHAR(3) COMMENT '收入原币字母代码',
  `srybje` DECIMAL(18,2) COMMENT '收入原币金额',
  `skybzm_dm` CHAR(3) COMMENT '收款原币字母代码',
  `skybje` DECIMAL(18,2) COMMENT '收款原币金额',
  `zssl` DECIMAL(16,6) COMMENT '征税税率',
  `tsl` DECIMAL(16,6) COMMENT '退税率',
  `ztsce` DECIMAL(18,6) COMMENT '征退税差额',
  `ytse_1` DECIMAL(18,6) COMMENT '应退税额',
  `cktmsywlxdmjh` VARCHAR(30) COMMENT '出口退（免）税业务类型代码集合',
  `cktmsywlxmcjh` VARCHAR(75) COMMENT '出口退（免）税业务类型名称集合',
  `bz` VARCHAR(3000) COMMENT '备注',
  `jbr_dm` CHAR(11) COMMENT '经办人代码',
  `ckfph` VARCHAR(30) COMMENT '出口发票号',
  `kprq` DATETIME COMMENT '开票日期',
  `mdtsny` CHAR(6) COMMENT '免抵退税年月',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `ysfw_dm` VARCHAR(20) COMMENT '应税服务代码',
  `ysfwmc` VARCHAR(500) COMMENT '应税服务名称',
  `zbblny` VARCHAR(6) COMMENT '暂不办理年月',
  `bytsny` CHAR(6) COMMENT '不予退税年月',
  `ckrq_1` DATETIME COMMENT '出口日期',
  KEY `IDX_CKTS_SB_MDT_YFSJ_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_MDT_YFSJ_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='增值税零税率应税服务免抵退税申报明细(临时表)';

-- Creating table CKTS_SB_MTS_BNSH_LSB
CREATE TABLE `CKTS_SB_MTS_BNSH_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `ckfph` VARCHAR(30) COMMENT '出口发票号',
  `jckxszrq` DATETIME COMMENT '记出口销售账日期',
  `cjhbzm_dm` CHAR(3) COMMENT '成交货币字母代码',
  `cjzj` DECIMAL(18,2) COMMENT '成交总价||成交总价',
  `cjhbhl` DECIMAL(16,6) COMMENT '成交货币汇率',
  `ckxsermb` DECIMAL(18,2) COMMENT '出口销售额（人民币）',
  `ckshhbzm_dm` CHAR(3) COMMENT '出口收汇货币字母代码',
  `yshje` DECIMAL(18,2) COMMENT '已收汇金额',
  `wshje` DECIMAL(18,2) COMMENT '未收汇金额',
  `wshbl` DECIMAL(10,6) COMMENT '未收汇比例',
  `bnshyy_dm` CHAR(2) COMMENT '不能收汇原因代码',
  `bnshyymc` VARCHAR(150) COMMENT '不能收汇原因名称',
  `tgzmclzl` VARCHAR(300) COMMENT '提供证明材料种类',
  `htydqbshzzrq` DATETIME COMMENT '合同约定全部收汇最终日期',
  `ckhth` VARCHAR(60) COMMENT '出口合同号',
  `bz` VARCHAR(3000) COMMENT '备注',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgrq` DATETIME COMMENT '修改日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `tbrq_1` DATETIME COMMENT '填表日期',
  KEY `IDX_CKTS_SB_MTS_BNSH_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_MTS_BNSH_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口货物不能收汇申报临时表';

-- Creating table CKTS_SB_MTS_CKSH_LSB
CREATE TABLE `CKTS_SB_MTS_CKSH_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `sbxh` VARCHAR(50) COMMENT '退免税申报情况||申报序号',
  `ckbgdh` VARCHAR(21) COMMENT '退免税申报情况||出口报关单号',
  `ckfph` VARCHAR(30) COMMENT '退免税申报情况||出口发票号',
  `jckxszrq` DATETIME COMMENT '记出口销售账日期',
  `cjhbzm_dm` CHAR(3) COMMENT '退免税申报情况||成交货币字母代码',
  `cjzj` DECIMAL(18,2) COMMENT '退免税申报情况||成交总价',
  `cjhbhl` DECIMAL(16,6) COMMENT '成交货币汇率',
  `ckxsermb` DECIMAL(18,2) COMMENT '退免税申报情况||出口销售额（人民币）',
  `pzhm_2` VARCHAR(40) COMMENT '已收汇情况||凭证号码',
  `ckshrq` DATETIME COMMENT '已收汇情况||出口收汇日期',
  `jhfs_dm` CHAR(1) COMMENT '结汇方式代码',
  `yhywbh` VARCHAR(50) COMMENT '银行业务编号',
  `ckshhbzm_dm` CHAR(3) COMMENT '已收汇情况||出口收汇货币字母代码',
  `ckshje` DECIMAL(18,2) COMMENT '已收汇情况||出口收汇金额',
  `ckshhbhl` DECIMAL(16,6) COMMENT '出口收汇货币汇率',
  `ckshjermb` DECIMAL(18,2) COMMENT '已收汇情况||出口收汇金额（人民币）',
  `fhr` VARCHAR(300) COMMENT '已收汇情况||付汇人',
  `fhgjdq` VARCHAR(300) COMMENT '付汇国家（地区）',
  `fjksfhyy` VARCHAR(75) COMMENT '已收汇情况||非进口商付汇原因',
  `fjkgjdqfhyy` VARCHAR(75) COMMENT '非进口国家（地区）付汇原因',
  `bz` VARCHAR(3000) COMMENT '退免税申报情况||备注',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgrq` DATETIME COMMENT '修改日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `jrjgdm` VARCHAR(20) COMMENT '金融机构代码',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `dlckhwzmhm` VARCHAR(20) COMMENT '退免税申报情况||代理出口货物证明号码',
  `yshqkpzzje` DECIMAL(18,2) COMMENT '已收汇情况||凭证总金额',
  `stshqkyy` VARCHAR(100) COMMENT '视同收汇情况||原因',
  `stshqkyyjtsm` VARCHAR(4000) COMMENT '视同收汇情况||原因具体说明',
  `stshqkjzclzl` VARCHAR(100) COMMENT '视同收汇情况||举证材料种类',
  `stshqkzrmbje` DECIMAL(18,2) COMMENT '视同收汇情况||折人民币金额',
  `stshqkhtydqbshzzrq` DATETIME COMMENT '视同收汇情况||合同约定全部收汇最终日期',
  `stshqkckhth` VARCHAR(60) COMMENT '视同收汇情况||出口合同号',
  KEY `IDX_CKTS_SB_MTS_CKSH_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_MTS_CKSH_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口货物收汇申报临时表';

-- Creating table CKTS_SB_MTS_HGSPTZ_LSB
CREATE TABLE `CKTS_SB_MTS_HGSPTZ_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `sbhgspmc` VARCHAR(500) COMMENT '申报海关商品名称||申报海关商品名称',
  `tsl` DECIMAL(16,6) COMMENT '退税率',
  `tzhcksp_dm` VARCHAR(20) COMMENT '调整后出口商品代码',
  `tzhhgspmc` VARCHAR(500) COMMENT '调整后海关商品名称',
  `tzhtsl` DECIMAL(16,6) COMMENT '调整后退税率',
  `bz` VARCHAR(3000) COMMENT '备注',
  `dlckhwzmhm` VARCHAR(20) COMMENT '代理出口货物证明号码',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgrq` DATETIME COMMENT '修改日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `hgckhwbgdsbrq` DATETIME COMMENT '海关出口货物报关单申报日期',
  KEY `IDX_CKTS_SB_MTS_HGSPTZ_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_MTS_HGSPTZ_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='海关出口商品代码、名称、退税率调整对应临时表';

-- Creating table CKTS_SB_MTS_JHPZHT_LSB
CREATE TABLE `CKTS_SB_MTS_JHPZHT_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `xh` DECIMAL(8,0) COMMENT '序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `fp_dm` VARCHAR(12) COMMENT '发票代码',
  `fphm` VARCHAR(30) COMMENT '发票号码',
  `hgzyjkshm` VARCHAR(100) COMMENT '海关专用缴款书号码',
  `ghfshxydm` VARCHAR(20) COMMENT '购货方社会信用代码',
  `xhfshxydm` VARCHAR(20) COMMENT '销货方社会信用代码',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `skssq` VARCHAR(60) COMMENT '税款所属期',
  `kprq` DATETIME COMMENT '开票日期',
  `shbz` CHAR(1) COMMENT '审核标志',
  `yysm` VARCHAR(4000) COMMENT '原因说明',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  KEY `IDX_CKTS_SB_MTS_JHPZHT_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_MTS_JHPZHT_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='进货凭证信息回退（临时表）';

-- Creating table CKTS_SB_MTS_SBHZ_LSB
CREATE TABLE `CKTS_SB_MTS_SBHZ_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `ckmxsbbfs` DECIMAL(10,0) COMMENT '出口明细申报表（份数）',
  `ckmxsbbjlts_1` DECIMAL(10,0) COMMENT '出口明细申报表记录（条数）',
  `ckemy` DECIMAL(18,2) COMMENT '出口额（美元）',
  `ckhwbgdzs` DECIMAL(10,0) COMMENT '出口货物报关单（张数）',
  `dlckhwzmzs` DECIMAL(10,0) COMMENT '代理出口货物证明（张数）',
  `qtpzzs` DECIMAL(10,0) COMMENT '其他凭证（张数）',
  `jhmxsbbfs` DECIMAL(10,0) COMMENT '进货明细申报表（份数）',
  `jhmxsbbjlts` DECIMAL(16,4) COMMENT '进货明细申报表记录条数',
  `zzszyfpzs` DECIMAL(10,0) COMMENT '增值税专用发票（张数）',
  `xfszyspzs` DECIMAL(10,0) COMMENT '消费税专用税票（张数）',
  `hgjkzzszyjkszs` DECIMAL(10,0) COMMENT '海关进口增值税专用缴款书（张数）',
  `hgjkxfszyjkszs` DECIMAL(10,0) COMMENT '海关进口消费税专用缴款书（张数）',
  `wmqycktsjhfpdzs` DECIMAL(10,0) COMMENT '外贸企业出口退税进货分批单（张数）',
  `zjhje` DECIMAL(18,2) COMMENT '总进货金额',
  `zjhse` DECIMAL(18,6) COMMENT '总进货税额',
  `zjhzzsse` DECIMAL(18,6) COMMENT '总进货增值税税额',
  `zjhxfsse` DECIMAL(18,6) COMMENT '总进货消费税税额',
  `bysbtse` DECIMAL(18,6) COMMENT '本月申报退税额',
  `bysbzzstse` DECIMAL(18,6) COMMENT '本月申报增值税退税额',
  `ckhwlwyzzstse` DECIMAL(18,6) COMMENT '出口货物劳务应增值税退税额',
  `ckysfwyzzstse` DECIMAL(18,6) COMMENT '出口应税服务应增值税退税额',
  `bysbxfstse` DECIMAL(18,6) COMMENT '本月申报消费税退税额',
  `byssytse` DECIMAL(18,6) COMMENT '本月实收已退税额',
  `byssytzzstse` DECIMAL(18,6) COMMENT '本月实收已退增值税退税额',
  `byssytxfstse` DECIMAL(18,6) COMMENT '本月实收已退消费税退税额',
  `bnljssytse` DECIMAL(18,6) COMMENT '本年累计实收已退税额',
  `bnljssytzzstse` DECIMAL(18,6) COMMENT '本年累计实收已退增值税退税额',
  `bnljssytxfstse` DECIMAL(18,6) COMMENT '本年累计实收已退消费税退税额',
  `sqkjdlckhwzmfs` DECIMAL(10,0) COMMENT '申请开具代理出口货物证明（份数）',
  `sqkjdlckhwzmjlts` DECIMAL(10,0) COMMENT '申请开具代理出口货物证明记录（条数）',
  `sqkjdljkhwzmfs` DECIMAL(10,0) COMMENT '申请开具代理进口货物证明（份数）',
  `sqkjdljkhwzmjlts` DECIMAL(10,0) COMMENT '申请开具代理进口货物证明记录（条数）',
  `sqkjlljgckhwmszmfs` DECIMAL(10,0) COMMENT '申请开具来料加工出口货物免税证明（份数）',
  `sqkjlljgckhwmszmjlts` DECIMAL(10,0) COMMENT '申请开具来料加工出口货物免税证明记录（条数）',
  `sqkjlljgckhwmshxzmfs` DECIMAL(10,0) COMMENT '申请开具来料加工出口货物免税核销证明（份数）',
  `sqkjlljgckhwmshxzmjlts` DECIMAL(10,0) COMMENT '申请开具来料加工出口货物免税核销证明记录（条数）',
  `sqkjckhwznxzmfs` DECIMAL(10,0) COMMENT '申请开具出口货物转内销证明（份数）',
  `sqkjckhwznxzmjlts` DECIMAL(10,0) COMMENT '申请开具出口货物转内销证明记录（条数）',
  `sqkjtyybszmfs` DECIMAL(10,0) COMMENT '申请开具退运已补税证明（份数）',
  `sqkjtyybszmjlts` DECIMAL(10,0) COMMENT '申请开具退运已补税证明记录（条数）',
  `sqkjbbbgdzmfs` DECIMAL(10,0) COMMENT '申请开具补办报关单证明（份数）',
  `sqkjbbbgdzmjlts` DECIMAL(10,0) COMMENT '申请开具补办报关单证明记录（条数）',
  `sqkjbbdlckzmfs` DECIMAL(10,0) COMMENT '申请开具补办代理出口证明（份数）',
  `sqkjbbdlckzmjlts` DECIMAL(10,0) COMMENT '申请开具补办代理出口证明记录（条数）',
  `sqkjckqyckhjcpmszmfs` DECIMAL(10,0) COMMENT '申请开具出口企业出口含金产品免税证明（份数）',
  `sqkjckqyckhjcpmszmjlts` DECIMAL(10,0) COMMENT '申请开具出口企业出口含金产品免税证明记录（条数）',
  `sbrsmrq` DATETIME COMMENT '申报人申明日期',
  `sqrmc` VARCHAR(300) COMMENT '授权人名称',
  `sqrsmrq` DATETIME COMMENT '授权人申明日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgrq` DATETIME COMMENT '修改日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `ckshhxdzs` DECIMAL(10,0) COMMENT '出口收汇核销单张数',
  `ckshjemy` DECIMAL(18,2) COMMENT '出口收汇金额（美元）',
  `yqshzmzs` DECIMAL(10,0) COMMENT '远期收汇证明张数',
  `sqkjbbshhxdzmfs` DECIMAL(10,0) COMMENT '申请开具补办收汇核销单证明（份数）',
  `sqkjbbshhxdzmts` DECIMAL(10,0) COMMENT '申请开具补办收汇核销单证明（条数）',
  `sbbh_1` VARCHAR(20) COMMENT '申报编号',
  KEY `IDX_CKTS_SB_MTS_SBHZ_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_MTS_SBHZ_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='外贸企业出口退税汇总申报临时表';

-- Creating table CKTS_SB_MTS_TSJH_LSB
CREATE TABLE `CKTS_SB_MTS_TSJH_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `glh` VARCHAR(30) COMMENT '关联号',
  `sz` CHAR(1) COMMENT '税种',
  `jhpzh` VARCHAR(75) COMMENT '进货凭证号',
  `zysph` VARCHAR(30) COMMENT '专用税票号',
  `kprq` DATETIME COMMENT '开票日期',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `sbhgspmc` VARCHAR(500) COMMENT '申报海关商品名称||申报海关商品名称',
  `hgjldwmc` VARCHAR(75) COMMENT '海关计量单位名称',
  `sl` DECIMAL(17,5) COMMENT '数量',
  `jsje` DECIMAL(18,2) COMMENT '计税金额',
  `zssl` DECIMAL(16,6) COMMENT '征税税率',
  `zsse` DECIMAL(18,6) COMMENT '征税税额',
  `tsl` DECIMAL(16,6) COMMENT '退税率',
  `tse` DECIMAL(18,6) COMMENT '退税额',
  `cktmsywlxdmjh` VARCHAR(30) COMMENT '出口退（免）税业务类型代码集合',
  `cktmsywlxmcjh` VARCHAR(75) COMMENT '出口退（免）税业务类型名称集合',
  `bz` VARCHAR(3000) COMMENT '备注',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgrq` DATETIME COMMENT '修改日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `ghfnsrsbh_1` VARCHAR(20) COMMENT '供货方纳税人识别号',
  `cktmspzlx_dm` CHAR(2) COMMENT '出口退(免)税凭证类型代码',
  `fpdm` VARCHAR(12) COMMENT '增值税发票代码（信息比对的时候通过JHPZH分解）',
  `fphm` VARCHAR(8) COMMENT '增值税发票号码（信息比对的时候通过JHPZH分解）',
  `ckrq_1` DATETIME COMMENT '出口日期（信息比对的时候通过关联号从出口明细获取）',
  KEY `IDX_CKTS_SB_MTS_TSJH_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_MTS_TSJH_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='外贸企业出口退税进货明细申报临时表';

-- Creating table CKTS_SB_MTS_TSSB_LSB
CREATE TABLE `CKTS_SB_MTS_TSSB_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `glh` VARCHAR(30) COMMENT '关联号',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `dlzmh` VARCHAR(30) COMMENT '代理证明号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `ckshhxdh` VARCHAR(30) COMMENT '出口收汇核销单号',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `sbhgspmc` VARCHAR(500) COMMENT '申报海关商品名称||申报海关商品名称',
  `hgjldwmc` VARCHAR(75) COMMENT '海关计量单位名称',
  `cksl` DECIMAL(17,5) COMMENT '出口数量',
  `mylaj` DECIMAL(18,2) COMMENT '美元离岸价',
  `ckjhje` DECIMAL(18,2) COMMENT '出口进货金额',
  `sbsp_dm` VARCHAR(20) COMMENT '申报商品代码',
  `sbspmc` VARCHAR(500) COMMENT '申报商品名称',
  `tsl` DECIMAL(16,6) COMMENT '退税率',
  `zzstse` DECIMAL(18,6) COMMENT '增值税退税额',
  `xfstse` DECIMAL(18,6) COMMENT '消费税退税额',
  `dzbqbz` CHAR(1) COMMENT '单证不齐标志',
  `cktmsywlxdmjh` VARCHAR(30) COMMENT '出口退（免）税业务类型代码集合',
  `cktmsywlxmcjh` VARCHAR(75) COMMENT '出口退（免）税业务类型名称集合',
  `bz` VARCHAR(3000) COMMENT '备注',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `stssl` DECIMAL(17,5) COMMENT '实退税数量',
  `pjdj` DECIMAL(18,2) COMMENT '平均单价',
  `rmblaj` DECIMAL(18,2) COMMENT '人民币离岸价',
  `mygdqsz_dm` CHAR(3) COMMENT '贸易国（地区）数字代码',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgrq` DATETIME COMMENT '修改日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `jjhwbaqdh` VARCHAR(30) COMMENT '进境货物备案清单号',
  `ckfph` VARCHAR(30) COMMENT '出口发票号',
  `hgcode` VARCHAR(4),
  `gbcode` VARCHAR(3),
  `zzmdg` VARCHAR(3),
  `hzdwdqdm` VARCHAR(5),
  `sbdwdm` VARCHAR(10),
  `gnqyfs_dm` VARCHAR(2) COMMENT '国内启运方式代码',
  `hgzsrzqylx_dm` VARCHAR(2) COMMENT '海关总署认证企业类型代码',
  KEY `IDX_CKTS_SB_MTS_TSSB_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_MTS_TSSB_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='外贸企业出口退税出口明细申报临时表';

-- Creating table CKTS_SB_MTS_TZSB_LSB
CREATE TABLE `CKTS_SB_MTS_TZSB_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `lslsbbz` CHAR(1) COMMENT '零税率申报标志',
  `yglh` VARCHAR(30) COMMENT '原关联号',
  `bz` VARCHAR(3000) COMMENT '备注',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgrq` DATETIME COMMENT '修改日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `wmqytzsblx_dm` CHAR(1) COMMENT '外贸企业调整申报类型代码',
  KEY `IDX_CKTS_SB_MTS_TZSB_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_MTS_TZSB_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='免退税调整申报临时表';

-- Creating table CKTS_SB_MTS_YSFWCK_LSB
CREATE TABLE `CKTS_SB_MTS_YSFWCK_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `glh` VARCHAR(30) COMMENT '关联号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `ysfw_dm` VARCHAR(20) COMMENT '应税服务代码',
  `ysfwmc` VARCHAR(500) COMMENT '应税服务名称',
  `hth` VARCHAR(60) COMMENT '合同号',
  `jwdwmc` VARCHAR(300) COMMENT '境外单位名称',
  `jwzcgjhdqsz_dm` CHAR(3) COMMENT '境外注册国家或地区数字代码',
  `htzjemy` DECIMAL(18,2) COMMENT '合同总金额（美元）',
  `htzjermb` DECIMAL(18,2) COMMENT '合同总金额（人民币）',
  `bqskpzfs` DECIMAL(10,0) COMMENT '本期收款凭证份数',
  `bqqrysfwyysrrmbje` DECIMAL(18,2) COMMENT '本期确认应税服务营业收入人民币金额',
  `skjemy` DECIMAL(18,2) COMMENT '收款金额（美元）',
  `tsl` DECIMAL(16,6) COMMENT '退税率',
  `zzstse` DECIMAL(18,6) COMMENT '增值税退税额',
  `cktmsywlxdmjh` VARCHAR(30) COMMENT '出口退（免）税业务类型代码集合',
  `cktmsywlxmcjh` VARCHAR(75) COMMENT '出口退（免）税业务类型名称集合',
  `bz` VARCHAR(3000) COMMENT '备注',
  `rq` DATETIME COMMENT '日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgrq` DATETIME COMMENT '修改日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `jhpzh` VARCHAR(75) COMMENT '进货凭证号',
  `kprq` DATETIME COMMENT '开票日期',
  `jsje` DECIMAL(18,2) COMMENT '计税金额',
  `zssl` DECIMAL(16,6) COMMENT '征税税率',
  `cktszmbh` VARCHAR(20) COMMENT '出口退税证明编号',
  `ghfnsrsbh_1` VARCHAR(20) COMMENT '供货方纳税人识别号',
  `ckfph` VARCHAR(30) COMMENT '出口发票号',
  `myhl` DECIMAL(16,6) COMMENT '美元汇率',
  `ygzmbh` VARCHAR(50) COMMENT '有关证明编号||有关证明编号',
  `fpdm` VARCHAR(12) COMMENT '增值税发票代码（信息比对的时候通过JHPZH分解）',
  `fphm` VARCHAR(8) COMMENT '增值税发票号码（信息比对的时候通过JHPZH分解）',
  KEY `IDX_CKTS_SB_MTS_YSFWCK_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_MTS_YSFWCK_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='外贸企业外购应税服务出口明细申请临时表';

-- Creating table CKTS_SB_YS_BNSH_LSB
CREATE TABLE `CKTS_SB_YS_BNSH_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `ckfph` VARCHAR(30) COMMENT '出口发票号',
  `jckxszrq` DATETIME COMMENT '记出口销售账日期',
  `cjhbzm_dm` CHAR(3) COMMENT '成交货币字母代码',
  `cjzj` DECIMAL(18,2) COMMENT '成交总价||成交总价',
  `cjhbhl` DECIMAL(16,6) COMMENT '成交货币汇率',
  `ckxsermb` DECIMAL(18,2) COMMENT '出口销售额（人民币）',
  `ckshhbzm_dm` CHAR(3) COMMENT '出口收汇货币字母代码',
  `yshje` DECIMAL(18,2) COMMENT '已收汇金额',
  `wshje` DECIMAL(18,2) COMMENT '未收汇金额',
  `wshbl` DECIMAL(10,6) COMMENT '未收汇比例',
  `bnshyy_dm` CHAR(2) COMMENT '不能收汇原因代码',
  `bnshyymc` VARCHAR(150) COMMENT '不能收汇原因名称',
  `tgzmclzl` VARCHAR(300) COMMENT '提供证明材料种类',
  `htydqbshzzrq` DATETIME COMMENT '合同约定全部收汇最终日期',
  `ckhth` VARCHAR(60) COMMENT '出口合同号',
  `bz` VARCHAR(3000) COMMENT '备注',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  KEY `IDX_CKTS_SB_YS_BNSH_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_YS_BNSH_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口已使用过的设备不能收汇申报临时表';

-- Creating table CKTS_SB_YS_CKSH_LSB
CREATE TABLE `CKTS_SB_YS_CKSH_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `sbxh` VARCHAR(50) COMMENT '退免税申报情况||申报序号',
  `ckbgdh` VARCHAR(21) COMMENT '退免税申报情况||出口报关单号',
  `ckfph` VARCHAR(30) COMMENT '退免税申报情况||出口发票号',
  `jckxszrq` DATETIME COMMENT '记出口销售账日期',
  `cjhbzm_dm` CHAR(3) COMMENT '退免税申报情况||成交货币字母代码',
  `cjzj` DECIMAL(18,2) COMMENT '退免税申报情况||成交总价',
  `cjhbhl` DECIMAL(16,6) COMMENT '成交货币汇率',
  `ckxsermb` DECIMAL(18,2) COMMENT '退免税申报情况||出口销售额（人民币）',
  `pzhm_2` VARCHAR(40) COMMENT '已收汇情况||凭证号码',
  `ckshrq` DATETIME COMMENT '已收汇情况||出口收汇日期',
  `jhfs_dm` CHAR(1) COMMENT '结汇方式代码',
  `jrjgdm` VARCHAR(20) COMMENT '金融机构代码',
  `yhywbh` VARCHAR(50) COMMENT '银行业务编号',
  `ckshhbzm_dm` CHAR(3) COMMENT '已收汇情况||出口收汇货币字母代码',
  `ckshje` DECIMAL(18,2) COMMENT '已收汇情况||出口收汇金额',
  `ckshhbhl` DECIMAL(16,6) COMMENT '出口收汇货币汇率',
  `ckshjermb` DECIMAL(18,2) COMMENT '已收汇情况||出口收汇金额（人民币）',
  `fhr` VARCHAR(300) COMMENT '已收汇情况||付汇人',
  `fhgjdq` VARCHAR(300) COMMENT '付汇国家（地区）',
  `fjksfhyy` VARCHAR(75) COMMENT '已收汇情况||非进口商付汇原因',
  `fjkgjdqfhyy` VARCHAR(75) COMMENT '非进口国家（地区）付汇原因',
  `bz` VARCHAR(3000) COMMENT '退免税申报情况||备注',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `dlckhwzmhm` VARCHAR(20) COMMENT '退免税申报情况||代理出口货物证明号码',
  `yshqkpzzje` DECIMAL(18,2) COMMENT '已收汇情况||凭证总金额',
  `stshqkyy` VARCHAR(100) COMMENT '视同收汇情况||原因',
  `stshqkyyjtsm` VARCHAR(4000) COMMENT '视同收汇情况||原因具体说明',
  `stshqkjzclzl` VARCHAR(100) COMMENT '视同收汇情况||举证材料种类',
  `stshqkzrmbje` DECIMAL(18,2) COMMENT '视同收汇情况||折人民币金额',
  `stshqkhtydqbshzzrq` DATETIME COMMENT '视同收汇情况||合同约定全部收汇最终日期',
  `stshqkckhth` VARCHAR(60) COMMENT '视同收汇情况||出口合同号',
  KEY `IDX_CKTS_SB_YS_CKSH_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_YS_CKSH_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口已使用过的设备收汇申报明细临时表';

-- Creating table CKTS_SB_YS_HGSPTZ_LSB
CREATE TABLE `CKTS_SB_YS_HGSPTZ_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75),
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `tsl` DECIMAL(16,6) COMMENT '退税率',
  `tzhcksp_dm` VARCHAR(20) COMMENT '调整后出口商品代码',
  `tzhhgspmc` VARCHAR(500) COMMENT '调整后海关商品名称',
  `tzhtsl` DECIMAL(16,6) COMMENT '调整后退税率',
  `dlckhwzmhm` VARCHAR(20) COMMENT '代理出口货物证明号码',
  `bz` VARCHAR(3000) COMMENT '备注',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `sbhgspmc` VARCHAR(500) COMMENT '申报海关商品名称||申报海关商品名称',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `hgckhwbgdsbrq` DATETIME COMMENT '海关出口货物报关单申报日期',
  KEY `IDX_CKTS_SB_YS_HGSPTZ_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_YS_HGSPTZ_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口已使用过的设备海关出口商品代码名称退税率调整对应申报临时表';

-- Creating table CKTS_SB_YS_SBMX_LSB
CREATE TABLE `CKTS_SB_YS_SBMX_LSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `ysygdsbmc` VARCHAR(500) COMMENT '已使用过的设备名称',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `dlckhwzmhm` VARCHAR(20) COMMENT '代理出口货物证明号码',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `tsl` DECIMAL(16,6) COMMENT '退税率',
  `ysygdsbpzhm` VARCHAR(40) COMMENT '已使用过的设备凭证号码',
  `kprq` DATETIME COMMENT '开票日期',
  `jsje` DECIMAL(18,2) COMMENT '计税金额',
  `se` DECIMAL(18,6) COMMENT '税额',
  `zssl` DECIMAL(16,6) COMMENT '征税税率',
  `sbzyjz` DECIMAL(18,2) COMMENT '设备折余价值',
  `tse` DECIMAL(18,6) COMMENT '退税额',
  `bz` VARCHAR(3000) COMMENT '备注',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `sbhgspmc` VARCHAR(500) COMMENT '申报海关商品名称||申报海关商品名称',
  `sbyz` DECIMAL(18,2) COMMENT '设备原值',
  `ysynx` DECIMAL(16,4) COMMENT '已使用年限',
  `ytljzje` DECIMAL(18,2) COMMENT '已提累计折旧额',
  `fpdm` VARCHAR(12) COMMENT '增值税发票代码（信息比对的时候通过JHPZH分解）',
  `fphm` VARCHAR(8) COMMENT '增值税发票号码（信息比对的时候通过JHPZH分解）',
  KEY `IDX_CKTS_SB_YS_SBMX_LSB_1` (`SBID`),
  KEY `IDX_CKTS_SB_YS_SBMX_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口已使用过的设备退税申报临时表';

-- Creating table CKTS_TY_YWBLXX_SCFFRQ
-- Original Oracle primary-key constraint: PK_CKTS_TY_YWBLXX_SCFFRQ (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_TY_YWBLXX_SCFFRQ` (
  `tsswjg_dm_1` CHAR(11) NOT NULL COMMENT '退税税务机关代码',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `lcswsx_dm` VARCHAR(16) NOT NULL COMMENT '流程税务事项代码',
  `ffrq` DATETIME COMMENT '发放日期',
  `sjtbrq` DATETIME COMMENT '数据同步日期',
  CONSTRAINT `PK_CKTS_TY_YWBLXX_SCFFRQ` PRIMARY KEY (`TSSWJG_DM_1`, `DJXH`, `LCSWSX_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口企业退税申报事项首次发放时间';

-- Creating table CKTS_WBSJ_FP_YCKSPZXX
CREATE TABLE `CKTS_WBSJ_FP_YCKSPZXX` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID||uuid',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `fp_dm` VARCHAR(12) COMMENT '发票代码',
  `fphm` VARCHAR(30) COMMENT '发票号码',
  `nsrsbh` VARCHAR(20) COMMENT '纳税人识别号',
  `je` DECIMAL(18,2) COMMENT '金额',
  `se` DECIMAL(18,6) COMMENT '税额',
  `jcbz` CHAR(1) COMMENT '解除标志',
  `rdhjcbz` CHAR(1) COMMENT '认定或解除标志',
  KEY `IDX_CKTS_WBSJ_YCKSPZXX_DJXH` (`DJXH`),
  KEY `IDX_CKTS_YCKSPZXX_FP_DM_FPHM` (`FP_DM`, `FPHM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='增值税异常扣税凭证信息表';

-- Creating table CKTS_WBSJ_FP_ZZSFPHWXX
-- Original Oracle primary-key constraint: PK_CKTS_WBSJ_FP_ZZSFPHWXX_1 (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_WBSJ_FP_ZZSFPHWXX` (
  `uuid` VARCHAR(32) NOT NULL,
  `djxh` DECIMAL(20,0),
  `fp_dm` VARCHAR(12),
  `fphm` VARCHAR(30),
  `hh` DECIMAL(8,0),
  `hwhyslwmc` VARCHAR(500),
  `xfnsrsbh` VARCHAR(20),
  `gfnsrsbh` VARCHAR(20),
  `gfhhwhyslwmc` VARCHAR(500),
  `rkrq` DATETIME,
  `jldwmc` VARCHAR(75),
  `qdbz_1` VARCHAR(2),
  `je` DECIMAL(18,2),
  `sl_1` DECIMAL(16,6),
  `se` DECIMAL(18,6),
  `kprq` DATETIME,
  `ggxh` VARCHAR(150),
  `lsh` VARCHAR(32),
  `hwlw_dm` VARCHAR(300),
  `qyspbm` VARCHAR(20),
  `syyhzcbz` CHAR(1),
  `lsllx_dm` CHAR(10),
  `yhzcsm` VARCHAR(750),
  `lrr_dm` CHAR(11),
  `lrrq` DATETIME,
  `xgr_dm` CHAR(11),
  `xgrq` DATETIME,
  `sjgsdq` CHAR(11),
  `sjtb_sj` DATETIME(6),
  `tsswjg_dm_1` CHAR(11),
  `dj_str` VARCHAR(300),
  `sl_3` DECIMAL(18,4),
  `jhpzh` VARCHAR(75),
  KEY `IDX_CKTS_WBSJ_FP_ZZSFPHWXX_DFF` (`DJXH`, `FP_DM`, `FPHM`, `GFHHWHYSLWMC`),
  KEY `IDX_CKTS_WBSJ_FP_ZZSFPHWXX_DJG` (`DJXH`, `JHPZH`, `GFHHWHYSLWMC`),
  CONSTRAINT `PK_CKTS_WBSJ_FP_ZZSFPHWXX_1` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table CKTS_WBSJ_FP_ZZSZYFPXX
-- Original Oracle primary-key constraint: PK_CKTS_WBSJ_FP_ZZSZYFPXX_1 (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_WBSJ_FP_ZZSZYFPXX` (
  `uuid` VARCHAR(32),
  `djxh` DECIMAL(20,0),
  `fp_dm` VARCHAR(12),
  `fphm` VARCHAR(30) NOT NULL,
  `xfnsrsbh` VARCHAR(20),
  `gfnsrsbh` VARCHAR(20),
  `fpzje` DECIMAL(18,2),
  `fpzse` DECIMAL(18,6),
  `kprq` DATETIME,
  `rzrq` DATETIME,
  `jhrq_1` DATETIME,
  `je` DECIMAL(18,2),
  `se` DECIMAL(18,6),
  `hzcjje` DECIMAL(18,2),
  `hzcjse` DECIMAL(18,6),
  `nxzckbz` CHAR(1),
  `nxzckje` DECIMAL(18,2),
  `nxzckse` DECIMAL(18,6),
  `sbfpjsje` DECIMAL(18,2),
  `sbfpsjsk` DECIMAL(18,6),
  `lslsbfpjsje` DECIMAL(18,2),
  `lslsbfpsjsk` DECIMAL(18,6),
  `ghfmc` VARCHAR(300),
  `ghfdz` VARCHAR(300),
  `xhfmc` VARCHAR(300),
  `xhfdz` VARCHAR(300),
  `rzxfzzszyfpbz` CHAR(1),
  `jhxfzzszyfpbz` CHAR(1),
  `bytsbz` CHAR(1),
  `fpzl_dm` VARCHAR(12),
  `fpyt_dm` CHAR(1),
  `fpzt_dm` CHAR(2),
  `zzssbbz` CHAR(1),
  `bdfpbz` CHAR(1),
  `fpsjbbz` CHAR(1),
  `cglbz` CHAR(1),
  `skssq` VARCHAR(60),
  `tsswjg_dm_1` CHAR(11),
  `zsswjg_dm` CHAR(11),
  `cytssbjl` VARCHAR(60),
  `jhxxjssj` DATETIME,
  `sjgxsj` DATETIME,
  `sjc` DATETIME,
  `rkrq` DATETIME,
  `lrr_dm` CHAR(11),
  `lrrq` DATETIME,
  `xgr_dm` CHAR(11),
  `xgrq` DATETIME,
  `sjgsdq` CHAR(11),
  `sjtb_sj` DATETIME(6),
  `hcxcjgdm` VARCHAR(6),
  `xhfkhhjzh` VARCHAR(300),
  `gmfkhhjzh` VARCHAR(300),
  `jcjhbfbz` CHAR(1) DEFAULT 'N',
  `skzfbz` CHAR(1) DEFAULT 'N',
  `xcjg_dm` CHAR(6),
  `yckspzbz` CHAR(1) DEFAULT 'N',
  `fphcjg_dm` CHAR(6),
  `jhpzh` VARCHAR(75) NOT NULL COMMENT '进货凭证号',
  KEY `IDX_CKTS_WBSJ_FP_ZZSFP_DJXH` (`DJXH`),
  CONSTRAINT `PK_CKTS_WBSJ_FP_ZZSZYFPXX_1` PRIMARY KEY (`JHPZH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table CKTS_WBSJ_GT3_ZS_JKS
CREATE TABLE `CKTS_WBSJ_GT3_ZS_JKS` (
  `djxh` DECIMAL(20,0) COMMENT '????????',
  `dzsphm` DECIMAL(20,0) COMMENT '??????????????????????????',
  `sjje` DECIMAL(18,2) COMMENT '????????',
  KEY `IDX_CKTS_WBSJ_GT3_ZS_JKS_DJXH` (`DJXH`),
  KEY `IDX_CKTS_WBSJ_GT3_ZS_JKS_DP` (`DJXH`, `DZSPHM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='????????-??????????';

-- Creating table CKTS_WBSJ_HG_BGD201
-- Original Oracle primary-key constraint: PK_CKTS_WBSJ_HG_BGD201_1 (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_WBSJ_HG_BGD201` (
  `uuid` VARCHAR(32) COMMENT 'UUID',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `ckny` CHAR(6) COMMENT '出口年月',
  `yhggqka_dm` CHAR(4) COMMENT '原海关关区（口岸）代码',
  `hggqka_dm` CHAR(4) COMMENT '海关关区（口岸）代码',
  `ckbgdh` VARCHAR(21) NOT NULL COMMENT '出口报关单号',
  `bsm` VARCHAR(21) COMMENT '标识码',
  `hzdwdq_dm` CHAR(5) COMMENT '货主单位地区代码',
  `hxdh` VARCHAR(30) COMMENT '核销单号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `ycksp_dm` VARCHAR(20) COMMENT '原出口商品代码',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `ckspmc` VARCHAR(75) COMMENT '出口商品名称',
  `hgjldwmc` VARCHAR(75) COMMENT '海关计量单位名称',
  `mygdqsz_dm` CHAR(3) COMMENT '贸易国（地区）数字代码',
  `yjgfs_dm` CHAR(4) COMMENT '原监管方式代码',
  `jgfs_dm` CHAR(4) COMMENT '监管方式代码',
  `ydyjldw_dm` VARCHAR(3) COMMENT '原第一计量单位代码',
  `dyjldw_dm` VARCHAR(3) COMMENT '第一计量单位代码',
  `ydejldw_dm` VARCHAR(3) COMMENT '原第二计量单位代码',
  `dejldw_dm` VARCHAR(3) COMMENT '第二计量单位代码',
  `cksl` DECIMAL(17,5) COMMENT '出口数量',
  `decksl` DECIMAL(17,5) COMMENT '第二出口数量',
  `rmblaj` DECIMAL(18,2) COMMENT '人民币离岸价',
  `mylaj` DECIMAL(18,2) COMMENT '美元离岸价',
  `cjhghbsz_dm` CHAR(3) COMMENT '成交海关货币数字代码',
  `cjzj` DECIMAL(18,2) COMMENT '成交总价',
  `jydwmc` VARCHAR(300) COMMENT '经营单位名称',
  `ysfs_dm` CHAR(1) COMMENT '运输方式代码',
  `tydh` VARCHAR(32) COMMENT '提运单号',
  `zmxz_dm` CHAR(3) COMMENT '征免性质代码',
  `jhfs_dm` CHAR(1) COMMENT '结汇方式代码',
  `xkzh` VARCHAR(20) COMMENT '许可证号',
  `zyg_dm` VARCHAR(6) COMMENT '指运港代码',
  `hgcjfs_dm` CHAR(1) COMMENT '海关成交方式代码',
  `yfjsfs_dm` CHAR(1) COMMENT '运费计算方式代码',
  `yfhghbsz_dm` CHAR(3) COMMENT '运费海关货币数字代码',
  `yfhl` DECIMAL(16,6) COMMENT '运费汇率',
  `bfjsfs_dm` CHAR(1) COMMENT '保费计算方式代码',
  `bfhghbsz_dm` CHAR(3) COMMENT '保费海关货币数字代码',
  `bfhl` DECIMAL(16,6) COMMENT '保费汇率',
  `zfjsfs_dm` CHAR(1) COMMENT '杂费计算方式代码',
  `zfhghbsz_dm` CHAR(3) COMMENT '杂费海关货币数字代码',
  `zfhl` DECIMAL(16,6) COMMENT '杂费汇率',
  `bah` VARCHAR(12) COMMENT '备案号',
  `sbdwdm` VARCHAR(50) COMMENT '申报单位代码',
  `sbdwmc` VARCHAR(300) COMMENT '申报单位名称',
  `hzdwmc` VARCHAR(300) COMMENT '货主单位名称',
  `ggxh` VARCHAR(150) COMMENT '规格型号',
  `zzmdgdqsz_dm` CHAR(3) COMMENT '最终目的国（地区）数字代码',
  `sbjldw_dm` VARCHAR(3) COMMENT '申报计量单位代码',
  `sbsl_1` DECIMAL(17,5) COMMENT '申报数量',
  `sbdj` DECIMAL(18,2) COMMENT '申报单价',
  `tsl` DECIMAL(16,6) COMMENT '退税率',
  `cytssbjl` VARCHAR(60) COMMENT '参与退税申报记录',
  `ysgjmc` VARCHAR(500) COMMENT '运输工具名称',
  `bytsbz` CHAR(1) COMMENT '不予退税标志',
  `hch` VARCHAR(32) COMMENT '航次号',
  `hzdwdm` VARCHAR(50) COMMENT '货主单位代码',
  `hgbzzl_dm` VARCHAR(2) COMMENT '海关包装种类代码',
  `js_1` DECIMAL(10,0) COMMENT '件数',
  `mz_2` DECIMAL(18,6) COMMENT '毛重',
  `jz` DECIMAL(18,6) COMMENT '净重',
  `lxbz` VARCHAR(32) COMMENT '类型备注',
  `tssbsl` DECIMAL(17,5) COMMENT '退税申报数量',
  `tssbrmblaj` DECIMAL(18,2) COMMENT '退税申报人民币离岸价',
  `tssbmylaj` DECIMAL(18,2) COMMENT '退税申报美元离岸价',
  `tysl` DECIMAL(17,5) COMMENT '退运数量',
  `tyrmblaj` DECIMAL(18,2) COMMENT '退运人民币离岸价',
  `tymylaj` DECIMAL(18,2) COMMENT '退运美元离岸价',
  `dlsbsl` DECIMAL(17,5) COMMENT '代理申报数量',
  `dlsbrmblaj` DECIMAL(18,2) COMMENT '代理申报人民币离岸价',
  `dlsbmylaj` DECIMAL(18,2) COMMENT '代理申报美元离岸价',
  `hgspmc` VARCHAR(500) COMMENT '海关商品名称',
  `gfhhgspmc` VARCHAR(500),
  `hgqy_dm` VARCHAR(50) COMMENT '海关企业代码',
  `sjgxsj` DATETIME COMMENT '数据更新时间',
  `rkrq` DATETIME COMMENT '入库日期',
  `sjzxtybh` VARCHAR(20) COMMENT '数据中心统一编号',
  `qygbz` CHAR(1) COMMENT '启运港标志',
  `kjdlckhwzmbz` CHAR(1) COMMENT '开具代理出口货物证明标志',
  `kjckhwtyybswtszmbz` CHAR(1) COMMENT '开具出口货物退运已补税（未退税）证明标志',
  `lrr_dm` CHAR(11) NOT NULL COMMENT '录入人代码',
  `lrrq` DATETIME NOT NULL COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `sjgsdq` CHAR(11) NOT NULL COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `hgckhwbgdsbrq` DATETIME COMMENT '海关出口货物报关单申报日期',
  `qygzcjgbz` CHAR(1) COMMENT '启运港正常结关标志',
  `qygwddbz` CHAR(1) COMMENT '启运港未到达标志',
  `qygcxckbz` CHAR(1) COMMENT '启运港撤销出口标志',
  `qyrq_2` DATETIME COMMENT '启运日期',
  `ckhth` VARCHAR(60) COMMENT '出口合同号',
  `gdbz_1` CHAR(1) DEFAULT 'N' COMMENT '改单标志',
  CONSTRAINT `PK_CKTS_WBSJ_HG_BGD201_1` PRIMARY KEY (`DJXH`, `CKBGDH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='海关出口货物报关单201';

-- Creating table CKTS_WBSJ_HG_BGD202
-- Original Oracle primary-key constraint: PK_CKTS_WBSJ_HG_BGD202 (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_WBSJ_HG_BGD202` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID||uuid',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ckny` CHAR(6) NOT NULL COMMENT '出口年月',
  `yhggqka_dm` CHAR(4) COMMENT '原海关关区（口岸）代码',
  `hggqka_dm` CHAR(4) COMMENT '海关关区（口岸）代码',
  `ckbgdh` VARCHAR(21) NOT NULL COMMENT '出口报关单号',
  `bsm` VARCHAR(21) COMMENT '标识码',
  `hzdwdq_dm` CHAR(5) COMMENT '货主单位地区代码',
  `hxdh` VARCHAR(30) COMMENT '核销单号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `ycksp_dm` VARCHAR(20) COMMENT '原出口商品代码',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `ckspmc` VARCHAR(75) COMMENT '出口商品名称',
  `hgjldwmc` VARCHAR(75) COMMENT '海关计量单位名称',
  `mygdqsz_dm` CHAR(3) COMMENT '贸易国（地区）数字代码',
  `jnhyd_dm` CHAR(5) COMMENT '境内货源地代码',
  `yjgfs_dm` CHAR(4) COMMENT '原监管方式代码',
  `jgfs_dm` CHAR(4) COMMENT '监管方式代码',
  `ydyjldw_dm` VARCHAR(3) COMMENT '原第一计量单位代码',
  `dyjldw_dm` VARCHAR(3) COMMENT '第一计量单位代码',
  `ydejldw_dm` VARCHAR(3) COMMENT '原第二计量单位代码',
  `dejldw_dm` VARCHAR(3) COMMENT '第二计量单位代码',
  `cksl` DECIMAL(17,5) COMMENT '出口数量',
  `decksl` DECIMAL(17,5) COMMENT '第二出口数量',
  `rmblaj` DECIMAL(18,2) COMMENT '人民币离岸价',
  `mylaj` DECIMAL(18,2) COMMENT '美元离岸价',
  `cjhghbsz_dm` CHAR(3) COMMENT '成交海关货币数字代码',
  `cjzj` DECIMAL(18,2) COMMENT '成交总价||成交总价',
  `jydwmc` VARCHAR(300) COMMENT '经营单位名称',
  `ysfs_dm` CHAR(1) COMMENT '运输方式代码',
  `tydh` VARCHAR(32) COMMENT '提运单号',
  `zmxz_dm` CHAR(3) COMMENT '征免性质代码',
  `jhfs_dm` CHAR(1) COMMENT '结汇方式代码',
  `xkzh` VARCHAR(20) COMMENT '许可证号',
  `zyg_dm` VARCHAR(6) COMMENT '指运港代码',
  `hgcjfs_dm` CHAR(1) COMMENT '海关成交方式代码',
  `yfjsfs_dm` CHAR(1) COMMENT '运费计算方式代码',
  `yfhghbsz_dm` CHAR(3) COMMENT '运费海关货币数字代码',
  `yfhl` DECIMAL(16,6) COMMENT '运费汇率',
  `bfjsfs_dm` CHAR(1) COMMENT '保费计算方式代码',
  `bfhghbsz_dm` CHAR(3) COMMENT '保费海关货币数字代码',
  `bfhl` DECIMAL(16,6) COMMENT '保费汇率',
  `zfjsfs_dm` CHAR(1) COMMENT '杂费计算方式代码',
  `zfhghbsz_dm` CHAR(3) COMMENT '杂费海关货币数字代码',
  `zfhl` DECIMAL(16,6) COMMENT '杂费汇率',
  `bah` VARCHAR(12) COMMENT '备案号',
  `sbdwdm` VARCHAR(50) COMMENT '申报单位代码',
  `sbdwmc` VARCHAR(300) COMMENT '申报单位名称',
  `hzdwmc` VARCHAR(300) COMMENT '货主单位名称',
  `ggxh` VARCHAR(150) COMMENT '规格型号',
  `zzmdgdqsz_dm` CHAR(3) COMMENT '最终目的国（地区）数字代码',
  `sbjldw_dm` VARCHAR(3) COMMENT '申报计量单位代码',
  `sbsl_1` DECIMAL(17,5) COMMENT '申报数量',
  `sbdj` DECIMAL(18,2) COMMENT '申报单价',
  `tsl` DECIMAL(16,6) COMMENT '退税率',
  `cytssbjl` VARCHAR(60) COMMENT '参与退税申报记录',
  `ysgjmc` VARCHAR(500) COMMENT '运输工具名称',
  `bytsbz` CHAR(1) COMMENT '不予退税标志',
  `hch` VARCHAR(32) COMMENT '航次号',
  `hzdwdm` VARCHAR(50) COMMENT '货主单位代码',
  `hgbzzl_dm` VARCHAR(2) COMMENT '海关包装种类代码',
  `js_1` DECIMAL(10,0) COMMENT '件数',
  `mz_2` DECIMAL(18,6) COMMENT '毛重',
  `jz` DECIMAL(18,6) COMMENT '净重',
  `lxbz` VARCHAR(32) COMMENT '类型备注',
  `hgspmc` VARCHAR(500) COMMENT '海关商品名称',
  `hgqy_dm` VARCHAR(50) COMMENT '海关企业代码',
  `rkrq` DATETIME COMMENT '入库日期',
  `sjzxtybh` VARCHAR(20) COMMENT '数据中心统一编号',
  `qygbz` CHAR(1) COMMENT '启运港标志',
  `kjdlckhwzmbz` CHAR(1) COMMENT '开具代理出口货物证明标志',
  `kjckhwtyybswtszmbz` CHAR(1) COMMENT '开具出口货物退运已补税（未退税）证明标志',
  `lrr_dm` CHAR(11) NOT NULL COMMENT '录入人代码',
  `lrrq` DATETIME NOT NULL COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `sjgsdq` CHAR(11) NOT NULL COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `hgckhwbgdsbrq` DATETIME COMMENT '海关出口货物报关单申报日期',
  `ckhth` VARCHAR(60) COMMENT '出口合同号',
  `qygzcjgbz` CHAR(1) COMMENT '启运港正常结关标志',
  `qygwddbz` CHAR(1) COMMENT '启运港未到达标志',
  `qygcxckbz` CHAR(1) COMMENT '启运港撤销出口标志',
  KEY `IDX_CKTS_WBSJ_HG_BGD202_D_C` (`DJXH`, `CKBGDH`),
  CONSTRAINT `PK_CKTS_WBSJ_HG_BGD202` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='海关出口货物报关单202';

-- Creating table CKTS_WBSJ_HG_DZSZCBAXX
CREATE TABLE `CKTS_WBSJ_HG_DZSZCBAXX` (
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `bah` VARCHAR(12) COMMENT '备案号',
  `hgqy_dm` VARCHAR(50) COMMENT '海关企业代码',
  `jydwmc` VARCHAR(300) COMMENT '经营单位名称',
  `jgdwdm` VARCHAR(50) COMMENT '加工单位代码',
  `jgdwmc` VARCHAR(300) COMMENT '加工单位名称',
  `szcbarq` DATETIME COMMENT '手（账）册备案日期',
  `bajkze` DECIMAL(18,2) COMMENT '备案进口总额',
  `backze` DECIMAL(18,2) COMMENT '备案出口总额',
  KEY `IDX_CKTS_WBSJ_HG_DZSCBA_D_B` (`DJXH`, `BAH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='海关电子手册备案信息';

-- Creating table CKTS_WBSJ_HG_JKJKS
-- Original Oracle primary-key constraint: PK_CKTS_WBSJ_HG_JKJKS (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_WBSJ_HG_JKJKS` (
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `lcslid` CHAR(32) COMMENT '流程实例ID',
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID||uuid',
  `tfrq` DATETIME COMMENT '填发日期',
  `sqdwbm` VARCHAR(50) COMMENT '申请单位编码',
  `jkdwrnsrmc` VARCHAR(300) COMMENT '缴款单位（人）纳税人名称',
  `jgfs_dm` CHAR(4) COMMENT '监管方式代码',
  `nsrsbh` VARCHAR(20) COMMENT '纳税人识别号',
  `skjehj` DECIMAL(18,2) COMMENT '税款金额合计',
  `sjzxtybh` VARCHAR(20) COMMENT '数据中心统一编号',
  `hgjkjksjhjg_dm` CHAR(1) COMMENT '海关进口缴款书稽核结果代码',
  `jhrq_1` DATETIME COMMENT '稽核日期',
  `dkdwsbh` VARCHAR(300) COMMENT '抵扣单位识别号',
  `zgswjg_dm` CHAR(11) COMMENT '主管税务机关代码',
  `hgjkjkscljg_dm` CHAR(3) COMMENT '海关进口缴款书处理结果代码',
  `cwxx` VARCHAR(3000) COMMENT '错误信息',
  `cytssbjl` VARCHAR(60) COMMENT '参与退税申报记录',
  `sbfpjsje` DECIMAL(18,2) COMMENT '申报发票计税金额',
  `sbfpsjsk` DECIMAL(18,6) COMMENT '申报发票实缴税款',
  `lslsbfpjsje` DECIMAL(18,2) COMMENT '零税率申报发票计税金额',
  `lslsbfpsjsk` DECIMAL(18,6) COMMENT '零税率申报发票实缴税款',
  `sbspjsje` DECIMAL(18,2) COMMENT '申报税票计税金额',
  `sbspsjsk` DECIMAL(18,6) COMMENT '申报税票实缴税款',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `bytsbz` CHAR(1) COMMENT '不予退税标志',
  `hgqy_dm` VARCHAR(50) COMMENT '海关企业代码',
  `wsjg` DECIMAL(18,6) COMMENT '完税价格',
  `skje` DECIMAL(18,2) COMMENT '税款金额',
  `jksp_dm` VARCHAR(20) COMMENT '进口商品代码',
  `hgspmc` VARCHAR(500) COMMENT '海关商品名称',
  `sl` DECIMAL(17,5) COMMENT '数量',
  `dw` VARCHAR(300) COMMENT '单位',
  `nxzckbz` CHAR(1) COMMENT '内销转出口标志',
  `hshbh` VARCHAR(50) COMMENT '核实函编号',
  `yskjehj` DECIMAL(18,2) COMMENT '原税款金额合计',
  `sjgxsj` DATETIME COMMENT '数据更新时间',
  `hcbz` CHAR(1) COMMENT '核查标志',
  `hcrq` DATETIME COMMENT '核查日期',
  `skssq` VARCHAR(60) COMMENT '税款所属期',
  `drrq` DATETIME COMMENT '读入日期',
  `lrr_dm` CHAR(11) NOT NULL COMMENT '录入人代码',
  `lrrq` DATETIME NOT NULL COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `sjgsdq` CHAR(11) NOT NULL COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `bgdhgbh` VARCHAR(30) COMMENT '报关单海关编号',
  `hgzyjkshm` VARCHAR(100) COMMENT '海关专用缴款书号码',
  `sjlybz` CHAR(1) COMMENT '数据来源标志||空||税费种认定，1||房土车申报，2||财务报表资料报送，6||小规模转一般纳税人申报，5||定期定额分月汇总申报',
  KEY `IDX_CKTS_WBSJ_HG_JKJKS_DJXH` (`DJXH`),
  KEY `IDX_CKTS_WBSJ_HG_JKJKS_D_` (`DJXH`, `HGZYJKSHM`),
  KEY `IDX_CKTS_WBSJ_HG_JKJKS_QYDM` (`HGQY_DM`),
  CONSTRAINT `PK_CKTS_WBSJ_HG_JKJKS` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='海关进口缴款书';

-- Creating table CKTS_WBSJ_HG_ZLKZDCLXX_JGB
CREATE TABLE `CKTS_WBSJ_HG_ZLKZDCLXX_JGB` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID||uuid',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `ckhwtyybswtszmbh` VARCHAR(20) COMMENT '出口货物退运已补税（未退税）证明编号',
  `tyybswtstylx_dm` CHAR(1) COMMENT '退运已补税（未退税）退运类型代码',
  `tysl` DECIMAL(17,5) COMMENT '退运数量',
  `tymylaj` DECIMAL(18,2) COMMENT '退运美元离岸价',
  `tyjsje` DECIMAL(18,2) COMMENT '退运计税金额',
  `tyybswtsclfs_dm` CHAR(1) COMMENT '退运已补税（未退税）处理方式代码',
  `cjssq` VARCHAR(60) COMMENT '冲减所属期',
  `hgzyjkshm` VARCHAR(100) COMMENT '海关专用缴款书号码',
  `qyuuid` VARCHAR(32) COMMENT '企业uuid',
  `dlckhwzmhm` VARCHAR(20) COMMENT '代理出口货物证明号码',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='总量控制待处理信息(结果表）';

-- Creating table CKTS_WBSJ_ZJ_CKTSBAQGXX
CREATE TABLE `CKTS_WBSJ_ZJ_CKTSBAQGXX` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID||uuid',
  `lcslid` CHAR(32) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `nsrsbh` VARCHAR(20) COMMENT '纳税人识别号',
  `shxydm` VARCHAR(20) COMMENT '社会信用代码',
  `hgqy_dm` VARCHAR(50) COMMENT '海关企业代码',
  `nsrmc` VARCHAR(300) COMMENT '纳税人名称',
  `dwmyjyzbadjbbh` VARCHAR(45) COMMENT '对外贸易经营者备案登记表编号',
  `cktsqylx_dm` VARCHAR(2) COMMENT '出口退税企业类型代码',
  `tskhyhzh` VARCHAR(50) COMMENT '退税开户银行账号',
  `qybltmsryylxdh` VARCHAR(60) COMMENT '企业办理退（免）税人员一联系电话',
  `qybltmsryysfzjhm` VARCHAR(30) COMMENT '企业办理退（免）税人员一身份证件号码',
  `qybltmsryyxm` VARCHAR(150) COMMENT '企业办理退（免）税人员一姓名',
  `qybltmsryelxdh` VARCHAR(60) COMMENT '企业办理退（免）税人员二联系电话',
  `qybltmsryesfzjhm` VARCHAR(30) COMMENT '企业办理退（免）税人员二身份证件号码',
  `qybltmsryexm` VARCHAR(150) COMMENT '企业办理退（免）税人员二姓名',
  `ckhwtmsjsff_dm` CHAR(1) COMMENT '出口货物退(免)税计算方法代码',
  `tglslysfwbz` CHAR(1) COMMENT '提供零税率应税服务标志',
  `lslysfw` VARCHAR(30) COMMENT '零税率应税服务',
  `xszzsyhzc` VARCHAR(30) COMMENT '享受增值税优惠政策',
  `cktmsgllx` VARCHAR(30) COMMENT '出口退（免）税管理类型',
  `fszl` VARCHAR(450) COMMENT '附送资料||应用于进出口退税',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `nsrlx_dm` CHAR(1) COMMENT '纳税人类型代码',
  `nsrxydj_dm` CHAR(1) COMMENT '纳税人信用等级代码',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `hsbmdm` VARCHAR(150) COMMENT '核算部门代码',
  `wmzhfwqybz` CHAR(1) COMMENT '外贸综合服务企业标志',
  `yfsjfw` VARCHAR(50) COMMENT '研发设计服务',
  `gjysfwysfs` VARCHAR(50) COMMENT '国际运输服务运输方式',
  `zzjgdm` VARCHAR(50) COMMENT '组织机构代码',
  `tszgy_dm` CHAR(11) COMMENT '退税专管员代码',
  `pyzjf` VARCHAR(15) COMMENT '拼音助记符',
  `bachbz` CHAR(1) COMMENT '备案撤回标志',
  `bachrq` DATETIME COMMENT '备案撤回日期',
  `barq` DATETIME COMMENT '备案日期',
  `cktszhbltgdkywbz` CHAR(1) COMMENT '出口退税账户办理托管贷款业务标志',
  `zyspjh` VARCHAR(30) COMMENT '专营商品集合',
  `wgjflgldm` VARCHAR(6) COMMENT '外管局分类管理代码',
  `tsdljgqybz` CHAR(1) COMMENT '退税代理机构企业标志',
  `sxfsl` DECIMAL(5,2) COMMENT '手续费税率',
  `zgwgjmc` VARCHAR(90) COMMENT '主管外管局名称',
  `fbhsbz` CHAR(1) COMMENT '分部核算标志',
  `fbhsbmdm` VARCHAR(150) COMMENT '分部核算部门代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `rkrq` DATETIME COMMENT '入库日期',
  `tsswjgmc` VARCHAR(300) COMMENT '退税税务机关名称',
  KEY `IDX_CKTS_WBSJ_ZJ_CKTSBAQGXX_N` (`NSRSBH`),
  KEY `IDX_CKTS_WBSJ_ZJ_CKTSBAQGXX_S` (`SHXYDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='外部数据总局出口退税备案全国信息';

-- Creating table CKTS_WBSJ_ZJ_JHBFXCJG
-- Original Oracle primary-key constraint: PK_CKTS_WBSJ_ZJ_JHBFXCJG (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_WBSJ_ZJ_JHBFXCJG` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID||uuid',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `fpzl_dm` VARCHAR(12) COMMENT '发票种类代码',
  `fp_dm` VARCHAR(12) NOT NULL COMMENT '发票代码',
  `fphm` VARCHAR(30) NOT NULL COMMENT '发票号码',
  `je` DECIMAL(18,2) COMMENT '金额',
  `se` DECIMAL(18,6) COMMENT '税额',
  `xfnsrsbh` VARCHAR(20) COMMENT '销方纳税人识别号',
  `gfnsrsbh` VARCHAR(20) COMMENT '购方纳税人识别号',
  `kprq` DATETIME COMMENT '开票日期',
  `zsswjg_dm` CHAR(11) COMMENT '征收税务机关代码',
  `jhrq_1` DATETIME COMMENT '稽核日期',
  `dklbz` CHAR(1) COMMENT '抵扣联标志',
  `jcbdfpje` DECIMAL(18,2) COMMENT '稽查比对发票金额',
  `jcbdfpse` DECIMAL(18,6) COMMENT '稽查比对发票税额',
  `jcbdfpxfnsrsbh` VARCHAR(20) COMMENT '稽查比对发票销方纳税人识别号',
  `jcbdfpgfnsrsbh` VARCHAR(20) COMMENT '稽查比对发票购方纳税人识别号',
  `jcbdfpkprq` DATETIME COMMENT '稽查比对发票开票日期',
  `jcbdfpnsrmc` VARCHAR(300) COMMENT '稽查比对发票纳税人名称',
  `jhjglb_dm` CHAR(1) COMMENT '稽核结果类别代码',
  `jhjgbflx_dm` CHAR(1) COMMENT '稽核结果不符类型代码',
  `csfpje` DECIMAL(18,2) COMMENT '查实发票金额',
  `csfpse` DECIMAL(18,6) COMMENT '查实发票税额',
  `csfpxfnsrsbh` VARCHAR(20) COMMENT '查实发票销方纳税人识别号',
  `csfpgfnsrsbh` VARCHAR(20) COMMENT '查实发票购方纳税人识别号',
  `csfpkprq` DATETIME COMMENT '查实发票开票日期',
  `xcrq` DATETIME COMMENT '协查日期',
  `xcjglb_dm` CHAR(1) COMMENT '协查结果类别代码',
  `xczt` CHAR(1) COMMENT '协查状态',
  `rkrq` DATETIME COMMENT '入库日期',
  `hcbz` CHAR(1) COMMENT '核查标志',
  `xcbz` CHAR(1) COMMENT '协查标志',
  `hcjglb_dm` CHAR(1) COMMENT '核查结果类别代码',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `lrr_dm` CHAR(11) NOT NULL COMMENT '录入人代码',
  `lrrq` DATETIME NOT NULL COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `sjgsdq` CHAR(11) NOT NULL COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  KEY `IDX_CKTS_WBSJ_ZJ_JHBFXCJG_HD` (`FP_DM`, `FPHM`),
  CONSTRAINT `PK_CKTS_WBSJ_ZJ_JHBFXCJG` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='总局交叉稽核不符发票信息协查结果信息';

-- Creating table CKTS_WBSJ_ZJ_SCWTDBBA
-- Original Oracle primary-key constraint: PK_CKTS_WBSJ_ZJ_SCWTDBBA (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_WBSJ_ZJ_SCWTDBBA` (
  `djxh` DECIMAL(20,0) COMMENT '登记序号(外贸综合服务企业)',
  `lcslid` CHAR(32) COMMENT '流程实例ID',
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID||uuid',
  `nsrmc` VARCHAR(300) COMMENT '纳税人名称',
  `hgqy_dm` VARCHAR(50) COMMENT '海关企业代码',
  `nsrsbh` VARCHAR(20) COMMENT '纳税人识别号',
  `shxydm` VARCHAR(20) COMMENT '社会信用代码',
  `wmzhfwqynsrmc` VARCHAR(300) COMMENT '外贸综合服务企业纳税人名称',
  `wmzhfwqyhgqydm` VARCHAR(50) COMMENT '外贸综合服务企业海关企业代码',
  `wmzhfwqynsrsbh` VARCHAR(20) COMMENT '外贸综合服务企业纳税人识别号',
  `wmzhfwqyshxydm` VARCHAR(20) COMMENT '外贸综合服务企业社会信用代码',
  `wmzhfwhtxyhm` VARCHAR(60) COMMENT '外贸综合服务合同（协议）号码',
  `tskhyhmc` VARCHAR(120) COMMENT '退税开户银行名称',
  `tskhyhzh` VARCHAR(50) COMMENT '退税开户银行账号',
  `dbtsbalczt_dm` CHAR(1) COMMENT '代办退税备案流程状态代码',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `lrrq` DATETIME NOT NULL COMMENT '录入日期',
  `lrr_dm` CHAR(11) NOT NULL COMMENT '录入人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `sjgsdq` CHAR(11) NOT NULL COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `bachbz` CHAR(1) COMMENT '备案撤回标志||备案撤回标志',
  `bachrq` DATETIME COMMENT '备案撤回日期',
  `rkrq` DATETIME COMMENT '入库日期',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `fqcktmsqbz` CHAR(1) COMMENT '放弃出口退（免）税权标志',
  `fqcktmsqqsrq` DATETIME COMMENT '放弃出口退（免）税权起始日期',
  `fqcktmsqjzrq` DATETIME COMMENT '放弃出口退（免）税权截止日期',
  `tzcktmsqbz` CHAR(1) COMMENT '停止出口退（免）税权标志',
  `tzcktmsqqsrq` DATETIME COMMENT '停止出口退（免）税权起始日期',
  `tzcktmsqjzrq` DATETIME COMMENT '停止出口退（免）税权截止日期',
  `tsgmsbz` CHAR(1) COMMENT '退税改免税标志',
  `tsgmsqsrq` DATETIME COMMENT '退税改免税起始日期',
  `tsgmsjzrq` DATETIME COMMENT '退税改免税截止日期',
  `nsrlx_dm` CHAR(1) COMMENT '纳税人类型代码',
  `nsrrdsjq` DATETIME COMMENT '纳税人认定时间起',
  `nsrrdsjz` DATETIME COMMENT '纳税人认定时间止',
  `ybnsrzxgmnsrsjq` DATETIME COMMENT '一般纳税人转小规模纳税人时间起',
  `ybnsrzxgmnsrsjz` DATETIME COMMENT '一般纳税人转小规模纳税人时间止',
  KEY `IDX_CKTS_WBSJ_ZJ_SCWTDBBA_HG` (`HGQY_DM`),
  KEY `IDX_CKTS_WBSJ_ZJ_SCWTDBBA_WM` (`WMZHFWQYHGQYDM`),
  CONSTRAINT `PK_CKTS_WBSJ_ZJ_SCWTDBBA` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='生产委托代办退税备案信息接收表';

-- Creating table CKTS_WBSJ_ZJ_TYYBSWTSZM
-- Original Oracle primary-key constraint: PK_CKTS_WBSJ_ZJ_TYYBSWTSZM (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_WBSJ_ZJ_TYYBSWTSZM` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID||uuid',
  `ckhwtyybswtszmbh` VARCHAR(20) COMMENT '出口货物退运已补税（未退税）证明编号',
  `sbbh_1` VARCHAR(20) COMMENT '申报编号',
  `rq` DATETIME COMMENT '日期',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `stfshxydm` VARCHAR(20) COMMENT '受托方社会信用代码',
  `stfnsrsbh` VARCHAR(20) COMMENT '受托方纳税人识别号',
  `wtfhgqydm` VARCHAR(50) COMMENT '委托方海关企业代码',
  `wtfnsrsbh` VARCHAR(20) COMMENT '委托方纳税人识别号',
  `wtfshxydm` VARCHAR(20) COMMENT '委托方社会信用代码',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `hggqka_dm` CHAR(4) COMMENT '海关关区（口岸）代码',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `ckshhxdh` VARCHAR(30) COMMENT '出口收汇核销单号',
  `ckfph` VARCHAR(30) COMMENT '出口发票号',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `ckspmc` VARCHAR(75) COMMENT '出口商品名称',
  `hgjldwmc` VARCHAR(75) COMMENT '海关计量单位名称',
  `cksl` DECIMAL(17,5) COMMENT '出口数量',
  `yjsje` DECIMAL(18,2) COMMENT '原计税金额',
  `ytzzse_1` DECIMAL(18,6) COMMENT '原退增值税额',
  `ytxfse_1` DECIMAL(18,6) COMMENT '原退消费税额',
  `tysl` DECIMAL(17,5) COMMENT '退运数量',
  `tyjsje` DECIMAL(18,2) COMMENT '退运计税金额',
  `ytsl_1` DECIMAL(16,6) COMMENT '原退税率',
  `ycjmdtse` DECIMAL(18,2) COMMENT '已冲减免抵退税额||应用于进出口退税',
  `cjssq` VARCHAR(60) COMMENT '冲减所属期',
  `ybzzse_1` DECIMAL(18,6) COMMENT '已补增值税额',
  `ybxfse_1` DECIMAL(18,6) COMMENT '已补消费税额',
  `jkshm` VARCHAR(20) COMMENT '缴款书号码',
  `hgspmc` VARCHAR(500) COMMENT '海关商品名称',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `ysbmdtse` DECIMAL(18,6) COMMENT '原申报免抵退税额',
  `jhpzh` VARCHAR(75) COMMENT '进货凭证号',
  `dlckhwzmhm` VARCHAR(20) COMMENT '代理出口货物证明号码',
  `ckemy` DECIMAL(18,2) COMMENT '出口额（美元）',
  `tyybswtstylx_dm` CHAR(1) COMMENT '退运已补税（未退税）退运类型代码',
  `ysybs` CHAR(1) COMMENT '已使用标识',
  `wtfcktszmbh` VARCHAR(20) COMMENT '委托方出口退税证明编号',
  `rkrq` DATETIME COMMENT '入库日期',
  `sybz` CHAR(1) COMMENT '使用标志',
  `sjgxsj` DATETIME COMMENT '数据更新时间',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  KEY `IDX_CKTS_WBSJ_ZJ_TYYBS_D_C` (`DJXH`, `CKHWTYYBSWTSZMBH`),
  CONSTRAINT `PK_CKTS_WBSJ_ZJ_TYYBSWTSZM` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='委托方出口货物退运已补税（未退税）证明';

-- Creating table CKTS_WBSJ_ZJ_WTCKHWZM
-- Original Oracle primary-key constraint: PK_CKTS_WBSJ_ZJ_WTCKHWZM (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_WBSJ_ZJ_WTCKHWZM` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID||uuid',
  `wtckhwzmbh` VARCHAR(20) COMMENT '委托出口货物证明编号',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `stfmc` VARCHAR(300) COMMENT '受托方名称',
  `stfnsrsbh` VARCHAR(20) COMMENT '受托方纳税人识别号',
  `stfhgqydm` VARCHAR(50) COMMENT '受托方海关企业代码',
  `rq` DATETIME COMMENT '日期',
  `wtfnsrmc` VARCHAR(300) COMMENT '委托方纳税人名称',
  `wtfnsrsbh` VARCHAR(20) COMMENT '委托方纳税人识别号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `ckspmc` VARCHAR(75) COMMENT '出口商品名称',
  `hbzm_dm` CHAR(3) COMMENT '货币字母代码',
  `cjzj` DECIMAL(18,2) COMMENT '成交总价||成交总价',
  `dlckxyh` VARCHAR(30) COMMENT '代理出口协议号',
  `bz_1` CHAR(1) COMMENT '标志',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `bz` VARCHAR(3000) COMMENT '备注',
  `cqbz_1` CHAR(1) COMMENT '超期标志',
  `zybz` CHAR(1) COMMENT '自营标志',
  `rkrq` DATETIME COMMENT '入库日期',
  `lrr_dm` CHAR(11) NOT NULL COMMENT '录入人代码',
  `lrrq` DATETIME NOT NULL COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `sjgsdq` CHAR(11) NOT NULL COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `wtfshxydm` VARCHAR(20) COMMENT '委托方社会信用代码',
  KEY `IDX_CKTS_WBSJ_WTCKHWZM_DJXH` (`DJXH`),
  KEY `IDX_CKTS_WBSJ_WTCKHWZM_S_W` (`STFHGQYDM`, `WTCKHWZMBH`),
  KEY `IDX_CKTS_WBSJ_WTCKHWZM_W_C` (`WTFNSRSBH`, `CKBGDH`),
  CONSTRAINT `PK_CKTS_WBSJ_ZJ_WTCKHWZM` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='总局委托出口货物证明';

-- Creating table CKTS_WBSJ_ZJ_XKFP
-- Original Oracle primary-key constraint: PK_CKTS_WBSJ_ZJ_XKFP (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_WBSJ_ZJ_XKFP` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID||uuid',
  `xh` DECIMAL(8,0) COMMENT '序号',
  `xxlymc` VARCHAR(150) COMMENT '信息来源名称',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `tsswjgmc` VARCHAR(300) COMMENT '退税税务机关名称',
  `ghfnsrsbh` VARCHAR(20) COMMENT '购货方纳税人识别号',
  `ghfnsrmc` VARCHAR(300) COMMENT '购货方纳税人名称',
  `kprq` DATETIME COMMENT '开票日期',
  `fp_dm` VARCHAR(12) COMMENT '发票代码',
  `fphm` VARCHAR(30) COMMENT '发票号码',
  `je` DECIMAL(18,2) COMMENT '金额',
  `se` DECIMAL(18,6) COMMENT '税额',
  `xhfnsrsbh` VARCHAR(20) COMMENT '销货方纳税人识别号',
  `xhfnsrmc` VARCHAR(300) COMMENT '销货方纳税人名称',
  `syjsbz` CHAR(1) COMMENT '善意接受标志',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `bz` VARCHAR(3000) COMMENT '备注',
  `cjrq_1` DATETIME COMMENT '采集日期',
  `czr` VARCHAR(32) COMMENT '操作人',
  `czsj` DATETIME COMMENT '操作时间||操作时间',
  `lrr_dm` CHAR(11) NOT NULL COMMENT '录入人代码',
  `lrrq` DATETIME NOT NULL COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `sjgsdq` CHAR(11) NOT NULL COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  KEY `IDX_CKTS_WBSJ_ZJ_XKFP_FPDMHM` (`FP_DM`, `FPHM`),
  KEY `IDX_CKTS_WBSJ_ZJ_XKFP_G` (`GHFNSRSBH`),
  KEY `IDX_CKTS_WBSJ_ZJ_XKFP_X` (`XHFNSRSBH`),
  KEY `IDX_CKTS_WBSJ_ZJ_XKFP_XH` (`XH`),
  CONSTRAINT `PK_CKTS_WBSJ_ZJ_XKFP` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='总局虚开发票';

-- Creating table CKTS_WBSJ_ZJ_ZJZYJKS
-- Original Oracle primary-key constraint: PK_CKTS_WBSJ_ZJ_ZJZYJKS (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_WBSJ_ZJ_ZJZYJKS` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID||uuid',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `lcslid` CHAR(32) COMMENT '流程实例ID',
  `jkshm` VARCHAR(20) COMMENT '缴款书号码',
  `yjkshm` VARCHAR(20) COMMENT '原缴款书号码',
  `tfrq` DATETIME COMMENT '填发日期',
  `tfswjg_dm` CHAR(11) COMMENT '填发税务机关代码',
  `jkdwrnsrsbh` VARCHAR(20) COMMENT '缴款单位（人）纳税人识别号',
  `jkdwrnsrmc` VARCHAR(300) COMMENT '缴款单位（人）纳税人名称',
  `jkdwrkhyhmc` VARCHAR(120) COMMENT '缴款单位（人）开户银行名称',
  `jkdwrzh` VARCHAR(50) COMMENT '缴款单位（人）账号',
  `ghfnsrsbh` VARCHAR(20) COMMENT '购货方纳税人识别号',
  `ghfnsrmc` VARCHAR(300) COMMENT '购货方纳税人名称',
  `ghqyhg_dm` VARCHAR(50) COMMENT '购货企业海关代码',
  `ckhwxfszyjkszh` VARCHAR(75) COMMENT '出口货物消费税专用缴款书字号',
  `yskm_dm` VARCHAR(9) COMMENT '预算科目代码',
  `yskmmc` VARCHAR(150) COMMENT '预算科目名称',
  `yskmjc` CHAR(1) COMMENT '预算科目级次',
  `hwlwmc` VARCHAR(300) COMMENT '货物劳务名称',
  `sjse` DECIMAL(18,6) COMMENT '实缴税额',
  `kssl` DECIMAL(18,6) COMMENT '课税数量',
  `jldw` VARCHAR(300) COMMENT '计量单位||计量单位',
  `spdj` DECIMAL(16,4) COMMENT '商品单价',
  `jsje` DECIMAL(18,2) COMMENT '计税金额',
  `fdsl` DECIMAL(16,6) COMMENT '法定税率',
  `zsl` DECIMAL(16,6) COMMENT '征收率',
  `sz` CHAR(1) COMMENT '税种',
  `wspzhmjh` VARCHAR(200) COMMENT '完税凭证号码集合',
  `sksssq` DATETIME COMMENT '税款所属时期',
  `sbspjsje` DECIMAL(18,2) COMMENT '申报税票计税金额',
  `sbsjse` DECIMAL(18,6) COMMENT '申报实缴税额',
  `rzjg` CHAR(1) COMMENT '认证结果',
  `qfbz` CHAR(1) COMMENT '清分标志',
  `clbz_1` CHAR(1) COMMENT '重录标志',
  `ssny` CHAR(6) COMMENT '所属年月',
  `cytssbjl` VARCHAR(60) COMMENT '参与退税申报记录',
  `jsbs` CHAR(1) COMMENT '缴销标识',
  `drrq` DATETIME COMMENT '读入日期',
  `djzclx_dm` CHAR(3) COMMENT '登记注册类型代码',
  `pzzg` VARCHAR(45) COMMENT '票证字轨',
  `skgk_dm` CHAR(10) COMMENT '收款国库代码',
  `skgkmc` VARCHAR(75) COMMENT '收款国库名称',
  `skxjrq` DATETIME COMMENT '税款限缴日期',
  `dzspmxxh` DECIMAL(8,0) COMMENT '电子税票明细序号',
  `zsxm_dm` VARCHAR(5) COMMENT '征收项目代码',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `lrr_dm` CHAR(11) NOT NULL COMMENT '录入人代码',
  `lrrq` DATETIME NOT NULL COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `sjgsdq` CHAR(11) NOT NULL COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `xtsphm` VARCHAR(300) COMMENT '系统税票号码',
  `bytsbz` CHAR(1) COMMENT '不予退税标志',
  KEY `IDX_CKTS_WBSJ_ZJ_ZJZYJKS_GH` (`GHQYHG_DM`),
  KEY `IDX_CKTS_WBSJ_ZJ_ZJZYJKS_J` (`JKSHM`),
  CONSTRAINT `PK_CKTS_WBSJ_ZJ_ZJZYJKS` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='接收到的核心征管消费税缴款';

-- Creating table CKTS_XXBD_SHQ
-- Original Oracle primary-key constraint: PK_CKTS_XXBD_SHQ (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_XXBD_SHQ` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号||金三企业标识',
  `sbywb_dm` VARCHAR(20) COMMENT '申报业务表代码',
  `sssq` VARCHAR(6) COMMENT '申报年月',
  `sbpc` DECIMAL(9,0) COMMENT '申报批次',
  `sbid` DECIMAL(18,0) COMMENT '申报业务序号，同SB_SBXX_HZ的ID',
  `crtime` DATETIME COMMENT '创建时间',
  `note` VARCHAR(20) DEFAULT ' ' COMMENT '备注',
  CONSTRAINT `PK_CKTS_XXBD_SHQ` PRIMARY KEY (`DJXH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='审核区（每个企业[NSRDZDAH]同时只能有一条记录）';

-- Creating table CKTS_XXBD_SHQ_YDXX
-- Original Oracle primary-key constraint: PK_CKTS_XXBD_SHQ_YDXX (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_XXBD_SHQ_YDXX` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号||金三企业标识',
  `sbywb_dm` VARCHAR(20) COMMENT '申报年月',
  `sssq` VARCHAR(6) COMMENT '申报年月',
  `sbpc` DECIMAL(9,0) COMMENT '申报批次',
  `sbid` DECIMAL(18,0) NOT NULL COMMENT '申报业务序号，同SB_SBXX_HZ的ID',
  `err_ly` CHAR(1) NOT NULL COMMENT '错误来源（0：数据自检；1：信息比对；2：审核系统反馈）',
  `xh` DECIMAL(18,0) NOT NULL COMMENT '流水号',
  `err_obj` VARCHAR(30) DEFAULT ' ' COMMENT '疑点对象（单证名称）',
  `glywb1` VARCHAR(50) DEFAULT ' ' COMMENT '关联业务表1',
  `glywb2` VARCHAR(50) DEFAULT ' ' COMMENT '关联业务表2',
  `glywb3` VARCHAR(50) DEFAULT ' ' COMMENT '关联业务表3',
  `glywz1` VARCHAR(50) DEFAULT ' ' COMMENT '关联业务值1',
  `glywz2` VARCHAR(50) DEFAULT ' ' COMMENT '关联业务值2',
  `ydcode` VARCHAR(30) DEFAULT ' ' COMMENT '疑点代码',
  `err_lev` VARCHAR(10) DEFAULT ' ' COMMENT '错误级别',
  `err_msg` VARCHAR(500) DEFAULT ' ' COMMENT '出错信息',
  `pass_flag` VARCHAR(1) DEFAULT ' ' COMMENT '可人工挑过标志',
  `crtime` DATETIME COMMENT '创建时间',
  KEY `IDX_CKTS_XXBD_SHQ_YDXX_DJXH` (`DJXH`),
  CONSTRAINT `PK_CKTS_XXBD_SHQ_YDXX` PRIMARY KEY (`XH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='审核_疑点信息';

-- Creating table CKTS_XXBD_YDXX
-- Original Oracle primary-key constraint: PK_CKTS_XXBD_YDXX (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_XXBD_YDXX` (
  `nsrdzdah` DECIMAL(20,0) NOT NULL COMMENT '纳税人电子档案号||便捷退税企业唯一标识',
  `sbywb_dm` VARCHAR(20) COMMENT '申报年月',
  `sssq` VARCHAR(6) COMMENT '申报年月',
  `sbpc` DECIMAL(9,0) COMMENT '申报批次',
  `sbid` DECIMAL(18,0) NOT NULL COMMENT '申报业务序号，同SB_SBXX_HZ的ID',
  `err_ly` CHAR(1) NOT NULL COMMENT '错误来源（0：数据自检；1：信息比对；2：审核系统反馈）',
  `xh` DECIMAL(18,0) NOT NULL COMMENT '流水号',
  `err_obj` VARCHAR(30) DEFAULT ' ' COMMENT '疑点对象（单证名称）',
  `glywb1` VARCHAR(50) DEFAULT ' ' COMMENT '关联业务表1',
  `glywb2` VARCHAR(50) DEFAULT ' ' COMMENT '关联业务表2',
  `glywb3` VARCHAR(50) DEFAULT ' ' COMMENT '关联业务表3',
  `glywz1` VARCHAR(50) DEFAULT ' ' COMMENT '关联业务值1',
  `glywz2` VARCHAR(50) DEFAULT ' ' COMMENT '关联业务值2',
  `ydcode` VARCHAR(30) DEFAULT ' ' COMMENT '疑点代码',
  `err_lev` VARCHAR(10) DEFAULT ' ' COMMENT '错误级别',
  `err_msg` VARCHAR(500) DEFAULT ' ' COMMENT '出错信息',
  `pass_flag` VARCHAR(1) DEFAULT ' ' COMMENT '可人工挑过标志',
  `crtime` DATETIME COMMENT '创建时间',
  KEY `IDX_CKTS_XXBD_YDXX_SBID` (`SBID`),
  CONSTRAINT `PK_CKTS_XXBD_YDXX` PRIMARY KEY (`SBID`, `ERR_LY`, `XH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='审核_疑点信息';

-- Creating table CKTS_ZM_BBCKTSZM_LSB
CREATE TABLE `CKTS_ZM_BBCKTSZM_LSB` (
  `sbid` DECIMAL(18,0),
  `qyhgdm` VARCHAR(20),
  `ssq` VARCHAR(60),
  `sbpc` VARCHAR(75),
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `ycktszmlx_dm` CHAR(2) COMMENT '原出口退税证明类型代码',
  `ycktszmbh` VARCHAR(20) COMMENT '原出口退税证明编号',
  `yzmkjswjgmc` VARCHAR(300) COMMENT '原证明开具税务机关名称',
  `lrrq` DATETIME COMMENT '录入日期',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `sbbh_1` VARCHAR(20) COMMENT '申报编号',
  `tbrq_1` DATETIME COMMENT '填表日期',
  KEY `IDX_CKTS_ZM_BBCKTSZM_LSB_1` (`SBID`),
  KEY `IDX_CKTS_ZM_BBCKTSZM_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='关于补办出口退税有关证明申请临时表';

-- Creating table CKTS_ZM_CKHWZNX_LSB
CREATE TABLE `CKTS_ZM_CKHWZNX_LSB` (
  `sbid` DECIMAL(18,0),
  `qyhgdm` VARCHAR(20),
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `xh_4` VARCHAR(10) COMMENT '项号',
  `yghpzh` VARCHAR(30) COMMENT '原购货凭证号',
  `ghkprq` DATETIME COMMENT '购货开票日期',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `ckspmc` VARCHAR(75) COMMENT '出口商品名称',
  `ghsl` DECIMAL(17,5) COMMENT '购货数量',
  `ghje` DECIMAL(18,2) COMMENT '购货金额',
  `ghzssl` DECIMAL(16,6) COMMENT '购货征税税率',
  `ghzsse` DECIMAL(18,6) COMMENT '购货征税税额',
  `hgjldwmc` VARCHAR(75) COMMENT '海关计量单位名称',
  `xhpzh` VARCHAR(30) COMMENT '销货凭证号',
  `nxkprq` DATETIME COMMENT '内销开票日期',
  `nxsl` DECIMAL(17,5) COMMENT '内销数量',
  `znxyy` VARCHAR(4000) COMMENT '转内销原因',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `bz` VARCHAR(3000) COMMENT '备注',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `sbbh_1` VARCHAR(20) COMMENT '申报编号',
  `kdkse` DECIMAL(18,6) COMMENT '可抵扣税额',
  `fpdm` VARCHAR(12) COMMENT '增值税发票代码（信息比对的时候通过JHPZH分解）',
  `fphm` VARCHAR(8) COMMENT '增值税发票号码（信息比对的时候通过JHPZH分解）',
  KEY `IDX_CKTS_ZM_CKHWZNX_LSB_1` (`SBID`),
  KEY `IDX_CKTS_ZM_CKHWZNX_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口货物转内销证明临时表';

-- Creating table CKTS_ZM_CKJYMSHXSB_LSB
CREATE TABLE `CKTS_ZM_CKJYMSHXSB_LSB` (
  `sbid` DECIMAL(18,0),
  `qyhgdm` VARCHAR(20),
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `jhnd` VARCHAR(10) COMMENT '计划年度',
  `jhbh` DECIMAL(8,0) COMMENT '计划编号',
  `ckfph` VARCHAR(30) COMMENT '出口发票号',
  `ckhth` VARCHAR(60) COMMENT '出口合同号',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `dlckhwzmhm` VARCHAR(20) COMMENT '代理出口货物证明号码',
  `ckshhxdh` VARCHAR(30) COMMENT '出口收汇核销单号',
  `jysp_dm` VARCHAR(20) COMMENT '卷烟商品代码',
  `jyph` VARCHAR(75) COMMENT '卷烟牌号',
  `jldwmc` VARCHAR(75) COMMENT '计量单位名称',
  `cksl` DECIMAL(17,5) COMMENT '出口数量',
  `ckhwmsxsemy` DECIMAL(18,2) COMMENT '出口货物免税销售额（美元）',
  `ckhwmsxsermb` DECIMAL(18,2) COMMENT '出口货物免税销售额（人民币）',
  `zymsgjckjyzmbh` VARCHAR(20) COMMENT '准予免税购进出口卷烟证明编号',
  `ckjyymszmbh` VARCHAR(20) COMMENT '出口卷烟已免税证明编号',
  `bz` VARCHAR(3000) COMMENT '备注',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `jhbh_1` VARCHAR(10) COMMENT '计划编号',
  KEY `IDX_CKTS_ZM_CKJYMSHXSB_LSB_1` (`SBID`),
  KEY `IDX_CKTS_ZM_CKJYMSHXSB_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口卷烟免税核销表(临时表)';

-- Creating table CKTS_ZM_CKJYYMSZM_LSB
CREATE TABLE `CKTS_ZM_CKJYYMSZM_LSB` (
  `sbid` DECIMAL(18,0),
  `qyhgdm` VARCHAR(20),
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `jyckqyshxydm` VARCHAR(20) COMMENT '卷烟出口企业社会信用代码',
  `jyckqynsrsbh` VARCHAR(20) COMMENT '卷烟出口企业纳税人识别号',
  `jyckqymc` VARCHAR(300) COMMENT '卷烟出口企业名称',
  `xh_4` VARCHAR(10) COMMENT '项号',
  `jysp_dm` VARCHAR(20) COMMENT '卷烟商品代码',
  `jymc_1` VARCHAR(75) COMMENT '卷烟名称',
  `jyph` VARCHAR(75) COMMENT '卷烟牌号',
  `jldwmc` VARCHAR(75) COMMENT '计量单位名称',
  `sl` DECIMAL(17,5) COMMENT '数量',
  `dj` DECIMAL(18,2) COMMENT '单价',
  `zjje_2` DECIMAL(18,2) COMMENT '总计金额',
  `zzs_se_dw` DECIMAL(18,2) COMMENT '免征增值税金额（单位税额）||应用于进出口退税',
  `zzs_se` DECIMAL(18,2) COMMENT '免征增值税金额（总计）||应用于进出口退税',
  `xfs_se_dw` DECIMAL(18,2) COMMENT '免征消费税金额（单位税额）||应用于进出口退税',
  `xfs_se` DECIMAL(18,2) COMMENT '免征消费税金额（总计）||应用于进出口退税',
  `zymsgjckjyzmbh` VARCHAR(20) COMMENT '准予免税购进出口卷烟证明编号',
  `fphm` VARCHAR(30) COMMENT '发票号码',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `cwfzrxm` VARCHAR(150) COMMENT '财务负责人姓名',
  `fddbrxm` VARCHAR(150) COMMENT '法定代表人姓名',
  `jbrxm` VARCHAR(75) COMMENT '经办人姓名',
  `sbbh_1` VARCHAR(20) COMMENT '申报编号',
  `tbrq_1` DATETIME COMMENT '填表日期',
  KEY `IDX_CKTS_ZM_CKJYYMSZM_LSB_1` (`SBID`),
  KEY `IDX_CKTS_ZM_CKJYYMSZM_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口卷烟已免税证明申请表(临时表)';

-- Creating table CKTS_ZM_CKZMZFQD_LSB
CREATE TABLE `CKTS_ZM_CKZMZFQD_LSB` (
  `sbid` DECIMAL(18,0),
  `qyhgdm` VARCHAR(20),
  `ssq` VARCHAR(60),
  `sbpc` VARCHAR(75),
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `cktszmbh` VARCHAR(20) COMMENT '出口退税证明编号',
  `cktszmlx_dm` CHAR(2) COMMENT '出口退税证明类型代码',
  `bz` VARCHAR(3000) COMMENT '备注',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `yzmkjswjgmc` VARCHAR(300) COMMENT '原证明开具税务机关名称',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  KEY `IDX_CKTS_ZM_CKZMZFQD_LSB_1` (`SBID`),
  KEY `IDX_CKTS_ZM_CKZMZFQD_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口证明作废清单临时表';

-- Creating table CKTS_ZM_DLCK_LSB
CREATE TABLE `CKTS_ZM_DLCK_LSB` (
  `sbid` DECIMAL(18,0),
  `qyhgdm` VARCHAR(20),
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `wtfshxydm` VARCHAR(20) COMMENT '委托方社会信用代码',
  `wtfnsrsbh` VARCHAR(20) COMMENT '委托方纳税人识别号',
  `wtfnsrmc` VARCHAR(300) COMMENT '委托方纳税人名称',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `ckshhxdh` VARCHAR(30) COMMENT '出口收汇核销单号',
  `myfs_dm` CHAR(4) COMMENT '贸易方式代码',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `hgjldwmc` VARCHAR(75) COMMENT '海关计量单位名称',
  `cksl` DECIMAL(17,5) COMMENT '出口数量',
  `hbzm_dm` CHAR(3) COMMENT '货币字母代码',
  `cjzj` DECIMAL(18,2) COMMENT '成交总价||成交总价',
  `mylaj` DECIMAL(18,2) COMMENT '美元离岸价',
  `wtdlckhth` VARCHAR(60) COMMENT '委托（代理）出口合同号',
  `hxddzbqbz` CHAR(1) COMMENT '核销单单证不齐标志',
  `bz` VARCHAR(3000) COMMENT '备注',
  `qyjbrxm` VARCHAR(150) COMMENT '企业经办人姓名',
  `jbrsfzjlx_dm` CHAR(3) COMMENT '经办人身份证件类型',
  `jbrsfzjhm` VARCHAR(30) COMMENT '经办人身份证件号码',
  `xh_4` VARCHAR(10) COMMENT '项号',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `sbbh_1` VARCHAR(20) COMMENT '申报编号',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `wtckhwzmbh` VARCHAR(20) COMMENT '委托出口货物证明编号',
  `rmblaj` DECIMAL(18,2) COMMENT '人民币离岸价',
  `ckspmc` VARCHAR(300) COMMENT '出口商品名称',
  KEY `IDX_CKTS_ZM_DLCK_LSB_1` (`SBID`),
  KEY `IDX_CKTS_ZM_DLCK_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='代理出口货物证明临时表';

-- Creating table CKTS_ZM_DLJK_LSB
CREATE TABLE `CKTS_ZM_DLJK_LSB` (
  `sbid` DECIMAL(18,0),
  `qyhgdm` VARCHAR(20),
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `xh_4` VARCHAR(10) COMMENT '项号',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `wtfnsrsbh` VARCHAR(20) COMMENT '委托方纳税人识别号',
  `wtfnsrmc` VARCHAR(300) COMMENT '委托方纳税人名称',
  `jkbgdh` VARCHAR(21) COMMENT '进口报关单号',
  `msjkljhgszgshxfs` DECIMAL(18,6) COMMENT '免税进口料件海关实征关税和消费税',
  `wtdljkhth` VARCHAR(60) COMMENT '委托（代理）进口合同号',
  `bz` VARCHAR(3000) COMMENT '备注',
  `jljgszch` VARCHAR(20) COMMENT '进料加工手（账）册号',
  `jgqynsrmc` VARCHAR(300) COMMENT '加工企业纳税人名称',
  `sbbh_1` VARCHAR(20) COMMENT '申报编号',
  `jbrxm` VARCHAR(75) COMMENT '经办人姓名',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  KEY `IDX_CKTS_ZM_DLJK_LSB_1` (`SBID`),
  KEY `IDX_CKTS_ZM_DLJK_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='代理进口货物证明临时表';

-- Creating table CKTS_ZM_LLJGHX_LSB
CREATE TABLE `CKTS_ZM_LLJGHX_LSB` (
  `sbid` DECIMAL(18,0),
  `qyhgdm` VARCHAR(20),
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `xh_4` VARCHAR(10) COMMENT '项号',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `lljgszch` VARCHAR(20) COMMENT '来料加工手（账）册号',
  `lljgmszmbh` VARCHAR(20) COMMENT '来料加工免税证明编号',
  `jgqyshxydm` VARCHAR(20) COMMENT '加工企业社会信用代码',
  `jgqynsrsbh` VARCHAR(20) COMMENT '加工企业纳税人识别号',
  `jgqynsrmc` VARCHAR(300) COMMENT '加工企业纳税人名称',
  `jgffphm` VARCHAR(30) COMMENT '加工费发票号码',
  `jgfje` DECIMAL(18,2) COMMENT '加工费金额',
  `jldwmc` VARCHAR(75) COMMENT '计量单位名称',
  `sl` DECIMAL(17,5) COMMENT '数量',
  `ckfph` VARCHAR(30) COMMENT '出口发票号',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `ckspmc` VARCHAR(75) COMMENT '出口商品名称',
  `hgjldwmc` VARCHAR(75) COMMENT '海关计量单位名称',
  `cksl` DECIMAL(17,5) COMMENT '出口数量',
  `jbrxm` VARCHAR(75) COMMENT '经办人姓名',
  `bz` VARCHAR(3000) COMMENT '备注',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `sbbh_1` VARCHAR(20) COMMENT '申报编号',
  KEY `IDX_CKTS_ZM_LLJGHX_LSB_1` (`SBID`),
  KEY `IDX_CKTS_ZM_LLJGHX_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='来料加工免税证明核销临时表';

-- Creating table CKTS_ZM_LLJG_LSB
CREATE TABLE `CKTS_ZM_LLJG_LSB` (
  `sbid` DECIMAL(18,0),
  `qyhgdm` VARCHAR(20),
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `stfnsrsbh` VARCHAR(20) COMMENT '受托方纳税人识别号',
  `stfmc` VARCHAR(300) COMMENT '受托方名称',
  `lljgszch` VARCHAR(20) COMMENT '来料加工手（账）册号',
  `jgffphm` VARCHAR(30) COMMENT '加工费发票号码',
  `ykfphwmc` VARCHAR(150) COMMENT '已开发票货物名称',
  `ykfphwdw` VARCHAR(75) COMMENT '已开发票货物单位',
  `ykfphwsl` DECIMAL(17,5) COMMENT '已开发票货物数量',
  `jgfje` DECIMAL(18,2) COMMENT '加工费金额',
  `bz` VARCHAR(3000) COMMENT '备注',
  `jbrxm` VARCHAR(75) COMMENT '经办人姓名',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `xh_4` VARCHAR(10) COMMENT '项号',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `sbbh_1` VARCHAR(20) COMMENT '申报编号',
  `tbrq_1` DATETIME COMMENT '填表日期',
  KEY `IDX_CKTS_ZM_LLJG_LSB_1` (`SBID`),
  KEY `IDX_CKTS_ZM_LLJG_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='来料加工免税证明临时表';

-- Creating table CKTS_ZM_TYYBSWTS_LSB
CREATE TABLE `CKTS_ZM_TYYBSWTS_LSB` (
  `sbid` DECIMAL(18,0),
  `qyhgdm` VARCHAR(20),
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `wtfcktszmbh` VARCHAR(20) COMMENT '委托方出口退税证明编号',
  `dlckhwzmhm` VARCHAR(20) COMMENT '代理出口货物证明号码',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `ckshhxdh` VARCHAR(30) COMMENT '出口收汇核销单号',
  `ckfph` VARCHAR(30) COMMENT '出口发票号',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `ckspmc` VARCHAR(75) COMMENT '出口商品名称',
  `hgjldwmc` VARCHAR(75) COMMENT '海关计量单位名称',
  `cksl` DECIMAL(17,5) COMMENT '出口数量',
  `hggqka_dm` CHAR(4) COMMENT '海关关区（口岸）代码',
  `yjsje` DECIMAL(18,2) COMMENT '原计税金额',
  `ysbmdtse` DECIMAL(18,6) COMMENT '原申报免抵退税额',
  `ytzzse_1` DECIMAL(18,6) COMMENT '原退增值税额',
  `ytxfse_1` DECIMAL(18,6) COMMENT '原退消费税额',
  `jhpzh` VARCHAR(75) COMMENT '进货凭证号',
  `tysl` DECIMAL(17,5) COMMENT '退运数量',
  `tyjsje` DECIMAL(18,2) COMMENT '退运计税金额',
  `ytsl_1` DECIMAL(16,6) COMMENT '原退税率',
  `ycjmdtse` DECIMAL(18,2) COMMENT '已冲减免抵退税额||应用于进出口退税',
  `cjssq` VARCHAR(60) COMMENT '冲减所属期',
  `ybzzse_1` DECIMAL(18,6) COMMENT '已补增值税额',
  `ybxfse_1` DECIMAL(18,6) COMMENT '已补消费税额',
  `jkshm` VARCHAR(20) COMMENT '缴款书号码',
  `rkrq` DATETIME COMMENT '入库日期',
  `tyybswtstylx_dm` CHAR(1) COMMENT '退运已补税（未退税）退运类型代码',
  `ysybs` CHAR(1) COMMENT '已使用标识',
  `bz` VARCHAR(3000) COMMENT '备注',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `sbbh_1` VARCHAR(20) COMMENT '申报编号',
  `xh_4` VARCHAR(10) COMMENT '项号',
  `sbny` CHAR(6) COMMENT '申报年月',
  `ckemy` DECIMAL(18,2) COMMENT '出口额（美元）',
  `hsjg` VARCHAR(20) COMMENT '核实结果',
  `sz` CHAR(1) COMMENT '税种',
  `tmsztbz` VARCHAR(50) COMMENT '退（免）税状态标志',
  `ybjtmsk` DECIMAL(18,6) COMMENT '应补缴退（免）税款',
  `ywclfs` VARCHAR(20) COMMENT '业务处理方式',
  `fpdm` VARCHAR(12) COMMENT '增值税发票代码（信息比对的时候通过JHPZH分解）',
  `fphm` VARCHAR(8) COMMENT '增值税发票号码（信息比对的时候通过JHPZH分解）',
  KEY `IDX_CKTS_ZM_TYYBSWTS_LSB_1` (`SBID`),
  KEY `IDX_CKTS_ZM_TYYBSWTS_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口货物退运已补税(未退税)证明临时表';

-- Creating table CKTS_ZM_WTCK_LSB
CREATE TABLE `CKTS_ZM_WTCK_LSB` (
  `sbid` DECIMAL(18,0),
  `qyhgdm` VARCHAR(20),
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `sbbh_1` VARCHAR(20) COMMENT '申报编号',
  `xh_4` VARCHAR(10) COMMENT '项号',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `stfshxydm` VARCHAR(20) COMMENT '受托方社会信用代码',
  `stfnsrsbh` VARCHAR(20) COMMENT '受托方纳税人识别号',
  `stfmc` VARCHAR(300) COMMENT '受托方名称',
  `dlckxyh` VARCHAR(30) COMMENT '代理出口协议号',
  `wtdlckhth` VARCHAR(60) COMMENT '委托（代理）出口合同号',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `ckspmc` VARCHAR(75) COMMENT '出口商品名称',
  `hbzm_dm` CHAR(3) COMMENT '货币字母代码',
  `bz` VARCHAR(3000) COMMENT '备注',
  `qyjbrxm` VARCHAR(150) COMMENT '企业经办人姓名',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `rmblaj` DECIMAL(18,2) COMMENT '人民币离岸价',
  KEY `IDX_CKTS_ZM_WTCK_LSB_1` (`SBID`),
  KEY `IDX_CKTS_ZM_WTCK_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='委托出口货物证明临时表';

-- Creating table CKTS_ZM_ZBZM_LSB
CREATE TABLE `CKTS_ZM_ZBZM_LSB` (
  `sbid` DECIMAL(18,0),
  `qyhgdm` VARCHAR(20),
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `zbjgszdswjgmc` VARCHAR(300) COMMENT '中标机构所在地税务机关名称',
  `zbqynsrsbh` VARCHAR(20) COMMENT '中标企业纳税人识别号',
  `zbqymc` VARCHAR(300) COMMENT '中标企业名称',
  `zbwjbh` VARCHAR(50) COMMENT '招标文件编号',
  `zbxmmc` VARCHAR(600) COMMENT '中标项目名称',
  `dkgbjgmc` VARCHAR(300) COMMENT '贷款国别（机构）名称',
  `mgjckyhzqdbdkxmqd` VARCHAR(4000) COMMENT '美国进出口银行主权担保贷款项目清单',
  `zbjdcpmc` VARCHAR(120) COMMENT '中标机电产品名称',
  `ggxh` VARCHAR(150) COMMENT '规格型号',
  `sl` DECIMAL(17,5) COMMENT '数量',
  `dj` DECIMAL(18,2) COMMENT '单价',
  `zj` DECIMAL(18,2) COMMENT '总价',
  `yhjewmy` DECIMAL(16,4) COMMENT '用汇金额（万美元）',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `ckspmc` VARCHAR(75) COMMENT '出口商品名称',
  `zbjgfzrxm` VARCHAR(150) COMMENT '招标机构负责人姓名',
  `zbjgsqrq` DATETIME COMMENT '招标机构申请日期',
  `bz` VARCHAR(3000) COMMENT '备注',
  `btsbz` CHAR(1) COMMENT '不退税标志',
  `btsyy` VARCHAR(4000) COMMENT '不退税原因',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `xh_4` VARCHAR(10) COMMENT '项号',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `sbbh_1` VARCHAR(20) COMMENT '申报编号',
  `zbjgmc` VARCHAR(300) COMMENT '招标机构名称',
  `jkgjjspmc` VARCHAR(500) COMMENT '进口关键件商品名称',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `jkgjjyhwmy` DECIMAL(16,4) COMMENT '进口关键件用汇（万美元）',
  KEY `IDX_CKTS_ZM_ZBZM_LSB_1` (`SBID`),
  KEY `IDX_CKTS_ZM_ZBZM_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='中标证明通知书临时表';

-- Creating table CKTS_ZM_ZYMSGJJY_LSB
CREATE TABLE `CKTS_ZM_ZYMSGJJY_LSB` (
  `sbid` DECIMAL(18,0),
  `qyhgdm` VARCHAR(20),
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `sbbh_1` VARCHAR(20) COMMENT '申报编号',
  `jyscqyshxydm` VARCHAR(20) COMMENT '卷烟生产企业社会信用代码',
  `jyscqynsrsbh` VARCHAR(20) COMMENT '卷烟生产企业纳税人识别号',
  `jyscqymc` VARCHAR(300) COMMENT '卷烟生产企业名称',
  `jhnd` VARCHAR(10) COMMENT '计划年度',
  `jhbh` DECIMAL(8,0) COMMENT '计划编号',
  `xh_4` VARCHAR(10) COMMENT '项号',
  `jysp_dm` VARCHAR(20) COMMENT '卷烟商品代码',
  `jymc_1` VARCHAR(75) COMMENT '卷烟名称',
  `jyph` VARCHAR(75) COMMENT '卷烟牌号',
  `jldwmc` VARCHAR(75) COMMENT '计量单位名称',
  `sl` DECIMAL(17,5) COMMENT '数量',
  `dj` DECIMAL(18,2) COMMENT '单价',
  `zjje_2` DECIMAL(18,2) COMMENT '总计金额',
  `ckjyjhsl` DECIMAL(17,5) COMMENT '出口卷烟计划数量',
  `ykjzmzjysl` DECIMAL(17,5) COMMENT '已开具《准免证》卷烟数量',
  `bz` VARCHAR(3000) COMMENT '备注',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `jhbh_1` VARCHAR(10) COMMENT '计划编号',
  KEY `IDX_CKTS_ZM_ZYMSGJJY_LSB_1` (`SBID`),
  KEY `IDX_CKTS_ZM_ZYMSGJJY_LSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='准予免税购进出口卷烟证明申请表（临时表）';

-- Creating table DM_CKFL
-- Original Oracle primary-key constraint: PK_DM_CKFL (MySQL index name: PRIMARY).
CREATE TABLE `DM_CKFL` (
  `ckfl_dm` VARCHAR(10) NOT NULL COMMENT '出口分类代码  SPDM/CKKA/MDG/GHS',
  `ckfl_mc` VARCHAR(100) NOT NULL COMMENT '出口分类名称  商品名称/出口口岸/目的国/供货商',
  `fldmcd` DECIMAL(4,0) NOT NULL COMMENT '分类代码长度 0表示按全代码分类，4表示按前4位字符串做分类',
  `dbfield` VARCHAR(100) COMMENT '数据库字段名',
  CONSTRAINT `PK_DM_CKFL` PRIMARY KEY (`CKFL_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_CZRY
-- Original Oracle primary-key constraint: PK_DM_CZRY (MySQL index name: PRIMARY).
CREATE TABLE `DM_CZRY` (
  `czry_dm` VARCHAR(20) NOT NULL,
  `czry_mc` VARCHAR(80) NOT NULL,
  `password` VARCHAR(50),
  `swjg_dm` VARCHAR(11) NOT NULL,
  `czry_dm_zg` VARCHAR(20) DEFAULT NULL,
  `yhlx` CHAR(2) NOT NULL DEFAULT '00',
  `usrstate` CHAR(1),
  `description` VARCHAR(200),
  `crtime` DATETIME,
  `crname` VARCHAR(20),
  `uptime` DATETIME,
  `upname` VARCHAR(20),
  `qybz` CHAR(1) NOT NULL DEFAULT 'Y',
  `lxdh` VARCHAR(32),
  `qx_swjg` VARCHAR(11),
  `czry_tssh` VARCHAR(20),
  CONSTRAINT `PK_DM_CZRY` PRIMARY KEY (`CZRY_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_CZRY_NEW
CREATE TABLE `DM_CZRY_NEW` (
  `czry_dm` VARCHAR(20) NOT NULL,
  `czry_mc` VARCHAR(80) NOT NULL,
  `password` VARCHAR(50),
  `swjg_dm` VARCHAR(11) NOT NULL,
  `czry_dm_zg` VARCHAR(20),
  `yhlx` CHAR(2) NOT NULL,
  `usrstate` CHAR(1),
  `description` VARCHAR(200),
  `crtime` DATETIME,
  `crname` VARCHAR(20),
  `uptime` DATETIME,
  `upname` VARCHAR(20),
  `qybz` CHAR(1) NOT NULL,
  `lxdh` VARCHAR(32),
  `qx_swjg` VARCHAR(11)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_FILTER_RULE
-- Original Oracle primary-key constraint: PK_DM_FILTER_RULE (MySQL index name: PRIMARY).
CREATE TABLE `DM_FILTER_RULE` (
  `rule_dm` VARCHAR(10) NOT NULL COMMENT '筛选规则代码',
  `rule_mc` VARCHAR(100) NOT NULL COMMENT '筛选规则名称',
  `note` VARCHAR(4) NOT NULL COMMENT '评分规则说明',
  `zb_dm` VARCHAR(10) COMMENT '涉及的指标代码',
  `score` DECIMAL(8,0) NOT NULL COMMENT '加或扣分总额 0-1000(100%权重的值）',
  `errlevel` DECIMAL(4,0) NOT NULL COMMENT '异常等级  从低到高0-9',
  CONSTRAINT `PK_DM_FILTER_RULE` PRIMARY KEY (`RULE_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_GBDL
CREATE TABLE `DM_GBDL` (
  `dl` VARCHAR(3) NOT NULL,
  `mc` VARCHAR(30),
  PRIMARY KEY (`DL`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_GT3_XML_CONFIG
-- Original Oracle primary-key constraint: DM_GT3_XML_CONFIG_PKEY (MySQL index name: PRIMARY).
CREATE TABLE `DM_GT3_XML_CONFIG` (
  `id` DECIMAL(38,0) NOT NULL,
  `sbyw_dm` VARCHAR(32) NOT NULL COMMENT '申报业务代码',
  `root_tag_name` VARCHAR(255) NOT NULL COMMENT '申报业务对应的xml文档根节点名称',
  `xsi_type` VARCHAR(255) NOT NULL COMMENT '用于标识报文的类型',
  `bbh` VARCHAR(255),
  `xmlbh` VARCHAR(255),
  `xmlmc` VARCHAR(255),
  `xsi_schemalocation` VARCHAR(255),
  `xmlns_xsi` VARCHAR(255),
  `xmlns` VARCHAR(255),
  `sbyw_mc` VARCHAR(100) COMMENT '申报业务名称',
  `jkbh` VARCHAR(100) COMMENT '接口编号',
  `lcsx_dm` VARCHAR(100) COMMENT '（金三）税务流程事项代码',
  `jkfw_id` VARCHAR(100) COMMENT '接口服务清册ID',
  `zjfk_id` VARCHAR(100),
  UNIQUE KEY `SBYW_DM_UNIQ_INDEX` (`SBYW_DM`),
  CONSTRAINT `DM_GT3_XML_CONFIG_PKEY` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_GT3_XML_FIELD_CONFIG
-- Original Oracle primary-key constraint: DM_GT3_XML_FIELD_CONFIG_PKEY2 (MySQL index name: PRIMARY).
CREATE TABLE `DM_GT3_XML_FIELD_CONFIG` (
  `id` DECIMAL(38,0) NOT NULL,
  `sbb_dm` VARCHAR(255) COMMENT '数据表代码',
  `field_name` VARCHAR(255) COMMENT '字段名称',
  `field_zh` VARCHAR(255) COMMENT '字段中文释义',
  `tag_name` VARCHAR(255) COMMENT 'xml标签名称',
  `default_value` VARCHAR(255) COMMENT '缺省值',
  `fmt_str` VARCHAR(255) COMMENT '格式化公式',
  `max_len` DECIMAL(38,0) COMMENT '最大长度',
  `tbl_name` VARCHAR(255) COMMENT '数据表名',
  `note` VARCHAR(100) COMMENT '表单名称',
  `gt3field_name` VARCHAR(100) COMMENT '金三字段名',
  `sbb_dm_suffix` VARCHAR(100) COMMENT '申报表代码后缀,用户历史查询',
  `qybz` CHAR(1) COMMENT '报文标志',
  CONSTRAINT `DM_GT3_XML_FIELD_CONFIG_PKEY2` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_GT3_XML_TBL_CONFIG
-- Original Oracle primary-key constraint: DM_GT3_XML_TBL_CONFIG_PKEY (MySQL index name: PRIMARY).
CREATE TABLE `DM_GT3_XML_TBL_CONFIG` (
  `id` DECIMAL(38,0) NOT NULL,
  `sbyw_dm` VARCHAR(32) NOT NULL COMMENT '申报业务代码',
  `sbb_dm` VARCHAR(255) NOT NULL COMMENT '申报表代码',
  `tbl_name` VARCHAR(255) COMMENT '申报数据表名称',
  `query_service` VARCHAR(255) COMMENT '查询服务',
  `query_sqlid` VARCHAR(255) COMMENT '查询sql mapper标识',
  `tag_name` VARCHAR(255) COMMENT '数据节点tag名称',
  `tag_child_suffix` VARCHAR(255) DEFAULT 'lb' COMMENT '循环节点后缀',
  `qybz` CHAR(1) NOT NULL DEFAULT 'Y' COMMENT '是否启用 Y-启用 N-不启用',
  `fksqlid` VARCHAR(255) COMMENT '历史数据查询SQL ID',
  `sbbfb` VARCHAR(255) COMMENT '附表自检标志',
  `sbb_mc` VARCHAR(100),
  `gt3tbl_name` VARCHAR(255) COMMENT '金三库表名',
  `sbbfbdm` VARCHAR(50) COMMENT '申报向导图附表代码',
  CONSTRAINT `DM_GT3_XML_TBL_CONFIG_PKEY` PRIMARY KEY (`ID`),
  CONSTRAINT `SBYW_TBL_INDEX` UNIQUE (`SBYW_DM`, `SBB_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_HIS_DATA_FIELD
-- Original Oracle primary-key constraint: DM_HIS_DATA_FIELD_ID (MySQL index name: PRIMARY).
CREATE TABLE `DM_HIS_DATA_FIELD` (
  `id` DECIMAL(20,0) NOT NULL COMMENT 'ID',
  `sbbdm` VARCHAR(20) NOT NULL COMMENT '申报表代码',
  `souce_field` VARCHAR(20) NOT NULL COMMENT '局端字段名',
  `target_field` VARCHAR(20) NOT NULL COMMENT '云平台字段名',
  `bz` VARCHAR(50) COMMENT '备注',
  `qybj` VARCHAR(1) DEFAULT 'Y' COMMENT '启用标记 (Y为启用，N为未启用)  默认启用',
  CONSTRAINT `DM_HIS_DATA_FIELD_ID` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='历史数据查询 局端字段与云平台字段 对应关系';

-- Creating table DM_HIS_DATA_TABLE
-- Original Oracle primary-key constraint: DM_HIS_DATA_ID (MySQL index name: PRIMARY).
CREATE TABLE `DM_HIS_DATA_TABLE` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '主键',
  `sbywbdm` VARCHAR(20) NOT NULL COMMENT '申报业务表代码',
  `sbbdm` VARCHAR(20) NOT NULL COMMENT '申报表代码',
  `namespace` VARCHAR(50) NOT NULL COMMENT 'sql 的nameSpace',
  `bz` VARCHAR(50) COMMENT '备注',
  `qybj` VARCHAR(1) DEFAULT 'Y' COMMENT '启用标记 (启用为Y，未启用为N，默认为启用)',
  CONSTRAINT `DM_HIS_DATA_ID` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='历史数据局端查询 对应关系表';

-- Creating table DM_HY
-- Original Oracle primary-key constraint: PK_DM_HY (MySQL index name: PRIMARY).
CREATE TABLE `DM_HY` (
  `hy_dm` VARCHAR(10) NOT NULL,
  `hy_mc` VARCHAR(100) NOT NULL,
  CONSTRAINT `PK_DM_HY` PRIMARY KEY (`HY_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_HY_TS
-- Original Oracle primary-key constraint: PK_DM_HY_TS (MySQL index name: PRIMARY).
CREATE TABLE `DM_HY_TS` (
  `hy_ts_dm` VARCHAR(10) NOT NULL,
  `hy_ts_mc` VARCHAR(100) NOT NULL,
  CONSTRAINT `PK_DM_HY_TS` PRIMARY KEY (`HY_TS_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_PART_FKFIELD
CREATE TABLE `DM_PART_FKFIELD` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '主键',
  `sbbdm` VARCHAR(50) NOT NULL COMMENT '申报表代码',
  `tag` VARCHAR(200) NOT NULL COMMENT '字段标签',
  `fname` VARCHAR(200) COMMENT '字段名',
  `nullval` VARCHAR(200) COMMENT '是否为空',
  `datatype` VARCHAR(50) COMMENT '数据类型',
  `fmt` VARCHAR(200) COMMENT '数据格式',
  `cname` VARCHAR(50) COMMENT '字段中文名',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='反馈部分字段表结构代码';

-- Creating table DM_PART_FKTBL
CREATE TABLE `DM_PART_FKTBL` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '????',
  `sbywb_dm` VARCHAR(20) NOT NULL COMMENT '??????????????',
  `sbbdm` VARCHAR(50) NOT NULL COMMENT '??????????',
  `tblname` VARCHAR(200) NOT NULL COMMENT '????',
  `sqlid` VARCHAR(200) COMMENT '????sqlid',
  `qybj` CHAR(1) NOT NULL COMMENT '????????',
  `bz` VARCHAR(200) COMMENT '????',
  UNIQUE KEY `UQ_DM_PART_XMLTBL_SS` (`SBYWB_DM`, `SBBDM`),
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='??????????????????????';

-- Creating table DM_ROLE
-- Original Oracle primary-key constraint: PK_DM_ROLE (MySQL index name: PRIMARY).
CREATE TABLE `DM_ROLE` (
  `role_dm` VARCHAR(20) NOT NULL COMMENT '角色代码',
  `role_mc` VARCHAR(20) NOT NULL COMMENT '角色名称',
  `description` VARCHAR(200) COMMENT '角色描述',
  `crtime` DATETIME COMMENT '创建时间',
  `crname` VARCHAR(20) COMMENT '创建人员',
  `uptime` DATETIME COMMENT '更新时间',
  `upname` VARCHAR(20) COMMENT '更新人员',
  `qybz` CHAR(1) COMMENT '启用标识',
  CONSTRAINT `PK_DM_ROLE` PRIMARY KEY (`ROLE_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='权限管理_角色代码表';

-- Creating table DM_SERVICE
-- Original Oracle primary-key constraint: PK_DM_SERVICE (MySQL index name: PRIMARY).
CREATE TABLE `DM_SERVICE` (
  `service_dm` VARCHAR(200) NOT NULL COMMENT '服务代码',
  `service_mc` VARCHAR(20) NOT NULL COMMENT '服务名称',
  `description` VARCHAR(200) COMMENT '服务描述',
  `menu_set` VARCHAR(200) COMMENT '服务对应客户端菜单列表',
  `crtime` DATETIME COMMENT '创建时间',
  `crname` VARCHAR(20) COMMENT '创建人员',
  `uptime` DATETIME COMMENT '更新时间',
  `upname` VARCHAR(20) COMMENT '更新人员',
  `qybz` CHAR(1) COMMENT '启用标识',
  CONSTRAINT `PK_DM_SERVICE` PRIMARY KEY (`SERVICE_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='权限管理_服务代码';

-- Creating table DM_SHYD
-- Original Oracle primary-key constraint: PK_DM_SHYD (MySQL index name: PRIMARY).
CREATE TABLE `DM_SHYD` (
  `sbywbdm` VARCHAR(10) NOT NULL COMMENT '申报业务表代码',
  `ydcode` VARCHAR(10) NOT NULL COMMENT '疑点代码',
  `err_obj` VARCHAR(30) COMMENT '疑点对象(单证名称)',
  `err_msg` VARCHAR(255) NOT NULL COMMENT '疑点信息',
  `err_lev` VARCHAR(10) COMMENT '疑点等级',
  `pass_flag` VARCHAR(1) COMMENT '是否可挑过',
  `is_valid` CHAR(1) DEFAULT '1' COMMENT '启用标志',
  `qy_flag` CHAR(1) COMMENT '用于企业',
  `gs_flag` CHAR(1) COMMENT '用于税务',
  CONSTRAINT `PK_DM_SHYD` PRIMARY KEY (`SBYWBDM`, `YDCODE`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='审核疑点字典表';

-- Creating table DM_SJFK_XMLFIELD
-- Original Oracle primary-key constraint: PK_DM_SJFK_XMLFIELD (MySQL index name: PRIMARY).
CREATE TABLE `DM_SJFK_XMLFIELD` (
  `id` DECIMAL(18,0) NOT NULL,
  `tblname` VARCHAR(200) NOT NULL,
  `xmltag` VARCHAR(200) NOT NULL,
  `fname` VARCHAR(200),
  `issbxx` CHAR(1) NOT NULL,
  `nullval` VARCHAR(200),
  `datatype` VARCHAR(50),
  `fmt` VARCHAR(200),
  `cname` VARCHAR(50),
  `fname_ys` VARCHAR(200),
  `sbbdm` VARCHAR(20),
  `maxlen` DECIMAL(10,0),
  CONSTRAINT `PK_DM_SJFK_XMLFIELD` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_SJFK_XMLTBL
-- Original Oracle primary-key constraint: PK_DM_SJFK_XMLTBL (MySQL index name: PRIMARY).
-- Auxiliary UNIQUE index UQ_DM_SJFK_XMLTBL_SS_ORACLE_NULLS preserves Oracle composite-UNIQUE NULL behavior: duplicate partially-NULL keys are rejected; wholly-NULL keys remain allowed. NULL flags prevent sentinel collisions; original named UNIQUE key is kept.
CREATE TABLE `DM_SJFK_XMLTBL` (
  `id` DECIMAL(18,0) NOT NULL,
  `sbywb_dm` VARCHAR(20) NOT NULL COMMENT '申报业务表代码，如生产免抵退A0305001',
  `sbbdm` VARCHAR(50) COMMENT '申报表代码，如免抵退明细表0305001010',
  `tblname` VARCHAR(200) NOT NULL COMMENT '云平台数据表名称，如免抵退明细表sb_mdts_mxb',
  `sqlid` VARCHAR(200) COMMENT '历史数据反馈局端查询sql',
  `gridtag` VARCHAR(200) NOT NULL COMMENT '申报、反馈报文节点名称',
  `qybj` CHAR(1) NOT NULL COMMENT '启用标记',
  `fksqlid` VARCHAR(500) COMMENT '初审往临时表写数据sql',
  `sbbfb` VARCHAR(50) COMMENT '对应云端申报表附表名称，暂时没用',
  `tblname_ys` VARCHAR(200) COMMENT '初审临时表表名',
  UNIQUE KEY `UQ_DM_SJFK_XMLTBL_SS` (`SBYWB_DM`, `SBBDM`),
  CONSTRAINT `PK_DM_SJFK_XMLTBL` PRIMARY KEY (`ID`),
  UNIQUE KEY `UQ_DM_SJFK_XMLTBL_SS_ORACLE_NULLS` (`sbywb_dm`, (COALESCE(`sbbdm`, '')), (`sbbdm` IS NULL))
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_SPDM4
CREATE TABLE `DM_SPDM4` (
  `spdm4` VARCHAR(10) NOT NULL,
  `spmc` VARCHAR(50),
  `spfname` VARCHAR(400),
  `ml` VARCHAR(4),
  PRIMARY KEY (`SPDM4`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_SWJG_BAK20220322
CREATE TABLE `DM_SWJG_BAK20220322` (
  `swjg_dm` VARCHAR(11) NOT NULL,
  `swjg_mc` VARCHAR(80) NOT NULL,
  `swjg_jc` VARCHAR(80) NOT NULL,
  `swjg_dm_sj` VARCHAR(11) NOT NULL,
  `yxws` DECIMAL(10,0),
  `swjg_bz` CHAR(1) NOT NULL,
  `qybz` CHAR(1) NOT NULL,
  `tsjg_bz` CHAR(1)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_SWJG_DZB
CREATE TABLE `DM_SWJG_DZB` (
  `glxt_swjg_dm` VARCHAR(11) NOT NULL,
  `swjg_dm` VARCHAR(11) NOT NULL,
  `swjg_mc` VARCHAR(100),
  `cnt` DECIMAL(10,0),
  PRIMARY KEY (`GLXT_SWJG_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_SWJG_TJ
CREATE TABLE `DM_SWJG_TJ` (
  `swjgdm` VARCHAR(11) NOT NULL,
  `swjgmc` VARCHAR(50),
  `swjgjc` VARCHAR(50),
  `sjdm` VARCHAR(11),
  `dispsx` VARCHAR(20) COMMENT '显示缩写',
  PRIMARY KEY (`SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_TABLE
-- Original Oracle primary-key constraint: DM_TABLE_ID (MySQL index name: PRIMARY).
CREATE TABLE `DM_TABLE` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '主键',
  `sbywbdm` VARCHAR(20) NOT NULL COMMENT '申报业务表代码',
  `sbbdm` VARCHAR(20) NOT NULL COMMENT '申报表代码',
  `namespace` VARCHAR(50) COMMENT 'sql 的nameSpace',
  `bz` VARCHAR(100) COMMENT '备注',
  `qybj` VARCHAR(1) DEFAULT 'Y' COMMENT '启用标记 (启用为Y，未启用为N，默认为启用)',
  `sbbfbdm` VARCHAR(50),
  CONSTRAINT `DM_TABLE_ID` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='gt3_tbl表，历史数据查询sqlid配置（备份表）';

-- Creating table DM_TBLX
-- Original Oracle primary-key constraint: PK_DM_TBLX (MySQL index name: PRIMARY).
CREATE TABLE `DM_TBLX` (
  `id` DECIMAL(18,0) NOT NULL,
  `mc` VARCHAR(200) NOT NULL,
  `tblx_dm` VARCHAR(50) NOT NULL,
  `sqlid` VARCHAR(1000),
  `qzfw` VARCHAR(200),
  `hzfw` VARCHAR(200),
  `tbhfw` VARCHAR(200),
  `bz` VARCHAR(1000),
  `qybj` CHAR(1) NOT NULL,
  UNIQUE KEY `UQ_DM_TBLX_LX` (`TBLX_DM`),
  CONSTRAINT `PK_DM_TBLX` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_YJXX
CREATE TABLE `DM_YJXX` (
  `yjcode` VARCHAR(10) NOT NULL COMMENT '预警代码',
  `yjname` VARCHAR(20) NOT NULL COMMENT '预警名称',
  `yj_msg` VARCHAR(255) NOT NULL COMMENT '预警信息',
  `required` CHAR(1) COMMENT '税务必选',
  `qy_flag` CHAR(1) COMMENT '用于企业',
  `gs_flag` CHAR(1) COMMENT '用于税务',
  `is_valid` CHAR(1) COMMENT '是否有效',
  `swcode` VARCHAR(100) COMMENT '提交税务机关集（用,隔开）'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_YSFS
CREATE TABLE `DM_YSFS` (
  `ysfscode` VARCHAR(4) NOT NULL,
  `ysfsmc` VARCHAR(60),
  PRIMARY KEY (`YSFSCODE`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_ZB
-- Original Oracle primary-key constraint: PK_DM_ZB (MySQL index name: PRIMARY).
CREATE TABLE `DM_ZB` (
  `zb_dm` VARCHAR(10) NOT NULL COMMENT '指标代码',
  `zb_mc` VARCHAR(100) NOT NULL COMMENT '指标名称',
  `zbfl` VARCHAR(100) COMMENT '指标分类，预留（如退税指标、纳税指标、财务指标等）',
  `qylx` CHAR(1) COMMENT '企业类型，该指标适用企业类型 1生产 2外贸 3全部企业类型',
  `zbsm` VARCHAR(1000) COMMENT '指标说明',
  `zbgs` VARCHAR(1000) COMMENT '公式文字描述',
  `jsbds` VARCHAR(1000) COMMENT '计算公式的表达式',
  `cssm` VARCHAR(1000) COMMENT '参数说明，对PM1到PM9参数进行说明',
  `pdyc` VARCHAR(4000) COMMENT '判定异常描述，该指标何种情况判定为异常，且异常的风险监控点描述',
  `val_min` DECIMAL(16,2) COMMENT '指标值下限，空表示无',
  `val_max` DECIMAL(16,2) COMMENT '指标值上限，空表示无',
  `ed_min` DECIMAL(16,4) COMMENT '差额额度下限，空表示无,差额额度=VAL-基期VAL',
  `ed_max` DECIMAL(16,4) COMMENT '差额额度上限，空表示无',
  `fd_min` DECIMAL(16,4) COMMENT '差额幅度下限，空表示无,差额幅度=(VAL-基期VAL)/基期VAL',
  `fd_max` DECIMAL(16,4) COMMENT '差额幅度上限，空表示无',
  `hybz` CHAR(1) NOT NULL COMMENT '行业比较标志1表示可与行业指标做横向比较 0表示不',
  CONSTRAINT `PK_DM_ZB` PRIMARY KEY (`ZB_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_ZB_HYCS
-- Original Oracle primary-key constraint: PK_DM_ZB_HYCS (MySQL index name: PRIMARY).
CREATE TABLE `DM_ZB_HYCS` (
  `zb_dm` VARCHAR(10) NOT NULL COMMENT '指标代码',
  `hy_dm` VARCHAR(10) NOT NULL COMMENT '行业代码',
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码 预留，考虑要按地区+行业来预警',
  `ed_min` DECIMAL(16,4) COMMENT '差额额度下限  空表示无,减平均值 得到的差额额度',
  `ed_max` DECIMAL(16,4) COMMENT '差额额度上限  空表示无',
  `ed_qz_unit` DECIMAL(16,4) COMMENT '单位权重差额额度  每10%权重的差额额度值',
  `fd_min` DECIMAL(16,4) COMMENT '差额幅度下限  空表示无,与平均值的差额/平均值 得到的差额幅度',
  `fd_max` DECIMAL(16,4) COMMENT '差额幅度上限  空表示无',
  `fd_qz_unit` DECIMAL(16,4) COMMENT '单位权重差额幅度  每10%权重的差额幅度值',
  CONSTRAINT `PK_DM_ZB_HYCS` PRIMARY KEY (`ZB_DM`, `HY_DM`, `SWJG_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DOC_FILEINFO
-- Original Oracle primary-key constraint: PK_DOC_FILEINFO (MySQL index name: PRIMARY).
-- FILEPATH uses utf8mb3 (BMP characters; no supplementary Unicode characters) so its full 1000-character UNIQUE index fits InnoDB 3072 bytes. No unique prefix or hash replacement is used.
-- The FILEPATH UNIQUE index additionally includes OCTET_LENGTH(FILEPATH): utf8mb3_bin is PAD SPACE, so the length expression preserves Oracle VARCHAR2 uniqueness for paths differing by trailing spaces.
CREATE TABLE `DOC_FILEINFO` (
  `id` DECIMAL(18,0) NOT NULL,
  `filename` VARCHAR(1000),
  `fmcode` VARCHAR(50),
  `title` VARCHAR(200),
  `filesize` DECIMAL(18,0),
  `rootpath` VARCHAR(1000) NOT NULL,
  `filepath` VARCHAR(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `busitype` VARCHAR(200),
  `busikey` DECIMAL(18,0),
  `nsrdzdah` DECIMAL(20,0),
  `filetype` CHAR(1) NOT NULL,
  `note` VARCHAR(4000),
  `issign` CHAR(1) NOT NULL,
  `crid` DECIMAL(18,0),
  `crtime` DATETIME(6),
  `upid` DECIMAL(18,0),
  `uptime` DATETIME(6),
  `nsrsbh` VARCHAR(20),
  `islock` CHAR(1) COMMENT '默认空，Y 已阅锁定 N解除',
  `note2` VARCHAR(4000) COMMENT '备注2',
  `dycs` DECIMAL(10,0),
  `zmbh` VARCHAR(30) COMMENT '证明编号',
  `fjlx` VARCHAR(40) COMMENT '附件类型',
  KEY `IX_DOC_FILEINFO_BB` (`BUSITYPE`, `BUSIKEY`),
  KEY `IX_DOC_FILEINFO_NB` (`NSRSBH`, `BUSITYPE`),
  KEY `IX_DOC_FILEINFO_NBB` (`NSRDZDAH`, `BUSITYPE`, `BUSIKEY`),
  UNIQUE KEY `UQ_DOC_FILEINFO_FILEPATH` (`FILEPATH`, (OCTET_LENGTH(`FILEPATH`))),
  CONSTRAINT `PK_DOC_FILEINFO` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DOC_FILEINFO_DYCK
-- Original Oracle primary-key constraint: PK_DOC_FILEINFO_DYCK (MySQL index name: PRIMARY).
-- FILEPATH uses utf8mb3 (BMP characters; no supplementary Unicode characters) so its full 1000-character UNIQUE index fits InnoDB 3072 bytes. No unique prefix or hash replacement is used.
-- The FILEPATH UNIQUE index additionally includes OCTET_LENGTH(FILEPATH): utf8mb3_bin is PAD SPACE, so the length expression preserves Oracle VARCHAR2 uniqueness for paths differing by trailing spaces.
CREATE TABLE `DOC_FILEINFO_DYCK` (
  `id` DECIMAL(18,0) NOT NULL,
  `filename` VARCHAR(1000),
  `fmcode` VARCHAR(50),
  `title` VARCHAR(200),
  `filesize` DECIMAL(18,0),
  `rootpath` VARCHAR(1000) NOT NULL,
  `filepath` VARCHAR(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `busitype` VARCHAR(200),
  `busikey` DECIMAL(18,0),
  `nsrdzdah` DECIMAL(20,0),
  `filetype` CHAR(1) NOT NULL,
  `note` VARCHAR(4000),
  `issign` CHAR(1) NOT NULL,
  `crid` DECIMAL(18,0),
  `crtime` DATETIME(6),
  `upid` DECIMAL(18,0),
  `uptime` DATETIME(6),
  `nsrsbh` VARCHAR(20),
  `islock` CHAR(1) COMMENT '默认空，Y 已阅锁定 N解除',
  `note2` VARCHAR(4000) COMMENT '备注2',
  `dycs` DECIMAL(10,0),
  KEY `IX_DOC_FILEINFO_DYCK_NB` (`NSRSBH`, `BUSITYPE`),
  KEY `IX_DOC_FILEINFO_DYCK_NBB` (`NSRDZDAH`, `BUSITYPE`, `BUSIKEY`),
  UNIQUE KEY `UQ_DOC_FILEINFO_DYCK_FILEPATH` (`FILEPATH`, (OCTET_LENGTH(`FILEPATH`))),
  CONSTRAINT `PK_DOC_FILEINFO_DYCK` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='单一窗口备份';

-- Creating table DOC_FILEINFO_KZ
CREATE TABLE `DOC_FILEINFO_KZ` (
  `id` DECIMAL(18,0) NOT NULL,
  `clbz` CHAR(1) COMMENT '处理标志  0：待下载    1：已下载',
  `filehash` VARCHAR(40) COMMENT '文件哈希',
  `rootpath` VARCHAR(255) COMMENT '根路径',
  `filepath` VARCHAR(1000) COMMENT '文件相对路径',
  `crtime` DATETIME(6) COMMENT '创建时间',
  `uptime` DATETIME(6) COMMENT '修改时间',
  `downloadnum` DECIMAL(5,0) COMMENT '下载次数',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DSF_DECLARE_COMPANYINFO
-- Original Oracle primary-key constraint: PK_DSF_DECLARE_COMPANYINFO (MySQL index name: PRIMARY).
CREATE TABLE `DSF_DECLARE_COMPANYINFO` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '序号',
  `social_credit_code` VARCHAR(20) NOT NULL COMMENT '统一社会信用代码',
  `tax_name` VARCHAR(100) NOT NULL COMMENT '纳税人名称',
  `customs_company_code` VARCHAR(20) COMMENT '海关企业代码',
  `agent_code` VARCHAR(30) COMMENT '对外贸易经营者备案登记表编号',
  `company_type` CHAR(2) NOT NULL COMMENT '企业类型 (01内资生产企业、02外商投资企业、03外贸企业、04个体工商户)',
  `operator` VARCHAR(100) NOT NULL COMMENT '经办人员-姓名',
  `operator_id` VARCHAR(20) NOT NULL COMMENT '经办人员-身份证号',
  `operator_phone` VARCHAR(30) NOT NULL COMMENT '经办人员-电话',
  `declare_type` CHAR(2) NOT NULL COMMENT '免税申报方式(01代理申报、 02自行申报)',
  `finance_chief` VARCHAR(100) NOT NULL COMMENT '财务负责人',
  `legal_person` VARCHAR(100) NOT NULL COMMENT '法定代表人',
  `agent_credit_code` VARCHAR(20) COMMENT '代理企业统一社会信用代码(申报方式为代理申报必填)',
  `agent_name` VARCHAR(100) COMMENT '代理企业纳税人名称(申报方式为代理申报必填)',
  `agent_customs_code` VARCHAR(20) COMMENT '代理企业海关企业代码(申报方式为代理申报必填)',
  `agent_operator` VARCHAR(100) COMMENT '代理经办人员-姓名(申报方式为代理申报必填)',
  `agent_operator_id` VARCHAR(30) COMMENT '代理经办人员-身份证号(申报方式为代理申报必填)',
  `agent_operator_phone` VARCHAR(30) COMMENT '代理经办人员-电话(申报方式为代理申报必填)',
  `decl_time` DATETIME(6) NOT NULL COMMENT '申报时间',
  `tax_org_code` VARCHAR(20) COMMENT '主管税务机关代码',
  `tax_org_name` VARCHAR(100) COMMENT '主管税务机关名称',
  `tax_org_operator` VARCHAR(100) COMMENT '主管税务机关经办人',
  `approve_state` CHAR(2) NOT NULL COMMENT '审核状态：00:云平台落地、01：审核中（局端落地）02 审核通过 03 审核不通过',
  `approve_message` VARCHAR(400) COMMENT '审批信息(审批不通过必填)',
  `create_time` DATETIME(6) NOT NULL COMMENT '创建时间',
  `update_time` DATETIME(6) COMMENT '修改时间（包含落地时间、审核时间等）',
  `attachment` LONGTEXT COMMENT '附件-税务登记证等(将ZIP流通过Base64编码生成内容)',
  `withdraw_flag` CHAR(1) COMMENT '备案撤回标志, 1:备案撤回 空值:备案',
  UNIQUE KEY `IDX_DECLARE_COMPANYINFO_CODE` (`SOCIAL_CREDIT_CODE`),
  CONSTRAINT `PK_DSF_DECLARE_COMPANYINFO` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DSF_DECLARE_COMPANYINFO_BAK
CREATE TABLE `DSF_DECLARE_COMPANYINFO_BAK` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '序号',
  `social_credit_code` VARCHAR(20) NOT NULL COMMENT '统一社会信用代码',
  `tax_name` VARCHAR(100) NOT NULL COMMENT '纳税人名称',
  `customs_company_code` VARCHAR(20) COMMENT '海关企业代码',
  `agent_code` VARCHAR(30) COMMENT '对外贸易经营者备案登记表编号',
  `company_type` CHAR(2) NOT NULL COMMENT '企业类型 (01内资生产企业、02外商投资企业、03外贸企业、04个体工商户)',
  `operator` VARCHAR(100) NOT NULL COMMENT '经办人员-姓名',
  `operator_id` VARCHAR(20) NOT NULL COMMENT '经办人员-身份证号',
  `operator_phone` VARCHAR(30) NOT NULL COMMENT '经办人员-电话',
  `declare_type` CHAR(2) NOT NULL COMMENT '免税申报方式(01代理申报、 02自行申报)',
  `finance_chief` VARCHAR(100) NOT NULL COMMENT '财务负责人',
  `legal_person` VARCHAR(100) NOT NULL COMMENT '法定代表人',
  `agent_credit_code` VARCHAR(20) COMMENT '代理企业统一社会信用代码(申报方式为代理申报必填)',
  `agent_name` VARCHAR(100) COMMENT '代理企业纳税人名称(申报方式为代理申报必填)',
  `agent_customs_code` VARCHAR(20) COMMENT '代理企业海关企业代码(申报方式为代理申报必填)',
  `agent_operator` VARCHAR(100) COMMENT '代理经办人员-姓名(申报方式为代理申报必填)',
  `agent_operator_id` VARCHAR(30) COMMENT '代理经办人员-身份证号(申报方式为代理申报必填)',
  `agent_operator_phone` VARCHAR(30) COMMENT '代理经办人员-电话(申报方式为代理申报必填)',
  `decl_time` DATETIME(6) NOT NULL COMMENT '申报时间',
  `tax_org_code` VARCHAR(20) COMMENT '主管税务机关代码',
  `tax_org_name` VARCHAR(100) COMMENT '主管税务机关名称',
  `tax_org_operator` VARCHAR(100) COMMENT '主管税务机关经办人',
  `approve_state` CHAR(2) NOT NULL COMMENT '审核状态：00:云平台落地、01：审核中（局端落地）02 审核通过 03 审核不通过',
  `approve_message` VARCHAR(400) COMMENT '审批信息(审批不通过必填)',
  `create_time` DATETIME(6) NOT NULL COMMENT '创建时间',
  `update_time` DATETIME(6) COMMENT '修改时间（包含落地时间、审核时间等）',
  `attachment` LONGTEXT COMMENT '附件-税务登记证等(将ZIP流通过Base64编码生成内容)',
  `withdraw_flag` CHAR(1) COMMENT '备案撤回标志, 1:备案撤回 空值:备案'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DZBA_SB_DB_TSSB
CREATE TABLE `DZBA_SB_DB_TSSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `wtdbtsscqynsrsbh` VARCHAR(20) COMMENT '委托代办退税生产企业纳税人识别号',
  `wtdbtsscqyshxydm` VARCHAR(20) COMMENT '委托代办退税生产企业社会信用代码',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `hgspmc` VARCHAR(500) COMMENT '海关商品名称',
  `hgjldwmc` VARCHAR(75) COMMENT '海关计量单位名称',
  `sbsp_dm` VARCHAR(20) COMMENT '申报商品代码',
  `sbspmc` VARCHAR(500) COMMENT '申报商品名称',
  `cksl` DECIMAL(16,4) COMMENT '出口数量',
  `mylaj` DECIMAL(18,2) COMMENT '美元离岸价',
  `dbtswspzhm` VARCHAR(40) COMMENT '代办退税完税凭证号码',
  `dbtsfpzs` DECIMAL(10,0) COMMENT '代办退税发票（张数）',
  `kprq` DATETIME COMMENT '开票日期',
  `jsje` DECIMAL(18,2) COMMENT '计税金额',
  `zssl` DECIMAL(16,6) COMMENT '征税税率',
  `tsl` DECIMAL(16,6) COMMENT '退税率',
  `tse` DECIMAL(18,6) COMMENT '退税额',
  `cktmsywlxdmjh` VARCHAR(30) COMMENT '出口退（免）税业务类型代码集合',
  `cktmsywlxmcjh` VARCHAR(75) COMMENT '出口退（免）税业务类型名称集合',
  `dbtsywlx_dm` VARCHAR(20) COMMENT '代办退税业务类型代码',
  `dbtsywlxmc` VARCHAR(75) COMMENT '代办退税业务类型名称',
  `bz` VARCHAR(3000) COMMENT '备注',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `dlsbjbr` VARCHAR(150) COMMENT '代理申报经办人',
  `sqrmc` VARCHAR(300) COMMENT '授权人名称',
  `sqrq_1` DATETIME COMMENT '授权日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgrq` DATETIME COMMENT '修改日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `jbrxm` VARCHAR(75) COMMENT '经办人姓名',
  `fpdm` VARCHAR(12) COMMENT '增值税发票代码（信息比对的时候通过DBTSWSPZHM分解）',
  `fphm` VARCHAR(8) COMMENT '增值税发票号码（信息比对的时候通过DBTSWSPZHM分解）',
  KEY `IDX_DZBA_SB_DB_TSSB_1` (`SBID`),
  KEY `IDX_DZBA_SB_DB_TSSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='外贸综合服务代办退税申报临时表';

-- Creating table DZBA_SB_MDT_TSSB
CREATE TABLE `DZBA_SB_MDT_TSSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75),
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `ckfph` VARCHAR(30) COMMENT '出口发票号',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `dlckhwzmhm` VARCHAR(20) COMMENT '代理出口货物证明号码',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `hgjldwmc` VARCHAR(75) COMMENT '海关计量单位名称',
  `cksl` DECIMAL(16,4) COMMENT '出口数量',
  `mylaj` DECIMAL(18,2) COMMENT '美元离岸价',
  `rmblaj` DECIMAL(18,2) COMMENT '人民币离岸价',
  `zssl` DECIMAL(16,6) COMMENT '征税税率',
  `tsl` DECIMAL(16,6) COMMENT '退税率',
  `tzhjhfpl` DECIMAL(10,6) COMMENT '调整后计划分配率',
  `jljgbsjkljzcjsjg` DECIMAL(18,2) COMMENT '进料加工保税进口料件组成计税价格',
  `gngjmsycljg` DECIMAL(18,2) COMMENT '国内购进免税原材料价格',
  `mdtsbdmzhdkse` DECIMAL(18,6) COMMENT '免抵退税不得免征和抵扣税额',
  `mdtse` DECIMAL(18,6) COMMENT '免抵退税额',
  `jljgszch` VARCHAR(20) COMMENT '进料加工手（账）册号',
  `cktmsywlxdmjh` VARCHAR(30) COMMENT '出口退（免）税业务类型代码集合',
  `cktmsywlxmcjh` VARCHAR(75) COMMENT '出口退（免）税业务类型名称集合',
  `ckhth` VARCHAR(60) COMMENT '出口合同号',
  `bz` VARCHAR(3000) COMMENT '备注',
  `cjhbzm_dm` CHAR(3) COMMENT '成交货币字母代码',
  `cjzj` DECIMAL(18,2) COMMENT '成交总价||成交总价',
  `cjhbhl` DECIMAL(16,6) COMMENT '成交货币汇率',
  `myhl` DECIMAL(16,6) COMMENT '美元汇率',
  `mdtsny` CHAR(6) COMMENT '免抵退税年月',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `sbhgspmc` VARCHAR(500) COMMENT '申报海关商品名称||申报海关商品名称',
  `zbblny` VARCHAR(6) COMMENT '暂不办理年月',
  `sbsp_dm` VARCHAR(20) COMMENT '申报商品代码',
  `sbspmc` VARCHAR(500) COMMENT '申报商品名称',
  KEY `IDX_DZBA_SB_MDT_TSSB_1` (`SBID`),
  KEY `IDX_DZBA_SB_MDT_TSSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='生产企业出口货物免抵退税申报明细(临时表)';

-- Creating table DZBA_SB_MTS_TSJH
CREATE TABLE `DZBA_SB_MTS_TSJH` (
  `sbid` DECIMAL(18,0),
  `qyhgdm` VARCHAR(20),
  `djxh` DECIMAL(20,0),
  `sbpc` VARCHAR(75),
  `sbxh` VARCHAR(50),
  `glh` VARCHAR(30),
  `sz` CHAR(1),
  `jhpzh` VARCHAR(75),
  `zysph` VARCHAR(30),
  `kprq` DATETIME,
  `cksp_dm` VARCHAR(20),
  `sbhgspmc` VARCHAR(500),
  `hgjldwmc` VARCHAR(75),
  `sl` DECIMAL(16,4),
  `jsje` DECIMAL(18,2),
  `zssl` DECIMAL(16,6),
  `zsse` DECIMAL(18,6),
  `tsl` DECIMAL(16,6),
  `tse` DECIMAL(18,6),
  `cktmsywlxdmjh` VARCHAR(30),
  `cktmsywlxmcjh` VARCHAR(75),
  `bz` VARCHAR(3000),
  `tbrq_1` DATETIME,
  `tsswjg_dm_1` CHAR(11),
  `lrr_dm` CHAR(11),
  `lrrq` DATETIME,
  `xgrq` DATETIME,
  `xgr_dm` CHAR(11),
  `sjgsdq` CHAR(11),
  `sjtb_sj` DATETIME(6),
  `ssq` VARCHAR(60),
  `ghfnsrsbh_1` VARCHAR(20),
  `cktmspzlx_dm` CHAR(2),
  `fpdm` VARCHAR(12),
  `fphm` VARCHAR(8),
  `ckrq_1` DATETIME,
  KEY `IDX_DZBA_SB_MTS_MTS_TSJH_1` (`SBID`),
  KEY `IDX_DZBA_SB_MTS_MTS_TSJH_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DZBA_SB_MTS_TSSB
CREATE TABLE `DZBA_SB_MTS_TSSB` (
  `sbid` DECIMAL(18,0) COMMENT 'sbid||sbid',
  `qyhgdm` VARCHAR(20) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `glh` VARCHAR(30) COMMENT '关联号',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `dlzmh` VARCHAR(30) COMMENT '代理证明号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `ckshhxdh` VARCHAR(30) COMMENT '出口收汇核销单号',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `sbhgspmc` VARCHAR(500) COMMENT '申报海关商品名称||申报海关商品名称',
  `hgjldwmc` VARCHAR(75) COMMENT '海关计量单位名称',
  `cksl` DECIMAL(16,4) COMMENT '出口数量',
  `mylaj` DECIMAL(18,2) COMMENT '美元离岸价',
  `ckjhje` DECIMAL(18,2) COMMENT '出口进货金额',
  `sbsp_dm` VARCHAR(20) COMMENT '申报商品代码',
  `sbspmc` VARCHAR(500) COMMENT '申报商品名称',
  `tsl` DECIMAL(16,6) COMMENT '退税率',
  `zzstse` DECIMAL(18,6) COMMENT '增值税退税额',
  `xfstse` DECIMAL(18,6) COMMENT '消费税退税额',
  `dzbqbz` CHAR(1) COMMENT '单证不齐标志',
  `cktmsywlxdmjh` VARCHAR(30) COMMENT '出口退（免）税业务类型代码集合',
  `cktmsywlxmcjh` VARCHAR(75) COMMENT '出口退（免）税业务类型名称集合',
  `bz` VARCHAR(3000) COMMENT '备注',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `stssl` DECIMAL(16,4) COMMENT '实退税数量',
  `pjdj` DECIMAL(18,2) COMMENT '平均单价',
  `rmblaj` DECIMAL(18,2) COMMENT '人民币离岸价',
  `mygdqsz_dm` CHAR(3) COMMENT '贸易国（地区）数字代码',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgrq` DATETIME COMMENT '修改日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `jjhwbaqdh` VARCHAR(30) COMMENT '进境货物备案清单号',
  `ckfph` VARCHAR(30) COMMENT '出口发票号',
  KEY `IDX_DZBA_SB_MTS_TSSB_1` (`SBID`),
  KEY `IDX_DZBA_SB_MTS_TSSB_2` (`QYHGDM`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='外贸企业出口退税出口明细申报临时表';

-- Creating table ETL_LOG_JOB
CREATE TABLE `ETL_LOG_JOB` (
  `id_job` DECIMAL(38,0),
  `channel_id` VARCHAR(255),
  `jobname` VARCHAR(255),
  `status` VARCHAR(15),
  `lines_read` DECIMAL(38,0),
  `lines_written` DECIMAL(38,0),
  `lines_updated` DECIMAL(38,0),
  `lines_input` DECIMAL(38,0),
  `lines_output` DECIMAL(38,0),
  `lines_rejected` DECIMAL(38,0),
  `errors` DECIMAL(38,0),
  `startdate` DATETIME,
  `enddate` DATETIME,
  `logdate` DATETIME,
  `depdate` DATETIME,
  `replaydate` DATETIME,
  `log_field` LONGTEXT,
  KEY `IDX_ETL_LOG_JOB_1` (`ID_JOB`),
  KEY `IDX_ETL_LOG_JOB_2` (`ERRORS`, `STATUS`, `JOBNAME`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table ETL_LOG_RUN
CREATE TABLE `ETL_LOG_RUN` (
  `id_batch` DECIMAL(38,0),
  `seq_nr` DECIMAL(38,0),
  `logdate` DATETIME,
  `transname` VARCHAR(255),
  `stepname` VARCHAR(255),
  `step_copy` DECIMAL(38,0),
  `lines_read` DECIMAL(38,0),
  `lines_written` DECIMAL(38,0),
  `lines_updated` DECIMAL(38,0),
  `lines_input` DECIMAL(38,0),
  `lines_output` DECIMAL(38,0),
  `lines_rejected` DECIMAL(38,0),
  `errors` DECIMAL(38,0),
  `input_buffer_rows` DECIMAL(38,0),
  `output_buffer_rows` DECIMAL(38,0)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table ETL_LOG_STEP
CREATE TABLE `ETL_LOG_STEP` (
  `id_batch` DECIMAL(38,0),
  `channel_id` VARCHAR(255),
  `transname` VARCHAR(255),
  `stepname` VARCHAR(255),
  `step_copy` DECIMAL(38,0),
  `lines_read` DECIMAL(38,0),
  `lines_written` DECIMAL(38,0),
  `lines_updated` DECIMAL(38,0),
  `lines_input` DECIMAL(38,0),
  `lines_output` DECIMAL(38,0),
  `lines_rejected` DECIMAL(38,0),
  `errors` DECIMAL(38,0),
  `log_date_ktl` DATETIME,
  `log_date` DATETIME
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table ETL_LOG_TRANS
CREATE TABLE `ETL_LOG_TRANS` (
  `id_batch` DECIMAL(38,0),
  `channel_id` VARCHAR(255),
  `transname` VARCHAR(255),
  `status` VARCHAR(15),
  `lines_read` DECIMAL(38,0),
  `lines_written` DECIMAL(38,0),
  `lines_updated` DECIMAL(38,0),
  `lines_input` DECIMAL(38,0),
  `lines_output` DECIMAL(38,0),
  `lines_rejected` DECIMAL(38,0),
  `errors` DECIMAL(38,0),
  `log_field` LONGTEXT,
  `startdate_ktl` DATETIME,
  `enddate_ktl` DATETIME,
  `logdate_ktl` DATETIME,
  `depdate_ktl` DATETIME,
  `replaydate_ktl` DATETIME,
  `startdate` DATETIME,
  `enddate` DATETIME,
  `logdate` DATETIME,
  `depdate` DATETIME,
  `replaydate` DATETIME,
  KEY `IDX_ETL_LOG_TRANS_1` (`ID_BATCH`),
  KEY `IDX_ETL_LOG_TRANS_2` (`ERRORS`, `STATUS`, `TRANSNAME`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table FK_TX_WSBBGD
CREATE TABLE `FK_TX_WSBBGD` (
  `cpcode` VARCHAR(32) NOT NULL DEFAULT ' ',
  `bgd_no` VARCHAR(21) NOT NULL DEFAULT ' ',
  `lj_date` DATETIME DEFAULT '1900-01-01 00:00:00',
  `cmcode` VARCHAR(12) DEFAULT ' ',
  `tdcode` VARCHAR(4) DEFAULT ' ',
  `rmb_amt` DECIMAL(15,2) DEFAULT (0),
  `usd_amt` DECIMAL(15,2) DEFAULT (0),
  `swcode` VARCHAR(11) DEFAULT ' ',
  `qydm` VARCHAR(18) DEFAULT ' ',
  `ba_no` VARCHAR(12) DEFAULT ' ',
  `memo` VARCHAR(100) DEFAULT ' '
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table GS_DJ_CKTMSDAB
-- Original Oracle primary-key constraint: PK_GS_DJ_CKTMSDAB (MySQL index name: PRIMARY).
CREATE TABLE `GS_DJ_CKTMSDAB` (
  `tbpc` DECIMAL(18,0) COMMENT '同步批次',
  `nsrdzdah` DECIMAL(20,0) NOT NULL COMMENT '纳税人电子档案号',
  `nsrmc` VARCHAR(400) COMMENT '纳税人名称',
  `nsrmcyw` VARCHAR(75) COMMENT '纳税人英文名称',
  `qyhgdm` VARCHAR(32) COMMENT '企业海关代码',
  `nsrdh` VARCHAR(60) COMMENT '纳税人电话',
  `nsrcz` VARCHAR(16) COMMENT '纳税人传真',
  `nsryb` VARCHAR(6) COMMENT '纳税人邮编',
  `nsryx` VARCHAR(90) COMMENT '纳税人电子信箱',
  `zcdz` VARCHAR(300) COMMENT '注册地址',
  `scjydz` VARCHAR(300) COMMENT '生产经营地址',
  `nsrsbh` VARCHAR(32) COMMENT '纳税人识别号',
  `nsrlx_dm` CHAR(1) COMMENT '纳税人类型代码',
  `swjg_dm` VARCHAR(11) COMMENT '税务机关代码
',
  `nsrxydj_dm` VARCHAR(20) COMMENT '纳税人信用等级',
  `djzclx_dm` VARCHAR(200) COMMENT '登记注册类型代码',
  `hy_dm` VARCHAR(4) COMMENT '行业代码',
  `lsgx_dm` VARCHAR(2) COMMENT '隶属关系代码',
  `jyzlx_dm` VARCHAR(1) COMMENT '经营者类型代码',
  `badjbbh` VARCHAR(30) COMMENT '外贸 备案登记表编号',
  `sfysfw` VARCHAR(1) COMMENT '是否应税服务
',
  `ysfw` VARCHAR(30) COMMENT '应税服务代码集，用半角逗号隔开
',
  `ysfs` VARCHAR(50) COMMENT '运输方式代码集，用半角逗号隔开
',
  `yfsj` VARCHAR(50) COMMENT '研发设计代码集，用半角逗号隔开
',
  `gsdjzzh` VARCHAR(50) COMMENT '工商登记证号',
  `gskyrq` DATETIME COMMENT '工商开业日期',
  `gsyxqz` DATETIME COMMENT '工商有效期止',
  `gsdjyxq` DECIMAL(2,0) COMMENT '工商登记有效期',
  `gszczb` VARCHAR(20) COMMENT '工商注册资本',
  `fddbrmc` VARCHAR(150) COMMENT '法人代表名称
',
  `frzjhm` VARCHAR(30) COMMENT '法人证件号码',
  `frdhhm` VARCHAR(60) COMMENT '法人电话号码',
  `yhmc` VARCHAR(400) COMMENT '开户银行名称',
  `yhzh` VARCHAR(60) COMMENT '开户银行账号',
  `bsy1_mc` VARCHAR(150) COMMENT '办税员名称
',
  `bsy1_id` VARCHAR(30) COMMENT '办税员身份证',
  `bsy1_dh` VARCHAR(60) COMMENT '办税员电话',
  `bsy2_mc` VARCHAR(150) COMMENT '办税员名称
',
  `bsy2_id` VARCHAR(30) COMMENT '办税员身份证',
  `bsy2_dh` VARCHAR(60) COMMENT '办税员电话',
  `zzsyhzc` VARCHAR(30) COMMENT '增值税优惠政策代码集，用半角逗号隔开
',
  `zgwhj` VARCHAR(30) COMMENT '主管外汇局',
  `fszl` VARCHAR(500) COMMENT '附送资料',
  `tsjsfs_dm` CHAR(1) COMMENT '退税计算方式代码',
  `sbfs_mc_zzbz` VARCHAR(20) COMMENT '纸质凭证申报方式',
  `sbfs_mc_sjdw` VARCHAR(20) COMMENT '纸质凭证电文方式',
  `sffbhs` CHAR(1) COMMENT '是否分部核算
',
  `fbhsdm` VARCHAR(100) COMMENT '分部核算部门代码
',
  `qylx_dm` VARCHAR(10) COMMENT '企业类型代码
',
  `cpcode` VARCHAR(32) COMMENT '核心征管系统TO_CHAR(DJXH)',
  `nsrdjno` VARCHAR(32) COMMENT '纳税人识别号',
  `shxyno` VARCHAR(20) COMMENT '社会信用代码',
  `zs_swjg_dm` VARCHAR(11) COMMENT '征收税务机关-审核助手用',
  `zx_flag` VARCHAR(1) COMMENT '注销标志 R 注销',
  `tsgllx_dm` VARCHAR(200) COMMENT '退税管理类型代码',
  `jdxzmc` VARCHAR(50) COMMENT '乡镇街道名称',
  `tag` VARCHAR(30),
  `tbbz` DECIMAL(8,0) DEFAULT 0 COMMENT '同步标志',
  `zgswskfj_dm` VARCHAR(11) COMMENT '主管税务所（科、分局）代码',
  `jdxz_dm` VARCHAR(9) COMMENT '街道乡镇代码',
  `readin_date` DATETIME,
  `wmzhfwqybz` CHAR(1) COMMENT '外贸综合服务企业标志（35号公告）',
  `scsbrq` DATETIME COMMENT '企业首次申报退（免）税时间（从HX_CKTS.CKTS_TY_SCSBQK同步）',
  `ztxthhbz` CHAR(1) COMMENT '暂停先退后核标志（从HX_CKTS.CKTS_BA_PZXX_JGB同步）',
  `yhzhtgbz` CHAR(1) COMMENT '银行账号托管标志',
  `zsqybbsrbz` CHAR(1) COMMENT '综税区试点一般纳税人标志',
  `cpcodetssh` VARCHAR(32) COMMENT '老审核系统CPCODE',
  `xgrq` DATETIME COMMENT '修改日期NVL(T.XGRQ,T.LRRQ)-增量用',
  `cwfzrxm` VARCHAR(150),
  `cwfzrsfzjhm` VARCHAR(30),
  `cwfzrgddh` VARCHAR(60),
  `cwfzryddh` VARCHAR(60),
  `bsrxm` VARCHAR(150),
  `bsrsfzjhm` VARCHAR(30),
  `bsrgddh` VARCHAR(60),
  `bsryddh` VARCHAR(60),
  `djrq` DATETIME,
  `scckrq` DATETIME COMMENT '首次出口日期',
  `barq` DATETIME COMMENT '备案日期',
  `fddbr_cgbl` DECIMAL(18,6) DEFAULT 0 COMMENT '法定代表人持股比例,%',
  `note` VARCHAR(10) COMMENT '备注',
  `fddbrsfzjlx_dm` CHAR(3) COMMENT '法人证件类型-NEW',
  `ybnsrrdsjq` DATETIME COMMENT '一般纳税人认定日期-NEW',
  `first_sb_ym` VARCHAR(6) COMMENT '首次申报年月-NEW',
  `nsrzt_dm` CHAR(2) COMMENT '纳税人状态-NEW',
  `zx_date` DATETIME COMMENT '备案撤回日期-NEW',
  `zgswj_dm` CHAR(11) COMMENT '征管税务机关代码-NEW',
  KEY `IDX_GS_DJ_CKTMSDAB_CPCODE` (`CPCODE`),
  KEY `IDX_GS_DJ_CKTMSDAB_CPTSSH` (`CPCODETSSH`),
  KEY `IDX_GS_DJ_CKTMSDAB_CZFZR` (`CWFZRSFZJHM`),
  KEY `IDX_GS_DJ_CKTMSDAB_FRZJHM` (`FRZJHM`),
  UNIQUE KEY `IDX_GS_DJ_CKTMSDAB_NSRSBH` (`NSRSBH`),
  KEY `IDX_GS_DJ_CKTMSDAB_QYHGDM` (`QYHGDM`),
  KEY `IDX_GS_DJ_CKTMSDAB_SWJG` (`SWJG_DM`),
  KEY `IDX_GS_DJ_CKTMSDAB_TBPC` (`TBPC`),
  CONSTRAINT `PK_GS_DJ_CKTMSDAB` PRIMARY KEY (`NSRDZDAH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='登记出口退税档案表';

-- Creating table GS_DJ_CKTMSDAB_BAK
CREATE TABLE `GS_DJ_CKTMSDAB_BAK` (
  `tbpc` DECIMAL(18,0) COMMENT '同步批次',
  `nsrdzdah` DECIMAL(20,0) NOT NULL COMMENT '纳税人电子档案号',
  `nsrmc` VARCHAR(400) COMMENT '纳税人名称',
  `nsrmcyw` VARCHAR(75) COMMENT '纳税人英文名称',
  `qyhgdm` VARCHAR(32) COMMENT '企业海关代码',
  `nsrdh` VARCHAR(60) COMMENT '纳税人电话',
  `nsrcz` VARCHAR(16) COMMENT '纳税人传真',
  `nsryb` VARCHAR(6) COMMENT '纳税人邮编',
  `nsryx` VARCHAR(90) COMMENT '纳税人电子信箱',
  `zcdz` VARCHAR(300) COMMENT '注册地址',
  `scjydz` VARCHAR(300) COMMENT '生产经营地址',
  `nsrsbh` VARCHAR(32) COMMENT '纳税人识别号',
  `nsrlx_dm` CHAR(1) COMMENT '纳税人类型代码',
  `swjg_dm` VARCHAR(11) COMMENT '税务机关代码
',
  `nsrxydj_dm` VARCHAR(20) COMMENT '纳税人信用等级',
  `djzclx_dm` VARCHAR(200) COMMENT '登记注册类型代码',
  `hy_dm` VARCHAR(4) COMMENT '行业代码',
  `lsgx_dm` VARCHAR(2) COMMENT '隶属关系代码',
  `jyzlx_dm` VARCHAR(1) COMMENT '经营者类型代码',
  `badjbbh` VARCHAR(30) COMMENT '外贸 备案登记表编号',
  `sfysfw` VARCHAR(1) COMMENT '是否应税服务
',
  `ysfw` VARCHAR(30) COMMENT '应税服务代码集，用半角逗号隔开
',
  `ysfs` VARCHAR(50) COMMENT '运输方式代码集，用半角逗号隔开
',
  `yfsj` VARCHAR(50) COMMENT '研
发设计代码集，用半角逗号隔开
',
  `gsdjzzh` VARCHAR(50) COMMENT '工商登记证号',
  `gskyrq` DATETIME COMMENT '工商开业日期',
  `gsyxqz` DATETIME COMMENT '工商有效期止',
  `gsdjyxq` DECIMAL(2,0) COMMENT '工商登记有效期',
  `gszczb` VARCHAR(20) COMMENT '工商注册资本',
  `fddbrmc` VARCHAR(150) COMMENT '法人代表名称
',
  `frzjhm` VARCHAR(30) COMMENT '法人证件号码',
  `frdhhm` VARCHAR(60) COMMENT '法人电话号码',
  `yhmc` VARCHAR(80) COMMENT '开户银行名称',
  `yhzh` VARCHAR(60) COMMENT '开户银行账号',
  `bsy1_mc` VARCHAR(30) COMMENT '办税员名称
',
  `bsy1_id` VARCHAR(20) COMMENT '办税员身份证',
  `bsy1_dh` VARCHAR(20) COMMENT '办税员电话',
  `bsy2_mc` VARCHAR(30) COMMENT '办税员名称
',
  `bsy2_id` VARCHAR(20) COMMENT '办税员身份证',
  `bsy2_dh` VARCHAR(20) COMMENT '办税员电话',
  `zzsyhzc` VARCHAR(30) COMMENT '增值税优惠政策代码集，用半角逗号隔开
',
  `zgwhj` VARCHAR(30) COMMENT '主管外汇局',
  `fszl` VARCHAR(240) COMMENT '附送资料',
  `tsjsfs_dm` CHAR(1) COMMENT '退税计算方式代码',
  `sbfs_mc_zzbz` VARCHAR(20) COMMENT '纸质凭证申报方式',
  `sbfs_mc_sjdw` VARCHAR(20) COMMENT '纸质凭证电文方式',
  `sffbhs` CHAR(1) COMMENT '是否分部核算
',
  `fbhsdm` VARCHAR(100) COMMENT '分部核算部门代码
',
  `qylx_dm` VARCHAR(10) COMMENT '企业类型代码
',
  `cpcode` VARCHAR(32) COMMENT '核心征管系统TO_CHAR(DJXH)',
  `nsrdjno` VARCHAR(32) COMMENT '纳税人识别号',
  `shxyno` VARCHAR(20) COMMENT '社会信用代码',
  `zs_swjg_dm` VARCHAR(11) COMMENT '征收税务机关-审核助手用',
  `zx_flag` VARCHAR(1) COMMENT '注销标志 R 注销',
  `tsgllx_dm` VARCHAR(200) COMMENT '退税管理类型代码',
  `jdxzmc` VARCHAR(50) COMMENT '乡镇街道名称',
  `tag` VARCHAR(30),
  `tbbz` DECIMAL(8,0) DEFAULT 0 COMMENT '同步标志',
  `zgswskfj_dm` VARCHAR(11) COMMENT '主管税务所（科、分局）代码',
  `jdxz_dm` VARCHAR(9) COMMENT '街道乡镇代码',
  `readin_date` DATETIME,
  `wmzhfwqybz` CHAR(1) COMMENT '外贸综合服务企业标志（35号公告）',
  `scsbrq` DATETIME COMMENT '企业首次申报退（免）税时间（从HX_CKTS.CKTS_TY_SCSBQK同步）',
  `ztxthhbz` CHAR(1) COMMENT '暂停先退后核标志（从HX_CKTS.CKTS_BA_PZXX_JGB同步）',
  `yhzhtgbz` CHAR(1) COMMENT '银行账号托管标志',
  `zsqybbsrbz` CHAR(1) COMMENT '综税区试点一般纳税人标志',
  `cpcodetssh` VARCHAR(32) COMMENT '老审核系统CPCODE'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='登记出口退税档案表';

-- Creating table GS_DJ_CKTMSDAB_KZ
-- Original Oracle primary-key constraint: PK_GS_DJ_CKTMSDAB_KZ (MySQL index name: PRIMARY).
CREATE TABLE `GS_DJ_CKTMSDAB_KZ` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID序号',
  `id` DECIMAL(18,0) COMMENT '序号',
  `nsrdzdah` DECIMAL(20,0) NOT NULL COMMENT '纳税人电子档案号',
  `kzlx` VARCHAR(50) COMMENT '扩展类型',
  `kzxx` VARCHAR(100) COMMENT '扩展信息',
  `st_date` DATETIME COMMENT '开始日期',
  `end_date` DATETIME COMMENT '终止日期',
  `flag` CHAR(1) COMMENT '有效标志',
  `note` VARCHAR(4000) COMMENT '备注',
  `tbpc` DECIMAL(18,0) COMMENT '同步批次',
  `readin_date` DATETIME,
  `cpcode` VARCHAR(32) COMMENT '核心征管系统TO_CHAR(DJXH)',
  KEY `IDX_GS_DJ_CKTMSDAB_KZ_2` (`NSRDZDAH`, `KZLX`, `ST_DATE`),
  KEY `IDX_GS_DJ_CKTMSDAB_KZ_TBPC` (`TBPC`),
  CONSTRAINT `PK_GS_DJ_CKTMSDAB_KZ` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口企业备案信息扩展信息';

-- Creating table GS_DJ_CKTMSDAB_KZ_TB
-- Original Oracle primary-key constraint: PK_GS_DJ_CKTMSDAB_KZ_TB (MySQL index name: PRIMARY).
CREATE TABLE `GS_DJ_CKTMSDAB_KZ_TB` (
  `cpcode` VARCHAR(32),
  `uuid` VARCHAR(32) NOT NULL,
  `kzlx` VARCHAR(50),
  `kzxx` VARCHAR(100),
  `st_date` DATETIME,
  `end_date` DATETIME,
  `flag` CHAR(1),
  CONSTRAINT `PK_GS_DJ_CKTMSDAB_KZ_TB` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口企业备案信息扩展信息,同步';

-- Creating table GS_DJ_CKTMSDAB_TB
-- Original Oracle primary-key constraint: PK_GS_DJ_CKTMSDAB_TB (MySQL index name: PRIMARY).
CREATE TABLE `GS_DJ_CKTMSDAB_TB` (
  `nsrmc` VARCHAR(400) COMMENT '纳税人名称',
  `nsrmcyw` VARCHAR(75) COMMENT '纳税人英文名称',
  `qyhgdm` VARCHAR(32) COMMENT '企业海关代码',
  `nsrdh` VARCHAR(60) COMMENT '纳税人电话',
  `nsrcz` VARCHAR(16) COMMENT '纳税人传真',
  `nsryb` VARCHAR(6) COMMENT '纳税人邮编',
  `nsryx` VARCHAR(90) COMMENT '纳税人电子信箱',
  `zcdz` VARCHAR(300) COMMENT '注册地址',
  `scjydz` VARCHAR(300) COMMENT '生产经营地址',
  `nsrsbh` VARCHAR(32) COMMENT '纳税人识别号',
  `nsrlx_dm` CHAR(1) COMMENT '纳税人类型代码',
  `swjg_dm` VARCHAR(11) COMMENT '税务机关代码
',
  `nsrxydj_dm` VARCHAR(20) COMMENT '纳税人信用等级',
  `djzclx_dm` CHAR(3) COMMENT '登记注册类型-NEW',
  `hy_dm` VARCHAR(4) COMMENT '行业代码',
  `lsgx_dm` VARCHAR(2) COMMENT '隶属关系代码',
  `jyzlx_dm` VARCHAR(1) COMMENT '经营者类型代码',
  `badjbbh` VARCHAR(45) COMMENT '外贸备案登记表编号',
  `sfysfw` VARCHAR(1) COMMENT '是否应税服务
',
  `ysfw` VARCHAR(30) COMMENT '应税服务代码集，用半角逗号隔开
',
  `ysfs` VARCHAR(50) COMMENT '运输方式代码集，用半角逗号隔开
',
  `yfsj` VARCHAR(50) COMMENT '研发设计代码集，用半角逗号隔开
',
  `gsdjzzh` VARCHAR(50) COMMENT '工商登记证号',
  `gskyrq` DATETIME COMMENT '工商开业日期',
  `gsyxqz` DATETIME COMMENT '工商有效期止',
  `gsdjyxq` DECIMAL(2,0) COMMENT '工商登记有效期',
  `gszczb` VARCHAR(20) COMMENT '工商注册资本',
  `fddbrmc` VARCHAR(150) COMMENT '法人代表名称
',
  `frzjhm` VARCHAR(30) COMMENT '法人证件号码',
  `frdhhm` VARCHAR(60) COMMENT '法人电话号码',
  `yhmc` VARCHAR(400) COMMENT '开户银行名称',
  `yhzh` VARCHAR(60) COMMENT '开户银行账号',
  `bsy1_mc` VARCHAR(150) COMMENT '办税员名称
',
  `bsy1_id` VARCHAR(30) COMMENT '办税员身份证',
  `bsy1_dh` VARCHAR(60) COMMENT '办税员电话',
  `bsy2_mc` VARCHAR(150) COMMENT '办税员名称
',
  `bsy2_id` VARCHAR(30) COMMENT '办税员身份证',
  `bsy2_dh` VARCHAR(60) COMMENT '办税员电话',
  `zzsyhzc` VARCHAR(30) COMMENT '增值税优惠政策代码集，用半角逗号隔开
',
  `zgwhj` VARCHAR(30) COMMENT '主管外汇局',
  `fszl` VARCHAR(500) COMMENT '附送资料',
  `tsjsfs_dm` CHAR(1) COMMENT '退税计算方式代码',
  `sbfs_mc_zzbz` VARCHAR(20) COMMENT '纸质凭证申报方式',
  `sbfs_mc_sjdw` VARCHAR(20) COMMENT '纸质凭证电文方式',
  `sffbhs` CHAR(1) COMMENT '是否分部核算
',
  `fbhsdm` VARCHAR(130) COMMENT '分部核算部门代码
',
  `qylx_dm` VARCHAR(10) COMMENT '企业类型代码
',
  `cpcode` VARCHAR(32) NOT NULL COMMENT '核心征管系统TOCHAR(DJXH)',
  `nsrdjno` VARCHAR(32) COMMENT '纳税人识别号',
  `shxyno` VARCHAR(20) COMMENT '社会信用代码',
  `zs_swjg_dm` VARCHAR(11) COMMENT '征收税务机关-审核助手用',
  `zx_flag` VARCHAR(1) COMMENT '注销标志 R 注销',
  `tsgllx_dm` VARCHAR(200) COMMENT '退税管理类型代码',
  `jdxzmc` VARCHAR(50) COMMENT '乡镇街道名称',
  `tag` VARCHAR(30),
  `zgswskfj_dm` VARCHAR(11) COMMENT '主管税务所（科、分局）代码',
  `jdxz_dm` CHAR(9) COMMENT '街道乡镇代码-NEW',
  `zsqybbsrbz` CHAR(1) COMMENT '综税区试点一般纳税人标志',
  `yhzhtgbz` CHAR(1) COMMENT '出口退税账户办理托管贷款业务标志',
  `wmzhfwqybz` CHAR(1) COMMENT '外贸综合服务企业标志',
  `scsbrq` DATETIME COMMENT '首次申报日期',
  `ztxthhbz` CHAR(1) COMMENT '暂停先退后核资格标志',
  `barq` DATETIME COMMENT '备案日期-NEW',
  `zx_date` DATETIME COMMENT '备案撤回日期-NEW',
  `fddbrsfzjlx_dm` CHAR(3) COMMENT '法人证件类型-NEW',
  `nsrzt_dm` CHAR(2) COMMENT '纳税人状态-NEW',
  `zgswj_dm` CHAR(11) COMMENT '征管税务机关代码-NEW',
  `gsdjz_fzrq` DATETIME COMMENT '税务登记日期-NEW',
  `ybnsrrdsjq` DATETIME COMMENT '一般纳税人认定日期-NEW',
  `first_sb_ym` VARCHAR(6) COMMENT '首次申报年月-NEW',
  `xgrq` DATETIME COMMENT '修改日期NVL(T.XGRQ,T.LRRQ)-增量用',
  `cwfzrxm` VARCHAR(150),
  `cwfzrsfzjhm` VARCHAR(30),
  `cwfzrgddh` VARCHAR(60),
  `cwfzryddh` VARCHAR(60),
  `bsrxm` VARCHAR(150),
  `bsrsfzjhm` VARCHAR(30),
  `bsrgddh` VARCHAR(60),
  `bsryddh` VARCHAR(60),
  `djrq` DATETIME,
  `scckrq` DATETIME COMMENT '首次出口日期',
  `fddbr_cgbl` DECIMAL(18,6) DEFAULT 0 COMMENT '法定代表人持股比例',
  KEY `IDX_GS_DJ_CKTMSDAB_TB_CPCODE` (`CPCODE`),
  CONSTRAINT `PK_GS_DJ_CKTMSDAB_TB` PRIMARY KEY (`CPCODE`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='登记出口退税档案表';

-- Creating table GS_DJ_CKTMSDAB_TEST
CREATE TABLE `GS_DJ_CKTMSDAB_TEST` (
  `nsrsbh` VARCHAR(32) COMMENT '纳税人识别号',
  `ysfs` VARCHAR(50) COMMENT '运输方式代码集，用半角逗号隔开
',
  `fszl` VARCHAR(240) COMMENT '附送资料',
  `name` LONGTEXT,
  `eg_name` VARCHAR(50),
  `qydm` VARCHAR(18),
  `tel` VARCHAR(20),
  `fax` VARCHAR(16),
  `postcode` VARCHAR(6),
  `email` VARCHAR(90),
  `address` VARCHAR(300),
  `jy_address` VARCHAR(300),
  `nsrlb` CHAR(1),
  `swcode` VARCHAR(11),
  `nsxydj` VARCHAR(20),
  `zclxcode` VARCHAR(200),
  `hycode` VARCHAR(4),
  `lsgx` VARCHAR(2),
  `jylxcode` CHAR(1),
  `jckq_pwh` VARCHAR(30),
  `ysfwcode` VARCHAR(30),
  `yfsjfw` VARCHAR(50),
  `gsdjz_no` VARCHAR(50),
  `gsdjz_fzrq` DATETIME(6),
  `null` VARCHAR(2000),
  `gsdjz_yxq` DECIMAL(38,0),
  `zczj` VARCHAR(20),
  `qyfr` VARCHAR(2000),
  `qyfr_no` VARCHAR(2000),
  `qyfr_tel` VARCHAR(2000),
  `bkname` VARCHAR(80),
  `acc_no` VARCHAR(60),
  `bsy` VARCHAR(30),
  `bsy_no` VARCHAR(20),
  `bsy_tel` VARCHAR(20),
  `bsy2` VARCHAR(30),
  `bsy2_no` VARCHAR(20),
  `bsy2_tel` VARCHAR(20),
  `yhzc` VARCHAR(30),
  `zgwgj` VARCHAR(30),
  `js_mode` CHAR(1),
  `zzsbfs` VARCHAR(20),
  `sjdwsb` VARCHAR(20),
  `fbhs` CHAR(1),
  `fbhscode` VARCHAR(100),
  `qylx` VARCHAR(10),
  `code` VARCHAR(32),
  `nsrdj_no` VARCHAR(32),
  `shxy_no` VARCHAR(20),
  `zxflag` CHAR(1),
  `kzlx` VARCHAR(200),
  `ysfw` CHAR(1),
  UNIQUE KEY `IDX_GS_DJ_CKTMSDAB_TEST_NSRSBH` (`NSRSBH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='登记出口退税档案表';

-- Creating table GS_DJ_CKTMSDAB_WZF_TB
-- Original Oracle primary-key constraint: PK_GS_DJ_CKTMSDAB_WZF (MySQL index name: PRIMARY).
CREATE TABLE `GS_DJ_CKTMSDAB_WZF_TB` (
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `lcslid` CHAR(32) COMMENT '流程实例ID',
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID||uuid',
  `nsrmc` VARCHAR(300) COMMENT '纳税人名称',
  `hgqy_dm` VARCHAR(50) COMMENT '海关企业代码',
  `nsrsbh` VARCHAR(20) COMMENT '纳税人识别号',
  `shxydm` VARCHAR(20) COMMENT '社会信用代码',
  `wmzhfwqynsrmc` VARCHAR(300) COMMENT '外贸综合服务企业纳税人名称',
  `wmzhfwqyhgqydm` VARCHAR(50) COMMENT '外贸综合服务企业海关企业代码',
  `wmzhfwqynsrsbh` VARCHAR(20) COMMENT '外贸综合服务企业纳税人识别号',
  `wmzhfwqyshxydm` VARCHAR(20) COMMENT '外贸综合服务企业社会信用代码',
  `wmzhfwhtxyhm` VARCHAR(60) COMMENT '外贸综合服务合同（协议）号码',
  `tskhyhmc` VARCHAR(120) COMMENT '退税开户银行名称',
  `tskhyhzh` VARCHAR(50) COMMENT '退税开户银行账号',
  `fddbrxm` VARCHAR(150) COMMENT '法定代表人姓名',
  `dbtsbalczt_dm` CHAR(1) COMMENT '代办退税备案流程状态代码',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `sjgsdq` CHAR(11) COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `bachbz` CHAR(1) COMMENT '备案撤回标志||备案撤回标志',
  `bachrq` DATETIME COMMENT '备案撤回日期',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  KEY `IDX_GS_DJ_CKTMSDAB_WZF_DJXH` (`DJXH`),
  CONSTRAINT `PK_GS_DJ_CKTMSDAB_WZF` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table GS_DJ_NSRFJXX
CREATE TABLE `GS_DJ_NSRFJXX` (
  `nsrdzdah` DECIMAL(20,0) NOT NULL,
  `tjnd` CHAR(4) NOT NULL COMMENT '统计年度',
  `ckxse` DECIMAL(16,2) COMMENT '年申报出口销售额',
  `zymyg` VARCHAR(500) COMMENT '主要贸易国',
  `zyspmc` VARCHAR(500) COMMENT '主要商品名称',
  `frtime` DATETIME(6) COMMENT '刷新时间',
  `ckgm` DECIMAL(16,2) COMMENT '年度出口规模（按出口日期)申报口径',
  `ckgm_hg` DECIMAL(16,2) COMMENT '年度出口规模（按出口日期)海关口径',
  `tse` DECIMAL(16,2) COMMENT '退税额',
  `mde` DECIMAL(16,2) COMMENT '免抵额',
  `zdbz` CHAR(1) COMMENT '重点企业标志(1重点 0普通)',
  PRIMARY KEY (`NSRDZDAH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口企业附加信息表';

-- Creating table GS_DJ_TEST_NSR
CREATE TABLE `GS_DJ_TEST_NSR` (
  `nsrdzdah` DECIMAL(20,0) NOT NULL,
  `nsrmc` VARCHAR(80),
  `yxbz` CHAR(1) NOT NULL,
  PRIMARY KEY (`NSRDZDAH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table GS_DJ_TXFWSQXX
-- Original Oracle primary-key constraint: PK_GS_DJ_TXFWSQXX (MySQL index name: PRIMARY).
CREATE TABLE `GS_DJ_TXFWSQXX` (
  `tbpc` DECIMAL(18,0) COMMENT '同步批次
',
  `uuid` VARCHAR(32) NOT NULL COMMENT '唯一主键标志',
  `cpcode` VARCHAR(32) COMMENT 'DJXH',
  `nsrdzdah` DECIMAL(20,0) COMMENT '纳税人电子档案号，征管系统中区分纳税人',
  `sfjsdxfw` VARCHAR(1) COMMENT '是否接收短信提醒服务
',
  `djr1mc` VARCHAR(30) COMMENT '登记人员1姓名
',
  `djr1zw` VARCHAR(20) COMMENT '登记人员1职务
',
  `djr1dh` VARCHAR(20) COMMENT '登记人员1手机号码
',
  `djr1yx` VARCHAR(50) COMMENT '登记人员1电子邮件
',
  `djr2mc` VARCHAR(30) COMMENT '登记人员2姓名
',
  `djr2zw` VARCHAR(20) COMMENT '登记人员2职务
',
  `djr2dh` VARCHAR(20) COMMENT '登记人员2手机号码
',
  `djr2yx` VARCHAR(50) COMMENT '登记人员2电子邮件
',
  `readin_date` DATETIME,
  KEY `IDX_GS_DJ_TXFWSQXX_NSRDZDAH` (`NSRDZDAH`),
  CONSTRAINT `PK_GS_DJ_TXFWSQXX` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='申请提醒服务表';

-- Creating table GS_DLCKHWZM
-- Original Oracle primary-key constraint: PK_DLCKHWZM (MySQL index name: PRIMARY).
CREATE TABLE `GS_DLCKHWZM` (
  `tbpc` DECIMAL(18,0) NOT NULL COMMENT '同步批次
',
  `nsrdzdah` DECIMAL(20,0) NOT NULL COMMENT '纳税人电子档案号，征管系统中区分纳税人唯一主键标志
',
  `dlckhwzm` VARCHAR(20) NOT NULL COMMENT '代理出口货物证明号
',
  `hgbgdh` VARCHAR(21) COMMENT '海关报关单号
',
  `ckrq` DATETIME COMMENT '出口日期
',
  `hgmyxz_dm` VARCHAR(4) COMMENT '海关贸易方式代码
',
  `spdm` VARCHAR(40) COMMENT '商品代码（报关）
',
  `spmc` VARCHAR(254) COMMENT '商品名称（报关）
',
  `jldw` VARCHAR(8) COMMENT '计量单位名称
',
  `sl` DECIMAL(15,4) COMMENT '数量
',
  `hbzl_dm` VARCHAR(3) COMMENT '货币种类代码
',
  `je_laj_usd` DECIMAL(15,2) COMMENT '美元离岸价
',
  `hlv_usd` DECIMAL(10,5) COMMENT '美元汇率
',
  `je_laj_rmb` DECIMAL(15,2) COMMENT '人民币离岸价
',
  `flag_pp` VARCHAR(1) COMMENT '与出口报关单（进项发票）匹配标志
',
  CONSTRAINT `PK_DLCKHWZM` PRIMARY KEY (`TBPC`, `NSRDZDAH`, `DLCKHWZM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='代理出口货物证明表';

-- Creating table GS_DM_HGSP_LMYCL
-- Original Oracle primary-key constraint: PK_DM_HGSP_LMYCL (MySQL index name: PRIMARY).
CREATE TABLE `GS_DM_HGSP_LMYCL` (
  `spdm` VARCHAR(40) NOT NULL COMMENT '商品代码',
  `spmc` VARCHAR(254) NOT NULL COMMENT '商品名称',
  `bz` VARCHAR(200) COMMENT '备注',
  `qybj` CHAR(1) COMMENT '启用标记',
  `tbpc` DECIMAL(18,0) NOT NULL COMMENT '同步批次',
  CONSTRAINT `PK_DM_HGSP_LMYCL` PRIMARY KEY (`TBPC`, `SPDM`, `SPMC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='列名原材料代码表';

-- Creating table GS_DM_NSRXYDJ
-- Original Oracle primary-key constraint: PK_DM_NSRXYDJ (MySQL index name: PRIMARY).
CREATE TABLE `GS_DM_NSRXYDJ` (
  `nsrxydj_dm` VARCHAR(2) NOT NULL COMMENT '纳税人信誉等级代码',
  `nsrxydj_mc` VARCHAR(20) COMMENT '纳税人信誉等级名称',
  `xybz` CHAR(1) COMMENT '选用标志',
  `yxbz` CHAR(1) COMMENT '有效标志',
  `tbpc` DECIMAL(18,0) COMMENT '同步批次',
  CONSTRAINT `PK_DM_NSRXYDJ` PRIMARY KEY (`NSRXYDJ_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='纳税人信誉等级代码（CTAIS）';

-- Creating table GS_DM_SWJG
-- Original Oracle primary-key constraint: GS_DM_SWJG (MySQL index name: PRIMARY).
CREATE TABLE `GS_DM_SWJG` (
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机构代码',
  `swjg_mc` VARCHAR(60) COMMENT '税务机构名称',
  `xybz` CHAR(1) COMMENT '选用标志',
  `yxbz` CHAR(1) COMMENT '有效标志',
  `tbpc` VARCHAR(18) COMMENT '同步批次',
  CONSTRAINT `GS_DM_SWJG` PRIMARY KEY (`SWJG_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='税务机关代码表（CTAIS）';

-- Creating table GS_FKSJ
CREATE TABLE `GS_FKSJ` (
  `id` DECIMAL(18,0) NOT NULL,
  `fkbw` LONGBLOB COMMENT '反馈报文',
  `bwgs` VARCHAR(10) COMMENT '报文格式',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='审批结束后反馈部分数据（比如不予退税、暂缓退税、国税证明编号）';

-- Creating table GS_HBZL_HLV
-- Original Oracle primary-key constraint: PK_GS_HBZL_HLV (MySQL index name: PRIMARY).
CREATE TABLE `GS_HBZL_HLV` (
  `tbpc` DECIMAL(18,0) NOT NULL COMMENT '同步批次',
  `hl_ym` VARCHAR(6) NOT NULL COMMENT '汇率年月',
  `code` VARCHAR(3) NOT NULL COMMENT '币种',
  `hl_rmb` DECIMAL(10,5) COMMENT '对人民币汇率',
  `hl_usd` DECIMAL(10,5) COMMENT '对美元汇率',
  `hl_range` DECIMAL(5,2) COMMENT '上下浮动范围',
  CONSTRAINT `PK_GS_HBZL_HLV` PRIMARY KEY (`HL_YM`, `CODE`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='各月份币制汇率表';

-- Creating table GS_JLJG_HXJG
-- Original Oracle primary-key constraint: PK_GS_JLJG_HXJG (MySQL index name: PRIMARY).
CREATE TABLE `GS_JLJG_HXJG` (
  `tbpc` DECIMAL(18,0) NOT NULL COMMENT '同步批次',
  `nsrdzdah` DECIMAL(20,0) NOT NULL COMMENT '纳税人电子档案号',
  `sssq` VARCHAR(6) NOT NULL COMMENT '所属时期',
  `sbno` VARCHAR(10) NOT NULL COMMENT '申报号',
  `jgmysch` VARCHAR(20) COMMENT '加工贸易手册号',
  `fplyear` VARCHAR(6) COMMENT '分配率使用年度（这个字段已经没有用处，可以取消，企业端不需要显示）',
  `fplv_jh` DECIMAL(10,6) COMMENT '计划分配率（这个字段已经没有用处，可以取消，企业端不需要显示，手册因为跨年度，每年的计划分配率不同，在一条记录下无法保存）',
  `lj_rmb` DECIMAL(15,2) COMMENT '全部销售额',
  `dzsqamt` DECIMAL(15,2) COMMENT '单证收讫销售额（这个字段已经没有用处，可以取消，企业端不需要显示）',
  `sjfpl` DECIMAL(10,6) COMMENT '实际分配率',
  `tzmdtdje` DECIMAL(15,2) COMMENT '应调整免抵退税额',
  `tzbmzdkdje` DECIMAL(15,2) COMMENT '应调整不得免征和抵扣税额',
  `syfalg` VARCHAR(1) COMMENT '使用标志',
  `syym` VARCHAR(6) COMMENT '使用年月',
  `bz` VARCHAR(200) COMMENT '备注',
  `hxqsrq` DATETIME COMMENT '核销起始日期',
  `hxjzrq` DATETIME COMMENT '核销截止日期',
  `nd` VARCHAR(10) COMMENT '年度',
  `lrrq` DATETIME COMMENT '录入日期',
  `uuid` VARCHAR(32) NOT NULL,
  KEY `IDX_GS_JLJG_HXJG_SSSQ` (`NSRDZDAH`, `SSSQ`),
  CONSTRAINT `PK_GS_JLJG_HXJG` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='核销结果表';

-- Creating table GS_JLJG_JHFPL
-- Original Oracle primary-key constraint: PK_GS_JLJG_JHFPL (MySQL index name: PRIMARY).
CREATE TABLE `GS_JLJG_JHFPL` (
  `tbpc` DECIMAL(18,0) NOT NULL COMMENT '同步批次',
  `nsrdzdah` DECIMAL(20,0) NOT NULL COMMENT '纳税人电子档案号',
  `sssq` VARCHAR(6) NOT NULL COMMENT '所属时期',
  `jhfplv` DECIMAL(9,5) COMMENT '计划分配率',
  `jhfplv_new` DECIMAL(9,5) COMMENT '新计划分配率',
  `uptime` DATETIME COMMENT '更新时间',
  CONSTRAINT `PK_GS_JLJG_JHFPL` PRIMARY KEY (`TBPC`, `NSRDZDAH`, `SSSQ`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='进料加工计划分配率';

-- Creating table GS_SH_PARAM
CREATE TABLE `GS_SH_PARAM` (
  `tsl_low` DECIMAL(5,2) NOT NULL DEFAULT 4.8 COMMENT '最低退税率',
  `tsl_high` DECIMAL(5,2) NOT NULL DEFAULT 17.2 COMMENT '退税率上限',
  `hhcb_low` DECIMAL(5,2) NOT NULL DEFAULT 5 COMMENT '换汇成本下限',
  `hhcb_high` DECIMAL(5,2) NOT NULL DEFAULT 8.2 COMMENT '换汇成本上限',
  `pri_low` DECIMAL(5,2) NOT NULL DEFAULT 0.5 COMMENT '单价下限',
  `pri_high` DECIMAL(5,2) NOT NULL DEFAULT 1.5 COMMENT '单价上限',
  `usd_wcbl` DECIMAL(5,2) NOT NULL DEFAULT 5 COMMENT '美元误差比例',
  `wcbl` DECIMAL(5,2) NOT NULL DEFAULT 0.2 COMMENT '误差比例',
  `cpcd_len` DECIMAL(2,0) NOT NULL DEFAULT 10 COMMENT '海关代码长度',
  `cmcd_len` DECIMAL(2,0) NOT NULL DEFAULT 8 COMMENT '商品代码长度',
  `zysp_len` DECIMAL(2,0) NOT NULL DEFAULT 11 COMMENT '专用税票长度',
  `ldlp_hhcb_low` DECIMAL(5,2) NOT NULL DEFAULT 5 COMMENT '关联号换汇成本下限',
  `ldlp_hhcb_high` DECIMAL(5,2) NOT NULL DEFAULT 8 COMMENT '关联号换汇成本上限',
  `htba_sl_fdbl` DECIMAL(5,2) NOT NULL DEFAULT 0 COMMENT '合同备案数量',
  `htba_je_fdbl` DECIMAL(5,2) NOT NULL DEFAULT 0 COMMENT '合同备案金额',
  `htba_mode` DECIMAL(1,0) NOT NULL DEFAULT 1 COMMENT '合同备案模式',
  `tbpc` DECIMAL(18,0) COMMENT '同步批次'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='国税疑点审核参数表';

-- Creating table GS_TRAINING_SYNC
-- GS_TRAINING_SYNC.id: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- Original Oracle primary-key constraint: PK_GS_TRAINING_SYNC (MySQL index name: PRIMARY).
CREATE TABLE `GS_TRAINING_SYNC` (
  `id` DECIMAL(65,27) NOT NULL COMMENT '主键，保持与gs_training一致',
  `tbbw` LONGTEXT COMMENT '同步报文',
  `tblx` CHAR(1) COMMENT '同步类型 1:新增/编辑   2:删除',
  `tbbz` CHAR(1) COMMENT '同步标志  Y:已同步  N:未同步',
  `tbsj` DATETIME(6) COMMENT '同步时间',
  `cjsj` DATETIME(6) COMMENT '创建时间',
  CONSTRAINT `PK_GS_TRAINING_SYNC` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='同步培训到易税云的表';

-- Creating table JXKH_TJBB
-- Original Oracle primary-key constraint: PK_JXKH_TJBB_TSF (MySQL index name: PRIMARY).
CREATE TABLE `JXKH_TJBB` (
  `tjmonth` VARCHAR(6) NOT NULL COMMENT '统计月份',
  `swcode` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `flglcd` VARCHAR(4) NOT NULL COMMENT '分类管理等级',
  `bahs` DECIMAL(10,0) COMMENT '备案户数',
  `sbhs` DECIMAL(10,0) COMMENT '申报户数',
  `sbpcs` DECIMAL(10,0) COMMENT '申报批次数',
  `sl_day` DECIMAL(10,4) DEFAULT 0 COMMENT '平均受理周期',
  `sh_day` DECIMAL(10,4) DEFAULT 0 COMMENT '平均审核周期',
  `hz_day` DECIMAL(10,4) DEFAULT 0 COMMENT '平均核准周期',
  `kp_day` DECIMAL(10,4) DEFAULT 0 COMMENT '平均征管开票周期',
  `hj_day` DECIMAL(10,4) DEFAULT 0 COMMENT '合计时间周期',
  `note` VARCHAR(255) DEFAULT ' ' COMMENT '备注',
  CONSTRAINT `PK_JXKH_TJBB_TSF` PRIMARY KEY (`TJMONTH`, `SWCODE`, `FLGLCD`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='绩效考核_统计报表';

-- Creating table PUB_JJR
-- Original Oracle primary-key constraint: PK_PUB_JJR (MySQL index name: PRIMARY).
CREATE TABLE `PUB_JJR` (
  `jjr_ssnd` VARCHAR(8) NOT NULL COMMENT '所属年度',
  `jjr_date` DATETIME NOT NULL COMMENT '节假日日期',
  `memo` VARCHAR(100) COMMENT '备注',
  CONSTRAINT `PK_PUB_JJR` PRIMARY KEY (`JJR_SSND`, `JJR_DATE`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='节假日';

-- Creating table RW_RWTXB
-- Original Oracle primary-key constraint: PK_RW_RWTXB (MySQL index name: PRIMARY).
CREATE TABLE `RW_RWTXB` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '主键id',
  `nsrdzdah` DECIMAL(20,0) COMMENT '纳税人电子档案号',
  `rwlx_dm` CHAR(1) COMMENT '任务类型代码，参见sys_dict表rwlx_dm',
  `rwbt` VARCHAR(100) COMMENT '任务标题',
  `rwnr` VARCHAR(1000) COMMENT '任务内容',
  `rwly` VARCHAR(30) COMMENT '任务来源，参见sys_dict表',
  `rwzt_dm` CHAR(1) COMMENT '任务状态代码，参见sys_dict表 rwzt_dm',
  `ywlx_dm` VARCHAR(10) COMMENT '业务类型代码，参见sys_dict表 ywlx_dm',
  `swry_dm` VARCHAR(20) COMMENT '税务人员代码',
  `swry_mc` VARCHAR(50) COMMENT '税务人员名称',
  `lxdh` VARCHAR(50) COMMENT '联系电话',
  `cjrq` DATETIME COMMENT '创建日期',
  `jzrq` DATETIME COMMENT '截止日期',
  `swjg_dm` VARCHAR(11) COMMENT '税务机关代码',
  `swjg_mc` VARCHAR(50) COMMENT '税务机关名称',
  `ywgjz` DECIMAL(18,0) COMMENT '业务关键字 对应sb_sbxx_hz的id',
  `wcrq` DATETIME COMMENT '完成日期',
  `thyy` VARCHAR(1000) COMMENT '退回原因',
  `bz` VARCHAR(200) COMMENT '备注',
  `clcs` DECIMAL(9,0) COMMENT '处理次数',
  `ywqx` LONGTEXT,
  KEY `IDX_RW_RWTXB_NSRRWLXJWGJZ` (`NSRDZDAH`, `RWLX_DM`, `YWGJZ`),
  CONSTRAINT `PK_RW_RWTXB` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='任务提醒表';

-- Creating table RW_SYNC_FILE
CREATE TABLE `RW_SYNC_FILE` (
  `id` DECIMAL(18,0),
  `md5` VARCHAR(64),
  `fileszie` DECIMAL(18,0),
  `filename` VARCHAR(100),
  `filepath` VARCHAR(100),
  `synflag` CHAR(1) COMMENT '0,待同步，1，已同步',
  `crtime` DATETIME,
  `syntime` DATETIME,
  `czry` VARCHAR(20) COMMENT '上传人'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table SB_HIS_SJFK
-- Original Oracle primary-key constraint: PK_SB_HIS_SJFK (MySQL index name: PRIMARY).
CREATE TABLE `SB_HIS_SJFK` (
  `id` DECIMAL(18,0) NOT NULL,
  `rwid` DECIMAL(18,0),
  `qyhgdm` VARCHAR(32),
  `clbz` CHAR(1) NOT NULL,
  `sjbw` LONGBLOB,
  `bwgs` VARCHAR(10),
  KEY `IDX_SB_HIS_SJFK_QYRWID` (`QYHGDM`, `RWID`),
  CONSTRAINT `PK_SB_HIS_SJFK` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table SB_JLJG_HXSBB2018
CREATE TABLE `SB_JLJG_HXSBB2018` (
  `sbid` DECIMAL(18,0) NOT NULL COMMENT '申报业务序列号',
  `xh` DECIMAL(18,0) DEFAULT 0 COMMENT '申报业务下序号',
  `sbno` VARCHAR(4) DEFAULT ' ' COMMENT '对应审核系统序号',
  `jgmysch` VARCHAR(20) NOT NULL COMMENT '加工贸易手册号',
  `fplv_jh` DECIMAL(9,5) DEFAULT 0 COMMENT '计划分配率',
  `fplv_sj` DECIMAL(9,5) DEFAULT 0 COMMENT '实际分配率',
  `lj_rmb` DECIMAL(15,2) DEFAULT 0 COMMENT '已申报出口额',
  `tzmdtdje` DECIMAL(15,2) DEFAULT 0 COMMENT '应调整免抵退税额',
  `tzbmzdkdje` DECIMAL(15,2) DEFAULT 0 COMMENT '应调整不得免征和抵扣税额',
  `ssyear` VARCHAR(4) DEFAULT ' ' COMMENT '所属年度',
  `bz` VARCHAR(200) DEFAULT ' ' COMMENT '备注',
  KEY `IDX_SB_JLJG_HXSBB2018_C1` (`SBID`, `JGMYSCH`),
  KEY `IDX_SB_JLJG_HXSBB2018_SBID` (`SBID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='生产企业进料加工业务免抵退税核销表';

-- Creating table SB_JLJG_HX_SBB
CREATE TABLE `SB_JLJG_HX_SBB` (
  `sbid` DECIMAL(18,0) NOT NULL COMMENT '申报业务序列号',
  `xh` DECIMAL(18,0) DEFAULT 0 COMMENT '申报业务下序号',
  `sbno` VARCHAR(8) DEFAULT ' ' COMMENT '对应审核系统序号',
  `jgmysch` VARCHAR(20) NOT NULL COMMENT '加工贸易手册号',
  `hx_begin` DATETIME COMMENT '核销起始时间',
  `hx_end` DATETIME COMMENT '核销截止时间',
  `fplv_jh` DECIMAL(9,5) DEFAULT 0 COMMENT '计划分配率',
  `fplv_sj` DECIMAL(9,5) DEFAULT 0 COMMENT '实际分配率',
  `lj_rmb` DECIMAL(15,2) DEFAULT 0 COMMENT '已申报出口额',
  `tzmdtdje` DECIMAL(15,2) DEFAULT 0 COMMENT '应调整免抵退税额',
  `tzbmzdkdje` DECIMAL(15,2) DEFAULT 0 COMMENT '应调整不得免征和抵扣税额',
  `ssyear` VARCHAR(4) DEFAULT ' ' COMMENT '所属年度',
  `bz` VARCHAR(200) DEFAULT ' ' COMMENT '备注',
  KEY `IDX_SB_JLJG_HX_SBB_C1` (`SBID`, `JGMYSCH`),
  KEY `IDX_SB_JLJG_HX_SBB_SBID` (`SBID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='生产企业进料加工业务免抵退税核销表';

-- Creating table SB_OTHER_BOTH_DZXXCXB
CREATE TABLE `SB_OTHER_BOTH_DZXXCXB` (
  `sbid` DECIMAL(18,0) NOT NULL COMMENT '申报id，对应sb_sbxx_hz表中的id',
  `dzzl_dm` VARCHAR(4) NOT NULL COMMENT '单证种类代码',
  `dzhm` VARCHAR(50) NOT NULL COMMENT '单证号码',
  `rsvflag` CHAR(1) COMMENT '同步/存在标志'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='单证信息查询表';

-- Creating table SB_OTHER_BOTH_DZXXSBB
CREATE TABLE `SB_OTHER_BOTH_DZXXSBB` (
  `tbpc` DECIMAL(18,0) COMMENT '同步批次',
  `sbid` DECIMAL(18,0) COMMENT '申报ID',
  `lcslid` VARCHAR(32) COMMENT '对应审核系统lcslid',
  `sbno` VARCHAR(32) COMMENT '对应审核系统sb_no',
  `dzzl_dm` VARCHAR(4) COMMENT '单证种类代码，对应审核系统BGD_NO非空格01；CKHW_DLZM_NO非空格03；CKHW_WTZM_NO非空格07',
  `dzhm` VARCHAR(50) COMMENT '单证号码，对应审核系统BGD_NO、CKHW_DLZM_NO、CKHW_WTZM_NO的非空格值',
  `jhpzh` VARCHAR(30) COMMENT '对应审核系统PZHM',
  `shflag` CHAR(1) COMMENT '对应审核系统SH_FLAG',
  `errflag` CHAR(1) COMMENT '对应审核系统ERR_FLAG',
  `cqsbflag` CHAR(1) COMMENT '对应审核系统CQSH_FLAG'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='无相关电子信息审批结果反馈表';

-- Creating table SB_SBXX_FKSJ
-- Original Oracle primary-key constraint: PK_SB_SBXX_FKSJ (MySQL index name: PRIMARY).
CREATE TABLE `SB_SBXX_FKSJ` (
  `id` DECIMAL(18,0) NOT NULL,
  `fkbw` LONGBLOB,
  `bwgs` VARCHAR(10),
  `fklx` CHAR(1) COMMENT '反馈类型  1：预审 2：依职权 ',
  CONSTRAINT `PK_SB_SBXX_FKSJ` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table SB_SBXX_HZ
-- Original Oracle primary-key constraint: PK_SB_SBXX_HZ (MySQL index name: PRIMARY).
CREATE TABLE `SB_SBXX_HZ` (
  `id` DECIMAL(18,0) NOT NULL,
  `uuid` VARCHAR(50) COMMENT '提取锁定uuid',
  `nsrdzdah` DECIMAL(20,0) NOT NULL COMMENT '纳税人电子档案号',
  `sbywb_dm` VARCHAR(20) NOT NULL COMMENT '申报状态代码',
  `sssq` CHAR(6) COMMENT '所属时期',
  `sbpc` DECIMAL(9,0) COMMENT '申报批次',
  `sbrq` DATETIME COMMENT '申报日期',
  `sbzt_dm` CHAR(2) NOT NULL COMMENT '初始：20：已申报受理；2A：网报方式，待调用网报接口；2B：文件读入方式，待人工读入文件；21：成功进入审核系统，待首次调用查询接口；30：审核系统中各环节；40：审核退回；41：申报异常；42：预审通过；43：预审有疑点',
  `lzhj` VARCHAR(50) COMMENT '流转环节',
  `fkrq` DATETIME COMMENT '反馈日期',
  `fkxx` VARCHAR(255) COMMENT '反馈信息',
  `fjsl` DECIMAL(9,0) COMMENT '附件数量',
  `qybj` CHAR(1) NOT NULL COMMENT '启用标记',
  `bz` VARCHAR(255) COMMENT '备注',
  `cjrq` DATETIME NOT NULL COMMENT '创建日期',
  `xgrq` DATETIME NOT NULL COMMENT '修改日期',
  `tqbz` VARCHAR(50) COMMENT '提取标志',
  `tqsj` DATETIME COMMENT '提取时间',
  `tqcs` DECIMAL(9,0) DEFAULT 0 COMMENT '提取次数',
  `sbyy` VARCHAR(1000) COMMENT '失败原因',
  `yxj` DECIMAL(9,0) DEFAULT 0 COMMENT '优先级',
  `sbsj` DATETIME COMMENT '申报时间',
  `tbsj` DATETIME COMMENT '同步时间',
  `lcslid` VARCHAR(50) COMMENT '流程实例ID',
  `tbcs` DECIMAL(9,0) DEFAULT 0 COMMENT '同步次数',
  `sbzl_dm` VARCHAR(10) COMMENT '申报种类代码 ',
  `sbtype` VARCHAR(10) COMMENT '申报种类 正式申报：ZSSB    预申报：YSB',
  `ysbz` VARCHAR(40) COMMENT '预审标记',
  `ystqsj` DATETIME COMMENT '预审提取时间',
  `yswcsj` DATETIME COMMENT '预审完成时间',
  `ystqcs` DECIMAL(9,0) DEFAULT 0 COMMENT '预审提取次数',
  `bwzy` VARCHAR(40) COMMENT '报文摘要',
  `ysjg` CHAR(1) COMMENT '预审结果   0:无疑点；1：只有可挑过疑点 ;2：有不可挑过疑点',
  `sbr` VARCHAR(50) COMMENT '申报人',
  `sbfs` CHAR(1) COMMENT '申报方式',
  `sbcs` DECIMAL(9,0) DEFAULT 0 COMMENT '申报次数，记录云平台正式申报提交次数，每正式申报该值+1',
  `zzsbb` CHAR(1) COMMENT '增值税申报表  0: 金三系统中已经全申报    1：审核系统中已经全申    空：没有全申报',
  `sbtmse` DECIMAL(16,2),
  KEY `IDX_SB_SBXX_HZ_LCSLID` (`LCSLID`),
  KEY `IDX_SB_SBXX_HZ_SBZT` (`SBZT_DM`),
  KEY `IX_SB_SBXX_HZ_NSS` (`NSRDZDAH`, `SSSQ`, `SBYWB_DM`),
  CONSTRAINT `PK_SB_SBXX_HZ` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table SB_SBXX_LOG
CREATE TABLE `SB_SBXX_LOG` (
  `fssj` DATETIME(6) NOT NULL,
  `sbid` DECIMAL(18,0) NOT NULL,
  `nsrdzdah` DECIMAL(20,0) NOT NULL,
  `sbywb_dm` VARCHAR(20),
  `sssq` CHAR(6),
  `sbpc` DECIMAL(9,0),
  `sbzt_dm` CHAR(2),
  `fkxx` VARCHAR(255),
  `sbyy` VARCHAR(1000),
  `lcslid` VARCHAR(50),
  `czlx` VARCHAR(20),
  KEY `IDX_SB_SBXX_LOG_NSRDZDAH` (`NSRDZDAH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table SB_SBXX_SBSJ
-- Original Oracle primary-key constraint: PK_SB_SBXX_SBSJ (MySQL index name: PRIMARY).
CREATE TABLE `SB_SBXX_SBSJ` (
  `id` DECIMAL(18,0) NOT NULL,
  `sbbw` LONGBLOB,
  `bwgs` VARCHAR(10),
  `bwzy` VARCHAR(200) COMMENT '报文摘要',
  `bwqm` LONGTEXT COMMENT '报文签名',
  `mwzy` VARCHAR(200) COMMENT '明文',
  CONSTRAINT `PK_SB_SBXX_SBSJ` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table SHZS_ETL_SWRY
CREATE TABLE `SHZS_ETL_SWRY` (
  `swry_dm` VARCHAR(11),
  `swrysf_dm` VARCHAR(32) NOT NULL,
  `swrymc` VARCHAR(113),
  `swjg_dm` VARCHAR(18),
  `gw_dm` VARCHAR(18) NOT NULL,
  `gwxh` VARCHAR(32),
  `sfswjgdm` VARCHAR(11) COMMENT '身份税务机关代码.00到科室
',
  PRIMARY KEY (`SWRYSF_DM`, `GW_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table SHZS_WP_SWRY
-- SHZS_WP_SWRY.id: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- Original Oracle primary-key constraint: PK_WP_R_ID (MySQL index name: PRIMARY).
CREATE TABLE `SHZS_WP_SWRY` (
  `id` DECIMAL(65,27) NOT NULL,
  `sfdm` VARCHAR(32) COMMENT '税务人员身份代码',
  `swrymc` VARCHAR(113),
  `status` CHAR(1) COMMENT '状态 0，离线  1，在线',
  `remark` VARCHAR(100) COMMENT '备注',
  `crtime` DATETIME COMMENT '创建时间',
  `uptime` DATETIME COMMENT '更新时间',
  `gwxh` VARCHAR(32) COMMENT '岗位序号',
  `swjgdm` VARCHAR(18) COMMENT '税务机关代码,0000到区县',
  `gwdm` VARCHAR(18) COMMENT '岗位代码',
  `swrydm` VARCHAR(11) COMMENT '税务人员代码',
  `sfswjgdm` VARCHAR(11) COMMENT '身份税务机关代码.00到科室
',
  KEY `IDX_SWJG_GW` (`SWJGDM`, `GWDM`),
  KEY `IDX_SWRYSF` (`SFDM`, `GWDM`),
  CONSTRAINT `PK_WP_R_ID` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table SHZS_WP_TASK
-- Original Oracle primary-key constraint: PK_WP_ID (MySQL index name: PRIMARY).
CREATE TABLE `SHZS_WP_TASK` (
  `id` VARCHAR(32) NOT NULL COMMENT '同zj_mh.mh_rwxx表gzxid值一致',
  `nsrsbh` VARCHAR(20) COMMENT '企业税号',
  `nsrmc` VARCHAR(100) COMMENT '企业名称',
  `swjgdm` VARCHAR(11) COMMENT '税务机关代码',
  `swsxdm` VARCHAR(32) COMMENT '税务事项代码',
  `ssqpc` VARCHAR(10) COMMENT '所属期批次, 调整为：环节（受理、审核、核准）等',
  `sbrq` DATETIME COMMENT '申报日期',
  `wpsj` DATETIME COMMENT '委派时间',
  `wpsfdm` VARCHAR(32) COMMENT '委派对象身份代码',
  `wpdx` VARCHAR(18) COMMENT '委派对象名称',
  `wpjg` VARCHAR(10) COMMENT '委派结果',
  `wpr` VARCHAR(18) COMMENT '委派人',
  `wpdxqyfz` VARCHAR(18) COMMENT '委派对象企业分组',
  `lcslid` VARCHAR(32) COMMENT '流程实例ID',
  `jdmode` CHAR(1) COMMENT '接单方式  1分组 0随机',
  `status` CHAR(1) COMMENT '状态 0预委派 1委派完成',
  CONSTRAINT `PK_WP_ID` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table SYS_CFG_CZRY_FPGL
-- Original Oracle primary-key constraint: PK_SYS_CFG_CZRY_FPGL (MySQL index name: PRIMARY).
CREATE TABLE `SYS_CFG_CZRY_FPGL` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '主键，序列号',
  `czry_dm` VARCHAR(20) NOT NULL COMMENT '操作人员代码',
  `swjg_dm` VARCHAR(200) COMMENT '税务机关代码',
  `zsjg_dm_set` VARCHAR(1000) COMMENT '征收机关代码（可多选）',
  `flgl_set` VARCHAR(20) COMMENT '分类管理簇: .C.D.',
  `jsmode_set` VARCHAR(20) COMMENT '退税计算方式代码簇，例如：.1.2.',
  `zgswry_dm_set` VARCHAR(200) COMMENT '专管员代码（可多选）',
  `crtime` DATETIME COMMENT '创建时间',
  `crname` VARCHAR(20) COMMENT '创建人员',
  `uptime` DATETIME COMMENT '更新时间',
  `upname` VARCHAR(20) COMMENT '更新人员',
  `qybz` CHAR(1) NOT NULL COMMENT '启用标识',
  `limit_sc` DECIMAL(10,0) DEFAULT 0,
  `limit_wm` DECIMAL(10,0) DEFAULT 0,
  `limit_qt` DECIMAL(10,0) DEFAULT 0,
  `cnt_sc` DECIMAL(10,0),
  `cnt_wm` DECIMAL(10,0),
  `cnt_qt` DECIMAL(10,0),
  `czry_tssh` VARCHAR(20),
  UNIQUE KEY `UQ_SYS_CFG_CZRY_FPGL` (`CZRY_DM`),
  CONSTRAINT `PK_SYS_CFG_CZRY_FPGL` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='审核助手_操作人员分户管理设置';

-- Creating table SYS_CFG_CZRY_ROLE
-- Original Oracle primary-key constraint: PK_SYS_CFG_CZRY_ROLE (MySQL index name: PRIMARY).
CREATE TABLE `SYS_CFG_CZRY_ROLE` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '主键，序列号',
  `czry_dm` VARCHAR(20) NOT NULL COMMENT '操作人员代码',
  `role_dm` VARCHAR(20) NOT NULL COMMENT '角色代码',
  `crtime` DATETIME COMMENT '创建时间',
  `crname` VARCHAR(20) COMMENT '创建人员',
  `uptime` DATETIME COMMENT '更新时间',
  `upname` VARCHAR(20) COMMENT '更新人员',
  `czry_tssh` VARCHAR(20),
  KEY `IDX_SYS_CFG_CZRY_ROLE_CZRY` (`CZRY_DM`),
  KEY `IDX_SYS_CFG_CZRY_ROLE_ROLE` (`ROLE_DM`),
  CONSTRAINT `PK_SYS_CFG_CZRY_ROLE` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='权限管理_操作人员对应角色表';

-- Creating table SYS_CFG_ROLE_SERVICE
-- Original Oracle primary-key constraint: PK_SYS_CFG_ROLE_SERVICE (MySQL index name: PRIMARY).
CREATE TABLE `SYS_CFG_ROLE_SERVICE` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '主键，序列号',
  `role_dm` VARCHAR(20) NOT NULL COMMENT '角色代码',
  `service_dm` VARCHAR(200) NOT NULL COMMENT '服务代码',
  `crtime` DATETIME COMMENT '创建时间',
  `crname` VARCHAR(20) COMMENT '创建人员',
  `uptime` DATETIME COMMENT '更新时间',
  `upname` VARCHAR(20) COMMENT '更新人员',
  KEY `SYS_CFG_ROLE_SERVICE_ROLE` (`ROLE_DM`),
  KEY `SYS_CFG_ROLE_SERVICE_SRV` (`SERVICE_DM`),
  CONSTRAINT `PK_SYS_CFG_ROLE_SERVICE` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='权限管理_角色服务对应表';

-- Creating table SYS_CFG_SBDR_FILEMODE
-- Original Oracle primary-key constraint: PK_SYS_CFG_SBDR_FILEMODE (MySQL index name: PRIMARY).
CREATE TABLE `SYS_CFG_SBDR_FILEMODE` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '主键，序列号',
  `codetype` VARCHAR(10) NOT NULL COMMENT '代码类型：GS--所属税务机关 ZS--征收税务机关 HG--海关代码 NS--纳税人识别号',
  `code` VARCHAR(20) NOT NULL COMMENT '代码值',
  `flgl_set` VARCHAR(20) COMMENT '分类管理簇: .C.D.',
  `jsmode_set` VARCHAR(20) COMMENT '退税计算方式代码簇，例如：.1.2.',
  `sbywb_set` VARCHAR(1000) COMMENT '申报业务编码簇，格式：.业务表代码1.业务表代码2. 循环，例如：.A0301001.A0305001.',
  `crtime` DATETIME COMMENT '创建时间',
  `crname` VARCHAR(20) COMMENT '创建人员',
  `uptime` DATETIME COMMENT '更新时间',
  `upname` VARCHAR(20) COMMENT '更新人员',
  `qybz` CHAR(1) NOT NULL COMMENT '启用标识',
  `jd_mode` CHAR(1) COMMENT '接单模式  1-随机分单（预设接单人） ',
  `yj_close` CHAR(1) COMMENT '预警信息关闭显示 1关闭；空或0不关闭',
  UNIQUE KEY `UQ_SYS_CFG_SBDR_FILEMODE` (`CODETYPE`, `CODE`),
  CONSTRAINT `PK_SYS_CFG_SBDR_FILEMODE` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='审核助手_文件模式接口设置';

-- Creating table SYS_TPI_AUTHOR
CREATE TABLE `SYS_TPI_AUTHOR` (
  `id` DECIMAL(10,0) NOT NULL COMMENT '序号',
  `appid` VARCHAR(30) NOT NULL COMMENT '第三方应用标识',
  `account` VARCHAR(30) NOT NULL COMMENT '授权帐号',
  `passwd` VARCHAR(30) NOT NULL COMMENT '密码',
  `ipset` VARCHAR(1000) COMMENT '已绑定的IP集合，用逗号分割',
  `qybz` CHAR(1) NOT NULL COMMENT 'Y有效 N无效',
  `note` VARCHAR(100) COMMENT '备注描述',
  `qxswjg` VARCHAR(11) COMMENT '权限税务机关',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table SYS_TPI_LOG
CREATE TABLE `SYS_TPI_LOG` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '序号',
  `appid` VARCHAR(30) COMMENT '第三方应用标识',
  `account` VARCHAR(30) COMMENT '帐号',
  `ip` VARCHAR(30) COMMENT '交易客户端IP',
  `tranid` VARCHAR(18) COMMENT '交易流水号',
  `funcname` VARCHAR(100) COMMENT '交易接口名',
  `reqtime` DATETIME COMMENT '请求时间',
  `rsptime` DATETIME COMMENT '响应时间',
  `reqnr` VARCHAR(4000) COMMENT '请求内容',
  `rspnr` VARCHAR(4000) COMMENT '响应内容',
  `clbz` CHAR(1) COMMENT '1成功 0失败',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='第三方接口交易日志表';

-- Creating table TB_CKTS_BICODE_SUB
-- Original Oracle primary-key constraint: PK_TB_CKTS_BICODE_SUB (MySQL index name: PRIMARY).
CREATE TABLE `TB_CKTS_BICODE_SUB` (
  `code` VARCHAR(3) NOT NULL,
  `item_no` VARCHAR(10),
  `hl_ym` VARCHAR(6) NOT NULL,
  `hl_rmb` DECIMAL(10,5) DEFAULT (0),
  `hl_usd` DECIMAL(10,5) DEFAULT (0),
  `hl_range` DECIMAL(5,2) DEFAULT (0),
  `st_date` DATETIME,
  `end_date` DATETIME,
  `readin_date` DATETIME,
  `tbpc` DECIMAL(18,0) NOT NULL,
  `tberr` VARCHAR(500),
  CONSTRAINT `PK_TB_CKTS_BICODE_SUB` PRIMARY KEY (`CODE`, `HL_YM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TB_CKTS_GC_JLJG_JHFPL
-- Original Oracle primary-key constraint: PK_TB_CKTS_GC_JLJG_JHFPL (MySQL index name: PRIMARY).
CREATE TABLE `TB_CKTS_GC_JLJG_JHFPL` (
  `uuid` VARCHAR(32) NOT NULL,
  `cpcode` VARCHAR(32) NOT NULL DEFAULT ' ',
  `sb_ym` VARCHAR(6) NOT NULL DEFAULT ' ',
  `jhfpl` DECIMAL(9,5) DEFAULT 0,
  `jhfpl_new` DECIMAL(9,5) DEFAULT 0,
  `op_date` DATETIME DEFAULT '1900-01-01 00:00:00',
  `readin_date` DATETIME,
  `tbpc` DECIMAL(18,0) NOT NULL,
  `tberr` VARCHAR(500),
  KEY `IDX_GC_JLJG_JHFPL_CPCODE` (`CPCODE`),
  KEY `IDX_GC_JLJG_JHFPL_RDINDATE` (`READIN_DATE`, `TBPC`),
  CONSTRAINT `PK_TB_CKTS_GC_JLJG_JHFPL` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TB_CKTS_GC_SQ_TXFW
-- Original Oracle primary-key constraint: PK_TB_CKTS_GC_SQ_TXFW (MySQL index name: PRIMARY).
CREATE TABLE `TB_CKTS_GC_SQ_TXFW` (
  `uuid` VARCHAR(32) NOT NULL,
  `cpcode` VARCHAR(32) NOT NULL DEFAULT ' ',
  `txfw_flag` VARCHAR(1) DEFAULT ' ',
  `djr` VARCHAR(75) DEFAULT ' ',
  `djr_duty` VARCHAR(300) DEFAULT ' ',
  `djr_tel` VARCHAR(60) DEFAULT ' ',
  `email1` VARCHAR(50) DEFAULT ' ',
  `djr2` VARCHAR(75) DEFAULT ' ',
  `djr2_duty` VARCHAR(300) DEFAULT ' ',
  `djr2_tel` VARCHAR(60) DEFAULT ' ',
  `email2` VARCHAR(50) DEFAULT ' ',
  `readin_date` DATETIME,
  `tbpc` DECIMAL(18,0) NOT NULL,
  `tberr` VARCHAR(500),
  KEY `IDX_CKTS_GC_SQ_TXFW_CPCODE` (`CPCODE`),
  KEY `IDX_CKTS_GC_SQ_TXFW_RDINDATE` (`READIN_DATE`, `TBPC`),
  CONSTRAINT `PK_TB_CKTS_GC_SQ_TXFW` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TB_CKTS_HISTORY_ZJDLZM
-- Original Oracle primary-key constraint: PK_TB_CKTS_HISTORY_ZJDLZM (MySQL index name: PRIMARY).
CREATE TABLE `TB_CKTS_HISTORY_ZJDLZM` (
  `wt_cpcode` VARCHAR(32) NOT NULL,
  `dlzm_no` VARCHAR(20) NOT NULL DEFAULT ' ',
  `bgd_no` VARCHAR(21) DEFAULT ' ',
  `lj_date` DATETIME DEFAULT '1900-01-01 00:00:00',
  `tdcode` VARCHAR(4) NOT NULL DEFAULT ' ',
  `cmcode` VARCHAR(12) DEFAULT ' ',
  `cmname` VARCHAR(254) DEFAULT ' ',
  `cmunit` VARCHAR(9) DEFAULT ' ',
  `bg_qnt` DECIMAL(15,4) DEFAULT (0),
  `bicode` VARCHAR(3) NOT NULL DEFAULT ' ',
  `usd_amt` DECIMAL(15,2) DEFAULT (0),
  `readin_date` DATETIME,
  `tbpc` DECIMAL(18,0) NOT NULL,
  `tberr` VARCHAR(500),
  KEY `IDX_HISTORY_ZJDLZM_RDINDATE` (`READIN_DATE`, `TBPC`),
  CONSTRAINT `PK_TB_CKTS_HISTORY_ZJDLZM` PRIMARY KEY (`WT_CPCODE`, `DLZM_NO`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TB_DTBSJ
-- Original Oracle primary-key constraint: PK_TB_DTBSJ_2 (MySQL index name: PRIMARY).
CREATE TABLE `TB_DTBSJ` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '序号',
  `tblx_dm` VARCHAR(50) NOT NULL COMMENT '同步类型代码',
  `mainid` DECIMAL(18,0) NOT NULL COMMENT '待同步数据主ID值',
  `cjsj` DATETIME(6) NOT NULL COMMENT '创建时间',
  `tqbz` VARCHAR(100) COMMENT '同步标志',
  `tqsj` DATETIME(6) COMMENT '同步时间',
  `tbcs` DECIMAL(9,0) NOT NULL COMMENT '同步次数',
  `sbyy` VARCHAR(2000) COMMENT '失败原因',
  `yxj` DECIMAL(9,0) NOT NULL DEFAULT 0 COMMENT '优先级',
  KEY `IX_TB_DTBSJ_YXJ2` (`YXJ`),
  CONSTRAINT `PK_TB_DTBSJ_2` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='待同步数据表';

-- Creating table TB_DTBSJ_ERR
-- Original Oracle primary-key constraint: PK_TB_DTBSJ_ERR (MySQL index name: PRIMARY).
CREATE TABLE `TB_DTBSJ_ERR` (
  `id` DECIMAL(18,0) NOT NULL,
  `tblx_dm` VARCHAR(50) NOT NULL,
  `mainid` DECIMAL(18,0) NOT NULL,
  `cjsj` DATETIME(6) NOT NULL,
  `tqbz` VARCHAR(100),
  `tqsj` DATETIME(6),
  `tbcs` DECIMAL(9,0) NOT NULL,
  `sbyy` VARCHAR(2000),
  `yxj` DECIMAL(9,0) NOT NULL DEFAULT 0,
  CONSTRAINT `PK_TB_DTBSJ_ERR` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TB_DTBSJ_LOG
-- Original Oracle primary-key constraint: PK_TB_DTBSJ_LOG (MySQL index name: PRIMARY).
CREATE TABLE `TB_DTBSJ_LOG` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '主键',
  `tblx_dm` VARCHAR(50) COMMENT '同步类型',
  `sbid` DECIMAL(18,0) COMMENT '申报id,对应tb_dtbsj表中的mainid',
  `cjsj` DATETIME(6),
  CONSTRAINT `PK_TB_DTBSJ_LOG` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TB_GS_NSRBAT
-- Original Oracle primary-key constraint: PK_GS_NSRBAT (MySQL index name: PRIMARY).
CREATE TABLE `TB_GS_NSRBAT` (
  `qyhgdm` VARCHAR(32) NOT NULL COMMENT '企业海关代码',
  `bz` VARCHAR(100),
  CONSTRAINT `PK_GS_NSRBAT` PRIMARY KEY (`QYHGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TB_GS_NSRXX
-- Original Oracle primary-key constraint: PK_TB_GS_NSRXX (MySQL index name: PRIMARY).
CREATE TABLE `TB_GS_NSRXX` (
  `qyhgdm` VARCHAR(32) COMMENT '企业海关代码',
  `nsrmc` VARCHAR(200) COMMENT '企业名称',
  `tbrq` DATETIME COMMENT '发票首次同步起始日期',
  `yxbz` CHAR(1) DEFAULT 'Y' COMMENT '有效标志，Y有效   N无效，不同步',
  `nsrdzdah` DECIMAL(20,0) NOT NULL COMMENT '纳税人电子档案号',
  `cpcode` VARCHAR(32) COMMENT '核心征管系统TO_CHAR(DJXH)',
  `cpcodetssh` VARCHAR(32) COMMENT '老审核系统CPCODE',
  CONSTRAINT `PK_TB_GS_NSRXX` PRIMARY KEY (`NSRDZDAH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='同步纳税人名单信息';

-- Creating table TB_GS_TBBZ
-- Original Oracle primary-key constraint: PK_TB_GS_TBBZ (MySQL index name: PRIMARY).
CREATE TABLE `TB_GS_TBBZ` (
  `tblx_dm` VARCHAR(50) NOT NULL COMMENT '同步类型',
  `tbnr` VARCHAR(20) COMMENT '同步内容，NSRSBH 或 ALL',
  `tbrq` DATETIME COMMENT '待同步起始日期',
  `tbsj` DATETIME COMMENT '同步时间',
  `tbcs` DECIMAL(18,0) NOT NULL DEFAULT 0 COMMENT '同步次数',
  `sbyy` VARCHAR(600) COMMENT '失败原因',
  `nsrdzdah` DECIMAL(20,0) NOT NULL COMMENT '纳税人电子档案号，可空',
  `qyhgdm` VARCHAR(32) NOT NULL COMMENT '企业海关代码或企业纳税人识别号',
  KEY `IDX_TB_GS_TBBZ` (`TBLX_DM`, `TBNR`),
  CONSTRAINT `PK_TB_GS_TBBZ` PRIMARY KEY (`TBLX_DM`, `NSRDZDAH`, `QYHGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='国税待同步标志表';

-- Creating table TB_GS_TBSB_RZ
CREATE TABLE `TB_GS_TBSB_RZ` (
  `tblx_dm` VARCHAR(50) COMMENT '同步类型',
  `sbrq` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '失败日期',
  `sbyy` VARCHAR(600) COMMENT '失败原因'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='国税待同步错误日志';

-- Creating table TB_GS_TBZT
-- Original Oracle primary-key constraint: PK_TB_GS_TBZT (MySQL index name: PRIMARY).
CREATE TABLE `TB_GS_TBZT` (
  `tblx_dm` VARCHAR(50) NOT NULL COMMENT '同步类型',
  `qssj` DATETIME COMMENT '同步起始日期',
  `zzsj` DATETIME COMMENT '同步终止日期',
  `zs` DECIMAL(18,0) NOT NULL DEFAULT 0 COMMENT '总数',
  `dqs` DECIMAL(18,0) NOT NULL DEFAULT 0 COMMENT '当前数',
  `sbyy` VARCHAR(600) COMMENT '失败原因',
  `tbnr` VARCHAR(32) COMMENT '同步内容，NSRSBH 或 ALL',
  CONSTRAINT `PK_TB_GS_TBZT` PRIMARY KEY (`TBLX_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='国税同步状态表';

-- Creating table TB_LOG_ETL_CHANNEL
CREATE TABLE `TB_LOG_ETL_CHANNEL` (
  `id_batch` DECIMAL(38,0),
  `channel_id` VARCHAR(255),
  `log_date` DATETIME,
  `logging_object_type` VARCHAR(255),
  `object_name` VARCHAR(255),
  `object_copy` VARCHAR(255),
  `repository_directory` VARCHAR(255),
  `filename` VARCHAR(255),
  `object_id` VARCHAR(255),
  `object_revision` VARCHAR(255),
  `parent_channel_id` VARCHAR(255),
  `root_channel_id` VARCHAR(255)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TB_LOG_ETL_ITEM
CREATE TABLE `TB_LOG_ETL_ITEM` (
  `id_batch` DECIMAL(38,0),
  `channel_id` VARCHAR(255),
  `log_date` DATETIME,
  `transname` VARCHAR(255),
  `stepname` VARCHAR(255),
  `lines_read` DECIMAL(38,0),
  `lines_written` DECIMAL(38,0),
  `lines_updated` DECIMAL(38,0),
  `lines_input` DECIMAL(38,0),
  `lines_output` DECIMAL(38,0),
  `lines_rejected` DECIMAL(38,0),
  `errors` DECIMAL(38,0),
  `result` CHAR(1),
  `nr_result_rows` DECIMAL(38,0),
  `nr_result_files` DECIMAL(38,0),
  KEY `IDX_TB_LOG_ETL_ITEM_1` (`ID_BATCH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TB_LOG_ETL_JOB
CREATE TABLE `TB_LOG_ETL_JOB` (
  `id_job` DECIMAL(38,0),
  `channel_id` VARCHAR(255),
  `jobname` VARCHAR(255),
  `status` VARCHAR(15),
  `lines_read` DECIMAL(38,0),
  `lines_written` DECIMAL(38,0),
  `lines_updated` DECIMAL(38,0),
  `lines_input` DECIMAL(38,0),
  `lines_output` DECIMAL(38,0),
  `lines_rejected` DECIMAL(38,0),
  `errors` DECIMAL(38,0),
  `startdate` DATETIME,
  `enddate` DATETIME,
  `logdate` DATETIME,
  `depdate` DATETIME,
  `replaydate` DATETIME,
  `log_field` LONGTEXT,
  KEY `IDX_TB_LOG_ETL_JOB_1` (`ID_JOB`),
  KEY `IDX_TB_LOG_ETL_JOB_2` (`ERRORS`, `STATUS`, `JOBNAME`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJ_CLBZ
CREATE TABLE `TJ_CLBZ` (
  `ssyf` VARCHAR(6) NOT NULL COMMENT '所属月份',
  `tjlx` VARCHAR(50) NOT NULL COMMENT '统计类型',
  `cljg` CHAR(1) NOT NULL COMMENT '处理结果',
  `jgnr` VARCHAR(4000) COMMENT '结果内容',
  `clsjs` DATETIME COMMENT '开始处理时间',
  `clsje` DATETIME COMMENT '结束处理时间',
  `swjg_dm` VARCHAR(11) COMMENT '区县税务机关代码',
  KEY `IDX_TJ_CLBZ_RZYF` (`SSYF`, `TJLX`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='统计日志表';

-- Creating table TJ_TSQK_NSR
-- Original Oracle primary-key constraint: PK_TJ_TSQK_NSR (MySQL index name: PRIMARY).
CREATE TABLE `TJ_TSQK_NSR` (
  `qyhgdm` VARCHAR(32),
  `cpcode` VARCHAR(32),
  `nsrsbh` VARCHAR(32),
  `nsrmc` VARCHAR(4000),
  `zcdz` VARCHAR(200),
  `nsrdh` VARCHAR(20),
  `tsjsfs_dm` CHAR(1),
  `hy_dm` VARCHAR(4),
  `djzclx_dm` VARCHAR(200),
  `swjg_dm` VARCHAR(11),
  `zx_flag` VARCHAR(1),
  `bjtssbcs` DECIMAL(12,0),
  `tjnd` VARCHAR(4),
  `tjyf` VARCHAR(4),
  `ckssed` DECIMAL(12,2),
  `cksser` DECIMAL(12,2),
  `zzstse` DECIMAL(12,2),
  `zzsmde` DECIMAL(12,2),
  `xfstse` DECIMAL(12,2),
  `xfsmde` DECIMAL(12,2),
  `sbcs` DECIMAL(12,0),
  `bgdfs` DECIMAL(12,0),
  `dlzmfs` DECIMAL(12,0),
  `zyfpfs` DECIMAL(12,0),
  `zyfpje` DECIMAL(12,2),
  `nsrdzdah` DECIMAL(20,0) NOT NULL,
  `bgdjed` DECIMAL(12,2),
  `bgdjer` DECIMAL(12,2),
  `bsy1_mc` VARCHAR(30),
  `bsy1_dh` VARCHAR(20),
  `bsy2_mc` VARCHAR(30),
  `bsy2_dh` VARCHAR(20),
  `bgds` DECIMAL(12,0),
  CONSTRAINT `PK_TJ_TSQK_NSR` PRIMARY KEY (`NSRDZDAH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJ_TSQK_SWJG
-- Original Oracle primary-key constraint: PK_TJ_TSQK_SWJG (MySQL index name: PRIMARY).
CREATE TABLE `TJ_TSQK_SWJG` (
  `ssyf` VARCHAR(6) NOT NULL COMMENT '所属月份',
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关',
  `tjrq` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '统计日期',
  `bjts_ktqys_sc` DECIMAL(9,0) DEFAULT 0 COMMENT '便捷退税开通企业数生产',
  `bjts_ktqys_wm` DECIMAL(9,0) DEFAULT 0 COMMENT '便捷退税开通企业数外贸',
  `bjts_ktqys_ms` DECIMAL(9,0) DEFAULT 0 COMMENT '便捷退税开通企业数免税',
  `bjts_ktqys_qt` DECIMAL(9,0) DEFAULT 0 COMMENT '便捷退税开通企业数其他',
  `bjts_sbqys_sc` DECIMAL(9,0) DEFAULT 0 COMMENT '便捷退税申报企业数生产',
  `bjts_sbqys_wm` DECIMAL(9,0) DEFAULT 0 COMMENT '便捷退税申报企业数外贸',
  `bjts_sbqys_ms` DECIMAL(9,0) DEFAULT 0 COMMENT '便捷退税申报企业数免税',
  `bjts_sbqys_qt` DECIMAL(9,0) DEFAULT 0 COMMENT '便捷退税申报企业数其他',
  `tssh_ktqys_sc` DECIMAL(9,0) DEFAULT 0 COMMENT '审核系统开通企业数生产',
  `tssh_ktqys_wm` DECIMAL(9,0) DEFAULT 0 COMMENT '审核系统开通企业数外贸',
  `tssh_ktqys_sc_a` DECIMAL(9,0) DEFAULT 0 COMMENT '审核系统开通企业数生产A类',
  `tssh_ktqys_wm_a` DECIMAL(9,0) DEFAULT 0 COMMENT '审核系统开通企业数外贸A类',
  `tssh_ktqys_sc_b` DECIMAL(9,0) DEFAULT 0 COMMENT '审核系统开通企业数生产B类',
  `tssh_ktqys_wm_b` DECIMAL(9,0) DEFAULT 0 COMMENT '审核系统开通企业数外贸B类',
  `tssh_ktqys_sc_c` DECIMAL(9,0) DEFAULT 0 COMMENT '审核系统开通企业数生产C类',
  `tssh_ktqys_wm_c` DECIMAL(9,0) DEFAULT 0 COMMENT '审核系统开通企业数外贸C类',
  `tssh_ktqys_sc_d` DECIMAL(9,0) DEFAULT 0 COMMENT '审核系统开通企业数生产D类',
  `tssh_ktqys_wm_d` DECIMAL(9,0) DEFAULT 0 COMMENT '审核系统开通企业数外贸D类',
  `tssh_sbqys_sc` DECIMAL(9,0) DEFAULT 0 COMMENT '审核系统申报企业数生产',
  `tssh_sbqys_wm` DECIMAL(9,0) DEFAULT 0 COMMENT '审核系统申报企业数外贸',
  `tssh_sbqys_sc_a` DECIMAL(9,0) DEFAULT 0 COMMENT '审核系统申报企业数生产A类',
  `tssh_sbqys_wm_a` DECIMAL(9,0) DEFAULT 0 COMMENT '审核系统申报企业数外贸A类',
  `tssh_sbqys_sc_b` DECIMAL(9,0) DEFAULT 0 COMMENT '审核系统申报企业数生产B类',
  `tssh_sbqys_wm_b` DECIMAL(9,0) DEFAULT 0 COMMENT '审核系统申报企业数外贸B类',
  `tssh_sbqys_sc_c` DECIMAL(9,0) DEFAULT 0 COMMENT '审核系统申报企业数生产C类',
  `tssh_sbqys_wm_c` DECIMAL(9,0) DEFAULT 0 COMMENT '审核系统申报企业数外贸C类',
  `tssh_sbqys_sc_d` DECIMAL(9,0) DEFAULT 0 COMMENT '审核系统申报企业数生产D类',
  `tssh_sbqys_wm_d` DECIMAL(9,0) DEFAULT 0 COMMENT '审核系统申报企业数外贸D类',
  `tssh_sptse_sc` DECIMAL(15,2) DEFAULT 0 COMMENT '审核系统申报退税额生产',
  `tssh_sptse_wm` DECIMAL(15,2) DEFAULT 0 COMMENT '审核系统申报退税额外贸',
  `tssh_sptse_sc_a` DECIMAL(15,2) DEFAULT 0 COMMENT '审核系统申报退税额生产A类',
  `tssh_sptse_wm_a` DECIMAL(15,2) DEFAULT 0 COMMENT '审核系统申报退税额外贸A类',
  `tssh_sptse_sc_b` DECIMAL(15,2) DEFAULT 0 COMMENT '审核系统申报退税额生产B类',
  `tssh_sptse_wm_b` DECIMAL(15,2) DEFAULT 0 COMMENT '审核系统申报退税额外贸B类',
  `tssh_sptse_sc_c` DECIMAL(15,2) DEFAULT 0 COMMENT '审核系统申报退税额生产C类',
  `tssh_sptse_wm_c` DECIMAL(15,2) DEFAULT 0 COMMENT '审核系统申报退税额外贸C类',
  `tssh_sptse_sc_d` DECIMAL(15,2) DEFAULT 0 COMMENT '审核系统申报退税额生产D类',
  `tssh_sptse_wm_d` DECIMAL(15,2) DEFAULT 0 COMMENT '审核系统申报退税额外贸D类',
  `tssh_sptse_sc_md` DECIMAL(15,2) DEFAULT 0 COMMENT '审核系统申报退税额生产-免抵',
  `tssh_sptse_sc_md_a` DECIMAL(15,2) DEFAULT 0 COMMENT '审核系统申报退税额生产-免抵A类',
  `tssh_sptse_sc_md_b` DECIMAL(15,2) DEFAULT 0 COMMENT '审核系统申报退税额生产-免抵B类',
  `tssh_sptse_sc_md_c` DECIMAL(15,2) DEFAULT 0 COMMENT '审核系统申报退税额生产-免抵C类',
  `tssh_sptse_sc_md_d` DECIMAL(15,2) DEFAULT 0 COMMENT '审核系统申报退税额生产-免抵C类',
  CONSTRAINT `PK_TJ_TSQK_SWJG` PRIMARY KEY (`SSYF`, `SWJG_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='税务机关退税情况表';

-- Creating table TMP_DMMYQY
CREATE TABLE `TMP_DMMYQY` (
  `id` DECIMAL(38,0) NOT NULL,
  `qyhgdm` VARCHAR(32) NOT NULL,
  `nsrdzdah` DECIMAL(18,0),
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_DYQY_ZDH
CREATE TABLE `TMP_DYQY_ZDH` (
  `qyhgdm` VARCHAR(32),
  `nsrsbh` VARCHAR(32),
  `nsrmc` VARCHAR(400),
  `tsjsfs_dm` CHAR(1)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_DZBA_DUP
CREATE TABLE `TMP_DZBA_DUP` (
  `nsrsbh` VARCHAR(20) NOT NULL,
  `baxh` VARCHAR(60) NOT NULL,
  `sbnypc` VARCHAR(10),
  `cnt` DECIMAL(38,0),
  `jszt` DECIMAL(38,0),
  PRIMARY KEY (`BAXH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_GDD_CKMX
CREATE TABLE `TMP_GDD_CKMX` (
  `lcslid` VARCHAR(32) NOT NULL,
  `cpcode` VARCHAR(32) NOT NULL,
  `bgd_no` VARCHAR(21) NOT NULL,
  `lj_date` DATETIME,
  `readin_date` DATETIME,
  `tssb_date` DATETIME,
  `tskp_date` DATETIME,
  `cmcode` VARCHAR(20),
  `tsflag` CHAR(1),
  `bg_qnt` DECIMAL(15,4),
  `sb_qnt` DECIMAL(15,4)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_GDD_NSR
CREATE TABLE `TMP_GDD_NSR` (
  `nsrsbh` VARCHAR(20) NOT NULL,
  `nsrmc` VARCHAR(80),
  `status` VARCHAR(10),
  `nsrdzdah` DECIMAL(18,0),
  `cpcode` VARCHAR(32),
  `tsjsfs` CHAR(1),
  `tse_sb` DECIMAL(16,2),
  `amt_sb` DECIMAL(16,2),
  `amt_hg` DECIMAL(16,2),
  `tse_zh` DECIMAL(16,2),
  `tse_by` DECIMAL(16,2),
  `rmb_sb` DECIMAL(16,2),
  PRIMARY KEY (`NSRSBH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_GXJSCPML
CREATE TABLE `TMP_GXJSCPML` (
  `xh` DECIMAL(38,0),
  `cksp_dm` VARCHAR(20),
  `ckspmc` VARCHAR(75),
  `ms` VARCHAR(3000),
  `jsly` VARCHAR(10),
  `bz` VARCHAR(75)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_HZ_KJBMD
CREATE TABLE `TMP_HZ_KJBMD` (
  `id` DECIMAL(38,0) NOT NULL,
  `nsrmc` VARCHAR(100),
  `nsrsbh` VARCHAR(20),
  `nsrdzdah` DECIMAL(18,0),
  `swjg_dm` VARCHAR(11),
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_LX_NSRXX
CREATE TABLE `TMP_LX_NSRXX` (
  `id` DECIMAL(38,0) NOT NULL,
  `nsrsbh` VARCHAR(20) NOT NULL,
  `qyhgdm` VARCHAR(10),
  `nsrmc` VARCHAR(80),
  `yhmc` VARCHAR(80),
  `yhzh` VARCHAR(30),
  `fddbrxm` VARCHAR(50),
  `fddbryddh` VARCHAR(30),
  `bsy1` VARCHAR(50),
  `bsy1dh` VARCHAR(30),
  `swjg_mc` VARCHAR(80),
  `swjg_dm` VARCHAR(20),
  `tsjsfs` CHAR(1),
  `flglcd` CHAR(1),
  `zc2_dqjk` DECIMAL(16,2),
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_LX_NSR_SBPC
-- TMP_LX_NSR_SBPC.days: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
CREATE TABLE `TMP_LX_NSR_SBPC` (
  `id` DECIMAL(38,0) NOT NULL,
  `nsrsbh` VARCHAR(20) NOT NULL,
  `sssqpc` VARCHAR(10) NOT NULL,
  `sbrq` DATETIME,
  `hzrq` DATETIME,
  `tse_sb` DECIMAL(16,2),
  `days` DECIMAL(65,27),
  PRIMARY KEY (`ID`, `SSSQPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_LX_NSR_SPQ5
CREATE TABLE `TMP_LX_NSR_SPQ5` (
  `id` DECIMAL(38,0) NOT NULL,
  `nsrsbh` VARCHAR(20) NOT NULL,
  `seqno` DECIMAL(38,0) NOT NULL,
  `spdm` VARCHAR(20),
  `spmc` VARCHAR(80),
  `usdamt` DECIMAL(16,2),
  PRIMARY KEY (`ID`, `SEQNO`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_NSRA
CREATE TABLE `TMP_NSRA` (
  `nsrsbh` VARCHAR(20) NOT NULL,
  `bz` CHAR(1)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_NSRXX
CREATE TABLE `TMP_NSRXX` (
  `xh` DECIMAL(20,0) NOT NULL,
  `nsrmc` VARCHAR(200),
  `nsrsbh` VARCHAR(20),
  `dq` VARCHAR(20),
  `lx` VARCHAR(20),
  `djxh` DECIMAL(20,0),
  `qyhgdm` VARCHAR(20),
  `shxyno` VARCHAR(20),
  PRIMARY KEY (`XH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_NSRXX_DZBA
CREATE TABLE `TMP_NSRXX_DZBA` (
  `nsrsbh` VARCHAR(20),
  `sbnypc` VARCHAR(20),
  `baxh` VARCHAR(50),
  `ckywbs` DECIMAL(10,0),
  `dzfs` DECIMAL(10,0)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_NSRXX_SWJG
-- Original Oracle primary-key constraint: PK_NSRXX_SWJG (MySQL index name: PRIMARY).
CREATE TABLE `TMP_NSRXX_SWJG` (
  `nsrsbh` VARCHAR(20) NOT NULL,
  `swjg_dm` VARCHAR(11),
  `nsrmc` VARCHAR(200),
  CONSTRAINT `PK_NSRXX_SWJG` PRIMARY KEY (`NSRSBH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_NSRXX_TJ
-- Original Oracle primary-key constraint: PK_TMP_NSRXX_TJ_DJXH (MySQL index name: PRIMARY).
CREATE TABLE `TMP_NSRXX_TJ` (
  `nsrsbh` VARCHAR(32) COMMENT '纳税人识别号',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `ck_amt` DECIMAL(16,2) COMMENT '美元出口销售额',
  `qbxssr` DECIMAL(16,2) COMMENT '全部销售额',
  CONSTRAINT `PK_TMP_NSRXX_TJ_DJXH` PRIMARY KEY (`DJXH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_NSR_SBPC
-- Original Oracle primary-key constraint: PK_TMP_NSR_SBPC (MySQL index name: PRIMARY).
CREATE TABLE `TMP_NSR_SBPC` (
  `nsrmc` VARCHAR(500) NOT NULL,
  `ssq` VARCHAR(100) NOT NULL,
  `sbpc` VARCHAR(100) NOT NULL,
  `nsrsbh` VARCHAR(100),
  `djxh` VARCHAR(100),
  CONSTRAINT `PK_TMP_NSR_SBPC` PRIMARY KEY (`NSRMC`, `SSQ`, `SBPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_NSR_ZCM
CREATE TABLE `TMP_NSR_ZCM` (
  `puid` VARCHAR(20) NOT NULL,
  `cityid` VARCHAR(10) NOT NULL
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_NSR_ZSSWJG
CREATE TABLE `TMP_NSR_ZSSWJG` (
  `id` DECIMAL(10,0) NOT NULL,
  `qyhgdm` VARCHAR(20),
  `nsrsbh` VARCHAR(20),
  `nsrmc` VARCHAR(200),
  `zsjgdm` VARCHAR(20),
  `zsjgmc` VARCHAR(100),
  `zsjgdm2` VARCHAR(11),
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_SBSJ
-- Original Oracle primary-key constraint: PK_TMP_SBSJ (MySQL index name: PRIMARY).
CREATE TABLE `TMP_SBSJ` (
  `id` DECIMAL(18,0) NOT NULL,
  `sbbw` LONGBLOB,
  `bwgs` VARCHAR(10),
  `bwzy` VARCHAR(200),
  `bwqm` LONGTEXT,
  CONSTRAINT `PK_TMP_SBSJ` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_SB_SBXX_HZ
CREATE TABLE `TMP_SB_SBXX_HZ` (
  `id` DECIMAL(18,0) NOT NULL,
  `nsrdzdah` DECIMAL(20,0) NOT NULL,
  `sbywb_dm` VARCHAR(20) NOT NULL,
  `sssq` CHAR(6),
  `sbpc` DECIMAL(9,0),
  `sbrq` DATETIME,
  KEY `IDX_1` (`NSRDZDAH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_TJ_CKQYXX
CREATE TABLE `TMP_TJ_CKQYXX` (
  `nsrdzdah` DECIMAL(20,0) NOT NULL,
  `cpcode` VARCHAR(32) NOT NULL,
  `nsrsbh` VARCHAR(20),
  `shxydm` VARCHAR(20),
  `qyhgdm` VARCHAR(32),
  `nsrmc` VARCHAR(100),
  `tsjsfs_dm` CHAR(1),
  `flglcd` CHAR(1),
  `nsrdh` VARCHAR(20),
  `zx_flag` CHAR(1),
  `scjydz` VARCHAR(60),
  `hy` VARCHAR(2),
  `djzclx` VARCHAR(3),
  `swjg_dm` VARCHAR(11),
  `nd` VARCHAR(4),
  `ckxse_usd` DECIMAL(18,2),
  `ckxse_rmb` DECIMAL(18,2),
  `tsse_sb` DECIMAL(18,2),
  `mdse_sb` DECIMAL(18,2),
  `tsse_zh` DECIMAL(18,2),
  `mdse_zh` DECIMAL(18,2),
  `tsse_by` DECIMAL(18,2),
  `mdse_by` DECIMAL(18,2),
  `sb_num` DECIMAL(10,0),
  `glh_num` DECIMAL(10,0),
  `ckmx_num` DECIMAL(10,0),
  `jhmx_num` DECIMAL(10,0),
  PRIMARY KEY (`NSRDZDAH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_TJ_DKQY_BANK
CREATE TABLE `TMP_TJ_DKQY_BANK` (
  `cpcode` VARCHAR(32) NOT NULL,
  `nsrsbh` VARCHAR(20),
  `qyhgdm` VARCHAR(10),
  `nsrmc` VARCHAR(100),
  `tsjsfs_dm` CHAR(1),
  `bkname` VARCHAR(100),
  `flglcd` CHAR(1),
  `nsrdh` VARCHAR(20),
  `scjydz` VARCHAR(60),
  `hy` VARCHAR(2),
  `djzclx` VARCHAR(3),
  `swjg_dm` VARCHAR(11),
  `yh_dm` VARCHAR(10),
  PRIMARY KEY (`CPCODE`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_TJ_DKQY_HXYH
CREATE TABLE `TMP_TJ_DKQY_HXYH` (
  `cpcode` VARCHAR(32) NOT NULL,
  `nsrsbh` VARCHAR(20),
  `qyhgdm` VARCHAR(10),
  `nsrmc` VARCHAR(100),
  `tsjsfs_dm` CHAR(1),
  `bkname` VARCHAR(100),
  `flglcd` CHAR(1),
  `nsrdh` VARCHAR(20),
  `scjydz` VARCHAR(60),
  `hy` VARCHAR(2),
  `djzclx` VARCHAR(3),
  `swjg_dm` VARCHAR(11),
  `nd` VARCHAR(4),
  `ckxse_usd` DECIMAL(18,2),
  `tsse_sb` DECIMAL(18,2),
  `mdse_sb` DECIMAL(18,2),
  `tsse_zh` DECIMAL(18,2),
  `mdse_zh` DECIMAL(18,2),
  `tsse_by` DECIMAL(18,2),
  `mdse_by` DECIMAL(18,2),
  `sb_num` DECIMAL(10,0),
  `glh_num` DECIMAL(10,0),
  `ckmx_num` DECIMAL(10,0),
  `jhmx_num` DECIMAL(10,0),
  PRIMARY KEY (`CPCODE`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_TJ_LX_ZGYH
CREATE TABLE `TMP_TJ_LX_ZGYH` (
  `id` DECIMAL(8,0) NOT NULL,
  `nsrsbh` VARCHAR(20) NOT NULL,
  `xse1` DECIMAL(16,2),
  `xse2` DECIMAL(16,2),
  `xse3` DECIMAL(16,2),
  `xse4` DECIMAL(16,2),
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_TJ_RANDOM
CREATE TABLE `TMP_TJ_RANDOM` (
  `nsrdzdah` DECIMAL(20,0) NOT NULL,
  `nsrsbh` VARCHAR(20) NOT NULL,
  `flglcd` CHAR(1),
  `tsjsfs` CHAR(1),
  `jhkh` CHAR(1),
  `mdse12m` DECIMAL(16,2),
  `tse12m` DECIMAL(16,2),
  `tscnt12m` DECIMAL(38,0),
  `mdse24m` DECIMAL(16,2),
  `tse24m` DECIMAL(16,2),
  `tscnt24m` DECIMAL(38,0),
  `xssr` DECIMAL(16,2),
  `zzsjscnt` DECIMAL(38,0),
  `shxyno` VARCHAR(20),
  `tscs18` DECIMAL(8,0),
  PRIMARY KEY (`NSRDZDAH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_TSSH_CZY
-- Original Oracle primary-key constraint: PK_TMP_TSSH_CZY (MySQL index name: PRIMARY).
CREATE TABLE `TMP_TSSH_CZY` (
  `user_id` VARCHAR(20) NOT NULL,
  `usrstate` VARCHAR(20),
  `fullname` VARCHAR(200),
  CONSTRAINT `PK_TMP_TSSH_CZY` PRIMARY KEY (`USER_ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_WMTS
CREATE TABLE `TMP_WMTS` (
  `uuid` VARCHAR(32) NOT NULL,
  `cpcode` VARCHAR(32) NOT NULL,
  `ym` VARCHAR(6) NOT NULL,
  `ck_usd` DECIMAL(15,2) DEFAULT 0,
  `jhje` DECIMAL(15,2) DEFAULT 0,
  `zse` DECIMAL(15,2) DEFAULT 0,
  `tse` DECIMAL(15,2) DEFAULT 0,
  KEY `IDX_TMP_WMTS_1` (`CPCODE`, `YM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table WMR_ENTERPRISE
-- Original Oracle primary-key constraint: PK_WMR_ENTERPRISE (MySQL index name: PRIMARY).
CREATE TABLE `WMR_ENTERPRISE` (
  `nsrsbh` VARCHAR(20) NOT NULL COMMENT '纳税人识别号',
  `nsrmc` VARCHAR(200) COMMENT '纳税人名称',
  `czbz` CHAR(1) NOT NULL COMMENT '操作标志（0-准入，1-贷中，2-注销）',
  `zrsj` DATETIME(6) COMMENT '准入时间',
  `dzsj` DATETIME(6) COMMENT '贷中时间',
  `zxsj` DATETIME(6) COMMENT '注销时间',
  `cjsj` DATETIME(6) NOT NULL DEFAULT (CAST(CURRENT_TIMESTAMP(0) AS DATETIME)) COMMENT '创建时间',
  `xgsj` DATETIME(6) COMMENT '更新时间',
  `bz` VARCHAR(200) COMMENT '备注，预留',
  CONSTRAINT `PK_WMR_ENTERPRISE` PRIMARY KEY (`NSRSBH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='外贸融-企业表';

-- Creating table ZZ_CWBB_LRBWXQ
CREATE TABLE `ZZ_CWBB_LRBWXQ` (
  `nsrsbh` VARCHAR(20) NOT NULL,
  `sssq` CHAR(6) NOT NULL,
  `ewbhxh` DECIMAL(38,0) NOT NULL,
  `mc` VARCHAR(100),
  `bys` DECIMAL(16,2),
  `bnljs` DECIMAL(16,2),
  PRIMARY KEY (`NSRSBH`, `SSSQ`, `EWBHXH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table ZZ_CWBB_LRBXQY
CREATE TABLE `ZZ_CWBB_LRBXQY` (
  `nsrsbh` VARCHAR(20) NOT NULL,
  `sssq` CHAR(6) NOT NULL,
  `ewbhxh` DECIMAL(38,0) NOT NULL,
  `hmc` VARCHAR(100),
  `byje` DECIMAL(16,2),
  `bnljje` DECIMAL(16,2),
  PRIMARY KEY (`NSRSBH`, `SSSQ`, `EWBHXH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table ZZ_CWBB_LRBYBQY
CREATE TABLE `ZZ_CWBB_LRBYBQY` (
  `nsrsbh` VARCHAR(20) NOT NULL,
  `sssq` CHAR(6) NOT NULL,
  `ewbhxh` DECIMAL(38,0) NOT NULL,
  `hmc` VARCHAR(100),
  `bqje` DECIMAL(16,2),
  `sqje_1` DECIMAL(16,2),
  PRIMARY KEY (`NSRSBH`, `SSSQ`, `EWBHXH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table ZZ_CWBB_ZCFZBWXQ
CREATE TABLE `ZZ_CWBB_ZCFZBWXQ` (
  `nsrsbh` VARCHAR(20) NOT NULL,
  `sssq` CHAR(6) NOT NULL,
  `ewbhxh` DECIMAL(38,0) NOT NULL,
  `zcxmmc` VARCHAR(100),
  `qms_zc` DECIMAL(16,2),
  `ncs_zc` DECIMAL(16,2),
  `qyxmmc` VARCHAR(100),
  `qms_qy` DECIMAL(16,2),
  `ncs_qy` DECIMAL(16,2),
  PRIMARY KEY (`NSRSBH`, `SSSQ`, `EWBHXH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table ZZ_CWBB_ZCFZBXQY
CREATE TABLE `ZZ_CWBB_ZCFZBXQY` (
  `nsrsbh` VARCHAR(20) NOT NULL,
  `sssq` CHAR(6) NOT NULL,
  `ewbhxh` DECIMAL(38,0) NOT NULL,
  `zcxmmc` VARCHAR(100),
  `qmye_zc` DECIMAL(16,2),
  `ncye_zc` DECIMAL(16,2),
  `qyxmmc` VARCHAR(100),
  `qmye_qy` DECIMAL(16,2),
  `ncye_qy` DECIMAL(16,2),
  PRIMARY KEY (`NSRSBH`, `SSSQ`, `EWBHXH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table ZZ_CWBB_ZCFZBYBQY
CREATE TABLE `ZZ_CWBB_ZCFZBYBQY` (
  `nsrsbh` VARCHAR(20) NOT NULL,
  `sssq` CHAR(6) NOT NULL,
  `ewbhxh` DECIMAL(38,0) NOT NULL,
  `zcxmmc` VARCHAR(100),
  `qmye_zc` DECIMAL(16,2),
  `ncye_zc` DECIMAL(16,2),
  `qyxmmc` VARCHAR(100),
  `qmye_qy` DECIMAL(16,2),
  `ncye_qy` DECIMAL(16,2),
  PRIMARY KEY (`NSRSBH`, `SSSQ`, `EWBHXH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table ZZ_NSR
CREATE TABLE `ZZ_NSR` (
  `nsrsbh` VARCHAR(20) NOT NULL,
  `nsrmc` VARCHAR(80),
  `djxh` DECIMAL(20,0),
  `ssny` DATETIME,
  `zzs_sbuuid` VARCHAR(32),
  `cwbbzl_dm` VARCHAR(20),
  `cwb_sbuuid` VARCHAR(32),
  PRIMARY KEY (`NSRSBH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table ZZ_ZZS_YBNSR
CREATE TABLE `ZZ_ZZS_YBNSR` (
  `nsrsbh` VARCHAR(20) NOT NULL,
  `sssq` CHAR(6) NOT NULL,
  `ewblxh` DECIMAL(38,0) NOT NULL,
  `asysljsxse` DECIMAL(16,2),
  `yshwxse` DECIMAL(16,2),
  `yslwxse` DECIMAL(16,2),
  `sysl_nsjctzxse` DECIMAL(16,2),
  `ajybfjsxse` DECIMAL(16,2),
  `jybf_nsjctzxse` DECIMAL(16,2),
  `mdtbfckxse` DECIMAL(16,2),
  `msxse` DECIMAL(16,2),
  `mshwxse` DECIMAL(16,2),
  `mslwxse` DECIMAL(16,2),
  `xxse` DECIMAL(16,2),
  `jxse` DECIMAL(16,2),
  `sqldse` DECIMAL(16,2),
  `jxsezc` DECIMAL(16,2),
  `mdtytse` DECIMAL(16,2),
  `sysl_nsjcybjse` DECIMAL(16,2),
  `ydksehj` DECIMAL(16,2),
  `sjdkse` DECIMAL(16,2),
  `ynse` DECIMAL(16,2),
  `qmldse` DECIMAL(16,2),
  `jybf_ynse` DECIMAL(16,2),
  `jybf_nsjcybjse` DECIMAL(16,2),
  `ynsejze` DECIMAL(16,2),
  `ynsehj` DECIMAL(16,2),
  `qcwjse` DECIMAL(16,2),
  `ssckkjzyjkstse` DECIMAL(16,2),
  `bqyjse` DECIMAL(16,2),
  `fcyjse` DECIMAL(16,2),
  `ckkjzyjksyjse` DECIMAL(16,2),
  `bqjnsqynse` DECIMAL(16,2),
  `bqjnqjse` DECIMAL(16,2),
  `qmwjse` DECIMAL(16,2),
  `qmwjse_qjse` DECIMAL(16,2),
  `bqybtse` DECIMAL(16,2),
  `jzjtsjtse` DECIMAL(16,2),
  `qcwjcbse` DECIMAL(16,2),
  `bqrkcbse` DECIMAL(16,2),
  `qmwjcbse` DECIMAL(16,2),
  PRIMARY KEY (`NSRSBH`, `SSSQ`, `EWBLXH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

SET SESSION sql_mode = @yiziemei_mysql8_saved_sql_mode;
SET @yiziemei_mysql8_saved_sql_mode = NULL;
