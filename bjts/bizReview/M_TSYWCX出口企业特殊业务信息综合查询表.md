# M_TSYWCX 出口企业特殊业务信息综合查询表——系统功能分析整理

> 文档编号：`FUN-M_TSYWCX`
> 当前版本：V0.1（静态资料还原稿）
> 整理日期：2026-09-03
> 代码与资料基线：`main@9648d427f49f4aa0d6faef8ec78f3959cb5dc3ee`
> 状态：**静态分析基线；运行口径、数据权限及缺失服务实现仍需业务、开发和数据平台主管确认**

---

## 功能简述

1. **[事实]** `M_TSYWCX` 是“日常管理 → 监测分析 → 出口企业特殊业务信息综合查询表”路径下的有效叶子菜单，前端页面组件为 `ckqytsywxx`。需求资料说明：统计一定时期内特殊业务退税申报情况，可按地区、业务类型分类。

---

## 1. 文档与功能身份

| 项目 | 内容 | 证据状态 |
|---|---|---|
| 功能编号 | `FUN-M_TSYWCX` | 本文建立 |
| 菜单代码 | `M_TSYWCX` | [事实] |
| 功能名称 | 出口企业特殊业务信息综合查询表 | [事实] |
| 菜单路径 | `M_ROOT → M_RCGL → M_JCFX → M_TSYWCX` | [事实]，菜单结构表 |
| 页面入口 | 前端页面组件为 `ckqytsywxx` | [事实]，`app.js` |
| 功能类型 | 查询、文件输出 | [事实]，页面源码与需求资料 |
| 需求来源/年份 | 2021年10月二分局提交需求后先开发，后期因未正式立项终止，中间数据抽取截止2022年12月份停止。 | [事实/待确认] |
| 原关系表服务标识 | `tl-bjts-sw` | [事实]，功能—数据库关系表 |
| 授权角色 | `JCFX` | [事实]，菜单—角色关系表 |
| 菜单状态 | `ISVALID=1`、`CHILDFLAG=0` | [事实]，有效且无下级菜单 |

---

## 2. 业务规则清单

| 规则编号 | 规则 | 来源 | 改造要求/待确认 |
|---|---|---|---|
| `RULE-TSYWCX-001` | 授权菜单包含 `M_TSYWCX` 时才应显示并允许打开该功能 | 菜单表、`app.js` | 服务端接口必须独立鉴权，不能只依赖前端隐藏 |
| `RULE-TSYWCX-002` | 页面提供“退税机关、统计日期、特殊业务”等输入或筛选项 | 页面模板 | 后端需实施类型、长度、必填、日期区间及数据范围校验 |
| `RULE-TSYWCX-003` | 页面以当前登录用户税务机关初始化组织范围 | 前端源码 | 服务端须根据会话重算允许组织集合，拒绝越权机关代码 |
| `RULE-TSYWCX-004` | 页面可见操作包括“查询、导出” | 页面模板 | 逐项确认角色、状态前置条件、并发控制和审计要求 |
| `RULE-TSYWCX-005` | 列表查询使用 `pageNo/pageSize` 或 jqGrid 分页事件 | 前端源码 | 统一页码基数、最大页大小、总数和空页返回约定 |
| `RULE-TSYWCX-006` | 页面会把列名与排序方向写入 `orderSql` 或排序参数 | 前端源码 | 服务端必须使用字段白名单映射，禁止直接拼接 SQL |
| `RULE-TSYWCX-007` | 组件初始化过程中会触发首次查询 | 前端源码 | 确认默认条件、默认数据范围及首屏性能基线 |
| `RULE-TSYWCX-008` | 统计一定时期内特殊业务退税申报情况，可按地区、业务类型分类。 | 功能清单 | 作为业务验收口径；歧义项由业务部门确认 |
| `RULE-TSYWCX-009` | 功能包含“导出”能力 | 页面与接口源码 | 限制文件类型、大小/行数，防公式注入和敏感数据泄露并记录审计 |
| `RULE-TSYWCX-010` | 前端以字符串业务码 `"0"` 判定成功，失败时展示 `res.msg` | 前端源码 | 统一 HTTP 状态、业务码、错误信息和请求关联号 |

---

## 3. 数据结构、血缘与一致性

### 3.1 核心实体

| 实体/对象 | Schema | 用途 | 操作 | 依据 |
|---|---|---|---|---|
| `JCFX_DATA_TSSBMX_TSYW` | `TL_TSSH` | 功能业务数据 | R | 功能—数据库关系表/页面源码 |

### 3.2 核心表结构特征

- **[事实]** `TL_TSSH.JCFX_DATA_TSSBMX_TSYW` 在本仓库 Oracle 对象脚本中定义为表，共 16 个字段，有主键，检出 2 个索引（其中 0 个唯一索引）。

### 3.3 数据血缘

```mermaid
flowchart LR
    A[基础对象<br/>基础数据源待补证] --> C[服务<br/>tl-bjts-sw]
    B[业务对象<br/>TL_TSSH.JCFX_DATA_TSSBMX_TSYW] --> C
    C --> D[页面组件<br/>ckqytsywxx]
    D --> E[查询、文件输出结果]
```

**[事实]** 功能—数据库关系表登记的基础对象为 `未登记`，业务对象为 `TL_TSSH.JCFX_DATA_TSSBMX_TSYW`。
**[事实]** 页面及直接关联组件共识别 7 个接口/外部入口，其中 6 个可与当前提交的 `tl-bjts-sw` Controller 路由静态匹配；其余实现可能位于未提交服务、网关或外部系统。
**[待确认]** 静态匹配不等同于生产调用闭环，仍需核对网关前缀、实际 SQL、数据权限、刷新作业、异常补偿和对账机制。

---

## 4. 接口、文件与消息

### 4.1 页面直接依赖的接口

| 接口 | 方法 | 用途 | 服务端证据 | 改造关注点 |
|---|---|---|---|---|
| `/bjtssw/sjjc/param/init` | POST | getDateCrossYearFlag | [`SjjcController.java`](../src/server/tl-bjts-sw/src/main/java/com/tl/bjts/sw/controller/SjjcController.java) | 校验参数、分页/排序白名单、行级权限、超时和空结果契约 |
| `/bjtssw/sjjc/dynamic/init/other` | POST | getTsywList | [`SjjcController.java`](../src/server/tl-bjts-sw/src/main/java/com/tl/bjts/sw/controller/SjjcController.java) | 校验参数、分页/排序白名单、行级权限、超时和空结果契约 |
| `/bjtssw/sjjc/query/tsywxx` | POST | 页面调用 | [`SjjcController.java`](../src/server/tl-bjts-sw/src/main/java/com/tl/bjts/sw/controller/SjjcController.java) | 校验参数、分页/排序白名单、行级权限、超时和空结果契约 |
| `/cxfw/export/readtree` | POST | 加载税务机关树 | [`ExportController.java`](../src/server/tl-bjts-sw/src/main/java/com/tl/bjts/sw/controller/ExportController.java) | 校验可见范围、字典有效性、缓存刷新和参数白名单 |
| `/bjtssw/sjjc/saveDynamicExcel` | POST FORM | 导入、导出或下载文件 | [`SjjcController.java`](../src/server/tl-bjts-sw/src/main/java/com/tl/bjts/sw/controller/SjjcController.java) | 校验文件权限、类型/大小、行数上限、敏感字段和审计 |
| `/bjtssw/sjjc/query/dynamic` | POST | search | [`SjjcController.java`](../src/server/tl-bjts-sw/src/main/java/com/tl/bjts/sw/controller/SjjcController.java) | 校验参数、分页/排序白名单、行级权限、超时和空结果契约 |
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
| [`app.js`](../src/client/src/app.js) | 194 行菜单注册、页面组件/外部地址及授权过滤 |
| [`ckqytsywxx.js`](<../src/client/src/page/监测分析/ckqytsywxx.js>) | `ckqytsywxx` 主组件、查询状态、表格与操作逻辑 |
| [`ckqytsywxx.html`](<../src/client/src/page/监测分析/ckqytsywxx.html>) | 页面输入、按钮、列表及弹窗结构 |
| [`fpqkmx.js`](<../src/client/src/page/监测分析/fpqkmx.js>) | 主页面直接引用的关联组件 |

### 5.2 服务端及数据库资产

| 资产 | 关键位置/用途 |
|---|---|
| [`SjjcController.java`](../src/server/tl-bjts-sw/src/main/java/com/tl/bjts/sw/controller/SjjcController.java) | 页面端点在当前服务工程中的 Controller 路由 |
| [`ExportController.java`](../src/server/tl-bjts-sw/src/main/java/com/tl/bjts/sw/controller/ExportController.java) | 页面端点在当前服务工程中的 Controller 路由 |
| 服务标识 `tl-bjts-sw` | 功能—数据库关系表登记的原部署/服务边界；与当前提交工程是否一致需确认 |
| [`tl_tssh_object20260810.sql`](../tl_tssh_object20260810.sql) | `TL_TSSH` 对象定义、约束与索引核验 |

### 5.3 需求—实现—数据—测试追踪

| 需求编号 | 需求 | 页面/接口 | 数据对象 | 验收用例 |
|---|---|---|---|---|
| `REQ-TSYWCX-001` | 授权用户可从菜单路径打开功能 | `M_TSYWCX`、`ckqytsywxx` | 菜单/角色配置 | `TC-01` 菜单可见性与接口越权校验 |
| `REQ-TSYWCX-002` | 查询、导出 | `/bjtssw/sjjc/param/init` | `TL_TSSH.JCFX_DATA_TSSBMX_TSYW` | `TC-02` 正常、空结果及边界条件 |
| `REQ-TSYWCX-003` | 查询条件、列表字段和业务口径一致 | 主组件及直接接口 | `TL_TSSH.JCFX_DATA_TSSBMX_TSYW` | `TC-03` 字段映射、分页排序及数据范围 |
| `REQ-TSYWCX-004` | 文件输入输出与页面数据、权限一致 | `/bjtssw/sjjc/saveDynamicExcel` | 同列表/业务对象 | `TC-04` 文件格式、上限、脱敏和审计 |
| `REQ-TSYWCX-005` | 角色与税务机关数据范围受控 | `/auth/getmenu`、全部业务接口 | 权限对象待补证 | `TC-05` 横向/纵向越权与敏感字段校验 |
