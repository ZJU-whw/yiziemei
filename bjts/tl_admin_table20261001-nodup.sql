prompt
prompt Creating table CS_SH_FZTSGWRY
prompt =============================
prompt
create table CS_SH_FZTSGWRY
(
  swjg_dm VARCHAR2(11) not null,
  qyhgdm  VARCHAR2(32) not null,
  nsrmc   VARCHAR2(100) not null,
  slg     VARCHAR2(20),
  shg     VARCHAR2(20),
  fhg     VARCHAR2(20),
  hzg     VARCHAR2(20),
  ffg     VARCHAR2(20),
  flag    CHAR(1),
  lrsj    DATE,
  bgsj    DATE,
  cpcode  VARCHAR2(32),
  note    VARCHAR2(255),
  id      NUMBER(18) not null
)
;
comment on table CS_SH_FZTSGWRY
  is '分组推送岗位人员参数表';
comment on column CS_SH_FZTSGWRY.swjg_dm
  is '税务机关代码';
comment on column CS_SH_FZTSGWRY.qyhgdm
  is '企业海关代码';
comment on column CS_SH_FZTSGWRY.nsrmc
  is '纳税人名称';
comment on column CS_SH_FZTSGWRY.slg
  is '受理岗';
comment on column CS_SH_FZTSGWRY.shg
  is '审核岗';
comment on column CS_SH_FZTSGWRY.fhg
  is '复审岗';
comment on column CS_SH_FZTSGWRY.hzg
  is '核准岗';
comment on column CS_SH_FZTSGWRY.ffg
  is '发放岗';
comment on column CS_SH_FZTSGWRY.flag
  is '校验标志 空：尚未校验 Y通过 N校验不通过';
comment on column CS_SH_FZTSGWRY.lrsj
  is '录入时间';
comment on column CS_SH_FZTSGWRY.bgsj
  is '更新时间';
comment on column CS_SH_FZTSGWRY.cpcode
  is 'cpcode';
comment on column CS_SH_FZTSGWRY.note
  is '校验信息';
comment on column CS_SH_FZTSGWRY.id
  is '主键id';
create index IDX_CS_SH_FZTSGWRY on CS_SH_FZTSGWRY (SWJG_DM, QYHGDM);
alter table CS_SH_FZTSGWRY
  add constraint PK_CS_SH_FZTSGWRY_ID primary key (ID);

prompt
prompt Creating table CS_SH_SJTSGWRY
prompt =============================
prompt
create table CS_SH_SJTSGWRY
(
  swjg_dm VARCHAR2(11) not null,
  shgwdm  VARCHAR2(20) not null,
  user_id VARCHAR2(32) not null,
  lrrq    DATE
)
;
comment on table CS_SH_SJTSGWRY
  is '随机接单岗位人员参数表';
comment on column CS_SH_SJTSGWRY.swjg_dm
  is '税务机关代码';
comment on column CS_SH_SJTSGWRY.shgwdm
  is '岗位代码--关联DM_SH_GW表';
comment on column CS_SH_SJTSGWRY.user_id
  is '操作员代码';
comment on column CS_SH_SJTSGWRY.lrrq
  is '录入时间';
alter table CS_SH_SJTSGWRY
  add primary key (SWJG_DM, SHGWDM, USER_ID);

prompt
prompt Creating table CS_SH_YDTSGW
prompt ===========================
prompt
create table CS_SH_YDTSGW
(
  swjg_dm VARCHAR2(11) not null,
  bktgyd  VARCHAR2(20),
  ktgyd   VARCHAR2(20),
  wyd     VARCHAR2(20),
  lsb     VARCHAR2(20)
)
;
comment on table CS_SH_YDTSGW
  is '疑点推送岗位参数表';
comment on column CS_SH_YDTSGW.swjg_dm
  is '税务机关代码';
comment on column CS_SH_YDTSGW.bktgyd
  is '不可挑过疑点';
comment on column CS_SH_YDTSGW.ktgyd
  is '可挑过疑点';
comment on column CS_SH_YDTSGW.wyd
  is '无疑点';
comment on column CS_SH_YDTSGW.lsb
  is '零申报';
alter table CS_SH_YDTSGW
  add primary key (SWJG_DM);

prompt
prompt Creating table CZ_LOG
prompt =====================
prompt
create table CZ_LOG
(
  id     NUMBER not null,
  lcslid VARCHAR2(50),
  code   VARCHAR2(100),
  sbyy   VARCHAR2(2000),
  cjsj   DATE default sysdate
)
;

prompt
prompt Creating table DCB_NSR_YSBQC
prompt ============================
prompt
create table DCB_NSR_YSBQC
(
  nsrdzdah  NUMBER(20) not null,
  qxlx      CHAR(2) not null,
  qybj      CHAR(1),
  crtime    DATE,
  tsjsfs_dm CHAR(1),
  zdhbz     CHAR(1)
)
;
comment on table DCB_NSR_YSBQC
  is '调查表-纳税人应申报清册';
comment on column DCB_NSR_YSBQC.qxlx
  is '权限类型(01:东阳退税指标测算)';
comment on column DCB_NSR_YSBQC.qybj
  is '启用标记';
comment on column DCB_NSR_YSBQC.crtime
  is '创建时间';
alter table DCB_NSR_YSBQC
  add constraint PK_DCB_NSR_YSBQC primary key (NSRDZDAH, QXLX);

prompt
prompt Creating table DCB_TSYCBFSLQK_LOG
prompt =================================
prompt
create table DCB_TSYCBFSLQK_LOG
(
  id        NUMBER(18) not null,
  nsrdzdah  NUMBER(20) not null,
  ny        CHAR(6) not null,
  yctse     NUMBER(16,2),
  sbywb_dm  VARCHAR2(50) not null,
  sbnypc    VARCHAR2(10),
  sbtse     NUMBER(16,2),
  dyljsbtse NUMBER(16,2),
  cldz      CHAR(1),
  yysm      VARCHAR2(200),
  czymc     VARCHAR2(50),
  crtime    DATE
)
;
comment on table DCB_TSYCBFSLQK_LOG
  is '调查表_退税预测不符受理情况_日志';
comment on column DCB_TSYCBFSLQK_LOG.id
  is '自增主键';
comment on column DCB_TSYCBFSLQK_LOG.nsrdzdah
  is '纳税人电子档案号';
comment on column DCB_TSYCBFSLQK_LOG.ny
  is '年月，接单时的系统年月';
comment on column DCB_TSYCBFSLQK_LOG.yctse
  is '预测退税额';
comment on column DCB_TSYCBFSLQK_LOG.sbywb_dm
  is '申报业务表代码';
comment on column DCB_TSYCBFSLQK_LOG.sbnypc
  is '申报年月批次';
comment on column DCB_TSYCBFSLQK_LOG.sbtse
  is '申报退税额';
comment on column DCB_TSYCBFSLQK_LOG.dyljsbtse
  is '当月累计申报退税额';
comment on column DCB_TSYCBFSLQK_LOG.cldz
  is '处理动作';
comment on column DCB_TSYCBFSLQK_LOG.yysm
  is '原因说明';
comment on column DCB_TSYCBFSLQK_LOG.czymc
  is '操作员名称';
comment on column DCB_TSYCBFSLQK_LOG.crtime
  is '创建时间';
create index INX_DCB_TSYCBFSLQK_LOG on DCB_TSYCBFSLQK_LOG (NSRDZDAH, NY);
alter table DCB_TSYCBFSLQK_LOG
  add constraint PRI_DCB_TSYCBFSLQK_LOG primary key (ID);

prompt
prompt Creating table DCB_TSZBCS_DDBDCKXQ
prompt ==================================
prompt
create table DCB_TSZBCS_DDBDCKXQ
(
  id          NUMBER(18) not null,
  nsrdzdah    NUMBER(20) not null,
  tjnd        CHAR(4) not null,
  tjyf        CHAR(2) not null,
  lsdd        NUMBER(16,2),
  xjdd        NUMBER(16,2),
  zhfhdd      NUMBER(16,2),
  hhfhdd      NUMBER(16,2),
  ddze        NUMBER(16,2),
  sndtqdd     NUMBER(16,2),
  yckdd       NUMBER(16,2),
  sjzhfhdd    NUMBER(16,2),
  yjqnzjf     NUMBER(16,4),
  knjy        VARCHAR2(2000),
  ckxse       NUMBER(16,2),
  mde         NUMBER(16,2),
  tse         NUMBER(16,2),
  ckhblv      NUMBER(16,4),
  tshblv      NUMBER(16,4),
  hbycyy      VARCHAR2(1000),
  crtime      DATE,
  uptime      DATE,
  sbbz        CHAR(1),
  jdtj_ksbcke NUMBER(16,2),
  jdtj_sbcke  NUMBER(16,2),
  jdtj_mde    NUMBER(16,2),
  jdtj_tse    NUMBER(16,2),
  jdtj_flag   CHAR(1),
  jdtj_time   DATE,
  note        VARCHAR2(200),
  wce         NUMBER(16,2),
  wclv        NUMBER(16,4)
)
;
comment on table DCB_TSZBCS_DDBDCKXQ
  is '调查表-退税指标测算业务-订单变动及出口需求调查表';
comment on column DCB_TSZBCS_DDBDCKXQ.tjnd
  is '统计年度';
comment on column DCB_TSZBCS_DDBDCKXQ.tjyf
  is '统计月份';
comment on column DCB_TSZBCS_DDBDCKXQ.lsdd
  is '流失订单';
comment on column DCB_TSZBCS_DDBDCKXQ.xjdd
  is '新接订单';
comment on column DCB_TSZBCS_DDBDCKXQ.zhfhdd
  is '暂缓发货订单';
comment on column DCB_TSZBCS_DDBDCKXQ.hhfhdd
  is '恢复发货订单';
comment on column DCB_TSZBCS_DDBDCKXQ.ddze
  is '订单总额（公式=∑新接订单-∑流失订单）';
comment on column DCB_TSZBCS_DDBDCKXQ.sndtqdd
  is '上年度同期订单';
comment on column DCB_TSZBCS_DDBDCKXQ.yckdd
  is '已出口订单';
comment on column DCB_TSZBCS_DDBDCKXQ.sjzhfhdd
  is '实际暂缓发货订单（公式=暂缓发货订单-恢复发货订单）';
comment on column DCB_TSZBCS_DDBDCKXQ.yjqnzjf
  is '预计全年增/降幅（公式=(订单总额-去年同期)/去年同期*100 %）';
comment on column DCB_TSZBCS_DDBDCKXQ.knjy
  is '目前困难和建议';
comment on column DCB_TSZBCS_DDBDCKXQ.ckxse
  is '出口额';
comment on column DCB_TSZBCS_DDBDCKXQ.mde
  is '免抵额';
comment on column DCB_TSZBCS_DDBDCKXQ.tse
  is '退税额';
comment on column DCB_TSZBCS_DDBDCKXQ.ckhblv
  is '出口额环比（公式=(出口额-上月出口额)/上月出口额*100%）';
comment on column DCB_TSZBCS_DDBDCKXQ.tshblv
  is '退税额环比（公式=(退税额-上月退税额)/上月退税额*100%）';
comment on column DCB_TSZBCS_DDBDCKXQ.hbycyy
  is '退税额环比异常原因（退税额环比波动在正负20%以上时必须填写）';
comment on column DCB_TSZBCS_DDBDCKXQ.crtime
  is '创建时间';
comment on column DCB_TSZBCS_DDBDCKXQ.uptime
  is '更新时间';
comment on column DCB_TSZBCS_DDBDCKXQ.sbbz
  is '上报标志(0未上报,1已上报)';
comment on column DCB_TSZBCS_DDBDCKXQ.jdtj_ksbcke
  is '局端统计-可申报出口额';
comment on column DCB_TSZBCS_DDBDCKXQ.jdtj_sbcke
  is '局端统计-申报出口额';
comment on column DCB_TSZBCS_DDBDCKXQ.jdtj_mde
  is '局端统计-申报免抵额';
comment on column DCB_TSZBCS_DDBDCKXQ.jdtj_tse
  is '局端统计-申报退税额';
comment on column DCB_TSZBCS_DDBDCKXQ.jdtj_flag
  is '局端统计-标志(0:待统计, 1:统计完成 2:统计失败)';
comment on column DCB_TSZBCS_DDBDCKXQ.jdtj_time
  is '局端统计-时间';
comment on column DCB_TSZBCS_DDBDCKXQ.note
  is '备注';
comment on column DCB_TSZBCS_DDBDCKXQ.wce
  is '误差额';
comment on column DCB_TSZBCS_DDBDCKXQ.wclv
  is '误差率';
create unique index UQ_TSZBCS_DDBDCKXQ_NNY on DCB_TSZBCS_DDBDCKXQ (NSRDZDAH, TJND, TJYF);
alter table DCB_TSZBCS_DDBDCKXQ
  add primary key (ID);

prompt
prompt Creating table DCB_TSZBCS_TJ
prompt ============================
prompt
create table DCB_TSZBCS_TJ
(
  nsrdzdah   NUMBER(20) not null,
  tjnd       CHAR(4) not null,
  tjyf       CHAR(2) not null,
  tsjsfs_dm  CHAR(1) not null,
  ksb_cke    NUMBER(16,2),
  sysb_cke   NUMBER(16,2),
  sysb_mde   NUMBER(16,2),
  sysb_tse   NUMBER(16,2),
  wsb_jxfpse NUMBER(16,2),
  sykp_xxse  NUMBER(16,2),
  sykp_jxse  NUMBER(16,2),
  sqldse     NUMBER(16,2),
  mdtytse    NUMBER(16,2),
  qmldse     NUMBER(16,2),
  tjbz       CHAR(1),
  tjstime    DATE,
  tjetime    DATE,
  sykp_rzdk  NUMBER(16,2),
  bz         VARCHAR2(200)
)
;
comment on table DCB_TSZBCS_TJ
  is '退税指标测算局端统计表';
comment on column DCB_TSZBCS_TJ.nsrdzdah
  is '纳税人电子档案号';
comment on column DCB_TSZBCS_TJ.tjnd
  is '统计年度';
comment on column DCB_TSZBCS_TJ.tjyf
  is '统计月份';
comment on column DCB_TSZBCS_TJ.tsjsfs_dm
  is '退税计算方式1生产2外贸';
comment on column DCB_TSZBCS_TJ.ksb_cke
  is '可申报出口额(近六个月出口）';
comment on column DCB_TSZBCS_TJ.sysb_cke
  is '上月实际申报出口额';
comment on column DCB_TSZBCS_TJ.sysb_mde
  is '上月实际申报免抵额';
comment on column DCB_TSZBCS_TJ.sysb_tse
  is '上月实际申报退税额';
comment on column DCB_TSZBCS_TJ.wsb_jxfpse
  is '外贸企业，近六个月已入审核系统未申报进项发票税额';
comment on column DCB_TSZBCS_TJ.sykp_xxse
  is '生产企业，上月开票（专票）销项税额';
comment on column DCB_TSZBCS_TJ.sykp_jxse
  is '生产企业，上月购货（专票）进项税额';
comment on column DCB_TSZBCS_TJ.sqldse
  is '生产企业，上期留抵税额';
comment on column DCB_TSZBCS_TJ.mdtytse
  is '生产企业，免抵退应退税额';
comment on column DCB_TSZBCS_TJ.qmldse
  is '生产企业，期末留抵税额测算';
comment on column DCB_TSZBCS_TJ.tjbz
  is '统计标志（预留使用）';
comment on column DCB_TSZBCS_TJ.tjstime
  is '统计开始时间';
comment on column DCB_TSZBCS_TJ.tjetime
  is '统计结束时间';
comment on column DCB_TSZBCS_TJ.sykp_rzdk
  is '生产企业，所属期上月的已认证抵扣税额';
comment on column DCB_TSZBCS_TJ.bz
  is '备注';
alter table DCB_TSZBCS_TJ
  add constraint PK_DCB_TSZBCS_TJ primary key (NSRDZDAH, TJND, TJYF);

prompt
prompt Creating table DCB_WCE_LIMIT_CONFIG
prompt ===================================
prompt
create table DCB_WCE_LIMIT_CONFIG
(
  swjg_dm  VARCHAR2(50) not null,
  wce_up   NUMBER(16,2),
  wce_down NUMBER(16,2)
)
;
comment on table DCB_WCE_LIMIT_CONFIG
  is '调查表_误差额_上下限配置表';
comment on column DCB_WCE_LIMIT_CONFIG.swjg_dm
  is '税务机关代码';
comment on column DCB_WCE_LIMIT_CONFIG.wce_up
  is '误差额上限';
comment on column DCB_WCE_LIMIT_CONFIG.wce_down
  is '误差额下限';
alter table DCB_WCE_LIMIT_CONFIG
  add constraint PRI_DCB_WCE_LIMIT_CONFIG primary key (SWJG_DM);

prompt
prompt Creating table DM_CATALOG
prompt =========================
prompt
create table DM_CATALOG
(
  code       VARCHAR2(20) not null,
  code_alias VARCHAR2(20),
  name       VARCHAR2(30),
  pcode      VARCHAR2(20),
  need_flag  CHAR(1),
  input_flag CHAR(1),
  showorder  NUMBER(10),
  qybj       CHAR(1),
  note       VARCHAR2(200)
)
;
comment on column DM_CATALOG.code
  is '代码';
comment on column DM_CATALOG.code_alias
  is '代码别名';
comment on column DM_CATALOG.name
  is '名称';
comment on column DM_CATALOG.pcode
  is '父类代码';
comment on column DM_CATALOG.need_flag
  is '是否必要';
comment on column DM_CATALOG.input_flag
  is '是否需要输入';
comment on column DM_CATALOG.showorder
  is '排序';
comment on column DM_CATALOG.qybj
  is '启用标记';
comment on column DM_CATALOG.note
  is '备注';
alter table DM_CATALOG
  add constraint DM_CATALOG_PK primary key (CODE);

prompt
prompt Creating table DM_CATALOG_SWJG
prompt ==============================
prompt
create table DM_CATALOG_SWJG
(
  swjgdm     VARCHAR2(11) not null,
  code       VARCHAR2(20) not null,
  code_alias VARCHAR2(20),
  name       VARCHAR2(30),
  pcode      VARCHAR2(20),
  need_flag  CHAR(1),
  input_flag CHAR(1),
  showorder  NUMBER(10),
  qybj       CHAR(1),
  note       VARCHAR2(200)
)
;
comment on column DM_CATALOG_SWJG.swjgdm
  is '税务机关代码';
comment on column DM_CATALOG_SWJG.code
  is '代码';
comment on column DM_CATALOG_SWJG.code_alias
  is '代码别名';
comment on column DM_CATALOG_SWJG.name
  is '名称';
comment on column DM_CATALOG_SWJG.pcode
  is '父类代码';
comment on column DM_CATALOG_SWJG.need_flag
  is '是否必要';
comment on column DM_CATALOG_SWJG.input_flag
  is '是否需要输入';
comment on column DM_CATALOG_SWJG.showorder
  is '排序';
comment on column DM_CATALOG_SWJG.qybj
  is '启用标记';
comment on column DM_CATALOG_SWJG.note
  is '备注';
alter table DM_CATALOG_SWJG
  add constraint DM_CATALOG_SWJG_PK primary key (SWJGDM, CODE);

prompt
prompt Creating table DM_CKTS_HGGNDQ
prompt =============================
prompt
create table DM_CKTS_HGGNDQ
(
  gndq_dm CHAR(5) not null,
  gndqmc  VARCHAR2(300) not null,
  dqxz_dm CHAR(1),
  yxbz    CHAR(1) not null,
  xybz    CHAR(1) not null,
  gndqjc  VARCHAR2(300)
)
;
comment on table DM_CKTS_HGGNDQ
  is '海关国内地区代码';
comment on column DM_CKTS_HGGNDQ.gndq_dm
  is '国内地区代码';
comment on column DM_CKTS_HGGNDQ.gndqmc
  is '国内地区名称';
comment on column DM_CKTS_HGGNDQ.dqxz_dm
  is '地区性质代码';
comment on column DM_CKTS_HGGNDQ.yxbz
  is '有效标志';
comment on column DM_CKTS_HGGNDQ.xybz
  is '选用标志';
comment on column DM_CKTS_HGGNDQ.gndqjc
  is '国内地区简称';
alter table DM_CKTS_HGGNDQ
  add constraint PK_DM_CKTS_HGGNDQ primary key (GNDQ_DM);

prompt
prompt Creating table DM_DMDZ
prompt ======================
prompt
create table DM_DMDZ
(
  xm VARCHAR2(20) not null,
  dm VARCHAR2(100) not null,
  dz VARCHAR2(100),
  bz VARCHAR2(200)
)
;
comment on table DM_DMDZ
  is '代码对照表，BJ2GL-SWJG， 便捷退税管理系统税务机关';
comment on column DM_DMDZ.xm
  is '项目';
comment on column DM_DMDZ.dm
  is '代码';
comment on column DM_DMDZ.dz
  is '对照代码';
comment on column DM_DMDZ.bz
  is '备注';
alter table DM_DMDZ
  add constraint PK_DM_DMDZ primary key (XM, DM);

prompt
prompt Creating table DM_DQCODE
prompt ========================
prompt
create table DM_DQCODE
(
  dq_code  VARCHAR2(10) not null,
  dq_name  VARCHAR2(30) default ' ',
  dq_ename VARCHAR2(60) default ' ',
  dq_type  VARCHAR2(2)
)
;
alter table DM_DQCODE
  add constraint PK_DM_DQCODE_CODE primary key (DQ_CODE);

prompt
prompt Creating table DM_DQGROUP
prompt =========================
prompt
create table DM_DQGROUP
(
  dq_code VARCHAR2(10) not null,
  gb_code VARCHAR2(3) not null
)
;
alter table DM_DQGROUP
  add constraint PK_DM_DQGROUP_DQ_GB primary key (DQ_CODE, GB_CODE);

prompt
prompt Creating table DM_GBCODE
prompt ========================
prompt
create table DM_GBCODE
(
  gb_code  VARCHAR2(3) not null,
  gb_name  VARCHAR2(30) default ' ',
  gb_ename VARCHAR2(28) default ' ',
  qycode   VARCHAR2(2),
  qyname   VARCHAR2(60),
  qybz     CHAR(1)
)
;
comment on column DM_GBCODE.gb_code
  is '国别代码';
comment on column DM_GBCODE.gb_name
  is '国别名称';
comment on column DM_GBCODE.gb_ename
  is '国别英文名称';
comment on column DM_GBCODE.qycode
  is '对应国外区域代码';
comment on column DM_GBCODE.qyname
  is '对应国外区域名称';
comment on column DM_GBCODE.qybz
  is '启用标志';
alter table DM_GBCODE
  add constraint PK_DM_GBCODE_CODE primary key (GB_CODE);

prompt
prompt Creating table DM_GY_SWJG
prompt =========================
prompt
create table DM_GY_SWJG
(
  swjg_dm    CHAR(11) not null,
  swjgmc     VARCHAR2(300) not null,
  swjgjc     VARCHAR2(150) not null,
  swjgbz     CHAR(1) not null,
  sjswjg_dm  CHAR(11),
  jgjc_dm    CHAR(2) not null,
  swjgyzbm   CHAR(6),
  swjgdz     VARCHAR2(300),
  swjglxdh   VARCHAR2(60),
  czdh       VARCHAR2(20),
  dzxx       VARCHAR2(90),
  xzqhsz_dm  CHAR(6),
  swjgfzr_dm CHAR(11),
  gdslx_dm   CHAR(1) not null,
  xybz       CHAR(1) not null,
  yxbz       CHAR(1) default 'Y' not null,
  yxqsrq     DATE not null,
  yxzzrq     DATE not null,
  swjgjg     VARCHAR2(75),
  bsfwtbz    CHAR(1),
  ghbz       CHAR(1) default 'N' not null,
  xsxh       NUMBER(4) default 1 not null,
  gjswjgmc   VARCHAR2(300),
  dsswjgmc   VARCHAR2(300),
  gsswjgjg   VARCHAR2(75),
  dsswjgjg   VARCHAR2(75),
  zn_dm      CHAR(2),
  swjgywmc   VARCHAR2(300)
)
;
comment on table DM_GY_SWJG
  is '税务机构代码';
comment on column DM_GY_SWJG.swjg_dm
  is '税务机关代码';
comment on column DM_GY_SWJG.swjgmc
  is '税务机关名称';
comment on column DM_GY_SWJG.swjgjc
  is '税务机构简称';
comment on column DM_GY_SWJG.swjgbz
  is '税务机构标志 0机关 1部门（设计阶段建议不要使用该列）';
comment on column DM_GY_SWJG.sjswjg_dm
  is '上级税务机关代码';
comment on column DM_GY_SWJG.jgjc_dm
  is '机构级次代码';
comment on column DM_GY_SWJG.swjgyzbm
  is '税务机构邮政编码';
comment on column DM_GY_SWJG.swjgdz
  is '税务机关地址';
comment on column DM_GY_SWJG.swjglxdh
  is '税务机关联系电话';
comment on column DM_GY_SWJG.czdh
  is '传真电话';
comment on column DM_GY_SWJG.dzxx
  is '电子信箱';
comment on column DM_GY_SWJG.xzqhsz_dm
  is '行政区划数字代码';
comment on column DM_GY_SWJG.swjgfzr_dm
  is '负责人';
comment on column DM_GY_SWJG.gdslx_dm
  is '国地税类型代码 ';
comment on column DM_GY_SWJG.xybz
  is '选用标志';
comment on column DM_GY_SWJG.yxbz
  is '有效标志';
comment on column DM_GY_SWJG.yxqsrq
  is '有效起始日期';
comment on column DM_GY_SWJG.yxzzrq
  is '有效终止日期';
comment on column DM_GY_SWJG.swjgjg
  is '税务机构局轨';
comment on column DM_GY_SWJG.bsfwtbz
  is '办税服务厅标志';
comment on column DM_GY_SWJG.ghbz
  is '管户标志';
comment on column DM_GY_SWJG.xsxh
  is '显示序号';
comment on column DM_GY_SWJG.gjswjgmc
  is '国家税务机关名称';
comment on column DM_GY_SWJG.dsswjgmc
  is '地税税务机关名称';
comment on column DM_GY_SWJG.gsswjgjg
  is '国税局轨';
comment on column DM_GY_SWJG.dsswjgjg
  is '地税局轨';
comment on column DM_GY_SWJG.zn_dm
  is '职能代码';
comment on column DM_GY_SWJG.swjgywmc
  is '税务机构英文名称';
create unique index PK_DM_GY_SWJG on DM_GY_SWJG (SWJG_DM);

prompt
prompt Creating table DM_HBZL_HG
prompt =========================
prompt
create table DM_HBZL_HG
(
  hbzl_hg VARCHAR2(6) not null,
  hbzl_dm VARCHAR2(3) not null,
  hbzl_mc VARCHAR2(20)
)
;
comment on table DM_HBZL_HG
  is '币制代码表';
alter table DM_HBZL_HG
  add constraint PK_HBZL_HG primary key (HBZL_HG);

prompt
prompt Creating table DM_HGCODE
prompt ========================
prompt
create table DM_HGCODE
(
  hgcode  VARCHAR2(4) not null,
  hgmc    VARCHAR2(60),
  xzqh_dm VARCHAR2(6),
  xzqh_mc VARCHAR2(50),
  qybz    CHAR(1)
)
;
comment on column DM_HGCODE.xzqh_dm
  is '对应行政区划代码';
comment on column DM_HGCODE.xzqh_mc
  is '对应行政区划名称';
comment on column DM_HGCODE.qybz
  is '启用标志';
alter table DM_HGCODE
  add primary key (HGCODE);

prompt
prompt Creating table DM_HGHYD
prompt =======================
prompt
create table DM_HGHYD
(
  id       NUMBER(18) not null,
  hghyd_dm VARCHAR2(5) not null,
  hghyd_mc VARCHAR2(50) not null,
  xzqh_dm  VARCHAR2(6),
  xzqh_mc  VARCHAR2(50),
  qybz     CHAR(1)
)
;
comment on table DM_HGHYD
  is '代码_海关货源地对照表';
comment on column DM_HGHYD.id
  is '主键，序列号';
comment on column DM_HGHYD.hghyd_dm
  is '海关货源地代码';
comment on column DM_HGHYD.hghyd_mc
  is '海关货源地名称';
comment on column DM_HGHYD.xzqh_dm
  is '对应行政区划代码';
comment on column DM_HGHYD.xzqh_mc
  is '对应行政区划名称';
comment on column DM_HGHYD.qybz
  is '启用标志';
alter table DM_HGHYD
  add constraint PK_DM_HGHYD primary key (ID);

prompt
prompt Creating table DM_HGSP_TSLV_DZ
prompt ==============================
prompt
create table DM_HGSP_TSLV_DZ
(
  spdm    VARCHAR2(20) not null,
  spmc    VARCHAR2(80),
  tslv    NUMBER(5,2),
  tslv_o  NUMBER(5,2),
  bc_flag CHAR(1)
)
;
alter table DM_HGSP_TSLV_DZ
  add primary key (SPDM);

prompt
prompt Creating table DM_HGZYG
prompt =======================
prompt
create table DM_HGZYG
(
  hgzyg_dm  VARCHAR2(10) not null,
  hgzygjc   VARCHAR2(100),
  hgzygywjc VARCHAR2(100)
)
;
comment on table DM_HGZYG
  is '海关指运港代码表';
comment on column DM_HGZYG.hgzyg_dm
  is '海关指运港代码';
comment on column DM_HGZYG.hgzygjc
  is '海关指运港简称';
comment on column DM_HGZYG.hgzygywjc
  is '海关指运港英文简称';
alter table DM_HGZYG
  add constraint PK_DM_HGZYG primary key (HGZYG_DM);

prompt
prompt Creating table DM_HY_JS
prompt =======================
prompt
create table DM_HY_JS
(
  hy_dm   VARCHAR2(4) not null,
  hymc    VARCHAR2(80),
  mlbz    CHAR(1),
  dlbz    CHAR(1),
  zlbz    CHAR(1),
  xlbz    CHAR(1),
  sjhy_dm VARCHAR2(4),
  xybz    CHAR(1),
  yxbz    CHAR(1)
)
;
alter table DM_HY_JS
  add primary key (HY_DM);

prompt
prompt Creating table DM_JDXZ
prompt ======================
prompt
create table DM_JDXZ
(
  jdxz_dm   VARCHAR2(9) not null,
  jdxzmc    VARCHAR2(300),
  xzqhsz_dm VARCHAR2(6),
  yxbz      CHAR(1)
)
;
alter table DM_JDXZ
  add primary key (JDXZ_DM);

prompt
prompt Creating table DM_SH_GW
prompt =======================
prompt
create table DM_SH_GW
(
  shgwdm    VARCHAR2(20) not null,
  shgwmc    VARCHAR2(30) not null,
  showorder INTEGER not null,
  tsshdm    VARCHAR2(30)
)
;
comment on table DM_SH_GW
  is '审核岗位字典表';
comment on column DM_SH_GW.shgwdm
  is '审核岗位代码';
comment on column DM_SH_GW.shgwmc
  is '审核岗位名称';
comment on column DM_SH_GW.showorder
  is '显示顺序';
comment on column DM_SH_GW.tsshdm
  is '审核系统中的代码';
alter table DM_SH_GW
  add primary key (SHGWDM);

prompt
prompt Creating table DM_SPFL
prompt ======================
prompt
create table DM_SPFL
(
  spml VARCHAR2(4),
  spdl VARCHAR2(4) not null
)
;
alter table DM_SPFL
  add constraint PK_DM_SPFL primary key (SPDL);

prompt
prompt Creating table DM_SPML
prompt ======================
prompt
create table DM_SPML
(
  spml VARCHAR2(4) not null,
  mlmc VARCHAR2(200),
  mldm VARCHAR2(20)
)
;
alter table DM_SPML
  add primary key (SPML);

prompt
prompt Creating table DM_SWJG
prompt ======================
prompt
create table DM_SWJG
(
  swjg_dm    VARCHAR2(11) not null,
  swjg_mc    VARCHAR2(80) not null,
  swjg_jc    VARCHAR2(80) not null,
  swjg_dm_sj VARCHAR2(11) not null,
  yxws       NUMBER(10),
  swjg_bz    CHAR(1) not null,
  qybz       CHAR(1) not null,
  tsjg_bz    CHAR(1),
  xzqhsz_dm  CHAR(6),
  dispsx     VARCHAR2(20),
  zbjg_dm    VARCHAR2(11),
  zg         VARCHAR2(20)
)
;
comment on table DM_SWJG
  is '权限管理_税务机关代码表，一般与征管系统同步';
comment on column DM_SWJG.swjg_dm
  is '税务机关代码';
comment on column DM_SWJG.swjg_mc
  is '税务机关名称';
comment on column DM_SWJG.swjg_jc
  is '税务机关简称';
comment on column DM_SWJG.swjg_dm_sj
  is '上级税务机关代码';
comment on column DM_SWJG.yxws
  is '有效位数';
comment on column DM_SWJG.swjg_bz
  is '税务机关标识';
comment on column DM_SWJG.qybz
  is '启用标识';
comment on column DM_SWJG.dispsx
  is '显示缩写';
comment on column DM_SWJG.zbjg_dm
  is '指标机关代码';
comment on column DM_SWJG.zg
  is '字轨(单证备案)';
alter table DM_SWJG
  add constraint PK_DM_SWJG primary key (SWJG_DM);

prompt
prompt Creating table DM_SWJG_VIRTUAL
prompt ==============================
prompt
create table DM_SWJG_VIRTUAL
(
  vir_swjgdm VARCHAR2(11) not null,
  vir_name   VARCHAR2(100) not null,
  swjg_dm    VARCHAR2(11) not null,
  yxbz       CHAR(1),
  vir_flag   CHAR(1)
)
;
comment on column DM_SWJG_VIRTUAL.vir_swjgdm
  is '当记录为下级单位时，该字段为真实的税务机关单位代码';
comment on column DM_SWJG_VIRTUAL.swjg_dm
  is '当为虚拟单位时，为所属单位代码，否则为子单位所属的虚拟代码代码';
comment on column DM_SWJG_VIRTUAL.vir_flag
  is '是否虚拟单位节点';
alter table DM_SWJG_VIRTUAL
  add constraint PK_VIR_SWJG primary key (VIR_SWJGDM, SWJG_DM);

prompt
prompt Creating table DM_TDCODE
prompt ========================
prompt
create table DM_TDCODE
(
  tdcode VARCHAR2(4) not null,
  tdmc   VARCHAR2(30)
)
;
alter table DM_TDCODE
  add primary key (TDCODE);

prompt
prompt Creating table DM_TSL_BB03105
prompt =============================
prompt
create table DM_TSL_BB03105
(
  bblc VARCHAR2(2),
  tsl  NUMBER(16,4),
  tslv VARCHAR2(10)
)
;

prompt
prompt Creating table DM_XZQH
prompt ======================
prompt
create table DM_XZQH
(
  dm     VARCHAR2(6) not null,
  mc     VARCHAR2(50) not null,
  qycode VARCHAR2(2),
  qyname VARCHAR2(50),
  qybz   CHAR(1)
)
;
comment on column DM_XZQH.dm
  is '行政区划代码';
comment on column DM_XZQH.mc
  is '行政区划名称';
comment on column DM_XZQH.qycode
  is '对应国内区域代码';
comment on column DM_XZQH.qyname
  is '对应国内区域名称';
comment on column DM_XZQH.qybz
  is '启用标志';
alter table DM_XZQH
  add primary key (DM);

prompt
prompt Creating table DM_XZQH_DQ
prompt =========================
prompt
create table DM_XZQH_DQ
(
  dm     VARCHAR2(6) not null,
  mc     VARCHAR2(50) not null,
  qycode VARCHAR2(2),
  qyname VARCHAR2(50),
  qybz   CHAR(1)
)
;
comment on table DM_XZQH_DQ
  is '按大区划分行政区划';
comment on column DM_XZQH_DQ.dm
  is '行政区划代码';
comment on column DM_XZQH_DQ.mc
  is '行政区划名称';
comment on column DM_XZQH_DQ.qycode
  is '对应国内区域代码';
comment on column DM_XZQH_DQ.qyname
  is '对应国内区域名称';
comment on column DM_XZQH_DQ.qybz
  is '启用标志';
alter table DM_XZQH_DQ
  add constraint PK_DM_XZQH_DQ primary key (DM);

prompt
prompt Creating table DM_XZQH_SF
prompt =========================
prompt
create table DM_XZQH_SF
(
  dm     VARCHAR2(6) not null,
  mc     VARCHAR2(50) not null,
  qycode VARCHAR2(2),
  qyname VARCHAR2(50),
  qybz   CHAR(1)
)
;
comment on table DM_XZQH_SF
  is '按大区划分行政区划';
comment on column DM_XZQH_SF.dm
  is '行政区划代码';
comment on column DM_XZQH_SF.mc
  is '行政区划名称';
comment on column DM_XZQH_SF.qycode
  is '对应国内区域代码';
comment on column DM_XZQH_SF.qyname
  is '对应国内区域名称';
comment on column DM_XZQH_SF.qybz
  is '启用标志';
alter table DM_XZQH_SF
  add constraint PK_DM_XZQH_SF primary key (DM);

prompt
prompt Creating table DM_XZQH_ZJ
prompt =========================
prompt
create table DM_XZQH_ZJ
(
  xzqh_dm   VARCHAR2(6) not null,
  xzqh_mc   VARCHAR2(150) not null,
  sjxzqh_dm VARCHAR2(6),
  yxbz      CHAR(1)
)
;
alter table DM_XZQH_ZJ
  add primary key (XZQH_DM);

prompt
prompt Creating table DM_ZBJG
prompt ======================
prompt
create table DM_ZBJG
(
  zbjg_dm   VARCHAR2(11) not null,
  zbjg_mc   VARCHAR2(100) not null,
  zbjg_jc   VARCHAR2(100) not null,
  sj_zbjg   VARCHAR2(11) not null,
  yxbz      CHAR(1) not null,
  lx        CHAR(1) default 1,
  whqx      VARCHAR2(11) default 133,
  showorder NUMBER,
  ck_zbjg   VARCHAR2(11)
)
;
comment on column DM_ZBJG.zbjg_dm
  is '指标机关代码';
comment on column DM_ZBJG.zbjg_mc
  is '机关名称';
comment on column DM_ZBJG.zbjg_jc
  is '机关简称';
comment on column DM_ZBJG.sj_zbjg
  is '上级代码（体现汇总关系）';
comment on column DM_ZBJG.yxbz
  is 'Y有效 N无效';
comment on column DM_ZBJG.lx
  is '类型：1实际机构 2汇总机构';
comment on column DM_ZBJG.whqx
  is '维护权限';
comment on column DM_ZBJG.showorder
  is '显示顺序';
comment on column DM_ZBJG.ck_zbjg
  is '指标出库机关（空表示省局指标库）';
alter table DM_ZBJG
  add primary key (ZBJG_DM);

prompt
prompt Creating table EDOC_APPLY
prompt =========================
prompt
create table EDOC_APPLY
(
  id         NUMBER(20) not null,
  nsrsbh     VARCHAR2(21) not null,
  result     CHAR(1) not null,
  apply_time TIMESTAMP(6) not null,
  audit_time TIMESTAMP(6),
  remark     VARCHAR2(255),
  file_path  VARCHAR2(255),
  concacts   VARCHAR2(40),
  tel        VARCHAR2(40),
  address    VARCHAR2(1000)
)
;
comment on table EDOC_APPLY
  is '资格备案申请表';
comment on column EDOC_APPLY.id
  is '主键id';
comment on column EDOC_APPLY.nsrsbh
  is '纳税人识别号';
comment on column EDOC_APPLY.result
  is '申请结果。1-已申请，2-已通过，3-已拒绝';
comment on column EDOC_APPLY.apply_time
  is '申请时间';
comment on column EDOC_APPLY.audit_time
  is '审核时间';
comment on column EDOC_APPLY.remark
  is '备注（拒绝原因）';
comment on column EDOC_APPLY.file_path
  is '申请表PDF文件路径';
comment on column EDOC_APPLY.concacts
  is '联系人';
comment on column EDOC_APPLY.tel
  is '联系电话';
comment on column EDOC_APPLY.address
  is '企业联系地址';
create index IDX_EDOC_APPLY_NSRSBH on EDOC_APPLY (NSRSBH);
alter table EDOC_APPLY
  add constraint EDOC_APPLY_PRIMARYKEY primary key (ID);

prompt
prompt Creating table EDOC_AUTO_TIME
prompt =============================
prompt
create table EDOC_AUTO_TIME
(
  id        NUMBER(20) not null,
  deal_type CHAR(1) not null,
  deal_time TIMESTAMP(6) not null
)
;
comment on table EDOC_AUTO_TIME
  is '处理定时任务记录处理时间的表';
comment on column EDOC_AUTO_TIME.deal_type
  is '1-轮询金三业务办理信息表生成备案任务和申报撤回任务';
comment on column EDOC_AUTO_TIME.deal_time
  is '处理时间';
create unique index UDX_EDOC_AUTO_TIME on EDOC_AUTO_TIME (DEAL_TYPE);
alter table EDOC_AUTO_TIME
  add constraint PK_EDOC_AUTO_TIME primary key (ID);

prompt
prompt Creating table EDOC_CATALOG_FIRST
prompt =================================
prompt
create table EDOC_CATALOG_FIRST
(
  id        NUMBER(20) not null,
  nsrsbh    VARCHAR2(21) not null,
  baxh      VARCHAR2(36) not null,
  sbnypc    VARCHAR2(36) not null,
  sbrq      DATE not null,
  entry_id  VARCHAR2(21) not null,
  ckfp_no   VARCHAR2(3000),
  jhfp_no   VARCHAR2(3000),
  zrbm      VARCHAR2(64),
  zrr       VARCHAR2(64),
  shbz      VARCHAR2(64),
  shrq      DATE,
  inspector VARCHAR2(20),
  remark    VARCHAR2(255),
  je        NUMBER(15,2),
  se        NUMBER(15,2),
  sfqqbz    CHAR(1),
  gdzt      CHAR(1),
  sbxh      VARCHAR2(8),
  dlzmh     VARCHAR2(20)
)
;
comment on table EDOC_CATALOG_FIRST
  is '备案目录主表';
comment on column EDOC_CATALOG_FIRST.id
  is '主键';
comment on column EDOC_CATALOG_FIRST.nsrsbh
  is '纳税人识别号';
comment on column EDOC_CATALOG_FIRST.baxh
  is '备案序号';
comment on column EDOC_CATALOG_FIRST.sbnypc
  is '申报年月批次';
comment on column EDOC_CATALOG_FIRST.sbrq
  is '申报日期';
comment on column EDOC_CATALOG_FIRST.entry_id
  is '报关单号（可以是代理证明号）';
comment on column EDOC_CATALOG_FIRST.ckfp_no
  is '出口发票号';
comment on column EDOC_CATALOG_FIRST.jhfp_no
  is '进货发票(进货凭证号)';
comment on column EDOC_CATALOG_FIRST.zrbm
  is '责任部门';
comment on column EDOC_CATALOG_FIRST.zrr
  is '责任人';
comment on column EDOC_CATALOG_FIRST.shbz
  is '审核标志';
comment on column EDOC_CATALOG_FIRST.shrq
  is '审核日期';
comment on column EDOC_CATALOG_FIRST.inspector
  is '审核人';
comment on column EDOC_CATALOG_FIRST.remark
  is '备注说明';
comment on column EDOC_CATALOG_FIRST.je
  is '金额';
comment on column EDOC_CATALOG_FIRST.se
  is '税额';
comment on column EDOC_CATALOG_FIRST.sfqqbz
  is '是否齐全标志 .0-无状态,1-未齐全，2-必备单证齐全，3-单证齐全';
comment on column EDOC_CATALOG_FIRST.gdzt
  is '归档状态.0-未归档,1-已归档';
comment on column EDOC_CATALOG_FIRST.sbxh
  is '最小的申报序号';
comment on column EDOC_CATALOG_FIRST.dlzmh
  is '代理证明号';
create index IDX_EDOC_CATALOG_FIRST_NXE on EDOC_CATALOG_FIRST (NSRSBH, BAXH, ENTRY_ID);
alter table EDOC_CATALOG_FIRST
  add constraint EDOC_CATALOG_FIRST_PRIMARYKEY primary key (ID);

prompt
prompt Creating table EDOC_CATALOG_SECOND
prompt ==================================
prompt
create table EDOC_CATALOG_SECOND
(
  id            NUMBER(20) not null,
  dzdl          VARCHAR2(36),
  edoc_type     VARCHAR2(10),
  edoc_id       NUMBER(20),
  edoc_state    VARCHAR2(600),
  edoc_flag     CHAR(1),
  update_time   TIMESTAMP(6),
  edoc_type_sub VARCHAR2(10),
  nsrsbh        VARCHAR2(21),
  entry_id      VARCHAR2(21)
)
;
comment on table EDOC_CATALOG_SECOND
  is '备案目录索引表';
comment on column EDOC_CATALOG_SECOND.id
  is '主键';
comment on column EDOC_CATALOG_SECOND.dzdl
  is '单证大类 1-备案单证，2-申报单证，3-其他单证';
comment on column EDOC_CATALOG_SECOND.edoc_type
  is '单证类型';
comment on column EDOC_CATALOG_SECOND.edoc_id
  is '单证文件ID,与单证文件信息表关联';
comment on column EDOC_CATALOG_SECOND.edoc_state
  is '单证说明';
comment on column EDOC_CATALOG_SECOND.edoc_flag
  is '单证标志  0-必备1-市县局要求必备2-非必备';
comment on column EDOC_CATALOG_SECOND.update_time
  is '更新时间， 即最后一次导入单证的时间';
comment on column EDOC_CATALOG_SECOND.edoc_type_sub
  is '单证类型详细';
comment on column EDOC_CATALOG_SECOND.nsrsbh
  is '纳税人识别号';
comment on column EDOC_CATALOG_SECOND.entry_id
  is '报关单/代理证明号';
create index IDX_EDOC_CATALOG_SECOND on EDOC_CATALOG_SECOND (EDOC_ID);
create index IDX_EDOC_CATALOG_SECOND_NE on EDOC_CATALOG_SECOND (NSRSBH, ENTRY_ID);
alter table EDOC_CATALOG_SECOND
  add constraint EDOC_CATALOG_SECOND_PRIMARYKEY primary key (ID);

prompt
prompt Creating table EDOC_DECLARE_WITHDRAW_RESULT
prompt ===========================================
prompt
create table EDOC_DECLARE_WITHDRAW_RESULT
(
  busikey VARCHAR2(50) not null,
  sjly    CHAR(1) not null,
  cjsj    TIMESTAMP(6),
  xgsj    TIMESTAMP(6)
)
;
comment on table EDOC_DECLARE_WITHDRAW_RESULT
  is '生成申报撤回任务结果表';
comment on column EDOC_DECLARE_WITHDRAW_RESULT.busikey
  is '业务主键';
comment on column EDOC_DECLARE_WITHDRAW_RESULT.sjly
  is '数据来源 1-老版本便捷退税触发器产生  2-自动轮询金三数据';
comment on column EDOC_DECLARE_WITHDRAW_RESULT.cjsj
  is '创建时间';
comment on column EDOC_DECLARE_WITHDRAW_RESULT.xgsj
  is '修改时间';
alter table EDOC_DECLARE_WITHDRAW_RESULT
  add constraint PK_EDOC_DECLARE_WITHDRAW_RESUL primary key (BUSIKEY);

prompt
prompt Creating table EDOC_ENTRY_MAIN
prompt ==============================
prompt
create table EDOC_ENTRY_MAIN
(
  id                         NUMBER(20) not null,
  nsrsbh                     VARCHAR2(21) not null,
  entry_id                   VARCHAR2(21) not null,
  sbywzl                     VARCHAR2(15),
  edoc_size                  VARCHAR2(10),
  owner_scc                  VARCHAR2(21),
  owner_name                 VARCHAR2(70),
  e_date                     DATE,
  contr_no                   VARCHAR2(50),
  manual_no                  VARCHAR2(30),
  traf_name                  VARCHAR2(50),
  cus_traf_mode              VARCHAR2(5),
  cus_traf_mode_name         VARCHAR2(30),
  bill_no                    VARCHAR2(32),
  supv_mode_code             VARCHAR2(4),
  supv_mode_code_name        VARCHAR2(30),
  cus_trade_nation_code      VARCHAR2(10),
  cus_trade_nation_code_name VARCHAR2(70),
  ywlx_code                  VARCHAR2(30),
  ywlx_name                  VARCHAR2(75),
  remark                     VARCHAR2(500),
  crtime                     DATE default sysdate,
  uptime                     DATE,
  sbdwdm                     VARCHAR2(50),
  sbdwmc                     VARCHAR2(300),
  trans_mode                 VARCHAR2(2),
  trans_mode_name            VARCHAR2(75),
  bgdsbrq                    DATE
)
;
comment on table EDOC_ENTRY_MAIN
  is '出口业务明细表';
comment on column EDOC_ENTRY_MAIN.id
  is '主键';
comment on column EDOC_ENTRY_MAIN.nsrsbh
  is '纳税人识别号';
comment on column EDOC_ENTRY_MAIN.entry_id
  is '报关单号/代理证明号';
comment on column EDOC_ENTRY_MAIN.sbywzl
  is '申报业务种类';
comment on column EDOC_ENTRY_MAIN.edoc_size
  is '文件大小(局端不使用，企业端使用)';
comment on column EDOC_ENTRY_MAIN.owner_scc
  is '生产销售单位税号';
comment on column EDOC_ENTRY_MAIN.owner_name
  is '生产销售单位名称';
comment on column EDOC_ENTRY_MAIN.e_date
  is '出口日期';
comment on column EDOC_ENTRY_MAIN.contr_no
  is '合同协议号';
comment on column EDOC_ENTRY_MAIN.manual_no
  is '备案号';
comment on column EDOC_ENTRY_MAIN.traf_name
  is '运输工具名称';
comment on column EDOC_ENTRY_MAIN.cus_traf_mode
  is '运输方式代码';
comment on column EDOC_ENTRY_MAIN.cus_traf_mode_name
  is '运输方式名称';
comment on column EDOC_ENTRY_MAIN.bill_no
  is '提运单号';
comment on column EDOC_ENTRY_MAIN.supv_mode_code
  is '贸易方式代码';
comment on column EDOC_ENTRY_MAIN.supv_mode_code_name
  is '贸易方式名称';
comment on column EDOC_ENTRY_MAIN.cus_trade_nation_code
  is '  贸易国别(地区)代码';
comment on column EDOC_ENTRY_MAIN.cus_trade_nation_code_name
  is '贸易国别(地区)名称';
comment on column EDOC_ENTRY_MAIN.ywlx_code
  is '业务类型代码';
comment on column EDOC_ENTRY_MAIN.ywlx_name
  is '业务类型名称';
comment on column EDOC_ENTRY_MAIN.remark
  is '备注';
comment on column EDOC_ENTRY_MAIN.crtime
  is '创建时间';
comment on column EDOC_ENTRY_MAIN.uptime
  is '修改时间';
comment on column EDOC_ENTRY_MAIN.sbdwdm
  is '申报单位代码(委托报关单位代码)';
comment on column EDOC_ENTRY_MAIN.sbdwmc
  is '申报单位名称(委托报关单位名称)';
comment on column EDOC_ENTRY_MAIN.trans_mode
  is '成交方式代码';
comment on column EDOC_ENTRY_MAIN.trans_mode_name
  is '成交方式名称';
comment on column EDOC_ENTRY_MAIN.bgdsbrq
  is '报关单申报日期';
create unique index IDX_EDOC_ENTRY_MAIN_NE on EDOC_ENTRY_MAIN (NSRSBH, ENTRY_ID);
alter table EDOC_ENTRY_MAIN
  add constraint PK_EDOC_ENTRY_MAIN primary key (ID);

prompt
prompt Creating table EDOC_EXAMINE_BUSINESS
prompt ====================================
prompt
create table EDOC_EXAMINE_BUSINESS
(
  id             NUMBER(20) not null,
  nsrsbh         VARCHAR2(21) not null,
  nsrmc          VARCHAR2(100) not null,
  qyhgdm         VARCHAR2(20) not null,
  swjgdm         VARCHAR2(11) not null,
  qylx           CHAR(1) not null,
  flglcd         CHAR(1),
  balx           CHAR(1) default 0,
  status         CHAR(1) default 0 not null,
  releaser       VARCHAR2(30),
  release_time   TIMESTAMP(6),
  report_time    TIMESTAMP(6),
  overdule       DATE,
  examiner       VARCHAR2(30),
  examine_time   TIMESTAMP(6),
  examine_result CHAR(1),
  examine_note   VARCHAR2(500),
  back_count     NUMBER(6) default 0,
  back_reason    VARCHAR2(500),
  sbywzl         VARCHAR2(10) not null,
  sbnypc         VARCHAR2(15) not null,
  sbrq           DATE,
  entry_id       VARCHAR2(18) not null,
  ywlx_code      VARCHAR2(30),
  ckfp_no        VARCHAR2(3000),
  jhfp_no        VARCHAR2(3000),
  je             NUMBER(15,2),
  se             NUMBER(15,2),
  yjsl           NUMBER(6) default 0,
  skclbz         CHAR(1),
  skclje         NUMBER(15,2),
  lxr            VARCHAR2(150),
  lxdh           VARCHAR2(30),
  range          VARCHAR2(500),
  void_flag      CHAR(1) default 0,
  voider         VARCHAR2(30),
  void_time      TIMESTAMP(6),
  cjsj           TIMESTAMP(6) default sysdate not null,
  xgsj           TIMESTAMP(6),
  note           VARCHAR2(500),
  tsjsfs_chg     CHAR(1),
  dzqqbz         CHAR(1)
)
;
comment on table EDOC_EXAMINE_BUSINESS
  is '单证核查出口业务表';
comment on column EDOC_EXAMINE_BUSINESS.id
  is '主键';
comment on column EDOC_EXAMINE_BUSINESS.nsrsbh
  is '纳税人识别号';
comment on column EDOC_EXAMINE_BUSINESS.nsrmc
  is '纳税人名称';
comment on column EDOC_EXAMINE_BUSINESS.qyhgdm
  is '企业海关代码';
comment on column EDOC_EXAMINE_BUSINESS.swjgdm
  is '税务机关代码';
comment on column EDOC_EXAMINE_BUSINESS.qylx
  is '企业类型  1:内资生产企业  2:
外商投资企业
3:外贸（工贸）企业
 9:其他（特许退税）企业';
comment on column EDOC_EXAMINE_BUSINESS.flglcd
  is '分类管理登记(A、B、C、D)';
comment on column EDOC_EXAMINE_BUSINESS.balx
  is '备案类型  0-数字化备案 1-纸质备案';
comment on column EDOC_EXAMINE_BUSINESS.status
  is '状态  0-未下达 1-已下达(已退回)，2，已收讫， 3-已上报，4-已审核';
comment on column EDOC_EXAMINE_BUSINESS.releaser
  is '下达人';
comment on column EDOC_EXAMINE_BUSINESS.release_time
  is '下达时间  yyyy-mm-dd hh:mm:ss';
comment on column EDOC_EXAMINE_BUSINESS.report_time
  is '上报时间 yyyy-mm-dd hh:mm:ss';
comment on column EDOC_EXAMINE_BUSINESS.overdule
  is '逾期时间 yyyy-mm-dd';
comment on column EDOC_EXAMINE_BUSINESS.examiner
  is '审核人';
comment on column EDOC_EXAMINE_BUSINESS.examine_time
  is '审核时间 yyyy-mm-dd hh:mm:ss';
comment on column EDOC_EXAMINE_BUSINESS.examine_result
  is '审核结论 （0-暂未发现问题、1-检查有问题）';
comment on column EDOC_EXAMINE_BUSINESS.examine_note
  is '审核意见';
comment on column EDOC_EXAMINE_BUSINESS.back_count
  is '退回次数';
comment on column EDOC_EXAMINE_BUSINESS.back_reason
  is '退回原因';
comment on column EDOC_EXAMINE_BUSINESS.sbywzl
  is '申报业务种类';
comment on column EDOC_EXAMINE_BUSINESS.sbnypc
  is '申报年月批次  比如202201-001';
comment on column EDOC_EXAMINE_BUSINESS.sbrq
  is '申报日期  yyyy-mm';
comment on column EDOC_EXAMINE_BUSINESS.entry_id
  is '18位出口报关单号或代理证明号';
comment on column EDOC_EXAMINE_BUSINESS.ywlx_code
  is '业务类型代码，以逗号隔开';
comment on column EDOC_EXAMINE_BUSINESS.ckfp_no
  is '出口发票号码，以逗号隔开';
comment on column EDOC_EXAMINE_BUSINESS.jhfp_no
  is '进项发票号码，以逗号隔开';
comment on column EDOC_EXAMINE_BUSINESS.je
  is '出口销售额-FOB价(美元)';
comment on column EDOC_EXAMINE_BUSINESS.se
  is '申报退免税额';
comment on column EDOC_EXAMINE_BUSINESS.yjsl
  is '预警数量   N:标识有N条三新预警，关联三新预警表';
comment on column EDOC_EXAMINE_BUSINESS.skclbz
  is '收款处理标志 1不予退税2已退税返纳，空表示不处理';
comment on column EDOC_EXAMINE_BUSINESS.skclje
  is '收款处理金额';
comment on column EDOC_EXAMINE_BUSINESS.lxr
  is '联系人';
comment on column EDOC_EXAMINE_BUSINESS.lxdh
  is '联系电话';
comment on column EDOC_EXAMINE_BUSINESS.range
  is '单证核查范围,以json方式存储';
comment on column EDOC_EXAMINE_BUSINESS.void_flag
  is '作废标志 0:未作废  1:已作废';
comment on column EDOC_EXAMINE_BUSINESS.voider
  is '作废人';
comment on column EDOC_EXAMINE_BUSINESS.void_time
  is '作废时间 yyyy-mm-dd hh:mm:ss';
comment on column EDOC_EXAMINE_BUSINESS.cjsj
  is '创建时间 yyyy-mm-dd hh:mm:ss';
comment on column EDOC_EXAMINE_BUSINESS.xgsj
  is '修改时间 yyyy-mm-dd hh:mm:ss';
comment on column EDOC_EXAMINE_BUSINESS.note
  is '备注';
comment on column EDOC_EXAMINE_BUSINESS.tsjsfs_chg
  is '退税计算方式变更,当不为空的时候代表企业变更前退税计算方式，否则默认为现有的退税计算方式';
comment on column EDOC_EXAMINE_BUSINESS.dzqqbz
  is '单证齐全标志 0-未齐全 1-已齐全';
create index IDX_EDOC_EXAMINE_BUSINESS_NE on EDOC_EXAMINE_BUSINESS (NSRSBH, ENTRY_ID);
create index IDX_EDOC_EXAMINE_BUSINESS_SJ on EDOC_EXAMINE_BUSINESS (RELEASE_TIME, REPORT_TIME, OVERDULE);
create index IDX_EDOC_EXAMINE_BUSINESS_SWJG on EDOC_EXAMINE_BUSINESS (SWJGDM);
create unique index UDX_EXAMINE_BUSINESS_NSSE on EDOC_EXAMINE_BUSINESS (NSRSBH, SBYWZL, SBNYPC, ENTRY_ID);
alter table EDOC_EXAMINE_BUSINESS
  add constraint PK_EDOC_EXAMINE_BUSINESS primary key (ID);

prompt
prompt Creating table EDOC_FILE_INFO
prompt =============================
prompt
create table EDOC_FILE_INFO
(
  edoc_id         NUMBER(20) not null,
  edoc_name       VARCHAR2(300),
  edoc_type       VARCHAR2(10) not null,
  md5             VARCHAR2(40),
  edoc_no         VARCHAR2(64),
  edoc_size       VARCHAR2(255),
  edoc_path       VARCHAR2(255),
  edoc_local_path VARCHAR2(255),
  crtime          TIMESTAMP(6),
  uptime          TIMESTAMP(6),
  sign_status     CHAR(1),
  use_number      INTEGER,
  remark          VARCHAR2(255),
  fill_date       DATE
)
;
comment on table EDOC_FILE_INFO
  is '单证文件信息表';
comment on column EDOC_FILE_INFO.edoc_id
  is '单证文件id，主键';
comment on column EDOC_FILE_INFO.edoc_name
  is '文件名称（默认使用单证类型中文拼接业务代码+申报年月+批次，企业可修改）';
comment on column EDOC_FILE_INFO.edoc_type
  is '单证类型';
comment on column EDOC_FILE_INFO.md5
  is 'MD5（存储文件的MD5值，以校验文档是否发生变动）
';
comment on column EDOC_FILE_INFO.edoc_no
  is '单证号码';
comment on column EDOC_FILE_INFO.edoc_size
  is '文件大小，单位K';
comment on column EDOC_FILE_INFO.edoc_path
  is '文件路径';
comment on column EDOC_FILE_INFO.edoc_local_path
  is '本地路径';
comment on column EDOC_FILE_INFO.crtime
  is '创建日期';
comment on column EDOC_FILE_INFO.uptime
  is '修改日期';
comment on column EDOC_FILE_INFO.sign_status
  is '签名状态.0-未加签,1-已加签';
comment on column EDOC_FILE_INFO.use_number
  is '引用次数';
comment on column EDOC_FILE_INFO.remark
  is '备注';
comment on column EDOC_FILE_INFO.fill_date
  is '验证日期';
alter table EDOC_FILE_INFO
  add constraint EDOC_FILE_INFO_PRIMARYKEY primary key (EDOC_ID);

prompt
prompt Creating table EDOC_INDEX_RANGE
prompt ===============================
prompt
create table EDOC_INDEX_RANGE
(
  id        NUMBER(20) not null,
  baxh      VARCHAR2(36) not null,
  nsrsbh    VARCHAR2(21),
  dzdl      CHAR(1) not null,
  edoc_type VARCHAR2(36) not null,
  edoc_flag CHAR(1) not null,
  crtime    TIMESTAMP(6) not null
)
;
comment on table EDOC_INDEX_RANGE
  is '单证索引范围表';
comment on column EDOC_INDEX_RANGE.baxh
  is '备案序号，对应edoc_record_task表中的baxh';
comment on column EDOC_INDEX_RANGE.nsrsbh
  is '纳税人识别号';
comment on column EDOC_INDEX_RANGE.dzdl
  is '单证大类 1-备案单证，2-申报单证，3-其他单证';
comment on column EDOC_INDEX_RANGE.edoc_type
  is '单证类型';
comment on column EDOC_INDEX_RANGE.edoc_flag
  is '单证标志 0-必备 1-市县局要求必备 2-非必备';
comment on column EDOC_INDEX_RANGE.crtime
  is '创建时间';
create index IDX_EDOC_INDEX_RANGE_BAXH on EDOC_INDEX_RANGE (BAXH);
alter table EDOC_INDEX_RANGE
  add constraint EDOC_INDEX_RANGE_PK primary key (ID);

prompt
prompt Creating table EDOC_INSPECT_BACK
prompt ================================
prompt
create table EDOC_INSPECT_BACK
(
  id          NUMBER(20) not null,
  hclx        CHAR(1) not null,
  inspect_no  NUMBER(20) not null,
  nsrsbh      VARCHAR2(21) not null,
  entry_id    VARCHAR2(18) not null,
  returnee    VARCHAR2(30),
  back_reason VARCHAR2(500),
  back_time   TIMESTAMP(6),
  cjsj        TIMESTAMP(6),
  xgsj        TIMESTAMP(6)
)
;
comment on table EDOC_INSPECT_BACK
  is '核查任务退回表(日常审单、年度核查)';
comment on column EDOC_INSPECT_BACK.id
  is '记录id';
comment on column EDOC_INSPECT_BACK.hclx
  is '核查类型(1:日常审单核查  2:年度单证核查)';
comment on column EDOC_INSPECT_BACK.inspect_no
  is '日常审单对应edoc_examine_business表主键, 年度单证核查对应edoc_inspect_business表主键';
comment on column EDOC_INSPECT_BACK.nsrsbh
  is '税号';
comment on column EDOC_INSPECT_BACK.entry_id
  is '报关单号';
comment on column EDOC_INSPECT_BACK.returnee
  is '退回人';
comment on column EDOC_INSPECT_BACK.back_reason
  is '退回原因';
comment on column EDOC_INSPECT_BACK.back_time
  is '退回时间';
comment on column EDOC_INSPECT_BACK.cjsj
  is '创建时间';
comment on column EDOC_INSPECT_BACK.xgsj
  is '修改时间';
create index IDX_EDOC_INSPECT_BACK_HI on EDOC_INSPECT_BACK (HCLX, INSPECT_NO);
alter table EDOC_INSPECT_BACK
  add constraint PK_EDOC_INSPECT_BACK primary key (ID);

prompt
prompt Creating table EDOC_INSPECT_BACK_INDEX
prompt ======================================
prompt
create table EDOC_INSPECT_BACK_INDEX
(
  id            NUMBER(20) not null,
  back_id       NUMBER(20) not null,
  edoc_type     VARCHAR2(10),
  dzdl          VARCHAR2(36),
  edoc_type_sub VARCHAR2(10),
  edoc_id       NUMBER(20),
  edoc_state    VARCHAR2(600),
  edoc_flag     CHAR(1),
  edoc_name     VARCHAR2(300),
  edoc_no       VARCHAR2(64),
  file_url      VARCHAR2(1000),
  remark        VARCHAR2(255),
  cjsj          TIMESTAMP(6),
  xgsj          TIMESTAMP(6)
)
;
comment on table EDOC_INSPECT_BACK_INDEX
  is '核查任务退回索引表';
comment on column EDOC_INSPECT_BACK_INDEX.id
  is '记录id';
comment on column EDOC_INSPECT_BACK_INDEX.back_id
  is '核查任务退回表edoc_inspect_back主键';
comment on column EDOC_INSPECT_BACK_INDEX.edoc_type
  is '单证类型';
comment on column EDOC_INSPECT_BACK_INDEX.dzdl
  is '单证大类(1、备案单证 2、申报单证 3、其它单证)';
comment on column EDOC_INSPECT_BACK_INDEX.edoc_type_sub
  is '单证详细类型';
comment on column EDOC_INSPECT_BACK_INDEX.edoc_id
  is '单证文件id';
comment on column EDOC_INSPECT_BACK_INDEX.edoc_state
  is '单证说明';
comment on column EDOC_INSPECT_BACK_INDEX.edoc_flag
  is '单证标志(0-必备   1-市县局 要求必备 2-非必备)';
comment on column EDOC_INSPECT_BACK_INDEX.edoc_name
  is '文件名称';
comment on column EDOC_INSPECT_BACK_INDEX.edoc_no
  is '单证号码';
comment on column EDOC_INSPECT_BACK_INDEX.file_url
  is '文件存储oss路径';
comment on column EDOC_INSPECT_BACK_INDEX.remark
  is '备注';
comment on column EDOC_INSPECT_BACK_INDEX.cjsj
  is '创建时间';
comment on column EDOC_INSPECT_BACK_INDEX.xgsj
  is '修改时间';
create index IDX_INSPECT_BACK_INDEX on EDOC_INSPECT_BACK_INDEX (BACK_ID);
alter table EDOC_INSPECT_BACK_INDEX
  add constraint PK_EDOC_INSPECT_BACK_INDEX primary key (ID);

prompt
prompt Creating table EDOC_INSPECT_BUSINESS
prompt ====================================
prompt
create table EDOC_INSPECT_BUSINESS
(
  id             NUMBER(20) not null,
  project_id     NUMBER(20) not null,
  status         CHAR(1) default 0 not null,
  sbywzl         VARCHAR2(10) not null,
  sbnypc         VARCHAR2(15) not null,
  sbrq           DATE not null,
  entry_id       VARCHAR2(18) not null,
  ywlx_code      VARCHAR2(30),
  je             NUMBER(15,2),
  se             NUMBER(15,2),
  releaser       VARCHAR2(30),
  release_time   TIMESTAMP(6),
  report_time    TIMESTAMP(6),
  examiner       VARCHAR2(30),
  examine_time   TIMESTAMP(6),
  examine_result CHAR(1),
  examine_note   VARCHAR2(500),
  returnee       VARCHAR2(30),
  back_time      TIMESTAMP(6),
  back_count     NUMBER(6) default 0,
  range          VARCHAR2(500),
  skclbz         CHAR(1),
  skclje         NUMBER(15,2),
  cjsj           TIMESTAMP(6) default sysdate not null,
  xgsj           TIMESTAMP(6),
  note           VARCHAR2(500),
  back_reason    VARCHAR2(1000),
  dzqqbz         CHAR(1)
)
;
comment on table EDOC_INSPECT_BUSINESS
  is '单证核查出口业务表';
comment on column EDOC_INSPECT_BUSINESS.id
  is '主键';
comment on column EDOC_INSPECT_BUSINESS.project_id
  is '单证核查立项表主键id';
comment on column EDOC_INSPECT_BUSINESS.status
  is '状态  0-创建 1-已下达(已退回)，2，已收讫， 3-已上报，4-已审核';
comment on column EDOC_INSPECT_BUSINESS.sbywzl
  is '申报业务种类';
comment on column EDOC_INSPECT_BUSINESS.sbnypc
  is '申报年月批次';
comment on column EDOC_INSPECT_BUSINESS.sbrq
  is '申报日期 yyyy-mm-dd';
comment on column EDOC_INSPECT_BUSINESS.entry_id
  is '18位报关单号/代理证明号';
comment on column EDOC_INSPECT_BUSINESS.ywlx_code
  is '业务类型代码';
comment on column EDOC_INSPECT_BUSINESS.je
  is '出口销售额-FOB价(美元)';
comment on column EDOC_INSPECT_BUSINESS.se
  is '申报退免税额';
comment on column EDOC_INSPECT_BUSINESS.releaser
  is '下达人';
comment on column EDOC_INSPECT_BUSINESS.release_time
  is '下达时间  yyyy-mm-dd hh:mm:ss';
comment on column EDOC_INSPECT_BUSINESS.report_time
  is '上报时间 yyyy-mm-dd hh:mm:ss';
comment on column EDOC_INSPECT_BUSINESS.examiner
  is '审核人';
comment on column EDOC_INSPECT_BUSINESS.examine_time
  is '审核时间 yyyy-mm-dd hh:mm:ss';
comment on column EDOC_INSPECT_BUSINESS.examine_result
  is '审核结论 0暂未发现问题/1检查有问题';
comment on column EDOC_INSPECT_BUSINESS.examine_note
  is '审核意见';
comment on column EDOC_INSPECT_BUSINESS.returnee
  is '退回人';
comment on column EDOC_INSPECT_BUSINESS.back_time
  is '退回时间 yyyy-mm-dd hh:mm:ss';
comment on column EDOC_INSPECT_BUSINESS.back_count
  is '退回次数  仅允许退回补正依次，取值0、1';
comment on column EDOC_INSPECT_BUSINESS.range
  is '单证核查范围';
comment on column EDOC_INSPECT_BUSINESS.skclbz
  is '收款处理标志  1不予退税2已退税返纳，空表示不处理';
comment on column EDOC_INSPECT_BUSINESS.skclje
  is '收款处理金额';
comment on column EDOC_INSPECT_BUSINESS.cjsj
  is '创建时间 yyyy-mm-dd hh:mm:ss';
comment on column EDOC_INSPECT_BUSINESS.xgsj
  is '修改时间 yyyy-mm-dd hh:mm:ss';
comment on column EDOC_INSPECT_BUSINESS.note
  is '备注';
comment on column EDOC_INSPECT_BUSINESS.back_reason
  is '退回原因';
comment on column EDOC_INSPECT_BUSINESS.dzqqbz
  is '单证齐全标志 0-未齐全 1-已齐全';
create index IDX_EDOC_INSPECT_BUSINESS_PID on EDOC_INSPECT_BUSINESS (PROJECT_ID);
create index IDX_INSPECT_BUSINESS_ENTRYID on EDOC_INSPECT_BUSINESS (ENTRY_ID);
create unique index UDX_EDOC_INSPECT_BUSINESS_PSSE on EDOC_INSPECT_BUSINESS (PROJECT_ID, SBYWZL, SBNYPC, ENTRY_ID);
alter table EDOC_INSPECT_BUSINESS
  add constraint PK_EDOC_INSPECT_BUSINESS primary key (ID);

prompt
prompt Creating table EDOC_INSPECT_CONFIGURE
prompt =====================================
prompt
create table EDOC_INSPECT_CONFIGURE
(
  id            NUMBER(20) not null,
  swjgdm        VARCHAR2(11) not null,
  config_type   CHAR(2) not null,
  config_value  CLOB,
  config_extend CLOB,
  cjsj          TIMESTAMP(6) default sysdate,
  xgsj          TIMESTAMP(6),
  note          VARCHAR2(200)
)
;
comment on table EDOC_INSPECT_CONFIGURE
  is '单证核查基础配置表';
comment on column EDOC_INSPECT_CONFIGURE.id
  is '主键';
comment on column EDOC_INSPECT_CONFIGURE.swjgdm
  is '税务机关代码';
comment on column EDOC_INSPECT_CONFIGURE.config_type
  is '配置类型 01:企业抽查比例  02:出口业务抽查比例 03:最大业务抽查数 04:意向的商品代码 05:敏感贸易国 06:FOB价起点';
comment on column EDOC_INSPECT_CONFIGURE.config_value
  is '配置内容';
comment on column EDOC_INSPECT_CONFIGURE.config_extend
  is '扩展内容';
comment on column EDOC_INSPECT_CONFIGURE.cjsj
  is '创建时间';
comment on column EDOC_INSPECT_CONFIGURE.xgsj
  is '更新时间';
comment on column EDOC_INSPECT_CONFIGURE.note
  is '备注';
create unique index UDX_INSPECT_CONFIGURE_ST on EDOC_INSPECT_CONFIGURE (SWJGDM, CONFIG_TYPE);
alter table EDOC_INSPECT_CONFIGURE
  add constraint PK_EDOC_INSPECT_CONFIGURE primary key (ID);

prompt
prompt Creating table EDOC_INSPECT_INTENTION
prompt =====================================
prompt
create table EDOC_INSPECT_INTENTION
(
  id     NUMBER(20) not null,
  nsrsbh VARCHAR2(21) not null,
  spdm   CLOB,
  mygjdq CLOB,
  fobqd  NUMBER(15,2),
  cjsj   TIMESTAMP(6) default sysdate,
  xgsj   TIMESTAMP(6),
  note   VARCHAR2(200)
)
;
comment on table EDOC_INSPECT_INTENTION
  is '单证核查项目意向关系表';
comment on column EDOC_INSPECT_INTENTION.id
  is '主键';
comment on column EDOC_INSPECT_INTENTION.nsrsbh
  is '纳税人识别号 0表示通用';
comment on column EDOC_INSPECT_INTENTION.spdm
  is '意向商品代码';
comment on column EDOC_INSPECT_INTENTION.mygjdq
  is '意向贸易国家及地区';
comment on column EDOC_INSPECT_INTENTION.fobqd
  is 'FOB价起点';
comment on column EDOC_INSPECT_INTENTION.cjsj
  is '创建时间';
comment on column EDOC_INSPECT_INTENTION.xgsj
  is '更新时间';
comment on column EDOC_INSPECT_INTENTION.note
  is '备注';
create index IDX_INSPECT_INTENTION_NSRSBH on EDOC_INSPECT_INTENTION (NSRSBH);
alter table EDOC_INSPECT_INTENTION
  add constraint PK_EDOC_INSPECT_INTENTION primary key (ID);

prompt
prompt Creating table EDOC_INSPECT_NOTICE
prompt ==================================
prompt
create table EDOC_INSPECT_NOTICE
(
  id         NUMBER(18) not null,
  inspect_no NUMBER(20),
  swjg_dm    VARCHAR2(11),
  wslx       VARCHAR2(20),
  nd         VARCHAR2(4),
  bh         VARCHAR2(10),
  zg         VARCHAR2(50),
  cjsj       TIMESTAMP(6),
  cjr        VARCHAR2(20),
  xdsj       TIMESTAMP(6),
  xdr        VARCHAR2(20),
  hzsj       TIMESTAMP(6),
  hznsr      VARCHAR2(20),
  noticeid   NUMBER(18),
  attachid   NUMBER(18)
)
;
comment on table EDOC_INSPECT_NOTICE
  is '税务事项通知书';
comment on column EDOC_INSPECT_NOTICE.inspect_no
  is '核查序号，对应edoc_inspect_task表主键';
comment on column EDOC_INSPECT_NOTICE.swjg_dm
  is '税务机关代码';
comment on column EDOC_INSPECT_NOTICE.wslx
  is '文书类型';
comment on column EDOC_INSPECT_NOTICE.nd
  is '年度';
comment on column EDOC_INSPECT_NOTICE.bh
  is '编号';
comment on column EDOC_INSPECT_NOTICE.zg
  is '文书字轨';
comment on column EDOC_INSPECT_NOTICE.cjsj
  is '创建时间';
comment on column EDOC_INSPECT_NOTICE.cjr
  is '创建人';
comment on column EDOC_INSPECT_NOTICE.xdsj
  is '下达时间';
comment on column EDOC_INSPECT_NOTICE.xdr
  is '下达人';
comment on column EDOC_INSPECT_NOTICE.hzsj
  is '回执时间';
comment on column EDOC_INSPECT_NOTICE.hznsr
  is '回执纳税人';
comment on column EDOC_INSPECT_NOTICE.noticeid
  is '通知id(对应fg_notice_qy_sync2yun表的主键)';
comment on column EDOC_INSPECT_NOTICE.attachid
  is '附件id(对应fg_notice_qy_attach)';
create unique index IDX_EDOC_INSPECT_NOTICE on EDOC_INSPECT_NOTICE (SWJG_DM, WSLX, ND, BH);
alter table EDOC_INSPECT_NOTICE
  add constraint PK_EDOC_INSPECT_NOTICE primary key (ID);

prompt
prompt Creating table EDOC_INSPECT_PROJECT
prompt ===================================
prompt
create table EDOC_INSPECT_PROJECT
(
  id             NUMBER(20) not null,
  nsrsbh         VARCHAR2(21) not null,
  nsrmc          VARCHAR2(100) not null,
  qyhgdm         VARCHAR2(20) not null,
  swjgdm         VARCHAR2(11) not null,
  qylx           CHAR(1) not null,
  flglcd         CHAR(1) not null,
  balx           CHAR(1) default 0,
  year           VARCHAR2(4) not null,
  source         CHAR(1) default 0,
  status         CHAR(1) default 0 not null,
  approve_time   TIMESTAMP(6),
  deadline       DATE,
  ywbs           NUMBER(6),
  inspector      VARCHAR2(30),
  inspect_time   TIMESTAMP(6),
  inspect_note   VARCHAR2(500),
  project_result CHAR(1),
  reviewer       VARCHAR2(30),
  review_time    TIMESTAMP(6),
  review_note    VARCHAR2(500),
  issuer         VARCHAR2(30),
  issue_time     TIMESTAMP(6),
  void_flag      CHAR(1) default 0,
  voider         VARCHAR2(30),
  void_time      TIMESTAMP(6),
  receipt_flag   CHAR(1) default 0,
  receipt_time   TIMESTAMP(6),
  qygm           VARCHAR2(2),
  ywccbl         NUMBER(15,2),
  lxr            VARCHAR2(40),
  lxdh           VARCHAR2(30),
  cjsj           TIMESTAMP(6) default sysdate not null,
  xgsj           TIMESTAMP(6),
  note           VARCHAR2(500)
)
;
comment on table EDOC_INSPECT_PROJECT
  is '单证核查项目表';
comment on column EDOC_INSPECT_PROJECT.id
  is '主键';
comment on column EDOC_INSPECT_PROJECT.nsrsbh
  is '纳税人识别号';
comment on column EDOC_INSPECT_PROJECT.nsrmc
  is '纳税人名称';
comment on column EDOC_INSPECT_PROJECT.qyhgdm
  is '企业海关代码';
comment on column EDOC_INSPECT_PROJECT.swjgdm
  is '税务机关代码';
comment on column EDOC_INSPECT_PROJECT.qylx
  is '企业类型  1:内资生产企业  2:
外商投资企业
3:外贸（工贸）企业
 9:其他（特许退税）企业';
comment on column EDOC_INSPECT_PROJECT.flglcd
  is '分类管理等级(A、B、C、D)';
comment on column EDOC_INSPECT_PROJECT.balx
  is '备案类型  0-数字化备案 1-纸质备案';
comment on column EDOC_INSPECT_PROJECT.year
  is '立项年度';
comment on column EDOC_INSPECT_PROJECT.source
  is '项目来源   0 指定 1随机';
comment on column EDOC_INSPECT_PROJECT.status
  is '项目状态  0 创建、1 审核、2复核、3发放、9结案';
comment on column EDOC_INSPECT_PROJECT.approve_time
  is '立项日期   yyyy-mm-dd hh:mm:ss';
comment on column EDOC_INSPECT_PROJECT.deadline
  is '项目期限 yyyy-mm-dd ';
comment on column EDOC_INSPECT_PROJECT.ywbs
  is '业务笔数';
comment on column EDOC_INSPECT_PROJECT.inspector
  is '审核人';
comment on column EDOC_INSPECT_PROJECT.inspect_time
  is '核查完成日期 yyyy-mm-dd hh:mm:ss';
comment on column EDOC_INSPECT_PROJECT.inspect_note
  is '核查意见';
comment on column EDOC_INSPECT_PROJECT.project_result
  is '项目结论  1合格2整改后合格3不合格';
comment on column EDOC_INSPECT_PROJECT.reviewer
  is '复核人';
comment on column EDOC_INSPECT_PROJECT.review_time
  is '复核日期';
comment on column EDOC_INSPECT_PROJECT.review_note
  is '复核意见';
comment on column EDOC_INSPECT_PROJECT.issuer
  is '发放人';
comment on column EDOC_INSPECT_PROJECT.issue_time
  is '发放日期 yyyy-mm-dd hh:mm:ss';
comment on column EDOC_INSPECT_PROJECT.void_flag
  is '作废标志 0: 正常  1:作废';
comment on column EDOC_INSPECT_PROJECT.voider
  is '作废人';
comment on column EDOC_INSPECT_PROJECT.void_time
  is '作废时间';
comment on column EDOC_INSPECT_PROJECT.receipt_flag
  is '回证标志 0-未回证 1-已回证';
comment on column EDOC_INSPECT_PROJECT.receipt_time
  is '回证时间 yyyy-mm-dd hh:mm:ss';
comment on column EDOC_INSPECT_PROJECT.qygm
  is '企业规模';
comment on column EDOC_INSPECT_PROJECT.ywccbl
  is '业务抽查比例';
comment on column EDOC_INSPECT_PROJECT.lxr
  is '联系人';
comment on column EDOC_INSPECT_PROJECT.lxdh
  is '联系电话';
comment on column EDOC_INSPECT_PROJECT.cjsj
  is '创建时间';
comment on column EDOC_INSPECT_PROJECT.xgsj
  is '修改时间';
comment on column EDOC_INSPECT_PROJECT.note
  is '备注';
create index IDX_INSPECT_PROJECT_RN on EDOC_INSPECT_PROJECT (REVIEW_NOTE);
create unique index UDX_INSPECT_PROJECT_NYV on EDOC_INSPECT_PROJECT (NSRSBH, YEAR, VOID_FLAG);
alter table EDOC_INSPECT_PROJECT
  add constraint PK_EDOC_INSPECT_PROJECT primary key (ID);

prompt
prompt Creating table EDOC_INSPECT_PROJECT_DEL
prompt =======================================
prompt
create table EDOC_INSPECT_PROJECT_DEL
(
  id             NUMBER(20) not null,
  nsrsbh         VARCHAR2(21) not null,
  nsrmc          VARCHAR2(100) not null,
  qyhgdm         VARCHAR2(20) not null,
  swjgdm         VARCHAR2(11) not null,
  qylx           CHAR(1) not null,
  flglcd         CHAR(1) not null,
  balx           CHAR(1),
  year           VARCHAR2(4) not null,
  source         CHAR(1),
  status         CHAR(1) not null,
  approve_time   TIMESTAMP(6),
  deadline       DATE,
  ywbs           NUMBER(6),
  inspector      VARCHAR2(30),
  inspect_time   TIMESTAMP(6),
  inspect_note   VARCHAR2(500),
  project_result CHAR(1),
  reviewer       VARCHAR2(30),
  review_time    TIMESTAMP(6),
  review_note    VARCHAR2(500),
  issuer         VARCHAR2(30),
  issue_time     TIMESTAMP(6),
  void_flag      CHAR(1),
  voider         VARCHAR2(30),
  void_time      TIMESTAMP(6),
  receipt_flag   CHAR(1),
  receipt_time   TIMESTAMP(6),
  qygm           VARCHAR2(2),
  ywccbl         NUMBER(15,2),
  lxr            VARCHAR2(30),
  lxdh           VARCHAR2(30),
  cjsj           TIMESTAMP(6) not null,
  xgsj           TIMESTAMP(6),
  note           VARCHAR2(500)
)
;
comment on table EDOC_INSPECT_PROJECT_DEL
  is '单证核查项目作废表';
comment on column EDOC_INSPECT_PROJECT_DEL.id
  is '主键';
comment on column EDOC_INSPECT_PROJECT_DEL.nsrsbh
  is '纳税人识别号';
comment on column EDOC_INSPECT_PROJECT_DEL.nsrmc
  is '纳税人名称';
comment on column EDOC_INSPECT_PROJECT_DEL.qyhgdm
  is '企业海关代码';
comment on column EDOC_INSPECT_PROJECT_DEL.swjgdm
  is '税务机关代码';
comment on column EDOC_INSPECT_PROJECT_DEL.qylx
  is '企业类型  1:内资生产企业  2:
外商投资企业
3:外贸（工贸）企业
 9:其他（特许退税）企业';
comment on column EDOC_INSPECT_PROJECT_DEL.flglcd
  is '分类管理等级(A、B、C、D)';
comment on column EDOC_INSPECT_PROJECT_DEL.balx
  is '备案类型  0-数字化备案 1-纸质备案';
comment on column EDOC_INSPECT_PROJECT_DEL.year
  is '立项年度';
comment on column EDOC_INSPECT_PROJECT_DEL.source
  is '项目来源   0 指定 1随机';
comment on column EDOC_INSPECT_PROJECT_DEL.status
  is '项目状态  0 创建、1 审核、2复核、3发放、9结案';
comment on column EDOC_INSPECT_PROJECT_DEL.approve_time
  is '立项日期   yyyy-mm-dd hh:mm:ss';
comment on column EDOC_INSPECT_PROJECT_DEL.deadline
  is '项目期限 yyyy-mm-dd ';
comment on column EDOC_INSPECT_PROJECT_DEL.ywbs
  is '业务笔数';
comment on column EDOC_INSPECT_PROJECT_DEL.inspector
  is '审核人';
comment on column EDOC_INSPECT_PROJECT_DEL.inspect_time
  is '核查完成日期 yyyy-mm-dd hh:mm:ss';
comment on column EDOC_INSPECT_PROJECT_DEL.inspect_note
  is '核查意见';
comment on column EDOC_INSPECT_PROJECT_DEL.project_result
  is '项目结论  1合格2整改后合格3不合格';
comment on column EDOC_INSPECT_PROJECT_DEL.reviewer
  is '复核人';
comment on column EDOC_INSPECT_PROJECT_DEL.review_time
  is '复核日期';
comment on column EDOC_INSPECT_PROJECT_DEL.review_note
  is '复核意见';
comment on column EDOC_INSPECT_PROJECT_DEL.issuer
  is '发放人';
comment on column EDOC_INSPECT_PROJECT_DEL.issue_time
  is '发放日期 yyyy-mm-dd hh:mm:ss';
comment on column EDOC_INSPECT_PROJECT_DEL.void_flag
  is '作废标志 0: 正常  1:作废';
comment on column EDOC_INSPECT_PROJECT_DEL.voider
  is '作废人';
comment on column EDOC_INSPECT_PROJECT_DEL.void_time
  is '作废时间';
comment on column EDOC_INSPECT_PROJECT_DEL.receipt_flag
  is '回证标志 0-未回证 1-已回证';
comment on column EDOC_INSPECT_PROJECT_DEL.receipt_time
  is '回证时间 yyyy-mm-dd hh:mm:ss';
comment on column EDOC_INSPECT_PROJECT_DEL.qygm
  is '企业规模';
comment on column EDOC_INSPECT_PROJECT_DEL.ywccbl
  is '业务抽查比例';
comment on column EDOC_INSPECT_PROJECT_DEL.lxr
  is '联系人';
comment on column EDOC_INSPECT_PROJECT_DEL.lxdh
  is '联系电话';
comment on column EDOC_INSPECT_PROJECT_DEL.cjsj
  is '创建时间';
comment on column EDOC_INSPECT_PROJECT_DEL.xgsj
  is '修改时间';
comment on column EDOC_INSPECT_PROJECT_DEL.note
  is '备注';
alter table EDOC_INSPECT_PROJECT_DEL
  add constraint PK_EDOC_INSPECT_PROJECT_DEL primary key (ID);

prompt
prompt Creating table EDOC_INSPECT_SUMMARY
prompt ===================================
prompt
create table EDOC_INSPECT_SUMMARY
(
  id         NUMBER(20) not null,
  nsrsbh     VARCHAR2(21) not null,
  swjgdm     VARCHAR2(11) not null,
  qylx       CHAR(1),
  year       CHAR(4) not null,
  bgd_count  NUMBER(6),
  sbpc_count NUMBER(6),
  je_total   NUMBER(15,2),
  se_total   NUMBER(15,2),
  qygm       VARCHAR2(2),
  cjsj       TIMESTAMP(6) default sysdate,
  xgsj       TIMESTAMP(6),
  note       VARCHAR2(200)
)
;
comment on table EDOC_INSPECT_SUMMARY
  is '企业年度申报汇总信息表';
comment on column EDOC_INSPECT_SUMMARY.id
  is '主键';
comment on column EDOC_INSPECT_SUMMARY.nsrsbh
  is '纳税人识别号';
comment on column EDOC_INSPECT_SUMMARY.swjgdm
  is '税务机关代码';
comment on column EDOC_INSPECT_SUMMARY.qylx
  is '企业类型';
comment on column EDOC_INSPECT_SUMMARY.year
  is '年度';
comment on column EDOC_INSPECT_SUMMARY.bgd_count
  is '报关单量';
comment on column EDOC_INSPECT_SUMMARY.sbpc_count
  is '申报批次数';
comment on column EDOC_INSPECT_SUMMARY.je_total
  is '申报总金额（美元）';
comment on column EDOC_INSPECT_SUMMARY.se_total
  is '退免税总额';
comment on column EDOC_INSPECT_SUMMARY.qygm
  is '企业规模';
comment on column EDOC_INSPECT_SUMMARY.cjsj
  is '创建时间';
comment on column EDOC_INSPECT_SUMMARY.xgsj
  is '更新时间';
comment on column EDOC_INSPECT_SUMMARY.note
  is '备注';
create unique index UDX_INSPECT_SUMMARY_NY on EDOC_INSPECT_SUMMARY (NSRSBH, YEAR);
alter table EDOC_INSPECT_SUMMARY
  add constraint PK_EDOC_INSPECT_SUMMARY primary key (ID);

prompt
prompt Creating table EDOC_INSPECT_TASK
prompt ================================
prompt
create table EDOC_INSPECT_TASK
(
  inspect_no     NUMBER(20) not null,
  nsrsbh         VARCHAR2(21) not null,
  nsrmc          VARCHAR2(100) not null,
  custom_code    VARCHAR2(20) not null,
  release_time   TIMESTAMP(6),
  deadline       DATE,
  inspect_state  VARCHAR2(500),
  status         CHAR(1) not null,
  inspect_result VARCHAR2(2),
  inspect_time   TIMESTAMP(6),
  report_time    TIMESTAMP(6),
  create_time    TIMESTAMP(6) not null,
  inspect_type   CHAR(1),
  self_check     CHAR(1),
  range          VARCHAR2(500),
  releaser       VARCHAR2(25),
  tax_notice     CLOB,
  remark         VARCHAR2(500),
  withdraw_count NUMBER(6) default 0
)
;
comment on table EDOC_INSPECT_TASK
  is '单证核查任务表';
comment on column EDOC_INSPECT_TASK.inspect_no
  is '核查序号 ，主键';
comment on column EDOC_INSPECT_TASK.nsrsbh
  is '纳税人识别号';
comment on column EDOC_INSPECT_TASK.nsrmc
  is '纳税人名称';
comment on column EDOC_INSPECT_TASK.custom_code
  is '海关代码';
comment on column EDOC_INSPECT_TASK.release_time
  is '下达日期';
comment on column EDOC_INSPECT_TASK.deadline
  is '资料报送期限';
comment on column EDOC_INSPECT_TASK.inspect_state
  is '核查说明';
comment on column EDOC_INSPECT_TASK.status
  is '状态   0-未下达 1-已下达，2，已收讫， 3-已上报，4-已审核';
comment on column EDOC_INSPECT_TASK.inspect_result
  is '核查结论10-正常  20-异常  为了便于扩展，以后以1开头的都代表正常 ，2开头代表异常 ，比如(21，22，23等，表示异常范围内的不同类型)';
comment on column EDOC_INSPECT_TASK.inspect_time
  is '核查日期 yyyy-mm-dd hh:mm:ss';
comment on column EDOC_INSPECT_TASK.report_time
  is '上报时间yyyy-mm-dd hh:mm:ss';
comment on column EDOC_INSPECT_TASK.create_time
  is '创建时间';
comment on column EDOC_INSPECT_TASK.inspect_type
  is '核查类型 1：核查（只需备案单证） 2、审单（全部单证）';
comment on column EDOC_INSPECT_TASK.self_check
  is '自查表标志(预留) 是否（Y/N） 是-要求企业填写其他类中的自查表';
comment on column EDOC_INSPECT_TASK.range
  is '单证类型范围，以逗号隔开，值为单证类型代码';
comment on column EDOC_INSPECT_TASK.releaser
  is '下达人';
comment on column EDOC_INSPECT_TASK.tax_notice
  is '税务事项通知书';
comment on column EDOC_INSPECT_TASK.remark
  is '备注';
comment on column EDOC_INSPECT_TASK.withdraw_count
  is '返回的次数(当status=1,withdraw_count=0时，前端展示已下达，当status=1,withdraw_count>0时，前端展示已退回)';
create index TL_BJTS.IDX_EDOC_INSPECT_TASK_NSRSBH on EDOC_INSPECT_TASK (NSRSBH);
alter table EDOC_INSPECT_TASK
  add constraint EDOC_INSPECT_TASK_PRIMARYKEY primary key (INSPECT_NO);

prompt
prompt Creating table EDOC_INSPECT_TASK_MX
prompt ===================================
prompt
create table EDOC_INSPECT_TASK_MX
(
  id             NUMBER(20) not null,
  inspect_no     NUMBER(20) not null,
  sbnypc         VARCHAR2(36) not null,
  sbrq           DATE,
  entry_id       VARCHAR2(18),
  inspect_result VARCHAR2(1) not null,
  result_state   VARCHAR2(500),
  inspector      VARCHAR2(30),
  examine_time   TIMESTAMP(6),
  process_type   CHAR(2),
  sbywzl         VARCHAR2(36),
  ckfp_no        VARCHAR2(3000),
  jhfp_no        VARCHAR2(3000),
  je             NUMBER(15,2),
  se             NUMBER(15,2),
  choice_flag    CHAR(1),
  slrq           DATE
)
;
comment on table EDOC_INSPECT_TASK_MX
  is '核查任务子表';
comment on column EDOC_INSPECT_TASK_MX.id
  is '主键';
comment on column EDOC_INSPECT_TASK_MX.inspect_no
  is '核查序号';
comment on column EDOC_INSPECT_TASK_MX.sbnypc
  is '申报年月批次';
comment on column EDOC_INSPECT_TASK_MX.sbrq
  is '申报日期';
comment on column EDOC_INSPECT_TASK_MX.entry_id
  is '18位报关单号或者代理证明号';
comment on column EDOC_INSPECT_TASK_MX.inspect_result
  is '核查结果,0-待审核，1-通过，2-不通过';
comment on column EDOC_INSPECT_TASK_MX.result_state
  is '结果说明';
comment on column EDOC_INSPECT_TASK_MX.inspector
  is '审核人';
comment on column EDOC_INSPECT_TASK_MX.examine_time
  is '审核时间';
comment on column EDOC_INSPECT_TASK_MX.process_type
  is '处理类型';
comment on column EDOC_INSPECT_TASK_MX.sbywzl
  is '申报业务种类';
comment on column EDOC_INSPECT_TASK_MX.ckfp_no
  is '出口发票';
comment on column EDOC_INSPECT_TASK_MX.jhfp_no
  is '进货发票';
comment on column EDOC_INSPECT_TASK_MX.je
  is '金额';
comment on column EDOC_INSPECT_TASK_MX.se
  is '税额';
comment on column EDOC_INSPECT_TASK_MX.choice_flag
  is '已选标志(0-可选  1-已选)';
comment on column EDOC_INSPECT_TASK_MX.slrq
  is '受理日期';
create unique index UIDX_EDOC_INSPECT_MX_INSPECT on EDOC_INSPECT_TASK_MX (INSPECT_NO);
alter table EDOC_INSPECT_TASK_MX
  add constraint EDOC_INSPECT_PRIMARYKEY primary key (ID);

prompt
prompt Creating table EDOC_RECORD_TASK
prompt ===============================
prompt
create table EDOC_RECORD_TASK
(
  id         NUMBER(20) not null,
  nsrsbh     VARCHAR2(21) not null,
  baxh       VARCHAR2(36) not null,
  sbywzl     VARCHAR2(15) not null,
  sbnypc     VARCHAR2(36) not null,
  sbrq       DATE not null,
  ddrq       DATE,
  slrq       DATE,
  baqx       DATE,
  bazt       CHAR(1) not null,
  basj       TIMESTAMP(6),
  je_total   NUMBER(15,2),
  se_total   NUMBER(15,2),
  creat_time TIMESTAMP(6),
  sbqx       DATE,
  ckywbs     NUMBER(6),
  dzfs       NUMBER(6)
)
;
comment on table EDOC_RECORD_TASK
  is '单证备案任务表';
comment on column EDOC_RECORD_TASK.id
  is '主键id';
comment on column EDOC_RECORD_TASK.nsrsbh
  is '纳税人识别号';
comment on column EDOC_RECORD_TASK.baxh
  is '备案序号由本系统生成，可采用UUID，与单证备案目录关联';
comment on column EDOC_RECORD_TASK.sbywzl
  is '申报业务种类';
comment on column EDOC_RECORD_TASK.sbnypc
  is '申报年月批次';
comment on column EDOC_RECORD_TASK.sbrq
  is '申报日期';
comment on column EDOC_RECORD_TASK.ddrq
  is '接收到备案任务的日期';
comment on column EDOC_RECORD_TASK.slrq
  is '出具受理通知书日期';
comment on column EDOC_RECORD_TASK.baqx
  is '备案期限（yyyy-mm-dd）';
comment on column EDOC_RECORD_TASK.bazt
  is '备案状态。1-待备案，2-备案中，3-备案完成';
comment on column EDOC_RECORD_TASK.basj
  is '备案时间（即归档时间）';
comment on column EDOC_RECORD_TASK.je_total
  is '总金额';
comment on column EDOC_RECORD_TASK.se_total
  is '总税额';
comment on column EDOC_RECORD_TASK.creat_time
  is '创建时间';
comment on column EDOC_RECORD_TASK.sbqx
  is '上报期限';
comment on column EDOC_RECORD_TASK.ckywbs
  is '出口业务笔数';
comment on column EDOC_RECORD_TASK.dzfs
  is '单证份数';
alter table EDOC_RECORD_TASK
  add constraint EDOC_RECORD_TASK_PRIMARYKEY primary key (ID);
alter table EDOC_RECORD_TASK
  add constraint IDX_EDOC_RECORD_TASK_NSS unique (NSRSBH, SBYWZL, SBNYPC);

prompt
prompt Creating table EDOC_RECORD_TRIGGER
prompt ==================================
prompt
create table EDOC_RECORD_TRIGGER
(
  sbid NUMBER(18) not null,
  tqbz VARCHAR2(40),
  tqsj TIMESTAMP(6),
  tqcs NUMBER(10),
  bz   VARCHAR2(500),
  cjsj TIMESTAMP(6),
  type CHAR(2)
)
;
comment on table EDOC_RECORD_TRIGGER
  is '生成备案任务触发表（触发器产生）';
comment on column EDOC_RECORD_TRIGGER.sbid
  is 'sb_sbxx_hz表主键';
comment on column EDOC_RECORD_TRIGGER.tqbz
  is '提取标志';
comment on column EDOC_RECORD_TRIGGER.tqsj
  is '提取时间';
comment on column EDOC_RECORD_TRIGGER.tqcs
  is '提取次数';
comment on column EDOC_RECORD_TRIGGER.bz
  is '备注';
comment on column EDOC_RECORD_TRIGGER.cjsj
  is '创建时间';
comment on column EDOC_RECORD_TRIGGER.type
  is '触发类型(10-生成备案任务 20-申报撤回)';
alter table EDOC_RECORD_TRIGGER
  add constraint EDOC_RECORD_TRIGGER primary key (SBID);

prompt
prompt Creating table EDOC_RECORD_TRIGGER_JS
prompt =====================================
prompt
create table EDOC_RECORD_TRIGGER_JS
(
  busikey VARCHAR2(50) not null,
  tqbz    VARCHAR2(40),
  tqsj    TIMESTAMP(6),
  tqcs    NUMBER(6) default 0,
  sjly    CHAR(1) default '0' not null,
  bz      VARCHAR2(500),
  cjsj    TIMESTAMP(6) default sysdate,
  lcslid  VARCHAR2(32)
)
;
comment on table EDOC_RECORD_TRIGGER_JS
  is '备案任务触发-从金三获取数据';
comment on column EDOC_RECORD_TRIGGER_JS.busikey
  is '业务主键(规范:税号|申报业务种类|所属时期|申报批次)';
comment on column EDOC_RECORD_TRIGGER_JS.tqbz
  is '提取标志';
comment on column EDOC_RECORD_TRIGGER_JS.tqsj
  is '提取时间';
comment on column EDOC_RECORD_TRIGGER_JS.tqcs
  is '提取次数';
comment on column EDOC_RECORD_TRIGGER_JS.sjly
  is '数据来源   0:bjts触发产生  1:同步历史备案任务';
comment on column EDOC_RECORD_TRIGGER_JS.bz
  is '备注';
comment on column EDOC_RECORD_TRIGGER_JS.cjsj
  is '创建时间';
comment on column EDOC_RECORD_TRIGGER_JS.lcslid
  is '流程实例ID';
alter table EDOC_RECORD_TRIGGER_JS
  add constraint PK_EDOC_RECORD_TRIGGER_HIS primary key (BUSIKEY, SJLY);

prompt
prompt Creating table EDOC_RECORD_TRIGGER_RESULT
prompt =========================================
prompt
create table EDOC_RECORD_TRIGGER_RESULT
(
  busikey VARCHAR2(50) not null,
  cljg    CHAR(1),
  msg     VARCHAR2(3000),
  cjsj    TIMESTAMP(6),
  xgsj    TIMESTAMP(6),
  sjly    CHAR(1),
  lcslid  VARCHAR2(32)
)
;
comment on table EDOC_RECORD_TRIGGER_RESULT
  is '触发产生备案任务错误记录表(来自金三)';
comment on column EDOC_RECORD_TRIGGER_RESULT.busikey
  is '业务主键(规范:税号|申报业务种类|所属时期|申报批次)';
comment on column EDOC_RECORD_TRIGGER_RESULT.cljg
  is '处理结果 0-成功、1-失败';
comment on column EDOC_RECORD_TRIGGER_RESULT.msg
  is '失败时填入信息';
comment on column EDOC_RECORD_TRIGGER_RESULT.cjsj
  is '创建时间';
comment on column EDOC_RECORD_TRIGGER_RESULT.xgsj
  is '修改时间';
comment on column EDOC_RECORD_TRIGGER_RESULT.sjly
  is '数据来源,  空,0或者1为老版便捷退税触发器产生   2-自动轮询金三数据';
comment on column EDOC_RECORD_TRIGGER_RESULT.lcslid
  is '流程实例ID';
alter table EDOC_RECORD_TRIGGER_RESULT
  add constraint PK_TRIGGER_JS_ERROR primary key (BUSIKEY);

prompt
prompt Creating table EDOC_STORE
prompt =========================
prompt
create table EDOC_STORE
(
  id        NUMBER(20) not null,
  mainid    NUMBER(20) not null,
  type      CHAR(3) not null,
  record    CLOB,
  cjsj      TIMESTAMP(6) default sysdate not null,
  xgsj      TIMESTAMP(6),
  file_path VARCHAR2(1000)
)
;
comment on table EDOC_STORE
  is '单证备案存储大对象表';
comment on column EDOC_STORE.id
  is '主键';
comment on column EDOC_STORE.mainid
  is '对应存储对象表的主键';
comment on column EDOC_STORE.type
  is '类型(001:年度单证核查-税务事项通知书)';
comment on column EDOC_STORE.record
  is '存储的记录(以base64编码存储)';
comment on column EDOC_STORE.cjsj
  is '创建时间';
comment on column EDOC_STORE.xgsj
  is '修改时间';
comment on column EDOC_STORE.file_path
  is '文件相对路径';
create unique index UDX_EDOC_STORE_MT on EDOC_STORE (MAINID, TYPE);
alter table EDOC_STORE
  add constraint PK_EDOC_STORE primary key (ID);

prompt
prompt Creating table EDOC_YJXX_DATA
prompt =============================
prompt
create table EDOC_YJXX_DATA
(
  id        NUMBER(20) not null,
  hx_id     NUMBER(20),
  hclx      CHAR(1),
  yj_sbid   NUMBER(20),
  yj_id     NUMBER(20),
  zbcode    VARCHAR2(5),
  yj_record VARCHAR2(30),
  yj_object VARCHAR2(30),
  yj_msg    VARCHAR2(1000),
  yj_time   TIMESTAMP(6),
  entry_id  VARCHAR2(18)
)
;
comment on table EDOC_YJXX_DATA
  is '单证预警信息表';
comment on column EDOC_YJXX_DATA.id
  is '主键';
comment on column EDOC_YJXX_DATA.hx_id
  is '日常审单-出口业务表id';
comment on column EDOC_YJXX_DATA.hclx
  is '2-日常审单，冗余，默认2';
comment on column EDOC_YJXX_DATA.yj_sbid
  is '申报id  关联tl_admin.yj_data_yjxx的sbid+id';
comment on column EDOC_YJXX_DATA.yj_id
  is '预警信息id  关联tl_admin.yj_data_yjxx的sbid+id';
comment on column EDOC_YJXX_DATA.zbcode
  is '预警指标  10101 新增商品
10201 新增供货商
';
comment on column EDOC_YJXX_DATA.yj_record
  is '预警关联号 外贸存放关联号
生产存放申报序号
';
comment on column EDOC_YJXX_DATA.yj_object
  is '预警对象 商品代码
  供货商税号
';
comment on column EDOC_YJXX_DATA.yj_msg
  is '预警描述';
comment on column EDOC_YJXX_DATA.yj_time
  is '预警生成时间 ';
comment on column EDOC_YJXX_DATA.entry_id
  is '18位报关单号或代理证明号';
create index IDX_EDOC_YJXX_DATA_HXID on EDOC_YJXX_DATA (HX_ID);
create unique index UDX_EDOC_YJXX_DATA on EDOC_YJXX_DATA (YJ_SBID, YJ_ID);
alter table EDOC_YJXX_DATA
  add constraint PK_EDOC_YJXX_DATA primary key (ID);

prompt
prompt Creating table FG_BLQY_INFO
prompt ===========================
prompt
create table FG_BLQY_INFO
(
  id          NUMBER(18) not null,
  qyhgdm      VARCHAR2(20) not null,
  nsrsbh      VARCHAR2(21) not null,
  sjlx        VARCHAR2(2) not null,
  blxxnr      VARCHAR2(200),
  lrr         VARCHAR2(20) not null,
  lrrq        DATE not null,
  swjg_dm     VARCHAR2(11) not null,
  nsr_swjg_dm VARCHAR2(11) not null,
  fxjb        VARCHAR2(2) not null,
  fxms        VARCHAR2(200),
  rqq         DATE,
  rqz         DATE,
  yxbz        CHAR(1) not null,
  bz          VARCHAR2(200)
)
;
comment on table FG_BLQY_INFO
  is '辅助管理--不良企业信息表';
comment on column FG_BLQY_INFO.id
  is '主键';
comment on column FG_BLQY_INFO.qyhgdm
  is '海关代码';
comment on column FG_BLQY_INFO.nsrsbh
  is '纳税人识别号';
comment on column FG_BLQY_INFO.sjlx
  is '事件类型(1-函调
2-实地核查
3-稽查案件
4-评估核查
9-其他
)';
comment on column FG_BLQY_INFO.blxxnr
  is '不良信息内容';
comment on column FG_BLQY_INFO.lrr
  is '录入人';
comment on column FG_BLQY_INFO.lrrq
  is '录入日期';
comment on column FG_BLQY_INFO.swjg_dm
  is '录入人税务机关代码';
comment on column FG_BLQY_INFO.nsr_swjg_dm
  is '纳税人税务机关代码';
comment on column FG_BLQY_INFO.fxjb
  is '风险级别(1一级风险-低
2二级风险-中
3三级风险-高
)';
comment on column FG_BLQY_INFO.fxms
  is '风险描述';
comment on column FG_BLQY_INFO.rqq
  is '风险日期起';
comment on column FG_BLQY_INFO.rqz
  is '风险日期止';
comment on column FG_BLQY_INFO.yxbz
  is '有效标志(Y/N)';
comment on column FG_BLQY_INFO.bz
  is '备注';
create index IDX_FG_BLQY_INFO_NSRSBH on FG_BLQY_INFO (NSRSBH);
create index IDX_FG_BLQY_INFO_QYHGDM on FG_BLQY_INFO (QYHGDM);
alter table FG_BLQY_INFO
  add constraint PK_FG_BLQY_INFO primary key (ID);

prompt
prompt Creating table FG_CKTSFN_DZ_JGB
prompt ===============================
prompt
create table FG_CKTSFN_DZ_JGB
(
  id         NUMBER(18) not null,
  pzxh       VARCHAR2(20) not null,
  zsxm_dm    VARCHAR2(5) not null,
  zg_uuid    VARCHAR2(32),
  sjly       CHAR(1),
  nsrsbh     VARCHAR2(20),
  nsrmc      VARCHAR2(80),
  yt_amt     NUMBER(16,2),
  sb_ym      VARCHAR2(6),
  sb_pc      VARCHAR2(2),
  xh_flag    CHAR(1),
  xh_date    DATE,
  op_date    DATE,
  zg_se      NUMBER(16,2),
  zg_sjyjse  NUMBER(16,2),
  zg_rkse    NUMBER(16,2),
  zg_op_date DATE,
  swjg_dm    VARCHAR2(11),
  dzjg       CHAR(1),
  dz_date    DATE,
  clbz       CHAR(1) default ' ',
  cl_user    VARCHAR2(20),
  cl_date    DATE,
  clyj       VARCHAR2(255)
)
;
comment on table FG_CKTSFN_DZ_JGB
  is '辅助管理--出口退税返纳对账结果表';
comment on column FG_CKTSFN_DZ_JGB.id
  is '主键';
comment on column FG_CKTSFN_DZ_JGB.pzxh
  is '凭证序号';
comment on column FG_CKTSFN_DZ_JGB.zsxm_dm
  is '征收项目代码';
comment on column FG_CKTSFN_DZ_JGB.sjly
  is '数据来源(2:TSTHS、
1:TSTHS_FN
)';
comment on column FG_CKTSFN_DZ_JGB.nsrsbh
  is '纳税人识别号';
comment on column FG_CKTSFN_DZ_JGB.nsrmc
  is '纳税人名称';
comment on column FG_CKTSFN_DZ_JGB.yt_amt
  is '应补缴增值税';
comment on column FG_CKTSFN_DZ_JGB.sb_ym
  is '申报年月';
comment on column FG_CKTSFN_DZ_JGB.sb_pc
  is '申报批次';
comment on column FG_CKTSFN_DZ_JGB.xh_flag
  is '销号标志';
comment on column FG_CKTSFN_DZ_JGB.xh_date
  is '销号日期';
comment on column FG_CKTSFN_DZ_JGB.op_date
  is '操作时间（出口）';
comment on column FG_CKTSFN_DZ_JGB.zg_se
  is '返纳税额（征管）';
comment on column FG_CKTSFN_DZ_JGB.zg_sjyjse
  is '实际应缴税额';
comment on column FG_CKTSFN_DZ_JGB.zg_rkse
  is '实际入库税额';
comment on column FG_CKTSFN_DZ_JGB.zg_op_date
  is '操作时间（征管）';
comment on column FG_CKTSFN_DZ_JGB.swjg_dm
  is '税务机关代码(出口或征管)';
comment on column FG_CKTSFN_DZ_JGB.dzjg
  is '对账结果';
comment on column FG_CKTSFN_DZ_JGB.dz_date
  is '对账时间(默认系统时间)';
comment on column FG_CKTSFN_DZ_JGB.clbz
  is '处理标志(默认为空格
1已处理
)';
comment on column FG_CKTSFN_DZ_JGB.cl_user
  is '处理人';
comment on column FG_CKTSFN_DZ_JGB.cl_date
  is '处理时间';
comment on column FG_CKTSFN_DZ_JGB.clyj
  is '处理意见';
create unique index UQ_FG_CKTSFN_DZ_JGB on FG_CKTSFN_DZ_JGB (PZXH, ZSXM_DM, ZG_UUID);
alter table FG_CKTSFN_DZ_JGB
  add constraint PK_FG_CKTSFN_DZ_JGB primary key (ID);

prompt
prompt Creating table FG_CKTSFN_HXZG
prompt =============================
prompt
create table FG_CKTSFN_HXZG
(
  spuuid        VARCHAR2(32) not null,
  skssswjg_dm   VARCHAR2(11),
  djxh          NUMBER(20),
  cpcode        VARCHAR2(32),
  qyhgdm        VARCHAR2(32),
  nsrsbh        VARCHAR2(20),
  nsrmc         VARCHAR2(80),
  zsuuid        VARCHAR2(32),
  dzsphm        NUMBER(20),
  dzspmxxh      NUMBER(8),
  zsxm_dm       VARCHAR2(5),
  sksx_dm       CHAR(4),
  yskm_dm       VARCHAR2(9),
  bz            VARCHAR2(3000),
  skssqq        DATE,
  skssqz        DATE,
  kjrq          DATE,
  jsyj          NUMBER(22,6),
  jkqx          DATE,
  rkrq          DATE,
  sjje          NUMBER(18,2),
  yzpzxh_ckts   VARCHAR2(32),
  xgrq          DATE,
  sjtb_date     DATE default sysdate,
  dzjg          CHAR(1),
  skssswjg_js   VARCHAR2(11),
  yzhytmskyy_dm VARCHAR2(3),
  ywhzbuuid     VARCHAR2(32)
)
;
comment on column FG_CKTSFN_HXZG.skssswjg_dm
  is '用备案信息中的swjg代替';
comment on column FG_CKTSFN_HXZG.skssswjg_js
  is '保存金三的SKSSSWJG_DM';
comment on column FG_CKTSFN_HXZG.yzhytmskyy_dm
  is '应追回已退（免）税款原因代码';
comment on column FG_CKTSFN_HXZG.ywhzbuuid
  is '业务核准表UUID';
create index IDX_FG_CKTSFN_HXZG_DJXH on FG_CKTSFN_HXZG (DJXH)
  nologging;
create index IDX_FG_CKTSFN_HXZG_SR on FG_CKTSFN_HXZG (SKSSSWJG_DM, RKRQ)
  nologging;
alter table FG_CKTSFN_HXZG
  add constraint PK_FG_CKTSFN_HXZG primary key (SPUUID);

prompt
prompt Creating table FG_CKTSFN_HXZG_YGP
prompt =================================
prompt
create table FG_CKTSFN_HXZG_YGP
(
  spuuid        VARCHAR2(32) not null,
  skssswjg_dm   VARCHAR2(11),
  djxh          NUMBER(20),
  cpcode        VARCHAR2(32),
  qyhgdm        VARCHAR2(32),
  nsrsbh        VARCHAR2(20),
  nsrmc         VARCHAR2(80),
  zsuuid        VARCHAR2(32),
  dzsphm        NUMBER(20),
  dzspmxxh      NUMBER(8),
  zsxm_dm       VARCHAR2(5),
  sksx_dm       CHAR(4),
  yskm_dm       VARCHAR2(9),
  bz            VARCHAR2(3000),
  skssqq        DATE,
  skssqz        DATE,
  kjrq          DATE,
  jsyj          NUMBER(22,6),
  jkqx          DATE,
  rkrq          DATE,
  sjje          NUMBER(18,2),
  yzpzxh_ckts   VARCHAR2(32),
  xgrq          DATE,
  sjtb_date     DATE default sysdate,
  dzjg          CHAR(1),
  skssswjg_js   VARCHAR2(11),
  yzhytmskyy_dm VARCHAR2(3),
  ywhzbuuid     VARCHAR2(32)
)
;

prompt
prompt Creating table FG_CKTSFN_TSSH
prompt =============================
prompt
create table FG_CKTSFN_TSSH
(
  pzxh_ckts  VARCHAR2(20) not null,
  zsxm_dm    VARCHAR2(5) not null,
  sjly       CHAR(1) not null,
  yt_amt     NUMBER(16,2),
  sb_ym      VARCHAR2(6),
  sb_pc      VARCHAR2(2),
  qyhgdm     VARCHAR2(32),
  nsrsbh     VARCHAR2(20),
  nsrmc      VARCHAR2(80),
  yzhyy_code VARCHAR2(4),
  yzh_reason VARCHAR2(500),
  note       VARCHAR2(200),
  xyz_flag   CHAR(1),
  xyz_date   DATE,
  xh_flag    CHAR(1),
  xh_date    DATE,
  swjg_dm    VARCHAR2(11),
  uuid       VARCHAR2(32),
  op_date    DATE,
  sjtb_date  DATE default sysdate,
  dzjg       CHAR(1),
  bgd_no     VARCHAR2(21),
  zyfp_no    VARCHAR2(30)
)
;
comment on table FG_CKTSFN_TSSH
  is '辅助管理--出口退税返纳表（出口）';
comment on column FG_CKTSFN_TSSH.pzxh_ckts
  is '应征凭证序号
(对账用)
1:YZSPZ_NO+NO
2:NO
';
comment on column FG_CKTSFN_TSSH.zsxm_dm
  is '征收项目代码（10101增值税
10102消费税
）';
comment on column FG_CKTSFN_TSSH.sjly
  is '数据来源(2 :TSTHS
、1: TSTHS_FN
)';
comment on column FG_CKTSFN_TSSH.yt_amt
  is '应补缴税额';
comment on column FG_CKTSFN_TSSH.sb_ym
  is '申报年月';
comment on column FG_CKTSFN_TSSH.sb_pc
  is '申报批次';
comment on column FG_CKTSFN_TSSH.qyhgdm
  is '海关企业代码';
comment on column FG_CKTSFN_TSSH.nsrsbh
  is '纳税人识别号';
comment on column FG_CKTSFN_TSSH.nsrmc
  is '企业名称';
comment on column FG_CKTSFN_TSSH.yzhyy_code
  is '应追回原因代码';
comment on column FG_CKTSFN_TSSH.yzh_reason
  is '应追回原因';
comment on column FG_CKTSFN_TSSH.note
  is '备注';
comment on column FG_CKTSFN_TSSH.xyz_flag
  is '写应征标志';
comment on column FG_CKTSFN_TSSH.xyz_date
  is '写应征日期';
comment on column FG_CKTSFN_TSSH.xh_flag
  is '销号标志';
comment on column FG_CKTSFN_TSSH.xh_date
  is '销号日期';
comment on column FG_CKTSFN_TSSH.swjg_dm
  is '税务机关代码';
comment on column FG_CKTSFN_TSSH.op_date
  is '录入日期';
comment on column FG_CKTSFN_TSSH.sjtb_date
  is '数据同步时间';
comment on column FG_CKTSFN_TSSH.dzjg
  is '对账结果';
comment on column FG_CKTSFN_TSSH.bgd_no
  is '报关单号';
comment on column FG_CKTSFN_TSSH.zyfp_no
  is '专用发票号码';
create index IDX_FG_CKTSFN_TSSH_BAK_SWJGDM on FG_CKTSFN_TSSH (SWJG_DM);
alter table FG_CKTSFN_TSSH
  add constraint PK_FG_CKTSFN_TSSH_BAK primary key (PZXH_CKTS, ZSXM_DM, SJLY);

prompt
prompt Creating table FG_FLGLPDZB_DTBHTX
prompt =================================
prompt
create table FG_FLGLPDZB_DTBHTX
(
  id         NUMBER(18) not null,
  nsrsbh     VARCHAR2(20) not null,
  swjg_dm    VARCHAR2(11) not null,
  ssny       VARCHAR2(6) not null,
  nsxydj_by  CHAR(1),
  nsxydj_sy  CHAR(1),
  hgflgl_by  CHAR(1),
  hgflgl_sy  CHAR(1),
  wgflgl_by  CHAR(1),
  wgflgl_sy  CHAR(1),
  sxqy_by    CHAR(1),
  sxqy_sy    CHAR(1),
  jcaj_num   NUMBER(4),
  jcaj_wh    VARCHAR2(1000),
  slqyfr_new VARCHAR2(1000),
  flglcd     CHAR(1),
  lrrq       DATE,
  cpcode     VARCHAR2(32)
)
;
comment on table FG_FLGLPDZB_DTBHTX
  is '分类管理评定指标动态变化提醒表';
comment on column FG_FLGLPDZB_DTBHTX.id
  is '主键';
comment on column FG_FLGLPDZB_DTBHTX.nsrsbh
  is '纳税人识别号';
comment on column FG_FLGLPDZB_DTBHTX.swjg_dm
  is '税务机关代码';
comment on column FG_FLGLPDZB_DTBHTX.ssny
  is '所属年月';
comment on column FG_FLGLPDZB_DTBHTX.nsxydj_by
  is '纳税信用登记(本月)';
comment on column FG_FLGLPDZB_DTBHTX.nsxydj_sy
  is '纳税信用登记(上月)';
comment on column FG_FLGLPDZB_DTBHTX.hgflgl_by
  is '海关管理类别(本月)';
comment on column FG_FLGLPDZB_DTBHTX.hgflgl_sy
  is '海关管理类别(上月)';
comment on column FG_FLGLPDZB_DTBHTX.wgflgl_by
  is '外管管理类别(本月)';
comment on column FG_FLGLPDZB_DTBHTX.wgflgl_sy
  is '外管管理类别(上月)';
comment on column FG_FLGLPDZB_DTBHTX.sxqy_by
  is '失信企业（本月）';
comment on column FG_FLGLPDZB_DTBHTX.sxqy_sy
  is '失信企业（上月）';
comment on column FG_FLGLPDZB_DTBHTX.jcaj_num
  is '稽查案件个数';
comment on column FG_FLGLPDZB_DTBHTX.jcaj_wh
  is '稽查案件文号';
comment on column FG_FLGLPDZB_DTBHTX.slqyfr_new
  is '四类出口企业的法定代表人新成立的出口企业';
comment on column FG_FLGLPDZB_DTBHTX.flglcd
  is '分类管理类别';
comment on column FG_FLGLPDZB_DTBHTX.lrrq
  is '录入日期';
comment on column FG_FLGLPDZB_DTBHTX.cpcode
  is 'cpcode';
create unique index UQ_FG_FLGLPDZB_DCBHTX_NS on FG_FLGLPDZB_DTBHTX (NSRSBH, SSNY);
alter table FG_FLGLPDZB_DTBHTX
  add constraint PK_FG_FLGLPDZB_DCBHTX primary key (ID);

prompt
prompt Creating table FG_FLGLPDZB_JCXXTJ
prompt =================================
prompt
create table FG_FLGLPDZB_JCXXTJ
(
  id           NUMBER(18) not null,
  nsrsbh       VARCHAR2(20) not null,
  ssny         VARCHAR2(6) not null,
  swjg_dm      VARCHAR2(11),
  qylx         VARCHAR2(2),
  flglcd       CHAR(1),
  snd_qmjzc    NUMBER(16,2),
  snd_cktse    NUMBER(16,2),
  nsxydj       CHAR(1),
  flgl_hg      CHAR(1),
  flgl_wg      CHAR(1),
  scsbzjljys   NUMBER(4),
  swdjrq       DATE,
  jcaj_num     NUMBER(4),
  jcaj_wh      VARCHAR2(1000),
  slqyfr_all   VARCHAR2(1000),
  slqyfr_new   VARCHAR2(1000),
  lhcjsxqy     CHAR(1),
  lrrq         DATE,
  clbz         CHAR(1),
  clrq         DATE,
  shxtbazt     VARCHAR2(2),
  jsxtqyzt     VARCHAR2(2),
  cpcode       VARCHAR2(32),
  snd_ljlgywsb NUMBER(2)
)
;
comment on table FG_FLGLPDZB_JCXXTJ
  is '分类管理评定指标基础信息统计表';
comment on column FG_FLGLPDZB_JCXXTJ.id
  is '主键';
comment on column FG_FLGLPDZB_JCXXTJ.nsrsbh
  is '纳税人识别号';
comment on column FG_FLGLPDZB_JCXXTJ.ssny
  is '所属年月';
comment on column FG_FLGLPDZB_JCXXTJ.swjg_dm
  is '税务机关代码';
comment on column FG_FLGLPDZB_JCXXTJ.qylx
  is '企业类型';
comment on column FG_FLGLPDZB_JCXXTJ.flglcd
  is '分类管理类别(评定前)';
comment on column FG_FLGLPDZB_JCXXTJ.snd_qmjzc
  is '上一年度期未净资产';
comment on column FG_FLGLPDZB_JCXXTJ.snd_cktse
  is '上一年度已办理出口退税额';
comment on column FG_FLGLPDZB_JCXXTJ.nsxydj
  is '纳税信用等级';
comment on column FG_FLGLPDZB_JCXXTJ.flgl_hg
  is '海关企业信用管理类别';
comment on column FG_FLGLPDZB_JCXXTJ.flgl_wg
  is '外汇管理的分类管理等级';
comment on column FG_FLGLPDZB_JCXXTJ.scsbzjljys
  is '首次申报至今累计月数(自首笔申报出口退（免）税之日起至评定时未满12个月)';
comment on column FG_FLGLPDZB_JCXXTJ.swdjrq
  is '税务登记日期';
comment on column FG_FLGLPDZB_JCXXTJ.jcaj_num
  is '近3年稽查案件 个数';
comment on column FG_FLGLPDZB_JCXXTJ.jcaj_wh
  is '近3年稽查案件文号';
comment on column FG_FLGLPDZB_JCXXTJ.slqyfr_all
  is '四类出口企业的法定代表人的全部出口企业';
comment on column FG_FLGLPDZB_JCXXTJ.slqyfr_new
  is '四类出口企业的法定代表人当月新成立出口企业';
comment on column FG_FLGLPDZB_JCXXTJ.lhcjsxqy
  is '被列为国家联合惩戒对象的失信企业(0/1  否/是)';
comment on column FG_FLGLPDZB_JCXXTJ.lrrq
  is '录入日期';
comment on column FG_FLGLPDZB_JCXXTJ.clbz
  is '处理标志';
comment on column FG_FLGLPDZB_JCXXTJ.clrq
  is '处理日期';
comment on column FG_FLGLPDZB_JCXXTJ.shxtbazt
  is '审核系统备案状态';
comment on column FG_FLGLPDZB_JCXXTJ.jsxtqyzt
  is '金三系统企业状态';
comment on column FG_FLGLPDZB_JCXXTJ.cpcode
  is 'cpcode';
comment on column FG_FLGLPDZB_JCXXTJ.snd_ljlgywsb
  is '上一年度累计未申报月份数(0-12之间取值)';
create unique index UQ_FG_FLGLPDZB_JCXXTJ_NS on FG_FLGLPDZB_JCXXTJ (NSRSBH, SSNY);
alter table FG_FLGLPDZB_JCXXTJ
  add constraint PK_FG_FLGLPDZB_JCXXTJ primary key (ID);

prompt
prompt Creating table FG_LOG_DZDZZM
prompt ============================
prompt
create table FG_LOG_DZDZZM
(
  id      NUMBER(18) not null,
  qyhgdm  VARCHAR2(20) not null,
  nsrsbh  VARCHAR2(21) not null,
  nsrmc   VARCHAR2(80),
  swjg_dm VARCHAR2(11) not null,
  qylx    CHAR(2),
  cpcode  VARCHAR2(32),
  dzlx    VARCHAR2(10) not null,
  zmbh    VARCHAR2(20) not null,
  sbym    VARCHAR2(6),
  sbpc    VARCHAR2(2),
  zcdyrq  DATE,
  bdcs    NUMBER(4) default 0,
  bdrq    DATE,
  zfbz    CHAR(1),
  zfrq    DATE,
  zfr     VARCHAR2(20),
  cjrq    DATE,
  cjr     VARCHAR2(20)
)
;
comment on table FG_LOG_DZDZZM
  is '辅助管理--电子单证证明日志';
comment on column FG_LOG_DZDZZM.id
  is '主键';
comment on column FG_LOG_DZDZZM.qyhgdm
  is '企业海关代码';
comment on column FG_LOG_DZDZZM.nsrsbh
  is '纳税人识别号';
comment on column FG_LOG_DZDZZM.nsrmc
  is '企业名称';
comment on column FG_LOG_DZDZZM.swjg_dm
  is '税务机关代码';
comment on column FG_LOG_DZDZZM.qylx
  is '企业类型';
comment on column FG_LOG_DZDZZM.cpcode
  is 'cpcode';
comment on column FG_LOG_DZDZZM.dzlx
  is '单证类型';
comment on column FG_LOG_DZDZZM.zmbh
  is '证明编号';
comment on column FG_LOG_DZDZZM.sbym
  is '申报年月';
comment on column FG_LOG_DZDZZM.sbpc
  is '申报批次';
comment on column FG_LOG_DZDZZM.zcdyrq
  is '正常打印日期';
comment on column FG_LOG_DZDZZM.bdcs
  is '补打次数';
comment on column FG_LOG_DZDZZM.bdrq
  is '补打日期(最后一次)';
comment on column FG_LOG_DZDZZM.zfbz
  is '作废标志';
comment on column FG_LOG_DZDZZM.zfrq
  is '作废日期';
comment on column FG_LOG_DZDZZM.zfr
  is '作废人';
comment on column FG_LOG_DZDZZM.cjrq
  is '出具日期';
comment on column FG_LOG_DZDZZM.cjr
  is '出具人';
create index IDX_FG_LOG_DZDZZM_NQ on FG_LOG_DZDZZM (QYHGDM, NSRSBH);
create unique index UDX_FG_LOG_DZDZZM_CPCODE on FG_LOG_DZDZZM (CPCODE, DZLX, ZMBH);
alter table FG_LOG_DZDZZM
  add constraint PK_FG_LOG_DZDZZM primary key (ID);

prompt
prompt Creating table FG_LOG_OPERATOR
prompt ==============================
prompt
create table FG_LOG_OPERATOR
(
  id       NUMBER(18) not null,
  funcno   VARCHAR2(50),
  actno    VARCHAR2(50),
  loguser  VARCHAR2(50),
  lognr    VARCHAR2(500),
  logtime  DATE,
  loglevel CHAR(1),
  ip       VARCHAR2(20),
  mac      VARCHAR2(20)
)
;
comment on table FG_LOG_OPERATOR
  is '系统操作日志表';
comment on column FG_LOG_OPERATOR.id
  is '主键';
comment on column FG_LOG_OPERATOR.funcno
  is '功能名（菜单项）';
comment on column FG_LOG_OPERATOR.actno
  is '操作名（具体操作）';
comment on column FG_LOG_OPERATOR.loguser
  is '操作人员';
comment on column FG_LOG_OPERATOR.lognr
  is '日志内容';
comment on column FG_LOG_OPERATOR.logtime
  is '记录日志时间';
comment on column FG_LOG_OPERATOR.loglevel
  is '日志级别（I/W/E）';
comment on column FG_LOG_OPERATOR.ip
  is '工作电脑ip';
comment on column FG_LOG_OPERATOR.mac
  is '工作电脑mac地址';
alter table FG_LOG_OPERATOR
  add constraint PK_FG_LOG_OPERATOR primary key (ID);

prompt
prompt Creating table FG_LOG_SYNC_DATA
prompt ===============================
prompt
create table FG_LOG_SYNC_DATA
(
  id        NUMBER(18) not null,
  sync_type VARCHAR2(50) not null,
  sync_obj  VARCHAR2(200),
  lognr     VARCHAR2(500),
  logtime   DATE,
  loglevel  CHAR(1),
  loguser   VARCHAR2(50)
)
;
comment on table FG_LOG_SYNC_DATA
  is '系统同步日志表';
comment on column FG_LOG_SYNC_DATA.id
  is '主键';
comment on column FG_LOG_SYNC_DATA.sync_type
  is '同步类型';
comment on column FG_LOG_SYNC_DATA.sync_obj
  is '同步对象';
comment on column FG_LOG_SYNC_DATA.lognr
  is '日志内容';
comment on column FG_LOG_SYNC_DATA.logtime
  is '记录日志时间';
comment on column FG_LOG_SYNC_DATA.loglevel
  is '日志级别';
comment on column FG_LOG_SYNC_DATA.loguser
  is '操作员代码
/系统服务
';
alter table FG_LOG_SYNC_DATA
  add constraint PK_FG_LOG_SYNC_DATA primary key (ID);

prompt
prompt Creating table FG_NOTICE_QY_ATTACH
prompt ==================================
prompt
create table FG_NOTICE_QY_ATTACH
(
  id       NUMBER(18) not null,
  noticeid NUMBER(18) not null,
  filename VARCHAR2(1000),
  filesize NUMBER(18),
  content  BLOB,
  filetype VARCHAR2(100) not null,
  crtime   DATE not null
)
;
comment on table FG_NOTICE_QY_ATTACH
  is '企业通知附件表';
comment on column FG_NOTICE_QY_ATTACH.id
  is '主键';
comment on column FG_NOTICE_QY_ATTACH.noticeid
  is '通知主键';
comment on column FG_NOTICE_QY_ATTACH.filename
  is '文件名';
comment on column FG_NOTICE_QY_ATTACH.filesize
  is '文件大小';
comment on column FG_NOTICE_QY_ATTACH.content
  is '文件内容';
comment on column FG_NOTICE_QY_ATTACH.filetype
  is '文件类型';
comment on column FG_NOTICE_QY_ATTACH.crtime
  is '创建时间';
alter table FG_NOTICE_QY_ATTACH
  add constraint PK_PG_NOTICE_QY_ATTACH primary key (ID);

prompt
prompt Creating table FG_NOTICE_QY_MAIN
prompt ================================
prompt
create table FG_NOTICE_QY_MAIN
(
  id             NUMBER not null,
  title          VARCHAR2(200),
  content        VARCHAR2(4000),
  release_user   VARCHAR2(100),
  release_czydm  VARCHAR2(20),
  release_swjgdm VARCHAR2(11),
  release_time   DATE,
  valid_time     DATE,
  qybj           CHAR(1),
  bz             VARCHAR2(255),
  cx_time        DATE,
  exist_upfile   CHAR(1),
  notitype       CHAR(1),
  objval         VARCHAR2(20)
)
;
comment on table FG_NOTICE_QY_MAIN
  is '企业通知主表';
comment on column FG_NOTICE_QY_MAIN.id
  is '主键';
comment on column FG_NOTICE_QY_MAIN.title
  is '标题';
comment on column FG_NOTICE_QY_MAIN.content
  is '内容';
comment on column FG_NOTICE_QY_MAIN.release_user
  is '发布人';
comment on column FG_NOTICE_QY_MAIN.release_czydm
  is '发布人帐号';
comment on column FG_NOTICE_QY_MAIN.release_swjgdm
  is '发布人税务机关代码';
comment on column FG_NOTICE_QY_MAIN.release_time
  is '发布时间';
comment on column FG_NOTICE_QY_MAIN.valid_time
  is '通知截止时间';
comment on column FG_NOTICE_QY_MAIN.qybj
  is '启用标记(0.编辑，1.发布，2.撤销)';
comment on column FG_NOTICE_QY_MAIN.bz
  is '备注';
comment on column FG_NOTICE_QY_MAIN.cx_time
  is '撤销时间';
comment on column FG_NOTICE_QY_MAIN.exist_upfile
  is '有无附件标志（0:无  1:有）';
comment on column FG_NOTICE_QY_MAIN.notitype
  is '通知类型(1群发
2定向
)';
comment on column FG_NOTICE_QY_MAIN.objval
  is '通知对象-主发(群发-SWJGDM
定向-NSRSBH
)';
alter table FG_NOTICE_QY_MAIN
  add constraint PK_FG_NOTICE_QY_MAIN primary key (ID);

prompt
prompt Creating table FG_NOTICE_QY_RECEIVER
prompt ====================================
prompt
create table FG_NOTICE_QY_RECEIVER
(
  noticeid NUMBER(18) not null,
  objval   VARCHAR2(20) not null
)
;
comment on table FG_NOTICE_QY_RECEIVER
  is '企业通知接收方子表';
comment on column FG_NOTICE_QY_RECEIVER.noticeid
  is '通知主表序号';
comment on column FG_NOTICE_QY_RECEIVER.objval
  is '通知对象（抄送）';
alter table FG_NOTICE_QY_RECEIVER
  add constraint PK_FG_NOTICE_QY_RECEIVER primary key (NOTICEID, OBJVAL);

prompt
prompt Creating table FG_NOTICE_QY_SYNC2YUN
prompt ====================================
prompt
create table FG_NOTICE_QY_SYNC2YUN
(
  id           NUMBER(18) not null,
  title        VARCHAR2(200),
  content      VARCHAR2(4000),
  release_user VARCHAR2(100),
  release_swjg VARCHAR2(200),
  release_time DATE,
  valid_time   DATE,
  swjgdm_set   VARCHAR2(1000),
  nsrdzdah_set VARCHAR2(2000),
  bz           VARCHAR2(255),
  qybj         CHAR(1)
)
;
comment on table FG_NOTICE_QY_SYNC2YUN
  is '企业通知信息同步到云平台信息';
comment on column FG_NOTICE_QY_SYNC2YUN.id
  is '主键';
comment on column FG_NOTICE_QY_SYNC2YUN.title
  is '标题';
comment on column FG_NOTICE_QY_SYNC2YUN.content
  is '内容';
comment on column FG_NOTICE_QY_SYNC2YUN.release_user
  is '发布人';
comment on column FG_NOTICE_QY_SYNC2YUN.release_swjg
  is '发布税务机关release_time,valid_time, swjgdm_set,bz,qybj';
comment on column FG_NOTICE_QY_SYNC2YUN.release_time
  is '发布日期';
comment on column FG_NOTICE_QY_SYNC2YUN.valid_time
  is '有效日期';
comment on column FG_NOTICE_QY_SYNC2YUN.swjgdm_set
  is '通知的税务机关代码集合';
comment on column FG_NOTICE_QY_SYNC2YUN.nsrdzdah_set
  is '通知的纳税人电子档案号集合';
comment on column FG_NOTICE_QY_SYNC2YUN.bz
  is '备注';
comment on column FG_NOTICE_QY_SYNC2YUN.qybj
  is '启用标记';
alter table FG_NOTICE_QY_SYNC2YUN
  add constraint PK_FG_NOTICE_QY_SYNC2YUN primary key (ID);

prompt
prompt Creating table FG_NOTICE_SW_ATTACH
prompt ==================================
prompt
create table FG_NOTICE_SW_ATTACH
(
  id       NUMBER(18) not null,
  noticeid NUMBER(18) not null,
  filename VARCHAR2(1000),
  filesize NUMBER(18),
  content  BLOB,
  filetype VARCHAR2(100) not null,
  crtime   DATE not null
)
;
comment on table FG_NOTICE_SW_ATTACH
  is '税务通知附件表';
comment on column FG_NOTICE_SW_ATTACH.id
  is '主键';
comment on column FG_NOTICE_SW_ATTACH.noticeid
  is '通知主键';
comment on column FG_NOTICE_SW_ATTACH.filename
  is '文件名';
comment on column FG_NOTICE_SW_ATTACH.filesize
  is '文件大小';
comment on column FG_NOTICE_SW_ATTACH.content
  is '文件内容';
comment on column FG_NOTICE_SW_ATTACH.filetype
  is '文件类型';
comment on column FG_NOTICE_SW_ATTACH.crtime
  is '创建时间';
alter table FG_NOTICE_SW_ATTACH
  add constraint PK_PG_NOTICE_SW_ATTACH primary key (ID);

prompt
prompt Creating table FG_NOTICE_SW_MAIN
prompt ================================
prompt
create table FG_NOTICE_SW_MAIN
(
  id             NUMBER not null,
  title          VARCHAR2(200),
  content        VARCHAR2(4000),
  release_user   VARCHAR2(100),
  release_czydm  VARCHAR2(20),
  release_swjgdm VARCHAR2(11),
  release_time   DATE,
  valid_time     DATE,
  qybj           CHAR(1),
  bz             VARCHAR2(255),
  cx_time        DATE,
  exist_upfile   CHAR(1),
  notitype       CHAR(1),
  objval         VARCHAR2(20)
)
;
comment on table FG_NOTICE_SW_MAIN
  is '税务通知主表';
comment on column FG_NOTICE_SW_MAIN.id
  is '主键';
comment on column FG_NOTICE_SW_MAIN.title
  is '标题';
comment on column FG_NOTICE_SW_MAIN.content
  is '内容';
comment on column FG_NOTICE_SW_MAIN.release_user
  is '发布人';
comment on column FG_NOTICE_SW_MAIN.release_czydm
  is '发布人帐号';
comment on column FG_NOTICE_SW_MAIN.release_swjgdm
  is '发布人税务机关代码';
comment on column FG_NOTICE_SW_MAIN.release_time
  is '发布时间';
comment on column FG_NOTICE_SW_MAIN.valid_time
  is '通知截止时间';
comment on column FG_NOTICE_SW_MAIN.qybj
  is '启用标记(0.编辑，1.发布，2.撤销)';
comment on column FG_NOTICE_SW_MAIN.bz
  is '备注';
comment on column FG_NOTICE_SW_MAIN.cx_time
  is '撤销时间';
comment on column FG_NOTICE_SW_MAIN.exist_upfile
  is '有无附件标志（0:无  1:有）';
comment on column FG_NOTICE_SW_MAIN.notitype
  is '通知类型(1群发
2定向
)';
comment on column FG_NOTICE_SW_MAIN.objval
  is '通知对象-主发(群发-SWJGDM
定向-CZRY_DM
)';
alter table FG_NOTICE_SW_MAIN
  add constraint PK_FG_NOTICE_SW_MAIN primary key (ID);

prompt
prompt Creating table FG_NOTICE_SW_RECEIPT
prompt ===================================
prompt
create table FG_NOTICE_SW_RECEIPT
(
  noticeid     NUMBER(18) not null,
  nsrsbh       VARCHAR2(20) not null,
  receipt_time DATE
)
;
comment on table FG_NOTICE_SW_RECEIPT
  is '税务通知回执表';
comment on column FG_NOTICE_SW_RECEIPT.noticeid
  is '通知id';
comment on column FG_NOTICE_SW_RECEIPT.nsrsbh
  is '纳税人识别号或者社会信用代码';
comment on column FG_NOTICE_SW_RECEIPT.receipt_time
  is '回执时间';
alter table FG_NOTICE_SW_RECEIPT
  add constraint PK_FG_NOTICE_SW_RECEIPT primary key (NOTICEID, NSRSBH);

prompt
prompt Creating table FG_NOTICE_SW_RECEIVER
prompt ====================================
prompt
create table FG_NOTICE_SW_RECEIVER
(
  noticeid NUMBER(18) not null,
  objval   VARCHAR2(20) not null
)
;
comment on table FG_NOTICE_SW_RECEIVER
  is '税务通知接收方子表';
comment on column FG_NOTICE_SW_RECEIVER.noticeid
  is '通知主表序号';
comment on column FG_NOTICE_SW_RECEIVER.objval
  is '通知对象（抄送）';
alter table FG_NOTICE_SW_RECEIVER
  add constraint PK_FG_NOTICE_SW_RECEIVER primary key (NOTICEID, OBJVAL);

prompt
prompt Creating table FG_SB_CANCEL
prompt ===========================
prompt
create table FG_SB_CANCEL
(
  lcslid    VARCHAR2(32) not null,
  qyhgdm    VARCHAR2(20) not null,
  nsrsbh    VARCHAR2(21) not null,
  nsrmc     VARCHAR2(80),
  cpcode    VARCHAR2(32) not null,
  swjg_dm   VARCHAR2(11),
  qylx      VARCHAR2(2) not null,
  gllb      CHAR(1) not null,
  lc_id     VARCHAR2(10) not null,
  sbym      VARCHAR2(6),
  sbpc      VARCHAR2(2),
  ckamt_usd NUMBER(16,2),
  tsjsje    NUMBER(16,2),
  jljgdje   NUMBER(16,2),
  tse_amt   NUMBER(16,2),
  tse_zzs   NUMBER(16,2),
  tse_xfs   NUMBER(16,2),
  mdse      NUMBER(16,2),
  sl_date   DATE,
  sh_user   VARCHAR2(20),
  yjbz      CHAR(1),
  sjly      CHAR(1) not null,
  sq_date   DATE,
  sq_reason VARCHAR2(200),
  sc_user   VARCHAR2(20),
  sc_reason VARCHAR2(200),
  sc_date   DATE,
  tse_zh    NUMBER(16,2),
  tse_by    NUMBER(16,2),
  sjtb_bz   CHAR(1),
  sjtb_date DATE,
  clbz      CHAR(1),
  tqbz      VARCHAR2(40),
  tqsj      TIMESTAMP(6),
  tqcs      NUMBER(2)
)
;
comment on table FG_SB_CANCEL
  is '辅助管理-撤单记录主线表';
comment on column FG_SB_CANCEL.lcslid
  is '流程受理id';
comment on column FG_SB_CANCEL.qyhgdm
  is '企业海关代码';
comment on column FG_SB_CANCEL.nsrsbh
  is '纳税人识别号';
comment on column FG_SB_CANCEL.nsrmc
  is '纳税人名称';
comment on column FG_SB_CANCEL.cpcode
  is '海关代码，老海关代码';
comment on column FG_SB_CANCEL.swjg_dm
  is '税务机关代码';
comment on column FG_SB_CANCEL.qylx
  is '企业类型';
comment on column FG_SB_CANCEL.gllb
  is '管理类别';
comment on column FG_SB_CANCEL.lc_id
  is '业务类型';
comment on column FG_SB_CANCEL.sbym
  is '申报年月';
comment on column FG_SB_CANCEL.sbpc
  is '申报批次';
comment on column FG_SB_CANCEL.ckamt_usd
  is '申报出口额USD';
comment on column FG_SB_CANCEL.tsjsje
  is '退税计税金额';
comment on column FG_SB_CANCEL.jljgdje
  is '进料加工抵减额';
comment on column FG_SB_CANCEL.tse_amt
  is '退(免)税总额';
comment on column FG_SB_CANCEL.tse_zzs
  is '退增值税';
comment on column FG_SB_CANCEL.tse_xfs
  is '退消费税';
comment on column FG_SB_CANCEL.mdse
  is '免抵税额';
comment on column FG_SB_CANCEL.sl_date
  is '申报受理时间';
comment on column FG_SB_CANCEL.sh_user
  is '审核人员';
comment on column FG_SB_CANCEL.yjbz
  is '预警标志';
comment on column FG_SB_CANCEL.sjly
  is '数据来源(1企业申请
2系统同步
)';
comment on column FG_SB_CANCEL.sq_date
  is '申请时间';
comment on column FG_SB_CANCEL.sq_reason
  is '申请原因';
comment on column FG_SB_CANCEL.sc_user
  is '撤单人';
comment on column FG_SB_CANCEL.sc_reason
  is '撤单原因';
comment on column FG_SB_CANCEL.sc_date
  is '撤单时间';
comment on column FG_SB_CANCEL.tse_zh
  is '暂缓退税金额';
comment on column FG_SB_CANCEL.tse_by
  is '不予退税金额';
comment on column FG_SB_CANCEL.sjtb_bz
  is '数据同步标志(0待同步
1正在同步
2同步结束
)';
comment on column FG_SB_CANCEL.sjtb_date
  is '数据同步时间';
comment on column FG_SB_CANCEL.clbz
  is '处理标志(0:未处理  1:已撤单处理)';
comment on column FG_SB_CANCEL.tqbz
  is '提取标志';
comment on column FG_SB_CANCEL.tqsj
  is '提取时间';
comment on column FG_SB_CANCEL.tqcs
  is '提取次数';
create index IDX_FG_SB_CANCEL_CPCODE on FG_SB_CANCEL (CPCODE);
create index IDX_FG_SB_CANCEL_QYBS on FG_SB_CANCEL (QYHGDM, NSRSBH);
create index IDX_FG_SB_CANCEL_SWJGDM on FG_SB_CANCEL (SWJG_DM);
alter table FG_SB_CANCEL
  add constraint PK_FG_SB_CANCEL primary key (LCSLID);

prompt
prompt Creating table FG_SB_CANCEL_DZMX
prompt ================================
prompt
create table FG_SB_CANCEL_DZMX
(
  lcslid  VARCHAR2(32) not null,
  cpcode  VARCHAR2(32),
  sbno    VARCHAR2(4) not null,
  pzlx    CHAR(1) not null,
  pzhm    VARCHAR2(32) not null,
  zh_flag CHAR(1),
  by_flag CHAR(1),
  tse     NUMBER(16,2) not null,
  sjly    CHAR(1) not null,
  spdm    VARCHAR2(11),
  jldw    VARCHAR2(20),
  spmc    VARCHAR2(30),
  sl      NUMBER(15,4),
  jsje    NUMBER(16,2)
)
;
comment on table FG_SB_CANCEL_DZMX
  is '辅助管理-撤单凭证明细表';
comment on column FG_SB_CANCEL_DZMX.lcslid
  is '流程受理id';
comment on column FG_SB_CANCEL_DZMX.cpcode
  is '海关代码，老的海关代码';
comment on column FG_SB_CANCEL_DZMX.sbno
  is '申报序号';
comment on column FG_SB_CANCEL_DZMX.pzlx
  is '凭证类型(1报关单
2进项发票
3专用税票
4代理证明
)';
comment on column FG_SB_CANCEL_DZMX.pzhm
  is '凭证号码';
comment on column FG_SB_CANCEL_DZMX.zh_flag
  is '暂缓标志(1暂缓，默认放行+提醒)';
comment on column FG_SB_CANCEL_DZMX.by_flag
  is '不予标志(1不予，默认拒绝放行)';
comment on column FG_SB_CANCEL_DZMX.tse
  is '申报退税额';
comment on column FG_SB_CANCEL_DZMX.sjly
  is '数据来源(1自动同步
2人工录入
)';
comment on column FG_SB_CANCEL_DZMX.spdm
  is '商品代码';
comment on column FG_SB_CANCEL_DZMX.jldw
  is '计量单位';
comment on column FG_SB_CANCEL_DZMX.spmc
  is '商品名称';
comment on column FG_SB_CANCEL_DZMX.sl
  is '数量';
comment on column FG_SB_CANCEL_DZMX.jsje
  is '计税金额';
create index IDX_FG_SB_CANCEL_DZMX_PZXX on FG_SB_CANCEL_DZMX (CPCODE, PZLX, PZHM);
alter table FG_SB_CANCEL_DZMX
  add constraint PK_FG_SB_CANCEL_DZMX primary key (LCSLID, SBNO);

prompt
prompt Creating table FG_SB_CANCEL_FXB
prompt ===============================
prompt
create table FG_SB_CANCEL_FXB
(
  cpcode  VARCHAR2(32) not null,
  pzlx    CHAR(1) not null,
  pzhm    VARCHAR2(32) not null,
  fx_flag CHAR(1) not null,
  op_user VARCHAR2(20),
  op_date DATE,
  bz      VARCHAR2(200)
)
;
comment on table FG_SB_CANCEL_FXB
  is '辅助管理-撤单单证放行表';
comment on column FG_SB_CANCEL_FXB.cpcode
  is '企业代码，老海关代码';
comment on column FG_SB_CANCEL_FXB.pzlx
  is '凭证类型';
comment on column FG_SB_CANCEL_FXB.pzhm
  is '凭证号码';
comment on column FG_SB_CANCEL_FXB.fx_flag
  is '放行标志(1放行
2放行+提醒
3拒绝放行
)';
comment on column FG_SB_CANCEL_FXB.op_user
  is '设置人';
comment on column FG_SB_CANCEL_FXB.op_date
  is '设置时间';
comment on column FG_SB_CANCEL_FXB.bz
  is '注释说明';
alter table FG_SB_CANCEL_FXB
  add constraint PK_FG_SB_CANCEL_FXB primary key (CPCODE, PZLX, PZHM);

prompt
prompt Creating table FG_SRTHS_QD
prompt ==========================
prompt
create table FG_SRTHS_QD
(
  no         VARCHAR2(20) not null,
  swjg_dm    VARCHAR2(11),
  qyhgdm     VARCHAR2(20),
  nsrsbh     VARCHAR2(20),
  nsrmc      VARCHAR2(100),
  qylx_dm    VARCHAR2(2),
  flglcd     CHAR(1),
  tsjsfs_dm  CHAR(1),
  sbywbdm    VARCHAR2(10),
  sssq       CHAR(6),
  sbpc       VARCHAR2(3),
  zzsamt     NUMBER(16,2),
  xfsamt     NUMBER(16,2),
  sh_time    DATE,
  shr        VARCHAR2(20),
  op_date    DATE,
  op_user    VARCHAR2(20),
  tsyhmc     VARCHAR2(80),
  tsyhzh     VARCHAR2(30),
  qdbz       CHAR(1) default 0,
  qd_date    DATE,
  qdno       VARCHAR2(20),
  qd_user    VARCHAR2(20),
  sjtbsj     DATE default sysdate,
  sjtbcs     INTEGER default 1,
  yjflag     CHAR(1) default 0,
  yjmsg      VARCHAR2(100),
  sjtbbz     CHAR(1) default '0',
  zbjg_dm    VARCHAR2(11),
  lcslid     VARCHAR2(32) default ' ' not null,
  zb_swjg_dm VARCHAR2(11)
)
;
comment on table FG_SRTHS_QD
  is '收入退还书清单';
comment on column FG_SRTHS_QD.no
  is '退还书号码';
comment on column FG_SRTHS_QD.swjg_dm
  is '所属退税税务机关';
comment on column FG_SRTHS_QD.qyhgdm
  is '海关代码';
comment on column FG_SRTHS_QD.nsrsbh
  is '纳税人识别号';
comment on column FG_SRTHS_QD.nsrmc
  is '纳税人名称';
comment on column FG_SRTHS_QD.qylx_dm
  is '企业类型';
comment on column FG_SRTHS_QD.flglcd
  is '分类管理等级';
comment on column FG_SRTHS_QD.tsjsfs_dm
  is '退税计算方式';
comment on column FG_SRTHS_QD.sbywbdm
  is '申报业务表代码';
comment on column FG_SRTHS_QD.sssq
  is '所属年月';
comment on column FG_SRTHS_QD.sbpc
  is '申报批次';
comment on column FG_SRTHS_QD.zzsamt
  is '退增值税';
comment on column FG_SRTHS_QD.xfsamt
  is '退消费税';
comment on column FG_SRTHS_QD.sh_time
  is '审核时间';
comment on column FG_SRTHS_QD.shr
  is '审核人';
comment on column FG_SRTHS_QD.op_date
  is '生成日期';
comment on column FG_SRTHS_QD.op_user
  is '生成人';
comment on column FG_SRTHS_QD.tsyhmc
  is '退税银行名称';
comment on column FG_SRTHS_QD.tsyhzh
  is '退税银行账号';
comment on column FG_SRTHS_QD.qdbz
  is '清单标志 0未生成 1已生成';
comment on column FG_SRTHS_QD.qd_date
  is '清单打印或导出日期';
comment on column FG_SRTHS_QD.qdno
  is '清单编号';
comment on column FG_SRTHS_QD.qd_user
  is '清单人';
comment on column FG_SRTHS_QD.sjtbsj
  is '数据同步时间';
comment on column FG_SRTHS_QD.sjtbcs
  is '数据同步次数';
comment on column FG_SRTHS_QD.yjflag
  is '预警标志 0正常 1有警告';
comment on column FG_SRTHS_QD.yjmsg
  is '预警消息';
comment on column FG_SRTHS_QD.sjtbbz
  is '数据同步标志，预留给后续处理';
comment on column FG_SRTHS_QD.lcslid
  is 'LCSLID';
comment on column FG_SRTHS_QD.zb_swjg_dm
  is '指标计划税务机关代码';
create index IDX_FG_SRTHS_QD_LCSLID on FG_SRTHS_QD (LCSLID);
alter table FG_SRTHS_QD
  add constraint PK_FG_SRTHS_QD primary key (NO);

prompt
prompt Creating table FG_SRTHS_QDBH
prompt ============================
prompt
create table FG_SRTHS_QDBH
(
  qdno    VARCHAR2(20) not null,
  swjg_dm VARCHAR2(11),
  qd_user VARCHAR2(20),
  qd_date DATE,
  yxbz    CHAR(1) default 'Y'
)
;
comment on table FG_SRTHS_QDBH
  is '收入退还书清单编号生成';
comment on column FG_SRTHS_QDBH.qdno
  is '清单编号';
comment on column FG_SRTHS_QDBH.swjg_dm
  is '税务机关代码';
comment on column FG_SRTHS_QDBH.qd_user
  is '清单生成人';
comment on column FG_SRTHS_QDBH.qd_date
  is '清单时间';
comment on column FG_SRTHS_QDBH.yxbz
  is '有效标志 Y有效 N作废';
create index IDX_FG_SRTHS_QBDH on FG_SRTHS_QDBH (SWJG_DM, QDNO);

prompt
prompt Creating table FG_SRTHS_QD_BAK
prompt ==============================
prompt
create table FG_SRTHS_QD_BAK
(
  no        VARCHAR2(20) not null,
  swjg_dm   VARCHAR2(11),
  qyhgdm    VARCHAR2(20),
  nsrsbh    VARCHAR2(20),
  nsrmc     VARCHAR2(100),
  qylx_dm   VARCHAR2(2),
  flglcd    CHAR(1),
  tsjsfs_dm CHAR(1),
  sbywbdm   VARCHAR2(10),
  sssq      CHAR(6),
  sbpc      VARCHAR2(3),
  zzsamt    NUMBER(16,2),
  xfsamt    NUMBER(16,2),
  sh_time   DATE,
  shr       VARCHAR2(20),
  op_date   DATE,
  op_user   VARCHAR2(20),
  tsyhmc    VARCHAR2(80),
  tsyhzh    VARCHAR2(30),
  qdbz      CHAR(1),
  qd_date   DATE,
  qdno      VARCHAR2(20),
  qd_user   VARCHAR2(20),
  sjtbsj    DATE,
  sjtbcs    INTEGER,
  yjflag    CHAR(1),
  yjmsg     VARCHAR2(100),
  sjtbbz    CHAR(1),
  zbjg_dm   VARCHAR2(11)
)
;

prompt
prompt Creating table FG_TKTZS_QD
prompt ==========================
prompt
create table FG_TKTZS_QD
(
  no         VARCHAR2(20) not null,
  msg_id     INTEGER not null,
  item_no    VARCHAR2(2) not null,
  swjg_dm    VARCHAR2(11),
  qyhgdm     VARCHAR2(20),
  nsrsbh     VARCHAR2(20),
  nsrmc      VARCHAR2(100),
  qylx_dm    VARCHAR2(2),
  flglcd     CHAR(1),
  tsjsfs_dm  CHAR(1),
  sbywbdm    VARCHAR2(10),
  sssq       CHAR(6),
  sbpc       VARCHAR2(3),
  ysjccode   VARCHAR2(2),
  lsgx       VARCHAR2(2),
  tkjccode   VARCHAR2(4),
  md_amt     NUMBER(16,2),
  sh_time    DATE,
  shr        VARCHAR2(20),
  op_date    DATE,
  op_user    VARCHAR2(20),
  zf_flag    CHAR(1),
  ywlx       VARCHAR2(2),
  qdbz       CHAR(1) default 0,
  qd_date    DATE,
  qdno       VARCHAR2(20),
  qd_user    VARCHAR2(20),
  sjtbsj     DATE default sysdate,
  sjtbcs     INTEGER default 1,
  yjflag     CHAR(1) default 0,
  yjmsg      VARCHAR2(100),
  sjtbbz     CHAR(1) default '0',
  zbjg_dm    VARCHAR2(11),
  lcslid     VARCHAR2(32) default ' ' not null,
  zb_swjg_dm VARCHAR2(11)
)
;
comment on table FG_TKTZS_QD
  is '调库通知书清单';
comment on column FG_TKTZS_QD.no
  is '调库通知书号码';
comment on column FG_TKTZS_QD.swjg_dm
  is '所属税务机关';
comment on column FG_TKTZS_QD.qyhgdm
  is '海关代码';
comment on column FG_TKTZS_QD.nsrsbh
  is '纳税人识别号';
comment on column FG_TKTZS_QD.nsrmc
  is '纳税人名称';
comment on column FG_TKTZS_QD.qylx_dm
  is '企业类型';
comment on column FG_TKTZS_QD.flglcd
  is '分类管理等级';
comment on column FG_TKTZS_QD.tsjsfs_dm
  is '退税计算方式';
comment on column FG_TKTZS_QD.sbywbdm
  is '申报业务表代码';
comment on column FG_TKTZS_QD.sssq
  is '所属年月';
comment on column FG_TKTZS_QD.sbpc
  is '申报批次';
comment on column FG_TKTZS_QD.md_amt
  is '免抵';
comment on column FG_TKTZS_QD.sh_time
  is '审核时间';
comment on column FG_TKTZS_QD.shr
  is '审核人';
comment on column FG_TKTZS_QD.op_date
  is '生成日期';
comment on column FG_TKTZS_QD.op_user
  is '生成人';
comment on column FG_TKTZS_QD.zf_flag
  is '作废标志 1作废 空格：不作废';
comment on column FG_TKTZS_QD.ywlx
  is '业务类型';
comment on column FG_TKTZS_QD.qdbz
  is '清单标志 0未生成 1已生成';
comment on column FG_TKTZS_QD.qd_date
  is '清单打印或导出日期';
comment on column FG_TKTZS_QD.qdno
  is '清单编号';
comment on column FG_TKTZS_QD.qd_user
  is '清单人';
comment on column FG_TKTZS_QD.sjtbsj
  is '数据同步时间';
comment on column FG_TKTZS_QD.sjtbcs
  is '数据同步次数';
comment on column FG_TKTZS_QD.yjflag
  is '预警标志 0正常 1有警告';
comment on column FG_TKTZS_QD.yjmsg
  is '预警消息';
comment on column FG_TKTZS_QD.sjtbbz
  is '数据同步标志，预留给后续处理';
comment on column FG_TKTZS_QD.lcslid
  is 'LCSLID';
comment on column FG_TKTZS_QD.zb_swjg_dm
  is '指标计划税务机关代码';
create index IDX_FG_TKTZS_QD_LCSLID on FG_TKTZS_QD (LCSLID);
alter table FG_TKTZS_QD
  add constraint PK_FG_TKTZS_QD primary key (NO);

prompt
prompt Creating table FG_TKTZS_QDBH
prompt ============================
prompt
create table FG_TKTZS_QDBH
(
  qdno    VARCHAR2(20) not null,
  swjg_dm VARCHAR2(11),
  qd_user VARCHAR2(20),
  qd_date DATE,
  yxbz    CHAR(1) default 'Y'
)
;
comment on table FG_TKTZS_QDBH
  is '调库通知书清单编号生成';
comment on column FG_TKTZS_QDBH.qdno
  is '清单编号';
comment on column FG_TKTZS_QDBH.swjg_dm
  is '税务机关代码';
comment on column FG_TKTZS_QDBH.qd_user
  is '清单生成人';
comment on column FG_TKTZS_QDBH.qd_date
  is '清单时间';
comment on column FG_TKTZS_QDBH.yxbz
  is '有效标志 Y有效 N作废';
alter table FG_TKTZS_QDBH
  add constraint PK_FG_TKTZS_QDBH primary key (QDNO);

prompt
prompt Creating table FG_TSDQY_JGB
prompt ===========================
prompt
create table FG_TSDQY_JGB
(
  nsrsbh VARCHAR2(20) not null,
  jgbz   CHAR(1),
  crtime DATE,
  crr    VARCHAR2(20),
  uptime DATE,
  upr    VARCHAR2(20),
  note   VARCHAR2(200)
)
;
comment on table FG_TSDQY_JGB
  is '退税贷企业监管表';
comment on column FG_TSDQY_JGB.nsrsbh
  is '纳税人识别号';
comment on column FG_TSDQY_JGB.jgbz
  is '监管标志 1 监管 0停止';
comment on column FG_TSDQY_JGB.crtime
  is '创建时间';
comment on column FG_TSDQY_JGB.crr
  is '创建人';
comment on column FG_TSDQY_JGB.note
  is '备注说明';
alter table FG_TSDQY_JGB
  add primary key (NSRSBH);

prompt
prompt Creating table FG_YWBLXX_DEL
prompt ============================
prompt
create table FG_YWBLXX_DEL
(
  lcslid    VARCHAR2(32) default ' ' not null,
  zfrq_1    DATE,
  lcswsx_dm VARCHAR2(200)
)
;
comment on column FG_YWBLXX_DEL.lcslid
  is 'LCSLID';
comment on column FG_YWBLXX_DEL.zfrq_1
  is '作废日期';
comment on column FG_YWBLXX_DEL.lcswsx_dm
  is '流程代码';
alter table FG_YWBLXX_DEL
  add constraint PK_FG_YWBLXX_DEL primary key (LCSLID);

prompt
prompt Creating table FG_YWYBA_INFO
prompt ============================
prompt
create table FG_YWYBA_INFO
(
  id        NUMBER(18) not null,
  qyhgdm    VARCHAR2(20) not null,
  nsrsbh    VARCHAR2(21) not null,
  nsrmc     VARCHAR2(200),
  year      CHAR(4),
  sfzh      VARCHAR2(255),
  ywyxm     VARCHAR2(200),
  sex       CHAR(1),
  gzrqq     DATE,
  gzrqz     DATE,
  sfqdldht  CHAR(1),
  sfdjbx    CHAR(1),
  sncke     NUMBER(16,2),
  snzycksp  VARCHAR2(400),
  snzyckg   VARCHAR2(400),
  snzyghd   VARCHAR2(400),
  freshtime DATE,
  bncke     NUMBER(16,2),
  bnzycksp  VARCHAR2(200),
  bnzyckg   VARCHAR2(200),
  bnzyghd   VARCHAR2(200),
  tbzf      NUMBER(10,4),
  qyhs      NUMBER(10),
  lrrq      DATE,
  xgrq      DATE,
  zxflag    CHAR(1),
  zxrq      DATE,
  sfsxgk    CHAR(1),
  clbz      CHAR(1),
  tqbz      VARCHAR2(40),
  tqsj      TIMESTAMP(6),
  tqcs      NUMBER(2),
  bz        VARCHAR2(200)
)
;
comment on table FG_YWYBA_INFO
  is '辅助管理--业务员备案信息表';
comment on column FG_YWYBA_INFO.id
  is '主键id';
comment on column FG_YWYBA_INFO.qyhgdm
  is '企业海关代码';
comment on column FG_YWYBA_INFO.nsrsbh
  is '纳税人识别号';
comment on column FG_YWYBA_INFO.nsrmc
  is '纳税人名称';
comment on column FG_YWYBA_INFO.year
  is '备案年度';
comment on column FG_YWYBA_INFO.sfzh
  is '身份证号';
comment on column FG_YWYBA_INFO.ywyxm
  is '业务员姓名';
comment on column FG_YWYBA_INFO.sex
  is '性别(1男2女)';
comment on column FG_YWYBA_INFO.gzrqq
  is '工作日期起';
comment on column FG_YWYBA_INFO.gzrqz
  is '工作日期止';
comment on column FG_YWYBA_INFO.sfqdldht
  is '是否签订劳动合同(Y/N)';
comment on column FG_YWYBA_INFO.sfdjbx
  is '是否代缴保险(Y/N)';
comment on column FG_YWYBA_INFO.sncke
  is '上年出口额(企业上报数)';
comment on column FG_YWYBA_INFO.snzycksp
  is '上年主出口商品';
comment on column FG_YWYBA_INFO.snzyckg
  is '上年主要出口国';
comment on column FG_YWYBA_INFO.snzyghd
  is '上年主要购货地';
comment on column FG_YWYBA_INFO.freshtime
  is '自动刷新时间';
comment on column FG_YWYBA_INFO.bncke
  is '本年出口额';
comment on column FG_YWYBA_INFO.bnzycksp
  is '本年主出口商品';
comment on column FG_YWYBA_INFO.bnzyckg
  is '本年主要出口国';
comment on column FG_YWYBA_INFO.bnzyghd
  is '本年主要购货地';
comment on column FG_YWYBA_INFO.tbzf
  is '同比增幅';
comment on column FG_YWYBA_INFO.qyhs
  is '涉及企业户数';
comment on column FG_YWYBA_INFO.lrrq
  is '录入时间';
comment on column FG_YWYBA_INFO.xgrq
  is '修改日期';
comment on column FG_YWYBA_INFO.zxflag
  is '注销标志(Y/N)';
comment on column FG_YWYBA_INFO.zxrq
  is '注销日期';
comment on column FG_YWYBA_INFO.sfsxgk
  is '是否涉嫌挂靠(Y/N)';
comment on column FG_YWYBA_INFO.clbz
  is '处理标志(0:待处理  1:正在处理   2:处理结束) 用于自动取数逻辑';
comment on column FG_YWYBA_INFO.tqbz
  is '提取标志';
comment on column FG_YWYBA_INFO.tqsj
  is '提取时间';
comment on column FG_YWYBA_INFO.tqcs
  is '提取次数';
create index IDX_FG_YWYBA_INFO_QYHGDM on FG_YWYBA_INFO (QYHGDM);
create index INX_FG_YWYBA_INFO_NSRSBH on FG_YWYBA_INFO (NSRSBH);
alter table FG_YWYBA_INFO
  add constraint PK_FG_YWYBA_INFO primary key (ID);

prompt
prompt Creating table GS_NOTICE_DOCFILE
prompt ================================
prompt
create table GS_NOTICE_DOCFILE
(
  id       NUMBER(18) not null,
  filename VARCHAR2(1000),
  filesize NUMBER(18),
  filetype VARCHAR2(100) not null,
  crtime   DATE not null,
  content  BLOB,
  noticeid NUMBER(18) not null
)
;
alter table GS_NOTICE_DOCFILE
  add constraint PK_NOTICE_DOCFILE_ID primary key (ID);

prompt
prompt Creating table GS_NOTICE_MAIN
prompt =============================
prompt
create table GS_NOTICE_MAIN
(
  id             NUMBER(18) not null,
  title          VARCHAR2(200) not null,
  content        CLOB not null,
  release_user   VARCHAR2(100) not null,
  release_czydm  VARCHAR2(20) not null,
  release_swjg   VARCHAR2(100) not null,
  release_swjgdm VARCHAR2(11) not null,
  release_time   DATE,
  valid_time     DATE,
  swjgdm_set     VARCHAR2(1000),
  qybj           CHAR(1) not null,
  bz             VARCHAR2(1000),
  swjgmc_set     VARCHAR2(1000),
  cx_time        DATE,
  exist_upfile   CHAR(1) default 0 not null,
  nsrsbh_set     VARCHAR2(1000),
  nsrdzdah_set   VARCHAR2(1000)
)
;
comment on table GS_NOTICE_MAIN
  is '通知公告';
comment on column GS_NOTICE_MAIN.title
  is '标题';
comment on column GS_NOTICE_MAIN.content
  is '正文';
comment on column GS_NOTICE_MAIN.release_user
  is '发布人';
comment on column GS_NOTICE_MAIN.release_czydm
  is '发布人账号';
comment on column GS_NOTICE_MAIN.release_swjg
  is '发布人税务机关名称';
comment on column GS_NOTICE_MAIN.release_swjgdm
  is '发布人税务机关代码';
comment on column GS_NOTICE_MAIN.release_time
  is '发布时间';
comment on column GS_NOTICE_MAIN.valid_time
  is '通知截止时间';
comment on column GS_NOTICE_MAIN.swjgdm_set
  is '发布范围税局机关代码';
comment on column GS_NOTICE_MAIN.qybj
  is '0.编辑，1.发布，2.撤销';
comment on column GS_NOTICE_MAIN.bz
  is '备注';
comment on column GS_NOTICE_MAIN.cx_time
  is '撤销时间';
comment on column GS_NOTICE_MAIN.exist_upfile
  is '是否存在附件';
comment on column GS_NOTICE_MAIN.nsrsbh_set
  is '纳税人识别号的集合';
comment on column GS_NOTICE_MAIN.nsrdzdah_set
  is '纳税人电子档案号的集合';
create unique index INDEX_NOTICE_ID on GS_NOTICE_MAIN (ID);
alter table GS_NOTICE_MAIN
  add constraint PK_NOTICE_MAIN_ID primary key (ID);

prompt
prompt Creating table GS_TRAINING
prompt ==========================
prompt
create table GS_TRAINING
(
  id               NUMBER(18) not null,
  originator       VARCHAR2(255),
  topic            VARCHAR2(255),
  synopsis         VARCHAR2(500),
  valid_date_start DATE,
  valid_date_end   DATE,
  person_limit     NUMBER(6),
  remain           NUMBER(6),
  address          VARCHAR2(500),
  contact          VARCHAR2(50),
  contact_tel      VARCHAR2(20),
  operator         VARCHAR2(20),
  isvalid          VARCHAR2(255),
  crtime           DATE,
  uptime           DATE,
  ticket           VARCHAR2(255),
  swjgdm           VARCHAR2(255),
  tssjq            DATE,
  tssjz            DATE
)
;
comment on column GS_TRAINING.id
  is '序号';
comment on column GS_TRAINING.originator
  is '发起单位';
comment on column GS_TRAINING.synopsis
  is '内容简介';
comment on column GS_TRAINING.person_limit
  is '人数上限';
comment on column GS_TRAINING.address
  is '培训地址';
comment on column GS_TRAINING.contact
  is '联系人';
comment on column GS_TRAINING.contact_tel
  is '联系电话';
comment on column GS_TRAINING.operator
  is '操作人';
comment on column GS_TRAINING.swjgdm
  is '发布人税务机关代码';
comment on column GS_TRAINING.tssjq
  is '安全助手推送时间起';
comment on column GS_TRAINING.tssjz
  is '推送时间止';
alter table GS_TRAINING
  add constraint PK_GS_TRAINING primary key (ID);

prompt
prompt Creating table GS_TRAINING_APPLY
prompt ================================
prompt
create table GS_TRAINING_APPLY
(
  id              NUMBER(20) not null,
  trainid         NUMBER(20) not null,
  company_name    VARCHAR2(255),
  shxydm          VARCHAR2(30),
  company_type    VARCHAR2(1),
  participant     VARCHAR2(30),
  participant_tel VARCHAR2(20),
  joinper         VARCHAR2(30),
  joinper_tel     VARCHAR2(20),
  oicq            VARCHAR2(13),
  openid          VARCHAR2(255),
  auth_code       VARCHAR2(10),
  sign_flag       VARCHAR2(1),
  crtime          DATE,
  uptime          DATE
)
;
alter table GS_TRAINING_APPLY
  add constraint PK_GS_TRAINING_APPLY primary key (ID);

prompt
prompt Creating table JSBK_CS_CZRY_DZB
prompt ===============================
prompt
create table JSBK_CS_CZRY_DZB
(
  czry_tssh VARCHAR2(30) not null,
  czry_hxzg VARCHAR2(30) not null
)
;
comment on table JSBK_CS_CZRY_DZB
  is '金三并库参数表-操作员对照';
alter table JSBK_CS_CZRY_DZB
  add primary key (CZRY_TSSH);

prompt
prompt Creating table RWGL_EXTERNAL
prompt ============================
prompt
create table RWGL_EXTERNAL
(
  id          NUMBER(18) not null,
  nsrsbh      VARCHAR2(18),
  task_type   VARCHAR2(3) not null,
  task_name   VARCHAR2(50),
  task_hash   VARCHAR2(50),
  task_status CHAR(1) not null,
  tqbz        VARCHAR2(32),
  tqsj        TIMESTAMP(6),
  tqcs        NUMBER(6),
  req_count   NUMBER(6),
  last_time   TIMESTAMP(6),
  creat_time  TIMESTAMP(6),
  update_time TIMESTAMP(6),
  first_time  TIMESTAMP(6),
  fetch_flag  CHAR(1),
  note        VARCHAR2(500),
  task_req    CLOB,
  task_res    CLOB,
  busikey     VARCHAR2(50)
)
;
comment on table RWGL_EXTERNAL
  is '单证备案-线程池任务表';
comment on column RWGL_EXTERNAL.id
  is '任务id';
comment on column RWGL_EXTERNAL.nsrsbh
  is '纳税人识别号';
comment on column RWGL_EXTERNAL.task_type
  is '任务类型';
comment on column RWGL_EXTERNAL.task_name
  is '任务名称';
comment on column RWGL_EXTERNAL.task_hash
  is '任务hash';
comment on column RWGL_EXTERNAL.task_status
  is '任务状态(0:待处理 1:处理中 2:处理失败   9:处理完毕)';
comment on column RWGL_EXTERNAL.tqbz
  is '提取标志';
comment on column RWGL_EXTERNAL.tqsj
  is '提取时间';
comment on column RWGL_EXTERNAL.tqcs
  is '提取次数';
comment on column RWGL_EXTERNAL.req_count
  is '请求次数';
comment on column RWGL_EXTERNAL.last_time
  is '最近一次获取时间';
comment on column RWGL_EXTERNAL.creat_time
  is '创建时间';
comment on column RWGL_EXTERNAL.update_time
  is '修改时间';
comment on column RWGL_EXTERNAL.first_time
  is '首次获取时间';
comment on column RWGL_EXTERNAL.fetch_flag
  is '获取标志（是-Y  否-N）';
comment on column RWGL_EXTERNAL.note
  is '错误信息';
comment on column RWGL_EXTERNAL.task_req
  is '任务请求';
comment on column RWGL_EXTERNAL.task_res
  is '任务响应';
comment on column RWGL_EXTERNAL.busikey
  is '业务外键，当task_type=003时，写入触发产生的备案任务的业务主键(采用从金三获取的模式，命名规则：nsrsbh|sbywzl|sssq|sbpc;采用从tl_bjts用户取数的模式，为sbid)。其他任务类型为空';
create unique index IDX_RWGL_EXTERNAL_HASH on RWGL_EXTERNAL (TASK_HASH);
create index IDX_RWGL_EXTERNAL_NTSF on RWGL_EXTERNAL (NSRSBH, TASK_TYPE, TASK_STATUS, FETCH_FLAG);
alter table RWGL_EXTERNAL
  add constraint RWGL_EXTERNAL_PK primary key (ID);

prompt
prompt Creating table RWGL_EXTERNAL_HIS
prompt ================================
prompt
create table RWGL_EXTERNAL_HIS
(
  id          NUMBER(18) not null,
  nsrsbh      VARCHAR2(18),
  task_type   VARCHAR2(3) not null,
  task_name   VARCHAR2(50),
  task_hash   VARCHAR2(50),
  task_status CHAR(1) not null,
  tqbz        VARCHAR2(32),
  tqsj        TIMESTAMP(6),
  tqcs        NUMBER(6),
  req_count   NUMBER(6),
  last_time   TIMESTAMP(6),
  creat_time  TIMESTAMP(6),
  update_time TIMESTAMP(6),
  first_time  TIMESTAMP(6),
  fetch_flag  CHAR(1),
  note        VARCHAR2(500),
  task_req    CLOB,
  task_res    CLOB,
  busikey     VARCHAR2(50)
)
;
comment on table RWGL_EXTERNAL_HIS
  is '单证备案-线程池任务历史数据备份表';
comment on column RWGL_EXTERNAL_HIS.id
  is '任务id';
comment on column RWGL_EXTERNAL_HIS.nsrsbh
  is '纳税人识别号';
comment on column RWGL_EXTERNAL_HIS.task_type
  is '任务类型';
comment on column RWGL_EXTERNAL_HIS.task_name
  is '任务名称';
comment on column RWGL_EXTERNAL_HIS.task_hash
  is '任务hash';
comment on column RWGL_EXTERNAL_HIS.task_status
  is '任务状态(0:待处理 1:处理中 2:处理失败   9:处理完毕)';
comment on column RWGL_EXTERNAL_HIS.tqbz
  is '提取标志';
comment on column RWGL_EXTERNAL_HIS.tqsj
  is '提取时间';
comment on column RWGL_EXTERNAL_HIS.tqcs
  is '提取次数';
comment on column RWGL_EXTERNAL_HIS.req_count
  is '请求次数';
comment on column RWGL_EXTERNAL_HIS.last_time
  is '最近一次获取时间';
comment on column RWGL_EXTERNAL_HIS.creat_time
  is '创建时间';
comment on column RWGL_EXTERNAL_HIS.update_time
  is '修改时间';
comment on column RWGL_EXTERNAL_HIS.first_time
  is '首次获取时间';
comment on column RWGL_EXTERNAL_HIS.fetch_flag
  is '获取标志（是-Y  否-N）';
comment on column RWGL_EXTERNAL_HIS.note
  is '错误信息';
comment on column RWGL_EXTERNAL_HIS.busikey
  is '业务外键，当task_type=003时，写入触发产生的备案任务的业务主键(采用从金三获取的模式，命名规则：nsrsbh|sbywzl|sssq|sbpc;采用从tl_bjts用户取数的模式，为sbid)。其他任务类型为空';
alter table RWGL_EXTERNAL_HIS
  add constraint RWGL_EXTERNAL_HIS_PK primary key (ID);

prompt
prompt Creating table RWGL_YBCL_XXZB
prompt =============================
prompt
create table RWGL_YBCL_XXZB
(
  rwlx      VARCHAR2(2) not null,
  rwhash    VARCHAR2(50) not null,
  rwname    VARCHAR2(50),
  rwbw      VARCHAR2(4000),
  rwms      VARCHAR2(200),
  rwzt      CHAR(1),
  tqbz      VARCHAR2(30),
  tqcs      NUMBER(4),
  tqsj      DATE,
  frtime    DATE,
  frnum     NUMBER(4),
  readnum   NUMBER(4),
  readtotal NUMBER(4),
  czrydm    VARCHAR2(20),
  czrymc    VARCHAR2(80) not null,
  crtime    DATE not null,
  swjgdm    VARCHAR2(11) not null,
  bz        VARCHAR2(200)
)
;
comment on table RWGL_YBCL_XXZB
  is '异步处理任务管理信息总表';
comment on column RWGL_YBCL_XXZB.rwlx
  is '任务类型';
comment on column RWGL_YBCL_XXZB.rwhash
  is '任务哈希(参数通过md5生成的哈希)';
comment on column RWGL_YBCL_XXZB.rwname
  is '任务中文名称';
comment on column RWGL_YBCL_XXZB.rwbw
  is '任务的报文';
comment on column RWGL_YBCL_XXZB.rwms
  is '任务的描述';
comment on column RWGL_YBCL_XXZB.rwzt
  is '任务状态(0:待处理  1:正在处理 2:处理完毕)';
comment on column RWGL_YBCL_XXZB.tqbz
  is '提取标志';
comment on column RWGL_YBCL_XXZB.tqcs
  is '提取次数';
comment on column RWGL_YBCL_XXZB.tqsj
  is '提取时间';
comment on column RWGL_YBCL_XXZB.frtime
  is '完成(刷新)时间';
comment on column RWGL_YBCL_XXZB.frnum
  is '总刷新次数(每刷新一次结果+1)';
comment on column RWGL_YBCL_XXZB.readnum
  is '读取次数(刷新后清0)';
comment on column RWGL_YBCL_XXZB.readtotal
  is '总读取次数(每次读取结果+1)';
comment on column RWGL_YBCL_XXZB.czrydm
  is '创建人员代码';
comment on column RWGL_YBCL_XXZB.czrymc
  is '创建人员名称';
comment on column RWGL_YBCL_XXZB.crtime
  is '创建时间';
comment on column RWGL_YBCL_XXZB.swjgdm
  is '税务机关代码';
comment on column RWGL_YBCL_XXZB.bz
  is '备注';
alter table RWGL_YBCL_XXZB
  add constraint PK_RWGL_YBCL_XXZB primary key (RWLX, RWHASH);

prompt
prompt Creating table SYS_CFG_TABLE_COLUMN
prompt ===================================
prompt
create table SYS_CFG_TABLE_COLUMN
(
  t_code      VARCHAR2(32) not null,
  t_c_code    VARCHAR2(32) not null,
  t_c_name    VARCHAR2(50),
  c_min_size  NUMBER,
  c_max_size  NUMBER,
  c_std_size  NUMBER,
  no          NUMBER,
  is_fixed    CHAR(1),
  is_order    CHAR(1),
  align       CHAR(1),
  isvaild     CHAR(1) default 1 not null,
  update_time DATE,
  create_time DATE,
  f1          VARCHAR2(32),
  f2          VARCHAR2(32),
  f3          VARCHAR2(32),
  f4          VARCHAR2(32),
  f5          VARCHAR2(32),
  degree      CHAR(1),
  d_config    CHAR(1)
)
;
comment on column SYS_CFG_TABLE_COLUMN.c_min_size
  is '默认最小列宽';
comment on column SYS_CFG_TABLE_COLUMN.c_max_size
  is '默认最大列宽';
comment on column SYS_CFG_TABLE_COLUMN.c_std_size
  is '列宽设置';
comment on column SYS_CFG_TABLE_COLUMN.no
  is '列表中的显示顺序';
comment on column SYS_CFG_TABLE_COLUMN.is_fixed
  is '列表中是否固定存在 0:否  1:是';
comment on column SYS_CFG_TABLE_COLUMN.is_order
  is '是否支持排序，0:不支持  1:支持';
comment on column SYS_CFG_TABLE_COLUMN.align
  is '0-居左(字符型) 1-居中 2-居右(数值型)';
comment on column SYS_CFG_TABLE_COLUMN.degree
  is '数值型保留的小数位';
comment on column SYS_CFG_TABLE_COLUMN.d_config
  is '默认是否显示字段(0/1),   1:默认显示(用户没有配置过sys_cfg_table_user对应的业务表时，列表中默认显示该字段)';
alter table SYS_CFG_TABLE_COLUMN
  add constraint PK_T_COLUMN primary key (T_CODE, T_C_CODE);

prompt
prompt Creating table SYS_CFG_TABLE_LIST
prompt =================================
prompt
create table SYS_CFG_TABLE_LIST
(
  t_code      VARCHAR2(32) not null,
  t_name      VARCHAR2(64) not null,
  isvaild     CHAR(1) default 1 not null,
  update_time DATE,
  create_time DATE,
  f1          VARCHAR2(32),
  f2          VARCHAR2(32),
  f3          VARCHAR2(32),
  f4          VARCHAR2(32),
  f5          VARCHAR2(32)
)
;
alter table SYS_CFG_TABLE_LIST
  add constraint PK_T_LIST primary key (T_CODE);

prompt
prompt Creating table SYS_CFG_TABLE_USER
prompt =================================
prompt
create table SYS_CFG_TABLE_USER
(
  user_id     VARCHAR2(64) not null,
  t_code      VARCHAR2(32) not null,
  cs          VARCHAR2(1000),
  isvaild     CHAR(1) default 1 not null,
  update_time DATE,
  create_time DATE,
  f1          VARCHAR2(32),
  f2          VARCHAR2(32),
  f3          VARCHAR2(32),
  f4          VARCHAR2(32),
  f5          VARCHAR2(32)
)
;
comment on column SYS_CFG_TABLE_USER.cs
  is '列名称集合，多个列代码用,隔开';
comment on column SYS_CFG_TABLE_USER.isvaild
  is '是否有效，默认1，即有效';
alter table SYS_CFG_TABLE_USER
  add constraint PK_T_USER primary key (USER_ID, T_CODE);

prompt
prompt Creating table SYS_CFG_YJBMDXX
prompt ==============================
prompt
create table SYS_CFG_YJBMDXX
(
  swjgdm    VARCHAR2(20) not null,
  qyhgdm    VARCHAR2(12) not null,
  yjcode    VARCHAR2(10) not null,
  yj_object VARCHAR2(20),
  qy_date   DATE not null,
  ty_date   DATE default TO_DATE('2100-1-1','YYYY-MM-DD') not null,
  remark    VARCHAR2(255),
  qymc      VARCHAR2(100),
  id        VARCHAR2(64) not null,
  is_valid  CHAR(1)
)
;
comment on column SYS_CFG_YJBMDXX.swjgdm
  is '税务机关代码';
comment on column SYS_CFG_YJBMDXX.yj_object
  is '预警对象，目前仅支持高风险商品代码';
comment on column SYS_CFG_YJBMDXX.qy_date
  is '启用日期';
comment on column SYS_CFG_YJBMDXX.ty_date
  is '停用日期';
comment on column SYS_CFG_YJBMDXX.id
  is '主键';
comment on column SYS_CFG_YJBMDXX.is_valid
  is '是否有效';
alter table SYS_CFG_YJBMDXX
  add constraint PK_YJBMDXX primary key (ID);

prompt
prompt Creating table SYS_CFG_YJSWJGXX
prompt ===============================
prompt
create table SYS_CFG_YJSWJGXX
(
  swjgdm  VARCHAR2(20) not null,
  yjcode  VARCHAR2(10) not null,
  is_push CHAR(1),
  remark  VARCHAR2(255),
  crtime  DATE,
  uptime  DATE,
  swjgmc  VARCHAR2(60)
)
;
comment on column SYS_CFG_YJSWJGXX.swjgdm
  is '税务机关代码';
comment on column SYS_CFG_YJSWJGXX.yjcode
  is '预警代码';
comment on column SYS_CFG_YJSWJGXX.is_push
  is '0,关闭，1，推送';
comment on column SYS_CFG_YJSWJGXX.remark
  is '备注';
comment on column SYS_CFG_YJSWJGXX.swjgmc
  is '税务机关名称';
alter table SYS_CFG_YJSWJGXX
  add constraint YJSWJGXX_PK primary key (YJCODE, SWJGDM);

prompt
prompt Creating table SYS_DICT
prompt =======================
prompt
create table SYS_DICT
(
  id        NUMBER(18) not null,
  dtype     VARCHAR2(50) not null,
  dcode     VARCHAR2(50) not null,
  dname     VARCHAR2(200) not null,
  addon     VARCHAR2(200),
  showorder NUMBER(9),
  note      VARCHAR2(200)
)
;
create unique index UQ_SYS_DICT_TC on SYS_DICT (DTYPE, DCODE);
alter table SYS_DICT
  add primary key (ID);

prompt
prompt Creating table SYS_GROUP
prompt ========================
prompt
create table SYS_GROUP
(
  code       VARCHAR2(50) not null,
  parentcode VARCHAR2(20),
  name       VARCHAR2(50) not null,
  remark     VARCHAR2(50),
  crtime     DATE,
  uptime     DATE,
  operid     NUMBER(18),
  isvalid    VARCHAR2(1)
)
;
comment on table SYS_GROUP
  is '权限管理_用户组表';
comment on column SYS_GROUP.code
  is '组代码';
comment on column SYS_GROUP.parentcode
  is '父组代码';
comment on column SYS_GROUP.name
  is '组名称';
comment on column SYS_GROUP.remark
  is '备注';
comment on column SYS_GROUP.crtime
  is '创建时间';
comment on column SYS_GROUP.uptime
  is '更新时间';
comment on column SYS_GROUP.operid
  is '操作人ID';
comment on column SYS_GROUP.isvalid
  is '是否有效';
alter table SYS_GROUP
  add constraint PK_CODE primary key (CODE);

prompt
prompt Creating table SYS_GROUP_ROLE
prompt =============================
prompt
create table SYS_GROUP_ROLE
(
  groupcode VARCHAR2(50) not null,
  rolecode  VARCHAR2(50) not null
)
;
comment on table SYS_GROUP_ROLE
  is '权限管理_用户组与角色关联表';
comment on column SYS_GROUP_ROLE.groupcode
  is '组代码';
comment on column SYS_GROUP_ROLE.rolecode
  is '角色代码';
alter table SYS_GROUP_ROLE
  add constraint PK_SYS_GROUP_ROLE primary key (GROUPCODE, ROLECODE);

prompt
prompt Creating table SYS_GROUP_USER
prompt =============================
prompt
create table SYS_GROUP_USER
(
  groupcode VARCHAR2(50) not null,
  czyid     NUMBER(18) not null
)
;
comment on table SYS_GROUP_USER
  is '权限管理_用户组与用户关联表';
comment on column SYS_GROUP_USER.groupcode
  is '组ID';
comment on column SYS_GROUP_USER.czyid
  is '操作员ID';
alter table SYS_GROUP_USER
  add constraint PK_SYS_GROUP_USER primary key (GROUPCODE, CZYID);

prompt
prompt Creating table SYS_MSG_NSR
prompt ==========================
prompt
create table SYS_MSG_NSR
(
  nsrdzdah NUMBER(20) not null,
  nsrsbh   VARCHAR2(20) not null,
  isvalid  VARCHAR2(1) default 1 not null,
  crtime   DATE default sysdate,
  uptime   DATE,
  type     VARCHAR2(10)
)
;
comment on column SYS_MSG_NSR.type
  is '会员类型';
alter table SYS_MSG_NSR
  add constraint PK_SYS_MSG_NSR primary key (NSRDZDAH);

prompt
prompt Creating table SYS_PERMISSION
prompt =============================
prompt
create table SYS_PERMISSION
(
  percode   VARCHAR2(50) not null,
  pername   VARCHAR2(50) not null,
  remark    VARCHAR2(50),
  crtime    DATE,
  uptime    DATE,
  operid    NUMBER(18),
  isvalid   VARCHAR2(1),
  ppercode  VARCHAR2(50),
  pertype   CHAR(1) not null,
  showorder NUMBER(9),
  childflag CHAR(1)
)
;
comment on table SYS_PERMISSION
  is '权限管理_权限表';
comment on column SYS_PERMISSION.percode
  is '权限代码';
comment on column SYS_PERMISSION.pername
  is '权限描述';
comment on column SYS_PERMISSION.remark
  is '备注';
comment on column SYS_PERMISSION.crtime
  is '创建时间';
comment on column SYS_PERMISSION.uptime
  is '更新时间';
comment on column SYS_PERMISSION.operid
  is '操作人ID';
comment on column SYS_PERMISSION.isvalid
  is '是否有效';
comment on column SYS_PERMISSION.ppercode
  is '父权限代码';
comment on column SYS_PERMISSION.pertype
  is 'M:菜单  F:功能';
comment on column SYS_PERMISSION.showorder
  is '显示顺序';
comment on column SYS_PERMISSION.childflag
  is '是否有下级';
alter table SYS_PERMISSION
  add constraint PK_SYS_PREMOISSION_CODE primary key (PERCODE);

prompt
prompt Creating table SYS_ROLE
prompt =======================
prompt
create table SYS_ROLE
(
  rolecode VARCHAR2(50) not null,
  rolename VARCHAR2(50) not null,
  remark   VARCHAR2(50),
  crtime   DATE,
  uptime   DATE,
  operid   NUMBER(18),
  isvalid  VARCHAR2(1)
)
;
comment on table SYS_ROLE
  is '权限管理_角色表';
comment on column SYS_ROLE.rolecode
  is '角色代码';
comment on column SYS_ROLE.rolename
  is '角色描述';
comment on column SYS_ROLE.remark
  is '备注';
comment on column SYS_ROLE.crtime
  is '创建时间';
comment on column SYS_ROLE.uptime
  is '更新时间';
comment on column SYS_ROLE.operid
  is '操作人ID';
comment on column SYS_ROLE.isvalid
  is '是否有效';
alter table SYS_ROLE
  add constraint PK_SYS_ROLE_CODE primary key (ROLECODE);

prompt
prompt Creating table SYS_ROLE_PERM
prompt ============================
prompt
create table SYS_ROLE_PERM
(
  rolecode VARCHAR2(50) not null,
  percode  VARCHAR2(50) not null
)
;
comment on table SYS_ROLE_PERM
  is '权限管理_角色权限关联表';
comment on column SYS_ROLE_PERM.rolecode
  is '角色代码';
comment on column SYS_ROLE_PERM.percode
  is '权限代码';
alter table SYS_ROLE_PERM
  add constraint PK_ROLE_PER_CODE primary key (ROLECODE, PERCODE);

prompt
prompt Creating table SYS_SEQUENCE
prompt ===========================
prompt
create table SYS_SEQUENCE
(
  tblname  VARCHAR2(200) not null,
  curvalue NUMBER(18) not null
)
;
comment on table SYS_SEQUENCE
  is '系统维护_系统序列表';
comment on column SYS_SEQUENCE.tblname
  is '数据表名称';
comment on column SYS_SEQUENCE.curvalue
  is '当前序列值';
alter table SYS_SEQUENCE
  add constraint PK_SYS_SEQUENCE primary key (TBLNAME);

prompt
prompt Creating table SYS_USER
prompt =======================
prompt
create table SYS_USER
(
  id         NUMBER(18) not null,
  parentid   NUMBER(18),
  czry_dm    VARCHAR2(20) not null,
  czry_mc    VARCHAR2(80) not null,
  password   VARCHAR2(50),
  swjg_dm    VARCHAR2(11) not null,
  czry_dm_zg VARCHAR2(20),
  usrstate   CHAR(1),
  crtime     DATE,
  crname     VARCHAR2(20),
  uptime     DATE,
  upname     VARCHAR2(20),
  qybz       CHAR(1) not null,
  qx_swjg    VARCHAR2(200),
  yhly       CHAR(1) default '0' not null,
  lxrdh      VARCHAR2(30)
)
;
comment on table SYS_USER
  is '用户管理_用户操作员表';
comment on column SYS_USER.id
  is '主键值';
comment on column SYS_USER.parentid
  is '父ID';
comment on column SYS_USER.czry_dm
  is '操作人员代码';
comment on column SYS_USER.czry_mc
  is '操作人员名称';
comment on column SYS_USER.password
  is '登陆密码';
comment on column SYS_USER.swjg_dm
  is '税务机关代码';
comment on column SYS_USER.czry_dm_zg
  is '对应征管系统代码';
comment on column SYS_USER.usrstate
  is '审核系统中的用户状态字段';
comment on column SYS_USER.crtime
  is '创建时间';
comment on column SYS_USER.crname
  is '创建人员';
comment on column SYS_USER.uptime
  is '更新时间';
comment on column SYS_USER.upname
  is '更新人员';
comment on column SYS_USER.qybz
  is '启用标志';
comment on column SYS_USER.qx_swjg
  is '权限税务机关代码';
comment on column SYS_USER.yhly
  is '默认为审核系统用户 1位自建用户';
comment on column SYS_USER.lxrdh
  is '操作人员联系人电话';
create unique index B_CZRY_DM on SYS_USER (CZRY_DM);
create index IDX_SYS_USER_IDX1 on SYS_USER (SWJG_DM);
alter table SYS_USER
  add constraint PK_SYS_USER_ID primary key (ID);

prompt
prompt Creating table SYS_USER_ROLE
prompt ============================
prompt
create table SYS_USER_ROLE
(
  czyid    NUMBER(18) not null,
  rolecode VARCHAR2(50) not null
)
;
comment on column SYS_USER_ROLE.czyid
  is '操作员ID';
comment on column SYS_USER_ROLE.rolecode
  is '角色代码';

prompt
prompt Creating table TB_REPORT_DATA
prompt =============================
prompt
create table TB_REPORT_DATA
(
  id        NUMBER(18) not null,
  sbqb      VARCHAR2(6) not null,
  value     NUMBER(12,2),
  sbywbdm   VARCHAR2(8),
  swjgdm    VARCHAR2(11) not null,
  valuetype CHAR(1),
  crtime    DATE
)
;
comment on column TB_REPORT_DATA.valuetype
  is '0、笔数，1、申报金额';
alter table TB_REPORT_DATA
  add constraint PK_ID primary key (ID);

prompt
prompt Creating table TJBB_CS_ZBRQ
prompt ===========================
prompt
create table TJBB_CS_ZBRQ
(
  bbny      VARCHAR2(6) not null,
  bbny_ksrq DATE,
  bbny_jzrq DATE,
  bbny_ksnf DATE
)
;
comment on table TJBB_CS_ZBRQ
  is '统计报表制表日期参数设置';
comment on column TJBB_CS_ZBRQ.bbny
  is '报表年月';
comment on column TJBB_CS_ZBRQ.bbny_ksrq
  is '报表区间——开始日期';
comment on column TJBB_CS_ZBRQ.bbny_jzrq
  is '报表区间——截止日期';
comment on column TJBB_CS_ZBRQ.bbny_ksnf
  is '报表区间——开始年份';
alter table TJBB_CS_ZBRQ
  add constraint PK_TJBB_CS_ZBRQ primary key (BBNY);

prompt
prompt Creating table TJBB_CX_CKTSSHSPQK
prompt =================================
prompt
create table TJBB_CX_CKTSSHSPQK
(
  paramhash VARCHAR2(64) not null,
  bblc      VARCHAR2(10) not null,
  swjgdm    VARCHAR2(32) not null,
  crtime    DATE default sysdate,
  bqtse_fh  NUMBER(16,2),
  bqtse_hz  NUMBER(16,2),
  bqtse_sp  NUMBER(16,2),
  bqtse_kp  NUMBER(16,2),
  ljtse_fh  NUMBER(16,2),
  ljtse_hz  NUMBER(16,2),
  ljtse_sp  NUMBER(16,2),
  ljtse_kp  NUMBER(16,2),
  dqdhztse  NUMBER(16,2),
  dqdsptse  NUMBER(16,2),
  dqdkptse  NUMBER(16,2)
)
;
comment on table TJBB_CX_CKTSSHSPQK
  is '查询统计--出口退税审核审批办理情况';
comment on column TJBB_CX_CKTSSHSPQK.bqtse_fh
  is '本期已复核数';
comment on column TJBB_CX_CKTSSHSPQK.bqtse_hz
  is '本期已核准数';
comment on column TJBB_CX_CKTSSHSPQK.bqtse_sp
  is '本期已审批数';
comment on column TJBB_CX_CKTSSHSPQK.bqtse_kp
  is '本期已开票退税数';
comment on column TJBB_CX_CKTSSHSPQK.ljtse_fh
  is '累计已复核数';
comment on column TJBB_CX_CKTSSHSPQK.ljtse_hz
  is '累计已核准数';
comment on column TJBB_CX_CKTSSHSPQK.ljtse_sp
  is '累计已审批数';
comment on column TJBB_CX_CKTSSHSPQK.ljtse_kp
  is '累计已退税开票';
comment on column TJBB_CX_CKTSSHSPQK.dqdhztse
  is '当前已复核待核准';
comment on column TJBB_CX_CKTSSHSPQK.dqdsptse
  is '当前已核准待审批';
comment on column TJBB_CX_CKTSSHSPQK.dqdkptse
  is '当前已审批待开票';
alter table TJBB_CX_CKTSSHSPQK
  add primary key (PARAMHASH, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_CZ_LOG
prompt ==========================
prompt
create table TJBB_CZ_LOG
(
  id     VARCHAR2(64) not null,
  swjgdm VARCHAR2(11),
  czry   VARCHAR2(20),
  cztime TIMESTAMP(6),
  czcode VARCHAR2(2),
  cztype CHAR(1),
  czobj  VARCHAR2(15)
)
;
comment on column TJBB_CZ_LOG.cztype
  is '1,任务流程';
comment on column TJBB_CZ_LOG.czobj
  is '操作对象';
alter table TJBB_CZ_LOG
  add constraint PK_TJBB_CZ_LOG primary key (ID);

prompt
prompt Creating table TJBB_DT_B01100
prompt =============================
prompt
create table TJBB_DT_B01100
(
  ssny           VARCHAR2(6) not null,
  bblc           VARCHAR2(10) not null,
  swjgdm         VARCHAR2(32) not null,
  rdhs           NUMBER(18),
  rdhs_hz        NUMBER(18),
  sbhs           NUMBER(18),
  sbhs_hz        NUMBER(18),
  sb_cke_xj      NUMBER(18,4),
  sb_cke_xj_hz   NUMBER(18,4),
  sb_cke_his     NUMBER(18,4),
  sb_cke_his_hz  NUMBER(18,4),
  sb_cke_cur     NUMBER(18,4),
  sb_cke_cur_hz  NUMBER(18,4),
  sb_tmse_xj     NUMBER(18,4),
  sb_tmse_xj_hz  NUMBER(18,4),
  sb_tmse_his    NUMBER(18,4),
  sb_tmse_his_hz NUMBER(18,4),
  sb_tmse_cur    NUMBER(18,4),
  sb_tmse_cur_hz NUMBER(18,4),
  sh_tmse_xj     NUMBER(18,4),
  sh_tmse_xj_hz  NUMBER(18,4),
  sh_tmse_his    NUMBER(18,4),
  sh_tmse_his_hz NUMBER(18,4),
  sh_tmse_cur    NUMBER(18,4),
  sh_tmse_cur_hz NUMBER(18,4),
  zh_tmse_xj     NUMBER(18,4),
  zh_tmse_xj_hz  NUMBER(18,4),
  zh_tmse_his    NUMBER(18,4),
  zh_tmse_his_hz NUMBER(18,4),
  zh_tmse_cur    NUMBER(18,4),
  zh_tmse_cur_hz NUMBER(18,4),
  by_tmse_xj     NUMBER(18,4),
  by_tmse_xj_hz  NUMBER(18,4),
  by_tmse_his    NUMBER(18,4),
  by_tmse_his_hz NUMBER(18,4),
  by_tmse_cur    NUMBER(18,4),
  by_tmse_cur_hz NUMBER(18,4),
  zt_tmse_xj     NUMBER(18,4),
  zt_tmse_xj_hz  NUMBER(18,4),
  zt_tmse_his    NUMBER(18,4),
  zt_tmse_his_hz NUMBER(18,4),
  zt_tmse_cur    NUMBER(18,4),
  zt_tmse_cur_hz NUMBER(18,4),
  sp_tk_xj       NUMBER(18,4),
  sp_tk_xj_hz    NUMBER(18,4),
  sp_tk_his      NUMBER(18,4),
  sp_tk_his_hz   NUMBER(18,4),
  sp_tk_cur      NUMBER(18,4),
  sp_tk_cur_hz   NUMBER(18,4),
  ys_tk          NUMBER(18,4),
  ys_tk_hz       NUMBER(18,4),
  ws_tk          NUMBER(18,4),
  ws_tk_hz       NUMBER(18,4),
  bl_tk_xj       NUMBER(18,4),
  bl_tk_xj_hz    NUMBER(18,4),
  bl_tk_his      NUMBER(18,4),
  bl_tk_his_hz   NUMBER(18,4),
  bl_tk_cur      NUMBER(18,4),
  bl_tk_cur_hz   NUMBER(18,4),
  zt_tk          NUMBER(18,4),
  zt_tk_hz       NUMBER(18,4),
  remark         VARCHAR2(400)
)
;
comment on column TJBB_DT_B01100.rdhs
  is '认定户数';
comment on column TJBB_DT_B01100.sbhs
  is '申报户数';
comment on column TJBB_DT_B01100.sb_cke_xj
  is '小计';
comment on column TJBB_DT_B01100.sb_cke_his
  is '以前年度出口货物申报累计';
comment on column TJBB_DT_B01100.sb_cke_cur
  is '当年出口货物申报累计';
comment on column TJBB_DT_B01100.sb_tmse_xj
  is '小计';
comment on column TJBB_DT_B01100.sb_tmse_his
  is '以前年度出口货物申报累计';
comment on column TJBB_DT_B01100.sb_tmse_cur
  is '当年出口货物申报累计';
comment on column TJBB_DT_B01100.sh_tmse_xj
  is '小计';
comment on column TJBB_DT_B01100.sh_tmse_his
  is '以前年度出口货物申报累计';
comment on column TJBB_DT_B01100.sh_tmse_cur
  is '当年出口货物申报累计';
comment on column TJBB_DT_B01100.zh_tmse_xj
  is '小计';
comment on column TJBB_DT_B01100.zh_tmse_his
  is '以前年度出口货物申报累计';
comment on column TJBB_DT_B01100.zh_tmse_cur
  is '当年出口货物申报累计';
comment on column TJBB_DT_B01100.by_tmse_xj
  is '小计';
comment on column TJBB_DT_B01100.by_tmse_his
  is '以前年度出口货物申报累计';
comment on column TJBB_DT_B01100.by_tmse_cur
  is '当年出口货物申报累计';
comment on column TJBB_DT_B01100.zt_tmse_xj
  is '小计';
comment on column TJBB_DT_B01100.zt_tmse_his
  is '以前年度出口货物申报累计';
comment on column TJBB_DT_B01100.zt_tmse_cur
  is '当年出口货物申报累计';
comment on column TJBB_DT_B01100.sp_tk_xj
  is '小计';
comment on column TJBB_DT_B01100.sp_tk_his
  is '以前年度出口货物申报累计';
comment on column TJBB_DT_B01100.sp_tk_cur
  is '当年出口货物申报累计';
comment on column TJBB_DT_B01100.ys_tk
  is '已送交国库退（调）库额';
comment on column TJBB_DT_B01100.ws_tk
  is '未送交国库退（调）库额';
comment on column TJBB_DT_B01100.bl_tk_xj
  is '小计';
comment on column TJBB_DT_B01100.bl_tk_his
  is '以前年度出口货物申报累计';
comment on column TJBB_DT_B01100.bl_tk_cur
  is '当年出口货物申报累计';
comment on column TJBB_DT_B01100.zt_tk
  is '退（调库）库在途数';
comment on column TJBB_DT_B01100.remark
  is '备注';
alter table TJBB_DT_B01100
  add constraint PK_TJBB_DT_B01100 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B01101
prompt =============================
prompt
create table TJBB_DT_B01101
(
  ssny          VARCHAR2(6) not null,
  bblc          VARCHAR2(10) not null,
  swjgdm        VARCHAR2(32) not null,
  hj_qyhs       NUMBER(16),
  hj_qyhs_hz    NUMBER(16),
  hj_tse        NUMBER(16,4),
  hj_tse_hz     NUMBER(16,4),
  fh_qyhs       NUMBER(16),
  fh_qyhs_hz    NUMBER(16),
  fh_tse_hj     NUMBER(16,4),
  fh_tse_hj_hz  NUMBER(16,4),
  fh_tse_his    NUMBER(16,4),
  fh_tse_his_hz NUMBER(16,4),
  fh_tse_cur    NUMBER(16,4),
  fh_tse_cur_hz NUMBER(16,4),
  hh_qyhs       NUMBER(16),
  hh_qyhs_hz    NUMBER(16),
  hh_tse_hj     NUMBER(16,4),
  hh_tse_hj_hz  NUMBER(16,4),
  hh_tse_his    NUMBER(16,4),
  hh_tse_his_hz NUMBER(16,4),
  hh_tse_cur    NUMBER(16,4),
  hh_tse_cur_hz NUMBER(16,4),
  dc_qyhs       NUMBER(16),
  dc_qyhs_hz    NUMBER(16),
  dc_tse_hj     NUMBER(16,4),
  dc_tse_hj_hz  NUMBER(16,4),
  dc_tse_his    NUMBER(16,4),
  dc_tse_his_hz NUMBER(16,4),
  dc_tse_cur    NUMBER(16,4),
  dc_tse_cur_hz NUMBER(16,4),
  yd_qyhs       NUMBER(16),
  yd_qyhs_hz    NUMBER(16),
  yd_tse_hj     NUMBER(16,4),
  yd_tse_hj_hz  NUMBER(16,4),
  yd_tse_his    NUMBER(16,4),
  yd_tse_his_hz NUMBER(16,4),
  yd_tse_cur    NUMBER(16,4),
  yd_tse_cur_hz NUMBER(16,4),
  remark        VARCHAR2(400)
)
;
comment on column TJBB_DT_B01101.hj_qyhs
  is '企业户数';
comment on column TJBB_DT_B01101.hj_tse
  is '退（免）税额';
comment on column TJBB_DT_B01101.fh_qyhs
  is '企业户数';
comment on column TJBB_DT_B01101.fh_tse_hj
  is '小计';
comment on column TJBB_DT_B01101.fh_tse_his
  is '以前年度';
comment on column TJBB_DT_B01101.fh_tse_cur
  is '当年出口';
comment on column TJBB_DT_B01101.hh_qyhs
  is '企业户数';
comment on column TJBB_DT_B01101.hh_tse_hj
  is '小计';
comment on column TJBB_DT_B01101.hh_tse_his
  is '以前年度';
comment on column TJBB_DT_B01101.hh_tse_cur
  is '当年出口';
comment on column TJBB_DT_B01101.dc_qyhs
  is '企业户数';
comment on column TJBB_DT_B01101.dc_tse_hj
  is '小计';
comment on column TJBB_DT_B01101.dc_tse_his
  is '以前年度';
comment on column TJBB_DT_B01101.dc_tse_cur
  is '当年出口';
comment on column TJBB_DT_B01101.yd_qyhs
  is '企业户数';
comment on column TJBB_DT_B01101.yd_tse_hj
  is '小计';
comment on column TJBB_DT_B01101.yd_tse_his
  is '以前年度';
comment on column TJBB_DT_B01101.yd_tse_cur
  is '当年出口';
comment on column TJBB_DT_B01101.remark
  is '备注';
alter table TJBB_DT_B01101
  add constraint PK_TJBB_DT_B01101 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B01102
prompt =============================
prompt
create table TJBB_DT_B01102
(
  ssny          VARCHAR2(6) not null,
  bblc          VARCHAR2(10) not null,
  swjgdm        VARCHAR2(32) not null,
  hj_qyhs       NUMBER(16),
  hj_qyhs_hz    NUMBER(16),
  hj_tse        NUMBER(16,4),
  hj_tse_hz     NUMBER(16,4),
  hh_qyhs       NUMBER(16),
  hh_qyhs_hz    NUMBER(16),
  hh_tse_xj     NUMBER(16,4),
  hh_tse_xj_hz  NUMBER(16,4),
  hh_tse_his    NUMBER(16,4),
  hh_tse_his_hz NUMBER(16,4),
  hh_tse_cur    NUMBER(16,4),
  hh_tse_cur_hz NUMBER(16,4),
  ba_qyhs       NUMBER(16),
  ba_qyhs_hz    NUMBER(16),
  ba_tse_xj     NUMBER(16,4),
  ba_tse_xj_hz  NUMBER(16,4),
  ba_tse_his    NUMBER(16,4),
  ba_tse_his_hz NUMBER(16,4),
  ba_tse_cur    NUMBER(16,4),
  ba_tse_cur_hz NUMBER(16,4),
  pz_qyhs       NUMBER(16),
  pz_qyhs_hz    NUMBER(16),
  pz_tse_xj     NUMBER(16,4),
  pz_tse_xj_hz  NUMBER(16,4),
  pz_tse_his    NUMBER(16,4),
  pz_tse_his_hz NUMBER(16,4),
  pz_tse_cur    NUMBER(16,4),
  pz_tse_cur_hz NUMBER(16,4),
  dl_qyhs       NUMBER(16),
  dl_qyhs_hz    NUMBER(16),
  dl_tse_xj     NUMBER(16,4),
  dl_tse_xj_hz  NUMBER(16,4),
  dl_tse_his    NUMBER(16,4),
  dl_tse_his_hz NUMBER(16,4),
  dl_tse_cur    NUMBER(16,4),
  dl_tse_cur_hz NUMBER(16,4),
  sh_qyhs       NUMBER(16),
  sh_qyhs_hz    NUMBER(16),
  sh_tse_xj     NUMBER(16,4),
  sh_tse_xj_hz  NUMBER(16,4),
  sh_tse_his    NUMBER(16,4),
  sh_tse_his_hz NUMBER(16,4),
  sh_tse_cur    NUMBER(16,4),
  sh_tse_cur_hz NUMBER(16,4),
  dc_qyhs       NUMBER(16),
  dc_qyhs_hz    NUMBER(16),
  dc_tse_xj     NUMBER(16,4),
  dc_tse_xj_hz  NUMBER(16,4),
  dc_tse_his    NUMBER(16,4),
  dc_tse_his_hz NUMBER(16,4),
  dc_tse_cur    NUMBER(16,4),
  dc_tse_cur_hz NUMBER(16,4),
  qt_qyhs       NUMBER(16),
  qt_qyhs_hz    NUMBER(16),
  qt_tse_xj     NUMBER(16,4),
  qt_tse_xj_hz  NUMBER(16,4),
  qt_tse_his    NUMBER(16,4),
  qt_tse_his_hz NUMBER(16,4),
  qt_tse_cur    NUMBER(16,4),
  qt_tse_cur_hz NUMBER(16,4),
  remark        VARCHAR2(400)
)
;
comment on column TJBB_DT_B01102.hj_qyhs
  is '企业户数';
comment on column TJBB_DT_B01102.hj_tse
  is '退（免）税额';
comment on column TJBB_DT_B01102.hh_qyhs
  is '企业户数';
comment on column TJBB_DT_B01102.hh_tse_xj
  is '小计';
comment on column TJBB_DT_B01102.hh_tse_his
  is '以前年度';
comment on column TJBB_DT_B01102.hh_tse_cur
  is '当年出口';
comment on column TJBB_DT_B01102.ba_qyhs
  is '企业户数';
comment on column TJBB_DT_B01102.ba_tse_xj
  is '小计';
comment on column TJBB_DT_B01102.ba_tse_his
  is '以前年度';
comment on column TJBB_DT_B01102.ba_tse_cur
  is '当年出口';
comment on column TJBB_DT_B01102.pz_qyhs
  is '企业户数';
comment on column TJBB_DT_B01102.pz_tse_xj
  is '小计';
comment on column TJBB_DT_B01102.pz_tse_his
  is '以前年度';
comment on column TJBB_DT_B01102.pz_tse_cur
  is '当年出口';
comment on column TJBB_DT_B01102.dl_qyhs
  is '企业户数';
comment on column TJBB_DT_B01102.dl_tse_xj
  is '小计';
comment on column TJBB_DT_B01102.dl_tse_his
  is '以前年度';
comment on column TJBB_DT_B01102.dl_tse_cur
  is '当年出口';
comment on column TJBB_DT_B01102.sh_qyhs
  is '企业户数';
comment on column TJBB_DT_B01102.sh_tse_xj
  is '小计';
comment on column TJBB_DT_B01102.sh_tse_his
  is '以前年度';
comment on column TJBB_DT_B01102.sh_tse_cur
  is '当年出口';
comment on column TJBB_DT_B01102.dc_qyhs
  is '企业户数';
comment on column TJBB_DT_B01102.dc_tse_xj
  is '小计';
comment on column TJBB_DT_B01102.dc_tse_his
  is '以前年度';
comment on column TJBB_DT_B01102.dc_tse_cur
  is '当年出口';
comment on column TJBB_DT_B01102.qt_qyhs
  is '企业户数';
comment on column TJBB_DT_B01102.qt_tse_xj
  is '小计';
comment on column TJBB_DT_B01102.qt_tse_his
  is '以前年度';
comment on column TJBB_DT_B01102.qt_tse_cur
  is '当年出口';
comment on column TJBB_DT_B01102.remark
  is '备注';
alter table TJBB_DT_B01102
  add constraint PK_TJBB_DT_B01102 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B01103
prompt =============================
prompt
create table TJBB_DT_B01103
(
  ssny              VARCHAR2(6) not null,
  bblc              VARCHAR2(10) not null,
  swjgdm            VARCHAR2(32) not null,
  ck_fwmy_cur       NUMBER(16,4),
  ck_fwmy_cur_hz    NUMBER(16,4),
  ck_fwmy_his       NUMBER(16,4),
  ck_fwmy_his_hz    NUMBER(16,4),
  ck_fwmy_xj        NUMBER(16,4),
  ck_fwmy_xj_hz     NUMBER(16,4),
  ck_hj             NUMBER(16,4),
  ck_hj_hz          NUMBER(16,4),
  ck_sc_cur         NUMBER(16,4),
  ck_sc_cur_hz      NUMBER(16,4),
  ck_sc_his         NUMBER(16,4),
  ck_sc_his_hz      NUMBER(16,4),
  ck_sc_xj          NUMBER(16,4),
  ck_sc_xj_hz       NUMBER(16,4),
  ck_wm_cur         NUMBER(16,4),
  ck_wm_cur_hz      NUMBER(16,4),
  ck_wm_his         NUMBER(16,4),
  ck_wm_his_hz      NUMBER(16,4),
  ck_wm_xj          NUMBER(16,4),
  ck_wm_xj_hz       NUMBER(16,4),
  ck_wzf_cur        NUMBER(16,4),
  ck_wzf_cur_hz     NUMBER(16,4),
  ck_wzf_his        NUMBER(16,4),
  ck_wzf_his_hz     NUMBER(16,4),
  ck_wzf_xj         NUMBER(16,4),
  ck_wzf_xj_hz      NUMBER(16,4),
  cstse_fwmy_cur    NUMBER(16,4),
  cstse_fwmy_cur_hz NUMBER(16,4),
  cstse_fwmy_his    NUMBER(16,4),
  cstse_fwmy_his_hz NUMBER(16,4),
  cstse_fwmy_xj     NUMBER(16,4),
  cstse_fwmy_xj_hz  NUMBER(16,4),
  cstse_hj          NUMBER(16,4),
  cstse_hj_hz       NUMBER(16,4),
  cstse_sc_cur      NUMBER(16,4),
  cstse_sc_cur_hz   NUMBER(16,4),
  cstse_sc_his      NUMBER(16,4),
  cstse_sc_his_hz   NUMBER(16,4),
  cstse_sc_xj       NUMBER(16,4),
  cstse_sc_xj_hz    NUMBER(16,4),
  cstse_wm_cur      NUMBER(16,4),
  cstse_wm_cur_hz   NUMBER(16,4),
  cstse_wm_his      NUMBER(16,4),
  cstse_wm_his_hz   NUMBER(16,4),
  cstse_wm_xj       NUMBER(16,4),
  cstse_wm_xj_hz    NUMBER(16,4),
  cstse_wzf_cur     NUMBER(16,4),
  cstse_wzf_cur_hz  NUMBER(16,4),
  cstse_wzf_his     NUMBER(16,4),
  cstse_wzf_his_hz  NUMBER(16,4),
  cstse_wzf_xj      NUMBER(16,4),
  cstse_wzf_xj_hz   NUMBER(16,4),
  hj_qyhs           NUMBER(16),
  hj_qyhs_hz        NUMBER(16),
  qyhs_fwmy         NUMBER(16),
  qyhs_fwmy_hz      NUMBER(16),
  qyhs_sc           NUMBER(16),
  qyhs_sc_hz        NUMBER(16),
  qyhs_wm           NUMBER(16),
  qyhs_wm_hz        NUMBER(16),
  qyhs_wzf          NUMBER(16),
  qyhs_wzf_hz       NUMBER(16),
  swjgmc            VARCHAR2(100),
  tse_per_usd       NUMBER(16,4),
  tse_per_usd_hz    NUMBER(16,4)
)
;
comment on column TJBB_DT_B01103.ck_fwmy_cur
  is '本年出口';
comment on column TJBB_DT_B01103.ck_fwmy_his
  is '以前年度';
comment on column TJBB_DT_B01103.ck_fwmy_xj
  is '小计';
comment on column TJBB_DT_B01103.ck_hj
  is '合计';
comment on column TJBB_DT_B01103.ck_sc_cur
  is '本年出口';
comment on column TJBB_DT_B01103.ck_sc_his
  is '以前年度';
comment on column TJBB_DT_B01103.ck_sc_xj
  is '小计';
comment on column TJBB_DT_B01103.ck_wm_cur
  is '本年出口';
comment on column TJBB_DT_B01103.ck_wm_his
  is '以前年度';
comment on column TJBB_DT_B01103.ck_wm_xj
  is '小计';
comment on column TJBB_DT_B01103.ck_wzf_cur
  is '本年出口';
comment on column TJBB_DT_B01103.ck_wzf_his
  is '以前年度';
comment on column TJBB_DT_B01103.ck_wzf_xj
  is '小计';
comment on column TJBB_DT_B01103.cstse_fwmy_cur
  is '本年出口';
comment on column TJBB_DT_B01103.cstse_fwmy_his
  is '以前年度';
comment on column TJBB_DT_B01103.cstse_fwmy_xj
  is '小计';
comment on column TJBB_DT_B01103.cstse_hj
  is '合计';
comment on column TJBB_DT_B01103.cstse_sc_cur
  is '本年出口';
comment on column TJBB_DT_B01103.cstse_sc_his
  is '以前年度';
comment on column TJBB_DT_B01103.cstse_sc_xj
  is '小计';
comment on column TJBB_DT_B01103.cstse_wm_cur
  is '本年出口';
comment on column TJBB_DT_B01103.cstse_wm_his
  is '以前年度';
comment on column TJBB_DT_B01103.cstse_wm_xj
  is '小计';
comment on column TJBB_DT_B01103.cstse_wzf_cur
  is '本年出口';
comment on column TJBB_DT_B01103.cstse_wzf_his
  is '以前年度';
comment on column TJBB_DT_B01103.cstse_wzf_xj
  is '小计';
comment on column TJBB_DT_B01103.hj_qyhs
  is '合计';
comment on column TJBB_DT_B01103.qyhs_fwmy
  is '服务贸易';
comment on column TJBB_DT_B01103.qyhs_sc
  is '生产企业';
comment on column TJBB_DT_B01103.qyhs_wm
  is '外贸企业';
comment on column TJBB_DT_B01103.qyhs_wzf
  is '外贸综合服务企业';
comment on column TJBB_DT_B01103.swjgmc
  is '地区';
comment on column TJBB_DT_B01103.tse_per_usd
  is '每美元退税额';
alter table TJBB_DT_B01103
  add constraint PK_TJBB_DT_B01103 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B01104
prompt =============================
prompt
create table TJBB_DT_B01104
(
  ssny              VARCHAR2(6) not null,
  bblc              VARCHAR2(10) not null,
  swjgdm            VARCHAR2(32) not null,
  cke_hj            NUMBER(16,4),
  cke_hj_hz         NUMBER(16,4),
  ck_fwmy_cur       NUMBER(16,4),
  ck_fwmy_cur_hz    NUMBER(16,4),
  ck_fwmy_his       NUMBER(16,4),
  ck_fwmy_his_hz    NUMBER(16,4),
  ck_fwmy_xj        NUMBER(16,4),
  ck_fwmy_xj_hz     NUMBER(16,4),
  ck_sc_cur         NUMBER(16,4),
  ck_sc_cur_hz      NUMBER(16,4),
  ck_sc_his         NUMBER(16,4),
  ck_sc_his_hz      NUMBER(16,4),
  ck_sc_xj          NUMBER(16,4),
  ck_sc_xj_hz       NUMBER(16,4),
  ck_wm_cur         NUMBER(16,4),
  ck_wm_cur_hz      NUMBER(16,4),
  ck_wm_his         NUMBER(16,4),
  ck_wm_his_hz      NUMBER(16,4),
  ck_wm_xj          NUMBER(16,4),
  ck_wm_xj_hz       NUMBER(16,4),
  ck_wzf_cur        NUMBER(16,4),
  ck_wzf_cur_hz     NUMBER(16,4),
  ck_wzf_his        NUMBER(16,4),
  ck_wzf_his_hz     NUMBER(16,4),
  ck_wzf_xj         NUMBER(16,4),
  ck_wzf_xj_hz      NUMBER(16,4),
  cstse_fwmy_cur    NUMBER(16,4),
  cstse_fwmy_cur_hz NUMBER(16,4),
  cstse_fwmy_his    NUMBER(16,4),
  cstse_fwmy_his_hz NUMBER(16,4),
  cstse_fwmy_xj     NUMBER(16,4),
  cstse_fwmy_xj_hz  NUMBER(16,4),
  cstse_hj          NUMBER(16,4),
  cstse_hj_hz       NUMBER(16,4),
  cstse_sc_cur      NUMBER(16,4),
  cstse_sc_cur_hz   NUMBER(16,4),
  cstse_sc_his      NUMBER(16,4),
  cstse_sc_his_hz   NUMBER(16,4),
  cstse_sc_xj       NUMBER(16,4),
  cstse_sc_xj_hz    NUMBER(16,4),
  cstse_wm_cur      NUMBER(16,4),
  cstse_wm_cur_hz   NUMBER(16,4),
  cstse_wm_his      NUMBER(16,4),
  cstse_wm_his_hz   NUMBER(16,4),
  cstse_wm_xj       NUMBER(16,4),
  cstse_wm_xj_hz    NUMBER(16,4),
  cstse_wzf_cur     NUMBER(16,4),
  cstse_wzf_cur_hz  NUMBER(16,4),
  cstse_wzf_his     NUMBER(16,4),
  cstse_wzf_his_hz  NUMBER(16,4),
  cstse_wzf_xj      NUMBER(16,4),
  cstse_wzf_xj_hz   NUMBER(16,4),
  qyhs_fwmy         NUMBER(16),
  qyhs_fwmy_hz      NUMBER(16),
  qyhs_hj           NUMBER(16),
  qyhs_hj_hz        NUMBER(16),
  qyhs_sc           NUMBER(16),
  qyhs_sc_hz        NUMBER(16),
  qyhs_wm           NUMBER(16),
  qyhs_wm_hz        NUMBER(16),
  qyhs_wzf          NUMBER(16),
  qyhs_wzf_hz       NUMBER(16),
  swjgmc            VARCHAR2(100),
  tse_per_usd       NUMBER(16,4),
  tse_per_usd_hz    NUMBER(16,4)
)
;
comment on column TJBB_DT_B01104.cke_hj
  is '合计';
comment on column TJBB_DT_B01104.ck_fwmy_cur
  is '本年出口';
comment on column TJBB_DT_B01104.ck_fwmy_his
  is '以前年度';
comment on column TJBB_DT_B01104.ck_fwmy_xj
  is '小计';
comment on column TJBB_DT_B01104.ck_sc_cur
  is '本年出口';
comment on column TJBB_DT_B01104.ck_sc_his
  is '以前年度';
comment on column TJBB_DT_B01104.ck_sc_xj
  is '小计';
comment on column TJBB_DT_B01104.ck_wm_cur
  is '本年出口';
comment on column TJBB_DT_B01104.ck_wm_his
  is '以前年度';
comment on column TJBB_DT_B01104.ck_wm_xj
  is '小计';
comment on column TJBB_DT_B01104.ck_wzf_cur
  is '本年出口';
comment on column TJBB_DT_B01104.ck_wzf_his
  is '以前年度';
comment on column TJBB_DT_B01104.ck_wzf_xj
  is '小计';
comment on column TJBB_DT_B01104.cstse_fwmy_cur
  is '本年出口';
comment on column TJBB_DT_B01104.cstse_fwmy_his
  is '以前年度';
comment on column TJBB_DT_B01104.cstse_fwmy_xj
  is '小计';
comment on column TJBB_DT_B01104.cstse_hj
  is '合计';
comment on column TJBB_DT_B01104.cstse_sc_cur
  is '本年出口';
comment on column TJBB_DT_B01104.cstse_sc_his
  is '以前年度';
comment on column TJBB_DT_B01104.cstse_sc_xj
  is '小计';
comment on column TJBB_DT_B01104.cstse_wm_cur
  is '本年出口';
comment on column TJBB_DT_B01104.cstse_wm_his
  is '以前年度';
comment on column TJBB_DT_B01104.cstse_wm_xj
  is '小计';
comment on column TJBB_DT_B01104.cstse_wzf_cur
  is '本年出口';
comment on column TJBB_DT_B01104.cstse_wzf_his
  is '以前年度';
comment on column TJBB_DT_B01104.cstse_wzf_xj
  is '小计';
comment on column TJBB_DT_B01104.qyhs_fwmy
  is '服务贸易';
comment on column TJBB_DT_B01104.qyhs_hj
  is '合计';
comment on column TJBB_DT_B01104.qyhs_sc
  is '生产企业';
comment on column TJBB_DT_B01104.qyhs_wm
  is '外贸企业';
comment on column TJBB_DT_B01104.qyhs_wzf
  is '外贸综合服务企业';
comment on column TJBB_DT_B01104.swjgmc
  is '税务机关名称';
comment on column TJBB_DT_B01104.tse_per_usd
  is '每美元退税额';
alter table TJBB_DT_B01104
  add constraint PK_TJBB_DT_B01104 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B01105
prompt =============================
prompt
create table TJBB_DT_B01105
(
  ssny       VARCHAR2(6) not null,
  bblc       VARCHAR2(10) not null,
  swjgdm     VARCHAR2(32) not null,
  je         NUMBER(16,4),
  je_hz      NUMBER(16,4),
  qyhs       NUMBER(16),
  qyhs_hz    NUMBER(16),
  xfs_cur    NUMBER(16,4),
  xfs_cur_hz NUMBER(16,4),
  xfs_his    NUMBER(16,4),
  xfs_his_hz NUMBER(16,4),
  xfs_xj     NUMBER(16,4),
  xfs_xj_hz  NUMBER(16,4),
  zzs_cur    NUMBER(16,4),
  zzs_cur_hz NUMBER(16,4),
  zzs_his    NUMBER(16,4),
  zzs_his_hz NUMBER(16,4),
  zzs_xj     NUMBER(16,4),
  zzs_xj_hz  NUMBER(16,4)
)
;
comment on column TJBB_DT_B01105.je
  is '金额';
comment on column TJBB_DT_B01105.qyhs
  is '企业户数';
comment on column TJBB_DT_B01105.xfs_cur
  is '本年出口';
comment on column TJBB_DT_B01105.xfs_his
  is '以前年度';
comment on column TJBB_DT_B01105.xfs_xj
  is '小计';
comment on column TJBB_DT_B01105.zzs_cur
  is '本年出口';
comment on column TJBB_DT_B01105.zzs_his
  is '以前年度';
comment on column TJBB_DT_B01105.zzs_xj
  is '小计';
alter table TJBB_DT_B01105
  add constraint PK_TJBB_DT_B01105 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B01106
prompt =============================
prompt
create table TJBB_DT_B01106
(
  ssny       VARCHAR2(6) not null,
  bblc       VARCHAR2(10) not null,
  swjgdm     VARCHAR2(32) not null,
  ay         VARCHAR2(100),
  byja       VARCHAR2(16),
  bz         VARCHAR2(200),
  cke        NUMBER(16,4),
  cke_hz     NUMBER(16,4),
  jsdw       VARCHAR2(50),
  jsr        VARCHAR2(16),
  jssj       DATE,
  lasj       DATE,
  lazt       VARCHAR2(16),
  mdse       NUMBER(16,4),
  mdse_hz    NUMBER(16,4),
  nsrmc      VARCHAR2(100),
  nsrsbh     VARCHAR2(18),
  spdm       VARCHAR2(40),
  spmc       VARCHAR2(100),
  sumary     VARCHAR2(4000),
  tmse_hj    NUMBER(16,4),
  tmse_hj_hz NUMBER(16,4),
  tse        NUMBER(16,4),
  tse_hz     NUMBER(16,4),
  xh         VARCHAR2(16),
  xhzt       VARCHAR2(16),
  ysdw       VARCHAR2(50),
  ysr        VARCHAR2(16),
  yssj       DATE,
  ysswh      VARCHAR2(20),
  zyay       VARCHAR2(4000)
)
;
comment on column TJBB_DT_B01106.ay
  is '案源';
comment on column TJBB_DT_B01106.byja
  is '不予接案';
comment on column TJBB_DT_B01106.bz
  is '备注';
comment on column TJBB_DT_B01106.cke
  is '出口额（万美元）';
comment on column TJBB_DT_B01106.jsdw
  is '接收单位';
comment on column TJBB_DT_B01106.jsr
  is '接收人';
comment on column TJBB_DT_B01106.jssj
  is '接收时间';
comment on column TJBB_DT_B01106.lasj
  is '立案时间';
comment on column TJBB_DT_B01106.lazt
  is '立案状态';
comment on column TJBB_DT_B01106.mdse
  is '免抵税额';
comment on column TJBB_DT_B01106.nsrmc
  is '名称';
comment on column TJBB_DT_B01106.nsrsbh
  is '纳税人识别号';
comment on column TJBB_DT_B01106.spdm
  is '商品编码';
comment on column TJBB_DT_B01106.spmc
  is '名称';
comment on column TJBB_DT_B01106.sumary
  is '案源信息摘要';
comment on column TJBB_DT_B01106.tmse_hj
  is '合计';
comment on column TJBB_DT_B01106.tse
  is '退税额';
comment on column TJBB_DT_B01106.xh
  is '序号';
comment on column TJBB_DT_B01106.xhzt
  is '销号状态';
comment on column TJBB_DT_B01106.ysdw
  is '移送单位';
comment on column TJBB_DT_B01106.ysr
  is '移送人';
comment on column TJBB_DT_B01106.yssj
  is '移送时间';
comment on column TJBB_DT_B01106.ysswh
  is '移送书文号';
comment on column TJBB_DT_B01106.zyay
  is '主要案情';
alter table TJBB_DT_B01106
  add constraint PK_TJBB_DT_B01106 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B01107
prompt =============================
prompt
create table TJBB_DT_B01107
(
  ssny          VARCHAR2(6) not null,
  bblc          VARCHAR2(10) not null,
  swjgdm        VARCHAR2(32) not null,
  gj_lv         NUMBER(16,2),
  gj_lv_hz      NUMBER(16,2),
  jg_ds_city    NUMBER(16),
  jg_ds_city_hz NUMBER(16),
  jg_ds_jg      NUMBER(16),
  jg_ds_jg_hz   NUMBER(16),
  jg_ds_lv      NUMBER(16,2),
  jg_ds_lv_hz   NUMBER(16,2),
  jg_hj         NUMBER(16),
  jg_hj_hz      NUMBER(16),
  jg_xj_city    NUMBER(16),
  jg_xj_city_hz NUMBER(16),
  jg_xj_jg      NUMBER(16),
  jg_xj_jg_hz   NUMBER(16),
  jg_xj_lv      NUMBER(16,2),
  jg_xj_lv_hz   NUMBER(16,2),
  per_se        NUMBER(16,4),
  per_se_hz     NUMBER(16,4),
  per_se_gj     NUMBER(16,4),
  per_se_gj_hz  NUMBER(16,4),
  ry_ds         NUMBER(16),
  ry_ds_hz      NUMBER(16),
  ry_ds_lv      NUMBER(16,2),
  ry_ds_lv_hz   NUMBER(16,2),
  ry_gj_lv      NUMBER(16,2),
  ry_gj_lv_hz   NUMBER(16,2),
  ry_hj         NUMBER(16),
  ry_hj_hz      NUMBER(16),
  ry_xj         NUMBER(16),
  ry_xj_hz      NUMBER(16),
  ry_xj_lv      NUMBER(16,2),
  ry_xj_lv_hz   NUMBER(16,2),
  swjgmc        VARCHAR2(40)
)
;
comment on column TJBB_DT_B01107.gj_lv
  is '占全国比重（%）';
comment on column TJBB_DT_B01107.jg_ds_city
  is '城市数量';
comment on column TJBB_DT_B01107.jg_ds_jg
  is '机构数量';
comment on column TJBB_DT_B01107.jg_ds_lv
  is '占比（%）';
comment on column TJBB_DT_B01107.jg_hj
  is '本省机构数量合计';
comment on column TJBB_DT_B01107.jg_xj_city
  is '县区数量';
comment on column TJBB_DT_B01107.jg_xj_jg
  is '机构数量';
comment on column TJBB_DT_B01107.jg_xj_lv
  is '占比（%）';
comment on column TJBB_DT_B01107.per_se
  is '税额';
comment on column TJBB_DT_B01107.per_se_gj
  is '与全国人均比较';
comment on column TJBB_DT_B01107.ry_ds
  is '人员数量';
comment on column TJBB_DT_B01107.ry_ds_lv
  is '占本省比重（%）';
comment on column TJBB_DT_B01107.ry_gj_lv
  is '占全国比重（%）';
comment on column TJBB_DT_B01107.ry_hj
  is '本省人员数量合计';
comment on column TJBB_DT_B01107.ry_xj
  is '人员数量';
comment on column TJBB_DT_B01107.ry_xj_lv
  is '占本省比重（%）';
comment on column TJBB_DT_B01107.swjgmc
  is '税务机关名称';
alter table TJBB_DT_B01107
  add constraint PK_TJBB_DT_B01107 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B01108
prompt =============================
prompt
create table TJBB_DT_B01108
(
  ssny            VARCHAR2(6) not null,
  bblc            VARCHAR2(10) not null,
  swjgdm          VARCHAR2(32) not null,
  rdhs            NUMBER(16),
  rdhs_hz         NUMBER(16),
  rd_sb_lv        NUMBER(16,4),
  rd_sb_lv_hz     NUMBER(16,4),
  sbhs            NUMBER(16),
  sbhs_hz         NUMBER(16),
  sb_cke_cur      NUMBER(16,4),
  sb_cke_cur_hz   NUMBER(16,4),
  sb_cke_his      NUMBER(16,4),
  sb_cke_his_hz   NUMBER(16,4),
  sb_cke_last     NUMBER(16,4),
  sb_cke_last_hz  NUMBER(16,4),
  sb_cke_tblv     NUMBER(16,4),
  sb_cke_tblv_hz  NUMBER(16,4),
  sb_cke_xj       NUMBER(16,4),
  sb_cke_xj_hz    NUMBER(16,4),
  sb_tmse_cur     NUMBER(16,4),
  sb_tmse_cur_hz  NUMBER(16,4),
  sb_tmse_his     NUMBER(16,4),
  sb_tmse_his_hz  NUMBER(16,4),
  sb_tmse_last    NUMBER(16,4),
  sb_tmse_last_hz NUMBER(16,4),
  sb_tmse_tblv    NUMBER(16,4),
  sb_tmse_tblv_hz NUMBER(16,4),
  sb_tmse_xj      NUMBER(16,4),
  sb_tmse_xj_hz   NUMBER(16,4),
  sh_tmse_cur     NUMBER(16,4),
  sh_tmse_cur_hz  NUMBER(16,4),
  sh_tmse_his     NUMBER(16,4),
  sh_tmse_his_hz  NUMBER(16,4),
  sh_tmse_last    NUMBER(16,4),
  sh_tmse_last_hz NUMBER(16,4),
  sh_tmse_tblv    NUMBER(16,4),
  sh_tmse_tblv_hz NUMBER(16,4),
  sh_tmse_xj      NUMBER(16,4),
  sh_tmse_xj_hz   NUMBER(16,4),
  sp_tmse_cur     NUMBER(16,4),
  sp_tmse_cur_hz  NUMBER(16,4),
  sp_tmse_his     NUMBER(16,4),
  sp_tmse_his_hz  NUMBER(16,4),
  sp_tmse_last    NUMBER(16,4),
  sp_tmse_last_hz NUMBER(16,4),
  sp_tmse_tblv    NUMBER(16,4),
  sp_tmse_tblv_hz NUMBER(16,4),
  sp_tmse_xj      NUMBER(16,4),
  sp_tmse_xj_hz   NUMBER(16,4),
  tk_jz_his       NUMBER(16,4),
  tk_jz_his_hz    NUMBER(16,4),
  tk_last         NUMBER(16,4),
  tk_last_hz      NUMBER(16,4),
  tk_sb_cur       NUMBER(16,4),
  tk_sb_cur_hz    NUMBER(16,4),
  tk_sb_his       NUMBER(16,4),
  tk_sb_his_hz    NUMBER(16,4),
  tk_tblv         NUMBER(16,4),
  tk_tblv_hz      NUMBER(16,4),
  tk_wbl_his      NUMBER(16,4),
  tk_wbl_his_hz   NUMBER(16,4),
  tk_xj           NUMBER(16,4),
  tk_xj_hz        NUMBER(16,4)
)
;
comment on column TJBB_DT_B01108.rdhs
  is '认定户数';
comment on column TJBB_DT_B01108.rd_sb_lv
  is '申报户数占认定户数的比率（100%）';
comment on column TJBB_DT_B01108.sbhs
  is '申报户数';
comment on column TJBB_DT_B01108.sb_cke_cur
  is '当年出口货物申报';
comment on column TJBB_DT_B01108.sb_cke_his
  is '以前年度出口货物申报';
comment on column TJBB_DT_B01108.sb_cke_last
  is '上年同期申报';
comment on column TJBB_DT_B01108.sb_cke_tblv
  is '同比变动率（100%）';
comment on column TJBB_DT_B01108.sb_cke_xj
  is '小计';
comment on column TJBB_DT_B01108.sb_tmse_cur
  is '当年出口货物申报';
comment on column TJBB_DT_B01108.sb_tmse_his
  is '以前年度出口货物申报';
comment on column TJBB_DT_B01108.sb_tmse_last
  is '上年同期申报';
comment on column TJBB_DT_B01108.sb_tmse_tblv
  is '同比变动率（100%）';
comment on column TJBB_DT_B01108.sb_tmse_xj
  is '小计';
comment on column TJBB_DT_B01108.sh_tmse_cur
  is '当年出口货物申报';
comment on column TJBB_DT_B01108.sh_tmse_his
  is '以前年度出口货物申报';
comment on column TJBB_DT_B01108.sh_tmse_last
  is '上年同期申报';
comment on column TJBB_DT_B01108.sh_tmse_tblv
  is '同比变动率（100%）';
comment on column TJBB_DT_B01108.sh_tmse_xj
  is '小计';
comment on column TJBB_DT_B01108.sp_tmse_cur
  is '当年出口货物申报';
comment on column TJBB_DT_B01108.sp_tmse_his
  is '以前年度出口货物申报';
comment on column TJBB_DT_B01108.sp_tmse_last
  is '上年同期申报';
comment on column TJBB_DT_B01108.sp_tmse_tblv
  is '同比变动率（100%）';
comment on column TJBB_DT_B01108.sp_tmse_xj
  is '小计';
comment on column TJBB_DT_B01108.tk_jz_his
  is '其中：以前年度结转';
comment on column TJBB_DT_B01108.tk_last
  is '上年同期办理';
comment on column TJBB_DT_B01108.tk_sb_cur
  is '当年出口货物申报';
comment on column TJBB_DT_B01108.tk_sb_his
  is '以前年度出口货物申报';
comment on column TJBB_DT_B01108.tk_tblv
  is '同比变动率（100%）';
comment on column TJBB_DT_B01108.tk_wbl_his
  is '其中：以前年度已审批未办理退库';
comment on column TJBB_DT_B01108.tk_xj
  is '小计';
alter table TJBB_DT_B01108
  add constraint PK_TJBB_DT_B01108 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B01109
prompt =============================
prompt
create table TJBB_DT_B01109
(
  ssny            VARCHAR2(6) not null,
  bblc            VARCHAR2(10) not null,
  swjgdm          VARCHAR2(32) not null,
  rdhs            NUMBER(16),
  rdhs_hz         NUMBER(16),
  rd_sb_lv        NUMBER(16,4),
  rd_sb_lv_hz     NUMBER(16,4),
  sbhs            NUMBER(16),
  sbhs_hz         NUMBER(16),
  sb_cke_cur      NUMBER(16,4),
  sb_cke_cur_hz   NUMBER(16,4),
  sb_cke_his      NUMBER(16,4),
  sb_cke_his_hz   NUMBER(16,4),
  sb_cke_last     NUMBER(16,4),
  sb_cke_last_hz  NUMBER(16,4),
  sb_cke_tblv     NUMBER(16,4),
  sb_cke_tblv_hz  NUMBER(16,4),
  sb_cke_xj       NUMBER(16,4),
  sb_cke_xj_hz    NUMBER(16,4),
  sb_tmse_cur     NUMBER(16,4),
  sb_tmse_cur_hz  NUMBER(16,4),
  sb_tmse_his     NUMBER(16,4),
  sb_tmse_his_hz  NUMBER(16,4),
  sb_tmse_last    NUMBER(16,4),
  sb_tmse_last_hz NUMBER(16,4),
  sb_tmse_tblv    NUMBER(16,4),
  sb_tmse_tblv_hz NUMBER(16,4),
  sb_tmse_xj      NUMBER(16,4),
  sb_tmse_xj_hz   NUMBER(16,4),
  sh_tmse_cur     NUMBER(16,4),
  sh_tmse_cur_hz  NUMBER(16,4),
  sh_tmse_his     NUMBER(16,4),
  sh_tmse_his_hz  NUMBER(16,4),
  sh_tmse_last    NUMBER(16,4),
  sh_tmse_last_hz NUMBER(16,4),
  sh_tmse_tblv    NUMBER(16,4),
  sh_tmse_tblv_hz NUMBER(16,4),
  sh_tmse_xj      NUMBER(16,4),
  sh_tmse_xj_hz   NUMBER(16,4),
  sp_tmse_cur     NUMBER(16,4),
  sp_tmse_cur_hz  NUMBER(16,4),
  sp_tmse_his     NUMBER(16,4),
  sp_tmse_his_hz  NUMBER(16,4),
  sp_tmse_last    NUMBER(16,4),
  sp_tmse_last_hz NUMBER(16,4),
  sp_tmse_tblv    NUMBER(16,4),
  sp_tmse_tblv_hz NUMBER(16,4),
  sp_tmse_xj      NUMBER(16,4),
  sp_tmse_xj_hz   NUMBER(16,4),
  tk_jz_his       NUMBER(16,4),
  tk_jz_his_hz    NUMBER(16,4),
  tk_last         NUMBER(16,4),
  tk_last_hz      NUMBER(16,4),
  tk_sb_cur       NUMBER(16,4),
  tk_sb_cur_hz    NUMBER(16,4),
  tk_sb_his       NUMBER(16,4),
  tk_sb_his_hz    NUMBER(16,4),
  tk_tblv         NUMBER(16,4),
  tk_tblv_hz      NUMBER(16,4),
  tk_wbl_his      NUMBER(16,4),
  tk_wbl_his_hz   NUMBER(16,4),
  tk_xj           NUMBER(16,4),
  tk_xj_hz        NUMBER(16,4)
)
;
comment on column TJBB_DT_B01109.rdhs
  is '认定户数';
comment on column TJBB_DT_B01109.rd_sb_lv
  is '申报户数占认定户数的比率（100%）';
comment on column TJBB_DT_B01109.sbhs
  is '申报户数';
comment on column TJBB_DT_B01109.sb_cke_cur
  is '当年出口货物申报';
comment on column TJBB_DT_B01109.sb_cke_his
  is '以前年度出口货物申报';
comment on column TJBB_DT_B01109.sb_cke_last
  is '上年同期申报';
comment on column TJBB_DT_B01109.sb_cke_tblv
  is '同比变动率（100%）';
comment on column TJBB_DT_B01109.sb_cke_xj
  is '小计';
comment on column TJBB_DT_B01109.sb_tmse_cur
  is '当年出口货物申报';
comment on column TJBB_DT_B01109.sb_tmse_his
  is '以前年度出口货物申报';
comment on column TJBB_DT_B01109.sb_tmse_last
  is '上年同期申报';
comment on column TJBB_DT_B01109.sb_tmse_tblv
  is '同比变动率（100%）';
comment on column TJBB_DT_B01109.sb_tmse_xj
  is '小计';
comment on column TJBB_DT_B01109.sh_tmse_cur
  is '当年出口货物申报';
comment on column TJBB_DT_B01109.sh_tmse_his
  is '以前年度出口货物申报';
comment on column TJBB_DT_B01109.sh_tmse_last
  is '上年同期申报';
comment on column TJBB_DT_B01109.sh_tmse_tblv
  is '同比变动率（100%）';
comment on column TJBB_DT_B01109.sh_tmse_xj
  is '小计';
comment on column TJBB_DT_B01109.sp_tmse_cur
  is '当年出口货物申报';
comment on column TJBB_DT_B01109.sp_tmse_his
  is '以前年度出口货物申报';
comment on column TJBB_DT_B01109.sp_tmse_last
  is '上年同期申报';
comment on column TJBB_DT_B01109.sp_tmse_tblv
  is '同比变动率（100%）';
comment on column TJBB_DT_B01109.sp_tmse_xj
  is '小计';
comment on column TJBB_DT_B01109.tk_jz_his
  is '其中：以前年度结转';
comment on column TJBB_DT_B01109.tk_last
  is '上年同期办理';
comment on column TJBB_DT_B01109.tk_sb_cur
  is '当年出口货物申报';
comment on column TJBB_DT_B01109.tk_sb_his
  is '以前年度出口货物申报';
comment on column TJBB_DT_B01109.tk_tblv
  is '同比变动率（100%）';
comment on column TJBB_DT_B01109.tk_wbl_his
  is '其中：以前年度已审批未办理退库';
comment on column TJBB_DT_B01109.tk_xj
  is '小计';
alter table TJBB_DT_B01109
  add constraint PK_TJBB_DT_B01109 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B02101
prompt =============================
prompt
create table TJBB_DT_B02101
(
  ssny               VARCHAR2(6) not null,
  bblc               VARCHAR2(10) not null,
  swjgdm             VARCHAR2(32) not null,
  bahs_hj            NUMBER(16),
  bahs_hj_hz         NUMBER(16),
  bahs_hj_add        NUMBER(16),
  bahs_hj_add_hz     NUMBER(16),
  bahs_sc            NUMBER(16),
  bahs_sc_hz         NUMBER(16),
  bahs_sc_add        NUMBER(16),
  bahs_sc_add_hz     NUMBER(16),
  bahs_wm            NUMBER(16),
  bahs_wm_hz         NUMBER(16),
  bahs_wm_add        NUMBER(16),
  bahs_wm_add_hz     NUMBER(16),
  bl_tmse_hj         NUMBER(16,4),
  bl_tmse_hj_hz      NUMBER(16,4),
  qyhs_tmse          NUMBER(16),
  qyhs_tmse_hz       NUMBER(16),
  sbhs_hj_mon        NUMBER(16),
  sbhs_hj_mon_hz     NUMBER(16),
  sbhs_hj_year       NUMBER(16),
  sbhs_hj_year_hz    NUMBER(16),
  sbhs_sc_mon        NUMBER(16),
  sbhs_sc_mon_hz     NUMBER(16),
  sbhs_sc_year       NUMBER(16),
  sbhs_sc_year_hz    NUMBER(16),
  sbhs_wm_mon        NUMBER(16),
  sbhs_wm_mon_hz     NUMBER(16),
  sbhs_wm_year       NUMBER(16),
  sbhs_wm_year_hz    NUMBER(16),
  sb_tmse_hj         NUMBER(16,4),
  sb_tmse_hj_hz      NUMBER(16,4),
  sddwdm             VARCHAR2(18),
  sdsj               VARCHAR2(64),
  sdsw               VARCHAR2(64),
  wzhbl_tmse_mon     NUMBER(16,4),
  wzhbl_tmse_mon_hz  NUMBER(16,4),
  wzhbl_tmse_year    NUMBER(16,4),
  wzhbl_tmse_year_hz NUMBER(16,4),
  wzhsb_tmse_mon     NUMBER(16,4),
  wzhsb_tmse_mon_hz  NUMBER(16,4),
  wzhsb_tmse_year    NUMBER(16,4),
  wzhsb_tmse_year_hz NUMBER(16,4)
)
;
comment on column TJBB_DT_B02101.bahs_hj
  is '已备案数';
comment on column TJBB_DT_B02101.bahs_hj_add
  is '其中：本年新增数';
comment on column TJBB_DT_B02101.bahs_sc
  is '已备案数';
comment on column TJBB_DT_B02101.bahs_sc_add
  is '其中：本年新增数';
comment on column TJBB_DT_B02101.bahs_wm
  is '已备案数';
comment on column TJBB_DT_B02101.bahs_wm_add
  is '其中：本年新增数';
comment on column TJBB_DT_B02101.bl_tmse_hj
  is '本年办理的退（免）税额';
comment on column TJBB_DT_B02101.qyhs_tmse
  is '本年有退（免）税申报业务的出口企业户数';
comment on column TJBB_DT_B02101.sbhs_hj_mon
  is '本期数';
comment on column TJBB_DT_B02101.sbhs_hj_year
  is '本年累计数';
comment on column TJBB_DT_B02101.sbhs_sc_mon
  is '本期数';
comment on column TJBB_DT_B02101.sbhs_sc_year
  is '本年累计数';
comment on column TJBB_DT_B02101.sbhs_wm_mon
  is '本期数';
comment on column TJBB_DT_B02101.sbhs_wm_year
  is '本年累计数';
comment on column TJBB_DT_B02101.sb_tmse_hj
  is '本年全部出口企业申报退（免）税额';
comment on column TJBB_DT_B02101.sddwdm
  is '试点单位代码';
comment on column TJBB_DT_B02101.sdsj
  is '试点开始时间';
comment on column TJBB_DT_B02101.sdsw
  is '试点单位';
comment on column TJBB_DT_B02101.wzhbl_tmse_mon
  is '本期数';
comment on column TJBB_DT_B02101.wzhbl_tmse_year
  is '本年累计数';
comment on column TJBB_DT_B02101.wzhsb_tmse_mon
  is '本期数';
comment on column TJBB_DT_B02101.wzhsb_tmse_year
  is '本年累计数';
alter table TJBB_DT_B02101
  add constraint PK_TJBB_DT_B02101 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B02102
prompt =============================
prompt
create table TJBB_DT_B02102
(
  ssny       VARCHAR2(6) not null,
  bblc       VARCHAR2(10) not null,
  swjgdm     VARCHAR2(32) not null,
  tssd_sl    NUMBER(16),
  tssd_sl_hz NUMBER(16),
  sqrs       NUMBER(16),
  sqrs_hz    NUMBER(16),
  sqdfs      NUMBER(16),
  sqdfs_hz   NUMBER(16),
  sqje       NUMBER(16,4),
  blrs       NUMBER(16),
  blrs_hz    NUMBER(16),
  blje       NUMBER(16,4),
  blje_hz    NUMBER(16,4),
  zytssp     VARCHAR2(400),
  sqje_hz    NUMBER(16,4)
)
;
comment on column TJBB_DT_B02102.tssd_sl
  is '退税商店数量';
comment on column TJBB_DT_B02102.sqrs
  is '申请开具离境退税申请单人数';
comment on column TJBB_DT_B02102.sqdfs
  is '开具离境退税申请单份数';
comment on column TJBB_DT_B02102.sqje
  is '涉及金额（万元）';
comment on column TJBB_DT_B02102.blrs
  is '申请退税人数';
comment on column TJBB_DT_B02102.blje
  is '办理退税金额（万元）';
comment on column TJBB_DT_B02102.zytssp
  is '主要退税商品';
alter table TJBB_DT_B02102
  add constraint PK_TJBB_DT_B02102 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B02103
prompt =============================
prompt
create table TJBB_DT_B02103
(
  ssny       VARCHAR2(6) not null,
  bblc       VARCHAR2(10) not null,
  swjgdm     VARCHAR2(32) not null,
  bahs       NUMBER(16),
  bahs_hz    NUMBER(16),
  bl_mdse    NUMBER(16,4),
  bl_mdse_hz NUMBER(16,4),
  bl_tmse    NUMBER(16,4),
  bl_tmse_hz NUMBER(16,4),
  bl_tse     NUMBER(16,4),
  bl_tse_hz  NUMBER(16,4),
  sbhs       NUMBER(16),
  sbhs_hz    NUMBER(16),
  sbtscke    NUMBER(16,4),
  sbtscke_hz NUMBER(16,4),
  sb_mdse    NUMBER(16,4),
  sb_mdse_hz NUMBER(16,4),
  sb_tmse    NUMBER(16,4),
  sb_tmse_hz NUMBER(16,4),
  sb_tse     NUMBER(16,4),
  sb_tse_hz  NUMBER(16,4),
  sh_mdse    NUMBER(16,4),
  sh_mdse_hz NUMBER(16,4),
  sh_tmse    NUMBER(16,4),
  sh_tmse_hz NUMBER(16,4),
  sh_tse     NUMBER(16,4),
  sh_tse_hz  NUMBER(16,4),
  zysp       VARCHAR2(400)
)
;
comment on column TJBB_DT_B02103.bahs
  is '备案户数';
comment on column TJBB_DT_B02103.bl_mdse
  is '免抵税额';
comment on column TJBB_DT_B02103.bl_tmse
  is '退（免）税额';
comment on column TJBB_DT_B02103.bl_tse
  is '退税额';
comment on column TJBB_DT_B02103.sbhs
  is '申报户数';
comment on column TJBB_DT_B02103.sbtscke
  is '申报退税出口额（万美元）';
comment on column TJBB_DT_B02103.sb_mdse
  is '免抵税额';
comment on column TJBB_DT_B02103.sb_tmse
  is '退（免）税额';
comment on column TJBB_DT_B02103.sb_tse
  is '退税额';
comment on column TJBB_DT_B02103.sh_mdse
  is '免抵税额';
comment on column TJBB_DT_B02103.sh_tmse
  is '退（免）税额';
comment on column TJBB_DT_B02103.sh_tse
  is '退税额';
comment on column TJBB_DT_B02103.zysp
  is '主要退税商品';
alter table TJBB_DT_B02103
  add constraint PK_TJBB_DT_B02103 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B02104
prompt =============================
prompt
create table TJBB_DT_B02104
(
  ssny       VARCHAR2(6) not null,
  bblc       VARCHAR2(10) not null,
  swjgdm     VARCHAR2(32) not null,
  bahs       NUMBER(16),
  bahs_hz    NUMBER(16),
  sbhs       NUMBER(16),
  sbhs_hz    NUMBER(16),
  sbtscke    NUMBER(16,4),
  sbtscke_hz NUMBER(16,4),
  zysp       VARCHAR2(400)
)
;
comment on column TJBB_DT_B02104.bahs
  is '市场经营户备案户数';
comment on column TJBB_DT_B02104.sbhs
  is '市场采购贸易经营者申报户数';
comment on column TJBB_DT_B02104.sbtscke
  is '申报免税出口额（万美元）';
comment on column TJBB_DT_B02104.zysp
  is '主要商品';
alter table TJBB_DT_B02104
  add constraint PK_TJBB_DT_B02104 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B02105
prompt =============================
prompt
create table TJBB_DT_B02105
(
  ssny               VARCHAR2(6) not null,
  bblc               VARCHAR2(10) not null,
  swjgdm             VARCHAR2(32) not null,
  gkbl_tke_his       NUMBER(16,4),
  gkbl_tke_his_hz    NUMBER(16,4),
  gkbl_tke_xj        NUMBER(16,4),
  gkbl_tke_xj_hz     NUMBER(16,4),
  gkbl_tke_year      NUMBER(16,4),
  gkbl_tke_year_hz   NUMBER(16,4),
  remark             VARCHAR2(200),
  sbhs               NUMBER(16),
  sbhs_hz            NUMBER(16),
  sblj_tmse_his      NUMBER(16,4),
  sblj_tmse_his_hz   NUMBER(16,4),
  sblj_tmse_year     NUMBER(16,4),
  sblj_tmse_year_hz  NUMBER(16,4),
  sblj_tscke_his     NUMBER(16,4),
  sblj_tscke_his_hz  NUMBER(16,4),
  sblj_tscke_year    NUMBER(16,4),
  sblj_tscke_year_hz NUMBER(16,4),
  sb_tmse_xj         NUMBER(16,4),
  sb_tmse_xj_hz      NUMBER(16,4),
  sb_tscke_xj        NUMBER(16,4),
  sb_tscke_xj_hz     NUMBER(16,4),
  shby_tmse_his      NUMBER(16,4),
  shby_tmse_his_hz   NUMBER(16,4),
  shby_tmse_xj       NUMBER(16,4),
  shby_tmse_xj_hz    NUMBER(16,4),
  shby_tmse_year     NUMBER(16,4),
  shby_tmse_year_hz  NUMBER(16,4),
  shlj_tmse_his      NUMBER(16,4),
  shlj_tmse_his_hz   NUMBER(16,4),
  shlj_tmse_year     NUMBER(16,4),
  shlj_tmse_year_hz  NUMBER(16,4),
  shzt_tmse_his      NUMBER(16,4),
  shzt_tmse_his_hz   NUMBER(16,4),
  shzt_tmse_xj       NUMBER(16,4),
  shzt_tmse_xj_hz    NUMBER(16,4),
  shzt_tmse_year     NUMBER(16,4),
  shzt_tmse_year_hz  NUMBER(16,4),
  sh_tmse_xj         NUMBER(16,4),
  sh_tmse_xj_hz      NUMBER(16,4),
  sptk_tke_his       NUMBER(16,4),
  sptk_tke_his_hz    NUMBER(16,4),
  sptk_tke_xj        NUMBER(16,4),
  sptk_tke_xj_hz     NUMBER(16,4),
  sptk_tke_year      NUMBER(16,4),
  sptk_tke_year_hz   NUMBER(16,4),
  ysgk_tke           NUMBER(16,4),
  ysgk_tke_hz        NUMBER(16,4),
  zt_tke             NUMBER(16,4),
  zt_tke_hz          NUMBER(16,4)
)
;
comment on column TJBB_DT_B02105.gkbl_tke_his
  is '以前年度出口货物申报累计';
comment on column TJBB_DT_B02105.gkbl_tke_xj
  is '小计';
comment on column TJBB_DT_B02105.gkbl_tke_year
  is '当年出口货物申报累计';
comment on column TJBB_DT_B02105.remark
  is '备注';
comment on column TJBB_DT_B02105.sbhs
  is '申报户数';
comment on column TJBB_DT_B02105.sblj_tmse_his
  is '以前年度出口货物申报累计';
comment on column TJBB_DT_B02105.sblj_tmse_year
  is '当年出口货物申报累计';
comment on column TJBB_DT_B02105.sblj_tscke_his
  is '以前年度出口货物申报累计';
comment on column TJBB_DT_B02105.sblj_tscke_year
  is '当年出口货物申报累计';
comment on column TJBB_DT_B02105.sb_tmse_xj
  is '小计';
comment on column TJBB_DT_B02105.sb_tscke_xj
  is '小计';
comment on column TJBB_DT_B02105.shby_tmse_his
  is '以前年度出口货物申报累计';
comment on column TJBB_DT_B02105.shby_tmse_xj
  is '小计';
comment on column TJBB_DT_B02105.shby_tmse_year
  is '当年出口货物申报累计';
comment on column TJBB_DT_B02105.shlj_tmse_his
  is '以前年度出口货物申报累计';
comment on column TJBB_DT_B02105.shlj_tmse_year
  is '当年出口货物申报累计';
comment on column TJBB_DT_B02105.shzt_tmse_his
  is '以前年度出口货物申报累计';
comment on column TJBB_DT_B02105.shzt_tmse_xj
  is '小计';
comment on column TJBB_DT_B02105.shzt_tmse_year
  is '当年出口货物申报累计';
comment on column TJBB_DT_B02105.sh_tmse_xj
  is '小计';
comment on column TJBB_DT_B02105.sptk_tke_his
  is '以前年度出口货物申报累计';
comment on column TJBB_DT_B02105.sptk_tke_xj
  is '小计';
comment on column TJBB_DT_B02105.sptk_tke_year
  is '当年出口货物申报累计';
comment on column TJBB_DT_B02105.ysgk_tke
  is '已送交国库退（调）库额';
comment on column TJBB_DT_B02105.zt_tke
  is '退（调）库在途数';
alter table TJBB_DT_B02105
  add constraint PK_TJBB_DT_B02105 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B02106
prompt =============================
prompt
create table TJBB_DT_B02106
(
  ssny         VARCHAR2(6) not null,
  bblc         VARCHAR2(10) not null,
  swjgdm       VARCHAR2(32) not null,
  bahs_dbts    NUMBER(16),
  bahs_dbts_hz NUMBER(16),
  bahs_zfqy    NUMBER(16),
  bahs_zfqy_hz NUMBER(16),
  bybl_tse     NUMBER(16,4),
  bybl_tse_hz  NUMBER(16,4),
  gkbl_tke     NUMBER(16,4),
  gkbl_tke_hz  NUMBER(16,4),
  remark       VARCHAR2(200),
  sbhs_dbts    NUMBER(16),
  sbhs_dbts_hz NUMBER(16),
  sbhs_zfqy    NUMBER(16),
  sbhs_zfqy_hz NUMBER(16),
  shtg_tse     NUMBER(16,4),
  shtg_tse_hz  NUMBER(16,4),
  shzt_tse     NUMBER(16,4),
  shzt_tse_hz  NUMBER(16,4),
  spyt_tke     NUMBER(16,4),
  spyt_tke_hz  NUMBER(16,4),
  tscke        NUMBER(16,4),
  tscke_hz     NUMBER(16,4),
  tse          NUMBER(16,4),
  tse_hz       NUMBER(16,4),
  wsgk_tke     NUMBER(16,4),
  wsgk_tke_hz  NUMBER(16,4),
  ysgk_tke     NUMBER(16,4),
  ysgk_tke_hz  NUMBER(16,4),
  zhbl_tse     NUMBER(16,4),
  zhbl_tse_hz  NUMBER(16,4),
  zt_tke       NUMBER(16,4),
  zt_tke_hz    NUMBER(16,4)
)
;
comment on column TJBB_DT_B02106.bahs_dbts
  is '备案代办退税生产企业户数';
comment on column TJBB_DT_B02106.bahs_zfqy
  is '备案综服企业户数';
comment on column TJBB_DT_B02106.bybl_tse
  is '不予办理退税额';
comment on column TJBB_DT_B02106.gkbl_tke
  is '国库已办理退（调）库额';
comment on column TJBB_DT_B02106.remark
  is '备注';
comment on column TJBB_DT_B02106.sbhs_dbts
  is '代办退税生产企业户数';
comment on column TJBB_DT_B02106.sbhs_zfqy
  is '综服企业申报户数';
comment on column TJBB_DT_B02106.shtg_tse
  is '审核通过应退税额';
comment on column TJBB_DT_B02106.shzt_tse
  is '审核在途数';
comment on column TJBB_DT_B02106.spyt_tke
  is '审批应退（调）库额';
comment on column TJBB_DT_B02106.tscke
  is '退税出口额 (万美元)';
comment on column TJBB_DT_B02106.tse
  is '退税额';
comment on column TJBB_DT_B02106.wsgk_tke
  is '未送交国库退（调）库额';
comment on column TJBB_DT_B02106.ysgk_tke
  is '已送交国库退（调）库额';
comment on column TJBB_DT_B02106.zhbl_tse
  is '暂缓办理退税额';
comment on column TJBB_DT_B02106.zt_tke
  is '退（调库）库在途数';
alter table TJBB_DT_B02106
  add constraint PK_TJBB_DT_B02106 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B02107
prompt =============================
prompt
create table TJBB_DT_B02107
(
  ssny       VARCHAR2(6) not null,
  bblc       VARCHAR2(10) not null,
  swjgdm     VARCHAR2(32) not null,
  djrq       DATE,
  jsjdjdm    VARCHAR2(20),
  jydz       VARCHAR2(200),
  jyzlx      VARCHAR2(20),
  nsrmc      VARCHAR2(100),
  nsrsbh     VARCHAR2(20),
  nsrzt      VARCHAR2(10),
  qyfddbr    VARCHAR2(100),
  qyfr_zjlx  VARCHAR2(20),
  qyhgdm     VARCHAR2(18),
  rdrq_ckts  DATE,
  rdrq_ybnsr DATE,
  xh         VARCHAR2(16),
  zcdz       VARCHAR2(200),
  zclx       VARCHAR2(50),
  zjhm       VARCHAR2(18)
)
;
comment on column TJBB_DT_B02107.djrq
  is '税务登记时间';
comment on column TJBB_DT_B02107.jsjdjdm
  is '技术监督局代码';
comment on column TJBB_DT_B02107.jydz
  is '企业经营地址';
comment on column TJBB_DT_B02107.jyzlx
  is '经营者类型';
comment on column TJBB_DT_B02107.nsrmc
  is '纳税人名称';
comment on column TJBB_DT_B02107.nsrsbh
  is '外贸综合服务企业纳税人识别号';
comment on column TJBB_DT_B02107.nsrzt
  is '纳税人状态';
comment on column TJBB_DT_B02107.qyfddbr
  is '企业法定代表人';
comment on column TJBB_DT_B02107.qyfr_zjlx
  is '企业法人证件类型';
comment on column TJBB_DT_B02107.qyhgdm
  is '企业海关代码';
comment on column TJBB_DT_B02107.rdrq_ckts
  is '出口退税认定时间';
comment on column TJBB_DT_B02107.rdrq_ybnsr
  is '一般纳税人认定时间';
comment on column TJBB_DT_B02107.xh
  is '序号';
comment on column TJBB_DT_B02107.zcdz
  is '企业注册地址';
comment on column TJBB_DT_B02107.zclx
  is '注册类型';
comment on column TJBB_DT_B02107.zjhm
  is '企业法人证件号码';
alter table TJBB_DT_B02107
  add constraint PK_TJBB_DT_B02107 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B02108
prompt =============================
prompt
create table TJBB_DT_B02108
(
  ssny               VARCHAR2(6) not null,
  bblc               VARCHAR2(10) not null,
  swjgdm             VARCHAR2(32) not null,
  xh                 VARCHAR2(16),
  nsrmc              VARCHAR2(100),
  nsrsbh             VARCHAR2(18),
  sb_cke_mon         NUMBER(16,4),
  sb_cke_mon_hz      NUMBER(16,4),
  sb_cke_year        NUMBER(16,4),
  sb_cke_year_hz     NUMBER(16,4),
  sb_cke13_mon       NUMBER(16,4),
  sb_cke13_mon_hz    NUMBER(16,4),
  sb_cke13_year      NUMBER(16,4),
  sb_cke13_year_hz   NUMBER(16,4),
  sb_tse_mon         NUMBER(16,4),
  sb_tse_mon_hz      NUMBER(16,4),
  sb_tse_year        NUMBER(16,4),
  sb_tse_year_hz     NUMBER(16,4),
  sb_tse13_mon       NUMBER(16,4),
  sb_tse13_mon_hz    NUMBER(16,4),
  sb_tse13_year      NUMBER(16,4),
  sb_tse13_year_hz   NUMBER(16,4),
  sh_tse_mon         NUMBER(16,4),
  sh_tse_mon_hz      NUMBER(16,4),
  sh_tse_year        NUMBER(16,4),
  sh_tse_year_hz     NUMBER(16,4),
  sh_tse13_mon       NUMBER(16,4),
  sh_tse13_mon_hz    NUMBER(16,4),
  sh_tse13_year      NUMBER(16,4),
  sh_tse13_year_hz   NUMBER(16,4),
  shzt_tse_xj        NUMBER(16,4),
  shzt_tse_xj_hz     NUMBER(16,4),
  shzt_tse13_xj      NUMBER(16,4),
  shzt_tse13_xj_hz   NUMBER(16,4),
  bybl_tse_mon       NUMBER(16,4),
  bybl_tse_mon_hz    NUMBER(16,4),
  bybl_tse_year      NUMBER(16,4),
  bybl_tse_year_hz   NUMBER(16,4),
  bybl_tse13_mon     NUMBER(16,4),
  bybl_tse13_mon_hz  NUMBER(16,4),
  bybl_tse13_year    NUMBER(16,4),
  bybl_tse13_year_hz NUMBER(16,4),
  sp_tse_mon         NUMBER(16,4),
  sp_tse_mon_hz      NUMBER(16,4),
  sp_tse_year        NUMBER(16,4),
  sp_tse_year_hz     NUMBER(16,4),
  ys_tke_year        NUMBER(16,4),
  ys_tke_year_hz     NUMBER(16,4),
  ws_tke_year        NUMBER(16,4),
  ws_tke_year_hz     NUMBER(16,4),
  bl_tke_year        NUMBER(16,4),
  bl_tke_year_hz     NUMBER(16,4),
  remark             VARCHAR2(200),
  zt_tke_year        NUMBER(16,4),
  zt_tke_year_hz     NUMBER(16,4)
)
;
comment on column TJBB_DT_B02108.xh
  is '序号';
comment on column TJBB_DT_B02108.nsrmc
  is '名称';
comment on column TJBB_DT_B02108.nsrsbh
  is '纳税人识别号';
comment on column TJBB_DT_B02108.sb_cke_mon
  is '当月';
comment on column TJBB_DT_B02108.sb_cke_year
  is '本年累计';
comment on column TJBB_DT_B02108.sb_cke13_mon
  is '当月';
comment on column TJBB_DT_B02108.sb_cke13_year
  is '本年累计';
comment on column TJBB_DT_B02108.sb_tse_mon
  is '当月';
comment on column TJBB_DT_B02108.sb_tse_year
  is '本年累计';
comment on column TJBB_DT_B02108.sb_tse13_mon
  is '当月';
comment on column TJBB_DT_B02108.sb_tse13_year
  is '本年累计';
comment on column TJBB_DT_B02108.sh_tse_mon
  is '当月';
comment on column TJBB_DT_B02108.sh_tse_year
  is '本年累计';
comment on column TJBB_DT_B02108.sh_tse13_mon
  is '当月';
comment on column TJBB_DT_B02108.sh_tse13_year
  is '本年累计';
comment on column TJBB_DT_B02108.shzt_tse_xj
  is '小计';
comment on column TJBB_DT_B02108.shzt_tse13_xj
  is '符合13号公告规定业务';
comment on column TJBB_DT_B02108.bybl_tse_mon
  is '当月';
comment on column TJBB_DT_B02108.bybl_tse_year
  is '本年累计';
comment on column TJBB_DT_B02108.bybl_tse13_mon
  is '当月';
comment on column TJBB_DT_B02108.bybl_tse13_year
  is '本年累计';
comment on column TJBB_DT_B02108.sp_tse_mon
  is '当月';
comment on column TJBB_DT_B02108.sp_tse_year
  is '本年累计';
comment on column TJBB_DT_B02108.ys_tke_year
  is '已送交国库退库额';
comment on column TJBB_DT_B02108.ws_tke_year
  is '未送交国库退库额';
comment on column TJBB_DT_B02108.bl_tke_year
  is '国库已办理退库额';
comment on column TJBB_DT_B02108.remark
  is '备注';
comment on column TJBB_DT_B02108.zt_tke_year
  is '退库在途数';
alter table TJBB_DT_B02108
  add constraint PK_TJBB_DT_B02108 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B02109
prompt =============================
prompt
create table TJBB_DT_B02109
(
  ssny          VARCHAR2(6) not null,
  bblc          VARCHAR2(10) not null,
  swjgdm        VARCHAR2(32) not null,
  xh            VARCHAR2(16),
  nsrsbh        VARCHAR2(20),
  qymc          VARCHAR2(80),
  jsje_mon      NUMBER(16,4),
  jsje_mon_hz   NUMBER(16,4),
  jsje_year     NUMBER(16,4),
  jsje_year_hz  NUMBER(16,4),
  sbtse_mon     NUMBER(16,4),
  sbtse_mon_hz  NUMBER(16,4),
  sbtse_year    NUMBER(16,4),
  sbtse_year_hz NUMBER(16,4),
  sphgdms       VARCHAR2(40),
  qyhgdm        VARCHAR2(20)
)
;
comment on column TJBB_DT_B02109.xh
  is '序号';
comment on column TJBB_DT_B02109.nsrsbh
  is '供货企业纳税人识别号';
comment on column TJBB_DT_B02109.qymc
  is '供货企业名称';
comment on column TJBB_DT_B02109.jsje_mon
  is '当月';
comment on column TJBB_DT_B02109.jsje_year
  is '本年累计';
comment on column TJBB_DT_B02109.sbtse_mon
  is '当月';
comment on column TJBB_DT_B02109.sbtse_year
  is '本年累计';
comment on column TJBB_DT_B02109.sphgdms
  is '主要商品海关代码';
comment on column TJBB_DT_B02109.qyhgdm
  is '外贸综合服务企业海关代码';
alter table TJBB_DT_B02109
  add constraint PK_TJBB_DT_B02109 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B02110
prompt =============================
prompt
create table TJBB_DT_B02110
(
  ssny     VARCHAR2(6) not null,
  bblc     VARCHAR2(10) not null,
  swjgdm   VARCHAR2(32) not null,
  bys      NUMBER(16,4),
  bys_hz   NUMBER(16,4),
  ljs      NUMBER(16,4),
  ljs_hz   NUMBER(16,4),
  syljs    NUMBER(16,4),
  syljs_hz NUMBER(16,4),
  remark   VARCHAR2(1000)
)
;
comment on column TJBB_DT_B02110.bys
  is '本月数';
comment on column TJBB_DT_B02110.ljs
  is '累计数';
comment on column TJBB_DT_B02110.syljs
  is '上月累计数';
comment on column TJBB_DT_B02110.remark
  is '备注';
alter table TJBB_DT_B02110
  add constraint PK_TJBB_DT_B02110 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B02111
prompt =============================
prompt
create table TJBB_DT_B02111
(
  ssny           VARCHAR2(6) not null,
  bblc           VARCHAR2(10) not null,
  swjgdm         VARCHAR2(32) not null,
  bgck_hs        NUMBER(16),
  bgck_hs_hz     NUMBER(16),
  bgck_je        NUMBER(16,4),
  bgck_je_hz     NUMBER(16,4),
  cktms_hs       NUMBER(16),
  cktms_hs_hz    NUMBER(16),
  cktms_je       NUMBER(16,4),
  cktms_je_hz    NUMBER(16,4),
  qjny           VARCHAR2(16),
  wpms_cke_hs    NUMBER(16),
  wpms_cke_hs_hz NUMBER(16),
  wpms_cke_je    NUMBER(16,4),
  wpms_cke_je_hz NUMBER(16,4),
  xfsms_cke      NUMBER(16,4),
  xfsms_cke_hz   NUMBER(16,4),
  zzsms_cke      NUMBER(16,4),
  zzsms_cke_hz   NUMBER(16,4)
)
;
comment on column TJBB_DT_B02111.bgck_hs
  is '户数';
comment on column TJBB_DT_B02111.bgck_je
  is '金额';
comment on column TJBB_DT_B02111.cktms_hs
  is '户数';
comment on column TJBB_DT_B02111.cktms_je
  is '金额';
comment on column TJBB_DT_B02111.qjny
  is '期间（年/月）';
comment on column TJBB_DT_B02111.wpms_cke_hs
  is '户数';
comment on column TJBB_DT_B02111.wpms_cke_je
  is '金额';
comment on column TJBB_DT_B02111.xfsms_cke
  is '消费税免税出口额';
comment on column TJBB_DT_B02111.zzsms_cke
  is '增值税免税出口额';
alter table TJBB_DT_B02111
  add constraint PK_TJBB_DT_B02111 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B02112
prompt =============================
prompt
create table TJBB_DT_B02112
(
  ssny       VARCHAR2(6) not null,
  bblc       VARCHAR2(10) not null,
  swjgdm     VARCHAR2(32) not null,
  bahs       NUMBER(16),
  bahs_hz    NUMBER(16),
  bl_mdse    NUMBER(16,4),
  bl_mdse_hz NUMBER(16,4),
  bl_tmse    NUMBER(16,4),
  bl_tmse_hz NUMBER(16,4),
  bl_tse     NUMBER(16,4),
  bl_tse_hz  NUMBER(16,4),
  sbhs       NUMBER(16,4),
  sbhs_hz    NUMBER(16,4),
  sbtscke    NUMBER(16,4),
  sbtscke_hz NUMBER(16,4),
  sb_mdse    NUMBER(16,4),
  sb_mdse_hz NUMBER(16,4),
  sb_tmse    NUMBER(16,4),
  sb_tmse_hz NUMBER(16,4),
  sb_tse     NUMBER(16,4),
  sb_tse_hz  NUMBER(16,4),
  sh_mdse    NUMBER(16,4),
  sh_mdse_hz NUMBER(16,4),
  sh_tmse    NUMBER(16,4),
  sh_tmse_hz NUMBER(16,4),
  sh_tse     NUMBER(16,4),
  sh_tse_hz  NUMBER(16,4),
  zysp       VARCHAR2(400)
)
;
comment on column TJBB_DT_B02112.bahs
  is '备案户数';
comment on column TJBB_DT_B02112.bl_mdse
  is '免抵税额';
comment on column TJBB_DT_B02112.bl_tmse
  is '退（免）税额';
comment on column TJBB_DT_B02112.bl_tse
  is '退税额';
comment on column TJBB_DT_B02112.sbhs
  is '申报户数';
comment on column TJBB_DT_B02112.sbtscke
  is '申报退税出口额（万美元）';
comment on column TJBB_DT_B02112.sb_mdse
  is '免抵税额';
comment on column TJBB_DT_B02112.sb_tmse
  is '退（免）税额';
comment on column TJBB_DT_B02112.sb_tse
  is '退税额';
comment on column TJBB_DT_B02112.sh_mdse
  is '免抵税额';
comment on column TJBB_DT_B02112.sh_tmse
  is '退（免）税额';
comment on column TJBB_DT_B02112.sh_tse
  is '退税额';
comment on column TJBB_DT_B02112.zysp
  is '主要退税商品';
alter table TJBB_DT_B02112
  add constraint PK_TJBB_DT_B02112 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B02113
prompt =============================
prompt
create table TJBB_DT_B02113
(
  ssny       VARCHAR2(6) not null,
  bblc       VARCHAR2(10) not null,
  swjgdm     VARCHAR2(32) not null,
  bahs       NUMBER(16),
  bahs_hz    NUMBER(16),
  bl_mdse    NUMBER(16,4),
  bl_mdse_hz NUMBER(16,4),
  bl_tmse    NUMBER(16,4),
  bl_tmse_hz NUMBER(16,4),
  bl_tse     NUMBER(16,4),
  bl_tse_hz  NUMBER(16,4),
  sbhs       NUMBER(16),
  sbhs_hz    NUMBER(16),
  sbtscke    NUMBER(16,4),
  sbtscke_hz NUMBER(16,4),
  sb_mdse    NUMBER(16,4),
  sb_mdse_hz NUMBER(16,4),
  sb_tmse    NUMBER(16,4),
  sb_tmse_hz NUMBER(16,4),
  sb_tse     NUMBER(16,4),
  sb_tse_hz  NUMBER(16,4),
  sh_mdse    NUMBER(16,4),
  sh_mdse_hz NUMBER(16,4),
  sh_tmse    NUMBER(16,4),
  sh_tmse_hz NUMBER(16,4),
  sh_tse     NUMBER(16,4),
  sh_tse_hz  NUMBER(16,4),
  zysp       VARCHAR2(400)
)
;
comment on column TJBB_DT_B02113.bahs
  is '备案户数';
comment on column TJBB_DT_B02113.bl_mdse
  is '免抵税额';
comment on column TJBB_DT_B02113.bl_tmse
  is '退（免）税额';
comment on column TJBB_DT_B02113.bl_tse
  is '退税额';
comment on column TJBB_DT_B02113.sbhs
  is '申报户数';
comment on column TJBB_DT_B02113.sbtscke
  is '申报退税出口额（万美元）';
comment on column TJBB_DT_B02113.sb_mdse
  is '免抵税额';
comment on column TJBB_DT_B02113.sb_tmse
  is '退（免）税额';
comment on column TJBB_DT_B02113.sb_tse
  is '退税额';
comment on column TJBB_DT_B02113.sh_mdse
  is '免抵税额';
comment on column TJBB_DT_B02113.sh_tmse
  is '退（免）税额';
comment on column TJBB_DT_B02113.sh_tse
  is '退税额';
comment on column TJBB_DT_B02113.zysp
  is '主要退税商品';
alter table TJBB_DT_B02113
  add constraint PK_TJBB_DT_B02113 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B02114
prompt =============================
prompt
create table TJBB_DT_B02114
(
  ssny            VARCHAR2(6) not null,
  bblc            VARCHAR2(10) not null,
  swjgdm          VARCHAR2(32) not null,
  xh              VARCHAR2(16),
  nsrmc           VARCHAR2(100),
  nsrsbh          VARCHAR2(18),
  sb_cke_mon      NUMBER(16,4),
  sb_cke_year     NUMBER(16,4),
  sb_cke35_mon    NUMBER(16,4),
  sb_cke35_year   NUMBER(16,4),
  sb_tse_mon      NUMBER(16,4),
  sb_tse_year     NUMBER(16,4),
  sb_tse35_mon    NUMBER(16,4),
  sb_tse35_year   NUMBER(16,4),
  sh_tse_mon      NUMBER(16,4),
  sh_tse_year     NUMBER(16,4),
  sh_tse35_mon    NUMBER(16,4),
  sh_tse35_year   NUMBER(16,4),
  shzt_tse_xj     NUMBER(16,4),
  shzt_tse35_xj   NUMBER(16,4),
  bybl_tse_mon    NUMBER(16,4),
  bybl_tse_year   NUMBER(16,4),
  bybl_tse35_mon  NUMBER(16,4),
  bybl_tse35_year NUMBER(16,4),
  sp_tse_mon      NUMBER(16,4),
  sp_tse_year     NUMBER(16,4),
  sp_tse35_mon    NUMBER(16,4),
  sp_tse35_year   NUMBER(16,4),
  ys_tke_year     NUMBER(16,4),
  ys_tke35_year   NUMBER(16,4),
  ws_tke_year     NUMBER(16,4),
  ws_tke35_year   NUMBER(16,4),
  bl_tke_year     NUMBER(16,4),
  bl_tke35_year   NUMBER(16,4),
  zt_tke_year     NUMBER(16,4),
  zt_tke35_year   NUMBER(16,4),
  remark          VARCHAR2(200)
)
;
comment on column TJBB_DT_B02114.xh
  is '序号';
comment on column TJBB_DT_B02114.nsrmc
  is '名称';
comment on column TJBB_DT_B02114.nsrsbh
  is '纳税人识别号';
comment on column TJBB_DT_B02114.sb_cke_mon
  is '当月';
comment on column TJBB_DT_B02114.sb_cke_year
  is '本年累计';
comment on column TJBB_DT_B02114.sb_cke35_mon
  is '当月';
comment on column TJBB_DT_B02114.sb_cke35_year
  is '本年累计';
comment on column TJBB_DT_B02114.sb_tse_mon
  is '当月';
comment on column TJBB_DT_B02114.sb_tse_year
  is '本年累计';
comment on column TJBB_DT_B02114.sb_tse35_mon
  is '当月';
comment on column TJBB_DT_B02114.sb_tse35_year
  is '本年累计';
comment on column TJBB_DT_B02114.sh_tse_mon
  is '当月';
comment on column TJBB_DT_B02114.sh_tse_year
  is '本年累计';
comment on column TJBB_DT_B02114.sh_tse35_mon
  is '当月';
comment on column TJBB_DT_B02114.sh_tse35_year
  is '本年累计';
comment on column TJBB_DT_B02114.shzt_tse_xj
  is '小计';
comment on column TJBB_DT_B02114.shzt_tse35_xj
  is '符合35号公告规定业务';
comment on column TJBB_DT_B02114.bybl_tse_mon
  is '当月';
comment on column TJBB_DT_B02114.bybl_tse_year
  is '本年累计';
comment on column TJBB_DT_B02114.bybl_tse35_mon
  is '当月';
comment on column TJBB_DT_B02114.bybl_tse35_year
  is '本年累计';
comment on column TJBB_DT_B02114.sp_tse_mon
  is '当月';
comment on column TJBB_DT_B02114.sp_tse_year
  is '本年累计';
comment on column TJBB_DT_B02114.sp_tse35_mon
  is '当月';
comment on column TJBB_DT_B02114.sp_tse35_year
  is '本年累计';
comment on column TJBB_DT_B02114.ys_tke_year
  is '已送交国库退库额';
comment on column TJBB_DT_B02114.ys_tke35_year
  is '已送交国库退库额';
comment on column TJBB_DT_B02114.ws_tke_year
  is '未送交国库退库额';
comment on column TJBB_DT_B02114.ws_tke35_year
  is '未送交国库退库额';
comment on column TJBB_DT_B02114.bl_tke_year
  is '国库已办理退库额';
comment on column TJBB_DT_B02114.bl_tke35_year
  is '国库已办理退库额';
comment on column TJBB_DT_B02114.zt_tke_year
  is '退库在途数';
comment on column TJBB_DT_B02114.zt_tke35_year
  is '退库在途数';
comment on column TJBB_DT_B02114.remark
  is '备注';
alter table TJBB_DT_B02114
  add constraint PK_TJBB_DT_B02114 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B03101
prompt =============================
prompt
create table TJBB_DT_B03101
(
  ssny   VARCHAR2(6) not null,
  bblc   VARCHAR2(10) not null,
  swjgdm VARCHAR2(32) not null,
  jan    NUMBER(16,4),
  jan_hz NUMBER(16,4),
  feb    NUMBER(16,4),
  feb_hz NUMBER(16,4),
  mar    NUMBER(16,4),
  mar_hz NUMBER(16,4),
  apr    NUMBER(16,4),
  apr_hz NUMBER(16,4),
  may    NUMBER(16,4),
  may_hz NUMBER(16,4),
  jun    NUMBER(16,4),
  jun_hz NUMBER(16,4),
  jul    NUMBER(16,4),
  jul_hz NUMBER(16,4),
  aug    NUMBER(16,4),
  aug_hz NUMBER(16,4),
  sep    NUMBER(16,4),
  sep_hz NUMBER(16,4),
  oct    NUMBER(16,4),
  oct_hz NUMBER(16,4),
  nov    NUMBER(16,4),
  nov_hz NUMBER(16,4),
  dec    NUMBER(16,4),
  dec_hz NUMBER(16,4)
)
;
comment on column TJBB_DT_B03101.jan
  is '1月';
comment on column TJBB_DT_B03101.feb
  is '2月';
comment on column TJBB_DT_B03101.mar
  is '3月';
comment on column TJBB_DT_B03101.apr
  is '4月';
comment on column TJBB_DT_B03101.may
  is '5月';
comment on column TJBB_DT_B03101.jun
  is '6月';
comment on column TJBB_DT_B03101.jul
  is '7月';
comment on column TJBB_DT_B03101.aug
  is '8月';
comment on column TJBB_DT_B03101.sep
  is '9月';
comment on column TJBB_DT_B03101.oct
  is '10月';
comment on column TJBB_DT_B03101.nov
  is '11月';
comment on column TJBB_DT_B03101.dec
  is '12月';
alter table TJBB_DT_B03101
  add constraint PK_TJBB_DT_B03101 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B03102
prompt =============================
prompt
create table TJBB_DT_B03102
(
  ssny   VARCHAR2(6) not null,
  bblc   VARCHAR2(10) not null,
  swjgdm VARCHAR2(32) not null,
  jan    NUMBER(16,4),
  jan_hz NUMBER(16,4),
  feb    NUMBER(16,4),
  feb_hz NUMBER(16,4),
  mar    NUMBER(16,4),
  mar_hz NUMBER(16,4),
  apr    NUMBER(16,4),
  apr_hz NUMBER(16,4),
  may    NUMBER(16,4),
  may_hz NUMBER(16,4),
  jun    NUMBER(16,4),
  jun_hz NUMBER(16,4),
  jul    NUMBER(16,4),
  jul_hz NUMBER(16,4),
  aug    NUMBER(16,4),
  aug_hz NUMBER(16,4),
  sep    NUMBER(16,4),
  sep_hz NUMBER(16,4),
  oct    NUMBER(16,4),
  oct_hz NUMBER(16,4),
  nov    NUMBER(16,4),
  nov_hz NUMBER(16,4),
  dec    NUMBER(16,4),
  dec_hz NUMBER(16,4)
)
;
comment on column TJBB_DT_B03102.jan
  is '1月';
comment on column TJBB_DT_B03102.feb
  is '2月';
comment on column TJBB_DT_B03102.mar
  is '3月';
comment on column TJBB_DT_B03102.apr
  is '4月';
comment on column TJBB_DT_B03102.may
  is '5月';
comment on column TJBB_DT_B03102.jun
  is '6月';
comment on column TJBB_DT_B03102.jul
  is '7月';
comment on column TJBB_DT_B03102.aug
  is '8月';
comment on column TJBB_DT_B03102.sep
  is '9月';
comment on column TJBB_DT_B03102.oct
  is '10月';
comment on column TJBB_DT_B03102.nov
  is '11月';
comment on column TJBB_DT_B03102.dec
  is '12月';
alter table TJBB_DT_B03102
  add constraint PK_TJBB_DT_B03102 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B03103
prompt =============================
prompt
create table TJBB_DT_B03103
(
  ssny              VARCHAR2(6) not null,
  bblc              VARCHAR2(10) not null,
  swjgdm            VARCHAR2(32) not null,
  area              VARCHAR2(40),
  ktkzy             NUMBER(16,4),
  ktkzy_hz          NUMBER(16,4),
  tke_mon           NUMBER(16,4),
  tke_mon_hz        NUMBER(16,4),
  tke_mon_tb        NUMBER(16,4),
  tke_mon_tb_hz     NUMBER(16,4),
  tke_year          NUMBER(16,4),
  tke_year_hz       NUMBER(16,4),
  tke_year_tb       NUMBER(16,4),
  tke_year_tb_hz    NUMBER(16,4),
  tmse_mon          NUMBER(16,4),
  tmse_mon_hz       NUMBER(16,4),
  tmse_mon_tb       NUMBER(16,4),
  tmse_mon_tb_hz    NUMBER(16,4),
  tmse_year         NUMBER(16,4),
  tmse_year_hz      NUMBER(16,4),
  tmse_year_tb      NUMBER(16,4),
  tmse_year_tb_hz   NUMBER(16,4),
  tke_mon_last      NUMBER(16,4),
  tke_mon_last_hz   NUMBER(16,4),
  tke_year_last     NUMBER(16,4),
  tke_year_last_hz  NUMBER(16,4),
  tmse_mon_last     NUMBER(16,4),
  tmse_mon_last_hz  NUMBER(16,4),
  tmse_year_last    NUMBER(16,4),
  tmse_year_last_hz NUMBER(16,4)
)
;
comment on column TJBB_DT_B03103.area
  is '地区';
comment on column TJBB_DT_B03103.ktkzy
  is '剩余可调库资源';
comment on column TJBB_DT_B03103.tke_mon
  is '调库';
comment on column TJBB_DT_B03103.tke_mon_tb
  is '同比';
comment on column TJBB_DT_B03103.tke_year
  is '调库';
comment on column TJBB_DT_B03103.tke_year_tb
  is '同比';
comment on column TJBB_DT_B03103.tmse_mon
  is '退税';
comment on column TJBB_DT_B03103.tmse_mon_tb
  is '同比';
comment on column TJBB_DT_B03103.tmse_year
  is '退税';
comment on column TJBB_DT_B03103.tmse_year_tb
  is '同比';
alter table TJBB_DT_B03103
  add constraint PK_TJBB_DT_B03103 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B03104
prompt =============================
prompt
create table TJBB_DT_B03104
(
  ssny             VARCHAR2(6) not null,
  bblc             VARCHAR2(10) not null,
  swjgdm           VARCHAR2(32) not null,
  cke_tb           NUMBER(16,4),
  cke_tb_hz        NUMBER(16,4),
  cke_year         NUMBER(16,4),
  cke_year_hz      NUMBER(16,4),
  cke_zb           NUMBER(16,4),
  cke_zb_hz        NUMBER(16,4),
  tse_tb           NUMBER(16,4),
  tse_tb_hz        NUMBER(16,4),
  tse_year         NUMBER(16,4),
  tse_year_hz      NUMBER(16,4),
  tse_zb           NUMBER(16,4),
  tse_zb_hz        NUMBER(16,4),
  spmc             VARCHAR2(400),
  cke_year_last    NUMBER(16,4),
  cke_year_last_hz NUMBER(16,4),
  tse_year_last    NUMBER(16,4),
  tse_year_last_hz NUMBER(16,4),
  spdl             VARCHAR2(16),
  spdldm           VARCHAR2(16)
)
;
comment on column TJBB_DT_B03104.cke_tb
  is '同比';
comment on column TJBB_DT_B03104.cke_year
  is '出口额';
comment on column TJBB_DT_B03104.cke_zb
  is '比重';
comment on column TJBB_DT_B03104.tse_tb
  is '同比';
comment on column TJBB_DT_B03104.tse_year
  is '退税额';
comment on column TJBB_DT_B03104.tse_zb
  is '比重';
comment on column TJBB_DT_B03104.cke_year_last
  is '出口额上年';
comment on column TJBB_DT_B03104.tse_year_last
  is '退税额上年';
comment on column TJBB_DT_B03104.spdl
  is '商品大类';
comment on column TJBB_DT_B03104.spdldm
  is '商品大类代码';
alter table TJBB_DT_B03104
  add constraint PK_TJBB_DT_B03104 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B03105
prompt =============================
prompt
create table TJBB_DT_B03105
(
  ssny             VARCHAR2(6) not null,
  bblc             VARCHAR2(10) not null,
  swjgdm           VARCHAR2(32) not null,
  cke_tb           NUMBER(16,4),
  cke_tb_hz        NUMBER(16,4),
  cke_year         NUMBER(16,4),
  cke_year_hz      NUMBER(16,4),
  cke_zb           NUMBER(16,4),
  cke_zb_hz        NUMBER(16,4),
  tse_tb           NUMBER(16,4),
  tse_tb_hz        NUMBER(16,4),
  tse_year         NUMBER(16,4),
  tse_year_hz      NUMBER(16,4),
  tse_zb           NUMBER(16,4),
  tse_zb_hz        NUMBER(16,4),
  cke_year_last    NUMBER(16,4),
  cke_year_last_hz NUMBER(16,4),
  tse_year_last    NUMBER(16,4),
  tse_year_last_hz NUMBER(16,4)
)
;
comment on column TJBB_DT_B03105.cke_tb
  is '同比';
comment on column TJBB_DT_B03105.cke_year
  is '出口额';
comment on column TJBB_DT_B03105.cke_zb
  is '比重';
comment on column TJBB_DT_B03105.tse_tb
  is '同比';
comment on column TJBB_DT_B03105.tse_year
  is '退税额';
comment on column TJBB_DT_B03105.tse_zb
  is '比重';
comment on column TJBB_DT_B03105.cke_year_last
  is '上年同期出口额';
comment on column TJBB_DT_B03105.tse_year_last
  is '上年同期退税额';
alter table TJBB_DT_B03105
  add constraint PK_TJBB_DT_B03105 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B03106
prompt =============================
prompt
create table TJBB_DT_B03106
(
  ssny             VARCHAR2(6) not null,
  bblc             VARCHAR2(10) not null,
  swjgdm           VARCHAR2(32) not null,
  cke_year         NUMBER(16,4),
  cke_year_hz      NUMBER(16,4),
  cke_year_tb      NUMBER(16,4),
  cke_year_tb_hz   NUMBER(16,4),
  cke_year_zb      NUMBER(16,4),
  cke_year_zb_hz   NUMBER(16,4),
  mse_year         NUMBER(16,4),
  mse_year_hz      NUMBER(16,4),
  tmse_year_tb     NUMBER(16,4),
  tmse_year_tb_hz  NUMBER(16,4),
  tmse_year_zb     NUMBER(16,4),
  tmse_year_zb_hz  NUMBER(16,4),
  tse_year         NUMBER(16,4),
  tse_year_hz      NUMBER(16,4),
  cke_year_last    NUMBER(16,4),
  cke_year_last_hz NUMBER(16,4),
  mse_year_last    NUMBER(16,4),
  mse_year_last_hz NUMBER(16,4),
  tse_year_last    NUMBER(16,4),
  tse_year_last_hz NUMBER(16,4),
  myfs_dm          VARCHAR2(4),
  myfs_mc          VARCHAR2(100)
)
;
comment on column TJBB_DT_B03106.cke_year
  is '出口额';
comment on column TJBB_DT_B03106.cke_year_tb
  is '同比';
comment on column TJBB_DT_B03106.cke_year_zb
  is '比重';
comment on column TJBB_DT_B03106.mse_year
  is '免税额';
comment on column TJBB_DT_B03106.tmse_year_tb
  is '同比';
comment on column TJBB_DT_B03106.tmse_year_zb
  is '比重';
comment on column TJBB_DT_B03106.tse_year
  is '退税额';
comment on column TJBB_DT_B03106.cke_year_last
  is '出口额上年同期';
comment on column TJBB_DT_B03106.mse_year_last
  is '免税额上年同期';
comment on column TJBB_DT_B03106.tse_year_last
  is '退税额上年同期';
alter table TJBB_DT_B03106
  add constraint PK_TJBB_DT_B03106 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B03107
prompt =============================
prompt
create table TJBB_DT_B03107
(
  ssny             VARCHAR2(6) not null,
  bblc             VARCHAR2(10) not null,
  swjgdm           VARCHAR2(32) not null,
  area             VARCHAR2(50),
  sbhs_1           NUMBER(16),
  sbhs_1_hz        NUMBER(16),
  sbhs_2           NUMBER(16),
  sbhs_2_hz        NUMBER(16),
  sbhs_3           NUMBER(16),
  sbhs_3_hz        NUMBER(16),
  sbhs_4           NUMBER(16),
  sbhs_4_hz        NUMBER(16),
  tse_1_lj         NUMBER(16,4),
  tse_1_lj_hz      NUMBER(16,4),
  tse_1_tb         NUMBER(16,4),
  tse_1_tb_hz      NUMBER(16,4),
  tse_1_zb         NUMBER(16,4),
  tse_1_zb_hz      NUMBER(16,4),
  tse_2_lj         NUMBER(16,4),
  tse_2_lj_hz      NUMBER(16,4),
  tse_2_tb         NUMBER(16,4),
  tse_2_tb_hz      NUMBER(16,4),
  tse_2_zb         NUMBER(16,4),
  tse_2_zb_hz      NUMBER(16,4),
  tse_3_lj         NUMBER(16,4),
  tse_3_lj_hz      NUMBER(16,4),
  tse_3_tb         NUMBER(16,4),
  tse_3_tb_hz      NUMBER(16,4),
  tse_3_zb         NUMBER(16,4),
  tse_3_zb_hz      NUMBER(16,4),
  tse_4_lj         NUMBER(16,4),
  tse_4_lj_hz      NUMBER(16,4),
  tse_4_tb         NUMBER(16,4),
  tse_4_tb_hz      NUMBER(16,4),
  tse_4_zb         NUMBER(16,4),
  tse_4_zb_hz      NUMBER(16,4),
  tse_1_lj_last    NUMBER(16,4),
  tse_1_lj_last_hz NUMBER(16,4),
  tse_2_lj_last    NUMBER(16,4),
  tse_2_lj_last_hz NUMBER(16,4),
  tse_3_lj_last    NUMBER(16,4),
  tse_3_lj_last_hz NUMBER(16,4),
  tse_4_lj_last    NUMBER(16,4),
  tse_4_lj_last_hz NUMBER(16,4)
)
;
comment on column TJBB_DT_B03107.area
  is '地区';
comment on column TJBB_DT_B03107.sbhs_1
  is '申报户数';
comment on column TJBB_DT_B03107.sbhs_2
  is '申报户数';
comment on column TJBB_DT_B03107.sbhs_3
  is '申报户数';
comment on column TJBB_DT_B03107.sbhs_4
  is '申报户数';
comment on column TJBB_DT_B03107.tse_1_lj
  is '累计办理退税';
comment on column TJBB_DT_B03107.tse_1_tb
  is '同比';
comment on column TJBB_DT_B03107.tse_1_zb
  is '退税占比比重';
comment on column TJBB_DT_B03107.tse_2_lj
  is '累计办理退税';
comment on column TJBB_DT_B03107.tse_2_tb
  is '同比';
comment on column TJBB_DT_B03107.tse_2_zb
  is '退税占比比重';
comment on column TJBB_DT_B03107.tse_3_lj
  is '累计办理退税';
comment on column TJBB_DT_B03107.tse_3_tb
  is '同比';
comment on column TJBB_DT_B03107.tse_3_zb
  is '退税占比比重';
comment on column TJBB_DT_B03107.tse_4_lj
  is '累计办理退税';
comment on column TJBB_DT_B03107.tse_4_tb
  is '同比';
comment on column TJBB_DT_B03107.tse_4_zb
  is '退税占比比重';
alter table TJBB_DT_B03107
  add constraint PK_TJBB_DT_B03107 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B03108
prompt =============================
prompt
create table TJBB_DT_B03108
(
  ssny         VARCHAR2(6) not null,
  bblc         VARCHAR2(10) not null,
  swjgdm       VARCHAR2(32) not null,
  cke          NUMBER(16,4),
  cke_hz       NUMBER(16,4),
  cke_tb       NUMBER(16,4),
  cke_tb_hz    NUMBER(16,4),
  cke_zb       NUMBER(16,4),
  cke_zb_hz    NUMBER(16,4),
  tmse         NUMBER(16,4),
  tmse_hz      NUMBER(16,4),
  tmse_tb      NUMBER(16,4),
  tmse_tb_hz   NUMBER(16,4),
  tmse_zb      NUMBER(16,4),
  tmse_zb_hz   NUMBER(16,4),
  cke_last     NUMBER(16,4),
  cke_last_hz  NUMBER(16,4),
  tmse_last    NUMBER(16,4),
  tmse_last_hz NUMBER(16,4)
)
;
comment on column TJBB_DT_B03108.cke
  is '当期累计出口额（万美元）';
comment on column TJBB_DT_B03108.cke_tb
  is '同比（%）';
comment on column TJBB_DT_B03108.cke_zb
  is '占比（%）';
comment on column TJBB_DT_B03108.tmse
  is '退免税额（万元）';
comment on column TJBB_DT_B03108.tmse_tb
  is '同比（%）';
comment on column TJBB_DT_B03108.tmse_zb
  is '占比（%）';
alter table TJBB_DT_B03108
  add constraint PK_TJBB_DT_B03108 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B03109
prompt =============================
prompt
create table TJBB_DT_B03109
(
  ssny           VARCHAR2(6) not null,
  bblc           VARCHAR2(10) not null,
  swjgdm         VARCHAR2(32) not null,
  cke_lj         NUMBER(16,4),
  cke_lj_hz      NUMBER(16,4),
  cke_tb         NUMBER(16,4),
  cke_tb_hz      NUMBER(16,4),
  cke_zb         NUMBER(16,4),
  cke_zb_hz      NUMBER(16,4),
  gbdm           VARCHAR2(20),
  hgmc           VARCHAR2(100),
  cke_lj_last    NUMBER(16,4),
  cke_lj_last_hz NUMBER(16,4)
)
;
comment on column TJBB_DT_B03109.cke_lj
  is '本年累计出口额';
comment on column TJBB_DT_B03109.cke_tb
  is '同比（%）';
comment on column TJBB_DT_B03109.cke_zb
  is '占比（%）';
comment on column TJBB_DT_B03109.gbdm
  is '关别代码';
comment on column TJBB_DT_B03109.hgmc
  is '海关名称';
alter table TJBB_DT_B03109
  add constraint PK_TJBB_DT_B03109 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B03109_MID
prompt =================================
prompt
create table TJBB_DT_B03109_MID
(
  swjgdm VARCHAR2(32) not null,
  ssny   VARCHAR2(6) not null,
  gbdm   VARCHAR2(20) not null,
  cke_lj NUMBER(16,4),
  tse_lj NUMBER(16,4),
  ckpm   NUMBER(10)
)
;
alter table TJBB_DT_B03109_MID
  add constraint PK_TJBB_DT_B03109_MID primary key (SWJGDM, SSNY, GBDM);

prompt
prompt Creating table TJBB_DT_B03110
prompt =============================
prompt
create table TJBB_DT_B03110
(
  ssny            VARCHAR2(6) not null,
  bblc            VARCHAR2(10) not null,
  swjgdm          VARCHAR2(32) not null,
  cke_tb          NUMBER(16,4),
  cke_tb_hz       NUMBER(16,4),
  cke_usd         NUMBER(16,4),
  cke_usd_hz      NUMBER(16,4),
  cke_zb          NUMBER(16,4),
  cke_zb_hz       NUMBER(16,4),
  item            VARCHAR2(40),
  tmse            NUMBER(16,4),
  tmse_hz         NUMBER(16,4),
  tmse_tb         NUMBER(16,4),
  tmse_tb_hz      NUMBER(16,4),
  tmse_zb         NUMBER(16,4),
  tmse_zb_hz      NUMBER(16,4),
  cke_usd_last    NUMBER(16,4),
  cke_usd_last_hz NUMBER(16,4),
  tmse_last       NUMBER(16,4),
  tmse_last_hz    NUMBER(16,4)
)
;
comment on column TJBB_DT_B03110.cke_tb
  is '同比（%）';
comment on column TJBB_DT_B03110.cke_usd
  is '当期累计出口额（万美元）';
comment on column TJBB_DT_B03110.cke_zb
  is '占比（%）';
comment on column TJBB_DT_B03110.item
  is '项目名称';
comment on column TJBB_DT_B03110.tmse
  is '退免税额（万元）';
comment on column TJBB_DT_B03110.tmse_tb
  is '同比（%）';
comment on column TJBB_DT_B03110.tmse_zb
  is '占比（%）';
alter table TJBB_DT_B03110
  add constraint PK_TJBB_DT_B03110 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B03110_MID
prompt =================================
prompt
create table TJBB_DT_B03110_MID
(
  swjgdm VARCHAR2(32) not null,
  ssny   VARCHAR2(6) not null,
  dmtype VARCHAR2(6) not null,
  gbdm   VARCHAR2(20) not null,
  cke_lj NUMBER(16,4),
  tse_lj NUMBER(16,4),
  ckpm   NUMBER(5)
)
;
alter table TJBB_DT_B03110_MID
  add constraint PK_TJBB_DT_B03110_MID primary key (SWJGDM, SSNY, DMTYPE, GBDM);

prompt
prompt Creating table TJBB_DT_B03111
prompt =============================
prompt
create table TJBB_DT_B03111
(
  ssny        VARCHAR2(6) not null,
  bblc        VARCHAR2(10) not null,
  swjgdm      VARCHAR2(32) not null,
  fp_sl       NUMBER(16),
  fp_sl_hz    NUMBER(16),
  hshfh_sl    NUMBER(16),
  hshfh_sl_hz NUMBER(16),
  js_je       NUMBER(16,4),
  js_je_hz    NUMBER(16,4),
  ts_je       NUMBER(16,4),
  ts_je_hz    NUMBER(16,4)
)
;
comment on column TJBB_DT_B03111.fp_sl
  is '涉及发票数量';
comment on column TJBB_DT_B03111.hshfh_sl
  is '核实函（复函）数量';
comment on column TJBB_DT_B03111.js_je
  is '涉及计税金额';
comment on column TJBB_DT_B03111.ts_je
  is '涉及退税额';
alter table TJBB_DT_B03111
  add constraint PK_TJBB_DT_B03111 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B03112
prompt =============================
prompt
create table TJBB_DT_B03112
(
  ssny             VARCHAR2(6) not null,
  bblc             VARCHAR2(10) not null,
  swjgdm           VARCHAR2(32) not null,
  cke_tb           NUMBER(16,4),
  cke_tb_hz        NUMBER(16,4),
  cke_year         NUMBER(16,4),
  cke_year_hz      NUMBER(16,4),
  cke_zb           NUMBER(16,4),
  cke_zb_hz        NUMBER(16,4),
  tse_tb           NUMBER(16,4),
  tse_tb_hz        NUMBER(16,4),
  tse_year         NUMBER(16,4),
  tse_year_hz      NUMBER(16,4),
  tse_zb           NUMBER(16,4),
  tse_zb_hz        NUMBER(16,4),
  spmc             VARCHAR2(400),
  cke_year_last    NUMBER(16,4),
  cke_year_last_hz NUMBER(16,4),
  tse_year_last    NUMBER(16,4),
  tse_year_last_hz NUMBER(16,4),
  spdl             VARCHAR2(16),
  spdldm           VARCHAR2(16)
)
;
comment on column TJBB_DT_B03112.cke_tb
  is '同比';
comment on column TJBB_DT_B03112.cke_year
  is '出口额';
comment on column TJBB_DT_B03112.cke_zb
  is '比重';
comment on column TJBB_DT_B03112.tse_tb
  is '同比';
comment on column TJBB_DT_B03112.tse_year
  is '退税额';
comment on column TJBB_DT_B03112.tse_zb
  is '比重';
comment on column TJBB_DT_B03112.cke_year_last
  is '出口额上年';
comment on column TJBB_DT_B03112.tse_year_last
  is '退税额上年';
comment on column TJBB_DT_B03112.spdl
  is '商品大类';
comment on column TJBB_DT_B03112.spdldm
  is '商品大类代码';
alter table TJBB_DT_B03112
  add constraint PK_TJBB_DT_B03112 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B03113
prompt =============================
prompt
create table TJBB_DT_B03113
(
  ssny                  VARCHAR2(6) not null,
  bblc                  VARCHAR2(10) not null,
  swjgdm                VARCHAR2(32) not null,
  cke_tb                NUMBER(16,4),
  cke_tb_hz             NUMBER(16,4),
  cke_year              NUMBER(16,4),
  cke_year_hz           NUMBER(16,4),
  cke_year_zb           NUMBER(16,4),
  cke_year_zb_hz        NUMBER(16,4),
  cke_year_zb_last      NUMBER(16,4),
  cke_year_zb_last_hz   NUMBER(16,4),
  pm                    VARCHAR2(10),
  qyhgdm                VARCHAR2(18),
  tmse_tb               NUMBER(16,4),
  tmse_tb_hz            NUMBER(16,4),
  tmse_year             NUMBER(16,4),
  tmse_year_hz          NUMBER(16,4),
  tmse_year_zb          NUMBER(16,4),
  tmse_year_zb_hz       NUMBER(16,4),
  tmse_year_zb_last     NUMBER(16,4),
  tmse_year_zb_last_hz  NUMBER(16,4),
  usa_cke_tb            NUMBER(16,4),
  usa_cke_tb_hz         NUMBER(16,4),
  usa_cke_year          NUMBER(16,4),
  usa_cke_year_hz       NUMBER(16,4),
  usa_tmse_tb           NUMBER(16,4),
  usa_tmse_tb_hz        NUMBER(16,4),
  usa_tmse_year         NUMBER(16,4),
  usa_tmse_year_hz      NUMBER(16,4),
  cke_year_last         NUMBER(16,4),
  cke_year_last_hz      NUMBER(16,4),
  tmse_year_last        NUMBER(16,4),
  tmse_year_last_hz     NUMBER(16,4),
  usa_cke_year_last     NUMBER(16,4),
  usa_cke_year_last_hz  NUMBER(16,4),
  usa_tmse_year_last    NUMBER(16,4),
  usa_tmse_year_last_hz NUMBER(16,4),
  qymc                  VARCHAR2(160),
  cpcode                VARCHAR2(32),
  jsmode                VARCHAR2(1),
  jsmodemc              VARCHAR2(10)
)
;
comment on column TJBB_DT_B03113.cke_tb
  is '同比（%）';
comment on column TJBB_DT_B03113.cke_year
  is '本年';
comment on column TJBB_DT_B03113.cke_year_zb
  is '本年';
comment on column TJBB_DT_B03113.cke_year_zb_last
  is '上年同期';
comment on column TJBB_DT_B03113.pm
  is '排名';
comment on column TJBB_DT_B03113.qyhgdm
  is '企业海关代码';
comment on column TJBB_DT_B03113.tmse_tb
  is '同比';
comment on column TJBB_DT_B03113.tmse_year
  is '本年';
comment on column TJBB_DT_B03113.tmse_year_zb
  is '本年';
comment on column TJBB_DT_B03113.tmse_year_zb_last
  is '上年同期';
comment on column TJBB_DT_B03113.usa_cke_tb
  is '同比（%）';
comment on column TJBB_DT_B03113.usa_cke_year
  is '本年';
comment on column TJBB_DT_B03113.usa_tmse_tb
  is '同比';
comment on column TJBB_DT_B03113.usa_tmse_year
  is '本年';
comment on column TJBB_DT_B03113.jsmodemc
  is '企业类型名称';
alter table TJBB_DT_B03113
  add constraint PK_TJBB_DT_B03113 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B03114
prompt =============================
prompt
create table TJBB_DT_B03114
(
  ssny            VARCHAR2(6) not null,
  bblc            VARCHAR2(10) not null,
  swjgdm          VARCHAR2(32) not null,
  cke_tb          NUMBER(16),
  cke_tb_hz       NUMBER(16),
  cke_usd         NUMBER(16),
  cke_usd_hz      NUMBER(16),
  cke_zb          NUMBER(16),
  cke_zb_hz       NUMBER(16),
  item            VARCHAR2(40),
  tmse            NUMBER(16),
  tmse_hz         NUMBER(16),
  tmse_tb         NUMBER(16),
  tmse_tb_hz      NUMBER(16),
  tmse_zb         NUMBER(16),
  tmse_zb_hz      NUMBER(16),
  cke_usd_last    NUMBER(16,4),
  cke_usd_last_hz NUMBER(16,4),
  tmse_last       NUMBER(16,4),
  tmse_last_hz    NUMBER(16,4)
)
;
comment on column TJBB_DT_B03114.cke_tb
  is '同比（%）';
comment on column TJBB_DT_B03114.cke_usd
  is '累计出口额（万美元）';
comment on column TJBB_DT_B03114.cke_zb
  is '占比（%）';
comment on column TJBB_DT_B03114.item
  is '项目名称';
comment on column TJBB_DT_B03114.tmse
  is '累计退免税额（万元）';
comment on column TJBB_DT_B03114.tmse_tb
  is '同比（%）';
comment on column TJBB_DT_B03114.tmse_zb
  is '占比（%）';
alter table TJBB_DT_B03114
  add constraint PK_TJBB_DT_B03114 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B03114_MID
prompt =================================
prompt
create table TJBB_DT_B03114_MID
(
  swjgdm VARCHAR2(32) not null,
  ssny   VARCHAR2(6) not null,
  dmtype VARCHAR2(6) not null,
  gbdm   VARCHAR2(20) not null,
  cke_lj NUMBER(16,4),
  tse_lj NUMBER(16,4),
  ckpm   NUMBER(5)
)
;
alter table TJBB_DT_B03114_MID
  add constraint PK_TJBB_DT_B03114_MID primary key (SWJGDM, SSNY, DMTYPE, GBDM);

prompt
prompt Creating table TJBB_DT_B03115
prompt =============================
prompt
create table TJBB_DT_B03115
(
  ssny         VARCHAR2(6) not null,
  bblc         VARCHAR2(10) not null,
  swjgdm       VARCHAR2(32) not null,
  qymc         VARCHAR2(100),
  shxyno       VARCHAR2(18),
  swjg         VARCHAR2(11),
  tmse         NUMBER(16,4),
  tmse_hz      NUMBER(16,4),
  tmse_tb      NUMBER(16,4),
  tmse_tb_hz   NUMBER(16,4),
  xh           VARCHAR2(16),
  tmse_last    NUMBER(16,4),
  tmse_last_hz NUMBER(16,4),
  jsmode       VARCHAR2(1),
  jsmodemc     VARCHAR2(10),
  mde          NUMBER(16,4),
  mde_hz       NUMBER(16,4),
  mde_last     NUMBER(16,4),
  mde_last_hz  NUMBER(16,4),
  tse          NUMBER(16,4),
  tse_hz       NUMBER(16,4),
  tse_last     NUMBER(16,4),
  tse_last_hz  NUMBER(16,4),
  djxh         NUMBER(20)
)
;
comment on column TJBB_DT_B03115.qymc
  is '企业名称';
comment on column TJBB_DT_B03115.shxyno
  is '社会信用代码';
comment on column TJBB_DT_B03115.swjg
  is '所属税务机关';
comment on column TJBB_DT_B03115.tmse
  is '办理退（免）税';
comment on column TJBB_DT_B03115.tmse_tb
  is '同比';
comment on column TJBB_DT_B03115.xh
  is '序号';
comment on column TJBB_DT_B03115.jsmodemc
  is '企业类型名称';
comment on column TJBB_DT_B03115.mde
  is '免抵额';
comment on column TJBB_DT_B03115.mde_last
  is '免抵额';
comment on column TJBB_DT_B03115.tse
  is '退税额';
comment on column TJBB_DT_B03115.tse_last
  is '退税额';
comment on column TJBB_DT_B03115.djxh
  is '登记序号';
alter table TJBB_DT_B03115
  add constraint PK_TJBB_DT_B03115 primary key (SWJGDM, SSNY, BBLC);

prompt
prompt Creating table TJBB_DT_B03115_MID
prompt =================================
prompt
create table TJBB_DT_B03115_MID
(
  ssny   VARCHAR2(6) not null,
  swjgdm VARCHAR2(32) not null,
  jsmode VARCHAR2(1) not null,
  djxh   NUMBER(20) not null,
  tmse   NUMBER(16,4),
  tse    NUMBER(16,4),
  mde    NUMBER(16,4),
  ckpm_1 NUMBER(6),
  ckpm_2 NUMBER(6),
  ckpm_3 NUMBER(6)
)
;
comment on column TJBB_DT_B03115_MID.ssny
  is '年月';
comment on column TJBB_DT_B03115_MID.swjgdm
  is '税务机关';
comment on column TJBB_DT_B03115_MID.jsmode
  is '计税方式';
comment on column TJBB_DT_B03115_MID.djxh
  is '登记序号';
comment on column TJBB_DT_B03115_MID.tmse
  is '办理退（免）税';
comment on column TJBB_DT_B03115_MID.tse
  is '退税额';
comment on column TJBB_DT_B03115_MID.mde
  is '免抵额';
comment on column TJBB_DT_B03115_MID.ckpm_1
  is '出口排名（区县级）';
comment on column TJBB_DT_B03115_MID.ckpm_2
  is '出口排名（地市级）';
comment on column TJBB_DT_B03115_MID.ckpm_3
  is '出口排名（全省）';
create index IDX_TJBB_DT_B03115_MID_DS on TJBB_DT_B03115_MID (DJXH, SSNY);
alter table TJBB_DT_B03115_MID
  add constraint PK_TJBB_DT_B03115_MID primary key (SSNY, JSMODE, SWJGDM, DJXH);

prompt
prompt Creating table TJBB_DT_B03116
prompt =============================
prompt
create table TJBB_DT_B03116
(
  ssny            VARCHAR2(6) not null,
  bblc            VARCHAR2(10) not null,
  swjgdm          VARCHAR2(32) not null,
  bl_hs           NUMBER(16),
  bl_hs_hz        NUMBER(16),
  bl_jsje         NUMBER(16,4),
  bl_jsje_hz      NUMBER(16,4),
  bl_myxse        NUMBER(16,4),
  bl_myxse_hz     NUMBER(16,4),
  bl_tmse         NUMBER(16,4),
  bl_tmse_hz      NUMBER(16,4),
  bl_yts_hs       NUMBER(16),
  bl_yts_hs_hz    NUMBER(16),
  bl_yts_jsje     NUMBER(16,4),
  bl_yts_jsje_hz  NUMBER(16,4),
  bl_yts_myxse    NUMBER(16,4),
  bl_yts_myxse_hz NUMBER(16,4),
  bl_yts_tmse     NUMBER(16,4),
  bl_yts_tmse_hz  NUMBER(16,4),
  ck_hs           NUMBER(16),
  ck_hs_hz        NUMBER(16),
  ck_mylaj        NUMBER(16,4),
  ck_mylaj_hz     NUMBER(16,4),
  ck_rmblaj       NUMBER(16,4),
  ck_rmblaj_hz    NUMBER(16,4),
  sb_hs           NUMBER(16),
  sb_hs_hz        NUMBER(16),
  sb_jsje         NUMBER(16,4),
  sb_jsje_hz      NUMBER(16,4),
  sb_myxse        NUMBER(16,4),
  sb_myxse_hz     NUMBER(16,4),
  sb_tmse         NUMBER(16,4),
  sb_tmse_hz      NUMBER(16,4),
  sb_yts_hs       NUMBER(16),
  sb_yts_hs_hz    NUMBER(16),
  sb_yts_jsje     NUMBER(16,4),
  sb_yts_jsje_hz  NUMBER(16,4),
  sb_yts_myxse    NUMBER(16,4),
  sb_yts_myxse_hz NUMBER(16,4),
  sb_yts_tmse     NUMBER(16,4),
  sb_yts_tmse_hz  NUMBER(16,4)
)
;
comment on column TJBB_DT_B03116.bl_hs
  is '办理_户数';
comment on column TJBB_DT_B03116.bl_jsje
  is '办理_计税金额';
comment on column TJBB_DT_B03116.bl_myxse
  is '办理_美元销售额';
comment on column TJBB_DT_B03116.bl_tmse
  is '办理_退（免）税额';
comment on column TJBB_DT_B03116.bl_yts_hs
  is '办理_预退税_户数';
comment on column TJBB_DT_B03116.bl_yts_jsje
  is '办理_预退税_计税金额';
comment on column TJBB_DT_B03116.bl_yts_myxse
  is '办理_预退税_美元销售额';
comment on column TJBB_DT_B03116.bl_yts_tmse
  is '办理_预退税_退（免）税额';
comment on column TJBB_DT_B03116.ck_hs
  is '出口_户数';
comment on column TJBB_DT_B03116.ck_mylaj
  is '出口_美元离岸价';
comment on column TJBB_DT_B03116.ck_rmblaj
  is '出口_人民币离岸价';
comment on column TJBB_DT_B03116.sb_hs
  is '申报_户数';
comment on column TJBB_DT_B03116.sb_jsje
  is '申报_计税金额';
comment on column TJBB_DT_B03116.sb_myxse
  is '申报_美元销售额';
comment on column TJBB_DT_B03116.sb_tmse
  is '申报_退（免）税额';
comment on column TJBB_DT_B03116.sb_yts_hs
  is '申报_预退税_户数';
comment on column TJBB_DT_B03116.sb_yts_jsje
  is '申报_预退税_计税金额';
comment on column TJBB_DT_B03116.sb_yts_myxse
  is '申报_预退税_美元销售额';
comment on column TJBB_DT_B03116.sb_yts_tmse
  is '申报_预退税_退（免）税额';
alter table TJBB_DT_B03116
  add constraint PK_TJBB_DT_B03116 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B03117
prompt =============================
prompt
create table TJBB_DT_B03117
(
  ssny               VARCHAR2(6) not null,
  bblc               VARCHAR2(10) not null,
  swjgdm             VARCHAR2(32) not null,
  bl_hs              NUMBER(16),
  bl_hs_hz           NUMBER(16),
  bl_jsje            NUMBER(16,4),
  bl_jsje_hz         NUMBER(16,4),
  bl_myxse           NUMBER(16,4),
  bl_myxse_hz        NUMBER(16,4),
  bl_tmse            NUMBER(16,4),
  bl_tmse_hz         NUMBER(16,4),
  ck_f1039_hs        NUMBER(16),
  ck_f1039_hs_hz     NUMBER(16),
  ck_f1039_mylaj     NUMBER(16,4),
  ck_f1039_mylaj_hz  NUMBER(16,4),
  ck_f1039_rmblaj    NUMBER(16,4),
  ck_f1039_rmblaj_hz NUMBER(16,4),
  ck_hs              NUMBER(16),
  ck_hs_hz           NUMBER(16),
  ck_mylaj           NUMBER(16,4),
  ck_mylaj_hz        NUMBER(16,4),
  ck_rmblaj          NUMBER(16,4),
  ck_rmblaj_hz       NUMBER(16,4),
  sb_hs              NUMBER(16),
  sb_hs_hz           NUMBER(16),
  sb_jsje            NUMBER(16,4),
  sb_jsje_hz         NUMBER(16,4),
  sb_myxse           NUMBER(16,4),
  sb_myxse_hz        NUMBER(16,4),
  sb_tmse            NUMBER(16,4),
  sb_tmse_hz         NUMBER(16,4)
)
;
comment on column TJBB_DT_B03117.bl_hs
  is '办理_户数';
comment on column TJBB_DT_B03117.bl_jsje
  is '办理_计税金额';
comment on column TJBB_DT_B03117.bl_myxse
  is '办理_美元销售额';
comment on column TJBB_DT_B03117.bl_tmse
  is '办理_退（免）税额';
comment on column TJBB_DT_B03117.ck_f1039_hs
  is '出口_剔除市场采购_户数';
comment on column TJBB_DT_B03117.ck_f1039_mylaj
  is '出口_剔除市场采购_美元离岸价';
comment on column TJBB_DT_B03117.ck_f1039_rmblaj
  is '出口_剔除市场采购_人民币离岸价';
comment on column TJBB_DT_B03117.ck_hs
  is '户数';
comment on column TJBB_DT_B03117.ck_mylaj
  is '美元离岸价';
comment on column TJBB_DT_B03117.ck_rmblaj
  is '人民币离岸价';
comment on column TJBB_DT_B03117.sb_hs
  is '申报_户数';
comment on column TJBB_DT_B03117.sb_jsje
  is '申报_计税金额';
comment on column TJBB_DT_B03117.sb_myxse
  is '申报_美元销售额';
comment on column TJBB_DT_B03117.sb_tmse
  is '申报_退（免）税额';
alter table TJBB_DT_B03117
  add constraint PK_TJBB_DT_B03117 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B05101
prompt =============================
prompt
create table TJBB_DT_B05101
(
  ssny           VARCHAR2(6) not null,
  bblc           VARCHAR2(10) not null,
  swjgdm         VARCHAR2(32) not null,
  cke_9610_hs    NUMBER(16),
  cke_9610_hs_hz NUMBER(16),
  cke_9610_je    NUMBER(16,4),
  cke_9610_je_hz NUMBER(16,4),
  cke_9710_hs    NUMBER(16),
  cke_9710_hs_hz NUMBER(16),
  cke_9710_je    NUMBER(16,4),
  cke_9710_je_hz NUMBER(16,4),
  cke_9810_hs    NUMBER(16),
  cke_9810_hs_hz NUMBER(16),
  cke_9810_je    NUMBER(16,4),
  cke_9810_je_hz NUMBER(16,4),
  qjny           VARCHAR2(16),
  tms_9610_hs    NUMBER(16),
  tms_9610_hs_hz NUMBER(16),
  tms_9610_je    NUMBER(16,4),
  tms_9610_je_hz NUMBER(16,4),
  tms_9710_hs    NUMBER(16),
  tms_9710_hs_hz NUMBER(16),
  tms_9710_je    NUMBER(16,4),
  tms_9710_je_hz NUMBER(16,4),
  tms_9810_hs    NUMBER(16),
  tms_9810_hs_hz NUMBER(16),
  tms_9810_je    NUMBER(16,4),
  tms_9810_je_hz NUMBER(16,4)
)
;
comment on column TJBB_DT_B05101.cke_9610_hs
  is '户数';
comment on column TJBB_DT_B05101.cke_9610_je
  is '金额（万元）';
comment on column TJBB_DT_B05101.cke_9710_hs
  is '户数';
comment on column TJBB_DT_B05101.cke_9710_je
  is '金额（万元）';
comment on column TJBB_DT_B05101.cke_9810_hs
  is '户数';
comment on column TJBB_DT_B05101.cke_9810_je
  is '金额（万元）';
comment on column TJBB_DT_B05101.qjny
  is '期间（年/月）';
comment on column TJBB_DT_B05101.tms_9610_hs
  is '户数';
comment on column TJBB_DT_B05101.tms_9610_je
  is '金额（万元）';
comment on column TJBB_DT_B05101.tms_9710_hs
  is '户数';
comment on column TJBB_DT_B05101.tms_9710_je
  is '金额（万元）';
comment on column TJBB_DT_B05101.tms_9810_hs
  is '户数';
comment on column TJBB_DT_B05101.tms_9810_je
  is '金额（万元）';
alter table TJBB_DT_B05101
  add constraint PK_TJBB_DT_B05101 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B05102
prompt =============================
prompt
create table TJBB_DT_B05102
(
  ssny           VARCHAR2(6) not null,
  bblc           VARCHAR2(10) not null,
  swjgdm         VARCHAR2(32) not null,
  kjls_cke_hs    NUMBER(16),
  kjls_cke_hs_hz NUMBER(16),
  kjls_cke_je    NUMBER(16,4),
  kjls_cke_je_hz NUMBER(16,4),
  kjls_tms_hs    NUMBER(16),
  kjls_tms_hs_hz NUMBER(16),
  kjls_tms_je    NUMBER(16,4),
  kjls_tms_je_hz NUMBER(16,4),
  qjny           VARCHAR2(16),
  wpms_cke_hs    NUMBER(16),
  wpms_cke_hs_hz NUMBER(16),
  wpms_cke_je    NUMBER(16,4),
  wpms_cke_je_hz NUMBER(16,4)
)
;
comment on column TJBB_DT_B05102.kjls_cke_hs
  is '户数';
comment on column TJBB_DT_B05102.kjls_cke_je
  is '金额（万元）';
comment on column TJBB_DT_B05102.kjls_tms_hs
  is '户数';
comment on column TJBB_DT_B05102.kjls_tms_je
  is '金额（万元）';
comment on column TJBB_DT_B05102.qjny
  is '期间（年/月）';
comment on column TJBB_DT_B05102.wpms_cke_hs
  is '户数';
comment on column TJBB_DT_B05102.wpms_cke_je
  is '金额（万元）';
alter table TJBB_DT_B05102
  add constraint PK_TJBB_DT_B05102 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B06101
prompt =============================
prompt
create table TJBB_DT_B06101
(
  ssny       VARCHAR2(6) not null,
  bblc       VARCHAR2(10) not null,
  swjgdm     VARCHAR2(32) not null,
  area       VARCHAR2(40),
  jyh_bas    NUMBER(16),
  jyh_bas_hz NUMBER(16),
  jyz_bas    NUMBER(16),
  jyz_bas_hz NUMBER(16),
  prov       VARCHAR2(16),
  sdsj       VARCHAR2(40)
)
;
comment on column TJBB_DT_B06101.area
  is '试点地区';
comment on column TJBB_DT_B06101.jyh_bas
  is '市场经营户备案数';
comment on column TJBB_DT_B06101.jyz_bas
  is '市场经营者备案数';
comment on column TJBB_DT_B06101.prov
  is '省份';
comment on column TJBB_DT_B06101.sdsj
  is '试点起始时间';
alter table TJBB_DT_B06101
  add constraint PK_TJBB_DT_B06101 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_B06102
prompt =============================
prompt
create table TJBB_DT_B06102
(
  ssny          VARCHAR2(6) not null,
  bblc          VARCHAR2(10) not null,
  swjgdm        VARCHAR2(32) not null,
  area          VARCHAR2(40),
  cke_mon       NUMBER(16,6),
  cke_mon_hz    NUMBER(16,6),
  cke_total     NUMBER(16,6),
  cke_total_hz  NUMBER(16,6),
  prov          VARCHAR2(16),
  qjny          VARCHAR2(40),
  sbms_mon      NUMBER(16,6),
  sbms_mon_hz   NUMBER(16,6),
  sbms_total    NUMBER(16,6),
  sbms_total_hz NUMBER(16,6)
)
;
comment on column TJBB_DT_B06102.area
  is '试点地区';
comment on column TJBB_DT_B06102.cke_mon
  is '出口货物总值';
comment on column TJBB_DT_B06102.cke_total
  is '出口货物总值';
comment on column TJBB_DT_B06102.prov
  is '省份';
comment on column TJBB_DT_B06102.qjny
  is '期间（年/月）';
comment on column TJBB_DT_B06102.sbms_mon
  is '申报免税出口额';
comment on column TJBB_DT_B06102.sbms_total
  is '申报免税出口额';

prompt
prompt Creating table TJBB_DT_B07101
prompt =============================
prompt
create table TJBB_DT_B07101
(
  ssny            VARCHAR2(6) not null,
  bblc            VARCHAR2(10) not null,
  swjgdm          VARCHAR2(32) not null,
  rdhs            NUMBER(16),
  rdhs_hz         NUMBER(16),
  sbhs            NUMBER(16),
  sbhs_hz         NUMBER(16),
  rd_sb_lv        NUMBER(16,4),
  rd_sb_lv_hz     NUMBER(16,4),
  sb_cke_cur      NUMBER(16,4),
  sb_cke_cur_hz   NUMBER(16,4),
  sb_cke_last     NUMBER(16,4),
  sb_cke_last_hz  NUMBER(16,4),
  sb_cke_tblv     NUMBER(16,4),
  sb_cke_tblv_hz  NUMBER(16,4),
  sb_tmse_cur     NUMBER(16,4),
  sb_tmse_cur_hz  NUMBER(16,4),
  sb_tmse_last    NUMBER(16,4),
  sb_tmse_last_hz NUMBER(16,4),
  sb_tmse_tblv    NUMBER(16,4),
  sb_tmse_tblv_hz NUMBER(16,4),
  sh_tmse_cur     NUMBER(16,4),
  sh_tmse_cur_hz  NUMBER(16,4),
  sh_tmse_last    NUMBER(16,4),
  sh_tmse_last_hz NUMBER(16,4),
  sh_tmse_tblv    NUMBER(16,4),
  sh_tmse_tblv_hz NUMBER(16,4),
  sp_tmse_cur     NUMBER(16,4),
  sp_tmse_cur_hz  NUMBER(16,4),
  sp_tmse_last    NUMBER(16,4),
  sp_tmse_last_hz NUMBER(16,4),
  sp_tmse_tblv    NUMBER(16,4),
  sp_tmse_tblv_hz NUMBER(16,4),
  tk_cur          NUMBER(16,4),
  tk_cur_hz       NUMBER(16,4),
  tk_last         NUMBER(16,4),
  tk_last_hz      NUMBER(16,4),
  tk_tblv         NUMBER(16,4),
  tk_tblv_hz      NUMBER(16,4)
)
;
comment on column TJBB_DT_B07101.rdhs
  is '认定户数';
comment on column TJBB_DT_B07101.sbhs
  is '申报户数';
comment on column TJBB_DT_B07101.rd_sb_lv
  is '申报户数占认定户数的比率（100%）';
comment on column TJBB_DT_B07101.sb_cke_cur
  is '小计';
comment on column TJBB_DT_B07101.sb_cke_last
  is '上年同期申报';
comment on column TJBB_DT_B07101.sb_cke_tblv
  is '同比变动率（100%）';
comment on column TJBB_DT_B07101.sb_tmse_cur
  is '小计';
comment on column TJBB_DT_B07101.sb_tmse_last
  is '上年同期申报';
comment on column TJBB_DT_B07101.sb_tmse_tblv
  is '同比变动率（100%）';
comment on column TJBB_DT_B07101.sh_tmse_cur
  is '小计';
comment on column TJBB_DT_B07101.sh_tmse_last
  is '上年同期申报';
comment on column TJBB_DT_B07101.sh_tmse_tblv
  is '同比变动率（100%）';
comment on column TJBB_DT_B07101.sp_tmse_cur
  is '小计';
comment on column TJBB_DT_B07101.sp_tmse_last
  is '上年同期申报';
comment on column TJBB_DT_B07101.sp_tmse_tblv
  is '同比变动率（100%）';
comment on column TJBB_DT_B07101.tk_cur
  is '小计';
comment on column TJBB_DT_B07101.tk_last
  is '上年同期办理';
comment on column TJBB_DT_B07101.tk_tblv
  is '同比变动率（100%）';
alter table TJBB_DT_B07101
  add constraint PK_TJBB_DT_B07101 primary key (SWJGDM, SSNY, BBLC);

prompt
prompt Creating table TJBB_DT_D01002
prompt =============================
prompt
create table TJBB_DT_D01002
(
  paramhash VARCHAR2(64) not null,
  bblc      VARCHAR2(10) not null,
  swjgdm    VARCHAR2(32) not null,
  crtime    DATE default sysdate,
  je        NUMBER(16,4),
  je_sq     NUMBER(16,4),
  tb        NUMBER(16,4)
)
;
comment on column TJBB_DT_D01002.je
  is '金额';
comment on column TJBB_DT_D01002.je_sq
  is '上年同期';
comment on column TJBB_DT_D01002.tb
  is '同比';
alter table TJBB_DT_D01002
  add constraint PK_TJBB_DT_D01002 primary key (PARAMHASH, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_D01003
prompt =============================
prompt
create table TJBB_DT_D01003
(
  bblc       VARCHAR2(10) not null,
  swjgdm     VARCHAR2(32) not null,
  ts_amt     NUMBER(16,4),
  ts_amt_sq  NUMBER(16,4),
  ts_amt_tb  NUMBER(16,4),
  ts_amt_zb  NUMBER(16,4),
  usd_amt    NUMBER(16,4),
  usd_amt_sq NUMBER(16,4),
  usd_amt_tb NUMBER(16,4),
  usd_amt_zb NUMBER(16,4),
  paramhash  VARCHAR2(64) not null,
  mldm       VARCHAR2(10),
  crtime     DATE default sysdate not null
)
;
comment on column TJBB_DT_D01003.ts_amt
  is '累计退税额';
comment on column TJBB_DT_D01003.ts_amt_sq
  is '上年同期';
comment on column TJBB_DT_D01003.ts_amt_tb
  is '同比';
comment on column TJBB_DT_D01003.ts_amt_zb
  is '占比';
comment on column TJBB_DT_D01003.usd_amt
  is '累计出口额';
comment on column TJBB_DT_D01003.usd_amt_sq
  is '上年同期';
comment on column TJBB_DT_D01003.usd_amt_tb
  is '同比';
comment on column TJBB_DT_D01003.usd_amt_zb
  is '占比';
comment on column TJBB_DT_D01003.paramhash
  is '参数HASH';
comment on column TJBB_DT_D01003.mldm
  is '商品大类代码';
create index IDX_HASH_D01003 on TJBB_DT_D01003 (PARAMHASH);
alter table TJBB_DT_D01003
  add constraint PK_TJBB_DT_D01003 primary key (BBLC, SWJGDM, PARAMHASH);

prompt
prompt Creating table TJBB_DT_D01004
prompt =============================
prompt
create table TJBB_DT_D01004
(
  paramhash  VARCHAR2(64) not null,
  bblc       VARCHAR2(10) not null,
  swjgdm     VARCHAR2(32) not null,
  crtime     DATE default sysdate,
  code       VARCHAR2(16),
  name       VARCHAR2(200),
  usd_amt    NUMBER(16,4),
  usd_amt_sq NUMBER(16,4),
  usd_amt_tb NUMBER(16,4),
  usd_amt_zb NUMBER(16,4),
  xh         VARCHAR2(16)
)
;
comment on column TJBB_DT_D01004.code
  is '代码';
comment on column TJBB_DT_D01004.name
  is '名称';
comment on column TJBB_DT_D01004.usd_amt
  is '累计出口额';
comment on column TJBB_DT_D01004.usd_amt_sq
  is '上年同期';
comment on column TJBB_DT_D01004.usd_amt_tb
  is '同比';
comment on column TJBB_DT_D01004.usd_amt_zb
  is '占比';
comment on column TJBB_DT_D01004.xh
  is '序号';
alter table TJBB_DT_D01004
  add constraint PK_TJBB_DT_D01004 primary key (PARAMHASH, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_D01005
prompt =============================
prompt
create table TJBB_DT_D01005
(
  paramhash  VARCHAR2(64) not null,
  bblc       VARCHAR2(10) not null,
  swjgdm     VARCHAR2(32) not null,
  crtime     DATE default sysdate,
  nsrmc      VARCHAR2(400),
  nsrsbh     VARCHAR2(32),
  pm         VARCHAR2(16),
  ts_amt     NUMBER(16,4),
  ts_amt_sq  NUMBER(16,4),
  ts_amt_tb  NUMBER(16,4),
  usd_amt    NUMBER(16,4),
  usd_amt_sq NUMBER(16,4),
  usd_amt_tb NUMBER(16,4)
)
;
comment on column TJBB_DT_D01005.nsrmc
  is '企业名称';
comment on column TJBB_DT_D01005.nsrsbh
  is '社会信用代码';
comment on column TJBB_DT_D01005.pm
  is '排名';
comment on column TJBB_DT_D01005.ts_amt
  is '累计退税额';
comment on column TJBB_DT_D01005.ts_amt_sq
  is '上年同期';
comment on column TJBB_DT_D01005.ts_amt_tb
  is '同比';
comment on column TJBB_DT_D01005.usd_amt
  is '累计出口额';
comment on column TJBB_DT_D01005.usd_amt_sq
  is '上年同期';
comment on column TJBB_DT_D01005.usd_amt_tb
  is '同比';
alter table TJBB_DT_D01005
  add constraint PK_TJBB_DT_D01005 primary key (PARAMHASH, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_D01006
prompt =============================
prompt
create table TJBB_DT_D01006
(
  paramhash  VARCHAR2(64) not null,
  bblc       VARCHAR2(10) not null,
  swjgdm     VARCHAR2(32) not null,
  crtime     DATE default sysdate,
  tsl        VARCHAR2(10),
  usd_amt    NUMBER(16,4),
  usd_amt_sq NUMBER(16,4),
  usd_amt_tb NUMBER(16,4),
  usd_amt_zb NUMBER(16,4),
  xh         VARCHAR2(10)
)
;
comment on column TJBB_DT_D01006.tsl
  is '退税率';
comment on column TJBB_DT_D01006.usd_amt
  is '出口额';
comment on column TJBB_DT_D01006.usd_amt_sq
  is '上年同期';
comment on column TJBB_DT_D01006.usd_amt_tb
  is '同比';
comment on column TJBB_DT_D01006.usd_amt_zb
  is '占比';
comment on column TJBB_DT_D01006.xh
  is '序号';
alter table TJBB_DT_D01006
  add constraint PK_TJBB_DT_D01006 primary key (PARAMHASH, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_D01007
prompt =============================
prompt
create table TJBB_DT_D01007
(
  paramhash  VARCHAR2(64) not null,
  bblc       VARCHAR2(10) not null,
  swjgdm     VARCHAR2(32) not null,
  crtime     DATE default sysdate,
  hymc       VARCHAR2(400),
  qyhs       NUMBER(16),
  ts_amt     NUMBER(16,4),
  ts_amt_sq  NUMBER(16,4),
  ts_amt_tb  NUMBER(16,4),
  ts_amt_zb  NUMBER(16,4),
  usd_amt    NUMBER(16,4),
  usd_amt_sq NUMBER(16,4),
  usd_amt_tb NUMBER(16,4),
  usd_amt_zb NUMBER(16,4),
  xh         VARCHAR2(10),
  hydm       VARCHAR2(10),
  sjhy_dm    VARCHAR2(10)
)
;
comment on column TJBB_DT_D01007.hymc
  is '行业名称';
comment on column TJBB_DT_D01007.qyhs
  is '户数';
comment on column TJBB_DT_D01007.ts_amt
  is '累计退税额';
comment on column TJBB_DT_D01007.ts_amt_sq
  is '上年同期';
comment on column TJBB_DT_D01007.ts_amt_tb
  is '同比';
comment on column TJBB_DT_D01007.ts_amt_zb
  is '占比';
comment on column TJBB_DT_D01007.usd_amt
  is '累计出口额';
comment on column TJBB_DT_D01007.usd_amt_sq
  is '上年同期';
comment on column TJBB_DT_D01007.usd_amt_tb
  is '同比';
comment on column TJBB_DT_D01007.usd_amt_zb
  is '占比';
comment on column TJBB_DT_D01007.xh
  is '序号';
comment on column TJBB_DT_D01007.hydm
  is '行业代码';
comment on column TJBB_DT_D01007.sjhy_dm
  is '上级行业代码';
alter table TJBB_DT_D01007
  add constraint PK_TJBB_DT_D01007 primary key (PARAMHASH, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_D01008
prompt =============================
prompt
create table TJBB_DT_D01008
(
  paramhash  VARCHAR2(64) not null,
  bblc       VARCHAR2(10) not null,
  swjgdm     VARCHAR2(32) not null,
  crtime     DATE default sysdate,
  hgcode     VARCHAR2(16),
  hgmc       VARCHAR2(100),
  usd_amt    NUMBER(16,4),
  usd_amt_sq NUMBER(16,4),
  usd_amt_tb NUMBER(16,4),
  usd_amt_zb NUMBER(16,4),
  xh         VARCHAR2(10)
)
;
comment on column TJBB_DT_D01008.hgcode
  is '关别代码';
comment on column TJBB_DT_D01008.hgmc
  is '海关名称';
comment on column TJBB_DT_D01008.usd_amt
  is '累计出口额';
comment on column TJBB_DT_D01008.usd_amt_sq
  is '上年同期';
comment on column TJBB_DT_D01008.usd_amt_tb
  is '同比';
comment on column TJBB_DT_D01008.usd_amt_zb
  is '占比';
comment on column TJBB_DT_D01008.xh
  is '序号';
alter table TJBB_DT_D01008
  add constraint PK_TJBB_DT_D01008 primary key (PARAMHASH, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_D01009
prompt =============================
prompt
create table TJBB_DT_D01009
(
  paramhash  VARCHAR2(64) not null,
  bblc       VARCHAR2(10) not null,
  swjgdm     VARCHAR2(32) not null,
  crtime     DATE default sysdate,
  tdcode     VARCHAR2(10),
  tdmc       VARCHAR2(100),
  usd_amt    NUMBER(16,4),
  usd_amt_sq NUMBER(16,4),
  usd_amt_tb NUMBER(16,4),
  usd_amt_zb NUMBER(16,4),
  xh         VARCHAR2(10)
)
;
comment on column TJBB_DT_D01009.tdcode
  is '监管方式代码';
comment on column TJBB_DT_D01009.tdmc
  is '监管方式名称';
comment on column TJBB_DT_D01009.usd_amt
  is '累计出口额';
comment on column TJBB_DT_D01009.usd_amt_sq
  is '上年同期';
comment on column TJBB_DT_D01009.usd_amt_tb
  is '同比';
comment on column TJBB_DT_D01009.usd_amt_zb
  is '占比';
comment on column TJBB_DT_D01009.xh
  is '序号';
alter table TJBB_DT_D01009
  add constraint PK_TJBB_DT_D01009 primary key (PARAMHASH, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_D01010
prompt =============================
prompt
create table TJBB_DT_D01010
(
  paramhash VARCHAR2(64) not null,
  bblc      VARCHAR2(10) not null,
  swjgdm    VARCHAR2(32) not null,
  crtime    DATE default sysdate,
  jhamt     NUMBER(16,4),
  jhamt_sq  NUMBER(16,4),
  jhamt_tb  NUMBER(16,4),
  jhamt_zb  NUMBER(16,4),
  mc        VARCHAR2(200),
  tse       NUMBER(16,4),
  tse_sq    NUMBER(16,4),
  tse_tb    NUMBER(16,4),
  tse_zb    NUMBER(16,4),
  sjxzqh    VARCHAR2(10),
  xzqh      VARCHAR2(10)
)
;
comment on column TJBB_DT_D01010.jhamt
  is '累计进货额';
comment on column TJBB_DT_D01010.jhamt_sq
  is '上年同期';
comment on column TJBB_DT_D01010.jhamt_tb
  is '同比';
comment on column TJBB_DT_D01010.jhamt_zb
  is '占比';
comment on column TJBB_DT_D01010.mc
  is '供货企业区域';
comment on column TJBB_DT_D01010.tse
  is '累计退税额';
comment on column TJBB_DT_D01010.tse_sq
  is '上年同期';
comment on column TJBB_DT_D01010.tse_tb
  is '同比';
comment on column TJBB_DT_D01010.tse_zb
  is '占比';
comment on column TJBB_DT_D01010.sjxzqh
  is '上级行政区划';
comment on column TJBB_DT_D01010.xzqh
  is '行政区划';
alter table TJBB_DT_D01010
  add constraint PK_TJBB_DT_D01010 primary key (PARAMHASH, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_DT_E01001
prompt =============================
prompt
create table TJBB_DT_E01001
(
  ssny   VARCHAR2(6) not null,
  bblc   VARCHAR2(10) not null,
  swjgdm VARCHAR2(32) not null,
  apr    NUMBER(16,4),
  aug    NUMBER(16,4),
  dec    NUMBER(16,4),
  feb    NUMBER(16,4),
  jan    NUMBER(16,4),
  jul    NUMBER(16,4),
  jun    NUMBER(16,4),
  mar    NUMBER(16,4),
  may    NUMBER(16,4),
  nov    NUMBER(16,4),
  oct    NUMBER(16,4),
  sep    NUMBER(16,4)
)
;
comment on column TJBB_DT_E01001.apr
  is '4月';
comment on column TJBB_DT_E01001.aug
  is '8月';
comment on column TJBB_DT_E01001.dec
  is '12月';
comment on column TJBB_DT_E01001.feb
  is '2月';
comment on column TJBB_DT_E01001.jan
  is '1月';
comment on column TJBB_DT_E01001.jul
  is '7月';
comment on column TJBB_DT_E01001.jun
  is '6月';
comment on column TJBB_DT_E01001.mar
  is '3月';
comment on column TJBB_DT_E01001.may
  is '5月';
comment on column TJBB_DT_E01001.nov
  is '11月';
comment on column TJBB_DT_E01001.oct
  is '10月';
comment on column TJBB_DT_E01001.sep
  is '9月';
alter table TJBB_DT_E01001
  add constraint PK_TJBB_DT_E01001 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TJBB_HEADER_COLS
prompt ===============================
prompt
create table TJBB_HEADER_COLS
(
  bbdm         VARCHAR2(10),
  fname        VARCHAR2(20),
  cname        VARCHAR2(60),
  fnamehz      VARCHAR2(20),
  ftype        VARCHAR2(20),
  maxlen       NUMBER,
  degree       NUMBER,
  defval       VARCHAR2(30),
  nullable     CHAR(1),
  fmt          VARCHAR2(30),
  showorder    NUMBER,
  xlscol       VARCHAR2(3),
  allowupdate  CHAR(1) not null,
  note         VARCHAR2(100),
  qybj         CHAR(1) not null,
  align        CHAR(1),
  allowformula CHAR(1),
  id           NUMBER not null,
  allowsum     CHAR(1) default 'Y',
  hztype       CHAR(1) default '1',
  hzobj        VARCHAR2(20)
)
;
comment on column TJBB_HEADER_COLS.bbdm
  is '报表代码';
comment on column TJBB_HEADER_COLS.fname
  is '字段名';
comment on column TJBB_HEADER_COLS.cname
  is '字段中文名，主表头';
comment on column TJBB_HEADER_COLS.fnamehz
  is '汇总字段名,默认为空，为空则汇总字段=字段名_hz';
comment on column TJBB_HEADER_COLS.ftype
  is '字段类型varchar/number/date';
comment on column TJBB_HEADER_COLS.maxlen
  is '长度';
comment on column TJBB_HEADER_COLS.degree
  is '精度';
comment on column TJBB_HEADER_COLS.defval
  is '缺省值';
comment on column TJBB_HEADER_COLS.nullable
  is 'Y可空 N非空，默认Y';
comment on column TJBB_HEADER_COLS.fmt
  is '输出格式';
comment on column TJBB_HEADER_COLS.showorder
  is '显示顺序，为空则界面表头不显示该字段';
comment on column TJBB_HEADER_COLS.xlscol
  is '用于导出到EXCEL模版';
comment on column TJBB_HEADER_COLS.allowupdate
  is 'Y可修改N不可修改';
comment on column TJBB_HEADER_COLS.note
  is '用于tips展示，为空用中文名';
comment on column TJBB_HEADER_COLS.qybj
  is 'Y/N缺省启用，考虑报表字段有可能增减变化';
comment on column TJBB_HEADER_COLS.align
  is '显示位置,0：靠左，1：居中，2：靠右';
comment on column TJBB_HEADER_COLS.allowformula
  is 'Y允许列进行公式运算，N不允许运算公式，默认为Y';
comment on column TJBB_HEADER_COLS.id
  is '主键';
comment on column TJBB_HEADER_COLS.allowsum
  is 'Y允许列进行求和汇总，N不允许求和汇总，默认为Y';
comment on column TJBB_HEADER_COLS.hztype
  is ' 1求和  2同比  3环比';
comment on column TJBB_HEADER_COLS.hzobj
  is '汇总作用对象';
alter table TJBB_HEADER_COLS
  add constraint PK_HEADER_COLS primary key (ID);
alter table TJBB_HEADER_COLS
  add constraint UNI_HEADER_COLS unique (BBDM, FNAME);

prompt
prompt Creating table TJBB_LINE_ITEM
prompt =============================
prompt
create table TJBB_LINE_ITEM
(
  bbdm         VARCHAR2(10) not null,
  bblc         VARCHAR2(3) not null,
  lcmc         VARCHAR2(200),
  showorder    NUMBER not null,
  xlsrow       VARCHAR2(3),
  allowupdate  CHAR(1) not null,
  qybj         CHAR(1) not null,
  hztype       CHAR(1) default '1',
  hzobj        VARCHAR2(20),
  allowformula CHAR(1)
)
;
comment on column TJBB_LINE_ITEM.bbdm
  is '报表代码';
comment on column TJBB_LINE_ITEM.bblc
  is '报表栏次';
comment on column TJBB_LINE_ITEM.lcmc
  is '栏次名称';
comment on column TJBB_LINE_ITEM.showorder
  is '显示排序';
comment on column TJBB_LINE_ITEM.xlsrow
  is 'EXCEL行';
comment on column TJBB_LINE_ITEM.allowupdate
  is 'Y可修改N不可修改';
comment on column TJBB_LINE_ITEM.qybj
  is 'Y/N缺省启用，考虑报表栏次有可能增减变化';
comment on column TJBB_LINE_ITEM.hztype
  is ' 1求和  2同比  3环比';
comment on column TJBB_LINE_ITEM.hzobj
  is '汇总作用对象';
comment on column TJBB_LINE_ITEM.allowformula
  is 'Y列公式是否在行上起效N否';
alter table TJBB_LINE_ITEM
  add constraint PK_TJBB_LINE_ITEM primary key (BBDM, BBLC);

prompt
prompt Creating table TJBB_REPORT_DYNAMIC
prompt ==================================
prompt
create table TJBB_REPORT_DYNAMIC
(
  bbdm         VARCHAR2(6) not null,
  location     VARCHAR2(10) not null,
  bblc_name    VARCHAR2(200),
  column_title VARCHAR2(200) not null,
  sql_script   VARCHAR2(4000) not null,
  is_valid     CHAR(1) not null,
  crtime       DATE,
  uptime       DATE,
  db_target    VARCHAR2(20),
  remark       VARCHAR2(2000)
)
;
comment on column TJBB_REPORT_DYNAMIC.bblc_name
  is '栏次中文描述';
comment on column TJBB_REPORT_DYNAMIC.column_title
  is '列中文描述';
comment on column TJBB_REPORT_DYNAMIC.is_valid
  is '是否有效启用';
comment on column TJBB_REPORT_DYNAMIC.db_target
  is '数据源目标，默认为便捷退税';
comment on column TJBB_REPORT_DYNAMIC.remark
  is '描述';
alter table TJBB_REPORT_DYNAMIC
  add constraint PK_BBDM_LOC primary key (BBDM, LOCATION);

prompt
prompt Creating table TJBB_REPORT_FORMULA
prompt ==================================
prompt
create table TJBB_REPORT_FORMULA
(
  id      NUMBER not null,
  bbdm    VARCHAR2(10),
  type    CHAR(1),
  formula VARCHAR2(200),
  yxj     NUMBER default 0,
  qybz    CHAR(1),
  ishzjs  CHAR(1)
)
;
comment on column TJBB_REPORT_FORMULA.type
  is '公式类型 1，列公式 2，行公式';
comment on column TJBB_REPORT_FORMULA.yxj
  is '优先级,数字越小优先级越高';
comment on column TJBB_REPORT_FORMULA.ishzjs
  is '是否参与汇总计算1，参与0，不参与';
alter table TJBB_REPORT_FORMULA
  add constraint PK_TJBB_REPORT_FORMULA primary key (ID);

prompt
prompt Creating table TJBB_REPORT_HEADER
prompt =================================
prompt
create table TJBB_REPORT_HEADER
(
  bbdm      VARCHAR2(10) not null,
  bh        VARCHAR2(20) not null,
  showname  VARCHAR2(150),
  type      CHAR(1) not null,
  ismerg    CHAR(1) not null,
  dispwidth VARCHAR2(8),
  disphight VARCHAR2(8),
  h         VARCHAR2(3) not null,
  w         VARCHAR2(3) not null,
  horder    NUMBER not null,
  vorder    NUMBER not null,
  qybj      CHAR(1) not null
)
;
comment on column TJBB_REPORT_HEADER.bbdm
  is '报表代码';
comment on column TJBB_REPORT_HEADER.bh
  is '编号';
comment on column TJBB_REPORT_HEADER.showname
  is '显示名称';
comment on column TJBB_REPORT_HEADER.type
  is '1：表头 2：栏次';
comment on column TJBB_REPORT_HEADER.ismerg
  is '0：否  1：是';
comment on column TJBB_REPORT_HEADER.qybj
  is '启用标志,Y/N缺省启用，考虑报表栏次有可能增减变化';
alter table TJBB_REPORT_HEADER
  add constraint PK_TJBB_REPORT_HEADER primary key (BBDM, BH, TYPE);

prompt
prompt Creating table TJBB_REPORT_ITEM
prompt ===============================
prompt
create table TJBB_REPORT_ITEM
(
  bbdldm VARCHAR2(10) not null,
  bbdlmc VARCHAR2(60),
  bbdljc VARCHAR2(40),
  note   VARCHAR2(100),
  type   VARCHAR2(1)
)
;
comment on column TJBB_REPORT_ITEM.bbdldm
  is '报表大类代码';
comment on column TJBB_REPORT_ITEM.bbdlmc
  is '报表大类名称';
comment on column TJBB_REPORT_ITEM.bbdljc
  is '报表大类简称';
comment on column TJBB_REPORT_ITEM.note
  is '说明';
comment on column TJBB_REPORT_ITEM.type
  is '报表类型，1,适用统计报表 2.适用统计分析';
alter table TJBB_REPORT_ITEM
  add constraint PK_TJBB_REPORT_ITEM primary key (BBDLDM);

prompt
prompt Creating table TJBB_REPORT_LIST
prompt ===============================
prompt
create table TJBB_REPORT_LIST
(
  bbdm       VARCHAR2(10) not null,
  bbdldm     VARCHAR2(10) not null,
  bbmc       VARCHAR2(60) not null,
  bbjc       VARCHAR2(40),
  fname      VARCHAR2(30) not null,
  sppy       NUMBER,
  czpy       NUMBER,
  sfbl       NUMBER,
  classhz    VARCHAR2(100),
  classcx    VARCHAR2(100),
  classsb    VARCHAR2(100),
  classzf    VARCHAR2(100),
  showorder  NUMBER,
  bbtype     CHAR(1) not null,
  qybj       CHAR(1),
  note       VARCHAR2(100),
  excelcol   NUMBER,
  excelrow   NUMBER,
  headcol    NUMBER,
  headrow    NUMBER,
  hztype     CHAR(1),
  swjgmctype CHAR(1),
  endrow     NUMBER,
  endcol     NUMBER,
  proc       VARCHAR2(50),
  prochz     VARCHAR2(50)
)
;
comment on column TJBB_REPORT_LIST.bbdm
  is '报表代码';
comment on column TJBB_REPORT_LIST.bbdldm
  is '报表大类代码';
comment on column TJBB_REPORT_LIST.bbmc
  is '报表中文名称';
comment on column TJBB_REPORT_LIST.bbjc
  is '报表简称称';
comment on column TJBB_REPORT_LIST.fname
  is '数据库表名';
comment on column TJBB_REPORT_LIST.sppy
  is '打印水平偏移，预留';
comment on column TJBB_REPORT_LIST.czpy
  is '打印垂直偏移,';
comment on column TJBB_REPORT_LIST.sfbl
  is '默认缩放比例';
comment on column TJBB_REPORT_LIST.classhz
  is '汇总服务类';
comment on column TJBB_REPORT_LIST.classcx
  is '查询服务类';
comment on column TJBB_REPORT_LIST.classsb
  is '上报服务类';
comment on column TJBB_REPORT_LIST.classzf
  is '撤销服务类';
comment on column TJBB_REPORT_LIST.showorder
  is '显示顺序';
comment on column TJBB_REPORT_LIST.bbtype
  is '报表类型,1固定报表 2可变长报表 3可变长翻页表';
comment on column TJBB_REPORT_LIST.qybj
  is '启用标志,Y/N缺省启用，考虑报表字段有可能增减变化';
comment on column TJBB_REPORT_LIST.note
  is '说明';
comment on column TJBB_REPORT_LIST.excelcol
  is 'Excel模板数据起始列';
comment on column TJBB_REPORT_LIST.excelrow
  is 'Excel模板数据起始行';
comment on column TJBB_REPORT_LIST.headcol
  is 'Excel模板表头起始列';
comment on column TJBB_REPORT_LIST.headrow
  is 'Excel模板表头起始行';
comment on column TJBB_REPORT_LIST.hztype
  is '1指标汇总，3明细汇总，5合计汇总';
comment on column TJBB_REPORT_LIST.swjgmctype
  is '对于合计汇总表，（DM_SWJG_SJ）显示的税务机关名称类型   1-全称 ，2-简称，3-显示名称';
comment on column TJBB_REPORT_LIST.endrow
  is 'Excel模板结束行';
comment on column TJBB_REPORT_LIST.endcol
  is 'Excel模板结束列';
comment on column TJBB_REPORT_LIST.proc
  is '初始化存储过程';
comment on column TJBB_REPORT_LIST.prochz
  is '汇总存储过程';
alter table TJBB_REPORT_LIST
  add constraint PK_TJBB_REPORT_LIST primary key (BBDM);

prompt
prompt Creating table TJBB_REPORT_TBXX
prompt ===============================
prompt
create table TJBB_REPORT_TBXX
(
  id     NUMBER not null,
  bbdm   VARCHAR2(10),
  swjgdm VARCHAR2(18),
  swjgmc VARCHAR2(40),
  ssny   VARCHAR2(20),
  unit   VARCHAR2(30),
  zbr    VARCHAR2(40),
  zbdate DATE,
  qt     VARCHAR2(50)
)
;
comment on column TJBB_REPORT_TBXX.id
  is '主键';
comment on column TJBB_REPORT_TBXX.swjgmc
  is '填表名称';
comment on column TJBB_REPORT_TBXX.ssny
  is '填表期别';
comment on column TJBB_REPORT_TBXX.unit
  is '填表单位';
comment on column TJBB_REPORT_TBXX.zbr
  is '制表人';
comment on column TJBB_REPORT_TBXX.zbdate
  is '制表日期';
comment on column TJBB_REPORT_TBXX.qt
  is '其他选项';
alter table TJBB_REPORT_TBXX
  add constraint PK_TJBB_REPORT_TBXX primary key (ID);
alter table TJBB_REPORT_TBXX
  add constraint UQ_TJBB_REPORT_TBXX unique (BBDM, SWJGDM);

prompt
prompt Creating table TJBB_SB_JYXX
prompt ===========================
prompt
create table TJBB_SB_JYXX
(
  id        VARCHAR2(64) not null,
  swjgdm    VARCHAR2(11),
  ssny      VARCHAR2(6),
  bbdldm    VARCHAR2(3),
  bbdm      VARCHAR2(6),
  msg_type  CHAR(1),
  msg_level CHAR(1),
  msg       VARCHAR2(200)
)
;
comment on column TJBB_SB_JYXX.id
  is '主键';
comment on column TJBB_SB_JYXX.msg_level
  is '1,错误 2.提示';
alter table TJBB_SB_JYXX
  add constraint PK_TJBB_JYXX primary key (ID);

prompt
prompt Creating table TJBB_SWJG_MONTH
prompt ==============================
prompt
create table TJBB_SWJG_MONTH
(
  swjgdm VARCHAR2(11) not null,
  ssny   VARCHAR2(6)
)
;
comment on table TJBB_SWJG_MONTH
  is '报表制表前月份数据是否初始化控制表';
alter table TJBB_SWJG_MONTH
  add constraint PK_TJBB_SWJG_MONTH primary key (SWJGDM);

prompt
prompt Creating table TJBB_TASK
prompt ========================
prompt
create table TJBB_TASK
(
  bbdldm VARCHAR2(10) not null,
  swjgdm VARCHAR2(11) not null,
  ny     VARCHAR2(6) not null,
  status VARCHAR2(2) not null,
  sjswjg VARCHAR2(11) not null,
  cjtime TIMESTAMP(6) not null,
  cjr    VARCHAR2(20) not null,
  zbtime TIMESTAMP(6),
  zbr    VARCHAR2(20),
  sbtime TIMESTAMP(6),
  sbr    VARCHAR2(20),
  chtime TIMESTAMP(6),
  chr    VARCHAR2(20),
  type   CHAR(1) not null,
  swjgmc VARCHAR2(60) not null,
  swjgjc VARCHAR2(60),
  note   VARCHAR2(255)
)
;
comment on column TJBB_TASK.bbdldm
  is '报表大类代码';
comment on column TJBB_TASK.swjgdm
  is '报表机关代码';
comment on column TJBB_TASK.ny
  is 'yyyymm';
comment on column TJBB_TASK.status
  is '00创建10制表（汇总/调整）20上报';
comment on column TJBB_TASK.cjr
  is '一般为系统admin';
comment on column TJBB_TASK.zbtime
  is '首次制表完成时间';
comment on column TJBB_TASK.zbr
  is '制表人';
comment on column TJBB_TASK.sbtime
  is '上报时间';
comment on column TJBB_TASK.chtime
  is '撤回时间';
comment on column TJBB_TASK.chr
  is '撤回人';
comment on column TJBB_TASK.type
  is '1表示基层报表，由汇总服务从原始数据统计而得
2表示汇总报表，由基层报表汇总而得';
alter table TJBB_TASK
  add constraint PK_TJBB_TASK primary key (BBDLDM, SWJGDM, NY);

prompt
prompt Creating table TJBB_TASK_SUB
prompt ============================
prompt
create table TJBB_TASK_SUB
(
  bbid   VARCHAR2(64) not null,
  bbdm   VARCHAR2(10) not null,
  swjgdm VARCHAR2(11) not null,
  ny     VARCHAR2(6) not null,
  hztime TIMESTAMP(6) not null,
  hzr    VARCHAR2(20) not null,
  xgtime TIMESTAMP(6),
  xgr    VARCHAR2(20),
  bbdldm VARCHAR2(10)
)
;
comment on column TJBB_TASK_SUB.bbid
  is '报表id';
comment on column TJBB_TASK_SUB.bbdm
  is '报表代码';
comment on column TJBB_TASK_SUB.swjgdm
  is '报表机关代码';
comment on column TJBB_TASK_SUB.ny
  is '年月yyyymm';
comment on column TJBB_TASK_SUB.hztime
  is '附表汇总的时间';
comment on column TJBB_TASK_SUB.hzr
  is '汇总人';
comment on column TJBB_TASK_SUB.xgtime
  is '附表调整后保存时间';
comment on column TJBB_TASK_SUB.xgr
  is '修改人';
comment on column TJBB_TASK_SUB.bbdldm
  is '报表大类代码';
alter table TJBB_TASK_SUB
  add constraint PK_TJBB_TASK_SUB primary key (BBID);

prompt
prompt Creating table TSGZ_CKTS_BDQSB
prompt ==============================
prompt
create table TSGZ_CKTS_BDQSB
(
  swjg_dm  VARCHAR2(11) not null,
  xh       NUMBER(10) not null,
  ny       VARCHAR2(6),
  tse_sb   NUMBER(16,2),
  mde_sb   NUMBER(16,2),
  tse_sq   NUMBER(16,2),
  mde_sq   NUMBER(16,2),
  tse_tblv NUMBER(16,2),
  mde_tblv NUMBER(16,2)
)
;
comment on table TSGZ_CKTS_BDQSB
  is '态势感知-出口退税-近6个月退税变动趋势表';
comment on column TSGZ_CKTS_BDQSB.swjg_dm
  is '税务机关代码';
comment on column TSGZ_CKTS_BDQSB.xh
  is '序号';
comment on column TSGZ_CKTS_BDQSB.ny
  is '年月';
comment on column TSGZ_CKTS_BDQSB.tse_sb
  is '申报退税额';
comment on column TSGZ_CKTS_BDQSB.mde_sb
  is '申报免抵额';
comment on column TSGZ_CKTS_BDQSB.tse_sq
  is '上年同期退税额';
comment on column TSGZ_CKTS_BDQSB.mde_sq
  is '上年同期免抵额';
comment on column TSGZ_CKTS_BDQSB.tse_tblv
  is '退税额同比';
comment on column TSGZ_CKTS_BDQSB.mde_tblv
  is '免抵额同比';
alter table TSGZ_CKTS_BDQSB
  add constraint PK_TSGZ_CKTS_BDQSB primary key (SWJG_DM, XH);

prompt
prompt Creating table TSGZ_CKTS_BDQSB_BACK_SBTJ
prompt ========================================
prompt
create table TSGZ_CKTS_BDQSB_BACK_SBTJ
(
  swjg_dm  VARCHAR2(11) not null,
  xh       NUMBER(10) not null,
  ny       VARCHAR2(6),
  tse_sb   NUMBER(16,2),
  mde_sb   NUMBER(16,2),
  tse_sq   NUMBER(16,2),
  mde_sq   NUMBER(16,2),
  tse_tblv NUMBER(16,2),
  mde_tblv NUMBER(16,2)
)
;

prompt
prompt Creating table TSGZ_CKTS_FLGLTJB
prompt ================================
prompt
create table TSGZ_CKTS_FLGLTJB
(
  swjg_dm     VARCHAR2(11) not null,
  ckqygllb_dm CHAR(1) not null,
  tse         NUMBER(16,2)
)
;
comment on table TSGZ_CKTS_FLGLTJB
  is '态势感知-出口退税-按分类管理统计表';
comment on column TSGZ_CKTS_FLGLTJB.swjg_dm
  is '税务机关代码';
comment on column TSGZ_CKTS_FLGLTJB.ckqygllb_dm
  is '分类管理类别';
comment on column TSGZ_CKTS_FLGLTJB.tse
  is '申报退税额';
alter table TSGZ_CKTS_FLGLTJB
  add constraint PK_TSGZ_CKTS_FLGLTJB primary key (SWJG_DM, CKQYGLLB_DM);

prompt
prompt Creating table TSGZ_CKTS_YWFLQKTJB
prompt ==================================
prompt
create table TSGZ_CKTS_YWFLQKTJB
(
  swjg_dm  VARCHAR2(11) not null,
  sbywb_dm VARCHAR2(8) not null,
  pc_sb    NUMBER(10),
  tse_sb   NUMBER(16,2),
  pc_sq    NUMBER(10),
  tse_sq   NUMBER(16,2),
  tblv_pc  NUMBER(9,2),
  tblv_tse NUMBER(9,2)
)
;
comment on table TSGZ_CKTS_YWFLQKTJB
  is '态势感知-出口退税-按业务分类退税情况统计表';
comment on column TSGZ_CKTS_YWFLQKTJB.swjg_dm
  is '税务机关代码';
comment on column TSGZ_CKTS_YWFLQKTJB.sbywb_dm
  is '申报业务代码';
comment on column TSGZ_CKTS_YWFLQKTJB.pc_sb
  is '申报批次数';
comment on column TSGZ_CKTS_YWFLQKTJB.tse_sb
  is '申报退税额';
comment on column TSGZ_CKTS_YWFLQKTJB.pc_sq
  is '申报批次数(上期)';
comment on column TSGZ_CKTS_YWFLQKTJB.tse_sq
  is '申报退税额(上期)';
comment on column TSGZ_CKTS_YWFLQKTJB.tblv_pc
  is '批次同比';
comment on column TSGZ_CKTS_YWFLQKTJB.tblv_tse
  is '退税额同比';
alter table TSGZ_CKTS_YWFLQKTJB
  add constraint PK_TSGZ_CKTS_YWFLQKTJB primary key (SWJG_DM, SBYWB_DM);

prompt
prompt Creating table TSGZ_DZBA_BA_BDQSB
prompt =================================
prompt
create table TSGZ_DZBA_BA_BDQSB
(
  swjg_dm VARCHAR2(11) not null,
  xh      NUMBER(10) not null,
  cnt_dy  NUMBER(10),
  tse_dy  NUMBER(16,2),
  cnt_lj  NUMBER(10),
  tse_lj  NUMBER(16,2),
  ny      VARCHAR2(6)
)
;
comment on table TSGZ_DZBA_BA_BDQSB
  is '态势感知-单证备案-备案变动趋势表';
comment on column TSGZ_DZBA_BA_BDQSB.swjg_dm
  is '税务机关代码';
comment on column TSGZ_DZBA_BA_BDQSB.xh
  is '序号';
comment on column TSGZ_DZBA_BA_BDQSB.cnt_dy
  is '当月批次数';
comment on column TSGZ_DZBA_BA_BDQSB.tse_dy
  is '当月退免税额';
comment on column TSGZ_DZBA_BA_BDQSB.cnt_lj
  is '累计批次数';
comment on column TSGZ_DZBA_BA_BDQSB.tse_lj
  is '累计退免税额';
comment on column TSGZ_DZBA_BA_BDQSB.ny
  is '年月';
alter table TSGZ_DZBA_BA_BDQSB
  add constraint PK_TSGZ_DZBA_BA_BDQSB primary key (SWJG_DM, XH);

prompt
prompt Creating table TSGZ_DZBA_BA_DQQKB
prompt =================================
prompt
create table TSGZ_DZBA_BA_DQQKB
(
  swjg_dm  VARCHAR2(11) not null,
  cnt_zb   NUMBER(10),
  cnt_yb   NUMBER(10),
  tse_zb   NUMBER(16,2),
  tse_yb   NUMBER(16,2),
  tse_bnlj NUMBER(16,2)
)
;
comment on table TSGZ_DZBA_BA_DQQKB
  is '态势感知-单证备案-备案当前情况表';
comment on column TSGZ_DZBA_BA_DQQKB.swjg_dm
  is '税务机关代码';
comment on column TSGZ_DZBA_BA_DQQKB.cnt_zb
  is '在备批次数';
comment on column TSGZ_DZBA_BA_DQQKB.cnt_yb
  is '已备批次数';
comment on column TSGZ_DZBA_BA_DQQKB.tse_zb
  is '在备退免税额';
comment on column TSGZ_DZBA_BA_DQQKB.tse_yb
  is '已备退免税额';
comment on column TSGZ_DZBA_BA_DQQKB.tse_bnlj
  is '本年累计退（免）税额';
alter table TSGZ_DZBA_BA_DQQKB
  add constraint PK_TSGZ_DZBA_BA_DQQKB primary key (SWJG_DM);

prompt
prompt Creating table TSGZ_DZBA_BA_TSFSTJB
prompt ===================================
prompt
create table TSGZ_DZBA_BA_TSFSTJB
(
  swjg_dm   VARCHAR2(11) not null,
  tsjsfs_dm CHAR(1) not null,
  cnt       NUMBER(10),
  tse       NUMBER(16,2)
)
;
comment on table TSGZ_DZBA_BA_TSFSTJB
  is '态势感知-单证备案-备案按退税方式统计表';
comment on column TSGZ_DZBA_BA_TSFSTJB.swjg_dm
  is '税务机关代码';
comment on column TSGZ_DZBA_BA_TSFSTJB.tsjsfs_dm
  is '退税计算方式';
comment on column TSGZ_DZBA_BA_TSFSTJB.cnt
  is '已备批次数';
comment on column TSGZ_DZBA_BA_TSFSTJB.tse
  is '已备案退免税额';
alter table TSGZ_DZBA_BA_TSFSTJB
  add constraint PK_TSGZ_DZBA_BA_TSFSTJB primary key (SWJG_DM, TSJSFS_DM);

prompt
prompt Creating table TSGZ_DZBA_DJ_BDQSB
prompt =================================
prompt
create table TSGZ_DZBA_DJ_BDQSB
(
  swjg_dm VARCHAR2(11) not null,
  xh      NUMBER(10) not null,
  djhs    NUMBER(10),
  djhs_lj NUMBER(10),
  ny      VARCHAR2(6)
)
;
comment on table TSGZ_DZBA_DJ_BDQSB
  is '态势感知-单证备案登记户数变动趋势表';
comment on column TSGZ_DZBA_DJ_BDQSB.swjg_dm
  is '税务机关代码';
comment on column TSGZ_DZBA_DJ_BDQSB.xh
  is '序号';
comment on column TSGZ_DZBA_DJ_BDQSB.djhs
  is '登记户数';
comment on column TSGZ_DZBA_DJ_BDQSB.djhs_lj
  is '登记户数(累计)';
comment on column TSGZ_DZBA_DJ_BDQSB.ny
  is '年月';
alter table TSGZ_DZBA_DJ_BDQSB
  add constraint PK_TSGZ_DZBA_DJ_BDQSB primary key (SWJG_DM, XH);

prompt
prompt Creating table TSGZ_DZBA_DJ_HS
prompt ==============================
prompt
create table TSGZ_DZBA_DJ_HS
(
  swjg_dm VARCHAR2(11) not null,
  djhs_wm NUMBER(10),
  djhs_sc NUMBER(10),
  ckqyhs  NUMBER(10)
)
;
comment on table TSGZ_DZBA_DJ_HS
  is '态势感知-单证备案登记表户数';
comment on column TSGZ_DZBA_DJ_HS.swjg_dm
  is '税务机关代码';
comment on column TSGZ_DZBA_DJ_HS.djhs_wm
  is '外贸登记户数';
comment on column TSGZ_DZBA_DJ_HS.djhs_sc
  is '生产登记户数';
comment on column TSGZ_DZBA_DJ_HS.ckqyhs
  is '出口企业户数(取自金三，且是有退免税的活跃户)';
alter table TSGZ_DZBA_DJ_HS
  add constraint PK_TSGZ_DZBA_DJ_HS primary key (SWJG_DM);

prompt
prompt Creating table TSGZ_DZBA_HC_QKTJB
prompt =================================
prompt
create table TSGZ_DZBA_HC_QKTJB
(
  swjg_dm  VARCHAR2(11) not null,
  cnt_all  NUMBER(10),
  cnt_end  NUMBER(10),
  cnt_warn NUMBER(10),
  tse_warn NUMBER(16,2),
  hcblv    NUMBER(6,2)
)
;
comment on table TSGZ_DZBA_HC_QKTJB
  is '态势感知-单证核查-情况统计表';
comment on column TSGZ_DZBA_HC_QKTJB.swjg_dm
  is '税务机关代码';
comment on column TSGZ_DZBA_HC_QKTJB.cnt_all
  is '核查业务笔数';
comment on column TSGZ_DZBA_HC_QKTJB.cnt_end
  is '结束业务笔数';
comment on column TSGZ_DZBA_HC_QKTJB.cnt_warn
  is '问题业务笔数';
comment on column TSGZ_DZBA_HC_QKTJB.tse_warn
  is '问题退免税额';
comment on column TSGZ_DZBA_HC_QKTJB.hcblv
  is '核查比率';
alter table TSGZ_DZBA_HC_QKTJB
  add constraint PK_TSGZ_DZBA_HC_QKTJB primary key (SWJG_DM);

prompt
prompt Creating table TSGZ_QT_BAXX
prompt ===========================
prompt
create table TSGZ_QT_BAXX
(
  swjg_dm    VARCHAR2(11) not null,
  cnt_add    NUMBER(10),
  cnt_modify NUMBER(10),
  cnt_del    NUMBER(10)
)
;
comment on table TSGZ_QT_BAXX
  is '态势感知-备案信息本年累计-新增、变更、注销表';
comment on column TSGZ_QT_BAXX.cnt_add
  is '本年累计新增';
comment on column TSGZ_QT_BAXX.cnt_modify
  is '本年累计变更';
comment on column TSGZ_QT_BAXX.cnt_del
  is '本年累计注销';
alter table TSGZ_QT_BAXX
  add constraint PK_TSGZ_DZBA_BAXX primary key (SWJG_DM);

prompt
prompt Creating table TSGZ_QT_BAXZZX
prompt =============================
prompt
create table TSGZ_QT_BAXZZX
(
  swjg_dm VARCHAR2(11) not null,
  xh      NUMBER(10) not null,
  ny      VARCHAR2(6),
  cnt_add NUMBER(10),
  cnt_del NUMBER(10)
)
;
comment on table TSGZ_QT_BAXZZX
  is '态势感知-出口退税-近6个月新增注销备案企业';
comment on column TSGZ_QT_BAXZZX.swjg_dm
  is '税务机关代码';
comment on column TSGZ_QT_BAXZZX.xh
  is '序号（xh为1-6，1为本月）';
comment on column TSGZ_QT_BAXZZX.ny
  is '年月';
comment on column TSGZ_QT_BAXZZX.cnt_add
  is '新增用户数';
comment on column TSGZ_QT_BAXZZX.cnt_del
  is '注销用户数';
alter table TSGZ_QT_BAXZZX
  add constraint PK_TSGZ_QT_BAXZZX primary key (XH, SWJG_DM);

prompt
prompt Creating table TSGZ_QT_YWBLQKTJB
prompt ================================
prompt
create table TSGZ_QT_YWBLQKTJB
(
  swjg_dm   VARCHAR2(11) not null,
  sbzl_dm   CHAR(4) not null,
  cnt_sb_dy NUMBER(10),
  cnt_bl_dy NUMBER(10),
  cnt_sb_lj NUMBER(10),
  cnt_bl_lj NUMBER(10)
)
;
comment on table TSGZ_QT_YWBLQKTJB
  is '态势感知-其他-业务办理情况统计表';
comment on column TSGZ_QT_YWBLQKTJB.swjg_dm
  is '税务机关代码';
comment on column TSGZ_QT_YWBLQKTJB.sbzl_dm
  is '业务种类代码';
comment on column TSGZ_QT_YWBLQKTJB.cnt_sb_dy
  is '当月申报笔数';
comment on column TSGZ_QT_YWBLQKTJB.cnt_bl_dy
  is '当月办理笔数';
comment on column TSGZ_QT_YWBLQKTJB.cnt_sb_lj
  is '累计申报笔数';
comment on column TSGZ_QT_YWBLQKTJB.cnt_bl_lj
  is '累计办理笔数';
alter table TSGZ_QT_YWBLQKTJB
  add constraint PK_TSGZ_QT_YWBLQKTJB primary key (SWJG_DM, SBZL_DM);

prompt
prompt Creating table TSGZ_SWJG
prompt ========================
prompt
create table TSGZ_SWJG
(
  swjg_dm VARCHAR2(11) not null,
  qybj    CHAR(1) not null,
  crtime  DATE not null
)
;
comment on table TSGZ_SWJG
  is '态势感知-抽取、加工数据的税务机关';
comment on column TSGZ_SWJG.swjg_dm
  is '税务机关代码';
comment on column TSGZ_SWJG.qybj
  is '启用标记(Y:开启  N:关闭)';
comment on column TSGZ_SWJG.crtime
  is '创建时间';
alter table TSGZ_SWJG
  add constraint PK_TSGZ_SWJG primary key (SWJG_DM);

prompt
prompt Creating table TSSH_MDTKB_DEL
prompt =============================
prompt
create table TSSH_MDTKB_DEL
(
  no      VARCHAR2(20),
  ms_id   INTEGER not null,
  item_no VARCHAR2(10) not null,
  year    VARCHAR2(4),
  ym      VARCHAR2(10),
  uuid    VARCHAR2(32),
  lr_user VARCHAR2(32) default ' ',
  lr_date DATE default TO_DATE('1900-1-1','YYYY-MM-DD'),
  op_user VARCHAR2(32) default ' ',
  op_date DATE,
  zf_flag VARCHAR2(1)
)
;
comment on column TSSH_MDTKB_DEL.no
  is '调库通知书号码';

prompt
prompt Creating table TSSH_TSTHS_DEL
prompt =============================
prompt
create table TSSH_TSTHS_DEL
(
  no      VARCHAR2(50) not null,
  year    VARCHAR2(4),
  rq      DATE,
  uuid    VARCHAR2(32) default sys_guid(),
  lr_user VARCHAR2(32) default ' ',
  lr_date DATE default TO_DATE('1900-1-1','YYYY-MM-DD')
)
;
create index IDX_TSTHS_DEL_NO on TSSH_TSTHS_DEL (NO);

prompt
prompt Creating table VIP_MISSING_VOUCHER
prompt ==================================
prompt
create table VIP_MISSING_VOUCHER
(
  id       NUMBER(20) not null,
  nsrdzdah NUMBER(20) not null,
  lx       CHAR(1) not null,
  dzno     VARCHAR2(30) not null,
  dzrq     DATE not null,
  ztbz     CHAR(1) not null,
  crtime   TIMESTAMP(6),
  sctime   TIMESTAMP(6),
  hztime   TIMESTAMP(6),
  ddtime   TIMESTAMP(6),
  yxbz     CHAR(1),
  tsflag   CHAR(1) default 0
)
;
comment on column VIP_MISSING_VOUCHER.ztbz
  is '0录入1已上传（提交）2已汇总9已补发（到达）';
alter table VIP_MISSING_VOUCHER
  add constraint PK_SJBL_ID primary key (ID);

prompt
prompt Creating table YJ_CS_BMD
prompt ========================
prompt
create table YJ_CS_BMD
(
  id       NUMBER(18) not null,
  swjgdm   VARCHAR2(11) not null,
  nsrdzdah NUMBER(20) not null,
  yjcode   VARCHAR2(3) not null,
  objflag  CHAR(1) not null,
  yyms     VARCHAR2(255),
  yxbz     CHAR(1) not null,
  lrr      VARCHAR2(20) not null,
  lrrq     DATE not null,
  xgr      VARCHAR2(20) not null,
  xgrq     DATE not null
)
;
comment on table YJ_CS_BMD
  is '预警白名单';
comment on column YJ_CS_BMD.id
  is '序号，由序列产生';
comment on column YJ_CS_BMD.swjgdm
  is '税务机关代码';
comment on column YJ_CS_BMD.nsrdzdah
  is '纳税人电子档案号';
comment on column YJ_CS_BMD.yjcode
  is '预警代码';
comment on column YJ_CS_BMD.objflag
  is '是否按对象放行，0整体放行 1按白名单子表（预警对象）进行放行';
comment on column YJ_CS_BMD.yyms
  is '原因描述';
comment on column YJ_CS_BMD.yxbz
  is '有效标志 Y/N';
comment on column YJ_CS_BMD.lrr
  is '录入人';
comment on column YJ_CS_BMD.lrrq
  is '录入时间';
comment on column YJ_CS_BMD.xgr
  is '修改人';
comment on column YJ_CS_BMD.xgrq
  is '修改时间';
alter table YJ_CS_BMD
  add constraint PK_YJ_CS_BMD primary key (ID);

prompt
prompt Creating table YJ_CS_BMD_SUB
prompt ============================
prompt
create table YJ_CS_BMD_SUB
(
  bsid       NUMBER(18) not null,
  bmdid      NUMBER(18) not null,
  yj_object  VARCHAR2(30) not null,
  yj_objname VARCHAR2(80),
  yxbz       CHAR(1) not null,
  lrr        VARCHAR2(20) not null,
  lrrq       DATE not null,
  xgr        VARCHAR2(20) not null,
  xgrq       DATE not null
)
;
comment on table YJ_CS_BMD_SUB
  is '预警白名单子表';
comment on column YJ_CS_BMD_SUB.bsid
  is '序号，由序列产生';
comment on column YJ_CS_BMD_SUB.bmdid
  is '关联白名单主表';
comment on column YJ_CS_BMD_SUB.yj_object
  is '预警对象值';
comment on column YJ_CS_BMD_SUB.yj_objname
  is '预警对象名称';
comment on column YJ_CS_BMD_SUB.yxbz
  is '有效标志 Y/N';
comment on column YJ_CS_BMD_SUB.lrr
  is '录入人';
comment on column YJ_CS_BMD_SUB.lrrq
  is '录入时间';
comment on column YJ_CS_BMD_SUB.xgr
  is '修改人';
comment on column YJ_CS_BMD_SUB.xgrq
  is '修改时间';
alter table YJ_CS_BMD_SUB
  add constraint PK_YJ_CS_BMD_SUB primary key (BSID);

prompt
prompt Creating table YJ_CS_MGKA_SC
prompt ============================
prompt
create table YJ_CS_MGKA_SC
(
  kacode VARCHAR2(4) not null,
  kaname VARCHAR2(50),
  sheng  VARCHAR2(50),
  yxbz   CHAR(1) not null
)
;
comment on table YJ_CS_MGKA_SC
  is '省正常周边口岸库';
comment on column YJ_CS_MGKA_SC.kacode
  is '口岸代码';
comment on column YJ_CS_MGKA_SC.kaname
  is '口岸名称';
comment on column YJ_CS_MGKA_SC.sheng
  is '所在省份';
comment on column YJ_CS_MGKA_SC.yxbz
  is '有效标志 Y/N';
alter table YJ_CS_MGKA_SC
  add constraint PK_YJ_CS_MGKA_SC primary key (KACODE);

prompt
prompt Creating table YJ_CS_MGKA_WM
prompt ============================
prompt
create table YJ_CS_MGKA_WM
(
  id       NUMBER(18) not null,
  swjgfw   VARCHAR2(100) not null,
  kacode   VARCHAR2(4) not null,
  kaname   VARCHAR2(50),
  qsrq     DATE,
  jzrq     DATE,
  yyms     VARCHAR2(255),
  lrr      VARCHAR2(20) not null,
  lrrq     DATE not null,
  lrswjgdm VARCHAR2(11) not null,
  yxbz     CHAR(1) not null
)
;
comment on table YJ_CS_MGKA_WM
  is '敏感口岸库';
comment on column YJ_CS_MGKA_WM.id
  is '序号，由序列产生';
comment on column YJ_CS_MGKA_WM.swjgfw
  is '税务机关范围,例如：杭州13301%，绍兴13306%';
comment on column YJ_CS_MGKA_WM.kacode
  is '口岸代码';
comment on column YJ_CS_MGKA_WM.kaname
  is '口岸名称';
comment on column YJ_CS_MGKA_WM.qsrq
  is '预警起始日期';
comment on column YJ_CS_MGKA_WM.jzrq
  is '预警截止日期';
comment on column YJ_CS_MGKA_WM.yyms
  is '原因描述';
comment on column YJ_CS_MGKA_WM.lrrq
  is '录入时间';
comment on column YJ_CS_MGKA_WM.lrswjgdm
  is '录入税务机关代码';
alter table YJ_CS_MGKA_WM
  add constraint PK_YJ_CS_MGKA_WM primary key (ID);

prompt
prompt Creating table YJ_CS_MGSP
prompt =========================
prompt
create table YJ_CS_MGSP
(
  id       NUMBER(18) not null,
  swjgfw   VARCHAR2(100) not null,
  spdm     VARCHAR2(20) not null,
  spmc     VARCHAR2(50),
  qsrq     DATE,
  jzrq     DATE,
  yyms     VARCHAR2(255),
  lrr      VARCHAR2(20) not null,
  lrrq     DATE not null,
  lrswjgdm VARCHAR2(11) not null,
  yxbz     CHAR(1) not null
)
;
comment on table YJ_CS_MGSP
  is '敏感商品库';
comment on column YJ_CS_MGSP.id
  is '序号，由序列产生';
comment on column YJ_CS_MGSP.swjgfw
  is '税务机关范围,例如：杭州13301%，绍兴13306%';
comment on column YJ_CS_MGSP.spdm
  is '商品代码（前4、6位）或完整代码';
comment on column YJ_CS_MGSP.spmc
  is '商品名称';
comment on column YJ_CS_MGSP.qsrq
  is '预警起始日期';
comment on column YJ_CS_MGSP.jzrq
  is '预警截止日期';
comment on column YJ_CS_MGSP.yyms
  is '原因描述';
comment on column YJ_CS_MGSP.lrrq
  is '录入时间';
comment on column YJ_CS_MGSP.lrswjgdm
  is '录入税务机关代码';
comment on column YJ_CS_MGSP.yxbz
  is '有效标志 Y/N';
alter table YJ_CS_MGSP
  add constraint PK_YJ_CS_MGSP primary key (ID);

prompt
prompt Creating table YJ_CS_QSPJDJ_SC
prompt ==============================
prompt
create table YJ_CS_QSPJDJ_SC
(
  spdm   VARCHAR2(20) not null,
  spmc   VARCHAR2(50),
  qnt    NUMBER(16,2) not null,
  amt    NUMBER(16,2) not null,
  dj     NUMBER(16,2),
  qyhs   NUMBER(10),
  sbspmc VARCHAR2(100),
  ywbs   NUMBER(10)
)
;
alter table YJ_CS_QSPJDJ_SC
  add constraint PK_YJ_CS_QSPJDJ_SC_2025 primary key (SPDM);

prompt
prompt Creating table YJ_CS_QSPJDJ_WM
prompt ==============================
prompt
create table YJ_CS_QSPJDJ_WM
(
  spdm   VARCHAR2(20) not null,
  spmc   VARCHAR2(50),
  qnt    NUMBER(16,2) not null,
  amt    NUMBER(16,2) not null,
  dj     NUMBER(16,2),
  qyhs   NUMBER(10),
  sbspmc VARCHAR2(100),
  ywbs   NUMBER(10)
)
;
alter table YJ_CS_QSPJDJ_WM
  add constraint PK_YJ_CS_QSPJDJ_WM_2025 primary key (SPDM);

prompt
prompt Creating table YJ_CS_WMQYMMYLRL
prompt ===============================
prompt
create table YJ_CS_WMQYMMYLRL
(
  swjg_dm    VARCHAR2(11) not null,
  sbqyhs     NUMBER(10),
  sbywbs     NUMBER(10),
  mmylrl_max NUMBER(10,2),
  mmylrl_min NUMBER(10,2),
  mmylrl_mid NUMBER(10,2),
  mmylrl_avg NUMBER(10,2),
  mmylrl_std NUMBER(10,2),
  mylaj      NUMBER(18,2),
  rmblaj     NUMBER(18,2),
  jhcb       NUMBER(18,2),
  mmylrl_yjx NUMBER(10,2)
)
;
comment on table YJ_CS_WMQYMMYLRL
  is '每美元利润率分析模型表（分税务机关）';
comment on column YJ_CS_WMQYMMYLRL.swjg_dm
  is '税务机关代码';
comment on column YJ_CS_WMQYMMYLRL.sbqyhs
  is '申报企业户数';
comment on column YJ_CS_WMQYMMYLRL.sbywbs
  is '申报业务笔数';
comment on column YJ_CS_WMQYMMYLRL.mmylrl_max
  is '最大值';
comment on column YJ_CS_WMQYMMYLRL.mmylrl_min
  is '最小值';
comment on column YJ_CS_WMQYMMYLRL.mmylrl_mid
  is '中位数';
comment on column YJ_CS_WMQYMMYLRL.mmylrl_avg
  is '平均值';
comment on column YJ_CS_WMQYMMYLRL.mmylrl_std
  is '标准差';
comment on column YJ_CS_WMQYMMYLRL.mylaj
  is '合计美元销售额';
comment on column YJ_CS_WMQYMMYLRL.rmblaj
  is '合计人民币销售额';
comment on column YJ_CS_WMQYMMYLRL.jhcb
  is '合计进货成本（计税金额+征税额-退税额）';
comment on column YJ_CS_WMQYMMYLRL.mmylrl_yjx
  is '综合每美元利润率';
alter table YJ_CS_WMQYMMYLRL
  add constraint PK_YJ_CS_WMQYMMYLRL primary key (SWJG_DM);

prompt
prompt Creating table YJ_CS_WMQYMMYLRL_FQY
prompt ===================================
prompt
create table YJ_CS_WMQYMMYLRL_FQY
(
  swjg_dm    VARCHAR2(11) not null,
  djxh       NUMBER(20) not null,
  sbywbs     NUMBER(10),
  mmylrl_max NUMBER(10,2),
  mmylrl_min NUMBER(10,2),
  mmylrl_mid NUMBER(10,2),
  mmylrl_avg NUMBER(10,2),
  mmylrl_std NUMBER(10,2),
  mylaj      NUMBER(18,2),
  rmblaj     NUMBER(18,2),
  jhcb       NUMBER(18,2),
  mmylrl_yjx NUMBER(10,2)
)
;
comment on table YJ_CS_WMQYMMYLRL_FQY
  is '每美元利润率分析模型表（分企业）';
comment on column YJ_CS_WMQYMMYLRL_FQY.swjg_dm
  is '税务机关代码';
comment on column YJ_CS_WMQYMMYLRL_FQY.djxh
  is '登记序号';
comment on column YJ_CS_WMQYMMYLRL_FQY.sbywbs
  is '申报业务笔数';
comment on column YJ_CS_WMQYMMYLRL_FQY.mmylrl_max
  is '最大值';
comment on column YJ_CS_WMQYMMYLRL_FQY.mmylrl_min
  is '最小值';
comment on column YJ_CS_WMQYMMYLRL_FQY.mmylrl_mid
  is '中位数';
comment on column YJ_CS_WMQYMMYLRL_FQY.mmylrl_avg
  is '平均值';
comment on column YJ_CS_WMQYMMYLRL_FQY.mmylrl_std
  is '标准差';
comment on column YJ_CS_WMQYMMYLRL_FQY.mylaj
  is '合计美元销售额';
comment on column YJ_CS_WMQYMMYLRL_FQY.rmblaj
  is '合计人民币销售额';
comment on column YJ_CS_WMQYMMYLRL_FQY.jhcb
  is '合计进货成本（计税金额+征税额-退税额）';
comment on column YJ_CS_WMQYMMYLRL_FQY.mmylrl_yjx
  is '综合每美元利润率';
alter table YJ_CS_WMQYMMYLRL_FQY
  add constraint PK_YJ_CS_WMQYMMYLRL_FQY primary key (SWJG_DM, DJXH);

prompt
prompt Creating table YJ_CS_YCGHQY
prompt ===========================
prompt
create table YJ_CS_YCGHQY
(
  id       NUMBER(18) not null,
  swjgfw   VARCHAR2(100) not null,
  nsrsbh   VARCHAR2(32) not null,
  nsrmc    VARCHAR2(400),
  zgswjgmc VARCHAR2(50),
  qsrq     DATE,
  jzrq     DATE,
  yyms     VARCHAR2(255),
  lrr      VARCHAR2(20) not null,
  lrrq     DATE not null,
  lrswjgdm VARCHAR2(11) not null,
  yxbz     CHAR(1) not null
)
;
comment on table YJ_CS_YCGHQY
  is '异常供货企业库';
comment on column YJ_CS_YCGHQY.id
  is '序号，由序列产生';
comment on column YJ_CS_YCGHQY.swjgfw
  is '税务机关范围,例如：杭州13301%，绍兴13306%';
comment on column YJ_CS_YCGHQY.nsrsbh
  is '供货企业识别号';
comment on column YJ_CS_YCGHQY.nsrmc
  is '供货企业名称';
comment on column YJ_CS_YCGHQY.zgswjgmc
  is '供货企业主管税务机关名';
comment on column YJ_CS_YCGHQY.qsrq
  is '预警起始日期';
comment on column YJ_CS_YCGHQY.jzrq
  is '预警截止日期';
comment on column YJ_CS_YCGHQY.yyms
  is '原因描述';
comment on column YJ_CS_YCGHQY.lrrq
  is '录入时间';
comment on column YJ_CS_YCGHQY.lrswjgdm
  is '录入税务机关代码';
comment on column YJ_CS_YCGHQY.yxbz
  is '有效标志 Y/N';
alter table YJ_CS_YCGHQY
  add constraint PK_YJ_CS_YCGHQY primary key (ID);

prompt
prompt Creating table YJ_CS_YCHD
prompt =========================
prompt
create table YJ_CS_YCHD
(
  fhbh     VARCHAR2(20) not null,
  fhrq     DATE,
  nsrsbh   VARCHAR2(20) not null,
  nsrmc    VARCHAR2(80),
  zgswjgmc VARCHAR2(50),
  fhnr     VARCHAR2(1000),
  tbsj     DATE not null,
  yxbz     CHAR(1) not null
)
;
comment on table YJ_CS_YCHD
  is '异常函调信息库';
comment on column YJ_CS_YCHD.fhbh
  is '复函编号';
comment on column YJ_CS_YCHD.fhrq
  is '复函日期';
comment on column YJ_CS_YCHD.nsrsbh
  is '纳税人识别号';
comment on column YJ_CS_YCHD.nsrmc
  is '纳税人名称';
comment on column YJ_CS_YCHD.zgswjgmc
  is '纳税人主管税务机关名';
comment on column YJ_CS_YCHD.fhnr
  is '复函内容';
comment on column YJ_CS_YCHD.tbsj
  is '同步时间';
comment on column YJ_CS_YCHD.yxbz
  is '有效标志 Y/N';
alter table YJ_CS_YCHD
  add constraint PK_YJ_CS_YCHD primary key (FHBH);

prompt
prompt Creating table YJ_CS_YCHD_JS
prompt ============================
prompt
create table YJ_CS_YCHD_JS
(
  fhxxbuuid    VARCHAR2(32) not null,
  wsbh         VARCHAR2(150),
  fahqfrq      DATE,
  fahdswjg_dm  CHAR(11),
  fahdswjgmc   VARCHAR2(300),
  ghqynsrsbh   VARCHAR2(20),
  ghfqymc      VARCHAR2(300),
  ghfzgswjg_dm CHAR(11),
  ghfzgswjgmc  VARCHAR2(300),
  ghqynsrsbh_1 VARCHAR2(20),
  ghfqymc_1    VARCHAR2(300),
  fpfs         NUMBER(16,4),
  jehj         NUMBER(18,2),
  sehj         NUMBER(18,2),
  jshj         NUMBER(18,2),
  fuhxxbuuid   VARCHAR2(32),
  hshbh        VARCHAR2(50),
  fuhqfrq      DATE,
  fuhlx_dm     CHAR(1),
  fuhclrq      DATE,
  fuhclyj_dm   CHAR(1),
  hdjglx       CHAR(1),
  crtime       DATE default SYSDATE
)
;
comment on table YJ_CS_YCHD_JS
  is '金三异常函调信息';
comment on column YJ_CS_YCHD_JS.fhxxbuuid
  is '发函信息表UUID';
comment on column YJ_CS_YCHD_JS.wsbh
  is '文书编号';
comment on column YJ_CS_YCHD_JS.fahqfrq
  is '发函签发日期';
comment on column YJ_CS_YCHD_JS.fahdswjg_dm
  is '发函地税务机关代码';
comment on column YJ_CS_YCHD_JS.fahdswjgmc
  is '发函地税务机关名称';
comment on column YJ_CS_YCHD_JS.ghqynsrsbh
  is '购货方企业纳税人识别号';
comment on column YJ_CS_YCHD_JS.ghfqymc
  is '购货方企业名称';
comment on column YJ_CS_YCHD_JS.ghfzgswjg_dm
  is '供货方主管税务机关代码';
comment on column YJ_CS_YCHD_JS.ghfzgswjgmc
  is '供货方主管税务机关名称';
comment on column YJ_CS_YCHD_JS.ghqynsrsbh_1
  is '供货方企业纳税人识别号';
comment on column YJ_CS_YCHD_JS.ghfqymc_1
  is '供货方企业名称';
comment on column YJ_CS_YCHD_JS.fpfs
  is '发票份数';
comment on column YJ_CS_YCHD_JS.jehj
  is '金额合计';
comment on column YJ_CS_YCHD_JS.sehj
  is '税额合计';
comment on column YJ_CS_YCHD_JS.jshj
  is '价税合计';
comment on column YJ_CS_YCHD_JS.fuhxxbuuid
  is '复函信息表UUID';
comment on column YJ_CS_YCHD_JS.hshbh
  is '核实函编号';
comment on column YJ_CS_YCHD_JS.fuhqfrq
  is '复函签发日期';
comment on column YJ_CS_YCHD_JS.fuhlx_dm
  is '复函类型代码';
comment on column YJ_CS_YCHD_JS.fuhclrq
  is '复函处理日期';
comment on column YJ_CS_YCHD_JS.fuhclyj_dm
  is '复函处理意见代码';
comment on column YJ_CS_YCHD_JS.hdjglx
  is '函调结果类型1未回函2回函异常未处理3不予退税处理';
comment on column YJ_CS_YCHD_JS.crtime
  is '数据扫描日期';
create index IDX_YJ_CS_YCHD_JS_1 on YJ_CS_YCHD_JS (FAHDSWJG_DM, GHQYNSRSBH_1, GHQYNSRSBH);
alter table YJ_CS_YCHD_JS
  add constraint PK_YJ_CS_YCHD_JS primary key (FHXXBUUID);

prompt
prompt Creating table YJ_DATA_HYDBYZ
prompt =============================
prompt
create table YJ_DATA_HYDBYZ
(
  tbpc      NUMBER(18),
  id        NUMBER(18) not null,
  sbid      NUMBER(18) not null,
  nsrdzdah  NUMBER(20) not null,
  cj_date   DATE not null,
  yjcode    VARCHAR2(3) not null,
  zbcode    VARCHAR2(5),
  yj_object VARCHAR2(40),
  yj_count  NUMBER(8),
  yj_amt    NUMBER(16,2),
  yj_tax    NUMBER(16,2),
  yj_record VARCHAR2(30),
  yj_msg    VARCHAR2(1000) not null,
  cl_date   DATE,
  cl_flag   CHAR(1),
  cl_user   VARCHAR2(30),
  cl_msg    VARCHAR2(255),
  bz        VARCHAR2(255),
  sbym      VARCHAR2(6),
  score     NUMBER(8),
  swflag    CHAR(1),
  qyflag    CHAR(1),
  bmdflag   CHAR(1),
  lcslid    CHAR(32),
  djxh      NUMBER(20)
)
;
comment on table YJ_DATA_HYDBYZ
  is '预警信息记录表';
comment on column YJ_DATA_HYDBYZ.tbpc
  is '同步批次';
comment on column YJ_DATA_HYDBYZ.id
  is '序号，由序列产生';
comment on column YJ_DATA_HYDBYZ.sbid
  is '申报ID';
comment on column YJ_DATA_HYDBYZ.nsrdzdah
  is '纳税人电子档案号';
comment on column YJ_DATA_HYDBYZ.cj_date
  is '创建时间';
comment on column YJ_DATA_HYDBYZ.yjcode
  is '预警代码';
comment on column YJ_DATA_HYDBYZ.zbcode
  is '预警指标';
comment on column YJ_DATA_HYDBYZ.yj_object
  is '预警对象值';
comment on column YJ_DATA_HYDBYZ.yj_count
  is '预警笔数';
comment on column YJ_DATA_HYDBYZ.yj_amt
  is '预警金额';
comment on column YJ_DATA_HYDBYZ.yj_tax
  is '预警税额';
comment on column YJ_DATA_HYDBYZ.yj_record
  is '关联号';
comment on column YJ_DATA_HYDBYZ.yj_msg
  is '预警描述';
comment on column YJ_DATA_HYDBYZ.cl_date
  is '处理时间';
comment on column YJ_DATA_HYDBYZ.cl_flag
  is '处理标志';
comment on column YJ_DATA_HYDBYZ.cl_user
  is '处理人';
comment on column YJ_DATA_HYDBYZ.cl_msg
  is '处理意见';
comment on column YJ_DATA_HYDBYZ.bz
  is '备注';
comment on column YJ_DATA_HYDBYZ.sbym
  is '实际申报年月';
comment on column YJ_DATA_HYDBYZ.score
  is '评分';
comment on column YJ_DATA_HYDBYZ.swflag
  is '税务标志 1/0 （1展示给税务）';
comment on column YJ_DATA_HYDBYZ.qyflag
  is '企业标志 1/0 （1展示给企业）';
comment on column YJ_DATA_HYDBYZ.bmdflag
  is '白名单标志 0正常预警 1白名单 2预警关闭';
comment on column YJ_DATA_HYDBYZ.lcslid
  is 'LCSLID（根据业务事项取ZLCLCSLID=LCSLID的ZLCLCSLID)';
comment on column YJ_DATA_HYDBYZ.djxh
  is '登记序号';
create index IDX_YJ_DATA_HYDBYZ_CJSJ on YJ_DATA_HYDBYZ (CJ_DATE);
create index IDX_YJ_DATA_HYDBYZ_NSR on YJ_DATA_HYDBYZ (NSRDZDAH);
create index IDX_YJ_DATA_HYDBYZ_NYZO on YJ_DATA_HYDBYZ (SBID, NSRDZDAH, YJCODE, ZBCODE, YJ_OBJECT);
create index IDX_YJ_DATA_HYDBYZ_NYZR on YJ_DATA_HYDBYZ (SBID, NSRDZDAH, YJCODE, ZBCODE, YJ_RECORD);
alter table YJ_DATA_HYDBYZ
  add constraint PK_YJ_DATA_HYDBYZ primary key (ID, SBID);

prompt
prompt Creating table YJ_DATA_SCORE
prompt ============================
prompt
create table YJ_DATA_SCORE
(
  nsrdzdah NUMBER(20) not null,
  score    NUMBER(8) not null,
  yj_level CHAR(1),
  pgid     NUMBER(18)
)
;
comment on table YJ_DATA_SCORE
  is '预警评分总表';
comment on column YJ_DATA_SCORE.nsrdzdah
  is '纳税人电子档案号';
comment on column YJ_DATA_SCORE.score
  is '纳税人当前总评分';
comment on column YJ_DATA_SCORE.yj_level
  is '预警等级，0无预警 1蓝色预警 2红色预警';
comment on column YJ_DATA_SCORE.pgid
  is '评估ID，关联评估岗处理记录表';
alter table YJ_DATA_SCORE
  add constraint PK_YJ_DATA_SCORE primary key (NSRDZDAH);

prompt
prompt Creating table YJ_DATA_TSFPQYYHZ
prompt ================================
prompt
create table YJ_DATA_TSFPQYYHZ
(
  djxh     NUMBER(20) not null,
  ny       CHAR(6) not null,
  dfnsrsbh VARCHAR2(20) not null,
  dfnsrmc  VARCHAR2(100),
  fps      NUMBER(10),
  je       NUMBER(18,2),
  se       NUMBER(18,2),
  sjgxsj   DATE
)
;
comment on table YJ_DATA_TSFPQYYHZ
  is '退税发票企业月汇总表（数据来源金三出口退税发票）';
comment on column YJ_DATA_TSFPQYYHZ.djxh
  is '登记序号';
comment on column YJ_DATA_TSFPQYYHZ.ny
  is '年月';
comment on column YJ_DATA_TSFPQYYHZ.dfnsrsbh
  is '对方税号';
comment on column YJ_DATA_TSFPQYYHZ.dfnsrmc
  is '对方名称';
comment on column YJ_DATA_TSFPQYYHZ.fps
  is '发票份数';
comment on column YJ_DATA_TSFPQYYHZ.je
  is '金额合计';
comment on column YJ_DATA_TSFPQYYHZ.se
  is '税额合计';
comment on column YJ_DATA_TSFPQYYHZ.sjgxsj
  is '数据更新时间';
alter table YJ_DATA_TSFPQYYHZ
  add constraint PK_YJ_DATA_TSFPQYYHZ primary key (DJXH, NY, DFNSRSBH);

prompt
prompt Creating table YJ_DATA_YJXX
prompt ===========================
prompt
create table YJ_DATA_YJXX
(
  tbpc      NUMBER(18),
  id        NUMBER(18) not null,
  sbid      NUMBER(18) not null,
  nsrdzdah  NUMBER(20) not null,
  cj_date   DATE not null,
  yjcode    VARCHAR2(3) not null,
  zbcode    VARCHAR2(5),
  yj_object VARCHAR2(40),
  yj_count  NUMBER(8),
  yj_amt    NUMBER(16,2),
  yj_tax    NUMBER(16,2),
  yj_record VARCHAR2(30),
  yj_msg    VARCHAR2(1000) not null,
  cl_date   DATE,
  cl_flag   CHAR(1),
  cl_user   VARCHAR2(30),
  cl_msg    VARCHAR2(255),
  bz        VARCHAR2(255),
  sbym      VARCHAR2(6),
  score     NUMBER(8),
  swflag    CHAR(1),
  qyflag    CHAR(1),
  bmdflag   CHAR(1)
)
;
comment on table YJ_DATA_YJXX
  is '预警信息记录表';
comment on column YJ_DATA_YJXX.tbpc
  is '同步批次';
comment on column YJ_DATA_YJXX.id
  is '序号，由序列产生';
comment on column YJ_DATA_YJXX.sbid
  is '申报ID';
comment on column YJ_DATA_YJXX.nsrdzdah
  is '纳税人电子档案号';
comment on column YJ_DATA_YJXX.cj_date
  is '创建时间';
comment on column YJ_DATA_YJXX.yjcode
  is '预警代码';
comment on column YJ_DATA_YJXX.zbcode
  is '预警指标';
comment on column YJ_DATA_YJXX.yj_object
  is '预警对象值';
comment on column YJ_DATA_YJXX.yj_count
  is '预警笔数';
comment on column YJ_DATA_YJXX.yj_amt
  is '预警金额';
comment on column YJ_DATA_YJXX.yj_tax
  is '预警税额';
comment on column YJ_DATA_YJXX.yj_record
  is '关联号';
comment on column YJ_DATA_YJXX.yj_msg
  is '预警描述';
comment on column YJ_DATA_YJXX.cl_date
  is '处理时间';
comment on column YJ_DATA_YJXX.cl_flag
  is '处理标志';
comment on column YJ_DATA_YJXX.cl_user
  is '处理人';
comment on column YJ_DATA_YJXX.cl_msg
  is '处理意见';
comment on column YJ_DATA_YJXX.bz
  is '备注';
comment on column YJ_DATA_YJXX.sbym
  is '实际申报年月';
comment on column YJ_DATA_YJXX.score
  is '评分';
comment on column YJ_DATA_YJXX.swflag
  is '税务标志 1/0 （1展示给税务）';
comment on column YJ_DATA_YJXX.qyflag
  is '企业标志 1/0 （1展示给企业）';
comment on column YJ_DATA_YJXX.bmdflag
  is '白名单标志 0正常预警 1白名单 2预警关闭';
create index IDX_YJ_DATA_YJXX_CJSJ on YJ_DATA_YJXX (CJ_DATE)
  nologging;
create index IDX_YJ_DATA_YJXX_NSR on YJ_DATA_YJXX (NSRDZDAH)
  nologging;
create index IDX_YJ_DATA_YJXX_NYZO on YJ_DATA_YJXX (SBID, NSRDZDAH, YJCODE, ZBCODE, YJ_OBJECT)
  nologging;
create index IDX_YJ_DATA_YJXX_NYZR on YJ_DATA_YJXX (SBID, NSRDZDAH, YJCODE, ZBCODE, YJ_RECORD)
  nologging;
create index IDX_YJ_DATA_YJXX_YJZB on YJ_DATA_YJXX (ZBCODE)
  nologging;
alter table YJ_DATA_YJXX
  add constraint PK_YJ_DATA_YJXX primary key (ID, SBID);

prompt
prompt Creating table YJ_DIC_CODE
prompt ==========================
prompt
create table YJ_DIC_CODE
(
  yjcode   VARCHAR2(3) not null,
  yjname   VARCHAR2(50) not null,
  yjinfo   VARCHAR2(1000) not null,
  sysw     CHAR(1) not null,
  syqy     CHAR(1) not null,
  zxflag   CHAR(1) not null,
  yjobject VARCHAR2(50),
  yxbz     CHAR(1) not null,
  yjlx     CHAR(1) not null,
  tsywlx   INTEGER,
  swjg_fw  VARCHAR2(100)
)
;
comment on table YJ_DIC_CODE
  is '预警代码表';
comment on column YJ_DIC_CODE.yjcode
  is '预警代码';
comment on column YJ_DIC_CODE.yjname
  is '预警名称';
comment on column YJ_DIC_CODE.yjinfo
  is '预警提示信息模版';
comment on column YJ_DIC_CODE.sysw
  is '适用税务 Y/N';
comment on column YJ_DIC_CODE.syqy
  is '适用企业 Y/N';
comment on column YJ_DIC_CODE.zxflag
  is '能否自选 Y/N（注仅全省通用的指标，允许自选，非全省通用指标默认设置N）';
comment on column YJ_DIC_CODE.yjobject
  is '预警对象名';
comment on column YJ_DIC_CODE.yxbz
  is '有效标准 Y/N';
comment on column YJ_DIC_CODE.yjlx
  is '预警类型 1综合预警 2按单预警 3汇总预警';
comment on column YJ_DIC_CODE.tsywlx
  is '退税业务类型 1生产 2外贸 4外综服 8周边业务';
comment on column YJ_DIC_CODE.swjg_fw
  is '适用税务机关范围集合（按税务机关代码有效位数省局3位地市级5位区县局7位）';
alter table YJ_DIC_CODE
  add constraint PK_YJ_DIC_CODE primary key (YJCODE);

prompt
prompt Creating table YJ_DIC_HGHYD
prompt ===========================
prompt
create table YJ_DIC_HGHYD
(
  id       NUMBER(18) not null,
  hghyd_dm VARCHAR2(5) not null,
  hghyd_mc VARCHAR2(50) not null,
  xzqh_dm  VARCHAR2(5),
  xzqh_mc  VARCHAR2(50),
  qybz     CHAR(1)
)
;

prompt
prompt Creating table YJ_DIC_SWJG
prompt ==========================
prompt
create table YJ_DIC_SWJG
(
  swjgdm VARCHAR2(11) not null,
  yjcode VARCHAR2(3) not null,
  qyflag CHAR(1) not null
)
;
comment on table YJ_DIC_SWJG
  is '预警代码地市机关开启关闭表';
comment on column YJ_DIC_SWJG.swjgdm
  is '税务机关代码';
comment on column YJ_DIC_SWJG.yjcode
  is '预警代码';
comment on column YJ_DIC_SWJG.qyflag
  is '启用标志 1/0';
alter table YJ_DIC_SWJG
  add constraint PK_YJ_DIC_SWJG primary key (SWJGDM, YJCODE);

prompt
prompt Creating table YJ_DIC_YJZB
prompt ==========================
prompt
create table YJ_DIC_YJZB
(
  yjcode VARCHAR2(3) not null,
  yjname VARCHAR2(50),
  zbcode VARCHAR2(5) not null,
  zbname VARCHAR2(80) not null,
  jslx   CHAR(1),
  p1name VARCHAR2(80),
  p1val  NUMBER(16,2),
  p2name VARCHAR2(80),
  p2val  NUMBER(16,2),
  score  NUMBER(8),
  yjmsg  VARCHAR2(500),
  note   VARCHAR2(255),
  wsql   VARCHAR2(4000),
  sysw   CHAR(1),
  syqy   CHAR(1),
  p3name VARCHAR2(80),
  p3val  NUMBER(16,2),
  p4name VARCHAR2(80),
  p4val  NUMBER(16,2)
)
;
comment on table YJ_DIC_YJZB
  is '预警指标字典表';
comment on column YJ_DIC_YJZB.yjcode
  is '预警代码';
comment on column YJ_DIC_YJZB.yjname
  is '预警名称（冗余，为了看着方便）';
comment on column YJ_DIC_YJZB.zbcode
  is '指标代码 前3位表示预警代码';
comment on column YJ_DIC_YJZB.zbname
  is '指标名称';
comment on column YJ_DIC_YJZB.jslx
  is '计算类型 1按报关单 2按批次汇总 3六个月汇总';
comment on column YJ_DIC_YJZB.p1name
  is '参数1名称';
comment on column YJ_DIC_YJZB.p1val
  is '参数1阀值';
comment on column YJ_DIC_YJZB.p2name
  is '参数2名称';
comment on column YJ_DIC_YJZB.p2val
  is '参数2阀值';
comment on column YJ_DIC_YJZB.score
  is '评分';
comment on column YJ_DIC_YJZB.note
  is '备注';
comment on column YJ_DIC_YJZB.wsql
  is '伪SQL代码';
comment on column YJ_DIC_YJZB.sysw
  is '是否适用税务 1/0';
comment on column YJ_DIC_YJZB.syqy
  is '是否适用企业 1/0';
comment on column YJ_DIC_YJZB.p3name
  is '参数3名称';
comment on column YJ_DIC_YJZB.p3val
  is '参数3阀值';
comment on column YJ_DIC_YJZB.p4name
  is '参数4名称';
comment on column YJ_DIC_YJZB.p4val
  is '参数4阀值';
alter table YJ_DIC_YJZB
  add constraint PK_YJ_DIC_YJZB primary key (ZBCODE);

prompt
prompt Creating table YJ_DIC_YJZBSWJG
prompt ==============================
prompt
create table YJ_DIC_YJZBSWJG
(
  swjgdm VARCHAR2(11) not null,
  zbcode VARCHAR2(5) not null,
  p1val  NUMBER(16,2),
  p2val  NUMBER(16,2),
  score  NUMBER(8),
  yxbz   CHAR(1) not null,
  p3val  NUMBER(16,2),
  p4val  NUMBER(16,2)
)
;
comment on table YJ_DIC_YJZBSWJG
  is '预警指标地市机关自定义参数表';
comment on column YJ_DIC_YJZBSWJG.swjgdm
  is '税务机关代码(地市机关)';
comment on column YJ_DIC_YJZBSWJG.zbcode
  is '指标代码';
comment on column YJ_DIC_YJZBSWJG.p1val
  is '参数1阀值';
comment on column YJ_DIC_YJZBSWJG.p2val
  is '参数2阀值';
comment on column YJ_DIC_YJZBSWJG.score
  is '评分';
comment on column YJ_DIC_YJZBSWJG.yxbz
  is '有效标志 Y/N';
comment on column YJ_DIC_YJZBSWJG.p3val
  is '参数3阀值';
comment on column YJ_DIC_YJZBSWJG.p4val
  is '参数4阀值';
alter table YJ_DIC_YJZBSWJG
  add constraint PK_YJ_DIC_YJZBSWJG primary key (SWJGDM, ZBCODE);

prompt
prompt Creating table YJ_SBXX_HZ
prompt =========================
prompt
create table YJ_SBXX_HZ
(
  id       NUMBER(18) not null,
  nsrdzdah NUMBER(20) not null,
  sbywb_dm VARCHAR2(20) not null,
  sssq     CHAR(6),
  sbpc     NUMBER(9),
  sbrq     DATE,
  sbzt_dm  CHAR(2) not null,
  lzhj     VARCHAR2(50),
  fkrq     DATE,
  fkxx     VARCHAR2(255),
  bz       VARCHAR2(255),
  cjrq     DATE not null,
  xgrq     DATE not null,
  tqbz     VARCHAR2(50),
  tqsj     DATE,
  tqcs     NUMBER(9) default 0,
  sbyy     VARCHAR2(1000),
  yxj      NUMBER(9) default 0,
  sbsj     DATE,
  tbsj     DATE,
  lcslid   VARCHAR2(50),
  tbcs     NUMBER(9) default 0,
  sbzl_dm  VARCHAR2(10),
  sbtype   VARCHAR2(10),
  ysbz     VARCHAR2(40),
  ystqsj   DATE,
  yswcsj   DATE,
  ystqcs   NUMBER(9) default 0,
  bwzy     VARCHAR2(40),
  ysjg     CHAR(1),
  sbr      VARCHAR2(20),
  sbfs     CHAR(1),
  sbcs     NUMBER(9) default 0,
  zzsbb    CHAR(1),
  uuid     VARCHAR2(50)
)
;
comment on column YJ_SBXX_HZ.id
  is '主键，序列号';
comment on column YJ_SBXX_HZ.nsrdzdah
  is '纳税人电子档案号';
comment on column YJ_SBXX_HZ.sbywb_dm
  is '申报业务表代码（A0?0?0??）';
comment on column YJ_SBXX_HZ.sssq
  is '所属时期，YYYYMM';
comment on column YJ_SBXX_HZ.sbpc
  is '申报批次';
comment on column YJ_SBXX_HZ.sbrq
  is '申报日期';
comment on column YJ_SBXX_HZ.sbzt_dm
  is '初始：20，无预警信息：OK，有预警信息：YJ，流程已发放：30，流程已作废：40';
comment on column YJ_SBXX_HZ.lzhj
  is '流转环节';
comment on column YJ_SBXX_HZ.fkrq
  is '反馈日期';
comment on column YJ_SBXX_HZ.fkxx
  is '反馈信息';
comment on column YJ_SBXX_HZ.bz
  is '备注';
comment on column YJ_SBXX_HZ.cjrq
  is '创建日期';
comment on column YJ_SBXX_HZ.xgrq
  is '修改日期';
comment on column YJ_SBXX_HZ.tqbz
  is '提取标志';
comment on column YJ_SBXX_HZ.tqsj
  is '提取时间';
comment on column YJ_SBXX_HZ.tqcs
  is '提取次数';
comment on column YJ_SBXX_HZ.sbyy
  is '失败原因';
comment on column YJ_SBXX_HZ.yxj
  is '优先级';
comment on column YJ_SBXX_HZ.sbsj
  is '申报时间';
comment on column YJ_SBXX_HZ.tbsj
  is '同步时间';
comment on column YJ_SBXX_HZ.lcslid
  is '流程实例ID';
comment on column YJ_SBXX_HZ.tbcs
  is '同步次数';
comment on column YJ_SBXX_HZ.sbzl_dm
  is '申报种类代码 ';
comment on column YJ_SBXX_HZ.sbtype
  is '申报种类 正式申报：ZSSB    预申报：YSB';
comment on column YJ_SBXX_HZ.ysbz
  is '预审标记';
comment on column YJ_SBXX_HZ.ystqsj
  is '预审提取时间';
comment on column YJ_SBXX_HZ.yswcsj
  is '预审完成时间';
comment on column YJ_SBXX_HZ.ystqcs
  is '预审提取次数';
comment on column YJ_SBXX_HZ.bwzy
  is '报文摘要';
comment on column YJ_SBXX_HZ.ysjg
  is '预审结果   0:无疑点；1：只有可挑过疑点 ;2：有不可挑过疑点';
comment on column YJ_SBXX_HZ.sbr
  is '申报人（webservice，czry_dm）';
comment on column YJ_SBXX_HZ.sbfs
  is '申报方式（0或空-网报接口 1-文件读入）';
comment on column YJ_SBXX_HZ.sbcs
  is '申报次数，记录云平台正式申报提交次数，每正式申报同步一次加1';
comment on column YJ_SBXX_HZ.zzsbb
  is '增值税报表是否已申报 0：金三系统中已经全申报   1：审核系统中已经全申报    空：没有全申报';
create index IDX_SB_SBXX_HZ_SBZT on YJ_SBXX_HZ (SBZT_DM);
create index IX_SB_SBXX_HZ_NSS on YJ_SBXX_HZ (NSRDZDAH, SSSQ, SBYWB_DM);
create unique index UQ_YJ_SBXX_HZ_LC on YJ_SBXX_HZ (LCSLID);
alter table YJ_SBXX_HZ
  add constraint PK_SB_SBXX_HZ primary key (ID);

prompt
prompt Creating table ZB_CKTSJH
prompt ========================
prompt
create table ZB_CKTSJH
(
  swjg_dm     VARCHAR2(11) not null,
  ny          CHAR(6) not null,
  byxdjhe     NUMBER(16,4),
  byxdjhe_y   NUMBER(16,4),
  syjzjhe     NUMBER(16,4),
  syjzjhe_y   NUMBER(16,4),
  byzhcktse   NUMBER(16,4),
  byzhcktse_y NUMBER(16,4),
  byjhze      NUMBER(16,4),
  byjhze_y    NUMBER(16,4),
  byybltse    NUMBER(16,4),
  byybltse_y  NUMBER(16,4),
  byjhye      NUMBER(16,4),
  byjhye_y    NUMBER(16,4),
  byjhwcl     NUMBER(16,4),
  byjhwcl_y   NUMBER(16,4),
  bnljbltse   NUMBER(16,4),
  bnljbltse_y NUMBER(16,4),
  bnljyzhse   NUMBER(16,4),
  bnljyzhse_y NUMBER(16,4)
)
;
comment on column ZB_CKTSJH.ny
  is '年月';
comment on column ZB_CKTSJH.byxdjhe
  is '本月下达计划额';
comment on column ZB_CKTSJH.syjzjhe
  is '上月结转计划额';
comment on column ZB_CKTSJH.byzhcktse
  is '本月追回出口退税款';
comment on column ZB_CKTSJH.byjhze
  is '本月计划总额 = 上三栏之和';
comment on column ZB_CKTSJH.byybltse
  is '本月已办理退税额';
comment on column ZB_CKTSJH.byjhye
  is '退税计划余额= 本月计划总额 - 本月已办理退税额';
comment on column ZB_CKTSJH.byjhwcl
  is '计划完成率= 本月已办理退税额/本月计划总额';
comment on column ZB_CKTSJH.bnljbltse
  is '本年累计办理退税（上月累计+本月已办理退税额），初值为上月累计';
comment on column ZB_CKTSJH.bnljyzhse
  is '本年累计已退税款追回';
alter table ZB_CKTSJH
  add primary key (SWJG_DM, NY);

prompt
prompt Creating table ZB_TSJHXD_WH
prompt ===========================
prompt
create table ZB_TSJHXD_WH
(
  whqx    VARCHAR2(11) not null,
  tszb_yn VARCHAR2(6) not null,
  tszb_pc VARCHAR2(2) not null,
  zbjg_dm VARCHAR2(11) not null,
  tszbje  NUMBER(16,2) not null,
  lrr_dm  VARCHAR2(20),
  lrsj    DATE,
  xgr_dm  VARCHAR2(20),
  xgsj    DATE,
  sxbz    CHAR(1) default 0
)
;
comment on table ZB_TSJHXD_WH
  is '退税指标计划-追加维护';
comment on column ZB_TSJHXD_WH.whqx
  is '维护权限';
comment on column ZB_TSJHXD_WH.tszb_yn
  is '年月';
comment on column ZB_TSJHXD_WH.tszb_pc
  is '批次';
comment on column ZB_TSJHXD_WH.zbjg_dm
  is '指标机关代码';
comment on column ZB_TSJHXD_WH.tszbje
  is '退税指标金额';
comment on column ZB_TSJHXD_WH.lrr_dm
  is '录入人';
comment on column ZB_TSJHXD_WH.lrsj
  is '录入时间';
comment on column ZB_TSJHXD_WH.xgr_dm
  is '修改人';
comment on column ZB_TSJHXD_WH.xgsj
  is '修改时间';
comment on column ZB_TSJHXD_WH.sxbz
  is '生效标志   0尚未生效  1已生效';
alter table ZB_TSJHXD_WH
  add primary key (WHQX, TSZB_YN, TSZB_PC, ZBJG_DM);

prompt
prompt Creating table ZB_TSJHZX_HZB
prompt ============================
prompt
create table ZB_TSJHZX_HZB
(
  tszb_yn   VARCHAR2(6) not null,
  zbjg_dm   VARCHAR2(11) not null,
  byxdjhe   NUMBER(16,2) default 0 not null,
  syjzjhe   NUMBER(16,2) default 0 not null,
  byzhtse   NUMBER(16,2) default 0 not null,
  byjhze    NUMBER(16,2) default 0 not null,
  byybltse  NUMBER(16,2) default 0 not null,
  byjhye    NUMBER(16,2) default 0 not null,
  jhwcl     NUMBER(6,2) default 0 not null,
  bnljbltse NUMBER(16,2) default 0 not null,
  bnljzhtse NUMBER(16,2) default 0 not null,
  bnljxdjhe NUMBER(16,2) default 0 not null,
  bnljjhwcl NUMBER(6,2) default 0 not null,
  xgsj      DATE default sysdate,
  lrsj      DATE default sysdate
)
;
comment on column ZB_TSJHZX_HZB.tszb_yn
  is '年月';
comment on column ZB_TSJHZX_HZB.zbjg_dm
  is '指标机关';
comment on column ZB_TSJHZX_HZB.byxdjhe
  is '本月下达计划额';
comment on column ZB_TSJHZX_HZB.syjzjhe
  is '上月结转计划额';
comment on column ZB_TSJHZX_HZB.byzhtse
  is '本月追回退税额';
comment on column ZB_TSJHZX_HZB.byjhze
  is '本月计划总额';
comment on column ZB_TSJHZX_HZB.byybltse
  is '本月已办理退税额';
comment on column ZB_TSJHZX_HZB.byjhye
  is '本月计划余额';
comment on column ZB_TSJHZX_HZB.jhwcl
  is '计划完成率';
comment on column ZB_TSJHZX_HZB.bnljbltse
  is '期初累计办理退税额';
comment on column ZB_TSJHZX_HZB.bnljzhtse
  is '期初累计追回退税额';
comment on column ZB_TSJHZX_HZB.bnljxdjhe
  is '期初累计下达计划额';
comment on column ZB_TSJHZX_HZB.bnljjhwcl
  is '本年累计计划完成率';
comment on column ZB_TSJHZX_HZB.xgsj
  is '修改时间';
comment on column ZB_TSJHZX_HZB.lrsj
  is '创建时间';
alter table ZB_TSJHZX_HZB
  add primary key (TSZB_YN, ZBJG_DM);

prompt
prompt Creating table ZB_TSJHZX_HZB_13301TZ
prompt ====================================
prompt
create table ZB_TSJHZX_HZB_13301TZ
(
  tszb_yn   VARCHAR2(6) not null,
  zbjg_dm   VARCHAR2(11) not null,
  byxdjhe   NUMBER(16,2) not null,
  syjzjhe   NUMBER(16,2) not null,
  byzhtse   NUMBER(16,2) not null,
  byjhze    NUMBER(16,2) not null,
  byybltse  NUMBER(16,2) not null,
  byjhye    NUMBER(16,2) not null,
  jhwcl     NUMBER(6,2) not null,
  bnljbltse NUMBER(16,2) not null,
  bnljzhtse NUMBER(16,2) not null,
  bnljxdjhe NUMBER(16,2) not null,
  bnljjhwcl NUMBER(6,2) not null,
  xgsj      DATE,
  lrsj      DATE
)
;

prompt
prompt Creating table ZB_TSJHZX_HZB_BAK_13301YH_LP
prompt ===========================================
prompt
create table ZB_TSJHZX_HZB_BAK_13301YH_LP
(
  tszb_yn   VARCHAR2(6) not null,
  zbjg_dm   VARCHAR2(11) not null,
  byxdjhe   NUMBER(16,2) not null,
  syjzjhe   NUMBER(16,2) not null,
  byzhtse   NUMBER(16,2) not null,
  byjhze    NUMBER(16,2) not null,
  byybltse  NUMBER(16,2) not null,
  byjhye    NUMBER(16,2) not null,
  jhwcl     NUMBER(6,2) not null,
  bnljbltse NUMBER(16,2) not null,
  bnljzhtse NUMBER(16,2) not null,
  bnljxdjhe NUMBER(16,2) not null,
  bnljjhwcl NUMBER(6,2) not null,
  xgsj      DATE,
  lrsj      DATE
)
;

prompt Done
set define on
