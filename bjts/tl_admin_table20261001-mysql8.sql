-- MySQL 8.0.17+ / InnoDB; UTF-8 encoded.
-- Source: tl_admin_table20261001-nodup.sql (strictly decoded from GBK).
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

-- Creating table CS_SH_FZTSGWRY
-- Original Oracle primary-key constraint: PK_CS_SH_FZTSGWRY_ID (MySQL index name: PRIMARY).
CREATE TABLE `CS_SH_FZTSGWRY` (
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `qyhgdm` VARCHAR(32) NOT NULL COMMENT '企业海关代码',
  `nsrmc` VARCHAR(100) NOT NULL COMMENT '纳税人名称',
  `slg` VARCHAR(20) COMMENT '受理岗',
  `shg` VARCHAR(20) COMMENT '审核岗',
  `fhg` VARCHAR(20) COMMENT '复审岗',
  `hzg` VARCHAR(20) COMMENT '核准岗',
  `ffg` VARCHAR(20) COMMENT '发放岗',
  `flag` CHAR(1) COMMENT '校验标志 空：尚未校验 Y通过 N校验不通过',
  `lrsj` DATETIME COMMENT '录入时间',
  `bgsj` DATETIME COMMENT '更新时间',
  `cpcode` VARCHAR(32) COMMENT 'cpcode',
  `note` VARCHAR(255) COMMENT '校验信息',
  `id` DECIMAL(18,0) NOT NULL COMMENT '主键id',
  KEY `IDX_CS_SH_FZTSGWRY` (`SWJG_DM`, `QYHGDM`),
  CONSTRAINT `PK_CS_SH_FZTSGWRY_ID` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='分组推送岗位人员参数表';

-- Creating table CS_SH_SJTSGWRY
CREATE TABLE `CS_SH_SJTSGWRY` (
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `shgwdm` VARCHAR(20) NOT NULL COMMENT '岗位代码--关联DM_SH_GW表',
  `user_id` VARCHAR(32) NOT NULL COMMENT '操作员代码',
  `lrrq` DATETIME COMMENT '录入时间',
  PRIMARY KEY (`SWJG_DM`, `SHGWDM`, `USER_ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='随机接单岗位人员参数表';

-- Creating table CS_SH_YDTSGW
CREATE TABLE `CS_SH_YDTSGW` (
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `bktgyd` VARCHAR(20) COMMENT '不可挑过疑点',
  `ktgyd` VARCHAR(20) COMMENT '可挑过疑点',
  `wyd` VARCHAR(20) COMMENT '无疑点',
  `lsb` VARCHAR(20) COMMENT '零申报',
  PRIMARY KEY (`SWJG_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='疑点推送岗位参数表';

-- Creating table CZ_LOG
-- CZ_LOG.id: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
CREATE TABLE `CZ_LOG` (
  `id` DECIMAL(65,27) NOT NULL,
  `lcslid` VARCHAR(50),
  `code` VARCHAR(100),
  `sbyy` VARCHAR(2000),
  `cjsj` DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DCB_NSR_YSBQC
-- Original Oracle primary-key constraint: PK_DCB_NSR_YSBQC (MySQL index name: PRIMARY).
CREATE TABLE `DCB_NSR_YSBQC` (
  `nsrdzdah` DECIMAL(20,0) NOT NULL,
  `qxlx` CHAR(2) NOT NULL COMMENT '权限类型(01:东阳退税指标测算)',
  `qybj` CHAR(1) COMMENT '启用标记',
  `crtime` DATETIME COMMENT '创建时间',
  `tsjsfs_dm` CHAR(1),
  `zdhbz` CHAR(1),
  CONSTRAINT `PK_DCB_NSR_YSBQC` PRIMARY KEY (`NSRDZDAH`, `QXLX`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='调查表-纳税人应申报清册';

-- Creating table DCB_TSYCBFSLQK_LOG
-- Original Oracle primary-key constraint: PRI_DCB_TSYCBFSLQK_LOG (MySQL index name: PRIMARY).
CREATE TABLE `DCB_TSYCBFSLQK_LOG` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '自增主键',
  `nsrdzdah` DECIMAL(20,0) NOT NULL COMMENT '纳税人电子档案号',
  `ny` CHAR(6) NOT NULL COMMENT '年月，接单时的系统年月',
  `yctse` DECIMAL(16,2) COMMENT '预测退税额',
  `sbywb_dm` VARCHAR(50) NOT NULL COMMENT '申报业务表代码',
  `sbnypc` VARCHAR(10) COMMENT '申报年月批次',
  `sbtse` DECIMAL(16,2) COMMENT '申报退税额',
  `dyljsbtse` DECIMAL(16,2) COMMENT '当月累计申报退税额',
  `cldz` CHAR(1) COMMENT '处理动作',
  `yysm` VARCHAR(200) COMMENT '原因说明',
  `czymc` VARCHAR(50) COMMENT '操作员名称',
  `crtime` DATETIME COMMENT '创建时间',
  KEY `INX_DCB_TSYCBFSLQK_LOG` (`NSRDZDAH`, `NY`),
  CONSTRAINT `PRI_DCB_TSYCBFSLQK_LOG` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='调查表_退税预测不符受理情况_日志';

-- Creating table DCB_TSZBCS_DDBDCKXQ
CREATE TABLE `DCB_TSZBCS_DDBDCKXQ` (
  `id` DECIMAL(18,0) NOT NULL,
  `nsrdzdah` DECIMAL(20,0) NOT NULL,
  `tjnd` CHAR(4) NOT NULL COMMENT '统计年度',
  `tjyf` CHAR(2) NOT NULL COMMENT '统计月份',
  `lsdd` DECIMAL(16,2) COMMENT '流失订单',
  `xjdd` DECIMAL(16,2) COMMENT '新接订单',
  `zhfhdd` DECIMAL(16,2) COMMENT '暂缓发货订单',
  `hhfhdd` DECIMAL(16,2) COMMENT '恢复发货订单',
  `ddze` DECIMAL(16,2) COMMENT '订单总额（公式=∑新接订单-∑流失订单）',
  `sndtqdd` DECIMAL(16,2) COMMENT '上年度同期订单',
  `yckdd` DECIMAL(16,2) COMMENT '已出口订单',
  `sjzhfhdd` DECIMAL(16,2) COMMENT '实际暂缓发货订单（公式=暂缓发货订单-恢复发货订单）',
  `yjqnzjf` DECIMAL(16,4) COMMENT '预计全年增/降幅（公式=(订单总额-去年同期)/去年同期*100 %）',
  `knjy` VARCHAR(2000) COMMENT '目前困难和建议',
  `ckxse` DECIMAL(16,2) COMMENT '出口额',
  `mde` DECIMAL(16,2) COMMENT '免抵额',
  `tse` DECIMAL(16,2) COMMENT '退税额',
  `ckhblv` DECIMAL(16,4) COMMENT '出口额环比（公式=(出口额-上月出口额)/上月出口额*100%）',
  `tshblv` DECIMAL(16,4) COMMENT '退税额环比（公式=(退税额-上月退税额)/上月退税额*100%）',
  `hbycyy` VARCHAR(1000) COMMENT '退税额环比异常原因（退税额环比波动在正负20%以上时必须填写）',
  `crtime` DATETIME COMMENT '创建时间',
  `uptime` DATETIME COMMENT '更新时间',
  `sbbz` CHAR(1) COMMENT '上报标志(0未上报,1已上报)',
  `jdtj_ksbcke` DECIMAL(16,2) COMMENT '局端统计-可申报出口额',
  `jdtj_sbcke` DECIMAL(16,2) COMMENT '局端统计-申报出口额',
  `jdtj_mde` DECIMAL(16,2) COMMENT '局端统计-申报免抵额',
  `jdtj_tse` DECIMAL(16,2) COMMENT '局端统计-申报退税额',
  `jdtj_flag` CHAR(1) COMMENT '局端统计-标志(0:待统计, 1:统计完成 2:统计失败)',
  `jdtj_time` DATETIME COMMENT '局端统计-时间',
  `note` VARCHAR(200) COMMENT '备注',
  `wce` DECIMAL(16,2) COMMENT '误差额',
  `wclv` DECIMAL(16,4) COMMENT '误差率',
  UNIQUE KEY `UQ_TSZBCS_DDBDCKXQ_NNY` (`NSRDZDAH`, `TJND`, `TJYF`),
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='调查表-退税指标测算业务-订单变动及出口需求调查表';

-- Creating table DCB_TSZBCS_TJ
-- Original Oracle primary-key constraint: PK_DCB_TSZBCS_TJ (MySQL index name: PRIMARY).
CREATE TABLE `DCB_TSZBCS_TJ` (
  `nsrdzdah` DECIMAL(20,0) NOT NULL COMMENT '纳税人电子档案号',
  `tjnd` CHAR(4) NOT NULL COMMENT '统计年度',
  `tjyf` CHAR(2) NOT NULL COMMENT '统计月份',
  `tsjsfs_dm` CHAR(1) NOT NULL COMMENT '退税计算方式1生产2外贸',
  `ksb_cke` DECIMAL(16,2) COMMENT '可申报出口额(近六个月出口）',
  `sysb_cke` DECIMAL(16,2) COMMENT '上月实际申报出口额',
  `sysb_mde` DECIMAL(16,2) COMMENT '上月实际申报免抵额',
  `sysb_tse` DECIMAL(16,2) COMMENT '上月实际申报退税额',
  `wsb_jxfpse` DECIMAL(16,2) COMMENT '外贸企业，近六个月已入审核系统未申报进项发票税额',
  `sykp_xxse` DECIMAL(16,2) COMMENT '生产企业，上月开票（专票）销项税额',
  `sykp_jxse` DECIMAL(16,2) COMMENT '生产企业，上月购货（专票）进项税额',
  `sqldse` DECIMAL(16,2) COMMENT '生产企业，上期留抵税额',
  `mdtytse` DECIMAL(16,2) COMMENT '生产企业，免抵退应退税额',
  `qmldse` DECIMAL(16,2) COMMENT '生产企业，期末留抵税额测算',
  `tjbz` CHAR(1) COMMENT '统计标志（预留使用）',
  `tjstime` DATETIME COMMENT '统计开始时间',
  `tjetime` DATETIME COMMENT '统计结束时间',
  `sykp_rzdk` DECIMAL(16,2) COMMENT '生产企业，所属期上月的已认证抵扣税额',
  `bz` VARCHAR(200) COMMENT '备注',
  CONSTRAINT `PK_DCB_TSZBCS_TJ` PRIMARY KEY (`NSRDZDAH`, `TJND`, `TJYF`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='退税指标测算局端统计表';

-- Creating table DCB_WCE_LIMIT_CONFIG
-- Original Oracle primary-key constraint: PRI_DCB_WCE_LIMIT_CONFIG (MySQL index name: PRIMARY).
CREATE TABLE `DCB_WCE_LIMIT_CONFIG` (
  `swjg_dm` VARCHAR(50) NOT NULL COMMENT '税务机关代码',
  `wce_up` DECIMAL(16,2) COMMENT '误差额上限',
  `wce_down` DECIMAL(16,2) COMMENT '误差额下限',
  CONSTRAINT `PRI_DCB_WCE_LIMIT_CONFIG` PRIMARY KEY (`SWJG_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='调查表_误差额_上下限配置表';

-- Creating table DM_CATALOG
-- Original Oracle primary-key constraint: DM_CATALOG_PK (MySQL index name: PRIMARY).
CREATE TABLE `DM_CATALOG` (
  `code` VARCHAR(20) NOT NULL COMMENT '代码',
  `code_alias` VARCHAR(20) COMMENT '代码别名',
  `name` VARCHAR(30) COMMENT '名称',
  `pcode` VARCHAR(20) COMMENT '父类代码',
  `need_flag` CHAR(1) COMMENT '是否必要',
  `input_flag` CHAR(1) COMMENT '是否需要输入',
  `showorder` DECIMAL(10,0) COMMENT '排序',
  `qybj` CHAR(1) COMMENT '启用标记',
  `note` VARCHAR(200) COMMENT '备注',
  CONSTRAINT `DM_CATALOG_PK` PRIMARY KEY (`CODE`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_CATALOG_SWJG
-- Original Oracle primary-key constraint: DM_CATALOG_SWJG_PK (MySQL index name: PRIMARY).
CREATE TABLE `DM_CATALOG_SWJG` (
  `swjgdm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `code` VARCHAR(20) NOT NULL COMMENT '代码',
  `code_alias` VARCHAR(20) COMMENT '代码别名',
  `name` VARCHAR(30) COMMENT '名称',
  `pcode` VARCHAR(20) COMMENT '父类代码',
  `need_flag` CHAR(1) COMMENT '是否必要',
  `input_flag` CHAR(1) COMMENT '是否需要输入',
  `showorder` DECIMAL(10,0) COMMENT '排序',
  `qybj` CHAR(1) COMMENT '启用标记',
  `note` VARCHAR(200) COMMENT '备注',
  CONSTRAINT `DM_CATALOG_SWJG_PK` PRIMARY KEY (`SWJGDM`, `CODE`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_CKTS_HGGNDQ
-- Original Oracle primary-key constraint: PK_DM_CKTS_HGGNDQ (MySQL index name: PRIMARY).
CREATE TABLE `DM_CKTS_HGGNDQ` (
  `gndq_dm` CHAR(5) NOT NULL COMMENT '国内地区代码',
  `gndqmc` VARCHAR(300) NOT NULL COMMENT '国内地区名称',
  `dqxz_dm` CHAR(1) COMMENT '地区性质代码',
  `yxbz` CHAR(1) NOT NULL COMMENT '有效标志',
  `xybz` CHAR(1) NOT NULL COMMENT '选用标志',
  `gndqjc` VARCHAR(300) COMMENT '国内地区简称',
  CONSTRAINT `PK_DM_CKTS_HGGNDQ` PRIMARY KEY (`GNDQ_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='海关国内地区代码';

-- Creating table DM_DMDZ
-- Original Oracle primary-key constraint: PK_DM_DMDZ (MySQL index name: PRIMARY).
CREATE TABLE `DM_DMDZ` (
  `xm` VARCHAR(20) NOT NULL COMMENT '项目',
  `dm` VARCHAR(100) NOT NULL COMMENT '代码',
  `dz` VARCHAR(100) COMMENT '对照代码',
  `bz` VARCHAR(200) COMMENT '备注',
  CONSTRAINT `PK_DM_DMDZ` PRIMARY KEY (`XM`, `DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='代码对照表，BJ2GL-SWJG， 便捷退税管理系统税务机关';

-- Creating table DM_DQCODE
-- Original Oracle primary-key constraint: PK_DM_DQCODE_CODE (MySQL index name: PRIMARY).
CREATE TABLE `DM_DQCODE` (
  `dq_code` VARCHAR(10) NOT NULL,
  `dq_name` VARCHAR(30) DEFAULT ' ',
  `dq_ename` VARCHAR(60) DEFAULT ' ',
  `dq_type` VARCHAR(2),
  CONSTRAINT `PK_DM_DQCODE_CODE` PRIMARY KEY (`DQ_CODE`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_DQGROUP
-- Original Oracle primary-key constraint: PK_DM_DQGROUP_DQ_GB (MySQL index name: PRIMARY).
CREATE TABLE `DM_DQGROUP` (
  `dq_code` VARCHAR(10) NOT NULL,
  `gb_code` VARCHAR(3) NOT NULL,
  CONSTRAINT `PK_DM_DQGROUP_DQ_GB` PRIMARY KEY (`DQ_CODE`, `GB_CODE`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_GBCODE
-- Original Oracle primary-key constraint: PK_DM_GBCODE_CODE (MySQL index name: PRIMARY).
CREATE TABLE `DM_GBCODE` (
  `gb_code` VARCHAR(3) NOT NULL COMMENT '国别代码',
  `gb_name` VARCHAR(30) DEFAULT ' ' COMMENT '国别名称',
  `gb_ename` VARCHAR(28) DEFAULT ' ' COMMENT '国别英文名称',
  `qycode` VARCHAR(2) COMMENT '对应国外区域代码',
  `qyname` VARCHAR(60) COMMENT '对应国外区域名称',
  `qybz` CHAR(1) COMMENT '启用标志',
  CONSTRAINT `PK_DM_GBCODE_CODE` PRIMARY KEY (`GB_CODE`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_GY_SWJG
CREATE TABLE `DM_GY_SWJG` (
  `swjg_dm` CHAR(11) NOT NULL COMMENT '税务机关代码',
  `swjgmc` VARCHAR(300) NOT NULL COMMENT '税务机关名称',
  `swjgjc` VARCHAR(150) NOT NULL COMMENT '税务机构简称',
  `swjgbz` CHAR(1) NOT NULL COMMENT '税务机构标志 0机关 1部门（设计阶段建议不要使用该列）',
  `sjswjg_dm` CHAR(11) COMMENT '上级税务机关代码',
  `jgjc_dm` CHAR(2) NOT NULL COMMENT '机构级次代码',
  `swjgyzbm` CHAR(6) COMMENT '税务机构邮政编码',
  `swjgdz` VARCHAR(300) COMMENT '税务机关地址',
  `swjglxdh` VARCHAR(60) COMMENT '税务机关联系电话',
  `czdh` VARCHAR(20) COMMENT '传真电话',
  `dzxx` VARCHAR(90) COMMENT '电子信箱',
  `xzqhsz_dm` CHAR(6) COMMENT '行政区划数字代码',
  `swjgfzr_dm` CHAR(11) COMMENT '负责人',
  `gdslx_dm` CHAR(1) NOT NULL COMMENT '国地税类型代码 ',
  `xybz` CHAR(1) NOT NULL COMMENT '选用标志',
  `yxbz` CHAR(1) NOT NULL DEFAULT 'Y' COMMENT '有效标志',
  `yxqsrq` DATETIME NOT NULL COMMENT '有效起始日期',
  `yxzzrq` DATETIME NOT NULL COMMENT '有效终止日期',
  `swjgjg` VARCHAR(75) COMMENT '税务机构局轨',
  `bsfwtbz` CHAR(1) COMMENT '办税服务厅标志',
  `ghbz` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '管户标志',
  `xsxh` DECIMAL(4,0) NOT NULL DEFAULT 1 COMMENT '显示序号',
  `gjswjgmc` VARCHAR(300) COMMENT '国家税务机关名称',
  `dsswjgmc` VARCHAR(300) COMMENT '地税税务机关名称',
  `gsswjgjg` VARCHAR(75) COMMENT '国税局轨',
  `dsswjgjg` VARCHAR(75) COMMENT '地税局轨',
  `zn_dm` CHAR(2) COMMENT '职能代码',
  `swjgywmc` VARCHAR(300) COMMENT '税务机构英文名称',
  UNIQUE KEY `PK_DM_GY_SWJG` (`SWJG_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='税务机构代码';

-- Creating table DM_HBZL_HG
-- Original Oracle primary-key constraint: PK_HBZL_HG (MySQL index name: PRIMARY).
CREATE TABLE `DM_HBZL_HG` (
  `hbzl_hg` VARCHAR(6) NOT NULL,
  `hbzl_dm` VARCHAR(3) NOT NULL,
  `hbzl_mc` VARCHAR(20),
  CONSTRAINT `PK_HBZL_HG` PRIMARY KEY (`HBZL_HG`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='币制代码表';

-- Creating table DM_HGCODE
CREATE TABLE `DM_HGCODE` (
  `hgcode` VARCHAR(4) NOT NULL,
  `hgmc` VARCHAR(60),
  `xzqh_dm` VARCHAR(6) COMMENT '对应行政区划代码',
  `xzqh_mc` VARCHAR(50) COMMENT '对应行政区划名称',
  `qybz` CHAR(1) COMMENT '启用标志',
  PRIMARY KEY (`HGCODE`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_HGHYD
-- Original Oracle primary-key constraint: PK_DM_HGHYD (MySQL index name: PRIMARY).
CREATE TABLE `DM_HGHYD` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '主键，序列号',
  `hghyd_dm` VARCHAR(5) NOT NULL COMMENT '海关货源地代码',
  `hghyd_mc` VARCHAR(50) NOT NULL COMMENT '海关货源地名称',
  `xzqh_dm` VARCHAR(6) COMMENT '对应行政区划代码',
  `xzqh_mc` VARCHAR(50) COMMENT '对应行政区划名称',
  `qybz` CHAR(1) COMMENT '启用标志',
  CONSTRAINT `PK_DM_HGHYD` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='代码_海关货源地对照表';

-- Creating table DM_HGSP_TSLV_DZ
CREATE TABLE `DM_HGSP_TSLV_DZ` (
  `spdm` VARCHAR(20) NOT NULL,
  `spmc` VARCHAR(80),
  `tslv` DECIMAL(5,2),
  `tslv_o` DECIMAL(5,2),
  `bc_flag` CHAR(1),
  PRIMARY KEY (`SPDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_HGZYG
-- Original Oracle primary-key constraint: PK_DM_HGZYG (MySQL index name: PRIMARY).
CREATE TABLE `DM_HGZYG` (
  `hgzyg_dm` VARCHAR(10) NOT NULL COMMENT '海关指运港代码',
  `hgzygjc` VARCHAR(100) COMMENT '海关指运港简称',
  `hgzygywjc` VARCHAR(100) COMMENT '海关指运港英文简称',
  CONSTRAINT `PK_DM_HGZYG` PRIMARY KEY (`HGZYG_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='海关指运港代码表';

-- Creating table DM_HY_JS
CREATE TABLE `DM_HY_JS` (
  `hy_dm` VARCHAR(4) NOT NULL,
  `hymc` VARCHAR(80),
  `mlbz` CHAR(1),
  `dlbz` CHAR(1),
  `zlbz` CHAR(1),
  `xlbz` CHAR(1),
  `sjhy_dm` VARCHAR(4),
  `xybz` CHAR(1),
  `yxbz` CHAR(1),
  PRIMARY KEY (`HY_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_JDXZ
CREATE TABLE `DM_JDXZ` (
  `jdxz_dm` VARCHAR(9) NOT NULL,
  `jdxzmc` VARCHAR(300),
  `xzqhsz_dm` VARCHAR(6),
  `yxbz` CHAR(1),
  PRIMARY KEY (`JDXZ_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_SH_GW
CREATE TABLE `DM_SH_GW` (
  `shgwdm` VARCHAR(20) NOT NULL COMMENT '审核岗位代码',
  `shgwmc` VARCHAR(30) NOT NULL COMMENT '审核岗位名称',
  `showorder` DECIMAL(38,0) NOT NULL COMMENT '显示顺序',
  `tsshdm` VARCHAR(30) COMMENT '审核系统中的代码',
  PRIMARY KEY (`SHGWDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='审核岗位字典表';

-- Creating table DM_SPFL
-- Original Oracle primary-key constraint: PK_DM_SPFL (MySQL index name: PRIMARY).
CREATE TABLE `DM_SPFL` (
  `spml` VARCHAR(4),
  `spdl` VARCHAR(4) NOT NULL,
  CONSTRAINT `PK_DM_SPFL` PRIMARY KEY (`SPDL`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_SPML
CREATE TABLE `DM_SPML` (
  `spml` VARCHAR(4) NOT NULL,
  `mlmc` VARCHAR(200),
  `mldm` VARCHAR(20),
  PRIMARY KEY (`SPML`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_SWJG
-- Original Oracle primary-key constraint: PK_DM_SWJG (MySQL index name: PRIMARY).
CREATE TABLE `DM_SWJG` (
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `swjg_mc` VARCHAR(80) NOT NULL COMMENT '税务机关名称',
  `swjg_jc` VARCHAR(80) NOT NULL COMMENT '税务机关简称',
  `swjg_dm_sj` VARCHAR(11) NOT NULL COMMENT '上级税务机关代码',
  `yxws` DECIMAL(10,0) COMMENT '有效位数',
  `swjg_bz` CHAR(1) NOT NULL COMMENT '税务机关标识',
  `qybz` CHAR(1) NOT NULL COMMENT '启用标识',
  `tsjg_bz` CHAR(1),
  `xzqhsz_dm` CHAR(6),
  `dispsx` VARCHAR(20) COMMENT '显示缩写',
  `zbjg_dm` VARCHAR(11) COMMENT '指标机关代码',
  `zg` VARCHAR(20) COMMENT '字轨(单证备案)',
  CONSTRAINT `PK_DM_SWJG` PRIMARY KEY (`SWJG_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='权限管理_税务机关代码表，一般与征管系统同步';

-- Creating table DM_SWJG_VIRTUAL
-- Original Oracle primary-key constraint: PK_VIR_SWJG (MySQL index name: PRIMARY).
CREATE TABLE `DM_SWJG_VIRTUAL` (
  `vir_swjgdm` VARCHAR(11) NOT NULL COMMENT '当记录为下级单位时，该字段为真实的税务机关单位代码',
  `vir_name` VARCHAR(100) NOT NULL,
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '当为虚拟单位时，为所属单位代码，否则为子单位所属的虚拟代码代码',
  `yxbz` CHAR(1),
  `vir_flag` CHAR(1) COMMENT '是否虚拟单位节点',
  CONSTRAINT `PK_VIR_SWJG` PRIMARY KEY (`VIR_SWJGDM`, `SWJG_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_TDCODE
CREATE TABLE `DM_TDCODE` (
  `tdcode` VARCHAR(4) NOT NULL,
  `tdmc` VARCHAR(30),
  PRIMARY KEY (`TDCODE`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_TSL_BB03105
CREATE TABLE `DM_TSL_BB03105` (
  `bblc` VARCHAR(2),
  `tsl` DECIMAL(16,4),
  `tslv` VARCHAR(10)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_XZQH
CREATE TABLE `DM_XZQH` (
  `dm` VARCHAR(6) NOT NULL COMMENT '行政区划代码',
  `mc` VARCHAR(50) NOT NULL COMMENT '行政区划名称',
  `qycode` VARCHAR(2) COMMENT '对应国内区域代码',
  `qyname` VARCHAR(50) COMMENT '对应国内区域名称',
  `qybz` CHAR(1) COMMENT '启用标志',
  PRIMARY KEY (`DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_XZQH_DQ
-- Original Oracle primary-key constraint: PK_DM_XZQH_DQ (MySQL index name: PRIMARY).
CREATE TABLE `DM_XZQH_DQ` (
  `dm` VARCHAR(6) NOT NULL COMMENT '行政区划代码',
  `mc` VARCHAR(50) NOT NULL COMMENT '行政区划名称',
  `qycode` VARCHAR(2) COMMENT '对应国内区域代码',
  `qyname` VARCHAR(50) COMMENT '对应国内区域名称',
  `qybz` CHAR(1) COMMENT '启用标志',
  CONSTRAINT `PK_DM_XZQH_DQ` PRIMARY KEY (`DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='按大区划分行政区划';

-- Creating table DM_XZQH_SF
-- Original Oracle primary-key constraint: PK_DM_XZQH_SF (MySQL index name: PRIMARY).
CREATE TABLE `DM_XZQH_SF` (
  `dm` VARCHAR(6) NOT NULL COMMENT '行政区划代码',
  `mc` VARCHAR(50) NOT NULL COMMENT '行政区划名称',
  `qycode` VARCHAR(2) COMMENT '对应国内区域代码',
  `qyname` VARCHAR(50) COMMENT '对应国内区域名称',
  `qybz` CHAR(1) COMMENT '启用标志',
  CONSTRAINT `PK_DM_XZQH_SF` PRIMARY KEY (`DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='按大区划分行政区划';

-- Creating table DM_XZQH_ZJ
CREATE TABLE `DM_XZQH_ZJ` (
  `xzqh_dm` VARCHAR(6) NOT NULL,
  `xzqh_mc` VARCHAR(150) NOT NULL,
  `sjxzqh_dm` VARCHAR(6),
  `yxbz` CHAR(1),
  PRIMARY KEY (`XZQH_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_ZBJG
-- DM_ZBJG.showorder: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
CREATE TABLE `DM_ZBJG` (
  `zbjg_dm` VARCHAR(11) NOT NULL COMMENT '指标机关代码',
  `zbjg_mc` VARCHAR(100) NOT NULL COMMENT '机关名称',
  `zbjg_jc` VARCHAR(100) NOT NULL COMMENT '机关简称',
  `sj_zbjg` VARCHAR(11) NOT NULL COMMENT '上级代码（体现汇总关系）',
  `yxbz` CHAR(1) NOT NULL COMMENT 'Y有效 N无效',
  `lx` CHAR(1) DEFAULT '1' COMMENT '类型：1实际机构 2汇总机构',
  `whqx` VARCHAR(11) DEFAULT '133' COMMENT '维护权限',
  `showorder` DECIMAL(65,27) COMMENT '显示顺序',
  `ck_zbjg` VARCHAR(11) COMMENT '指标出库机关（空表示省局指标库）',
  PRIMARY KEY (`ZBJG_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table EDOC_APPLY
-- Original Oracle primary-key constraint: EDOC_APPLY_PRIMARYKEY (MySQL index name: PRIMARY).
CREATE TABLE `EDOC_APPLY` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键id',
  `nsrsbh` VARCHAR(21) NOT NULL COMMENT '纳税人识别号',
  `result` CHAR(1) NOT NULL COMMENT '申请结果。1-已申请，2-已通过，3-已拒绝',
  `apply_time` DATETIME(6) NOT NULL COMMENT '申请时间',
  `audit_time` DATETIME(6) COMMENT '审核时间',
  `remark` VARCHAR(255) COMMENT '备注（拒绝原因）',
  `file_path` VARCHAR(255) COMMENT '申请表PDF文件路径',
  `concacts` VARCHAR(40) COMMENT '联系人',
  `tel` VARCHAR(40) COMMENT '联系电话',
  `address` VARCHAR(1000) COMMENT '企业联系地址',
  KEY `IDX_EDOC_APPLY_NSRSBH` (`NSRSBH`),
  CONSTRAINT `EDOC_APPLY_PRIMARYKEY` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='资格备案申请表';

-- Creating table EDOC_AUTO_TIME
-- Original Oracle primary-key constraint: PK_EDOC_AUTO_TIME (MySQL index name: PRIMARY).
CREATE TABLE `EDOC_AUTO_TIME` (
  `id` DECIMAL(20,0) NOT NULL,
  `deal_type` CHAR(1) NOT NULL COMMENT '1-轮询金三业务办理信息表生成备案任务和申报撤回任务',
  `deal_time` DATETIME(6) NOT NULL COMMENT '处理时间',
  UNIQUE KEY `UDX_EDOC_AUTO_TIME` (`DEAL_TYPE`),
  CONSTRAINT `PK_EDOC_AUTO_TIME` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='处理定时任务记录处理时间的表';

-- Creating table EDOC_CATALOG_FIRST
-- Original Oracle primary-key constraint: EDOC_CATALOG_FIRST_PRIMARYKEY (MySQL index name: PRIMARY).
CREATE TABLE `EDOC_CATALOG_FIRST` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键',
  `nsrsbh` VARCHAR(21) NOT NULL COMMENT '纳税人识别号',
  `baxh` VARCHAR(36) NOT NULL COMMENT '备案序号',
  `sbnypc` VARCHAR(36) NOT NULL COMMENT '申报年月批次',
  `sbrq` DATETIME NOT NULL COMMENT '申报日期',
  `entry_id` VARCHAR(21) NOT NULL COMMENT '报关单号（可以是代理证明号）',
  `ckfp_no` VARCHAR(3000) COMMENT '出口发票号',
  `jhfp_no` VARCHAR(3000) COMMENT '进货发票(进货凭证号)',
  `zrbm` VARCHAR(64) COMMENT '责任部门',
  `zrr` VARCHAR(64) COMMENT '责任人',
  `shbz` VARCHAR(64) COMMENT '审核标志',
  `shrq` DATETIME COMMENT '审核日期',
  `inspector` VARCHAR(20) COMMENT '审核人',
  `remark` VARCHAR(255) COMMENT '备注说明',
  `je` DECIMAL(15,2) COMMENT '金额',
  `se` DECIMAL(15,2) COMMENT '税额',
  `sfqqbz` CHAR(1) COMMENT '是否齐全标志 .0-无状态,1-未齐全，2-必备单证齐全，3-单证齐全',
  `gdzt` CHAR(1) COMMENT '归档状态.0-未归档,1-已归档',
  `sbxh` VARCHAR(8) COMMENT '最小的申报序号',
  `dlzmh` VARCHAR(20) COMMENT '代理证明号',
  KEY `IDX_EDOC_CATALOG_FIRST_NXE` (`NSRSBH`, `BAXH`, `ENTRY_ID`),
  CONSTRAINT `EDOC_CATALOG_FIRST_PRIMARYKEY` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='备案目录主表';

-- Creating table EDOC_CATALOG_SECOND
-- Original Oracle primary-key constraint: EDOC_CATALOG_SECOND_PRIMARYKEY (MySQL index name: PRIMARY).
CREATE TABLE `EDOC_CATALOG_SECOND` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键',
  `dzdl` VARCHAR(36) COMMENT '单证大类 1-备案单证，2-申报单证，3-其他单证',
  `edoc_type` VARCHAR(10) COMMENT '单证类型',
  `edoc_id` DECIMAL(20,0) COMMENT '单证文件ID,与单证文件信息表关联',
  `edoc_state` VARCHAR(600) COMMENT '单证说明',
  `edoc_flag` CHAR(1) COMMENT '单证标志  0-必备1-市县局要求必备2-非必备',
  `update_time` DATETIME(6) COMMENT '更新时间， 即最后一次导入单证的时间',
  `edoc_type_sub` VARCHAR(10) COMMENT '单证类型详细',
  `nsrsbh` VARCHAR(21) COMMENT '纳税人识别号',
  `entry_id` VARCHAR(21) COMMENT '报关单/代理证明号',
  KEY `IDX_EDOC_CATALOG_SECOND` (`EDOC_ID`),
  KEY `IDX_EDOC_CATALOG_SECOND_NE` (`NSRSBH`, `ENTRY_ID`),
  CONSTRAINT `EDOC_CATALOG_SECOND_PRIMARYKEY` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='备案目录索引表';

-- Creating table EDOC_DECLARE_WITHDRAW_RESULT
-- Original Oracle primary-key constraint: PK_EDOC_DECLARE_WITHDRAW_RESUL (MySQL index name: PRIMARY).
CREATE TABLE `EDOC_DECLARE_WITHDRAW_RESULT` (
  `busikey` VARCHAR(50) NOT NULL COMMENT '业务主键',
  `sjly` CHAR(1) NOT NULL COMMENT '数据来源 1-老版本便捷退税触发器产生  2-自动轮询金三数据',
  `cjsj` DATETIME(6) COMMENT '创建时间',
  `xgsj` DATETIME(6) COMMENT '修改时间',
  CONSTRAINT `PK_EDOC_DECLARE_WITHDRAW_RESUL` PRIMARY KEY (`BUSIKEY`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='生成申报撤回任务结果表';

-- Creating table EDOC_ENTRY_MAIN
-- Original Oracle primary-key constraint: PK_EDOC_ENTRY_MAIN (MySQL index name: PRIMARY).
CREATE TABLE `EDOC_ENTRY_MAIN` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键',
  `nsrsbh` VARCHAR(21) NOT NULL COMMENT '纳税人识别号',
  `entry_id` VARCHAR(21) NOT NULL COMMENT '报关单号/代理证明号',
  `sbywzl` VARCHAR(15) COMMENT '申报业务种类',
  `edoc_size` VARCHAR(10) COMMENT '文件大小(局端不使用，企业端使用)',
  `owner_scc` VARCHAR(21) COMMENT '生产销售单位税号',
  `owner_name` VARCHAR(70) COMMENT '生产销售单位名称',
  `e_date` DATETIME COMMENT '出口日期',
  `contr_no` VARCHAR(50) COMMENT '合同协议号',
  `manual_no` VARCHAR(30) COMMENT '备案号',
  `traf_name` VARCHAR(50) COMMENT '运输工具名称',
  `cus_traf_mode` VARCHAR(5) COMMENT '运输方式代码',
  `cus_traf_mode_name` VARCHAR(30) COMMENT '运输方式名称',
  `bill_no` VARCHAR(32) COMMENT '提运单号',
  `supv_mode_code` VARCHAR(4) COMMENT '贸易方式代码',
  `supv_mode_code_name` VARCHAR(30) COMMENT '贸易方式名称',
  `cus_trade_nation_code` VARCHAR(10) COMMENT '  贸易国别(地区)代码',
  `cus_trade_nation_code_name` VARCHAR(70) COMMENT '贸易国别(地区)名称',
  `ywlx_code` VARCHAR(30) COMMENT '业务类型代码',
  `ywlx_name` VARCHAR(75) COMMENT '业务类型名称',
  `remark` VARCHAR(500) COMMENT '备注',
  `crtime` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `uptime` DATETIME COMMENT '修改时间',
  `sbdwdm` VARCHAR(50) COMMENT '申报单位代码(委托报关单位代码)',
  `sbdwmc` VARCHAR(300) COMMENT '申报单位名称(委托报关单位名称)',
  `trans_mode` VARCHAR(2) COMMENT '成交方式代码',
  `trans_mode_name` VARCHAR(75) COMMENT '成交方式名称',
  `bgdsbrq` DATETIME COMMENT '报关单申报日期',
  UNIQUE KEY `IDX_EDOC_ENTRY_MAIN_NE` (`NSRSBH`, `ENTRY_ID`),
  CONSTRAINT `PK_EDOC_ENTRY_MAIN` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口业务明细表';

-- Creating table EDOC_EXAMINE_BUSINESS
-- Original Oracle primary-key constraint: PK_EDOC_EXAMINE_BUSINESS (MySQL index name: PRIMARY).
CREATE TABLE `EDOC_EXAMINE_BUSINESS` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键',
  `nsrsbh` VARCHAR(21) NOT NULL COMMENT '纳税人识别号',
  `nsrmc` VARCHAR(100) NOT NULL COMMENT '纳税人名称',
  `qyhgdm` VARCHAR(20) NOT NULL COMMENT '企业海关代码',
  `swjgdm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `qylx` CHAR(1) NOT NULL COMMENT '企业类型  1:内资生产企业  2:
外商投资企业
3:外贸（工贸）企业
 9:其他（特许退税）企业',
  `flglcd` CHAR(1) COMMENT '分类管理登记(A、B、C、D)',
  `balx` CHAR(1) DEFAULT '0' COMMENT '备案类型  0-数字化备案 1-纸质备案',
  `status` CHAR(1) NOT NULL DEFAULT '0' COMMENT '状态  0-未下达 1-已下达(已退回)，2，已收讫， 3-已上报，4-已审核',
  `releaser` VARCHAR(30) COMMENT '下达人',
  `release_time` DATETIME(6) COMMENT '下达时间  yyyy-mm-dd hh:mm:ss',
  `report_time` DATETIME(6) COMMENT '上报时间 yyyy-mm-dd hh:mm:ss',
  `overdule` DATETIME COMMENT '逾期时间 yyyy-mm-dd',
  `examiner` VARCHAR(30) COMMENT '审核人',
  `examine_time` DATETIME(6) COMMENT '审核时间 yyyy-mm-dd hh:mm:ss',
  `examine_result` CHAR(1) COMMENT '审核结论 （0-暂未发现问题、1-检查有问题）',
  `examine_note` VARCHAR(500) COMMENT '审核意见',
  `back_count` DECIMAL(6,0) DEFAULT 0 COMMENT '退回次数',
  `back_reason` VARCHAR(500) COMMENT '退回原因',
  `sbywzl` VARCHAR(10) NOT NULL COMMENT '申报业务种类',
  `sbnypc` VARCHAR(15) NOT NULL COMMENT '申报年月批次  比如202201-001',
  `sbrq` DATETIME COMMENT '申报日期  yyyy-mm',
  `entry_id` VARCHAR(18) NOT NULL COMMENT '18位出口报关单号或代理证明号',
  `ywlx_code` VARCHAR(30) COMMENT '业务类型代码，以逗号隔开',
  `ckfp_no` VARCHAR(3000) COMMENT '出口发票号码，以逗号隔开',
  `jhfp_no` VARCHAR(3000) COMMENT '进项发票号码，以逗号隔开',
  `je` DECIMAL(15,2) COMMENT '出口销售额-FOB价(美元)',
  `se` DECIMAL(15,2) COMMENT '申报退免税额',
  `yjsl` DECIMAL(6,0) DEFAULT 0 COMMENT '预警数量   N:标识有N条三新预警，关联三新预警表',
  `skclbz` CHAR(1) COMMENT '收款处理标志 1不予退税2已退税返纳，空表示不处理',
  `skclje` DECIMAL(15,2) COMMENT '收款处理金额',
  `lxr` VARCHAR(150) COMMENT '联系人',
  `lxdh` VARCHAR(30) COMMENT '联系电话',
  `range` VARCHAR(500) COMMENT '单证核查范围,以json方式存储',
  `void_flag` CHAR(1) DEFAULT '0' COMMENT '作废标志 0:未作废  1:已作废',
  `voider` VARCHAR(30) COMMENT '作废人',
  `void_time` DATETIME(6) COMMENT '作废时间 yyyy-mm-dd hh:mm:ss',
  `cjsj` DATETIME(6) NOT NULL DEFAULT (CAST(CURRENT_TIMESTAMP(0) AS DATETIME)) COMMENT '创建时间 yyyy-mm-dd hh:mm:ss',
  `xgsj` DATETIME(6) COMMENT '修改时间 yyyy-mm-dd hh:mm:ss',
  `note` VARCHAR(500) COMMENT '备注',
  `tsjsfs_chg` CHAR(1) COMMENT '退税计算方式变更,当不为空的时候代表企业变更前退税计算方式，否则默认为现有的退税计算方式',
  `dzqqbz` CHAR(1) COMMENT '单证齐全标志 0-未齐全 1-已齐全',
  KEY `IDX_EDOC_EXAMINE_BUSINESS_NE` (`NSRSBH`, `ENTRY_ID`),
  KEY `IDX_EDOC_EXAMINE_BUSINESS_SJ` (`RELEASE_TIME`, `REPORT_TIME`, `OVERDULE`),
  KEY `IDX_EDOC_EXAMINE_BUSINESS_SWJG` (`SWJGDM`),
  UNIQUE KEY `UDX_EXAMINE_BUSINESS_NSSE` (`NSRSBH`, `SBYWZL`, `SBNYPC`, `ENTRY_ID`),
  CONSTRAINT `PK_EDOC_EXAMINE_BUSINESS` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='单证核查出口业务表';

-- Creating table EDOC_FILE_INFO
-- Original Oracle primary-key constraint: EDOC_FILE_INFO_PRIMARYKEY (MySQL index name: PRIMARY).
CREATE TABLE `EDOC_FILE_INFO` (
  `edoc_id` DECIMAL(20,0) NOT NULL COMMENT '单证文件id，主键',
  `edoc_name` VARCHAR(300) COMMENT '文件名称（默认使用单证类型中文拼接业务代码+申报年月+批次，企业可修改）',
  `edoc_type` VARCHAR(10) NOT NULL COMMENT '单证类型',
  `md5` VARCHAR(40) COMMENT 'MD5（存储文件的MD5值，以校验文档是否发生变动）
',
  `edoc_no` VARCHAR(64) COMMENT '单证号码',
  `edoc_size` VARCHAR(255) COMMENT '文件大小，单位K',
  `edoc_path` VARCHAR(255) COMMENT '文件路径',
  `edoc_local_path` VARCHAR(255) COMMENT '本地路径',
  `crtime` DATETIME(6) COMMENT '创建日期',
  `uptime` DATETIME(6) COMMENT '修改日期',
  `sign_status` CHAR(1) COMMENT '签名状态.0-未加签,1-已加签',
  `use_number` DECIMAL(38,0) COMMENT '引用次数',
  `remark` VARCHAR(255) COMMENT '备注',
  `fill_date` DATETIME COMMENT '验证日期',
  CONSTRAINT `EDOC_FILE_INFO_PRIMARYKEY` PRIMARY KEY (`EDOC_ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='单证文件信息表';

-- Creating table EDOC_INDEX_RANGE
-- Original Oracle primary-key constraint: EDOC_INDEX_RANGE_PK (MySQL index name: PRIMARY).
CREATE TABLE `EDOC_INDEX_RANGE` (
  `id` DECIMAL(20,0) NOT NULL,
  `baxh` VARCHAR(36) NOT NULL COMMENT '备案序号，对应edoc_record_task表中的baxh',
  `nsrsbh` VARCHAR(21) COMMENT '纳税人识别号',
  `dzdl` CHAR(1) NOT NULL COMMENT '单证大类 1-备案单证，2-申报单证，3-其他单证',
  `edoc_type` VARCHAR(36) NOT NULL COMMENT '单证类型',
  `edoc_flag` CHAR(1) NOT NULL COMMENT '单证标志 0-必备 1-市县局要求必备 2-非必备',
  `crtime` DATETIME(6) NOT NULL COMMENT '创建时间',
  KEY `IDX_EDOC_INDEX_RANGE_BAXH` (`BAXH`),
  CONSTRAINT `EDOC_INDEX_RANGE_PK` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='单证索引范围表';

-- Creating table EDOC_INSPECT_BACK
-- Original Oracle primary-key constraint: PK_EDOC_INSPECT_BACK (MySQL index name: PRIMARY).
CREATE TABLE `EDOC_INSPECT_BACK` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '记录id',
  `hclx` CHAR(1) NOT NULL COMMENT '核查类型(1:日常审单核查  2:年度单证核查)',
  `inspect_no` DECIMAL(20,0) NOT NULL COMMENT '日常审单对应edoc_examine_business表主键, 年度单证核查对应edoc_inspect_business表主键',
  `nsrsbh` VARCHAR(21) NOT NULL COMMENT '税号',
  `entry_id` VARCHAR(18) NOT NULL COMMENT '报关单号',
  `returnee` VARCHAR(30) COMMENT '退回人',
  `back_reason` VARCHAR(500) COMMENT '退回原因',
  `back_time` DATETIME(6) COMMENT '退回时间',
  `cjsj` DATETIME(6) COMMENT '创建时间',
  `xgsj` DATETIME(6) COMMENT '修改时间',
  KEY `IDX_EDOC_INSPECT_BACK_HI` (`HCLX`, `INSPECT_NO`),
  CONSTRAINT `PK_EDOC_INSPECT_BACK` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='核查任务退回表(日常审单、年度核查)';

-- Creating table EDOC_INSPECT_BACK_INDEX
-- Original Oracle primary-key constraint: PK_EDOC_INSPECT_BACK_INDEX (MySQL index name: PRIMARY).
CREATE TABLE `EDOC_INSPECT_BACK_INDEX` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '记录id',
  `back_id` DECIMAL(20,0) NOT NULL COMMENT '核查任务退回表edoc_inspect_back主键',
  `edoc_type` VARCHAR(10) COMMENT '单证类型',
  `dzdl` VARCHAR(36) COMMENT '单证大类(1、备案单证 2、申报单证 3、其它单证)',
  `edoc_type_sub` VARCHAR(10) COMMENT '单证详细类型',
  `edoc_id` DECIMAL(20,0) COMMENT '单证文件id',
  `edoc_state` VARCHAR(600) COMMENT '单证说明',
  `edoc_flag` CHAR(1) COMMENT '单证标志(0-必备   1-市县局 要求必备 2-非必备)',
  `edoc_name` VARCHAR(300) COMMENT '文件名称',
  `edoc_no` VARCHAR(64) COMMENT '单证号码',
  `file_url` VARCHAR(1000) COMMENT '文件存储oss路径',
  `remark` VARCHAR(255) COMMENT '备注',
  `cjsj` DATETIME(6) COMMENT '创建时间',
  `xgsj` DATETIME(6) COMMENT '修改时间',
  KEY `IDX_INSPECT_BACK_INDEX` (`BACK_ID`),
  CONSTRAINT `PK_EDOC_INSPECT_BACK_INDEX` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='核查任务退回索引表';

-- Creating table EDOC_INSPECT_BUSINESS
-- Original Oracle primary-key constraint: PK_EDOC_INSPECT_BUSINESS (MySQL index name: PRIMARY).
CREATE TABLE `EDOC_INSPECT_BUSINESS` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键',
  `project_id` DECIMAL(20,0) NOT NULL COMMENT '单证核查立项表主键id',
  `status` CHAR(1) NOT NULL DEFAULT '0' COMMENT '状态  0-创建 1-已下达(已退回)，2，已收讫， 3-已上报，4-已审核',
  `sbywzl` VARCHAR(10) NOT NULL COMMENT '申报业务种类',
  `sbnypc` VARCHAR(15) NOT NULL COMMENT '申报年月批次',
  `sbrq` DATETIME NOT NULL COMMENT '申报日期 yyyy-mm-dd',
  `entry_id` VARCHAR(18) NOT NULL COMMENT '18位报关单号/代理证明号',
  `ywlx_code` VARCHAR(30) COMMENT '业务类型代码',
  `je` DECIMAL(15,2) COMMENT '出口销售额-FOB价(美元)',
  `se` DECIMAL(15,2) COMMENT '申报退免税额',
  `releaser` VARCHAR(30) COMMENT '下达人',
  `release_time` DATETIME(6) COMMENT '下达时间  yyyy-mm-dd hh:mm:ss',
  `report_time` DATETIME(6) COMMENT '上报时间 yyyy-mm-dd hh:mm:ss',
  `examiner` VARCHAR(30) COMMENT '审核人',
  `examine_time` DATETIME(6) COMMENT '审核时间 yyyy-mm-dd hh:mm:ss',
  `examine_result` CHAR(1) COMMENT '审核结论 0暂未发现问题/1检查有问题',
  `examine_note` VARCHAR(500) COMMENT '审核意见',
  `returnee` VARCHAR(30) COMMENT '退回人',
  `back_time` DATETIME(6) COMMENT '退回时间 yyyy-mm-dd hh:mm:ss',
  `back_count` DECIMAL(6,0) DEFAULT 0 COMMENT '退回次数  仅允许退回补正依次，取值0、1',
  `range` VARCHAR(500) COMMENT '单证核查范围',
  `skclbz` CHAR(1) COMMENT '收款处理标志  1不予退税2已退税返纳，空表示不处理',
  `skclje` DECIMAL(15,2) COMMENT '收款处理金额',
  `cjsj` DATETIME(6) NOT NULL DEFAULT (CAST(CURRENT_TIMESTAMP(0) AS DATETIME)) COMMENT '创建时间 yyyy-mm-dd hh:mm:ss',
  `xgsj` DATETIME(6) COMMENT '修改时间 yyyy-mm-dd hh:mm:ss',
  `note` VARCHAR(500) COMMENT '备注',
  `back_reason` VARCHAR(1000) COMMENT '退回原因',
  `dzqqbz` CHAR(1) COMMENT '单证齐全标志 0-未齐全 1-已齐全',
  KEY `IDX_EDOC_INSPECT_BUSINESS_PID` (`PROJECT_ID`),
  KEY `IDX_INSPECT_BUSINESS_ENTRYID` (`ENTRY_ID`),
  UNIQUE KEY `UDX_EDOC_INSPECT_BUSINESS_PSSE` (`PROJECT_ID`, `SBYWZL`, `SBNYPC`, `ENTRY_ID`),
  CONSTRAINT `PK_EDOC_INSPECT_BUSINESS` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='单证核查出口业务表';

-- Creating table EDOC_INSPECT_CONFIGURE
-- Original Oracle primary-key constraint: PK_EDOC_INSPECT_CONFIGURE (MySQL index name: PRIMARY).
CREATE TABLE `EDOC_INSPECT_CONFIGURE` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键',
  `swjgdm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `config_type` CHAR(2) NOT NULL COMMENT '配置类型 01:企业抽查比例  02:出口业务抽查比例 03:最大业务抽查数 04:意向的商品代码 05:敏感贸易国 06:FOB价起点',
  `config_value` LONGTEXT COMMENT '配置内容',
  `config_extend` LONGTEXT COMMENT '扩展内容',
  `cjsj` DATETIME(6) DEFAULT (CAST(CURRENT_TIMESTAMP(0) AS DATETIME)) COMMENT '创建时间',
  `xgsj` DATETIME(6) COMMENT '更新时间',
  `note` VARCHAR(200) COMMENT '备注',
  UNIQUE KEY `UDX_INSPECT_CONFIGURE_ST` (`SWJGDM`, `CONFIG_TYPE`),
  CONSTRAINT `PK_EDOC_INSPECT_CONFIGURE` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='单证核查基础配置表';

-- Creating table EDOC_INSPECT_INTENTION
-- Original Oracle primary-key constraint: PK_EDOC_INSPECT_INTENTION (MySQL index name: PRIMARY).
CREATE TABLE `EDOC_INSPECT_INTENTION` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键',
  `nsrsbh` VARCHAR(21) NOT NULL COMMENT '纳税人识别号 0表示通用',
  `spdm` LONGTEXT COMMENT '意向商品代码',
  `mygjdq` LONGTEXT COMMENT '意向贸易国家及地区',
  `fobqd` DECIMAL(15,2) COMMENT 'FOB价起点',
  `cjsj` DATETIME(6) DEFAULT (CAST(CURRENT_TIMESTAMP(0) AS DATETIME)) COMMENT '创建时间',
  `xgsj` DATETIME(6) COMMENT '更新时间',
  `note` VARCHAR(200) COMMENT '备注',
  KEY `IDX_INSPECT_INTENTION_NSRSBH` (`NSRSBH`),
  CONSTRAINT `PK_EDOC_INSPECT_INTENTION` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='单证核查项目意向关系表';

-- Creating table EDOC_INSPECT_NOTICE
-- Original Oracle primary-key constraint: PK_EDOC_INSPECT_NOTICE (MySQL index name: PRIMARY).
-- Auxiliary UNIQUE index IDX_EDOC_INSPECT_NOTICE_ORACLE_NULLS preserves Oracle composite-UNIQUE NULL behavior: duplicate partially-NULL keys are rejected; wholly-NULL keys remain allowed. NULL flags prevent sentinel collisions; original named UNIQUE key is kept.
CREATE TABLE `EDOC_INSPECT_NOTICE` (
  `id` DECIMAL(18,0) NOT NULL,
  `inspect_no` DECIMAL(20,0) COMMENT '核查序号，对应edoc_inspect_task表主键',
  `swjg_dm` VARCHAR(11) COMMENT '税务机关代码',
  `wslx` VARCHAR(20) COMMENT '文书类型',
  `nd` VARCHAR(4) COMMENT '年度',
  `bh` VARCHAR(10) COMMENT '编号',
  `zg` VARCHAR(50) COMMENT '文书字轨',
  `cjsj` DATETIME(6) COMMENT '创建时间',
  `cjr` VARCHAR(20) COMMENT '创建人',
  `xdsj` DATETIME(6) COMMENT '下达时间',
  `xdr` VARCHAR(20) COMMENT '下达人',
  `hzsj` DATETIME(6) COMMENT '回执时间',
  `hznsr` VARCHAR(20) COMMENT '回执纳税人',
  `noticeid` DECIMAL(18,0) COMMENT '通知id(对应fg_notice_qy_sync2yun表的主键)',
  `attachid` DECIMAL(18,0) COMMENT '附件id(对应fg_notice_qy_attach)',
  UNIQUE KEY `IDX_EDOC_INSPECT_NOTICE` (`SWJG_DM`, `WSLX`, `ND`, `BH`),
  CONSTRAINT `PK_EDOC_INSPECT_NOTICE` PRIMARY KEY (`ID`),
  UNIQUE KEY `IDX_EDOC_INSPECT_NOTICE_ORACLE_NULLS` ((IF(`swjg_dm` IS NULL AND `wslx` IS NULL AND `nd` IS NULL AND `bh` IS NULL, NULL, 1)), (COALESCE(`swjg_dm`, '')), (`swjg_dm` IS NULL), (COALESCE(`wslx`, '')), (`wslx` IS NULL), (COALESCE(`nd`, '')), (`nd` IS NULL), (COALESCE(`bh`, '')), (`bh` IS NULL))
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='税务事项通知书';

-- Creating table EDOC_INSPECT_PROJECT
-- Original Oracle primary-key constraint: PK_EDOC_INSPECT_PROJECT (MySQL index name: PRIMARY).
-- Auxiliary UNIQUE index UDX_INSPECT_PROJECT_NYV_ORACLE_NULLS preserves Oracle composite-UNIQUE NULL behavior: duplicate partially-NULL keys are rejected; wholly-NULL keys remain allowed. NULL flags prevent sentinel collisions; original named UNIQUE key is kept.
CREATE TABLE `EDOC_INSPECT_PROJECT` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键',
  `nsrsbh` VARCHAR(21) NOT NULL COMMENT '纳税人识别号',
  `nsrmc` VARCHAR(100) NOT NULL COMMENT '纳税人名称',
  `qyhgdm` VARCHAR(20) NOT NULL COMMENT '企业海关代码',
  `swjgdm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `qylx` CHAR(1) NOT NULL COMMENT '企业类型  1:内资生产企业  2:
外商投资企业
3:外贸（工贸）企业
 9:其他（特许退税）企业',
  `flglcd` CHAR(1) NOT NULL COMMENT '分类管理等级(A、B、C、D)',
  `balx` CHAR(1) DEFAULT '0' COMMENT '备案类型  0-数字化备案 1-纸质备案',
  `year` VARCHAR(4) NOT NULL COMMENT '立项年度',
  `source` CHAR(1) DEFAULT '0' COMMENT '项目来源   0 指定 1随机',
  `status` CHAR(1) NOT NULL DEFAULT '0' COMMENT '项目状态  0 创建、1 审核、2复核、3发放、9结案',
  `approve_time` DATETIME(6) COMMENT '立项日期   yyyy-mm-dd hh:mm:ss',
  `deadline` DATETIME COMMENT '项目期限 yyyy-mm-dd ',
  `ywbs` DECIMAL(6,0) COMMENT '业务笔数',
  `inspector` VARCHAR(30) COMMENT '审核人',
  `inspect_time` DATETIME(6) COMMENT '核查完成日期 yyyy-mm-dd hh:mm:ss',
  `inspect_note` VARCHAR(500) COMMENT '核查意见',
  `project_result` CHAR(1) COMMENT '项目结论  1合格2整改后合格3不合格',
  `reviewer` VARCHAR(30) COMMENT '复核人',
  `review_time` DATETIME(6) COMMENT '复核日期',
  `review_note` VARCHAR(500) COMMENT '复核意见',
  `issuer` VARCHAR(30) COMMENT '发放人',
  `issue_time` DATETIME(6) COMMENT '发放日期 yyyy-mm-dd hh:mm:ss',
  `void_flag` CHAR(1) DEFAULT '0' COMMENT '作废标志 0: 正常  1:作废',
  `voider` VARCHAR(30) COMMENT '作废人',
  `void_time` DATETIME(6) COMMENT '作废时间',
  `receipt_flag` CHAR(1) DEFAULT '0' COMMENT '回证标志 0-未回证 1-已回证',
  `receipt_time` DATETIME(6) COMMENT '回证时间 yyyy-mm-dd hh:mm:ss',
  `qygm` VARCHAR(2) COMMENT '企业规模',
  `ywccbl` DECIMAL(15,2) COMMENT '业务抽查比例',
  `lxr` VARCHAR(40) COMMENT '联系人',
  `lxdh` VARCHAR(30) COMMENT '联系电话',
  `cjsj` DATETIME(6) NOT NULL DEFAULT (CAST(CURRENT_TIMESTAMP(0) AS DATETIME)) COMMENT '创建时间',
  `xgsj` DATETIME(6) COMMENT '修改时间',
  `note` VARCHAR(500) COMMENT '备注',
  KEY `IDX_INSPECT_PROJECT_RN` (`REVIEW_NOTE`),
  UNIQUE KEY `UDX_INSPECT_PROJECT_NYV` (`NSRSBH`, `YEAR`, `VOID_FLAG`),
  CONSTRAINT `PK_EDOC_INSPECT_PROJECT` PRIMARY KEY (`ID`),
  UNIQUE KEY `UDX_INSPECT_PROJECT_NYV_ORACLE_NULLS` (`nsrsbh`, `year`, (COALESCE(`void_flag`, '')), (`void_flag` IS NULL))
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='单证核查项目表';

-- Creating table EDOC_INSPECT_PROJECT_DEL
-- Original Oracle primary-key constraint: PK_EDOC_INSPECT_PROJECT_DEL (MySQL index name: PRIMARY).
CREATE TABLE `EDOC_INSPECT_PROJECT_DEL` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键',
  `nsrsbh` VARCHAR(21) NOT NULL COMMENT '纳税人识别号',
  `nsrmc` VARCHAR(100) NOT NULL COMMENT '纳税人名称',
  `qyhgdm` VARCHAR(20) NOT NULL COMMENT '企业海关代码',
  `swjgdm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `qylx` CHAR(1) NOT NULL COMMENT '企业类型  1:内资生产企业  2:
外商投资企业
3:外贸（工贸）企业
 9:其他（特许退税）企业',
  `flglcd` CHAR(1) NOT NULL COMMENT '分类管理等级(A、B、C、D)',
  `balx` CHAR(1) COMMENT '备案类型  0-数字化备案 1-纸质备案',
  `year` VARCHAR(4) NOT NULL COMMENT '立项年度',
  `source` CHAR(1) COMMENT '项目来源   0 指定 1随机',
  `status` CHAR(1) NOT NULL COMMENT '项目状态  0 创建、1 审核、2复核、3发放、9结案',
  `approve_time` DATETIME(6) COMMENT '立项日期   yyyy-mm-dd hh:mm:ss',
  `deadline` DATETIME COMMENT '项目期限 yyyy-mm-dd ',
  `ywbs` DECIMAL(6,0) COMMENT '业务笔数',
  `inspector` VARCHAR(30) COMMENT '审核人',
  `inspect_time` DATETIME(6) COMMENT '核查完成日期 yyyy-mm-dd hh:mm:ss',
  `inspect_note` VARCHAR(500) COMMENT '核查意见',
  `project_result` CHAR(1) COMMENT '项目结论  1合格2整改后合格3不合格',
  `reviewer` VARCHAR(30) COMMENT '复核人',
  `review_time` DATETIME(6) COMMENT '复核日期',
  `review_note` VARCHAR(500) COMMENT '复核意见',
  `issuer` VARCHAR(30) COMMENT '发放人',
  `issue_time` DATETIME(6) COMMENT '发放日期 yyyy-mm-dd hh:mm:ss',
  `void_flag` CHAR(1) COMMENT '作废标志 0: 正常  1:作废',
  `voider` VARCHAR(30) COMMENT '作废人',
  `void_time` DATETIME(6) COMMENT '作废时间',
  `receipt_flag` CHAR(1) COMMENT '回证标志 0-未回证 1-已回证',
  `receipt_time` DATETIME(6) COMMENT '回证时间 yyyy-mm-dd hh:mm:ss',
  `qygm` VARCHAR(2) COMMENT '企业规模',
  `ywccbl` DECIMAL(15,2) COMMENT '业务抽查比例',
  `lxr` VARCHAR(30) COMMENT '联系人',
  `lxdh` VARCHAR(30) COMMENT '联系电话',
  `cjsj` DATETIME(6) NOT NULL COMMENT '创建时间',
  `xgsj` DATETIME(6) COMMENT '修改时间',
  `note` VARCHAR(500) COMMENT '备注',
  CONSTRAINT `PK_EDOC_INSPECT_PROJECT_DEL` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='单证核查项目作废表';

-- Creating table EDOC_INSPECT_SUMMARY
-- Original Oracle primary-key constraint: PK_EDOC_INSPECT_SUMMARY (MySQL index name: PRIMARY).
CREATE TABLE `EDOC_INSPECT_SUMMARY` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键',
  `nsrsbh` VARCHAR(21) NOT NULL COMMENT '纳税人识别号',
  `swjgdm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `qylx` CHAR(1) COMMENT '企业类型',
  `year` CHAR(4) NOT NULL COMMENT '年度',
  `bgd_count` DECIMAL(6,0) COMMENT '报关单量',
  `sbpc_count` DECIMAL(6,0) COMMENT '申报批次数',
  `je_total` DECIMAL(15,2) COMMENT '申报总金额（美元）',
  `se_total` DECIMAL(15,2) COMMENT '退免税总额',
  `qygm` VARCHAR(2) COMMENT '企业规模',
  `cjsj` DATETIME(6) DEFAULT (CAST(CURRENT_TIMESTAMP(0) AS DATETIME)) COMMENT '创建时间',
  `xgsj` DATETIME(6) COMMENT '更新时间',
  `note` VARCHAR(200) COMMENT '备注',
  UNIQUE KEY `UDX_INSPECT_SUMMARY_NY` (`NSRSBH`, `YEAR`),
  CONSTRAINT `PK_EDOC_INSPECT_SUMMARY` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='企业年度申报汇总信息表';

-- Creating table EDOC_INSPECT_TASK
-- Original Oracle primary-key constraint: EDOC_INSPECT_TASK_PRIMARYKEY (MySQL index name: PRIMARY).
-- Original schema-qualified index: TL_BJTS.IDX_EDOC_INSPECT_TASK_NSRSBH; MySQL indexes belong to the current table/database.
CREATE TABLE `EDOC_INSPECT_TASK` (
  `inspect_no` DECIMAL(20,0) NOT NULL COMMENT '核查序号 ，主键',
  `nsrsbh` VARCHAR(21) NOT NULL COMMENT '纳税人识别号',
  `nsrmc` VARCHAR(100) NOT NULL COMMENT '纳税人名称',
  `custom_code` VARCHAR(20) NOT NULL COMMENT '海关代码',
  `release_time` DATETIME(6) COMMENT '下达日期',
  `deadline` DATETIME COMMENT '资料报送期限',
  `inspect_state` VARCHAR(500) COMMENT '核查说明',
  `status` CHAR(1) NOT NULL COMMENT '状态   0-未下达 1-已下达，2，已收讫， 3-已上报，4-已审核',
  `inspect_result` VARCHAR(2) COMMENT '核查结论10-正常  20-异常  为了便于扩展，以后以1开头的都代表正常 ，2开头代表异常 ，比如(21，22，23等，表示异常范围内的不同类型)',
  `inspect_time` DATETIME(6) COMMENT '核查日期 yyyy-mm-dd hh:mm:ss',
  `report_time` DATETIME(6) COMMENT '上报时间yyyy-mm-dd hh:mm:ss',
  `create_time` DATETIME(6) NOT NULL COMMENT '创建时间',
  `inspect_type` CHAR(1) COMMENT '核查类型 1：核查（只需备案单证） 2、审单（全部单证）',
  `self_check` CHAR(1) COMMENT '自查表标志(预留) 是否（Y/N） 是-要求企业填写其他类中的自查表',
  `range` VARCHAR(500) COMMENT '单证类型范围，以逗号隔开，值为单证类型代码',
  `releaser` VARCHAR(25) COMMENT '下达人',
  `tax_notice` LONGTEXT COMMENT '税务事项通知书',
  `remark` VARCHAR(500) COMMENT '备注',
  `withdraw_count` DECIMAL(6,0) DEFAULT 0 COMMENT '返回的次数(当status=1,withdraw_count=0时，前端展示已下达，当status=1,withdraw_count>0时，前端展示已退回)',
  KEY `IDX_EDOC_INSPECT_TASK_NSRSBH` (`NSRSBH`),
  CONSTRAINT `EDOC_INSPECT_TASK_PRIMARYKEY` PRIMARY KEY (`INSPECT_NO`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='单证核查任务表';

-- Creating table EDOC_INSPECT_TASK_MX
-- Original Oracle primary-key constraint: EDOC_INSPECT_PRIMARYKEY (MySQL index name: PRIMARY).
CREATE TABLE `EDOC_INSPECT_TASK_MX` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键',
  `inspect_no` DECIMAL(20,0) NOT NULL COMMENT '核查序号',
  `sbnypc` VARCHAR(36) NOT NULL COMMENT '申报年月批次',
  `sbrq` DATETIME COMMENT '申报日期',
  `entry_id` VARCHAR(18) COMMENT '18位报关单号或者代理证明号',
  `inspect_result` VARCHAR(1) NOT NULL COMMENT '核查结果,0-待审核，1-通过，2-不通过',
  `result_state` VARCHAR(500) COMMENT '结果说明',
  `inspector` VARCHAR(30) COMMENT '审核人',
  `examine_time` DATETIME(6) COMMENT '审核时间',
  `process_type` CHAR(2) COMMENT '处理类型',
  `sbywzl` VARCHAR(36) COMMENT '申报业务种类',
  `ckfp_no` VARCHAR(3000) COMMENT '出口发票',
  `jhfp_no` VARCHAR(3000) COMMENT '进货发票',
  `je` DECIMAL(15,2) COMMENT '金额',
  `se` DECIMAL(15,2) COMMENT '税额',
  `choice_flag` CHAR(1) COMMENT '已选标志(0-可选  1-已选)',
  `slrq` DATETIME COMMENT '受理日期',
  UNIQUE KEY `UIDX_EDOC_INSPECT_MX_INSPECT` (`INSPECT_NO`),
  CONSTRAINT `EDOC_INSPECT_PRIMARYKEY` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='核查任务子表';

-- Creating table EDOC_RECORD_TASK
-- Original Oracle primary-key constraint: EDOC_RECORD_TASK_PRIMARYKEY (MySQL index name: PRIMARY).
CREATE TABLE `EDOC_RECORD_TASK` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键id',
  `nsrsbh` VARCHAR(21) NOT NULL COMMENT '纳税人识别号',
  `baxh` VARCHAR(36) NOT NULL COMMENT '备案序号由本系统生成，可采用UUID，与单证备案目录关联',
  `sbywzl` VARCHAR(15) NOT NULL COMMENT '申报业务种类',
  `sbnypc` VARCHAR(36) NOT NULL COMMENT '申报年月批次',
  `sbrq` DATETIME NOT NULL COMMENT '申报日期',
  `ddrq` DATETIME COMMENT '接收到备案任务的日期',
  `slrq` DATETIME COMMENT '出具受理通知书日期',
  `baqx` DATETIME COMMENT '备案期限（yyyy-mm-dd）',
  `bazt` CHAR(1) NOT NULL COMMENT '备案状态。1-待备案，2-备案中，3-备案完成',
  `basj` DATETIME(6) COMMENT '备案时间（即归档时间）',
  `je_total` DECIMAL(15,2) COMMENT '总金额',
  `se_total` DECIMAL(15,2) COMMENT '总税额',
  `creat_time` DATETIME(6) COMMENT '创建时间',
  `sbqx` DATETIME COMMENT '上报期限',
  `ckywbs` DECIMAL(6,0) COMMENT '出口业务笔数',
  `dzfs` DECIMAL(6,0) COMMENT '单证份数',
  CONSTRAINT `EDOC_RECORD_TASK_PRIMARYKEY` PRIMARY KEY (`ID`),
  CONSTRAINT `IDX_EDOC_RECORD_TASK_NSS` UNIQUE (`NSRSBH`, `SBYWZL`, `SBNYPC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='单证备案任务表';

-- Creating table EDOC_RECORD_TRIGGER
-- Original Oracle primary-key constraint: EDOC_RECORD_TRIGGER (MySQL index name: PRIMARY).
CREATE TABLE `EDOC_RECORD_TRIGGER` (
  `sbid` DECIMAL(18,0) NOT NULL COMMENT 'sb_sbxx_hz表主键',
  `tqbz` VARCHAR(40) COMMENT '提取标志',
  `tqsj` DATETIME(6) COMMENT '提取时间',
  `tqcs` DECIMAL(10,0) COMMENT '提取次数',
  `bz` VARCHAR(500) COMMENT '备注',
  `cjsj` DATETIME(6) COMMENT '创建时间',
  `type` CHAR(2) COMMENT '触发类型(10-生成备案任务 20-申报撤回)',
  CONSTRAINT `EDOC_RECORD_TRIGGER` PRIMARY KEY (`SBID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='生成备案任务触发表（触发器产生）';

-- Creating table EDOC_RECORD_TRIGGER_JS
-- Original Oracle primary-key constraint: PK_EDOC_RECORD_TRIGGER_HIS (MySQL index name: PRIMARY).
CREATE TABLE `EDOC_RECORD_TRIGGER_JS` (
  `busikey` VARCHAR(50) NOT NULL COMMENT '业务主键(规范:税号|申报业务种类|所属时期|申报批次)',
  `tqbz` VARCHAR(40) COMMENT '提取标志',
  `tqsj` DATETIME(6) COMMENT '提取时间',
  `tqcs` DECIMAL(6,0) DEFAULT 0 COMMENT '提取次数',
  `sjly` CHAR(1) NOT NULL DEFAULT '0' COMMENT '数据来源   0:bjts触发产生  1:同步历史备案任务',
  `bz` VARCHAR(500) COMMENT '备注',
  `cjsj` DATETIME(6) DEFAULT (CAST(CURRENT_TIMESTAMP(0) AS DATETIME)) COMMENT '创建时间',
  `lcslid` VARCHAR(32) COMMENT '流程实例ID',
  CONSTRAINT `PK_EDOC_RECORD_TRIGGER_HIS` PRIMARY KEY (`BUSIKEY`, `SJLY`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='备案任务触发-从金三获取数据';

-- Creating table EDOC_RECORD_TRIGGER_RESULT
-- Original Oracle primary-key constraint: PK_TRIGGER_JS_ERROR (MySQL index name: PRIMARY).
CREATE TABLE `EDOC_RECORD_TRIGGER_RESULT` (
  `busikey` VARCHAR(50) NOT NULL COMMENT '业务主键(规范:税号|申报业务种类|所属时期|申报批次)',
  `cljg` CHAR(1) COMMENT '处理结果 0-成功、1-失败',
  `msg` VARCHAR(3000) COMMENT '失败时填入信息',
  `cjsj` DATETIME(6) COMMENT '创建时间',
  `xgsj` DATETIME(6) COMMENT '修改时间',
  `sjly` CHAR(1) COMMENT '数据来源,  空,0或者1为老版便捷退税触发器产生   2-自动轮询金三数据',
  `lcslid` VARCHAR(32) COMMENT '流程实例ID',
  CONSTRAINT `PK_TRIGGER_JS_ERROR` PRIMARY KEY (`BUSIKEY`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='触发产生备案任务错误记录表(来自金三)';

-- Creating table EDOC_STORE
-- Original Oracle primary-key constraint: PK_EDOC_STORE (MySQL index name: PRIMARY).
CREATE TABLE `EDOC_STORE` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键',
  `mainid` DECIMAL(20,0) NOT NULL COMMENT '对应存储对象表的主键',
  `type` CHAR(3) NOT NULL COMMENT '类型(001:年度单证核查-税务事项通知书)',
  `record` LONGTEXT COMMENT '存储的记录(以base64编码存储)',
  `cjsj` DATETIME(6) NOT NULL DEFAULT (CAST(CURRENT_TIMESTAMP(0) AS DATETIME)) COMMENT '创建时间',
  `xgsj` DATETIME(6) COMMENT '修改时间',
  `file_path` VARCHAR(1000) COMMENT '文件相对路径',
  UNIQUE KEY `UDX_EDOC_STORE_MT` (`MAINID`, `TYPE`),
  CONSTRAINT `PK_EDOC_STORE` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='单证备案存储大对象表';

-- Creating table EDOC_YJXX_DATA
-- Original Oracle primary-key constraint: PK_EDOC_YJXX_DATA (MySQL index name: PRIMARY).
-- Auxiliary UNIQUE index UDX_EDOC_YJXX_DATA_ORACLE_NULLS preserves Oracle composite-UNIQUE NULL behavior: duplicate partially-NULL keys are rejected; wholly-NULL keys remain allowed. NULL flags prevent sentinel collisions; original named UNIQUE key is kept.
CREATE TABLE `EDOC_YJXX_DATA` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键',
  `hx_id` DECIMAL(20,0) COMMENT '日常审单-出口业务表id',
  `hclx` CHAR(1) COMMENT '2-日常审单，冗余，默认2',
  `yj_sbid` DECIMAL(20,0) COMMENT '申报id  关联tl_admin.yj_data_yjxx的sbid+id',
  `yj_id` DECIMAL(20,0) COMMENT '预警信息id  关联tl_admin.yj_data_yjxx的sbid+id',
  `zbcode` VARCHAR(5) COMMENT '预警指标  10101 新增商品
10201 新增供货商
',
  `yj_record` VARCHAR(30) COMMENT '预警关联号 外贸存放关联号
生产存放申报序号
',
  `yj_object` VARCHAR(30) COMMENT '预警对象 商品代码
  供货商税号
',
  `yj_msg` VARCHAR(1000) COMMENT '预警描述',
  `yj_time` DATETIME(6) COMMENT '预警生成时间 ',
  `entry_id` VARCHAR(18) COMMENT '18位报关单号或代理证明号',
  KEY `IDX_EDOC_YJXX_DATA_HXID` (`HX_ID`),
  UNIQUE KEY `UDX_EDOC_YJXX_DATA` (`YJ_SBID`, `YJ_ID`),
  CONSTRAINT `PK_EDOC_YJXX_DATA` PRIMARY KEY (`ID`),
  UNIQUE KEY `UDX_EDOC_YJXX_DATA_ORACLE_NULLS` ((IF(`yj_sbid` IS NULL AND `yj_id` IS NULL, NULL, 1)), (COALESCE(`yj_sbid`, 0)), (`yj_sbid` IS NULL), (COALESCE(`yj_id`, 0)), (`yj_id` IS NULL))
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='单证预警信息表';

-- Creating table FG_BLQY_INFO
-- Original Oracle primary-key constraint: PK_FG_BLQY_INFO (MySQL index name: PRIMARY).
CREATE TABLE `FG_BLQY_INFO` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '主键',
  `qyhgdm` VARCHAR(20) NOT NULL COMMENT '海关代码',
  `nsrsbh` VARCHAR(21) NOT NULL COMMENT '纳税人识别号',
  `sjlx` VARCHAR(2) NOT NULL COMMENT '事件类型(1-函调
2-实地核查
3-稽查案件
4-评估核查
9-其他
)',
  `blxxnr` VARCHAR(200) COMMENT '不良信息内容',
  `lrr` VARCHAR(20) NOT NULL COMMENT '录入人',
  `lrrq` DATETIME NOT NULL COMMENT '录入日期',
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '录入人税务机关代码',
  `nsr_swjg_dm` VARCHAR(11) NOT NULL COMMENT '纳税人税务机关代码',
  `fxjb` VARCHAR(2) NOT NULL COMMENT '风险级别(1一级风险-低
2二级风险-中
3三级风险-高
)',
  `fxms` VARCHAR(200) COMMENT '风险描述',
  `rqq` DATETIME COMMENT '风险日期起',
  `rqz` DATETIME COMMENT '风险日期止',
  `yxbz` CHAR(1) NOT NULL COMMENT '有效标志(Y/N)',
  `bz` VARCHAR(200) COMMENT '备注',
  KEY `IDX_FG_BLQY_INFO_NSRSBH` (`NSRSBH`),
  KEY `IDX_FG_BLQY_INFO_QYHGDM` (`QYHGDM`),
  CONSTRAINT `PK_FG_BLQY_INFO` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='辅助管理--不良企业信息表';

-- Creating table FG_CKTSFN_DZ_JGB
-- Original Oracle primary-key constraint: PK_FG_CKTSFN_DZ_JGB (MySQL index name: PRIMARY).
-- Auxiliary UNIQUE index UQ_FG_CKTSFN_DZ_JGB_ORACLE_NULLS preserves Oracle composite-UNIQUE NULL behavior: duplicate partially-NULL keys are rejected; wholly-NULL keys remain allowed. NULL flags prevent sentinel collisions; original named UNIQUE key is kept.
CREATE TABLE `FG_CKTSFN_DZ_JGB` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '主键',
  `pzxh` VARCHAR(20) NOT NULL COMMENT '凭证序号',
  `zsxm_dm` VARCHAR(5) NOT NULL COMMENT '征收项目代码',
  `zg_uuid` VARCHAR(32),
  `sjly` CHAR(1) COMMENT '数据来源(2:TSTHS、
1:TSTHS_FN
)',
  `nsrsbh` VARCHAR(20) COMMENT '纳税人识别号',
  `nsrmc` VARCHAR(80) COMMENT '纳税人名称',
  `yt_amt` DECIMAL(16,2) COMMENT '应补缴增值税',
  `sb_ym` VARCHAR(6) COMMENT '申报年月',
  `sb_pc` VARCHAR(2) COMMENT '申报批次',
  `xh_flag` CHAR(1) COMMENT '销号标志',
  `xh_date` DATETIME COMMENT '销号日期',
  `op_date` DATETIME COMMENT '操作时间（出口）',
  `zg_se` DECIMAL(16,2) COMMENT '返纳税额（征管）',
  `zg_sjyjse` DECIMAL(16,2) COMMENT '实际应缴税额',
  `zg_rkse` DECIMAL(16,2) COMMENT '实际入库税额',
  `zg_op_date` DATETIME COMMENT '操作时间（征管）',
  `swjg_dm` VARCHAR(11) COMMENT '税务机关代码(出口或征管)',
  `dzjg` CHAR(1) COMMENT '对账结果',
  `dz_date` DATETIME COMMENT '对账时间(默认系统时间)',
  `clbz` CHAR(1) DEFAULT ' ' COMMENT '处理标志(默认为空格
1已处理
)',
  `cl_user` VARCHAR(20) COMMENT '处理人',
  `cl_date` DATETIME COMMENT '处理时间',
  `clyj` VARCHAR(255) COMMENT '处理意见',
  UNIQUE KEY `UQ_FG_CKTSFN_DZ_JGB` (`PZXH`, `ZSXM_DM`, `ZG_UUID`),
  CONSTRAINT `PK_FG_CKTSFN_DZ_JGB` PRIMARY KEY (`ID`),
  UNIQUE KEY `UQ_FG_CKTSFN_DZ_JGB_ORACLE_NULLS` (`pzxh`, `zsxm_dm`, (COALESCE(`zg_uuid`, '')), (`zg_uuid` IS NULL))
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='辅助管理--出口退税返纳对账结果表';

-- Creating table FG_CKTSFN_HXZG
-- Original Oracle primary-key constraint: PK_FG_CKTSFN_HXZG (MySQL index name: PRIMARY).
CREATE TABLE `FG_CKTSFN_HXZG` (
  `spuuid` VARCHAR(32) NOT NULL,
  `skssswjg_dm` VARCHAR(11) COMMENT '用备案信息中的swjg代替',
  `djxh` DECIMAL(20,0),
  `cpcode` VARCHAR(32),
  `qyhgdm` VARCHAR(32),
  `nsrsbh` VARCHAR(20),
  `nsrmc` VARCHAR(80),
  `zsuuid` VARCHAR(32),
  `dzsphm` DECIMAL(20,0),
  `dzspmxxh` DECIMAL(8,0),
  `zsxm_dm` VARCHAR(5),
  `sksx_dm` CHAR(4),
  `yskm_dm` VARCHAR(9),
  `bz` VARCHAR(3000),
  `skssqq` DATETIME,
  `skssqz` DATETIME,
  `kjrq` DATETIME,
  `jsyj` DECIMAL(22,6),
  `jkqx` DATETIME,
  `rkrq` DATETIME,
  `sjje` DECIMAL(18,2),
  `yzpzxh_ckts` VARCHAR(32),
  `xgrq` DATETIME,
  `sjtb_date` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `dzjg` CHAR(1),
  `skssswjg_js` VARCHAR(11) COMMENT '保存金三的SKSSSWJG_DM',
  `yzhytmskyy_dm` VARCHAR(3) COMMENT '应追回已退（免）税款原因代码',
  `ywhzbuuid` VARCHAR(32) COMMENT '业务核准表UUID',
  KEY `IDX_FG_CKTSFN_HXZG_DJXH` (`DJXH`),
  KEY `IDX_FG_CKTSFN_HXZG_SR` (`SKSSSWJG_DM`, `RKRQ`),
  CONSTRAINT `PK_FG_CKTSFN_HXZG` PRIMARY KEY (`SPUUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table FG_CKTSFN_HXZG_YGP
CREATE TABLE `FG_CKTSFN_HXZG_YGP` (
  `spuuid` VARCHAR(32) NOT NULL,
  `skssswjg_dm` VARCHAR(11),
  `djxh` DECIMAL(20,0),
  `cpcode` VARCHAR(32),
  `qyhgdm` VARCHAR(32),
  `nsrsbh` VARCHAR(20),
  `nsrmc` VARCHAR(80),
  `zsuuid` VARCHAR(32),
  `dzsphm` DECIMAL(20,0),
  `dzspmxxh` DECIMAL(8,0),
  `zsxm_dm` VARCHAR(5),
  `sksx_dm` CHAR(4),
  `yskm_dm` VARCHAR(9),
  `bz` VARCHAR(3000),
  `skssqq` DATETIME,
  `skssqz` DATETIME,
  `kjrq` DATETIME,
  `jsyj` DECIMAL(22,6),
  `jkqx` DATETIME,
  `rkrq` DATETIME,
  `sjje` DECIMAL(18,2),
  `yzpzxh_ckts` VARCHAR(32),
  `xgrq` DATETIME,
  `sjtb_date` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `dzjg` CHAR(1),
  `skssswjg_js` VARCHAR(11),
  `yzhytmskyy_dm` VARCHAR(3),
  `ywhzbuuid` VARCHAR(32)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table FG_CKTSFN_TSSH
-- Original Oracle primary-key constraint: PK_FG_CKTSFN_TSSH_BAK (MySQL index name: PRIMARY).
CREATE TABLE `FG_CKTSFN_TSSH` (
  `pzxh_ckts` VARCHAR(20) NOT NULL COMMENT '应征凭证序号
(对账用)
1:YZSPZ_NO+NO
2:NO
',
  `zsxm_dm` VARCHAR(5) NOT NULL COMMENT '征收项目代码（10101增值税
10102消费税
）',
  `sjly` CHAR(1) NOT NULL COMMENT '数据来源(2 :TSTHS
、1: TSTHS_FN
)',
  `yt_amt` DECIMAL(16,2) COMMENT '应补缴税额',
  `sb_ym` VARCHAR(6) COMMENT '申报年月',
  `sb_pc` VARCHAR(2) COMMENT '申报批次',
  `qyhgdm` VARCHAR(32) COMMENT '海关企业代码',
  `nsrsbh` VARCHAR(20) COMMENT '纳税人识别号',
  `nsrmc` VARCHAR(80) COMMENT '企业名称',
  `yzhyy_code` VARCHAR(4) COMMENT '应追回原因代码',
  `yzh_reason` VARCHAR(500) COMMENT '应追回原因',
  `note` VARCHAR(200) COMMENT '备注',
  `xyz_flag` CHAR(1) COMMENT '写应征标志',
  `xyz_date` DATETIME COMMENT '写应征日期',
  `xh_flag` CHAR(1) COMMENT '销号标志',
  `xh_date` DATETIME COMMENT '销号日期',
  `swjg_dm` VARCHAR(11) COMMENT '税务机关代码',
  `uuid` VARCHAR(32),
  `op_date` DATETIME COMMENT '录入日期',
  `sjtb_date` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '数据同步时间',
  `dzjg` CHAR(1) COMMENT '对账结果',
  `bgd_no` VARCHAR(21) COMMENT '报关单号',
  `zyfp_no` VARCHAR(30) COMMENT '专用发票号码',
  KEY `IDX_FG_CKTSFN_TSSH_BAK_SWJGDM` (`SWJG_DM`),
  CONSTRAINT `PK_FG_CKTSFN_TSSH_BAK` PRIMARY KEY (`PZXH_CKTS`, `ZSXM_DM`, `SJLY`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='辅助管理--出口退税返纳表（出口）';

-- Creating table FG_FLGLPDZB_DTBHTX
-- Original Oracle primary-key constraint: PK_FG_FLGLPDZB_DCBHTX (MySQL index name: PRIMARY).
CREATE TABLE `FG_FLGLPDZB_DTBHTX` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '主键',
  `nsrsbh` VARCHAR(20) NOT NULL COMMENT '纳税人识别号',
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `ssny` VARCHAR(6) NOT NULL COMMENT '所属年月',
  `nsxydj_by` CHAR(1) COMMENT '纳税信用登记(本月)',
  `nsxydj_sy` CHAR(1) COMMENT '纳税信用登记(上月)',
  `hgflgl_by` CHAR(1) COMMENT '海关管理类别(本月)',
  `hgflgl_sy` CHAR(1) COMMENT '海关管理类别(上月)',
  `wgflgl_by` CHAR(1) COMMENT '外管管理类别(本月)',
  `wgflgl_sy` CHAR(1) COMMENT '外管管理类别(上月)',
  `sxqy_by` CHAR(1) COMMENT '失信企业（本月）',
  `sxqy_sy` CHAR(1) COMMENT '失信企业（上月）',
  `jcaj_num` DECIMAL(4,0) COMMENT '稽查案件个数',
  `jcaj_wh` VARCHAR(1000) COMMENT '稽查案件文号',
  `slqyfr_new` VARCHAR(1000) COMMENT '四类出口企业的法定代表人新成立的出口企业',
  `flglcd` CHAR(1) COMMENT '分类管理类别',
  `lrrq` DATETIME COMMENT '录入日期',
  `cpcode` VARCHAR(32) COMMENT 'cpcode',
  UNIQUE KEY `UQ_FG_FLGLPDZB_DCBHTX_NS` (`NSRSBH`, `SSNY`),
  CONSTRAINT `PK_FG_FLGLPDZB_DCBHTX` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='分类管理评定指标动态变化提醒表';

-- Creating table FG_FLGLPDZB_JCXXTJ
-- Original Oracle primary-key constraint: PK_FG_FLGLPDZB_JCXXTJ (MySQL index name: PRIMARY).
CREATE TABLE `FG_FLGLPDZB_JCXXTJ` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '主键',
  `nsrsbh` VARCHAR(20) NOT NULL COMMENT '纳税人识别号',
  `ssny` VARCHAR(6) NOT NULL COMMENT '所属年月',
  `swjg_dm` VARCHAR(11) COMMENT '税务机关代码',
  `qylx` VARCHAR(2) COMMENT '企业类型',
  `flglcd` CHAR(1) COMMENT '分类管理类别(评定前)',
  `snd_qmjzc` DECIMAL(16,2) COMMENT '上一年度期未净资产',
  `snd_cktse` DECIMAL(16,2) COMMENT '上一年度已办理出口退税额',
  `nsxydj` CHAR(1) COMMENT '纳税信用等级',
  `flgl_hg` CHAR(1) COMMENT '海关企业信用管理类别',
  `flgl_wg` CHAR(1) COMMENT '外汇管理的分类管理等级',
  `scsbzjljys` DECIMAL(4,0) COMMENT '首次申报至今累计月数(自首笔申报出口退（免）税之日起至评定时未满12个月)',
  `swdjrq` DATETIME COMMENT '税务登记日期',
  `jcaj_num` DECIMAL(4,0) COMMENT '近3年稽查案件 个数',
  `jcaj_wh` VARCHAR(1000) COMMENT '近3年稽查案件文号',
  `slqyfr_all` VARCHAR(1000) COMMENT '四类出口企业的法定代表人的全部出口企业',
  `slqyfr_new` VARCHAR(1000) COMMENT '四类出口企业的法定代表人当月新成立出口企业',
  `lhcjsxqy` CHAR(1) COMMENT '被列为国家联合惩戒对象的失信企业(0/1  否/是)',
  `lrrq` DATETIME COMMENT '录入日期',
  `clbz` CHAR(1) COMMENT '处理标志',
  `clrq` DATETIME COMMENT '处理日期',
  `shxtbazt` VARCHAR(2) COMMENT '审核系统备案状态',
  `jsxtqyzt` VARCHAR(2) COMMENT '金三系统企业状态',
  `cpcode` VARCHAR(32) COMMENT 'cpcode',
  `snd_ljlgywsb` DECIMAL(2,0) COMMENT '上一年度累计未申报月份数(0-12之间取值)',
  UNIQUE KEY `UQ_FG_FLGLPDZB_JCXXTJ_NS` (`NSRSBH`, `SSNY`),
  CONSTRAINT `PK_FG_FLGLPDZB_JCXXTJ` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='分类管理评定指标基础信息统计表';

-- Creating table FG_LOG_DZDZZM
-- Original Oracle primary-key constraint: PK_FG_LOG_DZDZZM (MySQL index name: PRIMARY).
-- Auxiliary UNIQUE index UDX_FG_LOG_DZDZZM_CPCODE_ORACLE_NULLS preserves Oracle composite-UNIQUE NULL behavior: duplicate partially-NULL keys are rejected; wholly-NULL keys remain allowed. NULL flags prevent sentinel collisions; original named UNIQUE key is kept.
CREATE TABLE `FG_LOG_DZDZZM` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '主键',
  `qyhgdm` VARCHAR(20) NOT NULL COMMENT '企业海关代码',
  `nsrsbh` VARCHAR(21) NOT NULL COMMENT '纳税人识别号',
  `nsrmc` VARCHAR(80) COMMENT '企业名称',
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `qylx` CHAR(2) COMMENT '企业类型',
  `cpcode` VARCHAR(32) COMMENT 'cpcode',
  `dzlx` VARCHAR(10) NOT NULL COMMENT '单证类型',
  `zmbh` VARCHAR(20) NOT NULL COMMENT '证明编号',
  `sbym` VARCHAR(6) COMMENT '申报年月',
  `sbpc` VARCHAR(2) COMMENT '申报批次',
  `zcdyrq` DATETIME COMMENT '正常打印日期',
  `bdcs` DECIMAL(4,0) DEFAULT 0 COMMENT '补打次数',
  `bdrq` DATETIME COMMENT '补打日期(最后一次)',
  `zfbz` CHAR(1) COMMENT '作废标志',
  `zfrq` DATETIME COMMENT '作废日期',
  `zfr` VARCHAR(20) COMMENT '作废人',
  `cjrq` DATETIME COMMENT '出具日期',
  `cjr` VARCHAR(20) COMMENT '出具人',
  KEY `IDX_FG_LOG_DZDZZM_NQ` (`QYHGDM`, `NSRSBH`),
  UNIQUE KEY `UDX_FG_LOG_DZDZZM_CPCODE` (`CPCODE`, `DZLX`, `ZMBH`),
  CONSTRAINT `PK_FG_LOG_DZDZZM` PRIMARY KEY (`ID`),
  UNIQUE KEY `UDX_FG_LOG_DZDZZM_CPCODE_ORACLE_NULLS` ((COALESCE(`cpcode`, '')), (`cpcode` IS NULL), `dzlx`, `zmbh`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='辅助管理--电子单证证明日志';

-- Creating table FG_LOG_OPERATOR
-- Original Oracle primary-key constraint: PK_FG_LOG_OPERATOR (MySQL index name: PRIMARY).
CREATE TABLE `FG_LOG_OPERATOR` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '主键',
  `funcno` VARCHAR(50) COMMENT '功能名（菜单项）',
  `actno` VARCHAR(50) COMMENT '操作名（具体操作）',
  `loguser` VARCHAR(50) COMMENT '操作人员',
  `lognr` VARCHAR(500) COMMENT '日志内容',
  `logtime` DATETIME COMMENT '记录日志时间',
  `loglevel` CHAR(1) COMMENT '日志级别（I/W/E）',
  `ip` VARCHAR(20) COMMENT '工作电脑ip',
  `mac` VARCHAR(20) COMMENT '工作电脑mac地址',
  CONSTRAINT `PK_FG_LOG_OPERATOR` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='系统操作日志表';

-- Creating table FG_LOG_SYNC_DATA
-- Original Oracle primary-key constraint: PK_FG_LOG_SYNC_DATA (MySQL index name: PRIMARY).
CREATE TABLE `FG_LOG_SYNC_DATA` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '主键',
  `sync_type` VARCHAR(50) NOT NULL COMMENT '同步类型',
  `sync_obj` VARCHAR(200) COMMENT '同步对象',
  `lognr` VARCHAR(500) COMMENT '日志内容',
  `logtime` DATETIME COMMENT '记录日志时间',
  `loglevel` CHAR(1) COMMENT '日志级别',
  `loguser` VARCHAR(50) COMMENT '操作员代码
/系统服务
',
  CONSTRAINT `PK_FG_LOG_SYNC_DATA` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='系统同步日志表';

-- Creating table FG_NOTICE_QY_ATTACH
-- Original Oracle primary-key constraint: PK_PG_NOTICE_QY_ATTACH (MySQL index name: PRIMARY).
CREATE TABLE `FG_NOTICE_QY_ATTACH` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '主键',
  `noticeid` DECIMAL(18,0) NOT NULL COMMENT '通知主键',
  `filename` VARCHAR(1000) COMMENT '文件名',
  `filesize` DECIMAL(18,0) COMMENT '文件大小',
  `content` LONGBLOB COMMENT '文件内容',
  `filetype` VARCHAR(100) NOT NULL COMMENT '文件类型',
  `crtime` DATETIME NOT NULL COMMENT '创建时间',
  CONSTRAINT `PK_PG_NOTICE_QY_ATTACH` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='企业通知附件表';

-- Creating table FG_NOTICE_QY_MAIN
-- FG_NOTICE_QY_MAIN.id: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- Original Oracle primary-key constraint: PK_FG_NOTICE_QY_MAIN (MySQL index name: PRIMARY).
CREATE TABLE `FG_NOTICE_QY_MAIN` (
  `id` DECIMAL(65,27) NOT NULL COMMENT '主键',
  `title` VARCHAR(200) COMMENT '标题',
  `content` VARCHAR(4000) COMMENT '内容',
  `release_user` VARCHAR(100) COMMENT '发布人',
  `release_czydm` VARCHAR(20) COMMENT '发布人帐号',
  `release_swjgdm` VARCHAR(11) COMMENT '发布人税务机关代码',
  `release_time` DATETIME COMMENT '发布时间',
  `valid_time` DATETIME COMMENT '通知截止时间',
  `qybj` CHAR(1) COMMENT '启用标记(0.编辑，1.发布，2.撤销)',
  `bz` VARCHAR(255) COMMENT '备注',
  `cx_time` DATETIME COMMENT '撤销时间',
  `exist_upfile` CHAR(1) COMMENT '有无附件标志（0:无  1:有）',
  `notitype` CHAR(1) COMMENT '通知类型(1群发
2定向
)',
  `objval` VARCHAR(20) COMMENT '通知对象-主发(群发-SWJGDM
定向-NSRSBH
)',
  CONSTRAINT `PK_FG_NOTICE_QY_MAIN` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='企业通知主表';

-- Creating table FG_NOTICE_QY_RECEIVER
-- Original Oracle primary-key constraint: PK_FG_NOTICE_QY_RECEIVER (MySQL index name: PRIMARY).
CREATE TABLE `FG_NOTICE_QY_RECEIVER` (
  `noticeid` DECIMAL(18,0) NOT NULL COMMENT '通知主表序号',
  `objval` VARCHAR(20) NOT NULL COMMENT '通知对象（抄送）',
  CONSTRAINT `PK_FG_NOTICE_QY_RECEIVER` PRIMARY KEY (`NOTICEID`, `OBJVAL`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='企业通知接收方子表';

-- Creating table FG_NOTICE_QY_SYNC2YUN
-- Original Oracle primary-key constraint: PK_FG_NOTICE_QY_SYNC2YUN (MySQL index name: PRIMARY).
CREATE TABLE `FG_NOTICE_QY_SYNC2YUN` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '主键',
  `title` VARCHAR(200) COMMENT '标题',
  `content` VARCHAR(4000) COMMENT '内容',
  `release_user` VARCHAR(100) COMMENT '发布人',
  `release_swjg` VARCHAR(200) COMMENT '发布税务机关release_time,valid_time, swjgdm_set,bz,qybj',
  `release_time` DATETIME COMMENT '发布日期',
  `valid_time` DATETIME COMMENT '有效日期',
  `swjgdm_set` VARCHAR(1000) COMMENT '通知的税务机关代码集合',
  `nsrdzdah_set` VARCHAR(2000) COMMENT '通知的纳税人电子档案号集合',
  `bz` VARCHAR(255) COMMENT '备注',
  `qybj` CHAR(1) COMMENT '启用标记',
  CONSTRAINT `PK_FG_NOTICE_QY_SYNC2YUN` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='企业通知信息同步到云平台信息';

-- Creating table FG_NOTICE_SW_ATTACH
-- Original Oracle primary-key constraint: PK_PG_NOTICE_SW_ATTACH (MySQL index name: PRIMARY).
CREATE TABLE `FG_NOTICE_SW_ATTACH` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '主键',
  `noticeid` DECIMAL(18,0) NOT NULL COMMENT '通知主键',
  `filename` VARCHAR(1000) COMMENT '文件名',
  `filesize` DECIMAL(18,0) COMMENT '文件大小',
  `content` LONGBLOB COMMENT '文件内容',
  `filetype` VARCHAR(100) NOT NULL COMMENT '文件类型',
  `crtime` DATETIME NOT NULL COMMENT '创建时间',
  CONSTRAINT `PK_PG_NOTICE_SW_ATTACH` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='税务通知附件表';

-- Creating table FG_NOTICE_SW_MAIN
-- FG_NOTICE_SW_MAIN.id: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- Original Oracle primary-key constraint: PK_FG_NOTICE_SW_MAIN (MySQL index name: PRIMARY).
CREATE TABLE `FG_NOTICE_SW_MAIN` (
  `id` DECIMAL(65,27) NOT NULL COMMENT '主键',
  `title` VARCHAR(200) COMMENT '标题',
  `content` VARCHAR(4000) COMMENT '内容',
  `release_user` VARCHAR(100) COMMENT '发布人',
  `release_czydm` VARCHAR(20) COMMENT '发布人帐号',
  `release_swjgdm` VARCHAR(11) COMMENT '发布人税务机关代码',
  `release_time` DATETIME COMMENT '发布时间',
  `valid_time` DATETIME COMMENT '通知截止时间',
  `qybj` CHAR(1) COMMENT '启用标记(0.编辑，1.发布，2.撤销)',
  `bz` VARCHAR(255) COMMENT '备注',
  `cx_time` DATETIME COMMENT '撤销时间',
  `exist_upfile` CHAR(1) COMMENT '有无附件标志（0:无  1:有）',
  `notitype` CHAR(1) COMMENT '通知类型(1群发
2定向
)',
  `objval` VARCHAR(20) COMMENT '通知对象-主发(群发-SWJGDM
定向-CZRY_DM
)',
  CONSTRAINT `PK_FG_NOTICE_SW_MAIN` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='税务通知主表';

-- Creating table FG_NOTICE_SW_RECEIPT
-- Original Oracle primary-key constraint: PK_FG_NOTICE_SW_RECEIPT (MySQL index name: PRIMARY).
CREATE TABLE `FG_NOTICE_SW_RECEIPT` (
  `noticeid` DECIMAL(18,0) NOT NULL COMMENT '通知id',
  `nsrsbh` VARCHAR(20) NOT NULL COMMENT '纳税人识别号或者社会信用代码',
  `receipt_time` DATETIME COMMENT '回执时间',
  CONSTRAINT `PK_FG_NOTICE_SW_RECEIPT` PRIMARY KEY (`NOTICEID`, `NSRSBH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='税务通知回执表';

-- Creating table FG_NOTICE_SW_RECEIVER
-- Original Oracle primary-key constraint: PK_FG_NOTICE_SW_RECEIVER (MySQL index name: PRIMARY).
CREATE TABLE `FG_NOTICE_SW_RECEIVER` (
  `noticeid` DECIMAL(18,0) NOT NULL COMMENT '通知主表序号',
  `objval` VARCHAR(20) NOT NULL COMMENT '通知对象（抄送）',
  CONSTRAINT `PK_FG_NOTICE_SW_RECEIVER` PRIMARY KEY (`NOTICEID`, `OBJVAL`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='税务通知接收方子表';

-- Creating table FG_SB_CANCEL
-- Original Oracle primary-key constraint: PK_FG_SB_CANCEL (MySQL index name: PRIMARY).
CREATE TABLE `FG_SB_CANCEL` (
  `lcslid` VARCHAR(32) NOT NULL COMMENT '流程受理id',
  `qyhgdm` VARCHAR(20) NOT NULL COMMENT '企业海关代码',
  `nsrsbh` VARCHAR(21) NOT NULL COMMENT '纳税人识别号',
  `nsrmc` VARCHAR(80) COMMENT '纳税人名称',
  `cpcode` VARCHAR(32) NOT NULL COMMENT '海关代码，老海关代码',
  `swjg_dm` VARCHAR(11) COMMENT '税务机关代码',
  `qylx` VARCHAR(2) NOT NULL COMMENT '企业类型',
  `gllb` CHAR(1) NOT NULL COMMENT '管理类别',
  `lc_id` VARCHAR(10) NOT NULL COMMENT '业务类型',
  `sbym` VARCHAR(6) COMMENT '申报年月',
  `sbpc` VARCHAR(2) COMMENT '申报批次',
  `ckamt_usd` DECIMAL(16,2) COMMENT '申报出口额USD',
  `tsjsje` DECIMAL(16,2) COMMENT '退税计税金额',
  `jljgdje` DECIMAL(16,2) COMMENT '进料加工抵减额',
  `tse_amt` DECIMAL(16,2) COMMENT '退(免)税总额',
  `tse_zzs` DECIMAL(16,2) COMMENT '退增值税',
  `tse_xfs` DECIMAL(16,2) COMMENT '退消费税',
  `mdse` DECIMAL(16,2) COMMENT '免抵税额',
  `sl_date` DATETIME COMMENT '申报受理时间',
  `sh_user` VARCHAR(20) COMMENT '审核人员',
  `yjbz` CHAR(1) COMMENT '预警标志',
  `sjly` CHAR(1) NOT NULL COMMENT '数据来源(1企业申请
2系统同步
)',
  `sq_date` DATETIME COMMENT '申请时间',
  `sq_reason` VARCHAR(200) COMMENT '申请原因',
  `sc_user` VARCHAR(20) COMMENT '撤单人',
  `sc_reason` VARCHAR(200) COMMENT '撤单原因',
  `sc_date` DATETIME COMMENT '撤单时间',
  `tse_zh` DECIMAL(16,2) COMMENT '暂缓退税金额',
  `tse_by` DECIMAL(16,2) COMMENT '不予退税金额',
  `sjtb_bz` CHAR(1) COMMENT '数据同步标志(0待同步
1正在同步
2同步结束
)',
  `sjtb_date` DATETIME COMMENT '数据同步时间',
  `clbz` CHAR(1) COMMENT '处理标志(0:未处理  1:已撤单处理)',
  `tqbz` VARCHAR(40) COMMENT '提取标志',
  `tqsj` DATETIME(6) COMMENT '提取时间',
  `tqcs` DECIMAL(2,0) COMMENT '提取次数',
  KEY `IDX_FG_SB_CANCEL_CPCODE` (`CPCODE`),
  KEY `IDX_FG_SB_CANCEL_QYBS` (`QYHGDM`, `NSRSBH`),
  KEY `IDX_FG_SB_CANCEL_SWJGDM` (`SWJG_DM`),
  CONSTRAINT `PK_FG_SB_CANCEL` PRIMARY KEY (`LCSLID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='辅助管理-撤单记录主线表';

-- Creating table FG_SB_CANCEL_DZMX
-- Original Oracle primary-key constraint: PK_FG_SB_CANCEL_DZMX (MySQL index name: PRIMARY).
CREATE TABLE `FG_SB_CANCEL_DZMX` (
  `lcslid` VARCHAR(32) NOT NULL COMMENT '流程受理id',
  `cpcode` VARCHAR(32) COMMENT '海关代码，老的海关代码',
  `sbno` VARCHAR(4) NOT NULL COMMENT '申报序号',
  `pzlx` CHAR(1) NOT NULL COMMENT '凭证类型(1报关单
2进项发票
3专用税票
4代理证明
)',
  `pzhm` VARCHAR(32) NOT NULL COMMENT '凭证号码',
  `zh_flag` CHAR(1) COMMENT '暂缓标志(1暂缓，默认放行+提醒)',
  `by_flag` CHAR(1) COMMENT '不予标志(1不予，默认拒绝放行)',
  `tse` DECIMAL(16,2) NOT NULL COMMENT '申报退税额',
  `sjly` CHAR(1) NOT NULL COMMENT '数据来源(1自动同步
2人工录入
)',
  `spdm` VARCHAR(11) COMMENT '商品代码',
  `jldw` VARCHAR(20) COMMENT '计量单位',
  `spmc` VARCHAR(30) COMMENT '商品名称',
  `sl` DECIMAL(15,4) COMMENT '数量',
  `jsje` DECIMAL(16,2) COMMENT '计税金额',
  KEY `IDX_FG_SB_CANCEL_DZMX_PZXX` (`CPCODE`, `PZLX`, `PZHM`),
  CONSTRAINT `PK_FG_SB_CANCEL_DZMX` PRIMARY KEY (`LCSLID`, `SBNO`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='辅助管理-撤单凭证明细表';

-- Creating table FG_SB_CANCEL_FXB
-- Original Oracle primary-key constraint: PK_FG_SB_CANCEL_FXB (MySQL index name: PRIMARY).
CREATE TABLE `FG_SB_CANCEL_FXB` (
  `cpcode` VARCHAR(32) NOT NULL COMMENT '企业代码，老海关代码',
  `pzlx` CHAR(1) NOT NULL COMMENT '凭证类型',
  `pzhm` VARCHAR(32) NOT NULL COMMENT '凭证号码',
  `fx_flag` CHAR(1) NOT NULL COMMENT '放行标志(1放行
2放行+提醒
3拒绝放行
)',
  `op_user` VARCHAR(20) COMMENT '设置人',
  `op_date` DATETIME COMMENT '设置时间',
  `bz` VARCHAR(200) COMMENT '注释说明',
  CONSTRAINT `PK_FG_SB_CANCEL_FXB` PRIMARY KEY (`CPCODE`, `PZLX`, `PZHM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='辅助管理-撤单单证放行表';

-- Creating table FG_SRTHS_QD
-- Original Oracle primary-key constraint: PK_FG_SRTHS_QD (MySQL index name: PRIMARY).
CREATE TABLE `FG_SRTHS_QD` (
  `no` VARCHAR(20) NOT NULL COMMENT '退还书号码',
  `swjg_dm` VARCHAR(11) COMMENT '所属退税税务机关',
  `qyhgdm` VARCHAR(20) COMMENT '海关代码',
  `nsrsbh` VARCHAR(20) COMMENT '纳税人识别号',
  `nsrmc` VARCHAR(100) COMMENT '纳税人名称',
  `qylx_dm` VARCHAR(2) COMMENT '企业类型',
  `flglcd` CHAR(1) COMMENT '分类管理等级',
  `tsjsfs_dm` CHAR(1) COMMENT '退税计算方式',
  `sbywbdm` VARCHAR(10) COMMENT '申报业务表代码',
  `sssq` CHAR(6) COMMENT '所属年月',
  `sbpc` VARCHAR(3) COMMENT '申报批次',
  `zzsamt` DECIMAL(16,2) COMMENT '退增值税',
  `xfsamt` DECIMAL(16,2) COMMENT '退消费税',
  `sh_time` DATETIME COMMENT '审核时间',
  `shr` VARCHAR(20) COMMENT '审核人',
  `op_date` DATETIME COMMENT '生成日期',
  `op_user` VARCHAR(20) COMMENT '生成人',
  `tsyhmc` VARCHAR(80) COMMENT '退税银行名称',
  `tsyhzh` VARCHAR(30) COMMENT '退税银行账号',
  `qdbz` CHAR(1) DEFAULT '0' COMMENT '清单标志 0未生成 1已生成',
  `qd_date` DATETIME COMMENT '清单打印或导出日期',
  `qdno` VARCHAR(20) COMMENT '清单编号',
  `qd_user` VARCHAR(20) COMMENT '清单人',
  `sjtbsj` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '数据同步时间',
  `sjtbcs` DECIMAL(38,0) DEFAULT 1 COMMENT '数据同步次数',
  `yjflag` CHAR(1) DEFAULT '0' COMMENT '预警标志 0正常 1有警告',
  `yjmsg` VARCHAR(100) COMMENT '预警消息',
  `sjtbbz` CHAR(1) DEFAULT '0' COMMENT '数据同步标志，预留给后续处理',
  `zbjg_dm` VARCHAR(11),
  `lcslid` VARCHAR(32) NOT NULL DEFAULT ' ' COMMENT 'LCSLID',
  `zb_swjg_dm` VARCHAR(11) COMMENT '指标计划税务机关代码',
  KEY `IDX_FG_SRTHS_QD_LCSLID` (`LCSLID`),
  CONSTRAINT `PK_FG_SRTHS_QD` PRIMARY KEY (`NO`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='收入退还书清单';

-- Creating table FG_SRTHS_QDBH
CREATE TABLE `FG_SRTHS_QDBH` (
  `qdno` VARCHAR(20) NOT NULL COMMENT '清单编号',
  `swjg_dm` VARCHAR(11) COMMENT '税务机关代码',
  `qd_user` VARCHAR(20) COMMENT '清单生成人',
  `qd_date` DATETIME COMMENT '清单时间',
  `yxbz` CHAR(1) DEFAULT 'Y' COMMENT '有效标志 Y有效 N作废',
  KEY `IDX_FG_SRTHS_QBDH` (`SWJG_DM`, `QDNO`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='收入退还书清单编号生成';

-- Creating table FG_SRTHS_QD_BAK
CREATE TABLE `FG_SRTHS_QD_BAK` (
  `no` VARCHAR(20) NOT NULL,
  `swjg_dm` VARCHAR(11),
  `qyhgdm` VARCHAR(20),
  `nsrsbh` VARCHAR(20),
  `nsrmc` VARCHAR(100),
  `qylx_dm` VARCHAR(2),
  `flglcd` CHAR(1),
  `tsjsfs_dm` CHAR(1),
  `sbywbdm` VARCHAR(10),
  `sssq` CHAR(6),
  `sbpc` VARCHAR(3),
  `zzsamt` DECIMAL(16,2),
  `xfsamt` DECIMAL(16,2),
  `sh_time` DATETIME,
  `shr` VARCHAR(20),
  `op_date` DATETIME,
  `op_user` VARCHAR(20),
  `tsyhmc` VARCHAR(80),
  `tsyhzh` VARCHAR(30),
  `qdbz` CHAR(1),
  `qd_date` DATETIME,
  `qdno` VARCHAR(20),
  `qd_user` VARCHAR(20),
  `sjtbsj` DATETIME,
  `sjtbcs` DECIMAL(38,0),
  `yjflag` CHAR(1),
  `yjmsg` VARCHAR(100),
  `sjtbbz` CHAR(1),
  `zbjg_dm` VARCHAR(11)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table FG_TKTZS_QD
-- Original Oracle primary-key constraint: PK_FG_TKTZS_QD (MySQL index name: PRIMARY).
CREATE TABLE `FG_TKTZS_QD` (
  `no` VARCHAR(20) NOT NULL COMMENT '调库通知书号码',
  `msg_id` DECIMAL(38,0) NOT NULL,
  `item_no` VARCHAR(2) NOT NULL,
  `swjg_dm` VARCHAR(11) COMMENT '所属税务机关',
  `qyhgdm` VARCHAR(20) COMMENT '海关代码',
  `nsrsbh` VARCHAR(20) COMMENT '纳税人识别号',
  `nsrmc` VARCHAR(100) COMMENT '纳税人名称',
  `qylx_dm` VARCHAR(2) COMMENT '企业类型',
  `flglcd` CHAR(1) COMMENT '分类管理等级',
  `tsjsfs_dm` CHAR(1) COMMENT '退税计算方式',
  `sbywbdm` VARCHAR(10) COMMENT '申报业务表代码',
  `sssq` CHAR(6) COMMENT '所属年月',
  `sbpc` VARCHAR(3) COMMENT '申报批次',
  `ysjccode` VARCHAR(2),
  `lsgx` VARCHAR(2),
  `tkjccode` VARCHAR(4),
  `md_amt` DECIMAL(16,2) COMMENT '免抵',
  `sh_time` DATETIME COMMENT '审核时间',
  `shr` VARCHAR(20) COMMENT '审核人',
  `op_date` DATETIME COMMENT '生成日期',
  `op_user` VARCHAR(20) COMMENT '生成人',
  `zf_flag` CHAR(1) COMMENT '作废标志 1作废 空格：不作废',
  `ywlx` VARCHAR(2) COMMENT '业务类型',
  `qdbz` CHAR(1) DEFAULT '0' COMMENT '清单标志 0未生成 1已生成',
  `qd_date` DATETIME COMMENT '清单打印或导出日期',
  `qdno` VARCHAR(20) COMMENT '清单编号',
  `qd_user` VARCHAR(20) COMMENT '清单人',
  `sjtbsj` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '数据同步时间',
  `sjtbcs` DECIMAL(38,0) DEFAULT 1 COMMENT '数据同步次数',
  `yjflag` CHAR(1) DEFAULT '0' COMMENT '预警标志 0正常 1有警告',
  `yjmsg` VARCHAR(100) COMMENT '预警消息',
  `sjtbbz` CHAR(1) DEFAULT '0' COMMENT '数据同步标志，预留给后续处理',
  `zbjg_dm` VARCHAR(11),
  `lcslid` VARCHAR(32) NOT NULL DEFAULT ' ' COMMENT 'LCSLID',
  `zb_swjg_dm` VARCHAR(11) COMMENT '指标计划税务机关代码',
  KEY `IDX_FG_TKTZS_QD_LCSLID` (`LCSLID`),
  CONSTRAINT `PK_FG_TKTZS_QD` PRIMARY KEY (`NO`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='调库通知书清单';

-- Creating table FG_TKTZS_QDBH
-- Original Oracle primary-key constraint: PK_FG_TKTZS_QDBH (MySQL index name: PRIMARY).
CREATE TABLE `FG_TKTZS_QDBH` (
  `qdno` VARCHAR(20) NOT NULL COMMENT '清单编号',
  `swjg_dm` VARCHAR(11) COMMENT '税务机关代码',
  `qd_user` VARCHAR(20) COMMENT '清单生成人',
  `qd_date` DATETIME COMMENT '清单时间',
  `yxbz` CHAR(1) DEFAULT 'Y' COMMENT '有效标志 Y有效 N作废',
  CONSTRAINT `PK_FG_TKTZS_QDBH` PRIMARY KEY (`QDNO`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='调库通知书清单编号生成';

-- Creating table FG_TSDQY_JGB
CREATE TABLE `FG_TSDQY_JGB` (
  `nsrsbh` VARCHAR(20) NOT NULL COMMENT '纳税人识别号',
  `jgbz` CHAR(1) COMMENT '监管标志 1 监管 0停止',
  `crtime` DATETIME COMMENT '创建时间',
  `crr` VARCHAR(20) COMMENT '创建人',
  `uptime` DATETIME,
  `upr` VARCHAR(20),
  `note` VARCHAR(200) COMMENT '备注说明',
  PRIMARY KEY (`NSRSBH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='退税贷企业监管表';

-- Creating table FG_YWBLXX_DEL
-- Original Oracle primary-key constraint: PK_FG_YWBLXX_DEL (MySQL index name: PRIMARY).
CREATE TABLE `FG_YWBLXX_DEL` (
  `lcslid` VARCHAR(32) NOT NULL DEFAULT ' ' COMMENT 'LCSLID',
  `zfrq_1` DATETIME COMMENT '作废日期',
  `lcswsx_dm` VARCHAR(200) COMMENT '流程代码',
  CONSTRAINT `PK_FG_YWBLXX_DEL` PRIMARY KEY (`LCSLID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table FG_YWYBA_INFO
-- Original Oracle primary-key constraint: PK_FG_YWYBA_INFO (MySQL index name: PRIMARY).
CREATE TABLE `FG_YWYBA_INFO` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '主键id',
  `qyhgdm` VARCHAR(20) NOT NULL COMMENT '企业海关代码',
  `nsrsbh` VARCHAR(21) NOT NULL COMMENT '纳税人识别号',
  `nsrmc` VARCHAR(200) COMMENT '纳税人名称',
  `year` CHAR(4) COMMENT '备案年度',
  `sfzh` VARCHAR(255) COMMENT '身份证号',
  `ywyxm` VARCHAR(200) COMMENT '业务员姓名',
  `sex` CHAR(1) COMMENT '性别(1男2女)',
  `gzrqq` DATETIME COMMENT '工作日期起',
  `gzrqz` DATETIME COMMENT '工作日期止',
  `sfqdldht` CHAR(1) COMMENT '是否签订劳动合同(Y/N)',
  `sfdjbx` CHAR(1) COMMENT '是否代缴保险(Y/N)',
  `sncke` DECIMAL(16,2) COMMENT '上年出口额(企业上报数)',
  `snzycksp` VARCHAR(400) COMMENT '上年主出口商品',
  `snzyckg` VARCHAR(400) COMMENT '上年主要出口国',
  `snzyghd` VARCHAR(400) COMMENT '上年主要购货地',
  `freshtime` DATETIME COMMENT '自动刷新时间',
  `bncke` DECIMAL(16,2) COMMENT '本年出口额',
  `bnzycksp` VARCHAR(200) COMMENT '本年主出口商品',
  `bnzyckg` VARCHAR(200) COMMENT '本年主要出口国',
  `bnzyghd` VARCHAR(200) COMMENT '本年主要购货地',
  `tbzf` DECIMAL(10,4) COMMENT '同比增幅',
  `qyhs` DECIMAL(10,0) COMMENT '涉及企业户数',
  `lrrq` DATETIME COMMENT '录入时间',
  `xgrq` DATETIME COMMENT '修改日期',
  `zxflag` CHAR(1) COMMENT '注销标志(Y/N)',
  `zxrq` DATETIME COMMENT '注销日期',
  `sfsxgk` CHAR(1) COMMENT '是否涉嫌挂靠(Y/N)',
  `clbz` CHAR(1) COMMENT '处理标志(0:待处理  1:正在处理   2:处理结束) 用于自动取数逻辑',
  `tqbz` VARCHAR(40) COMMENT '提取标志',
  `tqsj` DATETIME(6) COMMENT '提取时间',
  `tqcs` DECIMAL(2,0) COMMENT '提取次数',
  `bz` VARCHAR(200),
  KEY `IDX_FG_YWYBA_INFO_QYHGDM` (`QYHGDM`),
  KEY `INX_FG_YWYBA_INFO_NSRSBH` (`NSRSBH`),
  CONSTRAINT `PK_FG_YWYBA_INFO` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='辅助管理--业务员备案信息表';

-- Creating table GS_NOTICE_DOCFILE
-- Original Oracle primary-key constraint: PK_NOTICE_DOCFILE_ID (MySQL index name: PRIMARY).
CREATE TABLE `GS_NOTICE_DOCFILE` (
  `id` DECIMAL(18,0) NOT NULL,
  `filename` VARCHAR(1000),
  `filesize` DECIMAL(18,0),
  `filetype` VARCHAR(100) NOT NULL,
  `crtime` DATETIME NOT NULL,
  `content` LONGBLOB,
  `noticeid` DECIMAL(18,0) NOT NULL,
  CONSTRAINT `PK_NOTICE_DOCFILE_ID` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table GS_NOTICE_MAIN
-- Original Oracle primary-key constraint: PK_NOTICE_MAIN_ID (MySQL index name: PRIMARY).
CREATE TABLE `GS_NOTICE_MAIN` (
  `id` DECIMAL(18,0) NOT NULL,
  `title` VARCHAR(200) NOT NULL COMMENT '标题',
  `content` LONGTEXT NOT NULL COMMENT '正文',
  `release_user` VARCHAR(100) NOT NULL COMMENT '发布人',
  `release_czydm` VARCHAR(20) NOT NULL COMMENT '发布人账号',
  `release_swjg` VARCHAR(100) NOT NULL COMMENT '发布人税务机关名称',
  `release_swjgdm` VARCHAR(11) NOT NULL COMMENT '发布人税务机关代码',
  `release_time` DATETIME COMMENT '发布时间',
  `valid_time` DATETIME COMMENT '通知截止时间',
  `swjgdm_set` VARCHAR(1000) COMMENT '发布范围税局机关代码',
  `qybj` CHAR(1) NOT NULL COMMENT '0.编辑，1.发布，2.撤销',
  `bz` VARCHAR(1000) COMMENT '备注',
  `swjgmc_set` VARCHAR(1000),
  `cx_time` DATETIME COMMENT '撤销时间',
  `exist_upfile` CHAR(1) NOT NULL DEFAULT '0' COMMENT '是否存在附件',
  `nsrsbh_set` VARCHAR(1000) COMMENT '纳税人识别号的集合',
  `nsrdzdah_set` VARCHAR(1000) COMMENT '纳税人电子档案号的集合',
  UNIQUE KEY `INDEX_NOTICE_ID` (`ID`),
  CONSTRAINT `PK_NOTICE_MAIN_ID` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='通知公告';

-- Creating table GS_TRAINING
-- Original Oracle primary-key constraint: PK_GS_TRAINING (MySQL index name: PRIMARY).
CREATE TABLE `GS_TRAINING` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '序号',
  `originator` VARCHAR(255) COMMENT '发起单位',
  `topic` VARCHAR(255),
  `synopsis` VARCHAR(500) COMMENT '内容简介',
  `valid_date_start` DATETIME,
  `valid_date_end` DATETIME,
  `person_limit` DECIMAL(6,0) COMMENT '人数上限',
  `remain` DECIMAL(6,0),
  `address` VARCHAR(500) COMMENT '培训地址',
  `contact` VARCHAR(50) COMMENT '联系人',
  `contact_tel` VARCHAR(20) COMMENT '联系电话',
  `operator` VARCHAR(20) COMMENT '操作人',
  `isvalid` VARCHAR(255),
  `crtime` DATETIME,
  `uptime` DATETIME,
  `ticket` VARCHAR(255),
  `swjgdm` VARCHAR(255) COMMENT '发布人税务机关代码',
  `tssjq` DATETIME COMMENT '安全助手推送时间起',
  `tssjz` DATETIME COMMENT '推送时间止',
  CONSTRAINT `PK_GS_TRAINING` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table GS_TRAINING_APPLY
-- Original Oracle primary-key constraint: PK_GS_TRAINING_APPLY (MySQL index name: PRIMARY).
CREATE TABLE `GS_TRAINING_APPLY` (
  `id` DECIMAL(20,0) NOT NULL,
  `trainid` DECIMAL(20,0) NOT NULL,
  `company_name` VARCHAR(255),
  `shxydm` VARCHAR(30),
  `company_type` VARCHAR(1),
  `participant` VARCHAR(30),
  `participant_tel` VARCHAR(20),
  `joinper` VARCHAR(30),
  `joinper_tel` VARCHAR(20),
  `oicq` VARCHAR(13),
  `openid` VARCHAR(255),
  `auth_code` VARCHAR(10),
  `sign_flag` VARCHAR(1),
  `crtime` DATETIME,
  `uptime` DATETIME,
  CONSTRAINT `PK_GS_TRAINING_APPLY` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table JSBK_CS_CZRY_DZB
CREATE TABLE `JSBK_CS_CZRY_DZB` (
  `czry_tssh` VARCHAR(30) NOT NULL,
  `czry_hxzg` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`CZRY_TSSH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='金三并库参数表-操作员对照';

-- Creating table RWGL_EXTERNAL
-- Original Oracle primary-key constraint: RWGL_EXTERNAL_PK (MySQL index name: PRIMARY).
CREATE TABLE `RWGL_EXTERNAL` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '任务id',
  `nsrsbh` VARCHAR(18) COMMENT '纳税人识别号',
  `task_type` VARCHAR(3) NOT NULL COMMENT '任务类型',
  `task_name` VARCHAR(50) COMMENT '任务名称',
  `task_hash` VARCHAR(50) COMMENT '任务hash',
  `task_status` CHAR(1) NOT NULL COMMENT '任务状态(0:待处理 1:处理中 2:处理失败   9:处理完毕)',
  `tqbz` VARCHAR(32) COMMENT '提取标志',
  `tqsj` DATETIME(6) COMMENT '提取时间',
  `tqcs` DECIMAL(6,0) COMMENT '提取次数',
  `req_count` DECIMAL(6,0) COMMENT '请求次数',
  `last_time` DATETIME(6) COMMENT '最近一次获取时间',
  `creat_time` DATETIME(6) COMMENT '创建时间',
  `update_time` DATETIME(6) COMMENT '修改时间',
  `first_time` DATETIME(6) COMMENT '首次获取时间',
  `fetch_flag` CHAR(1) COMMENT '获取标志（是-Y  否-N）',
  `note` VARCHAR(500) COMMENT '错误信息',
  `task_req` LONGTEXT COMMENT '任务请求',
  `task_res` LONGTEXT COMMENT '任务响应',
  `busikey` VARCHAR(50) COMMENT '业务外键，当task_type=003时，写入触发产生的备案任务的业务主键(采用从金三获取的模式，命名规则：nsrsbh|sbywzl|sssq|sbpc;采用从tl_bjts用户取数的模式，为sbid)。其他任务类型为空',
  UNIQUE KEY `IDX_RWGL_EXTERNAL_HASH` (`TASK_HASH`),
  KEY `IDX_RWGL_EXTERNAL_NTSF` (`NSRSBH`, `TASK_TYPE`, `TASK_STATUS`, `FETCH_FLAG`),
  CONSTRAINT `RWGL_EXTERNAL_PK` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='单证备案-线程池任务表';

-- Creating table RWGL_EXTERNAL_HIS
-- Original Oracle primary-key constraint: RWGL_EXTERNAL_HIS_PK (MySQL index name: PRIMARY).
CREATE TABLE `RWGL_EXTERNAL_HIS` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '任务id',
  `nsrsbh` VARCHAR(18) COMMENT '纳税人识别号',
  `task_type` VARCHAR(3) NOT NULL COMMENT '任务类型',
  `task_name` VARCHAR(50) COMMENT '任务名称',
  `task_hash` VARCHAR(50) COMMENT '任务hash',
  `task_status` CHAR(1) NOT NULL COMMENT '任务状态(0:待处理 1:处理中 2:处理失败   9:处理完毕)',
  `tqbz` VARCHAR(32) COMMENT '提取标志',
  `tqsj` DATETIME(6) COMMENT '提取时间',
  `tqcs` DECIMAL(6,0) COMMENT '提取次数',
  `req_count` DECIMAL(6,0) COMMENT '请求次数',
  `last_time` DATETIME(6) COMMENT '最近一次获取时间',
  `creat_time` DATETIME(6) COMMENT '创建时间',
  `update_time` DATETIME(6) COMMENT '修改时间',
  `first_time` DATETIME(6) COMMENT '首次获取时间',
  `fetch_flag` CHAR(1) COMMENT '获取标志（是-Y  否-N）',
  `note` VARCHAR(500) COMMENT '错误信息',
  `task_req` LONGTEXT,
  `task_res` LONGTEXT,
  `busikey` VARCHAR(50) COMMENT '业务外键，当task_type=003时，写入触发产生的备案任务的业务主键(采用从金三获取的模式，命名规则：nsrsbh|sbywzl|sssq|sbpc;采用从tl_bjts用户取数的模式，为sbid)。其他任务类型为空',
  CONSTRAINT `RWGL_EXTERNAL_HIS_PK` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='单证备案-线程池任务历史数据备份表';

-- Creating table RWGL_YBCL_XXZB
-- Original Oracle primary-key constraint: PK_RWGL_YBCL_XXZB (MySQL index name: PRIMARY).
CREATE TABLE `RWGL_YBCL_XXZB` (
  `rwlx` VARCHAR(2) NOT NULL COMMENT '任务类型',
  `rwhash` VARCHAR(50) NOT NULL COMMENT '任务哈希(参数通过md5生成的哈希)',
  `rwname` VARCHAR(50) COMMENT '任务中文名称',
  `rwbw` VARCHAR(4000) COMMENT '任务的报文',
  `rwms` VARCHAR(200) COMMENT '任务的描述',
  `rwzt` CHAR(1) COMMENT '任务状态(0:待处理  1:正在处理 2:处理完毕)',
  `tqbz` VARCHAR(30) COMMENT '提取标志',
  `tqcs` DECIMAL(4,0) COMMENT '提取次数',
  `tqsj` DATETIME COMMENT '提取时间',
  `frtime` DATETIME COMMENT '完成(刷新)时间',
  `frnum` DECIMAL(4,0) COMMENT '总刷新次数(每刷新一次结果+1)',
  `readnum` DECIMAL(4,0) COMMENT '读取次数(刷新后清0)',
  `readtotal` DECIMAL(4,0) COMMENT '总读取次数(每次读取结果+1)',
  `czrydm` VARCHAR(20) COMMENT '创建人员代码',
  `czrymc` VARCHAR(80) NOT NULL COMMENT '创建人员名称',
  `crtime` DATETIME NOT NULL COMMENT '创建时间',
  `swjgdm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `bz` VARCHAR(200) COMMENT '备注',
  CONSTRAINT `PK_RWGL_YBCL_XXZB` PRIMARY KEY (`RWLX`, `RWHASH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='异步处理任务管理信息总表';

-- Creating table SYS_CFG_TABLE_COLUMN
-- SYS_CFG_TABLE_COLUMN.c_min_size: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- SYS_CFG_TABLE_COLUMN.c_max_size: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- SYS_CFG_TABLE_COLUMN.c_std_size: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- SYS_CFG_TABLE_COLUMN.no: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- Original Oracle primary-key constraint: PK_T_COLUMN (MySQL index name: PRIMARY).
CREATE TABLE `SYS_CFG_TABLE_COLUMN` (
  `t_code` VARCHAR(32) NOT NULL,
  `t_c_code` VARCHAR(32) NOT NULL,
  `t_c_name` VARCHAR(50),
  `c_min_size` DECIMAL(65,27) COMMENT '默认最小列宽',
  `c_max_size` DECIMAL(65,27) COMMENT '默认最大列宽',
  `c_std_size` DECIMAL(65,27) COMMENT '列宽设置',
  `no` DECIMAL(65,27) COMMENT '列表中的显示顺序',
  `is_fixed` CHAR(1) COMMENT '列表中是否固定存在 0:否  1:是',
  `is_order` CHAR(1) COMMENT '是否支持排序，0:不支持  1:支持',
  `align` CHAR(1) COMMENT '0-居左(字符型) 1-居中 2-居右(数值型)',
  `isvaild` CHAR(1) NOT NULL DEFAULT '1',
  `update_time` DATETIME,
  `create_time` DATETIME,
  `f1` VARCHAR(32),
  `f2` VARCHAR(32),
  `f3` VARCHAR(32),
  `f4` VARCHAR(32),
  `f5` VARCHAR(32),
  `degree` CHAR(1) COMMENT '数值型保留的小数位',
  `d_config` CHAR(1) COMMENT '默认是否显示字段(0/1),   1:默认显示(用户没有配置过sys_cfg_table_user对应的业务表时，列表中默认显示该字段)',
  CONSTRAINT `PK_T_COLUMN` PRIMARY KEY (`T_CODE`, `T_C_CODE`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table SYS_CFG_TABLE_LIST
-- Original Oracle primary-key constraint: PK_T_LIST (MySQL index name: PRIMARY).
CREATE TABLE `SYS_CFG_TABLE_LIST` (
  `t_code` VARCHAR(32) NOT NULL,
  `t_name` VARCHAR(64) NOT NULL,
  `isvaild` CHAR(1) NOT NULL DEFAULT '1',
  `update_time` DATETIME,
  `create_time` DATETIME,
  `f1` VARCHAR(32),
  `f2` VARCHAR(32),
  `f3` VARCHAR(32),
  `f4` VARCHAR(32),
  `f5` VARCHAR(32),
  CONSTRAINT `PK_T_LIST` PRIMARY KEY (`T_CODE`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table SYS_CFG_TABLE_USER
-- Original Oracle primary-key constraint: PK_T_USER (MySQL index name: PRIMARY).
CREATE TABLE `SYS_CFG_TABLE_USER` (
  `user_id` VARCHAR(64) NOT NULL,
  `t_code` VARCHAR(32) NOT NULL,
  `cs` VARCHAR(1000) COMMENT '列名称集合，多个列代码用,隔开',
  `isvaild` CHAR(1) NOT NULL DEFAULT '1' COMMENT '是否有效，默认1，即有效',
  `update_time` DATETIME,
  `create_time` DATETIME,
  `f1` VARCHAR(32),
  `f2` VARCHAR(32),
  `f3` VARCHAR(32),
  `f4` VARCHAR(32),
  `f5` VARCHAR(32),
  CONSTRAINT `PK_T_USER` PRIMARY KEY (`USER_ID`, `T_CODE`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table SYS_CFG_YJBMDXX
-- Original Oracle primary-key constraint: PK_YJBMDXX (MySQL index name: PRIMARY).
CREATE TABLE `SYS_CFG_YJBMDXX` (
  `swjgdm` VARCHAR(20) NOT NULL COMMENT '税务机关代码',
  `qyhgdm` VARCHAR(12) NOT NULL,
  `yjcode` VARCHAR(10) NOT NULL,
  `yj_object` VARCHAR(20) COMMENT '预警对象，目前仅支持高风险商品代码',
  `qy_date` DATETIME NOT NULL COMMENT '启用日期',
  `ty_date` DATETIME NOT NULL DEFAULT '2100-01-01 00:00:00' COMMENT '停用日期',
  `remark` VARCHAR(255),
  `qymc` VARCHAR(100),
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `is_valid` CHAR(1) COMMENT '是否有效',
  CONSTRAINT `PK_YJBMDXX` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table SYS_CFG_YJSWJGXX
-- Original Oracle primary-key constraint: YJSWJGXX_PK (MySQL index name: PRIMARY).
CREATE TABLE `SYS_CFG_YJSWJGXX` (
  `swjgdm` VARCHAR(20) NOT NULL COMMENT '税务机关代码',
  `yjcode` VARCHAR(10) NOT NULL COMMENT '预警代码',
  `is_push` CHAR(1) COMMENT '0,关闭，1，推送',
  `remark` VARCHAR(255) COMMENT '备注',
  `crtime` DATETIME,
  `uptime` DATETIME,
  `swjgmc` VARCHAR(60) COMMENT '税务机关名称',
  CONSTRAINT `YJSWJGXX_PK` PRIMARY KEY (`YJCODE`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table SYS_DICT
CREATE TABLE `SYS_DICT` (
  `id` DECIMAL(18,0) NOT NULL,
  `dtype` VARCHAR(50) NOT NULL,
  `dcode` VARCHAR(50) NOT NULL,
  `dname` VARCHAR(200) NOT NULL,
  `addon` VARCHAR(200),
  `showorder` DECIMAL(9,0),
  `note` VARCHAR(200),
  UNIQUE KEY `UQ_SYS_DICT_TC` (`DTYPE`, `DCODE`),
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table SYS_GROUP
-- Original Oracle primary-key constraint: PK_CODE (MySQL index name: PRIMARY).
CREATE TABLE `SYS_GROUP` (
  `code` VARCHAR(50) NOT NULL COMMENT '组代码',
  `parentcode` VARCHAR(20) COMMENT '父组代码',
  `name` VARCHAR(50) NOT NULL COMMENT '组名称',
  `remark` VARCHAR(50) COMMENT '备注',
  `crtime` DATETIME COMMENT '创建时间',
  `uptime` DATETIME COMMENT '更新时间',
  `operid` DECIMAL(18,0) COMMENT '操作人ID',
  `isvalid` VARCHAR(1) COMMENT '是否有效',
  CONSTRAINT `PK_CODE` PRIMARY KEY (`CODE`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='权限管理_用户组表';

-- Creating table SYS_GROUP_ROLE
-- Original Oracle primary-key constraint: PK_SYS_GROUP_ROLE (MySQL index name: PRIMARY).
CREATE TABLE `SYS_GROUP_ROLE` (
  `groupcode` VARCHAR(50) NOT NULL COMMENT '组代码',
  `rolecode` VARCHAR(50) NOT NULL COMMENT '角色代码',
  CONSTRAINT `PK_SYS_GROUP_ROLE` PRIMARY KEY (`GROUPCODE`, `ROLECODE`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='权限管理_用户组与角色关联表';

-- Creating table SYS_GROUP_USER
-- Original Oracle primary-key constraint: PK_SYS_GROUP_USER (MySQL index name: PRIMARY).
CREATE TABLE `SYS_GROUP_USER` (
  `groupcode` VARCHAR(50) NOT NULL COMMENT '组ID',
  `czyid` DECIMAL(18,0) NOT NULL COMMENT '操作员ID',
  CONSTRAINT `PK_SYS_GROUP_USER` PRIMARY KEY (`GROUPCODE`, `CZYID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='权限管理_用户组与用户关联表';

-- Creating table SYS_MSG_NSR
-- Original Oracle primary-key constraint: PK_SYS_MSG_NSR (MySQL index name: PRIMARY).
CREATE TABLE `SYS_MSG_NSR` (
  `nsrdzdah` DECIMAL(20,0) NOT NULL,
  `nsrsbh` VARCHAR(20) NOT NULL,
  `isvalid` VARCHAR(1) NOT NULL DEFAULT '1',
  `crtime` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `uptime` DATETIME,
  `type` VARCHAR(10) COMMENT '会员类型',
  CONSTRAINT `PK_SYS_MSG_NSR` PRIMARY KEY (`NSRDZDAH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table SYS_PERMISSION
-- Original Oracle primary-key constraint: PK_SYS_PREMOISSION_CODE (MySQL index name: PRIMARY).
CREATE TABLE `SYS_PERMISSION` (
  `percode` VARCHAR(50) NOT NULL COMMENT '权限代码',
  `pername` VARCHAR(50) NOT NULL COMMENT '权限描述',
  `remark` VARCHAR(50) COMMENT '备注',
  `crtime` DATETIME COMMENT '创建时间',
  `uptime` DATETIME COMMENT '更新时间',
  `operid` DECIMAL(18,0) COMMENT '操作人ID',
  `isvalid` VARCHAR(1) COMMENT '是否有效',
  `ppercode` VARCHAR(50) COMMENT '父权限代码',
  `pertype` CHAR(1) NOT NULL COMMENT 'M:菜单  F:功能',
  `showorder` DECIMAL(9,0) COMMENT '显示顺序',
  `childflag` CHAR(1) COMMENT '是否有下级',
  CONSTRAINT `PK_SYS_PREMOISSION_CODE` PRIMARY KEY (`PERCODE`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='权限管理_权限表';

-- Creating table SYS_ROLE
-- Original Oracle primary-key constraint: PK_SYS_ROLE_CODE (MySQL index name: PRIMARY).
CREATE TABLE `SYS_ROLE` (
  `rolecode` VARCHAR(50) NOT NULL COMMENT '角色代码',
  `rolename` VARCHAR(50) NOT NULL COMMENT '角色描述',
  `remark` VARCHAR(50) COMMENT '备注',
  `crtime` DATETIME COMMENT '创建时间',
  `uptime` DATETIME COMMENT '更新时间',
  `operid` DECIMAL(18,0) COMMENT '操作人ID',
  `isvalid` VARCHAR(1) COMMENT '是否有效',
  CONSTRAINT `PK_SYS_ROLE_CODE` PRIMARY KEY (`ROLECODE`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='权限管理_角色表';

-- Creating table SYS_ROLE_PERM
-- Original Oracle primary-key constraint: PK_ROLE_PER_CODE (MySQL index name: PRIMARY).
CREATE TABLE `SYS_ROLE_PERM` (
  `rolecode` VARCHAR(50) NOT NULL COMMENT '角色代码',
  `percode` VARCHAR(50) NOT NULL COMMENT '权限代码',
  CONSTRAINT `PK_ROLE_PER_CODE` PRIMARY KEY (`ROLECODE`, `PERCODE`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='权限管理_角色权限关联表';

-- Creating table SYS_SEQUENCE
-- Original Oracle primary-key constraint: PK_SYS_SEQUENCE (MySQL index name: PRIMARY).
CREATE TABLE `SYS_SEQUENCE` (
  `tblname` VARCHAR(200) NOT NULL COMMENT '数据表名称',
  `curvalue` DECIMAL(18,0) NOT NULL COMMENT '当前序列值',
  CONSTRAINT `PK_SYS_SEQUENCE` PRIMARY KEY (`TBLNAME`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='系统维护_系统序列表';

-- Creating table SYS_USER
-- Original Oracle primary-key constraint: PK_SYS_USER_ID (MySQL index name: PRIMARY).
CREATE TABLE `SYS_USER` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '主键值',
  `parentid` DECIMAL(18,0) COMMENT '父ID',
  `czry_dm` VARCHAR(20) NOT NULL COMMENT '操作人员代码',
  `czry_mc` VARCHAR(80) NOT NULL COMMENT '操作人员名称',
  `password` VARCHAR(50) COMMENT '登陆密码',
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `czry_dm_zg` VARCHAR(20) COMMENT '对应征管系统代码',
  `usrstate` CHAR(1) COMMENT '审核系统中的用户状态字段',
  `crtime` DATETIME COMMENT '创建时间',
  `crname` VARCHAR(20) COMMENT '创建人员',
  `uptime` DATETIME COMMENT '更新时间',
  `upname` VARCHAR(20) COMMENT '更新人员',
  `qybz` CHAR(1) NOT NULL COMMENT '启用标志',
  `qx_swjg` VARCHAR(200) COMMENT '权限税务机关代码',
  `yhly` CHAR(1) NOT NULL DEFAULT '0' COMMENT '默认为审核系统用户 1位自建用户',
  `lxrdh` VARCHAR(30) COMMENT '操作人员联系人电话',
  UNIQUE KEY `B_CZRY_DM` (`CZRY_DM`),
  KEY `IDX_SYS_USER_IDX1` (`SWJG_DM`),
  CONSTRAINT `PK_SYS_USER_ID` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='用户管理_用户操作员表';

-- Creating table SYS_USER_ROLE
CREATE TABLE `SYS_USER_ROLE` (
  `czyid` DECIMAL(18,0) NOT NULL COMMENT '操作员ID',
  `rolecode` VARCHAR(50) NOT NULL COMMENT '角色代码'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TB_REPORT_DATA
-- Original Oracle primary-key constraint: PK_ID (MySQL index name: PRIMARY).
CREATE TABLE `TB_REPORT_DATA` (
  `id` DECIMAL(18,0) NOT NULL,
  `sbqb` VARCHAR(6) NOT NULL,
  `value` DECIMAL(12,2),
  `sbywbdm` VARCHAR(8),
  `swjgdm` VARCHAR(11) NOT NULL,
  `valuetype` CHAR(1) COMMENT '0、笔数，1、申报金额',
  `crtime` DATETIME,
  CONSTRAINT `PK_ID` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_CS_ZBRQ
-- Original Oracle primary-key constraint: PK_TJBB_CS_ZBRQ (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_CS_ZBRQ` (
  `bbny` VARCHAR(6) NOT NULL COMMENT '报表年月',
  `bbny_ksrq` DATETIME COMMENT '报表区间——开始日期',
  `bbny_jzrq` DATETIME COMMENT '报表区间——截止日期',
  `bbny_ksnf` DATETIME COMMENT '报表区间——开始年份',
  CONSTRAINT `PK_TJBB_CS_ZBRQ` PRIMARY KEY (`BBNY`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='统计报表制表日期参数设置';

-- Creating table TJBB_CX_CKTSSHSPQK
CREATE TABLE `TJBB_CX_CKTSSHSPQK` (
  `paramhash` VARCHAR(64) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `crtime` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `bqtse_fh` DECIMAL(16,2) COMMENT '本期已复核数',
  `bqtse_hz` DECIMAL(16,2) COMMENT '本期已核准数',
  `bqtse_sp` DECIMAL(16,2) COMMENT '本期已审批数',
  `bqtse_kp` DECIMAL(16,2) COMMENT '本期已开票退税数',
  `ljtse_fh` DECIMAL(16,2) COMMENT '累计已复核数',
  `ljtse_hz` DECIMAL(16,2) COMMENT '累计已核准数',
  `ljtse_sp` DECIMAL(16,2) COMMENT '累计已审批数',
  `ljtse_kp` DECIMAL(16,2) COMMENT '累计已退税开票',
  `dqdhztse` DECIMAL(16,2) COMMENT '当前已复核待核准',
  `dqdsptse` DECIMAL(16,2) COMMENT '当前已核准待审批',
  `dqdkptse` DECIMAL(16,2) COMMENT '当前已审批待开票',
  PRIMARY KEY (`PARAMHASH`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='查询统计--出口退税审核审批办理情况';

-- Creating table TJBB_CZ_LOG
-- Original Oracle primary-key constraint: PK_TJBB_CZ_LOG (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_CZ_LOG` (
  `id` VARCHAR(64) NOT NULL,
  `swjgdm` VARCHAR(11),
  `czry` VARCHAR(20),
  `cztime` DATETIME(6),
  `czcode` VARCHAR(2),
  `cztype` CHAR(1) COMMENT '1,任务流程',
  `czobj` VARCHAR(15) COMMENT '操作对象',
  CONSTRAINT `PK_TJBB_CZ_LOG` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B01100
-- Original Oracle primary-key constraint: PK_TJBB_DT_B01100 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B01100` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `rdhs` DECIMAL(18,0) COMMENT '认定户数',
  `rdhs_hz` DECIMAL(18,0),
  `sbhs` DECIMAL(18,0) COMMENT '申报户数',
  `sbhs_hz` DECIMAL(18,0),
  `sb_cke_xj` DECIMAL(18,4) COMMENT '小计',
  `sb_cke_xj_hz` DECIMAL(18,4),
  `sb_cke_his` DECIMAL(18,4) COMMENT '以前年度出口货物申报累计',
  `sb_cke_his_hz` DECIMAL(18,4),
  `sb_cke_cur` DECIMAL(18,4) COMMENT '当年出口货物申报累计',
  `sb_cke_cur_hz` DECIMAL(18,4),
  `sb_tmse_xj` DECIMAL(18,4) COMMENT '小计',
  `sb_tmse_xj_hz` DECIMAL(18,4),
  `sb_tmse_his` DECIMAL(18,4) COMMENT '以前年度出口货物申报累计',
  `sb_tmse_his_hz` DECIMAL(18,4),
  `sb_tmse_cur` DECIMAL(18,4) COMMENT '当年出口货物申报累计',
  `sb_tmse_cur_hz` DECIMAL(18,4),
  `sh_tmse_xj` DECIMAL(18,4) COMMENT '小计',
  `sh_tmse_xj_hz` DECIMAL(18,4),
  `sh_tmse_his` DECIMAL(18,4) COMMENT '以前年度出口货物申报累计',
  `sh_tmse_his_hz` DECIMAL(18,4),
  `sh_tmse_cur` DECIMAL(18,4) COMMENT '当年出口货物申报累计',
  `sh_tmse_cur_hz` DECIMAL(18,4),
  `zh_tmse_xj` DECIMAL(18,4) COMMENT '小计',
  `zh_tmse_xj_hz` DECIMAL(18,4),
  `zh_tmse_his` DECIMAL(18,4) COMMENT '以前年度出口货物申报累计',
  `zh_tmse_his_hz` DECIMAL(18,4),
  `zh_tmse_cur` DECIMAL(18,4) COMMENT '当年出口货物申报累计',
  `zh_tmse_cur_hz` DECIMAL(18,4),
  `by_tmse_xj` DECIMAL(18,4) COMMENT '小计',
  `by_tmse_xj_hz` DECIMAL(18,4),
  `by_tmse_his` DECIMAL(18,4) COMMENT '以前年度出口货物申报累计',
  `by_tmse_his_hz` DECIMAL(18,4),
  `by_tmse_cur` DECIMAL(18,4) COMMENT '当年出口货物申报累计',
  `by_tmse_cur_hz` DECIMAL(18,4),
  `zt_tmse_xj` DECIMAL(18,4) COMMENT '小计',
  `zt_tmse_xj_hz` DECIMAL(18,4),
  `zt_tmse_his` DECIMAL(18,4) COMMENT '以前年度出口货物申报累计',
  `zt_tmse_his_hz` DECIMAL(18,4),
  `zt_tmse_cur` DECIMAL(18,4) COMMENT '当年出口货物申报累计',
  `zt_tmse_cur_hz` DECIMAL(18,4),
  `sp_tk_xj` DECIMAL(18,4) COMMENT '小计',
  `sp_tk_xj_hz` DECIMAL(18,4),
  `sp_tk_his` DECIMAL(18,4) COMMENT '以前年度出口货物申报累计',
  `sp_tk_his_hz` DECIMAL(18,4),
  `sp_tk_cur` DECIMAL(18,4) COMMENT '当年出口货物申报累计',
  `sp_tk_cur_hz` DECIMAL(18,4),
  `ys_tk` DECIMAL(18,4) COMMENT '已送交国库退（调）库额',
  `ys_tk_hz` DECIMAL(18,4),
  `ws_tk` DECIMAL(18,4) COMMENT '未送交国库退（调）库额',
  `ws_tk_hz` DECIMAL(18,4),
  `bl_tk_xj` DECIMAL(18,4) COMMENT '小计',
  `bl_tk_xj_hz` DECIMAL(18,4),
  `bl_tk_his` DECIMAL(18,4) COMMENT '以前年度出口货物申报累计',
  `bl_tk_his_hz` DECIMAL(18,4),
  `bl_tk_cur` DECIMAL(18,4) COMMENT '当年出口货物申报累计',
  `bl_tk_cur_hz` DECIMAL(18,4),
  `zt_tk` DECIMAL(18,4) COMMENT '退（调库）库在途数',
  `zt_tk_hz` DECIMAL(18,4),
  `remark` VARCHAR(400) COMMENT '备注',
  CONSTRAINT `PK_TJBB_DT_B01100` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B01101
-- Original Oracle primary-key constraint: PK_TJBB_DT_B01101 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B01101` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `hj_qyhs` DECIMAL(16,0) COMMENT '企业户数',
  `hj_qyhs_hz` DECIMAL(16,0),
  `hj_tse` DECIMAL(16,4) COMMENT '退（免）税额',
  `hj_tse_hz` DECIMAL(16,4),
  `fh_qyhs` DECIMAL(16,0) COMMENT '企业户数',
  `fh_qyhs_hz` DECIMAL(16,0),
  `fh_tse_hj` DECIMAL(16,4) COMMENT '小计',
  `fh_tse_hj_hz` DECIMAL(16,4),
  `fh_tse_his` DECIMAL(16,4) COMMENT '以前年度',
  `fh_tse_his_hz` DECIMAL(16,4),
  `fh_tse_cur` DECIMAL(16,4) COMMENT '当年出口',
  `fh_tse_cur_hz` DECIMAL(16,4),
  `hh_qyhs` DECIMAL(16,0) COMMENT '企业户数',
  `hh_qyhs_hz` DECIMAL(16,0),
  `hh_tse_hj` DECIMAL(16,4) COMMENT '小计',
  `hh_tse_hj_hz` DECIMAL(16,4),
  `hh_tse_his` DECIMAL(16,4) COMMENT '以前年度',
  `hh_tse_his_hz` DECIMAL(16,4),
  `hh_tse_cur` DECIMAL(16,4) COMMENT '当年出口',
  `hh_tse_cur_hz` DECIMAL(16,4),
  `dc_qyhs` DECIMAL(16,0) COMMENT '企业户数',
  `dc_qyhs_hz` DECIMAL(16,0),
  `dc_tse_hj` DECIMAL(16,4) COMMENT '小计',
  `dc_tse_hj_hz` DECIMAL(16,4),
  `dc_tse_his` DECIMAL(16,4) COMMENT '以前年度',
  `dc_tse_his_hz` DECIMAL(16,4),
  `dc_tse_cur` DECIMAL(16,4) COMMENT '当年出口',
  `dc_tse_cur_hz` DECIMAL(16,4),
  `yd_qyhs` DECIMAL(16,0) COMMENT '企业户数',
  `yd_qyhs_hz` DECIMAL(16,0),
  `yd_tse_hj` DECIMAL(16,4) COMMENT '小计',
  `yd_tse_hj_hz` DECIMAL(16,4),
  `yd_tse_his` DECIMAL(16,4) COMMENT '以前年度',
  `yd_tse_his_hz` DECIMAL(16,4),
  `yd_tse_cur` DECIMAL(16,4) COMMENT '当年出口',
  `yd_tse_cur_hz` DECIMAL(16,4),
  `remark` VARCHAR(400) COMMENT '备注',
  CONSTRAINT `PK_TJBB_DT_B01101` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B01102
-- Original Oracle primary-key constraint: PK_TJBB_DT_B01102 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B01102` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `hj_qyhs` DECIMAL(16,0) COMMENT '企业户数',
  `hj_qyhs_hz` DECIMAL(16,0),
  `hj_tse` DECIMAL(16,4) COMMENT '退（免）税额',
  `hj_tse_hz` DECIMAL(16,4),
  `hh_qyhs` DECIMAL(16,0) COMMENT '企业户数',
  `hh_qyhs_hz` DECIMAL(16,0),
  `hh_tse_xj` DECIMAL(16,4) COMMENT '小计',
  `hh_tse_xj_hz` DECIMAL(16,4),
  `hh_tse_his` DECIMAL(16,4) COMMENT '以前年度',
  `hh_tse_his_hz` DECIMAL(16,4),
  `hh_tse_cur` DECIMAL(16,4) COMMENT '当年出口',
  `hh_tse_cur_hz` DECIMAL(16,4),
  `ba_qyhs` DECIMAL(16,0) COMMENT '企业户数',
  `ba_qyhs_hz` DECIMAL(16,0),
  `ba_tse_xj` DECIMAL(16,4) COMMENT '小计',
  `ba_tse_xj_hz` DECIMAL(16,4),
  `ba_tse_his` DECIMAL(16,4) COMMENT '以前年度',
  `ba_tse_his_hz` DECIMAL(16,4),
  `ba_tse_cur` DECIMAL(16,4) COMMENT '当年出口',
  `ba_tse_cur_hz` DECIMAL(16,4),
  `pz_qyhs` DECIMAL(16,0) COMMENT '企业户数',
  `pz_qyhs_hz` DECIMAL(16,0),
  `pz_tse_xj` DECIMAL(16,4) COMMENT '小计',
  `pz_tse_xj_hz` DECIMAL(16,4),
  `pz_tse_his` DECIMAL(16,4) COMMENT '以前年度',
  `pz_tse_his_hz` DECIMAL(16,4),
  `pz_tse_cur` DECIMAL(16,4) COMMENT '当年出口',
  `pz_tse_cur_hz` DECIMAL(16,4),
  `dl_qyhs` DECIMAL(16,0) COMMENT '企业户数',
  `dl_qyhs_hz` DECIMAL(16,0),
  `dl_tse_xj` DECIMAL(16,4) COMMENT '小计',
  `dl_tse_xj_hz` DECIMAL(16,4),
  `dl_tse_his` DECIMAL(16,4) COMMENT '以前年度',
  `dl_tse_his_hz` DECIMAL(16,4),
  `dl_tse_cur` DECIMAL(16,4) COMMENT '当年出口',
  `dl_tse_cur_hz` DECIMAL(16,4),
  `sh_qyhs` DECIMAL(16,0) COMMENT '企业户数',
  `sh_qyhs_hz` DECIMAL(16,0),
  `sh_tse_xj` DECIMAL(16,4) COMMENT '小计',
  `sh_tse_xj_hz` DECIMAL(16,4),
  `sh_tse_his` DECIMAL(16,4) COMMENT '以前年度',
  `sh_tse_his_hz` DECIMAL(16,4),
  `sh_tse_cur` DECIMAL(16,4) COMMENT '当年出口',
  `sh_tse_cur_hz` DECIMAL(16,4),
  `dc_qyhs` DECIMAL(16,0) COMMENT '企业户数',
  `dc_qyhs_hz` DECIMAL(16,0),
  `dc_tse_xj` DECIMAL(16,4) COMMENT '小计',
  `dc_tse_xj_hz` DECIMAL(16,4),
  `dc_tse_his` DECIMAL(16,4) COMMENT '以前年度',
  `dc_tse_his_hz` DECIMAL(16,4),
  `dc_tse_cur` DECIMAL(16,4) COMMENT '当年出口',
  `dc_tse_cur_hz` DECIMAL(16,4),
  `qt_qyhs` DECIMAL(16,0) COMMENT '企业户数',
  `qt_qyhs_hz` DECIMAL(16,0),
  `qt_tse_xj` DECIMAL(16,4) COMMENT '小计',
  `qt_tse_xj_hz` DECIMAL(16,4),
  `qt_tse_his` DECIMAL(16,4) COMMENT '以前年度',
  `qt_tse_his_hz` DECIMAL(16,4),
  `qt_tse_cur` DECIMAL(16,4) COMMENT '当年出口',
  `qt_tse_cur_hz` DECIMAL(16,4),
  `remark` VARCHAR(400) COMMENT '备注',
  CONSTRAINT `PK_TJBB_DT_B01102` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B01103
-- Original Oracle primary-key constraint: PK_TJBB_DT_B01103 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B01103` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `ck_fwmy_cur` DECIMAL(16,4) COMMENT '本年出口',
  `ck_fwmy_cur_hz` DECIMAL(16,4),
  `ck_fwmy_his` DECIMAL(16,4) COMMENT '以前年度',
  `ck_fwmy_his_hz` DECIMAL(16,4),
  `ck_fwmy_xj` DECIMAL(16,4) COMMENT '小计',
  `ck_fwmy_xj_hz` DECIMAL(16,4),
  `ck_hj` DECIMAL(16,4) COMMENT '合计',
  `ck_hj_hz` DECIMAL(16,4),
  `ck_sc_cur` DECIMAL(16,4) COMMENT '本年出口',
  `ck_sc_cur_hz` DECIMAL(16,4),
  `ck_sc_his` DECIMAL(16,4) COMMENT '以前年度',
  `ck_sc_his_hz` DECIMAL(16,4),
  `ck_sc_xj` DECIMAL(16,4) COMMENT '小计',
  `ck_sc_xj_hz` DECIMAL(16,4),
  `ck_wm_cur` DECIMAL(16,4) COMMENT '本年出口',
  `ck_wm_cur_hz` DECIMAL(16,4),
  `ck_wm_his` DECIMAL(16,4) COMMENT '以前年度',
  `ck_wm_his_hz` DECIMAL(16,4),
  `ck_wm_xj` DECIMAL(16,4) COMMENT '小计',
  `ck_wm_xj_hz` DECIMAL(16,4),
  `ck_wzf_cur` DECIMAL(16,4) COMMENT '本年出口',
  `ck_wzf_cur_hz` DECIMAL(16,4),
  `ck_wzf_his` DECIMAL(16,4) COMMENT '以前年度',
  `ck_wzf_his_hz` DECIMAL(16,4),
  `ck_wzf_xj` DECIMAL(16,4) COMMENT '小计',
  `ck_wzf_xj_hz` DECIMAL(16,4),
  `cstse_fwmy_cur` DECIMAL(16,4) COMMENT '本年出口',
  `cstse_fwmy_cur_hz` DECIMAL(16,4),
  `cstse_fwmy_his` DECIMAL(16,4) COMMENT '以前年度',
  `cstse_fwmy_his_hz` DECIMAL(16,4),
  `cstse_fwmy_xj` DECIMAL(16,4) COMMENT '小计',
  `cstse_fwmy_xj_hz` DECIMAL(16,4),
  `cstse_hj` DECIMAL(16,4) COMMENT '合计',
  `cstse_hj_hz` DECIMAL(16,4),
  `cstse_sc_cur` DECIMAL(16,4) COMMENT '本年出口',
  `cstse_sc_cur_hz` DECIMAL(16,4),
  `cstse_sc_his` DECIMAL(16,4) COMMENT '以前年度',
  `cstse_sc_his_hz` DECIMAL(16,4),
  `cstse_sc_xj` DECIMAL(16,4) COMMENT '小计',
  `cstse_sc_xj_hz` DECIMAL(16,4),
  `cstse_wm_cur` DECIMAL(16,4) COMMENT '本年出口',
  `cstse_wm_cur_hz` DECIMAL(16,4),
  `cstse_wm_his` DECIMAL(16,4) COMMENT '以前年度',
  `cstse_wm_his_hz` DECIMAL(16,4),
  `cstse_wm_xj` DECIMAL(16,4) COMMENT '小计',
  `cstse_wm_xj_hz` DECIMAL(16,4),
  `cstse_wzf_cur` DECIMAL(16,4) COMMENT '本年出口',
  `cstse_wzf_cur_hz` DECIMAL(16,4),
  `cstse_wzf_his` DECIMAL(16,4) COMMENT '以前年度',
  `cstse_wzf_his_hz` DECIMAL(16,4),
  `cstse_wzf_xj` DECIMAL(16,4) COMMENT '小计',
  `cstse_wzf_xj_hz` DECIMAL(16,4),
  `hj_qyhs` DECIMAL(16,0) COMMENT '合计',
  `hj_qyhs_hz` DECIMAL(16,0),
  `qyhs_fwmy` DECIMAL(16,0) COMMENT '服务贸易',
  `qyhs_fwmy_hz` DECIMAL(16,0),
  `qyhs_sc` DECIMAL(16,0) COMMENT '生产企业',
  `qyhs_sc_hz` DECIMAL(16,0),
  `qyhs_wm` DECIMAL(16,0) COMMENT '外贸企业',
  `qyhs_wm_hz` DECIMAL(16,0),
  `qyhs_wzf` DECIMAL(16,0) COMMENT '外贸综合服务企业',
  `qyhs_wzf_hz` DECIMAL(16,0),
  `swjgmc` VARCHAR(100) COMMENT '地区',
  `tse_per_usd` DECIMAL(16,4) COMMENT '每美元退税额',
  `tse_per_usd_hz` DECIMAL(16,4),
  CONSTRAINT `PK_TJBB_DT_B01103` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B01104
-- Original Oracle primary-key constraint: PK_TJBB_DT_B01104 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B01104` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `cke_hj` DECIMAL(16,4) COMMENT '合计',
  `cke_hj_hz` DECIMAL(16,4),
  `ck_fwmy_cur` DECIMAL(16,4) COMMENT '本年出口',
  `ck_fwmy_cur_hz` DECIMAL(16,4),
  `ck_fwmy_his` DECIMAL(16,4) COMMENT '以前年度',
  `ck_fwmy_his_hz` DECIMAL(16,4),
  `ck_fwmy_xj` DECIMAL(16,4) COMMENT '小计',
  `ck_fwmy_xj_hz` DECIMAL(16,4),
  `ck_sc_cur` DECIMAL(16,4) COMMENT '本年出口',
  `ck_sc_cur_hz` DECIMAL(16,4),
  `ck_sc_his` DECIMAL(16,4) COMMENT '以前年度',
  `ck_sc_his_hz` DECIMAL(16,4),
  `ck_sc_xj` DECIMAL(16,4) COMMENT '小计',
  `ck_sc_xj_hz` DECIMAL(16,4),
  `ck_wm_cur` DECIMAL(16,4) COMMENT '本年出口',
  `ck_wm_cur_hz` DECIMAL(16,4),
  `ck_wm_his` DECIMAL(16,4) COMMENT '以前年度',
  `ck_wm_his_hz` DECIMAL(16,4),
  `ck_wm_xj` DECIMAL(16,4) COMMENT '小计',
  `ck_wm_xj_hz` DECIMAL(16,4),
  `ck_wzf_cur` DECIMAL(16,4) COMMENT '本年出口',
  `ck_wzf_cur_hz` DECIMAL(16,4),
  `ck_wzf_his` DECIMAL(16,4) COMMENT '以前年度',
  `ck_wzf_his_hz` DECIMAL(16,4),
  `ck_wzf_xj` DECIMAL(16,4) COMMENT '小计',
  `ck_wzf_xj_hz` DECIMAL(16,4),
  `cstse_fwmy_cur` DECIMAL(16,4) COMMENT '本年出口',
  `cstse_fwmy_cur_hz` DECIMAL(16,4),
  `cstse_fwmy_his` DECIMAL(16,4) COMMENT '以前年度',
  `cstse_fwmy_his_hz` DECIMAL(16,4),
  `cstse_fwmy_xj` DECIMAL(16,4) COMMENT '小计',
  `cstse_fwmy_xj_hz` DECIMAL(16,4),
  `cstse_hj` DECIMAL(16,4) COMMENT '合计',
  `cstse_hj_hz` DECIMAL(16,4),
  `cstse_sc_cur` DECIMAL(16,4) COMMENT '本年出口',
  `cstse_sc_cur_hz` DECIMAL(16,4),
  `cstse_sc_his` DECIMAL(16,4) COMMENT '以前年度',
  `cstse_sc_his_hz` DECIMAL(16,4),
  `cstse_sc_xj` DECIMAL(16,4) COMMENT '小计',
  `cstse_sc_xj_hz` DECIMAL(16,4),
  `cstse_wm_cur` DECIMAL(16,4) COMMENT '本年出口',
  `cstse_wm_cur_hz` DECIMAL(16,4),
  `cstse_wm_his` DECIMAL(16,4) COMMENT '以前年度',
  `cstse_wm_his_hz` DECIMAL(16,4),
  `cstse_wm_xj` DECIMAL(16,4) COMMENT '小计',
  `cstse_wm_xj_hz` DECIMAL(16,4),
  `cstse_wzf_cur` DECIMAL(16,4) COMMENT '本年出口',
  `cstse_wzf_cur_hz` DECIMAL(16,4),
  `cstse_wzf_his` DECIMAL(16,4) COMMENT '以前年度',
  `cstse_wzf_his_hz` DECIMAL(16,4),
  `cstse_wzf_xj` DECIMAL(16,4) COMMENT '小计',
  `cstse_wzf_xj_hz` DECIMAL(16,4),
  `qyhs_fwmy` DECIMAL(16,0) COMMENT '服务贸易',
  `qyhs_fwmy_hz` DECIMAL(16,0),
  `qyhs_hj` DECIMAL(16,0) COMMENT '合计',
  `qyhs_hj_hz` DECIMAL(16,0),
  `qyhs_sc` DECIMAL(16,0) COMMENT '生产企业',
  `qyhs_sc_hz` DECIMAL(16,0),
  `qyhs_wm` DECIMAL(16,0) COMMENT '外贸企业',
  `qyhs_wm_hz` DECIMAL(16,0),
  `qyhs_wzf` DECIMAL(16,0) COMMENT '外贸综合服务企业',
  `qyhs_wzf_hz` DECIMAL(16,0),
  `swjgmc` VARCHAR(100) COMMENT '税务机关名称',
  `tse_per_usd` DECIMAL(16,4) COMMENT '每美元退税额',
  `tse_per_usd_hz` DECIMAL(16,4),
  CONSTRAINT `PK_TJBB_DT_B01104` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B01105
-- Original Oracle primary-key constraint: PK_TJBB_DT_B01105 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B01105` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `je` DECIMAL(16,4) COMMENT '金额',
  `je_hz` DECIMAL(16,4),
  `qyhs` DECIMAL(16,0) COMMENT '企业户数',
  `qyhs_hz` DECIMAL(16,0),
  `xfs_cur` DECIMAL(16,4) COMMENT '本年出口',
  `xfs_cur_hz` DECIMAL(16,4),
  `xfs_his` DECIMAL(16,4) COMMENT '以前年度',
  `xfs_his_hz` DECIMAL(16,4),
  `xfs_xj` DECIMAL(16,4) COMMENT '小计',
  `xfs_xj_hz` DECIMAL(16,4),
  `zzs_cur` DECIMAL(16,4) COMMENT '本年出口',
  `zzs_cur_hz` DECIMAL(16,4),
  `zzs_his` DECIMAL(16,4) COMMENT '以前年度',
  `zzs_his_hz` DECIMAL(16,4),
  `zzs_xj` DECIMAL(16,4) COMMENT '小计',
  `zzs_xj_hz` DECIMAL(16,4),
  CONSTRAINT `PK_TJBB_DT_B01105` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B01106
-- Original Oracle primary-key constraint: PK_TJBB_DT_B01106 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B01106` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `ay` VARCHAR(100) COMMENT '案源',
  `byja` VARCHAR(16) COMMENT '不予接案',
  `bz` VARCHAR(200) COMMENT '备注',
  `cke` DECIMAL(16,4) COMMENT '出口额（万美元）',
  `cke_hz` DECIMAL(16,4),
  `jsdw` VARCHAR(50) COMMENT '接收单位',
  `jsr` VARCHAR(16) COMMENT '接收人',
  `jssj` DATETIME COMMENT '接收时间',
  `lasj` DATETIME COMMENT '立案时间',
  `lazt` VARCHAR(16) COMMENT '立案状态',
  `mdse` DECIMAL(16,4) COMMENT '免抵税额',
  `mdse_hz` DECIMAL(16,4),
  `nsrmc` VARCHAR(100) COMMENT '名称',
  `nsrsbh` VARCHAR(18) COMMENT '纳税人识别号',
  `spdm` VARCHAR(40) COMMENT '商品编码',
  `spmc` VARCHAR(100) COMMENT '名称',
  `sumary` VARCHAR(4000) COMMENT '案源信息摘要',
  `tmse_hj` DECIMAL(16,4) COMMENT '合计',
  `tmse_hj_hz` DECIMAL(16,4),
  `tse` DECIMAL(16,4) COMMENT '退税额',
  `tse_hz` DECIMAL(16,4),
  `xh` VARCHAR(16) COMMENT '序号',
  `xhzt` VARCHAR(16) COMMENT '销号状态',
  `ysdw` VARCHAR(50) COMMENT '移送单位',
  `ysr` VARCHAR(16) COMMENT '移送人',
  `yssj` DATETIME COMMENT '移送时间',
  `ysswh` VARCHAR(20) COMMENT '移送书文号',
  `zyay` VARCHAR(4000) COMMENT '主要案情',
  CONSTRAINT `PK_TJBB_DT_B01106` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B01107
-- Original Oracle primary-key constraint: PK_TJBB_DT_B01107 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B01107` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `gj_lv` DECIMAL(16,2) COMMENT '占全国比重（%）',
  `gj_lv_hz` DECIMAL(16,2),
  `jg_ds_city` DECIMAL(16,0) COMMENT '城市数量',
  `jg_ds_city_hz` DECIMAL(16,0),
  `jg_ds_jg` DECIMAL(16,0) COMMENT '机构数量',
  `jg_ds_jg_hz` DECIMAL(16,0),
  `jg_ds_lv` DECIMAL(16,2) COMMENT '占比（%）',
  `jg_ds_lv_hz` DECIMAL(16,2),
  `jg_hj` DECIMAL(16,0) COMMENT '本省机构数量合计',
  `jg_hj_hz` DECIMAL(16,0),
  `jg_xj_city` DECIMAL(16,0) COMMENT '县区数量',
  `jg_xj_city_hz` DECIMAL(16,0),
  `jg_xj_jg` DECIMAL(16,0) COMMENT '机构数量',
  `jg_xj_jg_hz` DECIMAL(16,0),
  `jg_xj_lv` DECIMAL(16,2) COMMENT '占比（%）',
  `jg_xj_lv_hz` DECIMAL(16,2),
  `per_se` DECIMAL(16,4) COMMENT '税额',
  `per_se_hz` DECIMAL(16,4),
  `per_se_gj` DECIMAL(16,4) COMMENT '与全国人均比较',
  `per_se_gj_hz` DECIMAL(16,4),
  `ry_ds` DECIMAL(16,0) COMMENT '人员数量',
  `ry_ds_hz` DECIMAL(16,0),
  `ry_ds_lv` DECIMAL(16,2) COMMENT '占本省比重（%）',
  `ry_ds_lv_hz` DECIMAL(16,2),
  `ry_gj_lv` DECIMAL(16,2) COMMENT '占全国比重（%）',
  `ry_gj_lv_hz` DECIMAL(16,2),
  `ry_hj` DECIMAL(16,0) COMMENT '本省人员数量合计',
  `ry_hj_hz` DECIMAL(16,0),
  `ry_xj` DECIMAL(16,0) COMMENT '人员数量',
  `ry_xj_hz` DECIMAL(16,0),
  `ry_xj_lv` DECIMAL(16,2) COMMENT '占本省比重（%）',
  `ry_xj_lv_hz` DECIMAL(16,2),
  `swjgmc` VARCHAR(40) COMMENT '税务机关名称',
  CONSTRAINT `PK_TJBB_DT_B01107` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B01108
-- Original Oracle primary-key constraint: PK_TJBB_DT_B01108 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B01108` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `rdhs` DECIMAL(16,0) COMMENT '认定户数',
  `rdhs_hz` DECIMAL(16,0),
  `rd_sb_lv` DECIMAL(16,4) COMMENT '申报户数占认定户数的比率（100%）',
  `rd_sb_lv_hz` DECIMAL(16,4),
  `sbhs` DECIMAL(16,0) COMMENT '申报户数',
  `sbhs_hz` DECIMAL(16,0),
  `sb_cke_cur` DECIMAL(16,4) COMMENT '当年出口货物申报',
  `sb_cke_cur_hz` DECIMAL(16,4),
  `sb_cke_his` DECIMAL(16,4) COMMENT '以前年度出口货物申报',
  `sb_cke_his_hz` DECIMAL(16,4),
  `sb_cke_last` DECIMAL(16,4) COMMENT '上年同期申报',
  `sb_cke_last_hz` DECIMAL(16,4),
  `sb_cke_tblv` DECIMAL(16,4) COMMENT '同比变动率（100%）',
  `sb_cke_tblv_hz` DECIMAL(16,4),
  `sb_cke_xj` DECIMAL(16,4) COMMENT '小计',
  `sb_cke_xj_hz` DECIMAL(16,4),
  `sb_tmse_cur` DECIMAL(16,4) COMMENT '当年出口货物申报',
  `sb_tmse_cur_hz` DECIMAL(16,4),
  `sb_tmse_his` DECIMAL(16,4) COMMENT '以前年度出口货物申报',
  `sb_tmse_his_hz` DECIMAL(16,4),
  `sb_tmse_last` DECIMAL(16,4) COMMENT '上年同期申报',
  `sb_tmse_last_hz` DECIMAL(16,4),
  `sb_tmse_tblv` DECIMAL(16,4) COMMENT '同比变动率（100%）',
  `sb_tmse_tblv_hz` DECIMAL(16,4),
  `sb_tmse_xj` DECIMAL(16,4) COMMENT '小计',
  `sb_tmse_xj_hz` DECIMAL(16,4),
  `sh_tmse_cur` DECIMAL(16,4) COMMENT '当年出口货物申报',
  `sh_tmse_cur_hz` DECIMAL(16,4),
  `sh_tmse_his` DECIMAL(16,4) COMMENT '以前年度出口货物申报',
  `sh_tmse_his_hz` DECIMAL(16,4),
  `sh_tmse_last` DECIMAL(16,4) COMMENT '上年同期申报',
  `sh_tmse_last_hz` DECIMAL(16,4),
  `sh_tmse_tblv` DECIMAL(16,4) COMMENT '同比变动率（100%）',
  `sh_tmse_tblv_hz` DECIMAL(16,4),
  `sh_tmse_xj` DECIMAL(16,4) COMMENT '小计',
  `sh_tmse_xj_hz` DECIMAL(16,4),
  `sp_tmse_cur` DECIMAL(16,4) COMMENT '当年出口货物申报',
  `sp_tmse_cur_hz` DECIMAL(16,4),
  `sp_tmse_his` DECIMAL(16,4) COMMENT '以前年度出口货物申报',
  `sp_tmse_his_hz` DECIMAL(16,4),
  `sp_tmse_last` DECIMAL(16,4) COMMENT '上年同期申报',
  `sp_tmse_last_hz` DECIMAL(16,4),
  `sp_tmse_tblv` DECIMAL(16,4) COMMENT '同比变动率（100%）',
  `sp_tmse_tblv_hz` DECIMAL(16,4),
  `sp_tmse_xj` DECIMAL(16,4) COMMENT '小计',
  `sp_tmse_xj_hz` DECIMAL(16,4),
  `tk_jz_his` DECIMAL(16,4) COMMENT '其中：以前年度结转',
  `tk_jz_his_hz` DECIMAL(16,4),
  `tk_last` DECIMAL(16,4) COMMENT '上年同期办理',
  `tk_last_hz` DECIMAL(16,4),
  `tk_sb_cur` DECIMAL(16,4) COMMENT '当年出口货物申报',
  `tk_sb_cur_hz` DECIMAL(16,4),
  `tk_sb_his` DECIMAL(16,4) COMMENT '以前年度出口货物申报',
  `tk_sb_his_hz` DECIMAL(16,4),
  `tk_tblv` DECIMAL(16,4) COMMENT '同比变动率（100%）',
  `tk_tblv_hz` DECIMAL(16,4),
  `tk_wbl_his` DECIMAL(16,4) COMMENT '其中：以前年度已审批未办理退库',
  `tk_wbl_his_hz` DECIMAL(16,4),
  `tk_xj` DECIMAL(16,4) COMMENT '小计',
  `tk_xj_hz` DECIMAL(16,4),
  CONSTRAINT `PK_TJBB_DT_B01108` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B01109
-- Original Oracle primary-key constraint: PK_TJBB_DT_B01109 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B01109` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `rdhs` DECIMAL(16,0) COMMENT '认定户数',
  `rdhs_hz` DECIMAL(16,0),
  `rd_sb_lv` DECIMAL(16,4) COMMENT '申报户数占认定户数的比率（100%）',
  `rd_sb_lv_hz` DECIMAL(16,4),
  `sbhs` DECIMAL(16,0) COMMENT '申报户数',
  `sbhs_hz` DECIMAL(16,0),
  `sb_cke_cur` DECIMAL(16,4) COMMENT '当年出口货物申报',
  `sb_cke_cur_hz` DECIMAL(16,4),
  `sb_cke_his` DECIMAL(16,4) COMMENT '以前年度出口货物申报',
  `sb_cke_his_hz` DECIMAL(16,4),
  `sb_cke_last` DECIMAL(16,4) COMMENT '上年同期申报',
  `sb_cke_last_hz` DECIMAL(16,4),
  `sb_cke_tblv` DECIMAL(16,4) COMMENT '同比变动率（100%）',
  `sb_cke_tblv_hz` DECIMAL(16,4),
  `sb_cke_xj` DECIMAL(16,4) COMMENT '小计',
  `sb_cke_xj_hz` DECIMAL(16,4),
  `sb_tmse_cur` DECIMAL(16,4) COMMENT '当年出口货物申报',
  `sb_tmse_cur_hz` DECIMAL(16,4),
  `sb_tmse_his` DECIMAL(16,4) COMMENT '以前年度出口货物申报',
  `sb_tmse_his_hz` DECIMAL(16,4),
  `sb_tmse_last` DECIMAL(16,4) COMMENT '上年同期申报',
  `sb_tmse_last_hz` DECIMAL(16,4),
  `sb_tmse_tblv` DECIMAL(16,4) COMMENT '同比变动率（100%）',
  `sb_tmse_tblv_hz` DECIMAL(16,4),
  `sb_tmse_xj` DECIMAL(16,4) COMMENT '小计',
  `sb_tmse_xj_hz` DECIMAL(16,4),
  `sh_tmse_cur` DECIMAL(16,4) COMMENT '当年出口货物申报',
  `sh_tmse_cur_hz` DECIMAL(16,4),
  `sh_tmse_his` DECIMAL(16,4) COMMENT '以前年度出口货物申报',
  `sh_tmse_his_hz` DECIMAL(16,4),
  `sh_tmse_last` DECIMAL(16,4) COMMENT '上年同期申报',
  `sh_tmse_last_hz` DECIMAL(16,4),
  `sh_tmse_tblv` DECIMAL(16,4) COMMENT '同比变动率（100%）',
  `sh_tmse_tblv_hz` DECIMAL(16,4),
  `sh_tmse_xj` DECIMAL(16,4) COMMENT '小计',
  `sh_tmse_xj_hz` DECIMAL(16,4),
  `sp_tmse_cur` DECIMAL(16,4) COMMENT '当年出口货物申报',
  `sp_tmse_cur_hz` DECIMAL(16,4),
  `sp_tmse_his` DECIMAL(16,4) COMMENT '以前年度出口货物申报',
  `sp_tmse_his_hz` DECIMAL(16,4),
  `sp_tmse_last` DECIMAL(16,4) COMMENT '上年同期申报',
  `sp_tmse_last_hz` DECIMAL(16,4),
  `sp_tmse_tblv` DECIMAL(16,4) COMMENT '同比变动率（100%）',
  `sp_tmse_tblv_hz` DECIMAL(16,4),
  `sp_tmse_xj` DECIMAL(16,4) COMMENT '小计',
  `sp_tmse_xj_hz` DECIMAL(16,4),
  `tk_jz_his` DECIMAL(16,4) COMMENT '其中：以前年度结转',
  `tk_jz_his_hz` DECIMAL(16,4),
  `tk_last` DECIMAL(16,4) COMMENT '上年同期办理',
  `tk_last_hz` DECIMAL(16,4),
  `tk_sb_cur` DECIMAL(16,4) COMMENT '当年出口货物申报',
  `tk_sb_cur_hz` DECIMAL(16,4),
  `tk_sb_his` DECIMAL(16,4) COMMENT '以前年度出口货物申报',
  `tk_sb_his_hz` DECIMAL(16,4),
  `tk_tblv` DECIMAL(16,4) COMMENT '同比变动率（100%）',
  `tk_tblv_hz` DECIMAL(16,4),
  `tk_wbl_his` DECIMAL(16,4) COMMENT '其中：以前年度已审批未办理退库',
  `tk_wbl_his_hz` DECIMAL(16,4),
  `tk_xj` DECIMAL(16,4) COMMENT '小计',
  `tk_xj_hz` DECIMAL(16,4),
  CONSTRAINT `PK_TJBB_DT_B01109` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B02101
-- Original Oracle primary-key constraint: PK_TJBB_DT_B02101 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B02101` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `bahs_hj` DECIMAL(16,0) COMMENT '已备案数',
  `bahs_hj_hz` DECIMAL(16,0),
  `bahs_hj_add` DECIMAL(16,0) COMMENT '其中：本年新增数',
  `bahs_hj_add_hz` DECIMAL(16,0),
  `bahs_sc` DECIMAL(16,0) COMMENT '已备案数',
  `bahs_sc_hz` DECIMAL(16,0),
  `bahs_sc_add` DECIMAL(16,0) COMMENT '其中：本年新增数',
  `bahs_sc_add_hz` DECIMAL(16,0),
  `bahs_wm` DECIMAL(16,0) COMMENT '已备案数',
  `bahs_wm_hz` DECIMAL(16,0),
  `bahs_wm_add` DECIMAL(16,0) COMMENT '其中：本年新增数',
  `bahs_wm_add_hz` DECIMAL(16,0),
  `bl_tmse_hj` DECIMAL(16,4) COMMENT '本年办理的退（免）税额',
  `bl_tmse_hj_hz` DECIMAL(16,4),
  `qyhs_tmse` DECIMAL(16,0) COMMENT '本年有退（免）税申报业务的出口企业户数',
  `qyhs_tmse_hz` DECIMAL(16,0),
  `sbhs_hj_mon` DECIMAL(16,0) COMMENT '本期数',
  `sbhs_hj_mon_hz` DECIMAL(16,0),
  `sbhs_hj_year` DECIMAL(16,0) COMMENT '本年累计数',
  `sbhs_hj_year_hz` DECIMAL(16,0),
  `sbhs_sc_mon` DECIMAL(16,0) COMMENT '本期数',
  `sbhs_sc_mon_hz` DECIMAL(16,0),
  `sbhs_sc_year` DECIMAL(16,0) COMMENT '本年累计数',
  `sbhs_sc_year_hz` DECIMAL(16,0),
  `sbhs_wm_mon` DECIMAL(16,0) COMMENT '本期数',
  `sbhs_wm_mon_hz` DECIMAL(16,0),
  `sbhs_wm_year` DECIMAL(16,0) COMMENT '本年累计数',
  `sbhs_wm_year_hz` DECIMAL(16,0),
  `sb_tmse_hj` DECIMAL(16,4) COMMENT '本年全部出口企业申报退（免）税额',
  `sb_tmse_hj_hz` DECIMAL(16,4),
  `sddwdm` VARCHAR(18) COMMENT '试点单位代码',
  `sdsj` VARCHAR(64) COMMENT '试点开始时间',
  `sdsw` VARCHAR(64) COMMENT '试点单位',
  `wzhbl_tmse_mon` DECIMAL(16,4) COMMENT '本期数',
  `wzhbl_tmse_mon_hz` DECIMAL(16,4),
  `wzhbl_tmse_year` DECIMAL(16,4) COMMENT '本年累计数',
  `wzhbl_tmse_year_hz` DECIMAL(16,4),
  `wzhsb_tmse_mon` DECIMAL(16,4) COMMENT '本期数',
  `wzhsb_tmse_mon_hz` DECIMAL(16,4),
  `wzhsb_tmse_year` DECIMAL(16,4) COMMENT '本年累计数',
  `wzhsb_tmse_year_hz` DECIMAL(16,4),
  CONSTRAINT `PK_TJBB_DT_B02101` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B02102
-- Original Oracle primary-key constraint: PK_TJBB_DT_B02102 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B02102` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `tssd_sl` DECIMAL(16,0) COMMENT '退税商店数量',
  `tssd_sl_hz` DECIMAL(16,0),
  `sqrs` DECIMAL(16,0) COMMENT '申请开具离境退税申请单人数',
  `sqrs_hz` DECIMAL(16,0),
  `sqdfs` DECIMAL(16,0) COMMENT '开具离境退税申请单份数',
  `sqdfs_hz` DECIMAL(16,0),
  `sqje` DECIMAL(16,4) COMMENT '涉及金额（万元）',
  `blrs` DECIMAL(16,0) COMMENT '申请退税人数',
  `blrs_hz` DECIMAL(16,0),
  `blje` DECIMAL(16,4) COMMENT '办理退税金额（万元）',
  `blje_hz` DECIMAL(16,4),
  `zytssp` VARCHAR(400) COMMENT '主要退税商品',
  `sqje_hz` DECIMAL(16,4),
  CONSTRAINT `PK_TJBB_DT_B02102` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B02103
-- Original Oracle primary-key constraint: PK_TJBB_DT_B02103 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B02103` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `bahs` DECIMAL(16,0) COMMENT '备案户数',
  `bahs_hz` DECIMAL(16,0),
  `bl_mdse` DECIMAL(16,4) COMMENT '免抵税额',
  `bl_mdse_hz` DECIMAL(16,4),
  `bl_tmse` DECIMAL(16,4) COMMENT '退（免）税额',
  `bl_tmse_hz` DECIMAL(16,4),
  `bl_tse` DECIMAL(16,4) COMMENT '退税额',
  `bl_tse_hz` DECIMAL(16,4),
  `sbhs` DECIMAL(16,0) COMMENT '申报户数',
  `sbhs_hz` DECIMAL(16,0),
  `sbtscke` DECIMAL(16,4) COMMENT '申报退税出口额（万美元）',
  `sbtscke_hz` DECIMAL(16,4),
  `sb_mdse` DECIMAL(16,4) COMMENT '免抵税额',
  `sb_mdse_hz` DECIMAL(16,4),
  `sb_tmse` DECIMAL(16,4) COMMENT '退（免）税额',
  `sb_tmse_hz` DECIMAL(16,4),
  `sb_tse` DECIMAL(16,4) COMMENT '退税额',
  `sb_tse_hz` DECIMAL(16,4),
  `sh_mdse` DECIMAL(16,4) COMMENT '免抵税额',
  `sh_mdse_hz` DECIMAL(16,4),
  `sh_tmse` DECIMAL(16,4) COMMENT '退（免）税额',
  `sh_tmse_hz` DECIMAL(16,4),
  `sh_tse` DECIMAL(16,4) COMMENT '退税额',
  `sh_tse_hz` DECIMAL(16,4),
  `zysp` VARCHAR(400) COMMENT '主要退税商品',
  CONSTRAINT `PK_TJBB_DT_B02103` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B02104
-- Original Oracle primary-key constraint: PK_TJBB_DT_B02104 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B02104` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `bahs` DECIMAL(16,0) COMMENT '市场经营户备案户数',
  `bahs_hz` DECIMAL(16,0),
  `sbhs` DECIMAL(16,0) COMMENT '市场采购贸易经营者申报户数',
  `sbhs_hz` DECIMAL(16,0),
  `sbtscke` DECIMAL(16,4) COMMENT '申报免税出口额（万美元）',
  `sbtscke_hz` DECIMAL(16,4),
  `zysp` VARCHAR(400) COMMENT '主要商品',
  CONSTRAINT `PK_TJBB_DT_B02104` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B02105
-- Original Oracle primary-key constraint: PK_TJBB_DT_B02105 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B02105` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `gkbl_tke_his` DECIMAL(16,4) COMMENT '以前年度出口货物申报累计',
  `gkbl_tke_his_hz` DECIMAL(16,4),
  `gkbl_tke_xj` DECIMAL(16,4) COMMENT '小计',
  `gkbl_tke_xj_hz` DECIMAL(16,4),
  `gkbl_tke_year` DECIMAL(16,4) COMMENT '当年出口货物申报累计',
  `gkbl_tke_year_hz` DECIMAL(16,4),
  `remark` VARCHAR(200) COMMENT '备注',
  `sbhs` DECIMAL(16,0) COMMENT '申报户数',
  `sbhs_hz` DECIMAL(16,0),
  `sblj_tmse_his` DECIMAL(16,4) COMMENT '以前年度出口货物申报累计',
  `sblj_tmse_his_hz` DECIMAL(16,4),
  `sblj_tmse_year` DECIMAL(16,4) COMMENT '当年出口货物申报累计',
  `sblj_tmse_year_hz` DECIMAL(16,4),
  `sblj_tscke_his` DECIMAL(16,4) COMMENT '以前年度出口货物申报累计',
  `sblj_tscke_his_hz` DECIMAL(16,4),
  `sblj_tscke_year` DECIMAL(16,4) COMMENT '当年出口货物申报累计',
  `sblj_tscke_year_hz` DECIMAL(16,4),
  `sb_tmse_xj` DECIMAL(16,4) COMMENT '小计',
  `sb_tmse_xj_hz` DECIMAL(16,4),
  `sb_tscke_xj` DECIMAL(16,4) COMMENT '小计',
  `sb_tscke_xj_hz` DECIMAL(16,4),
  `shby_tmse_his` DECIMAL(16,4) COMMENT '以前年度出口货物申报累计',
  `shby_tmse_his_hz` DECIMAL(16,4),
  `shby_tmse_xj` DECIMAL(16,4) COMMENT '小计',
  `shby_tmse_xj_hz` DECIMAL(16,4),
  `shby_tmse_year` DECIMAL(16,4) COMMENT '当年出口货物申报累计',
  `shby_tmse_year_hz` DECIMAL(16,4),
  `shlj_tmse_his` DECIMAL(16,4) COMMENT '以前年度出口货物申报累计',
  `shlj_tmse_his_hz` DECIMAL(16,4),
  `shlj_tmse_year` DECIMAL(16,4) COMMENT '当年出口货物申报累计',
  `shlj_tmse_year_hz` DECIMAL(16,4),
  `shzt_tmse_his` DECIMAL(16,4) COMMENT '以前年度出口货物申报累计',
  `shzt_tmse_his_hz` DECIMAL(16,4),
  `shzt_tmse_xj` DECIMAL(16,4) COMMENT '小计',
  `shzt_tmse_xj_hz` DECIMAL(16,4),
  `shzt_tmse_year` DECIMAL(16,4) COMMENT '当年出口货物申报累计',
  `shzt_tmse_year_hz` DECIMAL(16,4),
  `sh_tmse_xj` DECIMAL(16,4) COMMENT '小计',
  `sh_tmse_xj_hz` DECIMAL(16,4),
  `sptk_tke_his` DECIMAL(16,4) COMMENT '以前年度出口货物申报累计',
  `sptk_tke_his_hz` DECIMAL(16,4),
  `sptk_tke_xj` DECIMAL(16,4) COMMENT '小计',
  `sptk_tke_xj_hz` DECIMAL(16,4),
  `sptk_tke_year` DECIMAL(16,4) COMMENT '当年出口货物申报累计',
  `sptk_tke_year_hz` DECIMAL(16,4),
  `ysgk_tke` DECIMAL(16,4) COMMENT '已送交国库退（调）库额',
  `ysgk_tke_hz` DECIMAL(16,4),
  `zt_tke` DECIMAL(16,4) COMMENT '退（调）库在途数',
  `zt_tke_hz` DECIMAL(16,4),
  CONSTRAINT `PK_TJBB_DT_B02105` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B02106
-- Original Oracle primary-key constraint: PK_TJBB_DT_B02106 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B02106` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `bahs_dbts` DECIMAL(16,0) COMMENT '备案代办退税生产企业户数',
  `bahs_dbts_hz` DECIMAL(16,0),
  `bahs_zfqy` DECIMAL(16,0) COMMENT '备案综服企业户数',
  `bahs_zfqy_hz` DECIMAL(16,0),
  `bybl_tse` DECIMAL(16,4) COMMENT '不予办理退税额',
  `bybl_tse_hz` DECIMAL(16,4),
  `gkbl_tke` DECIMAL(16,4) COMMENT '国库已办理退（调）库额',
  `gkbl_tke_hz` DECIMAL(16,4),
  `remark` VARCHAR(200) COMMENT '备注',
  `sbhs_dbts` DECIMAL(16,0) COMMENT '代办退税生产企业户数',
  `sbhs_dbts_hz` DECIMAL(16,0),
  `sbhs_zfqy` DECIMAL(16,0) COMMENT '综服企业申报户数',
  `sbhs_zfqy_hz` DECIMAL(16,0),
  `shtg_tse` DECIMAL(16,4) COMMENT '审核通过应退税额',
  `shtg_tse_hz` DECIMAL(16,4),
  `shzt_tse` DECIMAL(16,4) COMMENT '审核在途数',
  `shzt_tse_hz` DECIMAL(16,4),
  `spyt_tke` DECIMAL(16,4) COMMENT '审批应退（调）库额',
  `spyt_tke_hz` DECIMAL(16,4),
  `tscke` DECIMAL(16,4) COMMENT '退税出口额 (万美元)',
  `tscke_hz` DECIMAL(16,4),
  `tse` DECIMAL(16,4) COMMENT '退税额',
  `tse_hz` DECIMAL(16,4),
  `wsgk_tke` DECIMAL(16,4) COMMENT '未送交国库退（调）库额',
  `wsgk_tke_hz` DECIMAL(16,4),
  `ysgk_tke` DECIMAL(16,4) COMMENT '已送交国库退（调）库额',
  `ysgk_tke_hz` DECIMAL(16,4),
  `zhbl_tse` DECIMAL(16,4) COMMENT '暂缓办理退税额',
  `zhbl_tse_hz` DECIMAL(16,4),
  `zt_tke` DECIMAL(16,4) COMMENT '退（调库）库在途数',
  `zt_tke_hz` DECIMAL(16,4),
  CONSTRAINT `PK_TJBB_DT_B02106` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B02107
-- Original Oracle primary-key constraint: PK_TJBB_DT_B02107 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B02107` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `djrq` DATETIME COMMENT '税务登记时间',
  `jsjdjdm` VARCHAR(20) COMMENT '技术监督局代码',
  `jydz` VARCHAR(200) COMMENT '企业经营地址',
  `jyzlx` VARCHAR(20) COMMENT '经营者类型',
  `nsrmc` VARCHAR(100) COMMENT '纳税人名称',
  `nsrsbh` VARCHAR(20) COMMENT '外贸综合服务企业纳税人识别号',
  `nsrzt` VARCHAR(10) COMMENT '纳税人状态',
  `qyfddbr` VARCHAR(100) COMMENT '企业法定代表人',
  `qyfr_zjlx` VARCHAR(20) COMMENT '企业法人证件类型',
  `qyhgdm` VARCHAR(18) COMMENT '企业海关代码',
  `rdrq_ckts` DATETIME COMMENT '出口退税认定时间',
  `rdrq_ybnsr` DATETIME COMMENT '一般纳税人认定时间',
  `xh` VARCHAR(16) COMMENT '序号',
  `zcdz` VARCHAR(200) COMMENT '企业注册地址',
  `zclx` VARCHAR(50) COMMENT '注册类型',
  `zjhm` VARCHAR(18) COMMENT '企业法人证件号码',
  CONSTRAINT `PK_TJBB_DT_B02107` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B02108
-- Original Oracle primary-key constraint: PK_TJBB_DT_B02108 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B02108` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `xh` VARCHAR(16) COMMENT '序号',
  `nsrmc` VARCHAR(100) COMMENT '名称',
  `nsrsbh` VARCHAR(18) COMMENT '纳税人识别号',
  `sb_cke_mon` DECIMAL(16,4) COMMENT '当月',
  `sb_cke_mon_hz` DECIMAL(16,4),
  `sb_cke_year` DECIMAL(16,4) COMMENT '本年累计',
  `sb_cke_year_hz` DECIMAL(16,4),
  `sb_cke13_mon` DECIMAL(16,4) COMMENT '当月',
  `sb_cke13_mon_hz` DECIMAL(16,4),
  `sb_cke13_year` DECIMAL(16,4) COMMENT '本年累计',
  `sb_cke13_year_hz` DECIMAL(16,4),
  `sb_tse_mon` DECIMAL(16,4) COMMENT '当月',
  `sb_tse_mon_hz` DECIMAL(16,4),
  `sb_tse_year` DECIMAL(16,4) COMMENT '本年累计',
  `sb_tse_year_hz` DECIMAL(16,4),
  `sb_tse13_mon` DECIMAL(16,4) COMMENT '当月',
  `sb_tse13_mon_hz` DECIMAL(16,4),
  `sb_tse13_year` DECIMAL(16,4) COMMENT '本年累计',
  `sb_tse13_year_hz` DECIMAL(16,4),
  `sh_tse_mon` DECIMAL(16,4) COMMENT '当月',
  `sh_tse_mon_hz` DECIMAL(16,4),
  `sh_tse_year` DECIMAL(16,4) COMMENT '本年累计',
  `sh_tse_year_hz` DECIMAL(16,4),
  `sh_tse13_mon` DECIMAL(16,4) COMMENT '当月',
  `sh_tse13_mon_hz` DECIMAL(16,4),
  `sh_tse13_year` DECIMAL(16,4) COMMENT '本年累计',
  `sh_tse13_year_hz` DECIMAL(16,4),
  `shzt_tse_xj` DECIMAL(16,4) COMMENT '小计',
  `shzt_tse_xj_hz` DECIMAL(16,4),
  `shzt_tse13_xj` DECIMAL(16,4) COMMENT '符合13号公告规定业务',
  `shzt_tse13_xj_hz` DECIMAL(16,4),
  `bybl_tse_mon` DECIMAL(16,4) COMMENT '当月',
  `bybl_tse_mon_hz` DECIMAL(16,4),
  `bybl_tse_year` DECIMAL(16,4) COMMENT '本年累计',
  `bybl_tse_year_hz` DECIMAL(16,4),
  `bybl_tse13_mon` DECIMAL(16,4) COMMENT '当月',
  `bybl_tse13_mon_hz` DECIMAL(16,4),
  `bybl_tse13_year` DECIMAL(16,4) COMMENT '本年累计',
  `bybl_tse13_year_hz` DECIMAL(16,4),
  `sp_tse_mon` DECIMAL(16,4) COMMENT '当月',
  `sp_tse_mon_hz` DECIMAL(16,4),
  `sp_tse_year` DECIMAL(16,4) COMMENT '本年累计',
  `sp_tse_year_hz` DECIMAL(16,4),
  `ys_tke_year` DECIMAL(16,4) COMMENT '已送交国库退库额',
  `ys_tke_year_hz` DECIMAL(16,4),
  `ws_tke_year` DECIMAL(16,4) COMMENT '未送交国库退库额',
  `ws_tke_year_hz` DECIMAL(16,4),
  `bl_tke_year` DECIMAL(16,4) COMMENT '国库已办理退库额',
  `bl_tke_year_hz` DECIMAL(16,4),
  `remark` VARCHAR(200) COMMENT '备注',
  `zt_tke_year` DECIMAL(16,4) COMMENT '退库在途数',
  `zt_tke_year_hz` DECIMAL(16,4),
  CONSTRAINT `PK_TJBB_DT_B02108` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B02109
-- Original Oracle primary-key constraint: PK_TJBB_DT_B02109 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B02109` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `xh` VARCHAR(16) COMMENT '序号',
  `nsrsbh` VARCHAR(20) COMMENT '供货企业纳税人识别号',
  `qymc` VARCHAR(80) COMMENT '供货企业名称',
  `jsje_mon` DECIMAL(16,4) COMMENT '当月',
  `jsje_mon_hz` DECIMAL(16,4),
  `jsje_year` DECIMAL(16,4) COMMENT '本年累计',
  `jsje_year_hz` DECIMAL(16,4),
  `sbtse_mon` DECIMAL(16,4) COMMENT '当月',
  `sbtse_mon_hz` DECIMAL(16,4),
  `sbtse_year` DECIMAL(16,4) COMMENT '本年累计',
  `sbtse_year_hz` DECIMAL(16,4),
  `sphgdms` VARCHAR(40) COMMENT '主要商品海关代码',
  `qyhgdm` VARCHAR(20) COMMENT '外贸综合服务企业海关代码',
  CONSTRAINT `PK_TJBB_DT_B02109` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B02110
-- Original Oracle primary-key constraint: PK_TJBB_DT_B02110 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B02110` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `bys` DECIMAL(16,4) COMMENT '本月数',
  `bys_hz` DECIMAL(16,4),
  `ljs` DECIMAL(16,4) COMMENT '累计数',
  `ljs_hz` DECIMAL(16,4),
  `syljs` DECIMAL(16,4) COMMENT '上月累计数',
  `syljs_hz` DECIMAL(16,4),
  `remark` VARCHAR(1000) COMMENT '备注',
  CONSTRAINT `PK_TJBB_DT_B02110` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B02111
-- Original Oracle primary-key constraint: PK_TJBB_DT_B02111 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B02111` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `bgck_hs` DECIMAL(16,0) COMMENT '户数',
  `bgck_hs_hz` DECIMAL(16,0),
  `bgck_je` DECIMAL(16,4) COMMENT '金额',
  `bgck_je_hz` DECIMAL(16,4),
  `cktms_hs` DECIMAL(16,0) COMMENT '户数',
  `cktms_hs_hz` DECIMAL(16,0),
  `cktms_je` DECIMAL(16,4) COMMENT '金额',
  `cktms_je_hz` DECIMAL(16,4),
  `qjny` VARCHAR(16) COMMENT '期间（年/月）',
  `wpms_cke_hs` DECIMAL(16,0) COMMENT '户数',
  `wpms_cke_hs_hz` DECIMAL(16,0),
  `wpms_cke_je` DECIMAL(16,4) COMMENT '金额',
  `wpms_cke_je_hz` DECIMAL(16,4),
  `xfsms_cke` DECIMAL(16,4) COMMENT '消费税免税出口额',
  `xfsms_cke_hz` DECIMAL(16,4),
  `zzsms_cke` DECIMAL(16,4) COMMENT '增值税免税出口额',
  `zzsms_cke_hz` DECIMAL(16,4),
  CONSTRAINT `PK_TJBB_DT_B02111` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B02112
-- Original Oracle primary-key constraint: PK_TJBB_DT_B02112 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B02112` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `bahs` DECIMAL(16,0) COMMENT '备案户数',
  `bahs_hz` DECIMAL(16,0),
  `bl_mdse` DECIMAL(16,4) COMMENT '免抵税额',
  `bl_mdse_hz` DECIMAL(16,4),
  `bl_tmse` DECIMAL(16,4) COMMENT '退（免）税额',
  `bl_tmse_hz` DECIMAL(16,4),
  `bl_tse` DECIMAL(16,4) COMMENT '退税额',
  `bl_tse_hz` DECIMAL(16,4),
  `sbhs` DECIMAL(16,4) COMMENT '申报户数',
  `sbhs_hz` DECIMAL(16,4),
  `sbtscke` DECIMAL(16,4) COMMENT '申报退税出口额（万美元）',
  `sbtscke_hz` DECIMAL(16,4),
  `sb_mdse` DECIMAL(16,4) COMMENT '免抵税额',
  `sb_mdse_hz` DECIMAL(16,4),
  `sb_tmse` DECIMAL(16,4) COMMENT '退（免）税额',
  `sb_tmse_hz` DECIMAL(16,4),
  `sb_tse` DECIMAL(16,4) COMMENT '退税额',
  `sb_tse_hz` DECIMAL(16,4),
  `sh_mdse` DECIMAL(16,4) COMMENT '免抵税额',
  `sh_mdse_hz` DECIMAL(16,4),
  `sh_tmse` DECIMAL(16,4) COMMENT '退（免）税额',
  `sh_tmse_hz` DECIMAL(16,4),
  `sh_tse` DECIMAL(16,4) COMMENT '退税额',
  `sh_tse_hz` DECIMAL(16,4),
  `zysp` VARCHAR(400) COMMENT '主要退税商品',
  CONSTRAINT `PK_TJBB_DT_B02112` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B02113
-- Original Oracle primary-key constraint: PK_TJBB_DT_B02113 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B02113` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `bahs` DECIMAL(16,0) COMMENT '备案户数',
  `bahs_hz` DECIMAL(16,0),
  `bl_mdse` DECIMAL(16,4) COMMENT '免抵税额',
  `bl_mdse_hz` DECIMAL(16,4),
  `bl_tmse` DECIMAL(16,4) COMMENT '退（免）税额',
  `bl_tmse_hz` DECIMAL(16,4),
  `bl_tse` DECIMAL(16,4) COMMENT '退税额',
  `bl_tse_hz` DECIMAL(16,4),
  `sbhs` DECIMAL(16,0) COMMENT '申报户数',
  `sbhs_hz` DECIMAL(16,0),
  `sbtscke` DECIMAL(16,4) COMMENT '申报退税出口额（万美元）',
  `sbtscke_hz` DECIMAL(16,4),
  `sb_mdse` DECIMAL(16,4) COMMENT '免抵税额',
  `sb_mdse_hz` DECIMAL(16,4),
  `sb_tmse` DECIMAL(16,4) COMMENT '退（免）税额',
  `sb_tmse_hz` DECIMAL(16,4),
  `sb_tse` DECIMAL(16,4) COMMENT '退税额',
  `sb_tse_hz` DECIMAL(16,4),
  `sh_mdse` DECIMAL(16,4) COMMENT '免抵税额',
  `sh_mdse_hz` DECIMAL(16,4),
  `sh_tmse` DECIMAL(16,4) COMMENT '退（免）税额',
  `sh_tmse_hz` DECIMAL(16,4),
  `sh_tse` DECIMAL(16,4) COMMENT '退税额',
  `sh_tse_hz` DECIMAL(16,4),
  `zysp` VARCHAR(400) COMMENT '主要退税商品',
  CONSTRAINT `PK_TJBB_DT_B02113` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B02114
-- Original Oracle primary-key constraint: PK_TJBB_DT_B02114 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B02114` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `xh` VARCHAR(16) COMMENT '序号',
  `nsrmc` VARCHAR(100) COMMENT '名称',
  `nsrsbh` VARCHAR(18) COMMENT '纳税人识别号',
  `sb_cke_mon` DECIMAL(16,4) COMMENT '当月',
  `sb_cke_year` DECIMAL(16,4) COMMENT '本年累计',
  `sb_cke35_mon` DECIMAL(16,4) COMMENT '当月',
  `sb_cke35_year` DECIMAL(16,4) COMMENT '本年累计',
  `sb_tse_mon` DECIMAL(16,4) COMMENT '当月',
  `sb_tse_year` DECIMAL(16,4) COMMENT '本年累计',
  `sb_tse35_mon` DECIMAL(16,4) COMMENT '当月',
  `sb_tse35_year` DECIMAL(16,4) COMMENT '本年累计',
  `sh_tse_mon` DECIMAL(16,4) COMMENT '当月',
  `sh_tse_year` DECIMAL(16,4) COMMENT '本年累计',
  `sh_tse35_mon` DECIMAL(16,4) COMMENT '当月',
  `sh_tse35_year` DECIMAL(16,4) COMMENT '本年累计',
  `shzt_tse_xj` DECIMAL(16,4) COMMENT '小计',
  `shzt_tse35_xj` DECIMAL(16,4) COMMENT '符合35号公告规定业务',
  `bybl_tse_mon` DECIMAL(16,4) COMMENT '当月',
  `bybl_tse_year` DECIMAL(16,4) COMMENT '本年累计',
  `bybl_tse35_mon` DECIMAL(16,4) COMMENT '当月',
  `bybl_tse35_year` DECIMAL(16,4) COMMENT '本年累计',
  `sp_tse_mon` DECIMAL(16,4) COMMENT '当月',
  `sp_tse_year` DECIMAL(16,4) COMMENT '本年累计',
  `sp_tse35_mon` DECIMAL(16,4) COMMENT '当月',
  `sp_tse35_year` DECIMAL(16,4) COMMENT '本年累计',
  `ys_tke_year` DECIMAL(16,4) COMMENT '已送交国库退库额',
  `ys_tke35_year` DECIMAL(16,4) COMMENT '已送交国库退库额',
  `ws_tke_year` DECIMAL(16,4) COMMENT '未送交国库退库额',
  `ws_tke35_year` DECIMAL(16,4) COMMENT '未送交国库退库额',
  `bl_tke_year` DECIMAL(16,4) COMMENT '国库已办理退库额',
  `bl_tke35_year` DECIMAL(16,4) COMMENT '国库已办理退库额',
  `zt_tke_year` DECIMAL(16,4) COMMENT '退库在途数',
  `zt_tke35_year` DECIMAL(16,4) COMMENT '退库在途数',
  `remark` VARCHAR(200) COMMENT '备注',
  CONSTRAINT `PK_TJBB_DT_B02114` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B03101
-- Original Oracle primary-key constraint: PK_TJBB_DT_B03101 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B03101` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `jan` DECIMAL(16,4) COMMENT '1月',
  `jan_hz` DECIMAL(16,4),
  `feb` DECIMAL(16,4) COMMENT '2月',
  `feb_hz` DECIMAL(16,4),
  `mar` DECIMAL(16,4) COMMENT '3月',
  `mar_hz` DECIMAL(16,4),
  `apr` DECIMAL(16,4) COMMENT '4月',
  `apr_hz` DECIMAL(16,4),
  `may` DECIMAL(16,4) COMMENT '5月',
  `may_hz` DECIMAL(16,4),
  `jun` DECIMAL(16,4) COMMENT '6月',
  `jun_hz` DECIMAL(16,4),
  `jul` DECIMAL(16,4) COMMENT '7月',
  `jul_hz` DECIMAL(16,4),
  `aug` DECIMAL(16,4) COMMENT '8月',
  `aug_hz` DECIMAL(16,4),
  `sep` DECIMAL(16,4) COMMENT '9月',
  `sep_hz` DECIMAL(16,4),
  `oct` DECIMAL(16,4) COMMENT '10月',
  `oct_hz` DECIMAL(16,4),
  `nov` DECIMAL(16,4) COMMENT '11月',
  `nov_hz` DECIMAL(16,4),
  `dec` DECIMAL(16,4) COMMENT '12月',
  `dec_hz` DECIMAL(16,4),
  CONSTRAINT `PK_TJBB_DT_B03101` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B03102
-- Original Oracle primary-key constraint: PK_TJBB_DT_B03102 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B03102` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `jan` DECIMAL(16,4) COMMENT '1月',
  `jan_hz` DECIMAL(16,4),
  `feb` DECIMAL(16,4) COMMENT '2月',
  `feb_hz` DECIMAL(16,4),
  `mar` DECIMAL(16,4) COMMENT '3月',
  `mar_hz` DECIMAL(16,4),
  `apr` DECIMAL(16,4) COMMENT '4月',
  `apr_hz` DECIMAL(16,4),
  `may` DECIMAL(16,4) COMMENT '5月',
  `may_hz` DECIMAL(16,4),
  `jun` DECIMAL(16,4) COMMENT '6月',
  `jun_hz` DECIMAL(16,4),
  `jul` DECIMAL(16,4) COMMENT '7月',
  `jul_hz` DECIMAL(16,4),
  `aug` DECIMAL(16,4) COMMENT '8月',
  `aug_hz` DECIMAL(16,4),
  `sep` DECIMAL(16,4) COMMENT '9月',
  `sep_hz` DECIMAL(16,4),
  `oct` DECIMAL(16,4) COMMENT '10月',
  `oct_hz` DECIMAL(16,4),
  `nov` DECIMAL(16,4) COMMENT '11月',
  `nov_hz` DECIMAL(16,4),
  `dec` DECIMAL(16,4) COMMENT '12月',
  `dec_hz` DECIMAL(16,4),
  CONSTRAINT `PK_TJBB_DT_B03102` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B03103
-- Original Oracle primary-key constraint: PK_TJBB_DT_B03103 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B03103` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `area` VARCHAR(40) COMMENT '地区',
  `ktkzy` DECIMAL(16,4) COMMENT '剩余可调库资源',
  `ktkzy_hz` DECIMAL(16,4),
  `tke_mon` DECIMAL(16,4) COMMENT '调库',
  `tke_mon_hz` DECIMAL(16,4),
  `tke_mon_tb` DECIMAL(16,4) COMMENT '同比',
  `tke_mon_tb_hz` DECIMAL(16,4),
  `tke_year` DECIMAL(16,4) COMMENT '调库',
  `tke_year_hz` DECIMAL(16,4),
  `tke_year_tb` DECIMAL(16,4) COMMENT '同比',
  `tke_year_tb_hz` DECIMAL(16,4),
  `tmse_mon` DECIMAL(16,4) COMMENT '退税',
  `tmse_mon_hz` DECIMAL(16,4),
  `tmse_mon_tb` DECIMAL(16,4) COMMENT '同比',
  `tmse_mon_tb_hz` DECIMAL(16,4),
  `tmse_year` DECIMAL(16,4) COMMENT '退税',
  `tmse_year_hz` DECIMAL(16,4),
  `tmse_year_tb` DECIMAL(16,4) COMMENT '同比',
  `tmse_year_tb_hz` DECIMAL(16,4),
  `tke_mon_last` DECIMAL(16,4),
  `tke_mon_last_hz` DECIMAL(16,4),
  `tke_year_last` DECIMAL(16,4),
  `tke_year_last_hz` DECIMAL(16,4),
  `tmse_mon_last` DECIMAL(16,4),
  `tmse_mon_last_hz` DECIMAL(16,4),
  `tmse_year_last` DECIMAL(16,4),
  `tmse_year_last_hz` DECIMAL(16,4),
  CONSTRAINT `PK_TJBB_DT_B03103` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B03104
-- Original Oracle primary-key constraint: PK_TJBB_DT_B03104 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B03104` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `cke_tb` DECIMAL(16,4) COMMENT '同比',
  `cke_tb_hz` DECIMAL(16,4),
  `cke_year` DECIMAL(16,4) COMMENT '出口额',
  `cke_year_hz` DECIMAL(16,4),
  `cke_zb` DECIMAL(16,4) COMMENT '比重',
  `cke_zb_hz` DECIMAL(16,4),
  `tse_tb` DECIMAL(16,4) COMMENT '同比',
  `tse_tb_hz` DECIMAL(16,4),
  `tse_year` DECIMAL(16,4) COMMENT '退税额',
  `tse_year_hz` DECIMAL(16,4),
  `tse_zb` DECIMAL(16,4) COMMENT '比重',
  `tse_zb_hz` DECIMAL(16,4),
  `spmc` VARCHAR(400),
  `cke_year_last` DECIMAL(16,4) COMMENT '出口额上年',
  `cke_year_last_hz` DECIMAL(16,4),
  `tse_year_last` DECIMAL(16,4) COMMENT '退税额上年',
  `tse_year_last_hz` DECIMAL(16,4),
  `spdl` VARCHAR(16) COMMENT '商品大类',
  `spdldm` VARCHAR(16) COMMENT '商品大类代码',
  CONSTRAINT `PK_TJBB_DT_B03104` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B03105
-- Original Oracle primary-key constraint: PK_TJBB_DT_B03105 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B03105` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `cke_tb` DECIMAL(16,4) COMMENT '同比',
  `cke_tb_hz` DECIMAL(16,4),
  `cke_year` DECIMAL(16,4) COMMENT '出口额',
  `cke_year_hz` DECIMAL(16,4),
  `cke_zb` DECIMAL(16,4) COMMENT '比重',
  `cke_zb_hz` DECIMAL(16,4),
  `tse_tb` DECIMAL(16,4) COMMENT '同比',
  `tse_tb_hz` DECIMAL(16,4),
  `tse_year` DECIMAL(16,4) COMMENT '退税额',
  `tse_year_hz` DECIMAL(16,4),
  `tse_zb` DECIMAL(16,4) COMMENT '比重',
  `tse_zb_hz` DECIMAL(16,4),
  `cke_year_last` DECIMAL(16,4) COMMENT '上年同期出口额',
  `cke_year_last_hz` DECIMAL(16,4),
  `tse_year_last` DECIMAL(16,4) COMMENT '上年同期退税额',
  `tse_year_last_hz` DECIMAL(16,4),
  CONSTRAINT `PK_TJBB_DT_B03105` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B03106
-- Original Oracle primary-key constraint: PK_TJBB_DT_B03106 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B03106` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `cke_year` DECIMAL(16,4) COMMENT '出口额',
  `cke_year_hz` DECIMAL(16,4),
  `cke_year_tb` DECIMAL(16,4) COMMENT '同比',
  `cke_year_tb_hz` DECIMAL(16,4),
  `cke_year_zb` DECIMAL(16,4) COMMENT '比重',
  `cke_year_zb_hz` DECIMAL(16,4),
  `mse_year` DECIMAL(16,4) COMMENT '免税额',
  `mse_year_hz` DECIMAL(16,4),
  `tmse_year_tb` DECIMAL(16,4) COMMENT '同比',
  `tmse_year_tb_hz` DECIMAL(16,4),
  `tmse_year_zb` DECIMAL(16,4) COMMENT '比重',
  `tmse_year_zb_hz` DECIMAL(16,4),
  `tse_year` DECIMAL(16,4) COMMENT '退税额',
  `tse_year_hz` DECIMAL(16,4),
  `cke_year_last` DECIMAL(16,4) COMMENT '出口额上年同期',
  `cke_year_last_hz` DECIMAL(16,4),
  `mse_year_last` DECIMAL(16,4) COMMENT '免税额上年同期',
  `mse_year_last_hz` DECIMAL(16,4),
  `tse_year_last` DECIMAL(16,4) COMMENT '退税额上年同期',
  `tse_year_last_hz` DECIMAL(16,4),
  `myfs_dm` VARCHAR(4),
  `myfs_mc` VARCHAR(100),
  CONSTRAINT `PK_TJBB_DT_B03106` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B03107
-- Original Oracle primary-key constraint: PK_TJBB_DT_B03107 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B03107` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `area` VARCHAR(50) COMMENT '地区',
  `sbhs_1` DECIMAL(16,0) COMMENT '申报户数',
  `sbhs_1_hz` DECIMAL(16,0),
  `sbhs_2` DECIMAL(16,0) COMMENT '申报户数',
  `sbhs_2_hz` DECIMAL(16,0),
  `sbhs_3` DECIMAL(16,0) COMMENT '申报户数',
  `sbhs_3_hz` DECIMAL(16,0),
  `sbhs_4` DECIMAL(16,0) COMMENT '申报户数',
  `sbhs_4_hz` DECIMAL(16,0),
  `tse_1_lj` DECIMAL(16,4) COMMENT '累计办理退税',
  `tse_1_lj_hz` DECIMAL(16,4),
  `tse_1_tb` DECIMAL(16,4) COMMENT '同比',
  `tse_1_tb_hz` DECIMAL(16,4),
  `tse_1_zb` DECIMAL(16,4) COMMENT '退税占比比重',
  `tse_1_zb_hz` DECIMAL(16,4),
  `tse_2_lj` DECIMAL(16,4) COMMENT '累计办理退税',
  `tse_2_lj_hz` DECIMAL(16,4),
  `tse_2_tb` DECIMAL(16,4) COMMENT '同比',
  `tse_2_tb_hz` DECIMAL(16,4),
  `tse_2_zb` DECIMAL(16,4) COMMENT '退税占比比重',
  `tse_2_zb_hz` DECIMAL(16,4),
  `tse_3_lj` DECIMAL(16,4) COMMENT '累计办理退税',
  `tse_3_lj_hz` DECIMAL(16,4),
  `tse_3_tb` DECIMAL(16,4) COMMENT '同比',
  `tse_3_tb_hz` DECIMAL(16,4),
  `tse_3_zb` DECIMAL(16,4) COMMENT '退税占比比重',
  `tse_3_zb_hz` DECIMAL(16,4),
  `tse_4_lj` DECIMAL(16,4) COMMENT '累计办理退税',
  `tse_4_lj_hz` DECIMAL(16,4),
  `tse_4_tb` DECIMAL(16,4) COMMENT '同比',
  `tse_4_tb_hz` DECIMAL(16,4),
  `tse_4_zb` DECIMAL(16,4) COMMENT '退税占比比重',
  `tse_4_zb_hz` DECIMAL(16,4),
  `tse_1_lj_last` DECIMAL(16,4),
  `tse_1_lj_last_hz` DECIMAL(16,4),
  `tse_2_lj_last` DECIMAL(16,4),
  `tse_2_lj_last_hz` DECIMAL(16,4),
  `tse_3_lj_last` DECIMAL(16,4),
  `tse_3_lj_last_hz` DECIMAL(16,4),
  `tse_4_lj_last` DECIMAL(16,4),
  `tse_4_lj_last_hz` DECIMAL(16,4),
  CONSTRAINT `PK_TJBB_DT_B03107` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B03108
-- Original Oracle primary-key constraint: PK_TJBB_DT_B03108 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B03108` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `cke` DECIMAL(16,4) COMMENT '当期累计出口额（万美元）',
  `cke_hz` DECIMAL(16,4),
  `cke_tb` DECIMAL(16,4) COMMENT '同比（%）',
  `cke_tb_hz` DECIMAL(16,4),
  `cke_zb` DECIMAL(16,4) COMMENT '占比（%）',
  `cke_zb_hz` DECIMAL(16,4),
  `tmse` DECIMAL(16,4) COMMENT '退免税额（万元）',
  `tmse_hz` DECIMAL(16,4),
  `tmse_tb` DECIMAL(16,4) COMMENT '同比（%）',
  `tmse_tb_hz` DECIMAL(16,4),
  `tmse_zb` DECIMAL(16,4) COMMENT '占比（%）',
  `tmse_zb_hz` DECIMAL(16,4),
  `cke_last` DECIMAL(16,4),
  `cke_last_hz` DECIMAL(16,4),
  `tmse_last` DECIMAL(16,4),
  `tmse_last_hz` DECIMAL(16,4),
  CONSTRAINT `PK_TJBB_DT_B03108` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B03109
-- Original Oracle primary-key constraint: PK_TJBB_DT_B03109 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B03109` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `cke_lj` DECIMAL(16,4) COMMENT '本年累计出口额',
  `cke_lj_hz` DECIMAL(16,4),
  `cke_tb` DECIMAL(16,4) COMMENT '同比（%）',
  `cke_tb_hz` DECIMAL(16,4),
  `cke_zb` DECIMAL(16,4) COMMENT '占比（%）',
  `cke_zb_hz` DECIMAL(16,4),
  `gbdm` VARCHAR(20) COMMENT '关别代码',
  `hgmc` VARCHAR(100) COMMENT '海关名称',
  `cke_lj_last` DECIMAL(16,4),
  `cke_lj_last_hz` DECIMAL(16,4),
  CONSTRAINT `PK_TJBB_DT_B03109` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B03109_MID
-- Original Oracle primary-key constraint: PK_TJBB_DT_B03109_MID (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B03109_MID` (
  `swjgdm` VARCHAR(32) NOT NULL,
  `ssny` VARCHAR(6) NOT NULL,
  `gbdm` VARCHAR(20) NOT NULL,
  `cke_lj` DECIMAL(16,4),
  `tse_lj` DECIMAL(16,4),
  `ckpm` DECIMAL(10,0),
  CONSTRAINT `PK_TJBB_DT_B03109_MID` PRIMARY KEY (`SWJGDM`, `SSNY`, `GBDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B03110
-- Original Oracle primary-key constraint: PK_TJBB_DT_B03110 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B03110` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `cke_tb` DECIMAL(16,4) COMMENT '同比（%）',
  `cke_tb_hz` DECIMAL(16,4),
  `cke_usd` DECIMAL(16,4) COMMENT '当期累计出口额（万美元）',
  `cke_usd_hz` DECIMAL(16,4),
  `cke_zb` DECIMAL(16,4) COMMENT '占比（%）',
  `cke_zb_hz` DECIMAL(16,4),
  `item` VARCHAR(40) COMMENT '项目名称',
  `tmse` DECIMAL(16,4) COMMENT '退免税额（万元）',
  `tmse_hz` DECIMAL(16,4),
  `tmse_tb` DECIMAL(16,4) COMMENT '同比（%）',
  `tmse_tb_hz` DECIMAL(16,4),
  `tmse_zb` DECIMAL(16,4) COMMENT '占比（%）',
  `tmse_zb_hz` DECIMAL(16,4),
  `cke_usd_last` DECIMAL(16,4),
  `cke_usd_last_hz` DECIMAL(16,4),
  `tmse_last` DECIMAL(16,4),
  `tmse_last_hz` DECIMAL(16,4),
  CONSTRAINT `PK_TJBB_DT_B03110` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B03110_MID
-- Original Oracle primary-key constraint: PK_TJBB_DT_B03110_MID (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B03110_MID` (
  `swjgdm` VARCHAR(32) NOT NULL,
  `ssny` VARCHAR(6) NOT NULL,
  `dmtype` VARCHAR(6) NOT NULL,
  `gbdm` VARCHAR(20) NOT NULL,
  `cke_lj` DECIMAL(16,4),
  `tse_lj` DECIMAL(16,4),
  `ckpm` DECIMAL(5,0),
  CONSTRAINT `PK_TJBB_DT_B03110_MID` PRIMARY KEY (`SWJGDM`, `SSNY`, `DMTYPE`, `GBDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B03111
-- Original Oracle primary-key constraint: PK_TJBB_DT_B03111 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B03111` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `fp_sl` DECIMAL(16,0) COMMENT '涉及发票数量',
  `fp_sl_hz` DECIMAL(16,0),
  `hshfh_sl` DECIMAL(16,0) COMMENT '核实函（复函）数量',
  `hshfh_sl_hz` DECIMAL(16,0),
  `js_je` DECIMAL(16,4) COMMENT '涉及计税金额',
  `js_je_hz` DECIMAL(16,4),
  `ts_je` DECIMAL(16,4) COMMENT '涉及退税额',
  `ts_je_hz` DECIMAL(16,4),
  CONSTRAINT `PK_TJBB_DT_B03111` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B03112
-- Original Oracle primary-key constraint: PK_TJBB_DT_B03112 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B03112` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `cke_tb` DECIMAL(16,4) COMMENT '同比',
  `cke_tb_hz` DECIMAL(16,4),
  `cke_year` DECIMAL(16,4) COMMENT '出口额',
  `cke_year_hz` DECIMAL(16,4),
  `cke_zb` DECIMAL(16,4) COMMENT '比重',
  `cke_zb_hz` DECIMAL(16,4),
  `tse_tb` DECIMAL(16,4) COMMENT '同比',
  `tse_tb_hz` DECIMAL(16,4),
  `tse_year` DECIMAL(16,4) COMMENT '退税额',
  `tse_year_hz` DECIMAL(16,4),
  `tse_zb` DECIMAL(16,4) COMMENT '比重',
  `tse_zb_hz` DECIMAL(16,4),
  `spmc` VARCHAR(400),
  `cke_year_last` DECIMAL(16,4) COMMENT '出口额上年',
  `cke_year_last_hz` DECIMAL(16,4),
  `tse_year_last` DECIMAL(16,4) COMMENT '退税额上年',
  `tse_year_last_hz` DECIMAL(16,4),
  `spdl` VARCHAR(16) COMMENT '商品大类',
  `spdldm` VARCHAR(16) COMMENT '商品大类代码',
  CONSTRAINT `PK_TJBB_DT_B03112` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B03113
-- Original Oracle primary-key constraint: PK_TJBB_DT_B03113 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B03113` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `cke_tb` DECIMAL(16,4) COMMENT '同比（%）',
  `cke_tb_hz` DECIMAL(16,4),
  `cke_year` DECIMAL(16,4) COMMENT '本年',
  `cke_year_hz` DECIMAL(16,4),
  `cke_year_zb` DECIMAL(16,4) COMMENT '本年',
  `cke_year_zb_hz` DECIMAL(16,4),
  `cke_year_zb_last` DECIMAL(16,4) COMMENT '上年同期',
  `cke_year_zb_last_hz` DECIMAL(16,4),
  `pm` VARCHAR(10) COMMENT '排名',
  `qyhgdm` VARCHAR(18) COMMENT '企业海关代码',
  `tmse_tb` DECIMAL(16,4) COMMENT '同比',
  `tmse_tb_hz` DECIMAL(16,4),
  `tmse_year` DECIMAL(16,4) COMMENT '本年',
  `tmse_year_hz` DECIMAL(16,4),
  `tmse_year_zb` DECIMAL(16,4) COMMENT '本年',
  `tmse_year_zb_hz` DECIMAL(16,4),
  `tmse_year_zb_last` DECIMAL(16,4) COMMENT '上年同期',
  `tmse_year_zb_last_hz` DECIMAL(16,4),
  `usa_cke_tb` DECIMAL(16,4) COMMENT '同比（%）',
  `usa_cke_tb_hz` DECIMAL(16,4),
  `usa_cke_year` DECIMAL(16,4) COMMENT '本年',
  `usa_cke_year_hz` DECIMAL(16,4),
  `usa_tmse_tb` DECIMAL(16,4) COMMENT '同比',
  `usa_tmse_tb_hz` DECIMAL(16,4),
  `usa_tmse_year` DECIMAL(16,4) COMMENT '本年',
  `usa_tmse_year_hz` DECIMAL(16,4),
  `cke_year_last` DECIMAL(16,4),
  `cke_year_last_hz` DECIMAL(16,4),
  `tmse_year_last` DECIMAL(16,4),
  `tmse_year_last_hz` DECIMAL(16,4),
  `usa_cke_year_last` DECIMAL(16,4),
  `usa_cke_year_last_hz` DECIMAL(16,4),
  `usa_tmse_year_last` DECIMAL(16,4),
  `usa_tmse_year_last_hz` DECIMAL(16,4),
  `qymc` VARCHAR(160),
  `cpcode` VARCHAR(32),
  `jsmode` VARCHAR(1),
  `jsmodemc` VARCHAR(10) COMMENT '企业类型名称',
  CONSTRAINT `PK_TJBB_DT_B03113` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B03114
-- Original Oracle primary-key constraint: PK_TJBB_DT_B03114 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B03114` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `cke_tb` DECIMAL(16,0) COMMENT '同比（%）',
  `cke_tb_hz` DECIMAL(16,0),
  `cke_usd` DECIMAL(16,0) COMMENT '累计出口额（万美元）',
  `cke_usd_hz` DECIMAL(16,0),
  `cke_zb` DECIMAL(16,0) COMMENT '占比（%）',
  `cke_zb_hz` DECIMAL(16,0),
  `item` VARCHAR(40) COMMENT '项目名称',
  `tmse` DECIMAL(16,0) COMMENT '累计退免税额（万元）',
  `tmse_hz` DECIMAL(16,0),
  `tmse_tb` DECIMAL(16,0) COMMENT '同比（%）',
  `tmse_tb_hz` DECIMAL(16,0),
  `tmse_zb` DECIMAL(16,0) COMMENT '占比（%）',
  `tmse_zb_hz` DECIMAL(16,0),
  `cke_usd_last` DECIMAL(16,4),
  `cke_usd_last_hz` DECIMAL(16,4),
  `tmse_last` DECIMAL(16,4),
  `tmse_last_hz` DECIMAL(16,4),
  CONSTRAINT `PK_TJBB_DT_B03114` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B03114_MID
-- Original Oracle primary-key constraint: PK_TJBB_DT_B03114_MID (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B03114_MID` (
  `swjgdm` VARCHAR(32) NOT NULL,
  `ssny` VARCHAR(6) NOT NULL,
  `dmtype` VARCHAR(6) NOT NULL,
  `gbdm` VARCHAR(20) NOT NULL,
  `cke_lj` DECIMAL(16,4),
  `tse_lj` DECIMAL(16,4),
  `ckpm` DECIMAL(5,0),
  CONSTRAINT `PK_TJBB_DT_B03114_MID` PRIMARY KEY (`SWJGDM`, `SSNY`, `DMTYPE`, `GBDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B03115
-- Original Oracle primary-key constraint: PK_TJBB_DT_B03115 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B03115` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `qymc` VARCHAR(100) COMMENT '企业名称',
  `shxyno` VARCHAR(18) COMMENT '社会信用代码',
  `swjg` VARCHAR(11) COMMENT '所属税务机关',
  `tmse` DECIMAL(16,4) COMMENT '办理退（免）税',
  `tmse_hz` DECIMAL(16,4),
  `tmse_tb` DECIMAL(16,4) COMMENT '同比',
  `tmse_tb_hz` DECIMAL(16,4),
  `xh` VARCHAR(16) COMMENT '序号',
  `tmse_last` DECIMAL(16,4),
  `tmse_last_hz` DECIMAL(16,4),
  `jsmode` VARCHAR(1),
  `jsmodemc` VARCHAR(10) COMMENT '企业类型名称',
  `mde` DECIMAL(16,4) COMMENT '免抵额',
  `mde_hz` DECIMAL(16,4),
  `mde_last` DECIMAL(16,4) COMMENT '免抵额',
  `mde_last_hz` DECIMAL(16,4),
  `tse` DECIMAL(16,4) COMMENT '退税额',
  `tse_hz` DECIMAL(16,4),
  `tse_last` DECIMAL(16,4) COMMENT '退税额',
  `tse_last_hz` DECIMAL(16,4),
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  CONSTRAINT `PK_TJBB_DT_B03115` PRIMARY KEY (`SWJGDM`, `SSNY`, `BBLC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B03115_MID
-- Original Oracle primary-key constraint: PK_TJBB_DT_B03115_MID (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B03115_MID` (
  `ssny` VARCHAR(6) NOT NULL COMMENT '年月',
  `swjgdm` VARCHAR(32) NOT NULL COMMENT '税务机关',
  `jsmode` VARCHAR(1) NOT NULL COMMENT '计税方式',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `tmse` DECIMAL(16,4) COMMENT '办理退（免）税',
  `tse` DECIMAL(16,4) COMMENT '退税额',
  `mde` DECIMAL(16,4) COMMENT '免抵额',
  `ckpm_1` DECIMAL(6,0) COMMENT '出口排名（区县级）',
  `ckpm_2` DECIMAL(6,0) COMMENT '出口排名（地市级）',
  `ckpm_3` DECIMAL(6,0) COMMENT '出口排名（全省）',
  KEY `IDX_TJBB_DT_B03115_MID_DS` (`DJXH`, `SSNY`),
  CONSTRAINT `PK_TJBB_DT_B03115_MID` PRIMARY KEY (`SSNY`, `JSMODE`, `SWJGDM`, `DJXH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B03116
-- Original Oracle primary-key constraint: PK_TJBB_DT_B03116 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B03116` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `bl_hs` DECIMAL(16,0) COMMENT '办理_户数',
  `bl_hs_hz` DECIMAL(16,0),
  `bl_jsje` DECIMAL(16,4) COMMENT '办理_计税金额',
  `bl_jsje_hz` DECIMAL(16,4),
  `bl_myxse` DECIMAL(16,4) COMMENT '办理_美元销售额',
  `bl_myxse_hz` DECIMAL(16,4),
  `bl_tmse` DECIMAL(16,4) COMMENT '办理_退（免）税额',
  `bl_tmse_hz` DECIMAL(16,4),
  `bl_yts_hs` DECIMAL(16,0) COMMENT '办理_预退税_户数',
  `bl_yts_hs_hz` DECIMAL(16,0),
  `bl_yts_jsje` DECIMAL(16,4) COMMENT '办理_预退税_计税金额',
  `bl_yts_jsje_hz` DECIMAL(16,4),
  `bl_yts_myxse` DECIMAL(16,4) COMMENT '办理_预退税_美元销售额',
  `bl_yts_myxse_hz` DECIMAL(16,4),
  `bl_yts_tmse` DECIMAL(16,4) COMMENT '办理_预退税_退（免）税额',
  `bl_yts_tmse_hz` DECIMAL(16,4),
  `ck_hs` DECIMAL(16,0) COMMENT '出口_户数',
  `ck_hs_hz` DECIMAL(16,0),
  `ck_mylaj` DECIMAL(16,4) COMMENT '出口_美元离岸价',
  `ck_mylaj_hz` DECIMAL(16,4),
  `ck_rmblaj` DECIMAL(16,4) COMMENT '出口_人民币离岸价',
  `ck_rmblaj_hz` DECIMAL(16,4),
  `sb_hs` DECIMAL(16,0) COMMENT '申报_户数',
  `sb_hs_hz` DECIMAL(16,0),
  `sb_jsje` DECIMAL(16,4) COMMENT '申报_计税金额',
  `sb_jsje_hz` DECIMAL(16,4),
  `sb_myxse` DECIMAL(16,4) COMMENT '申报_美元销售额',
  `sb_myxse_hz` DECIMAL(16,4),
  `sb_tmse` DECIMAL(16,4) COMMENT '申报_退（免）税额',
  `sb_tmse_hz` DECIMAL(16,4),
  `sb_yts_hs` DECIMAL(16,0) COMMENT '申报_预退税_户数',
  `sb_yts_hs_hz` DECIMAL(16,0),
  `sb_yts_jsje` DECIMAL(16,4) COMMENT '申报_预退税_计税金额',
  `sb_yts_jsje_hz` DECIMAL(16,4),
  `sb_yts_myxse` DECIMAL(16,4) COMMENT '申报_预退税_美元销售额',
  `sb_yts_myxse_hz` DECIMAL(16,4),
  `sb_yts_tmse` DECIMAL(16,4) COMMENT '申报_预退税_退（免）税额',
  `sb_yts_tmse_hz` DECIMAL(16,4),
  CONSTRAINT `PK_TJBB_DT_B03116` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B03117
-- Original Oracle primary-key constraint: PK_TJBB_DT_B03117 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B03117` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `bl_hs` DECIMAL(16,0) COMMENT '办理_户数',
  `bl_hs_hz` DECIMAL(16,0),
  `bl_jsje` DECIMAL(16,4) COMMENT '办理_计税金额',
  `bl_jsje_hz` DECIMAL(16,4),
  `bl_myxse` DECIMAL(16,4) COMMENT '办理_美元销售额',
  `bl_myxse_hz` DECIMAL(16,4),
  `bl_tmse` DECIMAL(16,4) COMMENT '办理_退（免）税额',
  `bl_tmse_hz` DECIMAL(16,4),
  `ck_f1039_hs` DECIMAL(16,0) COMMENT '出口_剔除市场采购_户数',
  `ck_f1039_hs_hz` DECIMAL(16,0),
  `ck_f1039_mylaj` DECIMAL(16,4) COMMENT '出口_剔除市场采购_美元离岸价',
  `ck_f1039_mylaj_hz` DECIMAL(16,4),
  `ck_f1039_rmblaj` DECIMAL(16,4) COMMENT '出口_剔除市场采购_人民币离岸价',
  `ck_f1039_rmblaj_hz` DECIMAL(16,4),
  `ck_hs` DECIMAL(16,0) COMMENT '户数',
  `ck_hs_hz` DECIMAL(16,0),
  `ck_mylaj` DECIMAL(16,4) COMMENT '美元离岸价',
  `ck_mylaj_hz` DECIMAL(16,4),
  `ck_rmblaj` DECIMAL(16,4) COMMENT '人民币离岸价',
  `ck_rmblaj_hz` DECIMAL(16,4),
  `sb_hs` DECIMAL(16,0) COMMENT '申报_户数',
  `sb_hs_hz` DECIMAL(16,0),
  `sb_jsje` DECIMAL(16,4) COMMENT '申报_计税金额',
  `sb_jsje_hz` DECIMAL(16,4),
  `sb_myxse` DECIMAL(16,4) COMMENT '申报_美元销售额',
  `sb_myxse_hz` DECIMAL(16,4),
  `sb_tmse` DECIMAL(16,4) COMMENT '申报_退（免）税额',
  `sb_tmse_hz` DECIMAL(16,4),
  CONSTRAINT `PK_TJBB_DT_B03117` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B05101
-- Original Oracle primary-key constraint: PK_TJBB_DT_B05101 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B05101` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `cke_9610_hs` DECIMAL(16,0) COMMENT '户数',
  `cke_9610_hs_hz` DECIMAL(16,0),
  `cke_9610_je` DECIMAL(16,4) COMMENT '金额（万元）',
  `cke_9610_je_hz` DECIMAL(16,4),
  `cke_9710_hs` DECIMAL(16,0) COMMENT '户数',
  `cke_9710_hs_hz` DECIMAL(16,0),
  `cke_9710_je` DECIMAL(16,4) COMMENT '金额（万元）',
  `cke_9710_je_hz` DECIMAL(16,4),
  `cke_9810_hs` DECIMAL(16,0) COMMENT '户数',
  `cke_9810_hs_hz` DECIMAL(16,0),
  `cke_9810_je` DECIMAL(16,4) COMMENT '金额（万元）',
  `cke_9810_je_hz` DECIMAL(16,4),
  `qjny` VARCHAR(16) COMMENT '期间（年/月）',
  `tms_9610_hs` DECIMAL(16,0) COMMENT '户数',
  `tms_9610_hs_hz` DECIMAL(16,0),
  `tms_9610_je` DECIMAL(16,4) COMMENT '金额（万元）',
  `tms_9610_je_hz` DECIMAL(16,4),
  `tms_9710_hs` DECIMAL(16,0) COMMENT '户数',
  `tms_9710_hs_hz` DECIMAL(16,0),
  `tms_9710_je` DECIMAL(16,4) COMMENT '金额（万元）',
  `tms_9710_je_hz` DECIMAL(16,4),
  `tms_9810_hs` DECIMAL(16,0) COMMENT '户数',
  `tms_9810_hs_hz` DECIMAL(16,0),
  `tms_9810_je` DECIMAL(16,4) COMMENT '金额（万元）',
  `tms_9810_je_hz` DECIMAL(16,4),
  CONSTRAINT `PK_TJBB_DT_B05101` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B05102
-- Original Oracle primary-key constraint: PK_TJBB_DT_B05102 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B05102` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `kjls_cke_hs` DECIMAL(16,0) COMMENT '户数',
  `kjls_cke_hs_hz` DECIMAL(16,0),
  `kjls_cke_je` DECIMAL(16,4) COMMENT '金额（万元）',
  `kjls_cke_je_hz` DECIMAL(16,4),
  `kjls_tms_hs` DECIMAL(16,0) COMMENT '户数',
  `kjls_tms_hs_hz` DECIMAL(16,0),
  `kjls_tms_je` DECIMAL(16,4) COMMENT '金额（万元）',
  `kjls_tms_je_hz` DECIMAL(16,4),
  `qjny` VARCHAR(16) COMMENT '期间（年/月）',
  `wpms_cke_hs` DECIMAL(16,0) COMMENT '户数',
  `wpms_cke_hs_hz` DECIMAL(16,0),
  `wpms_cke_je` DECIMAL(16,4) COMMENT '金额（万元）',
  `wpms_cke_je_hz` DECIMAL(16,4),
  CONSTRAINT `PK_TJBB_DT_B05102` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B06101
-- Original Oracle primary-key constraint: PK_TJBB_DT_B06101 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B06101` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `area` VARCHAR(40) COMMENT '试点地区',
  `jyh_bas` DECIMAL(16,0) COMMENT '市场经营户备案数',
  `jyh_bas_hz` DECIMAL(16,0),
  `jyz_bas` DECIMAL(16,0) COMMENT '市场经营者备案数',
  `jyz_bas_hz` DECIMAL(16,0),
  `prov` VARCHAR(16) COMMENT '省份',
  `sdsj` VARCHAR(40) COMMENT '试点起始时间',
  CONSTRAINT `PK_TJBB_DT_B06101` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B06102
CREATE TABLE `TJBB_DT_B06102` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `area` VARCHAR(40) COMMENT '试点地区',
  `cke_mon` DECIMAL(16,6) COMMENT '出口货物总值',
  `cke_mon_hz` DECIMAL(16,6),
  `cke_total` DECIMAL(16,6) COMMENT '出口货物总值',
  `cke_total_hz` DECIMAL(16,6),
  `prov` VARCHAR(16) COMMENT '省份',
  `qjny` VARCHAR(40) COMMENT '期间（年/月）',
  `sbms_mon` DECIMAL(16,6) COMMENT '申报免税出口额',
  `sbms_mon_hz` DECIMAL(16,6),
  `sbms_total` DECIMAL(16,6) COMMENT '申报免税出口额',
  `sbms_total_hz` DECIMAL(16,6)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_B07101
-- Original Oracle primary-key constraint: PK_TJBB_DT_B07101 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_B07101` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `rdhs` DECIMAL(16,0) COMMENT '认定户数',
  `rdhs_hz` DECIMAL(16,0),
  `sbhs` DECIMAL(16,0) COMMENT '申报户数',
  `sbhs_hz` DECIMAL(16,0),
  `rd_sb_lv` DECIMAL(16,4) COMMENT '申报户数占认定户数的比率（100%）',
  `rd_sb_lv_hz` DECIMAL(16,4),
  `sb_cke_cur` DECIMAL(16,4) COMMENT '小计',
  `sb_cke_cur_hz` DECIMAL(16,4),
  `sb_cke_last` DECIMAL(16,4) COMMENT '上年同期申报',
  `sb_cke_last_hz` DECIMAL(16,4),
  `sb_cke_tblv` DECIMAL(16,4) COMMENT '同比变动率（100%）',
  `sb_cke_tblv_hz` DECIMAL(16,4),
  `sb_tmse_cur` DECIMAL(16,4) COMMENT '小计',
  `sb_tmse_cur_hz` DECIMAL(16,4),
  `sb_tmse_last` DECIMAL(16,4) COMMENT '上年同期申报',
  `sb_tmse_last_hz` DECIMAL(16,4),
  `sb_tmse_tblv` DECIMAL(16,4) COMMENT '同比变动率（100%）',
  `sb_tmse_tblv_hz` DECIMAL(16,4),
  `sh_tmse_cur` DECIMAL(16,4) COMMENT '小计',
  `sh_tmse_cur_hz` DECIMAL(16,4),
  `sh_tmse_last` DECIMAL(16,4) COMMENT '上年同期申报',
  `sh_tmse_last_hz` DECIMAL(16,4),
  `sh_tmse_tblv` DECIMAL(16,4) COMMENT '同比变动率（100%）',
  `sh_tmse_tblv_hz` DECIMAL(16,4),
  `sp_tmse_cur` DECIMAL(16,4) COMMENT '小计',
  `sp_tmse_cur_hz` DECIMAL(16,4),
  `sp_tmse_last` DECIMAL(16,4) COMMENT '上年同期申报',
  `sp_tmse_last_hz` DECIMAL(16,4),
  `sp_tmse_tblv` DECIMAL(16,4) COMMENT '同比变动率（100%）',
  `sp_tmse_tblv_hz` DECIMAL(16,4),
  `tk_cur` DECIMAL(16,4) COMMENT '小计',
  `tk_cur_hz` DECIMAL(16,4),
  `tk_last` DECIMAL(16,4) COMMENT '上年同期办理',
  `tk_last_hz` DECIMAL(16,4),
  `tk_tblv` DECIMAL(16,4) COMMENT '同比变动率（100%）',
  `tk_tblv_hz` DECIMAL(16,4),
  CONSTRAINT `PK_TJBB_DT_B07101` PRIMARY KEY (`SWJGDM`, `SSNY`, `BBLC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_D01002
-- Original Oracle primary-key constraint: PK_TJBB_DT_D01002 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_D01002` (
  `paramhash` VARCHAR(64) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `crtime` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `je` DECIMAL(16,4) COMMENT '金额',
  `je_sq` DECIMAL(16,4) COMMENT '上年同期',
  `tb` DECIMAL(16,4) COMMENT '同比',
  CONSTRAINT `PK_TJBB_DT_D01002` PRIMARY KEY (`PARAMHASH`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_D01003
-- Original Oracle primary-key constraint: PK_TJBB_DT_D01003 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_D01003` (
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `ts_amt` DECIMAL(16,4) COMMENT '累计退税额',
  `ts_amt_sq` DECIMAL(16,4) COMMENT '上年同期',
  `ts_amt_tb` DECIMAL(16,4) COMMENT '同比',
  `ts_amt_zb` DECIMAL(16,4) COMMENT '占比',
  `usd_amt` DECIMAL(16,4) COMMENT '累计出口额',
  `usd_amt_sq` DECIMAL(16,4) COMMENT '上年同期',
  `usd_amt_tb` DECIMAL(16,4) COMMENT '同比',
  `usd_amt_zb` DECIMAL(16,4) COMMENT '占比',
  `paramhash` VARCHAR(64) NOT NULL COMMENT '参数HASH',
  `mldm` VARCHAR(10) COMMENT '商品大类代码',
  `crtime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `IDX_HASH_D01003` (`PARAMHASH`),
  CONSTRAINT `PK_TJBB_DT_D01003` PRIMARY KEY (`BBLC`, `SWJGDM`, `PARAMHASH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_D01004
-- Original Oracle primary-key constraint: PK_TJBB_DT_D01004 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_D01004` (
  `paramhash` VARCHAR(64) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `crtime` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `code` VARCHAR(16) COMMENT '代码',
  `name` VARCHAR(200) COMMENT '名称',
  `usd_amt` DECIMAL(16,4) COMMENT '累计出口额',
  `usd_amt_sq` DECIMAL(16,4) COMMENT '上年同期',
  `usd_amt_tb` DECIMAL(16,4) COMMENT '同比',
  `usd_amt_zb` DECIMAL(16,4) COMMENT '占比',
  `xh` VARCHAR(16) COMMENT '序号',
  CONSTRAINT `PK_TJBB_DT_D01004` PRIMARY KEY (`PARAMHASH`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_D01005
-- Original Oracle primary-key constraint: PK_TJBB_DT_D01005 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_D01005` (
  `paramhash` VARCHAR(64) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `crtime` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `nsrmc` VARCHAR(400) COMMENT '企业名称',
  `nsrsbh` VARCHAR(32) COMMENT '社会信用代码',
  `pm` VARCHAR(16) COMMENT '排名',
  `ts_amt` DECIMAL(16,4) COMMENT '累计退税额',
  `ts_amt_sq` DECIMAL(16,4) COMMENT '上年同期',
  `ts_amt_tb` DECIMAL(16,4) COMMENT '同比',
  `usd_amt` DECIMAL(16,4) COMMENT '累计出口额',
  `usd_amt_sq` DECIMAL(16,4) COMMENT '上年同期',
  `usd_amt_tb` DECIMAL(16,4) COMMENT '同比',
  CONSTRAINT `PK_TJBB_DT_D01005` PRIMARY KEY (`PARAMHASH`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_D01006
-- Original Oracle primary-key constraint: PK_TJBB_DT_D01006 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_D01006` (
  `paramhash` VARCHAR(64) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `crtime` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `tsl` VARCHAR(10) COMMENT '退税率',
  `usd_amt` DECIMAL(16,4) COMMENT '出口额',
  `usd_amt_sq` DECIMAL(16,4) COMMENT '上年同期',
  `usd_amt_tb` DECIMAL(16,4) COMMENT '同比',
  `usd_amt_zb` DECIMAL(16,4) COMMENT '占比',
  `xh` VARCHAR(10) COMMENT '序号',
  CONSTRAINT `PK_TJBB_DT_D01006` PRIMARY KEY (`PARAMHASH`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_D01007
-- Original Oracle primary-key constraint: PK_TJBB_DT_D01007 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_D01007` (
  `paramhash` VARCHAR(64) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `crtime` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `hymc` VARCHAR(400) COMMENT '行业名称',
  `qyhs` DECIMAL(16,0) COMMENT '户数',
  `ts_amt` DECIMAL(16,4) COMMENT '累计退税额',
  `ts_amt_sq` DECIMAL(16,4) COMMENT '上年同期',
  `ts_amt_tb` DECIMAL(16,4) COMMENT '同比',
  `ts_amt_zb` DECIMAL(16,4) COMMENT '占比',
  `usd_amt` DECIMAL(16,4) COMMENT '累计出口额',
  `usd_amt_sq` DECIMAL(16,4) COMMENT '上年同期',
  `usd_amt_tb` DECIMAL(16,4) COMMENT '同比',
  `usd_amt_zb` DECIMAL(16,4) COMMENT '占比',
  `xh` VARCHAR(10) COMMENT '序号',
  `hydm` VARCHAR(10) COMMENT '行业代码',
  `sjhy_dm` VARCHAR(10) COMMENT '上级行业代码',
  CONSTRAINT `PK_TJBB_DT_D01007` PRIMARY KEY (`PARAMHASH`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_D01008
-- Original Oracle primary-key constraint: PK_TJBB_DT_D01008 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_D01008` (
  `paramhash` VARCHAR(64) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `crtime` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `hgcode` VARCHAR(16) COMMENT '关别代码',
  `hgmc` VARCHAR(100) COMMENT '海关名称',
  `usd_amt` DECIMAL(16,4) COMMENT '累计出口额',
  `usd_amt_sq` DECIMAL(16,4) COMMENT '上年同期',
  `usd_amt_tb` DECIMAL(16,4) COMMENT '同比',
  `usd_amt_zb` DECIMAL(16,4) COMMENT '占比',
  `xh` VARCHAR(10) COMMENT '序号',
  CONSTRAINT `PK_TJBB_DT_D01008` PRIMARY KEY (`PARAMHASH`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_D01009
-- Original Oracle primary-key constraint: PK_TJBB_DT_D01009 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_D01009` (
  `paramhash` VARCHAR(64) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `crtime` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `tdcode` VARCHAR(10) COMMENT '监管方式代码',
  `tdmc` VARCHAR(100) COMMENT '监管方式名称',
  `usd_amt` DECIMAL(16,4) COMMENT '累计出口额',
  `usd_amt_sq` DECIMAL(16,4) COMMENT '上年同期',
  `usd_amt_tb` DECIMAL(16,4) COMMENT '同比',
  `usd_amt_zb` DECIMAL(16,4) COMMENT '占比',
  `xh` VARCHAR(10) COMMENT '序号',
  CONSTRAINT `PK_TJBB_DT_D01009` PRIMARY KEY (`PARAMHASH`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_D01010
-- Original Oracle primary-key constraint: PK_TJBB_DT_D01010 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_D01010` (
  `paramhash` VARCHAR(64) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `crtime` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `jhamt` DECIMAL(16,4) COMMENT '累计进货额',
  `jhamt_sq` DECIMAL(16,4) COMMENT '上年同期',
  `jhamt_tb` DECIMAL(16,4) COMMENT '同比',
  `jhamt_zb` DECIMAL(16,4) COMMENT '占比',
  `mc` VARCHAR(200) COMMENT '供货企业区域',
  `tse` DECIMAL(16,4) COMMENT '累计退税额',
  `tse_sq` DECIMAL(16,4) COMMENT '上年同期',
  `tse_tb` DECIMAL(16,4) COMMENT '同比',
  `tse_zb` DECIMAL(16,4) COMMENT '占比',
  `sjxzqh` VARCHAR(10) COMMENT '上级行政区划',
  `xzqh` VARCHAR(10) COMMENT '行政区划',
  CONSTRAINT `PK_TJBB_DT_D01010` PRIMARY KEY (`PARAMHASH`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_DT_E01001
-- Original Oracle primary-key constraint: PK_TJBB_DT_E01001 (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_DT_E01001` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `apr` DECIMAL(16,4) COMMENT '4月',
  `aug` DECIMAL(16,4) COMMENT '8月',
  `dec` DECIMAL(16,4) COMMENT '12月',
  `feb` DECIMAL(16,4) COMMENT '2月',
  `jan` DECIMAL(16,4) COMMENT '1月',
  `jul` DECIMAL(16,4) COMMENT '7月',
  `jun` DECIMAL(16,4) COMMENT '6月',
  `mar` DECIMAL(16,4) COMMENT '3月',
  `may` DECIMAL(16,4) COMMENT '5月',
  `nov` DECIMAL(16,4) COMMENT '11月',
  `oct` DECIMAL(16,4) COMMENT '10月',
  `sep` DECIMAL(16,4) COMMENT '9月',
  CONSTRAINT `PK_TJBB_DT_E01001` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_HEADER_COLS
-- TJBB_HEADER_COLS.maxlen: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- TJBB_HEADER_COLS.degree: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- TJBB_HEADER_COLS.showorder: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- TJBB_HEADER_COLS.id: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- Original Oracle primary-key constraint: PK_HEADER_COLS (MySQL index name: PRIMARY).
-- Auxiliary UNIQUE index UNI_HEADER_COLS_ORACLE_NULLS preserves Oracle composite-UNIQUE NULL behavior: duplicate partially-NULL keys are rejected; wholly-NULL keys remain allowed. NULL flags prevent sentinel collisions; original named UNIQUE key is kept.
CREATE TABLE `TJBB_HEADER_COLS` (
  `bbdm` VARCHAR(10) COMMENT '报表代码',
  `fname` VARCHAR(20) COMMENT '字段名',
  `cname` VARCHAR(60) COMMENT '字段中文名，主表头',
  `fnamehz` VARCHAR(20) COMMENT '汇总字段名,默认为空，为空则汇总字段=字段名_hz',
  `ftype` VARCHAR(20) COMMENT '字段类型varchar/number/date',
  `maxlen` DECIMAL(65,27) COMMENT '长度',
  `degree` DECIMAL(65,27) COMMENT '精度',
  `defval` VARCHAR(30) COMMENT '缺省值',
  `nullable` CHAR(1) COMMENT 'Y可空 N非空，默认Y',
  `fmt` VARCHAR(30) COMMENT '输出格式',
  `showorder` DECIMAL(65,27) COMMENT '显示顺序，为空则界面表头不显示该字段',
  `xlscol` VARCHAR(3) COMMENT '用于导出到EXCEL模版',
  `allowupdate` CHAR(1) NOT NULL COMMENT 'Y可修改N不可修改',
  `note` VARCHAR(100) COMMENT '用于tips展示，为空用中文名',
  `qybj` CHAR(1) NOT NULL COMMENT 'Y/N缺省启用，考虑报表字段有可能增减变化',
  `align` CHAR(1) COMMENT '显示位置,0：靠左，1：居中，2：靠右',
  `allowformula` CHAR(1) COMMENT 'Y允许列进行公式运算，N不允许运算公式，默认为Y',
  `id` DECIMAL(65,27) NOT NULL COMMENT '主键',
  `allowsum` CHAR(1) DEFAULT 'Y' COMMENT 'Y允许列进行求和汇总，N不允许求和汇总，默认为Y',
  `hztype` CHAR(1) DEFAULT '1' COMMENT ' 1求和  2同比  3环比',
  `hzobj` VARCHAR(20) COMMENT '汇总作用对象',
  CONSTRAINT `PK_HEADER_COLS` PRIMARY KEY (`ID`),
  CONSTRAINT `UNI_HEADER_COLS` UNIQUE (`BBDM`, `FNAME`),
  UNIQUE KEY `UNI_HEADER_COLS_ORACLE_NULLS` ((IF(`bbdm` IS NULL AND `fname` IS NULL, NULL, 1)), (COALESCE(`bbdm`, '')), (`bbdm` IS NULL), (COALESCE(`fname`, '')), (`fname` IS NULL))
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_LINE_ITEM
-- TJBB_LINE_ITEM.showorder: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- Original Oracle primary-key constraint: PK_TJBB_LINE_ITEM (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_LINE_ITEM` (
  `bbdm` VARCHAR(10) NOT NULL COMMENT '报表代码',
  `bblc` VARCHAR(3) NOT NULL COMMENT '报表栏次',
  `lcmc` VARCHAR(200) COMMENT '栏次名称',
  `showorder` DECIMAL(65,27) NOT NULL COMMENT '显示排序',
  `xlsrow` VARCHAR(3) COMMENT 'EXCEL行',
  `allowupdate` CHAR(1) NOT NULL COMMENT 'Y可修改N不可修改',
  `qybj` CHAR(1) NOT NULL COMMENT 'Y/N缺省启用，考虑报表栏次有可能增减变化',
  `hztype` CHAR(1) DEFAULT '1' COMMENT ' 1求和  2同比  3环比',
  `hzobj` VARCHAR(20) COMMENT '汇总作用对象',
  `allowformula` CHAR(1) COMMENT 'Y列公式是否在行上起效N否',
  CONSTRAINT `PK_TJBB_LINE_ITEM` PRIMARY KEY (`BBDM`, `BBLC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_REPORT_DYNAMIC
-- Original Oracle primary-key constraint: PK_BBDM_LOC (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_REPORT_DYNAMIC` (
  `bbdm` VARCHAR(6) NOT NULL,
  `location` VARCHAR(10) NOT NULL,
  `bblc_name` VARCHAR(200) COMMENT '栏次中文描述',
  `column_title` VARCHAR(200) NOT NULL COMMENT '列中文描述',
  `sql_script` VARCHAR(4000) NOT NULL,
  `is_valid` CHAR(1) NOT NULL COMMENT '是否有效启用',
  `crtime` DATETIME,
  `uptime` DATETIME,
  `db_target` VARCHAR(20) COMMENT '数据源目标，默认为便捷退税',
  `remark` VARCHAR(2000) COMMENT '描述',
  CONSTRAINT `PK_BBDM_LOC` PRIMARY KEY (`BBDM`, `LOCATION`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_REPORT_FORMULA
-- TJBB_REPORT_FORMULA.id: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- TJBB_REPORT_FORMULA.yxj: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- Original Oracle primary-key constraint: PK_TJBB_REPORT_FORMULA (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_REPORT_FORMULA` (
  `id` DECIMAL(65,27) NOT NULL,
  `bbdm` VARCHAR(10),
  `type` CHAR(1) COMMENT '公式类型 1，列公式 2，行公式',
  `formula` VARCHAR(200),
  `yxj` DECIMAL(65,27) DEFAULT 0 COMMENT '优先级,数字越小优先级越高',
  `qybz` CHAR(1),
  `ishzjs` CHAR(1) COMMENT '是否参与汇总计算1，参与0，不参与',
  CONSTRAINT `PK_TJBB_REPORT_FORMULA` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_REPORT_HEADER
-- TJBB_REPORT_HEADER.horder: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- TJBB_REPORT_HEADER.vorder: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- Original Oracle primary-key constraint: PK_TJBB_REPORT_HEADER (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_REPORT_HEADER` (
  `bbdm` VARCHAR(10) NOT NULL COMMENT '报表代码',
  `bh` VARCHAR(20) NOT NULL COMMENT '编号',
  `showname` VARCHAR(150) COMMENT '显示名称',
  `type` CHAR(1) NOT NULL COMMENT '1：表头 2：栏次',
  `ismerg` CHAR(1) NOT NULL COMMENT '0：否  1：是',
  `dispwidth` VARCHAR(8),
  `disphight` VARCHAR(8),
  `h` VARCHAR(3) NOT NULL,
  `w` VARCHAR(3) NOT NULL,
  `horder` DECIMAL(65,27) NOT NULL,
  `vorder` DECIMAL(65,27) NOT NULL,
  `qybj` CHAR(1) NOT NULL COMMENT '启用标志,Y/N缺省启用，考虑报表栏次有可能增减变化',
  CONSTRAINT `PK_TJBB_REPORT_HEADER` PRIMARY KEY (`BBDM`, `BH`, `TYPE`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_REPORT_ITEM
-- Original Oracle primary-key constraint: PK_TJBB_REPORT_ITEM (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_REPORT_ITEM` (
  `bbdldm` VARCHAR(10) NOT NULL COMMENT '报表大类代码',
  `bbdlmc` VARCHAR(60) COMMENT '报表大类名称',
  `bbdljc` VARCHAR(40) COMMENT '报表大类简称',
  `note` VARCHAR(100) COMMENT '说明',
  `type` VARCHAR(1) COMMENT '报表类型，1,适用统计报表 2.适用统计分析',
  CONSTRAINT `PK_TJBB_REPORT_ITEM` PRIMARY KEY (`BBDLDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_REPORT_LIST
-- TJBB_REPORT_LIST.sppy: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- TJBB_REPORT_LIST.czpy: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- TJBB_REPORT_LIST.sfbl: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- TJBB_REPORT_LIST.showorder: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- TJBB_REPORT_LIST.excelcol: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- TJBB_REPORT_LIST.excelrow: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- TJBB_REPORT_LIST.headcol: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- TJBB_REPORT_LIST.headrow: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- TJBB_REPORT_LIST.endrow: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- TJBB_REPORT_LIST.endcol: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- Original Oracle primary-key constraint: PK_TJBB_REPORT_LIST (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_REPORT_LIST` (
  `bbdm` VARCHAR(10) NOT NULL COMMENT '报表代码',
  `bbdldm` VARCHAR(10) NOT NULL COMMENT '报表大类代码',
  `bbmc` VARCHAR(60) NOT NULL COMMENT '报表中文名称',
  `bbjc` VARCHAR(40) COMMENT '报表简称称',
  `fname` VARCHAR(30) NOT NULL COMMENT '数据库表名',
  `sppy` DECIMAL(65,27) COMMENT '打印水平偏移，预留',
  `czpy` DECIMAL(65,27) COMMENT '打印垂直偏移,',
  `sfbl` DECIMAL(65,27) COMMENT '默认缩放比例',
  `classhz` VARCHAR(100) COMMENT '汇总服务类',
  `classcx` VARCHAR(100) COMMENT '查询服务类',
  `classsb` VARCHAR(100) COMMENT '上报服务类',
  `classzf` VARCHAR(100) COMMENT '撤销服务类',
  `showorder` DECIMAL(65,27) COMMENT '显示顺序',
  `bbtype` CHAR(1) NOT NULL COMMENT '报表类型,1固定报表 2可变长报表 3可变长翻页表',
  `qybj` CHAR(1) COMMENT '启用标志,Y/N缺省启用，考虑报表字段有可能增减变化',
  `note` VARCHAR(100) COMMENT '说明',
  `excelcol` DECIMAL(65,27) COMMENT 'Excel模板数据起始列',
  `excelrow` DECIMAL(65,27) COMMENT 'Excel模板数据起始行',
  `headcol` DECIMAL(65,27) COMMENT 'Excel模板表头起始列',
  `headrow` DECIMAL(65,27) COMMENT 'Excel模板表头起始行',
  `hztype` CHAR(1) COMMENT '1指标汇总，3明细汇总，5合计汇总',
  `swjgmctype` CHAR(1) COMMENT '对于合计汇总表，（DM_SWJG_SJ）显示的税务机关名称类型   1-全称 ，2-简称，3-显示名称',
  `endrow` DECIMAL(65,27) COMMENT 'Excel模板结束行',
  `endcol` DECIMAL(65,27) COMMENT 'Excel模板结束列',
  `proc` VARCHAR(50) COMMENT '初始化存储过程',
  `prochz` VARCHAR(50) COMMENT '汇总存储过程',
  CONSTRAINT `PK_TJBB_REPORT_LIST` PRIMARY KEY (`BBDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_REPORT_TBXX
-- TJBB_REPORT_TBXX.id: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- Original Oracle primary-key constraint: PK_TJBB_REPORT_TBXX (MySQL index name: PRIMARY).
-- Auxiliary UNIQUE index UQ_TJBB_REPORT_TBXX_ORACLE_NULLS preserves Oracle composite-UNIQUE NULL behavior: duplicate partially-NULL keys are rejected; wholly-NULL keys remain allowed. NULL flags prevent sentinel collisions; original named UNIQUE key is kept.
CREATE TABLE `TJBB_REPORT_TBXX` (
  `id` DECIMAL(65,27) NOT NULL COMMENT '主键',
  `bbdm` VARCHAR(10),
  `swjgdm` VARCHAR(18),
  `swjgmc` VARCHAR(40) COMMENT '填表名称',
  `ssny` VARCHAR(20) COMMENT '填表期别',
  `unit` VARCHAR(30) COMMENT '填表单位',
  `zbr` VARCHAR(40) COMMENT '制表人',
  `zbdate` DATETIME COMMENT '制表日期',
  `qt` VARCHAR(50) COMMENT '其他选项',
  CONSTRAINT `PK_TJBB_REPORT_TBXX` PRIMARY KEY (`ID`),
  CONSTRAINT `UQ_TJBB_REPORT_TBXX` UNIQUE (`BBDM`, `SWJGDM`),
  UNIQUE KEY `UQ_TJBB_REPORT_TBXX_ORACLE_NULLS` ((IF(`bbdm` IS NULL AND `swjgdm` IS NULL, NULL, 1)), (COALESCE(`bbdm`, '')), (`bbdm` IS NULL), (COALESCE(`swjgdm`, '')), (`swjgdm` IS NULL))
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_SB_JYXX
-- Original Oracle primary-key constraint: PK_TJBB_JYXX (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_SB_JYXX` (
  `id` VARCHAR(64) NOT NULL COMMENT '主键',
  `swjgdm` VARCHAR(11),
  `ssny` VARCHAR(6),
  `bbdldm` VARCHAR(3),
  `bbdm` VARCHAR(6),
  `msg_type` CHAR(1),
  `msg_level` CHAR(1) COMMENT '1,错误 2.提示',
  `msg` VARCHAR(200),
  CONSTRAINT `PK_TJBB_JYXX` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_SWJG_MONTH
-- Original Oracle primary-key constraint: PK_TJBB_SWJG_MONTH (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_SWJG_MONTH` (
  `swjgdm` VARCHAR(11) NOT NULL,
  `ssny` VARCHAR(6),
  CONSTRAINT `PK_TJBB_SWJG_MONTH` PRIMARY KEY (`SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='报表制表前月份数据是否初始化控制表';

-- Creating table TJBB_TASK
-- Original Oracle primary-key constraint: PK_TJBB_TASK (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_TASK` (
  `bbdldm` VARCHAR(10) NOT NULL COMMENT '报表大类代码',
  `swjgdm` VARCHAR(11) NOT NULL COMMENT '报表机关代码',
  `ny` VARCHAR(6) NOT NULL COMMENT 'yyyymm',
  `status` VARCHAR(2) NOT NULL COMMENT '00创建10制表（汇总/调整）20上报',
  `sjswjg` VARCHAR(11) NOT NULL,
  `cjtime` DATETIME(6) NOT NULL,
  `cjr` VARCHAR(20) NOT NULL COMMENT '一般为系统admin',
  `zbtime` DATETIME(6) COMMENT '首次制表完成时间',
  `zbr` VARCHAR(20) COMMENT '制表人',
  `sbtime` DATETIME(6) COMMENT '上报时间',
  `sbr` VARCHAR(20),
  `chtime` DATETIME(6) COMMENT '撤回时间',
  `chr` VARCHAR(20) COMMENT '撤回人',
  `type` CHAR(1) NOT NULL COMMENT '1表示基层报表，由汇总服务从原始数据统计而得
2表示汇总报表，由基层报表汇总而得',
  `swjgmc` VARCHAR(60) NOT NULL,
  `swjgjc` VARCHAR(60),
  `note` VARCHAR(255),
  CONSTRAINT `PK_TJBB_TASK` PRIMARY KEY (`BBDLDM`, `SWJGDM`, `NY`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_TASK_SUB
-- Original Oracle primary-key constraint: PK_TJBB_TASK_SUB (MySQL index name: PRIMARY).
CREATE TABLE `TJBB_TASK_SUB` (
  `bbid` VARCHAR(64) NOT NULL COMMENT '报表id',
  `bbdm` VARCHAR(10) NOT NULL COMMENT '报表代码',
  `swjgdm` VARCHAR(11) NOT NULL COMMENT '报表机关代码',
  `ny` VARCHAR(6) NOT NULL COMMENT '年月yyyymm',
  `hztime` DATETIME(6) NOT NULL COMMENT '附表汇总的时间',
  `hzr` VARCHAR(20) NOT NULL COMMENT '汇总人',
  `xgtime` DATETIME(6) COMMENT '附表调整后保存时间',
  `xgr` VARCHAR(20) COMMENT '修改人',
  `bbdldm` VARCHAR(10) COMMENT '报表大类代码',
  CONSTRAINT `PK_TJBB_TASK_SUB` PRIMARY KEY (`BBID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TSGZ_CKTS_BDQSB
-- Original Oracle primary-key constraint: PK_TSGZ_CKTS_BDQSB (MySQL index name: PRIMARY).
CREATE TABLE `TSGZ_CKTS_BDQSB` (
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `xh` DECIMAL(10,0) NOT NULL COMMENT '序号',
  `ny` VARCHAR(6) COMMENT '年月',
  `tse_sb` DECIMAL(16,2) COMMENT '申报退税额',
  `mde_sb` DECIMAL(16,2) COMMENT '申报免抵额',
  `tse_sq` DECIMAL(16,2) COMMENT '上年同期退税额',
  `mde_sq` DECIMAL(16,2) COMMENT '上年同期免抵额',
  `tse_tblv` DECIMAL(16,2) COMMENT '退税额同比',
  `mde_tblv` DECIMAL(16,2) COMMENT '免抵额同比',
  CONSTRAINT `PK_TSGZ_CKTS_BDQSB` PRIMARY KEY (`SWJG_DM`, `XH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='态势感知-出口退税-近6个月退税变动趋势表';

-- Creating table TSGZ_CKTS_BDQSB_BACK_SBTJ
CREATE TABLE `TSGZ_CKTS_BDQSB_BACK_SBTJ` (
  `swjg_dm` VARCHAR(11) NOT NULL,
  `xh` DECIMAL(10,0) NOT NULL,
  `ny` VARCHAR(6),
  `tse_sb` DECIMAL(16,2),
  `mde_sb` DECIMAL(16,2),
  `tse_sq` DECIMAL(16,2),
  `mde_sq` DECIMAL(16,2),
  `tse_tblv` DECIMAL(16,2),
  `mde_tblv` DECIMAL(16,2)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TSGZ_CKTS_FLGLTJB
-- Original Oracle primary-key constraint: PK_TSGZ_CKTS_FLGLTJB (MySQL index name: PRIMARY).
CREATE TABLE `TSGZ_CKTS_FLGLTJB` (
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `ckqygllb_dm` CHAR(1) NOT NULL COMMENT '分类管理类别',
  `tse` DECIMAL(16,2) COMMENT '申报退税额',
  CONSTRAINT `PK_TSGZ_CKTS_FLGLTJB` PRIMARY KEY (`SWJG_DM`, `CKQYGLLB_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='态势感知-出口退税-按分类管理统计表';

-- Creating table TSGZ_CKTS_YWFLQKTJB
-- Original Oracle primary-key constraint: PK_TSGZ_CKTS_YWFLQKTJB (MySQL index name: PRIMARY).
CREATE TABLE `TSGZ_CKTS_YWFLQKTJB` (
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `sbywb_dm` VARCHAR(8) NOT NULL COMMENT '申报业务代码',
  `pc_sb` DECIMAL(10,0) COMMENT '申报批次数',
  `tse_sb` DECIMAL(16,2) COMMENT '申报退税额',
  `pc_sq` DECIMAL(10,0) COMMENT '申报批次数(上期)',
  `tse_sq` DECIMAL(16,2) COMMENT '申报退税额(上期)',
  `tblv_pc` DECIMAL(9,2) COMMENT '批次同比',
  `tblv_tse` DECIMAL(9,2) COMMENT '退税额同比',
  CONSTRAINT `PK_TSGZ_CKTS_YWFLQKTJB` PRIMARY KEY (`SWJG_DM`, `SBYWB_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='态势感知-出口退税-按业务分类退税情况统计表';

-- Creating table TSGZ_DZBA_BA_BDQSB
-- Original Oracle primary-key constraint: PK_TSGZ_DZBA_BA_BDQSB (MySQL index name: PRIMARY).
CREATE TABLE `TSGZ_DZBA_BA_BDQSB` (
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `xh` DECIMAL(10,0) NOT NULL COMMENT '序号',
  `cnt_dy` DECIMAL(10,0) COMMENT '当月批次数',
  `tse_dy` DECIMAL(16,2) COMMENT '当月退免税额',
  `cnt_lj` DECIMAL(10,0) COMMENT '累计批次数',
  `tse_lj` DECIMAL(16,2) COMMENT '累计退免税额',
  `ny` VARCHAR(6) COMMENT '年月',
  CONSTRAINT `PK_TSGZ_DZBA_BA_BDQSB` PRIMARY KEY (`SWJG_DM`, `XH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='态势感知-单证备案-备案变动趋势表';

-- Creating table TSGZ_DZBA_BA_DQQKB
-- Original Oracle primary-key constraint: PK_TSGZ_DZBA_BA_DQQKB (MySQL index name: PRIMARY).
CREATE TABLE `TSGZ_DZBA_BA_DQQKB` (
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `cnt_zb` DECIMAL(10,0) COMMENT '在备批次数',
  `cnt_yb` DECIMAL(10,0) COMMENT '已备批次数',
  `tse_zb` DECIMAL(16,2) COMMENT '在备退免税额',
  `tse_yb` DECIMAL(16,2) COMMENT '已备退免税额',
  `tse_bnlj` DECIMAL(16,2) COMMENT '本年累计退（免）税额',
  CONSTRAINT `PK_TSGZ_DZBA_BA_DQQKB` PRIMARY KEY (`SWJG_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='态势感知-单证备案-备案当前情况表';

-- Creating table TSGZ_DZBA_BA_TSFSTJB
-- Original Oracle primary-key constraint: PK_TSGZ_DZBA_BA_TSFSTJB (MySQL index name: PRIMARY).
CREATE TABLE `TSGZ_DZBA_BA_TSFSTJB` (
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `tsjsfs_dm` CHAR(1) NOT NULL COMMENT '退税计算方式',
  `cnt` DECIMAL(10,0) COMMENT '已备批次数',
  `tse` DECIMAL(16,2) COMMENT '已备案退免税额',
  CONSTRAINT `PK_TSGZ_DZBA_BA_TSFSTJB` PRIMARY KEY (`SWJG_DM`, `TSJSFS_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='态势感知-单证备案-备案按退税方式统计表';

-- Creating table TSGZ_DZBA_DJ_BDQSB
-- Original Oracle primary-key constraint: PK_TSGZ_DZBA_DJ_BDQSB (MySQL index name: PRIMARY).
CREATE TABLE `TSGZ_DZBA_DJ_BDQSB` (
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `xh` DECIMAL(10,0) NOT NULL COMMENT '序号',
  `djhs` DECIMAL(10,0) COMMENT '登记户数',
  `djhs_lj` DECIMAL(10,0) COMMENT '登记户数(累计)',
  `ny` VARCHAR(6) COMMENT '年月',
  CONSTRAINT `PK_TSGZ_DZBA_DJ_BDQSB` PRIMARY KEY (`SWJG_DM`, `XH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='态势感知-单证备案登记户数变动趋势表';

-- Creating table TSGZ_DZBA_DJ_HS
-- Original Oracle primary-key constraint: PK_TSGZ_DZBA_DJ_HS (MySQL index name: PRIMARY).
CREATE TABLE `TSGZ_DZBA_DJ_HS` (
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `djhs_wm` DECIMAL(10,0) COMMENT '外贸登记户数',
  `djhs_sc` DECIMAL(10,0) COMMENT '生产登记户数',
  `ckqyhs` DECIMAL(10,0) COMMENT '出口企业户数(取自金三，且是有退免税的活跃户)',
  CONSTRAINT `PK_TSGZ_DZBA_DJ_HS` PRIMARY KEY (`SWJG_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='态势感知-单证备案登记表户数';

-- Creating table TSGZ_DZBA_HC_QKTJB
-- Original Oracle primary-key constraint: PK_TSGZ_DZBA_HC_QKTJB (MySQL index name: PRIMARY).
CREATE TABLE `TSGZ_DZBA_HC_QKTJB` (
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `cnt_all` DECIMAL(10,0) COMMENT '核查业务笔数',
  `cnt_end` DECIMAL(10,0) COMMENT '结束业务笔数',
  `cnt_warn` DECIMAL(10,0) COMMENT '问题业务笔数',
  `tse_warn` DECIMAL(16,2) COMMENT '问题退免税额',
  `hcblv` DECIMAL(6,2) COMMENT '核查比率',
  CONSTRAINT `PK_TSGZ_DZBA_HC_QKTJB` PRIMARY KEY (`SWJG_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='态势感知-单证核查-情况统计表';

-- Creating table TSGZ_QT_BAXX
-- Original Oracle primary-key constraint: PK_TSGZ_DZBA_BAXX (MySQL index name: PRIMARY).
CREATE TABLE `TSGZ_QT_BAXX` (
  `swjg_dm` VARCHAR(11) NOT NULL,
  `cnt_add` DECIMAL(10,0) COMMENT '本年累计新增',
  `cnt_modify` DECIMAL(10,0) COMMENT '本年累计变更',
  `cnt_del` DECIMAL(10,0) COMMENT '本年累计注销',
  CONSTRAINT `PK_TSGZ_DZBA_BAXX` PRIMARY KEY (`SWJG_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='态势感知-备案信息本年累计-新增、变更、注销表';

-- Creating table TSGZ_QT_BAXZZX
-- Original Oracle primary-key constraint: PK_TSGZ_QT_BAXZZX (MySQL index name: PRIMARY).
CREATE TABLE `TSGZ_QT_BAXZZX` (
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `xh` DECIMAL(10,0) NOT NULL COMMENT '序号（xh为1-6，1为本月）',
  `ny` VARCHAR(6) COMMENT '年月',
  `cnt_add` DECIMAL(10,0) COMMENT '新增用户数',
  `cnt_del` DECIMAL(10,0) COMMENT '注销用户数',
  CONSTRAINT `PK_TSGZ_QT_BAXZZX` PRIMARY KEY (`XH`, `SWJG_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='态势感知-出口退税-近6个月新增注销备案企业';

-- Creating table TSGZ_QT_YWBLQKTJB
-- Original Oracle primary-key constraint: PK_TSGZ_QT_YWBLQKTJB (MySQL index name: PRIMARY).
CREATE TABLE `TSGZ_QT_YWBLQKTJB` (
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `sbzl_dm` CHAR(4) NOT NULL COMMENT '业务种类代码',
  `cnt_sb_dy` DECIMAL(10,0) COMMENT '当月申报笔数',
  `cnt_bl_dy` DECIMAL(10,0) COMMENT '当月办理笔数',
  `cnt_sb_lj` DECIMAL(10,0) COMMENT '累计申报笔数',
  `cnt_bl_lj` DECIMAL(10,0) COMMENT '累计办理笔数',
  CONSTRAINT `PK_TSGZ_QT_YWBLQKTJB` PRIMARY KEY (`SWJG_DM`, `SBZL_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='态势感知-其他-业务办理情况统计表';

-- Creating table TSGZ_SWJG
-- Original Oracle primary-key constraint: PK_TSGZ_SWJG (MySQL index name: PRIMARY).
CREATE TABLE `TSGZ_SWJG` (
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `qybj` CHAR(1) NOT NULL COMMENT '启用标记(Y:开启  N:关闭)',
  `crtime` DATETIME NOT NULL COMMENT '创建时间',
  CONSTRAINT `PK_TSGZ_SWJG` PRIMARY KEY (`SWJG_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='态势感知-抽取、加工数据的税务机关';

-- Creating table TSSH_MDTKB_DEL
CREATE TABLE `TSSH_MDTKB_DEL` (
  `no` VARCHAR(20) COMMENT '调库通知书号码',
  `ms_id` DECIMAL(38,0) NOT NULL,
  `item_no` VARCHAR(10) NOT NULL,
  `year` VARCHAR(4),
  `ym` VARCHAR(10),
  `uuid` VARCHAR(32),
  `lr_user` VARCHAR(32) DEFAULT ' ',
  `lr_date` DATETIME DEFAULT '1900-01-01 00:00:00',
  `op_user` VARCHAR(32) DEFAULT ' ',
  `op_date` DATETIME,
  `zf_flag` VARCHAR(1)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TSSH_TSTHS_DEL
CREATE TABLE `TSSH_TSTHS_DEL` (
  `no` VARCHAR(50) NOT NULL,
  `year` VARCHAR(4),
  `rq` DATETIME,
  `uuid` VARCHAR(32) DEFAULT (UPPER(REPLACE(UUID(), '-', ''))),
  `lr_user` VARCHAR(32) DEFAULT ' ',
  `lr_date` DATETIME DEFAULT '1900-01-01 00:00:00',
  KEY `IDX_TSTHS_DEL_NO` (`NO`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table VIP_MISSING_VOUCHER
-- Original Oracle primary-key constraint: PK_SJBL_ID (MySQL index name: PRIMARY).
CREATE TABLE `VIP_MISSING_VOUCHER` (
  `id` DECIMAL(20,0) NOT NULL,
  `nsrdzdah` DECIMAL(20,0) NOT NULL,
  `lx` CHAR(1) NOT NULL,
  `dzno` VARCHAR(30) NOT NULL,
  `dzrq` DATETIME NOT NULL,
  `ztbz` CHAR(1) NOT NULL COMMENT '0录入1已上传（提交）2已汇总9已补发（到达）',
  `crtime` DATETIME(6),
  `sctime` DATETIME(6),
  `hztime` DATETIME(6),
  `ddtime` DATETIME(6),
  `yxbz` CHAR(1),
  `tsflag` CHAR(1) DEFAULT '0',
  CONSTRAINT `PK_SJBL_ID` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table YJ_CS_BMD
-- Original Oracle primary-key constraint: PK_YJ_CS_BMD (MySQL index name: PRIMARY).
CREATE TABLE `YJ_CS_BMD` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '序号，由序列产生',
  `swjgdm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `nsrdzdah` DECIMAL(20,0) NOT NULL COMMENT '纳税人电子档案号',
  `yjcode` VARCHAR(3) NOT NULL COMMENT '预警代码',
  `objflag` CHAR(1) NOT NULL COMMENT '是否按对象放行，0整体放行 1按白名单子表（预警对象）进行放行',
  `yyms` VARCHAR(255) COMMENT '原因描述',
  `yxbz` CHAR(1) NOT NULL COMMENT '有效标志 Y/N',
  `lrr` VARCHAR(20) NOT NULL COMMENT '录入人',
  `lrrq` DATETIME NOT NULL COMMENT '录入时间',
  `xgr` VARCHAR(20) NOT NULL COMMENT '修改人',
  `xgrq` DATETIME NOT NULL COMMENT '修改时间',
  CONSTRAINT `PK_YJ_CS_BMD` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='预警白名单';

-- Creating table YJ_CS_BMD_SUB
-- Original Oracle primary-key constraint: PK_YJ_CS_BMD_SUB (MySQL index name: PRIMARY).
CREATE TABLE `YJ_CS_BMD_SUB` (
  `bsid` DECIMAL(18,0) NOT NULL COMMENT '序号，由序列产生',
  `bmdid` DECIMAL(18,0) NOT NULL COMMENT '关联白名单主表',
  `yj_object` VARCHAR(30) NOT NULL COMMENT '预警对象值',
  `yj_objname` VARCHAR(80) COMMENT '预警对象名称',
  `yxbz` CHAR(1) NOT NULL COMMENT '有效标志 Y/N',
  `lrr` VARCHAR(20) NOT NULL COMMENT '录入人',
  `lrrq` DATETIME NOT NULL COMMENT '录入时间',
  `xgr` VARCHAR(20) NOT NULL COMMENT '修改人',
  `xgrq` DATETIME NOT NULL COMMENT '修改时间',
  CONSTRAINT `PK_YJ_CS_BMD_SUB` PRIMARY KEY (`BSID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='预警白名单子表';

-- Creating table YJ_CS_MGKA_SC
-- Original Oracle primary-key constraint: PK_YJ_CS_MGKA_SC (MySQL index name: PRIMARY).
CREATE TABLE `YJ_CS_MGKA_SC` (
  `kacode` VARCHAR(4) NOT NULL COMMENT '口岸代码',
  `kaname` VARCHAR(50) COMMENT '口岸名称',
  `sheng` VARCHAR(50) COMMENT '所在省份',
  `yxbz` CHAR(1) NOT NULL COMMENT '有效标志 Y/N',
  CONSTRAINT `PK_YJ_CS_MGKA_SC` PRIMARY KEY (`KACODE`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='省正常周边口岸库';

-- Creating table YJ_CS_MGKA_WM
-- Original Oracle primary-key constraint: PK_YJ_CS_MGKA_WM (MySQL index name: PRIMARY).
CREATE TABLE `YJ_CS_MGKA_WM` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '序号，由序列产生',
  `swjgfw` VARCHAR(100) NOT NULL COMMENT '税务机关范围,例如：杭州13301%，绍兴13306%',
  `kacode` VARCHAR(4) NOT NULL COMMENT '口岸代码',
  `kaname` VARCHAR(50) COMMENT '口岸名称',
  `qsrq` DATETIME COMMENT '预警起始日期',
  `jzrq` DATETIME COMMENT '预警截止日期',
  `yyms` VARCHAR(255) COMMENT '原因描述',
  `lrr` VARCHAR(20) NOT NULL,
  `lrrq` DATETIME NOT NULL COMMENT '录入时间',
  `lrswjgdm` VARCHAR(11) NOT NULL COMMENT '录入税务机关代码',
  `yxbz` CHAR(1) NOT NULL,
  CONSTRAINT `PK_YJ_CS_MGKA_WM` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='敏感口岸库';

-- Creating table YJ_CS_MGSP
-- Original Oracle primary-key constraint: PK_YJ_CS_MGSP (MySQL index name: PRIMARY).
CREATE TABLE `YJ_CS_MGSP` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '序号，由序列产生',
  `swjgfw` VARCHAR(100) NOT NULL COMMENT '税务机关范围,例如：杭州13301%，绍兴13306%',
  `spdm` VARCHAR(20) NOT NULL COMMENT '商品代码（前4、6位）或完整代码',
  `spmc` VARCHAR(50) COMMENT '商品名称',
  `qsrq` DATETIME COMMENT '预警起始日期',
  `jzrq` DATETIME COMMENT '预警截止日期',
  `yyms` VARCHAR(255) COMMENT '原因描述',
  `lrr` VARCHAR(20) NOT NULL,
  `lrrq` DATETIME NOT NULL COMMENT '录入时间',
  `lrswjgdm` VARCHAR(11) NOT NULL COMMENT '录入税务机关代码',
  `yxbz` CHAR(1) NOT NULL COMMENT '有效标志 Y/N',
  CONSTRAINT `PK_YJ_CS_MGSP` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='敏感商品库';

-- Creating table YJ_CS_QSPJDJ_SC
-- Original Oracle primary-key constraint: PK_YJ_CS_QSPJDJ_SC_2025 (MySQL index name: PRIMARY).
CREATE TABLE `YJ_CS_QSPJDJ_SC` (
  `spdm` VARCHAR(20) NOT NULL,
  `spmc` VARCHAR(50),
  `qnt` DECIMAL(16,2) NOT NULL,
  `amt` DECIMAL(16,2) NOT NULL,
  `dj` DECIMAL(16,2),
  `qyhs` DECIMAL(10,0),
  `sbspmc` VARCHAR(100),
  `ywbs` DECIMAL(10,0),
  CONSTRAINT `PK_YJ_CS_QSPJDJ_SC_2025` PRIMARY KEY (`SPDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table YJ_CS_QSPJDJ_WM
-- Original Oracle primary-key constraint: PK_YJ_CS_QSPJDJ_WM_2025 (MySQL index name: PRIMARY).
CREATE TABLE `YJ_CS_QSPJDJ_WM` (
  `spdm` VARCHAR(20) NOT NULL,
  `spmc` VARCHAR(50),
  `qnt` DECIMAL(16,2) NOT NULL,
  `amt` DECIMAL(16,2) NOT NULL,
  `dj` DECIMAL(16,2),
  `qyhs` DECIMAL(10,0),
  `sbspmc` VARCHAR(100),
  `ywbs` DECIMAL(10,0),
  CONSTRAINT `PK_YJ_CS_QSPJDJ_WM_2025` PRIMARY KEY (`SPDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table YJ_CS_WMQYMMYLRL
-- Original Oracle primary-key constraint: PK_YJ_CS_WMQYMMYLRL (MySQL index name: PRIMARY).
CREATE TABLE `YJ_CS_WMQYMMYLRL` (
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `sbqyhs` DECIMAL(10,0) COMMENT '申报企业户数',
  `sbywbs` DECIMAL(10,0) COMMENT '申报业务笔数',
  `mmylrl_max` DECIMAL(10,2) COMMENT '最大值',
  `mmylrl_min` DECIMAL(10,2) COMMENT '最小值',
  `mmylrl_mid` DECIMAL(10,2) COMMENT '中位数',
  `mmylrl_avg` DECIMAL(10,2) COMMENT '平均值',
  `mmylrl_std` DECIMAL(10,2) COMMENT '标准差',
  `mylaj` DECIMAL(18,2) COMMENT '合计美元销售额',
  `rmblaj` DECIMAL(18,2) COMMENT '合计人民币销售额',
  `jhcb` DECIMAL(18,2) COMMENT '合计进货成本（计税金额+征税额-退税额）',
  `mmylrl_yjx` DECIMAL(10,2) COMMENT '综合每美元利润率',
  CONSTRAINT `PK_YJ_CS_WMQYMMYLRL` PRIMARY KEY (`SWJG_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='每美元利润率分析模型表（分税务机关）';

-- Creating table YJ_CS_WMQYMMYLRL_FQY
-- Original Oracle primary-key constraint: PK_YJ_CS_WMQYMMYLRL_FQY (MySQL index name: PRIMARY).
CREATE TABLE `YJ_CS_WMQYMMYLRL_FQY` (
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `sbywbs` DECIMAL(10,0) COMMENT '申报业务笔数',
  `mmylrl_max` DECIMAL(10,2) COMMENT '最大值',
  `mmylrl_min` DECIMAL(10,2) COMMENT '最小值',
  `mmylrl_mid` DECIMAL(10,2) COMMENT '中位数',
  `mmylrl_avg` DECIMAL(10,2) COMMENT '平均值',
  `mmylrl_std` DECIMAL(10,2) COMMENT '标准差',
  `mylaj` DECIMAL(18,2) COMMENT '合计美元销售额',
  `rmblaj` DECIMAL(18,2) COMMENT '合计人民币销售额',
  `jhcb` DECIMAL(18,2) COMMENT '合计进货成本（计税金额+征税额-退税额）',
  `mmylrl_yjx` DECIMAL(10,2) COMMENT '综合每美元利润率',
  CONSTRAINT `PK_YJ_CS_WMQYMMYLRL_FQY` PRIMARY KEY (`SWJG_DM`, `DJXH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='每美元利润率分析模型表（分企业）';

-- Creating table YJ_CS_YCGHQY
-- Original Oracle primary-key constraint: PK_YJ_CS_YCGHQY (MySQL index name: PRIMARY).
CREATE TABLE `YJ_CS_YCGHQY` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '序号，由序列产生',
  `swjgfw` VARCHAR(100) NOT NULL COMMENT '税务机关范围,例如：杭州13301%，绍兴13306%',
  `nsrsbh` VARCHAR(32) NOT NULL COMMENT '供货企业识别号',
  `nsrmc` VARCHAR(400) COMMENT '供货企业名称',
  `zgswjgmc` VARCHAR(50) COMMENT '供货企业主管税务机关名',
  `qsrq` DATETIME COMMENT '预警起始日期',
  `jzrq` DATETIME COMMENT '预警截止日期',
  `yyms` VARCHAR(255) COMMENT '原因描述',
  `lrr` VARCHAR(20) NOT NULL,
  `lrrq` DATETIME NOT NULL COMMENT '录入时间',
  `lrswjgdm` VARCHAR(11) NOT NULL COMMENT '录入税务机关代码',
  `yxbz` CHAR(1) NOT NULL COMMENT '有效标志 Y/N',
  CONSTRAINT `PK_YJ_CS_YCGHQY` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='异常供货企业库';

-- Creating table YJ_CS_YCHD
-- Original Oracle primary-key constraint: PK_YJ_CS_YCHD (MySQL index name: PRIMARY).
CREATE TABLE `YJ_CS_YCHD` (
  `fhbh` VARCHAR(20) NOT NULL COMMENT '复函编号',
  `fhrq` DATETIME COMMENT '复函日期',
  `nsrsbh` VARCHAR(20) NOT NULL COMMENT '纳税人识别号',
  `nsrmc` VARCHAR(80) COMMENT '纳税人名称',
  `zgswjgmc` VARCHAR(50) COMMENT '纳税人主管税务机关名',
  `fhnr` VARCHAR(1000) COMMENT '复函内容',
  `tbsj` DATETIME NOT NULL COMMENT '同步时间',
  `yxbz` CHAR(1) NOT NULL COMMENT '有效标志 Y/N',
  CONSTRAINT `PK_YJ_CS_YCHD` PRIMARY KEY (`FHBH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='异常函调信息库';

-- Creating table YJ_CS_YCHD_JS
-- Original Oracle primary-key constraint: PK_YJ_CS_YCHD_JS (MySQL index name: PRIMARY).
CREATE TABLE `YJ_CS_YCHD_JS` (
  `fhxxbuuid` VARCHAR(32) NOT NULL COMMENT '发函信息表UUID',
  `wsbh` VARCHAR(150) COMMENT '文书编号',
  `fahqfrq` DATETIME COMMENT '发函签发日期',
  `fahdswjg_dm` CHAR(11) COMMENT '发函地税务机关代码',
  `fahdswjgmc` VARCHAR(300) COMMENT '发函地税务机关名称',
  `ghqynsrsbh` VARCHAR(20) COMMENT '购货方企业纳税人识别号',
  `ghfqymc` VARCHAR(300) COMMENT '购货方企业名称',
  `ghfzgswjg_dm` CHAR(11) COMMENT '供货方主管税务机关代码',
  `ghfzgswjgmc` VARCHAR(300) COMMENT '供货方主管税务机关名称',
  `ghqynsrsbh_1` VARCHAR(20) COMMENT '供货方企业纳税人识别号',
  `ghfqymc_1` VARCHAR(300) COMMENT '供货方企业名称',
  `fpfs` DECIMAL(16,4) COMMENT '发票份数',
  `jehj` DECIMAL(18,2) COMMENT '金额合计',
  `sehj` DECIMAL(18,2) COMMENT '税额合计',
  `jshj` DECIMAL(18,2) COMMENT '价税合计',
  `fuhxxbuuid` VARCHAR(32) COMMENT '复函信息表UUID',
  `hshbh` VARCHAR(50) COMMENT '核实函编号',
  `fuhqfrq` DATETIME COMMENT '复函签发日期',
  `fuhlx_dm` CHAR(1) COMMENT '复函类型代码',
  `fuhclrq` DATETIME COMMENT '复函处理日期',
  `fuhclyj_dm` CHAR(1) COMMENT '复函处理意见代码',
  `hdjglx` CHAR(1) COMMENT '函调结果类型1未回函2回函异常未处理3不予退税处理',
  `crtime` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '数据扫描日期',
  KEY `IDX_YJ_CS_YCHD_JS_1` (`FAHDSWJG_DM`, `GHQYNSRSBH_1`, `GHQYNSRSBH`),
  CONSTRAINT `PK_YJ_CS_YCHD_JS` PRIMARY KEY (`FHXXBUUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='金三异常函调信息';

-- Creating table YJ_DATA_HYDBYZ
-- Original Oracle primary-key constraint: PK_YJ_DATA_HYDBYZ (MySQL index name: PRIMARY).
CREATE TABLE `YJ_DATA_HYDBYZ` (
  `tbpc` DECIMAL(18,0) COMMENT '同步批次',
  `id` DECIMAL(18,0) NOT NULL COMMENT '序号，由序列产生',
  `sbid` DECIMAL(18,0) NOT NULL COMMENT '申报ID',
  `nsrdzdah` DECIMAL(20,0) NOT NULL COMMENT '纳税人电子档案号',
  `cj_date` DATETIME NOT NULL COMMENT '创建时间',
  `yjcode` VARCHAR(3) NOT NULL COMMENT '预警代码',
  `zbcode` VARCHAR(5) COMMENT '预警指标',
  `yj_object` VARCHAR(40) COMMENT '预警对象值',
  `yj_count` DECIMAL(8,0) COMMENT '预警笔数',
  `yj_amt` DECIMAL(16,2) COMMENT '预警金额',
  `yj_tax` DECIMAL(16,2) COMMENT '预警税额',
  `yj_record` VARCHAR(30) COMMENT '关联号',
  `yj_msg` VARCHAR(1000) NOT NULL COMMENT '预警描述',
  `cl_date` DATETIME COMMENT '处理时间',
  `cl_flag` CHAR(1) COMMENT '处理标志',
  `cl_user` VARCHAR(30) COMMENT '处理人',
  `cl_msg` VARCHAR(255) COMMENT '处理意见',
  `bz` VARCHAR(255) COMMENT '备注',
  `sbym` VARCHAR(6) COMMENT '实际申报年月',
  `score` DECIMAL(8,0) COMMENT '评分',
  `swflag` CHAR(1) COMMENT '税务标志 1/0 （1展示给税务）',
  `qyflag` CHAR(1) COMMENT '企业标志 1/0 （1展示给企业）',
  `bmdflag` CHAR(1) COMMENT '白名单标志 0正常预警 1白名单 2预警关闭',
  `lcslid` CHAR(32) COMMENT 'LCSLID（根据业务事项取ZLCLCSLID=LCSLID的ZLCLCSLID)',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  KEY `IDX_YJ_DATA_HYDBYZ_CJSJ` (`CJ_DATE`),
  KEY `IDX_YJ_DATA_HYDBYZ_NSR` (`NSRDZDAH`),
  KEY `IDX_YJ_DATA_HYDBYZ_NYZO` (`SBID`, `NSRDZDAH`, `YJCODE`, `ZBCODE`, `YJ_OBJECT`),
  KEY `IDX_YJ_DATA_HYDBYZ_NYZR` (`SBID`, `NSRDZDAH`, `YJCODE`, `ZBCODE`, `YJ_RECORD`),
  CONSTRAINT `PK_YJ_DATA_HYDBYZ` PRIMARY KEY (`ID`, `SBID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='预警信息记录表';

-- Creating table YJ_DATA_SCORE
-- Original Oracle primary-key constraint: PK_YJ_DATA_SCORE (MySQL index name: PRIMARY).
CREATE TABLE `YJ_DATA_SCORE` (
  `nsrdzdah` DECIMAL(20,0) NOT NULL COMMENT '纳税人电子档案号',
  `score` DECIMAL(8,0) NOT NULL COMMENT '纳税人当前总评分',
  `yj_level` CHAR(1) COMMENT '预警等级，0无预警 1蓝色预警 2红色预警',
  `pgid` DECIMAL(18,0) COMMENT '评估ID，关联评估岗处理记录表',
  CONSTRAINT `PK_YJ_DATA_SCORE` PRIMARY KEY (`NSRDZDAH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='预警评分总表';

-- Creating table YJ_DATA_TSFPQYYHZ
-- Original Oracle primary-key constraint: PK_YJ_DATA_TSFPQYYHZ (MySQL index name: PRIMARY).
CREATE TABLE `YJ_DATA_TSFPQYYHZ` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `ny` CHAR(6) NOT NULL COMMENT '年月',
  `dfnsrsbh` VARCHAR(20) NOT NULL COMMENT '对方税号',
  `dfnsrmc` VARCHAR(100) COMMENT '对方名称',
  `fps` DECIMAL(10,0) COMMENT '发票份数',
  `je` DECIMAL(18,2) COMMENT '金额合计',
  `se` DECIMAL(18,2) COMMENT '税额合计',
  `sjgxsj` DATETIME COMMENT '数据更新时间',
  CONSTRAINT `PK_YJ_DATA_TSFPQYYHZ` PRIMARY KEY (`DJXH`, `NY`, `DFNSRSBH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='退税发票企业月汇总表（数据来源金三出口退税发票）';

-- Creating table YJ_DATA_YJXX
-- Original Oracle primary-key constraint: PK_YJ_DATA_YJXX (MySQL index name: PRIMARY).
CREATE TABLE `YJ_DATA_YJXX` (
  `tbpc` DECIMAL(18,0) COMMENT '同步批次',
  `id` DECIMAL(18,0) NOT NULL COMMENT '序号，由序列产生',
  `sbid` DECIMAL(18,0) NOT NULL COMMENT '申报ID',
  `nsrdzdah` DECIMAL(20,0) NOT NULL COMMENT '纳税人电子档案号',
  `cj_date` DATETIME NOT NULL COMMENT '创建时间',
  `yjcode` VARCHAR(3) NOT NULL COMMENT '预警代码',
  `zbcode` VARCHAR(5) COMMENT '预警指标',
  `yj_object` VARCHAR(40) COMMENT '预警对象值',
  `yj_count` DECIMAL(8,0) COMMENT '预警笔数',
  `yj_amt` DECIMAL(16,2) COMMENT '预警金额',
  `yj_tax` DECIMAL(16,2) COMMENT '预警税额',
  `yj_record` VARCHAR(30) COMMENT '关联号',
  `yj_msg` VARCHAR(1000) NOT NULL COMMENT '预警描述',
  `cl_date` DATETIME COMMENT '处理时间',
  `cl_flag` CHAR(1) COMMENT '处理标志',
  `cl_user` VARCHAR(30) COMMENT '处理人',
  `cl_msg` VARCHAR(255) COMMENT '处理意见',
  `bz` VARCHAR(255) COMMENT '备注',
  `sbym` VARCHAR(6) COMMENT '实际申报年月',
  `score` DECIMAL(8,0) COMMENT '评分',
  `swflag` CHAR(1) COMMENT '税务标志 1/0 （1展示给税务）',
  `qyflag` CHAR(1) COMMENT '企业标志 1/0 （1展示给企业）',
  `bmdflag` CHAR(1) COMMENT '白名单标志 0正常预警 1白名单 2预警关闭',
  KEY `IDX_YJ_DATA_YJXX_CJSJ` (`CJ_DATE`),
  KEY `IDX_YJ_DATA_YJXX_NSR` (`NSRDZDAH`),
  KEY `IDX_YJ_DATA_YJXX_NYZO` (`SBID`, `NSRDZDAH`, `YJCODE`, `ZBCODE`, `YJ_OBJECT`),
  KEY `IDX_YJ_DATA_YJXX_NYZR` (`SBID`, `NSRDZDAH`, `YJCODE`, `ZBCODE`, `YJ_RECORD`),
  KEY `IDX_YJ_DATA_YJXX_YJZB` (`ZBCODE`),
  CONSTRAINT `PK_YJ_DATA_YJXX` PRIMARY KEY (`ID`, `SBID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='预警信息记录表';

-- Creating table YJ_DIC_CODE
-- Original Oracle primary-key constraint: PK_YJ_DIC_CODE (MySQL index name: PRIMARY).
CREATE TABLE `YJ_DIC_CODE` (
  `yjcode` VARCHAR(3) NOT NULL COMMENT '预警代码',
  `yjname` VARCHAR(50) NOT NULL COMMENT '预警名称',
  `yjinfo` VARCHAR(1000) NOT NULL COMMENT '预警提示信息模版',
  `sysw` CHAR(1) NOT NULL COMMENT '适用税务 Y/N',
  `syqy` CHAR(1) NOT NULL COMMENT '适用企业 Y/N',
  `zxflag` CHAR(1) NOT NULL COMMENT '能否自选 Y/N（注仅全省通用的指标，允许自选，非全省通用指标默认设置N）',
  `yjobject` VARCHAR(50) COMMENT '预警对象名',
  `yxbz` CHAR(1) NOT NULL COMMENT '有效标准 Y/N',
  `yjlx` CHAR(1) NOT NULL COMMENT '预警类型 1综合预警 2按单预警 3汇总预警',
  `tsywlx` DECIMAL(38,0) COMMENT '退税业务类型 1生产 2外贸 4外综服 8周边业务',
  `swjg_fw` VARCHAR(100) COMMENT '适用税务机关范围集合（按税务机关代码有效位数省局3位地市级5位区县局7位）',
  CONSTRAINT `PK_YJ_DIC_CODE` PRIMARY KEY (`YJCODE`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='预警代码表';

-- Creating table YJ_DIC_HGHYD
CREATE TABLE `YJ_DIC_HGHYD` (
  `id` DECIMAL(18,0) NOT NULL,
  `hghyd_dm` VARCHAR(5) NOT NULL,
  `hghyd_mc` VARCHAR(50) NOT NULL,
  `xzqh_dm` VARCHAR(5),
  `xzqh_mc` VARCHAR(50),
  `qybz` CHAR(1)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table YJ_DIC_SWJG
-- Original Oracle primary-key constraint: PK_YJ_DIC_SWJG (MySQL index name: PRIMARY).
CREATE TABLE `YJ_DIC_SWJG` (
  `swjgdm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `yjcode` VARCHAR(3) NOT NULL COMMENT '预警代码',
  `qyflag` CHAR(1) NOT NULL COMMENT '启用标志 1/0',
  CONSTRAINT `PK_YJ_DIC_SWJG` PRIMARY KEY (`SWJGDM`, `YJCODE`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='预警代码地市机关开启关闭表';

-- Creating table YJ_DIC_YJZB
-- Original Oracle primary-key constraint: PK_YJ_DIC_YJZB (MySQL index name: PRIMARY).
CREATE TABLE `YJ_DIC_YJZB` (
  `yjcode` VARCHAR(3) NOT NULL COMMENT '预警代码',
  `yjname` VARCHAR(50) COMMENT '预警名称（冗余，为了看着方便）',
  `zbcode` VARCHAR(5) NOT NULL COMMENT '指标代码 前3位表示预警代码',
  `zbname` VARCHAR(80) NOT NULL COMMENT '指标名称',
  `jslx` CHAR(1) COMMENT '计算类型 1按报关单 2按批次汇总 3六个月汇总',
  `p1name` VARCHAR(80) COMMENT '参数1名称',
  `p1val` DECIMAL(16,2) COMMENT '参数1阀值',
  `p2name` VARCHAR(80) COMMENT '参数2名称',
  `p2val` DECIMAL(16,2) COMMENT '参数2阀值',
  `score` DECIMAL(8,0) COMMENT '评分',
  `yjmsg` VARCHAR(500),
  `note` VARCHAR(255) COMMENT '备注',
  `wsql` VARCHAR(4000) COMMENT '伪SQL代码',
  `sysw` CHAR(1) COMMENT '是否适用税务 1/0',
  `syqy` CHAR(1) COMMENT '是否适用企业 1/0',
  `p3name` VARCHAR(80) COMMENT '参数3名称',
  `p3val` DECIMAL(16,2) COMMENT '参数3阀值',
  `p4name` VARCHAR(80) COMMENT '参数4名称',
  `p4val` DECIMAL(16,2) COMMENT '参数4阀值',
  CONSTRAINT `PK_YJ_DIC_YJZB` PRIMARY KEY (`ZBCODE`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='预警指标字典表';

-- Creating table YJ_DIC_YJZBSWJG
-- Original Oracle primary-key constraint: PK_YJ_DIC_YJZBSWJG (MySQL index name: PRIMARY).
CREATE TABLE `YJ_DIC_YJZBSWJG` (
  `swjgdm` VARCHAR(11) NOT NULL COMMENT '税务机关代码(地市机关)',
  `zbcode` VARCHAR(5) NOT NULL COMMENT '指标代码',
  `p1val` DECIMAL(16,2) COMMENT '参数1阀值',
  `p2val` DECIMAL(16,2) COMMENT '参数2阀值',
  `score` DECIMAL(8,0) COMMENT '评分',
  `yxbz` CHAR(1) NOT NULL COMMENT '有效标志 Y/N',
  `p3val` DECIMAL(16,2) COMMENT '参数3阀值',
  `p4val` DECIMAL(16,2) COMMENT '参数4阀值',
  CONSTRAINT `PK_YJ_DIC_YJZBSWJG` PRIMARY KEY (`SWJGDM`, `ZBCODE`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='预警指标地市机关自定义参数表';

-- Creating table YJ_SBXX_HZ
-- Original Oracle primary-key constraint: PK_SB_SBXX_HZ (MySQL index name: PRIMARY).
CREATE TABLE `YJ_SBXX_HZ` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '主键，序列号',
  `nsrdzdah` DECIMAL(20,0) NOT NULL COMMENT '纳税人电子档案号',
  `sbywb_dm` VARCHAR(20) NOT NULL COMMENT '申报业务表代码（A0?0?0??）',
  `sssq` CHAR(6) COMMENT '所属时期，YYYYMM',
  `sbpc` DECIMAL(9,0) COMMENT '申报批次',
  `sbrq` DATETIME COMMENT '申报日期',
  `sbzt_dm` CHAR(2) NOT NULL COMMENT '初始：20，无预警信息：OK，有预警信息：YJ，流程已发放：30，流程已作废：40',
  `lzhj` VARCHAR(50) COMMENT '流转环节',
  `fkrq` DATETIME COMMENT '反馈日期',
  `fkxx` VARCHAR(255) COMMENT '反馈信息',
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
  `sbr` VARCHAR(20) COMMENT '申报人（webservice，czry_dm）',
  `sbfs` CHAR(1) COMMENT '申报方式（0或空-网报接口 1-文件读入）',
  `sbcs` DECIMAL(9,0) DEFAULT 0 COMMENT '申报次数，记录云平台正式申报提交次数，每正式申报同步一次加1',
  `zzsbb` CHAR(1) COMMENT '增值税报表是否已申报 0：金三系统中已经全申报   1：审核系统中已经全申报    空：没有全申报',
  `uuid` VARCHAR(50),
  KEY `IDX_SB_SBXX_HZ_SBZT` (`SBZT_DM`),
  KEY `IX_SB_SBXX_HZ_NSS` (`NSRDZDAH`, `SSSQ`, `SBYWB_DM`),
  UNIQUE KEY `UQ_YJ_SBXX_HZ_LC` (`LCSLID`),
  CONSTRAINT `PK_SB_SBXX_HZ` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table ZB_CKTSJH
CREATE TABLE `ZB_CKTSJH` (
  `swjg_dm` VARCHAR(11) NOT NULL,
  `ny` CHAR(6) NOT NULL COMMENT '年月',
  `byxdjhe` DECIMAL(16,4) COMMENT '本月下达计划额',
  `byxdjhe_y` DECIMAL(16,4),
  `syjzjhe` DECIMAL(16,4) COMMENT '上月结转计划额',
  `syjzjhe_y` DECIMAL(16,4),
  `byzhcktse` DECIMAL(16,4) COMMENT '本月追回出口退税款',
  `byzhcktse_y` DECIMAL(16,4),
  `byjhze` DECIMAL(16,4) COMMENT '本月计划总额 = 上三栏之和',
  `byjhze_y` DECIMAL(16,4),
  `byybltse` DECIMAL(16,4) COMMENT '本月已办理退税额',
  `byybltse_y` DECIMAL(16,4),
  `byjhye` DECIMAL(16,4) COMMENT '退税计划余额= 本月计划总额 - 本月已办理退税额',
  `byjhye_y` DECIMAL(16,4),
  `byjhwcl` DECIMAL(16,4) COMMENT '计划完成率= 本月已办理退税额/本月计划总额',
  `byjhwcl_y` DECIMAL(16,4),
  `bnljbltse` DECIMAL(16,4) COMMENT '本年累计办理退税（上月累计+本月已办理退税额），初值为上月累计',
  `bnljbltse_y` DECIMAL(16,4),
  `bnljyzhse` DECIMAL(16,4) COMMENT '本年累计已退税款追回',
  `bnljyzhse_y` DECIMAL(16,4),
  PRIMARY KEY (`SWJG_DM`, `NY`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table ZB_TSJHXD_WH
CREATE TABLE `ZB_TSJHXD_WH` (
  `whqx` VARCHAR(11) NOT NULL COMMENT '维护权限',
  `tszb_yn` VARCHAR(6) NOT NULL COMMENT '年月',
  `tszb_pc` VARCHAR(2) NOT NULL COMMENT '批次',
  `zbjg_dm` VARCHAR(11) NOT NULL COMMENT '指标机关代码',
  `tszbje` DECIMAL(16,2) NOT NULL COMMENT '退税指标金额',
  `lrr_dm` VARCHAR(20) COMMENT '录入人',
  `lrsj` DATETIME COMMENT '录入时间',
  `xgr_dm` VARCHAR(20) COMMENT '修改人',
  `xgsj` DATETIME COMMENT '修改时间',
  `sxbz` CHAR(1) DEFAULT '0' COMMENT '生效标志   0尚未生效  1已生效',
  PRIMARY KEY (`WHQX`, `TSZB_YN`, `TSZB_PC`, `ZBJG_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='退税指标计划-追加维护';

-- Creating table ZB_TSJHZX_HZB
CREATE TABLE `ZB_TSJHZX_HZB` (
  `tszb_yn` VARCHAR(6) NOT NULL COMMENT '年月',
  `zbjg_dm` VARCHAR(11) NOT NULL COMMENT '指标机关',
  `byxdjhe` DECIMAL(16,2) NOT NULL DEFAULT 0 COMMENT '本月下达计划额',
  `syjzjhe` DECIMAL(16,2) NOT NULL DEFAULT 0 COMMENT '上月结转计划额',
  `byzhtse` DECIMAL(16,2) NOT NULL DEFAULT 0 COMMENT '本月追回退税额',
  `byjhze` DECIMAL(16,2) NOT NULL DEFAULT 0 COMMENT '本月计划总额',
  `byybltse` DECIMAL(16,2) NOT NULL DEFAULT 0 COMMENT '本月已办理退税额',
  `byjhye` DECIMAL(16,2) NOT NULL DEFAULT 0 COMMENT '本月计划余额',
  `jhwcl` DECIMAL(6,2) NOT NULL DEFAULT 0 COMMENT '计划完成率',
  `bnljbltse` DECIMAL(16,2) NOT NULL DEFAULT 0 COMMENT '期初累计办理退税额',
  `bnljzhtse` DECIMAL(16,2) NOT NULL DEFAULT 0 COMMENT '期初累计追回退税额',
  `bnljxdjhe` DECIMAL(16,2) NOT NULL DEFAULT 0 COMMENT '期初累计下达计划额',
  `bnljjhwcl` DECIMAL(6,2) NOT NULL DEFAULT 0 COMMENT '本年累计计划完成率',
  `xgsj` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `lrsj` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`TSZB_YN`, `ZBJG_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table ZB_TSJHZX_HZB_13301TZ
CREATE TABLE `ZB_TSJHZX_HZB_13301TZ` (
  `tszb_yn` VARCHAR(6) NOT NULL,
  `zbjg_dm` VARCHAR(11) NOT NULL,
  `byxdjhe` DECIMAL(16,2) NOT NULL,
  `syjzjhe` DECIMAL(16,2) NOT NULL,
  `byzhtse` DECIMAL(16,2) NOT NULL,
  `byjhze` DECIMAL(16,2) NOT NULL,
  `byybltse` DECIMAL(16,2) NOT NULL,
  `byjhye` DECIMAL(16,2) NOT NULL,
  `jhwcl` DECIMAL(6,2) NOT NULL,
  `bnljbltse` DECIMAL(16,2) NOT NULL,
  `bnljzhtse` DECIMAL(16,2) NOT NULL,
  `bnljxdjhe` DECIMAL(16,2) NOT NULL,
  `bnljjhwcl` DECIMAL(6,2) NOT NULL,
  `xgsj` DATETIME,
  `lrsj` DATETIME
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table ZB_TSJHZX_HZB_BAK_13301YH_LP
CREATE TABLE `ZB_TSJHZX_HZB_BAK_13301YH_LP` (
  `tszb_yn` VARCHAR(6) NOT NULL,
  `zbjg_dm` VARCHAR(11) NOT NULL,
  `byxdjhe` DECIMAL(16,2) NOT NULL,
  `syjzjhe` DECIMAL(16,2) NOT NULL,
  `byzhtse` DECIMAL(16,2) NOT NULL,
  `byjhze` DECIMAL(16,2) NOT NULL,
  `byybltse` DECIMAL(16,2) NOT NULL,
  `byjhye` DECIMAL(16,2) NOT NULL,
  `jhwcl` DECIMAL(6,2) NOT NULL,
  `bnljbltse` DECIMAL(16,2) NOT NULL,
  `bnljzhtse` DECIMAL(16,2) NOT NULL,
  `bnljxdjhe` DECIMAL(16,2) NOT NULL,
  `bnljjhwcl` DECIMAL(6,2) NOT NULL,
  `xgsj` DATETIME,
  `lrsj` DATETIME
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

SET SESSION sql_mode = @yiziemei_mysql8_saved_sql_mode;
SET @yiziemei_mysql8_saved_sql_mode = NULL;
