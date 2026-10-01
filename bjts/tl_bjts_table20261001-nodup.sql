set define off

prompt
prompt Creating table BJTS_TASK
prompt ========================
prompt
create table BJTS_TASK
(
  id     NUMBER(18) not null,
  nsrsbh VARCHAR2(20) not null,
  type   CHAR(3) not null,
  name   VARCHAR2(50),
  hash   VARCHAR2(50) not null,
  status CHAR(1) default 0 not null,
  tqbz   VARCHAR2(32),
  tqsj   TIMESTAMP(6) default sysdate,
  tqcs   NUMBER(6) default 0,
  qqcs   NUMBER(6) default 0,
  zjfwsj TIMESTAMP(6),
  cjsj   TIMESTAMP(6) default sysdate,
  xgsj   TIMESTAMP(6),
  bz     VARCHAR2(500),
  qqbw   CLOB,
  xybw   CLOB,
  bwgs   VARCHAR2(5)
)
;
comment on table BJTS_TASK
  is '便捷退税-任务表';
comment on column BJTS_TASK.id
  is '主键';
comment on column BJTS_TASK.nsrsbh
  is '纳税人识别号';
comment on column BJTS_TASK.type
  is '任务类型(操作类型)001-准入，002-贷中';
comment on column BJTS_TASK.name
  is '任务名称';
comment on column BJTS_TASK.hash
  is '任务hash  nsrsbh+czny_type';
comment on column BJTS_TASK.status
  is '任务状态 (0:待处理 1:处理中 2:处理失败   9:处理完毕)';
comment on column BJTS_TASK.tqbz
  is '提取标志';
comment on column BJTS_TASK.tqsj
  is '提取时间';
comment on column BJTS_TASK.tqcs
  is '提取次数';
comment on column BJTS_TASK.qqcs
  is '请求次数';
comment on column BJTS_TASK.zjfwsj
  is '最近访问时间';
comment on column BJTS_TASK.cjsj
  is '创建时间';
comment on column BJTS_TASK.xgsj
  is '修改时间';
comment on column BJTS_TASK.bz
  is '备注';
comment on column BJTS_TASK.qqbw
  is '请求报文，json格式存储';
comment on column BJTS_TASK.xybw
  is '响应报文，根据bwgs确定';
comment on column BJTS_TASK.bwgs
  is 'zip：对json格式进行压缩，json等格式';
create index IDX_BJTS_TASK_NT on BJTS_TASK (NSRSBH, TYPE);
create unique index UK_BJTS_TASK_HASH on BJTS_TASK (HASH);
alter table BJTS_TASK
  add constraint PK_BJTS_TASK primary key (ID);

prompt
prompt Creating table BJTS_TASK_HIS
prompt ============================
prompt
create table BJTS_TASK_HIS
(
  id     NUMBER(18) not null,
  nsrsbh VARCHAR2(20) not null,
  type   CHAR(3) not null,
  name   VARCHAR2(50),
  hash   VARCHAR2(50) not null,
  status CHAR(1) default 0 not null,
  tqbz   VARCHAR2(32),
  tqsj   TIMESTAMP(6) default sysdate,
  tqcs   NUMBER(6) default 0,
  qqcs   NUMBER(6) default 0,
  zjfwsj TIMESTAMP(6),
  cjsj   TIMESTAMP(6) default sysdate,
  xgsj   TIMESTAMP(6),
  bz     VARCHAR2(500),
  qqbw   CLOB,
  xybw   CLOB,
  bwgs   VARCHAR2(5)
)
;
comment on table BJTS_TASK_HIS
  is '便捷退税-历史任务表';
comment on column BJTS_TASK_HIS.id
  is '主键';
comment on column BJTS_TASK_HIS.nsrsbh
  is '纳税人识别号';
comment on column BJTS_TASK_HIS.type
  is '任务类型(操作类型)001-准入，002-贷中';
comment on column BJTS_TASK_HIS.name
  is '任务名称';
comment on column BJTS_TASK_HIS.hash
  is '任务hash  nsrsbh+czny_type';
comment on column BJTS_TASK_HIS.status
  is '任务状态 (0:待处理 1:处理中 2:处理失败   9:处理完毕)';
comment on column BJTS_TASK_HIS.tqbz
  is '提取标志';
comment on column BJTS_TASK_HIS.tqsj
  is '提取时间';
comment on column BJTS_TASK_HIS.tqcs
  is '提取次数';
comment on column BJTS_TASK_HIS.qqcs
  is '请求次数';
comment on column BJTS_TASK_HIS.zjfwsj
  is '最近访问时间';
comment on column BJTS_TASK_HIS.cjsj
  is '创建时间';
comment on column BJTS_TASK_HIS.xgsj
  is '修改时间';
comment on column BJTS_TASK_HIS.bz
  is '备注';
comment on column BJTS_TASK_HIS.qqbw
  is '请求报文，json格式存储';
comment on column BJTS_TASK_HIS.xybw
  is '响应报文，根据bwgs确定';
comment on column BJTS_TASK_HIS.bwgs
  is 'zip：对json格式进行压缩，json等格式';
alter table BJTS_TASK_HIS
  add constraint PK_BJTS_TASK_HIS primary key (ID);

prompt
prompt Creating table CALL_PROC_RET
prompt ============================
prompt
create table CALL_PROC_RET
(
  id        NUMBER(18) not null,
  ls_code   VARCHAR2(20),
  ls_msg    VARCHAR2(500),
  call_time DATE,
  note      VARCHAR2(500),
  up_time   DATE,
  sbid      NUMBER(18)
)
;
comment on table CALL_PROC_RET
  is '调用存储过程反馈表';
comment on column CALL_PROC_RET.ls_code
  is '调用存储过程返回代码';
comment on column CALL_PROC_RET.ls_msg
  is '调用存储过程返回信息';
comment on column CALL_PROC_RET.call_time
  is '调用时间';
comment on column CALL_PROC_RET.note
  is '备注';
comment on column CALL_PROC_RET.up_time
  is '修改时间';
comment on column CALL_PROC_RET.sbid
  is '对应sb_sbxx_hz表id';
alter table CALL_PROC_RET
  add constraint PK_CALL_PROC_RET primary key (ID);

prompt
prompt Creating table CKTS_BA_BABGQK_LSB
prompt =================================
prompt
create table CKTS_BA_BABGQK_LSB
(
  sbid        NUMBER(18),
  qyhgdm      VARCHAR2(20),
  ssq         VARCHAR2(60),
  sbpc        VARCHAR2(75),
  djxh        NUMBER(20),
  tbrq_1      DATE,
  babgzd_dm   VARCHAR2(30),
  babgzdmc    VARCHAR2(150),
  bgq         VARCHAR2(3000),
  bgh         VARCHAR2(3000),
  bz          VARCHAR2(3000),
  tsswjg_dm_1 CHAR(11),
  lrrq        DATE,
  lrr_dm      CHAR(11),
  xgrq        DATE,
  xgr_dm      CHAR(11),
  sjgsdq      CHAR(11),
  sjtb_sj     TIMESTAMP(6)
)
;
comment on table CKTS_BA_BABGQK_LSB
  is '出口企业委备案变更临时表';
comment on column CKTS_BA_BABGQK_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_BA_BABGQK_LSB.qyhgdm
  is '企业海关代码';
comment on column CKTS_BA_BABGQK_LSB.ssq
  is '所属期';
comment on column CKTS_BA_BABGQK_LSB.sbpc
  is '申报批次';
comment on column CKTS_BA_BABGQK_LSB.djxh
  is '登记序号';
comment on column CKTS_BA_BABGQK_LSB.tbrq_1
  is '填表日期';
comment on column CKTS_BA_BABGQK_LSB.babgzd_dm
  is '变更字段';
comment on column CKTS_BA_BABGQK_LSB.babgzdmc
  is '变更字段说明';
comment on column CKTS_BA_BABGQK_LSB.bgq
  is '变更前内容';
comment on column CKTS_BA_BABGQK_LSB.bgh
  is '变更后内容';
comment on column CKTS_BA_BABGQK_LSB.bz
  is '备注';
comment on column CKTS_BA_BABGQK_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_BA_BABGQK_LSB.lrrq
  is '录入日期';
comment on column CKTS_BA_BABGQK_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_BA_BABGQK_LSB.xgrq
  is '修改日期';
comment on column CKTS_BA_BABGQK_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_BA_BABGQK_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_BA_BABGQK_LSB.sjtb_sj
  is '数据同步时间';
create index IDX_CKTS_BA_BABGQK_LSB_1 on CKTS_BA_BABGQK_LSB (SBID);
create index IDX_CKTS_BA_BABGQK_LSB_2 on CKTS_BA_BABGQK_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_BA_SCQYWTDBTS_LSB
prompt =====================================
prompt
create table CKTS_BA_SCQYWTDBTS_LSB
(
  sbid           NUMBER(18),
  qyhgdm         VARCHAR2(20),
  ssq            VARCHAR2(60),
  sbpc           VARCHAR2(75),
  djxh           NUMBER(20),
  sbxh           VARCHAR2(50),
  xh             NUMBER(8),
  wmzhfwqynsrmc  VARCHAR2(300),
  wmzhfwqyhgqydm VARCHAR2(50),
  wmzhfwqynsrsbh VARCHAR2(20),
  wmzhfwqyshxydm VARCHAR2(20),
  wmzhfwhtxyhm   VARCHAR2(60),
  tskhyhmc       VARCHAR2(120),
  tskhyhzh       VARCHAR2(50),
  fddbrxm        VARCHAR2(150),
  dbtsbalczt_dm  CHAR(1),
  tsswjg_dm_1    CHAR(11),
  lrrq           DATE,
  lrr_dm         CHAR(11),
  xgrq           DATE,
  xgr_dm         CHAR(11),
  sjgsdq         CHAR(11),
  sjtb_sj        TIMESTAMP(6),
  tbrq_1         DATE
)
;
comment on table CKTS_BA_SCQYWTDBTS_LSB
  is '生产企业委托代办退税备案临时表';
comment on column CKTS_BA_SCQYWTDBTS_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_BA_SCQYWTDBTS_LSB.qyhgdm
  is '企业海关代码';
comment on column CKTS_BA_SCQYWTDBTS_LSB.ssq
  is '所属期';
comment on column CKTS_BA_SCQYWTDBTS_LSB.sbpc
  is '申报批次';
comment on column CKTS_BA_SCQYWTDBTS_LSB.djxh
  is '登记序号';
comment on column CKTS_BA_SCQYWTDBTS_LSB.sbxh
  is '申报序号';
comment on column CKTS_BA_SCQYWTDBTS_LSB.xh
  is '序号';
comment on column CKTS_BA_SCQYWTDBTS_LSB.wmzhfwqynsrmc
  is '外贸综合服务企业纳税人名称';
comment on column CKTS_BA_SCQYWTDBTS_LSB.wmzhfwqyhgqydm
  is '外贸综合服务企业海关企业代码';
comment on column CKTS_BA_SCQYWTDBTS_LSB.wmzhfwqynsrsbh
  is '外贸综合服务企业纳税人识别号';
comment on column CKTS_BA_SCQYWTDBTS_LSB.wmzhfwqyshxydm
  is '外贸综合服务企业社会信用代码';
comment on column CKTS_BA_SCQYWTDBTS_LSB.wmzhfwhtxyhm
  is '外贸综合服务合同（协议）号码';
comment on column CKTS_BA_SCQYWTDBTS_LSB.tskhyhmc
  is '退税开户银行名称';
comment on column CKTS_BA_SCQYWTDBTS_LSB.tskhyhzh
  is '退税开户银行账号';
comment on column CKTS_BA_SCQYWTDBTS_LSB.fddbrxm
  is '法定代表人姓名';
comment on column CKTS_BA_SCQYWTDBTS_LSB.dbtsbalczt_dm
  is '代办退税备案流程状态代码';
comment on column CKTS_BA_SCQYWTDBTS_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_BA_SCQYWTDBTS_LSB.lrrq
  is '录入日期';
comment on column CKTS_BA_SCQYWTDBTS_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_BA_SCQYWTDBTS_LSB.xgrq
  is '修改日期';
comment on column CKTS_BA_SCQYWTDBTS_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_BA_SCQYWTDBTS_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_BA_SCQYWTDBTS_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_BA_SCQYWTDBTS_LSB.tbrq_1
  is '填表日期';
create index IDX_CKTS_BA_SCQYWTDBTS_LSB_1 on CKTS_BA_SCQYWTDBTS_LSB (SBID);
create index IDX_CKTS_BA_SCQYWTDBTS_LSB_2 on CKTS_BA_SCQYWTDBTS_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_BA_WMZHFWDBTS_LSB
prompt =====================================
prompt
create table CKTS_BA_WMZHFWDBTS_LSB
(
  sbid                 NUMBER(18),
  qyhgdm               VARCHAR2(20),
  ssq                  VARCHAR2(60),
  sbpc                 VARCHAR2(75),
  djxh                 NUMBER(20),
  sbxh                 VARCHAR2(50),
  xh                   NUMBER(8),
  wtdbtsscqynsrmc      VARCHAR2(300),
  wtdbtsscqyhgqydm     VARCHAR2(50),
  wtdbtsscqynsrsbh     VARCHAR2(20),
  wtdbtsscqyshxydm     VARCHAR2(20),
  wmzhfwhtxyhm         VARCHAR2(60),
  wtdbtsscqydbtskhyhmc VARCHAR2(120),
  wtdbtsscqydbtskhyhzh VARCHAR2(50),
  fddbrxm              VARCHAR2(150),
  dbtsbalczt_dm        CHAR(1),
  tsswjg_dm_1          CHAR(11),
  lrrq                 DATE,
  lrr_dm               CHAR(11),
  xgrq                 DATE,
  xgr_dm               CHAR(11),
  sjgsdq               CHAR(11),
  sjtb_sj              TIMESTAMP(6),
  tbrq_1               DATE,
  tskhyhmc             VARCHAR2(120),
  tskhyhzh             VARCHAR2(50)
)
;
comment on table CKTS_BA_WMZHFWDBTS_LSB
  is '外贸综合服务代办退税备案临时表';
comment on column CKTS_BA_WMZHFWDBTS_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_BA_WMZHFWDBTS_LSB.qyhgdm
  is '企业海关代码';
comment on column CKTS_BA_WMZHFWDBTS_LSB.ssq
  is '所属期';
comment on column CKTS_BA_WMZHFWDBTS_LSB.sbpc
  is '申报批次';
comment on column CKTS_BA_WMZHFWDBTS_LSB.djxh
  is '登记序号';
comment on column CKTS_BA_WMZHFWDBTS_LSB.sbxh
  is '申报序号';
comment on column CKTS_BA_WMZHFWDBTS_LSB.xh
  is '序号';
comment on column CKTS_BA_WMZHFWDBTS_LSB.wtdbtsscqynsrmc
  is '委托代办退税生产企业纳税人名称';
comment on column CKTS_BA_WMZHFWDBTS_LSB.wtdbtsscqyhgqydm
  is '委托代办退税生产企业海关企业代码';
comment on column CKTS_BA_WMZHFWDBTS_LSB.wtdbtsscqynsrsbh
  is '委托代办退税生产企业纳税人识别号';
comment on column CKTS_BA_WMZHFWDBTS_LSB.wtdbtsscqyshxydm
  is '委托代办退税生产企业社会信用代码';
comment on column CKTS_BA_WMZHFWDBTS_LSB.wmzhfwhtxyhm
  is '外贸综合服务合同（协议）号码';
comment on column CKTS_BA_WMZHFWDBTS_LSB.wtdbtsscqydbtskhyhmc
  is '委托代办退税生产企业代办退税开户银行名称';
comment on column CKTS_BA_WMZHFWDBTS_LSB.wtdbtsscqydbtskhyhzh
  is '委托代办退税生产企业代办退税开户银行账号';
comment on column CKTS_BA_WMZHFWDBTS_LSB.fddbrxm
  is '法定代表人姓名';
comment on column CKTS_BA_WMZHFWDBTS_LSB.dbtsbalczt_dm
  is '代办退税备案流程状态代码';
comment on column CKTS_BA_WMZHFWDBTS_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_BA_WMZHFWDBTS_LSB.lrrq
  is '录入日期';
comment on column CKTS_BA_WMZHFWDBTS_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_BA_WMZHFWDBTS_LSB.xgrq
  is '修改日期';
comment on column CKTS_BA_WMZHFWDBTS_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_BA_WMZHFWDBTS_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_BA_WMZHFWDBTS_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_BA_WMZHFWDBTS_LSB.tbrq_1
  is '填表日期';
comment on column CKTS_BA_WMZHFWDBTS_LSB.tskhyhmc
  is '退税开户银行名称';
comment on column CKTS_BA_WMZHFWDBTS_LSB.tskhyhzh
  is '退税开户银行账号';
create index IDX_CKTS_BA_WMZHFWDBTS_LSB_1 on CKTS_BA_WMZHFWDBTS_LSB (SBID);
create index IDX_CKTS_BA_WMZHFWDBTS_LSB_2 on CKTS_BA_WMZHFWDBTS_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_DM_FPHCJG
prompt =============================
prompt
create table CKTS_DM_FPHCJG
(
  fphcjg_dm CHAR(6) not null,
  fphcjgmc  VARCHAR2(150) not null,
  yxbz      CHAR(1) not null,
  xybz      CHAR(1) not null
)
;
comment on table CKTS_DM_FPHCJG
  is '发票核查结果代码';
comment on column CKTS_DM_FPHCJG.fphcjg_dm
  is '发票核查结果代码';
comment on column CKTS_DM_FPHCJG.fphcjgmc
  is '发票核查结果名称';
comment on column CKTS_DM_FPHCJG.yxbz
  is '有效标志';
comment on column CKTS_DM_FPHCJG.xybz
  is '选用标志';
alter table CKTS_DM_FPHCJG
  add constraint PK_CKTS_DM_FPHCJG primary key (FPHCJG_DM);

prompt
prompt Creating table CKTS_DM_GJYSFW
prompt =============================
prompt
create table CKTS_DM_GJYSFW
(
  gjysfwdm CHAR(2) not null,
  gjysfwjc VARCHAR2(20) not null,
  gjysfwmc VARCHAR2(75) not null,
  gjysfwsm VARCHAR2(200) not null,
  yxbz     CHAR(1) not null,
  xybz     CHAR(1) not null
)
;
comment on table CKTS_DM_GJYSFW
  is '研发设计服务代码';
comment on column CKTS_DM_GJYSFW.gjysfwdm
  is '研发设计服务代码';
comment on column CKTS_DM_GJYSFW.gjysfwjc
  is '研发设计服务简称';
comment on column CKTS_DM_GJYSFW.gjysfwmc
  is '研发设计服务名称';
comment on column CKTS_DM_GJYSFW.gjysfwsm
  is '研发设计服务说明';
comment on column CKTS_DM_GJYSFW.yxbz
  is '有效标志';
comment on column CKTS_DM_GJYSFW.xybz
  is '选用标志';
alter table CKTS_DM_GJYSFW
  add constraint PK_CKTS_DM_GJYSFW primary key (GJYSFWDM);

prompt
prompt Creating table CKTS_DM_HGJGFS
prompt =============================
prompt
create table CKTS_DM_HGJGFS
(
  jgfs_dm     CHAR(4) not null,
  jgfsmc      VARCHAR2(150) not null,
  jgfsqc      VARCHAR2(300) not null,
  jgfssm      VARCHAR2(4000),
  jgfstslx_dm CHAR(1) not null,
  yxbz        CHAR(1) not null,
  xybz        CHAR(1) not null
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
comment on column CKTS_DM_HGJGFS.jgfssm
  is '监管方式说明';
comment on column CKTS_DM_HGJGFS.jgfstslx_dm
  is '监管方式退税类型代码';
comment on column CKTS_DM_HGJGFS.yxbz
  is '有效标志';
comment on column CKTS_DM_HGJGFS.xybz
  is '选用标志';
alter table CKTS_DM_HGJGFS
  add constraint PK_CKTS_DM_HGJGFS primary key (JGFS_DM);

prompt
prompt Creating table CKTS_DM_HGJLDW
prompt =============================
prompt
create table CKTS_DM_HGJLDW
(
  hgjldw_dm VARCHAR2(3) not null,
  hgjldwmc  VARCHAR2(75) not null,
  hgjldwqc  VARCHAR2(300) not null,
  yxbz      CHAR(1) not null,
  xybz      CHAR(1) not null
)
;
comment on table CKTS_DM_HGJLDW
  is '海关计量单位代码';
comment on column CKTS_DM_HGJLDW.hgjldw_dm
  is '海关计量单位代码';
comment on column CKTS_DM_HGJLDW.hgjldwmc
  is '海关计量单位名称';
comment on column CKTS_DM_HGJLDW.hgjldwqc
  is '海关计量单位全称';
comment on column CKTS_DM_HGJLDW.yxbz
  is '有效标志';
comment on column CKTS_DM_HGJLDW.xybz
  is '选用标志';
alter table CKTS_DM_HGJLDW
  add constraint PK_CKTS_DM_HGJLDW primary key (HGJLDW_DM);

prompt
prompt Creating table CKTS_DM_TSLVTZ
prompt =============================
prompt
create table CKTS_DM_TSLVTZ
(
  uuid    VARCHAR2(32) not null,
  cksp_dm VARCHAR2(20),
  ckspmc  VARCHAR2(75),
  zcyj    VARCHAR2(4000),
  kssj    DATE,
  jssj    DATE,
  tsl     NUMBER(16,6),
  zssl    NUMBER(16,6),
  kpqsrq  DATE,
  kpjzrq  DATE,
  tzhtsl  NUMBER(16,6),
  yxbz    CHAR(1) not null,
  xybz    CHAR(1) not null,
  lrrq    DATE not null,
  lrr_dm  CHAR(11) not null,
  xgrq    DATE,
  xgr_dm  CHAR(11)
)
;
comment on table CKTS_DM_TSLVTZ
  is '出口商品退税率调整表';
comment on column CKTS_DM_TSLVTZ.uuid
  is 'UUID||uuid';
comment on column CKTS_DM_TSLVTZ.cksp_dm
  is '出口商品代码';
comment on column CKTS_DM_TSLVTZ.ckspmc
  is '出口商品名称';
comment on column CKTS_DM_TSLVTZ.zcyj
  is '政策依据';
comment on column CKTS_DM_TSLVTZ.kssj
  is '开始时间';
comment on column CKTS_DM_TSLVTZ.jssj
  is '结束时间';
comment on column CKTS_DM_TSLVTZ.tsl
  is '退税率';
comment on column CKTS_DM_TSLVTZ.zssl
  is '征税税率';
comment on column CKTS_DM_TSLVTZ.kpqsrq
  is '开票起始日期';
comment on column CKTS_DM_TSLVTZ.kpjzrq
  is '开票截止日期';
comment on column CKTS_DM_TSLVTZ.tzhtsl
  is '调整后退税率';
comment on column CKTS_DM_TSLVTZ.yxbz
  is '有效标志';
comment on column CKTS_DM_TSLVTZ.xybz
  is '选用标志';
comment on column CKTS_DM_TSLVTZ.lrrq
  is '录入日期';
comment on column CKTS_DM_TSLVTZ.lrr_dm
  is '录入人代码';
comment on column CKTS_DM_TSLVTZ.xgrq
  is '修改日期';
comment on column CKTS_DM_TSLVTZ.xgr_dm
  is '修改人代码';
create index IDX_CKTS_DM_TSLVTZ_CQZ on CKTS_DM_TSLVTZ (CKSP_DM, KSSJ, JSSJ);
alter table CKTS_DM_TSLVTZ
  add constraint PK_CKTS_DM_TSLVTZ primary key (UUID);

prompt
prompt Creating table CKTS_DM_TSLVWK
prompt =============================
prompt
create table CKTS_DM_TSLVWK
(
  uuid          VARCHAR2(32) not null,
  cksp_dm       VARCHAR2(20),
  yxqq          DATE,
  yxqz          DATE,
  zhcksp_dm     VARCHAR2(20),
  ckspmc        VARCHAR2(75),
  hgjldw_dm     VARCHAR2(3),
  hgjldwmc      VARCHAR2(75),
  jbspbz        CHAR(1),
  bzspbz        CHAR(1),
  bzdwbz        CHAR(1),
  sz            CHAR(1),
  zssljh        VARCHAR2(10),
  cldezs        NUMBER(16,4),
  cjdlzs        NUMBER(16,4),
  tsl           NUMBER(16,6),
  splb          CHAR(2),
  yxbz          CHAR(1),
  xybz          CHAR(1),
  lrrq          DATE not null,
  lrr_dm        CHAR(11) not null,
  xgrq          DATE,
  xgr_dm        CHAR(11),
  cksptssplx_dm CHAR(1),
  bz            VARCHAR2(3000),
  spdmkbb       VARCHAR2(75),
  zssl          NUMBER(16,6)
)
;
comment on table CKTS_DM_TSLVWK
  is '出口商品退税率文库';
comment on column CKTS_DM_TSLVWK.uuid
  is 'UUID||uuid';
comment on column CKTS_DM_TSLVWK.cksp_dm
  is '出口商品代码';
comment on column CKTS_DM_TSLVWK.yxqq
  is '有效期起';
comment on column CKTS_DM_TSLVWK.yxqz
  is '有效期止';
comment on column CKTS_DM_TSLVWK.zhcksp_dm
  is '转换出口商品代码';
comment on column CKTS_DM_TSLVWK.ckspmc
  is '出口商品名称';
comment on column CKTS_DM_TSLVWK.hgjldw_dm
  is '海关计量单位代码';
comment on column CKTS_DM_TSLVWK.hgjldwmc
  is '海关计量单位名称';
comment on column CKTS_DM_TSLVWK.jbspbz
  is '基本商品标志';
comment on column CKTS_DM_TSLVWK.bzspbz
  is '标准商品标志';
comment on column CKTS_DM_TSLVWK.bzdwbz
  is '标准单位标志';
comment on column CKTS_DM_TSLVWK.sz
  is '税种';
comment on column CKTS_DM_TSLVWK.zssljh
  is '征税税率集合';
comment on column CKTS_DM_TSLVWK.cldezs
  is '从量定额征税';
comment on column CKTS_DM_TSLVWK.cjdlzs
  is '从价定率征税';
comment on column CKTS_DM_TSLVWK.tsl
  is '退税率';
comment on column CKTS_DM_TSLVWK.splb
  is '商品类别';
comment on column CKTS_DM_TSLVWK.yxbz
  is '有效标志';
comment on column CKTS_DM_TSLVWK.xybz
  is '选用标志';
comment on column CKTS_DM_TSLVWK.lrrq
  is '录入日期';
comment on column CKTS_DM_TSLVWK.lrr_dm
  is '录入人代码';
comment on column CKTS_DM_TSLVWK.xgrq
  is '修改日期';
comment on column CKTS_DM_TSLVWK.xgr_dm
  is '修改人代码';
comment on column CKTS_DM_TSLVWK.cksptssplx_dm
  is '出口商品特殊商品类型代码';
comment on column CKTS_DM_TSLVWK.bz
  is '备注';
comment on column CKTS_DM_TSLVWK.spdmkbb
  is '商品代码库版本';
comment on column CKTS_DM_TSLVWK.zssl
  is '征税税率';
create index IDX_CKTS_DM_TSLVWK_CQZ on CKTS_DM_TSLVWK (CKSP_DM, YXQQ, YXQZ);
alter table CKTS_DM_TSLVWK
  add constraint PK_CKTS_DM_TSLVWK primary key (UUID);

prompt
prompt Creating table CKTS_DM_TSLVWK_2026A
prompt ===================================
prompt
create table CKTS_DM_TSLVWK_2026A
(
  uuid          VARCHAR2(32) not null,
  cksp_dm       VARCHAR2(20),
  yxqq          DATE,
  yxqz          DATE,
  zhcksp_dm     VARCHAR2(20),
  ckspmc        VARCHAR2(75),
  hgjldw_dm     VARCHAR2(3),
  hgjldwmc      VARCHAR2(75),
  jbspbz        CHAR(1),
  bzspbz        CHAR(1),
  bzdwbz        CHAR(1),
  sz            CHAR(1),
  zssljh        VARCHAR2(10),
  cldezs        NUMBER(16,4),
  cjdlzs        NUMBER(16,4),
  tsl           NUMBER(16,6),
  splb          CHAR(2),
  yxbz          CHAR(1),
  xybz          CHAR(1),
  lrrq          DATE not null,
  lrr_dm        CHAR(11) not null,
  xgrq          DATE,
  xgr_dm        CHAR(11),
  cksptssplx_dm CHAR(1),
  bz            VARCHAR2(3000),
  spdmkbb       VARCHAR2(75),
  zssl          NUMBER(16,6)
)
;
comment on table CKTS_DM_TSLVWK_2026A
  is '出口商品退税率文库';
comment on column CKTS_DM_TSLVWK_2026A.uuid
  is 'UUID||uuid';
comment on column CKTS_DM_TSLVWK_2026A.cksp_dm
  is '出口商品代码';
comment on column CKTS_DM_TSLVWK_2026A.yxqq
  is '有效期起';
comment on column CKTS_DM_TSLVWK_2026A.yxqz
  is '有效期止';
comment on column CKTS_DM_TSLVWK_2026A.zhcksp_dm
  is '转换出口商品代码';
comment on column CKTS_DM_TSLVWK_2026A.ckspmc
  is '出口商品名称';
comment on column CKTS_DM_TSLVWK_2026A.hgjldw_dm
  is '海关计量单位代码';
comment on column CKTS_DM_TSLVWK_2026A.hgjldwmc
  is '海关计量单位名称';
comment on column CKTS_DM_TSLVWK_2026A.jbspbz
  is '基本商品标志';
comment on column CKTS_DM_TSLVWK_2026A.bzspbz
  is '标准商品标志';
comment on column CKTS_DM_TSLVWK_2026A.bzdwbz
  is '标准单位标志';
comment on column CKTS_DM_TSLVWK_2026A.sz
  is '税种';
comment on column CKTS_DM_TSLVWK_2026A.zssljh
  is '征税税率集合';
comment on column CKTS_DM_TSLVWK_2026A.cldezs
  is '从量定额征税';
comment on column CKTS_DM_TSLVWK_2026A.cjdlzs
  is '从价定率征税';
comment on column CKTS_DM_TSLVWK_2026A.tsl
  is '退税率';
comment on column CKTS_DM_TSLVWK_2026A.splb
  is '商品类别';
comment on column CKTS_DM_TSLVWK_2026A.yxbz
  is '有效标志';
comment on column CKTS_DM_TSLVWK_2026A.xybz
  is '选用标志';
comment on column CKTS_DM_TSLVWK_2026A.lrrq
  is '录入日期';
comment on column CKTS_DM_TSLVWK_2026A.lrr_dm
  is '录入人代码';
comment on column CKTS_DM_TSLVWK_2026A.xgrq
  is '修改日期';
comment on column CKTS_DM_TSLVWK_2026A.xgr_dm
  is '修改人代码';
comment on column CKTS_DM_TSLVWK_2026A.cksptssplx_dm
  is '出口商品特殊商品类型代码';
comment on column CKTS_DM_TSLVWK_2026A.bz
  is '备注';
comment on column CKTS_DM_TSLVWK_2026A.spdmkbb
  is '商品代码库版本';
comment on column CKTS_DM_TSLVWK_2026A.zssl
  is '征税税率';
create index IDX_CKTS_DM_TSLVWK_2026A_CQZ on CKTS_DM_TSLVWK_2026A (CKSP_DM, YXQQ, YXQZ);
alter table CKTS_DM_TSLVWK_2026A
  add constraint PK_CKTS_DM_TSLVWK_2026A primary key (UUID);

prompt
prompt Creating table CKTS_DM_XCJG
prompt ===========================
prompt
create table CKTS_DM_XCJG
(
  xcjg_dm CHAR(6) not null,
  xcjgmc  VARCHAR2(75) not null,
  yxbz    CHAR(1) not null,
  xybz    CHAR(1) not null
)
;
comment on table CKTS_DM_XCJG
  is '协查结果代码';
comment on column CKTS_DM_XCJG.xcjg_dm
  is '协查结果代码';
comment on column CKTS_DM_XCJG.xcjgmc
  is '协查结果名称';
comment on column CKTS_DM_XCJG.yxbz
  is '有效标志';
comment on column CKTS_DM_XCJG.xybz
  is '选用标志';
alter table CKTS_DM_XCJG
  add constraint PK_CKTS_DM_XCJG primary key (XCJG_DM);

prompt
prompt Creating table CKTS_DM_YFSJFW
prompt =============================
prompt
create table CKTS_DM_YFSJFW
(
  yfsjfwdm CHAR(2) not null,
  yfsjfwjc VARCHAR2(20) not null,
  yfsjfwmc VARCHAR2(75) not null,
  yfsjfwsm VARCHAR2(200) not null,
  yxbz     CHAR(1) not null,
  xybz     CHAR(1) not null
)
;
comment on table CKTS_DM_YFSJFW
  is '研发设计服务代码';
comment on column CKTS_DM_YFSJFW.yfsjfwdm
  is '研发设计服务代码';
comment on column CKTS_DM_YFSJFW.yfsjfwjc
  is '研发设计服务简称';
comment on column CKTS_DM_YFSJFW.yfsjfwmc
  is '研发设计服务名称';
comment on column CKTS_DM_YFSJFW.yfsjfwsm
  is '研发设计服务说明';
comment on column CKTS_DM_YFSJFW.yxbz
  is '有效标志';
comment on column CKTS_DM_YFSJFW.xybz
  is '选用标志';
alter table CKTS_DM_YFSJFW
  add constraint PK_CKTS_DM_YFSJFW primary key (YFSJFWDM);

prompt
prompt Creating table CKTS_GCB_ZM_TYYBSWTS
prompt ===================================
prompt
create table CKTS_GCB_ZM_TYYBSWTS
(
  djxh            NUMBER(20) not null,
  lcslid          CHAR(32),
  uuid            VARCHAR2(32) not null,
  cktszmbh        VARCHAR2(20),
  wtfcktszmbh     VARCHAR2(20),
  dlckhwzmhm      VARCHAR2(20),
  ssq             VARCHAR2(60),
  sbxh            VARCHAR2(50),
  ckbgdh          VARCHAR2(21),
  ckrq_1          DATE,
  ckshhxdh        VARCHAR2(30),
  ckfph           VARCHAR2(30),
  cksp_dm         VARCHAR2(20),
  ckspmc          VARCHAR2(75),
  hgjldwmc        VARCHAR2(75),
  cksl            NUMBER(17,5),
  hggqka_dm       CHAR(4),
  yjsje           NUMBER(18,2),
  ysbmdtse        NUMBER(18,6),
  ytzzse_1        NUMBER(18,6),
  ytxfse_1        NUMBER(18,6),
  jhpzh           VARCHAR2(75),
  tysl            NUMBER(17,5),
  tyjsje          NUMBER(18,2),
  ytsl_1          NUMBER(16,6),
  ycjmdtse        NUMBER(18,2),
  cjssq           VARCHAR2(60),
  ybzzse_1        NUMBER(18,6),
  ybxfse_1        NUMBER(18,6),
  jkshm           VARCHAR2(20),
  rkrq            DATE,
  tyybswtstylx_dm CHAR(1),
  ysybs           CHAR(1),
  bz              VARCHAR2(3000),
  tsswjg_dm_1     CHAR(11) not null,
  lrrq            DATE not null,
  lrr_dm          CHAR(11) not null,
  xgrq            DATE,
  xgr_dm          CHAR(11),
  sjgsdq          CHAR(11) not null,
  sjtb_sj         TIMESTAMP(6),
  sbbh_1          VARCHAR2(20),
  xh_4            VARCHAR2(10),
  sbny            CHAR(6),
  ckemy           NUMBER(18,2),
  sbpc            VARCHAR2(75),
  hsjg            VARCHAR2(20),
  sz              CHAR(1),
  tmsztbz         VARCHAR2(50),
  ybjtmsk         NUMBER(18,6),
  ywclfs          VARCHAR2(20),
  kjbz            CHAR(1),
  kjrq            DATE,
  kjr_dm          CHAR(11)
)
;
comment on table CKTS_GCB_ZM_TYYBSWTS
  is '出口货物退运已补税(未退税)证明过程表';
comment on column CKTS_GCB_ZM_TYYBSWTS.djxh
  is '登记序号';
comment on column CKTS_GCB_ZM_TYYBSWTS.lcslid
  is '流程实例ID';
comment on column CKTS_GCB_ZM_TYYBSWTS.uuid
  is 'UUID||uuid';
comment on column CKTS_GCB_ZM_TYYBSWTS.cktszmbh
  is '出口退税证明编号';
comment on column CKTS_GCB_ZM_TYYBSWTS.wtfcktszmbh
  is '委托方出口退税证明编号';
comment on column CKTS_GCB_ZM_TYYBSWTS.dlckhwzmhm
  is '代理出口货物证明号码';
comment on column CKTS_GCB_ZM_TYYBSWTS.ssq
  is '所属期';
comment on column CKTS_GCB_ZM_TYYBSWTS.sbxh
  is '申报序号';
comment on column CKTS_GCB_ZM_TYYBSWTS.ckbgdh
  is '出口报关单号';
comment on column CKTS_GCB_ZM_TYYBSWTS.ckrq_1
  is '出口日期';
comment on column CKTS_GCB_ZM_TYYBSWTS.ckshhxdh
  is '出口收汇核销单号';
comment on column CKTS_GCB_ZM_TYYBSWTS.ckfph
  is '出口发票号';
comment on column CKTS_GCB_ZM_TYYBSWTS.cksp_dm
  is '出口商品代码';
comment on column CKTS_GCB_ZM_TYYBSWTS.ckspmc
  is '出口商品名称';
comment on column CKTS_GCB_ZM_TYYBSWTS.hgjldwmc
  is '海关计量单位名称';
comment on column CKTS_GCB_ZM_TYYBSWTS.cksl
  is '出口数量';
comment on column CKTS_GCB_ZM_TYYBSWTS.hggqka_dm
  is '海关关区（口岸）代码';
comment on column CKTS_GCB_ZM_TYYBSWTS.yjsje
  is '原计税金额';
comment on column CKTS_GCB_ZM_TYYBSWTS.ysbmdtse
  is '原申报免抵退税额';
comment on column CKTS_GCB_ZM_TYYBSWTS.ytzzse_1
  is '原退增值税额';
comment on column CKTS_GCB_ZM_TYYBSWTS.ytxfse_1
  is '原退消费税额';
comment on column CKTS_GCB_ZM_TYYBSWTS.jhpzh
  is '进货凭证号';
comment on column CKTS_GCB_ZM_TYYBSWTS.tysl
  is '退运数量';
comment on column CKTS_GCB_ZM_TYYBSWTS.tyjsje
  is '退运计税金额';
comment on column CKTS_GCB_ZM_TYYBSWTS.ytsl_1
  is '原退税率';
comment on column CKTS_GCB_ZM_TYYBSWTS.ycjmdtse
  is '已冲减免抵退税额||应用于进出口退税';
comment on column CKTS_GCB_ZM_TYYBSWTS.cjssq
  is '冲减所属期';
comment on column CKTS_GCB_ZM_TYYBSWTS.ybzzse_1
  is '已补增值税额';
comment on column CKTS_GCB_ZM_TYYBSWTS.ybxfse_1
  is '已补消费税额';
comment on column CKTS_GCB_ZM_TYYBSWTS.jkshm
  is '缴款书号码';
comment on column CKTS_GCB_ZM_TYYBSWTS.rkrq
  is '入库日期';
comment on column CKTS_GCB_ZM_TYYBSWTS.tyybswtstylx_dm
  is '退运已补税（未退税）退运类型代码';
comment on column CKTS_GCB_ZM_TYYBSWTS.ysybs
  is '已使用标识';
comment on column CKTS_GCB_ZM_TYYBSWTS.bz
  is '备注';
comment on column CKTS_GCB_ZM_TYYBSWTS.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_GCB_ZM_TYYBSWTS.lrrq
  is '录入日期';
comment on column CKTS_GCB_ZM_TYYBSWTS.lrr_dm
  is '录入人代码';
comment on column CKTS_GCB_ZM_TYYBSWTS.xgrq
  is '修改日期';
comment on column CKTS_GCB_ZM_TYYBSWTS.xgr_dm
  is '修改人代码';
comment on column CKTS_GCB_ZM_TYYBSWTS.sjgsdq
  is '数据归属地区';
comment on column CKTS_GCB_ZM_TYYBSWTS.sjtb_sj
  is '数据同步时间';
comment on column CKTS_GCB_ZM_TYYBSWTS.sbbh_1
  is '申报编号';
comment on column CKTS_GCB_ZM_TYYBSWTS.xh_4
  is '项号';
comment on column CKTS_GCB_ZM_TYYBSWTS.sbny
  is '申报年月';
comment on column CKTS_GCB_ZM_TYYBSWTS.ckemy
  is '出口额（美元）';
comment on column CKTS_GCB_ZM_TYYBSWTS.sbpc
  is '申报批次';
comment on column CKTS_GCB_ZM_TYYBSWTS.hsjg
  is '核实结果';
comment on column CKTS_GCB_ZM_TYYBSWTS.sz
  is '税种';
comment on column CKTS_GCB_ZM_TYYBSWTS.tmsztbz
  is '退（免）税状态标志';
comment on column CKTS_GCB_ZM_TYYBSWTS.ybjtmsk
  is '应补缴退（免）税款';
comment on column CKTS_GCB_ZM_TYYBSWTS.ywclfs
  is '业务处理方式';
comment on column CKTS_GCB_ZM_TYYBSWTS.kjbz
  is '开具标志';
comment on column CKTS_GCB_ZM_TYYBSWTS.kjrq
  is '开具日期';
comment on column CKTS_GCB_ZM_TYYBSWTS.kjr_dm
  is '开具人代码';
create index IDX_CKTS_GCB_ZM_TYYBSWTS_D on CKTS_GCB_ZM_TYYBSWTS (DJXH);

prompt
prompt Creating table CKTS_JGB_BA_SCQYWTDBTS
prompt =====================================
prompt
create table CKTS_JGB_BA_SCQYWTDBTS
(
  djxh           NUMBER(20),
  lcslid         CHAR(32),
  uuid           VARCHAR2(32) not null,
  nsrmc          VARCHAR2(300),
  hgqy_dm        VARCHAR2(50),
  nsrsbh         VARCHAR2(20),
  shxydm         VARCHAR2(20),
  wmzhfwqynsrmc  VARCHAR2(300),
  wmzhfwqyhgqydm VARCHAR2(50),
  wmzhfwqynsrsbh VARCHAR2(20),
  wmzhfwqyshxydm VARCHAR2(20),
  wmzhfwhtxyhm   VARCHAR2(60),
  tskhyhmc       VARCHAR2(120),
  tskhyhzh       VARCHAR2(50),
  fddbrxm        VARCHAR2(150),
  dbtsbalczt_dm  CHAR(1),
  tsswjg_dm_1    CHAR(11),
  lrrq           DATE,
  lrr_dm         CHAR(11),
  xgrq           DATE,
  xgr_dm         CHAR(11),
  sjgsdq         CHAR(11),
  sjtb_sj        TIMESTAMP(6),
  bachbz         CHAR(1),
  bachrq         DATE,
  tbrq_1         DATE,
  sbxh           VARCHAR2(50)
)
;
comment on table CKTS_JGB_BA_SCQYWTDBTS
  is '生产企业委托代办退税备案结果表';
comment on column CKTS_JGB_BA_SCQYWTDBTS.djxh
  is '登记序号';
comment on column CKTS_JGB_BA_SCQYWTDBTS.lcslid
  is '流程实例ID';
comment on column CKTS_JGB_BA_SCQYWTDBTS.uuid
  is 'UUID||uuid';
comment on column CKTS_JGB_BA_SCQYWTDBTS.nsrmc
  is '纳税人名称';
comment on column CKTS_JGB_BA_SCQYWTDBTS.hgqy_dm
  is '海关企业代码';
comment on column CKTS_JGB_BA_SCQYWTDBTS.nsrsbh
  is '纳税人识别号';
comment on column CKTS_JGB_BA_SCQYWTDBTS.shxydm
  is '社会信用代码';
comment on column CKTS_JGB_BA_SCQYWTDBTS.wmzhfwqynsrmc
  is '外贸综合服务企业纳税人名称';
comment on column CKTS_JGB_BA_SCQYWTDBTS.wmzhfwqyhgqydm
  is '外贸综合服务企业海关企业代码';
comment on column CKTS_JGB_BA_SCQYWTDBTS.wmzhfwqynsrsbh
  is '外贸综合服务企业纳税人识别号';
comment on column CKTS_JGB_BA_SCQYWTDBTS.wmzhfwqyshxydm
  is '外贸综合服务企业社会信用代码';
comment on column CKTS_JGB_BA_SCQYWTDBTS.wmzhfwhtxyhm
  is '外贸综合服务合同（协议）号码';
comment on column CKTS_JGB_BA_SCQYWTDBTS.tskhyhmc
  is '退税开户银行名称';
comment on column CKTS_JGB_BA_SCQYWTDBTS.tskhyhzh
  is '退税开户银行账号';
comment on column CKTS_JGB_BA_SCQYWTDBTS.fddbrxm
  is '法定代表人姓名';
comment on column CKTS_JGB_BA_SCQYWTDBTS.dbtsbalczt_dm
  is '代办退税备案流程状态代码';
comment on column CKTS_JGB_BA_SCQYWTDBTS.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_JGB_BA_SCQYWTDBTS.lrrq
  is '录入日期';
comment on column CKTS_JGB_BA_SCQYWTDBTS.lrr_dm
  is '录入人代码';
comment on column CKTS_JGB_BA_SCQYWTDBTS.xgrq
  is '修改日期';
comment on column CKTS_JGB_BA_SCQYWTDBTS.xgr_dm
  is '修改人代码';
comment on column CKTS_JGB_BA_SCQYWTDBTS.sjgsdq
  is '数据归属地区';
comment on column CKTS_JGB_BA_SCQYWTDBTS.sjtb_sj
  is '数据同步时间';
comment on column CKTS_JGB_BA_SCQYWTDBTS.bachbz
  is '备案撤回标志||备案撤回标志';
comment on column CKTS_JGB_BA_SCQYWTDBTS.bachrq
  is '备案撤回日期';
comment on column CKTS_JGB_BA_SCQYWTDBTS.tbrq_1
  is '填表日期';
comment on column CKTS_JGB_BA_SCQYWTDBTS.sbxh
  is '申报序号';
create index IDX_CKTS_JGB_BA_SCQYWTDBTS_D on CKTS_JGB_BA_SCQYWTDBTS (DJXH);
create index IDX_CKTS_JGB_BA_SCQYWTDBTS_HG on CKTS_JGB_BA_SCQYWTDBTS (HGQY_DM);
create index IDX_CKTS_JGB_BA_SCQYWTDBTS_WM on CKTS_JGB_BA_SCQYWTDBTS (WMZHFWQYNSRSBH);

prompt
prompt Creating table CKTS_JGB_BA_WMZHFWDBTS
prompt =====================================
prompt
create table CKTS_JGB_BA_WMZHFWDBTS
(
  djxh                 NUMBER(20),
  lcslid               CHAR(32),
  uuid                 VARCHAR2(32) not null,
  nsrmc                VARCHAR2(300),
  hgqy_dm              VARCHAR2(50),
  nsrsbh               VARCHAR2(20),
  shxydm               VARCHAR2(20),
  wtdbtsscqynsrmc      VARCHAR2(300),
  wtdbtsscqyhgqydm     VARCHAR2(50),
  wtdbtsscqynsrsbh     VARCHAR2(20),
  wtdbtsscqyshxydm     VARCHAR2(20),
  wmzhfwhtxyhm         VARCHAR2(60),
  wtdbtsscqydbtskhyhmc VARCHAR2(120),
  wtdbtsscqydbtskhyhzh VARCHAR2(50),
  fddbrxm              VARCHAR2(150),
  dbtsbalczt_dm        CHAR(1),
  tsswjg_dm_1          CHAR(11),
  lrrq                 DATE,
  lrr_dm               CHAR(11),
  xgrq                 DATE,
  xgr_dm               CHAR(11),
  sjgsdq               CHAR(11),
  sjtb_sj              TIMESTAMP(6),
  bachbz               CHAR(1),
  bachrq               DATE,
  tbrq_1               DATE,
  tskhyhmc             VARCHAR2(120),
  tskhyhzh             VARCHAR2(50),
  sbxh                 VARCHAR2(50)
)
;
comment on table CKTS_JGB_BA_WMZHFWDBTS
  is '外贸综合服务代办退税备案结果表';
comment on column CKTS_JGB_BA_WMZHFWDBTS.djxh
  is '登记序号';
comment on column CKTS_JGB_BA_WMZHFWDBTS.lcslid
  is '流程实例ID';
comment on column CKTS_JGB_BA_WMZHFWDBTS.uuid
  is 'UUID||uuid';
comment on column CKTS_JGB_BA_WMZHFWDBTS.nsrmc
  is '纳税人名称';
comment on column CKTS_JGB_BA_WMZHFWDBTS.hgqy_dm
  is '海关企业代码';
comment on column CKTS_JGB_BA_WMZHFWDBTS.nsrsbh
  is '纳税人识别号';
comment on column CKTS_JGB_BA_WMZHFWDBTS.shxydm
  is '社会信用代码';
comment on column CKTS_JGB_BA_WMZHFWDBTS.wtdbtsscqynsrmc
  is '委托代办退税生产企业纳税人名称';
comment on column CKTS_JGB_BA_WMZHFWDBTS.wtdbtsscqyhgqydm
  is '委托代办退税生产企业海关企业代码';
comment on column CKTS_JGB_BA_WMZHFWDBTS.wtdbtsscqynsrsbh
  is '委托代办退税生产企业纳税人识别号';
comment on column CKTS_JGB_BA_WMZHFWDBTS.wtdbtsscqyshxydm
  is '委托代办退税生产企业社会信用代码';
comment on column CKTS_JGB_BA_WMZHFWDBTS.wmzhfwhtxyhm
  is '外贸综合服务合同（协议）号码';
comment on column CKTS_JGB_BA_WMZHFWDBTS.wtdbtsscqydbtskhyhmc
  is '委托代办退税生产企业代办退税开户银行名称';
comment on column CKTS_JGB_BA_WMZHFWDBTS.wtdbtsscqydbtskhyhzh
  is '委托代办退税生产企业代办退税开户银行账号';
comment on column CKTS_JGB_BA_WMZHFWDBTS.fddbrxm
  is '法定代表人姓名';
comment on column CKTS_JGB_BA_WMZHFWDBTS.dbtsbalczt_dm
  is '代办退税备案流程状态代码';
comment on column CKTS_JGB_BA_WMZHFWDBTS.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_JGB_BA_WMZHFWDBTS.lrrq
  is '录入日期';
comment on column CKTS_JGB_BA_WMZHFWDBTS.lrr_dm
  is '录入人代码';
comment on column CKTS_JGB_BA_WMZHFWDBTS.xgrq
  is '修改日期';
comment on column CKTS_JGB_BA_WMZHFWDBTS.xgr_dm
  is '修改人代码';
comment on column CKTS_JGB_BA_WMZHFWDBTS.sjgsdq
  is '数据归属地区';
comment on column CKTS_JGB_BA_WMZHFWDBTS.sjtb_sj
  is '数据同步时间';
comment on column CKTS_JGB_BA_WMZHFWDBTS.bachbz
  is '备案撤回标志||备案撤回标志';
comment on column CKTS_JGB_BA_WMZHFWDBTS.bachrq
  is '备案撤回日期';
comment on column CKTS_JGB_BA_WMZHFWDBTS.tbrq_1
  is '填表日期';
comment on column CKTS_JGB_BA_WMZHFWDBTS.tskhyhmc
  is '退税开户银行名称';
comment on column CKTS_JGB_BA_WMZHFWDBTS.tskhyhzh
  is '退税开户银行账号';
comment on column CKTS_JGB_BA_WMZHFWDBTS.sbxh
  is '申报序号';
create index IDX_CKTS_JGB_BA_WMZHFWDBTS_D on CKTS_JGB_BA_WMZHFWDBTS (DJXH);
create index IDX_CKTS_JGB_BA_WMZHFWDBTS_L on CKTS_JGB_BA_WMZHFWDBTS (LCSLID);
create index IDX_CKTS_JGB_BA_WMZHFWDBTS_WT on CKTS_JGB_BA_WMZHFWDBTS (WTDBTSSCQYNSRSBH);
alter table CKTS_JGB_BA_WMZHFWDBTS
  add constraint PK_CKTS_JGB_BA_WMZHFWDBTS primary key (UUID);

prompt
prompt Creating table CKTS_JGB_BA_XTHHZG
prompt =================================
prompt
create table CKTS_JGB_BA_XTHHZG
(
  uuid          VARCHAR2(32) not null,
  lcslid        CHAR(32) not null,
  djxh          NUMBER(20) not null,
  sbxh          VARCHAR2(50) not null,
  ckhth         VARCHAR2(60) not null,
  wsdwmc        VARCHAR2(300) not null,
  cksp_dm       VARCHAR2(20) not null,
  ckspmc        VARCHAR2(75) not null,
  tcrq          DATE not null,
  wgrq          DATE not null,
  ckemy         NUMBER(18,2) not null,
  yjskcs        NUMBER(10) not null,
  dycskbl       NUMBER(10,6) not null,
  decskbl       NUMBER(10,6) not null,
  qyskbl        NUMBER(10,6) not null,
  cktmsywlxdmjh VARCHAR2(30) not null,
  cktmsywlxmcjh VARCHAR2(75),
  bz            VARCHAR2(3000),
  zfbz_1        CHAR(1),
  lrr_dm        CHAR(11) not null,
  lrrq          DATE not null,
  xgr_dm        CHAR(11),
  xgrq          DATE,
  tsswjg_dm_1   CHAR(11) not null,
  sjgsdq        CHAR(11) not null,
  sjtb_sj       TIMESTAMP(6),
  tbrq_1        DATE,
  sbljje        NUMBER(18,2),
  cjljje        NUMBER(18,2),
  nd            VARCHAR2(10)
)
;
comment on table CKTS_JGB_BA_XTHHZG
  is '先退税后核销资格申请结果表';
comment on column CKTS_JGB_BA_XTHHZG.uuid
  is 'UUID||uuid';
comment on column CKTS_JGB_BA_XTHHZG.lcslid
  is '流程实例ID';
comment on column CKTS_JGB_BA_XTHHZG.djxh
  is '登记序号';
comment on column CKTS_JGB_BA_XTHHZG.sbxh
  is '申报序号';
comment on column CKTS_JGB_BA_XTHHZG.ckhth
  is '出口合同号';
comment on column CKTS_JGB_BA_XTHHZG.wsdwmc
  is '外商单位名称';
comment on column CKTS_JGB_BA_XTHHZG.cksp_dm
  is '出口商品代码';
comment on column CKTS_JGB_BA_XTHHZG.ckspmc
  is '出口商品名称';
comment on column CKTS_JGB_BA_XTHHZG.tcrq
  is '投产日期';
comment on column CKTS_JGB_BA_XTHHZG.wgrq
  is '完工日期';
comment on column CKTS_JGB_BA_XTHHZG.ckemy
  is '出口额（美元）';
comment on column CKTS_JGB_BA_XTHHZG.yjskcs
  is '预计收款次数';
comment on column CKTS_JGB_BA_XTHHZG.dycskbl
  is '第一次收款比例';
comment on column CKTS_JGB_BA_XTHHZG.decskbl
  is '第二次收款比例';
comment on column CKTS_JGB_BA_XTHHZG.qyskbl
  is '其余收款比例';
comment on column CKTS_JGB_BA_XTHHZG.cktmsywlxdmjh
  is '出口退（免）税业务类型代码集合';
comment on column CKTS_JGB_BA_XTHHZG.cktmsywlxmcjh
  is '出口退（免）税业务类型名称集合';
comment on column CKTS_JGB_BA_XTHHZG.bz
  is '备注';
comment on column CKTS_JGB_BA_XTHHZG.zfbz_1
  is '作废标志';
comment on column CKTS_JGB_BA_XTHHZG.lrr_dm
  is '录入人代码';
comment on column CKTS_JGB_BA_XTHHZG.lrrq
  is '录入日期';
comment on column CKTS_JGB_BA_XTHHZG.xgr_dm
  is '修改人代码';
comment on column CKTS_JGB_BA_XTHHZG.xgrq
  is '修改日期';
comment on column CKTS_JGB_BA_XTHHZG.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_JGB_BA_XTHHZG.sjgsdq
  is '数据归属地区';
comment on column CKTS_JGB_BA_XTHHZG.sjtb_sj
  is '数据同步时间';
comment on column CKTS_JGB_BA_XTHHZG.tbrq_1
  is '填表日期';
comment on column CKTS_JGB_BA_XTHHZG.sbljje
  is '申报累计金额';
comment on column CKTS_JGB_BA_XTHHZG.cjljje
  is '冲减累计金额';
comment on column CKTS_JGB_BA_XTHHZG.nd
  is '年度';

prompt
prompt Creating table CKTS_JGB_SB_MDT_XTHHZG
prompt =====================================
prompt
create table CKTS_JGB_SB_MDT_XTHHZG
(
  uuid          VARCHAR2(32) not null,
  lcslid        CHAR(32),
  djxh          NUMBER(20),
  sbxh          VARCHAR2(50),
  ckhth         VARCHAR2(60),
  wsdwmc        VARCHAR2(300),
  cksp_dm       VARCHAR2(20),
  ckspmc        VARCHAR2(75),
  tcrq          DATE,
  wgrq          DATE,
  ckemy         NUMBER(18,2),
  yjskcs        NUMBER(10),
  dycskbl       NUMBER(10,6),
  decskbl       NUMBER(10,6),
  qyskbl        NUMBER(10,6),
  cktmsywlxdmjh VARCHAR2(30),
  cktmsywlxmcjh VARCHAR2(75),
  bz            VARCHAR2(3000),
  lrr_dm        CHAR(11),
  lrrq          DATE,
  xgr_dm        CHAR(11),
  xgrq          DATE,
  tsswjg_dm_1   CHAR(11),
  sjgsdq        CHAR(11),
  sjtb_sj       TIMESTAMP(6),
  zfbz_1        CHAR(1) default 'N',
  zfr_dm        CHAR(11),
  zfsj          DATE,
  sbljje        NUMBER(18,2),
  cjljje        NUMBER(18,2),
  nd            VARCHAR2(10)
)
;
comment on table CKTS_JGB_SB_MDT_XTHHZG
  is '先退税后核销资格申请结果表';
comment on column CKTS_JGB_SB_MDT_XTHHZG.uuid
  is 'UUID||uuid';
comment on column CKTS_JGB_SB_MDT_XTHHZG.lcslid
  is '流程实例ID';
comment on column CKTS_JGB_SB_MDT_XTHHZG.djxh
  is '登记序号';
comment on column CKTS_JGB_SB_MDT_XTHHZG.sbxh
  is '申报序号';
comment on column CKTS_JGB_SB_MDT_XTHHZG.ckhth
  is '出口合同号';
comment on column CKTS_JGB_SB_MDT_XTHHZG.wsdwmc
  is '外商单位名称';
comment on column CKTS_JGB_SB_MDT_XTHHZG.cksp_dm
  is '出口商品代码';
comment on column CKTS_JGB_SB_MDT_XTHHZG.ckspmc
  is '出口商品名称';
comment on column CKTS_JGB_SB_MDT_XTHHZG.tcrq
  is '投产日期';
comment on column CKTS_JGB_SB_MDT_XTHHZG.wgrq
  is '完工日期';
comment on column CKTS_JGB_SB_MDT_XTHHZG.ckemy
  is '出口额（美元）';
comment on column CKTS_JGB_SB_MDT_XTHHZG.yjskcs
  is '预计收款次数';
comment on column CKTS_JGB_SB_MDT_XTHHZG.dycskbl
  is '第一次收款比例';
comment on column CKTS_JGB_SB_MDT_XTHHZG.decskbl
  is '第二次收款比例';
comment on column CKTS_JGB_SB_MDT_XTHHZG.qyskbl
  is '其余收款比例';
comment on column CKTS_JGB_SB_MDT_XTHHZG.cktmsywlxdmjh
  is '出口退（免）税业务类型代码集合';
comment on column CKTS_JGB_SB_MDT_XTHHZG.cktmsywlxmcjh
  is '出口退（免）税业务类型名称集合';
comment on column CKTS_JGB_SB_MDT_XTHHZG.bz
  is '备注';
comment on column CKTS_JGB_SB_MDT_XTHHZG.lrr_dm
  is '录入人代码';
comment on column CKTS_JGB_SB_MDT_XTHHZG.lrrq
  is '录入日期';
comment on column CKTS_JGB_SB_MDT_XTHHZG.xgr_dm
  is '修改人代码';
comment on column CKTS_JGB_SB_MDT_XTHHZG.xgrq
  is '修改日期';
comment on column CKTS_JGB_SB_MDT_XTHHZG.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_JGB_SB_MDT_XTHHZG.sjgsdq
  is '数据归属地区';
comment on column CKTS_JGB_SB_MDT_XTHHZG.sjtb_sj
  is '数据同步时间';
comment on column CKTS_JGB_SB_MDT_XTHHZG.zfbz_1
  is '作废标志';
comment on column CKTS_JGB_SB_MDT_XTHHZG.zfr_dm
  is '作废人代码';
comment on column CKTS_JGB_SB_MDT_XTHHZG.zfsj
  is '作废时间||作废时间';
comment on column CKTS_JGB_SB_MDT_XTHHZG.sbljje
  is '申报累计金额';
comment on column CKTS_JGB_SB_MDT_XTHHZG.cjljje
  is '冲减累计金额';
comment on column CKTS_JGB_SB_MDT_XTHHZG.nd
  is '年度';
create index IDX_CKTS_JGB_SB_MDT_XTHHZG_D on CKTS_JGB_SB_MDT_XTHHZG (DJXH);
create index IDX_CKTS_JGB_SB_MDT_XTHHZG_L on CKTS_JGB_SB_MDT_XTHHZG (LCSLID);
alter table CKTS_JGB_SB_MDT_XTHHZG
  add constraint PK_CKTS_JGB_SB_MDT_XTHHZG primary key (UUID);

prompt
prompt Creating table CKTS_JGB_ZM_LLJG
prompt ===============================
prompt
create table CKTS_JGB_ZM_LLJG
(
  uuid       VARCHAR2(32) not null,
  djxh       NUMBER(20),
  lljgmszmbh VARCHAR2(20),
  xh_4       VARCHAR2(10),
  lljgszch   VARCHAR2(20),
  jgffphm    VARCHAR2(30),
  ykfphwmc   VARCHAR2(150),
  ykfphwdw   VARCHAR2(75),
  ykfphwsl   NUMBER(17,5),
  jgfje      NUMBER(18,2),
  kjbz       CHAR(1),
  zfbz_1     CHAR(1)
)
;
comment on table CKTS_JGB_ZM_LLJG
  is '来料加工免税证明结果表';
comment on column CKTS_JGB_ZM_LLJG.uuid
  is 'UUID||uuid';
comment on column CKTS_JGB_ZM_LLJG.djxh
  is '登记序号';
comment on column CKTS_JGB_ZM_LLJG.lljgmszmbh
  is '来料加工免税证明编号';
comment on column CKTS_JGB_ZM_LLJG.xh_4
  is '项号';
comment on column CKTS_JGB_ZM_LLJG.lljgszch
  is '来料加工手（账）册号';
comment on column CKTS_JGB_ZM_LLJG.jgffphm
  is '加工费发票号码';
comment on column CKTS_JGB_ZM_LLJG.ykfphwmc
  is '已开发票货物名称';
comment on column CKTS_JGB_ZM_LLJG.ykfphwdw
  is '已开发票货物单位';
comment on column CKTS_JGB_ZM_LLJG.ykfphwsl
  is '已开发票货物数量';
comment on column CKTS_JGB_ZM_LLJG.jgfje
  is '加工费金额';
comment on column CKTS_JGB_ZM_LLJG.kjbz
  is '开具标志';
comment on column CKTS_JGB_ZM_LLJG.zfbz_1
  is '作废标志';
create index IDX_CKTS_JGB_ZM_LLJG_DJXH_SZCH on CKTS_JGB_ZM_LLJG (DJXH, LLJGSZCH);
create index IDX_CKTS_JGB_ZM_LLJG_DJXH_ZMBH on CKTS_JGB_ZM_LLJG (DJXH, LLJGMSZMBH);

prompt
prompt Creating table CKTS_JGB_ZM_TYYBSWTS
prompt ===================================
prompt
create table CKTS_JGB_ZM_TYYBSWTS
(
  djxh            NUMBER(20) not null,
  lcslid          CHAR(32),
  uuid            VARCHAR2(32) not null,
  cktszmbh        VARCHAR2(20),
  wtfcktszmbh     VARCHAR2(20),
  dlckhwzmhm      VARCHAR2(20),
  ssq             VARCHAR2(60),
  sbxh            VARCHAR2(50),
  ckbgdh          VARCHAR2(21),
  ckrq_1          DATE,
  ckshhxdh        VARCHAR2(30),
  ckfph           VARCHAR2(30),
  cksp_dm         VARCHAR2(20),
  ckspmc          VARCHAR2(75),
  hgjldwmc        VARCHAR2(75),
  cksl            NUMBER(17,5),
  hggqka_dm       CHAR(4),
  yjsje           NUMBER(18,2),
  ysbmdtse        NUMBER(18,6),
  ytzzse_1        NUMBER(18,6),
  ytxfse_1        NUMBER(18,6),
  jhpzh           VARCHAR2(75),
  tysl            NUMBER(17,5),
  tyjsje          NUMBER(18,2),
  ytsl_1          NUMBER(16,6),
  ycjmdtse        NUMBER(18,2),
  cjssq           VARCHAR2(60),
  ybzzse_1        NUMBER(18,6),
  ybxfse_1        NUMBER(18,6),
  jkshm           VARCHAR2(20),
  rkrq            DATE,
  tyybswtstylx_dm CHAR(1),
  ysybs           CHAR(1),
  bz              VARCHAR2(3000),
  tsswjg_dm_1     CHAR(11),
  lrrq            DATE,
  lrr_dm          CHAR(11),
  xgrq            DATE,
  xgr_dm          CHAR(11),
  sjgsdq          CHAR(11) not null,
  sjtb_sj         TIMESTAMP(6),
  sbbh_1          VARCHAR2(20),
  zfbz_1          CHAR(1),
  zfr_dm          CHAR(11),
  zfsj            DATE,
  xh_4            VARCHAR2(10),
  sbny            CHAR(6),
  ckemy           NUMBER(18,2),
  sbpc            VARCHAR2(75),
  hsjg            VARCHAR2(20),
  sz              CHAR(1),
  tmsztbz         VARCHAR2(50),
  ybjtmsk         NUMBER(18,6),
  ywclfs          VARCHAR2(20),
  kjbz            CHAR(1),
  kjrq            DATE,
  kjr_dm          CHAR(11)
)
;
comment on table CKTS_JGB_ZM_TYYBSWTS
  is '出口货物退运已补税(未退税)证明结果表';
comment on column CKTS_JGB_ZM_TYYBSWTS.djxh
  is '登记序号';
comment on column CKTS_JGB_ZM_TYYBSWTS.lcslid
  is '流程实例ID';
comment on column CKTS_JGB_ZM_TYYBSWTS.uuid
  is 'UUID||uuid';
comment on column CKTS_JGB_ZM_TYYBSWTS.cktszmbh
  is '出口退税证明编号';
comment on column CKTS_JGB_ZM_TYYBSWTS.wtfcktszmbh
  is '委托方出口退税证明编号';
comment on column CKTS_JGB_ZM_TYYBSWTS.dlckhwzmhm
  is '代理出口货物证明号码';
comment on column CKTS_JGB_ZM_TYYBSWTS.ssq
  is '所属期';
comment on column CKTS_JGB_ZM_TYYBSWTS.sbxh
  is '申报序号';
comment on column CKTS_JGB_ZM_TYYBSWTS.ckbgdh
  is '出口报关单号';
comment on column CKTS_JGB_ZM_TYYBSWTS.ckrq_1
  is '出口日期';
comment on column CKTS_JGB_ZM_TYYBSWTS.ckshhxdh
  is '出口收汇核销单号';
comment on column CKTS_JGB_ZM_TYYBSWTS.ckfph
  is '出口发票号';
comment on column CKTS_JGB_ZM_TYYBSWTS.cksp_dm
  is '出口商品代码';
comment on column CKTS_JGB_ZM_TYYBSWTS.ckspmc
  is '出口商品名称';
comment on column CKTS_JGB_ZM_TYYBSWTS.hgjldwmc
  is '海关计量单位名称';
comment on column CKTS_JGB_ZM_TYYBSWTS.cksl
  is '出口数量';
comment on column CKTS_JGB_ZM_TYYBSWTS.hggqka_dm
  is '海关关区（口岸）代码';
comment on column CKTS_JGB_ZM_TYYBSWTS.yjsje
  is '原计税金额';
comment on column CKTS_JGB_ZM_TYYBSWTS.ysbmdtse
  is '原申报免抵退税额';
comment on column CKTS_JGB_ZM_TYYBSWTS.ytzzse_1
  is '原退增值税额';
comment on column CKTS_JGB_ZM_TYYBSWTS.ytxfse_1
  is '原退消费税额';
comment on column CKTS_JGB_ZM_TYYBSWTS.jhpzh
  is '进货凭证号';
comment on column CKTS_JGB_ZM_TYYBSWTS.tysl
  is '退运数量';
comment on column CKTS_JGB_ZM_TYYBSWTS.tyjsje
  is '退运计税金额';
comment on column CKTS_JGB_ZM_TYYBSWTS.ytsl_1
  is '原退税率';
comment on column CKTS_JGB_ZM_TYYBSWTS.ycjmdtse
  is '已冲减免抵退税额||应用于进出口退税';
comment on column CKTS_JGB_ZM_TYYBSWTS.cjssq
  is '冲减所属期';
comment on column CKTS_JGB_ZM_TYYBSWTS.ybzzse_1
  is '已补增值税额';
comment on column CKTS_JGB_ZM_TYYBSWTS.ybxfse_1
  is '已补消费税额';
comment on column CKTS_JGB_ZM_TYYBSWTS.jkshm
  is '缴款书号码';
comment on column CKTS_JGB_ZM_TYYBSWTS.rkrq
  is '入库日期';
comment on column CKTS_JGB_ZM_TYYBSWTS.tyybswtstylx_dm
  is '退运已补税（未退税）退运类型代码';
comment on column CKTS_JGB_ZM_TYYBSWTS.ysybs
  is '已使用标识';
comment on column CKTS_JGB_ZM_TYYBSWTS.bz
  is '备注';
comment on column CKTS_JGB_ZM_TYYBSWTS.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_JGB_ZM_TYYBSWTS.lrrq
  is '录入日期';
comment on column CKTS_JGB_ZM_TYYBSWTS.lrr_dm
  is '录入人代码';
comment on column CKTS_JGB_ZM_TYYBSWTS.xgrq
  is '修改日期';
comment on column CKTS_JGB_ZM_TYYBSWTS.xgr_dm
  is '修改人代码';
comment on column CKTS_JGB_ZM_TYYBSWTS.sjgsdq
  is '数据归属地区';
comment on column CKTS_JGB_ZM_TYYBSWTS.sjtb_sj
  is '数据同步时间';
comment on column CKTS_JGB_ZM_TYYBSWTS.sbbh_1
  is '申报编号';
comment on column CKTS_JGB_ZM_TYYBSWTS.zfbz_1
  is '作废标志';
comment on column CKTS_JGB_ZM_TYYBSWTS.zfr_dm
  is '作废人代码';
comment on column CKTS_JGB_ZM_TYYBSWTS.zfsj
  is '作废时间||作废时间';
comment on column CKTS_JGB_ZM_TYYBSWTS.xh_4
  is '项号';
comment on column CKTS_JGB_ZM_TYYBSWTS.sbny
  is '申报年月';
comment on column CKTS_JGB_ZM_TYYBSWTS.ckemy
  is '出口额（美元）';
comment on column CKTS_JGB_ZM_TYYBSWTS.sbpc
  is '申报批次';
comment on column CKTS_JGB_ZM_TYYBSWTS.hsjg
  is '核实结果';
comment on column CKTS_JGB_ZM_TYYBSWTS.sz
  is '税种';
comment on column CKTS_JGB_ZM_TYYBSWTS.tmsztbz
  is '退（免）税状态标志';
comment on column CKTS_JGB_ZM_TYYBSWTS.ybjtmsk
  is '应补缴退（免）税款';
comment on column CKTS_JGB_ZM_TYYBSWTS.ywclfs
  is '业务处理方式';
comment on column CKTS_JGB_ZM_TYYBSWTS.kjbz
  is '开具标志';
comment on column CKTS_JGB_ZM_TYYBSWTS.kjrq
  is '开具日期';
comment on column CKTS_JGB_ZM_TYYBSWTS.kjr_dm
  is '开具人代码';
create index IDX_CKTS_JGB_ZM_TYYBSWTS_DJXH on CKTS_JGB_ZM_TYYBSWTS (DJXH);
create index IDX_CKTS_JGB_ZM_TYYBSWTS_L on CKTS_JGB_ZM_TYYBSWTS (LCSLID);
create index IDX_CKTS_JGB_ZM_TYYBSWTS_SCC on CKTS_JGB_ZM_TYYBSWTS (SSQ, CKTSZMBH, CJSSQ);
alter table CKTS_JGB_ZM_TYYBSWTS
  add constraint PK_CKTS_JGB_ZM_TYYBSWTS primary key (UUID);

prompt
prompt Creating table CKTS_SB_BNSHSB_LSB
prompt =================================
prompt
create table CKTS_SB_BNSHSB_LSB
(
  sbid         NUMBER(18),
  qyhgdm       VARCHAR2(20),
  djxh         NUMBER(20),
  tsswjg_dm_1  CHAR(11),
  ssq          VARCHAR2(60),
  sbpc         VARCHAR2(75),
  sbxh         VARCHAR2(50),
  ckbgdh       VARCHAR2(21),
  ckfph        VARCHAR2(30),
  jckxszrq     DATE,
  cjzj         NUMBER(18,2),
  cjhbhl       NUMBER(16,6),
  ckxsermb     NUMBER(18,2),
  ckshhbzm_dm  CHAR(3),
  yshje        NUMBER(18,2),
  wshje        NUMBER(18,2),
  wshbl        NUMBER(10,6),
  bnshyy_dm    CHAR(2),
  bnshyymc     VARCHAR2(150),
  htydqbshzzrq DATE,
  ckhth        VARCHAR2(60),
  bz           VARCHAR2(3000),
  tbrq_1       DATE,
  lrrq         DATE,
  lrr_dm       CHAR(11),
  xgr_dm       CHAR(11),
  xgrq         DATE,
  sjgsdq       CHAR(11),
  sjtb_sj      TIMESTAMP(6),
  cjhbzm_dm    CHAR(3),
  tgzmclzl     VARCHAR2(300)
)
;
comment on table CKTS_SB_BNSHSB_LSB
  is '非收汇企业申报不能收汇申报临时表';
comment on column CKTS_SB_BNSHSB_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_BNSHSB_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_BNSHSB_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_BNSHSB_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_BNSHSB_LSB.ssq
  is '所属期';
comment on column CKTS_SB_BNSHSB_LSB.sbpc
  is '申报批次';
comment on column CKTS_SB_BNSHSB_LSB.sbxh
  is '申报序号';
comment on column CKTS_SB_BNSHSB_LSB.ckbgdh
  is '出口报关单号';
comment on column CKTS_SB_BNSHSB_LSB.ckfph
  is '出口发票号';
comment on column CKTS_SB_BNSHSB_LSB.jckxszrq
  is '记出口销售账日期';
comment on column CKTS_SB_BNSHSB_LSB.cjzj
  is '成交总价||成交总价';
comment on column CKTS_SB_BNSHSB_LSB.cjhbhl
  is '成交货币汇率';
comment on column CKTS_SB_BNSHSB_LSB.ckxsermb
  is '出口销售额（人民币）';
comment on column CKTS_SB_BNSHSB_LSB.ckshhbzm_dm
  is '出口收汇货币字母代码';
comment on column CKTS_SB_BNSHSB_LSB.yshje
  is '已收汇金额';
comment on column CKTS_SB_BNSHSB_LSB.wshje
  is '未收汇金额';
comment on column CKTS_SB_BNSHSB_LSB.wshbl
  is '未收汇比例';
comment on column CKTS_SB_BNSHSB_LSB.bnshyy_dm
  is '不能收汇原因代码';
comment on column CKTS_SB_BNSHSB_LSB.bnshyymc
  is '不能收汇原因名称';
comment on column CKTS_SB_BNSHSB_LSB.htydqbshzzrq
  is '合同约定全部收汇最终日期';
comment on column CKTS_SB_BNSHSB_LSB.ckhth
  is '出口合同号';
comment on column CKTS_SB_BNSHSB_LSB.bz
  is '备注';
comment on column CKTS_SB_BNSHSB_LSB.tbrq_1
  is '填表日期';
comment on column CKTS_SB_BNSHSB_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_BNSHSB_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_BNSHSB_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_BNSHSB_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_BNSHSB_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_BNSHSB_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_BNSHSB_LSB.cjhbzm_dm
  is '成交货币字母代码';
comment on column CKTS_SB_BNSHSB_LSB.tgzmclzl
  is '提供证明材料种类';
create index IDX_CKTS_SB_BNSHSB_LSB_1 on CKTS_SB_BNSHSB_LSB (SBID);
create index IDX_CKTS_SB_BNSHSB_LSB_2 on CKTS_SB_BNSHSB_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_DB_CKHWBNSH_LSB
prompt ======================================
prompt
create table CKTS_SB_DB_CKHWBNSH_LSB
(
  sbid         NUMBER(18),
  qyhgdm       VARCHAR2(20),
  djxh         NUMBER(20),
  ssq          VARCHAR2(60),
  sbpc         VARCHAR2(75),
  sbxh         VARCHAR2(50),
  ckbgdh       VARCHAR2(21),
  ckfph        VARCHAR2(30),
  jckxszrq     DATE,
  cjhbzm_dm    CHAR(3),
  cjzj         NUMBER(18,2),
  cjhbhl       NUMBER(16,6),
  ckxsermb     NUMBER(18,2),
  ckshhbzm_dm  CHAR(3),
  yshje        NUMBER(18,2),
  wshje        NUMBER(18,2),
  wshbl        NUMBER(10,6),
  bnshyy_dm    CHAR(2),
  bnshyymc     VARCHAR2(150),
  tgzmclzl     VARCHAR2(300),
  htydqbshzzrq DATE,
  ckhth        VARCHAR2(60),
  bz           VARCHAR2(3000),
  tbrq_1       DATE,
  tsswjg_dm_1  CHAR(11),
  lrr_dm       CHAR(11),
  lrrq         DATE,
  xgrq         DATE,
  xgr_dm       CHAR(11),
  sjgsdq       CHAR(11),
  sjtb_sj      TIMESTAMP(6)
)
;
comment on table CKTS_SB_DB_CKHWBNSH_LSB
  is '外贸综合服务出口收汇不能收汇明细临时表';
comment on column CKTS_SB_DB_CKHWBNSH_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_DB_CKHWBNSH_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_DB_CKHWBNSH_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_DB_CKHWBNSH_LSB.ssq
  is '所属期';
comment on column CKTS_SB_DB_CKHWBNSH_LSB.sbpc
  is '申报批次';
comment on column CKTS_SB_DB_CKHWBNSH_LSB.sbxh
  is '申报序号';
comment on column CKTS_SB_DB_CKHWBNSH_LSB.ckbgdh
  is '出口报关单号';
comment on column CKTS_SB_DB_CKHWBNSH_LSB.ckfph
  is '出口发票号';
comment on column CKTS_SB_DB_CKHWBNSH_LSB.jckxszrq
  is '记出口销售账日期';
comment on column CKTS_SB_DB_CKHWBNSH_LSB.cjhbzm_dm
  is '成交货币字母代码';
comment on column CKTS_SB_DB_CKHWBNSH_LSB.cjzj
  is '成交总价||成交总价';
comment on column CKTS_SB_DB_CKHWBNSH_LSB.cjhbhl
  is '成交货币汇率';
comment on column CKTS_SB_DB_CKHWBNSH_LSB.ckxsermb
  is '出口销售额（人民币）';
comment on column CKTS_SB_DB_CKHWBNSH_LSB.ckshhbzm_dm
  is '出口收汇货币字母代码';
comment on column CKTS_SB_DB_CKHWBNSH_LSB.yshje
  is '已收汇金额';
comment on column CKTS_SB_DB_CKHWBNSH_LSB.wshje
  is '未收汇金额';
comment on column CKTS_SB_DB_CKHWBNSH_LSB.wshbl
  is '未收汇比例';
comment on column CKTS_SB_DB_CKHWBNSH_LSB.bnshyy_dm
  is '不能收汇原因代码';
comment on column CKTS_SB_DB_CKHWBNSH_LSB.bnshyymc
  is '不能收汇原因名称';
comment on column CKTS_SB_DB_CKHWBNSH_LSB.tgzmclzl
  is '提供证明材料种类';
comment on column CKTS_SB_DB_CKHWBNSH_LSB.htydqbshzzrq
  is '合同约定全部收汇最终日期';
comment on column CKTS_SB_DB_CKHWBNSH_LSB.ckhth
  is '出口合同号';
comment on column CKTS_SB_DB_CKHWBNSH_LSB.bz
  is '备注';
comment on column CKTS_SB_DB_CKHWBNSH_LSB.tbrq_1
  is '填表日期';
comment on column CKTS_SB_DB_CKHWBNSH_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_DB_CKHWBNSH_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_DB_CKHWBNSH_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_DB_CKHWBNSH_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_DB_CKHWBNSH_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_DB_CKHWBNSH_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_DB_CKHWBNSH_LSB.sjtb_sj
  is '数据同步时间';
create index IDX_CKTS_SB_DB_CKHWBNSH_LSB_1 on CKTS_SB_DB_CKHWBNSH_LSB (SBID);
create index IDX_CKTS_SB_DB_CKHWBNSH_LSB_2 on CKTS_SB_DB_CKHWBNSH_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_DB_CKHWSH_LSB
prompt ====================================
prompt
create table CKTS_SB_DB_CKHWSH_LSB
(
  sbid               NUMBER(18),
  qyhgdm             VARCHAR2(20),
  djxh               NUMBER(20),
  ssq                VARCHAR2(60),
  sbpc               VARCHAR2(75),
  sbxh               VARCHAR2(50),
  ckbgdh             VARCHAR2(21),
  ckfph              VARCHAR2(30),
  jckxszrq           DATE,
  cjhbzm_dm          CHAR(3),
  cjzj               NUMBER(18,2),
  cjhbhl             NUMBER(16,6),
  ckxsermb           NUMBER(18,2),
  pzhm_2             VARCHAR2(40),
  ckshrq             DATE,
  jhfs_dm            CHAR(1),
  yhywbh             VARCHAR2(50),
  ckshhbzm_dm        CHAR(3),
  ckshje             NUMBER(18,2),
  ckshhbhl           NUMBER(16,6),
  ckshjermb          NUMBER(18,2),
  fhr                VARCHAR2(300),
  fhgjdq             VARCHAR2(300),
  fjksfhyy           VARCHAR2(75),
  fjkgjdqfhyy        VARCHAR2(75),
  bz                 VARCHAR2(3000),
  tsswjg_dm_1        CHAR(11),
  lrr_dm             CHAR(11),
  lrrq               DATE,
  xgrq               DATE,
  xgr_dm             CHAR(11),
  sjgsdq             CHAR(11),
  sjtb_sj            TIMESTAMP(6),
  jrjgdm             VARCHAR2(20),
  tbrq_1             DATE,
  dlckhwzmhm         VARCHAR2(20),
  yshqkpzzje         NUMBER(18,2),
  stshqkyy           VARCHAR2(100),
  stshqkyyjtsm       VARCHAR2(4000),
  stshqkjzclzl       VARCHAR2(100),
  stshqkzrmbje       NUMBER(18,2),
  stshqkhtydqbshzzrq DATE,
  stshqkckhth        VARCHAR2(60)
)
;
comment on table CKTS_SB_DB_CKHWSH_LSB
  is '外贸综合服务出口货物收汇申报临时表';
comment on column CKTS_SB_DB_CKHWSH_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_DB_CKHWSH_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_DB_CKHWSH_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_DB_CKHWSH_LSB.ssq
  is '所属期';
comment on column CKTS_SB_DB_CKHWSH_LSB.sbpc
  is '申报批次';
comment on column CKTS_SB_DB_CKHWSH_LSB.sbxh
  is '退免税申报情况||申报序号';
comment on column CKTS_SB_DB_CKHWSH_LSB.ckbgdh
  is '退免税申报情况||出口报关单号';
comment on column CKTS_SB_DB_CKHWSH_LSB.ckfph
  is '退免税申报情况||出口发票号';
comment on column CKTS_SB_DB_CKHWSH_LSB.jckxszrq
  is '记出口销售账日期';
comment on column CKTS_SB_DB_CKHWSH_LSB.cjhbzm_dm
  is '退免税申报情况||成交货币字母代码';
comment on column CKTS_SB_DB_CKHWSH_LSB.cjzj
  is '退免税申报情况||成交总价';
comment on column CKTS_SB_DB_CKHWSH_LSB.cjhbhl
  is '成交货币汇率';
comment on column CKTS_SB_DB_CKHWSH_LSB.ckxsermb
  is '退免税申报情况||出口销售额（人民币）';
comment on column CKTS_SB_DB_CKHWSH_LSB.pzhm_2
  is '已收汇情况||凭证号码';
comment on column CKTS_SB_DB_CKHWSH_LSB.ckshrq
  is '已收汇情况||出口收汇日期';
comment on column CKTS_SB_DB_CKHWSH_LSB.jhfs_dm
  is '结汇方式代码';
comment on column CKTS_SB_DB_CKHWSH_LSB.yhywbh
  is '银行业务编号';
comment on column CKTS_SB_DB_CKHWSH_LSB.ckshhbzm_dm
  is '已收汇情况||出口收汇货币字母代码';
comment on column CKTS_SB_DB_CKHWSH_LSB.ckshje
  is '已收汇情况||出口收汇金额';
comment on column CKTS_SB_DB_CKHWSH_LSB.ckshhbhl
  is '出口收汇货币汇率';
comment on column CKTS_SB_DB_CKHWSH_LSB.ckshjermb
  is '已收汇情况||出口收汇金额（人民币）';
comment on column CKTS_SB_DB_CKHWSH_LSB.fhr
  is '已收汇情况||付汇人';
comment on column CKTS_SB_DB_CKHWSH_LSB.fhgjdq
  is '付汇国家（地区）';
comment on column CKTS_SB_DB_CKHWSH_LSB.fjksfhyy
  is '已收汇情况||非进口商付汇原因';
comment on column CKTS_SB_DB_CKHWSH_LSB.fjkgjdqfhyy
  is '非进口国家（地区）付汇原因';
comment on column CKTS_SB_DB_CKHWSH_LSB.bz
  is '退免税申报情况||备注';
comment on column CKTS_SB_DB_CKHWSH_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_DB_CKHWSH_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_DB_CKHWSH_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_DB_CKHWSH_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_DB_CKHWSH_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_DB_CKHWSH_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_DB_CKHWSH_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_DB_CKHWSH_LSB.jrjgdm
  is '金融机构代码';
comment on column CKTS_SB_DB_CKHWSH_LSB.tbrq_1
  is '填表日期';
comment on column CKTS_SB_DB_CKHWSH_LSB.dlckhwzmhm
  is '退免税申报情况||代理出口货物证明号码';
comment on column CKTS_SB_DB_CKHWSH_LSB.yshqkpzzje
  is '已收汇情况||凭证总金额';
comment on column CKTS_SB_DB_CKHWSH_LSB.stshqkyy
  is '视同收汇情况||原因';
comment on column CKTS_SB_DB_CKHWSH_LSB.stshqkyyjtsm
  is '视同收汇情况||原因具体说明';
comment on column CKTS_SB_DB_CKHWSH_LSB.stshqkjzclzl
  is '视同收汇情况||举证材料种类';
comment on column CKTS_SB_DB_CKHWSH_LSB.stshqkzrmbje
  is '视同收汇情况||折人民币金额';
comment on column CKTS_SB_DB_CKHWSH_LSB.stshqkhtydqbshzzrq
  is '视同收汇情况||合同约定全部收汇最终日期';
comment on column CKTS_SB_DB_CKHWSH_LSB.stshqkckhth
  is '视同收汇情况||出口合同号';
create index IDX_CKTS_SB_DB_CKHWSH_LSB_1 on CKTS_SB_DB_CKHWSH_LSB (SBID);
create index IDX_CKTS_SB_DB_CKHWSH_LSB_2 on CKTS_SB_DB_CKHWSH_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_DB_HGSPTZ_LSB
prompt ====================================
prompt
create table CKTS_SB_DB_HGSPTZ_LSB
(
  sbid          NUMBER(18),
  qyhgdm        VARCHAR2(20),
  djxh          NUMBER(20),
  sbxh          VARCHAR2(50),
  sbpc          VARCHAR2(75),
  ckbgdh        VARCHAR2(21),
  ckrq_1        DATE,
  cksp_dm       VARCHAR2(20),
  hgspmc        VARCHAR2(500),
  tsl           NUMBER(16,6),
  tzhcksp_dm    VARCHAR2(20),
  tzhhgspmc     VARCHAR2(500),
  tzhtsl        NUMBER(16,6),
  dlckhwzmhm    VARCHAR2(20),
  bz            VARCHAR2(3000),
  tsswjg_dm_1   CHAR(11),
  lrr_dm        CHAR(11),
  lrrq          DATE,
  xgrq          DATE,
  xgr_dm        CHAR(11),
  sjgsdq        CHAR(11),
  sjtb_sj       TIMESTAMP(6),
  ssq           VARCHAR2(60),
  hgckhwbgdsbrq DATE,
  tbrq_1        DATE,
  sbhgspmc      VARCHAR2(500)
)
;
comment on table CKTS_SB_DB_HGSPTZ_LSB
  is '外贸综合服务海关出口商品调整对照临时表';
comment on column CKTS_SB_DB_HGSPTZ_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_DB_HGSPTZ_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_DB_HGSPTZ_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_DB_HGSPTZ_LSB.sbxh
  is '申报序号';
comment on column CKTS_SB_DB_HGSPTZ_LSB.sbpc
  is '申报批次';
comment on column CKTS_SB_DB_HGSPTZ_LSB.ckbgdh
  is '出口报关单号';
comment on column CKTS_SB_DB_HGSPTZ_LSB.ckrq_1
  is '出口日期';
comment on column CKTS_SB_DB_HGSPTZ_LSB.cksp_dm
  is '出口商品代码';
comment on column CKTS_SB_DB_HGSPTZ_LSB.hgspmc
  is '海关商品名称';
comment on column CKTS_SB_DB_HGSPTZ_LSB.tsl
  is '退税率';
comment on column CKTS_SB_DB_HGSPTZ_LSB.tzhcksp_dm
  is '调整后出口商品代码';
comment on column CKTS_SB_DB_HGSPTZ_LSB.tzhhgspmc
  is '调整后海关商品名称';
comment on column CKTS_SB_DB_HGSPTZ_LSB.tzhtsl
  is '调整后退税率';
comment on column CKTS_SB_DB_HGSPTZ_LSB.dlckhwzmhm
  is '代理出口货物证明号码';
comment on column CKTS_SB_DB_HGSPTZ_LSB.bz
  is '备注';
comment on column CKTS_SB_DB_HGSPTZ_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_DB_HGSPTZ_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_DB_HGSPTZ_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_DB_HGSPTZ_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_DB_HGSPTZ_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_DB_HGSPTZ_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_DB_HGSPTZ_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_DB_HGSPTZ_LSB.ssq
  is '所属期';
comment on column CKTS_SB_DB_HGSPTZ_LSB.hgckhwbgdsbrq
  is '海关出口货物报关单申报日期';
comment on column CKTS_SB_DB_HGSPTZ_LSB.tbrq_1
  is '填表日期';
comment on column CKTS_SB_DB_HGSPTZ_LSB.sbhgspmc
  is '申报海关商品名称||申报海关商品名称';
create index IDX_CKTS_SB_DB_HGSPTZ_LSB_1 on CKTS_SB_DB_HGSPTZ_LSB (SBID);
create index IDX_CKTS_SB_DB_HGSPTZ_LSB_2 on CKTS_SB_DB_HGSPTZ_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_DB_TSSB_LSB
prompt ==================================
prompt
create table CKTS_SB_DB_TSSB_LSB
(
  sbid             NUMBER(18),
  qyhgdm           VARCHAR2(20),
  djxh             NUMBER(20),
  ssq              VARCHAR2(60),
  sbpc             VARCHAR2(75),
  sbxh             VARCHAR2(50),
  wtdbtsscqynsrsbh VARCHAR2(20),
  wtdbtsscqyshxydm VARCHAR2(20),
  ckbgdh           VARCHAR2(21),
  ckrq_1           DATE,
  cksp_dm          VARCHAR2(20),
  hgspmc           VARCHAR2(500),
  hgjldwmc         VARCHAR2(75),
  sbsp_dm          VARCHAR2(20),
  sbspmc           VARCHAR2(500),
  cksl             NUMBER(17,5),
  mylaj            NUMBER(18,2),
  dbtswspzhm       VARCHAR2(40),
  dbtsfpzs         NUMBER(10),
  kprq             DATE,
  jsje             NUMBER(18,2),
  zssl             NUMBER(16,6),
  tsl              NUMBER(16,6),
  tse              NUMBER(18,6),
  cktmsywlxdmjh    VARCHAR2(30),
  cktmsywlxmcjh    VARCHAR2(75),
  dbtsywlx_dm      VARCHAR2(20),
  dbtsywlxmc       VARCHAR2(75),
  bz               VARCHAR2(3000),
  tbrq_1           DATE,
  dlsbjbr          VARCHAR2(150),
  sqrmc            VARCHAR2(300),
  sqrq_1           DATE,
  tsswjg_dm_1      CHAR(11),
  lrr_dm           CHAR(11),
  lrrq             DATE,
  xgrq             DATE,
  xgr_dm           CHAR(11),
  sjgsdq           CHAR(11),
  sjtb_sj          TIMESTAMP(6),
  jbrxm            VARCHAR2(75),
  fpdm             VARCHAR2(12),
  fphm             VARCHAR2(8),
  hgcode           VARCHAR2(4),
  gbcode           VARCHAR2(3),
  zzmdg            VARCHAR2(3),
  hzdwdqdm         VARCHAR2(5),
  sbdwdm           VARCHAR2(10),
  gnqyfs_dm        VARCHAR2(2),
  hgzsrzqylx_dm    VARCHAR2(2)
)
;
comment on table CKTS_SB_DB_TSSB_LSB
  is '外贸综合服务代办退税申报临时表';
comment on column CKTS_SB_DB_TSSB_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_DB_TSSB_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_DB_TSSB_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_DB_TSSB_LSB.ssq
  is '所属期';
comment on column CKTS_SB_DB_TSSB_LSB.sbpc
  is '申报批次';
comment on column CKTS_SB_DB_TSSB_LSB.sbxh
  is '申报序号';
comment on column CKTS_SB_DB_TSSB_LSB.wtdbtsscqynsrsbh
  is '委托代办退税生产企业纳税人识别号';
comment on column CKTS_SB_DB_TSSB_LSB.wtdbtsscqyshxydm
  is '委托代办退税生产企业社会信用代码';
comment on column CKTS_SB_DB_TSSB_LSB.ckbgdh
  is '出口报关单号';
comment on column CKTS_SB_DB_TSSB_LSB.ckrq_1
  is '出口日期';
comment on column CKTS_SB_DB_TSSB_LSB.cksp_dm
  is '出口商品代码';
comment on column CKTS_SB_DB_TSSB_LSB.hgspmc
  is '海关商品名称';
comment on column CKTS_SB_DB_TSSB_LSB.hgjldwmc
  is '海关计量单位名称';
comment on column CKTS_SB_DB_TSSB_LSB.sbsp_dm
  is '申报商品代码';
comment on column CKTS_SB_DB_TSSB_LSB.sbspmc
  is '申报商品名称';
comment on column CKTS_SB_DB_TSSB_LSB.cksl
  is '出口数量';
comment on column CKTS_SB_DB_TSSB_LSB.mylaj
  is '美元离岸价';
comment on column CKTS_SB_DB_TSSB_LSB.dbtswspzhm
  is '代办退税完税凭证号码';
comment on column CKTS_SB_DB_TSSB_LSB.dbtsfpzs
  is '代办退税发票（张数）';
comment on column CKTS_SB_DB_TSSB_LSB.kprq
  is '开票日期';
comment on column CKTS_SB_DB_TSSB_LSB.jsje
  is '计税金额';
comment on column CKTS_SB_DB_TSSB_LSB.zssl
  is '征税税率';
comment on column CKTS_SB_DB_TSSB_LSB.tsl
  is '退税率';
comment on column CKTS_SB_DB_TSSB_LSB.tse
  is '退税额';
comment on column CKTS_SB_DB_TSSB_LSB.cktmsywlxdmjh
  is '出口退（免）税业务类型代码集合';
comment on column CKTS_SB_DB_TSSB_LSB.cktmsywlxmcjh
  is '出口退（免）税业务类型名称集合';
comment on column CKTS_SB_DB_TSSB_LSB.dbtsywlx_dm
  is '代办退税业务类型代码';
comment on column CKTS_SB_DB_TSSB_LSB.dbtsywlxmc
  is '代办退税业务类型名称';
comment on column CKTS_SB_DB_TSSB_LSB.bz
  is '备注';
comment on column CKTS_SB_DB_TSSB_LSB.tbrq_1
  is '填表日期';
comment on column CKTS_SB_DB_TSSB_LSB.dlsbjbr
  is '代理申报经办人';
comment on column CKTS_SB_DB_TSSB_LSB.sqrmc
  is '授权人名称';
comment on column CKTS_SB_DB_TSSB_LSB.sqrq_1
  is '授权日期';
comment on column CKTS_SB_DB_TSSB_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_DB_TSSB_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_DB_TSSB_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_DB_TSSB_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_DB_TSSB_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_DB_TSSB_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_DB_TSSB_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_DB_TSSB_LSB.jbrxm
  is '经办人姓名';
comment on column CKTS_SB_DB_TSSB_LSB.fpdm
  is '代办退税发票代码（信息比对的时候通过JHPZH分解）';
comment on column CKTS_SB_DB_TSSB_LSB.fphm
  is '代办退税发票号码（信息比对的时候通过JHPZH分解）';
comment on column CKTS_SB_DB_TSSB_LSB.gnqyfs_dm
  is '国内启运方式代码';
comment on column CKTS_SB_DB_TSSB_LSB.hgzsrzqylx_dm
  is '海关总署认证企业类型代码';
create index IDX_CKTS_SB_DB_TSSB_LSB_1 on CKTS_SB_DB_TSSB_LSB (SBID);
create index IDX_CKTS_SB_DB_TSSB_LSB_2 on CKTS_SB_DB_TSSB_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_FZC_BNSH_LSB
prompt ===================================
prompt
create table CKTS_SB_FZC_BNSH_LSB
(
  sbid         NUMBER(18),
  qyhgdm       VARCHAR2(20),
  djxh         NUMBER(20),
  ssq          VARCHAR2(60),
  sbpc         VARCHAR2(75),
  sbxh         VARCHAR2(50),
  ckbgdh       VARCHAR2(21),
  ckfph        VARCHAR2(30),
  jckxszrq     DATE,
  cjhbzm_dm    CHAR(3),
  cjzj         NUMBER(18,2),
  cjhbhl       NUMBER(16,6),
  ckxsermb     NUMBER(18,2),
  ckshhbzm_dm  CHAR(3),
  yshje        NUMBER(18,2),
  wshje        NUMBER(18,2),
  wshbl        NUMBER(10,6),
  bnshyy_dm    CHAR(2),
  bnshyymc     VARCHAR2(150),
  tgzmclzl     VARCHAR2(300),
  htydqbshzzrq DATE,
  ckhth        VARCHAR2(60),
  bz           VARCHAR2(3000),
  tbrq_1       DATE,
  lrr_dm       CHAR(11),
  lrrq         DATE,
  xgr_dm       CHAR(11),
  xgrq         DATE,
  tsswjg_dm_1  CHAR(11),
  sjgsdq       CHAR(11),
  sjtb_sj      TIMESTAMP(6)
)
;
comment on table CKTS_SB_FZC_BNSH_LSB
  is '出口非自产货物退消费税不能收汇申报临时表';
comment on column CKTS_SB_FZC_BNSH_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_FZC_BNSH_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_FZC_BNSH_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_FZC_BNSH_LSB.ssq
  is '所属期';
comment on column CKTS_SB_FZC_BNSH_LSB.sbxh
  is '申报序号';
comment on column CKTS_SB_FZC_BNSH_LSB.ckbgdh
  is '出口报关单号';
comment on column CKTS_SB_FZC_BNSH_LSB.ckfph
  is '出口发票号';
comment on column CKTS_SB_FZC_BNSH_LSB.jckxszrq
  is '记出口销售账日期';
comment on column CKTS_SB_FZC_BNSH_LSB.cjhbzm_dm
  is '成交货币字母代码';
comment on column CKTS_SB_FZC_BNSH_LSB.cjzj
  is '成交总价||成交总价';
comment on column CKTS_SB_FZC_BNSH_LSB.cjhbhl
  is '成交货币汇率';
comment on column CKTS_SB_FZC_BNSH_LSB.ckxsermb
  is '出口销售额（人民币）';
comment on column CKTS_SB_FZC_BNSH_LSB.ckshhbzm_dm
  is '出口收汇货币字母代码';
comment on column CKTS_SB_FZC_BNSH_LSB.yshje
  is '已收汇金额';
comment on column CKTS_SB_FZC_BNSH_LSB.wshje
  is '未收汇金额';
comment on column CKTS_SB_FZC_BNSH_LSB.wshbl
  is '未收汇比例';
comment on column CKTS_SB_FZC_BNSH_LSB.bnshyy_dm
  is '不能收汇原因代码';
comment on column CKTS_SB_FZC_BNSH_LSB.bnshyymc
  is '不能收汇原因名称';
comment on column CKTS_SB_FZC_BNSH_LSB.tgzmclzl
  is '提供证明材料种类';
comment on column CKTS_SB_FZC_BNSH_LSB.htydqbshzzrq
  is '合同约定全部收汇最终日期';
comment on column CKTS_SB_FZC_BNSH_LSB.ckhth
  is '出口合同号';
comment on column CKTS_SB_FZC_BNSH_LSB.bz
  is '备注';
comment on column CKTS_SB_FZC_BNSH_LSB.tbrq_1
  is '填表日期';
comment on column CKTS_SB_FZC_BNSH_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_FZC_BNSH_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_FZC_BNSH_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_FZC_BNSH_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_FZC_BNSH_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_FZC_BNSH_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_FZC_BNSH_LSB.sjtb_sj
  is '数据同步时间';
create index IDX_CKTS_SB_FZC_BNSH_LSB_1 on CKTS_SB_FZC_BNSH_LSB (SBID);
create index IDX_CKTS_SB_FZC_BNSH_LSB_2 on CKTS_SB_FZC_BNSH_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_FZC_CKSH_LSB
prompt ===================================
prompt
create table CKTS_SB_FZC_CKSH_LSB
(
  sbid               NUMBER(18),
  qyhgdm             VARCHAR2(20),
  djxh               NUMBER(20),
  ssq                VARCHAR2(60),
  sbpc               VARCHAR2(75),
  sbxh               VARCHAR2(50),
  ckbgdh             VARCHAR2(21),
  ckfph              VARCHAR2(30),
  jckxszrq           DATE,
  cjhbzm_dm          CHAR(3),
  cjzj               NUMBER(18,2),
  cjhbhl             NUMBER(16,6),
  ckxsermb           NUMBER(18,2),
  pzhm_2             VARCHAR2(40),
  ckshrq             DATE,
  jhfs_dm            CHAR(1),
  jrjgdm             VARCHAR2(20),
  yhywbh             VARCHAR2(50),
  ckshhbzm_dm        CHAR(3),
  ckshje             NUMBER(18,2),
  ckshhbhl           NUMBER(16,6),
  ckshjermb          NUMBER(18,2),
  fhr                VARCHAR2(300),
  fhgjdq             VARCHAR2(300),
  fjksfhyy           VARCHAR2(75),
  fjkgjdqfhyy        VARCHAR2(75),
  bz                 VARCHAR2(3000),
  lrr_dm             CHAR(11),
  lrrq               DATE,
  xgr_dm             CHAR(11),
  xgrq               DATE,
  tsswjg_dm_1        CHAR(11),
  sjgsdq             CHAR(11),
  sjtb_sj            TIMESTAMP(6),
  tbrq_1             DATE,
  dlckhwzmhm         VARCHAR2(20),
  yshqkpzzje         NUMBER(18,2),
  stshqkyy           VARCHAR2(100),
  stshqkyyjtsm       VARCHAR2(4000),
  stshqkjzclzl       VARCHAR2(100),
  stshqkzrmbje       NUMBER(18,2),
  stshqkhtydqbshzzrq DATE,
  stshqkckhth        VARCHAR2(60)
)
;
comment on table CKTS_SB_FZC_CKSH_LSB
  is '出口非自产货物退消费税收汇申报明细临时表';
comment on column CKTS_SB_FZC_CKSH_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_FZC_CKSH_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_FZC_CKSH_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_FZC_CKSH_LSB.ssq
  is '所属期';
comment on column CKTS_SB_FZC_CKSH_LSB.sbxh
  is '退免税申报情况||申报序号';
comment on column CKTS_SB_FZC_CKSH_LSB.ckbgdh
  is '退免税申报情况||出口报关单号';
comment on column CKTS_SB_FZC_CKSH_LSB.ckfph
  is '退免税申报情况||出口发票号';
comment on column CKTS_SB_FZC_CKSH_LSB.jckxszrq
  is '记出口销售账日期';
comment on column CKTS_SB_FZC_CKSH_LSB.cjhbzm_dm
  is '退免税申报情况||成交货币字母代码';
comment on column CKTS_SB_FZC_CKSH_LSB.cjzj
  is '退免税申报情况||成交总价';
comment on column CKTS_SB_FZC_CKSH_LSB.cjhbhl
  is '成交货币汇率';
comment on column CKTS_SB_FZC_CKSH_LSB.ckxsermb
  is '退免税申报情况||出口销售额（人民币）';
comment on column CKTS_SB_FZC_CKSH_LSB.pzhm_2
  is '已收汇情况||凭证号码';
comment on column CKTS_SB_FZC_CKSH_LSB.ckshrq
  is '已收汇情况||出口收汇日期';
comment on column CKTS_SB_FZC_CKSH_LSB.jhfs_dm
  is '结汇方式代码';
comment on column CKTS_SB_FZC_CKSH_LSB.jrjgdm
  is '金融机构代码';
comment on column CKTS_SB_FZC_CKSH_LSB.yhywbh
  is '银行业务编号';
comment on column CKTS_SB_FZC_CKSH_LSB.ckshhbzm_dm
  is '已收汇情况||出口收汇货币字母代码';
comment on column CKTS_SB_FZC_CKSH_LSB.ckshje
  is '已收汇情况||出口收汇金额';
comment on column CKTS_SB_FZC_CKSH_LSB.ckshhbhl
  is '出口收汇货币汇率';
comment on column CKTS_SB_FZC_CKSH_LSB.ckshjermb
  is '已收汇情况||出口收汇金额（人民币）';
comment on column CKTS_SB_FZC_CKSH_LSB.fhr
  is '已收汇情况||付汇人';
comment on column CKTS_SB_FZC_CKSH_LSB.fhgjdq
  is '付汇国家（地区）';
comment on column CKTS_SB_FZC_CKSH_LSB.fjksfhyy
  is '已收汇情况||非进口商付汇原因';
comment on column CKTS_SB_FZC_CKSH_LSB.fjkgjdqfhyy
  is '非进口国家（地区）付汇原因';
comment on column CKTS_SB_FZC_CKSH_LSB.bz
  is '退免税申报情况||备注';
comment on column CKTS_SB_FZC_CKSH_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_FZC_CKSH_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_FZC_CKSH_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_FZC_CKSH_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_FZC_CKSH_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_FZC_CKSH_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_FZC_CKSH_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_FZC_CKSH_LSB.tbrq_1
  is '填表日期';
comment on column CKTS_SB_FZC_CKSH_LSB.dlckhwzmhm
  is '退免税申报情况||代理出口货物证明号码';
comment on column CKTS_SB_FZC_CKSH_LSB.yshqkpzzje
  is '已收汇情况||凭证总金额';
comment on column CKTS_SB_FZC_CKSH_LSB.stshqkyy
  is '视同收汇情况||原因';
comment on column CKTS_SB_FZC_CKSH_LSB.stshqkyyjtsm
  is '视同收汇情况||原因具体说明';
comment on column CKTS_SB_FZC_CKSH_LSB.stshqkjzclzl
  is '视同收汇情况||举证材料种类';
comment on column CKTS_SB_FZC_CKSH_LSB.stshqkzrmbje
  is '视同收汇情况||折人民币金额';
comment on column CKTS_SB_FZC_CKSH_LSB.stshqkhtydqbshzzrq
  is '视同收汇情况||合同约定全部收汇最终日期';
comment on column CKTS_SB_FZC_CKSH_LSB.stshqkckhth
  is '视同收汇情况||出口合同号';
create index IDX_CKTS_SB_FZC_CKSH_LSB_1 on CKTS_SB_FZC_CKSH_LSB (SBID);
create index IDX_CKTS_SB_FZC_CKSH_LSB_2 on CKTS_SB_FZC_CKSH_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_FZC_HGSPTZ_LSB
prompt =====================================
prompt
create table CKTS_SB_FZC_HGSPTZ_LSB
(
  sbid          NUMBER(18),
  qyhgdm        VARCHAR2(20),
  djxh          NUMBER(20),
  ssq           VARCHAR2(60),
  sbpc          VARCHAR2(75),
  sbxh          VARCHAR2(50),
  ckbgdh        VARCHAR2(21),
  ckrq_1        DATE,
  cksp_dm       VARCHAR2(20),
  tsl           NUMBER(16,6),
  tzhcksp_dm    VARCHAR2(20),
  tzhhgspmc     VARCHAR2(500),
  tzhtsl        NUMBER(16,6),
  dlckhwzmhm    VARCHAR2(20),
  bz            VARCHAR2(3000),
  lrr_dm        CHAR(11),
  lrrq          DATE,
  xgr_dm        CHAR(11),
  xgrq          DATE,
  tsswjg_dm_1   CHAR(11),
  sjgsdq        CHAR(11),
  sjtb_sj       TIMESTAMP(6),
  sbhgspmc      VARCHAR2(500),
  hgckhwbgdsbrq DATE,
  tbrq_1        DATE
)
;
comment on table CKTS_SB_FZC_HGSPTZ_LSB
  is '出口非自产货物退消费税海关出口商品代码名称退税率调整对应申报临时表';
comment on column CKTS_SB_FZC_HGSPTZ_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_FZC_HGSPTZ_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_FZC_HGSPTZ_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_FZC_HGSPTZ_LSB.ssq
  is '所属期';
comment on column CKTS_SB_FZC_HGSPTZ_LSB.sbxh
  is '申报序号';
comment on column CKTS_SB_FZC_HGSPTZ_LSB.ckbgdh
  is '出口报关单号';
comment on column CKTS_SB_FZC_HGSPTZ_LSB.ckrq_1
  is '出口日期';
comment on column CKTS_SB_FZC_HGSPTZ_LSB.cksp_dm
  is '出口商品代码';
comment on column CKTS_SB_FZC_HGSPTZ_LSB.tsl
  is '退税率';
comment on column CKTS_SB_FZC_HGSPTZ_LSB.tzhcksp_dm
  is '调整后出口商品代码';
comment on column CKTS_SB_FZC_HGSPTZ_LSB.tzhhgspmc
  is '调整后海关商品名称';
comment on column CKTS_SB_FZC_HGSPTZ_LSB.tzhtsl
  is '调整后退税率';
comment on column CKTS_SB_FZC_HGSPTZ_LSB.dlckhwzmhm
  is '代理出口货物证明号码';
comment on column CKTS_SB_FZC_HGSPTZ_LSB.bz
  is '备注';
comment on column CKTS_SB_FZC_HGSPTZ_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_FZC_HGSPTZ_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_FZC_HGSPTZ_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_FZC_HGSPTZ_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_FZC_HGSPTZ_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_FZC_HGSPTZ_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_FZC_HGSPTZ_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_FZC_HGSPTZ_LSB.sbhgspmc
  is '申报海关商品名称||申报海关商品名称';
comment on column CKTS_SB_FZC_HGSPTZ_LSB.hgckhwbgdsbrq
  is '海关出口货物报关单申报日期';
comment on column CKTS_SB_FZC_HGSPTZ_LSB.tbrq_1
  is '填表日期';
create index IDX_CKTS_SB_FZC_HGSPTZ_LSB_1 on CKTS_SB_FZC_HGSPTZ_LSB (SBID);
create index IDX_CKTS_SB_FZC_HGSPTZ_LSB_2 on CKTS_SB_FZC_HGSPTZ_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_FZC_SBMX_LSB
prompt ===================================
prompt
create table CKTS_SB_FZC_SBMX_LSB
(
  sbid          NUMBER(18),
  qyhgdm        VARCHAR2(20),
  djxh          NUMBER(20),
  ssq           VARCHAR2(60),
  sbpc          VARCHAR2(75),
  sbxh          VARCHAR2(50),
  xfspzh        VARCHAR2(40),
  kprq          DATE,
  cksp_dm       VARCHAR2(20),
  hgjldwmc      VARCHAR2(75),
  sl            NUMBER(17,5),
  zssl          NUMBER(16,6),
  jsje          NUMBER(18,2),
  se            NUMBER(18,6),
  xfstse        NUMBER(18,6),
  ckbgdh        VARCHAR2(21),
  dlckhwzmhm    VARCHAR2(20),
  cksl          NUMBER(17,5),
  cktmsywlxdmjh VARCHAR2(30),
  cktmsywlxmcjh VARCHAR2(75),
  bz            VARCHAR2(3000),
  tbrq_1        DATE,
  lrr_dm        CHAR(11),
  lrrq          DATE,
  xgr_dm        CHAR(11),
  xgrq          DATE,
  tsswjg_dm_1   CHAR(11),
  sjgsdq        CHAR(11),
  sjtb_sj       TIMESTAMP(6),
  sbhgspmc      VARCHAR2(500),
  cktmspzlx_dm  CHAR(2),
  gnqyfs_dm     VARCHAR2(2),
  hgzsrzqylx_dm VARCHAR2(2)
)
;
comment on table CKTS_SB_FZC_SBMX_LSB
  is '出口非自产货物退消费税申报临时表';
comment on column CKTS_SB_FZC_SBMX_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_FZC_SBMX_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_FZC_SBMX_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_FZC_SBMX_LSB.ssq
  is '所属期';
comment on column CKTS_SB_FZC_SBMX_LSB.sbxh
  is '申报序号';
comment on column CKTS_SB_FZC_SBMX_LSB.xfspzh
  is '消费税凭证号';
comment on column CKTS_SB_FZC_SBMX_LSB.kprq
  is '开票日期';
comment on column CKTS_SB_FZC_SBMX_LSB.cksp_dm
  is '出口商品代码';
comment on column CKTS_SB_FZC_SBMX_LSB.hgjldwmc
  is '海关计量单位名称';
comment on column CKTS_SB_FZC_SBMX_LSB.sl
  is '数量';
comment on column CKTS_SB_FZC_SBMX_LSB.zssl
  is '征税税率';
comment on column CKTS_SB_FZC_SBMX_LSB.jsje
  is '计税金额';
comment on column CKTS_SB_FZC_SBMX_LSB.se
  is '税额';
comment on column CKTS_SB_FZC_SBMX_LSB.xfstse
  is '消费税退税额';
comment on column CKTS_SB_FZC_SBMX_LSB.ckbgdh
  is '出口报关单号';
comment on column CKTS_SB_FZC_SBMX_LSB.dlckhwzmhm
  is '代理出口货物证明号码';
comment on column CKTS_SB_FZC_SBMX_LSB.cksl
  is '出口数量';
comment on column CKTS_SB_FZC_SBMX_LSB.cktmsywlxdmjh
  is '出口退（免）税业务类型代码集合';
comment on column CKTS_SB_FZC_SBMX_LSB.cktmsywlxmcjh
  is '出口退（免）税业务类型名称集合';
comment on column CKTS_SB_FZC_SBMX_LSB.bz
  is '备注';
comment on column CKTS_SB_FZC_SBMX_LSB.tbrq_1
  is '填表日期';
comment on column CKTS_SB_FZC_SBMX_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_FZC_SBMX_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_FZC_SBMX_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_FZC_SBMX_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_FZC_SBMX_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_FZC_SBMX_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_FZC_SBMX_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_FZC_SBMX_LSB.sbhgspmc
  is '申报海关商品名称||申报海关商品名称';
comment on column CKTS_SB_FZC_SBMX_LSB.cktmspzlx_dm
  is '出口退(免)税凭证类型代码';
comment on column CKTS_SB_FZC_SBMX_LSB.gnqyfs_dm
  is '国内启运方式代码';
comment on column CKTS_SB_FZC_SBMX_LSB.hgzsrzqylx_dm
  is '海关总署认证企业类型代码';
create index IDX_CKTS_SB_FZC_SBMX_LSB_1 on CKTS_SB_FZC_SBMX_LSB (SBID);
create index IDX_CKTS_SB_FZC_SBMX_LSB_2 on CKTS_SB_FZC_SBMX_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_GJ_SBMX_LSB
prompt ==================================
prompt
create table CKTS_SB_GJ_SBMX_LSB
(
  sbid          NUMBER(18),
  qyhgdm        VARCHAR2(20),
  djxh          NUMBER(20),
  ssq           VARCHAR2(60),
  sbpc          VARCHAR2(75),
  sbxh          VARCHAR2(50),
  gjzyhwmc      VARCHAR2(500),
  sl            NUMBER(17,5),
  hgjldwmc      VARCHAR2(75),
  dj            NUMBER(18,2),
  jsje          NUMBER(18,2),
  se            NUMBER(18,6),
  zssl          NUMBER(16,6),
  tse           NUMBER(18,6),
  fkpzhm        VARCHAR2(40),
  cktmsywlxdmjh VARCHAR2(30),
  cktmsywlxmcjh VARCHAR2(75),
  bz            VARCHAR2(3000),
  tbrq_1        DATE,
  lrr_dm        CHAR(11),
  lrrq          DATE,
  xgr_dm        CHAR(11),
  xgrq          DATE,
  tsswjg_dm_1   CHAR(11),
  sjgsdq        CHAR(11),
  sjtb_sj       TIMESTAMP(6),
  kprq          DATE,
  ptfpbz        CHAR(1),
  ghfnsrsbh_1   VARCHAR2(20),
  jhpzh         VARCHAR2(75),
  jhpzzl_dm     CHAR(1),
  zzszyfphm     VARCHAR2(30),
  fpdm          VARCHAR2(12),
  fphm          VARCHAR2(8)
)
;
comment on table CKTS_SB_GJ_SBMX_LSB
  is '购进自用货物退税申报临时表';
comment on column CKTS_SB_GJ_SBMX_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_GJ_SBMX_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_GJ_SBMX_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_GJ_SBMX_LSB.ssq
  is '所属期';
comment on column CKTS_SB_GJ_SBMX_LSB.sbxh
  is '申报序号';
comment on column CKTS_SB_GJ_SBMX_LSB.gjzyhwmc
  is '购进自用货物名称';
comment on column CKTS_SB_GJ_SBMX_LSB.sl
  is '数量';
comment on column CKTS_SB_GJ_SBMX_LSB.hgjldwmc
  is '海关计量单位名称';
comment on column CKTS_SB_GJ_SBMX_LSB.dj
  is '单价';
comment on column CKTS_SB_GJ_SBMX_LSB.jsje
  is '计税金额';
comment on column CKTS_SB_GJ_SBMX_LSB.se
  is '税额';
comment on column CKTS_SB_GJ_SBMX_LSB.zssl
  is '征税税率';
comment on column CKTS_SB_GJ_SBMX_LSB.tse
  is '退税额';
comment on column CKTS_SB_GJ_SBMX_LSB.fkpzhm
  is '付款凭证号码';
comment on column CKTS_SB_GJ_SBMX_LSB.cktmsywlxdmjh
  is '出口退（免）税业务类型代码集合';
comment on column CKTS_SB_GJ_SBMX_LSB.cktmsywlxmcjh
  is '出口退（免）税业务类型名称集合';
comment on column CKTS_SB_GJ_SBMX_LSB.bz
  is '备注';
comment on column CKTS_SB_GJ_SBMX_LSB.tbrq_1
  is '填表日期';
comment on column CKTS_SB_GJ_SBMX_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_GJ_SBMX_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_GJ_SBMX_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_GJ_SBMX_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_GJ_SBMX_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_GJ_SBMX_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_GJ_SBMX_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_GJ_SBMX_LSB.kprq
  is '开票日期';
comment on column CKTS_SB_GJ_SBMX_LSB.ptfpbz
  is '普通发票标志';
comment on column CKTS_SB_GJ_SBMX_LSB.ghfnsrsbh_1
  is '供货方纳税人识别号';
comment on column CKTS_SB_GJ_SBMX_LSB.jhpzh
  is '进货凭证号';
comment on column CKTS_SB_GJ_SBMX_LSB.jhpzzl_dm
  is '进货凭证种类代码';
comment on column CKTS_SB_GJ_SBMX_LSB.zzszyfphm
  is '增值税专用发票号码';
comment on column CKTS_SB_GJ_SBMX_LSB.fpdm
  is '发票代码（信息比对的时候通过JHPZH分解）';
comment on column CKTS_SB_GJ_SBMX_LSB.fphm
  is '发票号码（信息比对的时候通过JHPZH分解）';
create index IDX_CKTS_SB_GJ_SBMX_LSB_1 on CKTS_SB_GJ_SBMX_LSB (SBID);
create index IDX_CKTS_SB_GJ_SBMX_LSB_2 on CKTS_SB_GJ_SBMX_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_HT_SBMX_LSB
prompt ==================================
prompt
create table CKTS_SB_HT_SBMX_LSB
(
  sbid          NUMBER(18),
  qyhgdm        VARCHAR2(20),
  djxh          NUMBER(20),
  ssq           VARCHAR2(60),
  sbpc          VARCHAR2(75),
  sbxh          VARCHAR2(50),
  cksp_dm       VARCHAR2(20),
  jhpzh         VARCHAR2(75),
  sl            NUMBER(17,5),
  hgjldwmc      VARCHAR2(75),
  dj            NUMBER(18,2),
  jsje          NUMBER(18,2),
  se            NUMBER(18,6),
  zssl          NUMBER(16,6),
  tse           NUMBER(18,6),
  cktmsywlxdmjh VARCHAR2(30),
  cktmsywlxmcjh VARCHAR2(75),
  bz            VARCHAR2(3000),
  tbrq_1        DATE,
  lrr_dm        CHAR(11),
  lrrq          DATE,
  xgr_dm        CHAR(11),
  xgrq          DATE,
  tsswjg_dm_1   CHAR(11),
  sjgsdq        CHAR(11),
  sjtb_sj       TIMESTAMP(6),
  sbhgspmc      VARCHAR2(500),
  kprq          DATE,
  cktmspzlx_dm  CHAR(2)
)
;
comment on table CKTS_SB_HT_SBMX_LSB
  is '航天发射退税申报临时表';
comment on column CKTS_SB_HT_SBMX_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_HT_SBMX_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_HT_SBMX_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_HT_SBMX_LSB.ssq
  is '所属期';
comment on column CKTS_SB_HT_SBMX_LSB.sbxh
  is '申报序号';
comment on column CKTS_SB_HT_SBMX_LSB.cksp_dm
  is '出口商品代码';
comment on column CKTS_SB_HT_SBMX_LSB.jhpzh
  is '进货凭证号';
comment on column CKTS_SB_HT_SBMX_LSB.sl
  is '数量';
comment on column CKTS_SB_HT_SBMX_LSB.hgjldwmc
  is '海关计量单位名称';
comment on column CKTS_SB_HT_SBMX_LSB.dj
  is '单价';
comment on column CKTS_SB_HT_SBMX_LSB.jsje
  is '计税金额';
comment on column CKTS_SB_HT_SBMX_LSB.se
  is '税额';
comment on column CKTS_SB_HT_SBMX_LSB.zssl
  is '征税税率';
comment on column CKTS_SB_HT_SBMX_LSB.tse
  is '退税额';
comment on column CKTS_SB_HT_SBMX_LSB.cktmsywlxdmjh
  is '出口退（免）税业务类型代码集合';
comment on column CKTS_SB_HT_SBMX_LSB.cktmsywlxmcjh
  is '出口退（免）税业务类型名称集合';
comment on column CKTS_SB_HT_SBMX_LSB.bz
  is '备注';
comment on column CKTS_SB_HT_SBMX_LSB.tbrq_1
  is '填表日期';
comment on column CKTS_SB_HT_SBMX_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_HT_SBMX_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_HT_SBMX_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_HT_SBMX_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_HT_SBMX_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_HT_SBMX_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_HT_SBMX_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_HT_SBMX_LSB.sbhgspmc
  is '申报海关商品名称||申报海关商品名称';
comment on column CKTS_SB_HT_SBMX_LSB.kprq
  is '开票日期';
comment on column CKTS_SB_HT_SBMX_LSB.cktmspzlx_dm
  is '出口退(免)税凭证类型代码';
create index IDX_CKTS_SB_HT_SBMX_LSB_1 on CKTS_SB_HT_SBMX_LSB (SBID);
create index IDX_CKTS_SB_HT_SBMX_LSB_2 on CKTS_SB_HT_SBMX_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_MDT_BNSH_LSB
prompt ===================================
prompt
create table CKTS_SB_MDT_BNSH_LSB
(
  sbid         NUMBER(18),
  qyhgdm       VARCHAR2(20),
  djxh         NUMBER(20),
  ssq          VARCHAR2(60),
  sbpc         VARCHAR2(75),
  sbxh         VARCHAR2(50),
  ckbgdh       VARCHAR2(21),
  ckfph        VARCHAR2(30),
  jckxszrq     DATE,
  cjhbzm_dm    CHAR(3),
  cjzj         NUMBER(18,2),
  cjhbhl       NUMBER(16,6),
  ckxsermb     NUMBER(18,2),
  ckshhbzm_dm  CHAR(3),
  yshje        NUMBER(18,2),
  wshje        NUMBER(18,2),
  wshbl        NUMBER(10,6),
  bnshyy_dm    CHAR(2),
  bnshyymc     VARCHAR2(150),
  tgzmclzl     VARCHAR2(300),
  htydqbshzzrq DATE,
  ckhth        VARCHAR2(60),
  bz           VARCHAR2(3000),
  lrr_dm       CHAR(11),
  lrrq         DATE,
  xgr_dm       CHAR(11),
  xgrq         DATE,
  tsswjg_dm_1  CHAR(11),
  sjgsdq       CHAR(11),
  sjtb_sj      TIMESTAMP(6),
  tbrq_1       DATE
)
;
comment on table CKTS_SB_MDT_BNSH_LSB
  is '免抵退出口货物不能收汇申报(临时表)';
comment on column CKTS_SB_MDT_BNSH_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_MDT_BNSH_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_MDT_BNSH_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_MDT_BNSH_LSB.ssq
  is '所属期';
comment on column CKTS_SB_MDT_BNSH_LSB.sbxh
  is '申报序号';
comment on column CKTS_SB_MDT_BNSH_LSB.ckbgdh
  is '出口报关单号';
comment on column CKTS_SB_MDT_BNSH_LSB.ckfph
  is '出口发票号';
comment on column CKTS_SB_MDT_BNSH_LSB.jckxszrq
  is '记出口销售账日期';
comment on column CKTS_SB_MDT_BNSH_LSB.cjhbzm_dm
  is '成交货币字母代码';
comment on column CKTS_SB_MDT_BNSH_LSB.cjzj
  is '成交总价||成交总价';
comment on column CKTS_SB_MDT_BNSH_LSB.cjhbhl
  is '成交货币汇率';
comment on column CKTS_SB_MDT_BNSH_LSB.ckxsermb
  is '出口销售额（人民币）';
comment on column CKTS_SB_MDT_BNSH_LSB.ckshhbzm_dm
  is '出口收汇货币字母代码';
comment on column CKTS_SB_MDT_BNSH_LSB.yshje
  is '已收汇金额';
comment on column CKTS_SB_MDT_BNSH_LSB.wshje
  is '未收汇金额';
comment on column CKTS_SB_MDT_BNSH_LSB.wshbl
  is '未收汇比例';
comment on column CKTS_SB_MDT_BNSH_LSB.bnshyy_dm
  is '不能收汇原因代码';
comment on column CKTS_SB_MDT_BNSH_LSB.bnshyymc
  is '不能收汇原因名称';
comment on column CKTS_SB_MDT_BNSH_LSB.tgzmclzl
  is '提供证明材料种类';
comment on column CKTS_SB_MDT_BNSH_LSB.htydqbshzzrq
  is '合同约定全部收汇最终日期';
comment on column CKTS_SB_MDT_BNSH_LSB.ckhth
  is '出口合同号';
comment on column CKTS_SB_MDT_BNSH_LSB.bz
  is '备注';
comment on column CKTS_SB_MDT_BNSH_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_MDT_BNSH_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_MDT_BNSH_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_MDT_BNSH_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_MDT_BNSH_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_MDT_BNSH_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_MDT_BNSH_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_MDT_BNSH_LSB.tbrq_1
  is '填表日期';
create index IDX_CKTS_SB_MDT_BNSH_LSB_1 on CKTS_SB_MDT_BNSH_LSB (SBID);
create index IDX_CKTS_SB_MDT_BNSH_LSB_2 on CKTS_SB_MDT_BNSH_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_MDT_CKSH_LSB
prompt ===================================
prompt
create table CKTS_SB_MDT_CKSH_LSB
(
  sbid               NUMBER(18),
  qyhgdm             VARCHAR2(20),
  djxh               NUMBER(20),
  ssq                VARCHAR2(60),
  sbpc               VARCHAR2(75),
  sbxh               VARCHAR2(50),
  ckbgdh             VARCHAR2(21),
  ckfph              VARCHAR2(30),
  jckxszrq           DATE,
  cjhbzm_dm          CHAR(3),
  cjzj               NUMBER(18,2),
  cjhbhl             NUMBER(16,6),
  ckxsermb           NUMBER(18,2),
  pzhm_2             VARCHAR2(40),
  ckshrq             DATE,
  jhfs_dm            CHAR(1),
  jrjgdm             VARCHAR2(20),
  yhywbh             VARCHAR2(50),
  ckshhbzm_dm        CHAR(3),
  ckshje             NUMBER(18,2),
  ckshhbhl           NUMBER(16,6),
  ckshjermb          NUMBER(18,2),
  fhr                VARCHAR2(300),
  fhgjdq             VARCHAR2(300),
  fjksfhyy           VARCHAR2(75),
  fjkgjdqfhyy        VARCHAR2(75),
  bz                 VARCHAR2(3000),
  lrr_dm             CHAR(11),
  lrrq               DATE,
  xgr_dm             CHAR(11),
  xgrq               DATE,
  tsswjg_dm_1        CHAR(11),
  sjgsdq             CHAR(11),
  sjtb_sj            TIMESTAMP(6),
  tbrq_1             DATE,
  dlckhwzmhm         VARCHAR2(20),
  yshqkpzzje         NUMBER(18,2),
  stshqkyy           VARCHAR2(100),
  stshqkyyjtsm       VARCHAR2(4000),
  stshqkjzclzl       VARCHAR2(100),
  stshqkzrmbje       NUMBER(18,2),
  stshqkhtydqbshzzrq DATE,
  stshqkckhth        VARCHAR2(60)
)
;
comment on table CKTS_SB_MDT_CKSH_LSB
  is '免抵退出口货物收汇申报(临时表)';
comment on column CKTS_SB_MDT_CKSH_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_MDT_CKSH_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_MDT_CKSH_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_MDT_CKSH_LSB.ssq
  is '所属期';
comment on column CKTS_SB_MDT_CKSH_LSB.sbxh
  is '退免税申报情况||申报序号';
comment on column CKTS_SB_MDT_CKSH_LSB.ckbgdh
  is '退免税申报情况||出口报关单号';
comment on column CKTS_SB_MDT_CKSH_LSB.ckfph
  is '退免税申报情况||出口发票号';
comment on column CKTS_SB_MDT_CKSH_LSB.jckxszrq
  is '记出口销售账日期';
comment on column CKTS_SB_MDT_CKSH_LSB.cjhbzm_dm
  is '退免税申报情况||成交货币字母代码';
comment on column CKTS_SB_MDT_CKSH_LSB.cjzj
  is '退免税申报情况||成交总价';
comment on column CKTS_SB_MDT_CKSH_LSB.cjhbhl
  is '成交货币汇率';
comment on column CKTS_SB_MDT_CKSH_LSB.ckxsermb
  is '退免税申报情况||出口销售额（人民币）';
comment on column CKTS_SB_MDT_CKSH_LSB.pzhm_2
  is '已收汇情况||凭证号码';
comment on column CKTS_SB_MDT_CKSH_LSB.ckshrq
  is '已收汇情况||出口收汇日期';
comment on column CKTS_SB_MDT_CKSH_LSB.jhfs_dm
  is '结汇方式代码';
comment on column CKTS_SB_MDT_CKSH_LSB.jrjgdm
  is '金融机构代码';
comment on column CKTS_SB_MDT_CKSH_LSB.yhywbh
  is '银行业务编号';
comment on column CKTS_SB_MDT_CKSH_LSB.ckshhbzm_dm
  is '已收汇情况||出口收汇货币字母代码';
comment on column CKTS_SB_MDT_CKSH_LSB.ckshje
  is '已收汇情况||出口收汇金额';
comment on column CKTS_SB_MDT_CKSH_LSB.ckshhbhl
  is '出口收汇货币汇率';
comment on column CKTS_SB_MDT_CKSH_LSB.ckshjermb
  is '已收汇情况||出口收汇金额（人民币）';
comment on column CKTS_SB_MDT_CKSH_LSB.fhr
  is '已收汇情况||付汇人';
comment on column CKTS_SB_MDT_CKSH_LSB.fhgjdq
  is '付汇国家（地区）';
comment on column CKTS_SB_MDT_CKSH_LSB.fjksfhyy
  is '已收汇情况||非进口商付汇原因';
comment on column CKTS_SB_MDT_CKSH_LSB.fjkgjdqfhyy
  is '非进口国家（地区）付汇原因';
comment on column CKTS_SB_MDT_CKSH_LSB.bz
  is '退免税申报情况||备注';
comment on column CKTS_SB_MDT_CKSH_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_MDT_CKSH_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_MDT_CKSH_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_MDT_CKSH_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_MDT_CKSH_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_MDT_CKSH_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_MDT_CKSH_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_MDT_CKSH_LSB.tbrq_1
  is '填表日期';
comment on column CKTS_SB_MDT_CKSH_LSB.dlckhwzmhm
  is '退免税申报情况||代理出口货物证明号码';
comment on column CKTS_SB_MDT_CKSH_LSB.yshqkpzzje
  is '已收汇情况||凭证总金额';
comment on column CKTS_SB_MDT_CKSH_LSB.stshqkyy
  is '视同收汇情况||原因';
comment on column CKTS_SB_MDT_CKSH_LSB.stshqkyyjtsm
  is '视同收汇情况||原因具体说明';
comment on column CKTS_SB_MDT_CKSH_LSB.stshqkjzclzl
  is '视同收汇情况||举证材料种类';
comment on column CKTS_SB_MDT_CKSH_LSB.stshqkzrmbje
  is '视同收汇情况||折人民币金额';
comment on column CKTS_SB_MDT_CKSH_LSB.stshqkhtydqbshzzrq
  is '视同收汇情况||合同约定全部收汇最终日期';
comment on column CKTS_SB_MDT_CKSH_LSB.stshqkckhth
  is '视同收汇情况||出口合同号';
create index IDX_CKTS_SB_MDT_CKSH_LSB_1 on CKTS_SB_MDT_CKSH_LSB (SBID);
create index IDX_CKTS_SB_MDT_CKSH_LSB_2 on CKTS_SB_MDT_CKSH_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_MDT_CYSM_LSB
prompt ===================================
prompt
create table CKTS_SB_MDT_CYSM_LSB
(
  sbid                NUMBER(18),
  qyhgdm              VARCHAR2(20),
  djxh                NUMBER(20),
  lajcysblx_dm        CHAR(1),
  tbrq_1              DATE,
  sbxh                VARCHAR2(50),
  ckfph               VARCHAR2(30),
  ckfpmylaj           NUMBER(18,2),
  ckfprmblaj          NUMBER(18,2),
  ckbgdh              VARCHAR2(21),
  dlckhwzmhm          VARCHAR2(20),
  mylaj               NUMBER(18,2),
  rmblaj              NUMBER(18,2),
  ckfphckbgdrmblajcye NUMBER(18,2),
  ckfphckbgdrmblajcyl NUMBER(22,6),
  yysm                VARCHAR2(4000),
  lrr_dm              CHAR(11),
  lrrq                DATE,
  xgr_dm              CHAR(11),
  xgrq                DATE,
  tsswjg_dm_1         CHAR(11),
  sjgsdq              CHAR(11),
  sjtb_sj             TIMESTAMP(6),
  sbpc                VARCHAR2(75),
  ssq                 VARCHAR2(60)
)
;
comment on table CKTS_SB_MDT_CYSM_LSB
  is '出口货物离岸价差异说明(临时表)';
comment on column CKTS_SB_MDT_CYSM_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_MDT_CYSM_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_MDT_CYSM_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_MDT_CYSM_LSB.lajcysblx_dm
  is '离岸价差异申报类型代码';
comment on column CKTS_SB_MDT_CYSM_LSB.tbrq_1
  is '填表日期';
comment on column CKTS_SB_MDT_CYSM_LSB.sbxh
  is '申报序号';
comment on column CKTS_SB_MDT_CYSM_LSB.ckfph
  is '出口发票号';
comment on column CKTS_SB_MDT_CYSM_LSB.ckfpmylaj
  is '出口发票美元离岸价';
comment on column CKTS_SB_MDT_CYSM_LSB.ckfprmblaj
  is '出口发票人民币离岸价';
comment on column CKTS_SB_MDT_CYSM_LSB.ckbgdh
  is '出口报关单号';
comment on column CKTS_SB_MDT_CYSM_LSB.dlckhwzmhm
  is '代理出口货物证明号码';
comment on column CKTS_SB_MDT_CYSM_LSB.mylaj
  is '美元离岸价';
comment on column CKTS_SB_MDT_CYSM_LSB.rmblaj
  is '人民币离岸价';
comment on column CKTS_SB_MDT_CYSM_LSB.ckfphckbgdrmblajcye
  is '出口发票和出口报关单人民币离岸价差异额';
comment on column CKTS_SB_MDT_CYSM_LSB.ckfphckbgdrmblajcyl
  is '出口发票和出口报关单人民币离岸价差异率';
comment on column CKTS_SB_MDT_CYSM_LSB.yysm
  is '原因说明';
comment on column CKTS_SB_MDT_CYSM_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_MDT_CYSM_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_MDT_CYSM_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_MDT_CYSM_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_MDT_CYSM_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_MDT_CYSM_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_MDT_CYSM_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_MDT_CYSM_LSB.ssq
  is '所属期';
create index IDX_CKTS_SB_MDT_CYSM_LSB_1 on CKTS_SB_MDT_CYSM_LSB (SBID);
create index IDX_CKTS_SB_MDT_CYSM_LSB_2 on CKTS_SB_MDT_CYSM_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_MDT_GJYS_LSB
prompt ===================================
prompt
create table CKTS_SB_MDT_GJYS_LSB
(
  sbid               NUMBER(18),
  qyhgdm             VARCHAR2(20),
  djxh               NUMBER(20),
  ssq                VARCHAR2(60),
  sbpc               VARCHAR2(75),
  sbxh               VARCHAR2(50),
  ysfw_dm            VARCHAR2(20),
  ysfwmc             VARCHAR2(500),
  bcyscs             NUMBER(10),
  zycdfs             NUMBER(10),
  zytdydfshzkrs      NUMBER(10),
  ysfwyyermb         NUMBER(18,2),
  zssl               NUMBER(16,6),
  tsl                NUMBER(16,6),
  ztsce              NUMBER(18,6),
  ytse_1             NUMBER(18,6),
  hth                VARCHAR2(60),
  bz                 VARCHAR2(3000),
  ckfph              VARCHAR2(30),
  kprq               DATE,
  myhl               NUMBER(16,6),
  ysfwyyemy          NUMBER(18,2),
  mdtsny             CHAR(6),
  cjhbzm_dm          CHAR(3),
  cjzj               NUMBER(18,2),
  lrr_dm             CHAR(11),
  lrrq               DATE,
  xgr_dm             CHAR(11),
  xgrq               DATE,
  tsswjg_dm_1        CHAR(11),
  sjgsdq             CHAR(11),
  sjtb_sj            TIMESTAMP(6),
  ysfwyyezfgfsdnsrjk NUMBER(18,2),
  ysfwyyemdtsjsje    NUMBER(18,2),
  zbblny             VARCHAR2(6),
  bytsny             CHAR(6),
  ckrq_1             DATE
)
;
comment on table CKTS_SB_MDT_GJYS_LSB
  is '国际运输明细申报(临时表)';
comment on column CKTS_SB_MDT_GJYS_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_MDT_GJYS_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_MDT_GJYS_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_MDT_GJYS_LSB.ssq
  is '所属期';
comment on column CKTS_SB_MDT_GJYS_LSB.sbxh
  is '申报序号';
comment on column CKTS_SB_MDT_GJYS_LSB.ysfw_dm
  is '应税服务代码';
comment on column CKTS_SB_MDT_GJYS_LSB.ysfwmc
  is '应税服务名称';
comment on column CKTS_SB_MDT_GJYS_LSB.bcyscs
  is '本次运输次数';
comment on column CKTS_SB_MDT_GJYS_LSB.zycdfs
  is '自运舱单份数';
comment on column CKTS_SB_MDT_GJYS_LSB.zytdydfshzkrs
  is '自运提单（运单）份数或载客人数';
comment on column CKTS_SB_MDT_GJYS_LSB.ysfwyyermb
  is '应税服务营业额（人民币）';
comment on column CKTS_SB_MDT_GJYS_LSB.zssl
  is '征税税率';
comment on column CKTS_SB_MDT_GJYS_LSB.tsl
  is '退税率';
comment on column CKTS_SB_MDT_GJYS_LSB.ztsce
  is '征退税差额';
comment on column CKTS_SB_MDT_GJYS_LSB.ytse_1
  is '应退税额';
comment on column CKTS_SB_MDT_GJYS_LSB.hth
  is '合同号';
comment on column CKTS_SB_MDT_GJYS_LSB.bz
  is '备注';
comment on column CKTS_SB_MDT_GJYS_LSB.ckfph
  is '出口发票号';
comment on column CKTS_SB_MDT_GJYS_LSB.kprq
  is '开票日期';
comment on column CKTS_SB_MDT_GJYS_LSB.myhl
  is '美元汇率';
comment on column CKTS_SB_MDT_GJYS_LSB.ysfwyyemy
  is '应税服务营业额（美元）';
comment on column CKTS_SB_MDT_GJYS_LSB.mdtsny
  is '免抵退税年月';
comment on column CKTS_SB_MDT_GJYS_LSB.cjhbzm_dm
  is '成交货币字母代码';
comment on column CKTS_SB_MDT_GJYS_LSB.cjzj
  is '成交总价||成交总价';
comment on column CKTS_SB_MDT_GJYS_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_MDT_GJYS_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_MDT_GJYS_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_MDT_GJYS_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_MDT_GJYS_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_MDT_GJYS_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_MDT_GJYS_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_MDT_GJYS_LSB.ysfwyyezfgfsdnsrjk
  is '应税服务营业额支付给非试点纳税人价款';
comment on column CKTS_SB_MDT_GJYS_LSB.ysfwyyemdtsjsje
  is '应税服务营业额免抵退税计税金额';
comment on column CKTS_SB_MDT_GJYS_LSB.zbblny
  is '暂不办理年月';
comment on column CKTS_SB_MDT_GJYS_LSB.bytsny
  is '不予退税年月';
comment on column CKTS_SB_MDT_GJYS_LSB.ckrq_1
  is '出口日期';
create index IDX_CKTS_SB_MDT_GJYS_LSB_1 on CKTS_SB_MDT_GJYS_LSB (SBID);
create index IDX_CKTS_SB_MDT_GJYS_LSB_2 on CKTS_SB_MDT_GJYS_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_MDT_HGSPTZ_LSB
prompt =====================================
prompt
create table CKTS_SB_MDT_HGSPTZ_LSB
(
  sbid          NUMBER(18),
  qyhgdm        VARCHAR2(20),
  djxh          NUMBER(20),
  sbxh          VARCHAR2(50),
  ckbgdh        VARCHAR2(21),
  ckrq_1        DATE,
  cksp_dm       VARCHAR2(20),
  ckspmc        VARCHAR2(75),
  tsl           NUMBER(16,6),
  tzhcksp_dm    VARCHAR2(20),
  tzhhgspmc     VARCHAR2(500),
  tzhtsl        NUMBER(16,6),
  dlckhwzmhm    VARCHAR2(20),
  bz            VARCHAR2(3000),
  lrr_dm        CHAR(11),
  lrrq          DATE,
  xgr_dm        CHAR(11),
  xgrq          DATE,
  tsswjg_dm_1   CHAR(11),
  sjgsdq        CHAR(11),
  sjtb_sj       TIMESTAMP(6),
  ssq           VARCHAR2(60),
  sbpc          VARCHAR2(75),
  tbrq_1        DATE,
  hgckhwbgdsbrq DATE,
  sbhgspmc      VARCHAR2(500)
)
;
comment on table CKTS_SB_MDT_HGSPTZ_LSB
  is '免抵退海关出口商品调整对应（临时表）';
comment on column CKTS_SB_MDT_HGSPTZ_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_MDT_HGSPTZ_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_MDT_HGSPTZ_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_MDT_HGSPTZ_LSB.sbxh
  is '申报序号';
comment on column CKTS_SB_MDT_HGSPTZ_LSB.ckbgdh
  is '出口报关单号';
comment on column CKTS_SB_MDT_HGSPTZ_LSB.ckrq_1
  is '出口日期';
comment on column CKTS_SB_MDT_HGSPTZ_LSB.cksp_dm
  is '出口商品代码';
comment on column CKTS_SB_MDT_HGSPTZ_LSB.ckspmc
  is '出口商品名称';
comment on column CKTS_SB_MDT_HGSPTZ_LSB.tsl
  is '退税率';
comment on column CKTS_SB_MDT_HGSPTZ_LSB.tzhcksp_dm
  is '调整后出口商品代码';
comment on column CKTS_SB_MDT_HGSPTZ_LSB.tzhhgspmc
  is '调整后海关商品名称';
comment on column CKTS_SB_MDT_HGSPTZ_LSB.tzhtsl
  is '调整后退税率';
comment on column CKTS_SB_MDT_HGSPTZ_LSB.dlckhwzmhm
  is '代理出口货物证明号码';
comment on column CKTS_SB_MDT_HGSPTZ_LSB.bz
  is '备注';
comment on column CKTS_SB_MDT_HGSPTZ_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_MDT_HGSPTZ_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_MDT_HGSPTZ_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_MDT_HGSPTZ_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_MDT_HGSPTZ_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_MDT_HGSPTZ_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_MDT_HGSPTZ_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_MDT_HGSPTZ_LSB.ssq
  is '所属期';
comment on column CKTS_SB_MDT_HGSPTZ_LSB.tbrq_1
  is '填表日期';
comment on column CKTS_SB_MDT_HGSPTZ_LSB.hgckhwbgdsbrq
  is '海关出口货物报关单申报日期';
comment on column CKTS_SB_MDT_HGSPTZ_LSB.sbhgspmc
  is '申报海关商品名称||申报海关商品名称';
create index IDX_CKTS_SB_MDT_HGSPTZ_LSB_1 on CKTS_SB_MDT_HGSPTZ_LSB (SBID);
create index IDX_CKTS_SB_MDT_HGSPTZ_LSB_2 on CKTS_SB_MDT_HGSPTZ_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_MDT_HKYS_QS_LSB
prompt ======================================
prompt
create table CKTS_SB_MDT_HKYS_QS_LSB
(
  sbid          NUMBER(18),
  qyhgdm        VARCHAR2(20),
  djxh          NUMBER(20),
  ssq           VARCHAR2(60),
  sbpc          VARCHAR2(75),
  sbxh          VARCHAR2(50),
  hkgjqszdlb_dm CHAR(2),
  hkgjyslb_dm   CHAR(2),
  qszdbh        VARCHAR2(32),
  kjrq          DATE,
  gjhdqmc       VARCHAR2(300),
  hbzm_dm       CHAR(3),
  kpphhdhm      VARCHAR2(60),
  cjzj          NUMBER(18,2),
  cjhbhl        NUMBER(16,6),
  qsqkjermb     NUMBER(18,2),
  bz            VARCHAR2(3000),
  lrr_dm        CHAR(11),
  lrrq          DATE,
  xgr_dm        CHAR(11),
  xgrq          DATE,
  tsswjg_dm_1   CHAR(11),
  sjgsdq        CHAR(11),
  sjtb_sj       TIMESTAMP(6)
)
;
comment on table CKTS_SB_MDT_HKYS_QS_LSB
  is '航空运输收入清算明细(临时表)';
comment on column CKTS_SB_MDT_HKYS_QS_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_MDT_HKYS_QS_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_MDT_HKYS_QS_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_MDT_HKYS_QS_LSB.ssq
  is '所属期';
comment on column CKTS_SB_MDT_HKYS_QS_LSB.sbxh
  is '申报序号';
comment on column CKTS_SB_MDT_HKYS_QS_LSB.hkgjqszdlb_dm
  is '航空国际清算账单类别代码';
comment on column CKTS_SB_MDT_HKYS_QS_LSB.hkgjyslb_dm
  is '航空国际运输类别代码';
comment on column CKTS_SB_MDT_HKYS_QS_LSB.qszdbh
  is '清算账单编号';
comment on column CKTS_SB_MDT_HKYS_QS_LSB.kjrq
  is '开具日期';
comment on column CKTS_SB_MDT_HKYS_QS_LSB.gjhdqmc
  is '国家或地区名称';
comment on column CKTS_SB_MDT_HKYS_QS_LSB.hbzm_dm
  is '货币字母代码';
comment on column CKTS_SB_MDT_HKYS_QS_LSB.kpphhdhm
  is '客票票号/货单号码';
comment on column CKTS_SB_MDT_HKYS_QS_LSB.cjzj
  is '成交总价||成交总价';
comment on column CKTS_SB_MDT_HKYS_QS_LSB.cjhbhl
  is '成交货币汇率';
comment on column CKTS_SB_MDT_HKYS_QS_LSB.qsqkjermb
  is '清算情况金额（人民币）';
comment on column CKTS_SB_MDT_HKYS_QS_LSB.bz
  is '备注';
comment on column CKTS_SB_MDT_HKYS_QS_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_MDT_HKYS_QS_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_MDT_HKYS_QS_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_MDT_HKYS_QS_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_MDT_HKYS_QS_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_MDT_HKYS_QS_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_MDT_HKYS_QS_LSB.sjtb_sj
  is '数据同步时间';
create index IDX_CKTS_SB_MDT_HKYS_QS_LSB_1 on CKTS_SB_MDT_HKYS_QS_LSB (SBID);
create index IDX_CKTS_SB_MDT_HKYS_QS_LSB_2 on CKTS_SB_MDT_HKYS_QS_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_MDT_KYHJ_LSB
prompt ===================================
prompt
create table CKTS_SB_MDT_KYHJ_LSB
(
  sbid          NUMBER(18),
  qyhgdm        VARCHAR2(20),
  djxh          NUMBER(20),
  ssq           VARCHAR2(60),
  sbpc          VARCHAR2(75),
  sbxh          VARCHAR2(50),
  gjkyqshjlb_dm CHAR(2),
  hjbh          VARCHAR2(50),
  kjrq          DATE,
  gjhdqmc       VARCHAR2(300),
  cjhbzm_dm     CHAR(3),
  cjzj          NUMBER(18,2),
  cjhbhl        NUMBER(16,6),
  gsyzfndjermb  NUMBER(18,2),
  myhl          NUMBER(16,6),
  gsyzfndjemy   NUMBER(18,2),
  bz            VARCHAR2(3000),
  lrr_dm        CHAR(11),
  lrrq          DATE,
  xgr_dm        CHAR(11),
  xgrq          DATE,
  tsswjg_dm_1   CHAR(11),
  sjgsdq        CHAR(11),
  sjtb_sj       TIMESTAMP(6)
)
;
comment on table CKTS_SB_MDT_KYHJ_LSB
  is '国际客运（含香港直通车）旅客、行李包裹运输清算函件明细受理表(临时表)';
comment on column CKTS_SB_MDT_KYHJ_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_MDT_KYHJ_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_MDT_KYHJ_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_MDT_KYHJ_LSB.ssq
  is '所属期';
comment on column CKTS_SB_MDT_KYHJ_LSB.sbxh
  is '申报序号';
comment on column CKTS_SB_MDT_KYHJ_LSB.gjkyqshjlb_dm
  is '国际客运清算函件类别代码';
comment on column CKTS_SB_MDT_KYHJ_LSB.hjbh
  is '函件编号';
comment on column CKTS_SB_MDT_KYHJ_LSB.kjrq
  is '开具日期';
comment on column CKTS_SB_MDT_KYHJ_LSB.gjhdqmc
  is '国家或地区名称';
comment on column CKTS_SB_MDT_KYHJ_LSB.cjhbzm_dm
  is '成交货币字母代码';
comment on column CKTS_SB_MDT_KYHJ_LSB.cjzj
  is '成交总价||成交总价';
comment on column CKTS_SB_MDT_KYHJ_LSB.cjhbhl
  is '成交货币汇率';
comment on column CKTS_SB_MDT_KYHJ_LSB.gsyzfndjermb
  is '归属于中方（内地）金额人民币';
comment on column CKTS_SB_MDT_KYHJ_LSB.myhl
  is '美元汇率';
comment on column CKTS_SB_MDT_KYHJ_LSB.gsyzfndjemy
  is '归属于中方（内地）金额美元';
comment on column CKTS_SB_MDT_KYHJ_LSB.bz
  is '备注';
comment on column CKTS_SB_MDT_KYHJ_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_MDT_KYHJ_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_MDT_KYHJ_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_MDT_KYHJ_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_MDT_KYHJ_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_MDT_KYHJ_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_MDT_KYHJ_LSB.sjtb_sj
  is '数据同步时间';
create index IDX_CKTS_SB_MDT_KYHJ_LSB_1 on CKTS_SB_MDT_KYHJ_LSB (SBID);
create index IDX_CKTS_SB_MDT_KYHJ_LSB_2 on CKTS_SB_MDT_KYHJ_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_MDT_SBHZ_LSB
prompt ===================================
prompt
create table CKTS_SB_MDT_SBHZ_LSB
(
  sbid                   NUMBER(18),
  qyhgdm                 VARCHAR2(20),
  djxh                   NUMBER(20),
  ssq                    VARCHAR2(60),
  sbpc                   VARCHAR2(75),
  ckxsemy                NUMBER(18,2),
  ckhwxsemy              NUMBER(18,2),
  ysfwxsemy              NUMBER(18,2),
  ckxsermb               NUMBER(18,2),
  mdtsbdmzhdkse          NUMBER(18,6),
  ckhwbdmzhdkse          NUMBER(18,6),
  ysfwbdmzhdkse          NUMBER(18,6),
  jljghxytzbdmzhdkse     NUMBER(18,6),
  mdtsbdmzhdksehj        NUMBER(18,6),
  mdtse                  NUMBER(18,6),
  ckhwmdtse              NUMBER(18,6),
  ysfwmdtse              NUMBER(18,6),
  sqjzmdtse              NUMBER(18,6),
  jljghxytzmdtse         NUMBER(18,6),
  mdtsehj                NUMBER(18,6),
  jzxqmdtse              NUMBER(18,6),
  zzsnssbbqmldse         NUMBER(18,6),
  ytse_1                 NUMBER(18,6),
  mdse                   NUMBER(18,6),
  bnljmdtckxsemy         NUMBER(18,2),
  bnljckhwxsemy          NUMBER(18,2),
  bnljysfwxsemy          NUMBER(18,2),
  bnljmdtckxsermb        NUMBER(18,2),
  bnljmdtsbdmzhdkse      NUMBER(18,6),
  bnljckhwbdmzhdkse      NUMBER(18,6),
  bnljysfwbdmzhdkse      NUMBER(18,6),
  bnljjljghxytzbdmzhdkse NUMBER(18,6),
  bnljmdtsbdmzhdksehj    NUMBER(18,6),
  bnljmdtse              NUMBER(18,6),
  bnljckhwmdtse          NUMBER(18,6),
  bnljysfwmdtse          NUMBER(18,6),
  bnljjljghxytzmdtse     NUMBER(18,6),
  bnljmdtsehj            NUMBER(18,6),
  bnljytse               NUMBER(18,6),
  bnljmdse               NUMBER(18,6),
  sqrmc                  VARCHAR2(300),
  smrxm                  VARCHAR2(150),
  lrr_dm                 CHAR(11),
  lrrq                   DATE,
  xgr_dm                 CHAR(11),
  xgrq                   DATE,
  tsswjg_dm_1            CHAR(11),
  sjgsdq                 CHAR(11),
  sjtb_sj                TIMESTAMP(6),
  bdmzdkseynsbce         NUMBER(18,6)
)
;
comment on table CKTS_SB_MDT_SBHZ_LSB
  is '免抵退税申报汇总表(临时表)';
comment on column CKTS_SB_MDT_SBHZ_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_MDT_SBHZ_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_MDT_SBHZ_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_MDT_SBHZ_LSB.ssq
  is '所属期';
comment on column CKTS_SB_MDT_SBHZ_LSB.ckxsemy
  is '出口销售额（美元）';
comment on column CKTS_SB_MDT_SBHZ_LSB.ckhwxsemy
  is '出口货物销售额（美元）';
comment on column CKTS_SB_MDT_SBHZ_LSB.ysfwxsemy
  is '应税服务销售额（美元）';
comment on column CKTS_SB_MDT_SBHZ_LSB.ckxsermb
  is '出口销售额（人民币）';
comment on column CKTS_SB_MDT_SBHZ_LSB.mdtsbdmzhdkse
  is '免抵退税不得免征和抵扣税额';
comment on column CKTS_SB_MDT_SBHZ_LSB.ckhwbdmzhdkse
  is '出口货物不得免征和抵扣税额';
comment on column CKTS_SB_MDT_SBHZ_LSB.ysfwbdmzhdkse
  is '应税服务不得免征和抵扣税额';
comment on column CKTS_SB_MDT_SBHZ_LSB.jljghxytzbdmzhdkse
  is '进料加工核销应调整不得免征和抵扣税额';
comment on column CKTS_SB_MDT_SBHZ_LSB.mdtsbdmzhdksehj
  is '免抵退税不得免征和抵扣税额合计';
comment on column CKTS_SB_MDT_SBHZ_LSB.mdtse
  is '免抵退税额';
comment on column CKTS_SB_MDT_SBHZ_LSB.ckhwmdtse
  is '出口货物免抵退税额';
comment on column CKTS_SB_MDT_SBHZ_LSB.ysfwmdtse
  is '应税服务免抵退税额';
comment on column CKTS_SB_MDT_SBHZ_LSB.sqjzmdtse
  is '上期结转免抵退税额';
comment on column CKTS_SB_MDT_SBHZ_LSB.jljghxytzmdtse
  is '进料加工核销应调整免抵退税额';
comment on column CKTS_SB_MDT_SBHZ_LSB.mdtsehj
  is '免抵退税额合计';
comment on column CKTS_SB_MDT_SBHZ_LSB.jzxqmdtse
  is '结转下期免抵退税额';
comment on column CKTS_SB_MDT_SBHZ_LSB.zzsnssbbqmldse
  is '增值税纳税申报表期末留抵税额';
comment on column CKTS_SB_MDT_SBHZ_LSB.ytse_1
  is '应退税额';
comment on column CKTS_SB_MDT_SBHZ_LSB.mdse
  is '免抵税额';
comment on column CKTS_SB_MDT_SBHZ_LSB.bnljmdtckxsemy
  is '本年累计免抵退出口销售额（美元）';
comment on column CKTS_SB_MDT_SBHZ_LSB.bnljckhwxsemy
  is '本年累计出口货物销售额（美元）';
comment on column CKTS_SB_MDT_SBHZ_LSB.bnljysfwxsemy
  is '本年累计应税服务销售额（美元）';
comment on column CKTS_SB_MDT_SBHZ_LSB.bnljmdtckxsermb
  is '本年累计免抵退出口销售额（人民币）';
comment on column CKTS_SB_MDT_SBHZ_LSB.bnljmdtsbdmzhdkse
  is '本年累计免抵退税不得免征和抵扣税额';
comment on column CKTS_SB_MDT_SBHZ_LSB.bnljckhwbdmzhdkse
  is '本年累计出口货物不得免征和抵扣税额';
comment on column CKTS_SB_MDT_SBHZ_LSB.bnljysfwbdmzhdkse
  is '本年累计应税服务不得免征和抵扣税额';
comment on column CKTS_SB_MDT_SBHZ_LSB.bnljjljghxytzbdmzhdkse
  is '本年累计进料加工核销应调整不得免征和抵扣税额';
comment on column CKTS_SB_MDT_SBHZ_LSB.bnljmdtsbdmzhdksehj
  is '本年累计免抵退税不得免征和抵扣税额合计';
comment on column CKTS_SB_MDT_SBHZ_LSB.bnljmdtse
  is '本年累计免抵退税额';
comment on column CKTS_SB_MDT_SBHZ_LSB.bnljckhwmdtse
  is '本年累计出口货物免抵退税额';
comment on column CKTS_SB_MDT_SBHZ_LSB.bnljysfwmdtse
  is '本年累计应税服务免抵退税额';
comment on column CKTS_SB_MDT_SBHZ_LSB.bnljjljghxytzmdtse
  is '本年累计进料加工核销应调整免抵退税额';
comment on column CKTS_SB_MDT_SBHZ_LSB.bnljmdtsehj
  is '本年累计免抵退税额合计';
comment on column CKTS_SB_MDT_SBHZ_LSB.bnljytse
  is '本年累计应退税额';
comment on column CKTS_SB_MDT_SBHZ_LSB.bnljmdse
  is '本年累计免抵税额';
comment on column CKTS_SB_MDT_SBHZ_LSB.sqrmc
  is '授权人名称';
comment on column CKTS_SB_MDT_SBHZ_LSB.smrxm
  is '声明人姓名';
comment on column CKTS_SB_MDT_SBHZ_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_MDT_SBHZ_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_MDT_SBHZ_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_MDT_SBHZ_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_MDT_SBHZ_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_MDT_SBHZ_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_MDT_SBHZ_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_MDT_SBHZ_LSB.bdmzdkseynsbce
  is '不得免征抵扣税额与纳税表差额';
create index IDX_CKTS_SB_MDT_SBHZ_LSB_1 on CKTS_SB_MDT_SBHZ_LSB (SBID);
create index IDX_CKTS_SB_MDT_SBHZ_LSB_2 on CKTS_SB_MDT_SBHZ_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_MDT_STZCQD_LSB
prompt =====================================
prompt
create table CKTS_SB_MDT_STZCQD_LSB
(
  sbid        NUMBER(18),
  qyhgdm      VARCHAR2(20),
  djxh        NUMBER(20),
  sbxh        VARCHAR2(50),
  xhfnsrsbh   VARCHAR2(20),
  xhfnsrmc    VARCHAR2(300),
  kprq        DATE,
  ssq         VARCHAR2(60),
  sbpc        VARCHAR2(75),
  lrr_dm      CHAR(11),
  lrrq        DATE,
  xgr_dm      CHAR(11),
  xgrq        DATE,
  tsswjg_dm_1 CHAR(11),
  sjgsdq      CHAR(11),
  sjtb_sj     TIMESTAMP(6),
  mxsbxh      VARCHAR2(50),
  jhpzh       VARCHAR2(75)
)
;
comment on table CKTS_SB_MDT_STZCQD_LSB
  is '视同自产进货明细清单临时表';
comment on column CKTS_SB_MDT_STZCQD_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_MDT_STZCQD_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_MDT_STZCQD_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_MDT_STZCQD_LSB.sbxh
  is '申报序号';
comment on column CKTS_SB_MDT_STZCQD_LSB.xhfnsrsbh
  is '销货方纳税人识别号';
comment on column CKTS_SB_MDT_STZCQD_LSB.xhfnsrmc
  is '销货方纳税人名称';
comment on column CKTS_SB_MDT_STZCQD_LSB.kprq
  is '开票日期';
comment on column CKTS_SB_MDT_STZCQD_LSB.ssq
  is '所属期';
comment on column CKTS_SB_MDT_STZCQD_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_MDT_STZCQD_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_MDT_STZCQD_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_MDT_STZCQD_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_MDT_STZCQD_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_MDT_STZCQD_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_MDT_STZCQD_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_MDT_STZCQD_LSB.mxsbxh
  is '明细申报序号';
comment on column CKTS_SB_MDT_STZCQD_LSB.jhpzh
  is '进货凭证号';
create index IDX_CKTS_SB_MDT_STZCQD_LSB_1 on CKTS_SB_MDT_STZCQD_LSB (SBID);
create index IDX_CKTS_SB_MDT_STZCQD_LSB_2 on CKTS_SB_MDT_STZCQD_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_MDT_SYYK_LSB
prompt ===================================
prompt
create table CKTS_SB_MDT_SYYK_LSB
(
  sbid        NUMBER(18),
  qyhgdm      VARCHAR2(20),
  djxh        NUMBER(20),
  ssq         VARCHAR2(60),
  sbpc        VARCHAR2(75),
  sbxh        VARCHAR2(50),
  hth         VARCHAR2(60),
  skrq        DATE,
  skpzh       VARCHAR2(60),
  skjermb     NUMBER(18,2),
  myhl        NUMBER(16,6),
  skyhmc      VARCHAR2(120),
  fkdwmc      VARCHAR2(150),
  gjhdqsz_dm  CHAR(3),
  fkyhmc      VARCHAR2(120),
  ljysyykrmb  NUMBER(18,2),
  skjemy      NUMBER(18,2),
  skpzzjemy   NUMBER(18,2),
  ljysyykmy   NUMBER(18,2),
  hbzm_dm     CHAR(3),
  cjzj        NUMBER(18,2),
  lrr_dm      CHAR(11),
  lrrq        DATE,
  xgr_dm      CHAR(11),
  xgrq        DATE,
  tsswjg_dm_1 CHAR(11),
  sjgsdq      CHAR(11),
  sjtb_sj     TIMESTAMP(6),
  tbrq_1      DATE
)
;
comment on table CKTS_SB_MDT_SYYK_LSB
  is '提供增值税零税率应税服务收讫营业款明细清单(临时表)';
comment on column CKTS_SB_MDT_SYYK_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_MDT_SYYK_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_MDT_SYYK_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_MDT_SYYK_LSB.ssq
  is '所属期';
comment on column CKTS_SB_MDT_SYYK_LSB.sbxh
  is '申报序号';
comment on column CKTS_SB_MDT_SYYK_LSB.hth
  is '合同号';
comment on column CKTS_SB_MDT_SYYK_LSB.skrq
  is '收款日期';
comment on column CKTS_SB_MDT_SYYK_LSB.skpzh
  is '收款凭证号';
comment on column CKTS_SB_MDT_SYYK_LSB.skjermb
  is '收款金额（人民币）';
comment on column CKTS_SB_MDT_SYYK_LSB.myhl
  is '美元汇率';
comment on column CKTS_SB_MDT_SYYK_LSB.skyhmc
  is '收款银行名称';
comment on column CKTS_SB_MDT_SYYK_LSB.fkdwmc
  is '付款单位名称';
comment on column CKTS_SB_MDT_SYYK_LSB.gjhdqsz_dm
  is '国家或地区数字代码';
comment on column CKTS_SB_MDT_SYYK_LSB.fkyhmc
  is '付款银行名称';
comment on column CKTS_SB_MDT_SYYK_LSB.ljysyykrmb
  is '累计已收营业款（人民币）';
comment on column CKTS_SB_MDT_SYYK_LSB.skjemy
  is '收款金额（美元）';
comment on column CKTS_SB_MDT_SYYK_LSB.skpzzjemy
  is '收款凭证总金额（美元）';
comment on column CKTS_SB_MDT_SYYK_LSB.ljysyykmy
  is '累计已收营业款（美元）';
comment on column CKTS_SB_MDT_SYYK_LSB.hbzm_dm
  is '货币字母代码';
comment on column CKTS_SB_MDT_SYYK_LSB.cjzj
  is '成交总价||成交总价';
comment on column CKTS_SB_MDT_SYYK_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_MDT_SYYK_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_MDT_SYYK_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_MDT_SYYK_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_MDT_SYYK_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_MDT_SYYK_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_MDT_SYYK_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_MDT_SYYK_LSB.tbrq_1
  is '填表日期';
create index IDX_CKTS_SB_MDT_SYYK_LSB_1 on CKTS_SB_MDT_SYYK_LSB (SBID);
create index IDX_CKTS_SB_MDT_SYYK_LSB_2 on CKTS_SB_MDT_SYYK_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_MDT_TLHY_LSB
prompt ===================================
prompt
create table CKTS_SB_MDT_TLHY_LSB
(
  sbid         NUMBER(18),
  qyhgdm       VARCHAR2(20),
  djxh         NUMBER(20),
  yf           CHAR(2),
  sbxh         VARCHAR2(50),
  tlyslx_dm    CHAR(2),
  tlyslxmc     VARCHAR2(75),
  hphzje       NUMBER(18,2),
  gsqttlysqyje NUMBER(18,2),
  gshjcygtje   NUMBER(18,2),
  ykcje_1      NUMBER(18,2),
  qshysfwjsje  NUMBER(18,2),
  bz           VARCHAR2(3000),
  lrr_dm       CHAR(11),
  lrrq         DATE,
  xgr_dm       CHAR(11),
  xgrq         DATE,
  tsswjg_dm_1  CHAR(11),
  sjgsdq       CHAR(11),
  sjtb_sj      TIMESTAMP(6),
  sbpc         VARCHAR2(75),
  ssq          VARCHAR2(60)
)
;
comment on table CKTS_SB_MDT_TLHY_LSB
  is '中国国家铁路集团有限公司国际货物运输明细（临时表）';
comment on column CKTS_SB_MDT_TLHY_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_MDT_TLHY_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_MDT_TLHY_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_MDT_TLHY_LSB.yf
  is '月份';
comment on column CKTS_SB_MDT_TLHY_LSB.sbxh
  is '申报序号';
comment on column CKTS_SB_MDT_TLHY_LSB.tlyslx_dm
  is '铁路运输类型代码';
comment on column CKTS_SB_MDT_TLHY_LSB.tlyslxmc
  is '铁路运输类型名称';
comment on column CKTS_SB_MDT_TLHY_LSB.hphzje
  is '货票汇总金额';
comment on column CKTS_SB_MDT_TLHY_LSB.gsqttlysqyje
  is '归属其他铁路运输企业金额';
comment on column CKTS_SB_MDT_TLHY_LSB.gshjcygtje
  is '归属汇缴成员国铁金额';
comment on column CKTS_SB_MDT_TLHY_LSB.ykcje_1
  is '应扣除金额';
comment on column CKTS_SB_MDT_TLHY_LSB.qshysfwjsje
  is '清算后应税服务计税金额';
comment on column CKTS_SB_MDT_TLHY_LSB.bz
  is '备注';
comment on column CKTS_SB_MDT_TLHY_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_MDT_TLHY_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_MDT_TLHY_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_MDT_TLHY_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_MDT_TLHY_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_MDT_TLHY_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_MDT_TLHY_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_MDT_TLHY_LSB.ssq
  is '所属期';
create index IDX_CKTS_SB_MDT_TLHY_LSB_1 on CKTS_SB_MDT_TLHY_LSB (SBID);
create index IDX_CKTS_SB_MDT_TLHY_LSB_2 on CKTS_SB_MDT_TLHY_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_MDT_TSSB_LSB
prompt ===================================
prompt
create table CKTS_SB_MDT_TSSB_LSB
(
  sbid             NUMBER(18),
  qyhgdm           VARCHAR2(20),
  djxh             NUMBER(20),
  ssq              VARCHAR2(60),
  sbpc             VARCHAR2(75),
  sbxh             VARCHAR2(50),
  ckfph            VARCHAR2(30),
  ckbgdh           VARCHAR2(21),
  ckrq_1           DATE,
  dlckhwzmhm       VARCHAR2(20),
  cksp_dm          VARCHAR2(20),
  hgjldwmc         VARCHAR2(75),
  cksl             NUMBER(17,5),
  mylaj            NUMBER(18,2),
  rmblaj           NUMBER(18,2),
  zssl             NUMBER(16,6),
  tsl              NUMBER(16,6),
  tzhjhfpl         NUMBER(10,6),
  jljgbsjkljzcjsjg NUMBER(18,2),
  gngjmsycljg      NUMBER(18,2),
  mdtsbdmzhdkse    NUMBER(18,6),
  mdtse            NUMBER(18,6),
  jljgszch         VARCHAR2(20),
  cktmsywlxdmjh    VARCHAR2(30),
  cktmsywlxmcjh    VARCHAR2(75),
  ckhth            VARCHAR2(60),
  bz               VARCHAR2(3000),
  cjhbzm_dm        CHAR(3),
  cjzj             NUMBER(18,2),
  cjhbhl           NUMBER(16,6),
  myhl             NUMBER(16,6),
  mdtsny           CHAR(6),
  lrr_dm           CHAR(11),
  lrrq             DATE,
  xgr_dm           CHAR(11),
  xgrq             DATE,
  tsswjg_dm_1      CHAR(11),
  sjgsdq           CHAR(11),
  sjtb_sj          TIMESTAMP(6),
  sbhgspmc         VARCHAR2(500),
  zbblny           VARCHAR2(6),
  sbsp_dm          VARCHAR2(20),
  sbspmc           VARCHAR2(500),
  hgcode           VARCHAR2(4),
  gbcode           VARCHAR2(3),
  zzmdg            VARCHAR2(3),
  hzdwdqdm         VARCHAR2(5),
  sbdwdm           VARCHAR2(10),
  gnqyfs_dm        VARCHAR2(2),
  hgzsrzqylx_dm    VARCHAR2(2)
)
;
comment on table CKTS_SB_MDT_TSSB_LSB
  is '生产企业出口货物免抵退税申报明细(临时表)';
comment on column CKTS_SB_MDT_TSSB_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_MDT_TSSB_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_MDT_TSSB_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_MDT_TSSB_LSB.ssq
  is '所属期';
comment on column CKTS_SB_MDT_TSSB_LSB.sbxh
  is '申报序号';
comment on column CKTS_SB_MDT_TSSB_LSB.ckfph
  is '出口发票号';
comment on column CKTS_SB_MDT_TSSB_LSB.ckbgdh
  is '出口报关单号';
comment on column CKTS_SB_MDT_TSSB_LSB.ckrq_1
  is '出口日期';
comment on column CKTS_SB_MDT_TSSB_LSB.dlckhwzmhm
  is '代理出口货物证明号码';
comment on column CKTS_SB_MDT_TSSB_LSB.cksp_dm
  is '出口商品代码';
comment on column CKTS_SB_MDT_TSSB_LSB.hgjldwmc
  is '海关计量单位名称';
comment on column CKTS_SB_MDT_TSSB_LSB.cksl
  is '出口数量';
comment on column CKTS_SB_MDT_TSSB_LSB.mylaj
  is '美元离岸价';
comment on column CKTS_SB_MDT_TSSB_LSB.rmblaj
  is '人民币离岸价';
comment on column CKTS_SB_MDT_TSSB_LSB.zssl
  is '征税税率';
comment on column CKTS_SB_MDT_TSSB_LSB.tsl
  is '退税率';
comment on column CKTS_SB_MDT_TSSB_LSB.tzhjhfpl
  is '调整后计划分配率';
comment on column CKTS_SB_MDT_TSSB_LSB.jljgbsjkljzcjsjg
  is '进料加工保税进口料件组成计税价格';
comment on column CKTS_SB_MDT_TSSB_LSB.gngjmsycljg
  is '国内购进免税原材料价格';
comment on column CKTS_SB_MDT_TSSB_LSB.mdtsbdmzhdkse
  is '免抵退税不得免征和抵扣税额';
comment on column CKTS_SB_MDT_TSSB_LSB.mdtse
  is '免抵退税额';
comment on column CKTS_SB_MDT_TSSB_LSB.jljgszch
  is '进料加工手（账）册号';
comment on column CKTS_SB_MDT_TSSB_LSB.cktmsywlxdmjh
  is '出口退（免）税业务类型代码集合';
comment on column CKTS_SB_MDT_TSSB_LSB.cktmsywlxmcjh
  is '出口退（免）税业务类型名称集合';
comment on column CKTS_SB_MDT_TSSB_LSB.ckhth
  is '出口合同号';
comment on column CKTS_SB_MDT_TSSB_LSB.bz
  is '备注';
comment on column CKTS_SB_MDT_TSSB_LSB.cjhbzm_dm
  is '成交货币字母代码';
comment on column CKTS_SB_MDT_TSSB_LSB.cjzj
  is '成交总价||成交总价';
comment on column CKTS_SB_MDT_TSSB_LSB.cjhbhl
  is '成交货币汇率';
comment on column CKTS_SB_MDT_TSSB_LSB.myhl
  is '美元汇率';
comment on column CKTS_SB_MDT_TSSB_LSB.mdtsny
  is '免抵退税年月';
comment on column CKTS_SB_MDT_TSSB_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_MDT_TSSB_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_MDT_TSSB_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_MDT_TSSB_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_MDT_TSSB_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_MDT_TSSB_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_MDT_TSSB_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_MDT_TSSB_LSB.sbhgspmc
  is '申报海关商品名称||申报海关商品名称';
comment on column CKTS_SB_MDT_TSSB_LSB.zbblny
  is '暂不办理年月';
comment on column CKTS_SB_MDT_TSSB_LSB.sbsp_dm
  is '申报商品代码';
comment on column CKTS_SB_MDT_TSSB_LSB.sbspmc
  is '申报商品名称';
comment on column CKTS_SB_MDT_TSSB_LSB.gnqyfs_dm
  is '国内启运方式代码';
comment on column CKTS_SB_MDT_TSSB_LSB.hgzsrzqylx_dm
  is '海关总署认证企业类型代码';
create index IDX_CKTS_SB_MDT_TSSB_LSB_1 on CKTS_SB_MDT_TSSB_LSB (SBID);
create index IDX_CKTS_SB_MDT_TSSB_LSB_2 on CKTS_SB_MDT_TSSB_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_MDT_XTHH_LSB
prompt ===================================
prompt
create table CKTS_SB_MDT_XTHH_LSB
(
  sbid          NUMBER(18),
  qyhgdm        VARCHAR2(20),
  djxh          NUMBER(20),
  ssq           VARCHAR2(60),
  sbpc          VARCHAR2(75),
  ckbgdh        VARCHAR2(21),
  ckhth         VARCHAR2(60),
  mylaj         NUMBER(18,2),
  mdtse         NUMBER(18,6),
  sbcs          NUMBER(10),
  zbmc          VARCHAR2(75),
  jzrq          DATE,
  rmblaj        NUMBER(18,2),
  pzfs          NUMBER(10),
  pzbh          VARCHAR2(30),
  skjemy        NUMBER(18,2),
  cktmsywlxdmjh VARCHAR2(30),
  cktmsywlxmcjh VARCHAR2(75),
  lrr_dm        CHAR(11),
  lrrq          DATE,
  xgr_dm        CHAR(11),
  xgrq          DATE,
  tsswjg_dm_1   CHAR(11),
  sjgsdq        CHAR(11),
  sjtb_sj       TIMESTAMP(6),
  ljsbckemy     NUMBER(18,2),
  ljsbmdtse     NUMBER(18,6),
  sbxh          VARCHAR2(50),
  pzhmjh        VARCHAR2(3000)
)
;
comment on table CKTS_SB_MDT_XTHH_LSB
  is '先退税后核销企业免抵退税申报附表(临时表)';
comment on column CKTS_SB_MDT_XTHH_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_MDT_XTHH_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_MDT_XTHH_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_MDT_XTHH_LSB.ssq
  is '所属期';
comment on column CKTS_SB_MDT_XTHH_LSB.ckbgdh
  is '出口报关单号';
comment on column CKTS_SB_MDT_XTHH_LSB.ckhth
  is '出口合同号';
comment on column CKTS_SB_MDT_XTHH_LSB.mylaj
  is '美元离岸价';
comment on column CKTS_SB_MDT_XTHH_LSB.mdtse
  is '免抵退税额';
comment on column CKTS_SB_MDT_XTHH_LSB.sbcs
  is '申报次数';
comment on column CKTS_SB_MDT_XTHH_LSB.zbmc
  is '账簿名称';
comment on column CKTS_SB_MDT_XTHH_LSB.jzrq
  is '记账日期';
comment on column CKTS_SB_MDT_XTHH_LSB.rmblaj
  is '人民币离岸价';
comment on column CKTS_SB_MDT_XTHH_LSB.pzfs
  is '凭证份数';
comment on column CKTS_SB_MDT_XTHH_LSB.pzbh
  is '凭证编号';
comment on column CKTS_SB_MDT_XTHH_LSB.skjemy
  is '收款金额（美元）';
comment on column CKTS_SB_MDT_XTHH_LSB.cktmsywlxdmjh
  is '出口退（免）税业务类型代码集合';
comment on column CKTS_SB_MDT_XTHH_LSB.cktmsywlxmcjh
  is '出口退（免）税业务类型名称集合';
comment on column CKTS_SB_MDT_XTHH_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_MDT_XTHH_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_MDT_XTHH_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_MDT_XTHH_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_MDT_XTHH_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_MDT_XTHH_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_MDT_XTHH_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_MDT_XTHH_LSB.ljsbckemy
  is '累计申报出口额（美元）';
comment on column CKTS_SB_MDT_XTHH_LSB.ljsbmdtse
  is '累计申报免抵退税额';
comment on column CKTS_SB_MDT_XTHH_LSB.sbxh
  is '申报序号';
comment on column CKTS_SB_MDT_XTHH_LSB.pzhmjh
  is '凭证号码集合';
create index IDX_CKTS_SB_MDT_XTHH_LSB_1 on CKTS_SB_MDT_XTHH_LSB (SBID);
create index IDX_CKTS_SB_MDT_XTHH_LSB_2 on CKTS_SB_MDT_XTHH_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_MDT_YFSJ_LSB
prompt ===================================
prompt
create table CKTS_SB_MDT_YFSJ_LSB
(
  sbid              NUMBER(18),
  qyhgdm            VARCHAR2(20),
  djxh              NUMBER(20),
  ssq               VARCHAR2(60),
  sbpc              VARCHAR2(75),
  sbxh              VARCHAR2(50),
  hth               VARCHAR2(60),
  cktszmbh          VARCHAR2(20),
  jwdwmc            VARCHAR2(300),
  gjhdqsz_dm        CHAR(3),
  myhl              NUMBER(16,6),
  skjemy            NUMBER(18,2),
  htzjemy           NUMBER(18,2),
  htzjermb          NUMBER(18,2),
  bqskpzfs          NUMBER(10),
  bqqrysfwyysrrmbje NUMBER(18,2),
  bqskjemy          NUMBER(18,2),
  ysfwyyermb        NUMBER(18,2),
  ysfwyyemdtsjsje   NUMBER(18,2),
  srybzm_dm         CHAR(3),
  srybje            NUMBER(18,2),
  skybzm_dm         CHAR(3),
  skybje            NUMBER(18,2),
  zssl              NUMBER(16,6),
  tsl               NUMBER(16,6),
  ztsce             NUMBER(18,6),
  ytse_1            NUMBER(18,6),
  cktmsywlxdmjh     VARCHAR2(30),
  cktmsywlxmcjh     VARCHAR2(75),
  bz                VARCHAR2(3000),
  jbr_dm            CHAR(11),
  ckfph             VARCHAR2(30),
  kprq              DATE,
  mdtsny            CHAR(6),
  lrr_dm            CHAR(11),
  lrrq              DATE,
  xgr_dm            CHAR(11),
  xgrq              DATE,
  tsswjg_dm_1       CHAR(11),
  sjgsdq            CHAR(11),
  sjtb_sj           TIMESTAMP(6),
  ysfw_dm           VARCHAR2(20),
  ysfwmc            VARCHAR2(500),
  zbblny            VARCHAR2(6),
  bytsny            CHAR(6),
  ckrq_1            DATE
)
;
comment on table CKTS_SB_MDT_YFSJ_LSB
  is '增值税零税率应税服务免抵退税申报明细(临时表)';
comment on column CKTS_SB_MDT_YFSJ_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_MDT_YFSJ_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_MDT_YFSJ_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_MDT_YFSJ_LSB.ssq
  is '所属期';
comment on column CKTS_SB_MDT_YFSJ_LSB.sbxh
  is '申报序号';
comment on column CKTS_SB_MDT_YFSJ_LSB.hth
  is '合同号';
comment on column CKTS_SB_MDT_YFSJ_LSB.cktszmbh
  is '出口退税证明编号';
comment on column CKTS_SB_MDT_YFSJ_LSB.jwdwmc
  is '境外单位名称';
comment on column CKTS_SB_MDT_YFSJ_LSB.gjhdqsz_dm
  is '国家或地区数字代码';
comment on column CKTS_SB_MDT_YFSJ_LSB.myhl
  is '美元汇率';
comment on column CKTS_SB_MDT_YFSJ_LSB.skjemy
  is '收款金额（美元）';
comment on column CKTS_SB_MDT_YFSJ_LSB.htzjemy
  is '合同总金额（美元）';
comment on column CKTS_SB_MDT_YFSJ_LSB.htzjermb
  is '合同总金额（人民币）';
comment on column CKTS_SB_MDT_YFSJ_LSB.bqskpzfs
  is '本期收款凭证份数';
comment on column CKTS_SB_MDT_YFSJ_LSB.bqqrysfwyysrrmbje
  is '本期确认应税服务营业收入人民币金额';
comment on column CKTS_SB_MDT_YFSJ_LSB.bqskjemy
  is '本期收款金额（美元）';
comment on column CKTS_SB_MDT_YFSJ_LSB.ysfwyyermb
  is '应税服务营业额（人民币）';
comment on column CKTS_SB_MDT_YFSJ_LSB.ysfwyyemdtsjsje
  is '应税服务营业额免抵退税计税金额';
comment on column CKTS_SB_MDT_YFSJ_LSB.srybzm_dm
  is '收入原币字母代码';
comment on column CKTS_SB_MDT_YFSJ_LSB.srybje
  is '收入原币金额';
comment on column CKTS_SB_MDT_YFSJ_LSB.skybzm_dm
  is '收款原币字母代码';
comment on column CKTS_SB_MDT_YFSJ_LSB.skybje
  is '收款原币金额';
comment on column CKTS_SB_MDT_YFSJ_LSB.zssl
  is '征税税率';
comment on column CKTS_SB_MDT_YFSJ_LSB.tsl
  is '退税率';
comment on column CKTS_SB_MDT_YFSJ_LSB.ztsce
  is '征退税差额';
comment on column CKTS_SB_MDT_YFSJ_LSB.ytse_1
  is '应退税额';
comment on column CKTS_SB_MDT_YFSJ_LSB.cktmsywlxdmjh
  is '出口退（免）税业务类型代码集合';
comment on column CKTS_SB_MDT_YFSJ_LSB.cktmsywlxmcjh
  is '出口退（免）税业务类型名称集合';
comment on column CKTS_SB_MDT_YFSJ_LSB.bz
  is '备注';
comment on column CKTS_SB_MDT_YFSJ_LSB.jbr_dm
  is '经办人代码';
comment on column CKTS_SB_MDT_YFSJ_LSB.ckfph
  is '出口发票号';
comment on column CKTS_SB_MDT_YFSJ_LSB.kprq
  is '开票日期';
comment on column CKTS_SB_MDT_YFSJ_LSB.mdtsny
  is '免抵退税年月';
comment on column CKTS_SB_MDT_YFSJ_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_MDT_YFSJ_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_MDT_YFSJ_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_MDT_YFSJ_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_MDT_YFSJ_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_MDT_YFSJ_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_MDT_YFSJ_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_MDT_YFSJ_LSB.ysfw_dm
  is '应税服务代码';
comment on column CKTS_SB_MDT_YFSJ_LSB.ysfwmc
  is '应税服务名称';
comment on column CKTS_SB_MDT_YFSJ_LSB.zbblny
  is '暂不办理年月';
comment on column CKTS_SB_MDT_YFSJ_LSB.bytsny
  is '不予退税年月';
comment on column CKTS_SB_MDT_YFSJ_LSB.ckrq_1
  is '出口日期';
create index IDX_CKTS_SB_MDT_YFSJ_LSB_1 on CKTS_SB_MDT_YFSJ_LSB (SBID);
create index IDX_CKTS_SB_MDT_YFSJ_LSB_2 on CKTS_SB_MDT_YFSJ_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_MTS_BNSH_LSB
prompt ===================================
prompt
create table CKTS_SB_MTS_BNSH_LSB
(
  sbid         NUMBER(18),
  qyhgdm       VARCHAR2(20),
  djxh         NUMBER(20),
  ssq          VARCHAR2(60),
  sbpc         VARCHAR2(75),
  sbxh         VARCHAR2(50),
  ckbgdh       VARCHAR2(21),
  ckfph        VARCHAR2(30),
  jckxszrq     DATE,
  cjhbzm_dm    CHAR(3),
  cjzj         NUMBER(18,2),
  cjhbhl       NUMBER(16,6),
  ckxsermb     NUMBER(18,2),
  ckshhbzm_dm  CHAR(3),
  yshje        NUMBER(18,2),
  wshje        NUMBER(18,2),
  wshbl        NUMBER(10,6),
  bnshyy_dm    CHAR(2),
  bnshyymc     VARCHAR2(150),
  tgzmclzl     VARCHAR2(300),
  htydqbshzzrq DATE,
  ckhth        VARCHAR2(60),
  bz           VARCHAR2(3000),
  tsswjg_dm_1  CHAR(11),
  lrr_dm       CHAR(11),
  lrrq         DATE,
  xgrq         DATE,
  xgr_dm       CHAR(11),
  sjgsdq       CHAR(11),
  sjtb_sj      TIMESTAMP(6),
  tbrq_1       DATE
)
;
comment on table CKTS_SB_MTS_BNSH_LSB
  is '出口货物不能收汇申报临时表';
comment on column CKTS_SB_MTS_BNSH_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_MTS_BNSH_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_MTS_BNSH_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_MTS_BNSH_LSB.ssq
  is '所属期';
comment on column CKTS_SB_MTS_BNSH_LSB.sbpc
  is '申报批次';
comment on column CKTS_SB_MTS_BNSH_LSB.sbxh
  is '申报序号';
comment on column CKTS_SB_MTS_BNSH_LSB.ckbgdh
  is '出口报关单号';
comment on column CKTS_SB_MTS_BNSH_LSB.ckfph
  is '出口发票号';
comment on column CKTS_SB_MTS_BNSH_LSB.jckxszrq
  is '记出口销售账日期';
comment on column CKTS_SB_MTS_BNSH_LSB.cjhbzm_dm
  is '成交货币字母代码';
comment on column CKTS_SB_MTS_BNSH_LSB.cjzj
  is '成交总价||成交总价';
comment on column CKTS_SB_MTS_BNSH_LSB.cjhbhl
  is '成交货币汇率';
comment on column CKTS_SB_MTS_BNSH_LSB.ckxsermb
  is '出口销售额（人民币）';
comment on column CKTS_SB_MTS_BNSH_LSB.ckshhbzm_dm
  is '出口收汇货币字母代码';
comment on column CKTS_SB_MTS_BNSH_LSB.yshje
  is '已收汇金额';
comment on column CKTS_SB_MTS_BNSH_LSB.wshje
  is '未收汇金额';
comment on column CKTS_SB_MTS_BNSH_LSB.wshbl
  is '未收汇比例';
comment on column CKTS_SB_MTS_BNSH_LSB.bnshyy_dm
  is '不能收汇原因代码';
comment on column CKTS_SB_MTS_BNSH_LSB.bnshyymc
  is '不能收汇原因名称';
comment on column CKTS_SB_MTS_BNSH_LSB.tgzmclzl
  is '提供证明材料种类';
comment on column CKTS_SB_MTS_BNSH_LSB.htydqbshzzrq
  is '合同约定全部收汇最终日期';
comment on column CKTS_SB_MTS_BNSH_LSB.ckhth
  is '出口合同号';
comment on column CKTS_SB_MTS_BNSH_LSB.bz
  is '备注';
comment on column CKTS_SB_MTS_BNSH_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_MTS_BNSH_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_MTS_BNSH_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_MTS_BNSH_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_MTS_BNSH_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_MTS_BNSH_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_MTS_BNSH_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_MTS_BNSH_LSB.tbrq_1
  is '填表日期';
create index IDX_CKTS_SB_MTS_BNSH_LSB_1 on CKTS_SB_MTS_BNSH_LSB (SBID);
create index IDX_CKTS_SB_MTS_BNSH_LSB_2 on CKTS_SB_MTS_BNSH_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_MTS_CKSH_LSB
prompt ===================================
prompt
create table CKTS_SB_MTS_CKSH_LSB
(
  sbid               NUMBER(18),
  qyhgdm             VARCHAR2(20),
  djxh               NUMBER(20),
  ssq                VARCHAR2(60),
  sbpc               VARCHAR2(75),
  sbxh               VARCHAR2(50),
  ckbgdh             VARCHAR2(21),
  ckfph              VARCHAR2(30),
  jckxszrq           DATE,
  cjhbzm_dm          CHAR(3),
  cjzj               NUMBER(18,2),
  cjhbhl             NUMBER(16,6),
  ckxsermb           NUMBER(18,2),
  pzhm_2             VARCHAR2(40),
  ckshrq             DATE,
  jhfs_dm            CHAR(1),
  yhywbh             VARCHAR2(50),
  ckshhbzm_dm        CHAR(3),
  ckshje             NUMBER(18,2),
  ckshhbhl           NUMBER(16,6),
  ckshjermb          NUMBER(18,2),
  fhr                VARCHAR2(300),
  fhgjdq             VARCHAR2(300),
  fjksfhyy           VARCHAR2(75),
  fjkgjdqfhyy        VARCHAR2(75),
  bz                 VARCHAR2(3000),
  tsswjg_dm_1        CHAR(11),
  lrr_dm             CHAR(11),
  lrrq               DATE,
  xgrq               DATE,
  xgr_dm             CHAR(11),
  sjgsdq             CHAR(11),
  sjtb_sj            TIMESTAMP(6),
  jrjgdm             VARCHAR2(20),
  tbrq_1             DATE,
  dlckhwzmhm         VARCHAR2(20),
  yshqkpzzje         NUMBER(18,2),
  stshqkyy           VARCHAR2(100),
  stshqkyyjtsm       VARCHAR2(4000),
  stshqkjzclzl       VARCHAR2(100),
  stshqkzrmbje       NUMBER(18,2),
  stshqkhtydqbshzzrq DATE,
  stshqkckhth        VARCHAR2(60)
)
;
comment on table CKTS_SB_MTS_CKSH_LSB
  is '出口货物收汇申报临时表';
comment on column CKTS_SB_MTS_CKSH_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_MTS_CKSH_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_MTS_CKSH_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_MTS_CKSH_LSB.ssq
  is '所属期';
comment on column CKTS_SB_MTS_CKSH_LSB.sbpc
  is '申报批次';
comment on column CKTS_SB_MTS_CKSH_LSB.sbxh
  is '退免税申报情况||申报序号';
comment on column CKTS_SB_MTS_CKSH_LSB.ckbgdh
  is '退免税申报情况||出口报关单号';
comment on column CKTS_SB_MTS_CKSH_LSB.ckfph
  is '退免税申报情况||出口发票号';
comment on column CKTS_SB_MTS_CKSH_LSB.jckxszrq
  is '记出口销售账日期';
comment on column CKTS_SB_MTS_CKSH_LSB.cjhbzm_dm
  is '退免税申报情况||成交货币字母代码';
comment on column CKTS_SB_MTS_CKSH_LSB.cjzj
  is '退免税申报情况||成交总价';
comment on column CKTS_SB_MTS_CKSH_LSB.cjhbhl
  is '成交货币汇率';
comment on column CKTS_SB_MTS_CKSH_LSB.ckxsermb
  is '退免税申报情况||出口销售额（人民币）';
comment on column CKTS_SB_MTS_CKSH_LSB.pzhm_2
  is '已收汇情况||凭证号码';
comment on column CKTS_SB_MTS_CKSH_LSB.ckshrq
  is '已收汇情况||出口收汇日期';
comment on column CKTS_SB_MTS_CKSH_LSB.jhfs_dm
  is '结汇方式代码';
comment on column CKTS_SB_MTS_CKSH_LSB.yhywbh
  is '银行业务编号';
comment on column CKTS_SB_MTS_CKSH_LSB.ckshhbzm_dm
  is '已收汇情况||出口收汇货币字母代码';
comment on column CKTS_SB_MTS_CKSH_LSB.ckshje
  is '已收汇情况||出口收汇金额';
comment on column CKTS_SB_MTS_CKSH_LSB.ckshhbhl
  is '出口收汇货币汇率';
comment on column CKTS_SB_MTS_CKSH_LSB.ckshjermb
  is '已收汇情况||出口收汇金额（人民币）';
comment on column CKTS_SB_MTS_CKSH_LSB.fhr
  is '已收汇情况||付汇人';
comment on column CKTS_SB_MTS_CKSH_LSB.fhgjdq
  is '付汇国家（地区）';
comment on column CKTS_SB_MTS_CKSH_LSB.fjksfhyy
  is '已收汇情况||非进口商付汇原因';
comment on column CKTS_SB_MTS_CKSH_LSB.fjkgjdqfhyy
  is '非进口国家（地区）付汇原因';
comment on column CKTS_SB_MTS_CKSH_LSB.bz
  is '退免税申报情况||备注';
comment on column CKTS_SB_MTS_CKSH_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_MTS_CKSH_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_MTS_CKSH_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_MTS_CKSH_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_MTS_CKSH_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_MTS_CKSH_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_MTS_CKSH_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_MTS_CKSH_LSB.jrjgdm
  is '金融机构代码';
comment on column CKTS_SB_MTS_CKSH_LSB.tbrq_1
  is '填表日期';
comment on column CKTS_SB_MTS_CKSH_LSB.dlckhwzmhm
  is '退免税申报情况||代理出口货物证明号码';
comment on column CKTS_SB_MTS_CKSH_LSB.yshqkpzzje
  is '已收汇情况||凭证总金额';
comment on column CKTS_SB_MTS_CKSH_LSB.stshqkyy
  is '视同收汇情况||原因';
comment on column CKTS_SB_MTS_CKSH_LSB.stshqkyyjtsm
  is '视同收汇情况||原因具体说明';
comment on column CKTS_SB_MTS_CKSH_LSB.stshqkjzclzl
  is '视同收汇情况||举证材料种类';
comment on column CKTS_SB_MTS_CKSH_LSB.stshqkzrmbje
  is '视同收汇情况||折人民币金额';
comment on column CKTS_SB_MTS_CKSH_LSB.stshqkhtydqbshzzrq
  is '视同收汇情况||合同约定全部收汇最终日期';
comment on column CKTS_SB_MTS_CKSH_LSB.stshqkckhth
  is '视同收汇情况||出口合同号';
create index IDX_CKTS_SB_MTS_CKSH_LSB_1 on CKTS_SB_MTS_CKSH_LSB (SBID);
create index IDX_CKTS_SB_MTS_CKSH_LSB_2 on CKTS_SB_MTS_CKSH_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_MTS_HGSPTZ_LSB
prompt =====================================
prompt
create table CKTS_SB_MTS_HGSPTZ_LSB
(
  sbid          NUMBER(18),
  qyhgdm        VARCHAR2(20),
  djxh          NUMBER(20),
  ssq           VARCHAR2(60),
  sbxh          VARCHAR2(50),
  sbpc          VARCHAR2(75),
  ckbgdh        VARCHAR2(21),
  ckrq_1        DATE,
  cksp_dm       VARCHAR2(20),
  sbhgspmc      VARCHAR2(500),
  tsl           NUMBER(16,6),
  tzhcksp_dm    VARCHAR2(20),
  tzhhgspmc     VARCHAR2(500),
  tzhtsl        NUMBER(16,6),
  bz            VARCHAR2(3000),
  dlckhwzmhm    VARCHAR2(20),
  tsswjg_dm_1   CHAR(11),
  lrr_dm        CHAR(11),
  lrrq          DATE,
  xgrq          DATE,
  xgr_dm        CHAR(11),
  sjgsdq        CHAR(11),
  sjtb_sj       TIMESTAMP(6),
  tbrq_1        DATE,
  hgckhwbgdsbrq DATE
)
;
comment on table CKTS_SB_MTS_HGSPTZ_LSB
  is '海关出口商品代码、名称、退税率调整对应临时表';
comment on column CKTS_SB_MTS_HGSPTZ_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_MTS_HGSPTZ_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_MTS_HGSPTZ_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_MTS_HGSPTZ_LSB.ssq
  is '所属期';
comment on column CKTS_SB_MTS_HGSPTZ_LSB.sbxh
  is '申报序号';
comment on column CKTS_SB_MTS_HGSPTZ_LSB.sbpc
  is '申报批次';
comment on column CKTS_SB_MTS_HGSPTZ_LSB.ckbgdh
  is '出口报关单号';
comment on column CKTS_SB_MTS_HGSPTZ_LSB.ckrq_1
  is '出口日期';
comment on column CKTS_SB_MTS_HGSPTZ_LSB.cksp_dm
  is '出口商品代码';
comment on column CKTS_SB_MTS_HGSPTZ_LSB.sbhgspmc
  is '申报海关商品名称||申报海关商品名称';
comment on column CKTS_SB_MTS_HGSPTZ_LSB.tsl
  is '退税率';
comment on column CKTS_SB_MTS_HGSPTZ_LSB.tzhcksp_dm
  is '调整后出口商品代码';
comment on column CKTS_SB_MTS_HGSPTZ_LSB.tzhhgspmc
  is '调整后海关商品名称';
comment on column CKTS_SB_MTS_HGSPTZ_LSB.tzhtsl
  is '调整后退税率';
comment on column CKTS_SB_MTS_HGSPTZ_LSB.bz
  is '备注';
comment on column CKTS_SB_MTS_HGSPTZ_LSB.dlckhwzmhm
  is '代理出口货物证明号码';
comment on column CKTS_SB_MTS_HGSPTZ_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_MTS_HGSPTZ_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_MTS_HGSPTZ_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_MTS_HGSPTZ_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_MTS_HGSPTZ_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_MTS_HGSPTZ_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_MTS_HGSPTZ_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_MTS_HGSPTZ_LSB.tbrq_1
  is '填表日期';
comment on column CKTS_SB_MTS_HGSPTZ_LSB.hgckhwbgdsbrq
  is '海关出口货物报关单申报日期';
create index IDX_CKTS_SB_MTS_HGSPTZ_LSB_1 on CKTS_SB_MTS_HGSPTZ_LSB (SBID);
create index IDX_CKTS_SB_MTS_HGSPTZ_LSB_2 on CKTS_SB_MTS_HGSPTZ_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_MTS_JHPZHT_LSB
prompt =====================================
prompt
create table CKTS_SB_MTS_JHPZHT_LSB
(
  sbid        NUMBER(18),
  qyhgdm      VARCHAR2(20),
  djxh        NUMBER(20),
  tsswjg_dm_1 CHAR(11),
  xh          NUMBER(8),
  ssq         VARCHAR2(60),
  sbpc        VARCHAR2(75),
  fp_dm       VARCHAR2(12),
  fphm        VARCHAR2(30),
  hgzyjkshm   VARCHAR2(100),
  ghfshxydm   VARCHAR2(20),
  xhfshxydm   VARCHAR2(20),
  lrr_dm      CHAR(11),
  lrrq        DATE,
  xgr_dm      CHAR(11),
  xgrq        DATE,
  sjgsdq      CHAR(11),
  sjtb_sj     TIMESTAMP(6),
  skssq       VARCHAR2(60),
  kprq        DATE,
  shbz        CHAR(1),
  yysm        VARCHAR2(4000),
  sbxh        VARCHAR2(50)
)
;
comment on table CKTS_SB_MTS_JHPZHT_LSB
  is '进货凭证信息回退（临时表）';
comment on column CKTS_SB_MTS_JHPZHT_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_MTS_JHPZHT_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_MTS_JHPZHT_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_MTS_JHPZHT_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_MTS_JHPZHT_LSB.xh
  is '序号';
comment on column CKTS_SB_MTS_JHPZHT_LSB.ssq
  is '所属期';
comment on column CKTS_SB_MTS_JHPZHT_LSB.sbpc
  is '申报批次';
comment on column CKTS_SB_MTS_JHPZHT_LSB.fp_dm
  is '发票代码';
comment on column CKTS_SB_MTS_JHPZHT_LSB.fphm
  is '发票号码';
comment on column CKTS_SB_MTS_JHPZHT_LSB.hgzyjkshm
  is '海关专用缴款书号码';
comment on column CKTS_SB_MTS_JHPZHT_LSB.ghfshxydm
  is '购货方社会信用代码';
comment on column CKTS_SB_MTS_JHPZHT_LSB.xhfshxydm
  is '销货方社会信用代码';
comment on column CKTS_SB_MTS_JHPZHT_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_MTS_JHPZHT_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_MTS_JHPZHT_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_MTS_JHPZHT_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_MTS_JHPZHT_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_MTS_JHPZHT_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_MTS_JHPZHT_LSB.skssq
  is '税款所属期';
comment on column CKTS_SB_MTS_JHPZHT_LSB.kprq
  is '开票日期';
comment on column CKTS_SB_MTS_JHPZHT_LSB.shbz
  is '审核标志';
comment on column CKTS_SB_MTS_JHPZHT_LSB.yysm
  is '原因说明';
comment on column CKTS_SB_MTS_JHPZHT_LSB.sbxh
  is '申报序号';
create index IDX_CKTS_SB_MTS_JHPZHT_LSB_1 on CKTS_SB_MTS_JHPZHT_LSB (SBID);
create index IDX_CKTS_SB_MTS_JHPZHT_LSB_2 on CKTS_SB_MTS_JHPZHT_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_MTS_SBHZ_LSB
prompt ===================================
prompt
create table CKTS_SB_MTS_SBHZ_LSB
(
  sbid                   NUMBER(18),
  qyhgdm                 VARCHAR2(20),
  djxh                   NUMBER(20),
  sbpc                   VARCHAR2(75),
  ckmxsbbfs              NUMBER(10),
  ckmxsbbjlts_1          NUMBER(10),
  ckemy                  NUMBER(18,2),
  ckhwbgdzs              NUMBER(10),
  dlckhwzmzs             NUMBER(10),
  qtpzzs                 NUMBER(10),
  jhmxsbbfs              NUMBER(10),
  jhmxsbbjlts            NUMBER(16,4),
  zzszyfpzs              NUMBER(10),
  xfszyspzs              NUMBER(10),
  hgjkzzszyjkszs         NUMBER(10),
  hgjkxfszyjkszs         NUMBER(10),
  wmqycktsjhfpdzs        NUMBER(10),
  zjhje                  NUMBER(18,2),
  zjhse                  NUMBER(18,6),
  zjhzzsse               NUMBER(18,6),
  zjhxfsse               NUMBER(18,6),
  bysbtse                NUMBER(18,6),
  bysbzzstse             NUMBER(18,6),
  ckhwlwyzzstse          NUMBER(18,6),
  ckysfwyzzstse          NUMBER(18,6),
  bysbxfstse             NUMBER(18,6),
  byssytse               NUMBER(18,6),
  byssytzzstse           NUMBER(18,6),
  byssytxfstse           NUMBER(18,6),
  bnljssytse             NUMBER(18,6),
  bnljssytzzstse         NUMBER(18,6),
  bnljssytxfstse         NUMBER(18,6),
  sqkjdlckhwzmfs         NUMBER(10),
  sqkjdlckhwzmjlts       NUMBER(10),
  sqkjdljkhwzmfs         NUMBER(10),
  sqkjdljkhwzmjlts       NUMBER(10),
  sqkjlljgckhwmszmfs     NUMBER(10),
  sqkjlljgckhwmszmjlts   NUMBER(10),
  sqkjlljgckhwmshxzmfs   NUMBER(10),
  sqkjlljgckhwmshxzmjlts NUMBER(10),
  sqkjckhwznxzmfs        NUMBER(10),
  sqkjckhwznxzmjlts      NUMBER(10),
  sqkjtyybszmfs          NUMBER(10),
  sqkjtyybszmjlts        NUMBER(10),
  sqkjbbbgdzmfs          NUMBER(10),
  sqkjbbbgdzmjlts        NUMBER(10),
  sqkjbbdlckzmfs         NUMBER(10),
  sqkjbbdlckzmjlts       NUMBER(10),
  sqkjckqyckhjcpmszmfs   NUMBER(10),
  sqkjckqyckhjcpmszmjlts NUMBER(10),
  sbrsmrq                DATE,
  sqrmc                  VARCHAR2(300),
  sqrsmrq                DATE,
  tsswjg_dm_1            CHAR(11),
  lrr_dm                 CHAR(11),
  lrrq                   DATE,
  xgrq                   DATE,
  xgr_dm                 CHAR(11),
  sjgsdq                 CHAR(11),
  sjtb_sj                TIMESTAMP(6),
  ssq                    VARCHAR2(60),
  ckshhxdzs              NUMBER(10),
  ckshjemy               NUMBER(18,2),
  yqshzmzs               NUMBER(10),
  sqkjbbshhxdzmfs        NUMBER(10),
  sqkjbbshhxdzmts        NUMBER(10),
  sbbh_1                 VARCHAR2(20)
)
;
comment on table CKTS_SB_MTS_SBHZ_LSB
  is '外贸企业出口退税汇总申报临时表';
comment on column CKTS_SB_MTS_SBHZ_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_MTS_SBHZ_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_MTS_SBHZ_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_MTS_SBHZ_LSB.sbpc
  is '申报批次';
comment on column CKTS_SB_MTS_SBHZ_LSB.ckmxsbbfs
  is '出口明细申报表（份数）';
comment on column CKTS_SB_MTS_SBHZ_LSB.ckmxsbbjlts_1
  is '出口明细申报表记录（条数）';
comment on column CKTS_SB_MTS_SBHZ_LSB.ckemy
  is '出口额（美元）';
comment on column CKTS_SB_MTS_SBHZ_LSB.ckhwbgdzs
  is '出口货物报关单（张数）';
comment on column CKTS_SB_MTS_SBHZ_LSB.dlckhwzmzs
  is '代理出口货物证明（张数）';
comment on column CKTS_SB_MTS_SBHZ_LSB.qtpzzs
  is '其他凭证（张数）';
comment on column CKTS_SB_MTS_SBHZ_LSB.jhmxsbbfs
  is '进货明细申报表（份数）';
comment on column CKTS_SB_MTS_SBHZ_LSB.jhmxsbbjlts
  is '进货明细申报表记录条数';
comment on column CKTS_SB_MTS_SBHZ_LSB.zzszyfpzs
  is '增值税专用发票（张数）';
comment on column CKTS_SB_MTS_SBHZ_LSB.xfszyspzs
  is '消费税专用税票（张数）';
comment on column CKTS_SB_MTS_SBHZ_LSB.hgjkzzszyjkszs
  is '海关进口增值税专用缴款书（张数）';
comment on column CKTS_SB_MTS_SBHZ_LSB.hgjkxfszyjkszs
  is '海关进口消费税专用缴款书（张数）';
comment on column CKTS_SB_MTS_SBHZ_LSB.wmqycktsjhfpdzs
  is '外贸企业出口退税进货分批单（张数）';
comment on column CKTS_SB_MTS_SBHZ_LSB.zjhje
  is '总进货金额';
comment on column CKTS_SB_MTS_SBHZ_LSB.zjhse
  is '总进货税额';
comment on column CKTS_SB_MTS_SBHZ_LSB.zjhzzsse
  is '总进货增值税税额';
comment on column CKTS_SB_MTS_SBHZ_LSB.zjhxfsse
  is '总进货消费税税额';
comment on column CKTS_SB_MTS_SBHZ_LSB.bysbtse
  is '本月申报退税额';
comment on column CKTS_SB_MTS_SBHZ_LSB.bysbzzstse
  is '本月申报增值税退税额';
comment on column CKTS_SB_MTS_SBHZ_LSB.ckhwlwyzzstse
  is '出口货物劳务应增值税退税额';
comment on column CKTS_SB_MTS_SBHZ_LSB.ckysfwyzzstse
  is '出口应税服务应增值税退税额';
comment on column CKTS_SB_MTS_SBHZ_LSB.bysbxfstse
  is '本月申报消费税退税额';
comment on column CKTS_SB_MTS_SBHZ_LSB.byssytse
  is '本月实收已退税额';
comment on column CKTS_SB_MTS_SBHZ_LSB.byssytzzstse
  is '本月实收已退增值税退税额';
comment on column CKTS_SB_MTS_SBHZ_LSB.byssytxfstse
  is '本月实收已退消费税退税额';
comment on column CKTS_SB_MTS_SBHZ_LSB.bnljssytse
  is '本年累计实收已退税额';
comment on column CKTS_SB_MTS_SBHZ_LSB.bnljssytzzstse
  is '本年累计实收已退增值税退税额';
comment on column CKTS_SB_MTS_SBHZ_LSB.bnljssytxfstse
  is '本年累计实收已退消费税退税额';
comment on column CKTS_SB_MTS_SBHZ_LSB.sqkjdlckhwzmfs
  is '申请开具代理出口货物证明（份数）';
comment on column CKTS_SB_MTS_SBHZ_LSB.sqkjdlckhwzmjlts
  is '申请开具代理出口货物证明记录（条数）';
comment on column CKTS_SB_MTS_SBHZ_LSB.sqkjdljkhwzmfs
  is '申请开具代理进口货物证明（份数）';
comment on column CKTS_SB_MTS_SBHZ_LSB.sqkjdljkhwzmjlts
  is '申请开具代理进口货物证明记录（条数）';
comment on column CKTS_SB_MTS_SBHZ_LSB.sqkjlljgckhwmszmfs
  is '申请开具来料加工出口货物免税证明（份数）';
comment on column CKTS_SB_MTS_SBHZ_LSB.sqkjlljgckhwmszmjlts
  is '申请开具来料加工出口货物免税证明记录（条数）';
comment on column CKTS_SB_MTS_SBHZ_LSB.sqkjlljgckhwmshxzmfs
  is '申请开具来料加工出口货物免税核销证明（份数）';
comment on column CKTS_SB_MTS_SBHZ_LSB.sqkjlljgckhwmshxzmjlts
  is '申请开具来料加工出口货物免税核销证明记录（条数）';
comment on column CKTS_SB_MTS_SBHZ_LSB.sqkjckhwznxzmfs
  is '申请开具出口货物转内销证明（份数）';
comment on column CKTS_SB_MTS_SBHZ_LSB.sqkjckhwznxzmjlts
  is '申请开具出口货物转内销证明记录（条数）';
comment on column CKTS_SB_MTS_SBHZ_LSB.sqkjtyybszmfs
  is '申请开具退运已补税证明（份数）';
comment on column CKTS_SB_MTS_SBHZ_LSB.sqkjtyybszmjlts
  is '申请开具退运已补税证明记录（条数）';
comment on column CKTS_SB_MTS_SBHZ_LSB.sqkjbbbgdzmfs
  is '申请开具补办报关单证明（份数）';
comment on column CKTS_SB_MTS_SBHZ_LSB.sqkjbbbgdzmjlts
  is '申请开具补办报关单证明记录（条数）';
comment on column CKTS_SB_MTS_SBHZ_LSB.sqkjbbdlckzmfs
  is '申请开具补办代理出口证明（份数）';
comment on column CKTS_SB_MTS_SBHZ_LSB.sqkjbbdlckzmjlts
  is '申请开具补办代理出口证明记录（条数）';
comment on column CKTS_SB_MTS_SBHZ_LSB.sqkjckqyckhjcpmszmfs
  is '申请开具出口企业出口含金产品免税证明（份数）';
comment on column CKTS_SB_MTS_SBHZ_LSB.sqkjckqyckhjcpmszmjlts
  is '申请开具出口企业出口含金产品免税证明记录（条数）';
comment on column CKTS_SB_MTS_SBHZ_LSB.sbrsmrq
  is '申报人申明日期';
comment on column CKTS_SB_MTS_SBHZ_LSB.sqrmc
  is '授权人名称';
comment on column CKTS_SB_MTS_SBHZ_LSB.sqrsmrq
  is '授权人申明日期';
comment on column CKTS_SB_MTS_SBHZ_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_MTS_SBHZ_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_MTS_SBHZ_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_MTS_SBHZ_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_MTS_SBHZ_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_MTS_SBHZ_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_MTS_SBHZ_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_MTS_SBHZ_LSB.ssq
  is '所属期';
comment on column CKTS_SB_MTS_SBHZ_LSB.ckshhxdzs
  is '出口收汇核销单张数';
comment on column CKTS_SB_MTS_SBHZ_LSB.ckshjemy
  is '出口收汇金额（美元）';
comment on column CKTS_SB_MTS_SBHZ_LSB.yqshzmzs
  is '远期收汇证明张数';
comment on column CKTS_SB_MTS_SBHZ_LSB.sqkjbbshhxdzmfs
  is '申请开具补办收汇核销单证明（份数）';
comment on column CKTS_SB_MTS_SBHZ_LSB.sqkjbbshhxdzmts
  is '申请开具补办收汇核销单证明（条数）';
comment on column CKTS_SB_MTS_SBHZ_LSB.sbbh_1
  is '申报编号';
create index IDX_CKTS_SB_MTS_SBHZ_LSB_1 on CKTS_SB_MTS_SBHZ_LSB (SBID);
create index IDX_CKTS_SB_MTS_SBHZ_LSB_2 on CKTS_SB_MTS_SBHZ_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_MTS_TSJH_LSB
prompt ===================================
prompt
create table CKTS_SB_MTS_TSJH_LSB
(
  sbid          NUMBER(18),
  qyhgdm        VARCHAR2(20),
  djxh          NUMBER(20),
  sbpc          VARCHAR2(75),
  sbxh          VARCHAR2(50),
  glh           VARCHAR2(30),
  sz            CHAR(1),
  jhpzh         VARCHAR2(75),
  zysph         VARCHAR2(30),
  kprq          DATE,
  cksp_dm       VARCHAR2(20),
  sbhgspmc      VARCHAR2(500),
  hgjldwmc      VARCHAR2(75),
  sl            NUMBER(17,5),
  jsje          NUMBER(18,2),
  zssl          NUMBER(16,6),
  zsse          NUMBER(18,6),
  tsl           NUMBER(16,6),
  tse           NUMBER(18,6),
  cktmsywlxdmjh VARCHAR2(30),
  cktmsywlxmcjh VARCHAR2(75),
  bz            VARCHAR2(3000),
  tbrq_1        DATE,
  tsswjg_dm_1   CHAR(11),
  lrr_dm        CHAR(11),
  lrrq          DATE,
  xgrq          DATE,
  xgr_dm        CHAR(11),
  sjgsdq        CHAR(11),
  sjtb_sj       TIMESTAMP(6),
  ssq           VARCHAR2(60),
  ghfnsrsbh_1   VARCHAR2(20),
  cktmspzlx_dm  CHAR(2),
  fpdm          VARCHAR2(12),
  fphm          VARCHAR2(8),
  ckrq_1        DATE
)
;
comment on table CKTS_SB_MTS_TSJH_LSB
  is '外贸企业出口退税进货明细申报临时表';
comment on column CKTS_SB_MTS_TSJH_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_MTS_TSJH_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_MTS_TSJH_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_MTS_TSJH_LSB.sbpc
  is '申报批次';
comment on column CKTS_SB_MTS_TSJH_LSB.sbxh
  is '申报序号';
comment on column CKTS_SB_MTS_TSJH_LSB.glh
  is '关联号';
comment on column CKTS_SB_MTS_TSJH_LSB.sz
  is '税种';
comment on column CKTS_SB_MTS_TSJH_LSB.jhpzh
  is '进货凭证号';
comment on column CKTS_SB_MTS_TSJH_LSB.zysph
  is '专用税票号';
comment on column CKTS_SB_MTS_TSJH_LSB.kprq
  is '开票日期';
comment on column CKTS_SB_MTS_TSJH_LSB.cksp_dm
  is '出口商品代码';
comment on column CKTS_SB_MTS_TSJH_LSB.sbhgspmc
  is '申报海关商品名称||申报海关商品名称';
comment on column CKTS_SB_MTS_TSJH_LSB.hgjldwmc
  is '海关计量单位名称';
comment on column CKTS_SB_MTS_TSJH_LSB.sl
  is '数量';
comment on column CKTS_SB_MTS_TSJH_LSB.jsje
  is '计税金额';
comment on column CKTS_SB_MTS_TSJH_LSB.zssl
  is '征税税率';
comment on column CKTS_SB_MTS_TSJH_LSB.zsse
  is '征税税额';
comment on column CKTS_SB_MTS_TSJH_LSB.tsl
  is '退税率';
comment on column CKTS_SB_MTS_TSJH_LSB.tse
  is '退税额';
comment on column CKTS_SB_MTS_TSJH_LSB.cktmsywlxdmjh
  is '出口退（免）税业务类型代码集合';
comment on column CKTS_SB_MTS_TSJH_LSB.cktmsywlxmcjh
  is '出口退（免）税业务类型名称集合';
comment on column CKTS_SB_MTS_TSJH_LSB.bz
  is '备注';
comment on column CKTS_SB_MTS_TSJH_LSB.tbrq_1
  is '填表日期';
comment on column CKTS_SB_MTS_TSJH_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_MTS_TSJH_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_MTS_TSJH_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_MTS_TSJH_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_MTS_TSJH_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_MTS_TSJH_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_MTS_TSJH_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_MTS_TSJH_LSB.ssq
  is '所属期';
comment on column CKTS_SB_MTS_TSJH_LSB.ghfnsrsbh_1
  is '供货方纳税人识别号';
comment on column CKTS_SB_MTS_TSJH_LSB.cktmspzlx_dm
  is '出口退(免)税凭证类型代码';
comment on column CKTS_SB_MTS_TSJH_LSB.fpdm
  is '增值税发票代码（信息比对的时候通过JHPZH分解）';
comment on column CKTS_SB_MTS_TSJH_LSB.fphm
  is '增值税发票号码（信息比对的时候通过JHPZH分解）';
comment on column CKTS_SB_MTS_TSJH_LSB.ckrq_1
  is '出口日期（信息比对的时候通过关联号从出口明细获取）';
create index IDX_CKTS_SB_MTS_TSJH_LSB_1 on CKTS_SB_MTS_TSJH_LSB (SBID);
create index IDX_CKTS_SB_MTS_TSJH_LSB_2 on CKTS_SB_MTS_TSJH_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_MTS_TSSB_LSB
prompt ===================================
prompt
create table CKTS_SB_MTS_TSSB_LSB
(
  sbid          NUMBER(18),
  qyhgdm        VARCHAR2(20),
  djxh          NUMBER(20),
  sbpc          VARCHAR2(75),
  sbxh          VARCHAR2(50),
  glh           VARCHAR2(30),
  ckbgdh        VARCHAR2(21),
  dlzmh         VARCHAR2(30),
  ckrq_1        DATE,
  ckshhxdh      VARCHAR2(30),
  cksp_dm       VARCHAR2(20),
  sbhgspmc      VARCHAR2(500),
  hgjldwmc      VARCHAR2(75),
  cksl          NUMBER(17,5),
  mylaj         NUMBER(18,2),
  ckjhje        NUMBER(18,2),
  sbsp_dm       VARCHAR2(20),
  sbspmc        VARCHAR2(500),
  tsl           NUMBER(16,6),
  zzstse        NUMBER(18,6),
  xfstse        NUMBER(18,6),
  dzbqbz        CHAR(1),
  cktmsywlxdmjh VARCHAR2(30),
  cktmsywlxmcjh VARCHAR2(75),
  bz            VARCHAR2(3000),
  tbrq_1        DATE,
  stssl         NUMBER(17,5),
  pjdj          NUMBER(18,2),
  rmblaj        NUMBER(18,2),
  mygdqsz_dm    CHAR(3),
  tsswjg_dm_1   CHAR(11),
  lrr_dm        CHAR(11),
  lrrq          DATE,
  xgrq          DATE,
  xgr_dm        CHAR(11),
  sjgsdq        CHAR(11),
  sjtb_sj       TIMESTAMP(6),
  ssq           VARCHAR2(60),
  jjhwbaqdh     VARCHAR2(30),
  ckfph         VARCHAR2(30),
  hgcode        VARCHAR2(4),
  gbcode        VARCHAR2(3),
  zzmdg         VARCHAR2(3),
  hzdwdqdm      VARCHAR2(5),
  sbdwdm        VARCHAR2(10),
  gnqyfs_dm     VARCHAR2(2),
  hgzsrzqylx_dm VARCHAR2(2)
)
;
comment on table CKTS_SB_MTS_TSSB_LSB
  is '外贸企业出口退税出口明细申报临时表';
comment on column CKTS_SB_MTS_TSSB_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_MTS_TSSB_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_MTS_TSSB_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_MTS_TSSB_LSB.sbpc
  is '申报批次';
comment on column CKTS_SB_MTS_TSSB_LSB.sbxh
  is '申报序号';
comment on column CKTS_SB_MTS_TSSB_LSB.glh
  is '关联号';
comment on column CKTS_SB_MTS_TSSB_LSB.ckbgdh
  is '出口报关单号';
comment on column CKTS_SB_MTS_TSSB_LSB.dlzmh
  is '代理证明号';
comment on column CKTS_SB_MTS_TSSB_LSB.ckrq_1
  is '出口日期';
comment on column CKTS_SB_MTS_TSSB_LSB.ckshhxdh
  is '出口收汇核销单号';
comment on column CKTS_SB_MTS_TSSB_LSB.cksp_dm
  is '出口商品代码';
comment on column CKTS_SB_MTS_TSSB_LSB.sbhgspmc
  is '申报海关商品名称||申报海关商品名称';
comment on column CKTS_SB_MTS_TSSB_LSB.hgjldwmc
  is '海关计量单位名称';
comment on column CKTS_SB_MTS_TSSB_LSB.cksl
  is '出口数量';
comment on column CKTS_SB_MTS_TSSB_LSB.mylaj
  is '美元离岸价';
comment on column CKTS_SB_MTS_TSSB_LSB.ckjhje
  is '出口进货金额';
comment on column CKTS_SB_MTS_TSSB_LSB.sbsp_dm
  is '申报商品代码';
comment on column CKTS_SB_MTS_TSSB_LSB.sbspmc
  is '申报商品名称';
comment on column CKTS_SB_MTS_TSSB_LSB.tsl
  is '退税率';
comment on column CKTS_SB_MTS_TSSB_LSB.zzstse
  is '增值税退税额';
comment on column CKTS_SB_MTS_TSSB_LSB.xfstse
  is '消费税退税额';
comment on column CKTS_SB_MTS_TSSB_LSB.dzbqbz
  is '单证不齐标志';
comment on column CKTS_SB_MTS_TSSB_LSB.cktmsywlxdmjh
  is '出口退（免）税业务类型代码集合';
comment on column CKTS_SB_MTS_TSSB_LSB.cktmsywlxmcjh
  is '出口退（免）税业务类型名称集合';
comment on column CKTS_SB_MTS_TSSB_LSB.bz
  is '备注';
comment on column CKTS_SB_MTS_TSSB_LSB.tbrq_1
  is '填表日期';
comment on column CKTS_SB_MTS_TSSB_LSB.stssl
  is '实退税数量';
comment on column CKTS_SB_MTS_TSSB_LSB.pjdj
  is '平均单价';
comment on column CKTS_SB_MTS_TSSB_LSB.rmblaj
  is '人民币离岸价';
comment on column CKTS_SB_MTS_TSSB_LSB.mygdqsz_dm
  is '贸易国（地区）数字代码';
comment on column CKTS_SB_MTS_TSSB_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_MTS_TSSB_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_MTS_TSSB_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_MTS_TSSB_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_MTS_TSSB_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_MTS_TSSB_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_MTS_TSSB_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_MTS_TSSB_LSB.ssq
  is '所属期';
comment on column CKTS_SB_MTS_TSSB_LSB.jjhwbaqdh
  is '进境货物备案清单号';
comment on column CKTS_SB_MTS_TSSB_LSB.ckfph
  is '出口发票号';
comment on column CKTS_SB_MTS_TSSB_LSB.gnqyfs_dm
  is '国内启运方式代码';
comment on column CKTS_SB_MTS_TSSB_LSB.hgzsrzqylx_dm
  is '海关总署认证企业类型代码';
create index IDX_CKTS_SB_MTS_TSSB_LSB_1 on CKTS_SB_MTS_TSSB_LSB (SBID);
create index IDX_CKTS_SB_MTS_TSSB_LSB_2 on CKTS_SB_MTS_TSSB_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_MTS_TZSB_LSB
prompt ===================================
prompt
create table CKTS_SB_MTS_TZSB_LSB
(
  sbid          NUMBER(18),
  qyhgdm        VARCHAR2(20),
  djxh          NUMBER(20),
  sbpc          VARCHAR2(75),
  sbxh          VARCHAR2(50),
  lslsbbz       CHAR(1),
  yglh          VARCHAR2(30),
  bz            VARCHAR2(3000),
  tsswjg_dm_1   CHAR(11),
  lrr_dm        CHAR(11),
  lrrq          DATE,
  xgrq          DATE,
  xgr_dm        CHAR(11),
  sjgsdq        CHAR(11),
  sjtb_sj       TIMESTAMP(6),
  ssq           VARCHAR2(60),
  wmqytzsblx_dm CHAR(1)
)
;
comment on table CKTS_SB_MTS_TZSB_LSB
  is '免退税调整申报临时表';
comment on column CKTS_SB_MTS_TZSB_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_MTS_TZSB_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_MTS_TZSB_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_MTS_TZSB_LSB.sbpc
  is '申报批次';
comment on column CKTS_SB_MTS_TZSB_LSB.sbxh
  is '申报序号';
comment on column CKTS_SB_MTS_TZSB_LSB.lslsbbz
  is '零税率申报标志';
comment on column CKTS_SB_MTS_TZSB_LSB.yglh
  is '原关联号';
comment on column CKTS_SB_MTS_TZSB_LSB.bz
  is '备注';
comment on column CKTS_SB_MTS_TZSB_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_MTS_TZSB_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_MTS_TZSB_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_MTS_TZSB_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_MTS_TZSB_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_MTS_TZSB_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_MTS_TZSB_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_MTS_TZSB_LSB.ssq
  is '所属期';
comment on column CKTS_SB_MTS_TZSB_LSB.wmqytzsblx_dm
  is '外贸企业调整申报类型代码';
create index IDX_CKTS_SB_MTS_TZSB_LSB_1 on CKTS_SB_MTS_TZSB_LSB (SBID);
create index IDX_CKTS_SB_MTS_TZSB_LSB_2 on CKTS_SB_MTS_TZSB_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_MTS_YSFWCK_LSB
prompt =====================================
prompt
create table CKTS_SB_MTS_YSFWCK_LSB
(
  sbid              NUMBER(18),
  qyhgdm            VARCHAR2(20),
  djxh              NUMBER(20),
  ssq               VARCHAR2(60),
  sbxh              VARCHAR2(50),
  glh               VARCHAR2(30),
  ckrq_1            DATE,
  ysfw_dm           VARCHAR2(20),
  ysfwmc            VARCHAR2(500),
  hth               VARCHAR2(60),
  jwdwmc            VARCHAR2(300),
  jwzcgjhdqsz_dm    CHAR(3),
  htzjemy           NUMBER(18,2),
  htzjermb          NUMBER(18,2),
  bqskpzfs          NUMBER(10),
  bqqrysfwyysrrmbje NUMBER(18,2),
  skjemy            NUMBER(18,2),
  tsl               NUMBER(16,6),
  zzstse            NUMBER(18,6),
  cktmsywlxdmjh     VARCHAR2(30),
  cktmsywlxmcjh     VARCHAR2(75),
  bz                VARCHAR2(3000),
  rq                DATE,
  tsswjg_dm_1       CHAR(11),
  lrr_dm            CHAR(11),
  lrrq              DATE,
  xgrq              DATE,
  xgr_dm            CHAR(11),
  sjgsdq            CHAR(11),
  sjtb_sj           TIMESTAMP(6),
  sbpc              VARCHAR2(75),
  jhpzh             VARCHAR2(75),
  kprq              DATE,
  jsje              NUMBER(18,2),
  zssl              NUMBER(16,6),
  cktszmbh          VARCHAR2(20),
  ghfnsrsbh_1       VARCHAR2(20),
  ckfph             VARCHAR2(30),
  myhl              NUMBER(16,6),
  ygzmbh            VARCHAR2(50),
  fpdm              VARCHAR2(12),
  fphm              VARCHAR2(8)
)
;
comment on table CKTS_SB_MTS_YSFWCK_LSB
  is '外贸企业外购应税服务出口明细申请临时表';
comment on column CKTS_SB_MTS_YSFWCK_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_MTS_YSFWCK_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_MTS_YSFWCK_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_MTS_YSFWCK_LSB.ssq
  is '所属期';
comment on column CKTS_SB_MTS_YSFWCK_LSB.sbxh
  is '申报序号';
comment on column CKTS_SB_MTS_YSFWCK_LSB.glh
  is '关联号';
comment on column CKTS_SB_MTS_YSFWCK_LSB.ckrq_1
  is '出口日期';
comment on column CKTS_SB_MTS_YSFWCK_LSB.ysfw_dm
  is '应税服务代码';
comment on column CKTS_SB_MTS_YSFWCK_LSB.ysfwmc
  is '应税服务名称';
comment on column CKTS_SB_MTS_YSFWCK_LSB.hth
  is '合同号';
comment on column CKTS_SB_MTS_YSFWCK_LSB.jwdwmc
  is '境外单位名称';
comment on column CKTS_SB_MTS_YSFWCK_LSB.jwzcgjhdqsz_dm
  is '境外注册国家或地区数字代码';
comment on column CKTS_SB_MTS_YSFWCK_LSB.htzjemy
  is '合同总金额（美元）';
comment on column CKTS_SB_MTS_YSFWCK_LSB.htzjermb
  is '合同总金额（人民币）';
comment on column CKTS_SB_MTS_YSFWCK_LSB.bqskpzfs
  is '本期收款凭证份数';
comment on column CKTS_SB_MTS_YSFWCK_LSB.bqqrysfwyysrrmbje
  is '本期确认应税服务营业收入人民币金额';
comment on column CKTS_SB_MTS_YSFWCK_LSB.skjemy
  is '收款金额（美元）';
comment on column CKTS_SB_MTS_YSFWCK_LSB.tsl
  is '退税率';
comment on column CKTS_SB_MTS_YSFWCK_LSB.zzstse
  is '增值税退税额';
comment on column CKTS_SB_MTS_YSFWCK_LSB.cktmsywlxdmjh
  is '出口退（免）税业务类型代码集合';
comment on column CKTS_SB_MTS_YSFWCK_LSB.cktmsywlxmcjh
  is '出口退（免）税业务类型名称集合';
comment on column CKTS_SB_MTS_YSFWCK_LSB.bz
  is '备注';
comment on column CKTS_SB_MTS_YSFWCK_LSB.rq
  is '日期';
comment on column CKTS_SB_MTS_YSFWCK_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_MTS_YSFWCK_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_MTS_YSFWCK_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_MTS_YSFWCK_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_MTS_YSFWCK_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_MTS_YSFWCK_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_MTS_YSFWCK_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_MTS_YSFWCK_LSB.sbpc
  is '申报批次';
comment on column CKTS_SB_MTS_YSFWCK_LSB.jhpzh
  is '进货凭证号';
comment on column CKTS_SB_MTS_YSFWCK_LSB.kprq
  is '开票日期';
comment on column CKTS_SB_MTS_YSFWCK_LSB.jsje
  is '计税金额';
comment on column CKTS_SB_MTS_YSFWCK_LSB.zssl
  is '征税税率';
comment on column CKTS_SB_MTS_YSFWCK_LSB.cktszmbh
  is '出口退税证明编号';
comment on column CKTS_SB_MTS_YSFWCK_LSB.ghfnsrsbh_1
  is '供货方纳税人识别号';
comment on column CKTS_SB_MTS_YSFWCK_LSB.ckfph
  is '出口发票号';
comment on column CKTS_SB_MTS_YSFWCK_LSB.myhl
  is '美元汇率';
comment on column CKTS_SB_MTS_YSFWCK_LSB.ygzmbh
  is '有关证明编号||有关证明编号';
comment on column CKTS_SB_MTS_YSFWCK_LSB.fpdm
  is '增值税发票代码（信息比对的时候通过JHPZH分解）';
comment on column CKTS_SB_MTS_YSFWCK_LSB.fphm
  is '增值税发票号码（信息比对的时候通过JHPZH分解）';
create index IDX_CKTS_SB_MTS_YSFWCK_LSB_1 on CKTS_SB_MTS_YSFWCK_LSB (SBID);
create index IDX_CKTS_SB_MTS_YSFWCK_LSB_2 on CKTS_SB_MTS_YSFWCK_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_YS_BNSH_LSB
prompt ==================================
prompt
create table CKTS_SB_YS_BNSH_LSB
(
  sbid         NUMBER(18),
  qyhgdm       VARCHAR2(20),
  djxh         NUMBER(20),
  ssq          VARCHAR2(60),
  sbpc         VARCHAR2(75),
  sbxh         VARCHAR2(50),
  ckbgdh       VARCHAR2(21),
  ckfph        VARCHAR2(30),
  jckxszrq     DATE,
  cjhbzm_dm    CHAR(3),
  cjzj         NUMBER(18,2),
  cjhbhl       NUMBER(16,6),
  ckxsermb     NUMBER(18,2),
  ckshhbzm_dm  CHAR(3),
  yshje        NUMBER(18,2),
  wshje        NUMBER(18,2),
  wshbl        NUMBER(10,6),
  bnshyy_dm    CHAR(2),
  bnshyymc     VARCHAR2(150),
  tgzmclzl     VARCHAR2(300),
  htydqbshzzrq DATE,
  ckhth        VARCHAR2(60),
  bz           VARCHAR2(3000),
  tbrq_1       DATE,
  lrr_dm       CHAR(11),
  lrrq         DATE,
  xgr_dm       CHAR(11),
  xgrq         DATE,
  tsswjg_dm_1  CHAR(11),
  sjgsdq       CHAR(11),
  sjtb_sj      TIMESTAMP(6)
)
;
comment on table CKTS_SB_YS_BNSH_LSB
  is '出口已使用过的设备不能收汇申报临时表';
comment on column CKTS_SB_YS_BNSH_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_YS_BNSH_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_YS_BNSH_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_YS_BNSH_LSB.ssq
  is '所属期';
comment on column CKTS_SB_YS_BNSH_LSB.sbpc
  is '申报批次';
comment on column CKTS_SB_YS_BNSH_LSB.sbxh
  is '申报序号';
comment on column CKTS_SB_YS_BNSH_LSB.ckbgdh
  is '出口报关单号';
comment on column CKTS_SB_YS_BNSH_LSB.ckfph
  is '出口发票号';
comment on column CKTS_SB_YS_BNSH_LSB.jckxszrq
  is '记出口销售账日期';
comment on column CKTS_SB_YS_BNSH_LSB.cjhbzm_dm
  is '成交货币字母代码';
comment on column CKTS_SB_YS_BNSH_LSB.cjzj
  is '成交总价||成交总价';
comment on column CKTS_SB_YS_BNSH_LSB.cjhbhl
  is '成交货币汇率';
comment on column CKTS_SB_YS_BNSH_LSB.ckxsermb
  is '出口销售额（人民币）';
comment on column CKTS_SB_YS_BNSH_LSB.ckshhbzm_dm
  is '出口收汇货币字母代码';
comment on column CKTS_SB_YS_BNSH_LSB.yshje
  is '已收汇金额';
comment on column CKTS_SB_YS_BNSH_LSB.wshje
  is '未收汇金额';
comment on column CKTS_SB_YS_BNSH_LSB.wshbl
  is '未收汇比例';
comment on column CKTS_SB_YS_BNSH_LSB.bnshyy_dm
  is '不能收汇原因代码';
comment on column CKTS_SB_YS_BNSH_LSB.bnshyymc
  is '不能收汇原因名称';
comment on column CKTS_SB_YS_BNSH_LSB.tgzmclzl
  is '提供证明材料种类';
comment on column CKTS_SB_YS_BNSH_LSB.htydqbshzzrq
  is '合同约定全部收汇最终日期';
comment on column CKTS_SB_YS_BNSH_LSB.ckhth
  is '出口合同号';
comment on column CKTS_SB_YS_BNSH_LSB.bz
  is '备注';
comment on column CKTS_SB_YS_BNSH_LSB.tbrq_1
  is '填表日期';
comment on column CKTS_SB_YS_BNSH_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_YS_BNSH_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_YS_BNSH_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_YS_BNSH_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_YS_BNSH_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_YS_BNSH_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_YS_BNSH_LSB.sjtb_sj
  is '数据同步时间';
create index IDX_CKTS_SB_YS_BNSH_LSB_1 on CKTS_SB_YS_BNSH_LSB (SBID);
create index IDX_CKTS_SB_YS_BNSH_LSB_2 on CKTS_SB_YS_BNSH_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_YS_CKSH_LSB
prompt ==================================
prompt
create table CKTS_SB_YS_CKSH_LSB
(
  sbid               NUMBER(18),
  qyhgdm             VARCHAR2(20),
  djxh               NUMBER(20),
  ssq                VARCHAR2(60),
  sbpc               VARCHAR2(75),
  sbxh               VARCHAR2(50),
  ckbgdh             VARCHAR2(21),
  ckfph              VARCHAR2(30),
  jckxszrq           DATE,
  cjhbzm_dm          CHAR(3),
  cjzj               NUMBER(18,2),
  cjhbhl             NUMBER(16,6),
  ckxsermb           NUMBER(18,2),
  pzhm_2             VARCHAR2(40),
  ckshrq             DATE,
  jhfs_dm            CHAR(1),
  jrjgdm             VARCHAR2(20),
  yhywbh             VARCHAR2(50),
  ckshhbzm_dm        CHAR(3),
  ckshje             NUMBER(18,2),
  ckshhbhl           NUMBER(16,6),
  ckshjermb          NUMBER(18,2),
  fhr                VARCHAR2(300),
  fhgjdq             VARCHAR2(300),
  fjksfhyy           VARCHAR2(75),
  fjkgjdqfhyy        VARCHAR2(75),
  bz                 VARCHAR2(3000),
  lrr_dm             CHAR(11),
  lrrq               DATE,
  xgr_dm             CHAR(11),
  xgrq               DATE,
  tsswjg_dm_1        CHAR(11),
  sjgsdq             CHAR(11),
  sjtb_sj            TIMESTAMP(6),
  tbrq_1             DATE,
  dlckhwzmhm         VARCHAR2(20),
  yshqkpzzje         NUMBER(18,2),
  stshqkyy           VARCHAR2(100),
  stshqkyyjtsm       VARCHAR2(4000),
  stshqkjzclzl       VARCHAR2(100),
  stshqkzrmbje       NUMBER(18,2),
  stshqkhtydqbshzzrq DATE,
  stshqkckhth        VARCHAR2(60)
)
;
comment on table CKTS_SB_YS_CKSH_LSB
  is '出口已使用过的设备收汇申报明细临时表';
comment on column CKTS_SB_YS_CKSH_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_YS_CKSH_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_YS_CKSH_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_YS_CKSH_LSB.ssq
  is '所属期';
comment on column CKTS_SB_YS_CKSH_LSB.sbpc
  is '申报批次';
comment on column CKTS_SB_YS_CKSH_LSB.sbxh
  is '退免税申报情况||申报序号';
comment on column CKTS_SB_YS_CKSH_LSB.ckbgdh
  is '退免税申报情况||出口报关单号';
comment on column CKTS_SB_YS_CKSH_LSB.ckfph
  is '退免税申报情况||出口发票号';
comment on column CKTS_SB_YS_CKSH_LSB.jckxszrq
  is '记出口销售账日期';
comment on column CKTS_SB_YS_CKSH_LSB.cjhbzm_dm
  is '退免税申报情况||成交货币字母代码';
comment on column CKTS_SB_YS_CKSH_LSB.cjzj
  is '退免税申报情况||成交总价';
comment on column CKTS_SB_YS_CKSH_LSB.cjhbhl
  is '成交货币汇率';
comment on column CKTS_SB_YS_CKSH_LSB.ckxsermb
  is '退免税申报情况||出口销售额（人民币）';
comment on column CKTS_SB_YS_CKSH_LSB.pzhm_2
  is '已收汇情况||凭证号码';
comment on column CKTS_SB_YS_CKSH_LSB.ckshrq
  is '已收汇情况||出口收汇日期';
comment on column CKTS_SB_YS_CKSH_LSB.jhfs_dm
  is '结汇方式代码';
comment on column CKTS_SB_YS_CKSH_LSB.jrjgdm
  is '金融机构代码';
comment on column CKTS_SB_YS_CKSH_LSB.yhywbh
  is '银行业务编号';
comment on column CKTS_SB_YS_CKSH_LSB.ckshhbzm_dm
  is '已收汇情况||出口收汇货币字母代码';
comment on column CKTS_SB_YS_CKSH_LSB.ckshje
  is '已收汇情况||出口收汇金额';
comment on column CKTS_SB_YS_CKSH_LSB.ckshhbhl
  is '出口收汇货币汇率';
comment on column CKTS_SB_YS_CKSH_LSB.ckshjermb
  is '已收汇情况||出口收汇金额（人民币）';
comment on column CKTS_SB_YS_CKSH_LSB.fhr
  is '已收汇情况||付汇人';
comment on column CKTS_SB_YS_CKSH_LSB.fhgjdq
  is '付汇国家（地区）';
comment on column CKTS_SB_YS_CKSH_LSB.fjksfhyy
  is '已收汇情况||非进口商付汇原因';
comment on column CKTS_SB_YS_CKSH_LSB.fjkgjdqfhyy
  is '非进口国家（地区）付汇原因';
comment on column CKTS_SB_YS_CKSH_LSB.bz
  is '退免税申报情况||备注';
comment on column CKTS_SB_YS_CKSH_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_YS_CKSH_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_YS_CKSH_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_YS_CKSH_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_YS_CKSH_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_YS_CKSH_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_YS_CKSH_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_YS_CKSH_LSB.tbrq_1
  is '填表日期';
comment on column CKTS_SB_YS_CKSH_LSB.dlckhwzmhm
  is '退免税申报情况||代理出口货物证明号码';
comment on column CKTS_SB_YS_CKSH_LSB.yshqkpzzje
  is '已收汇情况||凭证总金额';
comment on column CKTS_SB_YS_CKSH_LSB.stshqkyy
  is '视同收汇情况||原因';
comment on column CKTS_SB_YS_CKSH_LSB.stshqkyyjtsm
  is '视同收汇情况||原因具体说明';
comment on column CKTS_SB_YS_CKSH_LSB.stshqkjzclzl
  is '视同收汇情况||举证材料种类';
comment on column CKTS_SB_YS_CKSH_LSB.stshqkzrmbje
  is '视同收汇情况||折人民币金额';
comment on column CKTS_SB_YS_CKSH_LSB.stshqkhtydqbshzzrq
  is '视同收汇情况||合同约定全部收汇最终日期';
comment on column CKTS_SB_YS_CKSH_LSB.stshqkckhth
  is '视同收汇情况||出口合同号';
create index IDX_CKTS_SB_YS_CKSH_LSB_1 on CKTS_SB_YS_CKSH_LSB (SBID);
create index IDX_CKTS_SB_YS_CKSH_LSB_2 on CKTS_SB_YS_CKSH_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_YS_HGSPTZ_LSB
prompt ====================================
prompt
create table CKTS_SB_YS_HGSPTZ_LSB
(
  sbid          NUMBER(18),
  qyhgdm        VARCHAR2(20),
  djxh          NUMBER(20),
  ssq           VARCHAR2(60),
  sbpc          VARCHAR2(75),
  sbxh          VARCHAR2(50),
  ckbgdh        VARCHAR2(21),
  ckrq_1        DATE,
  cksp_dm       VARCHAR2(20),
  tsl           NUMBER(16,6),
  tzhcksp_dm    VARCHAR2(20),
  tzhhgspmc     VARCHAR2(500),
  tzhtsl        NUMBER(16,6),
  dlckhwzmhm    VARCHAR2(20),
  bz            VARCHAR2(3000),
  lrr_dm        CHAR(11),
  lrrq          DATE,
  xgr_dm        CHAR(11),
  xgrq          DATE,
  tsswjg_dm_1   CHAR(11),
  sjgsdq        CHAR(11),
  sjtb_sj       TIMESTAMP(6),
  sbhgspmc      VARCHAR2(500),
  tbrq_1        DATE,
  hgckhwbgdsbrq DATE
)
;
comment on table CKTS_SB_YS_HGSPTZ_LSB
  is '出口已使用过的设备海关出口商品代码名称退税率调整对应申报临时表';
comment on column CKTS_SB_YS_HGSPTZ_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_YS_HGSPTZ_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_YS_HGSPTZ_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_YS_HGSPTZ_LSB.ssq
  is '所属期';
comment on column CKTS_SB_YS_HGSPTZ_LSB.sbxh
  is '申报序号';
comment on column CKTS_SB_YS_HGSPTZ_LSB.ckbgdh
  is '出口报关单号';
comment on column CKTS_SB_YS_HGSPTZ_LSB.ckrq_1
  is '出口日期';
comment on column CKTS_SB_YS_HGSPTZ_LSB.cksp_dm
  is '出口商品代码';
comment on column CKTS_SB_YS_HGSPTZ_LSB.tsl
  is '退税率';
comment on column CKTS_SB_YS_HGSPTZ_LSB.tzhcksp_dm
  is '调整后出口商品代码';
comment on column CKTS_SB_YS_HGSPTZ_LSB.tzhhgspmc
  is '调整后海关商品名称';
comment on column CKTS_SB_YS_HGSPTZ_LSB.tzhtsl
  is '调整后退税率';
comment on column CKTS_SB_YS_HGSPTZ_LSB.dlckhwzmhm
  is '代理出口货物证明号码';
comment on column CKTS_SB_YS_HGSPTZ_LSB.bz
  is '备注';
comment on column CKTS_SB_YS_HGSPTZ_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_YS_HGSPTZ_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_YS_HGSPTZ_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_YS_HGSPTZ_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_YS_HGSPTZ_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_YS_HGSPTZ_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_YS_HGSPTZ_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_YS_HGSPTZ_LSB.sbhgspmc
  is '申报海关商品名称||申报海关商品名称';
comment on column CKTS_SB_YS_HGSPTZ_LSB.tbrq_1
  is '填表日期';
comment on column CKTS_SB_YS_HGSPTZ_LSB.hgckhwbgdsbrq
  is '海关出口货物报关单申报日期';
create index IDX_CKTS_SB_YS_HGSPTZ_LSB_1 on CKTS_SB_YS_HGSPTZ_LSB (SBID);
create index IDX_CKTS_SB_YS_HGSPTZ_LSB_2 on CKTS_SB_YS_HGSPTZ_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_SB_YS_SBMX_LSB
prompt ==================================
prompt
create table CKTS_SB_YS_SBMX_LSB
(
  sbid        NUMBER(18),
  qyhgdm      VARCHAR2(20),
  djxh        NUMBER(20),
  ssq         VARCHAR2(60),
  sbpc        VARCHAR2(75),
  sbxh        VARCHAR2(50),
  ysygdsbmc   VARCHAR2(500),
  ckbgdh      VARCHAR2(21),
  ckrq_1      DATE,
  dlckhwzmhm  VARCHAR2(20),
  cksp_dm     VARCHAR2(20),
  tsl         NUMBER(16,6),
  ysygdsbpzhm VARCHAR2(40),
  kprq        DATE,
  jsje        NUMBER(18,2),
  se          NUMBER(18,6),
  zssl        NUMBER(16,6),
  sbzyjz      NUMBER(18,2),
  tse         NUMBER(18,6),
  bz          VARCHAR2(3000),
  tbrq_1      DATE,
  lrr_dm      CHAR(11),
  lrrq        DATE,
  xgr_dm      CHAR(11),
  xgrq        DATE,
  tsswjg_dm_1 CHAR(11),
  sjgsdq      CHAR(11),
  sjtb_sj     TIMESTAMP(6),
  sbhgspmc    VARCHAR2(500),
  sbyz        NUMBER(18,2),
  ysynx       NUMBER(16,4),
  ytljzje     NUMBER(18,2),
  fpdm        VARCHAR2(12),
  fphm        VARCHAR2(8)
)
;
comment on table CKTS_SB_YS_SBMX_LSB
  is '出口已使用过的设备退税申报临时表';
comment on column CKTS_SB_YS_SBMX_LSB.sbid
  is 'sbid||sbid';
comment on column CKTS_SB_YS_SBMX_LSB.qyhgdm
  is '流程实例ID';
comment on column CKTS_SB_YS_SBMX_LSB.djxh
  is '登记序号';
comment on column CKTS_SB_YS_SBMX_LSB.ssq
  is '所属期';
comment on column CKTS_SB_YS_SBMX_LSB.sbpc
  is '申报批次';
comment on column CKTS_SB_YS_SBMX_LSB.sbxh
  is '申报序号';
comment on column CKTS_SB_YS_SBMX_LSB.ysygdsbmc
  is '已使用过的设备名称';
comment on column CKTS_SB_YS_SBMX_LSB.ckbgdh
  is '出口报关单号';
comment on column CKTS_SB_YS_SBMX_LSB.ckrq_1
  is '出口日期';
comment on column CKTS_SB_YS_SBMX_LSB.dlckhwzmhm
  is '代理出口货物证明号码';
comment on column CKTS_SB_YS_SBMX_LSB.cksp_dm
  is '出口商品代码';
comment on column CKTS_SB_YS_SBMX_LSB.tsl
  is '退税率';
comment on column CKTS_SB_YS_SBMX_LSB.ysygdsbpzhm
  is '已使用过的设备凭证号码';
comment on column CKTS_SB_YS_SBMX_LSB.kprq
  is '开票日期';
comment on column CKTS_SB_YS_SBMX_LSB.jsje
  is '计税金额';
comment on column CKTS_SB_YS_SBMX_LSB.se
  is '税额';
comment on column CKTS_SB_YS_SBMX_LSB.zssl
  is '征税税率';
comment on column CKTS_SB_YS_SBMX_LSB.sbzyjz
  is '设备折余价值';
comment on column CKTS_SB_YS_SBMX_LSB.tse
  is '退税额';
comment on column CKTS_SB_YS_SBMX_LSB.bz
  is '备注';
comment on column CKTS_SB_YS_SBMX_LSB.tbrq_1
  is '填表日期';
comment on column CKTS_SB_YS_SBMX_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_SB_YS_SBMX_LSB.lrrq
  is '录入日期';
comment on column CKTS_SB_YS_SBMX_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_SB_YS_SBMX_LSB.xgrq
  is '修改日期';
comment on column CKTS_SB_YS_SBMX_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_SB_YS_SBMX_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_SB_YS_SBMX_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_SB_YS_SBMX_LSB.sbhgspmc
  is '申报海关商品名称||申报海关商品名称';
comment on column CKTS_SB_YS_SBMX_LSB.sbyz
  is '设备原值';
comment on column CKTS_SB_YS_SBMX_LSB.ysynx
  is '已使用年限';
comment on column CKTS_SB_YS_SBMX_LSB.ytljzje
  is '已提累计折旧额';
comment on column CKTS_SB_YS_SBMX_LSB.fpdm
  is '增值税发票代码（信息比对的时候通过JHPZH分解）';
comment on column CKTS_SB_YS_SBMX_LSB.fphm
  is '增值税发票号码（信息比对的时候通过JHPZH分解）';
create index IDX_CKTS_SB_YS_SBMX_LSB_1 on CKTS_SB_YS_SBMX_LSB (SBID);
create index IDX_CKTS_SB_YS_SBMX_LSB_2 on CKTS_SB_YS_SBMX_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_TY_YWBLXX_SCFFRQ
prompt ====================================
prompt
create table CKTS_TY_YWBLXX_SCFFRQ
(
  tsswjg_dm_1 CHAR(11) not null,
  djxh        NUMBER(20) not null,
  lcswsx_dm   VARCHAR2(16) not null,
  ffrq        DATE,
  sjtbrq      DATE
)
;
comment on table CKTS_TY_YWBLXX_SCFFRQ
  is '出口企业退税申报事项首次发放时间';
comment on column CKTS_TY_YWBLXX_SCFFRQ.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_TY_YWBLXX_SCFFRQ.djxh
  is '登记序号';
comment on column CKTS_TY_YWBLXX_SCFFRQ.lcswsx_dm
  is '流程税务事项代码';
comment on column CKTS_TY_YWBLXX_SCFFRQ.ffrq
  is '发放日期';
comment on column CKTS_TY_YWBLXX_SCFFRQ.sjtbrq
  is '数据同步日期';
alter table CKTS_TY_YWBLXX_SCFFRQ
  add constraint PK_CKTS_TY_YWBLXX_SCFFRQ primary key (TSSWJG_DM_1, DJXH, LCSWSX_DM);

prompt
prompt Creating table CKTS_WBSJ_FP_YCKSPZXX
prompt ====================================
prompt
create table CKTS_WBSJ_FP_YCKSPZXX
(
  uuid    VARCHAR2(32) not null,
  djxh    NUMBER(20),
  fp_dm   VARCHAR2(12),
  fphm    VARCHAR2(30),
  nsrsbh  VARCHAR2(20),
  je      NUMBER(18,2),
  se      NUMBER(18,6),
  jcbz    CHAR(1),
  rdhjcbz CHAR(1)
)
;
comment on table CKTS_WBSJ_FP_YCKSPZXX
  is '增值税异常扣税凭证信息表';
comment on column CKTS_WBSJ_FP_YCKSPZXX.uuid
  is 'UUID||uuid';
comment on column CKTS_WBSJ_FP_YCKSPZXX.djxh
  is '登记序号';
comment on column CKTS_WBSJ_FP_YCKSPZXX.fp_dm
  is '发票代码';
comment on column CKTS_WBSJ_FP_YCKSPZXX.fphm
  is '发票号码';
comment on column CKTS_WBSJ_FP_YCKSPZXX.nsrsbh
  is '纳税人识别号';
comment on column CKTS_WBSJ_FP_YCKSPZXX.je
  is '金额';
comment on column CKTS_WBSJ_FP_YCKSPZXX.se
  is '税额';
comment on column CKTS_WBSJ_FP_YCKSPZXX.jcbz
  is '解除标志';
comment on column CKTS_WBSJ_FP_YCKSPZXX.rdhjcbz
  is '认定或解除标志';
create index IDX_CKTS_WBSJ_YCKSPZXX_DJXH on CKTS_WBSJ_FP_YCKSPZXX (DJXH);
create index IDX_CKTS_YCKSPZXX_FP_DM_FPHM on CKTS_WBSJ_FP_YCKSPZXX (FP_DM, FPHM);

prompt
prompt Creating table CKTS_WBSJ_FP_ZZSFPHWXX
prompt =====================================
prompt
create table CKTS_WBSJ_FP_ZZSFPHWXX
(
  uuid         VARCHAR2(32) not null,
  djxh         NUMBER(20),
  fp_dm        VARCHAR2(12),
  fphm         VARCHAR2(30),
  hh           NUMBER(8),
  hwhyslwmc    VARCHAR2(500),
  xfnsrsbh     VARCHAR2(20),
  gfnsrsbh     VARCHAR2(20),
  gfhhwhyslwmc VARCHAR2(500),
  rkrq         DATE,
  jldwmc       VARCHAR2(75),
  qdbz_1       VARCHAR2(2),
  je           NUMBER(18,2),
  sl_1         NUMBER(16,6),
  se           NUMBER(18,6),
  kprq         DATE,
  ggxh         VARCHAR2(150),
  lsh          VARCHAR2(32),
  hwlw_dm      VARCHAR2(300),
  qyspbm       VARCHAR2(20),
  syyhzcbz     CHAR(1),
  lsllx_dm     CHAR(10),
  yhzcsm       VARCHAR2(750),
  lrr_dm       CHAR(11),
  lrrq         DATE,
  xgr_dm       CHAR(11),
  xgrq         DATE,
  sjgsdq       CHAR(11),
  sjtb_sj      TIMESTAMP(6),
  tsswjg_dm_1  CHAR(11),
  dj_str       VARCHAR2(300),
  sl_3         NUMBER(18,4),
  jhpzh        VARCHAR2(75)
)
;
create index IDX_CKTS_WBSJ_FP_ZZSFPHWXX_DFF on CKTS_WBSJ_FP_ZZSFPHWXX (DJXH, FP_DM, FPHM, GFHHWHYSLWMC);
create index IDX_CKTS_WBSJ_FP_ZZSFPHWXX_DJG on CKTS_WBSJ_FP_ZZSFPHWXX (DJXH, JHPZH, GFHHWHYSLWMC);
alter table CKTS_WBSJ_FP_ZZSFPHWXX
  add constraint PK_CKTS_WBSJ_FP_ZZSFPHWXX_1 primary key (UUID);

prompt
prompt Creating table CKTS_WBSJ_FP_ZZSZYFPXX
prompt =====================================
prompt
create table CKTS_WBSJ_FP_ZZSZYFPXX
(
  uuid          VARCHAR2(32),
  djxh          NUMBER(20),
  fp_dm         VARCHAR2(12),
  fphm          VARCHAR2(30) not null,
  xfnsrsbh      VARCHAR2(20),
  gfnsrsbh      VARCHAR2(20),
  fpzje         NUMBER(18,2),
  fpzse         NUMBER(18,6),
  kprq          DATE,
  rzrq          DATE,
  jhrq_1        DATE,
  je            NUMBER(18,2),
  se            NUMBER(18,6),
  hzcjje        NUMBER(18,2),
  hzcjse        NUMBER(18,6),
  nxzckbz       CHAR(1),
  nxzckje       NUMBER(18,2),
  nxzckse       NUMBER(18,6),
  sbfpjsje      NUMBER(18,2),
  sbfpsjsk      NUMBER(18,6),
  lslsbfpjsje   NUMBER(18,2),
  lslsbfpsjsk   NUMBER(18,6),
  ghfmc         VARCHAR2(300),
  ghfdz         VARCHAR2(300),
  xhfmc         VARCHAR2(300),
  xhfdz         VARCHAR2(300),
  rzxfzzszyfpbz CHAR(1),
  jhxfzzszyfpbz CHAR(1),
  bytsbz        CHAR(1),
  fpzl_dm       VARCHAR2(12),
  fpyt_dm       CHAR(1),
  fpzt_dm       CHAR(2),
  zzssbbz       CHAR(1),
  bdfpbz        CHAR(1),
  fpsjbbz       CHAR(1),
  cglbz         CHAR(1),
  skssq         VARCHAR2(60),
  tsswjg_dm_1   CHAR(11),
  zsswjg_dm     CHAR(11),
  cytssbjl      VARCHAR2(60),
  jhxxjssj      DATE,
  sjgxsj        DATE,
  sjc           DATE,
  rkrq          DATE,
  lrr_dm        CHAR(11),
  lrrq          DATE,
  xgr_dm        CHAR(11),
  xgrq          DATE,
  sjgsdq        CHAR(11),
  sjtb_sj       TIMESTAMP(6),
  hcxcjgdm      VARCHAR2(6),
  xhfkhhjzh     VARCHAR2(300),
  gmfkhhjzh     VARCHAR2(300),
  jcjhbfbz      CHAR(1) default 'N',
  skzfbz        CHAR(1) default 'N',
  xcjg_dm       CHAR(6),
  yckspzbz      CHAR(1) default 'N',
  fphcjg_dm     CHAR(6),
  jhpzh         VARCHAR2(75) not null
)
;
comment on column CKTS_WBSJ_FP_ZZSZYFPXX.jhpzh
  is '进货凭证号';
create index IDX_CKTS_WBSJ_FP_ZZSFP_DJXH on CKTS_WBSJ_FP_ZZSZYFPXX (DJXH);
alter table CKTS_WBSJ_FP_ZZSZYFPXX
  add constraint PK_CKTS_WBSJ_FP_ZZSZYFPXX_1 primary key (JHPZH);

prompt
prompt Creating table CKTS_WBSJ_GT3_ZS_JKS
prompt ===================================
prompt
create table CKTS_WBSJ_GT3_ZS_JKS
(
  djxh   NUMBER(20),
  dzsphm NUMBER(20),
  sjje   NUMBER(18,2)
)
;
comment on table CKTS_WBSJ_GT3_ZS_JKS
  is '????????-??????????';
comment on column CKTS_WBSJ_GT3_ZS_JKS.djxh
  is '????????';
comment on column CKTS_WBSJ_GT3_ZS_JKS.dzsphm
  is '??????????????????????????';
comment on column CKTS_WBSJ_GT3_ZS_JKS.sjje
  is '????????';
create index IDX_CKTS_WBSJ_GT3_ZS_JKS_DJXH on CKTS_WBSJ_GT3_ZS_JKS (DJXH);
create index IDX_CKTS_WBSJ_GT3_ZS_JKS_DP on CKTS_WBSJ_GT3_ZS_JKS (DJXH, DZSPHM);

prompt
prompt Creating table CKTS_WBSJ_HG_BGD201
prompt ==================================
prompt
create table CKTS_WBSJ_HG_BGD201
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
  cksl               NUMBER(17,5),
  decksl             NUMBER(17,5),
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
  sbsl_1             NUMBER(17,5),
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
  tssbsl             NUMBER(17,5),
  tssbrmblaj         NUMBER(18,2),
  tssbmylaj          NUMBER(18,2),
  tysl               NUMBER(17,5),
  tyrmblaj           NUMBER(18,2),
  tymylaj            NUMBER(18,2),
  dlsbsl             NUMBER(17,5),
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
  gdbz_1             CHAR(1) default 'N'
)
;
comment on table CKTS_WBSJ_HG_BGD201
  is '海关出口货物报关单201';
comment on column CKTS_WBSJ_HG_BGD201.uuid
  is 'UUID';
comment on column CKTS_WBSJ_HG_BGD201.djxh
  is '登记序号';
comment on column CKTS_WBSJ_HG_BGD201.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_WBSJ_HG_BGD201.ckny
  is '出口年月';
comment on column CKTS_WBSJ_HG_BGD201.yhggqka_dm
  is '原海关关区（口岸）代码';
comment on column CKTS_WBSJ_HG_BGD201.hggqka_dm
  is '海关关区（口岸）代码';
comment on column CKTS_WBSJ_HG_BGD201.ckbgdh
  is '出口报关单号';
comment on column CKTS_WBSJ_HG_BGD201.bsm
  is '标识码';
comment on column CKTS_WBSJ_HG_BGD201.hzdwdq_dm
  is '货主单位地区代码';
comment on column CKTS_WBSJ_HG_BGD201.hxdh
  is '核销单号';
comment on column CKTS_WBSJ_HG_BGD201.ckrq_1
  is '出口日期';
comment on column CKTS_WBSJ_HG_BGD201.ycksp_dm
  is '原出口商品代码';
comment on column CKTS_WBSJ_HG_BGD201.cksp_dm
  is '出口商品代码';
comment on column CKTS_WBSJ_HG_BGD201.ckspmc
  is '出口商品名称';
comment on column CKTS_WBSJ_HG_BGD201.hgjldwmc
  is '海关计量单位名称';
comment on column CKTS_WBSJ_HG_BGD201.mygdqsz_dm
  is '贸易国（地区）数字代码';
comment on column CKTS_WBSJ_HG_BGD201.yjgfs_dm
  is '原监管方式代码';
comment on column CKTS_WBSJ_HG_BGD201.jgfs_dm
  is '监管方式代码';
comment on column CKTS_WBSJ_HG_BGD201.ydyjldw_dm
  is '原第一计量单位代码';
comment on column CKTS_WBSJ_HG_BGD201.dyjldw_dm
  is '第一计量单位代码';
comment on column CKTS_WBSJ_HG_BGD201.ydejldw_dm
  is '原第二计量单位代码';
comment on column CKTS_WBSJ_HG_BGD201.dejldw_dm
  is '第二计量单位代码';
comment on column CKTS_WBSJ_HG_BGD201.cksl
  is '出口数量';
comment on column CKTS_WBSJ_HG_BGD201.decksl
  is '第二出口数量';
comment on column CKTS_WBSJ_HG_BGD201.rmblaj
  is '人民币离岸价';
comment on column CKTS_WBSJ_HG_BGD201.mylaj
  is '美元离岸价';
comment on column CKTS_WBSJ_HG_BGD201.cjhghbsz_dm
  is '成交海关货币数字代码';
comment on column CKTS_WBSJ_HG_BGD201.cjzj
  is '成交总价';
comment on column CKTS_WBSJ_HG_BGD201.jydwmc
  is '经营单位名称';
comment on column CKTS_WBSJ_HG_BGD201.ysfs_dm
  is '运输方式代码';
comment on column CKTS_WBSJ_HG_BGD201.tydh
  is '提运单号';
comment on column CKTS_WBSJ_HG_BGD201.zmxz_dm
  is '征免性质代码';
comment on column CKTS_WBSJ_HG_BGD201.jhfs_dm
  is '结汇方式代码';
comment on column CKTS_WBSJ_HG_BGD201.xkzh
  is '许可证号';
comment on column CKTS_WBSJ_HG_BGD201.zyg_dm
  is '指运港代码';
comment on column CKTS_WBSJ_HG_BGD201.hgcjfs_dm
  is '海关成交方式代码';
comment on column CKTS_WBSJ_HG_BGD201.yfjsfs_dm
  is '运费计算方式代码';
comment on column CKTS_WBSJ_HG_BGD201.yfhghbsz_dm
  is '运费海关货币数字代码';
comment on column CKTS_WBSJ_HG_BGD201.yfhl
  is '运费汇率';
comment on column CKTS_WBSJ_HG_BGD201.bfjsfs_dm
  is '保费计算方式代码';
comment on column CKTS_WBSJ_HG_BGD201.bfhghbsz_dm
  is '保费海关货币数字代码';
comment on column CKTS_WBSJ_HG_BGD201.bfhl
  is '保费汇率';
comment on column CKTS_WBSJ_HG_BGD201.zfjsfs_dm
  is '杂费计算方式代码';
comment on column CKTS_WBSJ_HG_BGD201.zfhghbsz_dm
  is '杂费海关货币数字代码';
comment on column CKTS_WBSJ_HG_BGD201.zfhl
  is '杂费汇率';
comment on column CKTS_WBSJ_HG_BGD201.bah
  is '备案号';
comment on column CKTS_WBSJ_HG_BGD201.sbdwdm
  is '申报单位代码';
comment on column CKTS_WBSJ_HG_BGD201.sbdwmc
  is '申报单位名称';
comment on column CKTS_WBSJ_HG_BGD201.hzdwmc
  is '货主单位名称';
comment on column CKTS_WBSJ_HG_BGD201.ggxh
  is '规格型号';
comment on column CKTS_WBSJ_HG_BGD201.zzmdgdqsz_dm
  is '最终目的国（地区）数字代码';
comment on column CKTS_WBSJ_HG_BGD201.sbjldw_dm
  is '申报计量单位代码';
comment on column CKTS_WBSJ_HG_BGD201.sbsl_1
  is '申报数量';
comment on column CKTS_WBSJ_HG_BGD201.sbdj
  is '申报单价';
comment on column CKTS_WBSJ_HG_BGD201.tsl
  is '退税率';
comment on column CKTS_WBSJ_HG_BGD201.cytssbjl
  is '参与退税申报记录';
comment on column CKTS_WBSJ_HG_BGD201.ysgjmc
  is '运输工具名称';
comment on column CKTS_WBSJ_HG_BGD201.bytsbz
  is '不予退税标志';
comment on column CKTS_WBSJ_HG_BGD201.hch
  is '航次号';
comment on column CKTS_WBSJ_HG_BGD201.hzdwdm
  is '货主单位代码';
comment on column CKTS_WBSJ_HG_BGD201.hgbzzl_dm
  is '海关包装种类代码';
comment on column CKTS_WBSJ_HG_BGD201.js_1
  is '件数';
comment on column CKTS_WBSJ_HG_BGD201.mz_2
  is '毛重';
comment on column CKTS_WBSJ_HG_BGD201.jz
  is '净重';
comment on column CKTS_WBSJ_HG_BGD201.lxbz
  is '类型备注';
comment on column CKTS_WBSJ_HG_BGD201.tssbsl
  is '退税申报数量';
comment on column CKTS_WBSJ_HG_BGD201.tssbrmblaj
  is '退税申报人民币离岸价';
comment on column CKTS_WBSJ_HG_BGD201.tssbmylaj
  is '退税申报美元离岸价';
comment on column CKTS_WBSJ_HG_BGD201.tysl
  is '退运数量';
comment on column CKTS_WBSJ_HG_BGD201.tyrmblaj
  is '退运人民币离岸价';
comment on column CKTS_WBSJ_HG_BGD201.tymylaj
  is '退运美元离岸价';
comment on column CKTS_WBSJ_HG_BGD201.dlsbsl
  is '代理申报数量';
comment on column CKTS_WBSJ_HG_BGD201.dlsbrmblaj
  is '代理申报人民币离岸价';
comment on column CKTS_WBSJ_HG_BGD201.dlsbmylaj
  is '代理申报美元离岸价';
comment on column CKTS_WBSJ_HG_BGD201.hgspmc
  is '海关商品名称';
comment on column CKTS_WBSJ_HG_BGD201.hgqy_dm
  is '海关企业代码';
comment on column CKTS_WBSJ_HG_BGD201.sjgxsj
  is '数据更新时间';
comment on column CKTS_WBSJ_HG_BGD201.rkrq
  is '入库日期';
comment on column CKTS_WBSJ_HG_BGD201.sjzxtybh
  is '数据中心统一编号';
comment on column CKTS_WBSJ_HG_BGD201.qygbz
  is '启运港标志';
comment on column CKTS_WBSJ_HG_BGD201.kjdlckhwzmbz
  is '开具代理出口货物证明标志';
comment on column CKTS_WBSJ_HG_BGD201.kjckhwtyybswtszmbz
  is '开具出口货物退运已补税（未退税）证明标志';
comment on column CKTS_WBSJ_HG_BGD201.lrr_dm
  is '录入人代码';
comment on column CKTS_WBSJ_HG_BGD201.lrrq
  is '录入日期';
comment on column CKTS_WBSJ_HG_BGD201.xgr_dm
  is '修改人代码';
comment on column CKTS_WBSJ_HG_BGD201.xgrq
  is '修改日期';
comment on column CKTS_WBSJ_HG_BGD201.sjgsdq
  is '数据归属地区';
comment on column CKTS_WBSJ_HG_BGD201.sjtb_sj
  is '数据同步时间';
comment on column CKTS_WBSJ_HG_BGD201.hgckhwbgdsbrq
  is '海关出口货物报关单申报日期';
comment on column CKTS_WBSJ_HG_BGD201.qygzcjgbz
  is '启运港正常结关标志';
comment on column CKTS_WBSJ_HG_BGD201.qygwddbz
  is '启运港未到达标志';
comment on column CKTS_WBSJ_HG_BGD201.qygcxckbz
  is '启运港撤销出口标志';
comment on column CKTS_WBSJ_HG_BGD201.qyrq_2
  is '启运日期';
comment on column CKTS_WBSJ_HG_BGD201.ckhth
  is '出口合同号';
comment on column CKTS_WBSJ_HG_BGD201.gdbz_1
  is '改单标志';
alter table CKTS_WBSJ_HG_BGD201
  add constraint PK_CKTS_WBSJ_HG_BGD201_1 primary key (DJXH, CKBGDH);

prompt
prompt Creating table CKTS_WBSJ_HG_BGD202
prompt ==================================
prompt
create table CKTS_WBSJ_HG_BGD202
(
  uuid               VARCHAR2(32) not null,
  tsswjg_dm_1        CHAR(11),
  djxh               NUMBER(20),
  ckny               CHAR(6) not null,
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
  jnhyd_dm           CHAR(5),
  yjgfs_dm           CHAR(4),
  jgfs_dm            CHAR(4),
  ydyjldw_dm         VARCHAR2(3),
  dyjldw_dm          VARCHAR2(3),
  ydejldw_dm         VARCHAR2(3),
  dejldw_dm          VARCHAR2(3),
  cksl               NUMBER(17,5),
  decksl             NUMBER(17,5),
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
  sbsl_1             NUMBER(17,5),
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
  hgspmc             VARCHAR2(500),
  hgqy_dm            VARCHAR2(50),
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
  ckhth              VARCHAR2(60),
  qygzcjgbz          CHAR(1),
  qygwddbz           CHAR(1),
  qygcxckbz          CHAR(1)
)
;
comment on table CKTS_WBSJ_HG_BGD202
  is '海关出口货物报关单202';
comment on column CKTS_WBSJ_HG_BGD202.uuid
  is 'UUID||uuid';
comment on column CKTS_WBSJ_HG_BGD202.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_WBSJ_HG_BGD202.djxh
  is '登记序号';
comment on column CKTS_WBSJ_HG_BGD202.ckny
  is '出口年月';
comment on column CKTS_WBSJ_HG_BGD202.yhggqka_dm
  is '原海关关区（口岸）代码';
comment on column CKTS_WBSJ_HG_BGD202.hggqka_dm
  is '海关关区（口岸）代码';
comment on column CKTS_WBSJ_HG_BGD202.ckbgdh
  is '出口报关单号';
comment on column CKTS_WBSJ_HG_BGD202.bsm
  is '标识码';
comment on column CKTS_WBSJ_HG_BGD202.hzdwdq_dm
  is '货主单位地区代码';
comment on column CKTS_WBSJ_HG_BGD202.hxdh
  is '核销单号';
comment on column CKTS_WBSJ_HG_BGD202.ckrq_1
  is '出口日期';
comment on column CKTS_WBSJ_HG_BGD202.ycksp_dm
  is '原出口商品代码';
comment on column CKTS_WBSJ_HG_BGD202.cksp_dm
  is '出口商品代码';
comment on column CKTS_WBSJ_HG_BGD202.ckspmc
  is '出口商品名称';
comment on column CKTS_WBSJ_HG_BGD202.hgjldwmc
  is '海关计量单位名称';
comment on column CKTS_WBSJ_HG_BGD202.mygdqsz_dm
  is '贸易国（地区）数字代码';
comment on column CKTS_WBSJ_HG_BGD202.jnhyd_dm
  is '境内货源地代码';
comment on column CKTS_WBSJ_HG_BGD202.yjgfs_dm
  is '原监管方式代码';
comment on column CKTS_WBSJ_HG_BGD202.jgfs_dm
  is '监管方式代码';
comment on column CKTS_WBSJ_HG_BGD202.ydyjldw_dm
  is '原第一计量单位代码';
comment on column CKTS_WBSJ_HG_BGD202.dyjldw_dm
  is '第一计量单位代码';
comment on column CKTS_WBSJ_HG_BGD202.ydejldw_dm
  is '原第二计量单位代码';
comment on column CKTS_WBSJ_HG_BGD202.dejldw_dm
  is '第二计量单位代码';
comment on column CKTS_WBSJ_HG_BGD202.cksl
  is '出口数量';
comment on column CKTS_WBSJ_HG_BGD202.decksl
  is '第二出口数量';
comment on column CKTS_WBSJ_HG_BGD202.rmblaj
  is '人民币离岸价';
comment on column CKTS_WBSJ_HG_BGD202.mylaj
  is '美元离岸价';
comment on column CKTS_WBSJ_HG_BGD202.cjhghbsz_dm
  is '成交海关货币数字代码';
comment on column CKTS_WBSJ_HG_BGD202.cjzj
  is '成交总价||成交总价';
comment on column CKTS_WBSJ_HG_BGD202.jydwmc
  is '经营单位名称';
comment on column CKTS_WBSJ_HG_BGD202.ysfs_dm
  is '运输方式代码';
comment on column CKTS_WBSJ_HG_BGD202.tydh
  is '提运单号';
comment on column CKTS_WBSJ_HG_BGD202.zmxz_dm
  is '征免性质代码';
comment on column CKTS_WBSJ_HG_BGD202.jhfs_dm
  is '结汇方式代码';
comment on column CKTS_WBSJ_HG_BGD202.xkzh
  is '许可证号';
comment on column CKTS_WBSJ_HG_BGD202.zyg_dm
  is '指运港代码';
comment on column CKTS_WBSJ_HG_BGD202.hgcjfs_dm
  is '海关成交方式代码';
comment on column CKTS_WBSJ_HG_BGD202.yfjsfs_dm
  is '运费计算方式代码';
comment on column CKTS_WBSJ_HG_BGD202.yfhghbsz_dm
  is '运费海关货币数字代码';
comment on column CKTS_WBSJ_HG_BGD202.yfhl
  is '运费汇率';
comment on column CKTS_WBSJ_HG_BGD202.bfjsfs_dm
  is '保费计算方式代码';
comment on column CKTS_WBSJ_HG_BGD202.bfhghbsz_dm
  is '保费海关货币数字代码';
comment on column CKTS_WBSJ_HG_BGD202.bfhl
  is '保费汇率';
comment on column CKTS_WBSJ_HG_BGD202.zfjsfs_dm
  is '杂费计算方式代码';
comment on column CKTS_WBSJ_HG_BGD202.zfhghbsz_dm
  is '杂费海关货币数字代码';
comment on column CKTS_WBSJ_HG_BGD202.zfhl
  is '杂费汇率';
comment on column CKTS_WBSJ_HG_BGD202.bah
  is '备案号';
comment on column CKTS_WBSJ_HG_BGD202.sbdwdm
  is '申报单位代码';
comment on column CKTS_WBSJ_HG_BGD202.sbdwmc
  is '申报单位名称';
comment on column CKTS_WBSJ_HG_BGD202.hzdwmc
  is '货主单位名称';
comment on column CKTS_WBSJ_HG_BGD202.ggxh
  is '规格型号';
comment on column CKTS_WBSJ_HG_BGD202.zzmdgdqsz_dm
  is '最终目的国（地区）数字代码';
comment on column CKTS_WBSJ_HG_BGD202.sbjldw_dm
  is '申报计量单位代码';
comment on column CKTS_WBSJ_HG_BGD202.sbsl_1
  is '申报数量';
comment on column CKTS_WBSJ_HG_BGD202.sbdj
  is '申报单价';
comment on column CKTS_WBSJ_HG_BGD202.tsl
  is '退税率';
comment on column CKTS_WBSJ_HG_BGD202.cytssbjl
  is '参与退税申报记录';
comment on column CKTS_WBSJ_HG_BGD202.ysgjmc
  is '运输工具名称';
comment on column CKTS_WBSJ_HG_BGD202.bytsbz
  is '不予退税标志';
comment on column CKTS_WBSJ_HG_BGD202.hch
  is '航次号';
comment on column CKTS_WBSJ_HG_BGD202.hzdwdm
  is '货主单位代码';
comment on column CKTS_WBSJ_HG_BGD202.hgbzzl_dm
  is '海关包装种类代码';
comment on column CKTS_WBSJ_HG_BGD202.js_1
  is '件数';
comment on column CKTS_WBSJ_HG_BGD202.mz_2
  is '毛重';
comment on column CKTS_WBSJ_HG_BGD202.jz
  is '净重';
comment on column CKTS_WBSJ_HG_BGD202.lxbz
  is '类型备注';
comment on column CKTS_WBSJ_HG_BGD202.hgspmc
  is '海关商品名称';
comment on column CKTS_WBSJ_HG_BGD202.hgqy_dm
  is '海关企业代码';
comment on column CKTS_WBSJ_HG_BGD202.rkrq
  is '入库日期';
comment on column CKTS_WBSJ_HG_BGD202.sjzxtybh
  is '数据中心统一编号';
comment on column CKTS_WBSJ_HG_BGD202.qygbz
  is '启运港标志';
comment on column CKTS_WBSJ_HG_BGD202.kjdlckhwzmbz
  is '开具代理出口货物证明标志';
comment on column CKTS_WBSJ_HG_BGD202.kjckhwtyybswtszmbz
  is '开具出口货物退运已补税（未退税）证明标志';
comment on column CKTS_WBSJ_HG_BGD202.lrr_dm
  is '录入人代码';
comment on column CKTS_WBSJ_HG_BGD202.lrrq
  is '录入日期';
comment on column CKTS_WBSJ_HG_BGD202.xgr_dm
  is '修改人代码';
comment on column CKTS_WBSJ_HG_BGD202.xgrq
  is '修改日期';
comment on column CKTS_WBSJ_HG_BGD202.sjgsdq
  is '数据归属地区';
comment on column CKTS_WBSJ_HG_BGD202.sjtb_sj
  is '数据同步时间';
comment on column CKTS_WBSJ_HG_BGD202.hgckhwbgdsbrq
  is '海关出口货物报关单申报日期';
comment on column CKTS_WBSJ_HG_BGD202.ckhth
  is '出口合同号';
comment on column CKTS_WBSJ_HG_BGD202.qygzcjgbz
  is '启运港正常结关标志';
comment on column CKTS_WBSJ_HG_BGD202.qygwddbz
  is '启运港未到达标志';
comment on column CKTS_WBSJ_HG_BGD202.qygcxckbz
  is '启运港撤销出口标志';
create index IDX_CKTS_WBSJ_HG_BGD202_D_C on CKTS_WBSJ_HG_BGD202 (DJXH, CKBGDH);
alter table CKTS_WBSJ_HG_BGD202
  add constraint PK_CKTS_WBSJ_HG_BGD202 primary key (UUID);

prompt
prompt Creating table CKTS_WBSJ_HG_DZSZCBAXX
prompt =====================================
prompt
create table CKTS_WBSJ_HG_DZSZCBAXX
(
  djxh    NUMBER(20),
  bah     VARCHAR2(12),
  hgqy_dm VARCHAR2(50),
  jydwmc  VARCHAR2(300),
  jgdwdm  VARCHAR2(50),
  jgdwmc  VARCHAR2(300),
  szcbarq DATE,
  bajkze  NUMBER(18,2),
  backze  NUMBER(18,2)
)
;
comment on table CKTS_WBSJ_HG_DZSZCBAXX
  is '海关电子手册备案信息';
comment on column CKTS_WBSJ_HG_DZSZCBAXX.djxh
  is '登记序号';
comment on column CKTS_WBSJ_HG_DZSZCBAXX.bah
  is '备案号';
comment on column CKTS_WBSJ_HG_DZSZCBAXX.hgqy_dm
  is '海关企业代码';
comment on column CKTS_WBSJ_HG_DZSZCBAXX.jydwmc
  is '经营单位名称';
comment on column CKTS_WBSJ_HG_DZSZCBAXX.jgdwdm
  is '加工单位代码';
comment on column CKTS_WBSJ_HG_DZSZCBAXX.jgdwmc
  is '加工单位名称';
comment on column CKTS_WBSJ_HG_DZSZCBAXX.szcbarq
  is '手（账）册备案日期';
comment on column CKTS_WBSJ_HG_DZSZCBAXX.bajkze
  is '备案进口总额';
comment on column CKTS_WBSJ_HG_DZSZCBAXX.backze
  is '备案出口总额';
create index IDX_CKTS_WBSJ_HG_DZSCBA_D_B on CKTS_WBSJ_HG_DZSZCBAXX (DJXH, BAH);

prompt
prompt Creating table CKTS_WBSJ_HG_JKJKS
prompt =================================
prompt
create table CKTS_WBSJ_HG_JKJKS
(
  djxh           NUMBER(20),
  lcslid         CHAR(32),
  uuid           VARCHAR2(32) not null,
  tfrq           DATE,
  sqdwbm         VARCHAR2(50),
  jkdwrnsrmc     VARCHAR2(300),
  jgfs_dm        CHAR(4),
  nsrsbh         VARCHAR2(20),
  skjehj         NUMBER(18,2),
  sjzxtybh       VARCHAR2(20),
  hgjkjksjhjg_dm CHAR(1),
  jhrq_1         DATE,
  dkdwsbh        VARCHAR2(300),
  zgswjg_dm      CHAR(11),
  hgjkjkscljg_dm CHAR(3),
  cwxx           VARCHAR2(3000),
  cytssbjl       VARCHAR2(60),
  sbfpjsje       NUMBER(18,2),
  sbfpsjsk       NUMBER(18,6),
  lslsbfpjsje    NUMBER(18,2),
  lslsbfpsjsk    NUMBER(18,6),
  sbspjsje       NUMBER(18,2),
  sbspsjsk       NUMBER(18,6),
  tsswjg_dm_1    CHAR(11),
  bytsbz         CHAR(1),
  hgqy_dm        VARCHAR2(50),
  wsjg           NUMBER(18,6),
  skje           NUMBER(18,2),
  jksp_dm        VARCHAR2(20),
  hgspmc         VARCHAR2(500),
  sl             NUMBER(17,5),
  dw             VARCHAR2(300),
  nxzckbz        CHAR(1),
  hshbh          VARCHAR2(50),
  yskjehj        NUMBER(18,2),
  sjgxsj         DATE,
  hcbz           CHAR(1),
  hcrq           DATE,
  skssq          VARCHAR2(60),
  drrq           DATE,
  lrr_dm         CHAR(11) not null,
  lrrq           DATE not null,
  xgr_dm         CHAR(11),
  xgrq           DATE,
  sjgsdq         CHAR(11) not null,
  sjtb_sj        TIMESTAMP(6),
  bgdhgbh        VARCHAR2(30),
  hgzyjkshm      VARCHAR2(100),
  sjlybz         CHAR(1)
)
;
comment on table CKTS_WBSJ_HG_JKJKS
  is '海关进口缴款书';
comment on column CKTS_WBSJ_HG_JKJKS.djxh
  is '登记序号';
comment on column CKTS_WBSJ_HG_JKJKS.lcslid
  is '流程实例ID';
comment on column CKTS_WBSJ_HG_JKJKS.uuid
  is 'UUID||uuid';
comment on column CKTS_WBSJ_HG_JKJKS.tfrq
  is '填发日期';
comment on column CKTS_WBSJ_HG_JKJKS.sqdwbm
  is '申请单位编码';
comment on column CKTS_WBSJ_HG_JKJKS.jkdwrnsrmc
  is '缴款单位（人）纳税人名称';
comment on column CKTS_WBSJ_HG_JKJKS.jgfs_dm
  is '监管方式代码';
comment on column CKTS_WBSJ_HG_JKJKS.nsrsbh
  is '纳税人识别号';
comment on column CKTS_WBSJ_HG_JKJKS.skjehj
  is '税款金额合计';
comment on column CKTS_WBSJ_HG_JKJKS.sjzxtybh
  is '数据中心统一编号';
comment on column CKTS_WBSJ_HG_JKJKS.hgjkjksjhjg_dm
  is '海关进口缴款书稽核结果代码';
comment on column CKTS_WBSJ_HG_JKJKS.jhrq_1
  is '稽核日期';
comment on column CKTS_WBSJ_HG_JKJKS.dkdwsbh
  is '抵扣单位识别号';
comment on column CKTS_WBSJ_HG_JKJKS.zgswjg_dm
  is '主管税务机关代码';
comment on column CKTS_WBSJ_HG_JKJKS.hgjkjkscljg_dm
  is '海关进口缴款书处理结果代码';
comment on column CKTS_WBSJ_HG_JKJKS.cwxx
  is '错误信息';
comment on column CKTS_WBSJ_HG_JKJKS.cytssbjl
  is '参与退税申报记录';
comment on column CKTS_WBSJ_HG_JKJKS.sbfpjsje
  is '申报发票计税金额';
comment on column CKTS_WBSJ_HG_JKJKS.sbfpsjsk
  is '申报发票实缴税款';
comment on column CKTS_WBSJ_HG_JKJKS.lslsbfpjsje
  is '零税率申报发票计税金额';
comment on column CKTS_WBSJ_HG_JKJKS.lslsbfpsjsk
  is '零税率申报发票实缴税款';
comment on column CKTS_WBSJ_HG_JKJKS.sbspjsje
  is '申报税票计税金额';
comment on column CKTS_WBSJ_HG_JKJKS.sbspsjsk
  is '申报税票实缴税款';
comment on column CKTS_WBSJ_HG_JKJKS.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_WBSJ_HG_JKJKS.bytsbz
  is '不予退税标志';
comment on column CKTS_WBSJ_HG_JKJKS.hgqy_dm
  is '海关企业代码';
comment on column CKTS_WBSJ_HG_JKJKS.wsjg
  is '完税价格';
comment on column CKTS_WBSJ_HG_JKJKS.skje
  is '税款金额';
comment on column CKTS_WBSJ_HG_JKJKS.jksp_dm
  is '进口商品代码';
comment on column CKTS_WBSJ_HG_JKJKS.hgspmc
  is '海关商品名称';
comment on column CKTS_WBSJ_HG_JKJKS.sl
  is '数量';
comment on column CKTS_WBSJ_HG_JKJKS.dw
  is '单位';
comment on column CKTS_WBSJ_HG_JKJKS.nxzckbz
  is '内销转出口标志';
comment on column CKTS_WBSJ_HG_JKJKS.hshbh
  is '核实函编号';
comment on column CKTS_WBSJ_HG_JKJKS.yskjehj
  is '原税款金额合计';
comment on column CKTS_WBSJ_HG_JKJKS.sjgxsj
  is '数据更新时间';
comment on column CKTS_WBSJ_HG_JKJKS.hcbz
  is '核查标志';
comment on column CKTS_WBSJ_HG_JKJKS.hcrq
  is '核查日期';
comment on column CKTS_WBSJ_HG_JKJKS.skssq
  is '税款所属期';
comment on column CKTS_WBSJ_HG_JKJKS.drrq
  is '读入日期';
comment on column CKTS_WBSJ_HG_JKJKS.lrr_dm
  is '录入人代码';
comment on column CKTS_WBSJ_HG_JKJKS.lrrq
  is '录入日期';
comment on column CKTS_WBSJ_HG_JKJKS.xgr_dm
  is '修改人代码';
comment on column CKTS_WBSJ_HG_JKJKS.xgrq
  is '修改日期';
comment on column CKTS_WBSJ_HG_JKJKS.sjgsdq
  is '数据归属地区';
comment on column CKTS_WBSJ_HG_JKJKS.sjtb_sj
  is '数据同步时间';
comment on column CKTS_WBSJ_HG_JKJKS.bgdhgbh
  is '报关单海关编号';
comment on column CKTS_WBSJ_HG_JKJKS.hgzyjkshm
  is '海关专用缴款书号码';
comment on column CKTS_WBSJ_HG_JKJKS.sjlybz
  is '数据来源标志||空||税费种认定，1||房土车申报，2||财务报表资料报送，6||小规模转一般纳税人申报，5||定期定额分月汇总申报';
create index IDX_CKTS_WBSJ_HG_JKJKS_DJXH on CKTS_WBSJ_HG_JKJKS (DJXH);
create index IDX_CKTS_WBSJ_HG_JKJKS_D_ on CKTS_WBSJ_HG_JKJKS (DJXH, HGZYJKSHM);
create index IDX_CKTS_WBSJ_HG_JKJKS_QYDM on CKTS_WBSJ_HG_JKJKS (HGQY_DM);
alter table CKTS_WBSJ_HG_JKJKS
  add constraint PK_CKTS_WBSJ_HG_JKJKS primary key (UUID);

prompt
prompt Creating table CKTS_WBSJ_HG_ZLKZDCLXX_JGB
prompt =========================================
prompt
create table CKTS_WBSJ_HG_ZLKZDCLXX_JGB
(
  uuid             VARCHAR2(32) not null,
  djxh             NUMBER(20),
  tsswjg_dm_1      CHAR(11),
  ckbgdh           VARCHAR2(21),
  ckhwtyybswtszmbh VARCHAR2(20),
  tyybswtstylx_dm  CHAR(1),
  tysl             NUMBER(17,5),
  tymylaj          NUMBER(18,2),
  tyjsje           NUMBER(18,2),
  tyybswtsclfs_dm  CHAR(1),
  cjssq            VARCHAR2(60),
  hgzyjkshm        VARCHAR2(100),
  qyuuid           VARCHAR2(32),
  dlckhwzmhm       VARCHAR2(20),
  lrr_dm           CHAR(11),
  lrrq             DATE,
  xgr_dm           CHAR(11),
  xgrq             DATE,
  sjgsdq           CHAR(11),
  sjtb_sj          TIMESTAMP(6)
)
;
comment on table CKTS_WBSJ_HG_ZLKZDCLXX_JGB
  is '总量控制待处理信息(结果表）';
comment on column CKTS_WBSJ_HG_ZLKZDCLXX_JGB.uuid
  is 'UUID||uuid';
comment on column CKTS_WBSJ_HG_ZLKZDCLXX_JGB.djxh
  is '登记序号';
comment on column CKTS_WBSJ_HG_ZLKZDCLXX_JGB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_WBSJ_HG_ZLKZDCLXX_JGB.ckbgdh
  is '出口报关单号';
comment on column CKTS_WBSJ_HG_ZLKZDCLXX_JGB.ckhwtyybswtszmbh
  is '出口货物退运已补税（未退税）证明编号';
comment on column CKTS_WBSJ_HG_ZLKZDCLXX_JGB.tyybswtstylx_dm
  is '退运已补税（未退税）退运类型代码';
comment on column CKTS_WBSJ_HG_ZLKZDCLXX_JGB.tysl
  is '退运数量';
comment on column CKTS_WBSJ_HG_ZLKZDCLXX_JGB.tymylaj
  is '退运美元离岸价';
comment on column CKTS_WBSJ_HG_ZLKZDCLXX_JGB.tyjsje
  is '退运计税金额';
comment on column CKTS_WBSJ_HG_ZLKZDCLXX_JGB.tyybswtsclfs_dm
  is '退运已补税（未退税）处理方式代码';
comment on column CKTS_WBSJ_HG_ZLKZDCLXX_JGB.cjssq
  is '冲减所属期';
comment on column CKTS_WBSJ_HG_ZLKZDCLXX_JGB.hgzyjkshm
  is '海关专用缴款书号码';
comment on column CKTS_WBSJ_HG_ZLKZDCLXX_JGB.qyuuid
  is '企业uuid';
comment on column CKTS_WBSJ_HG_ZLKZDCLXX_JGB.dlckhwzmhm
  is '代理出口货物证明号码';
comment on column CKTS_WBSJ_HG_ZLKZDCLXX_JGB.lrr_dm
  is '录入人代码';
comment on column CKTS_WBSJ_HG_ZLKZDCLXX_JGB.lrrq
  is '录入日期';
comment on column CKTS_WBSJ_HG_ZLKZDCLXX_JGB.xgr_dm
  is '修改人代码';
comment on column CKTS_WBSJ_HG_ZLKZDCLXX_JGB.xgrq
  is '修改日期';
comment on column CKTS_WBSJ_HG_ZLKZDCLXX_JGB.sjgsdq
  is '数据归属地区';
comment on column CKTS_WBSJ_HG_ZLKZDCLXX_JGB.sjtb_sj
  is '数据同步时间';

prompt
prompt Creating table CKTS_WBSJ_ZJ_CKTSBAQGXX
prompt ======================================
prompt
create table CKTS_WBSJ_ZJ_CKTSBAQGXX
(
  uuid             VARCHAR2(32) not null,
  lcslid           CHAR(32),
  djxh             NUMBER(20),
  nsrsbh           VARCHAR2(20),
  shxydm           VARCHAR2(20),
  hgqy_dm          VARCHAR2(50),
  nsrmc            VARCHAR2(300),
  dwmyjyzbadjbbh   VARCHAR2(45),
  cktsqylx_dm      VARCHAR2(2),
  tskhyhzh         VARCHAR2(50),
  qybltmsryylxdh   VARCHAR2(60),
  qybltmsryysfzjhm VARCHAR2(30),
  qybltmsryyxm     VARCHAR2(150),
  qybltmsryelxdh   VARCHAR2(60),
  qybltmsryesfzjhm VARCHAR2(30),
  qybltmsryexm     VARCHAR2(150),
  ckhwtmsjsff_dm   CHAR(1),
  tglslysfwbz      CHAR(1),
  lslysfw          VARCHAR2(30),
  xszzsyhzc        VARCHAR2(30),
  cktmsgllx        VARCHAR2(30),
  fszl             VARCHAR2(450),
  tbrq_1           DATE,
  nsrlx_dm         CHAR(1),
  nsrxydj_dm       CHAR(1),
  tsswjg_dm_1      CHAR(11),
  hsbmdm           VARCHAR2(150),
  wmzhfwqybz       CHAR(1),
  yfsjfw           VARCHAR2(50),
  gjysfwysfs       VARCHAR2(50),
  zzjgdm           VARCHAR2(50),
  tszgy_dm         CHAR(11),
  pyzjf            VARCHAR2(15),
  bachbz           CHAR(1),
  bachrq           DATE,
  barq             DATE,
  cktszhbltgdkywbz CHAR(1),
  zyspjh           VARCHAR2(30),
  wgjflgldm        VARCHAR2(6),
  tsdljgqybz       CHAR(1),
  sxfsl            NUMBER(5,2),
  zgwgjmc          VARCHAR2(90),
  fbhsbz           CHAR(1),
  fbhsbmdm         VARCHAR2(150),
  lrrq             DATE,
  lrr_dm           CHAR(11),
  xgrq             DATE,
  xgr_dm           CHAR(11),
  sjgsdq           CHAR(11),
  sjtb_sj          TIMESTAMP(6),
  rkrq             DATE,
  tsswjgmc         VARCHAR2(300)
)
;
comment on table CKTS_WBSJ_ZJ_CKTSBAQGXX
  is '外部数据总局出口退税备案全国信息';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.uuid
  is 'UUID||uuid';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.lcslid
  is '流程实例ID';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.djxh
  is '登记序号';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.nsrsbh
  is '纳税人识别号';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.shxydm
  is '社会信用代码';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.hgqy_dm
  is '海关企业代码';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.nsrmc
  is '纳税人名称';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.dwmyjyzbadjbbh
  is '对外贸易经营者备案登记表编号';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.cktsqylx_dm
  is '出口退税企业类型代码';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.tskhyhzh
  is '退税开户银行账号';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.qybltmsryylxdh
  is '企业办理退（免）税人员一联系电话';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.qybltmsryysfzjhm
  is '企业办理退（免）税人员一身份证件号码';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.qybltmsryyxm
  is '企业办理退（免）税人员一姓名';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.qybltmsryelxdh
  is '企业办理退（免）税人员二联系电话';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.qybltmsryesfzjhm
  is '企业办理退（免）税人员二身份证件号码';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.qybltmsryexm
  is '企业办理退（免）税人员二姓名';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.ckhwtmsjsff_dm
  is '出口货物退(免)税计算方法代码';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.tglslysfwbz
  is '提供零税率应税服务标志';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.lslysfw
  is '零税率应税服务';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.xszzsyhzc
  is '享受增值税优惠政策';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.cktmsgllx
  is '出口退（免）税管理类型';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.fszl
  is '附送资料||应用于进出口退税';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.tbrq_1
  is '填表日期';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.nsrlx_dm
  is '纳税人类型代码';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.nsrxydj_dm
  is '纳税人信用等级代码';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.hsbmdm
  is '核算部门代码';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.wmzhfwqybz
  is '外贸综合服务企业标志';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.yfsjfw
  is '研发设计服务';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.gjysfwysfs
  is '国际运输服务运输方式';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.zzjgdm
  is '组织机构代码';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.tszgy_dm
  is '退税专管员代码';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.pyzjf
  is '拼音助记符';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.bachbz
  is '备案撤回标志';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.bachrq
  is '备案撤回日期';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.barq
  is '备案日期';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.cktszhbltgdkywbz
  is '出口退税账户办理托管贷款业务标志';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.zyspjh
  is '专营商品集合';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.wgjflgldm
  is '外管局分类管理代码';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.tsdljgqybz
  is '退税代理机构企业标志';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.sxfsl
  is '手续费税率';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.zgwgjmc
  is '主管外管局名称';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.fbhsbz
  is '分部核算标志';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.fbhsbmdm
  is '分部核算部门代码';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.lrrq
  is '录入日期';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.lrr_dm
  is '录入人代码';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.xgrq
  is '修改日期';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.xgr_dm
  is '修改人代码';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.sjgsdq
  is '数据归属地区';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.sjtb_sj
  is '数据同步时间';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.rkrq
  is '入库日期';
comment on column CKTS_WBSJ_ZJ_CKTSBAQGXX.tsswjgmc
  is '退税税务机关名称';
create index IDX_CKTS_WBSJ_ZJ_CKTSBAQGXX_N on CKTS_WBSJ_ZJ_CKTSBAQGXX (NSRSBH);
create index IDX_CKTS_WBSJ_ZJ_CKTSBAQGXX_S on CKTS_WBSJ_ZJ_CKTSBAQGXX (SHXYDM);

prompt
prompt Creating table CKTS_WBSJ_ZJ_JHBFXCJG
prompt ====================================
prompt
create table CKTS_WBSJ_ZJ_JHBFXCJG
(
  uuid           VARCHAR2(32) not null,
  djxh           NUMBER(20),
  fpzl_dm        VARCHAR2(12),
  fp_dm          VARCHAR2(12) not null,
  fphm           VARCHAR2(30) not null,
  je             NUMBER(18,2),
  se             NUMBER(18,6),
  xfnsrsbh       VARCHAR2(20),
  gfnsrsbh       VARCHAR2(20),
  kprq           DATE,
  zsswjg_dm      CHAR(11),
  jhrq_1         DATE,
  dklbz          CHAR(1),
  jcbdfpje       NUMBER(18,2),
  jcbdfpse       NUMBER(18,6),
  jcbdfpxfnsrsbh VARCHAR2(20),
  jcbdfpgfnsrsbh VARCHAR2(20),
  jcbdfpkprq     DATE,
  jcbdfpnsrmc    VARCHAR2(300),
  jhjglb_dm      CHAR(1),
  jhjgbflx_dm    CHAR(1),
  csfpje         NUMBER(18,2),
  csfpse         NUMBER(18,6),
  csfpxfnsrsbh   VARCHAR2(20),
  csfpgfnsrsbh   VARCHAR2(20),
  csfpkprq       DATE,
  xcrq           DATE,
  xcjglb_dm      CHAR(1),
  xczt           CHAR(1),
  rkrq           DATE,
  hcbz           CHAR(1),
  xcbz           CHAR(1),
  hcjglb_dm      CHAR(1),
  tsswjg_dm_1    CHAR(11),
  lrr_dm         CHAR(11) not null,
  lrrq           DATE not null,
  xgr_dm         CHAR(11),
  xgrq           DATE,
  sjgsdq         CHAR(11) not null,
  sjtb_sj        TIMESTAMP(6)
)
;
comment on table CKTS_WBSJ_ZJ_JHBFXCJG
  is '总局交叉稽核不符发票信息协查结果信息';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.uuid
  is 'UUID||uuid';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.djxh
  is '登记序号';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.fpzl_dm
  is '发票种类代码';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.fp_dm
  is '发票代码';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.fphm
  is '发票号码';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.je
  is '金额';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.se
  is '税额';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.xfnsrsbh
  is '销方纳税人识别号';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.gfnsrsbh
  is '购方纳税人识别号';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.kprq
  is '开票日期';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.zsswjg_dm
  is '征收税务机关代码';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.jhrq_1
  is '稽核日期';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.dklbz
  is '抵扣联标志';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.jcbdfpje
  is '稽查比对发票金额';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.jcbdfpse
  is '稽查比对发票税额';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.jcbdfpxfnsrsbh
  is '稽查比对发票销方纳税人识别号';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.jcbdfpgfnsrsbh
  is '稽查比对发票购方纳税人识别号';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.jcbdfpkprq
  is '稽查比对发票开票日期';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.jcbdfpnsrmc
  is '稽查比对发票纳税人名称';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.jhjglb_dm
  is '稽核结果类别代码';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.jhjgbflx_dm
  is '稽核结果不符类型代码';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.csfpje
  is '查实发票金额';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.csfpse
  is '查实发票税额';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.csfpxfnsrsbh
  is '查实发票销方纳税人识别号';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.csfpgfnsrsbh
  is '查实发票购方纳税人识别号';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.csfpkprq
  is '查实发票开票日期';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.xcrq
  is '协查日期';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.xcjglb_dm
  is '协查结果类别代码';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.xczt
  is '协查状态';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.rkrq
  is '入库日期';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.hcbz
  is '核查标志';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.xcbz
  is '协查标志';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.hcjglb_dm
  is '核查结果类别代码';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.lrr_dm
  is '录入人代码';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.lrrq
  is '录入日期';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.xgr_dm
  is '修改人代码';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.xgrq
  is '修改日期';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.sjgsdq
  is '数据归属地区';
comment on column CKTS_WBSJ_ZJ_JHBFXCJG.sjtb_sj
  is '数据同步时间';
create index IDX_CKTS_WBSJ_ZJ_JHBFXCJG_HD on CKTS_WBSJ_ZJ_JHBFXCJG (FP_DM, FPHM);
alter table CKTS_WBSJ_ZJ_JHBFXCJG
  add constraint PK_CKTS_WBSJ_ZJ_JHBFXCJG primary key (UUID);

prompt
prompt Creating table CKTS_WBSJ_ZJ_SCWTDBBA
prompt ====================================
prompt
create table CKTS_WBSJ_ZJ_SCWTDBBA
(
  djxh            NUMBER(20),
  lcslid          CHAR(32),
  uuid            VARCHAR2(32) not null,
  nsrmc           VARCHAR2(300),
  hgqy_dm         VARCHAR2(50),
  nsrsbh          VARCHAR2(20),
  shxydm          VARCHAR2(20),
  wmzhfwqynsrmc   VARCHAR2(300),
  wmzhfwqyhgqydm  VARCHAR2(50),
  wmzhfwqynsrsbh  VARCHAR2(20),
  wmzhfwqyshxydm  VARCHAR2(20),
  wmzhfwhtxyhm    VARCHAR2(60),
  tskhyhmc        VARCHAR2(120),
  tskhyhzh        VARCHAR2(50),
  dbtsbalczt_dm   CHAR(1),
  tsswjg_dm_1     CHAR(11),
  lrrq            DATE not null,
  lrr_dm          CHAR(11) not null,
  xgrq            DATE,
  xgr_dm          CHAR(11),
  sjgsdq          CHAR(11) not null,
  sjtb_sj         TIMESTAMP(6),
  bachbz          CHAR(1),
  bachrq          DATE,
  rkrq            DATE,
  tbrq_1          DATE,
  fqcktmsqbz      CHAR(1),
  fqcktmsqqsrq    DATE,
  fqcktmsqjzrq    DATE,
  tzcktmsqbz      CHAR(1),
  tzcktmsqqsrq    DATE,
  tzcktmsqjzrq    DATE,
  tsgmsbz         CHAR(1),
  tsgmsqsrq       DATE,
  tsgmsjzrq       DATE,
  nsrlx_dm        CHAR(1),
  nsrrdsjq        DATE,
  nsrrdsjz        DATE,
  ybnsrzxgmnsrsjq DATE,
  ybnsrzxgmnsrsjz DATE
)
;
comment on table CKTS_WBSJ_ZJ_SCWTDBBA
  is '生产委托代办退税备案信息接收表';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.djxh
  is '登记序号(外贸综合服务企业)';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.lcslid
  is '流程实例ID';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.uuid
  is 'UUID||uuid';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.nsrmc
  is '纳税人名称';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.hgqy_dm
  is '海关企业代码';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.nsrsbh
  is '纳税人识别号';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.shxydm
  is '社会信用代码';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.wmzhfwqynsrmc
  is '外贸综合服务企业纳税人名称';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.wmzhfwqyhgqydm
  is '外贸综合服务企业海关企业代码';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.wmzhfwqynsrsbh
  is '外贸综合服务企业纳税人识别号';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.wmzhfwqyshxydm
  is '外贸综合服务企业社会信用代码';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.wmzhfwhtxyhm
  is '外贸综合服务合同（协议）号码';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.tskhyhmc
  is '退税开户银行名称';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.tskhyhzh
  is '退税开户银行账号';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.dbtsbalczt_dm
  is '代办退税备案流程状态代码';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.lrrq
  is '录入日期';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.lrr_dm
  is '录入人代码';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.xgrq
  is '修改日期';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.xgr_dm
  is '修改人代码';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.sjgsdq
  is '数据归属地区';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.sjtb_sj
  is '数据同步时间';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.bachbz
  is '备案撤回标志||备案撤回标志';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.bachrq
  is '备案撤回日期';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.rkrq
  is '入库日期';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.tbrq_1
  is '填表日期';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.fqcktmsqbz
  is '放弃出口退（免）税权标志';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.fqcktmsqqsrq
  is '放弃出口退（免）税权起始日期';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.fqcktmsqjzrq
  is '放弃出口退（免）税权截止日期';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.tzcktmsqbz
  is '停止出口退（免）税权标志';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.tzcktmsqqsrq
  is '停止出口退（免）税权起始日期';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.tzcktmsqjzrq
  is '停止出口退（免）税权截止日期';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.tsgmsbz
  is '退税改免税标志';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.tsgmsqsrq
  is '退税改免税起始日期';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.tsgmsjzrq
  is '退税改免税截止日期';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.nsrlx_dm
  is '纳税人类型代码';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.nsrrdsjq
  is '纳税人认定时间起';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.nsrrdsjz
  is '纳税人认定时间止';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.ybnsrzxgmnsrsjq
  is '一般纳税人转小规模纳税人时间起';
comment on column CKTS_WBSJ_ZJ_SCWTDBBA.ybnsrzxgmnsrsjz
  is '一般纳税人转小规模纳税人时间止';
create index IDX_CKTS_WBSJ_ZJ_SCWTDBBA_HG on CKTS_WBSJ_ZJ_SCWTDBBA (HGQY_DM);
create index IDX_CKTS_WBSJ_ZJ_SCWTDBBA_WM on CKTS_WBSJ_ZJ_SCWTDBBA (WMZHFWQYHGQYDM);
alter table CKTS_WBSJ_ZJ_SCWTDBBA
  add constraint PK_CKTS_WBSJ_ZJ_SCWTDBBA primary key (UUID);

prompt
prompt Creating table CKTS_WBSJ_ZJ_TYYBSWTSZM
prompt ======================================
prompt
create table CKTS_WBSJ_ZJ_TYYBSWTSZM
(
  uuid             VARCHAR2(32) not null,
  ckhwtyybswtszmbh VARCHAR2(20),
  sbbh_1           VARCHAR2(20),
  rq               DATE,
  djxh             NUMBER(20) not null,
  stfshxydm        VARCHAR2(20),
  stfnsrsbh        VARCHAR2(20),
  wtfhgqydm        VARCHAR2(50),
  wtfnsrsbh        VARCHAR2(20),
  wtfshxydm        VARCHAR2(20),
  ssq              VARCHAR2(60),
  sbxh             VARCHAR2(50),
  hggqka_dm        CHAR(4),
  ckbgdh           VARCHAR2(21),
  ckrq_1           DATE,
  ckshhxdh         VARCHAR2(30),
  ckfph            VARCHAR2(30),
  cksp_dm          VARCHAR2(20),
  ckspmc           VARCHAR2(75),
  hgjldwmc         VARCHAR2(75),
  cksl             NUMBER(17,5),
  yjsje            NUMBER(18,2),
  ytzzse_1         NUMBER(18,6),
  ytxfse_1         NUMBER(18,6),
  tysl             NUMBER(17,5),
  tyjsje           NUMBER(18,2),
  ytsl_1           NUMBER(16,6),
  ycjmdtse         NUMBER(18,2),
  cjssq            VARCHAR2(60),
  ybzzse_1         NUMBER(18,6),
  ybxfse_1         NUMBER(18,6),
  jkshm            VARCHAR2(20),
  hgspmc           VARCHAR2(500),
  tsswjg_dm_1      CHAR(11),
  ysbmdtse         NUMBER(18,6),
  jhpzh            VARCHAR2(75),
  dlckhwzmhm       VARCHAR2(20),
  ckemy            NUMBER(18,2),
  tyybswtstylx_dm  CHAR(1),
  ysybs            CHAR(1),
  wtfcktszmbh      VARCHAR2(20),
  rkrq             DATE,
  sybz             CHAR(1),
  sjgxsj           DATE,
  lrr_dm           CHAR(11),
  lrrq             DATE,
  xgr_dm           CHAR(11),
  xgrq             DATE,
  sjgsdq           CHAR(11),
  sjtb_sj          TIMESTAMP(6)
)
;
comment on table CKTS_WBSJ_ZJ_TYYBSWTSZM
  is '委托方出口货物退运已补税（未退税）证明';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.uuid
  is 'UUID||uuid';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.ckhwtyybswtszmbh
  is '出口货物退运已补税（未退税）证明编号';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.sbbh_1
  is '申报编号';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.rq
  is '日期';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.djxh
  is '登记序号';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.stfshxydm
  is '受托方社会信用代码';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.stfnsrsbh
  is '受托方纳税人识别号';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.wtfhgqydm
  is '委托方海关企业代码';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.wtfnsrsbh
  is '委托方纳税人识别号';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.wtfshxydm
  is '委托方社会信用代码';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.ssq
  is '所属期';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.sbxh
  is '申报序号';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.hggqka_dm
  is '海关关区（口岸）代码';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.ckbgdh
  is '出口报关单号';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.ckrq_1
  is '出口日期';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.ckshhxdh
  is '出口收汇核销单号';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.ckfph
  is '出口发票号';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.cksp_dm
  is '出口商品代码';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.ckspmc
  is '出口商品名称';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.hgjldwmc
  is '海关计量单位名称';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.cksl
  is '出口数量';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.yjsje
  is '原计税金额';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.ytzzse_1
  is '原退增值税额';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.ytxfse_1
  is '原退消费税额';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.tysl
  is '退运数量';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.tyjsje
  is '退运计税金额';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.ytsl_1
  is '原退税率';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.ycjmdtse
  is '已冲减免抵退税额||应用于进出口退税';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.cjssq
  is '冲减所属期';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.ybzzse_1
  is '已补增值税额';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.ybxfse_1
  is '已补消费税额';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.jkshm
  is '缴款书号码';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.hgspmc
  is '海关商品名称';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.ysbmdtse
  is '原申报免抵退税额';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.jhpzh
  is '进货凭证号';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.dlckhwzmhm
  is '代理出口货物证明号码';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.ckemy
  is '出口额（美元）';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.tyybswtstylx_dm
  is '退运已补税（未退税）退运类型代码';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.ysybs
  is '已使用标识';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.wtfcktszmbh
  is '委托方出口退税证明编号';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.rkrq
  is '入库日期';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.sybz
  is '使用标志';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.sjgxsj
  is '数据更新时间';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.lrr_dm
  is '录入人代码';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.lrrq
  is '录入日期';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.xgr_dm
  is '修改人代码';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.xgrq
  is '修改日期';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.sjgsdq
  is '数据归属地区';
comment on column CKTS_WBSJ_ZJ_TYYBSWTSZM.sjtb_sj
  is '数据同步时间';
create index IDX_CKTS_WBSJ_ZJ_TYYBS_D_C on CKTS_WBSJ_ZJ_TYYBSWTSZM (DJXH, CKHWTYYBSWTSZMBH);
alter table CKTS_WBSJ_ZJ_TYYBSWTSZM
  add constraint PK_CKTS_WBSJ_ZJ_TYYBSWTSZM primary key (UUID);

prompt
prompt Creating table CKTS_WBSJ_ZJ_WTCKHWZM
prompt ====================================
prompt
create table CKTS_WBSJ_ZJ_WTCKHWZM
(
  uuid        VARCHAR2(32) not null,
  wtckhwzmbh  VARCHAR2(20),
  djxh        NUMBER(20),
  stfmc       VARCHAR2(300),
  stfnsrsbh   VARCHAR2(20),
  stfhgqydm   VARCHAR2(50),
  rq          DATE,
  wtfnsrmc    VARCHAR2(300),
  wtfnsrsbh   VARCHAR2(20),
  ckrq_1      DATE,
  ckbgdh      VARCHAR2(21),
  cksp_dm     VARCHAR2(20),
  ckspmc      VARCHAR2(75),
  hbzm_dm     CHAR(3),
  cjzj        NUMBER(18,2),
  dlckxyh     VARCHAR2(30),
  bz_1        CHAR(1),
  ssq         VARCHAR2(60),
  tsswjg_dm_1 CHAR(11),
  bz          VARCHAR2(3000),
  cqbz_1      CHAR(1),
  zybz        CHAR(1),
  rkrq        DATE,
  lrr_dm      CHAR(11) not null,
  lrrq        DATE not null,
  xgr_dm      CHAR(11),
  xgrq        DATE,
  sjgsdq      CHAR(11) not null,
  sjtb_sj     TIMESTAMP(6),
  wtfshxydm   VARCHAR2(20)
)
;
comment on table CKTS_WBSJ_ZJ_WTCKHWZM
  is '总局委托出口货物证明';
comment on column CKTS_WBSJ_ZJ_WTCKHWZM.uuid
  is 'UUID||uuid';
comment on column CKTS_WBSJ_ZJ_WTCKHWZM.wtckhwzmbh
  is '委托出口货物证明编号';
comment on column CKTS_WBSJ_ZJ_WTCKHWZM.djxh
  is '登记序号';
comment on column CKTS_WBSJ_ZJ_WTCKHWZM.stfmc
  is '受托方名称';
comment on column CKTS_WBSJ_ZJ_WTCKHWZM.stfnsrsbh
  is '受托方纳税人识别号';
comment on column CKTS_WBSJ_ZJ_WTCKHWZM.stfhgqydm
  is '受托方海关企业代码';
comment on column CKTS_WBSJ_ZJ_WTCKHWZM.rq
  is '日期';
comment on column CKTS_WBSJ_ZJ_WTCKHWZM.wtfnsrmc
  is '委托方纳税人名称';
comment on column CKTS_WBSJ_ZJ_WTCKHWZM.wtfnsrsbh
  is '委托方纳税人识别号';
comment on column CKTS_WBSJ_ZJ_WTCKHWZM.ckrq_1
  is '出口日期';
comment on column CKTS_WBSJ_ZJ_WTCKHWZM.ckbgdh
  is '出口报关单号';
comment on column CKTS_WBSJ_ZJ_WTCKHWZM.cksp_dm
  is '出口商品代码';
comment on column CKTS_WBSJ_ZJ_WTCKHWZM.ckspmc
  is '出口商品名称';
comment on column CKTS_WBSJ_ZJ_WTCKHWZM.hbzm_dm
  is '货币字母代码';
comment on column CKTS_WBSJ_ZJ_WTCKHWZM.cjzj
  is '成交总价||成交总价';
comment on column CKTS_WBSJ_ZJ_WTCKHWZM.dlckxyh
  is '代理出口协议号';
comment on column CKTS_WBSJ_ZJ_WTCKHWZM.bz_1
  is '标志';
comment on column CKTS_WBSJ_ZJ_WTCKHWZM.ssq
  is '所属期';
comment on column CKTS_WBSJ_ZJ_WTCKHWZM.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_WBSJ_ZJ_WTCKHWZM.bz
  is '备注';
comment on column CKTS_WBSJ_ZJ_WTCKHWZM.cqbz_1
  is '超期标志';
comment on column CKTS_WBSJ_ZJ_WTCKHWZM.zybz
  is '自营标志';
comment on column CKTS_WBSJ_ZJ_WTCKHWZM.rkrq
  is '入库日期';
comment on column CKTS_WBSJ_ZJ_WTCKHWZM.lrr_dm
  is '录入人代码';
comment on column CKTS_WBSJ_ZJ_WTCKHWZM.lrrq
  is '录入日期';
comment on column CKTS_WBSJ_ZJ_WTCKHWZM.xgr_dm
  is '修改人代码';
comment on column CKTS_WBSJ_ZJ_WTCKHWZM.xgrq
  is '修改日期';
comment on column CKTS_WBSJ_ZJ_WTCKHWZM.sjgsdq
  is '数据归属地区';
comment on column CKTS_WBSJ_ZJ_WTCKHWZM.sjtb_sj
  is '数据同步时间';
comment on column CKTS_WBSJ_ZJ_WTCKHWZM.wtfshxydm
  is '委托方社会信用代码';
create index IDX_CKTS_WBSJ_WTCKHWZM_DJXH on CKTS_WBSJ_ZJ_WTCKHWZM (DJXH);
create index IDX_CKTS_WBSJ_WTCKHWZM_S_W on CKTS_WBSJ_ZJ_WTCKHWZM (STFHGQYDM, WTCKHWZMBH);
create index IDX_CKTS_WBSJ_WTCKHWZM_W_C on CKTS_WBSJ_ZJ_WTCKHWZM (WTFNSRSBH, CKBGDH);
alter table CKTS_WBSJ_ZJ_WTCKHWZM
  add constraint PK_CKTS_WBSJ_ZJ_WTCKHWZM primary key (UUID);

prompt
prompt Creating table CKTS_WBSJ_ZJ_XKFP
prompt ================================
prompt
create table CKTS_WBSJ_ZJ_XKFP
(
  uuid        VARCHAR2(32) not null,
  xh          NUMBER(8),
  xxlymc      VARCHAR2(150),
  tsswjg_dm_1 CHAR(11),
  tsswjgmc    VARCHAR2(300),
  ghfnsrsbh   VARCHAR2(20),
  ghfnsrmc    VARCHAR2(300),
  kprq        DATE,
  fp_dm       VARCHAR2(12),
  fphm        VARCHAR2(30),
  je          NUMBER(18,2),
  se          NUMBER(18,6),
  xhfnsrsbh   VARCHAR2(20),
  xhfnsrmc    VARCHAR2(300),
  syjsbz      CHAR(1),
  cksp_dm     VARCHAR2(20),
  bz          VARCHAR2(3000),
  cjrq_1      DATE,
  czr         VARCHAR2(32),
  czsj        DATE,
  lrr_dm      CHAR(11) not null,
  lrrq        DATE not null,
  xgr_dm      CHAR(11),
  xgrq        DATE,
  sjgsdq      CHAR(11) not null,
  sjtb_sj     TIMESTAMP(6),
  djxh        NUMBER(20)
)
;
comment on table CKTS_WBSJ_ZJ_XKFP
  is '总局虚开发票';
comment on column CKTS_WBSJ_ZJ_XKFP.uuid
  is 'UUID||uuid';
comment on column CKTS_WBSJ_ZJ_XKFP.xh
  is '序号';
comment on column CKTS_WBSJ_ZJ_XKFP.xxlymc
  is '信息来源名称';
comment on column CKTS_WBSJ_ZJ_XKFP.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_WBSJ_ZJ_XKFP.tsswjgmc
  is '退税税务机关名称';
comment on column CKTS_WBSJ_ZJ_XKFP.ghfnsrsbh
  is '购货方纳税人识别号';
comment on column CKTS_WBSJ_ZJ_XKFP.ghfnsrmc
  is '购货方纳税人名称';
comment on column CKTS_WBSJ_ZJ_XKFP.kprq
  is '开票日期';
comment on column CKTS_WBSJ_ZJ_XKFP.fp_dm
  is '发票代码';
comment on column CKTS_WBSJ_ZJ_XKFP.fphm
  is '发票号码';
comment on column CKTS_WBSJ_ZJ_XKFP.je
  is '金额';
comment on column CKTS_WBSJ_ZJ_XKFP.se
  is '税额';
comment on column CKTS_WBSJ_ZJ_XKFP.xhfnsrsbh
  is '销货方纳税人识别号';
comment on column CKTS_WBSJ_ZJ_XKFP.xhfnsrmc
  is '销货方纳税人名称';
comment on column CKTS_WBSJ_ZJ_XKFP.syjsbz
  is '善意接受标志';
comment on column CKTS_WBSJ_ZJ_XKFP.cksp_dm
  is '出口商品代码';
comment on column CKTS_WBSJ_ZJ_XKFP.bz
  is '备注';
comment on column CKTS_WBSJ_ZJ_XKFP.cjrq_1
  is '采集日期';
comment on column CKTS_WBSJ_ZJ_XKFP.czr
  is '操作人';
comment on column CKTS_WBSJ_ZJ_XKFP.czsj
  is '操作时间||操作时间';
comment on column CKTS_WBSJ_ZJ_XKFP.lrr_dm
  is '录入人代码';
comment on column CKTS_WBSJ_ZJ_XKFP.lrrq
  is '录入日期';
comment on column CKTS_WBSJ_ZJ_XKFP.xgr_dm
  is '修改人代码';
comment on column CKTS_WBSJ_ZJ_XKFP.xgrq
  is '修改日期';
comment on column CKTS_WBSJ_ZJ_XKFP.sjgsdq
  is '数据归属地区';
comment on column CKTS_WBSJ_ZJ_XKFP.sjtb_sj
  is '数据同步时间';
comment on column CKTS_WBSJ_ZJ_XKFP.djxh
  is '登记序号';
create index IDX_CKTS_WBSJ_ZJ_XKFP_FPDMHM on CKTS_WBSJ_ZJ_XKFP (FP_DM, FPHM);
create index IDX_CKTS_WBSJ_ZJ_XKFP_G on CKTS_WBSJ_ZJ_XKFP (GHFNSRSBH);
create index IDX_CKTS_WBSJ_ZJ_XKFP_X on CKTS_WBSJ_ZJ_XKFP (XHFNSRSBH);
create index IDX_CKTS_WBSJ_ZJ_XKFP_XH on CKTS_WBSJ_ZJ_XKFP (XH);
alter table CKTS_WBSJ_ZJ_XKFP
  add constraint PK_CKTS_WBSJ_ZJ_XKFP primary key (UUID);

prompt
prompt Creating table CKTS_WBSJ_ZJ_ZJZYJKS
prompt ===================================
prompt
create table CKTS_WBSJ_ZJ_ZJZYJKS
(
  uuid           VARCHAR2(32) not null,
  djxh           NUMBER(20),
  lcslid         CHAR(32),
  jkshm          VARCHAR2(20),
  yjkshm         VARCHAR2(20),
  tfrq           DATE,
  tfswjg_dm      CHAR(11),
  jkdwrnsrsbh    VARCHAR2(20),
  jkdwrnsrmc     VARCHAR2(300),
  jkdwrkhyhmc    VARCHAR2(120),
  jkdwrzh        VARCHAR2(50),
  ghfnsrsbh      VARCHAR2(20),
  ghfnsrmc       VARCHAR2(300),
  ghqyhg_dm      VARCHAR2(50),
  ckhwxfszyjkszh VARCHAR2(75),
  yskm_dm        VARCHAR2(9),
  yskmmc         VARCHAR2(150),
  yskmjc         CHAR(1),
  hwlwmc         VARCHAR2(300),
  sjse           NUMBER(18,6),
  kssl           NUMBER(18,6),
  jldw           VARCHAR2(300),
  spdj           NUMBER(16,4),
  jsje           NUMBER(18,2),
  fdsl           NUMBER(16,6),
  zsl            NUMBER(16,6),
  sz             CHAR(1),
  wspzhmjh       VARCHAR2(200),
  sksssq         DATE,
  sbspjsje       NUMBER(18,2),
  sbsjse         NUMBER(18,6),
  rzjg           CHAR(1),
  qfbz           CHAR(1),
  clbz_1         CHAR(1),
  ssny           CHAR(6),
  cytssbjl       VARCHAR2(60),
  jsbs           CHAR(1),
  drrq           DATE,
  djzclx_dm      CHAR(3),
  pzzg           VARCHAR2(45),
  skgk_dm        CHAR(10),
  skgkmc         VARCHAR2(75),
  skxjrq         DATE,
  dzspmxxh       NUMBER(8),
  zsxm_dm        VARCHAR2(5),
  tsswjg_dm_1    CHAR(11),
  lrr_dm         CHAR(11) not null,
  lrrq           DATE not null,
  xgr_dm         CHAR(11),
  xgrq           DATE,
  sjgsdq         CHAR(11) not null,
  sjtb_sj        TIMESTAMP(6),
  xtsphm         VARCHAR2(300),
  bytsbz         CHAR(1)
)
;
comment on table CKTS_WBSJ_ZJ_ZJZYJKS
  is '接收到的核心征管消费税缴款';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.uuid
  is 'UUID||uuid';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.djxh
  is '登记序号';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.lcslid
  is '流程实例ID';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.jkshm
  is '缴款书号码';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.yjkshm
  is '原缴款书号码';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.tfrq
  is '填发日期';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.tfswjg_dm
  is '填发税务机关代码';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.jkdwrnsrsbh
  is '缴款单位（人）纳税人识别号';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.jkdwrnsrmc
  is '缴款单位（人）纳税人名称';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.jkdwrkhyhmc
  is '缴款单位（人）开户银行名称';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.jkdwrzh
  is '缴款单位（人）账号';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.ghfnsrsbh
  is '购货方纳税人识别号';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.ghfnsrmc
  is '购货方纳税人名称';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.ghqyhg_dm
  is '购货企业海关代码';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.ckhwxfszyjkszh
  is '出口货物消费税专用缴款书字号';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.yskm_dm
  is '预算科目代码';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.yskmmc
  is '预算科目名称';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.yskmjc
  is '预算科目级次';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.hwlwmc
  is '货物劳务名称';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.sjse
  is '实缴税额';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.kssl
  is '课税数量';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.jldw
  is '计量单位||计量单位';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.spdj
  is '商品单价';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.jsje
  is '计税金额';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.fdsl
  is '法定税率';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.zsl
  is '征收率';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.sz
  is '税种';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.wspzhmjh
  is '完税凭证号码集合';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.sksssq
  is '税款所属时期';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.sbspjsje
  is '申报税票计税金额';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.sbsjse
  is '申报实缴税额';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.rzjg
  is '认证结果';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.qfbz
  is '清分标志';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.clbz_1
  is '重录标志';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.ssny
  is '所属年月';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.cytssbjl
  is '参与退税申报记录';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.jsbs
  is '缴销标识';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.drrq
  is '读入日期';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.djzclx_dm
  is '登记注册类型代码';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.pzzg
  is '票证字轨';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.skgk_dm
  is '收款国库代码';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.skgkmc
  is '收款国库名称';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.skxjrq
  is '税款限缴日期';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.dzspmxxh
  is '电子税票明细序号';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.zsxm_dm
  is '征收项目代码';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.lrr_dm
  is '录入人代码';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.lrrq
  is '录入日期';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.xgr_dm
  is '修改人代码';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.xgrq
  is '修改日期';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.sjgsdq
  is '数据归属地区';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.sjtb_sj
  is '数据同步时间';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.xtsphm
  is '系统税票号码';
comment on column CKTS_WBSJ_ZJ_ZJZYJKS.bytsbz
  is '不予退税标志';
create index IDX_CKTS_WBSJ_ZJ_ZJZYJKS_GH on CKTS_WBSJ_ZJ_ZJZYJKS (GHQYHG_DM);
create index IDX_CKTS_WBSJ_ZJ_ZJZYJKS_J on CKTS_WBSJ_ZJ_ZJZYJKS (JKSHM);
alter table CKTS_WBSJ_ZJ_ZJZYJKS
  add constraint PK_CKTS_WBSJ_ZJ_ZJZYJKS primary key (UUID);

prompt
prompt Creating table CKTS_XXBD_SHQ
prompt ============================
prompt
create table CKTS_XXBD_SHQ
(
  djxh     NUMBER(20) not null,
  sbywb_dm VARCHAR2(20),
  sssq     VARCHAR2(6),
  sbpc     NUMBER(9),
  sbid     NUMBER(18),
  crtime   DATE,
  note     VARCHAR2(20) default ' '
)
;
comment on table CKTS_XXBD_SHQ
  is '审核区（每个企业[NSRDZDAH]同时只能有一条记录）';
comment on column CKTS_XXBD_SHQ.djxh
  is '登记序号||金三企业标识';
comment on column CKTS_XXBD_SHQ.sbywb_dm
  is '申报业务表代码';
comment on column CKTS_XXBD_SHQ.sssq
  is '申报年月';
comment on column CKTS_XXBD_SHQ.sbpc
  is '申报批次';
comment on column CKTS_XXBD_SHQ.sbid
  is '申报业务序号，同SB_SBXX_HZ的ID';
comment on column CKTS_XXBD_SHQ.crtime
  is '创建时间';
comment on column CKTS_XXBD_SHQ.note
  is '备注';
alter table CKTS_XXBD_SHQ
  add constraint PK_CKTS_XXBD_SHQ primary key (DJXH);

prompt
prompt Creating table CKTS_XXBD_SHQ_YDXX
prompt =================================
prompt
create table CKTS_XXBD_SHQ_YDXX
(
  djxh      NUMBER(20) not null,
  sbywb_dm  VARCHAR2(20),
  sssq      VARCHAR2(6),
  sbpc      NUMBER(9),
  sbid      NUMBER(18) not null,
  err_ly    CHAR(1) not null,
  xh        NUMBER(18) not null,
  err_obj   VARCHAR2(30) default ' ',
  glywb1    VARCHAR2(50) default ' ',
  glywb2    VARCHAR2(50) default ' ',
  glywb3    VARCHAR2(50) default ' ',
  glywz1    VARCHAR2(50) default ' ',
  glywz2    VARCHAR2(50) default ' ',
  ydcode    VARCHAR2(30) default ' ',
  err_lev   VARCHAR2(10) default ' ',
  err_msg   VARCHAR2(500) default ' ',
  pass_flag VARCHAR2(1) default ' ',
  crtime    DATE
)
;
comment on table CKTS_XXBD_SHQ_YDXX
  is '审核_疑点信息';
comment on column CKTS_XXBD_SHQ_YDXX.djxh
  is '登记序号||金三企业标识';
comment on column CKTS_XXBD_SHQ_YDXX.sbywb_dm
  is '申报年月';
comment on column CKTS_XXBD_SHQ_YDXX.sssq
  is '申报年月';
comment on column CKTS_XXBD_SHQ_YDXX.sbpc
  is '申报批次';
comment on column CKTS_XXBD_SHQ_YDXX.sbid
  is '申报业务序号，同SB_SBXX_HZ的ID';
comment on column CKTS_XXBD_SHQ_YDXX.err_ly
  is '错误来源（0：数据自检；1：信息比对；2：审核系统反馈）';
comment on column CKTS_XXBD_SHQ_YDXX.xh
  is '流水号';
comment on column CKTS_XXBD_SHQ_YDXX.err_obj
  is '疑点对象（单证名称）';
comment on column CKTS_XXBD_SHQ_YDXX.glywb1
  is '关联业务表1';
comment on column CKTS_XXBD_SHQ_YDXX.glywb2
  is '关联业务表2';
comment on column CKTS_XXBD_SHQ_YDXX.glywb3
  is '关联业务表3';
comment on column CKTS_XXBD_SHQ_YDXX.glywz1
  is '关联业务值1';
comment on column CKTS_XXBD_SHQ_YDXX.glywz2
  is '关联业务值2';
comment on column CKTS_XXBD_SHQ_YDXX.ydcode
  is '疑点代码';
comment on column CKTS_XXBD_SHQ_YDXX.err_lev
  is '错误级别';
comment on column CKTS_XXBD_SHQ_YDXX.err_msg
  is '出错信息';
comment on column CKTS_XXBD_SHQ_YDXX.pass_flag
  is '可人工挑过标志';
comment on column CKTS_XXBD_SHQ_YDXX.crtime
  is '创建时间';
create index IDX_CKTS_XXBD_SHQ_YDXX_DJXH on CKTS_XXBD_SHQ_YDXX (DJXH);
alter table CKTS_XXBD_SHQ_YDXX
  add constraint PK_CKTS_XXBD_SHQ_YDXX primary key (XH);

prompt
prompt Creating table CKTS_XXBD_YDXX
prompt =============================
prompt
create table CKTS_XXBD_YDXX
(
  nsrdzdah  NUMBER(20) not null,
  sbywb_dm  VARCHAR2(20),
  sssq      VARCHAR2(6),
  sbpc      NUMBER(9),
  sbid      NUMBER(18) not null,
  err_ly    CHAR(1) not null,
  xh        NUMBER(18) not null,
  err_obj   VARCHAR2(30) default ' ',
  glywb1    VARCHAR2(50) default ' ',
  glywb2    VARCHAR2(50) default ' ',
  glywb3    VARCHAR2(50) default ' ',
  glywz1    VARCHAR2(50) default ' ',
  glywz2    VARCHAR2(50) default ' ',
  ydcode    VARCHAR2(30) default ' ',
  err_lev   VARCHAR2(10) default ' ',
  err_msg   VARCHAR2(500) default ' ',
  pass_flag VARCHAR2(1) default ' ',
  crtime    DATE
)
;
comment on table CKTS_XXBD_YDXX
  is '审核_疑点信息';
comment on column CKTS_XXBD_YDXX.nsrdzdah
  is '纳税人电子档案号||便捷退税企业唯一标识';
comment on column CKTS_XXBD_YDXX.sbywb_dm
  is '申报年月';
comment on column CKTS_XXBD_YDXX.sssq
  is '申报年月';
comment on column CKTS_XXBD_YDXX.sbpc
  is '申报批次';
comment on column CKTS_XXBD_YDXX.sbid
  is '申报业务序号，同SB_SBXX_HZ的ID';
comment on column CKTS_XXBD_YDXX.err_ly
  is '错误来源（0：数据自检；1：信息比对；2：审核系统反馈）';
comment on column CKTS_XXBD_YDXX.xh
  is '流水号';
comment on column CKTS_XXBD_YDXX.err_obj
  is '疑点对象（单证名称）';
comment on column CKTS_XXBD_YDXX.glywb1
  is '关联业务表1';
comment on column CKTS_XXBD_YDXX.glywb2
  is '关联业务表2';
comment on column CKTS_XXBD_YDXX.glywb3
  is '关联业务表3';
comment on column CKTS_XXBD_YDXX.glywz1
  is '关联业务值1';
comment on column CKTS_XXBD_YDXX.glywz2
  is '关联业务值2';
comment on column CKTS_XXBD_YDXX.ydcode
  is '疑点代码';
comment on column CKTS_XXBD_YDXX.err_lev
  is '错误级别';
comment on column CKTS_XXBD_YDXX.err_msg
  is '出错信息';
comment on column CKTS_XXBD_YDXX.pass_flag
  is '可人工挑过标志';
comment on column CKTS_XXBD_YDXX.crtime
  is '创建时间';
create index IDX_CKTS_XXBD_YDXX_SBID on CKTS_XXBD_YDXX (SBID);
alter table CKTS_XXBD_YDXX
  add constraint PK_CKTS_XXBD_YDXX primary key (SBID, ERR_LY, XH);

prompt
prompt Creating table CKTS_ZM_BBCKTSZM_LSB
prompt ===================================
prompt
create table CKTS_ZM_BBCKTSZM_LSB
(
  sbid         NUMBER(18),
  qyhgdm       VARCHAR2(20),
  ssq          VARCHAR2(60),
  sbpc         VARCHAR2(75),
  djxh         NUMBER(20),
  sbxh         VARCHAR2(50),
  ycktszmlx_dm CHAR(2),
  ycktszmbh    VARCHAR2(20),
  yzmkjswjgmc  VARCHAR2(300),
  lrrq         DATE,
  lrr_dm       CHAR(11),
  xgrq         DATE,
  xgr_dm       CHAR(11),
  sjgsdq       CHAR(11),
  sjtb_sj      TIMESTAMP(6),
  sbbh_1       VARCHAR2(20),
  tbrq_1       DATE
)
;
comment on table CKTS_ZM_BBCKTSZM_LSB
  is '关于补办出口退税有关证明申请临时表';
comment on column CKTS_ZM_BBCKTSZM_LSB.djxh
  is '登记序号';
comment on column CKTS_ZM_BBCKTSZM_LSB.sbxh
  is '申报序号';
comment on column CKTS_ZM_BBCKTSZM_LSB.ycktszmlx_dm
  is '原出口退税证明类型代码';
comment on column CKTS_ZM_BBCKTSZM_LSB.ycktszmbh
  is '原出口退税证明编号';
comment on column CKTS_ZM_BBCKTSZM_LSB.yzmkjswjgmc
  is '原证明开具税务机关名称';
comment on column CKTS_ZM_BBCKTSZM_LSB.lrrq
  is '录入日期';
comment on column CKTS_ZM_BBCKTSZM_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_ZM_BBCKTSZM_LSB.xgrq
  is '修改日期';
comment on column CKTS_ZM_BBCKTSZM_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_ZM_BBCKTSZM_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_ZM_BBCKTSZM_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_ZM_BBCKTSZM_LSB.sbbh_1
  is '申报编号';
comment on column CKTS_ZM_BBCKTSZM_LSB.tbrq_1
  is '填表日期';
create index IDX_CKTS_ZM_BBCKTSZM_LSB_1 on CKTS_ZM_BBCKTSZM_LSB (SBID);
create index IDX_CKTS_ZM_BBCKTSZM_LSB_2 on CKTS_ZM_BBCKTSZM_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_ZM_CKHWZNX_LSB
prompt ==================================
prompt
create table CKTS_ZM_CKHWZNX_LSB
(
  sbid        NUMBER(18),
  qyhgdm      VARCHAR2(20),
  ssq         VARCHAR2(60),
  sbpc        VARCHAR2(75),
  djxh        NUMBER(20),
  sbxh        VARCHAR2(50),
  xh_4        VARCHAR2(10),
  yghpzh      VARCHAR2(30),
  ghkprq      DATE,
  cksp_dm     VARCHAR2(20),
  ckspmc      VARCHAR2(75),
  ghsl        NUMBER(17,5),
  ghje        NUMBER(18,2),
  ghzssl      NUMBER(16,6),
  ghzsse      NUMBER(18,6),
  hgjldwmc    VARCHAR2(75),
  xhpzh       VARCHAR2(30),
  nxkprq      DATE,
  nxsl        NUMBER(17,5),
  znxyy       VARCHAR2(4000),
  tbrq_1      DATE,
  bz          VARCHAR2(3000),
  tsswjg_dm_1 CHAR(11),
  lrrq        DATE,
  lrr_dm      CHAR(11),
  xgrq        DATE,
  xgr_dm      CHAR(11),
  sjgsdq      CHAR(11),
  sjtb_sj     TIMESTAMP(6),
  sbbh_1      VARCHAR2(20),
  kdkse       NUMBER(18,6),
  fpdm        VARCHAR2(12),
  fphm        VARCHAR2(8)
)
;
comment on table CKTS_ZM_CKHWZNX_LSB
  is '出口货物转内销证明临时表';
comment on column CKTS_ZM_CKHWZNX_LSB.ssq
  is '所属期';
comment on column CKTS_ZM_CKHWZNX_LSB.sbpc
  is '申报批次';
comment on column CKTS_ZM_CKHWZNX_LSB.djxh
  is '登记序号';
comment on column CKTS_ZM_CKHWZNX_LSB.sbxh
  is '申报序号';
comment on column CKTS_ZM_CKHWZNX_LSB.xh_4
  is '项号';
comment on column CKTS_ZM_CKHWZNX_LSB.yghpzh
  is '原购货凭证号';
comment on column CKTS_ZM_CKHWZNX_LSB.ghkprq
  is '购货开票日期';
comment on column CKTS_ZM_CKHWZNX_LSB.cksp_dm
  is '出口商品代码';
comment on column CKTS_ZM_CKHWZNX_LSB.ckspmc
  is '出口商品名称';
comment on column CKTS_ZM_CKHWZNX_LSB.ghsl
  is '购货数量';
comment on column CKTS_ZM_CKHWZNX_LSB.ghje
  is '购货金额';
comment on column CKTS_ZM_CKHWZNX_LSB.ghzssl
  is '购货征税税率';
comment on column CKTS_ZM_CKHWZNX_LSB.ghzsse
  is '购货征税税额';
comment on column CKTS_ZM_CKHWZNX_LSB.hgjldwmc
  is '海关计量单位名称';
comment on column CKTS_ZM_CKHWZNX_LSB.xhpzh
  is '销货凭证号';
comment on column CKTS_ZM_CKHWZNX_LSB.nxkprq
  is '内销开票日期';
comment on column CKTS_ZM_CKHWZNX_LSB.nxsl
  is '内销数量';
comment on column CKTS_ZM_CKHWZNX_LSB.znxyy
  is '转内销原因';
comment on column CKTS_ZM_CKHWZNX_LSB.tbrq_1
  is '填表日期';
comment on column CKTS_ZM_CKHWZNX_LSB.bz
  is '备注';
comment on column CKTS_ZM_CKHWZNX_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_ZM_CKHWZNX_LSB.lrrq
  is '录入日期';
comment on column CKTS_ZM_CKHWZNX_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_ZM_CKHWZNX_LSB.xgrq
  is '修改日期';
comment on column CKTS_ZM_CKHWZNX_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_ZM_CKHWZNX_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_ZM_CKHWZNX_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_ZM_CKHWZNX_LSB.sbbh_1
  is '申报编号';
comment on column CKTS_ZM_CKHWZNX_LSB.kdkse
  is '可抵扣税额';
comment on column CKTS_ZM_CKHWZNX_LSB.fpdm
  is '增值税发票代码（信息比对的时候通过JHPZH分解）';
comment on column CKTS_ZM_CKHWZNX_LSB.fphm
  is '增值税发票号码（信息比对的时候通过JHPZH分解）';
create index IDX_CKTS_ZM_CKHWZNX_LSB_1 on CKTS_ZM_CKHWZNX_LSB (SBID);
create index IDX_CKTS_ZM_CKHWZNX_LSB_2 on CKTS_ZM_CKHWZNX_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_ZM_CKJYMSHXSB_LSB
prompt =====================================
prompt
create table CKTS_ZM_CKJYMSHXSB_LSB
(
  sbid           NUMBER(18),
  qyhgdm         VARCHAR2(20),
  ssq            VARCHAR2(60),
  sbpc           VARCHAR2(75),
  djxh           NUMBER(20),
  sbxh           VARCHAR2(50),
  jhnd           VARCHAR2(10),
  jhbh           NUMBER(8),
  ckfph          VARCHAR2(30),
  ckhth          VARCHAR2(60),
  ckbgdh         VARCHAR2(21),
  ckrq_1         DATE,
  dlckhwzmhm     VARCHAR2(20),
  ckshhxdh       VARCHAR2(30),
  jysp_dm        VARCHAR2(20),
  jyph           VARCHAR2(75),
  jldwmc         VARCHAR2(75),
  cksl           NUMBER(17,5),
  ckhwmsxsemy    NUMBER(18,2),
  ckhwmsxsermb   NUMBER(18,2),
  zymsgjckjyzmbh VARCHAR2(20),
  ckjyymszmbh    VARCHAR2(20),
  bz             VARCHAR2(3000),
  lrr_dm         CHAR(11),
  lrrq           DATE,
  xgr_dm         CHAR(11),
  xgrq           DATE,
  tsswjg_dm_1    CHAR(11),
  sjgsdq         CHAR(11),
  sjtb_sj        TIMESTAMP(6),
  tbrq_1         DATE,
  jhbh_1         VARCHAR2(10)
)
;
comment on table CKTS_ZM_CKJYMSHXSB_LSB
  is '出口卷烟免税核销表(临时表)';
comment on column CKTS_ZM_CKJYMSHXSB_LSB.ssq
  is '所属期';
comment on column CKTS_ZM_CKJYMSHXSB_LSB.sbpc
  is '申报批次';
comment on column CKTS_ZM_CKJYMSHXSB_LSB.djxh
  is '登记序号';
comment on column CKTS_ZM_CKJYMSHXSB_LSB.sbxh
  is '申报序号';
comment on column CKTS_ZM_CKJYMSHXSB_LSB.jhnd
  is '计划年度';
comment on column CKTS_ZM_CKJYMSHXSB_LSB.jhbh
  is '计划编号';
comment on column CKTS_ZM_CKJYMSHXSB_LSB.ckfph
  is '出口发票号';
comment on column CKTS_ZM_CKJYMSHXSB_LSB.ckhth
  is '出口合同号';
comment on column CKTS_ZM_CKJYMSHXSB_LSB.ckbgdh
  is '出口报关单号';
comment on column CKTS_ZM_CKJYMSHXSB_LSB.ckrq_1
  is '出口日期';
comment on column CKTS_ZM_CKJYMSHXSB_LSB.dlckhwzmhm
  is '代理出口货物证明号码';
comment on column CKTS_ZM_CKJYMSHXSB_LSB.ckshhxdh
  is '出口收汇核销单号';
comment on column CKTS_ZM_CKJYMSHXSB_LSB.jysp_dm
  is '卷烟商品代码';
comment on column CKTS_ZM_CKJYMSHXSB_LSB.jyph
  is '卷烟牌号';
comment on column CKTS_ZM_CKJYMSHXSB_LSB.jldwmc
  is '计量单位名称';
comment on column CKTS_ZM_CKJYMSHXSB_LSB.cksl
  is '出口数量';
comment on column CKTS_ZM_CKJYMSHXSB_LSB.ckhwmsxsemy
  is '出口货物免税销售额（美元）';
comment on column CKTS_ZM_CKJYMSHXSB_LSB.ckhwmsxsermb
  is '出口货物免税销售额（人民币）';
comment on column CKTS_ZM_CKJYMSHXSB_LSB.zymsgjckjyzmbh
  is '准予免税购进出口卷烟证明编号';
comment on column CKTS_ZM_CKJYMSHXSB_LSB.ckjyymszmbh
  is '出口卷烟已免税证明编号';
comment on column CKTS_ZM_CKJYMSHXSB_LSB.bz
  is '备注';
comment on column CKTS_ZM_CKJYMSHXSB_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_ZM_CKJYMSHXSB_LSB.lrrq
  is '录入日期';
comment on column CKTS_ZM_CKJYMSHXSB_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_ZM_CKJYMSHXSB_LSB.xgrq
  is '修改日期';
comment on column CKTS_ZM_CKJYMSHXSB_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_ZM_CKJYMSHXSB_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_ZM_CKJYMSHXSB_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_ZM_CKJYMSHXSB_LSB.tbrq_1
  is '填表日期';
comment on column CKTS_ZM_CKJYMSHXSB_LSB.jhbh_1
  is '计划编号';
create index IDX_CKTS_ZM_CKJYMSHXSB_LSB_1 on CKTS_ZM_CKJYMSHXSB_LSB (SBID);
create index IDX_CKTS_ZM_CKJYMSHXSB_LSB_2 on CKTS_ZM_CKJYMSHXSB_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_ZM_CKJYYMSZM_LSB
prompt ====================================
prompt
create table CKTS_ZM_CKJYYMSZM_LSB
(
  sbid           NUMBER(18),
  qyhgdm         VARCHAR2(20),
  ssq            VARCHAR2(60),
  sbpc           VARCHAR2(75),
  djxh           NUMBER(20),
  sbxh           VARCHAR2(50),
  jyckqyshxydm   VARCHAR2(20),
  jyckqynsrsbh   VARCHAR2(20),
  jyckqymc       VARCHAR2(300),
  xh_4           VARCHAR2(10),
  jysp_dm        VARCHAR2(20),
  jymc_1         VARCHAR2(75),
  jyph           VARCHAR2(75),
  jldwmc         VARCHAR2(75),
  sl             NUMBER(17,5),
  dj             NUMBER(18,2),
  zjje_2         NUMBER(18,2),
  zzs_se_dw      NUMBER(18,2),
  zzs_se         NUMBER(18,2),
  xfs_se_dw      NUMBER(18,2),
  xfs_se         NUMBER(18,2),
  zymsgjckjyzmbh VARCHAR2(20),
  fphm           VARCHAR2(30),
  lrr_dm         CHAR(11),
  lrrq           DATE,
  xgr_dm         CHAR(11),
  xgrq           DATE,
  tsswjg_dm_1    CHAR(11),
  sjgsdq         CHAR(11),
  sjtb_sj        TIMESTAMP(6),
  cwfzrxm        VARCHAR2(150),
  fddbrxm        VARCHAR2(150),
  jbrxm          VARCHAR2(75),
  sbbh_1         VARCHAR2(20),
  tbrq_1         DATE
)
;
comment on table CKTS_ZM_CKJYYMSZM_LSB
  is '出口卷烟已免税证明申请表(临时表)';
comment on column CKTS_ZM_CKJYYMSZM_LSB.ssq
  is '所属期';
comment on column CKTS_ZM_CKJYYMSZM_LSB.sbpc
  is '申报批次';
comment on column CKTS_ZM_CKJYYMSZM_LSB.djxh
  is '登记序号';
comment on column CKTS_ZM_CKJYYMSZM_LSB.sbxh
  is '申报序号';
comment on column CKTS_ZM_CKJYYMSZM_LSB.jyckqyshxydm
  is '卷烟出口企业社会信用代码';
comment on column CKTS_ZM_CKJYYMSZM_LSB.jyckqynsrsbh
  is '卷烟出口企业纳税人识别号';
comment on column CKTS_ZM_CKJYYMSZM_LSB.jyckqymc
  is '卷烟出口企业名称';
comment on column CKTS_ZM_CKJYYMSZM_LSB.xh_4
  is '项号';
comment on column CKTS_ZM_CKJYYMSZM_LSB.jysp_dm
  is '卷烟商品代码';
comment on column CKTS_ZM_CKJYYMSZM_LSB.jymc_1
  is '卷烟名称';
comment on column CKTS_ZM_CKJYYMSZM_LSB.jyph
  is '卷烟牌号';
comment on column CKTS_ZM_CKJYYMSZM_LSB.jldwmc
  is '计量单位名称';
comment on column CKTS_ZM_CKJYYMSZM_LSB.sl
  is '数量';
comment on column CKTS_ZM_CKJYYMSZM_LSB.dj
  is '单价';
comment on column CKTS_ZM_CKJYYMSZM_LSB.zjje_2
  is '总计金额';
comment on column CKTS_ZM_CKJYYMSZM_LSB.zzs_se_dw
  is '免征增值税金额（单位税额）||应用于进出口退税';
comment on column CKTS_ZM_CKJYYMSZM_LSB.zzs_se
  is '免征增值税金额（总计）||应用于进出口退税';
comment on column CKTS_ZM_CKJYYMSZM_LSB.xfs_se_dw
  is '免征消费税金额（单位税额）||应用于进出口退税';
comment on column CKTS_ZM_CKJYYMSZM_LSB.xfs_se
  is '免征消费税金额（总计）||应用于进出口退税';
comment on column CKTS_ZM_CKJYYMSZM_LSB.zymsgjckjyzmbh
  is '准予免税购进出口卷烟证明编号';
comment on column CKTS_ZM_CKJYYMSZM_LSB.fphm
  is '发票号码';
comment on column CKTS_ZM_CKJYYMSZM_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_ZM_CKJYYMSZM_LSB.lrrq
  is '录入日期';
comment on column CKTS_ZM_CKJYYMSZM_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_ZM_CKJYYMSZM_LSB.xgrq
  is '修改日期';
comment on column CKTS_ZM_CKJYYMSZM_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_ZM_CKJYYMSZM_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_ZM_CKJYYMSZM_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_ZM_CKJYYMSZM_LSB.cwfzrxm
  is '财务负责人姓名';
comment on column CKTS_ZM_CKJYYMSZM_LSB.fddbrxm
  is '法定代表人姓名';
comment on column CKTS_ZM_CKJYYMSZM_LSB.jbrxm
  is '经办人姓名';
comment on column CKTS_ZM_CKJYYMSZM_LSB.sbbh_1
  is '申报编号';
comment on column CKTS_ZM_CKJYYMSZM_LSB.tbrq_1
  is '填表日期';
create index IDX_CKTS_ZM_CKJYYMSZM_LSB_1 on CKTS_ZM_CKJYYMSZM_LSB (SBID);
create index IDX_CKTS_ZM_CKJYYMSZM_LSB_2 on CKTS_ZM_CKJYYMSZM_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_ZM_CKZMZFQD_LSB
prompt ===================================
prompt
create table CKTS_ZM_CKZMZFQD_LSB
(
  sbid        NUMBER(18),
  qyhgdm      VARCHAR2(20),
  ssq         VARCHAR2(60),
  sbpc        VARCHAR2(75),
  djxh        NUMBER(20),
  cktszmbh    VARCHAR2(20),
  cktszmlx_dm CHAR(2),
  bz          VARCHAR2(3000),
  tbrq_1      DATE,
  yzmkjswjgmc VARCHAR2(300),
  tsswjg_dm_1 CHAR(11),
  lrr_dm      CHAR(11),
  lrrq        DATE,
  xgr_dm      CHAR(11),
  xgrq        DATE,
  sjgsdq      CHAR(11),
  sjtb_sj     TIMESTAMP(6),
  sbxh        VARCHAR2(50)
)
;
comment on table CKTS_ZM_CKZMZFQD_LSB
  is '出口证明作废清单临时表';
comment on column CKTS_ZM_CKZMZFQD_LSB.djxh
  is '登记序号';
comment on column CKTS_ZM_CKZMZFQD_LSB.cktszmbh
  is '出口退税证明编号';
comment on column CKTS_ZM_CKZMZFQD_LSB.cktszmlx_dm
  is '出口退税证明类型代码';
comment on column CKTS_ZM_CKZMZFQD_LSB.bz
  is '备注';
comment on column CKTS_ZM_CKZMZFQD_LSB.tbrq_1
  is '填表日期';
comment on column CKTS_ZM_CKZMZFQD_LSB.yzmkjswjgmc
  is '原证明开具税务机关名称';
comment on column CKTS_ZM_CKZMZFQD_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_ZM_CKZMZFQD_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_ZM_CKZMZFQD_LSB.lrrq
  is '录入日期';
comment on column CKTS_ZM_CKZMZFQD_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_ZM_CKZMZFQD_LSB.xgrq
  is '修改日期';
comment on column CKTS_ZM_CKZMZFQD_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_ZM_CKZMZFQD_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_ZM_CKZMZFQD_LSB.sbxh
  is '申报序号';
create index IDX_CKTS_ZM_CKZMZFQD_LSB_1 on CKTS_ZM_CKZMZFQD_LSB (SBID);
create index IDX_CKTS_ZM_CKZMZFQD_LSB_2 on CKTS_ZM_CKZMZFQD_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_ZM_DLCK_LSB
prompt ===============================
prompt
create table CKTS_ZM_DLCK_LSB
(
  sbid         NUMBER(18),
  qyhgdm       VARCHAR2(20),
  ssq          VARCHAR2(60),
  sbpc         VARCHAR2(75),
  djxh         NUMBER(20),
  sbxh         VARCHAR2(50),
  wtfshxydm    VARCHAR2(20),
  wtfnsrsbh    VARCHAR2(20),
  wtfnsrmc     VARCHAR2(300),
  ckbgdh       VARCHAR2(21),
  ckrq_1       DATE,
  ckshhxdh     VARCHAR2(30),
  myfs_dm      CHAR(4),
  cksp_dm      VARCHAR2(20),
  hgjldwmc     VARCHAR2(75),
  cksl         NUMBER(17,5),
  hbzm_dm      CHAR(3),
  cjzj         NUMBER(18,2),
  mylaj        NUMBER(18,2),
  wtdlckhth    VARCHAR2(60),
  hxddzbqbz    CHAR(1),
  bz           VARCHAR2(3000),
  qyjbrxm      VARCHAR2(150),
  jbrsfzjlx_dm CHAR(3),
  jbrsfzjhm    VARCHAR2(30),
  xh_4         VARCHAR2(10),
  lrr_dm       CHAR(11),
  lrrq         DATE,
  xgr_dm       CHAR(11),
  xgrq         DATE,
  sjgsdq       CHAR(11),
  sjtb_sj      TIMESTAMP(6),
  sbbh_1       VARCHAR2(20),
  tbrq_1       DATE,
  wtckhwzmbh   VARCHAR2(20),
  rmblaj       NUMBER(18,2),
  ckspmc       VARCHAR2(300)
)
;
comment on table CKTS_ZM_DLCK_LSB
  is '代理出口货物证明临时表';
comment on column CKTS_ZM_DLCK_LSB.ssq
  is '所属期';
comment on column CKTS_ZM_DLCK_LSB.sbpc
  is '申报批次';
comment on column CKTS_ZM_DLCK_LSB.djxh
  is '登记序号';
comment on column CKTS_ZM_DLCK_LSB.sbxh
  is '申报序号';
comment on column CKTS_ZM_DLCK_LSB.wtfshxydm
  is '委托方社会信用代码';
comment on column CKTS_ZM_DLCK_LSB.wtfnsrsbh
  is '委托方纳税人识别号';
comment on column CKTS_ZM_DLCK_LSB.wtfnsrmc
  is '委托方纳税人名称';
comment on column CKTS_ZM_DLCK_LSB.ckbgdh
  is '出口报关单号';
comment on column CKTS_ZM_DLCK_LSB.ckrq_1
  is '出口日期';
comment on column CKTS_ZM_DLCK_LSB.ckshhxdh
  is '出口收汇核销单号';
comment on column CKTS_ZM_DLCK_LSB.myfs_dm
  is '贸易方式代码';
comment on column CKTS_ZM_DLCK_LSB.cksp_dm
  is '出口商品代码';
comment on column CKTS_ZM_DLCK_LSB.hgjldwmc
  is '海关计量单位名称';
comment on column CKTS_ZM_DLCK_LSB.cksl
  is '出口数量';
comment on column CKTS_ZM_DLCK_LSB.hbzm_dm
  is '货币字母代码';
comment on column CKTS_ZM_DLCK_LSB.cjzj
  is '成交总价||成交总价';
comment on column CKTS_ZM_DLCK_LSB.mylaj
  is '美元离岸价';
comment on column CKTS_ZM_DLCK_LSB.wtdlckhth
  is '委托（代理）出口合同号';
comment on column CKTS_ZM_DLCK_LSB.hxddzbqbz
  is '核销单单证不齐标志';
comment on column CKTS_ZM_DLCK_LSB.bz
  is '备注';
comment on column CKTS_ZM_DLCK_LSB.qyjbrxm
  is '企业经办人姓名';
comment on column CKTS_ZM_DLCK_LSB.jbrsfzjlx_dm
  is '经办人身份证件类型';
comment on column CKTS_ZM_DLCK_LSB.jbrsfzjhm
  is '经办人身份证件号码';
comment on column CKTS_ZM_DLCK_LSB.xh_4
  is '项号';
comment on column CKTS_ZM_DLCK_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_ZM_DLCK_LSB.lrrq
  is '录入日期';
comment on column CKTS_ZM_DLCK_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_ZM_DLCK_LSB.xgrq
  is '修改日期';
comment on column CKTS_ZM_DLCK_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_ZM_DLCK_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_ZM_DLCK_LSB.sbbh_1
  is '申报编号';
comment on column CKTS_ZM_DLCK_LSB.tbrq_1
  is '填表日期';
comment on column CKTS_ZM_DLCK_LSB.wtckhwzmbh
  is '委托出口货物证明编号';
comment on column CKTS_ZM_DLCK_LSB.rmblaj
  is '人民币离岸价';
comment on column CKTS_ZM_DLCK_LSB.ckspmc
  is '出口商品名称';
create index IDX_CKTS_ZM_DLCK_LSB_1 on CKTS_ZM_DLCK_LSB (SBID);
create index IDX_CKTS_ZM_DLCK_LSB_2 on CKTS_ZM_DLCK_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_ZM_DLJK_LSB
prompt ===============================
prompt
create table CKTS_ZM_DLJK_LSB
(
  sbid             NUMBER(18),
  qyhgdm           VARCHAR2(20),
  ssq              VARCHAR2(60),
  sbpc             VARCHAR2(75),
  djxh             NUMBER(20),
  xh_4             VARCHAR2(10),
  sbxh             VARCHAR2(50),
  wtfnsrsbh        VARCHAR2(20),
  wtfnsrmc         VARCHAR2(300),
  jkbgdh           VARCHAR2(21),
  msjkljhgszgshxfs NUMBER(18,6),
  wtdljkhth        VARCHAR2(60),
  bz               VARCHAR2(3000),
  jljgszch         VARCHAR2(20),
  jgqynsrmc        VARCHAR2(300),
  sbbh_1           VARCHAR2(20),
  jbrxm            VARCHAR2(75),
  lrr_dm           CHAR(11),
  lrrq             DATE,
  xgr_dm           CHAR(11),
  xgrq             DATE,
  sjgsdq           CHAR(11),
  sjtb_sj          TIMESTAMP(6),
  tbrq_1           DATE,
  tsswjg_dm_1      CHAR(11)
)
;
comment on table CKTS_ZM_DLJK_LSB
  is '代理进口货物证明临时表';
comment on column CKTS_ZM_DLJK_LSB.ssq
  is '所属期';
comment on column CKTS_ZM_DLJK_LSB.sbpc
  is '申报批次';
comment on column CKTS_ZM_DLJK_LSB.djxh
  is '登记序号';
comment on column CKTS_ZM_DLJK_LSB.xh_4
  is '项号';
comment on column CKTS_ZM_DLJK_LSB.sbxh
  is '申报序号';
comment on column CKTS_ZM_DLJK_LSB.wtfnsrsbh
  is '委托方纳税人识别号';
comment on column CKTS_ZM_DLJK_LSB.wtfnsrmc
  is '委托方纳税人名称';
comment on column CKTS_ZM_DLJK_LSB.jkbgdh
  is '进口报关单号';
comment on column CKTS_ZM_DLJK_LSB.msjkljhgszgshxfs
  is '免税进口料件海关实征关税和消费税';
comment on column CKTS_ZM_DLJK_LSB.wtdljkhth
  is '委托（代理）进口合同号';
comment on column CKTS_ZM_DLJK_LSB.bz
  is '备注';
comment on column CKTS_ZM_DLJK_LSB.jljgszch
  is '进料加工手（账）册号';
comment on column CKTS_ZM_DLJK_LSB.jgqynsrmc
  is '加工企业纳税人名称';
comment on column CKTS_ZM_DLJK_LSB.sbbh_1
  is '申报编号';
comment on column CKTS_ZM_DLJK_LSB.jbrxm
  is '经办人姓名';
comment on column CKTS_ZM_DLJK_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_ZM_DLJK_LSB.lrrq
  is '录入日期';
comment on column CKTS_ZM_DLJK_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_ZM_DLJK_LSB.xgrq
  is '修改日期';
comment on column CKTS_ZM_DLJK_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_ZM_DLJK_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_ZM_DLJK_LSB.tbrq_1
  is '填表日期';
comment on column CKTS_ZM_DLJK_LSB.tsswjg_dm_1
  is '退税税务机关代码';
create index IDX_CKTS_ZM_DLJK_LSB_1 on CKTS_ZM_DLJK_LSB (SBID);
create index IDX_CKTS_ZM_DLJK_LSB_2 on CKTS_ZM_DLJK_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_ZM_LLJGHX_LSB
prompt =================================
prompt
create table CKTS_ZM_LLJGHX_LSB
(
  sbid        NUMBER(18),
  qyhgdm      VARCHAR2(20),
  ssq         VARCHAR2(60),
  sbpc        VARCHAR2(75),
  djxh        NUMBER(20),
  xh_4        VARCHAR2(10),
  tsswjg_dm_1 CHAR(11),
  sbxh        VARCHAR2(50),
  lljgszch    VARCHAR2(20),
  lljgmszmbh  VARCHAR2(20),
  jgqyshxydm  VARCHAR2(20),
  jgqynsrsbh  VARCHAR2(20),
  jgqynsrmc   VARCHAR2(300),
  jgffphm     VARCHAR2(30),
  jgfje       NUMBER(18,2),
  jldwmc      VARCHAR2(75),
  sl          NUMBER(17,5),
  ckfph       VARCHAR2(30),
  ckbgdh      VARCHAR2(21),
  cksp_dm     VARCHAR2(20),
  ckspmc      VARCHAR2(75),
  hgjldwmc    VARCHAR2(75),
  cksl        NUMBER(17,5),
  jbrxm       VARCHAR2(75),
  bz          VARCHAR2(3000),
  tbrq_1      DATE,
  lrr_dm      CHAR(11),
  lrrq        DATE,
  xgr_dm      CHAR(11),
  xgrq        DATE,
  sjgsdq      CHAR(11),
  sjtb_sj     TIMESTAMP(6),
  sbbh_1      VARCHAR2(20)
)
;
comment on table CKTS_ZM_LLJGHX_LSB
  is '来料加工免税证明核销临时表';
comment on column CKTS_ZM_LLJGHX_LSB.ssq
  is '所属期';
comment on column CKTS_ZM_LLJGHX_LSB.sbpc
  is '申报批次';
comment on column CKTS_ZM_LLJGHX_LSB.djxh
  is '登记序号';
comment on column CKTS_ZM_LLJGHX_LSB.xh_4
  is '项号';
comment on column CKTS_ZM_LLJGHX_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_ZM_LLJGHX_LSB.sbxh
  is '申报序号';
comment on column CKTS_ZM_LLJGHX_LSB.lljgszch
  is '来料加工手（账）册号';
comment on column CKTS_ZM_LLJGHX_LSB.lljgmszmbh
  is '来料加工免税证明编号';
comment on column CKTS_ZM_LLJGHX_LSB.jgqyshxydm
  is '加工企业社会信用代码';
comment on column CKTS_ZM_LLJGHX_LSB.jgqynsrsbh
  is '加工企业纳税人识别号';
comment on column CKTS_ZM_LLJGHX_LSB.jgqynsrmc
  is '加工企业纳税人名称';
comment on column CKTS_ZM_LLJGHX_LSB.jgffphm
  is '加工费发票号码';
comment on column CKTS_ZM_LLJGHX_LSB.jgfje
  is '加工费金额';
comment on column CKTS_ZM_LLJGHX_LSB.jldwmc
  is '计量单位名称';
comment on column CKTS_ZM_LLJGHX_LSB.sl
  is '数量';
comment on column CKTS_ZM_LLJGHX_LSB.ckfph
  is '出口发票号';
comment on column CKTS_ZM_LLJGHX_LSB.ckbgdh
  is '出口报关单号';
comment on column CKTS_ZM_LLJGHX_LSB.cksp_dm
  is '出口商品代码';
comment on column CKTS_ZM_LLJGHX_LSB.ckspmc
  is '出口商品名称';
comment on column CKTS_ZM_LLJGHX_LSB.hgjldwmc
  is '海关计量单位名称';
comment on column CKTS_ZM_LLJGHX_LSB.cksl
  is '出口数量';
comment on column CKTS_ZM_LLJGHX_LSB.jbrxm
  is '经办人姓名';
comment on column CKTS_ZM_LLJGHX_LSB.bz
  is '备注';
comment on column CKTS_ZM_LLJGHX_LSB.tbrq_1
  is '填表日期';
comment on column CKTS_ZM_LLJGHX_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_ZM_LLJGHX_LSB.lrrq
  is '录入日期';
comment on column CKTS_ZM_LLJGHX_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_ZM_LLJGHX_LSB.xgrq
  is '修改日期';
comment on column CKTS_ZM_LLJGHX_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_ZM_LLJGHX_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_ZM_LLJGHX_LSB.sbbh_1
  is '申报编号';
create index IDX_CKTS_ZM_LLJGHX_LSB_1 on CKTS_ZM_LLJGHX_LSB (SBID);
create index IDX_CKTS_ZM_LLJGHX_LSB_2 on CKTS_ZM_LLJGHX_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_ZM_LLJG_LSB
prompt ===============================
prompt
create table CKTS_ZM_LLJG_LSB
(
  sbid        NUMBER(18),
  qyhgdm      VARCHAR2(20),
  ssq         VARCHAR2(60),
  sbpc        VARCHAR2(75),
  djxh        NUMBER(20),
  sbxh        VARCHAR2(50),
  stfnsrsbh   VARCHAR2(20),
  stfmc       VARCHAR2(300),
  lljgszch    VARCHAR2(20),
  jgffphm     VARCHAR2(30),
  ykfphwmc    VARCHAR2(150),
  ykfphwdw    VARCHAR2(75),
  ykfphwsl    NUMBER(17,5),
  jgfje       NUMBER(18,2),
  bz          VARCHAR2(3000),
  jbrxm       VARCHAR2(75),
  tsswjg_dm_1 CHAR(11),
  xh_4        VARCHAR2(10),
  lrr_dm      CHAR(11),
  lrrq        DATE,
  xgr_dm      CHAR(11),
  xgrq        DATE,
  sjgsdq      CHAR(11),
  sjtb_sj     TIMESTAMP(6),
  sbbh_1      VARCHAR2(20),
  tbrq_1      DATE
)
;
comment on table CKTS_ZM_LLJG_LSB
  is '来料加工免税证明临时表';
comment on column CKTS_ZM_LLJG_LSB.ssq
  is '所属期';
comment on column CKTS_ZM_LLJG_LSB.sbpc
  is '申报批次';
comment on column CKTS_ZM_LLJG_LSB.djxh
  is '登记序号';
comment on column CKTS_ZM_LLJG_LSB.sbxh
  is '申报序号';
comment on column CKTS_ZM_LLJG_LSB.stfnsrsbh
  is '受托方纳税人识别号';
comment on column CKTS_ZM_LLJG_LSB.stfmc
  is '受托方名称';
comment on column CKTS_ZM_LLJG_LSB.lljgszch
  is '来料加工手（账）册号';
comment on column CKTS_ZM_LLJG_LSB.jgffphm
  is '加工费发票号码';
comment on column CKTS_ZM_LLJG_LSB.ykfphwmc
  is '已开发票货物名称';
comment on column CKTS_ZM_LLJG_LSB.ykfphwdw
  is '已开发票货物单位';
comment on column CKTS_ZM_LLJG_LSB.ykfphwsl
  is '已开发票货物数量';
comment on column CKTS_ZM_LLJG_LSB.jgfje
  is '加工费金额';
comment on column CKTS_ZM_LLJG_LSB.bz
  is '备注';
comment on column CKTS_ZM_LLJG_LSB.jbrxm
  is '经办人姓名';
comment on column CKTS_ZM_LLJG_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_ZM_LLJG_LSB.xh_4
  is '项号';
comment on column CKTS_ZM_LLJG_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_ZM_LLJG_LSB.lrrq
  is '录入日期';
comment on column CKTS_ZM_LLJG_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_ZM_LLJG_LSB.xgrq
  is '修改日期';
comment on column CKTS_ZM_LLJG_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_ZM_LLJG_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_ZM_LLJG_LSB.sbbh_1
  is '申报编号';
comment on column CKTS_ZM_LLJG_LSB.tbrq_1
  is '填表日期';
create index IDX_CKTS_ZM_LLJG_LSB_1 on CKTS_ZM_LLJG_LSB (SBID);
create index IDX_CKTS_ZM_LLJG_LSB_2 on CKTS_ZM_LLJG_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_ZM_TYYBSWTS_LSB
prompt ===================================
prompt
create table CKTS_ZM_TYYBSWTS_LSB
(
  sbid            NUMBER(18),
  qyhgdm          VARCHAR2(20),
  ssq             VARCHAR2(60),
  sbpc            VARCHAR2(75),
  djxh            NUMBER(20),
  wtfcktszmbh     VARCHAR2(20),
  dlckhwzmhm      VARCHAR2(20),
  sbxh            VARCHAR2(50),
  ckbgdh          VARCHAR2(21),
  ckrq_1          DATE,
  ckshhxdh        VARCHAR2(30),
  ckfph           VARCHAR2(30),
  cksp_dm         VARCHAR2(20),
  ckspmc          VARCHAR2(75),
  hgjldwmc        VARCHAR2(75),
  cksl            NUMBER(17,5),
  hggqka_dm       CHAR(4),
  yjsje           NUMBER(18,2),
  ysbmdtse        NUMBER(18,6),
  ytzzse_1        NUMBER(18,6),
  ytxfse_1        NUMBER(18,6),
  jhpzh           VARCHAR2(75),
  tysl            NUMBER(17,5),
  tyjsje          NUMBER(18,2),
  ytsl_1          NUMBER(16,6),
  ycjmdtse        NUMBER(18,2),
  cjssq           VARCHAR2(60),
  ybzzse_1        NUMBER(18,6),
  ybxfse_1        NUMBER(18,6),
  jkshm           VARCHAR2(20),
  rkrq            DATE,
  tyybswtstylx_dm CHAR(1),
  ysybs           CHAR(1),
  bz              VARCHAR2(3000),
  tsswjg_dm_1     CHAR(11),
  lrrq            DATE,
  lrr_dm          CHAR(11),
  xgrq            DATE,
  xgr_dm          CHAR(11),
  sjgsdq          CHAR(11),
  sjtb_sj         TIMESTAMP(6),
  sbbh_1          VARCHAR2(20),
  xh_4            VARCHAR2(10),
  sbny            CHAR(6),
  ckemy           NUMBER(18,2),
  hsjg            VARCHAR2(20),
  sz              CHAR(1),
  tmsztbz         VARCHAR2(50),
  ybjtmsk         NUMBER(18,6),
  ywclfs          VARCHAR2(20),
  fpdm            VARCHAR2(12),
  fphm            VARCHAR2(8)
)
;
comment on table CKTS_ZM_TYYBSWTS_LSB
  is '出口货物退运已补税(未退税)证明临时表';
comment on column CKTS_ZM_TYYBSWTS_LSB.ssq
  is '所属期';
comment on column CKTS_ZM_TYYBSWTS_LSB.sbpc
  is '申报批次';
comment on column CKTS_ZM_TYYBSWTS_LSB.djxh
  is '登记序号';
comment on column CKTS_ZM_TYYBSWTS_LSB.wtfcktszmbh
  is '委托方出口退税证明编号';
comment on column CKTS_ZM_TYYBSWTS_LSB.dlckhwzmhm
  is '代理出口货物证明号码';
comment on column CKTS_ZM_TYYBSWTS_LSB.sbxh
  is '申报序号';
comment on column CKTS_ZM_TYYBSWTS_LSB.ckbgdh
  is '出口报关单号';
comment on column CKTS_ZM_TYYBSWTS_LSB.ckrq_1
  is '出口日期';
comment on column CKTS_ZM_TYYBSWTS_LSB.ckshhxdh
  is '出口收汇核销单号';
comment on column CKTS_ZM_TYYBSWTS_LSB.ckfph
  is '出口发票号';
comment on column CKTS_ZM_TYYBSWTS_LSB.cksp_dm
  is '出口商品代码';
comment on column CKTS_ZM_TYYBSWTS_LSB.ckspmc
  is '出口商品名称';
comment on column CKTS_ZM_TYYBSWTS_LSB.hgjldwmc
  is '海关计量单位名称';
comment on column CKTS_ZM_TYYBSWTS_LSB.cksl
  is '出口数量';
comment on column CKTS_ZM_TYYBSWTS_LSB.hggqka_dm
  is '海关关区（口岸）代码';
comment on column CKTS_ZM_TYYBSWTS_LSB.yjsje
  is '原计税金额';
comment on column CKTS_ZM_TYYBSWTS_LSB.ysbmdtse
  is '原申报免抵退税额';
comment on column CKTS_ZM_TYYBSWTS_LSB.ytzzse_1
  is '原退增值税额';
comment on column CKTS_ZM_TYYBSWTS_LSB.ytxfse_1
  is '原退消费税额';
comment on column CKTS_ZM_TYYBSWTS_LSB.jhpzh
  is '进货凭证号';
comment on column CKTS_ZM_TYYBSWTS_LSB.tysl
  is '退运数量';
comment on column CKTS_ZM_TYYBSWTS_LSB.tyjsje
  is '退运计税金额';
comment on column CKTS_ZM_TYYBSWTS_LSB.ytsl_1
  is '原退税率';
comment on column CKTS_ZM_TYYBSWTS_LSB.ycjmdtse
  is '已冲减免抵退税额||应用于进出口退税';
comment on column CKTS_ZM_TYYBSWTS_LSB.cjssq
  is '冲减所属期';
comment on column CKTS_ZM_TYYBSWTS_LSB.ybzzse_1
  is '已补增值税额';
comment on column CKTS_ZM_TYYBSWTS_LSB.ybxfse_1
  is '已补消费税额';
comment on column CKTS_ZM_TYYBSWTS_LSB.jkshm
  is '缴款书号码';
comment on column CKTS_ZM_TYYBSWTS_LSB.rkrq
  is '入库日期';
comment on column CKTS_ZM_TYYBSWTS_LSB.tyybswtstylx_dm
  is '退运已补税（未退税）退运类型代码';
comment on column CKTS_ZM_TYYBSWTS_LSB.ysybs
  is '已使用标识';
comment on column CKTS_ZM_TYYBSWTS_LSB.bz
  is '备注';
comment on column CKTS_ZM_TYYBSWTS_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_ZM_TYYBSWTS_LSB.lrrq
  is '录入日期';
comment on column CKTS_ZM_TYYBSWTS_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_ZM_TYYBSWTS_LSB.xgrq
  is '修改日期';
comment on column CKTS_ZM_TYYBSWTS_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_ZM_TYYBSWTS_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_ZM_TYYBSWTS_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_ZM_TYYBSWTS_LSB.sbbh_1
  is '申报编号';
comment on column CKTS_ZM_TYYBSWTS_LSB.xh_4
  is '项号';
comment on column CKTS_ZM_TYYBSWTS_LSB.sbny
  is '申报年月';
comment on column CKTS_ZM_TYYBSWTS_LSB.ckemy
  is '出口额（美元）';
comment on column CKTS_ZM_TYYBSWTS_LSB.hsjg
  is '核实结果';
comment on column CKTS_ZM_TYYBSWTS_LSB.sz
  is '税种';
comment on column CKTS_ZM_TYYBSWTS_LSB.tmsztbz
  is '退（免）税状态标志';
comment on column CKTS_ZM_TYYBSWTS_LSB.ybjtmsk
  is '应补缴退（免）税款';
comment on column CKTS_ZM_TYYBSWTS_LSB.ywclfs
  is '业务处理方式';
comment on column CKTS_ZM_TYYBSWTS_LSB.fpdm
  is '增值税发票代码（信息比对的时候通过JHPZH分解）';
comment on column CKTS_ZM_TYYBSWTS_LSB.fphm
  is '增值税发票号码（信息比对的时候通过JHPZH分解）';
create index IDX_CKTS_ZM_TYYBSWTS_LSB_1 on CKTS_ZM_TYYBSWTS_LSB (SBID);
create index IDX_CKTS_ZM_TYYBSWTS_LSB_2 on CKTS_ZM_TYYBSWTS_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_ZM_WTCK_LSB
prompt ===============================
prompt
create table CKTS_ZM_WTCK_LSB
(
  sbid      NUMBER(18),
  qyhgdm    VARCHAR2(20),
  ssq       VARCHAR2(60),
  sbpc      VARCHAR2(75),
  djxh      NUMBER(20),
  sbbh_1    VARCHAR2(20),
  xh_4      VARCHAR2(10),
  sbxh      VARCHAR2(50),
  stfshxydm VARCHAR2(20),
  stfnsrsbh VARCHAR2(20),
  stfmc     VARCHAR2(300),
  dlckxyh   VARCHAR2(30),
  wtdlckhth VARCHAR2(60),
  ckbgdh    VARCHAR2(21),
  cksp_dm   VARCHAR2(20),
  ckspmc    VARCHAR2(75),
  hbzm_dm   CHAR(3),
  bz        VARCHAR2(3000),
  qyjbrxm   VARCHAR2(150),
  lrr_dm    CHAR(11),
  lrrq      DATE,
  xgr_dm    CHAR(11),
  xgrq      DATE,
  sjgsdq    CHAR(11),
  sjtb_sj   TIMESTAMP(6),
  tbrq_1    DATE,
  rmblaj    NUMBER(18,2)
)
;
comment on table CKTS_ZM_WTCK_LSB
  is '委托出口货物证明临时表';
comment on column CKTS_ZM_WTCK_LSB.ssq
  is '所属期';
comment on column CKTS_ZM_WTCK_LSB.sbpc
  is '申报批次';
comment on column CKTS_ZM_WTCK_LSB.djxh
  is '登记序号';
comment on column CKTS_ZM_WTCK_LSB.sbbh_1
  is '申报编号';
comment on column CKTS_ZM_WTCK_LSB.xh_4
  is '项号';
comment on column CKTS_ZM_WTCK_LSB.sbxh
  is '申报序号';
comment on column CKTS_ZM_WTCK_LSB.stfshxydm
  is '受托方社会信用代码';
comment on column CKTS_ZM_WTCK_LSB.stfnsrsbh
  is '受托方纳税人识别号';
comment on column CKTS_ZM_WTCK_LSB.stfmc
  is '受托方名称';
comment on column CKTS_ZM_WTCK_LSB.dlckxyh
  is '代理出口协议号';
comment on column CKTS_ZM_WTCK_LSB.wtdlckhth
  is '委托（代理）出口合同号';
comment on column CKTS_ZM_WTCK_LSB.ckbgdh
  is '出口报关单号';
comment on column CKTS_ZM_WTCK_LSB.cksp_dm
  is '出口商品代码';
comment on column CKTS_ZM_WTCK_LSB.ckspmc
  is '出口商品名称';
comment on column CKTS_ZM_WTCK_LSB.hbzm_dm
  is '货币字母代码';
comment on column CKTS_ZM_WTCK_LSB.bz
  is '备注';
comment on column CKTS_ZM_WTCK_LSB.qyjbrxm
  is '企业经办人姓名';
comment on column CKTS_ZM_WTCK_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_ZM_WTCK_LSB.lrrq
  is '录入日期';
comment on column CKTS_ZM_WTCK_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_ZM_WTCK_LSB.xgrq
  is '修改日期';
comment on column CKTS_ZM_WTCK_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_ZM_WTCK_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_ZM_WTCK_LSB.tbrq_1
  is '填表日期';
comment on column CKTS_ZM_WTCK_LSB.rmblaj
  is '人民币离岸价';
create index IDX_CKTS_ZM_WTCK_LSB_1 on CKTS_ZM_WTCK_LSB (SBID);
create index IDX_CKTS_ZM_WTCK_LSB_2 on CKTS_ZM_WTCK_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_ZM_ZBZM_LSB
prompt ===============================
prompt
create table CKTS_ZM_ZBZM_LSB
(
  sbid              NUMBER(18),
  qyhgdm            VARCHAR2(20),
  ssq               VARCHAR2(60),
  sbpc              VARCHAR2(75),
  djxh              NUMBER(20),
  zbjgszdswjgmc     VARCHAR2(300),
  zbqynsrsbh        VARCHAR2(20),
  zbqymc            VARCHAR2(300),
  zbwjbh            VARCHAR2(50),
  zbxmmc            VARCHAR2(600),
  dkgbjgmc          VARCHAR2(300),
  mgjckyhzqdbdkxmqd VARCHAR2(4000),
  zbjdcpmc          VARCHAR2(120),
  ggxh              VARCHAR2(150),
  sl                NUMBER(17,5),
  dj                NUMBER(18,2),
  zj                NUMBER(18,2),
  yhjewmy           NUMBER(16,4),
  cksp_dm           VARCHAR2(20),
  ckspmc            VARCHAR2(75),
  zbjgfzrxm         VARCHAR2(150),
  zbjgsqrq          DATE,
  bz                VARCHAR2(3000),
  btsbz             CHAR(1),
  btsyy             VARCHAR2(4000),
  sbxh              VARCHAR2(50),
  xh_4              VARCHAR2(10),
  tsswjg_dm_1       CHAR(11),
  lrrq              DATE,
  lrr_dm            CHAR(11),
  xgrq              DATE,
  xgr_dm            CHAR(11),
  sjgsdq            CHAR(11),
  sjtb_sj           TIMESTAMP(6),
  sbbh_1            VARCHAR2(20),
  zbjgmc            VARCHAR2(300),
  jkgjjspmc         VARCHAR2(500),
  tbrq_1            DATE,
  jkgjjyhwmy        NUMBER(16,4)
)
;
comment on table CKTS_ZM_ZBZM_LSB
  is '中标证明通知书临时表';
comment on column CKTS_ZM_ZBZM_LSB.ssq
  is '所属期';
comment on column CKTS_ZM_ZBZM_LSB.sbpc
  is '申报批次';
comment on column CKTS_ZM_ZBZM_LSB.djxh
  is '登记序号';
comment on column CKTS_ZM_ZBZM_LSB.zbjgszdswjgmc
  is '中标机构所在地税务机关名称';
comment on column CKTS_ZM_ZBZM_LSB.zbqynsrsbh
  is '中标企业纳税人识别号';
comment on column CKTS_ZM_ZBZM_LSB.zbqymc
  is '中标企业名称';
comment on column CKTS_ZM_ZBZM_LSB.zbwjbh
  is '招标文件编号';
comment on column CKTS_ZM_ZBZM_LSB.zbxmmc
  is '中标项目名称';
comment on column CKTS_ZM_ZBZM_LSB.dkgbjgmc
  is '贷款国别（机构）名称';
comment on column CKTS_ZM_ZBZM_LSB.mgjckyhzqdbdkxmqd
  is '美国进出口银行主权担保贷款项目清单';
comment on column CKTS_ZM_ZBZM_LSB.zbjdcpmc
  is '中标机电产品名称';
comment on column CKTS_ZM_ZBZM_LSB.ggxh
  is '规格型号';
comment on column CKTS_ZM_ZBZM_LSB.sl
  is '数量';
comment on column CKTS_ZM_ZBZM_LSB.dj
  is '单价';
comment on column CKTS_ZM_ZBZM_LSB.zj
  is '总价';
comment on column CKTS_ZM_ZBZM_LSB.yhjewmy
  is '用汇金额（万美元）';
comment on column CKTS_ZM_ZBZM_LSB.cksp_dm
  is '出口商品代码';
comment on column CKTS_ZM_ZBZM_LSB.ckspmc
  is '出口商品名称';
comment on column CKTS_ZM_ZBZM_LSB.zbjgfzrxm
  is '招标机构负责人姓名';
comment on column CKTS_ZM_ZBZM_LSB.zbjgsqrq
  is '招标机构申请日期';
comment on column CKTS_ZM_ZBZM_LSB.bz
  is '备注';
comment on column CKTS_ZM_ZBZM_LSB.btsbz
  is '不退税标志';
comment on column CKTS_ZM_ZBZM_LSB.btsyy
  is '不退税原因';
comment on column CKTS_ZM_ZBZM_LSB.sbxh
  is '申报序号';
comment on column CKTS_ZM_ZBZM_LSB.xh_4
  is '项号';
comment on column CKTS_ZM_ZBZM_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_ZM_ZBZM_LSB.lrrq
  is '录入日期';
comment on column CKTS_ZM_ZBZM_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_ZM_ZBZM_LSB.xgrq
  is '修改日期';
comment on column CKTS_ZM_ZBZM_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_ZM_ZBZM_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_ZM_ZBZM_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_ZM_ZBZM_LSB.sbbh_1
  is '申报编号';
comment on column CKTS_ZM_ZBZM_LSB.zbjgmc
  is '招标机构名称';
comment on column CKTS_ZM_ZBZM_LSB.jkgjjspmc
  is '进口关键件商品名称';
comment on column CKTS_ZM_ZBZM_LSB.tbrq_1
  is '填表日期';
comment on column CKTS_ZM_ZBZM_LSB.jkgjjyhwmy
  is '进口关键件用汇（万美元）';
create index IDX_CKTS_ZM_ZBZM_LSB_1 on CKTS_ZM_ZBZM_LSB (SBID);
create index IDX_CKTS_ZM_ZBZM_LSB_2 on CKTS_ZM_ZBZM_LSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table CKTS_ZM_ZYMSGJJY_LSB
prompt ===================================
prompt
create table CKTS_ZM_ZYMSGJJY_LSB
(
  sbid         NUMBER(18),
  qyhgdm       VARCHAR2(20),
  ssq          VARCHAR2(60),
  sbpc         VARCHAR2(75),
  djxh         NUMBER(20),
  sbxh         VARCHAR2(50),
  sbbh_1       VARCHAR2(20),
  jyscqyshxydm VARCHAR2(20),
  jyscqynsrsbh VARCHAR2(20),
  jyscqymc     VARCHAR2(300),
  jhnd         VARCHAR2(10),
  jhbh         NUMBER(8),
  xh_4         VARCHAR2(10),
  jysp_dm      VARCHAR2(20),
  jymc_1       VARCHAR2(75),
  jyph         VARCHAR2(75),
  jldwmc       VARCHAR2(75),
  sl           NUMBER(17,5),
  dj           NUMBER(18,2),
  zjje_2       NUMBER(18,2),
  ckjyjhsl     NUMBER(17,5),
  ykjzmzjysl   NUMBER(17,5),
  bz           VARCHAR2(3000),
  lrr_dm       CHAR(11),
  lrrq         DATE,
  xgr_dm       CHAR(11),
  xgrq         DATE,
  tsswjg_dm_1  CHAR(11),
  sjgsdq       CHAR(11),
  sjtb_sj      TIMESTAMP(6),
  jhbh_1       VARCHAR2(10)
)
;
comment on table CKTS_ZM_ZYMSGJJY_LSB
  is '准予免税购进出口卷烟证明申请表（临时表）';
comment on column CKTS_ZM_ZYMSGJJY_LSB.ssq
  is '所属期';
comment on column CKTS_ZM_ZYMSGJJY_LSB.sbpc
  is '申报批次';
comment on column CKTS_ZM_ZYMSGJJY_LSB.djxh
  is '登记序号';
comment on column CKTS_ZM_ZYMSGJJY_LSB.sbxh
  is '申报序号';
comment on column CKTS_ZM_ZYMSGJJY_LSB.sbbh_1
  is '申报编号';
comment on column CKTS_ZM_ZYMSGJJY_LSB.jyscqyshxydm
  is '卷烟生产企业社会信用代码';
comment on column CKTS_ZM_ZYMSGJJY_LSB.jyscqynsrsbh
  is '卷烟生产企业纳税人识别号';
comment on column CKTS_ZM_ZYMSGJJY_LSB.jyscqymc
  is '卷烟生产企业名称';
comment on column CKTS_ZM_ZYMSGJJY_LSB.jhnd
  is '计划年度';
comment on column CKTS_ZM_ZYMSGJJY_LSB.jhbh
  is '计划编号';
comment on column CKTS_ZM_ZYMSGJJY_LSB.xh_4
  is '项号';
comment on column CKTS_ZM_ZYMSGJJY_LSB.jysp_dm
  is '卷烟商品代码';
comment on column CKTS_ZM_ZYMSGJJY_LSB.jymc_1
  is '卷烟名称';
comment on column CKTS_ZM_ZYMSGJJY_LSB.jyph
  is '卷烟牌号';
comment on column CKTS_ZM_ZYMSGJJY_LSB.jldwmc
  is '计量单位名称';
comment on column CKTS_ZM_ZYMSGJJY_LSB.sl
  is '数量';
comment on column CKTS_ZM_ZYMSGJJY_LSB.dj
  is '单价';
comment on column CKTS_ZM_ZYMSGJJY_LSB.zjje_2
  is '总计金额';
comment on column CKTS_ZM_ZYMSGJJY_LSB.ckjyjhsl
  is '出口卷烟计划数量';
comment on column CKTS_ZM_ZYMSGJJY_LSB.ykjzmzjysl
  is '已开具《准免证》卷烟数量';
comment on column CKTS_ZM_ZYMSGJJY_LSB.bz
  is '备注';
comment on column CKTS_ZM_ZYMSGJJY_LSB.lrr_dm
  is '录入人代码';
comment on column CKTS_ZM_ZYMSGJJY_LSB.lrrq
  is '录入日期';
comment on column CKTS_ZM_ZYMSGJJY_LSB.xgr_dm
  is '修改人代码';
comment on column CKTS_ZM_ZYMSGJJY_LSB.xgrq
  is '修改日期';
comment on column CKTS_ZM_ZYMSGJJY_LSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column CKTS_ZM_ZYMSGJJY_LSB.sjgsdq
  is '数据归属地区';
comment on column CKTS_ZM_ZYMSGJJY_LSB.sjtb_sj
  is '数据同步时间';
comment on column CKTS_ZM_ZYMSGJJY_LSB.jhbh_1
  is '计划编号';
create index IDX_CKTS_ZM_ZYMSGJJY_LSB_1 on CKTS_ZM_ZYMSGJJY_LSB (SBID);
create index IDX_CKTS_ZM_ZYMSGJJY_LSB_2 on CKTS_ZM_ZYMSGJJY_LSB (QYHGDM, SSQ, SBPC);


prompt
prompt Creating table DM_CKFL
prompt ======================
prompt
create table DM_CKFL
(
  ckfl_dm VARCHAR2(10) not null,
  ckfl_mc VARCHAR2(100) not null,
  fldmcd  NUMBER(4) not null,
  dbfield VARCHAR2(100)
)
;
comment on column DM_CKFL.ckfl_dm
  is '出口分类代码  SPDM/CKKA/MDG/GHS';
comment on column DM_CKFL.ckfl_mc
  is '出口分类名称  商品名称/出口口岸/目的国/供货商';
comment on column DM_CKFL.fldmcd
  is '分类代码长度 0表示按全代码分类，4表示按前4位字符串做分类';
comment on column DM_CKFL.dbfield
  is '数据库字段名';
alter table DM_CKFL
  add constraint PK_DM_CKFL primary key (CKFL_DM);

prompt
prompt Creating table DM_CZRY
prompt ======================
prompt
create table DM_CZRY
(
  czry_dm     VARCHAR2(20) not null,
  czry_mc     VARCHAR2(80) not null,
  password    VARCHAR2(50),
  swjg_dm     VARCHAR2(11) not null,
  czry_dm_zg  VARCHAR2(20) default '',
  yhlx        CHAR(2) default '00' not null,
  usrstate    CHAR(1),
  description VARCHAR2(200),
  crtime      DATE,
  crname      VARCHAR2(20),
  uptime      DATE,
  upname      VARCHAR2(20),
  qybz        CHAR(1) default 'Y' not null,
  lxdh        VARCHAR2(32),
  qx_swjg     VARCHAR2(11),
  czry_tssh   VARCHAR2(20)
)
;
alter table DM_CZRY
  add constraint PK_DM_CZRY primary key (CZRY_DM);

prompt
prompt Creating table DM_CZRY_NEW
prompt ==========================
prompt
create table DM_CZRY_NEW
(
  czry_dm     VARCHAR2(20) not null,
  czry_mc     VARCHAR2(80) not null,
  password    VARCHAR2(50),
  swjg_dm     VARCHAR2(11) not null,
  czry_dm_zg  VARCHAR2(20),
  yhlx        CHAR(2) not null,
  usrstate    CHAR(1),
  description VARCHAR2(200),
  crtime      DATE,
  crname      VARCHAR2(20),
  uptime      DATE,
  upname      VARCHAR2(20),
  qybz        CHAR(1) not null,
  lxdh        VARCHAR2(32),
  qx_swjg     VARCHAR2(11)
)
;

prompt
prompt Creating table DM_FILTER_RULE
prompt =============================
prompt
create table DM_FILTER_RULE
(
  rule_dm  VARCHAR2(10) not null,
  rule_mc  VARCHAR2(100) not null,
  note     VARCHAR2(4) not null,
  zb_dm    VARCHAR2(10),
  score    NUMBER(8) not null,
  errlevel NUMBER(4) not null
)
;
comment on column DM_FILTER_RULE.rule_dm
  is '筛选规则代码';
comment on column DM_FILTER_RULE.rule_mc
  is '筛选规则名称';
comment on column DM_FILTER_RULE.note
  is '评分规则说明';
comment on column DM_FILTER_RULE.zb_dm
  is '涉及的指标代码';
comment on column DM_FILTER_RULE.score
  is '加或扣分总额 0-1000(100%权重的值）';
comment on column DM_FILTER_RULE.errlevel
  is '异常等级  从低到高0-9';
alter table DM_FILTER_RULE
  add constraint PK_DM_FILTER_RULE primary key (RULE_DM);


prompt
prompt Creating table DM_GBDL
prompt ======================
prompt
create table DM_GBDL
(
  dl VARCHAR2(3) not null,
  mc VARCHAR2(30)
)
;
alter table DM_GBDL
  add primary key (DL);

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
prompt Creating table DM_GT3_XML_FIELD_CONFIG
prompt ======================================
prompt
create table DM_GT3_XML_FIELD_CONFIG
(
  id            INTEGER not null,
  sbb_dm        VARCHAR2(255),
  field_name    VARCHAR2(255),
  field_zh      VARCHAR2(255),
  tag_name      VARCHAR2(255),
  default_value VARCHAR2(255),
  fmt_str       VARCHAR2(255),
  max_len       INTEGER,
  tbl_name      VARCHAR2(255),
  note          VARCHAR2(100),
  gt3field_name VARCHAR2(100),
  sbb_dm_suffix VARCHAR2(100),
  qybz          CHAR(1)
)
;
comment on column DM_GT3_XML_FIELD_CONFIG.sbb_dm
  is '数据表代码';
comment on column DM_GT3_XML_FIELD_CONFIG.field_name
  is '字段名称';
comment on column DM_GT3_XML_FIELD_CONFIG.field_zh
  is '字段中文释义';
comment on column DM_GT3_XML_FIELD_CONFIG.tag_name
  is 'xml标签名称';
comment on column DM_GT3_XML_FIELD_CONFIG.default_value
  is '缺省值';
comment on column DM_GT3_XML_FIELD_CONFIG.fmt_str
  is '格式化公式';
comment on column DM_GT3_XML_FIELD_CONFIG.max_len
  is '最大长度';
comment on column DM_GT3_XML_FIELD_CONFIG.tbl_name
  is '数据表名';
comment on column DM_GT3_XML_FIELD_CONFIG.note
  is '表单名称';
comment on column DM_GT3_XML_FIELD_CONFIG.gt3field_name
  is '金三字段名';
comment on column DM_GT3_XML_FIELD_CONFIG.sbb_dm_suffix
  is '申报表代码后缀,用户历史查询';
comment on column DM_GT3_XML_FIELD_CONFIG.qybz
  is '报文标志';
alter table DM_GT3_XML_FIELD_CONFIG
  add constraint DM_GT3_XML_FIELD_CONFIG_PKEY2 primary key (ID);

prompt
prompt Creating table DM_GT3_XML_TBL_CONFIG
prompt ====================================
prompt
create table DM_GT3_XML_TBL_CONFIG
(
  id               INTEGER not null,
  sbyw_dm          VARCHAR2(32) not null,
  sbb_dm           VARCHAR2(255) not null,
  tbl_name         VARCHAR2(255),
  query_service    VARCHAR2(255),
  query_sqlid      VARCHAR2(255),
  tag_name         VARCHAR2(255),
  tag_child_suffix VARCHAR2(255) default 'lb',
  qybz             CHAR(1) default 'Y' not null,
  fksqlid          VARCHAR2(255),
  sbbfb            VARCHAR2(255),
  sbb_mc           VARCHAR2(100),
  gt3tbl_name      VARCHAR2(255),
  sbbfbdm          VARCHAR2(50)
)
;
comment on column DM_GT3_XML_TBL_CONFIG.sbyw_dm
  is '申报业务代码';
comment on column DM_GT3_XML_TBL_CONFIG.sbb_dm
  is '申报表代码';
comment on column DM_GT3_XML_TBL_CONFIG.tbl_name
  is '申报数据表名称';
comment on column DM_GT3_XML_TBL_CONFIG.query_service
  is '查询服务';
comment on column DM_GT3_XML_TBL_CONFIG.query_sqlid
  is '查询sql mapper标识';
comment on column DM_GT3_XML_TBL_CONFIG.tag_name
  is '数据节点tag名称';
comment on column DM_GT3_XML_TBL_CONFIG.tag_child_suffix
  is '循环节点后缀';
comment on column DM_GT3_XML_TBL_CONFIG.qybz
  is '是否启用 Y-启用 N-不启用';
comment on column DM_GT3_XML_TBL_CONFIG.fksqlid
  is '历史数据查询SQL ID';
comment on column DM_GT3_XML_TBL_CONFIG.sbbfb
  is '附表自检标志';
comment on column DM_GT3_XML_TBL_CONFIG.gt3tbl_name
  is '金三库表名';
comment on column DM_GT3_XML_TBL_CONFIG.sbbfbdm
  is '申报向导图附表代码';
alter table DM_GT3_XML_TBL_CONFIG
  add constraint DM_GT3_XML_TBL_CONFIG_PKEY primary key (ID);
alter table DM_GT3_XML_TBL_CONFIG
  add constraint SBYW_TBL_INDEX unique (SBYW_DM, SBB_DM);


prompt
prompt Creating table DM_HIS_DATA_FIELD
prompt ================================
prompt
create table DM_HIS_DATA_FIELD
(
  id           NUMBER(20) not null,
  sbbdm        VARCHAR2(20) not null,
  souce_field  VARCHAR2(20) not null,
  target_field VARCHAR2(20) not null,
  bz           VARCHAR2(50),
  qybj         VARCHAR2(1) default 'Y'
)
;
comment on table DM_HIS_DATA_FIELD
  is '历史数据查询 局端字段与云平台字段 对应关系';
comment on column DM_HIS_DATA_FIELD.id
  is 'ID';
comment on column DM_HIS_DATA_FIELD.sbbdm
  is '申报表代码';
comment on column DM_HIS_DATA_FIELD.souce_field
  is '局端字段名';
comment on column DM_HIS_DATA_FIELD.target_field
  is '云平台字段名';
comment on column DM_HIS_DATA_FIELD.bz
  is '备注';
comment on column DM_HIS_DATA_FIELD.qybj
  is '启用标记 (Y为启用，N为未启用)  默认启用';
alter table DM_HIS_DATA_FIELD
  add constraint DM_HIS_DATA_FIELD_ID primary key (ID);

prompt
prompt Creating table DM_HIS_DATA_TABLE
prompt ================================
prompt
create table DM_HIS_DATA_TABLE
(
  id        NUMBER(18) not null,
  sbywbdm   VARCHAR2(20) not null,
  sbbdm     VARCHAR2(20) not null,
  namespace VARCHAR2(50) not null,
  bz        VARCHAR2(50),
  qybj      VARCHAR2(1) default 'Y'
)
;
comment on table DM_HIS_DATA_TABLE
  is '历史数据局端查询 对应关系表';
comment on column DM_HIS_DATA_TABLE.id
  is '主键';
comment on column DM_HIS_DATA_TABLE.sbywbdm
  is '申报业务表代码';
comment on column DM_HIS_DATA_TABLE.sbbdm
  is '申报表代码';
comment on column DM_HIS_DATA_TABLE.namespace
  is 'sql 的nameSpace';
comment on column DM_HIS_DATA_TABLE.bz
  is '备注';
comment on column DM_HIS_DATA_TABLE.qybj
  is '启用标记 (启用为Y，未启用为N，默认为启用)';
alter table DM_HIS_DATA_TABLE
  add constraint DM_HIS_DATA_ID primary key (ID);

prompt
prompt Creating table DM_HY
prompt ====================
prompt
create table DM_HY
(
  hy_dm VARCHAR2(10) not null,
  hy_mc VARCHAR2(100) not null
)
;
alter table DM_HY
  add constraint PK_DM_HY primary key (HY_DM);

prompt
prompt Creating table DM_HY_TS
prompt =======================
prompt
create table DM_HY_TS
(
  hy_ts_dm VARCHAR2(10) not null,
  hy_ts_mc VARCHAR2(100) not null
)
;
alter table DM_HY_TS
  add constraint PK_DM_HY_TS primary key (HY_TS_DM);

prompt
prompt Creating table DM_PART_FKFIELD
prompt ==============================
prompt
create table DM_PART_FKFIELD
(
  id       NUMBER(18) not null,
  sbbdm    VARCHAR2(50) not null,
  tag      VARCHAR2(200) not null,
  fname    VARCHAR2(200),
  nullval  VARCHAR2(200),
  datatype VARCHAR2(50),
  fmt      VARCHAR2(200),
  cname    VARCHAR2(50)
)
;
comment on table DM_PART_FKFIELD
  is '反馈部分字段表结构代码';
comment on column DM_PART_FKFIELD.id
  is '主键';
comment on column DM_PART_FKFIELD.sbbdm
  is '申报表代码';
comment on column DM_PART_FKFIELD.tag
  is '字段标签';
comment on column DM_PART_FKFIELD.fname
  is '字段名';
comment on column DM_PART_FKFIELD.nullval
  is '是否为空';
comment on column DM_PART_FKFIELD.datatype
  is '数据类型';
comment on column DM_PART_FKFIELD.fmt
  is '数据格式';
comment on column DM_PART_FKFIELD.cname
  is '字段中文名';
alter table DM_PART_FKFIELD
  add primary key (ID);

prompt
prompt Creating table DM_PART_FKTBL
prompt ============================
prompt
create table DM_PART_FKTBL
(
  id       NUMBER(18) not null,
  sbywb_dm VARCHAR2(20) not null,
  sbbdm    VARCHAR2(50) not null,
  tblname  VARCHAR2(200) not null,
  sqlid    VARCHAR2(200),
  qybj     CHAR(1) not null,
  bz       VARCHAR2(200)
)
;
comment on table DM_PART_FKTBL
  is '??????????????????????';
comment on column DM_PART_FKTBL.id
  is '????';
comment on column DM_PART_FKTBL.sbywb_dm
  is '??????????????';
comment on column DM_PART_FKTBL.sbbdm
  is '??????????';
comment on column DM_PART_FKTBL.tblname
  is '????';
comment on column DM_PART_FKTBL.sqlid
  is '????sqlid';
comment on column DM_PART_FKTBL.qybj
  is '????????';
comment on column DM_PART_FKTBL.bz
  is '????';
create unique index UQ_DM_PART_XMLTBL_SS on DM_PART_FKTBL (SBYWB_DM, SBBDM);
alter table DM_PART_FKTBL
  add primary key (ID);

prompt
prompt Creating table DM_ROLE
prompt ======================
prompt
create table DM_ROLE
(
  role_dm     VARCHAR2(20) not null,
  role_mc     VARCHAR2(20) not null,
  description VARCHAR2(200),
  crtime      DATE,
  crname      VARCHAR2(20),
  uptime      DATE,
  upname      VARCHAR2(20),
  qybz        CHAR(1)
)
;
comment on table DM_ROLE
  is '权限管理_角色代码表';
comment on column DM_ROLE.role_dm
  is '角色代码';
comment on column DM_ROLE.role_mc
  is '角色名称';
comment on column DM_ROLE.description
  is '角色描述';
comment on column DM_ROLE.crtime
  is '创建时间';
comment on column DM_ROLE.crname
  is '创建人员';
comment on column DM_ROLE.uptime
  is '更新时间';
comment on column DM_ROLE.upname
  is '更新人员';
comment on column DM_ROLE.qybz
  is '启用标识';
alter table DM_ROLE
  add constraint PK_DM_ROLE primary key (ROLE_DM);

prompt
prompt Creating table DM_SERVICE
prompt =========================
prompt
create table DM_SERVICE
(
  service_dm  VARCHAR2(200) not null,
  service_mc  VARCHAR2(20) not null,
  description VARCHAR2(200),
  menu_set    VARCHAR2(200),
  crtime      DATE,
  crname      VARCHAR2(20),
  uptime      DATE,
  upname      VARCHAR2(20),
  qybz        CHAR(1)
)
;
comment on table DM_SERVICE
  is '权限管理_服务代码';
comment on column DM_SERVICE.service_dm
  is '服务代码';
comment on column DM_SERVICE.service_mc
  is '服务名称';
comment on column DM_SERVICE.description
  is '服务描述';
comment on column DM_SERVICE.menu_set
  is '服务对应客户端菜单列表';
comment on column DM_SERVICE.crtime
  is '创建时间';
comment on column DM_SERVICE.crname
  is '创建人员';
comment on column DM_SERVICE.uptime
  is '更新时间';
comment on column DM_SERVICE.upname
  is '更新人员';
comment on column DM_SERVICE.qybz
  is '启用标识';
alter table DM_SERVICE
  add constraint PK_DM_SERVICE primary key (SERVICE_DM);

prompt
prompt Creating table DM_SHYD
prompt ======================
prompt
create table DM_SHYD
(
  sbywbdm   VARCHAR2(10) not null,
  ydcode    VARCHAR2(10) not null,
  err_obj   VARCHAR2(30),
  err_msg   VARCHAR2(255) not null,
  err_lev   VARCHAR2(10),
  pass_flag VARCHAR2(1),
  is_valid  CHAR(1) default 1,
  qy_flag   CHAR(1),
  gs_flag   CHAR(1)
)
;
comment on table DM_SHYD
  is '审核疑点字典表';
comment on column DM_SHYD.sbywbdm
  is '申报业务表代码';
comment on column DM_SHYD.ydcode
  is '疑点代码';
comment on column DM_SHYD.err_obj
  is '疑点对象(单证名称)';
comment on column DM_SHYD.err_msg
  is '疑点信息';
comment on column DM_SHYD.err_lev
  is '疑点等级';
comment on column DM_SHYD.pass_flag
  is '是否可挑过';
comment on column DM_SHYD.is_valid
  is '启用标志';
comment on column DM_SHYD.qy_flag
  is '用于企业';
comment on column DM_SHYD.gs_flag
  is '用于税务';
alter table DM_SHYD
  add constraint PK_DM_SHYD primary key (SBYWBDM, YDCODE);

prompt
prompt Creating table DM_SJFK_XMLFIELD
prompt ===============================
prompt
create table DM_SJFK_XMLFIELD
(
  id       NUMBER(18) not null,
  tblname  VARCHAR2(200) not null,
  xmltag   VARCHAR2(200) not null,
  fname    VARCHAR2(200),
  issbxx   CHAR(1) not null,
  nullval  VARCHAR2(200),
  datatype VARCHAR2(50),
  fmt      VARCHAR2(200),
  cname    VARCHAR2(50),
  fname_ys VARCHAR2(200),
  sbbdm    VARCHAR2(20),
  maxlen   NUMBER(10)
)
;
alter table DM_SJFK_XMLFIELD
  add constraint PK_DM_SJFK_XMLFIELD primary key (ID);

prompt
prompt Creating table DM_SJFK_XMLTBL
prompt =============================
prompt
create table DM_SJFK_XMLTBL
(
  id         NUMBER(18) not null,
  sbywb_dm   VARCHAR2(20) not null,
  sbbdm      VARCHAR2(50),
  tblname    VARCHAR2(200) not null,
  sqlid      VARCHAR2(200),
  gridtag    VARCHAR2(200) not null,
  qybj       CHAR(1) not null,
  fksqlid    VARCHAR2(500),
  sbbfb      VARCHAR2(50),
  tblname_ys VARCHAR2(200)
)
;
comment on column DM_SJFK_XMLTBL.sbywb_dm
  is '申报业务表代码，如生产免抵退A0305001';
comment on column DM_SJFK_XMLTBL.sbbdm
  is '申报表代码，如免抵退明细表0305001010';
comment on column DM_SJFK_XMLTBL.tblname
  is '云平台数据表名称，如免抵退明细表sb_mdts_mxb';
comment on column DM_SJFK_XMLTBL.sqlid
  is '历史数据反馈局端查询sql';
comment on column DM_SJFK_XMLTBL.gridtag
  is '申报、反馈报文节点名称';
comment on column DM_SJFK_XMLTBL.qybj
  is '启用标记';
comment on column DM_SJFK_XMLTBL.fksqlid
  is '初审往临时表写数据sql';
comment on column DM_SJFK_XMLTBL.sbbfb
  is '对应云端申报表附表名称，暂时没用';
comment on column DM_SJFK_XMLTBL.tblname_ys
  is '初审临时表表名';
create unique index UQ_DM_SJFK_XMLTBL_SS on DM_SJFK_XMLTBL (SBYWB_DM, SBBDM);
alter table DM_SJFK_XMLTBL
  add constraint PK_DM_SJFK_XMLTBL primary key (ID);

prompt
prompt Creating table DM_SPDM4
prompt =======================
prompt
create table DM_SPDM4
(
  spdm4   VARCHAR2(10) not null,
  spmc    VARCHAR2(50),
  spfname VARCHAR2(400),
  ml      VARCHAR2(4)
)
;
alter table DM_SPDM4
  add primary key (SPDM4);


prompt
prompt Creating table DM_SWJG_BAK20220322
prompt ==================================
prompt
create table DM_SWJG_BAK20220322
(
  swjg_dm    VARCHAR2(11) not null,
  swjg_mc    VARCHAR2(80) not null,
  swjg_jc    VARCHAR2(80) not null,
  swjg_dm_sj VARCHAR2(11) not null,
  yxws       NUMBER(10),
  swjg_bz    CHAR(1) not null,
  qybz       CHAR(1) not null,
  tsjg_bz    CHAR(1)
)
;

prompt
prompt Creating table DM_SWJG_DZB
prompt ==========================
prompt
create table DM_SWJG_DZB
(
  glxt_swjg_dm VARCHAR2(11) not null,
  swjg_dm      VARCHAR2(11) not null,
  swjg_mc      VARCHAR2(100),
  cnt          NUMBER(10)
)
;
alter table DM_SWJG_DZB
  add primary key (GLXT_SWJG_DM);

prompt
prompt Creating table DM_SWJG_TJ
prompt =========================
prompt
create table DM_SWJG_TJ
(
  swjgdm VARCHAR2(11) not null,
  swjgmc VARCHAR2(50),
  swjgjc VARCHAR2(50),
  sjdm   VARCHAR2(11),
  dispsx VARCHAR2(20)
)
;
comment on column DM_SWJG_TJ.dispsx
  is '显示缩写';
alter table DM_SWJG_TJ
  add primary key (SWJGDM);

prompt
prompt Creating table DM_TABLE
prompt =======================
prompt
create table DM_TABLE
(
  id        NUMBER(18) not null,
  sbywbdm   VARCHAR2(20) not null,
  sbbdm     VARCHAR2(20) not null,
  namespace VARCHAR2(50),
  bz        VARCHAR2(100),
  qybj      VARCHAR2(1) default 'Y',
  sbbfbdm   VARCHAR2(50)
)
;
comment on table DM_TABLE
  is 'gt3_tbl表，历史数据查询sqlid配置（备份表）';
comment on column DM_TABLE.id
  is '主键';
comment on column DM_TABLE.sbywbdm
  is '申报业务表代码';
comment on column DM_TABLE.sbbdm
  is '申报表代码';
comment on column DM_TABLE.namespace
  is 'sql 的nameSpace';
comment on column DM_TABLE.bz
  is '备注';
comment on column DM_TABLE.qybj
  is '启用标记 (启用为Y，未启用为N，默认为启用)';
alter table DM_TABLE
  add constraint DM_TABLE_ID primary key (ID);

prompt
prompt Creating table DM_TBLX
prompt ======================
prompt
create table DM_TBLX
(
  id      NUMBER(18) not null,
  mc      VARCHAR2(200) not null,
  tblx_dm VARCHAR2(50) not null,
  sqlid   VARCHAR2(1000),
  qzfw    VARCHAR2(200),
  hzfw    VARCHAR2(200),
  tbhfw   VARCHAR2(200),
  bz      VARCHAR2(1000),
  qybj    CHAR(1) not null
)
;
create unique index UQ_DM_TBLX_LX on DM_TBLX (TBLX_DM);
alter table DM_TBLX
  add constraint PK_DM_TBLX primary key (ID);

prompt
prompt Creating table DM_YJXX
prompt ======================
prompt
create table DM_YJXX
(
  yjcode   VARCHAR2(10) not null,
  yjname   VARCHAR2(20) not null,
  yj_msg   VARCHAR2(255) not null,
  required CHAR(1),
  qy_flag  CHAR(1),
  gs_flag  CHAR(1),
  is_valid CHAR(1),
  swcode   VARCHAR2(100)
)
;
comment on column DM_YJXX.yjcode
  is '预警代码';
comment on column DM_YJXX.yjname
  is '预警名称';
comment on column DM_YJXX.yj_msg
  is '预警信息';
comment on column DM_YJXX.required
  is '税务必选';
comment on column DM_YJXX.qy_flag
  is '用于企业';
comment on column DM_YJXX.gs_flag
  is '用于税务';
comment on column DM_YJXX.is_valid
  is '是否有效';
comment on column DM_YJXX.swcode
  is '提交税务机关集（用,隔开）';

prompt
prompt Creating table DM_YSFS
prompt ======================
prompt
create table DM_YSFS
(
  ysfscode VARCHAR2(4) not null,
  ysfsmc   VARCHAR2(60)
)
;
alter table DM_YSFS
  add primary key (YSFSCODE);

prompt
prompt Creating table DM_ZB
prompt ====================
prompt
create table DM_ZB
(
  zb_dm   VARCHAR2(10) not null,
  zb_mc   VARCHAR2(100) not null,
  zbfl    VARCHAR2(100),
  qylx    CHAR(1),
  zbsm    VARCHAR2(1000),
  zbgs    VARCHAR2(1000),
  jsbds   VARCHAR2(1000),
  cssm    VARCHAR2(1000),
  pdyc    VARCHAR2(4000),
  val_min NUMBER(16,2),
  val_max NUMBER(16,2),
  ed_min  NUMBER(16,4),
  ed_max  NUMBER(16,4),
  fd_min  NUMBER(16,4),
  fd_max  NUMBER(16,4),
  hybz    CHAR(1) not null
)
;
comment on column DM_ZB.zb_dm
  is '指标代码';
comment on column DM_ZB.zb_mc
  is '指标名称';
comment on column DM_ZB.zbfl
  is '指标分类，预留（如退税指标、纳税指标、财务指标等）';
comment on column DM_ZB.qylx
  is '企业类型，该指标适用企业类型 1生产 2外贸 3全部企业类型';
comment on column DM_ZB.zbsm
  is '指标说明';
comment on column DM_ZB.zbgs
  is '公式文字描述';
comment on column DM_ZB.jsbds
  is '计算公式的表达式';
comment on column DM_ZB.cssm
  is '参数说明，对PM1到PM9参数进行说明';
comment on column DM_ZB.pdyc
  is '判定异常描述，该指标何种情况判定为异常，且异常的风险监控点描述';
comment on column DM_ZB.val_min
  is '指标值下限，空表示无';
comment on column DM_ZB.val_max
  is '指标值上限，空表示无';
comment on column DM_ZB.ed_min
  is '差额额度下限，空表示无,差额额度=VAL-基期VAL';
comment on column DM_ZB.ed_max
  is '差额额度上限，空表示无';
comment on column DM_ZB.fd_min
  is '差额幅度下限，空表示无,差额幅度=(VAL-基期VAL)/基期VAL';
comment on column DM_ZB.fd_max
  is '差额幅度上限，空表示无';
comment on column DM_ZB.hybz
  is '行业比较标志1表示可与行业指标做横向比较 0表示不';
alter table DM_ZB
  add constraint PK_DM_ZB primary key (ZB_DM);

prompt
prompt Creating table DM_ZB_HYCS
prompt =========================
prompt
create table DM_ZB_HYCS
(
  zb_dm      VARCHAR2(10) not null,
  hy_dm      VARCHAR2(10) not null,
  swjg_dm    VARCHAR2(11) not null,
  ed_min     NUMBER(16,4),
  ed_max     NUMBER(16,4),
  ed_qz_unit NUMBER(16,4),
  fd_min     NUMBER(16,4),
  fd_max     NUMBER(16,4),
  fd_qz_unit NUMBER(16,4)
)
;
comment on column DM_ZB_HYCS.zb_dm
  is '指标代码';
comment on column DM_ZB_HYCS.hy_dm
  is '行业代码';
comment on column DM_ZB_HYCS.swjg_dm
  is '税务机关代码 预留，考虑要按地区+行业来预警';
comment on column DM_ZB_HYCS.ed_min
  is '差额额度下限  空表示无,减平均值 得到的差额额度';
comment on column DM_ZB_HYCS.ed_max
  is '差额额度上限  空表示无';
comment on column DM_ZB_HYCS.ed_qz_unit
  is '单位权重差额额度  每10%权重的差额额度值';
comment on column DM_ZB_HYCS.fd_min
  is '差额幅度下限  空表示无,与平均值的差额/平均值 得到的差额幅度';
comment on column DM_ZB_HYCS.fd_max
  is '差额幅度上限  空表示无';
comment on column DM_ZB_HYCS.fd_qz_unit
  is '单位权重差额幅度  每10%权重的差额幅度值';
alter table DM_ZB_HYCS
  add constraint PK_DM_ZB_HYCS primary key (ZB_DM, HY_DM, SWJG_DM);

prompt
prompt Creating table DOC_FILEINFO
prompt ===========================
prompt
create table DOC_FILEINFO
(
  id       NUMBER(18) not null,
  filename VARCHAR2(1000),
  fmcode   VARCHAR2(50),
  title    VARCHAR2(200),
  filesize NUMBER(18),
  rootpath VARCHAR2(1000) not null,
  filepath VARCHAR2(1000) not null,
  busitype VARCHAR2(200),
  busikey  NUMBER(18),
  nsrdzdah NUMBER(20),
  filetype CHAR(1) not null,
  note     VARCHAR2(4000),
  issign   CHAR(1) not null,
  crid     NUMBER(18),
  crtime   TIMESTAMP(6),
  upid     NUMBER(18),
  uptime   TIMESTAMP(6),
  nsrsbh   VARCHAR2(20),
  islock   CHAR(1),
  note2    VARCHAR2(4000),
  dycs     NUMBER(10),
  zmbh     VARCHAR2(30),
  fjlx     VARCHAR2(40)
)
;
comment on column DOC_FILEINFO.islock
  is '默认空，Y 已阅锁定 N解除';
comment on column DOC_FILEINFO.note2
  is '备注2';
comment on column DOC_FILEINFO.zmbh
  is '证明编号';
comment on column DOC_FILEINFO.fjlx
  is '附件类型';
create index IX_DOC_FILEINFO_BB on DOC_FILEINFO (BUSITYPE, BUSIKEY);
create index IX_DOC_FILEINFO_NB on DOC_FILEINFO (NSRSBH, BUSITYPE);
create index IX_DOC_FILEINFO_NBB on DOC_FILEINFO (NSRDZDAH, BUSITYPE, BUSIKEY);
create unique index UQ_DOC_FILEINFO_FILEPATH on DOC_FILEINFO (FILEPATH);
alter table DOC_FILEINFO
  add constraint PK_DOC_FILEINFO primary key (ID);

prompt
prompt Creating table DOC_FILEINFO_DYCK
prompt ================================
prompt
create table DOC_FILEINFO_DYCK
(
  id       NUMBER(18) not null,
  filename VARCHAR2(1000),
  fmcode   VARCHAR2(50),
  title    VARCHAR2(200),
  filesize NUMBER(18),
  rootpath VARCHAR2(1000) not null,
  filepath VARCHAR2(1000) not null,
  busitype VARCHAR2(200),
  busikey  NUMBER(18),
  nsrdzdah NUMBER(20),
  filetype CHAR(1) not null,
  note     VARCHAR2(4000),
  issign   CHAR(1) not null,
  crid     NUMBER(18),
  crtime   TIMESTAMP(6),
  upid     NUMBER(18),
  uptime   TIMESTAMP(6),
  nsrsbh   VARCHAR2(20),
  islock   CHAR(1),
  note2    VARCHAR2(4000),
  dycs     NUMBER(10)
)
;
comment on table DOC_FILEINFO_DYCK
  is '单一窗口备份';
comment on column DOC_FILEINFO_DYCK.islock
  is '默认空，Y 已阅锁定 N解除';
comment on column DOC_FILEINFO_DYCK.note2
  is '备注2';
create index IX_DOC_FILEINFO_DYCK_NB on DOC_FILEINFO_DYCK (NSRSBH, BUSITYPE);
create index IX_DOC_FILEINFO_DYCK_NBB on DOC_FILEINFO_DYCK (NSRDZDAH, BUSITYPE, BUSIKEY);
create unique index UQ_DOC_FILEINFO_DYCK_FILEPATH on DOC_FILEINFO_DYCK (FILEPATH);
alter table DOC_FILEINFO_DYCK
  add constraint PK_DOC_FILEINFO_DYCK primary key (ID);

prompt
prompt Creating table DOC_FILEINFO_KZ
prompt ==============================
prompt
create table DOC_FILEINFO_KZ
(
  id          NUMBER(18) not null,
  clbz        CHAR(1),
  filehash    VARCHAR2(40),
  rootpath    VARCHAR2(255),
  filepath    VARCHAR2(1000),
  crtime      TIMESTAMP(6),
  uptime      TIMESTAMP(6),
  downloadnum NUMBER(5)
)
;
comment on column DOC_FILEINFO_KZ.clbz
  is '处理标志  0：待下载    1：已下载';
comment on column DOC_FILEINFO_KZ.filehash
  is '文件哈希';
comment on column DOC_FILEINFO_KZ.rootpath
  is '根路径';
comment on column DOC_FILEINFO_KZ.filepath
  is '文件相对路径';
comment on column DOC_FILEINFO_KZ.crtime
  is '创建时间';
comment on column DOC_FILEINFO_KZ.uptime
  is '修改时间';
comment on column DOC_FILEINFO_KZ.downloadnum
  is '下载次数';
alter table DOC_FILEINFO_KZ
  add primary key (ID);

prompt
prompt Creating table DSF_DECLARE_COMPANYINFO
prompt ======================================
prompt
create table DSF_DECLARE_COMPANYINFO
(
  id                   NUMBER(18) not null,
  social_credit_code   VARCHAR2(20) not null,
  tax_name             VARCHAR2(100) not null,
  customs_company_code VARCHAR2(20),
  agent_code           VARCHAR2(30),
  company_type         CHAR(2) not null,
  operator             VARCHAR2(100) not null,
  operator_id          VARCHAR2(20) not null,
  operator_phone       VARCHAR2(30) not null,
  declare_type         CHAR(2) not null,
  finance_chief        VARCHAR2(100) not null,
  legal_person         VARCHAR2(100) not null,
  agent_credit_code    VARCHAR2(20),
  agent_name           VARCHAR2(100),
  agent_customs_code   VARCHAR2(20),
  agent_operator       VARCHAR2(100),
  agent_operator_id    VARCHAR2(30),
  agent_operator_phone VARCHAR2(30),
  decl_time            TIMESTAMP(6) not null,
  tax_org_code         VARCHAR2(20),
  tax_org_name         VARCHAR2(100),
  tax_org_operator     VARCHAR2(100),
  approve_state        CHAR(2) not null,
  approve_message      VARCHAR2(400),
  create_time          TIMESTAMP(6) not null,
  update_time          TIMESTAMP(6),
  attachment           CLOB,
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
comment on column DSF_DECLARE_COMPANYINFO.attachment
  is '附件-税务登记证等(将ZIP流通过Base64编码生成内容)';
comment on column DSF_DECLARE_COMPANYINFO.withdraw_flag
  is '备案撤回标志, 1:备案撤回 空值:备案';
create unique index IDX_DECLARE_COMPANYINFO_CODE on DSF_DECLARE_COMPANYINFO (SOCIAL_CREDIT_CODE);
alter table DSF_DECLARE_COMPANYINFO
  add constraint PK_DSF_DECLARE_COMPANYINFO primary key (ID);

prompt
prompt Creating table DSF_DECLARE_COMPANYINFO_BAK
prompt ==========================================
prompt
create table DSF_DECLARE_COMPANYINFO_BAK
(
  id                   NUMBER(18) not null,
  social_credit_code   VARCHAR2(20) not null,
  tax_name             VARCHAR2(100) not null,
  customs_company_code VARCHAR2(20),
  agent_code           VARCHAR2(30),
  company_type         CHAR(2) not null,
  operator             VARCHAR2(100) not null,
  operator_id          VARCHAR2(20) not null,
  operator_phone       VARCHAR2(30) not null,
  declare_type         CHAR(2) not null,
  finance_chief        VARCHAR2(100) not null,
  legal_person         VARCHAR2(100) not null,
  agent_credit_code    VARCHAR2(20),
  agent_name           VARCHAR2(100),
  agent_customs_code   VARCHAR2(20),
  agent_operator       VARCHAR2(100),
  agent_operator_id    VARCHAR2(30),
  agent_operator_phone VARCHAR2(30),
  decl_time            TIMESTAMP(6) not null,
  tax_org_code         VARCHAR2(20),
  tax_org_name         VARCHAR2(100),
  tax_org_operator     VARCHAR2(100),
  approve_state        CHAR(2) not null,
  approve_message      VARCHAR2(400),
  create_time          TIMESTAMP(6) not null,
  update_time          TIMESTAMP(6),
  attachment           CLOB,
  withdraw_flag        CHAR(1)
)
;
comment on column DSF_DECLARE_COMPANYINFO_BAK.id
  is '序号';
comment on column DSF_DECLARE_COMPANYINFO_BAK.social_credit_code
  is '统一社会信用代码';
comment on column DSF_DECLARE_COMPANYINFO_BAK.tax_name
  is '纳税人名称';
comment on column DSF_DECLARE_COMPANYINFO_BAK.customs_company_code
  is '海关企业代码';
comment on column DSF_DECLARE_COMPANYINFO_BAK.agent_code
  is '对外贸易经营者备案登记表编号';
comment on column DSF_DECLARE_COMPANYINFO_BAK.company_type
  is '企业类型 (01内资生产企业、02外商投资企业、03外贸企业、04个体工商户)';
comment on column DSF_DECLARE_COMPANYINFO_BAK.operator
  is '经办人员-姓名';
comment on column DSF_DECLARE_COMPANYINFO_BAK.operator_id
  is '经办人员-身份证号';
comment on column DSF_DECLARE_COMPANYINFO_BAK.operator_phone
  is '经办人员-电话';
comment on column DSF_DECLARE_COMPANYINFO_BAK.declare_type
  is '免税申报方式(01代理申报、 02自行申报)';
comment on column DSF_DECLARE_COMPANYINFO_BAK.finance_chief
  is '财务负责人';
comment on column DSF_DECLARE_COMPANYINFO_BAK.legal_person
  is '法定代表人';
comment on column DSF_DECLARE_COMPANYINFO_BAK.agent_credit_code
  is '代理企业统一社会信用代码(申报方式为代理申报必填)';
comment on column DSF_DECLARE_COMPANYINFO_BAK.agent_name
  is '代理企业纳税人名称(申报方式为代理申报必填)';
comment on column DSF_DECLARE_COMPANYINFO_BAK.agent_customs_code
  is '代理企业海关企业代码(申报方式为代理申报必填)';
comment on column DSF_DECLARE_COMPANYINFO_BAK.agent_operator
  is '代理经办人员-姓名(申报方式为代理申报必填)';
comment on column DSF_DECLARE_COMPANYINFO_BAK.agent_operator_id
  is '代理经办人员-身份证号(申报方式为代理申报必填)';
comment on column DSF_DECLARE_COMPANYINFO_BAK.agent_operator_phone
  is '代理经办人员-电话(申报方式为代理申报必填)';
comment on column DSF_DECLARE_COMPANYINFO_BAK.decl_time
  is '申报时间';
comment on column DSF_DECLARE_COMPANYINFO_BAK.tax_org_code
  is '主管税务机关代码';
comment on column DSF_DECLARE_COMPANYINFO_BAK.tax_org_name
  is '主管税务机关名称';
comment on column DSF_DECLARE_COMPANYINFO_BAK.tax_org_operator
  is '主管税务机关经办人';
comment on column DSF_DECLARE_COMPANYINFO_BAK.approve_state
  is '审核状态：00:云平台落地、01：审核中（局端落地）02 审核通过 03 审核不通过';
comment on column DSF_DECLARE_COMPANYINFO_BAK.approve_message
  is '审批信息(审批不通过必填)';
comment on column DSF_DECLARE_COMPANYINFO_BAK.create_time
  is '创建时间';
comment on column DSF_DECLARE_COMPANYINFO_BAK.update_time
  is '修改时间（包含落地时间、审核时间等）';
comment on column DSF_DECLARE_COMPANYINFO_BAK.attachment
  is '附件-税务登记证等(将ZIP流通过Base64编码生成内容)';
comment on column DSF_DECLARE_COMPANYINFO_BAK.withdraw_flag
  is '备案撤回标志, 1:备案撤回 空值:备案';

prompt
prompt Creating table DZBA_SB_DB_TSSB
prompt ==============================
prompt
create table DZBA_SB_DB_TSSB
(
  sbid             NUMBER(18),
  qyhgdm           VARCHAR2(20),
  djxh             NUMBER(20),
  ssq              VARCHAR2(60),
  sbpc             VARCHAR2(75),
  sbxh             VARCHAR2(50),
  wtdbtsscqynsrsbh VARCHAR2(20),
  wtdbtsscqyshxydm VARCHAR2(20),
  ckbgdh           VARCHAR2(21),
  ckrq_1           DATE,
  cksp_dm          VARCHAR2(20),
  hgspmc           VARCHAR2(500),
  hgjldwmc         VARCHAR2(75),
  sbsp_dm          VARCHAR2(20),
  sbspmc           VARCHAR2(500),
  cksl             NUMBER(16,4),
  mylaj            NUMBER(18,2),
  dbtswspzhm       VARCHAR2(40),
  dbtsfpzs         NUMBER(10),
  kprq             DATE,
  jsje             NUMBER(18,2),
  zssl             NUMBER(16,6),
  tsl              NUMBER(16,6),
  tse              NUMBER(18,6),
  cktmsywlxdmjh    VARCHAR2(30),
  cktmsywlxmcjh    VARCHAR2(75),
  dbtsywlx_dm      VARCHAR2(20),
  dbtsywlxmc       VARCHAR2(75),
  bz               VARCHAR2(3000),
  tbrq_1           DATE,
  dlsbjbr          VARCHAR2(150),
  sqrmc            VARCHAR2(300),
  sqrq_1           DATE,
  tsswjg_dm_1      CHAR(11),
  lrr_dm           CHAR(11),
  lrrq             DATE,
  xgrq             DATE,
  xgr_dm           CHAR(11),
  sjgsdq           CHAR(11),
  sjtb_sj          TIMESTAMP(6),
  jbrxm            VARCHAR2(75),
  fpdm             VARCHAR2(12),
  fphm             VARCHAR2(8)
)
;
comment on table DZBA_SB_DB_TSSB
  is '外贸综合服务代办退税申报临时表';
comment on column DZBA_SB_DB_TSSB.sbid
  is 'sbid||sbid';
comment on column DZBA_SB_DB_TSSB.qyhgdm
  is '流程实例ID';
comment on column DZBA_SB_DB_TSSB.djxh
  is '登记序号';
comment on column DZBA_SB_DB_TSSB.ssq
  is '所属期';
comment on column DZBA_SB_DB_TSSB.sbpc
  is '申报批次';
comment on column DZBA_SB_DB_TSSB.sbxh
  is '申报序号';
comment on column DZBA_SB_DB_TSSB.wtdbtsscqynsrsbh
  is '委托代办退税生产企业纳税人识别号';
comment on column DZBA_SB_DB_TSSB.wtdbtsscqyshxydm
  is '委托代办退税生产企业社会信用代码';
comment on column DZBA_SB_DB_TSSB.ckbgdh
  is '出口报关单号';
comment on column DZBA_SB_DB_TSSB.ckrq_1
  is '出口日期';
comment on column DZBA_SB_DB_TSSB.cksp_dm
  is '出口商品代码';
comment on column DZBA_SB_DB_TSSB.hgspmc
  is '海关商品名称';
comment on column DZBA_SB_DB_TSSB.hgjldwmc
  is '海关计量单位名称';
comment on column DZBA_SB_DB_TSSB.sbsp_dm
  is '申报商品代码';
comment on column DZBA_SB_DB_TSSB.sbspmc
  is '申报商品名称';
comment on column DZBA_SB_DB_TSSB.cksl
  is '出口数量';
comment on column DZBA_SB_DB_TSSB.mylaj
  is '美元离岸价';
comment on column DZBA_SB_DB_TSSB.dbtswspzhm
  is '代办退税完税凭证号码';
comment on column DZBA_SB_DB_TSSB.dbtsfpzs
  is '代办退税发票（张数）';
comment on column DZBA_SB_DB_TSSB.kprq
  is '开票日期';
comment on column DZBA_SB_DB_TSSB.jsje
  is '计税金额';
comment on column DZBA_SB_DB_TSSB.zssl
  is '征税税率';
comment on column DZBA_SB_DB_TSSB.tsl
  is '退税率';
comment on column DZBA_SB_DB_TSSB.tse
  is '退税额';
comment on column DZBA_SB_DB_TSSB.cktmsywlxdmjh
  is '出口退（免）税业务类型代码集合';
comment on column DZBA_SB_DB_TSSB.cktmsywlxmcjh
  is '出口退（免）税业务类型名称集合';
comment on column DZBA_SB_DB_TSSB.dbtsywlx_dm
  is '代办退税业务类型代码';
comment on column DZBA_SB_DB_TSSB.dbtsywlxmc
  is '代办退税业务类型名称';
comment on column DZBA_SB_DB_TSSB.bz
  is '备注';
comment on column DZBA_SB_DB_TSSB.tbrq_1
  is '填表日期';
comment on column DZBA_SB_DB_TSSB.dlsbjbr
  is '代理申报经办人';
comment on column DZBA_SB_DB_TSSB.sqrmc
  is '授权人名称';
comment on column DZBA_SB_DB_TSSB.sqrq_1
  is '授权日期';
comment on column DZBA_SB_DB_TSSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column DZBA_SB_DB_TSSB.lrr_dm
  is '录入人代码';
comment on column DZBA_SB_DB_TSSB.lrrq
  is '录入日期';
comment on column DZBA_SB_DB_TSSB.xgrq
  is '修改日期';
comment on column DZBA_SB_DB_TSSB.xgr_dm
  is '修改人代码';
comment on column DZBA_SB_DB_TSSB.sjgsdq
  is '数据归属地区';
comment on column DZBA_SB_DB_TSSB.sjtb_sj
  is '数据同步时间';
comment on column DZBA_SB_DB_TSSB.jbrxm
  is '经办人姓名';
comment on column DZBA_SB_DB_TSSB.fpdm
  is '增值税发票代码（信息比对的时候通过DBTSWSPZHM分解）';
comment on column DZBA_SB_DB_TSSB.fphm
  is '增值税发票号码（信息比对的时候通过DBTSWSPZHM分解）';
create index IDX_DZBA_SB_DB_TSSB_1 on DZBA_SB_DB_TSSB (SBID);
create index IDX_DZBA_SB_DB_TSSB_2 on DZBA_SB_DB_TSSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table DZBA_SB_MDT_TSSB
prompt ===============================
prompt
create table DZBA_SB_MDT_TSSB
(
  sbid             NUMBER(18),
  qyhgdm           VARCHAR2(20),
  djxh             NUMBER(20),
  ssq              VARCHAR2(60),
  sbpc             VARCHAR2(75),
  sbxh             VARCHAR2(50),
  ckfph            VARCHAR2(30),
  ckbgdh           VARCHAR2(21),
  ckrq_1           DATE,
  dlckhwzmhm       VARCHAR2(20),
  cksp_dm          VARCHAR2(20),
  hgjldwmc         VARCHAR2(75),
  cksl             NUMBER(16,4),
  mylaj            NUMBER(18,2),
  rmblaj           NUMBER(18,2),
  zssl             NUMBER(16,6),
  tsl              NUMBER(16,6),
  tzhjhfpl         NUMBER(10,6),
  jljgbsjkljzcjsjg NUMBER(18,2),
  gngjmsycljg      NUMBER(18,2),
  mdtsbdmzhdkse    NUMBER(18,6),
  mdtse            NUMBER(18,6),
  jljgszch         VARCHAR2(20),
  cktmsywlxdmjh    VARCHAR2(30),
  cktmsywlxmcjh    VARCHAR2(75),
  ckhth            VARCHAR2(60),
  bz               VARCHAR2(3000),
  cjhbzm_dm        CHAR(3),
  cjzj             NUMBER(18,2),
  cjhbhl           NUMBER(16,6),
  myhl             NUMBER(16,6),
  mdtsny           CHAR(6),
  lrr_dm           CHAR(11),
  lrrq             DATE,
  xgr_dm           CHAR(11),
  xgrq             DATE,
  tsswjg_dm_1      CHAR(11),
  sjgsdq           CHAR(11),
  sjtb_sj          TIMESTAMP(6),
  sbhgspmc         VARCHAR2(500),
  zbblny           VARCHAR2(6),
  sbsp_dm          VARCHAR2(20),
  sbspmc           VARCHAR2(500)
)
;
comment on table DZBA_SB_MDT_TSSB
  is '生产企业出口货物免抵退税申报明细(临时表)';
comment on column DZBA_SB_MDT_TSSB.sbid
  is 'sbid||sbid';
comment on column DZBA_SB_MDT_TSSB.qyhgdm
  is '流程实例ID';
comment on column DZBA_SB_MDT_TSSB.djxh
  is '登记序号';
comment on column DZBA_SB_MDT_TSSB.ssq
  is '所属期';
comment on column DZBA_SB_MDT_TSSB.sbxh
  is '申报序号';
comment on column DZBA_SB_MDT_TSSB.ckfph
  is '出口发票号';
comment on column DZBA_SB_MDT_TSSB.ckbgdh
  is '出口报关单号';
comment on column DZBA_SB_MDT_TSSB.ckrq_1
  is '出口日期';
comment on column DZBA_SB_MDT_TSSB.dlckhwzmhm
  is '代理出口货物证明号码';
comment on column DZBA_SB_MDT_TSSB.cksp_dm
  is '出口商品代码';
comment on column DZBA_SB_MDT_TSSB.hgjldwmc
  is '海关计量单位名称';
comment on column DZBA_SB_MDT_TSSB.cksl
  is '出口数量';
comment on column DZBA_SB_MDT_TSSB.mylaj
  is '美元离岸价';
comment on column DZBA_SB_MDT_TSSB.rmblaj
  is '人民币离岸价';
comment on column DZBA_SB_MDT_TSSB.zssl
  is '征税税率';
comment on column DZBA_SB_MDT_TSSB.tsl
  is '退税率';
comment on column DZBA_SB_MDT_TSSB.tzhjhfpl
  is '调整后计划分配率';
comment on column DZBA_SB_MDT_TSSB.jljgbsjkljzcjsjg
  is '进料加工保税进口料件组成计税价格';
comment on column DZBA_SB_MDT_TSSB.gngjmsycljg
  is '国内购进免税原材料价格';
comment on column DZBA_SB_MDT_TSSB.mdtsbdmzhdkse
  is '免抵退税不得免征和抵扣税额';
comment on column DZBA_SB_MDT_TSSB.mdtse
  is '免抵退税额';
comment on column DZBA_SB_MDT_TSSB.jljgszch
  is '进料加工手（账）册号';
comment on column DZBA_SB_MDT_TSSB.cktmsywlxdmjh
  is '出口退（免）税业务类型代码集合';
comment on column DZBA_SB_MDT_TSSB.cktmsywlxmcjh
  is '出口退（免）税业务类型名称集合';
comment on column DZBA_SB_MDT_TSSB.ckhth
  is '出口合同号';
comment on column DZBA_SB_MDT_TSSB.bz
  is '备注';
comment on column DZBA_SB_MDT_TSSB.cjhbzm_dm
  is '成交货币字母代码';
comment on column DZBA_SB_MDT_TSSB.cjzj
  is '成交总价||成交总价';
comment on column DZBA_SB_MDT_TSSB.cjhbhl
  is '成交货币汇率';
comment on column DZBA_SB_MDT_TSSB.myhl
  is '美元汇率';
comment on column DZBA_SB_MDT_TSSB.mdtsny
  is '免抵退税年月';
comment on column DZBA_SB_MDT_TSSB.lrr_dm
  is '录入人代码';
comment on column DZBA_SB_MDT_TSSB.lrrq
  is '录入日期';
comment on column DZBA_SB_MDT_TSSB.xgr_dm
  is '修改人代码';
comment on column DZBA_SB_MDT_TSSB.xgrq
  is '修改日期';
comment on column DZBA_SB_MDT_TSSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column DZBA_SB_MDT_TSSB.sjgsdq
  is '数据归属地区';
comment on column DZBA_SB_MDT_TSSB.sjtb_sj
  is '数据同步时间';
comment on column DZBA_SB_MDT_TSSB.sbhgspmc
  is '申报海关商品名称||申报海关商品名称';
comment on column DZBA_SB_MDT_TSSB.zbblny
  is '暂不办理年月';
comment on column DZBA_SB_MDT_TSSB.sbsp_dm
  is '申报商品代码';
comment on column DZBA_SB_MDT_TSSB.sbspmc
  is '申报商品名称';
create index IDX_DZBA_SB_MDT_TSSB_1 on DZBA_SB_MDT_TSSB (SBID);
create index IDX_DZBA_SB_MDT_TSSB_2 on DZBA_SB_MDT_TSSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table DZBA_SB_MTS_TSJH
prompt ===============================
prompt
create table DZBA_SB_MTS_TSJH
(
  sbid          NUMBER(18),
  qyhgdm        VARCHAR2(20),
  djxh          NUMBER(20),
  sbpc          VARCHAR2(75),
  sbxh          VARCHAR2(50),
  glh           VARCHAR2(30),
  sz            CHAR(1),
  jhpzh         VARCHAR2(75),
  zysph         VARCHAR2(30),
  kprq          DATE,
  cksp_dm       VARCHAR2(20),
  sbhgspmc      VARCHAR2(500),
  hgjldwmc      VARCHAR2(75),
  sl            NUMBER(16,4),
  jsje          NUMBER(18,2),
  zssl          NUMBER(16,6),
  zsse          NUMBER(18,6),
  tsl           NUMBER(16,6),
  tse           NUMBER(18,6),
  cktmsywlxdmjh VARCHAR2(30),
  cktmsywlxmcjh VARCHAR2(75),
  bz            VARCHAR2(3000),
  tbrq_1        DATE,
  tsswjg_dm_1   CHAR(11),
  lrr_dm        CHAR(11),
  lrrq          DATE,
  xgrq          DATE,
  xgr_dm        CHAR(11),
  sjgsdq        CHAR(11),
  sjtb_sj       TIMESTAMP(6),
  ssq           VARCHAR2(60),
  ghfnsrsbh_1   VARCHAR2(20),
  cktmspzlx_dm  CHAR(2),
  fpdm          VARCHAR2(12),
  fphm          VARCHAR2(8),
  ckrq_1        DATE
)
;
create index IDX_DZBA_SB_MTS_MTS_TSJH_1 on DZBA_SB_MTS_TSJH (SBID);
create index IDX_DZBA_SB_MTS_MTS_TSJH_2 on DZBA_SB_MTS_TSJH (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table DZBA_SB_MTS_TSSB
prompt ===============================
prompt
create table DZBA_SB_MTS_TSSB
(
  sbid          NUMBER(18),
  qyhgdm        VARCHAR2(20),
  djxh          NUMBER(20),
  sbpc          VARCHAR2(75),
  sbxh          VARCHAR2(50),
  glh           VARCHAR2(30),
  ckbgdh        VARCHAR2(21),
  dlzmh         VARCHAR2(30),
  ckrq_1        DATE,
  ckshhxdh      VARCHAR2(30),
  cksp_dm       VARCHAR2(20),
  sbhgspmc      VARCHAR2(500),
  hgjldwmc      VARCHAR2(75),
  cksl          NUMBER(16,4),
  mylaj         NUMBER(18,2),
  ckjhje        NUMBER(18,2),
  sbsp_dm       VARCHAR2(20),
  sbspmc        VARCHAR2(500),
  tsl           NUMBER(16,6),
  zzstse        NUMBER(18,6),
  xfstse        NUMBER(18,6),
  dzbqbz        CHAR(1),
  cktmsywlxdmjh VARCHAR2(30),
  cktmsywlxmcjh VARCHAR2(75),
  bz            VARCHAR2(3000),
  tbrq_1        DATE,
  stssl         NUMBER(16,4),
  pjdj          NUMBER(18,2),
  rmblaj        NUMBER(18,2),
  mygdqsz_dm    CHAR(3),
  tsswjg_dm_1   CHAR(11),
  lrr_dm        CHAR(11),
  lrrq          DATE,
  xgrq          DATE,
  xgr_dm        CHAR(11),
  sjgsdq        CHAR(11),
  sjtb_sj       TIMESTAMP(6),
  ssq           VARCHAR2(60),
  jjhwbaqdh     VARCHAR2(30),
  ckfph         VARCHAR2(30)
)
;
comment on table DZBA_SB_MTS_TSSB
  is '外贸企业出口退税出口明细申报临时表';
comment on column DZBA_SB_MTS_TSSB.sbid
  is 'sbid||sbid';
comment on column DZBA_SB_MTS_TSSB.qyhgdm
  is '流程实例ID';
comment on column DZBA_SB_MTS_TSSB.djxh
  is '登记序号';
comment on column DZBA_SB_MTS_TSSB.sbpc
  is '申报批次';
comment on column DZBA_SB_MTS_TSSB.sbxh
  is '申报序号';
comment on column DZBA_SB_MTS_TSSB.glh
  is '关联号';
comment on column DZBA_SB_MTS_TSSB.ckbgdh
  is '出口报关单号';
comment on column DZBA_SB_MTS_TSSB.dlzmh
  is '代理证明号';
comment on column DZBA_SB_MTS_TSSB.ckrq_1
  is '出口日期';
comment on column DZBA_SB_MTS_TSSB.ckshhxdh
  is '出口收汇核销单号';
comment on column DZBA_SB_MTS_TSSB.cksp_dm
  is '出口商品代码';
comment on column DZBA_SB_MTS_TSSB.sbhgspmc
  is '申报海关商品名称||申报海关商品名称';
comment on column DZBA_SB_MTS_TSSB.hgjldwmc
  is '海关计量单位名称';
comment on column DZBA_SB_MTS_TSSB.cksl
  is '出口数量';
comment on column DZBA_SB_MTS_TSSB.mylaj
  is '美元离岸价';
comment on column DZBA_SB_MTS_TSSB.ckjhje
  is '出口进货金额';
comment on column DZBA_SB_MTS_TSSB.sbsp_dm
  is '申报商品代码';
comment on column DZBA_SB_MTS_TSSB.sbspmc
  is '申报商品名称';
comment on column DZBA_SB_MTS_TSSB.tsl
  is '退税率';
comment on column DZBA_SB_MTS_TSSB.zzstse
  is '增值税退税额';
comment on column DZBA_SB_MTS_TSSB.xfstse
  is '消费税退税额';
comment on column DZBA_SB_MTS_TSSB.dzbqbz
  is '单证不齐标志';
comment on column DZBA_SB_MTS_TSSB.cktmsywlxdmjh
  is '出口退（免）税业务类型代码集合';
comment on column DZBA_SB_MTS_TSSB.cktmsywlxmcjh
  is '出口退（免）税业务类型名称集合';
comment on column DZBA_SB_MTS_TSSB.bz
  is '备注';
comment on column DZBA_SB_MTS_TSSB.tbrq_1
  is '填表日期';
comment on column DZBA_SB_MTS_TSSB.stssl
  is '实退税数量';
comment on column DZBA_SB_MTS_TSSB.pjdj
  is '平均单价';
comment on column DZBA_SB_MTS_TSSB.rmblaj
  is '人民币离岸价';
comment on column DZBA_SB_MTS_TSSB.mygdqsz_dm
  is '贸易国（地区）数字代码';
comment on column DZBA_SB_MTS_TSSB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column DZBA_SB_MTS_TSSB.lrr_dm
  is '录入人代码';
comment on column DZBA_SB_MTS_TSSB.lrrq
  is '录入日期';
comment on column DZBA_SB_MTS_TSSB.xgrq
  is '修改日期';
comment on column DZBA_SB_MTS_TSSB.xgr_dm
  is '修改人代码';
comment on column DZBA_SB_MTS_TSSB.sjgsdq
  is '数据归属地区';
comment on column DZBA_SB_MTS_TSSB.sjtb_sj
  is '数据同步时间';
comment on column DZBA_SB_MTS_TSSB.ssq
  is '所属期';
comment on column DZBA_SB_MTS_TSSB.jjhwbaqdh
  is '进境货物备案清单号';
comment on column DZBA_SB_MTS_TSSB.ckfph
  is '出口发票号';
create index IDX_DZBA_SB_MTS_TSSB_1 on DZBA_SB_MTS_TSSB (SBID);
create index IDX_DZBA_SB_MTS_TSSB_2 on DZBA_SB_MTS_TSSB (QYHGDM, SSQ, SBPC);

prompt
prompt Creating table ETL_LOG_JOB
prompt ==========================
prompt
create table ETL_LOG_JOB
(
  id_job         INTEGER,
  channel_id     VARCHAR2(255),
  jobname        VARCHAR2(255),
  status         VARCHAR2(15),
  lines_read     INTEGER,
  lines_written  INTEGER,
  lines_updated  INTEGER,
  lines_input    INTEGER,
  lines_output   INTEGER,
  lines_rejected INTEGER,
  errors         INTEGER,
  startdate      DATE,
  enddate        DATE,
  logdate        DATE,
  depdate        DATE,
  replaydate     DATE,
  log_field      CLOB
)
;
create index IDX_ETL_LOG_JOB_1 on ETL_LOG_JOB (ID_JOB);
create index IDX_ETL_LOG_JOB_2 on ETL_LOG_JOB (ERRORS, STATUS, JOBNAME);

prompt
prompt Creating table ETL_LOG_RUN
prompt ==========================
prompt
create table ETL_LOG_RUN
(
  id_batch           INTEGER,
  seq_nr             INTEGER,
  logdate            DATE,
  transname          VARCHAR2(255),
  stepname           VARCHAR2(255),
  step_copy          INTEGER,
  lines_read         INTEGER,
  lines_written      INTEGER,
  lines_updated      INTEGER,
  lines_input        INTEGER,
  lines_output       INTEGER,
  lines_rejected     INTEGER,
  errors             INTEGER,
  input_buffer_rows  INTEGER,
  output_buffer_rows INTEGER
)
;

prompt
prompt Creating table ETL_LOG_STEP
prompt ===========================
prompt
create table ETL_LOG_STEP
(
  id_batch       INTEGER,
  channel_id     VARCHAR2(255),
  transname      VARCHAR2(255),
  stepname       VARCHAR2(255),
  step_copy      INTEGER,
  lines_read     INTEGER,
  lines_written  INTEGER,
  lines_updated  INTEGER,
  lines_input    INTEGER,
  lines_output   INTEGER,
  lines_rejected INTEGER,
  errors         INTEGER,
  log_date_ktl   DATE,
  log_date       DATE
)
;

prompt
prompt Creating table ETL_LOG_TRANS
prompt ============================
prompt
create table ETL_LOG_TRANS
(
  id_batch       INTEGER,
  channel_id     VARCHAR2(255),
  transname      VARCHAR2(255),
  status         VARCHAR2(15),
  lines_read     INTEGER,
  lines_written  INTEGER,
  lines_updated  INTEGER,
  lines_input    INTEGER,
  lines_output   INTEGER,
  lines_rejected INTEGER,
  errors         INTEGER,
  log_field      CLOB,
  startdate_ktl  DATE,
  enddate_ktl    DATE,
  logdate_ktl    DATE,
  depdate_ktl    DATE,
  replaydate_ktl DATE,
  startdate      DATE,
  enddate        DATE,
  logdate        DATE,
  depdate        DATE,
  replaydate     DATE
)
;
create index IDX_ETL_LOG_TRANS_1 on ETL_LOG_TRANS (ID_BATCH);
create index IDX_ETL_LOG_TRANS_2 on ETL_LOG_TRANS (ERRORS, STATUS, TRANSNAME);

prompt
prompt Creating table FK_TX_WSBBGD
prompt ===========================
prompt
create table FK_TX_WSBBGD
(
  cpcode  VARCHAR2(32) default ' ' not null,
  bgd_no  VARCHAR2(21) default ' ' not null,
  lj_date DATE default TO_DATE('1900-01-01','YYYY-MM-DD'),
  cmcode  VARCHAR2(12) default ' ',
  tdcode  VARCHAR2(4) default ' ',
  rmb_amt NUMBER(15,2) default (0),
  usd_amt NUMBER(15,2) default (0),
  swcode  VARCHAR2(11) default ' ',
  qydm    VARCHAR2(18) default ' ',
  ba_no   VARCHAR2(12) default ' ',
  memo    VARCHAR2(100) default ' '
)
;

prompt
prompt Creating table GS_DJ_CKTMSDAB
prompt =============================
prompt
create table GS_DJ_CKTMSDAB
(
  tbpc           NUMBER(18),
  nsrdzdah       NUMBER(20) not null,
  nsrmc          VARCHAR2(400),
  nsrmcyw        VARCHAR2(75),
  qyhgdm         VARCHAR2(32),
  nsrdh          VARCHAR2(60),
  nsrcz          VARCHAR2(16),
  nsryb          VARCHAR2(6),
  nsryx          VARCHAR2(90),
  zcdz           VARCHAR2(300),
  scjydz         VARCHAR2(300),
  nsrsbh         VARCHAR2(32),
  nsrlx_dm       CHAR(1),
  swjg_dm        VARCHAR2(11),
  nsrxydj_dm     VARCHAR2(20),
  djzclx_dm      VARCHAR2(200),
  hy_dm          VARCHAR2(4),
  lsgx_dm        VARCHAR2(2),
  jyzlx_dm       VARCHAR2(1),
  badjbbh        VARCHAR2(30),
  sfysfw         VARCHAR2(1),
  ysfw           VARCHAR2(30),
  ysfs           VARCHAR2(50),
  yfsj           VARCHAR2(50),
  gsdjzzh        VARCHAR2(50),
  gskyrq         DATE,
  gsyxqz         DATE,
  gsdjyxq        NUMBER(2),
  gszczb         VARCHAR2(20),
  fddbrmc        VARCHAR2(150),
  frzjhm         VARCHAR2(30),
  frdhhm         VARCHAR2(60),
  yhmc           VARCHAR2(400),
  yhzh           VARCHAR2(60),
  bsy1_mc        VARCHAR2(150),
  bsy1_id        VARCHAR2(30),
  bsy1_dh        VARCHAR2(60),
  bsy2_mc        VARCHAR2(150),
  bsy2_id        VARCHAR2(30),
  bsy2_dh        VARCHAR2(60),
  zzsyhzc        VARCHAR2(30),
  zgwhj          VARCHAR2(30),
  fszl           VARCHAR2(500),
  tsjsfs_dm      CHAR(1),
  sbfs_mc_zzbz   VARCHAR2(20),
  sbfs_mc_sjdw   VARCHAR2(20),
  sffbhs         CHAR(1),
  fbhsdm         VARCHAR2(100),
  qylx_dm        VARCHAR2(10),
  cpcode         VARCHAR2(32),
  nsrdjno        VARCHAR2(32),
  shxyno         VARCHAR2(20),
  zs_swjg_dm     VARCHAR2(11),
  zx_flag        VARCHAR2(1),
  tsgllx_dm      VARCHAR2(200),
  jdxzmc         VARCHAR2(50),
  tag            VARCHAR2(30),
  tbbz           NUMBER(8) default 0,
  zgswskfj_dm    VARCHAR2(11),
  jdxz_dm        VARCHAR2(9),
  readin_date    DATE,
  wmzhfwqybz     CHAR(1),
  scsbrq         DATE,
  ztxthhbz       CHAR(1),
  yhzhtgbz       CHAR(1),
  zsqybbsrbz     CHAR(1),
  cpcodetssh     VARCHAR2(32),
  xgrq           DATE,
  cwfzrxm        VARCHAR2(150),
  cwfzrsfzjhm    VARCHAR2(30),
  cwfzrgddh      VARCHAR2(60),
  cwfzryddh      VARCHAR2(60),
  bsrxm          VARCHAR2(150),
  bsrsfzjhm      VARCHAR2(30),
  bsrgddh        VARCHAR2(60),
  bsryddh        VARCHAR2(60),
  djrq           DATE,
  scckrq         DATE,
  barq           DATE,
  fddbr_cgbl     NUMBER(18,6) default 0,
  note           VARCHAR2(10),
  fddbrsfzjlx_dm CHAR(3),
  ybnsrrdsjq     DATE,
  first_sb_ym    VARCHAR2(6),
  nsrzt_dm       CHAR(2),
  zx_date        DATE,
  zgswj_dm       CHAR(11)
)
;
comment on table GS_DJ_CKTMSDAB
  is '登记出口退税档案表';
comment on column GS_DJ_CKTMSDAB.tbpc
  is '同步批次';
comment on column GS_DJ_CKTMSDAB.nsrdzdah
  is '纳税人电子档案号';
comment on column GS_DJ_CKTMSDAB.nsrmc
  is '纳税人名称';
comment on column GS_DJ_CKTMSDAB.nsrmcyw
  is '纳税人英文名称';
comment on column GS_DJ_CKTMSDAB.qyhgdm
  is '企业海关代码';
comment on column GS_DJ_CKTMSDAB.nsrdh
  is '纳税人电话';
comment on column GS_DJ_CKTMSDAB.nsrcz
  is '纳税人传真';
comment on column GS_DJ_CKTMSDAB.nsryb
  is '纳税人邮编';
comment on column GS_DJ_CKTMSDAB.nsryx
  is '纳税人电子信箱';
comment on column GS_DJ_CKTMSDAB.zcdz
  is '注册地址';
comment on column GS_DJ_CKTMSDAB.scjydz
  is '生产经营地址';
comment on column GS_DJ_CKTMSDAB.nsrsbh
  is '纳税人识别号';
comment on column GS_DJ_CKTMSDAB.nsrlx_dm
  is '纳税人类型代码';
comment on column GS_DJ_CKTMSDAB.swjg_dm
  is '税务机关代码
';
comment on column GS_DJ_CKTMSDAB.nsrxydj_dm
  is '纳税人信用等级';
comment on column GS_DJ_CKTMSDAB.djzclx_dm
  is '登记注册类型代码';
comment on column GS_DJ_CKTMSDAB.hy_dm
  is '行业代码';
comment on column GS_DJ_CKTMSDAB.lsgx_dm
  is '隶属关系代码';
comment on column GS_DJ_CKTMSDAB.jyzlx_dm
  is '经营者类型代码';
comment on column GS_DJ_CKTMSDAB.badjbbh
  is '外贸 备案登记表编号';
comment on column GS_DJ_CKTMSDAB.sfysfw
  is '是否应税服务
';
comment on column GS_DJ_CKTMSDAB.ysfw
  is '应税服务代码集，用半角逗号隔开
';
comment on column GS_DJ_CKTMSDAB.ysfs
  is '运输方式代码集，用半角逗号隔开
';
comment on column GS_DJ_CKTMSDAB.yfsj
  is '研发设计代码集，用半角逗号隔开
';
comment on column GS_DJ_CKTMSDAB.gsdjzzh
  is '工商登记证号';
comment on column GS_DJ_CKTMSDAB.gskyrq
  is '工商开业日期';
comment on column GS_DJ_CKTMSDAB.gsyxqz
  is '工商有效期止';
comment on column GS_DJ_CKTMSDAB.gsdjyxq
  is '工商登记有效期';
comment on column GS_DJ_CKTMSDAB.gszczb
  is '工商注册资本';
comment on column GS_DJ_CKTMSDAB.fddbrmc
  is '法人代表名称
';
comment on column GS_DJ_CKTMSDAB.frzjhm
  is '法人证件号码';
comment on column GS_DJ_CKTMSDAB.frdhhm
  is '法人电话号码';
comment on column GS_DJ_CKTMSDAB.yhmc
  is '开户银行名称';
comment on column GS_DJ_CKTMSDAB.yhzh
  is '开户银行账号';
comment on column GS_DJ_CKTMSDAB.bsy1_mc
  is '办税员名称
';
comment on column GS_DJ_CKTMSDAB.bsy1_id
  is '办税员身份证';
comment on column GS_DJ_CKTMSDAB.bsy1_dh
  is '办税员电话';
comment on column GS_DJ_CKTMSDAB.bsy2_mc
  is '办税员名称
';
comment on column GS_DJ_CKTMSDAB.bsy2_id
  is '办税员身份证';
comment on column GS_DJ_CKTMSDAB.bsy2_dh
  is '办税员电话';
comment on column GS_DJ_CKTMSDAB.zzsyhzc
  is '增值税优惠政策代码集，用半角逗号隔开
';
comment on column GS_DJ_CKTMSDAB.zgwhj
  is '主管外汇局';
comment on column GS_DJ_CKTMSDAB.fszl
  is '附送资料';
comment on column GS_DJ_CKTMSDAB.tsjsfs_dm
  is '退税计算方式代码';
comment on column GS_DJ_CKTMSDAB.sbfs_mc_zzbz
  is '纸质凭证申报方式';
comment on column GS_DJ_CKTMSDAB.sbfs_mc_sjdw
  is '纸质凭证电文方式';
comment on column GS_DJ_CKTMSDAB.sffbhs
  is '是否分部核算
';
comment on column GS_DJ_CKTMSDAB.fbhsdm
  is '分部核算部门代码
';
comment on column GS_DJ_CKTMSDAB.qylx_dm
  is '企业类型代码
';
comment on column GS_DJ_CKTMSDAB.cpcode
  is '核心征管系统TO_CHAR(DJXH)';
comment on column GS_DJ_CKTMSDAB.nsrdjno
  is '纳税人识别号';
comment on column GS_DJ_CKTMSDAB.shxyno
  is '社会信用代码';
comment on column GS_DJ_CKTMSDAB.zs_swjg_dm
  is '征收税务机关-审核助手用';
comment on column GS_DJ_CKTMSDAB.zx_flag
  is '注销标志 R 注销';
comment on column GS_DJ_CKTMSDAB.tsgllx_dm
  is '退税管理类型代码';
comment on column GS_DJ_CKTMSDAB.jdxzmc
  is '乡镇街道名称';
comment on column GS_DJ_CKTMSDAB.tbbz
  is '同步标志';
comment on column GS_DJ_CKTMSDAB.zgswskfj_dm
  is '主管税务所（科、分局）代码';
comment on column GS_DJ_CKTMSDAB.jdxz_dm
  is '街道乡镇代码';
comment on column GS_DJ_CKTMSDAB.wmzhfwqybz
  is '外贸综合服务企业标志（35号公告）';
comment on column GS_DJ_CKTMSDAB.scsbrq
  is '企业首次申报退（免）税时间（从HX_CKTS.CKTS_TY_SCSBQK同步）';
comment on column GS_DJ_CKTMSDAB.ztxthhbz
  is '暂停先退后核标志（从HX_CKTS.CKTS_BA_PZXX_JGB同步）';
comment on column GS_DJ_CKTMSDAB.yhzhtgbz
  is '银行账号托管标志';
comment on column GS_DJ_CKTMSDAB.zsqybbsrbz
  is '综税区试点一般纳税人标志';
comment on column GS_DJ_CKTMSDAB.cpcodetssh
  is '老审核系统CPCODE';
comment on column GS_DJ_CKTMSDAB.xgrq
  is '修改日期NVL(T.XGRQ,T.LRRQ)-增量用';
comment on column GS_DJ_CKTMSDAB.scckrq
  is '首次出口日期';
comment on column GS_DJ_CKTMSDAB.barq
  is '备案日期';
comment on column GS_DJ_CKTMSDAB.fddbr_cgbl
  is '法定代表人持股比例,%';
comment on column GS_DJ_CKTMSDAB.note
  is '备注';
comment on column GS_DJ_CKTMSDAB.fddbrsfzjlx_dm
  is '法人证件类型-NEW';
comment on column GS_DJ_CKTMSDAB.ybnsrrdsjq
  is '一般纳税人认定日期-NEW';
comment on column GS_DJ_CKTMSDAB.first_sb_ym
  is '首次申报年月-NEW';
comment on column GS_DJ_CKTMSDAB.nsrzt_dm
  is '纳税人状态-NEW';
comment on column GS_DJ_CKTMSDAB.zx_date
  is '备案撤回日期-NEW';
comment on column GS_DJ_CKTMSDAB.zgswj_dm
  is '征管税务机关代码-NEW';
create index IDX_GS_DJ_CKTMSDAB_CPCODE on GS_DJ_CKTMSDAB (CPCODE);
create index IDX_GS_DJ_CKTMSDAB_CPTSSH on GS_DJ_CKTMSDAB (CPCODETSSH);
create index IDX_GS_DJ_CKTMSDAB_CZFZR on GS_DJ_CKTMSDAB (CWFZRSFZJHM);
create index IDX_GS_DJ_CKTMSDAB_FRZJHM on GS_DJ_CKTMSDAB (FRZJHM);
create unique index IDX_GS_DJ_CKTMSDAB_NSRSBH on GS_DJ_CKTMSDAB (NSRSBH);
create index IDX_GS_DJ_CKTMSDAB_QYHGDM on GS_DJ_CKTMSDAB (QYHGDM);
create index IDX_GS_DJ_CKTMSDAB_SWJG on GS_DJ_CKTMSDAB (SWJG_DM);
create index IDX_GS_DJ_CKTMSDAB_TBPC on GS_DJ_CKTMSDAB (TBPC);
alter table GS_DJ_CKTMSDAB
  add constraint PK_GS_DJ_CKTMSDAB primary key (NSRDZDAH);

prompt
prompt Creating table GS_DJ_CKTMSDAB_BAK
prompt =================================
prompt
create table GS_DJ_CKTMSDAB_BAK
(
  tbpc         NUMBER(18),
  nsrdzdah     NUMBER(20) not null,
  nsrmc        VARCHAR2(400),
  nsrmcyw      VARCHAR2(75),
  qyhgdm       VARCHAR2(32),
  nsrdh        VARCHAR2(60),
  nsrcz        VARCHAR2(16),
  nsryb        VARCHAR2(6),
  nsryx        VARCHAR2(90),
  zcdz         VARCHAR2(300),
  scjydz       VARCHAR2(300),
  nsrsbh       VARCHAR2(32),
  nsrlx_dm     CHAR(1),
  swjg_dm      VARCHAR2(11),
  nsrxydj_dm   VARCHAR2(20),
  djzclx_dm    VARCHAR2(200),
  hy_dm        VARCHAR2(4),
  lsgx_dm      VARCHAR2(2),
  jyzlx_dm     VARCHAR2(1),
  badjbbh      VARCHAR2(30),
  sfysfw       VARCHAR2(1),
  ysfw         VARCHAR2(30),
  ysfs         VARCHAR2(50),
  yfsj         VARCHAR2(50),
  gsdjzzh      VARCHAR2(50),
  gskyrq       DATE,
  gsyxqz       DATE,
  gsdjyxq      NUMBER(2),
  gszczb       VARCHAR2(20),
  fddbrmc      VARCHAR2(150),
  frzjhm       VARCHAR2(30),
  frdhhm       VARCHAR2(60),
  yhmc         VARCHAR2(80),
  yhzh         VARCHAR2(60),
  bsy1_mc      VARCHAR2(30),
  bsy1_id      VARCHAR2(20),
  bsy1_dh      VARCHAR2(20),
  bsy2_mc      VARCHAR2(30),
  bsy2_id      VARCHAR2(20),
  bsy2_dh      VARCHAR2(20),
  zzsyhzc      VARCHAR2(30),
  zgwhj        VARCHAR2(30),
  fszl         VARCHAR2(240),
  tsjsfs_dm    CHAR(1),
  sbfs_mc_zzbz VARCHAR2(20),
  sbfs_mc_sjdw VARCHAR2(20),
  sffbhs       CHAR(1),
  fbhsdm       VARCHAR2(100),
  qylx_dm      VARCHAR2(10),
  cpcode       VARCHAR2(32),
  nsrdjno      VARCHAR2(32),
  shxyno       VARCHAR2(20),
  zs_swjg_dm   VARCHAR2(11),
  zx_flag      VARCHAR2(1),
  tsgllx_dm    VARCHAR2(200),
  jdxzmc       VARCHAR2(50),
  tag          VARCHAR2(30),
  tbbz         NUMBER(8) default 0,
  zgswskfj_dm  VARCHAR2(11),
  jdxz_dm      VARCHAR2(9),
  readin_date  DATE,
  wmzhfwqybz   CHAR(1),
  scsbrq       DATE,
  ztxthhbz     CHAR(1),
  yhzhtgbz     CHAR(1),
  zsqybbsrbz   CHAR(1),
  cpcodetssh   VARCHAR2(32)
)
;
comment on table GS_DJ_CKTMSDAB_BAK
  is '登记出口退税档案表';
comment on column GS_DJ_CKTMSDAB_BAK.tbpc
  is '同步批次';
comment on column GS_DJ_CKTMSDAB_BAK.nsrdzdah
  is '纳税人电子档案号';
comment on column GS_DJ_CKTMSDAB_BAK.nsrmc
  is '纳税人名称';
comment on column GS_DJ_CKTMSDAB_BAK.nsrmcyw
  is '纳税人英文名称';
comment on column GS_DJ_CKTMSDAB_BAK.qyhgdm
  is '企业海关代码';
comment on column GS_DJ_CKTMSDAB_BAK.nsrdh
  is '纳税人电话';
comment on column GS_DJ_CKTMSDAB_BAK.nsrcz
  is '纳税人传真';
comment on column GS_DJ_CKTMSDAB_BAK.nsryb
  is '纳税人邮编';
comment on column GS_DJ_CKTMSDAB_BAK.nsryx
  is '纳税人电子信箱';
comment on column GS_DJ_CKTMSDAB_BAK.zcdz
  is '注册地址';
comment on column GS_DJ_CKTMSDAB_BAK.scjydz
  is '生产经营地址';
comment on column GS_DJ_CKTMSDAB_BAK.nsrsbh
  is '纳税人识别号';
comment on column GS_DJ_CKTMSDAB_BAK.nsrlx_dm
  is '纳税人类型代码';
comment on column GS_DJ_CKTMSDAB_BAK.swjg_dm
  is '税务机关代码
';
comment on column GS_DJ_CKTMSDAB_BAK.nsrxydj_dm
  is '纳税人信用等级';
comment on column GS_DJ_CKTMSDAB_BAK.djzclx_dm
  is '登记注册类型代码';
comment on column GS_DJ_CKTMSDAB_BAK.hy_dm
  is '行业代码';
comment on column GS_DJ_CKTMSDAB_BAK.lsgx_dm
  is '隶属关系代码';
comment on column GS_DJ_CKTMSDAB_BAK.jyzlx_dm
  is '经营者类型代码';
comment on column GS_DJ_CKTMSDAB_BAK.badjbbh
  is '外贸 备案登记表编号';
comment on column GS_DJ_CKTMSDAB_BAK.sfysfw
  is '是否应税服务
';
comment on column GS_DJ_CKTMSDAB_BAK.ysfw
  is '应税服务代码集，用半角逗号隔开
';
comment on column GS_DJ_CKTMSDAB_BAK.ysfs
  is '运输方式代码集，用半角逗号隔开
';
comment on column GS_DJ_CKTMSDAB_BAK.yfsj
  is '研
发设计代码集，用半角逗号隔开
';
comment on column GS_DJ_CKTMSDAB_BAK.gsdjzzh
  is '工商登记证号';
comment on column GS_DJ_CKTMSDAB_BAK.gskyrq
  is '工商开业日期';
comment on column GS_DJ_CKTMSDAB_BAK.gsyxqz
  is '工商有效期止';
comment on column GS_DJ_CKTMSDAB_BAK.gsdjyxq
  is '工商登记有效期';
comment on column GS_DJ_CKTMSDAB_BAK.gszczb
  is '工商注册资本';
comment on column GS_DJ_CKTMSDAB_BAK.fddbrmc
  is '法人代表名称
';
comment on column GS_DJ_CKTMSDAB_BAK.frzjhm
  is '法人证件号码';
comment on column GS_DJ_CKTMSDAB_BAK.frdhhm
  is '法人电话号码';
comment on column GS_DJ_CKTMSDAB_BAK.yhmc
  is '开户银行名称';
comment on column GS_DJ_CKTMSDAB_BAK.yhzh
  is '开户银行账号';
comment on column GS_DJ_CKTMSDAB_BAK.bsy1_mc
  is '办税员名称
';
comment on column GS_DJ_CKTMSDAB_BAK.bsy1_id
  is '办税员身份证';
comment on column GS_DJ_CKTMSDAB_BAK.bsy1_dh
  is '办税员电话';
comment on column GS_DJ_CKTMSDAB_BAK.bsy2_mc
  is '办税员名称
';
comment on column GS_DJ_CKTMSDAB_BAK.bsy2_id
  is '办税员身份证';
comment on column GS_DJ_CKTMSDAB_BAK.bsy2_dh
  is '办税员电话';
comment on column GS_DJ_CKTMSDAB_BAK.zzsyhzc
  is '增值税优惠政策代码集，用半角逗号隔开
';
comment on column GS_DJ_CKTMSDAB_BAK.zgwhj
  is '主管外汇局';
comment on column GS_DJ_CKTMSDAB_BAK.fszl
  is '附送资料';
comment on column GS_DJ_CKTMSDAB_BAK.tsjsfs_dm
  is '退税计算方式代码';
comment on column GS_DJ_CKTMSDAB_BAK.sbfs_mc_zzbz
  is '纸质凭证申报方式';
comment on column GS_DJ_CKTMSDAB_BAK.sbfs_mc_sjdw
  is '纸质凭证电文方式';
comment on column GS_DJ_CKTMSDAB_BAK.sffbhs
  is '是否分部核算
';
comment on column GS_DJ_CKTMSDAB_BAK.fbhsdm
  is '分部核算部门代码
';
comment on column GS_DJ_CKTMSDAB_BAK.qylx_dm
  is '企业类型代码
';
comment on column GS_DJ_CKTMSDAB_BAK.cpcode
  is '核心征管系统TO_CHAR(DJXH)';
comment on column GS_DJ_CKTMSDAB_BAK.nsrdjno
  is '纳税人识别号';
comment on column GS_DJ_CKTMSDAB_BAK.shxyno
  is '社会信用代码';
comment on column GS_DJ_CKTMSDAB_BAK.zs_swjg_dm
  is '征收税务机关-审核助手用';
comment on column GS_DJ_CKTMSDAB_BAK.zx_flag
  is '注销标志 R 注销';
comment on column GS_DJ_CKTMSDAB_BAK.tsgllx_dm
  is '退税管理类型代码';
comment on column GS_DJ_CKTMSDAB_BAK.jdxzmc
  is '乡镇街道名称';
comment on column GS_DJ_CKTMSDAB_BAK.tbbz
  is '同步标志';
comment on column GS_DJ_CKTMSDAB_BAK.zgswskfj_dm
  is '主管税务所（科、分局）代码';
comment on column GS_DJ_CKTMSDAB_BAK.jdxz_dm
  is '街道乡镇代码';
comment on column GS_DJ_CKTMSDAB_BAK.wmzhfwqybz
  is '外贸综合服务企业标志（35号公告）';
comment on column GS_DJ_CKTMSDAB_BAK.scsbrq
  is '企业首次申报退（免）税时间（从HX_CKTS.CKTS_TY_SCSBQK同步）';
comment on column GS_DJ_CKTMSDAB_BAK.ztxthhbz
  is '暂停先退后核标志（从HX_CKTS.CKTS_BA_PZXX_JGB同步）';
comment on column GS_DJ_CKTMSDAB_BAK.yhzhtgbz
  is '银行账号托管标志';
comment on column GS_DJ_CKTMSDAB_BAK.zsqybbsrbz
  is '综税区试点一般纳税人标志';
comment on column GS_DJ_CKTMSDAB_BAK.cpcodetssh
  is '老审核系统CPCODE';

prompt
prompt Creating table GS_DJ_CKTMSDAB_KZ
prompt ================================
prompt
create table GS_DJ_CKTMSDAB_KZ
(
  uuid        VARCHAR2(32) not null,
  id          NUMBER(18),
  nsrdzdah    NUMBER(20) not null,
  kzlx        VARCHAR2(50),
  kzxx        VARCHAR2(100),
  st_date     DATE,
  end_date    DATE,
  flag        CHAR(1),
  note        VARCHAR2(4000),
  tbpc        NUMBER(18),
  readin_date DATE,
  cpcode      VARCHAR2(32)
)
;
comment on table GS_DJ_CKTMSDAB_KZ
  is '出口企业备案信息扩展信息';
comment on column GS_DJ_CKTMSDAB_KZ.uuid
  is 'UUID序号';
comment on column GS_DJ_CKTMSDAB_KZ.id
  is '序号';
comment on column GS_DJ_CKTMSDAB_KZ.nsrdzdah
  is '纳税人电子档案号';
comment on column GS_DJ_CKTMSDAB_KZ.kzlx
  is '扩展类型';
comment on column GS_DJ_CKTMSDAB_KZ.kzxx
  is '扩展信息';
comment on column GS_DJ_CKTMSDAB_KZ.st_date
  is '开始日期';
comment on column GS_DJ_CKTMSDAB_KZ.end_date
  is '终止日期';
comment on column GS_DJ_CKTMSDAB_KZ.flag
  is '有效标志';
comment on column GS_DJ_CKTMSDAB_KZ.note
  is '备注';
comment on column GS_DJ_CKTMSDAB_KZ.tbpc
  is '同步批次';
comment on column GS_DJ_CKTMSDAB_KZ.cpcode
  is '核心征管系统TO_CHAR(DJXH)';
create index IDX_GS_DJ_CKTMSDAB_KZ_2 on GS_DJ_CKTMSDAB_KZ (NSRDZDAH, KZLX, ST_DATE);
create index IDX_GS_DJ_CKTMSDAB_KZ_TBPC on GS_DJ_CKTMSDAB_KZ (TBPC);
alter table GS_DJ_CKTMSDAB_KZ
  add constraint PK_GS_DJ_CKTMSDAB_KZ primary key (UUID);

prompt
prompt Creating table GS_DJ_CKTMSDAB_KZ_TB
prompt ===================================
prompt
create table GS_DJ_CKTMSDAB_KZ_TB
(
  cpcode   VARCHAR2(32),
  uuid     VARCHAR2(32) not null,
  kzlx     VARCHAR2(50),
  kzxx     VARCHAR2(100),
  st_date  DATE,
  end_date DATE,
  flag     CHAR(1)
)
;
comment on table GS_DJ_CKTMSDAB_KZ_TB
  is '出口企业备案信息扩展信息,同步';
alter table GS_DJ_CKTMSDAB_KZ_TB
  add constraint PK_GS_DJ_CKTMSDAB_KZ_TB primary key (UUID);

prompt
prompt Creating table GS_DJ_CKTMSDAB_TB
prompt ================================
prompt
create table GS_DJ_CKTMSDAB_TB
(
  nsrmc          VARCHAR2(400),
  nsrmcyw        VARCHAR2(75),
  qyhgdm         VARCHAR2(32),
  nsrdh          VARCHAR2(60),
  nsrcz          VARCHAR2(16),
  nsryb          VARCHAR2(6),
  nsryx          VARCHAR2(90),
  zcdz           VARCHAR2(300),
  scjydz         VARCHAR2(300),
  nsrsbh         VARCHAR2(32),
  nsrlx_dm       CHAR(1),
  swjg_dm        VARCHAR2(11),
  nsrxydj_dm     VARCHAR2(20),
  djzclx_dm      CHAR(3),
  hy_dm          VARCHAR2(4),
  lsgx_dm        VARCHAR2(2),
  jyzlx_dm       VARCHAR2(1),
  badjbbh        VARCHAR2(45),
  sfysfw         VARCHAR2(1),
  ysfw           VARCHAR2(30),
  ysfs           VARCHAR2(50),
  yfsj           VARCHAR2(50),
  gsdjzzh        VARCHAR2(50),
  gskyrq         DATE,
  gsyxqz         DATE,
  gsdjyxq        NUMBER(2),
  gszczb         VARCHAR2(20),
  fddbrmc        VARCHAR2(150),
  frzjhm         VARCHAR2(30),
  frdhhm         VARCHAR2(60),
  yhmc           VARCHAR2(400),
  yhzh           VARCHAR2(60),
  bsy1_mc        VARCHAR2(150),
  bsy1_id        VARCHAR2(30),
  bsy1_dh        VARCHAR2(60),
  bsy2_mc        VARCHAR2(150),
  bsy2_id        VARCHAR2(30),
  bsy2_dh        VARCHAR2(60),
  zzsyhzc        VARCHAR2(30),
  zgwhj          VARCHAR2(30),
  fszl           VARCHAR2(500),
  tsjsfs_dm      CHAR(1),
  sbfs_mc_zzbz   VARCHAR2(20),
  sbfs_mc_sjdw   VARCHAR2(20),
  sffbhs         CHAR(1),
  fbhsdm         VARCHAR2(130),
  qylx_dm        VARCHAR2(10),
  cpcode         VARCHAR2(32) not null,
  nsrdjno        VARCHAR2(32),
  shxyno         VARCHAR2(20),
  zs_swjg_dm     VARCHAR2(11),
  zx_flag        VARCHAR2(1),
  tsgllx_dm      VARCHAR2(200),
  jdxzmc         VARCHAR2(50),
  tag            VARCHAR2(30),
  zgswskfj_dm    VARCHAR2(11),
  jdxz_dm        CHAR(9),
  zsqybbsrbz     CHAR(1),
  yhzhtgbz       CHAR(1),
  wmzhfwqybz     CHAR(1),
  scsbrq         DATE,
  ztxthhbz       CHAR(1),
  barq           DATE,
  zx_date        DATE,
  fddbrsfzjlx_dm CHAR(3),
  nsrzt_dm       CHAR(2),
  zgswj_dm       CHAR(11),
  gsdjz_fzrq     DATE,
  ybnsrrdsjq     DATE,
  first_sb_ym    VARCHAR2(6),
  xgrq           DATE,
  cwfzrxm        VARCHAR2(150),
  cwfzrsfzjhm    VARCHAR2(30),
  cwfzrgddh      VARCHAR2(60),
  cwfzryddh      VARCHAR2(60),
  bsrxm          VARCHAR2(150),
  bsrsfzjhm      VARCHAR2(30),
  bsrgddh        VARCHAR2(60),
  bsryddh        VARCHAR2(60),
  djrq           DATE,
  scckrq         DATE,
  fddbr_cgbl     NUMBER(18,6) default 0
)
;
comment on table GS_DJ_CKTMSDAB_TB
  is '登记出口退税档案表';
comment on column GS_DJ_CKTMSDAB_TB.nsrmc
  is '纳税人名称';
comment on column GS_DJ_CKTMSDAB_TB.nsrmcyw
  is '纳税人英文名称';
comment on column GS_DJ_CKTMSDAB_TB.qyhgdm
  is '企业海关代码';
comment on column GS_DJ_CKTMSDAB_TB.nsrdh
  is '纳税人电话';
comment on column GS_DJ_CKTMSDAB_TB.nsrcz
  is '纳税人传真';
comment on column GS_DJ_CKTMSDAB_TB.nsryb
  is '纳税人邮编';
comment on column GS_DJ_CKTMSDAB_TB.nsryx
  is '纳税人电子信箱';
comment on column GS_DJ_CKTMSDAB_TB.zcdz
  is '注册地址';
comment on column GS_DJ_CKTMSDAB_TB.scjydz
  is '生产经营地址';
comment on column GS_DJ_CKTMSDAB_TB.nsrsbh
  is '纳税人识别号';
comment on column GS_DJ_CKTMSDAB_TB.nsrlx_dm
  is '纳税人类型代码';
comment on column GS_DJ_CKTMSDAB_TB.swjg_dm
  is '税务机关代码
';
comment on column GS_DJ_CKTMSDAB_TB.nsrxydj_dm
  is '纳税人信用等级';
comment on column GS_DJ_CKTMSDAB_TB.djzclx_dm
  is '登记注册类型-NEW';
comment on column GS_DJ_CKTMSDAB_TB.hy_dm
  is '行业代码';
comment on column GS_DJ_CKTMSDAB_TB.lsgx_dm
  is '隶属关系代码';
comment on column GS_DJ_CKTMSDAB_TB.jyzlx_dm
  is '经营者类型代码';
comment on column GS_DJ_CKTMSDAB_TB.badjbbh
  is '外贸备案登记表编号';
comment on column GS_DJ_CKTMSDAB_TB.sfysfw
  is '是否应税服务
';
comment on column GS_DJ_CKTMSDAB_TB.ysfw
  is '应税服务代码集，用半角逗号隔开
';
comment on column GS_DJ_CKTMSDAB_TB.ysfs
  is '运输方式代码集，用半角逗号隔开
';
comment on column GS_DJ_CKTMSDAB_TB.yfsj
  is '研发设计代码集，用半角逗号隔开
';
comment on column GS_DJ_CKTMSDAB_TB.gsdjzzh
  is '工商登记证号';
comment on column GS_DJ_CKTMSDAB_TB.gskyrq
  is '工商开业日期';
comment on column GS_DJ_CKTMSDAB_TB.gsyxqz
  is '工商有效期止';
comment on column GS_DJ_CKTMSDAB_TB.gsdjyxq
  is '工商登记有效期';
comment on column GS_DJ_CKTMSDAB_TB.gszczb
  is '工商注册资本';
comment on column GS_DJ_CKTMSDAB_TB.fddbrmc
  is '法人代表名称
';
comment on column GS_DJ_CKTMSDAB_TB.frzjhm
  is '法人证件号码';
comment on column GS_DJ_CKTMSDAB_TB.frdhhm
  is '法人电话号码';
comment on column GS_DJ_CKTMSDAB_TB.yhmc
  is '开户银行名称';
comment on column GS_DJ_CKTMSDAB_TB.yhzh
  is '开户银行账号';
comment on column GS_DJ_CKTMSDAB_TB.bsy1_mc
  is '办税员名称
';
comment on column GS_DJ_CKTMSDAB_TB.bsy1_id
  is '办税员身份证';
comment on column GS_DJ_CKTMSDAB_TB.bsy1_dh
  is '办税员电话';
comment on column GS_DJ_CKTMSDAB_TB.bsy2_mc
  is '办税员名称
';
comment on column GS_DJ_CKTMSDAB_TB.bsy2_id
  is '办税员身份证';
comment on column GS_DJ_CKTMSDAB_TB.bsy2_dh
  is '办税员电话';
comment on column GS_DJ_CKTMSDAB_TB.zzsyhzc
  is '增值税优惠政策代码集，用半角逗号隔开
';
comment on column GS_DJ_CKTMSDAB_TB.zgwhj
  is '主管外汇局';
comment on column GS_DJ_CKTMSDAB_TB.fszl
  is '附送资料';
comment on column GS_DJ_CKTMSDAB_TB.tsjsfs_dm
  is '退税计算方式代码';
comment on column GS_DJ_CKTMSDAB_TB.sbfs_mc_zzbz
  is '纸质凭证申报方式';
comment on column GS_DJ_CKTMSDAB_TB.sbfs_mc_sjdw
  is '纸质凭证电文方式';
comment on column GS_DJ_CKTMSDAB_TB.sffbhs
  is '是否分部核算
';
comment on column GS_DJ_CKTMSDAB_TB.fbhsdm
  is '分部核算部门代码
';
comment on column GS_DJ_CKTMSDAB_TB.qylx_dm
  is '企业类型代码
';
comment on column GS_DJ_CKTMSDAB_TB.cpcode
  is '核心征管系统TOCHAR(DJXH)';
comment on column GS_DJ_CKTMSDAB_TB.nsrdjno
  is '纳税人识别号';
comment on column GS_DJ_CKTMSDAB_TB.shxyno
  is '社会信用代码';
comment on column GS_DJ_CKTMSDAB_TB.zs_swjg_dm
  is '征收税务机关-审核助手用';
comment on column GS_DJ_CKTMSDAB_TB.zx_flag
  is '注销标志 R 注销';
comment on column GS_DJ_CKTMSDAB_TB.tsgllx_dm
  is '退税管理类型代码';
comment on column GS_DJ_CKTMSDAB_TB.jdxzmc
  is '乡镇街道名称';
comment on column GS_DJ_CKTMSDAB_TB.zgswskfj_dm
  is '主管税务所（科、分局）代码';
comment on column GS_DJ_CKTMSDAB_TB.jdxz_dm
  is '街道乡镇代码-NEW';
comment on column GS_DJ_CKTMSDAB_TB.zsqybbsrbz
  is '综税区试点一般纳税人标志';
comment on column GS_DJ_CKTMSDAB_TB.yhzhtgbz
  is '出口退税账户办理托管贷款业务标志';
comment on column GS_DJ_CKTMSDAB_TB.wmzhfwqybz
  is '外贸综合服务企业标志';
comment on column GS_DJ_CKTMSDAB_TB.scsbrq
  is '首次申报日期';
comment on column GS_DJ_CKTMSDAB_TB.ztxthhbz
  is '暂停先退后核资格标志';
comment on column GS_DJ_CKTMSDAB_TB.barq
  is '备案日期-NEW';
comment on column GS_DJ_CKTMSDAB_TB.zx_date
  is '备案撤回日期-NEW';
comment on column GS_DJ_CKTMSDAB_TB.fddbrsfzjlx_dm
  is '法人证件类型-NEW';
comment on column GS_DJ_CKTMSDAB_TB.nsrzt_dm
  is '纳税人状态-NEW';
comment on column GS_DJ_CKTMSDAB_TB.zgswj_dm
  is '征管税务机关代码-NEW';
comment on column GS_DJ_CKTMSDAB_TB.gsdjz_fzrq
  is '税务登记日期-NEW';
comment on column GS_DJ_CKTMSDAB_TB.ybnsrrdsjq
  is '一般纳税人认定日期-NEW';
comment on column GS_DJ_CKTMSDAB_TB.first_sb_ym
  is '首次申报年月-NEW';
comment on column GS_DJ_CKTMSDAB_TB.xgrq
  is '修改日期NVL(T.XGRQ,T.LRRQ)-增量用';
comment on column GS_DJ_CKTMSDAB_TB.scckrq
  is '首次出口日期';
comment on column GS_DJ_CKTMSDAB_TB.fddbr_cgbl
  is '法定代表人持股比例';
create index IDX_GS_DJ_CKTMSDAB_TB_CPCODE on GS_DJ_CKTMSDAB_TB (CPCODE);
alter table GS_DJ_CKTMSDAB_TB
  add constraint PK_GS_DJ_CKTMSDAB_TB primary key (CPCODE);

prompt
prompt Creating table GS_DJ_CKTMSDAB_TEST
prompt ==================================
prompt
create table GS_DJ_CKTMSDAB_TEST
(
  nsrsbh     VARCHAR2(32),
  ysfs       VARCHAR2(50),
  fszl       VARCHAR2(240),
  name       CLOB,
  eg_name    VARCHAR2(50),
  qydm       VARCHAR2(18),
  tel        VARCHAR2(20),
  fax        VARCHAR2(16),
  postcode   VARCHAR2(6),
  email      VARCHAR2(90),
  address    VARCHAR2(300),
  jy_address VARCHAR2(300),
  nsrlb      CHAR(1),
  swcode     VARCHAR2(11),
  nsxydj     VARCHAR2(20),
  zclxcode   VARCHAR2(200),
  hycode     VARCHAR2(4),
  lsgx       VARCHAR2(2),
  jylxcode   CHAR(1),
  jckq_pwh   VARCHAR2(30),
  ysfwcode   VARCHAR2(30),
  yfsjfw     VARCHAR2(50),
  gsdjz_no   VARCHAR2(50),
  gsdjz_fzrq TIMESTAMP(6),
  null       VARCHAR2(2000),
  gsdjz_yxq  INTEGER,
  zczj       VARCHAR2(20),
  qyfr       VARCHAR2(2000),
  qyfr_no    VARCHAR2(2000),
  qyfr_tel   VARCHAR2(2000),
  bkname     VARCHAR2(80),
  acc_no     VARCHAR2(60),
  bsy        VARCHAR2(30),
  bsy_no     VARCHAR2(20),
  bsy_tel    VARCHAR2(20),
  bsy2       VARCHAR2(30),
  bsy2_no    VARCHAR2(20),
  bsy2_tel   VARCHAR2(20),
  yhzc       VARCHAR2(30),
  zgwgj      VARCHAR2(30),
  js_mode    CHAR(1),
  zzsbfs     VARCHAR2(20),
  sjdwsb     VARCHAR2(20),
  fbhs       CHAR(1),
  fbhscode   VARCHAR2(100),
  qylx       VARCHAR2(10),
  code       VARCHAR2(32),
  nsrdj_no   VARCHAR2(32),
  shxy_no    VARCHAR2(20),
  zxflag     CHAR(1),
  kzlx       VARCHAR2(200),
  ysfw       CHAR(1)
)
;
comment on table GS_DJ_CKTMSDAB_TEST
  is '登记出口退税档案表';
comment on column GS_DJ_CKTMSDAB_TEST.nsrsbh
  is '纳税人识别号';
comment on column GS_DJ_CKTMSDAB_TEST.ysfs
  is '运输方式代码集，用半角逗号隔开
';
comment on column GS_DJ_CKTMSDAB_TEST.fszl
  is '附送资料';
create unique index IDX_GS_DJ_CKTMSDAB_TEST_NSRSBH on GS_DJ_CKTMSDAB_TEST (NSRSBH);

prompt
prompt Creating table GS_DJ_CKTMSDAB_WZF_TB
prompt ====================================
prompt
create table GS_DJ_CKTMSDAB_WZF_TB
(
  djxh           NUMBER(20),
  lcslid         CHAR(32),
  uuid           VARCHAR2(32) not null,
  nsrmc          VARCHAR2(300),
  hgqy_dm        VARCHAR2(50),
  nsrsbh         VARCHAR2(20),
  shxydm         VARCHAR2(20),
  wmzhfwqynsrmc  VARCHAR2(300),
  wmzhfwqyhgqydm VARCHAR2(50),
  wmzhfwqynsrsbh VARCHAR2(20),
  wmzhfwqyshxydm VARCHAR2(20),
  wmzhfwhtxyhm   VARCHAR2(60),
  tskhyhmc       VARCHAR2(120),
  tskhyhzh       VARCHAR2(50),
  fddbrxm        VARCHAR2(150),
  dbtsbalczt_dm  CHAR(1),
  tsswjg_dm_1    CHAR(11),
  lrrq           DATE,
  lrr_dm         CHAR(11),
  xgrq           DATE,
  xgr_dm         CHAR(11),
  sjgsdq         CHAR(11),
  sjtb_sj        TIMESTAMP(6),
  bachbz         CHAR(1),
  bachrq         DATE,
  tbrq_1         DATE,
  sbxh           VARCHAR2(50)
)
;
comment on column GS_DJ_CKTMSDAB_WZF_TB.djxh
  is '登记序号';
comment on column GS_DJ_CKTMSDAB_WZF_TB.lcslid
  is '流程实例ID';
comment on column GS_DJ_CKTMSDAB_WZF_TB.uuid
  is 'UUID||uuid';
comment on column GS_DJ_CKTMSDAB_WZF_TB.nsrmc
  is '纳税人名称';
comment on column GS_DJ_CKTMSDAB_WZF_TB.hgqy_dm
  is '海关企业代码';
comment on column GS_DJ_CKTMSDAB_WZF_TB.nsrsbh
  is '纳税人识别号';
comment on column GS_DJ_CKTMSDAB_WZF_TB.shxydm
  is '社会信用代码';
comment on column GS_DJ_CKTMSDAB_WZF_TB.wmzhfwqynsrmc
  is '外贸综合服务企业纳税人名称';
comment on column GS_DJ_CKTMSDAB_WZF_TB.wmzhfwqyhgqydm
  is '外贸综合服务企业海关企业代码';
comment on column GS_DJ_CKTMSDAB_WZF_TB.wmzhfwqynsrsbh
  is '外贸综合服务企业纳税人识别号';
comment on column GS_DJ_CKTMSDAB_WZF_TB.wmzhfwqyshxydm
  is '外贸综合服务企业社会信用代码';
comment on column GS_DJ_CKTMSDAB_WZF_TB.wmzhfwhtxyhm
  is '外贸综合服务合同（协议）号码';
comment on column GS_DJ_CKTMSDAB_WZF_TB.tskhyhmc
  is '退税开户银行名称';
comment on column GS_DJ_CKTMSDAB_WZF_TB.tskhyhzh
  is '退税开户银行账号';
comment on column GS_DJ_CKTMSDAB_WZF_TB.fddbrxm
  is '法定代表人姓名';
comment on column GS_DJ_CKTMSDAB_WZF_TB.dbtsbalczt_dm
  is '代办退税备案流程状态代码';
comment on column GS_DJ_CKTMSDAB_WZF_TB.tsswjg_dm_1
  is '退税税务机关代码';
comment on column GS_DJ_CKTMSDAB_WZF_TB.lrrq
  is '录入日期';
comment on column GS_DJ_CKTMSDAB_WZF_TB.lrr_dm
  is '录入人代码';
comment on column GS_DJ_CKTMSDAB_WZF_TB.xgrq
  is '修改日期';
comment on column GS_DJ_CKTMSDAB_WZF_TB.xgr_dm
  is '修改人代码';
comment on column GS_DJ_CKTMSDAB_WZF_TB.sjgsdq
  is '数据归属地区';
comment on column GS_DJ_CKTMSDAB_WZF_TB.sjtb_sj
  is '数据同步时间';
comment on column GS_DJ_CKTMSDAB_WZF_TB.bachbz
  is '备案撤回标志||备案撤回标志';
comment on column GS_DJ_CKTMSDAB_WZF_TB.bachrq
  is '备案撤回日期';
comment on column GS_DJ_CKTMSDAB_WZF_TB.tbrq_1
  is '填表日期';
comment on column GS_DJ_CKTMSDAB_WZF_TB.sbxh
  is '申报序号';
create index IDX_GS_DJ_CKTMSDAB_WZF_DJXH on GS_DJ_CKTMSDAB_WZF_TB (DJXH);
alter table GS_DJ_CKTMSDAB_WZF_TB
  add constraint PK_GS_DJ_CKTMSDAB_WZF primary key (UUID);

prompt
prompt Creating table GS_DJ_NSRFJXX
prompt ============================
prompt
create table GS_DJ_NSRFJXX
(
  nsrdzdah NUMBER(20) not null,
  tjnd     CHAR(4) not null,
  ckxse    NUMBER(16,2),
  zymyg    VARCHAR2(500),
  zyspmc   VARCHAR2(500),
  frtime   TIMESTAMP(6),
  ckgm     NUMBER(16,2),
  ckgm_hg  NUMBER(16,2),
  tse      NUMBER(16,2),
  mde      NUMBER(16,2),
  zdbz     CHAR(1)
)
;
comment on table GS_DJ_NSRFJXX
  is '出口企业附加信息表';
comment on column GS_DJ_NSRFJXX.tjnd
  is '统计年度';
comment on column GS_DJ_NSRFJXX.ckxse
  is '年申报出口销售额';
comment on column GS_DJ_NSRFJXX.zymyg
  is '主要贸易国';
comment on column GS_DJ_NSRFJXX.zyspmc
  is '主要商品名称';
comment on column GS_DJ_NSRFJXX.frtime
  is '刷新时间';
comment on column GS_DJ_NSRFJXX.ckgm
  is '年度出口规模（按出口日期)申报口径';
comment on column GS_DJ_NSRFJXX.ckgm_hg
  is '年度出口规模（按出口日期)海关口径';
comment on column GS_DJ_NSRFJXX.tse
  is '退税额';
comment on column GS_DJ_NSRFJXX.mde
  is '免抵额';
comment on column GS_DJ_NSRFJXX.zdbz
  is '重点企业标志(1重点 0普通)';
alter table GS_DJ_NSRFJXX
  add primary key (NSRDZDAH);

prompt
prompt Creating table GS_DJ_TEST_NSR
prompt =============================
prompt
create table GS_DJ_TEST_NSR
(
  nsrdzdah NUMBER(20) not null,
  nsrmc    VARCHAR2(80),
  yxbz     CHAR(1) not null
)
;
alter table GS_DJ_TEST_NSR
  add primary key (NSRDZDAH);

prompt
prompt Creating table GS_DJ_TXFWSQXX
prompt =============================
prompt
create table GS_DJ_TXFWSQXX
(
  tbpc        NUMBER(18),
  uuid        VARCHAR2(32) not null,
  cpcode      VARCHAR2(32),
  nsrdzdah    NUMBER(20),
  sfjsdxfw    VARCHAR2(1),
  djr1mc      VARCHAR2(30),
  djr1zw      VARCHAR2(20),
  djr1dh      VARCHAR2(20),
  djr1yx      VARCHAR2(50),
  djr2mc      VARCHAR2(30),
  djr2zw      VARCHAR2(20),
  djr2dh      VARCHAR2(20),
  djr2yx      VARCHAR2(50),
  readin_date DATE
)
;
comment on table GS_DJ_TXFWSQXX
  is '申请提醒服务表';
comment on column GS_DJ_TXFWSQXX.tbpc
  is '同步批次
';
comment on column GS_DJ_TXFWSQXX.uuid
  is '唯一主键标志';
comment on column GS_DJ_TXFWSQXX.cpcode
  is 'DJXH';
comment on column GS_DJ_TXFWSQXX.nsrdzdah
  is '纳税人电子档案号，征管系统中区分纳税人';
comment on column GS_DJ_TXFWSQXX.sfjsdxfw
  is '是否接收短信提醒服务
';
comment on column GS_DJ_TXFWSQXX.djr1mc
  is '登记人员1姓名
';
comment on column GS_DJ_TXFWSQXX.djr1zw
  is '登记人员1职务
';
comment on column GS_DJ_TXFWSQXX.djr1dh
  is '登记人员1手机号码
';
comment on column GS_DJ_TXFWSQXX.djr1yx
  is '登记人员1电子邮件
';
comment on column GS_DJ_TXFWSQXX.djr2mc
  is '登记人员2姓名
';
comment on column GS_DJ_TXFWSQXX.djr2zw
  is '登记人员2职务
';
comment on column GS_DJ_TXFWSQXX.djr2dh
  is '登记人员2手机号码
';
comment on column GS_DJ_TXFWSQXX.djr2yx
  is '登记人员2电子邮件
';
create index IDX_GS_DJ_TXFWSQXX_NSRDZDAH on GS_DJ_TXFWSQXX (NSRDZDAH);
alter table GS_DJ_TXFWSQXX
  add constraint PK_GS_DJ_TXFWSQXX primary key (UUID);

prompt
prompt Creating table GS_DLCKHWZM
prompt ==========================
prompt
create table GS_DLCKHWZM
(
  tbpc       NUMBER(18) not null,
  nsrdzdah   NUMBER(20) not null,
  dlckhwzm   VARCHAR2(20) not null,
  hgbgdh     VARCHAR2(21),
  ckrq       DATE,
  hgmyxz_dm  VARCHAR2(4),
  spdm       VARCHAR2(40),
  spmc       VARCHAR2(254),
  jldw       VARCHAR2(8),
  sl         NUMBER(15,4),
  hbzl_dm    VARCHAR2(3),
  je_laj_usd NUMBER(15,2),
  hlv_usd    NUMBER(10,5),
  je_laj_rmb NUMBER(15,2),
  flag_pp    VARCHAR2(1)
)
;
comment on table GS_DLCKHWZM
  is '代理出口货物证明表';
comment on column GS_DLCKHWZM.tbpc
  is '同步批次
';
comment on column GS_DLCKHWZM.nsrdzdah
  is '纳税人电子档案号，征管系统中区分纳税人唯一主键标志
';
comment on column GS_DLCKHWZM.dlckhwzm
  is '代理出口货物证明号
';
comment on column GS_DLCKHWZM.hgbgdh
  is '海关报关单号
';
comment on column GS_DLCKHWZM.ckrq
  is '出口日期
';
comment on column GS_DLCKHWZM.hgmyxz_dm
  is '海关贸易方式代码
';
comment on column GS_DLCKHWZM.spdm
  is '商品代码（报关）
';
comment on column GS_DLCKHWZM.spmc
  is '商品名称（报关）
';
comment on column GS_DLCKHWZM.jldw
  is '计量单位名称
';
comment on column GS_DLCKHWZM.sl
  is '数量
';
comment on column GS_DLCKHWZM.hbzl_dm
  is '货币种类代码
';
comment on column GS_DLCKHWZM.je_laj_usd
  is '美元离岸价
';
comment on column GS_DLCKHWZM.hlv_usd
  is '美元汇率
';
comment on column GS_DLCKHWZM.je_laj_rmb
  is '人民币离岸价
';
comment on column GS_DLCKHWZM.flag_pp
  is '与出口报关单（进项发票）匹配标志
';
alter table GS_DLCKHWZM
  add constraint PK_DLCKHWZM primary key (TBPC, NSRDZDAH, DLCKHWZM);

prompt
prompt Creating table GS_DM_HGSP_LMYCL
prompt ===============================
prompt
create table GS_DM_HGSP_LMYCL
(
  spdm VARCHAR2(40) not null,
  spmc VARCHAR2(254) not null,
  bz   VARCHAR2(200),
  qybj CHAR(1),
  tbpc NUMBER(18) not null
)
;
comment on table GS_DM_HGSP_LMYCL
  is '列名原材料代码表';
comment on column GS_DM_HGSP_LMYCL.spdm
  is '商品代码';
comment on column GS_DM_HGSP_LMYCL.spmc
  is '商品名称';
comment on column GS_DM_HGSP_LMYCL.bz
  is '备注';
comment on column GS_DM_HGSP_LMYCL.qybj
  is '启用标记';
comment on column GS_DM_HGSP_LMYCL.tbpc
  is '同步批次';
alter table GS_DM_HGSP_LMYCL
  add constraint PK_DM_HGSP_LMYCL primary key (TBPC, SPDM, SPMC);

prompt
prompt Creating table GS_DM_NSRXYDJ
prompt ============================
prompt
create table GS_DM_NSRXYDJ
(
  nsrxydj_dm VARCHAR2(2) not null,
  nsrxydj_mc VARCHAR2(20),
  xybz       CHAR(1),
  yxbz       CHAR(1),
  tbpc       NUMBER(18)
)
;
comment on table GS_DM_NSRXYDJ
  is '纳税人信誉等级代码（CTAIS）';
comment on column GS_DM_NSRXYDJ.nsrxydj_dm
  is '纳税人信誉等级代码';
comment on column GS_DM_NSRXYDJ.nsrxydj_mc
  is '纳税人信誉等级名称';
comment on column GS_DM_NSRXYDJ.xybz
  is '选用标志';
comment on column GS_DM_NSRXYDJ.yxbz
  is '有效标志';
comment on column GS_DM_NSRXYDJ.tbpc
  is '同步批次';
alter table GS_DM_NSRXYDJ
  add constraint PK_DM_NSRXYDJ primary key (NSRXYDJ_DM);

prompt
prompt Creating table GS_DM_SWJG
prompt =========================
prompt
create table GS_DM_SWJG
(
  swjg_dm VARCHAR2(11) not null,
  swjg_mc VARCHAR2(60),
  xybz    CHAR(1),
  yxbz    CHAR(1),
  tbpc    VARCHAR2(18)
)
;
comment on table GS_DM_SWJG
  is '税务机关代码表（CTAIS）';
comment on column GS_DM_SWJG.swjg_dm
  is '税务机构代码';
comment on column GS_DM_SWJG.swjg_mc
  is '税务机构名称';
comment on column GS_DM_SWJG.xybz
  is '选用标志';
comment on column GS_DM_SWJG.yxbz
  is '有效标志';
comment on column GS_DM_SWJG.tbpc
  is '同步批次';
alter table GS_DM_SWJG
  add constraint GS_DM_SWJG primary key (SWJG_DM);

prompt
prompt Creating table GS_FKSJ
prompt ======================
prompt
create table GS_FKSJ
(
  id   NUMBER(18) not null,
  fkbw BLOB,
  bwgs VARCHAR2(10)
)
;
comment on table GS_FKSJ
  is '审批结束后反馈部分数据（比如不予退税、暂缓退税、国税证明编号）';
comment on column GS_FKSJ.fkbw
  is '反馈报文';
comment on column GS_FKSJ.bwgs
  is '报文格式';
alter table GS_FKSJ
  add primary key (ID);

prompt
prompt Creating table GS_HBZL_HLV
prompt ==========================
prompt
create table GS_HBZL_HLV
(
  tbpc     NUMBER(18) not null,
  hl_ym    VARCHAR2(6) not null,
  code     VARCHAR2(3) not null,
  hl_rmb   NUMBER(10,5),
  hl_usd   NUMBER(10,5),
  hl_range NUMBER(5,2)
)
;
comment on table GS_HBZL_HLV
  is '各月份币制汇率表';
comment on column GS_HBZL_HLV.tbpc
  is '同步批次';
comment on column GS_HBZL_HLV.hl_ym
  is '汇率年月';
comment on column GS_HBZL_HLV.code
  is '币种';
comment on column GS_HBZL_HLV.hl_rmb
  is '对人民币汇率';
comment on column GS_HBZL_HLV.hl_usd
  is '对美元汇率';
comment on column GS_HBZL_HLV.hl_range
  is '上下浮动范围';
alter table GS_HBZL_HLV
  add constraint PK_GS_HBZL_HLV primary key (HL_YM, CODE);

prompt
prompt Creating table GS_JLJG_HXJG
prompt ===========================
prompt
create table GS_JLJG_HXJG
(
  tbpc       NUMBER(18) not null,
  nsrdzdah   NUMBER(20) not null,
  sssq       VARCHAR2(6) not null,
  sbno       VARCHAR2(10) not null,
  jgmysch    VARCHAR2(20),
  fplyear    VARCHAR2(6),
  fplv_jh    NUMBER(10,6),
  lj_rmb     NUMBER(15,2),
  dzsqamt    NUMBER(15,2),
  sjfpl      NUMBER(10,6),
  tzmdtdje   NUMBER(15,2),
  tzbmzdkdje NUMBER(15,2),
  syfalg     VARCHAR2(1),
  syym       VARCHAR2(6),
  bz         VARCHAR2(200),
  hxqsrq     DATE,
  hxjzrq     DATE,
  nd         VARCHAR2(10),
  lrrq       DATE,
  uuid       VARCHAR2(32) not null
)
;
comment on table GS_JLJG_HXJG
  is '核销结果表';
comment on column GS_JLJG_HXJG.tbpc
  is '同步批次';
comment on column GS_JLJG_HXJG.nsrdzdah
  is '纳税人电子档案号';
comment on column GS_JLJG_HXJG.sssq
  is '所属时期';
comment on column GS_JLJG_HXJG.sbno
  is '申报号';
comment on column GS_JLJG_HXJG.jgmysch
  is '加工贸易手册号';
comment on column GS_JLJG_HXJG.fplyear
  is '分配率使用年度（这个字段已经没有用处，可以取消，企业端不需要显示）';
comment on column GS_JLJG_HXJG.fplv_jh
  is '计划分配率（这个字段已经没有用处，可以取消，企业端不需要显示，手册因为跨年度，每年的计划分配率不同，在一条记录下无法保存）';
comment on column GS_JLJG_HXJG.lj_rmb
  is '全部销售额';
comment on column GS_JLJG_HXJG.dzsqamt
  is '单证收讫销售额（这个字段已经没有用处，可以取消，企业端不需要显示）';
comment on column GS_JLJG_HXJG.sjfpl
  is '实际分配率';
comment on column GS_JLJG_HXJG.tzmdtdje
  is '应调整免抵退税额';
comment on column GS_JLJG_HXJG.tzbmzdkdje
  is '应调整不得免征和抵扣税额';
comment on column GS_JLJG_HXJG.syfalg
  is '使用标志';
comment on column GS_JLJG_HXJG.syym
  is '使用年月';
comment on column GS_JLJG_HXJG.bz
  is '备注';
comment on column GS_JLJG_HXJG.hxqsrq
  is '核销起始日期';
comment on column GS_JLJG_HXJG.hxjzrq
  is '核销截止日期';
comment on column GS_JLJG_HXJG.nd
  is '年度';
comment on column GS_JLJG_HXJG.lrrq
  is '录入日期';
create index IDX_GS_JLJG_HXJG_SSSQ on GS_JLJG_HXJG (NSRDZDAH, SSSQ);
alter table GS_JLJG_HXJG
  add constraint PK_GS_JLJG_HXJG primary key (UUID);

prompt
prompt Creating table GS_JLJG_JHFPL
prompt ============================
prompt
create table GS_JLJG_JHFPL
(
  tbpc       NUMBER(18) not null,
  nsrdzdah   NUMBER(20) not null,
  sssq       VARCHAR2(6) not null,
  jhfplv     NUMBER(9,5),
  jhfplv_new NUMBER(9,5),
  uptime     DATE
)
;
comment on table GS_JLJG_JHFPL
  is '进料加工计划分配率';
comment on column GS_JLJG_JHFPL.tbpc
  is '同步批次';
comment on column GS_JLJG_JHFPL.nsrdzdah
  is '纳税人电子档案号';
comment on column GS_JLJG_JHFPL.sssq
  is '所属时期';
comment on column GS_JLJG_JHFPL.jhfplv
  is '计划分配率';
comment on column GS_JLJG_JHFPL.jhfplv_new
  is '新计划分配率';
comment on column GS_JLJG_JHFPL.uptime
  is '更新时间';
alter table GS_JLJG_JHFPL
  add constraint PK_GS_JLJG_JHFPL primary key (TBPC, NSRDZDAH, SSSQ);

prompt
prompt Creating table GS_SH_PARAM
prompt ==========================
prompt
create table GS_SH_PARAM
(
  tsl_low        NUMBER(5,2) default 4.8 not null,
  tsl_high       NUMBER(5,2) default 17.2 not null,
  hhcb_low       NUMBER(5,2) default 5 not null,
  hhcb_high      NUMBER(5,2) default 8.2 not null,
  pri_low        NUMBER(5,2) default 0.5 not null,
  pri_high       NUMBER(5,2) default 1.5 not null,
  usd_wcbl       NUMBER(5,2) default 5 not null,
  wcbl           NUMBER(5,2) default 0.2 not null,
  cpcd_len       NUMBER(2) default 10 not null,
  cmcd_len       NUMBER(2) default 8 not null,
  zysp_len       NUMBER(2) default 11 not null,
  ldlp_hhcb_low  NUMBER(5,2) default 5 not null,
  ldlp_hhcb_high NUMBER(5,2) default 8 not null,
  htba_sl_fdbl   NUMBER(5,2) default 0 not null,
  htba_je_fdbl   NUMBER(5,2) default 0 not null,
  htba_mode      NUMBER(1) default 1 not null,
  tbpc           NUMBER(18)
)
;
comment on table GS_SH_PARAM
  is '国税疑点审核参数表';
comment on column GS_SH_PARAM.tsl_low
  is '最低退税率';
comment on column GS_SH_PARAM.tsl_high
  is '退税率上限';
comment on column GS_SH_PARAM.hhcb_low
  is '换汇成本下限';
comment on column GS_SH_PARAM.hhcb_high
  is '换汇成本上限';
comment on column GS_SH_PARAM.pri_low
  is '单价下限';
comment on column GS_SH_PARAM.pri_high
  is '单价上限';
comment on column GS_SH_PARAM.usd_wcbl
  is '美元误差比例';
comment on column GS_SH_PARAM.wcbl
  is '误差比例';
comment on column GS_SH_PARAM.cpcd_len
  is '海关代码长度';
comment on column GS_SH_PARAM.cmcd_len
  is '商品代码长度';
comment on column GS_SH_PARAM.zysp_len
  is '专用税票长度';
comment on column GS_SH_PARAM.ldlp_hhcb_low
  is '关联号换汇成本下限';
comment on column GS_SH_PARAM.ldlp_hhcb_high
  is '关联号换汇成本上限';
comment on column GS_SH_PARAM.htba_sl_fdbl
  is '合同备案数量';
comment on column GS_SH_PARAM.htba_je_fdbl
  is '合同备案金额';
comment on column GS_SH_PARAM.htba_mode
  is '合同备案模式';
comment on column GS_SH_PARAM.tbpc
  is '同步批次';

prompt
prompt Creating table GS_TRAINING_SYNC
prompt ===============================
prompt
create table GS_TRAINING_SYNC
(
  id   NUMBER not null,
  tbbw CLOB,
  tblx CHAR(1),
  tbbz CHAR(1),
  tbsj TIMESTAMP(6),
  cjsj TIMESTAMP(6)
)
;
comment on table GS_TRAINING_SYNC
  is '同步培训到易税云的表';
comment on column GS_TRAINING_SYNC.id
  is '主键，保持与gs_training一致';
comment on column GS_TRAINING_SYNC.tbbw
  is '同步报文';
comment on column GS_TRAINING_SYNC.tblx
  is '同步类型 1:新增/编辑   2:删除';
comment on column GS_TRAINING_SYNC.tbbz
  is '同步标志  Y:已同步  N:未同步';
comment on column GS_TRAINING_SYNC.tbsj
  is '同步时间';
comment on column GS_TRAINING_SYNC.cjsj
  is '创建时间';
alter table GS_TRAINING_SYNC
  add constraint PK_GS_TRAINING_SYNC primary key (ID);


prompt
prompt Creating table JXKH_TJBB
prompt ========================
prompt
create table JXKH_TJBB
(
  tjmonth VARCHAR2(6) not null,
  swcode  VARCHAR2(11) not null,
  flglcd  VARCHAR2(4) not null,
  bahs    NUMBER(10),
  sbhs    NUMBER(10),
  sbpcs   NUMBER(10),
  sl_day  NUMBER(10,4) default 0,
  sh_day  NUMBER(10,4) default 0,
  hz_day  NUMBER(10,4) default 0,
  kp_day  NUMBER(10,4) default 0,
  hj_day  NUMBER(10,4) default 0,
  note    VARCHAR2(255) default ' '
)
;
comment on table JXKH_TJBB
  is '绩效考核_统计报表';
comment on column JXKH_TJBB.tjmonth
  is '统计月份';
comment on column JXKH_TJBB.swcode
  is '税务机关代码';
comment on column JXKH_TJBB.flglcd
  is '分类管理等级';
comment on column JXKH_TJBB.bahs
  is '备案户数';
comment on column JXKH_TJBB.sbhs
  is '申报户数';
comment on column JXKH_TJBB.sbpcs
  is '申报批次数';
comment on column JXKH_TJBB.sl_day
  is '平均受理周期';
comment on column JXKH_TJBB.sh_day
  is '平均审核周期';
comment on column JXKH_TJBB.hz_day
  is '平均核准周期';
comment on column JXKH_TJBB.kp_day
  is '平均征管开票周期';
comment on column JXKH_TJBB.hj_day
  is '合计时间周期';
comment on column JXKH_TJBB.note
  is '备注';
alter table JXKH_TJBB
  add constraint PK_JXKH_TJBB_TSF primary key (TJMONTH, SWCODE, FLGLCD);

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
prompt Creating table RW_RWTXB
prompt =======================
prompt
create table RW_RWTXB
(
  id       NUMBER(18) not null,
  nsrdzdah NUMBER(20),
  rwlx_dm  CHAR(1),
  rwbt     VARCHAR2(100),
  rwnr     VARCHAR2(1000),
  rwly     VARCHAR2(30),
  rwzt_dm  CHAR(1),
  ywlx_dm  VARCHAR2(10),
  swry_dm  VARCHAR2(20),
  swry_mc  VARCHAR2(50),
  lxdh     VARCHAR2(50),
  cjrq     DATE,
  jzrq     DATE,
  swjg_dm  VARCHAR2(11),
  swjg_mc  VARCHAR2(50),
  ywgjz    NUMBER(18),
  wcrq     DATE,
  thyy     VARCHAR2(1000),
  bz       VARCHAR2(200),
  clcs     NUMBER(9),
  ywqx     CLOB
)
;
comment on table RW_RWTXB
  is '任务提醒表';
comment on column RW_RWTXB.id
  is '主键id';
comment on column RW_RWTXB.nsrdzdah
  is '纳税人电子档案号';
comment on column RW_RWTXB.rwlx_dm
  is '任务类型代码，参见sys_dict表rwlx_dm';
comment on column RW_RWTXB.rwbt
  is '任务标题';
comment on column RW_RWTXB.rwnr
  is '任务内容';
comment on column RW_RWTXB.rwly
  is '任务来源，参见sys_dict表';
comment on column RW_RWTXB.rwzt_dm
  is '任务状态代码，参见sys_dict表 rwzt_dm';
comment on column RW_RWTXB.ywlx_dm
  is '业务类型代码，参见sys_dict表 ywlx_dm';
comment on column RW_RWTXB.swry_dm
  is '税务人员代码';
comment on column RW_RWTXB.swry_mc
  is '税务人员名称';
comment on column RW_RWTXB.lxdh
  is '联系电话';
comment on column RW_RWTXB.cjrq
  is '创建日期';
comment on column RW_RWTXB.jzrq
  is '截止日期';
comment on column RW_RWTXB.swjg_dm
  is '税务机关代码';
comment on column RW_RWTXB.swjg_mc
  is '税务机关名称';
comment on column RW_RWTXB.ywgjz
  is '业务关键字 对应sb_sbxx_hz的id';
comment on column RW_RWTXB.wcrq
  is '完成日期';
comment on column RW_RWTXB.thyy
  is '退回原因';
comment on column RW_RWTXB.bz
  is '备注';
comment on column RW_RWTXB.clcs
  is '处理次数';
create index IDX_RW_RWTXB_NSRRWLXJWGJZ on RW_RWTXB (NSRDZDAH, RWLX_DM, YWGJZ);
alter table RW_RWTXB
  add constraint PK_RW_RWTXB primary key (ID);

prompt
prompt Creating table RW_SYNC_FILE
prompt ===========================
prompt
create table RW_SYNC_FILE
(
  id       NUMBER(18),
  md5      VARCHAR2(64),
  fileszie NUMBER(18),
  filename VARCHAR2(100),
  filepath VARCHAR2(100),
  synflag  CHAR(1),
  crtime   DATE,
  syntime  DATE,
  czry     VARCHAR2(20)
)
;
comment on column RW_SYNC_FILE.synflag
  is '0,待同步，1，已同步';
comment on column RW_SYNC_FILE.czry
  is '上传人';

prompt
prompt Creating table SB_HIS_SJFK
prompt ==========================
prompt
create table SB_HIS_SJFK
(
  id     NUMBER(18) not null,
  rwid   NUMBER(18),
  qyhgdm VARCHAR2(32),
  clbz   CHAR(1) not null,
  sjbw   BLOB,
  bwgs   VARCHAR2(10)
)
;
create index IDX_SB_HIS_SJFK_QYRWID on SB_HIS_SJFK (QYHGDM, RWID);
alter table SB_HIS_SJFK
  add constraint PK_SB_HIS_SJFK primary key (ID);

prompt
prompt Creating table SB_JLJG_HXSBB2018
prompt ================================
prompt
create table SB_JLJG_HXSBB2018
(
  sbid       NUMBER(18) not null,
  xh         NUMBER(18) default 0,
  sbno       VARCHAR2(4) default ' ',
  jgmysch    VARCHAR2(20) not null,
  fplv_jh    NUMBER(9,5) default 0,
  fplv_sj    NUMBER(9,5) default 0,
  lj_rmb     NUMBER(15,2) default 0,
  tzmdtdje   NUMBER(15,2) default 0,
  tzbmzdkdje NUMBER(15,2) default 0,
  ssyear     VARCHAR2(4) default ' ',
  bz         VARCHAR2(200) default ' '
)
;
comment on table SB_JLJG_HXSBB2018
  is '生产企业进料加工业务免抵退税核销表';
comment on column SB_JLJG_HXSBB2018.sbid
  is '申报业务序列号';
comment on column SB_JLJG_HXSBB2018.xh
  is '申报业务下序号';
comment on column SB_JLJG_HXSBB2018.sbno
  is '对应审核系统序号';
comment on column SB_JLJG_HXSBB2018.jgmysch
  is '加工贸易手册号';
comment on column SB_JLJG_HXSBB2018.fplv_jh
  is '计划分配率';
comment on column SB_JLJG_HXSBB2018.fplv_sj
  is '实际分配率';
comment on column SB_JLJG_HXSBB2018.lj_rmb
  is '已申报出口额';
comment on column SB_JLJG_HXSBB2018.tzmdtdje
  is '应调整免抵退税额';
comment on column SB_JLJG_HXSBB2018.tzbmzdkdje
  is '应调整不得免征和抵扣税额';
comment on column SB_JLJG_HXSBB2018.ssyear
  is '所属年度';
comment on column SB_JLJG_HXSBB2018.bz
  is '备注';
create index IDX_SB_JLJG_HXSBB2018_C1 on SB_JLJG_HXSBB2018 (SBID, JGMYSCH);
create index IDX_SB_JLJG_HXSBB2018_SBID on SB_JLJG_HXSBB2018 (SBID);

prompt
prompt Creating table SB_JLJG_HX_SBB
prompt =============================
prompt
create table SB_JLJG_HX_SBB
(
  sbid       NUMBER(18) not null,
  xh         NUMBER(18) default 0,
  sbno       VARCHAR2(8) default ' ',
  jgmysch    VARCHAR2(20) not null,
  hx_begin   DATE,
  hx_end     DATE,
  fplv_jh    NUMBER(9,5) default 0,
  fplv_sj    NUMBER(9,5) default 0,
  lj_rmb     NUMBER(15,2) default 0,
  tzmdtdje   NUMBER(15,2) default 0,
  tzbmzdkdje NUMBER(15,2) default 0,
  ssyear     VARCHAR2(4) default ' ',
  bz         VARCHAR2(200) default ' '
)
;
comment on table SB_JLJG_HX_SBB
  is '生产企业进料加工业务免抵退税核销表';
comment on column SB_JLJG_HX_SBB.sbid
  is '申报业务序列号';
comment on column SB_JLJG_HX_SBB.xh
  is '申报业务下序号';
comment on column SB_JLJG_HX_SBB.sbno
  is '对应审核系统序号';
comment on column SB_JLJG_HX_SBB.jgmysch
  is '加工贸易手册号';
comment on column SB_JLJG_HX_SBB.hx_begin
  is '核销起始时间';
comment on column SB_JLJG_HX_SBB.hx_end
  is '核销截止时间';
comment on column SB_JLJG_HX_SBB.fplv_jh
  is '计划分配率';
comment on column SB_JLJG_HX_SBB.fplv_sj
  is '实际分配率';
comment on column SB_JLJG_HX_SBB.lj_rmb
  is '已申报出口额';
comment on column SB_JLJG_HX_SBB.tzmdtdje
  is '应调整免抵退税额';
comment on column SB_JLJG_HX_SBB.tzbmzdkdje
  is '应调整不得免征和抵扣税额';
comment on column SB_JLJG_HX_SBB.ssyear
  is '所属年度';
comment on column SB_JLJG_HX_SBB.bz
  is '备注';
create index IDX_SB_JLJG_HX_SBB_C1 on SB_JLJG_HX_SBB (SBID, JGMYSCH);
create index IDX_SB_JLJG_HX_SBB_SBID on SB_JLJG_HX_SBB (SBID);

prompt
prompt Creating table SB_OTHER_BOTH_DZXXCXB
prompt ====================================
prompt
create table SB_OTHER_BOTH_DZXXCXB
(
  sbid    NUMBER(18) not null,
  dzzl_dm VARCHAR2(4) not null,
  dzhm    VARCHAR2(50) not null,
  rsvflag CHAR(1)
)
;
comment on table SB_OTHER_BOTH_DZXXCXB
  is '单证信息查询表';
comment on column SB_OTHER_BOTH_DZXXCXB.sbid
  is '申报id，对应sb_sbxx_hz表中的id';
comment on column SB_OTHER_BOTH_DZXXCXB.dzzl_dm
  is '单证种类代码';
comment on column SB_OTHER_BOTH_DZXXCXB.dzhm
  is '单证号码';
comment on column SB_OTHER_BOTH_DZXXCXB.rsvflag
  is '同步/存在标志';

prompt
prompt Creating table SB_OTHER_BOTH_DZXXSBB
prompt ====================================
prompt
create table SB_OTHER_BOTH_DZXXSBB
(
  tbpc     NUMBER(18),
  sbid     NUMBER(18),
  lcslid   VARCHAR2(32),
  sbno     VARCHAR2(32),
  dzzl_dm  VARCHAR2(4),
  dzhm     VARCHAR2(50),
  jhpzh    VARCHAR2(30),
  shflag   CHAR(1),
  errflag  CHAR(1),
  cqsbflag CHAR(1)
)
;
comment on table SB_OTHER_BOTH_DZXXSBB
  is '无相关电子信息审批结果反馈表';
comment on column SB_OTHER_BOTH_DZXXSBB.tbpc
  is '同步批次';
comment on column SB_OTHER_BOTH_DZXXSBB.sbid
  is '申报ID';
comment on column SB_OTHER_BOTH_DZXXSBB.lcslid
  is '对应审核系统lcslid';
comment on column SB_OTHER_BOTH_DZXXSBB.sbno
  is '对应审核系统sb_no';
comment on column SB_OTHER_BOTH_DZXXSBB.dzzl_dm
  is '单证种类代码，对应审核系统BGD_NO非空格01；CKHW_DLZM_NO非空格03；CKHW_WTZM_NO非空格07';
comment on column SB_OTHER_BOTH_DZXXSBB.dzhm
  is '单证号码，对应审核系统BGD_NO、CKHW_DLZM_NO、CKHW_WTZM_NO的非空格值';
comment on column SB_OTHER_BOTH_DZXXSBB.jhpzh
  is '对应审核系统PZHM';
comment on column SB_OTHER_BOTH_DZXXSBB.shflag
  is '对应审核系统SH_FLAG';
comment on column SB_OTHER_BOTH_DZXXSBB.errflag
  is '对应审核系统ERR_FLAG';
comment on column SB_OTHER_BOTH_DZXXSBB.cqsbflag
  is '对应审核系统CQSH_FLAG';

prompt
prompt Creating table SB_SBXX_FKSJ
prompt ===========================
prompt
create table SB_SBXX_FKSJ
(
  id   NUMBER(18) not null,
  fkbw BLOB,
  bwgs VARCHAR2(10),
  fklx CHAR(1)
)
;
comment on column SB_SBXX_FKSJ.fklx
  is '反馈类型  1：预审 2：依职权 ';
alter table SB_SBXX_FKSJ
  add constraint PK_SB_SBXX_FKSJ primary key (ID);

prompt
prompt Creating table SB_SBXX_HZ
prompt =========================
prompt
create table SB_SBXX_HZ
(
  id       NUMBER(18) not null,
  uuid     VARCHAR2(50),
  nsrdzdah NUMBER(20) not null,
  sbywb_dm VARCHAR2(20) not null,
  sssq     CHAR(6),
  sbpc     NUMBER(9),
  sbrq     DATE,
  sbzt_dm  CHAR(2) not null,
  lzhj     VARCHAR2(50),
  fkrq     DATE,
  fkxx     VARCHAR2(255),
  fjsl     NUMBER(9),
  qybj     CHAR(1) not null,
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
  sbr      VARCHAR2(50),
  sbfs     CHAR(1),
  sbcs     NUMBER(9) default 0,
  zzsbb    CHAR(1),
  sbtmse   NUMBER(16,2)
)
;
comment on column SB_SBXX_HZ.uuid
  is '提取锁定uuid';
comment on column SB_SBXX_HZ.nsrdzdah
  is '纳税人电子档案号';
comment on column SB_SBXX_HZ.sbywb_dm
  is '申报状态代码';
comment on column SB_SBXX_HZ.sssq
  is '所属时期';
comment on column SB_SBXX_HZ.sbpc
  is '申报批次';
comment on column SB_SBXX_HZ.sbrq
  is '申报日期';
comment on column SB_SBXX_HZ.sbzt_dm
  is '初始：20：已申报受理；2A：网报方式，待调用网报接口；2B：文件读入方式，待人工读入文件；21：成功进入审核系统，待首次调用查询接口；30：审核系统中各环节；40：审核退回；41：申报异常；42：预审通过；43：预审有疑点';
comment on column SB_SBXX_HZ.lzhj
  is '流转环节';
comment on column SB_SBXX_HZ.fkrq
  is '反馈日期';
comment on column SB_SBXX_HZ.fkxx
  is '反馈信息';
comment on column SB_SBXX_HZ.fjsl
  is '附件数量';
comment on column SB_SBXX_HZ.qybj
  is '启用标记';
comment on column SB_SBXX_HZ.bz
  is '备注';
comment on column SB_SBXX_HZ.cjrq
  is '创建日期';
comment on column SB_SBXX_HZ.xgrq
  is '修改日期';
comment on column SB_SBXX_HZ.tqbz
  is '提取标志';
comment on column SB_SBXX_HZ.tqsj
  is '提取时间';
comment on column SB_SBXX_HZ.tqcs
  is '提取次数';
comment on column SB_SBXX_HZ.sbyy
  is '失败原因';
comment on column SB_SBXX_HZ.yxj
  is '优先级';
comment on column SB_SBXX_HZ.sbsj
  is '申报时间';
comment on column SB_SBXX_HZ.tbsj
  is '同步时间';
comment on column SB_SBXX_HZ.lcslid
  is '流程实例ID';
comment on column SB_SBXX_HZ.tbcs
  is '同步次数';
comment on column SB_SBXX_HZ.sbzl_dm
  is '申报种类代码 ';
comment on column SB_SBXX_HZ.sbtype
  is '申报种类 正式申报：ZSSB    预申报：YSB';
comment on column SB_SBXX_HZ.ysbz
  is '预审标记';
comment on column SB_SBXX_HZ.ystqsj
  is '预审提取时间';
comment on column SB_SBXX_HZ.yswcsj
  is '预审完成时间';
comment on column SB_SBXX_HZ.ystqcs
  is '预审提取次数';
comment on column SB_SBXX_HZ.bwzy
  is '报文摘要';
comment on column SB_SBXX_HZ.ysjg
  is '预审结果   0:无疑点；1：只有可挑过疑点 ;2：有不可挑过疑点';
comment on column SB_SBXX_HZ.sbr
  is '申报人';
comment on column SB_SBXX_HZ.sbfs
  is '申报方式';
comment on column SB_SBXX_HZ.sbcs
  is '申报次数，记录云平台正式申报提交次数，每正式申报该值+1';
comment on column SB_SBXX_HZ.zzsbb
  is '增值税申报表  0: 金三系统中已经全申报    1：审核系统中已经全申    空：没有全申报';
create index IDX_SB_SBXX_HZ_LCSLID on SB_SBXX_HZ (LCSLID);
create index IDX_SB_SBXX_HZ_SBZT on SB_SBXX_HZ (SBZT_DM);
create index IX_SB_SBXX_HZ_NSS on SB_SBXX_HZ (NSRDZDAH, SSSQ, SBYWB_DM);
alter table SB_SBXX_HZ
  add constraint PK_SB_SBXX_HZ primary key (ID);

prompt
prompt Creating table SB_SBXX_LOG
prompt ==========================
prompt
create table SB_SBXX_LOG
(
  fssj     TIMESTAMP(6) not null,
  sbid     NUMBER(18) not null,
  nsrdzdah NUMBER(20) not null,
  sbywb_dm VARCHAR2(20),
  sssq     CHAR(6),
  sbpc     NUMBER(9),
  sbzt_dm  CHAR(2),
  fkxx     VARCHAR2(255),
  sbyy     VARCHAR2(1000),
  lcslid   VARCHAR2(50),
  czlx     VARCHAR2(20)
)
;
create index IDX_SB_SBXX_LOG_NSRDZDAH on SB_SBXX_LOG (NSRDZDAH);

prompt
prompt Creating table SB_SBXX_SBSJ
prompt ===========================
prompt
create table SB_SBXX_SBSJ
(
  id   NUMBER(18) not null,
  sbbw BLOB,
  bwgs VARCHAR2(10),
  bwzy VARCHAR2(200),
  bwqm CLOB,
  mwzy VARCHAR2(200)
)
;
comment on column SB_SBXX_SBSJ.bwzy
  is '报文摘要';
comment on column SB_SBXX_SBSJ.bwqm
  is '报文签名';
comment on column SB_SBXX_SBSJ.mwzy
  is '明文';
alter table SB_SBXX_SBSJ
  add constraint PK_SB_SBXX_SBSJ primary key (ID);

prompt
prompt Creating table SHZS_ETL_SWRY
prompt ============================
prompt
create table SHZS_ETL_SWRY
(
  swry_dm   VARCHAR2(11),
  swrysf_dm VARCHAR2(32) not null,
  swrymc    VARCHAR2(113),
  swjg_dm   VARCHAR2(18),
  gw_dm     VARCHAR2(18) not null,
  gwxh      VARCHAR2(32),
  sfswjgdm  VARCHAR2(11)
)
;
comment on column SHZS_ETL_SWRY.sfswjgdm
  is '身份税务机关代码.00到科室
';
alter table SHZS_ETL_SWRY
  add primary key (SWRYSF_DM, GW_DM);

prompt
prompt Creating table SHZS_WP_SWRY
prompt ===========================
prompt
create table SHZS_WP_SWRY
(
  id       NUMBER not null,
  sfdm     VARCHAR2(32),
  swrymc   VARCHAR2(113),
  status   CHAR(1),
  remark   VARCHAR2(100),
  crtime   DATE,
  uptime   DATE,
  gwxh     VARCHAR2(32),
  swjgdm   VARCHAR2(18),
  gwdm     VARCHAR2(18),
  swrydm   VARCHAR2(11),
  sfswjgdm VARCHAR2(11)
)
;
comment on column SHZS_WP_SWRY.sfdm
  is '税务人员身份代码';
comment on column SHZS_WP_SWRY.status
  is '状态 0，离线  1，在线';
comment on column SHZS_WP_SWRY.remark
  is '备注';
comment on column SHZS_WP_SWRY.crtime
  is '创建时间';
comment on column SHZS_WP_SWRY.uptime
  is '更新时间';
comment on column SHZS_WP_SWRY.gwxh
  is '岗位序号';
comment on column SHZS_WP_SWRY.swjgdm
  is '税务机关代码,0000到区县';
comment on column SHZS_WP_SWRY.gwdm
  is '岗位代码';
comment on column SHZS_WP_SWRY.swrydm
  is '税务人员代码';
comment on column SHZS_WP_SWRY.sfswjgdm
  is '身份税务机关代码.00到科室
';
create index IDX_SWJG_GW on SHZS_WP_SWRY (SWJGDM, GWDM);
create index IDX_SWRYSF on SHZS_WP_SWRY (SFDM, GWDM);
alter table SHZS_WP_SWRY
  add constraint PK_WP_R_ID primary key (ID);

prompt
prompt Creating table SHZS_WP_TASK
prompt ===========================
prompt
create table SHZS_WP_TASK
(
  id       VARCHAR2(32) not null,
  nsrsbh   VARCHAR2(20),
  nsrmc    VARCHAR2(100),
  swjgdm   VARCHAR2(11),
  swsxdm   VARCHAR2(32),
  ssqpc    VARCHAR2(10),
  sbrq     DATE,
  wpsj     DATE,
  wpsfdm   VARCHAR2(32),
  wpdx     VARCHAR2(18),
  wpjg     VARCHAR2(10),
  wpr      VARCHAR2(18),
  wpdxqyfz VARCHAR2(18),
  lcslid   VARCHAR2(32),
  jdmode   CHAR(1),
  status   CHAR(1)
)
;
comment on column SHZS_WP_TASK.id
  is '同zj_mh.mh_rwxx表gzxid值一致';
comment on column SHZS_WP_TASK.nsrsbh
  is '企业税号';
comment on column SHZS_WP_TASK.nsrmc
  is '企业名称';
comment on column SHZS_WP_TASK.swjgdm
  is '税务机关代码';
comment on column SHZS_WP_TASK.swsxdm
  is '税务事项代码';
comment on column SHZS_WP_TASK.ssqpc
  is '所属期批次, 调整为：环节（受理、审核、核准）等';
comment on column SHZS_WP_TASK.sbrq
  is '申报日期';
comment on column SHZS_WP_TASK.wpsj
  is '委派时间';
comment on column SHZS_WP_TASK.wpsfdm
  is '委派对象身份代码';
comment on column SHZS_WP_TASK.wpdx
  is '委派对象名称';
comment on column SHZS_WP_TASK.wpjg
  is '委派结果';
comment on column SHZS_WP_TASK.wpr
  is '委派人';
comment on column SHZS_WP_TASK.wpdxqyfz
  is '委派对象企业分组';
comment on column SHZS_WP_TASK.lcslid
  is '流程实例ID';
comment on column SHZS_WP_TASK.jdmode
  is '接单方式  1分组 0随机';
comment on column SHZS_WP_TASK.status
  is '状态 0预委派 1委派完成';
alter table SHZS_WP_TASK
  add constraint PK_WP_ID primary key (ID);

prompt
prompt Creating table SYS_CFG_CZRY_FPGL
prompt ================================
prompt
create table SYS_CFG_CZRY_FPGL
(
  id            NUMBER(18) not null,
  czry_dm       VARCHAR2(20) not null,
  swjg_dm       VARCHAR2(200),
  zsjg_dm_set   VARCHAR2(1000),
  flgl_set      VARCHAR2(20),
  jsmode_set    VARCHAR2(20),
  zgswry_dm_set VARCHAR2(200),
  crtime        DATE,
  crname        VARCHAR2(20),
  uptime        DATE,
  upname        VARCHAR2(20),
  qybz          CHAR(1) not null,
  limit_sc      NUMBER(10) default 0,
  limit_wm      NUMBER(10) default 0,
  limit_qt      NUMBER(10) default 0,
  cnt_sc        NUMBER(10),
  cnt_wm        NUMBER(10),
  cnt_qt        NUMBER(10),
  czry_tssh     VARCHAR2(20)
)
;
comment on table SYS_CFG_CZRY_FPGL
  is '审核助手_操作人员分户管理设置';
comment on column SYS_CFG_CZRY_FPGL.id
  is '主键，序列号';
comment on column SYS_CFG_CZRY_FPGL.czry_dm
  is '操作人员代码';
comment on column SYS_CFG_CZRY_FPGL.swjg_dm
  is '税务机关代码';
comment on column SYS_CFG_CZRY_FPGL.zsjg_dm_set
  is '征收机关代码（可多选）';
comment on column SYS_CFG_CZRY_FPGL.flgl_set
  is '分类管理簇: .C.D.';
comment on column SYS_CFG_CZRY_FPGL.jsmode_set
  is '退税计算方式代码簇，例如：.1.2.';
comment on column SYS_CFG_CZRY_FPGL.zgswry_dm_set
  is '专管员代码（可多选）';
comment on column SYS_CFG_CZRY_FPGL.crtime
  is '创建时间';
comment on column SYS_CFG_CZRY_FPGL.crname
  is '创建人员';
comment on column SYS_CFG_CZRY_FPGL.uptime
  is '更新时间';
comment on column SYS_CFG_CZRY_FPGL.upname
  is '更新人员';
comment on column SYS_CFG_CZRY_FPGL.qybz
  is '启用标识';
create unique index UQ_SYS_CFG_CZRY_FPGL on SYS_CFG_CZRY_FPGL (CZRY_DM);
alter table SYS_CFG_CZRY_FPGL
  add constraint PK_SYS_CFG_CZRY_FPGL primary key (ID);

prompt
prompt Creating table SYS_CFG_CZRY_ROLE
prompt ================================
prompt
create table SYS_CFG_CZRY_ROLE
(
  id        NUMBER(18) not null,
  czry_dm   VARCHAR2(20) not null,
  role_dm   VARCHAR2(20) not null,
  crtime    DATE,
  crname    VARCHAR2(20),
  uptime    DATE,
  upname    VARCHAR2(20),
  czry_tssh VARCHAR2(20)
)
;
comment on table SYS_CFG_CZRY_ROLE
  is '权限管理_操作人员对应角色表';
comment on column SYS_CFG_CZRY_ROLE.id
  is '主键，序列号';
comment on column SYS_CFG_CZRY_ROLE.czry_dm
  is '操作人员代码';
comment on column SYS_CFG_CZRY_ROLE.role_dm
  is '角色代码';
comment on column SYS_CFG_CZRY_ROLE.crtime
  is '创建时间';
comment on column SYS_CFG_CZRY_ROLE.crname
  is '创建人员';
comment on column SYS_CFG_CZRY_ROLE.uptime
  is '更新时间';
comment on column SYS_CFG_CZRY_ROLE.upname
  is '更新人员';
create index IDX_SYS_CFG_CZRY_ROLE_CZRY on SYS_CFG_CZRY_ROLE (CZRY_DM);
create index IDX_SYS_CFG_CZRY_ROLE_ROLE on SYS_CFG_CZRY_ROLE (ROLE_DM);
alter table SYS_CFG_CZRY_ROLE
  add constraint PK_SYS_CFG_CZRY_ROLE primary key (ID);

prompt
prompt Creating table SYS_CFG_ROLE_SERVICE
prompt ===================================
prompt
create table SYS_CFG_ROLE_SERVICE
(
  id         NUMBER(18) not null,
  role_dm    VARCHAR2(20) not null,
  service_dm VARCHAR2(200) not null,
  crtime     DATE,
  crname     VARCHAR2(20),
  uptime     DATE,
  upname     VARCHAR2(20)
)
;
comment on table SYS_CFG_ROLE_SERVICE
  is '权限管理_角色服务对应表';
comment on column SYS_CFG_ROLE_SERVICE.id
  is '主键，序列号';
comment on column SYS_CFG_ROLE_SERVICE.role_dm
  is '角色代码';
comment on column SYS_CFG_ROLE_SERVICE.service_dm
  is '服务代码';
comment on column SYS_CFG_ROLE_SERVICE.crtime
  is '创建时间';
comment on column SYS_CFG_ROLE_SERVICE.crname
  is '创建人员';
comment on column SYS_CFG_ROLE_SERVICE.uptime
  is '更新时间';
comment on column SYS_CFG_ROLE_SERVICE.upname
  is '更新人员';
create index SYS_CFG_ROLE_SERVICE_ROLE on SYS_CFG_ROLE_SERVICE (ROLE_DM);
create index SYS_CFG_ROLE_SERVICE_SRV on SYS_CFG_ROLE_SERVICE (SERVICE_DM);
alter table SYS_CFG_ROLE_SERVICE
  add constraint PK_SYS_CFG_ROLE_SERVICE primary key (ID);

prompt
prompt Creating table SYS_CFG_SBDR_FILEMODE
prompt ====================================
prompt
create table SYS_CFG_SBDR_FILEMODE
(
  id         NUMBER(18) not null,
  codetype   VARCHAR2(10) not null,
  code       VARCHAR2(20) not null,
  flgl_set   VARCHAR2(20),
  jsmode_set VARCHAR2(20),
  sbywb_set  VARCHAR2(1000),
  crtime     DATE,
  crname     VARCHAR2(20),
  uptime     DATE,
  upname     VARCHAR2(20),
  qybz       CHAR(1) not null,
  jd_mode    CHAR(1),
  yj_close   CHAR(1)
)
;
comment on table SYS_CFG_SBDR_FILEMODE
  is '审核助手_文件模式接口设置';
comment on column SYS_CFG_SBDR_FILEMODE.id
  is '主键，序列号';
comment on column SYS_CFG_SBDR_FILEMODE.codetype
  is '代码类型：GS--所属税务机关 ZS--征收税务机关 HG--海关代码 NS--纳税人识别号';
comment on column SYS_CFG_SBDR_FILEMODE.code
  is '代码值';
comment on column SYS_CFG_SBDR_FILEMODE.flgl_set
  is '分类管理簇: .C.D.';
comment on column SYS_CFG_SBDR_FILEMODE.jsmode_set
  is '退税计算方式代码簇，例如：.1.2.';
comment on column SYS_CFG_SBDR_FILEMODE.sbywb_set
  is '申报业务编码簇，格式：.业务表代码1.业务表代码2. 循环，例如：.A0301001.A0305001.';
comment on column SYS_CFG_SBDR_FILEMODE.crtime
  is '创建时间';
comment on column SYS_CFG_SBDR_FILEMODE.crname
  is '创建人员';
comment on column SYS_CFG_SBDR_FILEMODE.uptime
  is '更新时间';
comment on column SYS_CFG_SBDR_FILEMODE.upname
  is '更新人员';
comment on column SYS_CFG_SBDR_FILEMODE.qybz
  is '启用标识';
comment on column SYS_CFG_SBDR_FILEMODE.jd_mode
  is '接单模式  1-随机分单（预设接单人） ';
comment on column SYS_CFG_SBDR_FILEMODE.yj_close
  is '预警信息关闭显示 1关闭；空或0不关闭';
create unique index UQ_SYS_CFG_SBDR_FILEMODE on SYS_CFG_SBDR_FILEMODE (CODETYPE, CODE);
alter table SYS_CFG_SBDR_FILEMODE
  add constraint PK_SYS_CFG_SBDR_FILEMODE primary key (ID);

prompt
prompt Creating table SYS_TPI_AUTHOR
prompt =============================
prompt
create table SYS_TPI_AUTHOR
(
  id      NUMBER(10) not null,
  appid   VARCHAR2(30) not null,
  account VARCHAR2(30) not null,
  passwd  VARCHAR2(30) not null,
  ipset   VARCHAR2(1000),
  qybz    CHAR(1) not null,
  note    VARCHAR2(100),
  qxswjg  VARCHAR2(11)
)
;
comment on column SYS_TPI_AUTHOR.id
  is '序号';
comment on column SYS_TPI_AUTHOR.appid
  is '第三方应用标识';
comment on column SYS_TPI_AUTHOR.account
  is '授权帐号';
comment on column SYS_TPI_AUTHOR.passwd
  is '密码';
comment on column SYS_TPI_AUTHOR.ipset
  is '已绑定的IP集合，用逗号分割';
comment on column SYS_TPI_AUTHOR.qybz
  is 'Y有效 N无效';
comment on column SYS_TPI_AUTHOR.note
  is '备注描述';
comment on column SYS_TPI_AUTHOR.qxswjg
  is '权限税务机关';
alter table SYS_TPI_AUTHOR
  add primary key (ID);

prompt
prompt Creating table SYS_TPI_LOG
prompt ==========================
prompt
create table SYS_TPI_LOG
(
  id       NUMBER(18) not null,
  appid    VARCHAR2(30),
  account  VARCHAR2(30),
  ip       VARCHAR2(30),
  tranid   VARCHAR2(18),
  funcname VARCHAR2(100),
  reqtime  DATE,
  rsptime  DATE,
  reqnr    VARCHAR2(4000),
  rspnr    VARCHAR2(4000),
  clbz     CHAR(1)
)
;
comment on table SYS_TPI_LOG
  is '第三方接口交易日志表';
comment on column SYS_TPI_LOG.id
  is '序号';
comment on column SYS_TPI_LOG.appid
  is '第三方应用标识';
comment on column SYS_TPI_LOG.account
  is '帐号';
comment on column SYS_TPI_LOG.ip
  is '交易客户端IP';
comment on column SYS_TPI_LOG.tranid
  is '交易流水号';
comment on column SYS_TPI_LOG.funcname
  is '交易接口名';
comment on column SYS_TPI_LOG.reqtime
  is '请求时间';
comment on column SYS_TPI_LOG.rsptime
  is '响应时间';
comment on column SYS_TPI_LOG.reqnr
  is '请求内容';
comment on column SYS_TPI_LOG.rspnr
  is '响应内容';
comment on column SYS_TPI_LOG.clbz
  is '1成功 0失败';
alter table SYS_TPI_LOG
  add primary key (ID);

prompt
prompt Creating table TB_CKTS_BICODE_SUB
prompt =================================
prompt
create table TB_CKTS_BICODE_SUB
(
  code        VARCHAR2(3) not null,
  item_no     VARCHAR2(10),
  hl_ym       VARCHAR2(6) not null,
  hl_rmb      NUMBER(10,5) default (0),
  hl_usd      NUMBER(10,5) default (0),
  hl_range    NUMBER(5,2) default (0),
  st_date     DATE,
  end_date    DATE,
  readin_date DATE,
  tbpc        NUMBER(18) not null,
  tberr       VARCHAR2(500)
)
;
alter table TB_CKTS_BICODE_SUB
  add constraint PK_TB_CKTS_BICODE_SUB primary key (CODE, HL_YM);

prompt
prompt Creating table TB_CKTS_GC_JLJG_JHFPL
prompt ====================================
prompt
create table TB_CKTS_GC_JLJG_JHFPL
(
  uuid        VARCHAR2(32) not null,
  cpcode      VARCHAR2(32) default ' ' not null,
  sb_ym       VARCHAR2(6) default ' ' not null,
  jhfpl       NUMBER(9,5) default 0,
  jhfpl_new   NUMBER(9,5) default 0,
  op_date     DATE default TO_DATE('01/01/1900','DD/MM/YYYY'),
  readin_date DATE,
  tbpc        NUMBER(18) not null,
  tberr       VARCHAR2(500)
)
;
create index IDX_GC_JLJG_JHFPL_CPCODE on TB_CKTS_GC_JLJG_JHFPL (CPCODE);
create index IDX_GC_JLJG_JHFPL_RDINDATE on TB_CKTS_GC_JLJG_JHFPL (READIN_DATE, TBPC);
alter table TB_CKTS_GC_JLJG_JHFPL
  add constraint PK_TB_CKTS_GC_JLJG_JHFPL primary key (UUID);

prompt
prompt Creating table TB_CKTS_GC_SQ_TXFW
prompt =================================
prompt
create table TB_CKTS_GC_SQ_TXFW
(
  uuid        VARCHAR2(32) not null,
  cpcode      VARCHAR2(32) default ' ' not null,
  txfw_flag   VARCHAR2(1) default ' ',
  djr         VARCHAR2(75) default ' ',
  djr_duty    VARCHAR2(300) default ' ',
  djr_tel     VARCHAR2(60) default ' ',
  email1      VARCHAR2(50) default ' ',
  djr2        VARCHAR2(75) default ' ',
  djr2_duty   VARCHAR2(300) default ' ',
  djr2_tel    VARCHAR2(60) default ' ',
  email2      VARCHAR2(50) default ' ',
  readin_date DATE,
  tbpc        NUMBER(18) not null,
  tberr       VARCHAR2(500)
)
;
create index IDX_CKTS_GC_SQ_TXFW_CPCODE on TB_CKTS_GC_SQ_TXFW (CPCODE);
create index IDX_CKTS_GC_SQ_TXFW_RDINDATE on TB_CKTS_GC_SQ_TXFW (READIN_DATE, TBPC);
alter table TB_CKTS_GC_SQ_TXFW
  add constraint PK_TB_CKTS_GC_SQ_TXFW primary key (UUID);

prompt
prompt Creating table TB_CKTS_HISTORY_ZJDLZM
prompt =====================================
prompt
create table TB_CKTS_HISTORY_ZJDLZM
(
  wt_cpcode   VARCHAR2(32) not null,
  dlzm_no     VARCHAR2(20) default ' ' not null,
  bgd_no      VARCHAR2(21) default ' ',
  lj_date     DATE default TO_DATE('1900-01-01','YYYY-MM-DD'),
  tdcode      VARCHAR2(4) default ' ' not null,
  cmcode      VARCHAR2(12) default ' ',
  cmname      VARCHAR2(254) default ' ',
  cmunit      VARCHAR2(9) default ' ',
  bg_qnt      NUMBER(15,4) default (0),
  bicode      VARCHAR2(3) default ' ' not null,
  usd_amt     NUMBER(15,2) default (0),
  readin_date DATE,
  tbpc        NUMBER(18) not null,
  tberr       VARCHAR2(500)
)
;
create index IDX_HISTORY_ZJDLZM_RDINDATE on TB_CKTS_HISTORY_ZJDLZM (READIN_DATE, TBPC);
alter table TB_CKTS_HISTORY_ZJDLZM
  add constraint PK_TB_CKTS_HISTORY_ZJDLZM primary key (WT_CPCODE, DLZM_NO);

prompt
prompt Creating table TB_DTBSJ
prompt =======================
prompt
create table TB_DTBSJ
(
  id      NUMBER(18) not null,
  tblx_dm VARCHAR2(50) not null,
  mainid  NUMBER(18) not null,
  cjsj    TIMESTAMP(6) not null,
  tqbz    VARCHAR2(100),
  tqsj    TIMESTAMP(6),
  tbcs    NUMBER(9) not null,
  sbyy    VARCHAR2(2000),
  yxj     NUMBER(9) default 0 not null
)
;
comment on table TB_DTBSJ
  is '待同步数据表';
comment on column TB_DTBSJ.id
  is '序号';
comment on column TB_DTBSJ.tblx_dm
  is '同步类型代码';
comment on column TB_DTBSJ.mainid
  is '待同步数据主ID值';
comment on column TB_DTBSJ.cjsj
  is '创建时间';
comment on column TB_DTBSJ.tqbz
  is '同步标志';
comment on column TB_DTBSJ.tqsj
  is '同步时间';
comment on column TB_DTBSJ.tbcs
  is '同步次数';
comment on column TB_DTBSJ.sbyy
  is '失败原因';
comment on column TB_DTBSJ.yxj
  is '优先级';
create index IX_TB_DTBSJ_YXJ2 on TB_DTBSJ (YXJ);
alter table TB_DTBSJ
  add constraint PK_TB_DTBSJ_2 primary key (ID);

prompt
prompt Creating table TB_DTBSJ_ERR
prompt ===========================
prompt
create table TB_DTBSJ_ERR
(
  id      NUMBER(18) not null,
  tblx_dm VARCHAR2(50) not null,
  mainid  NUMBER(18) not null,
  cjsj    TIMESTAMP(6) not null,
  tqbz    VARCHAR2(100),
  tqsj    TIMESTAMP(6),
  tbcs    NUMBER(9) not null,
  sbyy    VARCHAR2(2000),
  yxj     NUMBER(9) default 0 not null
)
;
alter table TB_DTBSJ_ERR
  add constraint PK_TB_DTBSJ_ERR primary key (ID);

prompt
prompt Creating table TB_DTBSJ_LOG
prompt ===========================
prompt
create table TB_DTBSJ_LOG
(
  id      NUMBER(18) not null,
  tblx_dm VARCHAR2(50),
  sbid    NUMBER(18),
  cjsj    TIMESTAMP(6)
)
;
comment on column TB_DTBSJ_LOG.id
  is '主键';
comment on column TB_DTBSJ_LOG.tblx_dm
  is '同步类型';
comment on column TB_DTBSJ_LOG.sbid
  is '申报id,对应tb_dtbsj表中的mainid';
alter table TB_DTBSJ_LOG
  add constraint PK_TB_DTBSJ_LOG primary key (ID);

prompt
prompt Creating table TB_GS_NSRBAT
prompt ===========================
prompt
create table TB_GS_NSRBAT
(
  qyhgdm VARCHAR2(32) not null,
  bz     VARCHAR2(100)
)
;
comment on column TB_GS_NSRBAT.qyhgdm
  is '企业海关代码';
alter table TB_GS_NSRBAT
  add constraint PK_GS_NSRBAT primary key (QYHGDM);

prompt
prompt Creating table TB_GS_NSRXX
prompt ==========================
prompt
create table TB_GS_NSRXX
(
  qyhgdm     VARCHAR2(32),
  nsrmc      VARCHAR2(200),
  tbrq       DATE,
  yxbz       CHAR(1) default 'Y',
  nsrdzdah   NUMBER(20) not null,
  cpcode     VARCHAR2(32),
  cpcodetssh VARCHAR2(32)
)
;
comment on table TB_GS_NSRXX
  is '同步纳税人名单信息';
comment on column TB_GS_NSRXX.qyhgdm
  is '企业海关代码';
comment on column TB_GS_NSRXX.nsrmc
  is '企业名称';
comment on column TB_GS_NSRXX.tbrq
  is '发票首次同步起始日期';
comment on column TB_GS_NSRXX.yxbz
  is '有效标志，Y有效   N无效，不同步';
comment on column TB_GS_NSRXX.nsrdzdah
  is '纳税人电子档案号';
comment on column TB_GS_NSRXX.cpcode
  is '核心征管系统TO_CHAR(DJXH)';
comment on column TB_GS_NSRXX.cpcodetssh
  is '老审核系统CPCODE';
alter table TB_GS_NSRXX
  add constraint PK_TB_GS_NSRXX primary key (NSRDZDAH);

prompt
prompt Creating table TB_GS_TBBZ
prompt =========================
prompt
create table TB_GS_TBBZ
(
  tblx_dm  VARCHAR2(50) not null,
  tbnr     VARCHAR2(20),
  tbrq     DATE,
  tbsj     DATE,
  tbcs     NUMBER(18) default 0 not null,
  sbyy     VARCHAR2(600),
  nsrdzdah NUMBER(20) not null,
  qyhgdm   VARCHAR2(32) not null
)
;
comment on table TB_GS_TBBZ
  is '国税待同步标志表';
comment on column TB_GS_TBBZ.tblx_dm
  is '同步类型';
comment on column TB_GS_TBBZ.tbnr
  is '同步内容，NSRSBH 或 ALL';
comment on column TB_GS_TBBZ.tbrq
  is '待同步起始日期';
comment on column TB_GS_TBBZ.tbsj
  is '同步时间';
comment on column TB_GS_TBBZ.tbcs
  is '同步次数';
comment on column TB_GS_TBBZ.sbyy
  is '失败原因';
comment on column TB_GS_TBBZ.nsrdzdah
  is '纳税人电子档案号，可空';
comment on column TB_GS_TBBZ.qyhgdm
  is '企业海关代码或企业纳税人识别号';
create index IDX_TB_GS_TBBZ on TB_GS_TBBZ (TBLX_DM, TBNR);
alter table TB_GS_TBBZ
  add constraint PK_TB_GS_TBBZ primary key (TBLX_DM, NSRDZDAH, QYHGDM);

prompt
prompt Creating table TB_GS_TBSB_RZ
prompt ============================
prompt
create table TB_GS_TBSB_RZ
(
  tblx_dm VARCHAR2(50),
  sbrq    DATE default sysdate,
  sbyy    VARCHAR2(600)
)
;
comment on table TB_GS_TBSB_RZ
  is '国税待同步错误日志';
comment on column TB_GS_TBSB_RZ.tblx_dm
  is '同步类型';
comment on column TB_GS_TBSB_RZ.sbrq
  is '失败日期';
comment on column TB_GS_TBSB_RZ.sbyy
  is '失败原因';

prompt
prompt Creating table TB_GS_TBZT
prompt =========================
prompt
create table TB_GS_TBZT
(
  tblx_dm VARCHAR2(50) not null,
  qssj    DATE,
  zzsj    DATE,
  zs      NUMBER(18) default 0 not null,
  dqs     NUMBER(18) default 0 not null,
  sbyy    VARCHAR2(600),
  tbnr    VARCHAR2(32)
)
;
comment on table TB_GS_TBZT
  is '国税同步状态表';
comment on column TB_GS_TBZT.tblx_dm
  is '同步类型';
comment on column TB_GS_TBZT.qssj
  is '同步起始日期';
comment on column TB_GS_TBZT.zzsj
  is '同步终止日期';
comment on column TB_GS_TBZT.zs
  is '总数';
comment on column TB_GS_TBZT.dqs
  is '当前数';
comment on column TB_GS_TBZT.sbyy
  is '失败原因';
comment on column TB_GS_TBZT.tbnr
  is '同步内容，NSRSBH 或 ALL';
alter table TB_GS_TBZT
  add constraint PK_TB_GS_TBZT primary key (TBLX_DM);

prompt
prompt Creating table TB_LOG_ETL_CHANNEL
prompt =================================
prompt
create table TB_LOG_ETL_CHANNEL
(
  id_batch             INTEGER,
  channel_id           VARCHAR2(255),
  log_date             DATE,
  logging_object_type  VARCHAR2(255),
  object_name          VARCHAR2(255),
  object_copy          VARCHAR2(255),
  repository_directory VARCHAR2(255),
  filename             VARCHAR2(255),
  object_id            VARCHAR2(255),
  object_revision      VARCHAR2(255),
  parent_channel_id    VARCHAR2(255),
  root_channel_id      VARCHAR2(255)
)
;

prompt
prompt Creating table TB_LOG_ETL_ITEM
prompt ==============================
prompt
create table TB_LOG_ETL_ITEM
(
  id_batch        INTEGER,
  channel_id      VARCHAR2(255),
  log_date        DATE,
  transname       VARCHAR2(255),
  stepname        VARCHAR2(255),
  lines_read      INTEGER,
  lines_written   INTEGER,
  lines_updated   INTEGER,
  lines_input     INTEGER,
  lines_output    INTEGER,
  lines_rejected  INTEGER,
  errors          INTEGER,
  result          CHAR(1),
  nr_result_rows  INTEGER,
  nr_result_files INTEGER
)
;
create index IDX_TB_LOG_ETL_ITEM_1 on TB_LOG_ETL_ITEM (ID_BATCH);

prompt
prompt Creating table TB_LOG_ETL_JOB
prompt =============================
prompt
create table TB_LOG_ETL_JOB
(
  id_job         INTEGER,
  channel_id     VARCHAR2(255),
  jobname        VARCHAR2(255),
  status         VARCHAR2(15),
  lines_read     INTEGER,
  lines_written  INTEGER,
  lines_updated  INTEGER,
  lines_input    INTEGER,
  lines_output   INTEGER,
  lines_rejected INTEGER,
  errors         INTEGER,
  startdate      DATE,
  enddate        DATE,
  logdate        DATE,
  depdate        DATE,
  replaydate     DATE,
  log_field      CLOB
)
;
create index IDX_TB_LOG_ETL_JOB_1 on TB_LOG_ETL_JOB (ID_JOB);
create index IDX_TB_LOG_ETL_JOB_2 on TB_LOG_ETL_JOB (ERRORS, STATUS, JOBNAME);

prompt
prompt Creating table TJ_CLBZ
prompt ======================
prompt
create table TJ_CLBZ
(
  ssyf    VARCHAR2(6) not null,
  tjlx    VARCHAR2(50) not null,
  cljg    CHAR(1) not null,
  jgnr    VARCHAR2(4000),
  clsjs   DATE,
  clsje   DATE,
  swjg_dm VARCHAR2(11)
)
;
comment on table TJ_CLBZ
  is '统计日志表';
comment on column TJ_CLBZ.ssyf
  is '所属月份';
comment on column TJ_CLBZ.tjlx
  is '统计类型';
comment on column TJ_CLBZ.cljg
  is '处理结果';
comment on column TJ_CLBZ.jgnr
  is '结果内容';
comment on column TJ_CLBZ.clsjs
  is '开始处理时间';
comment on column TJ_CLBZ.clsje
  is '结束处理时间';
comment on column TJ_CLBZ.swjg_dm
  is '区县税务机关代码';
create index IDX_TJ_CLBZ_RZYF on TJ_CLBZ (SSYF, TJLX);

prompt
prompt Creating table TJ_TSQK_NSR
prompt ==========================
prompt
create table TJ_TSQK_NSR
(
  qyhgdm    VARCHAR2(32),
  cpcode    VARCHAR2(32),
  nsrsbh    VARCHAR2(32),
  nsrmc     VARCHAR2(4000),
  zcdz      VARCHAR2(200),
  nsrdh     VARCHAR2(20),
  tsjsfs_dm CHAR(1),
  hy_dm     VARCHAR2(4),
  djzclx_dm VARCHAR2(200),
  swjg_dm   VARCHAR2(11),
  zx_flag   VARCHAR2(1),
  bjtssbcs  NUMBER(12),
  tjnd      VARCHAR2(4),
  tjyf      VARCHAR2(4),
  ckssed    NUMBER(12,2),
  cksser    NUMBER(12,2),
  zzstse    NUMBER(12,2),
  zzsmde    NUMBER(12,2),
  xfstse    NUMBER(12,2),
  xfsmde    NUMBER(12,2),
  sbcs      NUMBER(12),
  bgdfs     NUMBER(12),
  dlzmfs    NUMBER(12),
  zyfpfs    NUMBER(12),
  zyfpje    NUMBER(12,2),
  nsrdzdah  NUMBER(20) not null,
  bgdjed    NUMBER(12,2),
  bgdjer    NUMBER(12,2),
  bsy1_mc   VARCHAR2(30),
  bsy1_dh   VARCHAR2(20),
  bsy2_mc   VARCHAR2(30),
  bsy2_dh   VARCHAR2(20),
  bgds      NUMBER(12)
)
;
alter table TJ_TSQK_NSR
  add constraint PK_TJ_TSQK_NSR primary key (NSRDZDAH);

prompt
prompt Creating table TJ_TSQK_SWJG
prompt ===========================
prompt
create table TJ_TSQK_SWJG
(
  ssyf               VARCHAR2(6) not null,
  swjg_dm            VARCHAR2(11) not null,
  tjrq               DATE default sysdate not null,
  bjts_ktqys_sc      NUMBER(9) default 0,
  bjts_ktqys_wm      NUMBER(9) default 0,
  bjts_ktqys_ms      NUMBER(9) default 0,
  bjts_ktqys_qt      NUMBER(9) default 0,
  bjts_sbqys_sc      NUMBER(9) default 0,
  bjts_sbqys_wm      NUMBER(9) default 0,
  bjts_sbqys_ms      NUMBER(9) default 0,
  bjts_sbqys_qt      NUMBER(9) default 0,
  tssh_ktqys_sc      NUMBER(9) default 0,
  tssh_ktqys_wm      NUMBER(9) default 0,
  tssh_ktqys_sc_a    NUMBER(9) default 0,
  tssh_ktqys_wm_a    NUMBER(9) default 0,
  tssh_ktqys_sc_b    NUMBER(9) default 0,
  tssh_ktqys_wm_b    NUMBER(9) default 0,
  tssh_ktqys_sc_c    NUMBER(9) default 0,
  tssh_ktqys_wm_c    NUMBER(9) default 0,
  tssh_ktqys_sc_d    NUMBER(9) default 0,
  tssh_ktqys_wm_d    NUMBER(9) default 0,
  tssh_sbqys_sc      NUMBER(9) default 0,
  tssh_sbqys_wm      NUMBER(9) default 0,
  tssh_sbqys_sc_a    NUMBER(9) default 0,
  tssh_sbqys_wm_a    NUMBER(9) default 0,
  tssh_sbqys_sc_b    NUMBER(9) default 0,
  tssh_sbqys_wm_b    NUMBER(9) default 0,
  tssh_sbqys_sc_c    NUMBER(9) default 0,
  tssh_sbqys_wm_c    NUMBER(9) default 0,
  tssh_sbqys_sc_d    NUMBER(9) default 0,
  tssh_sbqys_wm_d    NUMBER(9) default 0,
  tssh_sptse_sc      NUMBER(15,2) default 0,
  tssh_sptse_wm      NUMBER(15,2) default 0,
  tssh_sptse_sc_a    NUMBER(15,2) default 0,
  tssh_sptse_wm_a    NUMBER(15,2) default 0,
  tssh_sptse_sc_b    NUMBER(15,2) default 0,
  tssh_sptse_wm_b    NUMBER(15,2) default 0,
  tssh_sptse_sc_c    NUMBER(15,2) default 0,
  tssh_sptse_wm_c    NUMBER(15,2) default 0,
  tssh_sptse_sc_d    NUMBER(15,2) default 0,
  tssh_sptse_wm_d    NUMBER(15,2) default 0,
  tssh_sptse_sc_md   NUMBER(15,2) default 0,
  tssh_sptse_sc_md_a NUMBER(15,2) default 0,
  tssh_sptse_sc_md_b NUMBER(15,2) default 0,
  tssh_sptse_sc_md_c NUMBER(15,2) default 0,
  tssh_sptse_sc_md_d NUMBER(15,2) default 0
)
;
comment on table TJ_TSQK_SWJG
  is '税务机关退税情况表';
comment on column TJ_TSQK_SWJG.ssyf
  is '所属月份';
comment on column TJ_TSQK_SWJG.swjg_dm
  is '税务机关';
comment on column TJ_TSQK_SWJG.tjrq
  is '统计日期';
comment on column TJ_TSQK_SWJG.bjts_ktqys_sc
  is '便捷退税开通企业数生产';
comment on column TJ_TSQK_SWJG.bjts_ktqys_wm
  is '便捷退税开通企业数外贸';
comment on column TJ_TSQK_SWJG.bjts_ktqys_ms
  is '便捷退税开通企业数免税';
comment on column TJ_TSQK_SWJG.bjts_ktqys_qt
  is '便捷退税开通企业数其他';
comment on column TJ_TSQK_SWJG.bjts_sbqys_sc
  is '便捷退税申报企业数生产';
comment on column TJ_TSQK_SWJG.bjts_sbqys_wm
  is '便捷退税申报企业数外贸';
comment on column TJ_TSQK_SWJG.bjts_sbqys_ms
  is '便捷退税申报企业数免税';
comment on column TJ_TSQK_SWJG.bjts_sbqys_qt
  is '便捷退税申报企业数其他';
comment on column TJ_TSQK_SWJG.tssh_ktqys_sc
  is '审核系统开通企业数生产';
comment on column TJ_TSQK_SWJG.tssh_ktqys_wm
  is '审核系统开通企业数外贸';
comment on column TJ_TSQK_SWJG.tssh_ktqys_sc_a
  is '审核系统开通企业数生产A类';
comment on column TJ_TSQK_SWJG.tssh_ktqys_wm_a
  is '审核系统开通企业数外贸A类';
comment on column TJ_TSQK_SWJG.tssh_ktqys_sc_b
  is '审核系统开通企业数生产B类';
comment on column TJ_TSQK_SWJG.tssh_ktqys_wm_b
  is '审核系统开通企业数外贸B类';
comment on column TJ_TSQK_SWJG.tssh_ktqys_sc_c
  is '审核系统开通企业数生产C类';
comment on column TJ_TSQK_SWJG.tssh_ktqys_wm_c
  is '审核系统开通企业数外贸C类';
comment on column TJ_TSQK_SWJG.tssh_ktqys_sc_d
  is '审核系统开通企业数生产D类';
comment on column TJ_TSQK_SWJG.tssh_ktqys_wm_d
  is '审核系统开通企业数外贸D类';
comment on column TJ_TSQK_SWJG.tssh_sbqys_sc
  is '审核系统申报企业数生产';
comment on column TJ_TSQK_SWJG.tssh_sbqys_wm
  is '审核系统申报企业数外贸';
comment on column TJ_TSQK_SWJG.tssh_sbqys_sc_a
  is '审核系统申报企业数生产A类';
comment on column TJ_TSQK_SWJG.tssh_sbqys_wm_a
  is '审核系统申报企业数外贸A类';
comment on column TJ_TSQK_SWJG.tssh_sbqys_sc_b
  is '审核系统申报企业数生产B类';
comment on column TJ_TSQK_SWJG.tssh_sbqys_wm_b
  is '审核系统申报企业数外贸B类';
comment on column TJ_TSQK_SWJG.tssh_sbqys_sc_c
  is '审核系统申报企业数生产C类';
comment on column TJ_TSQK_SWJG.tssh_sbqys_wm_c
  is '审核系统申报企业数外贸C类';
comment on column TJ_TSQK_SWJG.tssh_sbqys_sc_d
  is '审核系统申报企业数生产D类';
comment on column TJ_TSQK_SWJG.tssh_sbqys_wm_d
  is '审核系统申报企业数外贸D类';
comment on column TJ_TSQK_SWJG.tssh_sptse_sc
  is '审核系统申报退税额生产';
comment on column TJ_TSQK_SWJG.tssh_sptse_wm
  is '审核系统申报退税额外贸';
comment on column TJ_TSQK_SWJG.tssh_sptse_sc_a
  is '审核系统申报退税额生产A类';
comment on column TJ_TSQK_SWJG.tssh_sptse_wm_a
  is '审核系统申报退税额外贸A类';
comment on column TJ_TSQK_SWJG.tssh_sptse_sc_b
  is '审核系统申报退税额生产B类';
comment on column TJ_TSQK_SWJG.tssh_sptse_wm_b
  is '审核系统申报退税额外贸B类';
comment on column TJ_TSQK_SWJG.tssh_sptse_sc_c
  is '审核系统申报退税额生产C类';
comment on column TJ_TSQK_SWJG.tssh_sptse_wm_c
  is '审核系统申报退税额外贸C类';
comment on column TJ_TSQK_SWJG.tssh_sptse_sc_d
  is '审核系统申报退税额生产D类';
comment on column TJ_TSQK_SWJG.tssh_sptse_wm_d
  is '审核系统申报退税额外贸D类';
comment on column TJ_TSQK_SWJG.tssh_sptse_sc_md
  is '审核系统申报退税额生产-免抵';
comment on column TJ_TSQK_SWJG.tssh_sptse_sc_md_a
  is '审核系统申报退税额生产-免抵A类';
comment on column TJ_TSQK_SWJG.tssh_sptse_sc_md_b
  is '审核系统申报退税额生产-免抵B类';
comment on column TJ_TSQK_SWJG.tssh_sptse_sc_md_c
  is '审核系统申报退税额生产-免抵C类';
comment on column TJ_TSQK_SWJG.tssh_sptse_sc_md_d
  is '审核系统申报退税额生产-免抵C类';
alter table TJ_TSQK_SWJG
  add constraint PK_TJ_TSQK_SWJG primary key (SSYF, SWJG_DM);

prompt
prompt Creating table TMP_DMMYQY
prompt =========================
prompt
create table TMP_DMMYQY
(
  id       INTEGER not null,
  qyhgdm   VARCHAR2(32) not null,
  nsrdzdah NUMBER(18)
)
;
alter table TMP_DMMYQY
  add primary key (ID);

prompt
prompt Creating table TMP_DYQY_ZDH
prompt ===========================
prompt
create table TMP_DYQY_ZDH
(
  qyhgdm    VARCHAR2(32),
  nsrsbh    VARCHAR2(32),
  nsrmc     VARCHAR2(400),
  tsjsfs_dm CHAR(1)
)
;

prompt
prompt Creating table TMP_DZBA_DUP
prompt ===========================
prompt
create table TMP_DZBA_DUP
(
  nsrsbh VARCHAR2(20) not null,
  baxh   VARCHAR2(60) not null,
  sbnypc VARCHAR2(10),
  cnt    INTEGER,
  jszt   INTEGER
)
;
alter table TMP_DZBA_DUP
  add primary key (BAXH);

prompt
prompt Creating table TMP_GDD_CKMX
prompt ===========================
prompt
create table TMP_GDD_CKMX
(
  lcslid      VARCHAR2(32) not null,
  cpcode      VARCHAR2(32) not null,
  bgd_no      VARCHAR2(21) not null,
  lj_date     DATE,
  readin_date DATE,
  tssb_date   DATE,
  tskp_date   DATE,
  cmcode      VARCHAR2(20),
  tsflag      CHAR(1),
  bg_qnt      NUMBER(15,4),
  sb_qnt      NUMBER(15,4)
)
;

prompt
prompt Creating table TMP_GDD_NSR
prompt ==========================
prompt
create table TMP_GDD_NSR
(
  nsrsbh   VARCHAR2(20) not null,
  nsrmc    VARCHAR2(80),
  status   VARCHAR2(10),
  nsrdzdah NUMBER(18),
  cpcode   VARCHAR2(32),
  tsjsfs   CHAR(1),
  tse_sb   NUMBER(16,2),
  amt_sb   NUMBER(16,2),
  amt_hg   NUMBER(16,2),
  tse_zh   NUMBER(16,2),
  tse_by   NUMBER(16,2),
  rmb_sb   NUMBER(16,2)
)
;
alter table TMP_GDD_NSR
  add primary key (NSRSBH);

prompt
prompt Creating table TMP_GXJSCPML
prompt ===========================
prompt
create table TMP_GXJSCPML
(
  xh      INTEGER,
  cksp_dm VARCHAR2(20),
  ckspmc  VARCHAR2(75),
  ms      VARCHAR2(3000),
  jsly    VARCHAR2(10),
  bz      VARCHAR2(75)
)
;

prompt
prompt Creating table TMP_HZ_KJBMD
prompt ===========================
prompt
create table TMP_HZ_KJBMD
(
  id       INTEGER not null,
  nsrmc    VARCHAR2(100),
  nsrsbh   VARCHAR2(20),
  nsrdzdah NUMBER(18),
  swjg_dm  VARCHAR2(11)
)
;
alter table TMP_HZ_KJBMD
  add primary key (ID);

prompt
prompt Creating table TMP_LX_NSRXX
prompt ===========================
prompt
create table TMP_LX_NSRXX
(
  id        INTEGER not null,
  nsrsbh    VARCHAR2(20) not null,
  qyhgdm    VARCHAR2(10),
  nsrmc     VARCHAR2(80),
  yhmc      VARCHAR2(80),
  yhzh      VARCHAR2(30),
  fddbrxm   VARCHAR2(50),
  fddbryddh VARCHAR2(30),
  bsy1      VARCHAR2(50),
  bsy1dh    VARCHAR2(30),
  swjg_mc   VARCHAR2(80),
  swjg_dm   VARCHAR2(20),
  tsjsfs    CHAR(1),
  flglcd    CHAR(1),
  zc2_dqjk  NUMBER(16,2)
)
;
alter table TMP_LX_NSRXX
  add primary key (ID);

prompt
prompt Creating table TMP_LX_NSR_SBPC
prompt ==============================
prompt
create table TMP_LX_NSR_SBPC
(
  id     INTEGER not null,
  nsrsbh VARCHAR2(20) not null,
  sssqpc VARCHAR2(10) not null,
  sbrq   DATE,
  hzrq   DATE,
  tse_sb NUMBER(16,2),
  days   NUMBER
)
;
alter table TMP_LX_NSR_SBPC
  add primary key (ID, SSSQPC);

prompt
prompt Creating table TMP_LX_NSR_SPQ5
prompt ==============================
prompt
create table TMP_LX_NSR_SPQ5
(
  id     INTEGER not null,
  nsrsbh VARCHAR2(20) not null,
  seqno  INTEGER not null,
  spdm   VARCHAR2(20),
  spmc   VARCHAR2(80),
  usdamt NUMBER(16,2)
)
;
alter table TMP_LX_NSR_SPQ5
  add primary key (ID, SEQNO);

prompt
prompt Creating table TMP_NSRA
prompt =======================
prompt
create table TMP_NSRA
(
  nsrsbh VARCHAR2(20) not null,
  bz     CHAR(1)
)
;

prompt
prompt Creating table TMP_NSRXX
prompt ========================
prompt
create table TMP_NSRXX
(
  xh     NUMBER(20) not null,
  nsrmc  VARCHAR2(200),
  nsrsbh VARCHAR2(20),
  dq     VARCHAR2(20),
  lx     VARCHAR2(20),
  djxh   NUMBER(20),
  qyhgdm VARCHAR2(20),
  shxyno VARCHAR2(20)
)
;
alter table TMP_NSRXX
  add primary key (XH);

prompt
prompt Creating table TMP_NSRXX_DZBA
prompt =============================
prompt
create table TMP_NSRXX_DZBA
(
  nsrsbh VARCHAR2(20),
  sbnypc VARCHAR2(20),
  baxh   VARCHAR2(50),
  ckywbs NUMBER(10),
  dzfs   NUMBER(10)
)
;

prompt
prompt Creating table TMP_NSRXX_SWJG
prompt =============================
prompt
create table TMP_NSRXX_SWJG
(
  nsrsbh  VARCHAR2(20) not null,
  swjg_dm VARCHAR2(11),
  nsrmc   VARCHAR2(200)
)
;
alter table TMP_NSRXX_SWJG
  add constraint PK_NSRXX_SWJG primary key (NSRSBH);

prompt
prompt Creating table TMP_NSRXX_TJ
prompt ===========================
prompt
create table TMP_NSRXX_TJ
(
  nsrsbh VARCHAR2(32),
  djxh   NUMBER(20) not null,
  ck_amt NUMBER(16,2),
  qbxssr NUMBER(16,2)
)
;
comment on column TMP_NSRXX_TJ.nsrsbh
  is '纳税人识别号';
comment on column TMP_NSRXX_TJ.djxh
  is '登记序号';
comment on column TMP_NSRXX_TJ.ck_amt
  is '美元出口销售额';
comment on column TMP_NSRXX_TJ.qbxssr
  is '全部销售额';
alter table TMP_NSRXX_TJ
  add constraint PK_TMP_NSRXX_TJ_DJXH primary key (DJXH);

prompt
prompt Creating table TMP_NSR_SBPC
prompt ===========================
prompt
create table TMP_NSR_SBPC
(
  nsrmc  VARCHAR2(500) not null,
  ssq    VARCHAR2(100) not null,
  sbpc   VARCHAR2(100) not null,
  nsrsbh VARCHAR2(100),
  djxh   VARCHAR2(100)
)
;
alter table TMP_NSR_SBPC
  add constraint PK_TMP_NSR_SBPC primary key (NSRMC, SSQ, SBPC);

prompt
prompt Creating table TMP_NSR_ZCM
prompt ==========================
prompt
create table TMP_NSR_ZCM
(
  "puid"   VARCHAR2(20) not null,
  "cityid" VARCHAR2(10) not null
)
;

prompt
prompt Creating table TMP_NSR_ZSSWJG
prompt =============================
prompt
create table TMP_NSR_ZSSWJG
(
  id      NUMBER(10) not null,
  qyhgdm  VARCHAR2(20),
  nsrsbh  VARCHAR2(20),
  nsrmc   VARCHAR2(200),
  zsjgdm  VARCHAR2(20),
  zsjgmc  VARCHAR2(100),
  zsjgdm2 VARCHAR2(11)
)
;
alter table TMP_NSR_ZSSWJG
  add primary key (ID);

prompt
prompt Creating table TMP_SBSJ
prompt =======================
prompt
create table TMP_SBSJ
(
  id   NUMBER(18) not null,
  sbbw BLOB,
  bwgs VARCHAR2(10),
  bwzy VARCHAR2(200),
  bwqm CLOB
)
;
alter table TMP_SBSJ
  add constraint PK_TMP_SBSJ primary key (ID);

prompt
prompt Creating table TMP_SB_SBXX_HZ
prompt =============================
prompt
create table TMP_SB_SBXX_HZ
(
  id       NUMBER(18) not null,
  nsrdzdah NUMBER(20) not null,
  sbywb_dm VARCHAR2(20) not null,
  sssq     CHAR(6),
  sbpc     NUMBER(9),
  sbrq     DATE
)
;
create index IDX_1 on TMP_SB_SBXX_HZ (NSRDZDAH);

prompt
prompt Creating table TMP_TJ_CKQYXX
prompt ============================
prompt
create table TMP_TJ_CKQYXX
(
  nsrdzdah  NUMBER(20) not null,
  cpcode    VARCHAR2(32) not null,
  nsrsbh    VARCHAR2(20),
  shxydm    VARCHAR2(20),
  qyhgdm    VARCHAR2(32),
  nsrmc     VARCHAR2(100),
  tsjsfs_dm CHAR(1),
  flglcd    CHAR(1),
  nsrdh     VARCHAR2(20),
  zx_flag   CHAR(1),
  scjydz    VARCHAR2(60),
  hy        VARCHAR2(2),
  djzclx    VARCHAR2(3),
  swjg_dm   VARCHAR2(11),
  nd        VARCHAR2(4),
  ckxse_usd NUMBER(18,2),
  ckxse_rmb NUMBER(18,2),
  tsse_sb   NUMBER(18,2),
  mdse_sb   NUMBER(18,2),
  tsse_zh   NUMBER(18,2),
  mdse_zh   NUMBER(18,2),
  tsse_by   NUMBER(18,2),
  mdse_by   NUMBER(18,2),
  sb_num    NUMBER(10),
  glh_num   NUMBER(10),
  ckmx_num  NUMBER(10),
  jhmx_num  NUMBER(10)
)
;
alter table TMP_TJ_CKQYXX
  add primary key (NSRDZDAH);

prompt
prompt Creating table TMP_TJ_DKQY_BANK
prompt ===============================
prompt
create table TMP_TJ_DKQY_BANK
(
  cpcode    VARCHAR2(32) not null,
  nsrsbh    VARCHAR2(20),
  qyhgdm    VARCHAR2(10),
  nsrmc     VARCHAR2(100),
  tsjsfs_dm CHAR(1),
  bkname    VARCHAR2(100),
  flglcd    CHAR(1),
  nsrdh     VARCHAR2(20),
  scjydz    VARCHAR2(60),
  hy        VARCHAR2(2),
  djzclx    VARCHAR2(3),
  swjg_dm   VARCHAR2(11),
  yh_dm     VARCHAR2(10)
)
;
alter table TMP_TJ_DKQY_BANK
  add primary key (CPCODE);

prompt
prompt Creating table TMP_TJ_DKQY_HXYH
prompt ===============================
prompt
create table TMP_TJ_DKQY_HXYH
(
  cpcode    VARCHAR2(32) not null,
  nsrsbh    VARCHAR2(20),
  qyhgdm    VARCHAR2(10),
  nsrmc     VARCHAR2(100),
  tsjsfs_dm CHAR(1),
  bkname    VARCHAR2(100),
  flglcd    CHAR(1),
  nsrdh     VARCHAR2(20),
  scjydz    VARCHAR2(60),
  hy        VARCHAR2(2),
  djzclx    VARCHAR2(3),
  swjg_dm   VARCHAR2(11),
  nd        VARCHAR2(4),
  ckxse_usd NUMBER(18,2),
  tsse_sb   NUMBER(18,2),
  mdse_sb   NUMBER(18,2),
  tsse_zh   NUMBER(18,2),
  mdse_zh   NUMBER(18,2),
  tsse_by   NUMBER(18,2),
  mdse_by   NUMBER(18,2),
  sb_num    NUMBER(10),
  glh_num   NUMBER(10),
  ckmx_num  NUMBER(10),
  jhmx_num  NUMBER(10)
)
;
alter table TMP_TJ_DKQY_HXYH
  add primary key (CPCODE);

prompt
prompt Creating table TMP_TJ_LX_ZGYH
prompt =============================
prompt
create table TMP_TJ_LX_ZGYH
(
  id     NUMBER(8) not null,
  nsrsbh VARCHAR2(20) not null,
  xse1   NUMBER(16,2),
  xse2   NUMBER(16,2),
  xse3   NUMBER(16,2),
  xse4   NUMBER(16,2)
)
;
alter table TMP_TJ_LX_ZGYH
  add primary key (ID);

prompt
prompt Creating table TMP_TJ_RANDOM
prompt ============================
prompt
create table TMP_TJ_RANDOM
(
  nsrdzdah NUMBER(20) not null,
  nsrsbh   VARCHAR2(20) not null,
  flglcd   CHAR(1),
  tsjsfs   CHAR(1),
  jhkh     CHAR(1),
  mdse12m  NUMBER(16,2),
  tse12m   NUMBER(16,2),
  tscnt12m INTEGER,
  mdse24m  NUMBER(16,2),
  tse24m   NUMBER(16,2),
  tscnt24m INTEGER,
  xssr     NUMBER(16,2),
  zzsjscnt INTEGER,
  shxyno   VARCHAR2(20),
  tscs18   NUMBER(8)
)
;
alter table TMP_TJ_RANDOM
  add primary key (NSRDZDAH);

prompt
prompt Creating table TMP_TSSH_CZY
prompt ===========================
prompt
create table TMP_TSSH_CZY
(
  user_id  VARCHAR2(20) not null,
  usrstate VARCHAR2(20),
  fullname VARCHAR2(200)
)
;
alter table TMP_TSSH_CZY
  add constraint PK_TMP_TSSH_CZY primary key (USER_ID);

prompt
prompt Creating table TMP_WMTS
prompt =======================
prompt
create table TMP_WMTS
(
  uuid   VARCHAR2(32) not null,
  cpcode VARCHAR2(32) not null,
  ym     VARCHAR2(6) not null,
  ck_usd NUMBER(15,2) default 0,
  jhje   NUMBER(15,2) default 0,
  zse    NUMBER(15,2) default 0,
  tse    NUMBER(15,2) default 0
)
;
create index IDX_TMP_WMTS_1 on TMP_WMTS (CPCODE, YM);

prompt
prompt Creating table WMR_ENTERPRISE
prompt =============================
prompt
create table WMR_ENTERPRISE
(
  nsrsbh VARCHAR2(20) not null,
  nsrmc  VARCHAR2(200),
  czbz   CHAR(1) not null,
  zrsj   TIMESTAMP(6),
  dzsj   TIMESTAMP(6),
  zxsj   TIMESTAMP(6),
  cjsj   TIMESTAMP(6) default sysdate not null,
  xgsj   TIMESTAMP(6),
  bz     VARCHAR2(200)
)
;
comment on table WMR_ENTERPRISE
  is '外贸融-企业表';
comment on column WMR_ENTERPRISE.nsrsbh
  is '纳税人识别号';
comment on column WMR_ENTERPRISE.nsrmc
  is '纳税人名称';
comment on column WMR_ENTERPRISE.czbz
  is '操作标志（0-准入，1-贷中，2-注销）';
comment on column WMR_ENTERPRISE.zrsj
  is '准入时间';
comment on column WMR_ENTERPRISE.dzsj
  is '贷中时间';
comment on column WMR_ENTERPRISE.zxsj
  is '注销时间';
comment on column WMR_ENTERPRISE.cjsj
  is '创建时间';
comment on column WMR_ENTERPRISE.xgsj
  is '更新时间';
comment on column WMR_ENTERPRISE.bz
  is '备注，预留';
alter table WMR_ENTERPRISE
  add constraint PK_WMR_ENTERPRISE primary key (NSRSBH);

prompt
prompt Creating table ZZ_CWBB_LRBWXQ
prompt =============================
prompt
create table ZZ_CWBB_LRBWXQ
(
  nsrsbh VARCHAR2(20) not null,
  sssq   CHAR(6) not null,
  ewbhxh INTEGER not null,
  mc     VARCHAR2(100),
  bys    NUMBER(16,2),
  bnljs  NUMBER(16,2)
)
;
alter table ZZ_CWBB_LRBWXQ
  add primary key (NSRSBH, SSSQ, EWBHXH);

prompt
prompt Creating table ZZ_CWBB_LRBXQY
prompt =============================
prompt
create table ZZ_CWBB_LRBXQY
(
  nsrsbh VARCHAR2(20) not null,
  sssq   CHAR(6) not null,
  ewbhxh INTEGER not null,
  hmc    VARCHAR2(100),
  byje   NUMBER(16,2),
  bnljje NUMBER(16,2)
)
;
alter table ZZ_CWBB_LRBXQY
  add primary key (NSRSBH, SSSQ, EWBHXH);

prompt
prompt Creating table ZZ_CWBB_LRBYBQY
prompt ==============================
prompt
create table ZZ_CWBB_LRBYBQY
(
  nsrsbh VARCHAR2(20) not null,
  sssq   CHAR(6) not null,
  ewbhxh INTEGER not null,
  hmc    VARCHAR2(100),
  bqje   NUMBER(16,2),
  sqje_1 NUMBER(16,2)
)
;
alter table ZZ_CWBB_LRBYBQY
  add primary key (NSRSBH, SSSQ, EWBHXH);

prompt
prompt Creating table ZZ_CWBB_ZCFZBWXQ
prompt ===============================
prompt
create table ZZ_CWBB_ZCFZBWXQ
(
  nsrsbh VARCHAR2(20) not null,
  sssq   CHAR(6) not null,
  ewbhxh INTEGER not null,
  zcxmmc VARCHAR2(100),
  qms_zc NUMBER(16,2),
  ncs_zc NUMBER(16,2),
  qyxmmc VARCHAR2(100),
  qms_qy NUMBER(16,2),
  ncs_qy NUMBER(16,2)
)
;
alter table ZZ_CWBB_ZCFZBWXQ
  add primary key (NSRSBH, SSSQ, EWBHXH);

prompt
prompt Creating table ZZ_CWBB_ZCFZBXQY
prompt ===============================
prompt
create table ZZ_CWBB_ZCFZBXQY
(
  nsrsbh  VARCHAR2(20) not null,
  sssq    CHAR(6) not null,
  ewbhxh  INTEGER not null,
  zcxmmc  VARCHAR2(100),
  qmye_zc NUMBER(16,2),
  ncye_zc NUMBER(16,2),
  qyxmmc  VARCHAR2(100),
  qmye_qy NUMBER(16,2),
  ncye_qy NUMBER(16,2)
)
;
alter table ZZ_CWBB_ZCFZBXQY
  add primary key (NSRSBH, SSSQ, EWBHXH);

prompt
prompt Creating table ZZ_CWBB_ZCFZBYBQY
prompt ================================
prompt
create table ZZ_CWBB_ZCFZBYBQY
(
  nsrsbh  VARCHAR2(20) not null,
  sssq    CHAR(6) not null,
  ewbhxh  INTEGER not null,
  zcxmmc  VARCHAR2(100),
  qmye_zc NUMBER(16,2),
  ncye_zc NUMBER(16,2),
  qyxmmc  VARCHAR2(100),
  qmye_qy NUMBER(16,2),
  ncye_qy NUMBER(16,2)
)
;
alter table ZZ_CWBB_ZCFZBYBQY
  add primary key (NSRSBH, SSSQ, EWBHXH);

prompt
prompt Creating table ZZ_NSR
prompt =====================
prompt
create table ZZ_NSR
(
  nsrsbh     VARCHAR2(20) not null,
  nsrmc      VARCHAR2(80),
  djxh       NUMBER(20),
  ssny       DATE,
  zzs_sbuuid VARCHAR2(32),
  cwbbzl_dm  VARCHAR2(20),
  cwb_sbuuid VARCHAR2(32)
)
;
alter table ZZ_NSR
  add primary key (NSRSBH);

prompt
prompt Creating table ZZ_ZZS_YBNSR
prompt ===========================
prompt
create table ZZ_ZZS_YBNSR
(
  nsrsbh         VARCHAR2(20) not null,
  sssq           CHAR(6) not null,
  ewblxh         INTEGER not null,
  asysljsxse     NUMBER(16,2),
  yshwxse        NUMBER(16,2),
  yslwxse        NUMBER(16,2),
  sysl_nsjctzxse NUMBER(16,2),
  ajybfjsxse     NUMBER(16,2),
  jybf_nsjctzxse NUMBER(16,2),
  mdtbfckxse     NUMBER(16,2),
  msxse          NUMBER(16,2),
  mshwxse        NUMBER(16,2),
  mslwxse        NUMBER(16,2),
  xxse           NUMBER(16,2),
  jxse           NUMBER(16,2),
  sqldse         NUMBER(16,2),
  jxsezc         NUMBER(16,2),
  mdtytse        NUMBER(16,2),
  sysl_nsjcybjse NUMBER(16,2),
  ydksehj        NUMBER(16,2),
  sjdkse         NUMBER(16,2),
  ynse           NUMBER(16,2),
  qmldse         NUMBER(16,2),
  jybf_ynse      NUMBER(16,2),
  jybf_nsjcybjse NUMBER(16,2),
  ynsejze        NUMBER(16,2),
  ynsehj         NUMBER(16,2),
  qcwjse         NUMBER(16,2),
  ssckkjzyjkstse NUMBER(16,2),
  bqyjse         NUMBER(16,2),
  fcyjse         NUMBER(16,2),
  ckkjzyjksyjse  NUMBER(16,2),
  bqjnsqynse     NUMBER(16,2),
  bqjnqjse       NUMBER(16,2),
  qmwjse         NUMBER(16,2),
  qmwjse_qjse    NUMBER(16,2),
  bqybtse        NUMBER(16,2),
  jzjtsjtse      NUMBER(16,2),
  qcwjcbse       NUMBER(16,2),
  bqrkcbse       NUMBER(16,2),
  qmwjcbse       NUMBER(16,2)
)
;
alter table ZZ_ZZS_YBNSR
  add primary key (NSRSBH, SSSQ, EWBLXH);


prompt Done
set define on
