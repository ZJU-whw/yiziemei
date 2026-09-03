# M_TJRWCX 统计任务查询——系统功能分析整理

> 文档编号：`FUN-M_TJRWCX`
> 当前版本：V0.1（静态资料还原稿）
> 整理日期：2026-09-03
> 代码与资料基线：`main@9648d427f49f4aa0d6faef8ec78f3959cb5dc3ee`
> 状态：**静态分析基线；运行口径、数据权限及缺失服务实现仍需业务、开发和数据平台主管确认**

---

## 功能简述

1. **[事实]** `M_TJRWCX` 是“日常管理 → 统计分析 → 统计任务查询”路径下的有效叶子菜单，前端页面组件为 `jgcx`。需求资料说明：鉴于统计任务涉及的数据可能比较多，一次统计可能会因为统计时间超时报错，所以我们将每次用户提交的统计做了一个统计任务的日志处理。税务人员可在该功能模块按税务机关、业务类型、统计日期统计人员查询有关的统计任务日志，同时可点击“统计名称”列有关链接查看上次的统计结果。

---

## 1. 文档与功能身份

| 项目 | 内容 | 证据状态 |
|---|---|---|
| 功能编号 | `FUN-M_TJRWCX` | 本文建立 |
| 菜单代码 | `M_TJRWCX` | [事实] |
| 功能名称 | 统计任务查询 | [事实] |
| 菜单路径 | `M_ROOT → M_RCGL → M_TJFX → M_TJRWCX` | [事实]，菜单结构表 |
| 页面入口 | 前端页面组件为 `jgcx` | [事实]，`app.js` |
| 功能类型 | 统计展示、查询、文件输出 | [事实]，页面源码与需求资料 |
| 需求来源/年份 | 2019年二分局提交第一版便捷退税局端需求。 | [事实/待确认] |
| 原关系表服务标识 | `tl-bjts-sw` | [事实]，功能—数据库关系表 |
| 授权角色 | `XJZZ`、`SJZZ`、`SHJZZ` | [事实]，菜单—角色关系表 |
| 菜单状态 | `ISVALID=1`、`CHILDFLAG=0` | [事实]，有效且无下级菜单 |

---

## 2. 业务规则清单

| 规则编号 | 规则 | 来源 | 改造要求/待确认 |
|---|---|---|---|
| `RULE-TJRWCX-001` | 授权菜单包含 `M_TJRWCX` 时才应显示并允许打开该功能 | 菜单表、`app.js` | 服务端接口必须独立鉴权，不能只依赖前端隐藏 |
| `RULE-TJRWCX-002` | 页面提供“税务机关、统计类型、统计日期、统计人、退税机关、出口时间起、企业类型、生产企业”等输入或筛选项 | 页面模板 | 后端需实施类型、长度、必填、日期区间及数据范围校验 |
| `RULE-TJRWCX-003` | 页面以当前登录用户税务机关初始化组织范围 | 前端源码 | 服务端须根据会话重算允许组织集合，拒绝越权机关代码 |
| `RULE-TJRWCX-004` | 页面可见操作包括“查询、导出、统计图、统计表” | 页面模板 | 逐项确认角色、状态前置条件、并发控制和审计要求 |
| `RULE-TJRWCX-005` | 列表查询使用 `pageNo/pageSize` 或 jqGrid 分页事件 | 前端源码 | 统一页码基数、最大页大小、总数和空页返回约定 |
| `RULE-TJRWCX-006` | 页面会把列名与排序方向写入 `orderSql` 或排序参数 | 前端源码 | 服务端必须使用字段白名单映射，禁止直接拼接 SQL |
| `RULE-TJRWCX-007` | 组件初始化过程中会触发首次查询 | 前端源码 | 确认默认条件、默认数据范围及首屏性能基线 |
| `RULE-TJRWCX-008` | 鉴于统计任务涉及的数据可能比较多，一次统计可能会因为统计时间超时报错，所以我们将每次用户提交的统计做了一个统计任务的日志处理。税务人员可在该功能模块按税务机关、业务类型、统计日期统计人员查询有关的统计任务日志，同时可点击“统计名称”列有关链接查看上次的统计结果。 | 功能清单 | 作为业务验收口径；歧义项由业务部门确认 |
| `RULE-TJRWCX-009` | 功能包含“导出”能力 | 页面与接口源码 | 限制文件类型、大小/行数，防公式注入和敏感数据泄露并记录审计 |
| `RULE-TJRWCX-010` | 前端以字符串业务码 `"0"` 判定成功，失败时展示 `res.msg` | 前端源码 | 统一 HTTP 状态、业务码、错误信息和请求关联号 |

---

## 3. 数据结构、血缘与一致性

### 3.1 核心实体

| 实体/对象 | Schema | 用途 | 操作 | 依据 |
|---|---|---|---|---|
| `RWGL_YBCL_XXZB` | `TL_ADMIN` | 功能业务数据 | R | 功能—数据库关系表/页面源码 |

### 3.2 核心表结构特征

- **[事实]** `TL_ADMIN.RWGL_YBCL_XXZB` 在本仓库 Oracle 对象脚本中定义为表，共 18 个字段，有主键，检出 0 个索引（其中 0 个唯一索引）。

### 3.3 数据血缘

```mermaid
flowchart LR
    A[基础对象<br/>基础数据源待补证] --> C[服务<br/>tl-bjts-sw]
    B[业务对象<br/>TL_ADMIN.RWGL_YBCL_XXZB] --> C
    C --> D[页面组件<br/>jgcx]
    D --> E[统计展示、查询、文件输出结果]
```

**[事实]** 功能—数据库关系表登记的基础对象为 `未登记`，业务对象为 `TL_ADMIN.RWGL_YBCL_XXZB`。
**[事实]** 页面及直接关联组件共识别 9 个接口/外部入口，其中 7 个可与当前提交的 `tl-bjts-sw` Controller 路由静态匹配；其余实现可能位于未提交服务、网关或外部系统。
**[待确认]** 静态匹配不等同于生产调用闭环，仍需核对网关前缀、实际 SQL、数据权限、刷新作业、异常补偿和对账机制。

---

## 4. 接口、文件与消息

### 4.1 页面直接依赖的接口

| 接口 | 方法 | 用途 | 服务端证据 | 改造关注点 |
|---|---|---|---|---|
| `/bjtssw/tjfx/tjrw/delete` | POST | beforeSelectRow | [`TjfxController.java`](../src/server/tl-bjts-sw/src/main/java/com/tl/bjts/sw/controller/TjfxController.java) | 校验角色与数据范围，并保证幂等、事务一致性和操作审计 |
| `/bjtssw/tjfx/tjrw/list` | POST | $("#jgcx-table")[0].addJSONData([{ tjlxMc: 'asdf', tjtj: '统计条件', swjg: '税务机关', tjr: '统计人', tjrq: '统计日期' }, { tjlxMc: 'a1111', tjtj: '统计条件', swjg: '税务机关', tjr: '统计人', tjrq: '统计日期' }]); | [`TjfxController.java`](../src/server/tl-bjts-sw/src/main/java/com/tl/bjts/sw/controller/TjfxController.java) | 校验参数、分页/排序白名单、行级权限、超时和空结果契约 |
| `/glfw/export/dzzmrzqd` | POST FORM | 导入、导出或下载文件 | **当前服务工程未检出匹配路由** | 校验文件权限、类型/大小、行数上限、敏感字段和审计 |
| `/cxfw/export/readtree` | POST | 加载税务机关树 | [`ExportController.java`](../src/server/tl-bjts-sw/src/main/java/com/tl/bjts/sw/controller/ExportController.java) | 校验可见范围、字典有效性、缓存刷新和参数白名单 |
| `/bjtssw/tjfx/loaddata` | POST | 页面调用 | [`TjfxController.java`](../src/server/tl-bjts-sw/src/main/java/com/tl/bjts/sw/controller/TjfxController.java) | 校验参数、分页/排序白名单、行级权限、超时和空结果契约 |
| `/bjtssw/tjfx/loaddata/export` | POST FORM | 导入、导出或下载文件 | [`TjfxController.java`](../src/server/tl-bjts-sw/src/main/java/com/tl/bjts/sw/controller/TjfxController.java) | 校验文件权限、类型/大小、行数上限、敏感字段和审计 |
| `/bjtssw/tjbb/profile/header` | POST | getTableCol | [`TjbbController.java`](../src/server/tl-bjts-sw/src/main/java/com/tl/bjts/sw/controller/TjbbController.java) | 校验可见范围、字典有效性、缓存刷新和参数白名单 |
| `/bjtssw/tjfx/spml` | POST | getSpdl | [`TjfxController.java`](../src/server/tl-bjts-sw/src/main/java/com/tl/bjts/sw/controller/TjfxController.java) | 校验参数、分页/排序白名单、行级权限、超时和空结果契约 |
| `/auth/getmenu` | POST | 登录后取得授权菜单 | **当前服务工程未检出匹配路由** | 校验可见范围、字典有效性、缓存刷新和参数白名单 |

### 4.2 返回码与异常

前端调用主要以字符串业务码 `"0"` 作为成功条件，非成功结果通常展示 `res.msg`，网络失败交由通用提示处理。[事实]

以下接口契约仍需统一确认：

- HTTP 状态码与业务码的对应关系，以及未登录、无菜单权限、无数据权限的标准返回；
- 参数非法、页大小超限、排序字段非法、重复提交和并发修改的错误码；
- 正常空结果与上游数据未就绪、部分数据失败之间的区分；
- 请求关联号、用户提示、运维日志及敏感信息过滤规则。

### 4.3 文件、消息与外部接口

- 页面存在文件相关能力（导出）；文件格式、编码、模板版本、最大行数、失败反馈和敏感字段策略需按接口逐项确认。[事实/待确认]
- 未发现该页面直接发送或消费 MQ 消息；若服务端通过异步作业生成数据或文件，需补充调度与消息链路证据。[静态检索结论/待确认]

---

## 5. 实现资产清单与可追溯关系

### 5.1 前端资产

| 资产 | 关键位置/用途 |
|---|---|
| [`app.js`](../src/client/src/app.js) | 181 行菜单注册、页面组件/外部地址及授权过滤 |
| [`jgcx.js`](<../src/client/src/page/统计分析/jgcx.js>) | `jgcx` 主组件、查询状态、表格与操作逻辑 |
| [`jgcx.html`](<../src/client/src/page/统计分析/jgcx.html>) | 页面输入、按钮、列表及弹窗结构 |
| [`dqckts.js`](<../src/client/src/page/统计分析/dqckts.js>) | 主页面直接引用的关联组件 |
| [`fdlsp.js`](<../src/client/src/page/统计分析/fdlsp.js>) | 主页面直接引用的关联组件 |
| [`ckmygjfb.js`](<../src/client/src/page/统计分析/ckmygjfb.js>) | 主页面直接引用的关联组件 |
| [`qypmsh.js`](<../src/client/src/page/统计分析/qypmsh.js>) | 主页面直接引用的关联组件 |

### 5.2 服务端及数据库资产

| 资产 | 关键位置/用途 |
|---|---|
| [`TjfxController.java`](../src/server/tl-bjts-sw/src/main/java/com/tl/bjts/sw/controller/TjfxController.java) | 页面端点在当前服务工程中的 Controller 路由 |
| [`ExportController.java`](../src/server/tl-bjts-sw/src/main/java/com/tl/bjts/sw/controller/ExportController.java) | 页面端点在当前服务工程中的 Controller 路由 |
| [`TjbbController.java`](../src/server/tl-bjts-sw/src/main/java/com/tl/bjts/sw/controller/TjbbController.java) | 页面端点在当前服务工程中的 Controller 路由 |
| 服务标识 `tl-bjts-sw` | 功能—数据库关系表登记的原部署/服务边界；与当前提交工程是否一致需确认 |
| [`tl_admin_object20260804.sql`](../tl_admin_object20260804.sql) | `TL_ADMIN` 对象定义、约束与索引核验 |

### 5.3 需求—实现—数据—测试追踪

| 需求编号 | 需求 | 页面/接口 | 数据对象 | 验收用例 |
|---|---|---|---|---|
| `REQ-TJRWCX-001` | 授权用户可从菜单路径打开功能 | `M_TJRWCX`、`jgcx` | 菜单/角色配置 | `TC-01` 菜单可见性与接口越权校验 |
| `REQ-TJRWCX-002` | 查询、导出、统计图、统计表 | `/bjtssw/tjfx/tjrw/delete` | `TL_ADMIN.RWGL_YBCL_XXZB` | `TC-02` 正常、空结果及边界条件 |
| `REQ-TJRWCX-003` | 查询条件、列表字段和业务口径一致 | 主组件及直接接口 | `TL_ADMIN.RWGL_YBCL_XXZB` | `TC-03` 字段映射、分页排序及数据范围 |
| `REQ-TJRWCX-004` | 文件输入输出与页面数据、权限一致 | `/glfw/export/dzzmrzqd` | 同列表/业务对象 | `TC-04` 文件格式、上限、脱敏和审计 |
| `REQ-TJRWCX-005` | 角色与税务机关数据范围受控 | `/auth/getmenu`、全部业务接口 | 权限对象待补证 | `TC-05` 横向/纵向越权与敏感字段校验 |
