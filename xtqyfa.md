# 系统去 Oracle 化迁移改造方案

> **项目**：**《便捷退税（税务端）管理系统》**（浙江省税务局第二分局 / 进出口服务与管理局，政务内网）
> **改造方向**：Oracle 11g → MySQL 5.7
> **实施策略**：**治理前置——三 schema 先在 Oracle 侧合一并验证，再整体迁移 MySQL**
> **配套管理文件**：《去 Oracle 化迁移工作计划书》（`xtqyjhs.md` v0.2，以下简称"计划书"）
> **文档状态**：v0.2，待评审
> **编制日期**：2026-07-27

---

## 修订记录

| 版本 | 日期 | 修订内容 | 编制 |
|---|---|---|---|
| v0.1 | 2026-07-27 | 初稿，含数据库改造、数据迁移、ETL 改造、应用改造、测试与割接 | — |
| **v0.2** | **2026-07-27** | **与计划书 v0.2 同步：① 明确系统身份与"治理前置"实施策略（1.1/1.2 新增）；② 第 5 章迁移源端由三 schema 原始库改为治理后单 schema 库；③ 第 7 章应用改造拆分为阶段一（治理）/ 阶段二（MySQL）；④ 第 9 章割接不再叠加治理动作，回退阈值按功能重要性分级；⑤ 第 10 章阶段划分同步计划书 WBS；⑥ 第 11 章风险等级按系统重要性分级重估** | — |

---

## 目录

- [1. 概述](#1-概述)
- [2. 现状分析](#2-现状分析)
- [3. 目标架构与关键技术决策](#3-目标架构与关键技术决策)
- [4. 数据库层改造方案](#4-数据库层改造方案)
- [5. 数据迁移方案](#5-数据迁移方案)
- [6. ETL 改造方案](#6-etl-改造方案)
- [7. 应用层（Java）改造方案](#7-应用层java改造方案)
- [8. 测试与验证方案](#8-测试与验证方案)
- [9. 割接方案](#9-割接方案)
- [10. 实施计划与组织](#10-实施计划与组织)
- [11. 风险登记册](#11-风险登记册)
- [12. 附录](#12-附录)

---

## 1. 概述

### 1.1 背景与目标

按政务部门整体去 Oracle 化要求，本系统数据库由 Oracle 11g 替换为 MySQL 5.7。

**系统概况**：《便捷退税（税务端）管理系统》服务于浙江省税务局第二分局（进出口服务与管理局）及全省进出口税收管理部门，2019 年起建设，初期提供报表与统计分析模块，此后随省局每年新增需求迭代，陆续增加出口退税申报预警、审核助手管理平台、三三智检、案头分析、监测分析、长期未申报管理、数字化单证备案、态势感知综合信息展示等功能。系统运行于政务内网（物理隔离），**因历史分期建设，数据分设 3 个 schema（`TL_BJTS` / `TL_ADMIN` / `TL_TSSH`）**，并大量使用存储过程、函数、视图等数据库对象承载业务逻辑；应用层为 Java 服务，除自身数据源外还通过 ETL 从第三方平台抽取数据。系统定位为**辅助性业务系统**，功能重要性分级见计划书 1.7。

**改造目标**

| 编号 | 目标 | 验收口径 |
|---|---|---|
| G1 | 自身系统数据库完全脱离 Oracle | 生产环境不再存在 Oracle 实例与 Oracle 客户端依赖 |
| G2 | 业务功能等价 | 全量功能回归用例通过率 100%，关键业务双跑比对差异为 0 |
| G3 | 数据完整准确 | 表行数一致、主键集合一致、金额/税额类字段合计一致 |
| G4 | 性能不劣化 | 核心联机交易 P95 不高于迁移前 120%；批处理作业总时长不超过原窗口 |
| G5 | 可回退 | 割接后 T+7 内具备回退到 Oracle 的能力 |
| G6 | 平滑对接第三方 | 第三方平台数据源无论是否已切换 MySQL，本系统 ETL 均可正常运行 |

> **另有治理类目标 G7–G10**（三 schema 合一、冗余消除、停用服务下线、治理经业务验证），见计划书 1.4。本方案为其提供技术实现，验收口径以计划书为准。

### 1.1.1 实施策略：治理前置（v0.2 新增，影响本方案多个章节的前置条件）

本项目**不是单纯的数据库替换**，而是"数据治理"与"去 Oracle 化"两项任务**分两步串行实施**：

```
第一步（计划书 W3A/W3B）：Oracle 内治理，在预生产迁移环境上完成并验证
   Oracle 3 schema ──▶ Oracle 单 schema（合并 / 归并 / 清理 / 下线，已业务验证）
                              │
第二步（本方案）：去 Oracle 化  │  治理后的单 schema 成为迁移源
                              ▼
   Oracle 单 schema ──▶ MySQL 5.7 单 database
```

**对本方案的四处前置条件变更**：

| 章节 | v0.1 假设 | **v0.2 实际** |
|---|---|---|
| [5 数据迁移](#5-数据迁移方案) | 源端为三 schema 原始库，迁移中同时完成合并 | **源端为治理后单 schema；合并/归并/清理由已验证的治理脚本承担**，见 [5.0](#50-迁移源端说明v02) |
| [7 应用改造](#7-应用层java改造方案) | 一次性完成"去前缀 + MySQL 语法"全部改造 | **拆为阶段一（治理，在 Oracle 上验证）与阶段二（MySQL 语法）**，见 [7.0](#70-两阶段划分v02) |
| [9 割接](#9-割接方案) | 割接同时执行迁移与治理 | **割接只做 Oracle→MySQL 一件事**，见 [9.0](#90-割接范围收窄v02) |
| [11 风险](#11-风险登记册) | 按等权重功能评估影响 | **按功能重要性分级重估**，见 [11](#11-风险登记册) 表首说明 |

> **策略价值：每一步只变一个变量。** 治理阶段数据库仍是 Oracle，功能异常必定由合并/清理引起；迁移阶段数据结构已验证，异常必定由 MySQL 改造引起。完整论证见计划书 2.3.2。

### 1.2 范围

**范围内**

1. 自身系统 Oracle 数据库的结构迁移、对象（存储过程/函数/视图/序列/触发器/同义词/作业）改造、数据迁移。
2. ETL 抽数、清洗、加工作业的改造，含对第三方数据源的双模适配。
3. Java 应用层的持久层、数据源、事务、分页、存储过程调用、异常处理等改造。
4. 测试、割接、回退、投产后优化。
5. 新数据库的部署架构、高可用、备份恢复、监控。

**范围外（但需协同）**

1. 第三方平台自身的去 O 改造（由对方负责）。**但其改造时间点是本项目的关键路径依赖**，见 [6.2](#62-第三方数据源双模适配关键依赖)。
2. 业务需求变更、界面改版。
3. 操作系统/中间件的信创替换（若同期进行需并入统一窗口，见 [11 风险 R9](#11-风险登记册)）。

### 1.3 总体原则

| 原则 | 说明 |
|---|---|
| **等价优先** | 迁移期只做等价改写，不夹带业务逻辑变更。业务优化另立需求，避免问题归因困难。 |
| **例外：安全与正确性缺陷** | 迁移中发现的 SQL 注入、语义错误等，登记后单独走变更评审，不默默改也不默默留（详见 [2.4](#24-抽样对象中发现的既有问题)）。 |
| **分层解耦** | 数据库中不适合在 MySQL 承载的逻辑（动态 DDL、返回结果集的函数、自治事务）上移到应用层，一次改到位，不留技术债。 |
| **可回退** | 每个阶段都有明确回退点；割接方案以"能退回去"为第一优先级。 |
| **可验证** | 每一项改造都要有对应的验证手段（比对脚本、单测、双跑），"看起来对"不算完成。 |
| **自动化优先** | 结构转换、代码扫描、数据校验尽量脚本化，人工只做复核与疑难攻关。 |

---

## 2. 现状分析

### 2.1 系统架构现状

```
┌─────────────────────────────────────────────────────────────┐
│                      Java 应用服务                            │
│  ┌────────────┐  ┌────────────┐  ┌──────────────────────┐   │
│  │ 联机交易    │  │ 报表查询    │  │ 调用 DB 存储过程/函数 │   │
│  └─────┬──────┘  └─────┬──────┘  └──────────┬───────────┘   │
│        │  数据源A(自身) │                    │               │
│        │               │  数据源B(第三方)    │               │
└────────┼───────────────┼────────────────────┼───────────────┘
         │               │                    │
    ┌────▼───────────────▼────────────────────▼────┐
    │        Oracle 11g（自身系统）                  │
    │  schema: TL_TSSH / TL_ADMIN / TL_BJTS ...     │
    │  表 / 视图 / 存储过程 / 函数 / 序列 / 作业      │
    └────▲──────────────────────────────────────────┘
         │  ETL 抽取 + 清洗加工
    ┌────┴──────────────────────────┐
    │  第三方平台 Oracle 11g 数据源    │  ← 对方自行去 O，时点待定
    └───────────────────────────────┘
```

**已确认的关键事实**（来自本仓库现有 Oracle 脚本）：

- 至少存在 3 个 schema：`TL_TSSH`（态势感知/风险）、`TL_ADMIN`（预警配置）、`TL_BJTS`（申报/登记）。
- **存在单条 SQL 跨 schema 关联**。例：`存储过程-2-Oracle.txt:28-29`

  ```sql
  FROM TL_TSSH.CKTS_WBSJ_HG_BGD T
  INNER JOIN TL_BJTS.GS_DJ_CKTMSDAB S ON S.CPCODE=T.DJXH
  ```

  → **强约束：三个 schema 必须落在同一 MySQL 实例内**，不可拆分到不同实例或做分库，否则跨库 JOIN 失效。这一条直接否决了"按 schema 拆多实例"的部署方案。

- 业务逻辑显著下沉到数据库：风险规则扫描、预警写入、短信推送数据生成、审核任务委派、分页列表查询等均在 PL/SQL 中实现。

### 2.2 数据库对象摸底

改造工作量由对象数量与复杂度驱动，**方案落地前必须先完成摸底**。摸底 SQL 见 [附录 A](#附录-aoracle-摸底脚本)，需产出下表并作为工作量测算基线：

| 对象类型 | 数量 | 待摸底项 |
|---|---|---|
| 表 | ? | 行数、占用空间、分区表数、含 LOB 表数、宽表数 |
| 视图 | ? | 含窗口函数/CONNECT BY/嵌套层数 |
| 存储过程 / 函数 | ? | 源码行数、是否用动态 SQL/REF CURSOR/集合类型/自治事务 |
| 包（Package） | ? | 包内过程数、是否有包级变量 |
| 序列 | ? | 使用方式（单表主键 or 跨表） |
| 触发器 | ? | 是否含自治事务、是否跨表写 |
| 物化视图 | ? | 刷新方式与频率 |
| 同义词 | ? | 是否跨 schema |
| DB Link | ? | 指向何处（大概率指向第三方平台） |
| 定时作业 | ? | DBMS_JOB / DBMS_SCHEDULER 清单 |

> **本方案后续的工作量测算，暂以"表 800、视图 60、存储过程与函数 150、序列 40、触发器 20"作为假设基数，摸底完成后须整体复算。**

### 2.3 抽样对象的改造难度实证

本仓库已完成 6 个对象的样例改造，构成难度分级的实测标定，是工作量估算最可靠的依据。

| 样例 | 规模 | 关键 Oracle 特性 | MySQL 5.7 障碍 | 难度 | 实测投入 |
|---|---|---|---|---|---|
| `视图v_sbxx_sbdr_filemode.txt` | 13 行 | `ROW_NUMBER() OVER(PARTITION BY)` 去重 | **5.7 无窗口函数，且视图内禁用用户变量**（ER 1351），只能改写为相关子查询/反连接 | 中 | 0.5–1 人日 |
| `方法函数-2-Oracle.txt`<br>`Func_Get_Qxswjg` | 28 行 | WHILE 循环、SUBSTR、字符串拼接 | 语法直译即可 | 低 | 0.5 人日 |
| `方法函数-1-Oracle.txt`<br>`F_MY_STDAVG_TMPTB` | 72 行 | **函数内 EXECUTE IMMEDIATE 建/删临时表**、`SQL%ROWCOUNT`、`STDDEV()` | **MySQL 函数禁用动态 SQL**；函数不能做 DDL；DDL 隐式提交；`STDDEV` 语义不同（见下） | 高 | 3 人日（须重构为过程或上移应用层） |
| `存储过程-2-Oracle.txt`<br>`PRO_FXGL_FXSPCK_DZXX` | 145 行 | 两层游标 FOR、`MERGE INTO`、`SEQ.NEXTVAL`、`REGEXP_LIKE`、`DECODE`、`NVL`、`\|\|`、跨 3 schema | 嵌套 DECLARE CURSOR + 处理器作用域、MERGE 改写、序列模拟、正则大小写语义 | 中高 | 2–3 人日 |
| `存储过程-3-Oracle.txt`<br>`func_shzs_rwwp` | 206 行 | **返回集合类型** `TYPE_TB_SHZS_RWWP`、`WITH ... AS` CTE ×3、`ROWNUM=1`、多层 EXCEPTION、`DBMS_OUTPUT` | 函数不能返回结果集 → 改过程；5.7 无 CTE → 派生表 | 高 | 3–5 人日 |
| `存储过程-4-Oracle.txt`<br>`func_get_wjdr_sblist` | 102 行 | **REF CURSOR + 动态 SQL + `ROW_NUMBER() OVER()` + 集合返回**，且调用其他函数 | 三重障碍叠加；动态 SQL 结果集无法用游标遍历 | 高 | 3–5 人日 |

**由此标定的单对象平均工作量**：

| 难度 | 判定特征 | 占比估计 | 单对象人日（含自测） |
|---|---|---|---|
| 低 | 纯过程逻辑、单表 DML、无 Oracle 专有特性 | 40% | 0.5 |
| 中 | 游标循环、MERGE、序列、正则、多表关联 | 35% | 2.0 |
| 高 | 动态 SQL / REF CURSOR / 集合类型 / 窗口函数 / CTE / 自治事务 | 25% | 4.0 |

> 加权平均 ≈ **1.9 人日/对象**。按假设的 150 个过程函数计 ≈ 285 人日；视图 60 个按 0.8 人日计 ≈ 48 人日。再计 30% 的联调返工，对象改造合计约 **430 人日**。摸底后须以实际难度分布复算。

### 2.4 抽样对象中发现的既有问题

改造过程中发现以下既有缺陷。按 [1.3](#13-总体原则) 原则登记但不在迁移中默默修改，须单独走变更评审：

| 编号 | 位置 | 问题 | 建议 |
|---|---|---|---|
| D1 | `存储过程-4-Oracle.txt:60,86` | `p_filter`、`p_sort` 参数被**原样拼接进动态 SQL**，存在 SQL 注入风险；参数来自应用层 | 借改造窗口改为白名单校验 + 参数化；排序字段用枚举映射 |
| D2 | `方法函数-1-Oracle.txt:35` | `p_datasql` 是整段 SQL 文本，由调用方传入并直接执行 | 重构为"传业务参数、由被调方拼固定模板"，或整体上移应用层 |
| D3 | `存储过程-2-Oracle.txt:54` | 预警文案中"商品名称"取的是 `CKSP_DM`（商品代码），疑似笔误；且 `'出口美元金额'\|\|MYLAJ\|\|')'` 右括号不配对 | 业务确认后修正，已在 `mysql-2.txt` 中按原逻辑保留并加注释 |
| D4 | `存储过程-3-Oracle.txt:32`、`视图v_sbxx_sbdr_filemode.txt:10` | `ROWNUM=1` 写在 `LEFT JOIN ... ON` 子句内，语义依赖 Oracle 执行细节，结果不确定 | **必须业务确认取数意图**（应为"取最新一条扩展信息"），否则无法等价改写 |
| D5 | `方法函数-1-Oracle.txt:44` | Oracle `STDDEV()` 是**样本**标准差，MySQL `STDDEV()`/`STD()` 是**总体**标准差 | 改写时必须映射为 `STDDEV_SAMP()`，否则风险指标静默偏移 |

> **D5 是典型的"静默数值漂移"**：语法能编译、程序不报错、结果悄悄变了。这类问题在税务风险打分场景后果严重，是本次迁移测试的重点方向。

### 2.5 源码保真度问题（需立即处理）

`方法函数-2-Oracle.txt` 中 `<`、`>`、`*`、`||` 等字符整体丢失：

```sql
-- 仓库现存（已损坏）        -- 应为
if length(swjg_dm)11 then    if length(swjg_dm) < 11 then
i=5;                          i := 5;
while i 1 loop                while i > 1 loop
substr(swjg_dm,(i2),2)'00'    substr(swjg_dm,(i*2),2) <> '00'
v_qxSwjg  '%'                 v_qxSwjg || '%'
```

原因是脚本经由网页/HTML 通道复制导致转义字符丢失。

> **纠正措施（P0）**：所有 Oracle 源码必须从数据库字典直取（`DBA_SOURCE`、`DBMS_METADATA.GET_DDL`）或用 `expdp` 导出，**禁止**经由网页、聊天工具、富文本文档中转。已入库的脚本需与 `DBA_SOURCE` 全量比对一次，确认无字符丢失后方可作为改造输入。

---

## 3. 目标架构与关键技术决策

### 3.1 目标架构

```
┌──────────────────────────────────────────────────────────────┐
│                       Java 应用服务                            │
│   Connector/J  +  Druid/HikariCP  +  MyBatis(databaseId)      │
│   ┌──────────────┐            ┌───────────────────────────┐   │
│   │ 业务服务层     │            │ 原 PL/SQL 上移的服务组件    │   │
│   │              │            │（动态查询/集合返回/自治日志） │   │
│   └──────┬───────┘            └─────────────┬─────────────┘   │
└──────────┼──────────────────────────────────┼─────────────────┘
           │                                  │
    ┌──────▼──────────────────────────────────▼──────┐
    │        MySQL 5.7 主实例（同一实例内）             │
    │  db: tl_tssh / tl_admin / tl_bjts              │
    │  表 / 视图 / 存储过程 / 函数 / 序列模拟表          │
    └──────┬──────────────────────────┬──────────────┘
           │ 半同步复制                 │
    ┌──────▼──────┐            ┌──────▼───────┐
    │  备库(HA)    │            │ 只读库(报表)  │
    └─────────────┘            └──────────────┘
           ▲
           │ DataX / Kettle（调度：XXL-JOB）
    ┌──────┴─────────────────────────────────┐
    │  ETL 双模适配层                          │
    │  ├─ Oracle 源适配（第三方切换前）          │
    │  └─ MySQL 源适配（第三方切换后）           │
    └────────────────────────────────────────┘
```

### 3.2 决策 D-01：目标数据库版本

**结论：按上级要求采用 MySQL 5.7，同时提请评审 8.0 的可行性。**

需要明确记录的事实：MySQL 5.7 已于 **2023 年 10 月停止官方支持**，且缺失以下能力，而这些能力恰好是本系统的高频依赖：

| 缺失能力 | 本系统受影响处 | 5.7 下的代价 |
|---|---|---|
| 窗口函数 | `v_sbxx_sbdr_filemode` 视图、`func_get_wjdr_sblist` 分页 | 改相关子查询/自连接；**视图内还禁用用户变量**，绕行方案更少 |
| CTE（`WITH`） | `func_shzs_rwwp` 中 3 处 | 改派生表，SQL 冗长且重复子句 |
| **Hash Join** | 所有大表关联、ETL 加工 | **仅 BNL 嵌套循环，大表 JOIN 性能断崖**，见 [11 风险 R2](#11-风险登记册) |
| `CHECK` 约束 | 全部表级校验 | 5.7 解析但**静默忽略**，数据质量约束全部失效 |
| `NOWAIT` / `SKIP LOCKED` | 任务抢单类逻辑 | 只能靠 `innodb_lock_wait_timeout` |

> **建议**：若上级政策允许版本区间而非锁定 5.7，强烈建议改用 **MySQL 8.0**。仅"窗口函数 + CTE + Hash Join"三项，即可减少约 25% 的高难度对象改造量与绝大部分大表 JOIN 的性能攻坚。此建议应在方案评审时正式提出并留档；**若维持 5.7，本方案全部内容按 5.7 执行**，后续章节均已按 5.7 编写。

### 3.3 决策 D-02：schema 映射策略

Oracle 的 schema ≈ MySQL 的 database。两种方案：

| 方案 | 做法 | 优点 | 缺点 |
|---|---|---|---|
| **A. 一对一映射** | `TL_TSSH`→`tl_tssh`，代码中保留库名前缀 | 权限/备份粒度不变；对象名不冲突；改动最小 | SQL 中需保留 `db.table` 前缀 |
| **B. 合并单库** | 三个 schema 表合入一个库，**去掉前缀** | SQL 简洁；避免跨库权限配置 | **表名冲突风险**；权限粒度变粗；备份无法按子系统拆分 |

**结论：采用方案 B（合并单库、去前缀），与已完成的样例改造保持一致。**

前置条件（必须先做）：

1. **表名冲突检查**（见 [附录 A](#附录-aoracle-摸底脚本) A-9）。若存在同名表，须制定重命名规则并同步改造应用代码——这是方案 B 唯一的硬风险点。
2. 存储过程内非限定表名解析到**过程所属库**，故所有对象必须建在同一个库中。
3. 权限收缩到应用账号 + 只读账号 + 运维账号三类，通过表级授权补偿粒度损失。

> 无论 A 还是 B，[2.1](#21-系统架构现状) 的跨 schema JOIN 约束都要求**三者同实例**。

**v0.2 执行方式变更**：方案 B 的合并动作**不在 MySQL 侧首次执行，而是先在 Oracle 迁移环境上完成并经业务验证**（计划书 W3B.B2）。因此本方案第 4 章的结构迁移、第 5 章的数据迁移，其源端均为**已合并的单 schema**。表名冲突消解、去前缀改写、字典归并的码值映射，均由治理阶段产出的《对象映射总表》与《码值映射表》驱动，本方案不再重复定义规则。

### 3.4 决策 D-03：字符集与排序规则

| 项 | 取值 | 理由 |
|---|---|---|
| 字符集 | **`utf8mb4`** | 税务系统纳税人名称含生僻字，`utf8`（3 字节）无法存储部分 CJK 扩展区汉字，会直接报错或丢字 |
| 默认排序规则 | **`utf8mb4_bin`** | Oracle 默认字符串比较**区分大小写、区分尾空格**。MySQL `_ci` 排序规则不区分大小写、且 5.7 为 PAD SPACE（`'ABC '='ABC'` 为真），会导致 `WHERE code='abc'` 匹配到 `'ABC'`、唯一索引把 `'A'`/`'a'` 判为重复 |
| 例外 | 用户可见的模糊检索列可单列指定 `utf8mb4_general_ci` | 中文不涉及大小写，影响面小；按列而非按库放开 |
| 行格式 | `ROW_FORMAT=DYNAMIC` | 配合 `innodb_large_prefix=ON`，索引前缀上限 3072 字节（utf8mb4 下 768 字符） |

**必须核对的 Oracle 侧现状**（否则排序结果会变）：

```sql
SELECT parameter, value FROM nls_database_parameters
 WHERE parameter IN ('NLS_CHARACTERSET','NLS_SORT','NLS_COMP','NLS_LENGTH_SEMANTICS');
```

- 若 `NLS_SORT=BINARY` → 与 `utf8mb4_bin` 行为基本一致，可直接对应。
- 若 `NLS_SORT=SCHINESE_PINYIN_M`（按拼音排序）→ **MySQL 无内置拼音排序规则**。需为涉及中文排序的列增加"拼音码"辅助列（生成列或 ETL 落地）并按其排序，否则纳税人名称列表顺序会与现网不一致。这是用户一眼能看出来的差异，须提前识别。
- `NLS_LENGTH_SEMANTICS=BYTE`（默认）时 `VARCHAR2(30)` 是 30 **字节**，映射为 MySQL `VARCHAR(30)`（30 **字符**）是放宽，安全；反向不安全。

### 3.5 决策 D-04：实例参数基线

| 参数 | 取值 | 说明 |
|---|---|---|
| `lower_case_table_names` | **`1`** | Linux 下默认 0（表名大小写敏感），而 Oracle 对象名存为大写，代码中大小写混用。**必须在实例初始化前设定，事后无法安全更改** |
| `transaction_isolation` | **`READ-COMMITTED`** | 对齐 Oracle 默认隔离级别；同时大幅减少 RR 下的间隙锁死锁 |
| `binlog_format` | `ROW` | RC 隔离级别下的必需项 |
| `sql_mode` | `STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION` | **暂不含 `ONLY_FULL_GROUP_BY`**，见下 |
| `character_set_server` | `utf8mb4` | |
| `collation_server` | `utf8mb4_bin` | |
| `innodb_large_prefix` | `ON` | 5.7 默认 |
| `group_concat_max_len` | **`1048576`** | 默认仅 1024 字节，`LISTAGG` 改写后会**静默截断** |
| `div_precision_increment` | `4`（默认，需确认业务） | 影响 DECIMAL 除法结果小数位，涉及金额计算需评估 |
| `max_allowed_packet` | `64M` | LOB 迁移与大批量写入 |
| `event_scheduler` | `OFF` | 定时任务统一走外部调度，见 [4.3](#43-plsql-对象改造规范) |
| `max_sp_recursion_depth` | 按需（默认 0） | 若有递归存储过程需显式放开 |
| `innodb_lock_wait_timeout` | `10`（联机库） | 无 `NOWAIT`，靠超时兜底 |

**关于 `ONLY_FULL_GROUP_BY`**：MySQL 5.7 默认开启，会导致大量存量 SQL（`SELECT a,b FROM t GROUP BY a`）直接报错。策略：

1. 迁移期先关闭，保证功能跑通；
2. 同步用扫描工具列出全部违规 SQL 并排期整改；
3. 整改完成后在测试环境开启验证，投产后择机在生产开启。

**不建议永久关闭**——它屏蔽的是真实的语义歧义。

### 3.6 决策 D-05：存储过程去留策略

**不做无差别 1:1 直译。** MySQL 5.7 的存储程序是解释执行、无编译缓存，逐行游标循环的性能与 PL/SQL 差距很大；`PRO_FXGL_FXSPCK_DZXX` 这类"两层游标 + 逐行三次 INSERT"的结构在 MySQL 下会明显变慢。按下表分类处置：

| 类别 | 判定特征 | 处置 | 预估占比 |
|---|---|---|---|
| **C1 直译** | 逻辑简单、集合操作为主、被多方调用 | 等价改写为 MySQL 存储过程 | 40% |
| **C2 集合化重写** | 存在逐行游标循环，但循环体可改为一条集合 SQL | 改写为 `INSERT...SELECT` / `UPDATE...JOIN`，**消灭循环** | 25% |
| **C3 上移应用层** | 动态 SQL、返回结果集、动态 DDL、自治事务、需外部交互 | 用 Java 实现，DB 只保留数据访问 | 25% |
| **C4 下线** | 已无调用方（需通过调用链分析确认） | 评审后废弃 | 10% |

样例归类：

- `PRO_FXGL_FXSPCK_DZXX` → **C1**（已完成，见 `mysql-2.txt`）。但其内层循环对每行做 3 次带 `NOT EXISTS` 的 INSERT，**投产后应作为 C2 候选**改为按规则批量集合写入。
- `func_shzs_rwwp`、`func_get_wjdr_sblist` → **C3**。函数返回集合类型 + 动态 SQL，MySQL 无对应能力，勉强改造会得到又慢又难维护的代码。
- `F_MY_STDAVG_TMPTB` → **C3**。函数内建/删临时表，MySQL 函数禁用动态 SQL，无法直译；且 `p_datasql` 注入面（D2）也应借此消除。
- `Func_Get_Qxswjg` → **C1**。

> **C2/C3 的改造不是"额外工作"**，而是把在 MySQL 上必然要付的性能与维护成本提前一次性付掉。若全部按 C1 硬译，性能问题会在压测甚至投产后集中爆发，届时返工代价更高。

### 3.7 决策 D-06：序列与主键策略

| 场景 | 方案 | 说明 |
|---|---|---|
| 序列仅供单表主键使用 | **`AUTO_INCREMENT`** | 性能最好。需改造 INSERT 语句不再显式赋 ID |
| 序列跨表共用 / 需预取号 / INSERT 显式列出 ID | **序列模拟表 + 函数** | 已实现，见 `mysql-2.txt` 中 `sys_sequence` + `FN_SYS_SEQUENCE_NEXTVAL` |
| 高并发发号（>2000 TPS） | **号段模式** | 一次取 1000 个号缓存在应用内存，避免每次一行锁 |
| 分布式唯一 ID | 雪花算法 | 若后续有分库需求 |

序列模拟表的注意点：

1. 每次调用是一次 `INSERT ... ON DUPLICATE KEY UPDATE`，**该序列行上有行锁**，是潜在热点。批处理中高频调用需评估。
2. 初始值必须以业务表当前 `MAX(ID)` 初始化，且切换后 Oracle 侧不得再发号。
3. 创建修改数据的函数需 `log_bin_trust_function_creators=1` 或 `SUPER` 权限。

### 3.8 决策 D-07：部署与高可用

| 项 | 方案 |
|---|---|
| 拓扑 | 一主一备（半同步复制）+ 一只读库（报表/ETL 读） |
| 故障切换 | MHA 或 Orchestrator + VIP；政务内网优先选运维熟悉的方案 |
| 备份 | XtraBackup 每日物理全备 + binlog 增量；每周恢复演练 |
| 监控 | Prometheus + mysqld_exporter + Grafana；慢查询日志（`long_query_time=1`）接入日志平台 |
| 容量 | 单表建议 < 2000 万行。超限的大表（大概率是报关单、申报明细类）需**归档 + 分区**，见 [4.1.4](#414-分区表改造) |
| 诊断 | 无 AWR，改用 `performance_schema` + `sys` schema + 慢日志 + `pt-query-digest` |

---

## 4. 数据库层改造方案

### 4.1 结构迁移

#### 4.1.1 数据类型映射

| Oracle | MySQL 5.7 | 注意事项 |
|---|---|---|
| `NUMBER(p,0)` p≤4 | `SMALLINT` | |
| `NUMBER(p,0)` 5≤p≤9 | `INT` | |
| `NUMBER(p,0)` 10≤p≤18 | `BIGINT` | |
| `NUMBER(p,0)` p>18 | `DECIMAL(p,0)` | |
| `NUMBER(p,s)` | `DECIMAL(p,s)` | 金额、税额类**必须** DECIMAL，禁用 FLOAT/DOUBLE |
| `NUMBER`（无精度） | `DECIMAL(p,s)` 按实测取值 | **不可盲取 `DECIMAL(65,30)`**：拼接进字符串会带 30 位小数尾零（`mysql-2.txt` 已为此加了去尾零处理）。须用 [附录 A](#附录-aoracle-摸底脚本) A-5 实测每列真实精度 |
| `FLOAT` / `BINARY_FLOAT` | `FLOAT` | |
| `BINARY_DOUBLE` | `DOUBLE` | |
| `VARCHAR2(n)` | `VARCHAR(n)` | Oracle 默认 BYTE 语义、MySQL 为字符语义，映射为放宽，安全 |
| `NVARCHAR2(n)` | `VARCHAR(n)` | |
| `CHAR(n)` | `CHAR(n)` | 注意 PAD 语义差异，见 [4.5](#45-语义陷阱清单必读) |
| `CLOB` / `NCLOB` / `LONG` | `LONGTEXT` | |
| `BLOB` | `LONGBLOB` | |
| `RAW(n)` | `VARBINARY(n)` | |
| `DATE` | **`DATETIME`** | **不可映射为 MySQL `DATE`**，会丢失时分秒 |
| `TIMESTAMP(n)` | `DATETIME(n)` | **不用 MySQL `TIMESTAMP`**：范围仅 1970–2038 |
| `XMLTYPE` | `LONGTEXT` | 解析逻辑上移应用层 |
| `ROWID` / `UROWID` | 无对应 | 依赖 ROWID 的逻辑必须重写 |
| `INTERVAL` | 无对应 | 拆为数值列 + 单位 |

#### 4.1.2 建表规范

1. 引擎统一 `InnoDB`，`ROW_FORMAT=DYNAMIC`，字符集 `utf8mb4`。
2. **每表必须有主键**（InnoDB 聚簇索引依赖；无主键会严重影响复制性能）。Oracle 无主键的表需补建。
3. **行宽检查**：MySQL 单行上限 65535 字节（不含 BLOB/TEXT）。Oracle 中多个 `VARCHAR2(4000)` 的宽表，utf8mb4 下每列占 16000 字节，**极易超限**。处置：按实测长度收窄，或把大文本列改 `TEXT`。摸底见 A-6。
4. **索引前缀**：单列索引 ≤ 3072 字节（utf8mb4 下 768 字符）。超长列索引改前缀索引 `KEY(col(255))`，注意前缀索引不能用于覆盖索引和排序。
5. **`CHECK` 约束在 5.7 被静默忽略**。逐条评估：
   - 枚举值校验 → 应用层校验 + 数据质量稽核作业；
   - 关键不变量 → 触发器（注意性能）；
   - 登记到"降级约束清单"，由测试用例覆盖。
6. 外键：Oracle 若有外键，评估是否保留。建议**保留**（数据完整性优先），但需注意 MySQL 外键会带来额外行锁，高并发写入表可考虑改为应用层保证 + 定期稽核。
7. 命名统一小写（配合 `lower_case_table_names=1`）。

#### 4.1.3 数据校验型摸底（结构转换前必做）

| 检查 | 目的 |
|---|---|
| 越界日期：`col < DATE'1000-01-01'` 或含 `0000-00-00` | MySQL `DATETIME` 下限 1000-01-01，且 `NO_ZERO_DATE` 拒绝零值 |
| 无精度 `NUMBER` 列的实际最大整数位/小数位 | 决定 `DECIMAL(p,s)` |
| `VARCHAR2` 列实际最大字节长度 | 收窄列宽，规避行宽超限 |
| 全表宽度合计 | 识别超限宽表 |
| 空串 `''` 与 `NULL` 的分布 | 评估 [4.5](#45-语义陷阱清单必读) 空串陷阱影响面 |
| 大小写混用的编码类列 | 评估 `utf8mb4_bin` 切换后唯一约束是否会新增冲突 |

#### 4.1.4 分区表改造

MySQL 5.7 分区有两条硬约束，与 Oracle 差异极大：

1. **分区键必须包含在每一个唯一键/主键中**。Oracle 无此限制。若原表主键是 `ID`、按 `CKRQ` 范围分区，MySQL 下主键必须改为 `(ID, CKRQ)` 联合主键——这会连带影响外键、应用查询与 ORM 映射。
2. **无全局索引**，所有索引都是本地的；跨分区查询需扫所有分区。
3. **无 INTERVAL 自动分区**，须预建分区 + 定期维护作业新增/清理分区。

处置建议：

- 优先评估"是否真的需要分区"。若原分区仅为便于历史数据清理，可改为**归档表 + 定期搬迁**，避免主键改造的连锁影响。
- 确需分区的，采用 `RANGE COLUMNS(日期列)` 按月分区，配套建立分区维护作业（提前 3 个月预建）。

### 4.2 SQL 语法差异与改写规范

> 完整对照见 [附录 C](#附录-c函数与语法映射速查)。此处列出对本系统影响最大的项。

| Oracle | MySQL 5.7 | 关键陷阱 |
|---|---|---|
| `a \|\| b` | `CONCAT_WS('', a, b)` | **不要用 `CONCAT()`**：Oracle 的 `\|\|` 把 NULL 当空串，`CONCAT()` 遇 NULL 整体返回 NULL。`CONCAT_WS` 会跳过 NULL，语义一致 |
| `NVL(a,b)` | `IFNULL(a,b)` | 配合空串陷阱，常需写成 `IFNULL(NULLIF(a,''),b)` |
| `DECODE(x,0,0,y)` | `CASE WHEN x=0 THEN 0 ELSE y END` | 注意 Oracle DECODE 中 `NULL=NULL` 成立，CASE 中不成立 |
| `REGEXP_LIKE(c,p)` | `c REGEXP BINARY p` | Oracle 默认**区分大小写**，MySQL 按列排序规则（常为不敏感）→ 加 `BINARY`。且 5.7 是 POSIX 正则：**不支持 `\d`/`\w`**，需改 `[[:digit:]]`；按字节匹配，含中文的字符组 `[]` 与 `.` 行为异常 |
| `REGEXP_SUBSTR` / `REGEXP_REPLACE` | **5.7 无对应** | 上移应用层，或 8.0 |
| `ROWNUM <= n` | `LIMIT n` | Oracle 中 `ROWNUM` 先于 `ORDER BY` 生效，故有三层嵌套写法；MySQL `LIMIT` 后于 `ORDER BY`。**`ROWNUM=1` 不带排序时结果不确定，需业务确认取数意图**（见 D4） |
| `ROW_NUMBER() OVER(...)` | 相关子查询 / 自连接计数 | **视图内禁用用户变量**（ER 1351），因此视图里不能用 `@rn:=` 变通，只能用相关子查询或改为物化表 |
| `WITH x AS (...)` | 派生表 | 5.7 无 CTE；同一 CTE 被多次引用时需重复书写，注意执行计划劣化 |
| `MERGE INTO` | `INSERT...SELECT...WHERE NOT EXISTS`（仅插入）<br>`INSERT ... ON DUPLICATE KEY UPDATE`（插更新，**需唯一键**） | 后者依赖唯一索引，迁移时须确认唯一约束已建 |
| `SYSDATE` | **`NOW()`** | 不用 `SYSDATE()`：它是函数级取值、且对基于语句的复制不安全。`NOW()` 是语句级常量，与 Oracle 语义一致 |
| `date - n` | `DATE_SUB(date, INTERVAL n DAY)` | |
| `ADD_MONTHS(d,n)` | `DATE_ADD(d, INTERVAL n MONTH)` | 月末进位规则两者一致 |
| `MONTHS_BETWEEN(a,b)` | `TIMESTAMPDIFF(MONTH,b,a)` | Oracle 返回小数，MySQL 返回整数**截断**，差异需确认 |
| `TRUNC(date)` | `DATE(d)` | |
| `TRUNC(num, n)` | `TRUNCATE(num, n)` | |
| `TO_CHAR(d,'yyyy-mm-dd')` | `DATE_FORMAT(d,'%Y-%m-%d')` | 格式符全表转换，见附录 C |
| `TO_CHAR(n,'00')` | `LPAD(n,2,'0')` | 数字格式化模型无对应 |
| `TO_DATE(s,fmt)` | `STR_TO_DATE(s,fmt)` | |
| `INSTR(s,sub)` | `LOCATE(sub,s)` | **参数顺序相反** |
| `SUBSTR(s,-3)` | `RIGHT(s,3)` | MySQL `SUBSTRING` 支持负起点但语义需逐一核对 |
| `LISTAGG(c,',')` | `GROUP_CONCAT(c SEPARATOR ',')` | **必须调大 `group_concat_max_len`**，否则静默截断 |
| `STDDEV()` | **`STDDEV_SAMP()`** | 见 D5，样本 vs 总体 |
| `a(+) = b` | `LEFT JOIN` | Oracle 旧式外连接需全部改 ANSI 写法 |
| `SELECT ... FROM DUAL` | 同（MySQL 支持 `FROM DUAL`） | 5.7 中 `SELECT 1 WHERE ...` 无 FROM 不合法，**必须保留 `FROM DUAL`** |
| `CONNECT BY` | 5.7 无递归 CTE → 存储过程循环 / 闭包表 | 本系统税务机关层级似以 `LIKE` 前缀匹配实现（见 `Func_Get_Qxswjg`），影响可能有限，需摸底确认 |
| `/*+ HINT */` | 移除，改用索引调优 | Oracle Hint 语法在 MySQL 无效 |
| `PARALLEL` | **无并行查询** | 依赖并行的批处理需拆分为多任务并发，见 R2 |

### 4.3 PL/SQL 对象改造规范

#### 4.3.1 语言级映射

| Oracle PL/SQL | MySQL 5.7 |
|---|---|
| `CREATE PROCEDURE` | 同，但**参数需显式 `IN`/`OUT`**，且无默认值 |
| 函数返回结果集 / 集合类型 | **不支持** → 改为存储过程 `SELECT` 输出，或上移应用层 |
| `PACKAGE` | **不支持** → 拆为独立过程，命名 `包名_过程名`；包级变量无对应，改用会话变量或配置表 |
| 过程重载 | **不支持** → 重命名 |
| `%TYPE` / `%ROWTYPE` | **不支持** → 显式声明类型；建议用脚本从字典生成以降低维护成本 |
| 游标 `FOR` 循环 | `DECLARE CURSOR` + `CONTINUE HANDLER FOR NOT FOUND` + `LOOP`（**声明顺序：变量 → 游标 → 处理器**） |
| 嵌套游标 | 内层游标声明在嵌套 `BEGIN...END` 子块中，自带 NOT FOUND 处理器（作用域内优先于外层）。游标 SELECT 中的局部变量在 `OPEN` 时求值，故内层可直接引用外层变量。**已验证，见 `mysql-2.txt`** |
| `CONTINUE` | `ITERATE 标签` |
| `EXIT WHEN` | `IF ... THEN LEAVE 标签; END IF;` |
| `RETURN;`（过程中） | 删除，或用带标签块 + `LEAVE` |
| `EXCEPTION WHEN NO_DATA_FOUND` | `DECLARE CONTINUE HANDLER FOR NOT FOUND` |
| `EXCEPTION WHEN OTHERS` | `DECLARE EXIT HANDLER FOR SQLEXCEPTION` |
| `SQLERRM` / `SQLCODE` | `GET DIAGNOSTICS CONDITION 1 @errno=MYSQL_ERRNO, @msg=MESSAGE_TEXT` |
| `RAISE_APPLICATION_ERROR` | `SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='...'` |
| `SQL%ROWCOUNT` | `ROW_COUNT()` |
| `EXECUTE IMMEDIATE` | `PREPARE`/`EXECUTE`/`DEALLOCATE`。**存储函数中禁用**；**预处理语句结果集不能用游标遍历** |
| `BULK COLLECT` / `FORALL` | 无对应 → 临时表 + 集合 SQL |
| `PRAGMA AUTONOMOUS_TRANSACTION` | **无对应**。日志/审计类自治事务必须上移应用层（独立连接/独立事务） |
| `DBMS_OUTPUT.PUT_LINE` | 无对应 → 删除，或写入日志表（注意会进主事务） |
| `UTL_FILE` / `UTL_HTTP` / `UTL_SMTP` | 无对应 → 上移应用层 |
| `DBMS_JOB` / `DBMS_SCHEDULER` | **建议外部调度（XXL-JOB 等）**，不用 MySQL EVENT：EVENT 在备库被自动禁用，主备切换后任务静默不跑，且无重试、无告警、无执行历史 |
| 局部子过程/子函数 | 不支持 → 提升为独立对象 |
| 递归调用 | 需设 `max_sp_recursion_depth`（默认 0） |

#### 4.3.2 改造模板

嵌套游标的标准骨架（已在 `mysql-2.txt` 中验证，作为团队统一模板）：

```sql
CREATE PROCEDURE p_demo()
BEGIN
    DECLARE v_done_out TINYINT DEFAULT 0;
    DECLARE v_key VARCHAR(50);
    DECLARE cur_out CURSOR FOR SELECT k FROM t_rule;      -- 变量→游标→处理器
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done_out = 1;

    OPEN cur_out;
    read_out: LOOP
        FETCH cur_out INTO v_key;
        IF v_done_out = 1 THEN LEAVE read_out; END IF;
        IF <跳过条件> THEN ITERATE read_out; END IF;      -- 对应 Oracle CONTINUE

        BEGIN                                             -- 内层子块
            DECLARE v_done_in TINYINT DEFAULT 0;
            DECLARE v_col VARCHAR(50);
            DECLARE cur_in CURSOR FOR
                SELECT c FROM t_data WHERE k = v_key;     -- 引用外层变量，OPEN 时求值
            DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done_in = 1;

            SET v_done_in = 0;                            -- 显式重置，稳妥
            OPEN cur_in;
            read_in: LOOP
                FETCH cur_in INTO v_col;
                IF v_done_in = 1 THEN LEAVE read_in; END IF;
                -- 业务处理
            END LOOP read_in;
            CLOSE cur_in;
        END;
    END LOOP read_out;
    CLOSE cur_out;
END
```

#### 4.3.3 编码规范

1. 局部变量统一 `v_` / `p_` 前缀。**MySQL 中变量名与列名同名时列名优先**，不加前缀会产生极隐蔽的错误。
2. 每个过程配一个可重复执行的单测脚本（准备数据 → 调用 → 断言 → 清理）。
3. 改造后的脚本必须包含头注释：原 Oracle 对象名、转换要点、已知语义差异。参照 `mysql-2.txt` 的写法。
4. 所有改造脚本入 Git 管理，一对象一文件。

### 4.4 视图改造

| 事项 | 说明 |
|---|---|
| 派生表 | 5.7.7+ 视图内允许子查询，可用 |
| **用户变量** | **禁止**（ER 1351）。`ROW_NUMBER` 的变量法变通在视图内不可用 |
| 窗口函数替代 | 取每组第一条：改 `NOT EXISTS`（不存在更优的同组行）或 `JOIN (SELECT MAX(...) GROUP BY ...)` |
| 物化视图 | 无对应 → 改为**物理表 + 定时刷新作业**（全量重建或增量 MERGE），并在应用层容忍数据延迟 |
| 视图算法 | 含 `UNION`/聚合/`DISTINCT`/`LIMIT` 的视图会退化为 `TEMPTABLE`，**外层谓词无法下推**，导致全量物化。深层嵌套视图需重点压测 |
| 双引号标识符 | Oracle `"NSRSBH"` → MySQL 反引号，或开 `ANSI_QUOTES`（不建议，会影响字符串字面量） |

**`v_sbxx_sbdr_filemode` 改造示例**（去掉 `ROW_NUMBER()` 取每个 `sh.id` 的最新一条 `dk`）：

```sql
CREATE VIEW v_sbxx_sbdr_filemode AS
SELECT dj.nsrsbh, ... , CONCAT_WS('', SUBSTRING(ds.swjg_dm,8,4), ' ', ds.swjg_jc) AS swjg_jc
  FROM sb_sbxx_hz sh
  LEFT JOIN gs_dj_cktmsdab dj ON sh.nsrdzdah = dj.nsrdzdah
  LEFT JOIN gs_dj_cktmsdab_kz dk
         ON dj.nsrdzdah = dk.nsrdzdah AND dk.kzlx='FLGLCD' AND dk.flag='1'
        AND sh.sbrq BETWEEN dk.st_date AND dk.end_date
        -- 原 ROW_NUMBER() OVER(PARTITION BY sh.id ORDER BY dk.id DESC) = 1
        -- 改为反连接：不存在同条件下 id 更大的扩展记录
        AND NOT EXISTS (SELECT 1 FROM gs_dj_cktmsdab_kz dk2
                         WHERE dk2.nsrdzdah = dk.nsrdzdah AND dk2.kzlx='FLGLCD'
                           AND dk2.flag='1' AND sh.sbrq BETWEEN dk2.st_date AND dk2.end_date
                           AND dk2.id > dk.id)
  LEFT JOIN dm_swjg ds ON ds.swjg_dm = dj.zs_swjg_dm
 WHERE sh.sbzt_dm = '2B';
```

> 原视图第 10 行 `ON` 子句中还有一个 `rownum=1`（D4），语义不明确，**上述改写基于"取最新一条扩展信息"的推定，须经业务确认后定稿**。同时 `gs_dj_cktmsdab_kz(nsrdzdah,kzlx,flag,id)` 需建复合索引，否则反连接在 5.7 无 Hash Join 的情况下会很慢。

### 4.5 语义陷阱清单（必读）

这些差异**不会报错**，只会让结果悄悄变错，是本次迁移最大的质量风险来源。

| # | 陷阱 | Oracle | MySQL 5.7 | 应对 |
|---|---|---|---|---|
| T1 | **空串与 NULL** | `''` 就是 `NULL` | `''` ≠ `NULL` | 所有 `IS NULL`/`NVL`/拼接判断加 `NULLIF(col,'')`；迁移时决定是否把源端 `''` 统一写为 NULL（需业务确认） |
| T2 | **NULL 排序位置** | `ORDER BY c ASC` → NULL 在**最后** | NULL 在**最前** | 改写为 `ORDER BY c IS NULL, c`；影响所有列表页与报表顺序 |
| T3 | **字符串比较** | 区分大小写、VARCHAR2 区分尾空格 | `_ci` 不区分大小写；5.7 PAD SPACE 忽略尾空格 | 采用 `utf8mb4_bin`（D-03）；切换前检查唯一索引是否会新增冲突 |
| T4 | **除法精度** | `NUMBER` 除法保留高精度 | DECIMAL 除法小数位 = 原标度 + `div_precision_increment`(4) | 金额计算逐个核对，必要时显式 `ROUND()` |
| T5 | **数值转字符串** | `NUMBER` 拼接无多余尾零 | `DECIMAL(p,s)` 拼接带 s 位尾零 | 去尾零处理（`mysql-2.txt` 已实现），或收窄 DECIMAL 标度 |
| T6 | **`STDDEV`** | 样本标准差 | 总体标准差 | 映射为 `STDDEV_SAMP()`（D5） |
| T7 | **日期精度** | `DATE` 含时分秒 | `DATE` 不含 | 一律映射 `DATETIME` |
| T8 | **`MONTHS_BETWEEN`** | 返回小数 | `TIMESTAMPDIFF` 返回整数截断 | 需要小数的场景用日差换算 |
| T9 | **`INSTR` 参数序** | `INSTR(串, 子串)` | `LOCATE(子串, 串)` | 机械替换易错，需人工复核 |
| T10 | **`CHECK` 约束** | 强制生效 | **解析后静默忽略** | 建"降级约束清单"，由应用校验 + 稽核作业兜底 |
| T11 | **中文排序** | 取决于 `NLS_SORT` | 按编码点 | 若原为拼音排序需加拼音辅助列（D-03） |
| T12 | **隐式类型转换** | 字符与数字比较规则不同 | 字符列与数字比较会**导致索引失效** | 扫描 `WHERE 字符列 = 数字` 的写法并显式加引号 |
| T13 | **事务隔离级别** | 默认 RC | 默认 RR，间隙锁易死锁 | 设为 `READ-COMMITTED`（D-04） |
| T14 | **`COUNT(*)` 返回类型** | `BigDecimal` | `Long` | 应用层强转会 `ClassCastException`，见 [7.4](#74-类型映射变化java-侧高发缺陷) |

---

## 5. 数据迁移方案

### 5.0 迁移源端说明（v0.2）

**源端已变更**：本章全部内容的源端为**治理后的 Oracle 单 schema**，而非三 schema 原始库。

| 项 | 说明 |
|---|---|
| **迁移链路** | 生产 Oracle（3 schema）→ **治理转换脚本**（合并/归并/清理，计划书 W3A.A4.4 产出，W3B 已验证）→ **Oracle 单 schema 形态** → 本章的 Oracle→MySQL 迁移 → MySQL 单 database |
| **本章聚焦** | 仅后半段，即"单 schema Oracle → MySQL"。前半段的正确性由计划书 W3B 的业务验证（M2.5 门禁）保证 |
| **迁移范围** | **仅《对象映射总表》中 `migrate=Y` 的表**（处置码 K/M）。A/D 类（归档下线、废弃）**不迁移**，这是迁移量下降的来源 |
| **码值转换** | M 类（归并）表的码值按《码值映射表》转换，转换逻辑已随治理脚本在 W3B 验证 |
| **脚本一致性** | **割接执行的治理脚本必须与 W3B 验证通过的版本完全一致，禁止分叉**（计划书 10.2） |

> **实操提示**：割接当晚的实际操作是"生产 Oracle 快照 → 应用治理脚本 → 再应用本章迁移流程"，两段串联但都已分别演练。5.2 的切分、写入优化、顺序等策略适用于后半段。

### 5.1 工具选型

**内网约束：公有云 DTS 类服务（阿里云 DTS、腾讯 DTS）不可用**，必须选择可离线部署的工具。

| 用途 | 首选 | 备选 | 说明 |
|---|---|---|---|
| 结构转换 | 自研脚本（读 `DBA_TAB_COLUMNS` 生成 DDL） | MySQL Workbench Migration Wizard | 自研可控性最好，能内置本方案的类型映射与列宽收窄规则；工具产物必须人工复核 |
| 全量数据 | **DataX** | Kettle | 离线部署、oraclereader→mysqlwriter、支持切分并发与限速，国内政务项目主流 |
| 增量同步 | **OGG for MySQL**（若已有授权）| Debezium + Kafka（Oracle LogMiner） | 用于"不停机/短停机"割接；若接受较长停机窗口则可不用 |
| 一致性校验 | 自研校验脚本 | — | `pt-table-checksum` 仅支持 MySQL↔MySQL，跨异构不可用 |
| PL/SQL 转换 | **人工改造 + 本仓库积累的样例与规范** | SQLines（仅作参考） | 自动转换工具对本系统的动态 SQL/集合类型场景基本无效，不作为主路径 |

### 5.2 全量迁移

1. **切分策略**：大表按主键或日期列切分，DataX `splitPk` 并发 8–16 通道；小表串行。
2. **写入优化**（迁移期临时调整，割接后恢复）：
   - `innodb_flush_log_at_trx_commit=2`、`sync_binlog=0`
   - 迁移期先建表**不建二级索引**，数据导完后再 `ALTER TABLE ADD INDEX`（显著提速）
   - 关闭外键检查 `SET FOREIGN_KEY_CHECKS=0`，导完恢复
   - JDBC `rewriteBatchedStatements=true`，batchSize 1000–5000
3. **LOB 表**：单独通道、降低并发、调大 `max_allowed_packet`。
4. **顺序**：字典表/参数表 → 主数据表 → 业务表 → 明细大表。
5. **失败重跑**：按表粒度可重入（先 `TRUNCATE` 再导），并记录每表的开始/结束时间与行数。

### 5.3 增量追平

根据可接受的停机窗口二选一：

| 方案 | 适用 | 做法 | 停机窗口 |
|---|---|---|---|
| **A. 停机全量** | 停机窗口 ≥ 8h 且数据量可控 | 停应用 → 全量导 → 校验 → 切应用 | 长，但方案简单、风险低 |
| **B. 全量 + 增量** | 停机窗口 < 4h | 全量导（不停机）→ OGG/Debezium 追增量 → 窗口内停写、追平、校验、切换 | 短，但需额外搭建同步链路并做延迟监控 |

> 政务系统通常可申请周末长窗口，**初稿建议方案 A**，把复杂度花在验证而非同步链路上。若业务方明确要求 4 小时内完成，则转方案 B，需增加约 20 人日的同步链路搭建与演练。

### 5.4 一致性校验

分六层，逐层加严（**L6 为 v0.2 新增的治理专项**）：

| 层级 | 方法 | 覆盖 | 通过标准 |
|---|---|---|---|
| L1 行数 | 每表 `COUNT(*)` 两侧比对 | 全表 | 100% 一致 |
| L2 主键集合 | 按主键分桶取 `MIN/MAX/COUNT`，差异桶再下钻 | 全表 | 100% 一致 |
| L3 数值合计 | **所有金额、税额、数量列的 `SUM`/`MIN`/`MAX`** 比对 | 全部数值列 | 完全相等（不允许"接近"） |
| L4 全字段抽样 | 大表按主键随机抽 1‰（不少于 1000 行）逐字段比对 | 抽样 | 差异为 0 |
| L5 业务指标 | 用现网报表口径在两侧各跑一遍（如某月出口退税额、风险预警条数） | 关键指标 | 完全一致 |
| **L6 治理专项** | ① 归并表码值覆盖率；② 归并后无孤儿引用；③ **A/D 类表确未迁入**；④ MySQL 对象总数 = 映射总表 K/M 类数量 | 治理涉及对象 | ①=100%、②③④ 无例外 |

> **L1–L5 的比对基准需注意**：源端是治理后的单 schema，故 L1/L2/L3 应以**治理转换后的 Oracle 侧结果**为基准，而非三 schema 原始值——归并表的行数本就会变化。以原始值比对必然全表报错。
>
> **L6④"数字对不上即为遗漏"**：这是发现"映射表外新对象"（计划书风险 G9 漂移）的最后一道自动检查。

**L5 最具说服力，也最容易暴露 T1/T2/T4/T6 类语义陷阱**，必须由业务人员参与确认，不能只由技术侧自证。

校验注意点：

- 字符列比对要考虑排序规则差异，建议比对 `MD5(列值)` 而非直接比大小。
- 比对 `GROUP_CONCAT` 拼接的校验和时，两侧排序必须显式指定且一致。
- 空串/NULL 的处理策略（T1）会直接影响比对结果，须先定策略再比对。

---

## 6. ETL 改造方案

### 6.1 改造点清单

| 现状 | 改造 |
|---|---|
| 通过 DB Link 直连第三方 Oracle 抽数 | MySQL 无 DB Link（FEDERATED 引擎无谓词下推、性能与稳定性差，**不采用**）→ 改为 **DataX/Kettle 抽取落地** |
| 抽数后用 PL/SQL 清洗加工 | 按 [3.6](#36-决策-d-05存储过程去留策略) 分类：能集合化的改集合 SQL（C2），复杂编排上移调度平台（C3） |
| `MERGE INTO` 做增量合并 | `INSERT ... ON DUPLICATE KEY UPDATE`（**前置条件：目标表必须有唯一索引**，需逐表确认） |
| 物化视图做预汇总 | 物理汇总表 + 定时刷新作业 |
| `DBMS_JOB` 调度 | 外部调度平台（XXL-JOB），获得重试、告警、依赖编排、执行历史 |
| 依赖 `PARALLEL` 提速的大批量加工 | MySQL 无并行查询 → 拆分为按分片并发的多个任务 |
| 基于 `SJTB_SJ` 等时间戳的增量抽取 | 逻辑保留，但需确认时间戳列已建索引 |

### 6.2 第三方数据源双模适配（关键依赖）

第三方平台何时切 MySQL不由本项目控制，因此 ETL 必须**同时支持两种源**，且切换成本接近于零。

```
             ┌──────────────────────────────┐
             │      ETL 作业（业务逻辑）       │
             │  只依赖"抽数接口"，不依赖数据库   │
             └──────────────┬───────────────┘
                            │
              ┌─────────────▼─────────────┐
              │      数据源适配层           │
              │  配置化：dbType / url /    │
              │  driver / 方言 SQL 模板     │
              └───┬───────────────────┬────┘
                  │                   │
         ┌────────▼──────┐   ┌────────▼───────┐
         │ Oracle 源适配  │   │  MySQL 源适配   │
         │（第三方切换前） │   │（第三方切换后）  │
         └───────────────┘   └────────────────┘
```

设计要点：

1. 抽数 SQL 抽取为**方言模板**，按 `dbType` 选择，切换只改配置不改代码。
2. 抽数 SQL 尽量只用两侧都支持的语法（简单 `SELECT` + `WHERE` 时间戳增量），把方言差异压到最小。
3. **提前与第三方约定并书面确认**：
   - 切换时间点；
   - 切换后表结构、字段类型、字段含义是否变化（尤其是空串/NULL 策略、日期精度、数值精度）；
   - 是否提供切换前的测试环境供本系统联调；
   - 切换期间的双跑/回退安排。
4. **三种时序的应对**：

| 时序 | 影响 | 应对 |
|---|---|---|
| 第三方**早于**本系统切换 | 本系统仍是 Oracle，需从 MySQL 抽数 | 先上线 MySQL 源适配器，本系统自身迁移不受影响 |
| **同期**切换 | 两侧同时变动，问题定位困难 | **强烈建议错开**；若无法错开，需增加联合演练轮次 |
| 第三方**晚于**本系统切换 | 本系统已在 MySQL，仍需从 Oracle 抽数 | ETL 服务器需保留 Oracle 客户端/JDBC 驱动；此为**唯一允许的 Oracle 残留**，须在去 O 验收中单独说明并约定清退时点 |

> 最后一行是容易在验收时"卡壳"的点：去 O 验收口径若是"环境中不得存在任何 Oracle 组件"，而第三方尚未切换，则本系统无法验收。**须在项目启动阶段就与验收方明确该例外**，并写入验收标准。

---

## 7. 应用层（Java）改造方案

### 7.0 两阶段划分（v0.2）

应用改造拆为两个**可独立验证**的阶段，分界线清晰：**阶段一不碰任何 SQL 语法，只改对象名与码值；阶段二不碰对象名，只改语法。**

| | **阶段一：治理改造** | **阶段二：MySQL 改造** |
|---|---|---|
| 归属 | 计划书 W3B.B3 | **本章 7.1–7.8** |
| 运行环境 | Oracle 迁移环境（单 schema） | MySQL |
| 改造内容 | ① 去 schema 前缀（`TL_XXX.` 清除）<br>② 重命名表的引用更新<br>③ 归并表引用切换 + 码值映射<br>④ 停用功能的菜单/接口/定时任务下线 | ① 驱动与连接（7.1）<br>② 连接池（7.2）<br>③ 持久层与分页（7.3）<br>④ 类型映射（7.4）<br>⑤ 存储过程调用与 C3 上移（7.5）<br>⑥ 事务与锁（7.6）<br>⑦ 异常与错误码（7.7） |
| 驱动依据 | 《对象映射总表》`app_phase=1` 的条目 | 《对象映射总表》`app_phase=2` 的条目 + 本章规范 |
| 验证出口 | **B4 业务验证（M2.5），在 Oracle 上证明治理未影响业务** | 系统级联调 + W9 双跑比对（M5/M7） |
| SQL 语法 | **保持 Oracle 语法不变** | 改为 MySQL 语法 |

**为什么这样拆**：若两类改造混在一起，割接后出现"报表数据不对"，无法判断是清错了表还是改错了 SQL。拆开后，阶段一的问题在 Oracle 上就暴露并解决了，进入阶段二时数据结构已是确定的。

**两阶段的版本管理**（计划书 10.2）：主干 / 阶段一分支 / 阶段二分支三线并存，**每 2 周合并一次**。阶段一版本在迁移环境持续运行，且可能因迁移期新需求而变更，须与阶段二保持同步——这是本项目版本管理的主要复杂度来源（计划书风险 P1）。

> **7.3 的 `<databaseIdProvider>` 双方言技巧在两阶段模型下更有价值**：阶段一完成后，同一套代码带着 `oracle` 分支运行在迁移环境；阶段二为其补上 `mysql` 分支。双分支并存直接支撑双跑比对与快速回退。

### 7.1 依赖与连接

| 项 | Oracle | MySQL |
|---|---|---|
| 驱动 | `ojdbc6/7` | `mysql-connector-java`（8.0.x，驱动类 `com.mysql.cj.jdbc.Driver`，可连 5.7 服务端） |
| URL | `jdbc:oracle:thin:@host:1521:sid` | `jdbc:mysql://host:3306/db?useUnicode=true&characterEncoding=utf8&connectionCollation=utf8mb4_bin&serverTimezone=Asia/Shanghai&useSSL=false&rewriteBatchedStatements=true&zeroDateTimeBehavior=convertToNull&allowPublicKeyRetrieval=true` |
| 时区 | 无需指定 | **8.0 驱动必须指定 `serverTimezone`**，否则连接直接失败 |
| 批量写 | — | **`rewriteBatchedStatements=true` 必开**，否则 JDBC batch 退化为逐条执行 |
| 多语句 | — | 若有代码发送 `;` 分隔的多语句，需 `allowMultiQueries=true` |

依赖清理：移除 `ojdbc`、`orai18n`、`oracle.sql.*`、`OracleTypes` 等全部编译期依赖（ETL 模块除外，见 6.2）。

### 7.2 连接池

| 项 | 改造 |
|---|---|
| `validationQuery` | `SELECT 1 FROM DUAL` → **`SELECT 1`** |
| Druid `dbType` | `oracle` → `mysql`（影响 WallFilter、SQL 解析、监控统计） |
| `poolPreparedStatements` | Oracle 下常开；**MySQL 下建议关闭**（服务端预处理收益有限且占用服务端资源） |
| 连接数 | 需重新压测。MySQL 每连接一线程，连接数过高反而降吞吐；建议 `maxActive` 从 CPU 核数 × 4 起调 |
| `keepAlive` / 空闲回收 | MySQL 默认 `wait_timeout=28800`，需保证池内空闲检测周期小于它，否则出现"连接已被服务端关闭"异常 |

### 7.3 持久层

#### MyBatis

1. **`<databaseIdProvider>` 双方言并存** —— 迁移期最有价值的技巧：

   ```xml
   <databaseIdProvider type="DB_VENDOR">
     <property name="Oracle" value="oracle"/>
     <property name="MySQL"  value="mysql"/>
   </databaseIdProvider>
   ```

   同一个 `<select id="xxx">` 可写两份（`databaseId="oracle"` / `databaseId="mysql"`），运行时按实际数据源自动选择。这使得**同一套代码可同时在 Oracle 与 MySQL 上运行**，是双跑比对（[8.3](#83-双跑比对)）和快速回退的基础设施。建议改造期全程保留，割接稳定后再清理 Oracle 分支。

2. 主键生成：

   ```xml
   <!-- Oracle -->
   <selectKey keyProperty="id" order="BEFORE" resultType="long">
     SELECT SEQ_XXX.NEXTVAL FROM DUAL
   </selectKey>
   <!-- MySQL：AUTO_INCREMENT -->
   <insert useGeneratedKeys="true" keyProperty="id"> ... </insert>
   <!-- MySQL：序列模拟表 -->
   <selectKey keyProperty="id" order="BEFORE" resultType="long">
     SELECT FN_SYS_SEQUENCE_NEXTVAL('SEQ_XXX')
   </selectKey>
   ```

3. 分页：`ROWNUM` 三层嵌套 → `LIMIT #{offset},#{rows}`；PageHelper 设 `helperDialect=mysql`。注意**深分页性能**（`LIMIT 1000000,20` 会扫百万行），大偏移场景改为"基于上次最大主键的游标分页"。
4. 批量插入：`INSERT ALL ... SELECT * FROM DUAL` → `INSERT INTO t (...) VALUES (...),(...),(...)`（`<foreach>` 拼接）。
5. `jdbcType` 中的 Oracle 专有类型（如 `CURSOR`）需重写。

#### JPA / Hibernate（若使用）

- `Oracle10gDialect` → `MySQL57Dialect`（InnoDB 场景可用 `MySQL57InnoDBDialect`）。
- `@GeneratedValue(strategy=SEQUENCE)` → `IDENTITY` 或 `TABLE`。
- `@Column(columnDefinition=...)` 中的 Oracle 类型需改写。
- **禁止用 `hbm2ddl.auto=update` 做生产结构变更**，结构变更走版本化脚本（Flyway/Liquibase）。

### 7.4 类型映射变化（Java 侧高发缺陷）

**这是应用改造中最高发、最难靠代码走查发现的问题**：

| 场景 | Oracle 返回 | MySQL 返回 | 后果 |
|---|---|---|---|
| `SELECT COUNT(*)` | `BigDecimal` | `Long` | `(BigDecimal) map.get("CNT")` → `ClassCastException` |
| `NUMBER(18,0)` 列 | `BigDecimal` | `BIGINT` → `Long` | 同上 |
| `NUMBER(10,2)` 列 | `BigDecimal` | `DECIMAL` → `BigDecimal` | 一致 |
| `DATE` 列 | `Timestamp` | `DATETIME`→`Timestamp`；若误映射为 `DATE`→`java.sql.Date` | **时分秒丢失** |
| 结果为 `Map` 的查询 | 列名大写 | 列名按 SQL 中书写的大小写 | `map.get("NSRMC")` 取不到值 → **静默返回 null** |

应对：

1. **优先排查所有 `resultType="map"` / `Map<String,Object>` 的查询**，这类代码没有编译期检查，问题只在运行时暴露。改为明确的 POJO 映射。
2. 数值统一用 `BigDecimal` 接收后再转换，避免直接强转。
3. 全局搜索 `(BigDecimal)`、`(Long)`、`(Integer)` 强制转换点，逐一确认。
4. Map 取值的列名大小写：SQL 中显式写 `AS` 别名并统一大小写规范。

### 7.5 存储过程调用改造

| 场景 | Oracle | MySQL |
|---|---|---|
| 无返回值过程 | `{call P(?,?)}` | 相同 |
| 返回结果集 | 函数返回集合类型 / `OUT SYS_REFCURSOR` + `OracleTypes.CURSOR` | **MySQL 过程直接 `SELECT` 输出结果集**：`cs.execute()` 后 `cs.getResultSet()` |
| 多结果集 | — | `cs.getMoreResults()` 逐个取 |
| 上移应用层的（C3） | — | 改为普通 Service + MyBatis 查询，**取消存储过程调用** |

`func_shzs_rwwp`（审核任务委派）与 `func_get_wjdr_sblist`（分页列表）都属于 C3，改造后应用层直接以 Java 实现分支逻辑与动态查询条件拼装（用 MyBatis `<if>` 动态标签，同时消除 D1 的注入风险）。

### 7.6 事务与锁行为

| 差异 | 说明 | 应对 |
|---|---|---|
| 默认隔离级别 | Oracle RC vs MySQL RR | 服务端设 `READ-COMMITTED`（D-04），应用不再逐个 `@Transactional(isolation=...)` |
| 间隙锁 | RR 下范围更新产生间隙锁，Oracle 无此概念 | 切 RC 后大幅缓解；仍需对批量 `UPDATE ... WHERE 范围` 做死锁压测 |
| DDL | 两者均隐式提交 | 应用不得在事务中执行 DDL |
| `FOR UPDATE NOWAIT` | 5.7 无 | 改为依赖 `innodb_lock_wait_timeout` + 应用层重试；抢单类逻辑建议改为"乐观更新 + 影响行数判断" |
| 长事务 | Oracle undo 容忍度高 | MySQL 长事务导致 undo 膨胀、purge 滞后；需拆分批处理事务并设置监控告警 |
| 自治事务日志 | `PRAGMA AUTONOMOUS_TRANSACTION` | 上移应用层，用独立数据源/`REQUIRES_NEW` 传播，确保主事务回滚时日志仍保留 |

### 7.7 异常与错误码

代码中如有基于 Oracle 错误码的分支判断，需全部改写：

| 场景 | Oracle | MySQL |
|---|---|---|
| 唯一约束冲突 | `ORA-00001` | `1062` (`SQLState 23000`) |
| 非空约束冲突 | `ORA-01400` | `1048` |
| 值超长 | `ORA-12899` | `1406` |
| 死锁 | `ORA-00060` | `1213` |
| 锁等待超时 | `ORA-30006` | `1205` |
| 除零 | `ORA-01476` | `1365` |

> **建议不再直接判错误码**，改为捕获 Spring 的 `DuplicateKeyException`、`DataIntegrityViolationException` 等统一异常，由 `SQLExceptionTranslator` 屏蔽差异——一次改造，后续换库无感。

### 7.8 代码扫描

改造前先扫出全部待改点，形成可跟踪的清单（详见 [附录 D](#附录-d代码扫描命令)）。重点扫描范围：`*.xml`（MyBatis）、`*.java`、`*.sql`、`*.properties`/`*.yml`、以及**前端可能内嵌的 SQL 片段**和报表工具（帆软/润乾等）的数据集定义——报表工具里的 SQL 极易被遗漏。

---

## 8. 测试与验证方案

### 8.1 测试分层

| 层级 | 内容 | 责任方 | 通过标准 |
|---|---|---|---|
| 单元测试 | 每个改造后的存储过程/函数配可重复执行的测试脚本 | 开发 | 断言全通过 |
| 结构验证 | 表/列/索引/约束/默认值与源端逐项比对 | DBA | 差异清单为空或已说明 |
| 数据一致性 | L1–L5 五层校验（[5.4](#54-一致性校验)） | DBA + 业务 | 全部通过 |
| 功能回归 | 全量业务用例 | 测试 | 通过率 100% |
| **双跑比对** | 同输入在 Oracle 与 MySQL 各跑一遍比对输出 | 测试 + 业务 | 差异为 0 |
| 性能测试 | 联机 + 批处理 | 性能测试 | 达到 G4 |
| 高可用演练 | 主备切换、备份恢复 | 运维 | RTO/RPO 达标 |

### 8.2 重点测试方向

基于 [4.5](#45-语义陷阱清单必读) 的语义陷阱，设计**针对性用例**（常规回归用例覆盖不到这些）：

| 陷阱 | 专项用例 |
|---|---|
| T1 空串 | 构造含 `''` 与 `NULL` 的规则记录，验证"规则项为空则不过滤"的行为一致 |
| T2 NULL 排序 | 含 NULL 的列表页翻页，比对首页/末页记录 |
| T3 大小写 | 用大小写混合的编码值查询，验证不会多查/少查 |
| T4/T5 数值 | 金额除法、金额拼接进提示文案，逐字符比对文案 |
| T6 标准差 | `F_MY_STDAVG_TMPTB` 用固定数据集验证结果与 Oracle 完全一致 |
| T10 CHECK | 尝试写入违反原 CHECK 约束的数据，确认应用层已拦截 |
| T11 中文排序 | 纳税人名称列表排序结果整页比对 |
| T14 类型 | 遍历所有 `resultType="map"` 的接口，验证无 `ClassCastException`、无字段取空 |

### 8.3 双跑比对

**这是本方案中性价比最高的验证手段**，依托 [7.3](#73-持久层) 的 MyBatis `databaseIdProvider` 实现：

1. 测试环境同时保留 Oracle 与 MySQL 两套数据（数据已通过 L1–L4 校验一致）。
2. 同一应用、同一请求，分别打到两个数据源，记录响应。
3. 自动化比对响应 JSON（忽略时间戳、序列 ID 等必然不同的字段）。
4. 覆盖范围优先级：**报表与统计类 > 列表查询类 > 单笔业务办理类**（前者最容易受语义陷阱影响且最难人工发现）。
5. 批处理作业同样双跑：同一输入数据，比对两侧产生的预警记录、短信推送记录条数与内容。

### 8.4 性能测试

| 场景 | 关注点 |
|---|---|
| 核心联机交易 | P95/P99 响应时间、TPS |
| **大表多表关联查询** | **5.7 无 Hash Join，是最大风险点**。必须逐条 `EXPLAIN`，确认走索引嵌套循环而非 BNL；发现 `Using join buffer (Block Nested Loop)` 即为高危信号 |
| 存储过程批处理 | 总时长是否在原窗口内；重点是含游标循环的 C1 过程 |
| ETL 全流程 | 抽数 + 清洗 + 加工端到端时长 |
| 深分页 | 大偏移量查询 |
| 并发写入 | 序列模拟表是否成为热点；死锁率 |

**性能问题的处理顺序**：加索引 → 改写 SQL（拆分大 JOIN、中间结果落临时表）→ 集合化改造（C2）→ 预计算宽表 → 最后才考虑加硬件。

### 8.5 验收标准

1. G1–G6 全部达成。
2. 数据一致性 L1–L5 全部通过，业务方书面确认。
3. 功能回归通过率 100%，双跑比对差异为 0（或差异已逐条说明并经业务确认）。
4. 性能达标（G4），且无 `EXPLAIN` 中的高危信号遗留。
5. 割接与回退演练各成功一次。
6. 交付物齐全（见 [10.4](#104-交付物清单)）。

---

## 9. 割接方案

### 9.0 割接范围收窄（v0.2）

**割接夜不再叠加治理决策，只执行两段已分别演练过的脚本。**

| | v0.1（治理与迁移同夜完成） | **v0.2（治理已前置验证）** |
|---|---|---|
| 割接内容 | 迁移 + 合并 + 归并 + 清理，四件事同时做 | **① 应用治理转换脚本（已在 W3B 验证）② Oracle→MySQL 迁移（已演练 3 轮）** |
| 出错归因 | 数据不对时无法区分是清错了还是迁错了 | **治理已在 Oracle 上验证过，异常直接指向迁移环节** |
| 检查单长度 | 长，含大量治理项 | **短**，治理项仅剩核验性检查（见计划书附录 D） |
| 决策点 | 多 | 少 |

**割接前必做的一项新增动作**：**基线核对**（计划书 2.3.5 漂移-4）——割接前 2 周执行生产 Oracle 与《对象映射总表》的全量对象比对，任何未登记对象须当场裁决（迁移或跳过）。项目周期 13 个月，生产侧新增对象几乎必然，这是路径 A 的最后一道保险。

### 9.1 割接策略

初稿建议 **停机全量割接**（对应 [5.3](#53-增量追平) 方案 A）。理由：政务系统可申请周末长窗口；方案简单意味着风险点少、可演练、可回退。

### 9.2 割接时间线（示例：周六 20:00 起，窗口 12 小时）

| 时刻 | 动作 | 负责 | 回退检查点 |
|---|---|---|---|
| T-7d | 割接演练（全流程，含回退） | 全体 | — |
| T-1d | 冻结代码与配置；确认备份可用 | 开发/运维 | — |
| 20:00 | 停应用、停 ETL、停定时任务；确认无活动会话 | 运维 | — |
| 20:15 | **Oracle 全量备份**（最终回退点） | DBA | ★ 回退点 1 |
| 20:30 | **执行治理转换脚本**（schema 合并、码值归并、A/D 类排除）；核对对象数 | DBA | ★ 脚本失败则回退 |
| 21:30 | 启动全量数据迁移 | DBA | — |
| 02:00 | 迁移完成，建二级索引、恢复外键检查 | DBA | — |
| 03:00 | 数据校验 L1–L3、**L6 治理专项** | DBA | ★ 校验不通过则回退 |
| 04:00 | 序列初始化（以业务表 `MAX(ID)` 为准）、参数恢复生产值 | DBA | — |
| 04:30 | 应用切换配置并启动；冒烟测试 | 开发 | ★ 回退点 2 |
| 05:30 | **业务方分级验证：先一级（报表模块）→ 二级 → 三级** | 业务 | ★ 决策点：**仅一级功能不通过才触发回退评估** |
| 06:30 | 开启 ETL 与定时任务，观察首轮执行 | 运维 | — |
| 08:00 | **割接完成确认**，Oracle 置为只读保留 | 全体 | — |
| T+1 ~ T+7 | 加强监控；Oracle 只读保留待命 | 运维 | ★ 回退窗口 |
| T+30 | 确认稳定后，Oracle 归档下线 | DBA | — |

> **时间线须按实测重算**：v0.2 新增的治理脚本执行步骤（20:30）占用约 1 小时（示例值），其真实耗时须在 W3B.B2 与割接演练中实测。若治理脚本 + 迁移的合计耗时超过窗口 60%，须申请延长窗口或转 [5.3](#53-增量追平) 方案 B。

### 9.3 回退方案

**回退触发阈值按功能重要性分级（v0.2）**——系统为辅助性，二三级功能问题不构成回退理由：

| 回退时机 | 触发条件 | 动作 | 预计耗时 |
|---|---|---|---|
| 割接窗口内 | 治理脚本失败 / 数据校验（含 L6）不通过 / 冒烟失败 | 应用配置切回 Oracle，Oracle 解除只读 | 30 分钟 |
| 割接窗口内 | **一级功能（报表模块）验证不通过** | 同上 | 30 分钟 |
| 割接窗口内 | 二级/三级功能问题 | **不回退**，登记后按投产后修复处理 | — |
| T+7 内 | **仅当一级功能不可用或数据错误** | 应用切回 Oracle；**MySQL 期间产生的增量数据需人工回补** | 数小时至 1 天 |
| T+7 内 | 二级/三级功能问题、性能不达标但功能正常 | **不回退**，启动应急优化或投产后修复 | — |
| T+7 后 | — | 不再回退，转为问题修复 | — |

> **提高回退阈值是 v0.2 的实质收益**：T+7 内回退需人工回补增量数据、代价高昂。将触发条件限定为"报表模块故障"后，回退触发概率大幅下降，割接夜决策压力与 T+7 观察期负担同步下降。**前提是业务方书面接受"二三级功能可带病投产、投产后修复"**（计划书附录 F 第 20 项）。

**关键前提**：

1. 割接后 Oracle **保留只读**（不删、不停机），保证随时可切回。
2. 应用侧数据源切换必须**配置化、可秒级切换**，不允许需要重新编译打包。
3. **T+7 内的回退会丢失/需回补 MySQL 期间的增量数据**——这是回退的真实代价，必须让业务方在割接前就知晓并书面确认，不能等到要回退时才讨论。
4. 回退决策权归业务方，技术侧只提供判断依据与执行。
5. **回退不撤销治理**：回退目标是"生产 Oracle 原三 schema 形态"（该库在割接前始终未被改动），治理只存在于迁移环境与 MySQL 侧。这意味着**回退是干净的**，不需要反向撤销合并与归并。

### 9.4 割接检查单（摘要）

> 本检查单为迁移技术项；**治理与验证专项检查项见计划书附录 D**，两份合并使用。

- [ ] Oracle 全量备份完成且验证可恢复
- [ ] 所有应用实例已停止，无活动数据库会话
- [ ] ETL 与定时任务已停止
- [ ] 数据迁移日志无 ERROR，每表行数已记录
- [ ] L1/L2/L3 校验全部通过
- [ ] 序列初始值已按业务表 `MAX(ID)` 设置并复核
- [ ] MySQL 参数已从迁移态恢复为生产态（`innodb_flush_log_at_trx_commit=1`、`sync_binlog=1`）
- [ ] 二级索引、外键、触发器已全部创建并与清单核对
- [ ] 存储过程/函数/视图数量与清单一致，无编译错误
- [ ] 应用配置已切换；连接池、时区、字符集验证通过
- [ ] 冒烟用例通过
- [ ] 业务方关键功能确认通过
- [ ] 监控告警已生效
- [ ] Oracle 已置为只读并保留

---

## 10. 实施计划与组织

### 10.1 阶段划分

> **v0.2：本节已由计划书第 3、4 章取代，此处仅保留摘要与对应关系。** 详细的工作分解、步骤、完成标准、门禁判定以**计划书为准**。

| 本方案阶段 | 对应计划书工作包 | 周期 | 里程碑 |
|---|---|---|---|
| P0 准备 | **W1** 项目启动与准备（含源码保真度整改 2.5） | 4 周 | M0 方案评审通过 |
| P1 摸底评估 | **W2** 资产盘点与摸底（含血缘分析、重复表识别） | 6 周 | M1 盘点完成 |
| **P1.5 治理判定**（新增） | **W3A** 治理判定与基线设计 | 4 周 | **M2 治理决策门禁** |
| **P1.6 治理执行与验证**（新增） | **W3B** 迁移环境治理执行与业务验证 | 12 周 | **M2.5 治理验证门禁** |
| P2 结构与规范 | **W4** 目标库设计与结构迁移 | 4 周 | M3 结构就绪 |
| P3 对象改造 | **W5** 数据库对象改造（**最大工作量**） | 15 周 | M4 对象改造完成 |
| P4 应用改造 | **W6** 应用改造**阶段二**（阶段一在 W3B 完成，见 [7.0](#70-两阶段划分v02)） | 13 周（与 P3 并行） | M5 联调通过 |
| P5 ETL 改造 | **W7** ETL 改造 | 9 周（与 P3 并行） | M5 |
| P6 数据迁移 | **W8** 数据迁移与校验 | 7 周（与 P4 并行） | M6 迁移演练通过 |
| P7 测试 | **W9** 测试与验证（**按功能重要性分级确定深度**） | 9 周 | M7 测试验收通过 |
| P8 割接 | **W10** 割接与投产 | 3 周 | M8 演练 / M9 投产 |
| P9 稳定期 | **W11** 稳定运行与项目关闭 | 8 周 | M10 项目关闭 |

**总周期约 13 个月**（2026-08 ~ 2027-08）。关键路径：**W1 → W2 → W3A(M2) → W3B(M2.5) → W5 → W9 → W10**。

> **治理前置未延长总工期**：W3B 与 W4/W5 前段并行；代价体现在工作量与预生产服务器资源，而非日历周期。详见计划书 4.2/4.3。

### 10.2 工作量估算

| 工作包 | 人日 | 依据 |
|---|---|---|
| 摸底与评估 | 60 | — |
| 结构迁移（含类型映射、DDL、索引、分区改造） | 90 | 按 800 表估算 |
| 存储过程/函数改造 | 285 | [2.3](#23-抽样对象的改造难度实证) 实测标定 × 150 对象 |
| 视图改造 | 48 | 0.8 × 60 |
| 序列/触发器/作业改造 | 40 | — |
| 应用层改造 | 240 | — |
| ETL 改造（含双模适配） | 120 | — |
| 数据迁移与校验 | 90 | — |
| 测试（含双跑比对平台搭建） | 200 | — |
| 割接与演练 | 40 | — |
| 项目管理与文档 | 80 | — |
| **小计** | **1293** | |
| 风险余量 20% | 259 | |
| **合计** | **≈ 1550 人日** | |

> 按 12 人团队、月均 20 工作日计，约 6.5 人月×12 ≈ 6.5 个月净工作量，考虑并行度与等待，与 11–12 个月日历周期匹配。**摸底完成后必须以实际对象数与难度分布复算**——当前基数是假设值。

> **v0.2 更新**：上表为"不含治理"的技术基线。计入治理与验证后，**合计约 1850 人日（+19%）**，其中新增 540、减量 240。完整测算与"这笔钱买到了什么"的分析见**计划书 6.4**，本表不再重复。

### 10.3 组织分工

| 角色 | 人数 | 职责 |
|---|---|---|
| 项目经理 | 1 | 整体计划、跨方协调（**尤其是第三方平台的时点对齐**）、风险管理 |
| 架构师 | 1 | 技术决策、疑难攻关、方案评审 |
| DBA | 2 | 结构迁移、数据迁移、参数调优、高可用、割接执行 |
| 数据库开发 | 4 | 存储过程/函数/视图改造与单测 |
| Java 开发 | 4 | 应用层改造、C3 上移逻辑实现 |
| ETL 开发 | 2 | ETL 改造与双模适配 |
| 测试 | 3 | 回归、双跑比对、性能、专项语义测试 |
| 业务专家 | 2（兼职） | **语义确认（D3/D4）**、业务指标校验、割接决策 |

> 业务专家的投入常被低估。[2.4](#24-抽样对象中发现的既有问题) 中 D3/D4 这类"代码写了什么不等于业务要什么"的问题，只能由业务方拍板，技术侧无法自行决定。建议在计划中明确其参与节点与工时。

### 10.4 交付物清单

| 类别 | 交付物 |
|---|---|
| 评估 | 对象清单与难度分级表、数据画像报告、代码扫描清单、表名冲突检查报告 |
| 设计 | 本方案定稿、数据类型映射表、改造编码规范、MySQL 参数基线 |
| 代码 | 目标库 DDL 脚本、改造后的存储过程/函数/视图脚本（一对象一文件，Git 管理）、应用改造代码 |
| 迁移 | 数据迁移脚本与配置、一致性校验脚本、迁移执行报告 |
| 测试 | 测试用例集、双跑比对报告、性能测试报告、专项语义测试报告 |
| 运维 | 部署手册、参数基线、备份恢复手册、监控告警配置、应急预案 |
| 割接 | 割接方案与检查单、回退方案、演练报告、割接执行记录 |
| 遗留 | **降级约束清单**（被忽略的 CHECK）、**已知差异清单**、**待优化清单**（C2 候选、`ONLY_FULL_GROUP_BY` 整改项） |

---

## 11. 风险登记册

> **v0.2 影响判定基准变更**：系统为**辅助性业务系统**，功能分三级（一级=报表模块，二三级见计划书 1.7）。风险"影响"等级据此重估：
>
> | 影响 | v0.2 判定 |
> |---|---|
> | 高 | 里程碑延误 >4 周 / **一级功能（报表）数据错误或不可用** |
> | 中 | 延误 1–4 周 / **二级功能受影响** |
> | 低 | 延误 <1 周 / **三级功能受影响，可投产后修复** |
>
> **本表仅列技术风险。治理类风险（G1–G10）与管理类风险（P1–P6）见计划书 7.2**，其中 G8（B4 验证覆盖不足）、G9（迁移环境与生产漂移）、G10（治理脚本未固化）、P1（三轨版本合不拢）为 v0.2 新增的高等级风险，与本方案的实施直接相关。

| 编号 | 风险 | 等级 | 影响 | 应对 |
|---|---|---|---|---|
| **R1** | **MySQL 5.7 已停止官方支持**，无安全补丁 | 高 | 长期安全合规风险 | 评审阶段正式提出升级 8.0 的建议并留档；若维持 5.7，需内网安全加固 + 明确后续升级路线 |
| **R2** | **5.7 无 Hash Join、无并行查询**，大表关联与批处理性能断崖 | 高 | 批处理超窗口、报表超时 | 提前对 TOP50 慢 SQL 做 `EXPLAIN` 预演；建索引 → 拆 SQL → 中间表 → 预计算宽表；把此项列为性能测试第一优先级 |
| **R3** | 语义陷阱导致**静默数据错误**（T1/T2/T4/T6 等） | 高 | 业务数据错误且难发现 | [8.2](#82-重点测试方向) 专项用例 + [8.3](#83-双跑比对) 双跑比对 + L5 业务指标校验 |
| **R4** | **第三方平台切换时点不可控** | 高 | ETL 中断或去 O 验收受阻 | 双模适配层（[6.2](#62-第三方数据源双模适配关键依赖)）；**项目启动阶段即与验收方书面明确 Oracle 驱动残留的例外条款** |
| **R5** | 存储过程改造量与难度超预期 | 中高 | 工期延误 | 摸底后立即复算；C3/C4 分流以减少直译量；高难度对象优先启动 |
| **R6** | 表名冲突（合并单库方案） | 中 | 需重命名并连带改应用 | P1 阶段完成冲突检查（A-9），有冲突则重新评估方案 A；**v0.2：冲突消解与应用改动在 W3B.B3 阶段一集中完成并在 Oracle 上验证，不带入 MySQL 阶段** |
| **R7** | 分区表主键改造引发连锁影响 | 中 | 外键、ORM、查询大范围调整 | 优先评估改为"归档表"而非分区 |
| **R8** | 源码保真度问题（[2.5](#25-源码保真度问题需立即处理)） | 中 | 改造基于错误输入 | P0 阶段完成全量 `DBA_SOURCE` 比对，建立源码直取流程 |
| **R9** | 与信创（OS/CPU）改造同期进行 | 中 | 问题定位困难、窗口冲突 | 争取错开；若必须同期，增加联合演练轮次并明确问题归口 |
| **R10** | 团队 MySQL 经验不足 | 中 | 改造质量与效率 | P0 阶段专项培训；以本仓库已完成样例（`mysql-2.txt` 等）作为教材与模板；建立代码评审机制 |
| **R11** | 停机窗口不被批准 | 中 | 割接方案需改为不停机 | 尽早申请；备选方案 B（全量+增量），预留 20 人日 |
| **R12** | 回退时增量数据回补困难 | 中 | 回退代价高于预期 | 割接前与业务方书面确认回退代价；**v0.2：回退触发限定为一级功能故障（[9.3](#93-回退方案)），触发概率大幅下降**；且回退目标为未被改动的生产 Oracle 原库，无需反向撤销治理 |
| **R13**<br>*(v0.2 新增)* | **迁移环境与生产 Oracle 漂移**，割接时出现《对象映射总表》外的新对象 | 高 | 割接遗漏对象、L6 校验失败 | 计划书 2.3.5 五条漂移管控（结构变更 5 日内同步、新对象强制登记、割接前 2 周全量比对兜底、双冻结）；本方案 [9.0](#90-割接范围收窄v02) 基线核对 |
| **R14**<br>*(v0.2 新增)* | **治理脚本未固化**，W3B 跑通但割接时重现不了 | 高 | 治理成果无法落地，割接失败 | "跑通了但没进脚本视同未完成"写入门禁；B4 用刷新后的数据快照重放脚本验证可重复性；脚本版本化，**割接版本 = 验证版本，禁止分叉** |

---

## 12. 附录

### 附录 A：Oracle 摸底脚本

```sql
-- A-1 对象清单
SELECT owner, object_type, COUNT(*) cnt
  FROM dba_objects
 WHERE owner IN ('TL_TSSH','TL_ADMIN','TL_BJTS')
 GROUP BY owner, object_type ORDER BY 1,2;

-- A-2 PL/SQL 源码规模（工作量主驱动）
SELECT owner, name, type, MAX(line) lines
  FROM dba_source
 WHERE owner IN ('TL_TSSH','TL_ADMIN','TL_BJTS')
 GROUP BY owner, name, type ORDER BY lines DESC;

-- A-3 高难度特性扫描（定位 C3 类对象）
SELECT owner, name, type, line, text
  FROM dba_source
 WHERE owner IN ('TL_TSSH','TL_ADMIN','TL_BJTS')
   AND (  UPPER(text) LIKE '%CONNECT BY%'      OR UPPER(text) LIKE '%ROW_NUMBER%'
       OR UPPER(text) LIKE '%OVER%(%'          OR UPPER(text) LIKE '%WITH%AS%('
       OR UPPER(text) LIKE '%EXECUTE IMMEDIATE%' OR UPPER(text) LIKE '%REF CURSOR%'
       OR UPPER(text) LIKE '%DBMS\_%' ESCAPE '\' OR UPPER(text) LIKE '%AUTONOMOUS%'
       OR UPPER(text) LIKE '%BULK COLLECT%'    OR UPPER(text) LIKE '%FORALL%'
       OR UPPER(text) LIKE '%MERGE INTO%'      OR UPPER(text) LIKE '%LISTAGG%'
       OR UPPER(text) LIKE '%REGEXP\_%' ESCAPE '\' OR UPPER(text) LIKE '%UTL\_%' ESCAPE '\'
       OR UPPER(text) LIKE '%PIPELINED%'       OR UPPER(text) LIKE '%STDDEV%' )
 ORDER BY owner, name, line;

-- A-4 表数据量与空间
SELECT owner, table_name, num_rows, ROUND(blocks*8/1024) mb, partitioned
  FROM dba_tables
 WHERE owner IN ('TL_TSSH','TL_ADMIN','TL_BJTS')
 ORDER BY num_rows DESC NULLS LAST;

-- A-5 无精度 NUMBER 列（须实测真实精度后再定 DECIMAL(p,s)）
SELECT owner, table_name, column_name
  FROM dba_tab_columns
 WHERE owner IN ('TL_TSSH','TL_ADMIN','TL_BJTS')
   AND data_type = 'NUMBER' AND data_precision IS NULL;
-- 对上述每列执行（示例）：
-- SELECT MAX(LENGTH(TO_CHAR(TRUNC(ABS(col))))) int_digits,
--        MAX(NVL(LENGTH(SUBSTR(TO_CHAR(col), INSTR(TO_CHAR(col),'.')+1)),0)) dec_digits
--   FROM owner.table WHERE col IS NOT NULL;

-- A-6 宽表检查（MySQL 单行上限 65535 字节，utf8mb4 下 VARCHAR2(4000)≈16000 字节）
SELECT owner, table_name,
       SUM(CASE WHEN data_type LIKE 'VARCHAR2%' OR data_type LIKE 'CHAR%'
                THEN data_length*4 ELSE 8 END) est_bytes_utf8mb4
  FROM dba_tab_columns
 WHERE owner IN ('TL_TSSH','TL_ADMIN','TL_BJTS')
 GROUP BY owner, table_name HAVING SUM(CASE WHEN data_type LIKE 'VARCHAR2%'
        OR data_type LIKE 'CHAR%' THEN data_length*4 ELSE 8 END) > 60000
 ORDER BY 3 DESC;

-- A-7 LOB / 特殊类型
SELECT owner, table_name, column_name, data_type
  FROM dba_tab_columns
 WHERE owner IN ('TL_TSSH','TL_ADMIN','TL_BJTS')
   AND data_type IN ('CLOB','NCLOB','BLOB','LONG','RAW','LONG RAW','XMLTYPE','ROWID','UROWID');

-- A-8 CHECK 约束（MySQL 5.7 将静默忽略，须建降级清单）
SELECT owner, table_name, constraint_name, search_condition
  FROM dba_constraints
 WHERE owner IN ('TL_TSSH','TL_ADMIN','TL_BJTS') AND constraint_type = 'C'
   AND generated = 'USER NAME';

-- A-9 【合并单库方案的前置检查】跨 schema 表名冲突
SELECT table_name, COUNT(DISTINCT owner) n, LISTAGG(owner,',') WITHIN GROUP (ORDER BY owner) owners
  FROM dba_tables
 WHERE owner IN ('TL_TSSH','TL_ADMIN','TL_BJTS')
 GROUP BY table_name HAVING COUNT(DISTINCT owner) > 1;

-- A-10 分区表（MySQL 分区键必须包含在每个唯一键中）
SELECT owner, table_name, partitioning_type, subpartitioning_type, partition_count
  FROM dba_part_tables WHERE owner IN ('TL_TSSH','TL_ADMIN','TL_BJTS');

-- A-11 序列、触发器、同义词、DB Link、物化视图、作业
SELECT * FROM dba_sequences  WHERE sequence_owner IN ('TL_TSSH','TL_ADMIN','TL_BJTS');
SELECT owner,trigger_name,table_name,triggering_event,status FROM dba_triggers
 WHERE owner IN ('TL_TSSH','TL_ADMIN','TL_BJTS');
SELECT * FROM dba_synonyms   WHERE owner IN ('TL_TSSH','TL_ADMIN','TL_BJTS');
SELECT * FROM dba_db_links;
SELECT owner,mview_name,refresh_mode,refresh_method FROM dba_mviews;
SELECT job,what,interval FROM dba_jobs;
SELECT owner,job_name,job_action,repeat_interval,enabled FROM dba_scheduler_jobs;

-- A-12 NLS 设置（决定字符集与排序规则映射）
SELECT parameter, value FROM nls_database_parameters
 WHERE parameter IN ('NLS_CHARACTERSET','NLS_NCHAR_CHARACTERSET','NLS_SORT','NLS_COMP','NLS_LENGTH_SEMANTICS');

-- A-13 跨 schema 依赖（验证 2.1 的同实例约束）
SELECT owner, name, type, referenced_owner, referenced_name, referenced_type
  FROM dba_dependencies
 WHERE owner IN ('TL_TSSH','TL_ADMIN','TL_BJTS')
   AND referenced_owner NOT IN ('SYS','SYSTEM','PUBLIC')
   AND referenced_owner <> owner;

-- A-14 越界日期（MySQL DATETIME 下限 1000-01-01）
-- 对每个 DATE/TIMESTAMP 列执行：
-- SELECT COUNT(*) FROM owner.table WHERE col < DATE'1000-01-01' OR col > DATE'9999-12-31';
```

### 附录 B：MySQL 参数基线

```ini
[mysqld]
# ---- 必须在实例初始化前确定 ----
lower_case_table_names        = 1
character_set_server          = utf8mb4
collation_server              = utf8mb4_bin

# ---- 兼容 Oracle 行为 ----
transaction_isolation         = READ-COMMITTED
binlog_format                 = ROW
sql_mode                      = STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION
# 注：ONLY_FULL_GROUP_BY 暂不开启，整改完成后择机开启

# ---- 容量与行为 ----
innodb_large_prefix           = ON
innodb_file_per_table         = ON
group_concat_max_len          = 1048576
max_allowed_packet            = 64M
innodb_lock_wait_timeout      = 10
event_scheduler               = OFF
log_bin_trust_function_creators = 1        # 序列模拟函数需要
max_sp_recursion_depth        = 0          # 有递归过程时按需放开

# ---- 生产态（迁移期可临时放宽，割接前必须恢复）----
innodb_flush_log_at_trx_commit = 1
sync_binlog                    = 1

# ---- 诊断 ----
slow_query_log                = ON
long_query_time               = 1
log_queries_not_using_indexes = OFF        # 量太大，按需临时开启
performance_schema            = ON
```

### 附录 C：函数与语法映射速查

| 分类 | Oracle | MySQL 5.7 |
|---|---|---|
| 空值 | `NVL(a,b)` | `IFNULL(a,b)` |
| 空值 | `NVL2(a,b,c)` | `IF(a IS NOT NULL,b,c)` |
| 空值 | `COALESCE` | `COALESCE`（相同） |
| 空值 | `NULLIF` | `NULLIF`（相同） |
| 条件 | `DECODE(x,v1,r1,d)` | `CASE WHEN x=v1 THEN r1 ELSE d END` |
| 字符 | `a \|\| b` | `CONCAT_WS('',a,b)` |
| 字符 | `SUBSTR(s,p,l)` | `SUBSTRING(s,p,l)` |
| 字符 | `INSTR(s,sub)` | `LOCATE(sub,s)`（**参数序相反**） |
| 字符 | `LENGTH` / `LENGTHB` | `CHAR_LENGTH` / `LENGTH` |
| 字符 | `LPAD` / `RPAD` / `TRIM` / `REPLACE` | 同名 |
| 字符 | `LISTAGG(c,',') WITHIN GROUP(ORDER BY x)` | `GROUP_CONCAT(c ORDER BY x SEPARATOR ',')` |
| 字符 | `REGEXP_LIKE(c,p)` | `c REGEXP BINARY p` |
| 字符 | `REGEXP_SUBSTR` / `REGEXP_REPLACE` / `REGEXP_INSTR` | **无**（上移应用层） |
| 日期 | `SYSDATE` | `NOW()` |
| 日期 | `SYSTIMESTAMP` | `NOW(6)` |
| 日期 | `d + n` / `d - n` | `DATE_ADD(d,INTERVAL n DAY)` / `DATE_SUB` |
| 日期 | `d1 - d2`（天数） | `DATEDIFF(d1,d2)`（仅日期部分）或 `TIMESTAMPDIFF(SECOND,d2,d1)/86400` |
| 日期 | `ADD_MONTHS(d,n)` | `DATE_ADD(d,INTERVAL n MONTH)` |
| 日期 | `MONTHS_BETWEEN(a,b)` | `TIMESTAMPDIFF(MONTH,b,a)`（**整数截断**） |
| 日期 | `LAST_DAY(d)` | `LAST_DAY(d)` |
| 日期 | `TRUNC(d)` | `DATE(d)` |
| 日期 | `TRUNC(d,'MM')` | `DATE_FORMAT(d,'%Y-%m-01')` |
| 日期 | `TO_CHAR(d,'yyyy-mm-dd hh24:mi:ss')` | `DATE_FORMAT(d,'%Y-%m-%d %H:%i:%s')` |
| 日期 | `TO_DATE(s,'yyyy-mm-dd')` | `STR_TO_DATE(s,'%Y-%m-%d')` |
| 数值 | `TRUNC(n,d)` | `TRUNCATE(n,d)` |
| 数值 | `ROUND` / `CEIL` / `FLOOR` / `MOD` / `ABS` | `ROUND` / `CEILING` / `FLOOR` / `MOD` / `ABS` |
| 数值 | `TO_NUMBER(s)` | `CAST(s AS DECIMAL(38,10))` |
| 数值 | `STDDEV` | **`STDDEV_SAMP`** |
| 数值 | `VARIANCE` | `VAR_SAMP` |
| 分页 | `ROWNUM <= n` | `LIMIT n` |
| 分页 | `ROW_NUMBER() OVER(...)` | 相关子查询 / 自连接（视图内禁用用户变量） |
| 结构 | `WITH x AS (...)` | 派生表 |
| 结构 | `CONNECT BY` | 过程循环 / 闭包表 |
| 结构 | `MERGE INTO` | `INSERT...ON DUPLICATE KEY UPDATE` 或 `INSERT...SELECT...WHERE NOT EXISTS` |
| 结构 | `INSERT ALL` | 多值 `INSERT INTO t VALUES(...),(...)` |
| 结构 | `a(+)=b` | `LEFT JOIN` |
| 结构 | `FROM DUAL` | `FROM DUAL`（**5.7 中必须保留**） |
| 结构 | `SEQ.NEXTVAL` | `AUTO_INCREMENT` 或序列模拟函数 |
| 结构 | `SEQ.CURRVAL` | `LAST_INSERT_ID()` |

### 附录 D：代码扫描命令

```bash
# D-1 XML/SQL 中的 Oracle 专有语法（|| 在 .java 中是逻辑或，故不扫 .java）
grep -rnE "\b(ROWNUM|SYSDATE|SYSTIMESTAMP|DUAL)\b|\b(NVL2?|DECODE|TO_CHAR|TO_DATE|TO_NUMBER|TRUNC|ADD_MONTHS|MONTHS_BETWEEN|LISTAGG|WM_CONCAT|REGEXP_(LIKE|SUBSTR|REPLACE|INSTR)|INSTR|SUBSTR|NEXTVAL|CURRVAL)\s*\(|\bCONNECT\s+BY\b|\bMERGE\s+INTO\b|\bINSERT\s+ALL\b|\bROW_NUMBER\s*\(\s*\)\s*OVER|\(\+\)|\|\|" \
  --include="*.xml" --include="*.sql" -i .

# D-2 Java 中的 Oracle 依赖
grep -rn "oracle\.jdbc\|oracle\.sql\|OracleTypes\|OracleDriver\|OracleDialect\|SYS_REFCURSOR" \
  --include="*.java" --include="*.xml" --include="*.properties" --include="*.yml" .

# D-3 配置中的 Oracle 连接信息
grep -rn "jdbc:oracle\|ojdbc\|1521\|SELECT 1 FROM DUAL\|dbType.*oracle" \
  --include="*.properties" --include="*.yml" --include="*.xml" .

# D-4 类型映射高危点（7.4）
grep -rn "resultType=\"map\"\|resultType=\"java.util.Map\"\|Map<String,\s*Object>" --include="*.xml" --include="*.java" .
grep -rn "(BigDecimal)\|(Long)\|(Integer)" --include="*.java" .

# D-5 Oracle 错误码判断
grep -rnE "ORA-[0-9]{5}|getErrorCode\(\)\s*==\s*[0-9]+" --include="*.java" .

# D-6 存储过程调用点
grep -rn "{call \|CallableStatement\|@Select.*call\|statementType=\"CALLABLE\"" --include="*.java" --include="*.xml" .

# D-7 别忘了报表工具的数据集定义与前端内嵌 SQL
#     帆软 .cpt/.frm、润乾 .raq 等为压缩包或 XML，需单独解包扫描
```

### 附录 E：已完成的样例改造对照

本仓库已积累的改造样例，可作为团队改造模板与培训教材：

| Oracle 源 | MySQL 产出 | 覆盖的改造要点 |
|---|---|---|
| `存储过程-2-Oracle.txt` | `mysql-2.txt` | 嵌套两层 `DECLARE CURSOR`、处理器作用域、`MERGE`→`NOT EXISTS`、序列模拟、`REGEXP BINARY`、`CONCAT_WS` 空值语义、`NULLIF` 空串语义、DECIMAL 去尾零、去 schema 前缀 |
| `存储过程-3-Oracle.txt` | `mysql-3.txt` | 集合返回函数→存储过程、CTE→派生表、`ROWNUM=1`→`LIMIT 1` |
| `存储过程-4-Oracle.txt` | `mysql-4.txt` | REF CURSOR + 动态 SQL、`ROW_NUMBER()` 替代、分页改写 |
| `方法函数-1-Oracle.txt` | `mysql-Function-1.txt` | 动态 DDL、`SQL%ROWCOUNT`→`ROW_COUNT()`、`STDDEV`→`STDDEV_SAMP` |
| `方法函数-2-Oracle.txt` | `mysql-Function-2.txt` | 循环与字符串处理直译（**注意源文件字符丢失问题，见 2.5**） |
| `视图v_sbxx_sbdr_filemode.txt` | `mysql-视图-1.txt` | 视图内窗口函数替代 |

> 注：既有产出以 MySQL 5.5 为目标编写，`mysql-2.txt` 已按本方案更新为 5.7。其余文件需按本方案的 5.7 基线（`utf8mb4_bin`、`READ-COMMITTED`、去 schema 前缀、`STDDEV_SAMP` 等）复核后统一。

---

## 待确认事项（评审时需明确）

> **本节共 9 项为技术类待确认事项；管理与治理类另有 12 项，见计划书附录 F**（其中第 11 项"业务专家投入比例"、第 21 项"预生产服务器能否承载双环境"标注为 M0 前必须闭环）。两份清单合并闭环于 M0。

1. **MySQL 版本是否锁死 5.7**，还是允许 8.0？（影响约 25% 的高难度改造量与全部大表 JOIN 的性能方案）
2. ~~schema 合并方案（D-02 方案 B）是否确认？~~ **v0.2 已确认采用方案 B，且合并动作前置到 Oracle 迁移环境执行并验证**（[1.1.1](#111-实施策略治理前置v02-新增影响本方案多个章节的前置条件)、[3.3](#33-决策-d-02schema-映射策略)）。**表名冲突检查（A-9）仍须在 M1 完成**，冲突数量超预期（>30）时重新评估方案 A。
3. 可接受的**割接停机窗口**是多久？决定采用 [5.3](#53-增量追平) 的方案 A 还是 B。
4. **第三方平台的去 O 时间点**，以及去 O 验收对"ETL 侧保留 Oracle 驱动"是否接受为例外。
5. 源端 `''`（Oracle 视同 NULL）迁移到 MySQL 后，统一写为 `NULL` 还是保留空串？（影响 T1 全部改写方式与数据校验口径）
6. `NLS_SORT` 现状（A-12）；若为拼音排序，是否接受排序结果变化，或需增加拼音辅助列？
7. D3/D4 两处业务语义（预警文案字段、`ROWNUM=1` 取数意图）请业务方确认。
8. 是否与信创（OS/CPU）改造同期进行？
9. 本次是否借窗口修复 D1/D2 的 SQL 注入问题？（建议修复，需单独走变更评审）

---

> **本方案 v0.2 与《去 Oracle 化迁移工作计划书》（`xtqyjhs.md` v0.2）配套评审、配套使用。** 本方案回答"怎么改"，计划书回答"谁、按什么顺序、什么标准算完成、出问题怎么办"。
>
> 全部数量与工作量测算基于假设基数：**M1（资产盘点完成）后须整体复算**；**M2.5（治理验证通过）后须依据实际治理结论与改判量再次复算**。
