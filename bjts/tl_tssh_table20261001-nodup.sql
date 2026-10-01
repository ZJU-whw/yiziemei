prompt
prompt Creating table ATFX_CK_JG_ACJFSTJ
prompt =================================
prompt
create table ATFX_CK_JG_ACJFSTJ
(
  djxh      NUMBER(20) not null,
  ckny      VARCHAR2(6) not null,
  hgcjfs_dm VARCHAR2(1) not null,
  hgcjfsmc  VARCHAR2(100),
  bgdfs     NUMBER(10),
  hwmxts    NUMBER(10),
  mylaj     NUMBER(20,2),
  rmblaj    NUMBER(20,2)
)
;
comment on table ATFX_CK_JG_ACJFSTJ
  is '按成交方式统计数据';
comment on column ATFX_CK_JG_ACJFSTJ.djxh
  is '登记序号';
comment on column ATFX_CK_JG_ACJFSTJ.ckny
  is '出口年月';
comment on column ATFX_CK_JG_ACJFSTJ.hgcjfs_dm
  is '海关成交方式代码';
comment on column ATFX_CK_JG_ACJFSTJ.hgcjfsmc
  is '海关成交方式名称';
comment on column ATFX_CK_JG_ACJFSTJ.bgdfs
  is '报关单份数';
comment on column ATFX_CK_JG_ACJFSTJ.hwmxts
  is '货物明细条数';
comment on column ATFX_CK_JG_ACJFSTJ.mylaj
  is '美元离岸价';
comment on column ATFX_CK_JG_ACJFSTJ.rmblaj
  is '人民币离岸价';
alter table ATFX_CK_JG_ACJFSTJ
  add constraint PK_ATFX_CK_JG_ACJFSTJ primary key (DJXH, CKNY, HGCJFS_DM);

prompt
prompt Creating table ATFX_CK_JG_ACKKATJ
prompt =================================
prompt
create table ATFX_CK_JG_ACKKATJ
(
  djxh      NUMBER(20) not null,
  ckny      VARCHAR2(6) not null,
  hggqka_dm VARCHAR2(4) not null,
  hggqkamc  VARCHAR2(100),
  bgdfs     NUMBER(10),
  hwmxts    NUMBER(10),
  mylaj     NUMBER(20,2),
  rmblaj    NUMBER(20,2),
  ysfs_jh   VARCHAR2(100)
)
;
comment on table ATFX_CK_JG_ACKKATJ
  is '按出口口岸统计数据';
comment on column ATFX_CK_JG_ACKKATJ.djxh
  is '登记序号';
comment on column ATFX_CK_JG_ACKKATJ.ckny
  is '出口年月';
comment on column ATFX_CK_JG_ACKKATJ.hggqka_dm
  is '海关关区（口岸）代码';
comment on column ATFX_CK_JG_ACKKATJ.hggqkamc
  is '海关关区（口岸）名称';
comment on column ATFX_CK_JG_ACKKATJ.bgdfs
  is '报关单份数';
comment on column ATFX_CK_JG_ACKKATJ.hwmxts
  is '货物明细条数';
comment on column ATFX_CK_JG_ACKKATJ.mylaj
  is '美元离岸价';
comment on column ATFX_CK_JG_ACKKATJ.rmblaj
  is '人民币离岸价';
comment on column ATFX_CK_JG_ACKKATJ.ysfs_jh
  is '当前口岸对应运输方式代码集合';
alter table ATFX_CK_JG_ACKKATJ
  add constraint PK_ATFX_CK_JG_ACKKATJ primary key (DJXH, CKNY, HGGQKA_DM);

prompt
prompt Creating table ATFX_CK_JG_ACKSPTJ
prompt =================================
prompt
create table ATFX_CK_JG_ACKSPTJ
(
  djxh    NUMBER(20) not null,
  ckny    VARCHAR2(6) not null,
  cksp_dm VARCHAR2(20) not null,
  ckspmc  VARCHAR2(200),
  bgdfs   NUMBER(10),
  hwmxts  NUMBER(10),
  mylaj   NUMBER(20,2),
  rmblaj  NUMBER(20,2)
)
;
comment on table ATFX_CK_JG_ACKSPTJ
  is '按出口商品统计数据';
comment on column ATFX_CK_JG_ACKSPTJ.djxh
  is '登记序号';
comment on column ATFX_CK_JG_ACKSPTJ.ckny
  is '出口年月';
comment on column ATFX_CK_JG_ACKSPTJ.cksp_dm
  is '出口商品代码';
comment on column ATFX_CK_JG_ACKSPTJ.ckspmc
  is '出口商品名称';
comment on column ATFX_CK_JG_ACKSPTJ.bgdfs
  is '报关单份数';
comment on column ATFX_CK_JG_ACKSPTJ.hwmxts
  is '货物明细条数';
comment on column ATFX_CK_JG_ACKSPTJ.mylaj
  is '美元离岸价';
comment on column ATFX_CK_JG_ACKSPTJ.rmblaj
  is '人民币离岸价';
alter table ATFX_CK_JG_ACKSPTJ
  add constraint PK_ATFX_CK_JG_ACKSPTJ primary key (DJXH, CKNY, CKSP_DM);

prompt
prompt Creating table ATFX_CK_JG_AHYDTJ
prompt ================================
prompt
create table ATFX_CK_JG_AHYDTJ
(
  djxh      NUMBER(20) not null,
  ckny      VARCHAR2(6) not null,
  hzdwdq_dm VARCHAR2(5) not null,
  hzdwdqmc  VARCHAR2(100),
  bgdfs     NUMBER(10),
  hwmxts    NUMBER(10),
  mylaj     NUMBER(20,2),
  rmblaj    NUMBER(20,2)
)
;
comment on table ATFX_CK_JG_AHYDTJ
  is '按货源地统计数据';
comment on column ATFX_CK_JG_AHYDTJ.djxh
  is '登记序号';
comment on column ATFX_CK_JG_AHYDTJ.ckny
  is '出口年月';
comment on column ATFX_CK_JG_AHYDTJ.hzdwdq_dm
  is '货源地代码';
comment on column ATFX_CK_JG_AHYDTJ.hzdwdqmc
  is '货源地名称';
comment on column ATFX_CK_JG_AHYDTJ.bgdfs
  is '报关单份数';
comment on column ATFX_CK_JG_AHYDTJ.hwmxts
  is '货物明细条数';
comment on column ATFX_CK_JG_AHYDTJ.mylaj
  is '美元离岸价';
comment on column ATFX_CK_JG_AHYDTJ.rmblaj
  is '人民币离岸价';
alter table ATFX_CK_JG_AHYDTJ
  add constraint PK_ATFX_CK_JG_AHYDTJ primary key (DJXH, CKNY, HZDWDQ_DM);

prompt
prompt Creating table ATFX_CK_JG_AJGFSTJ
prompt =================================
prompt
create table ATFX_CK_JG_AJGFSTJ
(
  djxh    NUMBER(20) not null,
  ckny    VARCHAR2(6) not null,
  jgfs_dm VARCHAR2(4) not null,
  jgfsmc  VARCHAR2(100),
  bgdfs   NUMBER(10),
  hwmxts  NUMBER(10),
  mylaj   NUMBER(20,2),
  rmblaj  NUMBER(20,2)
)
;
comment on table ATFX_CK_JG_AJGFSTJ
  is '按监管方式统计数据';
comment on column ATFX_CK_JG_AJGFSTJ.djxh
  is '登记序号';
comment on column ATFX_CK_JG_AJGFSTJ.ckny
  is '出口年月';
comment on column ATFX_CK_JG_AJGFSTJ.jgfs_dm
  is '监管方式代码';
comment on column ATFX_CK_JG_AJGFSTJ.jgfsmc
  is '监管方式名称';
comment on column ATFX_CK_JG_AJGFSTJ.bgdfs
  is '报关单份数';
comment on column ATFX_CK_JG_AJGFSTJ.hwmxts
  is '货物明细条数';
comment on column ATFX_CK_JG_AJGFSTJ.mylaj
  is '美元离岸价';
comment on column ATFX_CK_JG_AJGFSTJ.rmblaj
  is '人民币离岸价';
alter table ATFX_CK_JG_AJGFSTJ
  add constraint PK_ATFX_CK_JG_AJGFSTJ primary key (DJXH, CKNY, JGFS_DM);

prompt
prompt Creating table ATFX_CK_JG_AKHTJ
prompt ===============================
prompt
create table ATFX_CK_JG_AKHTJ
(
  djxh    NUMBER(20) not null,
  ckny    VARCHAR2(6) not null,
  jwkh_mc VARCHAR2(200) not null,
  bgdfs   NUMBER(10),
  hwmxts  NUMBER(10),
  mylaj   NUMBER(20,2),
  rmblaj  NUMBER(20,2)
)
;
comment on table ATFX_CK_JG_AKHTJ
  is '按出口客户统计数据';
comment on column ATFX_CK_JG_AKHTJ.djxh
  is '登记序号';
comment on column ATFX_CK_JG_AKHTJ.ckny
  is '出口年月';
comment on column ATFX_CK_JG_AKHTJ.jwkh_mc
  is '境外客户名称';
comment on column ATFX_CK_JG_AKHTJ.bgdfs
  is '报关单份数';
comment on column ATFX_CK_JG_AKHTJ.hwmxts
  is '货物明细条数';
comment on column ATFX_CK_JG_AKHTJ.mylaj
  is '美元离岸价';
comment on column ATFX_CK_JG_AKHTJ.rmblaj
  is '人民币离岸价';
alter table ATFX_CK_JG_AKHTJ
  add constraint PK_ATFX_CK_JG_AKHTJ primary key (DJXH, CKNY, JWKH_MC);

prompt
prompt Creating table ATFX_CK_JG_AMDGTJ
prompt ================================
prompt
create table ATFX_CK_JG_AMDGTJ
(
  djxh         NUMBER(20) not null,
  ckny         VARCHAR2(6) not null,
  zzmdgdqsz_dm VARCHAR2(3) not null,
  zzmdgdqmc    VARCHAR2(100),
  bgdfs        NUMBER(10),
  hwmxts       NUMBER(10),
  mylaj        NUMBER(20,2),
  rmblaj       NUMBER(20,2)
)
;
comment on table ATFX_CK_JG_AMDGTJ
  is '按最终目的国统计数据';
comment on column ATFX_CK_JG_AMDGTJ.djxh
  is '登记序号';
comment on column ATFX_CK_JG_AMDGTJ.ckny
  is '出口年月';
comment on column ATFX_CK_JG_AMDGTJ.zzmdgdqsz_dm
  is '最终目的国（地区）数字代码';
comment on column ATFX_CK_JG_AMDGTJ.zzmdgdqmc
  is '最终目的国（地区）名称';
comment on column ATFX_CK_JG_AMDGTJ.bgdfs
  is '报关单份数';
comment on column ATFX_CK_JG_AMDGTJ.hwmxts
  is '货物明细条数';
comment on column ATFX_CK_JG_AMDGTJ.mylaj
  is '美元离岸价';
comment on column ATFX_CK_JG_AMDGTJ.rmblaj
  is '人民币离岸价';
alter table ATFX_CK_JG_AMDGTJ
  add constraint PK_ATFX_CK_JG_AMDGTJ primary key (DJXH, CKNY, ZZMDGDQSZ_DM);

prompt
prompt Creating table ATFX_CK_JG_AMYGTJ
prompt ================================
prompt
create table ATFX_CK_JG_AMYGTJ
(
  djxh       NUMBER(20) not null,
  ckny       VARCHAR2(6) not null,
  mygdqsz_dm VARCHAR2(3) not null,
  mygdqmc    VARCHAR2(100),
  bgdfs      NUMBER(10),
  hwmxts     NUMBER(10),
  mylaj      NUMBER(20,2),
  rmblaj     NUMBER(20,2)
)
;
comment on table ATFX_CK_JG_AMYGTJ
  is '按贸易国统计数据';
comment on column ATFX_CK_JG_AMYGTJ.djxh
  is '登记序号';
comment on column ATFX_CK_JG_AMYGTJ.ckny
  is '出口年月';
comment on column ATFX_CK_JG_AMYGTJ.mygdqsz_dm
  is '贸易国（地区）数字代码';
comment on column ATFX_CK_JG_AMYGTJ.mygdqmc
  is '贸易国（地区）名称';
comment on column ATFX_CK_JG_AMYGTJ.bgdfs
  is '报关单份数';
comment on column ATFX_CK_JG_AMYGTJ.hwmxts
  is '货物明细条数';
comment on column ATFX_CK_JG_AMYGTJ.mylaj
  is '美元离岸价';
comment on column ATFX_CK_JG_AMYGTJ.rmblaj
  is '人民币离岸价';
alter table ATFX_CK_JG_AMYGTJ
  add constraint PK_ATFX_CK_JG_AMYGTJ primary key (DJXH, CKNY, MYGDQSZ_DM);

prompt
prompt Creating table ATFX_CK_JG_ANYTJ
prompt ===============================
prompt
create table ATFX_CK_JG_ANYTJ
(
  djxh   NUMBER(20) not null,
  ckny   VARCHAR2(6) not null,
  bgdfs  NUMBER(10),
  hwmxts NUMBER(10),
  mylaj  NUMBER(20,2),
  rmblaj NUMBER(20,2)
)
;
comment on table ATFX_CK_JG_ANYTJ
  is '按年月统计出口数据';
comment on column ATFX_CK_JG_ANYTJ.djxh
  is '登记序号';
comment on column ATFX_CK_JG_ANYTJ.ckny
  is '出口年月';
comment on column ATFX_CK_JG_ANYTJ.bgdfs
  is '报关单份数';
comment on column ATFX_CK_JG_ANYTJ.hwmxts
  is '货物明细条数';
comment on column ATFX_CK_JG_ANYTJ.mylaj
  is '美元离岸价';
comment on column ATFX_CK_JG_ANYTJ.rmblaj
  is '人民币离岸价';
alter table ATFX_CK_JG_ANYTJ
  add constraint PK_ATFX_CK_JG_ANYTJ primary key (DJXH, CKNY);

prompt
prompt Creating table ATFX_CK_JG_AYSFSTJ
prompt =================================
prompt
create table ATFX_CK_JG_AYSFSTJ
(
  djxh    NUMBER(20) not null,
  ckny    VARCHAR2(6) not null,
  ysfs_dm VARCHAR2(2) not null,
  ysfsmc  VARCHAR2(100),
  bgdfs   NUMBER(10),
  hwmxts  NUMBER(10),
  mylaj   NUMBER(20,2),
  rmblaj  NUMBER(20,2)
)
;
comment on table ATFX_CK_JG_AYSFSTJ
  is '按运输方式统计数据';
comment on column ATFX_CK_JG_AYSFSTJ.djxh
  is '登记序号';
comment on column ATFX_CK_JG_AYSFSTJ.ckny
  is '出口年月';
comment on column ATFX_CK_JG_AYSFSTJ.ysfs_dm
  is '运输方式代码';
comment on column ATFX_CK_JG_AYSFSTJ.ysfsmc
  is '运输方式名称';
comment on column ATFX_CK_JG_AYSFSTJ.bgdfs
  is '报关单份数';
comment on column ATFX_CK_JG_AYSFSTJ.hwmxts
  is '货物明细条数';
comment on column ATFX_CK_JG_AYSFSTJ.mylaj
  is '美元离岸价';
comment on column ATFX_CK_JG_AYSFSTJ.rmblaj
  is '人民币离岸价';
alter table ATFX_CK_JG_AYSFSTJ
  add constraint PK_ATFX_CK_JG_AYSFSTJ primary key (DJXH, CKNY, YSFS_DM);

prompt
prompt Creating table ATFX_CK_YS_CKDZXX
prompt ================================
prompt
create table ATFX_CK_YS_CKDZXX
(
  uuid          VARCHAR2(32) not null,
  djxh          NUMBER(20) not null,
  ydjxh         NUMBER(20),
  ckbgdh        VARCHAR2(21) not null,
  dlckhwzmhm    VARCHAR2(20),
  hgckhwbgdsbrq DATE,
  ckrq_1        DATE,
  ckny          VARCHAR2(6),
  cksp_dm       VARCHAR2(20) not null,
  gfhhgspmc     VARCHAR2(500),
  ggxh          VARCHAR2(150),
  dyjldw_dm     VARCHAR2(3),
  hgjldwmc      VARCHAR2(75),
  cksl          NUMBER(18,6),
  dejldw_dm     VARCHAR2(3),
  decksl        NUMBER(18,6),
  sbjldw_dm     VARCHAR2(3),
  sbsl_1        NUMBER(18,6),
  cjhghbsz_dm   VARCHAR2(3),
  cjzj          NUMBER(18,2),
  yfjsfs_dm     CHAR(1),
  yfhghbsz_dm   CHAR(3),
  yfhl          NUMBER(16,6),
  bfjsfs_dm     CHAR(1),
  bfhghbsz_dm   CHAR(3),
  bfhl          NUMBER(16,6),
  zfjsfs_dm     CHAR(1),
  zfhghbsz_dm   CHAR(3),
  zfhl          NUMBER(16,6),
  rmblaj        NUMBER(18,2),
  mylaj         NUMBER(18,2),
  mygdqsz_dm    VARCHAR2(3),
  zzmdgdqsz_dm  VARCHAR2(3),
  hggqka_dm     VARCHAR2(4),
  jgfs_dm       VARCHAR2(4),
  hgcjfs_dm     VARCHAR2(1),
  jhfs_dm       VARCHAR2(1),
  zyg_dm        VARCHAR2(6),
  ysfs_dm       VARCHAR2(1),
  ysgjmc        VARCHAR2(100),
  hch           VARCHAR2(32),
  js_1          NUMBER(10),
  jz            NUMBER(18,3),
  mz_2          NUMBER(18,3),
  qygbz         VARCHAR2(1),
  jydwmc        VARCHAR2(200),
  hzdwdm        VARCHAR2(20),
  hzdwmc        VARCHAR2(200),
  hzdwdq_dm     VARCHAR2(5),
  sbdwdm        VARCHAR2(20),
  sbdwmc        VARCHAR2(200),
  tydh          VARCHAR2(32),
  ckhth         VARCHAR2(60),
  bah           VARCHAR2(20),
  sjlx          VARCHAR2(20),
  jzqks         NUMBER(18,6),
  ckfphm        VARCHAR2(30),
  jwshr         VARCHAR2(200),
  bjmmjbz       VARCHAR2(500),
  jzxh          VARCHAR2(2000),
  cytssbjl      VARCHAR2(60),
  tssbmylaj     NUMBER(18,2),
  tssbrmblaj    NUMBER(18,2),
  tssbsl        NUMBER(18,6),
  bytsbz        VARCHAR2(1),
  tymylaj       NUMBER(18,2),
  tyrmblaj      NUMBER(18,2),
  tysl          NUMBER(18,6),
  dlsbmylaj     NUMBER(18,2),
  dlsbrmblaj    NUMBER(18,2),
  dlsbsl        NUMBER(18,6)
)
;
comment on table ATFX_CK_YS_CKDZXX
  is '出口业务电子信息表';
comment on column ATFX_CK_YS_CKDZXX.uuid
  is 'UUID，主键';
comment on column ATFX_CK_YS_CKDZXX.djxh
  is '登记序号';
comment on column ATFX_CK_YS_CKDZXX.ydjxh
  is '原登记序号（提取已委托代办退税的报关单时需要，其它类型为Null）';
comment on column ATFX_CK_YS_CKDZXX.ckbgdh
  is '出口报关单号';
comment on column ATFX_CK_YS_CKDZXX.dlckhwzmhm
  is '代理出口货物证明号码';
comment on column ATFX_CK_YS_CKDZXX.hgckhwbgdsbrq
  is '海关出口货物报关单申报日期';
comment on column ATFX_CK_YS_CKDZXX.ckrq_1
  is '出口日期';
comment on column ATFX_CK_YS_CKDZXX.ckny
  is '出口年月（代理证明出口年月需通过出口日期转换）';
comment on column ATFX_CK_YS_CKDZXX.cksp_dm
  is '出口商品代码';
comment on column ATFX_CK_YS_CKDZXX.gfhhgspmc
  is '规范化海关商品名称';
comment on column ATFX_CK_YS_CKDZXX.ggxh
  is '规格型号';
comment on column ATFX_CK_YS_CKDZXX.dyjldw_dm
  is '第一计量单位代码';
comment on column ATFX_CK_YS_CKDZXX.hgjldwmc
  is '海关计量单位名称';
comment on column ATFX_CK_YS_CKDZXX.cksl
  is '出口数量';
comment on column ATFX_CK_YS_CKDZXX.dejldw_dm
  is '第二计量单位代码';
comment on column ATFX_CK_YS_CKDZXX.decksl
  is '第二出口数量';
comment on column ATFX_CK_YS_CKDZXX.sbjldw_dm
  is '申报计量单位代码';
comment on column ATFX_CK_YS_CKDZXX.sbsl_1
  is '申报数量';
comment on column ATFX_CK_YS_CKDZXX.cjhghbsz_dm
  is '成交海关货币数字代码';
comment on column ATFX_CK_YS_CKDZXX.cjzj
  is '成交总价';
comment on column ATFX_CK_YS_CKDZXX.yfjsfs_dm
  is '运费计算方式代码';
comment on column ATFX_CK_YS_CKDZXX.yfhghbsz_dm
  is '运费海关货币数字代码';
comment on column ATFX_CK_YS_CKDZXX.yfhl
  is '运费汇率';
comment on column ATFX_CK_YS_CKDZXX.bfjsfs_dm
  is '保费计算方式代码';
comment on column ATFX_CK_YS_CKDZXX.bfhghbsz_dm
  is '保费海关货币数字代码';
comment on column ATFX_CK_YS_CKDZXX.bfhl
  is '保费汇率';
comment on column ATFX_CK_YS_CKDZXX.zfjsfs_dm
  is '杂费计算方式代码';
comment on column ATFX_CK_YS_CKDZXX.zfhghbsz_dm
  is '杂费海关货币数字代码';
comment on column ATFX_CK_YS_CKDZXX.zfhl
  is '杂费汇率';
comment on column ATFX_CK_YS_CKDZXX.rmblaj
  is '人民币离岸价';
comment on column ATFX_CK_YS_CKDZXX.mylaj
  is '美元离岸价';
comment on column ATFX_CK_YS_CKDZXX.mygdqsz_dm
  is '贸易国（地区）数字代码';
comment on column ATFX_CK_YS_CKDZXX.zzmdgdqsz_dm
  is '最终目的国（地区）数字代码';
comment on column ATFX_CK_YS_CKDZXX.hggqka_dm
  is '海关关区（口岸）代码';
comment on column ATFX_CK_YS_CKDZXX.jgfs_dm
  is '监管方式代码';
comment on column ATFX_CK_YS_CKDZXX.hgcjfs_dm
  is '海关成交方式代码';
comment on column ATFX_CK_YS_CKDZXX.jhfs_dm
  is '结汇方式代码';
comment on column ATFX_CK_YS_CKDZXX.zyg_dm
  is '指运港代码';
comment on column ATFX_CK_YS_CKDZXX.ysfs_dm
  is '运输方式代码';
comment on column ATFX_CK_YS_CKDZXX.ysgjmc
  is '运输工具名称';
comment on column ATFX_CK_YS_CKDZXX.hch
  is '航次号';
comment on column ATFX_CK_YS_CKDZXX.js_1
  is '件数';
comment on column ATFX_CK_YS_CKDZXX.jz
  is '净重';
comment on column ATFX_CK_YS_CKDZXX.mz_2
  is '毛重';
comment on column ATFX_CK_YS_CKDZXX.qygbz
  is '启运港标志（代理证明没有启运港标志，默认为null）';
comment on column ATFX_CK_YS_CKDZXX.jydwmc
  is '经营单位名称';
comment on column ATFX_CK_YS_CKDZXX.hzdwdm
  is '货主单位代码';
comment on column ATFX_CK_YS_CKDZXX.hzdwmc
  is '货主单位名称';
comment on column ATFX_CK_YS_CKDZXX.hzdwdq_dm
  is '货主单位地区代码（代理证明用境内货源地代码）';
comment on column ATFX_CK_YS_CKDZXX.sbdwdm
  is '申报单位代码';
comment on column ATFX_CK_YS_CKDZXX.sbdwmc
  is '申报单位名称';
comment on column ATFX_CK_YS_CKDZXX.tydh
  is '提运单号';
comment on column ATFX_CK_YS_CKDZXX.ckhth
  is '出口合同号';
comment on column ATFX_CK_YS_CKDZXX.bah
  is '备案号';
comment on column ATFX_CK_YS_CKDZXX.sjlx
  is '数据类型（加工数据：自行出口、代理出口、代办退税）';
comment on column ATFX_CK_YS_CKDZXX.jzqks
  is '净重千克数（根据报关单第一、第二、成交单位，取其中重量单位并将对应出口数量转换为千克，用于后期统一计算重量单价）';
comment on column ATFX_CK_YS_CKDZXX.ckfphm
  is '出口发票号码（通过企业退税申报出口明细获取）';
comment on column ATFX_CK_YS_CKDZXX.jwshr
  is '境外收货人（通过出口发票号码，从出口发票数据提取国外客户名称写入）';
comment on column ATFX_CK_YS_CKDZXX.bjmmjbz
  is '标记唛码及备注（按18位报关单号从BGD204表中提取第一条数据写入）';
comment on column ATFX_CK_YS_CKDZXX.jzxh
  is '集装箱号（按18位报关单号从BGD204表获取所有记录拼接）';
comment on column ATFX_CK_YS_CKDZXX.cytssbjl
  is '参与退税申报记录';
comment on column ATFX_CK_YS_CKDZXX.tssbmylaj
  is '退税申报美元离岸价';
comment on column ATFX_CK_YS_CKDZXX.tssbrmblaj
  is '退税申报人民币离岸价';
comment on column ATFX_CK_YS_CKDZXX.tssbsl
  is '退税申报数量';
comment on column ATFX_CK_YS_CKDZXX.bytsbz
  is '不予退税标志';
comment on column ATFX_CK_YS_CKDZXX.tymylaj
  is '退运美元离岸价';
comment on column ATFX_CK_YS_CKDZXX.tyrmblaj
  is '退运人民币离岸价';
comment on column ATFX_CK_YS_CKDZXX.tysl
  is '退运数量';
comment on column ATFX_CK_YS_CKDZXX.dlsbmylaj
  is '代理申报美元离岸价（数据源为代理证明时为Null）';
comment on column ATFX_CK_YS_CKDZXX.dlsbrmblaj
  is '代理申报人民币离岸价（数据源为代理证明时为null）';
comment on column ATFX_CK_YS_CKDZXX.dlsbsl
  is '代理申报数量（数据源为代理证明时为null）';
create index IDX_ATFX_CK_YS_CKDZXX_DC on ATFX_CK_YS_CKDZXX (DJXH, CKNY);
alter table ATFX_CK_YS_CKDZXX
  add constraint PK_ATFX_CK_YS_CKDZXX primary key (DJXH, CKBGDH);

prompt
prompt Creating table ATFX_CS_SPHFWSSFLYBM
prompt ===================================
prompt
create table ATFX_CS_SPHFWSSFLYBM
(
  sphfwssflbm_p  VARCHAR2(2) not null,
  sphfwssflbm_l  CHAR(2) not null,
  sphfwssflbm_z  CHAR(2) not null,
  sphfwssflbm_j  CHAR(2) not null,
  sphfwssflbm_t  CHAR(2) not null,
  sphfwssflbm_k  CHAR(2) not null,
  sphfwssflbm_x  CHAR(2) not null,
  sphfwssflbm_m  CHAR(2) not null,
  sphfwssflbm_zm CHAR(2) not null,
  sphfwssflbm_xm CHAR(2) not null,
  sphfwssflhbbm  CHAR(19) not null,
  hwhlwmc        VARCHAR2(150) not null,
  sphfwfljc      VARCHAR2(300) not null,
  xybz           CHAR(1) not null,
  yxbz           CHAR(1) not null,
  bz             VARCHAR2(3000)
)
;
comment on table ATFX_CS_SPHFWSSFLYBM
  is '商品和服务税收分类与编码';
comment on column ATFX_CS_SPHFWSSFLYBM.sphfwssflbm_p
  is '商品和服务税收分类编码_篇||取值区间为0到6';
comment on column ATFX_CS_SPHFWSSFLYBM.sphfwssflbm_l
  is '商品和服务税收分类编码_类||取值区间为00到10';
comment on column ATFX_CS_SPHFWSSFLYBM.sphfwssflbm_z
  is '商品和服务税收分类编码_章||取值区间为00到10';
comment on column ATFX_CS_SPHFWSSFLYBM.sphfwssflbm_j
  is '商品和服务税收分类编码_节||取值区间为00到10';
comment on column ATFX_CS_SPHFWSSFLYBM.sphfwssflbm_t
  is '商品和服务税收分类编码_条||取值区间为00到10';
comment on column ATFX_CS_SPHFWSSFLYBM.sphfwssflbm_k
  is '商品和服务税收分类编码_款||取值区间为00到10';
comment on column ATFX_CS_SPHFWSSFLYBM.sphfwssflbm_x
  is '商品和服务税收分类编码_项||取值区间为00到10';
comment on column ATFX_CS_SPHFWSSFLYBM.sphfwssflbm_m
  is '商品和服务税收分类编码_目||取值区间为00到10';
comment on column ATFX_CS_SPHFWSSFLYBM.sphfwssflbm_zm
  is '商品和服务税收分类编码_子目||取值区间为00到10';
comment on column ATFX_CS_SPHFWSSFLYBM.sphfwssflbm_xm
  is '商品和服务税收分类编码_细目||取值区间为00到10';
comment on column ATFX_CS_SPHFWSSFLYBM.sphfwssflhbbm
  is '商品和服务税收分类合并编码';
comment on column ATFX_CS_SPHFWSSFLYBM.hwhlwmc
  is '货物和劳务名称';
comment on column ATFX_CS_SPHFWSSFLYBM.sphfwfljc
  is '商品和服务分类简称';
comment on column ATFX_CS_SPHFWSSFLYBM.xybz
  is '选用标志';
comment on column ATFX_CS_SPHFWSSFLYBM.yxbz
  is '有效标志';
comment on column ATFX_CS_SPHFWSSFLYBM.bz
  is '备注';

prompt
prompt Creating table ATFX_FP_JG_AGYSTJ
prompt ================================
prompt
create table ATFX_FP_JG_AGYSTJ
(
  djxh          NUMBER(20) not null,
  kpny          VARCHAR2(6) not null,
  gyssbh        VARCHAR2(20) not null,
  gysmc         VARCHAR2(200) not null,
  sphfwssflhbbm VARCHAR2(19) not null,
  hwhyslwfwmc   VARCHAR2(200),
  je            NUMBER(20,2),
  se            NUMBER(20,2)
)
;
comment on table ATFX_FP_JG_AGYSTJ
  is '供应商供货统计数据表';
comment on column ATFX_FP_JG_AGYSTJ.djxh
  is '登记序号';
comment on column ATFX_FP_JG_AGYSTJ.kpny
  is '开票年月';
comment on column ATFX_FP_JG_AGYSTJ.gyssbh
  is '供应商识别号';
comment on column ATFX_FP_JG_AGYSTJ.gysmc
  is '供应商名称';
comment on column ATFX_FP_JG_AGYSTJ.sphfwssflhbbm
  is '商品和服务税收分类合并编码';
comment on column ATFX_FP_JG_AGYSTJ.hwhyslwfwmc
  is '货物或应税劳务、服务名称';
comment on column ATFX_FP_JG_AGYSTJ.je
  is '金额';
comment on column ATFX_FP_JG_AGYSTJ.se
  is '税额';
alter table ATFX_FP_JG_AGYSTJ
  add constraint PK_ATFX_FP_JG_AGYSTJ primary key (DJXH, KPNY, GYSSBH, SPHFWSSFLHBBM);

prompt
prompt Creating table ATFX_FP_JG_ANYTJJH
prompt =================================
prompt
create table ATFX_FP_JG_ANYTJJH
(
  djxh  NUMBER(20) not null,
  kpny  VARCHAR2(6) not null,
  je_hw NUMBER(20,2),
  se_hw NUMBER(20,2),
  je_fw NUMBER(20,2),
  se_fw NUMBER(20,2)
)
;
comment on table ATFX_FP_JG_ANYTJJH
  is '按年月统计进货数据表';
comment on column ATFX_FP_JG_ANYTJJH.djxh
  is '登记序号';
comment on column ATFX_FP_JG_ANYTJJH.kpny
  is '开票年月';
comment on column ATFX_FP_JG_ANYTJJH.je_hw
  is '金额(货物)';
comment on column ATFX_FP_JG_ANYTJJH.se_hw
  is '税额(货物)';
comment on column ATFX_FP_JG_ANYTJJH.je_fw
  is '金额(服务)';
comment on column ATFX_FP_JG_ANYTJJH.se_fw
  is '税额(服务)';
create index IDX_ANYTJJH_DJXH on ATFX_FP_JG_ANYTJJH (DJXH);
create index IDX_ANYTJJH_KPNY on ATFX_FP_JG_ANYTJJH (KPNY);
alter table ATFX_FP_JG_ANYTJJH
  add constraint PK_ATFX_FP_JG_ANYTJJH primary key (DJXH, KPNY);

prompt
prompt Creating table ATFX_FP_JG_ANYTJXS
prompt =================================
prompt
create table ATFX_FP_JG_ANYTJXS
(
  djxh  NUMBER(20) not null,
  kpny  VARCHAR2(6) not null,
  je    NUMBER(20,2),
  se    NUMBER(20,2),
  je_nx NUMBER(20,2),
  se_nx NUMBER(20,2),
  je_wx NUMBER(20,2),
  se_wx NUMBER(20,2)
)
;
comment on table ATFX_FP_JG_ANYTJXS
  is '按年月统计销售数据';
comment on column ATFX_FP_JG_ANYTJXS.djxh
  is '登记序号';
comment on column ATFX_FP_JG_ANYTJXS.kpny
  is '开票年月';
comment on column ATFX_FP_JG_ANYTJXS.je
  is '金额';
comment on column ATFX_FP_JG_ANYTJXS.se
  is '税额';
comment on column ATFX_FP_JG_ANYTJXS.je_nx
  is '金额（内销）';
comment on column ATFX_FP_JG_ANYTJXS.se_nx
  is '税额（内销）';
comment on column ATFX_FP_JG_ANYTJXS.je_wx
  is '金额（外销）';
comment on column ATFX_FP_JG_ANYTJXS.se_wx
  is '税额（外销）';
alter table ATFX_FP_JG_ANYTJXS
  add constraint PK_ATFX_FP_JG_ANYTJXS primary key (DJXH, KPNY);

prompt
prompt Creating table ATFX_FP_JG_GYSJCXX
prompt =================================
prompt
create table ATFX_FP_JG_GYSJCXX
(
  djxh          NUMBER(20) not null,
  gyssbh        VARCHAR2(20) not null,
  gysmc         VARCHAR2(200) not null,
  gys_sjswjg_dm VARCHAR2(11),
  gys_dsswjg_dm VARCHAR2(11),
  gys_qxswjg_dm VARCHAR2(11),
  gys_sckprq    DATE,
  gys_sctssbrq  DATE,
  gys_bssckprq  DATE,
  gys_bskphs    NUMBER(10),
  gys_djrq      DATE,
  gys_nsrzt_dm  VARCHAR2(2)
)
;
comment on table ATFX_FP_JG_GYSJCXX
  is '供应商基础信息表';
comment on column ATFX_FP_JG_GYSJCXX.djxh
  is '登记序号';
comment on column ATFX_FP_JG_GYSJCXX.gyssbh
  is '供应商识别号';
comment on column ATFX_FP_JG_GYSJCXX.gysmc
  is '供应商名称';
comment on column ATFX_FP_JG_GYSJCXX.gys_sjswjg_dm
  is '供应商省局代码';
comment on column ATFX_FP_JG_GYSJCXX.gys_dsswjg_dm
  is '供应商地市局代码';
comment on column ATFX_FP_JG_GYSJCXX.gys_qxswjg_dm
  is '供应商区县局代码';
comment on column ATFX_FP_JG_GYSJCXX.gys_sckprq
  is '供应商给本企业首次开票日期';
comment on column ATFX_FP_JG_GYSJCXX.gys_sctssbrq
  is '供应商给本企业首次退税申报日期（从免退税进货明细、代办退税明细统计）';
comment on column ATFX_FP_JG_GYSJCXX.gys_bssckprq
  is '供应商给本省企业最早开票日期';
comment on column ATFX_FP_JG_GYSJCXX.gys_bskphs
  is '供应商在本省开票户数';
comment on column ATFX_FP_JG_GYSJCXX.gys_djrq
  is '供应商登记日期（仅限省内供货企业）';
comment on column ATFX_FP_JG_GYSJCXX.gys_nsrzt_dm
  is '供应商纳税人状态代码（仅限省内供货企业）';
create index IDX_GYSJCXX_DJXH on ATFX_FP_JG_GYSJCXX (DJXH);
create index IDX_GYSJCXX_GYSSBH on ATFX_FP_JG_GYSJCXX (GYSSBH);
create index IDX_GYSJCXX_GYS_NSRZT_DM on ATFX_FP_JG_GYSJCXX (GYS_NSRZT_DM);
create index IDX_GYSJCXX_GYS_SCKPRQ on ATFX_FP_JG_GYSJCXX (GYS_SCKPRQ);
create index IDX_GYSJCXX_GYS_SCTSSBRQ on ATFX_FP_JG_GYSJCXX (GYS_SCTSSBRQ);
create index IDX_GYSJCXX_GYS_SJSWJG_DM on ATFX_FP_JG_GYSJCXX (GYS_SJSWJG_DM);
alter table ATFX_FP_JG_GYSJCXX
  add constraint PK_ATFX_FP_JG_GYSJCXX primary key (DJXH, GYSSBH);

prompt
prompt Creating table ATFX_FP_JG_KHXX
prompt ==============================
prompt
create table ATFX_FP_JG_KHXX
(
  djxh       NUMBER(20) not null,
  gmf_mc     VARCHAR2(200) not null,
  gmf_sckprq DATE,
  gmf_gbdq   VARCHAR2(100)
)
;
comment on table ATFX_FP_JG_KHXX
  is '客户信息统计数据表';
comment on column ATFX_FP_JG_KHXX.djxh
  is '登记序号';
comment on column ATFX_FP_JG_KHXX.gmf_mc
  is '购买方名称';
comment on column ATFX_FP_JG_KHXX.gmf_sckprq
  is '首次销售日期';
comment on column ATFX_FP_JG_KHXX.gmf_gbdq
  is '购买方国别（国内省外为省、省内为地市）';
alter table ATFX_FP_JG_KHXX
  add constraint PK_ATFX_FP_JG_KHXX primary key (DJXH, GMF_MC);

prompt
prompt Creating table ATFX_FP_JG_NXKPTJ
prompt ================================
prompt
create table ATFX_FP_JG_NXKPTJ
(
  djxh          NUMBER(20) not null,
  kpny          VARCHAR2(6) not null,
  gmfmc         VARCHAR2(200) not null,
  sphfwssflhbbm VARCHAR2(19) not null,
  hwhyslwfwmc   VARCHAR2(200),
  je            NUMBER(20,2),
  se            NUMBER(20,2)
)
;
comment on table ATFX_FP_JG_NXKPTJ
  is '内销开票统计数据';
comment on column ATFX_FP_JG_NXKPTJ.djxh
  is '登记序号';
comment on column ATFX_FP_JG_NXKPTJ.kpny
  is '开票年月';
comment on column ATFX_FP_JG_NXKPTJ.gmfmc
  is '购买方名称';
comment on column ATFX_FP_JG_NXKPTJ.sphfwssflhbbm
  is '商品和服务税收分类合并编码';
comment on column ATFX_FP_JG_NXKPTJ.hwhyslwfwmc
  is '货物或应税劳务、服务名称';
comment on column ATFX_FP_JG_NXKPTJ.je
  is '金额';
comment on column ATFX_FP_JG_NXKPTJ.se
  is '税额（根据出口发票统计，有可能有出口应征税货物存在税额）';
alter table ATFX_FP_JG_NXKPTJ
  add constraint PK_ATFX_FP_JG_NXKPTJ primary key (DJXH, KPNY, GMFMC, SPHFWSSFLHBBM);

prompt
prompt Creating table ATFX_FP_JG_WXKPTJ
prompt ================================
prompt
create table ATFX_FP_JG_WXKPTJ
(
  djxh          NUMBER(20) not null,
  kpny          VARCHAR2(6) not null,
  jwkh_mc       VARCHAR2(200) not null,
  sphfwssflhbbm VARCHAR2(19) not null,
  hwhyslwfwmc   VARCHAR2(200),
  je            NUMBER(20,2),
  se            NUMBER(20,2)
)
;
comment on table ATFX_FP_JG_WXKPTJ
  is '外销开票统计数据';
comment on column ATFX_FP_JG_WXKPTJ.djxh
  is '登记序号';
comment on column ATFX_FP_JG_WXKPTJ.kpny
  is '开票年月';
comment on column ATFX_FP_JG_WXKPTJ.jwkh_mc
  is '境外客户名称';
comment on column ATFX_FP_JG_WXKPTJ.sphfwssflhbbm
  is '商品和服务税收分类合并编码';
comment on column ATFX_FP_JG_WXKPTJ.hwhyslwfwmc
  is '货物或应税劳务、服务名称';
comment on column ATFX_FP_JG_WXKPTJ.je
  is '金额';
comment on column ATFX_FP_JG_WXKPTJ.se
  is '税额（根据出口发票统计，有可能有出口应征税货物存在税额）';
alter table ATFX_FP_JG_WXKPTJ
  add constraint PK_ATFX_FP_JG_WXKPTJ primary key (DJXH, KPNY, JWKH_MC, SPHFWSSFLHBBM);

prompt
prompt Creating table ATFX_FP_YS_JHFPXX
prompt ================================
prompt
create table ATFX_FP_YS_JHFPXX
(
  fphm            VARCHAR2(30) not null,
  xh              NUMBER(10) not null,
  djxh            NUMBER(20) not null,
  kpyf            VARCHAR2(6),
  kprq            DATE,
  xsfnsrsbh       VARCHAR2(20) not null,
  xsfmc           VARCHAR2(300) not null,
  xsfdjxh         NUMBER(20),
  dk_xsfsbh       VARCHAR2(20),
  dk_xsfmc        VARCHAR2(300),
  gmfnsrsbh       VARCHAR2(20) not null,
  gmfmc           VARCHAR2(300) not null,
  gmfdjxh         NUMBER(20),
  xsfssjswjg_dm   VARCHAR2(11),
  xsfdsjswjg_dm   VARCHAR2(11),
  xsfzgswj_dm     VARCHAR2(11),
  xsfzgswskfj_dm  VARCHAR2(11),
  gmfssjswjg_dm   VARCHAR2(11),
  gmfdsjswjg_dm   VARCHAR2(11),
  gmfzgswj_dm     VARCHAR2(11),
  gmfzgswskfj_dm  VARCHAR2(11),
  kjhzfpdydlzfphm VARCHAR2(30),
  hjje            NUMBER(18,2),
  hjse            NUMBER(18,2),
  jshj            NUMBER(18,2),
  sphfwssflhbbm   VARCHAR2(20),
  hwhyslwfwmc     VARCHAR2(300) not null,
  ggxh            VARCHAR2(300),
  jldw            VARCHAR2(30),
  fpspsl          VARCHAR2(30),
  fpspdj          VARCHAR2(30),
  je              NUMBER(18,2),
  se              NUMBER(18,2),
  fppz_dm         VARCHAR2(10),
  sflzfp          CHAR(1),
  fpzt_dm         VARCHAR2(10),
  fplx            VARCHAR2(20),
  sjlx            VARCHAR2(30),
  slv             NUMBER(16,6)
)
;
comment on table ATFX_FP_YS_JHFPXX
  is '进货发票电子信息表';
comment on column ATFX_FP_YS_JHFPXX.fphm
  is '发票号码（主键，底账系统用发票代码||发票号码）';
comment on column ATFX_FP_YS_JHFPXX.xh
  is '序号（主键，底账货物对应MXXH）';
comment on column ATFX_FP_YS_JHFPXX.djxh
  is '登记序号（数据抽取时填入，多个企业分析时区分企业数据）';
comment on column ATFX_FP_YS_JHFPXX.kpyf
  is '开票月份（数电票需通过开票日期转换）';
comment on column ATFX_FP_YS_JHFPXX.kprq
  is '开票日期';
comment on column ATFX_FP_YS_JHFPXX.xsfnsrsbh
  is '销售方纳税人识别代号（底账电子专票对应XSFSBH，其他对应XFSBH）';
comment on column ATFX_FP_YS_JHFPXX.xsfmc
  is '销售方名称（底账非电子专票对应XFMC字段）';
comment on column ATFX_FP_YS_JHFPXX.xsfdjxh
  is '销售方登记序号（数电票XHFDJXH，底账发票没有对应字段，默认为null）';
comment on column ATFX_FP_YS_JHFPXX.dk_xsfsbh
  is '代开_销售方识别号（底账专用发票对应字段，其它为null）';
comment on column ATFX_FP_YS_JHFPXX.dk_xsfmc
  is '代开_销售方名称（底账专用发票对应字段，其它为null）';
comment on column ATFX_FP_YS_JHFPXX.gmfnsrsbh
  is '购买方纳税人识别号（底账电子专票对应GMFSBH，其他对应GFSBH）';
comment on column ATFX_FP_YS_JHFPXX.gmfmc
  is '购买方名称（底账非电子专票对应GFMC字段）';
comment on column ATFX_FP_YS_JHFPXX.gmfdjxh
  is '购买方登记序号（底账发票没有对应字段，默认为null）';
comment on column ATFX_FP_YS_JHFPXX.xsfssjswjg_dm
  is '销售方_省级税务机关代码（底账系统对应XF_SJSWJG_DM字段）';
comment on column ATFX_FP_YS_JHFPXX.xsfdsjswjg_dm
  is '销售方_地市级税务机关代码（底账系统对应XF_FSSWJG_DM字段）';
comment on column ATFX_FP_YS_JHFPXX.xsfzgswj_dm
  is '销售方_主管税务局代码（底账系统对应XF_QXSWJG_DM字段）';
comment on column ATFX_FP_YS_JHFPXX.xsfzgswskfj_dm
  is '销售方_主管税务所代码（底账发票没有对应字段，默认为null）';
comment on column ATFX_FP_YS_JHFPXX.gmfssjswjg_dm
  is '购买方_省市级税务机关代码（底账系统对应GF_SJSWJG_DM字段）';
comment on column ATFX_FP_YS_JHFPXX.gmfdsjswjg_dm
  is '购买方_地市级税务机关代码（底账系统对应GF_DSSWJG_DM字段）';
comment on column ATFX_FP_YS_JHFPXX.gmfzgswj_dm
  is '购买方_主管税务局代码（底账系统对应GF_QXSWJG_DM字段）';
comment on column ATFX_FP_YS_JHFPXX.gmfzgswskfj_dm
  is '购买方_主管税务所代码（底账发票没有对应字段，默认为null）';
comment on column ATFX_FP_YS_JHFPXX.kjhzfpdydlzfphm
  is '开具红字对应的蓝字发票号码（底账系统用原发票代码||原发票号码）';
comment on column ATFX_FP_YS_JHFPXX.hjje
  is '合计金额（底账发票对应JE）';
comment on column ATFX_FP_YS_JHFPXX.hjse
  is '合计税额（底账发票对应SE）';
comment on column ATFX_FP_YS_JHFPXX.jshj
  is '价税合计';
comment on column ATFX_FP_YS_JHFPXX.sphfwssflhbbm
  is '商品和服务税收分类合并编码（底账货物对应SPBM）';
comment on column ATFX_FP_YS_JHFPXX.hwhyslwfwmc
  is '货物或应税劳务、服务名称（底账货物对应MC）';
comment on column ATFX_FP_YS_JHFPXX.ggxh
  is '规格型号';
comment on column ATFX_FP_YS_JHFPXX.jldw
  is '单位（数电票对应DW）';
comment on column ATFX_FP_YS_JHFPXX.fpspsl
  is '数量（底账货物对应SL）';
comment on column ATFX_FP_YS_JHFPXX.fpspdj
  is '单价（底账货物对应DJ）';
comment on column ATFX_FP_YS_JHFPXX.je
  is '金额';
comment on column ATFX_FP_YS_JHFPXX.se
  is '税额';
comment on column ATFX_FP_YS_JHFPXX.fppz_dm
  is '发票票种代码（底账电子专票对应TSPZ字段，底账其他发票对应TSPZ_DM字段）';
comment on column ATFX_FP_YS_JHFPXX.sflzfp
  is '是否蓝字发票（底账电子专票对应FPZTBZ，其他对应FPZT_BZ；0蓝字→Y，1红字→N）';
comment on column ATFX_FP_YS_JHFPXX.fpzt_dm
  is '发票状态代码（数电票目前没有对应字段）';
comment on column ATFX_FP_YS_JHFPXX.fplx
  is '发票类型（普通发票/专用发票/数电发票，数据抽取时打标记）';
comment on column ATFX_FP_YS_JHFPXX.sjlx
  is '数据类型（原材料、生产设备等，后期可人工打标记，标记后需重新加工进货发票数据）';
create index IDX_JHFPXX_DJXH on ATFX_FP_YS_JHFPXX (DJXH);
create index IDX_JHFPXX_FPLX on ATFX_FP_YS_JHFPXX (FPLX);
create index IDX_JHFPXX_GMFNSRSBH on ATFX_FP_YS_JHFPXX (GMFNSRSBH);
create index IDX_JHFPXX_KPRQ on ATFX_FP_YS_JHFPXX (KPRQ);
create index IDX_JHFPXX_SJLX on ATFX_FP_YS_JHFPXX (SJLX);
create index IDX_JHFPXX_SPHFWSSFLHBBM on ATFX_FP_YS_JHFPXX (SPHFWSSFLHBBM);
create index IDX_JHFPXX_XSFNSRSBH on ATFX_FP_YS_JHFPXX (XSFNSRSBH);
alter table ATFX_FP_YS_JHFPXX
  add constraint PK_ATFX_FP_YS_JHFPXX primary key (FPHM, XH);

prompt
prompt Creating table ATFX_FP_YS_XSFPXX
prompt ================================
prompt
create table ATFX_FP_YS_XSFPXX
(
  fphm            VARCHAR2(30) not null,
  xh              NUMBER(10) not null,
  djxh            NUMBER(20) not null,
  kpyf            VARCHAR2(6),
  kprq            DATE,
  xsfnsrsbh       VARCHAR2(20) not null,
  xsfmc           VARCHAR2(300) not null,
  xsfdjxh         NUMBER(20),
  gmfnsrsbh       VARCHAR2(20),
  gmfmc           VARCHAR2(300) not null,
  gmfdjxh         NUMBER(20),
  xsfssjswjg_dm   VARCHAR2(11),
  xsfdsjswjg_dm   VARCHAR2(11),
  xsfzgswj_dm     VARCHAR2(11),
  xsfzgswskfj_dm  VARCHAR2(11),
  gmfssjswjg_dm   VARCHAR2(11),
  gmfdsjswjg_dm   VARCHAR2(11),
  gmfzgswj_dm     VARCHAR2(11),
  gmfzgswskfj_dm  VARCHAR2(11),
  kjhzfpdydlzfphm VARCHAR2(30),
  hjje            NUMBER(18,2),
  hjse            NUMBER(18,2),
  jshj            NUMBER(18,2),
  sphfwssflhbbm   VARCHAR2(20),
  hwhyslwfwmc     VARCHAR2(300) not null,
  ggxh            VARCHAR2(300),
  jldw            VARCHAR2(30),
  fpspsl          VARCHAR2(30),
  fpspdj          VARCHAR2(30),
  je              NUMBER(18,2),
  se              NUMBER(18,2),
  fppz_dm         VARCHAR2(10),
  sflzfp          CHAR(1),
  fplx            VARCHAR2(20),
  ckfpbz          CHAR(1),
  sjlx            VARCHAR2(30),
  slv             NUMBER(16,6)
)
;
comment on table ATFX_FP_YS_XSFPXX
  is '销售发票电子信息表';
comment on column ATFX_FP_YS_XSFPXX.fphm
  is '发票号码（主键，底账系统用发票代码||发票号码）';
comment on column ATFX_FP_YS_XSFPXX.xh
  is '序号（主键，底账货物对应MXXH）';
comment on column ATFX_FP_YS_XSFPXX.djxh
  is '登记序号（数据抽取时填入，多个企业同时分析时区分企业数据）';
comment on column ATFX_FP_YS_XSFPXX.kpyf
  is '开票月份（数电票没有开票月份，需通过开票日期转换）';
comment on column ATFX_FP_YS_XSFPXX.kprq
  is '开票日期';
comment on column ATFX_FP_YS_XSFPXX.xsfnsrsbh
  is '销售方纳税人识别代号（底账电子专票对应XSFSBH，其他对应XFSBH）';
comment on column ATFX_FP_YS_XSFPXX.xsfmc
  is '销售方名称（底账非电子专票对应XFMC字段）';
comment on column ATFX_FP_YS_XSFPXX.xsfdjxh
  is '销售方登记序号（数电票XHFDJXH，底账发票没有对应字段，默认为null）';
comment on column ATFX_FP_YS_XSFPXX.gmfnsrsbh
  is '购买方纳税人识别号（底账电子专票对应GMFSBH，其他对应GFSBH）';
comment on column ATFX_FP_YS_XSFPXX.gmfmc
  is '购买方名称（底账非电子专票对应GFMC字段）';
comment on column ATFX_FP_YS_XSFPXX.gmfdjxh
  is '购买方登记序号（底账发票没有对应字段，默认为null）';
comment on column ATFX_FP_YS_XSFPXX.xsfssjswjg_dm
  is '销售方_省级税务机关代码（底账系统对应XF_SJSWJG_DM字段）';
comment on column ATFX_FP_YS_XSFPXX.xsfdsjswjg_dm
  is '销售方_地市级税务机关代码（底账系统对应XF_FSSWJG_DM字段）';
comment on column ATFX_FP_YS_XSFPXX.xsfzgswj_dm
  is '销售方_主管税务局代码（底账系统对应XF_QXSWJG_DM字段）';
comment on column ATFX_FP_YS_XSFPXX.xsfzgswskfj_dm
  is '销售方_主管税务所代码（底账发票没有对应字段，默认为null）';
comment on column ATFX_FP_YS_XSFPXX.gmfssjswjg_dm
  is '购买方_省市级税务机关代码（底账系统对应GF_SJSWJG_DM字段）';
comment on column ATFX_FP_YS_XSFPXX.gmfdsjswjg_dm
  is '购买方_地市级税务机关代码（底账系统对应GF_DSSWJG_DM字段）';
comment on column ATFX_FP_YS_XSFPXX.gmfzgswj_dm
  is '购买方_主管税务局代码（底账系统对应GF_QXSWJG_DM字段）';
comment on column ATFX_FP_YS_XSFPXX.gmfzgswskfj_dm
  is '购买方_主管税务所代码（底账发票没有对应字段，默认为null）';
comment on column ATFX_FP_YS_XSFPXX.kjhzfpdydlzfphm
  is '开具红字对应的蓝字发票号码（底账系统用原发票代码||原发票号码）';
comment on column ATFX_FP_YS_XSFPXX.hjje
  is '合计金额（底账发票对应JE）';
comment on column ATFX_FP_YS_XSFPXX.hjse
  is '合计税额（底账发票对应SE）';
comment on column ATFX_FP_YS_XSFPXX.jshj
  is '价税合计';
comment on column ATFX_FP_YS_XSFPXX.sphfwssflhbbm
  is '商品和服务税收分类合并编码（底账货物对应SPBM）';
comment on column ATFX_FP_YS_XSFPXX.hwhyslwfwmc
  is '货物或应税劳务、服务名称（底账货物对应MC）';
comment on column ATFX_FP_YS_XSFPXX.ggxh
  is '规格型号';
comment on column ATFX_FP_YS_XSFPXX.jldw
  is '单位（数电票对应DW）';
comment on column ATFX_FP_YS_XSFPXX.fpspsl
  is '数量（底账货物对应SL）';
comment on column ATFX_FP_YS_XSFPXX.fpspdj
  is '单价（底账货物对应DJ）';
comment on column ATFX_FP_YS_XSFPXX.je
  is '金额';
comment on column ATFX_FP_YS_XSFPXX.se
  is '税额';
comment on column ATFX_FP_YS_XSFPXX.fppz_dm
  is '发票票种代码（底账电子专票对应TSPZ字段，底账其他发票对应TSPZ_DM字段）';
comment on column ATFX_FP_YS_XSFPXX.sflzfp
  is '是否蓝字发票（底账电子专票对应FPZTBZ，其他对应FPZT_BZ；0蓝字→Y，1红字→N）';
comment on column ATFX_FP_YS_XSFPXX.fplx
  is '发票类型（普通发票/专用发票/数电发票，数据抽取时根据来源打标记）';
comment on column ATFX_FP_YS_XSFPXX.ckfpbz
  is '出口发票标志（数据提取时根据备注栏打标记）';
comment on column ATFX_FP_YS_XSFPXX.sjlx
  is '数据类型（产成品、能源消耗（水电气煤等）、其它；后期可人工打标记，标记后需重新加工销货发票数据）';
create index IDX_XSFPXX_CKFPBZ on ATFX_FP_YS_XSFPXX (CKFPBZ);
create index IDX_XSFPXX_DJXH on ATFX_FP_YS_XSFPXX (DJXH);
create index IDX_XSFPXX_FPLX on ATFX_FP_YS_XSFPXX (FPLX);
create index IDX_XSFPXX_GMFNSRSBH on ATFX_FP_YS_XSFPXX (GMFNSRSBH);
create index IDX_XSFPXX_KPRQ on ATFX_FP_YS_XSFPXX (KPRQ);
create index IDX_XSFPXX_SJLX on ATFX_FP_YS_XSFPXX (SJLX);
create index IDX_XSFPXX_SPHFWSSFLHBBM on ATFX_FP_YS_XSFPXX (SPHFWSSFLHBBM);
create index IDX_XSFPXX_XSFNSRSBH on ATFX_FP_YS_XSFPXX (XSFNSRSBH);
alter table ATFX_FP_YS_XSFPXX
  add constraint PK_ATFX_FP_YS_XSFPXX primary key (FPHM, XH);

prompt
prompt Creating table ATFX_GLSJ_DATA_RZ
prompt ================================
prompt
create table ATFX_GLSJ_DATA_RZ
(
  uuid       VARCHAR2(36) not null,
  djxh       NUMBER(20) not null,
  ds_id      VARCHAR2(32) not null,
  table_name VARCHAR2(64) not null,
  sjjgkssj   DATE not null,
  sjjgjssj   DATE,
  jgbz       CHAR(1) default 0,
  jgmsg      VARCHAR2(4000),
  crtime     TIMESTAMP(6) default CURRENT_TIMESTAMP,
  uptime     TIMESTAMP(6)
)
;
comment on table ATFX_GLSJ_DATA_RZ
  is '数据加工日志表';
comment on column ATFX_GLSJ_DATA_RZ.uuid
  is '同案头分析台账UUID';
comment on column ATFX_GLSJ_DATA_RZ.djxh
  is '登记序号';
comment on column ATFX_GLSJ_DATA_RZ.ds_id
  is '数据源标识';
comment on column ATFX_GLSJ_DATA_RZ.table_name
  is '数据表标识';
comment on column ATFX_GLSJ_DATA_RZ.sjjgkssj
  is '开始时间';
comment on column ATFX_GLSJ_DATA_RZ.sjjgjssj
  is '结束时间';
comment on column ATFX_GLSJ_DATA_RZ.jgbz
  is '处理结果标志，0，初始 1，完成，9失败，5、重启';
comment on column ATFX_GLSJ_DATA_RZ.jgmsg
  is '处理结果信息';
alter table ATFX_GLSJ_DATA_RZ
  add constraint PK_ATFX_GLSJ_DATA_RZ primary key (UUID, DS_ID, DJXH, TABLE_NAME);

prompt
prompt Creating table ATFX_GLSJ_DATA_TZ
prompt ================================
prompt
create table ATFX_GLSJ_DATA_TZ
(
  uuid           VARCHAR2(32) not null,
  czry_swjg_dm   VARCHAR2(11) not null,
  qy_swjg_dm     VARCHAR2(11) not null,
  djxh           VARCHAR2(21) not null,
  nsrsbh         VARCHAR2(20) not null,
  nsrmc          VARCHAR2(200) not null,
  ckhwtmsjsff_dm CHAR(1),
  fxqq           DATE not null,
  fxqz           DATE not null,
  sqr_dm         VARCHAR2(20) not null,
  sqr_mc         VARCHAR2(80) not null,
  sqrq           DATE,
  fxr2_dm        VARCHAR2(20),
  fxr2_mc        VARCHAR2(80),
  spjg           CHAR(1),
  spyj           VARCHAR2(255),
  spr_dm         VARCHAR2(20),
  spr_mc         VARCHAR2(80),
  sprq           TIMESTAMP(6),
  tzzt           CHAR(3) not null,
  wcrq           DATE,
  cjr_dm         VARCHAR2(20),
  cjr_mc         VARCHAR2(80),
  note           VARCHAR2(255),
  crtime         TIMESTAMP(6) default CURRENT_TIMESTAMP not null,
  uptime         TIMESTAMP(6) default CURRENT_TIMESTAMP not null
)
;
comment on table ATFX_GLSJ_DATA_TZ
  is '案头分析台账主表';
comment on column ATFX_GLSJ_DATA_TZ.uuid
  is 'UUID，主键';
comment on column ATFX_GLSJ_DATA_TZ.czry_swjg_dm
  is '操作人员所属税务机关代码';
comment on column ATFX_GLSJ_DATA_TZ.qy_swjg_dm
  is '企业税务机关代码';
comment on column ATFX_GLSJ_DATA_TZ.djxh
  is '登记序号';
comment on column ATFX_GLSJ_DATA_TZ.nsrsbh
  is '纳税人识别号';
comment on column ATFX_GLSJ_DATA_TZ.nsrmc
  is '纳税人名称';
comment on column ATFX_GLSJ_DATA_TZ.ckhwtmsjsff_dm
  is '出口货物退(免)税计算方法代码';
comment on column ATFX_GLSJ_DATA_TZ.fxqq
  is '案头分析期起';
comment on column ATFX_GLSJ_DATA_TZ.fxqz
  is '案头分析期止';
comment on column ATFX_GLSJ_DATA_TZ.sqr_dm
  is '申请人代码';
comment on column ATFX_GLSJ_DATA_TZ.sqr_mc
  is '申请人名称';
comment on column ATFX_GLSJ_DATA_TZ.sqrq
  is '申请日期';
comment on column ATFX_GLSJ_DATA_TZ.fxr2_dm
  is '共同分析人员代码';
comment on column ATFX_GLSJ_DATA_TZ.fxr2_mc
  is '共同分析人员名称';
comment on column ATFX_GLSJ_DATA_TZ.spjg
  is '审批结果（1：同意；0：不同意）';
comment on column ATFX_GLSJ_DATA_TZ.spyj
  is '审批意见（同意/不同意）';
comment on column ATFX_GLSJ_DATA_TZ.spr_dm
  is '审批人代码';
comment on column ATFX_GLSJ_DATA_TZ.spr_mc
  is '审批人名称';
comment on column ATFX_GLSJ_DATA_TZ.sprq
  is '审批日期';
comment on column ATFX_GLSJ_DATA_TZ.tzzt
  is '台账状态(100已取消、110待审批、120数据准备、130案头分析、140出具报告、150已发放)';
comment on column ATFX_GLSJ_DATA_TZ.wcrq
  is '完成日期';
comment on column ATFX_GLSJ_DATA_TZ.cjr_dm
  is '创建人代码';
comment on column ATFX_GLSJ_DATA_TZ.cjr_mc
  is '创建人名称';
comment on column ATFX_GLSJ_DATA_TZ.note
  is '备注';
comment on column ATFX_GLSJ_DATA_TZ.crtime
  is '创建时间';
comment on column ATFX_GLSJ_DATA_TZ.uptime
  is '更新时间';
create index IDX_ATFX_GLSJ_DATA_TZ_DJXH on ATFX_GLSJ_DATA_TZ (DJXH);
create index IDX_ATFX_GLSJ_DATA_TZ_IDX1 on ATFX_GLSJ_DATA_TZ (CZRY_SWJG_DM);
create index IDX_ATFX_GLSJ_DATA_TZ_IDX2 on ATFX_GLSJ_DATA_TZ (QY_SWJG_DM);
alter table ATFX_GLSJ_DATA_TZ
  add constraint PK_ATFX_GLSJ_DATA_TZ primary key (UUID);

prompt
prompt Creating table ATFX_GLSJ_PZ_SJB
prompt ===============================
prompt
create table ATFX_GLSJ_PZ_SJB
(
  ds_id        VARCHAR2(32) not null,
  table_name   VARCHAR2(64) not null,
  table_cname  VARCHAR2(100) not null,
  table_schema VARCHAR2(32) not null,
  table_type   CHAR(1) not null,
  is_dict      VARCHAR2(1) not null,
  yxbz         VARCHAR2(1) not null,
  showorder    NUMBER(4) default 0,
  groupid      VARCHAR2(20),
  groupname    VARCHAR2(60),
  groupdesc    VARCHAR2(200)
)
;
comment on table ATFX_GLSJ_PZ_SJB
  is '数据表信息表';
comment on column ATFX_GLSJ_PZ_SJB.ds_id
  is '关联数据源信息表的DS_ID';
comment on column ATFX_GLSJ_PZ_SJB.table_name
  is '数据表标识（数据库中实际的表名）';
comment on column ATFX_GLSJ_PZ_SJB.table_cname
  is '数据表中文名称（用于展示）';
comment on column ATFX_GLSJ_PZ_SJB.table_schema
  is '数据表拥有者（所属 schema，如HX_CKTS）';
comment on column ATFX_GLSJ_PZ_SJB.table_type
  is '数据表类型（数据源/原始数据/加工数据）';
comment on column ATFX_GLSJ_PZ_SJB.is_dict
  is '是否为代码表（Y：是，N：否）';
comment on column ATFX_GLSJ_PZ_SJB.yxbz
  is '有效标志（Y：有效，N：无效）';
comment on column ATFX_GLSJ_PZ_SJB.showorder
  is '显示顺序（数字越小越靠前）';
comment on column ATFX_GLSJ_PZ_SJB.groupid
  is '分组标识';
alter table ATFX_GLSJ_PZ_SJB
  add constraint PK_ATFX_GLSJ_PZ_SJB primary key (DS_ID, TABLE_NAME);

prompt
prompt Creating table ATFX_GLSJ_PZ_SJBYL
prompt =================================
prompt
create table ATFX_GLSJ_PZ_SJBYL
(
  ds_id        VARCHAR2(32) not null,
  table_name   VARCHAR2(64) not null,
  ds_depend    VARCHAR2(32) not null,
  table_depend VARCHAR2(64) not null,
  yxbz         VARCHAR2(1) not null,
  showorder    NUMBER(4) default 0
)
;
comment on table ATFX_GLSJ_PZ_SJBYL
  is '数据表依赖关系表（存储数据表之间的依赖关系）';
comment on column ATFX_GLSJ_PZ_SJBYL.ds_id
  is '数据源标识（当前依赖方的数据源，关联atfx_glsj_pz_sjy表）';
comment on column ATFX_GLSJ_PZ_SJBYL.table_name
  is '数据表标识（当前依赖方的表，关联atfx_glsj_pz_sjb表）';
comment on column ATFX_GLSJ_PZ_SJBYL.ds_depend
  is '被依赖的数据源标识（被依赖方的数据源）';
comment on column ATFX_GLSJ_PZ_SJBYL.table_depend
  is '被依赖的数据表标识（被依赖方的表）';
comment on column ATFX_GLSJ_PZ_SJBYL.yxbz
  is '有效标志（Y=有效依赖关系，N=无效/已废弃）';
comment on column ATFX_GLSJ_PZ_SJBYL.showorder
  is '显示顺序（用于排序依赖关系的展示）';
alter table ATFX_GLSJ_PZ_SJBYL
  add constraint PK_ATFX_GLSJ_PZ_SJBYL primary key (DS_ID, TABLE_NAME, DS_DEPEND, TABLE_DEPEND);

prompt
prompt Creating table ATFX_GLSJ_PZ_SJX
prompt ===============================
prompt
create table ATFX_GLSJ_PZ_SJX
(
  ds_id       VARCHAR2(32) not null,
  table_name  VARCHAR2(64) not null,
  field_name  VARCHAR2(64) not null,
  field_cname VARCHAR2(100) not null,
  datatype    VARCHAR2(1) not null,
  showformat  VARCHAR2(1) default '0',
  showlength  NUMBER(3),
  codetable   VARCHAR2(64),
  codefield   VARCHAR2(64),
  defval      VARCHAR2(100),
  ywms        VARCHAR2(500),
  yxbz        VARCHAR2(1) not null,
  showorder   NUMBER(4) default 0,
  namefield   VARCHAR2(64),
  typefield   VARCHAR2(64),
  typevalue   VARCHAR2(40)
)
;
comment on table ATFX_GLSJ_PZ_SJX
  is '数据表字段信息表';
comment on column ATFX_GLSJ_PZ_SJX.ds_id
  is '数据源标识（关联atfx_glsj_pz_sjy表的DS_ID）';
comment on column ATFX_GLSJ_PZ_SJX.table_name
  is '数据表标识（关联atfx_glsj_pz_sjb表的TABLE_NAME）';
comment on column ATFX_GLSJ_PZ_SJX.field_name
  is '数据项标识（数据表中的实际字段名）';
comment on column ATFX_GLSJ_PZ_SJX.field_cname
  is '数据项中文名称（用于展示）';
comment on column ATFX_GLSJ_PZ_SJX.datatype
  is '数据类型（1=字符型,2=数值型,3=日期型,4=逻辑型）';
comment on column ATFX_GLSJ_PZ_SJX.showformat
  is '显示格式（0=默认,1=金额,2=整数,3=百分比） 0 居左，1，加千分符,靠右   2居中  3百分比居中加%';
comment on column ATFX_GLSJ_PZ_SJX.showlength
  is '显示长度';
comment on column ATFX_GLSJ_PZ_SJX.codetable
  is '关联代码表（若为代码项，填写对应代码表名）';
comment on column ATFX_GLSJ_PZ_SJX.codefield
  is '关联代码字段（代码表中对应的字段名）';
comment on column ATFX_GLSJ_PZ_SJX.defval
  is '缺省值（字段默认值）';
comment on column ATFX_GLSJ_PZ_SJX.ywms
  is '特殊业务功能描述字段，可用于扩展性功能描述，目前配置  time ，可控制字段显示时分秒';
comment on column ATFX_GLSJ_PZ_SJX.yxbz
  is '有效标志（Y=有效,N=无效）';
comment on column ATFX_GLSJ_PZ_SJX.showorder
  is '显示顺序（数字越小越靠前）';
comment on column ATFX_GLSJ_PZ_SJX.namefield
  is '关联代码名称字段';
comment on column ATFX_GLSJ_PZ_SJX.typefield
  is '关联代码类型字段';
comment on column ATFX_GLSJ_PZ_SJX.typevalue
  is '关联代码类型值';
alter table ATFX_GLSJ_PZ_SJX
  add constraint PK_ATFX_GLSJ_PZ_SJX primary key (DS_ID, TABLE_NAME, FIELD_NAME);

prompt
prompt Creating table ATFX_GLSJ_PZ_SJY
prompt ===============================
prompt
create table ATFX_GLSJ_PZ_SJY
(
  ds_id     VARCHAR2(32) not null,
  ds_name   VARCHAR2(100) not null,
  ds_type   VARCHAR2(20) not null,
  yxbz      VARCHAR2(1) not null,
  showorder NUMBER(4) default 0
)
;
comment on table ATFX_GLSJ_PZ_SJY
  is '数据源信息表';
comment on column ATFX_GLSJ_PZ_SJY.ds_id
  is '数据源标识（唯一主键）';
comment on column ATFX_GLSJ_PZ_SJY.ds_name
  is '数据源名称';
comment on column ATFX_GLSJ_PZ_SJY.ds_type
  is '数据源类型（如oracle/mysql）';
comment on column ATFX_GLSJ_PZ_SJY.yxbz
  is '有效标志（Y：有效，N：无效）';
comment on column ATFX_GLSJ_PZ_SJY.showorder
  is '显示顺序（数字越小越靠前）';
alter table ATFX_GLSJ_PZ_SJY
  add constraint PK_ATFX_GLSJ_PZ_SJY primary key (DS_ID);

prompt
prompt Creating table ATFX_HD_YS_BQYHDFPQD
prompt ===================================
prompt
create table ATFX_HD_YS_BQYHDFPQD
(
  hdfpqduuid  VARCHAR2(32) not null,
  fhxxbuuid   VARCHAR2(32) not null,
  djxh        NUMBER(20) not null,
  pzzl1       VARCHAR2(20),
  zzszyfpdmhm VARCHAR2(20) not null,
  ghfnsrsbh_1 VARCHAR2(20),
  sp_dm       VARCHAR2(20),
  spmc        VARCHAR2(200),
  ggxh        VARCHAR2(100),
  kjrq        DATE,
  jldw_dm     VARCHAR2(10),
  sl          NUMBER(18,6),
  sl_1        VARCHAR2(10),
  tsl         VARCHAR2(10),
  dj          NUMBER(18,6),
  je          NUMBER(18,2),
  se          NUMBER(18,2),
  jshj        NUMBER(18,2),
  ktse_1      NUMBER(18,2),
  sfyts       CHAR(1)
)
;
comment on table ATFX_HD_YS_BQYHDFPQD
  is '本企业函调发票清单表';
comment on column ATFX_HD_YS_BQYHDFPQD.hdfpqduuid
  is '函调发票清单UUID，主键';
comment on column ATFX_HD_YS_BQYHDFPQD.fhxxbuuid
  is '发函信息表UUID（关联函调信息表）';
comment on column ATFX_HD_YS_BQYHDFPQD.djxh
  is '登记序号';
comment on column ATFX_HD_YS_BQYHDFPQD.pzzl1
  is '凭证种类';
comment on column ATFX_HD_YS_BQYHDFPQD.zzszyfpdmhm
  is '增值税专用发票代码号码';
comment on column ATFX_HD_YS_BQYHDFPQD.ghfnsrsbh_1
  is '供货方纳税人识别号';
comment on column ATFX_HD_YS_BQYHDFPQD.sp_dm
  is '商品代码';
comment on column ATFX_HD_YS_BQYHDFPQD.spmc
  is '商品名称';
comment on column ATFX_HD_YS_BQYHDFPQD.ggxh
  is '规格型号';
comment on column ATFX_HD_YS_BQYHDFPQD.kjrq
  is '开具日期';
comment on column ATFX_HD_YS_BQYHDFPQD.jldw_dm
  is '计量单位代码';
comment on column ATFX_HD_YS_BQYHDFPQD.sl
  is '数量';
comment on column ATFX_HD_YS_BQYHDFPQD.sl_1
  is '税率';
comment on column ATFX_HD_YS_BQYHDFPQD.tsl
  is '退税率';
comment on column ATFX_HD_YS_BQYHDFPQD.dj
  is '单价';
comment on column ATFX_HD_YS_BQYHDFPQD.je
  is '金额';
comment on column ATFX_HD_YS_BQYHDFPQD.se
  is '税额';
comment on column ATFX_HD_YS_BQYHDFPQD.jshj
  is '价税合计';
comment on column ATFX_HD_YS_BQYHDFPQD.ktse_1
  is '可退税额';
comment on column ATFX_HD_YS_BQYHDFPQD.sfyts
  is '是否已退税（如Y=是，N=否）';
create index IDX_BQYHDFPQD_DJXH on ATFX_HD_YS_BQYHDFPQD (DJXH);
create index IDX_BQYHDFPQD_FHXXBUUID on ATFX_HD_YS_BQYHDFPQD (FHXXBUUID);
create index IDX_BQYHDFPQD_GHFNSRSBH1 on ATFX_HD_YS_BQYHDFPQD (GHFNSRSBH_1);
create index IDX_BQYHDFPQD_KJRQ on ATFX_HD_YS_BQYHDFPQD (KJRQ);
create index IDX_BQYHDFPQD_SFYTS on ATFX_HD_YS_BQYHDFPQD (SFYTS);
create index IDX_BQYHDFPQD_ZZSZYFPDMHM on ATFX_HD_YS_BQYHDFPQD (ZZSZYFPDMHM);
alter table ATFX_HD_YS_BQYHDFPQD
  add constraint PK_ATFX_HD_YS_BQYHDFPQD primary key (DJXH, HDFPQDUUID);

prompt
prompt Creating table ATFX_HD_YS_BQYHDXX
prompt =================================
prompt
create table ATFX_HD_YS_BQYHDXX
(
  fhxxbuuid       VARCHAR2(32) not null,
  wsbh            VARCHAR2(50) not null,
  fahdswjg_dm     VARCHAR2(11),
  fahdswjgmc      VARCHAR2(200),
  ghqynsrsbh      VARCHAR2(20) not null,
  ghfqymc         VARCHAR2(200) not null,
  ghfdjxh         NUMBER(20) not null,
  ghfzgswjg_dm    VARCHAR2(11),
  ghfzgswjgmc     VARCHAR2(200),
  ghqynsrsbh_1    VARCHAR2(20),
  ghfqymc_1       VARCHAR2(200),
  ghfdjxh1        NUMBER(20),
  fpfs            NUMBER(10),
  jehj            NUMBER(18,2),
  sehj            NUMBER(18,2),
  jshj            NUMBER(18,2),
  sjcktse         NUMBER(18,2),
  fh_qfrq         DATE,
  fahyy           VARCHAR2(1000),
  fuhxxbuuid      VARCHAR2(32),
  fuh_qfrq        DATE,
  fuhcs           NUMBER(3),
  fhlx_dm         VARCHAR2(2),
  ycqx_tree       VARCHAR2(1000),
  zhbltmsqx       VARCHAR2(1000),
  sffzchzxswdj    CHAR(1),
  yqfhyy          VARCHAR2(500),
  fscfhyy         VARCHAR2(500),
  zzhcswclyy_tree VARCHAR2(1000)
)
;
comment on table ATFX_HD_YS_BQYHDXX
  is '本企业函调信息表';
comment on column ATFX_HD_YS_BQYHDXX.fhxxbuuid
  is '发函信息表UUID（关联发函信息表和回函信息表）';
comment on column ATFX_HD_YS_BQYHDXX.wsbh
  is '文书编号（同回函信息表的核实函编号）';
comment on column ATFX_HD_YS_BQYHDXX.fahdswjg_dm
  is '发函地税务机关代码';
comment on column ATFX_HD_YS_BQYHDXX.fahdswjgmc
  is '发函地税务机关名称';
comment on column ATFX_HD_YS_BQYHDXX.ghqynsrsbh
  is '购货企业纳税人识别号（本企业）';
comment on column ATFX_HD_YS_BQYHDXX.ghfqymc
  is '购货企业名称（本企业）';
comment on column ATFX_HD_YS_BQYHDXX.ghfdjxh
  is '购货方登记序号（本企业）';
comment on column ATFX_HD_YS_BQYHDXX.ghfzgswjg_dm
  is '供货方主管税务机关代码';
comment on column ATFX_HD_YS_BQYHDXX.ghfzgswjgmc
  is '供货方主管税务机关名称';
comment on column ATFX_HD_YS_BQYHDXX.ghqynsrsbh_1
  is '供货企业纳税人识别号';
comment on column ATFX_HD_YS_BQYHDXX.ghfqymc_1
  is '供货企业名称';
comment on column ATFX_HD_YS_BQYHDXX.ghfdjxh1
  is '供货方登记序号';
comment on column ATFX_HD_YS_BQYHDXX.fpfs
  is '发票份数';
comment on column ATFX_HD_YS_BQYHDXX.jehj
  is '金额合计';
comment on column ATFX_HD_YS_BQYHDXX.sehj
  is '税额合计';
comment on column ATFX_HD_YS_BQYHDXX.jshj
  is '价税合计';
comment on column ATFX_HD_YS_BQYHDXX.sjcktse
  is '涉及出口退税额';
comment on column ATFX_HD_YS_BQYHDXX.fh_qfrq
  is '发函签发日期（取发函信息表）';
comment on column ATFX_HD_YS_BQYHDXX.fahyy
  is '发函原因（NVL(FAHYY,CXFAHYY)）';
comment on column ATFX_HD_YS_BQYHDXX.fuhxxbuuid
  is '复函信息表UUID';
comment on column ATFX_HD_YS_BQYHDXX.fuh_qfrq
  is '复函签发日期（取复函信息表）';
comment on column ATFX_HD_YS_BQYHDXX.fuhcs
  is '复函次数（对应复函表中的FHCS）';
comment on column ATFX_HD_YS_BQYHDXX.fhlx_dm
  is '复函类型代码：1-正常业务；2-存在不予退免税发票；3-经核查尚未处理完毕；4-暂缓办理退免税；5-非本地区管辖';
comment on column ATFX_HD_YS_BQYHDXX.ycqx_tree
  is '异常情形（NVL(YCQX_TREE, BYTMSQX_TREE)）';
comment on column ATFX_HD_YS_BQYHDXX.zhbltmsqx
  is '暂缓办理退（免）税情形';
comment on column ATFX_HD_YS_BQYHDXX.sffzchzxswdj
  is '是否为供货企业属于办理税务登记2年内被税务机关认定为非正常户或被登记为增值税一般纳税人2年内注销税务';
comment on column ATFX_HD_YS_BQYHDXX.yqfhyy
  is '延期复函原因';
comment on column ATFX_HD_YS_BQYHDXX.fscfhyy
  is '非首次复函原因';
comment on column ATFX_HD_YS_BQYHDXX.zzhcswclyy_tree
  is '正在核查尚未处理完毕原因列表';
create index IDX_BQYHDXX_FHLX_DM on ATFX_HD_YS_BQYHDXX (FHLX_DM);
create index IDX_BQYHDXX_FH_QFRQ on ATFX_HD_YS_BQYHDXX (FH_QFRQ);
create index IDX_BQYHDXX_FUHXXBUUID on ATFX_HD_YS_BQYHDXX (FUHXXBUUID);
create index IDX_BQYHDXX_FUH_QFRQ on ATFX_HD_YS_BQYHDXX (FUH_QFRQ);
create index IDX_BQYHDXX_GHQYNSRSBH on ATFX_HD_YS_BQYHDXX (GHQYNSRSBH);
create index IDX_BQYHDXX_GHQYNSRSBH1 on ATFX_HD_YS_BQYHDXX (GHQYNSRSBH_1);
alter table ATFX_HD_YS_BQYHDXX
  add constraint PK_ATFX_HD_YS_BQYHDXX primary key (GHFDJXH, FHXXBUUID);
alter table ATFX_HD_YS_BQYHDXX
  add constraint UK_BQYHDXX_WSBH unique (WSBH);

prompt
prompt Creating table ATFX_HD_YS_GYSYCHH
prompt =================================
prompt
create table ATFX_HD_YS_GYSYCHH
(
  hdfpqduuid   VARCHAR2(32) not null,
  djxh         NUMBER(20) not null,
  fhxxbuuid    VARCHAR2(32) not null,
  ghfqymc_1    VARCHAR2(200),
  ghqynsrsbh_1 VARCHAR2(20),
  zzszyfpdmhm  VARCHAR2(20) not null,
  sp_dm        VARCHAR2(20),
  spmc         VARCHAR2(200),
  ggxh         VARCHAR2(100),
  jldw_dm      VARCHAR2(10),
  sl           NUMBER(18,6),
  dj           NUMBER(18,6),
  je           NUMBER(18,2),
  kjrq         DATE,
  fhlx_dm      VARCHAR2(2) default '2' not null,
  ycqx_tree    VARCHAR2(1000),
  fuh_qfrq     DATE
)
;
comment on table ATFX_HD_YS_GYSYCHH
  is '供应商异常回函表（专门存储复函类型为"存在不予退免税发票"的记录）';
comment on column ATFX_HD_YS_GYSYCHH.hdfpqduuid
  is '函调发票清单UUID，主键';
comment on column ATFX_HD_YS_GYSYCHH.djxh
  is '登记序号（本企业登记序号，主要用于筛选和后续数据清理）';
comment on column ATFX_HD_YS_GYSYCHH.fhxxbuuid
  is '发函信息表UUID（用于关联异常业务的回函信息及对应发票）';
comment on column ATFX_HD_YS_GYSYCHH.ghfqymc_1
  is '供货企业名称';
comment on column ATFX_HD_YS_GYSYCHH.ghqynsrsbh_1
  is '供货企业纳税人识别号';
comment on column ATFX_HD_YS_GYSYCHH.zzszyfpdmhm
  is '增值税专用发票代码号码';
comment on column ATFX_HD_YS_GYSYCHH.sp_dm
  is '商品代码';
comment on column ATFX_HD_YS_GYSYCHH.spmc
  is '商品名称';
comment on column ATFX_HD_YS_GYSYCHH.ggxh
  is '规格型号';
comment on column ATFX_HD_YS_GYSYCHH.jldw_dm
  is '计量单位代码';
comment on column ATFX_HD_YS_GYSYCHH.sl
  is '数量';
comment on column ATFX_HD_YS_GYSYCHH.dj
  is '单价';
comment on column ATFX_HD_YS_GYSYCHH.je
  is '金额';
comment on column ATFX_HD_YS_GYSYCHH.kjrq
  is '开具日期';
comment on column ATFX_HD_YS_GYSYCHH.fhlx_dm
  is '复函类型代码（固定为2，表示存在不予退免税发票）';
comment on column ATFX_HD_YS_GYSYCHH.ycqx_tree
  is '异常情形（NVL(YCQX_TREE, BYTMSQX_TREE)）';
comment on column ATFX_HD_YS_GYSYCHH.fuh_qfrq
  is '复函签发日期（取复函信息表）';
create index IDX_GYSYCHH_DJXH on ATFX_HD_YS_GYSYCHH (DJXH);
create index IDX_GYSYCHH_FHXXBUUID on ATFX_HD_YS_GYSYCHH (FHXXBUUID);
create index IDX_GYSYCHH_FUH_QFRQ on ATFX_HD_YS_GYSYCHH (FUH_QFRQ);
create index IDX_GYSYCHH_GHQYNSRSBH1 on ATFX_HD_YS_GYSYCHH (GHQYNSRSBH_1);
create index IDX_GYSYCHH_KJRQ on ATFX_HD_YS_GYSYCHH (KJRQ);
create index IDX_GYSYCHH_ZZSZYFPDMHM on ATFX_HD_YS_GYSYCHH (ZZSZYFPDMHM);
alter table ATFX_HD_YS_GYSYCHH
  add constraint PK_ATFX_HD_YS_GYSYCHH primary key (DJXH, HDFPQDUUID);

prompt
prompt Creating table ATFX_JC_JG_GLQYXX
prompt ================================
prompt
create table ATFX_JC_JG_GLQYXX
(
  djxh           NUMBER(20) not null,
  glqy_nsrsbh    VARCHAR2(20) not null,
  glqy_shxydm    VARCHAR2(18),
  glqy_nsrmc     VARCHAR2(200) not null,
  glqy_djjg_dm   VARCHAR2(11),
  glqy_djrq      DATE,
  glqy_ybnsrrdrq DATE,
  glqy_barq      DATE,
  glqy_nsrzt_dm  VARCHAR2(2),
  glqy_bachrq    DATE,
  glqy_zxrq      DATE,
  glqy_flgldj    VARCHAR2(150),
  glgx_jh        VARCHAR2(200)
)
;
comment on table ATFX_JC_JG_GLQYXX
  is '法人与财务负责人股东关联企业信息表';
comment on column ATFX_JC_JG_GLQYXX.djxh
  is '登记序号';
comment on column ATFX_JC_JG_GLQYXX.glqy_nsrsbh
  is '关联企业纳税人识别号';
comment on column ATFX_JC_JG_GLQYXX.glqy_shxydm
  is '关联企业社会信用代码';
comment on column ATFX_JC_JG_GLQYXX.glqy_nsrmc
  is '关联企业纳税人名称';
comment on column ATFX_JC_JG_GLQYXX.glqy_djjg_dm
  is '关联企业登记机关代码';
comment on column ATFX_JC_JG_GLQYXX.glqy_djrq
  is '关联企业登记日期';
comment on column ATFX_JC_JG_GLQYXX.glqy_ybnsrrdrq
  is '关联企业一般纳税人认定日期';
comment on column ATFX_JC_JG_GLQYXX.glqy_barq
  is '关联企业备案日期';
comment on column ATFX_JC_JG_GLQYXX.glqy_nsrzt_dm
  is '关联企业纳税人状态代码';
comment on column ATFX_JC_JG_GLQYXX.glqy_bachrq
  is '关联企业备案撤回日期';
comment on column ATFX_JC_JG_GLQYXX.glqy_zxrq
  is '关联企业注销日期';
comment on column ATFX_JC_JG_GLQYXX.glqy_flgldj
  is '关联企业分类管理等级';
comment on column ATFX_JC_JG_GLQYXX.glgx_jh
  is '关联关系集合字段';
alter table ATFX_JC_JG_GLQYXX
  add constraint PK_ATFX_JC_JG_GLQYXX primary key (DJXH, GLQY_NSRSBH);

prompt
prompt Creating table ATFX_JC_JG_QYSCCK
prompt ================================
prompt
create table ATFX_JC_JG_QYSCCK
(
  djxh     NUMBER(20) not null,
  scckrq   DATE,
  sctssbrq DATE
)
;
comment on table ATFX_JC_JG_QYSCCK
  is '企业首次出口与申报信息表';
comment on column ATFX_JC_JG_QYSCCK.djxh
  is '登记序号';
comment on column ATFX_JC_JG_QYSCCK.scckrq
  is '首次出口日期';
comment on column ATFX_JC_JG_QYSCCK.sctssbrq
  is '首次退税申报日期';
create index IDX_QYSCCK_SCCKRQ on ATFX_JC_JG_QYSCCK (SCCKRQ);
create index IDX_QYSCCK_SCTSSBRQ on ATFX_JC_JG_QYSCCK (SCTSSBRQ);
alter table ATFX_JC_JG_QYSCCK
  add constraint PK_ATFX_JC_JG_QYSCCK primary key (DJXH);

prompt
prompt Creating table ATFX_JC_JG_SPSCCK
prompt ================================
prompt
create table ATFX_JC_JG_SPSCCK
(
  djxh     NUMBER(20) not null,
  cksp_dm  VARCHAR2(20) not null,
  ckspmc   VARCHAR2(1000),
  scckrq   DATE,
  sctssbrq DATE
)
;
comment on table ATFX_JC_JG_SPSCCK
  is '商品首次出口与申报信息表';
comment on column ATFX_JC_JG_SPSCCK.djxh
  is '登记序号';
comment on column ATFX_JC_JG_SPSCCK.cksp_dm
  is '出口商品代码（前4位）';
comment on column ATFX_JC_JG_SPSCCK.ckspmc
  is '出口商品名称';
comment on column ATFX_JC_JG_SPSCCK.scckrq
  is '首次出口日期';
comment on column ATFX_JC_JG_SPSCCK.sctssbrq
  is '首次退税申报日期';
create index IDX_SPSCCK_CKSP_DM on ATFX_JC_JG_SPSCCK (CKSP_DM);
create index IDX_SPSCCK_DJXH on ATFX_JC_JG_SPSCCK (DJXH);
create index IDX_SPSCCK_SCCKRQ on ATFX_JC_JG_SPSCCK (SCCKRQ);
create index IDX_SPSCCK_SCTSSBRQ on ATFX_JC_JG_SPSCCK (SCTSSBRQ);
alter table ATFX_JC_JG_SPSCCK
  add constraint PK_ATFX_JC_JG_SPSCCK primary key (DJXH, CKSP_DM);

prompt
prompt Creating table ATFX_JC_YS_FLGLXX
prompt ================================
prompt
create table ATFX_JC_YS_FLGLXX
(
  uuid VARCHAR2(32) not null,
  djxh NUMBER(20) not null,
  kznr VARCHAR2(150),
  yxqq DATE not null,
  yxqz DATE
)
;
comment on table ATFX_JC_YS_FLGLXX
  is '出口企业分类管理信息表';
comment on column ATFX_JC_YS_FLGLXX.uuid
  is 'UUID，主键';
comment on column ATFX_JC_YS_FLGLXX.djxh
  is '登记序号';
comment on column ATFX_JC_YS_FLGLXX.kznr
  is '扩展内容';
comment on column ATFX_JC_YS_FLGLXX.yxqq
  is '有效期起';
comment on column ATFX_JC_YS_FLGLXX.yxqz
  is '有效期止';
create index IDX_ATFX_JC_YS_FLGLXX_DJXH on ATFX_JC_YS_FLGLXX (DJXH);
alter table ATFX_JC_YS_FLGLXX
  add constraint PK_ATFX_JC_YS_FLGLXX primary key (UUID);

prompt
prompt Creating table ATFX_JC_YS_GDXX
prompt ==============================
prompt
create table ATFX_JC_YS_GDXX
(
  uuid           VARCHAR2(32) not null,
  djxh           NUMBER(20) not null,
  tzfhhhrmc      VARCHAR2(300) not null,
  tzbl           NUMBER(11,8),
  tzfhhhrzjhm    VARCHAR2(30),
  tzfhhhrzjzl_dm VARCHAR2(3),
  gjhdqsz_dm     VARCHAR2(60),
  tzfjjxz_dm     VARCHAR2(3)
)
;
comment on table ATFX_JC_YS_GDXX
  is '股东信息表';
comment on column ATFX_JC_YS_GDXX.uuid
  is 'UUID，主键';
comment on column ATFX_JC_YS_GDXX.djxh
  is '登记序号，关联企业主表';
comment on column ATFX_JC_YS_GDXX.tzfhhhrmc
  is '投资方（合伙人）名称';
comment on column ATFX_JC_YS_GDXX.tzbl
  is '投资比例（保留6位小数）';
comment on column ATFX_JC_YS_GDXX.tzfhhhrzjhm
  is '投资方（合伙人）证件号码';
comment on column ATFX_JC_YS_GDXX.tzfhhhrzjzl_dm
  is '投资方（合伙人）证件种类代码';
comment on column ATFX_JC_YS_GDXX.gjhdqsz_dm
  is '国家或地区数字代码';
comment on column ATFX_JC_YS_GDXX.tzfjjxz_dm
  is '投资方经济性质代码';
create index IDX_ATFX_JC_YS_GDXX_DJXH on ATFX_JC_YS_GDXX (DJXH);
alter table ATFX_JC_YS_GDXX
  add constraint PK_ATFX_JC_YS_GDXX primary key (UUID);

prompt
prompt Creating table ATFX_JC_YS_JCXXBGJL
prompt ==================================
prompt
create table ATFX_JC_YS_JCXXBGJL
(
  bgdjmxuuid VARCHAR2(32) not null,
  djxh       NUMBER(20) not null,
  bgxm_dm    VARCHAR2(20),
  bgxmmc     VARCHAR2(150) not null,
  bgqnr      VARCHAR2(4000),
  bghnr      VARCHAR2(4000),
  lrrq       DATE not null
)
;
comment on table ATFX_JC_YS_JCXXBGJL
  is '基础信息变更记录表';
comment on column ATFX_JC_YS_JCXXBGJL.bgdjmxuuid
  is '变更登记明细UUID，主键';
comment on column ATFX_JC_YS_JCXXBGJL.djxh
  is '登记序号';
comment on column ATFX_JC_YS_JCXXBGJL.bgxm_dm
  is '变更项目代码';
comment on column ATFX_JC_YS_JCXXBGJL.bgxmmc
  is '变更项目名称';
comment on column ATFX_JC_YS_JCXXBGJL.bgqnr
  is '变更前内容';
comment on column ATFX_JC_YS_JCXXBGJL.bghnr
  is '变更后内容';
comment on column ATFX_JC_YS_JCXXBGJL.lrrq
  is '录入日期';
create index IDX_ATFX_JC_YS_JCXXBGJL_DJXH on ATFX_JC_YS_JCXXBGJL (DJXH);
alter table ATFX_JC_YS_JCXXBGJL
  add constraint PK_ATFX_JC_YS_JCXXBGJL primary key (BGDJMXUUID);

prompt
prompt Creating table ATFX_JC_YS_NSRJCXX
prompt =================================
prompt
create table ATFX_JC_YS_NSRJCXX
(
  djxh           NUMBER(20) not null,
  nsrmc          VARCHAR2(300) not null,
  nsrsbh         VARCHAR2(20) not null,
  shxydm         VARCHAR2(20),
  hgqy_dm        VARCHAR2(20),
  djzclx_dm      VARCHAR2(3),
  cktsqylx_dm    VARCHAR2(2),
  ckhwtmsjsff_dm CHAR(1),
  scjydz         VARCHAR2(300),
  zcdz           VARCHAR2(300),
  jyfw           VARCHAR2(4000),
  djrq           DATE,
  barq           DATE,
  nsrzt_dm       VARCHAR2(2),
  fddbrsfzjhm    VARCHAR2(30),
  fddbrsfzjlx_dm VARCHAR2(3),
  fddbrxm        VARCHAR2(150),
  cwfzrsfzjhm    VARCHAR2(30),
  cwfzrsfzjzl_dm VARCHAR2(3),
  cwfzrxm        VARCHAR2(150),
  cyrs           NUMBER(10),
  fddbrjg        VARCHAR2(100),
  cwfzrjg        VARCHAR2(100)
)
;
comment on table ATFX_JC_YS_NSRJCXX
  is '出口退税企业基础信息表';
comment on column ATFX_JC_YS_NSRJCXX.djxh
  is '登记序号，主键';
comment on column ATFX_JC_YS_NSRJCXX.nsrmc
  is '纳税人名称';
comment on column ATFX_JC_YS_NSRJCXX.nsrsbh
  is '纳税人识别号（18位）';
comment on column ATFX_JC_YS_NSRJCXX.shxydm
  is '社会信用代码（18位）';
comment on column ATFX_JC_YS_NSRJCXX.hgqy_dm
  is '海关企业代码（10位）';
comment on column ATFX_JC_YS_NSRJCXX.djzclx_dm
  is '登记注册类型代码';
comment on column ATFX_JC_YS_NSRJCXX.cktsqylx_dm
  is '出口退税企业类型代码';
comment on column ATFX_JC_YS_NSRJCXX.ckhwtmsjsff_dm
  is '出口货物退(免)税计算方法代码';
comment on column ATFX_JC_YS_NSRJCXX.scjydz
  is '生产经营地址';
comment on column ATFX_JC_YS_NSRJCXX.zcdz
  is '注册地址';
comment on column ATFX_JC_YS_NSRJCXX.jyfw
  is '经营范围';
comment on column ATFX_JC_YS_NSRJCXX.djrq
  is '登记日期（税务登记日期）';
comment on column ATFX_JC_YS_NSRJCXX.barq
  is '备案日期（出口退税备案日期）';
comment on column ATFX_JC_YS_NSRJCXX.nsrzt_dm
  is '纳税人状态代码';
comment on column ATFX_JC_YS_NSRJCXX.fddbrsfzjhm
  is '法定代表人身份证号码';
comment on column ATFX_JC_YS_NSRJCXX.fddbrsfzjlx_dm
  is '法定代表人身份证件类型代码';
comment on column ATFX_JC_YS_NSRJCXX.fddbrxm
  is '法定代表人姓名';
comment on column ATFX_JC_YS_NSRJCXX.cwfzrsfzjhm
  is '财务负责人身份证件号码';
comment on column ATFX_JC_YS_NSRJCXX.cwfzrsfzjzl_dm
  is '财务负责人身份证件种类代码';
comment on column ATFX_JC_YS_NSRJCXX.cwfzrxm
  is '财务负责人姓名';
comment on column ATFX_JC_YS_NSRJCXX.cyrs
  is '从业人数（来源于税务登记信息）';
comment on column ATFX_JC_YS_NSRJCXX.fddbrjg
  is '法人代表人籍贯';
comment on column ATFX_JC_YS_NSRJCXX.cwfzrjg
  is '财务负责人籍贯';
alter table ATFX_JC_YS_NSRJCXX
  add constraint PK_ATFX_JC_YS_NSRJCXX_DJXH primary key (DJXH);
alter table ATFX_JC_YS_NSRJCXX
  add constraint UK_ATFX_JC_YS_NSRJCXX_NSRSBH unique (NSRSBH);

prompt
prompt Creating table ATFX_JC_YS_NSRZGRD
prompt =================================
prompt
create table ATFX_JC_YS_NSRZGRD
(
  rdpzuuid   VARCHAR2(32) not null,
  djxh       NUMBER(20) not null,
  nsrzglx_dm VARCHAR2(3) not null,
  nsrzglxmc  VARCHAR2(100) not null,
  yxqq       DATE not null,
  yxqz       DATE
)
;
comment on table ATFX_JC_YS_NSRZGRD
  is '纳税人资格认定信息表';
comment on column ATFX_JC_YS_NSRZGRD.rdpzuuid
  is '认定凭证UUID，主键';
comment on column ATFX_JC_YS_NSRZGRD.djxh
  is '登记序号，关联企业主表';
comment on column ATFX_JC_YS_NSRZGRD.nsrzglx_dm
  is '纳税人资格类型代码';
comment on column ATFX_JC_YS_NSRZGRD.nsrzglxmc
  is '纳税人资格类型名称';
comment on column ATFX_JC_YS_NSRZGRD.yxqq
  is '有效期起';
comment on column ATFX_JC_YS_NSRZGRD.yxqz
  is '有效期止（取YXQZ和SJZZRQ较小者）';
create index IDX_ATFX_JC_YS_NSRZGRD_DJXH on ATFX_JC_YS_NSRZGRD (DJXH);
alter table ATFX_JC_YS_NSRZGRD
  add constraint PK_ATFX_JC_YS_NSRZGRD primary key (RDPZUUID);

prompt
prompt Creating table ATFX_NS_YS_LRB
prompt =============================
prompt
create table ATFX_NS_YS_LRB
(
  uuid      VARCHAR2(32) not null,
  djxh      NUMBER(20) not null,
  skssqq    DATE not null,
  skssqz    DATE not null,
  kjzdzz_dm VARCHAR2(20),
  bys_yysr  NUMBER(20,2),
  bys_yycb  NUMBER(20,2),
  bys_sjjfj NUMBER(20,2),
  bys_glfy  NUMBER(20,2),
  bys_cwfy  NUMBER(20,2),
  bys_yyfy  NUMBER(20,2),
  bys_tzsy  NUMBER(20,2),
  bys_yylr  NUMBER(20,2),
  bys_yywsr NUMBER(20,2),
  bys_yywzc NUMBER(20,2),
  bys_lrze  NUMBER(20,2),
  bys_sds   NUMBER(20,2),
  bys_jlr   NUMBER(20,2)
)
;
comment on table ATFX_NS_YS_LRB
  is '利润表';
comment on column ATFX_NS_YS_LRB.uuid
  is 'UUID，主键';
comment on column ATFX_NS_YS_LRB.djxh
  is '登记序号';
comment on column ATFX_NS_YS_LRB.skssqq
  is '税款所属期起（格式YYYYMM）';
comment on column ATFX_NS_YS_LRB.skssqz
  is '税款所属期止（格式YYYYMM）';
comment on column ATFX_NS_YS_LRB.kjzdzz_dm
  is '会计制度（准则）代码（根据财务数据的来源表加工，涉及投资收益是否计入营业利润）';
comment on column ATFX_NS_YS_LRB.bys_yysr
  is '本月数_营业收入';
comment on column ATFX_NS_YS_LRB.bys_yycb
  is '本月数_营业成本';
comment on column ATFX_NS_YS_LRB.bys_sjjfj
  is '本月数_税金及附加';
comment on column ATFX_NS_YS_LRB.bys_glfy
  is '本月数_管理费用';
comment on column ATFX_NS_YS_LRB.bys_cwfy
  is '本月数_财务费用';
comment on column ATFX_NS_YS_LRB.bys_yyfy
  is '本月数_营业费用';
comment on column ATFX_NS_YS_LRB.bys_tzsy
  is '本月数_投资收益';
comment on column ATFX_NS_YS_LRB.bys_yylr
  is '本月数_营业利润';
comment on column ATFX_NS_YS_LRB.bys_yywsr
  is '本月数_营业外收入';
comment on column ATFX_NS_YS_LRB.bys_yywzc
  is '本月数_营业外支出';
comment on column ATFX_NS_YS_LRB.bys_lrze
  is '本月数_利润总额';
comment on column ATFX_NS_YS_LRB.bys_sds
  is '本月数_所得税费用';
comment on column ATFX_NS_YS_LRB.bys_jlr
  is '本月数_净利润';
create index IDX_LRB_DJXH on ATFX_NS_YS_LRB (DJXH);
create index IDX_LRB_KJZDZZ_DM on ATFX_NS_YS_LRB (KJZDZZ_DM);
create index IDX_LRB_SKSSQQ_SKSSQZ on ATFX_NS_YS_LRB (SKSSQQ, SKSSQZ);
alter table ATFX_NS_YS_LRB
  add constraint PK_ATFX_NS_YS_LRB primary key (UUID);

prompt
prompt Creating table ATFX_NS_YS_SDSSBB
prompt ================================
prompt
create table ATFX_NS_YS_SDSSBB
(
  uuid     VARCHAR2(32) not null,
  djxh     NUMBER(20) not null,
  skssqq   DATE not null,
  skssqz   DATE not null,
  sbuuid   VARCHAR2(32),
  yysr     NUMBER(20,2),
  ynssde   NUMBER(20,2),
  ynqysdse NUMBER(20,2),
  cyrs     NUMBER(10),
  gdzc_1   NUMBER(20,2),
  gdzc_2   NUMBER(20,2),
  gdzc_3   NUMBER(20,2),
  gdzc_4   NUMBER(20,2),
  gdzc_5   NUMBER(20,2),
  gdzc_6   NUMBER(20,2),
  gdzc_7   NUMBER(20,2)
)
;
comment on table ATFX_NS_YS_SDSSBB
  is '企业所得税年度纳税申报表';
comment on column ATFX_NS_YS_SDSSBB.uuid
  is 'UUID，主键';
comment on column ATFX_NS_YS_SDSSBB.djxh
  is '登记序号';
comment on column ATFX_NS_YS_SDSSBB.skssqq
  is '税款所属期起（格式YYYYMM）';
comment on column ATFX_NS_YS_SDSSBB.skssqz
  is '税款所属期止（格式YYYYMM）';
comment on column ATFX_NS_YS_SDSSBB.sbuuid
  is '申报UUID';
comment on column ATFX_NS_YS_SDSSBB.yysr
  is '营业收入';
comment on column ATFX_NS_YS_SDSSBB.ynssde
  is '应纳税所得额';
comment on column ATFX_NS_YS_SDSSBB.ynqysdse
  is '应纳企业所得税额';
comment on column ATFX_NS_YS_SDSSBB.cyrs
  is '从业人数（所得税年度申报）';
comment on column ATFX_NS_YS_SDSSBB.gdzc_1
  is '一、固定资产（2+3+4+5+6+7）';
comment on column ATFX_NS_YS_SDSSBB.gdzc_2
  is '（一）房屋、建筑物';
comment on column ATFX_NS_YS_SDSSBB.gdzc_3
  is '（二）飞机、火车、轮船、机器、机械和其他生产设备';
comment on column ATFX_NS_YS_SDSSBB.gdzc_4
  is '（三）与生产经营活动有关的器具、工具、家具等';
comment on column ATFX_NS_YS_SDSSBB.gdzc_5
  is '（四）飞机、火车、轮船以外的运输工具';
comment on column ATFX_NS_YS_SDSSBB.gdzc_6
  is '（五）电子设备';
comment on column ATFX_NS_YS_SDSSBB.gdzc_7
  is '（六）其他';
create index IDX_SDSSBB_DJXH on ATFX_NS_YS_SDSSBB (DJXH);
create index IDX_SDSSBB_SBUUID on ATFX_NS_YS_SDSSBB (SBUUID);
create index IDX_SDSSBB_SKSSQQ_SKSSQZ on ATFX_NS_YS_SDSSBB (SKSSQQ, SKSSQZ);
alter table ATFX_NS_YS_SDSSBB
  add constraint PK_ATFX_NS_YS_SDSSBB primary key (UUID);

prompt
prompt Creating table ATFX_NS_YS_ZCFZB
prompt ===============================
prompt
create table ATFX_NS_YS_ZCFZB
(
  uuid              VARCHAR2(32) not null,
  djxh              NUMBER(20) not null,
  skssqq            DATE not null,
  skssqz            DATE not null,
  kjzdzz_dm         VARCHAR2(20),
  ncs_zc_hbzj       NUMBER(20,2),
  qms_zc_hbzj       NUMBER(20,2),
  ncs_zc_yspj       NUMBER(20,2),
  qms_zc_yspj       NUMBER(20,2),
  ncs_zc_yszk       NUMBER(20,2),
  qms_zc_yszk       NUMBER(20,2),
  ncs_zc_yufzk      NUMBER(20,2),
  qms_zc_yufzk      NUMBER(20,2),
  ncs_zc_qtysk      NUMBER(20,2),
  qms_zc_qtysk      NUMBER(20,2),
  ncs_zc_ch         NUMBER(20,2),
  qms_zc_ch         NUMBER(20,2),
  ncs_zc_qtldzc     NUMBER(20,2),
  qms_zc_qtldzc     NUMBER(20,2),
  ncs_zc_ldzchj     NUMBER(20,2),
  qms_zc_ldzchj     NUMBER(20,2),
  ncs_zc_cqgqtz     NUMBER(20,2),
  qms_zc_cqgqtz     NUMBER(20,2),
  ncs_zc_gdzcyz     NUMBER(20,2),
  qms_zc_gdzcyz     NUMBER(20,2),
  ncs_zc_zjgc       NUMBER(20,2),
  qms_zc_zjgc       NUMBER(20,2),
  ncs_zc_wxzc       NUMBER(20,2),
  qms_zc_wxzc       NUMBER(20,2),
  ncs_zc_cqdtfy     NUMBER(20,2),
  qms_zc_cqdtfy     NUMBER(20,2),
  ncs_zc_zchj       NUMBER(20,2),
  qms_zc_zchj       NUMBER(20,2),
  ncs_qy_dqjk       NUMBER(20,2),
  qms_qy_dqjk       NUMBER(20,2),
  ncs_qy_yfpj       NUMBER(20,2),
  qms_qy_yfpj       NUMBER(20,2),
  ncs_qy_yfzk       NUMBER(20,2),
  qms_qy_yfzk       NUMBER(20,2),
  ncs_qy_yuszk      NUMBER(20,2),
  qms_qy_yuszk      NUMBER(20,2),
  ncs_qy_yfgz       NUMBER(20,2),
  qms_qy_yfgz       NUMBER(20,2),
  ncs_qy_yjsj       NUMBER(20,2),
  qms_qy_yjsj       NUMBER(20,2),
  ncs_qy_qtyfk      NUMBER(20,2),
  qms_qy_qtyfk      NUMBER(20,2),
  ncs_qy_qtldfz     NUMBER(20,2),
  qms_qy_qtldfz     NUMBER(20,2),
  ncs_qy_ldfzhj     NUMBER(20,2),
  qms_qy_ldfzhj     NUMBER(20,2),
  ncs_qy_cqjk       NUMBER(20,2),
  qms_qy_cqjk       NUMBER(20,2),
  ncs_qy_cqyfk      NUMBER(20,2),
  qms_qy_cqyfk      NUMBER(20,2),
  ncs_qy_fzhj       NUMBER(20,2),
  qms_qy_fzhj       NUMBER(20,2),
  ncs_qy_sszb       NUMBER(20,2),
  qms_qy_sszb       NUMBER(20,2),
  ncs_qy_zbgj       NUMBER(20,2),
  qms_qy_zbgj       NUMBER(20,2),
  ncs_qy_yyzj       NUMBER(20,2),
  qms_qy_yyzj       NUMBER(20,2),
  ncs_qy_wfplr      NUMBER(20,2),
  qms_qy_wfplr      NUMBER(20,2),
  ncs_qy_syzqyhj    NUMBER(20,2),
  qms_qy_syzqyhj    NUMBER(20,2),
  ncs_qy_fzysyzqyhj NUMBER(20,2),
  qms_qy_fzysyzqyhj NUMBER(20,2)
)
;
comment on table ATFX_NS_YS_ZCFZB
  is '资产负债表';
comment on column ATFX_NS_YS_ZCFZB.uuid
  is 'UUID，主键';
comment on column ATFX_NS_YS_ZCFZB.djxh
  is '登记序号';
comment on column ATFX_NS_YS_ZCFZB.skssqq
  is '税款所属期起（格式YYYYMM）';
comment on column ATFX_NS_YS_ZCFZB.skssqz
  is '税款所属期止（格式YYYYMM）';
comment on column ATFX_NS_YS_ZCFZB.kjzdzz_dm
  is '会计制度（准则）代码（根据财务数据的来源表加工）';
comment on column ATFX_NS_YS_ZCFZB.ncs_zc_hbzj
  is '年初数_资产_货币资金';
comment on column ATFX_NS_YS_ZCFZB.qms_zc_hbzj
  is '期末数_资产_货币资金';
comment on column ATFX_NS_YS_ZCFZB.ncs_zc_yspj
  is '年初数_资产_应收票据';
comment on column ATFX_NS_YS_ZCFZB.qms_zc_yspj
  is '期末数_资产_应收票据';
comment on column ATFX_NS_YS_ZCFZB.ncs_zc_yszk
  is '年初数_资产_应收账款';
comment on column ATFX_NS_YS_ZCFZB.qms_zc_yszk
  is '期末数_资产_应收账款';
comment on column ATFX_NS_YS_ZCFZB.ncs_zc_yufzk
  is '年初数_资产_预付账款';
comment on column ATFX_NS_YS_ZCFZB.qms_zc_yufzk
  is '期末数_资产_预付账款';
comment on column ATFX_NS_YS_ZCFZB.ncs_zc_qtysk
  is '年初数_资产_其他应收款';
comment on column ATFX_NS_YS_ZCFZB.qms_zc_qtysk
  is '期末数_资产_其他应收款';
comment on column ATFX_NS_YS_ZCFZB.ncs_zc_ch
  is '年初数_资产_存货';
comment on column ATFX_NS_YS_ZCFZB.qms_zc_ch
  is '期末数_资产_存货';
comment on column ATFX_NS_YS_ZCFZB.ncs_zc_qtldzc
  is '年初数_资产_其他流动资产';
comment on column ATFX_NS_YS_ZCFZB.qms_zc_qtldzc
  is '期末数_资产_其他流动资产';
comment on column ATFX_NS_YS_ZCFZB.ncs_zc_ldzchj
  is '年初数_资产_流动资产合计';
comment on column ATFX_NS_YS_ZCFZB.qms_zc_ldzchj
  is '期末数_资产_流动资产合计';
comment on column ATFX_NS_YS_ZCFZB.ncs_zc_cqgqtz
  is '年初数_资产_长期股权投资';
comment on column ATFX_NS_YS_ZCFZB.qms_zc_cqgqtz
  is '期末数_资产_长期股权投资';
comment on column ATFX_NS_YS_ZCFZB.ncs_zc_gdzcyz
  is '年初数_资产_固定资产原值（资产负债表）';
comment on column ATFX_NS_YS_ZCFZB.qms_zc_gdzcyz
  is '期末数_资产_固定资产原值（资产负债表）';
comment on column ATFX_NS_YS_ZCFZB.ncs_zc_zjgc
  is '年初数_资产_在建工程';
comment on column ATFX_NS_YS_ZCFZB.qms_zc_zjgc
  is '期末数_资产_在建工程';
comment on column ATFX_NS_YS_ZCFZB.ncs_zc_wxzc
  is '年初数_资产_无形资产';
comment on column ATFX_NS_YS_ZCFZB.qms_zc_wxzc
  is '期末数_资产_无形资产';
comment on column ATFX_NS_YS_ZCFZB.ncs_zc_cqdtfy
  is '年初数_资产_长期待摊费用';
comment on column ATFX_NS_YS_ZCFZB.qms_zc_cqdtfy
  is '期末数_资产_长期待摊费用';
comment on column ATFX_NS_YS_ZCFZB.ncs_zc_zchj
  is '年初数_资产_资产合计';
comment on column ATFX_NS_YS_ZCFZB.qms_zc_zchj
  is '期末数_资产_资产合计';
comment on column ATFX_NS_YS_ZCFZB.ncs_qy_dqjk
  is '年初数_权益_短期借款';
comment on column ATFX_NS_YS_ZCFZB.qms_qy_dqjk
  is '期末数_权益_短期借款';
comment on column ATFX_NS_YS_ZCFZB.ncs_qy_yfpj
  is '年初数_权益_应付票据';
comment on column ATFX_NS_YS_ZCFZB.qms_qy_yfpj
  is '期末数_权益_应付票据';
comment on column ATFX_NS_YS_ZCFZB.ncs_qy_yfzk
  is '年初数_权益_应付账款';
comment on column ATFX_NS_YS_ZCFZB.qms_qy_yfzk
  is '期末数_权益_应付账款';
comment on column ATFX_NS_YS_ZCFZB.ncs_qy_yuszk
  is '年初数_权益_预收账款';
comment on column ATFX_NS_YS_ZCFZB.qms_qy_yuszk
  is '期末数_权益_预收账款';
comment on column ATFX_NS_YS_ZCFZB.ncs_qy_yfgz
  is '年初数_权益_应付工资';
comment on column ATFX_NS_YS_ZCFZB.qms_qy_yfgz
  is '期末数_权益_应付工资';
comment on column ATFX_NS_YS_ZCFZB.ncs_qy_yjsj
  is '年初数_权益_应交税金';
comment on column ATFX_NS_YS_ZCFZB.qms_qy_yjsj
  is '期末数_权益_应交税金';
comment on column ATFX_NS_YS_ZCFZB.ncs_qy_qtyfk
  is '年初数_权益_其他应付款';
comment on column ATFX_NS_YS_ZCFZB.qms_qy_qtyfk
  is '期末数_权益_其他应付款';
comment on column ATFX_NS_YS_ZCFZB.ncs_qy_qtldfz
  is '年初数_权益_其他流动负债';
comment on column ATFX_NS_YS_ZCFZB.qms_qy_qtldfz
  is '期末数_权益_其他流动负债';
comment on column ATFX_NS_YS_ZCFZB.ncs_qy_ldfzhj
  is '年初数_权益_流动负债合计';
comment on column ATFX_NS_YS_ZCFZB.qms_qy_ldfzhj
  is '期末数_权益_流动负债合计';
comment on column ATFX_NS_YS_ZCFZB.ncs_qy_cqjk
  is '年初数_权益_长期借款';
comment on column ATFX_NS_YS_ZCFZB.qms_qy_cqjk
  is '期末数_权益_长期借款';
comment on column ATFX_NS_YS_ZCFZB.ncs_qy_cqyfk
  is '年初数_权益_长期应付款';
comment on column ATFX_NS_YS_ZCFZB.qms_qy_cqyfk
  is '期末数_权益_长期应付款';
comment on column ATFX_NS_YS_ZCFZB.ncs_qy_fzhj
  is '年初数_权益_负债合计';
comment on column ATFX_NS_YS_ZCFZB.qms_qy_fzhj
  is '期末数_权益_负债合计';
comment on column ATFX_NS_YS_ZCFZB.ncs_qy_sszb
  is '年初数_权益_实收资本(或股本)';
comment on column ATFX_NS_YS_ZCFZB.qms_qy_sszb
  is '期末数_权益_实收资本(或股本)';
comment on column ATFX_NS_YS_ZCFZB.ncs_qy_zbgj
  is '年初数_权益_资本公积';
comment on column ATFX_NS_YS_ZCFZB.qms_qy_zbgj
  is '期末数_权益_资本公积';
comment on column ATFX_NS_YS_ZCFZB.ncs_qy_yyzj
  is '年初数_权益_盈余公积';
comment on column ATFX_NS_YS_ZCFZB.qms_qy_yyzj
  is '期末数_权益_盈余公积';
comment on column ATFX_NS_YS_ZCFZB.ncs_qy_wfplr
  is '年初数_权益_未分配利润';
comment on column ATFX_NS_YS_ZCFZB.qms_qy_wfplr
  is '期末数_权益_未分配利润';
comment on column ATFX_NS_YS_ZCFZB.ncs_qy_syzqyhj
  is '年初数_权益_所有者权益(或股东权益)合计';
comment on column ATFX_NS_YS_ZCFZB.qms_qy_syzqyhj
  is '期末数_权益_所有者权益(或股东权益)合计';
comment on column ATFX_NS_YS_ZCFZB.ncs_qy_fzysyzqyhj
  is '年初数_权益_负债和所有者权益(或股东权益)总计';
comment on column ATFX_NS_YS_ZCFZB.qms_qy_fzysyzqyhj
  is '期末数_权益_负债和所有者权益(或股东权益)总计';
create index IDX_ZCFZB_DJXH on ATFX_NS_YS_ZCFZB (DJXH);
create index IDX_ZCFZB_KJZDZZ_DM on ATFX_NS_YS_ZCFZB (KJZDZZ_DM);
create index IDX_ZCFZB_SKSSQQ_SKSSQZ on ATFX_NS_YS_ZCFZB (SKSSQQ, SKSSQZ);
alter table ATFX_NS_YS_ZCFZB
  add constraint PK_ATFX_NS_YS_ZCFZB primary key (UUID);

prompt
prompt Creating table ATFX_NS_YS_ZZSSBB
prompt ================================
prompt
create table ATFX_NS_YS_ZZSSBB
(
  uuid           VARCHAR2(32) not null,
  djxh           NUMBER(20) not null,
  skssqq         DATE not null,
  skssqz         DATE not null,
  sbuuid         VARCHAR2(32),
  ewblxh         NUMBER(5),
  asysljsxse     NUMBER(18,2),
  yshwxse        NUMBER(18,2),
  yslwxse        NUMBER(18,2),
  sysl_nsjctzxse NUMBER(18,2),
  ajybfjsxse     NUMBER(18,2),
  jybf_nsjctzxse NUMBER(18,2),
  mdtbfckxse     NUMBER(18,2),
  msxse          NUMBER(18,2),
  mshwxse        NUMBER(18,2),
  mslwxse        NUMBER(18,2),
  xxse           NUMBER(18,2),
  jxse           NUMBER(18,2),
  sqldse         NUMBER(18,2),
  jxsezc         NUMBER(18,2),
  mdtytse        NUMBER(18,2),
  sysl_nsjcybjse NUMBER(18,2),
  ydksehj        NUMBER(18,2),
  sjdkse         NUMBER(18,2),
  ynse           NUMBER(18,2),
  qmldse         NUMBER(18,2),
  jybf_ynse      NUMBER(18,2),
  jybf_nsjcybjse NUMBER(18,2),
  ynsejze        NUMBER(18,2),
  ynsehj         NUMBER(18,2)
)
;
comment on table ATFX_NS_YS_ZZSSBB
  is '增值税一般纳税人申报表';
comment on column ATFX_NS_YS_ZZSSBB.uuid
  is 'UUID，主键';
comment on column ATFX_NS_YS_ZZSSBB.djxh
  is '登记序号';
comment on column ATFX_NS_YS_ZZSSBB.skssqq
  is '税款所属期起（格式YYYYMM）';
comment on column ATFX_NS_YS_ZZSSBB.skssqz
  is '税款所属期止（格式YYYYMM）';
comment on column ATFX_NS_YS_ZZSSBB.sbuuid
  is '申报UUID';
comment on column ATFX_NS_YS_ZZSSBB.ewblxh
  is '二维表列序号';
comment on column ATFX_NS_YS_ZZSSBB.asysljsxse
  is '按适用税率计税销售额';
comment on column ATFX_NS_YS_ZZSSBB.yshwxse
  is '应税货物销售额';
comment on column ATFX_NS_YS_ZZSSBB.yslwxse
  is '应税劳务销售额';
comment on column ATFX_NS_YS_ZZSSBB.sysl_nsjctzxse
  is '纳税检查调整的销售额_适用税率';
comment on column ATFX_NS_YS_ZZSSBB.ajybfjsxse
  is '按简易办法计税销售额';
comment on column ATFX_NS_YS_ZZSSBB.jybf_nsjctzxse
  is '纳税检查调整的销售额_简易办法';
comment on column ATFX_NS_YS_ZZSSBB.mdtbfckxse
  is '免抵退办法出口销售额';
comment on column ATFX_NS_YS_ZZSSBB.msxse
  is '免税销售额';
comment on column ATFX_NS_YS_ZZSSBB.mshwxse
  is '免税货物销售额';
comment on column ATFX_NS_YS_ZZSSBB.mslwxse
  is '免税劳务销售额';
comment on column ATFX_NS_YS_ZZSSBB.xxse
  is '销项税额';
comment on column ATFX_NS_YS_ZZSSBB.jxse
  is '进项税额';
comment on column ATFX_NS_YS_ZZSSBB.sqldse
  is '上期留抵税额';
comment on column ATFX_NS_YS_ZZSSBB.jxsezc
  is '进项税额转出';
comment on column ATFX_NS_YS_ZZSSBB.mdtytse
  is '免、抵、退应退税额';
comment on column ATFX_NS_YS_ZZSSBB.sysl_nsjcybjse
  is '按适用税率计算的纳税检查应补缴税额';
comment on column ATFX_NS_YS_ZZSSBB.ydksehj
  is '应抵扣税额合计';
comment on column ATFX_NS_YS_ZZSSBB.sjdkse
  is '实际抵扣税额';
comment on column ATFX_NS_YS_ZZSSBB.ynse
  is '应纳税额';
comment on column ATFX_NS_YS_ZZSSBB.qmldse
  is '期末留抵税额';
comment on column ATFX_NS_YS_ZZSSBB.jybf_ynse
  is '简易计税办法计算的应纳税额';
comment on column ATFX_NS_YS_ZZSSBB.jybf_nsjcybjse
  is '按简易计税办法计算的纳税检查应补缴税额';
comment on column ATFX_NS_YS_ZZSSBB.ynsejze
  is '应纳税额减征额';
comment on column ATFX_NS_YS_ZZSSBB.ynsehj
  is '应纳税额合计';
create index IDX_ZZSSBB_DJXH on ATFX_NS_YS_ZZSSBB (DJXH);
create index IDX_ZZSSBB_EWBLXH on ATFX_NS_YS_ZZSSBB (EWBLXH);
create index IDX_ZZSSBB_SBUUID on ATFX_NS_YS_ZZSSBB (SBUUID);
create index IDX_ZZSSBB_SKSSQQ_SKSSQZ on ATFX_NS_YS_ZZSSBB (SKSSQQ, SKSSQZ);
alter table ATFX_NS_YS_ZZSSBB
  add constraint PK_ATFX_NS_YS_ZZSSBB primary key (UUID);

prompt
prompt Creating table ATFX_QT_YS_JICHAXX
prompt =================================
prompt
create table ATFX_QT_YS_JICHAXX
(
  jcajxxuuid VARCHAR2(32) not null,
  djxh       NUMBER(20) not null,
  nsrsbh     VARCHAR2(20) not null,
  nsrmc      VARCHAR2(200) not null,
  jcajbh     VARCHAR2(50) not null,
  ajmc       VARCHAR2(500),
  lasqrq     DATE,
  larq       DATE,
  jarq       DATE,
  jcssqjq    DATE,
  jcssqjz    DATE,
  ajjczt_dm  VARCHAR2(10),
  sxsswfxw   VARCHAR2(2000),
  xafxjlayj  VARCHAR2(4000)
)
;
comment on table ATFX_QT_YS_JICHAXX
  is ' 稽查信息表：存储税收稽查案件的基础信息、时间节点、违法事实及立案依据，支撑稽查业务管理与数据统计 ';
comment on column ATFX_QT_YS_JICHAXX.jcajxxuuid
  is ' 稽查案件信息 UUID：案件全局唯一标识，用于跨表关联 ';
comment on column ATFX_QT_YS_JICHAXX.djxh
  is ' 登记序号：关联企业登记信息表，定位案件所属企业 ';
comment on column ATFX_QT_YS_JICHAXX.nsrsbh
  is ' 纳税人识别号：纳税人唯一税务编码，如统一社会信用代码 ';
comment on column ATFX_QT_YS_JICHAXX.nsrmc
  is ' 纳税人名称：纳税人法定全称，与营业执照一致 ';
comment on column ATFX_QT_YS_JICHAXX.jcajbh
  is ' 稽查案件编号：税务机关分配的案件唯一编号，遵循稽查文书编码规则 ';
comment on column ATFX_QT_YS_JICHAXX.ajmc
  is ' 案件名称：概括案件核心要素，含纳税人、时段、税种等信息 ';
comment on column ATFX_QT_YS_JICHAXX.lasqrq
  is ' 立案申请日期：提交立案申请的具体日期 ';
comment on column ATFX_QT_YS_JICHAXX.larq
  is ' 立案日期：批准立案的日期，标志稽查流程启动 ';
comment on column ATFX_QT_YS_JICHAXX.jarq
  is ' 结案日期：案件完成稽查并归档的日期 ';
comment on column ATFX_QT_YS_JICHAXX.jcssqjq
  is ' 检查所属期间起：稽查覆盖的税款所属期起始，格式 YYYYMM';
comment on column ATFX_QT_YS_JICHAXX.jcssqjz
  is ' 检查所属期间止：稽查覆盖的税款所属期结束，格式 YYYYMM';
comment on column ATFX_QT_YS_JICHAXX.ajjczt_dm
  is ' 案件稽查状态代码：标识案件当前流程阶段，关联系统状态字典表 ';
comment on column ATFX_QT_YS_JICHAXX.sxsswfxw
  is ' 涉嫌税收违法行为：记录违法类型、具体行为及初步证据描述 ';
comment on column ATFX_QT_YS_JICHAXX.xafxjlayj
  is ' 选案分析及立案依据：选案风险分析结论、立案的法律法规及事实依据 ';
create index IDX_JICHAXX_AJJCZT on ATFX_QT_YS_JICHAXX (AJJCZT_DM);
create index IDX_JICHAXX_DJXH on ATFX_QT_YS_JICHAXX (DJXH);
create index IDX_JICHAXX_JCSSQJ on ATFX_QT_YS_JICHAXX (JCSSQJQ, JCSSQJZ);
create index IDX_JICHAXX_LARQ on ATFX_QT_YS_JICHAXX (LARQ);
create index IDX_JICHAXX_NSRSBH on ATFX_QT_YS_JICHAXX (NSRSBH);
alter table ATFX_QT_YS_JICHAXX
  add constraint PK_ATFX_QT_YS_JICHAXX primary key (JCAJXXUUID);
alter table ATFX_QT_YS_JICHAXX
  add constraint UK_JICHAXX_JCAJBH unique (JCAJBH);

prompt
prompt Creating table ATFX_QT_YS_XZCFXX
prompt ================================
prompt
create table ATFX_QT_YS_XZCFXX
(
  swxzcfjdsuuid VARCHAR2(32) not null,
  sswfxwdjuuid  VARCHAR2(32) not null,
  djxh          NUMBER(20) not null,
  wh            VARCHAR2(100) not null,
  wszzrq        DATE not null,
  jcssqq        DATE,
  jcssqz        DATE,
  wfss          VARCHAR2(4000),
  wfsd          VARCHAR2(4000),
  swxzcfyj      VARCHAR2(4000),
  cfjd          VARCHAR2(4000),
  yjfkje        NUMBER(20,2),
  sjlx          VARCHAR2(30)
)
;
comment on table ATFX_QT_YS_XZCFXX
  is '行政处罚信息表';
comment on column ATFX_QT_YS_XZCFXX.swxzcfjdsuuid
  is '税务行政处罚决定书UUID';
comment on column ATFX_QT_YS_XZCFXX.sswfxwdjuuid
  is '税收违法行为登记UUID';
comment on column ATFX_QT_YS_XZCFXX.djxh
  is '登记序号';
comment on column ATFX_QT_YS_XZCFXX.wh
  is '文号';
comment on column ATFX_QT_YS_XZCFXX.wszzrq
  is '文书制作日期';
comment on column ATFX_QT_YS_XZCFXX.jcssqq
  is '检查所属期起,简易/不予处罚场景为NULL';
comment on column ATFX_QT_YS_XZCFXX.jcssqz
  is '检查所属期止,不予处罚场景为NULL';
comment on column ATFX_QT_YS_XZCFXX.wfss
  is '违法事实:不予处罚取JCNR（检查内容）';
comment on column ATFX_QT_YS_XZCFXX.wfsd
  is '违法手段：简易处罚取WFSD_DM对应的字典名称；不予处罚场景填NULL';
comment on column ATFX_QT_YS_XZCFXX.swxzcfyj
  is '税务行政处罚依据：简易处罚取CFYJ字段值；不予处罚取YJ_1字段值';
comment on column ATFX_QT_YS_XZCFXX.cfjd
  is '处罚决定：不予处罚取BYCFLY（不予处罚理由）';
comment on column ATFX_QT_YS_XZCFXX.yjfkje
  is '应缴罚款金额：简易处罚取FK_1字段值，不予处罚场景为NULL';
comment on column ATFX_QT_YS_XZCFXX.sjlx
  is '数据类型：处罚决定/简易处罚决定/不予处罚决定';
create index IDX_XZCFXX_DJXH on ATFX_QT_YS_XZCFXX (DJXH);
alter table ATFX_QT_YS_XZCFXX
  add constraint PK_ATFX_QT_YS_XZCFXX primary key (SWXZCFJDSUUID, SSWFXWDJUUID);

prompt
prompt Creating table ATFX_SH_JG_AFHGJTJ
prompt =================================
prompt
create table ATFX_SH_JG_AFHGJTJ
(
  djxh         NUMBER(20) not null,
  ckshny       VARCHAR2(6) not null,
  hggjhdqsz_dm VARCHAR2(3) not null,
  ckshjemy     NUMBER(20,2),
  ckshjermb    NUMBER(20,2),
  ckshhbzm_dm  VARCHAR2(6) not null
)
;
comment on table ATFX_SH_JG_AFHGJTJ
  is '按付汇国家统计数据';
comment on column ATFX_SH_JG_AFHGJTJ.djxh
  is '登记序号';
comment on column ATFX_SH_JG_AFHGJTJ.ckshny
  is '出口收汇年月';
comment on column ATFX_SH_JG_AFHGJTJ.hggjhdqsz_dm
  is '海关国家和地区数字代码';
comment on column ATFX_SH_JG_AFHGJTJ.ckshjemy
  is '出口收汇金额（美元）';
comment on column ATFX_SH_JG_AFHGJTJ.ckshjermb
  is '出口收汇金额（人民币）';
comment on column ATFX_SH_JG_AFHGJTJ.ckshhbzm_dm
  is '出口收汇货币字母代码';
alter table ATFX_SH_JG_AFHGJTJ
  add constraint PK_ATFX_SH_JG_AFHGJTJ primary key (DJXH, CKSHNY, HGGJHDQSZ_DM, CKSHHBZM_DM);

prompt
prompt Creating table ATFX_SH_JG_ANYTJ
prompt ===============================
prompt
create table ATFX_SH_JG_ANYTJ
(
  djxh      NUMBER(20) not null,
  ckshny    VARCHAR2(6) not null,
  ckshjemy  NUMBER(20,2),
  ckshjermb NUMBER(20,2),
  qzkjrmbje NUMBER(20,2)
)
;
comment on table ATFX_SH_JG_ANYTJ
  is '按年月统计收汇数据';
comment on column ATFX_SH_JG_ANYTJ.djxh
  is '登记序号';
comment on column ATFX_SH_JG_ANYTJ.ckshny
  is '出口收汇年月';
comment on column ATFX_SH_JG_ANYTJ.ckshjemy
  is '出口收汇金额（美元）';
comment on column ATFX_SH_JG_ANYTJ.ckshjermb
  is '出口收汇金额（人民币）';
comment on column ATFX_SH_JG_ANYTJ.qzkjrmbje
  is '其中跨境人民币金额';
alter table ATFX_SH_JG_ANYTJ
  add constraint PK_ATFX_SH_JG_ANYTJ primary key (DJXH, CKSHNY);

prompt
prompt Creating table ATFX_SH_YS_CKSHXX
prompt ================================
prompt
create table ATFX_SH_YS_CKSHXX
(
  uuid         VARCHAR2(32) not null,
  djxh         NUMBER(20) not null,
  ckshrq       DATE,
  ckshhbzm_dm  VARCHAR2(3),
  ckshje       NUMBER(18,2),
  ckshjemy     NUMBER(18,2),
  ckshjermb    NUMBER(18,2),
  gjhdqszm_dm  VARCHAR2(3),
  gbdq_dm      VARCHAR2(3),
  hggjhdqsz_dm VARCHAR2(3),
  yhywbh       VARCHAR2(50)
)
;
comment on table ATFX_SH_YS_CKSHXX
  is '出口收汇信息表';
comment on column ATFX_SH_YS_CKSHXX.uuid
  is 'UUID，主键';
comment on column ATFX_SH_YS_CKSHXX.djxh
  is '登记序号';
comment on column ATFX_SH_YS_CKSHXX.ckshrq
  is '出口收汇日期（外管局），对应人民币收汇为SKRQ';
comment on column ATFX_SH_YS_CKSHXX.ckshhbzm_dm
  is '出口收汇货币字母代码（外管局），对应人民币收汇为HBZM_DM';
comment on column ATFX_SH_YS_CKSHXX.ckshje
  is '出口收汇金额（原币），对应人民币收汇为SKZJE';
comment on column ATFX_SH_YS_CKSHXX.ckshjemy
  is '出口收汇金额（美元），人民币收汇需参考HX_CS_ZDY.CS_CKTS_HL表转换';
comment on column ATFX_SH_YS_CKSHXX.ckshjermb
  is '收款总金额（人民币），外管局收汇需参考HX_CS_ZDY.CS_CKTS_HL表转换，人民币收汇=SKZJE';
comment on column ATFX_SH_YS_CKSHXX.gjhdqszm_dm
  is '国家或地区三字母代码，对应人民币收汇为null';
comment on column ATFX_SH_YS_CKSHXX.gbdq_dm
  is '国家或地区数字代码，对应外管局收汇为null';
comment on column ATFX_SH_YS_CKSHXX.hggjhdqsz_dm
  is '海关国家和地区数字代码，根据GJHDQSZM_DM、GBDQ_DM参考HX_DM_ZDY.DM_CKTS_HGGJHDQ表转换';
comment on column ATFX_SH_YS_CKSHXX.yhywbh
  is '银行业务编号';
create index IDX_ATFX_SH_YS_CKSHXX_DC on ATFX_SH_YS_CKSHXX (DJXH, CKSHRQ);
alter table ATFX_SH_YS_CKSHXX
  add constraint PK_ATFX_SH_YS_CKSHXX primary key (UUID);

prompt
prompt Creating table ATFX_TS_JG_ACKSPTJ
prompt =================================
prompt
create table ATFX_TS_JG_ACKSPTJ
(
  djxh    NUMBER(20) not null,
  sbny    VARCHAR2(6) not null,
  cksp_dm VARCHAR2(20) not null,
  ckspmc  VARCHAR2(200),
  mylaj   NUMBER(20,2),
  rmblaj  NUMBER(20,2),
  jsje    NUMBER(20,2),
  mdtse   NUMBER(20,2),
  tse     NUMBER(20,2),
  mde     NUMBER(20,2)
)
;
comment on table ATFX_TS_JG_ACKSPTJ
  is '按出口商品统计退税数据表';
comment on column ATFX_TS_JG_ACKSPTJ.djxh
  is '登记序号';
comment on column ATFX_TS_JG_ACKSPTJ.sbny
  is '申报年月';
comment on column ATFX_TS_JG_ACKSPTJ.cksp_dm
  is '出口商品代码';
comment on column ATFX_TS_JG_ACKSPTJ.ckspmc
  is '出口商品名称';
comment on column ATFX_TS_JG_ACKSPTJ.mylaj
  is '申报美元离岸价（免退税、代办退税为null）';
comment on column ATFX_TS_JG_ACKSPTJ.rmblaj
  is '人民币离岸价（免退税、代办退税为null）';
comment on column ATFX_TS_JG_ACKSPTJ.jsje
  is '计税金额（免抵退为null）';
comment on column ATFX_TS_JG_ACKSPTJ.mdtse
  is '免抵退税额（免退税、代办退税为null）';
comment on column ATFX_TS_JG_ACKSPTJ.tse
  is '退税额（免抵退按对审汇总表应退免抵比例计算统计）';
comment on column ATFX_TS_JG_ACKSPTJ.mde
  is '免抵税额（免抵退=MDTSE-TSE；免退税、代办退税为null）';
alter table ATFX_TS_JG_ACKSPTJ
  add constraint PK_ATFX_TS_JG_ACKSPTJ primary key (DJXH, SBNY, CKSP_DM);

prompt
prompt Creating table ATFX_TS_JG_AGYSTJ
prompt ================================
prompt
create table ATFX_TS_JG_AGYSTJ
(
  djxh    NUMBER(20) not null,
  sbny    VARCHAR2(6) not null,
  gyssbh  VARCHAR2(20) not null,
  gysmc   VARCHAR2(200) not null,
  cksp_dm VARCHAR2(20) not null,
  ckspmc  VARCHAR2(200),
  jsje    NUMBER(20,2),
  tse     NUMBER(20,2)
)
;
comment on table ATFX_TS_JG_AGYSTJ
  is '按供应商统计退税数据';
comment on column ATFX_TS_JG_AGYSTJ.djxh
  is '登记序号';
comment on column ATFX_TS_JG_AGYSTJ.sbny
  is '申报年月';
comment on column ATFX_TS_JG_AGYSTJ.gyssbh
  is '供应商识别号';
comment on column ATFX_TS_JG_AGYSTJ.gysmc
  is '供应商名称';
comment on column ATFX_TS_JG_AGYSTJ.cksp_dm
  is '出口商品代码（前4位）';
comment on column ATFX_TS_JG_AGYSTJ.ckspmc
  is '出口商品名称';
comment on column ATFX_TS_JG_AGYSTJ.jsje
  is '计税金额';
comment on column ATFX_TS_JG_AGYSTJ.tse
  is '退税额';
alter table ATFX_TS_JG_AGYSTJ
  add constraint PK_ATFX_TS_JG_AGYSTJ primary key (DJXH, SBNY, GYSSBH, CKSP_DM);

prompt
prompt Creating table ATFX_TS_JG_ANYTJ
prompt ===============================
prompt
create table ATFX_TS_JG_ANYTJ
(
  djxh        NUMBER(20) not null,
  sbny        VARCHAR2(6) not null,
  bgdfs       NUMBER(10),
  hwmxts      NUMBER(10),
  mylaj       NUMBER(20,2),
  rmblaj      NUMBER(20,2),
  jsje        NUMBER(20,2),
  mdtse       NUMBER(20,2),
  tse         NUMBER(20,2),
  mde         NUMBER(20,2),
  hwmxts_cqsb NUMBER(10),
  mylaj_cqsb  NUMBER(20,2)
)
;
comment on table ATFX_TS_JG_ANYTJ
  is '按年月统计退税数据表';
comment on column ATFX_TS_JG_ANYTJ.djxh
  is '登记序号';
comment on column ATFX_TS_JG_ANYTJ.sbny
  is '申报年月';
comment on column ATFX_TS_JG_ANYTJ.bgdfs
  is '报关单份数';
comment on column ATFX_TS_JG_ANYTJ.hwmxts
  is '货物明细条数';
comment on column ATFX_TS_JG_ANYTJ.mylaj
  is '申报美元离岸价（免退税、代办退税为null）';
comment on column ATFX_TS_JG_ANYTJ.rmblaj
  is '人民币离岸价（免退税、代办退税为null）';
comment on column ATFX_TS_JG_ANYTJ.jsje
  is '计税金额（免抵退为null）';
comment on column ATFX_TS_JG_ANYTJ.mdtse
  is '免抵退税额（免退税、代办退税为null）';
comment on column ATFX_TS_JG_ANYTJ.tse
  is '退税额（免抵退按对审汇总表ytse_1统计）';
comment on column ATFX_TS_JG_ANYTJ.mde
  is '免抵额（免抵退按对审汇总表ytse_1统计；免退税、代办退税为null）';
comment on column ATFX_TS_JG_ANYTJ.hwmxts_cqsb
  is '其中超期申报货物明细条数';
comment on column ATFX_TS_JG_ANYTJ.mylaj_cqsb
  is '其中超期申报申报美元离岸价';
alter table ATFX_TS_JG_ANYTJ
  add constraint PK_ATFX_TS_JG_ANYTJ primary key (DJXH, SBNY);

prompt
prompt Creating table ATFX_TS_YS_CKMXSBB
prompt =================================
prompt
create table ATFX_TS_YS_CKMXSBB
(
  uuid          VARCHAR2(32) not null,
  djxh          NUMBER(20) not null,
  lcslid        VARCHAR2(50),
  ssq           VARCHAR2(6) not null,
  sbpc          VARCHAR2(75),
  sbxh          VARCHAR2(50),
  glh           VARCHAR2(30) not null,
  ckfph         VARCHAR2(30),
  ckbgdh        VARCHAR2(21),
  dlzmh         VARCHAR2(20),
  ckrq_1        DATE,
  cksp_dm       VARCHAR2(20) not null,
  sbhgspmc      VARCHAR2(200) not null,
  hgjldwmc      VARCHAR2(50),
  cksl          NUMBER(18,6),
  mylaj         NUMBER(18,2),
  rmblaj        NUMBER(18,2),
  ckjhje        NUMBER(18,2),
  zzstse        NUMBER(18,2),
  xfstse        NUMBER(18,2),
  cktmsywlxdmjh VARCHAR2(100),
  cktmsywlxmcjh VARCHAR2(200),
  lrrq          DATE,
  byblbz        CHAR(1),
  bytsbz        CHAR(1),
  bz            VARCHAR2(500)
)
;
comment on table ATFX_TS_YS_CKMXSBB
  is '出口明细申报表';
comment on column ATFX_TS_YS_CKMXSBB.uuid
  is 'UUID，主键';
comment on column ATFX_TS_YS_CKMXSBB.djxh
  is '登记序号（关联企业主表，标识申报企业）';
comment on column ATFX_TS_YS_CKMXSBB.ssq
  is '所属期（格式YYYYMM，申报数据的核心归属维度）';
comment on column ATFX_TS_YS_CKMXSBB.sbpc
  is '申报批次';
comment on column ATFX_TS_YS_CKMXSBB.sbxh
  is '申报序号';
comment on column ATFX_TS_YS_CKMXSBB.glh
  is '关联号（核心关联字段，用于关联进货明细计算金额与退税额）';
comment on column ATFX_TS_YS_CKMXSBB.rmblaj
  is '人民币离岸价（根据报关单号/代理证明号从报关单/代理证明数据提取）';
comment on column ATFX_TS_YS_CKMXSBB.ckjhje
  is '出口进货金额（根据关联号匹配进货明细，汇总计算得出）';
comment on column ATFX_TS_YS_CKMXSBB.zzstse
  is '增值税退税额（根据关联号匹配进货明细的增值税税额，按规则计算得出）';
comment on column ATFX_TS_YS_CKMXSBB.xfstse
  is '消费税退税额（根据关联号匹配进货明细的消费税税额，按规则计算得出）';
comment on column ATFX_TS_YS_CKMXSBB.lrrq
  is '录入日期（即申报提交日期，记录申报操作时间）';
comment on column ATFX_TS_YS_CKMXSBB.bytsbz
  is '不予退税标志（标识该笔出口明细是否符合退税条件）';
create index IDX_CKMXSBB_CKBGDH on ATFX_TS_YS_CKMXSBB (CKBGDH);
create index IDX_CKMXSBB_CKFPH on ATFX_TS_YS_CKMXSBB (CKFPH);
create index IDX_CKMXSBB_CKSP_DM on ATFX_TS_YS_CKMXSBB (CKSP_DM);
create index IDX_CKMXSBB_DJXH on ATFX_TS_YS_CKMXSBB (DJXH);
create index IDX_CKMXSBB_GLH on ATFX_TS_YS_CKMXSBB (GLH);
create index IDX_CKMXSBB_LCSLID on ATFX_TS_YS_CKMXSBB (LCSLID);
create index IDX_CKMXSBB_SSQ_SBPC on ATFX_TS_YS_CKMXSBB (SSQ, SBPC);
alter table ATFX_TS_YS_CKMXSBB
  add constraint PK_ATFX_TS_YS_CKMXSBB primary key (UUID);

prompt
prompt Creating table ATFX_TS_YS_DBTSSBB
prompt =================================
prompt
create table ATFX_TS_YS_DBTSSBB
(
  uuid             VARCHAR2(32) not null,
  djxh             NUMBER(20) not null,
  lcslid           VARCHAR2(50),
  ssq              VARCHAR2(6) not null,
  sbpc             VARCHAR2(75),
  sbxh             VARCHAR2(50),
  wtdbtsscqynsrsbh VARCHAR2(20) not null,
  wtdbtsscqyshxydm VARCHAR2(18),
  ckbgdh           VARCHAR2(21),
  ckrq_1           DATE,
  cksp_dm          VARCHAR2(20) not null,
  hgspmc           VARCHAR2(200) not null,
  hgjldwmc         VARCHAR2(50),
  cksl             NUMBER(18,6),
  mylaj            NUMBER(18,2),
  dbtswspzhm       VARCHAR2(50),
  kprq             DATE,
  jsje             NUMBER(18,2),
  zssl             VARCHAR2(10),
  tsl              VARCHAR2(10),
  tse              NUMBER(18,2),
  cktmsywlxdmjh    VARCHAR2(100),
  cktmsywlxmcjh    VARCHAR2(200),
  dbtsywlx_dm      VARCHAR2(10),
  dbtsywlxmc       VARCHAR2(100),
  lrrq             DATE,
  byblbz           CHAR(1),
  bytsbz           CHAR(1),
  mtsny            VARCHAR2(6),
  bz               VARCHAR2(500)
)
;
comment on table ATFX_TS_YS_DBTSSBB
  is '代办退税申报表';
comment on column ATFX_TS_YS_DBTSSBB.uuid
  is 'UUID，主键';
comment on column ATFX_TS_YS_DBTSSBB.djxh
  is '登记序号';
comment on column ATFX_TS_YS_DBTSSBB.lcslid
  is '流程实例ID';
comment on column ATFX_TS_YS_DBTSSBB.ssq
  is '所属期';
comment on column ATFX_TS_YS_DBTSSBB.sbpc
  is '申报批次';
comment on column ATFX_TS_YS_DBTSSBB.sbxh
  is '申报序号';
comment on column ATFX_TS_YS_DBTSSBB.wtdbtsscqynsrsbh
  is '委托代办退税生产企业纳税人识别号';
comment on column ATFX_TS_YS_DBTSSBB.wtdbtsscqyshxydm
  is '委托代办退税生产企业社会信用代码';
comment on column ATFX_TS_YS_DBTSSBB.ckbgdh
  is '出口报关单号';
comment on column ATFX_TS_YS_DBTSSBB.ckrq_1
  is '出口日期';
comment on column ATFX_TS_YS_DBTSSBB.cksp_dm
  is '出口商品代码';
comment on column ATFX_TS_YS_DBTSSBB.hgspmc
  is '海关商品名称';
comment on column ATFX_TS_YS_DBTSSBB.hgjldwmc
  is '海关计量单位名称';
comment on column ATFX_TS_YS_DBTSSBB.cksl
  is '出口数量';
comment on column ATFX_TS_YS_DBTSSBB.mylaj
  is '美元离岸价';
comment on column ATFX_TS_YS_DBTSSBB.dbtswspzhm
  is '代办退税完税凭证号码';
comment on column ATFX_TS_YS_DBTSSBB.kprq
  is '开票日期';
comment on column ATFX_TS_YS_DBTSSBB.jsje
  is '计税金额';
comment on column ATFX_TS_YS_DBTSSBB.zssl
  is '征税税率';
comment on column ATFX_TS_YS_DBTSSBB.tsl
  is '退税率';
comment on column ATFX_TS_YS_DBTSSBB.tse
  is '退税额';
comment on column ATFX_TS_YS_DBTSSBB.cktmsywlxdmjh
  is '出口退（免）税业务类型代码集合';
comment on column ATFX_TS_YS_DBTSSBB.cktmsywlxmcjh
  is '出口退（免）税业务类型名称集合';
comment on column ATFX_TS_YS_DBTSSBB.dbtsywlx_dm
  is '代办退税业务类型代码';
comment on column ATFX_TS_YS_DBTSSBB.dbtsywlxmc
  is '代办退税业务类型名称';
comment on column ATFX_TS_YS_DBTSSBB.lrrq
  is '录入日期（申报日期）';
comment on column ATFX_TS_YS_DBTSSBB.byblbz
  is '不予办理标志';
comment on column ATFX_TS_YS_DBTSSBB.bytsbz
  is '不予退税标志';
comment on column ATFX_TS_YS_DBTSSBB.mtsny
  is '免退税年月';
comment on column ATFX_TS_YS_DBTSSBB.bz
  is '备注';
create index IDX_DBTSSBB_CKBGDH on ATFX_TS_YS_DBTSSBB (CKBGDH);
create index IDX_DBTSSBB_CKRQ1 on ATFX_TS_YS_DBTSSBB (CKRQ_1);
create index IDX_DBTSSBB_CKSP_DM on ATFX_TS_YS_DBTSSBB (CKSP_DM);
create index IDX_DBTSSBB_DBTSYWLX_DM on ATFX_TS_YS_DBTSSBB (DBTSYWLX_DM);
create index IDX_DBTSSBB_DJXH on ATFX_TS_YS_DBTSSBB (DJXH);
create index IDX_DBTSSBB_SSQ on ATFX_TS_YS_DBTSSBB (SSQ);
create index IDX_DBTSSBB_WTDBTSSCQYNSRSBH on ATFX_TS_YS_DBTSSBB (WTDBTSSCQYNSRSBH);
alter table ATFX_TS_YS_DBTSSBB
  add constraint PK_ATFX_TS_YS_DBTSSBB primary key (UUID);

prompt
prompt Creating table ATFX_TS_YS_JHMXSBB
prompt =================================
prompt
create table ATFX_TS_YS_JHMXSBB
(
  uuid          VARCHAR2(32) not null,
  djxh          NUMBER(20) not null,
  lcslid        VARCHAR2(50),
  ssq           VARCHAR2(6) not null,
  sbpc          VARCHAR2(75),
  sbxh          VARCHAR2(50),
  glh           VARCHAR2(30) not null,
  sz            VARCHAR2(2) not null,
  jhpzh         VARCHAR2(64) not null,
  ghfnsrsbh_1   VARCHAR2(20),
  kprq          DATE not null,
  cksp_dm       VARCHAR2(20) not null,
  sbhgspmc      VARCHAR2(400) not null,
  hgjldwmc      VARCHAR2(50),
  sl            NUMBER(18,6),
  jsje          NUMBER(18,2),
  zssl          VARCHAR2(10),
  zsse          NUMBER(18,2),
  tsl           VARCHAR2(10),
  tse           NUMBER(18,2),
  cktmsywlxdmjh VARCHAR2(100),
  cktmsywlxmcjh VARCHAR2(200),
  lrrq          DATE,
  byblbz        CHAR(1),
  bytsbz        CHAR(1),
  mtsbz         CHAR(1),
  bz            VARCHAR2(500),
  ckrq_1        DATE
)
;
comment on table ATFX_TS_YS_JHMXSBB
  is '进货明细申报表';
comment on column ATFX_TS_YS_JHMXSBB.uuid
  is '主键';
comment on column ATFX_TS_YS_JHMXSBB.djxh
  is '登记序号';
comment on column ATFX_TS_YS_JHMXSBB.lcslid
  is '流程实例ID';
comment on column ATFX_TS_YS_JHMXSBB.ssq
  is '所属期';
comment on column ATFX_TS_YS_JHMXSBB.sbpc
  is '申报批次';
comment on column ATFX_TS_YS_JHMXSBB.sbxh
  is '申报序号';
comment on column ATFX_TS_YS_JHMXSBB.glh
  is '关联号';
comment on column ATFX_TS_YS_JHMXSBB.sz
  is '税种';
comment on column ATFX_TS_YS_JHMXSBB.jhpzh
  is '进货凭证号';
comment on column ATFX_TS_YS_JHMXSBB.ghfnsrsbh_1
  is '供货方纳税人识别号';
comment on column ATFX_TS_YS_JHMXSBB.kprq
  is '开票日期';
comment on column ATFX_TS_YS_JHMXSBB.cksp_dm
  is '出口商品代码';
comment on column ATFX_TS_YS_JHMXSBB.sbhgspmc
  is '申报海关商品名称||申报海关商品名称';
comment on column ATFX_TS_YS_JHMXSBB.hgjldwmc
  is '海关计量单位名称';
comment on column ATFX_TS_YS_JHMXSBB.sl
  is '数量';
comment on column ATFX_TS_YS_JHMXSBB.jsje
  is '计税金额';
comment on column ATFX_TS_YS_JHMXSBB.zssl
  is '征税税率';
comment on column ATFX_TS_YS_JHMXSBB.zsse
  is '征税税额';
comment on column ATFX_TS_YS_JHMXSBB.tsl
  is '退税率';
comment on column ATFX_TS_YS_JHMXSBB.tse
  is '退税额';
comment on column ATFX_TS_YS_JHMXSBB.cktmsywlxdmjh
  is '出口退（免）税业务类型代码集合';
comment on column ATFX_TS_YS_JHMXSBB.cktmsywlxmcjh
  is '出口退（免）税业务类型名称集合';
comment on column ATFX_TS_YS_JHMXSBB.lrrq
  is '录入日期（申报日期）';
comment on column ATFX_TS_YS_JHMXSBB.byblbz
  is '不予办理标志';
comment on column ATFX_TS_YS_JHMXSBB.bytsbz
  is '不予退税标志';
comment on column ATFX_TS_YS_JHMXSBB.mtsbz
  is '免退税标志';
comment on column ATFX_TS_YS_JHMXSBB.bz
  is '备注';
comment on column ATFX_TS_YS_JHMXSBB.ckrq_1
  is '出口日期（根据关联号从出口明细表提取，同一关联号下有多条出口明细的按最早的出口日期提取）';
create index IDX_JHMXSBB_CKRQ1 on ATFX_TS_YS_JHMXSBB (CKRQ_1);
create index IDX_JHMXSBB_CKSP_DM on ATFX_TS_YS_JHMXSBB (CKSP_DM);
create index IDX_JHMXSBB_DJXH on ATFX_TS_YS_JHMXSBB (DJXH);
create index IDX_JHMXSBB_GHFNSRSBH on ATFX_TS_YS_JHMXSBB (GHFNSRSBH_1);
create index IDX_JHMXSBB_GLH on ATFX_TS_YS_JHMXSBB (GLH);
create index IDX_JHMXSBB_JHPZH on ATFX_TS_YS_JHMXSBB (JHPZH);
create index IDX_JHMXSBB_SSQ on ATFX_TS_YS_JHMXSBB (SSQ);
alter table ATFX_TS_YS_JHMXSBB
  add constraint PK_ATFX_TS_YS_JHMXSBB primary key (UUID);

prompt
prompt Creating table ATFX_TS_YS_MDTSHZB
prompt =================================
prompt
create table ATFX_TS_YS_MDTSHZB
(
  uuid               VARCHAR2(32) not null,
  djxh               NUMBER(20),
  lcslid             VARCHAR2(32),
  ssq                VARCHAR2(6),
  ckxsemy            NUMBER(18,2),
  ckhwxsemy          NUMBER(18,2),
  ysfwxsemy          NUMBER(18,2),
  ckxsermb           NUMBER(18,2),
  mdtsbdmzhdkse      NUMBER(18,2),
  ckhwbdmzhdkse      NUMBER(18,2),
  ysfwbdmzhdkse      NUMBER(18,2),
  jljghxytzbdmzhdkse NUMBER(18,2),
  mdtsbdmzhdksehj    NUMBER(18,2),
  bdmzdkseynsbce     NUMBER(18,2),
  mdtse              NUMBER(18,2),
  ckhwmdtse          NUMBER(18,2),
  ysfwmdtse          NUMBER(18,2),
  sqjzmdtse          NUMBER(18,2),
  jljghxytzmdtse     NUMBER(18,2),
  mdtsehj            NUMBER(18,2),
  jzxqmdtse          NUMBER(18,2),
  zzsnssbbqmldse     NUMBER(18,2),
  ytse_1             NUMBER(18,2),
  mdse               NUMBER(18,2)
)
;
comment on table ATFX_TS_YS_MDTSHZB
  is '免抵退税申报汇总表';
comment on column ATFX_TS_YS_MDTSHZB.uuid
  is 'UUID||uuid';
comment on column ATFX_TS_YS_MDTSHZB.djxh
  is '登记序号';
comment on column ATFX_TS_YS_MDTSHZB.lcslid
  is '流程实例ID';
comment on column ATFX_TS_YS_MDTSHZB.ssq
  is '所属期';
comment on column ATFX_TS_YS_MDTSHZB.ckxsemy
  is '出口销售额（美元）';
comment on column ATFX_TS_YS_MDTSHZB.ckhwxsemy
  is '出口货物销售额（美元）';
comment on column ATFX_TS_YS_MDTSHZB.ysfwxsemy
  is '应税服务销售额（美元）';
comment on column ATFX_TS_YS_MDTSHZB.ckxsermb
  is '出口销售额（人民币）';
comment on column ATFX_TS_YS_MDTSHZB.mdtsbdmzhdkse
  is '免抵退税不得免征和抵扣税额';
comment on column ATFX_TS_YS_MDTSHZB.ckhwbdmzhdkse
  is '出口货物不得免征和抵扣税额';
comment on column ATFX_TS_YS_MDTSHZB.ysfwbdmzhdkse
  is '应税服务不得免征和抵扣税额';
comment on column ATFX_TS_YS_MDTSHZB.jljghxytzbdmzhdkse
  is '进料加工核销应调整不得免征和抵扣税额';
comment on column ATFX_TS_YS_MDTSHZB.mdtsbdmzhdksehj
  is '免抵退税不得免征和抵扣税额合计';
comment on column ATFX_TS_YS_MDTSHZB.bdmzdkseynsbce
  is '不得免征抵扣税额与纳税表差额';
comment on column ATFX_TS_YS_MDTSHZB.mdtse
  is '免抵退税额';
comment on column ATFX_TS_YS_MDTSHZB.ckhwmdtse
  is '出口货物免抵退税额';
comment on column ATFX_TS_YS_MDTSHZB.ysfwmdtse
  is '应税服务免抵退税额';
comment on column ATFX_TS_YS_MDTSHZB.sqjzmdtse
  is '上期结转免抵退税额';
comment on column ATFX_TS_YS_MDTSHZB.jljghxytzmdtse
  is '进料加工核销应调整免抵退税额';
comment on column ATFX_TS_YS_MDTSHZB.mdtsehj
  is '免抵退税额合计';
comment on column ATFX_TS_YS_MDTSHZB.jzxqmdtse
  is '结转下期免抵退税额';
comment on column ATFX_TS_YS_MDTSHZB.zzsnssbbqmldse
  is '增值税纳税申报表期末留抵税额';
comment on column ATFX_TS_YS_MDTSHZB.ytse_1
  is '应退税额';
comment on column ATFX_TS_YS_MDTSHZB.mdse
  is '免抵税额';
create index IDX_ATFX_TS_YS_MDTSHZB_DS on ATFX_TS_YS_MDTSHZB (DJXH, SSQ);
create index IDX_ATFX_TS_YS_MDTSHZB_LCSLID on ATFX_TS_YS_MDTSHZB (LCSLID);
alter table ATFX_TS_YS_MDTSHZB
  add constraint PK_ATFX_TS_YS_MDTSHZB primary key (UUID);

prompt
prompt Creating table ATFX_TS_YS_MDTSSBB
prompt =================================
prompt
create table ATFX_TS_YS_MDTSSBB
(
  uuid             VARCHAR2(32) not null,
  djxh             NUMBER(20) not null,
  lcslid           VARCHAR2(32),
  ssq              VARCHAR2(6) not null,
  sbxh             VARCHAR2(50),
  ckfph            VARCHAR2(30),
  ckbgdh           VARCHAR2(21),
  dlckhwzmhm       VARCHAR2(20),
  ckrq_1           DATE,
  cksp_dm          VARCHAR2(20) not null,
  sbhgspmc         VARCHAR2(500) not null,
  hgjldwmc         VARCHAR2(75),
  cksl             NUMBER(18,6),
  cjhbzm_dm        VARCHAR2(3),
  cjzj             NUMBER(18,2),
  cjhbhl           NUMBER(16,6),
  rmblaj           NUMBER(18,2),
  myhl             NUMBER(16,6),
  mylaj            NUMBER(18,2),
  zssl             VARCHAR2(10),
  tsl              VARCHAR2(10),
  jljgszch         VARCHAR2(20),
  jsfpl            NUMBER(16,6),
  tzhjhfpl         NUMBER(16,6),
  jljgbsjkljzcjsjg NUMBER(18,2),
  gngjmsycljg      NUMBER(18,2),
  mdtsbdmzhdkse    NUMBER(18,2),
  mdtse            NUMBER(18,2),
  cktmsywlxdmjh    VARCHAR2(100),
  cktmsywlxmcjh    VARCHAR2(200),
  lrrq             DATE,
  byblbz           CHAR(1),
  byblyy           VARCHAR2(3000),
  bytsbz           CHAR(1),
  bytsny           VARCHAR2(6),
  zbblny           VARCHAR2(6),
  mdtsny           VARCHAR2(6),
  bz               VARCHAR2(500)
)
;
comment on table ATFX_TS_YS_MDTSSBB
  is '免抵退税申报明细表';
comment on column ATFX_TS_YS_MDTSSBB.uuid
  is 'UUID，主键';
comment on column ATFX_TS_YS_MDTSSBB.djxh
  is '登记序号';
comment on column ATFX_TS_YS_MDTSSBB.lcslid
  is '流程实例ID';
comment on column ATFX_TS_YS_MDTSSBB.ssq
  is '所属期';
comment on column ATFX_TS_YS_MDTSSBB.sbxh
  is '申报序号';
comment on column ATFX_TS_YS_MDTSSBB.ckfph
  is '出口发票号';
comment on column ATFX_TS_YS_MDTSSBB.ckbgdh
  is '出口报关单号';
comment on column ATFX_TS_YS_MDTSSBB.dlckhwzmhm
  is '代理出口货物证明号码';
comment on column ATFX_TS_YS_MDTSSBB.ckrq_1
  is '出口日期';
comment on column ATFX_TS_YS_MDTSSBB.cksp_dm
  is '出口商品代码';
comment on column ATFX_TS_YS_MDTSSBB.sbhgspmc
  is '申报海关商品名称';
comment on column ATFX_TS_YS_MDTSSBB.hgjldwmc
  is '海关计量单位名称';
comment on column ATFX_TS_YS_MDTSSBB.cksl
  is '出口数量';
comment on column ATFX_TS_YS_MDTSSBB.cjhbzm_dm
  is '成交货币字母代码';
comment on column ATFX_TS_YS_MDTSSBB.cjzj
  is '成交总价';
comment on column ATFX_TS_YS_MDTSSBB.cjhbhl
  is '成交货币汇率';
comment on column ATFX_TS_YS_MDTSSBB.rmblaj
  is '人民币离岸价';
comment on column ATFX_TS_YS_MDTSSBB.myhl
  is '美元汇率';
comment on column ATFX_TS_YS_MDTSSBB.mylaj
  is '美元离岸价';
comment on column ATFX_TS_YS_MDTSSBB.zssl
  is '征税税率';
comment on column ATFX_TS_YS_MDTSSBB.tsl
  is '退税率';
comment on column ATFX_TS_YS_MDTSSBB.jljgszch
  is '进料加工手（账）册号';
comment on column ATFX_TS_YS_MDTSSBB.jsfpl
  is '计算分配率';
comment on column ATFX_TS_YS_MDTSSBB.tzhjhfpl
  is '调整后计划分配率';
comment on column ATFX_TS_YS_MDTSSBB.jljgbsjkljzcjsjg
  is '进料加工保税进口料件组成计税价格';
comment on column ATFX_TS_YS_MDTSSBB.gngjmsycljg
  is '国内购进免税原材料价格';
comment on column ATFX_TS_YS_MDTSSBB.mdtsbdmzhdkse
  is '免抵退税不得免征和抵扣税额';
comment on column ATFX_TS_YS_MDTSSBB.mdtse
  is '免抵退税额';
comment on column ATFX_TS_YS_MDTSSBB.cktmsywlxdmjh
  is '出口退（免）税业务类型代码集合';
comment on column ATFX_TS_YS_MDTSSBB.cktmsywlxmcjh
  is '出口退（免）税业务类型名称集合';
comment on column ATFX_TS_YS_MDTSSBB.lrrq
  is '录入日期（申报日期）';
comment on column ATFX_TS_YS_MDTSSBB.byblbz
  is '不予办理标志';
comment on column ATFX_TS_YS_MDTSSBB.byblyy
  is '不予办理原因';
comment on column ATFX_TS_YS_MDTSSBB.bytsbz
  is '不予退税标志';
comment on column ATFX_TS_YS_MDTSSBB.bytsny
  is '不予退税年月';
comment on column ATFX_TS_YS_MDTSSBB.zbblny
  is '暂不办理年月';
comment on column ATFX_TS_YS_MDTSSBB.mdtsny
  is '免抵退税年月';
comment on column ATFX_TS_YS_MDTSSBB.bz
  is '备注';
create index IDX_MDTSSBB_CKBGDH on ATFX_TS_YS_MDTSSBB (CKBGDH);
create index IDX_MDTSSBB_CKFPH on ATFX_TS_YS_MDTSSBB (CKFPH);
create index IDX_MDTSSBB_CKRQ_1 on ATFX_TS_YS_MDTSSBB (CKRQ_1);
create index IDX_MDTSSBB_CKSP_DM on ATFX_TS_YS_MDTSSBB (CKSP_DM);
create index IDX_MDTSSBB_DJXH on ATFX_TS_YS_MDTSSBB (DJXH);
create index IDX_MDTSSBB_LCSLID on ATFX_TS_YS_MDTSSBB (LCSLID);
create index IDX_MDTSSBB_SSQ on ATFX_TS_YS_MDTSSBB (SSQ);
alter table ATFX_TS_YS_MDTSSBB
  add constraint PK_ATFX_TS_YS_MDTSSBB primary key (UUID);

prompt
prompt Creating table ATFX_TS_YS_TSBLXX
prompt ================================
prompt
create table ATFX_TS_YS_TSBLXX
(
  srthsuuid   VARCHAR2(32) not null,
  djxh        NUMBER(20) not null,
  ydjxh       NUMBER(20),
  kprq        DATE,
  thrq_1      DATE,
  xhrq_1      DATE,
  tzlx_dm     VARCHAR2(10),
  ttsjlx_dm   VARCHAR2(10),
  skzl_dm     VARCHAR2(10),
  zsxm_dm     VARCHAR2(10),
  tdsfyylx_dm VARCHAR2(10),
  yskm_dm     VARCHAR2(20),
  sksx_dm     VARCHAR2(10),
  skssqq      DATE not null,
  skssqz      DATE not null,
  se          NUMBER(18,2) not null,
  ydtuuid     VARCHAR2(32),
  ydtlyuuid   VARCHAR2(32),
  sjlx        VARCHAR2(30)
)
;
comment on table ATFX_TS_YS_TSBLXX
  is '退税办理信息表';
comment on column ATFX_TS_YS_TSBLXX.srthsuuid
  is '收入退还书UUID，主键';
comment on column ATFX_TS_YS_TSBLXX.djxh
  is '登记序号';
comment on column ATFX_TS_YS_TSBLXX.ydjxh
  is '原登记序号（提取生产企业通过外综服企业代办退税的数据时，取代办退税的外综服企业djxh，非代办退税的数据为null）';
comment on column ATFX_TS_YS_TSBLXX.kprq
  is '开票日期';
comment on column ATFX_TS_YS_TSBLXX.thrq_1
  is '退还日期';
comment on column ATFX_TS_YS_TSBLXX.xhrq_1
  is '销号日期';
comment on column ATFX_TS_YS_TSBLXX.tzlx_dm
  is '调账类型代码';
comment on column ATFX_TS_YS_TSBLXX.ttsjlx_dm
  is '提退税金类型代码';
comment on column ATFX_TS_YS_TSBLXX.skzl_dm
  is '税款种类代码';
comment on column ATFX_TS_YS_TSBLXX.zsxm_dm
  is '征收项目代码';
comment on column ATFX_TS_YS_TSBLXX.tdsfyylx_dm
  is '退抵税费原因类型代码';
comment on column ATFX_TS_YS_TSBLXX.yskm_dm
  is '预算科目代码';
comment on column ATFX_TS_YS_TSBLXX.sksx_dm
  is '税款属性代码';
comment on column ATFX_TS_YS_TSBLXX.skssqq
  is '税款所属期起';
comment on column ATFX_TS_YS_TSBLXX.skssqz
  is '税款所属期止';
comment on column ATFX_TS_YS_TSBLXX.se
  is '税额';
comment on column ATFX_TS_YS_TSBLXX.ydtuuid
  is '应抵退UUID';
comment on column ATFX_TS_YS_TSBLXX.ydtlyuuid
  is '应抵退来源UUID';
comment on column ATFX_TS_YS_TSBLXX.sjlx
  is '数据类型（1、自行申报出口退税、2、留抵退税、3、代办退税、）';
create index IDX_TSBLXX_DJXH on ATFX_TS_YS_TSBLXX (DJXH);
create index IDX_TSBLXX_SJLX on ATFX_TS_YS_TSBLXX (SJLX);
create index IDX_TSBLXX_SKSSQQ_SKSSQZ on ATFX_TS_YS_TSBLXX (SKSSQQ, SKSSQZ);
create index IDX_TSBLXX_SKZL_DM_ZSXM_DM on ATFX_TS_YS_TSBLXX (SKZL_DM, ZSXM_DM);
create index IDX_TSBLXX_THRQ1 on ATFX_TS_YS_TSBLXX (THRQ_1);
create index IDX_TSBLXX_YDJXH on ATFX_TS_YS_TSBLXX (YDJXH);
create index IDX_TSBLXX_YDTUUID on ATFX_TS_YS_TSBLXX (YDTUUID);
alter table ATFX_TS_YS_TSBLXX
  add constraint PK_ATFX_TS_YS_TSBLXX primary key (SRTHSUUID);

prompt
prompt Creating table ATFX_TS_YS_TSFNXX
prompt ================================
prompt
create table ATFX_TS_YS_TSFNXX
(
  spuuid    VARCHAR2(32) not null,
  djxh      NUMBER(20) not null,
  rkrq      DATE,
  tzlx_dm   VARCHAR2(10),
  skzl_dm   VARCHAR2(10) not null,
  zsxm_dm   VARCHAR2(10) not null,
  sksx_dm   VARCHAR2(10),
  yzpzzl_dm VARCHAR2(10),
  yskm_dm   VARCHAR2(20),
  skssqq    DATE not null,
  skssqz    DATE not null,
  sjje      NUMBER(18,2) not null
)
;
comment on table ATFX_TS_YS_TSFNXX
  is '退税返纳信息表';
comment on column ATFX_TS_YS_TSFNXX.spuuid
  is '税票UUID（留抵退税取ZSUUID）';
comment on column ATFX_TS_YS_TSFNXX.djxh
  is '登记序号';
comment on column ATFX_TS_YS_TSFNXX.rkrq
  is '入库日期';
comment on column ATFX_TS_YS_TSFNXX.tzlx_dm
  is '调账类型代码';
comment on column ATFX_TS_YS_TSFNXX.skzl_dm
  is '税款种类代码';
comment on column ATFX_TS_YS_TSFNXX.zsxm_dm
  is '征收项目代码';
comment on column ATFX_TS_YS_TSFNXX.sksx_dm
  is '税款属性代码';
comment on column ATFX_TS_YS_TSFNXX.yzpzzl_dm
  is '应征凭证种类代码（出口退税返纳为null）';
comment on column ATFX_TS_YS_TSFNXX.yskm_dm
  is '预算科目代码';
comment on column ATFX_TS_YS_TSFNXX.skssqq
  is '税款所属期起（格式YYYYMM）';
comment on column ATFX_TS_YS_TSFNXX.skssqz
  is '税款所属期止（格式YYYYMM）';
comment on column ATFX_TS_YS_TSFNXX.sjje
  is '实缴金额（留抵退税取YBTSE）';
create index IDX_TSFNXX_DJXH on ATFX_TS_YS_TSFNXX (DJXH);
create index IDX_TSFNXX_RKRQ on ATFX_TS_YS_TSFNXX (RKRQ);
create index IDX_TSFNXX_SKSSQQ_SKSSQZ on ATFX_TS_YS_TSFNXX (SKSSQQ, SKSSQZ);
create index IDX_TSFNXX_SKZL_DM_ZSXM_DM on ATFX_TS_YS_TSFNXX (SKZL_DM, ZSXM_DM);
alter table ATFX_TS_YS_TSFNXX
  add constraint PK_ATFX_TS_YS_TSFNXX primary key (SPUUID);

prompt
prompt Creating table ATFX_TS_YS_WTDBTSSBB
prompt ===================================
prompt
create table ATFX_TS_YS_WTDBTSSBB
(
  uuid          VARCHAR2(32) not null,
  djxh          NUMBER(20) not null,
  ydjxh         NUMBER(20),
  lcslid        VARCHAR2(50),
  ssq           VARCHAR2(6) not null,
  sbpc          VARCHAR2(75),
  sbxh          VARCHAR2(50),
  ckbgdh        VARCHAR2(21),
  ckrq_1        DATE,
  cksp_dm       VARCHAR2(20) not null,
  hgspmc        VARCHAR2(200) not null,
  hgjldwmc      VARCHAR2(50),
  cksl          NUMBER(18,6),
  mylaj         NUMBER(18,2),
  dbtswspzhm    VARCHAR2(50),
  kprq          DATE,
  jsje          NUMBER(18,2),
  zssl          VARCHAR2(10),
  tsl           VARCHAR2(10),
  tse           NUMBER(18,2),
  cktmsywlxdmjh VARCHAR2(100),
  cktmsywlxmcjh VARCHAR2(200),
  lrrq          DATE,
  byblbz        CHAR(1),
  bytsbz        CHAR(1),
  mtsny         VARCHAR2(6),
  bz            VARCHAR2(500)
)
;
comment on table ATFX_TS_YS_WTDBTSSBB
  is '委托代办退税申报明细表';
comment on column ATFX_TS_YS_WTDBTSSBB.uuid
  is 'UUID，主键';
comment on column ATFX_TS_YS_WTDBTSSBB.djxh
  is '登记序号（本企业登记序号而非代办退税明细表中的登记序号）';
comment on column ATFX_TS_YS_WTDBTSSBB.ydjxh
  is '原登记序号（代办退税明细表中外综服企业的djxh）';
comment on column ATFX_TS_YS_WTDBTSSBB.lcslid
  is '流程实例ID';
comment on column ATFX_TS_YS_WTDBTSSBB.ssq
  is '所属期';
comment on column ATFX_TS_YS_WTDBTSSBB.sbpc
  is '申报批次';
comment on column ATFX_TS_YS_WTDBTSSBB.sbxh
  is '申报序号';
comment on column ATFX_TS_YS_WTDBTSSBB.ckbgdh
  is '出口报关单号';
comment on column ATFX_TS_YS_WTDBTSSBB.ckrq_1
  is '出口日期';
comment on column ATFX_TS_YS_WTDBTSSBB.cksp_dm
  is '出口商品代码';
comment on column ATFX_TS_YS_WTDBTSSBB.hgspmc
  is '海关商品名称';
comment on column ATFX_TS_YS_WTDBTSSBB.hgjldwmc
  is '海关计量单位名称';
comment on column ATFX_TS_YS_WTDBTSSBB.cksl
  is '出口数量';
comment on column ATFX_TS_YS_WTDBTSSBB.mylaj
  is '美元离岸价';
comment on column ATFX_TS_YS_WTDBTSSBB.dbtswspzhm
  is '代办退税完税凭证号码';
comment on column ATFX_TS_YS_WTDBTSSBB.kprq
  is '开票日期';
comment on column ATFX_TS_YS_WTDBTSSBB.jsje
  is '计税金额';
comment on column ATFX_TS_YS_WTDBTSSBB.zssl
  is '征税税率';
comment on column ATFX_TS_YS_WTDBTSSBB.tsl
  is '退税率';
comment on column ATFX_TS_YS_WTDBTSSBB.tse
  is '退税额';
comment on column ATFX_TS_YS_WTDBTSSBB.cktmsywlxdmjh
  is '出口退（免）税业务类型代码集合';
comment on column ATFX_TS_YS_WTDBTSSBB.cktmsywlxmcjh
  is '出口退（免）税业务类型名称集合';
comment on column ATFX_TS_YS_WTDBTSSBB.lrrq
  is '录入日期（申报日期）';
comment on column ATFX_TS_YS_WTDBTSSBB.byblbz
  is '不予办理标志';
comment on column ATFX_TS_YS_WTDBTSSBB.bytsbz
  is '不予退税标志';
comment on column ATFX_TS_YS_WTDBTSSBB.mtsny
  is '免退税年月';
comment on column ATFX_TS_YS_WTDBTSSBB.bz
  is '备注';
create index IDX_WTDBTSSBB_CKBGDH on ATFX_TS_YS_WTDBTSSBB (CKBGDH);
create index IDX_WTDBTSSBB_CKSP_DM on ATFX_TS_YS_WTDBTSSBB (CKSP_DM);
create index IDX_WTDBTSSBB_DJXH on ATFX_TS_YS_WTDBTSSBB (DJXH);
create index IDX_WTDBTSSBB_LCSLID on ATFX_TS_YS_WTDBTSSBB (LCSLID);
create index IDX_WTDBTSSBB_SSQ on ATFX_TS_YS_WTDBTSSBB (SSQ);
create index IDX_WTDBTSSBB_YDJXH on ATFX_TS_YS_WTDBTSSBB (YDJXH);
alter table ATFX_TS_YS_WTDBTSSBB
  add constraint PK_ATFX_TS_YS_WTDBTSSBB primary key (UUID);
alter table ATFX_TS_YS_WTDBTSSBB
  add constraint UK_WTDBTSSBB_SSQ_SBPC_SBXH unique (SSQ, SBPC, SBXH);

prompt
prompt Creating table ATFX_YDZY_CS_MDGDYB
prompt ==================================
prompt
create table ATFX_YDZY_CS_MDGDYB
(
  hggjhdqsz_dm CHAR(3) not null,
  gjhdqsz_dm   CHAR(3) not null,
  gjhdqszm_dm  CHAR(3),
  gjhdqlzm_dm  CHAR(2),
  gjhdqmc      VARCHAR2(200),
  gjhdqjc      VARCHAR2(75),
  gjhdqywmc    VARCHAR2(200),
  gjhdqywjc    VARCHAR2(75),
  xybz         CHAR(1),
  yxbz         CHAR(1),
  mydy         VARCHAR2(50),
  gydy         VARCHAR2(50)
)
;
comment on table ATFX_YDZY_CS_MDGDYB
  is '案头分析-疑点指引-参数-目的国电压表';
comment on column ATFX_YDZY_CS_MDGDYB.hggjhdqsz_dm
  is '海关国家或地区数字代码';
comment on column ATFX_YDZY_CS_MDGDYB.gjhdqsz_dm
  is '国家或地区数字代码';
comment on column ATFX_YDZY_CS_MDGDYB.gjhdqszm_dm
  is '国家或地区三字母代码';
comment on column ATFX_YDZY_CS_MDGDYB.gjhdqlzm_dm
  is '国家或地区俩字母代码';
comment on column ATFX_YDZY_CS_MDGDYB.gjhdqmc
  is '国家或地区名称';
comment on column ATFX_YDZY_CS_MDGDYB.gjhdqjc
  is '国家或地区简称';
comment on column ATFX_YDZY_CS_MDGDYB.gjhdqywmc
  is '国家或地区英文名称';
comment on column ATFX_YDZY_CS_MDGDYB.gjhdqywjc
  is '国家或地区英文简称';
comment on column ATFX_YDZY_CS_MDGDYB.xybz
  is '选用标志';
comment on column ATFX_YDZY_CS_MDGDYB.yxbz
  is '有效标志';
comment on column ATFX_YDZY_CS_MDGDYB.mydy
  is '民用电压';
comment on column ATFX_YDZY_CS_MDGDYB.gydy
  is '工业电压';
alter table ATFX_YDZY_CS_MDGDYB
  add constraint PK_ATFX_YDZY_CS_MDGDYB primary key (HGGJHDQSZ_DM);

prompt
prompt Creating table CKLLFX_CS_FXDJSZ
prompt ===============================
prompt
create table CKLLFX_CS_FXDJSZ
(
  fxdj_dm   VARCHAR2(1) not null,
  fxdj_mc   VARCHAR2(20) not null,
  fxdj_pdbj VARCHAR2(100) not null,
  fxdj_czfs VARCHAR2(100) not null,
  fxdj_yz   NUMBER(5,2) not null
)
;
comment on table CKLLFX_CS_FXDJSZ
  is '出口链路风险等级参数表';
comment on column CKLLFX_CS_FXDJSZ.fxdj_dm
  is '风险等级代码';
comment on column CKLLFX_CS_FXDJSZ.fxdj_mc
  is '风险等级名称';
comment on column CKLLFX_CS_FXDJSZ.fxdj_pdbj
  is '风险等级判定标准';
comment on column CKLLFX_CS_FXDJSZ.fxdj_czfs
  is '风险处置方式';
comment on column CKLLFX_CS_FXDJSZ.fxdj_yz
  is '阈值设置（%小于等于）';
alter table CKLLFX_CS_FXDJSZ
  add constraint PK_CKLLFX_CS_FXDJSZ primary key (FXDJ_DM);

prompt
prompt Creating table CKLLFX_CS_SWJGYJTZ
prompt =================================
prompt
create table CKLLFX_CS_SWJGYJTZ
(
  swjg_dm    VARCHAR2(11) not null,
  tsjsff_dm  CHAR(1) not null,
  ysfs_dm    VARCHAR2(2) not null,
  spdl_dm    VARCHAR2(10) not null,
  qycode_hyd VARCHAR2(2) not null,
  qycode_hg  VARCHAR2(2) not null,
  qycode_mdg VARCHAR2(2) not null,
  fxdj_tz    CHAR(1) not null,
  fxdj_tzrq  DATE,
  fxdj_tzry  VARCHAR2(30),
  fxdj_tzyy  VARCHAR2(200)
)
;
comment on table CKLLFX_CS_SWJGYJTZ
  is '税务机关出口链路预警调整表';
comment on column CKLLFX_CS_SWJGYJTZ.swjg_dm
  is '税务机关代码';
comment on column CKLLFX_CS_SWJGYJTZ.tsjsff_dm
  is '1生产2外贸（目前暂处理外贸）';
comment on column CKLLFX_CS_SWJGYJTZ.ysfs_dm
  is '运输方式代码';
comment on column CKLLFX_CS_SWJGYJTZ.spdl_dm
  is '商品大类（暂设定商品代码前2位）';
comment on column CKLLFX_CS_SWJGYJTZ.qycode_hyd
  is '货源地区域代码';
comment on column CKLLFX_CS_SWJGYJTZ.qycode_hg
  is '启运口岸区域代码';
comment on column CKLLFX_CS_SWJGYJTZ.qycode_mdg
  is '目的国区域代码';
comment on column CKLLFX_CS_SWJGYJTZ.fxdj_tz
  is '调整风险等级代码';
comment on column CKLLFX_CS_SWJGYJTZ.fxdj_tzrq
  is '调整日期';
comment on column CKLLFX_CS_SWJGYJTZ.fxdj_tzry
  is '调整人员';
comment on column CKLLFX_CS_SWJGYJTZ.fxdj_tzyy
  is '调整原因';
alter table CKLLFX_CS_SWJGYJTZ
  add constraint PK_CKLLFX_CS_SWJGYJTZ primary key (SWJG_DM, TSJSFF_DM, YSFS_DM, SPDL_DM, QYCODE_HYD, QYCODE_HG, QYCODE_MDG);

prompt
prompt Creating table CKLLFX_CS_WMQYLSLL
prompt =================================
prompt
create table CKLLFX_CS_WMQYLSLL
(
  ysfs_dm     VARCHAR2(2) not null,
  spdl_dm     VARCHAR2(10) not null,
  qycode_hyd  VARCHAR2(2) not null,
  qycode_hg   VARCHAR2(2) not null,
  qycode_mdg  VARCHAR2(2) not null,
  qyhs_all    NUMBER(10),
  qyzb_all    NUMBER(10,6),
  bgdfs_all   NUMBER(10),
  bgdzb_all   NUMBER(10,6),
  mylaj_all   NUMBER(18,6),
  myzb_all    NUMBER(10,6),
  qyhs_sx     NUMBER(10),
  qyzb_sx     NUMBER(10,6),
  bgdfs_sx    NUMBER(10),
  bgdzb_sx    NUMBER(10,6),
  mylaj_sx    NUMBER(18,6),
  myzb_sx     NUMBER(10,6),
  fxdj_zhfxzs NUMBER(10,6),
  fxdj_dm     CHAR(1)
)
;
comment on table CKLLFX_CS_WMQYLSLL
  is '历史出口链路分析模型表（外贸）';
comment on column CKLLFX_CS_WMQYLSLL.ysfs_dm
  is '运输方式代码';
comment on column CKLLFX_CS_WMQYLSLL.spdl_dm
  is '商品大类（暂设定商品代码前2位）';
comment on column CKLLFX_CS_WMQYLSLL.qycode_hyd
  is '货源地区域代码';
comment on column CKLLFX_CS_WMQYLSLL.qycode_hg
  is '启运口岸区域代码';
comment on column CKLLFX_CS_WMQYLSLL.qycode_mdg
  is '目的国区域代码';
comment on column CKLLFX_CS_WMQYLSLL.qyhs_all
  is '企业户数';
comment on column CKLLFX_CS_WMQYLSLL.qyzb_all
  is '企业占比（%）';
comment on column CKLLFX_CS_WMQYLSLL.bgdfs_all
  is '报关单份数';
comment on column CKLLFX_CS_WMQYLSLL.bgdzb_all
  is '报关单占比（%）';
comment on column CKLLFX_CS_WMQYLSLL.mylaj_all
  is '出口额美元';
comment on column CKLLFX_CS_WMQYLSLL.myzb_all
  is '出口额占比（%）';
comment on column CKLLFX_CS_WMQYLSLL.qyhs_sx
  is '（预留按预警口径筛选）企业户数';
comment on column CKLLFX_CS_WMQYLSLL.qyzb_sx
  is '（预留按预警口径筛选）企业占比（%）';
comment on column CKLLFX_CS_WMQYLSLL.bgdfs_sx
  is '（预留按预警口径筛选）报关单份数';
comment on column CKLLFX_CS_WMQYLSLL.bgdzb_sx
  is '（预留按预警口径筛选）报关单占比（%）';
comment on column CKLLFX_CS_WMQYLSLL.mylaj_sx
  is '（预留按预警口径筛选）出口额美元';
comment on column CKLLFX_CS_WMQYLSLL.myzb_sx
  is '（预留按预警口径筛选）出口额占比（%）';
comment on column CKLLFX_CS_WMQYLSLL.fxdj_zhfxzs
  is '综合风险指数，根据各项占比综合计算';
comment on column CKLLFX_CS_WMQYLSLL.fxdj_dm
  is '风险等级代码，根据综合风险指数，参考参数表设置';
alter table CKLLFX_CS_WMQYLSLL
  add constraint PK_CKLLFX_CS_WMQYLSLL primary key (YSFS_DM, SPDL_DM, QYCODE_HYD, QYCODE_HG, QYCODE_MDG);

prompt
prompt Creating table CKLLFX_CS_WMQYLSLL_DQ
prompt ====================================
prompt
create table CKLLFX_CS_WMQYLSLL_DQ
(
  ysfs_dm     VARCHAR2(2) not null,
  spdl_dm     VARCHAR2(10) not null,
  qycode_hyd  VARCHAR2(2) not null,
  qycode_hg   VARCHAR2(2) not null,
  qycode_mdg  VARCHAR2(2) not null,
  qyhs_all    NUMBER(10),
  qyzb_all    NUMBER(10,6),
  bgdfs_all   NUMBER(10),
  bgdzb_all   NUMBER(10,6),
  mylaj_all   NUMBER(18,6),
  myzb_all    NUMBER(10,6),
  qyhs_sx     NUMBER(10),
  qyzb_sx     NUMBER(10,6),
  bgdfs_sx    NUMBER(10),
  bgdzb_sx    NUMBER(10,6),
  mylaj_sx    NUMBER(18,6),
  myzb_sx     NUMBER(10,6),
  fxdj_zhfxzs NUMBER(10,6),
  fxdj_dm     CHAR(1)
)
;
comment on table CKLLFX_CS_WMQYLSLL_DQ
  is '历史出口链路分析模型表（外贸）';
comment on column CKLLFX_CS_WMQYLSLL_DQ.ysfs_dm
  is '运输方式代码';
comment on column CKLLFX_CS_WMQYLSLL_DQ.spdl_dm
  is '商品大类（暂设定商品代码前2位）';
comment on column CKLLFX_CS_WMQYLSLL_DQ.qycode_hyd
  is '货源地区域代码';
comment on column CKLLFX_CS_WMQYLSLL_DQ.qycode_hg
  is '启运口岸区域代码';
comment on column CKLLFX_CS_WMQYLSLL_DQ.qycode_mdg
  is '目的国区域代码';
comment on column CKLLFX_CS_WMQYLSLL_DQ.qyhs_all
  is '企业户数';
comment on column CKLLFX_CS_WMQYLSLL_DQ.qyzb_all
  is '企业占比（%）';
comment on column CKLLFX_CS_WMQYLSLL_DQ.bgdfs_all
  is '报关单份数';
comment on column CKLLFX_CS_WMQYLSLL_DQ.bgdzb_all
  is '报关单占比（%）';
comment on column CKLLFX_CS_WMQYLSLL_DQ.mylaj_all
  is '出口额美元';
comment on column CKLLFX_CS_WMQYLSLL_DQ.myzb_all
  is '出口额占比（%）';
comment on column CKLLFX_CS_WMQYLSLL_DQ.qyhs_sx
  is '（预留按预警口径筛选）企业户数';
comment on column CKLLFX_CS_WMQYLSLL_DQ.qyzb_sx
  is '（预留按预警口径筛选）企业占比（%）';
comment on column CKLLFX_CS_WMQYLSLL_DQ.bgdfs_sx
  is '（预留按预警口径筛选）报关单份数';
comment on column CKLLFX_CS_WMQYLSLL_DQ.bgdzb_sx
  is '（预留按预警口径筛选）报关单占比（%）';
comment on column CKLLFX_CS_WMQYLSLL_DQ.mylaj_sx
  is '（预留按预警口径筛选）出口额美元';
comment on column CKLLFX_CS_WMQYLSLL_DQ.myzb_sx
  is '（预留按预警口径筛选）出口额占比（%）';
comment on column CKLLFX_CS_WMQYLSLL_DQ.fxdj_zhfxzs
  is '综合风险指数，根据各项占比综合计算';
comment on column CKLLFX_CS_WMQYLSLL_DQ.fxdj_dm
  is '风险等级代码，根据综合风险指数，参考参数表设置';
alter table CKLLFX_CS_WMQYLSLL_DQ
  add constraint PK_CKLLFX_CS_WMQYLSLL_DQ primary key (YSFS_DM, SPDL_DM, QYCODE_HYD, QYCODE_HG, QYCODE_MDG);

prompt
prompt Creating table CKLLFX_CS_WMQYLSLL_SF
prompt ====================================
prompt
create table CKLLFX_CS_WMQYLSLL_SF
(
  ysfs_dm     VARCHAR2(2) not null,
  spdl_dm     VARCHAR2(10) not null,
  qycode_hyd  VARCHAR2(2) not null,
  qycode_hg   VARCHAR2(2) not null,
  qycode_mdg  VARCHAR2(2) not null,
  qyhs_all    NUMBER(10),
  qyzb_all    NUMBER(10,6),
  bgdfs_all   NUMBER(10),
  bgdzb_all   NUMBER(10,6),
  mylaj_all   NUMBER(18,6),
  myzb_all    NUMBER(10,6),
  qyhs_sx     NUMBER(10),
  qyzb_sx     NUMBER(10,6),
  bgdfs_sx    NUMBER(10),
  bgdzb_sx    NUMBER(10,6),
  mylaj_sx    NUMBER(18,6),
  myzb_sx     NUMBER(10,6),
  fxdj_zhfxzs NUMBER(10,6),
  fxdj_dm     CHAR(1)
)
;
comment on table CKLLFX_CS_WMQYLSLL_SF
  is '历史出口链路分析模型表（外贸）';
comment on column CKLLFX_CS_WMQYLSLL_SF.ysfs_dm
  is '运输方式代码';
comment on column CKLLFX_CS_WMQYLSLL_SF.spdl_dm
  is '商品大类（暂设定商品代码前2位）';
comment on column CKLLFX_CS_WMQYLSLL_SF.qycode_hyd
  is '货源地区域代码';
comment on column CKLLFX_CS_WMQYLSLL_SF.qycode_hg
  is '启运口岸区域代码';
comment on column CKLLFX_CS_WMQYLSLL_SF.qycode_mdg
  is '目的国区域代码';
comment on column CKLLFX_CS_WMQYLSLL_SF.qyhs_all
  is '企业户数';
comment on column CKLLFX_CS_WMQYLSLL_SF.qyzb_all
  is '企业占比（%）';
comment on column CKLLFX_CS_WMQYLSLL_SF.bgdfs_all
  is '报关单份数';
comment on column CKLLFX_CS_WMQYLSLL_SF.bgdzb_all
  is '报关单占比（%）';
comment on column CKLLFX_CS_WMQYLSLL_SF.mylaj_all
  is '出口额美元';
comment on column CKLLFX_CS_WMQYLSLL_SF.myzb_all
  is '出口额占比（%）';
comment on column CKLLFX_CS_WMQYLSLL_SF.qyhs_sx
  is '（预留按预警口径筛选）企业户数';
comment on column CKLLFX_CS_WMQYLSLL_SF.qyzb_sx
  is '（预留按预警口径筛选）企业占比（%）';
comment on column CKLLFX_CS_WMQYLSLL_SF.bgdfs_sx
  is '（预留按预警口径筛选）报关单份数';
comment on column CKLLFX_CS_WMQYLSLL_SF.bgdzb_sx
  is '（预留按预警口径筛选）报关单占比（%）';
comment on column CKLLFX_CS_WMQYLSLL_SF.mylaj_sx
  is '（预留按预警口径筛选）出口额美元';
comment on column CKLLFX_CS_WMQYLSLL_SF.myzb_sx
  is '（预留按预警口径筛选）出口额占比（%）';
comment on column CKLLFX_CS_WMQYLSLL_SF.fxdj_zhfxzs
  is '综合风险指数，根据各项占比综合计算';
comment on column CKLLFX_CS_WMQYLSLL_SF.fxdj_dm
  is '风险等级代码，根据综合风险指数，参考参数表设置';
alter table CKLLFX_CS_WMQYLSLL_SF
  add constraint PK_CKLLFX_CS_WMQYLSLL_SF primary key (YSFS_DM, SPDL_DM, QYCODE_HYD, QYCODE_HG, QYCODE_MDG);

prompt
prompt Creating table CKLLFX_DATA_BGDWL
prompt ================================
prompt
create table CKLLFX_DATA_BGDWL
(
  djxh         NUMBER(20) not null,
  bgdhgbh      VARCHAR2(21) not null,
  dlzmh        VARCHAR2(20),
  tmsjsff_dm   CHAR(1) not null,
  ckrq_1       DATE not null,
  mylaj        NUMBER(18,2) not null,
  ysfs_dm      CHAR(1) not null,
  hzdwdq_dm    CHAR(5) not null,
  hggqka_dm    CHAR(4) not null,
  zzmdgdqsz_dm CHAR(3) not null,
  spdl_dm      VARCHAR2(10),
  fhms_dm      CHAR(1),
  jzxh         VARCHAR2(40),
  jhpzh        VARCHAR2(75),
  ghfnsrsbh_1  VARCHAR2(20),
  ghfnsrmc     VARCHAR2(100),
  ghfnsrswjg   VARCHAR2(11),
  qycode_hyd   VARCHAR2(2),
  qycode_hg    VARCHAR2(2),
  qycode_mdg   VARCHAR2(2),
  fxdj_zhfxzs  NUMBER(10,6),
  fxdj_dm      CHAR(1),
  fxdj_gxrq    DATE,
  fxdj_tz      CHAR(1),
  fzdj_tzyy    VARCHAR2(200),
  wlxxly_dm    CHAR(1),
  ckfph        VARCHAR2(30),
  cph          VARCHAR2(500),
  qyrq         DATE,
  qyd          VARCHAR2(500),
  tydh         VARCHAR2(32),
  qyd_xzqh     VARCHAR2(6),
  tdlx_dm      CHAR(1),
  gjewmzt_dm   CHAR(1),
  bz           VARCHAR2(100),
  sjgxsj       DATE not null,
  ckfpbz       VARCHAR2(2000),
  ckmxbz       VARCHAR2(2000),
  wlxxly_bz    NUMBER(2),
  cpys_code    VARCHAR2(50),
  cpys_name    VARCHAR2(50)
)
;
comment on table CKLLFX_DATA_BGDWL
  is '企业出口链路信息表';
comment on column CKLLFX_DATA_BGDWL.djxh
  is '金三企业登记序号';
comment on column CKLLFX_DATA_BGDWL.bgdhgbh
  is '出口报关单号（18位）';
comment on column CKLLFX_DATA_BGDWL.dlzmh
  is '代理证明号，代理出口的需保留用于提取出口关联信息';
comment on column CKLLFX_DATA_BGDWL.tmsjsff_dm
  is '退（免）税计算方法代码（1生产/2外贸），根据业务提取';
comment on column CKLLFX_DATA_BGDWL.ckrq_1
  is '出口日期，来自报关单201';
comment on column CKLLFX_DATA_BGDWL.mylaj
  is '美元离岸价，来自报关单201';
comment on column CKLLFX_DATA_BGDWL.ysfs_dm
  is '运输方式，来自报关单201';
comment on column CKLLFX_DATA_BGDWL.hzdwdq_dm
  is '境内货源地，来自报关单201';
comment on column CKLLFX_DATA_BGDWL.hggqka_dm
  is '离境口岸（启运港业务取启运口岸，其他取出口口岸），来自报关单201';
comment on column CKLLFX_DATA_BGDWL.zzmdgdqsz_dm
  is '目的国，来自报关单';
comment on column CKLLFX_DATA_BGDWL.spdl_dm
  is '商品大类（暂设定商品代码前2位）';
comment on column CKLLFX_DATA_BGDWL.fhms_dm
  is '发货模式（1整柜/2散货(拼箱)），根据报关单204表判断';
comment on column CKLLFX_DATA_BGDWL.jzxh
  is '集装箱号（一票业务多个集装箱的列举一个集装箱加括号集装箱数量），来自报关单204';
comment on column CKLLFX_DATA_BGDWL.jhpzh
  is '进货凭证号，按金额占比取最大供应商税号对应的任一笔进货凭证，用于发票系统查询供货商名称及主管税务机关';
comment on column CKLLFX_DATA_BGDWL.ghfnsrsbh_1
  is '供应商税号，来自进货明细，按金额占比取最大供应商税号';
comment on column CKLLFX_DATA_BGDWL.ghfnsrmc
  is '供应商名称，来自发票底账库';
comment on column CKLLFX_DATA_BGDWL.ghfnsrswjg
  is '供应商主管税务机关（区县级），来自发票底账库';
comment on column CKLLFX_DATA_BGDWL.qycode_hyd
  is '货源地区域，由供应商主管税务机关或境内货源地，对应到某个境内区域代码';
comment on column CKLLFX_DATA_BGDWL.qycode_hg
  is '离境地区域，由离境口岸对应到境内区域代码';
comment on column CKLLFX_DATA_BGDWL.qycode_mdg
  is '目的国区域，由目的国对应到境外区域代码';
comment on column CKLLFX_DATA_BGDWL.fxdj_zhfxzs
  is '综合风险指数=出口链路规则命中的综合风险指数，由0至100，值越小风险越高';
comment on column CKLLFX_DATA_BGDWL.fxdj_dm
  is '风险等级=出口链路规则命中的风险等级';
comment on column CKLLFX_DATA_BGDWL.fxdj_gxrq
  is '风险刷新日期，刷新记录路径风险等级的日期值';
comment on column CKLLFX_DATA_BGDWL.fxdj_tz
  is '风险等级调整，人工经轨迹验证后手工调整风险等级（高/中/低/常规）';
comment on column CKLLFX_DATA_BGDWL.fzdj_tzyy
  is '风险调整原因，风险等级调整原因说明';
comment on column CKLLFX_DATA_BGDWL.wlxxly_dm
  is '物流信息采集源（1出口发票/2申报表/3核查报送）';
comment on column CKLLFX_DATA_BGDWL.ckfph
  is '出口发票号，用于提取物流信息';
comment on column CKLLFX_DATA_BGDWL.cph
  is '车牌号，物流信息要素1，由企业报送采集';
comment on column CKLLFX_DATA_BGDWL.qyrq
  is '起运日，物流信息要素2，由企业报送采集';
comment on column CKLLFX_DATA_BGDWL.qyd
  is '起运地，物流信息要素3，由企业报送采集';
comment on column CKLLFX_DATA_BGDWL.tydh
  is '提运单号，物流信息要素4，默认从报关单获取，核查时企业可更正';
comment on column CKLLFX_DATA_BGDWL.qyd_xzqh
  is '起运地行政区划（预留），将起运地转行政区划代码';
comment on column CKLLFX_DATA_BGDWL.tdlx_dm
  is '提单类型代码（预留，1船东提单/2货代提单）';
comment on column CKLLFX_DATA_BGDWL.gjewmzt_dm
  is '轨迹二维码生成状态（空/0-未生成，1-已生成）';
comment on column CKLLFX_DATA_BGDWL.bz
  is '备注，由税务人员自由填写';
comment on column CKLLFX_DATA_BGDWL.sjgxsj
  is '数据修改时间，表示记录的最近更新时间';
comment on column CKLLFX_DATA_BGDWL.ckfpbz
  is '出口发票备注';
comment on column CKLLFX_DATA_BGDWL.ckmxbz
  is '出口明细备注';
comment on column CKLLFX_DATA_BGDWL.wlxxly_bz
  is '后台解析物流信息标志（含义参考存储过程PRO_FXGL_SZYJ_WLXX）';
comment on column CKLLFX_DATA_BGDWL.cpys_code
  is '车牌颜色(1：蓝色；2：黄色；3：黄绿色)';
comment on column CKLLFX_DATA_BGDWL.cpys_name
  is '车牌颜色名称';
create index IDX_CKLLFX_DATA_BGDWL_SJGXSJ on CKLLFX_DATA_BGDWL (SJGXSJ);
alter table CKLLFX_DATA_BGDWL
  add constraint PK_CKLLFX_DATA_BGDWL primary key (DJXH, BGDHGBH);

prompt
prompt Creating table CKTS_BA_BABGQK_JGB
prompt =================================
prompt
create table CKTS_BA_BABGQK_JGB
(
  uuid        VARCHAR2(32) not null,
  lcslid      CHAR(32) not null,
  djxh        NUMBER(20) not null,
  bgq         VARCHAR2(3000),
  bgh         VARCHAR2(3000),
  bz          VARCHAR2(3000),
  lrr_dm      CHAR(11) not null,
  lrrq        DATE not null,
  tsswjg_dm_1 CHAR(11) not null,
  xgr_dm      CHAR(11),
  xgrq        DATE,
  sjgsdq      CHAR(11) not null,
  sjtb_sj     TIMESTAMP(6),
  tbrq_1      DATE,
  babgzd_dm   VARCHAR2(30),
  babgzdmc    VARCHAR2(150),
  fszl        VARCHAR2(450),
  ckzhuuid    VARCHAR2(32),
  bz_1        CHAR(1)
)
;
comment on table CKTS_BA_BABGQK_JGB
  is '备案变更情况结果表';
comment on column CKTS_BA_BABGQK_JGB.uuid
  is 'UUID||uuid';
comment on column CKTS_BA_BABGQK_JGB.lcslid
  is '流程实例ID';
comment on column CKTS_BA_BABGQK_JGB.djxh
  is '登记序号';
comment on column CKTS_BA_BABGQK_JGB.bgq
  is '变更前';
comment on column CKTS_BA_BABGQK_JGB.bgh
  is '变更后';
comment on column CKTS_BA_BABGQK_JGB.bz
  is '备注';
comment on column CKTS_BA_BABGQK_JGB.lrr_dm
  is '录入人代码';
comment on column CKTS_BA_BABGQK_JGB.lrrq
  is '录入日期';
comment on column CKTS_BA_BABGQK_JGB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_BA_BABGQK_JGB.xgr_dm
  is '修改人代码';
comment on column CKTS_BA_BABGQK_JGB.xgrq
  is '修改日期';
comment on column CKTS_BA_BABGQK_JGB.sjgsdq
  is '数据归属地区';
comment on column CKTS_BA_BABGQK_JGB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_BA_BABGQK_JGB.tbrq_1
  is '填表日期';
comment on column CKTS_BA_BABGQK_JGB.babgzd_dm
  is '备案变更字段代码';
comment on column CKTS_BA_BABGQK_JGB.babgzdmc
  is '备案变更字段名称';
comment on column CKTS_BA_BABGQK_JGB.fszl
  is '附送资料||应用于进出口退税';
comment on column CKTS_BA_BABGQK_JGB.ckzhuuid
  is '存款账号UUID';
comment on column CKTS_BA_BABGQK_JGB.bz_1
  is '标志';
create index IDX_CKTS_BA_BABGQK_JGB_DB on CKTS_BA_BABGQK_JGB (DJXH, BABGZD_DM);
create index IDX_CKTS_BA_BABGQK_JGB_L on CKTS_BA_BABGQK_JGB (LCSLID);
alter table CKTS_BA_BABGQK_JGB
  add constraint PK_CKTS_BA_BABGQK_JGB primary key (UUID);

prompt
prompt Creating table CKTS_DJ_BGDJMX
prompt =============================
prompt
create table CKTS_DJ_BGDJMX
(
  bgdjmxuuid VARCHAR2(32) not null,
  djxh       NUMBER(20) not null,
  bgxm_dm    VARCHAR2(13) not null,
  lrrq       DATE not null,
  bgqnr      VARCHAR2(200),
  bghnr      VARCHAR2(200)
)
;
comment on table CKTS_DJ_BGDJMX
  is '出口企业法人代表变更日志';
comment on column CKTS_DJ_BGDJMX.bgdjmxuuid
  is '变更登记明细UUID，主键';
comment on column CKTS_DJ_BGDJMX.djxh
  is '登记序号';
comment on column CKTS_DJ_BGDJMX.bgxm_dm
  is '变更项目代码(''030'',''086'',''112'')';
comment on column CKTS_DJ_BGDJMX.lrrq
  is '录入日期';
comment on column CKTS_DJ_BGDJMX.bgqnr
  is '变更前内容';
comment on column CKTS_DJ_BGDJMX.bghnr
  is '变更后内容';
create index CKTS_DJ_BGDJMX_DJXH_LRRQ on CKTS_DJ_BGDJMX (DJXH, LRRQ);
alter table CKTS_DJ_BGDJMX
  add constraint PK_DJ_BGDJMX primary key (BGDJMXUUID);

prompt
prompt Creating table CKTS_DJ_NSRXX
prompt ============================
prompt
create table CKTS_DJ_NSRXX
(
  djxh           NUMBER(20) not null,
  zgswj_dm       CHAR(11),
  nsrsbh         VARCHAR2(20) not null,
  nsrmc          VARCHAR2(300) not null,
  zcdz           VARCHAR2(300),
  scjydz         VARCHAR2(300),
  jyfw           VARCHAR2(3600),
  fddbrxm        VARCHAR2(150),
  fddbrsfzjlx_dm CHAR(3),
  fddbrsfzjhm    VARCHAR2(30),
  fddbrgddh      VARCHAR2(60),
  fddbryddh      VARCHAR2(60),
  cwfzrxm        VARCHAR2(150),
  cwfzrsfzjzl_dm CHAR(3),
  cwfzrsfzjhm    VARCHAR2(30),
  bsrxm          VARCHAR2(150),
  bsrsfzjzl_dm   CHAR(3),
  bsrsfzjhm      VARCHAR2(30),
  nsrzt_dm       CHAR(2) not null,
  djrq           DATE not null,
  ybnsrrdrq      DATE,
  fzcrdrq        DATE,
  zxrq           DATE,
  lrrq           DATE not null,
  xgrq           DATE
)
;
comment on column CKTS_DJ_NSRXX.nsrsbh
  is 'NVL(SHXYDM,NSRSBH)';
comment on column CKTS_DJ_NSRXX.xgrq
  is '增量同步用';
create index IDX_CKTS_DJ_NSRXX_FDDBRSFZJHM on CKTS_DJ_NSRXX (FDDBRSFZJHM)
  nologging;
create index IDX_CKTS_DJ_NSRXX_FDRXM on CKTS_DJ_NSRXX (FDDBRXM)
  nologging;
create index IDX_CKTS_DJ_NSRXX_NSRMC on CKTS_DJ_NSRXX (NSRMC)
  nologging;
create index IDX_CKTS_DJ_NSRXX_NSRSBH on CKTS_DJ_NSRXX (NSRSBH)
  nologging;
create index IDX_CKTS_DJ_NSRXX_ZCDZ on CKTS_DJ_NSRXX (ZCDZ)
  nologging;
create index IDX_CKTS_DJ_NSRXX_ZGSWJ on CKTS_DJ_NSRXX (ZGSWJ_DM)
  nologging;
alter table CKTS_DJ_NSRXX
  add constraint PK_DJ_NSRXX primary key (DJXH);

prompt
prompt Creating table CKTS_DM_CKYZS
prompt ============================
prompt
create table CKTS_DM_CKYZS
(
  jgfs_dm CHAR(4) not null,
  jgfsmc  VARCHAR2(150) not null
)
;
comment on table CKTS_DM_CKYZS
  is '省局货劳处给的出口应征税对应监管方式';
comment on column CKTS_DM_CKYZS.jgfs_dm
  is '监管方式代码';
comment on column CKTS_DM_CKYZS.jgfsmc
  is '监管方式名称';
alter table CKTS_DM_CKYZS
  add constraint PK_CKTS_DM_CKYZS primary key (JGFS_DM);

prompt
prompt Creating table CKTS_LC_JCZBBL
prompt =============================
prompt
create table CKTS_LC_JCZBBL
(
  uuid          VARCHAR2(32) not null,
  sbywb_dm      VARCHAR2(16),
  tsswjg_dm_1   CHAR(11),
  lcslid        CHAR(32),
  djxh          NUMBER(20) not null,
  ssq           VARCHAR2(60),
  sbpc          VARCHAR2(75),
  glh           VARCHAR2(30),
  ytse_1        NUMBER(18,6),
  ydnr          VARCHAR2(3000),
  zhshclyjlx_dm CHAR(1),
  jczbblzt_dm   CHAR(1),
  lrr_dm        CHAR(11),
  lrrq          DATE,
  xgrq          DATE
)
;
comment on table CKTS_LC_JCZBBL
  is '解除暂不办理退税结果表';
comment on column CKTS_LC_JCZBBL.uuid
  is 'UUID||uuid';
comment on column CKTS_LC_JCZBBL.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_LC_JCZBBL.lcslid
  is '流程实例ID';
comment on column CKTS_LC_JCZBBL.djxh
  is '登记序号';
comment on column CKTS_LC_JCZBBL.ssq
  is '所属期';
comment on column CKTS_LC_JCZBBL.sbpc
  is '申报批次';
comment on column CKTS_LC_JCZBBL.glh
  is '关联号';
comment on column CKTS_LC_JCZBBL.ytse_1
  is '应退税额';
comment on column CKTS_LC_JCZBBL.ydnr
  is '疑点内容';
comment on column CKTS_LC_JCZBBL.zhshclyjlx_dm
  is '综合审核处理意见类型代码';
comment on column CKTS_LC_JCZBBL.jczbblzt_dm
  is '解除暂不办理状态代码';
comment on column CKTS_LC_JCZBBL.lrr_dm
  is '录入人代码';
comment on column CKTS_LC_JCZBBL.lrrq
  is '录入日期';
comment on column CKTS_LC_JCZBBL.xgrq
  is '修改日期';
alter table CKTS_LC_JCZBBL
  add constraint PK_CKTS_LC_JCZBBL primary key (UUID);

prompt
prompt Creating table CKTS_LC_SBXX
prompt ===========================
prompt
create table CKTS_LC_SBXX
(
  uuid        VARCHAR2(32) not null,
  tsswjg_dm   CHAR(11),
  djxh        NUMBER(20),
  ckqygllb_dm CHAR(1),
  wzhbz       CHAR(1),
  sbywb_dm    VARCHAR2(16),
  ssq         VARCHAR2(60),
  sbpc        VARCHAR2(75),
  lcslid_sb   CHAR(32),
  zfbz        CHAR(1),
  zfr_dm      CHAR(11),
  zfrq        DATE,
  sbrq        DATE,
  sb_xsemy    NUMBER(18,2),
  sb_xsermb   NUMBER(18,2),
  sb_mdtse    NUMBER(18,6),
  sb_zzstse   NUMBER(18,6),
  sb_xfstse   NUMBER(18,6),
  sb_mdse     NUMBER(18,6),
  sjtb_sj     TIMESTAMP(6),
  xgrq        DATE,
  sjtb_bz     CHAR(1) default '0',
  dysltzsj    DATE,
  qdsj        DATE,
  qdr_dm      CHAR(11),
  htbz_1      CHAR(1)
)
;
comment on table CKTS_LC_SBXX
  is '流程申报信息表';
comment on column CKTS_LC_SBXX.uuid
  is 'UUID';
comment on column CKTS_LC_SBXX.tsswjg_dm
  is '退税税务机关代码';
comment on column CKTS_LC_SBXX.djxh
  is '登记序号';
comment on column CKTS_LC_SBXX.ckqygllb_dm
  is '出口企业管理类别代码';
comment on column CKTS_LC_SBXX.wzhbz
  is '无纸化标志';
comment on column CKTS_LC_SBXX.sbywb_dm
  is '申报业务表代码（根据流程税务事项转换）';
comment on column CKTS_LC_SBXX.ssq
  is '所属期';
comment on column CKTS_LC_SBXX.sbpc
  is '申报批次';
comment on column CKTS_LC_SBXX.lcslid_sb
  is '申报LCSLID（根据业务事项取ZLCLCSLID=LCSLID的ZLCLCSLID)';
comment on column CKTS_LC_SBXX.zfbz
  is '作废标志';
comment on column CKTS_LC_SBXX.zfr_dm
  is '作废人代码';
comment on column CKTS_LC_SBXX.zfrq
  is '作废日期';
comment on column CKTS_LC_SBXX.sbrq
  is '申报日期（从便捷退税获取）';
comment on column CKTS_LC_SBXX.sb_xsemy
  is '申报销售额（美元）';
comment on column CKTS_LC_SBXX.sb_xsermb
  is '申报销售额（人民币）';
comment on column CKTS_LC_SBXX.sb_mdtse
  is '申报免抵退税额';
comment on column CKTS_LC_SBXX.sb_zzstse
  is '申报增值税退税额';
comment on column CKTS_LC_SBXX.sb_xfstse
  is '申报消费税退税额';
comment on column CKTS_LC_SBXX.sb_mdse
  is '申报免抵税额';
comment on column CKTS_LC_SBXX.sjtb_sj
  is '数据同步时间';
comment on column CKTS_LC_SBXX.xgrq
  is '修改日期NVL(T.XGRQ,T.LRRQ)-增量用';
comment on column CKTS_LC_SBXX.sjtb_bz
  is '错误继续标志';
comment on column CKTS_LC_SBXX.dysltzsj
  is '打印受理通知时间';
comment on column CKTS_LC_SBXX.qdsj
  is '启动时间';
comment on column CKTS_LC_SBXX.qdr_dm
  is '启动人代码';
comment on column CKTS_LC_SBXX.htbz_1
  is '回退标志';
create index IDX_CKTS_LC_SBXX_DQ on CKTS_LC_SBXX (DJXH, QDSJ)
  nologging;
create index IDX_CKTS_LC_SBXX_DSSS on CKTS_LC_SBXX (DJXH, SBYWB_DM, SSQ, SBPC)
  nologging;
create index IDX_CKTS_LC_SBXX_LCSLID on CKTS_LC_SBXX (LCSLID_SB)
  nologging;
create index IDX_CKTS_LC_SBXX_SBRQ on CKTS_LC_SBXX (SBRQ)
  nologging;
create index IDX_CKTS_LC_SBXX_TQ on CKTS_LC_SBXX (TSSWJG_DM, QDSJ)
  nologging;
create index IDX_CKTS_LC_SBXX_TS on CKTS_LC_SBXX (TSSWJG_DM, SBRQ)
  nologging;
alter table CKTS_LC_SBXX
  add constraint PK_CKTS_LC_SBXX primary key (UUID);
alter index PK_CKTS_LC_SBXX nologging;

prompt
prompt Creating table CKTS_LC_SEHZXX
prompt =============================
prompt
create table CKTS_LC_SEHZXX
(
  uuid             VARCHAR2(32) not null,
  lcslid_fs        CHAR(32),
  tsswjg_dm        CHAR(11),
  djxh             NUMBER(20),
  ywhzbuuid        VARCHAR2(32),
  ywhzbid          VARCHAR2(10),
  xh               VARCHAR2(10),
  sehzr_dm         CHAR(11),
  sehzrq           DATE,
  sehz_mdtse       NUMBER(18,6),
  sehz_zzstse      NUMBER(18,6),
  sehz_xfstse      NUMBER(18,6),
  sehz_mdse        NUMBER(18,6),
  byhz_mdtse       NUMBER(18,6),
  byhz_zzstse      NUMBER(18,6),
  byhz_xfstse      NUMBER(18,6),
  byhz_mdse        NUMBER(18,6),
  lrr_dm           CHAR(11),
  zzssssrthsbh     VARCHAR2(32),
  xfssssrthsbh     VARCHAR2(32),
  gztktzsbh        VARCHAR2(32),
  sjtb_sj          TIMESTAMP(6),
  xgrq             DATE,
  sjtb_bz          CHAR(1) default '0',
  gkbl_mdtse       NUMBER(18,6),
  gkbl_zzstse      NUMBER(18,6),
  gkbl_xfstse      NUMBER(18,6),
  gkbl_mdse        NUMBER(18,6),
  sbywb_dm         VARCHAR2(16),
  ssq              VARCHAR2(60),
  sbpc             VARCHAR2(75),
  ckqygllb_dm      CHAR(1),
  wzhbz            CHAR(1),
  lctjjc           CHAR(2) default '10',
  cktmshwysfwlx_dm CHAR(1),
  snckzb           NUMBER(18,6),
  xhrq_tk          DATE default DATE'2100-12-31',
  xhrq_md          DATE default DATE'2100-12-31',
  cktmsjhssswjgdm  CHAR(11),
  mdtkssswjgdm     CHAR(11),
  xhrq_xfs         DATE default DATE'2100-12-31',
  kprq             DATE default DATE'2100-12-31'
)
;
comment on table CKTS_LC_SEHZXX
  is '税额核准信息表';
comment on column CKTS_LC_SEHZXX.uuid
  is 'UUID';
comment on column CKTS_LC_SEHZXX.lcslid_fs
  is '复审LCSLID';
comment on column CKTS_LC_SEHZXX.tsswjg_dm
  is '退税税务机关代码';
comment on column CKTS_LC_SEHZXX.djxh
  is '登记序号';
comment on column CKTS_LC_SEHZXX.ywhzbuuid
  is '业务核准表UUID';
comment on column CKTS_LC_SEHZXX.ywhzbid
  is '业务核准表ID';
comment on column CKTS_LC_SEHZXX.xh
  is '项号';
comment on column CKTS_LC_SEHZXX.sehzr_dm
  is '税额核准人代码';
comment on column CKTS_LC_SEHZXX.sehzrq
  is '税额核准日期';
comment on column CKTS_LC_SEHZXX.sehz_mdtse
  is '税额核准免抵退税额';
comment on column CKTS_LC_SEHZXX.sehz_zzstse
  is '税额核准增值税退税额';
comment on column CKTS_LC_SEHZXX.sehz_xfstse
  is '税额核准消费税退税额';
comment on column CKTS_LC_SEHZXX.sehz_mdse
  is '税额核准免抵税额';
comment on column CKTS_LC_SEHZXX.byhz_mdtse
  is '不予核准免抵退税额';
comment on column CKTS_LC_SEHZXX.byhz_zzstse
  is '不予核准增值税退税额';
comment on column CKTS_LC_SEHZXX.byhz_xfstse
  is '不予核准消费税退税额';
comment on column CKTS_LC_SEHZXX.byhz_mdse
  is '不予核准免抵税额';
comment on column CKTS_LC_SEHZXX.lrr_dm
  is '录入人代码，主要用于区分迁移数据';
comment on column CKTS_LC_SEHZXX.zzssssrthsbh
  is '增值税税收收入退还书编号';
comment on column CKTS_LC_SEHZXX.xfssssrthsbh
  is '消费税税收收入退还书编号';
comment on column CKTS_LC_SEHZXX.gztktzsbh
  is '更正（调库）通知书编号';
comment on column CKTS_LC_SEHZXX.sjtb_sj
  is '数据同步时间';
comment on column CKTS_LC_SEHZXX.xgrq
  is '修改日期NVL(T.XGRQ,T.LRRQ)-增量用';
comment on column CKTS_LC_SEHZXX.sjtb_bz
  is '错误继续标志';
comment on column CKTS_LC_SEHZXX.gkbl_mdtse
  is '国库办理免抵退税额';
comment on column CKTS_LC_SEHZXX.gkbl_zzstse
  is '国库办理增值税退税额';
comment on column CKTS_LC_SEHZXX.gkbl_xfstse
  is '国库办理消费税退税额';
comment on column CKTS_LC_SEHZXX.gkbl_mdse
  is '国库办理免抵税额';
comment on column CKTS_LC_SEHZXX.sbywb_dm
  is '申报业务表代码（根据流程税务事项转换）';
comment on column CKTS_LC_SEHZXX.ssq
  is '所属期';
comment on column CKTS_LC_SEHZXX.sbpc
  is '申报批次';
comment on column CKTS_LC_SEHZXX.ckqygllb_dm
  is '出口企业管理类别代码';
comment on column CKTS_LC_SEHZXX.wzhbz
  is '无纸化标志';
comment on column CKTS_LC_SEHZXX.lctjjc
  is '流程统计级次，默认外贸企业';
comment on column CKTS_LC_SEHZXX.cktmshwysfwlx_dm
  is '出口退（免）税货物应税服务类型代码';
comment on column CKTS_LC_SEHZXX.snckzb
  is '上年出口占比';
comment on column CKTS_LC_SEHZXX.xhrq_tk
  is '销号日期退库（增值税）';
comment on column CKTS_LC_SEHZXX.xhrq_md
  is '销号日期免抵';
comment on column CKTS_LC_SEHZXX.cktmsjhssswjgdm
  is '出口退（免）税计划所属税务机关代码';
comment on column CKTS_LC_SEHZXX.mdtkssswjgdm
  is '免抵调库税务机关代码';
comment on column CKTS_LC_SEHZXX.xhrq_xfs
  is '销号日期退库（消费税）';
comment on column CKTS_LC_SEHZXX.kprq
  is '金三开票日期（退税）';
create index IDX_CKTS_LC_SEHZXX_CTX1 on CKTS_LC_SEHZXX (CKTMSJHSSSWJGDM, XHRQ_TK)
  nologging;
create index IDX_CKTS_LC_SEHZXX_CTX2 on CKTS_LC_SEHZXX (MDTKSSSWJGDM, XHRQ_MD)
  nologging;
create index IDX_CKTS_LC_SEHZXX_CTX3 on CKTS_LC_SEHZXX (CKTMSJHSSSWJGDM, XHRQ_XFS)
  nologging;
create index IDX_CKTS_LC_SEHZXX_DS on CKTS_LC_SEHZXX (DJXH, SEHZRQ)
  nologging;
create index IDX_CKTS_LC_SEHZXX_DSSS on CKTS_LC_SEHZXX (DJXH, SBYWB_DM, SSQ, SBPC)
  nologging;
create index IDX_CKTS_LC_SEHZXX_LCSLIDFS on CKTS_LC_SEHZXX (LCSLID_FS)
  nologging;
create index IDX_CKTS_LC_SEHZXX_TS on CKTS_LC_SEHZXX (TSSWJG_DM, SEHZRQ)
  nologging;
create index IDX_CKTS_LC_SEHZXX_YX on CKTS_LC_SEHZXX (YWHZBUUID, XH)
  nologging;
alter table CKTS_LC_SEHZXX
  add constraint PK_CKTS_LC_SEHZXX primary key (UUID);
alter index PK_CKTS_LC_SEHZXX nologging;

prompt
prompt Creating table CKTS_LC_SHXX
prompt ===========================
prompt
create table CKTS_LC_SHXX
(
  uuid             VARCHAR2(32) not null,
  cktmshwysfwlx_dm CHAR(1),
  tsswjg_dm        CHAR(11),
  djxh             NUMBER(20),
  ckqygllb_dm      CHAR(1),
  wzhbz            CHAR(1),
  sbywb_dm         VARCHAR2(16),
  ssq              VARCHAR2(60),
  sbpc             VARCHAR2(75),
  lcslid           CHAR(32),
  lcslid_sb        CHAR(32) default ' ',
  lcslid_fs        CHAR(32) default ' ',
  zfbz             CHAR(1),
  zfr_dm           CHAR(11),
  zfrq             DATE,
  qdr_dm           CHAR(11),
  qdsj             DATE,
  ffbz             CHAR(1),
  ffr_dm           CHAR(11),
  ffrq             DATE,
  sjtb_sj          TIMESTAMP(6),
  lctjjc           CHAR(2) default '00',
  lcjsrq           DATE default TO_DATE('2100-12-31','YYYY-MM-DD'),
  sb_xsemy         NUMBER(18,2),
  sb_xsermb        NUMBER(18,2),
  sb_mdtse         NUMBER(18,6),
  sb_zzstse        NUMBER(18,6),
  sb_xfstse        NUMBER(18,6),
  sb_mdse          NUMBER(18,6),
  by_mdtse         NUMBER(18,6),
  by_zzstse        NUMBER(18,6),
  by_xfstse        NUMBER(18,6),
  by_mdse          NUMBER(18,6),
  zy_mdtse         NUMBER(18,6),
  zy_zzstse        NUMBER(18,6),
  zy_xfstse        NUMBER(18,6),
  zy_mdse          NUMBER(18,6),
  zh_mdtse         NUMBER(18,6),
  zh_zzstse        NUMBER(18,6),
  zh_xfstse        NUMBER(18,6),
  zh_mdse          NUMBER(18,6),
  snbl_mdtse       NUMBER(18,6),
  snbl_zzstse      NUMBER(18,6),
  snbl_xfstse      NUMBER(18,6),
  snbl_mdse        NUMBER(18,6),
  sybl_mdtse       NUMBER(18,6),
  sybl_zzstse      NUMBER(18,6),
  sybl_xfstse      NUMBER(18,6),
  sybl_mdse        NUMBER(18,6),
  xgrq             DATE,
  sjtb_bz          CHAR(1) default '0',
  byhz_mdtse       NUMBER(18,6),
  byhz_zzstse      NUMBER(18,6),
  byhz_xfstse      NUMBER(18,6),
  byhz_mdse        NUMBER(18,6),
  zlclcslid        CHAR(32),
  lcswsx_dm        VARCHAR2(16),
  lastopdate       DATE default TO_DATE('1900-01-01','YYYY-MM-DD'),
  bybl_mdtse       NUMBER(18,6) default 0,
  bybl_zzstse      NUMBER(18,6) default 0,
  bybl_xfstse      NUMBER(18,6) default 0,
  bybl_mdse        NUMBER(18,6) default 0
)
;
comment on table CKTS_LC_SHXX
  is '流程审核分流信息表';
comment on column CKTS_LC_SHXX.uuid
  is 'UUID';
comment on column CKTS_LC_SHXX.cktmshwysfwlx_dm
  is '出口退（免）税货物应税服务类型代码 1:货物，2:服务';
comment on column CKTS_LC_SHXX.tsswjg_dm
  is '退税税务机关代码';
comment on column CKTS_LC_SHXX.djxh
  is '登记序号';
comment on column CKTS_LC_SHXX.ckqygllb_dm
  is '出口企业管理类别代码';
comment on column CKTS_LC_SHXX.wzhbz
  is '无纸化标志';
comment on column CKTS_LC_SHXX.sbywb_dm
  is '申报业务表代码（根据流程税务事项转换）';
comment on column CKTS_LC_SHXX.ssq
  is '所属期';
comment on column CKTS_LC_SHXX.sbpc
  is '申报批次';
comment on column CKTS_LC_SHXX.lcslid
  is '分流LCSLID';
comment on column CKTS_LC_SHXX.lcslid_sb
  is '申报LCSLID';
comment on column CKTS_LC_SHXX.lcslid_fs
  is '复审LCSLID';
comment on column CKTS_LC_SHXX.zfbz
  is '作废标志';
comment on column CKTS_LC_SHXX.zfr_dm
  is '作废人代码';
comment on column CKTS_LC_SHXX.zfrq
  is '作废日期';
comment on column CKTS_LC_SHXX.qdr_dm
  is '启动人代码';
comment on column CKTS_LC_SHXX.qdsj
  is '启动时间';
comment on column CKTS_LC_SHXX.ffbz
  is '发放标志';
comment on column CKTS_LC_SHXX.ffr_dm
  is '发放人代码';
comment on column CKTS_LC_SHXX.ffrq
  is '发放日期';
comment on column CKTS_LC_SHXX.sjtb_sj
  is '数据同步时间';
comment on column CKTS_LC_SHXX.lctjjc
  is '流程统计级次，默认外贸企业';
comment on column CKTS_LC_SHXX.lcjsrq
  is '流程结束日期，默认2100-12-31';
comment on column CKTS_LC_SHXX.sb_xsemy
  is '申报销售额（美元）';
comment on column CKTS_LC_SHXX.sb_xsermb
  is '申报销售额（人民币）';
comment on column CKTS_LC_SHXX.sb_mdtse
  is '申报免抵退税额';
comment on column CKTS_LC_SHXX.sb_zzstse
  is '申报增值税退税额';
comment on column CKTS_LC_SHXX.sb_xfstse
  is '申报消费税退税额';
comment on column CKTS_LC_SHXX.sb_mdse
  is '申报免抵税额';
comment on column CKTS_LC_SHXX.by_mdtse
  is '不予退税免抵退税额';
comment on column CKTS_LC_SHXX.by_zzstse
  is '不予退税增值税退税额';
comment on column CKTS_LC_SHXX.by_xfstse
  is '不予退税消费税退税额';
comment on column CKTS_LC_SHXX.by_mdse
  is '不予退税免抵税额';
comment on column CKTS_LC_SHXX.zy_mdtse
  is '准予退税免抵退税额';
comment on column CKTS_LC_SHXX.zy_zzstse
  is '准予退税增值税退税额';
comment on column CKTS_LC_SHXX.zy_xfstse
  is '准予退税消费税退税额';
comment on column CKTS_LC_SHXX.zy_mdse
  is '准予退税免抵税额';
comment on column CKTS_LC_SHXX.zh_mdtse
  is '暂不办理免抵退税额';
comment on column CKTS_LC_SHXX.zh_zzstse
  is '暂不办理增值税退税额';
comment on column CKTS_LC_SHXX.zh_xfstse
  is '暂不办理消费税退税额';
comment on column CKTS_LC_SHXX.zh_mdse
  is '暂不办理免抵税额';
comment on column CKTS_LC_SHXX.snbl_mdtse
  is '截止上年办理免抵退税额';
comment on column CKTS_LC_SHXX.snbl_zzstse
  is '截止上年办理增值税退税额';
comment on column CKTS_LC_SHXX.snbl_xfstse
  is '截止上年办理消费税退税额';
comment on column CKTS_LC_SHXX.snbl_mdse
  is '截止上年办理免抵税额';
comment on column CKTS_LC_SHXX.sybl_mdtse
  is '截止上月办理免抵退税额';
comment on column CKTS_LC_SHXX.sybl_zzstse
  is '截止上月办理增值税退税额';
comment on column CKTS_LC_SHXX.sybl_xfstse
  is '截止上月办理消费税退税额';
comment on column CKTS_LC_SHXX.sybl_mdse
  is '截止上月办理免抵税额';
comment on column CKTS_LC_SHXX.xgrq
  is '修改日期NVL(T.XGRQ,T.LRRQ)-增量用';
comment on column CKTS_LC_SHXX.sjtb_bz
  is '错误继续标志';
comment on column CKTS_LC_SHXX.byhz_mdtse
  is '不予核准免抵退税额';
comment on column CKTS_LC_SHXX.byhz_zzstse
  is '不予核准增值税退税额';
comment on column CKTS_LC_SHXX.byhz_xfstse
  is '不予核准消费税退税额';
comment on column CKTS_LC_SHXX.byhz_mdse
  is '不予核准免抵税额';
comment on column CKTS_LC_SHXX.zlclcslid
  is '主流程lcslid从金三获取，用于判断中间节点流程的结束状态';
comment on column CKTS_LC_SHXX.lcswsx_dm
  is '流程税务事项代码，用于判断生产企业暂缓数据';
comment on column CKTS_LC_SHXX.lastopdate
  is '流程结束日期，默认1900-01-01';
comment on column CKTS_LC_SHXX.bybl_mdtse
  is '不予办理免抵退税额';
comment on column CKTS_LC_SHXX.bybl_zzstse
  is '不予办理增值税退税额';
comment on column CKTS_LC_SHXX.bybl_xfstse
  is '不予办理消费税退税额';
comment on column CKTS_LC_SHXX.bybl_mdse
  is '不予办理免抵税额';
create index IDX_CKTS_LC_SHXX_DQ on CKTS_LC_SHXX (DJXH, QDSJ)
  nologging;
create index IDX_CKTS_LC_SHXX_DSSS on CKTS_LC_SHXX (DJXH, SBYWB_DM, SSQ, SBPC)
  nologging;
create index IDX_CKTS_LC_SHXX_LCSLID on CKTS_LC_SHXX (LCSLID)
  nologging;
create index IDX_CKTS_LC_SHXX_LCSLID_FS on CKTS_LC_SHXX (LCSLID_FS)
  nologging;
create index IDX_CKTS_LC_SHXX_LCSLID_SB on CKTS_LC_SHXX (LCSLID_SB)
  nologging;
create index IDX_CKTS_LC_SHXX_TLQL on CKTS_LC_SHXX (TSSWJG_DM, LCJSRQ, QDSJ, LCTJJC)
  nologging;
create index IDX_CKTS_LC_SHXX_TQ on CKTS_LC_SHXX (TSSWJG_DM, QDSJ)
  nologging;
alter table CKTS_LC_SHXX
  add constraint PK_CKTS_LC_SHXX primary key (UUID);
alter index PK_CKTS_LC_SHXX nologging;

prompt
prompt Creating table CKTS_LC_SHXX_ZF
prompt ==============================
prompt
create table CKTS_LC_SHXX_ZF
(
  uuid             VARCHAR2(32) not null,
  cktmshwysfwlx_dm CHAR(1),
  tsswjg_dm        CHAR(11),
  djxh             NUMBER(20),
  ckqygllb_dm      CHAR(1),
  wzhbz            CHAR(1),
  sbywb_dm         VARCHAR2(16),
  ssq              VARCHAR2(60),
  sbpc             VARCHAR2(75),
  lcslid           CHAR(32),
  lcslid_sb        CHAR(32),
  lcslid_fs        CHAR(32),
  zfbz             CHAR(1),
  zfr_dm           CHAR(11),
  zfrq             DATE,
  qdr_dm           CHAR(11),
  qdsj             DATE,
  ffbz             CHAR(1),
  ffr_dm           CHAR(11),
  ffrq             DATE,
  sjtb_sj          TIMESTAMP(6),
  lctjjc           CHAR(2) default '00',
  lcjsrq           DATE default TO_DATE('2100-12-31','YYYY-MM-DD'),
  sb_xsemy         NUMBER(18,2),
  sb_xsermb        NUMBER(18,2),
  sb_mdtse         NUMBER(18,6),
  sb_zzstse        NUMBER(18,6),
  sb_xfstse        NUMBER(18,6),
  sb_mdse          NUMBER(18,6),
  by_mdtse         NUMBER(18,6),
  by_zzstse        NUMBER(18,6),
  by_xfstse        NUMBER(18,6),
  by_mdse          NUMBER(18,6),
  zy_mdtse         NUMBER(18,6),
  zy_zzstse        NUMBER(18,6),
  zy_xfstse        NUMBER(18,6),
  zy_mdse          NUMBER(18,6),
  zh_mdtse         NUMBER(18,6),
  zh_zzstse        NUMBER(18,6),
  zh_xfstse        NUMBER(18,6),
  zh_mdse          NUMBER(18,6),
  snbl_mdtse       NUMBER(18,6),
  snbl_zzstse      NUMBER(18,6),
  snbl_xfstse      NUMBER(18,6),
  snbl_mdse        NUMBER(18,6),
  sybl_mdtse       NUMBER(18,6),
  sybl_zzstse      NUMBER(18,6),
  sybl_xfstse      NUMBER(18,6),
  sybl_mdse        NUMBER(18,6),
  xgrq             DATE,
  sjtb_bz          CHAR(1) default '0',
  byhz_mdtse       NUMBER(18,6),
  byhz_zzstse      NUMBER(18,6),
  byhz_xfstse      NUMBER(18,6),
  byhz_mdse        NUMBER(18,6),
  zlclcslid        CHAR(32),
  lcswsx_dm        VARCHAR2(16),
  lastopdate       DATE default TO_DATE('1900-01-01','YYYY-MM-DD'),
  bybl_mdtse       NUMBER(18,6) default 0,
  bybl_zzstse      NUMBER(18,6) default 0,
  bybl_xfstse      NUMBER(18,6) default 0,
  bybl_mdse        NUMBER(18,6) default 0
)
;
comment on table CKTS_LC_SHXX_ZF
  is '流程审核分流信息表';
comment on column CKTS_LC_SHXX_ZF.uuid
  is 'UUID';
comment on column CKTS_LC_SHXX_ZF.cktmshwysfwlx_dm
  is '出口退（免）税货物应税服务类型代码 1:货物，2:服务';
comment on column CKTS_LC_SHXX_ZF.tsswjg_dm
  is '退税税务机关代码';
comment on column CKTS_LC_SHXX_ZF.djxh
  is '登记序号';
comment on column CKTS_LC_SHXX_ZF.ckqygllb_dm
  is '出口企业管理类别代码';
comment on column CKTS_LC_SHXX_ZF.wzhbz
  is '无纸化标志';
comment on column CKTS_LC_SHXX_ZF.sbywb_dm
  is '申报业务表代码（根据流程税务事项转换）';
comment on column CKTS_LC_SHXX_ZF.ssq
  is '所属期';
comment on column CKTS_LC_SHXX_ZF.sbpc
  is '申报批次';
comment on column CKTS_LC_SHXX_ZF.lcslid
  is '分流LCSLID';
comment on column CKTS_LC_SHXX_ZF.lcslid_sb
  is '申报LCSLID';
comment on column CKTS_LC_SHXX_ZF.lcslid_fs
  is '复审LCSLID';
comment on column CKTS_LC_SHXX_ZF.zfbz
  is '作废标志';
comment on column CKTS_LC_SHXX_ZF.zfr_dm
  is '作废人代码';
comment on column CKTS_LC_SHXX_ZF.zfrq
  is '作废日期';
comment on column CKTS_LC_SHXX_ZF.qdr_dm
  is '启动人代码';
comment on column CKTS_LC_SHXX_ZF.qdsj
  is '启动时间';
comment on column CKTS_LC_SHXX_ZF.ffbz
  is '发放标志';
comment on column CKTS_LC_SHXX_ZF.ffr_dm
  is '发放人代码';
comment on column CKTS_LC_SHXX_ZF.ffrq
  is '发放日期';
comment on column CKTS_LC_SHXX_ZF.sjtb_sj
  is '数据同步时间';
comment on column CKTS_LC_SHXX_ZF.lctjjc
  is '流程统计级次，默认外贸企业';
comment on column CKTS_LC_SHXX_ZF.lcjsrq
  is '流程结束日期，默认2100-12-31';
comment on column CKTS_LC_SHXX_ZF.sb_xsemy
  is '申报销售额（美元）';
comment on column CKTS_LC_SHXX_ZF.sb_xsermb
  is '申报销售额（人民币）';
comment on column CKTS_LC_SHXX_ZF.sb_mdtse
  is '申报免抵退税额';
comment on column CKTS_LC_SHXX_ZF.sb_zzstse
  is '申报增值税退税额';
comment on column CKTS_LC_SHXX_ZF.sb_xfstse
  is '申报消费税退税额';
comment on column CKTS_LC_SHXX_ZF.sb_mdse
  is '申报免抵税额';
comment on column CKTS_LC_SHXX_ZF.by_mdtse
  is '不予退税免抵退税额';
comment on column CKTS_LC_SHXX_ZF.by_zzstse
  is '不予退税增值税退税额';
comment on column CKTS_LC_SHXX_ZF.by_xfstse
  is '不予退税消费税退税额';
comment on column CKTS_LC_SHXX_ZF.by_mdse
  is '不予退税免抵税额';
comment on column CKTS_LC_SHXX_ZF.zy_mdtse
  is '准予退税免抵退税额';
comment on column CKTS_LC_SHXX_ZF.zy_zzstse
  is '准予退税增值税退税额';
comment on column CKTS_LC_SHXX_ZF.zy_xfstse
  is '准予退税消费税退税额';
comment on column CKTS_LC_SHXX_ZF.zy_mdse
  is '准予退税免抵税额';
comment on column CKTS_LC_SHXX_ZF.zh_mdtse
  is '暂不办理免抵退税额';
comment on column CKTS_LC_SHXX_ZF.zh_zzstse
  is '暂不办理增值税退税额';
comment on column CKTS_LC_SHXX_ZF.zh_xfstse
  is '暂不办理消费税退税额';
comment on column CKTS_LC_SHXX_ZF.zh_mdse
  is '暂不办理免抵税额';
comment on column CKTS_LC_SHXX_ZF.snbl_mdtse
  is '截止上年办理免抵退税额';
comment on column CKTS_LC_SHXX_ZF.snbl_zzstse
  is '截止上年办理增值税退税额';
comment on column CKTS_LC_SHXX_ZF.snbl_xfstse
  is '截止上年办理消费税退税额';
comment on column CKTS_LC_SHXX_ZF.snbl_mdse
  is '截止上年办理免抵税额';
comment on column CKTS_LC_SHXX_ZF.sybl_mdtse
  is '截止上月办理免抵退税额';
comment on column CKTS_LC_SHXX_ZF.sybl_zzstse
  is '截止上月办理增值税退税额';
comment on column CKTS_LC_SHXX_ZF.sybl_xfstse
  is '截止上月办理消费税退税额';
comment on column CKTS_LC_SHXX_ZF.sybl_mdse
  is '截止上月办理免抵税额';
comment on column CKTS_LC_SHXX_ZF.xgrq
  is '修改日期NVL(T.XGRQ,T.LRRQ)-增量用';
comment on column CKTS_LC_SHXX_ZF.sjtb_bz
  is '错误继续标志';
comment on column CKTS_LC_SHXX_ZF.byhz_mdtse
  is '不予核准免抵退税额';
comment on column CKTS_LC_SHXX_ZF.byhz_zzstse
  is '不予核准增值税退税额';
comment on column CKTS_LC_SHXX_ZF.byhz_xfstse
  is '不予核准消费税退税额';
comment on column CKTS_LC_SHXX_ZF.byhz_mdse
  is '不予核准免抵税额';
comment on column CKTS_LC_SHXX_ZF.zlclcslid
  is '主流程lcslid从金三获取，用于判断中间节点流程的结束状态';
comment on column CKTS_LC_SHXX_ZF.lcswsx_dm
  is '流程税务事项代码，用于判断生产企业暂缓数据';
comment on column CKTS_LC_SHXX_ZF.lastopdate
  is '流程结束日期，默认1900-01-01';
comment on column CKTS_LC_SHXX_ZF.bybl_mdtse
  is '不予办理免抵退税额';
comment on column CKTS_LC_SHXX_ZF.bybl_zzstse
  is '不予办理增值税退税额';
comment on column CKTS_LC_SHXX_ZF.bybl_xfstse
  is '不予办理消费税退税额';
comment on column CKTS_LC_SHXX_ZF.bybl_mdse
  is '不予办理免抵税额';
create index IDX_CKTS_LC_SHXX_ZF_DSS on CKTS_LC_SHXX_ZF (DJXH, SSQ, SBPC)
  nologging;
create index IDX_CKTS_LC_SHXX_ZF_LCSLID on CKTS_LC_SHXX_ZF (LCSLID)
  nologging;
create index IDX_CKTS_LC_SHXX_ZF_LCSLID_FS on CKTS_LC_SHXX_ZF (LCSLID_FS)
  nologging;
create index IDX_CKTS_LC_SHXX_ZF_UUID on CKTS_LC_SHXX_ZF (UUID)
  nologging;

prompt
prompt Creating table CKTS_LC_SHYDDCL
prompt ==============================
prompt
create table CKTS_LC_SHYDDCL
(
  uuid          VARCHAR2(32) not null,
  sbywb_dm      VARCHAR2(16),
  tsswjg_dm     CHAR(11),
  lcslid        CHAR(32),
  djxh          NUMBER(20),
  ssq           VARCHAR2(60),
  sbpc          VARCHAR2(75),
  sbxh          VARCHAR2(50),
  glh           VARCHAR2(30),
  mdtse         NUMBER(18,6),
  ydnr          VARCHAR2(3000),
  zhshclyjlx_dm CHAR(1),
  lrr_dm        CHAR(11),
  lrrq          DATE,
  xgrq          DATE default sysdate
)
;
comment on table CKTS_LC_SHYDDCL
  is '审核疑点业务处理过程表';
comment on column CKTS_LC_SHYDDCL.uuid
  is 'UUID';
comment on column CKTS_LC_SHYDDCL.sbywb_dm
  is '申报业务表代码';
comment on column CKTS_LC_SHYDDCL.tsswjg_dm
  is '退税税务机关代码';
comment on column CKTS_LC_SHYDDCL.lcslid
  is 'LCSLID';
comment on column CKTS_LC_SHYDDCL.djxh
  is '登记序号';
comment on column CKTS_LC_SHYDDCL.ssq
  is '所属期';
comment on column CKTS_LC_SHYDDCL.sbpc
  is '申报批次';
comment on column CKTS_LC_SHYDDCL.sbxh
  is '申报序号';
comment on column CKTS_LC_SHYDDCL.glh
  is '关联号';
comment on column CKTS_LC_SHYDDCL.mdtse
  is '免（抵）退税额';
comment on column CKTS_LC_SHYDDCL.ydnr
  is '疑点内容';
comment on column CKTS_LC_SHYDDCL.zhshclyjlx_dm
  is '综合审核处理意见类型代码';
alter table CKTS_LC_SHYDDCL
  add constraint PK_CKTS_LC_SHYDDCL primary key (UUID);
alter index PK_CKTS_LC_SHYDDCL nologging;

prompt
prompt Creating table CKTS_LC_SHYDDCL_SHXT
prompt ===================================
prompt
create table CKTS_LC_SHYDDCL_SHXT
(
  uuid          VARCHAR2(32) not null,
  sbywb_dm      VARCHAR2(16),
  tsswjg_dm     CHAR(11),
  lcslid        CHAR(32),
  djxh          NUMBER(20),
  ssq           VARCHAR2(60),
  sbpc          VARCHAR2(75),
  sbxh          VARCHAR2(50),
  glh           VARCHAR2(30),
  mdtse         NUMBER(18,6),
  ydnr          VARCHAR2(3000),
  zhshclyjlx_dm CHAR(1),
  lrr_dm        CHAR(11),
  lrrq          DATE,
  xgrq          DATE default sysdate
)
;
comment on table CKTS_LC_SHYDDCL_SHXT
  is '审核疑点业务处理过程表';
comment on column CKTS_LC_SHYDDCL_SHXT.uuid
  is 'UUID';
comment on column CKTS_LC_SHYDDCL_SHXT.sbywb_dm
  is '申报业务表代码';
comment on column CKTS_LC_SHYDDCL_SHXT.tsswjg_dm
  is '退税税务机关代码';
comment on column CKTS_LC_SHYDDCL_SHXT.lcslid
  is 'LCSLID';
comment on column CKTS_LC_SHYDDCL_SHXT.djxh
  is '登记序号';
comment on column CKTS_LC_SHYDDCL_SHXT.ssq
  is '所属期';
comment on column CKTS_LC_SHYDDCL_SHXT.sbpc
  is '申报批次';
comment on column CKTS_LC_SHYDDCL_SHXT.sbxh
  is '申报序号';
comment on column CKTS_LC_SHYDDCL_SHXT.glh
  is '关联号';
comment on column CKTS_LC_SHYDDCL_SHXT.mdtse
  is '免（抵）退税额';
comment on column CKTS_LC_SHYDDCL_SHXT.ydnr
  is '疑点内容';
comment on column CKTS_LC_SHYDDCL_SHXT.zhshclyjlx_dm
  is '综合审核处理意见类型代码';
alter table CKTS_LC_SHYDDCL_SHXT
  add constraint PK_CKTS_LC_SHYDDCL_SHXT primary key (UUID);
alter index PK_CKTS_LC_SHYDDCL_SHXT nologging;

prompt
prompt Creating table CKTS_LC_YWHZXX
prompt =============================
prompt
create table CKTS_LC_YWHZXX
(
  ywhzbuuid        VARCHAR2(32) not null,
  tsswjg_dm        CHAR(11),
  djxh             NUMBER(20),
  ckqygllb_dm      CHAR(1),
  wzhbz            CHAR(1),
  sbywb_dm         VARCHAR2(16),
  ssq              VARCHAR2(60),
  sbpc             VARCHAR2(75),
  lcslid_fs        CHAR(32),
  cktmshwysfwlx_dm CHAR(1),
  fsr_dm           CHAR(11),
  fsrq             DATE,
  fs_mdtse         NUMBER(18,6),
  fs_zzstse        NUMBER(18,6),
  fs_xfstse        NUMBER(18,6),
  fs_mdse          NUMBER(18,6),
  ywhzwcbz         CHAR(1),
  ywhzr_dm         CHAR(11),
  ywhzrq           DATE,
  sehzwcbz         CHAR(1),
  zk_zzstse        NUMBER(18,6),
  zk_xfstse        NUMBER(18,6),
  wtdbtsscqynsrsbh VARCHAR2(20),
  sjtb_sj          TIMESTAMP(6),
  xgrq             DATE,
  sjtb_bz          CHAR(1) default '0',
  lctjjc           CHAR(2) default '00',
  bz               VARCHAR2(100),
  tbyy_dm          CHAR(3)
)
;
comment on table CKTS_LC_YWHZXX
  is '业务核准信息表';
comment on column CKTS_LC_YWHZXX.ywhzbuuid
  is '业务核准表UUID';
comment on column CKTS_LC_YWHZXX.tsswjg_dm
  is '退税税务机关代码';
comment on column CKTS_LC_YWHZXX.djxh
  is '登记序号';
comment on column CKTS_LC_YWHZXX.ckqygllb_dm
  is '出口企业管理类别代码';
comment on column CKTS_LC_YWHZXX.wzhbz
  is '无纸化标志';
comment on column CKTS_LC_YWHZXX.sbywb_dm
  is '申报业务表代码（根据流程税务事项转换）';
comment on column CKTS_LC_YWHZXX.ssq
  is '所属期';
comment on column CKTS_LC_YWHZXX.sbpc
  is '申报批次';
comment on column CKTS_LC_YWHZXX.lcslid_fs
  is '复审LCSLID';
comment on column CKTS_LC_YWHZXX.cktmshwysfwlx_dm
  is '出口退（免）税货物应税服务类型代码';
comment on column CKTS_LC_YWHZXX.fsr_dm
  is '复审人代码（LRR_DM）';
comment on column CKTS_LC_YWHZXX.fsrq
  is '复审日期（LRRQ）';
comment on column CKTS_LC_YWHZXX.fs_mdtse
  is '复审免抵退税额';
comment on column CKTS_LC_YWHZXX.fs_zzstse
  is '复审增值税退税额';
comment on column CKTS_LC_YWHZXX.fs_xfstse
  is '复审消费税退税额';
comment on column CKTS_LC_YWHZXX.fs_mdse
  is '复审免抵税额';
comment on column CKTS_LC_YWHZXX.ywhzwcbz
  is '业务核准完成标志';
comment on column CKTS_LC_YWHZXX.ywhzr_dm
  is '业务核准人代码';
comment on column CKTS_LC_YWHZXX.ywhzrq
  is '业务核准时间';
comment on column CKTS_LC_YWHZXX.sehzwcbz
  is '税额核准完成标志';
comment on column CKTS_LC_YWHZXX.zk_zzstse
  is '暂扣增值税退税额';
comment on column CKTS_LC_YWHZXX.zk_xfstse
  is '暂扣消费税退税额';
comment on column CKTS_LC_YWHZXX.wtdbtsscqynsrsbh
  is '委托代办退税生产企业纳税人识别号';
comment on column CKTS_LC_YWHZXX.sjtb_sj
  is '数据同步时间';
comment on column CKTS_LC_YWHZXX.xgrq
  is '修改日期NVL(T.XGRQ,T.LRRQ)-增量用';
comment on column CKTS_LC_YWHZXX.sjtb_bz
  is '错误继续标志';
comment on column CKTS_LC_YWHZXX.lctjjc
  is '流程统计级次，默认外贸企业';
comment on column CKTS_LC_YWHZXX.bz
  is '备注，用于标示没有审核信息的核准信息';
comment on column CKTS_LC_YWHZXX.tbyy_dm
  is '退补原因代码';
create index IDX_CKTS_LC_YWHZXX_DSSS on CKTS_LC_YWHZXX (DJXH, SBYWB_DM, SSQ, SBPC)
  nologging;
create index IDX_CKTS_LC_YWHZXX_LCSLIDFS on CKTS_LC_YWHZXX (LCSLID_FS)
  nologging;
create index IDX_CKTS_LC_YWHZXX_TF on CKTS_LC_YWHZXX (TSSWJG_DM, FSRQ)
  nologging;
alter table CKTS_LC_YWHZXX
  add constraint PK_CKTS_LC_YWHZXX primary key (YWHZBUUID);
alter index PK_CKTS_LC_YWHZXX nologging;

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
prompt Creating table CKTS_OTHER_SXPSAJ
prompt ================================
prompt
create table CKTS_OTHER_SXPSAJ
(
  uuid         VARCHAR2(32) not null,
  swjgdm       VARCHAR2(11),
  cpcode       VARCHAR2(32),
  nsrdjno      VARCHAR2(32),
  shxyno       VARCHAR2(20),
  qyname       VARCHAR2(200),
  ajly_name    VARCHAR2(100),
  ajly_summary VARCHAR2(4000),
  ajly_reason  VARCHAR2(4000),
  sasp_code    VARCHAR2(20),
  sasp_name    VARCHAR2(254),
  usd_amt      NUMBER(24,4),
  mdts_amt     NUMBER(24,4),
  ts_amt       NUMBER(24,4),
  md_amt       NUMBER(24,4),
  ysjc_swcode  VARCHAR2(11),
  ysjc_swname  VARCHAR2(100),
  ysjc_date    DATE,
  ysjc_no      VARCHAR2(20),
  ysjc_user    VARCHAR2(30),
  jcjs_swcode  VARCHAR2(11),
  jcjs_swname  VARCHAR2(100),
  jcjs_date    DATE,
  jcjs_user    VARCHAR2(30),
  jcjs_flag    VARCHAR2(2),
  jcla_flag    VARCHAR2(2),
  jcla_date    DATE,
  jcja_flag    VARCHAR2(2),
  jcja_date    DATE,
  remark       VARCHAR2(1000)
)
;
comment on table CKTS_OTHER_SXPSAJ
  is '管理系统_报表_审核系统_涉嫌骗税信息';
comment on column CKTS_OTHER_SXPSAJ.swjgdm
  is '税务机关代码';
comment on column CKTS_OTHER_SXPSAJ.cpcode
  is '审核系统企业标识';
comment on column CKTS_OTHER_SXPSAJ.nsrdjno
  is '纳税人识别号';
comment on column CKTS_OTHER_SXPSAJ.shxyno
  is '社会信用代码';
comment on column CKTS_OTHER_SXPSAJ.qyname
  is '企业名称';
comment on column CKTS_OTHER_SXPSAJ.ajly_name
  is '案源';
comment on column CKTS_OTHER_SXPSAJ.ajly_summary
  is '案源信息摘要';
comment on column CKTS_OTHER_SXPSAJ.ajly_reason
  is '主要案情';
comment on column CKTS_OTHER_SXPSAJ.sasp_code
  is '涉案出口商品编码';
comment on column CKTS_OTHER_SXPSAJ.sasp_name
  is '涉案出口商品名称';
comment on column CKTS_OTHER_SXPSAJ.usd_amt
  is '涉案金额（万美元）';
comment on column CKTS_OTHER_SXPSAJ.mdts_amt
  is '出口退（免）税额（万元）';
comment on column CKTS_OTHER_SXPSAJ.ts_amt
  is '退税额（万元）';
comment on column CKTS_OTHER_SXPSAJ.md_amt
  is '免抵额（万元）';
comment on column CKTS_OTHER_SXPSAJ.ysjc_swcode
  is '移送单位代码';
comment on column CKTS_OTHER_SXPSAJ.ysjc_swname
  is '移送单位名称';
comment on column CKTS_OTHER_SXPSAJ.ysjc_date
  is '移送时间';
comment on column CKTS_OTHER_SXPSAJ.ysjc_no
  is '移送书文号';
comment on column CKTS_OTHER_SXPSAJ.ysjc_user
  is '移送人';
comment on column CKTS_OTHER_SXPSAJ.jcjs_swcode
  is '接收单位代码';
comment on column CKTS_OTHER_SXPSAJ.jcjs_swname
  is '接收单位名称';
comment on column CKTS_OTHER_SXPSAJ.jcjs_date
  is '接收时间';
comment on column CKTS_OTHER_SXPSAJ.jcjs_user
  is '接收人';
comment on column CKTS_OTHER_SXPSAJ.jcjs_flag
  is '不予接收标识';
comment on column CKTS_OTHER_SXPSAJ.jcla_flag
  is '稽查立案标识';
comment on column CKTS_OTHER_SXPSAJ.jcla_date
  is '稽查立案时间';
comment on column CKTS_OTHER_SXPSAJ.jcja_flag
  is '稽查结案标识';
comment on column CKTS_OTHER_SXPSAJ.jcja_date
  is '稽查结案时间';
comment on column CKTS_OTHER_SXPSAJ.remark
  is '备注';
alter table CKTS_OTHER_SXPSAJ
  add constraint PK_CKTS_OTHER_SXPSAJ primary key (UUID);

prompt
prompt Creating table CKTS_SB_FZC_SBMX
prompt ===============================
prompt
create table CKTS_SB_FZC_SBMX
(
  uuid          VARCHAR2(32) not null,
  lcslid        CHAR(32),
  tsswjg_dm     CHAR(11),
  djxh          NUMBER(20),
  ssq           VARCHAR2(60),
  sbpc          VARCHAR2(75) default '001',
  sbxh          VARCHAR2(50),
  ckbgdh        VARCHAR2(21),
  dlckhwzmhm    VARCHAR2(20),
  cksl          NUMBER(16,4),
  cktmspzlx_dm  CHAR(2),
  xfspzh        VARCHAR2(40),
  kprq          DATE,
  cksp_dm       VARCHAR2(20),
  sbhgspmc      VARCHAR2(500),
  hgjldwmc      VARCHAR2(75),
  sl            NUMBER(16,4),
  zssl          NUMBER(16,6),
  jsje          NUMBER(18,2),
  se            NUMBER(18,6),
  xfstse        NUMBER(18,6),
  cktmsywlxdmjh VARCHAR2(30),
  cktmsywlxmcjh VARCHAR2(75),
  chbz          CHAR(1) default 'N',
  bytsbz        CHAR(1),
  byblbz        CHAR(1),
  sjly          CHAR(1),
  sjtb_sj       TIMESTAMP(6),
  sbrq          DATE,
  xgrq          DATE,
  sjtb_bz       CHAR(1) default '0',
  zbblbz        CHAR(1) default 'N'
)
;
comment on table CKTS_SB_FZC_SBMX
  is '出口非自产货物退消费税申报表';
comment on column CKTS_SB_FZC_SBMX.uuid
  is 'UUID';
comment on column CKTS_SB_FZC_SBMX.lcslid
  is '分流LCSLID';
comment on column CKTS_SB_FZC_SBMX.tsswjg_dm
  is '退税税务机关代码';
comment on column CKTS_SB_FZC_SBMX.djxh
  is '登记序号';
comment on column CKTS_SB_FZC_SBMX.ssq
  is '所属期';
comment on column CKTS_SB_FZC_SBMX.sbpc
  is '申报批次';
comment on column CKTS_SB_FZC_SBMX.sbxh
  is '申报序号';
comment on column CKTS_SB_FZC_SBMX.ckbgdh
  is '出口报关单号';
comment on column CKTS_SB_FZC_SBMX.dlckhwzmhm
  is '代理出口货物证明号码';
comment on column CKTS_SB_FZC_SBMX.cksl
  is '出口数量';
comment on column CKTS_SB_FZC_SBMX.cktmspzlx_dm
  is '出口退(免)税凭证类型代码';
comment on column CKTS_SB_FZC_SBMX.xfspzh
  is '消费税凭证号';
comment on column CKTS_SB_FZC_SBMX.kprq
  is '开票日期';
comment on column CKTS_SB_FZC_SBMX.cksp_dm
  is '出口商品代码';
comment on column CKTS_SB_FZC_SBMX.sbhgspmc
  is '申报海关商品名称||申报海关商品名称';
comment on column CKTS_SB_FZC_SBMX.hgjldwmc
  is '海关计量单位名称';
comment on column CKTS_SB_FZC_SBMX.sl
  is '数量';
comment on column CKTS_SB_FZC_SBMX.zssl
  is '征税税率';
comment on column CKTS_SB_FZC_SBMX.jsje
  is '计税金额';
comment on column CKTS_SB_FZC_SBMX.se
  is '税额';
comment on column CKTS_SB_FZC_SBMX.xfstse
  is '消费税退税额';
comment on column CKTS_SB_FZC_SBMX.cktmsywlxdmjh
  is '出口退（免）税业务类型代码集合';
comment on column CKTS_SB_FZC_SBMX.cktmsywlxmcjh
  is '出口退（免）税业务类型名称集合';
comment on column CKTS_SB_FZC_SBMX.chbz
  is '撤回标志';
comment on column CKTS_SB_FZC_SBMX.bytsbz
  is '不予退税标志';
comment on column CKTS_SB_FZC_SBMX.byblbz
  is '不予办理标志';
comment on column CKTS_SB_FZC_SBMX.sjly
  is '1-GC表  2-JG表';
comment on column CKTS_SB_FZC_SBMX.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_FZC_SBMX.sbrq
  is '申报日期';
comment on column CKTS_SB_FZC_SBMX.xgrq
  is '修改日期NVL(T.XGRQ,T.LRRQ)-增量用';
comment on column CKTS_SB_FZC_SBMX.sjtb_bz
  is '错误继续标志';
comment on column CKTS_SB_FZC_SBMX.zbblbz
  is '暂不办理标志';
create index IDX_CKTS_SB_FZC_SBMX_DC on CKTS_SB_FZC_SBMX (DJXH, CKBGDH)
  nologging;
create index IDX_CKTS_SB_FZC_SBMX_DSSS on CKTS_SB_FZC_SBMX (DJXH, SSQ, SBPC, SBXH)
  nologging;
create index IDX_CKTS_SB_FZC_SBMX_LCSLID on CKTS_SB_FZC_SBMX (LCSLID)
  nologging;
alter table CKTS_SB_FZC_SBMX
  add constraint PK_CKTS_SB_FZC_SBMX primary key (UUID);
alter index PK_CKTS_SB_FZC_SBMX nologging;

prompt
prompt Creating table CKTS_SB_GJ_SBMX
prompt ==============================
prompt
create table CKTS_SB_GJ_SBMX
(
  uuid          VARCHAR2(32) not null,
  lcslid        CHAR(32),
  tsswjg_dm     CHAR(11),
  djxh          NUMBER(20),
  ssq           VARCHAR2(60),
  sbpc          VARCHAR2(75) default '001',
  sbxh          VARCHAR2(50),
  gjzyhwmc      VARCHAR2(500),
  jhpzzl_dm     CHAR(1),
  jhpzh         VARCHAR2(75),
  kprq          DATE,
  ghfnsrsbh_1   VARCHAR2(20),
  sl            NUMBER(16,4),
  hgjldwmc      VARCHAR2(75),
  dj            NUMBER(18,2),
  jsje          NUMBER(18,2),
  zssl          NUMBER(16,6),
  se            NUMBER(18,6),
  tse           NUMBER(18,6),
  fkpzhm        VARCHAR2(40),
  cktmsywlxdmjh VARCHAR2(30),
  cktmsywlxmcjh VARCHAR2(75),
  chbz          CHAR(1) default 'N',
  bytsbz        CHAR(1),
  byblbz        CHAR(1),
  sjly          CHAR(1),
  sjtb_sj       TIMESTAMP(6),
  sbrq          DATE,
  xgrq          DATE,
  sjtb_bz       CHAR(1) default '0',
  zbblbz        CHAR(1) default 'N'
)
;
comment on table CKTS_SB_GJ_SBMX
  is '购进自用货物退税申报结果表';
comment on column CKTS_SB_GJ_SBMX.uuid
  is 'UUID';
comment on column CKTS_SB_GJ_SBMX.lcslid
  is '分流LCSLID';
comment on column CKTS_SB_GJ_SBMX.tsswjg_dm
  is '退税税务机关代码';
comment on column CKTS_SB_GJ_SBMX.djxh
  is '登记序号';
comment on column CKTS_SB_GJ_SBMX.ssq
  is '所属期';
comment on column CKTS_SB_GJ_SBMX.sbpc
  is '申报批次（默认001）';
comment on column CKTS_SB_GJ_SBMX.sbxh
  is '申报序号';
comment on column CKTS_SB_GJ_SBMX.gjzyhwmc
  is '购进自用货物名称';
comment on column CKTS_SB_GJ_SBMX.jhpzzl_dm
  is '进货凭证种类代码';
comment on column CKTS_SB_GJ_SBMX.jhpzh
  is '进货凭证号';
comment on column CKTS_SB_GJ_SBMX.kprq
  is '开票日期';
comment on column CKTS_SB_GJ_SBMX.ghfnsrsbh_1
  is '供货方纳税人识别号';
comment on column CKTS_SB_GJ_SBMX.sl
  is '数量';
comment on column CKTS_SB_GJ_SBMX.hgjldwmc
  is '海关计量单位名称';
comment on column CKTS_SB_GJ_SBMX.dj
  is '单价';
comment on column CKTS_SB_GJ_SBMX.jsje
  is '计税金额';
comment on column CKTS_SB_GJ_SBMX.zssl
  is '征税税率';
comment on column CKTS_SB_GJ_SBMX.se
  is '税额';
comment on column CKTS_SB_GJ_SBMX.tse
  is '退税额';
comment on column CKTS_SB_GJ_SBMX.fkpzhm
  is '付款凭证号码';
comment on column CKTS_SB_GJ_SBMX.cktmsywlxdmjh
  is '出口退（免）税业务类型代码集合';
comment on column CKTS_SB_GJ_SBMX.cktmsywlxmcjh
  is '出口退（免）税业务类型名称集合';
comment on column CKTS_SB_GJ_SBMX.chbz
  is '撤回标志';
comment on column CKTS_SB_GJ_SBMX.bytsbz
  is '不予退税标志';
comment on column CKTS_SB_GJ_SBMX.byblbz
  is '不予办理标志';
comment on column CKTS_SB_GJ_SBMX.sjly
  is '1-GC表  2-JG表';
comment on column CKTS_SB_GJ_SBMX.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_GJ_SBMX.sbrq
  is '申报日期';
comment on column CKTS_SB_GJ_SBMX.xgrq
  is '修改日期NVL(T.XGRQ,T.LRRQ)-增量用';
comment on column CKTS_SB_GJ_SBMX.sjtb_bz
  is '错误继续标志';
comment on column CKTS_SB_GJ_SBMX.zbblbz
  is '暂不办理标志';
create index IDX_CKTS_SB_GJ_SBMX_DSSS on CKTS_SB_GJ_SBMX (DJXH, SSQ, SBPC, SBXH)
  nologging;
create index IDX_CKTS_SB_GJ_SBMX_LCSLID on CKTS_SB_GJ_SBMX (LCSLID)
  nologging;
alter table CKTS_SB_GJ_SBMX
  add constraint PK_CKTS_SB_GJ_SBMX primary key (UUID);
alter index PK_CKTS_SB_GJ_SBMX nologging;

prompt
prompt Creating table CKTS_SB_MDT_CKMX
prompt ===============================
prompt
create table CKTS_SB_MDT_CKMX
(
  uuid             VARCHAR2(32) not null,
  lcslid           CHAR(32),
  tsswjg_dm        CHAR(11),
  djxh             NUMBER(20),
  ssq              VARCHAR2(60),
  sbpc             VARCHAR2(75) default '001',
  sbxh             VARCHAR2(50),
  ckfph            VARCHAR2(30),
  ckbgdh           VARCHAR2(21),
  dlckhwzmhm       VARCHAR2(20),
  ckrq_1           DATE,
  cksp_dm          VARCHAR2(20),
  sbhgspmc         VARCHAR2(500),
  hgjldwmc         VARCHAR2(75),
  cksl             NUMBER(16,4),
  mylaj            NUMBER(18,2),
  rmblaj           NUMBER(18,2),
  zssl             NUMBER(16,6),
  tsl              NUMBER(16,6),
  jljgszch         VARCHAR2(20),
  tzhjhfpl         NUMBER(10,6),
  jljgbsjkljzcjsjg NUMBER(18,2),
  gngjmsycljg      NUMBER(18,2),
  mdtsbdmzhdkse    NUMBER(18,6),
  mdtse            NUMBER(18,6),
  cktmsywlxdmjh    VARCHAR2(30),
  cktmsywlxmcjh    VARCHAR2(75),
  chbz             CHAR(1) default 'N',
  zhbz_1           CHAR(1) default 'N',
  bytsbz           CHAR(1) default 'N',
  bytsny           CHAR(6),
  byblbz           CHAR(1) default 'N',
  byblny           VARCHAR2(6),
  zbblbz           CHAR(1) default 'N',
  zbblny           VARCHAR2(6),
  zzjczbblzyny     VARCHAR2(6),
  mdtsny           CHAR(6),
  lcslid_sb        CHAR(32) default ' ',
  lcslid_fs        CHAR(32) default ' ',
  tdcode           VARCHAR2(4),
  hgcode           VARCHAR2(4),
  hzdwdqdm         VARCHAR2(5),
  sbdwdm           VARCHAR2(20),
  gbcode           VARCHAR2(3),
  zzmdg            VARCHAR2(3),
  zyg              VARCHAR2(4),
  sjly             CHAR(1),
  sjtb_sj          TIMESTAMP(6),
  sbrq             DATE,
  xgrq             DATE,
  sjtb_bz          CHAR(1) default '0',
  fsrq             DATE
)
partition by range (TSSWJG_DM)
(
  partition P_13300000000 values less than ('13300000000')
    tablespace TL_TSSH,
  partition P_13301000000 values less than ('13301000000')
    tablespace TL_TSSH,
  partition P_13303000000 values less than ('13303000000')
    tablespace TL_TSSH,
  partition P_13304000000 values less than ('13304000000')
    tablespace TL_TSSH,
  partition P_13305000000 values less than ('13305000000')
    tablespace TL_TSSH,
  partition P_13306000000 values less than ('13306000000')
    tablespace TL_TSSH,
  partition P_13307000000 values less than ('13307000000')
    tablespace TL_TSSH,
  partition P_13308000000 values less than ('13308000000')
    tablespace TL_TSSH,
  partition P_13309000000 values less than ('13309000000')
    tablespace TL_TSSH,
  partition P_13310000000 values less than ('13310000000')
    tablespace TL_TSSH,
  partition P_13311000000 values less than ('13311000000')
    tablespace TL_TSSH,
  partition P_MAXVALUE values less than (MAXVALUE)
    tablespace TL_TSSH
);
comment on table CKTS_SB_MDT_CKMX
  is '免抵退出口货物明细表';
comment on column CKTS_SB_MDT_CKMX.uuid
  is 'UUID';
comment on column CKTS_SB_MDT_CKMX.lcslid
  is '分流LCSLID';
comment on column CKTS_SB_MDT_CKMX.tsswjg_dm
  is '退税税务机关代码';
comment on column CKTS_SB_MDT_CKMX.djxh
  is '登记序号';
comment on column CKTS_SB_MDT_CKMX.ssq
  is '所属期';
comment on column CKTS_SB_MDT_CKMX.sbpc
  is '申报批次（默认001）';
comment on column CKTS_SB_MDT_CKMX.sbxh
  is '申报序号';
comment on column CKTS_SB_MDT_CKMX.ckfph
  is '出口发票号码';
comment on column CKTS_SB_MDT_CKMX.ckbgdh
  is '出口报关单号';
comment on column CKTS_SB_MDT_CKMX.dlckhwzmhm
  is '代理出口货物证明号码';
comment on column CKTS_SB_MDT_CKMX.ckrq_1
  is '出口日期';
comment on column CKTS_SB_MDT_CKMX.cksp_dm
  is '出口商品代码';
comment on column CKTS_SB_MDT_CKMX.sbhgspmc
  is '申报海关商品名称';
comment on column CKTS_SB_MDT_CKMX.hgjldwmc
  is '海关计量单位名称';
comment on column CKTS_SB_MDT_CKMX.cksl
  is '出口数量';
comment on column CKTS_SB_MDT_CKMX.mylaj
  is '美元离岸价';
comment on column CKTS_SB_MDT_CKMX.rmblaj
  is '人民币离岸价';
comment on column CKTS_SB_MDT_CKMX.zssl
  is '征税税率';
comment on column CKTS_SB_MDT_CKMX.tsl
  is '退税率';
comment on column CKTS_SB_MDT_CKMX.jljgszch
  is '进料加工手账册号';
comment on column CKTS_SB_MDT_CKMX.tzhjhfpl
  is '进料加工计划分配率';
comment on column CKTS_SB_MDT_CKMX.jljgbsjkljzcjsjg
  is '进料加工保税料件计税价格';
comment on column CKTS_SB_MDT_CKMX.gngjmsycljg
  is '国内免税原材料计税价格';
comment on column CKTS_SB_MDT_CKMX.mdtsbdmzhdkse
  is '免抵退申报不得免征和抵扣税额';
comment on column CKTS_SB_MDT_CKMX.mdtse
  is '免抵退税额';
comment on column CKTS_SB_MDT_CKMX.cktmsywlxdmjh
  is '业务代码';
comment on column CKTS_SB_MDT_CKMX.cktmsywlxmcjh
  is '业务类型';
comment on column CKTS_SB_MDT_CKMX.chbz
  is '撤回标志';
comment on column CKTS_SB_MDT_CKMX.zhbz_1
  is '暂缓标志';
comment on column CKTS_SB_MDT_CKMX.bytsbz
  is '不予退税标志';
comment on column CKTS_SB_MDT_CKMX.bytsny
  is '不予退税年月';
comment on column CKTS_SB_MDT_CKMX.byblbz
  is '不予办理标志';
comment on column CKTS_SB_MDT_CKMX.byblny
  is '不予办理年月';
comment on column CKTS_SB_MDT_CKMX.zbblbz
  is '暂不办理标志';
comment on column CKTS_SB_MDT_CKMX.zbblny
  is '暂不办理年月';
comment on column CKTS_SB_MDT_CKMX.zzjczbblzyny
  is '最终解除暂不办理年月';
comment on column CKTS_SB_MDT_CKMX.mdtsny
  is '免抵退税年月';
comment on column CKTS_SB_MDT_CKMX.lcslid_sb
  is '申报LCSLID';
comment on column CKTS_SB_MDT_CKMX.lcslid_fs
  is '复审LCSLID';
comment on column CKTS_SB_MDT_CKMX.tdcode
  is '海关监管方式（关联报关单获取）';
comment on column CKTS_SB_MDT_CKMX.hgcode
  is '申报口岸（关联报关单获取）';
comment on column CKTS_SB_MDT_CKMX.hzdwdqdm
  is '货主单位地区代码（关联报关单获取）';
comment on column CKTS_SB_MDT_CKMX.sbdwdm
  is '申报单位代码（关联报关单获取）';
comment on column CKTS_SB_MDT_CKMX.gbcode
  is '国别代码（关联报关单获取）';
comment on column CKTS_SB_MDT_CKMX.zzmdg
  is '最终目的国（关联报关单获取）';
comment on column CKTS_SB_MDT_CKMX.zyg
  is '指运港（关联报关单获取）';
comment on column CKTS_SB_MDT_CKMX.sjly
  is '1-GC表  2-JG表';
comment on column CKTS_SB_MDT_CKMX.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_MDT_CKMX.sbrq
  is '申报日期';
comment on column CKTS_SB_MDT_CKMX.xgrq
  is '修改日期NVL(T.XGRQ,T.LRRQ)-增量用';
comment on column CKTS_SB_MDT_CKMX.sjtb_bz
  is '错误继续标志';
comment on column CKTS_SB_MDT_CKMX.fsrq
  is '复审日期';
create index IDX_CKTS_SB_MDT_CKMX_DC on CKTS_SB_MDT_CKMX (DJXH, CKBGDH)
  nologging;
create index IDX_CKTS_SB_MDT_CKMX_DSSS on CKTS_SB_MDT_CKMX (DJXH, SSQ, SBPC, SBXH)
  nologging;
create index IDX_CKTS_SB_MDT_CKMX_LCSLID on CKTS_SB_MDT_CKMX (LCSLID)
  nologging;
create index IDX_CKTS_SB_MDT_CKMX_LCSLID_FS on CKTS_SB_MDT_CKMX (LCSLID_FS)
  nologging;
create index IDX_CKTS_SB_MDT_CKMX_LCSLID_SB on CKTS_SB_MDT_CKMX (LCSLID_SB)
  nologging;
create index IDX_CKTS_SB_MDT_CKMX_SC on CKTS_SB_MDT_CKMX (SBRQ, CKSP_DM)
  nologging;
create index IDX_CKTS_SB_MDT_CKMX_SJ on CKTS_SB_MDT_CKMX (SJTB_SJ)
  nologging;
create index IDX_CKTS_SB_MDT_CKMX_STS on CKTS_SB_MDT_CKMX (SJLY, TDCODE, SJTB_SJ)
  nologging;
create index IDX_CKTS_SB_MDT_CKMX_TC on CKTS_SB_MDT_CKMX (TSSWJG_DM, CKRQ_1)
  nologging;
create index IDX_CKTS_SB_MDT_CKMX_TF on CKTS_SB_MDT_CKMX (TSSWJG_DM, FSRQ)
  nologging;
create index IDX_CKTS_SB_MDT_CKMX_TST on CKTS_SB_MDT_CKMX (TSSWJG_DM, SBRQ)
  nologging;
alter table CKTS_SB_MDT_CKMX
  add constraint PK_CKTS_SB_MDT_CKMX primary key (UUID);
alter index PK_CKTS_SB_MDT_CKMX nologging;

prompt
prompt Creating table CKTS_SB_MDT_GJYS
prompt ===============================
prompt
create table CKTS_SB_MDT_GJYS
(
  uuid          VARCHAR2(32) not null,
  lcslid        CHAR(32),
  tsswjg_dm     CHAR(11),
  djxh          NUMBER(20),
  ssq           VARCHAR2(60),
  sbpc          VARCHAR2(75) default '001',
  sbxh          VARCHAR2(50),
  ckfph         VARCHAR2(30),
  hth           VARCHAR2(60),
  ckrq_1        DATE,
  ysfw_dm       VARCHAR2(20),
  ysfwmc        VARCHAR2(500),
  ysfwyyemy     NUMBER(18,2),
  ysfwyyermb    NUMBER(18,2),
  zssl          NUMBER(16,6),
  tsl           NUMBER(16,6),
  mdtsbdmzhdkse NUMBER(18,6),
  mdtse         NUMBER(18,6),
  chbz          CHAR(1) default 'N',
  zhbz_1        CHAR(1) default 'N',
  bytsbz        CHAR(1) default 'N',
  bytsny        CHAR(6),
  byblbz        CHAR(1) default 'N',
  byblny        VARCHAR2(6),
  zbblbz        CHAR(1) default 'N',
  zbblny        VARCHAR2(6),
  zzjczbblzyny  VARCHAR2(6),
  mdtsny        CHAR(6),
  lcslid_sb     CHAR(32) default ' ',
  lcslid_fs     CHAR(32) default ' ',
  sjly          CHAR(1),
  sjtb_sj       TIMESTAMP(6),
  sbrq          DATE,
  xgrq          DATE,
  sjtb_bz       CHAR(1) default '0'
)
;
comment on table CKTS_SB_MDT_GJYS
  is '免抵退国际运输明细表';
comment on column CKTS_SB_MDT_GJYS.uuid
  is 'UUID';
comment on column CKTS_SB_MDT_GJYS.lcslid
  is '分流LCSLID';
comment on column CKTS_SB_MDT_GJYS.tsswjg_dm
  is '退税税务机关代码';
comment on column CKTS_SB_MDT_GJYS.djxh
  is '登记序号';
comment on column CKTS_SB_MDT_GJYS.ssq
  is '所属期';
comment on column CKTS_SB_MDT_GJYS.sbpc
  is '申报批次（默认001）';
comment on column CKTS_SB_MDT_GJYS.sbxh
  is '申报序号';
comment on column CKTS_SB_MDT_GJYS.ckfph
  is '出口发票号码';
comment on column CKTS_SB_MDT_GJYS.hth
  is '合同号';
comment on column CKTS_SB_MDT_GJYS.ckrq_1
  is '出口日期';
comment on column CKTS_SB_MDT_GJYS.ysfw_dm
  is '应税服务代码';
comment on column CKTS_SB_MDT_GJYS.ysfwmc
  is '应税服务名称';
comment on column CKTS_SB_MDT_GJYS.ysfwyyemy
  is '应税服务营业额（美元）';
comment on column CKTS_SB_MDT_GJYS.ysfwyyermb
  is '应税服务营业额（人民币）';
comment on column CKTS_SB_MDT_GJYS.zssl
  is '征税税率';
comment on column CKTS_SB_MDT_GJYS.tsl
  is '退税率';
comment on column CKTS_SB_MDT_GJYS.mdtsbdmzhdkse
  is '免抵退申报不得免征和抵扣税额';
comment on column CKTS_SB_MDT_GJYS.mdtse
  is '免抵退税额';
comment on column CKTS_SB_MDT_GJYS.chbz
  is '撤回标志';
comment on column CKTS_SB_MDT_GJYS.zhbz_1
  is '暂缓标志';
comment on column CKTS_SB_MDT_GJYS.bytsbz
  is '不予退税标志';
comment on column CKTS_SB_MDT_GJYS.bytsny
  is '不予退税年月';
comment on column CKTS_SB_MDT_GJYS.byblbz
  is '不予办理标志';
comment on column CKTS_SB_MDT_GJYS.byblny
  is '不予办理年月';
comment on column CKTS_SB_MDT_GJYS.zbblbz
  is '暂不办理标志';
comment on column CKTS_SB_MDT_GJYS.zbblny
  is '暂不办理年月';
comment on column CKTS_SB_MDT_GJYS.zzjczbblzyny
  is '最终解除暂不办理年月';
comment on column CKTS_SB_MDT_GJYS.mdtsny
  is '免抵退税年月';
comment on column CKTS_SB_MDT_GJYS.lcslid_sb
  is '申报LCSLID';
comment on column CKTS_SB_MDT_GJYS.lcslid_fs
  is '复审LCSLID';
comment on column CKTS_SB_MDT_GJYS.sjly
  is '1-GC表  2-JG表';
comment on column CKTS_SB_MDT_GJYS.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_MDT_GJYS.sbrq
  is '申报日期';
comment on column CKTS_SB_MDT_GJYS.xgrq
  is '修改日期NVL(T.XGRQ,T.LRRQ)-增量用';
comment on column CKTS_SB_MDT_GJYS.sjtb_bz
  is '错误继续标志';
create index IDX_CKTS_SB_MDT_GJYS_DSSS on CKTS_SB_MDT_GJYS (DJXH, SSQ, SBPC, SBXH)
  nologging;
create index IDX_CKTS_SB_MDT_GJYS_LCSLID on CKTS_SB_MDT_GJYS (LCSLID)
  nologging;
create index IDX_CKTS_SB_MDT_GJYS_LCSLID_FS on CKTS_SB_MDT_GJYS (LCSLID_FS)
  nologging;
create index IDX_CKTS_SB_MDT_GJYS_LCSLID_SB on CKTS_SB_MDT_GJYS (LCSLID_SB)
  nologging;
alter table CKTS_SB_MDT_GJYS
  add constraint PK_CKTS_SB_MDT_GJYS primary key (UUID);
alter index PK_CKTS_SB_MDT_GJYS nologging;

prompt
prompt Creating table CKTS_SB_MDT_SBDSHZ
prompt =================================
prompt
create table CKTS_SB_MDT_SBDSHZ
(
  uuid                       VARCHAR2(32) not null,
  lcslid                     CHAR(32),
  djxh                       NUMBER(20),
  ssq                        VARCHAR2(60),
  ckxsemy                    NUMBER(18,2),
  ckhwxsemy                  NUMBER(18,2),
  ysfwxsemy                  NUMBER(18,2),
  ckxsermb                   NUMBER(18,2),
  mdtsbdmzhdkse              NUMBER(18,6),
  ckhwbdmzhdkse              NUMBER(18,6),
  ysfwbdmzhdkse              NUMBER(18,6),
  jljghxytzbdmzhdkse         NUMBER(18,6),
  mdtsbdmzhdksehj            NUMBER(18,6),
  mdtse                      NUMBER(18,6),
  ckhwmdtse                  NUMBER(18,6),
  ysfwmdtse                  NUMBER(18,6),
  sqjzmdtse                  NUMBER(18,6),
  jljghxytzmdtse             NUMBER(18,6),
  mdtsehj                    NUMBER(18,6),
  jzxqmdtse                  NUMBER(18,6),
  zzsnssbbqmldse             NUMBER(18,6),
  ytse_1                     NUMBER(18,6),
  mdse                       NUMBER(18,6),
  bnljmdtckxsemy             NUMBER(18,2),
  bnljckhwxsemy              NUMBER(18,2),
  bnljysfwxsemy              NUMBER(18,2),
  bnljmdtckxsermb            NUMBER(18,2),
  bnljmdtsbdmzhdkse          NUMBER(18,6),
  bnljckhwbdmzhdkse          NUMBER(18,6),
  bnljysfwbdmzhdkse          NUMBER(18,6),
  bnljjljghxytzbdmzhdkse     NUMBER(18,6),
  bnljmdtsbdmzhdksehj        NUMBER(18,6),
  bnljmdtse                  NUMBER(18,6),
  bnljckhwmdtse              NUMBER(18,6),
  bnljysfwmdtse              NUMBER(18,6),
  bnljjljghxytzmdtse         NUMBER(18,6),
  bnljmdtsehj                NUMBER(18,6),
  bnljytse                   NUMBER(18,6),
  bnljmdse                   NUMBER(18,6),
  sqrmc                      VARCHAR2(300),
  smrxm                      VARCHAR2(150),
  bdmzdkseynsbce             NUMBER(18,6),
  lrr_dm                     CHAR(11),
  lrrq                       DATE not null,
  xgr_dm                     CHAR(11),
  xgrq                       DATE,
  tsswjg_dm_1                CHAR(11),
  sjgsdq                     CHAR(11) not null,
  sjtb_sj                    TIMESTAMP(6),
  nsbbcyjsssqq               DATE,
  nsbbcyjsssqz               DATE,
  ytsehw                     NUMBER(18,6),
  ytselw                     NUMBER(18,6),
  mdsehw                     NUMBER(18,6),
  mdselw                     NUMBER(18,6),
  qqzymdtse                  NUMBER(18,6),
  qqbymdtse                  NUMBER(18,6),
  qqzbblmdtse                NUMBER(18,6),
  ysfwyyezfgfsdnsrjk         NUMBER(18,2),
  jsqmldse                   NUMBER(18,6),
  dqbdmzhdkdje               NUMBER(18,6) default 0,
  jzbmzdkdje                 NUMBER(18,2),
  jbr                        VARCHAR2(150),
  jbrzjhm                    VARCHAR2(40),
  dljgtyshxydm               VARCHAR2(20),
  jzxqmdtsbdmzhdksedje       NUMBER(18,6),
  ytzbdmzhdkseyzzsnssbbce    NUMBER(18,6) default 0,
  syjljghxytzbdmzhdkseysbbce NUMBER(18,6) default 0
)
;
comment on table CKTS_SB_MDT_SBDSHZ
  is '免抵退税申报对审汇总表(结果表)';
comment on column CKTS_SB_MDT_SBDSHZ.uuid
  is 'UUID||uuid';
comment on column CKTS_SB_MDT_SBDSHZ.lcslid
  is '流程实例ID';
comment on column CKTS_SB_MDT_SBDSHZ.djxh
  is '登记序号';
comment on column CKTS_SB_MDT_SBDSHZ.ssq
  is '所属期';
comment on column CKTS_SB_MDT_SBDSHZ.ckxsemy
  is '出口销售额（美元）';
comment on column CKTS_SB_MDT_SBDSHZ.ckhwxsemy
  is '出口货物销售额（美元）';
comment on column CKTS_SB_MDT_SBDSHZ.ysfwxsemy
  is '应税服务销售额（美元）';
comment on column CKTS_SB_MDT_SBDSHZ.ckxsermb
  is '出口销售额（人民币）';
comment on column CKTS_SB_MDT_SBDSHZ.mdtsbdmzhdkse
  is '免抵退税不得免征和抵扣税额';
comment on column CKTS_SB_MDT_SBDSHZ.ckhwbdmzhdkse
  is '出口货物不得免征和抵扣税额';
comment on column CKTS_SB_MDT_SBDSHZ.ysfwbdmzhdkse
  is '应税服务不得免征和抵扣税额';
comment on column CKTS_SB_MDT_SBDSHZ.jljghxytzbdmzhdkse
  is '进料加工核销应调整不得免征和抵扣税额';
comment on column CKTS_SB_MDT_SBDSHZ.mdtsbdmzhdksehj
  is '免抵退税不得免征和抵扣税额合计';
comment on column CKTS_SB_MDT_SBDSHZ.mdtse
  is '免抵退税额';
comment on column CKTS_SB_MDT_SBDSHZ.ckhwmdtse
  is '出口货物免抵退税额';
comment on column CKTS_SB_MDT_SBDSHZ.ysfwmdtse
  is '应税服务免抵退税额';
comment on column CKTS_SB_MDT_SBDSHZ.sqjzmdtse
  is '上期结转免抵退税额';
comment on column CKTS_SB_MDT_SBDSHZ.jljghxytzmdtse
  is '进料加工核销应调整免抵退税额';
comment on column CKTS_SB_MDT_SBDSHZ.mdtsehj
  is '免抵退税额合计';
comment on column CKTS_SB_MDT_SBDSHZ.jzxqmdtse
  is '结转下期免抵退税额';
comment on column CKTS_SB_MDT_SBDSHZ.zzsnssbbqmldse
  is '增值税纳税申报表期末留抵税额';
comment on column CKTS_SB_MDT_SBDSHZ.ytse_1
  is '应退税额';
comment on column CKTS_SB_MDT_SBDSHZ.mdse
  is '免抵税额';
comment on column CKTS_SB_MDT_SBDSHZ.bnljmdtckxsemy
  is '本年累计免抵退出口销售额（美元）';
comment on column CKTS_SB_MDT_SBDSHZ.bnljckhwxsemy
  is '本年累计出口货物销售额（美元）';
comment on column CKTS_SB_MDT_SBDSHZ.bnljysfwxsemy
  is '本年累计应税服务销售额（美元）';
comment on column CKTS_SB_MDT_SBDSHZ.bnljmdtckxsermb
  is '本年累计免抵退出口销售额（人民币）';
comment on column CKTS_SB_MDT_SBDSHZ.bnljmdtsbdmzhdkse
  is '本年累计免抵退税不得免征和抵扣税额';
comment on column CKTS_SB_MDT_SBDSHZ.bnljckhwbdmzhdkse
  is '本年累计出口货物不得免征和抵扣税额';
comment on column CKTS_SB_MDT_SBDSHZ.bnljysfwbdmzhdkse
  is '本年累计应税服务不得免征和抵扣税额';
comment on column CKTS_SB_MDT_SBDSHZ.bnljjljghxytzbdmzhdkse
  is '本年累计进料加工核销应调整不得免征和抵扣税额';
comment on column CKTS_SB_MDT_SBDSHZ.bnljmdtsbdmzhdksehj
  is '本年累计免抵退税不得免征和抵扣税额合计';
comment on column CKTS_SB_MDT_SBDSHZ.bnljmdtse
  is '本年累计免抵退税额';
comment on column CKTS_SB_MDT_SBDSHZ.bnljckhwmdtse
  is '本年累计出口货物免抵退税额';
comment on column CKTS_SB_MDT_SBDSHZ.bnljysfwmdtse
  is '本年累计应税服务免抵退税额';
comment on column CKTS_SB_MDT_SBDSHZ.bnljjljghxytzmdtse
  is '本年累计进料加工核销应调整免抵退税额';
comment on column CKTS_SB_MDT_SBDSHZ.bnljmdtsehj
  is '本年累计免抵退税额合计';
comment on column CKTS_SB_MDT_SBDSHZ.bnljytse
  is '本年累计应退税额';
comment on column CKTS_SB_MDT_SBDSHZ.bnljmdse
  is '本年累计免抵税额';
comment on column CKTS_SB_MDT_SBDSHZ.sqrmc
  is '授权人名称';
comment on column CKTS_SB_MDT_SBDSHZ.smrxm
  is '声明人姓名';
comment on column CKTS_SB_MDT_SBDSHZ.bdmzdkseynsbce
  is '不得免征抵扣税额与纳税表差额';
comment on column CKTS_SB_MDT_SBDSHZ.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_MDT_SBDSHZ.lrrq
  is '录入日期';
comment on column CKTS_SB_MDT_SBDSHZ.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_MDT_SBDSHZ.xgrq
  is '修改日期';
comment on column CKTS_SB_MDT_SBDSHZ.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_MDT_SBDSHZ.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_MDT_SBDSHZ.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_MDT_SBDSHZ.nsbbcyjsssqq
  is '纳税报表参与计算所属期起';
comment on column CKTS_SB_MDT_SBDSHZ.nsbbcyjsssqz
  is '纳税报表参与计算所属期止';
comment on column CKTS_SB_MDT_SBDSHZ.ytsehw
  is '应退税额货物';
comment on column CKTS_SB_MDT_SBDSHZ.ytselw
  is '应退税额劳务';
comment on column CKTS_SB_MDT_SBDSHZ.mdsehw
  is '免抵税额货物';
comment on column CKTS_SB_MDT_SBDSHZ.mdselw
  is '免抵税额劳务';
comment on column CKTS_SB_MDT_SBDSHZ.qqzymdtse
  is '前期准予免抵退税额';
comment on column CKTS_SB_MDT_SBDSHZ.qqbymdtse
  is '前期不予免抵退税额';
comment on column CKTS_SB_MDT_SBDSHZ.qqzbblmdtse
  is '前期暂不办理免抵退税额';
comment on column CKTS_SB_MDT_SBDSHZ.ysfwyyezfgfsdnsrjk
  is '应税服务营业额支付给非试点纳税人价款';
comment on column CKTS_SB_MDT_SBDSHZ.jsqmldse
  is '计算期末留抵税额';
comment on column CKTS_SB_MDT_SBDSHZ.dqbdmzhdkdje
  is '当期不得免征和抵扣抵减额';
comment on column CKTS_SB_MDT_SBDSHZ.jzbmzdkdje
  is '结转不免征抵扣抵减额';
comment on column CKTS_SB_MDT_SBDSHZ.jbr
  is '经办人';
comment on column CKTS_SB_MDT_SBDSHZ.jbrzjhm
  is '经办人身份证件号码';
comment on column CKTS_SB_MDT_SBDSHZ.dljgtyshxydm
  is '代理机构统一社会信用代码||代理机构统一社会信用代码';
comment on column CKTS_SB_MDT_SBDSHZ.jzxqmdtsbdmzhdksedje
  is '结转下期免抵退税不得免征和抵扣税额抵减额';
comment on column CKTS_SB_MDT_SBDSHZ.ytzbdmzhdkseyzzsnssbbce
  is '进料加工核销应调整不得免征和抵扣税额与增值税纳税申报表差额';
comment on column CKTS_SB_MDT_SBDSHZ.syjljghxytzbdmzhdkseysbbce
  is '使用进料加工核销应调整不得免征和抵扣税额与增值税纳税申报表差额';
create index IDX_CKTS_MDT_SBDSHZ_JG_DS on CKTS_SB_MDT_SBDSHZ (DJXH, SSQ)
  nologging;
create index IDX_CKTS_MDT_SBDSHZ_JG_LCSLID on CKTS_SB_MDT_SBDSHZ (LCSLID);
alter table CKTS_SB_MDT_SBDSHZ
  add constraint PK_CKTS_SB_MDT_SBDSHZ primary key (UUID);

prompt
prompt Creating table CKTS_SB_MDT_YFSJ
prompt ===============================
prompt
create table CKTS_SB_MDT_YFSJ
(
  uuid          VARCHAR2(32) not null,
  lcslid        CHAR(32),
  tsswjg_dm     CHAR(11),
  djxh          NUMBER(20),
  ssq           VARCHAR2(60),
  sbpc          VARCHAR2(75) default '001',
  sbxh          VARCHAR2(50),
  ckfph         VARCHAR2(30),
  hth           VARCHAR2(60),
  ckrq_1        DATE,
  ysfw_dm       VARCHAR2(20),
  ysfwmc        VARCHAR2(500),
  ysfwyyemy     NUMBER(18,2),
  ysfwyyermb    NUMBER(18,2),
  zssl          NUMBER(16,6),
  tsl           NUMBER(16,6),
  mdtsbdmzhdkse NUMBER(18,6),
  mdtse         NUMBER(18,6),
  cktmsywlxdmjh VARCHAR2(30),
  cktmsywlxmcjh VARCHAR2(75),
  chbz          CHAR(1) default 'N',
  zhbz_1        CHAR(1) default 'N',
  bytsbz        CHAR(1) default 'N',
  bytsny        CHAR(6),
  byblbz        CHAR(1) default 'N',
  byblny        VARCHAR2(6),
  zbblbz        CHAR(1) default 'N',
  zbblny        VARCHAR2(6),
  zzjczbblzyny  VARCHAR2(6),
  mdtsny        CHAR(6),
  lcslid_sb     CHAR(32) default ' ',
  lcslid_fs     CHAR(32) default ' ',
  sjly          CHAR(1),
  sjtb_sj       TIMESTAMP(6),
  sbrq          DATE,
  xgrq          DATE,
  sjtb_bz       CHAR(1) default '0'
)
;
comment on table CKTS_SB_MDT_YFSJ
  is '免抵退研发设计明细表';
comment on column CKTS_SB_MDT_YFSJ.uuid
  is 'UUID';
comment on column CKTS_SB_MDT_YFSJ.lcslid
  is '分流LCSLID';
comment on column CKTS_SB_MDT_YFSJ.tsswjg_dm
  is '退税税务机关代码';
comment on column CKTS_SB_MDT_YFSJ.djxh
  is '登记序号';
comment on column CKTS_SB_MDT_YFSJ.ssq
  is '所属期';
comment on column CKTS_SB_MDT_YFSJ.sbpc
  is '申报批次（默认001）';
comment on column CKTS_SB_MDT_YFSJ.sbxh
  is '申报序号';
comment on column CKTS_SB_MDT_YFSJ.ckfph
  is '出口发票号码';
comment on column CKTS_SB_MDT_YFSJ.hth
  is '合同号';
comment on column CKTS_SB_MDT_YFSJ.ckrq_1
  is '出口日期';
comment on column CKTS_SB_MDT_YFSJ.ysfw_dm
  is '应税服务代码';
comment on column CKTS_SB_MDT_YFSJ.ysfwmc
  is '应税服务名称';
comment on column CKTS_SB_MDT_YFSJ.ysfwyyemy
  is '应税服务营业额（美元）';
comment on column CKTS_SB_MDT_YFSJ.ysfwyyermb
  is '应税服务营业额（人民币）';
comment on column CKTS_SB_MDT_YFSJ.zssl
  is '征税税率';
comment on column CKTS_SB_MDT_YFSJ.tsl
  is '退税率';
comment on column CKTS_SB_MDT_YFSJ.mdtsbdmzhdkse
  is '免抵退申报不得免征和抵扣税额';
comment on column CKTS_SB_MDT_YFSJ.mdtse
  is '免抵退税额';
comment on column CKTS_SB_MDT_YFSJ.cktmsywlxdmjh
  is '出口退（免）税业务类型代码集合';
comment on column CKTS_SB_MDT_YFSJ.cktmsywlxmcjh
  is '出口退（免）税业务类型名称集合';
comment on column CKTS_SB_MDT_YFSJ.chbz
  is '撤回标志';
comment on column CKTS_SB_MDT_YFSJ.zhbz_1
  is '暂缓标志';
comment on column CKTS_SB_MDT_YFSJ.bytsbz
  is '不予退税标志';
comment on column CKTS_SB_MDT_YFSJ.bytsny
  is '不予退税年月';
comment on column CKTS_SB_MDT_YFSJ.byblbz
  is '不予办理标志';
comment on column CKTS_SB_MDT_YFSJ.byblny
  is '不予办理年月';
comment on column CKTS_SB_MDT_YFSJ.zbblbz
  is '暂不办理标志';
comment on column CKTS_SB_MDT_YFSJ.zbblny
  is '暂不办理年月';
comment on column CKTS_SB_MDT_YFSJ.zzjczbblzyny
  is '最终解除暂不办理年月';
comment on column CKTS_SB_MDT_YFSJ.mdtsny
  is '免抵退税年月';
comment on column CKTS_SB_MDT_YFSJ.lcslid_sb
  is '申报LCSLID';
comment on column CKTS_SB_MDT_YFSJ.lcslid_fs
  is '复审LCSLID';
comment on column CKTS_SB_MDT_YFSJ.sjly
  is '1-GC表  2-JG表';
comment on column CKTS_SB_MDT_YFSJ.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_MDT_YFSJ.sbrq
  is '申报日期';
comment on column CKTS_SB_MDT_YFSJ.xgrq
  is '修改日期NVL(T.XGRQ,T.LRRQ)-增量用';
comment on column CKTS_SB_MDT_YFSJ.sjtb_bz
  is '错误继续标志';
create index IDX_CKTS_SB_MDT_YFSJ_DSSS on CKTS_SB_MDT_YFSJ (DJXH, SSQ, SBPC, SBXH)
  nologging;
create index IDX_CKTS_SB_MDT_YFSJ_LCSLID on CKTS_SB_MDT_YFSJ (LCSLID)
  nologging;
create index IDX_CKTS_SB_MDT_YFSJ_LCSLID_FS on CKTS_SB_MDT_YFSJ (LCSLID_FS)
  nologging;
create index IDX_CKTS_SB_MDT_YFSJ_LCSLID_SB on CKTS_SB_MDT_YFSJ (LCSLID_SB)
  nologging;
alter table CKTS_SB_MDT_YFSJ
  add constraint PK_CKTS_SB_MDT_YFSJ primary key (UUID);
alter index PK_CKTS_SB_MDT_YFSJ nologging;

prompt
prompt Creating table CKTS_SB_MTS_CKMX
prompt ===============================
prompt
create table CKTS_SB_MTS_CKMX
(
  uuid          VARCHAR2(32) not null,
  lcslid        CHAR(32),
  tsswjg_dm     CHAR(11),
  djxh          NUMBER(20),
  ssq           VARCHAR2(60),
  sbpc          VARCHAR2(75),
  sbxh          VARCHAR2(50),
  glh           VARCHAR2(30),
  ckfph         VARCHAR2(30),
  ckbgdh        VARCHAR2(21),
  dlckhwzmhm    VARCHAR2(20),
  ckrq_1        DATE,
  cksp_dm       VARCHAR2(20),
  sbhgspmc      VARCHAR2(500),
  hgjldwmc      VARCHAR2(75),
  cksl          NUMBER(16,4),
  mylaj         NUMBER(18,2),
  cktmsywlxdmjh VARCHAR2(30),
  cktmsywlxmcjh VARCHAR2(75),
  chbz          CHAR(1) default 'N',
  bytsbz        CHAR(1) default 'N',
  byblbz        CHAR(1) default 'N',
  lcslid_sb     CHAR(32) default ' ',
  tdcode        VARCHAR2(4),
  hgcode        VARCHAR2(4),
  hzdwdqdm      VARCHAR2(5),
  sbdwdm        VARCHAR2(20),
  gbcode        VARCHAR2(3),
  zzmdg         VARCHAR2(3),
  zyg           VARCHAR2(4),
  sjly          CHAR(1),
  sjtb_sj       TIMESTAMP(6),
  tse           NUMBER(18,2),
  sbrq          DATE,
  mtsbz         CHAR(1) default 'N',
  zbblbz        CHAR(1) default 'N',
  xgrq          DATE,
  sjtb_bz       CHAR(1) default '0',
  jsje          NUMBER(18,2),
  fsrq          DATE,
  tsl           NUMBER(16,6)
)
partition by range (TSSWJG_DM)
(
  partition P_13300000000 values less than ('13300000000')
    tablespace TL_TSSH,
  partition P_13301000000 values less than ('13301000000')
    tablespace TL_TSSH,
  partition P_13303000000 values less than ('13303000000')
    tablespace TL_TSSH,
  partition P_13304000000 values less than ('13304000000')
    tablespace TL_TSSH,
  partition P_13305000000 values less than ('13305000000')
    tablespace TL_TSSH,
  partition P_13306000000 values less than ('13306000000')
    tablespace TL_TSSH,
  partition P_13307000000 values less than ('13307000000')
    tablespace TL_TSSH,
  partition P_13308000000 values less than ('13308000000')
    tablespace TL_TSSH,
  partition P_13309000000 values less than ('13309000000')
    tablespace TL_TSSH,
  partition P_13310000000 values less than ('13310000000')
    tablespace TL_TSSH,
  partition P_13311000000 values less than ('13311000000')
    tablespace TL_TSSH,
  partition P_MAXVALUE values less than (MAXVALUE)
    tablespace TL_TSSH
);
comment on table CKTS_SB_MTS_CKMX
  is '免退税出口货物明细表';
comment on column CKTS_SB_MTS_CKMX.uuid
  is 'UUID';
comment on column CKTS_SB_MTS_CKMX.lcslid
  is '分流LCSLID';
comment on column CKTS_SB_MTS_CKMX.tsswjg_dm
  is '退税税务机关代码';
comment on column CKTS_SB_MTS_CKMX.djxh
  is '登记序号';
comment on column CKTS_SB_MTS_CKMX.ssq
  is '所属期';
comment on column CKTS_SB_MTS_CKMX.sbpc
  is '申报批次';
comment on column CKTS_SB_MTS_CKMX.sbxh
  is '申报序号';
comment on column CKTS_SB_MTS_CKMX.glh
  is '关联号';
comment on column CKTS_SB_MTS_CKMX.ckfph
  is '出口发票号码';
comment on column CKTS_SB_MTS_CKMX.ckbgdh
  is '出口报关单号';
comment on column CKTS_SB_MTS_CKMX.dlckhwzmhm
  is '代理出口货物证明号码';
comment on column CKTS_SB_MTS_CKMX.ckrq_1
  is '出口日期';
comment on column CKTS_SB_MTS_CKMX.cksp_dm
  is '出口商品代码';
comment on column CKTS_SB_MTS_CKMX.sbhgspmc
  is '申报海关商品名称';
comment on column CKTS_SB_MTS_CKMX.hgjldwmc
  is '海关计量单位名称';
comment on column CKTS_SB_MTS_CKMX.cksl
  is '出口数量';
comment on column CKTS_SB_MTS_CKMX.mylaj
  is '美元离岸价';
comment on column CKTS_SB_MTS_CKMX.cktmsywlxdmjh
  is '业务代码';
comment on column CKTS_SB_MTS_CKMX.cktmsywlxmcjh
  is '业务类型';
comment on column CKTS_SB_MTS_CKMX.chbz
  is '撤回标志';
comment on column CKTS_SB_MTS_CKMX.bytsbz
  is '不予退税标志';
comment on column CKTS_SB_MTS_CKMX.byblbz
  is '不予办理标志';
comment on column CKTS_SB_MTS_CKMX.lcslid_sb
  is '申报LCSLID';
comment on column CKTS_SB_MTS_CKMX.tdcode
  is '海关监管方式（关联报关单获取）';
comment on column CKTS_SB_MTS_CKMX.hgcode
  is '申报口岸（关联报关单获取）';
comment on column CKTS_SB_MTS_CKMX.hzdwdqdm
  is '货主单位地区代码（关联报关单获取）';
comment on column CKTS_SB_MTS_CKMX.sbdwdm
  is '申报单位代码（关联报关单获取）';
comment on column CKTS_SB_MTS_CKMX.gbcode
  is '国别代码（关联报关单获取）';
comment on column CKTS_SB_MTS_CKMX.zzmdg
  is '最终目的国（关联报关单获取）';
comment on column CKTS_SB_MTS_CKMX.zyg
  is '指运港（关联报关单获取）';
comment on column CKTS_SB_MTS_CKMX.sjly
  is '1-GC表  2-JG表';
comment on column CKTS_SB_MTS_CKMX.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_MTS_CKMX.tse
  is '退税额（从进货关联号汇总）';
comment on column CKTS_SB_MTS_CKMX.sbrq
  is '申报日期';
comment on column CKTS_SB_MTS_CKMX.mtsbz
  is '免退税标志';
comment on column CKTS_SB_MTS_CKMX.zbblbz
  is '暂不办理标志';
comment on column CKTS_SB_MTS_CKMX.xgrq
  is '修改日期NVL(T.XGRQ,T.LRRQ)-增量用';
comment on column CKTS_SB_MTS_CKMX.sjtb_bz
  is '错误继续标志';
comment on column CKTS_SB_MTS_CKMX.jsje
  is '进货金额';
comment on column CKTS_SB_MTS_CKMX.fsrq
  is '复审日期';
comment on column CKTS_SB_MTS_CKMX.tsl
  is '退税率';
create index IDX_CKTS_SB_MTS_CKMX_DC on CKTS_SB_MTS_CKMX (DJXH, CKBGDH)
  nologging;
create index IDX_CKTS_SB_MTS_CKMX_DGCL on CKTS_SB_MTS_CKMX (DJXH, GLH, CKSP_DM, LCSLID)
  nologging;
create index IDX_CKTS_SB_MTS_CKMX_DSSS on CKTS_SB_MTS_CKMX (DJXH, SSQ, SBPC, SBXH)
  nologging;
create index IDX_CKTS_SB_MTS_CKMX_LCSLID on CKTS_SB_MTS_CKMX (LCSLID)
  nologging;
create index IDX_CKTS_SB_MTS_CKMX_LCSLID_SB on CKTS_SB_MTS_CKMX (LCSLID_SB)
  nologging;
create index IDX_CKTS_SB_MTS_CKMX_SC on CKTS_SB_MTS_CKMX (SBRQ, CKSP_DM)
  nologging;
create index IDX_CKTS_SB_MTS_CKMX_SJ on CKTS_SB_MTS_CKMX (SJTB_SJ)
  nologging;
create index IDX_CKTS_SB_MTS_CKMX_STS on CKTS_SB_MTS_CKMX (SJLY, TDCODE, SJTB_SJ)
  nologging;
create index IDX_CKTS_SB_MTS_CKMX_TC on CKTS_SB_MTS_CKMX (TSSWJG_DM, CKRQ_1)
  nologging;
create index IDX_CKTS_SB_MTS_CKMX_TF on CKTS_SB_MTS_CKMX (TSSWJG_DM, FSRQ)
  nologging;
create index IDX_CKTS_SB_MTS_CKMX_TST on CKTS_SB_MTS_CKMX (TSSWJG_DM, SBRQ, TDCODE)
  nologging;
alter table CKTS_SB_MTS_CKMX
  add constraint PK_CKTS_SB_MTS_CKMX primary key (UUID);
alter index PK_CKTS_SB_MTS_CKMX nologging;

prompt
prompt Creating table CKTS_SB_MTS_CKMX_HIS
prompt ===================================
prompt
create table CKTS_SB_MTS_CKMX_HIS
(
  uuid          VARCHAR2(32) not null,
  lcslid        CHAR(32),
  tsswjg_dm     CHAR(11),
  djxh          NUMBER(20),
  ssq           VARCHAR2(60),
  sbpc          VARCHAR2(75),
  sbxh          VARCHAR2(50),
  glh           VARCHAR2(30),
  ckfph         VARCHAR2(30),
  ckbgdh        VARCHAR2(21),
  dlckhwzmhm    VARCHAR2(20),
  ckrq_1        DATE,
  cksp_dm       VARCHAR2(20),
  sbhgspmc      VARCHAR2(500),
  hgjldwmc      VARCHAR2(75),
  cksl          NUMBER(16,4),
  mylaj         NUMBER(18,2),
  cktmsywlxdmjh VARCHAR2(30),
  cktmsywlxmcjh VARCHAR2(75),
  chbz          CHAR(1) default 'N',
  bytsbz        CHAR(1) default 'N',
  byblbz        CHAR(1) default 'N',
  lcslid_sb     CHAR(32) default ' ',
  tdcode        VARCHAR2(4),
  hgcode        VARCHAR2(4),
  hzdwdqdm      VARCHAR2(5),
  sbdwdm        VARCHAR2(20),
  gbcode        VARCHAR2(3),
  zzmdg         VARCHAR2(3),
  zyg           VARCHAR2(4),
  sjly          CHAR(1),
  sjtb_sj       TIMESTAMP(6),
  tse           NUMBER(18,2),
  sbrq          DATE,
  mtsbz         CHAR(1) default 'N',
  zbblbz        CHAR(1) default 'N',
  xgrq          DATE,
  sjtb_bz       CHAR(1) default '0',
  jsje          NUMBER(18,2),
  fsrq          DATE,
  tsl           NUMBER(16,6)
)
;
comment on table CKTS_SB_MTS_CKMX_HIS
  is '免退税出口货物明细表';
comment on column CKTS_SB_MTS_CKMX_HIS.uuid
  is 'UUID';
comment on column CKTS_SB_MTS_CKMX_HIS.lcslid
  is '分流LCSLID';
comment on column CKTS_SB_MTS_CKMX_HIS.tsswjg_dm
  is '退税税务机关代码';
comment on column CKTS_SB_MTS_CKMX_HIS.djxh
  is '登记序号';
comment on column CKTS_SB_MTS_CKMX_HIS.ssq
  is '所属期';
comment on column CKTS_SB_MTS_CKMX_HIS.sbpc
  is '申报批次';
comment on column CKTS_SB_MTS_CKMX_HIS.sbxh
  is '申报序号';
comment on column CKTS_SB_MTS_CKMX_HIS.glh
  is '关联号';
comment on column CKTS_SB_MTS_CKMX_HIS.ckfph
  is '出口发票号码';
comment on column CKTS_SB_MTS_CKMX_HIS.ckbgdh
  is '出口报关单号';
comment on column CKTS_SB_MTS_CKMX_HIS.dlckhwzmhm
  is '代理出口货物证明号码';
comment on column CKTS_SB_MTS_CKMX_HIS.ckrq_1
  is '出口日期';
comment on column CKTS_SB_MTS_CKMX_HIS.cksp_dm
  is '出口商品代码';
comment on column CKTS_SB_MTS_CKMX_HIS.sbhgspmc
  is '申报海关商品名称';
comment on column CKTS_SB_MTS_CKMX_HIS.hgjldwmc
  is '海关计量单位名称';
comment on column CKTS_SB_MTS_CKMX_HIS.cksl
  is '出口数量';
comment on column CKTS_SB_MTS_CKMX_HIS.mylaj
  is '美元离岸价';
comment on column CKTS_SB_MTS_CKMX_HIS.cktmsywlxdmjh
  is '业务代码';
comment on column CKTS_SB_MTS_CKMX_HIS.cktmsywlxmcjh
  is '业务类型';
comment on column CKTS_SB_MTS_CKMX_HIS.chbz
  is '撤回标志';
comment on column CKTS_SB_MTS_CKMX_HIS.bytsbz
  is '不予退税标志';
comment on column CKTS_SB_MTS_CKMX_HIS.byblbz
  is '不予办理标志';
comment on column CKTS_SB_MTS_CKMX_HIS.lcslid_sb
  is '申报LCSLID';
comment on column CKTS_SB_MTS_CKMX_HIS.tdcode
  is '海关监管方式（关联报关单获取）';
comment on column CKTS_SB_MTS_CKMX_HIS.hgcode
  is '申报口岸（关联报关单获取）';
comment on column CKTS_SB_MTS_CKMX_HIS.hzdwdqdm
  is '货主单位地区代码（关联报关单获取）';
comment on column CKTS_SB_MTS_CKMX_HIS.sbdwdm
  is '申报单位代码（关联报关单获取）';
comment on column CKTS_SB_MTS_CKMX_HIS.gbcode
  is '国别代码（关联报关单获取）';
comment on column CKTS_SB_MTS_CKMX_HIS.zzmdg
  is '最终目的国（关联报关单获取）';
comment on column CKTS_SB_MTS_CKMX_HIS.zyg
  is '指运港（关联报关单获取）';
comment on column CKTS_SB_MTS_CKMX_HIS.sjly
  is '1-GC表  2-JG表';
comment on column CKTS_SB_MTS_CKMX_HIS.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_MTS_CKMX_HIS.tse
  is '退税额（从进货关联号汇总）';
comment on column CKTS_SB_MTS_CKMX_HIS.sbrq
  is '申报日期';
comment on column CKTS_SB_MTS_CKMX_HIS.mtsbz
  is '免退税标志';
comment on column CKTS_SB_MTS_CKMX_HIS.zbblbz
  is '暂不办理标志';
comment on column CKTS_SB_MTS_CKMX_HIS.xgrq
  is '修改日期NVL(T.XGRQ,T.LRRQ)-增量用';
comment on column CKTS_SB_MTS_CKMX_HIS.sjtb_bz
  is '错误继续标志';
comment on column CKTS_SB_MTS_CKMX_HIS.jsje
  is '进货金额';
comment on column CKTS_SB_MTS_CKMX_HIS.fsrq
  is '复审日期';
comment on column CKTS_SB_MTS_CKMX_HIS.tsl
  is '退税率';
create index IDX_CKTS_SB_MTS_CKMX_HIS_DC on CKTS_SB_MTS_CKMX_HIS (DJXH, CKBGDH)
  nologging;
create index IDX_CKTS_SB_MTS_CKMX_HIS_DGCL on CKTS_SB_MTS_CKMX_HIS (DJXH, GLH, CKSP_DM, LCSLID)
  nologging;
create index IDX_CKTS_SB_MTS_CKMX_HIS_DSSS on CKTS_SB_MTS_CKMX_HIS (DJXH, SSQ, SBPC, SBXH)
  nologging;
create index IDX_CKTS_SB_MTS_CKMX_HIS_L on CKTS_SB_MTS_CKMX_HIS (LCSLID)
  nologging;
create index IDX_CKTS_SB_MTS_CKMX_HIS_L_S on CKTS_SB_MTS_CKMX_HIS (LCSLID_SB)
  nologging;
create index IDX_CKTS_SB_MTS_CKMX_HIS_SC on CKTS_SB_MTS_CKMX_HIS (SBRQ, CKSP_DM)
  nologging;
create index IDX_CKTS_SB_MTS_CKMX_HIS_SJ on CKTS_SB_MTS_CKMX_HIS (SJTB_SJ)
  nologging;
create index IDX_CKTS_SB_MTS_CKMX_HIS_STS on CKTS_SB_MTS_CKMX_HIS (SJLY, TDCODE, SJTB_SJ)
  nologging;
create index IDX_CKTS_SB_MTS_CKMX_HIS_TC on CKTS_SB_MTS_CKMX_HIS (TSSWJG_DM, CKRQ_1)
  nologging;
create index IDX_CKTS_SB_MTS_CKMX_HIS_TF on CKTS_SB_MTS_CKMX_HIS (TSSWJG_DM, FSRQ)
  nologging;
create index IDX_CKTS_SB_MTS_CKMX_HIS_TST on CKTS_SB_MTS_CKMX_HIS (TSSWJG_DM, SBRQ, TDCODE)
  nologging;
alter table CKTS_SB_MTS_CKMX_HIS
  add constraint PK_CKTS_SB_MTS_CKMX_HIS primary key (UUID);
alter index PK_CKTS_SB_MTS_CKMX_HIS nologging;

prompt
prompt Creating table CKTS_SB_MTS_JHMX
prompt ===============================
prompt
create table CKTS_SB_MTS_JHMX
(
  uuid         VARCHAR2(32) not null,
  lcslid       CHAR(32),
  tsswjg_dm    CHAR(11),
  djxh         NUMBER(20),
  ssq          VARCHAR2(60),
  sbpc         VARCHAR2(75),
  sbxh         VARCHAR2(50),
  glh          VARCHAR2(30),
  sz           CHAR(1),
  cktmspzlx_dm CHAR(2),
  jhpzh        VARCHAR2(75),
  kprq         DATE,
  cksp_dm      VARCHAR2(20),
  sbhgspmc     VARCHAR2(500),
  hgjldwmc     VARCHAR2(75),
  sl           NUMBER(16,4),
  jsje         NUMBER(18,2),
  zssl         NUMBER(16,6),
  tsl          NUMBER(16,6),
  tse          NUMBER(18,6),
  ghfnsrsbh_1  VARCHAR2(20),
  chbz         CHAR(1) default 'N',
  bytsbz       CHAR(1) default 'N',
  byblbz       CHAR(1) default 'N',
  mtsbz        CHAR(1) default 'N',
  lcslid_sb    CHAR(32) default ' ',
  xzqh         VARCHAR2(4),
  hyd          VARCHAR2(10),
  sjly         CHAR(1),
  sjtb_sj      TIMESTAMP(6),
  sbrq         DATE,
  ckrq_1       DATE default DATE'1900-01-01',
  zbblbz       CHAR(1) default 'N',
  zzjczbblzyny VARCHAR2(6),
  xgrq         DATE,
  sjtb_bz      CHAR(1) default '0',
  xsfdsswjgdm  VARCHAR2(11)
)
partition by range (TSSWJG_DM)
(
  partition P_13300000000 values less than ('13300000000')
    tablespace TL_TSSH,
  partition P_13301000000 values less than ('13301000000')
    tablespace TL_TSSH,
  partition P_13303000000 values less than ('13303000000')
    tablespace TL_TSSH,
  partition P_13304000000 values less than ('13304000000')
    tablespace TL_TSSH,
  partition P_13305000000 values less than ('13305000000')
    tablespace TL_TSSH,
  partition P_13306000000 values less than ('13306000000')
    tablespace TL_TSSH,
  partition P_13307000000 values less than ('13307000000')
    tablespace TL_TSSH,
  partition P_13308000000 values less than ('13308000000')
    tablespace TL_TSSH,
  partition P_13309000000 values less than ('13309000000')
    tablespace TL_TSSH,
  partition P_13310000000 values less than ('13310000000')
    tablespace TL_TSSH,
  partition P_13311000000 values less than ('13311000000')
    tablespace TL_TSSH,
  partition P_MAXVALUE values less than (MAXVALUE)
    tablespace TL_TSSH
);
comment on table CKTS_SB_MTS_JHMX
  is '免退税进货明细表';
comment on column CKTS_SB_MTS_JHMX.uuid
  is 'UUID';
comment on column CKTS_SB_MTS_JHMX.lcslid
  is '分流LCSLID';
comment on column CKTS_SB_MTS_JHMX.tsswjg_dm
  is '退税税务机关代码';
comment on column CKTS_SB_MTS_JHMX.djxh
  is '登记序号';
comment on column CKTS_SB_MTS_JHMX.ssq
  is '所属期';
comment on column CKTS_SB_MTS_JHMX.sbpc
  is '申报批次';
comment on column CKTS_SB_MTS_JHMX.sbxh
  is '申报序号';
comment on column CKTS_SB_MTS_JHMX.glh
  is '关联号';
comment on column CKTS_SB_MTS_JHMX.sz
  is '税种';
comment on column CKTS_SB_MTS_JHMX.cktmspzlx_dm
  is '凭证种类';
comment on column CKTS_SB_MTS_JHMX.jhpzh
  is '进货凭证号/专用税票号';
comment on column CKTS_SB_MTS_JHMX.kprq
  is '开票日期';
comment on column CKTS_SB_MTS_JHMX.cksp_dm
  is '出口商品代码';
comment on column CKTS_SB_MTS_JHMX.sbhgspmc
  is '申报海关商品名称';
comment on column CKTS_SB_MTS_JHMX.hgjldwmc
  is '海关计量单位名称';
comment on column CKTS_SB_MTS_JHMX.sl
  is '数量';
comment on column CKTS_SB_MTS_JHMX.jsje
  is '计税金额';
comment on column CKTS_SB_MTS_JHMX.zssl
  is '征税税率';
comment on column CKTS_SB_MTS_JHMX.tsl
  is '退税率';
comment on column CKTS_SB_MTS_JHMX.tse
  is '退税额';
comment on column CKTS_SB_MTS_JHMX.ghfnsrsbh_1
  is '供货方纳税人识别号';
comment on column CKTS_SB_MTS_JHMX.chbz
  is '撤回标志';
comment on column CKTS_SB_MTS_JHMX.bytsbz
  is '不予退税标志';
comment on column CKTS_SB_MTS_JHMX.byblbz
  is '不予办理标志';
comment on column CKTS_SB_MTS_JHMX.mtsbz
  is '免退税标志';
comment on column CKTS_SB_MTS_JHMX.lcslid_sb
  is '申报LCSLID';
comment on column CKTS_SB_MTS_JHMX.xzqh
  is '行政区划';
comment on column CKTS_SB_MTS_JHMX.hyd
  is '货源地';
comment on column CKTS_SB_MTS_JHMX.sjly
  is '1-GC表  2-JG表';
comment on column CKTS_SB_MTS_JHMX.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_MTS_JHMX.sbrq
  is '申报日期';
comment on column CKTS_SB_MTS_JHMX.ckrq_1
  is '出口日期';
comment on column CKTS_SB_MTS_JHMX.zbblbz
  is '暂不办理标志';
comment on column CKTS_SB_MTS_JHMX.zzjczbblzyny
  is '最终解除暂不办理年月';
comment on column CKTS_SB_MTS_JHMX.xgrq
  is '修改日期NVL(T.XGRQ,T.LRRQ)-增量用';
comment on column CKTS_SB_MTS_JHMX.sjtb_bz
  is '错误继续标志';
comment on column CKTS_SB_MTS_JHMX.xsfdsswjgdm
  is '销售方地市税务机关代码，20251226取发票系统';
create index IDX_CKTS_SB_MTS_JHMX_CKRQ on CKTS_SB_MTS_JHMX (CKRQ_1)
  nologging;
create index IDX_CKTS_SB_MTS_JHMX_DGCL on CKTS_SB_MTS_JHMX (DJXH, GLH, CKSP_DM, LCSLID)
  nologging;
create index IDX_CKTS_SB_MTS_JHMX_DS on CKTS_SB_MTS_JHMX (DJXH, SBRQ)
  nologging;
create index IDX_CKTS_SB_MTS_JHMX_DSSS on CKTS_SB_MTS_JHMX (DJXH, SSQ, SBPC, SBXH)
  nologging;
create index IDX_CKTS_SB_MTS_JHMX_LCSLID on CKTS_SB_MTS_JHMX (LCSLID)
  nologging;
create index IDX_CKTS_SB_MTS_JHMX_LCSLID_SB on CKTS_SB_MTS_JHMX (LCSLID_SB)
  nologging;
create index IDX_CKTS_SB_MTS_JHMX_S on CKTS_SB_MTS_JHMX (SBRQ)
  nologging;
alter table CKTS_SB_MTS_JHMX
  add constraint PK_CKTS_SB_MTS_JHMX primary key (UUID);
alter index PK_CKTS_SB_MTS_JHMX nologging;

prompt
prompt Creating table CKTS_SB_MTS_JHMX_HIS
prompt ===================================
prompt
create table CKTS_SB_MTS_JHMX_HIS
(
  uuid         VARCHAR2(32) not null,
  lcslid       CHAR(32),
  tsswjg_dm    CHAR(11),
  djxh         NUMBER(20),
  ssq          VARCHAR2(60),
  sbpc         VARCHAR2(75),
  sbxh         VARCHAR2(50),
  glh          VARCHAR2(30),
  sz           CHAR(1),
  cktmspzlx_dm CHAR(2),
  jhpzh        VARCHAR2(75),
  kprq         DATE,
  cksp_dm      VARCHAR2(20),
  sbhgspmc     VARCHAR2(500),
  hgjldwmc     VARCHAR2(75),
  sl           NUMBER(16,4),
  jsje         NUMBER(18,2),
  zssl         NUMBER(16,6),
  tsl          NUMBER(16,6),
  tse          NUMBER(18,6),
  ghfnsrsbh_1  VARCHAR2(20),
  chbz         CHAR(1) default 'N',
  bytsbz       CHAR(1) default 'N',
  byblbz       CHAR(1) default 'N',
  mtsbz        CHAR(1) default 'N',
  lcslid_sb    CHAR(32) default ' ',
  xzqh         VARCHAR2(4),
  hyd          VARCHAR2(10),
  sjly         CHAR(1),
  sjtb_sj      TIMESTAMP(6),
  sbrq         DATE,
  ckrq_1       DATE default DATE'1900-01-01',
  zbblbz       CHAR(1) default 'N',
  zzjczbblzyny VARCHAR2(6),
  xgrq         DATE,
  sjtb_bz      CHAR(1) default '0',
  xsfdsswjgdm  VARCHAR2(11)
)
;
comment on table CKTS_SB_MTS_JHMX_HIS
  is '免退税进货明细表';
comment on column CKTS_SB_MTS_JHMX_HIS.uuid
  is 'UUID';
comment on column CKTS_SB_MTS_JHMX_HIS.lcslid
  is '分流LCSLID';
comment on column CKTS_SB_MTS_JHMX_HIS.tsswjg_dm
  is '退税税务机关代码';
comment on column CKTS_SB_MTS_JHMX_HIS.djxh
  is '登记序号';
comment on column CKTS_SB_MTS_JHMX_HIS.ssq
  is '所属期';
comment on column CKTS_SB_MTS_JHMX_HIS.sbpc
  is '申报批次';
comment on column CKTS_SB_MTS_JHMX_HIS.sbxh
  is '申报序号';
comment on column CKTS_SB_MTS_JHMX_HIS.glh
  is '关联号';
comment on column CKTS_SB_MTS_JHMX_HIS.sz
  is '税种';
comment on column CKTS_SB_MTS_JHMX_HIS.cktmspzlx_dm
  is '凭证种类';
comment on column CKTS_SB_MTS_JHMX_HIS.jhpzh
  is '进货凭证号/专用税票号';
comment on column CKTS_SB_MTS_JHMX_HIS.kprq
  is '开票日期';
comment on column CKTS_SB_MTS_JHMX_HIS.cksp_dm
  is '出口商品代码';
comment on column CKTS_SB_MTS_JHMX_HIS.sbhgspmc
  is '申报海关商品名称';
comment on column CKTS_SB_MTS_JHMX_HIS.hgjldwmc
  is '海关计量单位名称';
comment on column CKTS_SB_MTS_JHMX_HIS.sl
  is '数量';
comment on column CKTS_SB_MTS_JHMX_HIS.jsje
  is '计税金额';
comment on column CKTS_SB_MTS_JHMX_HIS.zssl
  is '征税税率';
comment on column CKTS_SB_MTS_JHMX_HIS.tsl
  is '退税率';
comment on column CKTS_SB_MTS_JHMX_HIS.tse
  is '退税额';
comment on column CKTS_SB_MTS_JHMX_HIS.ghfnsrsbh_1
  is '供货方纳税人识别号';
comment on column CKTS_SB_MTS_JHMX_HIS.chbz
  is '撤回标志';
comment on column CKTS_SB_MTS_JHMX_HIS.bytsbz
  is '不予退税标志';
comment on column CKTS_SB_MTS_JHMX_HIS.byblbz
  is '不予办理标志';
comment on column CKTS_SB_MTS_JHMX_HIS.mtsbz
  is '免退税标志';
comment on column CKTS_SB_MTS_JHMX_HIS.lcslid_sb
  is '申报LCSLID';
comment on column CKTS_SB_MTS_JHMX_HIS.xzqh
  is '行政区划';
comment on column CKTS_SB_MTS_JHMX_HIS.hyd
  is '货源地';
comment on column CKTS_SB_MTS_JHMX_HIS.sjly
  is '1-GC表  2-JG表';
comment on column CKTS_SB_MTS_JHMX_HIS.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_MTS_JHMX_HIS.sbrq
  is '申报日期';
comment on column CKTS_SB_MTS_JHMX_HIS.ckrq_1
  is '出口日期';
comment on column CKTS_SB_MTS_JHMX_HIS.zbblbz
  is '暂不办理标志';
comment on column CKTS_SB_MTS_JHMX_HIS.zzjczbblzyny
  is '最终解除暂不办理年月';
comment on column CKTS_SB_MTS_JHMX_HIS.xgrq
  is '修改日期NVL(T.XGRQ,T.LRRQ)-增量用';
comment on column CKTS_SB_MTS_JHMX_HIS.sjtb_bz
  is '错误继续标志';
comment on column CKTS_SB_MTS_JHMX_HIS.xsfdsswjgdm
  is '销售方地市税务机关代码，20251226取发票系统';
create index IDX_CKTS_SB_MTS_JHMX_HIS_CKRQ on CKTS_SB_MTS_JHMX_HIS (CKRQ_1)
  nologging;
create index IDX_CKTS_SB_MTS_JHMX_HIS_DGCL on CKTS_SB_MTS_JHMX_HIS (DJXH, GLH, CKSP_DM, LCSLID)
  nologging;
create index IDX_CKTS_SB_MTS_JHMX_HIS_DS on CKTS_SB_MTS_JHMX_HIS (DJXH, SBRQ)
  nologging;
create index IDX_CKTS_SB_MTS_JHMX_HIS_DSSS on CKTS_SB_MTS_JHMX_HIS (DJXH, SSQ, SBPC, SBXH)
  nologging;
create index IDX_CKTS_SB_MTS_JHMX_HIS_L on CKTS_SB_MTS_JHMX_HIS (LCSLID)
  nologging;
create index IDX_CKTS_SB_MTS_JHMX_HIS_L_S on CKTS_SB_MTS_JHMX_HIS (LCSLID_SB)
  nologging;
create index IDX_CKTS_SB_MTS_JHMX_HIS_S on CKTS_SB_MTS_JHMX_HIS (SBRQ)
  nologging;
alter table CKTS_SB_MTS_JHMX_HIS
  add constraint PK_CKTS_SB_MTS_JHMX_HIS primary key (UUID);
alter index PK_CKTS_SB_MTS_JHMX_HIS nologging;

prompt
prompt Creating table CKTS_SB_MTS_YSFW
prompt ===============================
prompt
create table CKTS_SB_MTS_YSFW
(
  uuid              VARCHAR2(32) not null,
  lcslid            CHAR(32),
  tsswjg_dm         CHAR(11),
  djxh              NUMBER(20),
  ssq               VARCHAR2(60),
  sbpc              VARCHAR2(75),
  sbxh              VARCHAR2(50),
  ckfph             VARCHAR2(30),
  hth               VARCHAR2(60),
  ckrq_1            DATE,
  ysfw_dm           VARCHAR2(20),
  ysfwmc            VARCHAR2(500),
  skjemy            NUMBER(18,2),
  bqqrysfwyysrrmbje NUMBER(18,2),
  jhpzh             VARCHAR2(75),
  kprq              DATE,
  jsje              NUMBER(18,2),
  zssl              NUMBER(16,6),
  tsl               NUMBER(16,6),
  zzstse            NUMBER(18,6),
  ghfnsrsbh_1       VARCHAR2(20),
  cktmsywlxdmjh     VARCHAR2(30),
  cktmsywlxmcjh     VARCHAR2(75),
  chbz              CHAR(1) default 'N',
  bytsbz            CHAR(1) default 'N',
  byblbz            CHAR(1) default 'N',
  lcslid_sb         CHAR(32) default ' ',
  sjly              CHAR(1),
  sjtb_sj           TIMESTAMP(6),
  sbrq              DATE,
  xgrq              DATE,
  sjtb_bz           CHAR(1) default '0',
  mtsbz             CHAR(1) default 'N',
  zbblbz            CHAR(1) default 'N'
)
;
comment on table CKTS_SB_MTS_YSFW
  is '免退税跨境应税行为出口明细表';
comment on column CKTS_SB_MTS_YSFW.uuid
  is 'UUID';
comment on column CKTS_SB_MTS_YSFW.lcslid
  is '分流LCSLID';
comment on column CKTS_SB_MTS_YSFW.tsswjg_dm
  is '退税税务机关代码';
comment on column CKTS_SB_MTS_YSFW.djxh
  is '登记序号';
comment on column CKTS_SB_MTS_YSFW.ssq
  is '所属期';
comment on column CKTS_SB_MTS_YSFW.sbpc
  is '申报批次';
comment on column CKTS_SB_MTS_YSFW.sbxh
  is '申报序号';
comment on column CKTS_SB_MTS_YSFW.ckfph
  is '出口发票号码';
comment on column CKTS_SB_MTS_YSFW.hth
  is '合同号';
comment on column CKTS_SB_MTS_YSFW.ckrq_1
  is '出口日期';
comment on column CKTS_SB_MTS_YSFW.ysfw_dm
  is '应税服务代码';
comment on column CKTS_SB_MTS_YSFW.ysfwmc
  is '应税服务名称';
comment on column CKTS_SB_MTS_YSFW.skjemy
  is '收款金额（美元）';
comment on column CKTS_SB_MTS_YSFW.bqqrysfwyysrrmbje
  is '本期确认应税服务营业额（人民币）';
comment on column CKTS_SB_MTS_YSFW.jhpzh
  is '进货凭证号';
comment on column CKTS_SB_MTS_YSFW.kprq
  is '开票日期';
comment on column CKTS_SB_MTS_YSFW.jsje
  is '计税金额';
comment on column CKTS_SB_MTS_YSFW.zssl
  is '征税税率';
comment on column CKTS_SB_MTS_YSFW.tsl
  is '退税率';
comment on column CKTS_SB_MTS_YSFW.zzstse
  is '增值税退税额';
comment on column CKTS_SB_MTS_YSFW.ghfnsrsbh_1
  is '供货方纳税人识别号';
comment on column CKTS_SB_MTS_YSFW.cktmsywlxdmjh
  is '业务代码';
comment on column CKTS_SB_MTS_YSFW.cktmsywlxmcjh
  is '业务类型';
comment on column CKTS_SB_MTS_YSFW.chbz
  is '撤回标志';
comment on column CKTS_SB_MTS_YSFW.bytsbz
  is '不予退税标志';
comment on column CKTS_SB_MTS_YSFW.byblbz
  is '不予办理标志';
comment on column CKTS_SB_MTS_YSFW.lcslid_sb
  is '申报LCSLID';
comment on column CKTS_SB_MTS_YSFW.sjly
  is '1-GC表  2-JG表';
comment on column CKTS_SB_MTS_YSFW.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_MTS_YSFW.sbrq
  is '申报日期';
comment on column CKTS_SB_MTS_YSFW.xgrq
  is '修改日期NVL(T.XGRQ,T.LRRQ)-增量用';
comment on column CKTS_SB_MTS_YSFW.sjtb_bz
  is '错误继续标志';
comment on column CKTS_SB_MTS_YSFW.mtsbz
  is '免退税标志';
comment on column CKTS_SB_MTS_YSFW.zbblbz
  is '暂不办理标志';
create index IDX_CKTS_SB_MTS_YSFW_DSSS on CKTS_SB_MTS_YSFW (DJXH, SSQ, SBPC, SBXH)
  nologging;
create index IDX_CKTS_SB_MTS_YSFW_LCSLID on CKTS_SB_MTS_YSFW (LCSLID)
  nologging;
alter table CKTS_SB_MTS_YSFW
  add constraint PK_CKTS_SB_MTS_YSFW primary key (UUID);
alter index PK_CKTS_SB_MTS_YSFW nologging;

prompt
prompt Creating table CKTS_SB_WZF_CKMX
prompt ===============================
prompt
create table CKTS_SB_WZF_CKMX
(
  uuid             VARCHAR2(32) not null,
  lcslid           CHAR(32),
  tsswjg_dm        CHAR(11),
  djxh             NUMBER(20),
  ssq              VARCHAR2(60),
  sbpc             VARCHAR2(75),
  sbxh             VARCHAR2(50),
  wtdbtsscqynsrsbh VARCHAR2(20),
  ckbgdh           VARCHAR2(21),
  ckrq_1           DATE,
  cksp_dm          VARCHAR2(20),
  hgspmc           VARCHAR2(500),
  hgjldwmc         VARCHAR2(75),
  cksl             NUMBER(16,4),
  mylaj            NUMBER(18,2),
  dbtswspzhm       VARCHAR2(40),
  kprq             DATE,
  jsje             NUMBER(18,2),
  zssl             NUMBER(16,6),
  tsl              NUMBER(16,6),
  tse              NUMBER(18,6),
  cktmsywlxdmjh    VARCHAR2(30),
  cktmsywlxmcjh    VARCHAR2(75),
  dbtsywlx_dm      VARCHAR2(20),
  dbtsywlxmc       VARCHAR2(75),
  chbz             CHAR(1) default 'N',
  bytsbz           CHAR(1) default 'N',
  byblbz           CHAR(1) default 'N',
  lcslid_sb        CHAR(32) default ' ',
  sjly             CHAR(1),
  sjtb_sj          TIMESTAMP(6),
  tdcode           VARCHAR2(4),
  hgcode           VARCHAR2(4),
  hzdwdqdm         VARCHAR2(5),
  sbdwdm           VARCHAR2(20),
  gbcode           VARCHAR2(3),
  zzmdg            VARCHAR2(3),
  zyg              VARCHAR2(4),
  sbrq             DATE,
  mtsbz            CHAR(1) default 'N',
  zbblbz           CHAR(1) default 'N',
  zzjczbblzyny     VARCHAR2(6),
  xgrq             DATE,
  sjtb_bz          CHAR(1) default '0',
  fsrq             DATE
)
;
comment on table CKTS_SB_WZF_CKMX
  is '外贸综合服务代办退税申报表';
comment on column CKTS_SB_WZF_CKMX.uuid
  is 'UUID';
comment on column CKTS_SB_WZF_CKMX.lcslid
  is '分流LCSLID';
comment on column CKTS_SB_WZF_CKMX.tsswjg_dm
  is '退税税务机关代码';
comment on column CKTS_SB_WZF_CKMX.djxh
  is '登记序号';
comment on column CKTS_SB_WZF_CKMX.ssq
  is '所属期';
comment on column CKTS_SB_WZF_CKMX.sbpc
  is '申报批次';
comment on column CKTS_SB_WZF_CKMX.sbxh
  is '申报序号';
comment on column CKTS_SB_WZF_CKMX.wtdbtsscqynsrsbh
  is '委托代办退税生产企业纳税人识别号';
comment on column CKTS_SB_WZF_CKMX.ckbgdh
  is '出口报关单号';
comment on column CKTS_SB_WZF_CKMX.ckrq_1
  is '出口日期';
comment on column CKTS_SB_WZF_CKMX.cksp_dm
  is '出口商品代码';
comment on column CKTS_SB_WZF_CKMX.hgspmc
  is '海关商品名称';
comment on column CKTS_SB_WZF_CKMX.hgjldwmc
  is '海关计量单位名称';
comment on column CKTS_SB_WZF_CKMX.cksl
  is '出口数量';
comment on column CKTS_SB_WZF_CKMX.mylaj
  is '美元离岸价';
comment on column CKTS_SB_WZF_CKMX.dbtswspzhm
  is '代办退税完税凭证号码';
comment on column CKTS_SB_WZF_CKMX.kprq
  is '开票日期';
comment on column CKTS_SB_WZF_CKMX.jsje
  is '计税金额';
comment on column CKTS_SB_WZF_CKMX.zssl
  is '征税税率';
comment on column CKTS_SB_WZF_CKMX.tsl
  is '退税率';
comment on column CKTS_SB_WZF_CKMX.tse
  is '退税额';
comment on column CKTS_SB_WZF_CKMX.cktmsywlxdmjh
  is '出口退（免）税业务类型代码集合';
comment on column CKTS_SB_WZF_CKMX.cktmsywlxmcjh
  is '出口退（免）税业务类型名称集合';
comment on column CKTS_SB_WZF_CKMX.dbtsywlx_dm
  is '代办退税业务类型代码';
comment on column CKTS_SB_WZF_CKMX.dbtsywlxmc
  is '代办退税业务类型名称';
comment on column CKTS_SB_WZF_CKMX.chbz
  is '撤回标志';
comment on column CKTS_SB_WZF_CKMX.bytsbz
  is '不予退税标志';
comment on column CKTS_SB_WZF_CKMX.byblbz
  is '不予办理标志';
comment on column CKTS_SB_WZF_CKMX.lcslid_sb
  is '申报LCSLID';
comment on column CKTS_SB_WZF_CKMX.sjly
  is '1-GC表  2-JG表';
comment on column CKTS_SB_WZF_CKMX.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_WZF_CKMX.sbrq
  is '申报日期';
comment on column CKTS_SB_WZF_CKMX.mtsbz
  is '免退税标志';
comment on column CKTS_SB_WZF_CKMX.zbblbz
  is '暂不办理标志';
comment on column CKTS_SB_WZF_CKMX.zzjczbblzyny
  is '最终解除暂不办理年月';
comment on column CKTS_SB_WZF_CKMX.xgrq
  is '修改日期NVL(T.XGRQ,T.LRRQ)-增量用';
comment on column CKTS_SB_WZF_CKMX.sjtb_bz
  is '错误继续标志';
comment on column CKTS_SB_WZF_CKMX.fsrq
  is '复审日期';
create index IDX_CKTS_SB_WZF_CKMX_DC on CKTS_SB_WZF_CKMX (DJXH, CKBGDH)
  nologging;
create index IDX_CKTS_SB_WZF_CKMX_DSSS on CKTS_SB_WZF_CKMX (DJXH, SSQ, SBPC, SBXH)
  nologging;
create index IDX_CKTS_SB_WZF_CKMX_LCSLID on CKTS_SB_WZF_CKMX (LCSLID)
  nologging;
create index IDX_CKTS_SB_WZF_CKMX_LCSLID_SB on CKTS_SB_WZF_CKMX (LCSLID_SB)
  nologging;
create index IDX_CKTS_SB_WZF_CKMX_SC on CKTS_SB_WZF_CKMX (SBRQ, CKSP_DM)
  nologging;
create index IDX_CKTS_SB_WZF_CKMX_SJ on CKTS_SB_WZF_CKMX (SJTB_SJ);
create index IDX_CKTS_SB_WZF_CKMX_TF on CKTS_SB_WZF_CKMX (TSSWJG_DM, FSRQ)
  nologging;
alter table CKTS_SB_WZF_CKMX
  add constraint PK_CKTS_SB_WZF_CKMX primary key (UUID);
alter index PK_CKTS_SB_WZF_CKMX nologging;

prompt
prompt Creating table CKTS_SB_YS_SBMX
prompt ==============================
prompt
create table CKTS_SB_YS_SBMX
(
  uuid        VARCHAR2(32) not null,
  lcslid      CHAR(32),
  tsswjg_dm   CHAR(11),
  djxh        NUMBER(20),
  ssq         VARCHAR2(60),
  sbpc        VARCHAR2(75),
  sbxh        VARCHAR2(50),
  ckbgdh      VARCHAR2(21),
  dlckhwzmhm  VARCHAR2(20),
  ckrq_1      DATE,
  cksp_dm     VARCHAR2(20),
  sbhgspmc    VARCHAR2(500),
  ysygdsbmc   VARCHAR2(500),
  ysygdsbpzhm VARCHAR2(40),
  kprq        DATE,
  jsje        NUMBER(18,2),
  zssl        NUMBER(16,6),
  se          NUMBER(18,6),
  sbyz        NUMBER(18,2),
  ysynx       NUMBER(16,4),
  ytljzje     NUMBER(18,2),
  sbzyjz      NUMBER(18,2),
  tsl         NUMBER(16,6),
  tse         NUMBER(18,6),
  chbz        CHAR(1) default 'N',
  bytsbz      CHAR(1),
  byblbz      CHAR(1),
  sjly        CHAR(1),
  sjtb_sj     TIMESTAMP(6),
  sbrq        DATE,
  xgrq        DATE,
  sjtb_bz     CHAR(1) default '0',
  zbblbz      CHAR(1) default 'N'
)
;
comment on table CKTS_SB_YS_SBMX
  is '出口已使用过的设备退税申报表';
comment on column CKTS_SB_YS_SBMX.uuid
  is 'UUID';
comment on column CKTS_SB_YS_SBMX.lcslid
  is '分流LCSLID';
comment on column CKTS_SB_YS_SBMX.tsswjg_dm
  is '退税税务机关代码';
comment on column CKTS_SB_YS_SBMX.djxh
  is '登记序号';
comment on column CKTS_SB_YS_SBMX.ssq
  is '所属期';
comment on column CKTS_SB_YS_SBMX.sbpc
  is '申报批次';
comment on column CKTS_SB_YS_SBMX.sbxh
  is '申报序号';
comment on column CKTS_SB_YS_SBMX.ckbgdh
  is '出口报关单号';
comment on column CKTS_SB_YS_SBMX.dlckhwzmhm
  is '代理出口货物证明号码';
comment on column CKTS_SB_YS_SBMX.ckrq_1
  is '出口日期';
comment on column CKTS_SB_YS_SBMX.cksp_dm
  is '出口商品代码';
comment on column CKTS_SB_YS_SBMX.sbhgspmc
  is '申报海关商品名称||申报海关商品名称';
comment on column CKTS_SB_YS_SBMX.ysygdsbmc
  is '已使用过的设备名称';
comment on column CKTS_SB_YS_SBMX.ysygdsbpzhm
  is '已使用过的设备凭证号码';
comment on column CKTS_SB_YS_SBMX.kprq
  is '开票日期';
comment on column CKTS_SB_YS_SBMX.jsje
  is '计税金额';
comment on column CKTS_SB_YS_SBMX.zssl
  is '征税税率';
comment on column CKTS_SB_YS_SBMX.se
  is '税额';
comment on column CKTS_SB_YS_SBMX.sbyz
  is '设备原值';
comment on column CKTS_SB_YS_SBMX.ysynx
  is '已使用年限';
comment on column CKTS_SB_YS_SBMX.ytljzje
  is '已提累计折旧额';
comment on column CKTS_SB_YS_SBMX.sbzyjz
  is '设备折余价值';
comment on column CKTS_SB_YS_SBMX.tsl
  is '退税率';
comment on column CKTS_SB_YS_SBMX.tse
  is '退税额';
comment on column CKTS_SB_YS_SBMX.chbz
  is '撤回标志';
comment on column CKTS_SB_YS_SBMX.bytsbz
  is '不予退税标志';
comment on column CKTS_SB_YS_SBMX.byblbz
  is '不予办理标志';
comment on column CKTS_SB_YS_SBMX.sjly
  is '1-GC表  2-JG表';
comment on column CKTS_SB_YS_SBMX.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_YS_SBMX.sbrq
  is '申报日期';
comment on column CKTS_SB_YS_SBMX.xgrq
  is '修改日期NVL(T.XGRQ,T.LRRQ)-增量用';
comment on column CKTS_SB_YS_SBMX.sjtb_bz
  is '错误继续标志';
comment on column CKTS_SB_YS_SBMX.zbblbz
  is '暂不办理标志';
create index IDX_CKTS_SB_YS_SBMX_DC on CKTS_SB_YS_SBMX (DJXH, CKBGDH);
create index IDX_CKTS_SB_YS_SBMX_DSSS on CKTS_SB_YS_SBMX (DJXH, SSQ, SBPC, SBXH);
create index IDX_CKTS_SB_YS_SBMX_LCSLID on CKTS_SB_YS_SBMX (LCSLID);
alter table CKTS_SB_YS_SBMX
  add constraint PK_CKTS_SB_YS_SBMX primary key (UUID);

prompt
prompt Creating table CKTS_TY_KJDSHWC_HSTZ
prompt ===================================
prompt
create table CKTS_TY_KJDSHWC_HSTZ
(
  uuid            VARCHAR2(32) not null,
  lcswsx_dm       VARCHAR2(16),
  djxh            NUMBER(20),
  ytslcslid       VARCHAR2(32),
  ytssbny         CHAR(6),
  ytsglh          VARCHAR2(30),
  ytssbpc         VARCHAR2(75),
  ytssbxh         VARCHAR2(50),
  ckbgdh          VARCHAR2(21),
  dlckhwzmhm      VARCHAR2(20),
  ckrq_1          DATE,
  ytssz           VARCHAR2(45),
  zzstse          NUMBER(18,6) default 0,
  xfstse          NUMBER(18,6) default 0,
  ytsblsj         DATE,
  sfyhsbz         CHAR(1) default 'N',
  schsrq          DATE,
  ckhwcytshslx_dm CHAR(2),
  zxhsrq          DATE,
  zxhssjlcslid    VARCHAR2(32),
  sfczcjsbbz      CHAR(1) default 'N',
  sfczzhxxbz      CHAR(1) default 'N',
  zxcjsjlcslid    VARCHAR2(32),
  zxzhsjlcslid    VARCHAR2(32),
  cqwhsfhbz       CHAR(1) default 'N',
  cqwhsfhlcslid   VARCHAR2(32),
  cqwhsfhr        VARCHAR2(300),
  cqwhsfhrq       DATE,
  hsycfhbz        CHAR(1) default 'N',
  hsycfhlcslid    VARCHAR2(32),
  hsycfhr         VARCHAR2(300),
  hsycfhrq        DATE,
  lrr_dm          CHAR(11) not null,
  lrrq            DATE not null,
  xgr_dm          CHAR(11),
  xgrq            DATE,
  sjgsdq          CHAR(11) not null,
  sjtb_sj         TIMESTAMP(6),
  sjgxsj          DATE,
  zfbz_1          CHAR(1) default 'N',
  ytsslrq         DATE,
  zxhsssq         CHAR(6),
  zxhspc          VARCHAR2(75),
  tsswjg_dm_1     CHAR(11),
  ytshsjzr_1      CHAR(6)
)
;
comment on table CKTS_TY_KJDSHWC_HSTZ
  is '跨境电商出口海外仓预退税核算管理台账表';
comment on column CKTS_TY_KJDSHWC_HSTZ.uuid
  is 'UUID||uuid';
comment on column CKTS_TY_KJDSHWC_HSTZ.lcswsx_dm
  is '流程税务事项代码';
comment on column CKTS_TY_KJDSHWC_HSTZ.djxh
  is '登记序号';
comment on column CKTS_TY_KJDSHWC_HSTZ.ytslcslid
  is '预退税流程实例ID';
comment on column CKTS_TY_KJDSHWC_HSTZ.ytssbny
  is '预退税申报年月';
comment on column CKTS_TY_KJDSHWC_HSTZ.ytsglh
  is '预退税关联号';
comment on column CKTS_TY_KJDSHWC_HSTZ.ytssbpc
  is '预退税申报批次';
comment on column CKTS_TY_KJDSHWC_HSTZ.ytssbxh
  is '预退税申报序号';
comment on column CKTS_TY_KJDSHWC_HSTZ.ckbgdh
  is '出口报关单号';
comment on column CKTS_TY_KJDSHWC_HSTZ.dlckhwzmhm
  is '代理出口货物证明号码';
comment on column CKTS_TY_KJDSHWC_HSTZ.ckrq_1
  is '出口日期';
comment on column CKTS_TY_KJDSHWC_HSTZ.ytssz
  is '预退税税种';
comment on column CKTS_TY_KJDSHWC_HSTZ.zzstse
  is '增值税退税额';
comment on column CKTS_TY_KJDSHWC_HSTZ.xfstse
  is '消费税退税额';
comment on column CKTS_TY_KJDSHWC_HSTZ.ytsblsj
  is '预退税办理时间';
comment on column CKTS_TY_KJDSHWC_HSTZ.sfyhsbz
  is '是否已核算标志';
comment on column CKTS_TY_KJDSHWC_HSTZ.schsrq
  is '首次核算日期';
comment on column CKTS_TY_KJDSHWC_HSTZ.ckhwcytshslx_dm
  is '出口海外仓预退税核算类型代码';
comment on column CKTS_TY_KJDSHWC_HSTZ.zxhsrq
  is '最新核算日期';
comment on column CKTS_TY_KJDSHWC_HSTZ.zxhssjlcslid
  is '最新核算数据LCSLID';
comment on column CKTS_TY_KJDSHWC_HSTZ.sfczcjsbbz
  is '是否存在冲减申报标志';
comment on column CKTS_TY_KJDSHWC_HSTZ.sfczzhxxbz
  is '是否存在追回信息标志';
comment on column CKTS_TY_KJDSHWC_HSTZ.zxcjsjlcslid
  is '最新冲减数据LCSLID';
comment on column CKTS_TY_KJDSHWC_HSTZ.zxzhsjlcslid
  is '最新追回数据LCSLID';
comment on column CKTS_TY_KJDSHWC_HSTZ.cqwhsfhbz
  is '超期未核算复核标志';
comment on column CKTS_TY_KJDSHWC_HSTZ.cqwhsfhlcslid
  is '超期未核算复核流程实例ID';
comment on column CKTS_TY_KJDSHWC_HSTZ.cqwhsfhr
  is '超期未核算复核人';
comment on column CKTS_TY_KJDSHWC_HSTZ.cqwhsfhrq
  is '超期未核算复核日期';
comment on column CKTS_TY_KJDSHWC_HSTZ.hsycfhbz
  is '核算异常复核标志';
comment on column CKTS_TY_KJDSHWC_HSTZ.hsycfhlcslid
  is '核算异常复核流程实例ID';
comment on column CKTS_TY_KJDSHWC_HSTZ.hsycfhr
  is '核算异常复核人';
comment on column CKTS_TY_KJDSHWC_HSTZ.hsycfhrq
  is '核算异常复核日期';
comment on column CKTS_TY_KJDSHWC_HSTZ.lrr_dm
  is '录入人代码';
comment on column CKTS_TY_KJDSHWC_HSTZ.lrrq
  is '录入日期';
comment on column CKTS_TY_KJDSHWC_HSTZ.xgr_dm
  is '修改人代码';
comment on column CKTS_TY_KJDSHWC_HSTZ.xgrq
  is '修改日期';
comment on column CKTS_TY_KJDSHWC_HSTZ.sjgsdq
  is '数据归属地区';
comment on column CKTS_TY_KJDSHWC_HSTZ.sjtb_sj
  is '数据同步时间';
comment on column CKTS_TY_KJDSHWC_HSTZ.sjgxsj
  is '数据更新时间';
comment on column CKTS_TY_KJDSHWC_HSTZ.zfbz_1
  is '作废标志';
comment on column CKTS_TY_KJDSHWC_HSTZ.ytsslrq
  is '预退税受理日期';
comment on column CKTS_TY_KJDSHWC_HSTZ.zxhsssq
  is '最新核算所属期';
comment on column CKTS_TY_KJDSHWC_HSTZ.zxhspc
  is '最新核算批次';
comment on column CKTS_TY_KJDSHWC_HSTZ.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_TY_KJDSHWC_HSTZ.ytshsjzr_1
  is '预退税核算截止日';
create index IDX_CKTS_TY_KJDSHWC_HSTZ_CD on CKTS_TY_KJDSHWC_HSTZ (DJXH, ZXCJSJLCSLID);
create index IDX_CKTS_TY_KJDSHWC_HSTZ_DCH on CKTS_TY_KJDSHWC_HSTZ (DJXH, CQWHSFHBZ, HSYCFHBZ);
create index IDX_CKTS_TY_KJDSHWC_HSTZ_DS on CKTS_TY_KJDSHWC_HSTZ (DJXH, SFYHSBZ);
create index IDX_CKTS_TY_KJDSHWC_HSTZ_DSPG on CKTS_TY_KJDSHWC_HSTZ (LCSWSX_DM, YTSSBNY, NVL(YTSGLH,'2'), NVL(YTSSBPC,'1'), YTSSBXH);
create index IDX_CKTS_TY_KJDSHWC_HSTZ_DY on CKTS_TY_KJDSHWC_HSTZ (DJXH, TO_CHAR(YTSBLSJ,'YYYYMM'));
create index IDX_CKTS_TY_KJDSHWC_HSTZ_L on CKTS_TY_KJDSHWC_HSTZ (YTSLCSLID);
alter table CKTS_TY_KJDSHWC_HSTZ
  add constraint PK_CKTS_TY_KJDSHWC_HSTZ primary key (UUID);

prompt
prompt Creating table CKTS_WBSJ_BGD_9X10
prompt =================================
prompt
create table CKTS_WBSJ_BGD_9X10
(
  uuid          VARCHAR2(32) not null,
  lcslid        CHAR(32),
  tsswjg_dm     CHAR(11),
  djxh          NUMBER(20),
  sbywb_dm      VARCHAR2(10),
  ssq           VARCHAR2(60),
  sbpc          VARCHAR2(75) default '001',
  sbxh          VARCHAR2(50),
  ckbgdh        VARCHAR2(21),
  ckrq_1        DATE,
  cksp_dm       VARCHAR2(20),
  tdcode        VARCHAR2(4),
  mylaj         NUMBER(18,2),
  mdtse         NUMBER(18,6),
  zytsbz        CHAR(1),
  sbrq          DATE,
  fsrq          DATE,
  cktmsywlxdmjh VARCHAR2(30),
  tse           NUMBER(18,6),
  sjly          CHAR(1),
  sjtb_sj       TIMESTAMP(6)
)
;
comment on column CKTS_WBSJ_BGD_9X10.uuid
  is 'UUID';
comment on column CKTS_WBSJ_BGD_9X10.lcslid
  is 'LCSLID';
comment on column CKTS_WBSJ_BGD_9X10.tsswjg_dm
  is '退税税务机关代码';
comment on column CKTS_WBSJ_BGD_9X10.djxh
  is '登记序号';
comment on column CKTS_WBSJ_BGD_9X10.sbywb_dm
  is '申报业务表代码';
comment on column CKTS_WBSJ_BGD_9X10.ssq
  is '所属期';
comment on column CKTS_WBSJ_BGD_9X10.sbpc
  is '申报批次';
comment on column CKTS_WBSJ_BGD_9X10.sbxh
  is '申报序号';
comment on column CKTS_WBSJ_BGD_9X10.ckbgdh
  is '出口报关单号';
comment on column CKTS_WBSJ_BGD_9X10.ckrq_1
  is '出口日期';
comment on column CKTS_WBSJ_BGD_9X10.cksp_dm
  is '出口商品代码';
comment on column CKTS_WBSJ_BGD_9X10.tdcode
  is '海关监管方式';
comment on column CKTS_WBSJ_BGD_9X10.mylaj
  is '美元离岸价';
comment on column CKTS_WBSJ_BGD_9X10.mdtse
  is '生产企业免抵退税额/外贸企业退税额';
comment on column CKTS_WBSJ_BGD_9X10.zytsbz
  is '准予退税标志';
comment on column CKTS_WBSJ_BGD_9X10.sbrq
  is '申报日期';
comment on column CKTS_WBSJ_BGD_9X10.fsrq
  is '复审日期';
comment on column CKTS_WBSJ_BGD_9X10.cktmsywlxdmjh
  is '业务代码';
comment on column CKTS_WBSJ_BGD_9X10.tse
  is '退税额';
comment on column CKTS_WBSJ_BGD_9X10.sjly
  is '1-GC表  2-JG表';
comment on column CKTS_WBSJ_BGD_9X10.sjtb_sj
  is '数据同步时间';
create index IDX_CKTS_WBSJ_BGD_9X10_DJXH on CKTS_WBSJ_BGD_9X10 (DJXH)
  nologging;
create index IDX_CKTS_WBSJ_BGD_9X10_LCSLID on CKTS_WBSJ_BGD_9X10 (LCSLID)
  nologging;
create index IDX_CKTS_WBSJ_BGD_9X10_TST on CKTS_WBSJ_BGD_9X10 (TSSWJG_DM, SBRQ, TDCODE)
  nologging;
alter table CKTS_WBSJ_BGD_9X10
  add constraint PKEY_CKTS_WBSJ_BGD_9X10 primary key (UUID);
alter index PKEY_CKTS_WBSJ_BGD_9X10 nologging;

prompt
prompt Creating table CKTS_WBSJ_BGD_WSB
prompt ================================
prompt
create table CKTS_WBSJ_BGD_WSB
(
  uuid      VARCHAR2(32),
  tsswjg_dm CHAR(11),
  djxh      NUMBER(20) not null,
  ckbgdh    VARCHAR2(21) not null,
  ckrq_1    DATE,
  cksp_dm   VARCHAR2(20),
  jgfs_dm   CHAR(4),
  rmblaj    NUMBER(18,2),
  mylaj     NUMBER(18,2),
  bah       VARCHAR2(12)
)
;
alter table CKTS_WBSJ_BGD_WSB
  add constraint PK_CKTS_WBSJ_WSBBGD primary key (DJXH, CKBGDH);

prompt
prompt Creating table CKTS_WBSJ_HG_BGD
prompt ===============================
prompt
create table CKTS_WBSJ_HG_BGD
(
  uuid               VARCHAR2(32),
  djxh               NUMBER(20) not null,
  tsswjg_dm_1        CHAR(11),
  ckny               CHAR(6),
  yhggqka_dm         CHAR(4),
  hggqka_dm          CHAR(4),
  ckbgdh             VARCHAR2(21) not null,
  bsm                VARCHAR2(21),
  hzdwdq_dm          CHAR(5),
  hxdh               VARCHAR2(30),
  ckrq_1             DATE,
  ycksp_dm           VARCHAR2(20),
  cksp_dm            VARCHAR2(20),
  ckspmc             VARCHAR2(75),
  hgjldwmc           VARCHAR2(75),
  mygdqsz_dm         CHAR(3),
  yjgfs_dm           CHAR(4),
  jgfs_dm            CHAR(4),
  ydyjldw_dm         VARCHAR2(3),
  dyjldw_dm          VARCHAR2(3),
  ydejldw_dm         VARCHAR2(3),
  dejldw_dm          VARCHAR2(3),
  cksl               NUMBER(16,4),
  decksl             NUMBER(16,4),
  rmblaj             NUMBER(18,2),
  mylaj              NUMBER(18,2),
  cjhghbsz_dm        CHAR(3),
  cjzj               NUMBER(18,2),
  jydwmc             VARCHAR2(300),
  ysfs_dm            CHAR(1),
  tydh               VARCHAR2(32),
  zmxz_dm            CHAR(3),
  jhfs_dm            CHAR(1),
  xkzh               VARCHAR2(20),
  zyg_dm             VARCHAR2(6),
  hgcjfs_dm          CHAR(1),
  yfjsfs_dm          CHAR(1),
  yfhghbsz_dm        CHAR(3),
  yfhl               NUMBER(16,6),
  bfjsfs_dm          CHAR(1),
  bfhghbsz_dm        CHAR(3),
  bfhl               NUMBER(16,6),
  zfjsfs_dm          CHAR(1),
  zfhghbsz_dm        CHAR(3),
  zfhl               NUMBER(16,6),
  bah                VARCHAR2(12),
  sbdwdm             VARCHAR2(50),
  sbdwmc             VARCHAR2(300),
  hzdwmc             VARCHAR2(300),
  ggxh               VARCHAR2(150),
  zzmdgdqsz_dm       CHAR(3),
  sbjldw_dm          VARCHAR2(3),
  sbsl_1             NUMBER(16,4),
  sbdj               NUMBER(18,2),
  tsl                NUMBER(16,6),
  cytssbjl           VARCHAR2(60),
  ysgjmc             VARCHAR2(500),
  bytsbz             CHAR(1),
  hch                VARCHAR2(32),
  hzdwdm             VARCHAR2(50),
  hgbzzl_dm          VARCHAR2(2),
  js_1               NUMBER(10),
  mz_2               NUMBER(18,6),
  jz                 NUMBER(18,6),
  lxbz               VARCHAR2(32),
  tssbsl             NUMBER(16,4),
  tssbrmblaj         NUMBER(18,2),
  tssbmylaj          NUMBER(18,2),
  tysl               NUMBER(16,4),
  tyrmblaj           NUMBER(18,2),
  tymylaj            NUMBER(18,2),
  dlsbsl             NUMBER(16,4),
  dlsbrmblaj         NUMBER(18,2),
  dlsbmylaj          NUMBER(18,2),
  hgspmc             VARCHAR2(500),
  gfhhgspmc          VARCHAR2(500),
  hgqy_dm            VARCHAR2(50),
  sjgxsj             DATE,
  rkrq               DATE,
  sjzxtybh           VARCHAR2(20),
  qygbz              CHAR(1),
  kjdlckhwzmbz       CHAR(1),
  kjckhwtyybswtszmbz CHAR(1),
  lrr_dm             CHAR(11) not null,
  lrrq               DATE not null,
  xgr_dm             CHAR(11),
  xgrq               DATE,
  sjgsdq             CHAR(11) not null,
  sjtb_sj            TIMESTAMP(6),
  hgckhwbgdsbrq      DATE,
  qygzcjgbz          CHAR(1),
  qygwddbz           CHAR(1),
  qygcxckbz          CHAR(1),
  qyrq_2             DATE,
  ckhth              VARCHAR2(60),
  gdbz_1             CHAR(1) default 'N',
  hydxzqh_dm         CHAR(4),
  zmtbz              CHAR(1)
)
;
comment on column CKTS_WBSJ_HG_BGD.zmtbz
  is '征免退标志';
create index IDX_CKTS_WBSJ_HG_BGD_CGC on CKTS_WBSJ_HG_BGD (CKSP_DM, GFHHGSPMC, CKNY)
  nologging;
create index IDX_CKTS_WBSJ_HG_BGD_CKSP on CKTS_WBSJ_HG_BGD (CKSP_DM, TSSWJG_DM_1)
  nologging;
create index IDX_CKTS_WBSJ_HG_BGD_DC on CKTS_WBSJ_HG_BGD (DJXH, CKRQ_1)
  nologging;
create index IDX_CKTS_WBSJ_HG_BGD_DS on CKTS_WBSJ_HG_BGD (DJXH, HGCKHWBGDSBRQ, JGFS_DM)
  nologging;
create index IDX_CKTS_WBSJ_HG_BGD_SJTBSJ on CKTS_WBSJ_HG_BGD (SJTB_SJ)
  nologging;
create index IDX_CKTS_WBSJ_HG_BGD_TJC on CKTS_WBSJ_HG_BGD (TSSWJG_DM_1, CKRQ_1, JGFS_DM)
  nologging;
alter table CKTS_WBSJ_HG_BGD
  add constraint PK_CKTS_WBSJ_HG_BGD primary key (CKBGDH, DJXH);

prompt
prompt Creating table CKTS_WBSJ_HG_BGD204
prompt ==================================
prompt
create table CKTS_WBSJ_HG_BGD204
(
  uuid        VARCHAR2(32) not null,
  djxh        NUMBER(20),
  tsswjg_dm_1 CHAR(11),
  jzxh        VARCHAR2(32),
  bjmmjbz     VARCHAR2(500),
  sjtb_sj     TIMESTAMP(6),
  bgdhgbh     VARCHAR2(30) not null,
  ckrq_1      DATE,
  tbrq        DATE,
  tbbz        CHAR(1)
)
;
comment on table CKTS_WBSJ_HG_BGD204
  is '海关出口货物报关单204';
comment on column CKTS_WBSJ_HG_BGD204.uuid
  is 'UUID||uuid';
comment on column CKTS_WBSJ_HG_BGD204.djxh
  is '登记序号';
comment on column CKTS_WBSJ_HG_BGD204.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_WBSJ_HG_BGD204.jzxh
  is '集装箱号';
comment on column CKTS_WBSJ_HG_BGD204.bjmmjbz
  is '标记唛码及备注';
comment on column CKTS_WBSJ_HG_BGD204.sjtb_sj
  is '数据同步时间';
comment on column CKTS_WBSJ_HG_BGD204.bgdhgbh
  is '报关单海关编号';
comment on column CKTS_WBSJ_HG_BGD204.ckrq_1
  is '出口日期';
comment on column CKTS_WBSJ_HG_BGD204.tbrq
  is '同步日期';
comment on column CKTS_WBSJ_HG_BGD204.tbbz
  is '同步标志';
create index IDX_CKTS_WBSJ_HG_BGD204_B on CKTS_WBSJ_HG_BGD204 (BGDHGBH)
  nologging;
create index IDX_CKTS_WBSJ_HG_BGD204_DC on CKTS_WBSJ_HG_BGD204 (DJXH, CKRQ_1)
  nologging;
create index IDX_CKTS_WBSJ_HG_BGD204_JC on CKTS_WBSJ_HG_BGD204 (JZXH, CKRQ_1)
  nologging;
alter table CKTS_WBSJ_HG_BGD204
  add constraint PK_CKTS_WBSJ_HG_BGD204 primary key (UUID);
alter index PK_CKTS_WBSJ_HG_BGD204 nologging;

prompt
prompt Creating table CKTS_WBSJ_ZJ_DLCKHWZM
prompt ====================================
prompt
create table CKTS_WBSJ_ZJ_DLCKHWZM
(
  uuid          VARCHAR2(32) not null,
  dlckhwzmhm    VARCHAR2(20),
  rq            DATE,
  djxh          NUMBER(20),
  wtfnsrsbh     VARCHAR2(20) not null,
  wtfnsrmc      VARCHAR2(300),
  wtfhgqydm     VARCHAR2(50),
  stfmc         VARCHAR2(300),
  stfnsrsbh     VARCHAR2(20),
  stfshxydm     VARCHAR2(20),
  ckbgdh        VARCHAR2(21),
  ckrq_1        DATE,
  ckshhxdh      VARCHAR2(30),
  cksp_dm       VARCHAR2(20),
  ckspmc        VARCHAR2(300),
  hgjldwmc      VARCHAR2(75),
  cksl          NUMBER(16,4),
  mylaj         NUMBER(18,2),
  wtdlckhth     VARCHAR2(60),
  ssq           VARCHAR2(60),
  tsswjg_dm_1   CHAR(11),
  cytssbjl      VARCHAR2(60),
  hbzm_dm       CHAR(3),
  ybje          NUMBER(18,2),
  jgfs_dm       CHAR(4),
  lcslid        CHAR(32),
  bytsbz        CHAR(1),
  bah           VARCHAR2(12),
  bfhghbsz_dm   CHAR(3),
  bfhl          NUMBER(16,6),
  bfjsfs_dm     CHAR(1),
  decksl        NUMBER(16,4),
  hgbzzl_dm     VARCHAR2(2),
  cjhghbsz_dm   CHAR(3),
  hgcjfs_dm     CHAR(1),
  cjzj          NUMBER(18,2),
  dyjldw_dm     VARCHAR2(3),
  dejldw_dm     VARCHAR2(3),
  mygdqsz_dm    CHAR(3),
  hch           VARCHAR2(32),
  hgspmc        VARCHAR2(500),
  hggqka_dm     CHAR(4),
  ckhth         VARCHAR2(60),
  jnhyd_dm      CHAR(5),
  hzdwmc        VARCHAR2(300),
  hzdwdm        VARCHAR2(50),
  jhfs_dm       CHAR(1),
  js_1          NUMBER(10),
  jydwmc        VARCHAR2(300),
  jz            NUMBER(18,6),
  lxbz          VARCHAR2(32),
  mz_2          NUMBER(18,6),
  rmblaj        NUMBER(18,2),
  sbdwdm        VARCHAR2(50),
  sbdwmc        VARCHAR2(300),
  sbjldw_dm     VARCHAR2(3),
  hgckhwbgdsbrq DATE,
  sbdj          NUMBER(18,2),
  sbsl_1        NUMBER(16,4),
  ggxh          VARCHAR2(150),
  ysgjmc        VARCHAR2(500),
  tssbsl        NUMBER(16,4),
  tssbrmblaj    NUMBER(18,2),
  tssbmylaj     NUMBER(18,2),
  tydh          VARCHAR2(32),
  tysl          NUMBER(16,4),
  tyrmblaj      NUMBER(18,2),
  tymylaj       NUMBER(18,2),
  xkzh          VARCHAR2(20),
  yfhghbsz_dm   CHAR(3),
  yfhl          NUMBER(16,6),
  yfjsfs_dm     CHAR(1),
  ysfs_dm       CHAR(1),
  zfhghbsz_dm   CHAR(3),
  zfhl          NUMBER(16,6),
  zfjsfs_dm     CHAR(1),
  zyg_dm        VARCHAR2(6),
  zzmdgdqsz_dm  CHAR(3),
  bz            VARCHAR2(3000),
  cjzmrq        DATE,
  gfhhgspmc     VARCHAR2(500),
  sjgxsj        DATE,
  rkrq          DATE,
  lrr_dm        CHAR(11) not null,
  lrrq          DATE not null,
  xgr_dm        CHAR(11),
  xgrq          DATE,
  sjgsdq        CHAR(11) not null,
  sjtb_sj       TIMESTAMP(6),
  dbtsbz_1      CHAR(1),
  stfhgqydm     VARCHAR2(50),
  sjly          VARCHAR2(1500),
  qklbbh        VARCHAR2(75)
)
;
comment on table CKTS_WBSJ_ZJ_DLCKHWZM
  is '总局代理出口货物证明';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.uuid
  is 'UUID||uuid';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.dlckhwzmhm
  is '代理出口货物证明号码';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.rq
  is '日期';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.djxh
  is '登记序号';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.wtfnsrsbh
  is '委托方纳税人识别号';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.wtfnsrmc
  is '委托方纳税人名称';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.wtfhgqydm
  is '委托方海关企业代码';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.stfmc
  is '受托方名称';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.stfnsrsbh
  is '受托方纳税人识别号';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.stfshxydm
  is '受托方社会信用代码';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.ckbgdh
  is '出口报关单号';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.ckrq_1
  is '出口日期';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.ckshhxdh
  is '出口收汇核销单号';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.cksp_dm
  is '出口商品代码';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.ckspmc
  is '出口商品名称';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.hgjldwmc
  is '海关计量单位名称';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.cksl
  is '出口数量';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.mylaj
  is '美元离岸价';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.wtdlckhth
  is '委托（代理）出口合同号';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.ssq
  is '所属期';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.cytssbjl
  is '参与退税申报记录';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.hbzm_dm
  is '货币字母代码';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.ybje
  is '原币金额';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.jgfs_dm
  is '监管方式代码';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.lcslid
  is '流程实例ID';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.bytsbz
  is '不予退税标志';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.bah
  is '备案号';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.bfhghbsz_dm
  is '保费海关货币数字代码';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.bfhl
  is '保费汇率';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.bfjsfs_dm
  is '保费计算方式代码';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.decksl
  is '第二出口数量';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.hgbzzl_dm
  is '海关包装种类代码';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.cjhghbsz_dm
  is '成交海关货币数字代码';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.hgcjfs_dm
  is '海关成交方式代码';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.cjzj
  is '成交总价||成交总价';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.dyjldw_dm
  is '第一计量单位代码';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.dejldw_dm
  is '第二计量单位代码';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.mygdqsz_dm
  is '贸易国（地区）数字代码';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.hch
  is '航次号';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.hgspmc
  is '海关商品名称';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.hggqka_dm
  is '海关关区（口岸）代码';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.ckhth
  is '出口合同号';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.jnhyd_dm
  is '境内货源地代码';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.hzdwmc
  is '货主单位名称';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.hzdwdm
  is '货主单位代码';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.jhfs_dm
  is '结汇方式代码';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.js_1
  is '件数';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.jydwmc
  is '经营单位名称';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.jz
  is '净重';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.lxbz
  is '类型备注';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.mz_2
  is '毛重';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.rmblaj
  is '人民币离岸价';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.sbdwdm
  is '申报单位代码';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.sbdwmc
  is '申报单位名称';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.sbjldw_dm
  is '申报计量单位代码';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.hgckhwbgdsbrq
  is '海关出口货物报关单申报日期';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.sbdj
  is '申报单价';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.sbsl_1
  is '申报数量';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.ggxh
  is '规格型号';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.ysgjmc
  is '运输工具名称';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.tssbsl
  is '退税申报数量';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.tssbrmblaj
  is '退税申报人民币离岸价';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.tssbmylaj
  is '退税申报美元离岸价';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.tydh
  is '提运单号';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.tysl
  is '退运数量';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.tyrmblaj
  is '退运人民币离岸价';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.tymylaj
  is '退运美元离岸价';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.xkzh
  is '许可证号';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.yfhghbsz_dm
  is '运费海关货币数字代码';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.yfhl
  is '运费汇率';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.yfjsfs_dm
  is '运费计算方式代码';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.ysfs_dm
  is '运输方式代码';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.zfhghbsz_dm
  is '杂费海关货币数字代码';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.zfhl
  is '杂费汇率';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.zfjsfs_dm
  is '杂费计算方式代码';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.zyg_dm
  is '指运港代码';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.zzmdgdqsz_dm
  is '最终目的国（地区）数字代码';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.bz
  is '备注';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.cjzmrq
  is '出具证明日期';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.gfhhgspmc
  is '规范化海关商品名称';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.sjgxsj
  is '数据更新时间';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.rkrq
  is '入库日期';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.lrr_dm
  is '录入人代码';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.lrrq
  is '录入日期';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.xgr_dm
  is '修改人代码';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.xgrq
  is '修改日期';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.sjgsdq
  is '数据归属地区';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.sjtb_sj
  is '数据同步时间';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.dbtsbz_1
  is '代办退税标志';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.stfhgqydm
  is '受托方海关企业代码';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.sjly
  is '数据来源||数据来源';
comment on column CKTS_WBSJ_ZJ_DLCKHWZM.qklbbh
  is '区块链版本号';
create index IDX_CKTS_WBSJ_ZJ_DLCKHWZM_DC on CKTS_WBSJ_ZJ_DLCKHWZM (DJXH, CKRQ_1)
  nologging;
create index IDX_CKTS_WBSJ_ZJ_DLCKHWZM_DD on CKTS_WBSJ_ZJ_DLCKHWZM (DJXH, DLCKHWZMHM)
  nologging;
alter table CKTS_WBSJ_ZJ_DLCKHWZM
  add constraint PK_CKTS_WBSJ_ZJ_DLCKHWZM primary key (UUID);

prompt
prompt Creating table CKTS_ZS_CKTSZB_JGB
prompt =================================
prompt
create table CKTS_ZS_CKTSZB_JGB
(
  uuid        VARCHAR2(32) not null,
  swjg_dm     CHAR(11) not null,
  skssswjg_dm CHAR(11) not null,
  jhfpnd      VARCHAR2(10) not null,
  jhxdrq      DATE,
  bnsjfpjh    NUMBER(18,6),
  bnyfpjh     NUMBER(18,6),
  bnfptsjhlj  NUMBER(18,6) not null,
  bz          VARCHAR2(3000),
  lrrq        DATE not null,
  lrr_dm      CHAR(11) not null,
  xgrq        DATE,
  xgr_dm      CHAR(11),
  sjgsdq      CHAR(11) not null,
  sjtb_sj     TIMESTAMP(6),
  yuuid       VARCHAR2(32),
  fprq        DATE,
  lcslid      CHAR(32) default '0' not null,
  ywpzuuid    VARCHAR2(32) default '0' not null,
  sjblbz      NUMBER(2) default 0
)
;
create index IDX_CKTS_ZS_CKTSZB_JGB_SJ on CKTS_ZS_CKTSZB_JGB (SKSSSWJG_DM, JHFPND)
  nologging;
alter table CKTS_ZS_CKTSZB_JGB
  add constraint PK_CKTS_ZS_CKTSZB_JGB primary key (UUID);
alter index PK_CKTS_ZS_CKTSZB_JGB nologging;

prompt
prompt Creating table CKTS_ZS_DJXHDZB
prompt ==============================
prompt
create table CKTS_ZS_DJXHDZB
(
  djxh_ck NUMBER(20) not null,
  djxh_zs NUMBER(20) not null,
  nsrmc   VARCHAR2(200)
)
;
comment on column CKTS_ZS_DJXHDZB.nsrmc
  is '纳税人名称';

prompt
prompt Creating table CKTS_ZS_MDTKB
prompt ============================
prompt
create table CKTS_ZS_MDTKB
(
  djxh        NUMBER(20),
  nsrsbh      VARCHAR2(20) not null,
  md_amt      NUMBER(18,2) not null,
  ss_ym       CHAR(6),
  lsgx_dm     CHAR(2),
  hg_dm       VARCHAR2(50),
  skssqq      DATE not null,
  skssqz      DATE not null,
  tklx        CHAR(1),
  tzlx_dm     CHAR(1) not null,
  kjtkbj      CHAR(1),
  zsswjg_dm   CHAR(11) not null,
  skssswjg_dm CHAR(11) not null,
  zgswskfj_dm CHAR(11) not null,
  lrr_dm      CHAR(11) not null,
  lrrq        DATE not null,
  xgr_dm      CHAR(11),
  xgrq        DATE,
  sjgsdq      CHAR(11) not null,
  sjtb_sj     TIMESTAMP(6),
  uuid        VARCHAR2(32) not null,
  ywlx        VARCHAR2(75),
  ckts_no     VARCHAR2(32),
  hsswjg_dm   CHAR(11),
  xhrq_1      DATE
)
;
comment on table CKTS_ZS_MDTKB
  is '征收出口退税免抵调库表，来源HX_ZS.ZS_CKTS_MDT';
comment on column CKTS_ZS_MDTKB.djxh
  is '登记序号';
comment on column CKTS_ZS_MDTKB.nsrsbh
  is '纳税人识别号';
comment on column CKTS_ZS_MDTKB.md_amt
  is '免抵额';
comment on column CKTS_ZS_MDTKB.ss_ym
  is '所属期';
comment on column CKTS_ZS_MDTKB.lsgx_dm
  is '隶属关系代码';
comment on column CKTS_ZS_MDTKB.hg_dm
  is '海关代码';
comment on column CKTS_ZS_MDTKB.skssqq
  is '税款所属期起';
comment on column CKTS_ZS_MDTKB.skssqz
  is '税款所属期止';
comment on column CKTS_ZS_MDTKB.tklx
  is '调库类型||包括：一般增值税、改征增值税';
comment on column CKTS_ZS_MDTKB.tzlx_dm
  is '调账类型代码';
comment on column CKTS_ZS_MDTKB.kjtkbj
  is '开具调库标记||Y 已开具调库通知书   N 未开具调库通知书 ';
comment on column CKTS_ZS_MDTKB.zsswjg_dm
  is '征收税务机关代码';
comment on column CKTS_ZS_MDTKB.skssswjg_dm
  is '税款所属税务机构代码';
comment on column CKTS_ZS_MDTKB.zgswskfj_dm
  is '主管税务所（科、分局）代码';
comment on column CKTS_ZS_MDTKB.lrr_dm
  is '录入人代码';
comment on column CKTS_ZS_MDTKB.lrrq
  is '录入日期';
comment on column CKTS_ZS_MDTKB.xgr_dm
  is '修改人代码';
comment on column CKTS_ZS_MDTKB.xgrq
  is '修改日期';
comment on column CKTS_ZS_MDTKB.sjgsdq
  is '数据归属地区';
comment on column CKTS_ZS_MDTKB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_ZS_MDTKB.uuid
  is 'UUID||uuid';
comment on column CKTS_ZS_MDTKB.ywlx
  is '业务类型';
comment on column CKTS_ZS_MDTKB.ckts_no
  is '出口退税编号||出口退税系统内部自动生成的编号';
comment on column CKTS_ZS_MDTKB.hsswjg_dm
  is '免抵调库税务机关代码';
comment on column CKTS_ZS_MDTKB.xhrq_1
  is '销号日期';
create index IDX_CKTS_ZS_MDTKB_DCKL on CKTS_ZS_MDTKB (DJXH, CKTS_NO, KJTKBJ, UPPER(TRIM(LRR_DM)))
  nologging;
alter table CKTS_ZS_MDTKB
  add constraint PK_CKTS_ZS_MDTKB primary key (UUID);
alter index PK_CKTS_ZS_MDTKB nologging;

prompt
prompt Creating table CKTS_ZS_SRTHS
prompt ============================
prompt
create table CKTS_ZS_SRTHS
(
  srthsuuid   VARCHAR2(32) not null,
  dzsphm      NUMBER(20) not null,
  dzspmxxh    NUMBER(8) not null,
  gldzspmxxh  NUMBER(8),
  ydtuuid     VARCHAR2(32) not null,
  djxh        NUMBER(20) not null,
  zrrsbh      VARCHAR2(20),
  zrrxm_1     VARCHAR2(150),
  zrrdjxh     NUMBER(20),
  pzzl_dm     VARCHAR2(9) not null,
  pzzg_dm     VARCHAR2(45),
  pzhm        VARCHAR2(20),
  kprq        DATE not null,
  thrq_1      DATE,
  xhrq_1      DATE,
  kjjzrq      DATE,
  xhr_dm      CHAR(11),
  czlx_dm     CHAR(2) not null,
  tzlx_dm     CHAR(1) not null,
  se          NUMBER(18,6) not null,
  zsxm_dm     VARCHAR2(5) not null,
  zspm_dm     CHAR(9) not null,
  skssqq      DATE not null,
  skssqz      DATE not null,
  skzl_dm     CHAR(2),
  sksx_dm     CHAR(4),
  djzclx_dm   CHAR(3) not null,
  hy_dm       VARCHAR2(4) not null,
  yskm_dm     VARCHAR2(9) not null,
  ysfpbl_dm   CHAR(8) not null,
  skgk_dm     CHAR(10) not null,
  jdxz_dm     CHAR(9),
  ttsjlx_dm   CHAR(2) not null,
  tdsfyjwszg  VARCHAR2(75),
  tsczbz      CHAR(1),
  tsczrq      DATE,
  yhyywd_dm   VARCHAR2(13),
  zhmc        VARCHAR2(300),
  yhzh        VARCHAR2(50),
  tdsfyylx_dm CHAR(3),
  ssyhlx_dm   CHAR(3),
  ssjmxzxl_dm CHAR(2),
  ssjmxzhz_dm VARCHAR2(3000),
  ssjmxzdl_dm CHAR(2),
  gkdzrq      DATE,
  ttjg_dm     CHAR(11) not null,
  cktsgc_dm   CHAR(2),
  cktsqylx_dm VARCHAR2(2),
  hg_dm       VARCHAR2(50),
  lhjhh       VARCHAR2(13),
  cktszddhbz  CHAR(1),
  fscgrq      DATE,
  ssgly_dm    CHAR(11),
  skssswjg_dm CHAR(11) not null,
  zgswskfj_dm CHAR(11) not null,
  swjg_dm     CHAR(11) not null,
  lrrq        DATE not null,
  lrr_dm      CHAR(11) not null,
  xgrq        DATE,
  xgr_dm      CHAR(11),
  sjgsdq      CHAR(11) not null,
  sjtb_sj     TIMESTAMP(6),
  wzfqydbbz   CHAR(1),
  sjblbz      NUMBER(2) default 0,
  ydtlyuuid   VARCHAR2(32) not null
)
;
create index IDX_CKTS_ZS_SRTHS_DJXH on CKTS_ZS_SRTHS (DJXH)
  nologging;
create index IDX_CKTS_ZS_SRTHS_STT on CKTS_ZS_SRTHS (SKSSSWJG_DM, TTSJLX_DM, THRQ_1)
  nologging;
create index IDX_CKTS_ZS_SRTHS_TT on CKTS_ZS_SRTHS (TTSJLX_DM, THRQ_1)
  nologging;
alter table CKTS_ZS_SRTHS
  add constraint PK_CKTS_ZS_SRTHS primary key (SRTHSUUID);
alter index PK_CKTS_ZS_SRTHS nologging;

prompt
prompt Creating table CKTS_ZS_TKGZ
prompt ===========================
prompt
create table CKTS_ZS_TKGZ
(
  tkgzuuid   VARCHAR2(32) not null,
  tzslb      CHAR(1) not null,
  tzsly      CHAR(1) not null,
  tzlx_dm    CHAR(1) not null,
  djxh       NUMBER(20),
  gzbz       CHAR(1) not null,
  btkgzuuid  VARCHAR2(32),
  pzzl_dm_1  VARCHAR2(9),
  pzrq_2     DATE,
  pzhm_2     VARCHAR2(40),
  zsxm_dm    VARCHAR2(5) not null,
  zspm_dm    CHAR(9) not null,
  yskm_dm    VARCHAR2(9) not null,
  ysfpbl_dm  CHAR(8) not null,
  skgk_dm    CHAR(10) not null,
  hsswjg_dm  CHAR(11),
  skssqq     DATE,
  skssqz     DATE,
  swjg_dm    CHAR(11) not null,
  je         NUMBER(18,2) not null,
  zsjgfzr_dm CHAR(11) not null,
  zsjgjsr_dm CHAR(11) not null,
  gzrq_1     DATE not null,
  gk_dm      CHAR(10) not null,
  gkfzr      VARCHAR2(150),
  gkjsr      VARCHAR2(150),
  dzsphm     NUMBER(20) not null,
  pzzl_dm    VARCHAR2(9),
  pzzg_dm    VARCHAR2(45),
  pzhm       VARCHAR2(20),
  wszg       VARCHAR2(150) not null,
  tkmxzsuuid VARCHAR2(32),
  spuuid     VARCHAR2(32),
  gkgzrq     DATE,
  xhrq_1     DATE,
  xhr_dm     CHAR(11),
  zfbz_1     CHAR(1),
  zfrq_1     DATE,
  zfr_dm     CHAR(11),
  lrrq       DATE not null,
  lrr_dm     CHAR(11) not null,
  xgrq       DATE,
  xgr_dm     CHAR(11),
  sjgsdq     CHAR(11) not null,
  fscgrq     DATE,
  sjtb_sj    TIMESTAMP(6),
  nh         VARCHAR2(10),
  zszm_dm    CHAR(16),
  sjblbz     NUMBER(2) default 0
)
;
create index IDX_CKTS_ZS_TKGZ_D on CKTS_ZS_TKGZ (DJXH)
  nologging;
create index IDX_CKTS_ZS_TKGZ_XTTGZ on CKTS_ZS_TKGZ (XHRQ_1, TZSLY, TZLX_DM, GZBZ, ZFRQ_1)
  nologging;
alter table CKTS_ZS_TKGZ
  add constraint PK_CKTS_ZS_TKGZ primary key (TKGZUUID);
alter index PK_CKTS_ZS_TKGZ nologging;

prompt
prompt Creating table DM_CQWSB_JS
prompt ==========================
prompt
create table DM_CQWSB_JS
(
  js_dm    VARCHAR2(4) not null,
  js_mc    VARCHAR2(200) not null,
  js_model VARCHAR2(300),
  qybj     CHAR(1)
)
;
alter table DM_CQWSB_JS
  add constraint PK_JS_DM primary key (JS_DM);

prompt
prompt Creating table DM_MSG_YWLX
prompt ==========================
prompt
create table DM_MSG_YWLX
(
  ywlx_mc   VARCHAR2(20) not null,
  showorder NUMBER(22)
)
;
comment on table DM_MSG_YWLX
  is '短信关联业务类型代码表';
comment on column DM_MSG_YWLX.ywlx_mc
  is '业务类型名称';
comment on column DM_MSG_YWLX.showorder
  is '展示顺序，按照升序展示';
alter table DM_MSG_YWLX
  add constraint DM_MSG_YWLX primary key (YWLX_MC);

prompt
prompt Creating table DM_XZQH_QG
prompt =========================
prompt
create table DM_XZQH_QG
(
  xzqh_dm   CHAR(6) not null,
  xzqhmc    VARCHAR2(150) not null,
  sjxzqh_dm CHAR(6),
  xzqhjc    CHAR(1) not null,
  yxbz      CHAR(1) not null,
  ssxzqmc   VARCHAR2(150),
  gfxbz     CHAR(1) not null
)
;
comment on table DM_XZQH_QG
  is '行政区划代码';
comment on column DM_XZQH_QG.xzqh_dm
  is '行政区划数字代码';
comment on column DM_XZQH_QG.xzqhmc
  is '行政区划名称';
comment on column DM_XZQH_QG.sjxzqh_dm
  is '上级行政区划数字代码';
comment on column DM_XZQH_QG.xzqhjc
  is '行政区划级次（1省级 2市级 3区县）';
comment on column DM_XZQH_QG.yxbz
  is '有效标志';
comment on column DM_XZQH_QG.ssxzqmc
  is '所属行政区名称||所属行政区';
comment on column DM_XZQH_QG.gfxbz
  is '高风险地区标志  1 高风险 0正常';
create index I_DM_XZQH_QG_1 on DM_XZQH_QG (XZQH_DM, SJXZQH_DM)
  nologging;
create index I_DM_XZQH_QG_2 on DM_XZQH_QG (SJXZQH_DM, XZQH_DM)
  nologging;
create index I_DM_XZQH_QG_4 on DM_XZQH_QG (SJXZQH_DM, XZQH_DM, YXBZ)
  nologging;
create unique index PK_DM_XZQH_QG on DM_XZQH_QG (XZQH_DM)
  nologging;

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
  bz             VARCHAR2(1000),
  tsswjg_mc      VARCHAR2(300),
  spdm2mc        VARCHAR2(250),
  bytscke        NUMBER(18,2),
  yzhtscdfs      NUMBER(18,2),
  pscke          NUMBER(18,2),
  pstse          NUMBER(18,2),
  pszhtse        NUMBER(18,2),
  sfysjc         CHAR(1) default 'N',
  jcpscke        NUMBER(18,2),
  jcpstse        NUMBER(18,2),
  jcqrpstse      NUMBER(18,2),
  jcrktse        NUMBER(18,2),
  jczhtse        NUMBER(18,2),
  sfysga         CHAR(1) default 'N',
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
  is '风险应对结果明细表';
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
  nsrsbh      VARCHAR2(20),
  jh_zzl      NUMBER(16,4),
  jh_zje      NUMBER(18,2),
  jh_dj_gj    NUMBER(16,4),
  jh_dj_gj_pj NUMBER(16,4),
  jh_dj_m     NUMBER(16,4),
  jh_dj_m_pj  NUMBER(16,4),
  nx_zzl      NUMBER(16,4),
  nx_zje      NUMBER(18,2),
  dl_je       NUMBER(18,2)
)
;
comment on table FXGL_DATA_FZPCKQY
  is '纺织品出口企业风险分析模型，部分字段来源于zj_bjts同名表';
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
comment on column FXGL_DATA_FZPCKQY.jh_zzl
  is '进货总重量';
comment on column FXGL_DATA_FZPCKQY.jh_zje
  is '进货总金额';
comment on column FXGL_DATA_FZPCKQY.jh_dj_gj
  is '进货每公斤单价';
comment on column FXGL_DATA_FZPCKQY.jh_dj_gj_pj
  is '进货每公斤平均单价';
comment on column FXGL_DATA_FZPCKQY.jh_dj_m
  is '进货每米单价';
comment on column FXGL_DATA_FZPCKQY.jh_dj_m_pj
  is '进货每米平均单价';
comment on column FXGL_DATA_FZPCKQY.nx_zzl
  is '内销总重量';
comment on column FXGL_DATA_FZPCKQY.nx_zje
  is '内销总金额';
comment on column FXGL_DATA_FZPCKQY.dl_je
  is '电力金额';
alter table FXGL_DATA_FZPCKQY
  add constraint PK_FXGL_DATA_FZPCKQY primary key (DJXH);

prompt
prompt Creating table FXGL_DATA_FZPCKQY_FPXX
prompt =====================================
prompt
create table FXGL_DATA_FZPCKQY_FPXX
(
  fphm          VARCHAR2(30) not null,
  xh            NUMBER(10) not null,
  kprq          TIMESTAMP(6),
  xsfnsrsbh     VARCHAR2(20),
  xsfmc         VARCHAR2(900) not null,
  xhfdjxh       NUMBER(20),
  gmfnsrsbh     VARCHAR2(60),
  gmfmc         VARCHAR2(900) not null,
  gmfdjxh       NUMBER(20),
  sphfwssflhbbm VARCHAR2(19),
  spfwjc        VARCHAR2(360) not null,
  xmmc          VARCHAR2(1800) not null,
  ggxh          VARCHAR2(450),
  dw            VARCHAR2(900),
  fpspdj        VARCHAR2(25),
  fpspsl        VARCHAR2(25),
  je            NUMBER(18,2) not null,
  sl_1          NUMBER(16,6) not null,
  se            NUMBER(18,6) not null,
  spbm5         VARCHAR2(5),
  sl            NUMBER(25,13)
)
;
comment on table FXGL_DATA_FZPCKQY_FPXX
  is '纺织品出口企业发票信息';
comment on column FXGL_DATA_FZPCKQY_FPXX.fphm
  is '发票号码';
comment on column FXGL_DATA_FZPCKQY_FPXX.xh
  is '序号';
comment on column FXGL_DATA_FZPCKQY_FPXX.kprq
  is '开票日期';
comment on column FXGL_DATA_FZPCKQY_FPXX.xsfnsrsbh
  is '销售方纳税人识别代号';
comment on column FXGL_DATA_FZPCKQY_FPXX.xsfmc
  is '销售方名称';
comment on column FXGL_DATA_FZPCKQY_FPXX.xhfdjxh
  is '销货方登记序号';
comment on column FXGL_DATA_FZPCKQY_FPXX.gmfnsrsbh
  is '购买方纳税人识别号';
comment on column FXGL_DATA_FZPCKQY_FPXX.gmfmc
  is '购买方名称';
comment on column FXGL_DATA_FZPCKQY_FPXX.gmfdjxh
  is '购买方登记序号';
comment on column FXGL_DATA_FZPCKQY_FPXX.sphfwssflhbbm
  is '商品和服务税收分类合并编码';
comment on column FXGL_DATA_FZPCKQY_FPXX.spfwjc
  is '商品服务简称||税编里的货劳名称';
comment on column FXGL_DATA_FZPCKQY_FPXX.xmmc
  is '项目名称';
comment on column FXGL_DATA_FZPCKQY_FPXX.ggxh
  is '规格型号';
comment on column FXGL_DATA_FZPCKQY_FPXX.dw
  is '单位';
comment on column FXGL_DATA_FZPCKQY_FPXX.fpspdj
  is '单价';
comment on column FXGL_DATA_FZPCKQY_FPXX.fpspsl
  is '数量';
comment on column FXGL_DATA_FZPCKQY_FPXX.je
  is '金额';
comment on column FXGL_DATA_FZPCKQY_FPXX.sl_1
  is '税率';
comment on column FXGL_DATA_FZPCKQY_FPXX.se
  is '税额';
comment on column FXGL_DATA_FZPCKQY_FPXX.spbm5
  is '税收分类编码大类';
comment on column FXGL_DATA_FZPCKQY_FPXX.sl
  is '数量';
create index IDX_FXGL_DATA_FZPCKQY_FPXX_G on FXGL_DATA_FZPCKQY_FPXX (GMFDJXH);
create index IDX_FXGL_DATA_FZPCKQY_FPXX_GS on FXGL_DATA_FZPCKQY_FPXX (GMFDJXH, SPBM5, XMMC, DW);
create index IDX_FXGL_DATA_FZPCKQY_FPXX_X on FXGL_DATA_FZPCKQY_FPXX (XHFDJXH);
create index IDX_FXGL_DATA_FZPCKQY_FPXX_XS on FXGL_DATA_FZPCKQY_FPXX (XHFDJXH, SPBM5, XMMC, DW)
  nologging;
alter table FXGL_DATA_FZPCKQY_FPXX
  add constraint PK_FXGL_DATA_FZPCKQY_FPXX primary key (FPHM, XH);

prompt
prompt Creating table FXGL_DATA_FZPCKQY_JXMX
prompt =====================================
prompt
create table FXGL_DATA_FZPCKQY_JXMX
(
  djxh  NUMBER(20) not null,
  spbm5 VARCHAR2(5) not null,
  xmmc  VARCHAR2(1800) not null,
  dw    VARCHAR2(900) not null,
  sl    NUMBER(25,13),
  je    NUMBER(18,2),
  se    NUMBER(18,6)
)
;
comment on table FXGL_DATA_FZPCKQY_JXMX
  is '纺织品出口企业原材料进货分类';
comment on column FXGL_DATA_FZPCKQY_JXMX.djxh
  is '登记序号';
comment on column FXGL_DATA_FZPCKQY_JXMX.spbm5
  is '税收分类编码大类';
comment on column FXGL_DATA_FZPCKQY_JXMX.xmmc
  is '项目名称';
comment on column FXGL_DATA_FZPCKQY_JXMX.dw
  is '单位';
comment on column FXGL_DATA_FZPCKQY_JXMX.sl
  is '数量';
comment on column FXGL_DATA_FZPCKQY_JXMX.je
  is '金额';
comment on column FXGL_DATA_FZPCKQY_JXMX.se
  is '税额';

prompt
prompt Creating table FXGL_DATA_FZPCKQY_JXXX
prompt =====================================
prompt
create table FXGL_DATA_FZPCKQY_JXXX
(
  djxh        NUMBER(20) not null,
  spbm5       VARCHAR2(5) not null,
  jh_sl_kg    NUMBER(20,10),
  jh_je_kg    NUMBER(18,2),
  jh_dj_kg    NUMBER(16,4),
  jh_dj_kg_pj NUMBER(16,4),
  jh_sl_m     NUMBER(25,13),
  jh_je_m     NUMBER(18,2),
  jh_dj_m     NUMBER(16,4),
  jh_dj_m_pj  NUMBER(16,4),
  jh_je_notkg NUMBER(18,2),
  jh_gj_m     NUMBER(16,4)
)
;
comment on column FXGL_DATA_FZPCKQY_JXXX.djxh
  is '登记序号';
comment on column FXGL_DATA_FZPCKQY_JXXX.spbm5
  is '税收分类编码大类';
comment on column FXGL_DATA_FZPCKQY_JXXX.jh_sl_kg
  is '数量（公斤）';
comment on column FXGL_DATA_FZPCKQY_JXXX.jh_je_kg
  is '金额（公斤）';
comment on column FXGL_DATA_FZPCKQY_JXXX.jh_dj_kg
  is '单价（公斤）';
comment on column FXGL_DATA_FZPCKQY_JXXX.jh_dj_kg_pj
  is '平均单价（公斤）';
comment on column FXGL_DATA_FZPCKQY_JXXX.jh_sl_m
  is '数量（米）';
comment on column FXGL_DATA_FZPCKQY_JXXX.jh_je_m
  is '金额（米）';
comment on column FXGL_DATA_FZPCKQY_JXXX.jh_dj_m
  is '单价（米）';
comment on column FXGL_DATA_FZPCKQY_JXXX.jh_dj_m_pj
  is '平均单价（米）';
comment on column FXGL_DATA_FZPCKQY_JXXX.jh_je_notkg
  is '金额（非公斤米单位）';
comment on column FXGL_DATA_FZPCKQY_JXXX.jh_gj_m
  is '出口每米公斤数';

prompt
prompt Creating table FXGL_DATA_FZPCKQY_NXMX
prompt =====================================
prompt
create table FXGL_DATA_FZPCKQY_NXMX
(
  djxh  NUMBER(20) not null,
  spbm5 VARCHAR2(5) not null,
  xmmc  VARCHAR2(1800) not null,
  dw    VARCHAR2(900) not null,
  sl    NUMBER(25,13),
  je    NUMBER(18,2),
  se    NUMBER(18,6)
)
;
comment on table FXGL_DATA_FZPCKQY_NXMX
  is '纺织品出口企业内销分类';
comment on column FXGL_DATA_FZPCKQY_NXMX.djxh
  is '登记序号';
comment on column FXGL_DATA_FZPCKQY_NXMX.spbm5
  is '税收分类编码大类';
comment on column FXGL_DATA_FZPCKQY_NXMX.xmmc
  is '项目名称';
comment on column FXGL_DATA_FZPCKQY_NXMX.dw
  is '单位';
comment on column FXGL_DATA_FZPCKQY_NXMX.sl
  is '数量';
comment on column FXGL_DATA_FZPCKQY_NXMX.je
  is '金额';
comment on column FXGL_DATA_FZPCKQY_NXMX.se
  is '税额';

prompt
prompt Creating table FXGL_DATA_FZPCKQY_NXXX
prompt =====================================
prompt
create table FXGL_DATA_FZPCKQY_NXXX
(
  djxh        NUMBER(20) not null,
  spbm5       VARCHAR2(5) not null,
  nx_sl_kg    NUMBER(25,13),
  nx_je_kg    NUMBER(18,2),
  nx_dj_kg    NUMBER(16,4),
  nx_dj_kg_pj NUMBER(16,4),
  nx_je_notkg NUMBER(18,2)
)
;
comment on column FXGL_DATA_FZPCKQY_NXXX.djxh
  is '登记序号';
comment on column FXGL_DATA_FZPCKQY_NXXX.spbm5
  is '税收分类编码大类';
comment on column FXGL_DATA_FZPCKQY_NXXX.nx_sl_kg
  is '数量（公斤）';
comment on column FXGL_DATA_FZPCKQY_NXXX.nx_je_kg
  is '金额（公斤）';
comment on column FXGL_DATA_FZPCKQY_NXXX.nx_dj_kg
  is '单价（公斤）';
comment on column FXGL_DATA_FZPCKQY_NXXX.nx_dj_kg_pj
  is '平均单价（公斤）';
comment on column FXGL_DATA_FZPCKQY_NXXX.nx_je_notkg
  is '金额（非公斤米单位）';

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
  ckhwtmsjsff_dm CHAR(1),
  fp_cke         NUMBER(18,2),
  fp_gje         NUMBER(18,2),
  yswg_ckje_bm   NUMBER(18,2),
  yswg_ckzb_bm   NUMBER(9,2),
  yswg_ckje_mc   NUMBER(18,2),
  yswg_ckzb_mc   NUMBER(9,2),
  gjsb_minkprq   DATE,
  gjsb_zje       NUMBER(18,2),
  gjsb_xgm_pp    NUMBER(18,2),
  gjsb_xgm_zp    NUMBER(18,2),
  gjsb_zb_pp     NUMBER(9,2),
  etl_bz         CHAR(1)
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
comment on column FXGL_DATA_STZC.fp_cke
  is '发票出口额（人民币）';
comment on column FXGL_DATA_STZC.fp_gje
  is '发票购进额（人民币）';
comment on column FXGL_DATA_STZC.yswg_ckje_bm
  is '疑似外购出口金额（编码）';
comment on column FXGL_DATA_STZC.yswg_ckzb_bm
  is '疑似外购出口占比（编码）';
comment on column FXGL_DATA_STZC.yswg_ckje_mc
  is '疑似外购出口金额（名称）';
comment on column FXGL_DATA_STZC.yswg_ckzb_mc
  is '疑似外购出口占比（名称）';
comment on column FXGL_DATA_STZC.gjsb_minkprq
  is '购进设备最早开票日期';
comment on column FXGL_DATA_STZC.gjsb_zje
  is '购进设备总金额';
comment on column FXGL_DATA_STZC.gjsb_xgm_pp
  is '购进小规模普票金额';
comment on column FXGL_DATA_STZC.gjsb_xgm_zp
  is '购进小规模专票金额';
comment on column FXGL_DATA_STZC.gjsb_zb_pp
  is '购进小规模普票占比';
comment on column FXGL_DATA_STZC.etl_bz
  is 'ETL分布处理标志，ETL提取前置‘1’，待存储过程更新后置‘2’';
alter table FXGL_DATA_STZC
  add constraint PK_FXGL_DATA_STZC primary key (DJXH);
alter index PK_FXGL_DATA_STZC nologging;

prompt
prompt Creating table FXGL_DATA_STZC_CKMX
prompt ==================================
prompt
create table FXGL_DATA_STZC_CKMX
(
  djxh          NUMBER(20) not null,
  sphfwssflhbbm VARCHAR2(19) not null,
  xmmc          VARCHAR2(1800) not null,
  je            NUMBER(18,2)
)
;
comment on table FXGL_DATA_STZC_CKMX
  is '出口外购货物生产企业出口分类';
comment on column FXGL_DATA_STZC_CKMX.djxh
  is '登记序号';
comment on column FXGL_DATA_STZC_CKMX.sphfwssflhbbm
  is '税收分类编码';
comment on column FXGL_DATA_STZC_CKMX.xmmc
  is '项目名称';
comment on column FXGL_DATA_STZC_CKMX.je
  is '金额';

prompt
prompt Creating table FXGL_DATA_STZC_FPXX
prompt ==================================
prompt
create table FXGL_DATA_STZC_FPXX
(
  fphm          VARCHAR2(30) not null,
  xh            NUMBER(10) not null,
  kprq          TIMESTAMP(6),
  xsfnsrsbh     VARCHAR2(20),
  xhfdjxh       NUMBER(20),
  gmfnsrsbh     VARCHAR2(60),
  gmfdjxh       NUMBER(20),
  sphfwssflhbbm VARCHAR2(19),
  xmmc          VARCHAR2(1800),
  fpspdj        VARCHAR2(25),
  fpspsl        VARCHAR2(25),
  je            NUMBER(18,2) not null,
  sl_1          NUMBER(16,6) not null,
  se            NUMBER(18,6) not null,
  bz            VARCHAR2(1000)
)
;
comment on table FXGL_DATA_STZC_FPXX
  is '出口外购货物生产企业发票信息';
comment on column FXGL_DATA_STZC_FPXX.fphm
  is '发票号码';
comment on column FXGL_DATA_STZC_FPXX.xh
  is '序号';
comment on column FXGL_DATA_STZC_FPXX.kprq
  is '开票日期';
comment on column FXGL_DATA_STZC_FPXX.xsfnsrsbh
  is '销售方纳税人识别代号';
comment on column FXGL_DATA_STZC_FPXX.xhfdjxh
  is '销货方登记序号';
comment on column FXGL_DATA_STZC_FPXX.gmfnsrsbh
  is '购买方纳税人识别号';
comment on column FXGL_DATA_STZC_FPXX.gmfdjxh
  is '购买方登记序号';
comment on column FXGL_DATA_STZC_FPXX.sphfwssflhbbm
  is '商品和服务税收分类合并编码';
comment on column FXGL_DATA_STZC_FPXX.xmmc
  is '项目名称';
comment on column FXGL_DATA_STZC_FPXX.fpspdj
  is '单价';
comment on column FXGL_DATA_STZC_FPXX.fpspsl
  is '数量';
comment on column FXGL_DATA_STZC_FPXX.je
  is '金额';
comment on column FXGL_DATA_STZC_FPXX.sl_1
  is '税率';
comment on column FXGL_DATA_STZC_FPXX.se
  is '税额';
comment on column FXGL_DATA_STZC_FPXX.bz
  is '备注';
create index IDX_FXGL_DATA_STZC_FPXX_G on FXGL_DATA_STZC_FPXX (GMFDJXH);
create index IDX_FXGL_DATA_STZC_FPXX_GS on FXGL_DATA_STZC_FPXX (GMFDJXH, SPHFWSSFLHBBM, XMMC);
create index IDX_FXGL_DATA_STZC_FPXX_X on FXGL_DATA_STZC_FPXX (XHFDJXH);
create index IDX_FXGL_DATA_STZC_FPXX_XS on FXGL_DATA_STZC_FPXX (XHFDJXH, SPHFWSSFLHBBM, XMMC);
alter table FXGL_DATA_STZC_FPXX
  add constraint PK_FXGL_DATA_STZC_FPXX primary key (FPHM, XH);

prompt
prompt Creating table FXGL_DATA_STZC_FPXX_GJ
prompt =====================================
prompt
create table FXGL_DATA_STZC_FPXX_GJ
(
  fphm          VARCHAR2(30) not null,
  xh            NUMBER(10) not null,
  kprq          TIMESTAMP(6),
  xsfnsrsbh     VARCHAR2(20),
  xhfdjxh       NUMBER(20),
  gmfnsrsbh     VARCHAR2(60),
  gmfdjxh       NUMBER(20),
  sphfwssflhbbm VARCHAR2(19),
  xmmc          VARCHAR2(1800),
  fpspdj        VARCHAR2(25),
  fpspsl        VARCHAR2(25),
  je            NUMBER(18,2) not null,
  sl_1          NUMBER(16,6) not null,
  se            NUMBER(18,6) not null,
  bz            VARCHAR2(1000),
  fplb          VARCHAR2(20)
)
;
comment on table FXGL_DATA_STZC_FPXX_GJ
  is '生产企业购进设备发票信息';
comment on column FXGL_DATA_STZC_FPXX_GJ.fphm
  is '发票号码';
comment on column FXGL_DATA_STZC_FPXX_GJ.xh
  is '序号';
comment on column FXGL_DATA_STZC_FPXX_GJ.kprq
  is '开票日期';
comment on column FXGL_DATA_STZC_FPXX_GJ.xsfnsrsbh
  is '销售方纳税人识别代号';
comment on column FXGL_DATA_STZC_FPXX_GJ.xhfdjxh
  is '销货方登记序号';
comment on column FXGL_DATA_STZC_FPXX_GJ.gmfnsrsbh
  is '购买方纳税人识别号';
comment on column FXGL_DATA_STZC_FPXX_GJ.gmfdjxh
  is '购买方登记序号';
comment on column FXGL_DATA_STZC_FPXX_GJ.sphfwssflhbbm
  is '商品和服务税收分类合并编码';
comment on column FXGL_DATA_STZC_FPXX_GJ.xmmc
  is '项目名称';
comment on column FXGL_DATA_STZC_FPXX_GJ.fpspdj
  is '单价';
comment on column FXGL_DATA_STZC_FPXX_GJ.fpspsl
  is '数量';
comment on column FXGL_DATA_STZC_FPXX_GJ.je
  is '金额';
comment on column FXGL_DATA_STZC_FPXX_GJ.sl_1
  is '税率';
comment on column FXGL_DATA_STZC_FPXX_GJ.se
  is '税额';
comment on column FXGL_DATA_STZC_FPXX_GJ.bz
  is '备注';
comment on column FXGL_DATA_STZC_FPXX_GJ.fplb
  is '发票类别（专票、普票）';
create index IDX_FXGL_DATA_STZC_FPXX_GJ_G on FXGL_DATA_STZC_FPXX_GJ (GMFDJXH);
create index IDX_FXGL_DATA_STZC_FPXX_GJ_GS on FXGL_DATA_STZC_FPXX_GJ (GMFDJXH, SPHFWSSFLHBBM, XMMC);
alter table FXGL_DATA_STZC_FPXX_GJ
  add constraint PK_FXGL_DATA_STZC_FPXX_GJ primary key (FPHM, XH);

prompt
prompt Creating table FXGL_DATA_STZC_JXMX
prompt ==================================
prompt
create table FXGL_DATA_STZC_JXMX
(
  djxh          NUMBER(20) not null,
  sphfwssflhbbm VARCHAR2(19) not null,
  xmmc          VARCHAR2(1800) not null,
  je            NUMBER(18,2)
)
;
comment on table FXGL_DATA_STZC_JXMX
  is '出口外购货物生产企业进货分类';
comment on column FXGL_DATA_STZC_JXMX.djxh
  is '登记序号';
comment on column FXGL_DATA_STZC_JXMX.sphfwssflhbbm
  is '税收分类编码';
comment on column FXGL_DATA_STZC_JXMX.xmmc
  is '项目名称';
comment on column FXGL_DATA_STZC_JXMX.je
  is '金额';

prompt
prompt Creating table FXGL_DATA_STZC_YSWG_BM
prompt =====================================
prompt
create table FXGL_DATA_STZC_YSWG_BM
(
  djxh          NUMBER(20) not null,
  sphfwssflhbbm VARCHAR2(19) not null,
  ckje          NUMBER(18,2),
  jhje          NUMBER(18,2),
  yswg_bfb      NUMBER(9,2),
  yswg_ckje     NUMBER(18,2)
)
;
comment on table FXGL_DATA_STZC_YSWG_BM
  is '出口外购货物生产企业按编码疑似外购分析';
comment on column FXGL_DATA_STZC_YSWG_BM.djxh
  is '登记序号';
comment on column FXGL_DATA_STZC_YSWG_BM.sphfwssflhbbm
  is '税收分类编码';
comment on column FXGL_DATA_STZC_YSWG_BM.ckje
  is '出口金额';
comment on column FXGL_DATA_STZC_YSWG_BM.jhje
  is '进货金额';
comment on column FXGL_DATA_STZC_YSWG_BM.yswg_bfb
  is '疑似外购百分比';
comment on column FXGL_DATA_STZC_YSWG_BM.yswg_ckje
  is '疑似外购出口金额';

prompt
prompt Creating table FXGL_DATA_STZC_YSWG_MC
prompt =====================================
prompt
create table FXGL_DATA_STZC_YSWG_MC
(
  djxh          NUMBER(20) not null,
  sphfwssflhbbm VARCHAR2(19) not null,
  xmmc          VARCHAR2(1800) not null,
  ckje          NUMBER(18,2),
  jhje          NUMBER(18,2),
  yswg_bfb      NUMBER(9,2),
  yswg_ckje     NUMBER(18,2)
)
;
comment on table FXGL_DATA_STZC_YSWG_MC
  is '出口外购货物生产企业按名称疑似外购分析';
comment on column FXGL_DATA_STZC_YSWG_MC.djxh
  is '登记序号';
comment on column FXGL_DATA_STZC_YSWG_MC.sphfwssflhbbm
  is '税收分类编码';
comment on column FXGL_DATA_STZC_YSWG_MC.xmmc
  is '项目名称';
comment on column FXGL_DATA_STZC_YSWG_MC.ckje
  is '出口金额';
comment on column FXGL_DATA_STZC_YSWG_MC.jhje
  is '进货金额';
comment on column FXGL_DATA_STZC_YSWG_MC.yswg_bfb
  is '疑似外购百分比';
comment on column FXGL_DATA_STZC_YSWG_MC.yswg_ckje
  is '疑似外购出口金额';

prompt
prompt Creating table FXGL_DATA_YCFP
prompt =============================
prompt
create table FXGL_DATA_YCFP
(
  tsswjg_dm CHAR(11),
  djxh      NUMBER(20),
  jhpzh     VARCHAR2(75) not null,
  kprq      DATE,
  gfnsrsbh  VARCHAR2(20),
  ghfmc     VARCHAR2(300),
  xfnsrsbh  VARCHAR2(20),
  xhfmc     VARCHAR2(300),
  je        NUMBER(18,2),
  sbfpjsje  NUMBER(18,2),
  hzcjjsje  NUMBER(18,2),
  hzcjrq    DATE,
  hzfphm    VARCHAR2(75)
)
;
comment on column FXGL_DATA_YCFP.tsswjg_dm
  is '退税税务机关代码';
comment on column FXGL_DATA_YCFP.djxh
  is '登记序号';
comment on column FXGL_DATA_YCFP.jhpzh
  is '进货凭证号/专用税票号';
comment on column FXGL_DATA_YCFP.kprq
  is '开票日期';
comment on column FXGL_DATA_YCFP.gfnsrsbh
  is '购买方税号';
comment on column FXGL_DATA_YCFP.ghfmc
  is '购买方名称';
comment on column FXGL_DATA_YCFP.xfnsrsbh
  is '销售方税号';
comment on column FXGL_DATA_YCFP.xhfmc
  is '销售方明细';
comment on column FXGL_DATA_YCFP.je
  is '原始发票计税金额';
comment on column FXGL_DATA_YCFP.sbfpjsje
  is '申报退税计税金额';
comment on column FXGL_DATA_YCFP.hzcjjsje
  is '红字冲减计税金额';
comment on column FXGL_DATA_YCFP.hzcjrq
  is '红字冲减日期';
comment on column FXGL_DATA_YCFP.hzfphm
  is '红字发票号码';
alter table FXGL_DATA_YCFP
  add constraint PK_FXGL_DATA_YCFP primary key (JHPZH);

prompt
prompt Creating table FXGL_DATA_ZXZB
prompt =============================
prompt
create table FXGL_DATA_ZXZB
(
  id        NUMBER not null,
  tsswjg_dm CHAR(11),
  djxh      NUMBER(20),
  nsrsbh    VARCHAR2(20),
  nsrmc     VARCHAR2(300),
  smlx      CHAR(1),
  smrq      DATE,
  smjg      VARCHAR2(300),
  zbid      VARCHAR2(30),
  zbcs      VARCHAR2(300),
  hsjglx    CHAR(1) default '0',
  hsrq      DATE,
  hsry      VARCHAR2(200),
  hsclqk    VARCHAR2(2000)
)
;
comment on column FXGL_DATA_ZXZB.id
  is 'ID主键';
comment on column FXGL_DATA_ZXZB.tsswjg_dm
  is '所属税务机关';
comment on column FXGL_DATA_ZXZB.djxh
  is '登记序号';
comment on column FXGL_DATA_ZXZB.nsrsbh
  is '税号';
comment on column FXGL_DATA_ZXZB.nsrmc
  is '名称';
comment on column FXGL_DATA_ZXZB.smlx
  is '扫描类型（0自动扫描/1手动刷新）';
comment on column FXGL_DATA_ZXZB.smrq
  is '扫描日期';
comment on column FXGL_DATA_ZXZB.smjg
  is '扫描结果描述';
comment on column FXGL_DATA_ZXZB.zbid
  is '专项监管指标ID';
comment on column FXGL_DATA_ZXZB.zbcs
  is '指标参数集合，因不同时期参数有差异，记录扫描时涉及各项指标值';
comment on column FXGL_DATA_ZXZB.hsjglx
  is '核实结果类型（0未核实/1已核实），后续可能会增加类型';
comment on column FXGL_DATA_ZXZB.hsrq
  is '核实日期';
comment on column FXGL_DATA_ZXZB.hsry
  is '核实人员';
comment on column FXGL_DATA_ZXZB.hsclqk
  is '核实处理情况';
create index IDX_FXGL_DATA_ZXZB_DZS on FXGL_DATA_ZXZB (DJXH, ZBID, SMRQ);
alter table FXGL_DATA_ZXZB
  add constraint PK_FXGL_DATA_ZXZB primary key (ID);

prompt
prompt Creating table FXGL_PZ_ZB
prompt =========================
prompt
create table FXGL_PZ_ZB
(
  zb_id         VARCHAR2(30) not null,
  zb_cname      VARCHAR2(80),
  zb_sname      VARCHAR2(50),
  zb_type       VARCHAR2(20),
  ywfl_dm       VARCHAR2(20),
  datatype      CHAR(1),
  showformat    CHAR(1),
  apply_hy      VARCHAR2(200),
  apply_qy      VARCHAR2(20),
  zb_fomula     VARCHAR2(4000),
  refresh_cycle VARCHAR2(10),
  ywms          VARCHAR2(4000),
  bbh           VARCHAR2(10),
  js_yxj        INTEGER,
  yxbz          CHAR(1),
  rs_type       VARCHAR2(20)
)
;
comment on table FXGL_PZ_ZB
  is '健康管理-配置-指标';
comment on column FXGL_PZ_ZB.zb_id
  is '指标标识 ';
comment on column FXGL_PZ_ZB.zb_cname
  is '指标名称 ';
comment on column FXGL_PZ_ZB.zb_sname
  is '指标简称 ';
comment on column FXGL_PZ_ZB.zb_type
  is '指标模式,表示指标结果值的生成方法，派生型是根据其他指标叠加时期范围或群体范围得到的关联指标 公式型/SQL型/派生型';
comment on column FXGL_PZ_ZB.ywfl_dm
  is '业务分类，关联 JKGL_DM_YWFL';
comment on column FXGL_PZ_ZB.datatype
  is '数据类型,针对指标结果值 数值型';
comment on column FXGL_PZ_ZB.showformat
  is '显示格式 默认/百分比/金额/整数';
comment on column FXGL_PZ_ZB.apply_hy
  is '适用行业（可多选） 关联行业代码表';
comment on column FXGL_PZ_ZB.apply_qy
  is '适用企业类型 空=全部/1生产/2外贸';
comment on column FXGL_PZ_ZB.zb_fomula
  is '指标公式。利用数据项、指标元、指标、指标参数、维度的计算公式伪代码 ';
comment on column FXGL_PZ_ZB.refresh_cycle
  is '刷新周期 日/周/月/季/半年/年';
comment on column FXGL_PZ_ZB.ywms
  is '业务描述 ';
comment on column FXGL_PZ_ZB.bbh
  is '版本号 ';
comment on column FXGL_PZ_ZB.js_yxj
  is '计算优先级（小值优先）';
comment on column FXGL_PZ_ZB.yxbz
  is '有效标志 Y /N';
comment on column FXGL_PZ_ZB.rs_type
  is '指标结果类型';
alter table FXGL_PZ_ZB
  add constraint PK_FXGL_PZ_ZB primary key (ZB_ID);

prompt
prompt Creating table FXGL_PZ_ZB_CS
prompt ============================
prompt
create table FXGL_PZ_ZB_CS
(
  csbm     VARCHAR2(50) not null,
  csmc     VARCHAR2(100),
  zb_id    VARCHAR2(30),
  datatype CHAR(1),
  val_def  VARCHAR2(100),
  note     VARCHAR2(200),
  yxbz     CHAR(1),
  cstype   VARCHAR2(10)
)
;
comment on table FXGL_PZ_ZB_CS
  is '指标参数配置';
comment on column FXGL_PZ_ZB_CS.csbm
  is '参数编码（PK）';
comment on column FXGL_PZ_ZB_CS.csmc
  is '参数名称';
comment on column FXGL_PZ_ZB_CS.zb_id
  is '指标标识 ';
comment on column FXGL_PZ_ZB_CS.datatype
  is '数据类型 1字符型/2数值型/3日期型/4逻辑型';
comment on column FXGL_PZ_ZB_CS.val_def
  is '全省默认值';
comment on column FXGL_PZ_ZB_CS.note
  is '说明';
comment on column FXGL_PZ_ZB_CS.yxbz
  is '有效标志';
comment on column FXGL_PZ_ZB_CS.cstype
  is '参数类型：数量、数值、金额、美元、百分比';
alter table FXGL_PZ_ZB_CS
  add constraint PK_FXGL_PZ_ZB_CS primary key (CSBM);

prompt
prompt Creating table FXGL_PZ_ZB_CS_SWJG
prompt =================================
prompt
create table FXGL_PZ_ZB_CS_SWJG
(
  swjg_dm VARCHAR2(11) not null,
  csbm    VARCHAR2(50) not null,
  val_def VARCHAR2(100),
  yxbz    CHAR(1)
)
;
comment on table FXGL_PZ_ZB_CS_SWJG
  is '指标参数税务机关自定义';
comment on column FXGL_PZ_ZB_CS_SWJG.swjg_dm
  is '税务机关代码';
comment on column FXGL_PZ_ZB_CS_SWJG.csbm
  is '参数编码（PK）';
comment on column FXGL_PZ_ZB_CS_SWJG.val_def
  is '参数值';
comment on column FXGL_PZ_ZB_CS_SWJG.yxbz
  is '有效标志Y/N';
alter table FXGL_PZ_ZB_CS_SWJG
  add constraint PK_FXGL_PZ_ZB_CS_SWJG primary key (SWJG_DM, CSBM);

prompt
prompt Creating table FXGL_PZ_ZB_TASK
prompt ==============================
prompt
create table FXGL_PZ_ZB_TASK
(
  id      NUMBER(20) not null,
  swjg_dm VARCHAR2(11) not null,
  sqr_xm  VARCHAR2(20) not null,
  sqr_dm  VARCHAR2(20) not null,
  zb_id   VARCHAR2(20) not null,
  sqsj    DATE not null,
  ztbz    CHAR(1),
  tqbs    VARCHAR2(50),
  clkssj  DATE,
  clwcsj  DATE
)
;
comment on column FXGL_PZ_ZB_TASK.swjg_dm
  is '税务机关代码';
comment on column FXGL_PZ_ZB_TASK.sqr_xm
  is '申请人姓名';
comment on column FXGL_PZ_ZB_TASK.sqr_dm
  is '申请人代码';
comment on column FXGL_PZ_ZB_TASK.zb_id
  is '指标ID';
comment on column FXGL_PZ_ZB_TASK.sqsj
  is '申请时间';
comment on column FXGL_PZ_ZB_TASK.ztbz
  is '0、已提交 1、出理中 2、处理完成 、9、处理失败';
comment on column FXGL_PZ_ZB_TASK.tqbs
  is '提取标识';
comment on column FXGL_PZ_ZB_TASK.clkssj
  is '处理开始时间';
comment on column FXGL_PZ_ZB_TASK.clwcsj
  is '处理完成时间';
alter table FXGL_PZ_ZB_TASK
  add constraint F_P_Z_T_PK primary key (ID);

prompt
prompt Creating table FXGL_SZ_SPFXCK
prompt =============================
prompt
create table FXGL_SZ_SPFXCK
(
  id         NUMBER(32) not null,
  tsswjg_dm  CHAR(11),
  tbr        VARCHAR2(20),
  tbrq       DATE,
  gz_fw_swjg VARCHAR2(11),
  gz_fw_data CHAR(1),
  gz_mc      VARCHAR2(200),
  gz_fxms    VARCHAR2(200),
  gz_spdm    VARCHAR2(200),
  gz_spmc    VARCHAR2(200),
  gz_ggxh    VARCHAR2(200),
  gz_ckka    VARCHAR2(200),
  gz_ckgb    VARCHAR2(200),
  gz_hyd     VARCHAR2(200),
  gz_djq     NUMBER(18,2),
  gz_djz     NUMBER(18,2),
  gz_yxqz    DATE,
  gz_dxtxbz  CHAR(1),
  qybj       CHAR(1),
  tsswjg_mc  VARCHAR2(60),
  gz_zjq     NUMBER(18,2),
  gz_zjz     NUMBER(18,2)
)
;
comment on table FXGL_SZ_SPFXCK
  is '商品风险出口维护';
comment on column FXGL_SZ_SPFXCK.id
  is 'ID主键';
comment on column FXGL_SZ_SPFXCK.tsswjg_dm
  is '填报单位';
comment on column FXGL_SZ_SPFXCK.tbr
  is '填报人';
comment on column FXGL_SZ_SPFXCK.tbrq
  is '填报日期';
comment on column FXGL_SZ_SPFXCK.gz_fw_swjg
  is '适用机关范围（根据填报单位有效位数自动调用，省局133杭州13301…）';
comment on column FXGL_SZ_SPFXCK.gz_fw_data
  is '适用业务范围（1出口电子信息2申报出口明细3同时适用）';
comment on column FXGL_SZ_SPFXCK.gz_mc
  is '规则名称';
comment on column FXGL_SZ_SPFXCK.gz_fxms
  is '风险描述';
comment on column FXGL_SZ_SPFXCK.gz_spdm
  is '商品代码';
comment on column FXGL_SZ_SPFXCK.gz_spmc
  is '商品名称';
comment on column FXGL_SZ_SPFXCK.gz_ggxh
  is '规格型号';
comment on column FXGL_SZ_SPFXCK.gz_ckka
  is '出口口岸';
comment on column FXGL_SZ_SPFXCK.gz_ckgb
  is '出口国别';
comment on column FXGL_SZ_SPFXCK.gz_hyd
  is '货源地';
comment on column FXGL_SZ_SPFXCK.gz_djq
  is '单价范围起（美元）';
comment on column FXGL_SZ_SPFXCK.gz_djz
  is '单价范围止（美元）';
comment on column FXGL_SZ_SPFXCK.gz_yxqz
  is '有效期止';
comment on column FXGL_SZ_SPFXCK.gz_dxtxbz
  is '生成短信提醒标志(Y/N)';
comment on column FXGL_SZ_SPFXCK.qybj
  is '启用标志(Y/N)';
comment on column FXGL_SZ_SPFXCK.gz_zjq
  is '总价范围起（美元）';
comment on column FXGL_SZ_SPFXCK.gz_zjz
  is '总价范围止（美元）';
alter table FXGL_SZ_SPFXCK
  add constraint PK_FXGL_SZ_SPFXCK primary key (ID);

prompt
prompt Creating table FXGL_SZ_SPFXJH
prompt =============================
prompt
create table FXGL_SZ_SPFXJH
(
  id         NUMBER(32) not null,
  tsswjg_dm  CHAR(11),
  tbr        VARCHAR2(20),
  tbrq       DATE,
  gz_fw_swjg VARCHAR2(11),
  gz_fw_data CHAR(1),
  gz_mc      VARCHAR2(100),
  gz_fxms    VARCHAR2(200),
  gz_ghdqdm  VARCHAR2(10),
  gz_ghdqmc  VARCHAR2(100),
  gz_ghqysh  VARCHAR2(20),
  gz_ghqymc  VARCHAR2(100),
  gz_spdm    VARCHAR2(20),
  gz_spmc    VARCHAR2(200),
  gz_yxqz    DATE,
  gz_dxtxbz  CHAR(1),
  qybj       CHAR(1),
  tsswjg_mc  VARCHAR2(60),
  fhxxbuuid  VARCHAR2(60)
)
;
comment on table FXGL_SZ_SPFXJH
  is '商品风险进货维护';
comment on column FXGL_SZ_SPFXJH.id
  is 'ID主键';
comment on column FXGL_SZ_SPFXJH.tsswjg_dm
  is '填报单位';
comment on column FXGL_SZ_SPFXJH.tbr
  is '填报人';
comment on column FXGL_SZ_SPFXJH.tbrq
  is '填报日期';
comment on column FXGL_SZ_SPFXJH.gz_fw_swjg
  is '适用机关范围（根据填报单位有效位数自动调用，省局133杭州13301…）';
comment on column FXGL_SZ_SPFXJH.gz_fw_data
  is '适用业务范围（1进货电子信息2申报进货明细3同时适用）';
comment on column FXGL_SZ_SPFXJH.gz_mc
  is '规则名称';
comment on column FXGL_SZ_SPFXJH.gz_fxms
  is '风险描述';
comment on column FXGL_SZ_SPFXJH.gz_ghdqdm
  is '供货地区代码';
comment on column FXGL_SZ_SPFXJH.gz_ghdqmc
  is '供货地区名称';
comment on column FXGL_SZ_SPFXJH.gz_ghqysh
  is '供货企业税号';
comment on column FXGL_SZ_SPFXJH.gz_ghqymc
  is '供货企业名称';
comment on column FXGL_SZ_SPFXJH.gz_spdm
  is '商品代码';
comment on column FXGL_SZ_SPFXJH.gz_spmc
  is '商品名称';
comment on column FXGL_SZ_SPFXJH.gz_yxqz
  is '有效期止';
comment on column FXGL_SZ_SPFXJH.gz_dxtxbz
  is '生成短信提醒标志(Y/N)';
comment on column FXGL_SZ_SPFXJH.qybj
  is '启用标志(Y/N)';
alter table FXGL_SZ_SPFXJH
  add constraint PK_FXGL_SZ_SPFXJH primary key (ID);

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
  nkkjms   VARCHAR2(4000),
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
  is '事前提醒类型（0否/1是）';
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
  hxczsm    VARCHAR2(2000),
  cldz      CHAR(1)
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
comment on column FXNK_NBFXDMX_SZ.cldz
  is '处理动作：0-忽略、1-中断';

prompt
prompt Creating table FXNK_RULES_MAIN
prompt ==============================
prompt
create table FXNK_RULES_MAIN
(
  id       NUMBER not null,
  biz_key  VARCHAR2(100) not null,
  biz_desc VARCHAR2(200),
  biz_path VARCHAR2(60) not null,
  is_valid CHAR(1) default 'Y' not null,
  bz       VARCHAR2(200)
)
;
comment on column FXNK_RULES_MAIN.id
  is '主键';
comment on column FXNK_RULES_MAIN.biz_key
  is '业务关键字';
comment on column FXNK_RULES_MAIN.biz_desc
  is '业务描述';
comment on column FXNK_RULES_MAIN.biz_path
  is '业务关键字路径';
comment on column FXNK_RULES_MAIN.is_valid
  is '是否有效  Y\N';
alter table FXNK_RULES_MAIN
  add constraint PK_RULES_MAIN primary key (ID);

prompt
prompt Creating table FXNK_RULES_MX
prompt ============================
prompt
create table FXNK_RULES_MX
(
  id          NUMBER not null,
  biz_key     VARCHAR2(100) not null,
  prop_path   VARCHAR2(60),
  prop_name   VARCHAR2(20) not null,
  value_path  VARCHAR2(60) not null,
  param_alias VARCHAR2(20) not null,
  is_valid    CHAR(1) default 'Y' not null,
  crtime      DATE,
  uptime      DATE
)
;
comment on column FXNK_RULES_MX.biz_key
  is '业务关键字';
comment on column FXNK_RULES_MX.prop_path
  is '参数变量路径';
comment on column FXNK_RULES_MX.prop_name
  is '参数变量名';
comment on column FXNK_RULES_MX.value_path
  is '参数变量值路径';
comment on column FXNK_RULES_MX.param_alias
  is '存储过程参数别名';
alter table FXNK_RULES_MX
  add constraint PK_RULES_MX primary key (ID);

prompt
prompt Creating table GLXT_BB_SHXT_DJXX
prompt ================================
prompt
create table GLXT_BB_SHXT_DJXX
(
  swjgdm      VARCHAR2(11),
  zgswjgdm    VARCHAR2(11),
  cpcode      VARCHAR2(32),
  qyhgdm      VARCHAR2(32),
  nsrdjno     VARCHAR2(32),
  shxyno      VARCHAR2(20),
  nsrmc       VARCHAR2(200),
  address_zc  VARCHAR2(300),
  address_jy  VARCHAR2(300),
  bsy         VARCHAR2(150),
  bsy_no      VARCHAR2(30),
  bsy_tel     VARCHAR2(60),
  bsy2        VARCHAR2(150),
  bsy2_no     VARCHAR2(30),
  bsy2_tel    VARCHAR2(60),
  jsmode      CHAR(1),
  qylx        VARCHAR2(10),
  nsrlx_js    VARCHAR2(1) default '1',
  djzclx_js   VARCHAR2(3),
  flglcd      CHAR(1),
  nsxydj_js   VARCHAR2(20),
  ysjccode    VARCHAR2(2),
  tkjccode    VARCHAR2(30),
  bkname      VARCHAR2(80),
  accno       VARCHAR2(60),
  accno_js    VARCHAR2(60),
  ysfw        CHAR(1),
  ysfwcode    VARCHAR2(30),
  ysfs        VARCHAR2(30),
  yfsjfw      VARCHAR2(50),
  wzfqy       CHAR(1),
  wzhqy       CHAR(1),
  sdqqy       CHAR(1),
  yfjg        CHAR(1),
  sq_date     DATE,
  zx_flag     CHAR(1),
  zx_date     DATE,
  nsrzt_js    VARCHAR2(2),
  sfckqy_js   CHAR(1) default '0',
  yxbaflag    CHAR(1) default '0',
  bajc_year   VARCHAR2(2) default '00',
  sbjc_year   VARCHAR2(2) default '00',
  bajc_month  VARCHAR2(2) default '00',
  sbjc_month  VARCHAR2(2) default '00',
  mdjccode    VARCHAR2(30),
  hydm        VARCHAR2(4),
  dbtsba_flag CHAR(1) default '0',
  dbtssb_flag CHAR(1) default '0',
  jsjdjdm     VARCHAR2(10),
  frdb_mc     VARCHAR2(150),
  swdj_date   DATE,
  ybnsr_date  DATE,
  frdb_zjlx   VARCHAR2(10),
  frdb_zjhm   VARCHAR2(30),
  djxh_js     NUMBER(21),
  first_sb_ym VARCHAR2(6),
  zgswskfj_dm VARCHAR2(11),
  jdxz_dm     VARCHAR2(9),
  wzfqy13     CHAR(1),
  qyfz        VARCHAR2(11),
  nsrdzdah    NUMBER(20),
  ckgm_dm     CHAR(1),
  ck_bgdfs    NUMBER(10),
  ck_mylaj    NUMBER(18,2),
  ckgm        NUMBER(18,2),
  sb_tmse     NUMBER(18,2),
  sb_mde      NUMBER(18,2),
  ckblv       NUMBER(10,6),
  mdblv       NUMBER(10,6),
  sflv        NUMBER(10,6),
  ckblv_dm    CHAR(1),
  mdblv_dm    CHAR(1),
  sflv_dm     CHAR(1),
  qygzxx      VARCHAR2(2000)
)
;
comment on table GLXT_BB_SHXT_DJXX
  is '管理系统_报表_出口企业档案表';
comment on column GLXT_BB_SHXT_DJXX.swjgdm
  is '退税税务机关代码';
comment on column GLXT_BB_SHXT_DJXX.zgswjgdm
  is '征管税务机关代码';
comment on column GLXT_BB_SHXT_DJXX.cpcode
  is '审核系统企业标识';
comment on column GLXT_BB_SHXT_DJXX.qyhgdm
  is '企业海关代码';
comment on column GLXT_BB_SHXT_DJXX.nsrdjno
  is '税务登记证号';
comment on column GLXT_BB_SHXT_DJXX.shxyno
  is '社会信用代码';
comment on column GLXT_BB_SHXT_DJXX.nsrmc
  is '纳税人名称';
comment on column GLXT_BB_SHXT_DJXX.address_zc
  is '企业注册地址';
comment on column GLXT_BB_SHXT_DJXX.address_jy
  is '经营场所';
comment on column GLXT_BB_SHXT_DJXX.bsy
  is '办税人姓名1';
comment on column GLXT_BB_SHXT_DJXX.bsy_no
  is '身份证号1';
comment on column GLXT_BB_SHXT_DJXX.bsy_tel
  is '办税人电话1';
comment on column GLXT_BB_SHXT_DJXX.bsy2
  is '办税人姓名2';
comment on column GLXT_BB_SHXT_DJXX.bsy2_no
  is '身份证号2';
comment on column GLXT_BB_SHXT_DJXX.bsy2_tel
  is '办税人电话2';
comment on column GLXT_BB_SHXT_DJXX.jsmode
  is '退税计算方式';
comment on column GLXT_BB_SHXT_DJXX.qylx
  is '企业类型代码';
comment on column GLXT_BB_SHXT_DJXX.nsrlx_js
  is '纳税人类型';
comment on column GLXT_BB_SHXT_DJXX.djzclx_js
  is '登记注册类型';
comment on column GLXT_BB_SHXT_DJXX.flglcd
  is '管理类别';
comment on column GLXT_BB_SHXT_DJXX.nsxydj_js
  is '纳税信用等级';
comment on column GLXT_BB_SHXT_DJXX.ysjccode
  is '预算级次';
comment on column GLXT_BB_SHXT_DJXX.tkjccode
  is '退库级次';
comment on column GLXT_BB_SHXT_DJXX.bkname
  is '退税开户银行';
comment on column GLXT_BB_SHXT_DJXX.accno
  is '审核系统退库账号';
comment on column GLXT_BB_SHXT_DJXX.accno_js
  is '金三系统退库账号';
comment on column GLXT_BB_SHXT_DJXX.ysfw
  is '是否应税服务';
comment on column GLXT_BB_SHXT_DJXX.ysfwcode
  is '应税服务代码';
comment on column GLXT_BB_SHXT_DJXX.ysfs
  is '运输方式';
comment on column GLXT_BB_SHXT_DJXX.yfsjfw
  is '研发设计服务';
comment on column GLXT_BB_SHXT_DJXX.wzfqy
  is '外综服企业标识';
comment on column GLXT_BB_SHXT_DJXX.wzhqy
  is '无纸化企业标识';
comment on column GLXT_BB_SHXT_DJXX.sdqqy
  is '水电气企业标识';
comment on column GLXT_BB_SHXT_DJXX.yfjg
  is '研发机构';
comment on column GLXT_BB_SHXT_DJXX.sq_date
  is '备案日期';
comment on column GLXT_BB_SHXT_DJXX.zx_flag
  is '备案撤回标识';
comment on column GLXT_BB_SHXT_DJXX.zx_date
  is '备案撤回日期';
comment on column GLXT_BB_SHXT_DJXX.nsrzt_js
  is '纳税人状态';
comment on column GLXT_BB_SHXT_DJXX.sfckqy_js
  is '金三出口企业标识';
comment on column GLXT_BB_SHXT_DJXX.yxbaflag
  is '有效备案标识';
comment on column GLXT_BB_SHXT_DJXX.bajc_year
  is '备案级次_本年';
comment on column GLXT_BB_SHXT_DJXX.sbjc_year
  is '申报级次_本年';
comment on column GLXT_BB_SHXT_DJXX.bajc_month
  is '备案级次_本月';
comment on column GLXT_BB_SHXT_DJXX.sbjc_month
  is '申报级次_本月';
comment on column GLXT_BB_SHXT_DJXX.mdjccode
  is '调库级次';
comment on column GLXT_BB_SHXT_DJXX.hydm
  is '行业代码（取金三）';
comment on column GLXT_BB_SHXT_DJXX.dbtsba_flag
  is '是否做过生产企业代办退税备案';
comment on column GLXT_BB_SHXT_DJXX.dbtssb_flag
  is '是否申报过代办退税';
comment on column GLXT_BB_SHXT_DJXX.jsjdjdm
  is '技术监督局代码';
comment on column GLXT_BB_SHXT_DJXX.frdb_mc
  is '法人代表名称';
comment on column GLXT_BB_SHXT_DJXX.swdj_date
  is '税务登记日期';
comment on column GLXT_BB_SHXT_DJXX.ybnsr_date
  is '一般纳税人认定日期';
comment on column GLXT_BB_SHXT_DJXX.frdb_zjlx
  is '法人代表证件类型';
comment on column GLXT_BB_SHXT_DJXX.frdb_zjhm
  is '法人代表证明号码';
comment on column GLXT_BB_SHXT_DJXX.djxh_js
  is '登记序号（取金三）';
comment on column GLXT_BB_SHXT_DJXX.first_sb_ym
  is '首次申报年月';
comment on column GLXT_BB_SHXT_DJXX.zgswskfj_dm
  is '主管税务所（科、分局）代码';
comment on column GLXT_BB_SHXT_DJXX.jdxz_dm
  is '街道乡镇代码';
comment on column GLXT_BB_SHXT_DJXX.wzfqy13
  is '是否按13号公告做过外综服备案';
comment on column GLXT_BB_SHXT_DJXX.qyfz
  is '企业分组';
comment on column GLXT_BB_SHXT_DJXX.nsrdzdah
  is '电子档案号，备用';
comment on column GLXT_BB_SHXT_DJXX.ckgm_dm
  is '出口规模（等级，ABCDE）';
comment on column GLXT_BB_SHXT_DJXX.ck_bgdfs
  is '出口报关单份数';
comment on column GLXT_BB_SHXT_DJXX.ck_mylaj
  is '出口美元离岸价';
comment on column GLXT_BB_SHXT_DJXX.ckgm
  is '出口规模（申报美元离岸价）';
comment on column GLXT_BB_SHXT_DJXX.sb_tmse
  is '申报退免税额';
comment on column GLXT_BB_SHXT_DJXX.sb_mde
  is '申报免抵额';
comment on column GLXT_BB_SHXT_DJXX.ckblv
  is '出口比例（百分比）';
comment on column GLXT_BB_SHXT_DJXX.mdblv
  is '免抵比例（百分比）';
comment on column GLXT_BB_SHXT_DJXX.sflv
  is '税负率（百分比）';
comment on column GLXT_BB_SHXT_DJXX.ckblv_dm
  is '出口比例（等级，ABCDE）';
comment on column GLXT_BB_SHXT_DJXX.mdblv_dm
  is '免抵比例（等级，ABCDE）';
comment on column GLXT_BB_SHXT_DJXX.sflv_dm
  is '税负率（等级，ABCDE）';
comment on column GLXT_BB_SHXT_DJXX.qygzxx
  is '企业关注信息';
create index IDX_GLXT_BB_SHXT_DJXX_BAJCYEAR on GLXT_BB_SHXT_DJXX (BAJC_YEAR);
create index IDX_GLXT_BB_SHXT_DJXX_CPCODE on GLXT_BB_SHXT_DJXX (CPCODE);
create index IDX_GLXT_BB_SHXT_DJXX_DJXH on GLXT_BB_SHXT_DJXX (DJXH_JS);
create index IDX_GLXT_BB_SHXT_DJXX_FRDB on GLXT_BB_SHXT_DJXX (FRDB_ZJHM);
create index IDX_GLXT_BB_SHXT_DJXX_JYDZ on GLXT_BB_SHXT_DJXX (ADDRESS_JY);
create index IDX_GLXT_BB_SHXT_DJXX_NSRDJNO on GLXT_BB_SHXT_DJXX (NSRDJNO);
create index IDX_GLXT_BB_SHXT_DJXX_QYHGDM on GLXT_BB_SHXT_DJXX (QYHGDM);
create index IDX_GLXT_BB_SHXT_DJXX_SHXYNO on GLXT_BB_SHXT_DJXX (SHXYNO);
create index IDX_GLXT_BB_SHXT_DJXX_SWJG on GLXT_BB_SHXT_DJXX (SWJGDM);
create index IDX_GLXT_BB_SHXT_DJXX_ZGSWJG on GLXT_BB_SHXT_DJXX (ZGSWJGDM);

prompt
prompt Creating table GLXT_BB_SHXT_LCXX
prompt ================================
prompt
create table GLXT_BB_SHXT_LCXX
(
  uuid        VARCHAR2(32) not null,
  swjgdm      VARCHAR2(11),
  zbswcode    VARCHAR2(11),
  djxh        NUMBER(20),
  ckqygllb_dm CHAR(1),
  sbywb_dm    VARCHAR2(16),
  sb_ym       VARCHAR2(6),
  sb_pc       VARCHAR2(4),
  lcslid      VARCHAR2(32),
  bjts_date   DATE,
  sb_date     DATE,
  sl_date     DATE,
  fh_date     DATE,
  ywhz_date   DATE,
  sehz_date   DATE,
  tskp_date   DATE,
  tstk_date   DATE,
  bljz_date   DATE,
  sl_user     VARCHAR2(32),
  fh_user     VARCHAR2(32),
  ywhz_user   VARCHAR2(32),
  sehz_user   VARCHAR2(32),
  usd_amt     NUMBER(24,4),
  rmb_amt     NUMBER(24,4),
  sb_ts_amt   NUMBER(24,4),
  sb_md_amt   NUMBER(24,4),
  zlc_ts_amt  NUMBER(24,4),
  zlc_md_amt  NUMBER(24,4),
  zlc_rwzt    VARCHAR2(600),
  zlc_xndbr   VARCHAR2(50),
  bybl_amt    NUMBER(24,4),
  zh_amt      NUMBER(24,4),
  byts_amt    NUMBER(24,4),
  zbbl_amt    NUMBER(24,4),
  fh_ts_amt   NUMBER(24,4),
  fh_md_amt   NUMBER(24,4),
  sehz_ts_amt NUMBER(24,4),
  sehz_md_amt NUMBER(24,4),
  byhz_ts_amt NUMBER(24,4),
  byhz_md_amt NUMBER(24,4),
  zk_amt      NUMBER(24,4),
  kp_ts_amt   NUMBER(24,4),
  kp_md_amt   NUMBER(24,4),
  tk_ts_amt   NUMBER(24,4),
  tk_md_amt   NUMBER(24,4),
  lcjsrq      DATE,
  sl_day      NUMBER(10,4) default 0,
  sh_day      NUMBER(10,4) default 0,
  hz_day      NUMBER(10,4) default 0,
  kp_day      NUMBER(10,4) default 0,
  sum_day     NUMBER(10,4) default 0,
  ysfw_flag   CHAR(1) default 'N',
  zlc_ffrq    DATE,
  wzhbz       CHAR(1)
)
;
comment on table GLXT_BB_SHXT_LCXX
  is '因审核系统数据有误需要调整数据表';
comment on column GLXT_BB_SHXT_LCXX.uuid
  is 'UUID||uuid';
comment on column GLXT_BB_SHXT_LCXX.swjgdm
  is '税务机关代码';
comment on column GLXT_BB_SHXT_LCXX.zbswcode
  is '指标税务机关';
comment on column GLXT_BB_SHXT_LCXX.djxh
  is '登记序号';
comment on column GLXT_BB_SHXT_LCXX.ckqygllb_dm
  is '出口企业管理类别代码';
comment on column GLXT_BB_SHXT_LCXX.sbywb_dm
  is '申报业务表代码（A0000001代表2013年前无业务流程的初始数据，其他正常）';
comment on column GLXT_BB_SHXT_LCXX.sb_ym
  is '申报年月';
comment on column GLXT_BB_SHXT_LCXX.sb_pc
  is '申报批次';
comment on column GLXT_BB_SHXT_LCXX.lcslid
  is '审核系统流程受理ID';
comment on column GLXT_BB_SHXT_LCXX.bjts_date
  is '便捷退税申报日期';
comment on column GLXT_BB_SHXT_LCXX.sb_date
  is '申报时间(对应主流程启动时间）';
comment on column GLXT_BB_SHXT_LCXX.sl_date
  is '受理时间（对应主流程出具受理通知书时间）';
comment on column GLXT_BB_SHXT_LCXX.fh_date
  is '主流程复审时间（取业务核准表录入时间）';
comment on column GLXT_BB_SHXT_LCXX.ywhz_date
  is '主流程业务核准时间（取业务核准表中的业务核准时间）';
comment on column GLXT_BB_SHXT_LCXX.sehz_date
  is '主流程税额核准时间（取税额核准表的税额核准日期）';
comment on column GLXT_BB_SHXT_LCXX.tskp_date
  is '主流程退税开票时间（取收核开票日期）';
comment on column GLXT_BB_SHXT_LCXX.tstk_date
  is '主流程退税退库时间（取国库退库日期）';
comment on column GLXT_BB_SHXT_LCXX.bljz_date
  is '主流程办理截止时间（根据申报日期、管理类别办理期限，扣除节假日计算）';
comment on column GLXT_BB_SHXT_LCXX.sl_user
  is '受理人员（对应主流程启动人代码对应中文）';
comment on column GLXT_BB_SHXT_LCXX.fh_user
  is '复审人员（取业务核准表录入人代码对应中文）';
comment on column GLXT_BB_SHXT_LCXX.ywhz_user
  is '业务核准人员（取业务核准表中的业务核准人代码对应中文）';
comment on column GLXT_BB_SHXT_LCXX.sehz_user
  is '税额核准人员（取税额核准表的税额核准人代码对应中文）';
comment on column GLXT_BB_SHXT_LCXX.usd_amt
  is '申报出口销售额（美元）';
comment on column GLXT_BB_SHXT_LCXX.rmb_amt
  is '申报出口销售额（人民币）';
comment on column GLXT_BB_SHXT_LCXX.sb_ts_amt
  is '申报退税额';
comment on column GLXT_BB_SHXT_LCXX.sb_md_amt
  is '申报免抵额';
comment on column GLXT_BB_SHXT_LCXX.zlc_ts_amt
  is '主流程退税额';
comment on column GLXT_BB_SHXT_LCXX.zlc_md_amt
  is '主流程免抵额';
comment on column GLXT_BB_SHXT_LCXX.zlc_rwzt
  is '主流程当前任务状态';
comment on column GLXT_BB_SHXT_LCXX.zlc_xndbr
  is '主流程当前虚拟代办人';
comment on column GLXT_BB_SHXT_LCXX.bybl_amt
  is '总不予办理免抵退税额（审核环节确定）';
comment on column GLXT_BB_SHXT_LCXX.zh_amt
  is '总暂缓免抵退税额（还在评估环节）';
comment on column GLXT_BB_SHXT_LCXX.byts_amt
  is '总不予退税免抵退税额（评估结果，复审确定）';
comment on column GLXT_BB_SHXT_LCXX.zbbl_amt
  is '总暂不办理免抵退税额（评估结果，复审确定）';
comment on column GLXT_BB_SHXT_LCXX.fh_ts_amt
  is '总复审退税额';
comment on column GLXT_BB_SHXT_LCXX.fh_md_amt
  is '总复审免抵额';
comment on column GLXT_BB_SHXT_LCXX.sehz_ts_amt
  is '总税额核准退税额';
comment on column GLXT_BB_SHXT_LCXX.sehz_md_amt
  is '总税额核准免抵额';
comment on column GLXT_BB_SHXT_LCXX.byhz_ts_amt
  is '总不予核准退税额';
comment on column GLXT_BB_SHXT_LCXX.byhz_md_amt
  is '总不予核准免抵额';
comment on column GLXT_BB_SHXT_LCXX.zk_amt
  is '总暂扣退税额';
comment on column GLXT_BB_SHXT_LCXX.kp_ts_amt
  is '总开票退税额';
comment on column GLXT_BB_SHXT_LCXX.kp_md_amt
  is '总开票免抵额';
comment on column GLXT_BB_SHXT_LCXX.tk_ts_amt
  is '总国库办理退税额';
comment on column GLXT_BB_SHXT_LCXX.tk_md_amt
  is '总国库办理免抵额';
comment on column GLXT_BB_SHXT_LCXX.lcjsrq
  is '流程全部结束日期';
comment on column GLXT_BB_SHXT_LCXX.sl_day
  is '受理周期（受理时间-申报时间，去除节假日，1小时=1/24天）';
comment on column GLXT_BB_SHXT_LCXX.sh_day
  is '审核周期（复核时间-受理时间，去除节假日，1小时=1/24天）';
comment on column GLXT_BB_SHXT_LCXX.hz_day
  is '核准周期（税额核准时间-复核时间，去除节假日，1小时=1/24天）';
comment on column GLXT_BB_SHXT_LCXX.kp_day
  is '开票周期（收核开票时间-税额核准时间，去除节假日，1小时=1/24天）';
comment on column GLXT_BB_SHXT_LCXX.sum_day
  is '总办理周期（=审核周期+核准周期+开票周期）';
comment on column GLXT_BB_SHXT_LCXX.ysfw_flag
  is '是否包含跨境应税行为申报数据';
comment on column GLXT_BB_SHXT_LCXX.zlc_ffrq
  is '主流程发放日期';
comment on column GLXT_BB_SHXT_LCXX.wzhbz
  is '是否无纸化申报';
create index IDX_GLXT_BB_SHXT_LCXX1_DJXH on GLXT_BB_SHXT_LCXX (DJXH);
create index IDX_GLXT_BB_SHXT_LCXX1_LCSLID on GLXT_BB_SHXT_LCXX (LCSLID);
create index TL_BJTS.IDX_GLXT_BB_SHXT_LCXX1_SSS on GLXT_BB_SHXT_LCXX (SWJGDM, SBYWB_DM, SB_DATE);
create index IDX_GLXT_BB_SHXT_LCXX1_SWJGDM on GLXT_BB_SHXT_LCXX (SWJGDM);
create index IDX_GLXT_BB_SHXT_LCXX1_TSBLJZ on GLXT_BB_SHXT_LCXX (BLJZ_DATE, ZLC_TS_AMT);
create index IDX_GLXT_BB_SHXT_LCXX_LCJSRQ on GLXT_BB_SHXT_LCXX (NVL(LCJSRQ,TO_DATE(' 2100-12-31 00:00:00', 'syyyy-mm-dd hh24:mi:ss')));
create index IDX_GLXT_BB_SHXT_LCXX_SLDATE on GLXT_BB_SHXT_LCXX (TO_CHAR(SL_DATE,'YYYY-MM'))
  nologging;
create index IDX_GLXT_BB_SHXT_LCXX_ZLCFFRQ on GLXT_BB_SHXT_LCXX (NVL(ZLC_FFRQ,TO_DATE(' 2100-12-31 00:00:00', 'syyyy-mm-dd hh24:mi:ss')));
create index IDX_GLXT_BB_SHXT_LX_ZBSWCODE on GLXT_BB_SHXT_LCXX (ZBSWCODE);
alter table GLXT_BB_SHXT_LCXX
  add constraint PKEY_GLXT_BB_SHXT_LCXX primary key (UUID);

prompt
prompt Creating table GLXT_BB_SHXT_LCXX_202105
prompt =======================================
prompt
create table GLXT_BB_SHXT_LCXX_202105
(
  swjgdm        VARCHAR2(11),
  cpcode        VARCHAR2(32),
  sbywb_dm      VARCHAR2(8),
  sb_ym         VARCHAR2(6),
  sb_pc         VARCHAR2(4),
  lcslid        VARCHAR2(32),
  tj_jc         VARCHAR2(2),
  ck_month      VARCHAR2(6),
  sl_month      VARCHAR2(6),
  sh_month      VARCHAR2(6),
  fh_month      VARCHAR2(6),
  sp_month      VARCHAR2(6),
  hz_month      VARCHAR2(6),
  tskp_month    VARCHAR2(6),
  tstk_month    VARCHAR2(6),
  mdkp_month    VARCHAR2(6),
  mdtk_month    VARCHAR2(6),
  sb_date       DATE,
  sl_date       DATE,
  sh_date       DATE,
  pg_date       DATE,
  fh_date       DATE,
  sp_date       DATE,
  hz_date       DATE,
  ths_date      DATE,
  tskp_date     DATE,
  tstk_date     DATE,
  mdkp_date     DATE,
  mdtk_date     DATE,
  fst_hz_date   DATE,
  fst_ths_date  DATE,
  fst_tskp_date DATE,
  sl_user       VARCHAR2(32),
  sh_user       VARCHAR2(32),
  pg_user       VARCHAR2(32),
  fh_user       VARCHAR2(32),
  sp_user       VARCHAR2(32),
  hz_user       VARCHAR2(32),
  ths_user      VARCHAR2(32),
  usd_amt       NUMBER(24,4),
  rmb_amt       NUMBER(24,4),
  sl_ts_amt     NUMBER(24,4),
  sl_zzs_amt    NUMBER(24,4),
  sl_xfs_amt    NUMBER(24,4),
  sl_md_amt     NUMBER(24,4),
  sh_ts_amt     NUMBER(24,4),
  sh_zzs_amt    NUMBER(24,4),
  sh_xfs_amt    NUMBER(24,4),
  sh_md_amt     NUMBER(24,4),
  by_ts_amt     NUMBER(24,4),
  by_zzs_amt    NUMBER(24,4),
  by_xfs_amt    NUMBER(24,4),
  by_md_amt     NUMBER(24,4),
  zh_ts_amt     NUMBER(24,4),
  zh_zzs_amt    NUMBER(24,4),
  zh_xfs_amt    NUMBER(24,4),
  zh_md_amt     NUMBER(24,4),
  fh_ts_amt     NUMBER(24,4),
  fh_zzs_amt    NUMBER(24,4),
  fh_xfs_amt    NUMBER(24,4),
  fh_md_amt     NUMBER(24,4),
  sp_ts_amt     NUMBER(24,4),
  sp_zzs_amt    NUMBER(24,4),
  sp_xfs_amt    NUMBER(24,4),
  sp_md_amt     NUMBER(24,4),
  zk_ts_amt     NUMBER(24,4),
  zk_zzs_amt    NUMBER(24,4),
  zk_xfs_amt    NUMBER(24,4),
  zk_md_amt     NUMBER(24,4),
  hz_ts_amt     NUMBER(24,4),
  hz_zzs_amt    NUMBER(24,4),
  hz_xfs_amt    NUMBER(24,4),
  hz_md_amt     NUMBER(24,4),
  kp_ts_amt     NUMBER(24,4),
  kp_zzs_amt    NUMBER(24,4),
  kp_xfs_amt    NUMBER(24,4),
  kp_md_amt     NUMBER(24,4),
  tk_ts_amt     NUMBER(24,4),
  tk_zzs_amt    NUMBER(24,4),
  tk_xfs_amt    NUMBER(24,4),
  tk_md_amt     NUMBER(24,4),
  his_ts_amt    NUMBER(24,4),
  his_zzs_amt   NUMBER(24,4),
  his_xfs_amt   NUMBER(24,4),
  his_md_amt    NUMBER(24,4),
  mon_ts_amt    NUMBER(24,4),
  mon_zzs_amt   NUMBER(24,4),
  mon_xfs_amt   NUMBER(24,4),
  mon_md_amt    NUMBER(24,4),
  his_param     NUMBER(10,4) default 1,
  mon_param     NUMBER(10,4) default 1,
  his_flag      CHAR(1) default '0',
  this_ts_amt   NUMBER(24,4),
  this_zzs_amt  NUMBER(24,4),
  this_xfs_amt  NUMBER(24,4),
  this_md_amt   NUMBER(24,4),
  zbswcode      VARCHAR2(11),
  hl_ts_amt     NUMBER(24,4),
  hl_zzs_amt    NUMBER(24,4),
  hl_xfs_amt    NUMBER(24,4),
  hl_md_amt     NUMBER(24,4),
  usd_amt_bb    NUMBER(24,4),
  rmb_amt_bb    NUMBER(24,4),
  tjswcode      VARCHAR2(11),
  mon_param_v   NUMBER(10,4) default 1,
  mon_param_c   NUMBER(10,4) default 1,
  mon_param_m   NUMBER(10,4) default 1,
  his_param_v   NUMBER(10,4) default 1,
  his_param_c   NUMBER(10,4) default 1,
  his_param_m   NUMBER(10,4) default 1,
  cpcodetssh    VARCHAR2(32)
)
partition by range (SWJGDM)
(
  partition P_13300000000 values less than ('13300000000')
    tablespace TL_TSSH,
  partition P_13301000000 values less than ('13301000000')
    tablespace TL_TSSH,
  partition P_13303000000 values less than ('13303000000')
    tablespace TL_TSSH,
  partition P_13304000000 values less than ('13304000000')
    tablespace TL_TSSH,
  partition P_13305000000 values less than ('13305000000')
    tablespace TL_TSSH,
  partition P_13306000000 values less than ('13306000000')
    tablespace TL_TSSH,
  partition P_13307000000 values less than ('13307000000')
    tablespace TL_TSSH,
  partition P_13308000000 values less than ('13308000000')
    tablespace TL_TSSH,
  partition P_13309000000 values less than ('13309000000')
    tablespace TL_TSSH,
  partition P_13310000000 values less than ('13310000000')
    tablespace TL_TSSH,
  partition P_13311000000 values less than ('13311000000')
    tablespace TL_TSSH,
  partition P_MAXVALUE values less than (MAXVALUE)
    tablespace TL_TSSH
);
comment on table GLXT_BB_SHXT_LCXX_202105
  is '因审核系统数据有误需要调整数据表';
comment on column GLXT_BB_SHXT_LCXX_202105.swjgdm
  is '税务机关代码';
comment on column GLXT_BB_SHXT_LCXX_202105.cpcode
  is '审核系统企业标识';
comment on column GLXT_BB_SHXT_LCXX_202105.sbywb_dm
  is '申报业务表代码（A0000001代表2013年前无业务流程的初始数据，其他正常）';
comment on column GLXT_BB_SHXT_LCXX_202105.sb_ym
  is '申报年月';
comment on column GLXT_BB_SHXT_LCXX_202105.sb_pc
  is '申报批次';
comment on column GLXT_BB_SHXT_LCXX_202105.lcslid
  is '审核系统流程受理ID';
comment on column GLXT_BB_SHXT_LCXX_202105.tj_jc
  is '统计级次（10免退税货物20免抵退货物30周边业务40服务贸易50外贸综合服务）';
comment on column GLXT_BB_SHXT_LCXX_202105.ck_month
  is '出口月份';
comment on column GLXT_BB_SHXT_LCXX_202105.sl_month
  is '受理月份';
comment on column GLXT_BB_SHXT_LCXX_202105.sh_month
  is '审核月份';
comment on column GLXT_BB_SHXT_LCXX_202105.fh_month
  is '复核月份';
comment on column GLXT_BB_SHXT_LCXX_202105.sp_month
  is '审批月份';
comment on column GLXT_BB_SHXT_LCXX_202105.hz_month
  is '核准月份';
comment on column GLXT_BB_SHXT_LCXX_202105.tskp_month
  is '退税开票月份';
comment on column GLXT_BB_SHXT_LCXX_202105.tstk_month
  is '退税退库月份';
comment on column GLXT_BB_SHXT_LCXX_202105.mdkp_month
  is '免抵开票月份';
comment on column GLXT_BB_SHXT_LCXX_202105.mdtk_month
  is '免抵调库月份';
comment on column GLXT_BB_SHXT_LCXX_202105.sb_date
  is '申报时间';
comment on column GLXT_BB_SHXT_LCXX_202105.sl_date
  is '受理时间';
comment on column GLXT_BB_SHXT_LCXX_202105.sh_date
  is '审核时间';
comment on column GLXT_BB_SHXT_LCXX_202105.pg_date
  is '评估时间';
comment on column GLXT_BB_SHXT_LCXX_202105.fh_date
  is '复审时间';
comment on column GLXT_BB_SHXT_LCXX_202105.sp_date
  is '审批时间';
comment on column GLXT_BB_SHXT_LCXX_202105.hz_date
  is '最新核准时间（用于报表统计）';
comment on column GLXT_BB_SHXT_LCXX_202105.ths_date
  is '最新退还书生成时间（用于报表统计）';
comment on column GLXT_BB_SHXT_LCXX_202105.tskp_date
  is '最新退税开票时间（用于报表统计）';
comment on column GLXT_BB_SHXT_LCXX_202105.tstk_date
  is '退税退库时间';
comment on column GLXT_BB_SHXT_LCXX_202105.mdkp_date
  is '免抵开票时间';
comment on column GLXT_BB_SHXT_LCXX_202105.mdtk_date
  is '免抵调库时间';
comment on column GLXT_BB_SHXT_LCXX_202105.fst_hz_date
  is '首次核准时间（用于绩效考核）';
comment on column GLXT_BB_SHXT_LCXX_202105.fst_ths_date
  is '首次退还书生成时间（用于绩效考核）';
comment on column GLXT_BB_SHXT_LCXX_202105.fst_tskp_date
  is '首次退税开票时间（用于绩效考核）';
comment on column GLXT_BB_SHXT_LCXX_202105.sl_user
  is '受理人员';
comment on column GLXT_BB_SHXT_LCXX_202105.sh_user
  is '审核人员';
comment on column GLXT_BB_SHXT_LCXX_202105.pg_user
  is '评估人员';
comment on column GLXT_BB_SHXT_LCXX_202105.fh_user
  is '复审人员';
comment on column GLXT_BB_SHXT_LCXX_202105.sp_user
  is '审批人员';
comment on column GLXT_BB_SHXT_LCXX_202105.hz_user
  is '核准人员';
comment on column GLXT_BB_SHXT_LCXX_202105.ths_user
  is '退还书生成人员';
comment on column GLXT_BB_SHXT_LCXX_202105.usd_amt
  is '出口销售额（美元）';
comment on column GLXT_BB_SHXT_LCXX_202105.rmb_amt
  is '出口销售额（人民币）';
comment on column GLXT_BB_SHXT_LCXX_202105.sl_ts_amt
  is '受理免抵退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.sl_zzs_amt
  is '受理增值税退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.sl_xfs_amt
  is '受理消费税退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.sl_md_amt
  is '受理免抵税额';
comment on column GLXT_BB_SHXT_LCXX_202105.sh_ts_amt
  is '审核免抵退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.sh_zzs_amt
  is '审核增值税退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.sh_xfs_amt
  is '审核消费税退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.sh_md_amt
  is '审核免抵税额';
comment on column GLXT_BB_SHXT_LCXX_202105.by_ts_amt
  is '不予退税免抵退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.by_zzs_amt
  is '不予退税增值税退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.by_xfs_amt
  is '不予退税消费税退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.by_md_amt
  is '不予退税免抵税额';
comment on column GLXT_BB_SHXT_LCXX_202105.zh_ts_amt
  is '暂缓办理免抵退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.zh_zzs_amt
  is '暂缓办理增值税退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.zh_xfs_amt
  is '暂缓办理消费税退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.zh_md_amt
  is '暂缓办理免抵税额';
comment on column GLXT_BB_SHXT_LCXX_202105.fh_ts_amt
  is '复核免抵退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.fh_zzs_amt
  is '复核增值税退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.fh_xfs_amt
  is '复核消费税退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.fh_md_amt
  is '复核免抵税额';
comment on column GLXT_BB_SHXT_LCXX_202105.sp_ts_amt
  is '审批免抵退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.sp_zzs_amt
  is '审批增值税退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.sp_xfs_amt
  is '审批消费税退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.sp_md_amt
  is '审批免抵税额';
comment on column GLXT_BB_SHXT_LCXX_202105.zk_ts_amt
  is '暂扣退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.zk_zzs_amt
  is '暂扣增值税退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.zk_xfs_amt
  is '暂扣消费税退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.zk_md_amt
  is '暂扣免抵税额';
comment on column GLXT_BB_SHXT_LCXX_202105.hz_ts_amt
  is '核准免抵退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.hz_zzs_amt
  is '核准增值税退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.hz_xfs_amt
  is '核准消费税退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.hz_md_amt
  is '核准免抵税额';
comment on column GLXT_BB_SHXT_LCXX_202105.kp_ts_amt
  is '送交国库免抵退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.kp_zzs_amt
  is '送交国库增值税退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.kp_xfs_amt
  is '送交国库消费税退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.kp_md_amt
  is '送交国库免抵税额';
comment on column GLXT_BB_SHXT_LCXX_202105.tk_ts_amt
  is '国库办理免抵退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.tk_zzs_amt
  is '国库办理增值税退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.tk_xfs_amt
  is '国库办理消费税退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.tk_md_amt
  is '国库办理免抵税额';
comment on column GLXT_BB_SHXT_LCXX_202105.his_ts_amt
  is '历史年份已办理免抵退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.his_zzs_amt
  is '历史年份已办理增值税退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.his_xfs_amt
  is '历史年份已办理消费税退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.his_md_amt
  is '历史年份已办理免抵税额';
comment on column GLXT_BB_SHXT_LCXX_202105.mon_ts_amt
  is '历史月份已办理免抵退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.mon_zzs_amt
  is '历史月份已办理增值税退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.mon_xfs_amt
  is '历史月份已办理消费税退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.mon_md_amt
  is '历史月份已办理免抵税额';
comment on column GLXT_BB_SHXT_LCXX_202105.his_param
  is '剔除历史年份退税剩余比例';
comment on column GLXT_BB_SHXT_LCXX_202105.mon_param
  is '本月免抵退占比';
comment on column GLXT_BB_SHXT_LCXX_202105.his_flag
  is '历史全部完成标志（历史年份已全额6正常7冲红8取消暂缓，历史月份已全额1正常2冲红3取消暂缓，0未结束）';
comment on column GLXT_BB_SHXT_LCXX_202105.this_ts_amt
  is '本月办理免抵退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.this_zzs_amt
  is '本月办理增值税退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.this_xfs_amt
  is '本月办理消费税退税额';
comment on column GLXT_BB_SHXT_LCXX_202105.this_md_amt
  is '本月办理免抵税额';
comment on column GLXT_BB_SHXT_LCXX_202105.zbswcode
  is '指标税务机关';
comment on column GLXT_BB_SHXT_LCXX_202105.hl_ts_amt
  is '忽略退免税额';
comment on column GLXT_BB_SHXT_LCXX_202105.hl_zzs_amt
  is '忽略增值税';
comment on column GLXT_BB_SHXT_LCXX_202105.hl_xfs_amt
  is '忽略消费税';
comment on column GLXT_BB_SHXT_LCXX_202105.hl_md_amt
  is '忽略免抵额';
comment on column GLXT_BB_SHXT_LCXX_202105.usd_amt_bb
  is '出口销售额（美元）,扣除进料加工料件';
comment on column GLXT_BB_SHXT_LCXX_202105.rmb_amt_bb
  is '出口销售额（人民币）,扣除进料加工料件';
comment on column GLXT_BB_SHXT_LCXX_202105.tjswcode
  is '统计税务机关';
comment on column GLXT_BB_SHXT_LCXX_202105.mon_param_v
  is '增值税-本月占比';
comment on column GLXT_BB_SHXT_LCXX_202105.mon_param_c
  is '消费税-本月占比';
comment on column GLXT_BB_SHXT_LCXX_202105.mon_param_m
  is '免抵额-本月占比';
comment on column GLXT_BB_SHXT_LCXX_202105.his_param_v
  is '增值税-剔除历史年份退税剩余比例';
comment on column GLXT_BB_SHXT_LCXX_202105.his_param_c
  is '消费税-剔除历史年份退税剩余比例';
comment on column GLXT_BB_SHXT_LCXX_202105.his_param_m
  is '免抵额-剔除历史年份退税剩余比例';
comment on column GLXT_BB_SHXT_LCXX_202105.cpcodetssh
  is '审核系统企业标识';
create index IDX_GLXT_BB_SHXT_LCXX_CPCODE on GLXT_BB_SHXT_LCXX_202105 (CPCODE)
  nologging;
create index IDX_GLXT_BB_SHXT_LCXX_HISFLAG on GLXT_BB_SHXT_LCXX_202105 (HIS_FLAG)
  nologging;
create index IDX_GLXT_BB_SHXT_LCXX_LCSLID on GLXT_BB_SHXT_LCXX_202105 (LCSLID)
  nologging;
create index IDX_GLXT_BB_SHXT_LCXX_SBYWB on GLXT_BB_SHXT_LCXX_202105 (SBYWB_DM)
  nologging;
create index IDX_GLXT_BB_SHXT_LCXX_SWJGDM on GLXT_BB_SHXT_LCXX_202105 (SWJGDM)
  nologging;
create index IDX_GLXT_BB_SHXT_LCXX_TJCODE on GLXT_BB_SHXT_LCXX_202105 (TJSWCODE)
  nologging;
create index IDX_GLXT_BB_SHXT_LCXX_TJJC on GLXT_BB_SHXT_LCXX_202105 (TJ_JC)
  nologging;
create index IDX_GLXT_BB_SHXT_LCXX_TS on GLXT_BB_SHXT_LCXX_202105 (TJSWCODE, SL_MONTH)
  nologging;
create index IDX_GLXT_BB_SHXT_LCXX_ZBJGDM on GLXT_BB_SHXT_LCXX_202105 (ZBSWCODE)
  nologging;

prompt
prompt Creating table GLXT_BB_SHXT_LCXX_SUB_202105
prompt ===========================================
prompt
create table GLXT_BB_SHXT_LCXX_SUB_202105
(
  swjgdm   VARCHAR2(11),
  cpcode   VARCHAR2(32),
  lcslid   VARCHAR2(32),
  ywlx     VARCHAR2(2),
  ym       VARCHAR2(6),
  sz       VARCHAR2(4),
  ths_date DATE,
  ths_user VARCHAR2(32),
  kp_date  DATE,
  tk_date  DATE,
  kp_amt   NUMBER(24,4),
  tk_amt   NUMBER(24,4),
  zbswcode VARCHAR2(11),
  sp_amt   NUMBER(24,4),
  ms_id    INTEGER,
  item_no  VARCHAR2(10),
  no       VARCHAR2(50),
  cno      VARCHAR2(18)
)
partition by range (SWJGDM)
(
  partition P_13300000000 values less than ('13300000000')
    tablespace TL_TSSH,
  partition P_13301000000 values less than ('13301000000')
    tablespace TL_TSSH,
  partition P_13303000000 values less than ('13303000000')
    tablespace TL_TSSH,
  partition P_13304000000 values less than ('13304000000')
    tablespace TL_TSSH,
  partition P_13305000000 values less than ('13305000000')
    tablespace TL_TSSH,
  partition P_13306000000 values less than ('13306000000')
    tablespace TL_TSSH,
  partition P_13307000000 values less than ('13307000000')
    tablespace TL_TSSH,
  partition P_13308000000 values less than ('13308000000')
    tablespace TL_TSSH,
  partition P_13309000000 values less than ('13309000000')
    tablespace TL_TSSH,
  partition P_13310000000 values less than ('13310000000')
    tablespace TL_TSSH,
  partition P_13311000000 values less than ('13311000000')
    tablespace TL_TSSH,
  partition P_MAXVALUE values less than (MAXVALUE)
    tablespace TL_TSSH
);
comment on table GLXT_BB_SHXT_LCXX_SUB_202105
  is '管理系统报表数据抽取用的中间表';
comment on column GLXT_BB_SHXT_LCXX_SUB_202105.swjgdm
  is '税务机关代码';
comment on column GLXT_BB_SHXT_LCXX_SUB_202105.cpcode
  is '审核系统企业标识';
comment on column GLXT_BB_SHXT_LCXX_SUB_202105.lcslid
  is '审核系统流程受理ID';
comment on column GLXT_BB_SHXT_LCXX_SUB_202105.ywlx
  is '业务类型:HW,FW';
comment on column GLXT_BB_SHXT_LCXX_SUB_202105.ym
  is '申报年月';
comment on column GLXT_BB_SHXT_LCXX_SUB_202105.sz
  is '税种:V,C,M';
comment on column GLXT_BB_SHXT_LCXX_SUB_202105.ths_date
  is '退还书生成时间';
comment on column GLXT_BB_SHXT_LCXX_SUB_202105.ths_user
  is '退还书生成人员';
comment on column GLXT_BB_SHXT_LCXX_SUB_202105.kp_date
  is '开票时间';
comment on column GLXT_BB_SHXT_LCXX_SUB_202105.tk_date
  is '退库调库时间';
comment on column GLXT_BB_SHXT_LCXX_SUB_202105.kp_amt
  is '开票税额';
comment on column GLXT_BB_SHXT_LCXX_SUB_202105.tk_amt
  is '国库税额';
comment on column GLXT_BB_SHXT_LCXX_SUB_202105.zbswcode
  is '指标税务机关代码';
comment on column GLXT_BB_SHXT_LCXX_SUB_202105.sp_amt
  is '审批税额';
create index IDX_GLXT_BB_LCXX_SUB_CPCODE on GLXT_BB_SHXT_LCXX_SUB_202105 (CPCODE);
create index IDX_GLXT_BB_LCXX_SUB_MIS on GLXT_BB_SHXT_LCXX_SUB_202105 (MS_ID, ITEM_NO, SZ);
create index IDX_GLXT_BB_LCXX_SUB_ZBCODE on GLXT_BB_SHXT_LCXX_SUB_202105 (ZBSWCODE);
create index IDX_PGLXT_BB_LCXX_SUB_LCSLID on GLXT_BB_SHXT_LCXX_SUB_202105 (LCSLID);
create index IDX_PGLXT_BB_LCXX_SUB_SWJGDM on GLXT_BB_SHXT_LCXX_SUB_202105 (SWJGDM);

prompt
prompt Creating table INTERFACE_ENTERPRISE_DECLARE
prompt ===========================================
prompt
create table INTERFACE_ENTERPRISE_DECLARE
(
  id          NUMBER(18) not null,
  name        VARCHAR2(200) not null,
  scc         VARCHAR2(20) not null,
  declaredate DATE not null,
  goodinfo    VARCHAR2(4000) not null,
  pushtime    DATE not null,
  bizid       VARCHAR2(40) not null,
  jgbz        CHAR(1) not null
)
;
comment on table INTERFACE_ENTERPRISE_DECLARE
  is '企业商品申报信息表';
comment on column INTERFACE_ENTERPRISE_DECLARE.id
  is '序号';
comment on column INTERFACE_ENTERPRISE_DECLARE.name
  is '企业名称';
comment on column INTERFACE_ENTERPRISE_DECLARE.scc
  is '社会信用代码';
comment on column INTERFACE_ENTERPRISE_DECLARE.declaredate
  is '申报时间';
comment on column INTERFACE_ENTERPRISE_DECLARE.goodinfo
  is '商品名称列表，逗号分割';
comment on column INTERFACE_ENTERPRISE_DECLARE.pushtime
  is '推送时间';
comment on column INTERFACE_ENTERPRISE_DECLARE.bizid
  is '推送请求UUID';
comment on column INTERFACE_ENTERPRISE_DECLARE.jgbz
  is '0正常 1商品超长截断';
create index IDX_T_DECLARATION_DECLAREDATE on INTERFACE_ENTERPRISE_DECLARE (DECLAREDATE);
create index IDX_T_DECLARATION_PUSHTIME on INTERFACE_ENTERPRISE_DECLARE (PUSHTIME);
alter table INTERFACE_ENTERPRISE_DECLARE
  add constraint PK_INTER_ENTER_DECLARE primary key (ID);

prompt
prompt Creating table INTERFACE_ENTERPRISE_RECORD
prompt ==========================================
prompt
create table INTERFACE_ENTERPRISE_RECORD
(
  id       NUMBER(18) not null,
  name     VARCHAR2(200) not null,
  scc      VARCHAR2(20) not null,
  rgdate   DATE not null,
  pushtime DATE not null,
  bizid    VARCHAR2(40) not null
)
;
comment on table INTERFACE_ENTERPRISE_RECORD
  is '企业海关备案信息表';
comment on column INTERFACE_ENTERPRISE_RECORD.id
  is '序号';
comment on column INTERFACE_ENTERPRISE_RECORD.name
  is '企业名称';
comment on column INTERFACE_ENTERPRISE_RECORD.scc
  is '社会信用代码';
comment on column INTERFACE_ENTERPRISE_RECORD.rgdate
  is '海关备案日期';
comment on column INTERFACE_ENTERPRISE_RECORD.pushtime
  is '推送时间';
comment on column INTERFACE_ENTERPRISE_RECORD.bizid
  is '推送请求UUID';
create index IDX_T_ENTERPRISE_BIZID on INTERFACE_ENTERPRISE_RECORD (BIZID);
create index IDX_T_ENTERPRISE_RGDATE on INTERFACE_ENTERPRISE_RECORD (RGDATE);
create unique index UN_T_SCC on INTERFACE_ENTERPRISE_RECORD (SCC);
alter table INTERFACE_ENTERPRISE_RECORD
  add constraint PK_T_ENTERPRISE_CUSTOMS primary key (ID);

prompt
prompt Creating table INTERFACE_PENDING_NSRSBH
prompt =======================================
prompt
create table INTERFACE_PENDING_NSRSBH
(
  nsrsbh VARCHAR2(20) not null,
  djrq   DATE,
  jyfw   VARCHAR2(3600),
  nsrmc  VARCHAR2(300),
  clzt   VARCHAR2(2)
)
;
comment on table INTERFACE_PENDING_NSRSBH
  is '口岸推送待处理纳税人信息表';
comment on column INTERFACE_PENDING_NSRSBH.nsrsbh
  is '纳税人识别号';
comment on column INTERFACE_PENDING_NSRSBH.djrq
  is '登记日期';
comment on column INTERFACE_PENDING_NSRSBH.jyfw
  is '经营范围';
comment on column INTERFACE_PENDING_NSRSBH.nsrmc
  is '纳税人名称';
comment on column INTERFACE_PENDING_NSRSBH.clzt
  is '处理状态';
alter table INTERFACE_PENDING_NSRSBH
  add constraint PK_INTERFACE_PENDING_NSRSBH primary key (NSRSBH);

prompt
prompt Creating table INTERFACE_PUSH_NSRSBH
prompt ====================================
prompt
create table INTERFACE_PUSH_NSRSBH
(
  id        NUMBER(18) not null,
  nsrsbh    VARCHAR2(21),
  push_time DATE
)
;
comment on table INTERFACE_PUSH_NSRSBH
  is '接口发送纳税人表';
create index IDX_PUSHTIME on INTERFACE_PUSH_NSRSBH (PUSH_TIME);
create unique index UQ_NSRSBH on INTERFACE_PUSH_NSRSBH (NSRSBH);
alter table INTERFACE_PUSH_NSRSBH
  add constraint PK_PUSH_NSRSBH primary key (ID);

prompt
prompt Creating table INTERFACE_SEND_DATA
prompt ==================================
prompt
create table INTERFACE_SEND_DATA
(
  bizid    VARCHAR2(50) not null,
  request  BLOB not null,
  response BLOB
)
;
alter table INTERFACE_SEND_DATA
  add constraint PK_BIZID primary key (BIZID);

prompt
prompt Creating table INTERFACE_SEND_LOG
prompt =================================
prompt
create table INTERFACE_SEND_LOG
(
  id        NUMBER(18) not null,
  bizcode   VARCHAR2(30),
  appid     VARCHAR2(30),
  bizid     VARCHAR2(50) not null,
  timestamp VARCHAR2(30),
  sign      VARCHAR2(100),
  reqtime   DATE,
  rsptime   DATE,
  clbz      CHAR(1),
  client_ip VARCHAR2(45)
)
;
comment on table INTERFACE_SEND_LOG
  is '接口发送日志表';
comment on column INTERFACE_SEND_LOG.id
  is '序号：主键';
comment on column INTERFACE_SEND_LOG.bizcode
  is '业务代码';
comment on column INTERFACE_SEND_LOG.appid
  is '第三方应用标';
comment on column INTERFACE_SEND_LOG.bizid
  is '业务唯一标识';
comment on column INTERFACE_SEND_LOG.timestamp
  is '请求参数-时间戳';
comment on column INTERFACE_SEND_LOG.sign
  is '请求参数-签名';
comment on column INTERFACE_SEND_LOG.reqtime
  is '请求时间';
comment on column INTERFACE_SEND_LOG.rsptime
  is '响应时间';
comment on column INTERFACE_SEND_LOG.clbz
  is '处理标志，1成功 0失败';
comment on column INTERFACE_SEND_LOG.client_ip
  is '客户端IP';
create index IDX_INTERFACE_SEND_LOG_APPID on INTERFACE_SEND_LOG (APPID);
create index IDX_INTERFACE_SEND_LOG_REQTIME on INTERFACE_SEND_LOG (REQTIME);
alter table INTERFACE_SEND_LOG
  add constraint PK_INTERFACE_SEND_LOG primary key (ID);
alter table INTERFACE_SEND_LOG
  add constraint UK_INTERFACE_SEND_LOG_BIZID unique (BIZID);

prompt
prompt Creating table INTERFACE_SERVICE_PROFILE
prompt ========================================
prompt
create table INTERFACE_SERVICE_PROFILE
(
  id       NUMBER(10) not null,
  servname VARCHAR2(100) not null,
  servurl  VARCHAR2(200),
  appid    VARCHAR2(30) not null,
  appkey   VARCHAR2(100) not null,
  ipset    VARCHAR2(500),
  yxbz     CHAR(1) not null,
  note     VARCHAR2(100),
  lasttime DATE
)
;
comment on table INTERFACE_SERVICE_PROFILE
  is '接口服务信息表';
comment on column INTERFACE_SERVICE_PROFILE.id
  is '序号';
comment on column INTERFACE_SERVICE_PROFILE.servname
  is '接口服务名称';
comment on column INTERFACE_SERVICE_PROFILE.servurl
  is '接口服务地址';
comment on column INTERFACE_SERVICE_PROFILE.appid
  is '第三方应用标识';
comment on column INTERFACE_SERVICE_PROFILE.appkey
  is '密钥（用于签名）';
comment on column INTERFACE_SERVICE_PROFILE.ipset
  is '预留于IP白名单，用逗号分割';
comment on column INTERFACE_SERVICE_PROFILE.yxbz
  is 'Y有效 N无效';
comment on column INTERFACE_SERVICE_PROFILE.note
  is '备注描述';
comment on column INTERFACE_SERVICE_PROFILE.lasttime
  is '最近一次处理时间';
create index IDX_APPID on INTERFACE_SERVICE_PROFILE (APPID);
alter table INTERFACE_SERVICE_PROFILE
  add constraint PK_INTERFACE_SERVICE_PROFILE primary key (ID);
alter table INTERFACE_SERVICE_PROFILE
  add constraint UK_INTERFACE_SERVICE_PROFILE unique (SERVNAME, APPID);

prompt
prompt Creating table JCFX_CS_CGHW
prompt ===========================
prompt
create table JCFX_CS_CGHW
(
  swjgdm VARCHAR2(11) not null,
  spbm   VARCHAR2(100) not null
)
;
comment on table JCFX_CS_CGHW
  is '各地区常规货物表';
comment on column JCFX_CS_CGHW.swjgdm
  is '主管税务机关';
comment on column JCFX_CS_CGHW.spbm
  is '商品税目编码';

prompt
prompt Creating table JCFX_CS_MGKA
prompt ===========================
prompt
create table JCFX_CS_MGKA
(
  swjgdm    VARCHAR2(11) not null,
  hggqka_dm CHAR(4) not null
)
;
comment on table JCFX_CS_MGKA
  is '各地区敏感口岸表';
comment on column JCFX_CS_MGKA.swjgdm
  is '主管税务机关';
comment on column JCFX_CS_MGKA.hggqka_dm
  is '出口口岸';

prompt
prompt Creating table JCFX_CS_MGSP
prompt ===========================
prompt
create table JCFX_CS_MGSP
(
  swjgdm  VARCHAR2(11) not null,
  cksp_dm VARCHAR2(20) not null
)
;
comment on table JCFX_CS_MGSP
  is '各地区敏感商品表';
comment on column JCFX_CS_MGSP.swjgdm
  is '主管税务机关';
comment on column JCFX_CS_MGSP.cksp_dm
  is '出口商品代码';

prompt
prompt Creating table JCFX_CS_TABLE
prompt ============================
prompt
create table JCFX_CS_TABLE
(
  tablename   VARCHAR2(30) not null,
  cname       VARCHAR2(50) not null,
  dtalias     VARCHAR2(10) not null,
  tabletype   VARCHAR2(1) not null,
  relation    VARCHAR2(20),
  dependtable VARCHAR2(30),
  qybz        VARCHAR2(1) default 'Y' not null
)
;
comment on table JCFX_CS_TABLE
  is '表对象定义表';
comment on column JCFX_CS_TABLE.tablename
  is '表名';
comment on column JCFX_CS_TABLE.cname
  is '表中文名';
comment on column JCFX_CS_TABLE.dtalias
  is '数据表别名';
comment on column JCFX_CS_TABLE.tabletype
  is '表类型';
comment on column JCFX_CS_TABLE.relation
  is '关系字段';
comment on column JCFX_CS_TABLE.dependtable
  is '依赖表';
comment on column JCFX_CS_TABLE.qybz
  is '启用标志';
alter table JCFX_CS_TABLE
  add constraint PK_JCFX_CS_TABLE primary key (TABLENAME);

prompt
prompt Creating table JCFX_CS_TSSP
prompt ===========================
prompt
create table JCFX_CS_TSSP
(
  swjgdm  VARCHAR2(11) not null,
  cksp_dm VARCHAR2(20) not null
)
;
comment on table JCFX_CS_TSSP
  is '各地区特殊商品表';
comment on column JCFX_CS_TSSP.swjgdm
  is '主管税务机关';
comment on column JCFX_CS_TSSP.cksp_dm
  is '出口商品代码';

prompt
prompt Creating table JCFX_CS_ZBDL
prompt ===========================
prompt
create table JCFX_CS_ZBDL
(
  zbdlbm VARCHAR2(1) not null,
  zbdlmc VARCHAR2(50) not null,
  lx     VARCHAR2(1) not null
)
;
comment on table JCFX_CS_ZBDL
  is '指标大类表';
comment on column JCFX_CS_ZBDL.zbdlbm
  is '指标大类编码';
comment on column JCFX_CS_ZBDL.zbdlmc
  is '指标大类名称';
comment on column JCFX_CS_ZBDL.lx
  is '类型';
alter table JCFX_CS_ZBDL
  add constraint PK_JCFX_CS_ZBDL primary key (ZBDLBM);

prompt
prompt Creating table JCFX_CS_ZBXM
prompt ===========================
prompt
create table JCFX_CS_ZBXM
(
  zbdlbm    VARCHAR2(1) not null,
  zbxmbm    VARCHAR2(20) not null,
  zbxmmc    VARCHAR2(50) not null,
  field     VARCHAR2(20) not null,
  datatable VARCHAR2(30),
  dicttable VARCHAR2(30),
  isvalid   CHAR(1) default 1,
  format    VARCHAR2(20),
  isshow    CHAR(1),
  pxno      VARCHAR2(30)
)
;
comment on table JCFX_CS_ZBXM
  is '指标项目表';
comment on column JCFX_CS_ZBXM.zbdlbm
  is '指标大类编码';
comment on column JCFX_CS_ZBXM.zbxmbm
  is '指标项目编码';
comment on column JCFX_CS_ZBXM.zbxmmc
  is '指标项目名称';
comment on column JCFX_CS_ZBXM.field
  is '字段名';
comment on column JCFX_CS_ZBXM.datatable
  is '数据表全名';
comment on column JCFX_CS_ZBXM.dicttable
  is '字典表名';
comment on column JCFX_CS_ZBXM.isvalid
  is '是否有效项';
comment on column JCFX_CS_ZBXM.format
  is '格式化样式';
comment on column JCFX_CS_ZBXM.isshow
  is '是否显示';
comment on column JCFX_CS_ZBXM.pxno
  is '排序序号';
alter table JCFX_CS_ZBXM
  add constraint PK_JCFX_CS_ZBXM primary key (ZBXMBM);

prompt
prompt Creating table JCFX_CS_ZDYXM
prompt ============================
prompt
create table JCFX_CS_ZDYXM
(
  zid        NUMBER(10) not null,
  zdyname    VARCHAR2(50) not null,
  ss_swjg_dm VARCHAR2(11) not null,
  ss_zbxmbm  VARCHAR2(10) not null,
  syfw_swjg  VARCHAR2(11) not null,
  qybz       VARCHAR2(1) not null,
  xgr        VARCHAR2(30),
  xgsj       DATE
)
;
comment on table JCFX_CS_ZDYXM
  is '自定义项目主表';
comment on column JCFX_CS_ZDYXM.zid
  is '序号';
comment on column JCFX_CS_ZDYXM.zdyname
  is '自定义项目名';
comment on column JCFX_CS_ZDYXM.ss_swjg_dm
  is '归属税务机关';
comment on column JCFX_CS_ZDYXM.ss_zbxmbm
  is '指标项目编码';
comment on column JCFX_CS_ZDYXM.syfw_swjg
  is '适用范围';
comment on column JCFX_CS_ZDYXM.qybz
  is '启用标志';
comment on column JCFX_CS_ZDYXM.xgr
  is '创建/修改人';
comment on column JCFX_CS_ZDYXM.xgsj
  is '修改时间';
alter table JCFX_CS_ZDYXM
  add constraint PK_JCFX_CS_ZDYXM primary key (ZID);

prompt
prompt Creating table JCFX_CS_ZDYXM_SUB
prompt ================================
prompt
create table JCFX_CS_ZDYXM_SUB
(
  id   NUMBER(10) not null,
  zid  NUMBER(10) not null,
  dm   VARCHAR2(20) not null,
  mc   VARCHAR2(50),
  qybz VARCHAR2(1) not null
)
;
comment on table JCFX_CS_ZDYXM_SUB
  is '自定义项目子表';
comment on column JCFX_CS_ZDYXM_SUB.id
  is '序号';
comment on column JCFX_CS_ZDYXM_SUB.zid
  is '主表序号';
comment on column JCFX_CS_ZDYXM_SUB.dm
  is '代码';
comment on column JCFX_CS_ZDYXM_SUB.mc
  is '名称';
comment on column JCFX_CS_ZDYXM_SUB.qybz
  is '启用标志';
alter table JCFX_CS_ZDYXM_SUB
  add constraint PK_JCFX_CS_ZDYXM_SUB primary key (ID);

prompt
prompt Creating table JCFX_DATA_BGDMX
prompt ==============================
prompt
create table JCFX_DATA_BGDMX
(
  uuid       VARCHAR2(32) not null,
  tsswjg_dm  CHAR(11) not null,
  djxh       NUMBER(20) not null,
  ckbgdh     VARCHAR2(21) not null,
  ny         CHAR(6),
  ckrq       DATE,
  cksp_dm    VARCHAR2(20),
  hggqka_dm  CHAR(4),
  mygdqsz_dm CHAR(3),
  jgfs_dm    CHAR(4),
  hzdwdq_dm  CHAR(5),
  hydxzqh_dm CHAR(4),
  mylaj      NUMBER(18,2),
  mylaj_zs   NUMBER(18,2) default 0,
  mylaj_ms   NUMBER(18,2) default 0,
  mylaj_bts  NUMBER(18,2) default 0,
  mylaj_kts  NUMBER(18,2) default 0,
  mylaj_ysb  NUMBER(18,2),
  rmblaj     NUMBER(18,2),
  tsl        NUMBER(10,6) default 0,
  ygtmse     NUMBER(18,2) default 0,
  sjgxsj     DATE
)
partition by range (TSSWJG_DM)
(
  partition P_13300000000 values less than ('13301000000')
    tablespace TL_TSSH,
  partition P_13301000000 values less than ('13303000000')
    tablespace TL_TSSH,
  partition P_13303000000 values less than ('13304000000')
    tablespace TL_TSSH,
  partition P_13304000000 values less than ('13305000000')
    tablespace TL_TSSH,
  partition P_13305000000 values less than ('13306000000')
    tablespace TL_TSSH,
  partition P_13306000000 values less than ('13307000000')
    tablespace TL_TSSH,
  partition P_13307000000 values less than ('13308000000')
    tablespace TL_TSSH,
  partition P_13308000000 values less than ('13309000000')
    tablespace TL_TSSH,
  partition P_13309000000 values less than ('13310000000')
    tablespace TL_TSSH,
  partition P_13310000000 values less than ('13311000000')
    tablespace TL_TSSH,
  partition P_13311000000 values less than (MAXVALUE)
    tablespace TL_TSSH
);
comment on table JCFX_DATA_BGDMX
  is '出口报关单明细表，202412停止更新，相关字段并入CKTS_WBSJ_HG_BGD';
comment on column JCFX_DATA_BGDMX.tsswjg_dm
  is '税务机关';
comment on column JCFX_DATA_BGDMX.djxh
  is '登记序号';
comment on column JCFX_DATA_BGDMX.ckbgdh
  is '21位报关单号';
comment on column JCFX_DATA_BGDMX.ny
  is '出口年月';
comment on column JCFX_DATA_BGDMX.ckrq
  is '出口日期';
comment on column JCFX_DATA_BGDMX.cksp_dm
  is '出口商品代码';
comment on column JCFX_DATA_BGDMX.hggqka_dm
  is '出口口岸';
comment on column JCFX_DATA_BGDMX.mygdqsz_dm
  is '出口国别';
comment on column JCFX_DATA_BGDMX.jgfs_dm
  is '贸易方式';
comment on column JCFX_DATA_BGDMX.hzdwdq_dm
  is '境内货源地';
comment on column JCFX_DATA_BGDMX.hydxzqh_dm
  is '货源地行政区划';
comment on column JCFX_DATA_BGDMX.mylaj
  is '出口销售（美元）';
comment on column JCFX_DATA_BGDMX.mylaj_zs
  is '出口销售（征税）';
comment on column JCFX_DATA_BGDMX.mylaj_ms
  is '出口销售（免税）';
comment on column JCFX_DATA_BGDMX.mylaj_bts
  is '出口销售（不退税）';
comment on column JCFX_DATA_BGDMX.mylaj_kts
  is '出口销售（可退税）';
comment on column JCFX_DATA_BGDMX.mylaj_ysb
  is '出口销售（已申报）';
comment on column JCFX_DATA_BGDMX.rmblaj
  is '出口销售（人民币）';
comment on column JCFX_DATA_BGDMX.tsl
  is '退税率（征免不按0，其他按文库）';
comment on column JCFX_DATA_BGDMX.ygtmse
  is '预估退免税额';
comment on column JCFX_DATA_BGDMX.sjgxsj
  is '数据更新时间';
create index IDX_JCFX_DATA_BGDMX_CKRQ on JCFX_DATA_BGDMX (CKRQ);
create index IDX_JCFX_DATA_BGDMX_SJGXSJ on JCFX_DATA_BGDMX (SJGXSJ);
alter table JCFX_DATA_BGDMX
  add constraint PK_JCFX_DATA_BGDMX primary key (DJXH, CKBGDH);

prompt
prompt Creating table JCFX_DATA_FPDFQYYHZ
prompt ==================================
prompt
create table JCFX_DATA_FPDFQYYHZ
(
  djxh       NUMBER(20) not null,
  ny         CHAR(6) not null,
  kplx       CHAR(1) not null,
  dfnsrsbh   VARCHAR2(20) not null,
  dfnsrmc    VARCHAR2(300),
  fps        NUMBER(10),
  je         NUMBER(18,2),
  se         NUMBER(18,2),
  zyspsm     VARCHAR2(30),
  zyspmc     VARCHAR2(300),
  zyspje     NUMBER(18,2),
  zysp_zblv  NUMBER(6,2),
  dffpzgkpxe NUMBER(18,2),
  fps_dgkj   NUMBER(10),
  je_dgkj    NUMBER(18,2),
  se_dgkj    NUMBER(18,2),
  sjgxsj     DATE,
  sp_zt      CHAR(1),
  sp_sj      DATE
)
;
comment on table JCFX_DATA_FPDFQYYHZ
  is '发票对方企业（上下游/专票）月汇总表';
comment on column JCFX_DATA_FPDFQYYHZ.djxh
  is '登记序号';
comment on column JCFX_DATA_FPDFQYYHZ.ny
  is '年月';
comment on column JCFX_DATA_FPDFQYYHZ.kplx
  is '开票类型 X 上游销货 G 下游购货';
comment on column JCFX_DATA_FPDFQYYHZ.dfnsrsbh
  is '对方税号';
comment on column JCFX_DATA_FPDFQYYHZ.dfnsrmc
  is '对方名称';
comment on column JCFX_DATA_FPDFQYYHZ.fps
  is '发票份数（专票）';
comment on column JCFX_DATA_FPDFQYYHZ.je
  is '金额合计（专票）';
comment on column JCFX_DATA_FPDFQYYHZ.se
  is '税额合计（专票）';
comment on column JCFX_DATA_FPDFQYYHZ.zyspsm
  is '主要商品税目';
comment on column JCFX_DATA_FPDFQYYHZ.zyspmc
  is '主要商品名称';
comment on column JCFX_DATA_FPDFQYYHZ.zyspje
  is '主要商品金额';
comment on column JCFX_DATA_FPDFQYYHZ.zysp_zblv
  is '主要商品占比';
comment on column JCFX_DATA_FPDFQYYHZ.dffpzgkpxe
  is '单份发票开票限额（专票）';
comment on column JCFX_DATA_FPDFQYYHZ.fps_dgkj
  is '发票份数（专票）_顶格开具';
comment on column JCFX_DATA_FPDFQYYHZ.je_dgkj
  is '金额合计（专票）_顶格开具';
comment on column JCFX_DATA_FPDFQYYHZ.se_dgkj
  is '税额合计（专票）_顶格开具';
comment on column JCFX_DATA_FPDFQYYHZ.sjgxsj
  is '数据更新时间';
comment on column JCFX_DATA_FPDFQYYHZ.sp_zt
  is '商品更新状态';
comment on column JCFX_DATA_FPDFQYYHZ.sp_sj
  is '商品更新时间';
alter table JCFX_DATA_FPDFQYYHZ
  add constraint PK_JCFX_DATA_FPDFQYYHZ primary key (DJXH, NY, KPLX, DFNSRSBH);

prompt
prompt Creating table JCFX_DATA_KPQYJCXX
prompt =================================
prompt
create table JCFX_DATA_KPQYJCXX
(
  nsrsbh    VARCHAR2(20) not null,
  nsrmc     VARCHAR2(300) not null,
  zgswjg_dm VARCHAR2(11),
  xzqh_dm   VARCHAR2(4),
  nsrzt_dm  CHAR(2),
  fxqybz    CHAR(1) default 'N' not null,
  sjgxsj    DATE
)
;
comment on table JCFX_DATA_KPQYJCXX
  is '开票企业基础信息表';
comment on column JCFX_DATA_KPQYJCXX.nsrsbh
  is '纳税人识别号';
comment on column JCFX_DATA_KPQYJCXX.nsrmc
  is '纳税人名称';
comment on column JCFX_DATA_KPQYJCXX.zgswjg_dm
  is '主管税务机关';
comment on column JCFX_DATA_KPQYJCXX.xzqh_dm
  is '行政区划';
comment on column JCFX_DATA_KPQYJCXX.nsrzt_dm
  is '纳税人状态';
comment on column JCFX_DATA_KPQYJCXX.fxqybz
  is '风险企业标志';
comment on column JCFX_DATA_KPQYJCXX.sjgxsj
  is '数据更新时间';
alter table JCFX_DATA_KPQYJCXX
  add constraint PK_JCFX_DATA_KPQYJCXX primary key (NSRSBH);

prompt
prompt Creating table JCFX_DATA_QYYHZ
prompt ==============================
prompt
create table JCFX_DATA_QYYHZ
(
  djxh             NUMBER(20) not null,
  ny               CHAR(6) not null,
  nsrsbh           VARCHAR2(20),
  shxydm           VARCHAR2(20),
  fp_xxfs_zy       NUMBER(10),
  fp_xxje_zy       NUMBER(18,2),
  fp_xxfs_dgkj     NUMBER(10),
  fp_xxje_dgkj     NUMBER(18,2),
  fp_xxfs_pt       NUMBER(10),
  fp_xxje_pt       NUMBER(18,2),
  fp_xxfs_ck       NUMBER(10),
  fp_xxje_ck       NUMBER(18,2),
  fp_xxje_ncp      NUMBER(18,2),
  fp_xxje_dianfei  NUMBER(18,2),
  fp_jxfs_zy       NUMBER(10),
  fp_jxje_zy       NUMBER(18,2),
  fp_jxfs_dgkj     NUMBER(18,2),
  fp_jxje_dgkj     NUMBER(18,2),
  fp_jxje_ds       NUMBER(18,2),
  fp_jxje_sn       NUMBER(18,2),
  fp_jxje_sw       NUMBER(18,2),
  fp_jxfs_pt       NUMBER(10),
  fp_jxje_pt       NUMBER(18,2),
  fp_jxje_cghwydcg NUMBER(18,2),
  fp_jxje_dianfei  NUMBER(18,2),
  fp_jxje_ysf      NUMBER(18,2),
  cz_gdzc          NUMBER(18,2),
  cz_ch            NUMBER(18,2),
  cz_yfzk          NUMBER(18,2),
  cz_qtysk         NUMBER(18,2),
  cz_zczz          NUMBER(18,2),
  cz_yszk          NUMBER(18,2),
  cz_qtyfk         NUMBER(18,2),
  cz_sszb          NUMBER(18,2),
  cz_fzzz          NUMBER(18,2),
  cl_zysr          NUMBER(18,2),
  cl_zycb          NUMBER(18,2),
  cl_yysj          NUMBER(18,2),
  cl_xsfy          NUMBER(18,2),
  cl_glfy          NUMBER(18,2),
  cl_cwfy          NUMBER(18,2),
  cl_lrze          NUMBER(18,2),
  cl_jlr           NUMBER(18,2),
  sb_jfrs          NUMBER(10),
  sb_jfjs          NUMBER(18,2),
  zzs_qbxssr       NUMBER(18,2),
  zzs_xxse         NUMBER(18,2),
  zzs_jxse         NUMBER(18,2),
  zzs_ynse         NUMBER(18,2),
  ck_sb_xsemy      NUMBER(18,2),
  ck_sb_xsermb     NUMBER(18,2),
  ck_sb_jsje       NUMBER(18,2),
  ck_sb_jhcb       NUMBER(18,2),
  ck_sb_tse        NUMBER(18,2),
  ck_sb_mde        NUMBER(18,2),
  ck_hz_tse        NUMBER(18,2),
  ck_hz_mde        NUMBER(18,2),
  ck_bl_tse        NUMBER(18,2),
  ck_bl_mde        NUMBER(18,2),
  ck_xzsp_cke      NUMBER(18,2),
  ck_xzghs_jsje    NUMBER(18,2),
  ck_tssp_cke      NUMBER(18,2),
  ck_mgsp_cke      NUMBER(18,2),
  ck_mgka_cke      NUMBER(18,2),
  sjgxsj           DATE,
  bjts_zt          CHAR(1) default 'N',
  bjts_sj          DATE,
  cw_zt            CHAR(1) default 'N',
  cw_sj            DATE,
  zzs_zt           CHAR(1) default 'N',
  zzs_sj           DATE,
  sb_zt            CHAR(1) default 'N',
  sb_sj            DATE,
  fpg_zt           CHAR(1) default 'N',
  fpg_sj           DATE,
  fpx_zt           CHAR(1) default 'N',
  fpx_sj           DATE,
  cghw_zt          CHAR(1) default 'N',
  cghw_sj          DATE,
  fpqy_zt          CHAR(1) default 'N',
  fpqy_sj          DATE
)
;
comment on table JCFX_DATA_QYYHZ
  is '企业数据月汇总表，202501停止更新';
comment on column JCFX_DATA_QYYHZ.djxh
  is '登记序号';
comment on column JCFX_DATA_QYYHZ.ny
  is '年月';
comment on column JCFX_DATA_QYYHZ.nsrsbh
  is '纳税人识别号';
comment on column JCFX_DATA_QYYHZ.shxydm
  is '社会信用代码';
comment on column JCFX_DATA_QYYHZ.fp_xxfs_zy
  is '发票_销项份数_专票';
comment on column JCFX_DATA_QYYHZ.fp_xxje_zy
  is '发票_销项金额_专票';
comment on column JCFX_DATA_QYYHZ.fp_xxfs_dgkj
  is '发票_销项份数_专票顶格开具';
comment on column JCFX_DATA_QYYHZ.fp_xxje_dgkj
  is '发票_销项金额_专票顶格开具';
comment on column JCFX_DATA_QYYHZ.fp_xxfs_pt
  is '发票_销项份数_普票';
comment on column JCFX_DATA_QYYHZ.fp_xxje_pt
  is '发票_销项金额_普票';
comment on column JCFX_DATA_QYYHZ.fp_xxfs_ck
  is '发票_销项份数_出口';
comment on column JCFX_DATA_QYYHZ.fp_xxje_ck
  is '发票_销项金额_出口';
comment on column JCFX_DATA_QYYHZ.fp_xxje_ncp
  is '发票_销项金额_农产品';
comment on column JCFX_DATA_QYYHZ.fp_xxje_dianfei
  is '发票_销项金额_电费';
comment on column JCFX_DATA_QYYHZ.fp_jxfs_zy
  is '发票_进项份数_专票';
comment on column JCFX_DATA_QYYHZ.fp_jxje_zy
  is '发票_进项金额_专票';
comment on column JCFX_DATA_QYYHZ.fp_jxfs_dgkj
  is '发票_进项份数_专票顶格开具';
comment on column JCFX_DATA_QYYHZ.fp_jxje_dgkj
  is '发票_进项金额_专票顶格开具';
comment on column JCFX_DATA_QYYHZ.fp_jxje_ds
  is '发票_进项金额_本地市';
comment on column JCFX_DATA_QYYHZ.fp_jxje_sn
  is '发票_进项金额_省内市外';
comment on column JCFX_DATA_QYYHZ.fp_jxje_sw
  is '发票_进项金额_省外';
comment on column JCFX_DATA_QYYHZ.fp_jxfs_pt
  is '发票_进项份数_普票';
comment on column JCFX_DATA_QYYHZ.fp_jxje_pt
  is '发票_进项金额_普票';
comment on column JCFX_DATA_QYYHZ.fp_jxje_cghwydcg
  is '发票_进项金额_常规货物异地采购';
comment on column JCFX_DATA_QYYHZ.fp_jxje_dianfei
  is '发票_进项金额_电费';
comment on column JCFX_DATA_QYYHZ.fp_jxje_ysf
  is '发票_进项金额_运输费';
comment on column JCFX_DATA_QYYHZ.cz_gdzc
  is '财资_固定资产';
comment on column JCFX_DATA_QYYHZ.cz_ch
  is '财资_存货';
comment on column JCFX_DATA_QYYHZ.cz_yfzk
  is '财资_预付账款';
comment on column JCFX_DATA_QYYHZ.cz_qtysk
  is '财资_其他应收款';
comment on column JCFX_DATA_QYYHZ.cz_zczz
  is '财资_资产总值';
comment on column JCFX_DATA_QYYHZ.cz_yszk
  is '财资_预收账款';
comment on column JCFX_DATA_QYYHZ.cz_qtyfk
  is '财资_其他应付款';
comment on column JCFX_DATA_QYYHZ.cz_sszb
  is '财资_实收资本';
comment on column JCFX_DATA_QYYHZ.cz_fzzz
  is '财资_负债总值';
comment on column JCFX_DATA_QYYHZ.cl_zysr
  is '财利_主营收入';
comment on column JCFX_DATA_QYYHZ.cl_zycb
  is '财利_主营成本';
comment on column JCFX_DATA_QYYHZ.cl_yysj
  is '财利_营业税金';
comment on column JCFX_DATA_QYYHZ.cl_xsfy
  is '财利_销售费用';
comment on column JCFX_DATA_QYYHZ.cl_glfy
  is '财利_管理费用';
comment on column JCFX_DATA_QYYHZ.cl_cwfy
  is '财利_财务费用';
comment on column JCFX_DATA_QYYHZ.cl_lrze
  is '财利_利润总额';
comment on column JCFX_DATA_QYYHZ.cl_jlr
  is '财利_净利润';
comment on column JCFX_DATA_QYYHZ.sb_jfrs
  is '社保_缴费人数';
comment on column JCFX_DATA_QYYHZ.sb_jfjs
  is '社保_缴费基数';
comment on column JCFX_DATA_QYYHZ.zzs_qbxssr
  is '增表_全部销售收入';
comment on column JCFX_DATA_QYYHZ.zzs_xxse
  is '增表_销项税额';
comment on column JCFX_DATA_QYYHZ.zzs_jxse
  is '增表_进项税额';
comment on column JCFX_DATA_QYYHZ.zzs_ynse
  is '增表_应纳税额';
comment on column JCFX_DATA_QYYHZ.ck_sb_xsemy
  is '出口_销售美元';
comment on column JCFX_DATA_QYYHZ.ck_sb_xsermb
  is '出口_销售人民币';
comment on column JCFX_DATA_QYYHZ.ck_sb_jsje
  is '出口_计税金额';
comment on column JCFX_DATA_QYYHZ.ck_sb_jhcb
  is '出口_进货成本';
comment on column JCFX_DATA_QYYHZ.ck_sb_tse
  is '出口_申报退税';
comment on column JCFX_DATA_QYYHZ.ck_sb_mde
  is '出口_申报免抵';
comment on column JCFX_DATA_QYYHZ.ck_hz_tse
  is '出口_核准退税';
comment on column JCFX_DATA_QYYHZ.ck_hz_mde
  is '出口_核准免抵';
comment on column JCFX_DATA_QYYHZ.ck_bl_tse
  is '出口_办理退税';
comment on column JCFX_DATA_QYYHZ.ck_bl_mde
  is '出口_办理免抵';
comment on column JCFX_DATA_QYYHZ.ck_xzsp_cke
  is '出口_新增商品出口额';
comment on column JCFX_DATA_QYYHZ.ck_xzghs_jsje
  is '出口_新增供应商计税金额';
comment on column JCFX_DATA_QYYHZ.ck_tssp_cke
  is '出口_特殊商品出口额';
comment on column JCFX_DATA_QYYHZ.ck_mgsp_cke
  is '出口_敏感商品出口额';
comment on column JCFX_DATA_QYYHZ.ck_mgka_cke
  is '出口_敏感口岸出口额';
comment on column JCFX_DATA_QYYHZ.sjgxsj
  is '数据更新时间';
comment on column JCFX_DATA_QYYHZ.bjts_zt
  is '便捷退税更新状态';
comment on column JCFX_DATA_QYYHZ.bjts_sj
  is '便捷退税更新时间';
comment on column JCFX_DATA_QYYHZ.cw_zt
  is '财务报表更新状态';
comment on column JCFX_DATA_QYYHZ.cw_sj
  is '财务报表更新时间';
comment on column JCFX_DATA_QYYHZ.zzs_zt
  is '增值税报表更新状态';
comment on column JCFX_DATA_QYYHZ.zzs_sj
  is '增值税报表更新时间';
comment on column JCFX_DATA_QYYHZ.sb_zt
  is '社保报表更新状态';
comment on column JCFX_DATA_QYYHZ.sb_sj
  is '社保报表更新时间';
comment on column JCFX_DATA_QYYHZ.fpg_zt
  is '销项发票更新状态';
comment on column JCFX_DATA_QYYHZ.fpg_sj
  is '销项发票更新时间';
comment on column JCFX_DATA_QYYHZ.fpx_zt
  is '进项发票更新状态';
comment on column JCFX_DATA_QYYHZ.fpx_sj
  is '进项发票更新时间';
comment on column JCFX_DATA_QYYHZ.cghw_zt
  is '常规货物更新状态';
comment on column JCFX_DATA_QYYHZ.cghw_sj
  is '常规货物更新时间';
comment on column JCFX_DATA_QYYHZ.fpqy_zt
  is '发票对方企业（上下游/专票）月汇总表更新状态';
comment on column JCFX_DATA_QYYHZ.fpqy_sj
  is '发票对方企业（上下游/专票）月汇总表更新时间';
alter table JCFX_DATA_QYYHZ
  add constraint PK_JCFX_DATA_QYYHZ primary key (DJXH, NY);

prompt
prompt Creating table JCFX_DATA_TSSBMX
prompt ===============================
prompt
create table JCFX_DATA_TSSBMX
(
  uuid       VARCHAR2(32) not null,
  tsswjg_dm  CHAR(11) not null,
  sbywlx     CHAR(1),
  lcslid     VARCHAR2(32),
  djxh       NUMBER(20) not null,
  ckbgdh     VARCHAR2(21) not null,
  ny         CHAR(6),
  sbrq       DATE,
  ckrq       DATE,
  cksp_dm    VARCHAR2(20),
  hggqka_dm  CHAR(4),
  mygdqsz_dm CHAR(3),
  jgfs_dm    CHAR(4),
  hzdwdq_dm  CHAR(5),
  mylaj      NUMBER(18,2),
  rmblaj     NUMBER(18,2),
  jsje       NUMBER(18,2),
  tsl        NUMBER(10,6),
  tmse       NUMBER(18,2),
  ghfnsrsbh  VARCHAR2(20),
  hydxzqh_dm CHAR(4),
  sjgxsj     DATE,
  glh        VARCHAR2(20),
  cksl       NUMBER(16,4)
)
partition by range (TSSWJG_DM)
(
  partition P_13300000000 values less than ('13301000000')
    tablespace TL_TSSH,
  partition P_13301000000 values less than ('13303000000')
    tablespace TL_TSSH,
  partition P_13303000000 values less than ('13304000000')
    tablespace TL_TSSH,
  partition P_13304000000 values less than ('13305000000')
    tablespace TL_TSSH,
  partition P_13305000000 values less than ('13306000000')
    tablespace TL_TSSH,
  partition P_13306000000 values less than ('13307000000')
    tablespace TL_TSSH,
  partition P_13307000000 values less than ('13308000000')
    tablespace TL_TSSH,
  partition P_13308000000 values less than ('13309000000')
    tablespace TL_TSSH,
  partition P_13309000000 values less than ('13310000000')
    tablespace TL_TSSH,
  partition P_13310000000 values less than ('13311000000')
    tablespace TL_TSSH,
  partition P_13311000000 values less than (MAXVALUE)
    tablespace TL_TSSH
);
comment on table JCFX_DATA_TSSBMX
  is '退税申报明细表';
comment on column JCFX_DATA_TSSBMX.tsswjg_dm
  is '税务机关';
comment on column JCFX_DATA_TSSBMX.sbywlx
  is '申报业务类型（1免抵退税2免退税3代办退税）';
comment on column JCFX_DATA_TSSBMX.lcslid
  is '申报LCSLID';
comment on column JCFX_DATA_TSSBMX.djxh
  is '登记序号';
comment on column JCFX_DATA_TSSBMX.ckbgdh
  is '21位报关单号';
comment on column JCFX_DATA_TSSBMX.ny
  is '申报年月';
comment on column JCFX_DATA_TSSBMX.sbrq
  is '申报日期';
comment on column JCFX_DATA_TSSBMX.ckrq
  is '出口日期';
comment on column JCFX_DATA_TSSBMX.cksp_dm
  is '出口商品代码';
comment on column JCFX_DATA_TSSBMX.hggqka_dm
  is '出口口岸';
comment on column JCFX_DATA_TSSBMX.mygdqsz_dm
  is '出口国别';
comment on column JCFX_DATA_TSSBMX.jgfs_dm
  is '贸易方式';
comment on column JCFX_DATA_TSSBMX.hzdwdq_dm
  is '境内货源地';
comment on column JCFX_DATA_TSSBMX.mylaj
  is '出口销售（美元）';
comment on column JCFX_DATA_TSSBMX.rmblaj
  is '出口销售（人民币）';
comment on column JCFX_DATA_TSSBMX.jsje
  is '计税金额';
comment on column JCFX_DATA_TSSBMX.tsl
  is '退税率';
comment on column JCFX_DATA_TSSBMX.tmse
  is '申报退免税额';
comment on column JCFX_DATA_TSSBMX.ghfnsrsbh
  is '供货方识别号';
comment on column JCFX_DATA_TSSBMX.hydxzqh_dm
  is '供货地区（地市级行政区划）';
comment on column JCFX_DATA_TSSBMX.sjgxsj
  is '数据更新时间';
comment on column JCFX_DATA_TSSBMX.glh
  is '免退税申报关联号';
comment on column JCFX_DATA_TSSBMX.cksl
  is '出口数量';
create index IDX_JCFX_DATA_TSSBMX_DC on JCFX_DATA_TSSBMX (DJXH, CKBGDH)
  nologging;
create index IDX_JCFX_DATA_TSSBMX_DN on JCFX_DATA_TSSBMX (DJXH, NY)
  nologging;
create index IDX_JCFX_DATA_TSSBMX_DS on JCFX_DATA_TSSBMX (DJXH, SBRQ)
  nologging;
create index IDX_JCFX_DATA_TSSBMX_LCSLID on JCFX_DATA_TSSBMX (LCSLID)
  nologging;
create index IDX_JCFX_DATA_TSSBMX_SC on JCFX_DATA_TSSBMX (CKSP_DM, CKRQ)
  nologging;
create index IDX_JCFX_DATA_TSSBMX_SJGXSJ on JCFX_DATA_TSSBMX (SJGXSJ)
  nologging;
alter table JCFX_DATA_TSSBMX
  add constraint PK_JCFX_DATA_TSSBMX primary key (UUID);
alter index PK_JCFX_DATA_TSSBMX nologging;

prompt
prompt Creating table JCFX_DATA_TSSBMX_TSYW
prompt ====================================
prompt
create table JCFX_DATA_TSSBMX_TSYW
(
  uuid      VARCHAR2(32) not null,
  tsswjg_dm CHAR(11) not null,
  djxh      NUMBER(20) not null,
  sbywlx    CHAR(1) not null,
  tsywlx    VARCHAR2(20) not null,
  lcslid    VARCHAR2(32) not null,
  sbxh      VARCHAR2(50),
  sbpzhm    VARCHAR2(30),
  cksp_dm   VARCHAR2(20),
  mylaj     NUMBER(18,2),
  rmblaj    NUMBER(18,2),
  tmse      NUMBER(18,2),
  sbny      CHAR(6),
  sbrq      DATE,
  hzny      CHAR(6),
  hzrq      DATE
)
;
comment on table JCFX_DATA_TSSBMX_TSYW
  is '特殊业务退税申报明细表';
comment on column JCFX_DATA_TSSBMX_TSYW.tsswjg_dm
  is '税务机关';
comment on column JCFX_DATA_TSSBMX_TSYW.djxh
  is '登记序号';
comment on column JCFX_DATA_TSSBMX_TSYW.sbywlx
  is '申报业务类型（1免抵退税2免退税3代办退税4周边业务）';
comment on column JCFX_DATA_TSSBMX_TSYW.tsywlx
  is '特殊业务类型';
comment on column JCFX_DATA_TSSBMX_TSYW.lcslid
  is '申报LCSLID';
comment on column JCFX_DATA_TSSBMX_TSYW.sbxh
  is '申报序号';
comment on column JCFX_DATA_TSSBMX_TSYW.sbpzhm
  is '21位报关单号/20位代理证明号/其他凭证号';
comment on column JCFX_DATA_TSSBMX_TSYW.cksp_dm
  is '出口商品代码';
comment on column JCFX_DATA_TSSBMX_TSYW.mylaj
  is '出口销售（美元）';
comment on column JCFX_DATA_TSSBMX_TSYW.rmblaj
  is '出口销售（人民币）';
comment on column JCFX_DATA_TSSBMX_TSYW.tmse
  is '退免税额';
comment on column JCFX_DATA_TSSBMX_TSYW.sbny
  is '申报年月';
comment on column JCFX_DATA_TSSBMX_TSYW.sbrq
  is '申报日期';
comment on column JCFX_DATA_TSSBMX_TSYW.hzny
  is '业务核准年月';
comment on column JCFX_DATA_TSSBMX_TSYW.hzrq
  is '业务核准日期';
create index IDX_JCFX_DATA_TSSBMX_TSYW_TH on JCFX_DATA_TSSBMX_TSYW (TSSWJG_DM, HZNY)
  nologging;
create index IDX_JCFX_DATA_TSSBMX_TSYW_TS on JCFX_DATA_TSSBMX_TSYW (TSSWJG_DM, SBNY)
  nologging;
alter table JCFX_DATA_TSSBMX_TSYW
  add constraint PK_JCFX_DATA_TSSBMX_TSYW primary key (UUID);
alter index PK_JCFX_DATA_TSSBMX_TSYW nologging;

prompt
prompt Creating table JCFX_DM_CKGB
prompt ===========================
prompt
create table JCFX_DM_CKGB
(
  ckgb_dm VARCHAR2(3) not null,
  ckgb_mc VARCHAR2(80) not null,
  pid     VARCHAR2(3)
)
;
comment on table JCFX_DM_CKGB
  is '出口国别代码表';
comment on column JCFX_DM_CKGB.ckgb_dm
  is '出口国别代码';
comment on column JCFX_DM_CKGB.ckgb_mc
  is '出口国别名称';
alter table JCFX_DM_CKGB
  add constraint PK_JCFX_DM_CKGB primary key (CKGB_DM);

prompt
prompt Creating table JCFX_DM_CKGM
prompt ===========================
prompt
create table JCFX_DM_CKGM
(
  ckgm_dm CHAR(1) not null,
  ckgm_mc VARCHAR2(50)
)
;
alter table JCFX_DM_CKGM
  add primary key (CKGM_DM);

prompt
prompt Creating table JCFX_DM_CKKA
prompt ===========================
prompt
create table JCFX_DM_CKKA
(
  ckka_dm VARCHAR2(4) not null,
  ckka_mc VARCHAR2(80) not null,
  pid     VARCHAR2(4)
)
;
comment on table JCFX_DM_CKKA
  is '出口口岸代码表';
comment on column JCFX_DM_CKKA.ckka_dm
  is '出口口岸代码';
comment on column JCFX_DM_CKKA.ckka_mc
  is '出口口岸名称';
alter table JCFX_DM_CKKA
  add constraint PK_JCFX_DM_CKKA primary key (CKKA_DM);

prompt
prompt Creating table JCFX_DM_CKQYLX
prompt =============================
prompt
create table JCFX_DM_CKQYLX
(
  ckqylx_dm VARCHAR2(1) not null,
  ckqylx_mc VARCHAR2(50) not null
)
;
comment on table JCFX_DM_CKQYLX
  is '出口企业类型表';
comment on column JCFX_DM_CKQYLX.ckqylx_dm
  is '企业类型代码';
comment on column JCFX_DM_CKQYLX.ckqylx_mc
  is '企业类型名称';
alter table JCFX_DM_CKQYLX
  add constraint PK_JCFX_DM_CKQYLX primary key (CKQYLX_DM);

prompt
prompt Creating table JCFX_DM_CKSP
prompt ===========================
prompt
create table JCFX_DM_CKSP
(
  cksp_dm VARCHAR2(20) not null,
  cksp_mc VARCHAR2(80) not null,
  spdm_8  VARCHAR2(8),
  spdm_4  VARCHAR2(4),
  spdm_2  VARCHAR2(2),
  spdm_0  VARCHAR2(3)
)
;
comment on table JCFX_DM_CKSP
  is '出口商品代码表';
comment on column JCFX_DM_CKSP.cksp_dm
  is '出口商品代码';
comment on column JCFX_DM_CKSP.cksp_mc
  is '出口商品名称';
comment on column JCFX_DM_CKSP.spdm_8
  is '出口商品代码（8位）';
comment on column JCFX_DM_CKSP.spdm_4
  is '出口商品代码（4位）';
comment on column JCFX_DM_CKSP.spdm_2
  is '出口商品代码（2位）';
comment on column JCFX_DM_CKSP.spdm_0
  is '海关23大类';
alter table JCFX_DM_CKSP
  add constraint PK_JCFX_DM_CKSP primary key (CKSP_DM);

prompt
prompt Creating table JCFX_DM_CKSPTREE
prompt ===============================
prompt
create table JCFX_DM_CKSPTREE
(
  cksp_dm VARCHAR2(20) not null,
  cksp_mc VARCHAR2(500),
  pid     VARCHAR2(20) not null,
  cksp_jc CHAR(1) not null,
  pid_jc  CHAR(1) not null
)
;
comment on table JCFX_DM_CKSPTREE
  is '出口商品树结构表';
comment on column JCFX_DM_CKSPTREE.cksp_dm
  is '出口商品代码';
comment on column JCFX_DM_CKSPTREE.cksp_mc
  is '出口商品名称';
comment on column JCFX_DM_CKSPTREE.pid
  is '上级树节点';
comment on column JCFX_DM_CKSPTREE.cksp_jc
  is '树节点级次';
comment on column JCFX_DM_CKSPTREE.pid_jc
  is '上级树节点级次';
alter table JCFX_DM_CKSPTREE
  add constraint PK_JCFX_DM_CKSPTREE primary key (CKSP_JC, CKSP_DM);

prompt
prompt Creating table JCFX_DM_DJZCLX
prompt =============================
prompt
create table JCFX_DM_DJZCLX
(
  djzclx_dm VARCHAR2(3) not null,
  djzclx_mc VARCHAR2(50) not null,
  pid       VARCHAR2(3)
)
;
comment on table JCFX_DM_DJZCLX
  is '登记注册类型表';
comment on column JCFX_DM_DJZCLX.djzclx_dm
  is '登记注册类型代码';
comment on column JCFX_DM_DJZCLX.djzclx_mc
  is '登记注册类型名称';
alter table JCFX_DM_DJZCLX
  add constraint PK_JCFX_DM_DJZCLX primary key (DJZCLX_DM);

prompt
prompt Creating table JCFX_DM_FLGL
prompt ===========================
prompt
create table JCFX_DM_FLGL
(
  flgl_dm VARCHAR2(1) not null,
  flgl_mc VARCHAR2(50) not null
)
;
comment on table JCFX_DM_FLGL
  is '出口企业分类管理代码表';
comment on column JCFX_DM_FLGL.flgl_dm
  is '管理类别代码';
comment on column JCFX_DM_FLGL.flgl_mc
  is '管理类别名称';
alter table JCFX_DM_FLGL
  add constraint PK_JCFX_DM_FLGL primary key (FLGL_DM);

prompt
prompt Creating table JCFX_DM_GHDQ
prompt ===========================
prompt
create table JCFX_DM_GHDQ
(
  ghdq_dm VARCHAR2(4) not null,
  ghdq_mc VARCHAR2(80) not null,
  pid     VARCHAR2(4)
)
;
comment on table JCFX_DM_GHDQ
  is '供货地区代码表';
comment on column JCFX_DM_GHDQ.ghdq_dm
  is '供货地区代码';
comment on column JCFX_DM_GHDQ.ghdq_mc
  is '供货地区名称';
alter table JCFX_DM_GHDQ
  add constraint PK_JCFX_DM_GHDQ primary key (GHDQ_DM);

prompt
prompt Creating table JCFX_DM_HY
prompt =========================
prompt
create table JCFX_DM_HY
(
  hy_dm VARCHAR2(4) not null,
  hy_mc VARCHAR2(50) not null,
  pid   VARCHAR2(4)
)
;
comment on table JCFX_DM_HY
  is '行业代码表';
comment on column JCFX_DM_HY.hy_dm
  is '行业代码';
comment on column JCFX_DM_HY.hy_mc
  is '行业名称';
alter table JCFX_DM_HY
  add constraint PK_JCFX_DM_HY primary key (HY_DM);

prompt
prompt Creating table JCFX_DM_MYFS
prompt ===========================
prompt
create table JCFX_DM_MYFS
(
  myfs_dm VARCHAR2(4) not null,
  myfs_mc VARCHAR2(80) not null,
  pid     VARCHAR2(4)
)
;
comment on table JCFX_DM_MYFS
  is '贸易方式代码表';
comment on column JCFX_DM_MYFS.myfs_dm
  is '贸易方式代码';
comment on column JCFX_DM_MYFS.myfs_mc
  is '贸易方式名称';
alter table JCFX_DM_MYFS
  add constraint PK_JCFX_DM_MYFS primary key (MYFS_DM);

prompt
prompt Creating table JCFX_DM_NSRLB
prompt ============================
prompt
create table JCFX_DM_NSRLB
(
  nsrlb_dm VARCHAR2(1) not null,
  nsrlb_mc VARCHAR2(50) not null
)
;
comment on table JCFX_DM_NSRLB
  is '纳税人类别代码表';
comment on column JCFX_DM_NSRLB.nsrlb_dm
  is '纳税人类别代码';
comment on column JCFX_DM_NSRLB.nsrlb_mc
  is '纳税人类别名称';
alter table JCFX_DM_NSRLB
  add constraint PK_JCFX_DM_NSRLB primary key (NSRLB_DM);

prompt
prompt Creating table JCFX_DM_NSRZT
prompt ============================
prompt
create table JCFX_DM_NSRZT
(
  nsrzt_dm VARCHAR2(2) not null,
  nsrzt_mc VARCHAR2(50) not null
)
;
comment on table JCFX_DM_NSRZT
  is '纳税人状态表';
comment on column JCFX_DM_NSRZT.nsrzt_dm
  is '纳税人状态代码';
comment on column JCFX_DM_NSRZT.nsrzt_mc
  is '纳税人状态名称';
alter table JCFX_DM_NSRZT
  add constraint PK_JCFX_DM_NSRZT primary key (NSRZT_DM);

prompt
prompt Creating table JCFX_DM_QYFZ
prompt ===========================
prompt
create table JCFX_DM_QYFZ
(
  qyfz_dm VARCHAR2(11) not null,
  qyfz_mc VARCHAR2(80) not null,
  swjg_dm VARCHAR2(11) not null
)
;
comment on table JCFX_DM_QYFZ
  is '企业分组代码表';
comment on column JCFX_DM_QYFZ.qyfz_dm
  is '企业分组代码';
comment on column JCFX_DM_QYFZ.qyfz_mc
  is '企业分组名称';
comment on column JCFX_DM_QYFZ.swjg_dm
  is '税务机关代码';
alter table JCFX_DM_QYFZ
  add constraint PK_JCFX_DM_QYFZ primary key (QYFZ_DM);

prompt
prompt Creating table JCFX_DM_SZQJZB
prompt =============================
prompt
create table JCFX_DM_SZQJZB
(
  zbxm   VARCHAR2(10) not null,
  dm     VARCHAR2(20) not null,
  mc     VARCHAR2(80) not null,
  minval NUMBER(16,2),
  maxval NUMBER(16,2)
)
;
comment on table JCFX_DM_SZQJZB
  is '数值区间类指标代码表';
comment on column JCFX_DM_SZQJZB.zbxm
  is '指标项目';
comment on column JCFX_DM_SZQJZB.dm
  is '代码';
comment on column JCFX_DM_SZQJZB.mc
  is '名称';
comment on column JCFX_DM_SZQJZB.minval
  is '下限';
comment on column JCFX_DM_SZQJZB.maxval
  is '上限';
alter table JCFX_DM_SZQJZB
  add constraint PK_JCFX_DM_SZQJZB primary key (ZBXM, DM);

prompt
prompt Creating table JCFX_DM_TSYW
prompt ===========================
prompt
create table JCFX_DM_TSYW
(
  tsyw_dm VARCHAR2(10) not null,
  tsyw_mc VARCHAR2(50) not null
)
;
comment on table JCFX_DM_TSYW
  is '特殊业务代码表';
comment on column JCFX_DM_TSYW.tsyw_dm
  is '特殊业务代码';
comment on column JCFX_DM_TSYW.tsyw_mc
  is '特殊业务名称';
alter table JCFX_DM_TSYW
  add constraint PK_JCFX_DM_TSYW primary key (TSYW_DM);

prompt
prompt Creating table JCFX_DM_YSFS
prompt ===========================
prompt
create table JCFX_DM_YSFS
(
  ysfs_dm VARCHAR2(1) not null,
  ysfs_mc VARCHAR2(80) not null
)
;
comment on table JCFX_DM_YSFS
  is '运输方式代码表';
comment on column JCFX_DM_YSFS.ysfs_dm
  is '运输方式代码';
comment on column JCFX_DM_YSFS.ysfs_mc
  is '运输方式名称';
alter table JCFX_DM_YSFS
  add constraint PK_JCFX_DM_YSFS primary key (YSFS_DM);

prompt
prompt Creating table JCFX_NSR_BADJ
prompt ============================
prompt
create table JCFX_NSR_BADJ
(
  djxh      NUMBER(20) not null,
  nsrsbh    VARCHAR2(20) not null,
  shxydm    VARCHAR2(20),
  nsrmc     VARCHAR2(100) not null,
  qyhgdm    VARCHAR2(20),
  ckqylx    CHAR(1),
  flglcd    CHAR(1),
  djzclx    CHAR(3),
  hy        CHAR(4),
  nsrzt     VARCHAR2(2),
  nsrlb     CHAR(1),
  qyfz      VARCHAR2(11),
  sq_date   DATE,
  bachbz    CHAR(1) default 'N' not null,
  bachsj    DATE,
  swjgdm    VARCHAR2(11) not null,
  ksswjg_dm VARCHAR2(11),
  jdxz_dm   VARCHAR2(10),
  nsrdzdah  NUMBER(20),
  ckblv     NUMBER(10,6),
  mdblv     NUMBER(10,6),
  sflv      NUMBER(10,6),
  ckgm      NUMBER(18,2),
  ckblv_dm  CHAR(1),
  mdblv_dm  CHAR(1),
  sflv_dm   CHAR(1),
  ckgm_dm   CHAR(1)
)
;
comment on table JCFX_NSR_BADJ
  is '纳税人备案登记表';
comment on column JCFX_NSR_BADJ.djxh
  is '登记序号';
comment on column JCFX_NSR_BADJ.nsrsbh
  is '纳税人识别号';
comment on column JCFX_NSR_BADJ.shxydm
  is '社会信用代码';
comment on column JCFX_NSR_BADJ.nsrmc
  is '纳税人名称';
comment on column JCFX_NSR_BADJ.qyhgdm
  is '企业海关代码';
comment on column JCFX_NSR_BADJ.ckqylx
  is '出口企业类型';
comment on column JCFX_NSR_BADJ.flglcd
  is '出口管理类别';
comment on column JCFX_NSR_BADJ.djzclx
  is '登记注册类型';
comment on column JCFX_NSR_BADJ.hy
  is '行业';
comment on column JCFX_NSR_BADJ.nsrzt
  is '纳税人状态';
comment on column JCFX_NSR_BADJ.nsrlb
  is '纳税人类别';
comment on column JCFX_NSR_BADJ.qyfz
  is '企业分组';
comment on column JCFX_NSR_BADJ.sq_date
  is '备案日期';
comment on column JCFX_NSR_BADJ.bachbz
  is '备案撤回标志';
comment on column JCFX_NSR_BADJ.bachsj
  is '备案撤回时间';
comment on column JCFX_NSR_BADJ.swjgdm
  is '主管税务机关';
comment on column JCFX_NSR_BADJ.ksswjg_dm
  is '税务机关科所';
comment on column JCFX_NSR_BADJ.jdxz_dm
  is '街道乡镇代码，备用';
comment on column JCFX_NSR_BADJ.nsrdzdah
  is '电子档案号，备用';
comment on column JCFX_NSR_BADJ.ckblv
  is '出口比例（百分比）';
comment on column JCFX_NSR_BADJ.mdblv
  is '免抵比例（百分比）';
comment on column JCFX_NSR_BADJ.sflv
  is '税负率（百分比）';
comment on column JCFX_NSR_BADJ.ckgm
  is '出口规模（美元）';
comment on column JCFX_NSR_BADJ.ckblv_dm
  is '出口比例（等级，ABCDE）';
comment on column JCFX_NSR_BADJ.mdblv_dm
  is '免抵比例（等级，ABCDE）';
comment on column JCFX_NSR_BADJ.sflv_dm
  is '税负率（等级，ABCDE）';
comment on column JCFX_NSR_BADJ.ckgm_dm
  is '出口规模（等级，ABCDE）';
create index IDX_JCFX_NSR_BADJ_CKQYLX on JCFX_NSR_BADJ (CKQYLX);
create index IDX_JCFX_NSR_BADJ_N on JCFX_NSR_BADJ (NSRSBH);
alter table JCFX_NSR_BADJ
  add constraint PK_JCFX_NSR_BADJ primary key (DJXH);

prompt
prompt Creating table JCFX_NSR_BADJ_TOHZ
prompt =================================
prompt
create table JCFX_NSR_BADJ_TOHZ
(
  djxh   NUMBER(20) not null,
  nsrsbh VARCHAR2(20) not null,
  shxydm VARCHAR2(20),
  jlxzsj DATE,
  bachsj DATE,
  swjgdm VARCHAR2(11),
  jcfxsj DATE
)
;
comment on table JCFX_NSR_BADJ_TOHZ
  is '纳税人备案登记表';
comment on column JCFX_NSR_BADJ_TOHZ.djxh
  is '登记序号';
comment on column JCFX_NSR_BADJ_TOHZ.nsrsbh
  is '纳税人识别号';
comment on column JCFX_NSR_BADJ_TOHZ.shxydm
  is '社会信用代码';
comment on column JCFX_NSR_BADJ_TOHZ.jlxzsj
  is '记录新增时间（根据记录新增时间，提前两年的完整年度抽取企业月汇总表）';
comment on column JCFX_NSR_BADJ_TOHZ.bachsj
  is '备案撤回时间';
comment on column JCFX_NSR_BADJ_TOHZ.swjgdm
  is '主管税务机关';
comment on column JCFX_NSR_BADJ_TOHZ.jcfxsj
  is '统计时间,当月已统计不统计,ETL使用';
alter table JCFX_NSR_BADJ_TOHZ
  add constraint PK_JCFX_NSR_BADJ_TOHZ primary key (DJXH);

prompt
prompt Creating table JCFX_NSR_SAMPLE
prompt ==============================
prompt
create table JCFX_NSR_SAMPLE
(
  zid       NUMBER(10) not null,
  sname     VARCHAR2(50) not null,
  swjgdm    VARCHAR2(11) not null,
  syfw_swjg VARCHAR2(11) not null,
  qybz      VARCHAR2(1) default 'Y' not null,
  xgr       VARCHAR2(30) not null,
  xgsj      DATE not null
)
;
comment on table JCFX_NSR_SAMPLE
  is '样本企业表';
comment on column JCFX_NSR_SAMPLE.zid
  is '序号';
comment on column JCFX_NSR_SAMPLE.sname
  is '样本名称';
comment on column JCFX_NSR_SAMPLE.swjgdm
  is '归属税务机关';
comment on column JCFX_NSR_SAMPLE.syfw_swjg
  is '适用范围';
comment on column JCFX_NSR_SAMPLE.qybz
  is '启用标志';
comment on column JCFX_NSR_SAMPLE.xgr
  is '创建/修改人';
comment on column JCFX_NSR_SAMPLE.xgsj
  is '修改时间';
alter table JCFX_NSR_SAMPLE
  add constraint PK_JCFX_NSR_SAMPLE primary key (ZID);

prompt
prompt Creating table JCFX_NSR_SAMPLE_SUB
prompt ==================================
prompt
create table JCFX_NSR_SAMPLE_SUB
(
  id     NUMBER(10) not null,
  zid    NUMBER(10) not null,
  nsrsbh VARCHAR2(20) not null,
  nsrmc  VARCHAR2(100) not null,
  qybz   VARCHAR2(1) default 'Y' not null,
  djxh   NUMBER(20) not null
)
;
comment on table JCFX_NSR_SAMPLE_SUB
  is '样本企业子表';
comment on column JCFX_NSR_SAMPLE_SUB.id
  is '序号';
comment on column JCFX_NSR_SAMPLE_SUB.zid
  is '序号';
comment on column JCFX_NSR_SAMPLE_SUB.nsrsbh
  is '纳税人识别号';
comment on column JCFX_NSR_SAMPLE_SUB.nsrmc
  is '纳税人名称';
comment on column JCFX_NSR_SAMPLE_SUB.qybz
  is '启用标志';
comment on column JCFX_NSR_SAMPLE_SUB.djxh
  is '登记序号';
create index IDX_JCFX_NSR_SAMPLE_SUB_Z on JCFX_NSR_SAMPLE_SUB (ZID);
alter table JCFX_NSR_SAMPLE_SUB
  add constraint PK_JCFX_NSR_SAMPLE_SUB primary key (ID);

prompt
prompt Creating table JCFX_TASK
prompt ========================
prompt
create table JCFX_TASK
(
  id        VARCHAR2(32) not null,
  czry_dm   VARCHAR2(40) not null,
  req_param CLOB,
  resp_data BLOB,
  task_flag CHAR(1),
  tqbz      VARCHAR2(64),
  tqsj      TIMESTAMP(6),
  wcsj      TIMESTAMP(6),
  tqcs      NUMBER,
  crtime    TIMESTAMP(6),
  title     VARCHAR2(200),
  sqltext   CLOB,
  swjgdm    VARCHAR2(20),
  bbtype    VARCHAR2(10)
)
;
comment on column JCFX_TASK.id
  is '任务ID，采用HASH值作为报文主键';
comment on column JCFX_TASK.czry_dm
  is '操作人员代码';
comment on column JCFX_TASK.task_flag
  is '任务标记，0-未提取，1提取中，2任务完成';
comment on column JCFX_TASK.tqbz
  is '提取标志';
comment on column JCFX_TASK.tqsj
  is '提取时间';
comment on column JCFX_TASK.wcsj
  is '完成时间';
comment on column JCFX_TASK.tqcs
  is '提取次数';
comment on column JCFX_TASK.title
  is '标题';
comment on column JCFX_TASK.sqltext
  is 'SQL脚本';
comment on column JCFX_TASK.bbtype
  is '报表类型';
alter table JCFX_TASK
  add constraint PK_ID primary key (ID);

prompt
prompt Creating table JCFX_TASK_SUB
prompt ============================
prompt
create table JCFX_TASK_SUB
(
  pid       VARCHAR2(32) not null,
  page_no   NUMBER not null,
  resp_data BLOB
)
;
alter table JCFX_TASK_SUB
  add constraint PK_PID_PAGE primary key (PID, PAGE_NO);

prompt
prompt Creating table JKGL_DATA_BGQ
prompt ============================
prompt
create table JKGL_DATA_BGQ
(
  bgqid         NUMBER(20) not null,
  djxh          NUMBER(20) not null,
  zqlx          VARCHAR2(10),
  bgq_q         DATE,
  bgq_z         DATE,
  sxzt          CHAR(1),
  tqbz          VARCHAR2(40),
  tqsj          DATE,
  wcsj          DATE,
  zzs_zt        CHAR(1) default 'N',
  zzs_sj        DATE,
  dzdz_zt       CHAR(1) default 'N',
  dzdz_sj       DATE,
  dzsp_zt       CHAR(1) default 'N',
  dzsp_sj       DATE,
  zbu_dzgf_zt   CHAR(1) default 'N',
  zbu_dzgf_sj   DATE,
  zbu_dzxf_zt   CHAR(1) default 'N',
  zbu_dzxf_sj   DATE,
  zbu_dzspjx_zt CHAR(1) default 'N',
  zbu_dzspjx_sj DATE,
  zbu_dzspxx_zt CHAR(1) default 'N',
  zbu_dzspxx_sj DATE,
  sds_zt        CHAR(1) default 'N',
  sds_sj        DATE
)
;
comment on table JKGL_DATA_BGQ
  is '指标统计报告期（主线表）';
comment on column JKGL_DATA_BGQ.bgqid
  is '报告期id';
comment on column JKGL_DATA_BGQ.djxh
  is '纳税人登记序号';
comment on column JKGL_DATA_BGQ.zqlx
  is '统计周期  年/季/月';
comment on column JKGL_DATA_BGQ.bgq_q
  is '报告期起';
comment on column JKGL_DATA_BGQ.bgq_z
  is '报告期止';
comment on column JKGL_DATA_BGQ.sxzt
  is '刷新状态 0待刷新  1刷新中 2,3已刷新';
comment on column JKGL_DATA_BGQ.tqbz
  is '提取标识（提取线程UUID)';
comment on column JKGL_DATA_BGQ.tqsj
  is '提取时间';
comment on column JKGL_DATA_BGQ.wcsj
  is '完成时间';
comment on column JKGL_DATA_BGQ.zzs_zt
  is '增值税报表更新状态';
comment on column JKGL_DATA_BGQ.zzs_sj
  is '增值税报表更新时间';
comment on column JKGL_DATA_BGQ.dzdz_zt
  is '底账更新状态';
comment on column JKGL_DATA_BGQ.dzdz_sj
  is '底账更新时间';
comment on column JKGL_DATA_BGQ.dzsp_zt
  is '底账商品更新状态';
comment on column JKGL_DATA_BGQ.dzsp_sj
  is '底账商品更新时间';
comment on column JKGL_DATA_BGQ.zbu_dzgf_zt
  is '底账更新状态ZBU_DZGF';
comment on column JKGL_DATA_BGQ.zbu_dzgf_sj
  is '底账更新时间ZBU_DZGF';
comment on column JKGL_DATA_BGQ.zbu_dzxf_zt
  is '底账更新状态ZBU_DZXF';
comment on column JKGL_DATA_BGQ.zbu_dzxf_sj
  is '底账更新时间ZBU_DZXF';
comment on column JKGL_DATA_BGQ.zbu_dzspjx_zt
  is '底账更新状态ZBU_DZSPJX';
comment on column JKGL_DATA_BGQ.zbu_dzspjx_sj
  is '底账更新时间ZBU_DZSPJX';
comment on column JKGL_DATA_BGQ.zbu_dzspxx_zt
  is '底账更新状态ZBU_DZSPXX';
comment on column JKGL_DATA_BGQ.zbu_dzspxx_sj
  is '底账更新时间ZBU_DZSPXX';
comment on column JKGL_DATA_BGQ.sds_zt
  is '所得税报表更新状态';
comment on column JKGL_DATA_BGQ.sds_sj
  is '所得税报表更新时间，仅更新年度报告期，每年6月1日以后刷新上年度报告期';
create index IDX_JKGL_DATA_BGQ on JKGL_DATA_BGQ (DJXH, BGQ_Q, BGQ_Z);
alter table JKGL_DATA_BGQ
  add constraint PK_JKGL_DATA_BGQ primary key (BGQID);

prompt
prompt Creating table JKGL_DATA_BGQ_QSPJ
prompt =================================
prompt
create table JKGL_DATA_BGQ_QSPJ
(
  bgqid   NUMBER(20) not null,
  qylx    CHAR(1),
  bgq_q   DATE,
  bgq_z   DATE,
  sxzt    CHAR(1),
  tqbz    VARCHAR2(40),
  tqsj    DATE,
  wcsj    DATE,
  swjg_dm VARCHAR2(11),
  qybj    CHAR(1) default 'N'
)
;
comment on table JKGL_DATA_BGQ_QSPJ
  is '全省平均值统计报告期（主线表）';
comment on column JKGL_DATA_BGQ_QSPJ.bgqid
  is '报告期id';
comment on column JKGL_DATA_BGQ_QSPJ.qylx
  is '企业类型  1生产  2外贸';
comment on column JKGL_DATA_BGQ_QSPJ.bgq_q
  is '报告期起';
comment on column JKGL_DATA_BGQ_QSPJ.bgq_z
  is '报告期止';
comment on column JKGL_DATA_BGQ_QSPJ.sxzt
  is '刷新状态 0待刷新  1刷新中 2已刷新';
comment on column JKGL_DATA_BGQ_QSPJ.tqbz
  is '提取标识（提取线程UUID)';
comment on column JKGL_DATA_BGQ_QSPJ.tqsj
  is '提取时间';
comment on column JKGL_DATA_BGQ_QSPJ.wcsj
  is '完成时间';
comment on column JKGL_DATA_BGQ_QSPJ.swjg_dm
  is '全省  1330000';
comment on column JKGL_DATA_BGQ_QSPJ.qybj
  is 'Y/N';
create index IDX_JKGL_DATA_BGQ_QSPJ on JKGL_DATA_BGQ_QSPJ (QYLX, BGQ_Q, BGQ_Z);
alter table JKGL_DATA_BGQ_QSPJ
  add constraint PK_JKGL_DATA_BGQ_QSPJ primary key (BGQID);

prompt
prompt Creating table JKGL_DATA_QYJKM_JGB
prompt ==================================
prompt
create table JKGL_DATA_QYJKM_JGB
(
  djxh       NUMBER(20) not null,
  jkm_level  CHAR(1),
  score_10   INTEGER,
  score_20   INTEGER,
  score_30   INTEGER,
  score_40   INTEGER,
  score_50   INTEGER,
  score_60   INTEGER,
  score_zh   INTEGER,
  uptime     DATE,
  tsjsfs_dm  CHAR(1),
  note       VARCHAR2(200),
  rgfm_level CHAR(1),
  rgfmsj     DATE,
  fmyxq      DATE,
  czydm      VARCHAR2(20),
  czymc      VARCHAR2(30),
  rgbzms     VARCHAR2(200),
  crtime     DATE
)
;
comment on table JKGL_DATA_QYJKM_JGB
  is '出口企业健康码结果表';
comment on column JKGL_DATA_QYJKM_JGB.djxh
  is '纳税人登记序号PK';
comment on column JKGL_DATA_QYJKM_JGB.jkm_level
  is '健康码等级（1绿 2黄 3红）';
comment on column JKGL_DATA_QYJKM_JGB.score_10
  is '信用分';
comment on column JKGL_DATA_QYJKM_JGB.score_20
  is '申报征收分';
comment on column JKGL_DATA_QYJKM_JGB.score_30
  is '出口退税分';
comment on column JKGL_DATA_QYJKM_JGB.score_40
  is '财务报表分';
comment on column JKGL_DATA_QYJKM_JGB.score_50
  is '发票供应链分';
comment on column JKGL_DATA_QYJKM_JGB.score_60
  is '其他分';
comment on column JKGL_DATA_QYJKM_JGB.score_zh
  is '健康码综合分';
comment on column JKGL_DATA_QYJKM_JGB.uptime
  is '更新时间';
comment on column JKGL_DATA_QYJKM_JGB.tsjsfs_dm
  is '退税计算方式
';
comment on column JKGL_DATA_QYJKM_JGB.note
  is '健康码构成说明
';
comment on column JKGL_DATA_QYJKM_JGB.rgfm_level
  is '人工赋码（1,2,3）
';
comment on column JKGL_DATA_QYJKM_JGB.rgfmsj
  is '人工赋码时间
';
comment on column JKGL_DATA_QYJKM_JGB.fmyxq
  is '人工赋码有效期止
';
comment on column JKGL_DATA_QYJKM_JGB.czydm
  is '操作员代码
';
comment on column JKGL_DATA_QYJKM_JGB.czymc
  is '操作员名称
';
comment on column JKGL_DATA_QYJKM_JGB.rgbzms
  is '人工赋码备注描述
';
alter table JKGL_DATA_QYJKM_JGB
  add constraint PK_JKGL_DATA_QYJKM_JGB primary key (DJXH);

prompt
prompt Creating table JKGL_DATA_QYJKM_LSB
prompt ==================================
prompt
create table JKGL_DATA_QYJKM_LSB
(
  id         NUMBER(20) not null,
  djxh       NUMBER(20) not null,
  jkm_level  CHAR(1),
  score_10   INTEGER,
  score_20   INTEGER,
  score_30   INTEGER,
  score_40   INTEGER,
  score_50   INTEGER,
  score_60   INTEGER,
  score_zh   INTEGER,
  uptime     DATE,
  tsjsfs_dm  CHAR(1),
  note       VARCHAR2(200),
  rgfm_level CHAR(1),
  rgfmsj     DATE,
  fmyxq      DATE,
  czydm      VARCHAR2(20),
  czymc      VARCHAR2(30),
  rgbzms     VARCHAR2(200)
)
;
comment on table JKGL_DATA_QYJKM_LSB
  is '出口企业健康码历史结果表';
comment on column JKGL_DATA_QYJKM_LSB.djxh
  is '纳税人登记序号PK';
comment on column JKGL_DATA_QYJKM_LSB.jkm_level
  is '健康码等级（1绿 2黄 3红）';
comment on column JKGL_DATA_QYJKM_LSB.score_10
  is '信用分';
comment on column JKGL_DATA_QYJKM_LSB.score_20
  is '申报征收分';
comment on column JKGL_DATA_QYJKM_LSB.score_30
  is '出口退税分';
comment on column JKGL_DATA_QYJKM_LSB.score_40
  is '财务报表分';
comment on column JKGL_DATA_QYJKM_LSB.score_50
  is '发票供应链分';
comment on column JKGL_DATA_QYJKM_LSB.score_60
  is '其他分';
comment on column JKGL_DATA_QYJKM_LSB.score_zh
  is '健康码综合分';
comment on column JKGL_DATA_QYJKM_LSB.uptime
  is '更新时间';
comment on column JKGL_DATA_QYJKM_LSB.tsjsfs_dm
  is '退税计算方式
';
comment on column JKGL_DATA_QYJKM_LSB.note
  is '健康码构成说明
';
comment on column JKGL_DATA_QYJKM_LSB.rgfm_level
  is '人工赋码（1,2,3）
';
comment on column JKGL_DATA_QYJKM_LSB.rgfmsj
  is '人工赋码时间
';
comment on column JKGL_DATA_QYJKM_LSB.fmyxq
  is '人工赋码有效期止
';
comment on column JKGL_DATA_QYJKM_LSB.czydm
  is '操作员代码
';
comment on column JKGL_DATA_QYJKM_LSB.czymc
  is '操作员名称
';
comment on column JKGL_DATA_QYJKM_LSB.rgbzms
  is '人工赋码备注描述
';
alter table JKGL_DATA_QYJKM_LSB
  add constraint PK_JKGL_DATA_QYJKM_LSB primary key (ID);

prompt
prompt Creating table JKGL_DATA_TASK
prompt =============================
prompt
create table JKGL_DATA_TASK
(
  bgqid  NUMBER(20) not null,
  sxzt   CHAR(1),
  tqbz   VARCHAR2(40),
  tqsj   DATE,
  wcsj   DATE,
  crtime DATE
)
;
comment on column JKGL_DATA_TASK.sxzt
  is '''0'',''待刷新'',''1'',''刷新中'',''2'',''已刷新''';
comment on column JKGL_DATA_TASK.tqbz
  is '提取标志';
comment on column JKGL_DATA_TASK.tqsj
  is '提取时间';
comment on column JKGL_DATA_TASK.wcsj
  is '完成时间';
comment on column JKGL_DATA_TASK.crtime
  is '任务创建时间';
alter table JKGL_DATA_TASK
  add constraint PK_JKGL_DATA_TASK primary key (BGQID);

prompt
prompt Creating table JKGL_DATA_TJ_ZB
prompt ==============================
prompt
create table JKGL_DATA_TJ_ZB
(
  bgqid    NUMBER(20) not null,
  zb_id    VARCHAR2(30) not null,
  zb_val   NUMBER(18,2),
  badpoint CHAR(1),
  params   VARCHAR2(4000),
  uptime   DATE default SYSDATE
)
;
comment on table JKGL_DATA_TJ_ZB
  is '报告期指标统计结果表';
comment on column JKGL_DATA_TJ_ZB.bgqid
  is '报告期ID PK';
comment on column JKGL_DATA_TJ_ZB.zb_id
  is '指标标识 PK';
comment on column JKGL_DATA_TJ_ZB.zb_val
  is '指标计算结果（逻辑型用1/0表示）';
comment on column JKGL_DATA_TJ_ZB.badpoint
  is '坏点标志 Y /N 当计算条件不满足或异常判断有条件不满足时，可打Y坏点，后续不参与健康综合评判';
comment on column JKGL_DATA_TJ_ZB.params
  is '记录计算参数[d]出口销售=100|出口数量=40[s]SQL脚本';
alter table JKGL_DATA_TJ_ZB
  add constraint JKGL_DATA_TJ_ZB primary key (BGQID, ZB_ID);

prompt
prompt Creating table JKGL_DATA_TJ_ZBU
prompt ===============================
prompt
create table JKGL_DATA_TJ_ZBU
(
  bgqid              NUMBER(20) not null,
  ck_bgdsl           NUMBER(10),
  ck_ckeusd          NUMBER(18,2),
  ck_ckermb          NUMBER(18,2),
  ck_sbdw_sl         NUMBER(10),
  ck_gb_sl           NUMBER(10),
  ck_bgdsl_de        NUMBER(10),
  ck_ckeusd_de       NUMBER(18,2),
  ck_bgdsl_st        NUMBER(10),
  ck_pxbgdsl         NUMBER(10),
  ck_zxbgdsl         NUMBER(18,2),
  ck_pjdbhgz         NUMBER(18,2),
  ck_ckeusd_lastyear NUMBER(18,2),
  zzs_xse_qb         NUMBER(18,2),
  zzs_xse_mdt        NUMBER(18,2),
  zzs_xse_ms         NUMBER(18,2),
  zzs_xxse           NUMBER(18,2),
  zzs_jxse           NUMBER(18,2),
  zzs_jxsezc         NUMBER(18,2),
  zzs_mdtbddkjxse    NUMBER(18,2),
  zzs_ynse           NUMBER(18,2),
  dz_xxfs_qb         NUMBER(10),
  dz_xxje_qb         NUMBER(18,2),
  dz_xxse_qb         NUMBER(18,2),
  dz_xxfs_zy         NUMBER(10),
  dz_xxje_zy         NUMBER(18,2),
  dz_xxse_zy         NUMBER(18,2),
  dz_xxfs_pt         NUMBER(10),
  dz_xxje_pt         NUMBER(18,2),
  dz_xxse_pt         NUMBER(18,2),
  dz_xxfs_ck         NUMBER(10),
  dz_xxje_ck         NUMBER(18,2),
  dz_jxfs_qb         NUMBER(10),
  dz_jxje_qb         NUMBER(18,2),
  dz_jxse_qb         NUMBER(18,2),
  dz_jxfs_zy         NUMBER(10),
  dz_jxje_zy         NUMBER(18,2),
  dz_jxse_zy         NUMBER(18,2),
  dz_jxfs_pt         NUMBER(10),
  dz_jxje_pt         NUMBER(18,2),
  dz_jxse_pt         NUMBER(18,2),
  dz_jxfs_dgkj       NUMBER(10),
  dz_jxje_dgkj       NUMBER(18,2),
  dz_jxse_dgkj       NUMBER(18,2),
  dz_jxse_jks        NUMBER(18,2),
  dz_jxje_ncp        NUMBER(18,2),
  dz_jxse_ncp        NUMBER(18,2),
  dz_dfje_sr         NUMBER(18,2),
  dz_dfje_zc         NUMBER(18,2),
  dz_wtjg            NUMBER(18,2),
  dz_yfje            NUMBER(18,2),
  dz_jxje_sn         NUMBER(18,2),
  dz_jxje_sw         NUMBER(18,2),
  ts_ckeusd          NUMBER(18,2),
  ts_ckermb          NUMBER(18,2),
  ts_tse_sb          NUMBER(18,2),
  ts_mde_sb          NUMBER(18,2),
  ts_tse_hz          NUMBER(18,2),
  ts_mde_hz          NUMBER(18,2),
  ts_tse_bl          NUMBER(18,2),
  ts_mde_bl          NUMBER(18,2),
  ts_ckermb_stzc     NUMBER(18,2),
  ts_jsje            NUMBER(18,2),
  ts_hhcb            NUMBER(18,2),
  ts_jhfp_je_dg      NUMBER(18,2),
  ts_jhfp_fs_dg      NUMBER(10),
  ts_jhfp_je         NUMBER(18,2),
  ts_jhfp_fs         NUMBER(10),
  ts_jhfp_je_cq1     NUMBER(18,2),
  ts_jhfp_fs_cq1     NUMBER(10),
  ts_jhfp_je_cq2     NUMBER(18,2),
  ts_jhfp_fs_cq2     NUMBER(10),
  ts_ghs_num         NUMBER(10),
  zc_yszk_qc         NUMBER(18,2),
  zc_yszk_qm         NUMBER(18,2),
  zc_yfzk_qc         NUMBER(18,2),
  zc_yfzk_qm         NUMBER(18,2),
  zc_gdzc_qc         NUMBER(18,2),
  zc_gdzc_qm         NUMBER(18,2),
  zc_ch_qc           NUMBER(18,2),
  zc_ch_qm           NUMBER(18,2),
  zc_zcze_qc         NUMBER(18,2),
  zc_zcze_qm         NUMBER(18,2),
  zc_fzze_qc         NUMBER(18,2),
  zc_fzze_qm         NUMBER(18,2),
  lr_yysr            NUMBER(18,2),
  lr_yycb            NUMBER(18,2),
  lr_xsfy            NUMBER(18,2),
  lr_glfy            NUMBER(18,2),
  lr_lrze            NUMBER(18,2),
  sds_yysr           NUMBER(18,2),
  sds_ynssde         NUMBER(18,2),
  ts_bgdsl           NUMBER(10),
  ts_bgdsl_cq        NUMBER(10),
  ts_ckeusd_cq       NUMBER(18,2),
  zc_syzqy_qc        NUMBER(18,2),
  zc_syzqy_qm        NUMBER(18,2),
  zc_ssgdqy_qc       NUMBER(18,2),
  zc_ssgdqy_qm       NUMBER(18,2),
  zc_ldzc_qc         NUMBER(18,2),
  zc_ldzc_qm         NUMBER(18,2),
  zc_yuszk_qc        NUMBER(18,2),
  zc_yuszk_qm        NUMBER(18,2),
  zc_yufzk_qc        NUMBER(18,2),
  zc_yufzk_qm        NUMBER(18,2),
  zc_ldfzze_qc       NUMBER(18,2),
  zc_ldfzze_qm       NUMBER(18,2),
  lr_qtsr            NUMBER(18,2),
  lr_sjjfj           NUMBER(18,2),
  lr_cwfy            NUMBER(18,2),
  lr_jlr             NUMBER(18,2),
  lr_sds             NUMBER(18,2),
  lr_lxzc            NUMBER(18,2),
  lr_yylr            NUMBER(18,2),
  ts_mtscke          NUMBER(18,2)
)
;
comment on table JKGL_DATA_TJ_ZBU
  is '报告期指标元统计--单项数据';
comment on column JKGL_DATA_TJ_ZBU.bgqid
  is '报告期ID';
comment on column JKGL_DATA_TJ_ZBU.ck_bgdsl
  is '出口_报关单数量';
comment on column JKGL_DATA_TJ_ZBU.ck_ckeusd
  is '出口_出口额USD';
comment on column JKGL_DATA_TJ_ZBU.ck_ckermb
  is '出口_出口额RMB';
comment on column JKGL_DATA_TJ_ZBU.ck_sbdw_sl
  is '出口_申报单位数量';
comment on column JKGL_DATA_TJ_ZBU.ck_gb_sl
  is '出口_目的国数量';
comment on column JKGL_DATA_TJ_ZBU.ck_bgdsl_de
  is '出口_大额报关单数量';
comment on column JKGL_DATA_TJ_ZBU.ck_ckeusd_de
  is '出口_大额报关单出口额USD';
comment on column JKGL_DATA_TJ_ZBU.ck_bgdsl_st
  is '出口_四同报关单数量';
comment on column JKGL_DATA_TJ_ZBU.ck_pxbgdsl
  is '出口_拼箱报关单数量';
comment on column JKGL_DATA_TJ_ZBU.ck_zxbgdsl
  is '出口_整箱报关单数量';
comment on column JKGL_DATA_TJ_ZBU.ck_pjdbhgz
  is '出口_平均单笔货柜值';
comment on column JKGL_DATA_TJ_ZBU.ck_ckeusd_lastyear
  is '出口_最近12个月出口额USD';
comment on column JKGL_DATA_TJ_ZBU.zzs_xse_qb
  is '增值税_销售额_全部';
comment on column JKGL_DATA_TJ_ZBU.zzs_xse_mdt
  is '增值税_销售额_免抵退出口';
comment on column JKGL_DATA_TJ_ZBU.zzs_xse_ms
  is '增值税_销售额_免税';
comment on column JKGL_DATA_TJ_ZBU.zzs_xxse
  is '增值税_销项税额';
comment on column JKGL_DATA_TJ_ZBU.zzs_jxse
  is '增值税_进项税额';
comment on column JKGL_DATA_TJ_ZBU.zzs_jxsezc
  is '增值税_进项税额转出';
comment on column JKGL_DATA_TJ_ZBU.zzs_mdtbddkjxse
  is '增值税_免抵退不得抵扣进项税额';
comment on column JKGL_DATA_TJ_ZBU.zzs_ynse
  is '增值税_应纳税额';
comment on column JKGL_DATA_TJ_ZBU.dz_xxfs_qb
  is '底账_销项份数_全部';
comment on column JKGL_DATA_TJ_ZBU.dz_xxje_qb
  is '底账_销项金额_全部';
comment on column JKGL_DATA_TJ_ZBU.dz_xxse_qb
  is '底账_销项税额_全部';
comment on column JKGL_DATA_TJ_ZBU.dz_xxfs_zy
  is '底账_销项份数_专票';
comment on column JKGL_DATA_TJ_ZBU.dz_xxje_zy
  is '底账_销项金额_专票';
comment on column JKGL_DATA_TJ_ZBU.dz_xxse_zy
  is '底账_销项税额_专票';
comment on column JKGL_DATA_TJ_ZBU.dz_xxfs_pt
  is '底账_销项份数_普票';
comment on column JKGL_DATA_TJ_ZBU.dz_xxje_pt
  is '底账_销项金额_普票';
comment on column JKGL_DATA_TJ_ZBU.dz_xxse_pt
  is '底账_销项税额_普票';
comment on column JKGL_DATA_TJ_ZBU.dz_xxfs_ck
  is '底账_销项份数_出口';
comment on column JKGL_DATA_TJ_ZBU.dz_xxje_ck
  is '底账_销项金额_出口';
comment on column JKGL_DATA_TJ_ZBU.dz_jxfs_qb
  is '底账_全部进项份数';
comment on column JKGL_DATA_TJ_ZBU.dz_jxje_qb
  is '底账_全部进项金额';
comment on column JKGL_DATA_TJ_ZBU.dz_jxse_qb
  is '底账_全部进项税额';
comment on column JKGL_DATA_TJ_ZBU.dz_jxfs_zy
  is '底账_进项份数_专票';
comment on column JKGL_DATA_TJ_ZBU.dz_jxje_zy
  is '底账_进项金额_专票';
comment on column JKGL_DATA_TJ_ZBU.dz_jxse_zy
  is '底账_进项税额_专票';
comment on column JKGL_DATA_TJ_ZBU.dz_jxfs_pt
  is '底账_进项份数_普票';
comment on column JKGL_DATA_TJ_ZBU.dz_jxje_pt
  is '底账_进项金额_普票';
comment on column JKGL_DATA_TJ_ZBU.dz_jxse_pt
  is '底账_进项税额_普票';
comment on column JKGL_DATA_TJ_ZBU.dz_jxfs_dgkj
  is '底账_进项份数_专票顶格开具';
comment on column JKGL_DATA_TJ_ZBU.dz_jxje_dgkj
  is '底账_进项金额_专票顶格开具';
comment on column JKGL_DATA_TJ_ZBU.dz_jxse_dgkj
  is '底账_进项税额_专票顶格开具';
comment on column JKGL_DATA_TJ_ZBU.dz_jxse_jks
  is '底账_进项税额_缴款书';
comment on column JKGL_DATA_TJ_ZBU.dz_jxje_ncp
  is '增值税_进项金额_农产品';
comment on column JKGL_DATA_TJ_ZBU.dz_jxse_ncp
  is '增值税_进项税额_农产品';
comment on column JKGL_DATA_TJ_ZBU.dz_dfje_sr
  is '底账_电费收入（销项）';
comment on column JKGL_DATA_TJ_ZBU.dz_dfje_zc
  is '底账_电费支出（进项）';
comment on column JKGL_DATA_TJ_ZBU.dz_wtjg
  is '底账_委托加工费支出';
comment on column JKGL_DATA_TJ_ZBU.dz_yfje
  is '底账_运费支出';
comment on column JKGL_DATA_TJ_ZBU.dz_jxje_sn
  is '底账_进项金额_省内';
comment on column JKGL_DATA_TJ_ZBU.dz_jxje_sw
  is '底账_进项金额_省外';
comment on column JKGL_DATA_TJ_ZBU.ts_ckeusd
  is '退税_出口额USD';
comment on column JKGL_DATA_TJ_ZBU.ts_ckermb
  is '退税_出口额RMB';
comment on column JKGL_DATA_TJ_ZBU.ts_tse_sb
  is '退税_退税额_申报';
comment on column JKGL_DATA_TJ_ZBU.ts_mde_sb
  is '退税_免抵额_申报';
comment on column JKGL_DATA_TJ_ZBU.ts_tse_hz
  is '退税_退税_核准';
comment on column JKGL_DATA_TJ_ZBU.ts_mde_hz
  is '退税_免抵_核准';
comment on column JKGL_DATA_TJ_ZBU.ts_tse_bl
  is '退税_退税_办理';
comment on column JKGL_DATA_TJ_ZBU.ts_mde_bl
  is '退税_免抵_办理';
comment on column JKGL_DATA_TJ_ZBU.ts_ckermb_stzc
  is '退税_视同自产出口额';
comment on column JKGL_DATA_TJ_ZBU.ts_jsje
  is '退税_计税金额（免退税）';
comment on column JKGL_DATA_TJ_ZBU.ts_hhcb
  is '退税_每百元出口成本（免退税）';
comment on column JKGL_DATA_TJ_ZBU.ts_jhfp_je_dg
  is '退税_顶格开票金额';
comment on column JKGL_DATA_TJ_ZBU.ts_jhfp_fs_dg
  is '退税_顶格开票份数';
comment on column JKGL_DATA_TJ_ZBU.ts_jhfp_je
  is '退税_发票总金额';
comment on column JKGL_DATA_TJ_ZBU.ts_jhfp_fs
  is '退税_发票总份数';
comment on column JKGL_DATA_TJ_ZBU.ts_jhfp_je_cq1
  is '退税_超期1发票金额';
comment on column JKGL_DATA_TJ_ZBU.ts_jhfp_fs_cq1
  is '退税_超期1发票份数';
comment on column JKGL_DATA_TJ_ZBU.ts_jhfp_je_cq2
  is '退税_超期2发票金额';
comment on column JKGL_DATA_TJ_ZBU.ts_jhfp_fs_cq2
  is '退税_超期2发票份数';
comment on column JKGL_DATA_TJ_ZBU.ts_ghs_num
  is '退税_供货商个数';
comment on column JKGL_DATA_TJ_ZBU.zc_yszk_qc
  is '资产_应收账款_期初';
comment on column JKGL_DATA_TJ_ZBU.zc_yszk_qm
  is '资产_应收账款_期末';
comment on column JKGL_DATA_TJ_ZBU.zc_yfzk_qc
  is '资产_应付账款_期初';
comment on column JKGL_DATA_TJ_ZBU.zc_yfzk_qm
  is '资产_应付账款_期末';
comment on column JKGL_DATA_TJ_ZBU.zc_gdzc_qc
  is '资产_固定资产_期初';
comment on column JKGL_DATA_TJ_ZBU.zc_gdzc_qm
  is '资产_固定资产_期末';
comment on column JKGL_DATA_TJ_ZBU.zc_ch_qc
  is '资产_存货_期初';
comment on column JKGL_DATA_TJ_ZBU.zc_ch_qm
  is '资产_存货_期末';
comment on column JKGL_DATA_TJ_ZBU.zc_zcze_qc
  is '资产_资产总额_期初';
comment on column JKGL_DATA_TJ_ZBU.zc_zcze_qm
  is '资产_资产总额_期末';
comment on column JKGL_DATA_TJ_ZBU.zc_fzze_qc
  is '资产_负债总额_期初';
comment on column JKGL_DATA_TJ_ZBU.zc_fzze_qm
  is '资产_负债总额_期末';
comment on column JKGL_DATA_TJ_ZBU.lr_yysr
  is '利润_主营业务收入';
comment on column JKGL_DATA_TJ_ZBU.lr_yycb
  is '利润_主营业务成本';
comment on column JKGL_DATA_TJ_ZBU.lr_xsfy
  is '利润_销售费用';
comment on column JKGL_DATA_TJ_ZBU.lr_glfy
  is '利润_管理费用';
comment on column JKGL_DATA_TJ_ZBU.lr_lrze
  is '利润_利润总额';
comment on column JKGL_DATA_TJ_ZBU.sds_yysr
  is '所得税_营业收入';
comment on column JKGL_DATA_TJ_ZBU.sds_ynssde
  is '所得税_应纳税所得额';
comment on column JKGL_DATA_TJ_ZBU.ts_bgdsl
  is '退税_报关单数量';
comment on column JKGL_DATA_TJ_ZBU.ts_bgdsl_cq
  is '退税_报关单数量_超期申报';
comment on column JKGL_DATA_TJ_ZBU.ts_ckeusd_cq
  is '退税_出口额USD_超期申报';
comment on column JKGL_DATA_TJ_ZBU.zc_syzqy_qc
  is '资产_所有者权益_期初';
comment on column JKGL_DATA_TJ_ZBU.zc_syzqy_qm
  is '资产_所有者权益_期末';
comment on column JKGL_DATA_TJ_ZBU.zc_ssgdqy_qc
  is '资产_少数股东权益_期初';
comment on column JKGL_DATA_TJ_ZBU.zc_ssgdqy_qm
  is '资产_少数股东权益_期末';
comment on column JKGL_DATA_TJ_ZBU.zc_ldzc_qc
  is '资产_流动资产_期初';
comment on column JKGL_DATA_TJ_ZBU.zc_ldzc_qm
  is '资产_流动资产_期末';
comment on column JKGL_DATA_TJ_ZBU.zc_yuszk_qc
  is '资产_预收账款_期初';
comment on column JKGL_DATA_TJ_ZBU.zc_yuszk_qm
  is '资产_预收账款_期末';
comment on column JKGL_DATA_TJ_ZBU.zc_yufzk_qc
  is '资产_预付账款_期初';
comment on column JKGL_DATA_TJ_ZBU.zc_yufzk_qm
  is '资产_预付账款_期末';
comment on column JKGL_DATA_TJ_ZBU.zc_ldfzze_qc
  is '资产_流动负债总额_期初';
comment on column JKGL_DATA_TJ_ZBU.zc_ldfzze_qm
  is '资产_流动负债总额_期末';
comment on column JKGL_DATA_TJ_ZBU.lr_qtsr
  is '利润_其它收入';
comment on column JKGL_DATA_TJ_ZBU.lr_sjjfj
  is '利润_税金及附加';
comment on column JKGL_DATA_TJ_ZBU.lr_cwfy
  is '利润_财务费用';
comment on column JKGL_DATA_TJ_ZBU.lr_jlr
  is '利润_净利润';
comment on column JKGL_DATA_TJ_ZBU.lr_sds
  is '利润_所得税';
comment on column JKGL_DATA_TJ_ZBU.lr_lxzc
  is '利润_利息支出';
comment on column JKGL_DATA_TJ_ZBU.lr_yylr
  is '利润_营业利润';
comment on column JKGL_DATA_TJ_ZBU.ts_mtscke
  is '退税_免退税期间出口额RMB';
alter table JKGL_DATA_TJ_ZBU
  add constraint PK_JKGL_DATA_TJ_ZBU primary key (BGQID);

prompt
prompt Creating table JKGL_DATA_TJ_ZBU_CKGB
prompt ====================================
prompt
create table JKGL_DATA_TJ_ZBU_CKGB
(
  id     NUMBER(20) not null,
  bgqid  NUMBER(20),
  gb_dm  VARCHAR2(3),
  ckeusd NUMBER(18,2),
  ckermb NUMBER(18,2),
  kasl   INTEGER,
  sbdwsl INTEGER,
  ysfssl INTEGER,
  mgbz   CHAR(1) default '0'
)
;
comment on table JKGL_DATA_TJ_ZBU_CKGB
  is '报告期指标元统计-出口国别汇总';
comment on column JKGL_DATA_TJ_ZBU_CKGB.id
  is '序号';
comment on column JKGL_DATA_TJ_ZBU_CKGB.bgqid
  is '报告期ID';
comment on column JKGL_DATA_TJ_ZBU_CKGB.gb_dm
  is '国别代码';
comment on column JKGL_DATA_TJ_ZBU_CKGB.ckeusd
  is '出口额USD';
comment on column JKGL_DATA_TJ_ZBU_CKGB.ckermb
  is '出口额';
comment on column JKGL_DATA_TJ_ZBU_CKGB.kasl
  is '口岸数量';
comment on column JKGL_DATA_TJ_ZBU_CKGB.sbdwsl
  is '申报单位数量';
comment on column JKGL_DATA_TJ_ZBU_CKGB.ysfssl
  is '运输方式数量';
comment on column JKGL_DATA_TJ_ZBU_CKGB.mgbz
  is '敏感标志  1敏感/0正常';
create index IDX_JKGL_DATA_TJ_ZBU_CKGB on JKGL_DATA_TJ_ZBU_CKGB (BGQID, GB_DM);
alter table JKGL_DATA_TJ_ZBU_CKGB
  add constraint PK_JKGL_DATA_TJ_ZBU_CKGB primary key (ID);

prompt
prompt Creating table JKGL_DATA_TJ_ZBU_CKKA
prompt ====================================
prompt
create table JKGL_DATA_TJ_ZBU_CKKA
(
  id     NUMBER(20) not null,
  bgqid  NUMBER(20),
  ka_dm  VARCHAR2(4),
  ckeusd NUMBER(18,2),
  ckermb NUMBER(18,2),
  sbdwsl INTEGER,
  mgbz   CHAR(1) default '0'
)
;
comment on table JKGL_DATA_TJ_ZBU_CKKA
  is '报告期指标元统计-出口口岸汇总';
comment on column JKGL_DATA_TJ_ZBU_CKKA.id
  is '序号';
comment on column JKGL_DATA_TJ_ZBU_CKKA.bgqid
  is '报告期ID';
comment on column JKGL_DATA_TJ_ZBU_CKKA.ka_dm
  is '口岸代码';
comment on column JKGL_DATA_TJ_ZBU_CKKA.ckeusd
  is '出口额USD';
comment on column JKGL_DATA_TJ_ZBU_CKKA.ckermb
  is '出口额';
comment on column JKGL_DATA_TJ_ZBU_CKKA.sbdwsl
  is '申报单位数量';
comment on column JKGL_DATA_TJ_ZBU_CKKA.mgbz
  is '敏感标志';
create index IDX_JKGL_DATA_TJ_ZBU_CKKA on JKGL_DATA_TJ_ZBU_CKKA (BGQID, KA_DM);
alter table JKGL_DATA_TJ_ZBU_CKKA
  add constraint PK_JKGL_DATA_TJ_ZBU_CKKA primary key (ID);

prompt
prompt Creating table JKGL_DATA_TJ_ZBU_CKSP
prompt ====================================
prompt
create table JKGL_DATA_TJ_ZBU_CKSP
(
  id     NUMBER(20) not null,
  bgqid  NUMBER(20),
  sp8_dm VARCHAR2(8),
  cksl   NUMBER(18,2),
  ckeusd NUMBER(18,2),
  ckermb NUMBER(18,2),
  mgbz   CHAR(1) default '0',
  ckdj   NUMBER(18,2),
  spdl   VARCHAR2(2),
  spmc   VARCHAR2(80),
  newbz  CHAR(1) default '0'
)
;
comment on table JKGL_DATA_TJ_ZBU_CKSP
  is '报告期指标元统计-出口商品汇总';
comment on column JKGL_DATA_TJ_ZBU_CKSP.id
  is '序号';
comment on column JKGL_DATA_TJ_ZBU_CKSP.bgqid
  is '报告期ID';
comment on column JKGL_DATA_TJ_ZBU_CKSP.sp8_dm
  is '商品代码（8位）';
comment on column JKGL_DATA_TJ_ZBU_CKSP.cksl
  is '出口数量';
comment on column JKGL_DATA_TJ_ZBU_CKSP.ckeusd
  is '出口额USD';
comment on column JKGL_DATA_TJ_ZBU_CKSP.ckermb
  is '出口额';
comment on column JKGL_DATA_TJ_ZBU_CKSP.mgbz
  is '敏感标志 1/0';
comment on column JKGL_DATA_TJ_ZBU_CKSP.ckdj
  is '出口单价';
comment on column JKGL_DATA_TJ_ZBU_CKSP.spdl
  is '商品大类 2位';
comment on column JKGL_DATA_TJ_ZBU_CKSP.spmc
  is '商品名称';
comment on column JKGL_DATA_TJ_ZBU_CKSP.newbz
  is '新增（跨大类）标志';
create index IDX_JKGL_DATA_TJ_ZBU_CKSP on JKGL_DATA_TJ_ZBU_CKSP (BGQID, SP8_DM);
alter table JKGL_DATA_TJ_ZBU_CKSP
  add constraint PK_JKGL_DATA_TJ_ZBU_CKSP primary key (ID);

prompt
prompt Creating table JKGL_DATA_TJ_ZBU_DZGF
prompt ====================================
prompt
create table JKGL_DATA_TJ_ZBU_DZGF
(
  id     NUMBER(20) not null,
  bgqid  NUMBER(20),
  gfsbh  VARCHAR2(20),
  gfmc   VARCHAR2(100),
  fs     NUMBER(10),
  je     NUMBER(18,2),
  se     NUMBER(18,2),
  zyspmc VARCHAR2(200),
  zyspje NUMBER(18,2)
)
;
comment on table JKGL_DATA_TJ_ZBU_DZGF
  is '报告期指标元统计-底账购方汇总(专票供应链下游)';
comment on column JKGL_DATA_TJ_ZBU_DZGF.id
  is '序号';
comment on column JKGL_DATA_TJ_ZBU_DZGF.bgqid
  is '报告期ID';
comment on column JKGL_DATA_TJ_ZBU_DZGF.gfsbh
  is '供货方税号';
comment on column JKGL_DATA_TJ_ZBU_DZGF.gfmc
  is '供货方名称';
comment on column JKGL_DATA_TJ_ZBU_DZGF.fs
  is '发票份数';
comment on column JKGL_DATA_TJ_ZBU_DZGF.je
  is '发票不含税金额';
comment on column JKGL_DATA_TJ_ZBU_DZGF.se
  is '发票税额';
comment on column JKGL_DATA_TJ_ZBU_DZGF.zyspmc
  is '主要商品名称';
comment on column JKGL_DATA_TJ_ZBU_DZGF.zyspje
  is '主要商品金额';
create index IDX_JKGL_DATA_TJ_ZBU_DZGF on JKGL_DATA_TJ_ZBU_DZGF (BGQID, GFSBH);
alter table JKGL_DATA_TJ_ZBU_DZGF
  add constraint PK_JKGL_DATA_TJ_ZBU_DZGF primary key (ID);

prompt
prompt Creating table JKGL_DATA_TJ_ZBU_DZSPJX
prompt ======================================
prompt
create table JKGL_DATA_TJ_ZBU_DZSPJX
(
  id    NUMBER(20) not null,
  bgqid NUMBER(20),
  spmc  VARCHAR2(200),
  spsm  VARCHAR2(60),
  je    NUMBER(18,2),
  se    NUMBER(18,2)
)
;
comment on table JKGL_DATA_TJ_ZBU_DZSPJX
  is '报告期指标元统计-底账商品汇总(专票进项货物)';
comment on column JKGL_DATA_TJ_ZBU_DZSPJX.id
  is '序号';
comment on column JKGL_DATA_TJ_ZBU_DZSPJX.bgqid
  is '报告期ID';
comment on column JKGL_DATA_TJ_ZBU_DZSPJX.spmc
  is '商品名称（只取排名前20）';
comment on column JKGL_DATA_TJ_ZBU_DZSPJX.spsm
  is '商品税目';
comment on column JKGL_DATA_TJ_ZBU_DZSPJX.je
  is '金额';
comment on column JKGL_DATA_TJ_ZBU_DZSPJX.se
  is '税额';
create index IDX_JKGL_DATA_TJ_ZBU_DZSPJX on JKGL_DATA_TJ_ZBU_DZSPJX (BGQID, SPMC);
alter table JKGL_DATA_TJ_ZBU_DZSPJX
  add constraint PK_JKGL_DATA_TJ_ZBU_DZSPJX primary key (ID);

prompt
prompt Creating table JKGL_DATA_TJ_ZBU_DZSPXX
prompt ======================================
prompt
create table JKGL_DATA_TJ_ZBU_DZSPXX
(
  id    NUMBER(20) not null,
  bgqid NUMBER(20),
  spmc  VARCHAR2(150),
  spsm  VARCHAR2(60),
  je    NUMBER(18,2),
  se    NUMBER(18,2)
)
;
comment on table JKGL_DATA_TJ_ZBU_DZSPXX
  is '报告期指标元统计-底账商品汇总(专票销项货物)';
comment on column JKGL_DATA_TJ_ZBU_DZSPXX.id
  is '序号';
comment on column JKGL_DATA_TJ_ZBU_DZSPXX.bgqid
  is '报告期ID';
comment on column JKGL_DATA_TJ_ZBU_DZSPXX.spmc
  is '商品名称（只取排名前20）';
comment on column JKGL_DATA_TJ_ZBU_DZSPXX.spsm
  is '商品税目';
comment on column JKGL_DATA_TJ_ZBU_DZSPXX.je
  is '金额';
comment on column JKGL_DATA_TJ_ZBU_DZSPXX.se
  is '税额';
create index IDX_JKGL_DATA_TJ_ZBU_DZSPXX on JKGL_DATA_TJ_ZBU_DZSPXX (BGQID, SPMC);
alter table JKGL_DATA_TJ_ZBU_DZSPXX
  add constraint PK_JKGL_DATA_TJ_ZBU_DZSPXX primary key (ID);

prompt
prompt Creating table JKGL_DATA_TJ_ZBU_DZXF
prompt ====================================
prompt
create table JKGL_DATA_TJ_ZBU_DZXF
(
  id     NUMBER(20) not null,
  bgqid  NUMBER(20),
  xfsbh  VARCHAR2(20),
  xfmc   VARCHAR2(100),
  fs     NUMBER(10),
  je     NUMBER(18,2),
  se     NUMBER(18,2),
  zyspmc VARCHAR2(200),
  zyspje NUMBER(18,2)
)
;
comment on table JKGL_DATA_TJ_ZBU_DZXF
  is '报告期指标元统计-底账销方汇总(专票供应链上游)';
comment on column JKGL_DATA_TJ_ZBU_DZXF.id
  is '序号';
comment on column JKGL_DATA_TJ_ZBU_DZXF.bgqid
  is '报告期ID';
comment on column JKGL_DATA_TJ_ZBU_DZXF.xfsbh
  is '销货方税号';
comment on column JKGL_DATA_TJ_ZBU_DZXF.xfmc
  is '销货方名称';
comment on column JKGL_DATA_TJ_ZBU_DZXF.fs
  is '发票份数';
comment on column JKGL_DATA_TJ_ZBU_DZXF.je
  is '发票不含税金额';
comment on column JKGL_DATA_TJ_ZBU_DZXF.se
  is '发票税额';
comment on column JKGL_DATA_TJ_ZBU_DZXF.zyspmc
  is '主要商品名称';
comment on column JKGL_DATA_TJ_ZBU_DZXF.zyspje
  is '主要商品金额';
create index IDX_JKGL_DATA_TJ_ZBU_DZXF on JKGL_DATA_TJ_ZBU_DZXF (BGQID, XFSBH);
alter table JKGL_DATA_TJ_ZBU_DZXF
  add constraint PK_JKGL_DATA_TJ_ZBU_DZXF primary key (ID);

prompt
prompt Creating table JKGL_DATA_TJ_ZBU_KZ
prompt ==================================
prompt
create table JKGL_DATA_TJ_ZBU_KZ
(
  bgqid        NUMBER(20) not null,
  cw_mll       NUMBER(18,2),
  cw_hysfl     NUMBER(18,2),
  cw_yylrl     NUMBER(18,2),
  cw_cbfylrl   NUMBER(18,2),
  cw_zzcbcl    NUMBER(18,2),
  cw_jzcsyl    NUMBER(18,2),
  cw_yysrtbzzl NUMBER(18,2),
  cw_jlrtbzzl  NUMBER(18,2),
  cw_zzczzl    NUMBER(18,2),
  cw_ldbl      NUMBER(18,2),
  cw_sdbl      NUMBER(18,2),
  cw_zcfzl     NUMBER(18,2),
  cw_chzzl     NUMBER(18,2),
  cw_yszkzzl   NUMBER(18,2),
  ck_ckusd_tb  NUMBER(18,2),
  ts_tmse_tb   NUMBER(18,2)
)
;
comment on table JKGL_DATA_TJ_ZBU_KZ
  is '报告期指标元统计--单项数据扩展';
comment on column JKGL_DATA_TJ_ZBU_KZ.bgqid
  is '报告期ID';
comment on column JKGL_DATA_TJ_ZBU_KZ.cw_mll
  is '财务_毛利率，限值[-900,100] ';
comment on column JKGL_DATA_TJ_ZBU_KZ.cw_hysfl
  is '财务_还原税负率，限值[-100,100] ';
comment on column JKGL_DATA_TJ_ZBU_KZ.cw_yylrl
  is '财务_营业利润率，限值[-900,100] ';
comment on column JKGL_DATA_TJ_ZBU_KZ.cw_cbfylrl
  is '财务_成本费用利润率，限值[-1100,100] ';
comment on column JKGL_DATA_TJ_ZBU_KZ.cw_zzcbcl
  is '财务_总资产报酬率，限值[-100,1000] ';
comment on column JKGL_DATA_TJ_ZBU_KZ.cw_jzcsyl
  is '财务_净资产收益率，限值[-100,1000] ';
comment on column JKGL_DATA_TJ_ZBU_KZ.cw_yysrtbzzl
  is '财务_营业收入同比增长率，限值[-6000,6000] ';
comment on column JKGL_DATA_TJ_ZBU_KZ.cw_jlrtbzzl
  is '财务_净利润同比增长率，限值[-6000,6000] ';
comment on column JKGL_DATA_TJ_ZBU_KZ.cw_zzczzl
  is '财务_总资产增长率，限值[-100,1000] ';
comment on column JKGL_DATA_TJ_ZBU_KZ.cw_ldbl
  is '财务_流动比率，限值[10,1000] ';
comment on column JKGL_DATA_TJ_ZBU_KZ.cw_sdbl
  is '财务_速动比率，限值[10,1000] ';
comment on column JKGL_DATA_TJ_ZBU_KZ.cw_zcfzl
  is '财务_资产负债率，限值[10,1000] ';
comment on column JKGL_DATA_TJ_ZBU_KZ.cw_chzzl
  is '财务_存货周转率，限值[0,360] ';
comment on column JKGL_DATA_TJ_ZBU_KZ.cw_yszkzzl
  is '财务_应收账款周转率，限值[0,360] ';
comment on column JKGL_DATA_TJ_ZBU_KZ.ck_ckusd_tb
  is '出口_美元出口额_同比，限值[0,6000] ';
comment on column JKGL_DATA_TJ_ZBU_KZ.ts_tmse_tb
  is '退税_退免税额_同比，限值[0,6000] ';
create index PK_JKGL_DATA_TJ_ZBU_KZ on JKGL_DATA_TJ_ZBU_KZ (BGQID);

prompt
prompt Creating table JKGL_DATA_TJ_ZBU_QYXX
prompt ====================================
prompt
create table JKGL_DATA_TJ_ZBU_QYXX
(
  bgqid    NUMBER(20) not null,
  fr_xm    VARCHAR2(150),
  fr_zjhm  VARCHAR2(30),
  skr_xm   VARCHAR2(150),
  skr_zjhm VARCHAR2(30),
  cwr_xm   VARCHAR2(150),
  cwr_zjhm VARCHAR2(30),
  bsr_xm   VARCHAR2(150),
  bsr_zjhm VARCHAR2(30),
  flglcd   CHAR(1),
  jyyfsl   NUMBER(10),
  ckyfsl   NUMBER(10),
  jycdmj   NUMBER(10),
  zcdz     VARCHAR2(300),
  jydz     VARCHAR2(300)
)
;
comment on table JKGL_DATA_TJ_ZBU_QYXX
  is '报告期指标元统计-企业基础信息';
comment on column JKGL_DATA_TJ_ZBU_QYXX.bgqid
  is '报告期ID';
comment on column JKGL_DATA_TJ_ZBU_QYXX.fr_xm
  is '法人代表姓名';
comment on column JKGL_DATA_TJ_ZBU_QYXX.fr_zjhm
  is '法人代表身份证';
comment on column JKGL_DATA_TJ_ZBU_QYXX.skr_xm
  is '实际控制人姓名';
comment on column JKGL_DATA_TJ_ZBU_QYXX.skr_zjhm
  is '实际控制人身份证';
comment on column JKGL_DATA_TJ_ZBU_QYXX.cwr_xm
  is '财务负责人姓名';
comment on column JKGL_DATA_TJ_ZBU_QYXX.cwr_zjhm
  is '财务负责人身份证';
comment on column JKGL_DATA_TJ_ZBU_QYXX.bsr_xm
  is '办税人姓名';
comment on column JKGL_DATA_TJ_ZBU_QYXX.bsr_zjhm
  is '办税人身份证';
comment on column JKGL_DATA_TJ_ZBU_QYXX.flglcd
  is '分类管理等级';
comment on column JKGL_DATA_TJ_ZBU_QYXX.jyyfsl
  is '经营月数-税务登记至今月数';
comment on column JKGL_DATA_TJ_ZBU_QYXX.ckyfsl
  is '出口月数-首次出口至今的月数';
comment on column JKGL_DATA_TJ_ZBU_QYXX.jycdmj
  is '经营（办公）场地面积';
comment on column JKGL_DATA_TJ_ZBU_QYXX.zcdz
  is '注册地址';
comment on column JKGL_DATA_TJ_ZBU_QYXX.jydz
  is '经营地址';
alter table JKGL_DATA_TJ_ZBU_QYXX
  add constraint PK_JKGL_DATA_TJ_ZBU_QYXX primary key (BGQID);

prompt
prompt Creating table JKGL_DATA_TJ_ZBU_TSGH
prompt ====================================
prompt
create table JKGL_DATA_TJ_ZBU_TSGH
(
  id     NUMBER(20) not null,
  bgqid  NUMBER(20),
  ghfsh  VARCHAR2(20),
  jhje   NUMBER(18,2),
  tse    NUMBER(18,2),
  fxqybz CHAR(1) default '0',
  fxdqbz CHAR(1) default '0',
  snwbz  CHAR(1) default '0',
  fzchbz CHAR(1) default '0',
  newbz  CHAR(1) default '0'
)
;
comment on table JKGL_DATA_TJ_ZBU_TSGH
  is '报告期指标元统计-退税供货汇总';
comment on column JKGL_DATA_TJ_ZBU_TSGH.id
  is '序号';
comment on column JKGL_DATA_TJ_ZBU_TSGH.bgqid
  is '报告期ID';
comment on column JKGL_DATA_TJ_ZBU_TSGH.ghfsh
  is '供货企业税号';
comment on column JKGL_DATA_TJ_ZBU_TSGH.jhje
  is '进货金额';
comment on column JKGL_DATA_TJ_ZBU_TSGH.tse
  is '退税额';
comment on column JKGL_DATA_TJ_ZBU_TSGH.fxqybz
  is '风险企业标志  0/  1风险企业';
comment on column JKGL_DATA_TJ_ZBU_TSGH.fxdqbz
  is '风险地区标志   0正常  1风险地区';
comment on column JKGL_DATA_TJ_ZBU_TSGH.snwbz
  is '省内外标志    0省内   1 省外 ';
comment on column JKGL_DATA_TJ_ZBU_TSGH.fzchbz
  is '非正常户标志   0正常  1非正常（包括注销等）';
comment on column JKGL_DATA_TJ_ZBU_TSGH.newbz
  is '新增供应商标志';
create index IDX_JKGL_DATA_TJ_ZBU_TSGH on JKGL_DATA_TJ_ZBU_TSGH (BGQID, GHFSH);
alter table JKGL_DATA_TJ_ZBU_TSGH
  add constraint PK_JKGL_DATA_TJ_ZBU_TSGH primary key (ID);

prompt
prompt Creating table JKGL_DATA_TJ_ZBU_TSSP
prompt ====================================
prompt
create table JKGL_DATA_TJ_ZBU_TSSP
(
  id          NUMBER(20) not null,
  bgqid       NUMBER(20),
  sp8_dm      VARCHAR2(8),
  ckeusd      NUMBER(18,2),
  ckermb      NUMBER(18,2),
  ckermb_stzc NUMBER(18,2),
  cksl        NUMBER(18,2),
  ckdj        NUMBER(18,2),
  sbtmse      NUMBER(18,2),
  jhje        NUMBER(18,2),
  jhdj        NUMBER(18,2),
  mgbz        CHAR(1) default '0',
  sp_dl       VARCHAR2(2),
  mmylr       NUMBER(18,2)
)
;
comment on table JKGL_DATA_TJ_ZBU_TSSP
  is '报告期指标元统计-退税商品汇总';
comment on column JKGL_DATA_TJ_ZBU_TSSP.id
  is '序号';
comment on column JKGL_DATA_TJ_ZBU_TSSP.bgqid
  is '报告期ID';
comment on column JKGL_DATA_TJ_ZBU_TSSP.sp8_dm
  is '商品代码（8位）';
comment on column JKGL_DATA_TJ_ZBU_TSSP.ckeusd
  is '出口额USD';
comment on column JKGL_DATA_TJ_ZBU_TSSP.ckermb
  is '出口额人民币';
comment on column JKGL_DATA_TJ_ZBU_TSSP.ckermb_stzc
  is '出口额_视同自产';
comment on column JKGL_DATA_TJ_ZBU_TSSP.cksl
  is '出口数量';
comment on column JKGL_DATA_TJ_ZBU_TSSP.ckdj
  is '出口单价';
comment on column JKGL_DATA_TJ_ZBU_TSSP.sbtmse
  is '申报退免税额';
comment on column JKGL_DATA_TJ_ZBU_TSSP.jhje
  is '进货金额';
comment on column JKGL_DATA_TJ_ZBU_TSSP.jhdj
  is '进货单价';
comment on column JKGL_DATA_TJ_ZBU_TSSP.mgbz
  is '敏感标志 1/0';
comment on column JKGL_DATA_TJ_ZBU_TSSP.sp_dl
  is '商品大类(2位)';
comment on column JKGL_DATA_TJ_ZBU_TSSP.mmylr
  is '每美元利润';
create index IDX_JKGL_DATA_TJ_ZBU_TSSP on JKGL_DATA_TJ_ZBU_TSSP (BGQID, SP8_DM);
alter table JKGL_DATA_TJ_ZBU_TSSP
  add constraint PK_JKGL_DATA_TJ_ZBU_TSSP primary key (ID);

prompt
prompt Creating table JKGL_DATA_ZB_JGB
prompt ===============================
prompt
create table JKGL_DATA_ZB_JGB
(
  djxh      NUMBER(20) not null,
  zb_id     VARCHAR2(30) not null,
  zb_val    NUMBER(18,2),
  yc_result INTEGER,
  badpoint  CHAR(1),
  score     INTEGER not null,
  params    VARCHAR2(4000),
  js_status CHAR(1),
  ff_status CHAR(1),
  tqbz      VARCHAR2(20),
  tqsj      DATE,
  uptime    DATE,
  hcjg      CHAR(1),
  hctime    DATE,
  hcyj      VARCHAR2(4000),
  hcr       VARCHAR2(20)
)
;
comment on table JKGL_DATA_ZB_JGB
  is '指标数据结果表';
comment on column JKGL_DATA_ZB_JGB.djxh
  is '纳税人登记序号PK';
comment on column JKGL_DATA_ZB_JGB.zb_id
  is '指标标识 PK';
comment on column JKGL_DATA_ZB_JGB.zb_val
  is '指标计算结果（逻辑型1/0）';
comment on column JKGL_DATA_ZB_JGB.yc_result
  is '异常判定结果（存在异常规则xh,无异常=0）';
comment on column JKGL_DATA_ZB_JGB.badpoint
  is '坏点标志 Y /N';
comment on column JKGL_DATA_ZB_JGB.score
  is '健康赋分';
comment on column JKGL_DATA_ZB_JGB.params
  is '计算输入参数（json格式）';
comment on column JKGL_DATA_ZB_JGB.js_status
  is '计算状态（0待计算 1已计算）';
comment on column JKGL_DATA_ZB_JGB.ff_status
  is '赋分状态（0待赋分 1已赋分）';
comment on column JKGL_DATA_ZB_JGB.tqbz
  is '提取标志';
comment on column JKGL_DATA_ZB_JGB.tqsj
  is '提取时间';
comment on column JKGL_DATA_ZB_JGB.uptime
  is '更新时间';
comment on column JKGL_DATA_ZB_JGB.hcjg
  is '核查（评定）结果： 1 经核实正常（不扣分）   2经核实异常（继续扣分）';
comment on column JKGL_DATA_ZB_JGB.hctime
  is '核查（评定）时间';
comment on column JKGL_DATA_ZB_JGB.hcyj
  is '核查（评定）情况描述';
comment on column JKGL_DATA_ZB_JGB.hcr
  is '核查（评定）人姓名';
alter table JKGL_DATA_ZB_JGB
  add constraint PK_JKGL_DATA_ZB_JGB primary key (DJXH, ZB_ID);

prompt
prompt Creating table JKGL_DATA_ZB_LSB
prompt ===============================
prompt
create table JKGL_DATA_ZB_LSB
(
  id        NUMBER(20) not null,
  djxh      NUMBER(20),
  zb_id     VARCHAR2(30),
  zb_val    NUMBER(18,2),
  yc_result INTEGER,
  badpoint  CHAR(1),
  score     INTEGER not null,
  params    VARCHAR2(4000),
  js_status CHAR(1),
  ff_status CHAR(1),
  tqbz      VARCHAR2(20),
  tqsj      DATE,
  uptime    DATE
)
;
comment on table JKGL_DATA_ZB_LSB
  is '指标数据历史表';
comment on column JKGL_DATA_ZB_LSB.id
  is '由序列产生的id';
comment on column JKGL_DATA_ZB_LSB.djxh
  is '纳税人登记序号PK';
comment on column JKGL_DATA_ZB_LSB.zb_id
  is '指标标识 PK';
comment on column JKGL_DATA_ZB_LSB.zb_val
  is '指标计算结果（逻辑型1/0）';
comment on column JKGL_DATA_ZB_LSB.yc_result
  is '异常判定结果（存在异常规则xh,无异常=0）';
comment on column JKGL_DATA_ZB_LSB.badpoint
  is '坏点标志 Y /N';
comment on column JKGL_DATA_ZB_LSB.score
  is '健康赋分';
comment on column JKGL_DATA_ZB_LSB.params
  is '计算输入参数（json格式）';
comment on column JKGL_DATA_ZB_LSB.js_status
  is '计算状态（0待计算 1已计算）';
comment on column JKGL_DATA_ZB_LSB.ff_status
  is '赋分状态（0待赋分 1已赋分）';
comment on column JKGL_DATA_ZB_LSB.tqbz
  is '提取标志';
comment on column JKGL_DATA_ZB_LSB.tqsj
  is '提取时间';
comment on column JKGL_DATA_ZB_LSB.uptime
  is '更新时间';
alter table JKGL_DATA_ZB_LSB
  add constraint PK_JKGL_DATA_ZB_LSB primary key (ID);

prompt
prompt Creating table JKGL_DATA_ZB_PS_JGB
prompt ==================================
prompt
create table JKGL_DATA_ZB_PS_JGB
(
  zb_id     VARCHAR2(30) not null,
  pslx_dm   VARCHAR2(20) not null,
  ps_code   VARCHAR2(30),
  zb_val    NUMBER(18,2),
  js_status CHAR(1),
  tqbz      VARCHAR2(20),
  tqsj      DATE,
  uptime    DATE
)
;
comment on table JKGL_DATA_ZB_PS_JGB
  is '指标派生数据结果表';
comment on column JKGL_DATA_ZB_PS_JGB.zb_id
  is '指标标识 PK';
comment on column JKGL_DATA_ZB_PS_JGB.pslx_dm
  is '派生类型代码PK（关联代码表）';
comment on column JKGL_DATA_ZB_PS_JGB.ps_code
  is '派生主题代码PK（派生类型下的具体代码）';
comment on column JKGL_DATA_ZB_PS_JGB.zb_val
  is '指标计算结果（逻辑型1/0）';
comment on column JKGL_DATA_ZB_PS_JGB.js_status
  is '计算状态（0待计算 1已计算）';
comment on column JKGL_DATA_ZB_PS_JGB.tqbz
  is '提取标志';
comment on column JKGL_DATA_ZB_PS_JGB.tqsj
  is '提取时间';
comment on column JKGL_DATA_ZB_PS_JGB.uptime
  is '更新时间';
alter table JKGL_DATA_ZB_PS_JGB
  add constraint PK_JKGL_DATA_ZB_PS_JGB primary key (ZB_ID, PSLX_DM);

prompt
prompt Creating table JKGL_DATA_ZB_PS_LSB
prompt ==================================
prompt
create table JKGL_DATA_ZB_PS_LSB
(
  id        NUMBER(20) not null,
  zb_id     VARCHAR2(30),
  pslx_dm   VARCHAR2(20),
  ps_code   VARCHAR2(30),
  zb_val    NUMBER(18,2),
  js_status CHAR(1),
  tqbz      VARCHAR2(20),
  tqsj      DATE,
  uptime    DATE
)
;
comment on table JKGL_DATA_ZB_PS_LSB
  is '指标派生数据历史表';
comment on column JKGL_DATA_ZB_PS_LSB.id
  is '由序列产生的id';
comment on column JKGL_DATA_ZB_PS_LSB.zb_id
  is '指标标识 PK';
comment on column JKGL_DATA_ZB_PS_LSB.pslx_dm
  is '派生类型代码PK（关联代码表）';
comment on column JKGL_DATA_ZB_PS_LSB.ps_code
  is '派生主题代码PK（派生类型下的具体代码）';
comment on column JKGL_DATA_ZB_PS_LSB.zb_val
  is '指标计算结果（逻辑型1/0）';
comment on column JKGL_DATA_ZB_PS_LSB.js_status
  is '计算状态（0待计算 1已计算）';
comment on column JKGL_DATA_ZB_PS_LSB.tqbz
  is '提取标志';
comment on column JKGL_DATA_ZB_PS_LSB.tqsj
  is '提取时间';
comment on column JKGL_DATA_ZB_PS_LSB.uptime
  is '更新时间';
alter table JKGL_DATA_ZB_PS_LSB
  add constraint PK_JKGL_DATA_ZB_PS_LSB primary key (ID);

prompt
prompt Creating table JKGL_DM_FXCKSP
prompt =============================
prompt
create table JKGL_DM_FXCKSP
(
  dm VARCHAR2(20) not null,
  mc VARCHAR2(40)
)
;
alter table JKGL_DM_FXCKSP
  add primary key (DM);

prompt
prompt Creating table JKGL_DM_JKM
prompt ==========================
prompt
create table JKGL_DM_JKM
(
  jkm_level CHAR(1) not null,
  jkm_mc    VARCHAR2(10)
)
;
comment on table JKGL_DM_JKM
  is '健康码代码表';
comment on column JKGL_DM_JKM.jkm_level
  is '健康码等级';
comment on column JKGL_DM_JKM.jkm_mc
  is '健康码名称';
alter table JKGL_DM_JKM
  add constraint PK_JKGL_DM_JKM primary key (JKM_LEVEL);

prompt
prompt Creating table JKGL_DM_PSLX
prompt ===========================
prompt
create table JKGL_DM_PSLX
(
  pslx_dm   VARCHAR2(20) not null,
  pslx_mc   VARCHAR2(100),
  algorithm VARCHAR2(20),
  note      VARCHAR2(200)
)
;
comment on table JKGL_DM_PSLX
  is '派生类型代码表';
comment on column JKGL_DM_PSLX.pslx_dm
  is '派生类型代码（关联代码表）';
comment on column JKGL_DM_PSLX.pslx_mc
  is '派生类型名称';
comment on column JKGL_DM_PSLX.algorithm
  is '算法（平均值，标准值）';
comment on column JKGL_DM_PSLX.note
  is '说明';
alter table JKGL_DM_PSLX
  add constraint PK_JKGL_DM_PSLX primary key (PSLX_DM);

prompt
prompt Creating table JKGL_DM_YSLX
prompt ===========================
prompt
create table JKGL_DM_YSLX
(
  yslx_dm   VARCHAR2(20) not null,
  yslx_mc   VARCHAR2(50),
  tablename VARCHAR2(50),
  dm_field  VARCHAR2(50),
  mc_field  VARCHAR2(50)
)
;
comment on table JKGL_DM_YSLX
  is '约束类型代码表';
comment on column JKGL_DM_YSLX.yslx_dm
  is '约束类型代码';
comment on column JKGL_DM_YSLX.yslx_mc
  is '约束类型名称';
comment on column JKGL_DM_YSLX.tablename
  is '关联代码表名';
comment on column JKGL_DM_YSLX.dm_field
  is '代码字段名';
comment on column JKGL_DM_YSLX.mc_field
  is '代码中文名';
alter table JKGL_DM_YSLX
  add constraint PK_JKGL_DM_YSLX primary key (YSLX_DM);

prompt
prompt Creating table JKGL_DM_YWFL
prompt ===========================
prompt
create table JKGL_DM_YWFL
(
  ywfl_dm VARCHAR2(10) not null,
  ywfl_mc VARCHAR2(50),
  ywfl_jc VARCHAR2(50)
)
;
comment on table JKGL_DM_YWFL
  is '健康管理-业务分类代码表';
alter table JKGL_DM_YWFL
  add constraint PK_JKGL_DM_YWFL primary key (YWFL_DM);

prompt
prompt Creating table JKGL_FX_GXFA
prompt ===========================
prompt
create table JKGL_FX_GXFA
(
  id         NUMBER(20) not null,
  famc       VARCHAR2(80),
  tsjsfs_dm  CHAR(1),
  cr_user    VARCHAR2(80),
  cr_user_dm VARCHAR2(20),
  cr_time    DATE,
  note       VARCHAR2(4000),
  gxlx       CHAR(1),
  swjg_dm    VARCHAR2(11)
)
;
comment on table JKGL_FX_GXFA
  is '共享方案表';
comment on column JKGL_FX_GXFA.id
  is '方案主表ID';
comment on column JKGL_FX_GXFA.famc
  is '方案名称';
comment on column JKGL_FX_GXFA.tsjsfs_dm
  is '退税计算方式 1生产 2外贸';
comment on column JKGL_FX_GXFA.cr_user
  is '创建人名称';
comment on column JKGL_FX_GXFA.cr_user_dm
  is '创建人代码';
comment on column JKGL_FX_GXFA.cr_time
  is '创建时间';
comment on column JKGL_FX_GXFA.note
  is '备注说明';
comment on column JKGL_FX_GXFA.gxlx
  is '共享类型 0-私有  1-公有';
comment on column JKGL_FX_GXFA.swjg_dm
  is '录入税务机关代码';
alter table JKGL_FX_GXFA
  add constraint JKGL_FX_GXFA primary key (ID);

prompt
prompt Creating table JKGL_FX_GXFA_GXGX
prompt ================================
prompt
create table JKGL_FX_GXFA_GXGX
(
  id         NUMBER(20) not null,
  gid        NUMBER(20) not null,
  gxfw       VARCHAR2(11),
  dxlx       VARCHAR2(10),
  qybz       CHAR(1) not null,
  cr_user    VARCHAR2(80),
  cr_user_dm VARCHAR2(20),
  up_user    VARCHAR2(80),
  up_user_dm VARCHAR2(20),
  cr_time    DATE,
  up_time    DATE
)
;
comment on table JKGL_FX_GXFA_GXGX
  is '共享关系表';
comment on column JKGL_FX_GXFA_GXGX.id
  is '共享关系表主键';
comment on column JKGL_FX_GXFA_GXGX.gid
  is '方案主表ID';
comment on column JKGL_FX_GXFA_GXGX.gxfw
  is '共享税务机关范围 例如13301或1330105';
comment on column JKGL_FX_GXFA_GXGX.dxlx
  is '对象类型  SWJG-税务机关';
comment on column JKGL_FX_GXFA_GXGX.qybz
  is '启用标志 Y-启用/N-不启用';
comment on column JKGL_FX_GXFA_GXGX.cr_user
  is '创建人名称';
comment on column JKGL_FX_GXFA_GXGX.cr_user_dm
  is '创建人代码';
comment on column JKGL_FX_GXFA_GXGX.up_user
  is '修改人名称';
comment on column JKGL_FX_GXFA_GXGX.up_user_dm
  is '修改人代码';
comment on column JKGL_FX_GXFA_GXGX.cr_time
  is '创建时间';
comment on column JKGL_FX_GXFA_GXGX.up_time
  is '修改时间';
alter table JKGL_FX_GXFA_GXGX
  add constraint JKGL_FX_GXFA_GX_SWJG primary key (ID);

prompt
prompt Creating table JKGL_FX_GXFA_RULE
prompt ================================
prompt
create table JKGL_FX_GXFA_RULE
(
  gid              NUMBER(20) not null,
  id               NUMBER(20) not null,
  rulename         VARCHAR2(80) not null,
  expression       VARCHAR2(2000),
  note             VARCHAR2(1000),
  showorder        INTEGER,
  yxbz             CHAR(1) not null,
  expression_cname VARCHAR2(2000),
  fxq_type         CHAR(1),
  fxq_offset       NUMBER(2),
  fxq_range        NUMBER(2)
)
;
comment on table JKGL_FX_GXFA_RULE
  is '共享方案规则集合表';
comment on column JKGL_FX_GXFA_RULE.gid
  is '方案主表ID';
comment on column JKGL_FX_GXFA_RULE.id
  is '共享规则主键ID';
comment on column JKGL_FX_GXFA_RULE.rulename
  is '规则名称';
comment on column JKGL_FX_GXFA_RULE.expression
  is '表达式';
comment on column JKGL_FX_GXFA_RULE.note
  is '备注说明';
comment on column JKGL_FX_GXFA_RULE.showorder
  is '显示顺序';
comment on column JKGL_FX_GXFA_RULE.yxbz
  is '有效标志 Y/N';
comment on column JKGL_FX_GXFA_RULE.expression_cname
  is '中文表达式';
comment on column JKGL_FX_GXFA_RULE.fxq_type
  is '分析期偏移类型，0-月，1-季，2-年';
comment on column JKGL_FX_GXFA_RULE.fxq_offset
  is '分析期偏移量';
comment on column JKGL_FX_GXFA_RULE.fxq_range
  is '分析期月跨度';
alter table JKGL_FX_GXFA_RULE
  add constraint JKGL_FX_GXFA_GXGZ primary key (ID);

prompt
prompt Creating table JKGL_FX_GXFA_YSTJ
prompt ================================
prompt
create table JKGL_FX_GXFA_YSTJ
(
  gid        NUMBER(20) not null,
  flglcd     VARCHAR2(50),
  flglcd_str VARCHAR2(50),
  djzclx     VARCHAR2(300),
  djzclx_str VARCHAR2(2000),
  hy         VARCHAR2(1000),
  hy_str     VARCHAR2(2000),
  nsrzt      VARCHAR2(50),
  nsrzt_str  VARCHAR2(200),
  ckgm       VARCHAR2(50),
  ckgm_str   VARCHAR2(200)
)
;
comment on table JKGL_FX_GXFA_YSTJ
  is '共享方案约束条件表';
comment on column JKGL_FX_GXFA_YSTJ.gid
  is '方案主表ID';
comment on column JKGL_FX_GXFA_YSTJ.flglcd
  is '分类管理等级';
comment on column JKGL_FX_GXFA_YSTJ.djzclx
  is '登记类型';
comment on column JKGL_FX_GXFA_YSTJ.hy
  is '行业';
comment on column JKGL_FX_GXFA_YSTJ.nsrzt
  is '纳税人状态';
comment on column JKGL_FX_GXFA_YSTJ.ckgm
  is '出口规模';
alter table JKGL_FX_GXFA_YSTJ
  add constraint JKGL_FX_GXFA_YSTJ primary key (GID);

prompt
prompt Creating table JKGL_FX_YBQYTC_TMP
prompt =================================
prompt
create table JKGL_FX_YBQYTC_TMP
(
  zid    NUMBER(20) not null,
  xh     INTEGER not null,
  nsrsbh VARCHAR2(20),
  nsrmc  VARCHAR2(100)
)
;
comment on table JKGL_FX_YBQYTC_TMP
  is '三三智检分析模块-样本企业(剔除)临时表';
comment on column JKGL_FX_YBQYTC_TMP.zid
  is '项目主表ID';
comment on column JKGL_FX_YBQYTC_TMP.xh
  is '序号';
comment on column JKGL_FX_YBQYTC_TMP.nsrsbh
  is '纳税人识别号';
comment on column JKGL_FX_YBQYTC_TMP.nsrmc
  is '纳税人名称';
alter table JKGL_FX_YBQYTC_TMP
  add constraint PK_JKGL_FX_YBQYTC_TMP primary key (ZID, XH);

prompt
prompt Creating table JKGL_FX_YBQY_TMP
prompt ===============================
prompt
create table JKGL_FX_YBQY_TMP
(
  zid    NUMBER(20) not null,
  xh     INTEGER not null,
  nsrsbh VARCHAR2(20),
  nsrmc  VARCHAR2(100)
)
;
comment on table JKGL_FX_YBQY_TMP
  is '三三智检分析模块-样本企业临时表';
comment on column JKGL_FX_YBQY_TMP.zid
  is '项目主表ID';
comment on column JKGL_FX_YBQY_TMP.xh
  is '序号';
comment on column JKGL_FX_YBQY_TMP.nsrsbh
  is '纳税人识别号';
comment on column JKGL_FX_YBQY_TMP.nsrmc
  is '纳税人名称';
alter table JKGL_FX_YBQY_TMP
  add constraint PK_JKGL_FX_YBQY_TMP primary key (ZID, XH);

prompt
prompt Creating table JKGL_FX_ZHZBSX
prompt =============================
prompt
create table JKGL_FX_ZHZBSX
(
  id         NUMBER(20) not null,
  xmmc       VARCHAR2(80),
  tsjsfs_dm  CHAR(1),
  note       VARCHAR2(200),
  status     CHAR(1),
  cr_user    VARCHAR2(80),
  cr_time    DATE,
  swjg_dm    VARCHAR2(11),
  up_time    DATE,
  cr_user_dm VARCHAR2(20)
)
;
comment on table JKGL_FX_ZHZBSX
  is '综合指标筛选项目主表';
comment on column JKGL_FX_ZHZBSX.id
  is '项目主表ID';
comment on column JKGL_FX_ZHZBSX.xmmc
  is '项目名称';
comment on column JKGL_FX_ZHZBSX.tsjsfs_dm
  is '退税计算方式 1生产 2外贸';
comment on column JKGL_FX_ZHZBSX.note
  is '备注说明';
comment on column JKGL_FX_ZHZBSX.status
  is '项目状态  0项目新建  1初始化完成  2筛选中  3筛选结束';
comment on column JKGL_FX_ZHZBSX.cr_user
  is '创建人名称';
comment on column JKGL_FX_ZHZBSX.cr_time
  is '创建时间';
comment on column JKGL_FX_ZHZBSX.swjg_dm
  is '录入税务机关代码';
comment on column JKGL_FX_ZHZBSX.up_time
  is '修改时间';
comment on column JKGL_FX_ZHZBSX.cr_user_dm
  is '创建人代码';
alter table JKGL_FX_ZHZBSX
  add constraint PK_JKGL_FX_ZHZBSX primary key (ID);

prompt
prompt Creating table JKGL_FX_ZHZBSX_MBQY
prompt ==================================
prompt
create table JKGL_FX_ZHZBSX_MBQY
(
  zid  NUMBER(20) not null,
  djxh NUMBER(20) not null
)
;
comment on table JKGL_FX_ZHZBSX_MBQY
  is '综合指标筛选子表-目标企业';
comment on column JKGL_FX_ZHZBSX_MBQY.zid
  is '项目主表ID';
comment on column JKGL_FX_ZHZBSX_MBQY.djxh
  is '企业登记序号  关联glxt_bb_shxt_djxx的djxh_js字段';
alter table JKGL_FX_ZHZBSX_MBQY
  add constraint PK_JKGL_FX_ZHZBSX_MBQY primary key (ZID, DJXH);

prompt
prompt Creating table JKGL_FX_ZHZBSX_PC
prompt ================================
prompt
create table JKGL_FX_ZHZBSX_PC
(
  uuid       VARCHAR2(40) not null,
  zid        NUMBER(20) not null,
  pc         INTEGER not null,
  ztbz       CHAR(1) not null,
  start_time DATE,
  end_time   DATE,
  rely_pc    INTEGER,
  msg        VARCHAR2(4000),
  ssq        DATE not null
)
;
comment on table JKGL_FX_ZHZBSX_PC
  is '综合指标筛选子表—批次（执行版本）';
comment on column JKGL_FX_ZHZBSX_PC.uuid
  is '主键';
comment on column JKGL_FX_ZHZBSX_PC.zid
  is '项目主表ID';
comment on column JKGL_FX_ZHZBSX_PC.pc
  is '筛选批次';
comment on column JKGL_FX_ZHZBSX_PC.ztbz
  is '执行状态   0创建  1筛选中  2筛选结束 9异常中断';
comment on column JKGL_FX_ZHZBSX_PC.start_time
  is '开始时间';
comment on column JKGL_FX_ZHZBSX_PC.end_time
  is '结束时间';
comment on column JKGL_FX_ZHZBSX_PC.rely_pc
  is '依赖批次  >0表示以依赖批次的结果为初始目标企业';
comment on column JKGL_FX_ZHZBSX_PC.msg
  is '执行过程输出的消息';
comment on column JKGL_FX_ZHZBSX_PC.ssq
  is '所属期';
create index IDX_JKGL_FX_ZHZBSX_PC on JKGL_FX_ZHZBSX_PC (ZID, PC);
alter table JKGL_FX_ZHZBSX_PC
  add constraint PK_JKGL_FX_ZHZBSX_PC primary key (UUID);

prompt
prompt Creating table JKGL_FX_ZHZBSX_PC_JGQY
prompt =====================================
prompt
create table JKGL_FX_ZHZBSX_PC_JGQY
(
  pc_uuid VARCHAR2(40) not null,
  djxh    NUMBER(20) not null,
  rule_id NUMBER(20)
)
;
comment on table JKGL_FX_ZHZBSX_PC_JGQY
  is '综合指标筛选子表—批次的结果企业';
comment on column JKGL_FX_ZHZBSX_PC_JGQY.pc_uuid
  is '关联到批次的UUID';
comment on column JKGL_FX_ZHZBSX_PC_JGQY.djxh
  is '企业登记序号';
comment on column JKGL_FX_ZHZBSX_PC_JGQY.rule_id
  is '规则表的ID';

prompt
prompt Creating table JKGL_FX_ZHZBSX_PC_RULE
prompt =====================================
prompt
create table JKGL_FX_ZHZBSX_PC_RULE
(
  pc_uuid          VARCHAR2(40) not null,
  rule_id          NUMBER(20) not null,
  zid              NUMBER(20) not null,
  expression       VARCHAR2(2000),
  expression_cname VARCHAR2(2000),
  task_flag        CHAR(1) default 0,
  tqbz             VARCHAR2(64),
  tqsj             DATE,
  tqcs             NUMBER(20) default 0,
  crtime           DATE,
  task_info        VARCHAR2(2000),
  fxq_q            DATE,
  fxq_z            DATE,
  status           VARCHAR2(100)
)
;
comment on table JKGL_FX_ZHZBSX_PC_RULE
  is '综合指标筛选子表—批次的使用规则';
comment on column JKGL_FX_ZHZBSX_PC_RULE.pc_uuid
  is '关联到批次的UUID';
comment on column JKGL_FX_ZHZBSX_PC_RULE.rule_id
  is '规则表的ID';
comment on column JKGL_FX_ZHZBSX_PC_RULE.zid
  is '项目主表ID（冗余，便于清理）';
comment on column JKGL_FX_ZHZBSX_PC_RULE.expression
  is '表达式（从规则表复制过来）';
comment on column JKGL_FX_ZHZBSX_PC_RULE.expression_cname
  is '中文表达式';
comment on column JKGL_FX_ZHZBSX_PC_RULE.task_flag
  is '规则解析状态  0-未完成 1-提取中 2-执行完成  9-出错';
comment on column JKGL_FX_ZHZBSX_PC_RULE.tqbz
  is '任务提取标志';
comment on column JKGL_FX_ZHZBSX_PC_RULE.tqsj
  is '提取时间';
comment on column JKGL_FX_ZHZBSX_PC_RULE.tqcs
  is '提取次数';
comment on column JKGL_FX_ZHZBSX_PC_RULE.crtime
  is '创建时间';
comment on column JKGL_FX_ZHZBSX_PC_RULE.task_info
  is '任务信息';
comment on column JKGL_FX_ZHZBSX_PC_RULE.fxq_q
  is '分析期起';
comment on column JKGL_FX_ZHZBSX_PC_RULE.fxq_z
  is '分析期止';
comment on column JKGL_FX_ZHZBSX_PC_RULE.status
  is '执行状态';
alter table JKGL_FX_ZHZBSX_PC_RULE
  add constraint PK_JKGL_FX_ZHZBSX_PC_RULE primary key (PC_UUID, RULE_ID);

prompt
prompt Creating table JKGL_FX_ZHZBSX_RULE
prompt ==================================
prompt
create table JKGL_FX_ZHZBSX_RULE
(
  id               NUMBER(20) not null,
  zid              NUMBER(20) not null,
  rulename         VARCHAR2(80) not null,
  expression       VARCHAR2(2000),
  note             VARCHAR2(1000),
  showorder        INTEGER,
  yxbz             CHAR(1) not null,
  cr_time          DATE,
  up_time          DATE,
  expression_cname VARCHAR2(2000),
  fxq_type         CHAR(1),
  fxq_offset       NUMBER(2),
  fxq_range        NUMBER(2)
)
;
comment on table JKGL_FX_ZHZBSX_RULE
  is '综合指标筛选子表-规则集合';
comment on column JKGL_FX_ZHZBSX_RULE.id
  is 'ID主键';
comment on column JKGL_FX_ZHZBSX_RULE.zid
  is '项目主表ID';
comment on column JKGL_FX_ZHZBSX_RULE.rulename
  is '规则名称';
comment on column JKGL_FX_ZHZBSX_RULE.expression
  is '表达式';
comment on column JKGL_FX_ZHZBSX_RULE.note
  is '备注说明';
comment on column JKGL_FX_ZHZBSX_RULE.showorder
  is '显示顺序';
comment on column JKGL_FX_ZHZBSX_RULE.yxbz
  is '有效标志 Y/N';
comment on column JKGL_FX_ZHZBSX_RULE.cr_time
  is '创建时间';
comment on column JKGL_FX_ZHZBSX_RULE.up_time
  is '修改时间';
comment on column JKGL_FX_ZHZBSX_RULE.expression_cname
  is '中文表达式';
comment on column JKGL_FX_ZHZBSX_RULE.fxq_type
  is '分析期偏移类型，0-月，1-季，2-年';
comment on column JKGL_FX_ZHZBSX_RULE.fxq_offset
  is '分析期偏移量';
comment on column JKGL_FX_ZHZBSX_RULE.fxq_range
  is '分析期月跨度';
create index IDX_JKGL_FX_ZHZBSX_RULE on JKGL_FX_ZHZBSX_RULE (ZID);
alter table JKGL_FX_ZHZBSX_RULE
  add constraint PK_JKGL_FX_ZHZBSX_RULE primary key (ID);

prompt
prompt Creating table JKGL_FX_ZHZBSX_YSTJ
prompt ==================================
prompt
create table JKGL_FX_ZHZBSX_YSTJ
(
  zid        NUMBER(20) not null,
  swjg       VARCHAR2(200),
  swjg_str   VARCHAR2(1000),
  flglcd     VARCHAR2(50),
  flglcd_str VARCHAR2(50),
  djzclx     VARCHAR2(300),
  djzclx_str VARCHAR2(2000),
  hy         VARCHAR2(1000),
  hy_str     VARCHAR2(2000),
  nsrzt      VARCHAR2(50),
  nsrzt_str  VARCHAR2(200),
  ckgm       VARCHAR2(50),
  ckgm_str   VARCHAR2(200)
)
;
comment on table JKGL_FX_ZHZBSX_YSTJ
  is '综合指标筛选项目子表—（目标企业）约束条件';
comment on column JKGL_FX_ZHZBSX_YSTJ.zid
  is '项目主表ID';
comment on column JKGL_FX_ZHZBSX_YSTJ.swjg
  is '税务机关约束，以逗号分割， 参见代码表JKGL_DM_YSLX';
comment on column JKGL_FX_ZHZBSX_YSTJ.swjg_str
  is '约束中文内容，以逗号分割';
comment on column JKGL_FX_ZHZBSX_YSTJ.flglcd
  is '分类管理等级';
comment on column JKGL_FX_ZHZBSX_YSTJ.djzclx
  is '登记类型';
comment on column JKGL_FX_ZHZBSX_YSTJ.hy
  is '行业';
comment on column JKGL_FX_ZHZBSX_YSTJ.nsrzt
  is '纳税人状态';
comment on column JKGL_FX_ZHZBSX_YSTJ.ckgm
  is '出口规模';
alter table JKGL_FX_ZHZBSX_YSTJ
  add constraint PK_JKGL_FX_ZHZBSX_YSTJ primary key (ZID);

prompt
prompt Creating table JKGL_GY_FXDQ_SWJG
prompt ================================
prompt
create table JKGL_GY_FXDQ_SWJG
(
  id        NUMBER(20) not null,
  swjg_dm   VARCHAR2(11),
  swjg_syfw VARCHAR2(11),
  xzqh_dm   VARCHAR2(6),
  xzqh_mc   VARCHAR2(80),
  yxq_q     DATE,
  yxq_z     DATE,
  fxms      VARCHAR2(500),
  qybz      CHAR(1),
  cr_czrymc VARCHAR2(30),
  cr_time   DATE,
  up_czrymc VARCHAR2(30),
  up_time   DATE
)
;
comment on table JKGL_GY_FXDQ_SWJG
  is '税务机关风险地区自定义表';
comment on column JKGL_GY_FXDQ_SWJG.id
  is '序号（主键）';
comment on column JKGL_GY_FXDQ_SWJG.swjg_dm
  is '录入税务机关代码';
comment on column JKGL_GY_FXDQ_SWJG.swjg_syfw
  is '适用税务机关范围 例如13301或1330105';
comment on column JKGL_GY_FXDQ_SWJG.xzqh_dm
  is '行政区划代码';
comment on column JKGL_GY_FXDQ_SWJG.xzqh_mc
  is '行政区划名称';
comment on column JKGL_GY_FXDQ_SWJG.yxq_q
  is '有效期起，可空';
comment on column JKGL_GY_FXDQ_SWJG.yxq_z
  is '有效期止，可空';
comment on column JKGL_GY_FXDQ_SWJG.fxms
  is '风险描述';
comment on column JKGL_GY_FXDQ_SWJG.qybz
  is '启用标志(Y/N)';
comment on column JKGL_GY_FXDQ_SWJG.cr_czrymc
  is '录入人姓名';
comment on column JKGL_GY_FXDQ_SWJG.cr_time
  is '录入时间';
comment on column JKGL_GY_FXDQ_SWJG.up_czrymc
  is '修改人姓名';
comment on column JKGL_GY_FXDQ_SWJG.up_time
  is '修改时间';
create index IDX_JKGL_GY_FXDQ_SWJG on JKGL_GY_FXDQ_SWJG (SWJG_DM, XZQH_DM);
create index IDX_JKGL_GY_FXDQ_SWJG2 on JKGL_GY_FXDQ_SWJG (XZQH_DM, SWJG_SYFW);
alter table JKGL_GY_FXDQ_SWJG
  add constraint PK_JKGL_GY_FXDQ_SWJG primary key (ID);

prompt
prompt Creating table JKGL_GY_FXQY_SWJG
prompt ================================
prompt
create table JKGL_GY_FXQY_SWJG
(
  id        NUMBER(20) not null,
  swjg_dm   VARCHAR2(11),
  swjg_syfw VARCHAR2(11),
  qysbh     VARCHAR2(20),
  qymc      VARCHAR2(80),
  yxq_q     DATE,
  yxq_z     DATE,
  fxms      VARCHAR2(500),
  qybz      CHAR(1),
  cr_czrymc VARCHAR2(30),
  cr_time   DATE,
  up_czrymc VARCHAR2(30),
  up_time   DATE
)
;
comment on table JKGL_GY_FXQY_SWJG
  is '税务机关风险企业自定义表';
comment on column JKGL_GY_FXQY_SWJG.id
  is '序号（主键）';
comment on column JKGL_GY_FXQY_SWJG.swjg_dm
  is '录入税务机关代码';
comment on column JKGL_GY_FXQY_SWJG.swjg_syfw
  is '适用税务机关范围 例如13301或1330105';
comment on column JKGL_GY_FXQY_SWJG.qysbh
  is '企业税号';
comment on column JKGL_GY_FXQY_SWJG.qymc
  is '企业名称';
comment on column JKGL_GY_FXQY_SWJG.yxq_q
  is '有效期起，可空';
comment on column JKGL_GY_FXQY_SWJG.yxq_z
  is '有效期止，可空';
comment on column JKGL_GY_FXQY_SWJG.fxms
  is '风险描述';
comment on column JKGL_GY_FXQY_SWJG.qybz
  is '启用标志(Y/N)';
comment on column JKGL_GY_FXQY_SWJG.cr_czrymc
  is '录入人姓名';
comment on column JKGL_GY_FXQY_SWJG.cr_time
  is '录入时间';
comment on column JKGL_GY_FXQY_SWJG.up_czrymc
  is '修改人姓名';
comment on column JKGL_GY_FXQY_SWJG.up_time
  is '修改时间';
create index IDX_JKGL_GY_FXQY_SWJG on JKGL_GY_FXQY_SWJG (SWJG_DM, QYSBH);
create index IDX_JKGL_GY_FXQY_SWJG2 on JKGL_GY_FXQY_SWJG (QYSBH, SWJG_SYFW);
alter table JKGL_GY_FXQY_SWJG
  add constraint PK_JKGL_GY_FXQY_SWJG primary key (ID);

prompt
prompt Creating table JKGL_GY_FXSM_HGCK
prompt ================================
prompt
create table JKGL_GY_FXSM_HGCK
(
  djxh   NUMBER(20) not null,
  ckbgdh VARCHAR2(21) not null,
  smrq   DATE,
  fxgz   VARCHAR2(200),
  tgbz   CHAR(1)
)
;
comment on table JKGL_GY_FXSM_HGCK
  is '公用-风险扫描-海关出口信息';
comment on column JKGL_GY_FXSM_HGCK.djxh
  is '登记序号';
comment on column JKGL_GY_FXSM_HGCK.ckbgdh
  is '出口报关单号';
comment on column JKGL_GY_FXSM_HGCK.smrq
  is '扫描日期';
comment on column JKGL_GY_FXSM_HGCK.fxgz
  is '（命中）风险规则';
comment on column JKGL_GY_FXSM_HGCK.tgbz
  is '挑过标志  1已挑过';
alter table JKGL_GY_FXSM_HGCK
  add constraint PK_JKGL_GY_FXSM_HGCK primary key (DJXH, CKBGDH);

prompt
prompt Creating table JKGL_GY_FXSM_TSSBGH
prompt ==================================
prompt
create table JKGL_GY_FXSM_TSSBGH
(
  djxh NUMBER(20) not null,
  uuid VARCHAR2(32) not null,
  smrq DATE,
  fxgz VARCHAR2(200),
  tgbz CHAR(1)
)
;
comment on table JKGL_GY_FXSM_TSSBGH
  is '公用-风险扫描-退税申报供货';
comment on column JKGL_GY_FXSM_TSSBGH.djxh
  is '登记序号';
comment on column JKGL_GY_FXSM_TSSBGH.smrq
  is '扫描日期';
comment on column JKGL_GY_FXSM_TSSBGH.fxgz
  is '（命中）风险规则';
comment on column JKGL_GY_FXSM_TSSBGH.tgbz
  is '挑过标志  1已挑过';
alter table JKGL_GY_FXSM_TSSBGH
  add constraint PK_JKGL_GY_FXSM_TSSBGH primary key (UUID);

prompt
prompt Creating table JKGL_GY_GHQYXX
prompt =============================
prompt
create table JKGL_GY_GHQYXX
(
  qysbh    VARCHAR2(20) not null,
  qymc     VARCHAR2(80),
  swjg_dm  VARCHAR2(11),
  xzqh_dm  VARCHAR2(6),
  nsrzt_dm VARCHAR2(2),
  is_gjs   CHAR(1),
  cr_time  DATE,
  up_time  DATE,
  swdjrq   DATE,
  bz_lxkp  CHAR(1),
  zzkprq   DATE,
  bz_yd    CHAR(1)
)
;
comment on table JKGL_GY_GHQYXX
  is '供货企业信息表（全省公用）';
comment on column JKGL_GY_GHQYXX.qysbh
  is '企业税号';
comment on column JKGL_GY_GHQYXX.qymc
  is '企业名称';
comment on column JKGL_GY_GHQYXX.swjg_dm
  is '税务机关代码';
comment on column JKGL_GY_GHQYXX.xzqh_dm
  is '行政区划代码';
comment on column JKGL_GY_GHQYXX.nsrzt_dm
  is '纳税人状态代码 03正常 ';
comment on column JKGL_GY_GHQYXX.is_gjs
  is '是否涉及贵金属销售Y/N';
comment on column JKGL_GY_GHQYXX.cr_time
  is '录入时间';
comment on column JKGL_GY_GHQYXX.up_time
  is '修改时间';
comment on column JKGL_GY_GHQYXX.swdjrq
  is '税务登记日期';
comment on column JKGL_GY_GHQYXX.bz_lxkp
  is '预留给分析用，连续开票金额预警标志';
comment on column JKGL_GY_GHQYXX.zzkprq
  is '最早开票日期';
comment on column JKGL_GY_GHQYXX.bz_yd
  is '异地标志,N 省内 ， Y 省外';
alter table JKGL_GY_GHQYXX
  add constraint PK_PK_JKGL_GY_GHQYXX primary key (QYSBH);

prompt
prompt Creating table JKGL_GY_MGSP_SWJG
prompt ================================
prompt
create table JKGL_GY_MGSP_SWJG
(
  id        NUMBER(20) not null,
  swjg_dm   VARCHAR2(11),
  swjg_syfw VARCHAR2(11),
  mgsp_dm   VARCHAR2(8),
  mgsp_mc   VARCHAR2(200),
  yxq_q     DATE,
  yxq_z     DATE,
  fxms      VARCHAR2(500),
  qybz      CHAR(1),
  cr_czrymc VARCHAR2(30),
  cr_time   DATE,
  up_czrymc VARCHAR2(30),
  up_time   DATE
)
;
comment on table JKGL_GY_MGSP_SWJG
  is '税务机关敏感商品自定义表';
comment on column JKGL_GY_MGSP_SWJG.id
  is '序号（主键）';
comment on column JKGL_GY_MGSP_SWJG.swjg_dm
  is '录入税务机关代码';
comment on column JKGL_GY_MGSP_SWJG.swjg_syfw
  is '适用税务机关范围 例如13301或1330105';
comment on column JKGL_GY_MGSP_SWJG.mgsp_dm
  is '敏感商品代码，4-8位代码';
comment on column JKGL_GY_MGSP_SWJG.mgsp_mc
  is '敏感商品名称';
comment on column JKGL_GY_MGSP_SWJG.yxq_q
  is '有效期起，可空';
comment on column JKGL_GY_MGSP_SWJG.yxq_z
  is '有效期止，可空';
comment on column JKGL_GY_MGSP_SWJG.fxms
  is '风险描述';
comment on column JKGL_GY_MGSP_SWJG.qybz
  is '启用标志(Y/N)';
comment on column JKGL_GY_MGSP_SWJG.cr_czrymc
  is '录入人姓名';
comment on column JKGL_GY_MGSP_SWJG.cr_time
  is '录入时间';
comment on column JKGL_GY_MGSP_SWJG.up_czrymc
  is '修改人姓名';
comment on column JKGL_GY_MGSP_SWJG.up_time
  is '修改时间';
create index IDX_JKGL_GY_MGSP_SWJG on JKGL_GY_MGSP_SWJG (SWJG_DM, MGSP_DM);
create index IDX_JKGL_GY_MGSP_SWJG2 on JKGL_GY_MGSP_SWJG (MGSP_DM, SWJG_SYFW);
alter table JKGL_GY_MGSP_SWJG
  add constraint PK_JKGL_GY_MGSP_SWJG primary key (ID);

prompt
prompt Creating table JKGL_JKM_RGPD_LSB
prompt ================================
prompt
create table JKGL_JKM_RGPD_LSB
(
  pd_uuid VARCHAR2(40) not null,
  djxh    NUMBER(20) not null,
  qdsj    DATE not null,
  jkm_y   CHAR(1) not null,
  jkm_n   CHAR(1),
  yxq     DATE,
  pdzt    CHAR(1) not null,
  pdjg    CHAR(1),
  pdr_dm  VARCHAR2(20),
  pdr_mc  VARCHAR2(30),
  pdsj    DATE,
  pdyj    VARCHAR2(1000),
  fhr_dm  VARCHAR2(20),
  fhr_mc  VARCHAR2(30),
  fhsj    DATE,
  fhyj    VARCHAR2(100),
  swjg_dm VARCHAR2(11) not null,
  fqlx    CHAR(1) not null,
  ssyy    VARCHAR2(1000),
  ssbs    VARCHAR2(40),
  sjtbbz  CHAR(1)
)
;
comment on table JKGL_JKM_RGPD_LSB
  is '健康管理_健康码_人工评定_历史表';
comment on column JKGL_JKM_RGPD_LSB.pd_uuid
  is '评定UUID';
comment on column JKGL_JKM_RGPD_LSB.djxh
  is '登记序号';
comment on column JKGL_JKM_RGPD_LSB.qdsj
  is '评定启动时间';
comment on column JKGL_JKM_RGPD_LSB.jkm_y
  is '原健康码';
comment on column JKGL_JKM_RGPD_LSB.jkm_n
  is '新健康码';
comment on column JKGL_JKM_RGPD_LSB.yxq
  is '评定有效期，为空表示长期有效';
comment on column JKGL_JKM_RGPD_LSB.pdzt
  is '评定状态：0待评定、1重新评定（退回）、2待复核、9评定完成';
comment on column JKGL_JKM_RGPD_LSB.pdjg
  is '评定结果：1-同意、2-拒绝';
comment on column JKGL_JKM_RGPD_LSB.pdr_dm
  is '评定人代码';
comment on column JKGL_JKM_RGPD_LSB.pdr_mc
  is '评定人姓名';
comment on column JKGL_JKM_RGPD_LSB.pdsj
  is '评定时间';
comment on column JKGL_JKM_RGPD_LSB.pdyj
  is '评定意见';
comment on column JKGL_JKM_RGPD_LSB.fhr_dm
  is '复核人代码';
comment on column JKGL_JKM_RGPD_LSB.fhr_mc
  is '复核人姓名';
comment on column JKGL_JKM_RGPD_LSB.fhsj
  is '复核时间';
comment on column JKGL_JKM_RGPD_LSB.fhyj
  is '复核意见';
comment on column JKGL_JKM_RGPD_LSB.swjg_dm
  is '出口企业所属税务机关代码';
comment on column JKGL_JKM_RGPD_LSB.fqlx
  is '发起类型：1-税务评定、2-企业申述';
comment on column JKGL_JKM_RGPD_LSB.ssyy
  is '申述原因';
comment on column JKGL_JKM_RGPD_LSB.ssbs
  is '申述标识';
comment on column JKGL_JKM_RGPD_LSB.sjtbbz
  is '数据同步标志';
alter table JKGL_JKM_RGPD_LSB
  add constraint JKGL_JKM_RGPD_LSB primary key (PD_UUID);

prompt
prompt Creating table JKGL_JKM_RGPD_SP
prompt ===============================
prompt
create table JKGL_JKM_RGPD_SP
(
  pd_uuid VARCHAR2(40) not null,
  djxh    NUMBER(20) not null,
  qdsj    DATE not null,
  jkm_y   CHAR(1) not null,
  jkm_n   CHAR(1),
  yxq     DATE,
  pdzt    CHAR(1) not null,
  pdjg    CHAR(1),
  pdr_dm  VARCHAR2(20),
  pdr_mc  VARCHAR2(30),
  pdsj    DATE,
  pdyj    VARCHAR2(1000),
  fhr_dm  VARCHAR2(20),
  fhr_mc  VARCHAR2(30),
  fhsj    DATE,
  fhyj    VARCHAR2(100),
  swjg_dm VARCHAR2(11) not null,
  fqlx    CHAR(1) not null,
  ssyy    VARCHAR2(1000),
  ssbs    VARCHAR2(40),
  sjtbbz  CHAR(1)
)
;
comment on table JKGL_JKM_RGPD_SP
  is '健康管理_健康码_人工评定_审批表';
comment on column JKGL_JKM_RGPD_SP.pd_uuid
  is '评定UUID';
comment on column JKGL_JKM_RGPD_SP.djxh
  is '登记序号';
comment on column JKGL_JKM_RGPD_SP.qdsj
  is '评定启动时间';
comment on column JKGL_JKM_RGPD_SP.jkm_y
  is '原健康码';
comment on column JKGL_JKM_RGPD_SP.jkm_n
  is '新健康码';
comment on column JKGL_JKM_RGPD_SP.yxq
  is '评定有效期，为空表示长期有效';
comment on column JKGL_JKM_RGPD_SP.pdzt
  is '评定状态：0待评定、1重新评定（退回）、2待复核、9评定完成';
comment on column JKGL_JKM_RGPD_SP.pdjg
  is '评定结果：1-同意、2-拒绝';
comment on column JKGL_JKM_RGPD_SP.pdr_dm
  is '评定人代码';
comment on column JKGL_JKM_RGPD_SP.pdr_mc
  is '评定人姓名';
comment on column JKGL_JKM_RGPD_SP.pdsj
  is '评定时间';
comment on column JKGL_JKM_RGPD_SP.pdyj
  is '评定意见';
comment on column JKGL_JKM_RGPD_SP.fhr_dm
  is '复核人代码';
comment on column JKGL_JKM_RGPD_SP.fhr_mc
  is '复核人姓名';
comment on column JKGL_JKM_RGPD_SP.fhsj
  is '复核时间';
comment on column JKGL_JKM_RGPD_SP.fhyj
  is '复核意见';
comment on column JKGL_JKM_RGPD_SP.swjg_dm
  is '出口企业所属税务机关代码';
comment on column JKGL_JKM_RGPD_SP.fqlx
  is '发起类型：1-税务评定、2-企业申述';
comment on column JKGL_JKM_RGPD_SP.ssyy
  is '申述原因';
comment on column JKGL_JKM_RGPD_SP.ssbs
  is '申述标识';
comment on column JKGL_JKM_RGPD_SP.sjtbbz
  is '数据同步标志';
alter table JKGL_JKM_RGPD_SP
  add constraint JKGL_JKM_RGPD_SP primary key (PD_UUID);

prompt
prompt Creating table JKGL_LOG_DEALDATA
prompt ================================
prompt
create table JKGL_LOG_DEALDATA
(
  czsj DATE default SYSDATE,
  czjl VARCHAR2(300),
  sbyy VARCHAR2(2000)
)
;

prompt
prompt Creating table JKGL_PZ_DS
prompt =========================
prompt
create table JKGL_PZ_DS
(
  ds_id     VARCHAR2(30) not null,
  ds_name   VARCHAR2(30),
  ds_type   VARCHAR2(20),
  yxbz      CHAR(1),
  showorder INTEGER
)
;
comment on table JKGL_PZ_DS
  is '健康管理-配置-数据源';
comment on column JKGL_PZ_DS.ds_id
  is '数据源标识 ';
comment on column JKGL_PZ_DS.ds_name
  is '数据源名称 ';
comment on column JKGL_PZ_DS.ds_type
  is '数据源类型 oracle/mysql';
comment on column JKGL_PZ_DS.yxbz
  is '有效标志 Y/N';
comment on column JKGL_PZ_DS.showorder
  is '显示顺序';
alter table JKGL_PZ_DS
  add constraint PK_JKGL_PZ_DS primary key (DS_ID);

prompt
prompt Creating table JKGL_PZ_JKM
prompt ==========================
prompt
create table JKGL_PZ_JKM
(
  ywfl_dm     CHAR(2) not null,
  ywfl_mc     VARCHAR2(20),
  zb_total    INTEGER,
  jkm_total   INTEGER,
  line_red    INTEGER,
  line_yellow INTEGER,
  ywfl_jc     VARCHAR2(20),
  tsjsfs      CHAR(1) not null
)
;
comment on table JKGL_PZ_JKM
  is '健康码(分数线)配置';
comment on column JKGL_PZ_JKM.ywfl_dm
  is '业务分类代码（PK）';
comment on column JKGL_PZ_JKM.ywfl_mc
  is '业务分类名称';
comment on column JKGL_PZ_JKM.zb_total
  is '指标总分';
comment on column JKGL_PZ_JKM.jkm_total
  is '健康码（折算）总分';
comment on column JKGL_PZ_JKM.line_red
  is '红线分数';
comment on column JKGL_PZ_JKM.line_yellow
  is '黄线分数';
comment on column JKGL_PZ_JKM.ywfl_jc
  is '业务分类简称';
comment on column JKGL_PZ_JKM.tsjsfs
  is '退税计算方式 1-生产，2-外贸';
alter table JKGL_PZ_JKM
  add constraint PK_JKGL_PZ_JKM primary key (YWFL_DM, TSJSFS);

prompt
prompt Creating table JKGL_PZ_JKM_SWJG
prompt ===============================
prompt
create table JKGL_PZ_JKM_SWJG
(
  swjg_dm     VARCHAR2(11) not null,
  ywfl_dm     CHAR(2) not null,
  tsjsfs      CHAR(1) not null,
  jkm_total   INTEGER,
  line_red    INTEGER,
  line_yellow INTEGER
)
;
alter table JKGL_PZ_JKM_SWJG
  add primary key (SWJG_DM, YWFL_DM, TSJSFS);

prompt
prompt Creating table JKGL_PZ_METADATA
prompt ===============================
prompt
create table JKGL_PZ_METADATA
(
  ds_id      VARCHAR2(30) not null,
  tablename  VARCHAR2(40) not null,
  fieldname  VARCHAR2(30) not null,
  fieldcname VARCHAR2(50),
  datatype   CHAR(1),
  showformat CHAR(1),
  showlength INTEGER,
  codetable  VARCHAR2(40),
  codefield  VARCHAR2(30),
  defval     VARCHAR2(50),
  yxbz       CHAR(1),
  showorder  INTEGER,
  md_id      VARCHAR2(30),
  ywms       VARCHAR2(100)
)
;
comment on table JKGL_PZ_METADATA
  is '健康管理-配置-数据项（元数据）';
comment on column JKGL_PZ_METADATA.ds_id
  is '数据源标识 引用数据表配置';
comment on column JKGL_PZ_METADATA.tablename
  is '数据表 引用数据表配置';
comment on column JKGL_PZ_METADATA.fieldname
  is '字段名 ';
comment on column JKGL_PZ_METADATA.fieldcname
  is '数据项名称 ';
comment on column JKGL_PZ_METADATA.datatype
  is '数据类型 1字符型/2数值型/3日期型/4逻辑型';
comment on column JKGL_PZ_METADATA.showformat
  is '显示格式 0默认/1金额/2整数/3百分比';
comment on column JKGL_PZ_METADATA.showlength
  is '显示长度 1~100';
comment on column JKGL_PZ_METADATA.codetable
  is '关联代码表 ';
comment on column JKGL_PZ_METADATA.codefield
  is '关联代码字段 ';
comment on column JKGL_PZ_METADATA.defval
  is '缺省值 ';
comment on column JKGL_PZ_METADATA.yxbz
  is '有效标志 Y/N';
comment on column JKGL_PZ_METADATA.showorder
  is '显示顺序';
comment on column JKGL_PZ_METADATA.md_id
  is '元数据标识';
comment on column JKGL_PZ_METADATA.ywms
  is '业务描述';
create unique index IDX_JKGL_PZ_METADATA on JKGL_PZ_METADATA (MD_ID);
alter table JKGL_PZ_METADATA
  add constraint PK_JKGL_PZ_METADATA primary key (DS_ID, TABLENAME, FIELDNAME);

prompt
prompt Creating table JKGL_PZ_QUERY_DF
prompt ===============================
prompt
create table JKGL_PZ_QUERY_DF
(
  dts_id      VARCHAR2(20) not null,
  df_id       VARCHAR2(30) not null,
  df_name     VARCHAR2(50) not null,
  fieldname   VARCHAR2(30) not null,
  datatype    CHAR(1) not null,
  showformat  VARCHAR2(20),
  showlength  NUMBER(10),
  showorder   NUMBER(10),
  yxbz        CHAR(1) not null,
  allow_order CHAR(1) not null,
  allow_sum   CHAR(1) not null,
  is_cond     CHAR(1) not null,
  is_output   CHAR(1) not null,
  dm_table    VARCHAR2(30),
  dm_field    VARCHAR2(30),
  dm_name     VARCHAR2(30),
  dm_show     CHAR(1),
  align       CHAR(1)
)
;
comment on table JKGL_PZ_QUERY_DF
  is '通用查询数据项配置';
comment on column JKGL_PZ_QUERY_DF.dts_id
  is '查询源标识 ';
comment on column JKGL_PZ_QUERY_DF.df_id
  is '数据项标识 ';
comment on column JKGL_PZ_QUERY_DF.df_name
  is '数据项名称 ';
comment on column JKGL_PZ_QUERY_DF.fieldname
  is '物理字段名 ';
comment on column JKGL_PZ_QUERY_DF.datatype
  is '数据类型 1字符2数值3日期';
comment on column JKGL_PZ_QUERY_DF.showformat
  is '显示格式 页面格式';
comment on column JKGL_PZ_QUERY_DF.showlength
  is '显示宽度 页面表格';
comment on column JKGL_PZ_QUERY_DF.showorder
  is '显示顺序 在选项中的排序，非实际输出顺序';
comment on column JKGL_PZ_QUERY_DF.yxbz
  is '有效标志 Y有效N注销';
comment on column JKGL_PZ_QUERY_DF.allow_order
  is '排序标志 1支持排序';
comment on column JKGL_PZ_QUERY_DF.allow_sum
  is '合计标志 1支持汇总';
comment on column JKGL_PZ_QUERY_DF.is_cond
  is '条件标志 1用于条件';
comment on column JKGL_PZ_QUERY_DF.is_output
  is '输出标志 1可输出';
comment on column JKGL_PZ_QUERY_DF.dm_table
  is '关联代码表 ';
comment on column JKGL_PZ_QUERY_DF.dm_field
  is '代码字段 ';
comment on column JKGL_PZ_QUERY_DF.dm_name
  is '内容字段 ';
comment on column JKGL_PZ_QUERY_DF.dm_show
  is '代码显示 1代码2名称3代码+名称';
comment on column JKGL_PZ_QUERY_DF.align
  is '排列：1-居左，2-居右，3-居中';
alter table JKGL_PZ_QUERY_DF
  add constraint PK_JKGL_PZ_QUERY_DF primary key (DF_ID);

prompt
prompt Creating table JKGL_PZ_QUERY_DTS
prompt ================================
prompt
create table JKGL_PZ_QUERY_DTS
(
  dts_id    VARCHAR2(20) not null,
  dts_name  VARCHAR2(50) not null,
  dsn       VARCHAR2(30) not null,
  db_user   VARCHAR2(30) not null,
  tablename VARCHAR2(30) not null,
  yxbz      CHAR(1) not null,
  showorder NUMBER(10),
  xztj      VARCHAR2(200)
)
;
comment on table JKGL_PZ_QUERY_DTS
  is '通用查询数据源配置';
comment on column JKGL_PZ_QUERY_DTS.dts_id
  is '查询源标识';
comment on column JKGL_PZ_QUERY_DTS.dts_name
  is '查询源名称';
comment on column JKGL_PZ_QUERY_DTS.dsn
  is '物理DSN';
comment on column JKGL_PZ_QUERY_DTS.db_user
  is 'ORACLE用户名';
comment on column JKGL_PZ_QUERY_DTS.tablename
  is '物理表名，支持视图';
comment on column JKGL_PZ_QUERY_DTS.yxbz
  is '有效标志 Y-有效/N-注销';
comment on column JKGL_PZ_QUERY_DTS.showorder
  is '显示顺序';
comment on column JKGL_PZ_QUERY_DTS.xztj
  is '限制条件（隐含条件）';
alter table JKGL_PZ_QUERY_DTS
  add constraint PK_JKGL_PZ_QUERY_DTS primary key (DTS_ID);

prompt
prompt Creating table JKGL_PZ_TABLE
prompt ============================
prompt
create table JKGL_PZ_TABLE
(
  ds_id      VARCHAR2(30) not null,
  tablename  VARCHAR2(40) not null,
  ds_schema  VARCHAR2(30),
  tablecname VARCHAR2(50),
  is_dict    CHAR(1),
  yxbz       CHAR(1),
  showorder  INTEGER,
  xztj       VARCHAR2(200)
)
;
comment on table JKGL_PZ_TABLE
  is '健康管理-配置-数据表';
comment on column JKGL_PZ_TABLE.ds_id
  is '数据源标识 引用数据源配置';
comment on column JKGL_PZ_TABLE.tablename
  is '数据表标识 ';
comment on column JKGL_PZ_TABLE.ds_schema
  is '数据源用户(空表示数据源登录用户）';
comment on column JKGL_PZ_TABLE.tablecname
  is '数据表中文名 ';
comment on column JKGL_PZ_TABLE.is_dict
  is '是否为代码表 Y/N';
comment on column JKGL_PZ_TABLE.yxbz
  is '有效标志 Y/N';
comment on column JKGL_PZ_TABLE.showorder
  is '显示顺序';
comment on column JKGL_PZ_TABLE.xztj
  is '限制条件';
alter table JKGL_PZ_TABLE
  add constraint PK_JKGL_PZ_TABLE primary key (DS_ID, TABLENAME);

prompt
prompt Creating table JKGL_PZ_ZB
prompt =========================
prompt
create table JKGL_PZ_ZB
(
  zb_id         VARCHAR2(30) not null,
  zb_cname      VARCHAR2(80),
  zb_sname      VARCHAR2(50),
  zb_type       VARCHAR2(20),
  ywfl_dm       VARCHAR2(20),
  datatype      CHAR(1),
  showformat    CHAR(1),
  apply_hy      VARCHAR2(200),
  apply_qy      VARCHAR2(20),
  zb_fomula     VARCHAR2(4000),
  refresh_cycle VARCHAR2(10),
  ywms          VARCHAR2(4000),
  bbh           VARCHAR2(10),
  js_yxj        INTEGER,
  yxbz          CHAR(1),
  rs_type       VARCHAR2(20)
)
;
comment on table JKGL_PZ_ZB
  is '健康管理-配置-指标';
comment on column JKGL_PZ_ZB.zb_id
  is '指标标识 ';
comment on column JKGL_PZ_ZB.zb_cname
  is '指标名称 ';
comment on column JKGL_PZ_ZB.zb_sname
  is '指标简称 ';
comment on column JKGL_PZ_ZB.zb_type
  is '指标模式,表示指标结果值的生成方法，派生型是根据其他指标叠加时期范围或群体范围得到的关联指标 公式型/SQL型/派生型';
comment on column JKGL_PZ_ZB.ywfl_dm
  is '业务分类，关联 JKGL_DM_YWFL';
comment on column JKGL_PZ_ZB.datatype
  is '数据类型,针对指标结果值 数值型';
comment on column JKGL_PZ_ZB.showformat
  is '显示格式 默认/百分比/金额/整数';
comment on column JKGL_PZ_ZB.apply_hy
  is '适用行业（可多选） 关联行业代码表';
comment on column JKGL_PZ_ZB.apply_qy
  is '适用企业类型 空=全部/1生产/2外贸';
comment on column JKGL_PZ_ZB.zb_fomula
  is '指标公式。利用数据项、指标元、指标、指标参数、维度的计算公式伪代码 ';
comment on column JKGL_PZ_ZB.refresh_cycle
  is '刷新周期 日/周/月/季/半年/年';
comment on column JKGL_PZ_ZB.ywms
  is '业务描述 ';
comment on column JKGL_PZ_ZB.bbh
  is '版本号 ';
comment on column JKGL_PZ_ZB.js_yxj
  is '计算优先级（小值优先）';
comment on column JKGL_PZ_ZB.yxbz
  is '有效标志 Y /N';
comment on column JKGL_PZ_ZB.rs_type
  is '指标结果类型';
alter table JKGL_PZ_ZB
  add constraint PK_JKGL_PZ_ZB primary key (ZB_ID);

prompt
prompt Creating table JKGL_PZ_ZBU
prompt ==========================
prompt
create table JKGL_PZ_ZBU
(
  zbu_id        VARCHAR2(30) not null,
  zbu_cname     VARCHAR2(80),
  zbu_sname     VARCHAR2(50),
  ywfl_dm       VARCHAR2(20),
  datatype      CHAR(1),
  showformat    CHAR(1),
  ywms          VARCHAR2(4000),
  ds_id         VARCHAR2(30),
  tablename     VARCHAR2(40),
  fieldname     VARCHAR2(30),
  xztj          VARCHAR2(4000),
  bbh           VARCHAR2(10),
  yxbz          CHAR(1),
  refresh_cycle VARCHAR2(10),
  psbz          CHAR(1),
  showorder     INTEGER,
  rs_type       VARCHAR2(10)
)
;
comment on table JKGL_PZ_ZBU
  is '健康管理-配置-指标元';
comment on column JKGL_PZ_ZBU.zbu_id
  is '指标元标识 ';
comment on column JKGL_PZ_ZBU.zbu_cname
  is '指标元全称 ';
comment on column JKGL_PZ_ZBU.zbu_sname
  is '指标元简称 ';
comment on column JKGL_PZ_ZBU.ywfl_dm
  is '业务分类代码  关联 JKGL_DM_YWFL';
comment on column JKGL_PZ_ZBU.datatype
  is '数据类型  1字符型/2数值型/3日期型/4逻辑型';
comment on column JKGL_PZ_ZBU.showformat
  is '显示格式  0默认/1金额/2整数/3百分比';
comment on column JKGL_PZ_ZBU.ywms
  is '业务描述 ';
comment on column JKGL_PZ_ZBU.ds_id
  is '关联的数据源 ';
comment on column JKGL_PZ_ZBU.tablename
  is '关联的数据表 ';
comment on column JKGL_PZ_ZBU.fieldname
  is '关联的数据项 ';
comment on column JKGL_PZ_ZBU.xztj
  is '限制条件，用SQL伪代码表述查询条件 ';
comment on column JKGL_PZ_ZBU.bbh
  is '版本号 ';
comment on column JKGL_PZ_ZBU.yxbz
  is '有效标志 Y/N';
comment on column JKGL_PZ_ZBU.refresh_cycle
  is '刷新周期 日/周/月/季/半年/年';
comment on column JKGL_PZ_ZBU.psbz
  is '派生标志  0单项指标元   1派生指标元（如：全省平均）';
comment on column JKGL_PZ_ZBU.showorder
  is '显示顺序';
comment on column JKGL_PZ_ZBU.rs_type
  is '结果类型（用中文描述）';
alter table JKGL_PZ_ZBU
  add constraint PK_JKGL_PZ_ZBU primary key (ZBU_ID);

prompt
prompt Creating table JKGL_PZ_ZBU_TEMP
prompt ===============================
prompt
create table JKGL_PZ_ZBU_TEMP
(
  zbu_id        VARCHAR2(30) not null,
  zbu_cname     VARCHAR2(80),
  zbu_sname     VARCHAR2(50),
  ywfl_dm       VARCHAR2(20),
  datatype      CHAR(1),
  showformat    CHAR(1),
  ywms          VARCHAR2(4000),
  ds_id         VARCHAR2(30),
  tablename     VARCHAR2(40),
  fieldname     VARCHAR2(30),
  xztj          VARCHAR2(4000),
  bbh           VARCHAR2(10),
  yxbz          CHAR(1),
  refresh_cycle VARCHAR2(10),
  psbz          CHAR(1),
  showorder     INTEGER,
  rs_type       VARCHAR2(10)
)
;
comment on table JKGL_PZ_ZBU_TEMP
  is '健康管理-配置-指标元';
alter table JKGL_PZ_ZBU_TEMP
  add constraint PK_JKGL_PZ_ZBU_TEMP primary key (ZBU_ID);

prompt
prompt Creating table JKGL_PZ_ZB_CS
prompt ============================
prompt
create table JKGL_PZ_ZB_CS
(
  csbm     VARCHAR2(50) not null,
  csmc     VARCHAR2(100),
  zb_id    VARCHAR2(30),
  datatype CHAR(1),
  val_def  VARCHAR2(100),
  note     VARCHAR2(200),
  yxbz     CHAR(1),
  cstype   VARCHAR2(10)
)
;
comment on table JKGL_PZ_ZB_CS
  is '指标参数配置';
comment on column JKGL_PZ_ZB_CS.csbm
  is '参数编码（PK）';
comment on column JKGL_PZ_ZB_CS.csmc
  is '参数名称';
comment on column JKGL_PZ_ZB_CS.zb_id
  is '指标标识 ';
comment on column JKGL_PZ_ZB_CS.datatype
  is '数据类型 1字符型/2数值型/3日期型/4逻辑型';
comment on column JKGL_PZ_ZB_CS.val_def
  is '全省默认值';
comment on column JKGL_PZ_ZB_CS.note
  is '说明';
comment on column JKGL_PZ_ZB_CS.yxbz
  is '有效标志';
comment on column JKGL_PZ_ZB_CS.cstype
  is '参数类型：数量、数值、金额、美元、百分比';
alter table JKGL_PZ_ZB_CS
  add constraint PK_JKGL_PZ_ZB_CS primary key (CSBM);

prompt
prompt Creating table JKGL_PZ_ZB_CS_SWJG
prompt =================================
prompt
create table JKGL_PZ_ZB_CS_SWJG
(
  swjg_dm VARCHAR2(11) not null,
  csbm    VARCHAR2(50) not null,
  val_def VARCHAR2(100),
  yxbz    CHAR(1)
)
;
comment on table JKGL_PZ_ZB_CS_SWJG
  is '指标参数税务机关自定义';
comment on column JKGL_PZ_ZB_CS_SWJG.swjg_dm
  is '税务机关代码';
comment on column JKGL_PZ_ZB_CS_SWJG.csbm
  is '参数编码（PK）';
comment on column JKGL_PZ_ZB_CS_SWJG.val_def
  is '参数值';
comment on column JKGL_PZ_ZB_CS_SWJG.yxbz
  is '有效标志Y/N';
alter table JKGL_PZ_ZB_CS_SWJG
  add constraint PK_JKGL_PZ_ZB_CS_SWJG primary key (SWJG_DM, CSBM);

prompt
prompt Creating table JKGL_PZ_ZB_PS
prompt ============================
prompt
create table JKGL_PZ_ZB_PS
(
  zb_id   VARCHAR2(30) not null,
  xh      INTEGER not null,
  pslx_dm VARCHAR2(20)
)
;
comment on table JKGL_PZ_ZB_PS
  is '指标派生';
comment on column JKGL_PZ_ZB_PS.zb_id
  is '指标标识 （PK）';
comment on column JKGL_PZ_ZB_PS.xh
  is '派生序号（PK）';
comment on column JKGL_PZ_ZB_PS.pslx_dm
  is '派生类型代码（关联代码表）';
alter table JKGL_PZ_ZB_PS
  add constraint PK_JKGL_PZ_ZB_PS primary key (ZB_ID, XH);

prompt
prompt Creating table JKGL_PZ_ZB_YCFF
prompt ==============================
prompt
create table JKGL_PZ_ZB_YCFF
(
  zb_id    VARCHAR2(30) not null,
  xh       INTEGER not null,
  ycpdtj   VARCHAR2(4000),
  lwgz     VARCHAR2(4000),
  badpoint CHAR(1),
  score    INTEGER,
  note     VARCHAR2(500),
  yxbz     CHAR(1)
)
;
comment on table JKGL_PZ_ZB_YCFF
  is '指标异常规则及赋分配置';
comment on column JKGL_PZ_ZB_YCFF.zb_id
  is '指标标识 （PK）';
comment on column JKGL_PZ_ZB_YCFF.xh
  is '异常判定序号（PK）>=1';
comment on column JKGL_PZ_ZB_YCFF.ycpdtj
  is '异常判定条件（伪代码表示）';
comment on column JKGL_PZ_ZB_YCFF.lwgz
  is '例外规则（伪代码表示）';
comment on column JKGL_PZ_ZB_YCFF.badpoint
  is '坏点标志Y/N';
comment on column JKGL_PZ_ZB_YCFF.score
  is '健康码赋分';
comment on column JKGL_PZ_ZB_YCFF.note
  is '异常描述';
alter table JKGL_PZ_ZB_YCFF
  add constraint PK_JKGL_PZ_ZB_YCFF primary key (ZB_ID, XH);

prompt
prompt Creating table JKGL_PZ_ZB_YCFF_SWJG
prompt ===================================
prompt
create table JKGL_PZ_ZB_YCFF_SWJG
(
  swjg_dm VARCHAR2(11) not null,
  zb_id   VARCHAR2(30) not null,
  xh      INTEGER not null,
  score   INTEGER not null,
  yxbz    CHAR(1)
)
;
comment on table JKGL_PZ_ZB_YCFF_SWJG
  is '指标异常规则赋分税务机关自定义';
comment on column JKGL_PZ_ZB_YCFF_SWJG.swjg_dm
  is '税务机关代码';
comment on column JKGL_PZ_ZB_YCFF_SWJG.zb_id
  is '指标标识 （PK）';
comment on column JKGL_PZ_ZB_YCFF_SWJG.xh
  is '异常判定序号（PK）>=1';
comment on column JKGL_PZ_ZB_YCFF_SWJG.score
  is '健康码赋分';
comment on column JKGL_PZ_ZB_YCFF_SWJG.yxbz
  is '有效标志Y/N';
alter table JKGL_PZ_ZB_YCFF_SWJG
  add constraint PK_JKGL_PZ_ZB_YCFF_SWJG primary key (SWJG_DM, ZB_ID, XH);

prompt
prompt Creating table JKGL_QSPJ_CKSP
prompt =============================
prompt
create table JKGL_QSPJ_CKSP
(
  id     NUMBER(20) not null,
  bgqid  NUMBER(20),
  sp8_dm VARCHAR2(8),
  ckeusd NUMBER(18,2),
  ckermb NUMBER(18,2),
  cksl   NUMBER(18,2),
  ckdj   NUMBER(18,2),
  qyhs   INTEGER,
  mmylr  NUMBER(18,2)
)
;
comment on table JKGL_QSPJ_CKSP
  is '全省平均_出口商品汇总';
comment on column JKGL_QSPJ_CKSP.id
  is '序号';
comment on column JKGL_QSPJ_CKSP.bgqid
  is '报告期ID 关联主表PK_JKGL_DATA_BGQ';
comment on column JKGL_QSPJ_CKSP.sp8_dm
  is '商品代码（8）';
comment on column JKGL_QSPJ_CKSP.ckeusd
  is '出口额USD';
comment on column JKGL_QSPJ_CKSP.ckermb
  is '出口额RMB';
comment on column JKGL_QSPJ_CKSP.cksl
  is '出口数量';
comment on column JKGL_QSPJ_CKSP.ckdj
  is '出口单价';
comment on column JKGL_QSPJ_CKSP.qyhs
  is '企业户数';
comment on column JKGL_QSPJ_CKSP.mmylr
  is '每美元利润';
create index IDX_JKGL_QSPJ_CKSP on JKGL_QSPJ_CKSP (BGQID, SP8_DM);
alter table JKGL_QSPJ_CKSP
  add constraint PK_JKGL_QSPJ_CKSP primary key (ID);

prompt
prompt Creating table JKGL_QSPJ_JGB
prompt ============================
prompt
create table JKGL_QSPJ_JGB
(
  id        NUMBER(20) not null,
  bgqid     NUMBER(20),
  mll       NUMBER(18,2),
  hysfl     NUMBER(18,2),
  fysrb     NUMBER(18,2),
  dwgdzcxse NUMBER(18,2),
  dwjymjxse NUMBER(18,2)
)
;
comment on table JKGL_QSPJ_JGB
  is '全省平均_结果表';
comment on column JKGL_QSPJ_JGB.id
  is '序号';
comment on column JKGL_QSPJ_JGB.bgqid
  is '报告期ID，关联主表PK_JKGL_DATA_BGQ';
comment on column JKGL_QSPJ_JGB.mll
  is '毛利率';
comment on column JKGL_QSPJ_JGB.hysfl
  is '还原税负率';
comment on column JKGL_QSPJ_JGB.fysrb
  is '费用收入比';
comment on column JKGL_QSPJ_JGB.dwgdzcxse
  is '单位固定资产销售额';
comment on column JKGL_QSPJ_JGB.dwjymjxse
  is '单位经营面积销售额';
create index IDX_JKGL_QSPJ_JGB on JKGL_QSPJ_JGB (BGQID);
alter table JKGL_QSPJ_JGB
  add constraint PK_JKGL_QSPJ_JGB primary key (ID);

prompt
prompt Creating table JKGL_QUERY_PLAN
prompt ==============================
prompt
create table JKGL_QUERY_PLAN
(
  qp_uuid  VARCHAR2(40) not null,
  qp_name  VARCHAR2(50) not null,
  ywms     VARCHAR2(200),
  uptime   DATE not null,
  owner_dm VARCHAR2(20) not null,
  owner_mc VARCHAR2(30) not null,
  swjg_dm  VARCHAR2(11) not null,
  dts_id   VARCHAR2(20) not null,
  zfbz     CHAR(1) not null,
  gxbz     CHAR(1) not null,
  gxfw     VARCHAR2(11),
  gxcs     NUMBER(10),
  fwcs     NUMBER(10)
)
;
comment on table JKGL_QUERY_PLAN
  is '通用查询方案配置';
comment on column JKGL_QUERY_PLAN.qp_uuid
  is '查询方案UUID ';
comment on column JKGL_QUERY_PLAN.qp_name
  is '查询方案名称 ';
comment on column JKGL_QUERY_PLAN.ywms
  is '业务描述 ';
comment on column JKGL_QUERY_PLAN.uptime
  is '修改时间 ';
comment on column JKGL_QUERY_PLAN.owner_dm
  is '所属用户（代码） ';
comment on column JKGL_QUERY_PLAN.owner_mc
  is '所属用户（名称） ';
comment on column JKGL_QUERY_PLAN.swjg_dm
  is '所属税务机关 ';
comment on column JKGL_QUERY_PLAN.dts_id
  is '查询源标识 查询源标识';
comment on column JKGL_QUERY_PLAN.zfbz
  is '作废标志 N/Y作废';
comment on column JKGL_QUERY_PLAN.gxbz
  is '共享标志 0/1共享';
comment on column JKGL_QUERY_PLAN.gxfw
  is '共享范围 133全省';
comment on column JKGL_QUERY_PLAN.gxcs
  is '其他机关共享次数 机关外访问';
comment on column JKGL_QUERY_PLAN.fwcs
  is '所属机关访问次数 机关内访问';
alter table JKGL_QUERY_PLAN
  add constraint PK_JKGL_QUERY_PLAN primary key (QP_UUID);

prompt
prompt Creating table JKGL_QUERY_PLAN_COND
prompt ===================================
prompt
create table JKGL_QUERY_PLAN_COND
(
  qp_uuid     VARCHAR2(40) not null,
  ch          INTEGER not null,
  lb          VARCHAR2(5),
  df_id       VARCHAR2(40) not null,
  c_relation  VARCHAR2(20) not null,
  c_targetval VARCHAR2(250) not null,
  c_logic     VARCHAR2(10),
  rb          VARCHAR2(5),
  expression  VARCHAR2(500)
)
;
comment on table JKGL_QUERY_PLAN_COND
  is '通用查询方案-查询条件子表配置';
comment on column JKGL_QUERY_PLAN_COND.qp_uuid
  is '查询方案UUID';
comment on column JKGL_QUERY_PLAN_COND.ch
  is '（条件）序号';
comment on column JKGL_QUERY_PLAN_COND.lb
  is '左括号，在条件前加(';
comment on column JKGL_QUERY_PLAN_COND.df_id
  is '数据项标识';
comment on column JKGL_QUERY_PLAN_COND.c_relation
  is '条件关系';
comment on column JKGL_QUERY_PLAN_COND.c_targetval
  is '条件值';
comment on column JKGL_QUERY_PLAN_COND.c_logic
  is '逻辑关系AND/OR';
comment on column JKGL_QUERY_PLAN_COND.rb
  is '右括号，在条件尾加)';
comment on column JKGL_QUERY_PLAN_COND.expression
  is '本条件表达式';
alter table JKGL_QUERY_PLAN_COND
  add constraint PK_JKGL_QUERY_PLAN_COND primary key (QP_UUID, CH);

prompt
prompt Creating table JKGL_QUERY_PLAN_ITEM
prompt ===================================
prompt
create table JKGL_QUERY_PLAN_ITEM
(
  qp_uuid VARCHAR2(40) not null,
  th      INTEGER not null,
  df_id   VARCHAR2(40) not null
)
;
comment on table JKGL_QUERY_PLAN_ITEM
  is '通用查询方案-查询输出项配置';
comment on column JKGL_QUERY_PLAN_ITEM.qp_uuid
  is '查询方案UUID';
comment on column JKGL_QUERY_PLAN_ITEM.th
  is '（数据）序号';
comment on column JKGL_QUERY_PLAN_ITEM.df_id
  is '数据项标识';
alter table JKGL_QUERY_PLAN_ITEM
  add constraint PK_JKGL_QUERY_PLAN_ITEM primary key (QP_UUID, TH);

prompt
prompt Creating table JKGL_QUERY_TASK_LOG
prompt ==================================
prompt
create table JKGL_QUERY_TASK_LOG
(
  qt_uuid   VARCHAR2(40) not null,
  crtime    DATE not null,
  czry_dm   VARCHAR2(20) not null,
  czry_mc   VARCHAR2(30) not null,
  swjg_dm   VARCHAR2(11) not null,
  dts_id    VARCHAR2(20) not null,
  sql       VARCHAR2(4000),
  wctime    DATE,
  totalrows NUMBER(10),
  export    NUMBER(10) not null,
  task_hash VARCHAR2(40) not null
)
;
comment on table JKGL_QUERY_TASK_LOG
  is '通用查询任务日志';
comment on column JKGL_QUERY_TASK_LOG.qt_uuid
  is 'QT_UUID';
comment on column JKGL_QUERY_TASK_LOG.crtime
  is '创建时间';
comment on column JKGL_QUERY_TASK_LOG.czry_dm
  is '用户代码';
comment on column JKGL_QUERY_TASK_LOG.czry_mc
  is '用户名称';
comment on column JKGL_QUERY_TASK_LOG.swjg_dm
  is '税务机关';
comment on column JKGL_QUERY_TASK_LOG.dts_id
  is '查询源标识，查询源标识';
comment on column JKGL_QUERY_TASK_LOG.sql
  is 'SQL脚本';
comment on column JKGL_QUERY_TASK_LOG.wctime
  is '完成时间';
comment on column JKGL_QUERY_TASK_LOG.totalrows
  is '结果总数量';
comment on column JKGL_QUERY_TASK_LOG.export
  is '导出标志，初始0，计量导出次数';
comment on column JKGL_QUERY_TASK_LOG.task_hash
  is '任务哈希，DTS_ID+SQL+创建时间转年月日为明文';
alter table JKGL_QUERY_TASK_LOG
  add constraint PK_JKGL_QUERY_TASK_LOG primary key (QT_UUID);

prompt
prompt Creating table JKGL_QUERY_TASK_RESULT
prompt =====================================
prompt
create table JKGL_QUERY_TASK_RESULT
(
  task_hash VARCHAR2(40) not null,
  qr_data   CLOB,
  page      NUMBER(10) not null
)
;
comment on table JKGL_QUERY_TASK_RESULT
  is '通用查询任务-数据结果';
comment on column JKGL_QUERY_TASK_RESULT.task_hash
  is '任务哈希';
comment on column JKGL_QUERY_TASK_RESULT.qr_data
  is '查询结果报文';
comment on column JKGL_QUERY_TASK_RESULT.page
  is '页码';
alter table JKGL_QUERY_TASK_RESULT
  add constraint PK_JKGL_QUERY_TASK_RESULT primary key (TASK_HASH, PAGE);

prompt
prompt Creating table JKGL_REPORT_CHART
prompt ================================
prompt
create table JKGL_REPORT_CHART
(
  zbmodel    VARCHAR2(20) not null,
  crtime     DATE,
  uptime     DATE,
  title      VARCHAR2(40),
  categories VARCHAR2(2000),
  series     VARCHAR2(4000),
  type       CHAR(1)
)
;
comment on column JKGL_REPORT_CHART.zbmodel
  is '指标源对象';
comment on column JKGL_REPORT_CHART.title
  is '指标名称';
comment on column JKGL_REPORT_CHART.categories
  is '分类维度';
comment on column JKGL_REPORT_CHART.series
  is '指标系列，格式：countries:select 1 from dual ，多系列用分号分割';
comment on column JKGL_REPORT_CHART.type
  is '1,单系列 2.多系列';
alter table JKGL_REPORT_CHART
  add constraint PK_R_I_Z_Z primary key (ZBMODEL);

prompt
prompt Creating table JKGL_REPORT_DATASOURCE
prompt =====================================
prompt
create table JKGL_REPORT_DATASOURCE
(
  zbmodel_id   VARCHAR2(40) not null,
  zbmodel_name VARCHAR2(60),
  scripte_sql  VARCHAR2(4000),
  prams_holder VARCHAR2(100),
  qybz         CHAR(1),
  bz           VARCHAR2(2000),
  type         CHAR(1),
  crtime       DATE,
  uptime       DATE,
  data_source  VARCHAR2(20)
)
;
comment on column JKGL_REPORT_DATASOURCE.zbmodel_id
  is '数据源对象标识';
comment on column JKGL_REPORT_DATASOURCE.zbmodel_name
  is '数据源对象名称';
comment on column JKGL_REPORT_DATASOURCE.scripte_sql
  is '执行脚本';
comment on column JKGL_REPORT_DATASOURCE.prams_holder
  is '参数占位符，都好分割，如#{djxh},#{ckrq}';
comment on column JKGL_REPORT_DATASOURCE.qybz
  is '启用标志';
comment on column JKGL_REPORT_DATASOURCE.bz
  is '说明';
comment on column JKGL_REPORT_DATASOURCE.type
  is '数据源适用类型：1、表，2、表单，3、分析图';
comment on column JKGL_REPORT_DATASOURCE.data_source
  is '脚本数据源标识,1、TSSH  2、JSXT';
alter table JKGL_REPORT_DATASOURCE
  add constraint PK_R_D_ID primary key (ZBMODEL_ID);

prompt
prompt Creating table JKGL_REPORT_RESULT
prompt =================================
prompt
create table JKGL_REPORT_RESULT
(
  djxh     NUMBER(20) not null,
  bgnd     CHAR(4) not null,
  bglx     CHAR(1) not null,
  nsrsbh   VARCHAR2(20) not null,
  swjg_dm  VARCHAR2(11) not null,
  sqr_xm   VARCHAR2(20) not null,
  sqr_dm   VARCHAR2(20) not null,
  sqsj     DATE not null,
  ztbz     CHAR(1),
  tqbs     VARCHAR2(50),
  clkssj   DATE,
  clwcsj   DATE,
  filesize NUMBER(20),
  filefmt  VARCHAR2(10),
  filepath VARCHAR2(200),
  xzcs     NUMBER(5) default 0
)
;
comment on table JKGL_REPORT_RESULT
  is '企业画像报告结果表';
comment on column JKGL_REPORT_RESULT.djxh
  is '登记序号';
comment on column JKGL_REPORT_RESULT.bgnd
  is '报告年度';
comment on column JKGL_REPORT_RESULT.bglx
  is '报告类型，1-画像报告';
comment on column JKGL_REPORT_RESULT.nsrsbh
  is '纳税人识别号';
comment on column JKGL_REPORT_RESULT.swjg_dm
  is '税务机关代码';
comment on column JKGL_REPORT_RESULT.sqr_xm
  is '申请人姓名';
comment on column JKGL_REPORT_RESULT.sqr_dm
  is '申请人代码';
comment on column JKGL_REPORT_RESULT.sqsj
  is '申请时间';
comment on column JKGL_REPORT_RESULT.ztbz
  is '状态标志，0-已申请，1-处理中，2-已生成，9-异常中断';
comment on column JKGL_REPORT_RESULT.tqbs
  is '提取标识';
comment on column JKGL_REPORT_RESULT.clkssj
  is '处理开始时间';
comment on column JKGL_REPORT_RESULT.clwcsj
  is '处理完成时间';
comment on column JKGL_REPORT_RESULT.filesize
  is '报告文件大小，单位K';
comment on column JKGL_REPORT_RESULT.filefmt
  is '报告文件格式，DOC/DOCX';
comment on column JKGL_REPORT_RESULT.filepath
  is '报告文件路径';
comment on column JKGL_REPORT_RESULT.xzcs
  is '下载次数';
alter table JKGL_REPORT_RESULT
  add constraint JKGL_REPORT_RESULT primary key (DJXH, BGND, BGLX);

prompt
prompt Creating table JKGL_REPORT_RESULT_LOG
prompt =====================================
prompt
create table JKGL_REPORT_RESULT_LOG
(
  djxh     NUMBER(20) not null,
  bgnd     CHAR(4) not null,
  bglx     CHAR(1) not null,
  nsrsbh   VARCHAR2(20) not null,
  swjg_dm  VARCHAR2(11) not null,
  sqr_xm   VARCHAR2(20) not null,
  sqr_dm   VARCHAR2(20) not null,
  sqsj     DATE not null,
  ztbz     CHAR(1),
  tqbs     VARCHAR2(50),
  clkssj   DATE,
  clwcsj   DATE,
  filesize NUMBER(20),
  filefmt  VARCHAR2(10),
  filepath VARCHAR2(200),
  xzcs     NUMBER(5) default 0
)
;
comment on table JKGL_REPORT_RESULT_LOG
  is '企业画像报告结果表';
comment on column JKGL_REPORT_RESULT_LOG.djxh
  is '登记序号';
comment on column JKGL_REPORT_RESULT_LOG.bgnd
  is '报告年度';
comment on column JKGL_REPORT_RESULT_LOG.bglx
  is '报告类型，1-画像报告';
comment on column JKGL_REPORT_RESULT_LOG.nsrsbh
  is '纳税人识别号';
comment on column JKGL_REPORT_RESULT_LOG.swjg_dm
  is '税务机关代码';
comment on column JKGL_REPORT_RESULT_LOG.sqr_xm
  is '申请人姓名';
comment on column JKGL_REPORT_RESULT_LOG.sqr_dm
  is '申请人代码';
comment on column JKGL_REPORT_RESULT_LOG.sqsj
  is '申请时间';
comment on column JKGL_REPORT_RESULT_LOG.ztbz
  is '状态标志，0-已申请，1-处理中，2-已生成，9-异常中断';
comment on column JKGL_REPORT_RESULT_LOG.tqbs
  is '提取标识';
comment on column JKGL_REPORT_RESULT_LOG.clkssj
  is '处理开始时间';
comment on column JKGL_REPORT_RESULT_LOG.clwcsj
  is '处理完成时间';
comment on column JKGL_REPORT_RESULT_LOG.filesize
  is '报告文件大小，单位K';
comment on column JKGL_REPORT_RESULT_LOG.filefmt
  is '报告文件格式，DOC/DOCX';
comment on column JKGL_REPORT_RESULT_LOG.filepath
  is '报告文件路径';
comment on column JKGL_REPORT_RESULT_LOG.xzcs
  is '下载次数';
alter table JKGL_REPORT_RESULT_LOG
  add constraint JKGL_REPORT_RESULT_LOG primary key (DJXH, BGND, BGLX);

prompt
prompt Creating table JKGL_REPORT_TEMPLATE
prompt ===================================
prompt
create table JKGL_REPORT_TEMPLATE
(
  id            NUMBER not null,
  template_name VARCHAR2(100),
  remark        VARCHAR2(1000),
  type          CHAR(1),
  qybz          CHAR(1),
  cjr           VARCHAR2(20),
  crtime        DATE,
  uptime        DATE
)
;
comment on column JKGL_REPORT_TEMPLATE.template_name
  is '文件名';
comment on column JKGL_REPORT_TEMPLATE.remark
  is '说明';
comment on column JKGL_REPORT_TEMPLATE.type
  is '类型0，常规 1，定时';
comment on column JKGL_REPORT_TEMPLATE.qybz
  is '启用标志';
comment on column JKGL_REPORT_TEMPLATE.cjr
  is '创建人';
comment on column JKGL_REPORT_TEMPLATE.crtime
  is '创建时间';
comment on column JKGL_REPORT_TEMPLATE.uptime
  is '修改时间';
alter table JKGL_REPORT_TEMPLATE
  add constraint PK_R_T_ID primary key (ID);

prompt
prompt Creating table JKGL_REPORT_TEMPLATE_PZ
prompt ======================================
prompt
create table JKGL_REPORT_TEMPLATE_PZ
(
  template_id NUMBER not null,
  zbmodel_id  VARCHAR2(20) not null
)
;
alter table JKGL_REPORT_TEMPLATE_PZ
  add constraint PK_R_T_P_PK primary key (TEMPLATE_ID, ZBMODEL_ID);

prompt
prompt Creating table JKGL_REPORT_XZ_LOG
prompt =================================
prompt
create table JKGL_REPORT_XZ_LOG
(
  id          NUMBER(20) not null,
  djxh        NUMBER(20) not null,
  bgnd        CHAR(4) not null,
  bglx        CHAR(1) not null,
  xzr_swjg_dm VARCHAR2(11) not null,
  xzr_xm      VARCHAR2(20) not null,
  xzr_dm      VARCHAR2(20) not null,
  xzsj        DATE not null
)
;
comment on table JKGL_REPORT_XZ_LOG
  is '企业画像报告下载日志表';
comment on column JKGL_REPORT_XZ_LOG.id
  is '主键ID';
comment on column JKGL_REPORT_XZ_LOG.djxh
  is '登记序号';
comment on column JKGL_REPORT_XZ_LOG.bgnd
  is '报告年度';
comment on column JKGL_REPORT_XZ_LOG.bglx
  is '报告类型，1-画像报告';
comment on column JKGL_REPORT_XZ_LOG.xzr_swjg_dm
  is '下载人税务机关代码';
comment on column JKGL_REPORT_XZ_LOG.xzr_xm
  is '下载人姓名';
comment on column JKGL_REPORT_XZ_LOG.xzr_dm
  is '下载人代码';
comment on column JKGL_REPORT_XZ_LOG.xzsj
  is '下载时间';
alter table JKGL_REPORT_XZ_LOG
  add constraint JKGL_REPORT_XZ_LOG primary key (ID);

prompt
prompt Creating table JKGL_ZLCJ_JGB
prompt ============================
prompt
create table JKGL_ZLCJ_JGB
(
  djxh              NUMBER(20) not null,
  zcjydz            VARCHAR2(200),
  ybnsr_djrq        DATE,
  sbckyw_fsrq       DATE,
  fddbr_xm          VARCHAR2(50),
  fddbr_lxdh        VARCHAR2(50),
  cwfzr_xm          VARCHAR2(50),
  cwfzr_lxdh        VARCHAR2(50),
  zczb              NUMBER(18,2),
  zchj              NUMBER(18,2),
  gdzczz            NUMBER(18,2),
  zgrs              NUMBER(10),
  sbjfrs            NUMBER(10),
  myfs              VARCHAR2(100),
  yjnscnl           NUMBER(18,2),
  yjbgcs_mj         NUMBER(10),
  yjbgcs_cq         VARCHAR2(10),
  yjbgcs_zlqx       DATE,
  yjbgcs_zlnf       NUMBER(18,2),
  yjbgcs_ywzlfp     CHAR(1),
  ckfs              VARCHAR2(10),
  yw_szck           CHAR(1),
  ck_mj             NUMBER(10),
  yw_wgcpck         CHAR(1),
  yw_wtjgcpck       CHAR(1),
  yw_sgcyqycpck     CHAR(1),
  yw_gnxs           CHAR(1),
  yw_agdszzc        CHAR(1),
  yw_agddzba        CHAR(1),
  dzba_fs           CHAR(1),
  sfyz_ckxs_zchw    CHAR(1),
  sfqdht_jwdzhgr    CHAR(1),
  sfqdht_wmzhfw     CHAR(1),
  sjjydz            VARCHAR2(200),
  sjjyr_xm          VARCHAR2(50),
  sjjyr_lxdh        VARCHAR2(50),
  sjjyr_jg_xzqh     VARCHAR2(6),
  sjjyr_fddbr_gx    VARCHAR2(10),
  bsr_xm            VARCHAR2(50),
  bsr_lxdh          VARCHAR2(50),
  bsr_sfzh          VARCHAR2(20),
  bsr_zzjz          VARCHAR2(10),
  sn_sjwxsr         NUMBER(18,2),
  dn_yjwxsr         NUMBER(18,2),
  sfxf_zmsbysj      CHAR(1),
  gdfs              VARCHAR2(10),
  hh_zydb           VARCHAR2(50),
  hh_wddb           VARCHAR2(50),
  ypj_mj            NUMBER(10),
  ptgs_nsrsbh       VARCHAR2(20),
  ptgs_nsrmc        VARCHAR2(100),
  sjgx_sj           DATE,
  sjjyr_sfzh        VARCHAR2(20),
  tsjsfs            VARCHAR2(6),
  sjjyr_fddbr_gx_qt VARCHAR2(50),
  cjlx              CHAR(1),
  nsrsbh            VARCHAR2(21),
  nsrmc             VARCHAR2(200),
  sn_ljcke          NUMBER(18,2),
  bn_ljcke          NUMBER(18,2),
  zyscsb            VARCHAR2(1000)
)
;
comment on table JKGL_ZLCJ_JGB
  is '健康管理-资料采集-结果表';
comment on column JKGL_ZLCJ_JGB.djxh
  is '出口企业登记序号（不要用便捷退税的nsrdzdah）';
comment on column JKGL_ZLCJ_JGB.zcjydz
  is '注册经营地址  ';
comment on column JKGL_ZLCJ_JGB.ybnsr_djrq
  is '一般纳税人登记日期  ';
comment on column JKGL_ZLCJ_JGB.sbckyw_fsrq
  is '首笔出口业务发生日期  ';
comment on column JKGL_ZLCJ_JGB.fddbr_xm
  is '法定代表人_姓名  ';
comment on column JKGL_ZLCJ_JGB.fddbr_lxdh
  is '法定代表人_联系电话  ';
comment on column JKGL_ZLCJ_JGB.cwfzr_xm
  is '财务负责人_姓名  ';
comment on column JKGL_ZLCJ_JGB.cwfzr_lxdh
  is '财务负责人_联系电话  ';
comment on column JKGL_ZLCJ_JGB.zczb
  is '注册资本（元）  ';
comment on column JKGL_ZLCJ_JGB.zchj
  is '企业资产合计（元）  ';
comment on column JKGL_ZLCJ_JGB.gdzczz
  is '固定资产总值（元） 【生产】 ';
comment on column JKGL_ZLCJ_JGB.zgrs
  is '职工人数  ';
comment on column JKGL_ZLCJ_JGB.sbjfrs
  is '社保缴费人数  ';
comment on column JKGL_ZLCJ_JGB.myfs
  is '贸易方式(可多选）  一般贸易/进料加工/深加工结转/来料加工';
comment on column JKGL_ZLCJ_JGB.yjnscnl
  is '预计年生产能力（元）  ';
comment on column JKGL_ZLCJ_JGB.yjbgcs_mj
  is '生产经营场所/办公场所_面积（平方米）  ';
comment on column JKGL_ZLCJ_JGB.yjbgcs_cq
  is '生产经营场所/办公场所_产权  自有/租赁（存储中文）';
comment on column JKGL_ZLCJ_JGB.yjbgcs_zlqx
  is '经营场地/办公场所_租赁期限  ';
comment on column JKGL_ZLCJ_JGB.yjbgcs_zlnf
  is '年租赁费  ';
comment on column JKGL_ZLCJ_JGB.yjbgcs_ywzlfp
  is '租赁发票开具情况  Y有/N无';
comment on column JKGL_ZLCJ_JGB.ckfs
  is '出口方式  自营/委托（存储中文）';
comment on column JKGL_ZLCJ_JGB.yw_szck
  is '是否设置仓库  Y是/N否';
comment on column JKGL_ZLCJ_JGB.ck_mj
  is '仓库面积  ';
comment on column JKGL_ZLCJ_JGB.yw_wgcpck
  is '有无外购产品出口 【生产】 Y有/N无';
comment on column JKGL_ZLCJ_JGB.yw_wtjgcpck
  is '有无委托加工产品出口 【生产】 Y有/N无';
comment on column JKGL_ZLCJ_JGB.yw_sgcyqycpck
  is '有无收购成员企业产品出口 【生产】 Y有/N无';
comment on column JKGL_ZLCJ_JGB.yw_gnxs
  is '有无国内销售 【生产】 Y有/N无';
comment on column JKGL_ZLCJ_JGB.yw_agdszzc
  is '是否按规定设置账册  Y是/N否';
comment on column JKGL_ZLCJ_JGB.yw_agddzba
  is '是否按规定进行单证备案  Y是/N否';
comment on column JKGL_ZLCJ_JGB.dzba_fs
  is '单证备案方式  1数字化/0纸质';
comment on column JKGL_ZLCJ_JGB.sfyz_ckxs_zchw
  is '出口销售货物的品种、规格等是否与自产货物（含视同自产货物）一致 【生产】 Y是/N否';
comment on column JKGL_ZLCJ_JGB.sfqdht_jwdzhgr
  is '生产企业已与境外单位或个人签订出口合同 【生产】 Y是/N否';
comment on column JKGL_ZLCJ_JGB.sfqdht_wmzhfw
  is '生产企业已与外贸综合服务企业签订外贸综合服务合同（协议） 【生产】 Y是/N否';
comment on column JKGL_ZLCJ_JGB.sjjydz
  is '实际经营地址  ';
comment on column JKGL_ZLCJ_JGB.sjjyr_xm
  is '实际控制人_姓名  ';
comment on column JKGL_ZLCJ_JGB.sjjyr_lxdh
  is '实际控制人_联系电话  ';
comment on column JKGL_ZLCJ_JGB.sjjyr_jg_xzqh
  is '实际控制人_籍贯  行政区划代码表（6位区县级）';
comment on column JKGL_ZLCJ_JGB.sjjyr_fddbr_gx
  is '法定代表人与实际经营人之间的关系  人员关系代码表';
comment on column JKGL_ZLCJ_JGB.bsr_xm
  is '办税人_姓名  ';
comment on column JKGL_ZLCJ_JGB.bsr_lxdh
  is '办税人_联系电话  ';
comment on column JKGL_ZLCJ_JGB.bsr_sfzh
  is '办税人员_身份证号  ';
comment on column JKGL_ZLCJ_JGB.bsr_zzjz
  is '办税人员_专职兼职  专职/兼职（存储中文）';
comment on column JKGL_ZLCJ_JGB.sn_sjwxsr
  is '上年实际外销收入（元）  ';
comment on column JKGL_ZLCJ_JGB.dn_yjwxsr
  is '当年预计全年外销收入（元）  ';
comment on column JKGL_ZLCJ_JGB.sfxf_zmsbysj
  is '帐面设备与实际是否相符 【生产】 Y是/N否';
comment on column JKGL_ZLCJ_JGB.gdfs
  is '供电方式 【生产】 自有/外搭（存储中文）';
comment on column JKGL_ZLCJ_JGB.hh_zydb
  is '自由电表（户号）【生产】 ';
comment on column JKGL_ZLCJ_JGB.hh_wddb
  is '外搭电（电表户主） 【生产】 ';
comment on column JKGL_ZLCJ_JGB.ypj_mj
  is '样品间面积 【外贸】 ';
comment on column JKGL_ZLCJ_JGB.ptgs_nsrsbh
  is '配套公司_纳税人识别号 【外贸】';
comment on column JKGL_ZLCJ_JGB.ptgs_nsrmc
  is '配套公司_纳税人名称 【外贸】 ';
comment on column JKGL_ZLCJ_JGB.sjgx_sj
  is '数据更新时间';
comment on column JKGL_ZLCJ_JGB.sjjyr_sfzh
  is '实际经营人_身份证号  ';
comment on column JKGL_ZLCJ_JGB.tsjsfs
  is '退税计算方式 1-生产，2-外贸';
comment on column JKGL_ZLCJ_JGB.sjjyr_fddbr_gx_qt
  is '法定代表人与实际经营人之间的关系—其他';
comment on column JKGL_ZLCJ_JGB.cjlx
  is '采集类型 a-出口企业信息采集';
comment on column JKGL_ZLCJ_JGB.nsrsbh
  is '纳税人识别号';
comment on column JKGL_ZLCJ_JGB.nsrmc
  is '纳税人名称';
comment on column JKGL_ZLCJ_JGB.sn_ljcke
  is '上年累计出口额（美元）';
comment on column JKGL_ZLCJ_JGB.bn_ljcke
  is '本年累计出口额（美元）';
comment on column JKGL_ZLCJ_JGB.zyscsb
  is '主要生产设备（生产企业有效）';
create unique index UDX_JKGL_ZLCJ_JGB on JKGL_ZLCJ_JGB (NSRSBH, CJLX);
alter table JKGL_ZLCJ_JGB
  add constraint PK_JKGL_ZLCJ_JGB primary key (DJXH);

prompt
prompt Creating table JKGL_ZLCJ_JGB_ZB
prompt ===============================
prompt
create table JKGL_ZLCJ_JGB_ZB
(
  djxh     NUMBER(20) not null,
  zyscsb   VARCHAR2(4000),
  zy_cksp  VARCHAR2(500),
  zy_ckgb  VARCHAR2(500),
  qkms     VARCHAR2(4000),
  qtsx     VARCHAR2(4000),
  ckspgylc VARCHAR2(4000),
  zy_bgka  VARCHAR2(500)
)
;
comment on column JKGL_ZLCJ_JGB_ZB.djxh
  is '登记序号';
comment on column JKGL_ZLCJ_JGB_ZB.zyscsb
  is '主要生产设备';
comment on column JKGL_ZLCJ_JGB_ZB.zy_cksp
  is '主要经营商品(代码和名称)  ';
comment on column JKGL_ZLCJ_JGB_ZB.zy_ckgb
  is '主要出口国别';
comment on column JKGL_ZLCJ_JGB_ZB.qkms
  is '情况描述';
comment on column JKGL_ZLCJ_JGB_ZB.qtsx
  is '其他事项 ';
comment on column JKGL_ZLCJ_JGB_ZB.ckspgylc
  is '出口产品的主要生产工艺流程 【生产】';
comment on column JKGL_ZLCJ_JGB_ZB.zy_bgka
  is '主要报关口岸';
alter table JKGL_ZLCJ_JGB_ZB
  add constraint PK_JKGL_ZLCJ_JGB_ZB primary key (DJXH);

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
  txsj    DATE,
  idly    CHAR(1) not null
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
comment on column MSG_PUSH_DATA.idly
  is 'ID来源，0金三1便捷退税';
create index IDX_MSG_PUSH_DATA on MSG_PUSH_DATA (SWJG_DM, BIZTYPE);
create index IDX_MSG_PUSH_DATA_BB on MSG_PUSH_DATA (BIZTYPE, BIZKEY);
alter table MSG_PUSH_DATA
  add constraint PK_MSG_PUSH_DATA primary key (ID, IDLY);

prompt
prompt Creating table MSG_PUSH_PLAN
prompt ============================
prompt
create table MSG_PUSH_PLAN
(
  id         NUMBER(20) not null,
  userid     NUMBER(20),
  content    VARCHAR2(200) not null,
  send_type  CHAR(1),
  send_targ  VARCHAR2(128),
  crtime     DATE,
  uptime     DATE,
  plan_flag  CHAR(1),
  send_time  DATE,
  tscs       NUMBER(16) default 0,
  is_reply   CHAR(1),
  reply_time DATE,
  qybz       CHAR(1),
  fetch_lock VARCHAR2(64),
  plan_tag   VARCHAR2(64),
  username   VARCHAR2(40),
  swjg_dm    VARCHAR2(20)
)
;
comment on column MSG_PUSH_PLAN.userid
  is '发送用户的userid';
comment on column MSG_PUSH_PLAN.send_type
  is '0短';
comment on column MSG_PUSH_PLAN.send_targ
  is '手机号';
comment on column MSG_PUSH_PLAN.plan_flag
  is '0待发送/1发送完成/9失败';
comment on column MSG_PUSH_PLAN.fetch_lock
  is '任务锁定标志';
comment on column MSG_PUSH_PLAN.username
  is '发送用户';
comment on column MSG_PUSH_PLAN.swjg_dm
  is '税务机关代码';
create unique index UNI_USERID_PLANTAG on MSG_PUSH_PLAN (USERID, PLAN_TAG);

prompt
prompt Creating table MSG_PUSH_PLAN_2DEL
prompt =================================
prompt
create table MSG_PUSH_PLAN_2DEL
(
  id         NUMBER(20) not null,
  userid     NUMBER(20),
  content    VARCHAR2(200) not null,
  send_type  CHAR(1),
  send_targ  VARCHAR2(128),
  crtime     DATE,
  uptime     DATE,
  plan_flag  CHAR(1),
  send_time  DATE,
  tscs       NUMBER(16) default 0,
  is_reply   CHAR(1),
  reply_time DATE,
  qybz       CHAR(1),
  fetch_lock VARCHAR2(64),
  plan_tag   VARCHAR2(64),
  username   VARCHAR2(40),
  swjg_dm    VARCHAR2(20)
)
;
comment on column MSG_PUSH_PLAN_2DEL.userid
  is '发送用户的userid';
comment on column MSG_PUSH_PLAN_2DEL.send_type
  is '0短';
comment on column MSG_PUSH_PLAN_2DEL.send_targ
  is '手机号';
comment on column MSG_PUSH_PLAN_2DEL.plan_flag
  is '0待发送/1发送完成/9失败';
comment on column MSG_PUSH_PLAN_2DEL.fetch_lock
  is '任务锁定标志';
comment on column MSG_PUSH_PLAN_2DEL.username
  is '发送用户';
comment on column MSG_PUSH_PLAN_2DEL.swjg_dm
  is '税务机关代码';

prompt
prompt Creating table MSG_PUSH_USER
prompt ============================
prompt
create table MSG_PUSH_USER
(
  id         NUMBER(20) not null,
  username   VARCHAR2(40),
  job_type   VARCHAR2(200) not null,
  phone      VARCHAR2(11),
  crtime     DATE,
  uptime     DATE,
  swjg_dm    VARCHAR2(20),
  qybz       CHAR(1),
  job_ms     VARCHAR2(40),
  swjg_mc    VARCHAR2(80),
  gddh       VARCHAR2(20),
  jjyq_tssb  CHAR(1) default 'N' not null,
  jjyq_fuh   CHAR(1) default 'N' not null,
  jjyq_sdhc  CHAR(1) default 'N' not null,
  fxck       CHAR(1) default 'N' not null,
  nksqtx     CHAR(1) default 'N' not null,
  nkshjd     CHAR(1) default 'N' not null,
  jjyq_fuhcl CHAR(1) default 'N' not null,
  jjrtxbz    CHAR(1) default 'N' not null,
  fxcksb     CHAR(1),
  fxgh       CHAR(1),
  fxghsb     CHAR(1)
)
;
comment on column MSG_PUSH_USER.username
  is '发送用户';
comment on column MSG_PUSH_USER.job_type
  is '职务（1-局长、2-科股长、3-市局汇总、4-省局汇总）';
comment on column MSG_PUSH_USER.phone
  is '手机号';
comment on column MSG_PUSH_USER.swjg_dm
  is '税务机关代码';
comment on column MSG_PUSH_USER.jjyq_tssb
  is '（即将逾期）退税业务短信（N-否、Y-是）';
comment on column MSG_PUSH_USER.jjyq_fuh
  is '（即将逾期）函调复函短信（N-否、Y-是）';
comment on column MSG_PUSH_USER.jjyq_sdhc
  is '（即将逾期）实地核查短信（N-否、Y-是）';
comment on column MSG_PUSH_USER.fxck
  is '风险出口短信（N-否、Y-是）';
comment on column MSG_PUSH_USER.nksqtx
  is '（内控事前提醒短信（N-否、Y-是）';
comment on column MSG_PUSH_USER.nkshjd
  is '内控事后监督短信（N-否、Y-是）';
comment on column MSG_PUSH_USER.jjyq_fuhcl
  is '（即将逾期）函调处理短信（N-否、Y-是）';
comment on column MSG_PUSH_USER.jjrtxbz
  is '节假日提醒标志（N-否、Y-是）';
alter table MSG_PUSH_USER
  add constraint PK_MSG_PUSH_USER primary key (ID);

prompt
prompt Creating table RCGL_CQWSB_DATA
prompt ==============================
prompt
create table RCGL_CQWSB_DATA
(
  uuid       VARCHAR2(32) not null,
  swjgdm     CHAR(11),
  djxh       NUMBER(20) not null,
  nsrsbh     VARCHAR2(20),
  nsrmc      VARCHAR2(200),
  tsjsffdm   CHAR(1),
  ckbgdh     VARCHAR2(21) not null,
  ckrq_1     DATE,
  cksp_dm    VARCHAR2(20),
  gfhhgspmc  VARCHAR2(500),
  jgfs_dm    CHAR(4),
  mylaj      NUMBER(18,2),
  rmblaj     NUMBER(18,2),
  dyjldw_dm  VARCHAR2(3),
  cksl       NUMBER(16,4),
  wsbsl      NUMBER(16,4),
  zssl       NUMBER(16,6),
  tsl        NUMBER(16,6),
  sjly       VARCHAR2(11),
  cjrq       DATE,
  zmtbz      CHAR(1),
  qyqr_rq    DATE,
  qyqr_zt    CHAR(1) default 0,
  zms_sbssq  CHAR(6),
  zs_ysxse   NUMBER(18,2),
  zs_jtxxse  NUMBER(18,2),
  zms_ckfphm VARCHAR2(500),
  ms_msxse   NUMBER(18,2),
  ms_jhpzhbz CHAR(2),
  ms_jhpzh   VARCHAR2(500),
  ms_jxzcbz  CHAR(2),
  ms_jxzcssq CHAR(6),
  ms_jxzcje  NUMBER(18,2),
  zms_fj     VARCHAR2(500),
  zms_bz     VARCHAR2(500),
  wsb_yylx   VARCHAR2(100),
  wsb_yysm   VARCHAR2(500),
  swsh_rq    DATE,
  swsh_zt    CHAR(1) default 0,
  swsh_ry    VARCHAR2(20),
  swsh_htyj  VARCHAR2(500),
  cytssbjl   VARCHAR2(60),
  hgcjfs_dm  CHAR(1),
  zms_ckfpbz CHAR(2),
  js_rq      DATE,
  js_zt      CHAR(1) default 0,
  js_yd      VARCHAR2(1000),
  tqbz       VARCHAR2(32),
  tqsj       DATE,
  js_dm      VARCHAR2(4),
  ysb_tse    NUMBER(18,2),
  ysb_mde    NUMBER(18,2)
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
  is '征免税类型（1征税/2免税/0可退税）';
comment on column RCGL_CQWSB_DATA.qyqr_rq
  is '企业确认时间';
comment on column RCGL_CQWSB_DATA.qyqr_zt
  is '企业确认状态（0未确认/1适用征税/2适用免税/3已全部退税/4待申报退税/5非销售业务，默认“未确认”）';
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
comment on column RCGL_CQWSB_DATA.js_dm
  is '机审疑点代码';
comment on column RCGL_CQWSB_DATA.ysb_tse
  is '已申报退税额';
comment on column RCGL_CQWSB_DATA.ysb_mde
  is '已申报免抵额';
create index IDX_RCGL_CQWSB_DATA_CKRQ on RCGL_CQWSB_DATA (CKRQ_1)
  nologging;
create index IDX_RCGL_CQWSB_DATA_S on RCGL_CQWSB_DATA (SWJGDM)
  nologging;
create index JSRW_COL_IDX on RCGL_CQWSB_DATA (SWJGDM, JS_ZT, TQSJ, SWSH_ZT);
alter table RCGL_CQWSB_DATA
  add constraint PK_RCGL_CQWSB_DATA primary key (DJXH, CKBGDH);
alter index PK_RCGL_CQWSB_DATA nologging;

prompt
prompt Creating table RCGL_CQWSB_HTRZ
prompt ==============================
prompt
create table RCGL_CQWSB_HTRZ
(
  djxh       NUMBER(20) not null,
  ckbgdh     VARCHAR2(21) not null,
  qyqr_rq    DATE,
  qyqr_zt    CHAR(1) default 0,
  zms_sbssq  CHAR(6),
  zs_ysxse   NUMBER(18,2),
  zs_jtxxse  NUMBER(18,2),
  zms_ckfphm VARCHAR2(500),
  ms_msxse   NUMBER(18,2),
  ms_jhpzhbz CHAR(2),
  ms_jhpzh   VARCHAR2(500),
  ms_jxzcbz  CHAR(2),
  ms_jxzcssq CHAR(6),
  ms_jxzcje  NUMBER(18,2),
  zms_fj     VARCHAR2(500),
  zms_bz     VARCHAR2(500),
  wsb_yylx   VARCHAR2(100),
  wsb_yysm   VARCHAR2(500),
  swsh_rq    DATE,
  swsh_zt    CHAR(1) default 0,
  swsh_ry    VARCHAR2(11),
  swsh_htyj  VARCHAR2(500),
  zms_ckfpbz CHAR(2),
  js_rq      DATE,
  js_zt      CHAR(1) default 0,
  js_yd      VARCHAR2(500)
)
;
comment on table RCGL_CQWSB_HTRZ
  is '长期未申报退税业务回退日志表';
comment on column RCGL_CQWSB_HTRZ.djxh
  is '登记序号';
comment on column RCGL_CQWSB_HTRZ.ckbgdh
  is '21位报关单号或20位代理出口货物证明号';
comment on column RCGL_CQWSB_HTRZ.qyqr_rq
  is '企业确认时间';
comment on column RCGL_CQWSB_HTRZ.qyqr_zt
  is '企业确认状态（0未确认/1适用征税/2适用免税/3已全部退税/4待申报退税，默认“未确认”）';
comment on column RCGL_CQWSB_HTRZ.zms_sbssq
  is '申报所属期';
comment on column RCGL_CQWSB_HTRZ.zs_ysxse
  is '应税销售额';
comment on column RCGL_CQWSB_HTRZ.zs_jtxxse
  is '计提销项税额';
comment on column RCGL_CQWSB_HTRZ.zms_ckfphm
  is '出口发票号码';
comment on column RCGL_CQWSB_HTRZ.ms_msxse
  is '免税销售额';
comment on column RCGL_CQWSB_HTRZ.ms_jhpzhbz
  is '是否有进货凭证（有/无）';
comment on column RCGL_CQWSB_HTRZ.ms_jhpzh
  is '进货凭证号';
comment on column RCGL_CQWSB_HTRZ.ms_jxzcbz
  is '是否进项转出（是/否）';
comment on column RCGL_CQWSB_HTRZ.ms_jxzcssq
  is '进项转出所属期';
comment on column RCGL_CQWSB_HTRZ.ms_jxzcje
  is '进项转出金额';
comment on column RCGL_CQWSB_HTRZ.zms_fj
  is '附件';
comment on column RCGL_CQWSB_HTRZ.zms_bz
  is '备注';
comment on column RCGL_CQWSB_HTRZ.wsb_yylx
  is '待申报原因类型（信息不齐/单证未收齐/尚未收汇/稽查/其他）';
comment on column RCGL_CQWSB_HTRZ.wsb_yysm
  is '待申报具体原因（选其他时填写）';
comment on column RCGL_CQWSB_HTRZ.swsh_rq
  is '税务审核时间';
comment on column RCGL_CQWSB_HTRZ.swsh_zt
  is '税局审核状态（0未审核/1审核通过/2审核未通过，默认“未审核”）';
comment on column RCGL_CQWSB_HTRZ.swsh_ry
  is '税务审核人员';
comment on column RCGL_CQWSB_HTRZ.swsh_htyj
  is '回退意见（审核未通过填写）';
comment on column RCGL_CQWSB_HTRZ.zms_ckfpbz
  is '是否开具出口发票（是/否，否的时候前台显示无票销售）';
comment on column RCGL_CQWSB_HTRZ.js_rq
  is '机审时间';
comment on column RCGL_CQWSB_HTRZ.js_zt
  is '机审状态（0未审核/1审核通过/2审核有疑点，默认“未审核”）';
comment on column RCGL_CQWSB_HTRZ.js_yd
  is '机审疑点（机审有疑点时填写）';
create index IDX_RCGL_CQWSB_HTRZ_DC on RCGL_CQWSB_HTRZ (DJXH, CKBGDH);

prompt
prompt Creating table RCGL_SDQY_9810
prompt =============================
prompt
create table RCGL_SDQY_9810
(
  id     NUMBER not null,
  nsrsbh VARCHAR2(21),
  nsrmc  VARCHAR2(200),
  swjgdm VARCHAR2(13),
  qybj   CHAR(1),
  cjr    VARCHAR2(20),
  crtime DATE,
  uptime DATE,
  djxh   NUMBER(21)
)
;
comment on table RCGL_SDQY_9810
  is '态势感知-9810试点企业名单';
comment on column RCGL_SDQY_9810.id
  is '序号，主键';
comment on column RCGL_SDQY_9810.nsrsbh
  is '税号';
comment on column RCGL_SDQY_9810.nsrmc
  is '名称';
comment on column RCGL_SDQY_9810.swjgdm
  is '税务机关代码';
comment on column RCGL_SDQY_9810.qybj
  is '启用标记';
comment on column RCGL_SDQY_9810.cjr
  is '创建人';
comment on column RCGL_SDQY_9810.crtime
  is '创建时间';
comment on column RCGL_SDQY_9810.uptime
  is '更新时间';
comment on column RCGL_SDQY_9810.djxh
  is '登记序号';
alter table RCGL_SDQY_9810
  add constraint PK_ID_SDQY primary key (ID);

prompt
prompt Creating table RCGL_SDQY_9810_BAK
prompt =================================
prompt
create table RCGL_SDQY_9810_BAK
(
  id     NUMBER not null,
  nsrsbh VARCHAR2(21),
  nsrmc  VARCHAR2(200),
  swjgdm VARCHAR2(13),
  qybj   CHAR(1),
  cjr    VARCHAR2(20),
  crtime DATE,
  uptime DATE,
  djxh   NUMBER(21)
)
;
comment on table RCGL_SDQY_9810_BAK
  is '态势感知-9810试点企业名单';
comment on column RCGL_SDQY_9810_BAK.id
  is '序号，主键';
comment on column RCGL_SDQY_9810_BAK.nsrsbh
  is '税号';
comment on column RCGL_SDQY_9810_BAK.nsrmc
  is '名称';
comment on column RCGL_SDQY_9810_BAK.swjgdm
  is '税务机关代码';
comment on column RCGL_SDQY_9810_BAK.qybj
  is '启用标记';
comment on column RCGL_SDQY_9810_BAK.cjr
  is '创建人';
comment on column RCGL_SDQY_9810_BAK.crtime
  is '创建时间';
comment on column RCGL_SDQY_9810_BAK.uptime
  is '更新时间';
comment on column RCGL_SDQY_9810_BAK.djxh
  is '登记序号';
alter table RCGL_SDQY_9810_BAK
  add constraint PK_RCGL_SDQY_9810_BAK primary key (ID);

prompt
prompt Creating table SYS_PARAM
prompt ========================
prompt
create table SYS_PARAM
(
  id     NUMBER not null,
  dcode  VARCHAR2(20),
  dvalue VARCHAR2(20),
  dtype  VARCHAR2(20),
  remark VARCHAR2(200)
)
;
alter table SYS_PARAM
  add constraint PK_ID_SYS_PARAM primary key (ID);

prompt
prompt Creating table TJBB_FHXX_CMCODE
prompt ===============================
prompt
create table TJBB_FHXX_CMCODE
(
  ssny        VARCHAR2(6) not null,
  swcode      VARCHAR2(32) not null,
  xmfl        VARCHAR2(10) not null,
  sbywbdm     VARCHAR2(10) not null,
  usd_amt_all NUMBER(16,4),
  rmb_amt_all NUMBER(16,4),
  ts_amt_all  NUMBER(16,4),
  usd_amt_usa NUMBER(16,4),
  rmb_amt_usa NUMBER(16,4),
  ts_amt_usa  NUMBER(16,4)
)
;
create index IDX_TJBB_FHXX_CMCODE_SXX on TJBB_FHXX_CMCODE (SWCODE, SSNY, XMFL);

prompt
prompt Creating table TJBB_FHXX_CPCODE
prompt ===============================
prompt
create table TJBB_FHXX_CPCODE
(
  ssny        VARCHAR2(6) not null,
  swcode      VARCHAR2(32) not null,
  xmfl        VARCHAR2(32) not null,
  sbywbdm     VARCHAR2(10) not null,
  usd_amt_all NUMBER(16,4),
  rmb_amt_all NUMBER(16,4),
  ts_amt_all  NUMBER(16,4),
  usd_amt_usa NUMBER(16,4),
  rmb_amt_usa NUMBER(16,4),
  ts_amt_usa  NUMBER(16,4)
)
;
create index IDX_TJBB_FHXX_CPCODE_SXX on TJBB_FHXX_CPCODE (SWCODE, SSNY, XMFL);

prompt
prompt Creating table TJBB_FHXX_GBCODE
prompt ===============================
prompt
create table TJBB_FHXX_GBCODE
(
  ssny    VARCHAR2(6) not null,
  swcode  VARCHAR2(32) not null,
  xmfl    VARCHAR2(10) not null,
  sbywbdm VARCHAR2(10) not null,
  usd_amt NUMBER(16,4),
  rmb_amt NUMBER(16,4),
  ts_amt  NUMBER(16,4)
)
;
create index IDX_TJBB_FHXX_GBCODE_SXX on TJBB_FHXX_GBCODE (SWCODE, SSNY, XMFL);

prompt
prompt Creating table TJBB_FHXX_HGCODE
prompt ===============================
prompt
create table TJBB_FHXX_HGCODE
(
  ssny    VARCHAR2(6) not null,
  swcode  VARCHAR2(32) not null,
  xmfl    VARCHAR2(10) not null,
  sbywbdm VARCHAR2(10) not null,
  usd_amt NUMBER(16,4),
  rmb_amt NUMBER(16,4),
  ts_amt  NUMBER(16,4)
)
;
create index IDX_TJBB_FHXX_HGCODE_SXX on TJBB_FHXX_HGCODE (SWCODE, SSNY, XMFL);

prompt
prompt Creating table TJBB_FHXX_TDCODE
prompt ===============================
prompt
create table TJBB_FHXX_TDCODE
(
  ssny    VARCHAR2(6) not null,
  swcode  VARCHAR2(32) not null,
  xmfl    VARCHAR2(10) not null,
  sbywbdm VARCHAR2(10) not null,
  usd_amt NUMBER(16,4),
  rmb_amt NUMBER(16,4),
  ts_amt  NUMBER(16,4)
)
;
create index IDX_TJBB_FHXX_TDCODE_SXX on TJBB_FHXX_TDCODE (SWCODE, SSNY, XMFL);

prompt
prompt Creating table TJBB_FHXX_TSLV
prompt =============================
prompt
create table TJBB_FHXX_TSLV
(
  ssny    VARCHAR2(6) not null,
  swcode  VARCHAR2(32) not null,
  xmfl    VARCHAR2(10) not null,
  sbywbdm VARCHAR2(10) not null,
  usd_amt NUMBER(16,4),
  rmb_amt NUMBER(16,4),
  ts_amt  NUMBER(16,4)
)
;
create index IDX_TJBB_FHXX_TSLV_SXX on TJBB_FHXX_TSLV (SWCODE, SSNY, XMFL);

prompt
prompt Creating table TMP_20260527_WMQYMMYLRL
prompt ======================================
prompt
create table TMP_20260527_WMQYMMYLRL
(
  swjg_dm    VARCHAR2(11) not null,
  djxh       NUMBER(20) not null,
  sbywbs     NUMBER(10),
  mmylrl_max NUMBER(10,2),
  mmylrl_min NUMBER(10,2),
  mmylrl_mid NUMBER(10,2),
  mmylrl_avg NUMBER(10,2),
  mmylrl_std NUMBER(10,2),
  mmylrl_yjx NUMBER(10,2)
)
;
comment on table TMP_20260527_WMQYMMYLRL
  is '每美元利润率分析模型表';
comment on column TMP_20260527_WMQYMMYLRL.swjg_dm
  is '税务机关代码';
comment on column TMP_20260527_WMQYMMYLRL.djxh
  is '登记序号';
comment on column TMP_20260527_WMQYMMYLRL.sbywbs
  is '申报业务笔数';
comment on column TMP_20260527_WMQYMMYLRL.mmylrl_max
  is '最大值';
comment on column TMP_20260527_WMQYMMYLRL.mmylrl_min
  is '最小值';
comment on column TMP_20260527_WMQYMMYLRL.mmylrl_mid
  is '中位数';
comment on column TMP_20260527_WMQYMMYLRL.mmylrl_avg
  is '平均值';
comment on column TMP_20260527_WMQYMMYLRL.mmylrl_std
  is '标准差';
comment on column TMP_20260527_WMQYMMYLRL.mmylrl_yjx
  is '预警线';
alter table TMP_20260527_WMQYMMYLRL
  add constraint PK_TMP_20260527_WMQYMMYLRL primary key (SWJG_DM, DJXH);

prompt
prompt Creating table TMP_CKBGDH_20260408
prompt ==================================
prompt
create table TMP_CKBGDH_20260408
(
  ckbgdh VARCHAR2(21) not null,
  sjly   VARCHAR2(10)
)
;

prompt
prompt Creating table TMP_LCSLID
prompt =========================
prompt
create table TMP_LCSLID
(
  lcslid VARCHAR2(32)
)
;
comment on column TMP_LCSLID.lcslid
  is '流程实例ID';

prompt
prompt Creating table TMP_PX_JZX
prompt =========================
prompt
create table TMP_PX_JZX
(
  jzxh   VARCHAR2(32),
  ckrq_1 DATE,
  qyhs   NUMBER(5)
)
;
comment on table TMP_PX_JZX
  is '拼箱集装箱';
comment on column TMP_PX_JZX.jzxh
  is '集装箱号';
comment on column TMP_PX_JZX.ckrq_1
  is '出口日期';
comment on column TMP_PX_JZX.qyhs
  is '拼箱企业户数';
create index IDX_TMP_PXJZX_JC on TMP_PX_JZX (JZXH, CKRQ_1)
  nologging;

prompt
prompt Creating table TMP_PX_MX
prompt ========================
prompt
create table TMP_PX_MX
(
  jzxh   VARCHAR2(32),
  ckrq_1 DATE,
  djxh   NUMBER(20)
)
;
comment on table TMP_PX_MX
  is '企业拼箱明细';
comment on column TMP_PX_MX.jzxh
  is '集装箱号';
comment on column TMP_PX_MX.ckrq_1
  is '出口日期';
comment on column TMP_PX_MX.djxh
  is '登记序号';
create index IDX_TMP_PX_MX_JC on TMP_PX_MX (CKRQ_1, JZXH)
  nologging;
create index IDX_TMP_PX_MX_JCD on TMP_PX_MX (CKRQ_1, JZXH, DJXH)
  nologging;

prompt
prompt Creating table TMP_QY_20250121_01
prompt =================================
prompt
create table TMP_QY_20250121_01
(
  xh   NUMBER(20),
  djxh NUMBER(20)
)
;

prompt
prompt Creating table TMP_QY_20250407_01
prompt =================================
prompt
create table TMP_QY_20250407_01
(
  xh     NUMBER(20),
  nsrmc  VARCHAR2(300),
  shxyno VARCHAR2(20),
  djxh   NUMBER(20),
  swjg   VARCHAR2(11),
  qylx   CHAR(1)
)
;
create index IDX_TMP_QY_20250407_01 on TMP_QY_20250407_01 (XH);

prompt
prompt Creating table TMP_QY_20260518
prompt ==============================
prompt
create table TMP_QY_20260518
(
  djxh   NUMBER(20),
  shxhdm VARCHAR2(20),
  nsrmc  VARCHAR2(300)
)
;

prompt
prompt Creating table TMP_RCGL_CQWSB_20260113
prompt ======================================
prompt
create table TMP_RCGL_CQWSB_20260113
(
  djxh   NUMBER(20),
  nsrsbh VARCHAR2(30),
  ckbgdh VARCHAR2(21)
)
;
comment on column TMP_RCGL_CQWSB_20260113.djxh
  is '登记序号';
comment on column TMP_RCGL_CQWSB_20260113.nsrsbh
  is '纳税人识别号';
comment on column TMP_RCGL_CQWSB_20260113.ckbgdh
  is '出口报关单号';

prompt
prompt Creating table TMP_RCGL_CQWSB_20260115
prompt ======================================
prompt
create table TMP_RCGL_CQWSB_20260115
(
  djxh   NUMBER(20),
  nsrsbh VARCHAR2(30),
  ckbgdh VARCHAR2(21)
)
;
comment on column TMP_RCGL_CQWSB_20260115.djxh
  is '登记序号';
comment on column TMP_RCGL_CQWSB_20260115.nsrsbh
  is '纳税人识别号';
comment on column TMP_RCGL_CQWSB_20260115.ckbgdh
  is '出口报关单号';

prompt
prompt Creating table TMP_RCGL_CQWSB_YCL_1330108
prompt =========================================
prompt
create table TMP_RCGL_CQWSB_YCL_1330108
(
  djxh    NUMBER(20),
  ckbgdh  VARCHAR2(21),
  swsh_rq DATE,
  swsh_zt CHAR(1) default 0,
  swsh_ry VARCHAR2(20)
)
;
create index IDX_RCGL_CQWSB_YCL_1330108_DC on TMP_RCGL_CQWSB_YCL_1330108 (DJXH, CKBGDH);

prompt
prompt Creating table TMP_RCGL_CQWSB_YCL_1330185
prompt =========================================
prompt
create table TMP_RCGL_CQWSB_YCL_1330185
(
  djxh    NUMBER(20),
  nsrsbh  VARCHAR2(18),
  nsrmc   VARCHAR2(100),
  ckbgdh  VARCHAR2(21),
  qyqr_zt CHAR(1)
)
;
create index IDX_RCGL_CQWSB_YCL_1330185_DC on TMP_RCGL_CQWSB_YCL_1330185 (DJXH, CKBGDH);

prompt
prompt Creating table TMP_RCGL_CQWSB_YCL_13304
prompt =======================================
prompt
create table TMP_RCGL_CQWSB_YCL_13304
(
  djxh   NUMBER(20),
  nsrsbh VARCHAR2(30),
  nsrmc  VARCHAR2(100),
  ckbgdh VARCHAR2(21),
  hsrq   DATE,
  hsr    VARCHAR2(60),
  hsclyj VARCHAR2(200)
)
;
comment on column TMP_RCGL_CQWSB_YCL_13304.djxh
  is '登记序号';
comment on column TMP_RCGL_CQWSB_YCL_13304.nsrsbh
  is '纳税人识别号';
comment on column TMP_RCGL_CQWSB_YCL_13304.nsrmc
  is '纳税人名称';
comment on column TMP_RCGL_CQWSB_YCL_13304.ckbgdh
  is '出口报关单号';
comment on column TMP_RCGL_CQWSB_YCL_13304.hsrq
  is '核实日期';
comment on column TMP_RCGL_CQWSB_YCL_13304.hsr
  is '核实人';
comment on column TMP_RCGL_CQWSB_YCL_13304.hsclyj
  is '核实处理意见';
create index IDX_RCGL_CQWSB_YCL_13304_DC on TMP_RCGL_CQWSB_YCL_13304 (DJXH, CKBGDH);

prompt
prompt Creating table TMP_RCGL_CQWSB_YCL_13306
prompt =======================================
prompt
create table TMP_RCGL_CQWSB_YCL_13306
(
  djxh   NUMBER(20),
  nsrsbh VARCHAR2(18),
  nsrmc  VARCHAR2(100),
  ckbgdh VARCHAR2(21),
  dlzmh  VARCHAR2(21),
  hsrq   DATE,
  hsr    VARCHAR2(20),
  hsclyj VARCHAR2(200),
  swcode VARCHAR2(11),
  sjly   VARCHAR2(10),
  lrrq   DATE default sysdate not null,
  ckrq   DATE,
  mylaj  NUMBER(15,2),
  rmblaj NUMBER(15,2)
)
;
comment on column TMP_RCGL_CQWSB_YCL_13306.djxh
  is '登记序号';
comment on column TMP_RCGL_CQWSB_YCL_13306.nsrsbh
  is '纳税人识别号';
comment on column TMP_RCGL_CQWSB_YCL_13306.nsrmc
  is '纳税人名称';
comment on column TMP_RCGL_CQWSB_YCL_13306.ckbgdh
  is '出口报关单号';
comment on column TMP_RCGL_CQWSB_YCL_13306.dlzmh
  is '代理证明号';
comment on column TMP_RCGL_CQWSB_YCL_13306.hsrq
  is '核实日期';
comment on column TMP_RCGL_CQWSB_YCL_13306.hsr
  is '核实人';
comment on column TMP_RCGL_CQWSB_YCL_13306.hsclyj
  is '核实处理意见';
comment on column TMP_RCGL_CQWSB_YCL_13306.swcode
  is '税务机关代码';
comment on column TMP_RCGL_CQWSB_YCL_13306.sjly
  is '数据来源';
comment on column TMP_RCGL_CQWSB_YCL_13306.lrrq
  is '录入日期';
comment on column TMP_RCGL_CQWSB_YCL_13306.ckrq
  is '出口日期';
comment on column TMP_RCGL_CQWSB_YCL_13306.mylaj
  is '美元离岸价';
comment on column TMP_RCGL_CQWSB_YCL_13306.rmblaj
  is '人民币离岸价';
create index IDX_RCGL_CQWSB_YCL_13306_DC on TMP_RCGL_CQWSB_YCL_13306 (DJXH, CKBGDH);

prompt
prompt Creating table TMP_RCGL_CQWSB_YCL_1330723
prompt =========================================
prompt
create table TMP_RCGL_CQWSB_YCL_1330723
(
  djxh      NUMBER(20),
  nsrsbh    VARCHAR2(20),
  ckbgdh    VARCHAR2(21),
  qyqr_rq   DATE,
  qyqr_zt   CHAR(1),
  zms_sbssq CHAR(6),
  zs_ysxse  NUMBER(18,2),
  zs_jtxxse NUMBER(18,2),
  ms_msxse  NUMBER(18,2),
  ms_jxzcbz CHAR(2),
  ms_jxzcje NUMBER(18,2),
  zms_bz    VARCHAR2(500),
  swsh_ry   VARCHAR2(20)
)
;
comment on column TMP_RCGL_CQWSB_YCL_1330723.zms_bz
  is '备注';
comment on column TMP_RCGL_CQWSB_YCL_1330723.swsh_ry
  is '税务审核人员';

prompt
prompt Creating table TMP_RCGL_CQWSB_YCL_1330723_1
prompt ===========================================
prompt
create table TMP_RCGL_CQWSB_YCL_1330723_1
(
  qyhgdm   VARCHAR2(18),
  nsrsbh   VARCHAR2(18),
  nsrmc    VARCHAR2(100),
  ckbgdh   VARCHAR2(21) not null,
  cksp_dm  VARCHAR2(20),
  sbhgspmc VARCHAR2(500),
  rmblaj   NUMBER(15,2),
  mylaj    NUMBER(15,2),
  ckrq     DATE,
  tmszc    VARCHAR2(20),
  sfsbzzs  VARCHAR2(20),
  sbsj     VARCHAR2(20),
  abssq    VARCHAR2(20),
  mdtxse   VARCHAR2(20),
  msxse    VARCHAR2(20),
  ysxse    VARCHAR2(20),
  tmsse    VARCHAR2(20),
  jtxxse   VARCHAR2(20),
  jxzcse   VARCHAR2(20),
  rkzzs    VARCHAR2(20),
  rkznj    VARCHAR2(20),
  bz       VARCHAR2(300),
  hsclyj   VARCHAR2(200),
  hsr      VARCHAR2(20),
  djxh     NUMBER(20) not null
)
;
alter table TMP_RCGL_CQWSB_YCL_1330723_1
  add constraint PK_RCGL_CQWSB_YCL_1330723_1 primary key (DJXH, CKBGDH);

prompt
prompt Creating table TMP_RCGL_CQWSB_YCL_1330723_2
prompt ===========================================
prompt
create table TMP_RCGL_CQWSB_YCL_1330723_2
(
  qyhgdm   VARCHAR2(18),
  nsrsbh   VARCHAR2(18),
  nsrmc    VARCHAR2(100),
  ckbgdh   VARCHAR2(21) not null,
  cksp_dm  VARCHAR2(20),
  sbhgspmc VARCHAR2(500),
  rmblaj   NUMBER(15,2),
  mylaj    NUMBER(15,2),
  ckrq     DATE,
  tmszc    VARCHAR2(20),
  sfsbzzs  VARCHAR2(20),
  sbsj     VARCHAR2(20),
  abssq    VARCHAR2(20),
  mdtxse   VARCHAR2(20),
  msxse    VARCHAR2(20),
  ysxse    VARCHAR2(20),
  tmsse    VARCHAR2(20),
  jtxxse   VARCHAR2(20),
  jxzcse   VARCHAR2(20),
  rkzzs    VARCHAR2(20),
  rkznj    VARCHAR2(20),
  bz       VARCHAR2(300),
  hsclyj   VARCHAR2(200),
  hsr      VARCHAR2(20),
  djxh     NUMBER(20) not null
)
;
comment on column TMP_RCGL_CQWSB_YCL_1330723_2.djxh
  is '登记序号';
alter table TMP_RCGL_CQWSB_YCL_1330723_2
  add constraint PK_RCGL_CQWSB_YCL_1330723_2 primary key (DJXH, CKBGDH);

prompt
prompt Creating table TMP_RCGL_CQWSB_YCL_13310
prompt =======================================
prompt
create table TMP_RCGL_CQWSB_YCL_13310
(
  djxh    NUMBER(20),
  nsrsbh  VARCHAR2(30),
  nsrmc   VARCHAR2(100),
  ckbgdh  VARCHAR2(21),
  hsrq    DATE,
  hsr     VARCHAR2(60),
  hsclyj  VARCHAR2(200),
  qyqr_zt CHAR(1) default 0,
  swsh_zt CHAR(1) default 1
)
;
comment on column TMP_RCGL_CQWSB_YCL_13310.djxh
  is '登记序号';
comment on column TMP_RCGL_CQWSB_YCL_13310.nsrsbh
  is '纳税人识别号';
comment on column TMP_RCGL_CQWSB_YCL_13310.nsrmc
  is '纳税人名称';
comment on column TMP_RCGL_CQWSB_YCL_13310.ckbgdh
  is '出口报关单号';
comment on column TMP_RCGL_CQWSB_YCL_13310.hsrq
  is '核实日期';
comment on column TMP_RCGL_CQWSB_YCL_13310.hsr
  is '核实人';
comment on column TMP_RCGL_CQWSB_YCL_13310.hsclyj
  is '核实处理意见';
comment on column TMP_RCGL_CQWSB_YCL_13310.qyqr_zt
  is '企业确认状态（0未确认/1适用征税/2适用免税/3已全部退税/4待申报退税/5非销售业务，默认“未确认”）';
comment on column TMP_RCGL_CQWSB_YCL_13310.swsh_zt
  is '税局审核状态（0未审核/1审核通过/2审核未通过，默认“未审核”）';
create index IDX_RCGL_CQWSB_YCL_13310_DC on TMP_RCGL_CQWSB_YCL_13310 (DJXH, CKBGDH);

prompt
prompt Creating table TMP_RCGL_CQWSB_YCL_13310_1
prompt =========================================
prompt
create table TMP_RCGL_CQWSB_YCL_13310_1
(
  djxh    NUMBER(20),
  nsrsbh  VARCHAR2(30),
  nsrmc   VARCHAR2(100),
  ckbgdh  VARCHAR2(21),
  hsrq    DATE,
  hsr     VARCHAR2(60),
  hsclyj  VARCHAR2(200),
  qyqr_zt CHAR(1) default 0,
  swsh_zt CHAR(1) default 1
)
;
comment on column TMP_RCGL_CQWSB_YCL_13310_1.djxh
  is '登记序号';
comment on column TMP_RCGL_CQWSB_YCL_13310_1.nsrsbh
  is '纳税人识别号';
comment on column TMP_RCGL_CQWSB_YCL_13310_1.nsrmc
  is '纳税人名称';
comment on column TMP_RCGL_CQWSB_YCL_13310_1.ckbgdh
  is '出口报关单号';
comment on column TMP_RCGL_CQWSB_YCL_13310_1.hsrq
  is '核实日期';
comment on column TMP_RCGL_CQWSB_YCL_13310_1.hsr
  is '核实人';
comment on column TMP_RCGL_CQWSB_YCL_13310_1.hsclyj
  is '核实处理意见';
comment on column TMP_RCGL_CQWSB_YCL_13310_1.qyqr_zt
  is '企业确认状态（0未确认/1适用征税/2适用免税/3已全部退税/4待申报退税/5非销售业务，默认“未确认”）';
comment on column TMP_RCGL_CQWSB_YCL_13310_1.swsh_zt
  is '税局审核状态（0未审核/1审核通过/2审核未通过，默认“未审核”）';
create index IDX_RCGL_CQWSB_YCL_13310_1_DC on TMP_RCGL_CQWSB_YCL_13310_1 (DJXH, CKBGDH);

prompt
prompt Creating table TMP_RCGL_CQWSB_YCL_HYQY
prompt ======================================
prompt
create table TMP_RCGL_CQWSB_YCL_HYQY
(
  djxh       NUMBER(20),
  ckbgdh     VARCHAR2(21),
  qyqr_rq    DATE,
  qyqr_zt    CHAR(1) default 0,
  zms_ckfpbz CHAR(2),
  zms_ckfphm VARCHAR2(500),
  zms_sbssq  CHAR(6),
  zs_ysxse   NUMBER(18,2),
  zs_jtxxse  NUMBER(18,2),
  ms_msxse   NUMBER(18,2),
  ms_jhpzhbz CHAR(2),
  ms_jhpzh   VARCHAR2(500),
  ms_jxzcbz  CHAR(2),
  ms_jxzcssq CHAR(6),
  ms_jxzcje  NUMBER(18,2),
  zms_bz     VARCHAR2(500),
  wsb_yylx   VARCHAR2(100),
  wsb_yysm   VARCHAR2(500)
)
;
comment on table TMP_RCGL_CQWSB_YCL_HYQY
  is '长期未申报退税业务会员企业数据导入';
comment on column TMP_RCGL_CQWSB_YCL_HYQY.djxh
  is '登记序号';
comment on column TMP_RCGL_CQWSB_YCL_HYQY.ckbgdh
  is '21位报关单号或20位代理出口货物证明号';
comment on column TMP_RCGL_CQWSB_YCL_HYQY.qyqr_rq
  is '企业确认时间';
comment on column TMP_RCGL_CQWSB_YCL_HYQY.qyqr_zt
  is '企业确认状态（0未确认/1适用征税/2适用免税/3已全部退税/4待申报退税/5非销售业务，默认“未确认”）';
comment on column TMP_RCGL_CQWSB_YCL_HYQY.zms_ckfpbz
  is '是否开具出口发票（是/否，否的时候前台显示无票销售）';
comment on column TMP_RCGL_CQWSB_YCL_HYQY.zms_ckfphm
  is '出口发票号码';
comment on column TMP_RCGL_CQWSB_YCL_HYQY.zms_sbssq
  is '申报所属期';
comment on column TMP_RCGL_CQWSB_YCL_HYQY.zs_ysxse
  is '应税销售额';
comment on column TMP_RCGL_CQWSB_YCL_HYQY.zs_jtxxse
  is '计提销项税额';
comment on column TMP_RCGL_CQWSB_YCL_HYQY.ms_msxse
  is '免税销售额';
comment on column TMP_RCGL_CQWSB_YCL_HYQY.ms_jhpzhbz
  is '是否有进货凭证（有/无）';
comment on column TMP_RCGL_CQWSB_YCL_HYQY.ms_jhpzh
  is '进货凭证号';
comment on column TMP_RCGL_CQWSB_YCL_HYQY.ms_jxzcbz
  is '是否进项转出（是/否）';
comment on column TMP_RCGL_CQWSB_YCL_HYQY.ms_jxzcssq
  is '进项转出所属期';
comment on column TMP_RCGL_CQWSB_YCL_HYQY.ms_jxzcje
  is '进项转出金额';
comment on column TMP_RCGL_CQWSB_YCL_HYQY.zms_bz
  is '备注';
comment on column TMP_RCGL_CQWSB_YCL_HYQY.wsb_yylx
  is '待申报原因类型（信息不齐/单证未收齐/尚未收汇/稽查/其他）';
comment on column TMP_RCGL_CQWSB_YCL_HYQY.wsb_yysm
  is '待申报具体原因（选其他时填写）';

prompt
prompt Creating table TMP_RCGL_CQWSB_YCL_HYQYHIS
prompt =========================================
prompt
create table TMP_RCGL_CQWSB_YCL_HYQYHIS
(
  djxh       NUMBER(20) not null,
  ckbgdh     VARCHAR2(21) not null,
  qyqr_rq    DATE,
  qyqr_zt    CHAR(1) default 0,
  zms_ckfpbz CHAR(2),
  zms_ckfphm VARCHAR2(500),
  zms_sbssq  CHAR(6),
  zs_ysxse   NUMBER(18,2),
  zs_jtxxse  NUMBER(18,2),
  ms_msxse   NUMBER(18,2),
  ms_jhpzhbz CHAR(2),
  ms_jhpzh   VARCHAR2(500),
  ms_jxzcbz  CHAR(2),
  ms_jxzcssq CHAR(6),
  ms_jxzcje  NUMBER(18,2),
  zms_bz     VARCHAR2(500),
  wsb_yylx   VARCHAR2(100),
  wsb_yysm   VARCHAR2(500)
)
;
comment on table TMP_RCGL_CQWSB_YCL_HYQYHIS
  is '长期未申报退税业务会员企业数据导入';

prompt
prompt Creating table TMP_SB_CKTMSYWLX
prompt ===============================
prompt
create table TMP_SB_CKTMSYWLX
(
  cktmsywlxdmjh VARCHAR2(30),
  sbcs          NUMBER(10)
)
;
create index IDX_TMP_SB_CKTMSYWLX on TMP_SB_CKTMSYWLX (CKTMSYWLXDMJH);

prompt
prompt Creating table TMP_SWJG_NDTJ
prompt ============================
prompt
create table TMP_SWJG_NDTJ
(
  swjg_dm   VARCHAR2(11) not null,
  swjg_mc   VARCHAR2(80) not null,
  sbhs_all  NUMBER(18),
  sbhs_sc   NUMBER(18),
  sbhs_wm   NUMBER(18),
  sbhs_xse  NUMBER(18),
  sbhs_bgd  NUMBER(18),
  mylaj_all NUMBER(18,6),
  mylaj_sc  NUMBER(18,6),
  mylaj_wm  NUMBER(18,6),
  tmse_all  NUMBER(18,6),
  tmse_sc   NUMBER(18,6),
  tmse_wm   NUMBER(18,6)
)
;
comment on column TMP_SWJG_NDTJ.swjg_dm
  is '税务机关代码';
comment on column TMP_SWJG_NDTJ.swjg_mc
  is '税务机关名称';
comment on column TMP_SWJG_NDTJ.sbhs_all
  is '申报户数';
comment on column TMP_SWJG_NDTJ.sbhs_sc
  is '申报户数';
comment on column TMP_SWJG_NDTJ.sbhs_wm
  is '申报户数';
comment on column TMP_SWJG_NDTJ.sbhs_xse
  is '申报户数';
comment on column TMP_SWJG_NDTJ.sbhs_bgd
  is '申报户数';
comment on column TMP_SWJG_NDTJ.mylaj_all
  is '美元离岸价';
comment on column TMP_SWJG_NDTJ.mylaj_sc
  is '美元离岸价';
comment on column TMP_SWJG_NDTJ.mylaj_wm
  is '美元离岸价';
comment on column TMP_SWJG_NDTJ.tmse_all
  is '退免税额';
comment on column TMP_SWJG_NDTJ.tmse_sc
  is '退免税额';
comment on column TMP_SWJG_NDTJ.tmse_wm
  is '退免税额';

prompt
prompt Creating table TMP_TJBB_DT_B03104
prompt =================================
prompt
create table TMP_TJBB_DT_B03104
(
  ssny          VARCHAR2(6) not null,
  bblc          VARCHAR2(10) not null,
  swjgdm        VARCHAR2(32) not null,
  spdldm        VARCHAR2(16),
  spdl          VARCHAR2(16),
  spmc          VARCHAR2(400),
  usd_year      NUMBER(16,4),
  tse_year      NUMBER(16,4),
  mde_year      NUMBER(16,4),
  usd_year_last NUMBER(16,4),
  tse_year_last NUMBER(16,4),
  mde_year_last NUMBER(16,4),
  usd_tb        NUMBER(16,4),
  usd_zb        NUMBER(16,4),
  tse_tb        NUMBER(16,4),
  tse_zb        NUMBER(16,4),
  mde_tb        NUMBER(16,4),
  mde_zb        NUMBER(16,4)
)
;
comment on column TMP_TJBB_DT_B03104.spdldm
  is '商品大类代码';
comment on column TMP_TJBB_DT_B03104.spdl
  is '商品大类';
comment on column TMP_TJBB_DT_B03104.usd_year
  is '出口额';
comment on column TMP_TJBB_DT_B03104.tse_year
  is '退税额';
comment on column TMP_TJBB_DT_B03104.mde_year
  is '退税额';
comment on column TMP_TJBB_DT_B03104.usd_year_last
  is '出口额上年';
comment on column TMP_TJBB_DT_B03104.tse_year_last
  is '退税额上年';
comment on column TMP_TJBB_DT_B03104.mde_year_last
  is '退税额上年';
comment on column TMP_TJBB_DT_B03104.usd_tb
  is '同比';
comment on column TMP_TJBB_DT_B03104.usd_zb
  is '比重';
comment on column TMP_TJBB_DT_B03104.tse_tb
  is '同比';
comment on column TMP_TJBB_DT_B03104.tse_zb
  is '比重';
comment on column TMP_TJBB_DT_B03104.mde_tb
  is '同比';
comment on column TMP_TJBB_DT_B03104.mde_zb
  is '比重';
alter table TMP_TJBB_DT_B03104
  add constraint PK_TMP_TJBB_DT_B03104 primary key (SSNY, BBLC, SWJGDM);

prompt
prompt Creating table TMP_TJBB_FHXX_CMCODE
prompt ===================================
prompt
create table TMP_TJBB_FHXX_CMCODE
(
  ssny        VARCHAR2(6) not null,
  swcode      VARCHAR2(32) not null,
  xmfl        VARCHAR2(10) not null,
  sbywbdm     VARCHAR2(10) not null,
  usd_amt_all NUMBER(16,4),
  rmb_amt_all NUMBER(16,4),
  ts_amt_all  NUMBER(16,4),
  md_amt_all  NUMBER(16,4),
  usd_amt_usa NUMBER(16,4),
  rmb_amt_usa NUMBER(16,4),
  ts_amt_usa  NUMBER(16,4),
  md_amt_usa  NUMBER(16,4)
)
;
create index IDX_TMP_TJBB_FHXX_CMCODE_SXX on TMP_TJBB_FHXX_CMCODE (SWCODE, SSNY, XMFL);

prompt
prompt Creating table TMP_TSLTZ_20241117
prompt =================================
prompt
create table TMP_TSLTZ_20241117
(
  xh   NUMBER,
  spdm VARCHAR2(20),
  spmc VARCHAR2(1000),
  tzlx CHAR(1)
)
;

prompt
prompt Creating table TMP_TSLTZ_20260113
prompt =================================
prompt
create table TMP_TSLTZ_20260113
(
  xh   NUMBER,
  spdm VARCHAR2(20),
  spmc VARCHAR2(2000),
  tzlx CHAR(1)
)
;
create index IDX_TMP_TSLTZ_20260113 on TMP_TSLTZ_20260113 (SPDM)
  nologging;

prompt
prompt Creating table TMP_TSLTZ_20260113_1
prompt ===================================
prompt
create table TMP_TSLTZ_20260113_1
(
  tzlx   CHAR(1),
  spdm   VARCHAR2(20),
  sjly   CHAR(1),
  djxh   NUMBER(20),
  ckbgdh VARCHAR2(21),
  ckrq_1 DATE,
  ckyear VARCHAR2(4),
  mylaj  NUMBER(18,2),
  tmse   NUMBER(18,2)
)
;
comment on column TMP_TSLTZ_20260113_1.tzlx
  is '调整类型';
comment on column TMP_TSLTZ_20260113_1.spdm
  is '商品代码';
comment on column TMP_TSLTZ_20260113_1.sjly
  is '数据来源';
comment on column TMP_TSLTZ_20260113_1.djxh
  is '登记序号';
comment on column TMP_TSLTZ_20260113_1.ckyear
  is '出口年份';
comment on column TMP_TSLTZ_20260113_1.mylaj
  is '出口销售（美元）';
comment on column TMP_TSLTZ_20260113_1.tmse
  is '申报退免税额';

prompt
prompt Creating table TMP_TSLTZ_20260113_2
prompt ===================================
prompt
create table TMP_TSLTZ_20260113_2
(
  tzlx   CHAR(1),
  spdm   VARCHAR2(20),
  sjly   CHAR(1),
  djxh   NUMBER(20),
  ckyear VARCHAR2(4),
  bgdfs  NUMBER(10),
  hwmxts NUMBER(10),
  mylaj  NUMBER(18,2),
  tmse   NUMBER(18,2)
)
;
comment on column TMP_TSLTZ_20260113_2.tzlx
  is '调整类型';
comment on column TMP_TSLTZ_20260113_2.spdm
  is '商品代码';
comment on column TMP_TSLTZ_20260113_2.sjly
  is '数据来源';
comment on column TMP_TSLTZ_20260113_2.djxh
  is '登记序号';
comment on column TMP_TSLTZ_20260113_2.ckyear
  is '出口年份';
comment on column TMP_TSLTZ_20260113_2.bgdfs
  is '报关单份数';
comment on column TMP_TSLTZ_20260113_2.hwmxts
  is '货物明细条数';
comment on column TMP_TSLTZ_20260113_2.mylaj
  is '出口销售（美元）';
comment on column TMP_TSLTZ_20260113_2.tmse
  is '申报退免税额';

prompt
prompt Creating table TMP_TSLTZ_20260113_3
prompt ===================================
prompt
create table TMP_TSLTZ_20260113_3
(
  tzlx         CHAR(1),
  spdm         VARCHAR2(20),
  sjly         CHAR(1),
  djxh         NUMBER(20),
  ckbgdh       VARCHAR2(21),
  ckrq_1       DATE,
  ckyear       VARCHAR2(4),
  mylaj        NUMBER(18,2),
  rmblaj       NUMBER(18,2),
  zzmdgdqsz_dm CHAR(3)
)
;
comment on column TMP_TSLTZ_20260113_3.tzlx
  is '调整类型';
comment on column TMP_TSLTZ_20260113_3.spdm
  is '商品代码';
comment on column TMP_TSLTZ_20260113_3.sjly
  is '数据来源';
comment on column TMP_TSLTZ_20260113_3.djxh
  is '登记序号';
comment on column TMP_TSLTZ_20260113_3.ckyear
  is '出口年份';
comment on column TMP_TSLTZ_20260113_3.mylaj
  is '出口销售（美元）';
comment on column TMP_TSLTZ_20260113_3.rmblaj
  is '出口销售（人民币）';

prompt
prompt Creating table TMP_TSLTZ_20260113_4
prompt ===================================
prompt
create table TMP_TSLTZ_20260113_4
(
  tzlx         CHAR(1),
  spdm         VARCHAR2(20),
  sjly         CHAR(1),
  djxh         NUMBER(20),
  ckyear       VARCHAR2(4),
  bgdfs        NUMBER(10),
  hwmxts       NUMBER(10),
  mylaj        NUMBER(18,2),
  rmblaj       NUMBER(18,2),
  zzmdgdqsz_dm CHAR(3)
)
;
comment on column TMP_TSLTZ_20260113_4.tzlx
  is '调整类型';
comment on column TMP_TSLTZ_20260113_4.spdm
  is '商品代码';
comment on column TMP_TSLTZ_20260113_4.sjly
  is '数据来源';
comment on column TMP_TSLTZ_20260113_4.djxh
  is '登记序号';
comment on column TMP_TSLTZ_20260113_4.ckyear
  is '出口年份';
comment on column TMP_TSLTZ_20260113_4.bgdfs
  is '报关单份数';
comment on column TMP_TSLTZ_20260113_4.hwmxts
  is '货物明细条数';
comment on column TMP_TSLTZ_20260113_4.mylaj
  is '出口销售（美元）';
comment on column TMP_TSLTZ_20260113_4.rmblaj
  is '出口销售（人民币）';

prompt
prompt Creating table TMP_TSLTZ_20260113_5
prompt ===================================
prompt
create table TMP_TSLTZ_20260113_5
(
  tzlx   CHAR(1),
  spdm   VARCHAR2(20),
  sjly   CHAR(1),
  djxh   NUMBER(20),
  ckbgdh VARCHAR2(21),
  sbrq   DATE,
  sbyear VARCHAR2(4),
  mylaj  NUMBER(18,2),
  tmse   NUMBER(18,2)
)
;
comment on column TMP_TSLTZ_20260113_5.tzlx
  is '调整类型';
comment on column TMP_TSLTZ_20260113_5.spdm
  is '商品代码';
comment on column TMP_TSLTZ_20260113_5.sjly
  is '数据来源';
comment on column TMP_TSLTZ_20260113_5.djxh
  is '登记序号';
comment on column TMP_TSLTZ_20260113_5.sbyear
  is '申报年份';
comment on column TMP_TSLTZ_20260113_5.mylaj
  is '出口销售（美元）';
comment on column TMP_TSLTZ_20260113_5.tmse
  is '申报退免税额';

prompt
prompt Creating table TMP_TSLTZ_20260113_6
prompt ===================================
prompt
create table TMP_TSLTZ_20260113_6
(
  tzlx   CHAR(1),
  spdm   VARCHAR2(20),
  sjly   CHAR(1),
  djxh   NUMBER(20),
  sbyear VARCHAR2(4),
  bgdfs  NUMBER(10),
  hwmxts NUMBER(10),
  mylaj  NUMBER(18,2),
  tmse   NUMBER(18,2)
)
;
comment on column TMP_TSLTZ_20260113_6.tzlx
  is '调整类型';
comment on column TMP_TSLTZ_20260113_6.spdm
  is '商品代码';
comment on column TMP_TSLTZ_20260113_6.sjly
  is '数据来源';
comment on column TMP_TSLTZ_20260113_6.djxh
  is '登记序号';
comment on column TMP_TSLTZ_20260113_6.sbyear
  is '申报年份';
comment on column TMP_TSLTZ_20260113_6.bgdfs
  is '报关单份数';
comment on column TMP_TSLTZ_20260113_6.hwmxts
  is '货物明细条数';
comment on column TMP_TSLTZ_20260113_6.mylaj
  is '出口销售（美元）';
comment on column TMP_TSLTZ_20260113_6.tmse
  is '申报退免税额';

prompt
prompt Creating table TMP_WLYCFX_XZQHDM
prompt ================================
prompt
create table TMP_WLYCFX_XZQHDM
(
  ckka_dm VARCHAR2(4),
  ckka_mc VARCHAR2(80),
  ghsf_dm VARCHAR2(4),
  ghsf_mc VARCHAR2(80),
  dlqy_dm VARCHAR2(4),
  dlqy_mc VARCHAR2(80)
)
;
comment on column TMP_WLYCFX_XZQHDM.ckka_dm
  is '出口口岸代码';
comment on column TMP_WLYCFX_XZQHDM.ckka_mc
  is '出口口岸名称';
comment on column TMP_WLYCFX_XZQHDM.ghsf_dm
  is '供货省份代码';
comment on column TMP_WLYCFX_XZQHDM.ghsf_mc
  is '供货省份名称';
comment on column TMP_WLYCFX_XZQHDM.dlqy_dm
  is '地理区域代码';
comment on column TMP_WLYCFX_XZQHDM.dlqy_mc
  is '地理区域名称';
create index IDX_TMP_WLYCFX_XZQHDM_CKKA on TMP_WLYCFX_XZQHDM (CKKA_DM)
  nologging;

prompt
prompt Creating table TMP_WMQYCKWL_20260603
prompt ====================================
prompt
create table TMP_WMQYCKWL_20260603
(
  lcslid       CHAR(32),
  djxh         NUMBER(20),
  glh          VARCHAR2(30),
  ghfnsrsbh_1  VARCHAR2(20),
  jhpzh        VARCHAR2(75),
  jsje         NUMBER(18,2),
  mylaj        NUMBER(18,2),
  cksp_dm      VARCHAR2(20),
  ysfs_dm      VARCHAR2(1),
  zzmdgdqsz_dm VARCHAR2(3),
  hggqka_dm    VARCHAR2(4),
  qysdqdm      VARCHAR2(4)
)
;
comment on column TMP_WMQYCKWL_20260603.lcslid
  is '分流LCSLID';
comment on column TMP_WMQYCKWL_20260603.djxh
  is '登记序号';
comment on column TMP_WMQYCKWL_20260603.glh
  is '关联号';
comment on column TMP_WMQYCKWL_20260603.ghfnsrsbh_1
  is '供货方纳税人识别号';
comment on column TMP_WMQYCKWL_20260603.jhpzh
  is '进货凭证号/专用税票号';
comment on column TMP_WMQYCKWL_20260603.jsje
  is '计税金额';
comment on column TMP_WMQYCKWL_20260603.mylaj
  is '美元离岸价';
comment on column TMP_WMQYCKWL_20260603.cksp_dm
  is '出口商品代码';

prompt
prompt Creating table TMP_WZEFJ_CKTS_LC_SEHZXX
prompt =======================================
prompt
create table TMP_WZEFJ_CKTS_LC_SEHZXX
(
  uuid                VARCHAR2(32),
  cktmsjhssswjgdm     CHAR(11),
  djxh                NUMBER(20),
  cktmsjhssswjgdm_new CHAR(11)
)
;
comment on table TMP_WZEFJ_CKTS_LC_SEHZXX
  is '二分局_税额核准信息';

prompt
prompt Creating table TMP_WZEFJ_CKTS_LC_SEHZXX_MD
prompt ==========================================
prompt
create table TMP_WZEFJ_CKTS_LC_SEHZXX_MD
(
  uuid             VARCHAR2(32),
  mdtkssswjgdm     CHAR(11),
  djxh             NUMBER(20),
  mdtkssswjgdm_new CHAR(11)
)
;
comment on table TMP_WZEFJ_CKTS_LC_SEHZXX_MD
  is '二分局_税额核准信息';

prompt
prompt Creating table TMP_WZEFJ_CKTS_LC_SHXX
prompt =====================================
prompt
create table TMP_WZEFJ_CKTS_LC_SHXX
(
  uuid       VARCHAR2(32),
  tsswjg_dm  CHAR(11),
  djxh       NUMBER(20),
  tsswjg_new CHAR(11)
)
;
comment on table TMP_WZEFJ_CKTS_LC_SHXX
  is '二分局_流程审核信息';

prompt
prompt Creating table TMP_WZEFJ_FG_CKTSFN_HXZG
prompt =======================================
prompt
create table TMP_WZEFJ_FG_CKTSFN_HXZG
(
  spuuid       VARCHAR2(32),
  skssswjg_dm  VARCHAR2(11),
  djxh         NUMBER(20),
  skssswjg_new VARCHAR2(11)
)
;
comment on table TMP_WZEFJ_FG_CKTSFN_HXZG
  is '二分局_出口退税返纳';

prompt
prompt Creating table TMP_WZEFJ_GLXT_BB_SHXT_DJXX
prompt ==========================================
prompt
create table TMP_WZEFJ_GLXT_BB_SHXT_DJXX
(
  swjgdm     VARCHAR2(11),
  cpcode     VARCHAR2(32),
  swjgdm_new VARCHAR2(11)
)
;
comment on table TMP_WZEFJ_GLXT_BB_SHXT_DJXX
  is '二分局_出口企业档案表';

prompt
prompt Creating table TMP_XSSWJ_CKLLFX
prompt ===============================
prompt
create table TMP_XSSWJ_CKLLFX
(
  tsswjg_dm_1 VARCHAR2(11),
  ysfs_dm     VARCHAR2(1),
  spdl_dm     VARCHAR2(2),
  qycode_hyd  VARCHAR2(5),
  qycode_hg   VARCHAR2(4),
  qycode_mdg  VARCHAR2(3),
  qyhs_all    NUMBER(10),
  qyzb_all    NUMBER(10,6),
  bgdfs_all   NUMBER(10),
  bgdzb_all   NUMBER(10,6),
  mylaj_all   NUMBER(18,2),
  myzb_all    NUMBER(10,6),
  qyhs_sx     NUMBER(10),
  qyzb_sx     NUMBER(10,6),
  bgdfs_sx    NUMBER(10),
  bgdzb_sx    NUMBER(10,6),
  mylaj_sx    NUMBER(18,2),
  myzb_sx     NUMBER(10,6),
  fxdj_zhfxzs NUMBER(10,6),
  fxdj_dm     CHAR(1)
)
;
comment on table TMP_XSSWJ_CKLLFX
  is '出口链路分析-历史数据统计表';
comment on column TMP_XSSWJ_CKLLFX.tsswjg_dm_1
  is '税务机关';
comment on column TMP_XSSWJ_CKLLFX.ysfs_dm
  is '运输方式';
comment on column TMP_XSSWJ_CKLLFX.spdl_dm
  is '商品大类';
comment on column TMP_XSSWJ_CKLLFX.qycode_hyd
  is '供应商地区';
comment on column TMP_XSSWJ_CKLLFX.qycode_hg
  is '离境口岸';
comment on column TMP_XSSWJ_CKLLFX.qycode_mdg
  is '目的国（洲）';
comment on column TMP_XSSWJ_CKLLFX.qyhs_all
  is '企业户数';
comment on column TMP_XSSWJ_CKLLFX.qyzb_all
  is '企业占比（%）';
comment on column TMP_XSSWJ_CKLLFX.bgdfs_all
  is '报关单份数';
comment on column TMP_XSSWJ_CKLLFX.bgdzb_all
  is '报关单占比（%）';
comment on column TMP_XSSWJ_CKLLFX.mylaj_all
  is '美元离岸价';
comment on column TMP_XSSWJ_CKLLFX.myzb_all
  is '美元占比（%）';
comment on column TMP_XSSWJ_CKLLFX.qyhs_sx
  is '（预留字段，按预警口径筛选）企业户数';
comment on column TMP_XSSWJ_CKLLFX.qyzb_sx
  is '（预留字段，按预警口径筛选）企业占比（%）';
comment on column TMP_XSSWJ_CKLLFX.bgdfs_sx
  is '（预留字段，按预警口径筛选）报关单份数';
comment on column TMP_XSSWJ_CKLLFX.bgdzb_sx
  is '（预留字段，按预警口径筛选）报关单占比（%）';
comment on column TMP_XSSWJ_CKLLFX.mylaj_sx
  is '（预留字段，按预警口径筛选）美元离岸价';
comment on column TMP_XSSWJ_CKLLFX.myzb_sx
  is '（预留字段，按预警口径筛选）美元占比（%）';
comment on column TMP_XSSWJ_CKLLFX.fxdj_zhfxzs
  is '综合风险指数，根据前面各项占比综合计算';
comment on column TMP_XSSWJ_CKLLFX.fxdj_dm
  is '风险等级指标';

prompt
prompt Creating table TMP_YCTS_ZZSFP
prompt =============================
prompt
create table TMP_YCTS_ZZSFP
(
  fpdmhm  VARCHAR2(30) not null,
  fpdm    VARCHAR2(20),
  fphm    VARCHAR2(10),
  kprq    TIMESTAMP(6),
  fpzt_bz VARCHAR2(1),
  xfsbh   VARCHAR2(26),
  gfsbh   VARCHAR2(64),
  je      NUMBER(18,2),
  se      NUMBER(18,2),
  jshj    NUMBER(18,2),
  fpzt_dm VARCHAR2(2),
  kpyf    NUMBER,
  bytsbz  CHAR(1),
  byblbz  CHAR(1),
  lcslid  CHAR(32),
  uuid    VARCHAR2(32) not null,
  djxh    NUMBER(20),
  sbxh    VARCHAR2(50),
  glh     VARCHAR2(30),
  sjly    VARCHAR2(100),
  bdly    VARCHAR2(100) not null,
  ssq     VARCHAR2(60),
  sbpc    VARCHAR2(75),
  yfpdmhm VARCHAR2(30),
  bz      VARCHAR2(1000),
  hzcjbz  CHAR(1)
)
;
alter table TMP_YCTS_ZZSFP
  add constraint PK_TMP_YCTS_ZZSFP primary key (UUID, BDLY);

prompt
prompt Creating table TMP_ZXZB_2026062
prompt ===============================
prompt
create table TMP_ZXZB_2026062
(
  nsrsbh VARCHAR2(20),
  smjg   VARCHAR2(300),
  hsrq   DATE,
  hsry   VARCHAR2(200),
  hsclqk VARCHAR2(2000)
)
;
comment on column TMP_ZXZB_2026062.nsrsbh
  is '税号';
comment on column TMP_ZXZB_2026062.smjg
  is '扫描结果描述';
comment on column TMP_ZXZB_2026062.hsrq
  is '核实日期';
comment on column TMP_ZXZB_2026062.hsry
  is '核实人员';
comment on column TMP_ZXZB_2026062.hsclqk
  is '核实处理情况';

prompt
prompt Creating table TSGZ_DATA
prompt ========================
prompt
create table TSGZ_DATA
(
  swjg_dm      VARCHAR2(11) not null,
  area         CHAR(1) not null,
  screen_level CHAR(1) not null,
  table_seq    INTEGER default 0 not null,
  content      CLOB,
  uptime       DATE not null,
  remark       VARCHAR2(100)
)
;
alter table TSGZ_DATA
  add unique (SWJG_DM, AREA, SCREEN_LEVEL, TABLE_SEQ);

prompt
prompt Creating table TSGZ_DATA_HISTORY
prompt ================================
prompt
create table TSGZ_DATA_HISTORY
(
  data_date    VARCHAR2(6) not null,
  swjg_dm      VARCHAR2(11) not null,
  area         CHAR(1) not null,
  screen_level CHAR(1) not null,
  table_seq    INTEGER default 0 not null,
  content      CLOB,
  uptime       DATE not null,
  remark       VARCHAR2(100)
)
;
comment on table TSGZ_DATA_HISTORY
  is '态势感知_数据_历史表';
comment on column TSGZ_DATA_HISTORY.data_date
  is '数据统计日期';
comment on column TSGZ_DATA_HISTORY.swjg_dm
  is '税务机关代码';
comment on column TSGZ_DATA_HISTORY.area
  is '区域：A、B、C、D、E、F';
comment on column TSGZ_DATA_HISTORY.screen_level
  is '屏幕层级：1-首页大屏、2-子屏';
comment on column TSGZ_DATA_HISTORY.table_seq
  is '表格序列号，预留字段，防止某个区域下数据量太大，可以按照区域内表格分开存储';
comment on column TSGZ_DATA_HISTORY.content
  is '数据内容';
comment on column TSGZ_DATA_HISTORY.uptime
  is '更新时间';
comment on column TSGZ_DATA_HISTORY.remark
  is '备注';
alter table TSGZ_DATA_HISTORY
  add unique (DATA_DATE, SWJG_DM, AREA, SCREEN_LEVEL, TABLE_SEQ);

prompt
prompt Creating table WSSB_CKTS_MDTKB
prompt ==============================
prompt
create table WSSB_CKTS_MDTKB
(
  ms_id         INTEGER not null,
  item_no       VARCHAR2(2) not null,
  hgqydm        VARCHAR2(10),
  nsrmc         VARCHAR2(80),
  nsrsbh        VARCHAR2(20),
  tktk_mdse_sps NUMBER(16,2),
  nsr_swjg_dm   VARCHAR2(11),
  swdjblx_dm    CHAR(1),
  skgk_dm       VARCHAR2(20),
  gly_dm        VARCHAR2(20),
  res_2         VARCHAR2(500) not null,
  op_date       DATE,
  sb_ym         VARCHAR2(6),
  dzbh          VARCHAR2(20),
  kjrq          DATE,
  xhrq          DATE,
  tk_flag       CHAR(1) default '0' not null,
  tbyycode      VARCHAR2(20) default '110'
)
;
alter table WSSB_CKTS_MDTKB
  add constraint PK_CKTS_MDTKB primary key (MS_ID, ITEM_NO);

prompt
prompt Creating table WSSB_CKTS_TSTHS
prompt ==============================
prompt
create table WSSB_CKTS_TSTHS
(
  no            VARCHAR2(18) not null,
  hgqydm        VARCHAR2(10),
  nsrmc         VARCHAR2(80),
  nsrsbh        VARCHAR2(20),
  tktk_ytse_sps NUMBER(18,2),
  tktk_mdse_sps NUMBER(18,2),
  qylx_dm       CHAR(1),
  nsr_swjg_dm   VARCHAR2(11),
  swdjblx_dm    CHAR(1),
  skgk_dm       VARCHAR2(20),
  sb_ym         VARCHAR2(6),
  gly_dm        VARCHAR2(20),
  res_2         VARCHAR2(500),
  ttxh          VARCHAR2(20),
  kjrq          DATE,
  xhrq          DATE,
  tk_flag       CHAR(1) default '0' not null,
  op_date       DATE default sysdate not null,
  zsxm_dm       VARCHAR2(2) default '01' not null,
  tbyycode      VARCHAR2(20) default '110'
)
;
alter table WSSB_CKTS_TSTHS
  add constraint PK_CKTS_TSTHS primary key (NO);

prompt
prompt Creating table YJ_BGDGZXX_JGB
prompt =============================
prompt
create table YJ_BGDGZXX_JGB
(
  djxh   NUMBER(20) not null,
  ckbgdh VARCHAR2(21) not null,
  gzxx   VARCHAR2(1000),
  czr_dm VARCHAR2(15) not null,
  czrq   DATE not null
)
;
comment on table YJ_BGDGZXX_JGB
  is '报关单关注信息表';
comment on column YJ_BGDGZXX_JGB.djxh
  is '金三企业登记序号';
comment on column YJ_BGDGZXX_JGB.ckbgdh
  is '出口报关单号（21位）/代理证明号（20位）';
comment on column YJ_BGDGZXX_JGB.gzxx
  is '关注信息';
comment on column YJ_BGDGZXX_JGB.czr_dm
  is '最后一次操作人员代码，系统自动记录';
comment on column YJ_BGDGZXX_JGB.czrq
  is '最后一次操作日期，系统自动记录';
alter table YJ_BGDGZXX_JGB
  add constraint PK_YJ_BGDGZXX_JGB primary key (DJXH, CKBGDH);

prompt
prompt Creating table YWY_BAXX_GCB
prompt ===========================
prompt
create table YWY_BAXX_GCB
(
  id       NUMBER(20) not null,
  djxh     NUMBER(20) not null,
  zjlx     VARCHAR2(3) default '201' not null,
  zjhm     VARCHAR2(30) not null,
  xm       VARCHAR2(40) not null,
  sex      CHAR(1) not null,
  phone    VARCHAR2(20),
  status   CHAR(1) default '1' not null,
  gzrq_q   DATE,
  gzrq_z   DATE,
  ckcpfw   VARCHAR2(1000),
  sfqdldht CHAR(1) not null,
  sfdjsb   CHAR(1) not null,
  ywyly    CHAR(1) not null,
  qtlyms   VARCHAR2(100),
  zj_hash  VARCHAR2(40),
  zfbz     CHAR(1) not null,
  zfsj     DATE,
  cr_time  DATE,
  up_time  DATE,
  qrbz     CHAR(1) default '0' not null,
  bazt     CHAR(1) default '0' not null,
  tjsj     DATE,
  basj     DATE,
  thsj     DATE,
  thyy     VARCHAR2(200),
  qrr_dm   VARCHAR2(20),
  qrsj     DATE
)
;
comment on table YWY_BAXX_GCB
  is '业务员备案信息表';
comment on column YWY_BAXX_GCB.id
  is '主键序号';
comment on column YWY_BAXX_GCB.djxh
  is '登记序号';
comment on column YWY_BAXX_GCB.zjlx
  is '证件类型  201居民身份证 208护照 210港澳通行证 213 台湾通行证';
comment on column YWY_BAXX_GCB.zjhm
  is '证件号码';
comment on column YWY_BAXX_GCB.xm
  is '姓名';
comment on column YWY_BAXX_GCB.sex
  is '性别    1男   2女';
comment on column YWY_BAXX_GCB.phone
  is '手机';
comment on column YWY_BAXX_GCB.status
  is '业务员状态   1在职  0离职';
comment on column YWY_BAXX_GCB.gzrq_q
  is '工作日期起';
comment on column YWY_BAXX_GCB.gzrq_z
  is '工作日期止';
comment on column YWY_BAXX_GCB.ckcpfw
  is '出口产品范围';
comment on column YWY_BAXX_GCB.sfqdldht
  is '是否签订劳动合同   Y是  N 否';
comment on column YWY_BAXX_GCB.sfdjsb
  is '是否代缴社保  Y是  N 否';
comment on column YWY_BAXX_GCB.ywyly
  is '业务员来源   1他人介绍    2招聘   3企业法人/投资方/实际管理人   4其他';
comment on column YWY_BAXX_GCB.qtlyms
  is '其他来源描述';
comment on column YWY_BAXX_GCB.zj_hash
  is '证件照片-哈希值';
comment on column YWY_BAXX_GCB.zfbz
  is '作废标志   Y已作废，N未作废';
comment on column YWY_BAXX_GCB.zfsj
  is '作废时间';
comment on column YWY_BAXX_GCB.cr_time
  is '创建时间';
comment on column YWY_BAXX_GCB.up_time
  is '修改时间';
comment on column YWY_BAXX_GCB.qrbz
  is '需确认标记  0无需确认  1需税务端确认';
comment on column YWY_BAXX_GCB.bazt
  is '备案状态  0未备案   1备案中（税务端待确认） 2已备案（税务端已确认）3备案退回';
comment on column YWY_BAXX_GCB.tjsj
  is '提交时间';
comment on column YWY_BAXX_GCB.basj
  is '备案时间';
comment on column YWY_BAXX_GCB.thsj
  is '退回时间';
comment on column YWY_BAXX_GCB.thyy
  is '退回原因';
comment on column YWY_BAXX_GCB.qrr_dm
  is '确认人代码';
comment on column YWY_BAXX_GCB.qrsj
  is '确认时间';
create index IDX_YWY_BAXX_GCB_DJXH on YWY_BAXX_GCB (DJXH);
create index IDX_YWY_BAXX_GCB_ZJHM on YWY_BAXX_GCB (ZJHM);
alter table YWY_BAXX_GCB
  add constraint PK_YWY_BAXX_GCB primary key (ID);

prompt
prompt Creating table YWY_BAXX_IMPORT
prompt ==============================
prompt
create table YWY_BAXX_IMPORT
(
  id       NUMBER(10) not null,
  djxh     NUMBER(20),
  qyhgdm   VARCHAR2(32),
  nsrsbh   VARCHAR2(20),
  nsrmc    VARCHAR2(100),
  xm       VARCHAR2(40),
  zjhm     VARCHAR2(30),
  phone    VARCHAR2(20),
  gzrq_q   DATE,
  sfqdldht CHAR(1),
  sfdjsb   CHAR(1),
  status   CHAR(1),
  basj     DATE,
  up_time  DATE
)
;
alter table YWY_BAXX_IMPORT
  add primary key (ID);

prompt
prompt Creating table YWY_BAXX_JGB
prompt ===========================
prompt
create table YWY_BAXX_JGB
(
  id       NUMBER(20) not null,
  djxh     NUMBER(20) not null,
  zjlx     VARCHAR2(3) default '201' not null,
  zjhm     VARCHAR2(30) not null,
  xm       VARCHAR2(40) not null,
  sex      CHAR(1) not null,
  phone    VARCHAR2(20),
  status   CHAR(1) default '1' not null,
  gzrq_q   DATE,
  gzrq_z   DATE,
  ckcpfw   VARCHAR2(1000),
  sfqdldht CHAR(1) not null,
  sfdjsb   CHAR(1) not null,
  ywyly    CHAR(1) not null,
  qtlyms   VARCHAR2(100),
  zj_hash  VARCHAR2(40),
  zfbz     CHAR(1) not null,
  zfsj     DATE,
  cr_time  DATE,
  up_time  DATE,
  qrbz     CHAR(1) default '0' not null,
  bazt     CHAR(1) default '0' not null,
  tjsj     DATE,
  basj     DATE,
  thsj     DATE,
  thyy     VARCHAR2(200),
  qrr_dm   VARCHAR2(20),
  qrsj     DATE
)
;
comment on table YWY_BAXX_JGB
  is '业务员备案信息表结果表';
comment on column YWY_BAXX_JGB.id
  is '主键序号';
comment on column YWY_BAXX_JGB.djxh
  is '纳税人电子档案号';
comment on column YWY_BAXX_JGB.zjlx
  is '证件类型  201居民身份证 208护照 210港澳通行证 213 台湾通行证';
comment on column YWY_BAXX_JGB.zjhm
  is '证件号码';
comment on column YWY_BAXX_JGB.xm
  is '姓名';
comment on column YWY_BAXX_JGB.sex
  is '性别    1男   2女';
comment on column YWY_BAXX_JGB.phone
  is '手机';
comment on column YWY_BAXX_JGB.status
  is '业务员状态   1在职  0离职';
comment on column YWY_BAXX_JGB.gzrq_q
  is '工作日期起';
comment on column YWY_BAXX_JGB.gzrq_z
  is '工作日期止';
comment on column YWY_BAXX_JGB.ckcpfw
  is '出口产品范围';
comment on column YWY_BAXX_JGB.sfqdldht
  is '是否签订劳动合同   Y是  N 否';
comment on column YWY_BAXX_JGB.sfdjsb
  is '是否代缴社保  Y是  N 否';
comment on column YWY_BAXX_JGB.ywyly
  is '业务员来源   1他人介绍    2招聘   3企业法人/投资方/实际管理人   4其他';
comment on column YWY_BAXX_JGB.qtlyms
  is '其他来源描述';
comment on column YWY_BAXX_JGB.zj_hash
  is '证件照片-哈希值';
comment on column YWY_BAXX_JGB.zfbz
  is '作废标志   Y已作废，N未作废';
comment on column YWY_BAXX_JGB.zfsj
  is '作废时间';
comment on column YWY_BAXX_JGB.cr_time
  is '创建时间';
comment on column YWY_BAXX_JGB.up_time
  is '修改时间';
comment on column YWY_BAXX_JGB.qrbz
  is '需确认标记  0无需确认  1需税务端确认';
comment on column YWY_BAXX_JGB.bazt
  is '备案状态  0未备案   1备案中（税务端待确认） 2已备案（税务端已确认）3备案退回';
comment on column YWY_BAXX_JGB.tjsj
  is '提交时间';
comment on column YWY_BAXX_JGB.basj
  is '备案时间';
comment on column YWY_BAXX_JGB.thsj
  is '退回时间';
comment on column YWY_BAXX_JGB.thyy
  is '退回原因';
comment on column YWY_BAXX_JGB.qrr_dm
  is '确认人代码';
comment on column YWY_BAXX_JGB.qrsj
  is '确认时间';
create index IDX_YWY_BAXX_JGB_DJXH on YWY_BAXX_JGB (DJXH);
create index IDX_YWY_BAXX_JGB_ZJHM on YWY_BAXX_JGB (ZJHM);
alter table YWY_BAXX_JGB
  add constraint PK_YWY_BAXX_JGB primary key (ID);

prompt
prompt Creating table YWY_BAXX_LSB
prompt ===========================
prompt
create table YWY_BAXX_LSB
(
  id       NUMBER(20) not null,
  ywy_id   NUMBER(20),
  djxh     NUMBER(20),
  zjlx     VARCHAR2(3),
  zjhm     VARCHAR2(30),
  xm       VARCHAR2(40),
  sex      CHAR(1),
  phone    VARCHAR2(20),
  status   CHAR(1),
  gzrq_q   DATE,
  gzrq_z   DATE,
  ckcpfw   VARCHAR2(1000),
  sfqdldht CHAR(1),
  sfdjsb   CHAR(1),
  ywyly    CHAR(1),
  qtlyms   VARCHAR2(100),
  zj_hash  VARCHAR2(40),
  zfbz     CHAR(1),
  zfsj     DATE,
  cr_time  DATE,
  up_time  DATE,
  qrbz     CHAR(1),
  bazt     CHAR(1),
  tjsj     DATE,
  basj     DATE,
  thsj     DATE,
  thyy     VARCHAR2(200),
  qrr_dm   VARCHAR2(20),
  qrsj     DATE
)
;
comment on table YWY_BAXX_LSB
  is '业务员备案历史信息表';
comment on column YWY_BAXX_LSB.id
  is '主键序号';
comment on column YWY_BAXX_LSB.djxh
  is '登记序号';
comment on column YWY_BAXX_LSB.zjlx
  is '证件类型  201居民身份证 208护照 210港澳通行证 213 台湾通行证';
comment on column YWY_BAXX_LSB.zjhm
  is '证件号码';
comment on column YWY_BAXX_LSB.xm
  is '姓名';
comment on column YWY_BAXX_LSB.sex
  is '性别    1男   2女';
comment on column YWY_BAXX_LSB.phone
  is '手机';
comment on column YWY_BAXX_LSB.status
  is '业务员状态   1在职  0离职';
comment on column YWY_BAXX_LSB.gzrq_q
  is '工作日期起';
comment on column YWY_BAXX_LSB.gzrq_z
  is '工作日期止';
comment on column YWY_BAXX_LSB.ckcpfw
  is '出口产品范围';
comment on column YWY_BAXX_LSB.sfqdldht
  is '是否签订劳动合同   Y是  N 否';
comment on column YWY_BAXX_LSB.sfdjsb
  is '是否代缴社保  Y是  N 否';
comment on column YWY_BAXX_LSB.ywyly
  is '业务员来源   1他人介绍    2招聘   3企业法人/投资方/实际管理人   4其他';
comment on column YWY_BAXX_LSB.qtlyms
  is '其他来源描述';
comment on column YWY_BAXX_LSB.zj_hash
  is '证件照片-哈希值';
comment on column YWY_BAXX_LSB.zfbz
  is '作废标志   Y已作废，N未作废';
comment on column YWY_BAXX_LSB.zfsj
  is '作废时间';
comment on column YWY_BAXX_LSB.cr_time
  is '创建时间';
comment on column YWY_BAXX_LSB.up_time
  is '修改时间';
comment on column YWY_BAXX_LSB.qrbz
  is '需确认标记  0无需确认  1需税务端确认';
comment on column YWY_BAXX_LSB.bazt
  is '备案状态  0未备案   1备案中（税务端待确认） 2已备案（税务端已确认）3备案退回';
comment on column YWY_BAXX_LSB.tjsj
  is '提交时间';
comment on column YWY_BAXX_LSB.basj
  is '备案时间';
comment on column YWY_BAXX_LSB.thsj
  is '退回时间';
comment on column YWY_BAXX_LSB.thyy
  is '退回原因';
comment on column YWY_BAXX_LSB.qrr_dm
  is '确认人代码';
comment on column YWY_BAXX_LSB.qrsj
  is '确认时间';
alter table YWY_BAXX_LSB
  add constraint PK_YWY_BAXX_LSB primary key (ID);

prompt
prompt Creating table YWY_BAXX_SFZJ
prompt ============================
prompt
create table YWY_BAXX_SFZJ
(
  ywy_id  NUMBER(20) not null,
  txgs    VARCHAR2(10),
  up_time DATE,
  sfzjnr  BLOB
)
;
alter table YWY_BAXX_SFZJ
  add primary key (YWY_ID);

prompt
prompt Creating table YWY_FXMC
prompt =======================
prompt
create table YWY_FXMC
(
  id      NUMBER(20) not null,
  swjg_dm VARCHAR2(11),
  zjhm    VARCHAR2(30),
  xm      VARCHAR2(50),
  fxlx    CHAR(1),
  fxqkms  VARCHAR2(4000),
  lrr_dm  VARCHAR2(20),
  lrsj    DATE,
  yxbz    CHAR(1)
)
;
comment on table YWY_FXMC
  is '风险业务员名册';
comment on column YWY_FXMC.id
  is '序号（主键）';
comment on column YWY_FXMC.swjg_dm
  is '录入税务机关';
comment on column YWY_FXMC.zjhm
  is '证件号码';
comment on column YWY_FXMC.xm
  is '姓名';
comment on column YWY_FXMC.fxlx
  is '风险类型   1 骗税、2 违规退税、3 出口风险商品、4 其他';
comment on column YWY_FXMC.fxqkms
  is '风险情况描述';
comment on column YWY_FXMC.lrr_dm
  is '录入人代码';
comment on column YWY_FXMC.lrsj
  is '录入时间';
comment on column YWY_FXMC.yxbz
  is '有效标志     Y/N';
create index IDX_YWY_FXMC on YWY_FXMC (ZJHM);
alter table YWY_FXMC
  add constraint PK_YWY_FXMC primary key (ID);

prompt
prompt Creating table YWY_TJGXXX
prompt =========================
prompt
create table YWY_TJGXXX
(
  zjhm   VARCHAR2(30) not null,
  sjqyhs INTEGER not null,
  tjsj   DATE
)
;
comment on table YWY_TJGXXX
  is '业务员统计共享信息表';
comment on column YWY_TJGXXX.zjhm
  is '证件号码';
comment on column YWY_TJGXXX.sjqyhs
  is '涉及企业户数';
comment on column YWY_TJGXXX.tjsj
  is '统计时间';
alter table YWY_TJGXXX
  add constraint PK_YWY_TJGXXX primary key (ZJHM);


prompt Done
set define on
