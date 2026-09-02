prompt PL/SQL Developer Export User Objects for user ZJ_BJTS@GT3_CX
prompt Created by Administrator on 2026年8月4日
set define off
spool zj_bjts_object20260804.log

prompt
prompt Creating table CKTS_DM_HGJGFS
prompt =============================
prompt
create table CKTS_DM_HGJGFS
(
  jgfs_dm     CHAR(4) not null,
  jgfsmc      VARCHAR2(150) not null,
  jgfsqc      VARCHAR2(300) not null,
  jgfstslx_dm CHAR(1) not null,
  ckyzsbz     CHAR(1) not null,
  msjgbz      CHAR(1) not null
)
;
comment on table CKTS_DM_HGJGFS
  is '海关监管方式代码';
comment on column CKTS_DM_HGJGFS.jgfs_dm
  is '监管方式代码';
comment on column CKTS_DM_HGJGFS.jgfsmc
  is '监管方式名称';
comment on column CKTS_DM_HGJGFS.jgfsqc
  is '监管方式全称';
comment on column CKTS_DM_HGJGFS.jgfstslx_dm
  is '监管方式退税类型代码';
comment on column CKTS_DM_HGJGFS.ckyzsbz
  is '监管出口应征税标志';
comment on column CKTS_DM_HGJGFS.msjgbz
  is '免税监管标志';
alter table CKTS_DM_HGJGFS
  add constraint PK_CKTS_DM_HGJGFS primary key (JGFS_DM);

prompt
prompt Creating table CKTS_HD_JJYQ
prompt ===========================
prompt
create table CKTS_HD_JJYQ
(
  fhxxbuuid    VARCHAR2(32) not null,
  ghfzgswjg_dm CHAR(11),
  ghfzgswjgmc  VARCHAR2(300),
  ghfdjxh1     NUMBER(20),
  ghqynsrsbh_1 VARCHAR2(20),
  ghfqymc_1    VARCHAR2(300),
  fahdswjgmc   VARCHAR2(300),
  wsbh         VARCHAR2(150),
  fpfs         NUMBER(16,4),
  jshj         NUMBER(18,2),
  qfrq         DATE,
  fuhjzrq      DATE,
  yqcs         NUMBER(10),
  yqrq_1       DATE,
  yqfhyy       CHAR(1)
)
;
comment on table CKTS_HD_JJYQ
  is '即将逾期函调复函数据';
comment on column CKTS_HD_JJYQ.fhxxbuuid
  is '发函信息表UUID';
comment on column CKTS_HD_JJYQ.ghfzgswjg_dm
  is '供货方主管税务机关代码';
comment on column CKTS_HD_JJYQ.ghfzgswjgmc
  is '供货方主管税务机关名称';
comment on column CKTS_HD_JJYQ.ghfdjxh1
  is '供货方登记序号';
comment on column CKTS_HD_JJYQ.ghqynsrsbh_1
  is '供货企业纳税人识别号';
comment on column CKTS_HD_JJYQ.ghfqymc_1
  is '供货企业名称';
comment on column CKTS_HD_JJYQ.fahdswjgmc
  is '发函地税务机关名称';
comment on column CKTS_HD_JJYQ.wsbh
  is '文书编号';
comment on column CKTS_HD_JJYQ.fpfs
  is '发票份数';
comment on column CKTS_HD_JJYQ.jshj
  is '价税合计';
comment on column CKTS_HD_JJYQ.qfrq
  is '签发日期';
comment on column CKTS_HD_JJYQ.fuhjzrq
  is '复函截止日期（延期日期）';
comment on column CKTS_HD_JJYQ.yqcs
  is '延期次数';
comment on column CKTS_HD_JJYQ.yqrq_1
  is '延期日期';
comment on column CKTS_HD_JJYQ.yqfhyy
  is '延期复函原因';
alter table CKTS_HD_JJYQ
  add constraint PK_CKTS_HD_JJYQ primary key (FHXXBUUID);

prompt
prompt Creating table CKTS_HD_XFHHSB
prompt =============================
prompt
create table CKTS_HD_XFHHSB
(
  hdfpqduuid  VARCHAR2(32) not null,
  zzszyfpdmhm VARCHAR2(20),
  je          NUMBER(18,2),
  se          NUMBER(18,6),
  ktse_1      NUMBER(18,6),
  fhxxbuuid   VARCHAR2(32),
  ghfdjxh     NUMBER(20),
  qfrq        DATE,
  ssq         VARCHAR2(60),
  sbpc        VARCHAR2(75),
  sbxh        VARCHAR2(50),
  lrrq        DATE
)
;
comment on table CKTS_HD_XFHHSB
  is '先发函后申报发票数据';
comment on column CKTS_HD_XFHHSB.hdfpqduuid
  is '函调发票清单UUID';
comment on column CKTS_HD_XFHHSB.zzszyfpdmhm
  is '增值税专用发票代码号码';
comment on column CKTS_HD_XFHHSB.je
  is '金额';
comment on column CKTS_HD_XFHHSB.se
  is '税额';
comment on column CKTS_HD_XFHHSB.ktse_1
  is '可退税额';
comment on column CKTS_HD_XFHHSB.fhxxbuuid
  is '发函信息表UUID';
comment on column CKTS_HD_XFHHSB.ghfdjxh
  is '购货方登记序号';
comment on column CKTS_HD_XFHHSB.qfrq
  is '签发日期';
comment on column CKTS_HD_XFHHSB.ssq
  is '所属期';
comment on column CKTS_HD_XFHHSB.sbpc
  is '申报批次';
comment on column CKTS_HD_XFHHSB.sbxh
  is '申报序号';
comment on column CKTS_HD_XFHHSB.lrrq
  is '录入日期';
alter table CKTS_HD_XFHHSB
  add constraint PK_CKTS_HD_XFHHSB primary key (HDFPQDUUID);

prompt
prompt Creating table CKTS_KZ_SLQY
prompt ===========================
prompt
create table CKTS_KZ_SLQY
(
  uuid           VARCHAR2(32) not null,
  tsswjg_dm_1    CHAR(11),
  djxh           NUMBER(20),
  lcslid         CHAR(32),
  yxqq           DATE,
  yxqz           DATE,
  lrrq           DATE,
  nsrsbh         VARCHAR2(20) not null,
  shxydm         VARCHAR2(20),
  nsrmc          VARCHAR2(300) not null,
  fddbrxm        VARCHAR2(150),
  fddbrsfzjlx_dm CHAR(3),
  fddbrsfzjhm    VARCHAR2(30),
  bachbz         CHAR(1),
  bachrq         DATE
)
;
comment on table CKTS_KZ_SLQY
  is '四类企业法定代表人信息';
comment on column CKTS_KZ_SLQY.uuid
  is 'UUID||uuid';
comment on column CKTS_KZ_SLQY.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_KZ_SLQY.djxh
  is '登记序号';
comment on column CKTS_KZ_SLQY.lcslid
  is '流程实例ID';
comment on column CKTS_KZ_SLQY.yxqq
  is '有效期起';
comment on column CKTS_KZ_SLQY.yxqz
  is '有效期止';
comment on column CKTS_KZ_SLQY.lrrq
  is '录入日期';
comment on column CKTS_KZ_SLQY.nsrsbh
  is '纳税人税号';
comment on column CKTS_KZ_SLQY.shxydm
  is '社会信用代码';
comment on column CKTS_KZ_SLQY.nsrmc
  is '纳税人名称';
comment on column CKTS_KZ_SLQY.fddbrxm
  is '法定代表人姓名';
comment on column CKTS_KZ_SLQY.fddbrsfzjlx_dm
  is '法定代表人证件类型';
comment on column CKTS_KZ_SLQY.fddbrsfzjhm
  is '法定代表人证件号码';
comment on column CKTS_KZ_SLQY.bachbz
  is '备案撤回标志';
comment on column CKTS_KZ_SLQY.bachrq
  is '备案撤回日期';
create index IDX_CKTS_KZ_SLQY_FDDBR on CKTS_KZ_SLQY (FDDBRSFZJHM);
alter table CKTS_KZ_SLQY
  add constraint PK_CKTS_KZ_SLQY primary key (UUID);

prompt
prompt Creating table CKTS_LC_SDHC
prompt ===========================
prompt
create table CKTS_LC_SDHC
(
  uuid        VARCHAR2(32) not null,
  tsswjg_dm_1 CHAR(11),
  djxh        NUMBER(20),
  nsrsbh      VARCHAR2(20),
  nsrmc       VARCHAR2(300),
  lcslid      CHAR(32),
  zlclcslid   CHAR(32),
  hcyysm      VARCHAR2(3000),
  sdhcrqtzbh  VARCHAR2(300),
  lrrq        DATE not null,
  rqdcpgry    VARCHAR2(300),
  rqqrry      VARCHAR2(300),
  rqqrsj      DATE,
  qxrqsj      DATE,
  jcrqsj      DATE,
  rqddxesj    DATE,
  rqsebjsj    DATE,
  sdhcqdsj    DATE,
  sdhcwcsj    DATE,
  hcbh        VARCHAR2(20),
  zfbz_1      CHAR(1),
  lczt        CHAR(2),
  sdhcqdzq    NUMBER(18,6) default 0,
  sdhcwczq    NUMBER(18,6) default 0
)
;
comment on table CKTS_LC_SDHC
  is '实地核查流程';
comment on column CKTS_LC_SDHC.uuid
  is 'UUID';
comment on column CKTS_LC_SDHC.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_LC_SDHC.djxh
  is '登记序号';
comment on column CKTS_LC_SDHC.nsrsbh
  is '纳税人识别号';
comment on column CKTS_LC_SDHC.nsrmc
  is '纳税人名称';
comment on column CKTS_LC_SDHC.lcslid
  is '流程实例ID';
comment on column CKTS_LC_SDHC.zlclcslid
  is '主流程LCSLID';
comment on column CKTS_LC_SDHC.hcyysm
  is '核查原因说明';
comment on column CKTS_LC_SDHC.sdhcrqtzbh
  is '实地核查容缺台账编号';
comment on column CKTS_LC_SDHC.lrrq
  is '录入日期';
comment on column CKTS_LC_SDHC.rqdcpgry
  is '容缺调查评估人员';
comment on column CKTS_LC_SDHC.rqqrry
  is '容缺确认人员';
comment on column CKTS_LC_SDHC.rqqrsj
  is '容缺确认时间';
comment on column CKTS_LC_SDHC.qxrqsj
  is '取消容缺时间';
comment on column CKTS_LC_SDHC.jcrqsj
  is '解除容缺时间';
comment on column CKTS_LC_SDHC.rqddxesj
  is '容缺到达限额时间';
comment on column CKTS_LC_SDHC.rqsebjsj
  is '容缺税额办结时间';
comment on column CKTS_LC_SDHC.sdhcqdsj
  is '实地核查启动时间';
comment on column CKTS_LC_SDHC.sdhcwcsj
  is '实地核查完成时间';
comment on column CKTS_LC_SDHC.hcbh
  is '核查编号';
comment on column CKTS_LC_SDHC.zfbz_1
  is '主流程LCSLID作废标志';
comment on column CKTS_LC_SDHC.lczt
  is '流程状态（00未结束正常01未结束即将逾期02未结束已逾期10正常结束12逾期结束20作废）';
comment on column CKTS_LC_SDHC.sdhcqdzq
  is '实地核查启动周期';
comment on column CKTS_LC_SDHC.sdhcwczq
  is '实地核查完成周期';
alter table CKTS_LC_SDHC
  add constraint PK_CKTS_LC_SDHC primary key (UUID);

prompt
prompt Creating table CKTS_LC_STZC
prompt ===========================
prompt
create table CKTS_LC_STZC
(
  uuid        VARCHAR2(32) not null,
  tsswjg_dm_1 CHAR(11),
  lcswsx_dm   VARCHAR2(16),
  lcslid      CHAR(32),
  ckqygllb_dm CHAR(1),
  djxh        NUMBER(20),
  ssq         VARCHAR2(60),
  ffrq        DATE,
  mylaj       NUMBER(18,2),
  rmblaj      NUMBER(18,2),
  mdtse       NUMBER(18,6),
  zgswskfj_dm CHAR(11),
  nsrsbh      VARCHAR2(20),
  nsrmc       VARCHAR2(300),
  djrq        DATE,
  sndxse      NUMBER(18,2),
  pjjb        VARCHAR2(10),
  lczt        CHAR(2)
)
;
comment on table CKTS_LC_STZC
  is '视同自产（STZC-01）流程';
comment on column CKTS_LC_STZC.uuid
  is 'UUID';
comment on column CKTS_LC_STZC.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_LC_STZC.lcswsx_dm
  is '流程税务事项代码';
comment on column CKTS_LC_STZC.lcslid
  is '流程实例ID';
comment on column CKTS_LC_STZC.ckqygllb_dm
  is '出口企业管理类别代码';
comment on column CKTS_LC_STZC.djxh
  is '登记序号';
comment on column CKTS_LC_STZC.ssq
  is '所属期';
comment on column CKTS_LC_STZC.ffrq
  is '发放时间';
comment on column CKTS_LC_STZC.mylaj
  is '视同自产销售额（美元）';
comment on column CKTS_LC_STZC.rmblaj
  is '视同自产销售额（人民币）';
comment on column CKTS_LC_STZC.mdtse
  is '视同自产免抵退税额';
comment on column CKTS_LC_STZC.zgswskfj_dm
  is '主管税务机关';
comment on column CKTS_LC_STZC.nsrsbh
  is '纳税人识别号';
comment on column CKTS_LC_STZC.nsrmc
  is '纳税人名称';
comment on column CKTS_LC_STZC.djrq
  is '税务登记日期';
comment on column CKTS_LC_STZC.sndxse
  is '上年度销售额';
comment on column CKTS_LC_STZC.pjjb
  is '纳税信用等级';
comment on column CKTS_LC_STZC.lczt
  is '流程状态（00未结束10结束）';
alter table CKTS_LC_STZC
  add constraint PK_CKTS_LC_STZC primary key (UUID);

prompt
prompt Creating table CKTS_LC_TSSB
prompt ===========================
prompt
create table CKTS_LC_TSSB
(
  uuid        VARCHAR2(32) not null,
  tsswjg_dm_1 CHAR(11),
  lcswsx_dm   VARCHAR2(16),
  lcslid      CHAR(32),
  ckqygllb_dm CHAR(1),
  djxh        NUMBER(20),
  nsrsbh      VARCHAR2(20),
  nsrmc       VARCHAR2(300),
  ssq         VARCHAR2(60),
  sbpc        VARCHAR2(75),
  sbrq_1      DATE,
  qdsj        DATE,
  khjzsj      DATE,
  dysltzsj    DATE,
  ffrq        DATE,
  fssj        DATE,
  ywhzsj      DATE,
  fszzstse    NUMBER(18,6) default 0,
  fsxfstse    NUMBER(18,6) default 0,
  fsmdse      NUMBER(18,6) default 0,
  sehzrq      DATE,
  sehzzzstse  NUMBER(18,6) default 0,
  sehzxfstse  NUMBER(18,6) default 0,
  byhzzzstse  NUMBER(18,6) default 0,
  byhzxfstse  NUMBER(18,6) default 0,
  kprq        DATE,
  ssrthsbh    VARCHAR2(32),
  sssrthsse   NUMBER(18,6) default 0,
  lcjssj      DATE,
  lczt        CHAR(2),
  lcyqdsj     NUMBER(18,6) default 0
)
;
comment on table CKTS_LC_TSSB
  is '出口退税审核流程';
comment on column CKTS_LC_TSSB.uuid
  is 'UUID';
comment on column CKTS_LC_TSSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_LC_TSSB.lcswsx_dm
  is '流程税务事项代码';
comment on column CKTS_LC_TSSB.lcslid
  is '流程实例ID';
comment on column CKTS_LC_TSSB.ckqygllb_dm
  is '出口企业管理类别代码';
comment on column CKTS_LC_TSSB.djxh
  is '登记序号';
comment on column CKTS_LC_TSSB.nsrsbh
  is '纳税人识别号';
comment on column CKTS_LC_TSSB.nsrmc
  is '纳税人名称';
comment on column CKTS_LC_TSSB.ssq
  is '所属期';
comment on column CKTS_LC_TSSB.sbpc
  is '申报批次';
comment on column CKTS_LC_TSSB.sbrq_1
  is '申报日期';
comment on column CKTS_LC_TSSB.qdsj
  is '启动时间';
comment on column CKTS_LC_TSSB.khjzsj
  is '考核截止时间';
comment on column CKTS_LC_TSSB.dysltzsj
  is '打印受理通知时间';
comment on column CKTS_LC_TSSB.ffrq
  is '发放日期';
comment on column CKTS_LC_TSSB.fssj
  is '复审时间';
comment on column CKTS_LC_TSSB.ywhzsj
  is '业务核准时间';
comment on column CKTS_LC_TSSB.fszzstse
  is '复审增值税退税额';
comment on column CKTS_LC_TSSB.fsxfstse
  is '复审消费税退税额';
comment on column CKTS_LC_TSSB.fsmdse
  is '复审免抵税额';
comment on column CKTS_LC_TSSB.sehzrq
  is '税额核准日期';
comment on column CKTS_LC_TSSB.sehzzzstse
  is '税额核准增值税退税额';
comment on column CKTS_LC_TSSB.sehzxfstse
  is '税额核准消费税退税额';
comment on column CKTS_LC_TSSB.byhzzzstse
  is '不予核准增值税退税额';
comment on column CKTS_LC_TSSB.byhzxfstse
  is '不予核准消费税退税额';
comment on column CKTS_LC_TSSB.kprq
  is '开票日期';
comment on column CKTS_LC_TSSB.ssrthsbh
  is '税收收入退还书编号';
comment on column CKTS_LC_TSSB.sssrthsse
  is '税收收入退还书汇总退税额';
comment on column CKTS_LC_TSSB.lcjssj
  is '流程结束日期';
comment on column CKTS_LC_TSSB.lczt
  is '流程状态（00未结束正常01未结束即将逾期02未结束已逾期10正常结束12逾期结束）';
comment on column CKTS_LC_TSSB.lcyqdsj
  is '流程已启动时间';
create index ID_CKTS_LC_TSSB_LCZT on CKTS_LC_TSSB (LCZT);
alter table CKTS_LC_TSSB
  add constraint PK_CKTS_LC_TSSB primary key (UUID);

prompt
prompt Creating table CKTS_LOG_DEALDATA
prompt ================================
prompt
create table CKTS_LOG_DEALDATA
(
  czsj DATE default SYSDATE,
  czjl VARCHAR2(300),
  sbyy VARCHAR2(2000)
)
;

prompt
prompt Creating table CKTS_WBSJ_CKWSB
prompt ==============================
prompt
create table CKTS_WBSJ_CKWSB
(
  tsswjg_dm_1 CHAR(11),
  djxh        NUMBER(20) not null,
  rkrq        DATE,
  ckrq_1      DATE,
  ckbgdh      VARCHAR2(21) not null,
  jgfs_dm     CHAR(4),
  cksp_dm     VARCHAR2(20),
  hgspmc      VARCHAR2(500),
  rmblaj      NUMBER(18,2),
  mylaj       NUMBER(18,2),
  hgqy_dm     VARCHAR2(50),
  bah         VARCHAR2(12),
  sjly        VARCHAR2(20)
)
;
comment on table CKTS_WBSJ_CKWSB
  is '出口应征税商品';
create index IDX_CKTS_WBSJ_CKWSB_PK on CKTS_WBSJ_CKWSB (DJXH, CKBGDH);

prompt
prompt Creating table CKTS_WBSJ_CKYZS
prompt ==============================
prompt
create table CKTS_WBSJ_CKYZS
(
  tsswjg_dm_1 CHAR(11),
  djxh        NUMBER(20) not null,
  rkrq        DATE,
  ckrq_1      DATE,
  ckbgdh      VARCHAR2(21) not null,
  jgfs_dm     CHAR(4),
  cksp_dm     VARCHAR2(20),
  hgspmc      VARCHAR2(500),
  rmblaj      NUMBER(18,2),
  mylaj       NUMBER(18,2),
  sjly        VARCHAR2(20),
  tsswjg_mc   VARCHAR2(100),
  xgr         VARCHAR2(20),
  xgsj        DATE,
  remark      VARCHAR2(100),
  nsrsbh      VARCHAR2(20),
  nsrmc       VARCHAR2(100)
)
;
comment on table CKTS_WBSJ_CKYZS
  is '出口应征税商品';
create index IDX_CKTS_WBSJ_CKYZS on CKTS_WBSJ_CKYZS (DJXH, CKBGDH);

prompt
prompt Creating table CKTS_YJRZ_LCSLID
prompt ===============================
prompt
create table CKTS_YJRZ_LCSLID
(
  tsswjg_dm_1 CHAR(11) not null,
  djxh        NUMBER(20) not null,
  ssq         VARCHAR2(60) not null,
  sbpc        VARCHAR2(75),
  lcswsx_dm   VARCHAR2(16) not null,
  lcslid      CHAR(32) not null,
  zbcode      VARCHAR2(5) not null,
  begin_time  DATE default SYSDATE not null,
  end_time    DATE,
  yj_count    NUMBER(8) default 0 not null
)
;
comment on column CKTS_YJRZ_LCSLID.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_YJRZ_LCSLID.djxh
  is '登记序号';
comment on column CKTS_YJRZ_LCSLID.ssq
  is '所属期';
comment on column CKTS_YJRZ_LCSLID.sbpc
  is '申报批次';
comment on column CKTS_YJRZ_LCSLID.lcswsx_dm
  is '流程税务事项代码';
comment on column CKTS_YJRZ_LCSLID.lcslid
  is '流程实例ID';
comment on column CKTS_YJRZ_LCSLID.zbcode
  is '指标代码 前3位表示预警代码';
comment on column CKTS_YJRZ_LCSLID.begin_time
  is '开始时间';
comment on column CKTS_YJRZ_LCSLID.end_time
  is '结束时间';
comment on column CKTS_YJRZ_LCSLID.yj_count
  is '预警笔数';
alter table CKTS_YJRZ_LCSLID
  add constraint PK_CKTS_YJRZ_LCSLID primary key (LCSLID, ZBCODE);

prompt
prompt Creating table DM_GT3_XML_CONFIG
prompt ================================
prompt
create table DM_GT3_XML_CONFIG
(
  id                 INTEGER not null,
  sbyw_dm            VARCHAR2(32) not null,
  root_tag_name      VARCHAR2(255) not null,
  xsi_type           VARCHAR2(255) not null,
  bbh                VARCHAR2(255),
  xmlbh              VARCHAR2(255),
  xmlmc              VARCHAR2(255),
  xsi_schemalocation VARCHAR2(255),
  xmlns_xsi          VARCHAR2(255),
  xmlns              VARCHAR2(255),
  sbyw_mc            VARCHAR2(100),
  jkbh               VARCHAR2(100),
  lcsx_dm            VARCHAR2(100),
  jkfw_id            VARCHAR2(100),
  zjfk_id            VARCHAR2(100)
)
;
comment on column DM_GT3_XML_CONFIG.sbyw_dm
  is '申报业务代码';
comment on column DM_GT3_XML_CONFIG.root_tag_name
  is '申报业务对应的xml文档根节点名称';
comment on column DM_GT3_XML_CONFIG.xsi_type
  is '用于标识报文的类型';
comment on column DM_GT3_XML_CONFIG.sbyw_mc
  is '申报业务名称';
comment on column DM_GT3_XML_CONFIG.jkbh
  is '接口编号';
comment on column DM_GT3_XML_CONFIG.lcsx_dm
  is '（金三）税务流程事项代码';
comment on column DM_GT3_XML_CONFIG.jkfw_id
  is '接口服务清册ID';
create unique index SBYW_DM_UNIQ_INDEX on DM_GT3_XML_CONFIG (SBYW_DM);
alter table DM_GT3_XML_CONFIG
  add constraint DM_GT3_XML_CONFIG_PKEY primary key (ID);

prompt
prompt Creating table DSF_DECLARE_COMPANYINFO
prompt ======================================
prompt
create table DSF_DECLARE_COMPANYINFO
(
  id                   NUMBER(18) not null,
  social_credit_code   VARCHAR2(20) not null,
  tax_name             VARCHAR2(500) not null,
  customs_company_code VARCHAR2(20),
  agent_code           VARCHAR2(30),
  company_type         CHAR(2) not null,
  operator             VARCHAR2(50) not null,
  operator_id          VARCHAR2(20) not null,
  operator_phone       VARCHAR2(30) not null,
  declare_type         CHAR(2) not null,
  finance_chief        VARCHAR2(50) not null,
  legal_person         VARCHAR2(50) not null,
  agent_credit_code    VARCHAR2(20),
  agent_name           VARCHAR2(50),
  agent_customs_code   VARCHAR2(20),
  agent_operator       VARCHAR2(30),
  agent_operator_id    VARCHAR2(30),
  agent_operator_phone VARCHAR2(30),
  attachment           VARCHAR2(4000),
  decl_time            TIMESTAMP(6),
  tax_org_code         VARCHAR2(20),
  tax_org_name         VARCHAR2(50),
  tax_org_operator     VARCHAR2(50),
  approve_state        CHAR(2),
  approve_message      VARCHAR2(200),
  create_time          TIMESTAMP(6),
  update_time          TIMESTAMP(6),
  withdraw_flag        CHAR(1)
)
;
comment on column DSF_DECLARE_COMPANYINFO.id
  is '序号';
comment on column DSF_DECLARE_COMPANYINFO.social_credit_code
  is '统一社会信用代码';
comment on column DSF_DECLARE_COMPANYINFO.tax_name
  is '纳税人名称';
comment on column DSF_DECLARE_COMPANYINFO.customs_company_code
  is '海关企业代码';
comment on column DSF_DECLARE_COMPANYINFO.agent_code
  is '对外贸易经营者备案登记表编号';
comment on column DSF_DECLARE_COMPANYINFO.company_type
  is '企业类型 (01内资生产企业、02外商投资企业、03外贸企业、04个体工商户)';
comment on column DSF_DECLARE_COMPANYINFO.operator
  is '经办人员-姓名';
comment on column DSF_DECLARE_COMPANYINFO.operator_id
  is '经办人员-身份证号';
comment on column DSF_DECLARE_COMPANYINFO.operator_phone
  is '经办人员-电话';
comment on column DSF_DECLARE_COMPANYINFO.declare_type
  is '免税申报方式(01代理申报、 02自行申报)';
comment on column DSF_DECLARE_COMPANYINFO.finance_chief
  is '财务负责人';
comment on column DSF_DECLARE_COMPANYINFO.legal_person
  is '法定代表人';
comment on column DSF_DECLARE_COMPANYINFO.agent_credit_code
  is '代理企业统一社会信用代码(申报方式为代理申报必填)';
comment on column DSF_DECLARE_COMPANYINFO.agent_name
  is '代理企业纳税人名称(申报方式为代理申报必填)';
comment on column DSF_DECLARE_COMPANYINFO.agent_customs_code
  is '代理企业海关企业代码(申报方式为代理申报必填)';
comment on column DSF_DECLARE_COMPANYINFO.agent_operator
  is '代理经办人员-姓名(申报方式为代理申报必填)';
comment on column DSF_DECLARE_COMPANYINFO.agent_operator_id
  is '代理经办人员-身份证号(申报方式为代理申报必填)';
comment on column DSF_DECLARE_COMPANYINFO.agent_operator_phone
  is '代理经办人员-电话(申报方式为代理申报必填)';
comment on column DSF_DECLARE_COMPANYINFO.attachment
  is '附件-税务登记证等(将ZIP流通过Base64编码生成内容)';
comment on column DSF_DECLARE_COMPANYINFO.decl_time
  is '申报时间';
comment on column DSF_DECLARE_COMPANYINFO.tax_org_code
  is '主管税务机关代码';
comment on column DSF_DECLARE_COMPANYINFO.tax_org_name
  is '主管税务机关名称';
comment on column DSF_DECLARE_COMPANYINFO.tax_org_operator
  is '主管税务机关经办人';
comment on column DSF_DECLARE_COMPANYINFO.approve_state
  is '审核状态：00:云平台落地、01：审核中（局端落地）02 审核通过 03 审核不通过';
comment on column DSF_DECLARE_COMPANYINFO.approve_message
  is '审批信息(审批不通过必填)';
comment on column DSF_DECLARE_COMPANYINFO.create_time
  is '创建时间';
comment on column DSF_DECLARE_COMPANYINFO.update_time
  is '修改时间（包含落地时间、审核时间等）';
comment on column DSF_DECLARE_COMPANYINFO.withdraw_flag
  is '备案撤回标志, 1:备案撤回 空值:备案';
alter table DSF_DECLARE_COMPANYINFO
  add primary key (ID);

prompt
prompt Creating table FXGL_DATA_FXYDJG
prompt ===============================
prompt
create table FXGL_DATA_FXYDJG
(
  id             NUMBER not null,
  tsswjg_dm      CHAR(11),
  tbr            VARCHAR2(20),
  tbrq           DATE,
  ssny           VARCHAR2(20),
  djxh           NUMBER(20),
  shxyno         VARCHAR2(20),
  nsrmc          VARCHAR2(200),
  fxrwly_dm      CHAR(2) not null,
  rwfxqj_mycke   NUMBER(18,2),
  rwfxqj_sbmycke NUMBER(18,2),
  rwfxqj_bltse   NUMBER(18,2),
  fxydcs_jh      VARCHAR2(100),
  byts           NUMBER(18,2),
  yzhts          NUMBER(18,2),
  stnxzs         NUMBER(18,2),
  zhts           NUMBER(18,2),
  jxsezc         NUMBER(18,2),
  ybjzzs         NUMBER(18,2),
  ybjsds         NUMBER(18,2),
  ybjqtsz        NUMBER(18,2),
  bz             VARCHAR2(200),
  tsswjg_mc      VARCHAR2(300),
  spdm2mc        VARCHAR2(250),
  bytscke        NUMBER(18,2),
  yzhtscdfs      NUMBER(18,2),
  pscke          NUMBER(18,2),
  pstse          NUMBER(18,2),
  pszhtse        NUMBER(18,2),
  sfysjc         CHAR(1),
  jcpscke        NUMBER(18,2),
  jcpstse        NUMBER(18,2),
  jcqrpstse      NUMBER(18,2),
  jcrktse        NUMBER(18,2),
  jczhtse        NUMBER(18,2),
  sfysga         CHAR(1),
  fxydyrkje      NUMBER(18,2),
  fxydrkje       NUMBER(18,2),
  rwyqsj         DATE,
  rwwcsj         DATE,
  lcslid         VARCHAR2(32),
  fxrwpcmc       VARCHAR2(100),
  qylx           VARCHAR2(64),
  ybjsds2        NUMBER(18,2),
  sfhcywt        CHAR(1)
)
;
comment on table FXGL_DATA_FXYDJG
  is '风险应对结果明细表（中间表），用于从金三刷数据到tl_tssh的同名表';
comment on column FXGL_DATA_FXYDJG.id
  is 'ID主键';
comment on column FXGL_DATA_FXYDJG.tsswjg_dm
  is '填报单位';
comment on column FXGL_DATA_FXYDJG.tbr
  is '填报人';
comment on column FXGL_DATA_FXYDJG.tbrq
  is '填报日期';
comment on column FXGL_DATA_FXYDJG.ssny
  is '所属年月';
comment on column FXGL_DATA_FXYDJG.djxh
  is '登记序号';
comment on column FXGL_DATA_FXYDJG.shxyno
  is '统一社会信用代码';
comment on column FXGL_DATA_FXYDJG.nsrmc
  is '企业名称';
comment on column FXGL_DATA_FXYDJG.fxrwly_dm
  is '风险任务来源(FXGL_DM_FXRWLY，单选)';
comment on column FXGL_DATA_FXYDJG.rwfxqj_mycke
  is '任务分析期间涉及出口额（万美元）';
comment on column FXGL_DATA_FXYDJG.rwfxqj_sbmycke
  is '任务分析期间涉及申报退税出口额（万美元）';
comment on column FXGL_DATA_FXYDJG.rwfxqj_bltse
  is '任务分析期间内办理退税额（万元）';
comment on column FXGL_DATA_FXYDJG.fxydcs_jh
  is '风险应对措施集合(FXGL_DM_FXYDCS，多选)';
comment on column FXGL_DATA_FXYDJG.byts
  is '不予退税额（万元）';
comment on column FXGL_DATA_FXYDJG.yzhts
  is '追回（补缴方式）退税额（万元）';
comment on column FXGL_DATA_FXYDJG.stnxzs
  is '视同内销征税额（万元）';
comment on column FXGL_DATA_FXYDJG.zhts
  is '暂缓退税额（万元）';
comment on column FXGL_DATA_FXYDJG.jxsezc
  is '进项转出税额（万元）';
comment on column FXGL_DATA_FXYDJG.ybjzzs
  is '应补交增值税税款额（万元）';
comment on column FXGL_DATA_FXYDJG.ybjsds
  is '应补缴或调增企业所得税税款额（万元）';
comment on column FXGL_DATA_FXYDJG.ybjqtsz
  is '应补缴其他税种税款额（万元）';
comment on column FXGL_DATA_FXYDJG.bz
  is '备注';
comment on column FXGL_DATA_FXYDJG.tsswjg_mc
  is '税务机关名称';
comment on column FXGL_DATA_FXYDJG.spdm2mc
  is '涉及商品代码及名称';
comment on column FXGL_DATA_FXYDJG.bytscke
  is '不予退税出口额（万美元）';
comment on column FXGL_DATA_FXYDJG.yzhtscdfs
  is '追回（冲抵方式）退税额（万元）';
comment on column FXGL_DATA_FXYDJG.pscke
  is '涉嫌骗税出口额（万美元）';
comment on column FXGL_DATA_FXYDJG.pstse
  is '涉嫌骗税申报退税额（万元）';
comment on column FXGL_DATA_FXYDJG.pszhtse
  is '涉嫌骗税暂缓退税额（万元）';
comment on column FXGL_DATA_FXYDJG.sfysjc
  is '是否移送稽查';
comment on column FXGL_DATA_FXYDJG.jcpscke
  is '移送稽查涉嫌骗税出口额（万美元）';
comment on column FXGL_DATA_FXYDJG.jcpstse
  is '移送稽查涉嫌骗税退税额（万元）';
comment on column FXGL_DATA_FXYDJG.jcqrpstse
  is '稽查已定性骗取退税额（万元）';
comment on column FXGL_DATA_FXYDJG.jcrktse
  is '稽查已追缴入库退税额（万元）';
comment on column FXGL_DATA_FXYDJG.jczhtse
  is '稽查暂缓退税（万元）';
comment on column FXGL_DATA_FXYDJG.sfysga
  is '是否移送公安';
comment on column FXGL_DATA_FXYDJG.fxydyrkje
  is '风险应对应入库金额（万元）';
comment on column FXGL_DATA_FXYDJG.fxydrkje
  is '风险应对已入库金额（万元）';
comment on column FXGL_DATA_FXYDJG.rwyqsj
  is '任务要求完成时限';
comment on column FXGL_DATA_FXYDJG.rwwcsj
  is '金三系统中任务完成时间';
comment on column FXGL_DATA_FXYDJG.lcslid
  is '审核系统流程受理ID';
comment on column FXGL_DATA_FXYDJG.fxrwpcmc
  is '风险任务批次名称';
comment on column FXGL_DATA_FXYDJG.qylx
  is '企业类型';
comment on column FXGL_DATA_FXYDJG.ybjsds2
  is '应调增应纳税所得额（万元）';
comment on column FXGL_DATA_FXYDJG.sfhcywt
  is '是否核查有问题';
alter table FXGL_DATA_FXYDJG
  add constraint PK_FXGL_DATA_FXYDJG primary key (ID);

prompt
prompt Creating table FXGL_DATA_FZPCKQY
prompt ================================
prompt
create table FXGL_DATA_FZPCKQY
(
  djxh        NUMBER(20) not null,
  ck_fzp      NUMBER(18,2),
  ck_rmb      NUMBER(18,2),
  ck_my       NUMBER(18,2),
  ck_zl_cd    NUMBER(16,4),
  ck_cd_zl    NUMBER(16,4),
  ck_zl_sl    NUMBER(16,4),
  ck_sl_zl    NUMBER(16,4),
  ck_zl_all   NUMBER(16,4),
  ck_gj_m     NUMBER(16,4),
  ck_gj_m_pj  NUMBER(16,4),
  ck_gj_j     NUMBER(16,4),
  ck_gj_j_pj  NUMBER(16,4),
  ck_dj_gj    NUMBER(16,4),
  ck_dj_gj_pj NUMBER(16,4),
  qbxssr      NUMBER(18,2),
  fzp_ckbl    NUMBER(10,6),
  zc_ch_qcye  NUMBER(18,2),
  zc_ch_qmye  NUMBER(18,2),
  zc_ch_zye   NUMBER(18,2),
  nsrsbh      VARCHAR2(20)
)
;
comment on table FXGL_DATA_FZPCKQY
  is '纺织品出口企业风险分析模型';
comment on column FXGL_DATA_FZPCKQY.djxh
  is '登记序号';
comment on column FXGL_DATA_FZPCKQY.ck_fzp
  is '纺织品出口额（人民币）';
comment on column FXGL_DATA_FZPCKQY.ck_rmb
  is '出口额（人民币）';
comment on column FXGL_DATA_FZPCKQY.ck_my
  is '出口额（美元）';
comment on column FXGL_DATA_FZPCKQY.ck_zl_cd
  is '出口重量（千克，对应单位米）';
comment on column FXGL_DATA_FZPCKQY.ck_cd_zl
  is '出口长度（米，对应单位千克）';
comment on column FXGL_DATA_FZPCKQY.ck_zl_sl
  is '出口重量（千克，对应单位件）';
comment on column FXGL_DATA_FZPCKQY.ck_sl_zl
  is '出口数量（件，对应单位千克）';
comment on column FXGL_DATA_FZPCKQY.ck_zl_all
  is '出口总重量';
comment on column FXGL_DATA_FZPCKQY.ck_gj_m
  is '出口每米公斤数';
comment on column FXGL_DATA_FZPCKQY.ck_gj_m_pj
  is '出口每米公斤平均数';
comment on column FXGL_DATA_FZPCKQY.ck_gj_j
  is '出口每件公斤数';
comment on column FXGL_DATA_FZPCKQY.ck_gj_j_pj
  is '出口每件公斤平均数';
comment on column FXGL_DATA_FZPCKQY.ck_dj_gj
  is '出口每公斤单价';
comment on column FXGL_DATA_FZPCKQY.ck_dj_gj_pj
  is '出口每公斤平均单价';
comment on column FXGL_DATA_FZPCKQY.qbxssr
  is '全部销售收入';
comment on column FXGL_DATA_FZPCKQY.fzp_ckbl
  is '纺织品出口比例';
comment on column FXGL_DATA_FZPCKQY.zc_ch_qcye
  is '资产负债表存货期初余额';
comment on column FXGL_DATA_FZPCKQY.zc_ch_qmye
  is '资产负债表存货期末余额';
comment on column FXGL_DATA_FZPCKQY.zc_ch_zye
  is '资产负债表存货总金额';
comment on column FXGL_DATA_FZPCKQY.nsrsbh
  is '纳税人识别号';
alter table FXGL_DATA_FZPCKQY
  add constraint PK_FXGL_DATA_FZPCKQY primary key (DJXH);

prompt
prompt Creating table FXGL_DATA_STZC
prompt =============================
prompt
create table FXGL_DATA_STZC
(
  djxh           NUMBER(20) not null,
  sbts_cke       NUMBER(18,2),
  sbts_wgcke     NUMBER(18,2),
  nsrsbh         VARCHAR2(20),
  nsrmc          VARCHAR2(300),
  zgswj_dm       VARCHAR2(11),
  zgswj_mc       VARCHAR2(300),
  hy_dm          VARCHAR2(4),
  hy_mc          VARCHAR2(100),
  nsrzt_dm       CHAR(2),
  barq           DATE,
  bachbz         CHAR(1),
  ckhwtmsjsff_dm CHAR(1)
)
;
comment on table FXGL_DATA_STZC
  is '生产企业出口外购货物风险模型';
comment on column FXGL_DATA_STZC.djxh
  is '登记序号';
comment on column FXGL_DATA_STZC.sbts_cke
  is '申报退税出口额（人民币）';
comment on column FXGL_DATA_STZC.sbts_wgcke
  is '申报退税外购出口额（人民币）';
comment on column FXGL_DATA_STZC.nsrsbh
  is '纳税人识别号';
comment on column FXGL_DATA_STZC.nsrmc
  is '纳税人名称';
comment on column FXGL_DATA_STZC.zgswj_dm
  is '主管税务机关代码';
comment on column FXGL_DATA_STZC.zgswj_mc
  is '主管税务机关名称';
comment on column FXGL_DATA_STZC.hy_dm
  is '行业代码';
comment on column FXGL_DATA_STZC.hy_mc
  is '行业名称';
comment on column FXGL_DATA_STZC.nsrzt_dm
  is '纳税人状态';
comment on column FXGL_DATA_STZC.barq
  is '备案日期';
comment on column FXGL_DATA_STZC.bachbz
  is '备案撤回标志';
comment on column FXGL_DATA_STZC.ckhwtmsjsff_dm
  is '出口货物退(免)税计算方法代码';
alter table FXGL_DATA_STZC
  add constraint PK_FXGL_DATA_STZC primary key (DJXH);
alter index PK_FXGL_DATA_STZC nologging;

prompt
prompt Creating table FXGL_DM_HZDWDQ
prompt =============================
prompt
create table FXGL_DM_HZDWDQ
(
  hzdwdq_dm VARCHAR2(5) not null,
  hzdwdq_mc VARCHAR2(200) not null,
  xzqh_dm   VARCHAR2(5),
  xzqh_mc   VARCHAR2(200),
  qybz      CHAR(1)
)
;
comment on table FXGL_DM_HZDWDQ
  is '货主单位地区与行政区划对照表';
comment on column FXGL_DM_HZDWDQ.hzdwdq_dm
  is '货主单位地区代码';
comment on column FXGL_DM_HZDWDQ.hzdwdq_mc
  is '货主单位地区名称';
comment on column FXGL_DM_HZDWDQ.xzqh_dm
  is '对应行政区划代码';
comment on column FXGL_DM_HZDWDQ.xzqh_mc
  is '对应行政区划名称';
comment on column FXGL_DM_HZDWDQ.qybz
  is '启用标志';
create index IDX_FXGL_DM_HZDWDQ on FXGL_DM_HZDWDQ (XZQH_DM);
alter table FXGL_DM_HZDWDQ
  add constraint PK_FXGL_DM_HZDWDQ primary key (HZDWDQ_DM);

prompt
prompt Creating table FXNK_CS_JJYQ
prompt ===========================
prompt
create table FXNK_CS_JJYQ
(
  tsswjg_dm_1 CHAR(11) not null,
  tsswjg_mc   VARCHAR2(150),
  jjyq_a      NUMBER(18,6) default 0,
  jjyq_b      NUMBER(18,6) default 0,
  jjyq_c      NUMBER(18,6) default 0,
  jjyq_d      NUMBER(18,6) default 0,
  whry        CHAR(11),
  whsj        DATE
)
;
comment on column FXNK_CS_JJYQ.tsswjg_dm_1
  is '退税税务机关代码';
comment on column FXNK_CS_JJYQ.tsswjg_mc
  is '退税税务机关简称';
comment on column FXNK_CS_JJYQ.jjyq_a
  is 'A类企业流程提醒设置（1-4）';
comment on column FXNK_CS_JJYQ.jjyq_b
  is 'B类企业流程提醒设置（1-9）';
comment on column FXNK_CS_JJYQ.jjyq_c
  is 'C类企业流程提醒设置（1-14）';
comment on column FXNK_CS_JJYQ.jjyq_d
  is 'D类企业流程提醒设置（1-19）';
comment on column FXNK_CS_JJYQ.whry
  is '维护人员（金三操作员代码）';
comment on column FXNK_CS_JJYQ.whsj
  is '维护时间';
alter table FXNK_CS_JJYQ
  add constraint PK_FXNK_CS_JJYQ primary key (TSSWJG_DM_1);

prompt
prompt Creating table FXNK_DM_NKZB
prompt ===========================
prompt
create table FXNK_DM_NKZB
(
  nkzbbh   VARCHAR2(10) not null,
  nkzbbb   VARCHAR2(6),
  nkzbxh   NUMBER(2),
  nkzbmxxh NUMBER(2),
  nkzblb   VARCHAR2(20),
  nkzbmc   VARCHAR2(300),
  nkfxdj   VARCHAR2(20),
  nkywly   VARCHAR2(100),
  nkywms   VARCHAR2(1000),
  nksjly   VARCHAR2(1000),
  nkkjms   VARCHAR2(2000),
  nkuuidb  VARCHAR2(100),
  sqtxlx   CHAR(1),
  szyjlx   CHAR(1),
  shjdlx   CHAR(1),
  kstxgzr  NUMBER(5,2),
  ksjdgzr  NUMBER(5,2),
  nkywlb   VARCHAR2(20),
  nkywbm   VARCHAR2(20),
  wcbz     CHAR(1)
)
;
comment on column FXNK_DM_NKZB.nkzbbh
  is '内控指标编号（后续作为主键）';
comment on column FXNK_DM_NKZB.nkzbbb
  is '内控指标版本（需求提交月份）';
comment on column FXNK_DM_NKZB.nkzbxh
  is '内控指标序号（对应内控需求文档中的顺序号）';
comment on column FXNK_DM_NKZB.nkzbmxxh
  is '内控指标明细序号（对应内控需求文档中数据口径的拆分顺序号）';
comment on column FXNK_DM_NKZB.nkzblb
  is '内控指标类别（态势感知归类）';
comment on column FXNK_DM_NKZB.nkzbmc
  is '内控指标名称';
comment on column FXNK_DM_NKZB.nkfxdj
  is '风险程度（高中低）';
comment on column FXNK_DM_NKZB.nkywly
  is '业务领域';
comment on column FXNK_DM_NKZB.nkywms
  is '业务描述';
comment on column FXNK_DM_NKZB.nksjly
  is '数据来源（金三前台数据源描述）';
comment on column FXNK_DM_NKZB.nkkjms
  is '口径说明（对应后台数据表口径描述）';
comment on column FXNK_DM_NKZB.nkuuidb
  is '内控风险点UUID对应表';
comment on column FXNK_DM_NKZB.sqtxlx
  is '事前提醒类型（0否/1是/2单独短信提醒）';
comment on column FXNK_DM_NKZB.szyjlx
  is '事中预警类型（0否/1提醒/2阻断）';
comment on column FXNK_DM_NKZB.shjdlx
  is '事后监督类型（0否/1是）';
comment on column FXNK_DM_NKZB.kstxgzr
  is '开始提醒工作日';
comment on column FXNK_DM_NKZB.ksjdgzr
  is '开始监督工作日';
comment on column FXNK_DM_NKZB.nkywlb
  is '内控业务类别（用于辅助态势感知归类）';
comment on column FXNK_DM_NKZB.nkywbm
  is '内控业务编码（用于辅助态势感知归类及剔除重复指标）';
alter table FXNK_DM_NKZB
  add constraint FXNK_DM_NKZB_PRI primary key (NKZBBH);

prompt
prompt Creating table FXNK_JC2B_NSXYPJ
prompt ===============================
prompt
create table FXNK_JC2B_NSXYPJ
(
  djxh NUMBER(20) not null,
  pjnd CHAR(4) not null,
  pjjb VARCHAR2(10) not null,
  fbsj DATE
)
;
comment on column FXNK_JC2B_NSXYPJ.djxh
  is '登记序号';
comment on column FXNK_JC2B_NSXYPJ.pjnd
  is '评级年度';
comment on column FXNK_JC2B_NSXYPJ.pjjb
  is '评级级别';
comment on column FXNK_JC2B_NSXYPJ.fbsj
  is '发布时间';
alter table FXNK_JC2B_NSXYPJ
  add constraint PK_FXNK_JC2B_NSXYPJ primary key (DJXH);

prompt
prompt Creating table FXNK_NBFXDMX_SH
prompt ==============================
prompt
create table FXNK_NBFXDMX_SH
(
  uuid      VARCHAR2(32) not null,
  swjgdm    CHAR(11),
  djxh      NUMBER(20),
  nsrsbh    VARCHAR2(20),
  nsrmc     VARCHAR2(300),
  lcswsx_dm VARCHAR2(16),
  lcslid    VARCHAR2(32),
  fssj      DATE,
  sjtbsj    DATE,
  nkzbbh    VARCHAR2(20) not null,
  nkje      NUMBER(16,2),
  nkse      NUMBER(16,2),
  nkywms    VARCHAR2(2000),
  nkclzt    CHAR(1) default '0',
  nkclry    CHAR(11),
  nkclsj    DATE,
  nkclsm    VARCHAR2(2000),
  fhry      CHAR(11),
  fhsj      DATE
)
;
comment on table FXNK_NBFXDMX_SH
  is '风险内控_内部风险点明细';
comment on column FXNK_NBFXDMX_SH.uuid
  is '内控业务关键字';
comment on column FXNK_NBFXDMX_SH.swjgdm
  is '税务机关代码';
comment on column FXNK_NBFXDMX_SH.djxh
  is '登记序号';
comment on column FXNK_NBFXDMX_SH.nsrsbh
  is '税号';
comment on column FXNK_NBFXDMX_SH.nsrmc
  is '名称';
comment on column FXNK_NBFXDMX_SH.lcswsx_dm
  is '流程税务事项代码';
comment on column FXNK_NBFXDMX_SH.lcslid
  is '流程实例ID';
comment on column FXNK_NBFXDMX_SH.fssj
  is '发生时间';
comment on column FXNK_NBFXDMX_SH.sjtbsj
  is '数据同步时间';
comment on column FXNK_NBFXDMX_SH.nkzbbh
  is '内控指标编号';
comment on column FXNK_NBFXDMX_SH.nkje
  is '涉及金额';
comment on column FXNK_NBFXDMX_SH.nkse
  is '涉及税额';
comment on column FXNK_NBFXDMX_SH.nkywms
  is '内控业务描述';
comment on column FXNK_NBFXDMX_SH.nkclzt
  is '内控处理状态（0未处理1已处理-正常2已处理-整改）';
comment on column FXNK_NBFXDMX_SH.nkclry
  is '内控处理人员';
comment on column FXNK_NBFXDMX_SH.nkclsj
  is '内控处理时间';
comment on column FXNK_NBFXDMX_SH.nkclsm
  is '内控处理说明';
comment on column FXNK_NBFXDMX_SH.fhry
  is '复核人员';
comment on column FXNK_NBFXDMX_SH.fhsj
  is '复核时间';

prompt
prompt Creating table FXNK_NBFXDMX_SQ
prompt ==============================
prompt
create table FXNK_NBFXDMX_SQ
(
  uuid      VARCHAR2(32) not null,
  swjgdm    CHAR(11),
  djxh      NUMBER(20),
  nsrsbh    VARCHAR2(20),
  nsrmc     VARCHAR2(300),
  lcswsx_dm VARCHAR2(16),
  lcslid    VARCHAR2(32),
  cjsj      DATE,
  gxsj      DATE,
  nkzbbh    VARCHAR2(20) not null,
  nkje      NUMBER(16,2),
  nkse      NUMBER(16,2),
  nkywms    VARCHAR2(2000),
  qxzt      CHAR(1) default '0',
  qxsj      DATE,
  qxry      CHAR(11),
  qxyysm    VARCHAR2(2000)
)
;
comment on table FXNK_NBFXDMX_SQ
  is '风险内控_内部风险点明细';
comment on column FXNK_NBFXDMX_SQ.uuid
  is '内控业务关键字';
comment on column FXNK_NBFXDMX_SQ.swjgdm
  is '税务机关代码';
comment on column FXNK_NBFXDMX_SQ.djxh
  is '登记序号';
comment on column FXNK_NBFXDMX_SQ.nsrsbh
  is '税号';
comment on column FXNK_NBFXDMX_SQ.nsrmc
  is '名称';
comment on column FXNK_NBFXDMX_SQ.lcswsx_dm
  is '流程税务事项代码';
comment on column FXNK_NBFXDMX_SQ.lcslid
  is '流程实例ID';
comment on column FXNK_NBFXDMX_SQ.cjsj
  is '创建时间（首次提醒时间）';
comment on column FXNK_NBFXDMX_SQ.gxsj
  is '更新时间（末次提醒时间）';
comment on column FXNK_NBFXDMX_SQ.nkzbbh
  is '内控指标编号';
comment on column FXNK_NBFXDMX_SQ.nkje
  is '涉及金额';
comment on column FXNK_NBFXDMX_SQ.nkse
  is '涉及税额';
comment on column FXNK_NBFXDMX_SQ.nkywms
  is '内控业务描述';
comment on column FXNK_NBFXDMX_SQ.qxzt
  is '取消状态（0未取消1已取消）';
comment on column FXNK_NBFXDMX_SQ.qxsj
  is '取消时间';
comment on column FXNK_NBFXDMX_SQ.qxry
  is '取消人员（金三操作员代码或SYSTEM）';
comment on column FXNK_NBFXDMX_SQ.qxyysm
  is '取消原因说明';

prompt
prompt Creating table FXNK_NBFXDMX_SZ
prompt ==============================
prompt
create table FXNK_NBFXDMX_SZ
(
  uuid      VARCHAR2(32) not null,
  swjgdm    CHAR(11),
  djxh      NUMBER(20),
  nsrsbh    VARCHAR2(20),
  nsrmc     VARCHAR2(300),
  lcswsx_dm VARCHAR2(16),
  lcslid    VARCHAR2(32),
  cfry      CHAR(11),
  cfsj      DATE,
  nkzbbh    VARCHAR2(20) not null,
  nkje      NUMBER(16,2),
  nkse      NUMBER(16,2),
  nkywms    VARCHAR2(2000),
  hxczsm    VARCHAR2(2000)
)
;
comment on table FXNK_NBFXDMX_SZ
  is '风险内控_内部风险点明细';
comment on column FXNK_NBFXDMX_SZ.uuid
  is '内控业务关键字';
comment on column FXNK_NBFXDMX_SZ.swjgdm
  is '税务机关代码';
comment on column FXNK_NBFXDMX_SZ.djxh
  is '登记序号';
comment on column FXNK_NBFXDMX_SZ.nsrsbh
  is '税号';
comment on column FXNK_NBFXDMX_SZ.nsrmc
  is '名称';
comment on column FXNK_NBFXDMX_SZ.lcswsx_dm
  is '流程税务事项代码';
comment on column FXNK_NBFXDMX_SZ.lcslid
  is '流程实例ID';
comment on column FXNK_NBFXDMX_SZ.cfry
  is '触发人员（金三操作员代码）';
comment on column FXNK_NBFXDMX_SZ.cfsj
  is '触发时间';
comment on column FXNK_NBFXDMX_SZ.nkzbbh
  is '内控指标编号';
comment on column FXNK_NBFXDMX_SZ.nkje
  is '涉及金额';
comment on column FXNK_NBFXDMX_SZ.nkse
  is '涉及税额';
comment on column FXNK_NBFXDMX_SZ.nkywms
  is '内控业务描述';
comment on column FXNK_NBFXDMX_SZ.hxczsm
  is '后续操作说明';

prompt
prompt Creating table FXNK_NBFXDMX_SZ_LC
prompt =================================
prompt
create table FXNK_NBFXDMX_SZ_LC
(
  plcslid   VARCHAR2(32),
  lcslid    VARCHAR2(32),
  zlclcslid VARCHAR2(32),
  cjtime    DATE default SYSDATE
)
;
comment on column FXNK_NBFXDMX_SZ_LC.plcslid
  is '流程实例ID';
comment on column FXNK_NBFXDMX_SZ_LC.lcslid
  is '流程实例ID';
comment on column FXNK_NBFXDMX_SZ_LC.zlclcslid
  is '流程实例ID';
create index IDX_FXNK_NBFXDMX_SZ_LC on FXNK_NBFXDMX_SZ_LC (PLCSLID);

prompt
prompt Creating table MSG_PUSH_DATA
prompt ============================
prompt
create table MSG_PUSH_DATA
(
  id      NUMBER(10) not null,
  swjg_dm VARCHAR2(11),
  nsrsbh  VARCHAR2(20),
  nsrmc   VARCHAR2(100),
  biztype VARCHAR2(20),
  bizkey  VARCHAR2(40),
  qdsj    DATE,
  jzsj    DATE,
  ywbz    VARCHAR2(100),
  sjtbsj  DATE,
  txcs    INTEGER,
  txsj    DATE
)
;
comment on table MSG_PUSH_DATA
  is '通用短信提醒业务数据表（每天晚上自动抽取更新即将逾期';
comment on column MSG_PUSH_DATA.swjg_dm
  is '税务机关代码';
comment on column MSG_PUSH_DATA.nsrsbh
  is '纳税人识别号';
comment on column MSG_PUSH_DATA.nsrmc
  is '纳税人名称';
comment on column MSG_PUSH_DATA.biztype
  is '业务种类： 退税办理/函调复函/荣缺办理';
comment on column MSG_PUSH_DATA.bizkey
  is '业务关键字';
comment on column MSG_PUSH_DATA.qdsj
  is '启动时间';
comment on column MSG_PUSH_DATA.jzsj
  is '截止时间';
comment on column MSG_PUSH_DATA.ywbz
  is '业务备注';
comment on column MSG_PUSH_DATA.sjtbsj
  is '数据同步时间';
comment on column MSG_PUSH_DATA.txcs
  is '提醒次数';
comment on column MSG_PUSH_DATA.txsj
  is '提醒时间';
create index IDX_MSG_PUSH_DATA on MSG_PUSH_DATA (SWJG_DM, BIZTYPE);
alter table MSG_PUSH_DATA
  add constraint PK_MSG_PUSH_DATA primary key (ID);

prompt
prompt Creating table PUB_JJR
prompt ======================
prompt
create table PUB_JJR
(
  jjr_ssnd VARCHAR2(8) not null,
  jjr_date DATE not null,
  memo     VARCHAR2(100)
)
;
comment on table PUB_JJR
  is '节假日';
comment on column PUB_JJR.jjr_ssnd
  is '所属年度';
comment on column PUB_JJR.jjr_date
  is '节假日日期';
comment on column PUB_JJR.memo
  is '备注';
alter table PUB_JJR
  add constraint PK_PUB_JJR primary key (JJR_SSND, JJR_DATE);

prompt
prompt Creating table RCGL_CQWSB_DATA
prompt ==============================
prompt
create table RCGL_CQWSB_DATA
(
  uuid        VARCHAR2(32) not null,
  swjgdm      CHAR(11),
  djxh        NUMBER(20) not null,
  nsrsbh      VARCHAR2(20),
  nsrmc       VARCHAR2(200),
  tsjsffdm    CHAR(1),
  ckbgdh      VARCHAR2(21) not null,
  ckrq_1      DATE,
  cksp_dm     VARCHAR2(20),
  gfhhgspmc   VARCHAR2(500),
  jgfs_dm     CHAR(4),
  mylaj       NUMBER(18,2),
  rmblaj      NUMBER(18,2),
  dyjldw_dm   VARCHAR2(3),
  cksl        NUMBER(16,4),
  wsbsl       NUMBER(16,4),
  zssl        NUMBER(16,6),
  tsl         NUMBER(16,6),
  sjly        VARCHAR2(11),
  cjrq        DATE,
  zmtbz       CHAR(1),
  qyqr_rq     DATE,
  qyqr_zt     CHAR(1) default 0,
  zms_sbssq   CHAR(6),
  zs_ysxse    NUMBER(18,2),
  zs_jtxxse   NUMBER(18,2),
  zms_ckfphm  VARCHAR2(30),
  ms_msxse    NUMBER(18,2),
  ms_jhpzhbz  CHAR(1),
  ms_jhpzh    VARCHAR2(30),
  ms_jxzcbz   CHAR(1),
  ms_jxzcssq  CHAR(6),
  ms_jxzcje   NUMBER(18,2),
  zms_fj      VARCHAR2(500),
  zms_bz      VARCHAR2(500),
  wsb_yylx    VARCHAR2(30),
  wsb_yysm    VARCHAR2(500),
  swsh_rq     DATE,
  swsh_zt     CHAR(1) default 0,
  swsh_ry     VARCHAR2(11),
  swsh_htyj   VARCHAR2(500),
  cytssbjl    VARCHAR2(60),
  hgcjfs_dm   CHAR(1),
  zms_ckfpbz  CHAR(2),
  js_rq       DATE,
  js_zt       CHAR(1) default 0,
  js_yd       VARCHAR2(500),
  jgfstslx_dm CHAR(1),
  ckyzsbz     CHAR(1),
  msjgbz      CHAR(1)
)
;
comment on table RCGL_CQWSB_DATA
  is '长期未申报退税业务数据表';
comment on column RCGL_CQWSB_DATA.swjgdm
  is '税务机关代码';
comment on column RCGL_CQWSB_DATA.djxh
  is '登记序号';
comment on column RCGL_CQWSB_DATA.nsrsbh
  is '纳税人识别号';
comment on column RCGL_CQWSB_DATA.nsrmc
  is '纳税人名称';
comment on column RCGL_CQWSB_DATA.tsjsffdm
  is '退税计算方式';
comment on column RCGL_CQWSB_DATA.ckbgdh
  is '21位报关单号或20位代理出口货物证明号';
comment on column RCGL_CQWSB_DATA.ckrq_1
  is '出口日期';
comment on column RCGL_CQWSB_DATA.cksp_dm
  is '出口商品代码';
comment on column RCGL_CQWSB_DATA.gfhhgspmc
  is '规范化海关商品名称';
comment on column RCGL_CQWSB_DATA.jgfs_dm
  is '监管方式';
comment on column RCGL_CQWSB_DATA.mylaj
  is '出口美元离岸价';
comment on column RCGL_CQWSB_DATA.rmblaj
  is '出口人民币离岸价';
comment on column RCGL_CQWSB_DATA.dyjldw_dm
  is '法定单位';
comment on column RCGL_CQWSB_DATA.cksl
  is '出口数量';
comment on column RCGL_CQWSB_DATA.wsbsl
  is '剩余未申报数量';
comment on column RCGL_CQWSB_DATA.zssl
  is '征税税率';
comment on column RCGL_CQWSB_DATA.tsl
  is '退税率';
comment on column RCGL_CQWSB_DATA.sjly
  is '数据来源（抽取服务用SYSTEM/依职权用税务人员代码）';
comment on column RCGL_CQWSB_DATA.cjrq
  is '新增日期';
comment on column RCGL_CQWSB_DATA.zmtbz
  is '征免税类型（1征税/2免税/3不退税/0可退税）';
comment on column RCGL_CQWSB_DATA.qyqr_rq
  is '企业确认时间';
comment on column RCGL_CQWSB_DATA.qyqr_zt
  is '企业确认状态（0未确认/1适用征税/2适用免税/3已全部退税/4待申报退税，默认“未确认”）';
comment on column RCGL_CQWSB_DATA.zms_sbssq
  is '申报所属期';
comment on column RCGL_CQWSB_DATA.zs_ysxse
  is '应税销售额';
comment on column RCGL_CQWSB_DATA.zs_jtxxse
  is '计提销项税额';
comment on column RCGL_CQWSB_DATA.zms_ckfphm
  is '出口发票号码';
comment on column RCGL_CQWSB_DATA.ms_msxse
  is '免税销售额';
comment on column RCGL_CQWSB_DATA.ms_jhpzhbz
  is '是否有进货凭证（有/无）';
comment on column RCGL_CQWSB_DATA.ms_jhpzh
  is '进货凭证号';
comment on column RCGL_CQWSB_DATA.ms_jxzcbz
  is '是否进项转出（是/否）';
comment on column RCGL_CQWSB_DATA.ms_jxzcssq
  is '进项转出所属期';
comment on column RCGL_CQWSB_DATA.ms_jxzcje
  is '进项转出金额';
comment on column RCGL_CQWSB_DATA.zms_fj
  is '附件';
comment on column RCGL_CQWSB_DATA.zms_bz
  is '备注';
comment on column RCGL_CQWSB_DATA.wsb_yylx
  is '待申报原因类型（信息不齐/单证未收齐/尚未收汇/稽查/其他）';
comment on column RCGL_CQWSB_DATA.wsb_yysm
  is '待申报具体原因（选其他时填写）';
comment on column RCGL_CQWSB_DATA.swsh_rq
  is '税务审核时间';
comment on column RCGL_CQWSB_DATA.swsh_zt
  is '税局审核状态（0未审核/1审核通过/2审核未通过，默认“未审核”）';
comment on column RCGL_CQWSB_DATA.swsh_ry
  is '税务审核人员';
comment on column RCGL_CQWSB_DATA.swsh_htyj
  is '回退意见（审核未通过填写）';
comment on column RCGL_CQWSB_DATA.cytssbjl
  is '参与退税申报记录';
comment on column RCGL_CQWSB_DATA.hgcjfs_dm
  is '成交方式';
comment on column RCGL_CQWSB_DATA.zms_ckfpbz
  is '是否开具出口发票（是/否，否的时候前台显示无票销售）';
comment on column RCGL_CQWSB_DATA.js_rq
  is '机审时间';
comment on column RCGL_CQWSB_DATA.js_zt
  is '机审状态（0未审核/1审核通过/2审核有疑点，默认“未审核”）';
comment on column RCGL_CQWSB_DATA.js_yd
  is '机审疑点（机审有疑点时填写）';
comment on column RCGL_CQWSB_DATA.jgfstslx_dm
  is '监管方式退税类型代码';
comment on column RCGL_CQWSB_DATA.ckyzsbz
  is '监管出口应征税标志';
comment on column RCGL_CQWSB_DATA.msjgbz
  is '免税监管标志';
create index IDX_RCGL_CQWSB_DATA_CJRQ on RCGL_CQWSB_DATA (CJRQ)
  nologging;
alter table RCGL_CQWSB_DATA
  add constraint PK_RCGL_CQWSB_DATA primary key (DJXH, CKBGDH);
alter index PK_RCGL_CQWSB_DATA nologging;

prompt
prompt Creating table TMP_20241117_TSLTZ
prompt =================================
prompt
create table TMP_20241117_TSLTZ
(
  xh   NUMBER,
  spdm VARCHAR2(20),
  spmc VARCHAR2(1000),
  tzlx CHAR(1)
)
;
create index IDX_TMP_TSLTZ_20241117 on TMP_20241117_TSLTZ (TZLX, SPDM);

prompt
prompt Creating table TMP_20250121_QY_01
prompt =================================
prompt
create table TMP_20250121_QY_01
(
  djxh NUMBER(20),
  xh   NUMBER(20)
)
;
comment on column TMP_20250121_QY_01.djxh
  is '登记序号';
create index IDX_TMP_QY_20250121_01 on TMP_20250121_QY_01 (DJXH);

prompt
prompt Creating table TMP_20250121_QY_02
prompt =================================
prompt
create table TMP_20250121_QY_02
(
  djxh        NUMBER(20),
  ajybfjsxse  NUMBER(18,2),
  tsswjg_dm_1 CHAR(11),
  mylaj       NUMBER(18,2),
  rmblaj      NUMBER(18,2),
  ckxsemy     NUMBER(18,2),
  ckxsermb    NUMBER(18,2),
  ytse_1      NUMBER(18,6),
  mdse        NUMBER(18,6)
)
;
comment on column TMP_20250121_QY_02.djxh
  is '登记序号';
comment on column TMP_20250121_QY_02.tsswjg_dm_1
  is '退税税务机关代码';
comment on column TMP_20250121_QY_02.ckxsemy
  is '出口销售额（美元）';
comment on column TMP_20250121_QY_02.ckxsermb
  is '出口销售额（人民币）';
comment on column TMP_20250121_QY_02.ytse_1
  is '应退税额';
comment on column TMP_20250121_QY_02.mdse
  is '免抵税额';
create index IDX_TMP_QY_20250121_02 on TMP_20250121_QY_02 (DJXH);

prompt
prompt Creating table TMP_20250220_13300910000
prompt =======================================
prompt
create table TMP_20250220_13300910000
(
  djxh        NUMBER(20) not null,
  ydtlyuuid   VARCHAR2(32) not null,
  skssswjg_dm CHAR(11)
)
;
alter table TMP_20250220_13300910000
  add constraint PK_TMP_13300910000 primary key (DJXH, YDTLYUUID);

prompt
prompt Creating table TMP_20250320_KJCKFP
prompt ==================================
prompt
create table TMP_20250320_KJCKFP
(
  djxh           NUMBER(20),
  tsswjg_dm_1    CHAR(11),
  nsrmc          VARCHAR2(300),
  shxyno         VARCHAR2(20),
  hgqydm         VARCHAR2(20),
  ckhwtmsjsff_dm CHAR(1),
  mylaj_0110     NUMBER(18,2),
  rmblaj_0110    NUMBER(18,2),
  mylaj_all      NUMBER(18,2),
  rmblaj_all     NUMBER(18,2)
)
;
create index IDX_TMP_KJCKFP_CKQY on TMP_20250320_KJCKFP (DJXH);

prompt
prompt Creating table TMP_20250403_QY_01
prompt =================================
prompt
create table TMP_20250403_QY_01
(
  xh     NUMBER(20),
  nsrmc  VARCHAR2(300),
  shxyno VARCHAR2(20),
  djxh   NUMBER(20),
  qysfba CHAR(1),
  a23tse NUMBER(18,2)
)
;
create index IDX_TMP_QY_20250403_01 on TMP_20250403_QY_01 (XH);

prompt
prompt Creating table TMP_20250407_QY_01
prompt =================================
prompt
create table TMP_20250407_QY_01
(
  xh     NUMBER(20),
  nsrmc  VARCHAR2(300),
  shxyno VARCHAR2(20),
  djxh   NUMBER(20),
  swjg   VARCHAR2(11),
  qylx   CHAR(1)
)
;
create index IDX_TMP_QY_20250407_01 on TMP_20250407_QY_01 (XH);

prompt
prompt Creating table TMP_20250417_QY_01
prompt =================================
prompt
create table TMP_20250417_QY_01
(
  xh          NUMBER(20) not null,
  nsrmc       VARCHAR2(300),
  hgqydm      VARCHAR2(20),
  nsrsbh      VARCHAR2(20),
  djxh        NUMBER(20),
  tsswjgdm    CHAR(11),
  zgswjgdm    CHAR(11),
  nsrzt_dm    CHAR(2),
  nsrzt_mc    VARCHAR2(20),
  djzclx_dm   CHAR(3),
  djzclx_mc   VARCHAR2(20),
  sfybnsr     CHAR(1),
  sfxgmnsr    CHAR(1),
  barq        DATE,
  cktsqylx_dm VARCHAR2(2),
  tmse        NUMBER(18,6),
  tse         NUMBER(18,6),
  tse2024     NUMBER(18,6),
  tse2025     NUMBER(18,6),
  zzsmse      NUMBER(18,6)
)
;
comment on column TMP_20250417_QY_01.xh
  is '序号';
comment on column TMP_20250417_QY_01.nsrmc
  is '名称';
comment on column TMP_20250417_QY_01.hgqydm
  is '海关代码';
comment on column TMP_20250417_QY_01.nsrsbh
  is '税号';
comment on column TMP_20250417_QY_01.djxh
  is '登记序号';
comment on column TMP_20250417_QY_01.tsswjgdm
  is '退税税务机关代码';
comment on column TMP_20250417_QY_01.zgswjgdm
  is '主管税务机关代码';
comment on column TMP_20250417_QY_01.nsrzt_dm
  is '纳税人状态DM';
comment on column TMP_20250417_QY_01.nsrzt_mc
  is '纳税人状态MC';
comment on column TMP_20250417_QY_01.djzclx_dm
  is '登记注册类型DM';
comment on column TMP_20250417_QY_01.djzclx_mc
  is '企业类型';
comment on column TMP_20250417_QY_01.sfybnsr
  is '是否一般纳税人';
comment on column TMP_20250417_QY_01.sfxgmnsr
  is '是否小规模纳税人';
comment on column TMP_20250417_QY_01.barq
  is '备案日期';
comment on column TMP_20250417_QY_01.cktsqylx_dm
  is '出口退税企业类型代码';
comment on column TMP_20250417_QY_01.tmse
  is '2024年-2025年一季度办理出口退（免）税额（元）';
comment on column TMP_20250417_QY_01.tse
  is '其中：出口退税额（元）';
comment on column TMP_20250417_QY_01.tse2024
  is '其中：2024年全年办理出口退税额（元）
';
comment on column TMP_20250417_QY_01.tse2025
  is '其中：2025年第一季度办理出口退税额（元）';
comment on column TMP_20250417_QY_01.zzsmse
  is '增值税免税额（元）';
alter table TMP_20250417_QY_01
  add constraint PK_TMP_QY_20250417_01 primary key (XH);

prompt
prompt Creating table TMP_20250428_QY_01
prompt =================================
prompt
create table TMP_20250428_QY_01
(
  xh     NUMBER(20),
  djxh   NUMBER(20),
  nsrmc  VARCHAR2(300),
  shxyno VARCHAR2(20),
  nsrzt  VARCHAR2(20),
  zgswjg VARCHAR2(60)
)
;
create index IDX_TMP_QY_20250428_01_D on TMP_20250428_QY_01 (DJXH);
create index IDX_TMP_QY_20250428_01_X on TMP_20250428_QY_01 (XH);

prompt
prompt Creating table TMP_20250507_QY_01
prompt =================================
prompt
create table TMP_20250507_QY_01
(
  xh     NUMBER(20),
  djxh   NUMBER(20),
  shxyno VARCHAR2(20),
  nsrmc  VARCHAR2(300)
)
;
create index IDX_TMP_QY_20250507_01_D on TMP_20250507_QY_01 (DJXH)
  nologging;
create index IDX_TMP_QY_20250507_01_X on TMP_20250507_QY_01 (XH)
  nologging;

prompt
prompt Creating table TMP_20250521_QY_01
prompt =================================
prompt
create table TMP_20250521_QY_01
(
  xh     NUMBER(20),
  shxyno VARCHAR2(20),
  nsrmc  VARCHAR2(300),
  djxh   NUMBER(20)
)
;

prompt
prompt Creating table TMP_20250612_QY_01
prompt =================================
prompt
create table TMP_20250612_QY_01
(
  xh     NUMBER(20),
  zzjgdm VARCHAR2(20),
  nsrmc  VARCHAR2(300),
  shxyno VARCHAR2(20),
  djxh   NUMBER(20)
)
;

prompt
prompt Creating table TMP_20250619_QY_01
prompt =================================
prompt
create table TMP_20250619_QY_01
(
  wj             NUMBER(2),
  xh             NUMBER(20),
  nsrmc          VARCHAR2(300),
  shxyno         VARCHAR2(20),
  bgd18          VARCHAR2(18),
  spxh           VARCHAR2(3),
  djxh           NUMBER(20),
  ckbgdh         VARCHAR2(21),
  tsswjg_dm_1    VARCHAR2(11),
  cytssbjl       VARCHAR2(60),
  tssbsl         NUMBER(18,6),
  tssbrmblaj     NUMBER(18,2),
  tssbmylaj      NUMBER(18,2),
  tssbtse        NUMBER(18,2),
  babz           CHAR(1),
  ckhwtmsjsff_dm CHAR(1)
)
;
comment on column TMP_20250619_QY_01.ckhwtmsjsff_dm
  is '出口货物退(免)税计算方法代码';
create index IDX_TMP_QY_20250619_01_DC on TMP_20250619_QY_01 (DJXH, CKBGDH)
  nologging;
create index IDX_TMP_QY_20250619_01_SN on TMP_20250619_QY_01 (SHXYNO, NSRMC)
  nologging;

prompt
prompt Creating table TMP_20251022_QY_01
prompt =================================
prompt
create table TMP_20251022_QY_01
(
  xh     NUMBER(20),
  nsrmc  VARCHAR2(300),
  shxyno VARCHAR2(20),
  djxh   NUMBER(20)
)
;
create index IDX_TMP_QY_20251022_01 on TMP_20251022_QY_01 (XH);

prompt
prompt Creating table TMP_20251028_TJ
prompt ==============================
prompt
create table TMP_20251028_TJ
(
  nsrsbh VARCHAR2(20),
  nsrmc  VARCHAR2(200)
)
;

prompt
prompt Creating table TMP_20251119_9X10
prompt ================================
prompt
create table TMP_20251119_9X10
(
  uuid        VARCHAR2(32),
  djxh        NUMBER(20) not null,
  tsswjg_dm_1 CHAR(11),
  ckbgdh      VARCHAR2(21) not null,
  ckrq_1      DATE,
  ckyear      VARCHAR2(20),
  cksp_dm     VARCHAR2(20),
  cksp_dm4    VARCHAR2(20),
  jgfs_dm     CHAR(4),
  rmblaj      NUMBER(18,2),
  mylaj       NUMBER(18,2)
)
;

prompt
prompt Creating table TMP_20251208_NSRTJ
prompt =================================
prompt
create table TMP_20251208_NSRTJ
(
  xh     NUMBER(10),
  nsrmc  VARCHAR2(200),
  shxydm VARCHAR2(20),
  qyhgdm VARCHAR2(20)
)
;

prompt
prompt Creating table TMP_20260113_SDHCRQ
prompt ==================================
prompt
create table TMP_20260113_SDHCRQ
(
  nsrsbh       VARCHAR2(20),
  djxh         NUMBER(20),
  nsrmc        VARCHAR2(300),
  tsswjg_dm_sj VARCHAR2(100),
  rqtzdjsj     VARCHAR2(100),
  sdhcbgqkgl   VARCHAR2(100),
  hcjgsm       VARCHAR2(1000)
)
;
comment on column TMP_20260113_SDHCRQ.nsrsbh
  is '纳税人识别号';
comment on column TMP_20260113_SDHCRQ.djxh
  is '登记序号';
comment on column TMP_20260113_SDHCRQ.nsrmc
  is '纳税人名称';
comment on column TMP_20260113_SDHCRQ.tsswjg_dm_sj
  is '省级主管税务机关';
comment on column TMP_20260113_SDHCRQ.rqtzdjsj
  is '容缺台账登记时间';
comment on column TMP_20260113_SDHCRQ.sdhcbgqkgl
  is '实地核查报告情况归类';
comment on column TMP_20260113_SDHCRQ.hcjgsm
  is '核查结果说明';

prompt
prompt Creating table TMP_20260113_TSLTZ
prompt =================================
prompt
create table TMP_20260113_TSLTZ
(
  xh   NUMBER,
  spdm VARCHAR2(20),
  spmc VARCHAR2(2000),
  tzlx CHAR(1)
)
;
create index IDX_TMP_TSLTZ_20260113 on TMP_20260113_TSLTZ (SPDM)
  nologging;

prompt
prompt Creating table TMP_20260113_TSLTZ_WQF
prompt =====================================
prompt
create table TMP_20260113_TSLTZ_WQF
(
  tzlx         CHAR(1),
  spdm         VARCHAR2(20),
  djxh         NUMBER(20),
  ckyear       VARCHAR2(4),
  zzmdgdqsz_dm CHAR(3),
  bgdfs        NUMBER(10),
  hwmxts       NUMBER(10),
  mylaj        NUMBER(18,2),
  rmblaj       NUMBER(20,2)
)
;
comment on column TMP_20260113_TSLTZ_WQF.tzlx
  is '调整类型';
comment on column TMP_20260113_TSLTZ_WQF.spdm
  is '商品代码';
comment on column TMP_20260113_TSLTZ_WQF.djxh
  is '登记序号';
comment on column TMP_20260113_TSLTZ_WQF.ckyear
  is '出口年份';
comment on column TMP_20260113_TSLTZ_WQF.bgdfs
  is '报关单份数';
comment on column TMP_20260113_TSLTZ_WQF.hwmxts
  is '货物明细条数';
comment on column TMP_20260113_TSLTZ_WQF.mylaj
  is '出口销售（美元）';
comment on column TMP_20260113_TSLTZ_WQF.rmblaj
  is '人民币离岸价';

prompt
prompt Creating table TMP_20260113_ZLQY
prompt ================================
prompt
create table TMP_20260113_ZLQY
(
  xh        NUMBER(20),
  shxyno    VARCHAR2(20),
  nsrmc     VARCHAR2(300),
  djxh      NUMBER(20),
  mylaj2025 NUMBER(18,2),
  tse2025   NUMBER(18,6),
  mylaj2024 NUMBER(18,2),
  tse2024   NUMBER(18,6),
  mde2025   NUMBER(18,6),
  mde2024   NUMBER(18,6)
)
;
comment on column TMP_20260113_ZLQY.mylaj2025
  is '美元离岸价';
comment on column TMP_20260113_ZLQY.tse2025
  is '免抵退税额';
comment on column TMP_20260113_ZLQY.mylaj2024
  is '美元离岸价';
comment on column TMP_20260113_ZLQY.tse2024
  is '免抵退税额';
comment on column TMP_20260113_ZLQY.mde2025
  is '免抵退税额';
comment on column TMP_20260113_ZLQY.mde2024
  is '免抵退税额';
create index IDX_TMP_ZLQY_20260113 on TMP_20260113_ZLQY (XH);

prompt
prompt Creating table TMP_20260225_NCPJJKC
prompt ===================================
prompt
create table TMP_20260225_NCPJJKC
(
  djxh     NUMBER(20),
  nsrsbh   VARCHAR2(20),
  nsrmc    VARCHAR2(300),
  nsrzt_dm VARCHAR2(20),
  ds_dm    VARCHAR2(20),
  qx       VARCHAR2(300),
  ks       VARCHAR2(300),
  hy       VARCHAR2(300),
  se       NUMBER(18,2)
)
;

prompt
prompt Creating table TMP_20260311_HTH_1
prompt =================================
prompt
create table TMP_20260311_HTH_1
(
  dq     VARCHAR2(20),
  djxh   NUMBER(20),
  shxydm VARCHAR2(20),
  nsrmc  VARCHAR2(200),
  hth    VARCHAR2(2000),
  jsrq   VARCHAR2(10),
  jsje   NUMBER(18,2),
  khmc   VARCHAR2(2000),
  hwmc   VARCHAR2(2000),
  bgdh   VARCHAR2(4000)
)
;
create index IDX_TMP_HTH_20260311_1_DB on TMP_20260311_HTH_1 (DJXH, BGDH)
  nologging;

prompt
prompt Creating table TMP_20260311_HTH_2
prompt =================================
prompt
create table TMP_20260311_HTH_2
(
  djxh         NUMBER(20),
  nsrmc        VARCHAR2(200),
  ckbgdh       VARCHAR2(21),
  ckrq_1       DATE,
  hth          VARCHAR2(2000),
  gfhhgspmc    VARCHAR2(500),
  zzmdgdqsz_dm CHAR(3),
  ckmylaj      NUMBER(18,2),
  ckrmblaj     NUMBER(18,2),
  ssq          VARCHAR2(60),
  sbpc         VARCHAR2(75),
  sbmylaj      NUMBER(18,2),
  sbjsje       NUMBER(18,2),
  sbtmse       NUMBER(18,6),
  sjly         VARCHAR2(10),
  ckhth        VARCHAR2(2000),
  hwmc         VARCHAR2(2000),
  bgdh         VARCHAR2(2000)
)
;
create index IDX_TMP_HTH_20260311_2 on TMP_20260311_HTH_2 (DJXH, CKBGDH)
  nologging;

prompt
prompt Creating table TMP_20260311_HTH_3
prompt =================================
prompt
create table TMP_20260311_HTH_3
(
  djxh         NUMBER(20),
  nsrmc        VARCHAR2(200),
  ckbgdh       VARCHAR2(21),
  ckrq_1       DATE,
  ckhth        VARCHAR2(2000),
  gfhhgspmc    VARCHAR2(500),
  zzmdgdqsz_dm CHAR(3),
  ckmylaj      NUMBER(18,2),
  ckrmblaj     NUMBER(18,2),
  ssq          VARCHAR2(60),
  sbpc         VARCHAR2(75),
  sbmylaj      NUMBER(18,2),
  sbjsje       NUMBER(18,2),
  sbtmse       NUMBER(18,6),
  sjly         VARCHAR2(10),
  hth          VARCHAR2(2000),
  hwmc         VARCHAR2(2000),
  bgdh         VARCHAR2(2000)
)
;
create index IDX_TMP_HTH_20260311_3 on TMP_20260311_HTH_3 (DJXH, CKBGDH)
  nologging;

prompt
prompt Creating table TMP_20260311_HTH_4
prompt =================================
prompt
create table TMP_20260311_HTH_4
(
  dq     VARCHAR2(20),
  djxh   NUMBER(20),
  shxydm VARCHAR2(20),
  nsrmc  VARCHAR2(200),
  hth    VARCHAR2(2000),
  jsrq   VARCHAR2(10),
  jsje   NUMBER(18,2),
  khmc   VARCHAR2(2000),
  hwmc   VARCHAR2(2000),
  bgdh   VARCHAR2(2000)
)
;
create index IDX_TMP_HTH_20260311_4_DB on TMP_20260311_HTH_4 (DJXH, BGDH)
  nologging;

prompt
prompt Creating table TMP_20260313_1039_1
prompt ==================================
prompt
create table TMP_20260313_1039_1
(
  djxh   NUMBER(20) not null,
  ckyear VARCHAR2(4),
  fs     NUMBER(10),
  bs     NUMBER(10),
  rmblaj NUMBER(18,2),
  mylaj  NUMBER(18,2),
  sjly   VARCHAR2(20)
)
;
comment on column TMP_20260313_1039_1.ckyear
  is '出口年份';
comment on column TMP_20260313_1039_1.fs
  is '份数';
comment on column TMP_20260313_1039_1.bs
  is '笔数';
comment on column TMP_20260313_1039_1.rmblaj
  is '人民币离岸价';
comment on column TMP_20260313_1039_1.mylaj
  is '美元离岸价';
comment on column TMP_20260313_1039_1.sjly
  is '数据来源（BGD201/WQFBGD201)';

prompt
prompt Creating table TMP_20260313_1039_2
prompt ==================================
prompt
create table TMP_20260313_1039_2
(
  djxh         NUMBER(20) not null,
  ckyear       VARCHAR2(4),
  fs           NUMBER(10),
  bs           NUMBER(10),
  rmblaj       NUMBER(18,2),
  mylaj        NUMBER(18,2),
  sjly         VARCHAR2(20),
  msxse_ybnsr  NUMBER(18,2),
  msxse_xgmnsr NUMBER(18,2)
)
;
comment on column TMP_20260313_1039_2.ckyear
  is '出口年份';
comment on column TMP_20260313_1039_2.fs
  is '份数';
comment on column TMP_20260313_1039_2.bs
  is '笔数';
comment on column TMP_20260313_1039_2.rmblaj
  is '人民币离岸价';
comment on column TMP_20260313_1039_2.mylaj
  is '美元离岸价';
comment on column TMP_20260313_1039_2.sjly
  is '数据来源（BGD201/WQFBGD201)';
comment on column TMP_20260313_1039_2.msxse_ybnsr
  is '免税销售额_一般纳税人';
comment on column TMP_20260313_1039_2.msxse_xgmnsr
  is '免税销售额_小规模纳税人';
create unique index IDX_TMP_1039_20260313_2 on TMP_20260313_1039_2 (DJXH, CKYEAR)
  nologging;

prompt
prompt Creating table TMP_20260408_SHYDCL_1
prompt ====================================
prompt
create table TMP_20260408_SHYDCL_1
(
  djxh   NUMBER(20),
  shxydm VARCHAR2(20),
  ssq    VARCHAR2(60),
  sbpc   VARCHAR2(75)
)
;
comment on column TMP_20260408_SHYDCL_1.ssq
  is '所属期';
comment on column TMP_20260408_SHYDCL_1.sbpc
  is '申报批次';

prompt
prompt Creating table TMP_20260408_SHYDCL_2
prompt ====================================
prompt
create table TMP_20260408_SHYDCL_2
(
  djxh   NUMBER(20),
  shxydm VARCHAR2(20),
  ckbgdh VARCHAR2(21)
)
;

prompt
prompt Creating table TMP_20260413_TSHKSZX_1
prompt =====================================
prompt
create table TMP_20260413_TSHKSZX_1
(
  tsswjg_dm_1 CHAR(11),
  swjgjc      VARCHAR2(150),
  djxh        NUMBER(20),
  nsrsbh      VARCHAR2(20),
  nsrmc       VARCHAR2(300),
  barq        DATE,
  bachrq      DATE,
  bachbz      CHAR(1),
  nsrzt_dm    CHAR(2),
  nsrztmc     VARCHAR2(30),
  yxqq_fzc    DATE,
  yxqq_fzczx  DATE,
  yxqq_zx     DATE,
  sehzrq_min  DATE,
  sehzrq_max  DATE,
  sehz_tse    NUMBER(18,6) default 0,
  sehzrq_100w DATE
)
;
comment on column TMP_20260413_TSHKSZX_1.tsswjg_dm_1
  is '退税税务机关代码';
comment on column TMP_20260413_TSHKSZX_1.swjgjc
  is '税务机构简称';
comment on column TMP_20260413_TSHKSZX_1.djxh
  is '登记序号';
comment on column TMP_20260413_TSHKSZX_1.nsrsbh
  is '纳税人识别号';
comment on column TMP_20260413_TSHKSZX_1.nsrmc
  is '纳税人名称';
comment on column TMP_20260413_TSHKSZX_1.barq
  is '备案日期';
comment on column TMP_20260413_TSHKSZX_1.bachrq
  is '备案撤回日期';
comment on column TMP_20260413_TSHKSZX_1.bachbz
  is '备案撤回标志';
comment on column TMP_20260413_TSHKSZX_1.nsrzt_dm
  is '纳税人状态';
comment on column TMP_20260413_TSHKSZX_1.nsrztmc
  is '纳税人状态名称';
comment on column TMP_20260413_TSHKSZX_1.yxqq_fzc
  is '有效期起_非正常';
comment on column TMP_20260413_TSHKSZX_1.yxqq_fzczx
  is '有效期起_非正常注销';
comment on column TMP_20260413_TSHKSZX_1.yxqq_zx
  is '有效期起_注销';
comment on column TMP_20260413_TSHKSZX_1.sehzrq_min
  is '税额核准日期_最早';
comment on column TMP_20260413_TSHKSZX_1.sehzrq_max
  is '税额核准日期_最迟';
comment on column TMP_20260413_TSHKSZX_1.sehz_tse
  is '税额核准_退税额';
comment on column TMP_20260413_TSHKSZX_1.sehzrq_100w
  is '税额核准日期_达100万';

prompt
prompt Creating table TMP_20260430_BGD_1
prompt =================================
prompt
create table TMP_20260430_BGD_1
(
  djxh   NUMBER(20) not null,
  ckbgdh VARCHAR2(21) not null
)
;

prompt
prompt Creating table TMP_20260509_1039_1
prompt ==================================
prompt
create table TMP_20260509_1039_1
(
  djxh       NUMBER(20) not null,
  ckyear     VARCHAR2(4),
  mylaj_1039 NUMBER(18,2),
  mylaj_all  NUMBER(18,2),
  sjly       VARCHAR2(20)
)
;
comment on column TMP_20260509_1039_1.djxh
  is '登记序号';
comment on column TMP_20260509_1039_1.ckyear
  is '出口年份';
comment on column TMP_20260509_1039_1.mylaj_1039
  is '美元离岸价_1039';
comment on column TMP_20260509_1039_1.mylaj_all
  is '美元离岸价_all';
comment on column TMP_20260509_1039_1.sjly
  is '数据来源（BGD/WQF/DLZM)';

prompt
prompt Creating table TMP_20260509_1039_2
prompt ==================================
prompt
create table TMP_20260509_1039_2
(
  djxh       NUMBER(20) not null,
  ckyear     VARCHAR2(4),
  mylaj_1039 NUMBER(18,2),
  mylaj_all  NUMBER(18,2),
  sjly       VARCHAR2(20),
  shjemy     NUMBER(18,2)
)
;
comment on column TMP_20260509_1039_2.djxh
  is '登记序号';
comment on column TMP_20260509_1039_2.ckyear
  is '出口年份';
comment on column TMP_20260509_1039_2.mylaj_1039
  is '美元离岸价_1039';
comment on column TMP_20260509_1039_2.mylaj_all
  is '美元离岸价_all';
comment on column TMP_20260509_1039_2.sjly
  is '数据来源（BGD/WQF/DLZM)';
comment on column TMP_20260509_1039_2.shjemy
  is '收汇金额美元';

prompt
prompt Creating table TMP_20260511_MDPP_1
prompt ==================================
prompt
create table TMP_20260511_MDPP_1
(
  djxh         NUMBER(20),
  tsswjg_dm_1  CHAR(11),
  nsrsbh       VARCHAR2(20) not null,
  shxydm       VARCHAR2(20),
  nsrmc        VARCHAR2(300) not null,
  nsrzt_dm     CHAR(2) not null,
  jnhyd_dm     CHAR(5),
  zzmdgdqsz_dm CHAR(3),
  gjhdqjc      VARCHAR2(75) not null,
  kasl         NUMBER(10),
  cke          NUMBER(18,2),
  tse          NUMBER(18,6)
)
;
comment on column TMP_20260511_MDPP_1.djxh
  is '登记序号';
comment on column TMP_20260511_MDPP_1.tsswjg_dm_1
  is '退税税务机关代码';
comment on column TMP_20260511_MDPP_1.jnhyd_dm
  is '境内货源地代码';
comment on column TMP_20260511_MDPP_1.zzmdgdqsz_dm
  is '最终目的国（地区）数字代码';
comment on column TMP_20260511_MDPP_1.gjhdqjc
  is '国家或地区简称';
comment on column TMP_20260511_MDPP_1.kasl
  is '数量';

prompt
prompt Creating table TMP_20260519_JLSJGJZ_1
prompt =====================================
prompt
create table TMP_20260519_JLSJGJZ_1
(
  djxh                  NUMBER(20) not null,
  bah                   VARCHAR2(12) not null,
  hxqsrq                DATE not null,
  hxjzrq                DATE not null,
  jsjkzz_mdthx          NUMBER(18,2),
  jsckzz_mdthx          NUMBER(18,2),
  jsjkzz_hxgbd          NUMBER(18,2),
  jsckzz_hxbgd          NUMBER(18,2),
  jsjkzz_hxgbd_0654     NUMBER(18,2),
  jsckzz_hxbgd_0654     NUMBER(18,2),
  jsjkzz_hxgbd_0654_zs  NUMBER(18,2),
  jsckzz_hxbgd_0654_zs  NUMBER(18,2),
  jsckzz_bgd201_0654    NUMBER(18,2),
  jsckzz_bgd201_0654_zs NUMBER(18,2)
)
;
comment on column TMP_20260519_JLSJGJZ_1.djxh
  is '登记序号';
comment on column TMP_20260519_JLSJGJZ_1.bah
  is '备案号';
comment on column TMP_20260519_JLSJGJZ_1.hxqsrq
  is '核销起始日期';
comment on column TMP_20260519_JLSJGJZ_1.hxjzrq
  is '核销截止日期';
comment on column TMP_20260519_JLSJGJZ_1.jsjkzz_mdthx
  is '计算进口总值（免抵退核销表来源）';
comment on column TMP_20260519_JLSJGJZ_1.jsckzz_mdthx
  is '计算出口总值（免抵退核销表来源）';
comment on column TMP_20260519_JLSJGJZ_1.jsjkzz_hxgbd
  is '计算进口总值（海关核销报关单来源）';
comment on column TMP_20260519_JLSJGJZ_1.jsckzz_hxbgd
  is '计算出口总值（海关核销报关单来源）';
comment on column TMP_20260519_JLSJGJZ_1.jsjkzz_hxgbd_0654
  is '计算进口总值（海关核销报关单来源0654）';
comment on column TMP_20260519_JLSJGJZ_1.jsckzz_hxbgd_0654
  is '计算出口总值（海关核销报关单来源0654）';
comment on column TMP_20260519_JLSJGJZ_1.jsjkzz_hxgbd_0654_zs
  is '计算进口总值（海关核销报关单来源0654征税商品）';
comment on column TMP_20260519_JLSJGJZ_1.jsckzz_hxbgd_0654_zs
  is '计算出口总值（海关核销报关单来源0654征税商品）';
comment on column TMP_20260519_JLSJGJZ_1.jsckzz_bgd201_0654
  is '计算出口总值（海关核销报关单来源）';
comment on column TMP_20260519_JLSJGJZ_1.jsckzz_bgd201_0654_zs
  is '计算出口总值（海关核销报关单来源0654征税商品）';
alter table TMP_20260519_JLSJGJZ_1
  add constraint PK_TMP_JLSJGJZ_20260519_1 primary key (DJXH, BAH, HXQSRQ, HXJZRQ);

prompt
prompt Creating table TMP_20260605_MDCK_1
prompt ==================================
prompt
create table TMP_20260605_MDCK_1
(
  xh             NUMBER(20) not null,
  nsrmc          VARCHAR2(300) not null,
  djxh           NUMBER(20),
  djrq           DATE,
  nsrzt_dm       VARCHAR2(2),
  nsrzglx_dm     VARCHAR2(3),
  yxqq           DATE,
  ckhwtmsjsff_dm CHAR(1),
  barq           DATE,
  rmblaj_bgd     NUMBER(18,2),
  rmblaj_tssb    NUMBER(18,2),
  zzs_msxse      NUMBER(18,2),
  zzs_qbxse      NUMBER(18,2),
  sds_jdsr       NUMBER(18,2),
  bachrq         DATE
)
;
comment on column TMP_20260605_MDCK_1.djrq
  is '登记日期（税务登记日期）';
comment on column TMP_20260605_MDCK_1.nsrzt_dm
  is '纳税人状态代码';
comment on column TMP_20260605_MDCK_1.nsrzglx_dm
  is '纳税人资格类型代码';
comment on column TMP_20260605_MDCK_1.yxqq
  is '有效期起';
comment on column TMP_20260605_MDCK_1.ckhwtmsjsff_dm
  is '出口货物退(免)税计算方法代码';
comment on column TMP_20260605_MDCK_1.barq
  is '备案日期（出口退税备案日期）';
comment on column TMP_20260605_MDCK_1.rmblaj_bgd
  is '报关单出口额';
comment on column TMP_20260605_MDCK_1.rmblaj_tssb
  is '退税申报出口额';

prompt
prompt Creating table TMP_20260608_FHQ_1
prompt =================================
prompt
create table TMP_20260608_FHQ_1
(
  xh    NUMBER(20),
  fhqmc VARCHAR2(300),
  nsrmc VARCHAR2(300),
  ds    VARCHAR2(30),
  qx    VARCHAR2(30),
  djxh  NUMBER(20),
  barq  DATE,
  tse   NUMBER(18,2)
)
;

prompt
prompt Creating table TMP_20260608_FHQ_2
prompt =================================
prompt
create table TMP_20260608_FHQ_2
(
  xh    NUMBER(20),
  fhqmc VARCHAR2(300),
  nsrmc VARCHAR2(300),
  ds    VARCHAR2(30),
  qx    VARCHAR2(50),
  djxh  NUMBER(20),
  barq  DATE,
  tse   NUMBER(18,2)
)
;

prompt
prompt Creating table TMP_20260608_FHQ_3
prompt =================================
prompt
create table TMP_20260608_FHQ_3
(
  xh    NUMBER(20),
  fhqmc VARCHAR2(300),
  nsrmc VARCHAR2(300),
  ds    VARCHAR2(30),
  qx    VARCHAR2(30),
  djxh  NUMBER(20),
  barq  DATE,
  tse   NUMBER(18,2)
)
;

prompt
prompt Creating table TMP_20260618_ZFFP
prompt ================================
prompt
create table TMP_20260618_ZFFP
(
  xh    NUMBER(20),
  djxh  NUMBER(20),
  jhpzh VARCHAR2(30)
)
;
create index IDX_TMP_20260618_ZFFP on TMP_20260618_ZFFP (DJXH, JHPZH);

prompt
prompt Creating table TMP_20260710_CS202611FJ8
prompt =======================================
prompt
create table TMP_20260710_CS202611FJ8
(
  cksp_dm VARCHAR2(20) not null,
  ckspmc  VARCHAR2(500),
  bz      VARCHAR2(3000)
)
;
comment on table TMP_20260710_CS202611FJ8
  is '财税2026年11号公告附件8所列商品';
comment on column TMP_20260710_CS202611FJ8.cksp_dm
  is '出口商品代码';
comment on column TMP_20260710_CS202611FJ8.ckspmc
  is '出口商品名称';
comment on column TMP_20260710_CS202611FJ8.bz
  is '备注';

prompt
prompt Creating table TMP_20260710_XGM
prompt ===============================
prompt
create table TMP_20260710_XGM
(
  djxh       NUMBER(20) not null,
  rmblaj_qf  NUMBER(18,2),
  rmblaj_wqf NUMBER(18,2)
)
;
alter table TMP_20260710_XGM
  add constraint PK_TMP_20260710_XGM primary key (DJXH);

prompt
prompt Creating table TMP_20260710_XGM_1
prompt =================================
prompt
create table TMP_20260710_XGM_1
(
  djxh        NUMBER(20) not null,
  rmblaj_qf   NUMBER(18,2),
  rmblaj_wqf  NUMBER(18,2),
  ckmsxse     NUMBER(18,2),
  yzxse       NUMBER(18,2),
  msxse       NUMBER(18,2),
  rmblaj_1039 NUMBER(18,2)
)
;
alter table TMP_20260710_XGM_1
  add constraint PK_TMP_20260710_XGM_1 primary key (DJXH);

prompt
prompt Creating table TMP_20260715_CKBDTJ_1
prompt ====================================
prompt
create table TMP_20260715_CKBDTJ_1
(
  djxh    NUMBER(20) not null,
  cksp_dm VARCHAR2(20) not null,
  ckyear  CHAR(4) not null,
  mylaj   NUMBER(18,2) not null
)
;
alter table TMP_20260715_CKBDTJ_1
  add constraint PK_TMP_20260715_CKBDTJ_1 primary key (DJXH, CKSP_DM, CKYEAR);

prompt
prompt Creating table TMP_20260715_HZCKTJ_1
prompt ====================================
prompt
create table TMP_20260715_HZCKTJ_1
(
  djxh   NUMBER(20) not null,
  rmblaj NUMBER(18,2) not null,
  ckyear CHAR(4) not null
)
;
alter table TMP_20260715_HZCKTJ_1
  add constraint PK_TMP_20260715_HZCKTJ_1 primary key (DJXH, CKYEAR);

prompt
prompt Creating table TMP_20260731_JGFS
prompt ================================
prompt
create table TMP_20260731_JGFS
(
  tsswjg_dm_1 CHAR(11),
  djxh        NUMBER(20) not null,
  ckbgdh      VARCHAR2(21) not null
)
;

prompt
prompt Creating table TMP_LCSLID
prompt =========================
prompt
create table TMP_LCSLID
(
  lcslid VARCHAR2(32),
  yj     NUMBER
)
;
comment on column TMP_LCSLID.lcslid
  is '流程实例ID';

prompt
prompt Creating table TMP_TDCODE_JLJG
prompt ==============================
prompt
create table TMP_TDCODE_JLJG
(
  code      VARCHAR2(30) not null,
  name      VARCHAR2(200),
  jckbz     VARCHAR2(1) not null,
  fullname  VARCHAR2(2000),
  js_flag_1 NUMBER,
  ljcp      VARCHAR2(20),
  flag_1    NUMBER,
  note      VARCHAR2(200)
)
;
alter table TMP_TDCODE_JLJG
  add constraint PK_TMP_TDCODE_JLJG primary key (CODE, JCKBZ);

prompt
prompt Creating table TSGZ_DATA_FQYCKJSBTJ
prompt ===================================
prompt
create table TSGZ_DATA_FQYCKJSBTJ
(
  tsswjg_dm_1 CHAR(11),
  djxh        NUMBER(20) not null,
  nsrmc       VARCHAR2(300),
  nsrsbh      VARCHAR2(20),
  rmblaj_all  NUMBER(18,2),
  rmblaj_tsl  NUMBER(18,2),
  rmblaj_tssb NUMBER(18,2),
  zzsmsxse    NUMBER(18,2),
  sbl_tssb    NUMBER(6,2),
  sbl_zzs     NUMBER(6,2)
)
;
comment on table TSGZ_DATA_FQYCKJSBTJ
  is '态势感知_分企业出口及申报统计';
comment on column TSGZ_DATA_FQYCKJSBTJ.tsswjg_dm_1
  is '退税税务机关代码';
comment on column TSGZ_DATA_FQYCKJSBTJ.djxh
  is '登记序号';
comment on column TSGZ_DATA_FQYCKJSBTJ.nsrmc
  is '纳税人名称';
comment on column TSGZ_DATA_FQYCKJSBTJ.nsrsbh
  is '纳税人识别号';
comment on column TSGZ_DATA_FQYCKJSBTJ.rmblaj_all
  is '出口额（出口日期自202601开始）';
comment on column TSGZ_DATA_FQYCKJSBTJ.rmblaj_tsl
  is '其中可退税出口额（出口日期自202601开始，监管方式可退税，且商品有退税率）';
comment on column TSGZ_DATA_FQYCKJSBTJ.rmblaj_tssb
  is '出口退(免)税申报额（出口日期自202601开始，按电子信息离岸价）';
comment on column TSGZ_DATA_FQYCKJSBTJ.zzsmsxse
  is '增值税免税销售额';
comment on column TSGZ_DATA_FQYCKJSBTJ.sbl_tssb
  is '退(免)税申报率';
comment on column TSGZ_DATA_FQYCKJSBTJ.sbl_zzs
  is '增值税申报率';
create index IDX_TSGZ_DATA_FQYCKJSBTJ_T on TSGZ_DATA_FQYCKJSBTJ (TSSWJG_DM_1, RMBLAJ_ALL)
  nologging;
alter table TSGZ_DATA_FQYCKJSBTJ
  add constraint PK_TSGZ_DATA_FQYCKJSBTJ primary key (DJXH);
alter index PK_TSGZ_DATA_FQYCKJSBTJ nologging;

prompt
prompt Creating table YJ_BGDGZXX_GCB
prompt =============================
prompt
create table YJ_BGDGZXX_GCB
(
  djxh   NUMBER(20) not null,
  ckbgdh VARCHAR2(21) not null,
  gzxx   VARCHAR2(1000),
  czr_dm VARCHAR2(15) not null,
  czrq   DATE not null
)
;
comment on table YJ_BGDGZXX_GCB
  is '报关单关注信息表';
comment on column YJ_BGDGZXX_GCB.djxh
  is '金三企业登记序号';
comment on column YJ_BGDGZXX_GCB.ckbgdh
  is '出口报关单号（21位）/代理证明号（20位）';
comment on column YJ_BGDGZXX_GCB.gzxx
  is '关注信息';
comment on column YJ_BGDGZXX_GCB.czr_dm
  is '最后一次操作人员代码，系统自动记录';
comment on column YJ_BGDGZXX_GCB.czrq
  is '最后一次操作日期，系统自动记录';
alter table YJ_BGDGZXX_GCB
  add constraint PK_YJ_BGDGZXX_GCB primary key (DJXH, CKBGDH);

prompt
prompt Creating sequence SEQ_FXGL_DATA_FXYDJG
prompt ======================================
prompt
create sequence SEQ_FXGL_DATA_FXYDJG
minvalue 100000000
maxvalue 9999999999999
start with 100057818
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_GS_DJ_CKTMSDAB_KZ
prompt =======================================
prompt
create sequence SEQ_GS_DJ_CKTMSDAB_KZ
minvalue 1
maxvalue 9999999999999999999999999999
start with 52161
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_MSG_PUSH_DATA
prompt ===================================
prompt
create sequence SEQ_MSG_PUSH_DATA
minvalue 1
maxvalue 9999999999
start with 484734
increment by 1
cache 10;

prompt
prompt Creating function COMPUTE_BLDATE
prompt ================================
prompt
CREATE OR REPLACE FUNCTION COMPUTE_BLDATE
/*
  编制人:毛小东
  编制日期:202109
  功能:计算两个日期之间，减去节假日，返回工作日天数
  参数:SL_DATE 开始日期，SB_DATE 结束日期
  返回：NUMBER 天数
 */
(
  END_DATE DATE,
  BEGIN_DATE DATE
)
RETURN NUMBER
IS
  V_END_DATE DATE;
  V_BEGIN_DATE DATE;
  V_BETWEENDAYS NUMBER;
  V_JJRDAYS INTEGER;
BEGIN
  V_END_DATE:=END_DATE;
  IF V_END_DATE IS NULL THEN
    V_END_DATE:=SYSDATE;
  END IF;

  V_BEGIN_DATE:=BEGIN_DATE;
  IF V_BEGIN_DATE IS NULL THEN
    V_BEGIN_DATE:=SYSDATE;
  END IF;

  --传递的开始日期只有日期，没有时间，以当天8点30分为开始时间
  IF V_BEGIN_DATE=TRUNC(V_BEGIN_DATE, 'DD') THEN
    V_BEGIN_DATE:=TRUNC(V_BEGIN_DATE, 'DD') + 0.3542;
  END IF;
  --传递的开始日期在下午17点30分之后，以次日8点30分为开始时间
  IF V_BEGIN_DATE>=TRUNC(V_BEGIN_DATE, 'DD') + 0.7295 THEN
    V_BEGIN_DATE:=TRUNC(V_BEGIN_DATE, 'DD') + 1.3542;
  END IF;
  --剔除开始日期是节假日，以后续第一个工作日8点30分为开始时间
  SELECT COUNT(*) INTO V_JJRDAYS FROM PUB_JJR WHERE JJR_DATE = TRUNC(V_BEGIN_DATE,'DD');
  LOOP
    EXIT WHEN V_JJRDAYS=0;
    V_BEGIN_DATE := TRUNC(V_BEGIN_DATE, 'DD') + 1.3542;
    SELECT COUNT(*) INTO V_JJRDAYS FROM PUB_JJR WHERE JJR_DATE = TRUNC(V_BEGIN_DATE,'DD');
  END LOOP;

  --传递的结束日期只有日期，没有时间，以当天17点30分为结束时间
  IF V_END_DATE=TRUNC(V_END_DATE, 'DD') THEN
    V_END_DATE:=TRUNC(V_END_DATE, 'DD') + 0.7295;
  END IF;
  --传递的结束日期在下午17点30分之后，以当天17点30分为结束时间
  IF V_END_DATE>=TRUNC(V_END_DATE, 'DD') + 0.7295 THEN
    V_END_DATE:=TRUNC(V_END_DATE, 'DD') + 0.7295;
  END IF;
  --剔除结束日期是节假日，以前一个工作日17点30分为结束时间
  SELECT COUNT(*) INTO V_JJRDAYS FROM PUB_JJR WHERE JJR_DATE = TRUNC(V_END_DATE,'DD');
  LOOP
    EXIT WHEN V_JJRDAYS=0;
    V_END_DATE := TRUNC(V_END_DATE, 'DD') - 1 + 0.7295;
    SELECT COUNT(*) INTO V_JJRDAYS FROM PUB_JJR WHERE JJR_DATE = TRUNC(V_END_DATE,'DD');
  END LOOP;

  --起始、截止日期均非节假日时，计算日期差
  V_BETWEENDAYS := V_END_DATE - V_BEGIN_DATE;

  --剔除日期间隔中的节假日天数
  SELECT COUNT(*) INTO V_JJRDAYS FROM PUB_JJR WHERE JJR_DATE > V_BEGIN_DATE AND JJR_DATE < V_END_DATE;
  V_BETWEENDAYS := V_BETWEENDAYS - V_JJRDAYS;

  IF V_BETWEENDAYS < 0 THEN
    RETURN (0);
  ELSE
    RETURN(ROUND(V_BETWEENDAYS,4));
  END IF;
END COMPUTE_BLDATE;
/

prompt
prompt Creating function COMPUTE_BLJZDATE
prompt ==================================
prompt
CREATE OR REPLACE FUNCTION COMPUTE_BLJZDATE
/*
  编制人:毛小东
  编制日期:202109
  功能:根据分类管理等级，增加工作日，其中A+5, B+10, C+15, D+20，默认20，返回截止日期
  参数:CKQYGLLB_DM 分类管理等级A,B,C,D  ；SL_DATE 开始受理日期
  返回：date 办理截止日期
 */
(
  V_IN_CKQYGLLB_DM varchar2,
  V_IN_SL_DATE date
)
return date
is
  v_adddays integer;
  v_jjrdays integer;
  v_zz_date date;
  i integer;
begin
  IF V_IN_SL_DATE IS NULL THEN
    RETURN NULL;
  END IF;

  IF V_IN_CKQYGLLB_DM = 'A' OR V_IN_CKQYGLLB_DM = 'a' THEN
    v_adddays := 5;
  ELSIF V_IN_CKQYGLLB_DM = 'B' OR V_IN_CKQYGLLB_DM = 'b' THEN
    v_adddays := 10;
  ELSIF V_IN_CKQYGLLB_DM = 'C' OR V_IN_CKQYGLLB_DM = 'c' THEN
    v_adddays := 15;
  ELSIF V_IN_CKQYGLLB_DM = 'D' OR V_IN_CKQYGLLB_DM = 'd' THEN
    v_adddays := 20;
  ELSE
    v_adddays := 20;
  END IF;

  v_zz_date := V_IN_SL_DATE;
  --传递的开始日期只有日期，没有时间，以当天8点30分为开始时间
  IF v_zz_date=TRUNC(v_zz_date, 'DD') THEN
    v_zz_date:=TRUNC(v_zz_date, 'DD') + 0.3542;
  END IF;
  --传递的开始日期在下午17点30分之后，以次日8点30分为开始时间
  IF v_zz_date>=TRUNC(v_zz_date, 'DD') + 0.7295 THEN
    v_zz_date:=TRUNC(v_zz_date, 'DD') + 1.3542;
  END IF;
  --剔除开始日期是节假日，以后续第一个工作日8点30分为开始时间
  SELECT COUNT(*) INTO V_JJRDAYS FROM PUB_JJR WHERE JJR_DATE = TRUNC(v_zz_date,'DD');
  LOOP
    EXIT WHEN V_JJRDAYS=0;
    v_zz_date := v_zz_date + 1;
    SELECT COUNT(*) INTO V_JJRDAYS FROM PUB_JJR WHERE JJR_DATE = TRUNC(v_zz_date,'DD');
  END LOOP;

  FOR i IN 1 .. v_adddays LOOP
    v_zz_date := v_zz_date + 1;
    v_jjrdays := 1;
    WHILE v_jjrdays = 1 LOOP
      select count(*) into v_jjrdays from PUB_JJR where jjr_date = trunc(v_zz_date,'dd');
      IF v_jjrdays > 0 THEN
        v_zz_date := v_zz_date + 1;
      END IF;
    END LOOP;
  END LOOP;

  return(v_zz_date);
end COMPUTE_BLJZDATE;
/

prompt
prompt Creating function F_GZR_BETWEEN
prompt ===============================
prompt
CREATE OR REPLACE FUNCTION F_GZR_BETWEEN(IN_RQ_Z DATE,IN_RQ_Q DATE)
RETURN  NUMBER
IS
  GZR_DAYS NUMBER;
BEGIN
  WITH V_RQ AS
  (SELECT IN_RQ_Q AS RQ_Q,
          IN_RQ_Z AS RQ_Z
     FROM DUAL)
  SELECT R.RQ_Z
         - R.RQ_Q
         - COALESCE(SUM(J1.JJRZZRQ - J1.JJRQSRQ + 1), 0)
         - COALESCE(J2.JJRZZRQ - R.RQ_Q + 1, 0)
         - COALESCE(R.RQ_Z - J3.JJRQSRQ + 1, 0)
         INTO GZR_DAYS
  FROM V_RQ R
  LEFT JOIN HX_CS_ZDY.CS_GY_JJR J1 ON J1.JJRQSRQ >= R.RQ_Q AND J1.JJRZZRQ <= R.RQ_Z
  LEFT JOIN HX_CS_ZDY.CS_GY_JJR J2 ON J2.JJRQSRQ <= R.RQ_Q AND J2.JJRZZRQ >= R.RQ_Q
  LEFT JOIN HX_CS_ZDY.CS_GY_JJR J3 ON J3.JJRQSRQ <= R.RQ_Z AND J3.JJRZZRQ >= R.RQ_Z
  GROUP BY R.RQ_Q,R.RQ_Z,J2.JJRZZRQ,J3.JJRQSRQ
  ;

RETURN GZR_DAYS;
END ;
/

prompt
prompt Creating procedure PRO_DEAL_CKTS_CKWSB_STOP
prompt ===========================================
prompt
CREATE OR REPLACE PROCEDURE PRO_DEAL_CKTS_CKWSB_STOP
/*
 * 出口未申报报关单提取
 * 停止使用
 */
AS
BEGIN

  EXECUTE IMMEDIATE 'TRUNCATE TABLE CKTS_WBSJ_CKWSB';
  COMMIT;
  
  FOR CUR_NSRXX IN (SELECT T.TSSWJG_DM_1,T.DJXH,T.HGQY_DM
                      FROM HX_CKTS.CKTS_BA_BAXX_JGB T
                     WHERE NVL(T.BACHBZ,'N')='N' AND T.CKHWTMSJSFF_DM<'3'
                     ORDER BY T.TSSWJG_DM_1) LOOP
    INSERT INTO CKTS_WBSJ_CKWSB(TSSWJG_DM_1,DJXH,RKRQ,CKRQ_1,CKBGDH,JGFS_DM,CKSP_DM,HGSPMC,RMBLAJ,MYLAJ,HGQY_DM,BAH,SJLY)
         SELECT S.TSSWJG_DM_1,S.DJXH,S.RKRQ,S.CKRQ_1,S.CKBGDH,S.JGFS_DM,S.CKSP_DM,S.HGSPMC,S.RMBLAJ,S.MYLAJ,S.HGQY_DM,S.BAH,'BGD201'
           FROM HX_CKTS.CKTS_WBSJ_HG_BGD201 S 
          INNER JOIN HX_DM_ZDY.DM_CKTS_HGJGFS JG ON JG.JGFS_DM=S.JGFS_DM AND JG.JGFSTSLX_DM='1'
          WHERE S.TSSWJG_DM_1=CUR_NSRXX.TSSWJG_DM_1 -- 金三分区表
            AND S.DJXH=CUR_NSRXX.DJXH -- 单户抽取
            AND S.CKRQ_1<TRUNC(SYSDATE,'YY') -- 不包括本年业务，金三有索引
            AND S.TSSBSL+S.DLSBSL=0 AND S.CKSL-S.TYSL>0; --未申报退税、代理证明，同时未全部退运
    COMMIT;
    INSERT INTO CKTS_WBSJ_CKWSB(TSSWJG_DM_1,DJXH,RKRQ,CKRQ_1,CKBGDH,JGFS_DM,CKSP_DM,HGSPMC,RMBLAJ,MYLAJ,HGQY_DM,BAH,SJLY)
         SELECT S.TSSWJG_DM_1,S.DJXH,S.RKRQ,S.CKRQ_1,S.DLCKHWZMHM,S.JGFS_DM,S.CKSP_DM,S.HGSPMC,S.RMBLAJ,S.MYLAJ,S.WTFHGQYDM,S.BAH,'DLCKZM'
           FROM HX_CKTS.CKTS_WBSJ_ZJ_DLCKHWZM S 
          INNER JOIN HX_DM_ZDY.DM_CKTS_HGJGFS JG ON JG.JGFS_DM=S.JGFS_DM AND JG.JGFSTSLX_DM='1'
          WHERE S.DJXH=CUR_NSRXX.DJXH -- 单户抽取
            AND S.CKRQ_1<TRUNC(SYSDATE,'YY') -- 不包括本年业务，金三有索引
            AND S.TSSBSL=0 AND S.CKSL-S.TYSL>0; --未申报退税，同时未全部退运
    COMMIT;
  END LOOP;
  
  --删除禁止出口商品或不退税商品、免税商品
  DELETE CKTS_WBSJ_CKWSB
   WHERE EXISTS ( SELECT 1
                    FROM HX_CKTS.CKTS_TY_CKSPTSLWK 
                   WHERE CKSP_DM = CKTS_WBSJ_CKWSB.CKSP_DM
                     AND CKTS_WBSJ_CKWSB.CKRQ_1 BETWEEN YXQQ AND YXQZ
                     AND CKSPTSSPLX_DM IN ('1','2'));
  COMMIT;
  DELETE CKTS_WBSJ_CKWSB
   WHERE EXISTS ( SELECT 1
                    FROM HX_CKTS.CKTS_TY_CKSPTSLWK 
                   WHERE CKSP_DM = SUBSTR(CKTS_WBSJ_CKWSB.CKSP_DM,1,8)
                     AND CKTS_WBSJ_CKWSB.CKRQ_1 BETWEEN YXQQ AND YXQZ
                     AND CKSPTSSPLX_DM IN ('1','2'));
  COMMIT;
  
  --删除生产企业免抵退已申报数据
  DELETE CKTS_WBSJ_CKWSB
   WHERE EXISTS ( SELECT 1
                    FROM HX_CKTS.CKTS_SB_MDT_TSSB_JGB
                   WHERE DJXH = CKTS_WBSJ_CKWSB.DJXH
                     AND CKBGDH = CKTS_WBSJ_CKWSB.CKBGDH);
  COMMIT;
  DELETE CKTS_WBSJ_CKWSB
   WHERE EXISTS ( SELECT 1
                    FROM HX_CKTS.CKTS_SB_MDT_TSSB_GCB
                   WHERE DJXH = CKTS_WBSJ_CKWSB.DJXH
                     AND CKBGDH = CKTS_WBSJ_CKWSB.CKBGDH);
  COMMIT;
  
  --删除外贸免退税已申报数据
  DELETE CKTS_WBSJ_CKWSB
   WHERE EXISTS ( SELECT 1
                    FROM HX_CKTS.CKTS_SB_MTS_TSSB_JGB
                   WHERE DJXH = CKTS_WBSJ_CKWSB.DJXH
                     AND CKBGDH = CKTS_WBSJ_CKWSB.CKBGDH);
  COMMIT;
  DELETE CKTS_WBSJ_CKWSB
   WHERE EXISTS ( SELECT 1
                    FROM HX_CKTS.CKTS_SB_MTS_TSSB_GCB
                   WHERE DJXH = CKTS_WBSJ_CKWSB.DJXH
                     AND CKBGDH = CKTS_WBSJ_CKWSB.CKBGDH);
  COMMIT;

  DELETE CKTS_WBSJ_CKWSB
   WHERE EXISTS ( SELECT 1
                    FROM HX_CKTS.CKTS_SB_MTS_TSSB_LB
                   WHERE DJXH = CKTS_WBSJ_CKWSB.DJXH
                     AND CKBGDH = CKTS_WBSJ_CKWSB.CKBGDH);
  COMMIT;
  
  --删除外综服代办退税已申报数据
  DELETE CKTS_WBSJ_CKWSB
   WHERE EXISTS ( SELECT 1
                    FROM HX_CKTS.CKTS_SB_DB_TSSB_JGB
                   WHERE DJXH = CKTS_WBSJ_CKWSB.DJXH
                     AND CKBGDH = CKTS_WBSJ_CKWSB.CKBGDH);
  COMMIT;
  DELETE CKTS_WBSJ_CKWSB
   WHERE EXISTS ( SELECT 1
                    FROM HX_CKTS.CKTS_SB_DB_TSSB_GCB
                   WHERE DJXH = CKTS_WBSJ_CKWSB.DJXH
                     AND CKBGDH = CKTS_WBSJ_CKWSB.CKBGDH);
  COMMIT;
  
  --删除非自产退消费税已申报数据
  DELETE CKTS_WBSJ_CKWSB
   WHERE EXISTS ( SELECT 1
                    FROM HX_CKTS.CKTS_SB_FZC_SBMX_JGB
                   WHERE DJXH = CKTS_WBSJ_CKWSB.DJXH
                     AND CKBGDH = CKTS_WBSJ_CKWSB.CKBGDH);
  COMMIT;
  DELETE CKTS_WBSJ_CKWSB
   WHERE EXISTS ( SELECT 1
                    FROM HX_CKTS.CKTS_SB_FZC_SBMX_GCB
                   WHERE DJXH = CKTS_WBSJ_CKWSB.DJXH
                     AND CKBGDH = CKTS_WBSJ_CKWSB.CKBGDH);
  COMMIT;
  
  --删除已使用旧设备已申报数据
  DELETE CKTS_WBSJ_CKWSB
   WHERE EXISTS ( SELECT 1
                    FROM HX_CKTS.CKTS_SB_YS_SBMX_JGB
                   WHERE DJXH = CKTS_WBSJ_CKWSB.DJXH
                     AND CKBGDH = CKTS_WBSJ_CKWSB.CKBGDH);
  COMMIT;
  DELETE CKTS_WBSJ_CKWSB
   WHERE EXISTS ( SELECT 1
                    FROM HX_CKTS.CKTS_SB_YS_SBMX_GCB
                   WHERE DJXH = CKTS_WBSJ_CKWSB.DJXH
                     AND CKBGDH = CKTS_WBSJ_CKWSB.CKBGDH);
  COMMIT;
  
  --删除代理出口证明已申报数据
  DELETE CKTS_WBSJ_CKWSB
   WHERE EXISTS ( SELECT 1
                    FROM HX_CKTS.CKTS_ZM_DLCK_JGMXB
                   WHERE DJXH = CKTS_WBSJ_CKWSB.DJXH
                     AND CKBGDH = CKTS_WBSJ_CKWSB.CKBGDH);
  COMMIT;
  DELETE CKTS_WBSJ_CKWSB
   WHERE EXISTS ( SELECT 1
                    FROM HX_CKTS.CKTS_ZM_DLCK_GCMXB
                   WHERE DJXH = CKTS_WBSJ_CKWSB.DJXH
                     AND CKBGDH = CKTS_WBSJ_CKWSB.CKBGDH);
  COMMIT;
  
END;
/

prompt
prompt Creating procedure PRO_DEAL_CKTS_CKYZS_STOP
prompt ===========================================
prompt
CREATE OR REPLACE PROCEDURE PRO_DEAL_CKTS_CKYZS_STOP
/*
 * 出口应征税商品数据提取
 * 停止使用
 */
AS
  LC_RKRQ   VARCHAR(8);
BEGIN
  SELECT TO_CHAR(TRUNC(MAX(T.RKRQ))-1,'YYYYMMDD')
    INTO LC_RKRQ
    FROM CKTS_WBSJ_CKYZS T;
  FOR CUR_SWJG IN (SELECT DJXH FROM HX_CKTS.CKTS_BA_BAXX_JGB ORDER BY TSSWJG_DM_1,DJXH) LOOP
    MERGE INTO CKTS_WBSJ_CKYZS A
         USING (SELECT T.TSSWJG_DM_1,T.DJXH,T.RKRQ,T.CKRQ_1,T.CKBGDH,T.JGFS_DM,T.CKSP_DM,T.HGSPMC,T.RMBLAJ,T.MYLAJ,SW.SWJGJC,NVL(QY.SHXYDM,QY.NSRSBH) AS NSRSBH,QY.NSRMC
                  FROM HX_CKTS.CKTS_WBSJ_HG_BGD201 T
                 INNER JOIN CKTS_DM_HGJGFS JG
                    ON JG.JGFS_DM=T.JGFS_DM AND JG.CKYZSBZ='Y'
                   AND (JG.JGFS_DM<>'1039' OR (JG.JGFS_DM='1039' AND T.CKRQ_1>=DATE'2024-03-20'))
                 INNER JOIN HX_CKTS.CKTS_TY_CKSPTSLWK WK
                    ON T.CKSP_DM LIKE WK.CKSP_DM||'%'
                   AND (T.CKRQ_1 BETWEEN WK.YXQQ AND WK.YXQZ)
                   AND WK.CKSPTSSPLX_DM='1'
                 INNER JOIN HX_DM_ZDY.DM_GY_SWJG SW
                    ON SW.SWJG_DM=T.TSSWJG_DM_1
                 INNER JOIN HX_DJ.DJ_NSRXX QY
                    ON QY.DJXH=T.DJXH
                 WHERE T.DJXH=CUR_SWJG.DJXH
                   AND TO_CHAR(T.RKRQ,'YYYYMMDD')>=LC_RKRQ
                   AND T.DLSBSL=0) B
            ON (A.DJXH=B.DJXH AND A.CKBGDH=B.CKBGDH)
          WHEN NOT MATCHED THEN
            INSERT (TSSWJG_DM_1,DJXH,RKRQ,CKRQ_1,CKBGDH,JGFS_DM,CKSP_DM,HGSPMC,RMBLAJ,MYLAJ,SJLY,TSSWJG_MC,NSRSBH,NSRMC)
            VALUES (B.TSSWJG_DM_1,B.DJXH,B.RKRQ,B.CKRQ_1,B.CKBGDH,B.JGFS_DM,B.CKSP_DM,B.HGSPMC,B.RMBLAJ,B.MYLAJ,'BGD201',B.SWJGJC,B.NSRSBH,B.NSRMC);
    COMMIT;
  END LOOP;
  
  MERGE INTO CKTS_WBSJ_CKYZS A
       USING (SELECT T.TSSWJG_DM_1,T.DJXH,T.RKRQ,T.CKRQ_1,T.DLCKHWZMHM,T.JGFS_DM,T.CKSP_DM,T.HGSPMC,T.RMBLAJ,T.MYLAJ,SW.SWJGJC,NVL(QY.SHXYDM,QY.NSRSBH) AS NSRSBH,QY.NSRMC
                FROM HX_CKTS.CKTS_WBSJ_ZJ_DLCKHWZM T
                 INNER JOIN CKTS_DM_HGJGFS JG
                    ON JG.JGFS_DM=T.JGFS_DM AND JG.CKYZSBZ='Y'
                   AND (JG.JGFS_DM<>'1039' OR (JG.JGFS_DM='1039' AND T.CKRQ_1>=DATE'2024-03-20'))
               INNER JOIN HX_CKTS.CKTS_TY_CKSPTSLWK WK
                  ON T.CKSP_DM LIKE WK.CKSP_DM||'%'
                 AND (T.CKRQ_1 BETWEEN WK.YXQQ AND WK.YXQZ)
                 AND WK.CKSPTSSPLX_DM='1'
               INNER JOIN HX_DM_ZDY.DM_GY_SWJG SW
                  ON SW.SWJG_DM=T.TSSWJG_DM_1
               INNER JOIN HX_DJ.DJ_NSRXX QY
                  ON QY.DJXH=T.DJXH
               WHERE TO_CHAR(T.RKRQ,'YYYYMMDD')>=LC_RKRQ) B
          ON (A.DJXH=B.DJXH AND A.CKBGDH=B.DLCKHWZMHM)
        WHEN NOT MATCHED THEN
          INSERT (TSSWJG_DM_1,DJXH,RKRQ,CKRQ_1,CKBGDH,JGFS_DM,CKSP_DM,HGSPMC,RMBLAJ,MYLAJ,SJLY,TSSWJG_MC,NSRSBH,NSRMC)
          VALUES (B.TSSWJG_DM_1,B.DJXH,B.RKRQ,B.CKRQ_1,B.DLCKHWZMHM,B.JGFS_DM,B.CKSP_DM,B.HGSPMC,B.RMBLAJ,B.MYLAJ,'DLCKZM',B.SWJGJC,B.NSRSBH,B.NSRMC);
  COMMIT;

  MERGE INTO CKTS_WBSJ_CKYZS A
       USING (SELECT T.TSSWJG_DM_1,T.DJXH,T.XGRQ,T.CKRQ_1,T.CKBGDH,T.JGFS_DM,T.CKSP_DM,T.HGSPMC,T.RMBLAJ,T.MYLAJ,SW.SWJGJC,NVL(QY.SHXYDM,QY.NSRSBH) AS NSRSBH,QY.NSRMC
                FROM HX_CKTS.CKTS_WBSJ_HG_WQFBGD201 T
                 INNER JOIN CKTS_DM_HGJGFS JG
                    ON JG.JGFS_DM=T.JGFS_DM AND JG.CKYZSBZ='Y'
                   AND (JG.JGFS_DM<>'1039' OR (JG.JGFS_DM='1039' AND T.CKRQ_1>=DATE'2024-03-20'))
               INNER JOIN HX_CKTS.CKTS_TY_CKSPTSLWK WK
                  ON T.CKSP_DM LIKE WK.CKSP_DM||'%'
                 AND (T.CKRQ_1 BETWEEN WK.YXQQ AND WK.YXQZ)
                 AND WK.CKSPTSSPLX_DM='1'
               INNER JOIN HX_DM_ZDY.DM_GY_SWJG SW
                  ON SW.SWJG_DM=T.TSSWJG_DM_1
               INNER JOIN HX_DJ.DJ_NSRXX QY
                  ON QY.DJXH=T.DJXH
               WHERE TO_CHAR(T.XGRQ,'YYYYMMDD')>=LC_RKRQ
                 AND T.DJXH IS NOT NULL) B
          ON (A.DJXH=B.DJXH AND A.CKBGDH=B.CKBGDH)
        WHEN NOT MATCHED THEN
          INSERT (TSSWJG_DM_1,DJXH,RKRQ,CKRQ_1,CKBGDH,JGFS_DM,CKSP_DM,HGSPMC,RMBLAJ,MYLAJ,SJLY,TSSWJG_MC,NSRSBH,NSRMC)
          VALUES (B.TSSWJG_DM_1,B.DJXH,B.XGRQ,B.CKRQ_1,B.CKBGDH,B.JGFS_DM,B.CKSP_DM,B.HGSPMC,B.RMBLAJ,B.MYLAJ,'WQFBGD1',B.SWJGJC,B.NSRSBH,B.NSRMC);
  COMMIT;

  MERGE INTO CKTS_WBSJ_CKYZS A
       USING (SELECT QY.ZGSWJ_DM,QY.DJXH,T.XGRQ,T.CKRQ_1,T.CKBGDH,T.JGFS_DM,T.CKSP_DM,T.HGSPMC,T.RMBLAJ,T.MYLAJ,SW.SWJGJC,NVL(QY.SHXYDM,QY.NSRSBH) AS NSRSBH,QY.NSRMC
                FROM HX_CKTS.CKTS_WBSJ_HG_WQFBGD201 T
                 INNER JOIN CKTS_DM_HGJGFS JG
                    ON JG.JGFS_DM=T.JGFS_DM AND JG.CKYZSBZ='Y'
                   AND (JG.JGFS_DM<>'1039' OR (JG.JGFS_DM='1039' AND T.CKRQ_1>=DATE'2024-03-20'))
               INNER JOIN HX_CKTS.CKTS_TY_CKSPTSLWK WK
                  ON T.CKSP_DM LIKE WK.CKSP_DM||'%'
                 AND (T.CKRQ_1 BETWEEN WK.YXQQ AND WK.YXQZ)
                 AND WK.CKSPTSSPLX_DM='1'
               INNER JOIN HX_DM_ZDY.DM_GY_SWJG SW
                  ON SW.SWJG_DM=T.TSSWJG_DM_1
               INNER JOIN HX_DJ.DJ_NSRXX QY
                  ON QY.NSRMC=T.JYDWMC
               WHERE TO_CHAR(T.XGRQ,'YYYYMMDD')>=LC_RKRQ
                 AND T.DJXH IS NULL) B
          ON (A.DJXH=B.DJXH AND A.CKBGDH=B.CKBGDH)
        WHEN NOT MATCHED THEN
          INSERT (TSSWJG_DM_1,DJXH,RKRQ,CKRQ_1,CKBGDH,JGFS_DM,CKSP_DM,HGSPMC,RMBLAJ,MYLAJ,SJLY,TSSWJG_MC,NSRSBH,NSRMC)
          VALUES (B.ZGSWJ_DM,B.DJXH,B.XGRQ,B.CKRQ_1,B.CKBGDH,B.JGFS_DM,B.CKSP_DM,B.HGSPMC,B.RMBLAJ,B.MYLAJ,'WQFBGD2',B.SWJGJC,B.NSRSBH,B.NSRMC);
  COMMIT;

  MERGE INTO CKTS_WBSJ_CKYZS A
       USING (SELECT T.TSSWJG_DM_1,T.DJXH,T.LRRQ,T.CKRQ_1,T.CKBGDH,T.JGFS_DM,T.CKSP_DM,S.HGSPMC,S.RMBLAJ,T.MYLAJ,SW.SWJGJC,NVL(QY.SHXYDM,QY.NSRSBH) AS NSRSBH,QY.NSRMC
                FROM HX_CKTS.CKTS_QT_BSYTMS_CKMX_JGB T
                LEFT JOIN HX_CKTS.CKTS_WBSJ_HG_BGD201 S
                  ON S.DJXH=T.DJXH
                 AND S.CKBGDH=T.CKBGDH
               INNER JOIN HX_DM_ZDY.DM_GY_SWJG SW
                  ON SW.SWJG_DM=T.TSSWJG_DM_1
               INNER JOIN HX_DJ.DJ_NSRXX QY
                  ON QY.DJXH=T.DJXH
               WHERE TO_CHAR(T.LRRQ,'YYYYMMDD')>=LC_RKRQ
                 AND T.CKBGDH IS NOT NULL
                 AND T.ZMSJY_DM='1') B
          ON (A.DJXH=B.DJXH AND A.CKBGDH=B.CKBGDH)
        WHEN NOT MATCHED THEN
          INSERT (TSSWJG_DM_1,DJXH,RKRQ,CKRQ_1,CKBGDH,JGFS_DM,CKSP_DM,HGSPMC,RMBLAJ,MYLAJ,SJLY,TSSWJG_MC,NSRSBH,NSRMC)
          VALUES (B.TSSWJG_DM_1,B.DJXH,B.LRRQ,B.CKRQ_1,B.CKBGDH,B.JGFS_DM,B.CKSP_DM,B.HGSPMC,B.RMBLAJ,B.MYLAJ,'BSYTMS',B.SWJGJC,B.NSRSBH,B.NSRMC);
  COMMIT;
END;
/

prompt
prompt Creating procedure PRO_DEAL_CKTS_CQWSB
prompt ======================================
prompt
CREATE OR REPLACE PROCEDURE PRO_DEAL_CKTS_CQWSB
/*
 * 长期未申报报关单提取
 * 每日执行
 * 20260804, 创建海关监管方式代码表，根据代码表免税监控标识及退税类型标识调整取数口径，判断征免退口径调整
 */
AS
  LN_MONTH         NUMBER(3);
  LD_JZRQ          DATE; --长期未申报数据的出口日期截止范围
  LD_CJRQ          DATE; --上次运行的创建日期
  V_CKSPTSSPLX_DM  CHAR(1);
  V_ZSSL           NUMBER(18,2);
  V_TSL            NUMBER(18,2);
  V_YBNSR          NUMBER(3);
BEGIN
  SELECT EXTRACT(MONTH FROM SYSDATE)
    INTO LN_MONTH
    FROM DUAL;
  IF LN_MONTH>=5 THEN
    LD_JZRQ := TRUNC(SYSDATE,'YY');
  ELSE
    LD_JZRQ := ADD_MONTHS(TRUNC(SYSDATE,'YY'),-12);
  END IF;
  SELECT MAX(CJRQ)
    INTO LD_CJRQ
    FROM RCGL_CQWSB_DATA;
  
  IF TRUNC(SYSDATE,'DD')=ADD_MONTHS(TRUNC(SYSDATE,'YY'),4) THEN
    --每年5月1日开始刷新上一年未申报数据
    FOR CUR_NSRXX IN (SELECT T.TSSWJG_DM_1,T.DJXH,T.CKHWTMSJSFF_DM,T.HGQY_DM,NVL(S.SHXYDM,S.NSRSBH) AS NSRSBH,S.NSRMC
                        FROM HX_CKTS.CKTS_BA_BAXX_JGB T
                       INNER JOIN HX_DJ.DJ_NSRXX S ON S.DJXH=T.DJXH
                       WHERE NVL(T.BACHBZ,'N')='N'
                         AND T.CKHWTMSJSFF_DM IN ('1','2') --企业范围
                       ORDER BY T.TSSWJG_DM_1) LOOP
      BEGIN
        MERGE INTO RCGL_CQWSB_DATA A
             USING (SELECT UUID,DJXH,CKBGDH,CKRQ_1,CKSP_DM,GFHHGSPMC,BGD.JGFS_DM,HGCJFS_DM,MYLAJ,RMBLAJ,
                           DYJLDW_DM,CKSL,GREATEST(CKSL-TSSBSL-TYSL-DLSBSL,0) AS WSBSL,
                           JG.JGFSTSLX_DM,JG.CKYZSBZ,JG.MSJGBZ
                      FROM HX_CKTS.CKTS_WBSJ_HG_BGD201 BGD
                     INNER JOIN CKTS_DM_HGJGFS JG
                        ON JG.JGFS_DM=BGD.JGFS_DM
                       AND (JG.MSJGBZ='Y' OR JG.JGFSTSLX_DM<>'0')
                     WHERE BGD.DJXH=CUR_NSRXX.DJXH -- 单户抽取
                       AND BGD.CKRQ_1>=ADD_MONTHS(TRUNC(SYSDATE,'YY'),-12) AND BGD.CKRQ_1<LD_JZRQ --出口日期范围
                       AND BGD.CKSL-BGD.TYSL>0
                       AND BGD.TSSBSL=0
                       AND BGD.DLSBSL=0) B
                ON (A.DJXH=B.DJXH AND A.CKBGDH=B.CKBGDH)
              WHEN NOT MATCHED THEN
                INSERT (UUID,SWJGDM,DJXH,NSRSBH,NSRMC,TSJSFFDM,CKBGDH,CKRQ_1,CKSP_DM,GFHHGSPMC,JGFS_DM,HGCJFS_DM,
                       MYLAJ,RMBLAJ,DYJLDW_DM,CKSL,WSBSL,SJLY,CJRQ,JGFSTSLX_DM,CKYZSBZ,MSJGBZ)
                VALUES (B.UUID,CUR_NSRXX.TSSWJG_DM_1,CUR_NSRXX.DJXH,CUR_NSRXX.NSRSBH,CUR_NSRXX.NSRMC,CUR_NSRXX.CKHWTMSJSFF_DM,
                       B.CKBGDH,B.CKRQ_1,B.CKSP_DM,B.GFHHGSPMC,B.JGFS_DM,B.HGCJFS_DM,
                       B.MYLAJ,B.RMBLAJ,B.DYJLDW_DM,B.CKSL,B.WSBSL,'BGD201',SYSDATE,B.JGFSTSLX_DM,B.CKYZSBZ,B.MSJGBZ);
        COMMIT;
        MERGE INTO RCGL_CQWSB_DATA A
             USING (SELECT UUID,DJXH,DLCKHWZMHM AS CKBGDH,CKRQ_1,CKSP_DM,GFHHGSPMC,BGD.JGFS_DM,HGCJFS_DM,MYLAJ,RMBLAJ,
                           DYJLDW_DM,CKSL,GREATEST(CKSL-TSSBSL-TYSL,0) AS WSBSL,
                           JG.JGFSTSLX_DM,JG.CKYZSBZ,JG.MSJGBZ
                      FROM HX_CKTS.CKTS_WBSJ_ZJ_DLCKHWZM BGD
                     INNER JOIN CKTS_DM_HGJGFS JG
                        ON JG.JGFS_DM=BGD.JGFS_DM
                       AND (JG.MSJGBZ='Y' OR JG.JGFSTSLX_DM<>'0')
                     WHERE BGD.DJXH=CUR_NSRXX.DJXH -- 单户抽取
                       AND BGD.CKRQ_1>=ADD_MONTHS(TRUNC(SYSDATE,'YY'),-12) AND BGD.CKRQ_1<LD_JZRQ --出口日期范围
                       AND BGD.CKSL-BGD.TYSL>0
                       AND BGD.TSSBSL=0) B
                ON (A.DJXH=B.DJXH AND A.CKBGDH=B.CKBGDH)
              WHEN NOT MATCHED THEN
                INSERT (UUID,SWJGDM,DJXH,NSRSBH,NSRMC,TSJSFFDM,CKBGDH,CKRQ_1,CKSP_DM,GFHHGSPMC,JGFS_DM,HGCJFS_DM,
                       MYLAJ,RMBLAJ,DYJLDW_DM,CKSL,WSBSL,SJLY,CJRQ,JGFSTSLX_DM,CKYZSBZ,MSJGBZ)
                VALUES (B.UUID,CUR_NSRXX.TSSWJG_DM_1,CUR_NSRXX.DJXH,CUR_NSRXX.NSRSBH,CUR_NSRXX.NSRMC,CUR_NSRXX.CKHWTMSJSFF_DM,
                       B.CKBGDH,B.CKRQ_1,B.CKSP_DM,B.GFHHGSPMC,B.JGFS_DM,B.HGCJFS_DM,
                       B.MYLAJ,B.RMBLAJ,B.DYJLDW_DM,B.CKSL,B.WSBSL,'DLCKHWZM',SYSDATE,B.JGFSTSLX_DM,B.CKYZSBZ,B.MSJGBZ);
        COMMIT;
        MERGE INTO RCGL_CQWSB_DATA A
             USING (SELECT UUID,DJXH,CKBGDH,CKRQ_1,CKSP_DM,GFHHGSPMC,BGD.JGFS_DM,HGCJFS_DM,MYLAJ,RMBLAJ,
                           DYJLDW_DM,CKSL,CKSL AS WSBSL,
                           JG.JGFSTSLX_DM,JG.CKYZSBZ,JG.MSJGBZ
                      FROM HX_CKTS.CKTS_WBSJ_HG_WQFBGD201 BGD
                     INNER JOIN CKTS_DM_HGJGFS JG
                        ON JG.JGFS_DM=BGD.JGFS_DM
                       AND (JG.MSJGBZ='Y' OR JG.JGFSTSLX_DM<>'0')
                     WHERE NVL(BGD.DJXH,0)=CUR_NSRXX.DJXH -- 单户抽取
                       AND BGD.CKRQ_1>=ADD_MONTHS(TRUNC(SYSDATE,'YY'),-12) AND BGD.CKRQ_1<LD_JZRQ --出口日期范围
                       ) B
                ON (A.DJXH=B.DJXH AND A.CKBGDH=B.CKBGDH)
              WHEN NOT MATCHED THEN
                INSERT (UUID,SWJGDM,DJXH,NSRSBH,NSRMC,TSJSFFDM,CKBGDH,CKRQ_1,CKSP_DM,GFHHGSPMC,JGFS_DM,HGCJFS_DM,
                       MYLAJ,RMBLAJ,DYJLDW_DM,CKSL,WSBSL,SJLY,CJRQ,JGFSTSLX_DM,CKYZSBZ,MSJGBZ)
                VALUES (B.UUID,CUR_NSRXX.TSSWJG_DM_1,CUR_NSRXX.DJXH,CUR_NSRXX.NSRSBH,CUR_NSRXX.NSRMC,CUR_NSRXX.CKHWTMSJSFF_DM,
                       B.CKBGDH,B.CKRQ_1,B.CKSP_DM,B.GFHHGSPMC,B.JGFS_DM,B.HGCJFS_DM,
                       B.MYLAJ,B.RMBLAJ,B.DYJLDW_DM,B.CKSL,B.WSBSL,'WQFBGD',SYSDATE,B.JGFSTSLX_DM,B.CKYZSBZ,B.MSJGBZ);
        COMMIT;
      END;
    END LOOP;
  ELSE
    --否则重复一天做增量数据刷新
    FOR CUR_NSRXX IN (SELECT T.TSSWJG_DM_1,T.DJXH,T.CKHWTMSJSFF_DM,T.HGQY_DM,NVL(S.SHXYDM,S.NSRSBH) AS NSRSBH,S.NSRMC
                        FROM HX_CKTS.CKTS_BA_BAXX_JGB T
                       INNER JOIN HX_DJ.DJ_NSRXX S ON S.DJXH=T.DJXH
                       WHERE NVL(T.BACHBZ,'N')='N'
                         AND T.CKHWTMSJSFF_DM IN ('1','2') --企业范围
                       ORDER BY T.TSSWJG_DM_1) LOOP
      BEGIN
        MERGE INTO RCGL_CQWSB_DATA A
             USING (SELECT UUID,DJXH,CKBGDH,CKRQ_1,CKSP_DM,GFHHGSPMC,BGD.JGFS_DM,HGCJFS_DM,MYLAJ,RMBLAJ,
                           DYJLDW_DM,CKSL,GREATEST(CKSL-TSSBSL-TYSL-DLSBSL,0) AS WSBSL,
                           JG.JGFSTSLX_DM,JG.CKYZSBZ,JG.MSJGBZ
                      FROM HX_CKTS.CKTS_WBSJ_HG_BGD201 BGD
                     INNER JOIN CKTS_DM_HGJGFS JG
                        ON JG.JGFS_DM=BGD.JGFS_DM
                       AND (JG.MSJGBZ='Y' OR JG.JGFSTSLX_DM<>'0')
                     WHERE BGD.DJXH=CUR_NSRXX.DJXH -- 单户抽取
                       AND BGD.CKRQ_1>=DATE'2019-01-01' AND BGD.CKRQ_1<LD_JZRQ --出口日期范围
                       AND TO_CHAR(RKRQ,'YYYYMMDD')>=TO_CHAR(LD_CJRQ-1,'YYYYMMDD')
                       AND BGD.CKSL-BGD.TYSL>0
                       AND BGD.TSSBSL=0
                       AND BGD.DLSBSL=0) B
                ON (A.DJXH=B.DJXH AND A.CKBGDH=B.CKBGDH)
              WHEN NOT MATCHED THEN
                INSERT (UUID,SWJGDM,DJXH,NSRSBH,NSRMC,TSJSFFDM,CKBGDH,CKRQ_1,CKSP_DM,GFHHGSPMC,JGFS_DM,HGCJFS_DM,
                       MYLAJ,RMBLAJ,DYJLDW_DM,CKSL,WSBSL,SJLY,CJRQ,JGFSTSLX_DM,CKYZSBZ,MSJGBZ)
                VALUES (B.UUID,CUR_NSRXX.TSSWJG_DM_1,CUR_NSRXX.DJXH,CUR_NSRXX.NSRSBH,CUR_NSRXX.NSRMC,CUR_NSRXX.CKHWTMSJSFF_DM,
                       B.CKBGDH,B.CKRQ_1,B.CKSP_DM,B.GFHHGSPMC,B.JGFS_DM,B.HGCJFS_DM,
                       B.MYLAJ,B.RMBLAJ,B.DYJLDW_DM,B.CKSL,B.WSBSL,'BGD201',SYSDATE,B.JGFSTSLX_DM,B.CKYZSBZ,B.MSJGBZ);
        COMMIT;
        MERGE INTO RCGL_CQWSB_DATA A
             USING (SELECT UUID,DJXH,DLCKHWZMHM AS CKBGDH,CKRQ_1,CKSP_DM,GFHHGSPMC,BGD.JGFS_DM,HGCJFS_DM,MYLAJ,RMBLAJ,
                           DYJLDW_DM,CKSL,GREATEST(CKSL-TSSBSL-TYSL,0) AS WSBSL,
                           JG.JGFSTSLX_DM,JG.CKYZSBZ,JG.MSJGBZ
                      FROM HX_CKTS.CKTS_WBSJ_ZJ_DLCKHWZM BGD
                     INNER JOIN CKTS_DM_HGJGFS JG
                        ON JG.JGFS_DM=BGD.JGFS_DM
                       AND (JG.MSJGBZ='Y' OR JG.JGFSTSLX_DM<>'0')
                     WHERE BGD.DJXH=CUR_NSRXX.DJXH -- 单户抽取
                       AND BGD.CKRQ_1>=DATE'2019-01-01' AND BGD.CKRQ_1<LD_JZRQ --出口日期范围
                       AND TO_CHAR(RKRQ,'YYYYMMDD')>=TO_CHAR(LD_CJRQ-1,'YYYYMMDD')
                       AND BGD.CKSL-BGD.TYSL>0
                       AND BGD.TSSBSL=0) B
                ON (A.DJXH=B.DJXH AND A.CKBGDH=B.CKBGDH)
              WHEN NOT MATCHED THEN
                INSERT (UUID,SWJGDM,DJXH,NSRSBH,NSRMC,TSJSFFDM,CKBGDH,CKRQ_1,CKSP_DM,GFHHGSPMC,JGFS_DM,HGCJFS_DM,
                       MYLAJ,RMBLAJ,DYJLDW_DM,CKSL,WSBSL,SJLY,CJRQ,JGFSTSLX_DM,CKYZSBZ,MSJGBZ)
                VALUES (B.UUID,CUR_NSRXX.TSSWJG_DM_1,CUR_NSRXX.DJXH,CUR_NSRXX.NSRSBH,CUR_NSRXX.NSRMC,CUR_NSRXX.CKHWTMSJSFF_DM,
                       B.CKBGDH,B.CKRQ_1,B.CKSP_DM,B.GFHHGSPMC,B.JGFS_DM,B.HGCJFS_DM,
                       B.MYLAJ,B.RMBLAJ,B.DYJLDW_DM,B.CKSL,B.WSBSL,'DLCKHWZM',SYSDATE,B.JGFSTSLX_DM,B.CKYZSBZ,B.MSJGBZ);
        COMMIT;
        MERGE INTO RCGL_CQWSB_DATA A
             USING (SELECT UUID,DJXH,CKBGDH,CKRQ_1,CKSP_DM,GFHHGSPMC,BGD.JGFS_DM,HGCJFS_DM,MYLAJ,RMBLAJ,
                           DYJLDW_DM,CKSL,CKSL AS WSBSL,
                           JG.JGFSTSLX_DM,JG.CKYZSBZ,JG.MSJGBZ
                      FROM HX_CKTS.CKTS_WBSJ_HG_WQFBGD201 BGD
                     INNER JOIN CKTS_DM_HGJGFS JG
                        ON JG.JGFS_DM=BGD.JGFS_DM
                       AND (JG.MSJGBZ='Y' OR JG.JGFSTSLX_DM<>'0')
                     WHERE NVL(BGD.DJXH,0)=CUR_NSRXX.DJXH -- 单户抽取
                       AND BGD.CKRQ_1>=DATE'2019-01-01' AND BGD.CKRQ_1<LD_JZRQ --出口日期范围
                       AND TO_CHAR(RKRQ,'YYYYMMDD')>=TO_CHAR(LD_CJRQ-1,'YYYYMMDD')
                       ) B
                ON (A.DJXH=B.DJXH AND A.CKBGDH=B.CKBGDH)
              WHEN NOT MATCHED THEN
                INSERT (UUID,SWJGDM,DJXH,NSRSBH,NSRMC,TSJSFFDM,CKBGDH,CKRQ_1,CKSP_DM,GFHHGSPMC,JGFS_DM,HGCJFS_DM,
                       MYLAJ,RMBLAJ,DYJLDW_DM,CKSL,WSBSL,SJLY,CJRQ,JGFSTSLX_DM,CKYZSBZ,MSJGBZ)
                VALUES (B.UUID,CUR_NSRXX.TSSWJG_DM_1,CUR_NSRXX.DJXH,CUR_NSRXX.NSRSBH,CUR_NSRXX.NSRMC,CUR_NSRXX.CKHWTMSJSFF_DM,
                       B.CKBGDH,B.CKRQ_1,B.CKSP_DM,B.GFHHGSPMC,B.JGFS_DM,B.HGCJFS_DM,
                       B.MYLAJ,B.RMBLAJ,B.DYJLDW_DM,B.CKSL,B.WSBSL,'WQFBGD',SYSDATE,B.JGFSTSLX_DM,B.CKYZSBZ,B.MSJGBZ);
        COMMIT;
      END;
    END LOOP;
  END IF;
  
  FOR CUR_WSB IN (SELECT T.DJXH,T.CKBGDH,T.CKRQ_1,T.CKSP_DM
                    FROM RCGL_CQWSB_DATA T
                   WHERE T.ZMTBZ IS NULL) LOOP
    BEGIN
      SELECT CKSPTSSPLX_DM, ZSSL, TSL
        INTO V_CKSPTSSPLX_DM, V_ZSSL, V_TSL
        FROM (SELECT CKSPTSSPLX_DM,TO_NUMBER(CASE WHEN LENGTH(ZSSLJH)>=2 THEN SUBSTR(ZSSLJH,1,2) ELSE ZSSLJH END) AS ZSSL,TSL
                FROM (SELECT NVL(A.CKSPTSSPLX_DM,'0') AS CKSPTSSPLX_DM,A.ZSSLJH,A.TSL
                        FROM HX_CKTS.CKTS_TY_CKSPTSLWK A
                       WHERE A.CKSP_DM LIKE CUR_WSB.CKSP_DM||'%' AND (CUR_WSB.CKRQ_1 BETWEEN A.YXQQ AND A.YXQZ) AND A.JBSPBZ='Y'
                       UNION ALL
                      SELECT NVL(B.CKSPTSSPLX_DM,'0') AS CKSPTSSPLX_DM,B.ZSSLJH,B.TSL
                        FROM HX_CKTS.CKTS_TY_CKSPTSLWK B
                       WHERE B.CKSP_DM = SUBSTR(CUR_WSB.CKSP_DM,1,8) AND (CUR_WSB.CKRQ_1 BETWEEN B.YXQQ AND B.YXQZ) AND B.JBSPBZ='Y'
                      ) S
               ORDER BY TSL DESC) R
       WHERE ROWNUM=1;
    EXCEPTION
      WHEN OTHERS THEN
        --找不到对应的基本商品
        V_CKSPTSSPLX_DM:=NULL;
        V_ZSSL:=NULL;
        V_TSL:=NULL;
    END;
    
    IF V_ZSSL IS NULL THEN
      BEGIN
        SELECT ZSSL, TSL
          INTO V_ZSSL, V_TSL
          FROM (SELECT TO_NUMBER(CASE WHEN LENGTH(ZSSLJH)>=2 THEN SUBSTR(ZSSLJH,1,2) ELSE ZSSLJH END) AS ZSSL,TSL
                  FROM HX_CKTS.CKTS_TY_CKSPTSLWK
                 WHERE CKSP_DM = SUBSTR(CUR_WSB.CKSP_DM,1,6)||'%' AND (CUR_WSB.CKRQ_1 BETWEEN YXQQ AND YXQZ) AND JBSPBZ='Y'
                 ORDER BY TSL DESC) R
         WHERE ROWNUM=1;
      EXCEPTION
        WHEN OTHERS THEN
          --找不到对应的基本商品
          V_ZSSL:=NULL;
          V_TSL:=NULL;
      END;
    END IF;
    
    SELECT COUNT(1)
      INTO V_YBNSR
      FROM HX_RD.RD_NSRZGXX_JGB S
     WHERE S.DJXH=CUR_WSB.DJXH
       AND S.NSRZGLX_DM IN ('201','202','203')
       AND (CUR_WSB.CKRQ_1 BETWEEN S.YXQQ AND S.YXQZ)
       AND ROWNUM=1;
     
    UPDATE RCGL_CQWSB_DATA S
       SET S.ZMTBZ=CASE WHEN V_CKSPTSSPLX_DM='1' AND S.CKYZSBZ='Y' THEN '1' --文库征税商品+监管方式应征税：征税
                        WHEN V_CKSPTSSPLX_DM='1' AND S.CKYZSBZ='N' THEN '2' --文库征税商品+监管方式不征税：免税
                        WHEN V_CKSPTSSPLX_DM='2' THEN '2'  --文库免税商品：免税
                        WHEN S.JGFSTSLX_DM='0' THEN '3' --监管方式不退税
                        WHEN V_YBNSR=0 THEN '4' --小规模期间出口：免税
                        WHEN S.TSJSFFDM IN ('3','9') THEN '9' --退税计算方式不退税
                        WHEN V_CKSPTSSPLX_DM IS NULL THEN 'W' --因文库代码调整，未知
                        ELSE '0' END,
           S.ZSSL=V_ZSSL,
           S.TSL=V_TSL
     WHERE S.DJXH=CUR_WSB.DJXH AND S.CKBGDH=CUR_WSB.CKBGDH;
    COMMIT;
  END LOOP;
END;
/

prompt
prompt Creating procedure PRO_DEAL_CKTS_CQWSB_ONE
prompt ==========================================
prompt
CREATE OR REPLACE PROCEDURE PRO_DEAL_CKTS_CQWSB_ONE
/*
 * 单户长期未申报报关单提取
 * 有需要时人工调用
 */
(
  P_SHXYDM  IN VARCHAR2 --单户税号
)
AS
  V_CKSPTSSPLX_DM  CHAR(1);
  V_ZSSL           NUMBER(18,2);
  V_TSL            NUMBER(18,2);
BEGIN
  IF P_SHXYDM IS NULL THEN
    RETURN;
  END IF;
  
  FOR CUR_NSRXX IN (SELECT T.TSSWJG_DM_1,T.DJXH,T.CKHWTMSJSFF_DM,T.HGQY_DM,NVL(S.SHXYDM,S.NSRSBH) AS NSRSBH,S.NSRMC
                      FROM HX_CKTS.CKTS_BA_BAXX_JGB T
                     INNER JOIN HX_DJ.DJ_NSRXX S ON S.DJXH=T.DJXH
                     WHERE S.NSRSBH=P_SHXYDM OR S.SHXYDM=P_SHXYDM) LOOP
    BEGIN
      MERGE INTO RCGL_CQWSB_DATA A
           USING (SELECT UUID,DJXH,CKBGDH,CKRQ_1,CKSP_DM,GFHHGSPMC,BGD.JGFS_DM,HGCJFS_DM,MYLAJ,RMBLAJ,
                         DYJLDW_DM,CKSL,GREATEST(CKSL-TSSBSL-TYSL-DLSBSL,0) AS WSBSL,
                         JG.JGFSTSLX_DM,JG.CKYZSBZ,JG.MSJGBZ
                    FROM HX_CKTS.CKTS_WBSJ_HG_BGD201 BGD
                   INNER JOIN CKTS_DM_HGJGFS JG
                      ON JG.JGFS_DM=BGD.JGFS_DM
                     AND (JG.MSJGBZ='Y' OR JG.JGFSTSLX_DM<>'0')
                   WHERE BGD.DJXH=CUR_NSRXX.DJXH -- 单户抽取
                     AND BGD.CKSL-BGD.TYSL>0
                     AND BGD.TSSBSL=0
                     AND BGD.DLSBSL=0) B
              ON (A.DJXH=B.DJXH AND A.CKBGDH=B.CKBGDH)
            WHEN NOT MATCHED THEN
              INSERT (UUID,SWJGDM,DJXH,NSRSBH,NSRMC,TSJSFFDM,CKBGDH,CKRQ_1,CKSP_DM,GFHHGSPMC,JGFS_DM,HGCJFS_DM,
                     MYLAJ,RMBLAJ,DYJLDW_DM,CKSL,WSBSL,SJLY,CJRQ,JGFSTSLX_DM,CKYZSBZ,MSJGBZ)
              VALUES (B.UUID,CUR_NSRXX.TSSWJG_DM_1,CUR_NSRXX.DJXH,CUR_NSRXX.NSRSBH,CUR_NSRXX.NSRMC,CUR_NSRXX.CKHWTMSJSFF_DM,
                     B.CKBGDH,B.CKRQ_1,B.CKSP_DM,B.GFHHGSPMC,B.JGFS_DM,B.HGCJFS_DM,
                     B.MYLAJ,B.RMBLAJ,B.DYJLDW_DM,B.CKSL,B.WSBSL,'BGD201',SYSDATE,B.JGFSTSLX_DM,B.CKYZSBZ,B.MSJGBZ);
      COMMIT;
      MERGE INTO RCGL_CQWSB_DATA A
           USING (SELECT UUID,DJXH,DLCKHWZMHM AS CKBGDH,CKRQ_1,CKSP_DM,GFHHGSPMC,BGD.JGFS_DM,HGCJFS_DM,MYLAJ,RMBLAJ,
                         DYJLDW_DM,CKSL,GREATEST(CKSL-TSSBSL-TYSL,0) AS WSBSL,
                         JG.JGFSTSLX_DM,JG.CKYZSBZ,JG.MSJGBZ
                    FROM HX_CKTS.CKTS_WBSJ_ZJ_DLCKHWZM BGD
                   INNER JOIN CKTS_DM_HGJGFS JG
                      ON JG.JGFS_DM=BGD.JGFS_DM
                     AND (JG.MSJGBZ='Y' OR JG.JGFSTSLX_DM<>'0')
                   WHERE BGD.DJXH=CUR_NSRXX.DJXH -- 单户抽取
                     AND BGD.CKSL-BGD.TYSL>0
                     AND BGD.TSSBSL=0) B
              ON (A.DJXH=B.DJXH AND A.CKBGDH=B.CKBGDH)
            WHEN NOT MATCHED THEN
              INSERT (UUID,SWJGDM,DJXH,NSRSBH,NSRMC,TSJSFFDM,CKBGDH,CKRQ_1,CKSP_DM,GFHHGSPMC,JGFS_DM,HGCJFS_DM,
                     MYLAJ,RMBLAJ,DYJLDW_DM,CKSL,WSBSL,SJLY,CJRQ,JGFSTSLX_DM,CKYZSBZ,MSJGBZ)
              VALUES (B.UUID,CUR_NSRXX.TSSWJG_DM_1,CUR_NSRXX.DJXH,CUR_NSRXX.NSRSBH,CUR_NSRXX.NSRMC,CUR_NSRXX.CKHWTMSJSFF_DM,
                     B.CKBGDH,B.CKRQ_1,B.CKSP_DM,B.GFHHGSPMC,B.JGFS_DM,B.HGCJFS_DM,
                     B.MYLAJ,B.RMBLAJ,B.DYJLDW_DM,B.CKSL,B.WSBSL,'DLCKHWZM',SYSDATE,B.JGFSTSLX_DM,B.CKYZSBZ,B.MSJGBZ);
      COMMIT;
      MERGE INTO RCGL_CQWSB_DATA A
           USING (SELECT UUID,DJXH,CKBGDH,CKRQ_1,CKSP_DM,GFHHGSPMC,BGD.JGFS_DM,HGCJFS_DM,MYLAJ,RMBLAJ,
                         DYJLDW_DM,CKSL,CKSL AS WSBSL,
                         JG.JGFSTSLX_DM,JG.CKYZSBZ,JG.MSJGBZ
                    FROM HX_CKTS.CKTS_WBSJ_HG_WQFBGD201 BGD
                   INNER JOIN CKTS_DM_HGJGFS JG
                      ON JG.JGFS_DM=BGD.JGFS_DM
                     AND (JG.MSJGBZ='Y' OR JG.JGFSTSLX_DM<>'0')
                   WHERE NVL(BGD.DJXH,0)=CUR_NSRXX.DJXH -- 单户抽取
                     ) B
              ON (A.DJXH=B.DJXH AND A.CKBGDH=B.CKBGDH)
            WHEN NOT MATCHED THEN
              INSERT (UUID,SWJGDM,DJXH,NSRSBH,NSRMC,TSJSFFDM,CKBGDH,CKRQ_1,CKSP_DM,GFHHGSPMC,JGFS_DM,HGCJFS_DM,
                     MYLAJ,RMBLAJ,DYJLDW_DM,CKSL,WSBSL,SJLY,CJRQ,JGFSTSLX_DM,CKYZSBZ,MSJGBZ)
              VALUES (B.UUID,CUR_NSRXX.TSSWJG_DM_1,CUR_NSRXX.DJXH,CUR_NSRXX.NSRSBH,CUR_NSRXX.NSRMC,CUR_NSRXX.CKHWTMSJSFF_DM,
                     B.CKBGDH,B.CKRQ_1,B.CKSP_DM,B.GFHHGSPMC,B.JGFS_DM,B.HGCJFS_DM,
                     B.MYLAJ,B.RMBLAJ,B.DYJLDW_DM,B.CKSL,B.WSBSL,'WQFBGD',SYSDATE,B.JGFSTSLX_DM,B.CKYZSBZ,B.MSJGBZ);
      COMMIT;
    END;
    
    FOR CUR_WSB IN (SELECT T.DJXH,T.CKBGDH,T.CKRQ_1,T.CKSP_DM
                      FROM RCGL_CQWSB_DATA T
                     WHERE T.DJXH=CUR_NSRXX.DJXH
                       AND T.ZMTBZ IS NULL) LOOP
      BEGIN
        SELECT CKSPTSSPLX_DM, ZSSL, TSL
          INTO V_CKSPTSSPLX_DM, V_ZSSL, V_TSL
          FROM (SELECT CKSPTSSPLX_DM,TO_NUMBER(CASE WHEN LENGTH(ZSSLJH)>=2 THEN SUBSTR(ZSSLJH,1,2) ELSE ZSSLJH END) AS ZSSL,TSL
                  FROM (SELECT NVL(A.CKSPTSSPLX_DM,'0') AS CKSPTSSPLX_DM,A.ZSSLJH,A.TSL
                          FROM HX_CKTS.CKTS_TY_CKSPTSLWK A
                         WHERE A.CKSP_DM LIKE CUR_WSB.CKSP_DM||'%' AND (CUR_WSB.CKRQ_1 BETWEEN A.YXQQ AND A.YXQZ) AND A.JBSPBZ='Y'
                         UNION ALL
                        SELECT NVL(B.CKSPTSSPLX_DM,'0') AS CKSPTSSPLX_DM,B.ZSSLJH,B.TSL
                          FROM HX_CKTS.CKTS_TY_CKSPTSLWK B
                         WHERE B.CKSP_DM = SUBSTR(CUR_WSB.CKSP_DM,1,8) AND (CUR_WSB.CKRQ_1 BETWEEN B.YXQQ AND B.YXQZ) AND B.JBSPBZ='Y'
                        ) S
                 ORDER BY TSL DESC) R
         WHERE ROWNUM=1;
      EXCEPTION
        WHEN OTHERS THEN
          --找不到对应的基本商品
          V_CKSPTSSPLX_DM:=NULL;
          V_ZSSL:=NULL;
          V_TSL:=NULL;
      END;
      
      IF V_ZSSL IS NULL THEN
        BEGIN
          SELECT ZSSL, TSL
            INTO V_ZSSL, V_TSL
            FROM (SELECT TO_NUMBER(CASE WHEN LENGTH(ZSSLJH)>=2 THEN SUBSTR(ZSSLJH,1,2) ELSE ZSSLJH END) AS ZSSL,TSL
                    FROM HX_CKTS.CKTS_TY_CKSPTSLWK
                   WHERE CKSP_DM = SUBSTR(CUR_WSB.CKSP_DM,1,6)||'%' AND (CUR_WSB.CKRQ_1 BETWEEN YXQQ AND YXQZ) AND JBSPBZ='Y'
                   ORDER BY TSL DESC) R
           WHERE ROWNUM=1;
        EXCEPTION
          WHEN OTHERS THEN
            --找不到对应的基本商品
            V_ZSSL:=NULL;
            V_TSL:=NULL;
        END;
      END IF;
    
    UPDATE RCGL_CQWSB_DATA S
       SET S.ZMTBZ=CASE WHEN V_CKSPTSSPLX_DM='1' AND S.CKYZSBZ='Y' THEN '1' --文库征税商品+监管方式应征税：征税
                        WHEN V_CKSPTSSPLX_DM='1' AND S.CKYZSBZ='N' THEN '2' --文库征税商品+监管方式不征税：免税
                        WHEN V_CKSPTSSPLX_DM='2' THEN '2'  --文库免税商品：免税
                        WHEN S.JGFSTSLX_DM='0' THEN '3' --监管方式不退税
                        WHEN S.TSJSFFDM IN ('3','9') THEN '9' --退税计算方式不退税
                        WHEN V_CKSPTSSPLX_DM IS NULL THEN 'W' --因文库代码调整，未知
                        ELSE '0' END,
           S.ZSSL=V_ZSSL,
           S.TSL=V_TSL
     WHERE S.DJXH=CUR_WSB.DJXH AND S.CKBGDH=CUR_WSB.CKBGDH;
    COMMIT;
    END LOOP;
  END LOOP;
END;
/

prompt
prompt Creating procedure PRO_DEAL_CKTS_HD_JJYQ
prompt ========================================
prompt
CREATE OR REPLACE PROCEDURE PRO_DEAL_CKTS_HD_JJYQ
/*
 * 即将逾期函调复函数据提取
 * 20250422，根据杭州市局王薇逾期回函内控指标的建议，调整即将逾期的条件
 * 20260817，根据绍兴市局陈弯弯当天到期未提醒的问题，调整截止日大于等于当前日期的条件
 */
AS
BEGIN
  -- 函调回函
  EXECUTE IMMEDIATE 'TRUNCATE TABLE CKTS_HD_JJYQ';
  COMMIT;

  INSERT INTO CKTS_HD_JJYQ(FHXXBUUID,GHFZGSWJG_DM,GHFZGSWJGMC,GHFDJXH1,GHQYNSRSBH_1,GHFQYMC_1,FAHDSWJGMC,WSBH,FPFS,JSHJ,QFRQ,FUHJZRQ,YQRQ_1,YQFHYY,YQCS)
       SELECT FHXXBUUID,GHFZGSWJG_DM,GHFZGSWJGMC,GHFDJXH1,GHQYNSRSBH_1,GHFQYMC_1,FAHDSWJGMC,WSBH,FPFS,JSHJ,QFRQ,FUHJZRQ,YQRQ_1,YQFHYY,YQCS
         FROM (SELECT F1.FHXXBUUID,F1.GHFZGSWJG_DM,F1.GHFZGSWJGMC,F1.GHFDJXH1,F1.GHQYNSRSBH_1,F1.GHFQYMC_1,F1.FAHDSWJGMC,
                      F1.WSBH,F1.FPFS,F1.JSHJ,F1.QFRQ,F1.FUHJZRQ,H1.QFRQ AS QFRQ_H,H1.YQRQ_1,H1.YQFHYY,
                      CASE WHEN H1.YQRQ_1 IS NULL THEN 0 ELSE ROW_NUMBER() OVER(PARTITION BY F1.FHXXBUUID ORDER BY H1.QFRQ) END AS YQCS,
                      NVL(H1.QFRQ,F1.QFRQ) AS RQQ,NVL(H1.YQRQ_1,F1.FUHJZRQ) AS RQZ,
                      ROW_NUMBER() OVER(PARTITION BY F1.FHXXBUUID ORDER BY H1.YQRQ_1 DESC, H1.FUHXXBUUID) AS RN
                 FROM HX_ZH.ZH_CKTS_FHXXB F1
                 LEFT JOIN HX_ZH.ZH_CKTS_FUHXXB H1 ON H1.FHXXBUUID = F1.FHXXBUUID
                                                   AND NVL(H1.ZFBZ_1,'N') = 'N'
                                                   AND NVL(H1.FHLX_DM,'3') = '3'
                                                   AND H1.FHBH IS NOT NULL
                WHERE F1.ZFBZ_1 = 'N'
                  AND F1.GHFZGSWJG_DM LIKE '133%' AND F1.GHFZGSWJG_DM NOT LIKE '13302%') F
        WHERE RN=1
          AND F.RQZ>=TRUNC(SYSDATE) AND COMPUTE_BLDATE(F.RQZ,SYSDATE)<=3 --未到期且到期日小于3个工作日，不包括已到期数据
          AND NOT EXISTS (SELECT 1
                            FROM HX_ZH.ZH_CKTS_FUHXXB H
                           WHERE H.FHXXBUUID = F.FHXXBUUID
                             AND H.FHBH IS NOT NULL
                             AND H.ZFBZ_1 = 'N'
                             AND H.QFRQ>F.RQQ
                             AND H.QFRQ<F.RQZ);
  COMMIT;

  RETURN;
END;
/

prompt
prompt Creating procedure PRO_DEAL_CKTS_HD_XFHHSB
prompt ==========================================
prompt
CREATE OR REPLACE PROCEDURE PRO_DEAL_CKTS_HD_XFHHSB
/*
 * 先发函后申报发票数据提取
 */
(
  V_SJCLSJD IN  DATE
)
AS
  LC_SSQ         VARCHAR(60);
  LC_SBPC        VARCHAR(75);
  LC_SBXH        VARCHAR(50);
  LD_LRRQ        DATE;
BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE CKTS_HD_XFHHSB';
  COMMIT;

  -- 插入函调发票清单及签发日期
  INSERT INTO CKTS_HD_XFHHSB(HDFPQDUUID,ZZSZYFPDMHM,JE,SE,KTSE_1,FHXXBUUID,GHFDJXH,QFRQ)
       SELECT FP.HDFPQDUUID,FP.ZZSZYFPDMHM,FP.JE,FP.SE,FP.KTSE_1,FH.FHXXBUUID,FH.GHFDJXH,FH.QFRQ
         FROM HX_ZH.ZH_CKTS_FHXXB FH --函调发函
        INNER JOIN HX_ZH.ZH_CKTS_HDFPQD FP ON FH.FHXXBUUID=FP.FHXXBUUID --函调发票清单
        WHERE FH.FAHDSWJG_DM LIKE '133%' AND FH.FAHDSWJG_DM NOT LIKE '13302%' --发函地税局：浙江非宁波
          AND NVL(FH.ZFBZ_1,'N')='N' --发函未作废
          AND FH.DZBZDSZL_DM='BDA1320284' --非上游核实函, 上游核实函为BDA1320288
          AND FH.QFRQ>=V_SJCLSJD --签发日期起始
          AND NVL(FP.ZFBZ_1,'N')='N' --清单未作废
          --AND NVL(FP.SFYTS,'N')='N' --未退税发票
          ;
  COMMIT;

  -- 删除生产企业（可能对原材料发函）
  DELETE FROM CKTS_HD_XFHHSB T WHERE EXISTS (
         SELECT 1 FROM HX_CKTS.CKTS_BA_BAXX_JGB JGB WHERE JGB.DJXH=T.GHFDJXH AND JGB.CKHWTMSJSFF_DM='1');
  COMMIT;
  -- 删除先购进申报
  DELETE FROM CKTS_HD_XFHHSB T WHERE EXISTS (
         SELECT 1 FROM HX_CKTS.CKTS_SB_GJ_SBMX_GCB GCB WHERE GCB.DJXH=T.GHFDJXH AND GCB.JHPZH=T.ZZSZYFPDMHM AND GCB.LRRQ<T.QFRQ+1);
  COMMIT;
  DELETE FROM CKTS_HD_XFHHSB T WHERE EXISTS (
         SELECT 1 FROM HX_CKTS.CKTS_SB_GJ_SBMX_JGB JGB WHERE JGB.DJXH=T.GHFDJXH AND JGB.JHPZH=T.ZZSZYFPDMHM AND JGB.LRRQ<T.QFRQ+1);
  COMMIT;
  -- 删除先代办退税申报
  DELETE FROM CKTS_HD_XFHHSB T WHERE EXISTS (
         SELECT 1 FROM HX_CKTS.CKTS_SB_DB_TSSB_GCB GCB WHERE GCB.DJXH=T.GHFDJXH AND GCB.DBTSWSPZHM=T.ZZSZYFPDMHM AND GCB.LRRQ<T.QFRQ+1);
  COMMIT;
  DELETE FROM CKTS_HD_XFHHSB T WHERE EXISTS (
         SELECT 1 FROM HX_CKTS.CKTS_SB_DB_TSSB_JGB JGB WHERE JGB.DJXH=T.GHFDJXH AND JGB.DBTSWSPZHM=T.ZZSZYFPDMHM AND JGB.LRRQ<T.QFRQ+1);
  COMMIT;
  -- 删除先服务贸易免退税申报
  DELETE FROM CKTS_HD_XFHHSB T WHERE EXISTS (
         SELECT 1 FROM HX_CKTS.CKTS_SB_MTS_YSFWCK_GCB GCB WHERE GCB.DJXH=T.GHFDJXH AND GCB.JHPZH=T.ZZSZYFPDMHM AND GCB.LRRQ<T.QFRQ+1);
  COMMIT;
  DELETE FROM CKTS_HD_XFHHSB T WHERE EXISTS (
         SELECT 1 FROM HX_CKTS.CKTS_SB_MTS_YSFWCK_JGB JGB WHERE JGB.DJXH=T.GHFDJXH AND JGB.JHPZH=T.ZZSZYFPDMHM AND JGB.LRRQ<T.QFRQ+1);
  COMMIT;
  -- 删除先免退税申报
  DELETE FROM CKTS_HD_XFHHSB T WHERE EXISTS (
         SELECT 1 FROM HX_CKTS.CKTS_SB_MTS_TSJH_GCB GCB WHERE GCB.DJXH=T.GHFDJXH AND GCB.JHPZH=T.ZZSZYFPDMHM AND GCB.LRRQ<T.QFRQ+1);
  COMMIT;
  DELETE FROM CKTS_HD_XFHHSB T WHERE EXISTS (
         SELECT 1 FROM HX_CKTS.CKTS_SB_MTS_TSJH_JGB JGB WHERE JGB.DJXH=T.GHFDJXH AND JGB.JHPZH=T.ZZSZYFPDMHM AND JGB.LRRQ<T.QFRQ+1);
  COMMIT;
  DELETE FROM CKTS_HD_XFHHSB T WHERE EXISTS (
         SELECT 1 FROM HX_CKTS.CKTS_SB_MTS_TSJH_LB JGB WHERE JGB.DJXH=T.GHFDJXH AND JGB.JHPZH=T.ZZSZYFPDMHM AND JGB.LRRQ<T.QFRQ+1);
  COMMIT;

  FOR CUR_LC IN (SELECT HDFPQDUUID,ZZSZYFPDMHM,GHFDJXH FROM CKTS_HD_XFHHSB) LOOP
    BEGIN
      SELECT SSQ,SBPC,SBXH,LRRQ
        INTO LC_SSQ,LC_SBPC,LC_SBXH,LD_LRRQ
        FROM (SELECT SSQ,SBPC,SBXH,LRRQ
                FROM (SELECT GCB.SSQ,GCB.SBPC,GCB.SBXH,GCB.LRRQ
                        FROM HX_CKTS.CKTS_SB_MTS_TSJH_GCB GCB
                       WHERE GCB.DJXH=CUR_LC.GHFDJXH AND GCB.JHPZH=CUR_LC.ZZSZYFPDMHM
                       UNION ALL
                      SELECT JGB.SSQ,JGB.SBPC,JGB.SBXH,JGB.LRRQ
                        FROM HX_CKTS.CKTS_SB_MTS_TSJH_JGB JGB
                       WHERE JGB.DJXH=CUR_LC.GHFDJXH AND JGB.JHPZH=CUR_LC.ZZSZYFPDMHM
                       UNION ALL
                      SELECT GCB.SSQ,NULL AS SBPC,GCB.SBXH,GCB.LRRQ
                        FROM HX_CKTS.CKTS_SB_GJ_SBMX_GCB GCB
                       WHERE GCB.DJXH=CUR_LC.GHFDJXH AND GCB.JHPZH=CUR_LC.ZZSZYFPDMHM
                       UNION ALL
                      SELECT JGB.SSQ,NULL AS SBPC,JGB.SBXH,JGB.LRRQ
                        FROM HX_CKTS.CKTS_SB_GJ_SBMX_JGB JGB
                       WHERE JGB.DJXH=CUR_LC.GHFDJXH AND JGB.JHPZH=CUR_LC.ZZSZYFPDMHM
                       UNION ALL
                      SELECT GCB.SSQ,GCB.SBPC,GCB.SBXH,GCB.LRRQ
                        FROM HX_CKTS.CKTS_SB_DB_TSSB_GCB GCB
                       WHERE GCB.DJXH=CUR_LC.GHFDJXH AND GCB.DBTSWSPZHM=CUR_LC.ZZSZYFPDMHM
                       UNION ALL
                      SELECT JGB.SSQ,JGB.SBPC,JGB.SBXH,JGB.LRRQ
                        FROM HX_CKTS.CKTS_SB_DB_TSSB_JGB JGB
                       WHERE JGB.DJXH=CUR_LC.GHFDJXH AND JGB.DBTSWSPZHM=CUR_LC.ZZSZYFPDMHM
                     ) T
               ORDER BY LRRQ) TT
       WHERE ROWNUM=1;
    EXCEPTION
      WHEN OTHERS THEN
        LC_SSQ := NULL;
        LC_SBPC := NULL;
        LC_SBXH := NULL;
        LD_LRRQ := NULL;
    END;

    UPDATE CKTS_HD_XFHHSB S
       SET S.SSQ=LC_SSQ, S.SBPC=LC_SBPC, S.SBXH=LC_SBXH, S.LRRQ=LD_LRRQ
     WHERE S.HDFPQDUUID=CUR_LC.HDFPQDUUID;
    COMMIT;
  END LOOP;

  RETURN;
END;
/

prompt
prompt Creating procedure PRO_DEAL_CKTS_KZ_SLQY
prompt ========================================
prompt
CREATE OR REPLACE PROCEDURE PRO_DEAL_CKTS_KZ_SLQY
(
  V_SJCLSJD IN  DATE
)
AS
BEGIN
  -- 四类企业法定代表人信息
  EXECUTE IMMEDIATE 'TRUNCATE TABLE CKTS_KZ_SLQY';
  COMMIT;

  INSERT INTO CKTS_KZ_SLQY(UUID,TSSWJG_DM_1,DJXH,LCSLID,YXQQ,YXQZ,LRRQ,NSRSBH,SHXYDM,NSRMC,FDDBRXM,FDDBRSFZJLX_DM,FDDBRSFZJHM,BACHBZ,BACHRQ)
       SELECT S.UUID,S.TSSWJG_DM_1,S.DJXH,S.LCSLID,TRUNC(S.YXQQ),TRUNC(S.YXQZ),TRUNC(S.LRRQ),
              T.NSRSBH,T.SHXYDM,T.NSRMC,T.FDDBRXM,T.FDDBRSFZJLX_DM,T.FDDBRSFZJHM,
              R.BACHBZ,R.BACHRQ
         FROM HX_CKTS.CKTS_BA_KZ_JGB S
        INNER JOIN HX_DJ.DJ_NSRXX T ON T.DJXH=S.DJXH
        INNER JOIN HX_CKTS.CKTS_BA_BAXX_JGB R ON R.DJXH=S.DJXH
        WHERE S.CKTMSBAKZLX_DM='FLGLCD' AND S.YXBZ='Y' AND S.KZNR='D'
          AND S.YXQZ>=V_SJCLSJD
          AND R.BACHBZ='N'
          AND R.BACHRQ IS NULL
        UNION ALL
       SELECT S.UUID,S.TSSWJG_DM_1,S.DJXH,S.LCSLID,TRUNC(S.YXQQ),TRUNC(S.YXQZ),TRUNC(S.LRRQ),
              T.NSRSBH,T.SHXYDM,T.NSRMC,T.FDDBRXM,T.FDDBRSFZJLX_DM,T.FDDBRSFZJHM,
              R.BACHBZ,R.BACHRQ
         FROM HX_CKTS.CKTS_BA_KZ_JGB S
        INNER JOIN HX_DJ.DJ_NSRXX T ON T.DJXH=S.DJXH
        INNER JOIN HX_CKTS.CKTS_BA_BAXX_JGB R ON R.DJXH=S.DJXH
        WHERE S.CKTMSBAKZLX_DM='FLGLCD' AND S.YXBZ='Y' AND S.KZNR='D'
          AND S.YXQZ>=V_SJCLSJD
          AND R.BACHBZ='Y'
          AND R.BACHRQ>V_SJCLSJD;
  COMMIT;

  RETURN;
END;
/

prompt
prompt Creating procedure PRO_DEAL_CKTS_LC_BYTS
prompt ========================================
prompt
CREATE OR REPLACE PROCEDURE PRO_DEAL_CKTS_LC_BYTS
/*
 * 提取事中审核环节的不予退税及应追回已退免税款明细
 */
AS
BEGIN
  FOR CUR_BYMTS IN (SELECT T.TSSWJG_DM_1,T.DJXH,T.LCSLID,T.SSQ,T.SBPC,MIN(T.XGRQ) AS TBRQ
                      FROM HX_CKTS.CKTS_BL_MTS_SHYDCL_JGB T
                     WHERE T.ZHSHCLYJLX_DM = '9'
                       AND T.XGRQ>=SYSDATE-7
                     GROUP BY T.TSSWJG_DM_1,T.DJXH,T.LCSLID,T.SSQ,T.SBPC) LOOP
    MERGE INTO FXGL_DATA_FXYDJG A
         USING (SELECT (SELECT NVL(SHXYDM,NSRSBH)
                          FROM HX_DJ.DJ_NSRXX
                         WHERE DJXH=CUR_BYMTS.DJXH) AS SHXYDM,
                       (SELECT NSRMC
                          FROM HX_DJ.DJ_NSRXX
                         WHERE DJXH=CUR_BYMTS.DJXH) AS NSRMC,
                       (SELECT DECODE(CKTSQYLX_DM,'1','内资生产企业','2','外商投资企业','3','外贸企业','其他单位')
                          FROM HX_CKTS.CKTS_BA_BAXX_JGB
                         WHERE DJXH=CUR_BYMTS.DJXH) AS QYLX,
                       (SELECT SWJGJC
                          FROM HX_DM_ZDY.DM_GY_SWJG
                         WHERE SWJG_DM=CUR_BYMTS.TSSWJG_DM_1) AS TSSWJG_MC,
                       (SELECT ROUND(SUM(MYLAJ)/10000,2)
                          FROM HX_CKTS.CKTS_SB_MTS_TSSB_JGB
                         WHERE DJXH=CUR_BYMTS.DJXH AND SSQ=CUR_BYMTS.SSQ AND SBPC=CUR_BYMTS.SBPC) AS RWFXQJ_SBMYCKE,
                       (SELECT TO_CHAR(WM_CONCAT(TT.FXYDCS))
                          FROM (SELECT '自查表核查' AS FXYDCS
                                  FROM DUAL
                                 WHERE EXISTS (SELECT 1
                                                 FROM HX_CKTS.CKTS_BL_MTS_SHYDCL_JGB
                                                WHERE LCSLID=CUR_BYMTS.LCSLID AND ZCBHCCLYJLX_DM='9')
                                 UNION ALL
                                SELECT '函调核查' AS FXYDCS
                                  FROM DUAL
                                 WHERE EXISTS (SELECT 1
                                                 FROM HX_CKTS.CKTS_BL_MTS_SHYDCL_JGB
                                                WHERE LCSLID=CUR_BYMTS.LCSLID AND FHCLYJLX_DM='9')
                                 UNION ALL
                                SELECT '实地核查' AS FXYDCS
                                  FROM DUAL
                                 WHERE EXISTS (SELECT 1
                                                 FROM HX_CKTS.CKTS_BL_MTS_SHYDCL_JGB
                                                WHERE LCSLID=CUR_BYMTS.LCSLID AND SDHCCLYJLX_DM='9')
                                 UNION ALL
                                SELECT '其他核查' AS FXYDCS
                                  FROM DUAL
                                 WHERE EXISTS (SELECT 1
                                                 FROM HX_CKTS.CKTS_BL_MTS_SHYDCL_JGB T
                                                WHERE T.LCSLID=CUR_BYMTS.LCSLID AND QTHCCLYJLX_DM='9')) TT) AS FXYDCS_JH,
                       (SELECT ROUND(SUM(MYLAJ)/10000,2)
                          FROM HX_CKTS.CKTS_SB_MTS_TSSB_JGB
                         WHERE DJXH=CUR_BYMTS.DJXH AND SSQ=CUR_BYMTS.SSQ AND SBPC=CUR_BYMTS.SBPC
                           AND GLH IN (SELECT GLH
                                         FROM HX_CKTS.CKTS_BL_MTS_SHYDCL_JGB
                                        WHERE LCSLID=CUR_BYMTS.LCSLID AND ZHSHCLYJLX_DM = '9')) AS BYTSCKE,
                       (SELECT ROUND(SUM(TSE)/10000,2)
                          FROM HX_CKTS.CKTS_SB_MTS_TSJH_JGB
                         WHERE DJXH=CUR_BYMTS.DJXH AND SSQ=CUR_BYMTS.SSQ AND SBPC=CUR_BYMTS.SBPC
                           AND GLH IN (SELECT GLH
                                         FROM HX_CKTS.CKTS_BL_MTS_SHYDCL_JGB
                                        WHERE LCSLID=CUR_BYMTS.LCSLID AND ZHSHCLYJLX_DM = '9')) AS BYTS,
                       (SELECT TO_CHAR(WM_CONCAT(CKSP_DM))
                          FROM (SELECT DISTINCT CKSP_DM
                                  FROM HX_CKTS.CKTS_SB_MTS_TSSB_JGB
                                 WHERE DJXH=CUR_BYMTS.DJXH AND SSQ=CUR_BYMTS.SSQ AND SBPC=CUR_BYMTS.SBPC
                                   AND GLH IN (SELECT GLH
                                                 FROM HX_CKTS.CKTS_BL_MTS_SHYDCL_JGB
                                                WHERE LCSLID=CUR_BYMTS.LCSLID AND ZHSHCLYJLX_DM = '9'))
                         WHERE ROWNUM<=20) AS SPDM2MC
                  FROM DUAL) B
            ON (A.LCSLID=CUR_BYMTS.LCSLID)
          WHEN MATCHED THEN
               UPDATE SET A.RWFXQJ_SBMYCKE=B.RWFXQJ_SBMYCKE, A.FXYDCS_JH=B.FXYDCS_JH, A.BYTSCKE=B.BYTSCKE, A.BYTS=B.BYTS,A.SPDM2MC=B.SPDM2MC
          WHEN NOT MATCHED THEN
            INSERT (ID,TSSWJG_DM,TBR,TBRQ,SSNY,DJXH,SHXYNO,NSRMC,FXRWLY_DM,RWFXQJ_SBMYCKE,FXYDCS_JH,BYTSCKE,BYTS,BZ,LCSLID,TSSWJG_MC,SPDM2MC,QYLX,SFHCYWT)
            VALUES (SEQ_FXGL_DATA_FXYDJG.NEXTVAL,CUR_BYMTS.TSSWJG_DM_1,'SYSTEM',CUR_BYMTS.TBRQ,CUR_BYMTS.SSQ,CUR_BYMTS.DJXH,B.SHXYDM,B.NSRMC,
                   '05',B.RWFXQJ_SBMYCKE,B.FXYDCS_JH,B.BYTSCKE,B.BYTS,'免退税所属期-批次：'||CUR_BYMTS.SSQ||CUR_BYMTS.SBPC,CUR_BYMTS.LCSLID,
                   B.TSSWJG_MC,B.SPDM2MC,B.QYLX,'Y');
    COMMIT;
  END LOOP;
  
  FOR CUR_BYDBTS IN (SELECT T.TSSWJG_DM_1,T.DJXH,T.LCSLID,T.SSQ,T.SBPC,MIN(T.XGRQ) AS TBRQ
                       FROM HX_CKTS.CKTS_BL_DB_SHYDCL_JGB T
                      WHERE T.ZHSHCLYJLX_DM = '9'
                        AND T.XGRQ>=SYSDATE-7
                      GROUP BY T.TSSWJG_DM_1,T.DJXH,T.LCSLID,T.SSQ,T.SBPC) LOOP
    MERGE INTO FXGL_DATA_FXYDJG A
         USING (SELECT (SELECT NVL(SHXYDM,NSRSBH)
                          FROM HX_DJ.DJ_NSRXX
                         WHERE DJXH=CUR_BYDBTS.DJXH) AS SHXYDM,
                       (SELECT NSRMC
                          FROM HX_DJ.DJ_NSRXX
                         WHERE DJXH=CUR_BYDBTS.DJXH) AS NSRMC,
                       (SELECT DECODE(CKTSQYLX_DM,'1','内资生产企业','2','外商投资企业','3','外贸企业','其他单位')
                          FROM HX_CKTS.CKTS_BA_BAXX_JGB
                         WHERE DJXH=CUR_BYDBTS.DJXH) AS QYLX,
                       (SELECT SWJGJC
                          FROM HX_DM_ZDY.DM_GY_SWJG
                         WHERE SWJG_DM=CUR_BYDBTS.TSSWJG_DM_1) AS TSSWJG_MC,
                       (SELECT ROUND(SUM(MYLAJ)/10000,2)
                          FROM HX_CKTS.CKTS_SB_DB_TSSB_JGB
                         WHERE DJXH=CUR_BYDBTS.DJXH AND SSQ=CUR_BYDBTS.SSQ AND SBPC=CUR_BYDBTS.SBPC) AS RWFXQJ_SBMYCKE,
                       (SELECT TO_CHAR(WM_CONCAT(TT.FXYDCS))
                          FROM (SELECT '自查表核查' AS FXYDCS
                                  FROM DUAL
                                 WHERE EXISTS (SELECT 1
                                                 FROM HX_CKTS.CKTS_BL_DB_SHYDCL_JGB
                                                WHERE LCSLID=CUR_BYDBTS.LCSLID AND ZCBHCCLYJLX_DM='9')
                                 UNION ALL
                                SELECT '函调核查' AS FXYDCS
                                  FROM DUAL
                                 WHERE EXISTS (SELECT 1
                                                 FROM HX_CKTS.CKTS_BL_DB_SHYDCL_JGB
                                                WHERE LCSLID=CUR_BYDBTS.LCSLID AND FHCLYJLX_DM='9')
                                 UNION ALL
                                SELECT '实地核查' AS FXYDCS
                                  FROM DUAL
                                 WHERE EXISTS (SELECT 1
                                                 FROM HX_CKTS.CKTS_BL_DB_SHYDCL_JGB
                                                WHERE LCSLID=CUR_BYDBTS.LCSLID AND SDHCCLYJLX_DM='9')
                                 UNION ALL
                                SELECT '其他核查' AS FXYDCS
                                  FROM DUAL
                                 WHERE EXISTS (SELECT 1
                                                 FROM HX_CKTS.CKTS_BL_DB_SHYDCL_JGB T
                                                WHERE T.LCSLID=CUR_BYDBTS.LCSLID AND QTHCCLYJLX_DM='9')) TT) AS FXYDCS_JH,
                       (SELECT ROUND(SUM(MYLAJ)/10000,2)
                          FROM HX_CKTS.CKTS_SB_DB_TSSB_JGB
                         WHERE DJXH=CUR_BYDBTS.DJXH AND SSQ=CUR_BYDBTS.SSQ AND SBPC=CUR_BYDBTS.SBPC
                           AND SBXH IN (SELECT SBXH
                                         FROM HX_CKTS.CKTS_BL_DB_SHYDCL_JGB
                                        WHERE LCSLID=CUR_BYDBTS.LCSLID AND ZHSHCLYJLX_DM = '9')) AS BYTSCKE,
                       (SELECT ROUND(SUM(TSE)/10000,2)
                          FROM HX_CKTS.CKTS_SB_DB_TSSB_JGB
                         WHERE DJXH=CUR_BYDBTS.DJXH AND SSQ=CUR_BYDBTS.SSQ AND SBPC=CUR_BYDBTS.SBPC
                           AND SBXH IN (SELECT SBXH
                                         FROM HX_CKTS.CKTS_BL_DB_SHYDCL_JGB
                                        WHERE LCSLID=CUR_BYDBTS.LCSLID AND ZHSHCLYJLX_DM = '9')) AS BYTS,
                       (SELECT TO_CHAR(WM_CONCAT(CKSP_DM))
                          FROM (SELECT DISTINCT CKSP_DM
                                  FROM HX_CKTS.CKTS_SB_DB_TSSB_JGB
                                 WHERE DJXH=CUR_BYDBTS.DJXH AND SSQ=CUR_BYDBTS.SSQ AND SBPC=CUR_BYDBTS.SBPC
                                   AND SBXH IN (SELECT SBXH
                                                 FROM HX_CKTS.CKTS_BL_DB_SHYDCL_JGB
                                                WHERE LCSLID=CUR_BYDBTS.LCSLID AND ZHSHCLYJLX_DM = '9'))
                         WHERE ROWNUM<=20) AS SPDM2MC
                  FROM DUAL) B
            ON (A.LCSLID=CUR_BYDBTS.LCSLID)
          WHEN MATCHED THEN
               UPDATE SET A.RWFXQJ_SBMYCKE=B.RWFXQJ_SBMYCKE, A.FXYDCS_JH=B.FXYDCS_JH, A.BYTSCKE=B.BYTSCKE, A.BYTS=B.BYTS,A.SPDM2MC=B.SPDM2MC
          WHEN NOT MATCHED THEN
            INSERT (ID,TSSWJG_DM,TBR,TBRQ,SSNY,DJXH,SHXYNO,NSRMC,FXRWLY_DM,RWFXQJ_SBMYCKE,FXYDCS_JH,BYTSCKE,BYTS,BZ,LCSLID,TSSWJG_MC,SPDM2MC,QYLX,SFHCYWT)
            VALUES (SEQ_FXGL_DATA_FXYDJG.NEXTVAL,CUR_BYDBTS.TSSWJG_DM_1,'SYSTEM',CUR_BYDBTS.TBRQ,CUR_BYDBTS.SSQ,CUR_BYDBTS.DJXH,B.SHXYDM,B.NSRMC,
                   '05',B.RWFXQJ_SBMYCKE,B.FXYDCS_JH,B.BYTSCKE,B.BYTS,'代办退税所属期-批次：'||CUR_BYDBTS.SSQ||CUR_BYDBTS.SBPC,CUR_BYDBTS.LCSLID,
                   B.TSSWJG_MC,B.SPDM2MC,B.QYLX,'Y');
    COMMIT;
  END LOOP;
  
  FOR CUR_BYMDT IN (SELECT T.TSSWJG_DM_1,T.DJXH,T.LCSLID,T.SSQ,MIN(T.XGRQ) AS TBRQ
                      FROM HX_CKTS.CKTS_BL_MDT_SHYDCL_JGB T
                     WHERE T.ZHSHCLYJLX_DM = '9'
                       AND T.XGRQ>=SYSDATE-7
                     GROUP BY T.TSSWJG_DM_1,T.DJXH,T.LCSLID,T.SSQ) LOOP
    MERGE INTO FXGL_DATA_FXYDJG A
         USING (SELECT (SELECT NVL(SHXYDM,NSRSBH)
                          FROM HX_DJ.DJ_NSRXX
                         WHERE DJXH=CUR_BYMDT.DJXH) AS SHXYDM,
                       (SELECT NSRMC
                          FROM HX_DJ.DJ_NSRXX
                         WHERE DJXH=CUR_BYMDT.DJXH) AS NSRMC,
                       (SELECT DECODE(CKTSQYLX_DM,'1','内资生产企业','2','外商投资企业','3','外贸企业','其他单位')
                          FROM HX_CKTS.CKTS_BA_BAXX_JGB
                         WHERE DJXH=CUR_BYMDT.DJXH) AS QYLX,
                       (SELECT SWJGJC
                          FROM HX_DM_ZDY.DM_GY_SWJG
                         WHERE SWJG_DM=CUR_BYMDT.TSSWJG_DM_1) AS TSSWJG_MC,
                       (SELECT ROUND(SUM(MYLAJ)/10000,2)
                          FROM (SELECT SBXH,MYLAJ,MDTSE,CKSP_DM
                                  FROM HX_CKTS.CKTS_SB_MDT_TSSB_JGB
                                 WHERE DJXH=CUR_BYMDT.DJXH AND SSQ=CUR_BYMDT.SSQ
                                 UNION ALL
                                SELECT SBXH,MYLAJ,MDTSE,CKSP_DM
                                  FROM HX_CKTS.CKTS_SB_MDT_TSSB_GCB
                                 WHERE DJXH=CUR_BYMDT.DJXH AND SSQ=CUR_BYMDT.SSQ)) AS RWFXQJ_SBMYCKE,
                       (SELECT TO_CHAR(WM_CONCAT(TT.FXYDCS))
                          FROM (SELECT '自查表核查' AS FXYDCS
                                  FROM DUAL
                                 WHERE EXISTS (SELECT 1
                                                 FROM HX_CKTS.CKTS_BL_MDT_SHYDCL_JGB
                                                WHERE LCSLID=CUR_BYMDT.LCSLID AND ZCBHCCLYJLX_DM='9')
                                 UNION ALL
                                SELECT '函调核查' AS FXYDCS
                                  FROM DUAL
                                 WHERE EXISTS (SELECT 1
                                                 FROM HX_CKTS.CKTS_BL_MDT_SHYDCL_JGB
                                                WHERE LCSLID=CUR_BYMDT.LCSLID AND FHCLYJLX_DM='9')
                                 UNION ALL
                                SELECT '实地核查' AS FXYDCS
                                  FROM DUAL
                                 WHERE EXISTS (SELECT 1
                                                 FROM HX_CKTS.CKTS_BL_MDT_SHYDCL_JGB
                                                WHERE LCSLID=CUR_BYMDT.LCSLID AND SDHCCLYJLX_DM='9')
                                 UNION ALL
                                SELECT '其他核查' AS FXYDCS
                                  FROM DUAL
                                 WHERE EXISTS (SELECT 1
                                                 FROM HX_CKTS.CKTS_BL_MDT_SHYDCL_JGB T
                                                WHERE T.LCSLID=CUR_BYMDT.LCSLID AND QTHCCLYJLX_DM='9')) TT) AS FXYDCS_JH,
                       (SELECT ROUND(SUM(MYLAJ)/10000,2)
                          FROM (SELECT SBXH,MYLAJ,MDTSE,CKSP_DM
                                  FROM HX_CKTS.CKTS_SB_MDT_TSSB_JGB
                                 WHERE DJXH=CUR_BYMDT.DJXH AND SSQ=CUR_BYMDT.SSQ
                                 UNION ALL
                                SELECT SBXH,MYLAJ,MDTSE,CKSP_DM
                                  FROM HX_CKTS.CKTS_SB_MDT_TSSB_GCB
                                 WHERE DJXH=CUR_BYMDT.DJXH AND SSQ=CUR_BYMDT.SSQ) TT
                         WHERE SBXH IN (SELECT SBXH
                                          FROM HX_CKTS.CKTS_BL_MDT_SHYDCL_JGB
                                         WHERE LCSLID=CUR_BYMDT.LCSLID AND ZHSHCLYJLX_DM = '9')) AS BYTSCKE,
                       (SELECT ROUND(SUM(MDTSE)/10000,2)
                          FROM (SELECT SBXH,MYLAJ,MDTSE,CKSP_DM
                                  FROM HX_CKTS.CKTS_SB_MDT_TSSB_JGB
                                 WHERE DJXH=CUR_BYMDT.DJXH AND SSQ=CUR_BYMDT.SSQ
                                 UNION ALL
                                SELECT SBXH,MYLAJ,MDTSE,CKSP_DM
                                  FROM HX_CKTS.CKTS_SB_MDT_TSSB_GCB
                                 WHERE DJXH=CUR_BYMDT.DJXH AND SSQ=CUR_BYMDT.SSQ) TT
                         WHERE SBXH IN (SELECT SBXH
                                          FROM HX_CKTS.CKTS_BL_MDT_SHYDCL_JGB
                                         WHERE LCSLID=CUR_BYMDT.LCSLID AND ZHSHCLYJLX_DM = '9')) AS BYTS,
                       (SELECT TO_CHAR(WM_CONCAT(CKSP_DM))
                          FROM (SELECT DISTINCT CKSP_DM
                                  FROM (SELECT SBXH,MYLAJ,MDTSE,CKSP_DM
                                          FROM HX_CKTS.CKTS_SB_MDT_TSSB_JGB
                                         WHERE DJXH=CUR_BYMDT.DJXH AND SSQ=CUR_BYMDT.SSQ
                                         UNION ALL
                                        SELECT SBXH,MYLAJ,MDTSE,CKSP_DM
                                          FROM HX_CKTS.CKTS_SB_MDT_TSSB_GCB
                                         WHERE DJXH=CUR_BYMDT.DJXH AND SSQ=CUR_BYMDT.SSQ) TT
                                 WHERE SBXH IN (SELECT SBXH
                                                 FROM HX_CKTS.CKTS_BL_MDT_SHYDCL_JGB
                                                WHERE LCSLID=CUR_BYMDT.LCSLID AND ZHSHCLYJLX_DM = '9'))
                         WHERE ROWNUM<=20) AS SPDM2MC
                  FROM DUAL) B
            ON (A.LCSLID=CUR_BYMDT.LCSLID)
          WHEN MATCHED THEN
               UPDATE SET A.RWFXQJ_SBMYCKE=B.RWFXQJ_SBMYCKE, A.FXYDCS_JH=B.FXYDCS_JH, A.BYTSCKE=B.BYTSCKE, A.BYTS=B.BYTS,A.SPDM2MC=B.SPDM2MC
          WHEN NOT MATCHED THEN
            INSERT (ID,TSSWJG_DM,TBR,TBRQ,SSNY,DJXH,SHXYNO,NSRMC,FXRWLY_DM,RWFXQJ_SBMYCKE,FXYDCS_JH,BYTSCKE,BYTS,BZ,LCSLID,TSSWJG_MC,SPDM2MC,QYLX,SFHCYWT)
            VALUES (SEQ_FXGL_DATA_FXYDJG.NEXTVAL,CUR_BYMDT.TSSWJG_DM_1,'SYSTEM',CUR_BYMDT.TBRQ,CUR_BYMDT.SSQ,CUR_BYMDT.DJXH,B.SHXYDM,B.NSRMC,
                   '05',B.RWFXQJ_SBMYCKE,B.FXYDCS_JH,B.BYTSCKE,B.BYTS,'免抵退所属期：'||CUR_BYMDT.SSQ,CUR_BYMDT.LCSLID,
                   B.TSSWJG_MC,B.SPDM2MC,B.QYLX,'Y');
    COMMIT;
  END LOOP;
  
  FOR CUR_BYZBTS IN (SELECT T.TSSWJG_DM_1,T.DJXH,T.LCSLID,T.SSQ,MIN(T.XGRQ) AS TBRQ
                      FROM HX_CKTS.CKTS_BL_ZB_SHYDCL_JGB T
                     WHERE T.LCSWSX_DM='LCSXA081042002' AND T.ZHSHCLYJLX_DM = '9'
                       AND T.XGRQ>=SYSDATE-7
                     GROUP BY T.TSSWJG_DM_1,T.DJXH,T.LCSLID,T.SSQ) LOOP
    MERGE INTO FXGL_DATA_FXYDJG A
         USING (SELECT (SELECT NVL(SHXYDM,NSRSBH)
                          FROM HX_DJ.DJ_NSRXX
                         WHERE DJXH=CUR_BYZBTS.DJXH) AS SHXYDM,
                       (SELECT NSRMC
                          FROM HX_DJ.DJ_NSRXX
                         WHERE DJXH=CUR_BYZBTS.DJXH) AS NSRMC,
                       (SELECT DECODE(CKTSQYLX_DM,'1','内资生产企业','2','外商投资企业','3','外贸企业','其他单位')
                          FROM HX_CKTS.CKTS_BA_BAXX_JGB
                         WHERE DJXH=CUR_BYZBTS.DJXH) AS QYLX,
                       (SELECT SWJGJC
                          FROM HX_DM_ZDY.DM_GY_SWJG
                         WHERE SWJG_DM=CUR_BYZBTS.TSSWJG_DM_1) AS TSSWJG_MC,
                       (SELECT TO_CHAR(WM_CONCAT(TT.FXYDCS))
                          FROM (SELECT '自查表核查' AS FXYDCS
                                  FROM DUAL
                                 WHERE EXISTS (SELECT 1
                                                 FROM HX_CKTS.CKTS_BL_ZB_SHYDCL_JGB
                                                WHERE LCSLID=CUR_BYZBTS.LCSLID AND ZCBHCCLYJLX_DM='9')
                                 UNION ALL
                                SELECT '函调核查' AS FXYDCS
                                  FROM DUAL
                                 WHERE EXISTS (SELECT 1
                                                 FROM HX_CKTS.CKTS_BL_ZB_SHYDCL_JGB
                                                WHERE LCSLID=CUR_BYZBTS.LCSLID AND FHCLYJLX_DM='9')
                                 UNION ALL
                                SELECT '实地核查' AS FXYDCS
                                  FROM DUAL
                                 WHERE EXISTS (SELECT 1
                                                 FROM HX_CKTS.CKTS_BL_ZB_SHYDCL_JGB
                                                WHERE LCSLID=CUR_BYZBTS.LCSLID AND SDHCCLYJLX_DM='9')
                                 UNION ALL
                                SELECT '其他核查' AS FXYDCS
                                  FROM DUAL
                                 WHERE EXISTS (SELECT 1
                                                 FROM HX_CKTS.CKTS_BL_ZB_SHYDCL_JGB T
                                                WHERE T.LCSLID=CUR_BYZBTS.LCSLID AND QTHCCLYJLX_DM='9')) TT) AS FXYDCS_JH,
                       (SELECT ROUND(SUM(TSE)/10000,2)
                          FROM HX_CKTS.CKTS_SB_GJ_SBMX_JGB
                         WHERE DJXH=CUR_BYZBTS.DJXH AND SSQ=CUR_BYZBTS.SSQ
                           AND SBXH IN (SELECT SBXH
                                         FROM HX_CKTS.CKTS_BL_ZB_SHYDCL_JGB
                                        WHERE LCSLID=CUR_BYZBTS.LCSLID AND ZHSHCLYJLX_DM = '9')) AS BYTS
                  FROM DUAL) B
            ON (A.LCSLID=CUR_BYZBTS.LCSLID)
          WHEN MATCHED THEN
               UPDATE SET A.FXYDCS_JH=B.FXYDCS_JH, A.BYTS=B.BYTS
          WHEN NOT MATCHED THEN
            INSERT (ID,TSSWJG_DM,TBR,TBRQ,SSNY,DJXH,SHXYNO,NSRMC,FXRWLY_DM,FXYDCS_JH,BYTS,BZ,LCSLID,TSSWJG_MC,QYLX,SFHCYWT)
            VALUES (SEQ_FXGL_DATA_FXYDJG.NEXTVAL,CUR_BYZBTS.TSSWJG_DM_1,'SYSTEM',CUR_BYZBTS.TBRQ,CUR_BYZBTS.SSQ,CUR_BYZBTS.DJXH,B.SHXYDM,B.NSRMC,
                   '05',B.FXYDCS_JH,B.BYTS,'购进所属期：'||CUR_BYZBTS.SSQ,CUR_BYZBTS.LCSLID,B.TSSWJG_MC,B.QYLX,'Y');
    COMMIT;
  END LOOP;
  
  FOR CUR_YZHTS IN (SELECT T.TSSWJG_DM_1,T.DJXH,T.LCSLID,ROUND(SUM(T.YZHTMSK)/10000,2) YZHTMSK,MIN(T.XGRQ) AS TBRQ,
                           MIN(CASE WHEN LENGTH(T.SSQ)=7 THEN SUBSTR(T.SSQ,1,4)||SUBSTR(T.SSQ,6,2) ELSE T.SSQ END) AS SSQ_Q,
                           MAX(CASE WHEN LENGTH(T.SSQ)=7 THEN SUBSTR(T.SSQ,1,4)||SUBSTR(T.SSQ,6,2) ELSE T.SSQ END) AS SSQ_Z
                      FROM HX_CKTS.CKTS_TK_YZHYTSKMXB_JGB T
                     WHERE T.YZHYTMSKYY_DM<>'05' AND T.YZHYTMSKYY_DM<>'032' AND T.YZHTMSK<>0
                       AND T.XGRQ>=SYSDATE-7
                     GROUP BY T.TSSWJG_DM_1,T.DJXH,T.LCSLID) LOOP
    MERGE INTO FXGL_DATA_FXYDJG A
         USING (SELECT (SELECT NVL(SHXYDM,NSRSBH)
                          FROM HX_DJ.DJ_NSRXX
                         WHERE DJXH=CUR_YZHTS.DJXH) AS SHXYDM,
                       (SELECT NSRMC
                          FROM HX_DJ.DJ_NSRXX
                         WHERE DJXH=CUR_YZHTS.DJXH) AS NSRMC,
                       (SELECT DECODE(CKTSQYLX_DM,'1','内资生产企业','2','外商投资企业','3','外贸企业','其他单位')
                          FROM HX_CKTS.CKTS_BA_BAXX_JGB
                         WHERE DJXH=CUR_YZHTS.DJXH) AS QYLX,
                       (SELECT SWJGJC
                          FROM HX_DM_ZDY.DM_GY_SWJG
                         WHERE SWJG_DM=CUR_YZHTS.TSSWJG_DM_1) AS TSSWJG_MC
                  FROM DUAL) B
            ON (A.LCSLID=CUR_YZHTS.LCSLID)
          WHEN MATCHED THEN
               UPDATE SET A.YZHTS=CUR_YZHTS.YZHTMSK
          WHEN NOT MATCHED THEN
            INSERT (ID,TSSWJG_DM,TBR,TBRQ,SSNY,DJXH,SHXYNO,NSRMC,FXRWLY_DM,FXYDCS_JH,YZHTS,BZ,LCSLID,TSSWJG_MC,QYLX,SFHCYWT)
            VALUES (SEQ_FXGL_DATA_FXYDJG.NEXTVAL,CUR_YZHTS.TSSWJG_DM_1,'SYSTEM',CUR_YZHTS.TBRQ,CUR_YZHTS.SSQ_Z,
                   CUR_YZHTS.DJXH,B.SHXYDM,B.NSRMC,'06','其他核查',CUR_YZHTS.YZHTMSK,
                   '应追回所属期起止：'||CUR_YZHTS.SSQ_Q||'-'||CUR_YZHTS.SSQ_Z,CUR_YZHTS.LCSLID,B.TSSWJG_MC,B.QYLX,'Y');
    COMMIT;
  END LOOP;
END;
/

prompt
prompt Creating procedure PRO_DEAL_CKTS_LC_STZC
prompt ========================================
prompt
CREATE OR REPLACE PROCEDURE PRO_DEAL_CKTS_LC_STZC
AS
BEGIN
  -- 出口退税审核流程（增量） 发放时间为系统日期提前7天，防止数据遗漏
  MERGE INTO CKTS_LC_STZC A
       USING (SELECT T.UUID,T.TSSWJG_DM_1,T.LCSWSX_DM,T.LCSLID,T.CKQYGLLB_DM,T.DJXH,T.SSQ,T.FFRQ,
                     SUM(S.MYLAJ) AS MYLAJ,SUM(S.RMBLAJ) AS RMBLAJ,SUM(S.MDTSE) AS MDTSE
                FROM HX_CKTS.CKTS_TY_YWBLXX T
               INNER JOIN HX_CKTS.CKTS_SB_MDT_TSSB_JGB S
                  ON S.TSSWJG_DM_1=T.TSSWJG_DM_1
                 AND S.DJXH=T.DJXH
                 AND S.SSQ=T.SSQ
                 AND REGEXP_LIKE(S.CKTMSYWLXDMJH,'STZC-01')
                 AND S.MDTSNY IS NOT NULL
                 AND S.MDTSE>0
               WHERE T.LCSWSX_DM='LCSXA081038001'
                 AND T.LCSLID=T.ZLCLCSLID
                 AND NVL(T.HTBZ_1,'N')='N'
                 AND T.FFRQ>=SYSDATE-7
               GROUP BY T.UUID,T.TSSWJG_DM_1,T.LCSWSX_DM,T.LCSLID,T.CKQYGLLB_DM,T.DJXH,T.SSQ,T.FFRQ
             ) B
          ON (A.UUID=B.UUID)
        WHEN MATCHED THEN
          UPDATE SET A.TSSWJG_DM_1=B.TSSWJG_DM_1,A.LCSWSX_DM=B.LCSWSX_DM,A.LCSLID=B.LCSLID,
                     A.CKQYGLLB_DM=B.CKQYGLLB_DM,A.DJXH=B.DJXH,A.SSQ=B.SSQ,A.FFRQ=B.FFRQ,
                     A.MYLAJ=B.MYLAJ,A.RMBLAJ=B.RMBLAJ,A.MDTSE=B.MDTSE
        WHEN NOT MATCHED THEN
          INSERT (UUID,TSSWJG_DM_1,LCSWSX_DM,LCSLID,CKQYGLLB_DM,DJXH,SSQ,FFRQ,MYLAJ,RMBLAJ,MDTSE,LCZT)
          VALUES (B.UUID,B.TSSWJG_DM_1,B.LCSWSX_DM,B.LCSLID,B.CKQYGLLB_DM,B.DJXH,B.SSQ,B.FFRQ,B.MYLAJ,B.RMBLAJ,B.MDTSE,'00');
  COMMIT;

  FOR CUR_LC IN (SELECT UUID,DJXH,FFRQ FROM CKTS_LC_STZC WHERE LCZT='00') LOOP
    UPDATE CKTS_LC_STZC T
       SET (T.ZGSWSKFJ_DM,T.NSRSBH,T.NSRMC,T.DJRQ)=
           (SELECT ZGSWSKFJ_DM,NSRSBH,NSRMC,DJRQ FROM HX_DJ.DJ_NSRXX WHERE DJXH=CUR_LC.DJXH)
     WHERE T.UUID=CUR_LC.UUID;
    COMMIT;

    UPDATE CKTS_LC_STZC T
       SET T.PJJB=(SELECT XY.PJJB FROM FXNK_JC2B_NSXYPJ XY WHERE XY.DJXH=CUR_LC.DJXH)
     WHERE T.UUID=CUR_LC.UUID;
    COMMIT;
  
    UPDATE CKTS_LC_STZC T
       SET T.SNDXSE=(SELECT SUM(ASYSLJSXSE+AJYBFJSXSE+MDTBFCKXSE+MSXSE)
                       FROM HX_SB.SB_ZZS_YBNSR
                      WHERE SBUUID IN (SELECT DISTINCT SBUUID
                                         FROM HX_SB.SB_SBXX
                                        WHERE DJXH=CUR_LC.DJXH
                                         AND SKSSQQ>=ADD_MONTHS(TRUNC(CUR_LC.FFRQ,'YY'),-12)
                                         AND SKSSQZ<TRUNC(CUR_LC.FFRQ,'YY')
                                         AND ZSXM_DM='10101' 
                                         AND YZPZZL_DM='BDA0610606'
                                         AND GZLX_DM_1 IN ('1','5')
                                         AND ZFBZ_1='N' )
                       AND EWBLXH IN (1, 3))
     WHERE T.UUID=CUR_LC.UUID;
    COMMIT;
      
    UPDATE CKTS_LC_STZC T
       SET T.LCZT=CASE WHEN ADD_MONTHS(T.DJRQ,24)>T.FFRQ OR T.PJJB<>'A' OR T.SNDXSE<500000000 THEN '11' ELSE '10' END
     WHERE T.UUID=CUR_LC.UUID AND T.DJRQ IS NOT NULL AND T.PJJB IS NOT NULL AND T.SNDXSE IS NOT NULL;
    COMMIT;
  END LOOP;

  RETURN;
END;
/

prompt
prompt Creating procedure PRO_DEAL_CKTS_LC_TSSB
prompt ========================================
prompt
CREATE OR REPLACE PROCEDURE PRO_DEAL_CKTS_LC_TSSB
AS
  LD_FSSJ        DATE;
  LD_YWHZSJ      DATE;
  LN_FSZZSTSE    NUMBER(18,6);
  LN_FSXFSTSE    NUMBER(18,6);
  LN_FSMDSE      NUMBER(18,6);
  LD_SEHZRQ      DATE;
  LN_SEHZZZSTSE  NUMBER(18,6);
  LN_SEHZXFSTSE  NUMBER(18,6);
  LN_BYHZZZSTSE  NUMBER(18,6);
  LN_BYHZXFSTSE  NUMBER(18,6);
  LC_SSRTHSBH    VARCHAR(32);
  LN_SSSRTHSSE   NUMBER(18,6);
  LD_KPRQ        DATE;
  LN_WZFLC       NUMBER(10);
  LN_ZBYWDCPG    NUMBER(10);
BEGIN
  -- 出口退税审核流程（增量） 启动时间为系统日期提前7天，防止数据遗漏
  MERGE INTO CKTS_LC_TSSB A
       USING (SELECT T.UUID,T.TSSWJG_DM_1,T.LCSWSX_DM,T.LCSLID,T.CKQYGLLB_DM,T.DJXH,S.NSRSBH,S.NSRMC,T.SSQ,T.SBPC,T.SBRQ_1,T.QDSJ,T.DYSLTZSJ,
                     COMPUTE_BLJZDATE(T.CKQYGLLB_DM,T.DYSLTZSJ) AS KHJZSJ
                FROM HX_CKTS.CKTS_TY_YWBLXX T
               INNER JOIN HX_DJ.DJ_NSRXX S ON S.DJXH=T.DJXH
               WHERE T.LCSWSX_DM IN ('LCSXA081038001','LCSXA081039001','LCSXA081040001','LCSXA081042001','LCSXA081042002','LCSXA081042006')
                 AND T.LCSLID=T.ZLCLCSLID
                 AND T.DYSLTZSJ>=SYSDATE-7
                 AND NVL(T.ZFBZ_1,'N') = 'N' AND NVL(T.HTBZ_1,'N')='N') B
          ON (A.UUID=B.UUID)
        WHEN MATCHED THEN
          UPDATE SET A.TSSWJG_DM_1=B.TSSWJG_DM_1,A.LCSWSX_DM=B.LCSWSX_DM,A.LCSLID=B.LCSLID,A.CKQYGLLB_DM=B.CKQYGLLB_DM,
                     A.DJXH=B.DJXH,A.NSRSBH=B.NSRSBH,A.NSRMC=B.NSRMC,A.SSQ=B.SSQ,A.SBPC=B.SBPC,A.SBRQ_1=B.SBRQ_1,
                     A.QDSJ=B.QDSJ,A.DYSLTZSJ=B.DYSLTZSJ,A.KHJZSJ=B.KHJZSJ
        WHEN NOT MATCHED THEN
          INSERT (UUID,TSSWJG_DM_1,LCSWSX_DM,LCSLID,CKQYGLLB_DM,DJXH,NSRSBH,NSRMC,SSQ,SBPC,SBRQ_1,QDSJ,DYSLTZSJ,KHJZSJ,LCZT)
          VALUES (B.UUID,B.TSSWJG_DM_1,B.LCSWSX_DM,B.LCSLID,B.CKQYGLLB_DM,B.DJXH,B.NSRSBH,B.NSRMC,B.SSQ,B.SBPC,B.SBRQ_1,B.QDSJ,B.DYSLTZSJ,B.KHJZSJ,'00');
  COMMIT;

  FOR CUR_LC IN (SELECT A.UUID,A.LCSWSX_DM,A.LCSLID,A.DYSLTZSJ,A.FFRQ,A.CKQYGLLB_DM,
                        DECODE(A.CKQYGLLB_DM,'A',5,'B',10,'C',15,20) AS CQ_DAY,
                        DECODE(A.CKQYGLLB_DM,'A',NVL(B.JJYQ_A,1.5),'B',NVL(B.JJYQ_B,1.5),'C',NVL(B.JJYQ_C,10),NVL(B.JJYQ_D,15)) AS JJYQ_DAY
                   FROM CKTS_LC_TSSB A
                   LEFT JOIN FXNK_CS_JJYQ B ON B.TSSWJG_DM_1=A.TSSWJG_DM_1
                  WHERE LCZT<'10')
  LOOP
    --删除作废流程
    SELECT COUNT(1)
      INTO LN_WZFLC
      FROM HX_CKTS.CKTS_TY_YWBLXX S
     WHERE S.UUID=CUR_LC.UUID AND NVL(S.ZFBZ_1,'N') = 'N';
    IF LN_WZFLC=0 THEN
      DELETE FROM CKTS_LC_TSSB WHERE UUID=CUR_LC.UUID;
      COMMIT;
      CONTINUE;
    END IF;

    -- FFRQ
    IF CUR_LC.FFRQ IS NULL THEN
      UPDATE CKTS_LC_TSSB T
         SET T.FFRQ = (SELECT FFRQ FROM HX_CKTS.CKTS_TY_YWBLXX S WHERE S.UUID=CUR_LC.UUID)
       WHERE T.UUID=CUR_LC.UUID;
      COMMIT;
    END IF;

    -- FSSJ,YWHZSJ,FSZZSTSE,FSXFSTSE,FSMDSE
    BEGIN
      SELECT MIN(YW.LRRQ),MIN(YW.YWHZSJ),NVL(SUM(YW.FSZZSTSE-YW.ZKZZSTSE),0),NVL(SUM(YW.FSXFSTSE-YW.ZKXFSTSE),0),NVL(SUM(YW.FSMDSE),0)
        INTO LD_FSSJ, LD_YWHZSJ, LN_FSZZSTSE, LN_FSXFSTSE, LN_FSMDSE
        FROM HX_CKTS.CKTS_TY_YWHZB YW
       WHERE YW.LCSLID=CUR_LC.LCSLID;
    EXCEPTION
      WHEN OTHERS THEN
        LD_FSSJ := NULL;
        LD_YWHZSJ := NULL;
        LN_FSZZSTSE := 0;
        LN_FSXFSTSE := 0;
        LN_FSMDSE := 0;
    END;
    UPDATE CKTS_LC_TSSB T
       SET T.FSSJ = LD_FSSJ,
           T.YWHZSJ = LD_YWHZSJ,
           T.FSZZSTSE = LN_FSZZSTSE,
           T.FSXFSTSE = LN_FSXFSTSE,
           T.FSMDSE= LN_FSMDSE
     WHERE T.UUID=CUR_LC.UUID;
    COMMIT;

    --SEHZRQ,SEHZZZSTSE,SEHZXFSTSE
    BEGIN
      SELECT MIN(SE.SEHZRQ), NVL(SUM(SE.SEHZZZSTSE),0), NVL(SUM(SE.SEHZXFSTSE),0), NVL(SUM(SE.BYHZZZSTSE),0), NVL(SUM(SE.BYHZXFSTSE),0)
        INTO LD_SEHZRQ, LN_SEHZZZSTSE, LN_SEHZXFSTSE, LN_BYHZZZSTSE, LN_BYHZXFSTSE
        FROM HX_CKTS.CKTS_TY_SEHZB SE
       WHERE SE.LCSLID=CUR_LC.LCSLID;
    EXCEPTION
      WHEN OTHERS THEN
        LD_SEHZRQ := NULL;
        LN_SEHZZZSTSE := 0;
        LN_SEHZXFSTSE := 0;
        LN_BYHZZZSTSE := 0;
        LN_BYHZXFSTSE := 0;
    END;
    UPDATE CKTS_LC_TSSB T
       SET T.SEHZRQ = LD_SEHZRQ,
           T.SEHZZZSTSE = LN_SEHZZZSTSE,
           T.SEHZXFSTSE = LN_SEHZXFSTSE,
           T.BYHZZZSTSE = LN_BYHZZZSTSE,
           T.BYHZXFSTSE = LN_BYHZXFSTSE
     WHERE T.UUID=CUR_LC.UUID;
    COMMIT;

    --SSRTHSBH,SSSRTHSSE,KPRQ
    BEGIN
      IF LN_SEHZZZSTSE>0 THEN
        SELECT SSRTHSBH, SSSRTHSSE, KPRQ
          INTO LC_SSRTHSBH, LN_SSSRTHSSE, LD_KPRQ
          FROM (SELECT SSRTHSBH, SSSRTHSSE, KPRQ
                  FROM (SELECT SE.ZZSSSSRTHSBH AS SSRTHSBH,SUM(SE.SEHZZZSTSE) AS SSSRTHSSE,MIN(TH.KPRQ) AS KPRQ
                          FROM HX_CKTS.CKTS_TY_SEHZB SE
                          LEFT JOIN HX_ZS.ZS_YDTXX ZS ON ZS.YDTLYUUID=SE.ZZSSSSRTHSBH
                          LEFT JOIN HX_ZS.ZS_SRTHS TH ON TH.YDTUUID=ZS.YDTUUID
                         WHERE SE.ZZSSSSRTHSBH IN (SELECT S.ZZSSSSRTHSBH FROM HX_CKTS.CKTS_TY_SEHZB S WHERE S.LCSLID=CUR_LC.LCSLID)
                         GROUP BY SE.ZZSSSSRTHSBH) TT
                 ORDER BY KPRQ, SSSRTHSSE DESC) TTT
         WHERE ROWNUM=1;
      ELSIF LN_SEHZXFSTSE>0 THEN
        SELECT SSRTHSBH, SSSRTHSSE, KPRQ
          INTO LC_SSRTHSBH, LN_SSSRTHSSE, LD_KPRQ
          FROM (SELECT SSRTHSBH, SSSRTHSSE, KPRQ
                  FROM (SELECT SE.XFSSSSRTHSBH AS SSRTHSBH,SUM(SE.SEHZXFSTSE) AS SSSRTHSSE,MIN(TH.KPRQ) AS KPRQ
                          FROM HX_CKTS.CKTS_TY_SEHZB SE
                          LEFT JOIN HX_ZS.ZS_YDTXX ZS ON ZS.YDTLYUUID=SE.XFSSSSRTHSBH
                          LEFT JOIN HX_ZS.ZS_SRTHS TH ON TH.YDTUUID=ZS.YDTUUID
                         WHERE SE.XFSSSSRTHSBH IN (SELECT S.XFSSSSRTHSBH FROM HX_CKTS.CKTS_TY_SEHZB S WHERE S.LCSLID=CUR_LC.LCSLID)
                         GROUP BY SE.XFSSSSRTHSBH) TT
                 ORDER BY KPRQ, SSSRTHSSE DESC) TTT
         WHERE ROWNUM=1;
      ELSE
        LC_SSRTHSBH := NULL;
        LN_SSSRTHSSE := 0;
        LD_KPRQ := NULL;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        LC_SSRTHSBH := NULL;
        LN_SSSRTHSSE := 0;
        LD_KPRQ := NULL;
    END;
    UPDATE CKTS_LC_TSSB T
       SET T.SSRTHSBH = LC_SSRTHSBH,
           T.SSSRTHSSE = LN_SSSRTHSSE,
           T.KPRQ = LD_KPRQ
     WHERE T.UUID=CUR_LC.UUID;
    COMMIT;

    -- 判断流程是否结束
    IF LD_FSSJ IS NULL THEN
      --无复审记录，两种情况，一种还未复审，一种全部分流主流程不需要复审，看发放情况
      UPDATE CKTS_LC_TSSB T
         SET T.LCJSSJ=T.FFRQ
       WHERE T.UUID=CUR_LC.UUID;
      COMMIT;
    ELSIF LD_SEHZRQ IS NULL THEN
      -- 有复审记录，无税额核准日期
      IF LD_YWHZSJ IS NULL THEN
        --无业务核准日期，两种情况，一种情况有退免税额待核准，一种复审无退免税额不需要核准，看发放情况
        UPDATE CKTS_LC_TSSB T
           SET T.LCJSSJ=T.FFRQ
         WHERE T.UUID=CUR_LC.UUID; --剔除A类企业预退税有可能无业务核准有税额核准
        COMMIT;
      ELSE
        --有业务核准日期，两种情况，一种情况无退免税额，一种情况有退免税额，看复审退税额
        UPDATE CKTS_LC_TSSB T
           SET T.LCJSSJ=CASE WHEN (LN_FSZZSTSE + LN_FSXFSTSE) <= 0 THEN LD_YWHZSJ ELSE NULL END
         WHERE T.UUID=CUR_LC.UUID;
        COMMIT;
      END IF;
    ELSIF LD_KPRQ IS NULL THEN
      --有税额核准表，无开票日期，四种情况，一种情况无复审退税额，一种情况无核准退税额，一种情况正负对冲，一种待开票
      UPDATE CKTS_LC_TSSB T
         SET T.LCJSSJ=CASE WHEN (LN_FSZZSTSE + LN_FSXFSTSE) <= 0 THEN LD_YWHZSJ
                           -- 原：WHEN (LN_SEHZZZSTSE + LN_SEHZXFSTSE) <= 0 THEN LD_SEHZRQ
                           -- 一类企业预退税数据有时候税额核准表没有及时产生，导致判断错误，改为复审减不予核准等于0时无核准
                           WHEN (LN_FSZZSTSE + LN_FSXFSTSE) - (LN_BYHZZZSTSE + LN_BYHZXFSTSE) = 0 THEN LD_SEHZRQ
                           WHEN LC_SSRTHSBH IS NOT NULL AND LN_SSSRTHSSE<=0 THEN LD_SEHZRQ
                           ELSE NULL END
       WHERE T.UUID=CUR_LC.UUID;
      COMMIT;
    ELSE
      --有开票日期，需要考虑A类企业部分预退税部分审核退税，根据复审通过数减税额核准结果判断
      UPDATE CKTS_LC_TSSB T
         SET T.LCJSSJ=CASE WHEN (LN_FSZZSTSE + LN_FSXFSTSE) - (LN_BYHZZZSTSE + LN_BYHZXFSTSE) - (LN_SEHZZZSTSE + LN_SEHZXFSTSE) = 0 THEN LD_KPRQ
                           ELSE NULL END
       WHERE T.UUID=CUR_LC.UUID;
      COMMIT;
    END IF;

    -- 周边业务不分流，按是否存在审核疑点处理判断是否存在调查评估环境
    SELECT COUNT(1)
      INTO LN_ZBYWDCPG
      FROM HX_CKTS.CKTS_TY_YWBLXX
     WHERE UUID=CUR_LC.UUID
       AND CUR_LC.LCSWSX_DM IN ('LCSXA081042001','LCSXA081042002','LCSXA081042006')
       AND EXISTS (SELECT 1 FROM HX_CKTS.CKTS_BL_ZB_SHYDCL_GCB GC WHERE GC.LCSLID=CUR_LC.LCSLID
                    UNION ALL
                   SELECT 1 FROM HX_CKTS.CKTS_BL_ZB_SHYDCL_JGB JG WHERE JG.LCSLID=CUR_LC.LCSLID);

    -- 从受理企业申报之日（打印受理时间）开始计算是否即将逾期，是否超期
    UPDATE CKTS_LC_TSSB T
       SET LCYQDSJ=COMPUTE_BLDATE(T.LCJSSJ,T.DYSLTZSJ)
     WHERE T.UUID=CUR_LC.UUID;
    COMMIT;

    UPDATE CKTS_LC_TSSB T
       SET LCZT=CASE WHEN T.LCJSSJ IS NOT NULL
                     THEN (CASE WHEN T.LCYQDSJ>CUR_LC.CQ_DAY AND LN_ZBYWDCPG=0
                                THEN '12'
                                ELSE '10'
                           END)
                     ELSE (CASE WHEN T.LCYQDSJ>CUR_LC.CQ_DAY AND LN_ZBYWDCPG=0
                                THEN '02'
                                WHEN T.LCYQDSJ>CUR_LC.JJYQ_DAY AND LN_ZBYWDCPG=0
                                THEN '01'
                                ELSE '00'
                           END)
                END
     WHERE T.UUID=CUR_LC.UUID;
    COMMIT;
  END LOOP;

  RETURN;
END;
/

prompt
prompt Creating procedure PRO_DEAL_FXNK_NBFXDMX_SH
prompt ===========================================
prompt
CREATE OR REPLACE PROCEDURE PRO_DEAL_FXNK_NBFXDMX_SH
/*
 * 风险内控的事后监督
 * 20231219，2023052401指标，原业务需求中包含出口企业案源管理台账的数据源，但很多税局反映案源管理台账中的企业不一定停止出口退税权，改为单一从税务行政处罚决定书来源
 * 20231219，2023073101指标，剔除“因分类管理等级评定为D类，系统自动增加TGSHZL的扩展类型”的原因
 * 20231221，2023051801指标，根据滨江反映结果，增加发函已签发的条件
 * 20231221，2023051801指标，根据临平反馈结果，增加正常回函后又发延期函情形的剔除
 * 20231221，2023052201指标，根据滨江意见核实结果，修改回函表关联条件
 * 20231221，2023073001指标，根据滨江反馈、李局意见，回函仅筛选有明确结论的（正常业务or异常业务），供货企业必须为生产企业
 * 20231211，2023074101指标，按省局李裕军局长意见，企业申报记录先按包括零申报、零核准判定
 * 20240110，2023050101指标，根据2023年以后数据分析，退补原因主要470离境退税490调整免抵190其他退税，剔除470与490
 * 20240116，2024010101指标，根据绍兴市局事中预警需求增加
 * 20240216，2024020101指标，根据李局意见增加
 * 20240423，2023050101指标，剔除企业有相同税额补税入库情况
 * 20240423，2023051101指标，实地核查台账增加12类型（转登记一般纳税人后首次申报）
 * 20240613，2023051601指标，根据总局督察数据及条件,增加发函文书种类条件(FH.DZBZDSZL_DM='BDA1320284'),变更剔除追溯发函条件(NVL(FH.YFHZBBLTSE,0)>0),删除回函处理意见条件(FUH.FHCLYJ_DM='3')
 * 20240614，2023051103指标，根据总局督查结果取数语句增加
 * 20240614，2024060101指标，根据李局意见增加
 * 20240614，2024060201指标，根据李局意见增加
 * 20240729，2023052201指标，根据上城意见，核实结果，对发票部分先核准，部分后续发函加时间控制，对同一发票非本地管辖二次发函按最后一次发函取数
 * 20240814，2023052401指标，因从处罚到实际停权需上报省局有时间间隔，增加文书制作后一个月的条件
 * 20250225，2023050601指标，将稽查立案数据源从出口企业案源管理台账改为稽查案件信息，按案件名称含“骗税”或立案原因含“骗税”、“骗取”过滤
 * 20250226，2023050602指标，将稽查立案数据源从出口企业案源管理台账改为稽查案件信息后，是否与2023050603合并或取消本指标
 * 20250226，2023050603指标，将违法事实条件含'%出口%骗税%'字样改为含'出口'、且含'退税'或'骗税'字样
 * 20250226，2023050801指标，对结果进行分析，总共160条风险提示，150条为信用等级修复，是否需要剔除，如何剔除？
 * 20250226，2023050901指标，将违法事实条件含'%出口%骗税%'字样改为含'出口'、且含'退税'或'骗税'字样
 * 20250303，2024060201指标，根据杭州反馈及广特办取数口径，起草人从lrrDm改为lxrDm
 * 20250305，2023051301指标，根据舟山反馈每年只要在6月底之前完成实地核查即可，因此取先退后核企业从每年7月1号之前开始检测
 * 20250312，2025030301指标，根据李局意见增加
 * 20250331，2023051501指标，根据李裕军局长要求，将间隔12个月改成间隔10个月
 * 20250415，2023052201指标，根据杭州市局反馈，原要求有正常回函口径有问题，临平局有异常回函，对异常回函涉及发票不予退税，其他发票准予退税，被筛选出来了
 * 20250422，2023051801指标，根据杭州市局王薇反映结果，取消正常回函后又发延期函情形的剔除。
 * 20250423，2023071401指标，根据总局下发疑点，对应核实函编号111019600202302020084，有两次回函正常，第二次有扫描结果没记录
 * 20250514，2025050101指标，根据李局意见增加
 * 20250514，2025050201指标，根据李局意见增加
 * 20250514，2025050301指标，根据李局意见增加
 * 20250514，20250504指标，根据李局意见增加
 * 20250521，2023050603指标，为防止一户企业多次被处罚导致数据重复，JCJAQY中UUID从BA.UUID改为CF.SWXZCFJDSUUID
 * 20250530，根据云和反馈意见的测试结果，对所有字符串类型的空值判断，都加上TRIM(A)函数
 * 20250717，2023072901指标，根据张蕴琛反馈意见，调整疑点描述返回信息，加上核实函编号，取消发函、回函、回函处理日期信息
 * 20250807，2023072501指标，根据拱墅反馈意见增加立案日期小于结案日期的限定
 * 20250812，2023051701指标，取消回函处理日期输出，条件改为“非本地管辖回函签发以后1个月内没有重新发函”
 * 20250812，2023071301指标，因回函处理日期、回函处理意见已不在回函表中，本指标暂时取消，后续确定数据以后重新优化。
 * 20250826，2023051601指标，检查历史供货记录的时候加金三并库前免退税进货老表
 * 20250901，鉴于etl调用时卡住缺少日志，统一在每个指标处理添加日志记录。
 * 20250902，2023050201指标，根据运行日志，优化查询条件以提升效率
 * 20250902，2023052201指标，根据运行日志，优化查询条件以提升效率
 * 20250902，2023071101指标，根据运行日志，优化查询条件以提升效率
 * 20250902，金华市增加2025090101指标事中预警，四类企业首次申报跨大类（海关编码前4位）商品
 * 20250902，金华市增加2025090201指标事中预警，9810业务非预退税申报
 * 20250910，萧山区增加2025090301指标事中预警，供货企业发函未回
 * 20250918，全省增加2025090401指标事后监督，针对金三A0230疑点的挑过情况，提取申报征收率大于计算征收率的正数数据
 * 20251010，2025090101-2025090301调整为全省运行
 * 20251010，2025090301指标事中预警，判断发函增加未作废条件，判断回函类型由原先的FUH.FHLX_DM IN ('1','2')改为NVL(FUH.FHLX_DM,'3')<>'3'
 * 20260126，2023052301指标，退税进货加不予办理为N条件，同时关联出口加不予退税、不予办理为N条件
 * 20260126，2023071601指标，获取应追回数据时增加返回空值的判断
 * 20260126，2023051501指标，四类企业供货的录入日期由流程的录入日期改为进货明细的录入日期，从而还原用户申报日期，同时不予退税、不予办理关联出口明细
 * 20260127，2023050701指标，针对停权有效期止为21001231的，无法再加24个月，调整为sysdate<yxqz or sysdate<add_months(yxqz,24)
 * 20260209，2023074601指标，根据新政策“出口企业默认无纸化申报”，取消
 * 20260310，2023051101、2023051301、2023071001指标，根据萧山区反馈，增加实地核查的核查原因代码
 * 20260409，2023051601指标，对不予退税回函增加后续没有不予改准予的条件过滤
 * 20260409，2023051901指标，对稽查是否结案按稽查结案日期+税务行政处罚决定书制作日期+税务处理决定书制作日期较小者，同时剔除案源撤销数据
 * 20260421，2023051401指标，将进料加工核销期限从4月21日调整为5月1日
 * 20260428，2023071401指标，将收到异常函回复正常口径调整为未收到正常函回函正常
 * 20260617，2023052802指标，增加备案变更时已出口未结清出口业务的剔除条件
 * 20260618，2023051401指标，对上年有申报，海关未核销的电子账册不再强制核销
 * 20260707，2023070701、2023070702指标，对长期未办结退免税事项增加门户流程信息关联，确保流程在金三前台可见
 * 20260724，2023052201指标，根据钱塘区反馈意见，增加对免退税进货结果表不予办理、不予退税、暂不办理的筛选
 * 20260807，2023052201指标，增加事中预警功能
 * 20260807，2023052401指标，处罚决定由原来的含“出口退税”改为含“停止*出口退税”
 * 20260831，2023051601指标，因clob字段太长导致to_char语句出错，改用dbms_lob.instr函数判断是都追溯发函
 */
AS
  LD_SJCL_M     DATE;
  LD_SJCL_Y     DATE;
BEGIN
  LD_SJCL_M := TRUNC(ADD_MONTHS(SYSDATE,-1),'MM');
  LD_SJCL_Y := TRUNC(ADD_MONTHS(SYSDATE,-1),'YY');

  -- 内部风险点明细
  EXECUTE IMMEDIATE 'TRUNCATE TABLE FXNK_NBFXDMX_SH';
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('Begin...');
  COMMIT;

  -- 办理特殊核准退税业务
  -- 2023050101   事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ,LCSWSX_DM,LCSLID)
       SELECT '2023050101',  -- '综合管理类','TSHZ',
              T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,T.YTZZSE+T.YTXFSE+T.MDSE,
              '【退补原因】'||T.TBYY_DM||'；【原因说明】'||T.TSHZTSSM,T.LRRQ,SYSDATE,'LCSXA082042001',T.LCSLID
         FROM HX_CKTS.CKTS_TS_TSHZTS_JGB T
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
        WHERE T.LRRQ>=LD_SJCL_M
          AND T.TBYY_DM='190'
          AND NOT EXISTS (SELECT 1 FROM HX_ZS.ZS_JKS S WHERE S.DJXH=T.DJXH GROUP BY S.DZSPHM HAVING SUM(S.SJJE)=T.YTZZSE)
          AND NOT EXISTS (SELECT 1 FROM HX_ZS.ZS_JKS S WHERE S.DJXH=T.DJXH GROUP BY S.DZSPHM,S.DZSPMXXH HAVING SUM(S.SJJE)=T.YTZZSE);
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023050101...');
  COMMIT;

  -- 不相容环节存在兼岗
  -- 2023050201   事中
  -- 流程审核、调评、复审、分流复审环节人员代码是否重复
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ,LCSWSX_DM,LCSLID)
         WITH LZHJ AS (
       SELECT SUBSTR(YW.LCSWSX_DM,1,11) AS LCSWSX,YW.DJXH,YW.SSQ,YW.SBPC,BL.LCHJ_DM,DECODE(BL.LCHJ_DM,'08','04',BL.LCHJ_DM) AS LCHJ_DM_2,BL.TS_RYDM
         FROM HX_CKTS.CKTS_TY_YWBLXX YW
        INNER JOIN HX_CKTS.CKTS_TY_TSSBYWBL_MXB BL ON BL.LCSLID=YW.LCSLID
        WHERE REGEXP_LIKE(YW.LCSWSX_DM,'^LCSXA081038|^LCSXA081039|^LCSXA081040|^LCSXA081042')
          AND NVL(YW.ZFBZ_1,'N')<>'Y' AND YW.QDSJ>=LD_SJCL_M
          AND BL.LCHJ_DM IN ('02','03','04','08') --审核、调评、复审、分流复审
       ),
         JGRY AS (
       SELECT LCSWSX,DJXH,SSQ,SBPC,TS_RYDM,COUNT(DISTINCT LCHJ_DM_2)
         FROM LZHJ
        GROUP BY LCSWSX,DJXH,SSQ,SBPC,TS_RYDM
       HAVING COUNT(DISTINCT LCHJ_DM_2)>1
       ),
         FXLC AS (
       SELECT JGRY.LCSWSX,JGRY.DJXH,JGRY.SSQ,JGRY.SBPC,JGRY.TS_RYDM,RY.SWRYXM,
              T.UUID,T.TSSWJG_DM_1,T.QDSJ,T.LCSWSX_DM,T.LCSLID,
              ROW_NUMBER() OVER (PARTITION BY JGRY.LCSWSX,JGRY.DJXH,JGRY.SSQ,JGRY.SBPC ORDER BY T.HTBZ_1 NULLS FIRST) RN,
              (SELECT LISTAGG(DM.LCHJMC,',') WITHIN GROUP(ORDER BY LZHJ.LCHJ_DM)
                 FROM LZHJ
                INNER JOIN HX_DM_ZDY.DM_CKTS_LCHJ DM ON DM.LCHJ_DM=LZHJ.LCHJ_DM
                WHERE LZHJ.DJXH=JGRY.DJXH AND LZHJ.SSQ=JGRY.SSQ AND NVL(LZHJ.SBPC,0)=NVL(JGRY.SBPC,0) AND LZHJ.TS_RYDM=JGRY.TS_RYDM) AS JGQK
         FROM JGRY
        INNER JOIN HX_CKTS.CKTS_TY_YWBLXX T ON T.DJXH=JGRY.DJXH AND T.SSQ=JGRY.SSQ AND NVL(T.SBPC,0)=NVL(JGRY.SBPC,0)
          AND SUBSTR(T.LCSWSX_DM,1,11)=JGRY.LCSWSX AND NVL(T.ZFBZ_1,'N')<>'Y' AND T.LCSLID=T.ZLCLCSLID
        INNER JOIN HX_DM_ZDY.DM_GY_SWRY RY ON RY.SWRY_DM=JGRY.TS_RYDM
       )
       SELECT '2023050201',  -- '综合管理类','GWZY-LZHJ',
              FXLC.UUID,FXLC.TSSWJG_DM_1,FXLC.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【流程事项】'||FXLC.LCSWSX||'；【所属期批次】'||FXLC.SSQ||FXLC.SBPC||
              '；【兼岗人员】'||FXLC.TS_RYDM||FXLC.SWRYXM||'；【兼岗情况】'||FXLC.JGQK,
              FXLC.QDSJ,SYSDATE,FXLC.LCSWSX_DM,FXLC.LCSLID
         FROM FXLC
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=FXLC.DJXH
        WHERE RN=1;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023050201...');
  COMMIT;
  -- 2023050204   事中
  -- 免抵退分流流程的疑点业务处理表，审核人员与复审人员相同
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ,LCSWSX_DM,LCSLID)
       SELECT DISTINCT '2023050204',  -- '综合管理类','GWZY-YDCL_MDT',
              T.LCSLID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【流程事项】LCSXA081038006；【所属期批次】'||T.SSQ||'；【兼岗人员】'||T.SHR_DM||RY.SWRYXM,
              T.XGRQ,SYSDATE,'LCSXA081038006',T.LCSLID
         FROM HX_CKTS.CKTS_BL_MDT_SHYDCL_JGB T
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
        INNER JOIN HX_DM_ZDY.DM_GY_SWRY RY ON RY.SWRY_DM=T.SHR_DM
        WHERE T.XGRQ>=LD_SJCL_M AND T.SHR_DM=T.FSR_DM_1;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023050204...');
  COMMIT;

  -- 备案撤回未结清税款
  -- 2023050301   事中
  -- 2023050302   事中
  -- 2023050303   事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023050301',  -- '综合管理类','BACH-WJQSK',
              BA.UUID,BA.TSSWJG_DM_1,BA.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,
              (SELECT NVL(SUM(TS.SE),0) FROM HX_ZS.ZS_YDTXX TS
              LEFT JOIN HX_ZS.ZS_SRTHS TH ON TH.YDTUUID=TS.YDTUUID AND TH.TZLX_DM IN ('1','4')
              WHERE TS.DJXH=BA.DJXH AND TS.TTSJLX_DM='01' AND TS.TZLX_DM='1' AND TS.TDSFS_DM='1' AND TH.THRQ_1 IS NULL),
              '【备案撤回日期】'||TO_CHAR(BA.BACHRQ,'YYYY-MM-DD')||
              '；【已核准待开具退税额】'||(SELECT SUM(TS.SE) FROM HX_ZS.ZS_YDTXX TS
              LEFT JOIN HX_ZS.ZS_SRTHS TH ON TH.YDTUUID=TS.YDTUUID AND TH.TZLX_DM IN ('1','4')
              WHERE TS.DJXH=BA.DJXH AND TS.TTSJLX_DM='01' AND TS.TZLX_DM='1' AND TS.TDSFS_DM='1' AND TH.THRQ_1 IS NULL),BA.BACHRQ,SYSDATE
         FROM HX_CKTS.CKTS_BA_BAXX_JGB BA
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=BA.DJXH
        WHERE BA.BACHRQ>=LD_SJCL_M
          AND EXISTS (SELECT 1
                        FROM HX_ZS.ZS_YDTXX YDT
                        LEFT JOIN HX_ZS.ZS_SRTHS THS ON THS.YDTUUID=YDT.YDTUUID AND THS.TZLX_DM IN ('1','4')
                       WHERE YDT.DJXH=BA.DJXH AND YDT.TTSJLX_DM='01' AND YDT.TZLX_DM='1' AND YDT.TDSFS_DM='1' AND THS.THRQ_1 IS NULL)
        UNION ALL
       SELECT '2023050302',  -- '综合管理类','BACH-WJQSK',
              BA.UUID,BA.TSSWJG_DM_1,BA.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,
              (SELECT NVL(SUM(MD.MD_AMT),0) FROM HX_ZS.ZS_CKTS_MDT MD
              LEFT JOIN HX_ZS.ZS_TKGZ TK ON TK.DJXH=MD.DJXH AND TK.BTKGZUUID=MD.CKTS_NO AND TK.TZSLY='3' AND TK.TZLX_DM='1' AND TK.GZBZ='Y' AND TK.ZFRQ_1 IS NULL
              WHERE MD.DJXH=BA.DJXH AND MD.TZLX_DM='1' AND TK.GKGZRQ IS NULL),
              '【备案撤回日期】'||TO_CHAR(BA.BACHRQ,'YYYY-MM-DD')||
              '；【已核准待调库免抵额】'||(SELECT SUM(MD.MD_AMT) FROM HX_ZS.ZS_CKTS_MDT MD
              LEFT JOIN HX_ZS.ZS_TKGZ TK ON TK.DJXH=MD.DJXH AND TK.BTKGZUUID=MD.CKTS_NO AND TK.TZSLY='3' AND TK.TZLX_DM='1' AND TK.GZBZ='Y' AND TK.ZFRQ_1 IS NULL
              WHERE MD.DJXH=BA.DJXH AND MD.TZLX_DM='1' AND TK.GKGZRQ IS NULL),BA.BACHRQ,SYSDATE
         FROM HX_CKTS.CKTS_BA_BAXX_JGB BA
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=BA.DJXH
        WHERE BA.BACHRQ>=LD_SJCL_M
          AND EXISTS (SELECT 1
                        FROM HX_ZS.ZS_CKTS_MDT MDT
                        LEFT JOIN HX_ZS.ZS_TKGZ GZ ON GZ.DJXH=MDT.DJXH AND GZ.BTKGZUUID=MDT.CKTS_NO
                         AND GZ.TZSLY='3' AND GZ.TZLX_DM='1' AND GZ.GZBZ='Y' AND GZ.ZFRQ_1 IS NULL
                       WHERE MDT.DJXH=BA.DJXH AND MDT.TZLX_DM='1' AND GZ.GKGZRQ IS NULL)
        UNION ALL
       SELECT '2023050303',  -- '综合管理类','BACH-WJQSK-JLJG',
              BA.UUID,BA.TSSWJG_DM_1,BA.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,HZ.JZXQMDTSE,
              '【备案撤回日期】'||TO_CHAR(BA.BACHRQ,'YYYY-MM-DD')|| '；【最后一次免抵退申报所属期】'||HZ.SSQ||'；【结转下期免抵退税额】'||HZ.JZXQMDTSE,
              BA.BACHRQ,SYSDATE
         FROM HX_CKTS.CKTS_BA_BAXX_JGB BA
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=BA.DJXH
        INNER JOIN HX_CKTS.CKTS_SB_MDT_SBDSHZ_JGB HZ ON HZ.DJXH=BA.DJXH
        WHERE BA.BACHRQ>=LD_SJCL_M
          AND HZ.JZXQMDTSE<>0
          AND NOT EXISTS (SELECT 1 FROM HX_CKTS.CKTS_SB_MDT_SBDSHZ_JGB S WHERE S.DJXH=HZ.DJXH AND S.SSQ>HZ.SSQ);
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023050303...');
  COMMIT;

  -- 平均办理时限超期
  -- 2023050401   X
  -- 2023050402   X
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       -- 税总纳服发2022年第5号"将全国正常出口退税平均办理时间由7个工作日压缩至6个工作日以内"
       SELECT '2023050401',  -- '综合管理类','CQBL-PJSX',
              T.TSSWJG_DM_1||'-'||TO_CHAR(LD_SJCL_Y,'YYYYMMDD')||'-'||TO_CHAR(TRUNC(SYSDATE,'MM')-1,'YYYYMMDD')||'-AD',T.TSSWJG_DM_1,NULL,NULL,NULL,NULL,NULL,
              '【出口退税业务平均办理时限】'||TO_CHAR(ROUND(AVG(T.LCYQDSJ),2)),SYSDATE,SYSDATE
         FROM CKTS_LC_TSSB T
        WHERE T.KHJZSJ IS NOT NULL AND T.QDSJ>=LD_SJCL_Y AND T.QDSJ<TRUNC(SYSDATE,'MM')
        GROUP BY T.TSSWJG_DM_1 HAVING AVG(T.LCYQDSJ)>6
        UNION ALL
       -- 税总货劳函2022年第83号"自2022年6月20日至2023年6月30日期间，税务部门办理一类、二类出口企业正常出口退（免）税的平均时间，压缩在3个工作日内"
       SELECT '2023050402',  -- '综合管理类','CQBL-PJSX-AB',
              T.TSSWJG_DM_1||'-'||TO_CHAR(LD_SJCL_Y,'YYYYMMDD')||'-'||TO_CHAR(TRUNC(SYSDATE,'MM')-1,'YYYYMMDD')||'-AD',T.TSSWJG_DM_1,NULL,NULL,NULL,NULL,NULL,
              '【一二类企业出口退税业务平均办理时限】'||TO_CHAR(ROUND(AVG(T.LCYQDSJ),2)),SYSDATE,SYSDATE
         FROM CKTS_LC_TSSB T
        WHERE T.KHJZSJ IS NOT NULL AND T.QDSJ>=LD_SJCL_Y AND T.QDSJ<TRUNC(SYSDATE,'MM')
          AND T.CKQYGLLB_DM IN ('A','B')
        GROUP BY T.TSSWJG_DM_1 HAVING AVG(T.LCYQDSJ)>3;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023050402...');
  COMMIT;

  -- 逾期办结出口退（免）税
  -- 2023050403   单独短信提醒
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ,LCSWSX_DM,LCSLID)
       SELECT '2023050403',  -- '综合管理类','CQBL-TSSB',
              T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【所属期批次】'||T.SSQ||T.SBPC||'；【出口企业管理类别】'||T.CKQYGLLB_DM||'；【启动时间】'||TO_CHAR(T.QDSJ,'YYYYMMDD')||'；【办结时间】'||
              TO_CHAR(T.LCJSSJ,'YYYYMMDD')||'；【办理周期】'||TO_CHAR(ROUND(T.LCYQDSJ,2))||'(未办结的按启动至刷新时间计算)',
              T.KHJZSJ,SYSDATE,T.LCSWSX_DM,T.LCSLID
         FROM CKTS_LC_TSSB T
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
        WHERE T.QDSJ>=LD_SJCL_Y AND T.LCZT IN ('02','12');
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023050403...');
  COMMIT;

  -- 未在规定期限内完成分类管理年度评定（按年统计）
  -- 2023050501   事前（纳税信用评定后1个月）
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023050501',  -- '综合管理类','FLGL-X-NDPD',
              T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【纳税信用等级评定时间】'||TO_CHAR(T.NSXYDJPDSJ,'YYYYMMDD')||'；【评定结果】'||T.NSXYDJ||
              '；【管理类别年度评定核准时间】'||TO_CHAR(T.HZSJ,'YYYYMMDD')||'(未核准的按刷新时间计算)'||'；【评定结果】'||T.PDGLLB_DM,
              T.HZSJ,SYSDATE
         FROM (SELECT JGB.TSSWJG_DM_1,JGB.UUID,JGB.DJXH,S.PJJB AS NSXYDJ,S.FBSJ AS NSXYDJPDSJ,JGB.PDGLLB_DM,JGB.HZSJ
                 FROM HX_CKTS.CKTS_QT_QYGLLBPD_JGB JGB
                INNER JOIN HX_CKTS.CKTS_BA_BAXX_JGB BA ON BA.DJXH=JGB.DJXH AND BA.BACHBZ='N'
                INNER JOIN FXNK_JC2B_NSXYPJ S ON S.DJXH=JGB.DJXH AND S.PJND=JGB.SSND AND S.PJJB<>'M'
                WHERE JGB.LRRQ>=LD_SJCL_M
                  AND NOT EXISTS (SELECT 1 FROM HX_CKTS.CKTS_QT_QYGLLBPD_JGB PRE
                                   WHERE PRE.DJXH=JGB.DJXH AND PRE.LRRQ>=TRUNC(JGB.LRRQ,'YY') AND PRE.LRRQ<JGB.LRRQ)
                UNION ALL
               SELECT GCB.TSSWJG_DM_1,GCB.UUID,GCB.DJXH,S.PJJB AS NSXYDJ,S.FBSJ AS NSXYDJPDSJ,GCB.PDGLLB_DM,NVL(GCB.HZSJ,SYSDATE) AS HZSJ
                 FROM HX_CKTS.CKTS_QT_QYGLLBPD_GCB GCB
                INNER JOIN HX_CKTS.CKTS_BA_BAXX_JGB BA ON BA.DJXH=GCB.DJXH AND BA.BACHBZ='N'
                INNER JOIN FXNK_JC2B_NSXYPJ S ON S.DJXH=GCB.DJXH AND S.PJND=GCB.SSND AND S.PJJB<>'M'
                WHERE GCB.LRRQ>=LD_SJCL_M
                  AND NOT EXISTS (SELECT 1 FROM HX_CKTS.CKTS_QT_QYGLLBPD_JGB PRE
                                   WHERE PRE.DJXH=GCB.DJXH AND PRE.LRRQ>=TRUNC(GCB.LRRQ,'YY') AND PRE.LRRQ<GCB.LRRQ)
              ) T
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH AND DJ.NSRZT_DM NOT IN ('05','07','08')
        WHERE MONTHS_BETWEEN(T.HZSJ,T.NSXYDJPDSJ)>=1;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023050501...');
  COMMIT;

  -- 一类、二类企业因涉嫌骗取出口退税被立案查处尚未结案的，未按规定将出口企业暂按三类管理
  -- 2023050601   事前（立案已经满20个工作日）
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH JCLAQY AS (
       SELECT BA.TSSWJG_DM_1,BA.DJXH,AJ.JCAJXXUUID,AJ.LARQ,AJ.AJMC,TO_CHAR(SUBSTR(SQ.XAFXJLAYJ,1,500)) AS LAYJ
         FROM HX_CKTS.CKTS_BA_BAXX_JGB BA
        INNER JOIN HX_JC.JC_AYXX AY ON AY.DJXH = BA.DJXH
        INNER JOIN HX_JC.JC_LASQB SQ ON SQ.JCAYXXUUID = AY.JCAYXXUUID
        INNER JOIN HX_JC.JC_AJXX AJ ON AJ.JCAJXXUUID = AY.JCAJXXUUID
        WHERE AJ.LARQ>=LD_SJCL_M --时间范围
          AND COMPUTE_BLJZDATE('D',AJ.LARQ)<TRUNC(SYSDATE) --立案满20个工作日
          AND AJ.JARQ IS NULL --未结案
          AND AJ.ZFBZ_1 = 'N' --未作废
          AND (REGEXP_LIKE(AJ.AJMC,'骗税') OR REGEXP_LIKE(SQ.XAFXJLAYJ,'骗税|骗取')) --案件名称含“骗税”或立案原因含“骗税”、“骗取”
       )
       SELECT '2023050601',  -- '综合管理类','FLGL-C-JCLAQY',
              JCLAQY.JCAJXXUUID,JCLAQY.TSSWJG_DM_1,JCLAQY.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【稽查立案日期】'||TO_CHAR(JCLAQY.LARQ,'YYYYMMDD')||'；【案件名称】'||JCLAQY.AJMC||'；【立案原因】'||JCLAQY.LAYJ||
              '；【立案前分类管理类别】'||A.KZNR||'；【有效期起止】'||TO_CHAR(A.YXQQ,'YYYYMMDD')||'-'||TO_CHAR(A.YXQZ,'YYYYMMDD')||
              '；【立案后20个工作日分类管理类别】'||B.KZNR||'；【有效期起止】'||TO_CHAR(B.YXQQ,'YYYYMMDD')||'-'||TO_CHAR(B.YXQZ,'YYYYMMDD'),
              JCLAQY.LARQ,SYSDATE
        FROM JCLAQY
       INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=JCLAQY.DJXH
       INNER JOIN HX_CKTS.CKTS_BA_KZ_JGB A ON A.DJXH=JCLAQY.DJXH AND A.CKTMSBAKZLX_DM='FLGLCD' AND A.YXBZ='Y'
         AND JCLAQY.LARQ>=A.YXQQ AND JCLAQY.LARQ<=A.YXQZ
       INNER JOIN HX_CKTS.CKTS_BA_KZ_JGB B ON B.DJXH=JCLAQY.DJXH AND B.CKTMSBAKZLX_DM='FLGLCD' AND B.YXBZ='Y'
         AND COMPUTE_BLJZDATE('D',JCLAQY.LARQ)>=B.YXQQ AND COMPUTE_BLJZDATE('D',JCLAQY.LARQ)<=B.YXQZ
       WHERE B.KZNR IN ('A','B');
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023050601...');
  COMMIT;

  -- 出口企业案源管理台账清册，结案后出口企业处罚原因代码非空的，未将出口企业调整为四类管理。
  -- 2023050602   事前（结案已经满20个工作日）
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH JCJAQY AS (
       SELECT S.TSSWJG_DM_1,S.UUID,S.DJXH,S.JARQ,S.CKQYAYGLTZCFYY_DM
         FROM HX_CKTS.CKTS_QT_CKQYAYGLTZ_GCB S
        WHERE S.JARQ>=LD_SJCL_Y AND TRIM(S.CKQYAYGLTZCFYY_DM) IS NOT NULL
          AND COMPUTE_BLJZDATE('D',S.JARQ)<TRUNC(SYSDATE)
        UNION ALL
       SELECT S.TSSWJG_DM_1,S.UUID,S.DJXH,S.JARQ,S.CKQYAYGLTZCFYY_DM
         FROM HX_CKTS.CKTS_QT_CKQYAYGLTZ_JGB S
        WHERE S.JARQ>=LD_SJCL_Y AND TRIM(S.CKQYAYGLTZCFYY_DM) IS NOT NULL
          AND COMPUTE_BLJZDATE('D',S.JARQ)<TRUNC(SYSDATE)
       )
       SELECT '2023050602',  -- '综合管理类','FLGL-D-JCJAQY',
              JCJAQY.UUID,JCJAQY.TSSWJG_DM_1,JCJAQY.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【案源管理台账结案日期】'||TO_CHAR(JCJAQY.JARQ,'YYYYMMDD')||'；【处罚原因代码】'||JCJAQY.CKQYAYGLTZCFYY_DM||
              '；【结案前分类管理类别】'||A.KZNR||'；【有效期起止】'||TO_CHAR(A.YXQQ,'YYYYMMDD')||'-'||TO_CHAR(A.YXQZ,'YYYYMMDD')||
              '；【结案后20个工作日分类管理类别】'||B.KZNR||'；【有效期起止】'||TO_CHAR(B.YXQQ,'YYYYMMDD')||'-'||TO_CHAR(B.YXQZ,'YYYYMMDD'),
              JCJAQY.JARQ,SYSDATE
        FROM JCJAQY
       INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=JCJAQY.DJXH
       INNER JOIN HX_CKTS.CKTS_BA_KZ_JGB A ON A.DJXH=JCJAQY.DJXH AND A.CKTMSBAKZLX_DM='FLGLCD' AND A.YXBZ='Y'
         AND JCJAQY.JARQ>=A.YXQQ AND JCJAQY.JARQ<=A.YXQZ
       INNER JOIN HX_CKTS.CKTS_BA_KZ_JGB B ON B.DJXH=JCJAQY.DJXH AND B.CKTMSBAKZLX_DM='FLGLCD' AND B.YXBZ='Y'
         AND COMPUTE_BLJZDATE('D',JCJAQY.JARQ)>=B.YXQQ AND COMPUTE_BLJZDATE('D',JCJAQY.JARQ)<=B.YXQZ
       WHERE B.KZNR<>'D';
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023050602...');
  COMMIT;

  -- 稽查结案后，税务行政处罚违法事实含'出口'、'退税'或'骗税'字眼的，未按规定将出口企业调整为四类管理
  -- 2023050603   事前（结案已经满20个工作日）
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH JCJAQY AS (
       SELECT BA.TSSWJG_DM_1,CF.SWXZCFJDSUUID,BA.DJXH,TRUNC(CF.WSZZRQ) AS JARQ,TO_CHAR(SUBSTR(CF.WFSS,1,500)) AS WFSS
         FROM HX_CKTS.CKTS_BA_BAXX_JGB BA
        INNER JOIN HX_JC.JC_AJXX AJ ON AJ.DJXH=BA.DJXH
        INNER JOIN HX_FZ.FZ_SWXZCFJDS CF ON CF.SSWFXWDJUUID=AJ.JCAJXXUUID AND NVL(CF.ZFBZ_1,'N')='N'
        WHERE  NVL(BA.BACHBZ,'N')='N'
          AND CF.WSZZRQ>=LD_SJCL_M
          AND REGEXP_LIKE(CF.WFSS,'出口') AND REGEXP_LIKE(CF.WFSS,'退税|骗税') --违法事实含'出口'、且含'退税'或'骗税'字样
          AND COMPUTE_BLJZDATE('D',CF.WSZZRQ)<TRUNC(SYSDATE)
       )
       SELECT '2023050603',  -- '综合管理类','FLGL-D-SWXZCF',
              JCJAQY.SWXZCFJDSUUID,JCJAQY.TSSWJG_DM_1,JCJAQY.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【税务行政处罚日期】'||TO_CHAR(JCJAQY.JARQ,'YYYYMMDD')||'【违法事实】'||JCJAQY.WFSS||
              '...【处罚前分类管理类别】'||A.KZNR||'；【有效期起止】'||TO_CHAR(A.YXQQ,'YYYYMMDD')||'-'||TO_CHAR(A.YXQZ,'YYYYMMDD')||
              '；【处罚后20个工作日分类管理类别】'||B.KZNR||'；【有效期起止】'||TO_CHAR(B.YXQQ,'YYYYMMDD')||'-'||TO_CHAR(B.YXQZ,'YYYYMMDD'),
              JCJAQY.JARQ,SYSDATE
        FROM JCJAQY
       INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=JCJAQY.DJXH
       INNER JOIN HX_CKTS.CKTS_BA_KZ_JGB A ON A.DJXH=JCJAQY.DJXH AND A.CKTMSBAKZLX_DM='FLGLCD' AND A.YXBZ='Y'
         AND JCJAQY.JARQ>=A.YXQQ AND JCJAQY.JARQ<=A.YXQZ
       INNER JOIN HX_CKTS.CKTS_BA_KZ_JGB B ON B.DJXH=JCJAQY.DJXH AND B.CKTMSBAKZLX_DM='FLGLCD' AND B.YXBZ='Y'
         AND COMPUTE_BLJZDATE('D',JCJAQY.JARQ)>=B.YXQQ AND COMPUTE_BLJZDATE('D',JCJAQY.JARQ)<=B.YXQZ
       WHERE B.KZNR<>'D';
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023050603...');
  COMMIT;

  -- 未按规定将停止出口退税权纳税人的分类管理类别调整为四类
  -- 2023050701   事前（停权有效期起满15个工作日——届满2年内），事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023050701',  -- '综合管理类','FLGL-D-TQQY',
              FLGL.UUID,BA.TSSWJG_DM_1,BA.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【停权有效期起止】'||TO_CHAR(TQQY.YXQQ,'YYYYMMDD')||'-'||TO_CHAR(TQQY.YXQZ,'YYYYMMDD')||
              '；【分类管理类别】'||FLGL.KZNR||'；【有效期起止】'||TO_CHAR(FLGL.YXQQ,'YYYYMMDD')||'-'||TO_CHAR(FLGL.YXQZ,'YYYYMMDD'),
              TQQY.LRRQ,SYSDATE
         FROM HX_CKTS.CKTS_BA_BAXX_JGB BA
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=BA.DJXH
        INNER JOIN HX_CKTS.CKTS_BA_KZ_JGB TQQY ON TQQY.DJXH=BA.DJXH AND TQQY.CKTMSBAKZLX_DM='TQQY' AND TQQY.YXBZ='Y'
          AND COMPUTE_BLJZDATE('C',TQQY.YXQQ)<TRUNC(SYSDATE) AND (SYSDATE<TQQY.YXQZ OR SYSDATE<ADD_MONTHS(TQQY.YXQZ,24))
        INNER JOIN HX_CKTS.CKTS_BA_KZ_JGB FLGL ON FLGL.DJXH=BA.DJXH AND FLGL.CKTMSBAKZLX_DM='FLGLCD' AND FLGL.YXBZ='Y'
          AND FLGL.KZNR<>'D' AND SYSDATE>=FLGL.YXQQ AND SYSDATE<=FLGL.YXQZ
        WHERE NVL(BA.BACHBZ,'N')='N';
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023050701...');
  COMMIT;

  -- 四类出口企业自评定之日起，未满12个月违规被评定为其他管理类别（因纳税信用修复原因重新评定的除外）
  -- 2023050801  事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023050801',  -- '综合管理类','FLGL-D-12M',
              KZ.UUID,BA.TSSWJG_DM_1,BA.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【四类出口企业有效期起止】'||TO_CHAR(KZ.YXQQ,'YYYYMMDD')||'-'||TO_CHAR(KZ.YXQZ,'YYYYMMDD'),
              KZ.LRRQ,SYSDATE
         FROM HX_CKTS.CKTS_BA_BAXX_JGB BA
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=BA.DJXH
        INNER JOIN HX_CKTS.CKTS_BA_KZ_JGB KZ ON KZ.DJXH=BA.DJXH AND KZ.CKTMSBAKZLX_DM='FLGLCD' AND KZ.KZNR='D' AND KZ.YXBZ='Y'
        WHERE NVL(BA.BACHBZ,'N')='N'
          AND MONTHS_BETWEEN(KZ.YXQZ+1,KZ.YXQQ)<12 AND KZ.YXQZ+1>=LD_SJCL_M
          AND NOT EXISTS (SELECT 1
                            FROM HX_CKTS.CKTS_BA_KZ_JGB NE
                           WHERE NE.DJXH=BA.DJXH AND NE.CKTMSBAKZLX_DM='FLGLCD' AND NE.KZNR='D' AND NE.YXBZ='Y'
                             AND NE.YXQQ<=KZ.YXQZ+1 AND MONTHS_BETWEEN(NE.YXQZ+1,KZ.YXQQ)>=12)
          AND NOT EXISTS (SELECT 1
                            FROM HX_CKTS.CKTS_BA_KZ_JGB PE
                           WHERE PE.DJXH=BA.DJXH AND PE.CKTMSBAKZLX_DM='FLGLCD' AND PE.KZNR='D' AND PE.YXBZ='Y'
                             AND PE.YXQZ+1>=KZ.YXQQ AND MONTHS_BETWEEN(KZ.YXQZ+1,PE.YXQQ)>=12);
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023050801...');
  COMMIT;

  -- 两次发生税收违法行为的出口企业未调整适用免税政策
  -- 2023050901  事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH JCJAQY AS (
       SELECT CF.SSWFXWDJUUID,BA.TSSWJG_DM_1,BA.DJXH,AJ.AJMC,TRUNC(CF.WSZZRQ) AS WSZZRQ,
              TO_CHAR(SUBSTR(CF.WFSS,1,500)) AS WFSS,TO_CHAR(SUBSTR(CF.CFJD,1,500)) AS CFJD,CF.YJFKJE,
              ROW_NUMBER() OVER (PARTITION BY BA.DJXH ORDER BY CF.WSZZRQ ASC) AS XH
         FROM HX_CKTS.CKTS_BA_BAXX_JGB BA
        INNER JOIN HX_JC.JC_AJXX AJ ON AJ.DJXH=BA.DJXH
        INNER JOIN HX_FZ.FZ_SWXZCFJDS CF ON CF.SSWFXWDJUUID=AJ.JCAJXXUUID AND NVL(CF.ZFBZ_1,'N')='N'
        WHERE NVL(BA.BACHBZ,'N')='N'
          AND ((REGEXP_LIKE(CF.WFSS,'虚开') AND REGEXP_LIKE(CF.WFSS,'专用发票')) OR
               (REGEXP_LIKE(CF.WFSS,'出口') AND REGEXP_LIKE(CF.WFSS,'退税|骗税')))
        )
       SELECT '2023050901',  -- '综合管理类','MSZC-SSWF-2C',
              JCJAQY.SSWFXWDJUUID,JCJAQY.TSSWJG_DM_1,JCJAQY.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【第二次违法事实】'||JCJAQY.WFSS||'...',
              JCJAQY.WSZZRQ,SYSDATE
         FROM JCJAQY
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=JCJAQY.DJXH
        WHERE JCJAQY.XH=2 AND JCJAQY.WSZZRQ>=LD_SJCL_M
          AND NOT EXISTS (SELECT 1
                            FROM HX_CKTS.CKTS_BA_KZ_JGB A
                           WHERE A.DJXH=JCJAQY.DJXH AND A.CKTMSBAKZLX_DM='TSGMS' AND A.YXBZ='Y'
                             AND COMPUTE_BLJZDATE('D',JCJAQY.WSZZRQ)>=A.YXQQ AND COMPUTE_BLJZDATE('D',JCJAQY.WSZZRQ)<=A.YXQZ);
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023050901...');
  COMMIT;

  -- 从异常供货企业采购的进货明细，连续12个月内申报退税额大于200万
  -- 2023051001  X
  -- 现有口径太复杂，待定

  -- 从异常供货企业采购的进货明细，连续12个月内申报退税额占这12个月全部申报退税额30%以上
  -- 2023051002  X
  -- 现有口径太复杂，待定

  -- 主管税务机关未按照“容缺办理”的原则办理且未按照规定开展实地核查
  -- 2023051101  X
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH SCSBQY AS (
       SELECT DJXH, MIN(LRRQ) AS SCSBRQ
         FROM (SELECT MDT.DJXH, MDT.LRRQ
                 FROM HX_CKTS.CKTS_BL_MDT_SHYDCL_JGB MDT
                WHERE MDT.LRRQ>=LD_SJCL_M AND MDT.YDNR LIKE '%首次申报免抵退税，应实地核查%'
                UNION ALL
               SELECT MTS.DJXH, MTS.LRRQ
                 FROM HX_CKTS.CKTS_BL_MTS_SHYDCL_JGB MTS
                WHERE MTS.LRRQ>=LD_SJCL_M AND MTS.YDNR LIKE '%出口企业首次申报退（免）税%')
        GROUP BY DJXH
       ),
         SDHC AS (
       SELECT DJXH, MIN(LRRQ) AS LRRQ
         FROM (SELECT SCSBQY.DJXH, SDHC.LRRQ
                 FROM SCSBQY
                INNER JOIN HX_CKTS.CKTS_SDHC_JHSDHCTZ_JGB SDHC ON SDHC.DJXH=SCSBQY.DJXH AND REGEXP_LIKE(SDHC.HCYYSM,'01|12|17|18|20|21|22')
                UNION ALL
               SELECT SCSBQY.DJXH, SDHC.LRRQ
                 FROM SCSBQY
                INNER JOIN HX_CKTS.CKTS_SDHC_JHSDHCTZ_GCB SDHC ON SDHC.DJXH=SCSBQY.DJXH AND REGEXP_LIKE(SDHC.HCYYSM,'01|12|17|18|20|21|22'))
        GROUP BY DJXH
       )
       SELECT '2023051101',  -- '申报管理类','SDHC-SCSB',
              SE.UUID,SE.TSSWJG_DM_1,SE.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,SE.SEHZZZSTSE+SE.SEHZXFSTSE+SE.SEHZMDSE,
              '【实地核查疑点发生时间】'||TO_CHAR(SCSBQY.SCSBRQ,'YYYYMMDD')||
              '；【税额核准日期】'||TO_CHAR(SE.SEHZRQ,'YYYYMMDD')||'；【（容缺）实地核查日期】'||TO_CHAR(SDHC.LRRQ,'YYYYMMDD'),
              SE.SEHZRQ,SYSDATE
         FROM SCSBQY
        INNER JOIN HX_CKTS.CKTS_TY_SEHZB SE ON SE.DJXH=SCSBQY.DJXH
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=SCSBQY.DJXH
         LEFT JOIN SDHC ON SDHC.DJXH=SCSBQY.DJXH
        WHERE SE.SEHZRQ>=SCSBQY.SCSBRQ AND SE.SEHZZZSTSE+SE.SEHZXFSTSE+SE.SEHZMDSE>0 AND NVL(SDHC.LRRQ,SYSDATE)>SE.SEHZRQ;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023051101...');
  COMMIT;

  -- 出口企业首次申报出口退（免）税，已按照“容缺办理”的原则办理但未按规定补充完成实地核查。
  -- 2023051102  单独短信提醒
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023051102',  -- '申报管理类','SDHC-SCSB-RQ',
              RQ.UUID,RQ.TSSWJG_DM_1,RQ.DJXH,RQ.NSRSBH,RQ.NSRMC,NULL,NULL,
              '【实地核查容缺确认时间】'||TO_CHAR(RQ.RQQRSJ,'YYYYMMDD')||'；【容缺到达限额时间】'||TO_CHAR(RQ.RQDDXESJ,'YYYYMMDD')||
              '；【确认后首笔退税办结时间】'||TO_CHAR(RQ.RQSEBJSJ,'YYYYMMDD')||'；【容缺后实地核查启动日期】'||TO_CHAR(RQ.SDHCQDSJ,'YYYYMMDD')||
              '；【容缺后实地核查完成日期】'||TO_CHAR(RQ.SDHCWCSJ,'YYYYMMDD'),RQ.RQQRSJ,SYSDATE
         FROM CKTS_LC_SDHC RQ
        WHERE RQ.LCZT IN ('02','12') AND RQ.RQQRSJ>=LD_SJCL_Y;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023051102...');
  COMMIT;

  -- 实地核查超20个工作日
  -- 2023051103  事前
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH SDHC AS (
       SELECT LC.UUID,LC.TSSWJG_DM_1,LC.DJXH,HCBG.HCYYSM,HCBG.HCRQ,COALESCE(MX1.TSSJ,MX2.TSSJ) TSSJ,
              ROW_NUMBER() OVER(PARTITION BY LC.LCSLID ORDER BY MX2.TSSJ DESC) SN
         FROM HX_CKTS.CKTS_TY_YWBLXX LC
        INNER JOIN HX_CKTS.CKTS_SDHC_SDHCBG_JGB HCBG
           ON HCBG.LCSLID=LC.LCSLID
         LEFT JOIN HX_CKTS.CKTS_TY_TSSBYWBL_MXB MX1
           ON MX1.LCSLID=LC.LCSLID AND MX1.LCHJ_DM = '05' AND TRIM(MX1.TS_RYDM) IS NOT NULL
         LEFT JOIN HX_CKTS.CKTS_TY_TSSBYWBL_MXB MX2
           ON MX2.LCSLID=LC.LCSLID AND MX2.LCHJ_DM = '08' AND TRIM(MX2.TS_RYDM) IS NOT NULL
        WHERE LC.LCSWSX_DM = 'LCSXA082025001'
          AND NVL(LC.ZFBZ_1,'N')='N'
          AND NVL(LC.FFRQ,SYSDATE)>=LD_SJCL_M
          AND COMPUTE_BLDATE(HCBG.HCRQ,COALESCE(MX1.TSSJ,MX2.TSSJ))>20)
       SELECT '2023051103',  -- '申报管理类','SDHC-CQ',
              SDHC.UUID,SDHC.TSSWJG_DM_1,SDHC.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【实地核查原因】'||SDHC.HCYYSM||'；【推送时间】'||TO_CHAR(SDHC.TSSJ,'YYYYMMDD')||
              '；【核查日期】'||TO_CHAR(SDHC.HCRQ,'YYYYMMDD'),
               SDHC.HCRQ,SYSDATE
         FROM SDHC
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=SDHC.DJXH
        WHERE SDHC.SN=1;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023051103...');
  COMMIT;

  -- 实地核查报告核查人员少于2人
  -- 2023051201  事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023051201',  -- '申报管理类','SDHC-HCBG-RY',
              BG.UUID,BG.TSSWJG_DM_1,BG.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【实地核查编号】'||BG.HCBH||'；【核查人员】'||BG.HCRY,BG.LRRQ,SYSDATE
         FROM (SELECT SDHC.UUID,SDHC.TSSWJG_DM_1,SDHC.DJXH,SDHC.HCBH,SDHC.HCRY,SDHC.LRRQ,
                      SUBSTR(SDHC.HCRY,1,INSTR(SDHC.HCRY,'##')-1) AS HCRY1,SUBSTR(SDHC.HCRY,INSTR(SDHC.HCRY,'##')+2) AS HCRY2
                 FROM HX_CKTS.CKTS_SDHC_SDHCBG_JGB SDHC
                WHERE SDHC.LRRQ>=LD_SJCL_M ) BG
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=BG.DJXH
        WHERE (TRIM(HCRY1) IS NULL) OR (TRIM(HCRY2) IS NULL) OR (TRIM(HCRY1)=TRIM(HCRY2));
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023051201...');
  COMMIT;

  -- 复函实地核查后未制作工作底稿
  -- 2023051202  事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH FUHWG AS (
       SELECT H1.FUHXXBUUID,H1.FUHSWJG_DM,H1.HSHBH,H1.FHBH,F1.GHFDJXH1,H1.GHQYNSRSBH_1,H1.GHFQYMC_1,
              F1.FAHDSWJGMC,F1.GHQYNSRSBH,F1.GHFQYMC,F1.FAHYY,H1.QFRQ,H1.FHLX_DM
         FROM HX_ZH.ZH_CKTS_FUHXXB H1
        INNER JOIN HX_ZH.ZH_CKTS_FHXXB F1 ON F1.FHXXBUUID=H1.FHXXBUUID
        WHERE H1.FUHSWJG_DM LIKE '133%' AND H1.FUHSWJG_DM NOT LIKE '13302%' AND NVL(H1.ZFBZ_1,'N')='N' --范围：全省不含宁波
          AND H1.FHLX_DM IN ('1','2','7','8')
          AND TRIM(H1.FHBH) IS NOT NULL -- 按“正常业务”复函
          AND H1.QFRQ>=LD_SJCL_M --起始时间限定
          AND NOT EXISTS (SELECT 1 FROM HX_ZH.ZH_CKTS_DCHSYGQKB DC WHERE DC.FUHXXBUUID=H1.FUHXXBUUID) --调查核实有关情况表
       )
       SELECT '2023051202',  -- '申报管理类','SDHC-HCBG-FUH',
              FUHWG.FUHXXBUUID,FUHWG.FUHSWJG_DM,FUHWG.GHFDJXH1,FUHWG.GHQYNSRSBH_1,FUHWG.GHFQYMC_1,NULL,NULL,
              '【核实函编号】'||FUHWG.HSHBH||'；【回函类型】'||FUHWG.FHLX_DM||'；【回函日期】'||TO_CHAR(FUHWG.QFRQ,'YYYYMMDD'),
              FUHWG.QFRQ,SYSDATE
         FROM FUHWG;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023051202...');
  COMMIT;

  -- 未按规定对先退税后核销业务开展实地核查（按年统计）
  -- 2023051301  事前
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH XTHHQY AS (
       SELECT SB.DJXH, MIN(SB.UUID) AS UUID, MIN(SB.LRRQ) AS SBRQ, SUM(SB.RMBLAJ) AS RMBLAJ, SUM(SB.MDTSE) AS MDTSE
         FROM HX_CKTS.CKTS_SB_MDT_XTHH_JGB SB
        WHERE SB.LRRQ>=LD_SJCL_Y
          AND SYSDATE>=ADD_MONTHS(LD_SJCL_Y,6) --系统日期大于等于当年7月1日后开始检测
        GROUP BY SB.DJXH
       )
       SELECT '2023051301',  -- '申报管理类','SDHC-XTHH',
              XTHHQY.UUID,BA.TSSWJG_DM_1,BA.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,XTHHQY.RMBLAJ,XTHHQY.MDTSE,
              '【企业当年首次申报先退税后核销业务日期】'||TO_CHAR(XTHHQY.SBRQ,'YYYYMMDD'),XTHHQY.SBRQ,SYSDATE
         FROM XTHHQY
        INNER JOIN HX_CKTS.CKTS_BA_BAXX_JGB BA ON BA.DJXH=XTHHQY.DJXH
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=XTHHQY.DJXH
        WHERE NOT EXISTS (SELECT 1
                            FROM HX_CKTS.CKTS_SDHC_SDHCBG_JGB SDHC
                           WHERE SDHC.DJXH=XTHHQY.DJXH
                             AND REGEXP_LIKE(SDHC.HCYYSM,'08|23')
                             AND SDHC.LRRQ>=LD_SJCL_Y);
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023051301...');
  COMMIT;

  -- 未按规定对超期申报进料加工核销进行处罚
  -- 2023051401  事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH YHXSZC AS (
         -- 应核销企业+手账册+核销日期
       SELECT HX.UUID,HX.TSSWJG_DM_1,HX.DJXH,HX.JLJGSZCH,TRUNC(HX.LRRQ) AS HXRQ,TRUNC(SC.RKRQ) AS RKRQ,TRUNC(SC.JARQ) AS JARQ
         FROM HX_CKTS.CKTS_SB_JLJG_MDTHX_JGB HX
        INNER JOIN HX_CKTS.CKTS_WBSJ_HG_DZSCHXXX SC ON HX.DJXH=SC.DJXH AND HX.JLJGSZCH=SC.BAH
        WHERE HX.LRRQ>=LD_SJCL_M
          AND HX.LRRQ>=TO_DATE(TO_CHAR(HX.LRRQ,'YYYY')||'0501','YYYYMMDD') --当年5月1日以后核销
          AND HX.JLJGSZCH LIKE 'C%' --手册
          AND SC.JARQ<TRUNC(HX.LRRQ,'YY') --上年已结案
          AND SC.RKRQ<ADD_MONTHS(TRUNC(HX.LRRQ,'YY'),3) --当年4月1号之前核销信息已入库
        UNION ALL
       SELECT HX.UUID,HX.TSSWJG_DM_1,HX.DJXH,HX.JLJGSZCH,TRUNC(HX.LRRQ) AS HXRQ,TRUNC(ZC.RKRQ) AS RKRQ,TRUNC(ZC.HXJZRQ) AS JARQ
         FROM HX_CKTS.CKTS_SB_JLJG_MDTHX_JGB HX
        INNER JOIN HX_CKTS.CKTS_WBSJ_HG_DZZCHXXX ZC ON HX.DJXH=ZC.DJXH AND HX.JLJGSZCH=ZC.BAH
          AND HX.HXQSRQ<ZC.HXJZRQ AND HX.HXJZRQ>=ZC.HXJZRQ
        WHERE HX.LRRQ>=LD_SJCL_M
          AND HX.LRRQ>=TO_DATE(TO_CHAR(HX.LRRQ,'YYYY')||'0501','YYYYMMDD') --当年5月1日以后核销
          AND SUBSTR(ZC.BAH,1,1) IN ('E','H','J') --账册
          AND ZC.HXJZRQ<TRUNC(HX.LRRQ,'YY') --上年已结案
          AND ZC.RKRQ<ADD_MONTHS(TRUNC(HX.LRRQ,'YY'),3) --当年4月1号之前核销信息已入库
/*        UNION ALL
       SELECT HX.UUID,HX.TSSWJG_DM_1,HX.DJXH,HX.JLJGSZCH,TRUNC(HX.LRRQ) AS HXRQ,TRUNC(HX.LRRQ,'YY')-1 AS RKRQ,TRUNC(HX.LRRQ,'YY')-1 AS JARQ
         FROM HX_CKTS.CKTS_SB_JLJG_MDTHX_JGB HX
        INNER JOIN HX_CKTS.CKTS_SB_MDT_TSSB_JGB SB ON HX.DJXH=SB.DJXH AND HX.JLJGSZCH=SB.JLJGSZCH
          AND SB.LRRQ>=ADD_MONTHS(TRUNC(HX.LRRQ,'YY'),-12) AND SB.LRRQ<TRUNC(HX.LRRQ,'YY') --上年申报数据
        WHERE HX.LRRQ>=LD_SJCL_M
          AND HX.LRRQ>=TO_DATE(TO_CHAR(HX.LRRQ,'YYYY')||'0501','YYYYMMDD') --当年5月1日以后核销
          AND SUBSTR(HX.JLJGSZCH,1,1) IN ('E','H','J') --账册
          AND HX.HXJZRQ>=ADD_MONTHS(TRUNC(HX.LRRQ,'YY'),-12) AND HX.HXJZRQ<TRUNC(HX.LRRQ,'YY')*/
      )
       SELECT '2023051401',  -- '申报管理类','JLJG-CQHX',
              T.UUID,BA.TSSWJG_DM_1,BA.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【手账册号】'||T.JLJGSZCH||'；【手册结案日期/账册核销截止日期/账册申报年份】'||TO_CHAR(T.JARQ,'YYYYMMDD')||
              '；【核销信息入库日期/账册申报年份】'||TO_CHAR(T.RKRQ,'YYYYMMDD')||'；【进料加工核销申报日期】'||TO_CHAR(T.HXRQ,'YYYYMMDD')
              ,T.HXRQ,SYSDATE
         FROM (SELECT YHXSZC.*,ROW_NUMBER() OVER (PARTITION BY DJXH,JLJGSZCH ORDER BY HXRQ ASC) AS XH FROM YHXSZC) T
        INNER JOIN HX_CKTS.CKTS_BA_BAXX_JGB BA ON BA.DJXH=T.DJXH
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
        WHERE XH=1
          AND NOT EXISTS (SELECT 1 -- 不存在0501之前的核销申报记录
                            FROM HX_CKTS.CKTS_TY_YWBLXX HXQ
                           WHERE HXQ.DJXH=T.DJXH AND HXQ.LCSWSX_DM='LCSXA081044001'
                             AND HXQ.QDSJ>=TRUNC(T.HXRQ,'YY') AND HXQ.QDSJ<TO_DATE(TO_CHAR(T.HXRQ,'YYYY')||'0501','YYYYMMDD'))
          AND NOT EXISTS (SELECT 1 -- 未登记进料加工
                            FROM HX_FZ.FZ_SSWFXWDJ FZ
                           WHERE FZ.DJXH=T.DJXH AND FZ.DJRQ>=T.HXRQ AND NVL(FZ.ZFBZ_1,'N')='N'
                             AND FZ.WFSS LIKE '%进料加工%');
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023051401...');
  COMMIT;

  -- 未按规定对四类出口企业申报的出口退（免）税发函调查
  -- 2023051501  事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH GHMX AS ( --四类企业供货明细
       SELECT LC.TSSWJG_DM_1,LC.DJXH,LC.SSQ,LC.SBPC,TRUNC(SB.LRRQ) AS LRRQ,
              QD.UUID,QD.XHFNSRSBH,QD.JHPZH,SB.RMBLAJ AS JSJE,SB.MDTSE AS TSE
         FROM HX_CKTS.CKTS_TY_YWBLXX LC
        INNER JOIN HX_CKTS.CKTS_SB_MDT_STZCQD_JGB QD ON QD.LCSLID=LC.LCSLID
        INNER JOIN HX_CKTS.CKTS_SB_MDT_TSSB_JGB SB
           ON SB.LCSLID=QD.LCSLID AND SB.SBXH=QD.MXSBXH AND SB.CKSL>0 AND NVL(SB.BYTSBZ,'N')='N' AND NVL(SB.BYBLBZ,'N')='N'
        WHERE LC.CKQYGLLB_DM='D' AND LC.LRRQ>=LD_SJCL_M
        UNION ALL
       SELECT LC.TSSWJG_DM_1,LC.DJXH,LC.SSQ,LC.SBPC,TRUNC(JH.LRRQ) AS LRRQ,
              JH.UUID,JH.GHFNSRSBH_1 AS XHFNSRSBH,JH.JHPZH,JH.JSJE,JH.TSE
         FROM HX_CKTS.CKTS_TY_YWBLXX LC
        INNER JOIN HX_CKTS.CKTS_SB_MTS_TSJH_JGB JH
          ON JH.LCSLID=LC.LCSLID AND JH.SL>0 AND NVL(JH.BYTSBZ,'N')='N' AND NVL(JH.BYBLBZ,'N')='N'
        INNER JOIN HX_CKTS.CKTS_SB_MTS_TSSB_JGB CK
          ON CK.DJXH=JH.DJXH AND CK.GLH=JH.GLH AND NVL(CK.BYTSBZ,'N')='N' AND NVL(CK.BYBLBZ,'N')='N'
        WHERE LC.CKQYGLLB_DM='D' AND LC.LRRQ>=LD_SJCL_M
       ),
              GHQY AS ( --按所属期、批次、申报日期、供货企业分组
       SELECT TSSWJG_DM_1,DJXH,SSQ,SBPC,XHFNSRSBH,MIN(LRRQ) AS LRRQ,
              MIN(UUID) AS UUID_MIN,COUNT(DISTINCT JHPZH) AS JHPZH_SL,SUM(JSJE) AS JSJE,SUM(TSE) AS TSE
         FROM GHMX
        WHERE NOT EXISTS (SELECT 1 -- 不存在申报以后的发函记录
                            FROM HX_ZH.ZH_CKTS_FHXXB FH
                           WHERE FH.GHFDJXH=GHMX.DJXH AND FH.GHQYNSRSBH_1=GHMX.XHFNSRSBH
                             AND NVL(FH.ZFBZ_1,'N')='N' AND FH.QFRQ>=GHMX.LRRQ)
          AND NOT EXISTS (SELECT 1 -- 不存在申报以前10个月内正常回函
                            FROM HX_ZH.ZH_CKTS_FHXXB FH
                           INNER JOIN HX_ZH.ZH_CKTS_FUHXXB FUH ON FH.FHXXBUUID=FUH.FHXXBUUID
                           WHERE FH.GHFDJXH=GHMX.DJXH AND FH.GHQYNSRSBH_1=GHMX.XHFNSRSBH
                             AND NVL(FH.ZFBZ_1,'N')='N' AND NVL(FUH.ZFBZ_1,'N')='N'
                             AND FUH.FHLX_DM='1' AND FUH.QFRQ>=ADD_MONTHS(GHMX.LRRQ,-10))
        GROUP BY TSSWJG_DM_1,DJXH,SSQ,SBPC,XHFNSRSBH
       ),
              FHMX AS (
       SELECT GHQY.UUID_MIN,FH.QFRQ,FH.FAHYY,
              ROW_NUMBER() OVER (PARTITION BY GHQY.UUID_MIN ORDER BY FH.QFRQ DESC) RN
         FROM GHQY
        INNER JOIN HX_ZH.ZH_CKTS_FHXXB FH ON FH.GHFDJXH=GHQY.DJXH AND FH.GHQYNSRSBH_1=GHQY.XHFNSRSBH AND NVL(FH.ZFBZ_1,'N')='N'
       ),
              FUHMX AS (
       SELECT GHQY.UUID_MIN,FUH.QFRQ,FUH.FHLX_DM,
              ROW_NUMBER() OVER (PARTITION BY GHQY.UUID_MIN ORDER BY FUH.QFRQ DESC) RN
         FROM GHQY
        INNER JOIN HX_ZH.ZH_CKTS_FHXXB FH ON FH.GHFDJXH=GHQY.DJXH AND FH.GHQYNSRSBH_1=GHQY.XHFNSRSBH AND NVL(FH.ZFBZ_1,'N')='N'
        INNER JOIN HX_ZH.ZH_CKTS_FUHXXB FUH ON FH.FHXXBUUID=FUH.FHXXBUUID AND NVL(FUH.ZFBZ_1,'N')='N' AND FUH.FHLX_DM NOT IN ('3','5')
       )
       SELECT '2023051501',  -- '函调管理类','HD-FAH-FLGLD',
              GHQY.UUID_MIN,GHQY.TSSWJG_DM_1,GHQY.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,GHQY.JSJE,GHQY.TSE,
              '【所属期】'||GHQY.SSQ||'；【批次】'||GHQY.SBPC||'；【申报日期】'||TO_CHAR(GHQY.LRRQ,'YYYYMMDD')||
              '；【供货方税号】'||GHQY.XHFNSRSBH||'；【发票份数】'||GHQY.JHPZH_SL||'；【金额】'||GHQY.JSJE||'；【退税额】'||GHQY.TSE||
              '；【最近一次发函日期】'||TO_CHAR(FHMX.QFRQ,'YYYYMMDD')||'；【发函原因】'||FHMX.FAHYY||
              '；【最近一次回函日期】'||TO_CHAR(FUHMX.QFRQ,'YYYYMMDD')||'；【回函类型】'||FUHMX.FHLX_DM,
              GHQY.LRRQ,SYSDATE
         FROM GHQY
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=GHQY.DJXH
        INNER JOIN HX_CKTS.CKTS_BA_BAXX_JGB BA ON BA.DJXH=GHQY.DJXH AND NVL(BA.BACHBZ,'N')='N'
         LEFT JOIN FHMX ON FHMX.UUID_MIN=GHQY.UUID_MIN AND FHMX.RN=1
         LEFT JOIN FUHMX ON FUHMX.UUID_MIN=GHQY.UUID_MIN AND FUHMX.RN=1;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023051501...');
  COMMIT;

  -- 未按规定对不予退税函件追溯发函
  -- 2023051601   事前（回函满15个工作日）
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH BYTSFUH AS (
       SELECT FH.FHXXBUUID,FH.WSBH,FH.FAHDSWJG_DM,FH.GHFDJXH,FH.GHQYNSRSBH,FH.GHFQYMC,FH.GHQYNSRSBH_1,MIN(FP.KJRQ) AS KJRQ,MAX(FUH.QFRQ) AS QFRQ
         FROM HX_ZH.ZH_CKTS_FUHXXB FUH
        INNER JOIN HX_ZH.ZH_CKTS_FHXXB FH ON FH.FHXXBUUID=FUH.FHXXBUUID
        INNER JOIN HX_ZH.ZH_CKTS_HDFPQD FP ON FP.FHXXBUUID=FH.FHXXBUUID
        WHERE FH.FAHDSWJG_DM LIKE '133%' AND FH.FAHDSWJG_DM NOT LIKE '13302%'
          AND FH.DZBZDSZL_DM='BDA1320284' -- 发函文书种类
          AND DBMS_LOB.INSTR(FH.YDXSJTNR,'追溯')=0 -- 剔除追溯发函，总局督察条件
          AND FUH.QFRQ>=LD_SJCL_M AND COMPUTE_BLJZDATE('C',FUH.QFRQ)<TRUNC(SYSDATE)
          AND NVL(FUH.ZFBZ_1,'N')='N'
          AND FUH.FHLX_DM='2' -- 不予退税回函
          AND NOT EXISTS (SELECT 1 --不存在不予改准予的回函
                            FROM HX_ZH.ZH_CKTS_FUHXXB H2
                           WHERE H2.FHXXBUUID=FUH.FHXXBUUID AND NVL(H2.ZFBZ_1,'N')='N' AND H2.FHLX_DM='1' AND TRIM(H2.FHBH) IS NOT NULL
                             AND H2.QFRQ>FUH.QFRQ)
        GROUP BY FH.FHXXBUUID,FH.WSBH,FH.FAHDSWJG_DM,FH.GHFDJXH,FH.GHQYNSRSBH,FH.GHFQYMC,FH.GHQYNSRSBH_1
       ),
         LSJH AS (
       SELECT BYTSFUH.GHFDJXH,BYTSFUH.GHQYNSRSBH_1,JGB.JHPZH,JGB.JSJE,JGB.TSE
         FROM BYTSFUH
        INNER JOIN HX_CKTS.CKTS_SB_MTS_TSJH_JGB JGB
           ON JGB.DJXH=BYTSFUH.GHFDJXH AND JGB.GHFNSRSBH_1=BYTSFUH.GHQYNSRSBH_1
          AND JGB.KPRQ>=ADD_MONTHS(BYTSFUH.KJRQ,-12) AND JGB.KPRQ<BYTSFUH.KJRQ
          AND NVL(JGB.BYBLBZ,'N')='N' AND NVL(JGB.BYTSBZ,'N')='N'
        UNION ALL
       SELECT BYTSFUH.GHFDJXH,BYTSFUH.GHQYNSRSBH_1,LB.JHPZH,LB.JSJE,LB.TSE
         FROM BYTSFUH
        INNER JOIN HX_CKTS.CKTS_SB_MTS_TSJH_LB LB
           ON LB.DJXH=BYTSFUH.GHFDJXH AND LB.GHFNSRSBH_1=BYTSFUH.GHQYNSRSBH_1
          AND LB.KPRQ>=ADD_MONTHS(BYTSFUH.KJRQ,-12) AND LB.KPRQ<BYTSFUH.KJRQ
          AND NVL(LB.BYBLBZ,'N')='N' AND NVL(LB.BYTSBZ,'N')='N'
	   )
       SELECT '2023051601',  -- '函调管理类','HD-FAH-BYTS',
              BYTSFUH.FHXXBUUID,BYTSFUH.FAHDSWJG_DM,BYTSFUH.GHFDJXH,BYTSFUH.GHQYNSRSBH,BYTSFUH.GHFQYMC,SUM(LSJH.JSJE),SUM(LSJH.TSE),
              '【文书编号】'||BYTSFUH.WSBH||'；【供货方税号】'||BYTSFUH.GHQYNSRSBH_1||'；【复函所列增值税专用发票的最早开票日期】'||TO_CHAR(BYTSFUH.KJRQ,'YYYYMMDD'),
              BYTSFUH.QFRQ,SYSDATE
         FROM BYTSFUH
        INNER JOIN LSJH
           ON LSJH.GHFDJXH=BYTSFUH.GHFDJXH AND LSJH.GHQYNSRSBH_1=BYTSFUH.GHQYNSRSBH_1
        WHERE NOT EXISTS (SELECT 1
                            FROM HX_ZH.ZH_CKTS_HDFPQD QD
                           WHERE QD.GHFNSRSBH_1=LSJH.GHQYNSRSBH_1 AND QD.ZZSZYFPDMHM=LSJH.JHPZH AND NVL(QD.ZFBZ_1,'N')='N')
        GROUP BY BYTSFUH.FHXXBUUID,BYTSFUH.WSBH,BYTSFUH.FAHDSWJG_DM,BYTSFUH.GHFDJXH,BYTSFUH.GHQYNSRSBH,BYTSFUH.GHFQYMC,BYTSFUH.GHQYNSRSBH_1,TO_CHAR(BYTSFUH.KJRQ,'YYYYMMDD'),BYTSFUH.QFRQ
       HAVING SUM(LSJH.JSJE)>0;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023051601...');
  COMMIT;

  -- 未按规定对非本地区管辖的函件重新发函
  -- 2023051701   事前（回函满15个工作日）
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH FBDFUH AS (
       SELECT FH.FHXXBUUID,FH.WSBH,FH.FAHDSWJG_DM,FH.GHFDJXH,FH.GHQYNSRSBH,FH.GHFQYMC,FH.GHQYNSRSBH_1,FH.QFRQ AS FHRQ,FUH.QFRQ AS FUHRQ,
              ROW_NUMBER() OVER (PARTITION BY FH.FHXXBUUID ORDER BY FUH.QFRQ DESC) RN
         FROM HX_ZH.ZH_CKTS_FUHXXB FUH
        INNER JOIN HX_ZH.ZH_CKTS_FHXXB FH ON FH.FHXXBUUID=FUH.FHXXBUUID
        WHERE FH.FAHDSWJG_DM LIKE '133%' AND FH.FAHDSWJG_DM NOT LIKE '13302%'
          AND FUH.QFRQ>=LD_SJCL_M AND COMPUTE_BLJZDATE('C',FUH.QFRQ)<TRUNC(SYSDATE)
          AND NVL(FUH.ZFBZ_1,'N')='N'
          AND FUH.FHLX_DM='5' --复函类型为“非本地区管辖”
       )
       SELECT '2023051701',  -- '函调管理类','HD-FAH-FBDGX',
              FBDFUH.FHXXBUUID,FBDFUH.FAHDSWJG_DM,FBDFUH.GHFDJXH,FBDFUH.GHQYNSRSBH,FBDFUH.GHFQYMC,NULL,NULL,
              '【文书编号】'||FBDFUH.WSBH||'；【供货方税号】'||FBDFUH.GHQYNSRSBH_1||
              '；【发函日期】'||TO_CHAR(FBDFUH.FHRQ,'YYYYMMDD')||'；【回函日期】'||TO_CHAR(FBDFUH.FUHRQ,'YYYYMMDD'),
              FBDFUH.FUHRQ,SYSDATE
         FROM FBDFUH
        WHERE RN=1
          AND NOT EXISTS (SELECT 1 -- 非本地管辖回函签发以后1个月内未重新发函
                            FROM HX_ZH.ZH_CKTS_FHXXB A
                           WHERE A.GHFDJXH=FBDFUH.GHFDJXH AND A.GHQYNSRSBH_1=FBDFUH.GHQYNSRSBH_1 AND A.WSBH<>FBDFUH.WSBH
                             AND A.QFRQ>FBDFUH.FHRQ AND A.QFRQ<ADD_MONTHS(FBDFUH.FUHRQ,1) AND NVL(A.ZFBZ_1,'N')='N');
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023051701...');
  COMMIT;

  -- 未在规定期限内复函
  -- 2023051801  单独短信提醒
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH FUHQX AS (
       SELECT F1.FHXXBUUID,F1.WSBH AS FHBH,F1.FAHDSWJGMC,F1.GHFZGSWJG_DM,F1.GHFDJXH1,F1.GHQYNSRSBH_1,F1.GHFQYMC_1,TRUNC(F1.QFRQ) AS QFRQ,
              TRUNC(F1.FUHJZRQ) AS FUHJZRQ,0 AS RN
         FROM HX_ZH.ZH_CKTS_FHXXB F1 --发函表的截止时间
        WHERE F1.GHFZGSWJG_DM LIKE '133%' AND F1.GHFZGSWJG_DM NOT LIKE '13302%' AND NVL(F1.ZFBZ_1,'N')='N'
          AND F1.QFRQ IS NOT NULL
          AND F1.FUHJZRQ>=LD_SJCL_M AND F1.FUHJZRQ<TRUNC(SYSDATE)
        UNION ALL
       SELECT F1.FHXXBUUID,H1.FHBH,F1.FAHDSWJGMC,F1.GHFZGSWJG_DM,F1.GHFDJXH1,F1.GHQYNSRSBH_1,F1.GHFQYMC_1,TRUNC(H1.QFRQ) AS QFRQ,
              TRUNC(H1.YQRQ_1) AS FUHJZRQ,ROW_NUMBER() OVER(PARTITION BY F1.FHXXBUUID ORDER BY H1.QFRQ) AS RN
         FROM HX_ZH.ZH_CKTS_FHXXB F1 --回函表的延期时间
        INNER JOIN HX_ZH.ZH_CKTS_FUHXXB H1 ON H1.FHXXBUUID=F1.FHXXBUUID AND NVL(H1.ZFBZ_1,'N')='N' AND NVL(H1.FHLX_DM,'3')='3' AND TRIM(H1.FHBH) IS NOT NULL
        WHERE F1.GHFZGSWJG_DM LIKE '133%' AND F1.GHFZGSWJG_DM NOT LIKE '13302%' AND NVL(F1.ZFBZ_1,'N')='N'
          AND F1.QFRQ IS NOT NULL
          AND H1.YQRQ_1>=LD_SJCL_M AND H1.YQRQ_1<TRUNC(SYSDATE)
       )
       SELECT '2023051801',  -- '函调管理类','HD-FUH-CQFUH',
              FUHQX.FHXXBUUID,FUHQX.GHFZGSWJG_DM,FUHQX.GHFDJXH1,FUHQX.GHQYNSRSBH_1,FUHQX.GHFQYMC_1,NULL,NULL,
              '【发函编号】'||FUHQX.FHBH||'；【发函地税务机关】'||FUHQX.FAHDSWJGMC||'；【发函日期/回延期函日期】'||TO_CHAR(FUHQX.QFRQ,'YYYYMMDD')
              ||'；【回函截止日期】'||TO_CHAR(FUHQX.FUHJZRQ,'YYYYMMDD')||'；【延期次数】'||FUHQX.RN,
              FUHQX.FUHJZRQ,SYSDATE
         FROM FUHQX
        WHERE NOT EXISTS (SELECT 1 --签发日期后没有新的回函
                            FROM HX_ZH.ZH_CKTS_FUHXXB A
                           WHERE A.FHXXBUUID=FUHQX.FHXXBUUID AND TRIM(A.FHBH) IS NOT NULL AND NVL(A.ZFBZ_1,'N')='N'
                             AND A.QFRQ>=FUHQX.QFRQ AND TRUNC(A.QFRQ)<=FUHQX.FUHJZRQ AND A.FHBH<>FUHQX.FHBH);
          /*AND NOT EXISTS (SELECT 1 --剔除正常回函后又回延期函的情形
                            FROM HX_ZH.ZH_CKTS_FUHXXB B
                           WHERE B.FHXXBUUID=FUHQX.FHXXBUUID AND TRIM(B.FHBH) IS NOT NULL AND NVL(B.ZFBZ_1,'N')='N'
                             AND TRUNC(B.QFRQ)<=FUHQX.FUHJZRQ AND NVL(B.FHLX_DM,'3')<>'3');*/
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023051801...');
  COMMIT;

  -- 违规对正在接受纳税评估、稽查的供货企业按“正常业务”复函
  -- 2023051901  事中
  -- 注：此处企业为供货企业，被稽查的原因不需要限定条件
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH FUHWG AS (
       SELECT H1.FUHXXBUUID,H1.FUHSWJG_DM,H1.HSHBH,H1.FHBH,F1.GHFDJXH1,H1.GHQYNSRSBH_1,H1.GHFQYMC_1,
              F1.FAHDSWJGMC,F1.GHQYNSRSBH,F1.GHFQYMC,F1.FAHYY,H1.QFRQ,
              JC.AJMC,JC.LARQ,JC.JARQ,CF.WSZZRQ AS SWXZCFJDSZZRQ,CL.WSZZRQ AS SWCLJDSZZRQ,
              ROW_NUMBER() OVER (PARTITION BY H1.FUHXXBUUID ORDER BY JC.LARQ) AS RN
         FROM HX_ZH.ZH_CKTS_FUHXXB H1
        INNER JOIN HX_ZH.ZH_CKTS_FHXXB F1 ON F1.FHXXBUUID=H1.FHXXBUUID
        INNER JOIN HX_JC.JC_AJXX JC ON JC.DJXH=F1.GHFDJXH1 AND JC.LARQ<H1.QFRQ AND NVL(JC.ZFBZ_1,'N')='N'
          AND JC.AJJCZT_DM<>'600' -- 剔除案源撤销的，后续不会有结案日期
         LEFT JOIN HX_FZ.FZ_SWXZCFJDS CF ON CF.SSWFXWDJUUID=JC.JCAJXXUUID AND NVL(CF.ZFBZ_1,'N')='N' --取税务行政处罚决定书制作日期
         LEFT JOIN HX_JC.JC_SWCLJDS CL ON CL.JCAJXXUUID=JC.JCAJXXUUID AND NVL(CL.ZFBZ_1,'N')='N' --取税务处理决定书制作日期
         -- 暂缺纳税评估的条件
        WHERE H1.FUHSWJG_DM LIKE '133%' AND H1.FUHSWJG_DM NOT LIKE '13302%' AND NVL(H1.ZFBZ_1,'N')='N' --范围：全省不含宁波
          AND H1.FHLX_DM='1' AND TRIM(H1.FHBH) IS NOT NULL -- 按“正常业务”复函
          AND H1.QFRQ>=LD_SJCL_M --时间范围
          AND LEAST(NVL(JC.JARQ,SYSDATE),NVL(CF.WSZZRQ,SYSDATE),NVL(CL.WSZZRQ,SYSDATE)) > H1.QFRQ
       )
       SELECT '2023051901',  -- '函调管理类','HD-FUH-JCLAQY',
              FUHWG.FUHXXBUUID,FUHWG.FUHSWJG_DM,FUHWG.GHFDJXH1,FUHWG.GHQYNSRSBH_1,FUHWG.GHFQYMC_1,NULL,NULL,
              '【核实函编号】'||FUHWG.HSHBH||'；【发函地税务机关】'||FUHWG.FAHDSWJGMC||'；【购货企业税号】'||FUHWG.GHQYNSRSBH||'；【回函日期】'||TO_CHAR(FUHWG.QFRQ,'YYYYMMDD')
              ||'；【案件名称】'||AJMC||'；【立案日期】'||TO_CHAR(FUHWG.LARQ,'YYYYMMDD')||'；【结案日期】'||TO_CHAR(FUHWG.JARQ,'YYYYMMDD')
              ||'；【税务行政处罚决定书制作日期】'||TO_CHAR(FUHWG.SWXZCFJDSZZRQ,'YYYYMMDD')||'；【税务处理决定书制作日期】'||TO_CHAR(FUHWG.SWCLJDSZZRQ,'YYYYMMDD'),
              FUHWG.QFRQ,SYSDATE
         FROM FUHWG
        WHERE RN=1;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023051901...');
  COMMIT;

  -- 未核查供货企业发票为虚开或伪造，违规按“正常业务”类型复函
  -- 2023052001  X
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH FUHWG AS (
       SELECT H1.FUHXXBUUID,H1.FUHSWJG_DM,H1.HSHBH,H1.FHBH,F1.GHFDJXH1,H1.GHQYNSRSBH_1,H1.GHFQYMC_1,
              F1.FAHDSWJGMC,F1.GHQYNSRSBH,F1.GHFQYMC,F1.FAHYY,H1.QFRQ,QD.ZZSZYFPDMHM,
              ROW_NUMBER() OVER (PARTITION BY H1.FUHXXBUUID ORDER BY QD.ZZSZYFPDMHM) AS RN
         FROM HX_ZH.ZH_CKTS_FUHXXB H1
        INNER JOIN HX_ZH.ZH_CKTS_FHXXB F1 ON F1.FHXXBUUID=H1.FHXXBUUID
        INNER JOIN HX_ZH.ZH_CKTS_HDFPQD QD ON QD.FHXXBUUID=H1.FHXXBUUID
        WHERE H1.FUHSWJG_DM LIKE '133%' AND H1.FUHSWJG_DM NOT LIKE '13302%' AND NVL(H1.ZFBZ_1,'N')='N' --范围：全省不含宁波
          AND H1.FHLX_DM='1' AND TRIM(H1.FHBH) IS NOT NULL -- 按“正常业务”复函
          AND H1.QFRQ>=LD_SJCL_M --范围：本年签发
          AND EXISTS (SELECT 1 FROM HX_CKTS.CKTS_WBSJ_ZJ_XKFP XK WHERE XK.FP_DM||XK.FPHM=QD.ZZSZYFPDMHM)
          -- 缺少稽查部门认定虚开的发票信息对应表
       )
       SELECT '2023052001',  -- '函调管理类','HD-FUH-JCLAFP',
              FUHWG.FUHXXBUUID,FUHWG.FUHSWJG_DM,FUHWG.GHFDJXH1,FUHWG.GHQYNSRSBH_1,FUHWG.GHFQYMC_1,NULL,NULL,
              '【核实函编号】'||FUHWG.HSHBH||'；【发函地税务机关】'||FUHWG.FAHDSWJGMC||'；【购货企业税号】'||FUHWG.GHQYNSRSBH||'；【回函日期】'||TO_CHAR(FUHWG.QFRQ,'YYYYMMDD')
              ||'；【稽查部门认定虚开的发票之一】'||ZZSZYFPDMHM,
              FUHWG.QFRQ,SYSDATE
         FROM FUHWG
        WHERE RN=1;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023052001...');
  COMMIT;

  -- 无合理理由再次复函改变原复函类型
  -- 2023052101  事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH FUHWG AS (
       SELECT H1.FUHXXBUUID,H1.FUHSWJG_DM,H1.HSHBH,F1.GHFDJXH1,H1.GHQYNSRSBH_1,H1.GHFQYMC_1,F1.FAHDSWJGMC,F1.GHQYNSRSBH,F1.GHFQYMC,
              H2.FHBH AS FHBH_Q,H2.FHLX_DM AS FHLX_Q,H2.QFRQ AS QFRQ_Q,H1.FHBH AS FHBH_H,H1.FHLX_DM AS FHLX_H,H1.QFRQ AS QFRQ_H
         FROM HX_ZH.ZH_CKTS_FUHXXB H1
        INNER JOIN HX_ZH.ZH_CKTS_FUHXXB H2 ON H2.HSHBH=H1.HSHBH AND H2.FHBH<>H1.FHBH
          AND H2.QFRQ<H1.QFRQ AND NVL(H2.ZFBZ_1,'N')='N' AND TRIM(H2.FHBH) IS NOT NULL
        INNER JOIN HX_ZH.ZH_CKTS_FHXXB F1 ON F1.FHXXBUUID=H1.FHXXBUUID
        WHERE H1.FUHSWJG_DM LIKE '133%' AND H1.FUHSWJG_DM NOT LIKE '13302%' AND NVL(H1.ZFBZ_1,'N')='N' --范围：全省不含宁波
          AND (  (H1.FHLX_DM IN ('2','8') AND H2.FHLX_DM='1') --从“正常业务”改为“异常业务”或“存在不予退免税发票”
              OR (H1.FHLX_DM IN ('1','3') AND H2.FHLX_DM IN ('2','8'))) --从“异常业务”或“存在不予退免税发票”改为“正常业务”或“经核查尚未处理完毕
          AND TRIM(H1.FHBH) IS NOT NULL
          AND H1.QFRQ>=LD_SJCL_M --范围：本年签发
       )
       SELECT '2023052101',  -- '函调管理类','HD-FUH-BGFUH',
              FUHWG.FUHXXBUUID,FUHWG.FUHSWJG_DM,FUHWG.GHFDJXH1,FUHWG.GHQYNSRSBH_1,FUHWG.GHFQYMC_1,NULL,NULL,
              '【核实函编号】'||FUHWG.HSHBH||'；【发函地税务机关】'||FUHWG.FAHDSWJGMC||'；【购货企业税号】'||FUHWG.GHQYNSRSBH||
              '；【回函日期1】'||TO_CHAR(FUHWG.QFRQ_Q,'YYYYMMDD')||'；【回函编号1】'||FUHWG.FHBH_Q||'；【回函类型1】'||FUHWG.FHLX_Q||
              '；【回函日期2】'||TO_CHAR(FUHWG.QFRQ_H,'YYYYMMDD')||'；【回函编号2】'||FUHWG.FHBH_H||'；【回函类型2】'||FUHWG.FHLX_H,
              FUHWG.QFRQ_H,SYSDATE
         FROM FUHWG;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023052101...');
  COMMIT;

  -- 违规对未收到复函的业务提前办理退免税
  -- 2023052201  事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH FUHWG AS (
       SELECT F1.FHXXBUUID,F1.WSBH,F1.GHQYNSRSBH,F1.GHFQYMC,
              JH.TSSWJG_DM_1,JH.DJXH,JH.LCSLID,JH.SSQ,JH.SBPC,JH.SBXH,JH.JHPZH,JH.JSJE,JH.TSE,
              JH.GHFNSRSBH_1,F1.GHFQYMC_1,
              TO_CHAR(JH.LRRQ,'YYYYMMDD') AS SBRQ,TO_CHAR(F1.QFRQ,'YYYYMMDD') AS QFRQ_F,TO_CHAR(HZ.SEHZRQ,'YYYYMMDD') AS HZRQ
         FROM HX_ZH.ZH_CKTS_FHXXB F1
         LEFT JOIN HX_ZH.ZH_CKTS_FUHXXB H1
           ON H1.FHXXBUUID=F1.FHXXBUUID AND NVL(H1.ZFBZ_1,'N')='N' AND TRIM(H1.FHBH) IS NOT NULL
          AND NVL(H1.FHLX_DM,'3')<>'3' -- 非延期回函
        INNER JOIN HX_ZH.ZH_CKTS_HDFPQD QD
           ON QD.FHXXBUUID=F1.FHXXBUUID AND QD.SFYTS='N' AND NVL(QD.ZFBZ_1,'N')='N' -- 发函时发票未退税
        INNER JOIN HX_CKTS.CKTS_SB_MTS_TSJH_JGB JH
           ON JH.DJXH=F1.GHFDJXH AND JH.JHPZH=QD.ZZSZYFPDMHM
          AND NVL(JH.BYTSBZ,'N')='N' AND NVL(JH.BYBLBZ,'N')='N' --结果表非不予办理、非不予退税
          AND NOT EXISTS ( --非暂不办理
              SELECT 1
                FROM HX_CKTS.CKTS_BL_MTS_SHYDDCLB DCL
               WHERE DCL.DJXH=JH.DJXH AND DCL.GLH=JH.GLH)
        INNER JOIN HX_CKTS.CKTS_TY_SEHZB HZ
           ON HZ.LCSLID=JH.LCSLID AND HZ.SEHZRQ>=LD_SJCL_M  --税额核准日期
        INNER JOIN HX_CKTS.CKTS_TY_YWBLXX YW
           ON YW.LCSLID=JH.LCSLID AND YW.CKQYGLLB_DM<>'A'
        WHERE F1.FAHDSWJG_DM LIKE '133%' AND F1.FAHDSWJG_DM NOT LIKE '13302%' -- 限定发函机关为省内非宁波地区
          AND F1.QFRQ IS NOT NULL -- 发函已签发
          AND NVL(F1.ZFBZ_1,'N') = 'N' -- 未作废
          AND H1.FHXXBUUID IS NULL -- 还没有结论明确（非延期函）的回函
       )
       SELECT '2023052201',
              FHXXBUUID,TSSWJG_DM_1,DJXH,GHQYNSRSBH,GHFQYMC,SUM(JSJE),SUM(TSE),
              '【所属期-批次】'||SSQ||SBPC||'；【供货企业税号】'||GHFNSRSBH_1||'；【核实函编号】'||WSBH||
              '；【申报日期】'||SBRQ||'；【发函日期】'||QFRQ_F||'（未回函）；【税额核准日期】'||HZRQ,
              TO_DATE(HZRQ,'YYYYMMDD'),SYSDATE
         FROM FUHWG
        WHERE SBRQ<=QFRQ_F AND QFRQ_F<=HZRQ --时间顺序：申报lrrq，发函qfrq_f，核准日期sehzrq
        GROUP BY FHXXBUUID,TSSWJG_DM_1,DJXH,GHQYNSRSBH,GHFQYMC,SSQ,SBPC,GHFNSRSBH_1,WSBH,SBRQ,QFRQ_F,HZRQ;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023052201...');
  COMMIT;

  -- 未按规定处理“存在不予退（免）税的情形”、“暂缓办理退（免）税”的复函
  -- 2023052301   事前（回函满15个工作日）
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH FUHWG AS (
       SELECT F1.FHXXBUUID,F1.FAHDSWJG_DM,F1.WSBH,F1.GHFDJXH,F1.GHQYNSRSBH,F1.GHFQYMC,F1.GHFZGSWJGMC,F1.GHQYNSRSBH_1,F1.GHFQYMC_1,
              JH.SSQ,JH.SBPC,JH.SBXH,JH.JHPZH,JH.JSJE,JH.TSE,H1.QFRQ,H1.FHLX_DM,
              ROW_NUMBER() OVER (PARTITION BY H1.FHXXBUUID,JH.SBXH ORDER BY QD.HDFPQDUUID) AS RN
         FROM HX_ZH.ZH_CKTS_FHXXB F1
        INNER JOIN HX_ZH.ZH_CKTS_FUHXXB H1 ON H1.FHXXBUUID=F1.FHXXBUUID AND NVL(H1.ZFBZ_1,'N')='N' AND TRIM(H1.FHBH) IS NOT NULL
        INNER JOIN HX_ZH.ZH_CKTS_HDFPQD QD ON QD.FHXXBUUID=F1.FHXXBUUID --对应发函清单
        INNER JOIN HX_CKTS.CKTS_SB_MTS_TSJH_JGB JH ON JH.DJXH=F1.GHFDJXH AND JH.JHPZH=QD.ZZSZYFPDMHM
          AND NVL(JH.BYTSBZ,'N')='N' AND NVL(JH.BYBLBZ,'N')='N' AND JH.TSE>0 --对应进货退税
        INNER JOIN HX_CKTS.CKTS_SB_MTS_TSSB_JGB CK ON CK.DJXH=JH.DJXH AND CK.GLH=JH.GLH
          AND NVL(CK.BYTSBZ,'N')='N' AND NVL(CK.BYBLBZ,'N')='N' -- 对应出口退税
        WHERE F1.FAHDSWJG_DM LIKE '133%' AND F1.FAHDSWJG_DM NOT LIKE '13302%' AND NVL(F1.ZFBZ_1,'N')='N' --范围：全省不含宁波
          AND H1.QFRQ>=LD_SJCL_M --范围：本年签发
          AND COMPUTE_BLJZDATE('C',H1.QFRQ)<TRUNC(SYSDATE)
          AND H1.FHLX_DM='2' --复函类型：存在不予退（免）税发票
          AND NOT EXISTS (SELECT 1 --不存在不予改准予的回函
                            FROM HX_ZH.ZH_CKTS_FUHXXB H2
                           WHERE H2.FHXXBUUID=F1.FHXXBUUID AND NVL(H2.ZFBZ_1,'N')='N' AND H2.FHLX_DM='1' AND TRIM(H2.FHBH) IS NOT NULL
                             AND H2.QFRQ>H1.QFRQ)
          AND NOT EXISTS (SELECT 1 --不存在不予退税或红字冲减
                            FROM HX_CKTS.CKTS_SB_MTS_TSJH_JGB JH2
                           WHERE JH2.DJXH=F1.GHFDJXH AND JH2.JHPZH=QD.ZZSZYFPDMHM AND (JH2.BYTSBZ='Y' OR JH2.TSE<0)
                           UNION ALL
                          SELECT 1 --不存在回函2个月内应追回
                            FROM HX_CKTS.CKTS_TK_YZHYTSKMXB_JGB YZH
                           WHERE YZH.DJXH=F1.GHFDJXH AND YZH.LRRQ>=H1.QFRQ AND YZH.LRRQ<ADD_MONTHS(H1.QFRQ,2))
       )
       SELECT '2023052301',  -- '函调管理类','HD-CL-BYTS',
              FUHWG.FHXXBUUID,FUHWG.FAHDSWJG_DM,FUHWG.GHFDJXH,FUHWG.GHQYNSRSBH,FUHWG.GHFQYMC,SUM(FUHWG.JSJE),SUM(FUHWG.TSE),
              '【核实函编号】'||FUHWG.WSBH||'；【供货企业税号】'||FUHWG.GHQYNSRSBH_1||
              '；【回函日期】'||TO_CHAR(FUHWG.QFRQ,'YYYYMMDD')||'；【回函类型】'||FUHWG.FHLX_DM,
              FUHWG.QFRQ,SYSDATE
         FROM FUHWG
        WHERE RN=1
        GROUP BY FUHWG.FHXXBUUID,FUHWG.FAHDSWJG_DM,FUHWG.GHFDJXH,FUHWG.GHQYNSRSBH,FUHWG.GHFQYMC,
              FUHWG.GHQYNSRSBH_1,FUHWG.WSBH,FUHWG.QFRQ,FUHWG.FHLX_DM;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023052301...');
  COMMIT;

  -- 未按规定处理“存在不予退（免）税的情形”、“暂缓办理退（免）税”的复函
  -- 2023052302   事前（回函满15个工作日）
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH FUHWG AS (
       SELECT F1.FHXXBUUID,F1.FAHDSWJG_DM,F1.WSBH,F1.GHFDJXH,F1.GHQYNSRSBH,F1.GHFQYMC,F1.GHFZGSWJGMC,F1.GHQYNSRSBH_1,F1.GHFQYMC_1,
              H1.QFRQ,H1.FHLX_DM,QD.ZZSZYFPDMHM,QD.JE,QD.SE
         FROM HX_ZH.ZH_CKTS_FHXXB F1
        INNER JOIN HX_ZH.ZH_CKTS_FUHXXB H1 ON H1.FHXXBUUID=F1.FHXXBUUID AND NVL(H1.ZFBZ_1,'N')='N' AND TRIM(H1.FHBH) IS NOT NULL
        INNER JOIN HX_ZH.ZH_CKTS_HDFPQD QD ON QD.FHXXBUUID=F1.FHXXBUUID --对应发函清单
        WHERE F1.FAHDSWJG_DM LIKE '133%' AND F1.FAHDSWJG_DM NOT LIKE '13302%' AND NVL(F1.ZFBZ_1,'N')='N' --范围：全省不含宁波
          AND H1.QFRQ>=LD_SJCL_M --范围：本年签发
          AND COMPUTE_BLJZDATE('C',H1.QFRQ)<TRUNC(SYSDATE)
          AND H1.FHLX_DM='7' --复函类型：暂缓办理退（免）税
          AND NOT EXISTS (SELECT 1 --不存在暂扣税款的记录
                            FROM HX_CKTS.CKTS_TS_ZKCKTSYWCLB_JGB JG
                           WHERE JG.DJXH=F1.GHFDJXH AND JG.LRRQ>=H1.QFRQ AND JG.LRRQ<ADD_MONTHS(H1.QFRQ,2)
                           UNION ALL
                          SELECT 1
                            FROM HX_CKTS.CKTS_TS_ZKCKTSYWCLB_GCB GC
                           WHERE GC.DJXH=F1.GHFDJXH AND GC.LRRQ>=H1.QFRQ AND GC.LRRQ<ADD_MONTHS(H1.QFRQ,2))
       )
       SELECT '2023052302',  -- '函调管理类','HD-CL-ZHTS',
              FUHWG.FHXXBUUID,FUHWG.FAHDSWJG_DM,FUHWG.GHFDJXH,FUHWG.GHQYNSRSBH,FUHWG.GHFQYMC,SUM(FUHWG.JE),SUM(FUHWG.SE),
              '【核实函编号】'||FUHWG.WSBH||'；【供货企业税号】'||FUHWG.GHQYNSRSBH_1||
              '；【回函日期】'||TO_CHAR(FUHWG.QFRQ,'YYYYMMDD')||'；【回函类型】'||FUHWG.FHLX_DM,
              FUHWG.QFRQ,SYSDATE
         FROM FUHWG
        GROUP BY FUHWG.FHXXBUUID,FUHWG.FAHDSWJG_DM,FUHWG.GHFDJXH,FUHWG.GHQYNSRSBH,FUHWG.GHFQYMC,
              FUHWG.GHQYNSRSBH_1,FUHWG.WSBH,FUHWG.QFRQ,FUHWG.FHLX_DM;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023052302...');
  COMMIT;

  -- 未按规定对停权出口企业录入停止退税标志
  -- 2023052401  X
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023052401',  -- '风险管理类','JC-JA-TQQY',
              CF.SWXZCFJDSUUID,BA.TSSWJG_DM_1,BA.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【税务行政处罚决定书处罚日期】'||TO_CHAR(CF.WSZZRQ,'YYYYMMDD')||
              '；【违法手段】'||TO_CHAR(SUBSTR(CF.WFSD,1,500))||
              '；【处罚决定】'||TO_CHAR(SUBSTR(CF.CFJD,1,500)),
              TRUNC(CF.WSZZRQ),SYSDATE
         FROM HX_CKTS.CKTS_BA_BAXX_JGB BA
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=BA.DJXH
        INNER JOIN HX_JC.JC_AJXX AJ ON AJ.DJXH=BA.DJXH
        INNER JOIN HX_FZ.FZ_SWXZCFJDS CF ON CF.SSWFXWDJUUID=AJ.JCAJXXUUID AND NVL(CF.ZFBZ_1,'N')='N'
        WHERE NVL(BA.BACHBZ,'N')='N'
          AND CF.WSZZRQ>=LD_SJCL_Y AND ADD_MONTHS(CF.WSZZRQ,1)<TRUNC(SYSDATE) AND CF.CFJD LIKE '%停止%出口退税%'
          AND NOT EXISTS (SELECT 1
                            FROM HX_CKTS.CKTS_BA_KZ_JGB A
                           WHERE A.DJXH=BA.DJXH AND A.CKTMSBAKZLX_DM='TQQY' AND A.YXBZ='Y'
                             AND ADD_MONTHS(CF.WSZZRQ,1)>=A.YXQQ AND CF.WSZZRQ<=A.YXQZ);
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023052401...');
  COMMIT;

  -- 稽查立案后未进行暂缓或暂扣税款处理
  -- 2023052501   事前（立案满5个工作日）
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH JCLAQY AS (
       --出口企业案源管理台账
       SELECT 'TZB' AS SJLY,T.UUID,T.DJXH,TRUNC(T.LARQ) AS LARQ
         FROM HX_CKTS.CKTS_QT_CKQYAYGLTZ_GCB T
        WHERE T.LABZ='Y' AND T.JABZ='N'
          AND COMPUTE_BLJZDATE('A',T.LARQ)<TRUNC(SYSDATE)
        UNION ALL
       SELECT 'TZB' AS SJLY,T.UUID,T.DJXH,TRUNC(T.LARQ) AS LARQ
         FROM HX_CKTS.CKTS_QT_CKQYAYGLTZ_JGB T
        WHERE T.LABZ='Y' AND T.JABZ='N'
          AND COMPUTE_BLJZDATE('A',T.LARQ)<TRUNC(SYSDATE)
        UNION ALL
       --关于出口企业的立案、查处情况告知书
       SELECT 'GZS' AS SJLY,T.SSSXNBYSJFKBUUID AS UUID,T.DJXH,MIN(TRUNC(T.QSRQ)) AS LARQ
         FROM HX_ZH.ZH_GYCKQYLACCQKGZS T
        WHERE COMPUTE_BLJZDATE('A',T.QSRQ)<TRUNC(SYSDATE)
        GROUP BY T.SSSXNBYSJFKBUUID,T.DJXH),
         ZKQY AS (
       SELECT UUID,DJXH,LARQ,SJLY,ZKRQ,ROW_NUMBER() OVER (PARTITION BY DJXH ORDER BY LARQ DESC,ZKRQ) AS RN
         FROM (SELECT S.UUID,S.DJXH,S.LARQ,S.SJLY,TRUNC(ZK.LRRQ) AS ZKRQ
                 FROM JCLAQY S
                 LEFT JOIN HX_CKTS.CKTS_TS_ZKCKTSYWCLB_JGB ZK ON ZK.DJXH=S.DJXH AND ZK.LRRQ>S.LARQ
                UNION ALL
               SELECT S.UUID,S.DJXH,S.LARQ,S.SJLY,TRUNC(ZK.LRRQ) AS ZKRQ
                 FROM JCLAQY S
                 LEFT JOIN HX_CKTS.CKTS_TS_ZKCKTSYWCLB_GCB ZK ON ZK.DJXH=S.DJXH AND ZK.LRRQ>S.LARQ) TT
       )
       SELECT '2023052501',  -- '风险管理类','JC-LA-YZHSKCL',
              HZ.UUID,HZ.TSSWJG_DM_1,HZ.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,HZ.SEHZZZSTSE+HZ.SEHZXFSTSE,
              (CASE WHEN ZKQY.SJLY='GZS' THEN '【告知书签收日期】' ELSE '【台账立案日期】' END)||TO_CHAR(ZKQY.LARQ,'YYYYMMDD')||
              '【录入暂扣日期】'||TO_CHAR(ZKQY.ZKRQ,'YYYYMMDD')||'【税额核准日期】'||TO_CHAR(HZ.SEHZRQ,'YYYYMMDD'),
              SYSDATE,SYSDATE
         FROM ZKQY
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=ZKQY.DJXH
        INNER JOIN HX_CKTS.CKTS_TY_SEHZB HZ ON HZ.DJXH=ZKQY.DJXH
        WHERE ZKQY.RN=1
          AND HZ.SEHZRQ>=LD_SJCL_M
          AND HZ.SEHZRQ>ZKQY.LARQ AND HZ.SEHZRQ<NVL(ZKQY.ZKRQ,SYSDATE) AND HZ.SEHZZZSTSE+HZ.SEHZXFSTSE>0;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023052501...');
  COMMIT;

  -- 收到异常抵扣凭证未按照规定处理
  -- 2023052601  X
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023052601',  -- '风险管理类','SDYCDKPZWAGDCL',
              YC.UUID,BA.TSSWJG_DM_1,BA.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,YC.JE,YC.SE,
              '【异常扣税凭证号码】'||JH.JHPZH||'；【申报退税所属期批次】'||JH.SSQ||'-'||JH.SBPC||
              '；【申报退税日期】'||TO_CHAR(JH.LRRQ,'YYYYMMDD')||'；【异常信息入库日期】'||TO_CHAR(YC.LRRQ,'YYYYMMDD'),
              YC.LRRQ,SYSDATE
         FROM HX_CKTS.CKTS_BA_BAXX_JGB BA
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=BA.DJXH
        INNER JOIN HX_CKTS.CKTS_WBSJ_FP_YCKSPZXX YC ON YC.DJXH=BA.DJXH AND YC.RDHJCBZ='Y' AND TRIM(YC.ZKLCLCSLID) IS NULL
        INNER JOIN HX_CKTS.CKTS_SB_MTS_TSJH_JGB JH ON JH.DJXH=BA.DJXH AND JH.JHPZH=YC.FP_DM||YC.FPHM AND NVL(JH.BYTSBZ,'N')='N'
        INNER JOIN HX_CKTS.CKTS_TY_YWBLXX LC ON LC.LCSLID=JH.LCSLID AND LC.CKQYGLLB_DM<>'A'
        WHERE NVL(BA.BACHBZ,'N')='N' AND YC.LRRQ>=LD_SJCL_M AND YC.LRRQ>JH.LRRQ
          AND NOT EXISTS (SELECT 1
                            FROM HX_CKTS.CKTS_TK_YZHYTSKMXB_JGB JGB
                           WHERE JGB.DJXH=BA.DJXH AND JGB.JXPZH=JH.JHPZH AND JGB.YZHYTMSKYY_DM='033'
                           UNION ALL
                          SELECT 1
                            FROM HX_CKTS.CKTS_TK_YZHYTSKMXB_GCB GCB
                           WHERE GCB.DJXH=BA.DJXH AND GCB.JXPZH=JH.JHPZH AND GCB.YZHYTMSKYY_DM='033');
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023052601...');
  COMMIT;

  -- 不应撤回而撤回存在不予退税情形的出口退（免）税申报
  -- 2023052701  事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH FUHBY AS (
       SELECT F1.FHXXBUUID,F1.FAHDSWJG_DM,F1.WSBH,F1.GHFDJXH,F1.GHQYNSRSBH,F1.GHFQYMC,F1.GHFZGSWJGMC,F1.GHQYNSRSBH_1,F1.GHFQYMC_1,
              JH.SSQ,JH.SBPC,JH.SBXH,JH.JHPZH,JH.JSJE,JH.TSE,H1.QFRQ,H1.FHLX_DM,
              ROW_NUMBER() OVER (PARTITION BY H1.FHXXBUUID,JH.SBXH ORDER BY QD.HDFPQDUUID) AS RN
         FROM HX_ZH.ZH_CKTS_FHXXB F1
        INNER JOIN HX_ZH.ZH_CKTS_FUHXXB H1 ON H1.FHXXBUUID=F1.FHXXBUUID AND NVL(H1.ZFBZ_1,'N')='N' AND TRIM(H1.FHBH) IS NOT NULL
        INNER JOIN HX_ZH.ZH_CKTS_HDFPQD QD ON QD.FHXXBUUID=F1.FHXXBUUID AND QD.SFYTS='N' --函调时未退税
        INNER JOIN HX_CKTS.CKTS_SB_MTS_TSJH_JGB JH ON JH.DJXH=F1.GHFDJXH AND JH.JHPZH=QD.ZZSZYFPDMHM
          AND NVL(JH.BYTSBZ,'N')='N' AND JH.TSE>0--对应发票已退税
        WHERE F1.FAHDSWJG_DM LIKE '133%' AND F1.FAHDSWJG_DM NOT LIKE '13302%' AND NVL(F1.ZFBZ_1,'N')='N' --范围：全省不含宁波
          AND H1.QFRQ>=LD_SJCL_M --范围：本年签发
          AND H1.FHLX_DM='2' --复函类型：存在不予退（免）税发票
          AND NOT EXISTS (SELECT 1 --不存在不予改准予的回函
                            FROM HX_ZH.ZH_CKTS_FUHXXB H2
                           WHERE H2.FHXXBUUID=F1.FHXXBUUID AND NVL(H2.ZFBZ_1,'N')='N' AND H2.FHLX_DM='1' AND TRIM(H2.FHBH) IS NOT NULL
                             AND H2.QFRQ>H1.QFRQ)
          AND EXISTS (SELECT 1 --存在撤回申报
                        FROM HX_CKTS.CKTS_SB_QYCHSBSJSL_JGB CH
                       WHERE CH.DJXH=JH.DJXH AND CH.SBCHYSSQ=JH.SSQ AND CH.SBCHYSBPC=JH.SBPC)
       )
       SELECT '2023052701',  -- '风险管理类','HD-CL-BYTS-CHSB',
              FUHBY.FHXXBUUID,FUHBY.FAHDSWJG_DM,FUHBY.GHFDJXH,FUHBY.GHQYNSRSBH,FUHBY.GHFQYMC,SUM(FUHBY.JSJE),SUM(FUHBY.TSE),
              '【所属期-批次】'||FUHBY.SSQ||FUHBY.SBPC||'；【供货企业税号】'||FUHBY.GHQYNSRSBH_1||
              '；【核实函编号】'||FUHBY.WSBH||'；【回函日期】'||TO_CHAR(FUHBY.QFRQ,'YYYYMMDD')||'；【回函类型】'||FUHBY.FHLX_DM,
              FUHBY.QFRQ,SYSDATE
         FROM FUHBY
        WHERE RN=1
        GROUP BY FUHBY.FHXXBUUID,FUHBY.FAHDSWJG_DM,FUHBY.GHFDJXH,FUHBY.GHQYNSRSBH,FUHBY.GHFQYMC,
              FUHBY.SSQ,FUHBY.SBPC,FUHBY.GHQYNSRSBH_1,FUHBY.WSBH,FUHBY.QFRQ,FUHBY.FHLX_DM;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023052701...');
  COMMIT;

  -- 为出口企业办理退免税计算方法变更的，未结清变更前出口退（免）税款
  -- 2023052801  事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH BGJSFF AS (
       SELECT LC.UUID,LC.TSSWJG_DM_1,LC.DJXH,BG.BABGZD_DM,BG.BABGZDMC,BG.BGQ,BG.BGH,TRUNC(LC.QDSJ) AS QDSJ,TRUNC(LC.FFRQ) AS FFRQ
         FROM HX_CKTS.CKTS_TY_YWBLXX LC
        INNER JOIN HX_CKTS.CKTS_BA_BABGQK_JGB BG ON BG.LCSLID=LC.LCSLID AND BG.BABGZD_DM='CKHWTMSJSFF_DM'
        WHERE NVL(LC.ZFBZ_1,'N')='N' AND LC.FFRQ>=LD_SJCL_M
       )
       SELECT '2023052801',  -- '风险管理类','BABG-WJQSK',
              BGJSFF.UUID,BGJSFF.TSSWJG_DM_1,BGJSFF.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【变更退(免)税计算方法无结清税款报告表，变更日期】'||TO_CHAR(BGJSFF.QDSJ,'YYYYMMDD')||
              '；【变更前】'||BGJSFF.BGQ||'；【变更后】'||BGJSFF.BGH,
              BGJSFF.FFRQ,SYSDATE
         FROM BGJSFF
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=BGJSFF.DJXH
        WHERE NOT EXISTS (SELECT 1
                            FROM HX_CKTS.CKTS_BA_JQSK_JGB JQSK
                           WHERE JQSK.DJXH=BGJSFF.DJXH AND JQSK.CJBGRQ>=BGJSFF.QDSJ AND JQSK.CJBGRQ<=BGJSFF.FFRQ)
          AND EXISTS (SELECT 1
                        FROM HX_CKTS.CKTS_TY_YWBLXX LC
                       WHERE LC.DJXH=BGJSFF.DJXH AND LC.LCSWSX_DM IN ('LCSXA081038001','LCSXA081039001')
                         AND LC.LRRQ<BGJSFF.QDSJ AND LC.FFBZ='Y');
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023052801...');
  COMMIT;

  -- 在变更退免税计算方法后，为企业办理变更前出口货物退（免）税。
  -- 2023052802  事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH BGJSFF AS (
       SELECT LC.UUID,LC.TSSWJG_DM_1,LC.DJXH,BG.BABGZD_DM,BG.BABGZDMC,BG.BGQ,BG.BGH,TRUNC(LC.QDSJ) AS QDSJ,TRUNC(LC.FFRQ) AS FFRQ,
              ROW_NUMBER() OVER(PARTITION BY LC.DJXH ORDER BY LC.FFRQ DESC) RN
         FROM HX_CKTS.CKTS_TY_YWBLXX LC
        INNER JOIN HX_CKTS.CKTS_BA_BABGQK_JGB BG ON BG.LCSLID=LC.LCSLID AND BG.BABGZD_DM='CKHWTMSJSFF_DM'
        WHERE NVL(LC.ZFBZ_1,'N')='N'
       )
       SELECT '2023052802',  -- '风险管理类','BABG-BGQCKYW',
              MDT.UUID,BGJSFF.TSSWJG_DM_1,BGJSFF.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,MDT.MYLAJ,MDT.MDTSE,
              '【外贸变生产日期】'||TO_CHAR(BGJSFF.QDSJ,'YYYYMMDD')||
              '；【出口凭证号码】'||NVL(MDT.DLCKHWZMHM,MDT.CKBGDH)||'；【出口日期】'||TO_CHAR(MDT.CKRQ_1,'YYYYMMDD')||'；【退税申报日期】'||TO_CHAR(MDT.LRRQ,'YYYYMMDD'),
              MDT.LRRQ,SYSDATE
         FROM BGJSFF
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=BGJSFF.DJXH
        INNER JOIN HX_CKTS.CKTS_SB_MDT_TSSB_JGB MDT ON MDT.DJXH=BGJSFF.DJXH
        WHERE MDT.LRRQ>=LD_SJCL_M AND MDT.CKSL>0
          AND BGJSFF.RN=1 AND MDT.CKRQ_1<BGJSFF.QDSJ AND MDT.LRRQ>BGJSFF.QDSJ AND NVL(MDT.BYBLBZ,'N')='N' AND NVL(MDT.BYTSBZ,'N')='N'
          AND EXISTS (SELECT 1 FROM HX_CKTS.CKTS_SB_MTS_TSSB_JGB MTS WHERE MTS.DJXH=BGJSFF.DJXH AND MTS.LRRQ<BGJSFF.QDSJ)
          AND NOT EXISTS (SELECT 1 FROM HX_CKTS.CKTS_BA_YCKWJQTMSBG_JGB WJQ WHERE WJQ.DJXH=BGJSFF.DJXH AND WJQ.PZHM_2=NVL(MDT.DLCKHWZMHM,MDT.CKBGDH))
        UNION ALL
       SELECT '2023052802',  -- '风险管理类','BABG-BGQCKYW',
              MTS.UUID,BGJSFF.TSSWJG_DM_1,BGJSFF.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,MTS.MYLAJ,NULL,
              '【生产变外贸日期】'||TO_CHAR(BGJSFF.QDSJ,'YYYYMMDD')||
              '；【出口凭证号码】'||NVL(MTS.DLZMH,MTS.CKBGDH)||'；【出口日期】'||TO_CHAR(MTS.CKRQ_1,'YYYYMMDD')||'；【退税申报日期】'||TO_CHAR(MTS.LRRQ,'YYYYMMDD'),
              MTS.LRRQ,SYSDATE
         FROM BGJSFF
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=BGJSFF.DJXH
        INNER JOIN HX_CKTS.CKTS_SB_MTS_TSSB_JGB MTS ON MTS.DJXH=BGJSFF.DJXH
        WHERE MTS.LRRQ>=LD_SJCL_M AND MTS.CKSL>0
          AND BGJSFF.RN=1 AND MTS.CKRQ_1<BGJSFF.QDSJ AND MTS.LRRQ>BGJSFF.QDSJ AND NVL(MTS.BYBLBZ,'N')='N' AND NVL(MTS.BYTSBZ,'N')='N'
          AND EXISTS (SELECT 1 FROM HX_CKTS.CKTS_SB_MDT_TSSB_JGB MDT WHERE MDT.DJXH=BGJSFF.DJXH AND MDT.LRRQ<BGJSFF.QDSJ)
          AND NOT EXISTS (SELECT 1 FROM HX_CKTS.CKTS_BA_YCKWJQTMSBG_JGB WJQ WHERE WJQ.DJXH=BGJSFF.DJXH AND WJQ.PZHM_2=NVL(MTS.DLZMH,MTS.CKBGDH));
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023052802...');
  COMMIT;

  -- 小规模纳税人期间出口的报关单在认定为一般纳税人之后进行退税申报
  -- 2023052901  X
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH XGMCK AS (
       SELECT MDT.UUID,MDT.TSSWJG_DM_1,MDT.DJXH,MDT.SSQ AS SSQPC,NVL(MDT.DLCKHWZMHM,MDT.CKBGDH) AS CKPZH,MDT.CKRQ_1,MDT.MYLAJ,MDT.LRRQ
         FROM HX_CKTS.CKTS_TY_YWBLXX YW
        INNER JOIN HX_CKTS.CKTS_SB_MDT_TSSB_JGB MDT
           ON MDT.DJXH=YW.DJXH AND MDT.SSQ=YW.SSQ
          AND NVL(MDT.BYBLBZ,'N')='N' AND NVL(MDT.BYTSBZ,'N')='N'
         LEFT JOIN HX_RD.RD_NSRZGXX_JGB KZ
           ON KZ.DJXH=MDT.DJXH AND KZ.NSRZGLX_DM IN ('201','202','203') AND KZ.YXQQ<=MDT.CKRQ_1 AND KZ.SJZZRQ>=MDT.CKRQ_1 AND KZ.ZFBZ_1='N'
        WHERE YW.LCSWSX_DM='LCSXA081038001' AND YW.QDSJ>=LD_SJCL_M
          AND KZ.DJXH IS NULL
        UNION ALL
       SELECT MTS.UUID,MTS.TSSWJG_DM_1,MTS.DJXH,MTS.SSQ||MTS.SBPC AS SSQPC,NVL(MTS.DLZMH,MTS.CKBGDH) AS CKPZH,MTS.CKRQ_1,MTS.MYLAJ,MTS.LRRQ
         FROM HX_CKTS.CKTS_TY_YWBLXX YW
        INNER JOIN HX_CKTS.CKTS_SB_MTS_TSSB_JGB MTS
           ON MTS.DJXH=YW.DJXH AND MTS.SSQ=YW.SSQ AND MTS.SBPC=YW.SBPC
          AND NVL(MTS.BYBLBZ,'N')='N' AND NVL(MTS.BYTSBZ,'N')='N'
         LEFT JOIN HX_RD.RD_NSRZGXX_JGB KZ
           ON KZ.DJXH=MTS.DJXH AND KZ.NSRZGLX_DM IN ('201','202','203') AND KZ.YXQQ<=MTS.CKRQ_1 AND KZ.SJZZRQ>=MTS.CKRQ_1 AND KZ.ZFBZ_1='N'
        WHERE YW.LCSWSX_DM='LCSXA081039001' AND YW.QDSJ>=LD_SJCL_M
          AND KZ.DJXH IS NULL
       )
       SELECT '2023052901',  -- '风险管理类','BABG-XGMCKYW',
              XGMCK.UUID,XGMCK.TSSWJG_DM_1,XGMCK.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,XGMCK.MYLAJ,NULL,
              '【所属期批次】'||XGMCK.SSQPC||'；【出口凭证号码】'||XGMCK.CKPZH||'；【出口日期】'||TO_CHAR(XGMCK.CKRQ_1,'YYYYMMDD'),
              XGMCK.LRRQ,SYSDATE
         FROM XGMCK
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=XGMCK.DJXH;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023052901...');
  COMMIT;

  -- 未按规定处理系统提示的审核疑点
  -- 2023070101  事中
  -- 2023070102  事中
  -- 2023070103  事中
  -- 2023070104  事中
  -- 2023070105  事中
  -- 2023070106  事中
  -- 2023070107  事中
  -- 2023070108  事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       -- 免抵退疑点挑过处理意见说明小于8位
       SELECT '2023070101',  -- '申报管理类','SHYD-CLYJQS-MDT',
              T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【所属期'||T.SSQ||'；【申报序号】'||T.SBXH||
              '；【疑点编号】'||T.YDBH||'；【疑点内容】'||T.YDNR||'；【处理意见说明】'||T.CLYJSM,
              COALESCE(T.CLSJ,T.XGRQ),SYSDATE
         FROM HX_CKTS.CKTS_BL_MDT_SHYD_JGB T
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
        WHERE T.LRRQ>=LD_SJCL_M
          AND T.SHYDCL_DM='02' -- 挑过的
          AND LENGTH(T.CLYJSM)<8
          AND T.YDBH NOT IN ('B0105','B0405','B0406','B0407')
        UNION ALL
       -- 免退税疑点挑过处理意见说明小于8位
       SELECT '2023070102',  -- '申报管理类','SHYD-CLYJQS-MTS',
              T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【所属期-批次】'||T.SSQ||'-'||T.SBPC||'；【申报序号】'||T.SBXH||'；【关联号】'||T.GLH||
              '；【疑点编号】'||T.YDBH||'；【疑点内容】'||T.YDNR||'；【处理意见说明】'||T.CLYJSM,
              COALESCE(T.CLSJ,T.XGRQ),SYSDATE
         FROM HX_CKTS.CKTS_BL_MTS_SHYD_JGB T
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
        WHERE T.LRRQ>=LD_SJCL_M
          AND T.SHYDCL_DM='02' -- 挑过的
          AND LENGTH(T.CLYJSM)<8
        UNION ALL
       -- 代办退税疑点挑过处理意见说明小于8位
       SELECT '2023070103',  -- '申报管理类','SHYD-CLYJQS-WZF',
              T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【所属期-批次】'||T.SSQ||'-'||T.SBPC||'；【申报序号】'||T.SBXH||
              '；【疑点编号】'||T.YDBH||'；【疑点内容】'||T.YDNR||'；【处理意见说明】'||T.CLYJSM,
              COALESCE(T.CLSJ,T.XGRQ),SYSDATE
         FROM HX_CKTS.CKTS_BL_DB_SHYD_JGB T
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
        WHERE T.LRRQ>=LD_SJCL_M
          AND T.SHYDCL_DM='02' -- 挑过的
          AND LENGTH(T.CLYJSM)<8
        UNION ALL
       -- 首次跨大类商品退税疑点
       -- 20231211 按省局李裕军局长意见，B0105也改成疑点挑过意见小于8的提示
       SELECT '2023070104',  -- '申报管理类','SHYD-KDLSB-MDT',
              T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【所属期'||T.SSQ||'；【申报序号】'||T.SBXH||
              '；【疑点编号】'||T.YDBH||'；【疑点内容】'||T.YDNR||'；【处理意见说明】'||T.CLYJSM,
              COALESCE(T.CLSJ,T.XGRQ),SYSDATE
         FROM HX_CKTS.CKTS_BL_MDT_SHYD_JGB T
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
        WHERE T.LRRQ>=LD_SJCL_M
          AND T.SHYDCL_DM='02' -- 挑过的
          AND LENGTH(T.CLYJSM)<8
          AND T.YDBH='B0105'
        UNION ALL
       -- 先退后核申报与资格审查疑点
       SELECT '2023070105',  -- '申报管理类','SHYD-XTHHZG-MDT',
              T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【所属期'||T.SSQ||'；【申报序号】'||T.SBXH||
              '；【疑点编号】'||T.YDBH||'；【疑点内容】'||T.YDNR||'；【处理意见说明】'||T.CLYJSM,
              COALESCE(T.CLSJ,T.XGRQ),SYSDATE
         FROM HX_CKTS.CKTS_BL_MDT_SHYD_JGB T
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
        WHERE T.LRRQ>=LD_SJCL_M
          AND T.SHYDCL_DM='02' -- 挑过的
          AND T.YDBH IN ('B0405','B0406','B0407')
        UNION ALL
       -- 应发函未发函
       SELECT '2023070106',  -- '申报管理类','SHYD-YFHWFH-MDT',
              T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【所属期】'||T.SSQ||'；【申报序号】'||T.SBXH||
              '；【疑点内容】'||T.YDNR||'；【发函编号】无；【其他核查内容】'||T.QTHCNR||'；【综合审核处理意见】准予退税',
              T.XGRQ,SYSDATE
         FROM HX_CKTS.CKTS_BL_MDT_SHYDCL_JGB T
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
        WHERE T.LRRQ>=LD_SJCL_M
          AND T.SHDCHSJYDMJH='2' -- 发函
          AND TRIM(FHBH) IS NULL -- 函件编号为空
          AND ZHSHCLYJLX_DM ='4' -- 综合审核处理意见类型代码=4准予退税
        UNION ALL
       -- 应发函未发函
       SELECT '2023070107',  -- '申报管理类','SHYD-YFHWFH-MTS',
              T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【所属期-批次】'||T.SSQ||'-'||T.SBPC||'；【申报序号】'||T.SBXH||'；【关联号】'||T.GLH||
              '；【疑点内容】'||T.YDNR||'；【发函编号】无；【其他核查内容】'||T.QTHCNR||'；【综合审核处理意见】准予退税',
              T.XGRQ,SYSDATE
         FROM HX_CKTS.CKTS_BL_MTS_SHYDCL_JGB T
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
        WHERE T.LRRQ>=LD_SJCL_M
          AND T.SHDCHSJYDMJH='2' -- 发函
          AND TRIM(FHBH) IS NULL -- 函件编号为空
          AND ZHSHCLYJLX_DM ='4' -- 综合审核处理意见类型代码=4准予退税
          AND NOT EXISTS (SELECT 1 --不存在12个月内从同一供货企业购进同类商品的正常回函
                            FROM HX_ZH.ZH_CKTS_FHXXB F1
                           INNER JOIN HX_ZH.ZH_CKTS_HDFPQD QD ON QD.FHXXBUUID=F1.FHXXBUUID
                           INNER JOIN HX_CKTS.CKTS_SB_MTS_TSJH_JGB JH ON JH.DJXH=F1.GHFDJXH AND JH.JHPZH=QD.ZZSZYFPDMHM
                           INNER JOIN HX_ZH.ZH_CKTS_FUHXXB H1 ON H1.FHXXBUUID=F1.FHXXBUUID
                           WHERE F1.GHFDJXH=T.DJXH AND F1.GHQYNSRSBH_1=T.GHFNSRSBH_1
                             AND JH.CKSP_DM=T.CKSP_DM
                             AND NVL(H1.ZFBZ_1,'N')='N' AND TRIM(H1.FHBH) IS NOT NULL AND H1.FHLX_DM='1'
                             AND H1.QFRQ>=ADD_MONTHS(T.LRRQ,-12) AND H1.QFRQ<T.XGRQ)
        UNION ALL
       -- 应发函未发函
       SELECT '2023070108',  -- '申报管理类','SHYD-YFHWFH-WZF',
              T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【所属期】'||T.SSQ||'；【申报序号】'||T.SBXH||
              '；【疑点内容】'||T.YDNR||'；【发函编号】无；【其他核查内容】'||T.QTHCNR||'；【综合审核处理意见】准予退税',
              T.XGRQ,SYSDATE
         FROM HX_CKTS.CKTS_BL_DB_SHYDCL_JGB T
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
        WHERE T.LRRQ>=LD_SJCL_M
          AND T.SHDCHSJYDMJH='2' -- 发函
          AND TRIM(FHBH) IS NULL -- 函件编号为空
          AND ZHSHCLYJLX_DM ='4'; -- 综合审核处理意见类型代码=4准予退税
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023070108...');
  COMMIT;

  -- 应暂不办理而办理出口退税（进出口税收管理部门已移送稽查部门的出口业务）
  -- 2023070201  X
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH AYTZ AS (
       SELECT S.SSSXNBYSJFKBUUID,S.DJXH,S.LRRQ,S.FKRQ
         FROM HX_ZH.ZH_SSSXNBYSJFKB S
        WHERE S.LRRQ>=LD_SJCL_M
          AND S.NBYSSSSXLX_DM LIKE '%03%' AND NVL(S.ZFBZ_1,'N')<>'Y')
       SELECT '2023070201',  -- '风险管理类','JC-CKYSJC-ZBBL',
              AYTZ.SSSXNBYSJFKBUUID,HZ.TSSWJG_DM_1,AYTZ.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,SUM(HZ.SEHZZZSTSE+HZ.SEHZXFSTSE),
              '【涉税事项内部移送录入日期】'||TO_CHAR(AYTZ.LRRQ,'YYYYMMDD')||'；【反馈日期】'||TO_CHAR(AYTZ.FKRQ,'YYYYMMDD'),
              AYTZ.LRRQ,SYSDATE
         FROM AYTZ
        INNER JOIN HX_CKTS.CKTS_TY_SEHZB HZ ON HZ.DJXH=AYTZ.DJXH
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=AYTZ.DJXH
        WHERE HZ.SEHZRQ>=AYTZ.LRRQ AND HZ.SEHZRQ<NVL(AYTZ.FKRQ,SYSDATE)
        GROUP BY AYTZ.SSSXNBYSJFKBUUID,HZ.TSSWJG_DM_1,AYTZ.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,AYTZ.LRRQ,AYTZ.FKRQ;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023070201...');
  COMMIT;

  -- 应追回未追回已退税税款
  -- 超过5个工作日
  -- 2023070301   事前
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023070301',  -- '风险管理类','PG-YZHWZH',
              PG.UUID,PG.TSSWJG_DM_1,PG.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,PG.TZCKERMB,PG.TZYTSE,
              '【评估日期】'||TO_CHAR(PG.LRRQ,'YYYYMMDD')||'；【评估处理情况】'||PG.PGCLQK,
              PG.LRRQ,SYSDATE
         FROM HX_CKTS.CKTS_FX_PGGZQK_JGB PG
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=PG.DJXH
        WHERE PG.LRRQ>=LD_SJCL_M
          AND COMPUTE_BLJZDATE('A',PG.LRRQ)<TRUNC(SYSDATE)
          AND (PG.PGCLQKDMJH LIKE '%4%' OR PG.PGCLQK LIKE '%追回%' OR PG.PGCLQK LIKE '%返纳%' OR PG.PGCLQK LIKE '%反纳%')
          AND NOT EXISTS (SELECT 1 --不存在回函2个月内应追回
                            FROM HX_CKTS.CKTS_TK_YZHYTSKMXB_JGB YZH
                           WHERE YZH.DJXH=PG.DJXH AND YZH.SSQ>=TO_CHAR(PG.PGRQQ,'YYYYMM') AND YZH.SSQ<=TO_CHAR(PG.PGRQZ,'YYYYMM'));
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023070301...');
  COMMIT;

  -- 应暂不办理而办理出口退税（因涉嫌骗取出口退税被税务机关稽查部门立案查处未结案的出口业务）
  -- 2023070401  X
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH AYTZ AS (
       SELECT JGB.UUID,JGB.DJXH,NVL(JGB.LARQ,JGB.XSYSQSRQ) AS LARQ,JGB.JARQ
         FROM HX_CKTS.CKTS_QT_CKQYAYGLTZ_JGB JGB
        WHERE JGB.LABZ='Y'
          AND NVL(JGB.LARQ,JGB.XSYSQSRQ)>=LD_SJCL_M
        UNION ALL
       SELECT GCB.UUID,GCB.DJXH,NVL(GCB.LARQ,GCB.XSYSQSRQ) AS LARQ,GCB.JARQ
         FROM HX_CKTS.CKTS_QT_CKQYAYGLTZ_GCB GCB
        WHERE GCB.LABZ='Y'
          AND NVL(GCB.LARQ,GCB.XSYSQSRQ)>=LD_SJCL_M)
       SELECT '2023070401',  -- '风险管理类','JC-JCLAWJA-ZBBL',
              AYTZ.UUID,HZ.TSSWJG_DM_1,AYTZ.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,SUM(HZ.SEHZZZSTSE+HZ.SEHZXFSTSE),
              '【案源管理台账立案日期/线索签收日期】'||TO_CHAR(AYTZ.LARQ,'YYYYMMDD')||'；【结案日期】'||TO_CHAR(AYTZ.JARQ,'YYYYMMDD'),
              AYTZ.LARQ,SYSDATE
         FROM AYTZ
        INNER JOIN HX_CKTS.CKTS_TY_SEHZB HZ ON HZ.DJXH=AYTZ.DJXH
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=AYTZ.DJXH
        WHERE HZ.SEHZRQ>=AYTZ.LARQ AND HZ.SEHZRQ<NVL(AYTZ.JARQ,SYSDATE)
        GROUP BY AYTZ.UUID,HZ.TSSWJG_DM_1,AYTZ.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,AYTZ.LARQ,AYTZ.JARQ;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023070401...');
  COMMIT;

  -- 违规兼任出口退（免）税岗位（免抵退税）
  -- 2023070501  事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH YDCL AS (
       SELECT SHLC.UUID,JG.TSSWJG_DM_1,JG.DJXH,JG.SSQ,JG.MDTSNY,YD.SDHCRXMJH,YD.SDHCBGBH,
              SHRY.SWRY_DM AS SHRYDM,SHRY.SWRYXM AS SHRYXM,FSRY.SWRY_DM AS FSRYDM,FSRY.SWRYXM AS FSRYXM,FSLC.FFRQ,
              SUM(JG.RMBLAJ) AS JE,SUM(JG.MDTSE) AS SE
         FROM HX_CKTS.CKTS_BL_MDT_SHYDCL_JGB YD
        INNER JOIN HX_CKTS.CKTS_SB_MDT_TSSB_JGB JG ON JG.DJXH=YD.DJXH AND JG.SSQ=YD.SSQ AND JG.SBXH=YD.SBXH AND JG.CKSL>0
        INNER JOIN HX_CKTS.CKTS_TY_YWBLXX SHLC ON SHLC.DJXH=JG.DJXH AND SHLC.SSQ=JG.SSQ
          AND SHLC.LCSWSX_DM='LCSXA081038001' AND NVL(SHLC.ZFBZ_1,'N')='N' AND NVL(SHLC.HTBZ_1,'N')='N'
        INNER JOIN HX_CKTS.CKTS_TY_TSSBYWBL_MXB SHHJ ON SHHJ.LCSLID=SHLC.LCSLID AND SHHJ.LCHJ_DM='02'
        INNER JOIN HX_DM_ZDY.DM_GY_SWRY SHRY ON SHRY.SWRY_DM=SHHJ.TS_RYDM
        INNER JOIN HX_CKTS.CKTS_TY_YWBLXX FSLC ON FSLC.DJXH=JG.DJXH AND FSLC.SSQ=JG.MDTSNY
          AND FSLC.LCSWSX_DM='LCSXA081038001' AND NVL(FSLC.ZFBZ_1,'N')='N' AND NVL(FSLC.HTBZ_1,'N')='N'
        INNER JOIN HX_CKTS.CKTS_TY_TSSBYWBL_MXB FSHJ ON FSHJ.LCSLID=FSLC.LCSLID AND FSHJ.LCHJ_DM='04'
        INNER JOIN HX_DM_ZDY.DM_GY_SWRY FSRY ON FSRY.SWRY_DM=FSHJ.TS_RYDM
        WHERE YD.LRRQ>=LD_SJCL_M AND TRIM(YD.SDHCBGBH) IS NOT NULL
          AND (REGEXP_LIKE(YD.SDHCRXMJH,SHRY.SWRYXM) OR REGEXP_LIKE(YD.SDHCRXMJH,FSRY.SWRYXM))
        GROUP BY SHLC.UUID,JG.TSSWJG_DM_1,JG.DJXH,JG.SSQ,JG.MDTSNY,YD.SDHCRXMJH,YD.SDHCBGBH,SHRY.SWRY_DM,SHRY.SWRYXM,FSRY.SWRY_DM,FSRY.SWRYXM,FSLC.FFRQ
       )
       SELECT '2023070501',  -- '综合管理类','GWZY-HCRY-MDT',
              YDCL.UUID,YDCL.TSSWJG_DM_1,YDCL.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,YDCL.JE,YDCL.SE,
              '【申报所属期-复审所属期】'||YDCL.SSQ||'-'||YDCL.MDTSNY||'；【实地核查报告】'||YDCL.SDHCBGBH||
              '；【实地核查人员】'||YDCL.SDHCRXMJH||'；【审核人员】'||YDCL.SHRYXM||'；【复审人员】'||YDCL.FSRYXM,
              YDCL.FFRQ,SYSDATE
         FROM YDCL
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=YDCL.DJXH;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023070501...');
  COMMIT;

  -- 违规兼任出口退（免）税岗位（免退税）
  -- 2023070502  事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH YDCL AS (
       SELECT SHLC.UUID,JG.TSSWJG_DM_1,JG.DJXH,JG.SSQ,JG.SBPC,YD.SDHCRXMJH,YD.SDHCBGBH,
              SHRY.SWRY_DM AS SHRYDM,SHRY.SWRYXM AS SHRYXM,FSRY.SWRY_DM AS FSRYDM,FSRY.SWRYXM AS FSRYXM,FSLC.FFRQ,
              SUM(JG.JSJE) AS JE,SUM(JG.TSE) AS SE
         FROM HX_CKTS.CKTS_BL_MTS_SHYDCL_JGB YD
        INNER JOIN HX_CKTS.CKTS_SB_MTS_TSJH_JGB JG ON JG.DJXH=YD.DJXH AND JG.SSQ=YD.SSQ AND JG.SBPC=YD.SBPC AND JG.SBXH=YD.SBXH AND JG.SL>0
        INNER JOIN HX_CKTS.CKTS_TY_YWBLXX SHLC ON SHLC.DJXH=JG.DJXH AND SHLC.SSQ=JG.SSQ AND SHLC.SBPC=JG.SBPC
          AND SHLC.LCSWSX_DM='LCSXA081039001' AND NVL(SHLC.ZFBZ_1,'N')='N' AND NVL(SHLC.HTBZ_1,'N')='N'
        INNER JOIN HX_CKTS.CKTS_TY_TSSBYWBL_MXB SHHJ ON SHHJ.LCSLID=SHLC.LCSLID AND SHHJ.LCHJ_DM='02'
        INNER JOIN HX_DM_ZDY.DM_GY_SWRY SHRY ON SHRY.SWRY_DM=SHHJ.TS_RYDM
        INNER JOIN HX_CKTS.CKTS_TY_YWBLXX FSLC ON FSLC.LCSLID=JG.LCSLID
        INNER JOIN HX_CKTS.CKTS_TY_TSSBYWBL_MXB FSHJ ON FSHJ.LCSLID=FSLC.LCSLID AND FSHJ.LCHJ_DM='08'
        INNER JOIN HX_DM_ZDY.DM_GY_SWRY FSRY ON FSRY.SWRY_DM=FSHJ.TS_RYDM
        WHERE YD.LRRQ>=LD_SJCL_M AND TRIM(YD.SDHCBGBH) IS NOT NULL
          AND (REGEXP_LIKE(YD.SDHCRXMJH,SHRY.SWRYXM) OR REGEXP_LIKE(YD.SDHCRXMJH,FSRY.SWRYXM))
        GROUP BY SHLC.UUID,JG.TSSWJG_DM_1,JG.DJXH,JG.SSQ,JG.SBPC,YD.SDHCRXMJH,YD.SDHCBGBH,SHRY.SWRY_DM,SHRY.SWRYXM,FSRY.SWRY_DM,FSRY.SWRYXM,FSLC.FFRQ
       )
       SELECT '2023070502',  -- '综合管理类','GWZY-HCRY-MTS',
              YDCL.UUID,YDCL.TSSWJG_DM_1,YDCL.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,YDCL.JE,YDCL.SE,
              '【申报所属期-批次】'||YDCL.SSQ||'-'||YDCL.SBPC||'；【实地核查报告】'||YDCL.SDHCBGBH||
              '；【实地核查人员】'||YDCL.SDHCRXMJH||'；【审核人员】'||YDCL.SHRYXM||'；【复审人员】'||YDCL.FSRYXM,
              YDCL.FFRQ,SYSDATE
         FROM YDCL
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=YDCL.DJXH;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023070502...');
  COMMIT;

  -- 违规兼任出口退（免）税岗位（代办退税）
  -- 2023070503  事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH YDCL AS (
       SELECT SHLC.UUID,JG.TSSWJG_DM_1,JG.DJXH,JG.SSQ,JG.SBPC,YD.SDHCRXMJH,YD.SDHCBGBH,
              SHRY.SWRY_DM AS SHRYDM,SHRY.SWRYXM AS SHRYXM,FSRY.SWRY_DM AS FSRYDM,FSRY.SWRYXM AS FSRYXM,FSLC.FFRQ,
              SUM(JG.JSJE) AS JE,SUM(JG.TSE) AS SE
         FROM HX_CKTS.CKTS_BL_DB_SHYDCL_JGB YD
        INNER JOIN HX_CKTS.CKTS_SB_DB_TSSB_JGB JG ON JG.DJXH=YD.DJXH AND JG.SSQ=YD.SSQ AND JG.SBPC=YD.SBPC AND JG.SBXH=YD.SBXH AND JG.CKSL>0
        INNER JOIN HX_CKTS.CKTS_TY_YWBLXX SHLC ON SHLC.DJXH=JG.DJXH AND SHLC.SSQ=JG.SSQ AND SHLC.SBPC=JG.SBPC
          AND SHLC.LCSWSX_DM='LCSXA081040001' AND NVL(SHLC.ZFBZ_1,'N')='N' AND NVL(SHLC.HTBZ_1,'N')='N'
        INNER JOIN HX_CKTS.CKTS_TY_TSSBYWBL_MXB SHHJ ON SHHJ.LCSLID=SHLC.LCSLID AND SHHJ.LCHJ_DM='02'
        INNER JOIN HX_DM_ZDY.DM_GY_SWRY SHRY ON SHRY.SWRY_DM=SHHJ.TS_RYDM
        INNER JOIN HX_CKTS.CKTS_TY_YWBLXX FSLC ON FSLC.LCSLID=JG.LCSLID
        INNER JOIN HX_CKTS.CKTS_TY_TSSBYWBL_MXB FSHJ ON FSHJ.LCSLID=FSLC.LCSLID AND FSHJ.LCHJ_DM='08'
        INNER JOIN HX_DM_ZDY.DM_GY_SWRY FSRY ON FSRY.SWRY_DM=FSHJ.TS_RYDM
        WHERE YD.LRRQ>=LD_SJCL_M AND TRIM(YD.SDHCBGBH) IS NOT NULL
          AND (REGEXP_LIKE(YD.SDHCRXMJH,SHRY.SWRYXM) OR REGEXP_LIKE(YD.SDHCRXMJH,FSRY.SWRYXM))
        GROUP BY SHLC.UUID,JG.TSSWJG_DM_1,JG.DJXH,JG.SSQ,JG.SBPC,YD.SDHCRXMJH,YD.SDHCBGBH,SHRY.SWRY_DM,SHRY.SWRYXM,FSRY.SWRY_DM,FSRY.SWRYXM,FSLC.FFRQ
       )
       SELECT '2023070503',  -- '综合管理类','GWZY-HCRY-WZF',
              YDCL.UUID,YDCL.TSSWJG_DM_1,YDCL.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,YDCL.JE,YDCL.SE,
              '【申报所属期-批次】'||YDCL.SSQ||'-'||YDCL.SBPC||'；【实地核查报告】'||YDCL.SDHCBGBH||
              '；【实地核查人员】'||YDCL.SDHCRXMJH||'；【审核人员】'||YDCL.SHRYXM||'；【复审人员】'||YDCL.FSRYXM,
              YDCL.FFRQ,SYSDATE
         FROM YDCL
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=YDCL.DJXH;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023070503...');
  COMMIT;

  -- 违规兼任出口退（免）税岗位（系统维护岗兼岗）
  -- 2023070601  X
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023070601',  -- '综合管理类','GWZY-XTWHG',
              RY.SWRYSF_DM,SUBSTR(RY.SFSWJG_DM,1,7)||'0000',NULL,RY.SWRY_DM,RY.RYSFMC,NULL,NULL,
              C.GWMC||'（兼有其他出口退税岗位）',RY.LRRQ,SYSDATE
         FROM HX_QX.DM_QX_SWRYSF RY
        INNER JOIN HX_QX.QX_JGGW_SWRYSF A ON A.SWRYSF_DM = RY.SWRYSF_DM AND A.YXBZ = 'Y'
        INNER JOIN HX_QX.QX_SWJG_GW B ON B.GWXH = A.GWXH AND B.YXBZ = 'Y' AND B.GW_DM='000000020948'
        INNER JOIN HX_DM_ZDY.DM_QX_GW C ON C.GW_DM = B.GW_DM AND C.YXBZ = 'Y' AND C.GWFL_DM='22'
        WHERE RY.YXBZ='Y' AND RY.SFSWJG_DM<>'13300000000'
          AND EXISTS (SELECT 1
                        FROM HX_QX.DM_QX_SWRYSF RY1
                       INNER JOIN HX_QX.QX_JGGW_SWRYSF A1 ON A1.SWRYSF_DM = RY1.SWRYSF_DM AND A1.YXBZ = 'Y'
                       INNER JOIN HX_QX.QX_SWJG_GW B1 ON B1.GWXH = A1.GWXH AND B1.YXBZ = 'Y' AND B1.GW_DM<>'000000020948'
                       INNER JOIN HX_DM_ZDY.DM_QX_GW C1 ON C1.GW_DM = B1.GW_DM AND C1.YXBZ = 'Y' AND C1.GWFL_DM='22'
                       WHERE RY1.SWRY_DM=RY.SWRY_DM AND RY1.YXBZ='Y');
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023070601...');
  COMMIT;

  -- 出口退（免）税事项长期未办结
  -- 2023070701   事前
  -- 2023070702   事前
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023070701',  -- '申报管理类','JXGL-CQBL-JBSX',
              YW.UUID,YW.TSSWJG_DM_1,YW.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【业务类型】'||SX.LCSWSXMC||'；【流程启动时间】'||TO_CHAR(YW.QDSJ,'YYYYMMDD')||'；【已在途工作日】'||COMPUTE_BLDATE(SYSDATE,YW.QDSJ),
              SYSDATE,SYSDATE
         FROM HX_CKTS.CKTS_TY_YWBLXX YW
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=YW.DJXH
        INNER JOIN HX_DM_QG.DM_GY_LCSWSX SX ON SX.LCSWSX_DM=YW.LCSWSX_DM
        INNER JOIN ZJ_MH.MH_LCXX LC ON LC.LCSLID=YW.LCSLID
        WHERE YW.LCSWSX_DM IN ('LCSXA081031001','LCSXA081033001','LCSXA081036001','LCSXA081036003','LCSXA081037001','LCSXA081001002',
              'LCSXA081043001','LCSXA081044002','LCSXA081045001','LCSXA081050001','LCSXA081051001','LCSXA081051002')
          AND NVL(YW.FFBZ,'N')='N'
          AND NVL(YW.ZFBZ_1,'N')='N'
          AND COMPUTE_BLDATE(SYSDATE,YW.QDSJ)>1
        UNION ALL
       SELECT '2023070702',  -- '申报管理类','JXGL-CQBL-FJBSX',
              YW.UUID,YW.TSSWJG_DM_1,YW.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【业务类型】'||SX.LCSWSXMC||'；【流程启动时间】'||TO_CHAR(YW.QDSJ,'YYYYMMDD')||'；【已在途工作日】'||COMPUTE_BLDATE(SYSDATE,YW.QDSJ),
              SYSDATE,SYSDATE
         FROM HX_CKTS.CKTS_TY_YWBLXX YW
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=YW.DJXH
        INNER JOIN HX_DM_QG.DM_GY_LCSWSX SX ON SX.LCSWSX_DM=YW.LCSWSX_DM
        INNER JOIN ZJ_MH.MH_LCXX LC ON LC.LCSLID=YW.LCSLID
        WHERE YW.LCSWSX_DM IN ('LCSXA081032001','LCSXA081032002','LCSXA081035001','LCSXA081047001','LCSXA081049001','LCSXA081049002',
              'LCSXA081049003','LCSXA081049004')
          AND NVL(YW.FFBZ,'N')='N'
          AND NVL(YW.ZFBZ_1,'N')='N'
          AND COMPUTE_BLDATE(SYSDATE,YW.QDSJ)>5;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023070702...');
  COMMIT;

  -- 未按规定核实四类企业收汇资料
  -- 2023070801  事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       -- 1、免抵退
       SELECT '2023070801',  -- '申报管理类','SHZL-FLGL-D',
              YW.UUID,YW.TSSWJG_DM_1,YW.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,
              (SELECT SUM(SH.CKSHJERMB) FROM HX_CKTS.CKTS_SB_MDT_CKSH_JGB SH WHERE SH.LCSLID=YW.LCSLID),NULL,
              '【申报所属期-批次】'||YW.SSQ||'-'||YW.SBPC||'；【启动时间】'||TO_CHAR(YW.QDSJ,'YYYYMMDD')||
              '；【申报日分类管理等级】'||YW.CKQYGLLB_DM||'；【申报收汇笔数】'||
              (SELECT COUNT(SH.UUID) FROM HX_CKTS.CKTS_SB_MDT_CKSH_JGB SH WHERE SH.LCSLID=YW.LCSLID),
              YW.QDSJ,SYSDATE
         FROM HX_CKTS.CKTS_TY_YWBLXX YW
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=YW.DJXH
        WHERE YW.QDSJ>=LD_SJCL_M AND YW.CKQYGLLB_DM='D' --申报的时候为四类企业
          AND EXISTS(SELECT 1 FROM HX_CKTS.CKTS_SB_MDT_CKSH_JGB SH WHERE SH.LCSLID=YW.LCSLID)
          AND NOT EXISTS (SELECT 1 FROM HX_CKTS.CKTS_SB_MDT_CKSHCC_GCB CC WHERE CC.DJXH=YW.DJXH AND CC.SSQ=YW.SSQ
                           UNION ALL
                          SELECT 1 FROM HX_CKTS.CKTS_SB_MDT_CKSHCC_JGB CC WHERE CC.DJXH=YW.DJXH AND CC.SSQ=YW.SSQ)
        UNION ALL
       -- 2、免退税
       SELECT '2023070801',  -- '申报管理类','SHZL-FLGL-D',
              YW.UUID,YW.TSSWJG_DM_1,YW.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,
              (SELECT SUM(SH.CKSHJERMB) FROM HX_CKTS.CKTS_SB_MTS_CKSH_JGB SH WHERE SH.LCSLID=YW.LCSLID),NULL,
              '【申报所属期-批次】'||YW.SSQ||'-'||YW.SBPC||'；【启动时间】'||TO_CHAR(YW.QDSJ,'YYYYMMDD')||
              '；【申报日分类管理等级】'||YW.CKQYGLLB_DM||'；【申报收汇笔数】'||
              (SELECT COUNT(SH.UUID) FROM HX_CKTS.CKTS_SB_MTS_CKSH_JGB SH WHERE SH.LCSLID=YW.LCSLID),
              YW.QDSJ,SYSDATE
         FROM HX_CKTS.CKTS_TY_YWBLXX YW
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=YW.DJXH
        WHERE YW.QDSJ>=LD_SJCL_M AND YW.CKQYGLLB_DM='D' --申报的时候为四类企业
          AND EXISTS(SELECT 1 FROM HX_CKTS.CKTS_SB_MTS_CKSH_JGB SH WHERE SH.LCSLID=YW.LCSLID)
          AND NOT EXISTS (SELECT 1 FROM HX_CKTS.CKTS_SB_MTS_CKSHCC_GCB CC WHERE CC.DJXH=YW.DJXH AND CC.SSQ=YW.SSQ AND CC.SBPC=YW.SBPC
                           UNION ALL
                          SELECT 1 FROM HX_CKTS.CKTS_SB_MTS_CKSHCC_JGB CC WHERE CC.DJXH=YW.DJXH AND CC.SSQ=YW.SSQ AND CC.SBPC=YW.SBPC)
        UNION ALL
       -- 3、代办退税
       SELECT '2023070801',  -- '申报管理类','SHZL-FLGL-D',
              YW.UUID,YW.TSSWJG_DM_1,YW.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,
              (SELECT SUM(SH.CKSHJERMB) FROM HX_CKTS.CKTS_SB_DB_CKHWSH_JGB SH WHERE SH.LCSLID=YW.LCSLID),NULL,
              '【申报所属期-批次】'||YW.SSQ||'-'||YW.SBPC||'；【启动时间】'||TO_CHAR(YW.QDSJ,'YYYYMMDD')||
              '；【申报日分类管理等级】'||YW.CKQYGLLB_DM||'；【申报收汇笔数】'||
              (SELECT COUNT(SH.UUID) FROM HX_CKTS.CKTS_SB_DB_CKHWSH_JGB SH WHERE SH.LCSLID=YW.LCSLID),
              YW.QDSJ,SYSDATE
         FROM HX_CKTS.CKTS_TY_YWBLXX YW
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=YW.DJXH
        WHERE YW.QDSJ>=LD_SJCL_M AND YW.CKQYGLLB_DM='D' --申报的时候为四类企业
          AND EXISTS(SELECT 1 FROM HX_CKTS.CKTS_SB_DB_CKHWSH_JGB SH WHERE SH.LCSLID=YW.LCSLID)
          AND NOT EXISTS (SELECT 1 FROM HX_CKTS.CKTS_SB_DB_CKHWSHCC_GCB CC WHERE CC.DJXH=YW.DJXH AND CC.SSQ=YW.SSQ AND CC.SBPC=YW.SBPC
                           UNION ALL
                          SELECT 1 FROM HX_CKTS.CKTS_SB_DB_CKHWSHCC_JGB CC WHERE CC.DJXH=YW.DJXH AND CC.SSQ=YW.SSQ AND CC.SBPC=YW.SBPC);
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023070801...');
  COMMIT;

  -- 未按规定核实往年出口货物收汇资料
  -- 2023070901  事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       -- 1、免抵退
       SELECT '2023070901',  -- '申报管理类','SHZL-FLGL-D',
              YW.UUID,YW.TSSWJG_DM_1,YW.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,
              (SELECT SUM(SH.CKSHJERMB) FROM HX_CKTS.CKTS_SB_MDT_CKSH_JGB SH WHERE SH.LCSLID=YW.LCSLID),NULL,
              '【申报所属期-批次】'||YW.SSQ||'-'||YW.SBPC||'；【启动时间】'||TO_CHAR(YW.QDSJ,'YYYYMMDD')||
              '；【申报日分类管理等级】'||YW.CKQYGLLB_DM||'；【申报收汇笔数】'||
              (SELECT COUNT(SH.UUID) FROM HX_CKTS.CKTS_SB_MDT_CKSH_JGB SH WHERE SH.LCSLID=YW.LCSLID),
              YW.QDSJ,SYSDATE
         FROM HX_CKTS.CKTS_TY_YWBLXX YW
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=YW.DJXH
        WHERE YW.QDSJ>=LD_SJCL_M AND YW.CKQYGLLB_DM<>'D' --申报的时候非四类企业
          AND EXISTS(SELECT 1 FROM HX_CKTS.CKTS_SB_MDT_CKSH_JGB SH WHERE SH.LCSLID=YW.LCSLID)
          AND NOT EXISTS (SELECT 1 FROM HX_CKTS.CKTS_SB_MDT_CKSHCC_GCB CC WHERE CC.DJXH=YW.DJXH AND CC.SSQ=YW.SSQ
                           UNION ALL
                          SELECT 1 FROM HX_CKTS.CKTS_SB_MDT_CKSHCC_JGB CC WHERE CC.DJXH=YW.DJXH AND CC.SSQ=YW.SSQ)
        UNION ALL
       -- 2、免退税
       SELECT '2023070901',  -- '申报管理类','SHZL-FLGL-D',
              YW.UUID,YW.TSSWJG_DM_1,YW.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,
              (SELECT SUM(SH.CKSHJERMB) FROM HX_CKTS.CKTS_SB_MTS_CKSH_JGB SH WHERE SH.LCSLID=YW.LCSLID),NULL,
              '【申报所属期-批次】'||YW.SSQ||'-'||YW.SBPC||'；【启动时间】'||TO_CHAR(YW.QDSJ,'YYYYMMDD')||
              '；【申报日分类管理等级】'||YW.CKQYGLLB_DM||'；【申报收汇笔数】'||
              (SELECT COUNT(SH.UUID) FROM HX_CKTS.CKTS_SB_MTS_CKSH_JGB SH WHERE SH.LCSLID=YW.LCSLID),
              YW.QDSJ,SYSDATE
         FROM HX_CKTS.CKTS_TY_YWBLXX YW
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=YW.DJXH
        WHERE YW.QDSJ>=LD_SJCL_M AND YW.CKQYGLLB_DM<>'D' --申报的时候非四类企业
          AND EXISTS(SELECT 1 FROM HX_CKTS.CKTS_SB_MTS_CKSH_JGB SH WHERE SH.LCSLID=YW.LCSLID)
          AND NOT EXISTS (SELECT 1 FROM HX_CKTS.CKTS_SB_MTS_CKSHCC_GCB CC WHERE CC.DJXH=YW.DJXH AND CC.SSQ=YW.SSQ AND CC.SBPC=YW.SBPC
                           UNION ALL
                          SELECT 1 FROM HX_CKTS.CKTS_SB_MTS_CKSHCC_JGB CC WHERE CC.DJXH=YW.DJXH AND CC.SSQ=YW.SSQ AND CC.SBPC=YW.SBPC)
        UNION ALL
       -- 3、代办退税
       SELECT '2023070901',  -- '申报管理类','SHZL-FLGL-D',
              YW.UUID,YW.TSSWJG_DM_1,YW.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,
              (SELECT SUM(SH.CKSHJERMB) FROM HX_CKTS.CKTS_SB_DB_CKHWSH_JGB SH WHERE SH.LCSLID=YW.LCSLID),NULL,
              '【申报所属期-批次】'||YW.SSQ||'-'||YW.SBPC||'；【启动时间】'||TO_CHAR(YW.QDSJ,'YYYYMMDD')||
              '；【申报日分类管理等级】'||YW.CKQYGLLB_DM||'；【申报收汇笔数】'||
              (SELECT COUNT(SH.UUID) FROM HX_CKTS.CKTS_SB_DB_CKHWSH_JGB SH WHERE SH.LCSLID=YW.LCSLID),
              YW.QDSJ,SYSDATE
         FROM HX_CKTS.CKTS_TY_YWBLXX YW
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=YW.DJXH
        WHERE YW.QDSJ>=LD_SJCL_M AND YW.CKQYGLLB_DM<>'D' --申报的时候非四类企业
          AND EXISTS(SELECT 1 FROM HX_CKTS.CKTS_SB_DB_CKHWSH_JGB SH WHERE SH.LCSLID=YW.LCSLID)
          AND NOT EXISTS (SELECT 1 FROM HX_CKTS.CKTS_SB_DB_CKHWSHCC_GCB CC WHERE CC.DJXH=YW.DJXH AND CC.SSQ=YW.SSQ AND CC.SBPC=YW.SBPC
                           UNION ALL
                          SELECT 1 FROM HX_CKTS.CKTS_SB_DB_CKHWSHCC_JGB CC WHERE CC.DJXH=YW.DJXH AND CC.SSQ=YW.SSQ AND CC.SBPC=YW.SBPC);
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023070901...');
  COMMIT;

  -- 未按规定对四类生产企业年度首次申报开展评估
  -- 2023071001  X
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023071001',  -- '申报管理类','SDHC-FLGL-D-NDSCSB',
              YW.UUID,YW.TSSWJG_DM_1,YW.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,MDT.CKXSERMB,MDT.MDTSE,
              '【申报所属期】'||YW.SSQ||'；【启动时间】'||TO_CHAR(YW.QDSJ,'YYYYMMDD')||'；【申报日分类管理等级】'||YW.CKQYGLLB_DM,
              YW.QDSJ,SYSDATE
         FROM HX_CKTS.CKTS_TY_YWBLXX YW
        INNER JOIN HX_CKTS.CKTS_SB_MDT_SBHZ_JGB MDT ON MDT.LCSLID=YW.LCSLID AND MDT.CKXSEMY>0 --剔除零申报
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=YW.DJXH
        WHERE YW.LCSWSX_DM='LCSXA081038001' --免抵退申报业务
          AND YW.CKQYGLLB_DM='D' --四类企业
          AND YW.QDSJ>=LD_SJCL_M
          AND YW.FFBZ='Y'
          AND NOT EXISTS (SELECT 1 --当年度首次申报
                            FROM HX_CKTS.CKTS_TY_YWBLXX S
                           INNER JOIN HX_CKTS.CKTS_SB_MDT_SBHZ_JGB SBHZ ON SBHZ.LCSLID=S.LCSLID AND SBHZ.CKXSEMY>0
                           WHERE S.DJXH=YW.DJXH AND S.LCSWSX_DM='LCSXA081038001' AND S.CKQYGLLB_DM='D' AND S.FFBZ='Y'
                             AND S.QDSJ>=TRUNC(YW.QDSJ,'YY') AND S.QDSJ<YW.QDSJ)
          AND NOT EXISTS (SELECT 1
                            FROM HX_CKTS.CKTS_SDHC_SDHCBG_JGB HC
                           WHERE HC.DJXH=YW.DJXH AND REGEXP_LIKE(HC.HCYYSM,'01|13|20') AND HC.LRRQ>=TRUNC(YW.QDSJ,'YY') AND HC.LRRQ<=YW.FFRQ);
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023071001...');
  COMMIT;

  -- 调查评估岗违规办理出口退（免）税
  -- 审核疑点处理结果表
  -- 2023071101   事前
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023071101',  -- '风险管理类','PG-YJGHQY',
              S.UUID,S.TSSWJG_DM_1,S.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,S.YTSE_1,
              '【申报所属期-批次】'||S.SSQ||'-'||S.SBPC||'；【疑点编号-内容】'||T.YDBH||'-'||T.YDNR
              ||'；【自查表处理意见】'||S.ZCBHCCLYJLX_DM||'；【复函处理意见】'||S.FHCLYJLX_DM||'；【实地核查处理意见】'||S.SDHCCLYJLX_DM
              ||'；【其他处理意见】'||S.QTHCCLYJLX_DM||'；【综合处理意见】'||S.ZHSHCLYJLX_DM,
              T.LRRQ,SYSDATE
         FROM HX_CKTS.CKTS_BL_MTS_SHYD_JGB T
        INNER JOIN HX_CKTS.CKTS_BL_MTS_SHYDCL_JGB S ON S.DJXH=T.DJXH AND S.SSQ=T.SSQ AND S.SBPC=T.SBPC AND S.SBXH=T.SBXH
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
        WHERE T.YDBH IN ('A9137','A9138','A0273','A0274')
          AND T.LRRQ>=LD_SJCL_M
          AND S.ZHSHCLYJLX_DM<>'6';
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023071101...');
  COMMIT;

  -- 应二次发函而未按规定进行发函
  -- 2023071201   X  	与2023051701重复

  -- 收到复函逾期办理
  -- 2023071301   事前
/*  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023071301',  -- '函调管理类','HD-CL-YQBLTS',
              H1.FUHXXBUUID,H1.FAHDSWJG_DM,F1.GHFDJXH,F1.GHQYNSRSBH,F1.GHFQYMC,F1.JEHJ,F1.SEHJ,
              '【核实函编号】'||H1.HSHBH||'；【复函编号】'||H1.FHBH||'；【回函类型】'||H1.FHLX_DM
              ||'；【回函日期】'||TO_CHAR(H1.QFRQ,'YYYYMMDD')||'；【回函处理日期】'||TO_CHAR(H1.FHCLRQ,'YYYYMMDD'),
              H1.QFRQ,SYSDATE
         FROM HX_ZH.ZH_CKTS_FUHXXB H1
        INNER JOIN HX_ZH.ZH_CKTS_FHXXB F1 ON F1.FHXXBUUID=H1.FHXXBUUID
        WHERE H1.FAHDSWJG_DM LIKE '133%' AND H1.FAHDSWJG_DM NOT LIKE '13302%'
          AND H1.QFRQ>=LD_SJCL_M
          AND NVL(H1.ZFBZ_1,'N')='N'
          AND NVL(H1.FHLX_DM,'3')<>'3'
          AND TRIM(H1.FHBH) IS NOT NULL
          AND H1.DZBZDSZL_DM='BDA1320283' --非向上游发函的回函
          AND COMPUTE_BLDATE(TRUNC(NVL(H1.FHCLRQ,SYSDATE)),TRUNC(H1.QFRQ))>=15;
  COMMIT;
*/
  -- 违规回复“正常业务”复函（存在向上游供货商的核实函未收到正常业务复函）
  -- 2023071401  事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ,LCSLID)
         WITH
         SYFA AS ( --本地（向上游供货企业）发函与（下游出口企业发的）上游核实函的对应关系(N:1)
       SELECT DISTINCT FA.WSBH,FA.SYHSHBH,FA.FAHDSWJG_DM,FA.GHFDJXH,FA.GHQYNSRSBH,FA.GHFQYMC,FA.JEHJ,FA.SEHJ
         FROM HX_ZH.ZH_CKTS_FHXXB FA
        WHERE FA.FAHDSWJG_DM LIKE '133%' AND FA.FAHDSWJG_DM NOT LIKE '13302%'
          AND FA.DZBZDSZL_DM='BDA1320288' AND TRIM(FA.SYHSHBH) IS NOT NULL
          AND NVL(FA.ZFBZ_1,'N')<>'Y' AND FA.QFRQ IS NOT NULL
       ),
         FU_1 AS ( --对（下游出口企业发的）上游核实函的最新一次复函为正常函
       SELECT FUHXXBUUID,SYHSHBH,FHBH,FAHDSWJG_DM,FAHDSWJGMC,QFRQ,FHLX_DM
         FROM (SELECT SYFA.SYHSHBH,FU.*,
                      ROW_NUMBER() OVER(PARTITION BY FU.FHXXBUUID ORDER BY FU.QFRQ DESC,FU.FHCS DESC NULLS LAST) RN
                 FROM SYFA
                INNER JOIN HX_ZH.ZH_CKTS_FUHXXB FU ON FU.HSHBH=SYFA.SYHSHBH
                WHERE NVL(FU.ZFBZ_1,'N')<>'Y'
                  AND FU.QFRQ>=LD_SJCL_M)
        WHERE RN=1 AND FHLX_DM='1'
       ),
         SYFU AS ( --针对本地（向上游供货企业）发函，按上游供货企业取最后一次回函
       SELECT WSBH,FUHXXBUUID,FHBH,FUHSWJG_DM,FUHSWJGMC,QFRQ,FHLX_DM
         FROM (SELECT SYFA.WSBH,FU.FUHXXBUUID,FU.FHBH,FU.FUHSWJG_DM,FU.FUHSWJGMC,FU.QFRQ,FU.FHLX_DM,
                      ROW_NUMBER() OVER(PARTITION BY SYFA.WSBH,FU.GHQYNSRSBH_1 ORDER BY FU.QFRQ DESC,FU.FHCS DESC NULLS LAST) RN
                 FROM SYFA
                 LEFT JOIN HX_ZH.ZH_CKTS_FUHXXB FU ON FU.HSHBH=SYFA.WSBH
                WHERE NVL(FU.ZFBZ_1,'N')<>'Y'
                  AND FU.QFRQ IS NOT NULL)
        WHERE RN=1
       )
       SELECT '2023071401',  -- '函调管理类','HD-FUH-GBSYFUHJG',
              FU_1.FUHXXBUUID,SYFA.FAHDSWJG_DM,SYFA.GHFDJXH,SYFA.GHQYNSRSBH,SYFA.GHFQYMC,SYFA.JEHJ,SYFA.SEHJ,
              '【上游核实函】'||SYFA.SYHSHBH||'；【复函编号】'||FU_1.FHBH||'；【回函类型】'||FU_1.FHLX_DM||
              '；【回函日期】'||TO_CHAR(FU_1.QFRQ,'YYYYMMDD')||'；【发函税务机关】'||FU_1.FAHDSWJG_DM||'-'||FU_1.FAHDSWJGMC||
              '；【下游核实函】'||SYFA.WSBH||'；【复函编号】'||SYFU.FHBH||'；【回函类型】'||SYFU.FHLX_DM||
              '；【回函日期】'||TO_CHAR(SYFU.QFRQ,'YYYYMMDD')||'；【回函税务机关】'||SYFU.FUHSWJG_DM||'-'||SYFU.FUHSWJGMC,
              FU_1.QFRQ,SYSDATE,SYFU.FUHXXBUUID
         FROM  FU_1
        INNER JOIN SYFA ON SYFA.SYHSHBH=FU_1.SYHSHBH
         LEFT JOIN SYFU ON SYFU.WSBH=SYFA.WSBH
        WHERE NVL(SYFU.FHLX_DM,'3') NOT IN ('1','5') -- 上游供货企业最后一次回函不是正常函或非本地管辖（需要再次复函，取本地管辖的
           OR NVL(SYFU.QFRQ,FU_1.QFRQ+1)>FU_1.QFRQ;  -- 或，上游供货企业最后一次回函签发时间晚于复函签发时间
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023071401...');
  COMMIT;

  -- 未按规定出具复函处理意见
  -- 2023071501  事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023071501',  -- '函调管理类','HD-CL-GBFUHJG',
              H1.FUHXXBUUID,F1.FAHDSWJG_DM,F1.GHFDJXH,F1.GHQYNSRSBH,F1.GHFQYMC,F1.JEHJ,F1.SEHJ,
              '【核实函编号】'||H1.HSHBH||'；【复函编号】'||H1.FHBH||
              '；【回函日期】'||TO_CHAR(H1.QFRQ,'YYYYMMDD')||'；【回函类型】'||H1.FHLX_DM||
              '；【回函处理日期】'||TO_CHAR(H1.FHCLRQ,'YYYYMMDD')||'；【回函处理意见】'||H1.FHCLYJ_DM||'；【处理意见说明】'||H1.FHCLYJSM,
              H1.FHCLRQ,SYSDATE
         FROM HX_ZH.ZH_CKTS_FUHXXB H1
        INNER JOIN HX_ZH.ZH_CKTS_FHXXB F1 ON F1.FHXXBUUID=H1.FHXXBUUID
        WHERE H1.FAHDSWJG_DM LIKE '133%' AND H1.FAHDSWJG_DM NOT LIKE '13302%'
          AND H1.DZBZDSZL_DM='BDA1320283'
          AND H1.FHLX_DM IN ('2','3','4','7','8')
          AND H1.FHCLYJ_DM ='1'
          AND NVL(H1.ZFBZ_1,'N')='N'
          AND TRIM(H1.FHBH) IS NOT NULL
          AND H1.FHCLRQ>=LD_SJCL_M
          AND NOT EXISTS (SELECT 1
                            FROM HX_ZH.ZH_CKTS_FUHXXB H2
                           WHERE H2.FHXXBUUID=H1.FHXXBUUID AND NVL(H2.ZFBZ_1,'N')='N' AND H2.FHLX_DM='1' AND H2.FHCS>H1.FHCS);
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023071501...');
  COMMIT;

  -- 未按规定对“不予退税”复函涉及税款进行处理
  -- 回函未满15个工作日的数据
  -- 2023071601   事前
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH
         FU_1 AS ( --1.最近一次“复函类型”为“存在不予退（免）税发票”，调查函类型非”向上游核实函”；
       SELECT FHXXBUUID,WSBH,FAHDSWJG_DM,FAHRQ,GHFDJXH,GHQYNSRSBH,GHFQYMC,GHQYNSRSBH_1,JEHJ,SEHJ,FHBH,FUHRQ,FHLX_DM,FHCLYJ_DM
         FROM (SELECT --发函表UUID,发函编号,发函机关代码,发函机关名称,签发日期,出口企业及供货企业,涉及出口退税额
                      FA.FHXXBUUID,FA.WSBH,FA.FAHDSWJG_DM,FA.QFRQ AS FAHRQ,FA.GHFDJXH,FA.GHQYNSRSBH,FA.GHFQYMC,FA.GHQYNSRSBH_1,FA.JEHJ,FA.SEHJ,
                      --复函编号,签发日期,复函类型代码,复函处理意见代码
                      FU.FHBH,FU.QFRQ AS FUHRQ,FU.FHLX_DM,FU.FHCLYJ_DM,
                      --复函次数排倒序，空最后
                      ROW_NUMBER() OVER (PARTITION BY FU.FHXXBUUID ORDER BY FU.FHCS DESC NULLS LAST) RN_FUH
                 FROM HX_ZH.ZH_CKTS_FHXXB FA
                INNER JOIN HX_ZH.ZH_CKTS_FUHXXB FU ON FA.FHXXBUUID=FU.FHXXBUUID
                WHERE FA.FAHDSWJG_DM LIKE '133%' AND FA.FAHDSWJG_DM NOT LIKE '13302%' --发函地税局：浙江非宁波
                  AND FA.DZBZDSZL_DM='BDA1320284' --非上游核实函, 上游核实函为BDA1320288
                  AND FU.QFRQ>=LD_SJCL_M --复函签发时间
                  AND COMPUTE_BLJZDATE('C',FU.QFRQ)<TRUNC(SYSDATE)
                  AND NVL(FA.ZFBZ_1,'N')='N' --发函未作废
                  AND NVL(FU.ZFBZ_1,'N')='N' --回函未作废
              ) HD
        WHERE RN_FUH=1 --最后一次复函
          AND FHLX_DM='2' --回函意见为“不予退税回函”
          AND NVL(FHCLYJ_DM,'0')<>'1' --剔除回函处理意见为准予退税的
       ),
           FP AS ( --2.核实函涉及发票办理退税（税额核准）时间在核实函签发日期之前；
       SELECT FHXXBUUID,WSBH,FAHDSWJG_DM,FAHRQ,GHFDJXH,GHQYNSRSBH,GHFQYMC,GHQYNSRSBH_1,JEHJ,SEHJ,FHBH,FUHRQ,FHLX_DM,FHCLYJ_DM,SUM(TSE) AS TSE
         FROM (SELECT FU_1.*,TSJH.TSE,ROW_NUMBER() OVER (PARTITION BY TSJH.UUID ORDER BY FU_1.FHXXBUUID) RN_JH
                 FROM FU_1
                INNER JOIN HX_ZH.ZH_CKTS_HDFPQD QD ON QD.FHXXBUUID=FU_1.FHXXBUUID AND NVL(QD.ZFBZ_1,'N')='N'
                INNER JOIN HX_CKTS.CKTS_SB_MTS_TSJH_JGB TSJH ON TSJH.DJXH=FU_1.GHFDJXH AND TSJH.JHPZH=QD.ZZSZYFPDMHM
                INNER JOIN HX_CKTS.CKTS_SB_MTS_TSSB_JGB TSSB ON TSSB.DJXH=TSJH.DJXH AND TSSB.GLH=TSJH.GLH
                INNER JOIN HX_CKTS.CKTS_TY_SEHZB SE ON SE.LCSLID=TSJH.LCSLID
                WHERE SE.SEHZRQ<FU_1.FAHRQ --税额核准日期小于发函签发日期，即退税后发函的不予退税复函，应追回
                  AND NVL(TSJH.BYBLBZ,'N')='N' AND NVL(TSJH.BYTSBZ,'N')='N' --对应发票进货明细非不予办理，非不予退税
                  AND NVL(TSSB.BYBLBZ,'N')='N' AND NVL(TSSB.BYTSBZ,'N')='N' --对应发票出口明细非不予办理，非不予退税
              ) MX
        WHERE RN_JH=1 --当一张发票对应多个关联号时，ZH_CKTS_HDFPQD有可能出现多次，需要去重
        GROUP BY FHXXBUUID,WSBH,FAHDSWJG_DM,FAHRQ,GHFDJXH,GHQYNSRSBH,GHFQYMC,GHQYNSRSBH_1,JEHJ,SEHJ,FHBH,FUHRQ,FHLX_DM,FHCLYJ_DM
       )
       --3.应追回金额小于核实函涉及税额合计一元以上.
       SELECT '2023071601',  -- '函调管理类','HD-CL-BYTS-YZH',
              FP.FHXXBUUID,FP.FAHDSWJG_DM,FP.GHFDJXH,FP.GHQYNSRSBH,FP.GHFQYMC,FP.JEHJ,FP.SEHJ,
              '【核实函编号】'||FP.WSBH||'；【发函日期】'||TO_CHAR(FP.FAHRQ,'YYYYMMDD')||'；【供货方】'||FP.GHQYNSRSBH_1||
              '；【回函编号】'||FP.FHBH||'；【回函日期】'||TO_CHAR(FP.FUHRQ,'YYYYMMDD')||'；【回函类型】'||FP.FHLX_DM||'；【回函处理意见】'||FP.FHCLYJ_DM||
              '；【发函前已退税税额(不包括并库前数据)】'||FP.TSE||'；【回函后追回税款次数】'||COUNT(YZH.UUID)||'；【税额】'||
              SUM(CASE WHEN YZH.YZHTMSK=0 THEN YZH.YTMSK ELSE YZH.YZHTMSK END),MAX(YZH.LRRQ),SYSDATE
         FROM FP
         LEFT JOIN HX_CKTS.CKTS_TK_YZHYTSKMXB_JGB YZH ON YZH.DJXH=FP.GHFDJXH AND YZH.LRRQ>FP.FUHRQ
        GROUP BY FHXXBUUID,WSBH,FAHDSWJG_DM,FAHRQ,GHFDJXH,GHQYNSRSBH,GHFQYMC,GHQYNSRSBH_1,JEHJ,SEHJ,FHBH,FUHRQ,FHLX_DM,FHCLYJ_DM,TSE
       HAVING NVL(SUM(CASE WHEN YZH.YZHTMSK=0 THEN YZH.YTMSK ELSE YZH.YZHTMSK END),0)<FP.TSE-1;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023071601...');
  COMMIT;

  -- 应暂扣未暂扣出口退税款
  -- >5个工作日
  -- 2023071701   事前
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023071701',  -- '风险管理类','JC-YZK-CKTSK',
              T.SSSXNBYSJFKBUUID,DJ.ZGSWJ_DM,DJ.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,SUM(SE.SEHZZZSTSE+SE.SEHZXFSTSE+SE.SEHZMDSE),
              '【审批日期】'||TO_CHAR(T.ZSRQ_3,'YYYYMMDD')||'；【移送后税额核准次数】'||COUNT(1)||
              '；【移送后核准税额】'||SUM(SE.SEHZZZSTSE+SE.SEHZXFSTSE+SE.SEHZMDSE)||'；【首次核准日期】'||TO_CHAR(MIN(SE.SEHZRQ),'YYYYMMDD'),
              SYSDATE,SYSDATE
         FROM HX_ZH.ZH_SSSXNBYSJFKB T
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
        INNER JOIN HX_CKTS.CKTS_TY_SEHZB SE ON SE.DJXH=T.DJXH AND SE.SEHZRQ>T.ZSRQ_3
        WHERE T.NBYSSSSXLX_DM LIKE '%03%' AND NVL(t.ZFBZ_1,'N')<>'Y'
          AND T.LRRQ>=LD_SJCL_M
          AND COMPUTE_BLJZDATE('A',T.LRRQ)<TRUNC(SYSDATE)
          AND EXISTS (SELECT 1 FROM HX_CKTS.CKTS_TY_SEHZB WHERE DJXH=T.DJXH AND SEHZRQ>T.ZSRQ_3)
          AND NOT EXISTS (SELECT 1 FROM HX_CKTS.CKTS_TS_ZKCKTSYWCLB_JGB WHERE DJXH=T.DJXH AND ZKQSSJ>T.ZSRQ_3)
        GROUP BY T.SSSXNBYSJFKBUUID,DJ.ZGSWJ_DM,DJ.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,TO_CHAR(T.ZSRQ_3,'YYYYMMDD');
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023071701...');
  COMMIT;

  -- 应解除未解除暂扣出口退税款
  -- >5个工作日
  -- 2023071801   事前
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH JAQJBYTS AS (
       SELECT AJ.JCAJXXUUID,CKQY.TSSWJG_DM_1,CKQY.DJXH,AJ.NSRSBH,AJ.NSRMC,AJ.JCAJBH,AJ.AJMC,AJ.LARQ,AJ.JARQ,TO_CHAR(SUBSTR(JL.JCFWHNR,1,1600)) AS JCFWHNR,
              (SELECT NVL(SUM(T.BYHZZZSTSE),0) FROM HX_CKTS.CKTS_TY_SEHZB T WHERE T.DJXH=AJ.DJXH AND T.SEHZRQ>=AJ.LARQ AND T.SEHZRQ<=AJ.JARQ) AS BYHZZZSTSE,
              (SELECT NVL(SUM(T.YTSE_1),0) FROM HX_CKTS.CKTS_BL_MTS_SHYDCL_JGB T WHERE T.DJXH=AJ.DJXH AND T.XGRQ>=AJ.LARQ AND T.XGRQ<=AJ.JARQ AND T.ZHSHCLYJLX_DM='6'
                UNION
               SELECT NVL(SUM(T.MDTSE),0) FROM HX_CKTS.CKTS_BL_MDT_SHYDCL_JGB T WHERE T.DJXH=AJ.DJXH AND T.XGRQ>=AJ.LARQ AND T.XGRQ<=AJ.JARQ AND T.ZHSHCLYJLX_DM='6') AS ZBBLTSE
         FROM HX_CKTS.CKTS_BA_BAXX_JGB CKQY
        INNER JOIN HX_JC.JC_AJXX AJ ON AJ.DJXH=CKQY.DJXH
        INNER JOIN HX_JC.JC_SWJCJL JL ON JL.JCAJXXUUID=AJ.JCAJXXUUID
        WHERE NVL(CKQY.BACHBZ,'N')='N' AND AJ.AJJCZT_DM LIKE '5%'
          AND AJ.JARQ>=LD_SJCL_M
          AND COMPUTE_BLJZDATE('A',AJ.JARQ)<TRUNC(SYSDATE)
          AND JL.JCFWHNR LIKE '%未发现%税收违法问题%')
       SELECT '2023071801',  -- '风险管理类','JC-YJC-CKTSK',
              JCAJXXUUID,TSSWJG_DM_1,DJXH,NSRSBH,NSRMC,NULL,BYHZZZSTSE + ZBBLTSE,
              '【稽查案件编号】'||JCAJBH||'；【立案日期】'||TO_CHAR(LARQ,'YYYYMMDD')||'；【结案日期】'||TO_CHAR(JARQ,'YYYYMMDD')||
              '；【期间不予核准税额】'||BYHZZZSTSE||'；【暂不办理税额】'||ZBBLTSE||'；【结案意见】'||JCFWHNR,
              JARQ,SYSDATE
         FROM JAQJBYTS
        WHERE BYHZZZSTSE + ZBBLTSE>0;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023071801...');
  COMMIT;

  -- 应暂停未暂停实行先退税后核销办法
  -- 2023071901  X
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH AYGLTZ AS ( --出口企业案源管理台账
       SELECT UUID,TSSWJG_DM_1,DJXH,NVL(LARQ,NVL(XSYSQSRQ,NVL(XSYSJCRQ,LRRQ))) AS LARQ,JARQ
         FROM HX_CKTS.CKTS_QT_CKQYAYGLTZ_JGB A
        WHERE A.LRRQ>=LD_SJCL_M
        UNION ALL
       SELECT UUID,TSSWJG_DM_1,DJXH,NVL(LARQ,NVL(XSYSQSRQ,NVL(XSYSJCRQ,LRRQ))) AS LARQ,JARQ
         FROM HX_CKTS.CKTS_QT_CKQYAYGLTZ_GCB B
        WHERE B.LRRQ>=LD_SJCL_M
       )
       SELECT '2023071901',  -- '申报管理类','JC-YZT-XTHH',
              AYGLTZ.UUID,AYGLTZ.TSSWJG_DM_1,AYGLTZ.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH) AS NSRSBH,DJ.NSRMC,NULL,NULL,
              '【先退后核合同号】'||XTHH.CKHTH||'；【投产日期】'||TO_CHAR(XTHH.TCRQ,'YYYYMMDD')||'；【完工日期】'||TO_CHAR(XTHH.WGRQ,'YYYYMMDD')||
              '；【案源管理台账立案/线索移交/录入日期】'||TO_CHAR(AYGLTZ.LARQ,'YYYYMMDD'),
              AYGLTZ.LARQ,SYSDATE
         FROM AYGLTZ
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=AYGLTZ.DJXH
        INNER JOIN HX_CKTS.CKTS_BA_XTHHZG_JGB XTHH --先退税后核销资格期间立案
          ON XTHH.DJXH=AYGLTZ.DJXH AND NVL(XTHH.ZFBZ_1,'N')='N' AND XTHH.TCRQ<AYGLTZ.LARQ AND XTHH.WGRQ>AYGLTZ.LARQ
       WHERE NOT EXISTS (SELECT 1 --立案以后不存在暂停实行先退税后核销
                           FROM HX_CKTS.CKTS_QT_SWSXQDB_JGB ZT
                          WHERE ZT.DJXH=AYGLTZ.DJXH AND ZT.LCSWSX_DM='LCSXA082035001' AND ZT.QDSX_DM='01' AND ZT.LRRQ>AYGLTZ.LARQ);
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023071901...');
  COMMIT;

  -- 应恢复未恢复实行先退税后核销办法
  -- 2023072001  X
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH AYGLTZ AS ( --出口企业案源管理台账，已结案无处罚
       SELECT UUID,TSSWJG_DM_1,DJXH,NVL(LARQ,NVL(XSYSQSRQ,NVL(XSYSJCRQ,LRRQ))) AS LARQ,JARQ
         FROM HX_CKTS.CKTS_QT_CKQYAYGLTZ_JGB A
        WHERE A.JARQ>=LD_SJCL_M AND TRIM(A.CKQYAYGLTZCFYY_DM) IS NULL
        UNION ALL
       SELECT UUID,TSSWJG_DM_1,DJXH,NVL(LARQ,NVL(XSYSQSRQ,NVL(XSYSJCRQ,LRRQ))) AS LARQ,JARQ
         FROM HX_CKTS.CKTS_QT_CKQYAYGLTZ_GCB B
        WHERE B.JARQ>=LD_SJCL_M AND TRIM(B.CKQYAYGLTZCFYY_DM) IS NULL
       )
       SELECT '2023072001',  -- '风险管理类','JC-YHF-XTHH',
              AYGLTZ.UUID,AYGLTZ.TSSWJG_DM_1,AYGLTZ.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH) AS NSRSBH,DJ.NSRMC,NULL,NULL,
              '【先退后核合同号】'||XTHH.CKHTH||'；【投产日期】'||TO_CHAR(XTHH.TCRQ,'YYYYMMDD')||'；【完工日期】'||TO_CHAR(XTHH.WGRQ,'YYYYMMDD')||
              '；【案源管理台账立案/线索移交/录入日期】'||TO_CHAR(AYGLTZ.LARQ,'YYYYMMDD')||'；【结案日期】'||TO_CHAR(AYGLTZ.JARQ,'YYYYMMDD')||
              '；【暂停资格日期】'||TO_CHAR(ZT.LRRQ,'YYYYMMDD'),
              AYGLTZ.JARQ,SYSDATE
         FROM AYGLTZ
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=AYGLTZ.DJXH
        INNER JOIN HX_CKTS.CKTS_BA_XTHHZG_JGB XTHH --先退税后核销资格期间立案
          ON XTHH.DJXH=AYGLTZ.DJXH AND NVL(XTHH.ZFBZ_1,'N')='N' AND XTHH.TCRQ<AYGLTZ.LARQ AND XTHH.WGRQ>AYGLTZ.LARQ
       INNER JOIN HX_CKTS.CKTS_QT_SWSXQDB_JGB ZT --立案以后暂停实行先退税后核销
          ON ZT.DJXH=AYGLTZ.DJXH AND ZT.LCSWSX_DM='LCSXA082035001' AND ZT.QDSX_DM='01' AND ZT.LRRQ>AYGLTZ.LARQ
       WHERE NOT EXISTS (SELECT 1 --暂停以后不存在恢复实行先退税后核销
                           FROM HX_CKTS.CKTS_QT_SWSXQDB_JGB HF
                          WHERE HF.DJXH=AYGLTZ.DJXH AND HF.LCSWSX_DM='LCSXA082035001' AND HF.QDSX_DM='02' AND HF.LRRQ>ZT.LRRQ);
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023072001...');
  COMMIT;

  -- 未按规定将移送稽查、稽查立案企业相关情况录入案源管理台账(未结案)
  -- >5个工作日内
  -- 2023072101   事前
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023072101',  -- '风险管理类','JC-WLRTZ-LAQY',
              AJ.JCAJXXUUID,BA.TSSWJG_DM_1,AJ.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH) AS NSRSBH,DJ.NSRMC,NULL,NULL,
              '【稽查案件编号】'||AJ.JCAJBH||'；【案件名称】'||AJ.AJMC||'；【案件类型代码】'||AJ.AJLX_DM||'；【立案日期】'||TO_CHAR(AJ.LARQ,'YYYYMMDD'),
              AJ.LARQ,SYSDATE
         FROM HX_JC.JC_AJXX AJ
        INNER JOIN HX_CKTS.CKTS_BA_BAXX_JGB BA ON BA.DJXH=AJ.DJXH AND NVL(BA.BACHBZ,'N')='N'
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=AJ.DJXH
        WHERE NVL(AJ.ZFBZ_1,'N') = 'N'
          AND AJ.LARQ>=LD_SJCL_M 
          AND COMPUTE_BLJZDATE('A',AJ.LARQ)<TRUNC(SYSDATE)
          AND AJ.JARQ IS NULL
          AND (AJ.AJMC LIKE '%发票违法%' OR AJ.AJMC LIKE '%骗税%')
          AND NOT EXISTS (SELECT 1 FROM HX_CKTS.CKTS_QT_CKQYAYGLTZ_JGB JG WHERE AJ.DJXH = JG.DJXH
                           UNION ALL
                          SELECT 1 FROM HX_CKTS.CKTS_QT_CKQYAYGLTZ_GCB JG WHERE AJ.DJXH = JG.DJXH);
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023072101...');
  COMMIT;

  -- 未按规定对移送稽查企业提出暂停实行先退税后核销办法的意见
  -- 2023072201  X 	与2023071901重复

  -- 未按规定将稽查结案企业相关情况录入案源管理台账
  -- 2023072301  X
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023072301',  -- '风险管理类','JC-WLRTZ-JAQY',
              AJ.JCAJXXUUID,BA.TSSWJG_DM_1,AJ.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH) AS NSRSBH,DJ.NSRMC,NULL,NULL,
              '【稽查案件编号】'||AJ.JCAJBH||'；【案件名称】'||AJ.AJMC||'；【结案日期】'||TO_CHAR(AJ.JARQ,'YYYYMMDD')||
              '；【违法事实】'||TO_CHAR(SUBSTR(CF.WFSS,1,500))||'...',
              AJ.JARQ,SYSDATE
         FROM HX_JC.JC_AJXX AJ
        INNER JOIN HX_CKTS.CKTS_BA_BAXX_JGB BA ON BA.DJXH=AJ.DJXH AND NVL(BA.BACHBZ,'N')='N'
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=AJ.DJXH
        INNER JOIN HX_FZ.FZ_SWXZCFJDS CF ON CF.SSWFXWDJUUID=AJ.JCAJXXUUID AND NVL(CF.ZFBZ_1,'N')='N'
        WHERE NVL(AJ.ZFBZ_1,'N') = 'N'
          AND AJ.JARQ>=LD_SJCL_M
          AND ((CF.WFSS LIKE '%虚开%' AND CF.WFSS LIKE '%专用发票%') OR (CF.WFSS LIKE '%出口%' AND CF.WFSS LIKE '%骗税%'))
          AND NOT EXISTS (SELECT 1 FROM HX_CKTS.CKTS_QT_CKQYAYGLTZ_JGB JG WHERE AJ.DJXH = JG.DJXH
                           UNION ALL
                          SELECT 1 FROM HX_CKTS.CKTS_QT_CKQYAYGLTZ_GCB JG WHERE AJ.DJXH = JG.DJXH);
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023072301...');
  COMMIT;

  -- 违规评定出口企业分类管理类别（一类企业）
  -- 2023072401  X
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH YLQY AS ( --一类企业评定结果
       SELECT KZ.UUID,KZ.TSSWJG_DM_1,KZ.DJXH,TRUNC(KZ.YXQQ) AS A_YXQQ,TRUNC(KZ.YXQZ) AS A_YXQZ,TRUNC(KZ.LRRQ) AS PDRQ
         FROM HX_CKTS.CKTS_BA_KZ_JGB KZ
        WHERE KZ.CKTMSBAKZLX_DM='FLGLCD' AND KZ.YXBZ='Y' AND KZ.KZNR='A' AND KZ.LRRQ>=LD_SJCL_M),
              SEHZ AS ( --一类企业对应上年度税额核准
       SELECT YLQY.UUID,SUM(SE.SEHZZZSTSE+SE.SEHZXFSTSE) AS HZSE
         FROM YLQY
        INNER JOIN HX_CKTS.CKTS_TY_SEHZB SE ON SE.DJXH=YLQY.DJXH
          AND SE.SEHZRQ>=ADD_MONTHS(TRUNC(YLQY.PDRQ,'YY'),-12) AND SE.SEHZRQ<TRUNC(YLQY.PDRQ,'YY')
        GROUP BY YLQY.UUID),
              YZH AS ( --一类企业对应上年度应追回已退免税款
       SELECT YLQY.UUID,SUM(TK.YZHTMSKZZS+TK.YZHTMSKXFS) AS YZHSE
         FROM YLQY
        INNER JOIN HX_CKTS.CKTS_TK_YZHYTSKMXB_JGB TK ON TK.DJXH=YLQY.DJXH
          AND TK.LRRQ>=ADD_MONTHS(TRUNC(YLQY.PDRQ,'YY'),-12) AND TK.LRRQ<TRUNC(YLQY.PDRQ,'YY')
        GROUP BY YLQY.UUID),
              CWBB AS ( --一类企业对应上年度年末净资产
       SELECT YLQY.UUID,SUM(B.QMYE_QY) AS SYZQY
         FROM YLQY
        INNER JOIN HX_SB.SB_ZLBSCJB A ON A.DJXH=YLQY.DJXH
          AND A.SSQQ>=ADD_MONTHS(TRUNC(YLQY.PDRQ,'YY'),-3) AND A.SSQZ=TRUNC(YLQY.PDRQ,'YY')-1 AND A.ZFBZ_1 IS NULL
        INNER JOIN HX_SB.SB_CWBB_QYKJZZYBQY_ZCFZB B ON B.ZLBSCJUUID=A.ZLBSCJUUID AND B.EWBHXH=30
        GROUP BY YLQY.UUID
        UNION ALL
       SELECT YLQY.UUID,SUM(B.QMS_QY) AS SYZQY
         FROM YLQY
        INNER JOIN HX_SB.SB_ZLBSCJB A ON A.DJXH=YLQY.DJXH
          AND A.SSQQ>=ADD_MONTHS(TRUNC(YLQY.PDRQ,'YY'),-3) AND A.SSQZ=TRUNC(YLQY.PDRQ,'YY')-1 AND A.ZFBZ_1 IS NULL
        INNER JOIN HX_SB.SB_CWBB_QYKJZZ_ZCFZB B ON B.ZLBSCJUUID=A.ZLBSCJUUID AND B.EWBHXH=35
        GROUP BY YLQY.UUID
        UNION ALL
       SELECT YLQY.UUID,SUM(B.QMYE_QY) AS SYZQY
         FROM YLQY
        INNER JOIN HX_SB.SB_ZLBSCJB A ON A.DJXH=YLQY.DJXH
          AND A.SSQQ>=ADD_MONTHS(TRUNC(YLQY.PDRQ,'YY'),-3) AND A.SSQZ=TRUNC(YLQY.PDRQ,'YY')-1 AND A.ZFBZ_1 IS NULL
        INNER JOIN HX_SB.SB_CWBB_XQYKJZZ_ZCFZB B ON B.ZLBSCJUUID=A.ZLBSCJUUID AND B.EWBHXH=30
        GROUP BY YLQY.UUID
        UNION ALL
       SELECT YLQY.UUID,SUM(B.QMYE_QY) AS SYZQY
         FROM YLQY
        INNER JOIN HX_SB.SB_ZLBSCJB A ON A.DJXH=YLQY.DJXH
          AND A.SSQQ>=ADD_MONTHS(TRUNC(YLQY.PDRQ,'YY'),-3) AND A.SSQZ=TRUNC(YLQY.PDRQ,'YY')-1 AND A.ZFBZ_1 IS NULL
        INNER JOIN HX_SB.SB_CWBB_QYKJZZYBQY_ZCFZBZX B ON B.ZLBSCJUUID=A.ZLBSCJUUID AND B.EWBHXH=38
        GROUP BY YLQY.UUID)
       SELECT '2023072401',  -- '综合管理类','FLGL-A-NMJZC',
              YLQY.UUID,YLQY.TSSWJG_DM_1,YLQY.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH) AS NSRSBH,DJ.NSRMC,NULL,NULL,
              '【一类企业评定日期】'||TO_CHAR(YLQY.PDRQ,'YYYYMMDD')||'；【有效期】'||TO_CHAR(YLQY.A_YXQQ,'YYYYMMDD')||'-'||TO_CHAR(YLQY.A_YXQZ,'YYYYMMDD')||
              '；【上年核准税额】'||NVL(SEHZ.HZSE,0)||'；【上年追回税额】'||NVL(YZH.YZHSE,0)||'；【上年末所有者权益】'||NVL(CWBB.SYZQY,0),
              YLQY.PDRQ,SYSDATE
         FROM YLQY
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=YLQY.DJXH
         LEFT JOIN SEHZ ON SEHZ.UUID=YLQY.UUID
         LEFT JOIN YZH ON YZH.UUID=YLQY.UUID
         LEFT JOIN CWBB ON CWBB.UUID=YLQY.UUID
        WHERE NVL(CWBB.SYZQY,0)<=0.6*(NVL(SEHZ.HZSE,0)-NVL(YZH.YZHSE,0));
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023072401...');
  COMMIT;

  -- 应恢复未恢复出口企业分类管理类别（稽查结案无问题）
  -- 结案满20个工作日的数据
  -- 2023072501   事前
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH AYGLTZ AS (
       SELECT A.UUID,A.TSSWJG_DM_1,A.DJXH,NVL(A.LARQ,NVL(A.XSYSQSRQ,NVL(A.XSYSJCRQ,A.LRRQ))) AS LARQ,A.JARQ
         FROM HX_CKTS.CKTS_QT_CKQYAYGLTZ_JGB A
        WHERE A.JARQ>=LD_SJCL_M AND TRIM(A.CKQYAYGLTZCFYY_DM) IS NULL
          AND COMPUTE_BLJZDATE('D',A.JARQ)<TRUNC(SYSDATE)
          AND NVL(A.LARQ,NVL(A.XSYSQSRQ,NVL(A.XSYSJCRQ,A.LRRQ))) < A.JARQ 
        UNION ALL
       SELECT B.UUID,B.TSSWJG_DM_1,B.DJXH,NVL(B.LARQ,NVL(B.XSYSQSRQ,NVL(B.XSYSJCRQ,B.LRRQ))) AS LARQ,B.JARQ
         FROM HX_CKTS.CKTS_QT_CKQYAYGLTZ_GCB B
        WHERE B.JARQ>=LD_SJCL_M AND TRIM(B.CKQYAYGLTZCFYY_DM) IS NULL
          AND COMPUTE_BLJZDATE('D',B.JARQ)<TRUNC(SYSDATE)
          AND NVL(B.LARQ,NVL(B.XSYSQSRQ,NVL(B.XSYSJCRQ,B.LRRQ))) < B.JARQ 
       ),
              YFLGL AS (
       SELECT UUID,KZNR_Y,YXQQ_Y FROM (
       SELECT AYGLTZ.UUID,Y.KZNR AS KZNR_Y,Y.YXQQ AS YXQQ_Y,ROW_NUMBER() OVER (PARTITION BY Y.DJXH ORDER BY Y.YXQQ DESC) RN
         FROM AYGLTZ
        INNER JOIN HX_CKTS.CKTS_BA_KZ_JGB Y ON Y.DJXH=AYGLTZ.DJXH
        WHERE Y.CKTMSBAKZLX_DM='FLGLCD' AND Y.YXBZ = 'Y' AND Y.YXQQ<AYGLTZ.LARQ)
        WHERE RN=1
       ),
              TZFLGL AS (
       SELECT UUID,KZNR_T,YXQQ_T FROM (
       SELECT AYGLTZ.UUID,Y.KZNR AS KZNR_T,Y.YXQQ AS YXQQ_T,ROW_NUMBER() OVER (PARTITION BY Y.DJXH ORDER BY Y.YXQQ ASC) RN
         FROM AYGLTZ
        INNER JOIN HX_CKTS.CKTS_BA_KZ_JGB Y ON Y.DJXH=AYGLTZ.DJXH
        WHERE Y.CKTMSBAKZLX_DM='FLGLCD' AND Y.YXBZ = 'Y' AND Y.YXQQ>AYGLTZ.LARQ)
        WHERE RN=1
       ),
              HFFLGL AS (
       SELECT UUID,KZNR_H,YXQQ_H FROM (
       SELECT AYGLTZ.UUID,Y.KZNR AS KZNR_H,Y.YXQQ AS YXQQ_H,ROW_NUMBER() OVER (PARTITION BY Y.DJXH ORDER BY Y.YXQQ ASC) RN
         FROM AYGLTZ
        INNER JOIN TZFLGL ON TZFLGL.UUID=AYGLTZ.UUID
        INNER JOIN HX_CKTS.CKTS_BA_KZ_JGB Y ON Y.DJXH=AYGLTZ.DJXH
        WHERE Y.CKTMSBAKZLX_DM='FLGLCD' AND Y.YXBZ = 'Y' AND Y.YXQQ>GREATEST(NVL(AYGLTZ.JARQ,TZFLGL.YXQQ_T),TZFLGL.YXQQ_T))
        WHERE RN=1
       )
       SELECT '2023072501',  -- '风险管理类','FLGL-AB-JCJAQY',
              AYGLTZ.UUID,AYGLTZ.TSSWJG_DM_1,AYGLTZ.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH) AS NSRSBH,DJ.NSRMC,NULL,NULL,
              '【案源管理台账立案日期】'||TO_CHAR(AYGLTZ.LARQ,'YYYYMMDD')||'【结案日期】'||TO_CHAR(AYGLTZ.JARQ,'YYYYMMDD')||
              '；【立案前分类管理等级】'||YFLGL.KZNR_Y||'【有效期起】'||TO_CHAR(YFLGL.YXQQ_Y,'YYYYMMDD')||
              '；【立案后分类管理等级】'||TZFLGL.KZNR_T||'【有效期起】'||TO_CHAR(TZFLGL.YXQQ_T,'YYYYMMDD')||
              '；【结案后分类管理等级】'||HFFLGL.KZNR_H||'【有效期起】'||TO_CHAR(HFFLGL.YXQQ_H,'YYYYMMDD'),
              AYGLTZ.JARQ,SYSDATE
         FROM AYGLTZ
        INNER JOIN HX_CKTS.CKTS_BA_BAXX_JGB BA ON BA.DJXH=AYGLTZ.DJXH AND NVL(BA.BACHBZ,'N')='N'
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=AYGLTZ.DJXH
        INNER JOIN YFLGL ON YFLGL.UUID=AYGLTZ.UUID
         LEFT JOIN TZFLGL ON TZFLGL.UUID=AYGLTZ.UUID
         LEFT JOIN HFFLGL ON HFFLGL.UUID=AYGLTZ.UUID
        WHERE YFLGL.KZNR_Y IN ('A','B');
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023072501...');
  COMMIT;

  -- 未按照规定办理出口退（免）税备案撤回
  -- 2023072601  X  	与202305030*重复

  -- 税务登记注销时出口备案未撤回
  -- 2023072701  X
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023072701',  -- '综合管理类','BACH-ZXSWDJ',
              BA.UUID,BA.TSSWJG_DM_1,BA.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【纳税人当前状态】'||DJ.NSRZT_DM||'-'||ZT.NSRZTMC||'；【修改日期】'||TO_CHAR(DJ.XGRQ,'YYYYMMDD'),
              DJ.XGRQ,SYSDATE
         FROM HX_CKTS.CKTS_BA_BAXX_JGB BA
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=BA.DJXH
        INNER JOIN HX_DM_QG.DM_GY_NSRZT ZT ON ZT.NSRZT_DM=DJ.NSRZT_DM
        WHERE DJ.NSRZT_DM='07' AND NVL(BA.BACHBZ,'N')='N'; --未包括非正常注销
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023072701...');
  COMMIT;

  -- 应出具未出具税务事项通知书
  -- 2023072801  事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023072801',  -- '申报管理类','WS-YCJWCJ',
              T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【税务事项】'||T.LCSWSX_DM||'-'||SX.LCSWSXMC||'；【所属期批次】'||T.SSQ||'-'||T.SBPC||'；【发放日期】'||TO_CHAR(T.FFRQ,'YYYYMMDD'),
              T.FFRQ,SYSDATE
         FROM HX_CKTS.CKTS_TY_YWBLXX T
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
        INNER JOIN HX_DM_QG.DM_GY_LCSWSX SX ON SX.LCSWSX_DM=T.LCSWSX_DM
        WHERE REGEXP_LIKE(T.LCSWSX_DM,'^LCSXA081047001|^LCSXA081049') --非即办类：来料加工免税、代理出口、代理进口、转内销、已补税（未退税）证明
          AND NVL(T.ZFBZ_1,'N')='N' -- 流程未作废
          AND T.FFRQ>=LD_SJCL_M
          AND T.FFRQ>=DATE'2023-10-01' --起始时间限定
          AND NOT EXISTS (SELECT 1 FROM HX_ZH.GY_WS_WSZB WS WHERE WS.DJXH=T.DJXH AND WS.LCSLID=T.LCSLID);  --不存在文书制作信息
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023072801...');
  COMMIT;

  -- 无合理理由进行再次发函
  -- 2023072901  事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH FH_FP AS (
       SELECT FP.ZZSZYFPDMHM,FH.FHXXBUUID,NVL(FU.FHLX_DM,'3') AS FHLX_DM,
              ROW_NUMBER() OVER (PARTITION BY FP.ZZSZYFPDMHM,FH.FHXXBUUID ORDER BY NVL(FU.QFRQ,SYSDATE) DESC,NVL(FU.FHCS,0) DESC) AS RN
         FROM HX_ZH.ZH_CKTS_HDFPQD FP --函调发票
        INNER JOIN HX_ZH.ZH_CKTS_FHXXB FH ON FH.FHXXBUUID=FP.FHXXBUUID --已发函
          AND FH.FAHDSWJG_DM LIKE '133%' AND FH.FAHDSWJG_DM NOT LIKE '13302%' --发函地税局：浙江非宁波
          AND NVL(FH.ZFBZ_1,'N')='N' --发函未作废
         LEFT JOIN HX_ZH.ZH_CKTS_FUHXXB FU ON FU.FHXXBUUID=FH.FHXXBUUID --左连接回函，包含未回函
          AND NVL(FU.ZFBZ_1,'N')='N' --回函未作废
       ),
              DUP_FP AS (
       SELECT FH_FP.ZZSZYFPDMHM
         FROM FH_FP
        WHERE FH_FP.RN=1 --按发票、发函UUID取最后一次回函记录
          AND FH_FP.FHLX_DM<>'5' --排除最后一次回函结果为非本地管辖复函的核实函
        GROUP BY FH_FP.ZZSZYFPDMHM HAVING COUNT(DISTINCT FH_FP.FHXXBUUID)>1 ----同一份发票存在2次以上发函记录
       ),
              DUP_FH AS (
       SELECT FP1.HDFPQDUUID,FP1.ZZSZYFPDMHM,FP1.JE,FP1.SE,
              FH1.FAHDSWJG_DM,FH1.FAHDSWJGMC,FH1.GHFDJXH,FH1.GHQYNSRSBH,FH1.GHFQYMC,
              FH1.GHFZGSWJG_DM,FH1.GHFZGSWJGMC,FH1.GHQYNSRSBH_1,FH1.GHFQYMC_1,
              FH1.FHXXBUUID,FH1.WSBH,FH1.QFR,FH1.QFRQ,FH1.LRRQ,FH1.FAHYY,
              FU1.FUHXXBUUID,FU1.QFRQ AS FUHRQ,FU1.LRRQ AS FULRRQ,FU1.FHLX_DM,FU1.FHCLRQ,FU1.FHCLYJ_DM,FU1.FHCLYJSM,
              ROW_NUMBER() OVER (PARTITION BY FP1.ZZSZYFPDMHM ORDER BY FH1.QFRQ DESC,FH1.LRRQ DESC,FU1.QFRQ DESC NULLS LAST,FU1.LRRQ DESC NULLS LAST) AS RN
         FROM DUP_FP
        INNER JOIN HX_ZH.ZH_CKTS_HDFPQD FP1 ON FP1.ZZSZYFPDMHM=DUP_FP.ZZSZYFPDMHM --函调发票
        INNER JOIN HX_ZH.ZH_CKTS_FHXXB FH1 ON FH1.FHXXBUUID=FP1.FHXXBUUID --发函
          AND FH1.FAHDSWJG_DM LIKE '133%' AND FH1.FAHDSWJG_DM NOT LIKE '13302%' --发函地税局：浙江非宁波
          AND NVL(FH1.ZFBZ_1,'N')='N' --发函未作废
         LEFT JOIN HX_ZH.ZH_CKTS_FUHXXB FU1 ON FU1.FHXXBUUID=FH1.FHXXBUUID --左连接，包含未回函
          AND NVL(FU1.ZFBZ_1,'N')='N' --回函未作废
       )
       SELECT '2023072901',  -- '函调管理类','HD-FAH-CFFH',
              HDFPQDUUID,FAHDSWJG_DM,GHFDJXH,GHQYNSRSBH,GHFQYMC,JE,SE,
              '【最近一次核实函编号】'||WSBH||'；【发票号码】'||ZZSZYFPDMHM||'；【供货企业】'||GHQYNSRSBH_1||'-'||GHFQYMC_1,
              /*'；【最近一次发函日期】'||TO_CHAR(QFRQ,'YYYYMMDD')||'；【发函原因】'||FAHYY||
              '；【最近一次回函日期】'||TO_CHAR(FUHRQ,'YYYYMMDD')||'；【回函意见】'||FHLX_DM||
              '；【最近一次回函处理日期】'||TO_CHAR(FHCLRQ,'YYYYMMDD')||'；【回函处理意见】'||FHCLYJ_DM,*/
              QFRQ,SYSDATE
         FROM DUP_FH
        WHERE DUP_FH.RN=1 --按发票取最后一次发函的最后一次回函记录
          AND DUP_FH.QFRQ>=LD_SJCL_M; --最后一次发函时间点限制
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023072901...');
  COMMIT;

  -- 复函地主管税务机关随意向上游发函
  -- 2023073001  X
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH FHXX AS (
       SELECT FH.FHXXBUUID,FH.FAHDSWJG_DM,FH.GHFDJXH,FH.GHQYNSRSBH,FH.GHFQYMC,FH.JEHJ,FH.SEHJ,FH.GHQYNSRSBH_1,FH.GHFQYMC_1,FH.QFRQ,FH.CXFAHYY,
              FU.FHLX_DM,FU.HSHBH,DC.GHQYNSRSBH AS GHQYNSRSBH_DC,DC.GHFQYMC AS GHFQYMC_DC,DC.GHQYZCLX,DC.GHQYDGHSPSFZC,
              ROW_NUMBER() OVER (PARTITION BY FH.FHXXBUUID ORDER BY FU.QFRQ DESC) AS RN
         FROM HX_ZH.ZH_CKTS_FHXXB FH
        INNER JOIN HX_ZH.ZH_CKTS_FUHXXB FU ON FH.SYHSHBH=FU.HSHBH
          AND NVL(FU.ZFBZ_1,'N')='N' --回函未作废
          AND FU.FHLX_DM IN ('1','2') --只针对有明确结论的回函有调查核实情况表
        INNER JOIN HX_ZH.ZH_CKTS_DCHSYGQKB DC ON DC.FUHXXBUUID=FU.FUHXXBUUID
          AND DC.GHQYZCLX='1' --供货企业注册类型限定为“生产企业”
          AND DC.GHQYDGHSPSFZC='Y' --供货企业的供货商品是否自产为是
        WHERE FH.FAHDSWJG_DM LIKE '133%' AND FH.FAHDSWJG_DM NOT LIKE '13302%' --向供货方发函地税局：浙江非宁波
          AND NVL(FH.ZFBZ_1,'N')='N' --向供货方发函未作废
          AND FH.QFRQ IS NOT NULL --向供货方发函已签发
          AND FU.QFRQ>=LD_SJCL_Y --向采购方回函的签发时间
       )
       SELECT '2023073001',  -- '函调管理类','HD-FAH-XSYFH',
              FHXXBUUID,FAHDSWJG_DM,GHFDJXH,GHQYNSRSBH,GHFQYMC,JEHJ,SEHJ,
              '【核实函编号】'||HSHBH||'；【购货企业】'||GHQYNSRSBH_DC||'-'||GHFQYMC_DC||
              '；【供货商注册类型】'||GHQYZCLX||'；【供货商品是否自产】'||GHQYDGHSPSFZC||'；【回函类型】'||FHLX_DM||
              '；【上游供货商】'||GHQYNSRSBH_1||'-'||GHFQYMC_1||'；【发函原因】'||CXFAHYY,
              QFRQ,SYSDATE
         FROM FHXX
        WHERE RN=1;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023073001...');
  COMMIT;

  -- 应出具未出具需提供收汇资料收汇信息采集的税务事项通知书
  -- 2023073101  X
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023073101',  -- '申报管理类','WS-YCJWCJ-SHZL',
              KZ.UUID,KZ.TSSWJG_DM_1,KZ.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【扩展类型】'||KZ.CKTMSBAKZLX_DM||'；【录入日期】'||TO_CHAR(KZ.LRRQ,'YYYYMMDD')||'；【有效期起】'||TO_CHAR(KZ.YXQQ,'YYYYMMDD')||
              '；【税务事项通知书('||SWSX.SWSXMC||')打印日期】'||TO_CHAR(WS.DYRQ,'YYYYMMDD')||
              '；【文书送达状态】'||SDZT.SDZTMC||'；【送达日期】'||TO_CHAR(SD.WSSDSJ,'YYYYMMDD'),
              KZ.LRRQ,SYSDATE
         FROM HX_CKTS.CKTS_BA_KZ_JGB KZ
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=KZ.DJXH AND DJ.NSRZT_DM NOT IN ('05','07','08')
         LEFT JOIN HX_ZH.GY_WS_WSZB WS ON KZ.DJXH=WS.DJXH AND WS.SWSX_DM='SXA082048001' AND WS.DZBZDSZL_DM='BDA0420113'  -- 需提供收汇资料收汇信息采集
         LEFT JOIN HX_DM_QG.DM_GY_SWSX SWSX ON WS.SWSX_DM=SWSX.SWSX_DM
         LEFT JOIN HX_DM_QG.DM_ZH_SDZT SDZT ON WS.SDZT_DM=SDZT.SDZT_DM
         LEFT JOIN HX_ZH.ZH_SDXX SD ON WS.YWWSUUID=SD.SDWSUUID  -- 文书 送达信息
         LEFT JOIN HX_ZH.ZH_SDHZ SDHZ ON SD.SDHZUUID=SDHZ.SDHZUUID -- 送达回证
        WHERE KZ.CKTMSBAKZLX_DM='TGSHZL' AND KZ.LRRQ>=LD_SJCL_M
          AND SDHZ.XHRQ_1 IS NULL
          AND NOT EXISTS (SELECT 1 FROM HX_CKTS.CKTS_BA_KZ_JGB FLGL
                           WHERE FLGL.DJXH=KZ.DJXH AND FLGL.CKTMSBAKZLX_DM='FLGLCD' AND FLGL.KZNR='D'
                             AND FLGL.YXBZ='Y' AND FLGL.YXQQ=KZ.YXQQ);
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023073101...');
  COMMIT;

  -- 应出具未出具适用出口免税政策评定的税务事项通知书
  -- >5个工作日
  -- 2023073201   事前
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023073201',  -- '申报管理类','WS-YCJWCJ-MSZC',
              MS.UUID,MS.TSSWJG_DM_1,MS.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【适用出口免税政策评估结果录入日期】'||TO_CHAR(MS.LRRQ,'YYYYMMDD')||'；【有效期起】'||TO_CHAR(MS.QSRQ_2,'YYYYMMDD')||
              '；【税务事项通知书('||SWSX.SWSXMC||')打印日期】'||TO_CHAR(WS.DYRQ,'YYYYMMDD')||
              '；【文书送达状态】'||SDZT.SDZTMC||'；【送达日期】'||TO_CHAR(SD.WSSDSJ,'YYYYMMDD'),
              MS.LRRQ,SYSDATE
         FROM HX_CKTS.CKTS_QT_SYCKMSZCPG_JGB MS  -- 适用出口免税政策评估结果表
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=MS.DJXH
         LEFT JOIN HX_ZH.GY_WS_WSZB WS ON MS.DJXH=WS.DJXH AND WS.DZBZDSZL_DM='BDA0820076' -- 出口适用增值税退（免）税政策改为适用免税企业通知
         LEFT JOIN HX_DM_QG.DM_GY_SWSX SWSX ON WS.SWSX_DM=SWSX.SWSX_DM
         LEFT JOIN HX_DM_QG.DM_ZH_SDZT SDZT ON WS.SDZT_DM=SDZT.SDZT_DM
         LEFT JOIN HX_ZH.ZH_SDXX SD ON WS.YWWSUUID=SD.SDWSUUID  -- 文书 送达信息
         LEFT JOIN HX_ZH.ZH_SDHZ SDHZ ON SD.SDHZUUID=SDHZ.SDHZUUID -- 送达回证
        WHERE MS.LRRQ>=LD_SJCL_M
          AND COMPUTE_BLJZDATE('A',MS.LRRQ)<TRUNC(SYSDATE)
          AND SDHZ.XHRQ_1 IS NULL;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023073201...');
  COMMIT;

  -- 违规评定出口企业分类管理类别（三类企业，上一年度违反规定未达处罚标准）
  -- 按不予行政处罚决定明细清册（违法事实包含“出口退税”字样），分类管理等级A、B有效期起前一年内制作文书的
  -- 2023073301  事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023073301',  -- '综合管理类','FLGL-C-WGWCF',
              T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【分类管理评定时间】'||TO_CHAR(T.LRRQ,'YYYYMMDD')||'；【评定等级】'||T.KZNR||
              '；【案件名称】'||S.AJMC||'；【文书制作时间】'||TO_CHAR(R.WSZZRQ,'YYYYMMDD')||
              '；【W违法事实】'||TO_CHAR(SUBSTR(R.WFSS,1,500))||'...【不予处罚理由】'||TO_CHAR(SUBSTR(R.BYCFLY,1,500)),
              T.LRRQ,SYSDATE
         FROM HX_CKTS.CKTS_BA_KZ_JGB T
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
        INNER JOIN HX_JC.JC_AJXX S ON S.DJXH=T.DJXH
        INNER JOIN HX_FZ.FZ_BYSWXZCFJDS R ON R.SSWFXWDJUUID=S.JCAJXXUUID AND NVL(R.ZFBZ_1,'N')='N'
          AND R.WSZZRQ<T.LRRQ AND R.WSZZRQ>=ADD_MONTHS(TRUNC(T.LRRQ,'YY'),-12)
          AND R.WFSS LIKE '%出口退税%'
        WHERE T.CKTMSBAKZLX_DM='FLGLCD' AND T.YXBZ='Y' AND T.YXQZ>T.YXQQ AND T.KZNR IN ('A','B')
          AND T.LRRQ>=LD_SJCL_M; --分类管理评定时间
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023073301...');
  COMMIT;

  -- 违规评定出口企业分类管理类别（四类企业，上一年度违反规定被处罚）
  -- 2023073401  事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023073401',  -- '综合管理类','FLGL-D-WGYCF',
              T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【分类管理评定时间】'||TO_CHAR(T.LRRQ,'YYYYMMDD')||'；【评定等级】'||T.KZNR||
              '；【案件名称】'||S.AJMC||'；【文书制作时间】'||TO_CHAR(R.WSZZRQ,'YYYYMMDD')||
              '；【W违法事实】'||TO_CHAR(SUBSTR(R.WFSS,1,500))||'...【处罚决定】'||TO_CHAR(SUBSTR(R.CFJD,1,500)),
              T.LRRQ,SYSDATE
         FROM HX_CKTS.CKTS_BA_KZ_JGB T
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
        INNER JOIN HX_JC.JC_AJXX S ON S.DJXH=T.DJXH
        INNER JOIN HX_FZ.FZ_SWXZCFJDS R ON R.SSWFXWDJUUID=S.JCAJXXUUID AND NVL(R.ZFBZ_1,'N')='N'
          AND R.WSZZRQ<T.LRRQ AND R.WSZZRQ>=ADD_MONTHS(TRUNC(T.LRRQ,'YY'),-12)
          AND R.CFJD LIKE '%骗取%出口退税%'
        WHERE T.CKTMSBAKZLX_DM='FLGLCD' AND T.YXBZ='Y' AND T.YXQZ>T.YXQQ AND T.KZNR<>'D'
          AND T.LRRQ>=LD_SJCL_M; --分类管理评定时间
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023073401...');
  COMMIT;

  -- 违规评定出口企业分类管理类别（四类企业，停权企业）
  -- 2023073501  X   同2023050701重复

  -- 违规评定出口企业分类管理类别（违规越级评定）
  -- 按分类管理类别一二三四分别对应4321分，连续两个区间的分类管理类别对应得分差超过1，属于越级评定
  -- 2023073601  X
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023073601',  -- '综合管理类','FLGL-X-YJPD',
              T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【分类管理评定时间】'||TO_CHAR(T.LRRQ,'YYYYMMDD')||
              '；【评定等级】'||T.KZNR||'；【有效期】'||TO_CHAR(T.YXQQ,'YYYYMMDD')||'-'||TO_CHAR(T.YXQZ,'YYYYMMDD')||
              '；【上一周期评定等级】'||S.KZNR||'；【有效期】'||TO_CHAR(S.YXQQ,'YYYYMMDD')||'-'||TO_CHAR(S.YXQZ,'YYYYMMDD'),
              T.LRRQ,SYSDATE
         FROM HX_CKTS.CKTS_BA_KZ_JGB T
        INNER JOIN HX_CKTS.CKTS_BA_KZ_JGB S ON S.DJXH=T.DJXH
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
        WHERE T.CKTMSBAKZLX_DM='FLGLCD' AND T.YXBZ='Y' AND T.YXQZ>T.YXQQ
          AND S.CKTMSBAKZLX_DM='FLGLCD' AND S.YXBZ='Y' AND S.YXQZ>S.YXQQ
          AND TRUNC(S.YXQZ)>=TRUNC(T.YXQQ)-1 AND TRUNC(S.YXQZ)<=TRUNC(T.YXQQ)
          AND DECODE(T.KZNR,'A',4,'B',3,'C',2,1)-DECODE(S.KZNR,'A',4,'B',3,'C',2,1)>1
          AND T.LRRQ>=LD_SJCL_M; --分类管理评定时间
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023073601...');
  COMMIT;

  -- 违规评定出口企业分类管理类别（四类企业，四类认定不足12个月）
  -- 2023073701  X    同2023050801重复

  -- 未及时进行出口企业分类管理评定（新增企业类别认定）
  -- 2023073801  X
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH XZQY AS (
       SELECT T.UUID,T.TSSWJG_DM_1,T.DJXH,TRUNC(T.LRRQ) AS BARQ,
              S.KZNR,TRUNC(S.YXQQ) AS YXQQ,TRUNC(S.YXQZ) AS YXQZ,TRUNC(S.LRRQ) AS PDRQ,
              ROW_NUMBER() OVER (PARTITION BY T.DJXH ORDER BY S.LRRQ) AS RN
         FROM HX_CKTS.CKTS_BA_BAXX_JGB T
         LEFT JOIN HX_CKTS.CKTS_BA_KZ_JGB S ON S.DJXH=T.DJXH
          AND S.CKTMSBAKZLX_DM='FLGLCD' AND S.YXBZ='Y' AND S.YXQZ>S.YXQQ
        WHERE T.LRRQ>=LD_SJCL_M AND NVL(T.BACHBZ,'N')='N'
       )
       SELECT '2023073801',  -- '综合管理类','FLGL-X-XZQYRD',
              XZQY.UUID,XZQY.TSSWJG_DM_1,XZQY.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【企业备案日期】'||TO_CHAR(XZQY.BARQ,'YYYYMMDD')||'；【评定日期】'||TO_CHAR(XZQY.PDRQ,'YYYYMMDD')||
              '；【评定等级】'||XZQY.KZNR||'；【有效期】'||TO_CHAR(XZQY.YXQQ,'YYYYMMDD')||'-'||TO_CHAR(XZQY.YXQZ,'YYYYMMDD'),
              XZQY.BARQ,SYSDATE
         FROM XZQY
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=XZQY.DJXH
        WHERE XZQY.RN=1 AND COMPUTE_BLDATE(NVL(XZQY.PDRQ,SYSDATE),XZQY.BARQ)>=15;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023073801...');
  COMMIT;

  -- 违规评定出口企业分类管理类别（三类企业，纳税信用评价为C级）
  -- FXNK_JC2B_NSXYPJ数据来源于决策二包，保留企业最新数据
  -- 2023073901  X
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023073901',  -- '综合管理类','FLGL-C-NSXZDJ',
              T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【分类管理评定日期】'||TO_CHAR(T.LRRQ,'YYYYMMDD')||'；【评定等级】'||T.KZNR||'；【有效期】'||TO_CHAR(T.YXQQ,'YYYYMMDD')||'-'||TO_CHAR(T.YXQZ,'YYYYMMDD')||
              '；【信用等级评定日期】'||TO_CHAR(S.FBSJ,'YYYYMMDD')||'；【信用等级】'||S.PJJB,
              SYSDATE,SYSDATE
         FROM HX_CKTS.CKTS_BA_KZ_JGB T
        INNER JOIN FXNK_JC2B_NSXYPJ S ON S.DJXH=T.DJXH AND S.PJJB='C'
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
        INNER JOIN HX_CKTS.CKTS_BA_BAXX_JGB BA ON BA.DJXH=T.DJXH AND NVL(BA.BACHBZ,'N')='N'
        WHERE T.CKTMSBAKZLX_DM='FLGLCD' AND T.YXBZ='Y' AND T.KZNR IN ('A','B')
          AND T.YXQZ>SYSDATE --剔除纳税信用评价之前已到期分类评定数据
          AND T.LRRQ>S.FBSJ;  --剔除纳税信用评价之前分类评定数据
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023073901...');
  COMMIT;

  -- 违规评定出口企业分类管理类别（四类企业，纳税信用评价为D级）
  -- FXNK_JC2B_NSXYPJ数据来源于决策二包，保留企业最新数据
  -- 2023074001  X
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023074001',  -- '综合管理类','FLGL-D-NSXZDJ',
              T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【分类管理评定日期】'||TO_CHAR(T.LRRQ,'YYYYMMDD')||'；【评定等级】'||T.KZNR||'；【有效期】'||TO_CHAR(T.YXQQ,'YYYYMMDD')||'-'||TO_CHAR(T.YXQZ,'YYYYMMDD')||
              '；【信用等级评定日期】'||TO_CHAR(S.FBSJ,'YYYYMMDD')||'；【信用等级】'||S.PJJB,
              SYSDATE,SYSDATE
         FROM HX_CKTS.CKTS_BA_KZ_JGB T
        INNER JOIN FXNK_JC2B_NSXYPJ S ON S.DJXH=T.DJXH AND S.PJJB='D' --纳税信用评价为D级
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
        INNER JOIN HX_CKTS.CKTS_BA_BAXX_JGB BA ON BA.DJXH=T.DJXH AND NVL(BA.BACHBZ,'N')='N'
        WHERE T.CKTMSBAKZLX_DM='FLGLCD' AND T.YXBZ='Y' AND T.KZNR IN ('A','B','C') --分类管理等级不为D
          AND T.YXQZ>SYSDATE --剔除纳税信用评价之前已到期分类评定数据
          AND T.LRRQ>S.FBSJ; --剔除纳税信用评价之前分类评定数据
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023074001...');
  COMMIT;

  -- 违规评定出口企业分类管理类别（三类企业，首笔申报未满12个月）
  -- 一二类企业名单，评定时间12个月前不存在核准记录、申报记录
  -- 2023074101  X
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023074101',  -- '综合管理类','FLGL-C-SCSB12M',
              T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【分类管理评定日期】'||TO_CHAR(T.LRRQ,'YYYYMMDD')||'；【评定等级】'||T.KZNR||'；【有效期】'||TO_CHAR(T.YXQQ,'YYYYMMDD')||'-'||TO_CHAR(T.YXQZ,'YYYYMMDD')||
              '；【首次申报日期】'||
              TO_CHAR((SELECT MIN(B3.LRRQ) FROM HX_CKTS.CKTS_TY_YWBLXX B3 WHERE B3.DJXH=T.DJXH AND NVL(B3.ZFBZ_1,'N')='N' AND
              B3.LCSWSX_DM IN ('LCSXA081038001','LCSXA081039001','LCSXA081040001','LCSXA081042001','LCSXA081042002','LCSXA081042006')),'YYYYMMDD')||
              '；【首次业务核准日期】'||
              TO_CHAR((SELECT MIN(B4.LRRQ) FROM HX_CKTS.CKTS_TY_YWHZB B4 WHERE B4.DJXH=T.DJXH),'YYYYMMDD')||
              '；【首次免抵退非零申报日期】'||
              TO_CHAR((SELECT MIN(B1.LRRQ) FROM HX_CKTS.CKTS_SB_MDT_SBHZ_JGB B1 WHERE B1.DJXH=T.DJXH AND B1.MDTSE>0),'YYYYMMDD')||
              '；【首次免退税申报日期】'||
              TO_CHAR((SELECT MIN(B2.LRRQ) FROM HX_CKTS.CKTS_SB_MTS_TSJH_JGB B2 WHERE B2.DJXH=T.DJXH AND B2.TSE>0),'YYYYMMDD')||
              '；【首次非零业务核准日期】'||
              TO_CHAR((SELECT MIN(B0.LRRQ) FROM HX_CKTS.CKTS_TY_YWHZB B0 WHERE B0.DJXH=T.DJXH AND B0.FSZZSTSE+B0.FSXFSTSE+B0.FSMDSE>0),'YYYYMMDD'),
              T.LRRQ,SYSDATE
         FROM HX_CKTS.CKTS_BA_KZ_JGB T
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
        WHERE T.CKTMSBAKZLX_DM='FLGLCD' AND T.YXBZ='Y' AND T.KZNR IN ('A','B') AND T.LRRQ>=LD_SJCL_M AND T.YXQZ>SYSDATE
          AND NOT EXISTS (SELECT 1 FROM HX_CKTS.CKTS_TY_YWBLXX A0
                           WHERE A0.DJXH=T.DJXH AND ADD_MONTHS(A0.LRRQ,12)<=T.LRRQ AND NVL(A0.ZFBZ_1,'N')='N'
                             AND REGEXP_LIKE(A0.LCSWSX_DM,'^LCSXA081038|^LCSXA081039|^LCSXA081040|^LCSXA081042'))
          AND NOT EXISTS (SELECT 1 FROM HX_CKTS.CKTS_TY_YWHZB A0
                           WHERE A0.DJXH=T.DJXH AND ADD_MONTHS(A0.LRRQ,12)<=T.LRRQ);
          /*AND NOT EXISTS (SELECT 1 FROM HX_CKTS.CKTS_TY_YWHZB A0
                           WHERE A0.DJXH=T.DJXH AND A0.FSZZSTSE+A0.FSXFSTSE+A0.FSMDSE>0 AND ADD_MONTHS(A0.LRRQ,12)<=T.LRRQ)
          AND NOT EXISTS (SELECT 1 FROM HX_CKTS.CKTS_SB_MDT_SBHZ_JGB A1 WHERE A1.DJXH=T.DJXH AND A1.MDTSE>0 AND ADD_MONTHS(A1.LRRQ,12)<=T.LRRQ)
          AND NOT EXISTS (SELECT 1 FROM HX_CKTS.CKTS_SB_MTS_TSJH_JGB A2 WHERE A2.DJXH=T.DJXH AND A2.TSE>0 AND ADD_MONTHS(A2.LRRQ,12)<=T.LRRQ);*/
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023074101...');
  COMMIT;

  -- 违规评定出口企业分类管理类别（四类企业，四类企业的法定代表人）
  -- 2023074201  事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH SLQY AS (
       SELECT KZ.UUID,KZ.TSSWJG_DM_1,KZ.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH) AS NSRSBH,DJ.NSRMC,
              BA.LRRQ AS BARQ,KZ.LRRQ,KZ.KZNR,DJ.FDDBRXM,DJ.FDDBRSFZJHM,
              SLQY.TSSWJG_DM_1 AS SLQY_TSSWJG,SLQY.NSRSBH AS SLQY_NSRSBH,SLQY.NSRMC AS SLQY_NSRMC,
              SLQY.YXQQ AS SLQY_YXQQ,SLQY.YXQZ AS SLQY_YXQZ,SLQY.BACHRQ AS SLQY_BACHRQ,
              ROW_NUMBER() OVER (PARTITION BY KZ.UUID ORDER BY SLQY.YXQQ) AS RN --用于剔除同时有多个四类企业
         FROM HX_CKTS.CKTS_BA_BAXX_JGB BA
        INNER JOIN HX_CKTS.CKTS_BA_KZ_JGB KZ ON KZ.DJXH=BA.DJXH AND KZ.CKTMSBAKZLX_DM='FLGLCD'
          AND KZ.YXBZ='Y' AND KZ.KZNR<>'D' --分类管理类别非四类
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=BA.DJXH
        INNER JOIN CKTS_KZ_SLQY SLQY ON SLQY.FDDBRSFZJHM=DJ.FDDBRSFZJHM AND SLQY.DJXH<>BA.DJXH--法人代表关联四类企业
        WHERE BA.LRRQ>=LD_SJCL_M --本年度新成立的出口企业
          AND BA.LRRQ>SLQY.YXQQ AND KZ.LRRQ<LEAST(SLQY.YXQZ,NVL(SLQY.BACHRQ,SYSDATE)) --成立时兼职企业在四类期间
       )
       SELECT '2023074201',  -- '综合管理类','FLGL-D-FDDBR',
              UUID,TSSWJG_DM_1,DJXH,NSRSBH,NSRMC,NULL,NULL,
              '【备案日期】'||TO_CHAR(BARQ,'YYYYMMDD')||'【分类管理评定日期】'||TO_CHAR(LRRQ,'YYYYMMDD')||'；【评定等级】'||KZNR||
              '；【企业法人代表】'||FDDBRXM||'-'||FDDBRSFZJHM||
              '；【法人代表关联四类企业】'||SLQY_TSSWJG||'-'||SLQY_NSRSBH||'-'||SLQY_NSRMC||
              '；【有效期】'||TO_CHAR(SLQY_YXQQ,'YYYYMMDD')||'-'||TO_CHAR(SLQY_YXQZ,'YYYYMMDD'),
              LRRQ,SYSDATE
         FROM SLQY
        WHERE RN=1;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023074201...');
  COMMIT;

  -- 未及时进行出口企业分类管理评定（复评申请）
  -- 企业管理类别复评结果表，评定时间晚于申请时间15个工作日以上
  -- 2023074301   事前
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023074301',  -- '综合管理类','FLGL-X-FPSQ',
              T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【企业申请复评时间】'||TO_CHAR(T.SQFPSJ,'YYYYMMDD')||'【评定日期】'||TO_CHAR(T.PDSJ,'YYYYMMDD')||
              '；【原评定等级】'||T.YGLLB_DM||'；【申请评定等级】'||T.SQFPGLLB_DM||'；【复评等级】'||T.FPGLLB_DM||
              '；【申请复评原因】'||T.SQFPYY,
              T.PDSJ,SYSDATE
         FROM HX_CKTS.CKTS_QT_QYGLLBFPPD_JGB T
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
        WHERE T.LRRQ>=LD_SJCL_M
          AND COMPUTE_BLDATE(T.PDSJ,T.SQFPSJ)>=15;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023074301...');
  COMMIT;

  -- 未及时进行出口企业分类管理评定（类别变更）
  -- 2023074401   事前
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023074401',  -- '综合管理类','FLGL-X-LBBG',
              T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【数据录入日期】'||TO_CHAR(T.LRRQ,'YYYYMMDD')||'【评定日期】'||TO_CHAR(T.PDSJ,'YYYYMMDD')||
              '；【原评定等级】'||KZ.KZNR||'；【调整等级】'||T.DTTZPDGLLB_DM||
              '；【税务机关评定意见】'||T.SWJGPDYJ,
              T.PDSJ,SYSDATE
         FROM HX_CKTS.CKTS_QT_QYGLLBDTTZ_JGB T
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
        INNER JOIN HX_CKTS.CKTS_BA_KZ_JGB KZ ON KZ.DJXH=T.DJXH AND KZ.CKTMSBAKZLX_DM='FLGLCD' AND KZ.YXBZ='Y'
          AND KZ.YXQQ<T.LRRQ AND KZ.YXQZ>=T.LRRQ
        WHERE T.LRRQ>=LD_SJCL_M
          AND COMPUTE_BLDATE(T.PDSJ,T.LRRQ)>=15;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023074401...');
  COMMIT;

  -- 未按规定主动公开一类、四类出口企业名单
  -- 李裕军：目前取不到电子税务局公开信息及时间，该风险暂不取数
  -- 2023074501   事前

  -- 未按规定对管理类别为四类的出口企业，取消无纸化标识
  -- 分类管理等级为D的有效区间与无纸化企业的有效区间有重合，20260209根据新政策取消本指标
  -- 2023074601  X
/*
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023074601',  -- '综合管理类','FLGL-D-WZHQY',
              S.UUID,S.TSSWJG_DM_1,S.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '（分类管理等级为D的有效区间与无纸化企业的有效区间有重合）【分类管理等级】'||S.KZNR||'；【有效期】'||TO_CHAR(S.YXQQ,'YYYYMMDD')||'-'||TO_CHAR(S.YXQZ,'YYYYMMDD')||
              '；【无纸化有效期】'||TO_CHAR(R.YXQQ,'YYYYMMDD')||'-'||TO_CHAR(R.YXQZ,'YYYYMMDD'),
              S.LRRQ,SYSDATE
         FROM HX_CKTS.CKTS_BA_BAXX_JGB T
        INNER JOIN HX_CKTS.CKTS_BA_KZ_JGB S ON S.DJXH=T.DJXH AND S.CKTMSBAKZLX_DM='FLGLCD' AND S.YXBZ='Y' AND S.KZNR='D'
        INNER JOIN HX_CKTS.CKTS_BA_KZ_JGB R ON R.DJXH=T.DJXH AND R.CKTMSBAKZLX_DM='WZHQY' AND R.YXBZ='Y'
           AND R.YXQZ>S.YXQQ AND R.YXQQ<S.YXQZ
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH AND DJ.NSRZT_DM NOT IN ('05','07','08')
        WHERE T.BACHBZ='N' AND S.LRRQ>=LD_SJCL_M;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023074601...');
  COMMIT;
*/

  -- 出口退免税计算方式适用错误
  -- 小规模转一般纳税人后，退免税计算方式未变更
  -- 2023074701   事前
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH XGMZYBNSR AS (
       SELECT T.UUID,T.TSSWJG_DM_1,T.DJXH,T.BARQ,T.CKTSQYLX_DM,T.CKHWTMSJSFF_DM,S.RDYXQQ,
              ROW_NUMBER() OVER (PARTITION BY T.UUID ORDER BY S.RDYXQQ DESC) AS RN
         FROM HX_CKTS.CKTS_BA_BAXX_JGB T
        INNER JOIN HX_RD.RD_YBNSRRDSQSPB S ON S.DJXH=T.DJXH AND S.ZFBZ_1='N' AND S.ZSTYBZ='Y' AND S.XKYNSRBZ='N'
        WHERE T.BACHBZ='N' AND T.CKTSQYLX_DM<>'9' AND T.CKHWTMSJSFF_DM>='3'
          AND COMPUTE_BLDATE(SYSDATE,S.ZSRQ)>=15
       )
       SELECT '2023074701',  -- '综合管理类','BABG-TMSJSFF-WBG',
              XGMZYBNSR.UUID,XGMZYBNSR.TSSWJG_DM_1,XGMZYBNSR.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '（转一般纳税人后，退免税计算方式未变更）【出口企业备案日期】'||TO_CHAR(XGMZYBNSR.BARQ,'YYYYMMDD')||'；【企业类型】'||XGMZYBNSR.CKTSQYLX_DM||
              '；【退(免)税计算方式】'||XGMZYBNSR.CKHWTMSJSFF_DM||'；【转一般纳税人认定日期】'||TO_CHAR(XGMZYBNSR.RDYXQQ,'YYYYMMDD'),
              XGMZYBNSR.RDYXQQ,SYSDATE
         FROM XGMZYBNSR
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=XGMZYBNSR.DJXH
        WHERE XGMZYBNSR.RN=1;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023074701...');
  COMMIT;

  -- 出口退免税计算方式适用错误，生产企业选免退税
  -- 2023074702   X
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023074702',  -- '综合管理类','BABG-TMSJSFF-SCMTS',
              T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '（生产企业选免退税）【出口企业备案日期】'||TO_CHAR(T.BARQ,'YYYYMMDD')||'；【企业类型】'||T.CKTSQYLX_DM||'；【退(免)税计算方式】'||T.CKHWTMSJSFF_DM,
              NVL(T.XGRQ,T.LRRQ),SYSDATE
         FROM HX_CKTS.CKTS_BA_BAXX_JGB T
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
        WHERE T.BACHBZ='N' AND T.CKTSQYLX_DM IN ('1','2') AND T.CKHWTMSJSFF_DM='2';
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023074702...');
  COMMIT;

  -- 出口退免税计算方式适用错误，外贸企业选免抵退
  -- 2023074703   X
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2023074703',  -- '综合管理类','BABG-TMSJSFF-WMMDT',
              T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '（外贸企业选免抵退）【出口企业备案日期】'||TO_CHAR(T.BARQ,'YYYYMMDD')||'；【企业类型】'||T.CKTSQYLX_DM||'；【退(免)税计算方式】'||T.CKHWTMSJSFF_DM,
              NVL(T.XGRQ,T.LRRQ),SYSDATE
         FROM HX_CKTS.CKTS_BA_BAXX_JGB T
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
        WHERE T.BACHBZ='N' AND T.CKTSQYLX_DM='3' AND T.CKHWTMSJSFF_DM='1';
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2023074703...');
  COMMIT;

  -- 不符合第一类视同自产类型的按STZC-01审核
  -- 2024010101  事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2024010101',  -- '申报管理类','SHYD-MDT-STZC',
              T.UUID,T.TSSWJG_DM_1,T.DJXH,T.NSRSBH,T.NSRMC,T.RMBLAJ,T.MDTSE,
              '【所属期】'||T.SSQ||'；【分类管理等级】'||T.CKQYGLLB_DM||'；【纳税信用等级】'||T.PJJB||
              '；【上年度销售额】'||T.SNDXSE||'；【登记日期】'||TO_CHAR(T.DJRQ,'YYYYMMDD'),
              T.FFRQ,SYSDATE
         FROM CKTS_LC_STZC T
        WHERE T.LCZT='11'
          AND T.FFRQ>=LD_SJCL_M;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2024010101...');
  COMMIT;

  -- 对企业尚未申报的出口退税发函调查
  -- 2024020101  事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2024020101',  -- '函调管理类','HD-FAH-XFHHSB',
              FH.FHXXBUUID,FH.FAHDSWJG_DM,FH.GHFDJXH,FH.GHQYNSRSBH,FH.GHFQYMC,FH.JEHJ,FH.SEHJ,
              '【核实函编号】'||FH.WSBH||'；【签发日期】'||TO_CHAR(FH.QFRQ,'YYYYMMDD')||
              '；【供货商税号】'||FH.GHQYNSRSBH_1||'；【发票份数】'||FH.FPFS||
              '；【签发时未申报发票份数】'||FP.FXFS||'；【金额】'||FP.FXJE||'；【税额】'||FP.FXSE,
              FH.QFRQ,SYSDATE
         FROM HX_ZH.ZH_CKTS_FHXXB FH
         INNER JOIN (SELECT FHXXBUUID,COUNT(DISTINCT ZZSZYFPDMHM) AS FXFS,SUM(JE) AS FXJE,SUM(SE) AS FXSE
                       FROM CKTS_HD_XFHHSB
                      GROUP BY FHXXBUUID) FP ON FP.FHXXBUUID=FH.FHXXBUUID;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2024020101...');
  COMMIT;

  -- 以其他方式结束调查评估
  -- 2024060101   事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH YDCL AS (
       SELECT T.LCSLID,MIN(T.UUID) AS UUID,SUM(T.YTSE_1) AS YTSE
         FROM HX_CKTS.CKTS_BL_MTS_SHYDCL_JGB T
        WHERE T.LRRQ>=LD_SJCL_M
          AND T.ZHSHCLYJLX_DM ='4' -- 综合处理意见类型 准予退税
          AND T.QTHCCLYJLX_DM='4' -- 其他处理意见类型 准予退税
          AND TRIM(T.FHBH) IS NULL AND TRIM(T.FHBH_1) IS NULL -- 未进行发函
          AND TRIM(SDHCBGBH) IS NULL -- 未进行实地核查
          AND LENGTH(QTHCNR)<30
        GROUP BY T.LCSLID)
       SELECT '2024060101',  -- '申报管理类','DCPG-QTFS',
              S.UUID,S.TSSWJG_DM_1,S.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,YDCL.YTSE,
              '【所属期批次】'||S.SSQ||S.SBPC||'；【疑点内容1】'||S.YDNR||'；【核查内容1】'||S.QTHCNR,S.LRRQ,SYSDATE
         FROM YDCL
        INNER JOIN HX_CKTS.CKTS_BL_MTS_SHYDCL_JGB S ON S.UUID=YDCL.UUID
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=S.DJXH;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2024060101...');
  COMMIT;

  -- 回函时不相容环节存在兼岗
  -- 2024060201   事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2024060201',  -- '函调管理类','HD-CL-HD-FUH-GWZY',
              H1.FUHXXBUUID,H1.FUHSWJG_DM,F1.GHFDJXH1,F1.GHQYNSRSBH_1,F1.GHFQYMC_1,NULL,NULL,
              '【核实函编号】'||H1.HSHBH||'；【复函编号】'||H1.FHBH||
              '；【联系人代码】'||H1.LXR_DM||'；【审核人代码】'||H1.SHR_DM||'；【签发人代码】'||H1.QFR_DM,
              H1.QFRQ,SYSDATE
         FROM HX_ZH.ZH_CKTS_FUHXXB H1
        INNER JOIN HX_ZH.ZH_CKTS_FHXXB F1 ON F1.FHXXBUUID=H1.FHXXBUUID
        WHERE H1.FUHSWJG_DM LIKE '133%' AND H1.FUHSWJG_DM NOT LIKE '13302%'
          AND NVL(H1.ZFBZ_1,'N')='N'
          AND TRIM(H1.FHBH) IS NOT NULL
          AND H1.QFRQ>=LD_SJCL_M --起始时间限定
          AND (H1.LXR_DM=H1.SHR_DM OR H1.SHR_DM=H1.QFR_DM OR H1.LXR_DM=H1.QFR_DM);
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2024060201...');
  COMMIT;

  -- 对本地管辖企业回复“非本地管辖”
  -- 2025030301   事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2025030301',  -- '函调管理类','HD-FUH-FBDGX',
              H1.FUHXXBUUID,H1.FUHSWJG_DM,F1.GHFDJXH1,F1.GHQYNSRSBH_1,NVL(F1.GHFQYMC_1,DJ.NSRMC),NULL,NULL,
              '【核实函编号】'||H1.HSHBH||'；【复函编号】'||H1.FHBH||
              '；【回函类型】5-非本地管辖；【回函税务机关代码】'||H1.FUHSWJG_DM||'；【企业主管税务局代码】'||DJ.ZGSWJ_DM,
              H1.QFRQ,SYSDATE
         FROM HX_ZH.ZH_CKTS_FUHXXB H1
        INNER JOIN HX_ZH.ZH_CKTS_FHXXB F1 ON F1.FHXXBUUID=H1.FHXXBUUID
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH = F1.GHFDJXH1
          AND DJ.KZZTDJLX_DM = '1110' -- 课征主体登记类型：单位纳税人税务登记
        WHERE H1.FUHSWJG_DM LIKE '133%' AND H1.FUHSWJG_DM NOT LIKE '13302%' --回函税务机关范围：浙江，不包括宁波
          AND H1.FHLX_DM = '5' --回函非本地管辖
          AND NVL(H1.ZFBZ_1,'N')='N'
          AND TRIM(H1.FHBH) IS NOT NULL
          AND H1.QFRQ>=LD_SJCL_M --起始时间限定
          AND SUBSTR(DJ.ZGSWJ_DM, 1, 7) = SUBSTR(H1.FUHSWJG_DM, 1, 7) --主管税务机关与回函税务机关前7位一致
          AND EXISTS (SELECT 1
                        FROM HX_RD.RD_NSRZGXX_JGB ZG --取一般纳税人资格
                       WHERE ZG.DJXH = DJ.DJXH
                         AND ZG.NSRZGLX_DM='201'
                         AND ZG.YXQQ <= H1.QFRQ
                         AND ZG.YXQZ > H1.QFRQ
                         AND ZG.QXBZ = 'N');
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2025030301...');
  COMMIT;

  -- 违规选择“暂缓办理退（免）税”复函
  -- 2025050101   事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2025050101',  -- '函调管理类','HD-FUH-ZHBLTS',
              H1.FUHXXBUUID,H1.FUHSWJG_DM,F1.GHFDJXH1,F1.GHQYNSRSBH_1,F1.GHFQYMC_1,F1.JEHJ,F1.SEHJ,
              '【核实函编号】'||H1.HSHBH||'；【复函编号】'||H1.FHBH||
              '；【风险描述】“4-暂缓办理退（免）税”复函签发日期之前，供货企业无稽查立案信息。',
              H1.QFRQ,SYSDATE
         FROM HX_ZH.ZH_CKTS_FUHXXB H1
        INNER JOIN HX_ZH.ZH_CKTS_FHXXB F1 ON F1.FHXXBUUID=H1.FHXXBUUID
        WHERE H1.FUHSWJG_DM LIKE '133%' AND H1.FUHSWJG_DM NOT LIKE '13302%' --回函税务机关范围：浙江，不包括宁波
          AND H1.FHLX_DM = '4' --回函“暂缓办理退（免）税”
          AND NVL(H1.ZFBZ_1,'N')='N'
          AND TRIM(H1.FHBH) IS NOT NULL
          AND H1.QFRQ>=LD_SJCL_Y --起始时间限定
          AND NOT EXISTS (SELECT 1 --签发日期供货企业不存在立案未结案的稽查信息
                            FROM HX_JC.JC_AJXX AJ
                           WHERE AJ.DJXH = F1.GHFDJXH1
                             AND NVL(AJ.ZFBZ_1, 'N') = 'N'
                             AND AJ.LARQ < H1.QFRQ AND NVL(AJ.JARQ, SYSDATE) > H1.QFRQ);
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2025050101...');
  COMMIT;

  -- 未按规定期限对“暂缓办理退（免）税”函件重新复函
  -- 2025050201   事前
  -- 结案日期满一个月
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2025050201',  -- '函调管理类','HD-FUH-QXZHBLTS',
              H1.FUHXXBUUID,H1.FUHSWJG_DM,F1.GHFDJXH1,F1.GHQYNSRSBH_1,F1.GHFQYMC_1,F1.JEHJ,F1.SEHJ,
              '【核实函编号】'||H1.HSHBH||'；【复函编号】'||H1.FHBH||'；【稽查结案日期】'||TO_CHAR(AJ.JARQ,'YYYY-MM-DD')||
              '；【风险描述】供货企业稽查接案后一个月，未对“暂缓办理退（免）税”函件重新复函。',
              AJ.JARQ,SYSDATE
         FROM HX_ZH.ZH_CKTS_FUHXXB H1
        INNER JOIN HX_ZH.ZH_CKTS_FHXXB F1 ON F1.FHXXBUUID=H1.FHXXBUUID
        INNER JOIN HX_JC.JC_AJXX AJ ON AJ.DJXH = F1.GHFDJXH1
          AND AJ.LARQ < H1.QFRQ AND H1.QFRQ < AJ.JARQ
          AND NVL(AJ.ZFBZ_1, 'N') = 'N'
        WHERE H1.FUHSWJG_DM LIKE '133%' AND H1.FUHSWJG_DM NOT LIKE '13302%' --回函税务机关范围：浙江，不包括宁波
          AND H1.FHLX_DM = '4' --回函“暂缓办理退（免）税”
          AND NVL(H1.ZFBZ_1,'N')='N'
          AND TRIM(H1.FHBH) IS NOT NULL
          AND AJ.JARQ>=LD_SJCL_Y --起始时间限定
          AND AJ.JARQ<=ADD_MONTHS(SYSDATE,-1)
          AND NOT EXISTS (SELECT 1 --“暂缓办理退（免）税”函件签发以后不存在明确意见的复函
                            FROM HX_ZH.ZH_CKTS_FUHXXB H2
                           WHERE H2.FHXXBUUID=F1.FHXXBUUID
                             AND H2.FHLX_DM IN ('1','2')
                             AND TRIM(H2.FHBH) IS NOT NULL
                             AND NVL(H2.ZFBZ_1,'N')='N'
                             AND H2.QFRQ>H1.QFRQ);
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2025050201...');
  COMMIT;

  -- 回函签发日期在发函签发日期以后5个工作日内
  -- 2025050301   事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2025050301',  -- '函调管理类','HD-FUH-WGGZRNWC',
              H1.FUHXXBUUID,H1.FUHSWJG_DM,F1.GHFDJXH1,F1.GHQYNSRSBH_1,F1.GHFQYMC_1,F1.JEHJ,F1.SEHJ,
              '【核实函编号】'||H1.HSHBH||'；【复函编号】'||H1.FHBH||
              '；【核实函签发日期】'||TO_CHAR(F1.QFRQ,'YYYYMMDD')||'；【回函签发日期】'||TO_CHAR(H1.QFRQ,'YYYYMMDD')||
              '；【风险描述】回函签发日期在发函签发日期以后5个工作日内。',
              H1.QFRQ,SYSDATE
         FROM HX_ZH.ZH_CKTS_FUHXXB H1
        INNER JOIN HX_ZH.ZH_CKTS_FHXXB F1 ON F1.FHXXBUUID=H1.FHXXBUUID
        WHERE H1.FUHSWJG_DM LIKE '133%' AND H1.FUHSWJG_DM NOT LIKE '13302%' --回函税务机关范围：浙江，不包括宁波
          AND NVL(H1.FHLX_DM,'3')<>'5'
          AND NVL(H1.ZFBZ_1,'N')='N'
          AND TRIM(H1.FHBH) IS NOT NULL
          AND H1.QFRQ>=LD_SJCL_Y --起始时间限定
          AND COMPUTE_BLDATE(H1.QFRQ,F1.QFRQ)<=5;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2025050301...');
  COMMIT;

  -- 审核疑点处理时，针对不同供货商采用同一份核实函编号
  -- 2025050401   事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH YDMX AS (
       SELECT QD.UUID,QD.LCSLID,QD.DJXH,QD.SSQ,QD.MXSBXH,QD.XHFNSRSBH,QD.XHFNSRMC,QD.KPRQ,YD.MDTSE,YD.YDNR,YD.FHBH,YD.FHBH_1
         FROM HX_CKTS.CKTS_SB_MDT_STZCQD_JGB QD
        INNER JOIN HX_CKTS.CKTS_BL_MDT_SHYDCL_JGB YD ON QD.DJXH=YD.DJXH AND QD.SSQ=YD.SSQ AND QD.MXSBXH=YD.SBXH
        WHERE YD.XGRQ>=LD_SJCL_Y --起始时间限定
          AND TRIM(YD.FHBH) IS NOT NULL)
       SELECT '2025050401',  -- '函调管理类','HD-FAH-BTGHSXTFAH',
              F1.FHXXBUUID, F1.FAHDSWJG_DM, F1.GHFDJXH, F1.GHQYNSRSBH, F1.GHFQYMC, NULL, SUM(YDMX.MDTSE),
              '【疑点所属期批次】'||YDMX.SSQ||'，【核实函编号】'||YDMX.FHBH||
              '；【风险描述】审核疑点处理表，针对不同供货商采用同一份核实函编号。',
              F1.QFRQ,SYSDATE
         FROM YDMX
        INNER JOIN HX_ZH.ZH_CKTS_FHXXB F1 ON F1.WSBH=YDMX.FHBH
        GROUP BY F1.FHXXBUUID, F1.FAHDSWJG_DM, F1.GHFDJXH, F1.GHQYNSRSBH, F1.GHFQYMC, YDMX.SSQ, YDMX.FHBH, F1.QFRQ
       HAVING COUNT(DISTINCT YDMX.XHFNSRSBH) > 1;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2025050401...');
  COMMIT;
  -- 2025050402   事中
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
         WITH YDMX AS (
       SELECT QD.UUID,QD.LCSLID,QD.DJXH,QD.SSQ,QD.SBPC,QD.SBXH,QD.GHFNSRSBH_1,QD.KPRQ,QD.TSE,YD.YDNR,YD.FHBH,YD.FHBH_1
         FROM HX_CKTS.CKTS_SB_MTS_TSJH_JGB QD
        INNER JOIN HX_CKTS.CKTS_BL_MTS_SHYDCL_JGB YD ON QD.DJXH=YD.DJXH AND QD.GLH=YD.GLH AND QD.SBXH=YD.SBXH
        WHERE YD.XGRQ>=LD_SJCL_Y --起始时间限定
          AND TRIM(YD.FHBH) IS NOT NULL)
       SELECT '2025050402',  -- '函调管理类','HD-FAH-BTGHSXTFAH',
              F1.FHXXBUUID, F1.FAHDSWJG_DM, F1.GHFDJXH, F1.GHQYNSRSBH, F1.GHFQYMC, NULL, SUM(YDMX.TSE),
              '【疑点所属期批次】'||YDMX.SSQ||YDMX.SBPC||'，【核实函编号】'||YDMX.FHBH||
              '；【风险描述】审核疑点处理表，针对不同供货商采用同一份核实函编号。',
              F1.QFRQ,SYSDATE
         FROM YDMX
        INNER JOIN HX_ZH.ZH_CKTS_FHXXB F1 ON F1.WSBH=YDMX.FHBH
        GROUP BY F1.FHXXBUUID, F1.FAHDSWJG_DM, F1.GHFDJXH, F1.GHQYNSRSBH, F1.GHFQYMC, YDMX.SSQ, YDMX.SBPC, YDMX.FHBH, F1.QFRQ
       HAVING COUNT(DISTINCT YDMX.GHFNSRSBH_1) > 1;
  INSERT INTO CKTS_LOG_DEALDATA(CZJL) VALUES ('2025050402...');
  COMMIT;

  -- 四类企业首次申报跨大类（海关编码前4位）商品
  -- 2025090101   事中

  -- 9810业务非预退税申报
  -- 2025090201   事中

  -- 供货企业发函未回
  -- 2025090301   事中

  -- 二十、申报的发票征收率大于该发票电子信息中计算的征收率
  -- 2025090401   X
  INSERT INTO FXNK_NBFXDMX_SH(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,FSSJ,SJTBSJ)
       SELECT '2025090401',  -- '申报管理类','SHYD-CLYJQS-MTS',
              T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,JH.JSJE,JH.TSE,
              '【所属期-批次】'||T.SSQ||'-'||T.SBPC||'；【申报序号】'||T.SBXH||'；【关联号】'||T.GLH||'；【录入人】'||RY.SWRYXM||
              '；【疑点编号】'||T.YDBH||'；【疑点内容】'||T.YDNR||'；【处理意见说明】'||T.CLYJSM,
              COALESCE(T.CLSJ,T.XGRQ),SYSDATE
         FROM HX_CKTS.CKTS_BL_MTS_SHYD_JGB T
        INNER JOIN HX_DM_ZDY.DM_GY_SWRY RY
           ON RY.SWRY_DM=T.LRR_DM
        INNER JOIN HX_DJ.DJ_NSRXX DJ 
           ON DJ.DJXH=T.DJXH
        INNER JOIN HX_CKTS.CKTS_SB_MTS_TSJH_JGB JH
           ON JH.DJXH=T.DJXH AND JH.GLH=T.GLH AND JH.SBXH=T.SBXH
        INNER JOIN HX_CKTS.CKTS_WBSJ_FP_ZZSZYFPXX FP
           ON FP.DJXH=T.DJXH AND FP.JHPZH=JH.JHPZH
        WHERE T.LRRQ>=LD_SJCL_M --起始时间限定
          AND T.SHYDCL_DM='02' -- 挑过的
          AND T.YDBH='A0230'
          AND JH.TSE>0
          AND ROUND(FP.FPZJE * JH.ZSSL /100,2) >FP.FPZSE;
  COMMIT;
  
  UPDATE FXNK_NBFXDMX_SH T
     SET T.SWJGDM='13306920000'
   WHERE T.SWJGDM='13306029200';
  COMMIT;
  
  RETURN;
END;
/

prompt
prompt Creating procedure PRO_DEAL_FXNK_NBFXDMX_SQ
prompt ===========================================
prompt
CREATE OR REPLACE PROCEDURE PRO_DEAL_FXNK_NBFXDMX_SQ
/*
 * 风险内控的事前预警
 */
AS
BEGIN
  -- 内部风险点明细
  EXECUTE IMMEDIATE 'TRUNCATE TABLE FXNK_NBFXDMX_SQ';
  COMMIT;

  -- 办理特殊核准退税业务
  -- 2023050101   事中

  -- 不相容环节存在兼岗
  -- 2023050201   事中
  -- 2023050204   事中

  -- 备案撤回未结清税款
  -- 2023050301   事中
  -- 2023050302   事中
  -- 2023050303   事中

  -- 平均办理时限超期
  -- 2023050401   X
  -- 2023050402   X

  -- 逾期办结出口退（免）税
  -- 2023050403   单独短信提醒

  -- 未在规定期限内完成分类管理年度评定（按年统计）
  -- 2023050501   事前
  -- 纳税信用评定后25天
  INSERT INTO FXNK_NBFXDMX_SQ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,CJSJ)
       SELECT '2023050501',  -- '综合管理类','FLGL-X-NDPD',
              T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【纳税信用等级评定时间】'||TO_CHAR(S.FBSJ,'YYYYMMDD')||'；【评定结果】'||S.PJJB,
              SYSDATE
         FROM HX_CKTS.CKTS_QT_QYGLLBPD_GCB T
        INNER JOIN HX_CKTS.CKTS_BA_BAXX_JGB BA ON BA.DJXH=T.DJXH AND NVL(BA.BACHBZ,'N')='N'
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH AND DJ.NSRZT_DM NOT IN ('05','07','08')
        INNER JOIN FXNK_JC2B_NSXYPJ S ON S.DJXH=T.DJXH AND S.PJND=T.SSND AND S.PJJB<>'M'
        WHERE T.HZSJ IS NULL --尚未核准
          AND SYSDATE>=S.FBSJ+25
          AND NOT EXISTS (SELECT 1
                            FROM HX_CKTS.CKTS_QT_QYGLLBPD_JGB PRE
                           WHERE PRE.DJXH=T.DJXH AND PRE.LRRQ>=TRUNC(T.LRRQ,'YY') AND PRE.LRRQ<T.LRRQ);
  COMMIT;

  -- 一类、二类企业被立案查处尚未结案的，未按规定将出口企业暂按三类管理
  -- 2023050601   事前
  -- 立案未满20个工作日的数据
  INSERT INTO FXNK_NBFXDMX_SQ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,CJSJ)
         WITH JCLAQY AS (
       SELECT BA.TSSWJG_DM_1,BA.DJXH,AJ.JCAJXXUUID,AJ.LARQ,AJ.AJMC,TO_CHAR(SUBSTR(SQ.XAFXJLAYJ,1,500)) AS LAYJ
         FROM HX_CKTS.CKTS_BA_BAXX_JGB BA
        INNER JOIN HX_JC.JC_AYXX AY ON AY.DJXH = BA.DJXH
        INNER JOIN HX_JC.JC_LASQB SQ ON SQ.JCAYXXUUID = AY.JCAYXXUUID
        INNER JOIN HX_JC.JC_AJXX AJ ON AJ.JCAJXXUUID = AY.JCAJXXUUID
        WHERE COMPUTE_BLJZDATE('D',AJ.LARQ)>=SYSDATE
          AND AJ.JARQ IS NULL --未结案
          AND AJ.ZFBZ_1 = 'N' --未作废
          AND (REGEXP_LIKE(AJ.AJMC,'骗税') OR REGEXP_LIKE(SQ.XAFXJLAYJ,'骗税|骗取')) --案件名称含“骗税”或立案原因含“骗税”、“骗取”
       )
       SELECT '2023050601',  -- '综合管理类','FLGL-C-JCLAQY',
              JCLAQY.JCAJXXUUID,JCLAQY.TSSWJG_DM_1,JCLAQY.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【稽查立案日期】'||TO_CHAR(JCLAQY.LARQ,'YYYYMMDD')||
              '；【当前分类管理类别】'||A.KZNR||'；【有效期起止】'||TO_CHAR(A.YXQQ,'YYYYMMDD')||'-'||TO_CHAR(A.YXQZ,'YYYYMMDD'),
              SYSDATE
        FROM JCLAQY
       INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=JCLAQY.DJXH
       INNER JOIN HX_CKTS.CKTS_BA_KZ_JGB A ON A.DJXH=JCLAQY.DJXH AND A.CKTMSBAKZLX_DM='FLGLCD' AND A.YXBZ='Y'
         AND SYSDATE>=A.YXQQ AND SYSDATE<=A.YXQZ
       WHERE A.KZNR IN ('A','B');
  COMMIT;

  -- 稽查结案后有违反出口退(免)税有关规定的，未按规定将出口企业调整为四类管理
  -- 2023050602   事前
  -- 结案未满20个工作日的数据
  INSERT INTO FXNK_NBFXDMX_SQ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,CJSJ)
         WITH JCJAQY AS (
       SELECT S.TSSWJG_DM_1,S.UUID,S.DJXH,S.JARQ
         FROM HX_CKTS.CKTS_QT_CKQYAYGLTZ_GCB S
        INNER JOIN HX_CKTS.CKTS_BA_BAXX_JGB BA ON BA.DJXH=S.DJXH AND NVL(BA.BACHBZ,'N')='N'
        WHERE COMPUTE_BLJZDATE('D',S.JARQ)>=SYSDATE
          AND TRIM(S.CKQYAYGLTZCFYY_DM) IS NOT NULL
        UNION ALL
       SELECT S.TSSWJG_DM_1,S.UUID,S.DJXH,S.JARQ
         FROM HX_CKTS.CKTS_QT_CKQYAYGLTZ_JGB S
        INNER JOIN HX_CKTS.CKTS_BA_BAXX_JGB BA ON BA.DJXH=S.DJXH AND NVL(BA.BACHBZ,'N')='N'
        WHERE COMPUTE_BLJZDATE('D',S.JARQ)>=SYSDATE
          AND TRIM(S.CKQYAYGLTZCFYY_DM) IS NOT NULL
       )
       SELECT '2023050602',  -- '综合管理类','FLGL-D-JCJAQY',
              JCJAQY.UUID,JCJAQY.TSSWJG_DM_1,JCJAQY.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【稽查结案日期】'||TO_CHAR(JCJAQY.JARQ,'YYYYMMDD')||
              '；【当前分类管理类别】'||A.KZNR||'；【有效期起止】'||TO_CHAR(A.YXQQ,'YYYYMMDD')||'-'||TO_CHAR(A.YXQZ,'YYYYMMDD'),
              SYSDATE
        FROM JCJAQY
       INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=JCJAQY.DJXH
       INNER JOIN HX_CKTS.CKTS_BA_KZ_JGB A ON A.DJXH=JCJAQY.DJXH AND A.CKTMSBAKZLX_DM='FLGLCD' AND A.YXBZ='Y'
         AND SYSDATE>=A.YXQQ AND SYSDATE<=A.YXQZ
       WHERE A.KZNR<>'D';
  COMMIT;

  -- 稽查结案后，税务行政处罚违法事实含'%出口%骗税%'字眼的，未按规定将出口企业调整为四类管理
  -- 2023050603   事前
  -- 结案未满20个工作日的数据
  INSERT INTO FXNK_NBFXDMX_SQ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,CJSJ)
         WITH JCJAQY AS (
       SELECT BA.TSSWJG_DM_1,BA.UUID,BA.DJXH,TRUNC(CF.WSZZRQ) AS JARQ
         FROM HX_CKTS.CKTS_BA_BAXX_JGB BA
        INNER JOIN HX_JC.JC_AJXX AJ ON AJ.DJXH=BA.DJXH
        INNER JOIN HX_FZ.FZ_SWXZCFJDS CF ON CF.SSWFXWDJUUID=AJ.JCAJXXUUID AND NVL(CF.ZFBZ_1,'N')='N'
        WHERE COMPUTE_BLJZDATE('D',CF.WSZZRQ)>=SYSDATE
          AND CF.WFSS LIKE '%出口%骗税%'
          AND NVL(BA.BACHBZ,'N')='N'
       )
       SELECT '2023050603',  -- '综合管理类','FLGL-D-SWXZCF',
              JCJAQY.UUID,JCJAQY.TSSWJG_DM_1,JCJAQY.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【税务行政处罚日期】'||TO_CHAR(JCJAQY.JARQ,'YYYYMMDD')||
              '；【当前分类管理类别】'||A.KZNR||'；【有效期起止】'||TO_CHAR(A.YXQQ,'YYYYMMDD')||'-'||TO_CHAR(A.YXQZ,'YYYYMMDD'),
              SYSDATE
        FROM JCJAQY
       INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=JCJAQY.DJXH
       INNER JOIN HX_CKTS.CKTS_BA_KZ_JGB A ON A.DJXH=JCJAQY.DJXH AND A.CKTMSBAKZLX_DM='FLGLCD' AND A.YXBZ='Y'
         AND SYSDATE>=A.YXQQ AND SYSDATE<=A.YXQZ
       WHERE A.KZNR<>'D';
  COMMIT;

  -- 未按规定将停止出口退税权纳税人的分类管理类别调整为四类
  -- 2023050701   事前，事中
  -- 停权有效期起未满15个工作日的数据
  INSERT INTO FXNK_NBFXDMX_SQ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,CJSJ)
       SELECT '2023050701',  -- '综合管理类','FLGL-D-TQQY',
              FLGL.UUID,BA.TSSWJG_DM_1,BA.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【停权有效期起止】'||TO_CHAR(TQQY.YXQQ,'YYYYMMDD')||'-'||TO_CHAR(TQQY.YXQZ,'YYYYMMDD')||
              '；【当前分类管理类别】'||FLGL.KZNR||'；【有效期起止】'||TO_CHAR(FLGL.YXQQ,'YYYYMMDD')||'-'||TO_CHAR(FLGL.YXQZ,'YYYYMMDD'),
              SYSDATE
         FROM HX_CKTS.CKTS_BA_BAXX_JGB BA
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=BA.DJXH
        INNER JOIN HX_CKTS.CKTS_BA_KZ_JGB TQQY ON TQQY.DJXH=BA.DJXH AND TQQY.CKTMSBAKZLX_DM='TQQY' AND TQQY.YXBZ='Y'
          AND COMPUTE_BLJZDATE('C',TQQY.YXQQ)>=SYSDATE
        INNER JOIN HX_CKTS.CKTS_BA_KZ_JGB FLGL ON FLGL.DJXH=BA.DJXH AND FLGL.CKTMSBAKZLX_DM='FLGLCD' AND FLGL.YXBZ='Y'
          AND FLGL.KZNR<>'D' AND SYSDATE>=FLGL.YXQQ AND SYSDATE<=FLGL.YXQZ
        WHERE NVL(BA.BACHBZ,'N')='N';
  COMMIT;

  -- 四类出口企业自评定之日起，未满12个月违规被评定为其他管理类别
  -- 2023050801  事中

  -- 两次发生税收违法行为的出口企业未调整适用免税政策
  -- 2023050901  事中

  -- 从异常供货企业采购的进货明细，连续12个月内申报退税额大于200万
  -- 2023051001  X

  -- 从异常供货企业采购的进货明细，连续12个月内申报退税额占这12个月全部申报退税额30%以上
  -- 2023051002  X

  -- 主管税务机关未按照“容缺办理”的原则办理且未按照规定开展实地核查
  -- 2023051101  X

  -- 出口企业首次申报出口退（免）税，已按照“容缺办理”的原则办理但未按规定补充完成实地核查。
  -- 2023051102  单独短信提醒

  -- 实地核查超15个工作日, 20240614根据总局督查结果增加
  -- 2023051103  事前
  INSERT INTO FXNK_NBFXDMX_SQ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,CJSJ)
         WITH SDHC AS (
       SELECT LC.UUID,LC.LCSLID,LC.TSSWJG_DM_1,LC.DJXH,SDHC.HCYY,COALESCE(MX1.TSSJ,MX2.TSSJ) TSSJ,
              ROW_NUMBER() OVER(PARTITION BY LC.LCSLID ORDER BY MX2.TSSJ DESC) SN
         FROM HX_CKTS.CKTS_TY_YWBLXX LC
        INNER JOIN (SELECT LCSLID,LISTAGG(HCYYMC, '||') WITHIN GROUP(ORDER BY HCYY_DM) HCYY
                      FROM (SELECT LCSLID,SD.HCYY_DM,HCYY.HCYYMC
                              FROM HX_CKTS.CKTS_SDHC_SDHC_GCB SD
                              LEFT JOIN HX_DM_ZDY.DM_CKTS_HCYY HCYY ON SD.HCYY_DM = HCYY.HCYY_DM
                             GROUP BY LCSLID,SD.HCYY_DM,HCYY.HCYYMC)
                     GROUP BY LCSLID) SDHC
           ON SDHC.LCSLID=LC.LCSLID
         LEFT JOIN HX_CKTS.CKTS_TY_TSSBYWBL_MXB MX1 ON MX1.LCSLID=LC.LCSLID AND MX1.LCHJ_DM = '05' AND MX1.TS_RYDM IS NOT NULL
         LEFT JOIN HX_CKTS.CKTS_TY_TSSBYWBL_MXB MX2 ON MX2.LCSLID=LC.LCSLID AND MX2.LCHJ_DM = '08' AND MX2.TS_RYDM IS NOT NULL
        WHERE LC.LCSWSX_DM = 'LCSXA082025001' AND NVL(LC.ZFBZ_1,'N')='N' AND NVL(LC.FFBZ,'N')='N'
          AND COMPUTE_BLDATE(SYSDATE,COALESCE(MX1.TSSJ,MX2.TSSJ))>15)
       SELECT '2023051103',  -- '申报管理类','SDHC-CQ',
              SDHC.UUID,SDHC.TSSWJG_DM_1,SDHC.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【实地核查原因】'||SDHC.HCYY||'；【推送时间】'||TO_CHAR(SDHC.TSSJ,'YYYYMMDD'),SYSDATE
         FROM SDHC
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=SDHC.DJXH
        WHERE SDHC.SN=1;

  -- 实地核查报告核查人员少于2人
  -- 2023051201  事中

  -- 复函实地核查后未制作工作底稿
  -- 2023051202  事中

  -- 未按规定对先退税后核销业务开展实地核查（按年统计）
  -- 2023051301  事前
  -- 每年6月份开始提醒
  INSERT INTO FXNK_NBFXDMX_SQ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,CJSJ)
         WITH XTHHQY AS (
       SELECT SB.DJXH, MIN(SB.UUID) AS UUID, MIN(SB.LRRQ) AS SBRQ, SUM(SB.RMBLAJ) AS RMBLAJ, SUM(SB.MDTSE) AS MDTSE
         FROM HX_CKTS.CKTS_SB_MDT_XTHH_JGB SB
        WHERE SB.LRRQ>=TRUNC(ADD_MONTHS(SYSDATE,-1),'YY')
          AND SYSDATE>=ADD_MONTHS(TRUNC(ADD_MONTHS(SYSDATE,-1),'YY'),5) --系统日期大于等于当年6月1日后开始检测
        GROUP BY SB.DJXH
       )
       SELECT '2023051301',  -- '申报管理类','SDHC-XTHH',
              XTHHQY.UUID,BA.TSSWJG_DM_1,BA.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,XTHHQY.RMBLAJ,XTHHQY.MDTSE,
              '【企业当年首次申报先退税后核销业务日期】'||TO_CHAR(XTHHQY.SBRQ,'YYYYMMDD'),SYSDATE
         FROM XTHHQY
        INNER JOIN HX_CKTS.CKTS_BA_BAXX_JGB BA ON BA.DJXH=XTHHQY.DJXH
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=XTHHQY.DJXH
        WHERE NOT EXISTS (SELECT 1
                            FROM HX_CKTS.CKTS_SDHC_SDHCBG_JGB SDHC
                           WHERE SDHC.DJXH=XTHHQY.DJXH
                             AND SDHC.HCYYSM LIKE '%08—生产企业实行先退税后核销%'
                             AND SDHC.LRRQ>=TRUNC(ADD_MONTHS(SYSDATE,-1),'YY'));
  COMMIT;

  -- 未按规定对超期申报进料加工核销进行处罚
  -- 2023051401  事中

  -- 未按规定对四类出口企业申报的出口退（免）税发函调查
  -- 2023051501  事中

  -- 未按规定对不予退税函件追溯发函
  -- 2023051601   事前
  -- 回函未满15个工作日的数据
  INSERT INTO FXNK_NBFXDMX_SQ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,CJSJ)
         WITH BYTSFUH AS (
       SELECT FH.FHXXBUUID,FH.WSBH,FH.FAHDSWJG_DM,FH.GHFDJXH,FH.GHQYNSRSBH,FH.GHFQYMC,FH.GHQYNSRSBH_1,MIN(FP.KJRQ) AS KJRQ,MAX(FUH.QFRQ) AS QFRQ
         FROM HX_ZH.ZH_CKTS_FUHXXB FUH
        INNER JOIN HX_ZH.ZH_CKTS_FHXXB FH ON FH.FHXXBUUID=FUH.FHXXBUUID
        INNER JOIN HX_ZH.ZH_CKTS_HDFPQD FP ON FP.FHXXBUUID=FH.FHXXBUUID
        WHERE FH.FAHDSWJG_DM LIKE '133%' AND FH.FAHDSWJG_DM NOT LIKE '13302%'
          AND FH.DZBZDSZL_DM='BDA1320284' -- 发函文书种类
          AND DBMS_LOB.INSTR(FH.YDXSJTNR,'追溯')=0 -- 剔除追溯发函，总局督察条件
          AND COMPUTE_BLJZDATE('C',FUH.QFRQ)>=SYSDATE
          AND NVL(FUH.ZFBZ_1,'N')='N'
          AND FUH.FHLX_DM='2' -- 不予退税回函
          AND NOT EXISTS (SELECT 1 --不存在不予改准予的回函
                            FROM HX_ZH.ZH_CKTS_FUHXXB H2
                           WHERE H2.FHXXBUUID=FUH.FHXXBUUID AND NVL(H2.ZFBZ_1,'N')='N' AND H2.FHLX_DM='1' AND TRIM(H2.FHBH) IS NOT NULL
                             AND H2.QFRQ>FUH.QFRQ)
        GROUP BY FH.FHXXBUUID,FH.WSBH,FH.FAHDSWJG_DM,FH.GHFDJXH,FH.GHQYNSRSBH,FH.GHFQYMC,FH.GHQYNSRSBH_1
       ),
         LSJH AS (
       SELECT BYTSFUH.GHFDJXH,BYTSFUH.GHQYNSRSBH_1,JGB.JHPZH,JGB.JSJE,JGB.TSE
         FROM BYTSFUH
        INNER JOIN HX_CKTS.CKTS_SB_MTS_TSJH_JGB JGB
           ON JGB.DJXH=BYTSFUH.GHFDJXH AND JGB.GHFNSRSBH_1=BYTSFUH.GHQYNSRSBH_1
          AND JGB.KPRQ>=ADD_MONTHS(BYTSFUH.KJRQ,-12) AND JGB.KPRQ<BYTSFUH.KJRQ
          AND NVL(JGB.BYBLBZ,'N')='N' AND NVL(JGB.BYTSBZ,'N')='N'
        UNION ALL
       SELECT BYTSFUH.GHFDJXH,BYTSFUH.GHQYNSRSBH_1,LB.JHPZH,LB.JSJE,LB.TSE
         FROM BYTSFUH
        INNER JOIN HX_CKTS.CKTS_SB_MTS_TSJH_LB LB
           ON LB.DJXH=BYTSFUH.GHFDJXH AND LB.GHFNSRSBH_1=BYTSFUH.GHQYNSRSBH_1
          AND LB.KPRQ>=ADD_MONTHS(BYTSFUH.KJRQ,-12) AND LB.KPRQ<BYTSFUH.KJRQ
          AND NVL(LB.BYBLBZ,'N')='N' AND NVL(LB.BYTSBZ,'N')='N'
	   )
       SELECT '2023051601',  -- '函调管理类','HD-FAH-BYTS',
              BYTSFUH.FHXXBUUID,BYTSFUH.FAHDSWJG_DM,BYTSFUH.GHFDJXH,BYTSFUH.GHQYNSRSBH,BYTSFUH.GHFQYMC,SUM(LSJH.JSJE),SUM(LSJH.TSE),
              '【文书编号】'||BYTSFUH.WSBH||'；【供货方税号】'||BYTSFUH.GHQYNSRSBH_1||'；【复函所列增值税专用发票的最早开票日期】'||TO_CHAR(BYTSFUH.KJRQ,'YYYYMMDD'),
              SYSDATE
         FROM BYTSFUH
        INNER JOIN LSJH
           ON LSJH.GHFDJXH=BYTSFUH.GHFDJXH AND LSJH.GHQYNSRSBH_1=BYTSFUH.GHQYNSRSBH_1
        WHERE NOT EXISTS (SELECT 1
                            FROM HX_ZH.ZH_CKTS_HDFPQD QD
                           WHERE QD.GHFNSRSBH_1=LSJH.GHQYNSRSBH_1 AND QD.ZZSZYFPDMHM=LSJH.JHPZH AND NVL(QD.ZFBZ_1,'N')='N')
        GROUP BY BYTSFUH.FHXXBUUID,BYTSFUH.WSBH,BYTSFUH.FAHDSWJG_DM,BYTSFUH.GHFDJXH,BYTSFUH.GHQYNSRSBH,BYTSFUH.GHFQYMC,BYTSFUH.GHQYNSRSBH_1,TO_CHAR(BYTSFUH.KJRQ,'YYYYMMDD'),BYTSFUH.QFRQ
       HAVING SUM(LSJH.JSJE)>0;
  COMMIT;

  -- 未按规定对非本地区管辖的函件重新发函
  -- 2023051701   事前
  -- 回函未满15个工作日的数据
  INSERT INTO FXNK_NBFXDMX_SQ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,CJSJ)
         WITH FBDFUH AS (
       SELECT FH.FHXXBUUID,FH.WSBH,FH.FAHDSWJG_DM,FH.GHFDJXH,FH.GHQYNSRSBH,FH.GHFQYMC,FH.GHQYNSRSBH_1,FH.QFRQ AS FHRQ,FUH.QFRQ AS FUHRQ,FUH.FHCLRQ,
              ROW_NUMBER() OVER (PARTITION BY FH.FHXXBUUID ORDER BY FUH.QFRQ DESC) RN
         FROM HX_ZH.ZH_CKTS_FUHXXB FUH
        INNER JOIN HX_ZH.ZH_CKTS_FHXXB FH ON FH.FHXXBUUID=FUH.FHXXBUUID
          AND NVL(FH.ZFBZ_1,'N')='N'
        WHERE FH.FAHDSWJG_DM LIKE '133%' AND FH.FAHDSWJG_DM NOT LIKE '13302%'
          AND COMPUTE_BLJZDATE('C',FUH.QFRQ)>=SYSDATE
          AND NVL(FUH.ZFBZ_1,'N')='N'
          AND FUH.FHLX_DM='5' --复函类型为“非本地区管辖”
       )
       SELECT '2023051701',  -- '函调管理类','HD-FAH-FBDGX',
              FBDFUH.FHXXBUUID,FBDFUH.FAHDSWJG_DM,FBDFUH.GHFDJXH,FBDFUH.GHQYNSRSBH,FBDFUH.GHFQYMC,NULL,NULL,
              '【文书编号】'||FBDFUH.WSBH||'；【供货方税号】'||FBDFUH.GHQYNSRSBH_1||
              '；【发函日期】'||TO_CHAR(FBDFUH.FHRQ,'YYYYMMDD')||'；【回函日期】'||TO_CHAR(FBDFUH.FUHRQ,'YYYYMMDD'),
              SYSDATE
         FROM FBDFUH
        WHERE RN=1
          AND NOT EXISTS (SELECT 1
                            FROM HX_ZH.ZH_CKTS_FHXXB A
                           WHERE A.GHFDJXH=FBDFUH.GHFDJXH AND A.GHQYNSRSBH_1=FBDFUH.GHQYNSRSBH_1 AND A.WSBH<>FBDFUH.WSBH
                             AND A.QFRQ>FBDFUH.FHRQ AND A.QFRQ<ADD_MONTHS(NVL(FBDFUH.FHCLRQ,FBDFUH.FUHRQ),2) AND NVL(A.ZFBZ_1,'N')='N');
  COMMIT;

  -- 未在规定期限内复函
  -- 2023051801  单独短信提醒

  -- 违规对正在接受纳税评估、稽查的供货企业按“正常业务”复函
  -- 2023051901  事中

  -- 未核查供货企业发票为虚开或伪造，违规按“正常业务”类型复函
  -- 2023052001  X

  -- 无合理理由再次复函改变原复函类型
  -- 2023052101  事中

  -- 违规对未收到复函的业务提前办理退免税
  -- 2023052201  事中

  -- 未按规定处理“存在不予退（免）税的情形”、“暂缓办理退（免）税”的复函
  -- 2023052301   事前
  -- 回函未满15个工作日的数据
  INSERT INTO FXNK_NBFXDMX_SQ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,CJSJ)
         WITH FUHWG AS (
       SELECT F1.FHXXBUUID,F1.FAHDSWJG_DM,F1.WSBH,F1.GHFDJXH,F1.GHQYNSRSBH,F1.GHFQYMC,F1.GHFZGSWJGMC,F1.GHQYNSRSBH_1,F1.GHFQYMC_1,
              JH.SSQ,JH.SBPC,JH.SBXH,JH.JHPZH,JH.JSJE,JH.TSE,H1.QFRQ,H1.FHLX_DM,
              ROW_NUMBER() OVER (PARTITION BY H1.FHXXBUUID,JH.SBXH ORDER BY QD.HDFPQDUUID) AS RN
         FROM HX_ZH.ZH_CKTS_FHXXB F1
        INNER JOIN HX_ZH.ZH_CKTS_FUHXXB H1 ON H1.FHXXBUUID=F1.FHXXBUUID AND NVL(H1.ZFBZ_1,'N')='N' AND H1.FHBH IS NOT NULL
        INNER JOIN HX_ZH.ZH_CKTS_HDFPQD QD ON QD.FHXXBUUID=F1.FHXXBUUID --对应发函清单
        INNER JOIN HX_CKTS.CKTS_SB_MTS_TSJH_JGB JH ON JH.DJXH=F1.GHFDJXH AND JH.JHPZH=QD.ZZSZYFPDMHM
          AND NVL(JH.BYTSBZ,'N')='N' AND NVL(JH.BYBLBZ,'N')='N' AND JH.TSE>0 --对应进货退税
        INNER JOIN HX_CKTS.CKTS_SB_MTS_TSSB_JGB CK ON CK.DJXH=JH.DJXH AND CK.GLH=JH.GLH
          AND NVL(CK.BYTSBZ,'N')='N' AND NVL(CK.BYBLBZ,'N')='N' -- 对应出口退税
        WHERE F1.FAHDSWJG_DM LIKE '133%' AND F1.FAHDSWJG_DM NOT LIKE '13302%' AND NVL(F1.ZFBZ_1,'N')='N' --范围：全省不含宁波
          AND COMPUTE_BLJZDATE('C',H1.QFRQ)>=SYSDATE
          AND H1.FHLX_DM='2' --复函类型：存在不予退（免）税发票
          AND NOT EXISTS (SELECT 1 --不存在不予改准予的回函
                            FROM HX_ZH.ZH_CKTS_FUHXXB H2
                           WHERE H2.FHXXBUUID=F1.FHXXBUUID AND NVL(H2.ZFBZ_1,'N')='N' AND H2.FHLX_DM='1' AND H2.FHBH IS NOT NULL
                             AND H2.QFRQ>H1.QFRQ)
          AND NOT EXISTS (SELECT 1 --不存在不予退税或红字冲减
                            FROM HX_CKTS.CKTS_SB_MTS_TSJH_JGB JH2
                           WHERE JH2.DJXH=F1.GHFDJXH AND JH2.JHPZH=QD.ZZSZYFPDMHM AND (JH2.BYTSBZ='Y' OR JH2.TSE<0)
                           UNION ALL
                          SELECT 1 --不存在回函2个月内应追回
                            FROM HX_CKTS.CKTS_TK_YZHYTSKMXB_JGB YZH
                           WHERE YZH.DJXH=F1.GHFDJXH AND YZH.LRRQ>=H1.QFRQ AND YZH.LRRQ<ADD_MONTHS(H1.QFRQ,2))
       )
       SELECT '2023052301',  -- '函调管理类','HD-CL-BYTS',
              FUHWG.FHXXBUUID,FUHWG.FAHDSWJG_DM,FUHWG.GHFDJXH,FUHWG.GHQYNSRSBH,FUHWG.GHFQYMC,SUM(FUHWG.JSJE),SUM(FUHWG.TSE),
              '【核实函编号】'||FUHWG.WSBH||'；【供货企业税号】'||FUHWG.GHQYNSRSBH_1||
              '；【回函日期】'||TO_CHAR(FUHWG.QFRQ,'YYYYMMDD')||'；【回函类型】'||FUHWG.FHLX_DM,
              SYSDATE
         FROM FUHWG
        WHERE RN=1
        GROUP BY FUHWG.FHXXBUUID,FUHWG.FAHDSWJG_DM,FUHWG.GHFDJXH,FUHWG.GHQYNSRSBH,FUHWG.GHFQYMC,
              FUHWG.GHQYNSRSBH_1,FUHWG.WSBH,FUHWG.QFRQ,FUHWG.FHLX_DM;
  COMMIT;

  -- 未按规定处理“存在不予退（免）税的情形”、“暂缓办理退（免）税”的复函
  -- 2023052302   事前
  -- 回函未满15个工作日的数据
  INSERT INTO FXNK_NBFXDMX_SQ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,CJSJ)
         WITH FUHWG AS (
       SELECT F1.FHXXBUUID,F1.FAHDSWJG_DM,F1.WSBH,F1.GHFDJXH,F1.GHQYNSRSBH,F1.GHFQYMC,F1.GHFZGSWJGMC,F1.GHQYNSRSBH_1,F1.GHFQYMC_1,
              H1.QFRQ,H1.FHLX_DM,QD.ZZSZYFPDMHM,QD.JE,QD.SE
         FROM HX_ZH.ZH_CKTS_FHXXB F1
        INNER JOIN HX_ZH.ZH_CKTS_FUHXXB H1 ON H1.FHXXBUUID=F1.FHXXBUUID AND NVL(H1.ZFBZ_1,'N')='N' AND H1.FHBH IS NOT NULL
        INNER JOIN HX_ZH.ZH_CKTS_HDFPQD QD ON QD.FHXXBUUID=F1.FHXXBUUID --对应发函清单
        WHERE F1.FAHDSWJG_DM LIKE '133%' AND F1.FAHDSWJG_DM NOT LIKE '13302%' AND NVL(F1.ZFBZ_1,'N')='N' --范围：全省不含宁波
          AND COMPUTE_BLJZDATE('C',H1.QFRQ)>=SYSDATE
          AND H1.FHLX_DM='7' --复函类型：暂缓办理退（免）税
          AND NOT EXISTS (SELECT 1 --不存在暂扣税款的记录
                            FROM HX_CKTS.CKTS_TS_ZKCKTSYWCLB_JGB JG
                           WHERE JG.DJXH=F1.GHFDJXH AND JG.LRRQ>=H1.QFRQ AND JG.LRRQ<ADD_MONTHS(H1.QFRQ,2)
                           UNION ALL
                          SELECT 1
                            FROM HX_CKTS.CKTS_TS_ZKCKTSYWCLB_GCB GC
                           WHERE GC.DJXH=F1.GHFDJXH AND GC.LRRQ>=H1.QFRQ AND GC.LRRQ<ADD_MONTHS(H1.QFRQ,2))
       )
       SELECT '2023052302',  -- '函调管理类','HD-CL-ZHTS',
              FUHWG.FHXXBUUID,FUHWG.FAHDSWJG_DM,FUHWG.GHFDJXH,FUHWG.GHQYNSRSBH,FUHWG.GHFQYMC,SUM(FUHWG.JE),SUM(FUHWG.SE),
              '【核实函编号】'||FUHWG.WSBH||'；【供货企业税号】'||FUHWG.GHQYNSRSBH_1||
              '；【回函日期】'||TO_CHAR(FUHWG.QFRQ,'YYYYMMDD')||'；【回函类型】'||FUHWG.FHLX_DM,
              SYSDATE
         FROM FUHWG
        GROUP BY FUHWG.FHXXBUUID,FUHWG.FAHDSWJG_DM,FUHWG.GHFDJXH,FUHWG.GHQYNSRSBH,FUHWG.GHFQYMC,
              FUHWG.GHQYNSRSBH_1,FUHWG.WSBH,FUHWG.QFRQ,FUHWG.FHLX_DM;
  COMMIT;

  -- 未按规定对停权出口企业录入停止退税标志
  -- 2023052401  X

  -- 稽查立案后未进行暂缓或暂扣税款处理
  -- 2023052501   事前
  -- 立案未满5个工作日的数据
  INSERT INTO FXNK_NBFXDMX_SQ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,CJSJ)
         WITH JCLAQY AS (
       --出口企业案源管理台账
       SELECT 'TZB' AS SJLY,T.UUID,T.DJXH,TRUNC(T.LARQ) AS LARQ
         FROM HX_CKTS.CKTS_QT_CKQYAYGLTZ_GCB T
        WHERE T.LABZ='Y' AND T.JABZ='N'
          AND COMPUTE_BLJZDATE('A',T.LARQ)<TRUNC(SYSDATE)
        UNION ALL
       SELECT 'TZB' AS SJLY,T.UUID,T.DJXH,TRUNC(T.LARQ) AS LARQ
         FROM HX_CKTS.CKTS_QT_CKQYAYGLTZ_JGB T
        WHERE T.LABZ='Y' AND T.JABZ='N'
          AND COMPUTE_BLJZDATE('A',T.LARQ)<TRUNC(SYSDATE)
        UNION ALL
       --关于出口企业的立案、查处情况告知书
       SELECT 'GZS' AS SJLY,T.SSSXNBYSJFKBUUID AS UUID,T.DJXH,MIN(TRUNC(T.QSRQ)) AS LARQ
         FROM HX_ZH.ZH_GYCKQYLACCQKGZS T
        WHERE COMPUTE_BLJZDATE('A',T.QSRQ)<TRUNC(SYSDATE)
        GROUP BY T.SSSXNBYSJFKBUUID,T.DJXH),
         ZKQY AS (
       SELECT UUID,DJXH,LARQ,SJLY,ZKRQ,ROW_NUMBER() OVER (PARTITION BY DJXH ORDER BY LARQ DESC,ZKRQ) AS RN
         FROM (SELECT S.UUID,S.DJXH,S.LARQ,S.SJLY,TRUNC(ZK.LRRQ) AS ZKRQ
                 FROM JCLAQY S
                 LEFT JOIN HX_CKTS.CKTS_TS_ZKCKTSYWCLB_JGB ZK ON ZK.DJXH=S.DJXH AND ZK.LRRQ>S.LARQ
                UNION ALL
               SELECT S.UUID,S.DJXH,S.LARQ,S.SJLY,TRUNC(ZK.LRRQ) AS ZKRQ
                 FROM JCLAQY S
                 LEFT JOIN HX_CKTS.CKTS_TS_ZKCKTSYWCLB_GCB ZK ON ZK.DJXH=S.DJXH AND ZK.LRRQ>S.LARQ) TT
       )
       SELECT '2023052501',  -- '风险管理类','JC-LA-YZHSKCL',
              HZ.YWHZBUUID,HZ.TSSWJG_DM_1,HZ.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,HZ.FSZZSTSE+HZ.FSXFSTSE,
              (CASE WHEN ZKQY.SJLY='GZS' THEN '【告知书签收日期】' ELSE '【台账立案日期】' END)||TO_CHAR(ZKQY.LARQ,'YYYYMMDD')||
              '【录入暂扣日期】'||TO_CHAR(ZKQY.ZKRQ,'YYYYMMDD'),
              SYSDATE
         FROM ZKQY
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=ZKQY.DJXH
        INNER JOIN HX_CKTS.CKTS_TY_YWHZB HZ ON HZ.DJXH=ZKQY.DJXH
        WHERE ZKQY.RN=1
          AND NVL(HZ.SEHZWCBZ,'N')='N'
          AND HZ.LRRQ>ZKQY.LARQ AND HZ.LRRQ<NVL(ZKQY.ZKRQ,SYSDATE) AND HZ.FSZZSTSE+HZ.FSXFSTSE>0;
  COMMIT;

  -- 收到异常抵扣凭证未按照规定处理
  -- 2023052601  X

  -- 不应撤回而撤回存在不予退税情形的出口退（免）税申报
  -- 2023052701  事中

  -- 为出口企业办理退免税计算方法变更的，未结清变更前出口退（免）税款
  -- 2023052801  事中

  -- 在变更退免税计算方法后，为企业办理变更前出口货物退（免）税。
  -- 2023052802  事中

  -- 小规模纳税人期间出口的报关单在认定为一般纳税人之后进行退税申报
  -- 2023052901  X

  -- 未按规定处理系统提示的审核疑点
  -- 2023070101  事中
  -- 2023070102  事中
  -- 2023070103  事中
  -- 2023070104  事中
  -- 2023070105  事中
  -- 2023070106  事中
  -- 2023070107  事中
  -- 2023070108  事中

  -- 应暂不办理而办理出口退税（进出口税收管理部门已移送稽查部门的出口业务）
  -- 2023070201  X

  -- 应追回未追回已退税税款
  -- 2023070301   事前
  -- 5个工作日内
  INSERT INTO FXNK_NBFXDMX_SQ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,CJSJ)
       SELECT '2023070301',  -- '风险管理类','PG-YZHWZH',
              PG.UUID,PG.TSSWJG_DM_1,PG.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,PG.TZCKERMB,PG.TZYTSE,
              '【评估日期】'||TO_CHAR(PG.LRRQ,'YYYYMMDD')||'；【评估处理情况】'||PG.PGCLQK,
              SYSDATE
         FROM HX_CKTS.CKTS_FX_PGGZQK_JGB PG
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=PG.DJXH
        WHERE COMPUTE_BLJZDATE('A',PG.LRRQ)>=SYSDATE
          AND (PG.PGCLQKDMJH LIKE '%4%' OR PG.PGCLQK LIKE '%追回%' OR PG.PGCLQK LIKE '%返纳%' OR PG.PGCLQK LIKE '%反纳%')
          AND NOT EXISTS (SELECT 1 --不存在回函2个月内应追回
                            FROM HX_CKTS.CKTS_TK_YZHYTSKMXB_JGB YZH
                           WHERE YZH.DJXH=PG.DJXH AND YZH.SSQ>=TO_CHAR(PG.PGRQQ,'YYYYMM') AND YZH.SSQ<=TO_CHAR(PG.PGRQZ,'YYYYMM'));
  COMMIT;

  -- 应暂不办理而办理出口退税（因涉嫌骗取出口退税被税务机关稽查部门立案查处未结案的出口业务）
  -- 2023070401  X

  -- 违规兼任出口退（免）税岗位（免抵退税）
  -- 2023070501  事中

  -- 违规兼任出口退（免）税岗位（免退税）
  -- 2023070502  事中

  -- 违规兼任出口退（免）税岗位（代办退税）
  -- 2023070503  事中

  -- 违规兼任出口退（免）税岗位（系统维护岗兼岗）
  -- 2023070601  X

  -- 出口退（免）税事项长期未办结
  -- 2023070701   事前
  -- 2023070702   事前
  INSERT INTO FXNK_NBFXDMX_SQ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,CJSJ)
       SELECT '2023070701',  -- '申报管理类','JXGL-CQBL-JBSX',
              YW.UUID,YW.TSSWJG_DM_1,YW.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【业务类型】'||SX.LCSWSXMC||'；【流程启动时间】'||TO_CHAR(YW.QDSJ,'YYYYMMDD')||'；【已在途工作日】'||COMPUTE_BLDATE(SYSDATE,YW.QDSJ),
              SYSDATE
         FROM HX_CKTS.CKTS_TY_YWBLXX YW
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=YW.DJXH
        INNER JOIN HX_DM_QG.DM_GY_LCSWSX SX ON SX.LCSWSX_DM=YW.LCSWSX_DM
        INNER JOIN ZJ_MH.MH_LCXX LC ON LC.LCSLID=YW.LCSLID
        WHERE YW.LCSWSX_DM IN ('LCSXA081031001','LCSXA081033001','LCSXA081036001','LCSXA081036003','LCSXA081037001','LCSXA081001002',
              'LCSXA081043001','LCSXA081044002','LCSXA081045001','LCSXA081050001','LCSXA081051001','LCSXA081051002')
          AND NVL(YW.FFBZ,'N')='N'
          AND NVL(YW.ZFBZ_1,'N')='N'
          AND COMPUTE_BLDATE(SYSDATE,YW.QDSJ)>0.5 AND COMPUTE_BLDATE(SYSDATE,YW.QDSJ)<1
        UNION ALL
       SELECT '2023070702',  -- '申报管理类','JXGL-CQBL-FJBSX',
              YW.UUID,YW.TSSWJG_DM_1,YW.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【业务类型】'||SX.LCSWSXMC||'；【流程启动时间】'||TO_CHAR(YW.QDSJ,'YYYYMMDD')||'；【已在途工作日】'||COMPUTE_BLDATE(SYSDATE,YW.QDSJ),
              SYSDATE
         FROM HX_CKTS.CKTS_TY_YWBLXX YW
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=YW.DJXH
        INNER JOIN HX_DM_QG.DM_GY_LCSWSX SX ON SX.LCSWSX_DM=YW.LCSWSX_DM
        INNER JOIN ZJ_MH.MH_LCXX LC ON LC.LCSLID=YW.LCSLID
        WHERE YW.LCSWSX_DM IN ('LCSXA081032001','LCSXA081032002','LCSXA081035001','LCSXA081047001','LCSXA081049001','LCSXA081049002',
              'LCSXA081049003','LCSXA081049004')
          AND NVL(YW.FFBZ,'N')='N'
          AND NVL(YW.ZFBZ_1,'N')='N'
          AND COMPUTE_BLDATE(SYSDATE,YW.QDSJ)>3 AND COMPUTE_BLDATE(SYSDATE,YW.QDSJ)<5;
  COMMIT;

  -- 未按规定核实四类企业收汇资料
  -- 2023070801  事中

  -- 未按规定核实往年出口货物收汇资料
  -- 2023070901  事中

  -- 未按规定对四类生产企业年度首次申报开展评估
  -- 2023071001  X

  -- 调查评估岗违规办理出口退（免）税
  -- 2023071101   事前
  -- 审核疑点处理过程表
  INSERT INTO FXNK_NBFXDMX_SQ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,CJSJ)
       SELECT '2023071101',  -- '风险管理类','PG-YJGHQY',
              S.UUID,S.TSSWJG_DM_1,S.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,S.YTSE_1,
              '【申报所属期-批次】'||S.SSQ||'-'||S.SBPC||'；【疑点编号-内容】'||T.YDBH||'-'||T.YDNR
              ||'；【自查表处理意见】'||S.ZCBHCCLYJLX_DM||'；【复函处理意见】'||S.FHCLYJLX_DM||'；【实地核查处理意见】'||S.SDHCCLYJLX_DM
              ||'；【其他处理意见】'||S.QTHCCLYJLX_DM||'；【综合处理意见】'||S.ZHSHCLYJLX_DM,
              SYSDATE
         FROM HX_CKTS.CKTS_BL_MTS_SHYD_GCB T
        INNER JOIN HX_CKTS.CKTS_BL_MTS_SHYDCL_GCB S ON S.DJXH=T.DJXH AND S.SSQ=T.SSQ AND S.SBPC=T.SBPC AND S.SBXH=T.SBXH
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
        WHERE T.YDBH IN ('A9137','A9138','A0273','A0274')
          AND S.ZHSHCLYJLX_DM<>'6';
  COMMIT;

  -- 应二次发函而未按规定进行发函	与2023051701重复

  -- 收到复函逾期办理
  -- 2023071301   事前
  -- 回函签发10-15个工作日，复函处理日期为空
/*  INSERT INTO FXNK_NBFXDMX_SQ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,CJSJ)
       SELECT '2023071301',  -- '函调管理类','HD-CL-YQBLTS',
              H1.FUHXXBUUID,H1.FAHDSWJG_DM,F1.GHFDJXH,F1.GHQYNSRSBH,F1.GHFQYMC,F1.JEHJ,F1.SEHJ,
              '【核实函编号】'||H1.HSHBH||'；【复函编号】'||H1.FHBH||'；【回函类型】'||H1.FHLX_DM
              ||'；【回函日期】'||TO_CHAR(H1.QFRQ,'YYYYMMDD')||'；【回函处理日期】'||TO_CHAR(H1.FHCLRQ,'YYYYMMDD'),
              SYSDATE
         FROM HX_ZH.ZH_CKTS_FUHXXB H1
        INNER JOIN HX_ZH.ZH_CKTS_FHXXB F1 ON F1.FHXXBUUID=H1.FHXXBUUID
        WHERE H1.FAHDSWJG_DM LIKE '133%' AND H1.FAHDSWJG_DM NOT LIKE '13302%'
          AND COMPUTE_BLJZDATE('B',H1.QFRQ)<TRUNC(SYSDATE)
          AND COMPUTE_BLJZDATE('C',H1.QFRQ)>SYSDATE
          AND NVL(H1.ZFBZ_1,'N')='N'
          AND NVL(H1.FHLX_DM,'3')<>'3'
          AND H1.FHBH IS NOT NULL
          AND H1.DZBZDSZL_DM='BDA1320283' --非向上游发函的回函
          AND H1.FHCLRQ IS NULL;
  COMMIT;*/

  -- 违规回复“正常业务”复函（上游税局回复异常）
  -- 2023071401  事中

  -- 未按规定出具复函处理意见
  -- 2023071501  事中

  -- 未按规定对“不予退税”复函涉及税款进行处理
  -- 2023071601   事前
  -- 回函未满15个工作日的数据
  INSERT INTO FXNK_NBFXDMX_SQ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,CJSJ)
         WITH
         FU_1 AS ( --1.最近一次“复函类型”为“存在不予退（免）税发票”，调查函类型非”向上游核实函”；
       SELECT FHXXBUUID,WSBH,FAHDSWJG_DM,FAHRQ,GHFDJXH,GHQYNSRSBH,GHFQYMC,GHQYNSRSBH_1,JEHJ,SEHJ,FHBH,FUHRQ,FHLX_DM,FHCLYJ_DM
         FROM (SELECT --发函表UUID,发函编号,发函机关代码,发函机关名称,签发日期,出口企业及供货企业,涉及出口退税额
                      FA.FHXXBUUID,FA.WSBH,FA.FAHDSWJG_DM,FA.QFRQ AS FAHRQ,FA.GHFDJXH,FA.GHQYNSRSBH,FA.GHFQYMC,FA.GHQYNSRSBH_1,FA.JEHJ,FA.SEHJ,
                      --复函编号,签发日期,复函类型代码,复函处理意见代码
                      FU.FHBH,FU.QFRQ AS FUHRQ,FU.FHLX_DM,FU.FHCLYJ_DM,
                      --复函次数排倒序，空最后
                      ROW_NUMBER() OVER (PARTITION BY FU.FHXXBUUID ORDER BY FU.FHCS DESC NULLS LAST) RN_FUH
                 FROM HX_ZH.ZH_CKTS_FHXXB FA
                INNER JOIN HX_ZH.ZH_CKTS_FUHXXB FU ON FA.FHXXBUUID=FU.FHXXBUUID
                WHERE FA.FAHDSWJG_DM LIKE '133%' AND FA.FAHDSWJG_DM NOT LIKE '13302%' --发函地税局：浙江非宁波
                  AND FA.DZBZDSZL_DM='BDA1320284' --非上游核实函, 上游核实函为BDA1320288
                  AND COMPUTE_BLJZDATE('C',FU.QFRQ)>=SYSDATE
                  AND NVL(FA.ZFBZ_1,'N')='N' --发函未作废
                  AND NVL(FU.ZFBZ_1,'N')='N' --回函未作废
              ) HD
        WHERE RN_FUH=1 --最后一次复函
          AND FHLX_DM='2' --回函意见为“不予退税回函”
          AND FHCLYJ_DM<>'1' --剔除回函处理意见为准予退税的
       ),
           FP AS ( --2.核实函涉及发票办理退税（税额核准）时间在核实函签发日期之前；
       SELECT FHXXBUUID,WSBH,FAHDSWJG_DM,FAHRQ,GHFDJXH,GHQYNSRSBH,GHFQYMC,GHQYNSRSBH_1,JEHJ,SEHJ,FHBH,FUHRQ,FHLX_DM,FHCLYJ_DM,SUM(TSE) AS TSE
         FROM (SELECT FU_1.*,TSJH.TSE,ROW_NUMBER() OVER (PARTITION BY TSJH.UUID ORDER BY FU_1.FHXXBUUID) RN_JH
                 FROM FU_1
                INNER JOIN HX_ZH.ZH_CKTS_HDFPQD QD ON QD.FHXXBUUID=FU_1.FHXXBUUID AND NVL(QD.ZFBZ_1,'N')='N'
                INNER JOIN HX_CKTS.CKTS_SB_MTS_TSJH_JGB TSJH ON TSJH.DJXH=FU_1.GHFDJXH AND TSJH.JHPZH=QD.ZZSZYFPDMHM
                INNER JOIN HX_CKTS.CKTS_SB_MTS_TSSB_JGB TSSB ON TSSB.DJXH=TSJH.DJXH AND TSSB.GLH=TSJH.GLH
                INNER JOIN HX_CKTS.CKTS_TY_SEHZB SE ON SE.LCSLID=TSJH.LCSLID
                WHERE SE.SEHZRQ<FU_1.FAHRQ --税额核准日期小于发函签发日期，即退税后发函的不予退税复函，应追回
                  AND NVL(TSJH.BYBLBZ,'N')='N' AND NVL(TSJH.BYTSBZ,'N')='N' --对应发票进货明细非不予办理，非不予退税
                  AND NVL(TSSB.BYBLBZ,'N')='N' AND NVL(TSSB.BYTSBZ,'N')='N' --对应发票出口明细非不予办理，非不予退税
              ) MX
        WHERE RN_JH=1 --当一张发票对应多个关联号时，ZH_CKTS_HDFPQD有可能出现多次，需要去重
        GROUP BY FHXXBUUID,WSBH,FAHDSWJG_DM,FAHRQ,GHFDJXH,GHQYNSRSBH,GHFQYMC,GHQYNSRSBH_1,JEHJ,SEHJ,FHBH,FUHRQ,FHLX_DM,FHCLYJ_DM
       )
       --3.应追回金额小于核实函涉及税额合计一元以上.
       SELECT '2023071601',  -- '函调管理类','HD-CL-BYTS-YZH',
              FP.FHXXBUUID,FP.FAHDSWJG_DM,FP.GHFDJXH,FP.GHQYNSRSBH,FP.GHFQYMC,FP.JEHJ,FP.SEHJ,
              '【核实函编号】'||FP.WSBH||'；【发函日期】'||TO_CHAR(FP.FAHRQ,'YYYYMMDD')||'；【供货方】'||FP.GHQYNSRSBH_1||
              '；【回函编号】'||FP.FHBH||'；【回函日期】'||TO_CHAR(FP.FUHRQ,'YYYYMMDD')||'；【回函类型】'||FP.FHLX_DM||'；【回函处理意见】'||FP.FHCLYJ_DM||
              '；【发函前已退税税额(不包括并库前数据)】'||FP.TSE||'；【回函后追回税款次数】'||COUNT(YZH.UUID)||'；【税额】'||
              SUM(CASE WHEN YZH.YZHTMSK=0 THEN YZH.YTMSK ELSE YZH.YZHTMSK END),SYSDATE
         FROM FP
         LEFT JOIN HX_CKTS.CKTS_TK_YZHYTSKMXB_JGB YZH ON YZH.DJXH=FP.GHFDJXH AND YZH.LRRQ>FP.FUHRQ
        GROUP BY FHXXBUUID,WSBH,FAHDSWJG_DM,FAHRQ,GHFDJXH,GHQYNSRSBH,GHFQYMC,GHQYNSRSBH_1,JEHJ,SEHJ,FHBH,FUHRQ,FHLX_DM,FHCLYJ_DM,TSE
       HAVING NVL(SUM(CASE WHEN YZH.YZHTMSK=0 THEN YZH.YTMSK ELSE YZH.YZHTMSK END),0)<FP.TSE-1;
  COMMIT;

  -- 应暂扣未暂扣出口退税款
  -- 2023071701   事前
  -- 5个工作日内
  INSERT INTO FXNK_NBFXDMX_SQ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,CJSJ)
       SELECT '2023071701',  -- '风险管理类','JC-YZK-CKTSK',
              T.SSSXNBYSJFKBUUID,DJ.ZGSWJ_DM,DJ.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,SUM(SE.SEHZZZSTSE+SE.SEHZXFSTSE+SE.SEHZMDSE),
              '【审批日期】'||TO_CHAR(T.ZSRQ_3,'YYYYMMDD')||'；【移送后税额核准次数】'||COUNT(1)||
              '；【移送后核准税额】'||SUM(SE.SEHZZZSTSE+SE.SEHZXFSTSE+SE.SEHZMDSE)||'；【首次核准日期】'||TO_CHAR(MIN(SE.SEHZRQ),'YYYYMMDD'),
              SYSDATE
         FROM HX_ZH.ZH_SSSXNBYSJFKB T
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
        INNER JOIN HX_CKTS.CKTS_TY_SEHZB SE ON SE.DJXH=T.DJXH AND SE.SEHZRQ>T.ZSRQ_3
        WHERE T.NBYSSSSXLX_DM LIKE '%03%' AND NVL(t.ZFBZ_1,'N')<>'Y'
          AND COMPUTE_BLJZDATE('A',T.LRRQ)>=SYSDATE
          AND EXISTS (SELECT 1 FROM HX_CKTS.CKTS_TY_SEHZB WHERE DJXH=T.DJXH AND SEHZRQ>T.ZSRQ_3)
          AND NOT EXISTS (SELECT 1 FROM HX_CKTS.CKTS_TS_ZKCKTSYWCLB_JGB WHERE DJXH=T.DJXH AND ZKQSSJ>T.ZSRQ_3)
        GROUP BY T.SSSXNBYSJFKBUUID,DJ.ZGSWJ_DM,DJ.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,TO_CHAR(T.ZSRQ_3,'YYYYMMDD');
  COMMIT;

  -- 应解除未解除暂扣出口退税款
  -- 2023071801   事前
  -- 5个工作日内
  INSERT INTO FXNK_NBFXDMX_SQ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,CJSJ)
         WITH JAQJBYTS AS (
       SELECT AJ.JCAJXXUUID,CKQY.TSSWJG_DM_1,CKQY.DJXH,AJ.NSRSBH,AJ.NSRMC,AJ.JCAJBH,AJ.AJMC,AJ.LARQ,AJ.JARQ,TO_CHAR(SUBSTR(JL.JCFWHNR,1,1600)) AS JCFWHNR,
              (SELECT NVL(SUM(T.BYHZZZSTSE),0) FROM HX_CKTS.CKTS_TY_SEHZB T WHERE T.DJXH=AJ.DJXH AND T.SEHZRQ>=AJ.LARQ AND T.SEHZRQ<=AJ.JARQ) AS BYHZZZSTSE,
              (SELECT NVL(SUM(T.YTSE_1),0) FROM HX_CKTS.CKTS_BL_MTS_SHYDCL_JGB T WHERE T.DJXH=AJ.DJXH AND T.XGRQ>=AJ.LARQ AND T.XGRQ<=AJ.JARQ AND T.ZHSHCLYJLX_DM='6'
                UNION
               SELECT NVL(SUM(T.MDTSE),0) FROM HX_CKTS.CKTS_BL_MDT_SHYDCL_JGB T WHERE T.DJXH=AJ.DJXH AND T.XGRQ>=AJ.LARQ AND T.XGRQ<=AJ.JARQ AND T.ZHSHCLYJLX_DM='6') AS ZBBLTSE
         FROM HX_CKTS.CKTS_BA_BAXX_JGB CKQY
        INNER JOIN HX_JC.JC_AJXX AJ ON AJ.DJXH=CKQY.DJXH
        INNER JOIN HX_JC.JC_SWJCJL JL ON JL.JCAJXXUUID=AJ.JCAJXXUUID
        WHERE NVL(CKQY.BACHBZ,'N')='N' AND AJ.AJJCZT_DM LIKE '5%'
          AND COMPUTE_BLJZDATE('A',AJ.JARQ)>=SYSDATE
          AND JL.JCFWHNR LIKE '%未发现%税收违法问题%')
       SELECT '2023071801',  -- '风险管理类','JC-YJC-CKTSK',
              JCAJXXUUID,TSSWJG_DM_1,DJXH,NSRSBH,NSRMC,NULL,BYHZZZSTSE + ZBBLTSE,
              '【稽查案件编号】'||JCAJBH||'；【立案日期】'||TO_CHAR(LARQ,'YYYYMMDD')||'；【结案日期】'||TO_CHAR(JARQ,'YYYYMMDD')||
              '；【期间不予核准税额】'||BYHZZZSTSE||'；【暂不办理税额】'||ZBBLTSE||'；【结案意见】'||JCFWHNR,
              SYSDATE
         FROM JAQJBYTS
        WHERE BYHZZZSTSE + ZBBLTSE>0;
  COMMIT;

  -- 应暂停未暂停实行先退税后核销办法
  -- 2023071901  X

  -- 应恢复未恢复实行先退税后核销办法
  -- 2023072001  X

  -- 未按规定将移送稽查、稽查立案企业相关情况录入案源管理台账(未结案)
  -- 2023072101   事前
  -- 5个工作日内
  INSERT INTO FXNK_NBFXDMX_SQ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,CJSJ)
       SELECT '2023072101',  -- '风险管理类','JC-WLRTZ-LAQY',
              AJ.JCAJXXUUID,BA.TSSWJG_DM_1,AJ.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH) AS NSRSBH,DJ.NSRMC,NULL,NULL,
              '【稽查案件编号】'||AJ.JCAJBH||'；【案件名称】'||AJ.AJMC||'；【案件类型代码】'||AJ.AJLX_DM||'；【立案日期】'||TO_CHAR(AJ.LARQ,'YYYYMMDD'),
              SYSDATE
         FROM HX_JC.JC_AJXX AJ
        INNER JOIN HX_CKTS.CKTS_BA_BAXX_JGB BA ON BA.DJXH=AJ.DJXH AND NVL(BA.BACHBZ,'N')='N'
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=AJ.DJXH
        WHERE NVL(AJ.ZFBZ_1,'N') = 'N'
          AND COMPUTE_BLJZDATE('A',AJ.LARQ)>=SYSDATE
          AND AJ.JARQ IS NULL
          AND (AJ.AJMC LIKE '%发票违法%' OR AJ.AJMC LIKE '%骗税%')
          AND NOT EXISTS (SELECT 1 FROM HX_CKTS.CKTS_QT_CKQYAYGLTZ_JGB JG WHERE AJ.DJXH = JG.DJXH
                           UNION ALL
                          SELECT 1 FROM HX_CKTS.CKTS_QT_CKQYAYGLTZ_GCB JG WHERE AJ.DJXH = JG.DJXH);
  COMMIT;

  -- 未按规定对移送稽查企业提出暂停实行先退税后核销办法的意见	与2023071901重复

  -- 未按规定将稽查结案企业相关情况录入案源管理台账
  -- 2023072301  X

  -- 违规评定出口企业分类管理类别（一类企业）
  -- 2023072401  X

  -- 应恢复未恢复出口企业分类管理类别（稽查结案无问题）
  -- 2023072501   事前
  -- 结案未满20个工作日的数据
  INSERT INTO FXNK_NBFXDMX_SQ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,CJSJ)
         WITH AYGLTZ AS (
       SELECT A.UUID,A.TSSWJG_DM_1,A.DJXH,NVL(A.LARQ,NVL(A.XSYSQSRQ,NVL(A.XSYSJCRQ,A.LRRQ))) AS LARQ,A.JARQ
         FROM HX_CKTS.CKTS_QT_CKQYAYGLTZ_JGB A
        INNER JOIN HX_CKTS.CKTS_BA_BAXX_JGB BA ON BA.DJXH=A.DJXH AND NVL(BA.BACHBZ,'N')='N'
        WHERE COMPUTE_BLJZDATE('D',A.JARQ)>=SYSDATE
          AND TRIM(A.CKQYAYGLTZCFYY_DM) IS NULL
        UNION ALL
       SELECT B.UUID,B.TSSWJG_DM_1,B.DJXH,NVL(B.LARQ,NVL(B.XSYSQSRQ,NVL(B.XSYSJCRQ,B.LRRQ))) AS LARQ,B.JARQ
         FROM HX_CKTS.CKTS_QT_CKQYAYGLTZ_GCB B
        INNER JOIN HX_CKTS.CKTS_BA_BAXX_JGB BA ON BA.DJXH=B.DJXH AND NVL(BA.BACHBZ,'N')='N'
        WHERE COMPUTE_BLJZDATE('D',B.JARQ)>=SYSDATE
          AND TRIM(B.CKQYAYGLTZCFYY_DM) IS NULL
       ),
              YFLGL AS (
       SELECT UUID,KZNR_Y,YXQQ_Y FROM (
       SELECT AYGLTZ.UUID,Y.KZNR AS KZNR_Y,Y.YXQQ AS YXQQ_Y,ROW_NUMBER() OVER (PARTITION BY Y.DJXH ORDER BY Y.YXQQ DESC) RN
         FROM AYGLTZ
        INNER JOIN HX_CKTS.CKTS_BA_KZ_JGB Y ON Y.DJXH=AYGLTZ.DJXH
        WHERE Y.CKTMSBAKZLX_DM='FLGLCD' AND Y.YXBZ = 'Y' AND Y.YXQQ<AYGLTZ.LARQ)
        WHERE RN=1
       ),
              XFLGL AS (
       SELECT UUID,KZNR_T,YXQQ_T FROM (
       SELECT AYGLTZ.UUID,Y.KZNR AS KZNR_T,Y.YXQQ AS YXQQ_T,ROW_NUMBER() OVER (PARTITION BY Y.DJXH ORDER BY Y.YXQQ ASC) RN
         FROM AYGLTZ
        INNER JOIN HX_CKTS.CKTS_BA_KZ_JGB Y ON Y.DJXH=AYGLTZ.DJXH
        WHERE Y.CKTMSBAKZLX_DM='FLGLCD' AND Y.YXBZ = 'Y' AND SYSDATE>=Y.YXQQ AND SYSDATE<=Y.YXQZ)
        WHERE RN=1
       )
       SELECT '2023072501',  -- '风险管理类','FLGL-AB-JCJAQY',
              AYGLTZ.UUID,AYGLTZ.TSSWJG_DM_1,AYGLTZ.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH) AS NSRSBH,DJ.NSRMC,NULL,NULL,
              '【案源管理台账立案日期】'||TO_CHAR(AYGLTZ.LARQ,'YYYYMMDD')||'【结案日期】'||TO_CHAR(AYGLTZ.JARQ,'YYYYMMDD')||
              '；【立案前分类管理等级】'||YFLGL.KZNR_Y||'【有效期起】'||TO_CHAR(YFLGL.YXQQ_Y,'YYYYMMDD')||
              '；【当前分类管理类别】'||XFLGL.KZNR_T||'【有效期起】'||TO_CHAR(XFLGL.YXQQ_T,'YYYYMMDD'),
              SYSDATE
         FROM AYGLTZ
        INNER JOIN HX_CKTS.CKTS_BA_BAXX_JGB BA ON BA.DJXH=AYGLTZ.DJXH AND NVL(BA.BACHBZ,'N')='N'
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=AYGLTZ.DJXH
        INNER JOIN YFLGL ON YFLGL.UUID=AYGLTZ.UUID
        INNER JOIN XFLGL ON XFLGL.UUID=AYGLTZ.UUID
        WHERE YFLGL.KZNR_Y IN ('A','B');
  COMMIT;

  -- 未按照规定办理出口退（免）税备案撤回	与202305030*重复

  -- 税务登记注销时出口备案未撤回
  -- 2023072701  X

  -- 应出具未出具税务事项通知书
  -- 2023072801  事中

  -- 无合理理由进行再次发函
  -- 2023072901  事中

  -- 复函地主管税务机关随意向上游发函
  -- 2023073001  X

  -- 应出具未出具需提供收汇资料收汇信息采集的税务事项通知书
  -- 2023073101  X

  -- 应出具未出具适用出口免税政策评定的税务事项通知书
  -- 2023073201   事前
  -- 5个工作日内
  INSERT INTO FXNK_NBFXDMX_SQ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,CJSJ)
       SELECT '2023073201',  -- '申报管理类','WS-YCJWCJ-MSZC',
              MS.UUID,MS.TSSWJG_DM_1,MS.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【适用出口免税政策评估结果录入日期】'||TO_CHAR(MS.LRRQ,'YYYYMMDD')||'；【有效期起】'||TO_CHAR(MS.QSRQ_2,'YYYYMMDD')||
              '；【税务事项通知书('||SWSX.SWSXMC||')打印日期】'||TO_CHAR(WS.DYRQ,'YYYYMMDD')||
              '；【文书送达状态】'||SDZT.SDZTMC||'；【送达日期】'||TO_CHAR(SD.WSSDSJ,'YYYYMMDD'),
              SYSDATE
         FROM HX_CKTS.CKTS_QT_SYCKMSZCPG_JGB MS  -- 适用出口免税政策评估结果表
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=MS.DJXH
         LEFT JOIN HX_ZH.GY_WS_WSZB WS ON MS.DJXH=WS.DJXH AND WS.DZBZDSZL_DM='BDA0820076' -- 出口适用增值税退（免）税政策改为适用免税企业通知
         LEFT JOIN HX_DM_QG.DM_GY_SWSX SWSX ON WS.SWSX_DM=SWSX.SWSX_DM
         LEFT JOIN HX_DM_QG.DM_ZH_SDZT SDZT ON WS.SDZT_DM=SDZT.SDZT_DM
         LEFT JOIN HX_ZH.ZH_SDXX SD ON WS.YWWSUUID=SD.SDWSUUID  -- 文书 送达信息
         LEFT JOIN HX_ZH.ZH_SDHZ SDHZ ON SD.SDHZUUID=SDHZ.SDHZUUID -- 送达回证
        WHERE COMPUTE_BLJZDATE('A',MS.LRRQ)>=SYSDATE
          AND SDHZ.XHRQ_1 IS NULL;
  COMMIT;

  -- 违规评定出口企业分类管理类别（三类企业，上一年度违反规定未达处罚标准）
  -- 2023073301  事中

  -- 违规评定出口企业分类管理类别（四类企业，上一年度违反规定被处罚）
  -- 2023073401  事中

  -- 违规评定出口企业分类管理类别（四类企业，停权企业），同2023050701重复

  -- 违规评定出口企业分类管理类别（违规越级评定）
  -- 2023073601  X

  -- 违规评定出口企业分类管理类别（四类企业，四类认定不足12个月），同2023050801重复

  -- 未及时进行出口企业分类管理评定（新增企业类别认定）
  -- 2023073801  X

  -- 违规评定出口企业分类管理类别（三类企业，纳税信用评价为C级）
  -- 2023073901  X

  -- 违规评定出口企业分类管理类别（四类企业，纳税信用评价为D级）
  -- 2023074001  X

  -- 违规评定出口企业分类管理类别（三类企业，首笔申报未满12个月）
  -- 2023074101  X

  -- 违规评定出口企业分类管理类别（四类企业，四类企业的法定代表人）
  -- 2023074201  事中

  -- 未及时进行出口企业分类管理评定（复评申请）
  -- 2023074301   事前
  -- 企业管理类别复评表，申请时间未满15个工作日
  INSERT INTO FXNK_NBFXDMX_SQ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,CJSJ)
       SELECT '2023074301',  -- '综合管理类','FLGL-X-FPSQ',
              T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【企业申请复评时间】'||TO_CHAR(T.SQFPSJ,'YYYYMMDD')||'【评定日期】'||TO_CHAR(T.PDSJ,'YYYYMMDD')||
              '；【原评定等级】'||T.YGLLB_DM||'；【申请评定等级】'||T.SQFPGLLB_DM||'；【复评等级】'||T.FPGLLB_DM||
              '；【申请复评原因】'||T.SQFPYY,
              SYSDATE
         FROM HX_CKTS.CKTS_QT_QYGLLBFPPD_GCB T
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
        WHERE COMPUTE_BLJZDATE('C',T.SQFPSJ)>=SYSDATE;
  COMMIT;

  -- 未及时进行出口企业分类管理评定（类别变更）
  -- 2023074401   事前
  -- 企业管理类别评定表，申请时间未满15个工作日
  INSERT INTO FXNK_NBFXDMX_SQ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,CJSJ)
       SELECT '2023074401',  -- '综合管理类','FLGL-X-LBBG',
              T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【数据录入日期】'||TO_CHAR(T.LRRQ,'YYYYMMDD')||'【评定日期】'||TO_CHAR(T.PDSJ,'YYYYMMDD')||
              '；【原评定等级】'||KZ.KZNR||'；【调整等级】'||T.DTTZPDGLLB_DM||
              '；【税务机关评定意见】'||T.SWJGPDYJ,
              SYSDATE
         FROM HX_CKTS.CKTS_QT_QYGLLBDTTZ_GCB T
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
        INNER JOIN HX_CKTS.CKTS_BA_KZ_JGB KZ ON KZ.DJXH=T.DJXH AND KZ.CKTMSBAKZLX_DM='FLGLCD' AND KZ.YXBZ='Y'
          AND KZ.YXQQ<T.LRRQ AND KZ.YXQZ>=T.LRRQ
        WHERE COMPUTE_BLJZDATE('C',T.LRRQ)>=SYSDATE;
  COMMIT;

  -- 未按规定主动公开一类、四类出口企业名单
  -- 李裕军：目前取不到电子税务局公开信息及时间，该风险暂不取数
  -- 2023074501   事前
  INSERT INTO FXNK_NBFXDMX_SQ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,CJSJ)
       SELECT '2023074501',  -- '综合管理类','FLGL-AD-ZDGK',
              T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '【企业分类管理等级】'||T.KZNR||'【评定日期】'||TO_CHAR(T.LRRQ,'YYYYMMDD')||'；【请确认】是否已按规定主动公开一类、四类出口企业名单',
              SYSDATE
         FROM HX_CKTS.CKTS_BA_KZ_JGB T
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
        WHERE T.CKTMSBAKZLX_DM='FLGLCD' AND T.KZNR IN ('A','D') AND T.YXBZ='Y'
          AND COMPUTE_BLJZDATE('C',T.LRRQ)>=SYSDATE AND COMPUTE_BLJZDATE('C',T.LRRQ)<TRUNC(SYSDATE);
  COMMIT;

  -- 未按规定对管理类别为四类的出口企业，取消无纸化标识
  -- 2023074601  X

  -- 出口退免税计算方式适用错误
  -- 2023074701   事前
  -- 转一般纳税人后未满15个工作日的数据
  INSERT INTO FXNK_NBFXDMX_SQ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,CJSJ)
         WITH XGMZYBNSR AS (
       SELECT T.UUID,T.TSSWJG_DM_1,T.DJXH,T.BARQ,T.CKTSQYLX_DM,T.CKHWTMSJSFF_DM,S.RDYXQQ,
              ROW_NUMBER() OVER (PARTITION BY T.UUID ORDER BY S.RDYXQQ DESC) AS RN
         FROM HX_CKTS.CKTS_BA_BAXX_JGB T
        INNER JOIN HX_RD.RD_YBNSRRDSQSPB S ON S.DJXH=T.DJXH AND S.ZFBZ_1='N' AND S.ZSTYBZ='Y' AND S.XKYNSRBZ='N'
        WHERE T.BACHBZ='N'
          AND COMPUTE_BLJZDATE('C',S.ZSRQ)>=SYSDATE
          AND T.CKTSQYLX_DM<>'9' AND T.CKHWTMSJSFF_DM>='3'
       )
       SELECT '2023074701',  -- '综合管理类','BABG-TMSJSFF-WBG',
              XGMZYBNSR.UUID,XGMZYBNSR.TSSWJG_DM_1,XGMZYBNSR.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,NULL,NULL,
              '（转一般纳税人后，退免税计算方式未变更）【出口企业备案日期】'||TO_CHAR(XGMZYBNSR.BARQ,'YYYYMMDD')||'；【企业类型】'||XGMZYBNSR.CKTSQYLX_DM||
              '；【退(免)税计算方式】'||XGMZYBNSR.CKHWTMSJSFF_DM||'；【转一般纳税人认定日期】'||TO_CHAR(XGMZYBNSR.RDYXQQ,'YYYYMMDD'),
              SYSDATE
         FROM XGMZYBNSR
        INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=XGMZYBNSR.DJXH
        WHERE XGMZYBNSR.RN=1;
  COMMIT;

  -- 不符合视同自产的按视同自产审核
  -- 2024010101  事中

  -- 对企业尚未申报的出口退税发函调查
  -- 2024020101  事中

  -- 以其他方式结束调查评估
  -- 2024060101   事中

  -- 回函时不相容环节存在兼岗
  -- 2024060201   事中

  -- 对本地管辖企业回复“非本地管辖”
  -- 2025030301   事中

  -- 违规选择“暂缓办理退（免）税”复函
  -- 2025050101   事中

  -- 未按规定期限对“暂缓办理退（免）税”函件重新复函
  -- 2025050201   事前
  -- 结案日期未满一个月
  INSERT INTO FXNK_NBFXDMX_SQ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,NKJE,NKSE,NKYWMS,CJSJ)
       SELECT '2025050201',  -- '函调管理类','HD-FUH-QXZHBLTS',
              H1.FUHXXBUUID,H1.FUHSWJG_DM,F1.GHFDJXH1,F1.GHQYNSRSBH_1,F1.GHFQYMC_1,F1.JEHJ,F1.SEHJ,
              '【核实函编号】'||H1.HSHBH||'；【复函编号】'||H1.FHBH||'；【稽查结案日期】'||TO_CHAR(AJ.JARQ,'YYYY-MM-DD')||
              '；【风险描述】供货企业稽查已结案，未对“暂缓办理退（免）税”函件重新复函。',
              SYSDATE
         FROM HX_ZH.ZH_CKTS_FUHXXB H1
        INNER JOIN HX_ZH.ZH_CKTS_FHXXB F1 ON F1.FHXXBUUID=H1.FHXXBUUID
        INNER JOIN HX_JC.JC_AJXX AJ ON AJ.DJXH = F1.GHFDJXH1
          AND AJ.LARQ < H1.QFRQ AND H1.QFRQ < AJ.JARQ
          AND NVL(AJ.ZFBZ_1, 'N') = 'N'
        WHERE H1.FUHSWJG_DM LIKE '133%' AND H1.FUHSWJG_DM NOT LIKE '13302%' --回函税务机关范围：浙江，不包括宁波
          AND H1.FHLX_DM = '4' --回函“暂缓办理退（免）税”
          AND NVL(H1.ZFBZ_1,'N')='N'
          AND H1.FHBH IS NOT NULL
          AND AJ.JARQ>ADD_MONTHS(SYSDATE,-1)
          AND NOT EXISTS (SELECT 1 --“暂缓办理退（免）税”函件签发以后不存在明确意见的复函
                            FROM HX_ZH.ZH_CKTS_FUHXXB H2
                           WHERE H2.FHXXBUUID=F1.FHXXBUUID
                             AND H2.FHLX_DM IN ('1','2')
                             AND H2.FHBH IS NOT NULL
                             AND NVL(H2.ZFBZ_1,'N')='N'
                             AND H2.QFRQ>H1.QFRQ);
  COMMIT;

  -- 回函签发日期在发函签发日期以后5个工作日内
  -- 2025050301   事中

  -- 审核疑点处理时，针对不同供货商采用同一份核实函编号
  -- 2025050401   事中
  -- 2025050402   事中

  -- 四类企业首次申报跨大类（海关编码前4位）商品
  -- 2025090101   事中

  -- 9810业务非预退税申报
  -- 2025090201   事中
  
  UPDATE FXNK_NBFXDMX_SQ T
     SET T.SWJGDM='13306920000'
   WHERE T.SWJGDM='13306029200';
  COMMIT;

  RETURN;
END;
/

prompt
prompt Creating procedure PRO_DEAL_MSG_PUSH_DATA
prompt =========================================
prompt
CREATE OR REPLACE PROCEDURE PRO_DEAL_MSG_PUSH_DATA
/*
 * 提取即将逾期出口退税审核流程、容缺实地核查报告、复函流程、复函处理流程
 * 20250722, 复函处理流程增加回函类型不等于“3-延期回函”的筛选条件。
 * 20250821，复函处理因不在本表回写复函处理日期，暂时取消短信提醒
 * 20260515，根据杭州市局王薇意见，每年4月申报期增加卷烟免税核销的提醒
 * 20260519，根据杭州市局王薇意见，每年4月申报期增加来料加工免税证明核销的提醒
 */
AS
BEGIN
  -- 短信提醒数据
  EXECUTE IMMEDIATE 'TRUNCATE TABLE MSG_PUSH_DATA';
  COMMIT;

  -- 出口退税审核流程
  -- PRO_DEAL_CKTS_LC_TSSB();
  INSERT INTO MSG_PUSH_DATA(ID,SWJG_DM,NSRSBH,NSRMC,BIZTYPE,BIZKEY,QDSJ,JZSJ,YWBZ,SJTBSJ)
       SELECT SEQ_MSG_PUSH_DATA.NEXTVAL,TSSWJG_DM_1,NSRSBH,NSRMC,'退税办理',
              LCSLID,QDSJ,KHJZSJ,
              DECODE(LCSWSX_DM,'LCSXA081038001','免抵退税：'||SSQ||'('||CKQYGLLB_DM||')',
                               'LCSXA081039001','免退税：'||SSQ||'-'||SBPC||'('||CKQYGLLB_DM||')',
                               'LCSXA081042006','退消费税：'||SSQ||'('||CKQYGLLB_DM||')',
                               'LCSXA081042001','已使用设备退税：'||SSQ||'('||CKQYGLLB_DM||')',
                               'LCSXA081042002','购进自用货物退税：'||SSQ||'('||CKQYGLLB_DM||')',
                               'LCSXA081040001','代办退税：'||SSQ||'-'||SBPC||'('||CKQYGLLB_DM||')'),SYSDATE
         FROM CKTS_LC_TSSB T
        WHERE T.LCZT='01';
  COMMIT;

  -- 容缺实地核查流程（新管理办法出台以后，容缺办理已经取消）
/*
  -- PRO_DEAL_FXNK_LC_SDHC();
  INSERT INTO MSG_PUSH_DATA(ID,SWJG_DM,NSRSBH,NSRMC,BIZTYPE,BIZKEY,QDSJ,JZSJ,YWBZ,SJTBSJ)
       SELECT SEQ_MSG_PUSH_DATA.NEXTVAL,TSSWJG_DM_1,NSRSBH,NSRMC,'容缺办理',
              LCSLID,RQQRSJ,COMPUTE_BLJZDATE(NULL,RQQRSJ),
              '实地核查容缺台账编号：'||SDHCRQTZBH,SYSDATE
         FROM CKTS_LC_SDHC T
        WHERE T.LCZT='01';
  COMMIT;
*/
  -- 即将逾期复函
  -- PRO_DEAL_CKTS_HD_JJYQ()
  INSERT INTO MSG_PUSH_DATA(ID,SWJG_DM,NSRSBH,NSRMC,BIZTYPE,BIZKEY,QDSJ,JZSJ,YWBZ,SJTBSJ)
       SELECT SEQ_MSG_PUSH_DATA.NEXTVAL,GHFZGSWJG_DM,GHQYNSRSBH_1,GHFQYMC_1,'函调复函',
              FHXXBUUID,NULL,NVL(YQRQ_1,FUHJZRQ),
              '核实函编号：'||WSBH,SYSDATE
         FROM CKTS_HD_JJYQ;
  COMMIT;

  -- 即将逾期复函处理（金三升级，复函处理不再回写ZH_CKTS_FUHXXB表，已取消）
/*
  INSERT INTO MSG_PUSH_DATA(ID,SWJG_DM,NSRSBH,NSRMC,BIZTYPE,BIZKEY,QDSJ,JZSJ,YWBZ,SJTBSJ)
       SELECT SEQ_MSG_PUSH_DATA.NEXTVAL,H1.FAHDSWJG_DM,F1.GHQYNSRSBH,F1.GHFQYMC,'函调处理',
              H1.FUHXXBUUID,H1.QFRQ,COMPUTE_BLJZDATE('C',H1.QFRQ),
              '【核实函编号】'||H1.HSHBH,SYSDATE
         FROM HX_ZH.ZH_CKTS_FUHXXB H1
        INNER JOIN HX_ZH.ZH_CKTS_FHXXB F1 ON F1.FHXXBUUID=H1.FHXXBUUID
        WHERE H1.FAHDSWJG_DM LIKE '133%' AND H1.FAHDSWJG_DM NOT LIKE '13302%'
          AND NVL(H1.ZFBZ_1,'N')='N'
          AND H1.FHBH IS NOT NULL
          AND H1.DZBZDSZL_DM='BDA1320283' --非向上游发函的回函
          AND NVL(H1.FHLX_DM,'3')<>'3'
          AND H1.FHCLRQ IS NULL
          AND (COMPUTE_BLDATE(SYSDATE,TRUNC(H1.QFRQ)) BETWEEN 5 AND 15);
  COMMIT;
*/
  IF SYSDATE>=TO_DATE(TO_CHAR(SYSDATE,'YYYY')||'0401','YYYYMMDD') AND SYSDATE<TO_DATE(TO_CHAR(SYSDATE,'YYYY')||'0420','YYYYMMDD') THEN
    -- 卷烟免税证明核销提醒
    INSERT INTO MSG_PUSH_DATA(ID,SWJG_DM,NSRSBH,NSRMC,BIZTYPE,BIZKEY,QDSJ,JZSJ,YWBZ,SJTBSJ)
         SELECT SEQ_MSG_PUSH_DATA.NEXTVAL,T.ZGSWJ_DM,T.NSRSBH,T.NSRMC,'免税核销',
                NULL,NULL,TO_DATE(TO_CHAR(SYSDATE,'YYYY')||'0420','YYYYMMDD'),
                '卷烟免税证明核销提醒',SYSDATE
           FROM HX_DJ.DJ_NSRXX T
          WHERE T.DJXH=10113301000049506708 --全省仅中烟公司
            AND NOT EXISTS (SELECT 1 -- 当年不存在已申报未作废的卷烟免税证明核销流程
                              FROM HX_CKTS.CKTS_TY_YWBLXX S
                             WHERE S.DJXH=T.DJXH
                               AND S.LCSWSX_DM='LCSXA081048003' 
                               AND S.QDSJ>=TO_DATE(TO_CHAR(SYSDATE,'YYYY')||'0101','YYYYMMDD')
                               AND S.ZFRQ_1 IS NULL);
    COMMIT;
    
    -- 来料加工免税证明核销提醒
    INSERT INTO MSG_PUSH_DATA(ID,SWJG_DM,NSRSBH,NSRMC,BIZTYPE,BIZKEY,QDSJ,JZSJ,YWBZ,SJTBSJ)
           WITH WHXZM AS (
         SELECT DISTINCT T.DJXH,S.LLJGSZCH,T.LLJGMSZMBH
           FROM HX_CKTS.CKTS_ZM_LLJG_JGB T
          INNER JOIN HX_CKTS.CKTS_ZM_LLJG_JGMXB S ON S.ZBUUID=T.UUID
          WHERE TRUNC(T.KJRQ,'YY')=ADD_MONTHS(TRUNC(SYSDATE,'YY'),-12) AND T.ZFRQ_1 IS NULL --上年度已开具证明及对应手帐册号
            AND EXISTS
                (SELECT 1
                   FROM HX_CKTS.CKTS_WBSJ_HG_DZSCHXXX A
                  WHERE A.DJXH=S.DJXH AND A.BAH=S.LLJGSZCH AND TRUNC(A.JARQ,'YY')=ADD_MONTHS(TRUNC(SYSDATE,'YY'),-12) --手册号上年度核销
                  UNION ALL
                 SELECT 1
                   FROM HX_CKTS.CKTS_WBSJ_HG_DZZCHXXX B
                  WHERE B.DJXH=S.DJXH AND B.BAH=S.LLJGSZCH AND TRUNC(B.HXJZRQ,'YY')=ADD_MONTHS(TRUNC(SYSDATE,'YY'),-12)) --账册号上年度核销
            AND NOT EXISTS
                (SELECT 1
                   FROM HX_CKTS.CKTS_ZM_LLJGHX_JGMXB B
                  WHERE B.DJXH=T.DJXH AND B.LLJGMSZMBH=T.LLJGMSZMBH AND B.JGFFPHM=S.JGFFPHM --证明未核销
                  UNION ALL
                 SELECT 1
                   FROM HX_CKTS.CKTS_ZM_LLJGHX_GCMXB B
                  WHERE B.DJXH=T.DJXH AND B.LLJGMSZMBH=T.LLJGMSZMBH AND B.JGFFPHM=S.JGFFPHM)) --证明未申报
         SELECT SEQ_MSG_PUSH_DATA.NEXTVAL,T.ZGSWJ_DM,T.NSRSBH,T.NSRMC,'免税核销',
                WHXZM.LLJGSZCH||'-'||WHXZM.LLJGMSZMBH,NULL,TO_DATE(TO_CHAR(SYSDATE,'YYYY')||'0420','YYYYMMDD'),
                '卷烟免税证明核销提醒',SYSDATE
           FROM WHXZM
          INNER JOIN HX_DJ.DJ_NSRXX T ON T.DJXH=WHXZM.DJXH;
    COMMIT;
  END IF;

  RETURN;
END;
/

prompt
prompt Creating procedure PRO_DEAL_CKTS_DATA
prompt =====================================
prompt
CREATE OR REPLACE PROCEDURE PRO_DEAL_CKTS_DATA
/*
 * 预处理金三流程信息
 */
AS
  LD_SJCL_M     DATE;
  LD_SJCL_Y     DATE;
BEGIN
  LD_SJCL_M := TRUNC(ADD_MONTHS(SYSDATE,-1),'MM');
  LD_SJCL_Y := TRUNC(ADD_MONTHS(SYSDATE,-1),'YY');

  -- 即将逾期函调（复函）
  PRO_DEAL_CKTS_HD_JJYQ;
  -- 先发函后申报退税数据
  PRO_DEAL_CKTS_HD_XFHHSB(LD_SJCL_M);
  -- 本年度四类企业法人代表
  PRO_DEAL_CKTS_KZ_SLQY(LD_SJCL_Y);
  -- 不予退税及应追回已退免税款
  PRO_DEAL_CKTS_LC_BYTS;
  -- 容缺实地核查流程（新管理办法出台以后，容缺办理已经取消）
  --PRO_DEAL_CKTS_LC_SDHC;
  -- 视同自产审核流程
  PRO_DEAL_CKTS_LC_STZC;
  -- 出口退税审核流程
  PRO_DEAL_CKTS_LC_TSSB;
  
  PRO_DEAL_MSG_PUSH_DATA;
  PRO_DEAL_FXNK_NBFXDMX_SH;
  PRO_DEAL_FXNK_NBFXDMX_SQ;
END;
/

prompt
prompt Creating procedure PRO_DEAL_CKTS_LC_SDHC_STOP
prompt =============================================
prompt
CREATE OR REPLACE PROCEDURE PRO_DEAL_CKTS_LC_SDHC_STOP
/*
 * 新管理办法出台以后，容缺办理已经取消
 * 停止使用
 */
AS
  LD_SDHCQDSJ    DATE;
  LC_HCBH        VARCHAR(32);
  LD_SDHCWCSJ    DATE;
  LD_RQSEBJSJ    DATE;
  LC_ZLCLCSLID   VARCHAR(32);
  LC_ZFBZ_1      VARCHAR(2);
BEGIN
  -- 实地核查流程（增量）启动时间为系统日期提前7天，防止数据遗漏
  MERGE INTO CKTS_LC_SDHC A
       USING (SELECT T1.UUID,T1.TSSWJG_DM_1,T1.DJXH,S1.NSRSBH,S1.NSRMC,T1.LCSLID,T1.ZLCLCSLID,T1.HCYYSM,
                     T1.SDHCRQTZBH,T1.RQDCPGRY,T1.RQQRRY,T1.RQQRSJ,T1.JCRQSJ,T1.QXRQSJ,T1.RQDDXESJ,T1.LRRQ
                FROM HX_CKTS.CKTS_SDHC_JHSDHCTZ_JGB T1
               INNER JOIN HX_DJ.DJ_NSRXX S1 ON S1.DJXH=T1.DJXH
               WHERE T1.LRRQ>=SYSDATE-7 AND T1.RQBLSDHCBZ='Y' AND REGEXP_LIKE(T1.HCYYSM,'01|17|18')
               UNION ALL
              SELECT T2.UUID,T2.TSSWJG_DM_1,T2.DJXH,S2.NSRSBH,S2.NSRMC,T2.LCSLID,T2.ZLCLCSLID,T2.HCYYSM,
                     T2.SDHCRQTZBH,T2.RQDCPGRY,T2.RQQRRY,T2.RQQRSJ,T2.JCRQSJ,T2.QXRQSJ,T2.RQDDXESJ,T2.LRRQ
                FROM HX_CKTS.CKTS_SDHC_JHSDHCTZ_GCB T2
               INNER JOIN HX_DJ.DJ_NSRXX S2 ON S2.DJXH=T2.DJXH
               WHERE T2.LRRQ>=SYSDATE-7 AND T2.RQBLSDHCBZ='Y' AND REGEXP_LIKE(T2.HCYYSM,'01|17|18')) B
          ON (A.UUID=B.UUID)
        WHEN MATCHED THEN
          UPDATE SET A.TSSWJG_DM_1=B.TSSWJG_DM_1,A.DJXH=B.DJXH,A.NSRSBH=B.NSRSBH,A.NSRMC=B.NSRMC,
                     A.LCSLID=B.LCSLID,A.ZLCLCSLID=B.ZLCLCSLID,A.HCYYSM=B.HCYYSM,A.SDHCRQTZBH=B.SDHCRQTZBH,
                     A.RQDCPGRY=B.RQDCPGRY,A.RQQRRY=B.RQQRRY,A.RQQRSJ=B.RQQRSJ,A.JCRQSJ=B.JCRQSJ,A.QXRQSJ=B.QXRQSJ,
                     A.RQDDXESJ=B.RQDDXESJ,A.LRRQ=B.LRRQ
        WHEN NOT MATCHED THEN
          INSERT (UUID,TSSWJG_DM_1,DJXH,NSRSBH,NSRMC,LCSLID,ZLCLCSLID,HCYYSM,SDHCRQTZBH,RQDCPGRY,RQQRRY,RQQRSJ,JCRQSJ,QXRQSJ,RQDDXESJ,LRRQ,LCZT)
          VALUES (B.UUID,B.TSSWJG_DM_1,B.DJXH,B.NSRSBH,B.NSRMC,B.LCSLID,B.ZLCLCSLID,B.HCYYSM,B.SDHCRQTZBH,B.RQDCPGRY,B.RQQRRY,B.RQQRSJ,B.JCRQSJ,B.QXRQSJ,B.RQDDXESJ,B.LRRQ,'00');
  COMMIT;

  FOR CUR_LC IN (SELECT UUID,DJXH,NVL(ZLCLCSLID,LCSLID) AS ZLCLCSLID,LRRQ,RQQRSJ FROM CKTS_LC_SDHC WHERE LCZT<'10') LOOP
    -- SDHCQDSJ
    BEGIN
      SELECT MIN(T.RWFQSJ)
        INTO LD_SDHCQDSJ
        FROM (SELECT T1.*
                FROM HX_CKTS.CKTS_SDHC_JHSDHCTZ_JGB JGB
               INNER JOIN ZJ_MH.MH_LSRWXX T1 ON T1.LCSLID=JGB.LCSLID
               WHERE JGB.DJXH=CUR_LC.DJXH AND JGB.LRRQ>=CUR_LC.LRRQ AND REGEXP_LIKE(JGB.HCYYSM,'01|17|18')
               UNION ALL
              SELECT T2.*
                FROM HX_CKTS.CKTS_SDHC_JHSDHCTZ_GCB GCB
               INNER JOIN ZJ_MH.MH_RWXX T2 ON T2.LCSLID=GCB.LCSLID
               WHERE GCB.DJXH=CUR_LC.DJXH AND GCB.LRRQ>=CUR_LC.LRRQ AND REGEXP_LIKE(GCB.HCYYSM,'01|17|18')
             ) T
       WHERE T.RWSTATUS<>'06' AND T.RWZT LIKE '实地核查-实地核查实施%';
    EXCEPTION
      WHEN OTHERS THEN
        LD_SDHCQDSJ := NULL;
    END;
    -- HCBH, SDHCWCSJ
    BEGIN
      SELECT HCBH, SDHCWCSJ
        INTO LC_HCBH, LD_SDHCWCSJ
        FROM (SELECT HCBH, SDHCWCSJ
                FROM (SELECT T.HCBH, NVL(T.DCPGCLRQ,T.LRRQ) AS SDHCWCSJ
                        FROM HX_CKTS.CKTS_SDHC_SDHCBG_JGB T
                       WHERE T.DJXH=CUR_LC.DJXH AND T.LRRQ>=CUR_LC.LRRQ AND REGEXP_LIKE(T.HCYYSM,'01|17|18')
                       UNION ALL
                      SELECT T.HCBH, NVL(T.DCPGCLRQ,T.LRRQ) AS SDHCWCSJ
                        FROM HX_CKTS.CKTS_SDHC_SDHCBG_GCB T
                       WHERE T.DJXH=CUR_LC.DJXH AND T.LRRQ>=CUR_LC.LRRQ AND REGEXP_LIKE(T.HCYYSM,'01|17|18')
                     ) TT
               ORDER BY SDHCWCSJ) TTT
       WHERE ROWNUM=1;
    EXCEPTION
      WHEN OTHERS THEN
        LC_HCBH := NULL;
        LD_SDHCWCSJ := NULL;
    END;
    -- ZLCLCSLID, ZFBZ_1
    BEGIN
      SELECT LCSLID, ZFBZ_1
        INTO LC_ZLCLCSLID, LC_ZFBZ_1
        FROM (SELECT T.LCSLID,T.QDSJ, NVL(T.ZFBZ_1,'N') AS ZFBZ_1
                FROM HX_CKTS.CKTS_TY_YWBLXX T
               WHERE T.DJXH=CUR_LC.DJXH
                 AND T.LCSWSX_DM IN ('LCSXA081038001','LCSXA081039001','LCSXA081042006','LCSXA081042001','LCSXA081042002','LCSXA081040001')
                 AND T.LCSLID = T.ZLCLCSLID
                 AND T.QDSJ <= (SELECT QDSJ FROM HX_CKTS.CKTS_TY_YWBLXX WHERE DJXH=CUR_LC.DJXH AND LCSLID=CUR_LC.ZLCLCSLID)
               ORDER BY T.QDSJ DESC) TT
       WHERE ROWNUM=1;
    EXCEPTION
      WHEN OTHERS THEN
        LC_ZLCLCSLID := CUR_LC.ZLCLCSLID;
        LC_ZFBZ_1 := 'Y';
    END;
    --LD_RQSEBJSJ
    BEGIN
      SELECT MIN(CASE WHEN NVL(YW.FSZZSTSE,0)+NVL(YW.FSXFSTSE,0)-NVL(SE.BYHZZZSTSE,0)-NVL(SE.BYHZXFSTSE,0)>0 THEN TH.KPRQ
                      ELSE SE.SEHZRQ END)
        INTO LD_RQSEBJSJ
        FROM HX_CKTS.CKTS_TY_YWHZB YW
        LEFT JOIN HX_CKTS.CKTS_TY_SEHZB SE ON SE.YWHZBUUID=YW.YWHZBUUID
        LEFT JOIN HX_ZS.ZS_YDTXX ZS ON ZS.YDTLYUUID=SE.ZZSSSSRTHSBH AND ZS.TZLX_DM IN ('1','4')
        LEFT JOIN HX_ZS.ZS_SRTHS TH ON TH.YDTUUID=ZS.YDTUUID
       WHERE YW.DJXH=CUR_LC.DJXH AND YW.YWHZSJ>CUR_LC.RQQRSJ AND (YW.FSZZSTSE+YW.FSXFSTSE+YW.FSMDSE)>0;
    EXCEPTION
      WHEN OTHERS THEN
        LD_RQSEBJSJ := NULL;
    END;

    UPDATE CKTS_LC_SDHC S
       SET S.SDHCQDSJ=LD_SDHCQDSJ, S.HCBH=LC_HCBH, S.SDHCWCSJ=LD_SDHCWCSJ, S.RQSEBJSJ=LD_RQSEBJSJ,
           S.ZLCLCSLID=LC_ZLCLCSLID, S.ZFBZ_1=LC_ZFBZ_1,
           S.SDHCQDZQ=COMPUTE_BLDATE(NVL(S.SDHCQDSJ,SYSDATE),NVL(S.RQSEBJSJ,SYSDATE)),
           S.SDHCWCZQ=COMPUTE_BLDATE(NVL(S.SDHCWCSJ,SYSDATE),GREATEST(S.RQDDXESJ,NVL(S.RQSEBJSJ,SYSDATE)))
     WHERE S.UUID=CUR_LC.UUID;
    COMMIT;

    UPDATE CKTS_LC_SDHC S
       SET LCZT=CASE WHEN S.ZFBZ_1='Y'
                     THEN '20'
                     WHEN NVL(S.QXRQSJ,SYSDATE+1)<SYSDATE
                     THEN '20'
                     WHEN S.SDHCWCSJ IS NOT NULL
                     THEN (CASE WHEN S.RQDDXESJ IS NULL AND S.SDHCQDZQ>=20
                                THEN '12'
                                WHEN S.RQDDXESJ IS NOT NULL AND S.SDHCWCZQ>=20
                                THEN '12'
                                ELSE '10'
                           END)
                     ELSE (CASE WHEN S.RQDDXESJ IS NULL AND S.SDHCQDZQ>=20
                                THEN '02'
                                WHEN S.RQDDXESJ IS NOT NULL AND S.SDHCWCZQ>=20
                                THEN '02'
                                WHEN S.RQDDXESJ IS NULL AND S.SDHCQDZQ>=15
                                THEN '01'
                                WHEN S.RQDDXESJ IS NOT NULL AND S.SDHCWCZQ>=15
                                THEN '01'
                                ELSE '00'
                           END)
                END
     WHERE UUID=CUR_LC.UUID;
    COMMIT;
  END LOOP;

  RETURN;
END;
/

prompt
prompt Creating procedure PRO_DEAL_FXGL_FZPCKQY
prompt ========================================
prompt
CREATE OR REPLACE PROCEDURE PRO_DEAL_FXGL_FZPCKQY
/*
 * 纺织品出口企业风险指标提取过程
 */
(
  P_FXYEAR  IN VARCHAR2 --分析年度
)
AS
  LC_FXYEAR  CHAR(4);
  LD_FXRQQ   DATE; --分析期起
  LD_FXRQZ   DATE; --分析期止
  LD_SSQQ    DATE; --财务报表所属期起

  LN_CK_ZL_CD   NUMBER(16,4);
  LN_CK_CD_ZL   NUMBER(16,4);
  LN_CK_ZL_SL   NUMBER(16,4);
  LN_CK_SL_ZL   NUMBER(16,4);
  LN_CK_ZL_ALL  NUMBER(16,4);
  LN_CK_RMB     NUMBER(18,2);

  LN_QBXSSR     NUMBER(18,2);
  LN_CH_QCYE    NUMBER(18,2);
  LN_CH_QMYE    NUMBER(18,2);

BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE FXGL_DATA_FZPCKQY';
  COMMIT;

  -- 按年分析，因涉及财务报表，分析期止不能大于上一季度末
  IF (TRIM(P_FXYEAR) IS NULL) OR (LENGTH(TRIM(P_FXYEAR))!=4) OR
    (TRIM(P_FXYEAR)<'2019') OR (TRIM(P_FXYEAR)>TO_CHAR(ADD_MONTHS(SYSDATE,-4),'YYYY')) THEN
    LC_FXYEAR := TO_CHAR(ADD_MONTHS(SYSDATE,-4),'YYYY');
  ELSE
    LC_FXYEAR := TRIM(P_FXYEAR);
  END IF;
  LD_FXRQQ := TO_DATE(LC_FXYEAR||'-01-01','YYYY-MM-DD');
  LD_FXRQZ := TO_DATE(LC_FXYEAR||'-12-31','YYYY-MM-DD');
  IF LD_FXRQZ > TRUNC(SYSDATE,'Q') THEN
    LD_FXRQZ := TRUNC(SYSDATE,'Q') - 1;
  END IF;
  LD_SSQQ := TRUNC(LD_FXRQZ,'Q');

  -- 插入分析期内有纺织品出口的企业名单及出口统计数据
  INSERT INTO FXGL_DATA_FZPCKQY(DJXH,CK_RMB,CK_MY,CK_ZL_CD,CK_CD_ZL,CK_ZL_SL,CK_SL_ZL,CK_ZL_ALL,CK_FZP)
  SELECT BGD.DJXH,SUM(BGD.RMBLAJ),SUM(BGD.MYLAJ),
         SUM(CASE
             WHEN BGD.DYJLDW_DM = '09' AND BGD.DEJLDW_DM='04' THEN
               BGD.CKSL
             WHEN BGD.DEJLDW_DM = '09' AND BGD.DYJLDW_DM='04' THEN
               BGD.DECKSL
             ELSE
               0
             END) AS CK_ZL_CD,
         SUM(CASE
             WHEN BGD.DYJLDW_DM = '09' AND BGD.DEJLDW_DM='04' THEN
               BGD.DECKSL
             WHEN BGD.DEJLDW_DM = '09' AND BGD.DYJLDW_DM='04' THEN
               BGD.CKSL
             ELSE
               0
             END)  AS CK_CD_ZL,
         SUM(CASE
             WHEN BGD.DYJLDW_DM = '09' AND BGD.DEJLDW_DM='01' THEN
               BGD.CKSL
             WHEN BGD.DEJLDW_DM = '09' AND BGD.DYJLDW_DM='01' THEN
               BGD.DECKSL
             ELSE
               0
             END)  AS CK_ZL_SL,
         SUM(CASE
             WHEN BGD.DYJLDW_DM = '09' AND BGD.DEJLDW_DM='01' THEN
               BGD.DECKSL
             WHEN BGD.DEJLDW_DM = '09' AND BGD.DYJLDW_DM='01' THEN
               BGD.CKSL
             ELSE
               0
             END)  AS CK_SL_ZL,
         SUM(CASE
             WHEN BGD.DYJLDW_DM = '09'  THEN
               BGD.CKSL
             WHEN BGD.DEJLDW_DM = '09'  THEN
               BGD.DECKSL
             ELSE
               0
             END)  AS CK_ZL_ALL,
         SUM(CASE
             WHEN BGD.JGFS_DM IN (SELECT JGFS_DM FROM HX_DM_ZDY.DM_CKTS_HGJGFS WHERE JGFSTSLX_DM = '1') THEN
               BGD.RMBLAJ
             ELSE
               0
             END) AS CK_FZP
    FROM HX_CKTS.CKTS_WBSJ_HG_BGD201 BGD
   WHERE BGD.CKRQ_1 >= LD_FXRQQ
     AND BGD.CKRQ_1 <= LD_FXRQZ
     AND SUBSTR(BGD.CKSP_DM, 1, 2) BETWEEN '50' AND '63'
   GROUP BY BGD.DJXH;
  COMMIT;

  FOR CUR_CKQY IN (SELECT DJXH FROM FXGL_DATA_FZPCKQY) LOOP
    -- 更新纺织品出口企业全部销售额信息
    WITH SBB AS (
    SELECT DISTINCT SB.SBUUID
      FROM HX_SB.SB_SBXX SB
     WHERE SB.DJXH=CUR_CKQY.DJXH
       AND SB.SKSSQQ >= LD_FXRQQ
       AND SB.SKSSQZ <= LD_FXRQZ
       AND SB.ZSXM_DM = '10101'
       AND SB.YZPZZL_DM = 'BDA0610606'
       AND SB.GZLX_DM_1 IN ('1', '5')
       AND SB.ZFBZ_1 = 'N'
    )
    SELECT SUM(ZZS.ASYSLJSXSE + ZZS.AJYBFJSXSE + ZZS.MDTBFCKXSE + ZZS.MSXSE)
      INTO LN_QBXSSR
      FROM SBB
     INNER JOIN HX_SB.SB_ZZS_YBNSR ZZS
        ON ZZS.SBUUID = SBB.SBUUID
     WHERE ZZS.EWBLXH IN (1, 3);
    UPDATE FXGL_DATA_FZPCKQY T
       SET T.QBXSSR = LN_QBXSSR,
           T.FZP_CKBL = CASE WHEN T.CK_FZP>=LN_QBXSSR THEN 1 ELSE T.CK_FZP/LN_QBXSSR END
     WHERE T.DJXH=CUR_CKQY.DJXH;
    COMMIT;

    --  更新财务报表存货信息
    WITH CWBB AS (
    SELECT A.ZLBSCJUUID
      FROM HX_SB.SB_ZLBSCJB A
     WHERE A.DJXH = CUR_CKQY.DJXH
       AND A.SSQQ >= LD_SSQQ
       AND A.SSQZ = LD_FXRQZ
       AND A.ZFBZ_1 IS NULL)
    SELECT SUM(CH_QCYE), SUM(CH_QMYE)
      INTO LN_CH_QCYE, LN_CH_QMYE
      FROM (SELECT B.NCYE_ZC AS CH_QCYE, B.QMYE_ZC AS CH_QMYE
              FROM CWBB
             INNER JOIN HX_SB.SB_CWBB_QYKJZZYBQY_ZCFZB B
                ON B.ZLBSCJUUID=CWBB.ZLBSCJUUID
             WHERE B.EWBHXH = 9
             UNION ALL
            SELECT B.NCS_ZC AS CH_QCYE, B.QMS_ZC AS CH_QMYE
              FROM CWBB
             INNER JOIN HX_SB.SB_CWBB_QYKJZZ_ZCFZB B
                ON B.ZLBSCJUUID=CWBB.ZLBSCJUUID
             WHERE B.EWBHXH = 10
             UNION ALL
            SELECT B.NCYE_ZC AS CH_QCYE, B.QMYE_ZC AS CH_QMYE
              FROM CWBB
             INNER JOIN HX_SB.SB_CWBB_XQYKJZZ_ZCFZB B
                ON B.ZLBSCJUUID=CWBB.ZLBSCJUUID
             WHERE B.EWBHXH = 9
             UNION ALL
            SELECT B.SNNMYE_ZC AS CH_QCYE, B.QMYE_ZC AS CH_QMYE
              FROM CWBB
             INNER JOIN HX_SB.SB_CWBB_QYKJZZYBQY_ZCFZBZX B
                ON B.ZLBSCJUUID=CWBB.ZLBSCJUUID
             WHERE B.EWBHXH = 9
           ) T;
    UPDATE FXGL_DATA_FZPCKQY T
       SET T.ZC_CH_QCYE = LN_CH_QCYE,
           T.ZC_CH_QMYE = LN_CH_QMYE,
           T.ZC_CH_ZYE = LN_CH_QMYE - LN_CH_QCYE
     WHERE T.DJXH=CUR_CKQY.DJXH;
    COMMIT;

  END LOOP;

  -- 删除暂不需要分析数据
  DELETE FROM FXGL_DATA_FZPCKQY T WHERE T.CK_FZP<10000000;
  COMMIT;
  DELETE FROM FXGL_DATA_FZPCKQY T WHERE T.CK_FZP<0.3*T.QBXSSR;
  COMMIT;

  -- 更新每米公斤数、每件公斤数、每公斤单价
  SELECT SUM(S.CK_ZL_CD), SUM(S.CK_CD_ZL), SUM(S.CK_ZL_SL),SUM(S.CK_SL_ZL),SUM(S.CK_ZL_ALL),SUM(S.CK_RMB)
    INTO LN_CK_ZL_CD, LN_CK_CD_ZL, LN_CK_ZL_SL, LN_CK_SL_ZL, LN_CK_ZL_ALL, LN_CK_RMB
    FROM FXGL_DATA_FZPCKQY S;
  UPDATE FXGL_DATA_FZPCKQY T
     SET T.CK_GJ_M = CASE WHEN T.CK_CD_ZL = 0 THEN NULL ELSE T.CK_ZL_CD / T.CK_CD_ZL END,
         T.CK_GJ_M_PJ = CASE WHEN LN_CK_CD_ZL = 0 THEN NULL ELSE LN_CK_ZL_CD / LN_CK_CD_ZL END,
         T.CK_GJ_J = CASE WHEN T.CK_SL_ZL = 0 THEN NULL ELSE T.CK_ZL_SL / T.CK_SL_ZL END,
         T.CK_GJ_J_PJ = CASE WHEN LN_CK_SL_ZL = 0 THEN NULL ELSE LN_CK_ZL_SL / LN_CK_SL_ZL END,
         T.CK_DJ_GJ = CASE WHEN T.CK_ZL_ALL = 0 THEN NULL ELSE T.CK_RMB / T.CK_ZL_ALL END,
         T.CK_DJ_GJ_PJ = CASE WHEN LN_CK_ZL_ALL = 0 THEN NULL ELSE LN_CK_RMB / LN_CK_ZL_ALL END;
  COMMIT;

  -- 更新纺织品出口企业税务登记信息
  UPDATE FXGL_DATA_FZPCKQY T
     SET T.NSRSBH = (
  SELECT NVL(S.SHXYDM,S.NSRSBH)
    FROM HX_DJ.DJ_NSRXX S
   WHERE S.DJXH=T.DJXH);
  COMMIT;

END;
/

prompt
prompt Creating procedure PRO_DEAL_FXGL_STZCANDGJSB
prompt ============================================
prompt
CREATE OR REPLACE PROCEDURE PRO_DEAL_FXGL_STZCANDGJSB
/*
 * 生产企业出口外购货物风险模型、购进设备开1%3%普票风险模型
 * 数据初始化过程，确定生产企业范围
 */
AS
BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE FXGL_DATA_STZC';
  COMMIT;

  -- 插入分析期内有视同自产出口的生产企业出口统计数据
  INSERT INTO FXGL_DATA_STZC(DJXH,SBTS_CKE,SBTS_WGCKE)
  SELECT SB.DJXH,SUM(SB.RMBLAJ),
         SUM(CASE WHEN REGEXP_LIKE(SB.CKTMSYWLXDMJH,'STZC') AND NOT REGEXP_LIKE(SB.CKTMSYWLXDMJH,'STZC-05') THEN SB.RMBLAJ ELSE 0 END)
    FROM HX_CKTS.CKTS_SB_MDT_TSSB_JGB SB
   WHERE SB.CKRQ_1 >= DATE'2024-01-01' AND SB.CKRQ_1 < DATE'2026-01-01' -- 出口日期范围
     AND SB.MDTSNY IS NOT NULL -- 已准予退税
   GROUP BY SB.DJXH;
  COMMIT;

  UPDATE FXGL_DATA_STZC T
     SET (NSRSBH,NSRMC,ZGSWJ_DM,ZGSWJ_MC,HY_DM,HY_MC,NSRZT_DM) =
         (SELECT NVL(S.SHXYDM,S.NSRSBH),S.NSRMC,S.ZGSWJ_DM,SW.SWJGMC,S.HY_DM,HY.HYMC,S.NSRZT_DM
            FROM HX_DJ.DJ_NSRXX S
           INNER JOIN HX_DM_ZDY.DM_GY_SWJG SW ON SW.SWJG_DM=S.ZGSWJ_DM
           INNER JOIN HX_DM_QG.DM_GY_HY HY ON HY.HY_DM=S.HY_DM
           WHERE S.DJXH=T.DJXH);
  COMMIT;

  UPDATE FXGL_DATA_STZC T
     SET (T.BARQ,T.BACHBZ,T.CKHWTMSJSFF_DM) =
         (SELECT S.BARQ,S.BACHBZ,S.CKHWTMSJSFF_DM
            FROM HX_CKTS.CKTS_BA_BAXX_JGB S
           WHERE S.DJXH=T.DJXH);
  COMMIT;

END;
/

prompt
prompt Creating procedure PRO_DEAL_FXNK_NBFXDMX_SZ
prompt ===========================================
prompt
CREATE OR REPLACE PROCEDURE PRO_DEAL_FXNK_NBFXDMX_SZ
/*
 * 风险内控的事中干预
 * 流程推送的时候建议"审核岗-->调查评估岗，复审岗；调查评估岗-->复审岗"的时候调用
 * 20250530，根据云和反馈意见的测试结果，对所有字符串类型的空值判断，都加上TRIM(A)函数
 * 20260807，2023052201指标，增加事中预警功能
 * 20260821，2023052201指标，事中预警去除已签发条件，正在起草函调的发票也预警
 */
(
  V_LCSWSX    IN  VARCHAR2, -- 税务事项代码
  V_LCSLID    IN  VARCHAR2, -- 流程实例ID
  V_SWRYDM    IN  VARCHAR2, -- 当前操作人员
  V_PROPS     IN  VARCHAR2, -- 动态参数(多个参数用英文逗号隔开，每一个参数由“参数名:参数值"组成)
  V_ERROR     OUT NUMBER    -- 输出参数，当前（事项+流程实例ID）触发的事中风险点数量
)
AS
  LL_LTCS         NUMBER(10);
  LC_LCSWSX       VARCHAR2(14);
  LC_TSSWRY       VARCHAR2(11);
  LC_TS2SWRY      VARCHAR2(11);
  LN_DJXH         NUMBER(20);
  
  LC_LCSLID       VARCHAR2(32);
  LC_LCSLID_ZLC   VARCHAR2(32);
  LN_I            NUMBER := 1;
  
  LC_SWJG         VARCHAR2(11);
  LL_ROWS         NUMBER(10);
  LN_WJQTSE       NUMBER(18,6);
  LD_BGTMSJSFF    DATE;
  LC_UUID         VARCHAR2(32);
BEGIN
  V_ERROR :=0;
  IF TRIM(V_LCSWSX) IS NULL OR TRIM(V_LCSLID) IS NULL THEN
    RETURN;
  END IF;

  --规范税务事项代码长度
  LC_LCSWSX :=SUBSTR(V_LCSWSX,1,14);

  --提取下一环节操作人员代码（分流时可能有两个）
  BEGIN
    SELECT SUBSTR(PROPS,INSTR(PROPS,':')+1)
      INTO LC_TSSWRY
      FROM (SELECT REGEXP_SUBSTR(V_PROPS, '[^;]+', 1, LEVEL) AS PROPS
              FROM DUAL
           CONNECT BY REGEXP_SUBSTR(V_PROPS, '[^;]+', 1, LEVEL) IS NOT NULL)
     WHERE PROPS LIKE 'tsswry%'
       AND ROWNUM=1;
  EXCEPTION
    WHEN OTHERS THEN
      LC_TSSWRY := NULL;
  END;
  BEGIN
    SELECT SUBSTR(PROPS,INSTR(PROPS,':')+1)
      INTO LC_TS2SWRY
      FROM (SELECT REGEXP_SUBSTR(V_PROPS, '[^;]+', 1, LEVEL) AS PROPS
              FROM DUAL
           CONNECT BY REGEXP_SUBSTR(V_PROPS, '[^;]+', 1, LEVEL) IS NOT NULL)
     WHERE PROPS LIKE 'ts2swry%'
       AND ROWNUM=1;
  EXCEPTION
    WHEN OTHERS THEN
      LC_TS2SWRY := NULL;
  END;
  --提取djxh
  BEGIN
    SELECT TO_NUMBER(SUBSTR(PROPS,INSTR(PROPS,':')+1))
      INTO LN_DJXH
      FROM (SELECT REGEXP_SUBSTR(V_PROPS, '[^;]+', 1, LEVEL) AS PROPS
              FROM DUAL
           CONNECT BY REGEXP_SUBSTR(V_PROPS, '[^;]+', 1, LEVEL) IS NOT NULL)
     WHERE PROPS LIKE 'djxh%'
       AND ROWNUM=1;
  EXCEPTION
    WHEN OTHERS THEN
      LN_DJXH := 0;
  END;
  --根据所在税务机关设置联调测试参数
  BEGIN
    SELECT T.TSSWJG_DM_1
      INTO LC_SWJG
      FROM HX_CKTS.CKTS_BA_BAXX_JGB T
     WHERE T.DJXH=LN_DJXH;
  EXCEPTION
    WHEN OTHERS THEN
      LC_SWJG := '133';
  END;
--  IF LC_SWJG='13300910000' THEN --根据需求调整需要提示所有监控点的税务机关
  IF V_LCSLID='DCDE6CE202DC8BBCC38E8F4F9746D4D1' THEN --根据需求调整需要提示所有监控点的税务机关
    LL_LTCS :=2;
  ELSE
    LL_LTCS :=1;
  END IF;

  DELETE FROM FXNK_NBFXDMX_SZ T WHERE T.LCSWSX_DM=LC_LCSWSX AND T.LCSLID=V_LCSLID;
  DELETE FROM FXNK_NBFXDMX_SZ_LC WHERE PLCSLID=V_LCSLID;
  COMMIT;

  -- 从当前流程追溯到主流程，用于确定相同批次各流转环节
  LC_LCSLID:= V_LCSLID;
  WHILE LN_I>0 LOOP
    BEGIN
      SELECT T.ZLCLCSLID
        INTO LC_LCSLID_ZLC
        FROM HX_CKTS.CKTS_TY_YWBLXX T
       WHERE T.LCSLID=LC_LCSLID AND T.ZLCLCSLID<>LC_LCSLID;
      
      INSERT INTO FXNK_NBFXDMX_SZ_LC(PLCSLID,LCSLID,ZLCLCSLID)
           VALUES (V_LCSLID,LC_LCSLID,LC_LCSLID_ZLC);
      COMMIT;
      
      LC_LCSLID:= LC_LCSLID_ZLC;
    EXCEPTION
      WHEN OTHERS THEN
        INSERT INTO FXNK_NBFXDMX_SZ_LC(PLCSLID,LCSLID,ZLCLCSLID)
             VALUES (V_LCSLID,LC_LCSLID,LC_LCSLID);
        COMMIT;
        
        LN_I :=0;
    END;
  END LOOP;

  -- 办理特殊核准退税业务
  -- 2023050101 事中
  IF LC_LCSWSX='LCSXA082042001' THEN
    INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
         SELECT '2023050101',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                '【请确认】是否存在相同金额的入库信息，【本次核准税额】'||T.YTZZSE+T.YTXFSE+T.MDSE
           FROM HX_CKTS.CKTS_TS_TSHZTS_GCB T
          INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
          WHERE T.LCSLID=V_LCSLID
            AND T.TBYY_DM='190'
            AND NOT EXISTS (SELECT 1 FROM HX_ZS.ZS_JKS S WHERE S.DJXH=T.DJXH GROUP BY S.DZSPHM HAVING SUM(S.SJJE)=T.YTZZSE)
            AND NOT EXISTS (SELECT 1 FROM HX_ZS.ZS_JKS S WHERE S.DJXH=T.DJXH GROUP BY S.DZSPHM,S.DZSPMXXH HAVING SUM(S.SJJE)=T.YTZZSE);
    COMMIT;
    IF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023050101',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】办理特殊核准退税业务是否存在相同金额的入库信息检查通过'
             FROM HX_CKTS.CKTS_TS_TSHZTS_GCB T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID
              AND NOT EXISTS (SELECT 1 FROM FXNK_NBFXDMX_SZ S WHERE S.NKZBBH='2023050101' AND S.LCSLID=V_LCSLID);
      COMMIT;
    END IF;
  END IF;

  -- 不相容环节存在兼岗
  -- 2023050201   事中
  IF SUBSTR(LC_LCSWSX,1,11) IN ('LCSXA081038','LCSXA081039','LCSXA081040','LCSXA081042') THEN
    -- 人员1
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM HX_CKTS.CKTS_TY_YWBLXX T
     INNER JOIN FXNK_NBFXDMX_SZ_LC S ON S.PLCSLID=T.LCSLID
     INNER JOIN HX_CKTS.CKTS_TY_TSSBYWBL_MXB HJ ON HJ.LCSLID=S.LCSLID
     WHERE T.LCSLID=V_LCSLID
       AND HJ.LCHJ_DM IN ('02','03','04','08')
       AND HJ.TS_RYDM = LC_TSSWRY
       AND HJ.HTRQ_1 IS NULL;
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023050201',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】'||LC_TSSWRY||'是否在同一企业同一批次曾经流转过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 AND TRIM(LC_TSSWRY) IS NOT NULL THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023050201',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||LC_TSSWRY||'是否在同一企业同一批次曾经流转过检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
    -- 人员2
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM HX_CKTS.CKTS_TY_YWBLXX T
     INNER JOIN FXNK_NBFXDMX_SZ_LC S ON S.PLCSLID=T.LCSLID
     INNER JOIN HX_CKTS.CKTS_TY_TSSBYWBL_MXB HJ ON HJ.LCSLID=S.LCSLID
     WHERE T.LCSLID=V_LCSLID
       AND HJ.LCHJ_DM IN ('02','03','04','08')
       AND HJ.TS_RYDM = LC_TS2SWRY
       AND HJ.HTRQ_1 IS NULL;
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023050201',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】'||LC_TS2SWRY||'是否在同一企业同一批次曾经流转过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 AND TRIM(LC_TS2SWRY) IS NOT NULL THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023050201',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||LC_TS2SWRY||'是否在同一企业同一批次曾经流转过检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  END IF;
  -- 2023050204   事中
  IF LC_LCSWSX = 'LCSXA081038006' THEN
    INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
         SELECT '2023050204',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                '【请确认】'||LC_TSSWRY||'是否在同一企业同一批次曾经流转过'
           FROM HX_CKTS.CKTS_BL_MDT_SHYDCL_GCB T
          INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
          WHERE T.LCSLID=V_LCSLID
            AND T.SHR_DM=LC_TSSWRY
            AND ROWNUM=1;
    COMMIT;
    IF LL_LTCS=2 AND TRIM(LC_TSSWRY) IS NOT NULL THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023050204',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||LC_TSSWRY||'是否在同一企业同一批次曾经流转过检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID
              AND NOT EXISTS (SELECT 1 FROM FXNK_NBFXDMX_SZ S WHERE S.NKZBBH='2023050204' AND S.LCSLID=V_LCSLID)
              AND ROWNUM=1;
      COMMIT;
    END IF;
  END IF;

  -- 备案撤回未结清税款
  -- 2023050301   事中
  -- 2023050302   事中
  -- 2023050303   事中
  IF LC_LCSWSX = 'LCSXA081032002' THEN
    BEGIN
      SELECT NVL(SUM(T.SE),0)
        INTO LN_WJQTSE
        FROM HX_ZS.ZS_YDTXX T
        LEFT JOIN HX_ZS.ZS_SRTHS TH ON TH.YDTUUID=T.YDTUUID AND TH.TZLX_DM IN ('1','4')
       WHERE T.DJXH=LN_DJXH
         AND T.TTSJLX_DM='01' AND T.TZLX_DM='1' AND T.TDSFS_DM='1'
         AND TH.THRQ_1 IS NULL;
    EXCEPTION
      WHEN OTHERS THEN
        LN_WJQTSE := 0;
    END;
    IF LN_WJQTSE>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023050301',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】以下税款是否结清；【已核准待开具退税额】'||LN_WJQTSE
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023050301',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||DJ.NSRMC||'已核准待开具退税额检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;

    BEGIN
      SELECT NVL(SUM(T.MD_AMT),0)
        INTO LN_WJQTSE
        FROM HX_ZS.ZS_CKTS_MDT T
        LEFT JOIN HX_ZS.ZS_TKGZ TK ON TK.DJXH=T.DJXH AND TK.BTKGZUUID=T.CKTS_NO AND TK.TZSLY='3' AND TK.TZLX_DM='1' AND TK.GZBZ='Y' AND TK.ZFRQ_1 IS NULL
       WHERE T.DJXH=LN_DJXH
         AND T.TZLX_DM='1'
         AND TK.GKGZRQ IS NULL;
    EXCEPTION
      WHEN OTHERS THEN
        LN_WJQTSE := 0;
    END;
    IF LN_WJQTSE>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023050302',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】以下税款是否结清；【已核准待调库免抵额】'||LN_WJQTSE
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023050302',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||DJ.NSRMC||'已核准待调库免抵额检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;

    BEGIN
      SELECT NVL(T.JZXQMDTSE,0)
        INTO LN_WJQTSE
        FROM HX_CKTS.CKTS_SB_MDT_SBDSHZ_JGB T
       WHERE T.DJXH=LN_DJXH
         AND T.JZXQMDTSE<>0
         AND NOT EXISTS (SELECT 1 FROM HX_CKTS.CKTS_SB_MDT_SBDSHZ_JGB S WHERE S.DJXH=T.DJXH AND S.SSQ>T.SSQ);
    EXCEPTION
      WHEN OTHERS THEN
        LN_WJQTSE := 0;
    END;
    IF LN_WJQTSE>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023050303',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】以下税款是否结清；【结转下期免抵退税额】'||LN_WJQTSE
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023050303',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||DJ.NSRMC||'结转下期免抵退税额检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  END IF;

  -- 平均办理时限超期
  -- 2023050401   X
  -- 2023050402   X

  -- 逾期办结出口退（免）税
  -- 2023050403   单独短信提醒

  -- 未在规定期限内完成分类管理年度评定（按年统计）
  -- 2023050501   事前

  -- 一类、二类企业被立案查处尚未结案的，未按规定将出口企业暂按三类管理
  -- 2023050601   事前

  -- 稽查结案后有违反出口退(免)税有关规定的，未按规定将出口企业调整为四类管理
  -- 2023050602   事前

  -- 稽查结案后，税务行政处罚违法事实含'%出口%骗税%'字眼的，未按规定将出口企业调整为四类管理
  -- 2023050603   事前

  -- 未按规定将停止出口退税权纳税人的分类管理类别调整为四类（停权有效期）
  -- 2023050701   事前，事中
  IF LC_LCSWSX = 'LCSXA081053001' THEN
    INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
         SELECT '2023050701',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                '【请确认】纳税人停止出口退税权是否届满两年；【停权有效期起止】'||
                TO_CHAR(TQQY.YXQQ,'YYYYMMDD')||'-'||TO_CHAR(TQQY.YXQZ,'YYYYMMDD')
           FROM HX_CKTS.CKTS_TY_YWBLXX T
          INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
          INNER JOIN HX_CKTS.CKTS_BA_KZ_JGB TQQY ON TQQY.DJXH=T.DJXH AND TQQY.CKTMSBAKZLX_DM='TQQY' AND TQQY.YXBZ='Y'
          WHERE T.LCSLID=V_LCSLID
            AND TQQY.YXQQ<SYSDATE AND SYSDATE<ADD_MONTHS(TQQY.YXQZ,24);
    COMMIT;
    IF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023050701',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||DJ.NSRMC||'停止出口退税权是否届满两年检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID
              AND NOT EXISTS (SELECT 1 FROM FXNK_NBFXDMX_SZ S WHERE S.NKZBBH='2023050701' AND S.LCSLID=V_LCSLID);
      COMMIT;
    END IF;
  END IF;

  -- 四类出口企业自评定之日起，未满12个月违规被评定为其他管理类别
  -- 2023050801  事中
  IF LC_LCSWSX IN ('LCSXA081053001','LCSXA082052001') THEN
    INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
         SELECT '2023050801',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                '【请确认】四类出口企业是否已纳税信用修复；【当前纳税信用等级】D'
           FROM HX_CKTS.CKTS_TY_YWBLXX T
          INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
          INNER JOIN HX_CKTS.CKTS_BA_KZ_JGB KZ ON KZ.DJXH=T.DJXH AND KZ.CKTMSBAKZLX_DM='FLGLCD' AND KZ.KZNR='D' AND KZ.YXBZ='Y' AND KZ.YXQZ>SYSDATE
          INNER JOIN FXNK_JC2B_NSXYPJ J2 ON J2.DJXH=T.DJXH AND J2.PJND='D'
          WHERE T.LCSLID=V_LCSLID
            AND MONTHS_BETWEEN(SYSDATE,KZ.YXQQ)<12
            AND NOT EXISTS (SELECT 1
                              FROM HX_CKTS.CKTS_BA_KZ_JGB PE
                             WHERE PE.DJXH=T.DJXH AND PE.CKTMSBAKZLX_DM='FLGLCD' AND PE.KZNR='D' AND PE.YXBZ='Y'
                               AND PE.YXQZ+1>=KZ.YXQQ AND MONTHS_BETWEEN(SYSDATE,PE.YXQQ)>=12);
    COMMIT;
    IF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023050801',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||DJ.NSRMC||'四类出口企业自评定之日起未满12个月检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID
              AND NOT EXISTS (SELECT 1 FROM FXNK_NBFXDMX_SZ S WHERE S.NKZBBH='2023050801' AND S.LCSLID=V_LCSLID);
      COMMIT;
    END IF;
  END IF;

  -- 两次发生税收违法行为的出口企业未调整适用免税政策
  -- 2023050901  事中
  IF SUBSTR(LC_LCSWSX,1,11) IN ('LCSXA081038','LCSXA081039','LCSXA081040','LCSXA081042') THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM HX_CKTS.CKTS_TY_YWBLXX T
     INNER JOIN HX_JC.JC_AJXX AJ ON AJ.DJXH=T.DJXH
     INNER JOIN HX_FZ.FZ_SWXZCFJDS CF ON CF.SSWFXWDJUUID=AJ.JCAJXXUUID AND NVL(CF.ZFBZ_1,'N')='N'
     WHERE T.LCSLID=V_LCSLID
       AND ((CF.WFSS LIKE '%虚开%' AND CF.WFSS LIKE '%专用发票%') OR (CF.WFSS LIKE '%出口%' AND CF.WFSS LIKE '%骗税%'));
    IF LL_ROWS>=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023050901',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】出口企业存在两次税务行政处罚决定书，是否调整适用免税政策'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023050901',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||DJ.NSRMC||'两次发生税收违法行为适用免税政策检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  END IF;

  -- 从异常供货企业采购的进货明细，连续12个月内申报退税额大于200万
  -- 2023051001  X

  -- 从异常供货企业采购的进货明细，连续12个月内申报退税额占这12个月全部申报退税额30%以上
  -- 2023051002  X

  -- 主管税务机关未按照“容缺办理”的原则办理且未按照规定开展实地核查
  -- 2023051101  X

  -- 出口企业首次申报出口退（免）税，已按照“容缺办理”的原则办理但未按规定补充完成实地核查。
  -- 2023051102  单独短信提醒

  -- 实地核查超20个工作日, 20240614根据总局督查结果增加
  -- 2023051103  事前

  -- 实地核查报告核查人员少于2人
  -- 2023051201  事中
  IF LC_LCSWSX='LCSXA082025001' THEN
    INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
         SELECT '2023051201',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                '【请确认】实地核查报告核查人员是否少于2人；【核查人员】'||BG.HCRY
           FROM HX_CKTS.CKTS_TY_YWBLXX T
          INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
          INNER JOIN (SELECT SDHC.LCSLID, SDHC.HCRY, SUBSTR(SDHC.HCRY,1,INSTR(SDHC.HCRY,'##')-1) AS HCRY1,SUBSTR(SDHC.HCRY,INSTR(SDHC.HCRY,'##')+2) AS HCRY2
                        FROM HX_CKTS.CKTS_SDHC_SDHCBG_GCB SDHC
                       WHERE SDHC.LCSLID=V_LCSLID) BG ON BG.LCSLID=T.LCSLID
          WHERE T.LCSLID=V_LCSLID
            AND (TRIM(BG.HCRY) IS NULL OR (TRIM(BG.HCRY1) IS NULL) OR (TRIM(BG.HCRY2) IS NULL) OR (TRIM(BG.HCRY1)=TRIM(BG.HCRY2)));
    COMMIT;
    IF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023051201',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||DJ.NSRMC||'实地核查报告核查人员数量检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID
              AND NOT EXISTS (SELECT 1 FROM FXNK_NBFXDMX_SZ S WHERE S.NKZBBH='2023051201' AND S.LCSLID=V_LCSLID);
      COMMIT;
    END IF;
  END IF;
  -- 2023051201   事中
  IF LC_LCSWSX = 'LCSXA081038001' THEN
    INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
         SELECT '2023051201',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                '【请确认】疑点业务处理实地核查人员是否少于2人；【核查人员】'||T.SDHCRXMJH
           FROM (SELECT S.*,
                        SUBSTR(S.SDHCRXMJH,1,GREATEST(INSTR(S.SDHCRXMJH,'##'),INSTR(S.SDHCRXMJH,'、'),INSTR(S.SDHCRXMJH,'，'),INSTR(S.SDHCRXMJH,'&'),INSTR(S.SDHCRXMJH,' '))-1) AS HCRY1,
                        SUBSTR(S.SDHCRXMJH,GREATEST(INSTR(S.SDHCRXMJH,'##')+2,INSTR(S.SDHCRXMJH,'、')+1,INSTR(S.SDHCRXMJH,'，')+1,INSTR(S.SDHCRXMJH,'&')+1,INSTR(S.SDHCRXMJH,' ')+1)) AS HCRY2
                   FROM HX_CKTS.CKTS_BL_MDT_SHYDCL_GCB S
                  WHERE S.LCSLID=V_LCSLID
                    AND TRIM(S.SDHCRXMJH) IS NOT NULL) T
          INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
          WHERE ((TRIM(T.HCRY1) IS NULL) OR (TRIM(T.HCRY2) IS NULL) OR (TRIM(T.HCRY1)=TRIM(T.HCRY2)))
            AND ROWNUM=1;
    COMMIT;
    IF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023051201',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||DJ.NSRMC||'疑点业务处理实地核查人员数量检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID
              AND NOT EXISTS (SELECT 1 FROM FXNK_NBFXDMX_SZ S WHERE S.NKZBBH='2023051201' AND S.LCSLID=V_LCSLID)
              AND ROWNUM=1;
      COMMIT;
    END IF;
  END IF;
  -- 2023051201   事中
  IF SUBSTR(LC_LCSWSX,1,11) = 'LCSXA081039' THEN
    INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
         SELECT '2023051201',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                '【请确认】疑点业务处理实地核查人员是否少于2人；【核查人员】'||T.SDHCRXMJH
           FROM (SELECT S.*,
                        SUBSTR(S.SDHCRXMJH,1,GREATEST(INSTR(S.SDHCRXMJH,'##'),INSTR(S.SDHCRXMJH,'、'),INSTR(S.SDHCRXMJH,'，'),INSTR(S.SDHCRXMJH,'&'),INSTR(S.SDHCRXMJH,' '))-1) AS HCRY1,
                        SUBSTR(S.SDHCRXMJH,GREATEST(INSTR(S.SDHCRXMJH,'##')+2,INSTR(S.SDHCRXMJH,'、')+1,INSTR(S.SDHCRXMJH,'，')+1,INSTR(S.SDHCRXMJH,'&')+1,INSTR(S.SDHCRXMJH,' ')+1)) AS HCRY2
                   FROM HX_CKTS.CKTS_BL_MTS_SHYDCL_GCB S
                  WHERE S.LCSLID=V_LCSLID
                    AND TRIM(S.SDHCRXMJH) IS NOT NULL) T
          INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
          WHERE ((TRIM(T.HCRY1) IS NULL) OR (TRIM(T.HCRY2) IS NULL) OR (TRIM(T.HCRY1)=TRIM(T.HCRY2)))
            AND ROWNUM=1;
    COMMIT;
    IF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023051201',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||DJ.NSRMC||'疑点业务处理实地核查人员数量检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID
              AND NOT EXISTS (SELECT 1 FROM FXNK_NBFXDMX_SZ S WHERE S.NKZBBH='2023051201' AND S.LCSLID=V_LCSLID)
              AND ROWNUM=1;
      COMMIT;
    END IF;
  END IF;

  -- 复函实地核查后未制作工作底稿
  -- 2023051202  事中
  IF LC_LCSWSX='LCSXA132008017' THEN
    INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
         SELECT '2023051202',T.FUHXXBUUID,T.FUHSWJG_DM,NULL,T.GHQYNSRSBH_1,T.GHFQYMC_1,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                '【请确认】复函实地核查后是否制作工作底稿'
           FROM HX_ZH.ZH_CKTS_FUHXXB T
          WHERE T.LCSLID=V_LCSLID
            AND T.FHLX_DM IN ('1','2','7','8')
            AND TRIM(T.FHBH) IS NOT NULL
            AND NOT EXISTS (SELECT 1 FROM HX_ZH.ZH_CKTS_DCHSYGQKB DC WHERE DC.FUHXXBUUID=T.FUHXXBUUID); --调查核实有关情况表
    COMMIT;
    IF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023051202',T.FUHXXBUUID,T.FUHSWJG_DM,NULL,T.GHQYNSRSBH_1,T.GHFQYMC_1,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||T.GHFQYMC_1||'复函实地核查工作底稿检查通过'
             FROM HX_ZH.ZH_CKTS_FUHXXB T
            WHERE T.LCSLID=V_LCSLID
              AND NOT EXISTS (SELECT 1 FROM FXNK_NBFXDMX_SZ S WHERE S.NKZBBH='2023051202' AND S.LCSLID=V_LCSLID);
      COMMIT;
    END IF;
  END IF;

  -- 未按规定对先退税后核销业务开展实地核查（按年统计）
  -- 2023051301  X

  -- 未按规定对超期申报进料加工核销进行处罚
  -- 2023051401  事中
  IF LC_LCSWSX = 'LCSXA081038001' AND SYSDATE>=TO_DATE(TO_CHAR(SYSDATE,'YYYY')||'0501','YYYYMMDD') THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM (SELECT DISTINCT SC.BAH,SC.JARQ --上年度核销手册
              FROM HX_CKTS.CKTS_TY_YWBLXX T
             INNER JOIN HX_CKTS.CKTS_WBSJ_HG_DZSCHXXX SC ON SC.DJXH=T.DJXH
               AND SC.JARQ>=ADD_MONTHS(TRUNC(SYSDATE,'YY'),-12) AND SC.JARQ<TRUNC(SYSDATE,'YY')
               AND SUBSTR(SC.BAH,1,1)='C'
             WHERE T.LCSLID=V_LCSLID
               AND NOT EXISTS (SELECT 1
                                 FROM HX_CKTS.CKTS_SB_JLJG_MDTHX_JGB HX
                                WHERE HX.DJXH=T.DJXH AND HX.JLJGSZCH=SC.BAH
                                  AND HX.LRRQ<TO_DATE(TO_CHAR(SYSDATE,'YYYY')||'0501','YYYYMMDD')
                                UNION ALL
                               SELECT 1
                                 FROM HX_CKTS.CKTS_SB_JLJG_MDTHX_GCB HX
                                WHERE HX.DJXH=T.DJXH AND HX.JLJGSZCH=SC.BAH
                                  AND HX.LRRQ<TO_DATE(TO_CHAR(SYSDATE,'YYYY')||'0501','YYYYMMDD'))
             UNION ALL
            SELECT DISTINCT ZC.BAH,ZC.HXJZRQ -- 上年度核销账册
              FROM HX_CKTS.CKTS_TY_YWBLXX T
             INNER JOIN HX_CKTS.CKTS_WBSJ_HG_DZZCHXXX ZC ON ZC.DJXH=T.DJXH
               AND ZC.HXJZRQ>=ADD_MONTHS(TRUNC(SYSDATE,'YY'),-12) AND ZC.HXJZRQ<TRUNC(SYSDATE,'YY')
               AND SUBSTR(ZC.BAH,1,1) IN ('E','H','J')
             WHERE T.LCSLID=V_LCSLID
               AND NOT EXISTS (SELECT 1
                                 FROM HX_CKTS.CKTS_SB_JLJG_MDTHX_JGB HX
                                WHERE HX.DJXH=T.DJXH AND HX.JLJGSZCH=ZC.BAH
                                  AND HX.HXQSRQ<=ZC.HXQSRQ AND HX.HXJZRQ>=ZC.HXJZRQ
                                  AND HX.LRRQ<TO_DATE(TO_CHAR(SYSDATE,'YYYY')||'0501','YYYYMMDD')
                                UNION ALL
                               SELECT 1
                                 FROM HX_CKTS.CKTS_SB_JLJG_MDTHX_GCB HX
                                WHERE HX.DJXH=T.DJXH AND HX.JLJGSZCH=ZC.BAH
                                  AND HX.HXQSRQ<=ZC.HXQSRQ AND HX.HXJZRQ>=ZC.HXJZRQ
                                  AND HX.LRRQ<TO_DATE(TO_CHAR(SYSDATE,'YYYY')||'0501','YYYYMMDD'))
             /*UNION ALL
            SELECT DISTINCT SB.JLJGSZCH, TRUNC(SYSDATE,'YY')-1 --上年度申报账册，加了这一部分以后比较慢>10s
              FROM HX_CKTS.CKTS_TY_YWBLXX T
             INNER JOIN HX_CKTS.CKTS_SB_MDT_TSSB_JGB SB ON SB.DJXH=T.DJXH
               AND SB.LRRQ>=ADD_MONTHS(TRUNC(SYSDATE,'YY'),-12) AND SB.LRRQ<TRUNC(SYSDATE,'YY')
               AND SUBSTR(SB.JLJGSZCH,1,1) IN ('E','H','J')
             WHERE T.LCSLID=V_LCSLID
               AND NOT EXISTS (SELECT 1
                                 FROM HX_CKTS.CKTS_SB_JLJG_MDTHX_JGB HX
                                WHERE HX.DJXH=T.DJXH AND HX.JLJGSZCH=SB.JLJGSZCH
                                  AND HX.HXJZRQ>=ADD_MONTHS(TRUNC(SYSDATE,'YY'),-12) AND HX.HXJZRQ<TRUNC(SYSDATE,'YY')
                                  AND HX.LRRQ<TO_DATE(TO_CHAR(SYSDATE,'YYYY')||'0501','YYYYMMDD')
                                UNION ALL
                               SELECT 1
                                 FROM HX_CKTS.CKTS_SB_JLJG_MDTHX_GCB HX
                                WHERE HX.DJXH=T.DJXH AND HX.JLJGSZCH=SB.JLJGSZCH
                                  AND HX.HXJZRQ>=ADD_MONTHS(TRUNC(SYSDATE,'YY'),-12) AND HX.HXJZRQ<TRUNC(SYSDATE,'YY')
                                  AND HX.LRRQ<TO_DATE(TO_CHAR(SYSDATE,'YYYY')||'0501','YYYYMMDD'))*/
           );
    IF LL_ROWS>=1 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023051401',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】超期申报进料加工核销，是否已经进行处罚'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID
              AND NOT EXISTS (SELECT 1 -- 未登记进料加工
                                FROM HX_FZ.FZ_SSWFXWDJ FZ
                               WHERE FZ.DJXH=T.DJXH AND NVL(FZ.ZFBZ_1,'N')='N'
                                 AND FZ.DJRQ>=TO_DATE(TO_CHAR(SYSDATE,'YYYY')||'0501','YYYYMMDD')
                                 AND FZ.WFSS LIKE '%进料加工%');
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023051401',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||DJ.NSRMC||'超期申报进料加工核销检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  END IF;

  -- 未按规定对四类出口企业申报的出口退（免）税发函调查
  -- 2023051501  事中
  -- 20250331 根据李裕军局长要求，将间隔12个月改成间隔10个月
  IF SUBSTR(LC_LCSWSX,1,11)='LCSXA081038' THEN
    SELECT COUNT(JH.XHFNSRSBH)
      INTO LL_ROWS
      FROM HX_CKTS.CKTS_TY_YWBLXX T
     INNER JOIN HX_CKTS.CKTS_SB_MDT_STZCQD_GCB JH ON JH.LCSLID=T.LCSLID
     WHERE T.LCSLID=V_LCSLID
       AND T.CKQYGLLB_DM='D'
       AND NOT EXISTS (SELECT 1 -- 不存在申报以前10个月正常回函
                         FROM HX_ZH.ZH_CKTS_FHXXB FH
                        INNER JOIN HX_ZH.ZH_CKTS_FUHXXB FUH ON FH.FHXXBUUID=FUH.FHXXBUUID
                        WHERE FH.GHFDJXH=JH.DJXH AND FH.GHQYNSRSBH_1=JH.XHFNSRSBH
                          AND NVL(FH.ZFBZ_1,'N')='N' AND NVL(FUH.ZFBZ_1,'N')='N'
                          AND FUH.FHLX_DM='1' AND FUH.QFRQ>=ADD_MONTHS(SYSDATE,-10));
    IF LL_ROWS>=1 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023051501',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】四类出口企业供货商不存在申报以前10个月内的正常回函，是否抽取一定比例发函调查'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023051501',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||DJ.NSRMC||'四类出口企业供货商发函调查销检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  ELSIF SUBSTR(LC_LCSWSX,1,11)='LCSXA081039' THEN
    SELECT COUNT(JH.GHFNSRSBH_1)
      INTO LL_ROWS
      FROM HX_CKTS.CKTS_TY_YWBLXX T
     INNER JOIN HX_CKTS.CKTS_SB_MTS_TSJH_GCB JH ON JH.LCSLID=T.LCSLID
     WHERE T.LCSLID=V_LCSLID
       AND T.CKQYGLLB_DM='D'
       AND NOT EXISTS (SELECT 1 -- 不存在申报以前10个月正常回函
                         FROM HX_ZH.ZH_CKTS_FHXXB FH
                        INNER JOIN HX_ZH.ZH_CKTS_FUHXXB FUH ON FH.FHXXBUUID=FUH.FHXXBUUID
                        WHERE FH.GHFDJXH=JH.DJXH AND FH.GHQYNSRSBH_1=JH.GHFNSRSBH_1
                          AND NVL(FH.ZFBZ_1,'N')='N' AND NVL(FUH.ZFBZ_1,'N')='N'
                          AND FUH.FHLX_DM='1' AND FUH.QFRQ>=ADD_MONTHS(SYSDATE,-10));
    IF LL_ROWS>=1 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023051501',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】四类出口企业供货商不存在申报以前10个月内的正常回函，是否抽取一定比例发函调查'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023051501',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||DJ.NSRMC||'四类出口企业供货商发函调查销检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  END IF;

  -- 未按规定对不予退税函件追溯发函
  -- 2023051601   事前

  -- 未按规定对非本地区管辖的函件重新发函
  -- 2023051701   事前

  -- 未在规定期限内复函
  -- 2023051801  单独短信提醒

  -- 违规对正在接受纳税评估、稽查的供货企业按“正常业务”复函
  -- 2023051901  事中
  IF LC_LCSWSX='LCSXA132008017' THEN
    INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
         SELECT '2023051901',T.FUHXXBUUID,T.FUHSWJG_DM,NULL,T.GHQYNSRSBH_1,T.GHFQYMC_1,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                '【请确认】该企业正在接受纳税评估、稽查期间，是否按正常业务回函'
           FROM HX_ZH.ZH_CKTS_FUHXXB T
          INNER JOIN HX_ZH.ZH_CKTS_FHXXB F1 ON F1.FHXXBUUID=T.FHXXBUUID
          INNER JOIN HX_JC.JC_AJXX JC ON JC.DJXH=F1.GHFDJXH1 AND JC.LARQ<SYSDATE AND NVL(JC.ZFBZ_1,'N')='N'
            AND JC.AJJCZT_DM<>'600' -- 剔除案源撤销的
           LEFT JOIN HX_FZ.FZ_SWXZCFJDS CF ON CF.SSWFXWDJUUID=JC.JCAJXXUUID AND NVL(CF.ZFBZ_1,'N')='N' --取税务行政处罚决定书制作日期
           LEFT JOIN HX_JC.JC_SWCLJDS CL ON CL.JCAJXXUUID=JC.JCAJXXUUID AND NVL(CL.ZFBZ_1,'N')='N' --取税务处理决定书制作日期
          WHERE T.LCSLID=V_LCSLID
            AND T.FHLX_DM='1' -- 按“正常业务”复函
            AND TRIM(T.FHBH) IS NOT NULL
            AND JC.JARQ IS NULL AND CF.WSZZRQ IS NULL AND CL.WSZZRQ IS NULL;
    COMMIT;
    IF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023051901',T.FUHXXBUUID,T.FUHSWJG_DM,NULL,T.GHQYNSRSBH_1,T.GHFQYMC_1,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||T.GHFQYMC_1||'复函实地核查工作底稿检查通过'
             FROM HX_ZH.ZH_CKTS_FUHXXB T
            WHERE T.LCSLID=V_LCSLID
              AND NOT EXISTS (SELECT 1 FROM FXNK_NBFXDMX_SZ S WHERE S.NKZBBH='2023051901' AND S.LCSLID=V_LCSLID);
      COMMIT;
    END IF;
  END IF;

  -- 未核查供货企业发票为虚开或伪造，违规按“正常业务”类型复函
  -- 2023052001  X

  -- 无合理理由再次复函改变原复函类型
  -- 2023052101  事中
  IF LC_LCSWSX='LCSXA132008017' THEN
    INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
         SELECT '2023052101',T.FUHXXBUUID,T.FUHSWJG_DM,NULL,T.GHQYNSRSBH_1,T.GHFQYMC_1,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                '【请确认】该企业上次回函类型为'||H2.FHLX_DM||'，是否改为按类型'||T.FHLX_DM||'回函'
           FROM HX_ZH.ZH_CKTS_FUHXXB T
          INNER JOIN HX_ZH.ZH_CKTS_FUHXXB H2 ON H2.HSHBH=T.HSHBH AND H2.FHBH<>T.FHBH
            AND H2.QFRQ<SYSDATE AND NVL(H2.ZFBZ_1,'N')='N' AND H2.FHBH IS NOT NULL
          WHERE T.LCSLID=V_LCSLID
            AND ((T.FHLX_DM IN ('1','3') AND H2.FHLX_DM IN ('2','8')) OR --从“异常业务”或“存在不予退免税发票”改为“正常业务”或“经核查尚未处理完毕”
                 (T.FHLX_DM IN ('2','8') AND H2.FHLX_DM='1')) --从“正常业务”改为“异常业务”或“存在不予退免税发票”
            AND TRIM(T.FHBH) IS NOT NULL;
    COMMIT;
    IF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023052101',T.FUHXXBUUID,T.FUHSWJG_DM,NULL,T.GHQYNSRSBH_1,T.GHFQYMC_1,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||T.GHFQYMC_1||'再次复函改变原复函类型检查通过'
             FROM HX_ZH.ZH_CKTS_FUHXXB T
            WHERE T.LCSLID=V_LCSLID
              AND NOT EXISTS (SELECT 1 FROM FXNK_NBFXDMX_SZ S WHERE S.NKZBBH='2023052101' AND S.LCSLID=V_LCSLID);
      COMMIT;
    END IF;
  END IF;

  -- 违规对未收到复函的业务提前办理退免税
  -- 2023052201  事中
  IF SUBSTR(LC_LCSWSX,1,11) = 'LCSXA081039' THEN
    INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
         SELECT '2023052201',MIN(JH.UUID),JH.TSSWJG_DM_1,JH.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                '【请确认】存在供应商('||JH.GHFNSRSBH_1||')进货发票('||JH.JHPZH||')发函未回'
           FROM HX_CKTS.CKTS_SB_MTS_TSJH_GCB JH
          INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=JH.DJXH
           LEFT JOIN HX_CKTS.CKTS_BL_MTS_SHYDDCLB DCL
             ON DCL.DJXH=JH.DJXH AND DCL.GLH=JH.GLH-- AND DCL.SBXH=JH.SBXH
          WHERE JH.LCSLID=V_LCSLID
            AND NVL(JH.BYTSBZ,'N')='N' --非不予退税
            AND NVL(JH.BYBLBZ,'N')='N' --非不予办理
            AND NVL(DCL.JCZBBLZT_DM,'1')<>'3' --非暂不办理
            AND EXISTS (
                SELECT 1
                  FROM HX_ZH.ZH_CKTS_FHXXB F1
                 INNER JOIN HX_ZH.ZH_CKTS_HDFPQD QD
                    ON QD.FHXXBUUID=F1.FHXXBUUID AND QD.SFYTS='N' AND NVL(QD.ZFBZ_1,'N')='N' -- 发函时发票未退税
                  LEFT JOIN HX_ZH.ZH_CKTS_FUHXXB H1
                    ON H1.FHXXBUUID=F1.FHXXBUUID AND NVL(H1.ZFBZ_1,'N')='N' AND TRIM(H1.FHBH) IS NOT NULL
                   AND NVL(H1.FHLX_DM,'3')<>'3' -- 剔除延期回函
                 WHERE F1.GHFDJXH=JH.DJXH AND F1.GHQYNSRSBH_1=JH.GHFNSRSBH_1
                   --AND F1.QFRQ IS NOT NULL -- 发函已签发
                   AND NVL(F1.ZFBZ_1,'N') = 'N' -- 未作废
                   AND QD.ZZSZYFPDMHM=JH.JHPZH
                   AND H1.FHXXBUUID IS NULL) -- 还没有结论明确（非延期函）的回函
          GROUP BY JH.TSSWJG_DM_1,JH.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,JH.GHFNSRSBH_1,JH.JHPZH;
    COMMIT;
    IF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023052201',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||DJ.NSRMC||'违规对未收到复函的业务提前办理退免税检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID
              AND NOT EXISTS (SELECT 1 FROM FXNK_NBFXDMX_SZ S WHERE S.NKZBBH='2023052201' AND S.LCSLID=V_LCSLID)
              AND ROWNUM=1;
      COMMIT;
    END IF;
  END IF;

  -- 未按规定处理“存在不予退（免）税的情形”、“暂缓办理退（免）税”的复函
  -- 2023052301   事前
  -- 2023052302   事前

  -- 未按规定对停权出口企业录入停止退税标志
  -- 2023052401  X

  -- 稽查立案后未进行暂缓或暂扣税款处理
  -- 2023052501   事前

  -- 收到异常抵扣凭证未按照规定处理
  -- 2023052601  X

  -- 不应撤回而撤回存在不予退税情形的出口退（免）税申报
  -- 2023052701  事中
  IF LC_LCSWSX='LCSXA081045004' THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM HX_CKTS.CKTS_TY_YWBLXX T
     INNER JOIN HX_CKTS.CKTS_SB_QYCHSBSJSL_GCB CH ON CH.LCSLID=T.LCSLID --对应撤回申请
     INNER JOIN HX_CKTS.CKTS_SB_MTS_TSJH_GCB JH ON JH.DJXH=T.DJXH AND JH.SSQ=CH.SBCHYSSQ AND JH.SBPC=CH.SBCHYSBPC --撤回申请中对应进货明细
     INNER JOIN HX_ZH.ZH_CKTS_HDFPQD QD ON QD.ZZSZYFPDMHM=JH.JHPZH --存在函调发票
     INNER JOIN HX_ZH.ZH_CKTS_FHXXB F1 ON F1.FHXXBUUID=QD.FHXXBUUID AND NVL(F1.ZFBZ_1,'N')='N' AND F1.QFRQ IS NOT NULL -- 已发函
     WHERE T.LCSLID=V_LCSLID
       AND NOT EXISTS (SELECT 1
                         FROM HX_ZH.ZH_CKTS_FUHXXB H1
                        WHERE H1.FHXXBUUID=F1.FHXXBUUID AND NVL(H1.ZFBZ_1,'N')='N' AND TRIM(H1.FHBH) IS NOT NULL
                          AND H1.FHLX_DM='1');
    IF LL_ROWS>=1 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023052701',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】企业申请撤回的申报批次中，存在已发函且未收到“正常业务”回函的发票，是否准许撤回'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023052701',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||DJ.NSRMC||'申请撤回的申报批次是否存在已发函且未收到“正常业务”回函的发票检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  END IF;

  -- 为出口企业办理退免税计算方法变更的，未结清变更前出口退（免）税款
  -- 2023052801  事中
  IF LC_LCSWSX = 'LCSXA081032001' THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM HX_CKTS.CKTS_TY_YWBLXX T
     WHERE T.DJXH=LN_DJXH
       AND REGEXP_LIKE(T.LCSWSX_DM,'^LCSXA081038|^LCSXA081039|^LCSXA081040|^LCSXA081042')
       AND NVL(T.FFBZ,'N')='N' AND NVL(T.ZFBZ_1,'N')='N';
    IF LL_ROWS>=1 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023052801',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】以下税款是否结清；【未完结退税流程】'||LL_ROWS||'条'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            INNER JOIN HX_CKTS.CKTS_BA_BABGQK_JGB BG ON BG.LCSLID=T.LCSLID AND BG.BABGZD_DM='CKHWTMSJSFF_DM'
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023052801',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||DJ.NSRMC||'变更退免税计算方法未完结退税流程检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;

    SELECT COUNT(1)
      INTO LL_ROWS
      FROM HX_CKTS.CKTS_WBSJ_HG_BGD201 T
     WHERE T.DJXH=LN_DJXH
       AND T.TSSBSL+T.DLSBSL=0 AND T.CKSL-T.TYSL>0  --未申报退税、代理证明，同时未全部退运
       AND EXISTS (SELECT 1 -- 监管方式退税
                     FROM HX_DM_ZDY.DM_CKTS_HGJGFS
                    WHERE JGFS_DM = T.JGFS_DM
                      AND JGFSTSLX_DM='1')
       AND EXISTS (SELECT 1
                    FROM HX_CKTS.CKTS_TY_CKSPTSLWK --商品文库退税
                   WHERE (CKSP_DM = T.CKSP_DM OR CKSP_DM = SUBSTR(T.CKSP_DM,1,8))
                     AND T.CKRQ_1 BETWEEN YXQQ AND YXQZ
                     AND TRIM(CKSPTSSPLX_DM) IS NULL);
    IF LL_ROWS>=1 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023052801',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】以下税款是否结清；【未申报退税报关单】'||LL_ROWS||'条'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            INNER JOIN HX_CKTS.CKTS_BA_BABGQK_JGB BG ON BG.LCSLID=T.LCSLID AND BG.BABGZD_DM='CKHWTMSJSFF_DM'
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023052801',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||DJ.NSRMC||'变更退免税计算方法未申报退税报关单检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;

    BEGIN
      SELECT NVL(SUM(T.YTSE_1),0)
        INTO LN_WJQTSE
        FROM HX_CKTS.CKTS_BL_MTS_SHYDDCLB T
       WHERE T.DJXH=LN_DJXH;
    EXCEPTION
      WHEN OTHERS THEN
        LN_WJQTSE := 0;
    END;
    IF LN_WJQTSE>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023052801',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】以下税款是否结清；【未解除暂不办理退税额】'||LN_WJQTSE
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            INNER JOIN HX_CKTS.CKTS_BA_BABGQK_JGB BG ON BG.LCSLID=T.LCSLID AND BG.BABGZD_DM='CKHWTMSJSFF_DM'
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023052801',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||DJ.NSRMC||'变更退免税计算方法未解除暂不办理退税额检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;

    BEGIN
      SELECT NVL(SUM(T.SE),0)
        INTO LN_WJQTSE
        FROM HX_ZS.ZS_YDTXX T
        LEFT JOIN HX_ZS.ZS_SRTHS TH ON TH.YDTUUID=T.YDTUUID AND TH.TZLX_DM IN ('1','4')
       WHERE T.DJXH=LN_DJXH
         AND T.TTSJLX_DM='01' AND T.TZLX_DM='1' AND T.TDSFS_DM='1'
         AND TH.THRQ_1 IS NULL;
    EXCEPTION
      WHEN OTHERS THEN
        LN_WJQTSE := 0;
    END;
    IF LN_WJQTSE>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023052801',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】以下税款是否结清；【已核准待开具退税额】'||LN_WJQTSE
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            INNER JOIN HX_CKTS.CKTS_BA_BABGQK_JGB BG ON BG.LCSLID=T.LCSLID AND BG.BABGZD_DM='CKHWTMSJSFF_DM'
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023052801',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||DJ.NSRMC||'变更退免税计算方法已核准待开具退税额检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;

    BEGIN
      SELECT NVL(SUM(T.MD_AMT),0)
        INTO LN_WJQTSE
        FROM HX_ZS.ZS_CKTS_MDT T
        LEFT JOIN HX_ZS.ZS_TKGZ TK ON TK.DJXH=T.DJXH AND TK.BTKGZUUID=T.CKTS_NO AND TK.TZSLY='3' AND TK.TZLX_DM='1' AND TK.GZBZ='Y' AND TK.ZFRQ_1 IS NULL
       WHERE T.DJXH=LN_DJXH
         AND T.TZLX_DM='1'
         AND TK.GKGZRQ IS NULL;
    EXCEPTION
      WHEN OTHERS THEN
        LN_WJQTSE := 0;
    END;
    IF LN_WJQTSE>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023052801',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】以下税款是否结清；【已核准待调库免抵额】'||LN_WJQTSE
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            INNER JOIN HX_CKTS.CKTS_BA_BABGQK_JGB BG ON BG.LCSLID=T.LCSLID AND BG.BABGZD_DM='CKHWTMSJSFF_DM'
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023052801',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||DJ.NSRMC||'变更退免税计算方法已核准待调库免抵额检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;

    BEGIN
      SELECT NVL(T.JZXQMDTSE,0)
        INTO LN_WJQTSE
        FROM HX_CKTS.CKTS_SB_MDT_SBDSHZ_JGB T
       WHERE T.DJXH=LN_DJXH
         AND T.JZXQMDTSE<>0
         AND NOT EXISTS (SELECT 1 FROM HX_CKTS.CKTS_SB_MDT_SBDSHZ_JGB S WHERE S.DJXH=T.DJXH AND S.SSQ>T.SSQ);
    EXCEPTION
      WHEN OTHERS THEN
        LN_WJQTSE := 0;
    END;
    IF LN_WJQTSE>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023052801',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】以下税款是否结清；【结转下期免抵退税额】'||LN_WJQTSE
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            INNER JOIN HX_CKTS.CKTS_BA_BABGQK_JGB BG ON BG.LCSLID=T.LCSLID AND BG.BABGZD_DM='CKHWTMSJSFF_DM'
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023052801',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||DJ.NSRMC||'变更退免税计算方法结转下期免抵退税额检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  END IF;

  -- 在变更退免税计算方法后，为企业办理变更前出口货物退（免）税。
  -- 2023052802  事中
  IF SUBSTR(LC_LCSWSX,1,11)='LCSXA081038' THEN
    BEGIN
      SELECT NVL(MAX(T.LRRQ),DATE'1900-01-01')
        INTO LD_BGTMSJSFF
        FROM HX_CKTS.CKTS_BA_BABGQK_JGB T
       WHERE T.DJXH=LN_DJXH
         AND T.BABGZD_DM='CKHWTMSJSFF_DM';
    EXCEPTION
      WHEN OTHERS THEN
        LD_BGTMSJSFF := DATE'1900-01-01';
    END;
    IF LD_BGTMSJSFF>DATE'1900-01-01' THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023052802',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】存在退免税计算方法变更前出口的业务，是否继续推送；【变更日期】'||TO_CHAR(LD_BGTMSJSFF,'YYYYMMDD')
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID
              AND EXISTS (SELECT 1
                            FROM HX_CKTS.CKTS_SB_MDT_TSSB_GCB MDT
                           WHERE MDT.LCSLID=T.LCSLID AND MDT.CKRQ_1<LD_BGTMSJSFF)
              AND EXISTS (SELECT 1
                            FROM HX_CKTS.CKTS_SB_MTS_TSSB_JGB MTS
                           WHERE MTS.DJXH=T.DJXH AND MTS.LRRQ<LD_BGTMSJSFF);
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023052802',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||DJ.NSRMC||'退免税计算方法变更前出口业务检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  ELSIF SUBSTR(LC_LCSWSX,1,11)='LCSXA081039' THEN
    BEGIN
      SELECT NVL(MAX(T.LRRQ),DATE'1900-01-01')
        INTO LD_BGTMSJSFF
        FROM HX_CKTS.CKTS_BA_BABGQK_JGB T
       WHERE T.DJXH=LN_DJXH
         AND T.BABGZD_DM='CKHWTMSJSFF_DM';
    EXCEPTION
      WHEN OTHERS THEN
        LD_BGTMSJSFF := DATE'1900-01-01';
    END;
    IF LD_BGTMSJSFF>DATE'1900-01-01' THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023052802',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】存在退免税计算方法变更前出口的业务，是否继续推送；【变更日期】'||TO_CHAR(LD_BGTMSJSFF,'YYYYMMDD')
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID
              AND EXISTS (SELECT 1
                            FROM HX_CKTS.CKTS_SB_MTS_TSSB_GCB MTS
                           WHERE MTS.LCSLID=T.LCSLID AND MTS.CKRQ_1<LD_BGTMSJSFF)
              AND EXISTS (SELECT 1
                            FROM HX_CKTS.CKTS_SB_MDT_TSSB_JGB MDT
                           WHERE MDT.DJXH=T.DJXH AND MDT.LRRQ<LD_BGTMSJSFF);
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023052802',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||DJ.NSRMC||'退免税计算方法变更前出口业务检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  END IF;

  -- 小规模纳税人期间出口的报关单在认定为一般纳税人之后进行退税申报
  -- 2023052901  X

  -- 未按规定处理系统提示的审核疑点
  -- 2023070101  事中
  -- 2023070102  事中
  -- 2023070103  事中
  -- 2023070104  事中
  -- 2023070105  事中
  -- 2023070106  事中
  -- 2023070107  事中
  -- 2023070108  事中
  IF SUBSTR(LC_LCSWSX,1,11)='LCSXA081038' THEN
    SELECT COUNT(1),MIN(T.UUID)
      INTO LL_ROWS,LC_UUID
      FROM HX_CKTS.CKTS_BL_MDT_SHYD_GCB T
     WHERE T.LCSLID=V_LCSLID
       AND T.SHYDCL_DM='02' -- 挑过的
       AND LENGTH(T.CLYJSM)<8;
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
      SELECT '2023070101',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
             '【请确认】免抵退疑点挑过处理意见说明是否过于简单'
        FROM HX_CKTS.CKTS_BL_MDT_SHYD_GCB T
       INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
       WHERE T.UUID=LC_UUID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023070101',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||DJ.NSRMC||'免抵退疑点挑过处理意见说明是否过于简单检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID
              AND ROWNUM=1;
      COMMIT;
    END IF;
    
    SELECT COUNT(1),MIN(T.UUID)
      INTO LL_ROWS,LC_UUID
      FROM HX_CKTS.CKTS_BL_MDT_SHYDCL_JGB T
     WHERE T.LCSLID=V_LCSLID
       AND T.SHDCHSJYDMJH='2' -- 发函
       AND TRIM(FHBH) IS NULL -- 函件编号为空
       AND ZHSHCLYJLX_DM ='4'; -- 综合审核处理意见类型代码=4准予退税
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
      SELECT '2023070106',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
             '【请确认】免抵退疑点意见为发函调查，请确认是否已发函'
        FROM HX_CKTS.CKTS_BL_MDT_SHYDCL_JGB T
       INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
       WHERE T.UUID=LC_UUID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023070106',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||DJ.NSRMC||'免抵退疑点应发函未发函检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID
              AND ROWNUM=1;
      COMMIT;
    END IF;
  ELSIF SUBSTR(LC_LCSWSX,1,11)='LCSXA081039' THEN
    SELECT COUNT(1),MIN(T.UUID)
      INTO LL_ROWS,LC_UUID
      FROM HX_CKTS.CKTS_BL_MTS_SHYD_GCB T
     WHERE T.LCSLID=V_LCSLID
       AND T.SHYDCL_DM='02' -- 挑过的
       AND LENGTH(T.CLYJSM)<8;
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
      SELECT '2023070102',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
             '【请确认】免退税疑点挑过处理意见说明是否过于简单'
        FROM HX_CKTS.CKTS_BL_MTS_SHYD_GCB T
       INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
       WHERE T.UUID=LC_UUID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023070102',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||DJ.NSRMC||'免退税疑点挑过处理意见说明是否过于简单检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID
              AND ROWNUM=1;
      COMMIT;
    END IF;

    SELECT COUNT(1),MIN(T.UUID)
      INTO LL_ROWS,LC_UUID
      FROM HX_CKTS.CKTS_BL_MTS_SHYDCL_JGB T
     WHERE T.LCSLID=V_LCSLID
       AND T.SHDCHSJYDMJH='2' -- 发函
       AND TRIM(FHBH) IS NULL -- 函件编号为空
       AND ZHSHCLYJLX_DM ='4' -- 综合审核处理意见类型代码=4准予退税
       AND NOT EXISTS (SELECT 1 --不存在12个月内从同一供货企业购进同类商品的正常回函
                         FROM HX_ZH.ZH_CKTS_FHXXB F1
                        INNER JOIN HX_ZH.ZH_CKTS_HDFPQD QD ON QD.FHXXBUUID=F1.FHXXBUUID
                        INNER JOIN HX_CKTS.CKTS_SB_MTS_TSJH_JGB JH ON JH.DJXH=F1.GHFDJXH AND JH.JHPZH=QD.ZZSZYFPDMHM
                        INNER JOIN HX_ZH.ZH_CKTS_FUHXXB H1 ON H1.FHXXBUUID=F1.FHXXBUUID
                        WHERE F1.GHFDJXH=T.DJXH AND F1.GHQYNSRSBH_1=T.GHFNSRSBH_1
                          AND JH.CKSP_DM=T.CKSP_DM
                          AND NVL(H1.ZFBZ_1,'N')='N' AND TRIM(H1.FHBH) IS NOT NULL AND H1.FHLX_DM='1'
                          AND H1.QFRQ>=ADD_MONTHS(T.LRRQ,-12) AND H1.QFRQ<T.XGRQ);
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
      SELECT '2023070107',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
             '【请确认】免退税疑点意见为发函调查，请确认是否已发函'
        FROM HX_CKTS.CKTS_BL_MTS_SHYDCL_JGB T
       INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
       WHERE T.UUID=LC_UUID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023070107',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||DJ.NSRMC||'免退税疑点应发函未发函检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID
              AND ROWNUM=1;
      COMMIT;
    END IF;
  ELSIF SUBSTR(LC_LCSWSX,1,11)='LCSXA081040' THEN
    SELECT COUNT(1),MIN(T.UUID)
      INTO LL_ROWS,LC_UUID
      FROM HX_CKTS.CKTS_BL_DB_SHYD_GCB T
     WHERE T.LCSLID=V_LCSLID
       AND T.SHYDCL_DM='02' -- 挑过的
       AND LENGTH(T.CLYJSM)<8;
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
      SELECT '2023070103',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
             '【请确认】代办退税疑点挑过处理意见说明是否过于简单'
        FROM HX_CKTS.CKTS_BL_DB_SHYD_GCB T
       INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
       WHERE T.UUID=LC_UUID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023070103',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||DJ.NSRMC||'代办退税疑点挑过处理意见说明是否过于简单检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID
              AND ROWNUM=1;
      COMMIT;
    END IF;

    SELECT COUNT(1),MIN(T.UUID)
      INTO LL_ROWS,LC_UUID
      FROM HX_CKTS.CKTS_BL_DB_SHYDCL_JGB T
     WHERE T.LCSLID=V_LCSLID
       AND T.SHDCHSJYDMJH='2' -- 发函
       AND TRIM(FHBH) IS NULL -- 函件编号为空
       AND ZHSHCLYJLX_DM ='4'; -- 综合审核处理意见类型代码=4准予退税
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
      SELECT '2023070108',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
             '【请确认】代办退税疑点意见为发函调查，请确认是否已发函'
        FROM HX_CKTS.CKTS_BL_DB_SHYDCL_JGB T
       INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
       WHERE T.UUID=LC_UUID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023070108',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】'||DJ.NSRMC||'代办退税疑点应发函未发函检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID
              AND ROWNUM=1;
      COMMIT;
    END IF;
  END IF;

  -- 应暂不办理而办理出口退税（进出口税收管理部门已移送稽查部门的出口业务）
  -- 2023070201  X

  -- 应追回未追回已退税税款
  -- 2023070301   事前

  -- 应暂不办理而办理出口退税（因涉嫌骗取出口退税被税务机关稽查部门立案查处未结案的出口业务）
  -- 2023070401  X

  -- 违规兼任出口退（免）税岗位（免抵退税）
  -- 2023070501  事中
  IF LC_LCSWSX = 'LCSXA081038006' THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM HX_CKTS.CKTS_BL_MDT_SHYDCL_GCB YD
     INNER JOIN HX_CKTS.CKTS_TY_YWBLXX SHLC ON SHLC.DJXH=YD.DJXH AND SHLC.SSQ=YD.SSQ
       AND SHLC.LCSWSX_DM='LCSXA081038001' AND NVL(SHLC.ZFBZ_1,'N')='N' AND NVL(SHLC.HTBZ_1,'N')='N'
     INNER JOIN HX_CKTS.CKTS_TY_TSSBYWBL_MXB SHHJ ON SHHJ.LCSLID=SHLC.LCSLID AND SHHJ.LCHJ_DM='02'
     INNER JOIN HX_DM_ZDY.DM_GY_SWRY SHRY ON SHRY.SWRY_DM=SHHJ.TS_RYDM
     WHERE YD.LCSLID=V_LCSLID
       AND TRIM(YD.SDHCBGBH) IS NOT NULL AND REGEXP_LIKE(YD.SDHCRXMJH,SHRY.SWRYXM);
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023070501',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】核查人员是否在在同一企业同一批次曾经流转过'
             FROM HX_CKTS.CKTS_BL_MDT_SHYDCL_GCB T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID
              AND ROWNUM=1;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023070501',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】核查人员兼岗检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID
              AND ROWNUM=1;
      COMMIT;
    END IF;
  END IF;

  -- 违规兼任出口退（免）税岗位（免退税）
  -- 2023070502  事中
  IF LC_LCSWSX = 'LCSXA081039006' THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM HX_CKTS.CKTS_BL_MTS_SHYDCL_GCB YD
     INNER JOIN HX_CKTS.CKTS_TY_YWBLXX SHLC ON SHLC.DJXH=YD.DJXH AND SHLC.SSQ=YD.SSQ AND SHLC.SBPC=YD.SBPC
       AND SHLC.LCSWSX_DM='LCSXA081039001' AND NVL(SHLC.ZFBZ_1,'N')='N' AND NVL(SHLC.HTBZ_1,'N')='N'
     INNER JOIN HX_CKTS.CKTS_TY_TSSBYWBL_MXB SHHJ ON SHHJ.LCSLID=SHLC.LCSLID AND SHHJ.LCHJ_DM='02'
     INNER JOIN HX_DM_ZDY.DM_GY_SWRY SHRY ON SHRY.SWRY_DM=SHHJ.TS_RYDM
     WHERE YD.LCSLID=V_LCSLID
       AND TRIM(YD.SDHCBGBH) IS NOT NULL AND REGEXP_LIKE(YD.SDHCRXMJH,SHRY.SWRYXM);
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023070502',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】核查人员是否在在同一企业同一批次曾经流转过'
             FROM HX_CKTS.CKTS_BL_MTS_SHYDCL_GCB T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID
              AND ROWNUM=1;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023070502',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】核查人员兼岗检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID
              AND ROWNUM=1;
      COMMIT;
    END IF;
  END IF;

  -- 违规兼任出口退（免）税岗位（代办退税）
  -- 2023070503  事中
  IF LC_LCSWSX = 'LCSXA081040006' THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM HX_CKTS.CKTS_BL_DB_SHYDCL_GCB YD
     INNER JOIN HX_CKTS.CKTS_TY_YWBLXX SHLC ON SHLC.DJXH=YD.DJXH AND SHLC.SSQ=YD.SSQ AND SHLC.SBPC=YD.SBPC
       AND SHLC.LCSWSX_DM='LCSXA081040001' AND NVL(SHLC.ZFBZ_1,'N')='N' AND NVL(SHLC.HTBZ_1,'N')='N'
     INNER JOIN HX_CKTS.CKTS_TY_TSSBYWBL_MXB SHHJ ON SHHJ.LCSLID=SHLC.LCSLID AND SHHJ.LCHJ_DM='02'
     INNER JOIN HX_DM_ZDY.DM_GY_SWRY SHRY ON SHRY.SWRY_DM=SHHJ.TS_RYDM
     WHERE YD.LCSLID=V_LCSLID
       AND TRIM(YD.SDHCBGBH) IS NOT NULL AND REGEXP_LIKE(YD.SDHCRXMJH,SHRY.SWRYXM);
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023070503',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】核查人员是否在同一企业同一批次曾经流转过'
             FROM HX_CKTS.CKTS_BL_DB_SHYDCL_GCB T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID
              AND ROWNUM=1;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023070503',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】核查人员兼岗检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID
              AND ROWNUM=1;
      COMMIT;
    END IF;
  END IF;

  -- 违规兼任出口退（免）税岗位（系统维护岗兼岗）
  -- 2023070601  X

  -- 出口退（免）税事项长期未办结
  -- 2023070701   事前
  -- 2023070702   事前

  -- 未按规定核实四类企业收汇资料
  -- 2023070801  事中
  IF SUBSTR(LC_LCSWSX,1,11)='LCSXA081038' THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM HX_CKTS.CKTS_TY_YWBLXX YW
     WHERE YW.LCSLID=V_LCSLID
       AND YW.CKQYGLLB_DM='D' --申报的时候为四类企业
       AND EXISTS (SELECT 1 FROM HX_CKTS.CKTS_SB_MDT_CKSH_GCB SH WHERE SH.LCSLID=YW.LCSLID)
       AND NOT EXISTS (SELECT 1 FROM HX_CKTS.CKTS_SB_MDT_CKSHCC_GCB CC WHERE CC.DJXH=YW.DJXH AND CC.SSQ=YW.SSQ);
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023070801',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】是否已按规定核实四类企业收汇资料'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023070801',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】按规定核实四类企业收汇资料检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  ELSIF SUBSTR(LC_LCSWSX,1,11)='LCSXA081039' THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM HX_CKTS.CKTS_TY_YWBLXX YW
     WHERE YW.LCSLID=V_LCSLID
       AND YW.CKQYGLLB_DM='D' --申报的时候为四类企业
       AND EXISTS (SELECT 1 FROM HX_CKTS.CKTS_SB_MTS_CKSH_GCB SH WHERE SH.LCSLID=YW.LCSLID)
       AND NOT EXISTS (SELECT 1 FROM HX_CKTS.CKTS_SB_MTS_CKSHCC_GCB CC WHERE CC.DJXH=YW.DJXH AND CC.SSQ=YW.SSQ AND CC.SBPC=YW.SBPC);
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023070801',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】是否已按规定核实四类企业收汇资料'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023070801',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】按规定核实四类企业收汇资料检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  ELSIF SUBSTR(LC_LCSWSX,1,11)='LCSXA081040' THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM HX_CKTS.CKTS_TY_YWBLXX YW
     WHERE YW.LCSLID=V_LCSLID
       AND YW.CKQYGLLB_DM='D' --申报的时候为四类企业
       AND EXISTS (SELECT 1 FROM HX_CKTS.CKTS_SB_DB_CKHWSH_GCB SH WHERE SH.LCSLID=YW.LCSLID)
       AND NOT EXISTS (SELECT 1 FROM HX_CKTS.CKTS_SB_DB_CKHWSHCC_GCB CC WHERE CC.DJXH=YW.DJXH AND CC.SSQ=YW.SSQ AND CC.SBPC=YW.SBPC);
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023070801',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】是否已按规定核实四类企业收汇资料'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023070801',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】按规定核实四类企业收汇资料检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  END IF;

  -- 未按规定核实往年出口货物收汇资料
  -- 2023070901  事中
  IF SUBSTR(LC_LCSWSX,1,11)='LCSXA081038' THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM HX_CKTS.CKTS_TY_YWBLXX YW
     WHERE YW.LCSLID=V_LCSLID
       AND YW.CKQYGLLB_DM<>'D' --申报的时候非四类企业
       AND EXISTS (SELECT 1 FROM HX_CKTS.CKTS_SB_MDT_TSSB_GCB CK WHERE CK.LCSLID=YW.LCSLID AND CK.CKRQ_1<TRUNC(SYSDATE,'YY'))
       AND EXISTS (SELECT 1 FROM HX_CKTS.CKTS_SB_MDT_CKSH_GCB SH WHERE SH.LCSLID=YW.LCSLID)
       AND NOT EXISTS (SELECT 1 FROM HX_CKTS.CKTS_SB_MDT_CKSHCC_GCB CC WHERE CC.LCSLID=YW.LCSLID);
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023070901',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】是否已按规定核实往年出口货物收汇资料'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023070901',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】按规定核实往年出口货物检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  ELSIF SUBSTR(LC_LCSWSX,1,11)='LCSXA081039' THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM HX_CKTS.CKTS_TY_YWBLXX YW
     WHERE YW.LCSLID=V_LCSLID
       AND YW.CKQYGLLB_DM<>'D' --申报的时候非四类企业
       AND EXISTS (SELECT 1 FROM HX_CKTS.CKTS_SB_MTS_TSSB_GCB CK WHERE CK.LCSLID=YW.LCSLID AND CK.CKRQ_1<TRUNC(SYSDATE,'YY'))
       AND EXISTS (SELECT 1 FROM HX_CKTS.CKTS_SB_MTS_CKSH_GCB SH WHERE SH.LCSLID=YW.LCSLID)
       AND NOT EXISTS (SELECT 1 FROM HX_CKTS.CKTS_SB_MTS_CKSHCC_GCB CC WHERE CC.LCSLID=YW.LCSLID);
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023070901',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】是否已按规定核实往年出口货物收汇资料'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023070901',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】按规定核实往年出口货物检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  ELSIF SUBSTR(LC_LCSWSX,1,11)='LCSXA081040' THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM HX_CKTS.CKTS_TY_YWBLXX YW
     WHERE YW.LCSLID=V_LCSLID
       AND YW.CKQYGLLB_DM<>'D' --申报的时候非四类企业
       AND EXISTS (SELECT 1 FROM HX_CKTS.CKTS_SB_DB_TSSB_GCB CK WHERE CK.LCSLID=YW.LCSLID AND CK.CKRQ_1<TRUNC(SYSDATE,'YY'))
       AND EXISTS (SELECT 1 FROM HX_CKTS.CKTS_SB_DB_CKHWSH_GCB SH WHERE SH.LCSLID=YW.LCSLID)
       AND NOT EXISTS (SELECT 1 FROM HX_CKTS.CKTS_SB_DB_CKHWSHCC_GCB CC WHERE CC.LCSLID=YW.LCSLID);
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023070901',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】是否已按规定核实往年出口货物收汇资料'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023070901',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】按规定核实往年出口货物检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  END IF;

  -- 未按规定对四类生产企业年度首次申报开展评估
  -- 2023071001  X

  -- 调查评估岗违规办理出口退（免）税
  -- 2023071101   事前

  -- 应二次发函而未按规定进行发函	与2023051701重复

  -- 收到复函逾期办理
  -- 2023071301   事前

  -- 违规回复“正常业务”复函（存在向上游供货商的核实函未收到正常业务复函）
  -- 2023071401  事中
  IF LC_LCSWSX='LCSXA132008017' THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM HX_ZH.ZH_CKTS_FUHXXB FU
     WHERE FU.LCSLID=V_LCSLID
       AND FU.FHLX_DM='1'
       AND EXISTS (SELECT 1 
                     FROM HX_ZH.ZH_CKTS_FHXXB FA_1
                    WHERE FA_1.SYHSHBH=FU.HSHBH
                      AND FA_1.ZFBZ_1='N' --存在未作废的向上游核实函
                      AND NOT EXISTS (SELECT 1
                                        FROM HX_ZH.ZH_CKTS_FUHXXB FU_1
                                       WHERE FU_1.FHXXBUUID=FA_1.FHXXBUUID
                                         AND FU_1.ZFBZ_1='N'
                                         AND FU_1.FHLX_DM NOT IN ('1','5')));
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023071401',T.FUHXXBUUID,T.FUHSWJG_DM,NULL,T.GHQYNSRSBH_1,T.GHFQYMC_1,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】存在向上游供货商的核实函未收到正常业务复函，是否按正常回复'
             FROM HX_ZH.ZH_CKTS_FUHXXB T
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023071401',T.FUHXXBUUID,T.FUHSWJG_DM,NULL,T.GHQYNSRSBH_1,T.GHFQYMC_1,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】上游税局回复类型检查通过'
             FROM HX_ZH.ZH_CKTS_FUHXXB T
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  END IF;

  -- 未按规定出具复函处理意见
  -- 2023071501  事中
  IF LC_LCSWSX='LCSXA132008017' THEN
    INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
         SELECT '2023071501',T.FUHXXBUUID,T.FUHSWJG_DM,NULL,T.GHQYNSRSBH_1,T.GHFQYMC_1,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                '【请确认】上游税局回复类型与复函处理意见不一致，是否继续'
           FROM HX_ZH.ZH_CKTS_FUHXXB T
          WHERE T.LCSLID=V_LCSLID
            AND T.DZBZDSZL_DM='BDA1320283'
            AND T.FHLX_DM IN ('2','3','4','7','8')
            AND T.FHCLYJ_DM ='1';
    COMMIT;
    IF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023071501',T.FUHXXBUUID,T.FUHSWJG_DM,NULL,T.GHQYNSRSBH_1,T.GHFQYMC_1,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】上游税局回复类型与复函处理意见一致性检查通过'
             FROM HX_ZH.ZH_CKTS_FUHXXB T
            WHERE T.LCSLID=V_LCSLID
              AND NOT EXISTS (SELECT 1 FROM FXNK_NBFXDMX_SZ S WHERE S.NKZBBH='2023071501' AND S.LCSLID=V_LCSLID);
      COMMIT;
    END IF;
  END IF;

  -- 未按规定对“不予退税”复函涉及税款进行处理
  -- 2023071601   事前

  -- 应暂扣未暂扣出口退税款
  -- 2023071701   事前

  -- 应解除未解除暂扣出口退税款
  -- 2023071801   事前

  -- 应暂停未暂停实行先退税后核销办法
  -- 2023071901  X

  -- 应恢复未恢复实行先退税后核销办法
  -- 2023072001  X

  -- 未按规定将移送稽查、稽查立案企业相关情况录入案源管理台账(未结案)
  -- 2023072101   事前

  -- 未按规定对移送稽查企业提出暂停实行先退税后核销办法的意见	与2023071901重复

  -- 未按规定将稽查结案企业相关情况录入案源管理台账
  -- 2023072301  X

  -- 违规评定出口企业分类管理类别（一类企业）
  -- 2023072401  X

  -- 应恢复未恢复出口企业分类管理类别（稽查结案无问题）
  -- 2023072501   事前

  -- 未按照规定办理出口退（免）税备案撤回	与202305030*重复

  -- 税务登记注销时出口备案未撤回
  -- 2023072701  X

  -- 应出具未出具税务事项通知书
  -- 2023072801  事中
  IF LC_LCSWSX='LCSXA081047001' OR SUBSTR(LC_LCSWSX,1,11)='LCSXA081049' THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM HX_ZH.GY_WS_WSZB WS
     WHERE WS.LCSLID=V_LCSLID;
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023072801',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】是否已出具税务事项通知书'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023072801',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】是否应出具未出具税务事项通知书检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  END IF;

  -- 无合理理由进行再次发函
  -- 2023072901  事中
  IF LC_LCSWSX='LCSXA132008017' THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM HX_ZH.ZH_CKTS_FHXXB FH
     INNER JOIN HX_ZH.ZH_CKTS_HDFPQD FP ON FP.FHXXBUUID=FH.FHXXBUUID
     WHERE FH.LCSLID=V_LCSLID
       AND EXISTS (SELECT 1
                     FROM HX_ZH.ZH_CKTS_FHXXB FH_1
                    INNER JOIN HX_ZH.ZH_CKTS_HDFPQD FP_1 ON FP_1.FHXXBUUID=FH_1.FHXXBUUID
                    WHERE NVL(FH_1.ZFBZ_1,'N')='N' AND NVL(FP_1.ZFBZ_1,'N')='N'
                      AND FH_1.QFRQ<FH.QFRQ
                      AND FP_1.ZZSZYFPDMHM=FP.ZZSZYFPDMHM
                      AND NOT EXISTS (SELECT 1
                                        FROM HX_ZH.ZH_CKTS_FUHXXB FU_1
                                       WHERE FU_1.FHXXBUUID=FH_1.FHXXBUUID
                                         AND FU_1.FHLX_DM='5'));
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023072901',T.FHXXBUUID,T.FAHDSWJG_DM,T.GHFDJXH,T.GHQYNSRSBH,T.GHFQYMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】存在'||LL_ROWS||'份发票曾经发函且无“非本地管辖”回函，是否再次发函'
             FROM HX_ZH.ZH_CKTS_FHXXB T
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023072901',T.FHXXBUUID,T.FAHDSWJG_DM,T.GHFDJXH,T.GHQYNSRSBH,T.GHFQYMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】无合理理由进行再次发函检查通过'
             FROM HX_ZH.ZH_CKTS_FHXXB T
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  END IF;

  -- 复函地主管税务机关随意向上游发函
  -- 2023073001  X

  -- 应出具未出具需提供收汇资料收汇信息采集的税务事项通知书
  -- 2023073101  X

  -- 应出具未出具适用出口免税政策评定的税务事项通知书
  -- 2023073201   事前

  -- 违规评定出口企业分类管理类别（三类企业，上一年度违反规定未达处罚标准）
  -- 2023073301  事中
  IF LC_LCSWSX='LCSXA081053001' THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM HX_CKTS.CKTS_QT_QYGLLBFPPD_GCB PD
     INNER JOIN HX_JC.JC_AJXX S ON S.DJXH=PD.DJXH
     INNER JOIN HX_FZ.FZ_BYSWXZCFJDS R ON R.SSWFXWDJUUID=S.JCAJXXUUID AND NVL(R.ZFBZ_1,'N')='N'
       AND R.WSZZRQ>=ADD_MONTHS(TRUNC(SYSDATE,'YY'),-12) AND R.WFSS LIKE '%出口退税%'
     WHERE PD.LCSLID=V_LCSLID
       AND PD.SQFPGLLB_DM IN ('A','B');
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023073301',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】出口企业从上年初至今存在违反规定未达处罚标准的不予税务行政处罚决定书'
             FROM HX_CKTS.CKTS_QT_QYGLLBFPPD_GCB T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023073301',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】出口企业从上年初至今存在违反规定未达处罚标准检查通过'
             FROM HX_CKTS.CKTS_QT_QYGLLBFPPD_GCB T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  ELSIF LC_LCSWSX='LCSXA082052001' THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM HX_CKTS.CKTS_QT_QYGLLBPD_GCB PD
     INNER JOIN HX_JC.JC_AJXX S ON S.DJXH=PD.DJXH
     INNER JOIN HX_FZ.FZ_BYSWXZCFJDS R ON R.SSWFXWDJUUID=S.JCAJXXUUID AND NVL(R.ZFBZ_1,'N')='N'
       AND R.WSZZRQ>=ADD_MONTHS(TRUNC(SYSDATE,'YY'),-12) AND R.WFSS LIKE '%出口退税%'
     WHERE PD.LCSLID=V_LCSLID
       AND PD.PDGLLB_DM IN ('A','B');
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023073301',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】出口企业从上年初至今存在违反规定未达处罚标准的不予税务行政处罚决定书'
             FROM HX_CKTS.CKTS_QT_QYGLLBPD_GCB T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023073301',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】出口企业从上年初至今存在违反规定未达处罚标准检查通过'
             FROM HX_CKTS.CKTS_QT_QYGLLBPD_GCB T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  END IF;

  -- 违规评定出口企业分类管理类别（四类企业，上一年度违反规定被处罚）
  -- 2023073401  事中
  IF LC_LCSWSX='LCSXA081053001' THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM HX_CKTS.CKTS_QT_QYGLLBFPPD_GCB PD
     INNER JOIN HX_JC.JC_AJXX S ON S.DJXH=PD.DJXH
     INNER JOIN HX_FZ.FZ_SWXZCFJDS R ON R.SSWFXWDJUUID=S.JCAJXXUUID AND NVL(R.ZFBZ_1,'N')='N'
       AND R.WSZZRQ>=ADD_MONTHS(TRUNC(SYSDATE,'YY'),-12) AND R.CFJD LIKE '%骗取%出口退税%'
     WHERE PD.LCSLID=V_LCSLID
       AND PD.SQFPGLLB_DM IN ('A','B','C');
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023073401',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】出口企业从上年初至今存在违反规定被处罚的税务行政处罚决定书'
             FROM HX_CKTS.CKTS_QT_QYGLLBFPPD_GCB T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023073401',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】出口企业从上年初至今存在违反规定被处罚检查通过'
             FROM HX_CKTS.CKTS_QT_QYGLLBFPPD_GCB T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  ELSIF LC_LCSWSX='LCSXA082052001' THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM HX_CKTS.CKTS_QT_QYGLLBPD_GCB PD
     INNER JOIN HX_JC.JC_AJXX S ON S.DJXH=PD.DJXH
     INNER JOIN HX_FZ.FZ_SWXZCFJDS R ON R.SSWFXWDJUUID=S.JCAJXXUUID AND NVL(R.ZFBZ_1,'N')='N'
       AND R.WSZZRQ>=ADD_MONTHS(TRUNC(SYSDATE,'YY'),-12) AND R.CFJD LIKE '%骗取%出口退税%'
     WHERE PD.LCSLID=V_LCSLID
       AND PD.PDGLLB_DM IN ('A','B','C');
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023073401',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】出口企业从上年初至今存在违反规定被处罚的税务行政处罚决定书'
             FROM HX_CKTS.CKTS_QT_QYGLLBPD_GCB T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023073401',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】出口企业从上年初至今存在违反规定被处罚检查通过'
             FROM HX_CKTS.CKTS_QT_QYGLLBPD_GCB T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  END IF;

  -- 违规评定出口企业分类管理类别（四类企业，停权企业），同2023050701重复

  -- 违规评定出口企业分类管理类别（违规越级评定）
  -- 2023073601  X

  -- 违规评定出口企业分类管理类别（四类企业，四类认定不足12个月），同2023050801重复

  -- 未及时进行出口企业分类管理评定（新增企业类别认定）
  -- 2023073801  X

  -- 违规评定出口企业分类管理类别（三类企业，纳税信用评价为C级）
  -- 2023073901  X

  -- 违规评定出口企业分类管理类别（四类企业，纳税信用评价为D级）
  -- 2023074001  X

  -- 违规评定出口企业分类管理类别（三类企业，首笔申报未满12个月）
  -- 2023074101  X

  -- 违规评定出口企业分类管理类别（四类企业，四类企业的法定代表人）
  -- 2023074201  事中
  IF LC_LCSWSX='LCSXA082052001' THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM HX_CKTS.CKTS_QT_QYGLLBPD_GCB PD
     WHERE PD.LCSLID=V_LCSLID
       AND PD.PDGLLB_DM IN ('A','B','C')
       AND NOT EXISTS (SELECT 1
                         FROM HX_CKTS.CKTS_BA_KZ_JGB KZ
                        WHERE KZ.DJXH=PD.DJXH AND KZ.CKTMSBAKZLX_DM='FLGLCD' AND KZ.YXBZ='Y')
       AND EXISTS (SELECT 1
                     FROM HX_DJ.DJ_NSRXX DJ
                    INNER JOIN CKTS_KZ_SLQY SLQY ON SLQY.FDDBRSFZJHM=DJ.FDDBRSFZJHM --法人代表关联四类企业
                      WHERE DJ.DJXH=PD.DJXH AND SLQY.DJXH<>PD.DJXH);
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023074201',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】法定代表人名下存在其他四类出口企业'
             FROM HX_CKTS.CKTS_QT_QYGLLBPD_GCB T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2023074201',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】法定代表人名下存在其他四类出口企业检查通过'
             FROM HX_CKTS.CKTS_QT_QYGLLBPD_GCB T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  END IF;

  -- 未及时进行出口企业分类管理评定（复评申请）
  -- 2023074301   事前

  -- 未及时进行出口企业分类管理评定（类别变更）
  -- 2023074401   事前

  -- 未按规定主动公开一类、四类出口企业名单
  -- 李裕军：目前取不到电子税务局公开信息及时间，该风险暂不取数

  -- 未按规定对管理类别为四类的出口企业，取消无纸化标识
  -- 2023074601  X

  -- 出口退免税计算方式适用错误
  -- 2023074701   事前

  -- 不符合视同自产的按视同自产审核
  -- 2024010101  事中
  IF SUBSTR(LC_LCSWSX,1,11) = 'LCSXA081038' THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM HX_CKTS.CKTS_TY_YWBLXX T
     WHERE T.LCSLID=V_LCSLID
       AND EXISTS (SELECT 1 --存在stzc-01
                     FROM HX_CKTS.CKTS_SB_MDT_TSSB_GCB MX
                    WHERE MX.LCSLID=T.LCSLID
                      AND REGEXP_LIKE(MX.CKTMSYWLXDMJH,'STZC-01'))
       AND (   NOT EXISTS (SELECT 1 --不存在2年登记日期
                             FROM HX_DJ.DJ_NSRXX DJ
                            WHERE DJXH=T.DJXH
                              AND ADD_MONTHS(DJ.DJRQ,24)<SYSDATE)
            OR NOT EXISTS (SELECT 1 --不存在A类信用等级
                             FROM FXNK_JC2B_NSXYPJ XY
                            WHERE XY.DJXH=T.DJXH
                              AND XY.PJJB='A')
            OR NOT EXISTS (SELECT 1 --不存在上年末销售额累计大于5亿
                             FROM HX_SB.SB_SBXX SB
                            INNER JOIN HX_SB.SB_ZZS_YBNSR ZZS ON ZZS.SBUUID=SB.SBUUID
                            WHERE SB.DJXH=T.DJXH
                              AND SB.SKSSQQ=ADD_MONTHS(TRUNC(SYSDATE,'YY'),-1)
                              AND SB.ZSXM_DM='10101'
                              AND SB.SKSSQZ=TRUNC(SYSDATE,'YY')-1
                              AND SB.YZPZZL_DM='BDA0610606'
                              AND SB.GZLX_DM_1 IN ('1','5')
                              AND SB.ZFBZ_1='N'
                              AND ZZS.EWBLXH=2
                              AND ZZS.ASYSLJSXSE+ZZS.AJYBFJSXSE+ZZS.MDTBFCKXSE+ZZS.MSXSE>=500000000));
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2024010101',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】出口企业是否符合STZC-01（登记2年及以上/信用等级A类/上年销售额5亿及以上）'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2024010101',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】出口企业是否符合STZC-01检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  END IF;

  -- 对企业尚未申报的出口退税发函调查
  -- 2024020101  事中
  IF LC_LCSWSX='LCSXA132008017' THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM HX_ZH.ZH_CKTS_FHXXB FH
     INNER JOIN HX_ZH.ZH_CKTS_HDFPQD FP ON FP.FHXXBUUID=FH.FHXXBUUID
     WHERE FH.LCSLID=V_LCSLID
       AND NOT EXISTS (SELECT 1
                         FROM HX_CKTS.CKTS_SB_MTS_TSJH_GCB GCB
                        WHERE GCB.DJXH=FH.GHFDJXH AND GCB.JHPZH=FP.ZZSZYFPDMHM
                        UNION ALL
                       SELECT 1
                         FROM HX_CKTS.CKTS_SB_MTS_TSJH_JGB JGB
                        WHERE JGB.DJXH=FH.GHFDJXH AND JGB.JHPZH=FP.ZZSZYFPDMHM);
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2024020101',T.FHXXBUUID,T.FAHDSWJG_DM,T.GHFDJXH,T.GHQYNSRSBH,T.GHFQYMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】存在'||LL_ROWS||'份发票未查到免退税申报记录'
             FROM HX_ZH.ZH_CKTS_FHXXB T
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2024020101',T.FHXXBUUID,T.FAHDSWJG_DM,T.GHFDJXH,T.GHQYNSRSBH,T.GHFQYMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】对企业尚未申报的出口退税发函调查检查通过'
             FROM HX_ZH.ZH_CKTS_FHXXB T
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  END IF;

  -- 以其他方式结束调查评估
  -- 2024060101   事中
  IF SUBSTR(LC_LCSWSX,1,11)='LCSXA081039' THEN
    SELECT COUNT(1),MIN(T.UUID)
      INTO LL_ROWS,LC_UUID
      FROM HX_CKTS.CKTS_BL_MTS_SHYDCL_GCB T
     WHERE T.LCSLID=V_LCSLID
       AND T.ZHSHCLYJLX_DM ='4' -- 综合处理意见类型 准予退税
       AND T.QTHCCLYJLX_DM='4' -- 其他处理意见类型 准予退税
       AND TRIM(T.FHBH) IS NULL AND TRIM(T.FHBH_1) IS NULL -- 未进行发函
       AND TRIM(SDHCBGBH) IS NULL -- 未进行实地核查
       AND LENGTH(QTHCNR)<30;
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2024060101',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】免退税疑点处理无发函编号、回函编号、实地核查报告编号，其他核查内容过于简单'
             FROM HX_CKTS.CKTS_BL_MTS_SHYDCL_GCB T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.UUID=LC_UUID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2024060101',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】以其他方式结束调查评估检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID
              AND ROWNUM=1;
      COMMIT;
    END IF;
  END IF;

  -- 回函时不相容环节存在兼岗
  -- 2024060201   事中
  -- 20250303，根据杭州反馈及广特办取数口径，起草人从lrrDm改为lxrDm
  IF LC_LCSWSX='LCSXA132008017' THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM HX_ZH.ZH_CKTS_FUHXXB H1
     WHERE H1.LCSLID=V_LCSLID
       AND NVL(H1.ZFBZ_1,'N')='N'
       AND trim(H1.FHBH) IS NOT NULL
       AND (H1.LXR_DM=H1.SHR_DM OR H1.SHR_DM=H1.QFR_DM OR H1.LXR_DM=H1.QFR_DM);
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2024060201',T.FUHXXBUUID,T.FUHSWJG_DM,NULL,T.GHQYNSRSBH_1,T.GHFQYMC_1,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】回函时不相容环节存在兼岗'
             FROM HX_ZH.ZH_CKTS_FUHXXB T
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2024060201',T.FUHXXBUUID,T.FUHSWJG_DM,NULL,T.GHQYNSRSBH_1,T.GHFQYMC_1,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】回函时不相容环节存在兼岗检查通过'
             FROM HX_ZH.ZH_CKTS_FUHXXB T
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  END IF;

  -- 对本地管辖企业回复“非本地管辖”
  -- 2025030301   事中
  IF LC_LCSWSX='LCSXA132008017' THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM HX_ZH.ZH_CKTS_FUHXXB H1
     INNER JOIN HX_ZH.ZH_CKTS_FHXXB F1 ON F1.FHXXBUUID=H1.FHXXBUUID
     INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH = F1.GHFDJXH1 AND DJ.KZZTDJLX_DM='1110' -- 课征主体登记类型：单位纳税人税务登记
       AND SUBSTR(DJ.ZGSWJ_DM, 1, 7) = SUBSTR(H1.FUHSWJG_DM, 1, 7) --主管税务机关与回函税务机关前7位一致
     WHERE H1.LCSLID=V_LCSLID
       AND H1.FHLX_DM = '5' --回函非本地管辖
       AND NVL(H1.ZFBZ_1,'N')='N'
       AND TRIM(H1.FHBH) IS NOT NULL
       AND EXISTS (SELECT 1
                     FROM HX_RD.RD_NSRZGXX_JGB ZG --取一般纳税人资格
                    WHERE ZG.DJXH = DJ.DJXH
                      AND ZG.NSRZGLX_DM='201'
                      AND ZG.YXQQ <= H1.QFRQ
                      AND ZG.YXQZ > H1.QFRQ
                      AND ZG.QXBZ = 'N');
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2025030301',T.FUHXXBUUID,T.FUHSWJG_DM,NULL,T.GHQYNSRSBH_1,T.GHFQYMC_1,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】本区县级主管税务机关下存在供货商纳税人税务登记信息，是否回复非本地管辖'
             FROM HX_ZH.ZH_CKTS_FUHXXB T
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2025030301',T.FUHXXBUUID,T.FUHSWJG_DM,NULL,T.GHQYNSRSBH_1,T.GHFQYMC_1,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】供货企业是否非本地管辖检查通过'
             FROM HX_ZH.ZH_CKTS_FUHXXB T
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  END IF;

  -- 违规选择“暂缓办理退（免）税”复函
  -- 2025050101   事中
  IF LC_LCSWSX='LCSXA132008017' THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM HX_ZH.ZH_CKTS_FUHXXB FU
     INNER JOIN HX_ZH.ZH_CKTS_FHXXB FA ON FA.FHXXBUUID=FU.FHXXBUUID
     WHERE FU.LCSLID=V_LCSLID
       AND FU.FHLX_DM='4'
       AND NOT EXISTS (SELECT 1 --不存在立案未结案的稽查信息
                         FROM HX_JC.JC_AJXX AJ
                        WHERE AJ.DJXH = FA.GHFDJXH1
                          AND NVL(AJ.ZFBZ_1, 'N') = 'N'
                          AND AJ.LARQ < SYSDATE
                          AND AJ.JARQ IS NULL);
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2025050101',T.FUHXXBUUID,T.FUHSWJG_DM,NULL,T.GHQYNSRSBH_1,T.GHFQYMC_1,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】供货企业不存在立案未结案的稽查信息，是否按“暂缓办理退（免）税”复函'
             FROM HX_ZH.ZH_CKTS_FUHXXB T
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2025050101',T.FUHXXBUUID,T.FUHSWJG_DM,NULL,T.GHQYNSRSBH_1,T.GHFQYMC_1,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】违规选择“暂缓办理退（免）税”复函检查通过'
             FROM HX_ZH.ZH_CKTS_FUHXXB T
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  END IF;

  -- 未按规定期限对“暂缓办理退（免）税”函件重新复函
  -- 2025050201   事前

  -- 回函签发日期在发函签发日期以后5个工作日内
  -- 2025050301   事中
  IF LC_LCSWSX='LCSXA132008017' THEN
    INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
         SELECT '2025050301',H1.FUHXXBUUID,H1.FUHSWJG_DM,F1.GHFDJXH1,F1.GHQYNSRSBH_1,F1.GHFQYMC_1,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                '【请确认】回函签发日期在发函签发日期以后5个工作日内，是否继续'
           FROM HX_ZH.ZH_CKTS_FUHXXB H1
          INNER JOIN HX_ZH.ZH_CKTS_FHXXB F1 ON F1.FHXXBUUID=H1.FHXXBUUID
          WHERE H1.LCSLID=V_LCSLID
            AND NVL(H1.FHLX_DM,'3')<>'5'
            AND NVL(H1.ZFBZ_1,'N')='N'
            AND TRIM(H1.FHBH) IS NOT NULL
            AND COMPUTE_BLDATE(H1.QFRQ,F1.QFRQ)<=5;
    COMMIT;
    IF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2025050301',H1.FUHXXBUUID,H1.FUHSWJG_DM,F1.GHFDJXH1,F1.GHQYNSRSBH_1,F1.GHFQYMC_1,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】回函签发日期是否在发函签发日期以后5个工作日内检查通过'
             FROM HX_ZH.ZH_CKTS_FUHXXB H1
            INNER JOIN HX_ZH.ZH_CKTS_FHXXB F1 ON F1.FHXXBUUID=H1.FHXXBUUID
            WHERE H1.LCSLID=V_LCSLID
              AND NOT EXISTS (SELECT 1 FROM FXNK_NBFXDMX_SZ S WHERE S.NKZBBH='2025050301' AND S.LCSLID=V_LCSLID);
      COMMIT;
    END IF;
  END IF;

  -- 审核疑点处理时，针对不同供货商采用同一份核实函编号
  -- 2025050401   事中
  -- 2025050402   事中
  IF SUBSTR(LC_LCSWSX,1,11)='LCSXA081038' THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM (SELECT T.FHBH --存在多于一个供货商的核实函编号
              FROM HX_CKTS.CKTS_BL_MDT_SHYDCL_GCB T
             INNER JOIN HX_CKTS.CKTS_SB_MDT_STZCQD_GCB JH
                ON JH.DJXH=T.DJXH AND JH.SSQ=T.SSQ AND JH.MXSBXH=T.SBXH
             WHERE T.LCSLID=V_LCSLID
               AND TRIM(T.FHBH) IS NOT NULL
             GROUP BY T.FHBH
            HAVING COUNT(DISTINCT JH.XHFNSRSBH)>1) TT;
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2025050401',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】审核疑点处理时，针对不同供货商录入了同一份核实函编号，是否继续'
             FROM HX_CKTS.CKTS_BL_MDT_SHYDCL_GCB T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID
              AND ROWNUM=1;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2025050401',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】审核疑点处理时同一份核实函编号是否针对不同供货商检查通过'
             FROM HX_CKTS.CKTS_BL_MDT_SHYDCL_GCB T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID
              AND ROWNUM=1;
      COMMIT;
    END IF;
  ELSIF SUBSTR(LC_LCSWSX,1,11)='LCSXA081039' THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM (SELECT T.FHBH --存在多于一个供货商的核实函编号
              FROM HX_CKTS.CKTS_BL_MTS_SHYDCL_GCB T
             INNER JOIN HX_CKTS.CKTS_SB_MTS_TSJH_GCB JH
                ON JH.DJXH=T.DJXH AND JH.GLH=T.GLH AND JH.SBXH=T.SBXH
             WHERE T.LCSLID=V_LCSLID
               AND TRIM(T.FHBH) IS NOT NULL
             GROUP BY T.FHBH
            HAVING COUNT(DISTINCT JH.GHFNSRSBH_1)>1) TT;
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2025050402',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】审核疑点处理时，针对不同供货商录入了同一份核实函编号，是否继续'
             FROM HX_CKTS.CKTS_BL_MTS_SHYDCL_GCB T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID
              AND ROWNUM=1;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2025050402',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】审核疑点处理时同一份核实函编号是否针对不同供货商检查通过'
             FROM HX_CKTS.CKTS_BL_MTS_SHYDCL_GCB T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID
              AND ROWNUM=1;
      COMMIT;
    END IF;
  END IF;

  -- 四类企业首次申报跨大类（海关编码前4位）商品
  -- 2025090101   事中
  IF SUBSTR(LC_LCSWSX,1,11)='LCSXA081038' THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM HX_CKTS.CKTS_TY_YWBLXX T
     INNER JOIN HX_CKTS.CKTS_SB_MDT_TSSB_GCB S
       ON S.LCSLID=T.LCSLID
     WHERE T.LCSLID=V_LCSLID
       AND T.CKQYGLLB_DM='D'
       AND NOT EXISTS (SELECT 1
                         FROM HX_CKTS.CKTS_SB_MDT_TSSB_JGB LS
                        WHERE LS.DJXH=LN_DJXH
                          AND SUBSTR(LS.CKSP_DM,1,4)=SUBSTR(S.CKSP_DM,1,4));
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2025090101',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】四类企业申报的出口货物跨大类（商品代码前4位），请加强审核'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2025090101',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】四类企业申报的出口货物跨大类（商品代码前4位）检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  ELSIF SUBSTR(LC_LCSWSX,1,11)='LCSXA081039' THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM HX_CKTS.CKTS_TY_YWBLXX T
     INNER JOIN HX_CKTS.CKTS_SB_MTS_TSSB_GCB S
       ON S.LCSLID=T.LCSLID
     WHERE T.LCSLID=V_LCSLID
       AND T.CKQYGLLB_DM='D'
       AND NOT EXISTS (SELECT 1
                         FROM HX_CKTS.CKTS_SB_MTS_TSSB_JGB LS
                        WHERE LS.DJXH=LN_DJXH
                          AND SUBSTR(LS.CKSP_DM,1,4)=SUBSTR(S.CKSP_DM,1,4)
                        UNION ALL
                       SELECT 1
                         FROM HX_CKTS.CKTS_SB_MTS_TSSB_LB LB
                        WHERE LB.DJXH=LN_DJXH
                          AND SUBSTR(LB.CKSP_DM,1,4)=SUBSTR(S.CKSP_DM,1,4)
                       );
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2025090101',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】四类企业申报的出口货物跨大类（商品代码前4位），请加强审核'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2025090101',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】四类企业申报的出口货物跨大类（商品代码前4位）检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  END IF;

  -- 9810业务非预退税申报
  -- 2025090201   事中
  IF SUBSTR(LC_LCSWSX,1,11)='LCSXA081038' THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM (SELECT T.UUID
              FROM HX_CKTS.CKTS_SB_MDT_TSSB_GCB T
             INNER JOIN HX_CKTS.CKTS_WBSJ_HG_BGD201 S
                ON S.DJXH=T.DJXH AND S.CKBGDH=T.CKFPH
             WHERE T.LCSLID=V_LCSLID
               AND S.JGFS_DM='9810'
               AND NOT REGEXP_LIKE(NVL(T.CKTMSYWLXDMJH,'1'),'HWC-YT')
             UNION ALL
            SELECT T.UUID
              FROM HX_CKTS.CKTS_SB_MDT_TSSB_GCB T
             INNER JOIN HX_CKTS.CKTS_WBSJ_ZJ_DLCKHWZM S
                ON S.DJXH=T.DJXH AND S.DLCKHWZMHM=T.DLCKHWZMHM
             WHERE T.LCSLID=V_LCSLID
               AND S.JGFS_DM='9810'
               AND NOT REGEXP_LIKE(NVL(T.CKTMSYWLXDMJH,'1'),'HWC-YT')
           ) TT;
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2025090201',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】出口企业申报9810业务，但退（免）税业务类型未选择“HWC-YT”，请加强审核'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2025090201',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】出口企业申报的9810业务是否申报“HWC-YT”检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  ELSIF SUBSTR(LC_LCSWSX,1,11)='LCSXA081039' THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM (SELECT T.UUID
              FROM HX_CKTS.CKTS_SB_MTS_TSSB_GCB T
             INNER JOIN HX_CKTS.CKTS_WBSJ_HG_BGD201 S
                ON S.DJXH=T.DJXH AND S.CKBGDH=T.CKFPH
             WHERE T.LCSLID=V_LCSLID
               AND S.JGFS_DM='9810'
               AND NOT REGEXP_LIKE(NVL(T.CKTMSYWLXDMJH,'1'),'HWC-YT')
             UNION ALL
            SELECT T.UUID
              FROM HX_CKTS.CKTS_SB_MTS_TSSB_GCB T
             INNER JOIN HX_CKTS.CKTS_WBSJ_ZJ_DLCKHWZM S
                ON S.DJXH=T.DJXH AND S.DLCKHWZMHM=T.DLZMH
             WHERE T.LCSLID=V_LCSLID
               AND S.JGFS_DM='9810'
               AND NOT REGEXP_LIKE(NVL(T.CKTMSYWLXDMJH,'1'),'HWC-YT')
           ) TT;
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2025090201',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】出口企业申报9810业务，但退（免）税业务类型未选择“HWC-YT”，请加强审核'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2025090201',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】出口企业申报的9810业务是否申报“HWC-YT”检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  END IF;

  -- 供货企业发函未回
  -- 2025090301   事中
  IF SUBSTR(LC_LCSWSX,1,11)='LCSXA081039' THEN
    SELECT COUNT(1)
      INTO LL_ROWS
      FROM (SELECT DISTINCT T.GHFNSRSBH_1
              FROM HX_CKTS.CKTS_SB_MTS_TSJH_GCB T
             INNER JOIN HX_ZH.ZH_CKTS_FHXXB FH
                ON FH.GHFDJXH=T.DJXH AND FH.GHQYNSRSBH_1=T.GHFNSRSBH_1 AND NVL(FH.ZFBZ_1,'N')='N' AND FH.QFRQ IS NOT NULL
             WHERE T.LCSLID=V_LCSLID
               AND NOT EXISTS (SELECT 1
                                 FROM HX_ZH.ZH_CKTS_FUHXXB FUH
                                WHERE FUH.FHXXBUUID=FH.FHXXBUUID
                                  AND FUH.FHBH IS NOT NULL
                                  AND NVL(FUH.FHLX_DM,'3')<>'3'
                                  AND NVL(FUH.ZFBZ_1,'N')='N')
           ) TT;
    IF LL_ROWS>0 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2025090301',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【请确认】本批次中有('||LL_ROWS||')个供货商存在发函未回的情况，请加强审核'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    ELSIF LL_LTCS=2 THEN
      INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
           SELECT '2025090301',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,LC_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                  '【联调测试】相同供货商发函未回检查通过'
             FROM HX_CKTS.CKTS_TY_YWBLXX T
            INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
            WHERE T.LCSLID=V_LCSLID;
      COMMIT;
    END IF;
  END IF;

  SELECT COUNT(1)
    INTO V_ERROR
    FROM FXNK_NBFXDMX_SZ T
   WHERE T.LCSWSX_DM=LC_LCSWSX AND T.LCSLID=V_LCSLID;

  IF V_ERROR=0 AND LL_LTCS=2 THEN
    INSERT INTO FXNK_NBFXDMX_SZ(NKZBBH,UUID,SWJGDM,DJXH,NSRSBH,NSRMC,LCSWSX_DM,LCSLID,CFRY,CFSJ,NKYWMS)
         SELECT '2024070201',T.UUID,T.TSSWJG_DM_1,T.DJXH,NVL(DJ.SHXYDM,DJ.NSRSBH),DJ.NSRMC,V_LCSWSX,V_LCSLID,V_SWRYDM,SYSDATE,
                '【联调测试】动态参数'||V_PROPS
           FROM HX_CKTS.CKTS_TY_YWBLXX T
          INNER JOIN HX_DJ.DJ_NSRXX DJ ON DJ.DJXH=T.DJXH
          WHERE T.LCSLID=V_LCSLID;
    COMMIT;
  END IF;

  DELETE FROM FXNK_NBFXDMX_SZ_LC WHERE PLCSLID=V_LCSLID;
  COMMIT;
  
  UPDATE FXNK_NBFXDMX_SZ T
     SET T.SWJGDM='13306920000'
   WHERE T.SWJGDM='13306029200';
  COMMIT;

  RETURN;
END;
/

prompt
prompt Creating procedure PRO_DEAL_TSGZ_FQYCKJSBTJ
prompt ===========================================
prompt
CREATE OR REPLACE PROCEDURE PRO_DEAL_TSGZ_FQYCKJSBTJ
/*
 * 态势感知_分企业出口及申报统计
 */
AS
  LN_RMBLAJ_ALL   NUMBER(18,2);
  LN_RMBLAJ_TSL   NUMBER(18,2);
  LN_RMBLAJ_TSSB  NUMBER(18,2);
  LN_MSXSE_YB     NUMBER(18,2);
  LN_MSXSE_XGM    NUMBER(18,2);
BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TSGZ_DATA_FQYCKJSBTJ';
  COMMIT;
  
  FOR CUR_CKQY IN (SELECT A.TSSWJG_DM_1,A.DJXH,B.NSRMC,NVL(B.SHXYDM,B.NSRSBH) AS NSRSBH
                     FROM HX_CKTS.CKTS_BA_BAXX_JGB A
                    INNER JOIN HX_DJ.DJ_NSRXX B ON B.DJXH=A.DJXH
                    WHERE NVL(A.BACHBZ,'N')='N' AND A.BACHRQ IS NULL --未备案撤回
                      AND B.NSRZT_DM NOT IN ('05','07','08') --纳税人状态正常
                      AND EXISTS (
                          SELECT 1 FROM HX_CKTS.CKTS_WBSJ_HG_BGD201 C WHERE C.DJXH=A.DJXH AND C.CKRQ_1>=DATE'2026-01-01'
                           UNION ALL
                          SELECT 1 FROM HX_CKTS.CKTS_WBSJ_ZJ_DLCKHWZM D WHERE D.DJXH=A.DJXH AND D.CKRQ_1>=DATE'2026-01-01')
                    ORDER BY A.TSSWJG_DM_1,A.DJXH)
  LOOP
    -- 出口及退税申报情况
    WITH
    MX AS (
    SELECT T.CKBGDH,T.MYLAJ,T.RMBLAJ,T.TSSBMYLAJ,JG.JGFSTSLX_DM,WK.TSL,
           1 AS RN
      FROM HX_CKTS.CKTS_WBSJ_HG_BGD201 T
     INNER JOIN HX_DM_ZDY.DM_CKTS_HGJGFS JG
        ON JG.JGFS_DM=T.JGFS_DM
     INNER JOIN HX_CKTS.CKTS_TY_CKSPTSLWK WK
        ON (WK.CKSP_DM=T.CKSP_DM OR WK.CKSP_DM=SUBSTR(T.CKSP_DM,1,8))
       AND T.CKRQ_1 BETWEEN WK.YXQQ AND WK.YXQZ
     WHERE T.DJXH=CUR_CKQY.DJXH
       AND T.CKRQ_1>=DATE'2026-01-01'
       AND T.DLSBMYLAJ=0
     UNION ALL
    SELECT T.DLCKHWZMHM AS CKBGDH,T.MYLAJ,T.RMBLAJ,T.TSSBMYLAJ,JG.JGFSTSLX_DM,WK.TSL,
           ROW_NUMBER() OVER (PARTITION BY T.DLCKHWZMHM ORDER BY T.RKRQ DESC) AS RN
      FROM HX_CKTS.CKTS_WBSJ_ZJ_DLCKHWZM T
     INNER JOIN HX_DM_ZDY.DM_CKTS_HGJGFS JG
        ON JG.JGFS_DM=T.JGFS_DM
     INNER JOIN HX_CKTS.CKTS_TY_CKSPTSLWK WK
        ON REGEXP_LIKE(T.CKSP_DM,WK.CKSP_DM)
       AND T.CKRQ_1 BETWEEN WK.YXQQ AND WK.YXQZ
     WHERE T.DJXH=CUR_CKQY.DJXH
       AND T.CKRQ_1>=DATE'2026-01-01'
    )
    SELECT NVL(SUM(RMBLAJ),0),
           NVL(SUM(CASE WHEN JGFSTSLX_DM>'0' AND TSL>0 THEN RMBLAJ ELSE 0 END),0),
           NVL(SUM(CASE WHEN TSSBMYLAJ>0 THEN RMBLAJ ELSE 0 END),0)
      INTO LN_RMBLAJ_ALL, LN_RMBLAJ_TSL, LN_RMBLAJ_TSSB
      FROM MX
     WHERE RN=1;

    -- 对出口数大于0的企业统计增值税免税申报
    IF LN_RMBLAJ_ALL>0 THEN
      -- 一般纳税人报表
      SELECT NVL(SUM(MSXSE),0)
        INTO LN_MSXSE_YB
        FROM HX_SB.SB_ZZS_YBNSR
       WHERE SBUUID IN (SELECT DISTINCT SBUUID
                          FROM HX_SB.SB_SBXX
                         WHERE DJXH=CUR_CKQY.DJXH
                           AND SKSSQQ>=DATE'2026-01-01' AND SKSSQZ<SYSDATE
                           AND ZSXM_DM='10101' 
                           AND YZPZZL_DM='BDA0610606'
                           AND GZLX_DM_1 IN ('1','5')
                           AND ZFBZ_1='N' )
         AND EWBLXH IN (1, 3);
      -- 小规模报表
      SELECT NVL(SUM(CKMSXSE),0)
        INTO LN_MSXSE_XGM
        FROM HX_SB.SB_ZZS_XGM
       WHERE SBUUID IN (SELECT DISTINCT SBUUID
                          FROM HX_SB.SB_SBXX
                         WHERE DJXH=CUR_CKQY.DJXH
                           AND SKSSQQ>=DATE'2026-01-01' AND SKSSQZ<SYSDATE
                           AND ZSXM_DM='10101' 
                           AND YZPZZL_DM='BDA0610611'
                           AND GZLX_DM_1 IN ('1','5')
                           AND ZFBZ_1='N' )
         AND EWBLXH IN (1, 2);
      LN_MSXSE_YB := LN_MSXSE_YB + LN_MSXSE_XGM;

      INSERT INTO TSGZ_DATA_FQYCKJSBTJ(TSSWJG_DM_1,DJXH,NSRMC,NSRSBH,RMBLAJ_ALL,RMBLAJ_TSL,RMBLAJ_TSSB,ZZSMSXSE,SBL_TSSB,SBL_ZZS)
      SELECT CUR_CKQY.TSSWJG_DM_1,CUR_CKQY.DJXH,CUR_CKQY.NSRMC,CUR_CKQY.NSRSBH,
             ROUND(LN_RMBLAJ_ALL/10000,4),ROUND(LN_RMBLAJ_TSL/10000,4),
             ROUND(LN_RMBLAJ_TSSB/10000,4),ROUND(LN_MSXSE_YB/10000,4),
             CASE WHEN LN_RMBLAJ_TSL<=0 THEN NULL
                  WHEN LN_RMBLAJ_TSSB<=0 THEN 0
                  WHEN LN_RMBLAJ_TSSB>=LN_RMBLAJ_TSL THEN 100
                  ELSE ROUND(100 * LN_RMBLAJ_TSSB / LN_RMBLAJ_TSL,2)
             END,
             CASE WHEN LN_RMBLAJ_TSL<=0 THEN NULL
                  WHEN LN_MSXSE_YB<=0 THEN 0
                  WHEN LN_MSXSE_YB>=LN_RMBLAJ_TSL THEN 100
                  ELSE ROUND(100 * LN_MSXSE_YB / LN_RMBLAJ_TSL,2)
             END
        FROM DUAL;
      COMMIT;
    END IF;
  END LOOP;

END;
/

prompt
prompt Creating procedure TMP_PRO_DEAL_20250121
prompt ========================================
prompt
CREATE OR REPLACE PROCEDURE TMP_PRO_DEAL_20250121
AS
BEGIN

  INSERT INTO TMP_20250121_QY_01(DJXH)
    SELECT DISTINCT DJXH
      FROM HX_CKTS.CKTS_SB_MDT_SBDSHZ_JGB T
     WHERE T.DJXH = T.DJXH
       AND T.SSQ >= '201501'
       AND T.MDTSE > 0;
   COMMIT;

  INSERT INTO TMP_20250121_QY_02(DJXH)
    SELECT DJXH
      FROM TMP_20250121_QY_01 T
     WHERE EXISTS (SELECT 1
                     FROM HX_CKTS.CKTS_WBSJ_HG_BGD201 S
                    WHERE S.DJXH = T.DJXH
                      AND S.CKRQ_1 >= DATE '2015-01-01');
   COMMIT;

  FOR CUR_QY IN (SELECT DJXH FROM TMP_20250121_QY_02 WHERE AJYBFJSXSE IS NULL ORDER BY TSSWJG_DM_1)
  LOOP
    update TMP_20250121_QY_02 t
       set t.ajybfjsxse =
           (SELECT NVL(SUM(AJYBFJSXSE),0)
              FROM HX_SB.SB_ZZS_YBNSR
             WHERE SBUUID IN (SELECT DISTINCT SBUUID
                                FROM HX_SB.SB_SBXX
                               WHERE DJXH=CUR_QY.DJXH
                                 AND SKSSQQ>=DATE'2015-01-01' AND SKSSQZ<DATE '2025-01-01'
                                 AND ZSXM_DM='10101'
                                 AND YZPZZL_DM='BDA0610606'
                                 AND GZLX_DM_1 IN ('1','5')
                                 AND ZFBZ_1='N' )
               AND EWBLXH IN (1, 3))
     where t.djxh=CUR_QY.DJXH;
     commit;
  END LOOP;
  
  DELETE FROM TMP_20250121_QY_02 T WHERE T.AJYBFJSXSE<=0;
  COMMIT;

  FOR CUR_QY IN (SELECT DJXH FROM TMP_20250121_QY_02 WHERE MYLAJ IS NULL ORDER BY TSSWJG_DM_1)
  LOOP
    update TMP_20250121_QY_02 t
       set (T.MYLAJ,T.RMBLAJ) =
           (SELECT NVL(SUM(MYLAJ),0),NVL(SUM(RMBLAJ),0)
              FROM HX_CKTS.CKTS_WBSJ_HG_BGD201 S
             WHERE S.DJXH = T.DJXH
               AND S.CKRQ_1 >= DATE '2015-01-01')
     where t.djxh=CUR_QY.DJXH;
    update TMP_20250121_QY_02 t
       set (T.CKXSEMY,T.CKXSERMB,T.YTSE_1,T.MDSE) =
           (SELECT NVL(SUM(CKXSEMY),0),NVL(SUM(CKXSERMB),0),NVL(SUM(YTSE_1),0),NVL(SUM(MDSE),0)
              FROM HX_CKTS.CKTS_SB_MDT_SBDSHZ_JGB S
             WHERE S.DJXH = T.DJXH
               AND S.SSQ>='201501')
     where t.djxh=CUR_QY.DJXH;
     commit;
  END LOOP;
/*
  select t.tsswjg_dm_1,t.djxh,nvl(s.shxydm,s.nsrsbh) as nsrsbh,s.nsrmc,ba.barq,ba.bachbz,ba.bachrq,
         t.ajybfjsxse,t.mylaj,t.rmblaj,t.ckxsemy,t.ckxsermb,t.ytse_1,t.mdse
    from TMP_20250121_QY_02 t
   inner join hx_dj.dj_nsrxx s on s.djxh=t.djxh
   inner join hx_ckts.ckts_ba_baxx_jgb ba on ba.djxh=t.djxh
   order by t.tsswjg_dm_1,t.djxh;
*/
  RETURN;
END;
/

prompt
prompt Creating procedure TMP_PRO_DEAL_20250417
prompt ========================================
prompt
CREATE OR REPLACE PROCEDURE TMP_PRO_DEAL_20250417
AS
  LN_MSXSE  NUMBER(18,6);
BEGIN
  FOR CUR_LC IN (SELECT T.XH,T.DJXH FROM tmp_20250417_qy_01 T)
  LOOP
    BEGIN
      LN_MSXSE :=0;
      SELECT NVL(SUM(MSXSE+MDTBFCKXSE),0)
        INTO LN_MSXSE
        FROM HX_SB.SB_ZZS_YBNSR
       WHERE SBUUID IN (SELECT DISTINCT SBUUID
                          FROM HX_SB.SB_SBXX
                         WHERE DJXH=CUR_LC.DJXH
                           AND SKSSQQ>=date'2024-01-01'
                           AND ZSXM_DM='10101' 
                           AND YZPZZL_DM ='BDA0610606'
                           AND GZLX_DM_1 IN ('1','5')
                           AND ZFBZ_1='N' )
         AND EWBLXH=1;
      SELECT LN_MSXSE+ NVL(SUM(MSXSE),0)
        INTO LN_MSXSE
        FROM HX_SB.SB_ZZS_XGM
       WHERE SBUUID IN (SELECT DISTINCT SBUUID
                          FROM HX_SB.SB_SBXX
                         WHERE DJXH=CUR_LC.DJXH
                           AND SKSSQQ>=date'2024-01-01'
                           AND ZSXM_DM='10101' 
                           AND YZPZZL_DM ='BDA0610611'
                           AND GZLX_DM_1 IN ('1','5')
                           AND ZFBZ_1='N' )
         AND EWBLXH=1;
      UPDATE tmp_20250417_qy_01 S
         SET S.ZZSMSE=LN_MSXSE
       WHERE S.XH=CUR_LC.XH;
      COMMIT;
    END;
  END LOOP;

END;
/

prompt
prompt Creating procedure TMP_PRO_DEAL_20250619
prompt ========================================
prompt
CREATE OR REPLACE PROCEDURE TMP_PRO_DEAL_20250619
AS
  LN_DJXH         NUMBER(20);
  LC_BABZ         CHAR(1);
  LC_TMSJSFF      CHAR(1);
  LC_SWJG         VARCHAR2(11);
  LC_CYTSSBJL     VARCHAR2(60);
  LN_TSSBSL       NUMBER(18,6);
  LN_TSSBMYLAJ    NUMBER(18,2);
  LN_TSSBRMBLAJ   NUMBER(18,2);
  LN_TSSBTSE      NUMBER(18,2);
BEGIN

  FOR CUR_LC IN (SELECT DISTINCT SHXYNO,NSRMC FROM TMP_20250619_QY_01 WHERE DJXH IS NULL)
  LOOP
    BEGIN
      SELECT T.DJXH,'Y',S.TSSWJG_DM_1,S.CKHWTMSJSFF_DM
        INTO LN_DJXH,LC_BABZ,LC_SWJG,LC_TMSJSFF
        FROM HX_DJ.DJ_NSRXX T
       INNER JOIN HX_CKTS.CKTS_BA_BAXX_JGB S ON S.DJXH=T.DJXH
       WHERE T.SHXYDM=CUR_LC.SHXYNO OR T.NSRSBH=CUR_LC.SHXYNO OR T.NSRMC=CUR_LC.NSRMC;
    EXCEPTION
      WHEN OTHERS THEN
        LN_DJXH:=NULL;
    END;
    IF LN_DJXH IS NULL THEN
      BEGIN
        SELECT T.DJXH,'N',T.ZGSWSKFJ_DM,NULL
          INTO LN_DJXH,LC_BABZ,LC_SWJG,LC_TMSJSFF
          FROM HX_DJ.DJ_NSRXX T
         WHERE T.SHXYDM=CUR_LC.SHXYNO OR T.NSRSBH=CUR_LC.SHXYNO OR T.NSRMC=CUR_LC.NSRMC
           AND T.NSRZT_DM='03';
      EXCEPTION
        WHEN OTHERS THEN
          LN_DJXH:=NULL;
      END;
    END IF;
    IF LN_DJXH IS NOT NULL THEN
      UPDATE TMP_20250619_QY_01
         SET DJXH=LN_DJXH,BABZ=LC_BABZ,TSSWJG_DM_1=LC_SWJG,CKHWTMSJSFF_DM=LC_TMSJSFF
       WHERE SHXYNO=CUR_LC.SHXYNO AND NSRMC=CUR_LC.NSRMC;
      COMMIT;
    END IF;
  END LOOP;

  UPDATE TMP_20250619_QY_01 T
     SET T.CKBGDH=T.BGD18||'00'||T.SPXH
   WHERE LENGTH(T.SPXH)=1;
  UPDATE TMP_20250619_QY_01 T
     SET T.CKBGDH=T.BGD18||'0'||T.SPXH
   WHERE LENGTH(T.SPXH)=2;
  COMMIT;

  FOR CUR_LC IN (SELECT DJXH,CKBGDH FROM TMP_20250619_QY_01 WHERE BABZ='Y' /*AND CKHWTMSJSFF_DM='2'*/)
  LOOP
    BEGIN
      SELECT T.CYTSSBJL,T.TSSBSL,T.TSSBMYLAJ,T.TSSBRMBLAJ
        INTO LC_CYTSSBJL,LN_TSSBSL,LN_TSSBMYLAJ,LN_TSSBRMBLAJ
        FROM HX_CKTS.CKTS_WBSJ_HG_BGD201 T
       WHERE T.DJXH=CUR_LC.DJXH AND T.CKBGDH=CUR_LC.CKBGDH;
    EXCEPTION
      WHEN OTHERS THEN
        LC_CYTSSBJL:=NULL;
    END;
    IF LC_CYTSSBJL IS NOT NULL THEN
      SELECT NVL(SUM(B.TSE),0)
        INTO LN_TSSBTSE
        FROM HX_CKTS.CKTS_SB_MTS_TSSB_JGB A
       INNER JOIN HX_CKTS.CKTS_SB_MTS_TSJH_JGB B ON B.DJXH=A.DJXH AND B.GLH=A.GLH
       WHERE A.DJXH=CUR_LC.DJXH AND A.CKBGDH=CUR_LC.CKBGDH;
      UPDATE TMP_20250619_QY_01 C
         SET C.CYTSSBJL=LC_CYTSSBJL,
             C.TSSBSL=LN_TSSBSL,
             C.TSSBMYLAJ=LN_TSSBMYLAJ,
             C.TSSBRMBLAJ=LN_TSSBRMBLAJ,
             C.TSSBTSE=LN_TSSBTSE
       WHERE C.DJXH=CUR_LC.DJXH AND C.CKBGDH=CUR_LC.CKBGDH;
      COMMIT;
    END IF;
  END LOOP;
  
  
END;
/

prompt
prompt Creating procedure TMP_PRO_DEAL_20260113
prompt ========================================
prompt
create or replace procedure tmp_pro_deal_20260113
as
  ln_mylaj2025    number(18,2);
  ln_mylaj2024    number(18,2);
  ln_dllaj2025    number(18,2);
  ln_dllaj2024    number(18,2);
  ln_tse2025      number(18,6);
  ln_tse2024      number(18,6);
  ln_mde2025      number(18,6);
  ln_mde2024      number(18,6);
begin
  for cur_lc in (select t.xh, t.djxh from tmp_20260113_zlqy t where t.mylaj2025 is null)
  loop
    select sum(case when bgd.ckrq_1<date'2025-01-01' then 0 else bgd.mylaj end),
           sum(case when bgd.ckrq_1<date'2025-01-01' then bgd.mylaj else 0 end)
      into ln_mylaj2025, ln_mylaj2024
      from hx_ckts.ckts_wbsj_hg_bgd201 bgd
     where bgd.djxh=cur_lc.djxh
       and bgd.ckrq_1>=date'2024-01-01' and bgd.ckrq_1<date'2026-01-01';

    select sum(case when zm.ckrq_1<date'2025-01-01' then 0 else zm.mylaj end),
           sum(case when zm.ckrq_1<date'2025-01-01' then zm.mylaj else 0 end)
      into ln_dllaj2025, ln_dllaj2024
      from hx_ckts.ckts_wbsj_zj_dlckhwzm zm
     where zm.djxh=cur_lc.djxh
       and zm.ckrq_1>=date'2024-01-01' and zm.ckrq_1<date'2026-01-01';
  
    select sum(case when se.sehzrq<date'2025-01-01' then 0 else se.sehzzzstse+se.sehzxfstse end),
           sum(case when se.sehzrq<date'2025-01-01' then 0 else se.sehzmdse end),
           sum(case when se.sehzrq<date'2025-01-01' then se.sehzzzstse+se.sehzxfstse else 0 end),
           sum(case when se.sehzrq<date'2025-01-01' then se.sehzmdse else 0 end)
      into ln_tse2025, ln_mde2025, ln_tse2024, ln_mde2024
      from hx_ckts.ckts_ty_sehzb se
     where se.djxh=cur_lc.djxh
       and se.sehzrq>=date'2024-01-01' and se.sehzrq<date'2026-01-01';
    
    update tmp_20260113_zlqy t
       set t.mylaj2025 = nvl(ln_mylaj2025,0)+nvl(ln_dllaj2025,0),
           t.mylaj2024 = nvl(ln_mylaj2024,0)+nvl(ln_dllaj2024,0),
           t.tse2025 = ln_tse2025,
           t.tse2024 = ln_tse2024,
           t.mde2025 = ln_mde2025,
           t.mde2024 = ln_mde2024
     where t.xh=cur_lc.xh;
    commit;
  end loop;

  return;
end;
/

prompt
prompt Creating procedure TMP_PRO_DEAL_20260313
prompt ========================================
prompt
CREATE OR REPLACE PROCEDURE TMP_PRO_DEAL_20260313
AS
  LN_MSXSE_Y  NUMBER(18,6);
  LN_MSXSE_X  NUMBER(18,6);
BEGIN
  INSERT INTO TMP_20260313_1039_1(DJXH,CKYEAR,FS,BS,RMBLAJ,MYLAJ,SJLY)
  select T.DJXH,TO_CHAR(T.CKRQ_1,'YYYY'),COUNT(DISTINCT SUBSTR(T.CKBGDH,1,18)),COUNT(1),SUM(T.RMBLAJ),SUM(T.MYLAJ),'BGD201'
    from HX_CKTS.CKTS_WBSJ_HG_BGD201 t
   WHERE T.JGFS_DM='1039' AND T.CKRQ_1>=DATE'2023-01-01'
   GROUP BY T.DJXH,TO_CHAR(T.CKRQ_1,'YYYY')
   UNION ALL
  select T.DJXH,TO_CHAR(T.CKRQ_1,'YYYY'),COUNT(DISTINCT SUBSTR(T.CKBGDH,1,18)),COUNT(1),SUM(T.RMBLAJ),SUM(T.MYLAJ),'WQFBGD201'
    from HX_CKTS.CKTS_WBSJ_HG_WQFBGD201 t
   WHERE T.DJXH IS NOT NULL AND T.JGFS_DM='1039' AND T.CKRQ_1>=DATE'2023-01-01'
   GROUP BY T.DJXH,TO_CHAR(T.CKRQ_1,'YYYY');
  COMMIT;
  INSERT INTO TMP_20260313_1039_2(DJXH,CKYEAR,FS,BS,RMBLAJ,MYLAJ,SJLY)
  SELECT DJXH,CKYEAR,SUM(FS),SUM(BS),SUM(RMBLAJ),SUM(MYLAJ),LISTAGG(SJLY,';') within group(order by DJXH,CKYEAR) as glgx_jh
    FROM TMP_20260313_1039_1 T
   GROUP BY DJXH,CKYEAR;
  COMMIT;

  FOR CUR_LC IN (SELECT T.DJXH,T.CKYEAR FROM TMP_20260313_1039_2 T)
  LOOP
    BEGIN
      LN_MSXSE_Y :=NULL;
      LN_MSXSE_X :=NULL;
      SELECT SUM(MSXSE)
        INTO LN_MSXSE_Y
        FROM HX_SB.SB_ZZS_YBNSR
       WHERE SBUUID IN (SELECT DISTINCT SBUUID
                          FROM HX_SB.SB_SBXX
                         WHERE DJXH=CUR_LC.DJXH
                           AND SKSSQQ>=TO_DATE(CUR_LC.CKYEAR||'0101','YYYYMMDD')
                           AND SKSSQZ<ADD_MONTHS(TO_DATE(CUR_LC.CKYEAR||'0101','YYYYMMDD'),12)
                           AND ZSXM_DM='10101' 
                           AND YZPZZL_DM ='BDA0610606'
                           AND GZLX_DM_1 IN ('1','5')
                           AND ZFBZ_1='N' )
         AND EWBLXH=1;
      SELECT SUM(MSXSE)
        INTO LN_MSXSE_X
        FROM HX_SB.SB_ZZS_XGM
       WHERE SBUUID IN (SELECT DISTINCT SBUUID
                          FROM HX_SB.SB_SBXX
                         WHERE DJXH=CUR_LC.DJXH
                           AND SKSSQQ>=TO_DATE(CUR_LC.CKYEAR||'0101','YYYYMMDD')
                           AND SKSSQZ<ADD_MONTHS(TO_DATE(CUR_LC.CKYEAR||'0101','YYYYMMDD'),12)
                           AND ZSXM_DM='10101' 
                           AND YZPZZL_DM ='BDA0610611'
                           AND GZLX_DM_1 IN ('1','5')
                           AND ZFBZ_1='N' )
         AND EWBLXH=1;
      UPDATE TMP_20260313_1039_2 S
         SET S.MSXSE_YBNSR=LN_MSXSE_Y,
             S.MSXSE_XGMNSR=LN_MSXSE_X
       WHERE S.DJXH=CUR_LC.DJXH
         AND S.CKYEAR=CUR_LC.CKYEAR;
      COMMIT;
    END;
  END LOOP;
END;
/

prompt
prompt Creating procedure TMP_PRO_DEAL_20260413
prompt ========================================
prompt
CREATE OR REPLACE PROCEDURE TMP_PRO_DEAL_20260413
AS
  LN_TSE  NUMBER(18,6);
BEGIN
  DELETE FROM TMP_20260413_TSHKSZX_1;
  COMMIT;
  
  INSERT INTO TMP_20260413_TSHKSZX_1(TSSWJG_DM_1,SWJGJC,DJXH,NSRSBH,NSRMC,BARQ,BACHRQ,BACHBZ,NSRZT_DM,NSRZTMC,YXQQ_FZC,YXQQ_FZCZX,YXQQ_ZX,SEHZRQ_MIN,SEHZRQ_MAX,SEHZ_TSE)
  WITH
  CKQY AS (
  SELECT T.TSSWJG_DM_1,T.DJXH,NVL(S.SHXYDM,S.NSRSBH) AS NSRSBH,S.NSRMC,TRUNC(T.BARQ) AS BARQ,TRUNC(T.BACHRQ) AS BACHRQ,T.BACHBZ,S.NSRZT_DM,
         CASE WHEN S.NSRZT_DM IN ('05','07','08') THEN
           (SELECT MIN(A.YXQQ) FROM HX_DJ.DJ_NSRZTBGXXB A --非正常日期，剔除无效数据，剔除备案前发生数据
            WHERE A.DJXH=T.DJXH AND A.NSRZT_DM='05' AND A.YXQZ>A.YXQQ
            AND NOT EXISTS (SELECT 1 FROM HX_DJ.DJ_NSRZTBGXXB B WHERE B.DJXH=A.DJXH AND B.NSRZT_DM='03' AND B.YXQZ>A.YXQQ))
           ELSE NULL END AS YXQQ_FZC,
         CASE WHEN S.NSRZT_DM IN ('05','07','08') THEN
           (SELECT MIN(A.YXQQ) FROM HX_DJ.DJ_NSRZTBGXXB A --非正常注销日期，剔除无效数据，剔除备案前发生数据
            WHERE A.DJXH=T.DJXH AND A.NSRZT_DM='08' AND A.YXQZ>A.YXQQ
            AND NOT EXISTS (SELECT 1 FROM HX_DJ.DJ_NSRZTBGXXB B WHERE B.DJXH=A.DJXH AND B.NSRZT_DM='03' AND B.YXQZ>A.YXQQ))
           ELSE NULL END AS YXQQ_FZCZX,
         CASE WHEN S.NSRZT_DM IN ('05','07','08') THEN
           (SELECT MIN(A.YXQQ) FROM HX_DJ.DJ_NSRZTBGXXB A --注销日期，剔除无效数据，剔除备案前发生数据
            WHERE A.DJXH=T.DJXH AND A.NSRZT_DM='07' AND A.YXQZ>A.YXQQ
            AND NOT EXISTS (SELECT 1 FROM HX_DJ.DJ_NSRZTBGXXB B WHERE B.DJXH=A.DJXH AND B.NSRZT_DM='03' AND B.YXQZ>A.YXQQ))
           ELSE NULL END AS YXQQ_ZX
    FROM HX_CKTS.CKTS_BA_BAXX_JGB T
   INNER JOIN HX_DJ.DJ_NSRXX S ON S.DJXH=T.DJXH
   WHERE T.BACHBZ='Y' OR S.NSRZT_DM IN ('05','07','08') -- 所有已备案撤回或状态为非正常、非正常注销、注销的出口企业
  ),
  TS AS (
  SELECT T.DJXH, TRUNC(MIN(T.SEHZRQ)) AS SEHZRQ_MIN, TRUNC(MAX(T.SEHZRQ)) AS SEHZRQ_MAX, SUM(T.SEHZZZSTSE+T.SEHZXFSTSE) AS SEHZ_TSE
    FROM CKQY
   INNER JOIN HX_CKTS.CKTS_TY_SEHZB T ON T.DJXH=CKQY.DJXH
   WHERE T.SEHZZZSTSE+T.SEHZXFSTSE>0
   GROUP BY T.DJXH --按企业汇总最早退税日期、最迟退税日期、以及核准退税额
  HAVING SUM(T.SEHZZZSTSE+T.SEHZXFSTSE)>=1000000 --退税额已超过100W
  )
  SELECT CKQY.TSSWJG_DM_1,JG.SWJGJC,CKQY.DJXH,CKQY.NSRSBH,CKQY.NSRMC,CKQY.BARQ,CKQY.BACHRQ,CKQY.BACHBZ,CKQY.NSRZT_DM,ZT.NSRZTMC,
         CKQY.YXQQ_FZC,CKQY.YXQQ_FZCZX,CKQY.YXQQ_ZX,TS.SEHZRQ_MIN,TS.SEHZRQ_MAX,TS.SEHZ_TSE
    FROM CKQY
   INNER JOIN TS ON TS.DJXH=CKQY.DJXH
   INNER JOIN HX_DM_ZDY.DM_GY_SWJG JG ON JG.SWJG_DM=CKQY.TSSWJG_DM_1
   INNER JOIN HX_DM_QG.DM_GY_NSRZT ZT ON ZT.NSRZT_DM=CKQY.NSRZT_DM
  ;
  COMMIT;

  FOR CUR_DJXH IN (SELECT T.DJXH FROM TMP_20260413_TSHKSZX_1 T)
  LOOP
    BEGIN
      LN_TSE :=0;
      FOR CUR_HZ IN (SELECT S.SEHZZZSTSE+S.SEHZXFSTSE AS HZTSE,TRUNC(S.SEHZRQ) AS SEHZRQ FROM HX_CKTS.CKTS_TY_SEHZB S WHERE S.DJXH=CUR_DJXH.DJXH ORDER BY S.SEHZRQ)
      LOOP
        BEGIN
          LN_TSE := LN_TSE + CUR_HZ.HZTSE;
          IF LN_TSE >=1000000 THEN
            UPDATE TMP_20260413_TSHKSZX_1 TT
               SET TT.SEHZRQ_100W=CUR_HZ.SEHZRQ
             WHERE TT.DJXH=CUR_DJXH.DJXH;
            COMMIT;
            EXIT;
          END IF;
        END;
      END LOOP;
    END;
  END LOOP;
END;
/

prompt
prompt Creating procedure TMP_PRO_DEAL_20260509
prompt ========================================
prompt
create or replace procedure tmp_pro_deal_20260509
as
begin
  insert into tmp_20260509_1039_1(djxh,ckyear,mylaj_1039,sjly)
  select t.djxh,to_char(t.ckrq_1,'YYYY'),sum(t.mylaj),'BGD'
    from hx_ckts.ckts_wbsj_hg_bgd201 t
   where t.ckrq_1>=date'2023-01-01'
     and t.ckrq_1<date'2026-05-01'
     and t.jgfs_dm='1039'
   group by t.djxh,to_char(t.ckrq_1,'YYYY')
   union all
  select t.djxh,to_char(t.ckrq_1,'YYYY'),sum(t.mylaj),'WQF'
    from hx_ckts.ckts_wbsj_hg_wqfbgd201 t
   where t.djxh is not null
     and t.ckrq_1>=date'2023-01-01'
     and t.ckrq_1<date'2026-05-01'
     and t.jgfs_dm='1039'
   group by t.djxh,to_char(t.ckrq_1,'YYYY')
   union all
  select t.djxh,to_char(t.ckrq_1,'YYYY'),sum(t.mylaj),'DLZM'
    from hx_ckts.ckts_wbsj_zj_dlckhwzm t
   where t.ckrq_1>=date'2023-01-01'
     and t.ckrq_1<date'2026-05-01'
     and t.jgfs_dm='1039'
   group by t.djxh,to_char(t.ckrq_1,'YYYY');
  commit;
  
  update tmp_20260509_1039_1 t
     set t.mylaj_all= (select sum(s.mylaj)
                         from hx_ckts.ckts_wbsj_hg_bgd201 s
                        where s.djxh=t.djxh
                          and s.ckrq_1>=to_date(t.ckyear||'0101','YYYYMMDD')
                          and s.ckrq_1<add_months(to_date(t.ckyear||'0101','YYYYMMDD'),12)
                          and s.ckrq_1<date'2026-05-01')
   where t.sjly='BGD';
  commit;
  update tmp_20260509_1039_1 t
     set t.mylaj_all= (select sum(s.mylaj)
                         from hx_ckts.ckts_wbsj_hg_wqfbgd201 s
                        where s.djxh=t.djxh
                          and s.ckrq_1>=to_date(t.ckyear||'0101','YYYYMMDD')
                          and s.ckrq_1<add_months(to_date(t.ckyear||'0101','YYYYMMDD'),12)
                          and s.ckrq_1<date'2026-05-01')
   where t.sjly='WQF';
  commit;
  update tmp_20260509_1039_1 t
     set t.mylaj_all= (select sum(s.mylaj)
                         from hx_ckts.ckts_wbsj_zj_dlckhwzm s
                        where s.djxh=t.djxh
                          and s.ckrq_1>=to_date(t.ckyear||'0101','YYYYMMDD')
                          and s.ckrq_1<add_months(to_date(t.ckyear||'0101','YYYYMMDD'),12)
                          and s.ckrq_1<date'2026-05-01')
   where t.sjly='DLZM';
  commit;
  
  insert into tmp_20260509_1039_2(djxh,ckyear,mylaj_1039,mylaj_all,sjly)
  select djxh,ckyear,sum(mylaj_1039),sum(mylaj_all),listagg(sjly,';') within group(order by djxh,ckyear)
    from tmp_20260509_1039_1 t
   group by djxh,ckyear;
  commit;
  
  update tmp_20260509_1039_2 t
     set t.shjemy=nvl((select sum(wh.ckshjemy)
                         from hx_ckts.ckts_wbsj_wh_hwshzbsj wh
                        where wh.djxh=t.djxh
                          and wh.ckshrq>=to_date(t.ckyear||'0101','YYYYMMDD')
                          and wh.ckshrq<add_months(to_date(t.ckyear||'0101','YYYYMMDD'),12)
                          and wh.ckshrq<date'2026-05-01'),0)+
                  nvl((select sum(round(zj.skzje * 100 / hl.rmbhl,2))
                         from hx_ckts.ckts_wbsj_zj_kjmysrxx zj
                        inner join hx_cs_zdy.cs_ckts_hl hl
                           on hl.hbzm_dm='USD' and hl.hlny=to_char(zj.skrq,'yyyymm')
                        where zj.djxh=t.djxh
                          and zj.skrq>=to_date(t.ckyear||'0101','YYYYMMDD')
                          and zj.skrq<add_months(to_date(t.ckyear||'0101','YYYYMMDD'),12)
                          and zj.skrq<date'2026-05-01'),0);
  commit; 
end;
/

prompt
prompt Creating procedure TMP_PRO_DEAL_20260519
prompt ========================================
prompt
CREATE OR REPLACE PROCEDURE TMP_PRO_DEAL_20260519
AS
  LN_JSJKZZ  NUMBER(18,2);
  LN_JSCKZZ  NUMBER(18,2);
  LN_JSJKZZ_0654  NUMBER(18,2);
  LN_JSCKZZ_0654  NUMBER(18,2);
  LN_JSJKZZ_0654_ZS  NUMBER(18,2);
  LN_JSCKZZ_0654_ZS  NUMBER(18,2);
  LN_JSCKZZ_BGD201_0654  NUMBER(18,2);
  LN_JSCKZZ_BGD201_0654_ZS  NUMBER(18,2);
BEGIN
/*
  INSERT INTO TMP_20260519_JLSJGJZ_1(DJXH,BAH,HXQSRQ,HXJZRQ)
  SELECT DISTINCT T.DJXH,T.BAH,DATE'1900-01-01' AS HXQSRQ, DATE'2026-12-31' AS HXJZRQ
    FROM HX_CKTS.CKTS_WBSJ_HG_DZSCHXXX T
   WHERE TRUNC(T.JARQ,'yy')=DATE'2025-01-01'
   UNION ALL
  SELECT DISTINCT T.DJXH,T.BAH,T.HXQSRQ, T.HXJZRQ
    FROM HX_CKTS.CKTS_WBSJ_HG_DZZCHXXX T
   WHERE TRUNC(T.HXJZRQ,'yy')=DATE'2025-01-01';
  COMMIT;
  SELECT T.*,T.ROWID FROM TMP_20260519_JLSJGJZ_1 T WHERE T.DJXH IS NULL;
  SELECT T.*,T.ROWID,S.*,ROW_NUMBER() OVER (PARTITION BY T.DJXH,T.BAH ORDER BY S.LRRQ DESC) AS PM
    FROM TMP_20260519_JLSJGJZ_1 T
   INNER JOIN HX_CKTS.CKTS_SB_JLJG_MDTHX_JGB S
      ON S.DJXH=T.DJXH AND S.JLJGSZCH=T.BAH
   WHERE REGEXP_LIKE(T.BAH,'^B|^C')
     AND T.JSJKZZ_MDTHX IS NULL;
  SELECT T.*,T.ROWID,S.*,ROW_NUMBER() OVER (PARTITION BY T.DJXH,T.BAH ORDER BY S.LRRQ DESC) AS PM
    FROM TMP_20260519_JLSJGJZ_1 T
   INNER JOIN HX_CKTS.CKTS_SB_JLJG_MDTHX_JGB S
      ON S.DJXH=T.DJXH AND S.JLJGSZCH=T.BAH AND S.HXQSRQ=T.HXQSRQ AND S.HXJZRQ=T.HXJZRQ
   WHERE REGEXP_LIKE(T.BAH,'^E|^H')
     AND T.JSJKZZ_MDTHX IS NULL;
*/
  FOR CUR_SZC IN (SELECT DJXH,BAH,HXQSRQ,HXJZRQ FROM TMP_20260519_JLSJGJZ_1 WHERE BAH LIKE 'C%' AND JSJKZZ_HXGBD IS NULL)
  LOOP
    BEGIN
      SELECT SUM(CASE WHEN S.JS_FLAG_1=1 THEN T.RMBLAJ WHEN S.JS_FLAG_1=3 THEN T.RMBLAJ WHEN S.JS_FLAG_1=4 THEN (-1) * T.RMBLAJ ELSE 0 END),
             SUM(CASE WHEN S.JS_FLAG_1=2 THEN T.RMBLAJ WHEN S.JS_FLAG_1=5 THEN T.RMBLAJ WHEN S.JS_FLAG_1=6 THEN (-1) * T.RMBLAJ ELSE 0 END),
             SUM(CASE WHEN T.JGFS_DM='0654' AND T.JCKBZ_DM='I' THEN T.RMBLAJ ELSE 0 END),
             SUM(CASE WHEN T.JGFS_DM='0654' AND T.JCKBZ_DM='E' THEN T.RMBLAJ ELSE 0 END),
             SUM(CASE WHEN T.JGFS_DM='0654' AND T.JCKBZ_DM='I' AND NVL(NVL(A.CKSPTSSPLX_DM,B.CKSPTSSPLX_DM),'0')='1' THEN T.RMBLAJ ELSE 0 END),
             SUM(CASE WHEN T.JGFS_DM='0654' AND T.JCKBZ_DM='E'  AND NVL(NVL(A.CKSPTSSPLX_DM,B.CKSPTSSPLX_DM),'0')='1'THEN T.RMBLAJ ELSE 0 END)
        INTO LN_JSJKZZ, LN_JSCKZZ, LN_JSJKZZ_0654, LN_JSCKZZ_0654, LN_JSJKZZ_0654_ZS, LN_JSCKZZ_0654_ZS
        FROM HX_CKTS.CKTS_WBSJ_HG_HXBGD T
       INNER JOIN TMP_TDCODE_JLJG S ON S.CODE=T.JGFS_DM AND S.JCKBZ=T.JCKBZ_DM
        LEFT JOIN HX_CKTS.CKTS_TY_CKSPTSLWK A ON A.CKSP_DM=T.CKSP_DM AND T.CKRQ_1>=A.YXQQ AND T.CKRQ_1<=A.YXQZ
        LEFT JOIN HX_CKTS.CKTS_TY_CKSPTSLWK B ON B.CKSP_DM=SUBSTR(T.CKSP_DM,1,8) AND T.CKRQ_1>=B.YXQQ AND T.CKRQ_1<=B.YXQZ
       WHERE T.DJXH=CUR_SZC.DJXH
         AND T.BAH=CUR_SZC.BAH
         AND (REGEXP_LIKE(CUR_SZC.BAH,'^B|^C') OR 
              (REGEXP_LIKE(CUR_SZC.BAH,'^E|^H') AND T.CKRQ_1>=CUR_SZC.HXQSRQ AND T.CKRQ_1<=CUR_SZC.HXJZRQ));
    EXCEPTION
      WHEN OTHERS THEN
        LN_JSJKZZ := 0;
        LN_JSCKZZ := 0;
        LN_JSJKZZ_0654 :=0;
        LN_JSCKZZ_0654 :=0;
        LN_JSJKZZ_0654_ZS :=0;
        LN_JSCKZZ_0654_ZS :=0;
    END;
    BEGIN
      SELECT SUM(T.RMBLAJ),
             SUM(CASE WHEN NVL(NVL(A.CKSPTSSPLX_DM,B.CKSPTSSPLX_DM),'0')='1' THEN T.RMBLAJ ELSE 0 END)
        INTO LN_JSCKZZ_BGD201_0654, LN_JSCKZZ_BGD201_0654_ZS
        FROM HX_CKTS.CKTS_WBSJ_HG_BGD201 T
        LEFT JOIN HX_CKTS.CKTS_TY_CKSPTSLWK A ON A.CKSP_DM=T.CKSP_DM AND T.CKRQ_1>=A.YXQQ AND T.CKRQ_1<=A.YXQZ
        LEFT JOIN HX_CKTS.CKTS_TY_CKSPTSLWK B ON B.CKSP_DM=SUBSTR(T.CKSP_DM,1,8) AND T.CKRQ_1>=B.YXQQ AND T.CKRQ_1<=B.YXQZ
       WHERE T.DJXH=CUR_SZC.DJXH
         AND T.BAH=CUR_SZC.BAH
         AND T.JGFS_DM='0654'
         AND (REGEXP_LIKE(CUR_SZC.BAH,'^B|^C') OR 
              (REGEXP_LIKE(CUR_SZC.BAH,'^E|^H') AND T.CKRQ_1>=CUR_SZC.HXQSRQ AND T.CKRQ_1<=CUR_SZC.HXJZRQ));
    EXCEPTION
      WHEN OTHERS THEN
        LN_JSCKZZ_BGD201_0654 := 0;
        LN_JSCKZZ_BGD201_0654_ZS := 0;
    END;
    UPDATE TMP_20260519_JLSJGJZ_1 S
       SET S.JSJKZZ_HXGBD = LN_JSJKZZ,
           S.JSCKZZ_HXBGD = LN_JSCKZZ,
           S.JSJKZZ_HXGBD_0654 = LN_JSJKZZ_0654,
           S.JSCKZZ_HXBGD_0654 = LN_JSCKZZ_0654,
           S.JSJKZZ_HXGBD_0654_ZS = LN_JSJKZZ_0654_ZS,
           S.JSCKZZ_HXBGD_0654_ZS = LN_JSCKZZ_0654_ZS,
           S.JSCKZZ_BGD201_0654 = LN_JSCKZZ_BGD201_0654,
           S.JSCKZZ_BGD201_0654_ZS = LN_JSCKZZ_BGD201_0654_ZS
     WHERE S.DJXH = CUR_SZC.DJXH
       AND S.BAH = CUR_SZC.BAH
       AND S.HXQSRQ = CUR_SZC.HXQSRQ
       AND S.HXJZRQ = CUR_SZC.HXJZRQ;
    COMMIT;
  END LOOP;
/*
  SELECT S.ZGSWJ_DM,NVL(S.SHXYDM,S.NSRSBH),S.NSRMC,T.*
    FROM TMP_20260519_JLSJGJZ_1 T
   INNER JOIN HX_DJ.DJ_NSRXX S ON S.DJXH=T.DJXH
   WHERE T.JSJKZZ_HXGBD IS NOT NULL
   ORDER BY S.ZGSWJ_DM,T.BAH;
*/
END;
/

prompt
prompt Creating procedure TMP_PRO_DEAL_20260710
prompt ========================================
prompt
CREATE OR REPLACE PROCEDURE TMP_PRO_DEAL_20260710
AS
BEGIN
/*
  INSERT INTO TMP_20260710_XGM(DJXH,RMBLAJ_QF)
  SELECT T.DJXH,SUM(T.RMBLAJ) AS RMBLAJ
    FROM HX_CKTS.CKTS_WBSJ_HG_BGD201 T
   WHERE T.CKRQ_1>=DATE'2026-01-01' AND T.CKRQ_1<DATE'2026-04-01'
   GROUP BY T.DJXH;
  COMMIT;

  MERGE INTO TMP_20260710_XGM A
        USING (SELECT T.DJXH,SUM(T.RMBLAJ) AS RMBLAJ
                 FROM HX_CKTS.CKTS_WBSJ_HG_WQFBGD201 T
                WHERE T.CKRQ_1>=DATE'2026-01-01' AND T.CKRQ_1<DATE'2026-04-01'
                GROUP BY T.DJXH) B
           ON (B.DJXH=A.DJXH)
         WHEN MATCHED THEN
           UPDATE SET A.RMBLAJ_WQF=B.RMBLAJ
         WHEN NOT MATCHED THEN
            INSERT (DJXH,RMBLAJ_WQF)
            VALUES (B.DJXH,B.RMBLAJ);
  COMMIT;

  INSERT INTO TMP_20260710_XGM_1(DJXH,RMBLAJ_QF,RMBLAJ_WQF)
  SELECT DJXH,RMBLAJ_QF,RMBLAJ_WQF
    FROM TMP_20260710_XGM T
   WHERE NOT EXISTS (
         SELECT 1
           FROM HX_RD.RD_NSRZGXX_JGB S
          WHERE S.DJXH=T.DJXH
            AND S.NSRZGLX_DM IN ('201','202','203')
            AND S.ZFBZ_1='N'
            AND (TRUNC(SYSDATE) BETWEEN S.YXQQ AND S.YXQZ));
*/
  
  FOR CUR_CKQY IN (SELECT DJXH,RMBLAJ_QF,RMBLAJ_WQF FROM TMP_20260710_XGM_1)
  LOOP
    -- 小规模报表
/*
    UPDATE TMP_20260710_XGM_1 A
       SET (A.YZXSE,A.MSXSE,A.CKMSXSE) = (
           SELECT SUM(YZZZSBHSXSE),SUM(MSXSE),SUM(CKMSXSE)
             FROM HX_SB.SB_ZZS_XGM
            WHERE SBUUID IN (SELECT DISTINCT SBUUID
                               FROM HX_SB.SB_SBXX
                              WHERE DJXH=CUR_CKQY.DJXH
                                AND SKSSQQ>=DATE'2026-01-01' AND SKSSQZ<DATE'2026-04-01'
                                AND ZSXM_DM='10101' 
                                AND YZPZZL_DM='BDA0610611'
                                AND GZLX_DM_1 IN ('1','5')
                                AND ZFBZ_1='N' )
              AND EWBLXH IN (1, 2))
     WHERE A.DJXH=CUR_CKQY.DJXH;
    COMMIT;
*/
    UPDATE TMP_20260710_XGM_1 A
       SET A.RMBLAJ_1039 = NVL((SELECT SUM(T.RMBLAJ) FROM HX_CKTS.CKTS_WBSJ_HG_BGD201 T
                                 WHERE T.DJXH=CUR_CKQY.DJXH AND T.CKRQ_1>=DATE'2026-01-01' AND T.CKRQ_1<DATE'2026-04-01' AND T.JGFS_DM='1039'),0)
                         + NVL((SELECT SUM(T.RMBLAJ) FROM HX_CKTS.CKTS_WBSJ_HG_WQFBGD201 T
                                 WHERE T.DJXH=CUR_CKQY.DJXH AND T.CKRQ_1>=DATE'2026-01-01' AND T.CKRQ_1<DATE'2026-04-01' AND T.JGFS_DM='1039'),0)
     WHERE A.DJXH=CUR_CKQY.DJXH;
    COMMIT;
  END LOOP;

END;
/

prompt
prompt Creating procedure TMP_PRO_TEST_YJSC
prompt ====================================
prompt
CREATE OR REPLACE PROCEDURE TMP_PRO_TEST_YJSC
/*
 * 预警处理效率测试
 */
AS
BEGIN
  FOR CUR_LC IN (SELECT TSSWJG_DM_1,DJXH,SSQ,SBPC,LCSWSX_DM,LCSLID
                   FROM HX_CKTS.CKTS_TY_YWBLXX T
                  WHERE T.LCSWSX_DM='LCSXA081038001'
                    AND T.QDSJ>TRUNC(SYSDATE,'MM')
                    AND T.ZLCLCSLID=T.LCSLID
                    AND EXISTS (SELECT 1
                                  FROM HX_CKTS.CKTS_SB_MDT_TSSB_GCB S1
                                 WHERE S1.LCSLID=T.LCSLID)
                    AND NOT EXISTS (SELECT 1
                                      FROM CKTS_YJRZ_LCSLID S2
                                     WHERE S2.LCSLID=T.LCSLID))
  LOOP
    --新增出口商品（生产）
    INSERT INTO CKTS_YJRZ_LCSLID(TSSWJG_DM_1,DJXH,SSQ,SBPC,LCSWSX_DM,LCSLID,ZBCODE)
         VALUES (CUR_LC.TSSWJG_DM_1,CUR_LC.DJXH,CUR_LC.SSQ,CUR_LC.SBPC,CUR_LC.LCSWSX_DM,CUR_LC.LCSLID,'10101');
    COMMIT;
    UPDATE CKTS_YJRZ_LCSLID S
       SET S.YJ_COUNT=(SELECT COUNT(1) FROM (
/*********************************************************************************************************************************/
           SELECT T.LCSLID,T.YJ_OBJECT,T.YJ_RECORD,T.YJ_COUNT,T.YJ_AMT,T.YJ_TAX,
                  (SELECT B.SBHGSPMC FROM HX_CKTS.CKTS_SB_MDT_TSSB_GCB B WHERE B.LCSLID=T.LCSLID AND B.SBXH=T.YJ_RECORD) AS CMNAME
             FROM (SELECT A.DJXH,
                          A.LCSLID,
                          SUBSTR(A.CKSP_DM,1,8) AS YJ_OBJECT,
                          MIN(A.SBXH) AS YJ_RECORD,
                          COUNT(1) AS YJ_COUNT,
                          SUM(A.MYLAJ) AS YJ_AMT,
                          SUM(A.MDTSE) AS YJ_TAX,
                          MIN(A.CKRQ_1) AS CKRQ0
                     FROM HX_CKTS.CKTS_SB_MDT_TSSB_GCB A
                    WHERE LCSLID = CUR_LC.LCSLID --#{LCSLID}
                    GROUP BY A.DJXH,A.LCSLID,SUBSTR(A.CKSP_DM,1,8)
                   HAVING SUM(A.MDTSE) > 1 --#{PVAL1}
                  ) T
            WHERE NOT EXISTS (SELECT 1
                                FROM HX_CKTS.CKTS_SB_MDT_TSSB_JGB S
                               WHERE S.DJXH = T.DJXH
                                 AND SUBSTR(S.CKSP_DM,1,8) = T.YJ_OBJECT
                                 AND S.CKRQ_1 >=ADD_MONTHS(TRUNC(T.CKRQ0,'YY'),-24))
              AND NOT EXISTS (SELECT 1
                                FROM HX_CKTS.CKTS_SB_MDT_TSSB_GCB S
                               INNER JOIN HX_CKTS.CKTS_BL_MDT_SHYDCL_JGB R
                                  ON R.DJXH=S.DJXH AND R.SSQ=S.SSQ AND R.SBXH=S.SBXH AND R.ZHSHCLYJLX_DM='4'
                               WHERE S.DJXH = T.DJXH AND S.LCSLID<>T.LCSLID
                                 AND SUBSTR(S.CKSP_DM,1,8) = T.YJ_OBJECT
                                 AND S.CKRQ_1 >=ADD_MONTHS(TRUNC(T.CKRQ0,'YY'),-24))
/*********************************************************************************************************************************/
                      ))
     WHERE S.LCSLID=CUR_LC.LCSLID AND S.ZBCODE='10101';
    COMMIT;
    UPDATE CKTS_YJRZ_LCSLID S
       SET S.END_TIME=SYSDATE
     WHERE S.LCSLID=CUR_LC.LCSLID AND S.ZBCODE='10101';
    COMMIT;

    --首次申报出口退税
    INSERT INTO CKTS_YJRZ_LCSLID(TSSWJG_DM_1,DJXH,SSQ,SBPC,LCSWSX_DM,LCSLID,ZBCODE)
         VALUES (CUR_LC.TSSWJG_DM_1,CUR_LC.DJXH,CUR_LC.SSQ,CUR_LC.SBPC,CUR_LC.LCSWSX_DM,CUR_LC.LCSLID,'10301');
    COMMIT;
    UPDATE CKTS_YJRZ_LCSLID S
       SET S.YJ_COUNT=(
/*********************************************************************************************************************************/
           WITH
           SCSBQK AS (
           SELECT B.DJXH, B.LCSWSX_DM, NVL(B.SDHCWCBZ,'0') AS SDHCWCBZ, B.QYZTLX, TRUNC(B.QYZTBGSJ) AS QYZTBGSJ
             FROM (SELECT T.DJXH, T.LCSWSX_DM, T.LCSLID, T.QDSJ, A.SDHCWCBZ, A.QYZTLX, A.QYZTBGSJ, A.LRRQ
                     FROM HX_CKTS.CKTS_TY_YWBLXX T
                    INNER JOIN HX_CKTS.CKTS_TY_SCSBQK A ON A.DJXH=T.DJXH
                    WHERE T.LCSLID=CUR_LC.LCSLID --#{LCSLID}
                    ORDER BY A.LRRQ DESC) B
            WHERE ROWNUM=1),
           SDHCBG AS (
           SELECT D.DJXH, D.HCYYSM, D.HCJGSM
             FROM (SELECT C.DJXH, C.HCYYSM, C.HCJGSM, C.LRRQ
                     FROM SCSBQK
                    INNER JOIN HX_CKTS.CKTS_SDHC_SDHCBG_JGB C ON C.DJXH=SCSBQK.DJXH
                    WHERE SCSBQK.SDHCWCBZ<>'2'
                      AND C.HCYYSM LIKE DECODE(SCSBQK.QYZTLX,'1','%01%','2',DECODE(SCSBQK.LCSWSX_DM,'LCSXA081038001','%17%','%18%'),'3','%12%')
                      AND C.LRRQ >=SCSBQK.QYZTBGSJ
                    ORDER BY C.LRRQ DESC) D
            WHERE ROWNUM=1)
           SELECT COUNT(1)
             FROM DUAL
            WHERE NOT EXISTS (SELECT 1 FROM SCSBQK WHERE SCSBQK.SDHCWCBZ='2'
                              UNION
                              SELECT 1 FROM SDHCBG WHERE REGEXP_LIKE(SDHCBG.HCJGSM,'01|02|03|04'))
              AND EXISTS (SELECT 1
                            FROM HX_CKTS.CKTS_SB_MDT_SBHZ_GCB
                           WHERE LCSLID=CUR_LC.LCSLID --#{LCSLID}
                             AND MDTSE>0)
/*********************************************************************************************************************************/
           )
     WHERE S.LCSLID=CUR_LC.LCSLID AND S.ZBCODE='10301';
    COMMIT;
    UPDATE CKTS_YJRZ_LCSLID S
       SET S.END_TIME=SYSDATE
     WHERE S.LCSLID=CUR_LC.LCSLID AND S.ZBCODE='10301';
    COMMIT;
  END LOOP;
END;
/

prompt
prompt Creating procedure TMP_PRO_TEST_YJWM
prompt ====================================
prompt
CREATE OR REPLACE PROCEDURE TMP_PRO_TEST_YJWM
/*
 * 预警处理效率测试
 */
AS
BEGIN
  FOR CUR_LC IN (SELECT TSSWJG_DM_1,DJXH,SSQ,SBPC,LCSWSX_DM,LCSLID
                   FROM HX_CKTS.CKTS_TY_YWBLXX T
                  WHERE T.LCSWSX_DM='LCSXA081039001'
                    AND T.QDSJ>TRUNC(SYSDATE,'MM')
                    AND T.ZLCLCSLID=T.LCSLID
                    AND EXISTS (SELECT 1
                                  FROM HX_CKTS.CKTS_SB_MTS_TSSB_GCB S1
                                 WHERE S1.LCSLID=T.LCSLID)
                    AND NOT EXISTS (SELECT 1
                                      FROM CKTS_YJRZ_LCSLID S2
                                     WHERE S2.LCSLID=T.LCSLID AND S2.ZBCODE='10501'))
  LOOP
    --新增出口商品（外贸）
    INSERT INTO CKTS_YJRZ_LCSLID(TSSWJG_DM_1,DJXH,SSQ,SBPC,LCSWSX_DM,LCSLID,ZBCODE)
         VALUES (CUR_LC.TSSWJG_DM_1,CUR_LC.DJXH,CUR_LC.SSQ,CUR_LC.SBPC,CUR_LC.LCSWSX_DM,CUR_LC.LCSLID,'10101');
    COMMIT;
    UPDATE CKTS_YJRZ_LCSLID S
       SET S.YJ_COUNT=(SELECT COUNT(1) FROM (
/*********************************************************************************************************************************/
           WITH
           GLMX AS (
           SELECT A1.DJXH,A1.LCSLID,A1.CKSP_DM,A1.GLH,A1.CKRQ_1,A1.MYLAJ,
                  (SELECT SUM(A2.TSE) FROM HX_CKTS.CKTS_SB_MTS_TSJH_GCB A2 WHERE A2.DJXH=A1.DJXH AND A2.GLH=A1.GLH) AS TSE
             FROM HX_CKTS.CKTS_SB_MTS_TSSB_GCB A1
            WHERE A1.LCSLID = CUR_LC.LCSLID --#{LCSLID}
           ),
           FZTJ AS (
           SELECT A.DJXH,A.LCSLID,
                  SUBSTR(A.CKSP_DM,1,8) AS YJ_OBJECT,
                  MIN(A.GLH) AS YJ_RECORD,
                  COUNT(1) AS YJ_COUNT,
                  SUM(A.MYLAJ) AS YJ_AMT,
                  SUM(A.TSE) AS YJ_TAX,
                  MIN(A.CKRQ_1) AS CKRQ0
             FROM GLMX A
            GROUP BY A.DJXH,A.LCSLID,SUBSTR(A.CKSP_DM,1,8)
           HAVING SUM(A.TSE) > 1 --#{PVAL1}
           )
           SELECT T.LCSLID,T.YJ_OBJECT,T.YJ_RECORD,T.YJ_COUNT,T.YJ_AMT,T.YJ_TAX,
                  (SELECT B.SBHGSPMC FROM HX_CKTS.CKTS_SB_MTS_TSSB_GCB B WHERE B.LCSLID=T.LCSLID AND B.GLH=T.YJ_RECORD) AS CMNAME
             FROM FZTJ T
            WHERE NOT EXISTS (SELECT 1
                                FROM HX_CKTS.CKTS_SB_MTS_TSSB_JGB S
                               WHERE S.DJXH = T.DJXH
                                 AND SUBSTR(S.CKSP_DM,1,8) = T.YJ_OBJECT
                                 AND S.CKRQ_1 >=ADD_MONTHS(TRUNC(T.CKRQ0,'YY'),-24))
/**/
                      ))
     WHERE S.LCSLID=CUR_LC.LCSLID AND S.ZBCODE='10101';
    COMMIT;
    UPDATE CKTS_YJRZ_LCSLID S
       SET S.END_TIME=SYSDATE
     WHERE S.LCSLID=CUR_LC.LCSLID AND S.ZBCODE='10101';
    COMMIT;
    
    --新增供货商（外贸）
    INSERT INTO CKTS_YJRZ_LCSLID(TSSWJG_DM_1,DJXH,SSQ,SBPC,LCSWSX_DM,LCSLID,ZBCODE)
         VALUES (CUR_LC.TSSWJG_DM_1,CUR_LC.DJXH,CUR_LC.SSQ,CUR_LC.SBPC,CUR_LC.LCSWSX_DM,CUR_LC.LCSLID,'10201');
    COMMIT;
    UPDATE CKTS_YJRZ_LCSLID S
       SET S.YJ_COUNT=(SELECT COUNT(1) FROM (
/*********************************************************************************************************************************/
           WITH
           FZTJ AS (
           SELECT A.DJXH,
                  A.LCSLID,
                  A.GHFNSRSBH_1 AS YJ_OBJECT,
                  MIN(A.GLH) AS YJ_RECORD,
                  COUNT(1) AS YJ_COUNT,
                  SUM(A.JSJE) AS YJ_AMT,
                  SUM(A.TSE) AS YJ_TAX,
                  MIN(A.KPRQ) AS KPRQ0
             FROM HX_CKTS.CKTS_SB_MTS_TSJH_GCB A
            WHERE A.LCSLID = CUR_LC.LCSLID --#{LCSLID}
            GROUP BY A.DJXH,A.LCSLID,A.GHFNSRSBH_1
           HAVING SUM(A.TSE) > 1 --#{PVAL1}
           )
           SELECT T.LCSLID,T.YJ_OBJECT,T.YJ_RECORD,T.YJ_COUNT,T.YJ_AMT,T.YJ_TAX,
                  (SELECT B.SBHGSPMC FROM HX_CKTS.CKTS_SB_MTS_TSSB_GCB B WHERE B.LCSLID=T.LCSLID AND B.GLH=T.YJ_RECORD) AS CMNAME
             FROM FZTJ T
            WHERE NOT EXISTS (SELECT 1
                                FROM HX_CKTS.CKTS_SB_MTS_TSJH_JGB S
                               WHERE S.DJXH = T.DJXH
                                 AND S.GHFNSRSBH_1 = T.YJ_OBJECT
                                 AND S.KPRQ >=ADD_MONTHS(TRUNC(T.KPRQ0,'YY'),-24))
/**/
                      ))
     WHERE S.LCSLID=CUR_LC.LCSLID AND S.ZBCODE='10201';
    COMMIT;
    UPDATE CKTS_YJRZ_LCSLID S
       SET S.END_TIME=SYSDATE
     WHERE S.LCSLID=CUR_LC.LCSLID AND S.ZBCODE='10201';
    COMMIT;
    
    --首次申报出口退税
    INSERT INTO CKTS_YJRZ_LCSLID(TSSWJG_DM_1,DJXH,SSQ,SBPC,LCSWSX_DM,LCSLID,ZBCODE)
         VALUES (CUR_LC.TSSWJG_DM_1,CUR_LC.DJXH,CUR_LC.SSQ,CUR_LC.SBPC,CUR_LC.LCSWSX_DM,CUR_LC.LCSLID,'10301');
    COMMIT;
    UPDATE CKTS_YJRZ_LCSLID S
       SET S.YJ_COUNT=(
/*********************************************************************************************************************************/
           WITH
           SCSBQK AS (
           SELECT B.DJXH, B.LCSWSX_DM, NVL(B.SDHCWCBZ,'0') AS SDHCWCBZ, B.QYZTLX, TRUNC(B.QYZTBGSJ) AS QYZTBGSJ
             FROM (SELECT T.DJXH, T.LCSWSX_DM, T.LCSLID, T.QDSJ, A.SDHCWCBZ, A.QYZTLX, A.QYZTBGSJ, A.LRRQ
                     FROM HX_CKTS.CKTS_TY_YWBLXX T
                    INNER JOIN HX_CKTS.CKTS_TY_SCSBQK A ON A.DJXH=T.DJXH
                    WHERE T.LCSLID=CUR_LC.LCSLID --#{LCSLID}
                    ORDER BY A.LRRQ DESC) B
            WHERE ROWNUM=1),
           SDHCBG AS (
           SELECT D.DJXH, D.HCYYSM, D.HCJGSM
             FROM (SELECT C.DJXH, C.HCYYSM, C.HCJGSM, C.LRRQ
                     FROM SCSBQK
                    INNER JOIN HX_CKTS.CKTS_SDHC_SDHCBG_JGB C ON C.DJXH=SCSBQK.DJXH
                    WHERE SCSBQK.SDHCWCBZ<>'2'
                      AND C.HCYYSM LIKE DECODE(SCSBQK.QYZTLX,'1','%01%','2',DECODE(SCSBQK.LCSWSX_DM,'LCSXA081038001','%17%','%18%'),'3','%12%')
                      AND C.LRRQ >=SCSBQK.QYZTBGSJ
                    ORDER BY C.LRRQ DESC) D
            WHERE ROWNUM=1)
           SELECT COUNT(1)
             FROM DUAL
            WHERE NOT EXISTS (SELECT 1 FROM SCSBQK WHERE SCSBQK.SDHCWCBZ='2'
                              UNION
                              SELECT 1 FROM SDHCBG WHERE REGEXP_LIKE(SDHCBG.HCJGSM,'01|02|03|04'))
/**/
           )
     WHERE S.LCSLID=CUR_LC.LCSLID AND S.ZBCODE='10301';
    COMMIT;
    UPDATE CKTS_YJRZ_LCSLID S
       SET S.END_TIME=SYSDATE
     WHERE S.LCSLID=CUR_LC.LCSLID AND S.ZBCODE='10301';
    COMMIT;
    
    --货源地不一致
    INSERT INTO CKTS_YJRZ_LCSLID(TSSWJG_DM_1,DJXH,SSQ,SBPC,LCSWSX_DM,LCSLID,ZBCODE)
         VALUES (CUR_LC.TSSWJG_DM_1,CUR_LC.DJXH,CUR_LC.SSQ,CUR_LC.SBPC,CUR_LC.LCSWSX_DM,CUR_LC.LCSLID,'10401');
    COMMIT;
    UPDATE CKTS_YJRZ_LCSLID S
       SET S.YJ_COUNT=(SELECT COUNT(1) FROM (
/*********************************************************************************************************************************/
           WITH
           GLMX AS (
           SELECT A.LCSLID,SUBSTR(A.CKBGDH,1,18) AS YJ_OBJECT,A.GLH AS YJ_RECORD,A.MYLAJ,
                  C.HZDWDQ_DM,D.HZDWDQ_MC,D.XZQH_DM,B.SBXH,B.JSJE,B.TSE,B.GHFNSRSBH_1,
                  CASE WHEN DJ.ZGSWJ_DM IS NOT NULL AND SUBSTR(DJ.ZGSWJ_DM,2,LENGTH(D.XZQH_DM))=D.XZQH_DM THEN 0
                       WHEN LENGTH(B.GHFNSRSBH_1)=18 AND SUBSTR(B.GHFNSRSBH_1,5,2)='00' AND SUBSTR(B.GHFNSRSBH_1,3,2)=SUBSTR(D.XZQH_DM,1,2) THEN 0
                       WHEN LENGTH(B.GHFNSRSBH_1)=18 AND SUBSTR(B.GHFNSRSBH_1,5,2)<>'00' AND SUBSTR(B.GHFNSRSBH_1,3,LENGTH(D.XZQH_DM))=D.XZQH_DM THEN 0
                       WHEN LENGTH(B.GHFNSRSBH_1)>=15 AND LENGTH(B.GHFNSRSBH_1)<>18 AND SUBSTR(B.GHFNSRSBH_1,1,LENGTH(D.XZQH_DM))=D.XZQH_DM THEN 0
                       ELSE 1 END AS HYDYZ
             FROM HX_CKTS.CKTS_SB_MTS_TSSB_GCB A
            INNER JOIN HX_CKTS.CKTS_WBSJ_HG_BGD201 C ON C.DJXH=A.DJXH AND C.CKBGDH=A.CKBGDH
            INNER JOIN FXGL_DM_HZDWDQ D ON D.HZDWDQ_DM=C.HZDWDQ_DM
            INNER JOIN HX_CKTS.CKTS_SB_MTS_TSJH_GCB B ON A.DJXH=B.DJXH AND A.GLH=B.GLH
             LEFT JOIN HX_DJ.DJ_NSRXX DJ ON COALESCE(DJ.SHXYDM,DJ.NSRSBH)=B.GHFNSRSBH_1 AND DJ.KZZTDJLX_DM='1110'
            WHERE A.LCSLID=CUR_LC.LCSLID --#{LCSLID}
              AND A.CKBGDH IS NOT NULL
            UNION ALL
           SELECT A.LCSLID,SUBSTR(A.DLZMH,1,18) AS YJ_OBJECT,A.GLH AS YJ_RECORD,A.MYLAJ,
                  C.JNHYD_DM AS HZDWDQ_DM,D.HZDWDQ_MC,D.XZQH_DM,B.SBXH,B.JSJE,B.TSE,B.GHFNSRSBH_1,
                  CASE WHEN DJ.ZGSWJ_DM IS NOT NULL AND SUBSTR(DJ.ZGSWJ_DM,2,LENGTH(D.XZQH_DM))=D.XZQH_DM THEN 0
                       WHEN LENGTH(B.GHFNSRSBH_1)=18 AND SUBSTR(B.GHFNSRSBH_1,5,2)='00' AND SUBSTR(B.GHFNSRSBH_1,3,2)=SUBSTR(D.XZQH_DM,1,2) THEN 0
                       WHEN LENGTH(B.GHFNSRSBH_1)=18 AND SUBSTR(B.GHFNSRSBH_1,5,2)<>'00' AND SUBSTR(B.GHFNSRSBH_1,3,LENGTH(D.XZQH_DM))=D.XZQH_DM THEN 0
                       WHEN LENGTH(B.GHFNSRSBH_1)>=15 AND LENGTH(B.GHFNSRSBH_1)<>18 AND SUBSTR(B.GHFNSRSBH_1,1,LENGTH(D.XZQH_DM))=D.XZQH_DM THEN 0
                       ELSE 1 END AS HYDYZ
             FROM HX_CKTS.CKTS_SB_MTS_TSSB_GCB A
            INNER JOIN HX_CKTS.CKTS_WBSJ_ZJ_DLCKHWZM C ON C.DJXH=A.DJXH AND C.TSSWJG_DM_1=A.TSSWJG_DM_1 AND C.DLCKHWZMHM=A.DLZMH
            INNER JOIN FXGL_DM_HZDWDQ D ON D.HZDWDQ_DM=C.JNHYD_DM
            INNER JOIN HX_CKTS.CKTS_SB_MTS_TSJH_GCB B ON A.DJXH=B.DJXH AND A.GLH=B.GLH
             LEFT JOIN HX_DJ.DJ_NSRXX DJ ON COALESCE(DJ.SHXYDM,DJ.NSRSBH)=B.GHFNSRSBH_1 AND DJ.KZZTDJLX_DM='1110'
            WHERE A.LCSLID=CUR_LC.LCSLID --#{LCSLID}
              AND A.CKBGDH IS NULL
           ),
           BYZMX AS (
           SELECT LCSLID,YJ_OBJECT,YJ_RECORD,MYLAJ,HZDWDQ_DM,HZDWDQ_MC,XZQH_DM,SBXH,JSJE,TSE,GHFNSRSBH_1,
                  ROW_NUMBER() OVER (PARTITION BY YJ_RECORD ORDER BY JSJE DESC) AS JSMYBZ,
                  ROW_NUMBER() OVER (PARTITION BY YJ_OBJECT ORDER BY JSJE DESC) AS XSYJBZ
             FROM GLMX T
            WHERE HYDYZ=1
              AND NOT EXISTS (SELECT 1 FROM GLMX S WHERE S.YJ_OBJECT=T.YJ_OBJECT AND S.HYDYZ=0)
           ),
           BYZTJ AS (
           SELECT YJ_OBJECT,COUNT(1) AS YJ_COUNT,SUM(CASE WHEN JSMYBZ=1 THEN MYLAJ ELSE 0 END) AS YJ_USD,SUM(JSJE) AS YJ_AMT,SUM(TSE) AS YJ_TAX
             FROM BYZMX
            GROUP BY YJ_OBJECT
            HAVING SUM(TSE)>1 --#{PVAL1}
           )
           SELECT BYZMX.LCSLID,BYZMX.YJ_OBJECT,BYZMX.YJ_RECORD,BYZTJ.YJ_COUNT,BYZTJ.YJ_USD,BYZTJ.YJ_AMT,BYZTJ.YJ_TAX,
                  BYZMX.HZDWDQ_DM,BYZMX.HZDWDQ_MC,BYZMX.XZQH_DM,BYZMX.GHFNSRSBH_1
             FROM BYZMX
            INNER JOIN BYZTJ ON BYZTJ.YJ_OBJECT=BYZMX.YJ_OBJECT
            WHERE BYZMX.XSYJBZ=1
/**/
                      ))
     WHERE S.LCSLID=CUR_LC.LCSLID AND S.ZBCODE='10401';
    COMMIT;
    UPDATE CKTS_YJRZ_LCSLID S
       SET S.END_TIME=SYSDATE
     WHERE S.LCSLID=CUR_LC.LCSLID AND S.ZBCODE='10401';
    COMMIT;
    
    --商品名称不一致
    INSERT INTO CKTS_YJRZ_LCSLID(TSSWJG_DM_1,DJXH,SSQ,SBPC,LCSWSX_DM,LCSLID,ZBCODE)
         VALUES (CUR_LC.TSSWJG_DM_1,CUR_LC.DJXH,CUR_LC.SSQ,CUR_LC.SBPC,CUR_LC.LCSWSX_DM,CUR_LC.LCSLID,'10501');
    COMMIT;
    UPDATE CKTS_YJRZ_LCSLID S
       SET S.YJ_COUNT=(SELECT COUNT(1) FROM (
/*********************************************************************************************************************************/
           WITH
           GLMX AS (
           SELECT A.LCSLID,A.CKSP_DM AS YJ_OBJECT,A.GLH AS YJ_RECORD,A.MYLAJ,B.SBXH,B.JSJE,B.TSE,
                  C.GFHHGSPMC,D.GFHHWHYSLWMC,
                  CASE WHEN C.GFHHGSPMC=D.GFHHWHYSLWMC THEN 0 ELSE 1 END AS SPMCYZ
             FROM HX_CKTS.CKTS_SB_MTS_TSSB_GCB A
            INNER JOIN HX_CKTS.CKTS_SB_MTS_TSJH_GCB B ON A.DJXH=B.DJXH AND A.GLH=B.GLH
            INNER JOIN HX_CKTS.CKTS_WBSJ_HG_BGD201 C ON C.DJXH=A.DJXH AND C.CKBGDH=A.CKBGDH
            INNER JOIN HX_CKTS.CKTS_WBSJ_FP_ZZSFPHWXX D ON D.DJXH=A.DJXH AND D.JHPZH=B.JHPZH
            WHERE A.LCSLID=CUR_LC.LCSLID --#{LCSLID}
              AND A.CKBGDH IS NOT NULL
            UNION ALL
           SELECT A.LCSLID,A.CKSP_DM AS YJ_OBJECT,A.GLH AS YJ_RECORD,A.MYLAJ,B.SBXH,B.JSJE,B.TSE,
                  C.GFHHGSPMC,D.GFHHWHYSLWMC,
                  CASE WHEN C.GFHHGSPMC=D.GFHHWHYSLWMC THEN 0 ELSE 1 END AS SPMCYZ
             FROM HX_CKTS.CKTS_SB_MTS_TSSB_GCB A
            INNER JOIN HX_CKTS.CKTS_SB_MTS_TSJH_GCB B ON A.DJXH=B.DJXH AND A.GLH=B.GLH
            INNER JOIN HX_CKTS.CKTS_WBSJ_ZJ_DLCKHWZM C ON C.DJXH=A.DJXH AND C.TSSWJG_DM_1=A.TSSWJG_DM_1 AND C.DLCKHWZMHM=A.DLZMH
            INNER JOIN HX_CKTS.CKTS_WBSJ_FP_ZZSFPHWXX D ON D.DJXH=A.DJXH AND D.JHPZH=B.JHPZH
            WHERE A.LCSLID=CUR_LC.LCSLID --#{LCSLID}
              AND A.CKBGDH IS NULL
           ),
           BYZMX AS (
           SELECT LCSLID,YJ_OBJECT,YJ_RECORD,MYLAJ,SBXH,JSJE,TSE,GFHHGSPMC,GFHHWHYSLWMC,
                  ROW_NUMBER() OVER (PARTITION BY YJ_RECORD ORDER BY JSJE DESC) AS JSMYBZ,
                  ROW_NUMBER() OVER (PARTITION BY SBXH ORDER BY JSJE DESC) AS JSSEBZ
             FROM GLMX T
            WHERE SPMCYZ=1
              AND NOT EXISTS (SELECT 1 FROM GLMX S WHERE S.YJ_RECORD=T.YJ_RECORD AND S.SPMCYZ=0)
           ),
           BYZTJ AS (
           SELECT YJ_RECORD,1 AS YJ_COUNT,
                  SUM(CASE WHEN JSMYBZ=1 THEN MYLAJ ELSE 0 END) AS YJ_USD,
                  SUM(CASE WHEN JSSEBZ=1 THEN JSJE ELSE 0 END) AS YJ_AMT,
                  SUM(CASE WHEN JSSEBZ=1 THEN TSE ELSE 0 END) AS YJ_TAX
             FROM BYZMX
            GROUP BY YJ_RECORD
            HAVING SUM(TSE)>1 --#{PVAL1}
           )
           SELECT BYZMX.LCSLID,BYZMX.YJ_OBJECT,BYZMX.YJ_RECORD,BYZTJ.YJ_COUNT,BYZTJ.YJ_USD,BYZTJ.YJ_AMT,BYZTJ.YJ_TAX,
                  BYZMX.SBXH,BYZMX.GFHHGSPMC,BYZMX.GFHHWHYSLWMC
             FROM BYZMX
            INNER JOIN BYZTJ ON BYZTJ.YJ_RECORD=BYZMX.YJ_RECORD
            WHERE BYZMX.JSMYBZ=1
/**/
                      ))
     WHERE S.LCSLID=CUR_LC.LCSLID AND S.ZBCODE='10501';
    COMMIT;
    UPDATE CKTS_YJRZ_LCSLID S
       SET S.END_TIME=SYSDATE
     WHERE S.LCSLID=CUR_LC.LCSLID AND S.ZBCODE='10501';
    COMMIT;
  END LOOP;

END;
/


prompt Done
spool off
set define on
