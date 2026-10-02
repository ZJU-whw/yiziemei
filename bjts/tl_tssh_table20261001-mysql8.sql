-- MySQL 8.0.17+ / InnoDB; UTF-8 encoded.
-- Source: tl_tssh_table20261001-nodup.sql (strictly decoded from GBK).
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

-- Creating table ATFX_CK_JG_ACJFSTJ
-- Original Oracle primary-key constraint: PK_ATFX_CK_JG_ACJFSTJ (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_CK_JG_ACJFSTJ` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `ckny` VARCHAR(6) NOT NULL COMMENT '出口年月',
  `hgcjfs_dm` VARCHAR(1) NOT NULL COMMENT '海关成交方式代码',
  `hgcjfsmc` VARCHAR(100) COMMENT '海关成交方式名称',
  `bgdfs` DECIMAL(10,0) COMMENT '报关单份数',
  `hwmxts` DECIMAL(10,0) COMMENT '货物明细条数',
  `mylaj` DECIMAL(20,2) COMMENT '美元离岸价',
  `rmblaj` DECIMAL(20,2) COMMENT '人民币离岸价',
  CONSTRAINT `PK_ATFX_CK_JG_ACJFSTJ` PRIMARY KEY (`DJXH`, `CKNY`, `HGCJFS_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='按成交方式统计数据';

-- Creating table ATFX_CK_JG_ACKKATJ
-- Original Oracle primary-key constraint: PK_ATFX_CK_JG_ACKKATJ (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_CK_JG_ACKKATJ` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `ckny` VARCHAR(6) NOT NULL COMMENT '出口年月',
  `hggqka_dm` VARCHAR(4) NOT NULL COMMENT '海关关区（口岸）代码',
  `hggqkamc` VARCHAR(100) COMMENT '海关关区（口岸）名称',
  `bgdfs` DECIMAL(10,0) COMMENT '报关单份数',
  `hwmxts` DECIMAL(10,0) COMMENT '货物明细条数',
  `mylaj` DECIMAL(20,2) COMMENT '美元离岸价',
  `rmblaj` DECIMAL(20,2) COMMENT '人民币离岸价',
  `ysfs_jh` VARCHAR(100) COMMENT '当前口岸对应运输方式代码集合',
  CONSTRAINT `PK_ATFX_CK_JG_ACKKATJ` PRIMARY KEY (`DJXH`, `CKNY`, `HGGQKA_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='按出口口岸统计数据';

-- Creating table ATFX_CK_JG_ACKSPTJ
-- Original Oracle primary-key constraint: PK_ATFX_CK_JG_ACKSPTJ (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_CK_JG_ACKSPTJ` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `ckny` VARCHAR(6) NOT NULL COMMENT '出口年月',
  `cksp_dm` VARCHAR(20) NOT NULL COMMENT '出口商品代码',
  `ckspmc` VARCHAR(200) COMMENT '出口商品名称',
  `bgdfs` DECIMAL(10,0) COMMENT '报关单份数',
  `hwmxts` DECIMAL(10,0) COMMENT '货物明细条数',
  `mylaj` DECIMAL(20,2) COMMENT '美元离岸价',
  `rmblaj` DECIMAL(20,2) COMMENT '人民币离岸价',
  CONSTRAINT `PK_ATFX_CK_JG_ACKSPTJ` PRIMARY KEY (`DJXH`, `CKNY`, `CKSP_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='按出口商品统计数据';

-- Creating table ATFX_CK_JG_AHYDTJ
-- Original Oracle primary-key constraint: PK_ATFX_CK_JG_AHYDTJ (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_CK_JG_AHYDTJ` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `ckny` VARCHAR(6) NOT NULL COMMENT '出口年月',
  `hzdwdq_dm` VARCHAR(5) NOT NULL COMMENT '货源地代码',
  `hzdwdqmc` VARCHAR(100) COMMENT '货源地名称',
  `bgdfs` DECIMAL(10,0) COMMENT '报关单份数',
  `hwmxts` DECIMAL(10,0) COMMENT '货物明细条数',
  `mylaj` DECIMAL(20,2) COMMENT '美元离岸价',
  `rmblaj` DECIMAL(20,2) COMMENT '人民币离岸价',
  CONSTRAINT `PK_ATFX_CK_JG_AHYDTJ` PRIMARY KEY (`DJXH`, `CKNY`, `HZDWDQ_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='按货源地统计数据';

-- Creating table ATFX_CK_JG_AJGFSTJ
-- Original Oracle primary-key constraint: PK_ATFX_CK_JG_AJGFSTJ (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_CK_JG_AJGFSTJ` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `ckny` VARCHAR(6) NOT NULL COMMENT '出口年月',
  `jgfs_dm` VARCHAR(4) NOT NULL COMMENT '监管方式代码',
  `jgfsmc` VARCHAR(100) COMMENT '监管方式名称',
  `bgdfs` DECIMAL(10,0) COMMENT '报关单份数',
  `hwmxts` DECIMAL(10,0) COMMENT '货物明细条数',
  `mylaj` DECIMAL(20,2) COMMENT '美元离岸价',
  `rmblaj` DECIMAL(20,2) COMMENT '人民币离岸价',
  CONSTRAINT `PK_ATFX_CK_JG_AJGFSTJ` PRIMARY KEY (`DJXH`, `CKNY`, `JGFS_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='按监管方式统计数据';

-- Creating table ATFX_CK_JG_AKHTJ
-- Original Oracle primary-key constraint: PK_ATFX_CK_JG_AKHTJ (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_CK_JG_AKHTJ` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `ckny` VARCHAR(6) NOT NULL COMMENT '出口年月',
  `jwkh_mc` VARCHAR(200) NOT NULL COMMENT '境外客户名称',
  `bgdfs` DECIMAL(10,0) COMMENT '报关单份数',
  `hwmxts` DECIMAL(10,0) COMMENT '货物明细条数',
  `mylaj` DECIMAL(20,2) COMMENT '美元离岸价',
  `rmblaj` DECIMAL(20,2) COMMENT '人民币离岸价',
  CONSTRAINT `PK_ATFX_CK_JG_AKHTJ` PRIMARY KEY (`DJXH`, `CKNY`, `JWKH_MC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='按出口客户统计数据';

-- Creating table ATFX_CK_JG_AMDGTJ
-- Original Oracle primary-key constraint: PK_ATFX_CK_JG_AMDGTJ (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_CK_JG_AMDGTJ` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `ckny` VARCHAR(6) NOT NULL COMMENT '出口年月',
  `zzmdgdqsz_dm` VARCHAR(3) NOT NULL COMMENT '最终目的国（地区）数字代码',
  `zzmdgdqmc` VARCHAR(100) COMMENT '最终目的国（地区）名称',
  `bgdfs` DECIMAL(10,0) COMMENT '报关单份数',
  `hwmxts` DECIMAL(10,0) COMMENT '货物明细条数',
  `mylaj` DECIMAL(20,2) COMMENT '美元离岸价',
  `rmblaj` DECIMAL(20,2) COMMENT '人民币离岸价',
  CONSTRAINT `PK_ATFX_CK_JG_AMDGTJ` PRIMARY KEY (`DJXH`, `CKNY`, `ZZMDGDQSZ_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='按最终目的国统计数据';

-- Creating table ATFX_CK_JG_AMYGTJ
-- Original Oracle primary-key constraint: PK_ATFX_CK_JG_AMYGTJ (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_CK_JG_AMYGTJ` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `ckny` VARCHAR(6) NOT NULL COMMENT '出口年月',
  `mygdqsz_dm` VARCHAR(3) NOT NULL COMMENT '贸易国（地区）数字代码',
  `mygdqmc` VARCHAR(100) COMMENT '贸易国（地区）名称',
  `bgdfs` DECIMAL(10,0) COMMENT '报关单份数',
  `hwmxts` DECIMAL(10,0) COMMENT '货物明细条数',
  `mylaj` DECIMAL(20,2) COMMENT '美元离岸价',
  `rmblaj` DECIMAL(20,2) COMMENT '人民币离岸价',
  CONSTRAINT `PK_ATFX_CK_JG_AMYGTJ` PRIMARY KEY (`DJXH`, `CKNY`, `MYGDQSZ_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='按贸易国统计数据';

-- Creating table ATFX_CK_JG_ANYTJ
-- Original Oracle primary-key constraint: PK_ATFX_CK_JG_ANYTJ (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_CK_JG_ANYTJ` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `ckny` VARCHAR(6) NOT NULL COMMENT '出口年月',
  `bgdfs` DECIMAL(10,0) COMMENT '报关单份数',
  `hwmxts` DECIMAL(10,0) COMMENT '货物明细条数',
  `mylaj` DECIMAL(20,2) COMMENT '美元离岸价',
  `rmblaj` DECIMAL(20,2) COMMENT '人民币离岸价',
  CONSTRAINT `PK_ATFX_CK_JG_ANYTJ` PRIMARY KEY (`DJXH`, `CKNY`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='按年月统计出口数据';

-- Creating table ATFX_CK_JG_AYSFSTJ
-- Original Oracle primary-key constraint: PK_ATFX_CK_JG_AYSFSTJ (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_CK_JG_AYSFSTJ` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `ckny` VARCHAR(6) NOT NULL COMMENT '出口年月',
  `ysfs_dm` VARCHAR(2) NOT NULL COMMENT '运输方式代码',
  `ysfsmc` VARCHAR(100) COMMENT '运输方式名称',
  `bgdfs` DECIMAL(10,0) COMMENT '报关单份数',
  `hwmxts` DECIMAL(10,0) COMMENT '货物明细条数',
  `mylaj` DECIMAL(20,2) COMMENT '美元离岸价',
  `rmblaj` DECIMAL(20,2) COMMENT '人民币离岸价',
  CONSTRAINT `PK_ATFX_CK_JG_AYSFSTJ` PRIMARY KEY (`DJXH`, `CKNY`, `YSFS_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='按运输方式统计数据';

-- Creating table ATFX_CK_YS_CKDZXX
-- Original Oracle primary-key constraint: PK_ATFX_CK_YS_CKDZXX (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_CK_YS_CKDZXX` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID，主键',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `ydjxh` DECIMAL(20,0) COMMENT '原登记序号（提取已委托代办退税的报关单时需要，其它类型为Null）',
  `ckbgdh` VARCHAR(21) NOT NULL COMMENT '出口报关单号',
  `dlckhwzmhm` VARCHAR(20) COMMENT '代理出口货物证明号码',
  `hgckhwbgdsbrq` DATETIME COMMENT '海关出口货物报关单申报日期',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `ckny` VARCHAR(6) COMMENT '出口年月（代理证明出口年月需通过出口日期转换）',
  `cksp_dm` VARCHAR(20) NOT NULL COMMENT '出口商品代码',
  `gfhhgspmc` VARCHAR(500) COMMENT '规范化海关商品名称',
  `ggxh` VARCHAR(150) COMMENT '规格型号',
  `dyjldw_dm` VARCHAR(3) COMMENT '第一计量单位代码',
  `hgjldwmc` VARCHAR(75) COMMENT '海关计量单位名称',
  `cksl` DECIMAL(18,6) COMMENT '出口数量',
  `dejldw_dm` VARCHAR(3) COMMENT '第二计量单位代码',
  `decksl` DECIMAL(18,6) COMMENT '第二出口数量',
  `sbjldw_dm` VARCHAR(3) COMMENT '申报计量单位代码',
  `sbsl_1` DECIMAL(18,6) COMMENT '申报数量',
  `cjhghbsz_dm` VARCHAR(3) COMMENT '成交海关货币数字代码',
  `cjzj` DECIMAL(18,2) COMMENT '成交总价',
  `yfjsfs_dm` CHAR(1) COMMENT '运费计算方式代码',
  `yfhghbsz_dm` CHAR(3) COMMENT '运费海关货币数字代码',
  `yfhl` DECIMAL(16,6) COMMENT '运费汇率',
  `bfjsfs_dm` CHAR(1) COMMENT '保费计算方式代码',
  `bfhghbsz_dm` CHAR(3) COMMENT '保费海关货币数字代码',
  `bfhl` DECIMAL(16,6) COMMENT '保费汇率',
  `zfjsfs_dm` CHAR(1) COMMENT '杂费计算方式代码',
  `zfhghbsz_dm` CHAR(3) COMMENT '杂费海关货币数字代码',
  `zfhl` DECIMAL(16,6) COMMENT '杂费汇率',
  `rmblaj` DECIMAL(18,2) COMMENT '人民币离岸价',
  `mylaj` DECIMAL(18,2) COMMENT '美元离岸价',
  `mygdqsz_dm` VARCHAR(3) COMMENT '贸易国（地区）数字代码',
  `zzmdgdqsz_dm` VARCHAR(3) COMMENT '最终目的国（地区）数字代码',
  `hggqka_dm` VARCHAR(4) COMMENT '海关关区（口岸）代码',
  `jgfs_dm` VARCHAR(4) COMMENT '监管方式代码',
  `hgcjfs_dm` VARCHAR(1) COMMENT '海关成交方式代码',
  `jhfs_dm` VARCHAR(1) COMMENT '结汇方式代码',
  `zyg_dm` VARCHAR(6) COMMENT '指运港代码',
  `ysfs_dm` VARCHAR(1) COMMENT '运输方式代码',
  `ysgjmc` VARCHAR(100) COMMENT '运输工具名称',
  `hch` VARCHAR(32) COMMENT '航次号',
  `js_1` DECIMAL(10,0) COMMENT '件数',
  `jz` DECIMAL(18,3) COMMENT '净重',
  `mz_2` DECIMAL(18,3) COMMENT '毛重',
  `qygbz` VARCHAR(1) COMMENT '启运港标志（代理证明没有启运港标志，默认为null）',
  `jydwmc` VARCHAR(200) COMMENT '经营单位名称',
  `hzdwdm` VARCHAR(20) COMMENT '货主单位代码',
  `hzdwmc` VARCHAR(200) COMMENT '货主单位名称',
  `hzdwdq_dm` VARCHAR(5) COMMENT '货主单位地区代码（代理证明用境内货源地代码）',
  `sbdwdm` VARCHAR(20) COMMENT '申报单位代码',
  `sbdwmc` VARCHAR(200) COMMENT '申报单位名称',
  `tydh` VARCHAR(32) COMMENT '提运单号',
  `ckhth` VARCHAR(60) COMMENT '出口合同号',
  `bah` VARCHAR(20) COMMENT '备案号',
  `sjlx` VARCHAR(20) COMMENT '数据类型（加工数据：自行出口、代理出口、代办退税）',
  `jzqks` DECIMAL(18,6) COMMENT '净重千克数（根据报关单第一、第二、成交单位，取其中重量单位并将对应出口数量转换为千克，用于后期统一计算重量单价）',
  `ckfphm` VARCHAR(30) COMMENT '出口发票号码（通过企业退税申报出口明细获取）',
  `jwshr` VARCHAR(200) COMMENT '境外收货人（通过出口发票号码，从出口发票数据提取国外客户名称写入）',
  `bjmmjbz` VARCHAR(500) COMMENT '标记唛码及备注（按18位报关单号从BGD204表中提取第一条数据写入）',
  `jzxh` VARCHAR(2000) COMMENT '集装箱号（按18位报关单号从BGD204表获取所有记录拼接）',
  `cytssbjl` VARCHAR(60) COMMENT '参与退税申报记录',
  `tssbmylaj` DECIMAL(18,2) COMMENT '退税申报美元离岸价',
  `tssbrmblaj` DECIMAL(18,2) COMMENT '退税申报人民币离岸价',
  `tssbsl` DECIMAL(18,6) COMMENT '退税申报数量',
  `bytsbz` VARCHAR(1) COMMENT '不予退税标志',
  `tymylaj` DECIMAL(18,2) COMMENT '退运美元离岸价',
  `tyrmblaj` DECIMAL(18,2) COMMENT '退运人民币离岸价',
  `tysl` DECIMAL(18,6) COMMENT '退运数量',
  `dlsbmylaj` DECIMAL(18,2) COMMENT '代理申报美元离岸价（数据源为代理证明时为Null）',
  `dlsbrmblaj` DECIMAL(18,2) COMMENT '代理申报人民币离岸价（数据源为代理证明时为null）',
  `dlsbsl` DECIMAL(18,6) COMMENT '代理申报数量（数据源为代理证明时为null）',
  KEY `IDX_ATFX_CK_YS_CKDZXX_DC` (`DJXH`, `CKNY`),
  CONSTRAINT `PK_ATFX_CK_YS_CKDZXX` PRIMARY KEY (`DJXH`, `CKBGDH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口业务电子信息表';

-- Creating table ATFX_CS_SPHFWSSFLYBM
CREATE TABLE `ATFX_CS_SPHFWSSFLYBM` (
  `sphfwssflbm_p` VARCHAR(2) NOT NULL COMMENT '商品和服务税收分类编码_篇||取值区间为0到6',
  `sphfwssflbm_l` CHAR(2) NOT NULL COMMENT '商品和服务税收分类编码_类||取值区间为00到10',
  `sphfwssflbm_z` CHAR(2) NOT NULL COMMENT '商品和服务税收分类编码_章||取值区间为00到10',
  `sphfwssflbm_j` CHAR(2) NOT NULL COMMENT '商品和服务税收分类编码_节||取值区间为00到10',
  `sphfwssflbm_t` CHAR(2) NOT NULL COMMENT '商品和服务税收分类编码_条||取值区间为00到10',
  `sphfwssflbm_k` CHAR(2) NOT NULL COMMENT '商品和服务税收分类编码_款||取值区间为00到10',
  `sphfwssflbm_x` CHAR(2) NOT NULL COMMENT '商品和服务税收分类编码_项||取值区间为00到10',
  `sphfwssflbm_m` CHAR(2) NOT NULL COMMENT '商品和服务税收分类编码_目||取值区间为00到10',
  `sphfwssflbm_zm` CHAR(2) NOT NULL COMMENT '商品和服务税收分类编码_子目||取值区间为00到10',
  `sphfwssflbm_xm` CHAR(2) NOT NULL COMMENT '商品和服务税收分类编码_细目||取值区间为00到10',
  `sphfwssflhbbm` CHAR(19) NOT NULL COMMENT '商品和服务税收分类合并编码',
  `hwhlwmc` VARCHAR(150) NOT NULL COMMENT '货物和劳务名称',
  `sphfwfljc` VARCHAR(300) NOT NULL COMMENT '商品和服务分类简称',
  `xybz` CHAR(1) NOT NULL COMMENT '选用标志',
  `yxbz` CHAR(1) NOT NULL COMMENT '有效标志',
  `bz` VARCHAR(3000) COMMENT '备注'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='商品和服务税收分类与编码';

-- Creating table ATFX_FP_JG_AGYSTJ
-- Original Oracle primary-key constraint: PK_ATFX_FP_JG_AGYSTJ (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_FP_JG_AGYSTJ` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `kpny` VARCHAR(6) NOT NULL COMMENT '开票年月',
  `gyssbh` VARCHAR(20) NOT NULL COMMENT '供应商识别号',
  `gysmc` VARCHAR(200) NOT NULL COMMENT '供应商名称',
  `sphfwssflhbbm` VARCHAR(19) NOT NULL COMMENT '商品和服务税收分类合并编码',
  `hwhyslwfwmc` VARCHAR(200) COMMENT '货物或应税劳务、服务名称',
  `je` DECIMAL(20,2) COMMENT '金额',
  `se` DECIMAL(20,2) COMMENT '税额',
  CONSTRAINT `PK_ATFX_FP_JG_AGYSTJ` PRIMARY KEY (`DJXH`, `KPNY`, `GYSSBH`, `SPHFWSSFLHBBM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='供应商供货统计数据表';

-- Creating table ATFX_FP_JG_ANYTJJH
-- Original Oracle primary-key constraint: PK_ATFX_FP_JG_ANYTJJH (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_FP_JG_ANYTJJH` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `kpny` VARCHAR(6) NOT NULL COMMENT '开票年月',
  `je_hw` DECIMAL(20,2) COMMENT '金额(货物)',
  `se_hw` DECIMAL(20,2) COMMENT '税额(货物)',
  `je_fw` DECIMAL(20,2) COMMENT '金额(服务)',
  `se_fw` DECIMAL(20,2) COMMENT '税额(服务)',
  KEY `IDX_ANYTJJH_DJXH` (`DJXH`),
  KEY `IDX_ANYTJJH_KPNY` (`KPNY`),
  CONSTRAINT `PK_ATFX_FP_JG_ANYTJJH` PRIMARY KEY (`DJXH`, `KPNY`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='按年月统计进货数据表';

-- Creating table ATFX_FP_JG_ANYTJXS
-- Original Oracle primary-key constraint: PK_ATFX_FP_JG_ANYTJXS (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_FP_JG_ANYTJXS` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `kpny` VARCHAR(6) NOT NULL COMMENT '开票年月',
  `je` DECIMAL(20,2) COMMENT '金额',
  `se` DECIMAL(20,2) COMMENT '税额',
  `je_nx` DECIMAL(20,2) COMMENT '金额（内销）',
  `se_nx` DECIMAL(20,2) COMMENT '税额（内销）',
  `je_wx` DECIMAL(20,2) COMMENT '金额（外销）',
  `se_wx` DECIMAL(20,2) COMMENT '税额（外销）',
  CONSTRAINT `PK_ATFX_FP_JG_ANYTJXS` PRIMARY KEY (`DJXH`, `KPNY`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='按年月统计销售数据';

-- Creating table ATFX_FP_JG_GYSJCXX
-- Original Oracle primary-key constraint: PK_ATFX_FP_JG_GYSJCXX (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_FP_JG_GYSJCXX` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `gyssbh` VARCHAR(20) NOT NULL COMMENT '供应商识别号',
  `gysmc` VARCHAR(200) NOT NULL COMMENT '供应商名称',
  `gys_sjswjg_dm` VARCHAR(11) COMMENT '供应商省局代码',
  `gys_dsswjg_dm` VARCHAR(11) COMMENT '供应商地市局代码',
  `gys_qxswjg_dm` VARCHAR(11) COMMENT '供应商区县局代码',
  `gys_sckprq` DATETIME COMMENT '供应商给本企业首次开票日期',
  `gys_sctssbrq` DATETIME COMMENT '供应商给本企业首次退税申报日期（从免退税进货明细、代办退税明细统计）',
  `gys_bssckprq` DATETIME COMMENT '供应商给本省企业最早开票日期',
  `gys_bskphs` DECIMAL(10,0) COMMENT '供应商在本省开票户数',
  `gys_djrq` DATETIME COMMENT '供应商登记日期（仅限省内供货企业）',
  `gys_nsrzt_dm` VARCHAR(2) COMMENT '供应商纳税人状态代码（仅限省内供货企业）',
  KEY `IDX_GYSJCXX_DJXH` (`DJXH`),
  KEY `IDX_GYSJCXX_GYSSBH` (`GYSSBH`),
  KEY `IDX_GYSJCXX_GYS_NSRZT_DM` (`GYS_NSRZT_DM`),
  KEY `IDX_GYSJCXX_GYS_SCKPRQ` (`GYS_SCKPRQ`),
  KEY `IDX_GYSJCXX_GYS_SCTSSBRQ` (`GYS_SCTSSBRQ`),
  KEY `IDX_GYSJCXX_GYS_SJSWJG_DM` (`GYS_SJSWJG_DM`),
  CONSTRAINT `PK_ATFX_FP_JG_GYSJCXX` PRIMARY KEY (`DJXH`, `GYSSBH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='供应商基础信息表';

-- Creating table ATFX_FP_JG_KHXX
-- Original Oracle primary-key constraint: PK_ATFX_FP_JG_KHXX (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_FP_JG_KHXX` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `gmf_mc` VARCHAR(200) NOT NULL COMMENT '购买方名称',
  `gmf_sckprq` DATETIME COMMENT '首次销售日期',
  `gmf_gbdq` VARCHAR(100) COMMENT '购买方国别（国内省外为省、省内为地市）',
  CONSTRAINT `PK_ATFX_FP_JG_KHXX` PRIMARY KEY (`DJXH`, `GMF_MC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='客户信息统计数据表';

-- Creating table ATFX_FP_JG_NXKPTJ
-- Original Oracle primary-key constraint: PK_ATFX_FP_JG_NXKPTJ (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_FP_JG_NXKPTJ` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `kpny` VARCHAR(6) NOT NULL COMMENT '开票年月',
  `gmfmc` VARCHAR(200) NOT NULL COMMENT '购买方名称',
  `sphfwssflhbbm` VARCHAR(19) NOT NULL COMMENT '商品和服务税收分类合并编码',
  `hwhyslwfwmc` VARCHAR(200) COMMENT '货物或应税劳务、服务名称',
  `je` DECIMAL(20,2) COMMENT '金额',
  `se` DECIMAL(20,2) COMMENT '税额（根据出口发票统计，有可能有出口应征税货物存在税额）',
  CONSTRAINT `PK_ATFX_FP_JG_NXKPTJ` PRIMARY KEY (`DJXH`, `KPNY`, `GMFMC`, `SPHFWSSFLHBBM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='内销开票统计数据';

-- Creating table ATFX_FP_JG_WXKPTJ
-- Original Oracle primary-key constraint: PK_ATFX_FP_JG_WXKPTJ (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_FP_JG_WXKPTJ` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `kpny` VARCHAR(6) NOT NULL COMMENT '开票年月',
  `jwkh_mc` VARCHAR(200) NOT NULL COMMENT '境外客户名称',
  `sphfwssflhbbm` VARCHAR(19) NOT NULL COMMENT '商品和服务税收分类合并编码',
  `hwhyslwfwmc` VARCHAR(200) COMMENT '货物或应税劳务、服务名称',
  `je` DECIMAL(20,2) COMMENT '金额',
  `se` DECIMAL(20,2) COMMENT '税额（根据出口发票统计，有可能有出口应征税货物存在税额）',
  CONSTRAINT `PK_ATFX_FP_JG_WXKPTJ` PRIMARY KEY (`DJXH`, `KPNY`, `JWKH_MC`, `SPHFWSSFLHBBM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='外销开票统计数据';

-- Creating table ATFX_FP_YS_JHFPXX
-- Original Oracle primary-key constraint: PK_ATFX_FP_YS_JHFPXX (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_FP_YS_JHFPXX` (
  `fphm` VARCHAR(30) NOT NULL COMMENT '发票号码（主键，底账系统用发票代码||发票号码）',
  `xh` DECIMAL(10,0) NOT NULL COMMENT '序号（主键，底账货物对应MXXH）',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号（数据抽取时填入，多个企业分析时区分企业数据）',
  `kpyf` VARCHAR(6) COMMENT '开票月份（数电票需通过开票日期转换）',
  `kprq` DATETIME COMMENT '开票日期',
  `xsfnsrsbh` VARCHAR(20) NOT NULL COMMENT '销售方纳税人识别代号（底账电子专票对应XSFSBH，其他对应XFSBH）',
  `xsfmc` VARCHAR(300) NOT NULL COMMENT '销售方名称（底账非电子专票对应XFMC字段）',
  `xsfdjxh` DECIMAL(20,0) COMMENT '销售方登记序号（数电票XHFDJXH，底账发票没有对应字段，默认为null）',
  `dk_xsfsbh` VARCHAR(20) COMMENT '代开_销售方识别号（底账专用发票对应字段，其它为null）',
  `dk_xsfmc` VARCHAR(300) COMMENT '代开_销售方名称（底账专用发票对应字段，其它为null）',
  `gmfnsrsbh` VARCHAR(20) NOT NULL COMMENT '购买方纳税人识别号（底账电子专票对应GMFSBH，其他对应GFSBH）',
  `gmfmc` VARCHAR(300) NOT NULL COMMENT '购买方名称（底账非电子专票对应GFMC字段）',
  `gmfdjxh` DECIMAL(20,0) COMMENT '购买方登记序号（底账发票没有对应字段，默认为null）',
  `xsfssjswjg_dm` VARCHAR(11) COMMENT '销售方_省级税务机关代码（底账系统对应XF_SJSWJG_DM字段）',
  `xsfdsjswjg_dm` VARCHAR(11) COMMENT '销售方_地市级税务机关代码（底账系统对应XF_FSSWJG_DM字段）',
  `xsfzgswj_dm` VARCHAR(11) COMMENT '销售方_主管税务局代码（底账系统对应XF_QXSWJG_DM字段）',
  `xsfzgswskfj_dm` VARCHAR(11) COMMENT '销售方_主管税务所代码（底账发票没有对应字段，默认为null）',
  `gmfssjswjg_dm` VARCHAR(11) COMMENT '购买方_省市级税务机关代码（底账系统对应GF_SJSWJG_DM字段）',
  `gmfdsjswjg_dm` VARCHAR(11) COMMENT '购买方_地市级税务机关代码（底账系统对应GF_DSSWJG_DM字段）',
  `gmfzgswj_dm` VARCHAR(11) COMMENT '购买方_主管税务局代码（底账系统对应GF_QXSWJG_DM字段）',
  `gmfzgswskfj_dm` VARCHAR(11) COMMENT '购买方_主管税务所代码（底账发票没有对应字段，默认为null）',
  `kjhzfpdydlzfphm` VARCHAR(30) COMMENT '开具红字对应的蓝字发票号码（底账系统用原发票代码||原发票号码）',
  `hjje` DECIMAL(18,2) COMMENT '合计金额（底账发票对应JE）',
  `hjse` DECIMAL(18,2) COMMENT '合计税额（底账发票对应SE）',
  `jshj` DECIMAL(18,2) COMMENT '价税合计',
  `sphfwssflhbbm` VARCHAR(20) COMMENT '商品和服务税收分类合并编码（底账货物对应SPBM）',
  `hwhyslwfwmc` VARCHAR(300) NOT NULL COMMENT '货物或应税劳务、服务名称（底账货物对应MC）',
  `ggxh` VARCHAR(300) COMMENT '规格型号',
  `jldw` VARCHAR(30) COMMENT '单位（数电票对应DW）',
  `fpspsl` VARCHAR(30) COMMENT '数量（底账货物对应SL）',
  `fpspdj` VARCHAR(30) COMMENT '单价（底账货物对应DJ）',
  `je` DECIMAL(18,2) COMMENT '金额',
  `se` DECIMAL(18,2) COMMENT '税额',
  `fppz_dm` VARCHAR(10) COMMENT '发票票种代码（底账电子专票对应TSPZ字段，底账其他发票对应TSPZ_DM字段）',
  `sflzfp` CHAR(1) COMMENT '是否蓝字发票（底账电子专票对应FPZTBZ，其他对应FPZT_BZ；0蓝字→Y，1红字→N）',
  `fpzt_dm` VARCHAR(10) COMMENT '发票状态代码（数电票目前没有对应字段）',
  `fplx` VARCHAR(20) COMMENT '发票类型（普通发票/专用发票/数电发票，数据抽取时打标记）',
  `sjlx` VARCHAR(30) COMMENT '数据类型（原材料、生产设备等，后期可人工打标记，标记后需重新加工进货发票数据）',
  `slv` DECIMAL(16,6),
  KEY `IDX_JHFPXX_DJXH` (`DJXH`),
  KEY `IDX_JHFPXX_FPLX` (`FPLX`),
  KEY `IDX_JHFPXX_GMFNSRSBH` (`GMFNSRSBH`),
  KEY `IDX_JHFPXX_KPRQ` (`KPRQ`),
  KEY `IDX_JHFPXX_SJLX` (`SJLX`),
  KEY `IDX_JHFPXX_SPHFWSSFLHBBM` (`SPHFWSSFLHBBM`),
  KEY `IDX_JHFPXX_XSFNSRSBH` (`XSFNSRSBH`),
  CONSTRAINT `PK_ATFX_FP_YS_JHFPXX` PRIMARY KEY (`FPHM`, `XH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='进货发票电子信息表';

-- Creating table ATFX_FP_YS_XSFPXX
-- Original Oracle primary-key constraint: PK_ATFX_FP_YS_XSFPXX (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_FP_YS_XSFPXX` (
  `fphm` VARCHAR(30) NOT NULL COMMENT '发票号码（主键，底账系统用发票代码||发票号码）',
  `xh` DECIMAL(10,0) NOT NULL COMMENT '序号（主键，底账货物对应MXXH）',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号（数据抽取时填入，多个企业同时分析时区分企业数据）',
  `kpyf` VARCHAR(6) COMMENT '开票月份（数电票没有开票月份，需通过开票日期转换）',
  `kprq` DATETIME COMMENT '开票日期',
  `xsfnsrsbh` VARCHAR(20) NOT NULL COMMENT '销售方纳税人识别代号（底账电子专票对应XSFSBH，其他对应XFSBH）',
  `xsfmc` VARCHAR(300) NOT NULL COMMENT '销售方名称（底账非电子专票对应XFMC字段）',
  `xsfdjxh` DECIMAL(20,0) COMMENT '销售方登记序号（数电票XHFDJXH，底账发票没有对应字段，默认为null）',
  `gmfnsrsbh` VARCHAR(20) COMMENT '购买方纳税人识别号（底账电子专票对应GMFSBH，其他对应GFSBH）',
  `gmfmc` VARCHAR(300) NOT NULL COMMENT '购买方名称（底账非电子专票对应GFMC字段）',
  `gmfdjxh` DECIMAL(20,0) COMMENT '购买方登记序号（底账发票没有对应字段，默认为null）',
  `xsfssjswjg_dm` VARCHAR(11) COMMENT '销售方_省级税务机关代码（底账系统对应XF_SJSWJG_DM字段）',
  `xsfdsjswjg_dm` VARCHAR(11) COMMENT '销售方_地市级税务机关代码（底账系统对应XF_FSSWJG_DM字段）',
  `xsfzgswj_dm` VARCHAR(11) COMMENT '销售方_主管税务局代码（底账系统对应XF_QXSWJG_DM字段）',
  `xsfzgswskfj_dm` VARCHAR(11) COMMENT '销售方_主管税务所代码（底账发票没有对应字段，默认为null）',
  `gmfssjswjg_dm` VARCHAR(11) COMMENT '购买方_省市级税务机关代码（底账系统对应GF_SJSWJG_DM字段）',
  `gmfdsjswjg_dm` VARCHAR(11) COMMENT '购买方_地市级税务机关代码（底账系统对应GF_DSSWJG_DM字段）',
  `gmfzgswj_dm` VARCHAR(11) COMMENT '购买方_主管税务局代码（底账系统对应GF_QXSWJG_DM字段）',
  `gmfzgswskfj_dm` VARCHAR(11) COMMENT '购买方_主管税务所代码（底账发票没有对应字段，默认为null）',
  `kjhzfpdydlzfphm` VARCHAR(30) COMMENT '开具红字对应的蓝字发票号码（底账系统用原发票代码||原发票号码）',
  `hjje` DECIMAL(18,2) COMMENT '合计金额（底账发票对应JE）',
  `hjse` DECIMAL(18,2) COMMENT '合计税额（底账发票对应SE）',
  `jshj` DECIMAL(18,2) COMMENT '价税合计',
  `sphfwssflhbbm` VARCHAR(20) COMMENT '商品和服务税收分类合并编码（底账货物对应SPBM）',
  `hwhyslwfwmc` VARCHAR(300) NOT NULL COMMENT '货物或应税劳务、服务名称（底账货物对应MC）',
  `ggxh` VARCHAR(300) COMMENT '规格型号',
  `jldw` VARCHAR(30) COMMENT '单位（数电票对应DW）',
  `fpspsl` VARCHAR(30) COMMENT '数量（底账货物对应SL）',
  `fpspdj` VARCHAR(30) COMMENT '单价（底账货物对应DJ）',
  `je` DECIMAL(18,2) COMMENT '金额',
  `se` DECIMAL(18,2) COMMENT '税额',
  `fppz_dm` VARCHAR(10) COMMENT '发票票种代码（底账电子专票对应TSPZ字段，底账其他发票对应TSPZ_DM字段）',
  `sflzfp` CHAR(1) COMMENT '是否蓝字发票（底账电子专票对应FPZTBZ，其他对应FPZT_BZ；0蓝字→Y，1红字→N）',
  `fplx` VARCHAR(20) COMMENT '发票类型（普通发票/专用发票/数电发票，数据抽取时根据来源打标记）',
  `ckfpbz` CHAR(1) COMMENT '出口发票标志（数据提取时根据备注栏打标记）',
  `sjlx` VARCHAR(30) COMMENT '数据类型（产成品、能源消耗（水电气煤等）、其它；后期可人工打标记，标记后需重新加工销货发票数据）',
  `slv` DECIMAL(16,6),
  KEY `IDX_XSFPXX_CKFPBZ` (`CKFPBZ`),
  KEY `IDX_XSFPXX_DJXH` (`DJXH`),
  KEY `IDX_XSFPXX_FPLX` (`FPLX`),
  KEY `IDX_XSFPXX_GMFNSRSBH` (`GMFNSRSBH`),
  KEY `IDX_XSFPXX_KPRQ` (`KPRQ`),
  KEY `IDX_XSFPXX_SJLX` (`SJLX`),
  KEY `IDX_XSFPXX_SPHFWSSFLHBBM` (`SPHFWSSFLHBBM`),
  KEY `IDX_XSFPXX_XSFNSRSBH` (`XSFNSRSBH`),
  CONSTRAINT `PK_ATFX_FP_YS_XSFPXX` PRIMARY KEY (`FPHM`, `XH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='销售发票电子信息表';

-- Creating table ATFX_GLSJ_DATA_RZ
-- Original Oracle primary-key constraint: PK_ATFX_GLSJ_DATA_RZ (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_GLSJ_DATA_RZ` (
  `uuid` VARCHAR(36) NOT NULL COMMENT '同案头分析台账UUID',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `ds_id` VARCHAR(32) NOT NULL COMMENT '数据源标识',
  `table_name` VARCHAR(64) NOT NULL COMMENT '数据表标识',
  `sjjgkssj` DATETIME NOT NULL COMMENT '开始时间',
  `sjjgjssj` DATETIME COMMENT '结束时间',
  `jgbz` CHAR(1) DEFAULT '0' COMMENT '处理结果标志，0，初始 1，完成，9失败，5、重启',
  `jgmsg` VARCHAR(4000) COMMENT '处理结果信息',
  `crtime` DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6),
  `uptime` DATETIME(6),
  CONSTRAINT `PK_ATFX_GLSJ_DATA_RZ` PRIMARY KEY (`UUID`, `DS_ID`, `DJXH`, `TABLE_NAME`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='数据加工日志表';

-- Creating table ATFX_GLSJ_DATA_TZ
-- Original Oracle primary-key constraint: PK_ATFX_GLSJ_DATA_TZ (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_GLSJ_DATA_TZ` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID，主键',
  `czry_swjg_dm` VARCHAR(11) NOT NULL COMMENT '操作人员所属税务机关代码',
  `qy_swjg_dm` VARCHAR(11) NOT NULL COMMENT '企业税务机关代码',
  `djxh` VARCHAR(21) NOT NULL COMMENT '登记序号',
  `nsrsbh` VARCHAR(20) NOT NULL COMMENT '纳税人识别号',
  `nsrmc` VARCHAR(200) NOT NULL COMMENT '纳税人名称',
  `ckhwtmsjsff_dm` CHAR(1) COMMENT '出口货物退(免)税计算方法代码',
  `fxqq` DATETIME NOT NULL COMMENT '案头分析期起',
  `fxqz` DATETIME NOT NULL COMMENT '案头分析期止',
  `sqr_dm` VARCHAR(20) NOT NULL COMMENT '申请人代码',
  `sqr_mc` VARCHAR(80) NOT NULL COMMENT '申请人名称',
  `sqrq` DATETIME COMMENT '申请日期',
  `fxr2_dm` VARCHAR(20) COMMENT '共同分析人员代码',
  `fxr2_mc` VARCHAR(80) COMMENT '共同分析人员名称',
  `spjg` CHAR(1) COMMENT '审批结果（1：同意；0：不同意）',
  `spyj` VARCHAR(255) COMMENT '审批意见（同意/不同意）',
  `spr_dm` VARCHAR(20) COMMENT '审批人代码',
  `spr_mc` VARCHAR(80) COMMENT '审批人名称',
  `sprq` DATETIME(6) COMMENT '审批日期',
  `tzzt` CHAR(3) NOT NULL COMMENT '台账状态(100已取消、110待审批、120数据准备、130案头分析、140出具报告、150已发放)',
  `wcrq` DATETIME COMMENT '完成日期',
  `cjr_dm` VARCHAR(20) COMMENT '创建人代码',
  `cjr_mc` VARCHAR(80) COMMENT '创建人名称',
  `note` VARCHAR(255) COMMENT '备注',
  `crtime` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `uptime` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  KEY `IDX_ATFX_GLSJ_DATA_TZ_DJXH` (`DJXH`),
  KEY `IDX_ATFX_GLSJ_DATA_TZ_IDX1` (`CZRY_SWJG_DM`),
  KEY `IDX_ATFX_GLSJ_DATA_TZ_IDX2` (`QY_SWJG_DM`),
  CONSTRAINT `PK_ATFX_GLSJ_DATA_TZ` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='案头分析台账主表';

-- Creating table ATFX_GLSJ_PZ_SJB
-- Original Oracle primary-key constraint: PK_ATFX_GLSJ_PZ_SJB (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_GLSJ_PZ_SJB` (
  `ds_id` VARCHAR(32) NOT NULL COMMENT '关联数据源信息表的DS_ID',
  `table_name` VARCHAR(64) NOT NULL COMMENT '数据表标识（数据库中实际的表名）',
  `table_cname` VARCHAR(100) NOT NULL COMMENT '数据表中文名称（用于展示）',
  `table_schema` VARCHAR(32) NOT NULL COMMENT '数据表拥有者（所属 schema，如HX_CKTS）',
  `table_type` CHAR(1) NOT NULL COMMENT '数据表类型（数据源/原始数据/加工数据）',
  `is_dict` VARCHAR(1) NOT NULL COMMENT '是否为代码表（Y：是，N：否）',
  `yxbz` VARCHAR(1) NOT NULL COMMENT '有效标志（Y：有效，N：无效）',
  `showorder` DECIMAL(4,0) DEFAULT 0 COMMENT '显示顺序（数字越小越靠前）',
  `groupid` VARCHAR(20) COMMENT '分组标识',
  `groupname` VARCHAR(60),
  `groupdesc` VARCHAR(200),
  CONSTRAINT `PK_ATFX_GLSJ_PZ_SJB` PRIMARY KEY (`DS_ID`, `TABLE_NAME`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='数据表信息表';

-- Creating table ATFX_GLSJ_PZ_SJBYL
-- Original Oracle primary-key constraint: PK_ATFX_GLSJ_PZ_SJBYL (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_GLSJ_PZ_SJBYL` (
  `ds_id` VARCHAR(32) NOT NULL COMMENT '数据源标识（当前依赖方的数据源，关联atfx_glsj_pz_sjy表）',
  `table_name` VARCHAR(64) NOT NULL COMMENT '数据表标识（当前依赖方的表，关联atfx_glsj_pz_sjb表）',
  `ds_depend` VARCHAR(32) NOT NULL COMMENT '被依赖的数据源标识（被依赖方的数据源）',
  `table_depend` VARCHAR(64) NOT NULL COMMENT '被依赖的数据表标识（被依赖方的表）',
  `yxbz` VARCHAR(1) NOT NULL COMMENT '有效标志（Y=有效依赖关系，N=无效/已废弃）',
  `showorder` DECIMAL(4,0) DEFAULT 0 COMMENT '显示顺序（用于排序依赖关系的展示）',
  CONSTRAINT `PK_ATFX_GLSJ_PZ_SJBYL` PRIMARY KEY (`DS_ID`, `TABLE_NAME`, `DS_DEPEND`, `TABLE_DEPEND`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='数据表依赖关系表（存储数据表之间的依赖关系）';

-- Creating table ATFX_GLSJ_PZ_SJX
-- Original Oracle primary-key constraint: PK_ATFX_GLSJ_PZ_SJX (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_GLSJ_PZ_SJX` (
  `ds_id` VARCHAR(32) NOT NULL COMMENT '数据源标识（关联atfx_glsj_pz_sjy表的DS_ID）',
  `table_name` VARCHAR(64) NOT NULL COMMENT '数据表标识（关联atfx_glsj_pz_sjb表的TABLE_NAME）',
  `field_name` VARCHAR(64) NOT NULL COMMENT '数据项标识（数据表中的实际字段名）',
  `field_cname` VARCHAR(100) NOT NULL COMMENT '数据项中文名称（用于展示）',
  `datatype` VARCHAR(1) NOT NULL COMMENT '数据类型（1=字符型,2=数值型,3=日期型,4=逻辑型）',
  `showformat` VARCHAR(1) DEFAULT '0' COMMENT '显示格式（0=默认,1=金额,2=整数,3=百分比） 0 居左，1，加千分符,靠右   2居中  3百分比居中加%',
  `showlength` DECIMAL(3,0) COMMENT '显示长度',
  `codetable` VARCHAR(64) COMMENT '关联代码表（若为代码项，填写对应代码表名）',
  `codefield` VARCHAR(64) COMMENT '关联代码字段（代码表中对应的字段名）',
  `defval` VARCHAR(100) COMMENT '缺省值（字段默认值）',
  `ywms` VARCHAR(500) COMMENT '特殊业务功能描述字段，可用于扩展性功能描述，目前配置  time ，可控制字段显示时分秒',
  `yxbz` VARCHAR(1) NOT NULL COMMENT '有效标志（Y=有效,N=无效）',
  `showorder` DECIMAL(4,0) DEFAULT 0 COMMENT '显示顺序（数字越小越靠前）',
  `namefield` VARCHAR(64) COMMENT '关联代码名称字段',
  `typefield` VARCHAR(64) COMMENT '关联代码类型字段',
  `typevalue` VARCHAR(40) COMMENT '关联代码类型值',
  CONSTRAINT `PK_ATFX_GLSJ_PZ_SJX` PRIMARY KEY (`DS_ID`, `TABLE_NAME`, `FIELD_NAME`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='数据表字段信息表';

-- Creating table ATFX_GLSJ_PZ_SJY
-- Original Oracle primary-key constraint: PK_ATFX_GLSJ_PZ_SJY (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_GLSJ_PZ_SJY` (
  `ds_id` VARCHAR(32) NOT NULL COMMENT '数据源标识（唯一主键）',
  `ds_name` VARCHAR(100) NOT NULL COMMENT '数据源名称',
  `ds_type` VARCHAR(20) NOT NULL COMMENT '数据源类型（如oracle/mysql）',
  `yxbz` VARCHAR(1) NOT NULL COMMENT '有效标志（Y：有效，N：无效）',
  `showorder` DECIMAL(4,0) DEFAULT 0 COMMENT '显示顺序（数字越小越靠前）',
  CONSTRAINT `PK_ATFX_GLSJ_PZ_SJY` PRIMARY KEY (`DS_ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='数据源信息表';

-- Creating table ATFX_HD_YS_BQYHDFPQD
-- Original Oracle primary-key constraint: PK_ATFX_HD_YS_BQYHDFPQD (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_HD_YS_BQYHDFPQD` (
  `hdfpqduuid` VARCHAR(32) NOT NULL COMMENT '函调发票清单UUID，主键',
  `fhxxbuuid` VARCHAR(32) NOT NULL COMMENT '发函信息表UUID（关联函调信息表）',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `pzzl1` VARCHAR(20) COMMENT '凭证种类',
  `zzszyfpdmhm` VARCHAR(20) NOT NULL COMMENT '增值税专用发票代码号码',
  `ghfnsrsbh_1` VARCHAR(20) COMMENT '供货方纳税人识别号',
  `sp_dm` VARCHAR(20) COMMENT '商品代码',
  `spmc` VARCHAR(200) COMMENT '商品名称',
  `ggxh` VARCHAR(100) COMMENT '规格型号',
  `kjrq` DATETIME COMMENT '开具日期',
  `jldw_dm` VARCHAR(10) COMMENT '计量单位代码',
  `sl` DECIMAL(18,6) COMMENT '数量',
  `sl_1` VARCHAR(10) COMMENT '税率',
  `tsl` VARCHAR(10) COMMENT '退税率',
  `dj` DECIMAL(18,6) COMMENT '单价',
  `je` DECIMAL(18,2) COMMENT '金额',
  `se` DECIMAL(18,2) COMMENT '税额',
  `jshj` DECIMAL(18,2) COMMENT '价税合计',
  `ktse_1` DECIMAL(18,2) COMMENT '可退税额',
  `sfyts` CHAR(1) COMMENT '是否已退税（如Y=是，N=否）',
  KEY `IDX_BQYHDFPQD_DJXH` (`DJXH`),
  KEY `IDX_BQYHDFPQD_FHXXBUUID` (`FHXXBUUID`),
  KEY `IDX_BQYHDFPQD_GHFNSRSBH1` (`GHFNSRSBH_1`),
  KEY `IDX_BQYHDFPQD_KJRQ` (`KJRQ`),
  KEY `IDX_BQYHDFPQD_SFYTS` (`SFYTS`),
  KEY `IDX_BQYHDFPQD_ZZSZYFPDMHM` (`ZZSZYFPDMHM`),
  CONSTRAINT `PK_ATFX_HD_YS_BQYHDFPQD` PRIMARY KEY (`DJXH`, `HDFPQDUUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='本企业函调发票清单表';

-- Creating table ATFX_HD_YS_BQYHDXX
-- Original Oracle primary-key constraint: PK_ATFX_HD_YS_BQYHDXX (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_HD_YS_BQYHDXX` (
  `fhxxbuuid` VARCHAR(32) NOT NULL COMMENT '发函信息表UUID（关联发函信息表和回函信息表）',
  `wsbh` VARCHAR(50) NOT NULL COMMENT '文书编号（同回函信息表的核实函编号）',
  `fahdswjg_dm` VARCHAR(11) COMMENT '发函地税务机关代码',
  `fahdswjgmc` VARCHAR(200) COMMENT '发函地税务机关名称',
  `ghqynsrsbh` VARCHAR(20) NOT NULL COMMENT '购货企业纳税人识别号（本企业）',
  `ghfqymc` VARCHAR(200) NOT NULL COMMENT '购货企业名称（本企业）',
  `ghfdjxh` DECIMAL(20,0) NOT NULL COMMENT '购货方登记序号（本企业）',
  `ghfzgswjg_dm` VARCHAR(11) COMMENT '供货方主管税务机关代码',
  `ghfzgswjgmc` VARCHAR(200) COMMENT '供货方主管税务机关名称',
  `ghqynsrsbh_1` VARCHAR(20) COMMENT '供货企业纳税人识别号',
  `ghfqymc_1` VARCHAR(200) COMMENT '供货企业名称',
  `ghfdjxh1` DECIMAL(20,0) COMMENT '供货方登记序号',
  `fpfs` DECIMAL(10,0) COMMENT '发票份数',
  `jehj` DECIMAL(18,2) COMMENT '金额合计',
  `sehj` DECIMAL(18,2) COMMENT '税额合计',
  `jshj` DECIMAL(18,2) COMMENT '价税合计',
  `sjcktse` DECIMAL(18,2) COMMENT '涉及出口退税额',
  `fh_qfrq` DATETIME COMMENT '发函签发日期（取发函信息表）',
  `fahyy` VARCHAR(1000) COMMENT '发函原因（NVL(FAHYY,CXFAHYY)）',
  `fuhxxbuuid` VARCHAR(32) COMMENT '复函信息表UUID',
  `fuh_qfrq` DATETIME COMMENT '复函签发日期（取复函信息表）',
  `fuhcs` DECIMAL(3,0) COMMENT '复函次数（对应复函表中的FHCS）',
  `fhlx_dm` VARCHAR(2) COMMENT '复函类型代码：1-正常业务；2-存在不予退免税发票；3-经核查尚未处理完毕；4-暂缓办理退免税；5-非本地区管辖',
  `ycqx_tree` VARCHAR(1000) COMMENT '异常情形（NVL(YCQX_TREE, BYTMSQX_TREE)）',
  `zhbltmsqx` VARCHAR(1000) COMMENT '暂缓办理退（免）税情形',
  `sffzchzxswdj` CHAR(1) COMMENT '是否为供货企业属于办理税务登记2年内被税务机关认定为非正常户或被登记为增值税一般纳税人2年内注销税务',
  `yqfhyy` VARCHAR(500) COMMENT '延期复函原因',
  `fscfhyy` VARCHAR(500) COMMENT '非首次复函原因',
  `zzhcswclyy_tree` VARCHAR(1000) COMMENT '正在核查尚未处理完毕原因列表',
  KEY `IDX_BQYHDXX_FHLX_DM` (`FHLX_DM`),
  KEY `IDX_BQYHDXX_FH_QFRQ` (`FH_QFRQ`),
  KEY `IDX_BQYHDXX_FUHXXBUUID` (`FUHXXBUUID`),
  KEY `IDX_BQYHDXX_FUH_QFRQ` (`FUH_QFRQ`),
  KEY `IDX_BQYHDXX_GHQYNSRSBH` (`GHQYNSRSBH`),
  KEY `IDX_BQYHDXX_GHQYNSRSBH1` (`GHQYNSRSBH_1`),
  CONSTRAINT `PK_ATFX_HD_YS_BQYHDXX` PRIMARY KEY (`GHFDJXH`, `FHXXBUUID`),
  CONSTRAINT `UK_BQYHDXX_WSBH` UNIQUE (`WSBH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='本企业函调信息表';

-- Creating table ATFX_HD_YS_GYSYCHH
-- Original Oracle primary-key constraint: PK_ATFX_HD_YS_GYSYCHH (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_HD_YS_GYSYCHH` (
  `hdfpqduuid` VARCHAR(32) NOT NULL COMMENT '函调发票清单UUID，主键',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号（本企业登记序号，主要用于筛选和后续数据清理）',
  `fhxxbuuid` VARCHAR(32) NOT NULL COMMENT '发函信息表UUID（用于关联异常业务的回函信息及对应发票）',
  `ghfqymc_1` VARCHAR(200) COMMENT '供货企业名称',
  `ghqynsrsbh_1` VARCHAR(20) COMMENT '供货企业纳税人识别号',
  `zzszyfpdmhm` VARCHAR(20) NOT NULL COMMENT '增值税专用发票代码号码',
  `sp_dm` VARCHAR(20) COMMENT '商品代码',
  `spmc` VARCHAR(200) COMMENT '商品名称',
  `ggxh` VARCHAR(100) COMMENT '规格型号',
  `jldw_dm` VARCHAR(10) COMMENT '计量单位代码',
  `sl` DECIMAL(18,6) COMMENT '数量',
  `dj` DECIMAL(18,6) COMMENT '单价',
  `je` DECIMAL(18,2) COMMENT '金额',
  `kjrq` DATETIME COMMENT '开具日期',
  `fhlx_dm` VARCHAR(2) NOT NULL DEFAULT '2' COMMENT '复函类型代码（固定为2，表示存在不予退免税发票）',
  `ycqx_tree` VARCHAR(1000) COMMENT '异常情形（NVL(YCQX_TREE, BYTMSQX_TREE)）',
  `fuh_qfrq` DATETIME COMMENT '复函签发日期（取复函信息表）',
  KEY `IDX_GYSYCHH_DJXH` (`DJXH`),
  KEY `IDX_GYSYCHH_FHXXBUUID` (`FHXXBUUID`),
  KEY `IDX_GYSYCHH_FUH_QFRQ` (`FUH_QFRQ`),
  KEY `IDX_GYSYCHH_GHQYNSRSBH1` (`GHQYNSRSBH_1`),
  KEY `IDX_GYSYCHH_KJRQ` (`KJRQ`),
  KEY `IDX_GYSYCHH_ZZSZYFPDMHM` (`ZZSZYFPDMHM`),
  CONSTRAINT `PK_ATFX_HD_YS_GYSYCHH` PRIMARY KEY (`DJXH`, `HDFPQDUUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='供应商异常回函表（专门存储复函类型为"存在不予退免税发票"的记录）';

-- Creating table ATFX_JC_JG_GLQYXX
-- Original Oracle primary-key constraint: PK_ATFX_JC_JG_GLQYXX (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_JC_JG_GLQYXX` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `glqy_nsrsbh` VARCHAR(20) NOT NULL COMMENT '关联企业纳税人识别号',
  `glqy_shxydm` VARCHAR(18) COMMENT '关联企业社会信用代码',
  `glqy_nsrmc` VARCHAR(200) NOT NULL COMMENT '关联企业纳税人名称',
  `glqy_djjg_dm` VARCHAR(11) COMMENT '关联企业登记机关代码',
  `glqy_djrq` DATETIME COMMENT '关联企业登记日期',
  `glqy_ybnsrrdrq` DATETIME COMMENT '关联企业一般纳税人认定日期',
  `glqy_barq` DATETIME COMMENT '关联企业备案日期',
  `glqy_nsrzt_dm` VARCHAR(2) COMMENT '关联企业纳税人状态代码',
  `glqy_bachrq` DATETIME COMMENT '关联企业备案撤回日期',
  `glqy_zxrq` DATETIME COMMENT '关联企业注销日期',
  `glqy_flgldj` VARCHAR(150) COMMENT '关联企业分类管理等级',
  `glgx_jh` VARCHAR(200) COMMENT '关联关系集合字段',
  CONSTRAINT `PK_ATFX_JC_JG_GLQYXX` PRIMARY KEY (`DJXH`, `GLQY_NSRSBH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='法人与财务负责人股东关联企业信息表';

-- Creating table ATFX_JC_JG_QYSCCK
-- Original Oracle primary-key constraint: PK_ATFX_JC_JG_QYSCCK (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_JC_JG_QYSCCK` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `scckrq` DATETIME COMMENT '首次出口日期',
  `sctssbrq` DATETIME COMMENT '首次退税申报日期',
  KEY `IDX_QYSCCK_SCCKRQ` (`SCCKRQ`),
  KEY `IDX_QYSCCK_SCTSSBRQ` (`SCTSSBRQ`),
  CONSTRAINT `PK_ATFX_JC_JG_QYSCCK` PRIMARY KEY (`DJXH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='企业首次出口与申报信息表';

-- Creating table ATFX_JC_JG_SPSCCK
-- Original Oracle primary-key constraint: PK_ATFX_JC_JG_SPSCCK (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_JC_JG_SPSCCK` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `cksp_dm` VARCHAR(20) NOT NULL COMMENT '出口商品代码（前4位）',
  `ckspmc` VARCHAR(1000) COMMENT '出口商品名称',
  `scckrq` DATETIME COMMENT '首次出口日期',
  `sctssbrq` DATETIME COMMENT '首次退税申报日期',
  KEY `IDX_SPSCCK_CKSP_DM` (`CKSP_DM`),
  KEY `IDX_SPSCCK_DJXH` (`DJXH`),
  KEY `IDX_SPSCCK_SCCKRQ` (`SCCKRQ`),
  KEY `IDX_SPSCCK_SCTSSBRQ` (`SCTSSBRQ`),
  CONSTRAINT `PK_ATFX_JC_JG_SPSCCK` PRIMARY KEY (`DJXH`, `CKSP_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='商品首次出口与申报信息表';

-- Creating table ATFX_JC_YS_FLGLXX
-- Original Oracle primary-key constraint: PK_ATFX_JC_YS_FLGLXX (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_JC_YS_FLGLXX` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID，主键',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `kznr` VARCHAR(150) COMMENT '扩展内容',
  `yxqq` DATETIME NOT NULL COMMENT '有效期起',
  `yxqz` DATETIME COMMENT '有效期止',
  KEY `IDX_ATFX_JC_YS_FLGLXX_DJXH` (`DJXH`),
  CONSTRAINT `PK_ATFX_JC_YS_FLGLXX` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口企业分类管理信息表';

-- Creating table ATFX_JC_YS_GDXX
-- Original Oracle primary-key constraint: PK_ATFX_JC_YS_GDXX (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_JC_YS_GDXX` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID，主键',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号，关联企业主表',
  `tzfhhhrmc` VARCHAR(300) NOT NULL COMMENT '投资方（合伙人）名称',
  `tzbl` DECIMAL(11,8) COMMENT '投资比例（保留6位小数）',
  `tzfhhhrzjhm` VARCHAR(30) COMMENT '投资方（合伙人）证件号码',
  `tzfhhhrzjzl_dm` VARCHAR(3) COMMENT '投资方（合伙人）证件种类代码',
  `gjhdqsz_dm` VARCHAR(60) COMMENT '国家或地区数字代码',
  `tzfjjxz_dm` VARCHAR(3) COMMENT '投资方经济性质代码',
  KEY `IDX_ATFX_JC_YS_GDXX_DJXH` (`DJXH`),
  CONSTRAINT `PK_ATFX_JC_YS_GDXX` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='股东信息表';

-- Creating table ATFX_JC_YS_JCXXBGJL
-- Original Oracle primary-key constraint: PK_ATFX_JC_YS_JCXXBGJL (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_JC_YS_JCXXBGJL` (
  `bgdjmxuuid` VARCHAR(32) NOT NULL COMMENT '变更登记明细UUID，主键',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `bgxm_dm` VARCHAR(20) COMMENT '变更项目代码',
  `bgxmmc` VARCHAR(150) NOT NULL COMMENT '变更项目名称',
  `bgqnr` VARCHAR(4000) COMMENT '变更前内容',
  `bghnr` VARCHAR(4000) COMMENT '变更后内容',
  `lrrq` DATETIME NOT NULL COMMENT '录入日期',
  KEY `IDX_ATFX_JC_YS_JCXXBGJL_DJXH` (`DJXH`),
  CONSTRAINT `PK_ATFX_JC_YS_JCXXBGJL` PRIMARY KEY (`BGDJMXUUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='基础信息变更记录表';

-- Creating table ATFX_JC_YS_NSRJCXX
-- Original Oracle primary-key constraint: PK_ATFX_JC_YS_NSRJCXX_DJXH (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_JC_YS_NSRJCXX` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号，主键',
  `nsrmc` VARCHAR(300) NOT NULL COMMENT '纳税人名称',
  `nsrsbh` VARCHAR(20) NOT NULL COMMENT '纳税人识别号（18位）',
  `shxydm` VARCHAR(20) COMMENT '社会信用代码（18位）',
  `hgqy_dm` VARCHAR(20) COMMENT '海关企业代码（10位）',
  `djzclx_dm` VARCHAR(3) COMMENT '登记注册类型代码',
  `cktsqylx_dm` VARCHAR(2) COMMENT '出口退税企业类型代码',
  `ckhwtmsjsff_dm` CHAR(1) COMMENT '出口货物退(免)税计算方法代码',
  `scjydz` VARCHAR(300) COMMENT '生产经营地址',
  `zcdz` VARCHAR(300) COMMENT '注册地址',
  `jyfw` VARCHAR(4000) COMMENT '经营范围',
  `djrq` DATETIME COMMENT '登记日期（税务登记日期）',
  `barq` DATETIME COMMENT '备案日期（出口退税备案日期）',
  `nsrzt_dm` VARCHAR(2) COMMENT '纳税人状态代码',
  `fddbrsfzjhm` VARCHAR(30) COMMENT '法定代表人身份证号码',
  `fddbrsfzjlx_dm` VARCHAR(3) COMMENT '法定代表人身份证件类型代码',
  `fddbrxm` VARCHAR(150) COMMENT '法定代表人姓名',
  `cwfzrsfzjhm` VARCHAR(30) COMMENT '财务负责人身份证件号码',
  `cwfzrsfzjzl_dm` VARCHAR(3) COMMENT '财务负责人身份证件种类代码',
  `cwfzrxm` VARCHAR(150) COMMENT '财务负责人姓名',
  `cyrs` DECIMAL(10,0) COMMENT '从业人数（来源于税务登记信息）',
  `fddbrjg` VARCHAR(100) COMMENT '法人代表人籍贯',
  `cwfzrjg` VARCHAR(100) COMMENT '财务负责人籍贯',
  CONSTRAINT `PK_ATFX_JC_YS_NSRJCXX_DJXH` PRIMARY KEY (`DJXH`),
  CONSTRAINT `UK_ATFX_JC_YS_NSRJCXX_NSRSBH` UNIQUE (`NSRSBH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口退税企业基础信息表';

-- Creating table ATFX_JC_YS_NSRZGRD
-- Original Oracle primary-key constraint: PK_ATFX_JC_YS_NSRZGRD (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_JC_YS_NSRZGRD` (
  `rdpzuuid` VARCHAR(32) NOT NULL COMMENT '认定凭证UUID，主键',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号，关联企业主表',
  `nsrzglx_dm` VARCHAR(3) NOT NULL COMMENT '纳税人资格类型代码',
  `nsrzglxmc` VARCHAR(100) NOT NULL COMMENT '纳税人资格类型名称',
  `yxqq` DATETIME NOT NULL COMMENT '有效期起',
  `yxqz` DATETIME COMMENT '有效期止（取YXQZ和SJZZRQ较小者）',
  KEY `IDX_ATFX_JC_YS_NSRZGRD_DJXH` (`DJXH`),
  CONSTRAINT `PK_ATFX_JC_YS_NSRZGRD` PRIMARY KEY (`RDPZUUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='纳税人资格认定信息表';

-- Creating table ATFX_NS_YS_LRB
-- Original Oracle primary-key constraint: PK_ATFX_NS_YS_LRB (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_NS_YS_LRB` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID，主键',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `skssqq` DATETIME NOT NULL COMMENT '税款所属期起（格式YYYYMM）',
  `skssqz` DATETIME NOT NULL COMMENT '税款所属期止（格式YYYYMM）',
  `kjzdzz_dm` VARCHAR(20) COMMENT '会计制度（准则）代码（根据财务数据的来源表加工，涉及投资收益是否计入营业利润）',
  `bys_yysr` DECIMAL(20,2) COMMENT '本月数_营业收入',
  `bys_yycb` DECIMAL(20,2) COMMENT '本月数_营业成本',
  `bys_sjjfj` DECIMAL(20,2) COMMENT '本月数_税金及附加',
  `bys_glfy` DECIMAL(20,2) COMMENT '本月数_管理费用',
  `bys_cwfy` DECIMAL(20,2) COMMENT '本月数_财务费用',
  `bys_yyfy` DECIMAL(20,2) COMMENT '本月数_营业费用',
  `bys_tzsy` DECIMAL(20,2) COMMENT '本月数_投资收益',
  `bys_yylr` DECIMAL(20,2) COMMENT '本月数_营业利润',
  `bys_yywsr` DECIMAL(20,2) COMMENT '本月数_营业外收入',
  `bys_yywzc` DECIMAL(20,2) COMMENT '本月数_营业外支出',
  `bys_lrze` DECIMAL(20,2) COMMENT '本月数_利润总额',
  `bys_sds` DECIMAL(20,2) COMMENT '本月数_所得税费用',
  `bys_jlr` DECIMAL(20,2) COMMENT '本月数_净利润',
  KEY `IDX_LRB_DJXH` (`DJXH`),
  KEY `IDX_LRB_KJZDZZ_DM` (`KJZDZZ_DM`),
  KEY `IDX_LRB_SKSSQQ_SKSSQZ` (`SKSSQQ`, `SKSSQZ`),
  CONSTRAINT `PK_ATFX_NS_YS_LRB` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='利润表';

-- Creating table ATFX_NS_YS_SDSSBB
-- Original Oracle primary-key constraint: PK_ATFX_NS_YS_SDSSBB (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_NS_YS_SDSSBB` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID，主键',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `skssqq` DATETIME NOT NULL COMMENT '税款所属期起（格式YYYYMM）',
  `skssqz` DATETIME NOT NULL COMMENT '税款所属期止（格式YYYYMM）',
  `sbuuid` VARCHAR(32) COMMENT '申报UUID',
  `yysr` DECIMAL(20,2) COMMENT '营业收入',
  `ynssde` DECIMAL(20,2) COMMENT '应纳税所得额',
  `ynqysdse` DECIMAL(20,2) COMMENT '应纳企业所得税额',
  `cyrs` DECIMAL(10,0) COMMENT '从业人数（所得税年度申报）',
  `gdzc_1` DECIMAL(20,2) COMMENT '一、固定资产（2+3+4+5+6+7）',
  `gdzc_2` DECIMAL(20,2) COMMENT '（一）房屋、建筑物',
  `gdzc_3` DECIMAL(20,2) COMMENT '（二）飞机、火车、轮船、机器、机械和其他生产设备',
  `gdzc_4` DECIMAL(20,2) COMMENT '（三）与生产经营活动有关的器具、工具、家具等',
  `gdzc_5` DECIMAL(20,2) COMMENT '（四）飞机、火车、轮船以外的运输工具',
  `gdzc_6` DECIMAL(20,2) COMMENT '（五）电子设备',
  `gdzc_7` DECIMAL(20,2) COMMENT '（六）其他',
  KEY `IDX_SDSSBB_DJXH` (`DJXH`),
  KEY `IDX_SDSSBB_SBUUID` (`SBUUID`),
  KEY `IDX_SDSSBB_SKSSQQ_SKSSQZ` (`SKSSQQ`, `SKSSQZ`),
  CONSTRAINT `PK_ATFX_NS_YS_SDSSBB` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='企业所得税年度纳税申报表';

-- Creating table ATFX_NS_YS_ZCFZB
-- Original Oracle primary-key constraint: PK_ATFX_NS_YS_ZCFZB (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_NS_YS_ZCFZB` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID，主键',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `skssqq` DATETIME NOT NULL COMMENT '税款所属期起（格式YYYYMM）',
  `skssqz` DATETIME NOT NULL COMMENT '税款所属期止（格式YYYYMM）',
  `kjzdzz_dm` VARCHAR(20) COMMENT '会计制度（准则）代码（根据财务数据的来源表加工）',
  `ncs_zc_hbzj` DECIMAL(20,2) COMMENT '年初数_资产_货币资金',
  `qms_zc_hbzj` DECIMAL(20,2) COMMENT '期末数_资产_货币资金',
  `ncs_zc_yspj` DECIMAL(20,2) COMMENT '年初数_资产_应收票据',
  `qms_zc_yspj` DECIMAL(20,2) COMMENT '期末数_资产_应收票据',
  `ncs_zc_yszk` DECIMAL(20,2) COMMENT '年初数_资产_应收账款',
  `qms_zc_yszk` DECIMAL(20,2) COMMENT '期末数_资产_应收账款',
  `ncs_zc_yufzk` DECIMAL(20,2) COMMENT '年初数_资产_预付账款',
  `qms_zc_yufzk` DECIMAL(20,2) COMMENT '期末数_资产_预付账款',
  `ncs_zc_qtysk` DECIMAL(20,2) COMMENT '年初数_资产_其他应收款',
  `qms_zc_qtysk` DECIMAL(20,2) COMMENT '期末数_资产_其他应收款',
  `ncs_zc_ch` DECIMAL(20,2) COMMENT '年初数_资产_存货',
  `qms_zc_ch` DECIMAL(20,2) COMMENT '期末数_资产_存货',
  `ncs_zc_qtldzc` DECIMAL(20,2) COMMENT '年初数_资产_其他流动资产',
  `qms_zc_qtldzc` DECIMAL(20,2) COMMENT '期末数_资产_其他流动资产',
  `ncs_zc_ldzchj` DECIMAL(20,2) COMMENT '年初数_资产_流动资产合计',
  `qms_zc_ldzchj` DECIMAL(20,2) COMMENT '期末数_资产_流动资产合计',
  `ncs_zc_cqgqtz` DECIMAL(20,2) COMMENT '年初数_资产_长期股权投资',
  `qms_zc_cqgqtz` DECIMAL(20,2) COMMENT '期末数_资产_长期股权投资',
  `ncs_zc_gdzcyz` DECIMAL(20,2) COMMENT '年初数_资产_固定资产原值（资产负债表）',
  `qms_zc_gdzcyz` DECIMAL(20,2) COMMENT '期末数_资产_固定资产原值（资产负债表）',
  `ncs_zc_zjgc` DECIMAL(20,2) COMMENT '年初数_资产_在建工程',
  `qms_zc_zjgc` DECIMAL(20,2) COMMENT '期末数_资产_在建工程',
  `ncs_zc_wxzc` DECIMAL(20,2) COMMENT '年初数_资产_无形资产',
  `qms_zc_wxzc` DECIMAL(20,2) COMMENT '期末数_资产_无形资产',
  `ncs_zc_cqdtfy` DECIMAL(20,2) COMMENT '年初数_资产_长期待摊费用',
  `qms_zc_cqdtfy` DECIMAL(20,2) COMMENT '期末数_资产_长期待摊费用',
  `ncs_zc_zchj` DECIMAL(20,2) COMMENT '年初数_资产_资产合计',
  `qms_zc_zchj` DECIMAL(20,2) COMMENT '期末数_资产_资产合计',
  `ncs_qy_dqjk` DECIMAL(20,2) COMMENT '年初数_权益_短期借款',
  `qms_qy_dqjk` DECIMAL(20,2) COMMENT '期末数_权益_短期借款',
  `ncs_qy_yfpj` DECIMAL(20,2) COMMENT '年初数_权益_应付票据',
  `qms_qy_yfpj` DECIMAL(20,2) COMMENT '期末数_权益_应付票据',
  `ncs_qy_yfzk` DECIMAL(20,2) COMMENT '年初数_权益_应付账款',
  `qms_qy_yfzk` DECIMAL(20,2) COMMENT '期末数_权益_应付账款',
  `ncs_qy_yuszk` DECIMAL(20,2) COMMENT '年初数_权益_预收账款',
  `qms_qy_yuszk` DECIMAL(20,2) COMMENT '期末数_权益_预收账款',
  `ncs_qy_yfgz` DECIMAL(20,2) COMMENT '年初数_权益_应付工资',
  `qms_qy_yfgz` DECIMAL(20,2) COMMENT '期末数_权益_应付工资',
  `ncs_qy_yjsj` DECIMAL(20,2) COMMENT '年初数_权益_应交税金',
  `qms_qy_yjsj` DECIMAL(20,2) COMMENT '期末数_权益_应交税金',
  `ncs_qy_qtyfk` DECIMAL(20,2) COMMENT '年初数_权益_其他应付款',
  `qms_qy_qtyfk` DECIMAL(20,2) COMMENT '期末数_权益_其他应付款',
  `ncs_qy_qtldfz` DECIMAL(20,2) COMMENT '年初数_权益_其他流动负债',
  `qms_qy_qtldfz` DECIMAL(20,2) COMMENT '期末数_权益_其他流动负债',
  `ncs_qy_ldfzhj` DECIMAL(20,2) COMMENT '年初数_权益_流动负债合计',
  `qms_qy_ldfzhj` DECIMAL(20,2) COMMENT '期末数_权益_流动负债合计',
  `ncs_qy_cqjk` DECIMAL(20,2) COMMENT '年初数_权益_长期借款',
  `qms_qy_cqjk` DECIMAL(20,2) COMMENT '期末数_权益_长期借款',
  `ncs_qy_cqyfk` DECIMAL(20,2) COMMENT '年初数_权益_长期应付款',
  `qms_qy_cqyfk` DECIMAL(20,2) COMMENT '期末数_权益_长期应付款',
  `ncs_qy_fzhj` DECIMAL(20,2) COMMENT '年初数_权益_负债合计',
  `qms_qy_fzhj` DECIMAL(20,2) COMMENT '期末数_权益_负债合计',
  `ncs_qy_sszb` DECIMAL(20,2) COMMENT '年初数_权益_实收资本(或股本)',
  `qms_qy_sszb` DECIMAL(20,2) COMMENT '期末数_权益_实收资本(或股本)',
  `ncs_qy_zbgj` DECIMAL(20,2) COMMENT '年初数_权益_资本公积',
  `qms_qy_zbgj` DECIMAL(20,2) COMMENT '期末数_权益_资本公积',
  `ncs_qy_yyzj` DECIMAL(20,2) COMMENT '年初数_权益_盈余公积',
  `qms_qy_yyzj` DECIMAL(20,2) COMMENT '期末数_权益_盈余公积',
  `ncs_qy_wfplr` DECIMAL(20,2) COMMENT '年初数_权益_未分配利润',
  `qms_qy_wfplr` DECIMAL(20,2) COMMENT '期末数_权益_未分配利润',
  `ncs_qy_syzqyhj` DECIMAL(20,2) COMMENT '年初数_权益_所有者权益(或股东权益)合计',
  `qms_qy_syzqyhj` DECIMAL(20,2) COMMENT '期末数_权益_所有者权益(或股东权益)合计',
  `ncs_qy_fzysyzqyhj` DECIMAL(20,2) COMMENT '年初数_权益_负债和所有者权益(或股东权益)总计',
  `qms_qy_fzysyzqyhj` DECIMAL(20,2) COMMENT '期末数_权益_负债和所有者权益(或股东权益)总计',
  KEY `IDX_ZCFZB_DJXH` (`DJXH`),
  KEY `IDX_ZCFZB_KJZDZZ_DM` (`KJZDZZ_DM`),
  KEY `IDX_ZCFZB_SKSSQQ_SKSSQZ` (`SKSSQQ`, `SKSSQZ`),
  CONSTRAINT `PK_ATFX_NS_YS_ZCFZB` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='资产负债表';

-- Creating table ATFX_NS_YS_ZZSSBB
-- Original Oracle primary-key constraint: PK_ATFX_NS_YS_ZZSSBB (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_NS_YS_ZZSSBB` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID，主键',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `skssqq` DATETIME NOT NULL COMMENT '税款所属期起（格式YYYYMM）',
  `skssqz` DATETIME NOT NULL COMMENT '税款所属期止（格式YYYYMM）',
  `sbuuid` VARCHAR(32) COMMENT '申报UUID',
  `ewblxh` DECIMAL(5,0) COMMENT '二维表列序号',
  `asysljsxse` DECIMAL(18,2) COMMENT '按适用税率计税销售额',
  `yshwxse` DECIMAL(18,2) COMMENT '应税货物销售额',
  `yslwxse` DECIMAL(18,2) COMMENT '应税劳务销售额',
  `sysl_nsjctzxse` DECIMAL(18,2) COMMENT '纳税检查调整的销售额_适用税率',
  `ajybfjsxse` DECIMAL(18,2) COMMENT '按简易办法计税销售额',
  `jybf_nsjctzxse` DECIMAL(18,2) COMMENT '纳税检查调整的销售额_简易办法',
  `mdtbfckxse` DECIMAL(18,2) COMMENT '免抵退办法出口销售额',
  `msxse` DECIMAL(18,2) COMMENT '免税销售额',
  `mshwxse` DECIMAL(18,2) COMMENT '免税货物销售额',
  `mslwxse` DECIMAL(18,2) COMMENT '免税劳务销售额',
  `xxse` DECIMAL(18,2) COMMENT '销项税额',
  `jxse` DECIMAL(18,2) COMMENT '进项税额',
  `sqldse` DECIMAL(18,2) COMMENT '上期留抵税额',
  `jxsezc` DECIMAL(18,2) COMMENT '进项税额转出',
  `mdtytse` DECIMAL(18,2) COMMENT '免、抵、退应退税额',
  `sysl_nsjcybjse` DECIMAL(18,2) COMMENT '按适用税率计算的纳税检查应补缴税额',
  `ydksehj` DECIMAL(18,2) COMMENT '应抵扣税额合计',
  `sjdkse` DECIMAL(18,2) COMMENT '实际抵扣税额',
  `ynse` DECIMAL(18,2) COMMENT '应纳税额',
  `qmldse` DECIMAL(18,2) COMMENT '期末留抵税额',
  `jybf_ynse` DECIMAL(18,2) COMMENT '简易计税办法计算的应纳税额',
  `jybf_nsjcybjse` DECIMAL(18,2) COMMENT '按简易计税办法计算的纳税检查应补缴税额',
  `ynsejze` DECIMAL(18,2) COMMENT '应纳税额减征额',
  `ynsehj` DECIMAL(18,2) COMMENT '应纳税额合计',
  KEY `IDX_ZZSSBB_DJXH` (`DJXH`),
  KEY `IDX_ZZSSBB_EWBLXH` (`EWBLXH`),
  KEY `IDX_ZZSSBB_SBUUID` (`SBUUID`),
  KEY `IDX_ZZSSBB_SKSSQQ_SKSSQZ` (`SKSSQQ`, `SKSSQZ`),
  CONSTRAINT `PK_ATFX_NS_YS_ZZSSBB` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='增值税一般纳税人申报表';

-- Creating table ATFX_QT_YS_JICHAXX
-- Original Oracle primary-key constraint: PK_ATFX_QT_YS_JICHAXX (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_QT_YS_JICHAXX` (
  `jcajxxuuid` VARCHAR(32) NOT NULL COMMENT ' 稽查案件信息 UUID：案件全局唯一标识，用于跨表关联 ',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT ' 登记序号：关联企业登记信息表，定位案件所属企业 ',
  `nsrsbh` VARCHAR(20) NOT NULL COMMENT ' 纳税人识别号：纳税人唯一税务编码，如统一社会信用代码 ',
  `nsrmc` VARCHAR(200) NOT NULL COMMENT ' 纳税人名称：纳税人法定全称，与营业执照一致 ',
  `jcajbh` VARCHAR(50) NOT NULL COMMENT ' 稽查案件编号：税务机关分配的案件唯一编号，遵循稽查文书编码规则 ',
  `ajmc` VARCHAR(500) COMMENT ' 案件名称：概括案件核心要素，含纳税人、时段、税种等信息 ',
  `lasqrq` DATETIME COMMENT ' 立案申请日期：提交立案申请的具体日期 ',
  `larq` DATETIME COMMENT ' 立案日期：批准立案的日期，标志稽查流程启动 ',
  `jarq` DATETIME COMMENT ' 结案日期：案件完成稽查并归档的日期 ',
  `jcssqjq` DATETIME COMMENT ' 检查所属期间起：稽查覆盖的税款所属期起始，格式 YYYYMM',
  `jcssqjz` DATETIME COMMENT ' 检查所属期间止：稽查覆盖的税款所属期结束，格式 YYYYMM',
  `ajjczt_dm` VARCHAR(10) COMMENT ' 案件稽查状态代码：标识案件当前流程阶段，关联系统状态字典表 ',
  `sxsswfxw` VARCHAR(2000) COMMENT ' 涉嫌税收违法行为：记录违法类型、具体行为及初步证据描述 ',
  `xafxjlayj` VARCHAR(4000) COMMENT ' 选案分析及立案依据：选案风险分析结论、立案的法律法规及事实依据 ',
  KEY `IDX_JICHAXX_AJJCZT` (`AJJCZT_DM`),
  KEY `IDX_JICHAXX_DJXH` (`DJXH`),
  KEY `IDX_JICHAXX_JCSSQJ` (`JCSSQJQ`, `JCSSQJZ`),
  KEY `IDX_JICHAXX_LARQ` (`LARQ`),
  KEY `IDX_JICHAXX_NSRSBH` (`NSRSBH`),
  CONSTRAINT `PK_ATFX_QT_YS_JICHAXX` PRIMARY KEY (`JCAJXXUUID`),
  CONSTRAINT `UK_JICHAXX_JCAJBH` UNIQUE (`JCAJBH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT=' 稽查信息表：存储税收稽查案件的基础信息、时间节点、违法事实及立案依据，支撑稽查业务管理与数据统计 ';

-- Creating table ATFX_QT_YS_XZCFXX
-- Original Oracle primary-key constraint: PK_ATFX_QT_YS_XZCFXX (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_QT_YS_XZCFXX` (
  `swxzcfjdsuuid` VARCHAR(32) NOT NULL COMMENT '税务行政处罚决定书UUID',
  `sswfxwdjuuid` VARCHAR(32) NOT NULL COMMENT '税收违法行为登记UUID',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `wh` VARCHAR(100) NOT NULL COMMENT '文号',
  `wszzrq` DATETIME NOT NULL COMMENT '文书制作日期',
  `jcssqq` DATETIME COMMENT '检查所属期起,简易/不予处罚场景为NULL',
  `jcssqz` DATETIME COMMENT '检查所属期止,不予处罚场景为NULL',
  `wfss` VARCHAR(4000) COMMENT '违法事实:不予处罚取JCNR（检查内容）',
  `wfsd` VARCHAR(4000) COMMENT '违法手段：简易处罚取WFSD_DM对应的字典名称；不予处罚场景填NULL',
  `swxzcfyj` VARCHAR(4000) COMMENT '税务行政处罚依据：简易处罚取CFYJ字段值；不予处罚取YJ_1字段值',
  `cfjd` VARCHAR(4000) COMMENT '处罚决定：不予处罚取BYCFLY（不予处罚理由）',
  `yjfkje` DECIMAL(20,2) COMMENT '应缴罚款金额：简易处罚取FK_1字段值，不予处罚场景为NULL',
  `sjlx` VARCHAR(30) COMMENT '数据类型：处罚决定/简易处罚决定/不予处罚决定',
  KEY `IDX_XZCFXX_DJXH` (`DJXH`),
  CONSTRAINT `PK_ATFX_QT_YS_XZCFXX` PRIMARY KEY (`SWXZCFJDSUUID`, `SSWFXWDJUUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='行政处罚信息表';

-- Creating table ATFX_SH_JG_AFHGJTJ
-- Original Oracle primary-key constraint: PK_ATFX_SH_JG_AFHGJTJ (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_SH_JG_AFHGJTJ` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `ckshny` VARCHAR(6) NOT NULL COMMENT '出口收汇年月',
  `hggjhdqsz_dm` VARCHAR(3) NOT NULL COMMENT '海关国家和地区数字代码',
  `ckshjemy` DECIMAL(20,2) COMMENT '出口收汇金额（美元）',
  `ckshjermb` DECIMAL(20,2) COMMENT '出口收汇金额（人民币）',
  `ckshhbzm_dm` VARCHAR(6) NOT NULL COMMENT '出口收汇货币字母代码',
  CONSTRAINT `PK_ATFX_SH_JG_AFHGJTJ` PRIMARY KEY (`DJXH`, `CKSHNY`, `HGGJHDQSZ_DM`, `CKSHHBZM_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='按付汇国家统计数据';

-- Creating table ATFX_SH_JG_ANYTJ
-- Original Oracle primary-key constraint: PK_ATFX_SH_JG_ANYTJ (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_SH_JG_ANYTJ` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `ckshny` VARCHAR(6) NOT NULL COMMENT '出口收汇年月',
  `ckshjemy` DECIMAL(20,2) COMMENT '出口收汇金额（美元）',
  `ckshjermb` DECIMAL(20,2) COMMENT '出口收汇金额（人民币）',
  `qzkjrmbje` DECIMAL(20,2) COMMENT '其中跨境人民币金额',
  CONSTRAINT `PK_ATFX_SH_JG_ANYTJ` PRIMARY KEY (`DJXH`, `CKSHNY`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='按年月统计收汇数据';

-- Creating table ATFX_SH_YS_CKSHXX
-- Original Oracle primary-key constraint: PK_ATFX_SH_YS_CKSHXX (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_SH_YS_CKSHXX` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID，主键',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `ckshrq` DATETIME COMMENT '出口收汇日期（外管局），对应人民币收汇为SKRQ',
  `ckshhbzm_dm` VARCHAR(3) COMMENT '出口收汇货币字母代码（外管局），对应人民币收汇为HBZM_DM',
  `ckshje` DECIMAL(18,2) COMMENT '出口收汇金额（原币），对应人民币收汇为SKZJE',
  `ckshjemy` DECIMAL(18,2) COMMENT '出口收汇金额（美元），人民币收汇需参考HX_CS_ZDY.CS_CKTS_HL表转换',
  `ckshjermb` DECIMAL(18,2) COMMENT '收款总金额（人民币），外管局收汇需参考HX_CS_ZDY.CS_CKTS_HL表转换，人民币收汇=SKZJE',
  `gjhdqszm_dm` VARCHAR(3) COMMENT '国家或地区三字母代码，对应人民币收汇为null',
  `gbdq_dm` VARCHAR(3) COMMENT '国家或地区数字代码，对应外管局收汇为null',
  `hggjhdqsz_dm` VARCHAR(3) COMMENT '海关国家和地区数字代码，根据GJHDQSZM_DM、GBDQ_DM参考HX_DM_ZDY.DM_CKTS_HGGJHDQ表转换',
  `yhywbh` VARCHAR(50) COMMENT '银行业务编号',
  KEY `IDX_ATFX_SH_YS_CKSHXX_DC` (`DJXH`, `CKSHRQ`),
  CONSTRAINT `PK_ATFX_SH_YS_CKSHXX` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口收汇信息表';

-- Creating table ATFX_TS_JG_ACKSPTJ
-- Original Oracle primary-key constraint: PK_ATFX_TS_JG_ACKSPTJ (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_TS_JG_ACKSPTJ` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `sbny` VARCHAR(6) NOT NULL COMMENT '申报年月',
  `cksp_dm` VARCHAR(20) NOT NULL COMMENT '出口商品代码',
  `ckspmc` VARCHAR(200) COMMENT '出口商品名称',
  `mylaj` DECIMAL(20,2) COMMENT '申报美元离岸价（免退税、代办退税为null）',
  `rmblaj` DECIMAL(20,2) COMMENT '人民币离岸价（免退税、代办退税为null）',
  `jsje` DECIMAL(20,2) COMMENT '计税金额（免抵退为null）',
  `mdtse` DECIMAL(20,2) COMMENT '免抵退税额（免退税、代办退税为null）',
  `tse` DECIMAL(20,2) COMMENT '退税额（免抵退按对审汇总表应退免抵比例计算统计）',
  `mde` DECIMAL(20,2) COMMENT '免抵税额（免抵退=MDTSE-TSE；免退税、代办退税为null）',
  CONSTRAINT `PK_ATFX_TS_JG_ACKSPTJ` PRIMARY KEY (`DJXH`, `SBNY`, `CKSP_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='按出口商品统计退税数据表';

-- Creating table ATFX_TS_JG_AGYSTJ
-- Original Oracle primary-key constraint: PK_ATFX_TS_JG_AGYSTJ (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_TS_JG_AGYSTJ` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `sbny` VARCHAR(6) NOT NULL COMMENT '申报年月',
  `gyssbh` VARCHAR(20) NOT NULL COMMENT '供应商识别号',
  `gysmc` VARCHAR(200) NOT NULL COMMENT '供应商名称',
  `cksp_dm` VARCHAR(20) NOT NULL COMMENT '出口商品代码（前4位）',
  `ckspmc` VARCHAR(200) COMMENT '出口商品名称',
  `jsje` DECIMAL(20,2) COMMENT '计税金额',
  `tse` DECIMAL(20,2) COMMENT '退税额',
  CONSTRAINT `PK_ATFX_TS_JG_AGYSTJ` PRIMARY KEY (`DJXH`, `SBNY`, `GYSSBH`, `CKSP_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='按供应商统计退税数据';

-- Creating table ATFX_TS_JG_ANYTJ
-- Original Oracle primary-key constraint: PK_ATFX_TS_JG_ANYTJ (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_TS_JG_ANYTJ` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `sbny` VARCHAR(6) NOT NULL COMMENT '申报年月',
  `bgdfs` DECIMAL(10,0) COMMENT '报关单份数',
  `hwmxts` DECIMAL(10,0) COMMENT '货物明细条数',
  `mylaj` DECIMAL(20,2) COMMENT '申报美元离岸价（免退税、代办退税为null）',
  `rmblaj` DECIMAL(20,2) COMMENT '人民币离岸价（免退税、代办退税为null）',
  `jsje` DECIMAL(20,2) COMMENT '计税金额（免抵退为null）',
  `mdtse` DECIMAL(20,2) COMMENT '免抵退税额（免退税、代办退税为null）',
  `tse` DECIMAL(20,2) COMMENT '退税额（免抵退按对审汇总表ytse_1统计）',
  `mde` DECIMAL(20,2) COMMENT '免抵额（免抵退按对审汇总表ytse_1统计；免退税、代办退税为null）',
  `hwmxts_cqsb` DECIMAL(10,0) COMMENT '其中超期申报货物明细条数',
  `mylaj_cqsb` DECIMAL(20,2) COMMENT '其中超期申报申报美元离岸价',
  CONSTRAINT `PK_ATFX_TS_JG_ANYTJ` PRIMARY KEY (`DJXH`, `SBNY`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='按年月统计退税数据表';

-- Creating table ATFX_TS_YS_CKMXSBB
-- Original Oracle primary-key constraint: PK_ATFX_TS_YS_CKMXSBB (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_TS_YS_CKMXSBB` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID，主键',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号（关联企业主表，标识申报企业）',
  `lcslid` VARCHAR(50),
  `ssq` VARCHAR(6) NOT NULL COMMENT '所属期（格式YYYYMM，申报数据的核心归属维度）',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `glh` VARCHAR(30) NOT NULL COMMENT '关联号（核心关联字段，用于关联进货明细计算金额与退税额）',
  `ckfph` VARCHAR(30),
  `ckbgdh` VARCHAR(21),
  `dlzmh` VARCHAR(20),
  `ckrq_1` DATETIME,
  `cksp_dm` VARCHAR(20) NOT NULL,
  `sbhgspmc` VARCHAR(200) NOT NULL,
  `hgjldwmc` VARCHAR(50),
  `cksl` DECIMAL(18,6),
  `mylaj` DECIMAL(18,2),
  `rmblaj` DECIMAL(18,2) COMMENT '人民币离岸价（根据报关单号/代理证明号从报关单/代理证明数据提取）',
  `ckjhje` DECIMAL(18,2) COMMENT '出口进货金额（根据关联号匹配进货明细，汇总计算得出）',
  `zzstse` DECIMAL(18,2) COMMENT '增值税退税额（根据关联号匹配进货明细的增值税税额，按规则计算得出）',
  `xfstse` DECIMAL(18,2) COMMENT '消费税退税额（根据关联号匹配进货明细的消费税税额，按规则计算得出）',
  `cktmsywlxdmjh` VARCHAR(100),
  `cktmsywlxmcjh` VARCHAR(200),
  `lrrq` DATETIME COMMENT '录入日期（即申报提交日期，记录申报操作时间）',
  `byblbz` CHAR(1),
  `bytsbz` CHAR(1) COMMENT '不予退税标志（标识该笔出口明细是否符合退税条件）',
  `bz` VARCHAR(500),
  KEY `IDX_CKMXSBB_CKBGDH` (`CKBGDH`),
  KEY `IDX_CKMXSBB_CKFPH` (`CKFPH`),
  KEY `IDX_CKMXSBB_CKSP_DM` (`CKSP_DM`),
  KEY `IDX_CKMXSBB_DJXH` (`DJXH`),
  KEY `IDX_CKMXSBB_GLH` (`GLH`),
  KEY `IDX_CKMXSBB_LCSLID` (`LCSLID`),
  KEY `IDX_CKMXSBB_SSQ_SBPC` (`SSQ`, `SBPC`),
  CONSTRAINT `PK_ATFX_TS_YS_CKMXSBB` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口明细申报表';

-- Creating table ATFX_TS_YS_DBTSSBB
-- Original Oracle primary-key constraint: PK_ATFX_TS_YS_DBTSSBB (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_TS_YS_DBTSSBB` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID，主键',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `lcslid` VARCHAR(50) COMMENT '流程实例ID',
  `ssq` VARCHAR(6) NOT NULL COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `wtdbtsscqynsrsbh` VARCHAR(20) NOT NULL COMMENT '委托代办退税生产企业纳税人识别号',
  `wtdbtsscqyshxydm` VARCHAR(18) COMMENT '委托代办退税生产企业社会信用代码',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `cksp_dm` VARCHAR(20) NOT NULL COMMENT '出口商品代码',
  `hgspmc` VARCHAR(200) NOT NULL COMMENT '海关商品名称',
  `hgjldwmc` VARCHAR(50) COMMENT '海关计量单位名称',
  `cksl` DECIMAL(18,6) COMMENT '出口数量',
  `mylaj` DECIMAL(18,2) COMMENT '美元离岸价',
  `dbtswspzhm` VARCHAR(50) COMMENT '代办退税完税凭证号码',
  `kprq` DATETIME COMMENT '开票日期',
  `jsje` DECIMAL(18,2) COMMENT '计税金额',
  `zssl` VARCHAR(10) COMMENT '征税税率',
  `tsl` VARCHAR(10) COMMENT '退税率',
  `tse` DECIMAL(18,2) COMMENT '退税额',
  `cktmsywlxdmjh` VARCHAR(100) COMMENT '出口退（免）税业务类型代码集合',
  `cktmsywlxmcjh` VARCHAR(200) COMMENT '出口退（免）税业务类型名称集合',
  `dbtsywlx_dm` VARCHAR(10) COMMENT '代办退税业务类型代码',
  `dbtsywlxmc` VARCHAR(100) COMMENT '代办退税业务类型名称',
  `lrrq` DATETIME COMMENT '录入日期（申报日期）',
  `byblbz` CHAR(1) COMMENT '不予办理标志',
  `bytsbz` CHAR(1) COMMENT '不予退税标志',
  `mtsny` VARCHAR(6) COMMENT '免退税年月',
  `bz` VARCHAR(500) COMMENT '备注',
  KEY `IDX_DBTSSBB_CKBGDH` (`CKBGDH`),
  KEY `IDX_DBTSSBB_CKRQ1` (`CKRQ_1`),
  KEY `IDX_DBTSSBB_CKSP_DM` (`CKSP_DM`),
  KEY `IDX_DBTSSBB_DBTSYWLX_DM` (`DBTSYWLX_DM`),
  KEY `IDX_DBTSSBB_DJXH` (`DJXH`),
  KEY `IDX_DBTSSBB_SSQ` (`SSQ`),
  KEY `IDX_DBTSSBB_WTDBTSSCQYNSRSBH` (`WTDBTSSCQYNSRSBH`),
  CONSTRAINT `PK_ATFX_TS_YS_DBTSSBB` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='代办退税申报表';

-- Creating table ATFX_TS_YS_JHMXSBB
-- Original Oracle primary-key constraint: PK_ATFX_TS_YS_JHMXSBB (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_TS_YS_JHMXSBB` (
  `uuid` VARCHAR(32) NOT NULL COMMENT '主键',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `lcslid` VARCHAR(50) COMMENT '流程实例ID',
  `ssq` VARCHAR(6) NOT NULL COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `glh` VARCHAR(30) NOT NULL COMMENT '关联号',
  `sz` VARCHAR(2) NOT NULL COMMENT '税种',
  `jhpzh` VARCHAR(64) NOT NULL COMMENT '进货凭证号',
  `ghfnsrsbh_1` VARCHAR(20) COMMENT '供货方纳税人识别号',
  `kprq` DATETIME NOT NULL COMMENT '开票日期',
  `cksp_dm` VARCHAR(20) NOT NULL COMMENT '出口商品代码',
  `sbhgspmc` VARCHAR(400) NOT NULL COMMENT '申报海关商品名称||申报海关商品名称',
  `hgjldwmc` VARCHAR(50) COMMENT '海关计量单位名称',
  `sl` DECIMAL(18,6) COMMENT '数量',
  `jsje` DECIMAL(18,2) COMMENT '计税金额',
  `zssl` VARCHAR(10) COMMENT '征税税率',
  `zsse` DECIMAL(18,2) COMMENT '征税税额',
  `tsl` VARCHAR(10) COMMENT '退税率',
  `tse` DECIMAL(18,2) COMMENT '退税额',
  `cktmsywlxdmjh` VARCHAR(100) COMMENT '出口退（免）税业务类型代码集合',
  `cktmsywlxmcjh` VARCHAR(200) COMMENT '出口退（免）税业务类型名称集合',
  `lrrq` DATETIME COMMENT '录入日期（申报日期）',
  `byblbz` CHAR(1) COMMENT '不予办理标志',
  `bytsbz` CHAR(1) COMMENT '不予退税标志',
  `mtsbz` CHAR(1) COMMENT '免退税标志',
  `bz` VARCHAR(500) COMMENT '备注',
  `ckrq_1` DATETIME COMMENT '出口日期（根据关联号从出口明细表提取，同一关联号下有多条出口明细的按最早的出口日期提取）',
  KEY `IDX_JHMXSBB_CKRQ1` (`CKRQ_1`),
  KEY `IDX_JHMXSBB_CKSP_DM` (`CKSP_DM`),
  KEY `IDX_JHMXSBB_DJXH` (`DJXH`),
  KEY `IDX_JHMXSBB_GHFNSRSBH` (`GHFNSRSBH_1`),
  KEY `IDX_JHMXSBB_GLH` (`GLH`),
  KEY `IDX_JHMXSBB_JHPZH` (`JHPZH`),
  KEY `IDX_JHMXSBB_SSQ` (`SSQ`),
  CONSTRAINT `PK_ATFX_TS_YS_JHMXSBB` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='进货明细申报表';

-- Creating table ATFX_TS_YS_MDTSHZB
-- Original Oracle primary-key constraint: PK_ATFX_TS_YS_MDTSHZB (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_TS_YS_MDTSHZB` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID||uuid',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `lcslid` VARCHAR(32) COMMENT '流程实例ID',
  `ssq` VARCHAR(6) COMMENT '所属期',
  `ckxsemy` DECIMAL(18,2) COMMENT '出口销售额（美元）',
  `ckhwxsemy` DECIMAL(18,2) COMMENT '出口货物销售额（美元）',
  `ysfwxsemy` DECIMAL(18,2) COMMENT '应税服务销售额（美元）',
  `ckxsermb` DECIMAL(18,2) COMMENT '出口销售额（人民币）',
  `mdtsbdmzhdkse` DECIMAL(18,2) COMMENT '免抵退税不得免征和抵扣税额',
  `ckhwbdmzhdkse` DECIMAL(18,2) COMMENT '出口货物不得免征和抵扣税额',
  `ysfwbdmzhdkse` DECIMAL(18,2) COMMENT '应税服务不得免征和抵扣税额',
  `jljghxytzbdmzhdkse` DECIMAL(18,2) COMMENT '进料加工核销应调整不得免征和抵扣税额',
  `mdtsbdmzhdksehj` DECIMAL(18,2) COMMENT '免抵退税不得免征和抵扣税额合计',
  `bdmzdkseynsbce` DECIMAL(18,2) COMMENT '不得免征抵扣税额与纳税表差额',
  `mdtse` DECIMAL(18,2) COMMENT '免抵退税额',
  `ckhwmdtse` DECIMAL(18,2) COMMENT '出口货物免抵退税额',
  `ysfwmdtse` DECIMAL(18,2) COMMENT '应税服务免抵退税额',
  `sqjzmdtse` DECIMAL(18,2) COMMENT '上期结转免抵退税额',
  `jljghxytzmdtse` DECIMAL(18,2) COMMENT '进料加工核销应调整免抵退税额',
  `mdtsehj` DECIMAL(18,2) COMMENT '免抵退税额合计',
  `jzxqmdtse` DECIMAL(18,2) COMMENT '结转下期免抵退税额',
  `zzsnssbbqmldse` DECIMAL(18,2) COMMENT '增值税纳税申报表期末留抵税额',
  `ytse_1` DECIMAL(18,2) COMMENT '应退税额',
  `mdse` DECIMAL(18,2) COMMENT '免抵税额',
  KEY `IDX_ATFX_TS_YS_MDTSHZB_DS` (`DJXH`, `SSQ`),
  KEY `IDX_ATFX_TS_YS_MDTSHZB_LCSLID` (`LCSLID`),
  CONSTRAINT `PK_ATFX_TS_YS_MDTSHZB` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='免抵退税申报汇总表';

-- Creating table ATFX_TS_YS_MDTSSBB
-- Original Oracle primary-key constraint: PK_ATFX_TS_YS_MDTSSBB (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_TS_YS_MDTSSBB` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID，主键',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `lcslid` VARCHAR(32) COMMENT '流程实例ID',
  `ssq` VARCHAR(6) NOT NULL COMMENT '所属期',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `ckfph` VARCHAR(30) COMMENT '出口发票号',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `dlckhwzmhm` VARCHAR(20) COMMENT '代理出口货物证明号码',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `cksp_dm` VARCHAR(20) NOT NULL COMMENT '出口商品代码',
  `sbhgspmc` VARCHAR(500) NOT NULL COMMENT '申报海关商品名称',
  `hgjldwmc` VARCHAR(75) COMMENT '海关计量单位名称',
  `cksl` DECIMAL(18,6) COMMENT '出口数量',
  `cjhbzm_dm` VARCHAR(3) COMMENT '成交货币字母代码',
  `cjzj` DECIMAL(18,2) COMMENT '成交总价',
  `cjhbhl` DECIMAL(16,6) COMMENT '成交货币汇率',
  `rmblaj` DECIMAL(18,2) COMMENT '人民币离岸价',
  `myhl` DECIMAL(16,6) COMMENT '美元汇率',
  `mylaj` DECIMAL(18,2) COMMENT '美元离岸价',
  `zssl` VARCHAR(10) COMMENT '征税税率',
  `tsl` VARCHAR(10) COMMENT '退税率',
  `jljgszch` VARCHAR(20) COMMENT '进料加工手（账）册号',
  `jsfpl` DECIMAL(16,6) COMMENT '计算分配率',
  `tzhjhfpl` DECIMAL(16,6) COMMENT '调整后计划分配率',
  `jljgbsjkljzcjsjg` DECIMAL(18,2) COMMENT '进料加工保税进口料件组成计税价格',
  `gngjmsycljg` DECIMAL(18,2) COMMENT '国内购进免税原材料价格',
  `mdtsbdmzhdkse` DECIMAL(18,2) COMMENT '免抵退税不得免征和抵扣税额',
  `mdtse` DECIMAL(18,2) COMMENT '免抵退税额',
  `cktmsywlxdmjh` VARCHAR(100) COMMENT '出口退（免）税业务类型代码集合',
  `cktmsywlxmcjh` VARCHAR(200) COMMENT '出口退（免）税业务类型名称集合',
  `lrrq` DATETIME COMMENT '录入日期（申报日期）',
  `byblbz` CHAR(1) COMMENT '不予办理标志',
  `byblyy` VARCHAR(3000) COMMENT '不予办理原因',
  `bytsbz` CHAR(1) COMMENT '不予退税标志',
  `bytsny` VARCHAR(6) COMMENT '不予退税年月',
  `zbblny` VARCHAR(6) COMMENT '暂不办理年月',
  `mdtsny` VARCHAR(6) COMMENT '免抵退税年月',
  `bz` VARCHAR(500) COMMENT '备注',
  KEY `IDX_MDTSSBB_CKBGDH` (`CKBGDH`),
  KEY `IDX_MDTSSBB_CKFPH` (`CKFPH`),
  KEY `IDX_MDTSSBB_CKRQ_1` (`CKRQ_1`),
  KEY `IDX_MDTSSBB_CKSP_DM` (`CKSP_DM`),
  KEY `IDX_MDTSSBB_DJXH` (`DJXH`),
  KEY `IDX_MDTSSBB_LCSLID` (`LCSLID`),
  KEY `IDX_MDTSSBB_SSQ` (`SSQ`),
  CONSTRAINT `PK_ATFX_TS_YS_MDTSSBB` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='免抵退税申报明细表';

-- Creating table ATFX_TS_YS_TSBLXX
-- Original Oracle primary-key constraint: PK_ATFX_TS_YS_TSBLXX (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_TS_YS_TSBLXX` (
  `srthsuuid` VARCHAR(32) NOT NULL COMMENT '收入退还书UUID，主键',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `ydjxh` DECIMAL(20,0) COMMENT '原登记序号（提取生产企业通过外综服企业代办退税的数据时，取代办退税的外综服企业djxh，非代办退税的数据为null）',
  `kprq` DATETIME COMMENT '开票日期',
  `thrq_1` DATETIME COMMENT '退还日期',
  `xhrq_1` DATETIME COMMENT '销号日期',
  `tzlx_dm` VARCHAR(10) COMMENT '调账类型代码',
  `ttsjlx_dm` VARCHAR(10) COMMENT '提退税金类型代码',
  `skzl_dm` VARCHAR(10) COMMENT '税款种类代码',
  `zsxm_dm` VARCHAR(10) COMMENT '征收项目代码',
  `tdsfyylx_dm` VARCHAR(10) COMMENT '退抵税费原因类型代码',
  `yskm_dm` VARCHAR(20) COMMENT '预算科目代码',
  `sksx_dm` VARCHAR(10) COMMENT '税款属性代码',
  `skssqq` DATETIME NOT NULL COMMENT '税款所属期起',
  `skssqz` DATETIME NOT NULL COMMENT '税款所属期止',
  `se` DECIMAL(18,2) NOT NULL COMMENT '税额',
  `ydtuuid` VARCHAR(32) COMMENT '应抵退UUID',
  `ydtlyuuid` VARCHAR(32) COMMENT '应抵退来源UUID',
  `sjlx` VARCHAR(30) COMMENT '数据类型（1、自行申报出口退税、2、留抵退税、3、代办退税、）',
  KEY `IDX_TSBLXX_DJXH` (`DJXH`),
  KEY `IDX_TSBLXX_SJLX` (`SJLX`),
  KEY `IDX_TSBLXX_SKSSQQ_SKSSQZ` (`SKSSQQ`, `SKSSQZ`),
  KEY `IDX_TSBLXX_SKZL_DM_ZSXM_DM` (`SKZL_DM`, `ZSXM_DM`),
  KEY `IDX_TSBLXX_THRQ1` (`THRQ_1`),
  KEY `IDX_TSBLXX_YDJXH` (`YDJXH`),
  KEY `IDX_TSBLXX_YDTUUID` (`YDTUUID`),
  CONSTRAINT `PK_ATFX_TS_YS_TSBLXX` PRIMARY KEY (`SRTHSUUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='退税办理信息表';

-- Creating table ATFX_TS_YS_TSFNXX
-- Original Oracle primary-key constraint: PK_ATFX_TS_YS_TSFNXX (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_TS_YS_TSFNXX` (
  `spuuid` VARCHAR(32) NOT NULL COMMENT '税票UUID（留抵退税取ZSUUID）',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `rkrq` DATETIME COMMENT '入库日期',
  `tzlx_dm` VARCHAR(10) COMMENT '调账类型代码',
  `skzl_dm` VARCHAR(10) NOT NULL COMMENT '税款种类代码',
  `zsxm_dm` VARCHAR(10) NOT NULL COMMENT '征收项目代码',
  `sksx_dm` VARCHAR(10) COMMENT '税款属性代码',
  `yzpzzl_dm` VARCHAR(10) COMMENT '应征凭证种类代码（出口退税返纳为null）',
  `yskm_dm` VARCHAR(20) COMMENT '预算科目代码',
  `skssqq` DATETIME NOT NULL COMMENT '税款所属期起（格式YYYYMM）',
  `skssqz` DATETIME NOT NULL COMMENT '税款所属期止（格式YYYYMM）',
  `sjje` DECIMAL(18,2) NOT NULL COMMENT '实缴金额（留抵退税取YBTSE）',
  KEY `IDX_TSFNXX_DJXH` (`DJXH`),
  KEY `IDX_TSFNXX_RKRQ` (`RKRQ`),
  KEY `IDX_TSFNXX_SKSSQQ_SKSSQZ` (`SKSSQQ`, `SKSSQZ`),
  KEY `IDX_TSFNXX_SKZL_DM_ZSXM_DM` (`SKZL_DM`, `ZSXM_DM`),
  CONSTRAINT `PK_ATFX_TS_YS_TSFNXX` PRIMARY KEY (`SPUUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='退税返纳信息表';

-- Creating table ATFX_TS_YS_WTDBTSSBB
-- Original Oracle primary-key constraint: PK_ATFX_TS_YS_WTDBTSSBB (MySQL index name: PRIMARY).
-- Auxiliary UNIQUE index UK_WTDBTSSBB_SSQ_SBPC_SBXH_ORACLE_NULLS preserves Oracle composite-UNIQUE NULL behavior: duplicate partially-NULL keys are rejected; wholly-NULL keys remain allowed. NULL flags prevent sentinel collisions; original named UNIQUE key is kept.
CREATE TABLE `ATFX_TS_YS_WTDBTSSBB` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID，主键',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号（本企业登记序号而非代办退税明细表中的登记序号）',
  `ydjxh` DECIMAL(20,0) COMMENT '原登记序号（代办退税明细表中外综服企业的djxh）',
  `lcslid` VARCHAR(50) COMMENT '流程实例ID',
  `ssq` VARCHAR(6) NOT NULL COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `cksp_dm` VARCHAR(20) NOT NULL COMMENT '出口商品代码',
  `hgspmc` VARCHAR(200) NOT NULL COMMENT '海关商品名称',
  `hgjldwmc` VARCHAR(50) COMMENT '海关计量单位名称',
  `cksl` DECIMAL(18,6) COMMENT '出口数量',
  `mylaj` DECIMAL(18,2) COMMENT '美元离岸价',
  `dbtswspzhm` VARCHAR(50) COMMENT '代办退税完税凭证号码',
  `kprq` DATETIME COMMENT '开票日期',
  `jsje` DECIMAL(18,2) COMMENT '计税金额',
  `zssl` VARCHAR(10) COMMENT '征税税率',
  `tsl` VARCHAR(10) COMMENT '退税率',
  `tse` DECIMAL(18,2) COMMENT '退税额',
  `cktmsywlxdmjh` VARCHAR(100) COMMENT '出口退（免）税业务类型代码集合',
  `cktmsywlxmcjh` VARCHAR(200) COMMENT '出口退（免）税业务类型名称集合',
  `lrrq` DATETIME COMMENT '录入日期（申报日期）',
  `byblbz` CHAR(1) COMMENT '不予办理标志',
  `bytsbz` CHAR(1) COMMENT '不予退税标志',
  `mtsny` VARCHAR(6) COMMENT '免退税年月',
  `bz` VARCHAR(500) COMMENT '备注',
  KEY `IDX_WTDBTSSBB_CKBGDH` (`CKBGDH`),
  KEY `IDX_WTDBTSSBB_CKSP_DM` (`CKSP_DM`),
  KEY `IDX_WTDBTSSBB_DJXH` (`DJXH`),
  KEY `IDX_WTDBTSSBB_LCSLID` (`LCSLID`),
  KEY `IDX_WTDBTSSBB_SSQ` (`SSQ`),
  KEY `IDX_WTDBTSSBB_YDJXH` (`YDJXH`),
  CONSTRAINT `PK_ATFX_TS_YS_WTDBTSSBB` PRIMARY KEY (`UUID`),
  CONSTRAINT `UK_WTDBTSSBB_SSQ_SBPC_SBXH` UNIQUE (`SSQ`, `SBPC`, `SBXH`),
  UNIQUE KEY `UK_WTDBTSSBB_SSQ_SBPC_SBXH_ORACLE_NULLS` (`ssq`, (COALESCE(`sbpc`, '')), (`sbpc` IS NULL), (COALESCE(`sbxh`, '')), (`sbxh` IS NULL))
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='委托代办退税申报明细表';

-- Creating table ATFX_YDZY_CS_MDGDYB
-- Original Oracle primary-key constraint: PK_ATFX_YDZY_CS_MDGDYB (MySQL index name: PRIMARY).
CREATE TABLE `ATFX_YDZY_CS_MDGDYB` (
  `hggjhdqsz_dm` CHAR(3) NOT NULL COMMENT '海关国家或地区数字代码',
  `gjhdqsz_dm` CHAR(3) NOT NULL COMMENT '国家或地区数字代码',
  `gjhdqszm_dm` CHAR(3) COMMENT '国家或地区三字母代码',
  `gjhdqlzm_dm` CHAR(2) COMMENT '国家或地区俩字母代码',
  `gjhdqmc` VARCHAR(200) COMMENT '国家或地区名称',
  `gjhdqjc` VARCHAR(75) COMMENT '国家或地区简称',
  `gjhdqywmc` VARCHAR(200) COMMENT '国家或地区英文名称',
  `gjhdqywjc` VARCHAR(75) COMMENT '国家或地区英文简称',
  `xybz` CHAR(1) COMMENT '选用标志',
  `yxbz` CHAR(1) COMMENT '有效标志',
  `mydy` VARCHAR(50) COMMENT '民用电压',
  `gydy` VARCHAR(50) COMMENT '工业电压',
  CONSTRAINT `PK_ATFX_YDZY_CS_MDGDYB` PRIMARY KEY (`HGGJHDQSZ_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='案头分析-疑点指引-参数-目的国电压表';

-- Creating table CKLLFX_CS_FXDJSZ
-- Original Oracle primary-key constraint: PK_CKLLFX_CS_FXDJSZ (MySQL index name: PRIMARY).
CREATE TABLE `CKLLFX_CS_FXDJSZ` (
  `fxdj_dm` VARCHAR(1) NOT NULL COMMENT '风险等级代码',
  `fxdj_mc` VARCHAR(20) NOT NULL COMMENT '风险等级名称',
  `fxdj_pdbj` VARCHAR(100) NOT NULL COMMENT '风险等级判定标准',
  `fxdj_czfs` VARCHAR(100) NOT NULL COMMENT '风险处置方式',
  `fxdj_yz` DECIMAL(5,2) NOT NULL COMMENT '阈值设置（%小于等于）',
  CONSTRAINT `PK_CKLLFX_CS_FXDJSZ` PRIMARY KEY (`FXDJ_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口链路风险等级参数表';

-- Creating table CKLLFX_CS_SWJGYJTZ
-- Original Oracle primary-key constraint: PK_CKLLFX_CS_SWJGYJTZ (MySQL index name: PRIMARY).
CREATE TABLE `CKLLFX_CS_SWJGYJTZ` (
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `tsjsff_dm` CHAR(1) NOT NULL COMMENT '1生产2外贸（目前暂处理外贸）',
  `ysfs_dm` VARCHAR(2) NOT NULL COMMENT '运输方式代码',
  `spdl_dm` VARCHAR(10) NOT NULL COMMENT '商品大类（暂设定商品代码前2位）',
  `qycode_hyd` VARCHAR(2) NOT NULL COMMENT '货源地区域代码',
  `qycode_hg` VARCHAR(2) NOT NULL COMMENT '启运口岸区域代码',
  `qycode_mdg` VARCHAR(2) NOT NULL COMMENT '目的国区域代码',
  `fxdj_tz` CHAR(1) NOT NULL COMMENT '调整风险等级代码',
  `fxdj_tzrq` DATETIME COMMENT '调整日期',
  `fxdj_tzry` VARCHAR(30) COMMENT '调整人员',
  `fxdj_tzyy` VARCHAR(200) COMMENT '调整原因',
  CONSTRAINT `PK_CKLLFX_CS_SWJGYJTZ` PRIMARY KEY (`SWJG_DM`, `TSJSFF_DM`, `YSFS_DM`, `SPDL_DM`, `QYCODE_HYD`, `QYCODE_HG`, `QYCODE_MDG`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='税务机关出口链路预警调整表';

-- Creating table CKLLFX_CS_WMQYLSLL
-- Original Oracle primary-key constraint: PK_CKLLFX_CS_WMQYLSLL (MySQL index name: PRIMARY).
CREATE TABLE `CKLLFX_CS_WMQYLSLL` (
  `ysfs_dm` VARCHAR(2) NOT NULL COMMENT '运输方式代码',
  `spdl_dm` VARCHAR(10) NOT NULL COMMENT '商品大类（暂设定商品代码前2位）',
  `qycode_hyd` VARCHAR(2) NOT NULL COMMENT '货源地区域代码',
  `qycode_hg` VARCHAR(2) NOT NULL COMMENT '启运口岸区域代码',
  `qycode_mdg` VARCHAR(2) NOT NULL COMMENT '目的国区域代码',
  `qyhs_all` DECIMAL(10,0) COMMENT '企业户数',
  `qyzb_all` DECIMAL(10,6) COMMENT '企业占比（%）',
  `bgdfs_all` DECIMAL(10,0) COMMENT '报关单份数',
  `bgdzb_all` DECIMAL(10,6) COMMENT '报关单占比（%）',
  `mylaj_all` DECIMAL(18,6) COMMENT '出口额美元',
  `myzb_all` DECIMAL(10,6) COMMENT '出口额占比（%）',
  `qyhs_sx` DECIMAL(10,0) COMMENT '（预留按预警口径筛选）企业户数',
  `qyzb_sx` DECIMAL(10,6) COMMENT '（预留按预警口径筛选）企业占比（%）',
  `bgdfs_sx` DECIMAL(10,0) COMMENT '（预留按预警口径筛选）报关单份数',
  `bgdzb_sx` DECIMAL(10,6) COMMENT '（预留按预警口径筛选）报关单占比（%）',
  `mylaj_sx` DECIMAL(18,6) COMMENT '（预留按预警口径筛选）出口额美元',
  `myzb_sx` DECIMAL(10,6) COMMENT '（预留按预警口径筛选）出口额占比（%）',
  `fxdj_zhfxzs` DECIMAL(10,6) COMMENT '综合风险指数，根据各项占比综合计算',
  `fxdj_dm` CHAR(1) COMMENT '风险等级代码，根据综合风险指数，参考参数表设置',
  CONSTRAINT `PK_CKLLFX_CS_WMQYLSLL` PRIMARY KEY (`YSFS_DM`, `SPDL_DM`, `QYCODE_HYD`, `QYCODE_HG`, `QYCODE_MDG`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='历史出口链路分析模型表（外贸）';

-- Creating table CKLLFX_CS_WMQYLSLL_DQ
-- Original Oracle primary-key constraint: PK_CKLLFX_CS_WMQYLSLL_DQ (MySQL index name: PRIMARY).
CREATE TABLE `CKLLFX_CS_WMQYLSLL_DQ` (
  `ysfs_dm` VARCHAR(2) NOT NULL COMMENT '运输方式代码',
  `spdl_dm` VARCHAR(10) NOT NULL COMMENT '商品大类（暂设定商品代码前2位）',
  `qycode_hyd` VARCHAR(2) NOT NULL COMMENT '货源地区域代码',
  `qycode_hg` VARCHAR(2) NOT NULL COMMENT '启运口岸区域代码',
  `qycode_mdg` VARCHAR(2) NOT NULL COMMENT '目的国区域代码',
  `qyhs_all` DECIMAL(10,0) COMMENT '企业户数',
  `qyzb_all` DECIMAL(10,6) COMMENT '企业占比（%）',
  `bgdfs_all` DECIMAL(10,0) COMMENT '报关单份数',
  `bgdzb_all` DECIMAL(10,6) COMMENT '报关单占比（%）',
  `mylaj_all` DECIMAL(18,6) COMMENT '出口额美元',
  `myzb_all` DECIMAL(10,6) COMMENT '出口额占比（%）',
  `qyhs_sx` DECIMAL(10,0) COMMENT '（预留按预警口径筛选）企业户数',
  `qyzb_sx` DECIMAL(10,6) COMMENT '（预留按预警口径筛选）企业占比（%）',
  `bgdfs_sx` DECIMAL(10,0) COMMENT '（预留按预警口径筛选）报关单份数',
  `bgdzb_sx` DECIMAL(10,6) COMMENT '（预留按预警口径筛选）报关单占比（%）',
  `mylaj_sx` DECIMAL(18,6) COMMENT '（预留按预警口径筛选）出口额美元',
  `myzb_sx` DECIMAL(10,6) COMMENT '（预留按预警口径筛选）出口额占比（%）',
  `fxdj_zhfxzs` DECIMAL(10,6) COMMENT '综合风险指数，根据各项占比综合计算',
  `fxdj_dm` CHAR(1) COMMENT '风险等级代码，根据综合风险指数，参考参数表设置',
  CONSTRAINT `PK_CKLLFX_CS_WMQYLSLL_DQ` PRIMARY KEY (`YSFS_DM`, `SPDL_DM`, `QYCODE_HYD`, `QYCODE_HG`, `QYCODE_MDG`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='历史出口链路分析模型表（外贸）';

-- Creating table CKLLFX_CS_WMQYLSLL_SF
-- Original Oracle primary-key constraint: PK_CKLLFX_CS_WMQYLSLL_SF (MySQL index name: PRIMARY).
CREATE TABLE `CKLLFX_CS_WMQYLSLL_SF` (
  `ysfs_dm` VARCHAR(2) NOT NULL COMMENT '运输方式代码',
  `spdl_dm` VARCHAR(10) NOT NULL COMMENT '商品大类（暂设定商品代码前2位）',
  `qycode_hyd` VARCHAR(2) NOT NULL COMMENT '货源地区域代码',
  `qycode_hg` VARCHAR(2) NOT NULL COMMENT '启运口岸区域代码',
  `qycode_mdg` VARCHAR(2) NOT NULL COMMENT '目的国区域代码',
  `qyhs_all` DECIMAL(10,0) COMMENT '企业户数',
  `qyzb_all` DECIMAL(10,6) COMMENT '企业占比（%）',
  `bgdfs_all` DECIMAL(10,0) COMMENT '报关单份数',
  `bgdzb_all` DECIMAL(10,6) COMMENT '报关单占比（%）',
  `mylaj_all` DECIMAL(18,6) COMMENT '出口额美元',
  `myzb_all` DECIMAL(10,6) COMMENT '出口额占比（%）',
  `qyhs_sx` DECIMAL(10,0) COMMENT '（预留按预警口径筛选）企业户数',
  `qyzb_sx` DECIMAL(10,6) COMMENT '（预留按预警口径筛选）企业占比（%）',
  `bgdfs_sx` DECIMAL(10,0) COMMENT '（预留按预警口径筛选）报关单份数',
  `bgdzb_sx` DECIMAL(10,6) COMMENT '（预留按预警口径筛选）报关单占比（%）',
  `mylaj_sx` DECIMAL(18,6) COMMENT '（预留按预警口径筛选）出口额美元',
  `myzb_sx` DECIMAL(10,6) COMMENT '（预留按预警口径筛选）出口额占比（%）',
  `fxdj_zhfxzs` DECIMAL(10,6) COMMENT '综合风险指数，根据各项占比综合计算',
  `fxdj_dm` CHAR(1) COMMENT '风险等级代码，根据综合风险指数，参考参数表设置',
  CONSTRAINT `PK_CKLLFX_CS_WMQYLSLL_SF` PRIMARY KEY (`YSFS_DM`, `SPDL_DM`, `QYCODE_HYD`, `QYCODE_HG`, `QYCODE_MDG`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='历史出口链路分析模型表（外贸）';

-- Creating table CKLLFX_DATA_BGDWL
-- Original Oracle primary-key constraint: PK_CKLLFX_DATA_BGDWL (MySQL index name: PRIMARY).
CREATE TABLE `CKLLFX_DATA_BGDWL` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '金三企业登记序号',
  `bgdhgbh` VARCHAR(21) NOT NULL COMMENT '出口报关单号（18位）',
  `dlzmh` VARCHAR(20) COMMENT '代理证明号，代理出口的需保留用于提取出口关联信息',
  `tmsjsff_dm` CHAR(1) NOT NULL COMMENT '退（免）税计算方法代码（1生产/2外贸），根据业务提取',
  `ckrq_1` DATETIME NOT NULL COMMENT '出口日期，来自报关单201',
  `mylaj` DECIMAL(18,2) NOT NULL COMMENT '美元离岸价，来自报关单201',
  `ysfs_dm` CHAR(1) NOT NULL COMMENT '运输方式，来自报关单201',
  `hzdwdq_dm` CHAR(5) NOT NULL COMMENT '境内货源地，来自报关单201',
  `hggqka_dm` CHAR(4) NOT NULL COMMENT '离境口岸（启运港业务取启运口岸，其他取出口口岸），来自报关单201',
  `zzmdgdqsz_dm` CHAR(3) NOT NULL COMMENT '目的国，来自报关单',
  `spdl_dm` VARCHAR(10) COMMENT '商品大类（暂设定商品代码前2位）',
  `fhms_dm` CHAR(1) COMMENT '发货模式（1整柜/2散货(拼箱)），根据报关单204表判断',
  `jzxh` VARCHAR(40) COMMENT '集装箱号（一票业务多个集装箱的列举一个集装箱加括号集装箱数量），来自报关单204',
  `jhpzh` VARCHAR(75) COMMENT '进货凭证号，按金额占比取最大供应商税号对应的任一笔进货凭证，用于发票系统查询供货商名称及主管税务机关',
  `ghfnsrsbh_1` VARCHAR(20) COMMENT '供应商税号，来自进货明细，按金额占比取最大供应商税号',
  `ghfnsrmc` VARCHAR(100) COMMENT '供应商名称，来自发票底账库',
  `ghfnsrswjg` VARCHAR(11) COMMENT '供应商主管税务机关（区县级），来自发票底账库',
  `qycode_hyd` VARCHAR(2) COMMENT '货源地区域，由供应商主管税务机关或境内货源地，对应到某个境内区域代码',
  `qycode_hg` VARCHAR(2) COMMENT '离境地区域，由离境口岸对应到境内区域代码',
  `qycode_mdg` VARCHAR(2) COMMENT '目的国区域，由目的国对应到境外区域代码',
  `fxdj_zhfxzs` DECIMAL(10,6) COMMENT '综合风险指数=出口链路规则命中的综合风险指数，由0至100，值越小风险越高',
  `fxdj_dm` CHAR(1) COMMENT '风险等级=出口链路规则命中的风险等级',
  `fxdj_gxrq` DATETIME COMMENT '风险刷新日期，刷新记录路径风险等级的日期值',
  `fxdj_tz` CHAR(1) COMMENT '风险等级调整，人工经轨迹验证后手工调整风险等级（高/中/低/常规）',
  `fzdj_tzyy` VARCHAR(200) COMMENT '风险调整原因，风险等级调整原因说明',
  `wlxxly_dm` CHAR(1) COMMENT '物流信息采集源（1出口发票/2申报表/3核查报送）',
  `ckfph` VARCHAR(30) COMMENT '出口发票号，用于提取物流信息',
  `cph` VARCHAR(500) COMMENT '车牌号，物流信息要素1，由企业报送采集',
  `qyrq` DATETIME COMMENT '起运日，物流信息要素2，由企业报送采集',
  `qyd` VARCHAR(500) COMMENT '起运地，物流信息要素3，由企业报送采集',
  `tydh` VARCHAR(32) COMMENT '提运单号，物流信息要素4，默认从报关单获取，核查时企业可更正',
  `qyd_xzqh` VARCHAR(6) COMMENT '起运地行政区划（预留），将起运地转行政区划代码',
  `tdlx_dm` CHAR(1) COMMENT '提单类型代码（预留，1船东提单/2货代提单）',
  `gjewmzt_dm` CHAR(1) COMMENT '轨迹二维码生成状态（空/0-未生成，1-已生成）',
  `bz` VARCHAR(100) COMMENT '备注，由税务人员自由填写',
  `sjgxsj` DATETIME NOT NULL COMMENT '数据修改时间，表示记录的最近更新时间',
  `ckfpbz` VARCHAR(2000) COMMENT '出口发票备注',
  `ckmxbz` VARCHAR(2000) COMMENT '出口明细备注',
  `wlxxly_bz` DECIMAL(2,0) COMMENT '后台解析物流信息标志（含义参考存储过程PRO_FXGL_SZYJ_WLXX）',
  `cpys_code` VARCHAR(50) COMMENT '车牌颜色(1：蓝色；2：黄色；3：黄绿色)',
  `cpys_name` VARCHAR(50) COMMENT '车牌颜色名称',
  KEY `IDX_CKLLFX_DATA_BGDWL_SJGXSJ` (`SJGXSJ`),
  CONSTRAINT `PK_CKLLFX_DATA_BGDWL` PRIMARY KEY (`DJXH`, `BGDHGBH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='企业出口链路信息表';

-- Creating table CKTS_BA_BABGQK_JGB
-- Original Oracle primary-key constraint: PK_CKTS_BA_BABGQK_JGB (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_BA_BABGQK_JGB` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID||uuid',
  `lcslid` CHAR(32) NOT NULL COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `bgq` VARCHAR(3000) COMMENT '变更前',
  `bgh` VARCHAR(3000) COMMENT '变更后',
  `bz` VARCHAR(3000) COMMENT '备注',
  `lrr_dm` CHAR(11) NOT NULL COMMENT '录入人代码',
  `lrrq` DATETIME NOT NULL COMMENT '录入日期',
  `tsswjg_dm_1` CHAR(11) NOT NULL COMMENT '退税税务机关代码',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `sjgsdq` CHAR(11) NOT NULL COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `tbrq_1` DATETIME COMMENT '填表日期',
  `babgzd_dm` VARCHAR(30) COMMENT '备案变更字段代码',
  `babgzdmc` VARCHAR(150) COMMENT '备案变更字段名称',
  `fszl` VARCHAR(450) COMMENT '附送资料||应用于进出口退税',
  `ckzhuuid` VARCHAR(32) COMMENT '存款账号UUID',
  `bz_1` CHAR(1) COMMENT '标志',
  KEY `IDX_CKTS_BA_BABGQK_JGB_DB` (`DJXH`, `BABGZD_DM`),
  KEY `IDX_CKTS_BA_BABGQK_JGB_L` (`LCSLID`),
  CONSTRAINT `PK_CKTS_BA_BABGQK_JGB` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='备案变更情况结果表';

-- Creating table CKTS_DJ_BGDJMX
-- Original Oracle primary-key constraint: PK_DJ_BGDJMX (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_DJ_BGDJMX` (
  `bgdjmxuuid` VARCHAR(32) NOT NULL COMMENT '变更登记明细UUID，主键',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `bgxm_dm` VARCHAR(13) NOT NULL COMMENT '变更项目代码(''030'',''086'',''112'')',
  `lrrq` DATETIME NOT NULL COMMENT '录入日期',
  `bgqnr` VARCHAR(200) COMMENT '变更前内容',
  `bghnr` VARCHAR(200) COMMENT '变更后内容',
  KEY `CKTS_DJ_BGDJMX_DJXH_LRRQ` (`DJXH`, `LRRQ`),
  CONSTRAINT `PK_DJ_BGDJMX` PRIMARY KEY (`BGDJMXUUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口企业法人代表变更日志';

-- Creating table CKTS_DJ_NSRXX
-- Original Oracle primary-key constraint: PK_DJ_NSRXX (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_DJ_NSRXX` (
  `djxh` DECIMAL(20,0) NOT NULL,
  `zgswj_dm` CHAR(11),
  `nsrsbh` VARCHAR(20) NOT NULL COMMENT 'NVL(SHXYDM,NSRSBH)',
  `nsrmc` VARCHAR(300) NOT NULL,
  `zcdz` VARCHAR(300),
  `scjydz` VARCHAR(300),
  `jyfw` VARCHAR(3600),
  `fddbrxm` VARCHAR(150),
  `fddbrsfzjlx_dm` CHAR(3),
  `fddbrsfzjhm` VARCHAR(30),
  `fddbrgddh` VARCHAR(60),
  `fddbryddh` VARCHAR(60),
  `cwfzrxm` VARCHAR(150),
  `cwfzrsfzjzl_dm` CHAR(3),
  `cwfzrsfzjhm` VARCHAR(30),
  `bsrxm` VARCHAR(150),
  `bsrsfzjzl_dm` CHAR(3),
  `bsrsfzjhm` VARCHAR(30),
  `nsrzt_dm` CHAR(2) NOT NULL,
  `djrq` DATETIME NOT NULL,
  `ybnsrrdrq` DATETIME,
  `fzcrdrq` DATETIME,
  `zxrq` DATETIME,
  `lrrq` DATETIME NOT NULL,
  `xgrq` DATETIME COMMENT '增量同步用',
  KEY `IDX_CKTS_DJ_NSRXX_FDDBRSFZJHM` (`FDDBRSFZJHM`),
  KEY `IDX_CKTS_DJ_NSRXX_FDRXM` (`FDDBRXM`),
  KEY `IDX_CKTS_DJ_NSRXX_NSRMC` (`NSRMC`),
  KEY `IDX_CKTS_DJ_NSRXX_NSRSBH` (`NSRSBH`),
  KEY `IDX_CKTS_DJ_NSRXX_ZCDZ` (`ZCDZ`),
  KEY `IDX_CKTS_DJ_NSRXX_ZGSWJ` (`ZGSWJ_DM`),
  CONSTRAINT `PK_DJ_NSRXX` PRIMARY KEY (`DJXH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table CKTS_DM_CKYZS
-- Original Oracle primary-key constraint: PK_CKTS_DM_CKYZS (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_DM_CKYZS` (
  `jgfs_dm` CHAR(4) NOT NULL COMMENT '监管方式代码',
  `jgfsmc` VARCHAR(150) NOT NULL COMMENT '监管方式名称',
  CONSTRAINT `PK_CKTS_DM_CKYZS` PRIMARY KEY (`JGFS_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='省局货劳处给的出口应征税对应监管方式';

-- Creating table CKTS_LC_JCZBBL
-- Original Oracle primary-key constraint: PK_CKTS_LC_JCZBBL (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_LC_JCZBBL` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID||uuid',
  `sbywb_dm` VARCHAR(16),
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `lcslid` CHAR(32) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `glh` VARCHAR(30) COMMENT '关联号',
  `ytse_1` DECIMAL(18,6) COMMENT '应退税额',
  `ydnr` VARCHAR(3000) COMMENT '疑点内容',
  `zhshclyjlx_dm` CHAR(1) COMMENT '综合审核处理意见类型代码',
  `jczbblzt_dm` CHAR(1) COMMENT '解除暂不办理状态代码',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME COMMENT '录入日期',
  `xgrq` DATETIME COMMENT '修改日期',
  CONSTRAINT `PK_CKTS_LC_JCZBBL` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='解除暂不办理退税结果表';

-- Creating table CKTS_LC_SBXX
-- Original Oracle primary-key constraint: PK_CKTS_LC_SBXX (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_LC_SBXX` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID',
  `tsswjg_dm` CHAR(11) COMMENT '退税税务机关代码',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ckqygllb_dm` CHAR(1) COMMENT '出口企业管理类别代码',
  `wzhbz` CHAR(1) COMMENT '无纸化标志',
  `sbywb_dm` VARCHAR(16) COMMENT '申报业务表代码（根据流程税务事项转换）',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `lcslid_sb` CHAR(32) COMMENT '申报LCSLID（根据业务事项取ZLCLCSLID=LCSLID的ZLCLCSLID)',
  `zfbz` CHAR(1) COMMENT '作废标志',
  `zfr_dm` CHAR(11) COMMENT '作废人代码',
  `zfrq` DATETIME COMMENT '作废日期',
  `sbrq` DATETIME COMMENT '申报日期（从便捷退税获取）',
  `sb_xsemy` DECIMAL(18,2) COMMENT '申报销售额（美元）',
  `sb_xsermb` DECIMAL(18,2) COMMENT '申报销售额（人民币）',
  `sb_mdtse` DECIMAL(18,6) COMMENT '申报免抵退税额',
  `sb_zzstse` DECIMAL(18,6) COMMENT '申报增值税退税额',
  `sb_xfstse` DECIMAL(18,6) COMMENT '申报消费税退税额',
  `sb_mdse` DECIMAL(18,6) COMMENT '申报免抵税额',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `xgrq` DATETIME COMMENT '修改日期NVL(T.XGRQ,T.LRRQ)-增量用',
  `sjtb_bz` CHAR(1) DEFAULT '0' COMMENT '错误继续标志',
  `dysltzsj` DATETIME COMMENT '打印受理通知时间',
  `qdsj` DATETIME COMMENT '启动时间',
  `qdr_dm` CHAR(11) COMMENT '启动人代码',
  `htbz_1` CHAR(1) COMMENT '回退标志',
  KEY `IDX_CKTS_LC_SBXX_DQ` (`DJXH`, `QDSJ`),
  KEY `IDX_CKTS_LC_SBXX_DSSS` (`DJXH`, `SBYWB_DM`, `SSQ`, `SBPC`),
  KEY `IDX_CKTS_LC_SBXX_LCSLID` (`LCSLID_SB`),
  KEY `IDX_CKTS_LC_SBXX_SBRQ` (`SBRQ`),
  KEY `IDX_CKTS_LC_SBXX_TQ` (`TSSWJG_DM`, `QDSJ`),
  KEY `IDX_CKTS_LC_SBXX_TS` (`TSSWJG_DM`, `SBRQ`),
  CONSTRAINT `PK_CKTS_LC_SBXX` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='流程申报信息表';

-- Creating table CKTS_LC_SEHZXX
-- Original Oracle primary-key constraint: PK_CKTS_LC_SEHZXX (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_LC_SEHZXX` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID',
  `lcslid_fs` CHAR(32) COMMENT '复审LCSLID',
  `tsswjg_dm` CHAR(11) COMMENT '退税税务机关代码',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ywhzbuuid` VARCHAR(32) COMMENT '业务核准表UUID',
  `ywhzbid` VARCHAR(10) COMMENT '业务核准表ID',
  `xh` VARCHAR(10) COMMENT '项号',
  `sehzr_dm` CHAR(11) COMMENT '税额核准人代码',
  `sehzrq` DATETIME COMMENT '税额核准日期',
  `sehz_mdtse` DECIMAL(18,6) COMMENT '税额核准免抵退税额',
  `sehz_zzstse` DECIMAL(18,6) COMMENT '税额核准增值税退税额',
  `sehz_xfstse` DECIMAL(18,6) COMMENT '税额核准消费税退税额',
  `sehz_mdse` DECIMAL(18,6) COMMENT '税额核准免抵税额',
  `byhz_mdtse` DECIMAL(18,6) COMMENT '不予核准免抵退税额',
  `byhz_zzstse` DECIMAL(18,6) COMMENT '不予核准增值税退税额',
  `byhz_xfstse` DECIMAL(18,6) COMMENT '不予核准消费税退税额',
  `byhz_mdse` DECIMAL(18,6) COMMENT '不予核准免抵税额',
  `lrr_dm` CHAR(11) COMMENT '录入人代码，主要用于区分迁移数据',
  `zzssssrthsbh` VARCHAR(32) COMMENT '增值税税收收入退还书编号',
  `xfssssrthsbh` VARCHAR(32) COMMENT '消费税税收收入退还书编号',
  `gztktzsbh` VARCHAR(32) COMMENT '更正（调库）通知书编号',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `xgrq` DATETIME COMMENT '修改日期NVL(T.XGRQ,T.LRRQ)-增量用',
  `sjtb_bz` CHAR(1) DEFAULT '0' COMMENT '错误继续标志',
  `gkbl_mdtse` DECIMAL(18,6) COMMENT '国库办理免抵退税额',
  `gkbl_zzstse` DECIMAL(18,6) COMMENT '国库办理增值税退税额',
  `gkbl_xfstse` DECIMAL(18,6) COMMENT '国库办理消费税退税额',
  `gkbl_mdse` DECIMAL(18,6) COMMENT '国库办理免抵税额',
  `sbywb_dm` VARCHAR(16) COMMENT '申报业务表代码（根据流程税务事项转换）',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `ckqygllb_dm` CHAR(1) COMMENT '出口企业管理类别代码',
  `wzhbz` CHAR(1) COMMENT '无纸化标志',
  `lctjjc` CHAR(2) DEFAULT '10' COMMENT '流程统计级次，默认外贸企业',
  `cktmshwysfwlx_dm` CHAR(1) COMMENT '出口退（免）税货物应税服务类型代码',
  `snckzb` DECIMAL(18,6) COMMENT '上年出口占比',
  `xhrq_tk` DATETIME DEFAULT '2100-12-31 00:00:00' COMMENT '销号日期退库（增值税）',
  `xhrq_md` DATETIME DEFAULT '2100-12-31 00:00:00' COMMENT '销号日期免抵',
  `cktmsjhssswjgdm` CHAR(11) COMMENT '出口退（免）税计划所属税务机关代码',
  `mdtkssswjgdm` CHAR(11) COMMENT '免抵调库税务机关代码',
  `xhrq_xfs` DATETIME DEFAULT '2100-12-31 00:00:00' COMMENT '销号日期退库（消费税）',
  `kprq` DATETIME DEFAULT '2100-12-31 00:00:00' COMMENT '金三开票日期（退税）',
  KEY `IDX_CKTS_LC_SEHZXX_CTX1` (`CKTMSJHSSSWJGDM`, `XHRQ_TK`),
  KEY `IDX_CKTS_LC_SEHZXX_CTX2` (`MDTKSSSWJGDM`, `XHRQ_MD`),
  KEY `IDX_CKTS_LC_SEHZXX_CTX3` (`CKTMSJHSSSWJGDM`, `XHRQ_XFS`),
  KEY `IDX_CKTS_LC_SEHZXX_DS` (`DJXH`, `SEHZRQ`),
  KEY `IDX_CKTS_LC_SEHZXX_DSSS` (`DJXH`, `SBYWB_DM`, `SSQ`, `SBPC`),
  KEY `IDX_CKTS_LC_SEHZXX_LCSLIDFS` (`LCSLID_FS`),
  KEY `IDX_CKTS_LC_SEHZXX_TS` (`TSSWJG_DM`, `SEHZRQ`),
  KEY `IDX_CKTS_LC_SEHZXX_YX` (`YWHZBUUID`, `XH`),
  CONSTRAINT `PK_CKTS_LC_SEHZXX` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='税额核准信息表';

-- Creating table CKTS_LC_SHXX
-- Original Oracle primary-key constraint: PK_CKTS_LC_SHXX (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_LC_SHXX` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID',
  `cktmshwysfwlx_dm` CHAR(1) COMMENT '出口退（免）税货物应税服务类型代码 1:货物，2:服务',
  `tsswjg_dm` CHAR(11) COMMENT '退税税务机关代码',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ckqygllb_dm` CHAR(1) COMMENT '出口企业管理类别代码',
  `wzhbz` CHAR(1) COMMENT '无纸化标志',
  `sbywb_dm` VARCHAR(16) COMMENT '申报业务表代码（根据流程税务事项转换）',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `lcslid` CHAR(32) COMMENT '分流LCSLID',
  `lcslid_sb` CHAR(32) DEFAULT ' ' COMMENT '申报LCSLID',
  `lcslid_fs` CHAR(32) DEFAULT ' ' COMMENT '复审LCSLID',
  `zfbz` CHAR(1) COMMENT '作废标志',
  `zfr_dm` CHAR(11) COMMENT '作废人代码',
  `zfrq` DATETIME COMMENT '作废日期',
  `qdr_dm` CHAR(11) COMMENT '启动人代码',
  `qdsj` DATETIME COMMENT '启动时间',
  `ffbz` CHAR(1) COMMENT '发放标志',
  `ffr_dm` CHAR(11) COMMENT '发放人代码',
  `ffrq` DATETIME COMMENT '发放日期',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `lctjjc` CHAR(2) DEFAULT '00' COMMENT '流程统计级次，默认外贸企业',
  `lcjsrq` DATETIME DEFAULT '2100-12-31 00:00:00' COMMENT '流程结束日期，默认2100-12-31',
  `sb_xsemy` DECIMAL(18,2) COMMENT '申报销售额（美元）',
  `sb_xsermb` DECIMAL(18,2) COMMENT '申报销售额（人民币）',
  `sb_mdtse` DECIMAL(18,6) COMMENT '申报免抵退税额',
  `sb_zzstse` DECIMAL(18,6) COMMENT '申报增值税退税额',
  `sb_xfstse` DECIMAL(18,6) COMMENT '申报消费税退税额',
  `sb_mdse` DECIMAL(18,6) COMMENT '申报免抵税额',
  `by_mdtse` DECIMAL(18,6) COMMENT '不予退税免抵退税额',
  `by_zzstse` DECIMAL(18,6) COMMENT '不予退税增值税退税额',
  `by_xfstse` DECIMAL(18,6) COMMENT '不予退税消费税退税额',
  `by_mdse` DECIMAL(18,6) COMMENT '不予退税免抵税额',
  `zy_mdtse` DECIMAL(18,6) COMMENT '准予退税免抵退税额',
  `zy_zzstse` DECIMAL(18,6) COMMENT '准予退税增值税退税额',
  `zy_xfstse` DECIMAL(18,6) COMMENT '准予退税消费税退税额',
  `zy_mdse` DECIMAL(18,6) COMMENT '准予退税免抵税额',
  `zh_mdtse` DECIMAL(18,6) COMMENT '暂不办理免抵退税额',
  `zh_zzstse` DECIMAL(18,6) COMMENT '暂不办理增值税退税额',
  `zh_xfstse` DECIMAL(18,6) COMMENT '暂不办理消费税退税额',
  `zh_mdse` DECIMAL(18,6) COMMENT '暂不办理免抵税额',
  `snbl_mdtse` DECIMAL(18,6) COMMENT '截止上年办理免抵退税额',
  `snbl_zzstse` DECIMAL(18,6) COMMENT '截止上年办理增值税退税额',
  `snbl_xfstse` DECIMAL(18,6) COMMENT '截止上年办理消费税退税额',
  `snbl_mdse` DECIMAL(18,6) COMMENT '截止上年办理免抵税额',
  `sybl_mdtse` DECIMAL(18,6) COMMENT '截止上月办理免抵退税额',
  `sybl_zzstse` DECIMAL(18,6) COMMENT '截止上月办理增值税退税额',
  `sybl_xfstse` DECIMAL(18,6) COMMENT '截止上月办理消费税退税额',
  `sybl_mdse` DECIMAL(18,6) COMMENT '截止上月办理免抵税额',
  `xgrq` DATETIME COMMENT '修改日期NVL(T.XGRQ,T.LRRQ)-增量用',
  `sjtb_bz` CHAR(1) DEFAULT '0' COMMENT '错误继续标志',
  `byhz_mdtse` DECIMAL(18,6) COMMENT '不予核准免抵退税额',
  `byhz_zzstse` DECIMAL(18,6) COMMENT '不予核准增值税退税额',
  `byhz_xfstse` DECIMAL(18,6) COMMENT '不予核准消费税退税额',
  `byhz_mdse` DECIMAL(18,6) COMMENT '不予核准免抵税额',
  `zlclcslid` CHAR(32) COMMENT '主流程lcslid从金三获取，用于判断中间节点流程的结束状态',
  `lcswsx_dm` VARCHAR(16) COMMENT '流程税务事项代码，用于判断生产企业暂缓数据',
  `lastopdate` DATETIME DEFAULT '1900-01-01 00:00:00' COMMENT '流程结束日期，默认1900-01-01',
  `bybl_mdtse` DECIMAL(18,6) DEFAULT 0 COMMENT '不予办理免抵退税额',
  `bybl_zzstse` DECIMAL(18,6) DEFAULT 0 COMMENT '不予办理增值税退税额',
  `bybl_xfstse` DECIMAL(18,6) DEFAULT 0 COMMENT '不予办理消费税退税额',
  `bybl_mdse` DECIMAL(18,6) DEFAULT 0 COMMENT '不予办理免抵税额',
  KEY `IDX_CKTS_LC_SHXX_DQ` (`DJXH`, `QDSJ`),
  KEY `IDX_CKTS_LC_SHXX_DSSS` (`DJXH`, `SBYWB_DM`, `SSQ`, `SBPC`),
  KEY `IDX_CKTS_LC_SHXX_LCSLID` (`LCSLID`),
  KEY `IDX_CKTS_LC_SHXX_LCSLID_FS` (`LCSLID_FS`),
  KEY `IDX_CKTS_LC_SHXX_LCSLID_SB` (`LCSLID_SB`),
  KEY `IDX_CKTS_LC_SHXX_TLQL` (`TSSWJG_DM`, `LCJSRQ`, `QDSJ`, `LCTJJC`),
  KEY `IDX_CKTS_LC_SHXX_TQ` (`TSSWJG_DM`, `QDSJ`),
  CONSTRAINT `PK_CKTS_LC_SHXX` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='流程审核分流信息表';

-- Creating table CKTS_LC_SHXX_ZF
CREATE TABLE `CKTS_LC_SHXX_ZF` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID',
  `cktmshwysfwlx_dm` CHAR(1) COMMENT '出口退（免）税货物应税服务类型代码 1:货物，2:服务',
  `tsswjg_dm` CHAR(11) COMMENT '退税税务机关代码',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ckqygllb_dm` CHAR(1) COMMENT '出口企业管理类别代码',
  `wzhbz` CHAR(1) COMMENT '无纸化标志',
  `sbywb_dm` VARCHAR(16) COMMENT '申报业务表代码（根据流程税务事项转换）',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `lcslid` CHAR(32) COMMENT '分流LCSLID',
  `lcslid_sb` CHAR(32) COMMENT '申报LCSLID',
  `lcslid_fs` CHAR(32) COMMENT '复审LCSLID',
  `zfbz` CHAR(1) COMMENT '作废标志',
  `zfr_dm` CHAR(11) COMMENT '作废人代码',
  `zfrq` DATETIME COMMENT '作废日期',
  `qdr_dm` CHAR(11) COMMENT '启动人代码',
  `qdsj` DATETIME COMMENT '启动时间',
  `ffbz` CHAR(1) COMMENT '发放标志',
  `ffr_dm` CHAR(11) COMMENT '发放人代码',
  `ffrq` DATETIME COMMENT '发放日期',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `lctjjc` CHAR(2) DEFAULT '00' COMMENT '流程统计级次，默认外贸企业',
  `lcjsrq` DATETIME DEFAULT '2100-12-31 00:00:00' COMMENT '流程结束日期，默认2100-12-31',
  `sb_xsemy` DECIMAL(18,2) COMMENT '申报销售额（美元）',
  `sb_xsermb` DECIMAL(18,2) COMMENT '申报销售额（人民币）',
  `sb_mdtse` DECIMAL(18,6) COMMENT '申报免抵退税额',
  `sb_zzstse` DECIMAL(18,6) COMMENT '申报增值税退税额',
  `sb_xfstse` DECIMAL(18,6) COMMENT '申报消费税退税额',
  `sb_mdse` DECIMAL(18,6) COMMENT '申报免抵税额',
  `by_mdtse` DECIMAL(18,6) COMMENT '不予退税免抵退税额',
  `by_zzstse` DECIMAL(18,6) COMMENT '不予退税增值税退税额',
  `by_xfstse` DECIMAL(18,6) COMMENT '不予退税消费税退税额',
  `by_mdse` DECIMAL(18,6) COMMENT '不予退税免抵税额',
  `zy_mdtse` DECIMAL(18,6) COMMENT '准予退税免抵退税额',
  `zy_zzstse` DECIMAL(18,6) COMMENT '准予退税增值税退税额',
  `zy_xfstse` DECIMAL(18,6) COMMENT '准予退税消费税退税额',
  `zy_mdse` DECIMAL(18,6) COMMENT '准予退税免抵税额',
  `zh_mdtse` DECIMAL(18,6) COMMENT '暂不办理免抵退税额',
  `zh_zzstse` DECIMAL(18,6) COMMENT '暂不办理增值税退税额',
  `zh_xfstse` DECIMAL(18,6) COMMENT '暂不办理消费税退税额',
  `zh_mdse` DECIMAL(18,6) COMMENT '暂不办理免抵税额',
  `snbl_mdtse` DECIMAL(18,6) COMMENT '截止上年办理免抵退税额',
  `snbl_zzstse` DECIMAL(18,6) COMMENT '截止上年办理增值税退税额',
  `snbl_xfstse` DECIMAL(18,6) COMMENT '截止上年办理消费税退税额',
  `snbl_mdse` DECIMAL(18,6) COMMENT '截止上年办理免抵税额',
  `sybl_mdtse` DECIMAL(18,6) COMMENT '截止上月办理免抵退税额',
  `sybl_zzstse` DECIMAL(18,6) COMMENT '截止上月办理增值税退税额',
  `sybl_xfstse` DECIMAL(18,6) COMMENT '截止上月办理消费税退税额',
  `sybl_mdse` DECIMAL(18,6) COMMENT '截止上月办理免抵税额',
  `xgrq` DATETIME COMMENT '修改日期NVL(T.XGRQ,T.LRRQ)-增量用',
  `sjtb_bz` CHAR(1) DEFAULT '0' COMMENT '错误继续标志',
  `byhz_mdtse` DECIMAL(18,6) COMMENT '不予核准免抵退税额',
  `byhz_zzstse` DECIMAL(18,6) COMMENT '不予核准增值税退税额',
  `byhz_xfstse` DECIMAL(18,6) COMMENT '不予核准消费税退税额',
  `byhz_mdse` DECIMAL(18,6) COMMENT '不予核准免抵税额',
  `zlclcslid` CHAR(32) COMMENT '主流程lcslid从金三获取，用于判断中间节点流程的结束状态',
  `lcswsx_dm` VARCHAR(16) COMMENT '流程税务事项代码，用于判断生产企业暂缓数据',
  `lastopdate` DATETIME DEFAULT '1900-01-01 00:00:00' COMMENT '流程结束日期，默认1900-01-01',
  `bybl_mdtse` DECIMAL(18,6) DEFAULT 0 COMMENT '不予办理免抵退税额',
  `bybl_zzstse` DECIMAL(18,6) DEFAULT 0 COMMENT '不予办理增值税退税额',
  `bybl_xfstse` DECIMAL(18,6) DEFAULT 0 COMMENT '不予办理消费税退税额',
  `bybl_mdse` DECIMAL(18,6) DEFAULT 0 COMMENT '不予办理免抵税额',
  KEY `IDX_CKTS_LC_SHXX_ZF_DSS` (`DJXH`, `SSQ`, `SBPC`),
  KEY `IDX_CKTS_LC_SHXX_ZF_LCSLID` (`LCSLID`),
  KEY `IDX_CKTS_LC_SHXX_ZF_LCSLID_FS` (`LCSLID_FS`),
  KEY `IDX_CKTS_LC_SHXX_ZF_UUID` (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='流程审核分流信息表';

-- Creating table CKTS_LC_SHYDDCL
-- Original Oracle primary-key constraint: PK_CKTS_LC_SHYDDCL (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_LC_SHYDDCL` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID',
  `sbywb_dm` VARCHAR(16) COMMENT '申报业务表代码',
  `tsswjg_dm` CHAR(11) COMMENT '退税税务机关代码',
  `lcslid` CHAR(32) COMMENT 'LCSLID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `glh` VARCHAR(30) COMMENT '关联号',
  `mdtse` DECIMAL(18,6) COMMENT '免（抵）退税额',
  `ydnr` VARCHAR(3000) COMMENT '疑点内容',
  `zhshclyjlx_dm` CHAR(1) COMMENT '综合审核处理意见类型代码',
  `lrr_dm` CHAR(11),
  `lrrq` DATETIME,
  `xgrq` DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `PK_CKTS_LC_SHYDDCL` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='审核疑点业务处理过程表';

-- Creating table CKTS_LC_SHYDDCL_SHXT
-- Original Oracle primary-key constraint: PK_CKTS_LC_SHYDDCL_SHXT (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_LC_SHYDDCL_SHXT` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID',
  `sbywb_dm` VARCHAR(16) COMMENT '申报业务表代码',
  `tsswjg_dm` CHAR(11) COMMENT '退税税务机关代码',
  `lcslid` CHAR(32) COMMENT 'LCSLID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `glh` VARCHAR(30) COMMENT '关联号',
  `mdtse` DECIMAL(18,6) COMMENT '免（抵）退税额',
  `ydnr` VARCHAR(3000) COMMENT '疑点内容',
  `zhshclyjlx_dm` CHAR(1) COMMENT '综合审核处理意见类型代码',
  `lrr_dm` CHAR(11),
  `lrrq` DATETIME,
  `xgrq` DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `PK_CKTS_LC_SHYDDCL_SHXT` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='审核疑点业务处理过程表';

-- Creating table CKTS_LC_YWHZXX
-- Original Oracle primary-key constraint: PK_CKTS_LC_YWHZXX (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_LC_YWHZXX` (
  `ywhzbuuid` VARCHAR(32) NOT NULL COMMENT '业务核准表UUID',
  `tsswjg_dm` CHAR(11) COMMENT '退税税务机关代码',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ckqygllb_dm` CHAR(1) COMMENT '出口企业管理类别代码',
  `wzhbz` CHAR(1) COMMENT '无纸化标志',
  `sbywb_dm` VARCHAR(16) COMMENT '申报业务表代码（根据流程税务事项转换）',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `lcslid_fs` CHAR(32) COMMENT '复审LCSLID',
  `cktmshwysfwlx_dm` CHAR(1) COMMENT '出口退（免）税货物应税服务类型代码',
  `fsr_dm` CHAR(11) COMMENT '复审人代码（LRR_DM）',
  `fsrq` DATETIME COMMENT '复审日期（LRRQ）',
  `fs_mdtse` DECIMAL(18,6) COMMENT '复审免抵退税额',
  `fs_zzstse` DECIMAL(18,6) COMMENT '复审增值税退税额',
  `fs_xfstse` DECIMAL(18,6) COMMENT '复审消费税退税额',
  `fs_mdse` DECIMAL(18,6) COMMENT '复审免抵税额',
  `ywhzwcbz` CHAR(1) COMMENT '业务核准完成标志',
  `ywhzr_dm` CHAR(11) COMMENT '业务核准人代码',
  `ywhzrq` DATETIME COMMENT '业务核准时间',
  `sehzwcbz` CHAR(1) COMMENT '税额核准完成标志',
  `zk_zzstse` DECIMAL(18,6) COMMENT '暂扣增值税退税额',
  `zk_xfstse` DECIMAL(18,6) COMMENT '暂扣消费税退税额',
  `wtdbtsscqynsrsbh` VARCHAR(20) COMMENT '委托代办退税生产企业纳税人识别号',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `xgrq` DATETIME COMMENT '修改日期NVL(T.XGRQ,T.LRRQ)-增量用',
  `sjtb_bz` CHAR(1) DEFAULT '0' COMMENT '错误继续标志',
  `lctjjc` CHAR(2) DEFAULT '00' COMMENT '流程统计级次，默认外贸企业',
  `bz` VARCHAR(100) COMMENT '备注，用于标示没有审核信息的核准信息',
  `tbyy_dm` CHAR(3) COMMENT '退补原因代码',
  KEY `IDX_CKTS_LC_YWHZXX_DSSS` (`DJXH`, `SBYWB_DM`, `SSQ`, `SBPC`),
  KEY `IDX_CKTS_LC_YWHZXX_LCSLIDFS` (`LCSLID_FS`),
  KEY `IDX_CKTS_LC_YWHZXX_TF` (`TSSWJG_DM`, `FSRQ`),
  CONSTRAINT `PK_CKTS_LC_YWHZXX` PRIMARY KEY (`YWHZBUUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='业务核准信息表';

-- Creating table CKTS_LOG_DEALDATA
CREATE TABLE `CKTS_LOG_DEALDATA` (
  `czsj` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `czjl` VARCHAR(300),
  `sbyy` VARCHAR(2000)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table CKTS_OTHER_SXPSAJ
-- Original Oracle primary-key constraint: PK_CKTS_OTHER_SXPSAJ (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_OTHER_SXPSAJ` (
  `uuid` VARCHAR(32) NOT NULL,
  `swjgdm` VARCHAR(11) COMMENT '税务机关代码',
  `cpcode` VARCHAR(32) COMMENT '审核系统企业标识',
  `nsrdjno` VARCHAR(32) COMMENT '纳税人识别号',
  `shxyno` VARCHAR(20) COMMENT '社会信用代码',
  `qyname` VARCHAR(200) COMMENT '企业名称',
  `ajly_name` VARCHAR(100) COMMENT '案源',
  `ajly_summary` VARCHAR(4000) COMMENT '案源信息摘要',
  `ajly_reason` VARCHAR(4000) COMMENT '主要案情',
  `sasp_code` VARCHAR(20) COMMENT '涉案出口商品编码',
  `sasp_name` VARCHAR(254) COMMENT '涉案出口商品名称',
  `usd_amt` DECIMAL(24,4) COMMENT '涉案金额（万美元）',
  `mdts_amt` DECIMAL(24,4) COMMENT '出口退（免）税额（万元）',
  `ts_amt` DECIMAL(24,4) COMMENT '退税额（万元）',
  `md_amt` DECIMAL(24,4) COMMENT '免抵额（万元）',
  `ysjc_swcode` VARCHAR(11) COMMENT '移送单位代码',
  `ysjc_swname` VARCHAR(100) COMMENT '移送单位名称',
  `ysjc_date` DATETIME COMMENT '移送时间',
  `ysjc_no` VARCHAR(20) COMMENT '移送书文号',
  `ysjc_user` VARCHAR(30) COMMENT '移送人',
  `jcjs_swcode` VARCHAR(11) COMMENT '接收单位代码',
  `jcjs_swname` VARCHAR(100) COMMENT '接收单位名称',
  `jcjs_date` DATETIME COMMENT '接收时间',
  `jcjs_user` VARCHAR(30) COMMENT '接收人',
  `jcjs_flag` VARCHAR(2) COMMENT '不予接收标识',
  `jcla_flag` VARCHAR(2) COMMENT '稽查立案标识',
  `jcla_date` DATETIME COMMENT '稽查立案时间',
  `jcja_flag` VARCHAR(2) COMMENT '稽查结案标识',
  `jcja_date` DATETIME COMMENT '稽查结案时间',
  `remark` VARCHAR(1000) COMMENT '备注',
  CONSTRAINT `PK_CKTS_OTHER_SXPSAJ` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='管理系统_报表_审核系统_涉嫌骗税信息';

-- Creating table CKTS_SB_FZC_SBMX
-- Original Oracle primary-key constraint: PK_CKTS_SB_FZC_SBMX (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_SB_FZC_SBMX` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID',
  `lcslid` CHAR(32) COMMENT '分流LCSLID',
  `tsswjg_dm` CHAR(11) COMMENT '退税税务机关代码',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) DEFAULT '001' COMMENT '申报批次',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `dlckhwzmhm` VARCHAR(20) COMMENT '代理出口货物证明号码',
  `cksl` DECIMAL(16,4) COMMENT '出口数量',
  `cktmspzlx_dm` CHAR(2) COMMENT '出口退(免)税凭证类型代码',
  `xfspzh` VARCHAR(40) COMMENT '消费税凭证号',
  `kprq` DATETIME COMMENT '开票日期',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `sbhgspmc` VARCHAR(500) COMMENT '申报海关商品名称||申报海关商品名称',
  `hgjldwmc` VARCHAR(75) COMMENT '海关计量单位名称',
  `sl` DECIMAL(16,4) COMMENT '数量',
  `zssl` DECIMAL(16,6) COMMENT '征税税率',
  `jsje` DECIMAL(18,2) COMMENT '计税金额',
  `se` DECIMAL(18,6) COMMENT '税额',
  `xfstse` DECIMAL(18,6) COMMENT '消费税退税额',
  `cktmsywlxdmjh` VARCHAR(30) COMMENT '出口退（免）税业务类型代码集合',
  `cktmsywlxmcjh` VARCHAR(75) COMMENT '出口退（免）税业务类型名称集合',
  `chbz` CHAR(1) DEFAULT 'N' COMMENT '撤回标志',
  `bytsbz` CHAR(1) COMMENT '不予退税标志',
  `byblbz` CHAR(1) COMMENT '不予办理标志',
  `sjly` CHAR(1) COMMENT '1-GC表  2-JG表',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `sbrq` DATETIME COMMENT '申报日期',
  `xgrq` DATETIME COMMENT '修改日期NVL(T.XGRQ,T.LRRQ)-增量用',
  `sjtb_bz` CHAR(1) DEFAULT '0' COMMENT '错误继续标志',
  `zbblbz` CHAR(1) DEFAULT 'N' COMMENT '暂不办理标志',
  KEY `IDX_CKTS_SB_FZC_SBMX_DC` (`DJXH`, `CKBGDH`),
  KEY `IDX_CKTS_SB_FZC_SBMX_DSSS` (`DJXH`, `SSQ`, `SBPC`, `SBXH`),
  KEY `IDX_CKTS_SB_FZC_SBMX_LCSLID` (`LCSLID`),
  CONSTRAINT `PK_CKTS_SB_FZC_SBMX` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口非自产货物退消费税申报表';

-- Creating table CKTS_SB_GJ_SBMX
-- Original Oracle primary-key constraint: PK_CKTS_SB_GJ_SBMX (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_SB_GJ_SBMX` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID',
  `lcslid` CHAR(32) COMMENT '分流LCSLID',
  `tsswjg_dm` CHAR(11) COMMENT '退税税务机关代码',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) DEFAULT '001' COMMENT '申报批次（默认001）',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `gjzyhwmc` VARCHAR(500) COMMENT '购进自用货物名称',
  `jhpzzl_dm` CHAR(1) COMMENT '进货凭证种类代码',
  `jhpzh` VARCHAR(75) COMMENT '进货凭证号',
  `kprq` DATETIME COMMENT '开票日期',
  `ghfnsrsbh_1` VARCHAR(20) COMMENT '供货方纳税人识别号',
  `sl` DECIMAL(16,4) COMMENT '数量',
  `hgjldwmc` VARCHAR(75) COMMENT '海关计量单位名称',
  `dj` DECIMAL(18,2) COMMENT '单价',
  `jsje` DECIMAL(18,2) COMMENT '计税金额',
  `zssl` DECIMAL(16,6) COMMENT '征税税率',
  `se` DECIMAL(18,6) COMMENT '税额',
  `tse` DECIMAL(18,6) COMMENT '退税额',
  `fkpzhm` VARCHAR(40) COMMENT '付款凭证号码',
  `cktmsywlxdmjh` VARCHAR(30) COMMENT '出口退（免）税业务类型代码集合',
  `cktmsywlxmcjh` VARCHAR(75) COMMENT '出口退（免）税业务类型名称集合',
  `chbz` CHAR(1) DEFAULT 'N' COMMENT '撤回标志',
  `bytsbz` CHAR(1) COMMENT '不予退税标志',
  `byblbz` CHAR(1) COMMENT '不予办理标志',
  `sjly` CHAR(1) COMMENT '1-GC表  2-JG表',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `sbrq` DATETIME COMMENT '申报日期',
  `xgrq` DATETIME COMMENT '修改日期NVL(T.XGRQ,T.LRRQ)-增量用',
  `sjtb_bz` CHAR(1) DEFAULT '0' COMMENT '错误继续标志',
  `zbblbz` CHAR(1) DEFAULT 'N' COMMENT '暂不办理标志',
  KEY `IDX_CKTS_SB_GJ_SBMX_DSSS` (`DJXH`, `SSQ`, `SBPC`, `SBXH`),
  KEY `IDX_CKTS_SB_GJ_SBMX_LCSLID` (`LCSLID`),
  CONSTRAINT `PK_CKTS_SB_GJ_SBMX` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='购进自用货物退税申报结果表';

-- Creating table CKTS_SB_MDT_CKMX
-- Original Oracle primary-key constraint: PK_CKTS_SB_MDT_CKMX (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_SB_MDT_CKMX` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID',
  `lcslid` CHAR(32) COMMENT '分流LCSLID',
  `tsswjg_dm` CHAR(11) COMMENT '退税税务机关代码',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) DEFAULT '001' COMMENT '申报批次（默认001）',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `ckfph` VARCHAR(30) COMMENT '出口发票号码',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `dlckhwzmhm` VARCHAR(20) COMMENT '代理出口货物证明号码',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `sbhgspmc` VARCHAR(500) COMMENT '申报海关商品名称',
  `hgjldwmc` VARCHAR(75) COMMENT '海关计量单位名称',
  `cksl` DECIMAL(16,4) COMMENT '出口数量',
  `mylaj` DECIMAL(18,2) COMMENT '美元离岸价',
  `rmblaj` DECIMAL(18,2) COMMENT '人民币离岸价',
  `zssl` DECIMAL(16,6) COMMENT '征税税率',
  `tsl` DECIMAL(16,6) COMMENT '退税率',
  `jljgszch` VARCHAR(20) COMMENT '进料加工手账册号',
  `tzhjhfpl` DECIMAL(10,6) COMMENT '进料加工计划分配率',
  `jljgbsjkljzcjsjg` DECIMAL(18,2) COMMENT '进料加工保税料件计税价格',
  `gngjmsycljg` DECIMAL(18,2) COMMENT '国内免税原材料计税价格',
  `mdtsbdmzhdkse` DECIMAL(18,6) COMMENT '免抵退申报不得免征和抵扣税额',
  `mdtse` DECIMAL(18,6) COMMENT '免抵退税额',
  `cktmsywlxdmjh` VARCHAR(30) COMMENT '业务代码',
  `cktmsywlxmcjh` VARCHAR(75) COMMENT '业务类型',
  `chbz` CHAR(1) DEFAULT 'N' COMMENT '撤回标志',
  `zhbz_1` CHAR(1) DEFAULT 'N' COMMENT '暂缓标志',
  `bytsbz` CHAR(1) DEFAULT 'N' COMMENT '不予退税标志',
  `bytsny` CHAR(6) COMMENT '不予退税年月',
  `byblbz` CHAR(1) DEFAULT 'N' COMMENT '不予办理标志',
  `byblny` VARCHAR(6) COMMENT '不予办理年月',
  `zbblbz` CHAR(1) DEFAULT 'N' COMMENT '暂不办理标志',
  `zbblny` VARCHAR(6) COMMENT '暂不办理年月',
  `zzjczbblzyny` VARCHAR(6) COMMENT '最终解除暂不办理年月',
  `mdtsny` CHAR(6) COMMENT '免抵退税年月',
  `lcslid_sb` CHAR(32) DEFAULT ' ' COMMENT '申报LCSLID',
  `lcslid_fs` CHAR(32) DEFAULT ' ' COMMENT '复审LCSLID',
  `tdcode` VARCHAR(4) COMMENT '海关监管方式（关联报关单获取）',
  `hgcode` VARCHAR(4) COMMENT '申报口岸（关联报关单获取）',
  `hzdwdqdm` VARCHAR(5) COMMENT '货主单位地区代码（关联报关单获取）',
  `sbdwdm` VARCHAR(20) COMMENT '申报单位代码（关联报关单获取）',
  `gbcode` VARCHAR(3) COMMENT '国别代码（关联报关单获取）',
  `zzmdg` VARCHAR(3) COMMENT '最终目的国（关联报关单获取）',
  `zyg` VARCHAR(4) COMMENT '指运港（关联报关单获取）',
  `sjly` CHAR(1) COMMENT '1-GC表  2-JG表',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `sbrq` DATETIME COMMENT '申报日期',
  `xgrq` DATETIME COMMENT '修改日期NVL(T.XGRQ,T.LRRQ)-增量用',
  `sjtb_bz` CHAR(1) DEFAULT '0' COMMENT '错误继续标志',
  `fsrq` DATETIME COMMENT '复审日期',
  KEY `IDX_CKTS_SB_MDT_CKMX_DC` (`DJXH`, `CKBGDH`),
  KEY `IDX_CKTS_SB_MDT_CKMX_DSSS` (`DJXH`, `SSQ`, `SBPC`, `SBXH`),
  KEY `IDX_CKTS_SB_MDT_CKMX_LCSLID` (`LCSLID`),
  KEY `IDX_CKTS_SB_MDT_CKMX_LCSLID_FS` (`LCSLID_FS`),
  KEY `IDX_CKTS_SB_MDT_CKMX_LCSLID_SB` (`LCSLID_SB`),
  KEY `IDX_CKTS_SB_MDT_CKMX_SC` (`SBRQ`, `CKSP_DM`),
  KEY `IDX_CKTS_SB_MDT_CKMX_SJ` (`SJTB_SJ`),
  KEY `IDX_CKTS_SB_MDT_CKMX_STS` (`SJLY`, `TDCODE`, `SJTB_SJ`),
  KEY `IDX_CKTS_SB_MDT_CKMX_TC` (`TSSWJG_DM`, `CKRQ_1`),
  KEY `IDX_CKTS_SB_MDT_CKMX_TF` (`TSSWJG_DM`, `FSRQ`),
  KEY `IDX_CKTS_SB_MDT_CKMX_TST` (`TSSWJG_DM`, `SBRQ`),
  CONSTRAINT `PK_CKTS_SB_MDT_CKMX` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='免抵退出口货物明细表';
-- MySQL requires every PRIMARY/UNIQUE key to contain all partition columns.
-- To preserve the original keys and their uniqueness, this table is not partitioned.
-- Original Oracle partition definition (retained for reference):
-- partition by range (TSSWJG_DM)
-- (
--   partition P_13300000000 values less than ('13300000000')
--     tablespace TL_TSSH,
--   partition P_13301000000 values less than ('13301000000')
--     tablespace TL_TSSH,
--   partition P_13303000000 values less than ('13303000000')
--     tablespace TL_TSSH,
--   partition P_13304000000 values less than ('13304000000')
--     tablespace TL_TSSH,
--   partition P_13305000000 values less than ('13305000000')
--     tablespace TL_TSSH,
--   partition P_13306000000 values less than ('13306000000')
--     tablespace TL_TSSH,
--   partition P_13307000000 values less than ('13307000000')
--     tablespace TL_TSSH,
--   partition P_13308000000 values less than ('13308000000')
--     tablespace TL_TSSH,
--   partition P_13309000000 values less than ('13309000000')
--     tablespace TL_TSSH,
--   partition P_13310000000 values less than ('13310000000')
--     tablespace TL_TSSH,
--   partition P_13311000000 values less than ('13311000000')
--     tablespace TL_TSSH,
--   partition P_MAXVALUE values less than (MAXVALUE)
--     tablespace TL_TSSH
-- )

-- Creating table CKTS_SB_MDT_GJYS
-- Original Oracle primary-key constraint: PK_CKTS_SB_MDT_GJYS (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_SB_MDT_GJYS` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID',
  `lcslid` CHAR(32) COMMENT '分流LCSLID',
  `tsswjg_dm` CHAR(11) COMMENT '退税税务机关代码',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) DEFAULT '001' COMMENT '申报批次（默认001）',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `ckfph` VARCHAR(30) COMMENT '出口发票号码',
  `hth` VARCHAR(60) COMMENT '合同号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `ysfw_dm` VARCHAR(20) COMMENT '应税服务代码',
  `ysfwmc` VARCHAR(500) COMMENT '应税服务名称',
  `ysfwyyemy` DECIMAL(18,2) COMMENT '应税服务营业额（美元）',
  `ysfwyyermb` DECIMAL(18,2) COMMENT '应税服务营业额（人民币）',
  `zssl` DECIMAL(16,6) COMMENT '征税税率',
  `tsl` DECIMAL(16,6) COMMENT '退税率',
  `mdtsbdmzhdkse` DECIMAL(18,6) COMMENT '免抵退申报不得免征和抵扣税额',
  `mdtse` DECIMAL(18,6) COMMENT '免抵退税额',
  `chbz` CHAR(1) DEFAULT 'N' COMMENT '撤回标志',
  `zhbz_1` CHAR(1) DEFAULT 'N' COMMENT '暂缓标志',
  `bytsbz` CHAR(1) DEFAULT 'N' COMMENT '不予退税标志',
  `bytsny` CHAR(6) COMMENT '不予退税年月',
  `byblbz` CHAR(1) DEFAULT 'N' COMMENT '不予办理标志',
  `byblny` VARCHAR(6) COMMENT '不予办理年月',
  `zbblbz` CHAR(1) DEFAULT 'N' COMMENT '暂不办理标志',
  `zbblny` VARCHAR(6) COMMENT '暂不办理年月',
  `zzjczbblzyny` VARCHAR(6) COMMENT '最终解除暂不办理年月',
  `mdtsny` CHAR(6) COMMENT '免抵退税年月',
  `lcslid_sb` CHAR(32) DEFAULT ' ' COMMENT '申报LCSLID',
  `lcslid_fs` CHAR(32) DEFAULT ' ' COMMENT '复审LCSLID',
  `sjly` CHAR(1) COMMENT '1-GC表  2-JG表',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `sbrq` DATETIME COMMENT '申报日期',
  `xgrq` DATETIME COMMENT '修改日期NVL(T.XGRQ,T.LRRQ)-增量用',
  `sjtb_bz` CHAR(1) DEFAULT '0' COMMENT '错误继续标志',
  KEY `IDX_CKTS_SB_MDT_GJYS_DSSS` (`DJXH`, `SSQ`, `SBPC`, `SBXH`),
  KEY `IDX_CKTS_SB_MDT_GJYS_LCSLID` (`LCSLID`),
  KEY `IDX_CKTS_SB_MDT_GJYS_LCSLID_FS` (`LCSLID_FS`),
  KEY `IDX_CKTS_SB_MDT_GJYS_LCSLID_SB` (`LCSLID_SB`),
  CONSTRAINT `PK_CKTS_SB_MDT_GJYS` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='免抵退国际运输明细表';

-- Creating table CKTS_SB_MDT_SBDSHZ
-- Original Oracle primary-key constraint: PK_CKTS_SB_MDT_SBDSHZ (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_SB_MDT_SBDSHZ` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID||uuid',
  `lcslid` CHAR(32) COMMENT '流程实例ID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
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
  `bdmzdkseynsbce` DECIMAL(18,6) COMMENT '不得免征抵扣税额与纳税表差额',
  `lrr_dm` CHAR(11) COMMENT '录入人代码',
  `lrrq` DATETIME NOT NULL COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `sjgsdq` CHAR(11) NOT NULL COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `nsbbcyjsssqq` DATETIME COMMENT '纳税报表参与计算所属期起',
  `nsbbcyjsssqz` DATETIME COMMENT '纳税报表参与计算所属期止',
  `ytsehw` DECIMAL(18,6) COMMENT '应退税额货物',
  `ytselw` DECIMAL(18,6) COMMENT '应退税额劳务',
  `mdsehw` DECIMAL(18,6) COMMENT '免抵税额货物',
  `mdselw` DECIMAL(18,6) COMMENT '免抵税额劳务',
  `qqzymdtse` DECIMAL(18,6) COMMENT '前期准予免抵退税额',
  `qqbymdtse` DECIMAL(18,6) COMMENT '前期不予免抵退税额',
  `qqzbblmdtse` DECIMAL(18,6) COMMENT '前期暂不办理免抵退税额',
  `ysfwyyezfgfsdnsrjk` DECIMAL(18,2) COMMENT '应税服务营业额支付给非试点纳税人价款',
  `jsqmldse` DECIMAL(18,6) COMMENT '计算期末留抵税额',
  `dqbdmzhdkdje` DECIMAL(18,6) DEFAULT 0 COMMENT '当期不得免征和抵扣抵减额',
  `jzbmzdkdje` DECIMAL(18,2) COMMENT '结转不免征抵扣抵减额',
  `jbr` VARCHAR(150) COMMENT '经办人',
  `jbrzjhm` VARCHAR(40) COMMENT '经办人身份证件号码',
  `dljgtyshxydm` VARCHAR(20) COMMENT '代理机构统一社会信用代码||代理机构统一社会信用代码',
  `jzxqmdtsbdmzhdksedje` DECIMAL(18,6) COMMENT '结转下期免抵退税不得免征和抵扣税额抵减额',
  `ytzbdmzhdkseyzzsnssbbce` DECIMAL(18,6) DEFAULT 0 COMMENT '进料加工核销应调整不得免征和抵扣税额与增值税纳税申报表差额',
  `syjljghxytzbdmzhdkseysbbce` DECIMAL(18,6) DEFAULT 0 COMMENT '使用进料加工核销应调整不得免征和抵扣税额与增值税纳税申报表差额',
  KEY `IDX_CKTS_MDT_SBDSHZ_JG_DS` (`DJXH`, `SSQ`),
  KEY `IDX_CKTS_MDT_SBDSHZ_JG_LCSLID` (`LCSLID`),
  CONSTRAINT `PK_CKTS_SB_MDT_SBDSHZ` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='免抵退税申报对审汇总表(结果表)';

-- Creating table CKTS_SB_MDT_YFSJ
-- Original Oracle primary-key constraint: PK_CKTS_SB_MDT_YFSJ (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_SB_MDT_YFSJ` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID',
  `lcslid` CHAR(32) COMMENT '分流LCSLID',
  `tsswjg_dm` CHAR(11) COMMENT '退税税务机关代码',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) DEFAULT '001' COMMENT '申报批次（默认001）',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `ckfph` VARCHAR(30) COMMENT '出口发票号码',
  `hth` VARCHAR(60) COMMENT '合同号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `ysfw_dm` VARCHAR(20) COMMENT '应税服务代码',
  `ysfwmc` VARCHAR(500) COMMENT '应税服务名称',
  `ysfwyyemy` DECIMAL(18,2) COMMENT '应税服务营业额（美元）',
  `ysfwyyermb` DECIMAL(18,2) COMMENT '应税服务营业额（人民币）',
  `zssl` DECIMAL(16,6) COMMENT '征税税率',
  `tsl` DECIMAL(16,6) COMMENT '退税率',
  `mdtsbdmzhdkse` DECIMAL(18,6) COMMENT '免抵退申报不得免征和抵扣税额',
  `mdtse` DECIMAL(18,6) COMMENT '免抵退税额',
  `cktmsywlxdmjh` VARCHAR(30) COMMENT '出口退（免）税业务类型代码集合',
  `cktmsywlxmcjh` VARCHAR(75) COMMENT '出口退（免）税业务类型名称集合',
  `chbz` CHAR(1) DEFAULT 'N' COMMENT '撤回标志',
  `zhbz_1` CHAR(1) DEFAULT 'N' COMMENT '暂缓标志',
  `bytsbz` CHAR(1) DEFAULT 'N' COMMENT '不予退税标志',
  `bytsny` CHAR(6) COMMENT '不予退税年月',
  `byblbz` CHAR(1) DEFAULT 'N' COMMENT '不予办理标志',
  `byblny` VARCHAR(6) COMMENT '不予办理年月',
  `zbblbz` CHAR(1) DEFAULT 'N' COMMENT '暂不办理标志',
  `zbblny` VARCHAR(6) COMMENT '暂不办理年月',
  `zzjczbblzyny` VARCHAR(6) COMMENT '最终解除暂不办理年月',
  `mdtsny` CHAR(6) COMMENT '免抵退税年月',
  `lcslid_sb` CHAR(32) DEFAULT ' ' COMMENT '申报LCSLID',
  `lcslid_fs` CHAR(32) DEFAULT ' ' COMMENT '复审LCSLID',
  `sjly` CHAR(1) COMMENT '1-GC表  2-JG表',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `sbrq` DATETIME COMMENT '申报日期',
  `xgrq` DATETIME COMMENT '修改日期NVL(T.XGRQ,T.LRRQ)-增量用',
  `sjtb_bz` CHAR(1) DEFAULT '0' COMMENT '错误继续标志',
  KEY `IDX_CKTS_SB_MDT_YFSJ_DSSS` (`DJXH`, `SSQ`, `SBPC`, `SBXH`),
  KEY `IDX_CKTS_SB_MDT_YFSJ_LCSLID` (`LCSLID`),
  KEY `IDX_CKTS_SB_MDT_YFSJ_LCSLID_FS` (`LCSLID_FS`),
  KEY `IDX_CKTS_SB_MDT_YFSJ_LCSLID_SB` (`LCSLID_SB`),
  CONSTRAINT `PK_CKTS_SB_MDT_YFSJ` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='免抵退研发设计明细表';

-- Creating table CKTS_SB_MTS_CKMX
-- Original Oracle primary-key constraint: PK_CKTS_SB_MTS_CKMX (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_SB_MTS_CKMX` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID',
  `lcslid` CHAR(32) COMMENT '分流LCSLID',
  `tsswjg_dm` CHAR(11) COMMENT '退税税务机关代码',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `glh` VARCHAR(30) COMMENT '关联号',
  `ckfph` VARCHAR(30) COMMENT '出口发票号码',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `dlckhwzmhm` VARCHAR(20) COMMENT '代理出口货物证明号码',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `sbhgspmc` VARCHAR(500) COMMENT '申报海关商品名称',
  `hgjldwmc` VARCHAR(75) COMMENT '海关计量单位名称',
  `cksl` DECIMAL(16,4) COMMENT '出口数量',
  `mylaj` DECIMAL(18,2) COMMENT '美元离岸价',
  `cktmsywlxdmjh` VARCHAR(30) COMMENT '业务代码',
  `cktmsywlxmcjh` VARCHAR(75) COMMENT '业务类型',
  `chbz` CHAR(1) DEFAULT 'N' COMMENT '撤回标志',
  `bytsbz` CHAR(1) DEFAULT 'N' COMMENT '不予退税标志',
  `byblbz` CHAR(1) DEFAULT 'N' COMMENT '不予办理标志',
  `lcslid_sb` CHAR(32) DEFAULT ' ' COMMENT '申报LCSLID',
  `tdcode` VARCHAR(4) COMMENT '海关监管方式（关联报关单获取）',
  `hgcode` VARCHAR(4) COMMENT '申报口岸（关联报关单获取）',
  `hzdwdqdm` VARCHAR(5) COMMENT '货主单位地区代码（关联报关单获取）',
  `sbdwdm` VARCHAR(20) COMMENT '申报单位代码（关联报关单获取）',
  `gbcode` VARCHAR(3) COMMENT '国别代码（关联报关单获取）',
  `zzmdg` VARCHAR(3) COMMENT '最终目的国（关联报关单获取）',
  `zyg` VARCHAR(4) COMMENT '指运港（关联报关单获取）',
  `sjly` CHAR(1) COMMENT '1-GC表  2-JG表',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `tse` DECIMAL(18,2) COMMENT '退税额（从进货关联号汇总）',
  `sbrq` DATETIME COMMENT '申报日期',
  `mtsbz` CHAR(1) DEFAULT 'N' COMMENT '免退税标志',
  `zbblbz` CHAR(1) DEFAULT 'N' COMMENT '暂不办理标志',
  `xgrq` DATETIME COMMENT '修改日期NVL(T.XGRQ,T.LRRQ)-增量用',
  `sjtb_bz` CHAR(1) DEFAULT '0' COMMENT '错误继续标志',
  `jsje` DECIMAL(18,2) COMMENT '进货金额',
  `fsrq` DATETIME COMMENT '复审日期',
  `tsl` DECIMAL(16,6) COMMENT '退税率',
  KEY `IDX_CKTS_SB_MTS_CKMX_DC` (`DJXH`, `CKBGDH`),
  KEY `IDX_CKTS_SB_MTS_CKMX_DGCL` (`DJXH`, `GLH`, `CKSP_DM`, `LCSLID`),
  KEY `IDX_CKTS_SB_MTS_CKMX_DSSS` (`DJXH`, `SSQ`, `SBPC`, `SBXH`),
  KEY `IDX_CKTS_SB_MTS_CKMX_LCSLID` (`LCSLID`),
  KEY `IDX_CKTS_SB_MTS_CKMX_LCSLID_SB` (`LCSLID_SB`),
  KEY `IDX_CKTS_SB_MTS_CKMX_SC` (`SBRQ`, `CKSP_DM`),
  KEY `IDX_CKTS_SB_MTS_CKMX_SJ` (`SJTB_SJ`),
  KEY `IDX_CKTS_SB_MTS_CKMX_STS` (`SJLY`, `TDCODE`, `SJTB_SJ`),
  KEY `IDX_CKTS_SB_MTS_CKMX_TC` (`TSSWJG_DM`, `CKRQ_1`),
  KEY `IDX_CKTS_SB_MTS_CKMX_TF` (`TSSWJG_DM`, `FSRQ`),
  KEY `IDX_CKTS_SB_MTS_CKMX_TST` (`TSSWJG_DM`, `SBRQ`, `TDCODE`),
  CONSTRAINT `PK_CKTS_SB_MTS_CKMX` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='免退税出口货物明细表';
-- MySQL requires every PRIMARY/UNIQUE key to contain all partition columns.
-- To preserve the original keys and their uniqueness, this table is not partitioned.
-- Original Oracle partition definition (retained for reference):
-- partition by range (TSSWJG_DM)
-- (
--   partition P_13300000000 values less than ('13300000000')
--     tablespace TL_TSSH,
--   partition P_13301000000 values less than ('13301000000')
--     tablespace TL_TSSH,
--   partition P_13303000000 values less than ('13303000000')
--     tablespace TL_TSSH,
--   partition P_13304000000 values less than ('13304000000')
--     tablespace TL_TSSH,
--   partition P_13305000000 values less than ('13305000000')
--     tablespace TL_TSSH,
--   partition P_13306000000 values less than ('13306000000')
--     tablespace TL_TSSH,
--   partition P_13307000000 values less than ('13307000000')
--     tablespace TL_TSSH,
--   partition P_13308000000 values less than ('13308000000')
--     tablespace TL_TSSH,
--   partition P_13309000000 values less than ('13309000000')
--     tablespace TL_TSSH,
--   partition P_13310000000 values less than ('13310000000')
--     tablespace TL_TSSH,
--   partition P_13311000000 values less than ('13311000000')
--     tablespace TL_TSSH,
--   partition P_MAXVALUE values less than (MAXVALUE)
--     tablespace TL_TSSH
-- )

-- Creating table CKTS_SB_MTS_CKMX_HIS
-- Original Oracle primary-key constraint: PK_CKTS_SB_MTS_CKMX_HIS (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_SB_MTS_CKMX_HIS` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID',
  `lcslid` CHAR(32) COMMENT '分流LCSLID',
  `tsswjg_dm` CHAR(11) COMMENT '退税税务机关代码',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `glh` VARCHAR(30) COMMENT '关联号',
  `ckfph` VARCHAR(30) COMMENT '出口发票号码',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `dlckhwzmhm` VARCHAR(20) COMMENT '代理出口货物证明号码',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `sbhgspmc` VARCHAR(500) COMMENT '申报海关商品名称',
  `hgjldwmc` VARCHAR(75) COMMENT '海关计量单位名称',
  `cksl` DECIMAL(16,4) COMMENT '出口数量',
  `mylaj` DECIMAL(18,2) COMMENT '美元离岸价',
  `cktmsywlxdmjh` VARCHAR(30) COMMENT '业务代码',
  `cktmsywlxmcjh` VARCHAR(75) COMMENT '业务类型',
  `chbz` CHAR(1) DEFAULT 'N' COMMENT '撤回标志',
  `bytsbz` CHAR(1) DEFAULT 'N' COMMENT '不予退税标志',
  `byblbz` CHAR(1) DEFAULT 'N' COMMENT '不予办理标志',
  `lcslid_sb` CHAR(32) DEFAULT ' ' COMMENT '申报LCSLID',
  `tdcode` VARCHAR(4) COMMENT '海关监管方式（关联报关单获取）',
  `hgcode` VARCHAR(4) COMMENT '申报口岸（关联报关单获取）',
  `hzdwdqdm` VARCHAR(5) COMMENT '货主单位地区代码（关联报关单获取）',
  `sbdwdm` VARCHAR(20) COMMENT '申报单位代码（关联报关单获取）',
  `gbcode` VARCHAR(3) COMMENT '国别代码（关联报关单获取）',
  `zzmdg` VARCHAR(3) COMMENT '最终目的国（关联报关单获取）',
  `zyg` VARCHAR(4) COMMENT '指运港（关联报关单获取）',
  `sjly` CHAR(1) COMMENT '1-GC表  2-JG表',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `tse` DECIMAL(18,2) COMMENT '退税额（从进货关联号汇总）',
  `sbrq` DATETIME COMMENT '申报日期',
  `mtsbz` CHAR(1) DEFAULT 'N' COMMENT '免退税标志',
  `zbblbz` CHAR(1) DEFAULT 'N' COMMENT '暂不办理标志',
  `xgrq` DATETIME COMMENT '修改日期NVL(T.XGRQ,T.LRRQ)-增量用',
  `sjtb_bz` CHAR(1) DEFAULT '0' COMMENT '错误继续标志',
  `jsje` DECIMAL(18,2) COMMENT '进货金额',
  `fsrq` DATETIME COMMENT '复审日期',
  `tsl` DECIMAL(16,6) COMMENT '退税率',
  KEY `IDX_CKTS_SB_MTS_CKMX_HIS_DC` (`DJXH`, `CKBGDH`),
  KEY `IDX_CKTS_SB_MTS_CKMX_HIS_DGCL` (`DJXH`, `GLH`, `CKSP_DM`, `LCSLID`),
  KEY `IDX_CKTS_SB_MTS_CKMX_HIS_DSSS` (`DJXH`, `SSQ`, `SBPC`, `SBXH`),
  KEY `IDX_CKTS_SB_MTS_CKMX_HIS_L` (`LCSLID`),
  KEY `IDX_CKTS_SB_MTS_CKMX_HIS_L_S` (`LCSLID_SB`),
  KEY `IDX_CKTS_SB_MTS_CKMX_HIS_SC` (`SBRQ`, `CKSP_DM`),
  KEY `IDX_CKTS_SB_MTS_CKMX_HIS_SJ` (`SJTB_SJ`),
  KEY `IDX_CKTS_SB_MTS_CKMX_HIS_STS` (`SJLY`, `TDCODE`, `SJTB_SJ`),
  KEY `IDX_CKTS_SB_MTS_CKMX_HIS_TC` (`TSSWJG_DM`, `CKRQ_1`),
  KEY `IDX_CKTS_SB_MTS_CKMX_HIS_TF` (`TSSWJG_DM`, `FSRQ`),
  KEY `IDX_CKTS_SB_MTS_CKMX_HIS_TST` (`TSSWJG_DM`, `SBRQ`, `TDCODE`),
  CONSTRAINT `PK_CKTS_SB_MTS_CKMX_HIS` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='免退税出口货物明细表';

-- Creating table CKTS_SB_MTS_JHMX
-- Original Oracle primary-key constraint: PK_CKTS_SB_MTS_JHMX (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_SB_MTS_JHMX` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID',
  `lcslid` CHAR(32) COMMENT '分流LCSLID',
  `tsswjg_dm` CHAR(11) COMMENT '退税税务机关代码',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `glh` VARCHAR(30) COMMENT '关联号',
  `sz` CHAR(1) COMMENT '税种',
  `cktmspzlx_dm` CHAR(2) COMMENT '凭证种类',
  `jhpzh` VARCHAR(75) COMMENT '进货凭证号/专用税票号',
  `kprq` DATETIME COMMENT '开票日期',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `sbhgspmc` VARCHAR(500) COMMENT '申报海关商品名称',
  `hgjldwmc` VARCHAR(75) COMMENT '海关计量单位名称',
  `sl` DECIMAL(16,4) COMMENT '数量',
  `jsje` DECIMAL(18,2) COMMENT '计税金额',
  `zssl` DECIMAL(16,6) COMMENT '征税税率',
  `tsl` DECIMAL(16,6) COMMENT '退税率',
  `tse` DECIMAL(18,6) COMMENT '退税额',
  `ghfnsrsbh_1` VARCHAR(20) COMMENT '供货方纳税人识别号',
  `chbz` CHAR(1) DEFAULT 'N' COMMENT '撤回标志',
  `bytsbz` CHAR(1) DEFAULT 'N' COMMENT '不予退税标志',
  `byblbz` CHAR(1) DEFAULT 'N' COMMENT '不予办理标志',
  `mtsbz` CHAR(1) DEFAULT 'N' COMMENT '免退税标志',
  `lcslid_sb` CHAR(32) DEFAULT ' ' COMMENT '申报LCSLID',
  `xzqh` VARCHAR(4) COMMENT '行政区划',
  `hyd` VARCHAR(10) COMMENT '货源地',
  `sjly` CHAR(1) COMMENT '1-GC表  2-JG表',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `sbrq` DATETIME COMMENT '申报日期',
  `ckrq_1` DATETIME DEFAULT '1900-01-01 00:00:00' COMMENT '出口日期',
  `zbblbz` CHAR(1) DEFAULT 'N' COMMENT '暂不办理标志',
  `zzjczbblzyny` VARCHAR(6) COMMENT '最终解除暂不办理年月',
  `xgrq` DATETIME COMMENT '修改日期NVL(T.XGRQ,T.LRRQ)-增量用',
  `sjtb_bz` CHAR(1) DEFAULT '0' COMMENT '错误继续标志',
  `xsfdsswjgdm` VARCHAR(11) COMMENT '销售方地市税务机关代码，20251226取发票系统',
  KEY `IDX_CKTS_SB_MTS_JHMX_CKRQ` (`CKRQ_1`),
  KEY `IDX_CKTS_SB_MTS_JHMX_DGCL` (`DJXH`, `GLH`, `CKSP_DM`, `LCSLID`),
  KEY `IDX_CKTS_SB_MTS_JHMX_DS` (`DJXH`, `SBRQ`),
  KEY `IDX_CKTS_SB_MTS_JHMX_DSSS` (`DJXH`, `SSQ`, `SBPC`, `SBXH`),
  KEY `IDX_CKTS_SB_MTS_JHMX_LCSLID` (`LCSLID`),
  KEY `IDX_CKTS_SB_MTS_JHMX_LCSLID_SB` (`LCSLID_SB`),
  KEY `IDX_CKTS_SB_MTS_JHMX_S` (`SBRQ`),
  CONSTRAINT `PK_CKTS_SB_MTS_JHMX` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='免退税进货明细表';
-- MySQL requires every PRIMARY/UNIQUE key to contain all partition columns.
-- To preserve the original keys and their uniqueness, this table is not partitioned.
-- Original Oracle partition definition (retained for reference):
-- partition by range (TSSWJG_DM)
-- (
--   partition P_13300000000 values less than ('13300000000')
--     tablespace TL_TSSH,
--   partition P_13301000000 values less than ('13301000000')
--     tablespace TL_TSSH,
--   partition P_13303000000 values less than ('13303000000')
--     tablespace TL_TSSH,
--   partition P_13304000000 values less than ('13304000000')
--     tablespace TL_TSSH,
--   partition P_13305000000 values less than ('13305000000')
--     tablespace TL_TSSH,
--   partition P_13306000000 values less than ('13306000000')
--     tablespace TL_TSSH,
--   partition P_13307000000 values less than ('13307000000')
--     tablespace TL_TSSH,
--   partition P_13308000000 values less than ('13308000000')
--     tablespace TL_TSSH,
--   partition P_13309000000 values less than ('13309000000')
--     tablespace TL_TSSH,
--   partition P_13310000000 values less than ('13310000000')
--     tablespace TL_TSSH,
--   partition P_13311000000 values less than ('13311000000')
--     tablespace TL_TSSH,
--   partition P_MAXVALUE values less than (MAXVALUE)
--     tablespace TL_TSSH
-- )

-- Creating table CKTS_SB_MTS_JHMX_HIS
-- Original Oracle primary-key constraint: PK_CKTS_SB_MTS_JHMX_HIS (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_SB_MTS_JHMX_HIS` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID',
  `lcslid` CHAR(32) COMMENT '分流LCSLID',
  `tsswjg_dm` CHAR(11) COMMENT '退税税务机关代码',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `glh` VARCHAR(30) COMMENT '关联号',
  `sz` CHAR(1) COMMENT '税种',
  `cktmspzlx_dm` CHAR(2) COMMENT '凭证种类',
  `jhpzh` VARCHAR(75) COMMENT '进货凭证号/专用税票号',
  `kprq` DATETIME COMMENT '开票日期',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `sbhgspmc` VARCHAR(500) COMMENT '申报海关商品名称',
  `hgjldwmc` VARCHAR(75) COMMENT '海关计量单位名称',
  `sl` DECIMAL(16,4) COMMENT '数量',
  `jsje` DECIMAL(18,2) COMMENT '计税金额',
  `zssl` DECIMAL(16,6) COMMENT '征税税率',
  `tsl` DECIMAL(16,6) COMMENT '退税率',
  `tse` DECIMAL(18,6) COMMENT '退税额',
  `ghfnsrsbh_1` VARCHAR(20) COMMENT '供货方纳税人识别号',
  `chbz` CHAR(1) DEFAULT 'N' COMMENT '撤回标志',
  `bytsbz` CHAR(1) DEFAULT 'N' COMMENT '不予退税标志',
  `byblbz` CHAR(1) DEFAULT 'N' COMMENT '不予办理标志',
  `mtsbz` CHAR(1) DEFAULT 'N' COMMENT '免退税标志',
  `lcslid_sb` CHAR(32) DEFAULT ' ' COMMENT '申报LCSLID',
  `xzqh` VARCHAR(4) COMMENT '行政区划',
  `hyd` VARCHAR(10) COMMENT '货源地',
  `sjly` CHAR(1) COMMENT '1-GC表  2-JG表',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `sbrq` DATETIME COMMENT '申报日期',
  `ckrq_1` DATETIME DEFAULT '1900-01-01 00:00:00' COMMENT '出口日期',
  `zbblbz` CHAR(1) DEFAULT 'N' COMMENT '暂不办理标志',
  `zzjczbblzyny` VARCHAR(6) COMMENT '最终解除暂不办理年月',
  `xgrq` DATETIME COMMENT '修改日期NVL(T.XGRQ,T.LRRQ)-增量用',
  `sjtb_bz` CHAR(1) DEFAULT '0' COMMENT '错误继续标志',
  `xsfdsswjgdm` VARCHAR(11) COMMENT '销售方地市税务机关代码，20251226取发票系统',
  KEY `IDX_CKTS_SB_MTS_JHMX_HIS_CKRQ` (`CKRQ_1`),
  KEY `IDX_CKTS_SB_MTS_JHMX_HIS_DGCL` (`DJXH`, `GLH`, `CKSP_DM`, `LCSLID`),
  KEY `IDX_CKTS_SB_MTS_JHMX_HIS_DS` (`DJXH`, `SBRQ`),
  KEY `IDX_CKTS_SB_MTS_JHMX_HIS_DSSS` (`DJXH`, `SSQ`, `SBPC`, `SBXH`),
  KEY `IDX_CKTS_SB_MTS_JHMX_HIS_L` (`LCSLID`),
  KEY `IDX_CKTS_SB_MTS_JHMX_HIS_L_S` (`LCSLID_SB`),
  KEY `IDX_CKTS_SB_MTS_JHMX_HIS_S` (`SBRQ`),
  CONSTRAINT `PK_CKTS_SB_MTS_JHMX_HIS` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='免退税进货明细表';

-- Creating table CKTS_SB_MTS_YSFW
-- Original Oracle primary-key constraint: PK_CKTS_SB_MTS_YSFW (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_SB_MTS_YSFW` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID',
  `lcslid` CHAR(32) COMMENT '分流LCSLID',
  `tsswjg_dm` CHAR(11) COMMENT '退税税务机关代码',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `ckfph` VARCHAR(30) COMMENT '出口发票号码',
  `hth` VARCHAR(60) COMMENT '合同号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `ysfw_dm` VARCHAR(20) COMMENT '应税服务代码',
  `ysfwmc` VARCHAR(500) COMMENT '应税服务名称',
  `skjemy` DECIMAL(18,2) COMMENT '收款金额（美元）',
  `bqqrysfwyysrrmbje` DECIMAL(18,2) COMMENT '本期确认应税服务营业额（人民币）',
  `jhpzh` VARCHAR(75) COMMENT '进货凭证号',
  `kprq` DATETIME COMMENT '开票日期',
  `jsje` DECIMAL(18,2) COMMENT '计税金额',
  `zssl` DECIMAL(16,6) COMMENT '征税税率',
  `tsl` DECIMAL(16,6) COMMENT '退税率',
  `zzstse` DECIMAL(18,6) COMMENT '增值税退税额',
  `ghfnsrsbh_1` VARCHAR(20) COMMENT '供货方纳税人识别号',
  `cktmsywlxdmjh` VARCHAR(30) COMMENT '业务代码',
  `cktmsywlxmcjh` VARCHAR(75) COMMENT '业务类型',
  `chbz` CHAR(1) DEFAULT 'N' COMMENT '撤回标志',
  `bytsbz` CHAR(1) DEFAULT 'N' COMMENT '不予退税标志',
  `byblbz` CHAR(1) DEFAULT 'N' COMMENT '不予办理标志',
  `lcslid_sb` CHAR(32) DEFAULT ' ' COMMENT '申报LCSLID',
  `sjly` CHAR(1) COMMENT '1-GC表  2-JG表',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `sbrq` DATETIME COMMENT '申报日期',
  `xgrq` DATETIME COMMENT '修改日期NVL(T.XGRQ,T.LRRQ)-增量用',
  `sjtb_bz` CHAR(1) DEFAULT '0' COMMENT '错误继续标志',
  `mtsbz` CHAR(1) DEFAULT 'N' COMMENT '免退税标志',
  `zbblbz` CHAR(1) DEFAULT 'N' COMMENT '暂不办理标志',
  KEY `IDX_CKTS_SB_MTS_YSFW_DSSS` (`DJXH`, `SSQ`, `SBPC`, `SBXH`),
  KEY `IDX_CKTS_SB_MTS_YSFW_LCSLID` (`LCSLID`),
  CONSTRAINT `PK_CKTS_SB_MTS_YSFW` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='免退税跨境应税行为出口明细表';

-- Creating table CKTS_SB_WZF_CKMX
-- Original Oracle primary-key constraint: PK_CKTS_SB_WZF_CKMX (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_SB_WZF_CKMX` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID',
  `lcslid` CHAR(32) COMMENT '分流LCSLID',
  `tsswjg_dm` CHAR(11) COMMENT '退税税务机关代码',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `wtdbtsscqynsrsbh` VARCHAR(20) COMMENT '委托代办退税生产企业纳税人识别号',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `hgspmc` VARCHAR(500) COMMENT '海关商品名称',
  `hgjldwmc` VARCHAR(75) COMMENT '海关计量单位名称',
  `cksl` DECIMAL(16,4) COMMENT '出口数量',
  `mylaj` DECIMAL(18,2) COMMENT '美元离岸价',
  `dbtswspzhm` VARCHAR(40) COMMENT '代办退税完税凭证号码',
  `kprq` DATETIME COMMENT '开票日期',
  `jsje` DECIMAL(18,2) COMMENT '计税金额',
  `zssl` DECIMAL(16,6) COMMENT '征税税率',
  `tsl` DECIMAL(16,6) COMMENT '退税率',
  `tse` DECIMAL(18,6) COMMENT '退税额',
  `cktmsywlxdmjh` VARCHAR(30) COMMENT '出口退（免）税业务类型代码集合',
  `cktmsywlxmcjh` VARCHAR(75) COMMENT '出口退（免）税业务类型名称集合',
  `dbtsywlx_dm` VARCHAR(20) COMMENT '代办退税业务类型代码',
  `dbtsywlxmc` VARCHAR(75) COMMENT '代办退税业务类型名称',
  `chbz` CHAR(1) DEFAULT 'N' COMMENT '撤回标志',
  `bytsbz` CHAR(1) DEFAULT 'N' COMMENT '不予退税标志',
  `byblbz` CHAR(1) DEFAULT 'N' COMMENT '不予办理标志',
  `lcslid_sb` CHAR(32) DEFAULT ' ' COMMENT '申报LCSLID',
  `sjly` CHAR(1) COMMENT '1-GC表  2-JG表',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `tdcode` VARCHAR(4),
  `hgcode` VARCHAR(4),
  `hzdwdqdm` VARCHAR(5),
  `sbdwdm` VARCHAR(20),
  `gbcode` VARCHAR(3),
  `zzmdg` VARCHAR(3),
  `zyg` VARCHAR(4),
  `sbrq` DATETIME COMMENT '申报日期',
  `mtsbz` CHAR(1) DEFAULT 'N' COMMENT '免退税标志',
  `zbblbz` CHAR(1) DEFAULT 'N' COMMENT '暂不办理标志',
  `zzjczbblzyny` VARCHAR(6) COMMENT '最终解除暂不办理年月',
  `xgrq` DATETIME COMMENT '修改日期NVL(T.XGRQ,T.LRRQ)-增量用',
  `sjtb_bz` CHAR(1) DEFAULT '0' COMMENT '错误继续标志',
  `fsrq` DATETIME COMMENT '复审日期',
  KEY `IDX_CKTS_SB_WZF_CKMX_DC` (`DJXH`, `CKBGDH`),
  KEY `IDX_CKTS_SB_WZF_CKMX_DSSS` (`DJXH`, `SSQ`, `SBPC`, `SBXH`),
  KEY `IDX_CKTS_SB_WZF_CKMX_LCSLID` (`LCSLID`),
  KEY `IDX_CKTS_SB_WZF_CKMX_LCSLID_SB` (`LCSLID_SB`),
  KEY `IDX_CKTS_SB_WZF_CKMX_SC` (`SBRQ`, `CKSP_DM`),
  KEY `IDX_CKTS_SB_WZF_CKMX_SJ` (`SJTB_SJ`),
  KEY `IDX_CKTS_SB_WZF_CKMX_TF` (`TSSWJG_DM`, `FSRQ`),
  CONSTRAINT `PK_CKTS_SB_WZF_CKMX` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='外贸综合服务代办退税申报表';

-- Creating table CKTS_SB_YS_SBMX
-- Original Oracle primary-key constraint: PK_CKTS_SB_YS_SBMX (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_SB_YS_SBMX` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID',
  `lcslid` CHAR(32) COMMENT '分流LCSLID',
  `tsswjg_dm` CHAR(11) COMMENT '退税税务机关代码',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) COMMENT '申报批次',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `dlckhwzmhm` VARCHAR(20) COMMENT '代理出口货物证明号码',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `sbhgspmc` VARCHAR(500) COMMENT '申报海关商品名称||申报海关商品名称',
  `ysygdsbmc` VARCHAR(500) COMMENT '已使用过的设备名称',
  `ysygdsbpzhm` VARCHAR(40) COMMENT '已使用过的设备凭证号码',
  `kprq` DATETIME COMMENT '开票日期',
  `jsje` DECIMAL(18,2) COMMENT '计税金额',
  `zssl` DECIMAL(16,6) COMMENT '征税税率',
  `se` DECIMAL(18,6) COMMENT '税额',
  `sbyz` DECIMAL(18,2) COMMENT '设备原值',
  `ysynx` DECIMAL(16,4) COMMENT '已使用年限',
  `ytljzje` DECIMAL(18,2) COMMENT '已提累计折旧额',
  `sbzyjz` DECIMAL(18,2) COMMENT '设备折余价值',
  `tsl` DECIMAL(16,6) COMMENT '退税率',
  `tse` DECIMAL(18,6) COMMENT '退税额',
  `chbz` CHAR(1) DEFAULT 'N' COMMENT '撤回标志',
  `bytsbz` CHAR(1) COMMENT '不予退税标志',
  `byblbz` CHAR(1) COMMENT '不予办理标志',
  `sjly` CHAR(1) COMMENT '1-GC表  2-JG表',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `sbrq` DATETIME COMMENT '申报日期',
  `xgrq` DATETIME COMMENT '修改日期NVL(T.XGRQ,T.LRRQ)-增量用',
  `sjtb_bz` CHAR(1) DEFAULT '0' COMMENT '错误继续标志',
  `zbblbz` CHAR(1) DEFAULT 'N' COMMENT '暂不办理标志',
  KEY `IDX_CKTS_SB_YS_SBMX_DC` (`DJXH`, `CKBGDH`),
  KEY `IDX_CKTS_SB_YS_SBMX_DSSS` (`DJXH`, `SSQ`, `SBPC`, `SBXH`),
  KEY `IDX_CKTS_SB_YS_SBMX_LCSLID` (`LCSLID`),
  CONSTRAINT `PK_CKTS_SB_YS_SBMX` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口已使用过的设备退税申报表';

-- Creating table CKTS_TY_KJDSHWC_HSTZ
-- Original Oracle primary-key constraint: PK_CKTS_TY_KJDSHWC_HSTZ (MySQL index name: PRIMARY).
-- Original function index IDX_CKTS_TY_KJDSHWC_HSTZ_DSPG: (LCSWSX_DM, YTSSBNY, NVL(YTSGLH,'2'), NVL(YTSSBPC,'1'), YTSSBXH); expressions below use equivalent MySQL functions.
-- Original function index IDX_CKTS_TY_KJDSHWC_HSTZ_DY: (DJXH, TO_CHAR(YTSBLSJ,'YYYYMM')); expressions below use equivalent MySQL functions.
CREATE TABLE `CKTS_TY_KJDSHWC_HSTZ` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID||uuid',
  `lcswsx_dm` VARCHAR(16) COMMENT '流程税务事项代码',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ytslcslid` VARCHAR(32) COMMENT '预退税流程实例ID',
  `ytssbny` CHAR(6) COMMENT '预退税申报年月',
  `ytsglh` VARCHAR(30) COMMENT '预退税关联号',
  `ytssbpc` VARCHAR(75) COMMENT '预退税申报批次',
  `ytssbxh` VARCHAR(50) COMMENT '预退税申报序号',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `dlckhwzmhm` VARCHAR(20) COMMENT '代理出口货物证明号码',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `ytssz` VARCHAR(45) COMMENT '预退税税种',
  `zzstse` DECIMAL(18,6) DEFAULT 0 COMMENT '增值税退税额',
  `xfstse` DECIMAL(18,6) DEFAULT 0 COMMENT '消费税退税额',
  `ytsblsj` DATETIME COMMENT '预退税办理时间',
  `sfyhsbz` CHAR(1) DEFAULT 'N' COMMENT '是否已核算标志',
  `schsrq` DATETIME COMMENT '首次核算日期',
  `ckhwcytshslx_dm` CHAR(2) COMMENT '出口海外仓预退税核算类型代码',
  `zxhsrq` DATETIME COMMENT '最新核算日期',
  `zxhssjlcslid` VARCHAR(32) COMMENT '最新核算数据LCSLID',
  `sfczcjsbbz` CHAR(1) DEFAULT 'N' COMMENT '是否存在冲减申报标志',
  `sfczzhxxbz` CHAR(1) DEFAULT 'N' COMMENT '是否存在追回信息标志',
  `zxcjsjlcslid` VARCHAR(32) COMMENT '最新冲减数据LCSLID',
  `zxzhsjlcslid` VARCHAR(32) COMMENT '最新追回数据LCSLID',
  `cqwhsfhbz` CHAR(1) DEFAULT 'N' COMMENT '超期未核算复核标志',
  `cqwhsfhlcslid` VARCHAR(32) COMMENT '超期未核算复核流程实例ID',
  `cqwhsfhr` VARCHAR(300) COMMENT '超期未核算复核人',
  `cqwhsfhrq` DATETIME COMMENT '超期未核算复核日期',
  `hsycfhbz` CHAR(1) DEFAULT 'N' COMMENT '核算异常复核标志',
  `hsycfhlcslid` VARCHAR(32) COMMENT '核算异常复核流程实例ID',
  `hsycfhr` VARCHAR(300) COMMENT '核算异常复核人',
  `hsycfhrq` DATETIME COMMENT '核算异常复核日期',
  `lrr_dm` CHAR(11) NOT NULL COMMENT '录入人代码',
  `lrrq` DATETIME NOT NULL COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `sjgsdq` CHAR(11) NOT NULL COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `sjgxsj` DATETIME COMMENT '数据更新时间',
  `zfbz_1` CHAR(1) DEFAULT 'N' COMMENT '作废标志',
  `ytsslrq` DATETIME COMMENT '预退税受理日期',
  `zxhsssq` CHAR(6) COMMENT '最新核算所属期',
  `zxhspc` VARCHAR(75) COMMENT '最新核算批次',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `ytshsjzr_1` CHAR(6) COMMENT '预退税核算截止日',
  KEY `IDX_CKTS_TY_KJDSHWC_HSTZ_CD` (`DJXH`, `ZXCJSJLCSLID`),
  KEY `IDX_CKTS_TY_KJDSHWC_HSTZ_DCH` (`DJXH`, `CQWHSFHBZ`, `HSYCFHBZ`),
  KEY `IDX_CKTS_TY_KJDSHWC_HSTZ_DS` (`DJXH`, `SFYHSBZ`),
  KEY `IDX_CKTS_TY_KJDSHWC_HSTZ_DSPG` (`LCSWSX_DM`, `YTSSBNY`, (COALESCE(NULLIF(`YTSGLH`, ''), '2')), (COALESCE(NULLIF(`YTSSBPC`, ''), '1')), `YTSSBXH`),
  KEY `IDX_CKTS_TY_KJDSHWC_HSTZ_DY` (`DJXH`, (CAST(CONCAT(LPAD(YEAR(`YTSBLSJ`), 4, '0'), LPAD(MONTH(`YTSBLSJ`), 2, '0')) AS CHAR(6)))),
  KEY `IDX_CKTS_TY_KJDSHWC_HSTZ_L` (`YTSLCSLID`),
  CONSTRAINT `PK_CKTS_TY_KJDSHWC_HSTZ` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='跨境电商出口海外仓预退税核算管理台账表';

-- Creating table CKTS_WBSJ_BGD_9X10
-- Original Oracle primary-key constraint: PKEY_CKTS_WBSJ_BGD_9X10 (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_WBSJ_BGD_9X10` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID',
  `lcslid` CHAR(32) COMMENT 'LCSLID',
  `tsswjg_dm` CHAR(11) COMMENT '退税税务机关代码',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `sbywb_dm` VARCHAR(10) COMMENT '申报业务表代码',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `sbpc` VARCHAR(75) DEFAULT '001' COMMENT '申报批次',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `tdcode` VARCHAR(4) COMMENT '海关监管方式',
  `mylaj` DECIMAL(18,2) COMMENT '美元离岸价',
  `mdtse` DECIMAL(18,6) COMMENT '生产企业免抵退税额/外贸企业退税额',
  `zytsbz` CHAR(1) COMMENT '准予退税标志',
  `sbrq` DATETIME COMMENT '申报日期',
  `fsrq` DATETIME COMMENT '复审日期',
  `cktmsywlxdmjh` VARCHAR(30) COMMENT '业务代码',
  `tse` DECIMAL(18,6) COMMENT '退税额',
  `sjly` CHAR(1) COMMENT '1-GC表  2-JG表',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  KEY `IDX_CKTS_WBSJ_BGD_9X10_DJXH` (`DJXH`),
  KEY `IDX_CKTS_WBSJ_BGD_9X10_LCSLID` (`LCSLID`),
  KEY `IDX_CKTS_WBSJ_BGD_9X10_TST` (`TSSWJG_DM`, `SBRQ`, `TDCODE`),
  CONSTRAINT `PKEY_CKTS_WBSJ_BGD_9X10` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table CKTS_WBSJ_BGD_WSB
-- Original Oracle primary-key constraint: PK_CKTS_WBSJ_WSBBGD (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_WBSJ_BGD_WSB` (
  `uuid` VARCHAR(32),
  `tsswjg_dm` CHAR(11),
  `djxh` DECIMAL(20,0) NOT NULL,
  `ckbgdh` VARCHAR(21) NOT NULL,
  `ckrq_1` DATETIME,
  `cksp_dm` VARCHAR(20),
  `jgfs_dm` CHAR(4),
  `rmblaj` DECIMAL(18,2),
  `mylaj` DECIMAL(18,2),
  `bah` VARCHAR(12),
  CONSTRAINT `PK_CKTS_WBSJ_WSBBGD` PRIMARY KEY (`DJXH`, `CKBGDH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table CKTS_WBSJ_HG_BGD
-- Original Oracle primary-key constraint: PK_CKTS_WBSJ_HG_BGD (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_WBSJ_HG_BGD` (
  `uuid` VARCHAR(32),
  `djxh` DECIMAL(20,0) NOT NULL,
  `tsswjg_dm_1` CHAR(11),
  `ckny` CHAR(6),
  `yhggqka_dm` CHAR(4),
  `hggqka_dm` CHAR(4),
  `ckbgdh` VARCHAR(21) NOT NULL,
  `bsm` VARCHAR(21),
  `hzdwdq_dm` CHAR(5),
  `hxdh` VARCHAR(30),
  `ckrq_1` DATETIME,
  `ycksp_dm` VARCHAR(20),
  `cksp_dm` VARCHAR(20),
  `ckspmc` VARCHAR(75),
  `hgjldwmc` VARCHAR(75),
  `mygdqsz_dm` CHAR(3),
  `yjgfs_dm` CHAR(4),
  `jgfs_dm` CHAR(4),
  `ydyjldw_dm` VARCHAR(3),
  `dyjldw_dm` VARCHAR(3),
  `ydejldw_dm` VARCHAR(3),
  `dejldw_dm` VARCHAR(3),
  `cksl` DECIMAL(16,4),
  `decksl` DECIMAL(16,4),
  `rmblaj` DECIMAL(18,2),
  `mylaj` DECIMAL(18,2),
  `cjhghbsz_dm` CHAR(3),
  `cjzj` DECIMAL(18,2),
  `jydwmc` VARCHAR(300),
  `ysfs_dm` CHAR(1),
  `tydh` VARCHAR(32),
  `zmxz_dm` CHAR(3),
  `jhfs_dm` CHAR(1),
  `xkzh` VARCHAR(20),
  `zyg_dm` VARCHAR(6),
  `hgcjfs_dm` CHAR(1),
  `yfjsfs_dm` CHAR(1),
  `yfhghbsz_dm` CHAR(3),
  `yfhl` DECIMAL(16,6),
  `bfjsfs_dm` CHAR(1),
  `bfhghbsz_dm` CHAR(3),
  `bfhl` DECIMAL(16,6),
  `zfjsfs_dm` CHAR(1),
  `zfhghbsz_dm` CHAR(3),
  `zfhl` DECIMAL(16,6),
  `bah` VARCHAR(12),
  `sbdwdm` VARCHAR(50),
  `sbdwmc` VARCHAR(300),
  `hzdwmc` VARCHAR(300),
  `ggxh` VARCHAR(150),
  `zzmdgdqsz_dm` CHAR(3),
  `sbjldw_dm` VARCHAR(3),
  `sbsl_1` DECIMAL(16,4),
  `sbdj` DECIMAL(18,2),
  `tsl` DECIMAL(16,6),
  `cytssbjl` VARCHAR(60),
  `ysgjmc` VARCHAR(500),
  `bytsbz` CHAR(1),
  `hch` VARCHAR(32),
  `hzdwdm` VARCHAR(50),
  `hgbzzl_dm` VARCHAR(2),
  `js_1` DECIMAL(10,0),
  `mz_2` DECIMAL(18,6),
  `jz` DECIMAL(18,6),
  `lxbz` VARCHAR(32),
  `tssbsl` DECIMAL(16,4),
  `tssbrmblaj` DECIMAL(18,2),
  `tssbmylaj` DECIMAL(18,2),
  `tysl` DECIMAL(16,4),
  `tyrmblaj` DECIMAL(18,2),
  `tymylaj` DECIMAL(18,2),
  `dlsbsl` DECIMAL(16,4),
  `dlsbrmblaj` DECIMAL(18,2),
  `dlsbmylaj` DECIMAL(18,2),
  `hgspmc` VARCHAR(500),
  `gfhhgspmc` VARCHAR(500),
  `hgqy_dm` VARCHAR(50),
  `sjgxsj` DATETIME,
  `rkrq` DATETIME,
  `sjzxtybh` VARCHAR(20),
  `qygbz` CHAR(1),
  `kjdlckhwzmbz` CHAR(1),
  `kjckhwtyybswtszmbz` CHAR(1),
  `lrr_dm` CHAR(11) NOT NULL,
  `lrrq` DATETIME NOT NULL,
  `xgr_dm` CHAR(11),
  `xgrq` DATETIME,
  `sjgsdq` CHAR(11) NOT NULL,
  `sjtb_sj` DATETIME(6),
  `hgckhwbgdsbrq` DATETIME,
  `qygzcjgbz` CHAR(1),
  `qygwddbz` CHAR(1),
  `qygcxckbz` CHAR(1),
  `qyrq_2` DATETIME,
  `ckhth` VARCHAR(60),
  `gdbz_1` CHAR(1) DEFAULT 'N',
  `hydxzqh_dm` CHAR(4),
  `zmtbz` CHAR(1) COMMENT '征免退标志',
  KEY `IDX_CKTS_WBSJ_HG_BGD_CGC` (`CKSP_DM`, `GFHHGSPMC`, `CKNY`),
  KEY `IDX_CKTS_WBSJ_HG_BGD_CKSP` (`CKSP_DM`, `TSSWJG_DM_1`),
  KEY `IDX_CKTS_WBSJ_HG_BGD_DC` (`DJXH`, `CKRQ_1`),
  KEY `IDX_CKTS_WBSJ_HG_BGD_DS` (`DJXH`, `HGCKHWBGDSBRQ`, `JGFS_DM`),
  KEY `IDX_CKTS_WBSJ_HG_BGD_SJTBSJ` (`SJTB_SJ`),
  KEY `IDX_CKTS_WBSJ_HG_BGD_TJC` (`TSSWJG_DM_1`, `CKRQ_1`, `JGFS_DM`),
  CONSTRAINT `PK_CKTS_WBSJ_HG_BGD` PRIMARY KEY (`CKBGDH`, `DJXH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table CKTS_WBSJ_HG_BGD204
-- Original Oracle primary-key constraint: PK_CKTS_WBSJ_HG_BGD204 (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_WBSJ_HG_BGD204` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID||uuid',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `jzxh` VARCHAR(32) COMMENT '集装箱号',
  `bjmmjbz` VARCHAR(500) COMMENT '标记唛码及备注',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `bgdhgbh` VARCHAR(30) NOT NULL COMMENT '报关单海关编号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `tbrq` DATETIME COMMENT '同步日期',
  `tbbz` CHAR(1) COMMENT '同步标志',
  KEY `IDX_CKTS_WBSJ_HG_BGD204_B` (`BGDHGBH`),
  KEY `IDX_CKTS_WBSJ_HG_BGD204_DC` (`DJXH`, `CKRQ_1`),
  KEY `IDX_CKTS_WBSJ_HG_BGD204_JC` (`JZXH`, `CKRQ_1`),
  CONSTRAINT `PK_CKTS_WBSJ_HG_BGD204` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='海关出口货物报关单204';

-- Creating table CKTS_WBSJ_ZJ_DLCKHWZM
-- Original Oracle primary-key constraint: PK_CKTS_WBSJ_ZJ_DLCKHWZM (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_WBSJ_ZJ_DLCKHWZM` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID||uuid',
  `dlckhwzmhm` VARCHAR(20) COMMENT '代理出口货物证明号码',
  `rq` DATETIME COMMENT '日期',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `wtfnsrsbh` VARCHAR(20) NOT NULL COMMENT '委托方纳税人识别号',
  `wtfnsrmc` VARCHAR(300) COMMENT '委托方纳税人名称',
  `wtfhgqydm` VARCHAR(50) COMMENT '委托方海关企业代码',
  `stfmc` VARCHAR(300) COMMENT '受托方名称',
  `stfnsrsbh` VARCHAR(20) COMMENT '受托方纳税人识别号',
  `stfshxydm` VARCHAR(20) COMMENT '受托方社会信用代码',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `ckshhxdh` VARCHAR(30) COMMENT '出口收汇核销单号',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `ckspmc` VARCHAR(300) COMMENT '出口商品名称',
  `hgjldwmc` VARCHAR(75) COMMENT '海关计量单位名称',
  `cksl` DECIMAL(16,4) COMMENT '出口数量',
  `mylaj` DECIMAL(18,2) COMMENT '美元离岸价',
  `wtdlckhth` VARCHAR(60) COMMENT '委托（代理）出口合同号',
  `ssq` VARCHAR(60) COMMENT '所属期',
  `tsswjg_dm_1` CHAR(11) COMMENT '退税税务机关代码',
  `cytssbjl` VARCHAR(60) COMMENT '参与退税申报记录',
  `hbzm_dm` CHAR(3) COMMENT '货币字母代码',
  `ybje` DECIMAL(18,2) COMMENT '原币金额',
  `jgfs_dm` CHAR(4) COMMENT '监管方式代码',
  `lcslid` CHAR(32) COMMENT '流程实例ID',
  `bytsbz` CHAR(1) COMMENT '不予退税标志',
  `bah` VARCHAR(12) COMMENT '备案号',
  `bfhghbsz_dm` CHAR(3) COMMENT '保费海关货币数字代码',
  `bfhl` DECIMAL(16,6) COMMENT '保费汇率',
  `bfjsfs_dm` CHAR(1) COMMENT '保费计算方式代码',
  `decksl` DECIMAL(16,4) COMMENT '第二出口数量',
  `hgbzzl_dm` VARCHAR(2) COMMENT '海关包装种类代码',
  `cjhghbsz_dm` CHAR(3) COMMENT '成交海关货币数字代码',
  `hgcjfs_dm` CHAR(1) COMMENT '海关成交方式代码',
  `cjzj` DECIMAL(18,2) COMMENT '成交总价||成交总价',
  `dyjldw_dm` VARCHAR(3) COMMENT '第一计量单位代码',
  `dejldw_dm` VARCHAR(3) COMMENT '第二计量单位代码',
  `mygdqsz_dm` CHAR(3) COMMENT '贸易国（地区）数字代码',
  `hch` VARCHAR(32) COMMENT '航次号',
  `hgspmc` VARCHAR(500) COMMENT '海关商品名称',
  `hggqka_dm` CHAR(4) COMMENT '海关关区（口岸）代码',
  `ckhth` VARCHAR(60) COMMENT '出口合同号',
  `jnhyd_dm` CHAR(5) COMMENT '境内货源地代码',
  `hzdwmc` VARCHAR(300) COMMENT '货主单位名称',
  `hzdwdm` VARCHAR(50) COMMENT '货主单位代码',
  `jhfs_dm` CHAR(1) COMMENT '结汇方式代码',
  `js_1` DECIMAL(10,0) COMMENT '件数',
  `jydwmc` VARCHAR(300) COMMENT '经营单位名称',
  `jz` DECIMAL(18,6) COMMENT '净重',
  `lxbz` VARCHAR(32) COMMENT '类型备注',
  `mz_2` DECIMAL(18,6) COMMENT '毛重',
  `rmblaj` DECIMAL(18,2) COMMENT '人民币离岸价',
  `sbdwdm` VARCHAR(50) COMMENT '申报单位代码',
  `sbdwmc` VARCHAR(300) COMMENT '申报单位名称',
  `sbjldw_dm` VARCHAR(3) COMMENT '申报计量单位代码',
  `hgckhwbgdsbrq` DATETIME COMMENT '海关出口货物报关单申报日期',
  `sbdj` DECIMAL(18,2) COMMENT '申报单价',
  `sbsl_1` DECIMAL(16,4) COMMENT '申报数量',
  `ggxh` VARCHAR(150) COMMENT '规格型号',
  `ysgjmc` VARCHAR(500) COMMENT '运输工具名称',
  `tssbsl` DECIMAL(16,4) COMMENT '退税申报数量',
  `tssbrmblaj` DECIMAL(18,2) COMMENT '退税申报人民币离岸价',
  `tssbmylaj` DECIMAL(18,2) COMMENT '退税申报美元离岸价',
  `tydh` VARCHAR(32) COMMENT '提运单号',
  `tysl` DECIMAL(16,4) COMMENT '退运数量',
  `tyrmblaj` DECIMAL(18,2) COMMENT '退运人民币离岸价',
  `tymylaj` DECIMAL(18,2) COMMENT '退运美元离岸价',
  `xkzh` VARCHAR(20) COMMENT '许可证号',
  `yfhghbsz_dm` CHAR(3) COMMENT '运费海关货币数字代码',
  `yfhl` DECIMAL(16,6) COMMENT '运费汇率',
  `yfjsfs_dm` CHAR(1) COMMENT '运费计算方式代码',
  `ysfs_dm` CHAR(1) COMMENT '运输方式代码',
  `zfhghbsz_dm` CHAR(3) COMMENT '杂费海关货币数字代码',
  `zfhl` DECIMAL(16,6) COMMENT '杂费汇率',
  `zfjsfs_dm` CHAR(1) COMMENT '杂费计算方式代码',
  `zyg_dm` VARCHAR(6) COMMENT '指运港代码',
  `zzmdgdqsz_dm` CHAR(3) COMMENT '最终目的国（地区）数字代码',
  `bz` VARCHAR(3000) COMMENT '备注',
  `cjzmrq` DATETIME COMMENT '出具证明日期',
  `gfhhgspmc` VARCHAR(500) COMMENT '规范化海关商品名称',
  `sjgxsj` DATETIME COMMENT '数据更新时间',
  `rkrq` DATETIME COMMENT '入库日期',
  `lrr_dm` CHAR(11) NOT NULL COMMENT '录入人代码',
  `lrrq` DATETIME NOT NULL COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `sjgsdq` CHAR(11) NOT NULL COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `dbtsbz_1` CHAR(1) COMMENT '代办退税标志',
  `stfhgqydm` VARCHAR(50) COMMENT '受托方海关企业代码',
  `sjly` VARCHAR(1500) COMMENT '数据来源||数据来源',
  `qklbbh` VARCHAR(75) COMMENT '区块链版本号',
  KEY `IDX_CKTS_WBSJ_ZJ_DLCKHWZM_DC` (`DJXH`, `CKRQ_1`),
  KEY `IDX_CKTS_WBSJ_ZJ_DLCKHWZM_DD` (`DJXH`, `DLCKHWZMHM`),
  CONSTRAINT `PK_CKTS_WBSJ_ZJ_DLCKHWZM` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='总局代理出口货物证明';

-- Creating table CKTS_ZS_CKTSZB_JGB
-- Original Oracle primary-key constraint: PK_CKTS_ZS_CKTSZB_JGB (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_ZS_CKTSZB_JGB` (
  `uuid` VARCHAR(32) NOT NULL,
  `swjg_dm` CHAR(11) NOT NULL,
  `skssswjg_dm` CHAR(11) NOT NULL,
  `jhfpnd` VARCHAR(10) NOT NULL,
  `jhxdrq` DATETIME,
  `bnsjfpjh` DECIMAL(18,6),
  `bnyfpjh` DECIMAL(18,6),
  `bnfptsjhlj` DECIMAL(18,6) NOT NULL,
  `bz` VARCHAR(3000),
  `lrrq` DATETIME NOT NULL,
  `lrr_dm` CHAR(11) NOT NULL,
  `xgrq` DATETIME,
  `xgr_dm` CHAR(11),
  `sjgsdq` CHAR(11) NOT NULL,
  `sjtb_sj` DATETIME(6),
  `yuuid` VARCHAR(32),
  `fprq` DATETIME,
  `lcslid` CHAR(32) NOT NULL DEFAULT '0',
  `ywpzuuid` VARCHAR(32) NOT NULL DEFAULT '0',
  `sjblbz` DECIMAL(2,0) DEFAULT 0,
  KEY `IDX_CKTS_ZS_CKTSZB_JGB_SJ` (`SKSSSWJG_DM`, `JHFPND`),
  CONSTRAINT `PK_CKTS_ZS_CKTSZB_JGB` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table CKTS_ZS_DJXHDZB
CREATE TABLE `CKTS_ZS_DJXHDZB` (
  `djxh_ck` DECIMAL(20,0) NOT NULL,
  `djxh_zs` DECIMAL(20,0) NOT NULL,
  `nsrmc` VARCHAR(200) COMMENT '纳税人名称'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table CKTS_ZS_MDTKB
-- Original Oracle primary-key constraint: PK_CKTS_ZS_MDTKB (MySQL index name: PRIMARY).
-- Original function index IDX_CKTS_ZS_MDTKB_DCKL: (DJXH, CKTS_NO, KJTKBJ, UPPER(TRIM(LRR_DM))); expressions below use equivalent MySQL functions.
CREATE TABLE `CKTS_ZS_MDTKB` (
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `nsrsbh` VARCHAR(20) NOT NULL COMMENT '纳税人识别号',
  `md_amt` DECIMAL(18,2) NOT NULL COMMENT '免抵额',
  `ss_ym` CHAR(6) COMMENT '所属期',
  `lsgx_dm` CHAR(2) COMMENT '隶属关系代码',
  `hg_dm` VARCHAR(50) COMMENT '海关代码',
  `skssqq` DATETIME NOT NULL COMMENT '税款所属期起',
  `skssqz` DATETIME NOT NULL COMMENT '税款所属期止',
  `tklx` CHAR(1) COMMENT '调库类型||包括：一般增值税、改征增值税',
  `tzlx_dm` CHAR(1) NOT NULL COMMENT '调账类型代码',
  `kjtkbj` CHAR(1) COMMENT '开具调库标记||Y 已开具调库通知书   N 未开具调库通知书 ',
  `zsswjg_dm` CHAR(11) NOT NULL COMMENT '征收税务机关代码',
  `skssswjg_dm` CHAR(11) NOT NULL COMMENT '税款所属税务机构代码',
  `zgswskfj_dm` CHAR(11) NOT NULL COMMENT '主管税务所（科、分局）代码',
  `lrr_dm` CHAR(11) NOT NULL COMMENT '录入人代码',
  `lrrq` DATETIME NOT NULL COMMENT '录入日期',
  `xgr_dm` CHAR(11) COMMENT '修改人代码',
  `xgrq` DATETIME COMMENT '修改日期',
  `sjgsdq` CHAR(11) NOT NULL COMMENT '数据归属地区',
  `sjtb_sj` DATETIME(6) COMMENT '数据同步时间',
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID||uuid',
  `ywlx` VARCHAR(75) COMMENT '业务类型',
  `ckts_no` VARCHAR(32) COMMENT '出口退税编号||出口退税系统内部自动生成的编号',
  `hsswjg_dm` CHAR(11) COMMENT '免抵调库税务机关代码',
  `xhrq_1` DATETIME COMMENT '销号日期',
  KEY `IDX_CKTS_ZS_MDTKB_DCKL` (`DJXH`, `CKTS_NO`, `KJTKBJ`, (NULLIF(UPPER(TRIM(`LRR_DM`)), ''))),
  CONSTRAINT `PK_CKTS_ZS_MDTKB` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='征收出口退税免抵调库表，来源HX_ZS.ZS_CKTS_MDT';

-- Creating table CKTS_ZS_SRTHS
-- Original Oracle primary-key constraint: PK_CKTS_ZS_SRTHS (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_ZS_SRTHS` (
  `srthsuuid` VARCHAR(32) NOT NULL,
  `dzsphm` DECIMAL(20,0) NOT NULL,
  `dzspmxxh` DECIMAL(8,0) NOT NULL,
  `gldzspmxxh` DECIMAL(8,0),
  `ydtuuid` VARCHAR(32) NOT NULL,
  `djxh` DECIMAL(20,0) NOT NULL,
  `zrrsbh` VARCHAR(20),
  `zrrxm_1` VARCHAR(150),
  `zrrdjxh` DECIMAL(20,0),
  `pzzl_dm` VARCHAR(9) NOT NULL,
  `pzzg_dm` VARCHAR(45),
  `pzhm` VARCHAR(20),
  `kprq` DATETIME NOT NULL,
  `thrq_1` DATETIME,
  `xhrq_1` DATETIME,
  `kjjzrq` DATETIME,
  `xhr_dm` CHAR(11),
  `czlx_dm` CHAR(2) NOT NULL,
  `tzlx_dm` CHAR(1) NOT NULL,
  `se` DECIMAL(18,6) NOT NULL,
  `zsxm_dm` VARCHAR(5) NOT NULL,
  `zspm_dm` CHAR(9) NOT NULL,
  `skssqq` DATETIME NOT NULL,
  `skssqz` DATETIME NOT NULL,
  `skzl_dm` CHAR(2),
  `sksx_dm` CHAR(4),
  `djzclx_dm` CHAR(3) NOT NULL,
  `hy_dm` VARCHAR(4) NOT NULL,
  `yskm_dm` VARCHAR(9) NOT NULL,
  `ysfpbl_dm` CHAR(8) NOT NULL,
  `skgk_dm` CHAR(10) NOT NULL,
  `jdxz_dm` CHAR(9),
  `ttsjlx_dm` CHAR(2) NOT NULL,
  `tdsfyjwszg` VARCHAR(75),
  `tsczbz` CHAR(1),
  `tsczrq` DATETIME,
  `yhyywd_dm` VARCHAR(13),
  `zhmc` VARCHAR(300),
  `yhzh` VARCHAR(50),
  `tdsfyylx_dm` CHAR(3),
  `ssyhlx_dm` CHAR(3),
  `ssjmxzxl_dm` CHAR(2),
  `ssjmxzhz_dm` VARCHAR(3000),
  `ssjmxzdl_dm` CHAR(2),
  `gkdzrq` DATETIME,
  `ttjg_dm` CHAR(11) NOT NULL,
  `cktsgc_dm` CHAR(2),
  `cktsqylx_dm` VARCHAR(2),
  `hg_dm` VARCHAR(50),
  `lhjhh` VARCHAR(13),
  `cktszddhbz` CHAR(1),
  `fscgrq` DATETIME,
  `ssgly_dm` CHAR(11),
  `skssswjg_dm` CHAR(11) NOT NULL,
  `zgswskfj_dm` CHAR(11) NOT NULL,
  `swjg_dm` CHAR(11) NOT NULL,
  `lrrq` DATETIME NOT NULL,
  `lrr_dm` CHAR(11) NOT NULL,
  `xgrq` DATETIME,
  `xgr_dm` CHAR(11),
  `sjgsdq` CHAR(11) NOT NULL,
  `sjtb_sj` DATETIME(6),
  `wzfqydbbz` CHAR(1),
  `sjblbz` DECIMAL(2,0) DEFAULT 0,
  `ydtlyuuid` VARCHAR(32) NOT NULL,
  KEY `IDX_CKTS_ZS_SRTHS_DJXH` (`DJXH`),
  KEY `IDX_CKTS_ZS_SRTHS_STT` (`SKSSSWJG_DM`, `TTSJLX_DM`, `THRQ_1`),
  KEY `IDX_CKTS_ZS_SRTHS_TT` (`TTSJLX_DM`, `THRQ_1`),
  CONSTRAINT `PK_CKTS_ZS_SRTHS` PRIMARY KEY (`SRTHSUUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table CKTS_ZS_TKGZ
-- Original Oracle primary-key constraint: PK_CKTS_ZS_TKGZ (MySQL index name: PRIMARY).
CREATE TABLE `CKTS_ZS_TKGZ` (
  `tkgzuuid` VARCHAR(32) NOT NULL,
  `tzslb` CHAR(1) NOT NULL,
  `tzsly` CHAR(1) NOT NULL,
  `tzlx_dm` CHAR(1) NOT NULL,
  `djxh` DECIMAL(20,0),
  `gzbz` CHAR(1) NOT NULL,
  `btkgzuuid` VARCHAR(32),
  `pzzl_dm_1` VARCHAR(9),
  `pzrq_2` DATETIME,
  `pzhm_2` VARCHAR(40),
  `zsxm_dm` VARCHAR(5) NOT NULL,
  `zspm_dm` CHAR(9) NOT NULL,
  `yskm_dm` VARCHAR(9) NOT NULL,
  `ysfpbl_dm` CHAR(8) NOT NULL,
  `skgk_dm` CHAR(10) NOT NULL,
  `hsswjg_dm` CHAR(11),
  `skssqq` DATETIME,
  `skssqz` DATETIME,
  `swjg_dm` CHAR(11) NOT NULL,
  `je` DECIMAL(18,2) NOT NULL,
  `zsjgfzr_dm` CHAR(11) NOT NULL,
  `zsjgjsr_dm` CHAR(11) NOT NULL,
  `gzrq_1` DATETIME NOT NULL,
  `gk_dm` CHAR(10) NOT NULL,
  `gkfzr` VARCHAR(150),
  `gkjsr` VARCHAR(150),
  `dzsphm` DECIMAL(20,0) NOT NULL,
  `pzzl_dm` VARCHAR(9),
  `pzzg_dm` VARCHAR(45),
  `pzhm` VARCHAR(20),
  `wszg` VARCHAR(150) NOT NULL,
  `tkmxzsuuid` VARCHAR(32),
  `spuuid` VARCHAR(32),
  `gkgzrq` DATETIME,
  `xhrq_1` DATETIME,
  `xhr_dm` CHAR(11),
  `zfbz_1` CHAR(1),
  `zfrq_1` DATETIME,
  `zfr_dm` CHAR(11),
  `lrrq` DATETIME NOT NULL,
  `lrr_dm` CHAR(11) NOT NULL,
  `xgrq` DATETIME,
  `xgr_dm` CHAR(11),
  `sjgsdq` CHAR(11) NOT NULL,
  `fscgrq` DATETIME,
  `sjtb_sj` DATETIME(6),
  `nh` VARCHAR(10),
  `zszm_dm` CHAR(16),
  `sjblbz` DECIMAL(2,0) DEFAULT 0,
  KEY `IDX_CKTS_ZS_TKGZ_D` (`DJXH`),
  KEY `IDX_CKTS_ZS_TKGZ_XTTGZ` (`XHRQ_1`, `TZSLY`, `TZLX_DM`, `GZBZ`, `ZFRQ_1`),
  CONSTRAINT `PK_CKTS_ZS_TKGZ` PRIMARY KEY (`TKGZUUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_CQWSB_JS
-- Original Oracle primary-key constraint: PK_JS_DM (MySQL index name: PRIMARY).
CREATE TABLE `DM_CQWSB_JS` (
  `js_dm` VARCHAR(4) NOT NULL,
  `js_mc` VARCHAR(200) NOT NULL,
  `js_model` VARCHAR(300),
  `qybj` CHAR(1),
  CONSTRAINT `PK_JS_DM` PRIMARY KEY (`JS_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table DM_MSG_YWLX
-- Original Oracle primary-key constraint: DM_MSG_YWLX (MySQL index name: PRIMARY).
CREATE TABLE `DM_MSG_YWLX` (
  `ywlx_mc` VARCHAR(20) NOT NULL COMMENT '业务类型名称',
  `showorder` DECIMAL(22,0) COMMENT '展示顺序，按照升序展示',
  CONSTRAINT `DM_MSG_YWLX` PRIMARY KEY (`YWLX_MC`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='短信关联业务类型代码表';

-- Creating table DM_XZQH_QG
CREATE TABLE `DM_XZQH_QG` (
  `xzqh_dm` CHAR(6) NOT NULL COMMENT '行政区划数字代码',
  `xzqhmc` VARCHAR(150) NOT NULL COMMENT '行政区划名称',
  `sjxzqh_dm` CHAR(6) COMMENT '上级行政区划数字代码',
  `xzqhjc` CHAR(1) NOT NULL COMMENT '行政区划级次（1省级 2市级 3区县）',
  `yxbz` CHAR(1) NOT NULL COMMENT '有效标志',
  `ssxzqmc` VARCHAR(150) COMMENT '所属行政区名称||所属行政区',
  `gfxbz` CHAR(1) NOT NULL COMMENT '高风险地区标志  1 高风险 0正常',
  KEY `I_DM_XZQH_QG_1` (`XZQH_DM`, `SJXZQH_DM`),
  KEY `I_DM_XZQH_QG_2` (`SJXZQH_DM`, `XZQH_DM`),
  KEY `I_DM_XZQH_QG_4` (`SJXZQH_DM`, `XZQH_DM`, `YXBZ`),
  UNIQUE KEY `PK_DM_XZQH_QG` (`XZQH_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='行政区划代码';

-- Creating table FXGL_DATA_FXYDJG
-- FXGL_DATA_FXYDJG.id: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- Original Oracle primary-key constraint: PK_FXGL_DATA_FXYDJG (MySQL index name: PRIMARY).
CREATE TABLE `FXGL_DATA_FXYDJG` (
  `id` DECIMAL(65,27) NOT NULL COMMENT 'ID主键',
  `tsswjg_dm` CHAR(11) COMMENT '填报单位',
  `tbr` VARCHAR(20) COMMENT '填报人',
  `tbrq` DATETIME COMMENT '填报日期',
  `ssny` VARCHAR(20) COMMENT '所属年月',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `shxyno` VARCHAR(20) COMMENT '统一社会信用代码',
  `nsrmc` VARCHAR(200) COMMENT '企业名称',
  `fxrwly_dm` CHAR(2) NOT NULL COMMENT '风险任务来源(FXGL_DM_FXRWLY，单选)',
  `rwfxqj_mycke` DECIMAL(18,2) COMMENT '任务分析期间涉及出口额（万美元）',
  `rwfxqj_sbmycke` DECIMAL(18,2) COMMENT '任务分析期间涉及申报退税出口额（万美元）',
  `rwfxqj_bltse` DECIMAL(18,2) COMMENT '任务分析期间内办理退税额（万元）',
  `fxydcs_jh` VARCHAR(100) COMMENT '风险应对措施集合(FXGL_DM_FXYDCS，多选)',
  `byts` DECIMAL(18,2) COMMENT '不予退税额（万元）',
  `yzhts` DECIMAL(18,2) COMMENT '追回（补缴方式）退税额（万元）',
  `stnxzs` DECIMAL(18,2) COMMENT '视同内销征税额（万元）',
  `zhts` DECIMAL(18,2) COMMENT '暂缓退税额（万元）',
  `jxsezc` DECIMAL(18,2) COMMENT '进项转出税额（万元）',
  `ybjzzs` DECIMAL(18,2) COMMENT '应补交增值税税款额（万元）',
  `ybjsds` DECIMAL(18,2) COMMENT '应补缴或调增企业所得税税款额（万元）',
  `ybjqtsz` DECIMAL(18,2) COMMENT '应补缴其他税种税款额（万元）',
  `bz` VARCHAR(1000) COMMENT '备注',
  `tsswjg_mc` VARCHAR(300) COMMENT '税务机关名称',
  `spdm2mc` VARCHAR(250) COMMENT '涉及商品代码及名称',
  `bytscke` DECIMAL(18,2) COMMENT '不予退税出口额（万美元）',
  `yzhtscdfs` DECIMAL(18,2) COMMENT '追回（冲抵方式）退税额（万元）',
  `pscke` DECIMAL(18,2) COMMENT '涉嫌骗税出口额（万美元）',
  `pstse` DECIMAL(18,2) COMMENT '涉嫌骗税申报退税额（万元）',
  `pszhtse` DECIMAL(18,2) COMMENT '涉嫌骗税暂缓退税额（万元）',
  `sfysjc` CHAR(1) DEFAULT 'N' COMMENT '是否移送稽查',
  `jcpscke` DECIMAL(18,2) COMMENT '移送稽查涉嫌骗税出口额（万美元）',
  `jcpstse` DECIMAL(18,2) COMMENT '移送稽查涉嫌骗税退税额（万元）',
  `jcqrpstse` DECIMAL(18,2) COMMENT '稽查已定性骗取退税额（万元）',
  `jcrktse` DECIMAL(18,2) COMMENT '稽查已追缴入库退税额（万元）',
  `jczhtse` DECIMAL(18,2) COMMENT '稽查暂缓退税（万元）',
  `sfysga` CHAR(1) DEFAULT 'N' COMMENT '是否移送公安',
  `fxydyrkje` DECIMAL(18,2) COMMENT '风险应对应入库金额（万元）',
  `fxydrkje` DECIMAL(18,2) COMMENT '风险应对已入库金额（万元）',
  `rwyqsj` DATETIME COMMENT '任务要求完成时限',
  `rwwcsj` DATETIME COMMENT '金三系统中任务完成时间',
  `lcslid` VARCHAR(32) COMMENT '审核系统流程受理ID',
  `fxrwpcmc` VARCHAR(100) COMMENT '风险任务批次名称',
  `qylx` VARCHAR(64) COMMENT '企业类型',
  `ybjsds2` DECIMAL(18,2) COMMENT '应调增应纳税所得额（万元）',
  `sfhcywt` CHAR(1) COMMENT '是否核查有问题',
  CONSTRAINT `PK_FXGL_DATA_FXYDJG` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='风险应对结果明细表';

-- Creating table FXGL_DATA_FZPCKQY
-- Original Oracle primary-key constraint: PK_FXGL_DATA_FZPCKQY (MySQL index name: PRIMARY).
CREATE TABLE `FXGL_DATA_FZPCKQY` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `ck_fzp` DECIMAL(18,2) COMMENT '纺织品出口额（人民币）',
  `ck_rmb` DECIMAL(18,2) COMMENT '出口额（人民币）',
  `ck_my` DECIMAL(18,2) COMMENT '出口额（美元）',
  `ck_zl_cd` DECIMAL(16,4) COMMENT '出口重量（千克，对应单位米）',
  `ck_cd_zl` DECIMAL(16,4) COMMENT '出口长度（米，对应单位千克）',
  `ck_zl_sl` DECIMAL(16,4) COMMENT '出口重量（千克，对应单位件）',
  `ck_sl_zl` DECIMAL(16,4) COMMENT '出口数量（件，对应单位千克）',
  `ck_zl_all` DECIMAL(16,4) COMMENT '出口总重量',
  `ck_gj_m` DECIMAL(16,4) COMMENT '出口每米公斤数',
  `ck_gj_m_pj` DECIMAL(16,4) COMMENT '出口每米公斤平均数',
  `ck_gj_j` DECIMAL(16,4) COMMENT '出口每件公斤数',
  `ck_gj_j_pj` DECIMAL(16,4) COMMENT '出口每件公斤平均数',
  `ck_dj_gj` DECIMAL(16,4) COMMENT '出口每公斤单价',
  `ck_dj_gj_pj` DECIMAL(16,4) COMMENT '出口每公斤平均单价',
  `qbxssr` DECIMAL(18,2) COMMENT '全部销售收入',
  `fzp_ckbl` DECIMAL(10,6) COMMENT '纺织品出口比例',
  `zc_ch_qcye` DECIMAL(18,2) COMMENT '资产负债表存货期初余额',
  `zc_ch_qmye` DECIMAL(18,2) COMMENT '资产负债表存货期末余额',
  `zc_ch_zye` DECIMAL(18,2) COMMENT '资产负债表存货总金额',
  `nsrsbh` VARCHAR(20) COMMENT '纳税人识别号',
  `jh_zzl` DECIMAL(16,4) COMMENT '进货总重量',
  `jh_zje` DECIMAL(18,2) COMMENT '进货总金额',
  `jh_dj_gj` DECIMAL(16,4) COMMENT '进货每公斤单价',
  `jh_dj_gj_pj` DECIMAL(16,4) COMMENT '进货每公斤平均单价',
  `jh_dj_m` DECIMAL(16,4) COMMENT '进货每米单价',
  `jh_dj_m_pj` DECIMAL(16,4) COMMENT '进货每米平均单价',
  `nx_zzl` DECIMAL(16,4) COMMENT '内销总重量',
  `nx_zje` DECIMAL(18,2) COMMENT '内销总金额',
  `dl_je` DECIMAL(18,2) COMMENT '电力金额',
  CONSTRAINT `PK_FXGL_DATA_FZPCKQY` PRIMARY KEY (`DJXH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='纺织品出口企业风险分析模型，部分字段来源于zj_bjts同名表';

-- Creating table FXGL_DATA_FZPCKQY_FPXX
-- Original Oracle primary-key constraint: PK_FXGL_DATA_FZPCKQY_FPXX (MySQL index name: PRIMARY).
-- Original full-column index IDX_FXGL_DATA_FZPCKQY_FPXX_GS: (GMFDJXH, SPBM5, XMMC, DW) exceeds InnoDB 3072 bytes; same non-unique index name/column order retained with explicit prefixes {'XMMC': 380, 'DW': 380}. Column values are not shortened.
-- Original full-column index IDX_FXGL_DATA_FZPCKQY_FPXX_XS: (XHFDJXH, SPBM5, XMMC, DW) exceeds InnoDB 3072 bytes; same non-unique index name/column order retained with explicit prefixes {'XMMC': 380, 'DW': 380}. Column values are not shortened.
CREATE TABLE `FXGL_DATA_FZPCKQY_FPXX` (
  `fphm` VARCHAR(30) NOT NULL COMMENT '发票号码',
  `xh` DECIMAL(10,0) NOT NULL COMMENT '序号',
  `kprq` DATETIME(6) COMMENT '开票日期',
  `xsfnsrsbh` VARCHAR(20) COMMENT '销售方纳税人识别代号',
  `xsfmc` VARCHAR(900) NOT NULL COMMENT '销售方名称',
  `xhfdjxh` DECIMAL(20,0) COMMENT '销货方登记序号',
  `gmfnsrsbh` VARCHAR(60) COMMENT '购买方纳税人识别号',
  `gmfmc` VARCHAR(900) NOT NULL COMMENT '购买方名称',
  `gmfdjxh` DECIMAL(20,0) COMMENT '购买方登记序号',
  `sphfwssflhbbm` VARCHAR(19) COMMENT '商品和服务税收分类合并编码',
  `spfwjc` VARCHAR(360) NOT NULL COMMENT '商品服务简称||税编里的货劳名称',
  `xmmc` VARCHAR(1800) NOT NULL COMMENT '项目名称',
  `ggxh` VARCHAR(450) COMMENT '规格型号',
  `dw` VARCHAR(900) COMMENT '单位',
  `fpspdj` VARCHAR(25) COMMENT '单价',
  `fpspsl` VARCHAR(25) COMMENT '数量',
  `je` DECIMAL(18,2) NOT NULL COMMENT '金额',
  `sl_1` DECIMAL(16,6) NOT NULL COMMENT '税率',
  `se` DECIMAL(18,6) NOT NULL COMMENT '税额',
  `spbm5` VARCHAR(5) COMMENT '税收分类编码大类',
  `sl` DECIMAL(25,13) COMMENT '数量',
  KEY `IDX_FXGL_DATA_FZPCKQY_FPXX_G` (`GMFDJXH`),
  KEY `IDX_FXGL_DATA_FZPCKQY_FPXX_GS` (`GMFDJXH`, `SPBM5`, `XMMC`(380), `DW`(380)),
  KEY `IDX_FXGL_DATA_FZPCKQY_FPXX_X` (`XHFDJXH`),
  KEY `IDX_FXGL_DATA_FZPCKQY_FPXX_XS` (`XHFDJXH`, `SPBM5`, `XMMC`(380), `DW`(380)),
  CONSTRAINT `PK_FXGL_DATA_FZPCKQY_FPXX` PRIMARY KEY (`FPHM`, `XH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='纺织品出口企业发票信息';

-- Creating table FXGL_DATA_FZPCKQY_JXMX
CREATE TABLE `FXGL_DATA_FZPCKQY_JXMX` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `spbm5` VARCHAR(5) NOT NULL COMMENT '税收分类编码大类',
  `xmmc` VARCHAR(1800) NOT NULL COMMENT '项目名称',
  `dw` VARCHAR(900) NOT NULL COMMENT '单位',
  `sl` DECIMAL(25,13) COMMENT '数量',
  `je` DECIMAL(18,2) COMMENT '金额',
  `se` DECIMAL(18,6) COMMENT '税额'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='纺织品出口企业原材料进货分类';

-- Creating table FXGL_DATA_FZPCKQY_JXXX
CREATE TABLE `FXGL_DATA_FZPCKQY_JXXX` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `spbm5` VARCHAR(5) NOT NULL COMMENT '税收分类编码大类',
  `jh_sl_kg` DECIMAL(20,10) COMMENT '数量（公斤）',
  `jh_je_kg` DECIMAL(18,2) COMMENT '金额（公斤）',
  `jh_dj_kg` DECIMAL(16,4) COMMENT '单价（公斤）',
  `jh_dj_kg_pj` DECIMAL(16,4) COMMENT '平均单价（公斤）',
  `jh_sl_m` DECIMAL(25,13) COMMENT '数量（米）',
  `jh_je_m` DECIMAL(18,2) COMMENT '金额（米）',
  `jh_dj_m` DECIMAL(16,4) COMMENT '单价（米）',
  `jh_dj_m_pj` DECIMAL(16,4) COMMENT '平均单价（米）',
  `jh_je_notkg` DECIMAL(18,2) COMMENT '金额（非公斤米单位）',
  `jh_gj_m` DECIMAL(16,4) COMMENT '出口每米公斤数'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table FXGL_DATA_FZPCKQY_NXMX
CREATE TABLE `FXGL_DATA_FZPCKQY_NXMX` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `spbm5` VARCHAR(5) NOT NULL COMMENT '税收分类编码大类',
  `xmmc` VARCHAR(1800) NOT NULL COMMENT '项目名称',
  `dw` VARCHAR(900) NOT NULL COMMENT '单位',
  `sl` DECIMAL(25,13) COMMENT '数量',
  `je` DECIMAL(18,2) COMMENT '金额',
  `se` DECIMAL(18,6) COMMENT '税额'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='纺织品出口企业内销分类';

-- Creating table FXGL_DATA_FZPCKQY_NXXX
CREATE TABLE `FXGL_DATA_FZPCKQY_NXXX` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `spbm5` VARCHAR(5) NOT NULL COMMENT '税收分类编码大类',
  `nx_sl_kg` DECIMAL(25,13) COMMENT '数量（公斤）',
  `nx_je_kg` DECIMAL(18,2) COMMENT '金额（公斤）',
  `nx_dj_kg` DECIMAL(16,4) COMMENT '单价（公斤）',
  `nx_dj_kg_pj` DECIMAL(16,4) COMMENT '平均单价（公斤）',
  `nx_je_notkg` DECIMAL(18,2) COMMENT '金额（非公斤米单位）'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table FXGL_DATA_STZC
-- Original Oracle primary-key constraint: PK_FXGL_DATA_STZC (MySQL index name: PRIMARY).
CREATE TABLE `FXGL_DATA_STZC` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `sbts_cke` DECIMAL(18,2) COMMENT '申报退税出口额（人民币）',
  `sbts_wgcke` DECIMAL(18,2) COMMENT '申报退税外购出口额（人民币）',
  `nsrsbh` VARCHAR(20) COMMENT '纳税人识别号',
  `nsrmc` VARCHAR(300) COMMENT '纳税人名称',
  `zgswj_dm` VARCHAR(11) COMMENT '主管税务机关代码',
  `zgswj_mc` VARCHAR(300) COMMENT '主管税务机关名称',
  `hy_dm` VARCHAR(4) COMMENT '行业代码',
  `hy_mc` VARCHAR(100) COMMENT '行业名称',
  `nsrzt_dm` CHAR(2) COMMENT '纳税人状态',
  `barq` DATETIME COMMENT '备案日期',
  `bachbz` CHAR(1) COMMENT '备案撤回标志',
  `ckhwtmsjsff_dm` CHAR(1) COMMENT '出口货物退(免)税计算方法代码',
  `fp_cke` DECIMAL(18,2) COMMENT '发票出口额（人民币）',
  `fp_gje` DECIMAL(18,2) COMMENT '发票购进额（人民币）',
  `yswg_ckje_bm` DECIMAL(18,2) COMMENT '疑似外购出口金额（编码）',
  `yswg_ckzb_bm` DECIMAL(9,2) COMMENT '疑似外购出口占比（编码）',
  `yswg_ckje_mc` DECIMAL(18,2) COMMENT '疑似外购出口金额（名称）',
  `yswg_ckzb_mc` DECIMAL(9,2) COMMENT '疑似外购出口占比（名称）',
  `gjsb_minkprq` DATETIME COMMENT '购进设备最早开票日期',
  `gjsb_zje` DECIMAL(18,2) COMMENT '购进设备总金额',
  `gjsb_xgm_pp` DECIMAL(18,2) COMMENT '购进小规模普票金额',
  `gjsb_xgm_zp` DECIMAL(18,2) COMMENT '购进小规模专票金额',
  `gjsb_zb_pp` DECIMAL(9,2) COMMENT '购进小规模普票占比',
  `etl_bz` CHAR(1) COMMENT 'ETL分布处理标志，ETL提取前置‘1’，待存储过程更新后置‘2’',
  CONSTRAINT `PK_FXGL_DATA_STZC` PRIMARY KEY (`DJXH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='生产企业出口外购货物风险模型';

-- Creating table FXGL_DATA_STZC_CKMX
CREATE TABLE `FXGL_DATA_STZC_CKMX` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `sphfwssflhbbm` VARCHAR(19) NOT NULL COMMENT '税收分类编码',
  `xmmc` VARCHAR(1800) NOT NULL COMMENT '项目名称',
  `je` DECIMAL(18,2) COMMENT '金额'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口外购货物生产企业出口分类';

-- Creating table FXGL_DATA_STZC_FPXX
-- Original Oracle primary-key constraint: PK_FXGL_DATA_STZC_FPXX (MySQL index name: PRIMARY).
-- Original full-column index IDX_FXGL_DATA_STZC_FPXX_GS: (GMFDJXH, SPHFWSSFLHBBM, XMMC) exceeds InnoDB 3072 bytes; same non-unique index name/column order retained with explicit prefixes {'XMMC': 746}. Column values are not shortened.
-- Original full-column index IDX_FXGL_DATA_STZC_FPXX_XS: (XHFDJXH, SPHFWSSFLHBBM, XMMC) exceeds InnoDB 3072 bytes; same non-unique index name/column order retained with explicit prefixes {'XMMC': 746}. Column values are not shortened.
CREATE TABLE `FXGL_DATA_STZC_FPXX` (
  `fphm` VARCHAR(30) NOT NULL COMMENT '发票号码',
  `xh` DECIMAL(10,0) NOT NULL COMMENT '序号',
  `kprq` DATETIME(6) COMMENT '开票日期',
  `xsfnsrsbh` VARCHAR(20) COMMENT '销售方纳税人识别代号',
  `xhfdjxh` DECIMAL(20,0) COMMENT '销货方登记序号',
  `gmfnsrsbh` VARCHAR(60) COMMENT '购买方纳税人识别号',
  `gmfdjxh` DECIMAL(20,0) COMMENT '购买方登记序号',
  `sphfwssflhbbm` VARCHAR(19) COMMENT '商品和服务税收分类合并编码',
  `xmmc` VARCHAR(1800) COMMENT '项目名称',
  `fpspdj` VARCHAR(25) COMMENT '单价',
  `fpspsl` VARCHAR(25) COMMENT '数量',
  `je` DECIMAL(18,2) NOT NULL COMMENT '金额',
  `sl_1` DECIMAL(16,6) NOT NULL COMMENT '税率',
  `se` DECIMAL(18,6) NOT NULL COMMENT '税额',
  `bz` VARCHAR(1000) COMMENT '备注',
  KEY `IDX_FXGL_DATA_STZC_FPXX_G` (`GMFDJXH`),
  KEY `IDX_FXGL_DATA_STZC_FPXX_GS` (`GMFDJXH`, `SPHFWSSFLHBBM`, `XMMC`(746)),
  KEY `IDX_FXGL_DATA_STZC_FPXX_X` (`XHFDJXH`),
  KEY `IDX_FXGL_DATA_STZC_FPXX_XS` (`XHFDJXH`, `SPHFWSSFLHBBM`, `XMMC`(746)),
  CONSTRAINT `PK_FXGL_DATA_STZC_FPXX` PRIMARY KEY (`FPHM`, `XH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口外购货物生产企业发票信息';

-- Creating table FXGL_DATA_STZC_FPXX_GJ
-- Original Oracle primary-key constraint: PK_FXGL_DATA_STZC_FPXX_GJ (MySQL index name: PRIMARY).
-- Original full-column index IDX_FXGL_DATA_STZC_FPXX_GJ_GS: (GMFDJXH, SPHFWSSFLHBBM, XMMC) exceeds InnoDB 3072 bytes; same non-unique index name/column order retained with explicit prefixes {'XMMC': 746}. Column values are not shortened.
CREATE TABLE `FXGL_DATA_STZC_FPXX_GJ` (
  `fphm` VARCHAR(30) NOT NULL COMMENT '发票号码',
  `xh` DECIMAL(10,0) NOT NULL COMMENT '序号',
  `kprq` DATETIME(6) COMMENT '开票日期',
  `xsfnsrsbh` VARCHAR(20) COMMENT '销售方纳税人识别代号',
  `xhfdjxh` DECIMAL(20,0) COMMENT '销货方登记序号',
  `gmfnsrsbh` VARCHAR(60) COMMENT '购买方纳税人识别号',
  `gmfdjxh` DECIMAL(20,0) COMMENT '购买方登记序号',
  `sphfwssflhbbm` VARCHAR(19) COMMENT '商品和服务税收分类合并编码',
  `xmmc` VARCHAR(1800) COMMENT '项目名称',
  `fpspdj` VARCHAR(25) COMMENT '单价',
  `fpspsl` VARCHAR(25) COMMENT '数量',
  `je` DECIMAL(18,2) NOT NULL COMMENT '金额',
  `sl_1` DECIMAL(16,6) NOT NULL COMMENT '税率',
  `se` DECIMAL(18,6) NOT NULL COMMENT '税额',
  `bz` VARCHAR(1000) COMMENT '备注',
  `fplb` VARCHAR(20) COMMENT '发票类别（专票、普票）',
  KEY `IDX_FXGL_DATA_STZC_FPXX_GJ_G` (`GMFDJXH`),
  KEY `IDX_FXGL_DATA_STZC_FPXX_GJ_GS` (`GMFDJXH`, `SPHFWSSFLHBBM`, `XMMC`(746)),
  CONSTRAINT `PK_FXGL_DATA_STZC_FPXX_GJ` PRIMARY KEY (`FPHM`, `XH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='生产企业购进设备发票信息';

-- Creating table FXGL_DATA_STZC_JXMX
CREATE TABLE `FXGL_DATA_STZC_JXMX` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `sphfwssflhbbm` VARCHAR(19) NOT NULL COMMENT '税收分类编码',
  `xmmc` VARCHAR(1800) NOT NULL COMMENT '项目名称',
  `je` DECIMAL(18,2) COMMENT '金额'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口外购货物生产企业进货分类';

-- Creating table FXGL_DATA_STZC_YSWG_BM
CREATE TABLE `FXGL_DATA_STZC_YSWG_BM` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `sphfwssflhbbm` VARCHAR(19) NOT NULL COMMENT '税收分类编码',
  `ckje` DECIMAL(18,2) COMMENT '出口金额',
  `jhje` DECIMAL(18,2) COMMENT '进货金额',
  `yswg_bfb` DECIMAL(9,2) COMMENT '疑似外购百分比',
  `yswg_ckje` DECIMAL(18,2) COMMENT '疑似外购出口金额'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口外购货物生产企业按编码疑似外购分析';

-- Creating table FXGL_DATA_STZC_YSWG_MC
CREATE TABLE `FXGL_DATA_STZC_YSWG_MC` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `sphfwssflhbbm` VARCHAR(19) NOT NULL COMMENT '税收分类编码',
  `xmmc` VARCHAR(1800) NOT NULL COMMENT '项目名称',
  `ckje` DECIMAL(18,2) COMMENT '出口金额',
  `jhje` DECIMAL(18,2) COMMENT '进货金额',
  `yswg_bfb` DECIMAL(9,2) COMMENT '疑似外购百分比',
  `yswg_ckje` DECIMAL(18,2) COMMENT '疑似外购出口金额'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口外购货物生产企业按名称疑似外购分析';

-- Creating table FXGL_DATA_YCFP
-- Original Oracle primary-key constraint: PK_FXGL_DATA_YCFP (MySQL index name: PRIMARY).
CREATE TABLE `FXGL_DATA_YCFP` (
  `tsswjg_dm` CHAR(11) COMMENT '退税税务机关代码',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `jhpzh` VARCHAR(75) NOT NULL COMMENT '进货凭证号/专用税票号',
  `kprq` DATETIME COMMENT '开票日期',
  `gfnsrsbh` VARCHAR(20) COMMENT '购买方税号',
  `ghfmc` VARCHAR(300) COMMENT '购买方名称',
  `xfnsrsbh` VARCHAR(20) COMMENT '销售方税号',
  `xhfmc` VARCHAR(300) COMMENT '销售方明细',
  `je` DECIMAL(18,2) COMMENT '原始发票计税金额',
  `sbfpjsje` DECIMAL(18,2) COMMENT '申报退税计税金额',
  `hzcjjsje` DECIMAL(18,2) COMMENT '红字冲减计税金额',
  `hzcjrq` DATETIME COMMENT '红字冲减日期',
  `hzfphm` VARCHAR(75) COMMENT '红字发票号码',
  CONSTRAINT `PK_FXGL_DATA_YCFP` PRIMARY KEY (`JHPZH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table FXGL_DATA_ZXZB
-- FXGL_DATA_ZXZB.id: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- Original Oracle primary-key constraint: PK_FXGL_DATA_ZXZB (MySQL index name: PRIMARY).
CREATE TABLE `FXGL_DATA_ZXZB` (
  `id` DECIMAL(65,27) NOT NULL COMMENT 'ID主键',
  `tsswjg_dm` CHAR(11) COMMENT '所属税务机关',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `nsrsbh` VARCHAR(20) COMMENT '税号',
  `nsrmc` VARCHAR(300) COMMENT '名称',
  `smlx` CHAR(1) COMMENT '扫描类型（0自动扫描/1手动刷新）',
  `smrq` DATETIME COMMENT '扫描日期',
  `smjg` VARCHAR(300) COMMENT '扫描结果描述',
  `zbid` VARCHAR(30) COMMENT '专项监管指标ID',
  `zbcs` VARCHAR(300) COMMENT '指标参数集合，因不同时期参数有差异，记录扫描时涉及各项指标值',
  `hsjglx` CHAR(1) DEFAULT '0' COMMENT '核实结果类型（0未核实/1已核实），后续可能会增加类型',
  `hsrq` DATETIME COMMENT '核实日期',
  `hsry` VARCHAR(200) COMMENT '核实人员',
  `hsclqk` VARCHAR(2000) COMMENT '核实处理情况',
  KEY `IDX_FXGL_DATA_ZXZB_DZS` (`DJXH`, `ZBID`, `SMRQ`),
  CONSTRAINT `PK_FXGL_DATA_ZXZB` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table FXGL_PZ_ZB
-- Original Oracle primary-key constraint: PK_FXGL_PZ_ZB (MySQL index name: PRIMARY).
CREATE TABLE `FXGL_PZ_ZB` (
  `zb_id` VARCHAR(30) NOT NULL COMMENT '指标标识 ',
  `zb_cname` VARCHAR(80) COMMENT '指标名称 ',
  `zb_sname` VARCHAR(50) COMMENT '指标简称 ',
  `zb_type` VARCHAR(20) COMMENT '指标模式,表示指标结果值的生成方法，派生型是根据其他指标叠加时期范围或群体范围得到的关联指标 公式型/SQL型/派生型',
  `ywfl_dm` VARCHAR(20) COMMENT '业务分类，关联 JKGL_DM_YWFL',
  `datatype` CHAR(1) COMMENT '数据类型,针对指标结果值 数值型',
  `showformat` CHAR(1) COMMENT '显示格式 默认/百分比/金额/整数',
  `apply_hy` VARCHAR(200) COMMENT '适用行业（可多选） 关联行业代码表',
  `apply_qy` VARCHAR(20) COMMENT '适用企业类型 空=全部/1生产/2外贸',
  `zb_fomula` VARCHAR(4000) COMMENT '指标公式。利用数据项、指标元、指标、指标参数、维度的计算公式伪代码 ',
  `refresh_cycle` VARCHAR(10) COMMENT '刷新周期 日/周/月/季/半年/年',
  `ywms` VARCHAR(4000) COMMENT '业务描述 ',
  `bbh` VARCHAR(10) COMMENT '版本号 ',
  `js_yxj` DECIMAL(38,0) COMMENT '计算优先级（小值优先）',
  `yxbz` CHAR(1) COMMENT '有效标志 Y /N',
  `rs_type` VARCHAR(20) COMMENT '指标结果类型',
  CONSTRAINT `PK_FXGL_PZ_ZB` PRIMARY KEY (`ZB_ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='健康管理-配置-指标';

-- Creating table FXGL_PZ_ZB_CS
-- Original Oracle primary-key constraint: PK_FXGL_PZ_ZB_CS (MySQL index name: PRIMARY).
CREATE TABLE `FXGL_PZ_ZB_CS` (
  `csbm` VARCHAR(50) NOT NULL COMMENT '参数编码（PK）',
  `csmc` VARCHAR(100) COMMENT '参数名称',
  `zb_id` VARCHAR(30) COMMENT '指标标识 ',
  `datatype` CHAR(1) COMMENT '数据类型 1字符型/2数值型/3日期型/4逻辑型',
  `val_def` VARCHAR(100) COMMENT '全省默认值',
  `note` VARCHAR(200) COMMENT '说明',
  `yxbz` CHAR(1) COMMENT '有效标志',
  `cstype` VARCHAR(10) COMMENT '参数类型：数量、数值、金额、美元、百分比',
  CONSTRAINT `PK_FXGL_PZ_ZB_CS` PRIMARY KEY (`CSBM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='指标参数配置';

-- Creating table FXGL_PZ_ZB_CS_SWJG
-- Original Oracle primary-key constraint: PK_FXGL_PZ_ZB_CS_SWJG (MySQL index name: PRIMARY).
CREATE TABLE `FXGL_PZ_ZB_CS_SWJG` (
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `csbm` VARCHAR(50) NOT NULL COMMENT '参数编码（PK）',
  `val_def` VARCHAR(100) COMMENT '参数值',
  `yxbz` CHAR(1) COMMENT '有效标志Y/N',
  CONSTRAINT `PK_FXGL_PZ_ZB_CS_SWJG` PRIMARY KEY (`SWJG_DM`, `CSBM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='指标参数税务机关自定义';

-- Creating table FXGL_PZ_ZB_TASK
-- Original Oracle primary-key constraint: F_P_Z_T_PK (MySQL index name: PRIMARY).
CREATE TABLE `FXGL_PZ_ZB_TASK` (
  `id` DECIMAL(20,0) NOT NULL,
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `sqr_xm` VARCHAR(20) NOT NULL COMMENT '申请人姓名',
  `sqr_dm` VARCHAR(20) NOT NULL COMMENT '申请人代码',
  `zb_id` VARCHAR(20) NOT NULL COMMENT '指标ID',
  `sqsj` DATETIME NOT NULL COMMENT '申请时间',
  `ztbz` CHAR(1) COMMENT '0、已提交 1、出理中 2、处理完成 、9、处理失败',
  `tqbs` VARCHAR(50) COMMENT '提取标识',
  `clkssj` DATETIME COMMENT '处理开始时间',
  `clwcsj` DATETIME COMMENT '处理完成时间',
  CONSTRAINT `F_P_Z_T_PK` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table FXGL_SZ_SPFXCK
-- Original Oracle primary-key constraint: PK_FXGL_SZ_SPFXCK (MySQL index name: PRIMARY).
CREATE TABLE `FXGL_SZ_SPFXCK` (
  `id` DECIMAL(32,0) NOT NULL COMMENT 'ID主键',
  `tsswjg_dm` CHAR(11) COMMENT '填报单位',
  `tbr` VARCHAR(20) COMMENT '填报人',
  `tbrq` DATETIME COMMENT '填报日期',
  `gz_fw_swjg` VARCHAR(11) COMMENT '适用机关范围（根据填报单位有效位数自动调用，省局133杭州13301…）',
  `gz_fw_data` CHAR(1) COMMENT '适用业务范围（1出口电子信息2申报出口明细3同时适用）',
  `gz_mc` VARCHAR(200) COMMENT '规则名称',
  `gz_fxms` VARCHAR(200) COMMENT '风险描述',
  `gz_spdm` VARCHAR(200) COMMENT '商品代码',
  `gz_spmc` VARCHAR(200) COMMENT '商品名称',
  `gz_ggxh` VARCHAR(200) COMMENT '规格型号',
  `gz_ckka` VARCHAR(200) COMMENT '出口口岸',
  `gz_ckgb` VARCHAR(200) COMMENT '出口国别',
  `gz_hyd` VARCHAR(200) COMMENT '货源地',
  `gz_djq` DECIMAL(18,2) COMMENT '单价范围起（美元）',
  `gz_djz` DECIMAL(18,2) COMMENT '单价范围止（美元）',
  `gz_yxqz` DATETIME COMMENT '有效期止',
  `gz_dxtxbz` CHAR(1) COMMENT '生成短信提醒标志(Y/N)',
  `qybj` CHAR(1) COMMENT '启用标志(Y/N)',
  `tsswjg_mc` VARCHAR(60),
  `gz_zjq` DECIMAL(18,2) COMMENT '总价范围起（美元）',
  `gz_zjz` DECIMAL(18,2) COMMENT '总价范围止（美元）',
  CONSTRAINT `PK_FXGL_SZ_SPFXCK` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='商品风险出口维护';

-- Creating table FXGL_SZ_SPFXJH
-- Original Oracle primary-key constraint: PK_FXGL_SZ_SPFXJH (MySQL index name: PRIMARY).
CREATE TABLE `FXGL_SZ_SPFXJH` (
  `id` DECIMAL(32,0) NOT NULL COMMENT 'ID主键',
  `tsswjg_dm` CHAR(11) COMMENT '填报单位',
  `tbr` VARCHAR(20) COMMENT '填报人',
  `tbrq` DATETIME COMMENT '填报日期',
  `gz_fw_swjg` VARCHAR(11) COMMENT '适用机关范围（根据填报单位有效位数自动调用，省局133杭州13301…）',
  `gz_fw_data` CHAR(1) COMMENT '适用业务范围（1进货电子信息2申报进货明细3同时适用）',
  `gz_mc` VARCHAR(100) COMMENT '规则名称',
  `gz_fxms` VARCHAR(200) COMMENT '风险描述',
  `gz_ghdqdm` VARCHAR(10) COMMENT '供货地区代码',
  `gz_ghdqmc` VARCHAR(100) COMMENT '供货地区名称',
  `gz_ghqysh` VARCHAR(20) COMMENT '供货企业税号',
  `gz_ghqymc` VARCHAR(100) COMMENT '供货企业名称',
  `gz_spdm` VARCHAR(20) COMMENT '商品代码',
  `gz_spmc` VARCHAR(200) COMMENT '商品名称',
  `gz_yxqz` DATETIME COMMENT '有效期止',
  `gz_dxtxbz` CHAR(1) COMMENT '生成短信提醒标志(Y/N)',
  `qybj` CHAR(1) COMMENT '启用标志(Y/N)',
  `tsswjg_mc` VARCHAR(60),
  `fhxxbuuid` VARCHAR(60),
  CONSTRAINT `PK_FXGL_SZ_SPFXJH` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='商品风险进货维护';

-- Creating table FXNK_DM_NKZB
-- Original Oracle primary-key constraint: FXNK_DM_NKZB_PRI (MySQL index name: PRIMARY).
CREATE TABLE `FXNK_DM_NKZB` (
  `nkzbbh` VARCHAR(10) NOT NULL COMMENT '内控指标编号（后续作为主键）',
  `nkzbbb` VARCHAR(6) COMMENT '内控指标版本（需求提交月份）',
  `nkzbxh` DECIMAL(2,0) COMMENT '内控指标序号（对应内控需求文档中的顺序号）',
  `nkzbmxxh` DECIMAL(2,0) COMMENT '内控指标明细序号（对应内控需求文档中数据口径的拆分顺序号）',
  `nkzblb` VARCHAR(20) COMMENT '内控指标类别（态势感知归类）',
  `nkzbmc` VARCHAR(300) COMMENT '内控指标名称',
  `nkfxdj` VARCHAR(20) COMMENT '风险程度（高中低）',
  `nkywly` VARCHAR(100) COMMENT '业务领域',
  `nkywms` VARCHAR(1000) COMMENT '业务描述',
  `nksjly` VARCHAR(1000) COMMENT '数据来源（金三前台数据源描述）',
  `nkkjms` VARCHAR(4000) COMMENT '口径说明（对应后台数据表口径描述）',
  `nkuuidb` VARCHAR(100) COMMENT '内控风险点UUID对应表',
  `sqtxlx` CHAR(1) COMMENT '事前提醒类型（0否/1是）',
  `szyjlx` CHAR(1) COMMENT '事中预警类型（0否/1提醒/2阻断）',
  `shjdlx` CHAR(1) COMMENT '事后监督类型（0否/1是）',
  `kstxgzr` DECIMAL(5,2) COMMENT '开始提醒工作日',
  `ksjdgzr` DECIMAL(5,2) COMMENT '开始监督工作日',
  `nkywlb` VARCHAR(20) COMMENT '内控业务类别（用于辅助态势感知归类）',
  `nkywbm` VARCHAR(20) COMMENT '内控业务编码（用于辅助态势感知归类及剔除重复指标）',
  `wcbz` CHAR(1),
  CONSTRAINT `FXNK_DM_NKZB_PRI` PRIMARY KEY (`NKZBBH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table FXNK_NBFXDMX_SH
CREATE TABLE `FXNK_NBFXDMX_SH` (
  `uuid` VARCHAR(32) NOT NULL COMMENT '内控业务关键字',
  `swjgdm` CHAR(11) COMMENT '税务机关代码',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `nsrsbh` VARCHAR(20) COMMENT '税号',
  `nsrmc` VARCHAR(300) COMMENT '名称',
  `lcswsx_dm` VARCHAR(16) COMMENT '流程税务事项代码',
  `lcslid` VARCHAR(32) COMMENT '流程实例ID',
  `fssj` DATETIME COMMENT '发生时间',
  `sjtbsj` DATETIME COMMENT '数据同步时间',
  `nkzbbh` VARCHAR(20) NOT NULL COMMENT '内控指标编号',
  `nkje` DECIMAL(16,2) COMMENT '涉及金额',
  `nkse` DECIMAL(16,2) COMMENT '涉及税额',
  `nkywms` VARCHAR(2000) COMMENT '内控业务描述',
  `nkclzt` CHAR(1) DEFAULT '0' COMMENT '内控处理状态（0未处理1已处理-正常2已处理-整改）',
  `nkclry` CHAR(11) COMMENT '内控处理人员',
  `nkclsj` DATETIME COMMENT '内控处理时间',
  `nkclsm` VARCHAR(2000) COMMENT '内控处理说明',
  `fhry` CHAR(11) COMMENT '复核人员',
  `fhsj` DATETIME COMMENT '复核时间'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='风险内控_内部风险点明细';

-- Creating table FXNK_NBFXDMX_SQ
CREATE TABLE `FXNK_NBFXDMX_SQ` (
  `uuid` VARCHAR(32) NOT NULL COMMENT '内控业务关键字',
  `swjgdm` CHAR(11) COMMENT '税务机关代码',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `nsrsbh` VARCHAR(20) COMMENT '税号',
  `nsrmc` VARCHAR(300) COMMENT '名称',
  `lcswsx_dm` VARCHAR(16) COMMENT '流程税务事项代码',
  `lcslid` VARCHAR(32) COMMENT '流程实例ID',
  `cjsj` DATETIME COMMENT '创建时间（首次提醒时间）',
  `gxsj` DATETIME COMMENT '更新时间（末次提醒时间）',
  `nkzbbh` VARCHAR(20) NOT NULL COMMENT '内控指标编号',
  `nkje` DECIMAL(16,2) COMMENT '涉及金额',
  `nkse` DECIMAL(16,2) COMMENT '涉及税额',
  `nkywms` VARCHAR(2000) COMMENT '内控业务描述',
  `qxzt` CHAR(1) DEFAULT '0' COMMENT '取消状态（0未取消1已取消）',
  `qxsj` DATETIME COMMENT '取消时间',
  `qxry` CHAR(11) COMMENT '取消人员（金三操作员代码或SYSTEM）',
  `qxyysm` VARCHAR(2000) COMMENT '取消原因说明'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='风险内控_内部风险点明细';

-- Creating table FXNK_NBFXDMX_SZ
CREATE TABLE `FXNK_NBFXDMX_SZ` (
  `uuid` VARCHAR(32) NOT NULL COMMENT '内控业务关键字',
  `swjgdm` CHAR(11) COMMENT '税务机关代码',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `nsrsbh` VARCHAR(20) COMMENT '税号',
  `nsrmc` VARCHAR(300) COMMENT '名称',
  `lcswsx_dm` VARCHAR(16) COMMENT '流程税务事项代码',
  `lcslid` VARCHAR(32) COMMENT '流程实例ID',
  `cfry` CHAR(11) COMMENT '触发人员（金三操作员代码）',
  `cfsj` DATETIME COMMENT '触发时间',
  `nkzbbh` VARCHAR(20) NOT NULL COMMENT '内控指标编号',
  `nkje` DECIMAL(16,2) COMMENT '涉及金额',
  `nkse` DECIMAL(16,2) COMMENT '涉及税额',
  `nkywms` VARCHAR(2000) COMMENT '内控业务描述',
  `hxczsm` VARCHAR(2000) COMMENT '后续操作说明',
  `cldz` CHAR(1) COMMENT '处理动作：0-忽略、1-中断'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='风险内控_内部风险点明细';

-- Creating table FXNK_RULES_MAIN
-- FXNK_RULES_MAIN.id: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- Original Oracle primary-key constraint: PK_RULES_MAIN (MySQL index name: PRIMARY).
CREATE TABLE `FXNK_RULES_MAIN` (
  `id` DECIMAL(65,27) NOT NULL COMMENT '主键',
  `biz_key` VARCHAR(100) NOT NULL COMMENT '业务关键字',
  `biz_desc` VARCHAR(200) COMMENT '业务描述',
  `biz_path` VARCHAR(60) NOT NULL COMMENT '业务关键字路径',
  `is_valid` CHAR(1) NOT NULL DEFAULT 'Y' COMMENT '是否有效  Y\N',
  `bz` VARCHAR(200),
  CONSTRAINT `PK_RULES_MAIN` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table FXNK_RULES_MX
-- FXNK_RULES_MX.id: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- Original Oracle primary-key constraint: PK_RULES_MX (MySQL index name: PRIMARY).
CREATE TABLE `FXNK_RULES_MX` (
  `id` DECIMAL(65,27) NOT NULL,
  `biz_key` VARCHAR(100) NOT NULL COMMENT '业务关键字',
  `prop_path` VARCHAR(60) COMMENT '参数变量路径',
  `prop_name` VARCHAR(20) NOT NULL COMMENT '参数变量名',
  `value_path` VARCHAR(60) NOT NULL COMMENT '参数变量值路径',
  `param_alias` VARCHAR(20) NOT NULL COMMENT '存储过程参数别名',
  `is_valid` CHAR(1) NOT NULL DEFAULT 'Y',
  `crtime` DATETIME,
  `uptime` DATETIME,
  CONSTRAINT `PK_RULES_MX` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table GLXT_BB_SHXT_DJXX
CREATE TABLE `GLXT_BB_SHXT_DJXX` (
  `swjgdm` VARCHAR(11) COMMENT '退税税务机关代码',
  `zgswjgdm` VARCHAR(11) COMMENT '征管税务机关代码',
  `cpcode` VARCHAR(32) COMMENT '审核系统企业标识',
  `qyhgdm` VARCHAR(32) COMMENT '企业海关代码',
  `nsrdjno` VARCHAR(32) COMMENT '税务登记证号',
  `shxyno` VARCHAR(20) COMMENT '社会信用代码',
  `nsrmc` VARCHAR(200) COMMENT '纳税人名称',
  `address_zc` VARCHAR(300) COMMENT '企业注册地址',
  `address_jy` VARCHAR(300) COMMENT '经营场所',
  `bsy` VARCHAR(150) COMMENT '办税人姓名1',
  `bsy_no` VARCHAR(30) COMMENT '身份证号1',
  `bsy_tel` VARCHAR(60) COMMENT '办税人电话1',
  `bsy2` VARCHAR(150) COMMENT '办税人姓名2',
  `bsy2_no` VARCHAR(30) COMMENT '身份证号2',
  `bsy2_tel` VARCHAR(60) COMMENT '办税人电话2',
  `jsmode` CHAR(1) COMMENT '退税计算方式',
  `qylx` VARCHAR(10) COMMENT '企业类型代码',
  `nsrlx_js` VARCHAR(1) DEFAULT '1' COMMENT '纳税人类型',
  `djzclx_js` VARCHAR(3) COMMENT '登记注册类型',
  `flglcd` CHAR(1) COMMENT '管理类别',
  `nsxydj_js` VARCHAR(20) COMMENT '纳税信用等级',
  `ysjccode` VARCHAR(2) COMMENT '预算级次',
  `tkjccode` VARCHAR(30) COMMENT '退库级次',
  `bkname` VARCHAR(80) COMMENT '退税开户银行',
  `accno` VARCHAR(60) COMMENT '审核系统退库账号',
  `accno_js` VARCHAR(60) COMMENT '金三系统退库账号',
  `ysfw` CHAR(1) COMMENT '是否应税服务',
  `ysfwcode` VARCHAR(30) COMMENT '应税服务代码',
  `ysfs` VARCHAR(30) COMMENT '运输方式',
  `yfsjfw` VARCHAR(50) COMMENT '研发设计服务',
  `wzfqy` CHAR(1) COMMENT '外综服企业标识',
  `wzhqy` CHAR(1) COMMENT '无纸化企业标识',
  `sdqqy` CHAR(1) COMMENT '水电气企业标识',
  `yfjg` CHAR(1) COMMENT '研发机构',
  `sq_date` DATETIME COMMENT '备案日期',
  `zx_flag` CHAR(1) COMMENT '备案撤回标识',
  `zx_date` DATETIME COMMENT '备案撤回日期',
  `nsrzt_js` VARCHAR(2) COMMENT '纳税人状态',
  `sfckqy_js` CHAR(1) DEFAULT '0' COMMENT '金三出口企业标识',
  `yxbaflag` CHAR(1) DEFAULT '0' COMMENT '有效备案标识',
  `bajc_year` VARCHAR(2) DEFAULT '00' COMMENT '备案级次_本年',
  `sbjc_year` VARCHAR(2) DEFAULT '00' COMMENT '申报级次_本年',
  `bajc_month` VARCHAR(2) DEFAULT '00' COMMENT '备案级次_本月',
  `sbjc_month` VARCHAR(2) DEFAULT '00' COMMENT '申报级次_本月',
  `mdjccode` VARCHAR(30) COMMENT '调库级次',
  `hydm` VARCHAR(4) COMMENT '行业代码（取金三）',
  `dbtsba_flag` CHAR(1) DEFAULT '0' COMMENT '是否做过生产企业代办退税备案',
  `dbtssb_flag` CHAR(1) DEFAULT '0' COMMENT '是否申报过代办退税',
  `jsjdjdm` VARCHAR(10) COMMENT '技术监督局代码',
  `frdb_mc` VARCHAR(150) COMMENT '法人代表名称',
  `swdj_date` DATETIME COMMENT '税务登记日期',
  `ybnsr_date` DATETIME COMMENT '一般纳税人认定日期',
  `frdb_zjlx` VARCHAR(10) COMMENT '法人代表证件类型',
  `frdb_zjhm` VARCHAR(30) COMMENT '法人代表证明号码',
  `djxh_js` DECIMAL(21,0) COMMENT '登记序号（取金三）',
  `first_sb_ym` VARCHAR(6) COMMENT '首次申报年月',
  `zgswskfj_dm` VARCHAR(11) COMMENT '主管税务所（科、分局）代码',
  `jdxz_dm` VARCHAR(9) COMMENT '街道乡镇代码',
  `wzfqy13` CHAR(1) COMMENT '是否按13号公告做过外综服备案',
  `qyfz` VARCHAR(11) COMMENT '企业分组',
  `nsrdzdah` DECIMAL(20,0) COMMENT '电子档案号，备用',
  `ckgm_dm` CHAR(1) COMMENT '出口规模（等级，ABCDE）',
  `ck_bgdfs` DECIMAL(10,0) COMMENT '出口报关单份数',
  `ck_mylaj` DECIMAL(18,2) COMMENT '出口美元离岸价',
  `ckgm` DECIMAL(18,2) COMMENT '出口规模（申报美元离岸价）',
  `sb_tmse` DECIMAL(18,2) COMMENT '申报退免税额',
  `sb_mde` DECIMAL(18,2) COMMENT '申报免抵额',
  `ckblv` DECIMAL(10,6) COMMENT '出口比例（百分比）',
  `mdblv` DECIMAL(10,6) COMMENT '免抵比例（百分比）',
  `sflv` DECIMAL(10,6) COMMENT '税负率（百分比）',
  `ckblv_dm` CHAR(1) COMMENT '出口比例（等级，ABCDE）',
  `mdblv_dm` CHAR(1) COMMENT '免抵比例（等级，ABCDE）',
  `sflv_dm` CHAR(1) COMMENT '税负率（等级，ABCDE）',
  `qygzxx` VARCHAR(2000) COMMENT '企业关注信息',
  KEY `IDX_GLXT_BB_SHXT_DJXX_BAJCYEAR` (`BAJC_YEAR`),
  KEY `IDX_GLXT_BB_SHXT_DJXX_CPCODE` (`CPCODE`),
  KEY `IDX_GLXT_BB_SHXT_DJXX_DJXH` (`DJXH_JS`),
  KEY `IDX_GLXT_BB_SHXT_DJXX_FRDB` (`FRDB_ZJHM`),
  KEY `IDX_GLXT_BB_SHXT_DJXX_JYDZ` (`ADDRESS_JY`),
  KEY `IDX_GLXT_BB_SHXT_DJXX_NSRDJNO` (`NSRDJNO`),
  KEY `IDX_GLXT_BB_SHXT_DJXX_QYHGDM` (`QYHGDM`),
  KEY `IDX_GLXT_BB_SHXT_DJXX_SHXYNO` (`SHXYNO`),
  KEY `IDX_GLXT_BB_SHXT_DJXX_SWJG` (`SWJGDM`),
  KEY `IDX_GLXT_BB_SHXT_DJXX_ZGSWJG` (`ZGSWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='管理系统_报表_出口企业档案表';

-- Creating table GLXT_BB_SHXT_LCXX
-- Original Oracle primary-key constraint: PKEY_GLXT_BB_SHXT_LCXX (MySQL index name: PRIMARY).
-- Original schema-qualified index: TL_BJTS.IDX_GLXT_BB_SHXT_LCXX1_SSS; MySQL indexes belong to the current table/database.
-- Original function index IDX_GLXT_BB_SHXT_LCXX_LCJSRQ: (NVL(LCJSRQ,TO_DATE(' 2100-12-31 00:00:00', 'syyyy-mm-dd hh24:mi:ss'))); expressions below use equivalent MySQL functions.
-- Original function index IDX_GLXT_BB_SHXT_LCXX_SLDATE: (TO_CHAR(SL_DATE,'YYYY-MM')); expressions below use equivalent MySQL functions.
-- Original function index IDX_GLXT_BB_SHXT_LCXX_ZLCFFRQ: (NVL(ZLC_FFRQ,TO_DATE(' 2100-12-31 00:00:00', 'syyyy-mm-dd hh24:mi:ss'))); expressions below use equivalent MySQL functions.
CREATE TABLE `GLXT_BB_SHXT_LCXX` (
  `uuid` VARCHAR(32) NOT NULL COMMENT 'UUID||uuid',
  `swjgdm` VARCHAR(11) COMMENT '税务机关代码',
  `zbswcode` VARCHAR(11) COMMENT '指标税务机关',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ckqygllb_dm` CHAR(1) COMMENT '出口企业管理类别代码',
  `sbywb_dm` VARCHAR(16) COMMENT '申报业务表代码（A0000001代表2013年前无业务流程的初始数据，其他正常）',
  `sb_ym` VARCHAR(6) COMMENT '申报年月',
  `sb_pc` VARCHAR(4) COMMENT '申报批次',
  `lcslid` VARCHAR(32) COMMENT '审核系统流程受理ID',
  `bjts_date` DATETIME COMMENT '便捷退税申报日期',
  `sb_date` DATETIME COMMENT '申报时间(对应主流程启动时间）',
  `sl_date` DATETIME COMMENT '受理时间（对应主流程出具受理通知书时间）',
  `fh_date` DATETIME COMMENT '主流程复审时间（取业务核准表录入时间）',
  `ywhz_date` DATETIME COMMENT '主流程业务核准时间（取业务核准表中的业务核准时间）',
  `sehz_date` DATETIME COMMENT '主流程税额核准时间（取税额核准表的税额核准日期）',
  `tskp_date` DATETIME COMMENT '主流程退税开票时间（取收核开票日期）',
  `tstk_date` DATETIME COMMENT '主流程退税退库时间（取国库退库日期）',
  `bljz_date` DATETIME COMMENT '主流程办理截止时间（根据申报日期、管理类别办理期限，扣除节假日计算）',
  `sl_user` VARCHAR(32) COMMENT '受理人员（对应主流程启动人代码对应中文）',
  `fh_user` VARCHAR(32) COMMENT '复审人员（取业务核准表录入人代码对应中文）',
  `ywhz_user` VARCHAR(32) COMMENT '业务核准人员（取业务核准表中的业务核准人代码对应中文）',
  `sehz_user` VARCHAR(32) COMMENT '税额核准人员（取税额核准表的税额核准人代码对应中文）',
  `usd_amt` DECIMAL(24,4) COMMENT '申报出口销售额（美元）',
  `rmb_amt` DECIMAL(24,4) COMMENT '申报出口销售额（人民币）',
  `sb_ts_amt` DECIMAL(24,4) COMMENT '申报退税额',
  `sb_md_amt` DECIMAL(24,4) COMMENT '申报免抵额',
  `zlc_ts_amt` DECIMAL(24,4) COMMENT '主流程退税额',
  `zlc_md_amt` DECIMAL(24,4) COMMENT '主流程免抵额',
  `zlc_rwzt` VARCHAR(600) COMMENT '主流程当前任务状态',
  `zlc_xndbr` VARCHAR(50) COMMENT '主流程当前虚拟代办人',
  `bybl_amt` DECIMAL(24,4) COMMENT '总不予办理免抵退税额（审核环节确定）',
  `zh_amt` DECIMAL(24,4) COMMENT '总暂缓免抵退税额（还在评估环节）',
  `byts_amt` DECIMAL(24,4) COMMENT '总不予退税免抵退税额（评估结果，复审确定）',
  `zbbl_amt` DECIMAL(24,4) COMMENT '总暂不办理免抵退税额（评估结果，复审确定）',
  `fh_ts_amt` DECIMAL(24,4) COMMENT '总复审退税额',
  `fh_md_amt` DECIMAL(24,4) COMMENT '总复审免抵额',
  `sehz_ts_amt` DECIMAL(24,4) COMMENT '总税额核准退税额',
  `sehz_md_amt` DECIMAL(24,4) COMMENT '总税额核准免抵额',
  `byhz_ts_amt` DECIMAL(24,4) COMMENT '总不予核准退税额',
  `byhz_md_amt` DECIMAL(24,4) COMMENT '总不予核准免抵额',
  `zk_amt` DECIMAL(24,4) COMMENT '总暂扣退税额',
  `kp_ts_amt` DECIMAL(24,4) COMMENT '总开票退税额',
  `kp_md_amt` DECIMAL(24,4) COMMENT '总开票免抵额',
  `tk_ts_amt` DECIMAL(24,4) COMMENT '总国库办理退税额',
  `tk_md_amt` DECIMAL(24,4) COMMENT '总国库办理免抵额',
  `lcjsrq` DATETIME COMMENT '流程全部结束日期',
  `sl_day` DECIMAL(10,4) DEFAULT 0 COMMENT '受理周期（受理时间-申报时间，去除节假日，1小时=1/24天）',
  `sh_day` DECIMAL(10,4) DEFAULT 0 COMMENT '审核周期（复核时间-受理时间，去除节假日，1小时=1/24天）',
  `hz_day` DECIMAL(10,4) DEFAULT 0 COMMENT '核准周期（税额核准时间-复核时间，去除节假日，1小时=1/24天）',
  `kp_day` DECIMAL(10,4) DEFAULT 0 COMMENT '开票周期（收核开票时间-税额核准时间，去除节假日，1小时=1/24天）',
  `sum_day` DECIMAL(10,4) DEFAULT 0 COMMENT '总办理周期（=审核周期+核准周期+开票周期）',
  `ysfw_flag` CHAR(1) DEFAULT 'N' COMMENT '是否包含跨境应税行为申报数据',
  `zlc_ffrq` DATETIME COMMENT '主流程发放日期',
  `wzhbz` CHAR(1) COMMENT '是否无纸化申报',
  KEY `IDX_GLXT_BB_SHXT_LCXX1_DJXH` (`DJXH`),
  KEY `IDX_GLXT_BB_SHXT_LCXX1_LCSLID` (`LCSLID`),
  KEY `IDX_GLXT_BB_SHXT_LCXX1_SSS` (`SWJGDM`, `SBYWB_DM`, `SB_DATE`),
  KEY `IDX_GLXT_BB_SHXT_LCXX1_SWJGDM` (`SWJGDM`),
  KEY `IDX_GLXT_BB_SHXT_LCXX1_TSBLJZ` (`BLJZ_DATE`, `ZLC_TS_AMT`),
  KEY `IDX_GLXT_BB_SHXT_LCXX_LCJSRQ` ((COALESCE(`LCJSRQ`, CAST('2100-12-31 00:00:00' AS DATETIME)))),
  KEY `IDX_GLXT_BB_SHXT_LCXX_SLDATE` ((CAST(CONCAT(LPAD(YEAR(`SL_DATE`), 4, '0'), '-', LPAD(MONTH(`SL_DATE`), 2, '0')) AS CHAR(7)))),
  KEY `IDX_GLXT_BB_SHXT_LCXX_ZLCFFRQ` ((COALESCE(`ZLC_FFRQ`, CAST('2100-12-31 00:00:00' AS DATETIME)))),
  KEY `IDX_GLXT_BB_SHXT_LX_ZBSWCODE` (`ZBSWCODE`),
  CONSTRAINT `PKEY_GLXT_BB_SHXT_LCXX` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='因审核系统数据有误需要调整数据表';

-- Creating table GLXT_BB_SHXT_LCXX_202105
CREATE TABLE `GLXT_BB_SHXT_LCXX_202105` (
  `swjgdm` VARCHAR(11) COMMENT '税务机关代码',
  `cpcode` VARCHAR(32) COMMENT '审核系统企业标识',
  `sbywb_dm` VARCHAR(8) COMMENT '申报业务表代码（A0000001代表2013年前无业务流程的初始数据，其他正常）',
  `sb_ym` VARCHAR(6) COMMENT '申报年月',
  `sb_pc` VARCHAR(4) COMMENT '申报批次',
  `lcslid` VARCHAR(32) COMMENT '审核系统流程受理ID',
  `tj_jc` VARCHAR(2) COMMENT '统计级次（10免退税货物20免抵退货物30周边业务40服务贸易50外贸综合服务）',
  `ck_month` VARCHAR(6) COMMENT '出口月份',
  `sl_month` VARCHAR(6) COMMENT '受理月份',
  `sh_month` VARCHAR(6) COMMENT '审核月份',
  `fh_month` VARCHAR(6) COMMENT '复核月份',
  `sp_month` VARCHAR(6) COMMENT '审批月份',
  `hz_month` VARCHAR(6) COMMENT '核准月份',
  `tskp_month` VARCHAR(6) COMMENT '退税开票月份',
  `tstk_month` VARCHAR(6) COMMENT '退税退库月份',
  `mdkp_month` VARCHAR(6) COMMENT '免抵开票月份',
  `mdtk_month` VARCHAR(6) COMMENT '免抵调库月份',
  `sb_date` DATETIME COMMENT '申报时间',
  `sl_date` DATETIME COMMENT '受理时间',
  `sh_date` DATETIME COMMENT '审核时间',
  `pg_date` DATETIME COMMENT '评估时间',
  `fh_date` DATETIME COMMENT '复审时间',
  `sp_date` DATETIME COMMENT '审批时间',
  `hz_date` DATETIME COMMENT '最新核准时间（用于报表统计）',
  `ths_date` DATETIME COMMENT '最新退还书生成时间（用于报表统计）',
  `tskp_date` DATETIME COMMENT '最新退税开票时间（用于报表统计）',
  `tstk_date` DATETIME COMMENT '退税退库时间',
  `mdkp_date` DATETIME COMMENT '免抵开票时间',
  `mdtk_date` DATETIME COMMENT '免抵调库时间',
  `fst_hz_date` DATETIME COMMENT '首次核准时间（用于绩效考核）',
  `fst_ths_date` DATETIME COMMENT '首次退还书生成时间（用于绩效考核）',
  `fst_tskp_date` DATETIME COMMENT '首次退税开票时间（用于绩效考核）',
  `sl_user` VARCHAR(32) COMMENT '受理人员',
  `sh_user` VARCHAR(32) COMMENT '审核人员',
  `pg_user` VARCHAR(32) COMMENT '评估人员',
  `fh_user` VARCHAR(32) COMMENT '复审人员',
  `sp_user` VARCHAR(32) COMMENT '审批人员',
  `hz_user` VARCHAR(32) COMMENT '核准人员',
  `ths_user` VARCHAR(32) COMMENT '退还书生成人员',
  `usd_amt` DECIMAL(24,4) COMMENT '出口销售额（美元）',
  `rmb_amt` DECIMAL(24,4) COMMENT '出口销售额（人民币）',
  `sl_ts_amt` DECIMAL(24,4) COMMENT '受理免抵退税额',
  `sl_zzs_amt` DECIMAL(24,4) COMMENT '受理增值税退税额',
  `sl_xfs_amt` DECIMAL(24,4) COMMENT '受理消费税退税额',
  `sl_md_amt` DECIMAL(24,4) COMMENT '受理免抵税额',
  `sh_ts_amt` DECIMAL(24,4) COMMENT '审核免抵退税额',
  `sh_zzs_amt` DECIMAL(24,4) COMMENT '审核增值税退税额',
  `sh_xfs_amt` DECIMAL(24,4) COMMENT '审核消费税退税额',
  `sh_md_amt` DECIMAL(24,4) COMMENT '审核免抵税额',
  `by_ts_amt` DECIMAL(24,4) COMMENT '不予退税免抵退税额',
  `by_zzs_amt` DECIMAL(24,4) COMMENT '不予退税增值税退税额',
  `by_xfs_amt` DECIMAL(24,4) COMMENT '不予退税消费税退税额',
  `by_md_amt` DECIMAL(24,4) COMMENT '不予退税免抵税额',
  `zh_ts_amt` DECIMAL(24,4) COMMENT '暂缓办理免抵退税额',
  `zh_zzs_amt` DECIMAL(24,4) COMMENT '暂缓办理增值税退税额',
  `zh_xfs_amt` DECIMAL(24,4) COMMENT '暂缓办理消费税退税额',
  `zh_md_amt` DECIMAL(24,4) COMMENT '暂缓办理免抵税额',
  `fh_ts_amt` DECIMAL(24,4) COMMENT '复核免抵退税额',
  `fh_zzs_amt` DECIMAL(24,4) COMMENT '复核增值税退税额',
  `fh_xfs_amt` DECIMAL(24,4) COMMENT '复核消费税退税额',
  `fh_md_amt` DECIMAL(24,4) COMMENT '复核免抵税额',
  `sp_ts_amt` DECIMAL(24,4) COMMENT '审批免抵退税额',
  `sp_zzs_amt` DECIMAL(24,4) COMMENT '审批增值税退税额',
  `sp_xfs_amt` DECIMAL(24,4) COMMENT '审批消费税退税额',
  `sp_md_amt` DECIMAL(24,4) COMMENT '审批免抵税额',
  `zk_ts_amt` DECIMAL(24,4) COMMENT '暂扣退税额',
  `zk_zzs_amt` DECIMAL(24,4) COMMENT '暂扣增值税退税额',
  `zk_xfs_amt` DECIMAL(24,4) COMMENT '暂扣消费税退税额',
  `zk_md_amt` DECIMAL(24,4) COMMENT '暂扣免抵税额',
  `hz_ts_amt` DECIMAL(24,4) COMMENT '核准免抵退税额',
  `hz_zzs_amt` DECIMAL(24,4) COMMENT '核准增值税退税额',
  `hz_xfs_amt` DECIMAL(24,4) COMMENT '核准消费税退税额',
  `hz_md_amt` DECIMAL(24,4) COMMENT '核准免抵税额',
  `kp_ts_amt` DECIMAL(24,4) COMMENT '送交国库免抵退税额',
  `kp_zzs_amt` DECIMAL(24,4) COMMENT '送交国库增值税退税额',
  `kp_xfs_amt` DECIMAL(24,4) COMMENT '送交国库消费税退税额',
  `kp_md_amt` DECIMAL(24,4) COMMENT '送交国库免抵税额',
  `tk_ts_amt` DECIMAL(24,4) COMMENT '国库办理免抵退税额',
  `tk_zzs_amt` DECIMAL(24,4) COMMENT '国库办理增值税退税额',
  `tk_xfs_amt` DECIMAL(24,4) COMMENT '国库办理消费税退税额',
  `tk_md_amt` DECIMAL(24,4) COMMENT '国库办理免抵税额',
  `his_ts_amt` DECIMAL(24,4) COMMENT '历史年份已办理免抵退税额',
  `his_zzs_amt` DECIMAL(24,4) COMMENT '历史年份已办理增值税退税额',
  `his_xfs_amt` DECIMAL(24,4) COMMENT '历史年份已办理消费税退税额',
  `his_md_amt` DECIMAL(24,4) COMMENT '历史年份已办理免抵税额',
  `mon_ts_amt` DECIMAL(24,4) COMMENT '历史月份已办理免抵退税额',
  `mon_zzs_amt` DECIMAL(24,4) COMMENT '历史月份已办理增值税退税额',
  `mon_xfs_amt` DECIMAL(24,4) COMMENT '历史月份已办理消费税退税额',
  `mon_md_amt` DECIMAL(24,4) COMMENT '历史月份已办理免抵税额',
  `his_param` DECIMAL(10,4) DEFAULT 1 COMMENT '剔除历史年份退税剩余比例',
  `mon_param` DECIMAL(10,4) DEFAULT 1 COMMENT '本月免抵退占比',
  `his_flag` CHAR(1) DEFAULT '0' COMMENT '历史全部完成标志（历史年份已全额6正常7冲红8取消暂缓，历史月份已全额1正常2冲红3取消暂缓，0未结束）',
  `this_ts_amt` DECIMAL(24,4) COMMENT '本月办理免抵退税额',
  `this_zzs_amt` DECIMAL(24,4) COMMENT '本月办理增值税退税额',
  `this_xfs_amt` DECIMAL(24,4) COMMENT '本月办理消费税退税额',
  `this_md_amt` DECIMAL(24,4) COMMENT '本月办理免抵税额',
  `zbswcode` VARCHAR(11) COMMENT '指标税务机关',
  `hl_ts_amt` DECIMAL(24,4) COMMENT '忽略退免税额',
  `hl_zzs_amt` DECIMAL(24,4) COMMENT '忽略增值税',
  `hl_xfs_amt` DECIMAL(24,4) COMMENT '忽略消费税',
  `hl_md_amt` DECIMAL(24,4) COMMENT '忽略免抵额',
  `usd_amt_bb` DECIMAL(24,4) COMMENT '出口销售额（美元）,扣除进料加工料件',
  `rmb_amt_bb` DECIMAL(24,4) COMMENT '出口销售额（人民币）,扣除进料加工料件',
  `tjswcode` VARCHAR(11) COMMENT '统计税务机关',
  `mon_param_v` DECIMAL(10,4) DEFAULT 1 COMMENT '增值税-本月占比',
  `mon_param_c` DECIMAL(10,4) DEFAULT 1 COMMENT '消费税-本月占比',
  `mon_param_m` DECIMAL(10,4) DEFAULT 1 COMMENT '免抵额-本月占比',
  `his_param_v` DECIMAL(10,4) DEFAULT 1 COMMENT '增值税-剔除历史年份退税剩余比例',
  `his_param_c` DECIMAL(10,4) DEFAULT 1 COMMENT '消费税-剔除历史年份退税剩余比例',
  `his_param_m` DECIMAL(10,4) DEFAULT 1 COMMENT '免抵额-剔除历史年份退税剩余比例',
  `cpcodetssh` VARCHAR(32) COMMENT '审核系统企业标识',
  KEY `IDX_GLXT_BB_SHXT_LCXX_CPCODE` (`CPCODE`),
  KEY `IDX_GLXT_BB_SHXT_LCXX_HISFLAG` (`HIS_FLAG`),
  KEY `IDX_GLXT_BB_SHXT_LCXX_LCSLID` (`LCSLID`),
  KEY `IDX_GLXT_BB_SHXT_LCXX_SBYWB` (`SBYWB_DM`),
  KEY `IDX_GLXT_BB_SHXT_LCXX_SWJGDM` (`SWJGDM`),
  KEY `IDX_GLXT_BB_SHXT_LCXX_TJCODE` (`TJSWCODE`),
  KEY `IDX_GLXT_BB_SHXT_LCXX_TJJC` (`TJ_JC`),
  KEY `IDX_GLXT_BB_SHXT_LCXX_TS` (`TJSWCODE`, `SL_MONTH`),
  KEY `IDX_GLXT_BB_SHXT_LCXX_ZBJGDM` (`ZBSWCODE`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='因审核系统数据有误需要调整数据表'
PARTITION BY RANGE COLUMNS (`SWJGDM`) (
  PARTITION `P_13300000000` VALUES LESS THAN ('13300000000'),
  PARTITION `P_13301000000` VALUES LESS THAN ('13301000000'),
  PARTITION `P_13303000000` VALUES LESS THAN ('13303000000'),
  PARTITION `P_13304000000` VALUES LESS THAN ('13304000000'),
  PARTITION `P_13305000000` VALUES LESS THAN ('13305000000'),
  PARTITION `P_13306000000` VALUES LESS THAN ('13306000000'),
  PARTITION `P_13307000000` VALUES LESS THAN ('13307000000'),
  PARTITION `P_13308000000` VALUES LESS THAN ('13308000000'),
  PARTITION `P_13309000000` VALUES LESS THAN ('13309000000'),
  PARTITION `P_13310000000` VALUES LESS THAN ('13310000000'),
  PARTITION `P_13311000000` VALUES LESS THAN ('13311000000'),
  PARTITION `P_MAXVALUE` VALUES LESS THAN (MAXVALUE)
);

-- Creating table GLXT_BB_SHXT_LCXX_SUB_202105
CREATE TABLE `GLXT_BB_SHXT_LCXX_SUB_202105` (
  `swjgdm` VARCHAR(11) COMMENT '税务机关代码',
  `cpcode` VARCHAR(32) COMMENT '审核系统企业标识',
  `lcslid` VARCHAR(32) COMMENT '审核系统流程受理ID',
  `ywlx` VARCHAR(2) COMMENT '业务类型:HW,FW',
  `ym` VARCHAR(6) COMMENT '申报年月',
  `sz` VARCHAR(4) COMMENT '税种:V,C,M',
  `ths_date` DATETIME COMMENT '退还书生成时间',
  `ths_user` VARCHAR(32) COMMENT '退还书生成人员',
  `kp_date` DATETIME COMMENT '开票时间',
  `tk_date` DATETIME COMMENT '退库调库时间',
  `kp_amt` DECIMAL(24,4) COMMENT '开票税额',
  `tk_amt` DECIMAL(24,4) COMMENT '国库税额',
  `zbswcode` VARCHAR(11) COMMENT '指标税务机关代码',
  `sp_amt` DECIMAL(24,4) COMMENT '审批税额',
  `ms_id` DECIMAL(38,0),
  `item_no` VARCHAR(10),
  `no` VARCHAR(50),
  `cno` VARCHAR(18),
  KEY `IDX_GLXT_BB_LCXX_SUB_CPCODE` (`CPCODE`),
  KEY `IDX_GLXT_BB_LCXX_SUB_MIS` (`MS_ID`, `ITEM_NO`, `SZ`),
  KEY `IDX_GLXT_BB_LCXX_SUB_ZBCODE` (`ZBSWCODE`),
  KEY `IDX_PGLXT_BB_LCXX_SUB_LCSLID` (`LCSLID`),
  KEY `IDX_PGLXT_BB_LCXX_SUB_SWJGDM` (`SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='管理系统报表数据抽取用的中间表'
PARTITION BY RANGE COLUMNS (`SWJGDM`) (
  PARTITION `P_13300000000` VALUES LESS THAN ('13300000000'),
  PARTITION `P_13301000000` VALUES LESS THAN ('13301000000'),
  PARTITION `P_13303000000` VALUES LESS THAN ('13303000000'),
  PARTITION `P_13304000000` VALUES LESS THAN ('13304000000'),
  PARTITION `P_13305000000` VALUES LESS THAN ('13305000000'),
  PARTITION `P_13306000000` VALUES LESS THAN ('13306000000'),
  PARTITION `P_13307000000` VALUES LESS THAN ('13307000000'),
  PARTITION `P_13308000000` VALUES LESS THAN ('13308000000'),
  PARTITION `P_13309000000` VALUES LESS THAN ('13309000000'),
  PARTITION `P_13310000000` VALUES LESS THAN ('13310000000'),
  PARTITION `P_13311000000` VALUES LESS THAN ('13311000000'),
  PARTITION `P_MAXVALUE` VALUES LESS THAN (MAXVALUE)
);

-- Creating table INTERFACE_ENTERPRISE_DECLARE
-- Original Oracle primary-key constraint: PK_INTER_ENTER_DECLARE (MySQL index name: PRIMARY).
CREATE TABLE `INTERFACE_ENTERPRISE_DECLARE` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '序号',
  `name` VARCHAR(200) NOT NULL COMMENT '企业名称',
  `scc` VARCHAR(20) NOT NULL COMMENT '社会信用代码',
  `declaredate` DATETIME NOT NULL COMMENT '申报时间',
  `goodinfo` VARCHAR(4000) NOT NULL COMMENT '商品名称列表，逗号分割',
  `pushtime` DATETIME NOT NULL COMMENT '推送时间',
  `bizid` VARCHAR(40) NOT NULL COMMENT '推送请求UUID',
  `jgbz` CHAR(1) NOT NULL COMMENT '0正常 1商品超长截断',
  KEY `IDX_T_DECLARATION_DECLAREDATE` (`DECLAREDATE`),
  KEY `IDX_T_DECLARATION_PUSHTIME` (`PUSHTIME`),
  CONSTRAINT `PK_INTER_ENTER_DECLARE` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='企业商品申报信息表';

-- Creating table INTERFACE_ENTERPRISE_RECORD
-- Original Oracle primary-key constraint: PK_T_ENTERPRISE_CUSTOMS (MySQL index name: PRIMARY).
CREATE TABLE `INTERFACE_ENTERPRISE_RECORD` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '序号',
  `name` VARCHAR(200) NOT NULL COMMENT '企业名称',
  `scc` VARCHAR(20) NOT NULL COMMENT '社会信用代码',
  `rgdate` DATETIME NOT NULL COMMENT '海关备案日期',
  `pushtime` DATETIME NOT NULL COMMENT '推送时间',
  `bizid` VARCHAR(40) NOT NULL COMMENT '推送请求UUID',
  KEY `IDX_T_ENTERPRISE_BIZID` (`BIZID`),
  KEY `IDX_T_ENTERPRISE_RGDATE` (`RGDATE`),
  UNIQUE KEY `UN_T_SCC` (`SCC`),
  CONSTRAINT `PK_T_ENTERPRISE_CUSTOMS` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='企业海关备案信息表';

-- Creating table INTERFACE_PENDING_NSRSBH
-- Original Oracle primary-key constraint: PK_INTERFACE_PENDING_NSRSBH (MySQL index name: PRIMARY).
CREATE TABLE `INTERFACE_PENDING_NSRSBH` (
  `nsrsbh` VARCHAR(20) NOT NULL COMMENT '纳税人识别号',
  `djrq` DATETIME COMMENT '登记日期',
  `jyfw` VARCHAR(3600) COMMENT '经营范围',
  `nsrmc` VARCHAR(300) COMMENT '纳税人名称',
  `clzt` VARCHAR(2) COMMENT '处理状态',
  CONSTRAINT `PK_INTERFACE_PENDING_NSRSBH` PRIMARY KEY (`NSRSBH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='口岸推送待处理纳税人信息表';

-- Creating table INTERFACE_PUSH_NSRSBH
-- Original Oracle primary-key constraint: PK_PUSH_NSRSBH (MySQL index name: PRIMARY).
CREATE TABLE `INTERFACE_PUSH_NSRSBH` (
  `id` DECIMAL(18,0) NOT NULL,
  `nsrsbh` VARCHAR(21),
  `push_time` DATETIME,
  KEY `IDX_PUSHTIME` (`PUSH_TIME`),
  UNIQUE KEY `UQ_NSRSBH` (`NSRSBH`),
  CONSTRAINT `PK_PUSH_NSRSBH` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='接口发送纳税人表';

-- Creating table INTERFACE_SEND_DATA
-- Original Oracle primary-key constraint: PK_BIZID (MySQL index name: PRIMARY).
CREATE TABLE `INTERFACE_SEND_DATA` (
  `bizid` VARCHAR(50) NOT NULL,
  `request` LONGBLOB NOT NULL,
  `response` LONGBLOB,
  CONSTRAINT `PK_BIZID` PRIMARY KEY (`BIZID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table INTERFACE_SEND_LOG
-- Original Oracle primary-key constraint: PK_INTERFACE_SEND_LOG (MySQL index name: PRIMARY).
CREATE TABLE `INTERFACE_SEND_LOG` (
  `id` DECIMAL(18,0) NOT NULL COMMENT '序号：主键',
  `bizcode` VARCHAR(30) COMMENT '业务代码',
  `appid` VARCHAR(30) COMMENT '第三方应用标',
  `bizid` VARCHAR(50) NOT NULL COMMENT '业务唯一标识',
  `timestamp` VARCHAR(30) COMMENT '请求参数-时间戳',
  `sign` VARCHAR(100) COMMENT '请求参数-签名',
  `reqtime` DATETIME COMMENT '请求时间',
  `rsptime` DATETIME COMMENT '响应时间',
  `clbz` CHAR(1) COMMENT '处理标志，1成功 0失败',
  `client_ip` VARCHAR(45) COMMENT '客户端IP',
  KEY `IDX_INTERFACE_SEND_LOG_APPID` (`APPID`),
  KEY `IDX_INTERFACE_SEND_LOG_REQTIME` (`REQTIME`),
  CONSTRAINT `PK_INTERFACE_SEND_LOG` PRIMARY KEY (`ID`),
  CONSTRAINT `UK_INTERFACE_SEND_LOG_BIZID` UNIQUE (`BIZID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='接口发送日志表';

-- Creating table INTERFACE_SERVICE_PROFILE
-- Original Oracle primary-key constraint: PK_INTERFACE_SERVICE_PROFILE (MySQL index name: PRIMARY).
CREATE TABLE `INTERFACE_SERVICE_PROFILE` (
  `id` DECIMAL(10,0) NOT NULL COMMENT '序号',
  `servname` VARCHAR(100) NOT NULL COMMENT '接口服务名称',
  `servurl` VARCHAR(200) COMMENT '接口服务地址',
  `appid` VARCHAR(30) NOT NULL COMMENT '第三方应用标识',
  `appkey` VARCHAR(100) NOT NULL COMMENT '密钥（用于签名）',
  `ipset` VARCHAR(500) COMMENT '预留于IP白名单，用逗号分割',
  `yxbz` CHAR(1) NOT NULL COMMENT 'Y有效 N无效',
  `note` VARCHAR(100) COMMENT '备注描述',
  `lasttime` DATETIME COMMENT '最近一次处理时间',
  KEY `IDX_APPID` (`APPID`),
  CONSTRAINT `PK_INTERFACE_SERVICE_PROFILE` PRIMARY KEY (`ID`),
  CONSTRAINT `UK_INTERFACE_SERVICE_PROFILE` UNIQUE (`SERVNAME`, `APPID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='接口服务信息表';

-- Creating table JCFX_CS_CGHW
CREATE TABLE `JCFX_CS_CGHW` (
  `swjgdm` VARCHAR(11) NOT NULL COMMENT '主管税务机关',
  `spbm` VARCHAR(100) NOT NULL COMMENT '商品税目编码'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='各地区常规货物表';

-- Creating table JCFX_CS_MGKA
CREATE TABLE `JCFX_CS_MGKA` (
  `swjgdm` VARCHAR(11) NOT NULL COMMENT '主管税务机关',
  `hggqka_dm` CHAR(4) NOT NULL COMMENT '出口口岸'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='各地区敏感口岸表';

-- Creating table JCFX_CS_MGSP
CREATE TABLE `JCFX_CS_MGSP` (
  `swjgdm` VARCHAR(11) NOT NULL COMMENT '主管税务机关',
  `cksp_dm` VARCHAR(20) NOT NULL COMMENT '出口商品代码'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='各地区敏感商品表';

-- Creating table JCFX_CS_TABLE
-- Original Oracle primary-key constraint: PK_JCFX_CS_TABLE (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_CS_TABLE` (
  `tablename` VARCHAR(30) NOT NULL COMMENT '表名',
  `cname` VARCHAR(50) NOT NULL COMMENT '表中文名',
  `dtalias` VARCHAR(10) NOT NULL COMMENT '数据表别名',
  `tabletype` VARCHAR(1) NOT NULL COMMENT '表类型',
  `relation` VARCHAR(20) COMMENT '关系字段',
  `dependtable` VARCHAR(30) COMMENT '依赖表',
  `qybz` VARCHAR(1) NOT NULL DEFAULT 'Y' COMMENT '启用标志',
  CONSTRAINT `PK_JCFX_CS_TABLE` PRIMARY KEY (`TABLENAME`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='表对象定义表';

-- Creating table JCFX_CS_TSSP
CREATE TABLE `JCFX_CS_TSSP` (
  `swjgdm` VARCHAR(11) NOT NULL COMMENT '主管税务机关',
  `cksp_dm` VARCHAR(20) NOT NULL COMMENT '出口商品代码'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='各地区特殊商品表';

-- Creating table JCFX_CS_ZBDL
-- Original Oracle primary-key constraint: PK_JCFX_CS_ZBDL (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_CS_ZBDL` (
  `zbdlbm` VARCHAR(1) NOT NULL COMMENT '指标大类编码',
  `zbdlmc` VARCHAR(50) NOT NULL COMMENT '指标大类名称',
  `lx` VARCHAR(1) NOT NULL COMMENT '类型',
  CONSTRAINT `PK_JCFX_CS_ZBDL` PRIMARY KEY (`ZBDLBM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='指标大类表';

-- Creating table JCFX_CS_ZBXM
-- Original Oracle primary-key constraint: PK_JCFX_CS_ZBXM (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_CS_ZBXM` (
  `zbdlbm` VARCHAR(1) NOT NULL COMMENT '指标大类编码',
  `zbxmbm` VARCHAR(20) NOT NULL COMMENT '指标项目编码',
  `zbxmmc` VARCHAR(50) NOT NULL COMMENT '指标项目名称',
  `field` VARCHAR(20) NOT NULL COMMENT '字段名',
  `datatable` VARCHAR(30) COMMENT '数据表全名',
  `dicttable` VARCHAR(30) COMMENT '字典表名',
  `isvalid` CHAR(1) DEFAULT '1' COMMENT '是否有效项',
  `format` VARCHAR(20) COMMENT '格式化样式',
  `isshow` CHAR(1) COMMENT '是否显示',
  `pxno` VARCHAR(30) COMMENT '排序序号',
  CONSTRAINT `PK_JCFX_CS_ZBXM` PRIMARY KEY (`ZBXMBM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='指标项目表';

-- Creating table JCFX_CS_ZDYXM
-- Original Oracle primary-key constraint: PK_JCFX_CS_ZDYXM (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_CS_ZDYXM` (
  `zid` DECIMAL(10,0) NOT NULL COMMENT '序号',
  `zdyname` VARCHAR(50) NOT NULL COMMENT '自定义项目名',
  `ss_swjg_dm` VARCHAR(11) NOT NULL COMMENT '归属税务机关',
  `ss_zbxmbm` VARCHAR(10) NOT NULL COMMENT '指标项目编码',
  `syfw_swjg` VARCHAR(11) NOT NULL COMMENT '适用范围',
  `qybz` VARCHAR(1) NOT NULL COMMENT '启用标志',
  `xgr` VARCHAR(30) COMMENT '创建/修改人',
  `xgsj` DATETIME COMMENT '修改时间',
  CONSTRAINT `PK_JCFX_CS_ZDYXM` PRIMARY KEY (`ZID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='自定义项目主表';

-- Creating table JCFX_CS_ZDYXM_SUB
-- Original Oracle primary-key constraint: PK_JCFX_CS_ZDYXM_SUB (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_CS_ZDYXM_SUB` (
  `id` DECIMAL(10,0) NOT NULL COMMENT '序号',
  `zid` DECIMAL(10,0) NOT NULL COMMENT '主表序号',
  `dm` VARCHAR(20) NOT NULL COMMENT '代码',
  `mc` VARCHAR(50) COMMENT '名称',
  `qybz` VARCHAR(1) NOT NULL COMMENT '启用标志',
  CONSTRAINT `PK_JCFX_CS_ZDYXM_SUB` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='自定义项目子表';

-- Creating table JCFX_DATA_BGDMX
-- Original Oracle primary-key constraint: PK_JCFX_DATA_BGDMX (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_DATA_BGDMX` (
  `uuid` VARCHAR(32) NOT NULL,
  `tsswjg_dm` CHAR(11) NOT NULL COMMENT '税务机关',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `ckbgdh` VARCHAR(21) NOT NULL COMMENT '21位报关单号',
  `ny` CHAR(6) COMMENT '出口年月',
  `ckrq` DATETIME COMMENT '出口日期',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `hggqka_dm` CHAR(4) COMMENT '出口口岸',
  `mygdqsz_dm` CHAR(3) COMMENT '出口国别',
  `jgfs_dm` CHAR(4) COMMENT '贸易方式',
  `hzdwdq_dm` CHAR(5) COMMENT '境内货源地',
  `hydxzqh_dm` CHAR(4) COMMENT '货源地行政区划',
  `mylaj` DECIMAL(18,2) COMMENT '出口销售（美元）',
  `mylaj_zs` DECIMAL(18,2) DEFAULT 0 COMMENT '出口销售（征税）',
  `mylaj_ms` DECIMAL(18,2) DEFAULT 0 COMMENT '出口销售（免税）',
  `mylaj_bts` DECIMAL(18,2) DEFAULT 0 COMMENT '出口销售（不退税）',
  `mylaj_kts` DECIMAL(18,2) DEFAULT 0 COMMENT '出口销售（可退税）',
  `mylaj_ysb` DECIMAL(18,2) COMMENT '出口销售（已申报）',
  `rmblaj` DECIMAL(18,2) COMMENT '出口销售（人民币）',
  `tsl` DECIMAL(10,6) DEFAULT 0 COMMENT '退税率（征免不按0，其他按文库）',
  `ygtmse` DECIMAL(18,2) DEFAULT 0 COMMENT '预估退免税额',
  `sjgxsj` DATETIME COMMENT '数据更新时间',
  KEY `IDX_JCFX_DATA_BGDMX_CKRQ` (`CKRQ`),
  KEY `IDX_JCFX_DATA_BGDMX_SJGXSJ` (`SJGXSJ`),
  CONSTRAINT `PK_JCFX_DATA_BGDMX` PRIMARY KEY (`DJXH`, `CKBGDH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口报关单明细表，202412停止更新，相关字段并入CKTS_WBSJ_HG_BGD';
-- MySQL requires every PRIMARY/UNIQUE key to contain all partition columns.
-- To preserve the original keys and their uniqueness, this table is not partitioned.
-- Original Oracle partition definition (retained for reference):
-- partition by range (TSSWJG_DM)
-- (
--   partition P_13300000000 values less than ('13301000000')
--     tablespace TL_TSSH,
--   partition P_13301000000 values less than ('13303000000')
--     tablespace TL_TSSH,
--   partition P_13303000000 values less than ('13304000000')
--     tablespace TL_TSSH,
--   partition P_13304000000 values less than ('13305000000')
--     tablespace TL_TSSH,
--   partition P_13305000000 values less than ('13306000000')
--     tablespace TL_TSSH,
--   partition P_13306000000 values less than ('13307000000')
--     tablespace TL_TSSH,
--   partition P_13307000000 values less than ('13308000000')
--     tablespace TL_TSSH,
--   partition P_13308000000 values less than ('13309000000')
--     tablespace TL_TSSH,
--   partition P_13309000000 values less than ('13310000000')
--     tablespace TL_TSSH,
--   partition P_13310000000 values less than ('13311000000')
--     tablespace TL_TSSH,
--   partition P_13311000000 values less than (MAXVALUE)
--     tablespace TL_TSSH
-- )

-- Creating table JCFX_DATA_FPDFQYYHZ
-- Original Oracle primary-key constraint: PK_JCFX_DATA_FPDFQYYHZ (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_DATA_FPDFQYYHZ` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `ny` CHAR(6) NOT NULL COMMENT '年月',
  `kplx` CHAR(1) NOT NULL COMMENT '开票类型 X 上游销货 G 下游购货',
  `dfnsrsbh` VARCHAR(20) NOT NULL COMMENT '对方税号',
  `dfnsrmc` VARCHAR(300) COMMENT '对方名称',
  `fps` DECIMAL(10,0) COMMENT '发票份数（专票）',
  `je` DECIMAL(18,2) COMMENT '金额合计（专票）',
  `se` DECIMAL(18,2) COMMENT '税额合计（专票）',
  `zyspsm` VARCHAR(30) COMMENT '主要商品税目',
  `zyspmc` VARCHAR(300) COMMENT '主要商品名称',
  `zyspje` DECIMAL(18,2) COMMENT '主要商品金额',
  `zysp_zblv` DECIMAL(6,2) COMMENT '主要商品占比',
  `dffpzgkpxe` DECIMAL(18,2) COMMENT '单份发票开票限额（专票）',
  `fps_dgkj` DECIMAL(10,0) COMMENT '发票份数（专票）_顶格开具',
  `je_dgkj` DECIMAL(18,2) COMMENT '金额合计（专票）_顶格开具',
  `se_dgkj` DECIMAL(18,2) COMMENT '税额合计（专票）_顶格开具',
  `sjgxsj` DATETIME COMMENT '数据更新时间',
  `sp_zt` CHAR(1) COMMENT '商品更新状态',
  `sp_sj` DATETIME COMMENT '商品更新时间',
  CONSTRAINT `PK_JCFX_DATA_FPDFQYYHZ` PRIMARY KEY (`DJXH`, `NY`, `KPLX`, `DFNSRSBH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='发票对方企业（上下游/专票）月汇总表';

-- Creating table JCFX_DATA_KPQYJCXX
-- Original Oracle primary-key constraint: PK_JCFX_DATA_KPQYJCXX (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_DATA_KPQYJCXX` (
  `nsrsbh` VARCHAR(20) NOT NULL COMMENT '纳税人识别号',
  `nsrmc` VARCHAR(300) NOT NULL COMMENT '纳税人名称',
  `zgswjg_dm` VARCHAR(11) COMMENT '主管税务机关',
  `xzqh_dm` VARCHAR(4) COMMENT '行政区划',
  `nsrzt_dm` CHAR(2) COMMENT '纳税人状态',
  `fxqybz` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '风险企业标志',
  `sjgxsj` DATETIME COMMENT '数据更新时间',
  CONSTRAINT `PK_JCFX_DATA_KPQYJCXX` PRIMARY KEY (`NSRSBH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='开票企业基础信息表';

-- Creating table JCFX_DATA_QYYHZ
-- Original Oracle primary-key constraint: PK_JCFX_DATA_QYYHZ (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_DATA_QYYHZ` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `ny` CHAR(6) NOT NULL COMMENT '年月',
  `nsrsbh` VARCHAR(20) COMMENT '纳税人识别号',
  `shxydm` VARCHAR(20) COMMENT '社会信用代码',
  `fp_xxfs_zy` DECIMAL(10,0) COMMENT '发票_销项份数_专票',
  `fp_xxje_zy` DECIMAL(18,2) COMMENT '发票_销项金额_专票',
  `fp_xxfs_dgkj` DECIMAL(10,0) COMMENT '发票_销项份数_专票顶格开具',
  `fp_xxje_dgkj` DECIMAL(18,2) COMMENT '发票_销项金额_专票顶格开具',
  `fp_xxfs_pt` DECIMAL(10,0) COMMENT '发票_销项份数_普票',
  `fp_xxje_pt` DECIMAL(18,2) COMMENT '发票_销项金额_普票',
  `fp_xxfs_ck` DECIMAL(10,0) COMMENT '发票_销项份数_出口',
  `fp_xxje_ck` DECIMAL(18,2) COMMENT '发票_销项金额_出口',
  `fp_xxje_ncp` DECIMAL(18,2) COMMENT '发票_销项金额_农产品',
  `fp_xxje_dianfei` DECIMAL(18,2) COMMENT '发票_销项金额_电费',
  `fp_jxfs_zy` DECIMAL(10,0) COMMENT '发票_进项份数_专票',
  `fp_jxje_zy` DECIMAL(18,2) COMMENT '发票_进项金额_专票',
  `fp_jxfs_dgkj` DECIMAL(18,2) COMMENT '发票_进项份数_专票顶格开具',
  `fp_jxje_dgkj` DECIMAL(18,2) COMMENT '发票_进项金额_专票顶格开具',
  `fp_jxje_ds` DECIMAL(18,2) COMMENT '发票_进项金额_本地市',
  `fp_jxje_sn` DECIMAL(18,2) COMMENT '发票_进项金额_省内市外',
  `fp_jxje_sw` DECIMAL(18,2) COMMENT '发票_进项金额_省外',
  `fp_jxfs_pt` DECIMAL(10,0) COMMENT '发票_进项份数_普票',
  `fp_jxje_pt` DECIMAL(18,2) COMMENT '发票_进项金额_普票',
  `fp_jxje_cghwydcg` DECIMAL(18,2) COMMENT '发票_进项金额_常规货物异地采购',
  `fp_jxje_dianfei` DECIMAL(18,2) COMMENT '发票_进项金额_电费',
  `fp_jxje_ysf` DECIMAL(18,2) COMMENT '发票_进项金额_运输费',
  `cz_gdzc` DECIMAL(18,2) COMMENT '财资_固定资产',
  `cz_ch` DECIMAL(18,2) COMMENT '财资_存货',
  `cz_yfzk` DECIMAL(18,2) COMMENT '财资_预付账款',
  `cz_qtysk` DECIMAL(18,2) COMMENT '财资_其他应收款',
  `cz_zczz` DECIMAL(18,2) COMMENT '财资_资产总值',
  `cz_yszk` DECIMAL(18,2) COMMENT '财资_预收账款',
  `cz_qtyfk` DECIMAL(18,2) COMMENT '财资_其他应付款',
  `cz_sszb` DECIMAL(18,2) COMMENT '财资_实收资本',
  `cz_fzzz` DECIMAL(18,2) COMMENT '财资_负债总值',
  `cl_zysr` DECIMAL(18,2) COMMENT '财利_主营收入',
  `cl_zycb` DECIMAL(18,2) COMMENT '财利_主营成本',
  `cl_yysj` DECIMAL(18,2) COMMENT '财利_营业税金',
  `cl_xsfy` DECIMAL(18,2) COMMENT '财利_销售费用',
  `cl_glfy` DECIMAL(18,2) COMMENT '财利_管理费用',
  `cl_cwfy` DECIMAL(18,2) COMMENT '财利_财务费用',
  `cl_lrze` DECIMAL(18,2) COMMENT '财利_利润总额',
  `cl_jlr` DECIMAL(18,2) COMMENT '财利_净利润',
  `sb_jfrs` DECIMAL(10,0) COMMENT '社保_缴费人数',
  `sb_jfjs` DECIMAL(18,2) COMMENT '社保_缴费基数',
  `zzs_qbxssr` DECIMAL(18,2) COMMENT '增表_全部销售收入',
  `zzs_xxse` DECIMAL(18,2) COMMENT '增表_销项税额',
  `zzs_jxse` DECIMAL(18,2) COMMENT '增表_进项税额',
  `zzs_ynse` DECIMAL(18,2) COMMENT '增表_应纳税额',
  `ck_sb_xsemy` DECIMAL(18,2) COMMENT '出口_销售美元',
  `ck_sb_xsermb` DECIMAL(18,2) COMMENT '出口_销售人民币',
  `ck_sb_jsje` DECIMAL(18,2) COMMENT '出口_计税金额',
  `ck_sb_jhcb` DECIMAL(18,2) COMMENT '出口_进货成本',
  `ck_sb_tse` DECIMAL(18,2) COMMENT '出口_申报退税',
  `ck_sb_mde` DECIMAL(18,2) COMMENT '出口_申报免抵',
  `ck_hz_tse` DECIMAL(18,2) COMMENT '出口_核准退税',
  `ck_hz_mde` DECIMAL(18,2) COMMENT '出口_核准免抵',
  `ck_bl_tse` DECIMAL(18,2) COMMENT '出口_办理退税',
  `ck_bl_mde` DECIMAL(18,2) COMMENT '出口_办理免抵',
  `ck_xzsp_cke` DECIMAL(18,2) COMMENT '出口_新增商品出口额',
  `ck_xzghs_jsje` DECIMAL(18,2) COMMENT '出口_新增供应商计税金额',
  `ck_tssp_cke` DECIMAL(18,2) COMMENT '出口_特殊商品出口额',
  `ck_mgsp_cke` DECIMAL(18,2) COMMENT '出口_敏感商品出口额',
  `ck_mgka_cke` DECIMAL(18,2) COMMENT '出口_敏感口岸出口额',
  `sjgxsj` DATETIME COMMENT '数据更新时间',
  `bjts_zt` CHAR(1) DEFAULT 'N' COMMENT '便捷退税更新状态',
  `bjts_sj` DATETIME COMMENT '便捷退税更新时间',
  `cw_zt` CHAR(1) DEFAULT 'N' COMMENT '财务报表更新状态',
  `cw_sj` DATETIME COMMENT '财务报表更新时间',
  `zzs_zt` CHAR(1) DEFAULT 'N' COMMENT '增值税报表更新状态',
  `zzs_sj` DATETIME COMMENT '增值税报表更新时间',
  `sb_zt` CHAR(1) DEFAULT 'N' COMMENT '社保报表更新状态',
  `sb_sj` DATETIME COMMENT '社保报表更新时间',
  `fpg_zt` CHAR(1) DEFAULT 'N' COMMENT '销项发票更新状态',
  `fpg_sj` DATETIME COMMENT '销项发票更新时间',
  `fpx_zt` CHAR(1) DEFAULT 'N' COMMENT '进项发票更新状态',
  `fpx_sj` DATETIME COMMENT '进项发票更新时间',
  `cghw_zt` CHAR(1) DEFAULT 'N' COMMENT '常规货物更新状态',
  `cghw_sj` DATETIME COMMENT '常规货物更新时间',
  `fpqy_zt` CHAR(1) DEFAULT 'N' COMMENT '发票对方企业（上下游/专票）月汇总表更新状态',
  `fpqy_sj` DATETIME COMMENT '发票对方企业（上下游/专票）月汇总表更新时间',
  CONSTRAINT `PK_JCFX_DATA_QYYHZ` PRIMARY KEY (`DJXH`, `NY`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='企业数据月汇总表，202501停止更新';

-- Creating table JCFX_DATA_TSSBMX
-- Original Oracle primary-key constraint: PK_JCFX_DATA_TSSBMX (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_DATA_TSSBMX` (
  `uuid` VARCHAR(32) NOT NULL,
  `tsswjg_dm` CHAR(11) NOT NULL COMMENT '税务机关',
  `sbywlx` CHAR(1) COMMENT '申报业务类型（1免抵退税2免退税3代办退税）',
  `lcslid` VARCHAR(32) COMMENT '申报LCSLID',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `ckbgdh` VARCHAR(21) NOT NULL COMMENT '21位报关单号',
  `ny` CHAR(6) COMMENT '申报年月',
  `sbrq` DATETIME COMMENT '申报日期',
  `ckrq` DATETIME COMMENT '出口日期',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `hggqka_dm` CHAR(4) COMMENT '出口口岸',
  `mygdqsz_dm` CHAR(3) COMMENT '出口国别',
  `jgfs_dm` CHAR(4) COMMENT '贸易方式',
  `hzdwdq_dm` CHAR(5) COMMENT '境内货源地',
  `mylaj` DECIMAL(18,2) COMMENT '出口销售（美元）',
  `rmblaj` DECIMAL(18,2) COMMENT '出口销售（人民币）',
  `jsje` DECIMAL(18,2) COMMENT '计税金额',
  `tsl` DECIMAL(10,6) COMMENT '退税率',
  `tmse` DECIMAL(18,2) COMMENT '申报退免税额',
  `ghfnsrsbh` VARCHAR(20) COMMENT '供货方识别号',
  `hydxzqh_dm` CHAR(4) COMMENT '供货地区（地市级行政区划）',
  `sjgxsj` DATETIME COMMENT '数据更新时间',
  `glh` VARCHAR(20) COMMENT '免退税申报关联号',
  `cksl` DECIMAL(16,4) COMMENT '出口数量',
  KEY `IDX_JCFX_DATA_TSSBMX_DC` (`DJXH`, `CKBGDH`),
  KEY `IDX_JCFX_DATA_TSSBMX_DN` (`DJXH`, `NY`),
  KEY `IDX_JCFX_DATA_TSSBMX_DS` (`DJXH`, `SBRQ`),
  KEY `IDX_JCFX_DATA_TSSBMX_LCSLID` (`LCSLID`),
  KEY `IDX_JCFX_DATA_TSSBMX_SC` (`CKSP_DM`, `CKRQ`),
  KEY `IDX_JCFX_DATA_TSSBMX_SJGXSJ` (`SJGXSJ`),
  CONSTRAINT `PK_JCFX_DATA_TSSBMX` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='退税申报明细表';
-- MySQL requires every PRIMARY/UNIQUE key to contain all partition columns.
-- To preserve the original keys and their uniqueness, this table is not partitioned.
-- Original Oracle partition definition (retained for reference):
-- partition by range (TSSWJG_DM)
-- (
--   partition P_13300000000 values less than ('13301000000')
--     tablespace TL_TSSH,
--   partition P_13301000000 values less than ('13303000000')
--     tablespace TL_TSSH,
--   partition P_13303000000 values less than ('13304000000')
--     tablespace TL_TSSH,
--   partition P_13304000000 values less than ('13305000000')
--     tablespace TL_TSSH,
--   partition P_13305000000 values less than ('13306000000')
--     tablespace TL_TSSH,
--   partition P_13306000000 values less than ('13307000000')
--     tablespace TL_TSSH,
--   partition P_13307000000 values less than ('13308000000')
--     tablespace TL_TSSH,
--   partition P_13308000000 values less than ('13309000000')
--     tablespace TL_TSSH,
--   partition P_13309000000 values less than ('13310000000')
--     tablespace TL_TSSH,
--   partition P_13310000000 values less than ('13311000000')
--     tablespace TL_TSSH,
--   partition P_13311000000 values less than (MAXVALUE)
--     tablespace TL_TSSH
-- )

-- Creating table JCFX_DATA_TSSBMX_TSYW
-- Original Oracle primary-key constraint: PK_JCFX_DATA_TSSBMX_TSYW (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_DATA_TSSBMX_TSYW` (
  `uuid` VARCHAR(32) NOT NULL,
  `tsswjg_dm` CHAR(11) NOT NULL COMMENT '税务机关',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `sbywlx` CHAR(1) NOT NULL COMMENT '申报业务类型（1免抵退税2免退税3代办退税4周边业务）',
  `tsywlx` VARCHAR(20) NOT NULL COMMENT '特殊业务类型',
  `lcslid` VARCHAR(32) NOT NULL COMMENT '申报LCSLID',
  `sbxh` VARCHAR(50) COMMENT '申报序号',
  `sbpzhm` VARCHAR(30) COMMENT '21位报关单号/20位代理证明号/其他凭证号',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `mylaj` DECIMAL(18,2) COMMENT '出口销售（美元）',
  `rmblaj` DECIMAL(18,2) COMMENT '出口销售（人民币）',
  `tmse` DECIMAL(18,2) COMMENT '退免税额',
  `sbny` CHAR(6) COMMENT '申报年月',
  `sbrq` DATETIME COMMENT '申报日期',
  `hzny` CHAR(6) COMMENT '业务核准年月',
  `hzrq` DATETIME COMMENT '业务核准日期',
  KEY `IDX_JCFX_DATA_TSSBMX_TSYW_TH` (`TSSWJG_DM`, `HZNY`),
  KEY `IDX_JCFX_DATA_TSSBMX_TSYW_TS` (`TSSWJG_DM`, `SBNY`),
  CONSTRAINT `PK_JCFX_DATA_TSSBMX_TSYW` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='特殊业务退税申报明细表';

-- Creating table JCFX_DM_CKGB
-- Original Oracle primary-key constraint: PK_JCFX_DM_CKGB (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_DM_CKGB` (
  `ckgb_dm` VARCHAR(3) NOT NULL COMMENT '出口国别代码',
  `ckgb_mc` VARCHAR(80) NOT NULL COMMENT '出口国别名称',
  `pid` VARCHAR(3),
  CONSTRAINT `PK_JCFX_DM_CKGB` PRIMARY KEY (`CKGB_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口国别代码表';

-- Creating table JCFX_DM_CKGM
CREATE TABLE `JCFX_DM_CKGM` (
  `ckgm_dm` CHAR(1) NOT NULL,
  `ckgm_mc` VARCHAR(50),
  PRIMARY KEY (`CKGM_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table JCFX_DM_CKKA
-- Original Oracle primary-key constraint: PK_JCFX_DM_CKKA (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_DM_CKKA` (
  `ckka_dm` VARCHAR(4) NOT NULL COMMENT '出口口岸代码',
  `ckka_mc` VARCHAR(80) NOT NULL COMMENT '出口口岸名称',
  `pid` VARCHAR(4),
  CONSTRAINT `PK_JCFX_DM_CKKA` PRIMARY KEY (`CKKA_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口口岸代码表';

-- Creating table JCFX_DM_CKQYLX
-- Original Oracle primary-key constraint: PK_JCFX_DM_CKQYLX (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_DM_CKQYLX` (
  `ckqylx_dm` VARCHAR(1) NOT NULL COMMENT '企业类型代码',
  `ckqylx_mc` VARCHAR(50) NOT NULL COMMENT '企业类型名称',
  CONSTRAINT `PK_JCFX_DM_CKQYLX` PRIMARY KEY (`CKQYLX_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口企业类型表';

-- Creating table JCFX_DM_CKSP
-- Original Oracle primary-key constraint: PK_JCFX_DM_CKSP (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_DM_CKSP` (
  `cksp_dm` VARCHAR(20) NOT NULL COMMENT '出口商品代码',
  `cksp_mc` VARCHAR(80) NOT NULL COMMENT '出口商品名称',
  `spdm_8` VARCHAR(8) COMMENT '出口商品代码（8位）',
  `spdm_4` VARCHAR(4) COMMENT '出口商品代码（4位）',
  `spdm_2` VARCHAR(2) COMMENT '出口商品代码（2位）',
  `spdm_0` VARCHAR(3) COMMENT '海关23大类',
  CONSTRAINT `PK_JCFX_DM_CKSP` PRIMARY KEY (`CKSP_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口商品代码表';

-- Creating table JCFX_DM_CKSPTREE
-- Original Oracle primary-key constraint: PK_JCFX_DM_CKSPTREE (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_DM_CKSPTREE` (
  `cksp_dm` VARCHAR(20) NOT NULL COMMENT '出口商品代码',
  `cksp_mc` VARCHAR(500) COMMENT '出口商品名称',
  `pid` VARCHAR(20) NOT NULL COMMENT '上级树节点',
  `cksp_jc` CHAR(1) NOT NULL COMMENT '树节点级次',
  `pid_jc` CHAR(1) NOT NULL COMMENT '上级树节点级次',
  CONSTRAINT `PK_JCFX_DM_CKSPTREE` PRIMARY KEY (`CKSP_JC`, `CKSP_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口商品树结构表';

-- Creating table JCFX_DM_DJZCLX
-- Original Oracle primary-key constraint: PK_JCFX_DM_DJZCLX (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_DM_DJZCLX` (
  `djzclx_dm` VARCHAR(3) NOT NULL COMMENT '登记注册类型代码',
  `djzclx_mc` VARCHAR(50) NOT NULL COMMENT '登记注册类型名称',
  `pid` VARCHAR(3),
  CONSTRAINT `PK_JCFX_DM_DJZCLX` PRIMARY KEY (`DJZCLX_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='登记注册类型表';

-- Creating table JCFX_DM_FLGL
-- Original Oracle primary-key constraint: PK_JCFX_DM_FLGL (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_DM_FLGL` (
  `flgl_dm` VARCHAR(1) NOT NULL COMMENT '管理类别代码',
  `flgl_mc` VARCHAR(50) NOT NULL COMMENT '管理类别名称',
  CONSTRAINT `PK_JCFX_DM_FLGL` PRIMARY KEY (`FLGL_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口企业分类管理代码表';

-- Creating table JCFX_DM_GHDQ
-- Original Oracle primary-key constraint: PK_JCFX_DM_GHDQ (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_DM_GHDQ` (
  `ghdq_dm` VARCHAR(4) NOT NULL COMMENT '供货地区代码',
  `ghdq_mc` VARCHAR(80) NOT NULL COMMENT '供货地区名称',
  `pid` VARCHAR(4),
  CONSTRAINT `PK_JCFX_DM_GHDQ` PRIMARY KEY (`GHDQ_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='供货地区代码表';

-- Creating table JCFX_DM_HY
-- Original Oracle primary-key constraint: PK_JCFX_DM_HY (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_DM_HY` (
  `hy_dm` VARCHAR(4) NOT NULL COMMENT '行业代码',
  `hy_mc` VARCHAR(50) NOT NULL COMMENT '行业名称',
  `pid` VARCHAR(4),
  CONSTRAINT `PK_JCFX_DM_HY` PRIMARY KEY (`HY_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='行业代码表';

-- Creating table JCFX_DM_MYFS
-- Original Oracle primary-key constraint: PK_JCFX_DM_MYFS (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_DM_MYFS` (
  `myfs_dm` VARCHAR(4) NOT NULL COMMENT '贸易方式代码',
  `myfs_mc` VARCHAR(80) NOT NULL COMMENT '贸易方式名称',
  `pid` VARCHAR(4),
  CONSTRAINT `PK_JCFX_DM_MYFS` PRIMARY KEY (`MYFS_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='贸易方式代码表';

-- Creating table JCFX_DM_NSRLB
-- Original Oracle primary-key constraint: PK_JCFX_DM_NSRLB (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_DM_NSRLB` (
  `nsrlb_dm` VARCHAR(1) NOT NULL COMMENT '纳税人类别代码',
  `nsrlb_mc` VARCHAR(50) NOT NULL COMMENT '纳税人类别名称',
  CONSTRAINT `PK_JCFX_DM_NSRLB` PRIMARY KEY (`NSRLB_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='纳税人类别代码表';

-- Creating table JCFX_DM_NSRZT
-- Original Oracle primary-key constraint: PK_JCFX_DM_NSRZT (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_DM_NSRZT` (
  `nsrzt_dm` VARCHAR(2) NOT NULL COMMENT '纳税人状态代码',
  `nsrzt_mc` VARCHAR(50) NOT NULL COMMENT '纳税人状态名称',
  CONSTRAINT `PK_JCFX_DM_NSRZT` PRIMARY KEY (`NSRZT_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='纳税人状态表';

-- Creating table JCFX_DM_QYFZ
-- Original Oracle primary-key constraint: PK_JCFX_DM_QYFZ (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_DM_QYFZ` (
  `qyfz_dm` VARCHAR(11) NOT NULL COMMENT '企业分组代码',
  `qyfz_mc` VARCHAR(80) NOT NULL COMMENT '企业分组名称',
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  CONSTRAINT `PK_JCFX_DM_QYFZ` PRIMARY KEY (`QYFZ_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='企业分组代码表';

-- Creating table JCFX_DM_SZQJZB
-- Original Oracle primary-key constraint: PK_JCFX_DM_SZQJZB (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_DM_SZQJZB` (
  `zbxm` VARCHAR(10) NOT NULL COMMENT '指标项目',
  `dm` VARCHAR(20) NOT NULL COMMENT '代码',
  `mc` VARCHAR(80) NOT NULL COMMENT '名称',
  `minval` DECIMAL(16,2) COMMENT '下限',
  `maxval` DECIMAL(16,2) COMMENT '上限',
  CONSTRAINT `PK_JCFX_DM_SZQJZB` PRIMARY KEY (`ZBXM`, `DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='数值区间类指标代码表';

-- Creating table JCFX_DM_TSYW
-- Original Oracle primary-key constraint: PK_JCFX_DM_TSYW (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_DM_TSYW` (
  `tsyw_dm` VARCHAR(10) NOT NULL COMMENT '特殊业务代码',
  `tsyw_mc` VARCHAR(50) NOT NULL COMMENT '特殊业务名称',
  CONSTRAINT `PK_JCFX_DM_TSYW` PRIMARY KEY (`TSYW_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='特殊业务代码表';

-- Creating table JCFX_DM_YSFS
-- Original Oracle primary-key constraint: PK_JCFX_DM_YSFS (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_DM_YSFS` (
  `ysfs_dm` VARCHAR(1) NOT NULL COMMENT '运输方式代码',
  `ysfs_mc` VARCHAR(80) NOT NULL COMMENT '运输方式名称',
  CONSTRAINT `PK_JCFX_DM_YSFS` PRIMARY KEY (`YSFS_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='运输方式代码表';

-- Creating table JCFX_NSR_BADJ
-- Original Oracle primary-key constraint: PK_JCFX_NSR_BADJ (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_NSR_BADJ` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `nsrsbh` VARCHAR(20) NOT NULL COMMENT '纳税人识别号',
  `shxydm` VARCHAR(20) COMMENT '社会信用代码',
  `nsrmc` VARCHAR(100) NOT NULL COMMENT '纳税人名称',
  `qyhgdm` VARCHAR(20) COMMENT '企业海关代码',
  `ckqylx` CHAR(1) COMMENT '出口企业类型',
  `flglcd` CHAR(1) COMMENT '出口管理类别',
  `djzclx` CHAR(3) COMMENT '登记注册类型',
  `hy` CHAR(4) COMMENT '行业',
  `nsrzt` VARCHAR(2) COMMENT '纳税人状态',
  `nsrlb` CHAR(1) COMMENT '纳税人类别',
  `qyfz` VARCHAR(11) COMMENT '企业分组',
  `sq_date` DATETIME COMMENT '备案日期',
  `bachbz` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '备案撤回标志',
  `bachsj` DATETIME COMMENT '备案撤回时间',
  `swjgdm` VARCHAR(11) NOT NULL COMMENT '主管税务机关',
  `ksswjg_dm` VARCHAR(11) COMMENT '税务机关科所',
  `jdxz_dm` VARCHAR(10) COMMENT '街道乡镇代码，备用',
  `nsrdzdah` DECIMAL(20,0) COMMENT '电子档案号，备用',
  `ckblv` DECIMAL(10,6) COMMENT '出口比例（百分比）',
  `mdblv` DECIMAL(10,6) COMMENT '免抵比例（百分比）',
  `sflv` DECIMAL(10,6) COMMENT '税负率（百分比）',
  `ckgm` DECIMAL(18,2) COMMENT '出口规模（美元）',
  `ckblv_dm` CHAR(1) COMMENT '出口比例（等级，ABCDE）',
  `mdblv_dm` CHAR(1) COMMENT '免抵比例（等级，ABCDE）',
  `sflv_dm` CHAR(1) COMMENT '税负率（等级，ABCDE）',
  `ckgm_dm` CHAR(1) COMMENT '出口规模（等级，ABCDE）',
  KEY `IDX_JCFX_NSR_BADJ_CKQYLX` (`CKQYLX`),
  KEY `IDX_JCFX_NSR_BADJ_N` (`NSRSBH`),
  CONSTRAINT `PK_JCFX_NSR_BADJ` PRIMARY KEY (`DJXH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='纳税人备案登记表';

-- Creating table JCFX_NSR_BADJ_TOHZ
-- Original Oracle primary-key constraint: PK_JCFX_NSR_BADJ_TOHZ (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_NSR_BADJ_TOHZ` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `nsrsbh` VARCHAR(20) NOT NULL COMMENT '纳税人识别号',
  `shxydm` VARCHAR(20) COMMENT '社会信用代码',
  `jlxzsj` DATETIME COMMENT '记录新增时间（根据记录新增时间，提前两年的完整年度抽取企业月汇总表）',
  `bachsj` DATETIME COMMENT '备案撤回时间',
  `swjgdm` VARCHAR(11) COMMENT '主管税务机关',
  `jcfxsj` DATETIME COMMENT '统计时间,当月已统计不统计,ETL使用',
  CONSTRAINT `PK_JCFX_NSR_BADJ_TOHZ` PRIMARY KEY (`DJXH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='纳税人备案登记表';

-- Creating table JCFX_NSR_SAMPLE
-- Original Oracle primary-key constraint: PK_JCFX_NSR_SAMPLE (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_NSR_SAMPLE` (
  `zid` DECIMAL(10,0) NOT NULL COMMENT '序号',
  `sname` VARCHAR(50) NOT NULL COMMENT '样本名称',
  `swjgdm` VARCHAR(11) NOT NULL COMMENT '归属税务机关',
  `syfw_swjg` VARCHAR(11) NOT NULL COMMENT '适用范围',
  `qybz` VARCHAR(1) NOT NULL DEFAULT 'Y' COMMENT '启用标志',
  `xgr` VARCHAR(30) NOT NULL COMMENT '创建/修改人',
  `xgsj` DATETIME NOT NULL COMMENT '修改时间',
  CONSTRAINT `PK_JCFX_NSR_SAMPLE` PRIMARY KEY (`ZID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='样本企业表';

-- Creating table JCFX_NSR_SAMPLE_SUB
-- Original Oracle primary-key constraint: PK_JCFX_NSR_SAMPLE_SUB (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_NSR_SAMPLE_SUB` (
  `id` DECIMAL(10,0) NOT NULL COMMENT '序号',
  `zid` DECIMAL(10,0) NOT NULL COMMENT '序号',
  `nsrsbh` VARCHAR(20) NOT NULL COMMENT '纳税人识别号',
  `nsrmc` VARCHAR(100) NOT NULL COMMENT '纳税人名称',
  `qybz` VARCHAR(1) NOT NULL DEFAULT 'Y' COMMENT '启用标志',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  KEY `IDX_JCFX_NSR_SAMPLE_SUB_Z` (`ZID`),
  CONSTRAINT `PK_JCFX_NSR_SAMPLE_SUB` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='样本企业子表';

-- Creating table JCFX_TASK
-- JCFX_TASK.tqcs: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- Original Oracle primary-key constraint: PK_ID (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_TASK` (
  `id` VARCHAR(32) NOT NULL COMMENT '任务ID，采用HASH值作为报文主键',
  `czry_dm` VARCHAR(40) NOT NULL COMMENT '操作人员代码',
  `req_param` LONGTEXT,
  `resp_data` LONGBLOB,
  `task_flag` CHAR(1) COMMENT '任务标记，0-未提取，1提取中，2任务完成',
  `tqbz` VARCHAR(64) COMMENT '提取标志',
  `tqsj` DATETIME(6) COMMENT '提取时间',
  `wcsj` DATETIME(6) COMMENT '完成时间',
  `tqcs` DECIMAL(65,27) COMMENT '提取次数',
  `crtime` DATETIME(6),
  `title` VARCHAR(200) COMMENT '标题',
  `sqltext` LONGTEXT COMMENT 'SQL脚本',
  `swjgdm` VARCHAR(20),
  `bbtype` VARCHAR(10) COMMENT '报表类型',
  CONSTRAINT `PK_ID` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table JCFX_TASK_SUB
-- JCFX_TASK_SUB.page_no: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- Original Oracle primary-key constraint: PK_PID_PAGE (MySQL index name: PRIMARY).
CREATE TABLE `JCFX_TASK_SUB` (
  `pid` VARCHAR(32) NOT NULL,
  `page_no` DECIMAL(65,27) NOT NULL,
  `resp_data` LONGBLOB,
  CONSTRAINT `PK_PID_PAGE` PRIMARY KEY (`PID`, `PAGE_NO`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table JKGL_DATA_BGQ
-- Original Oracle primary-key constraint: PK_JKGL_DATA_BGQ (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_DATA_BGQ` (
  `bgqid` DECIMAL(20,0) NOT NULL COMMENT '报告期id',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '纳税人登记序号',
  `zqlx` VARCHAR(10) COMMENT '统计周期  年/季/月',
  `bgq_q` DATETIME COMMENT '报告期起',
  `bgq_z` DATETIME COMMENT '报告期止',
  `sxzt` CHAR(1) COMMENT '刷新状态 0待刷新  1刷新中 2,3已刷新',
  `tqbz` VARCHAR(40) COMMENT '提取标识（提取线程UUID)',
  `tqsj` DATETIME COMMENT '提取时间',
  `wcsj` DATETIME COMMENT '完成时间',
  `zzs_zt` CHAR(1) DEFAULT 'N' COMMENT '增值税报表更新状态',
  `zzs_sj` DATETIME COMMENT '增值税报表更新时间',
  `dzdz_zt` CHAR(1) DEFAULT 'N' COMMENT '底账更新状态',
  `dzdz_sj` DATETIME COMMENT '底账更新时间',
  `dzsp_zt` CHAR(1) DEFAULT 'N' COMMENT '底账商品更新状态',
  `dzsp_sj` DATETIME COMMENT '底账商品更新时间',
  `zbu_dzgf_zt` CHAR(1) DEFAULT 'N' COMMENT '底账更新状态ZBU_DZGF',
  `zbu_dzgf_sj` DATETIME COMMENT '底账更新时间ZBU_DZGF',
  `zbu_dzxf_zt` CHAR(1) DEFAULT 'N' COMMENT '底账更新状态ZBU_DZXF',
  `zbu_dzxf_sj` DATETIME COMMENT '底账更新时间ZBU_DZXF',
  `zbu_dzspjx_zt` CHAR(1) DEFAULT 'N' COMMENT '底账更新状态ZBU_DZSPJX',
  `zbu_dzspjx_sj` DATETIME COMMENT '底账更新时间ZBU_DZSPJX',
  `zbu_dzspxx_zt` CHAR(1) DEFAULT 'N' COMMENT '底账更新状态ZBU_DZSPXX',
  `zbu_dzspxx_sj` DATETIME COMMENT '底账更新时间ZBU_DZSPXX',
  `sds_zt` CHAR(1) DEFAULT 'N' COMMENT '所得税报表更新状态',
  `sds_sj` DATETIME COMMENT '所得税报表更新时间，仅更新年度报告期，每年6月1日以后刷新上年度报告期',
  KEY `IDX_JKGL_DATA_BGQ` (`DJXH`, `BGQ_Q`, `BGQ_Z`),
  CONSTRAINT `PK_JKGL_DATA_BGQ` PRIMARY KEY (`BGQID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='指标统计报告期（主线表）';

-- Creating table JKGL_DATA_BGQ_QSPJ
-- Original Oracle primary-key constraint: PK_JKGL_DATA_BGQ_QSPJ (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_DATA_BGQ_QSPJ` (
  `bgqid` DECIMAL(20,0) NOT NULL COMMENT '报告期id',
  `qylx` CHAR(1) COMMENT '企业类型  1生产  2外贸',
  `bgq_q` DATETIME COMMENT '报告期起',
  `bgq_z` DATETIME COMMENT '报告期止',
  `sxzt` CHAR(1) COMMENT '刷新状态 0待刷新  1刷新中 2已刷新',
  `tqbz` VARCHAR(40) COMMENT '提取标识（提取线程UUID)',
  `tqsj` DATETIME COMMENT '提取时间',
  `wcsj` DATETIME COMMENT '完成时间',
  `swjg_dm` VARCHAR(11) COMMENT '全省  1330000',
  `qybj` CHAR(1) DEFAULT 'N' COMMENT 'Y/N',
  KEY `IDX_JKGL_DATA_BGQ_QSPJ` (`QYLX`, `BGQ_Q`, `BGQ_Z`),
  CONSTRAINT `PK_JKGL_DATA_BGQ_QSPJ` PRIMARY KEY (`BGQID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='全省平均值统计报告期（主线表）';

-- Creating table JKGL_DATA_QYJKM_JGB
-- Original Oracle primary-key constraint: PK_JKGL_DATA_QYJKM_JGB (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_DATA_QYJKM_JGB` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '纳税人登记序号PK',
  `jkm_level` CHAR(1) COMMENT '健康码等级（1绿 2黄 3红）',
  `score_10` DECIMAL(38,0) COMMENT '信用分',
  `score_20` DECIMAL(38,0) COMMENT '申报征收分',
  `score_30` DECIMAL(38,0) COMMENT '出口退税分',
  `score_40` DECIMAL(38,0) COMMENT '财务报表分',
  `score_50` DECIMAL(38,0) COMMENT '发票供应链分',
  `score_60` DECIMAL(38,0) COMMENT '其他分',
  `score_zh` DECIMAL(38,0) COMMENT '健康码综合分',
  `uptime` DATETIME COMMENT '更新时间',
  `tsjsfs_dm` CHAR(1) COMMENT '退税计算方式
',
  `note` VARCHAR(200) COMMENT '健康码构成说明
',
  `rgfm_level` CHAR(1) COMMENT '人工赋码（1,2,3）
',
  `rgfmsj` DATETIME COMMENT '人工赋码时间
',
  `fmyxq` DATETIME COMMENT '人工赋码有效期止
',
  `czydm` VARCHAR(20) COMMENT '操作员代码
',
  `czymc` VARCHAR(30) COMMENT '操作员名称
',
  `rgbzms` VARCHAR(200) COMMENT '人工赋码备注描述
',
  `crtime` DATETIME,
  CONSTRAINT `PK_JKGL_DATA_QYJKM_JGB` PRIMARY KEY (`DJXH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口企业健康码结果表';

-- Creating table JKGL_DATA_QYJKM_LSB
-- Original Oracle primary-key constraint: PK_JKGL_DATA_QYJKM_LSB (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_DATA_QYJKM_LSB` (
  `id` DECIMAL(20,0) NOT NULL,
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '纳税人登记序号PK',
  `jkm_level` CHAR(1) COMMENT '健康码等级（1绿 2黄 3红）',
  `score_10` DECIMAL(38,0) COMMENT '信用分',
  `score_20` DECIMAL(38,0) COMMENT '申报征收分',
  `score_30` DECIMAL(38,0) COMMENT '出口退税分',
  `score_40` DECIMAL(38,0) COMMENT '财务报表分',
  `score_50` DECIMAL(38,0) COMMENT '发票供应链分',
  `score_60` DECIMAL(38,0) COMMENT '其他分',
  `score_zh` DECIMAL(38,0) COMMENT '健康码综合分',
  `uptime` DATETIME COMMENT '更新时间',
  `tsjsfs_dm` CHAR(1) COMMENT '退税计算方式
',
  `note` VARCHAR(200) COMMENT '健康码构成说明
',
  `rgfm_level` CHAR(1) COMMENT '人工赋码（1,2,3）
',
  `rgfmsj` DATETIME COMMENT '人工赋码时间
',
  `fmyxq` DATETIME COMMENT '人工赋码有效期止
',
  `czydm` VARCHAR(20) COMMENT '操作员代码
',
  `czymc` VARCHAR(30) COMMENT '操作员名称
',
  `rgbzms` VARCHAR(200) COMMENT '人工赋码备注描述
',
  CONSTRAINT `PK_JKGL_DATA_QYJKM_LSB` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口企业健康码历史结果表';

-- Creating table JKGL_DATA_TASK
-- Original Oracle primary-key constraint: PK_JKGL_DATA_TASK (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_DATA_TASK` (
  `bgqid` DECIMAL(20,0) NOT NULL,
  `sxzt` CHAR(1) COMMENT '''0'',''待刷新'',''1'',''刷新中'',''2'',''已刷新''',
  `tqbz` VARCHAR(40) COMMENT '提取标志',
  `tqsj` DATETIME COMMENT '提取时间',
  `wcsj` DATETIME COMMENT '完成时间',
  `crtime` DATETIME COMMENT '任务创建时间',
  CONSTRAINT `PK_JKGL_DATA_TASK` PRIMARY KEY (`BGQID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table JKGL_DATA_TJ_ZB
-- Original Oracle primary-key constraint: JKGL_DATA_TJ_ZB (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_DATA_TJ_ZB` (
  `bgqid` DECIMAL(20,0) NOT NULL COMMENT '报告期ID PK',
  `zb_id` VARCHAR(30) NOT NULL COMMENT '指标标识 PK',
  `zb_val` DECIMAL(18,2) COMMENT '指标计算结果（逻辑型用1/0表示）',
  `badpoint` CHAR(1) COMMENT '坏点标志 Y /N 当计算条件不满足或异常判断有条件不满足时，可打Y坏点，后续不参与健康综合评判',
  `params` VARCHAR(4000) COMMENT '记录计算参数[d]出口销售=100|出口数量=40[s]SQL脚本',
  `uptime` DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `JKGL_DATA_TJ_ZB` PRIMARY KEY (`BGQID`, `ZB_ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='报告期指标统计结果表';

-- Creating table JKGL_DATA_TJ_ZBU
-- Original Oracle primary-key constraint: PK_JKGL_DATA_TJ_ZBU (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_DATA_TJ_ZBU` (
  `bgqid` DECIMAL(20,0) NOT NULL COMMENT '报告期ID',
  `ck_bgdsl` DECIMAL(10,0) COMMENT '出口_报关单数量',
  `ck_ckeusd` DECIMAL(18,2) COMMENT '出口_出口额USD',
  `ck_ckermb` DECIMAL(18,2) COMMENT '出口_出口额RMB',
  `ck_sbdw_sl` DECIMAL(10,0) COMMENT '出口_申报单位数量',
  `ck_gb_sl` DECIMAL(10,0) COMMENT '出口_目的国数量',
  `ck_bgdsl_de` DECIMAL(10,0) COMMENT '出口_大额报关单数量',
  `ck_ckeusd_de` DECIMAL(18,2) COMMENT '出口_大额报关单出口额USD',
  `ck_bgdsl_st` DECIMAL(10,0) COMMENT '出口_四同报关单数量',
  `ck_pxbgdsl` DECIMAL(10,0) COMMENT '出口_拼箱报关单数量',
  `ck_zxbgdsl` DECIMAL(18,2) COMMENT '出口_整箱报关单数量',
  `ck_pjdbhgz` DECIMAL(18,2) COMMENT '出口_平均单笔货柜值',
  `ck_ckeusd_lastyear` DECIMAL(18,2) COMMENT '出口_最近12个月出口额USD',
  `zzs_xse_qb` DECIMAL(18,2) COMMENT '增值税_销售额_全部',
  `zzs_xse_mdt` DECIMAL(18,2) COMMENT '增值税_销售额_免抵退出口',
  `zzs_xse_ms` DECIMAL(18,2) COMMENT '增值税_销售额_免税',
  `zzs_xxse` DECIMAL(18,2) COMMENT '增值税_销项税额',
  `zzs_jxse` DECIMAL(18,2) COMMENT '增值税_进项税额',
  `zzs_jxsezc` DECIMAL(18,2) COMMENT '增值税_进项税额转出',
  `zzs_mdtbddkjxse` DECIMAL(18,2) COMMENT '增值税_免抵退不得抵扣进项税额',
  `zzs_ynse` DECIMAL(18,2) COMMENT '增值税_应纳税额',
  `dz_xxfs_qb` DECIMAL(10,0) COMMENT '底账_销项份数_全部',
  `dz_xxje_qb` DECIMAL(18,2) COMMENT '底账_销项金额_全部',
  `dz_xxse_qb` DECIMAL(18,2) COMMENT '底账_销项税额_全部',
  `dz_xxfs_zy` DECIMAL(10,0) COMMENT '底账_销项份数_专票',
  `dz_xxje_zy` DECIMAL(18,2) COMMENT '底账_销项金额_专票',
  `dz_xxse_zy` DECIMAL(18,2) COMMENT '底账_销项税额_专票',
  `dz_xxfs_pt` DECIMAL(10,0) COMMENT '底账_销项份数_普票',
  `dz_xxje_pt` DECIMAL(18,2) COMMENT '底账_销项金额_普票',
  `dz_xxse_pt` DECIMAL(18,2) COMMENT '底账_销项税额_普票',
  `dz_xxfs_ck` DECIMAL(10,0) COMMENT '底账_销项份数_出口',
  `dz_xxje_ck` DECIMAL(18,2) COMMENT '底账_销项金额_出口',
  `dz_jxfs_qb` DECIMAL(10,0) COMMENT '底账_全部进项份数',
  `dz_jxje_qb` DECIMAL(18,2) COMMENT '底账_全部进项金额',
  `dz_jxse_qb` DECIMAL(18,2) COMMENT '底账_全部进项税额',
  `dz_jxfs_zy` DECIMAL(10,0) COMMENT '底账_进项份数_专票',
  `dz_jxje_zy` DECIMAL(18,2) COMMENT '底账_进项金额_专票',
  `dz_jxse_zy` DECIMAL(18,2) COMMENT '底账_进项税额_专票',
  `dz_jxfs_pt` DECIMAL(10,0) COMMENT '底账_进项份数_普票',
  `dz_jxje_pt` DECIMAL(18,2) COMMENT '底账_进项金额_普票',
  `dz_jxse_pt` DECIMAL(18,2) COMMENT '底账_进项税额_普票',
  `dz_jxfs_dgkj` DECIMAL(10,0) COMMENT '底账_进项份数_专票顶格开具',
  `dz_jxje_dgkj` DECIMAL(18,2) COMMENT '底账_进项金额_专票顶格开具',
  `dz_jxse_dgkj` DECIMAL(18,2) COMMENT '底账_进项税额_专票顶格开具',
  `dz_jxse_jks` DECIMAL(18,2) COMMENT '底账_进项税额_缴款书',
  `dz_jxje_ncp` DECIMAL(18,2) COMMENT '增值税_进项金额_农产品',
  `dz_jxse_ncp` DECIMAL(18,2) COMMENT '增值税_进项税额_农产品',
  `dz_dfje_sr` DECIMAL(18,2) COMMENT '底账_电费收入（销项）',
  `dz_dfje_zc` DECIMAL(18,2) COMMENT '底账_电费支出（进项）',
  `dz_wtjg` DECIMAL(18,2) COMMENT '底账_委托加工费支出',
  `dz_yfje` DECIMAL(18,2) COMMENT '底账_运费支出',
  `dz_jxje_sn` DECIMAL(18,2) COMMENT '底账_进项金额_省内',
  `dz_jxje_sw` DECIMAL(18,2) COMMENT '底账_进项金额_省外',
  `ts_ckeusd` DECIMAL(18,2) COMMENT '退税_出口额USD',
  `ts_ckermb` DECIMAL(18,2) COMMENT '退税_出口额RMB',
  `ts_tse_sb` DECIMAL(18,2) COMMENT '退税_退税额_申报',
  `ts_mde_sb` DECIMAL(18,2) COMMENT '退税_免抵额_申报',
  `ts_tse_hz` DECIMAL(18,2) COMMENT '退税_退税_核准',
  `ts_mde_hz` DECIMAL(18,2) COMMENT '退税_免抵_核准',
  `ts_tse_bl` DECIMAL(18,2) COMMENT '退税_退税_办理',
  `ts_mde_bl` DECIMAL(18,2) COMMENT '退税_免抵_办理',
  `ts_ckermb_stzc` DECIMAL(18,2) COMMENT '退税_视同自产出口额',
  `ts_jsje` DECIMAL(18,2) COMMENT '退税_计税金额（免退税）',
  `ts_hhcb` DECIMAL(18,2) COMMENT '退税_每百元出口成本（免退税）',
  `ts_jhfp_je_dg` DECIMAL(18,2) COMMENT '退税_顶格开票金额',
  `ts_jhfp_fs_dg` DECIMAL(10,0) COMMENT '退税_顶格开票份数',
  `ts_jhfp_je` DECIMAL(18,2) COMMENT '退税_发票总金额',
  `ts_jhfp_fs` DECIMAL(10,0) COMMENT '退税_发票总份数',
  `ts_jhfp_je_cq1` DECIMAL(18,2) COMMENT '退税_超期1发票金额',
  `ts_jhfp_fs_cq1` DECIMAL(10,0) COMMENT '退税_超期1发票份数',
  `ts_jhfp_je_cq2` DECIMAL(18,2) COMMENT '退税_超期2发票金额',
  `ts_jhfp_fs_cq2` DECIMAL(10,0) COMMENT '退税_超期2发票份数',
  `ts_ghs_num` DECIMAL(10,0) COMMENT '退税_供货商个数',
  `zc_yszk_qc` DECIMAL(18,2) COMMENT '资产_应收账款_期初',
  `zc_yszk_qm` DECIMAL(18,2) COMMENT '资产_应收账款_期末',
  `zc_yfzk_qc` DECIMAL(18,2) COMMENT '资产_应付账款_期初',
  `zc_yfzk_qm` DECIMAL(18,2) COMMENT '资产_应付账款_期末',
  `zc_gdzc_qc` DECIMAL(18,2) COMMENT '资产_固定资产_期初',
  `zc_gdzc_qm` DECIMAL(18,2) COMMENT '资产_固定资产_期末',
  `zc_ch_qc` DECIMAL(18,2) COMMENT '资产_存货_期初',
  `zc_ch_qm` DECIMAL(18,2) COMMENT '资产_存货_期末',
  `zc_zcze_qc` DECIMAL(18,2) COMMENT '资产_资产总额_期初',
  `zc_zcze_qm` DECIMAL(18,2) COMMENT '资产_资产总额_期末',
  `zc_fzze_qc` DECIMAL(18,2) COMMENT '资产_负债总额_期初',
  `zc_fzze_qm` DECIMAL(18,2) COMMENT '资产_负债总额_期末',
  `lr_yysr` DECIMAL(18,2) COMMENT '利润_主营业务收入',
  `lr_yycb` DECIMAL(18,2) COMMENT '利润_主营业务成本',
  `lr_xsfy` DECIMAL(18,2) COMMENT '利润_销售费用',
  `lr_glfy` DECIMAL(18,2) COMMENT '利润_管理费用',
  `lr_lrze` DECIMAL(18,2) COMMENT '利润_利润总额',
  `sds_yysr` DECIMAL(18,2) COMMENT '所得税_营业收入',
  `sds_ynssde` DECIMAL(18,2) COMMENT '所得税_应纳税所得额',
  `ts_bgdsl` DECIMAL(10,0) COMMENT '退税_报关单数量',
  `ts_bgdsl_cq` DECIMAL(10,0) COMMENT '退税_报关单数量_超期申报',
  `ts_ckeusd_cq` DECIMAL(18,2) COMMENT '退税_出口额USD_超期申报',
  `zc_syzqy_qc` DECIMAL(18,2) COMMENT '资产_所有者权益_期初',
  `zc_syzqy_qm` DECIMAL(18,2) COMMENT '资产_所有者权益_期末',
  `zc_ssgdqy_qc` DECIMAL(18,2) COMMENT '资产_少数股东权益_期初',
  `zc_ssgdqy_qm` DECIMAL(18,2) COMMENT '资产_少数股东权益_期末',
  `zc_ldzc_qc` DECIMAL(18,2) COMMENT '资产_流动资产_期初',
  `zc_ldzc_qm` DECIMAL(18,2) COMMENT '资产_流动资产_期末',
  `zc_yuszk_qc` DECIMAL(18,2) COMMENT '资产_预收账款_期初',
  `zc_yuszk_qm` DECIMAL(18,2) COMMENT '资产_预收账款_期末',
  `zc_yufzk_qc` DECIMAL(18,2) COMMENT '资产_预付账款_期初',
  `zc_yufzk_qm` DECIMAL(18,2) COMMENT '资产_预付账款_期末',
  `zc_ldfzze_qc` DECIMAL(18,2) COMMENT '资产_流动负债总额_期初',
  `zc_ldfzze_qm` DECIMAL(18,2) COMMENT '资产_流动负债总额_期末',
  `lr_qtsr` DECIMAL(18,2) COMMENT '利润_其它收入',
  `lr_sjjfj` DECIMAL(18,2) COMMENT '利润_税金及附加',
  `lr_cwfy` DECIMAL(18,2) COMMENT '利润_财务费用',
  `lr_jlr` DECIMAL(18,2) COMMENT '利润_净利润',
  `lr_sds` DECIMAL(18,2) COMMENT '利润_所得税',
  `lr_lxzc` DECIMAL(18,2) COMMENT '利润_利息支出',
  `lr_yylr` DECIMAL(18,2) COMMENT '利润_营业利润',
  `ts_mtscke` DECIMAL(18,2) COMMENT '退税_免退税期间出口额RMB',
  CONSTRAINT `PK_JKGL_DATA_TJ_ZBU` PRIMARY KEY (`BGQID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='报告期指标元统计--单项数据';

-- Creating table JKGL_DATA_TJ_ZBU_CKGB
-- Original Oracle primary-key constraint: PK_JKGL_DATA_TJ_ZBU_CKGB (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_DATA_TJ_ZBU_CKGB` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '序号',
  `bgqid` DECIMAL(20,0) COMMENT '报告期ID',
  `gb_dm` VARCHAR(3) COMMENT '国别代码',
  `ckeusd` DECIMAL(18,2) COMMENT '出口额USD',
  `ckermb` DECIMAL(18,2) COMMENT '出口额',
  `kasl` DECIMAL(38,0) COMMENT '口岸数量',
  `sbdwsl` DECIMAL(38,0) COMMENT '申报单位数量',
  `ysfssl` DECIMAL(38,0) COMMENT '运输方式数量',
  `mgbz` CHAR(1) DEFAULT '0' COMMENT '敏感标志  1敏感/0正常',
  KEY `IDX_JKGL_DATA_TJ_ZBU_CKGB` (`BGQID`, `GB_DM`),
  CONSTRAINT `PK_JKGL_DATA_TJ_ZBU_CKGB` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='报告期指标元统计-出口国别汇总';

-- Creating table JKGL_DATA_TJ_ZBU_CKKA
-- Original Oracle primary-key constraint: PK_JKGL_DATA_TJ_ZBU_CKKA (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_DATA_TJ_ZBU_CKKA` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '序号',
  `bgqid` DECIMAL(20,0) COMMENT '报告期ID',
  `ka_dm` VARCHAR(4) COMMENT '口岸代码',
  `ckeusd` DECIMAL(18,2) COMMENT '出口额USD',
  `ckermb` DECIMAL(18,2) COMMENT '出口额',
  `sbdwsl` DECIMAL(38,0) COMMENT '申报单位数量',
  `mgbz` CHAR(1) DEFAULT '0' COMMENT '敏感标志',
  KEY `IDX_JKGL_DATA_TJ_ZBU_CKKA` (`BGQID`, `KA_DM`),
  CONSTRAINT `PK_JKGL_DATA_TJ_ZBU_CKKA` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='报告期指标元统计-出口口岸汇总';

-- Creating table JKGL_DATA_TJ_ZBU_CKSP
-- Original Oracle primary-key constraint: PK_JKGL_DATA_TJ_ZBU_CKSP (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_DATA_TJ_ZBU_CKSP` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '序号',
  `bgqid` DECIMAL(20,0) COMMENT '报告期ID',
  `sp8_dm` VARCHAR(8) COMMENT '商品代码（8位）',
  `cksl` DECIMAL(18,2) COMMENT '出口数量',
  `ckeusd` DECIMAL(18,2) COMMENT '出口额USD',
  `ckermb` DECIMAL(18,2) COMMENT '出口额',
  `mgbz` CHAR(1) DEFAULT '0' COMMENT '敏感标志 1/0',
  `ckdj` DECIMAL(18,2) COMMENT '出口单价',
  `spdl` VARCHAR(2) COMMENT '商品大类 2位',
  `spmc` VARCHAR(80) COMMENT '商品名称',
  `newbz` CHAR(1) DEFAULT '0' COMMENT '新增（跨大类）标志',
  KEY `IDX_JKGL_DATA_TJ_ZBU_CKSP` (`BGQID`, `SP8_DM`),
  CONSTRAINT `PK_JKGL_DATA_TJ_ZBU_CKSP` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='报告期指标元统计-出口商品汇总';

-- Creating table JKGL_DATA_TJ_ZBU_DZGF
-- Original Oracle primary-key constraint: PK_JKGL_DATA_TJ_ZBU_DZGF (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_DATA_TJ_ZBU_DZGF` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '序号',
  `bgqid` DECIMAL(20,0) COMMENT '报告期ID',
  `gfsbh` VARCHAR(20) COMMENT '供货方税号',
  `gfmc` VARCHAR(100) COMMENT '供货方名称',
  `fs` DECIMAL(10,0) COMMENT '发票份数',
  `je` DECIMAL(18,2) COMMENT '发票不含税金额',
  `se` DECIMAL(18,2) COMMENT '发票税额',
  `zyspmc` VARCHAR(200) COMMENT '主要商品名称',
  `zyspje` DECIMAL(18,2) COMMENT '主要商品金额',
  KEY `IDX_JKGL_DATA_TJ_ZBU_DZGF` (`BGQID`, `GFSBH`),
  CONSTRAINT `PK_JKGL_DATA_TJ_ZBU_DZGF` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='报告期指标元统计-底账购方汇总(专票供应链下游)';

-- Creating table JKGL_DATA_TJ_ZBU_DZSPJX
-- Original Oracle primary-key constraint: PK_JKGL_DATA_TJ_ZBU_DZSPJX (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_DATA_TJ_ZBU_DZSPJX` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '序号',
  `bgqid` DECIMAL(20,0) COMMENT '报告期ID',
  `spmc` VARCHAR(200) COMMENT '商品名称（只取排名前20）',
  `spsm` VARCHAR(60) COMMENT '商品税目',
  `je` DECIMAL(18,2) COMMENT '金额',
  `se` DECIMAL(18,2) COMMENT '税额',
  KEY `IDX_JKGL_DATA_TJ_ZBU_DZSPJX` (`BGQID`, `SPMC`),
  CONSTRAINT `PK_JKGL_DATA_TJ_ZBU_DZSPJX` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='报告期指标元统计-底账商品汇总(专票进项货物)';

-- Creating table JKGL_DATA_TJ_ZBU_DZSPXX
-- Original Oracle primary-key constraint: PK_JKGL_DATA_TJ_ZBU_DZSPXX (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_DATA_TJ_ZBU_DZSPXX` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '序号',
  `bgqid` DECIMAL(20,0) COMMENT '报告期ID',
  `spmc` VARCHAR(150) COMMENT '商品名称（只取排名前20）',
  `spsm` VARCHAR(60) COMMENT '商品税目',
  `je` DECIMAL(18,2) COMMENT '金额',
  `se` DECIMAL(18,2) COMMENT '税额',
  KEY `IDX_JKGL_DATA_TJ_ZBU_DZSPXX` (`BGQID`, `SPMC`),
  CONSTRAINT `PK_JKGL_DATA_TJ_ZBU_DZSPXX` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='报告期指标元统计-底账商品汇总(专票销项货物)';

-- Creating table JKGL_DATA_TJ_ZBU_DZXF
-- Original Oracle primary-key constraint: PK_JKGL_DATA_TJ_ZBU_DZXF (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_DATA_TJ_ZBU_DZXF` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '序号',
  `bgqid` DECIMAL(20,0) COMMENT '报告期ID',
  `xfsbh` VARCHAR(20) COMMENT '销货方税号',
  `xfmc` VARCHAR(100) COMMENT '销货方名称',
  `fs` DECIMAL(10,0) COMMENT '发票份数',
  `je` DECIMAL(18,2) COMMENT '发票不含税金额',
  `se` DECIMAL(18,2) COMMENT '发票税额',
  `zyspmc` VARCHAR(200) COMMENT '主要商品名称',
  `zyspje` DECIMAL(18,2) COMMENT '主要商品金额',
  KEY `IDX_JKGL_DATA_TJ_ZBU_DZXF` (`BGQID`, `XFSBH`),
  CONSTRAINT `PK_JKGL_DATA_TJ_ZBU_DZXF` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='报告期指标元统计-底账销方汇总(专票供应链上游)';

-- Creating table JKGL_DATA_TJ_ZBU_KZ
CREATE TABLE `JKGL_DATA_TJ_ZBU_KZ` (
  `bgqid` DECIMAL(20,0) NOT NULL COMMENT '报告期ID',
  `cw_mll` DECIMAL(18,2) COMMENT '财务_毛利率，限值[-900,100] ',
  `cw_hysfl` DECIMAL(18,2) COMMENT '财务_还原税负率，限值[-100,100] ',
  `cw_yylrl` DECIMAL(18,2) COMMENT '财务_营业利润率，限值[-900,100] ',
  `cw_cbfylrl` DECIMAL(18,2) COMMENT '财务_成本费用利润率，限值[-1100,100] ',
  `cw_zzcbcl` DECIMAL(18,2) COMMENT '财务_总资产报酬率，限值[-100,1000] ',
  `cw_jzcsyl` DECIMAL(18,2) COMMENT '财务_净资产收益率，限值[-100,1000] ',
  `cw_yysrtbzzl` DECIMAL(18,2) COMMENT '财务_营业收入同比增长率，限值[-6000,6000] ',
  `cw_jlrtbzzl` DECIMAL(18,2) COMMENT '财务_净利润同比增长率，限值[-6000,6000] ',
  `cw_zzczzl` DECIMAL(18,2) COMMENT '财务_总资产增长率，限值[-100,1000] ',
  `cw_ldbl` DECIMAL(18,2) COMMENT '财务_流动比率，限值[10,1000] ',
  `cw_sdbl` DECIMAL(18,2) COMMENT '财务_速动比率，限值[10,1000] ',
  `cw_zcfzl` DECIMAL(18,2) COMMENT '财务_资产负债率，限值[10,1000] ',
  `cw_chzzl` DECIMAL(18,2) COMMENT '财务_存货周转率，限值[0,360] ',
  `cw_yszkzzl` DECIMAL(18,2) COMMENT '财务_应收账款周转率，限值[0,360] ',
  `ck_ckusd_tb` DECIMAL(18,2) COMMENT '出口_美元出口额_同比，限值[0,6000] ',
  `ts_tmse_tb` DECIMAL(18,2) COMMENT '退税_退免税额_同比，限值[0,6000] ',
  KEY `PK_JKGL_DATA_TJ_ZBU_KZ` (`BGQID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='报告期指标元统计--单项数据扩展';

-- Creating table JKGL_DATA_TJ_ZBU_QYXX
-- Original Oracle primary-key constraint: PK_JKGL_DATA_TJ_ZBU_QYXX (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_DATA_TJ_ZBU_QYXX` (
  `bgqid` DECIMAL(20,0) NOT NULL COMMENT '报告期ID',
  `fr_xm` VARCHAR(150) COMMENT '法人代表姓名',
  `fr_zjhm` VARCHAR(30) COMMENT '法人代表身份证',
  `skr_xm` VARCHAR(150) COMMENT '实际控制人姓名',
  `skr_zjhm` VARCHAR(30) COMMENT '实际控制人身份证',
  `cwr_xm` VARCHAR(150) COMMENT '财务负责人姓名',
  `cwr_zjhm` VARCHAR(30) COMMENT '财务负责人身份证',
  `bsr_xm` VARCHAR(150) COMMENT '办税人姓名',
  `bsr_zjhm` VARCHAR(30) COMMENT '办税人身份证',
  `flglcd` CHAR(1) COMMENT '分类管理等级',
  `jyyfsl` DECIMAL(10,0) COMMENT '经营月数-税务登记至今月数',
  `ckyfsl` DECIMAL(10,0) COMMENT '出口月数-首次出口至今的月数',
  `jycdmj` DECIMAL(10,0) COMMENT '经营（办公）场地面积',
  `zcdz` VARCHAR(300) COMMENT '注册地址',
  `jydz` VARCHAR(300) COMMENT '经营地址',
  CONSTRAINT `PK_JKGL_DATA_TJ_ZBU_QYXX` PRIMARY KEY (`BGQID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='报告期指标元统计-企业基础信息';

-- Creating table JKGL_DATA_TJ_ZBU_TSGH
-- Original Oracle primary-key constraint: PK_JKGL_DATA_TJ_ZBU_TSGH (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_DATA_TJ_ZBU_TSGH` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '序号',
  `bgqid` DECIMAL(20,0) COMMENT '报告期ID',
  `ghfsh` VARCHAR(20) COMMENT '供货企业税号',
  `jhje` DECIMAL(18,2) COMMENT '进货金额',
  `tse` DECIMAL(18,2) COMMENT '退税额',
  `fxqybz` CHAR(1) DEFAULT '0' COMMENT '风险企业标志  0/  1风险企业',
  `fxdqbz` CHAR(1) DEFAULT '0' COMMENT '风险地区标志   0正常  1风险地区',
  `snwbz` CHAR(1) DEFAULT '0' COMMENT '省内外标志    0省内   1 省外 ',
  `fzchbz` CHAR(1) DEFAULT '0' COMMENT '非正常户标志   0正常  1非正常（包括注销等）',
  `newbz` CHAR(1) DEFAULT '0' COMMENT '新增供应商标志',
  KEY `IDX_JKGL_DATA_TJ_ZBU_TSGH` (`BGQID`, `GHFSH`),
  CONSTRAINT `PK_JKGL_DATA_TJ_ZBU_TSGH` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='报告期指标元统计-退税供货汇总';

-- Creating table JKGL_DATA_TJ_ZBU_TSSP
-- Original Oracle primary-key constraint: PK_JKGL_DATA_TJ_ZBU_TSSP (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_DATA_TJ_ZBU_TSSP` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '序号',
  `bgqid` DECIMAL(20,0) COMMENT '报告期ID',
  `sp8_dm` VARCHAR(8) COMMENT '商品代码（8位）',
  `ckeusd` DECIMAL(18,2) COMMENT '出口额USD',
  `ckermb` DECIMAL(18,2) COMMENT '出口额人民币',
  `ckermb_stzc` DECIMAL(18,2) COMMENT '出口额_视同自产',
  `cksl` DECIMAL(18,2) COMMENT '出口数量',
  `ckdj` DECIMAL(18,2) COMMENT '出口单价',
  `sbtmse` DECIMAL(18,2) COMMENT '申报退免税额',
  `jhje` DECIMAL(18,2) COMMENT '进货金额',
  `jhdj` DECIMAL(18,2) COMMENT '进货单价',
  `mgbz` CHAR(1) DEFAULT '0' COMMENT '敏感标志 1/0',
  `sp_dl` VARCHAR(2) COMMENT '商品大类(2位)',
  `mmylr` DECIMAL(18,2) COMMENT '每美元利润',
  KEY `IDX_JKGL_DATA_TJ_ZBU_TSSP` (`BGQID`, `SP8_DM`),
  CONSTRAINT `PK_JKGL_DATA_TJ_ZBU_TSSP` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='报告期指标元统计-退税商品汇总';

-- Creating table JKGL_DATA_ZB_JGB
-- Original Oracle primary-key constraint: PK_JKGL_DATA_ZB_JGB (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_DATA_ZB_JGB` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '纳税人登记序号PK',
  `zb_id` VARCHAR(30) NOT NULL COMMENT '指标标识 PK',
  `zb_val` DECIMAL(18,2) COMMENT '指标计算结果（逻辑型1/0）',
  `yc_result` DECIMAL(38,0) COMMENT '异常判定结果（存在异常规则xh,无异常=0）',
  `badpoint` CHAR(1) COMMENT '坏点标志 Y /N',
  `score` DECIMAL(38,0) NOT NULL COMMENT '健康赋分',
  `params` VARCHAR(4000) COMMENT '计算输入参数（json格式）',
  `js_status` CHAR(1) COMMENT '计算状态（0待计算 1已计算）',
  `ff_status` CHAR(1) COMMENT '赋分状态（0待赋分 1已赋分）',
  `tqbz` VARCHAR(20) COMMENT '提取标志',
  `tqsj` DATETIME COMMENT '提取时间',
  `uptime` DATETIME COMMENT '更新时间',
  `hcjg` CHAR(1) COMMENT '核查（评定）结果： 1 经核实正常（不扣分）   2经核实异常（继续扣分）',
  `hctime` DATETIME COMMENT '核查（评定）时间',
  `hcyj` VARCHAR(4000) COMMENT '核查（评定）情况描述',
  `hcr` VARCHAR(20) COMMENT '核查（评定）人姓名',
  CONSTRAINT `PK_JKGL_DATA_ZB_JGB` PRIMARY KEY (`DJXH`, `ZB_ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='指标数据结果表';

-- Creating table JKGL_DATA_ZB_LSB
-- Original Oracle primary-key constraint: PK_JKGL_DATA_ZB_LSB (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_DATA_ZB_LSB` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '由序列产生的id',
  `djxh` DECIMAL(20,0) COMMENT '纳税人登记序号PK',
  `zb_id` VARCHAR(30) COMMENT '指标标识 PK',
  `zb_val` DECIMAL(18,2) COMMENT '指标计算结果（逻辑型1/0）',
  `yc_result` DECIMAL(38,0) COMMENT '异常判定结果（存在异常规则xh,无异常=0）',
  `badpoint` CHAR(1) COMMENT '坏点标志 Y /N',
  `score` DECIMAL(38,0) NOT NULL COMMENT '健康赋分',
  `params` VARCHAR(4000) COMMENT '计算输入参数（json格式）',
  `js_status` CHAR(1) COMMENT '计算状态（0待计算 1已计算）',
  `ff_status` CHAR(1) COMMENT '赋分状态（0待赋分 1已赋分）',
  `tqbz` VARCHAR(20) COMMENT '提取标志',
  `tqsj` DATETIME COMMENT '提取时间',
  `uptime` DATETIME COMMENT '更新时间',
  CONSTRAINT `PK_JKGL_DATA_ZB_LSB` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='指标数据历史表';

-- Creating table JKGL_DATA_ZB_PS_JGB
-- Original Oracle primary-key constraint: PK_JKGL_DATA_ZB_PS_JGB (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_DATA_ZB_PS_JGB` (
  `zb_id` VARCHAR(30) NOT NULL COMMENT '指标标识 PK',
  `pslx_dm` VARCHAR(20) NOT NULL COMMENT '派生类型代码PK（关联代码表）',
  `ps_code` VARCHAR(30) COMMENT '派生主题代码PK（派生类型下的具体代码）',
  `zb_val` DECIMAL(18,2) COMMENT '指标计算结果（逻辑型1/0）',
  `js_status` CHAR(1) COMMENT '计算状态（0待计算 1已计算）',
  `tqbz` VARCHAR(20) COMMENT '提取标志',
  `tqsj` DATETIME COMMENT '提取时间',
  `uptime` DATETIME COMMENT '更新时间',
  CONSTRAINT `PK_JKGL_DATA_ZB_PS_JGB` PRIMARY KEY (`ZB_ID`, `PSLX_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='指标派生数据结果表';

-- Creating table JKGL_DATA_ZB_PS_LSB
-- Original Oracle primary-key constraint: PK_JKGL_DATA_ZB_PS_LSB (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_DATA_ZB_PS_LSB` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '由序列产生的id',
  `zb_id` VARCHAR(30) COMMENT '指标标识 PK',
  `pslx_dm` VARCHAR(20) COMMENT '派生类型代码PK（关联代码表）',
  `ps_code` VARCHAR(30) COMMENT '派生主题代码PK（派生类型下的具体代码）',
  `zb_val` DECIMAL(18,2) COMMENT '指标计算结果（逻辑型1/0）',
  `js_status` CHAR(1) COMMENT '计算状态（0待计算 1已计算）',
  `tqbz` VARCHAR(20) COMMENT '提取标志',
  `tqsj` DATETIME COMMENT '提取时间',
  `uptime` DATETIME COMMENT '更新时间',
  CONSTRAINT `PK_JKGL_DATA_ZB_PS_LSB` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='指标派生数据历史表';

-- Creating table JKGL_DM_FXCKSP
CREATE TABLE `JKGL_DM_FXCKSP` (
  `dm` VARCHAR(20) NOT NULL,
  `mc` VARCHAR(40),
  PRIMARY KEY (`DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table JKGL_DM_JKM
-- Original Oracle primary-key constraint: PK_JKGL_DM_JKM (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_DM_JKM` (
  `jkm_level` CHAR(1) NOT NULL COMMENT '健康码等级',
  `jkm_mc` VARCHAR(10) COMMENT '健康码名称',
  CONSTRAINT `PK_JKGL_DM_JKM` PRIMARY KEY (`JKM_LEVEL`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='健康码代码表';

-- Creating table JKGL_DM_PSLX
-- Original Oracle primary-key constraint: PK_JKGL_DM_PSLX (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_DM_PSLX` (
  `pslx_dm` VARCHAR(20) NOT NULL COMMENT '派生类型代码（关联代码表）',
  `pslx_mc` VARCHAR(100) COMMENT '派生类型名称',
  `algorithm` VARCHAR(20) COMMENT '算法（平均值，标准值）',
  `note` VARCHAR(200) COMMENT '说明',
  CONSTRAINT `PK_JKGL_DM_PSLX` PRIMARY KEY (`PSLX_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='派生类型代码表';

-- Creating table JKGL_DM_YSLX
-- Original Oracle primary-key constraint: PK_JKGL_DM_YSLX (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_DM_YSLX` (
  `yslx_dm` VARCHAR(20) NOT NULL COMMENT '约束类型代码',
  `yslx_mc` VARCHAR(50) COMMENT '约束类型名称',
  `tablename` VARCHAR(50) COMMENT '关联代码表名',
  `dm_field` VARCHAR(50) COMMENT '代码字段名',
  `mc_field` VARCHAR(50) COMMENT '代码中文名',
  CONSTRAINT `PK_JKGL_DM_YSLX` PRIMARY KEY (`YSLX_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='约束类型代码表';

-- Creating table JKGL_DM_YWFL
-- Original Oracle primary-key constraint: PK_JKGL_DM_YWFL (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_DM_YWFL` (
  `ywfl_dm` VARCHAR(10) NOT NULL,
  `ywfl_mc` VARCHAR(50),
  `ywfl_jc` VARCHAR(50),
  CONSTRAINT `PK_JKGL_DM_YWFL` PRIMARY KEY (`YWFL_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='健康管理-业务分类代码表';

-- Creating table JKGL_FX_GXFA
-- Original Oracle primary-key constraint: JKGL_FX_GXFA (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_FX_GXFA` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '方案主表ID',
  `famc` VARCHAR(80) COMMENT '方案名称',
  `tsjsfs_dm` CHAR(1) COMMENT '退税计算方式 1生产 2外贸',
  `cr_user` VARCHAR(80) COMMENT '创建人名称',
  `cr_user_dm` VARCHAR(20) COMMENT '创建人代码',
  `cr_time` DATETIME COMMENT '创建时间',
  `note` VARCHAR(4000) COMMENT '备注说明',
  `gxlx` CHAR(1) COMMENT '共享类型 0-私有  1-公有',
  `swjg_dm` VARCHAR(11) COMMENT '录入税务机关代码',
  CONSTRAINT `JKGL_FX_GXFA` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='共享方案表';

-- Creating table JKGL_FX_GXFA_GXGX
-- Original Oracle primary-key constraint: JKGL_FX_GXFA_GX_SWJG (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_FX_GXFA_GXGX` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '共享关系表主键',
  `gid` DECIMAL(20,0) NOT NULL COMMENT '方案主表ID',
  `gxfw` VARCHAR(11) COMMENT '共享税务机关范围 例如13301或1330105',
  `dxlx` VARCHAR(10) COMMENT '对象类型  SWJG-税务机关',
  `qybz` CHAR(1) NOT NULL COMMENT '启用标志 Y-启用/N-不启用',
  `cr_user` VARCHAR(80) COMMENT '创建人名称',
  `cr_user_dm` VARCHAR(20) COMMENT '创建人代码',
  `up_user` VARCHAR(80) COMMENT '修改人名称',
  `up_user_dm` VARCHAR(20) COMMENT '修改人代码',
  `cr_time` DATETIME COMMENT '创建时间',
  `up_time` DATETIME COMMENT '修改时间',
  CONSTRAINT `JKGL_FX_GXFA_GX_SWJG` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='共享关系表';

-- Creating table JKGL_FX_GXFA_RULE
-- Original Oracle primary-key constraint: JKGL_FX_GXFA_GXGZ (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_FX_GXFA_RULE` (
  `gid` DECIMAL(20,0) NOT NULL COMMENT '方案主表ID',
  `id` DECIMAL(20,0) NOT NULL COMMENT '共享规则主键ID',
  `rulename` VARCHAR(80) NOT NULL COMMENT '规则名称',
  `expression` VARCHAR(2000) COMMENT '表达式',
  `note` VARCHAR(1000) COMMENT '备注说明',
  `showorder` DECIMAL(38,0) COMMENT '显示顺序',
  `yxbz` CHAR(1) NOT NULL COMMENT '有效标志 Y/N',
  `expression_cname` VARCHAR(2000) COMMENT '中文表达式',
  `fxq_type` CHAR(1) COMMENT '分析期偏移类型，0-月，1-季，2-年',
  `fxq_offset` DECIMAL(2,0) COMMENT '分析期偏移量',
  `fxq_range` DECIMAL(2,0) COMMENT '分析期月跨度',
  CONSTRAINT `JKGL_FX_GXFA_GXGZ` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='共享方案规则集合表';

-- Creating table JKGL_FX_GXFA_YSTJ
-- Original Oracle primary-key constraint: JKGL_FX_GXFA_YSTJ (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_FX_GXFA_YSTJ` (
  `gid` DECIMAL(20,0) NOT NULL COMMENT '方案主表ID',
  `flglcd` VARCHAR(50) COMMENT '分类管理等级',
  `flglcd_str` VARCHAR(50),
  `djzclx` VARCHAR(300) COMMENT '登记类型',
  `djzclx_str` VARCHAR(2000),
  `hy` VARCHAR(1000) COMMENT '行业',
  `hy_str` VARCHAR(2000),
  `nsrzt` VARCHAR(50) COMMENT '纳税人状态',
  `nsrzt_str` VARCHAR(200),
  `ckgm` VARCHAR(50) COMMENT '出口规模',
  `ckgm_str` VARCHAR(200),
  CONSTRAINT `JKGL_FX_GXFA_YSTJ` PRIMARY KEY (`GID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='共享方案约束条件表';

-- Creating table JKGL_FX_YBQYTC_TMP
-- Original Oracle primary-key constraint: PK_JKGL_FX_YBQYTC_TMP (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_FX_YBQYTC_TMP` (
  `zid` DECIMAL(20,0) NOT NULL COMMENT '项目主表ID',
  `xh` DECIMAL(38,0) NOT NULL COMMENT '序号',
  `nsrsbh` VARCHAR(20) COMMENT '纳税人识别号',
  `nsrmc` VARCHAR(100) COMMENT '纳税人名称',
  CONSTRAINT `PK_JKGL_FX_YBQYTC_TMP` PRIMARY KEY (`ZID`, `XH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='三三智检分析模块-样本企业(剔除)临时表';

-- Creating table JKGL_FX_YBQY_TMP
-- Original Oracle primary-key constraint: PK_JKGL_FX_YBQY_TMP (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_FX_YBQY_TMP` (
  `zid` DECIMAL(20,0) NOT NULL COMMENT '项目主表ID',
  `xh` DECIMAL(38,0) NOT NULL COMMENT '序号',
  `nsrsbh` VARCHAR(20) COMMENT '纳税人识别号',
  `nsrmc` VARCHAR(100) COMMENT '纳税人名称',
  CONSTRAINT `PK_JKGL_FX_YBQY_TMP` PRIMARY KEY (`ZID`, `XH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='三三智检分析模块-样本企业临时表';

-- Creating table JKGL_FX_ZHZBSX
-- Original Oracle primary-key constraint: PK_JKGL_FX_ZHZBSX (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_FX_ZHZBSX` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '项目主表ID',
  `xmmc` VARCHAR(80) COMMENT '项目名称',
  `tsjsfs_dm` CHAR(1) COMMENT '退税计算方式 1生产 2外贸',
  `note` VARCHAR(200) COMMENT '备注说明',
  `status` CHAR(1) COMMENT '项目状态  0项目新建  1初始化完成  2筛选中  3筛选结束',
  `cr_user` VARCHAR(80) COMMENT '创建人名称',
  `cr_time` DATETIME COMMENT '创建时间',
  `swjg_dm` VARCHAR(11) COMMENT '录入税务机关代码',
  `up_time` DATETIME COMMENT '修改时间',
  `cr_user_dm` VARCHAR(20) COMMENT '创建人代码',
  CONSTRAINT `PK_JKGL_FX_ZHZBSX` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='综合指标筛选项目主表';

-- Creating table JKGL_FX_ZHZBSX_MBQY
-- Original Oracle primary-key constraint: PK_JKGL_FX_ZHZBSX_MBQY (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_FX_ZHZBSX_MBQY` (
  `zid` DECIMAL(20,0) NOT NULL COMMENT '项目主表ID',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '企业登记序号  关联glxt_bb_shxt_djxx的djxh_js字段',
  CONSTRAINT `PK_JKGL_FX_ZHZBSX_MBQY` PRIMARY KEY (`ZID`, `DJXH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='综合指标筛选子表-目标企业';

-- Creating table JKGL_FX_ZHZBSX_PC
-- Original Oracle primary-key constraint: PK_JKGL_FX_ZHZBSX_PC (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_FX_ZHZBSX_PC` (
  `uuid` VARCHAR(40) NOT NULL COMMENT '主键',
  `zid` DECIMAL(20,0) NOT NULL COMMENT '项目主表ID',
  `pc` DECIMAL(38,0) NOT NULL COMMENT '筛选批次',
  `ztbz` CHAR(1) NOT NULL COMMENT '执行状态   0创建  1筛选中  2筛选结束 9异常中断',
  `start_time` DATETIME COMMENT '开始时间',
  `end_time` DATETIME COMMENT '结束时间',
  `rely_pc` DECIMAL(38,0) COMMENT '依赖批次  >0表示以依赖批次的结果为初始目标企业',
  `msg` VARCHAR(4000) COMMENT '执行过程输出的消息',
  `ssq` DATETIME NOT NULL COMMENT '所属期',
  KEY `IDX_JKGL_FX_ZHZBSX_PC` (`ZID`, `PC`),
  CONSTRAINT `PK_JKGL_FX_ZHZBSX_PC` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='综合指标筛选子表—批次（执行版本）';

-- Creating table JKGL_FX_ZHZBSX_PC_JGQY
CREATE TABLE `JKGL_FX_ZHZBSX_PC_JGQY` (
  `pc_uuid` VARCHAR(40) NOT NULL COMMENT '关联到批次的UUID',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '企业登记序号',
  `rule_id` DECIMAL(20,0) COMMENT '规则表的ID'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='综合指标筛选子表—批次的结果企业';

-- Creating table JKGL_FX_ZHZBSX_PC_RULE
-- Original Oracle primary-key constraint: PK_JKGL_FX_ZHZBSX_PC_RULE (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_FX_ZHZBSX_PC_RULE` (
  `pc_uuid` VARCHAR(40) NOT NULL COMMENT '关联到批次的UUID',
  `rule_id` DECIMAL(20,0) NOT NULL COMMENT '规则表的ID',
  `zid` DECIMAL(20,0) NOT NULL COMMENT '项目主表ID（冗余，便于清理）',
  `expression` VARCHAR(2000) COMMENT '表达式（从规则表复制过来）',
  `expression_cname` VARCHAR(2000) COMMENT '中文表达式',
  `task_flag` CHAR(1) DEFAULT '0' COMMENT '规则解析状态  0-未完成 1-提取中 2-执行完成  9-出错',
  `tqbz` VARCHAR(64) COMMENT '任务提取标志',
  `tqsj` DATETIME COMMENT '提取时间',
  `tqcs` DECIMAL(20,0) DEFAULT 0 COMMENT '提取次数',
  `crtime` DATETIME COMMENT '创建时间',
  `task_info` VARCHAR(2000) COMMENT '任务信息',
  `fxq_q` DATETIME COMMENT '分析期起',
  `fxq_z` DATETIME COMMENT '分析期止',
  `status` VARCHAR(100) COMMENT '执行状态',
  CONSTRAINT `PK_JKGL_FX_ZHZBSX_PC_RULE` PRIMARY KEY (`PC_UUID`, `RULE_ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='综合指标筛选子表—批次的使用规则';

-- Creating table JKGL_FX_ZHZBSX_RULE
-- Original Oracle primary-key constraint: PK_JKGL_FX_ZHZBSX_RULE (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_FX_ZHZBSX_RULE` (
  `id` DECIMAL(20,0) NOT NULL COMMENT 'ID主键',
  `zid` DECIMAL(20,0) NOT NULL COMMENT '项目主表ID',
  `rulename` VARCHAR(80) NOT NULL COMMENT '规则名称',
  `expression` VARCHAR(2000) COMMENT '表达式',
  `note` VARCHAR(1000) COMMENT '备注说明',
  `showorder` DECIMAL(38,0) COMMENT '显示顺序',
  `yxbz` CHAR(1) NOT NULL COMMENT '有效标志 Y/N',
  `cr_time` DATETIME COMMENT '创建时间',
  `up_time` DATETIME COMMENT '修改时间',
  `expression_cname` VARCHAR(2000) COMMENT '中文表达式',
  `fxq_type` CHAR(1) COMMENT '分析期偏移类型，0-月，1-季，2-年',
  `fxq_offset` DECIMAL(2,0) COMMENT '分析期偏移量',
  `fxq_range` DECIMAL(2,0) COMMENT '分析期月跨度',
  KEY `IDX_JKGL_FX_ZHZBSX_RULE` (`ZID`),
  CONSTRAINT `PK_JKGL_FX_ZHZBSX_RULE` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='综合指标筛选子表-规则集合';

-- Creating table JKGL_FX_ZHZBSX_YSTJ
-- Original Oracle primary-key constraint: PK_JKGL_FX_ZHZBSX_YSTJ (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_FX_ZHZBSX_YSTJ` (
  `zid` DECIMAL(20,0) NOT NULL COMMENT '项目主表ID',
  `swjg` VARCHAR(200) COMMENT '税务机关约束，以逗号分割， 参见代码表JKGL_DM_YSLX',
  `swjg_str` VARCHAR(1000) COMMENT '约束中文内容，以逗号分割',
  `flglcd` VARCHAR(50) COMMENT '分类管理等级',
  `flglcd_str` VARCHAR(50),
  `djzclx` VARCHAR(300) COMMENT '登记类型',
  `djzclx_str` VARCHAR(2000),
  `hy` VARCHAR(1000) COMMENT '行业',
  `hy_str` VARCHAR(2000),
  `nsrzt` VARCHAR(50) COMMENT '纳税人状态',
  `nsrzt_str` VARCHAR(200),
  `ckgm` VARCHAR(50) COMMENT '出口规模',
  `ckgm_str` VARCHAR(200),
  CONSTRAINT `PK_JKGL_FX_ZHZBSX_YSTJ` PRIMARY KEY (`ZID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='综合指标筛选项目子表—（目标企业）约束条件';

-- Creating table JKGL_GY_FXDQ_SWJG
-- Original Oracle primary-key constraint: PK_JKGL_GY_FXDQ_SWJG (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_GY_FXDQ_SWJG` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '序号（主键）',
  `swjg_dm` VARCHAR(11) COMMENT '录入税务机关代码',
  `swjg_syfw` VARCHAR(11) COMMENT '适用税务机关范围 例如13301或1330105',
  `xzqh_dm` VARCHAR(6) COMMENT '行政区划代码',
  `xzqh_mc` VARCHAR(80) COMMENT '行政区划名称',
  `yxq_q` DATETIME COMMENT '有效期起，可空',
  `yxq_z` DATETIME COMMENT '有效期止，可空',
  `fxms` VARCHAR(500) COMMENT '风险描述',
  `qybz` CHAR(1) COMMENT '启用标志(Y/N)',
  `cr_czrymc` VARCHAR(30) COMMENT '录入人姓名',
  `cr_time` DATETIME COMMENT '录入时间',
  `up_czrymc` VARCHAR(30) COMMENT '修改人姓名',
  `up_time` DATETIME COMMENT '修改时间',
  KEY `IDX_JKGL_GY_FXDQ_SWJG` (`SWJG_DM`, `XZQH_DM`),
  KEY `IDX_JKGL_GY_FXDQ_SWJG2` (`XZQH_DM`, `SWJG_SYFW`),
  CONSTRAINT `PK_JKGL_GY_FXDQ_SWJG` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='税务机关风险地区自定义表';

-- Creating table JKGL_GY_FXQY_SWJG
-- Original Oracle primary-key constraint: PK_JKGL_GY_FXQY_SWJG (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_GY_FXQY_SWJG` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '序号（主键）',
  `swjg_dm` VARCHAR(11) COMMENT '录入税务机关代码',
  `swjg_syfw` VARCHAR(11) COMMENT '适用税务机关范围 例如13301或1330105',
  `qysbh` VARCHAR(20) COMMENT '企业税号',
  `qymc` VARCHAR(80) COMMENT '企业名称',
  `yxq_q` DATETIME COMMENT '有效期起，可空',
  `yxq_z` DATETIME COMMENT '有效期止，可空',
  `fxms` VARCHAR(500) COMMENT '风险描述',
  `qybz` CHAR(1) COMMENT '启用标志(Y/N)',
  `cr_czrymc` VARCHAR(30) COMMENT '录入人姓名',
  `cr_time` DATETIME COMMENT '录入时间',
  `up_czrymc` VARCHAR(30) COMMENT '修改人姓名',
  `up_time` DATETIME COMMENT '修改时间',
  KEY `IDX_JKGL_GY_FXQY_SWJG` (`SWJG_DM`, `QYSBH`),
  KEY `IDX_JKGL_GY_FXQY_SWJG2` (`QYSBH`, `SWJG_SYFW`),
  CONSTRAINT `PK_JKGL_GY_FXQY_SWJG` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='税务机关风险企业自定义表';

-- Creating table JKGL_GY_FXSM_HGCK
-- Original Oracle primary-key constraint: PK_JKGL_GY_FXSM_HGCK (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_GY_FXSM_HGCK` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `ckbgdh` VARCHAR(21) NOT NULL COMMENT '出口报关单号',
  `smrq` DATETIME COMMENT '扫描日期',
  `fxgz` VARCHAR(200) COMMENT '（命中）风险规则',
  `tgbz` CHAR(1) COMMENT '挑过标志  1已挑过',
  CONSTRAINT `PK_JKGL_GY_FXSM_HGCK` PRIMARY KEY (`DJXH`, `CKBGDH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='公用-风险扫描-海关出口信息';

-- Creating table JKGL_GY_FXSM_TSSBGH
-- Original Oracle primary-key constraint: PK_JKGL_GY_FXSM_TSSBGH (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_GY_FXSM_TSSBGH` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `uuid` VARCHAR(32) NOT NULL,
  `smrq` DATETIME COMMENT '扫描日期',
  `fxgz` VARCHAR(200) COMMENT '（命中）风险规则',
  `tgbz` CHAR(1) COMMENT '挑过标志  1已挑过',
  CONSTRAINT `PK_JKGL_GY_FXSM_TSSBGH` PRIMARY KEY (`UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='公用-风险扫描-退税申报供货';

-- Creating table JKGL_GY_GHQYXX
-- Original Oracle primary-key constraint: PK_PK_JKGL_GY_GHQYXX (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_GY_GHQYXX` (
  `qysbh` VARCHAR(20) NOT NULL COMMENT '企业税号',
  `qymc` VARCHAR(80) COMMENT '企业名称',
  `swjg_dm` VARCHAR(11) COMMENT '税务机关代码',
  `xzqh_dm` VARCHAR(6) COMMENT '行政区划代码',
  `nsrzt_dm` VARCHAR(2) COMMENT '纳税人状态代码 03正常 ',
  `is_gjs` CHAR(1) COMMENT '是否涉及贵金属销售Y/N',
  `cr_time` DATETIME COMMENT '录入时间',
  `up_time` DATETIME COMMENT '修改时间',
  `swdjrq` DATETIME COMMENT '税务登记日期',
  `bz_lxkp` CHAR(1) COMMENT '预留给分析用，连续开票金额预警标志',
  `zzkprq` DATETIME COMMENT '最早开票日期',
  `bz_yd` CHAR(1) COMMENT '异地标志,N 省内 ， Y 省外',
  CONSTRAINT `PK_PK_JKGL_GY_GHQYXX` PRIMARY KEY (`QYSBH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='供货企业信息表（全省公用）';

-- Creating table JKGL_GY_MGSP_SWJG
-- Original Oracle primary-key constraint: PK_JKGL_GY_MGSP_SWJG (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_GY_MGSP_SWJG` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '序号（主键）',
  `swjg_dm` VARCHAR(11) COMMENT '录入税务机关代码',
  `swjg_syfw` VARCHAR(11) COMMENT '适用税务机关范围 例如13301或1330105',
  `mgsp_dm` VARCHAR(8) COMMENT '敏感商品代码，4-8位代码',
  `mgsp_mc` VARCHAR(200) COMMENT '敏感商品名称',
  `yxq_q` DATETIME COMMENT '有效期起，可空',
  `yxq_z` DATETIME COMMENT '有效期止，可空',
  `fxms` VARCHAR(500) COMMENT '风险描述',
  `qybz` CHAR(1) COMMENT '启用标志(Y/N)',
  `cr_czrymc` VARCHAR(30) COMMENT '录入人姓名',
  `cr_time` DATETIME COMMENT '录入时间',
  `up_czrymc` VARCHAR(30) COMMENT '修改人姓名',
  `up_time` DATETIME COMMENT '修改时间',
  KEY `IDX_JKGL_GY_MGSP_SWJG` (`SWJG_DM`, `MGSP_DM`),
  KEY `IDX_JKGL_GY_MGSP_SWJG2` (`MGSP_DM`, `SWJG_SYFW`),
  CONSTRAINT `PK_JKGL_GY_MGSP_SWJG` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='税务机关敏感商品自定义表';

-- Creating table JKGL_JKM_RGPD_LSB
-- Original Oracle primary-key constraint: JKGL_JKM_RGPD_LSB (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_JKM_RGPD_LSB` (
  `pd_uuid` VARCHAR(40) NOT NULL COMMENT '评定UUID',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `qdsj` DATETIME NOT NULL COMMENT '评定启动时间',
  `jkm_y` CHAR(1) NOT NULL COMMENT '原健康码',
  `jkm_n` CHAR(1) COMMENT '新健康码',
  `yxq` DATETIME COMMENT '评定有效期，为空表示长期有效',
  `pdzt` CHAR(1) NOT NULL COMMENT '评定状态：0待评定、1重新评定（退回）、2待复核、9评定完成',
  `pdjg` CHAR(1) COMMENT '评定结果：1-同意、2-拒绝',
  `pdr_dm` VARCHAR(20) COMMENT '评定人代码',
  `pdr_mc` VARCHAR(30) COMMENT '评定人姓名',
  `pdsj` DATETIME COMMENT '评定时间',
  `pdyj` VARCHAR(1000) COMMENT '评定意见',
  `fhr_dm` VARCHAR(20) COMMENT '复核人代码',
  `fhr_mc` VARCHAR(30) COMMENT '复核人姓名',
  `fhsj` DATETIME COMMENT '复核时间',
  `fhyj` VARCHAR(100) COMMENT '复核意见',
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '出口企业所属税务机关代码',
  `fqlx` CHAR(1) NOT NULL COMMENT '发起类型：1-税务评定、2-企业申述',
  `ssyy` VARCHAR(1000) COMMENT '申述原因',
  `ssbs` VARCHAR(40) COMMENT '申述标识',
  `sjtbbz` CHAR(1) COMMENT '数据同步标志',
  CONSTRAINT `JKGL_JKM_RGPD_LSB` PRIMARY KEY (`PD_UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='健康管理_健康码_人工评定_历史表';

-- Creating table JKGL_JKM_RGPD_SP
-- Original Oracle primary-key constraint: JKGL_JKM_RGPD_SP (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_JKM_RGPD_SP` (
  `pd_uuid` VARCHAR(40) NOT NULL COMMENT '评定UUID',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `qdsj` DATETIME NOT NULL COMMENT '评定启动时间',
  `jkm_y` CHAR(1) NOT NULL COMMENT '原健康码',
  `jkm_n` CHAR(1) COMMENT '新健康码',
  `yxq` DATETIME COMMENT '评定有效期，为空表示长期有效',
  `pdzt` CHAR(1) NOT NULL COMMENT '评定状态：0待评定、1重新评定（退回）、2待复核、9评定完成',
  `pdjg` CHAR(1) COMMENT '评定结果：1-同意、2-拒绝',
  `pdr_dm` VARCHAR(20) COMMENT '评定人代码',
  `pdr_mc` VARCHAR(30) COMMENT '评定人姓名',
  `pdsj` DATETIME COMMENT '评定时间',
  `pdyj` VARCHAR(1000) COMMENT '评定意见',
  `fhr_dm` VARCHAR(20) COMMENT '复核人代码',
  `fhr_mc` VARCHAR(30) COMMENT '复核人姓名',
  `fhsj` DATETIME COMMENT '复核时间',
  `fhyj` VARCHAR(100) COMMENT '复核意见',
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '出口企业所属税务机关代码',
  `fqlx` CHAR(1) NOT NULL COMMENT '发起类型：1-税务评定、2-企业申述',
  `ssyy` VARCHAR(1000) COMMENT '申述原因',
  `ssbs` VARCHAR(40) COMMENT '申述标识',
  `sjtbbz` CHAR(1) COMMENT '数据同步标志',
  CONSTRAINT `JKGL_JKM_RGPD_SP` PRIMARY KEY (`PD_UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='健康管理_健康码_人工评定_审批表';

-- Creating table JKGL_LOG_DEALDATA
CREATE TABLE `JKGL_LOG_DEALDATA` (
  `czsj` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `czjl` VARCHAR(300),
  `sbyy` VARCHAR(2000)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table JKGL_PZ_DS
-- Original Oracle primary-key constraint: PK_JKGL_PZ_DS (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_PZ_DS` (
  `ds_id` VARCHAR(30) NOT NULL COMMENT '数据源标识 ',
  `ds_name` VARCHAR(30) COMMENT '数据源名称 ',
  `ds_type` VARCHAR(20) COMMENT '数据源类型 oracle/mysql',
  `yxbz` CHAR(1) COMMENT '有效标志 Y/N',
  `showorder` DECIMAL(38,0) COMMENT '显示顺序',
  CONSTRAINT `PK_JKGL_PZ_DS` PRIMARY KEY (`DS_ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='健康管理-配置-数据源';

-- Creating table JKGL_PZ_JKM
-- Original Oracle primary-key constraint: PK_JKGL_PZ_JKM (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_PZ_JKM` (
  `ywfl_dm` CHAR(2) NOT NULL COMMENT '业务分类代码（PK）',
  `ywfl_mc` VARCHAR(20) COMMENT '业务分类名称',
  `zb_total` DECIMAL(38,0) COMMENT '指标总分',
  `jkm_total` DECIMAL(38,0) COMMENT '健康码（折算）总分',
  `line_red` DECIMAL(38,0) COMMENT '红线分数',
  `line_yellow` DECIMAL(38,0) COMMENT '黄线分数',
  `ywfl_jc` VARCHAR(20) COMMENT '业务分类简称',
  `tsjsfs` CHAR(1) NOT NULL COMMENT '退税计算方式 1-生产，2-外贸',
  CONSTRAINT `PK_JKGL_PZ_JKM` PRIMARY KEY (`YWFL_DM`, `TSJSFS`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='健康码(分数线)配置';

-- Creating table JKGL_PZ_JKM_SWJG
CREATE TABLE `JKGL_PZ_JKM_SWJG` (
  `swjg_dm` VARCHAR(11) NOT NULL,
  `ywfl_dm` CHAR(2) NOT NULL,
  `tsjsfs` CHAR(1) NOT NULL,
  `jkm_total` DECIMAL(38,0),
  `line_red` DECIMAL(38,0),
  `line_yellow` DECIMAL(38,0),
  PRIMARY KEY (`SWJG_DM`, `YWFL_DM`, `TSJSFS`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table JKGL_PZ_METADATA
-- Original Oracle primary-key constraint: PK_JKGL_PZ_METADATA (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_PZ_METADATA` (
  `ds_id` VARCHAR(30) NOT NULL COMMENT '数据源标识 引用数据表配置',
  `tablename` VARCHAR(40) NOT NULL COMMENT '数据表 引用数据表配置',
  `fieldname` VARCHAR(30) NOT NULL COMMENT '字段名 ',
  `fieldcname` VARCHAR(50) COMMENT '数据项名称 ',
  `datatype` CHAR(1) COMMENT '数据类型 1字符型/2数值型/3日期型/4逻辑型',
  `showformat` CHAR(1) COMMENT '显示格式 0默认/1金额/2整数/3百分比',
  `showlength` DECIMAL(38,0) COMMENT '显示长度 1~100',
  `codetable` VARCHAR(40) COMMENT '关联代码表 ',
  `codefield` VARCHAR(30) COMMENT '关联代码字段 ',
  `defval` VARCHAR(50) COMMENT '缺省值 ',
  `yxbz` CHAR(1) COMMENT '有效标志 Y/N',
  `showorder` DECIMAL(38,0) COMMENT '显示顺序',
  `md_id` VARCHAR(30) COMMENT '元数据标识',
  `ywms` VARCHAR(100) COMMENT '业务描述',
  UNIQUE KEY `IDX_JKGL_PZ_METADATA` (`MD_ID`),
  CONSTRAINT `PK_JKGL_PZ_METADATA` PRIMARY KEY (`DS_ID`, `TABLENAME`, `FIELDNAME`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='健康管理-配置-数据项（元数据）';

-- Creating table JKGL_PZ_QUERY_DF
-- Original Oracle primary-key constraint: PK_JKGL_PZ_QUERY_DF (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_PZ_QUERY_DF` (
  `dts_id` VARCHAR(20) NOT NULL COMMENT '查询源标识 ',
  `df_id` VARCHAR(30) NOT NULL COMMENT '数据项标识 ',
  `df_name` VARCHAR(50) NOT NULL COMMENT '数据项名称 ',
  `fieldname` VARCHAR(30) NOT NULL COMMENT '物理字段名 ',
  `datatype` CHAR(1) NOT NULL COMMENT '数据类型 1字符2数值3日期',
  `showformat` VARCHAR(20) COMMENT '显示格式 页面格式',
  `showlength` DECIMAL(10,0) COMMENT '显示宽度 页面表格',
  `showorder` DECIMAL(10,0) COMMENT '显示顺序 在选项中的排序，非实际输出顺序',
  `yxbz` CHAR(1) NOT NULL COMMENT '有效标志 Y有效N注销',
  `allow_order` CHAR(1) NOT NULL COMMENT '排序标志 1支持排序',
  `allow_sum` CHAR(1) NOT NULL COMMENT '合计标志 1支持汇总',
  `is_cond` CHAR(1) NOT NULL COMMENT '条件标志 1用于条件',
  `is_output` CHAR(1) NOT NULL COMMENT '输出标志 1可输出',
  `dm_table` VARCHAR(30) COMMENT '关联代码表 ',
  `dm_field` VARCHAR(30) COMMENT '代码字段 ',
  `dm_name` VARCHAR(30) COMMENT '内容字段 ',
  `dm_show` CHAR(1) COMMENT '代码显示 1代码2名称3代码+名称',
  `align` CHAR(1) COMMENT '排列：1-居左，2-居右，3-居中',
  CONSTRAINT `PK_JKGL_PZ_QUERY_DF` PRIMARY KEY (`DF_ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='通用查询数据项配置';

-- Creating table JKGL_PZ_QUERY_DTS
-- Original Oracle primary-key constraint: PK_JKGL_PZ_QUERY_DTS (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_PZ_QUERY_DTS` (
  `dts_id` VARCHAR(20) NOT NULL COMMENT '查询源标识',
  `dts_name` VARCHAR(50) NOT NULL COMMENT '查询源名称',
  `dsn` VARCHAR(30) NOT NULL COMMENT '物理DSN',
  `db_user` VARCHAR(30) NOT NULL COMMENT 'ORACLE用户名',
  `tablename` VARCHAR(30) NOT NULL COMMENT '物理表名，支持视图',
  `yxbz` CHAR(1) NOT NULL COMMENT '有效标志 Y-有效/N-注销',
  `showorder` DECIMAL(10,0) COMMENT '显示顺序',
  `xztj` VARCHAR(200) COMMENT '限制条件（隐含条件）',
  CONSTRAINT `PK_JKGL_PZ_QUERY_DTS` PRIMARY KEY (`DTS_ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='通用查询数据源配置';

-- Creating table JKGL_PZ_TABLE
-- Original Oracle primary-key constraint: PK_JKGL_PZ_TABLE (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_PZ_TABLE` (
  `ds_id` VARCHAR(30) NOT NULL COMMENT '数据源标识 引用数据源配置',
  `tablename` VARCHAR(40) NOT NULL COMMENT '数据表标识 ',
  `ds_schema` VARCHAR(30) COMMENT '数据源用户(空表示数据源登录用户）',
  `tablecname` VARCHAR(50) COMMENT '数据表中文名 ',
  `is_dict` CHAR(1) COMMENT '是否为代码表 Y/N',
  `yxbz` CHAR(1) COMMENT '有效标志 Y/N',
  `showorder` DECIMAL(38,0) COMMENT '显示顺序',
  `xztj` VARCHAR(200) COMMENT '限制条件',
  CONSTRAINT `PK_JKGL_PZ_TABLE` PRIMARY KEY (`DS_ID`, `TABLENAME`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='健康管理-配置-数据表';

-- Creating table JKGL_PZ_ZB
-- Original Oracle primary-key constraint: PK_JKGL_PZ_ZB (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_PZ_ZB` (
  `zb_id` VARCHAR(30) NOT NULL COMMENT '指标标识 ',
  `zb_cname` VARCHAR(80) COMMENT '指标名称 ',
  `zb_sname` VARCHAR(50) COMMENT '指标简称 ',
  `zb_type` VARCHAR(20) COMMENT '指标模式,表示指标结果值的生成方法，派生型是根据其他指标叠加时期范围或群体范围得到的关联指标 公式型/SQL型/派生型',
  `ywfl_dm` VARCHAR(20) COMMENT '业务分类，关联 JKGL_DM_YWFL',
  `datatype` CHAR(1) COMMENT '数据类型,针对指标结果值 数值型',
  `showformat` CHAR(1) COMMENT '显示格式 默认/百分比/金额/整数',
  `apply_hy` VARCHAR(200) COMMENT '适用行业（可多选） 关联行业代码表',
  `apply_qy` VARCHAR(20) COMMENT '适用企业类型 空=全部/1生产/2外贸',
  `zb_fomula` VARCHAR(4000) COMMENT '指标公式。利用数据项、指标元、指标、指标参数、维度的计算公式伪代码 ',
  `refresh_cycle` VARCHAR(10) COMMENT '刷新周期 日/周/月/季/半年/年',
  `ywms` VARCHAR(4000) COMMENT '业务描述 ',
  `bbh` VARCHAR(10) COMMENT '版本号 ',
  `js_yxj` DECIMAL(38,0) COMMENT '计算优先级（小值优先）',
  `yxbz` CHAR(1) COMMENT '有效标志 Y /N',
  `rs_type` VARCHAR(20) COMMENT '指标结果类型',
  CONSTRAINT `PK_JKGL_PZ_ZB` PRIMARY KEY (`ZB_ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='健康管理-配置-指标';

-- Creating table JKGL_PZ_ZBU
-- Original Oracle primary-key constraint: PK_JKGL_PZ_ZBU (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_PZ_ZBU` (
  `zbu_id` VARCHAR(30) NOT NULL COMMENT '指标元标识 ',
  `zbu_cname` VARCHAR(80) COMMENT '指标元全称 ',
  `zbu_sname` VARCHAR(50) COMMENT '指标元简称 ',
  `ywfl_dm` VARCHAR(20) COMMENT '业务分类代码  关联 JKGL_DM_YWFL',
  `datatype` CHAR(1) COMMENT '数据类型  1字符型/2数值型/3日期型/4逻辑型',
  `showformat` CHAR(1) COMMENT '显示格式  0默认/1金额/2整数/3百分比',
  `ywms` VARCHAR(4000) COMMENT '业务描述 ',
  `ds_id` VARCHAR(30) COMMENT '关联的数据源 ',
  `tablename` VARCHAR(40) COMMENT '关联的数据表 ',
  `fieldname` VARCHAR(30) COMMENT '关联的数据项 ',
  `xztj` VARCHAR(4000) COMMENT '限制条件，用SQL伪代码表述查询条件 ',
  `bbh` VARCHAR(10) COMMENT '版本号 ',
  `yxbz` CHAR(1) COMMENT '有效标志 Y/N',
  `refresh_cycle` VARCHAR(10) COMMENT '刷新周期 日/周/月/季/半年/年',
  `psbz` CHAR(1) COMMENT '派生标志  0单项指标元   1派生指标元（如：全省平均）',
  `showorder` DECIMAL(38,0) COMMENT '显示顺序',
  `rs_type` VARCHAR(10) COMMENT '结果类型（用中文描述）',
  CONSTRAINT `PK_JKGL_PZ_ZBU` PRIMARY KEY (`ZBU_ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='健康管理-配置-指标元';

-- Creating table JKGL_PZ_ZBU_TEMP
-- Original Oracle primary-key constraint: PK_JKGL_PZ_ZBU_TEMP (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_PZ_ZBU_TEMP` (
  `zbu_id` VARCHAR(30) NOT NULL,
  `zbu_cname` VARCHAR(80),
  `zbu_sname` VARCHAR(50),
  `ywfl_dm` VARCHAR(20),
  `datatype` CHAR(1),
  `showformat` CHAR(1),
  `ywms` VARCHAR(4000),
  `ds_id` VARCHAR(30),
  `tablename` VARCHAR(40),
  `fieldname` VARCHAR(30),
  `xztj` VARCHAR(4000),
  `bbh` VARCHAR(10),
  `yxbz` CHAR(1),
  `refresh_cycle` VARCHAR(10),
  `psbz` CHAR(1),
  `showorder` DECIMAL(38,0),
  `rs_type` VARCHAR(10),
  CONSTRAINT `PK_JKGL_PZ_ZBU_TEMP` PRIMARY KEY (`ZBU_ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='健康管理-配置-指标元';

-- Creating table JKGL_PZ_ZB_CS
-- Original Oracle primary-key constraint: PK_JKGL_PZ_ZB_CS (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_PZ_ZB_CS` (
  `csbm` VARCHAR(50) NOT NULL COMMENT '参数编码（PK）',
  `csmc` VARCHAR(100) COMMENT '参数名称',
  `zb_id` VARCHAR(30) COMMENT '指标标识 ',
  `datatype` CHAR(1) COMMENT '数据类型 1字符型/2数值型/3日期型/4逻辑型',
  `val_def` VARCHAR(100) COMMENT '全省默认值',
  `note` VARCHAR(200) COMMENT '说明',
  `yxbz` CHAR(1) COMMENT '有效标志',
  `cstype` VARCHAR(10) COMMENT '参数类型：数量、数值、金额、美元、百分比',
  CONSTRAINT `PK_JKGL_PZ_ZB_CS` PRIMARY KEY (`CSBM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='指标参数配置';

-- Creating table JKGL_PZ_ZB_CS_SWJG
-- Original Oracle primary-key constraint: PK_JKGL_PZ_ZB_CS_SWJG (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_PZ_ZB_CS_SWJG` (
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `csbm` VARCHAR(50) NOT NULL COMMENT '参数编码（PK）',
  `val_def` VARCHAR(100) COMMENT '参数值',
  `yxbz` CHAR(1) COMMENT '有效标志Y/N',
  CONSTRAINT `PK_JKGL_PZ_ZB_CS_SWJG` PRIMARY KEY (`SWJG_DM`, `CSBM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='指标参数税务机关自定义';

-- Creating table JKGL_PZ_ZB_PS
-- Original Oracle primary-key constraint: PK_JKGL_PZ_ZB_PS (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_PZ_ZB_PS` (
  `zb_id` VARCHAR(30) NOT NULL COMMENT '指标标识 （PK）',
  `xh` DECIMAL(38,0) NOT NULL COMMENT '派生序号（PK）',
  `pslx_dm` VARCHAR(20) COMMENT '派生类型代码（关联代码表）',
  CONSTRAINT `PK_JKGL_PZ_ZB_PS` PRIMARY KEY (`ZB_ID`, `XH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='指标派生';

-- Creating table JKGL_PZ_ZB_YCFF
-- Original Oracle primary-key constraint: PK_JKGL_PZ_ZB_YCFF (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_PZ_ZB_YCFF` (
  `zb_id` VARCHAR(30) NOT NULL COMMENT '指标标识 （PK）',
  `xh` DECIMAL(38,0) NOT NULL COMMENT '异常判定序号（PK）>=1',
  `ycpdtj` VARCHAR(4000) COMMENT '异常判定条件（伪代码表示）',
  `lwgz` VARCHAR(4000) COMMENT '例外规则（伪代码表示）',
  `badpoint` CHAR(1) COMMENT '坏点标志Y/N',
  `score` DECIMAL(38,0) COMMENT '健康码赋分',
  `note` VARCHAR(500) COMMENT '异常描述',
  `yxbz` CHAR(1),
  CONSTRAINT `PK_JKGL_PZ_ZB_YCFF` PRIMARY KEY (`ZB_ID`, `XH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='指标异常规则及赋分配置';

-- Creating table JKGL_PZ_ZB_YCFF_SWJG
-- Original Oracle primary-key constraint: PK_JKGL_PZ_ZB_YCFF_SWJG (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_PZ_ZB_YCFF_SWJG` (
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `zb_id` VARCHAR(30) NOT NULL COMMENT '指标标识 （PK）',
  `xh` DECIMAL(38,0) NOT NULL COMMENT '异常判定序号（PK）>=1',
  `score` DECIMAL(38,0) NOT NULL COMMENT '健康码赋分',
  `yxbz` CHAR(1) COMMENT '有效标志Y/N',
  CONSTRAINT `PK_JKGL_PZ_ZB_YCFF_SWJG` PRIMARY KEY (`SWJG_DM`, `ZB_ID`, `XH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='指标异常规则赋分税务机关自定义';

-- Creating table JKGL_QSPJ_CKSP
-- Original Oracle primary-key constraint: PK_JKGL_QSPJ_CKSP (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_QSPJ_CKSP` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '序号',
  `bgqid` DECIMAL(20,0) COMMENT '报告期ID 关联主表PK_JKGL_DATA_BGQ',
  `sp8_dm` VARCHAR(8) COMMENT '商品代码（8）',
  `ckeusd` DECIMAL(18,2) COMMENT '出口额USD',
  `ckermb` DECIMAL(18,2) COMMENT '出口额RMB',
  `cksl` DECIMAL(18,2) COMMENT '出口数量',
  `ckdj` DECIMAL(18,2) COMMENT '出口单价',
  `qyhs` DECIMAL(38,0) COMMENT '企业户数',
  `mmylr` DECIMAL(18,2) COMMENT '每美元利润',
  KEY `IDX_JKGL_QSPJ_CKSP` (`BGQID`, `SP8_DM`),
  CONSTRAINT `PK_JKGL_QSPJ_CKSP` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='全省平均_出口商品汇总';

-- Creating table JKGL_QSPJ_JGB
-- Original Oracle primary-key constraint: PK_JKGL_QSPJ_JGB (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_QSPJ_JGB` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '序号',
  `bgqid` DECIMAL(20,0) COMMENT '报告期ID，关联主表PK_JKGL_DATA_BGQ',
  `mll` DECIMAL(18,2) COMMENT '毛利率',
  `hysfl` DECIMAL(18,2) COMMENT '还原税负率',
  `fysrb` DECIMAL(18,2) COMMENT '费用收入比',
  `dwgdzcxse` DECIMAL(18,2) COMMENT '单位固定资产销售额',
  `dwjymjxse` DECIMAL(18,2) COMMENT '单位经营面积销售额',
  KEY `IDX_JKGL_QSPJ_JGB` (`BGQID`),
  CONSTRAINT `PK_JKGL_QSPJ_JGB` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='全省平均_结果表';

-- Creating table JKGL_QUERY_PLAN
-- Original Oracle primary-key constraint: PK_JKGL_QUERY_PLAN (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_QUERY_PLAN` (
  `qp_uuid` VARCHAR(40) NOT NULL COMMENT '查询方案UUID ',
  `qp_name` VARCHAR(50) NOT NULL COMMENT '查询方案名称 ',
  `ywms` VARCHAR(200) COMMENT '业务描述 ',
  `uptime` DATETIME NOT NULL COMMENT '修改时间 ',
  `owner_dm` VARCHAR(20) NOT NULL COMMENT '所属用户（代码） ',
  `owner_mc` VARCHAR(30) NOT NULL COMMENT '所属用户（名称） ',
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '所属税务机关 ',
  `dts_id` VARCHAR(20) NOT NULL COMMENT '查询源标识 查询源标识',
  `zfbz` CHAR(1) NOT NULL COMMENT '作废标志 N/Y作废',
  `gxbz` CHAR(1) NOT NULL COMMENT '共享标志 0/1共享',
  `gxfw` VARCHAR(11) COMMENT '共享范围 133全省',
  `gxcs` DECIMAL(10,0) COMMENT '其他机关共享次数 机关外访问',
  `fwcs` DECIMAL(10,0) COMMENT '所属机关访问次数 机关内访问',
  CONSTRAINT `PK_JKGL_QUERY_PLAN` PRIMARY KEY (`QP_UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='通用查询方案配置';

-- Creating table JKGL_QUERY_PLAN_COND
-- Original Oracle primary-key constraint: PK_JKGL_QUERY_PLAN_COND (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_QUERY_PLAN_COND` (
  `qp_uuid` VARCHAR(40) NOT NULL COMMENT '查询方案UUID',
  `ch` DECIMAL(38,0) NOT NULL COMMENT '（条件）序号',
  `lb` VARCHAR(5) COMMENT '左括号，在条件前加(',
  `df_id` VARCHAR(40) NOT NULL COMMENT '数据项标识',
  `c_relation` VARCHAR(20) NOT NULL COMMENT '条件关系',
  `c_targetval` VARCHAR(250) NOT NULL COMMENT '条件值',
  `c_logic` VARCHAR(10) COMMENT '逻辑关系AND/OR',
  `rb` VARCHAR(5) COMMENT '右括号，在条件尾加)',
  `expression` VARCHAR(500) COMMENT '本条件表达式',
  CONSTRAINT `PK_JKGL_QUERY_PLAN_COND` PRIMARY KEY (`QP_UUID`, `CH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='通用查询方案-查询条件子表配置';

-- Creating table JKGL_QUERY_PLAN_ITEM
-- Original Oracle primary-key constraint: PK_JKGL_QUERY_PLAN_ITEM (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_QUERY_PLAN_ITEM` (
  `qp_uuid` VARCHAR(40) NOT NULL COMMENT '查询方案UUID',
  `th` DECIMAL(38,0) NOT NULL COMMENT '（数据）序号',
  `df_id` VARCHAR(40) NOT NULL COMMENT '数据项标识',
  CONSTRAINT `PK_JKGL_QUERY_PLAN_ITEM` PRIMARY KEY (`QP_UUID`, `TH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='通用查询方案-查询输出项配置';

-- Creating table JKGL_QUERY_TASK_LOG
-- Original Oracle primary-key constraint: PK_JKGL_QUERY_TASK_LOG (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_QUERY_TASK_LOG` (
  `qt_uuid` VARCHAR(40) NOT NULL COMMENT 'QT_UUID',
  `crtime` DATETIME NOT NULL COMMENT '创建时间',
  `czry_dm` VARCHAR(20) NOT NULL COMMENT '用户代码',
  `czry_mc` VARCHAR(30) NOT NULL COMMENT '用户名称',
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关',
  `dts_id` VARCHAR(20) NOT NULL COMMENT '查询源标识，查询源标识',
  `sql` VARCHAR(4000) COMMENT 'SQL脚本',
  `wctime` DATETIME COMMENT '完成时间',
  `totalrows` DECIMAL(10,0) COMMENT '结果总数量',
  `export` DECIMAL(10,0) NOT NULL COMMENT '导出标志，初始0，计量导出次数',
  `task_hash` VARCHAR(40) NOT NULL COMMENT '任务哈希，DTS_ID+SQL+创建时间转年月日为明文',
  CONSTRAINT `PK_JKGL_QUERY_TASK_LOG` PRIMARY KEY (`QT_UUID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='通用查询任务日志';

-- Creating table JKGL_QUERY_TASK_RESULT
-- Original Oracle primary-key constraint: PK_JKGL_QUERY_TASK_RESULT (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_QUERY_TASK_RESULT` (
  `task_hash` VARCHAR(40) NOT NULL COMMENT '任务哈希',
  `qr_data` LONGTEXT COMMENT '查询结果报文',
  `page` DECIMAL(10,0) NOT NULL COMMENT '页码',
  CONSTRAINT `PK_JKGL_QUERY_TASK_RESULT` PRIMARY KEY (`TASK_HASH`, `PAGE`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='通用查询任务-数据结果';

-- Creating table JKGL_REPORT_CHART
-- Original Oracle primary-key constraint: PK_R_I_Z_Z (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_REPORT_CHART` (
  `zbmodel` VARCHAR(20) NOT NULL COMMENT '指标源对象',
  `crtime` DATETIME,
  `uptime` DATETIME,
  `title` VARCHAR(40) COMMENT '指标名称',
  `categories` VARCHAR(2000) COMMENT '分类维度',
  `series` VARCHAR(4000) COMMENT '指标系列，格式：countries:select 1 from dual ，多系列用分号分割',
  `type` CHAR(1) COMMENT '1,单系列 2.多系列',
  CONSTRAINT `PK_R_I_Z_Z` PRIMARY KEY (`ZBMODEL`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table JKGL_REPORT_DATASOURCE
-- Original Oracle primary-key constraint: PK_R_D_ID (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_REPORT_DATASOURCE` (
  `zbmodel_id` VARCHAR(40) NOT NULL COMMENT '数据源对象标识',
  `zbmodel_name` VARCHAR(60) COMMENT '数据源对象名称',
  `scripte_sql` VARCHAR(4000) COMMENT '执行脚本',
  `prams_holder` VARCHAR(100) COMMENT '参数占位符，都好分割，如#{djxh},#{ckrq}',
  `qybz` CHAR(1) COMMENT '启用标志',
  `bz` VARCHAR(2000) COMMENT '说明',
  `type` CHAR(1) COMMENT '数据源适用类型：1、表，2、表单，3、分析图',
  `crtime` DATETIME,
  `uptime` DATETIME,
  `data_source` VARCHAR(20) COMMENT '脚本数据源标识,1、TSSH  2、JSXT',
  CONSTRAINT `PK_R_D_ID` PRIMARY KEY (`ZBMODEL_ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table JKGL_REPORT_RESULT
-- Original Oracle primary-key constraint: JKGL_REPORT_RESULT (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_REPORT_RESULT` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `bgnd` CHAR(4) NOT NULL COMMENT '报告年度',
  `bglx` CHAR(1) NOT NULL COMMENT '报告类型，1-画像报告',
  `nsrsbh` VARCHAR(20) NOT NULL COMMENT '纳税人识别号',
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `sqr_xm` VARCHAR(20) NOT NULL COMMENT '申请人姓名',
  `sqr_dm` VARCHAR(20) NOT NULL COMMENT '申请人代码',
  `sqsj` DATETIME NOT NULL COMMENT '申请时间',
  `ztbz` CHAR(1) COMMENT '状态标志，0-已申请，1-处理中，2-已生成，9-异常中断',
  `tqbs` VARCHAR(50) COMMENT '提取标识',
  `clkssj` DATETIME COMMENT '处理开始时间',
  `clwcsj` DATETIME COMMENT '处理完成时间',
  `filesize` DECIMAL(20,0) COMMENT '报告文件大小，单位K',
  `filefmt` VARCHAR(10) COMMENT '报告文件格式，DOC/DOCX',
  `filepath` VARCHAR(200) COMMENT '报告文件路径',
  `xzcs` DECIMAL(5,0) DEFAULT 0 COMMENT '下载次数',
  CONSTRAINT `JKGL_REPORT_RESULT` PRIMARY KEY (`DJXH`, `BGND`, `BGLX`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='企业画像报告结果表';

-- Creating table JKGL_REPORT_RESULT_LOG
-- Original Oracle primary-key constraint: JKGL_REPORT_RESULT_LOG (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_REPORT_RESULT_LOG` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `bgnd` CHAR(4) NOT NULL COMMENT '报告年度',
  `bglx` CHAR(1) NOT NULL COMMENT '报告类型，1-画像报告',
  `nsrsbh` VARCHAR(20) NOT NULL COMMENT '纳税人识别号',
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `sqr_xm` VARCHAR(20) NOT NULL COMMENT '申请人姓名',
  `sqr_dm` VARCHAR(20) NOT NULL COMMENT '申请人代码',
  `sqsj` DATETIME NOT NULL COMMENT '申请时间',
  `ztbz` CHAR(1) COMMENT '状态标志，0-已申请，1-处理中，2-已生成，9-异常中断',
  `tqbs` VARCHAR(50) COMMENT '提取标识',
  `clkssj` DATETIME COMMENT '处理开始时间',
  `clwcsj` DATETIME COMMENT '处理完成时间',
  `filesize` DECIMAL(20,0) COMMENT '报告文件大小，单位K',
  `filefmt` VARCHAR(10) COMMENT '报告文件格式，DOC/DOCX',
  `filepath` VARCHAR(200) COMMENT '报告文件路径',
  `xzcs` DECIMAL(5,0) DEFAULT 0 COMMENT '下载次数',
  CONSTRAINT `JKGL_REPORT_RESULT_LOG` PRIMARY KEY (`DJXH`, `BGND`, `BGLX`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='企业画像报告结果表';

-- Creating table JKGL_REPORT_TEMPLATE
-- JKGL_REPORT_TEMPLATE.id: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- Original Oracle primary-key constraint: PK_R_T_ID (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_REPORT_TEMPLATE` (
  `id` DECIMAL(65,27) NOT NULL,
  `template_name` VARCHAR(100) COMMENT '文件名',
  `remark` VARCHAR(1000) COMMENT '说明',
  `type` CHAR(1) COMMENT '类型0，常规 1，定时',
  `qybz` CHAR(1) COMMENT '启用标志',
  `cjr` VARCHAR(20) COMMENT '创建人',
  `crtime` DATETIME COMMENT '创建时间',
  `uptime` DATETIME COMMENT '修改时间',
  CONSTRAINT `PK_R_T_ID` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table JKGL_REPORT_TEMPLATE_PZ
-- JKGL_REPORT_TEMPLATE_PZ.template_id: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- Original Oracle primary-key constraint: PK_R_T_P_PK (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_REPORT_TEMPLATE_PZ` (
  `template_id` DECIMAL(65,27) NOT NULL,
  `zbmodel_id` VARCHAR(20) NOT NULL,
  CONSTRAINT `PK_R_T_P_PK` PRIMARY KEY (`TEMPLATE_ID`, `ZBMODEL_ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table JKGL_REPORT_XZ_LOG
-- Original Oracle primary-key constraint: JKGL_REPORT_XZ_LOG (MySQL index name: PRIMARY).
CREATE TABLE `JKGL_REPORT_XZ_LOG` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键ID',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `bgnd` CHAR(4) NOT NULL COMMENT '报告年度',
  `bglx` CHAR(1) NOT NULL COMMENT '报告类型，1-画像报告',
  `xzr_swjg_dm` VARCHAR(11) NOT NULL COMMENT '下载人税务机关代码',
  `xzr_xm` VARCHAR(20) NOT NULL COMMENT '下载人姓名',
  `xzr_dm` VARCHAR(20) NOT NULL COMMENT '下载人代码',
  `xzsj` DATETIME NOT NULL COMMENT '下载时间',
  CONSTRAINT `JKGL_REPORT_XZ_LOG` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='企业画像报告下载日志表';

-- Creating table JKGL_ZLCJ_JGB
-- Original Oracle primary-key constraint: PK_JKGL_ZLCJ_JGB (MySQL index name: PRIMARY).
-- Auxiliary UNIQUE index UDX_JKGL_ZLCJ_JGB_ORACLE_NULLS preserves Oracle composite-UNIQUE NULL behavior: duplicate partially-NULL keys are rejected; wholly-NULL keys remain allowed. NULL flags prevent sentinel collisions; original named UNIQUE key is kept.
CREATE TABLE `JKGL_ZLCJ_JGB` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '出口企业登记序号（不要用便捷退税的nsrdzdah）',
  `zcjydz` VARCHAR(200) COMMENT '注册经营地址  ',
  `ybnsr_djrq` DATETIME COMMENT '一般纳税人登记日期  ',
  `sbckyw_fsrq` DATETIME COMMENT '首笔出口业务发生日期  ',
  `fddbr_xm` VARCHAR(50) COMMENT '法定代表人_姓名  ',
  `fddbr_lxdh` VARCHAR(50) COMMENT '法定代表人_联系电话  ',
  `cwfzr_xm` VARCHAR(50) COMMENT '财务负责人_姓名  ',
  `cwfzr_lxdh` VARCHAR(50) COMMENT '财务负责人_联系电话  ',
  `zczb` DECIMAL(18,2) COMMENT '注册资本（元）  ',
  `zchj` DECIMAL(18,2) COMMENT '企业资产合计（元）  ',
  `gdzczz` DECIMAL(18,2) COMMENT '固定资产总值（元） 【生产】 ',
  `zgrs` DECIMAL(10,0) COMMENT '职工人数  ',
  `sbjfrs` DECIMAL(10,0) COMMENT '社保缴费人数  ',
  `myfs` VARCHAR(100) COMMENT '贸易方式(可多选）  一般贸易/进料加工/深加工结转/来料加工',
  `yjnscnl` DECIMAL(18,2) COMMENT '预计年生产能力（元）  ',
  `yjbgcs_mj` DECIMAL(10,0) COMMENT '生产经营场所/办公场所_面积（平方米）  ',
  `yjbgcs_cq` VARCHAR(10) COMMENT '生产经营场所/办公场所_产权  自有/租赁（存储中文）',
  `yjbgcs_zlqx` DATETIME COMMENT '经营场地/办公场所_租赁期限  ',
  `yjbgcs_zlnf` DECIMAL(18,2) COMMENT '年租赁费  ',
  `yjbgcs_ywzlfp` CHAR(1) COMMENT '租赁发票开具情况  Y有/N无',
  `ckfs` VARCHAR(10) COMMENT '出口方式  自营/委托（存储中文）',
  `yw_szck` CHAR(1) COMMENT '是否设置仓库  Y是/N否',
  `ck_mj` DECIMAL(10,0) COMMENT '仓库面积  ',
  `yw_wgcpck` CHAR(1) COMMENT '有无外购产品出口 【生产】 Y有/N无',
  `yw_wtjgcpck` CHAR(1) COMMENT '有无委托加工产品出口 【生产】 Y有/N无',
  `yw_sgcyqycpck` CHAR(1) COMMENT '有无收购成员企业产品出口 【生产】 Y有/N无',
  `yw_gnxs` CHAR(1) COMMENT '有无国内销售 【生产】 Y有/N无',
  `yw_agdszzc` CHAR(1) COMMENT '是否按规定设置账册  Y是/N否',
  `yw_agddzba` CHAR(1) COMMENT '是否按规定进行单证备案  Y是/N否',
  `dzba_fs` CHAR(1) COMMENT '单证备案方式  1数字化/0纸质',
  `sfyz_ckxs_zchw` CHAR(1) COMMENT '出口销售货物的品种、规格等是否与自产货物（含视同自产货物）一致 【生产】 Y是/N否',
  `sfqdht_jwdzhgr` CHAR(1) COMMENT '生产企业已与境外单位或个人签订出口合同 【生产】 Y是/N否',
  `sfqdht_wmzhfw` CHAR(1) COMMENT '生产企业已与外贸综合服务企业签订外贸综合服务合同（协议） 【生产】 Y是/N否',
  `sjjydz` VARCHAR(200) COMMENT '实际经营地址  ',
  `sjjyr_xm` VARCHAR(50) COMMENT '实际控制人_姓名  ',
  `sjjyr_lxdh` VARCHAR(50) COMMENT '实际控制人_联系电话  ',
  `sjjyr_jg_xzqh` VARCHAR(6) COMMENT '实际控制人_籍贯  行政区划代码表（6位区县级）',
  `sjjyr_fddbr_gx` VARCHAR(10) COMMENT '法定代表人与实际经营人之间的关系  人员关系代码表',
  `bsr_xm` VARCHAR(50) COMMENT '办税人_姓名  ',
  `bsr_lxdh` VARCHAR(50) COMMENT '办税人_联系电话  ',
  `bsr_sfzh` VARCHAR(20) COMMENT '办税人员_身份证号  ',
  `bsr_zzjz` VARCHAR(10) COMMENT '办税人员_专职兼职  专职/兼职（存储中文）',
  `sn_sjwxsr` DECIMAL(18,2) COMMENT '上年实际外销收入（元）  ',
  `dn_yjwxsr` DECIMAL(18,2) COMMENT '当年预计全年外销收入（元）  ',
  `sfxf_zmsbysj` CHAR(1) COMMENT '帐面设备与实际是否相符 【生产】 Y是/N否',
  `gdfs` VARCHAR(10) COMMENT '供电方式 【生产】 自有/外搭（存储中文）',
  `hh_zydb` VARCHAR(50) COMMENT '自由电表（户号）【生产】 ',
  `hh_wddb` VARCHAR(50) COMMENT '外搭电（电表户主） 【生产】 ',
  `ypj_mj` DECIMAL(10,0) COMMENT '样品间面积 【外贸】 ',
  `ptgs_nsrsbh` VARCHAR(20) COMMENT '配套公司_纳税人识别号 【外贸】',
  `ptgs_nsrmc` VARCHAR(100) COMMENT '配套公司_纳税人名称 【外贸】 ',
  `sjgx_sj` DATETIME COMMENT '数据更新时间',
  `sjjyr_sfzh` VARCHAR(20) COMMENT '实际经营人_身份证号  ',
  `tsjsfs` VARCHAR(6) COMMENT '退税计算方式 1-生产，2-外贸',
  `sjjyr_fddbr_gx_qt` VARCHAR(50) COMMENT '法定代表人与实际经营人之间的关系—其他',
  `cjlx` CHAR(1) COMMENT '采集类型 a-出口企业信息采集',
  `nsrsbh` VARCHAR(21) COMMENT '纳税人识别号',
  `nsrmc` VARCHAR(200) COMMENT '纳税人名称',
  `sn_ljcke` DECIMAL(18,2) COMMENT '上年累计出口额（美元）',
  `bn_ljcke` DECIMAL(18,2) COMMENT '本年累计出口额（美元）',
  `zyscsb` VARCHAR(1000) COMMENT '主要生产设备（生产企业有效）',
  UNIQUE KEY `UDX_JKGL_ZLCJ_JGB` (`NSRSBH`, `CJLX`),
  CONSTRAINT `PK_JKGL_ZLCJ_JGB` PRIMARY KEY (`DJXH`),
  UNIQUE KEY `UDX_JKGL_ZLCJ_JGB_ORACLE_NULLS` ((IF(`nsrsbh` IS NULL AND `cjlx` IS NULL, NULL, 1)), (COALESCE(`nsrsbh`, '')), (`nsrsbh` IS NULL), (COALESCE(`cjlx`, '')), (`cjlx` IS NULL))
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='健康管理-资料采集-结果表';

-- Creating table JKGL_ZLCJ_JGB_ZB
-- Original Oracle primary-key constraint: PK_JKGL_ZLCJ_JGB_ZB (MySQL index name: PRIMARY).
-- zyscsb: VARCHAR2(4000) -> TEXT with CHAR_LENGTH <= 4000 CHECK to keep this wide row below MySQL 65535 bytes.
CREATE TABLE `JKGL_ZLCJ_JGB_ZB` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `zyscsb` TEXT COMMENT '主要生产设备',
  `zy_cksp` VARCHAR(500) COMMENT '主要经营商品(代码和名称)  ',
  `zy_ckgb` VARCHAR(500) COMMENT '主要出口国别',
  `qkms` VARCHAR(4000) COMMENT '情况描述',
  `qtsx` VARCHAR(4000) COMMENT '其他事项 ',
  `ckspgylc` VARCHAR(4000) COMMENT '出口产品的主要生产工艺流程 【生产】',
  `zy_bgka` VARCHAR(500) COMMENT '主要报关口岸',
  CONSTRAINT `PK_JKGL_ZLCJ_JGB_ZB` PRIMARY KEY (`DJXH`),
  CHECK (CHAR_LENGTH(`zyscsb`) <= 4000)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table MSG_PUSH_DATA
-- Original Oracle primary-key constraint: PK_MSG_PUSH_DATA (MySQL index name: PRIMARY).
CREATE TABLE `MSG_PUSH_DATA` (
  `id` DECIMAL(10,0) NOT NULL,
  `swjg_dm` VARCHAR(11) COMMENT '税务机关代码',
  `nsrsbh` VARCHAR(20) COMMENT '纳税人识别号',
  `nsrmc` VARCHAR(100) COMMENT '纳税人名称',
  `biztype` VARCHAR(20) COMMENT '业务种类： 退税办理/函调复函/荣缺办理',
  `bizkey` VARCHAR(40) COMMENT '业务关键字',
  `qdsj` DATETIME COMMENT '启动时间',
  `jzsj` DATETIME COMMENT '截止时间',
  `ywbz` VARCHAR(100) COMMENT '业务备注',
  `sjtbsj` DATETIME COMMENT '数据同步时间',
  `txcs` DECIMAL(38,0) COMMENT '提醒次数',
  `txsj` DATETIME COMMENT '提醒时间',
  `idly` CHAR(1) NOT NULL COMMENT 'ID来源，0金三1便捷退税',
  KEY `IDX_MSG_PUSH_DATA` (`SWJG_DM`, `BIZTYPE`),
  KEY `IDX_MSG_PUSH_DATA_BB` (`BIZTYPE`, `BIZKEY`),
  CONSTRAINT `PK_MSG_PUSH_DATA` PRIMARY KEY (`ID`, `IDLY`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='通用短信提醒业务数据表（每天晚上自动抽取更新即将逾期';

-- Creating table MSG_PUSH_PLAN
-- Auxiliary UNIQUE index UNI_USERID_PLANTAG_ORACLE_NULLS preserves Oracle composite-UNIQUE NULL behavior: duplicate partially-NULL keys are rejected; wholly-NULL keys remain allowed. NULL flags prevent sentinel collisions; original named UNIQUE key is kept.
CREATE TABLE `MSG_PUSH_PLAN` (
  `id` DECIMAL(20,0) NOT NULL,
  `userid` DECIMAL(20,0) COMMENT '发送用户的userid',
  `content` VARCHAR(200) NOT NULL,
  `send_type` CHAR(1) COMMENT '0短',
  `send_targ` VARCHAR(128) COMMENT '手机号',
  `crtime` DATETIME,
  `uptime` DATETIME,
  `plan_flag` CHAR(1) COMMENT '0待发送/1发送完成/9失败',
  `send_time` DATETIME,
  `tscs` DECIMAL(16,0) DEFAULT 0,
  `is_reply` CHAR(1),
  `reply_time` DATETIME,
  `qybz` CHAR(1),
  `fetch_lock` VARCHAR(64) COMMENT '任务锁定标志',
  `plan_tag` VARCHAR(64),
  `username` VARCHAR(40) COMMENT '发送用户',
  `swjg_dm` VARCHAR(20) COMMENT '税务机关代码',
  UNIQUE KEY `UNI_USERID_PLANTAG` (`USERID`, `PLAN_TAG`),
  UNIQUE KEY `UNI_USERID_PLANTAG_ORACLE_NULLS` ((IF(`userid` IS NULL AND `plan_tag` IS NULL, NULL, 1)), (COALESCE(`userid`, 0)), (`userid` IS NULL), (COALESCE(`plan_tag`, '')), (`plan_tag` IS NULL))
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table MSG_PUSH_PLAN_2DEL
CREATE TABLE `MSG_PUSH_PLAN_2DEL` (
  `id` DECIMAL(20,0) NOT NULL,
  `userid` DECIMAL(20,0) COMMENT '发送用户的userid',
  `content` VARCHAR(200) NOT NULL,
  `send_type` CHAR(1) COMMENT '0短',
  `send_targ` VARCHAR(128) COMMENT '手机号',
  `crtime` DATETIME,
  `uptime` DATETIME,
  `plan_flag` CHAR(1) COMMENT '0待发送/1发送完成/9失败',
  `send_time` DATETIME,
  `tscs` DECIMAL(16,0) DEFAULT 0,
  `is_reply` CHAR(1),
  `reply_time` DATETIME,
  `qybz` CHAR(1),
  `fetch_lock` VARCHAR(64) COMMENT '任务锁定标志',
  `plan_tag` VARCHAR(64),
  `username` VARCHAR(40) COMMENT '发送用户',
  `swjg_dm` VARCHAR(20) COMMENT '税务机关代码'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table MSG_PUSH_USER
-- Original Oracle primary-key constraint: PK_MSG_PUSH_USER (MySQL index name: PRIMARY).
CREATE TABLE `MSG_PUSH_USER` (
  `id` DECIMAL(20,0) NOT NULL,
  `username` VARCHAR(40) COMMENT '发送用户',
  `job_type` VARCHAR(200) NOT NULL COMMENT '职务（1-局长、2-科股长、3-市局汇总、4-省局汇总）',
  `phone` VARCHAR(11) COMMENT '手机号',
  `crtime` DATETIME,
  `uptime` DATETIME,
  `swjg_dm` VARCHAR(20) COMMENT '税务机关代码',
  `qybz` CHAR(1),
  `job_ms` VARCHAR(40),
  `swjg_mc` VARCHAR(80),
  `gddh` VARCHAR(20),
  `jjyq_tssb` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '（即将逾期）退税业务短信（N-否、Y-是）',
  `jjyq_fuh` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '（即将逾期）函调复函短信（N-否、Y-是）',
  `jjyq_sdhc` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '（即将逾期）实地核查短信（N-否、Y-是）',
  `fxck` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '风险出口短信（N-否、Y-是）',
  `nksqtx` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '（内控事前提醒短信（N-否、Y-是）',
  `nkshjd` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '内控事后监督短信（N-否、Y-是）',
  `jjyq_fuhcl` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '（即将逾期）函调处理短信（N-否、Y-是）',
  `jjrtxbz` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '节假日提醒标志（N-否、Y-是）',
  `fxcksb` CHAR(1),
  `fxgh` CHAR(1),
  `fxghsb` CHAR(1),
  CONSTRAINT `PK_MSG_PUSH_USER` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table RCGL_CQWSB_DATA
-- Original Oracle primary-key constraint: PK_RCGL_CQWSB_DATA (MySQL index name: PRIMARY).
CREATE TABLE `RCGL_CQWSB_DATA` (
  `uuid` VARCHAR(32) NOT NULL,
  `swjgdm` CHAR(11) COMMENT '税务机关代码',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `nsrsbh` VARCHAR(20) COMMENT '纳税人识别号',
  `nsrmc` VARCHAR(200) COMMENT '纳税人名称',
  `tsjsffdm` CHAR(1) COMMENT '退税计算方式',
  `ckbgdh` VARCHAR(21) NOT NULL COMMENT '21位报关单号或20位代理出口货物证明号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `gfhhgspmc` VARCHAR(500) COMMENT '规范化海关商品名称',
  `jgfs_dm` CHAR(4) COMMENT '监管方式',
  `mylaj` DECIMAL(18,2) COMMENT '出口美元离岸价',
  `rmblaj` DECIMAL(18,2) COMMENT '出口人民币离岸价',
  `dyjldw_dm` VARCHAR(3) COMMENT '法定单位',
  `cksl` DECIMAL(16,4) COMMENT '出口数量',
  `wsbsl` DECIMAL(16,4) COMMENT '剩余未申报数量',
  `zssl` DECIMAL(16,6) COMMENT '征税税率',
  `tsl` DECIMAL(16,6) COMMENT '退税率',
  `sjly` VARCHAR(11) COMMENT '数据来源（抽取服务用SYSTEM/依职权用税务人员代码）',
  `cjrq` DATETIME COMMENT '新增日期',
  `zmtbz` CHAR(1) COMMENT '征免税类型（1征税/2免税/0可退税）',
  `qyqr_rq` DATETIME COMMENT '企业确认时间',
  `qyqr_zt` CHAR(1) DEFAULT '0' COMMENT '企业确认状态（0未确认/1适用征税/2适用免税/3已全部退税/4待申报退税/5非销售业务，默认“未确认”）',
  `zms_sbssq` CHAR(6) COMMENT '申报所属期',
  `zs_ysxse` DECIMAL(18,2) COMMENT '应税销售额',
  `zs_jtxxse` DECIMAL(18,2) COMMENT '计提销项税额',
  `zms_ckfphm` VARCHAR(500) COMMENT '出口发票号码',
  `ms_msxse` DECIMAL(18,2) COMMENT '免税销售额',
  `ms_jhpzhbz` CHAR(2) COMMENT '是否有进货凭证（有/无）',
  `ms_jhpzh` VARCHAR(500) COMMENT '进货凭证号',
  `ms_jxzcbz` CHAR(2) COMMENT '是否进项转出（是/否）',
  `ms_jxzcssq` CHAR(6) COMMENT '进项转出所属期',
  `ms_jxzcje` DECIMAL(18,2) COMMENT '进项转出金额',
  `zms_fj` VARCHAR(500) COMMENT '附件',
  `zms_bz` VARCHAR(500) COMMENT '备注',
  `wsb_yylx` VARCHAR(100) COMMENT '待申报原因类型（信息不齐/单证未收齐/尚未收汇/稽查/其他）',
  `wsb_yysm` VARCHAR(500) COMMENT '待申报具体原因（选其他时填写）',
  `swsh_rq` DATETIME COMMENT '税务审核时间',
  `swsh_zt` CHAR(1) DEFAULT '0' COMMENT '税局审核状态（0未审核/1审核通过/2审核未通过，默认“未审核”）',
  `swsh_ry` VARCHAR(20) COMMENT '税务审核人员',
  `swsh_htyj` VARCHAR(500) COMMENT '回退意见（审核未通过填写）',
  `cytssbjl` VARCHAR(60) COMMENT '参与退税申报记录',
  `hgcjfs_dm` CHAR(1) COMMENT '成交方式',
  `zms_ckfpbz` CHAR(2) COMMENT '是否开具出口发票（是/否，否的时候前台显示无票销售）',
  `js_rq` DATETIME COMMENT '机审时间',
  `js_zt` CHAR(1) DEFAULT '0' COMMENT '机审状态（0未审核/1审核通过/2审核有疑点，默认“未审核”）',
  `js_yd` VARCHAR(1000) COMMENT '机审疑点（机审有疑点时填写）',
  `tqbz` VARCHAR(32),
  `tqsj` DATETIME,
  `js_dm` VARCHAR(4) COMMENT '机审疑点代码',
  `ysb_tse` DECIMAL(18,2) COMMENT '已申报退税额',
  `ysb_mde` DECIMAL(18,2) COMMENT '已申报免抵额',
  KEY `IDX_RCGL_CQWSB_DATA_CKRQ` (`CKRQ_1`),
  KEY `IDX_RCGL_CQWSB_DATA_S` (`SWJGDM`),
  KEY `JSRW_COL_IDX` (`SWJGDM`, `JS_ZT`, `TQSJ`, `SWSH_ZT`),
  CONSTRAINT `PK_RCGL_CQWSB_DATA` PRIMARY KEY (`DJXH`, `CKBGDH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='长期未申报退税业务数据表';

-- Creating table RCGL_CQWSB_HTRZ
CREATE TABLE `RCGL_CQWSB_HTRZ` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `ckbgdh` VARCHAR(21) NOT NULL COMMENT '21位报关单号或20位代理出口货物证明号',
  `qyqr_rq` DATETIME COMMENT '企业确认时间',
  `qyqr_zt` CHAR(1) DEFAULT '0' COMMENT '企业确认状态（0未确认/1适用征税/2适用免税/3已全部退税/4待申报退税，默认“未确认”）',
  `zms_sbssq` CHAR(6) COMMENT '申报所属期',
  `zs_ysxse` DECIMAL(18,2) COMMENT '应税销售额',
  `zs_jtxxse` DECIMAL(18,2) COMMENT '计提销项税额',
  `zms_ckfphm` VARCHAR(500) COMMENT '出口发票号码',
  `ms_msxse` DECIMAL(18,2) COMMENT '免税销售额',
  `ms_jhpzhbz` CHAR(2) COMMENT '是否有进货凭证（有/无）',
  `ms_jhpzh` VARCHAR(500) COMMENT '进货凭证号',
  `ms_jxzcbz` CHAR(2) COMMENT '是否进项转出（是/否）',
  `ms_jxzcssq` CHAR(6) COMMENT '进项转出所属期',
  `ms_jxzcje` DECIMAL(18,2) COMMENT '进项转出金额',
  `zms_fj` VARCHAR(500) COMMENT '附件',
  `zms_bz` VARCHAR(500) COMMENT '备注',
  `wsb_yylx` VARCHAR(100) COMMENT '待申报原因类型（信息不齐/单证未收齐/尚未收汇/稽查/其他）',
  `wsb_yysm` VARCHAR(500) COMMENT '待申报具体原因（选其他时填写）',
  `swsh_rq` DATETIME COMMENT '税务审核时间',
  `swsh_zt` CHAR(1) DEFAULT '0' COMMENT '税局审核状态（0未审核/1审核通过/2审核未通过，默认“未审核”）',
  `swsh_ry` VARCHAR(11) COMMENT '税务审核人员',
  `swsh_htyj` VARCHAR(500) COMMENT '回退意见（审核未通过填写）',
  `zms_ckfpbz` CHAR(2) COMMENT '是否开具出口发票（是/否，否的时候前台显示无票销售）',
  `js_rq` DATETIME COMMENT '机审时间',
  `js_zt` CHAR(1) DEFAULT '0' COMMENT '机审状态（0未审核/1审核通过/2审核有疑点，默认“未审核”）',
  `js_yd` VARCHAR(500) COMMENT '机审疑点（机审有疑点时填写）',
  KEY `IDX_RCGL_CQWSB_HTRZ_DC` (`DJXH`, `CKBGDH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='长期未申报退税业务回退日志表';

-- Creating table RCGL_SDQY_9810
-- RCGL_SDQY_9810.id: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- Original Oracle primary-key constraint: PK_ID_SDQY (MySQL index name: PRIMARY).
CREATE TABLE `RCGL_SDQY_9810` (
  `id` DECIMAL(65,27) NOT NULL COMMENT '序号，主键',
  `nsrsbh` VARCHAR(21) COMMENT '税号',
  `nsrmc` VARCHAR(200) COMMENT '名称',
  `swjgdm` VARCHAR(13) COMMENT '税务机关代码',
  `qybj` CHAR(1) COMMENT '启用标记',
  `cjr` VARCHAR(20) COMMENT '创建人',
  `crtime` DATETIME COMMENT '创建时间',
  `uptime` DATETIME COMMENT '更新时间',
  `djxh` DECIMAL(21,0) COMMENT '登记序号',
  CONSTRAINT `PK_ID_SDQY` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='态势感知-9810试点企业名单';

-- Creating table RCGL_SDQY_9810_BAK
-- RCGL_SDQY_9810_BAK.id: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- Original Oracle primary-key constraint: PK_RCGL_SDQY_9810_BAK (MySQL index name: PRIMARY).
CREATE TABLE `RCGL_SDQY_9810_BAK` (
  `id` DECIMAL(65,27) NOT NULL COMMENT '序号，主键',
  `nsrsbh` VARCHAR(21) COMMENT '税号',
  `nsrmc` VARCHAR(200) COMMENT '名称',
  `swjgdm` VARCHAR(13) COMMENT '税务机关代码',
  `qybj` CHAR(1) COMMENT '启用标记',
  `cjr` VARCHAR(20) COMMENT '创建人',
  `crtime` DATETIME COMMENT '创建时间',
  `uptime` DATETIME COMMENT '更新时间',
  `djxh` DECIMAL(21,0) COMMENT '登记序号',
  CONSTRAINT `PK_RCGL_SDQY_9810_BAK` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='态势感知-9810试点企业名单';

-- Creating table SYS_PARAM
-- SYS_PARAM.id: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- Original Oracle primary-key constraint: PK_ID_SYS_PARAM (MySQL index name: PRIMARY).
CREATE TABLE `SYS_PARAM` (
  `id` DECIMAL(65,27) NOT NULL,
  `dcode` VARCHAR(20),
  `dvalue` VARCHAR(20),
  `dtype` VARCHAR(20),
  `remark` VARCHAR(200),
  CONSTRAINT `PK_ID_SYS_PARAM` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_FHXX_CMCODE
CREATE TABLE `TJBB_FHXX_CMCODE` (
  `ssny` VARCHAR(6) NOT NULL,
  `swcode` VARCHAR(32) NOT NULL,
  `xmfl` VARCHAR(10) NOT NULL,
  `sbywbdm` VARCHAR(10) NOT NULL,
  `usd_amt_all` DECIMAL(16,4),
  `rmb_amt_all` DECIMAL(16,4),
  `ts_amt_all` DECIMAL(16,4),
  `usd_amt_usa` DECIMAL(16,4),
  `rmb_amt_usa` DECIMAL(16,4),
  `ts_amt_usa` DECIMAL(16,4),
  KEY `IDX_TJBB_FHXX_CMCODE_SXX` (`SWCODE`, `SSNY`, `XMFL`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_FHXX_CPCODE
CREATE TABLE `TJBB_FHXX_CPCODE` (
  `ssny` VARCHAR(6) NOT NULL,
  `swcode` VARCHAR(32) NOT NULL,
  `xmfl` VARCHAR(32) NOT NULL,
  `sbywbdm` VARCHAR(10) NOT NULL,
  `usd_amt_all` DECIMAL(16,4),
  `rmb_amt_all` DECIMAL(16,4),
  `ts_amt_all` DECIMAL(16,4),
  `usd_amt_usa` DECIMAL(16,4),
  `rmb_amt_usa` DECIMAL(16,4),
  `ts_amt_usa` DECIMAL(16,4),
  KEY `IDX_TJBB_FHXX_CPCODE_SXX` (`SWCODE`, `SSNY`, `XMFL`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_FHXX_GBCODE
CREATE TABLE `TJBB_FHXX_GBCODE` (
  `ssny` VARCHAR(6) NOT NULL,
  `swcode` VARCHAR(32) NOT NULL,
  `xmfl` VARCHAR(10) NOT NULL,
  `sbywbdm` VARCHAR(10) NOT NULL,
  `usd_amt` DECIMAL(16,4),
  `rmb_amt` DECIMAL(16,4),
  `ts_amt` DECIMAL(16,4),
  KEY `IDX_TJBB_FHXX_GBCODE_SXX` (`SWCODE`, `SSNY`, `XMFL`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_FHXX_HGCODE
CREATE TABLE `TJBB_FHXX_HGCODE` (
  `ssny` VARCHAR(6) NOT NULL,
  `swcode` VARCHAR(32) NOT NULL,
  `xmfl` VARCHAR(10) NOT NULL,
  `sbywbdm` VARCHAR(10) NOT NULL,
  `usd_amt` DECIMAL(16,4),
  `rmb_amt` DECIMAL(16,4),
  `ts_amt` DECIMAL(16,4),
  KEY `IDX_TJBB_FHXX_HGCODE_SXX` (`SWCODE`, `SSNY`, `XMFL`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_FHXX_TDCODE
CREATE TABLE `TJBB_FHXX_TDCODE` (
  `ssny` VARCHAR(6) NOT NULL,
  `swcode` VARCHAR(32) NOT NULL,
  `xmfl` VARCHAR(10) NOT NULL,
  `sbywbdm` VARCHAR(10) NOT NULL,
  `usd_amt` DECIMAL(16,4),
  `rmb_amt` DECIMAL(16,4),
  `ts_amt` DECIMAL(16,4),
  KEY `IDX_TJBB_FHXX_TDCODE_SXX` (`SWCODE`, `SSNY`, `XMFL`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TJBB_FHXX_TSLV
CREATE TABLE `TJBB_FHXX_TSLV` (
  `ssny` VARCHAR(6) NOT NULL,
  `swcode` VARCHAR(32) NOT NULL,
  `xmfl` VARCHAR(10) NOT NULL,
  `sbywbdm` VARCHAR(10) NOT NULL,
  `usd_amt` DECIMAL(16,4),
  `rmb_amt` DECIMAL(16,4),
  `ts_amt` DECIMAL(16,4),
  KEY `IDX_TJBB_FHXX_TSLV_SXX` (`SWCODE`, `SSNY`, `XMFL`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_20260527_WMQYMMYLRL
-- Original Oracle primary-key constraint: PK_TMP_20260527_WMQYMMYLRL (MySQL index name: PRIMARY).
CREATE TABLE `TMP_20260527_WMQYMMYLRL` (
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `sbywbs` DECIMAL(10,0) COMMENT '申报业务笔数',
  `mmylrl_max` DECIMAL(10,2) COMMENT '最大值',
  `mmylrl_min` DECIMAL(10,2) COMMENT '最小值',
  `mmylrl_mid` DECIMAL(10,2) COMMENT '中位数',
  `mmylrl_avg` DECIMAL(10,2) COMMENT '平均值',
  `mmylrl_std` DECIMAL(10,2) COMMENT '标准差',
  `mmylrl_yjx` DECIMAL(10,2) COMMENT '预警线',
  CONSTRAINT `PK_TMP_20260527_WMQYMMYLRL` PRIMARY KEY (`SWJG_DM`, `DJXH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='每美元利润率分析模型表';

-- Creating table TMP_CKBGDH_20260408
CREATE TABLE `TMP_CKBGDH_20260408` (
  `ckbgdh` VARCHAR(21) NOT NULL,
  `sjly` VARCHAR(10)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_LCSLID
CREATE TABLE `TMP_LCSLID` (
  `lcslid` VARCHAR(32) COMMENT '流程实例ID'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_PX_JZX
CREATE TABLE `TMP_PX_JZX` (
  `jzxh` VARCHAR(32) COMMENT '集装箱号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `qyhs` DECIMAL(5,0) COMMENT '拼箱企业户数',
  KEY `IDX_TMP_PXJZX_JC` (`JZXH`, `CKRQ_1`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='拼箱集装箱';

-- Creating table TMP_PX_MX
CREATE TABLE `TMP_PX_MX` (
  `jzxh` VARCHAR(32) COMMENT '集装箱号',
  `ckrq_1` DATETIME COMMENT '出口日期',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  KEY `IDX_TMP_PX_MX_JC` (`CKRQ_1`, `JZXH`),
  KEY `IDX_TMP_PX_MX_JCD` (`CKRQ_1`, `JZXH`, `DJXH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='企业拼箱明细';

-- Creating table TMP_QY_20250121_01
CREATE TABLE `TMP_QY_20250121_01` (
  `xh` DECIMAL(20,0),
  `djxh` DECIMAL(20,0)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_QY_20250407_01
CREATE TABLE `TMP_QY_20250407_01` (
  `xh` DECIMAL(20,0),
  `nsrmc` VARCHAR(300),
  `shxyno` VARCHAR(20),
  `djxh` DECIMAL(20,0),
  `swjg` VARCHAR(11),
  `qylx` CHAR(1),
  KEY `IDX_TMP_QY_20250407_01` (`XH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_QY_20260518
CREATE TABLE `TMP_QY_20260518` (
  `djxh` DECIMAL(20,0),
  `shxhdm` VARCHAR(20),
  `nsrmc` VARCHAR(300)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_RCGL_CQWSB_20260113
CREATE TABLE `TMP_RCGL_CQWSB_20260113` (
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `nsrsbh` VARCHAR(30) COMMENT '纳税人识别号',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_RCGL_CQWSB_20260115
CREATE TABLE `TMP_RCGL_CQWSB_20260115` (
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `nsrsbh` VARCHAR(30) COMMENT '纳税人识别号',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_RCGL_CQWSB_YCL_1330108
CREATE TABLE `TMP_RCGL_CQWSB_YCL_1330108` (
  `djxh` DECIMAL(20,0),
  `ckbgdh` VARCHAR(21),
  `swsh_rq` DATETIME,
  `swsh_zt` CHAR(1) DEFAULT '0',
  `swsh_ry` VARCHAR(20),
  KEY `IDX_RCGL_CQWSB_YCL_1330108_DC` (`DJXH`, `CKBGDH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_RCGL_CQWSB_YCL_1330185
CREATE TABLE `TMP_RCGL_CQWSB_YCL_1330185` (
  `djxh` DECIMAL(20,0),
  `nsrsbh` VARCHAR(18),
  `nsrmc` VARCHAR(100),
  `ckbgdh` VARCHAR(21),
  `qyqr_zt` CHAR(1),
  KEY `IDX_RCGL_CQWSB_YCL_1330185_DC` (`DJXH`, `CKBGDH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_RCGL_CQWSB_YCL_13304
CREATE TABLE `TMP_RCGL_CQWSB_YCL_13304` (
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `nsrsbh` VARCHAR(30) COMMENT '纳税人识别号',
  `nsrmc` VARCHAR(100) COMMENT '纳税人名称',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `hsrq` DATETIME COMMENT '核实日期',
  `hsr` VARCHAR(60) COMMENT '核实人',
  `hsclyj` VARCHAR(200) COMMENT '核实处理意见',
  KEY `IDX_RCGL_CQWSB_YCL_13304_DC` (`DJXH`, `CKBGDH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_RCGL_CQWSB_YCL_13306
CREATE TABLE `TMP_RCGL_CQWSB_YCL_13306` (
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `nsrsbh` VARCHAR(18) COMMENT '纳税人识别号',
  `nsrmc` VARCHAR(100) COMMENT '纳税人名称',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `dlzmh` VARCHAR(21) COMMENT '代理证明号',
  `hsrq` DATETIME COMMENT '核实日期',
  `hsr` VARCHAR(20) COMMENT '核实人',
  `hsclyj` VARCHAR(200) COMMENT '核实处理意见',
  `swcode` VARCHAR(11) COMMENT '税务机关代码',
  `sjly` VARCHAR(10) COMMENT '数据来源',
  `lrrq` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '录入日期',
  `ckrq` DATETIME COMMENT '出口日期',
  `mylaj` DECIMAL(15,2) COMMENT '美元离岸价',
  `rmblaj` DECIMAL(15,2) COMMENT '人民币离岸价',
  KEY `IDX_RCGL_CQWSB_YCL_13306_DC` (`DJXH`, `CKBGDH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_RCGL_CQWSB_YCL_1330723
CREATE TABLE `TMP_RCGL_CQWSB_YCL_1330723` (
  `djxh` DECIMAL(20,0),
  `nsrsbh` VARCHAR(20),
  `ckbgdh` VARCHAR(21),
  `qyqr_rq` DATETIME,
  `qyqr_zt` CHAR(1),
  `zms_sbssq` CHAR(6),
  `zs_ysxse` DECIMAL(18,2),
  `zs_jtxxse` DECIMAL(18,2),
  `ms_msxse` DECIMAL(18,2),
  `ms_jxzcbz` CHAR(2),
  `ms_jxzcje` DECIMAL(18,2),
  `zms_bz` VARCHAR(500) COMMENT '备注',
  `swsh_ry` VARCHAR(20) COMMENT '税务审核人员'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_RCGL_CQWSB_YCL_1330723_1
-- Original Oracle primary-key constraint: PK_RCGL_CQWSB_YCL_1330723_1 (MySQL index name: PRIMARY).
CREATE TABLE `TMP_RCGL_CQWSB_YCL_1330723_1` (
  `qyhgdm` VARCHAR(18),
  `nsrsbh` VARCHAR(18),
  `nsrmc` VARCHAR(100),
  `ckbgdh` VARCHAR(21) NOT NULL,
  `cksp_dm` VARCHAR(20),
  `sbhgspmc` VARCHAR(500),
  `rmblaj` DECIMAL(15,2),
  `mylaj` DECIMAL(15,2),
  `ckrq` DATETIME,
  `tmszc` VARCHAR(20),
  `sfsbzzs` VARCHAR(20),
  `sbsj` VARCHAR(20),
  `abssq` VARCHAR(20),
  `mdtxse` VARCHAR(20),
  `msxse` VARCHAR(20),
  `ysxse` VARCHAR(20),
  `tmsse` VARCHAR(20),
  `jtxxse` VARCHAR(20),
  `jxzcse` VARCHAR(20),
  `rkzzs` VARCHAR(20),
  `rkznj` VARCHAR(20),
  `bz` VARCHAR(300),
  `hsclyj` VARCHAR(200),
  `hsr` VARCHAR(20),
  `djxh` DECIMAL(20,0) NOT NULL,
  CONSTRAINT `PK_RCGL_CQWSB_YCL_1330723_1` PRIMARY KEY (`DJXH`, `CKBGDH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_RCGL_CQWSB_YCL_1330723_2
-- Original Oracle primary-key constraint: PK_RCGL_CQWSB_YCL_1330723_2 (MySQL index name: PRIMARY).
CREATE TABLE `TMP_RCGL_CQWSB_YCL_1330723_2` (
  `qyhgdm` VARCHAR(18),
  `nsrsbh` VARCHAR(18),
  `nsrmc` VARCHAR(100),
  `ckbgdh` VARCHAR(21) NOT NULL,
  `cksp_dm` VARCHAR(20),
  `sbhgspmc` VARCHAR(500),
  `rmblaj` DECIMAL(15,2),
  `mylaj` DECIMAL(15,2),
  `ckrq` DATETIME,
  `tmszc` VARCHAR(20),
  `sfsbzzs` VARCHAR(20),
  `sbsj` VARCHAR(20),
  `abssq` VARCHAR(20),
  `mdtxse` VARCHAR(20),
  `msxse` VARCHAR(20),
  `ysxse` VARCHAR(20),
  `tmsse` VARCHAR(20),
  `jtxxse` VARCHAR(20),
  `jxzcse` VARCHAR(20),
  `rkzzs` VARCHAR(20),
  `rkznj` VARCHAR(20),
  `bz` VARCHAR(300),
  `hsclyj` VARCHAR(200),
  `hsr` VARCHAR(20),
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  CONSTRAINT `PK_RCGL_CQWSB_YCL_1330723_2` PRIMARY KEY (`DJXH`, `CKBGDH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_RCGL_CQWSB_YCL_13310
CREATE TABLE `TMP_RCGL_CQWSB_YCL_13310` (
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `nsrsbh` VARCHAR(30) COMMENT '纳税人识别号',
  `nsrmc` VARCHAR(100) COMMENT '纳税人名称',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `hsrq` DATETIME COMMENT '核实日期',
  `hsr` VARCHAR(60) COMMENT '核实人',
  `hsclyj` VARCHAR(200) COMMENT '核实处理意见',
  `qyqr_zt` CHAR(1) DEFAULT '0' COMMENT '企业确认状态（0未确认/1适用征税/2适用免税/3已全部退税/4待申报退税/5非销售业务，默认“未确认”）',
  `swsh_zt` CHAR(1) DEFAULT '1' COMMENT '税局审核状态（0未审核/1审核通过/2审核未通过，默认“未审核”）',
  KEY `IDX_RCGL_CQWSB_YCL_13310_DC` (`DJXH`, `CKBGDH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_RCGL_CQWSB_YCL_13310_1
CREATE TABLE `TMP_RCGL_CQWSB_YCL_13310_1` (
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `nsrsbh` VARCHAR(30) COMMENT '纳税人识别号',
  `nsrmc` VARCHAR(100) COMMENT '纳税人名称',
  `ckbgdh` VARCHAR(21) COMMENT '出口报关单号',
  `hsrq` DATETIME COMMENT '核实日期',
  `hsr` VARCHAR(60) COMMENT '核实人',
  `hsclyj` VARCHAR(200) COMMENT '核实处理意见',
  `qyqr_zt` CHAR(1) DEFAULT '0' COMMENT '企业确认状态（0未确认/1适用征税/2适用免税/3已全部退税/4待申报退税/5非销售业务，默认“未确认”）',
  `swsh_zt` CHAR(1) DEFAULT '1' COMMENT '税局审核状态（0未审核/1审核通过/2审核未通过，默认“未审核”）',
  KEY `IDX_RCGL_CQWSB_YCL_13310_1_DC` (`DJXH`, `CKBGDH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_RCGL_CQWSB_YCL_HYQY
CREATE TABLE `TMP_RCGL_CQWSB_YCL_HYQY` (
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ckbgdh` VARCHAR(21) COMMENT '21位报关单号或20位代理出口货物证明号',
  `qyqr_rq` DATETIME COMMENT '企业确认时间',
  `qyqr_zt` CHAR(1) DEFAULT '0' COMMENT '企业确认状态（0未确认/1适用征税/2适用免税/3已全部退税/4待申报退税/5非销售业务，默认“未确认”）',
  `zms_ckfpbz` CHAR(2) COMMENT '是否开具出口发票（是/否，否的时候前台显示无票销售）',
  `zms_ckfphm` VARCHAR(500) COMMENT '出口发票号码',
  `zms_sbssq` CHAR(6) COMMENT '申报所属期',
  `zs_ysxse` DECIMAL(18,2) COMMENT '应税销售额',
  `zs_jtxxse` DECIMAL(18,2) COMMENT '计提销项税额',
  `ms_msxse` DECIMAL(18,2) COMMENT '免税销售额',
  `ms_jhpzhbz` CHAR(2) COMMENT '是否有进货凭证（有/无）',
  `ms_jhpzh` VARCHAR(500) COMMENT '进货凭证号',
  `ms_jxzcbz` CHAR(2) COMMENT '是否进项转出（是/否）',
  `ms_jxzcssq` CHAR(6) COMMENT '进项转出所属期',
  `ms_jxzcje` DECIMAL(18,2) COMMENT '进项转出金额',
  `zms_bz` VARCHAR(500) COMMENT '备注',
  `wsb_yylx` VARCHAR(100) COMMENT '待申报原因类型（信息不齐/单证未收齐/尚未收汇/稽查/其他）',
  `wsb_yysm` VARCHAR(500) COMMENT '待申报具体原因（选其他时填写）'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='长期未申报退税业务会员企业数据导入';

-- Creating table TMP_RCGL_CQWSB_YCL_HYQYHIS
CREATE TABLE `TMP_RCGL_CQWSB_YCL_HYQYHIS` (
  `djxh` DECIMAL(20,0) NOT NULL,
  `ckbgdh` VARCHAR(21) NOT NULL,
  `qyqr_rq` DATETIME,
  `qyqr_zt` CHAR(1) DEFAULT '0',
  `zms_ckfpbz` CHAR(2),
  `zms_ckfphm` VARCHAR(500),
  `zms_sbssq` CHAR(6),
  `zs_ysxse` DECIMAL(18,2),
  `zs_jtxxse` DECIMAL(18,2),
  `ms_msxse` DECIMAL(18,2),
  `ms_jhpzhbz` CHAR(2),
  `ms_jhpzh` VARCHAR(500),
  `ms_jxzcbz` CHAR(2),
  `ms_jxzcssq` CHAR(6),
  `ms_jxzcje` DECIMAL(18,2),
  `zms_bz` VARCHAR(500),
  `wsb_yylx` VARCHAR(100),
  `wsb_yysm` VARCHAR(500)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='长期未申报退税业务会员企业数据导入';

-- Creating table TMP_SB_CKTMSYWLX
CREATE TABLE `TMP_SB_CKTMSYWLX` (
  `cktmsywlxdmjh` VARCHAR(30),
  `sbcs` DECIMAL(10,0),
  KEY `IDX_TMP_SB_CKTMSYWLX` (`CKTMSYWLXDMJH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_SWJG_NDTJ
CREATE TABLE `TMP_SWJG_NDTJ` (
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `swjg_mc` VARCHAR(80) NOT NULL COMMENT '税务机关名称',
  `sbhs_all` DECIMAL(18,0) COMMENT '申报户数',
  `sbhs_sc` DECIMAL(18,0) COMMENT '申报户数',
  `sbhs_wm` DECIMAL(18,0) COMMENT '申报户数',
  `sbhs_xse` DECIMAL(18,0) COMMENT '申报户数',
  `sbhs_bgd` DECIMAL(18,0) COMMENT '申报户数',
  `mylaj_all` DECIMAL(18,6) COMMENT '美元离岸价',
  `mylaj_sc` DECIMAL(18,6) COMMENT '美元离岸价',
  `mylaj_wm` DECIMAL(18,6) COMMENT '美元离岸价',
  `tmse_all` DECIMAL(18,6) COMMENT '退免税额',
  `tmse_sc` DECIMAL(18,6) COMMENT '退免税额',
  `tmse_wm` DECIMAL(18,6) COMMENT '退免税额'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_TJBB_DT_B03104
-- Original Oracle primary-key constraint: PK_TMP_TJBB_DT_B03104 (MySQL index name: PRIMARY).
CREATE TABLE `TMP_TJBB_DT_B03104` (
  `ssny` VARCHAR(6) NOT NULL,
  `bblc` VARCHAR(10) NOT NULL,
  `swjgdm` VARCHAR(32) NOT NULL,
  `spdldm` VARCHAR(16) COMMENT '商品大类代码',
  `spdl` VARCHAR(16) COMMENT '商品大类',
  `spmc` VARCHAR(400),
  `usd_year` DECIMAL(16,4) COMMENT '出口额',
  `tse_year` DECIMAL(16,4) COMMENT '退税额',
  `mde_year` DECIMAL(16,4) COMMENT '退税额',
  `usd_year_last` DECIMAL(16,4) COMMENT '出口额上年',
  `tse_year_last` DECIMAL(16,4) COMMENT '退税额上年',
  `mde_year_last` DECIMAL(16,4) COMMENT '退税额上年',
  `usd_tb` DECIMAL(16,4) COMMENT '同比',
  `usd_zb` DECIMAL(16,4) COMMENT '比重',
  `tse_tb` DECIMAL(16,4) COMMENT '同比',
  `tse_zb` DECIMAL(16,4) COMMENT '比重',
  `mde_tb` DECIMAL(16,4) COMMENT '同比',
  `mde_zb` DECIMAL(16,4) COMMENT '比重',
  CONSTRAINT `PK_TMP_TJBB_DT_B03104` PRIMARY KEY (`SSNY`, `BBLC`, `SWJGDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_TJBB_FHXX_CMCODE
CREATE TABLE `TMP_TJBB_FHXX_CMCODE` (
  `ssny` VARCHAR(6) NOT NULL,
  `swcode` VARCHAR(32) NOT NULL,
  `xmfl` VARCHAR(10) NOT NULL,
  `sbywbdm` VARCHAR(10) NOT NULL,
  `usd_amt_all` DECIMAL(16,4),
  `rmb_amt_all` DECIMAL(16,4),
  `ts_amt_all` DECIMAL(16,4),
  `md_amt_all` DECIMAL(16,4),
  `usd_amt_usa` DECIMAL(16,4),
  `rmb_amt_usa` DECIMAL(16,4),
  `ts_amt_usa` DECIMAL(16,4),
  `md_amt_usa` DECIMAL(16,4),
  KEY `IDX_TMP_TJBB_FHXX_CMCODE_SXX` (`SWCODE`, `SSNY`, `XMFL`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_TSLTZ_20241117
-- TMP_TSLTZ_20241117.xh: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
CREATE TABLE `TMP_TSLTZ_20241117` (
  `xh` DECIMAL(65,27),
  `spdm` VARCHAR(20),
  `spmc` VARCHAR(1000),
  `tzlx` CHAR(1)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_TSLTZ_20260113
-- TMP_TSLTZ_20260113.xh: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
CREATE TABLE `TMP_TSLTZ_20260113` (
  `xh` DECIMAL(65,27),
  `spdm` VARCHAR(20),
  `spmc` VARCHAR(2000),
  `tzlx` CHAR(1),
  KEY `IDX_TMP_TSLTZ_20260113` (`SPDM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_TSLTZ_20260113_1
CREATE TABLE `TMP_TSLTZ_20260113_1` (
  `tzlx` CHAR(1) COMMENT '调整类型',
  `spdm` VARCHAR(20) COMMENT '商品代码',
  `sjly` CHAR(1) COMMENT '数据来源',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ckbgdh` VARCHAR(21),
  `ckrq_1` DATETIME,
  `ckyear` VARCHAR(4) COMMENT '出口年份',
  `mylaj` DECIMAL(18,2) COMMENT '出口销售（美元）',
  `tmse` DECIMAL(18,2) COMMENT '申报退免税额'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_TSLTZ_20260113_2
CREATE TABLE `TMP_TSLTZ_20260113_2` (
  `tzlx` CHAR(1) COMMENT '调整类型',
  `spdm` VARCHAR(20) COMMENT '商品代码',
  `sjly` CHAR(1) COMMENT '数据来源',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ckyear` VARCHAR(4) COMMENT '出口年份',
  `bgdfs` DECIMAL(10,0) COMMENT '报关单份数',
  `hwmxts` DECIMAL(10,0) COMMENT '货物明细条数',
  `mylaj` DECIMAL(18,2) COMMENT '出口销售（美元）',
  `tmse` DECIMAL(18,2) COMMENT '申报退免税额'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_TSLTZ_20260113_3
CREATE TABLE `TMP_TSLTZ_20260113_3` (
  `tzlx` CHAR(1) COMMENT '调整类型',
  `spdm` VARCHAR(20) COMMENT '商品代码',
  `sjly` CHAR(1) COMMENT '数据来源',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ckbgdh` VARCHAR(21),
  `ckrq_1` DATETIME,
  `ckyear` VARCHAR(4) COMMENT '出口年份',
  `mylaj` DECIMAL(18,2) COMMENT '出口销售（美元）',
  `rmblaj` DECIMAL(18,2) COMMENT '出口销售（人民币）',
  `zzmdgdqsz_dm` CHAR(3)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_TSLTZ_20260113_4
CREATE TABLE `TMP_TSLTZ_20260113_4` (
  `tzlx` CHAR(1) COMMENT '调整类型',
  `spdm` VARCHAR(20) COMMENT '商品代码',
  `sjly` CHAR(1) COMMENT '数据来源',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ckyear` VARCHAR(4) COMMENT '出口年份',
  `bgdfs` DECIMAL(10,0) COMMENT '报关单份数',
  `hwmxts` DECIMAL(10,0) COMMENT '货物明细条数',
  `mylaj` DECIMAL(18,2) COMMENT '出口销售（美元）',
  `rmblaj` DECIMAL(18,2) COMMENT '出口销售（人民币）',
  `zzmdgdqsz_dm` CHAR(3)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_TSLTZ_20260113_5
CREATE TABLE `TMP_TSLTZ_20260113_5` (
  `tzlx` CHAR(1) COMMENT '调整类型',
  `spdm` VARCHAR(20) COMMENT '商品代码',
  `sjly` CHAR(1) COMMENT '数据来源',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `ckbgdh` VARCHAR(21),
  `sbrq` DATETIME,
  `sbyear` VARCHAR(4) COMMENT '申报年份',
  `mylaj` DECIMAL(18,2) COMMENT '出口销售（美元）',
  `tmse` DECIMAL(18,2) COMMENT '申报退免税额'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_TSLTZ_20260113_6
CREATE TABLE `TMP_TSLTZ_20260113_6` (
  `tzlx` CHAR(1) COMMENT '调整类型',
  `spdm` VARCHAR(20) COMMENT '商品代码',
  `sjly` CHAR(1) COMMENT '数据来源',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `sbyear` VARCHAR(4) COMMENT '申报年份',
  `bgdfs` DECIMAL(10,0) COMMENT '报关单份数',
  `hwmxts` DECIMAL(10,0) COMMENT '货物明细条数',
  `mylaj` DECIMAL(18,2) COMMENT '出口销售（美元）',
  `tmse` DECIMAL(18,2) COMMENT '申报退免税额'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_WLYCFX_XZQHDM
CREATE TABLE `TMP_WLYCFX_XZQHDM` (
  `ckka_dm` VARCHAR(4) COMMENT '出口口岸代码',
  `ckka_mc` VARCHAR(80) COMMENT '出口口岸名称',
  `ghsf_dm` VARCHAR(4) COMMENT '供货省份代码',
  `ghsf_mc` VARCHAR(80) COMMENT '供货省份名称',
  `dlqy_dm` VARCHAR(4) COMMENT '地理区域代码',
  `dlqy_mc` VARCHAR(80) COMMENT '地理区域名称',
  KEY `IDX_TMP_WLYCFX_XZQHDM_CKKA` (`CKKA_DM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_WMQYCKWL_20260603
CREATE TABLE `TMP_WMQYCKWL_20260603` (
  `lcslid` CHAR(32) COMMENT '分流LCSLID',
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `glh` VARCHAR(30) COMMENT '关联号',
  `ghfnsrsbh_1` VARCHAR(20) COMMENT '供货方纳税人识别号',
  `jhpzh` VARCHAR(75) COMMENT '进货凭证号/专用税票号',
  `jsje` DECIMAL(18,2) COMMENT '计税金额',
  `mylaj` DECIMAL(18,2) COMMENT '美元离岸价',
  `cksp_dm` VARCHAR(20) COMMENT '出口商品代码',
  `ysfs_dm` VARCHAR(1),
  `zzmdgdqsz_dm` VARCHAR(3),
  `hggqka_dm` VARCHAR(4),
  `qysdqdm` VARCHAR(4)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_WZEFJ_CKTS_LC_SEHZXX
CREATE TABLE `TMP_WZEFJ_CKTS_LC_SEHZXX` (
  `uuid` VARCHAR(32),
  `cktmsjhssswjgdm` CHAR(11),
  `djxh` DECIMAL(20,0),
  `cktmsjhssswjgdm_new` CHAR(11)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='二分局_税额核准信息';

-- Creating table TMP_WZEFJ_CKTS_LC_SEHZXX_MD
CREATE TABLE `TMP_WZEFJ_CKTS_LC_SEHZXX_MD` (
  `uuid` VARCHAR(32),
  `mdtkssswjgdm` CHAR(11),
  `djxh` DECIMAL(20,0),
  `mdtkssswjgdm_new` CHAR(11)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='二分局_税额核准信息';

-- Creating table TMP_WZEFJ_CKTS_LC_SHXX
CREATE TABLE `TMP_WZEFJ_CKTS_LC_SHXX` (
  `uuid` VARCHAR(32),
  `tsswjg_dm` CHAR(11),
  `djxh` DECIMAL(20,0),
  `tsswjg_new` CHAR(11)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='二分局_流程审核信息';

-- Creating table TMP_WZEFJ_FG_CKTSFN_HXZG
CREATE TABLE `TMP_WZEFJ_FG_CKTSFN_HXZG` (
  `spuuid` VARCHAR(32),
  `skssswjg_dm` VARCHAR(11),
  `djxh` DECIMAL(20,0),
  `skssswjg_new` VARCHAR(11)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='二分局_出口退税返纳';

-- Creating table TMP_WZEFJ_GLXT_BB_SHXT_DJXX
CREATE TABLE `TMP_WZEFJ_GLXT_BB_SHXT_DJXX` (
  `swjgdm` VARCHAR(11),
  `cpcode` VARCHAR(32),
  `swjgdm_new` VARCHAR(11)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='二分局_出口企业档案表';

-- Creating table TMP_XSSWJ_CKLLFX
CREATE TABLE `TMP_XSSWJ_CKLLFX` (
  `tsswjg_dm_1` VARCHAR(11) COMMENT '税务机关',
  `ysfs_dm` VARCHAR(1) COMMENT '运输方式',
  `spdl_dm` VARCHAR(2) COMMENT '商品大类',
  `qycode_hyd` VARCHAR(5) COMMENT '供应商地区',
  `qycode_hg` VARCHAR(4) COMMENT '离境口岸',
  `qycode_mdg` VARCHAR(3) COMMENT '目的国（洲）',
  `qyhs_all` DECIMAL(10,0) COMMENT '企业户数',
  `qyzb_all` DECIMAL(10,6) COMMENT '企业占比（%）',
  `bgdfs_all` DECIMAL(10,0) COMMENT '报关单份数',
  `bgdzb_all` DECIMAL(10,6) COMMENT '报关单占比（%）',
  `mylaj_all` DECIMAL(18,2) COMMENT '美元离岸价',
  `myzb_all` DECIMAL(10,6) COMMENT '美元占比（%）',
  `qyhs_sx` DECIMAL(10,0) COMMENT '（预留字段，按预警口径筛选）企业户数',
  `qyzb_sx` DECIMAL(10,6) COMMENT '（预留字段，按预警口径筛选）企业占比（%）',
  `bgdfs_sx` DECIMAL(10,0) COMMENT '（预留字段，按预警口径筛选）报关单份数',
  `bgdzb_sx` DECIMAL(10,6) COMMENT '（预留字段，按预警口径筛选）报关单占比（%）',
  `mylaj_sx` DECIMAL(18,2) COMMENT '（预留字段，按预警口径筛选）美元离岸价',
  `myzb_sx` DECIMAL(10,6) COMMENT '（预留字段，按预警口径筛选）美元占比（%）',
  `fxdj_zhfxzs` DECIMAL(10,6) COMMENT '综合风险指数，根据前面各项占比综合计算',
  `fxdj_dm` CHAR(1) COMMENT '风险等级指标'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='出口链路分析-历史数据统计表';

-- Creating table TMP_YCTS_ZZSFP
-- TMP_YCTS_ZZSFP.kpyf: unspecified Oracle NUMBER mapped to DECIMAL(65,27); see range note above.
-- Original Oracle primary-key constraint: PK_TMP_YCTS_ZZSFP (MySQL index name: PRIMARY).
CREATE TABLE `TMP_YCTS_ZZSFP` (
  `fpdmhm` VARCHAR(30) NOT NULL,
  `fpdm` VARCHAR(20),
  `fphm` VARCHAR(10),
  `kprq` DATETIME(6),
  `fpzt_bz` VARCHAR(1),
  `xfsbh` VARCHAR(26),
  `gfsbh` VARCHAR(64),
  `je` DECIMAL(18,2),
  `se` DECIMAL(18,2),
  `jshj` DECIMAL(18,2),
  `fpzt_dm` VARCHAR(2),
  `kpyf` DECIMAL(65,27),
  `bytsbz` CHAR(1),
  `byblbz` CHAR(1),
  `lcslid` CHAR(32),
  `uuid` VARCHAR(32) NOT NULL,
  `djxh` DECIMAL(20,0),
  `sbxh` VARCHAR(50),
  `glh` VARCHAR(30),
  `sjly` VARCHAR(100),
  `bdly` VARCHAR(100) NOT NULL,
  `ssq` VARCHAR(60),
  `sbpc` VARCHAR(75),
  `yfpdmhm` VARCHAR(30),
  `bz` VARCHAR(1000),
  `hzcjbz` CHAR(1),
  CONSTRAINT `PK_TMP_YCTS_ZZSFP` PRIMARY KEY (`UUID`, `BDLY`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TMP_ZXZB_2026062
CREATE TABLE `TMP_ZXZB_2026062` (
  `nsrsbh` VARCHAR(20) COMMENT '税号',
  `smjg` VARCHAR(300) COMMENT '扫描结果描述',
  `hsrq` DATETIME COMMENT '核实日期',
  `hsry` VARCHAR(200) COMMENT '核实人员',
  `hsclqk` VARCHAR(2000) COMMENT '核实处理情况'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TSGZ_DATA
CREATE TABLE `TSGZ_DATA` (
  `swjg_dm` VARCHAR(11) NOT NULL,
  `area` CHAR(1) NOT NULL,
  `screen_level` CHAR(1) NOT NULL,
  `table_seq` DECIMAL(38,0) NOT NULL DEFAULT 0,
  `content` LONGTEXT,
  `uptime` DATETIME NOT NULL,
  `remark` VARCHAR(100),
  UNIQUE (`SWJG_DM`, `AREA`, `SCREEN_LEVEL`, `TABLE_SEQ`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table TSGZ_DATA_HISTORY
CREATE TABLE `TSGZ_DATA_HISTORY` (
  `data_date` VARCHAR(6) NOT NULL COMMENT '数据统计日期',
  `swjg_dm` VARCHAR(11) NOT NULL COMMENT '税务机关代码',
  `area` CHAR(1) NOT NULL COMMENT '区域：A、B、C、D、E、F',
  `screen_level` CHAR(1) NOT NULL COMMENT '屏幕层级：1-首页大屏、2-子屏',
  `table_seq` DECIMAL(38,0) NOT NULL DEFAULT 0 COMMENT '表格序列号，预留字段，防止某个区域下数据量太大，可以按照区域内表格分开存储',
  `content` LONGTEXT COMMENT '数据内容',
  `uptime` DATETIME NOT NULL COMMENT '更新时间',
  `remark` VARCHAR(100) COMMENT '备注',
  UNIQUE (`DATA_DATE`, `SWJG_DM`, `AREA`, `SCREEN_LEVEL`, `TABLE_SEQ`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='态势感知_数据_历史表';

-- Creating table WSSB_CKTS_MDTKB
-- Original Oracle primary-key constraint: PK_CKTS_MDTKB (MySQL index name: PRIMARY).
CREATE TABLE `WSSB_CKTS_MDTKB` (
  `ms_id` DECIMAL(38,0) NOT NULL,
  `item_no` VARCHAR(2) NOT NULL,
  `hgqydm` VARCHAR(10),
  `nsrmc` VARCHAR(80),
  `nsrsbh` VARCHAR(20),
  `tktk_mdse_sps` DECIMAL(16,2),
  `nsr_swjg_dm` VARCHAR(11),
  `swdjblx_dm` CHAR(1),
  `skgk_dm` VARCHAR(20),
  `gly_dm` VARCHAR(20),
  `res_2` VARCHAR(500) NOT NULL,
  `op_date` DATETIME,
  `sb_ym` VARCHAR(6),
  `dzbh` VARCHAR(20),
  `kjrq` DATETIME,
  `xhrq` DATETIME,
  `tk_flag` CHAR(1) NOT NULL DEFAULT '0',
  `tbyycode` VARCHAR(20) DEFAULT '110',
  CONSTRAINT `PK_CKTS_MDTKB` PRIMARY KEY (`MS_ID`, `ITEM_NO`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table WSSB_CKTS_TSTHS
-- Original Oracle primary-key constraint: PK_CKTS_TSTHS (MySQL index name: PRIMARY).
CREATE TABLE `WSSB_CKTS_TSTHS` (
  `no` VARCHAR(18) NOT NULL,
  `hgqydm` VARCHAR(10),
  `nsrmc` VARCHAR(80),
  `nsrsbh` VARCHAR(20),
  `tktk_ytse_sps` DECIMAL(18,2),
  `tktk_mdse_sps` DECIMAL(18,2),
  `qylx_dm` CHAR(1),
  `nsr_swjg_dm` VARCHAR(11),
  `swdjblx_dm` CHAR(1),
  `skgk_dm` VARCHAR(20),
  `sb_ym` VARCHAR(6),
  `gly_dm` VARCHAR(20),
  `res_2` VARCHAR(500),
  `ttxh` VARCHAR(20),
  `kjrq` DATETIME,
  `xhrq` DATETIME,
  `tk_flag` CHAR(1) NOT NULL DEFAULT '0',
  `op_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `zsxm_dm` VARCHAR(2) NOT NULL DEFAULT '01',
  `tbyycode` VARCHAR(20) DEFAULT '110',
  CONSTRAINT `PK_CKTS_TSTHS` PRIMARY KEY (`NO`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table YJ_BGDGZXX_JGB
-- Original Oracle primary-key constraint: PK_YJ_BGDGZXX_JGB (MySQL index name: PRIMARY).
CREATE TABLE `YJ_BGDGZXX_JGB` (
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '金三企业登记序号',
  `ckbgdh` VARCHAR(21) NOT NULL COMMENT '出口报关单号（21位）/代理证明号（20位）',
  `gzxx` VARCHAR(1000) COMMENT '关注信息',
  `czr_dm` VARCHAR(15) NOT NULL COMMENT '最后一次操作人员代码，系统自动记录',
  `czrq` DATETIME NOT NULL COMMENT '最后一次操作日期，系统自动记录',
  CONSTRAINT `PK_YJ_BGDGZXX_JGB` PRIMARY KEY (`DJXH`, `CKBGDH`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='报关单关注信息表';

-- Creating table YWY_BAXX_GCB
-- Original Oracle primary-key constraint: PK_YWY_BAXX_GCB (MySQL index name: PRIMARY).
CREATE TABLE `YWY_BAXX_GCB` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键序号',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '登记序号',
  `zjlx` VARCHAR(3) NOT NULL DEFAULT '201' COMMENT '证件类型  201居民身份证 208护照 210港澳通行证 213 台湾通行证',
  `zjhm` VARCHAR(30) NOT NULL COMMENT '证件号码',
  `xm` VARCHAR(40) NOT NULL COMMENT '姓名',
  `sex` CHAR(1) NOT NULL COMMENT '性别    1男   2女',
  `phone` VARCHAR(20) COMMENT '手机',
  `status` CHAR(1) NOT NULL DEFAULT '1' COMMENT '业务员状态   1在职  0离职',
  `gzrq_q` DATETIME COMMENT '工作日期起',
  `gzrq_z` DATETIME COMMENT '工作日期止',
  `ckcpfw` VARCHAR(1000) COMMENT '出口产品范围',
  `sfqdldht` CHAR(1) NOT NULL COMMENT '是否签订劳动合同   Y是  N 否',
  `sfdjsb` CHAR(1) NOT NULL COMMENT '是否代缴社保  Y是  N 否',
  `ywyly` CHAR(1) NOT NULL COMMENT '业务员来源   1他人介绍    2招聘   3企业法人/投资方/实际管理人   4其他',
  `qtlyms` VARCHAR(100) COMMENT '其他来源描述',
  `zj_hash` VARCHAR(40) COMMENT '证件照片-哈希值',
  `zfbz` CHAR(1) NOT NULL COMMENT '作废标志   Y已作废，N未作废',
  `zfsj` DATETIME COMMENT '作废时间',
  `cr_time` DATETIME COMMENT '创建时间',
  `up_time` DATETIME COMMENT '修改时间',
  `qrbz` CHAR(1) NOT NULL DEFAULT '0' COMMENT '需确认标记  0无需确认  1需税务端确认',
  `bazt` CHAR(1) NOT NULL DEFAULT '0' COMMENT '备案状态  0未备案   1备案中（税务端待确认） 2已备案（税务端已确认）3备案退回',
  `tjsj` DATETIME COMMENT '提交时间',
  `basj` DATETIME COMMENT '备案时间',
  `thsj` DATETIME COMMENT '退回时间',
  `thyy` VARCHAR(200) COMMENT '退回原因',
  `qrr_dm` VARCHAR(20) COMMENT '确认人代码',
  `qrsj` DATETIME COMMENT '确认时间',
  KEY `IDX_YWY_BAXX_GCB_DJXH` (`DJXH`),
  KEY `IDX_YWY_BAXX_GCB_ZJHM` (`ZJHM`),
  CONSTRAINT `PK_YWY_BAXX_GCB` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='业务员备案信息表';

-- Creating table YWY_BAXX_IMPORT
CREATE TABLE `YWY_BAXX_IMPORT` (
  `id` DECIMAL(10,0) NOT NULL,
  `djxh` DECIMAL(20,0),
  `qyhgdm` VARCHAR(32),
  `nsrsbh` VARCHAR(20),
  `nsrmc` VARCHAR(100),
  `xm` VARCHAR(40),
  `zjhm` VARCHAR(30),
  `phone` VARCHAR(20),
  `gzrq_q` DATETIME,
  `sfqdldht` CHAR(1),
  `sfdjsb` CHAR(1),
  `status` CHAR(1),
  `basj` DATETIME,
  `up_time` DATETIME,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table YWY_BAXX_JGB
-- Original Oracle primary-key constraint: PK_YWY_BAXX_JGB (MySQL index name: PRIMARY).
CREATE TABLE `YWY_BAXX_JGB` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键序号',
  `djxh` DECIMAL(20,0) NOT NULL COMMENT '纳税人电子档案号',
  `zjlx` VARCHAR(3) NOT NULL DEFAULT '201' COMMENT '证件类型  201居民身份证 208护照 210港澳通行证 213 台湾通行证',
  `zjhm` VARCHAR(30) NOT NULL COMMENT '证件号码',
  `xm` VARCHAR(40) NOT NULL COMMENT '姓名',
  `sex` CHAR(1) NOT NULL COMMENT '性别    1男   2女',
  `phone` VARCHAR(20) COMMENT '手机',
  `status` CHAR(1) NOT NULL DEFAULT '1' COMMENT '业务员状态   1在职  0离职',
  `gzrq_q` DATETIME COMMENT '工作日期起',
  `gzrq_z` DATETIME COMMENT '工作日期止',
  `ckcpfw` VARCHAR(1000) COMMENT '出口产品范围',
  `sfqdldht` CHAR(1) NOT NULL COMMENT '是否签订劳动合同   Y是  N 否',
  `sfdjsb` CHAR(1) NOT NULL COMMENT '是否代缴社保  Y是  N 否',
  `ywyly` CHAR(1) NOT NULL COMMENT '业务员来源   1他人介绍    2招聘   3企业法人/投资方/实际管理人   4其他',
  `qtlyms` VARCHAR(100) COMMENT '其他来源描述',
  `zj_hash` VARCHAR(40) COMMENT '证件照片-哈希值',
  `zfbz` CHAR(1) NOT NULL COMMENT '作废标志   Y已作废，N未作废',
  `zfsj` DATETIME COMMENT '作废时间',
  `cr_time` DATETIME COMMENT '创建时间',
  `up_time` DATETIME COMMENT '修改时间',
  `qrbz` CHAR(1) NOT NULL DEFAULT '0' COMMENT '需确认标记  0无需确认  1需税务端确认',
  `bazt` CHAR(1) NOT NULL DEFAULT '0' COMMENT '备案状态  0未备案   1备案中（税务端待确认） 2已备案（税务端已确认）3备案退回',
  `tjsj` DATETIME COMMENT '提交时间',
  `basj` DATETIME COMMENT '备案时间',
  `thsj` DATETIME COMMENT '退回时间',
  `thyy` VARCHAR(200) COMMENT '退回原因',
  `qrr_dm` VARCHAR(20) COMMENT '确认人代码',
  `qrsj` DATETIME COMMENT '确认时间',
  KEY `IDX_YWY_BAXX_JGB_DJXH` (`DJXH`),
  KEY `IDX_YWY_BAXX_JGB_ZJHM` (`ZJHM`),
  CONSTRAINT `PK_YWY_BAXX_JGB` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='业务员备案信息表结果表';

-- Creating table YWY_BAXX_LSB
-- Original Oracle primary-key constraint: PK_YWY_BAXX_LSB (MySQL index name: PRIMARY).
CREATE TABLE `YWY_BAXX_LSB` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '主键序号',
  `ywy_id` DECIMAL(20,0),
  `djxh` DECIMAL(20,0) COMMENT '登记序号',
  `zjlx` VARCHAR(3) COMMENT '证件类型  201居民身份证 208护照 210港澳通行证 213 台湾通行证',
  `zjhm` VARCHAR(30) COMMENT '证件号码',
  `xm` VARCHAR(40) COMMENT '姓名',
  `sex` CHAR(1) COMMENT '性别    1男   2女',
  `phone` VARCHAR(20) COMMENT '手机',
  `status` CHAR(1) COMMENT '业务员状态   1在职  0离职',
  `gzrq_q` DATETIME COMMENT '工作日期起',
  `gzrq_z` DATETIME COMMENT '工作日期止',
  `ckcpfw` VARCHAR(1000) COMMENT '出口产品范围',
  `sfqdldht` CHAR(1) COMMENT '是否签订劳动合同   Y是  N 否',
  `sfdjsb` CHAR(1) COMMENT '是否代缴社保  Y是  N 否',
  `ywyly` CHAR(1) COMMENT '业务员来源   1他人介绍    2招聘   3企业法人/投资方/实际管理人   4其他',
  `qtlyms` VARCHAR(100) COMMENT '其他来源描述',
  `zj_hash` VARCHAR(40) COMMENT '证件照片-哈希值',
  `zfbz` CHAR(1) COMMENT '作废标志   Y已作废，N未作废',
  `zfsj` DATETIME COMMENT '作废时间',
  `cr_time` DATETIME COMMENT '创建时间',
  `up_time` DATETIME COMMENT '修改时间',
  `qrbz` CHAR(1) COMMENT '需确认标记  0无需确认  1需税务端确认',
  `bazt` CHAR(1) COMMENT '备案状态  0未备案   1备案中（税务端待确认） 2已备案（税务端已确认）3备案退回',
  `tjsj` DATETIME COMMENT '提交时间',
  `basj` DATETIME COMMENT '备案时间',
  `thsj` DATETIME COMMENT '退回时间',
  `thyy` VARCHAR(200) COMMENT '退回原因',
  `qrr_dm` VARCHAR(20) COMMENT '确认人代码',
  `qrsj` DATETIME COMMENT '确认时间',
  CONSTRAINT `PK_YWY_BAXX_LSB` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='业务员备案历史信息表';

-- Creating table YWY_BAXX_SFZJ
CREATE TABLE `YWY_BAXX_SFZJ` (
  `ywy_id` DECIMAL(20,0) NOT NULL,
  `txgs` VARCHAR(10),
  `up_time` DATETIME,
  `sfzjnr` LONGBLOB,
  PRIMARY KEY (`YWY_ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin;

-- Creating table YWY_FXMC
-- Original Oracle primary-key constraint: PK_YWY_FXMC (MySQL index name: PRIMARY).
CREATE TABLE `YWY_FXMC` (
  `id` DECIMAL(20,0) NOT NULL COMMENT '序号（主键）',
  `swjg_dm` VARCHAR(11) COMMENT '录入税务机关',
  `zjhm` VARCHAR(30) COMMENT '证件号码',
  `xm` VARCHAR(50) COMMENT '姓名',
  `fxlx` CHAR(1) COMMENT '风险类型   1 骗税、2 违规退税、3 出口风险商品、4 其他',
  `fxqkms` VARCHAR(4000) COMMENT '风险情况描述',
  `lrr_dm` VARCHAR(20) COMMENT '录入人代码',
  `lrsj` DATETIME COMMENT '录入时间',
  `yxbz` CHAR(1) COMMENT '有效标志     Y/N',
  KEY `IDX_YWY_FXMC` (`ZJHM`),
  CONSTRAINT `PK_YWY_FXMC` PRIMARY KEY (`ID`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='风险业务员名册';

-- Creating table YWY_TJGXXX
-- Original Oracle primary-key constraint: PK_YWY_TJGXXX (MySQL index name: PRIMARY).
CREATE TABLE `YWY_TJGXXX` (
  `zjhm` VARCHAR(30) NOT NULL COMMENT '证件号码',
  `sjqyhs` DECIMAL(38,0) NOT NULL COMMENT '涉及企业户数',
  `tjsj` DATETIME COMMENT '统计时间',
  CONSTRAINT `PK_YWY_TJGXXX` PRIMARY KEY (`ZJHM`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_bin COMMENT='业务员统计共享信息表';

SET SESSION sql_mode = @yiziemei_mysql8_saved_sql_mode;
SET @yiziemei_mysql8_saved_sql_mode = NULL;
