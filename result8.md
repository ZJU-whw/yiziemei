# 行业报告迭代优化问题汇总与实施清单

> 编制日期：2026-08-30
> 当前基线：[《A股板块潜力与龙头图形股研究报告_20260828.html》](./A股板块潜力与龙头图形股研究报告_20260828.html)
> 验收依据：[result6.md](./result6.md)、[result4.md](./result4.md)
> 实施原则：保留当前架构和已有能力，不推翻重建，只做可回归、可分批发布的增量优化

## 一、总体结论

当前版本无需重做。以下主体应直接保留：

- 单 HTML 报告形态及 8 个日报频道、7 个周报频道；
- `WEEKLY` 类型、完整周期元数据和五交易日覆盖；
- 90 行业当前快照、周五 80 条全量迁移、90 条周内生命周期路径；
- 3D/5D/10D/20D 资金复盘、周度资金榜、龙头事件账本；
- 主线三层分类、下周 Top10、历史统计与前瞻账本框架；
- `RESEARCH_ONLY / WAIT`、缺失证据失败关闭、正式候选不补位原则。

后续工作不是增加一套新报告，而是在现有载荷和页面中修正四类问题：

1. **数据事实不可靠：**图形跨日集合不可比、触发/失效字段冲突；
2. **规则语义自相矛盾：**观察计划发布时已满足自身失效条件、状态机未经正式闭合；
3. **日报行动层不足：**底层数据已有，但首页、早期池、Top 榜、日变化和量化缺口未表达；
4. **审计只验数量、不验语义：**`audit_counts.status=PASS` 无法阻止逻辑冲突进入报告。

实施优先级分为：

- **P0：事实正确性与规则一致性。** 未完成前不得重新申请周报验收；
- **P1：日报/周报需求闭环与可用性。** 完成后可申请二次优化整体验收；
- **P2：研究有效性和体验增强。** 不阻断当前验收，可后续持续迭代。

## 二、增量改造边界

### 2.1 必须保持不变

1. 不删除或更名现有 15 个频道，不另建一套周报页面；
2. 不改变 90 行业主键，继续以 `industry_code` 连接跨日历史；
3. 不在浏览器端重新计算生产规则，排序、筛选和摘要由生成端产出；
4. 不把 L2/L3 观察项自动提级为 L1，不为 Top10 或案例数量补占位；
5. 不用 0、空字符串或默认 PASS 代替 `UNKNOWN/PARTIAL/NOT_COLLECTED`；
6. 不改变 `RESEARCH_ONLY / WAIT` 的研究边界；
7. 不删除现有字段。对歧义字段先新增清晰字段、双写一个兼容版本，再标记旧字段废弃。

### 2.2 推荐的兼容升级方式

- `payload_schema_version`、`weekly_report_schema_version` 和规则版本各提升一个小版本；
- 现有 `current_states`、`weekly_*` 数组继续使用，只增补字段或少量派生数组；
- 页面继续使用现有标签页和表格，在现有 `<section>` 中增加摘要卡、分组表或列；
- 每一批改动都先通过自动断言，再重生成同一个 2026-08-28 固定回归样例。

## 三、P0：必须先解决的阻断项

### P0-01 图形跨日快照可比性

**当前问题**

8 月 27 日历史 HTML 声明完整研究池 380 条，但只嵌入 58 条展示记录；8 月 28 日原生管线完整池为 493 条。两天均被标记为 `FULL_RESEARCH`，导致展示子集与全量池直接比较，8 月 28 日输出 462 条无法证明为真实新增的 `PATTERN_ADDED`。

**最小改动**

继续使用 `snapshot_manifest` 和 `weekly_pattern_events`，只补充快照范围及比较审计：

```text
pattern_snapshot_scope: FULL_SNAPSHOT | DISPLAY_SUBSET
pattern_snapshot_count
pattern_embedded_count
pattern_snapshot_sha256
pattern_comparability_key
```

生成事件时执行：

- 两侧均为同版本 `FULL_SNAPSHOT`：正常计算新增、移除和变化；
- 任一侧为 `DISPLAY_SUBSET`：只比较共同可见键的状态变化；
- 无法判断新增/移除时标记 `UNKNOWN_NOT_COMPARABLE`，不得输出为真实新增/淘汰；
- 范围变化本身单独记录为审计事件，不混入研究事件。

新增 `weekly_pattern_event_audit`：

```text
prior_scope / current_scope
prior_count / current_count
comparable_count / excluded_count
added_count / removed_count / changed_count
comparability_status
```

**验收口径**

1. 8 月 27 日必须识别为 `DISPLAY_SUBSET`，不能继续标为完整快照；
2. 重新生成后，不能再把当前全量池相对上一日未展示部分计算为新增；
3. `added + removed + changed` 与实际事件数组闭合；
4. 每个事件均可追溯到前后快照键和哈希；
5. W5 页面明确显示可比范围、排除数量和比较状态。

### P0-02 下周观察计划按阶段拆分条件

**当前问题**

下周 Top10 的当前市场闸门全部为 `FAIL`，但 10 项失效条件均含 `MARKET_GATE_UNKNOWN_OR_FAIL`，导致所有观察项在发布时已经满足自身失效条件。

**最小改动**

保留 `next_week_watchlist`，将一个混合条件拆成三个字段：

```text
watch_entry_condition
watch_exit_condition
post_confirmation_invalidation_condition
```

建议语义：

- 早期观察阶段允许闸门 FAIL/UNKNOWN，重点看生命周期恶化、确认项减少或新增反证；
- 从观察升级到正式研究时，必须要求市场闸门 PASS；
- 只有确认后，闸门由 PASS 转 FAIL 才属于正式研究失效条件。

同时增加生成时评价：

```text
condition_evaluation:
  watch_entry_met
  watch_exit_triggered
  formal_upgrade_met
  post_confirmation_invalidation_triggered
```

**验收口径**

1. 入选 Top10 时 `watch_entry_met=true` 且 `watch_exit_triggered=false`；
2. 任一项目若已触发观察退出条件，必须从 Top10 移除并进入风险/退出记录；
3. 页面分别显示“继续观察条件”“升级条件”“确认后失效条件”；
4. 不再出现“当前状态已满足自身失效条件”的记录。

### P0-03 L3 触发前撤销位与触发后失效位分离

**当前问题**

51 条页面图形观察中有 15 条 L3 同时满足 `trigger_level == invalidation_level`、收盘低于该价格、失效条件已触发但风险仍为 `NONE`。当前字段无法区分“尚待突破的参考位”和“突破后的保护位”。

**最小改动**

保留 `trigger_level`，将单一 `invalidation_level` 明确拆分为：

```text
pre_trigger_cancel_level
post_trigger_invalidation_level
trigger_state
pre_trigger_cancel_state
post_trigger_invalidation_state
pattern_status: FORMING | TRIGGERED | INVALIDATED | UNKNOWN
```

迁移规则：

- 上游没有有效撤销位或失效位时写 `null + UNKNOWN`，不得复制触发位补值；
- L3 未触发时只评价触发前撤销条件；
- 触发后才启用 `post_trigger_invalidation_level`；
- 已失效对象不继续以正常 L3 展示，应进入失效事件或明确标记 `INVALIDATED`。

**验收口径**

1. 长多图形的有效失效位不得等于或高于触发位；无有效值时必须为 UNKNOWN；
2. `pattern_status=INVALIDATED` 与风险标记、候选池去留一致；
3. 浙富控股等 15 条历史问题逐条回归，不再显示“已触发失效但风险无”；
4. D5、D7、W5 共用同一组状态字段，不各自推断。

### P0-04 正式确定当前 S0～S6 状态机

**当前问题**

原需求是 S0～S5；当前实现已使用 S0～S6，并把 S5 定义为高位分化、S6 定义为退潮。当前算法和历史账本已经按 S0～S6 运行，但缺少正式批准、阈值、合法迁移及旧状态映射。

**推荐的最小改动**

为避免回滚重算，优先保留现有 S0～S6，实现以下文档化和版本化：

```text
state_machine_version: sector-lifecycle-v2
state_order / state_quality_order
state_definitions
allowed_transitions
transition_reason_requirements
legacy_state_mapping
```

须由需求所有者明确批准：

- S0 未启动；
- S1 形成观察；
- S2 启动准备；
- S3 四维确认；
- S4 趋势跟踪；
- S5 高位分化；
- S6 退潮。

若需求所有者不批准 S0～S6，再另立变更将其恢复为 S0～S5；该路径涉及历史迁移重算，不纳入本轮“最小迭代”首选方案。

**验收口径**

1. 任一状态均有中文含义、进入阈值、退出阈值和合法迁移；
2. `STATE_UPGRADED/STATE_DOWNGRADED` 与质量顺序一致；
3. 周内路径中的每一步均通过合法迁移校验；
4. 页面和载荷显示同一状态机版本；
5. 原 S0～S5 账本到 S0～S6 的映射可追溯。

### P0-05 枚举与字段口径闭合

**当前问题**

实际载荷含 `RADAR_CONFIRMED`、`LOW_CONFIDENCE`、`ALL_MARKET_STATES`、`MARKET_STATE:ROTATION`，但 glossary 无对应项；说明文字使用 `INSUFFICIENT_SAMPLE`，实际枚举又采用 `LOW_SAMPLE`。`PRICE_FLOW_DIVERGENCE`、`price_flow_relation` 和周度背离标签也使用不同窗口却未明确区分。

**最小改动**

1. 补齐全部允许值和实际值，不只补本期页面可见值；
2. 样本不足统一保留一个正式枚举，旧值做兼容映射；
3. 不强制不同窗口的背离结果相等，而是改为清晰字段名：

```text
daily_price_flow_relation
daily_price_flow_window
risk_price_flow_divergence
risk_price_flow_window
weekly_price_flow_tags
weekly_price_flow_rule
```

4. 增加 `field_dictionary`，逐字段记录来源、单位、窗口、公式、阈值、更新时间和缺失处理。

**验收口径**

- 构建时执行 `allowed_codes ∪ used_codes ⊆ glossary_codes`；
- 任一新增枚举无中文名或解释时构建失败；
- 页面不得再裸显未翻译代码；
- 同一“背离”名称不得指代未披露的不同窗口。

### P0-06 将审计从“数量 PASS”扩展为“可发布 PASS”

**当前问题**

现有 `audit_counts.status=PASS` 只校验数量、覆盖和顺序，无法发现伪新增、自失效、触发位等于失效位、枚举缺失等语义问题。

**最小改动**

在现有审计对象中增加：

```text
structural_audit_status
semantic_audit_status
render_audit_status
publish_status
blocking_errors[]
warnings[]
```

P0-01～P0-05 的断言全部纳入 `semantic_audit_status`。只有结构、语义、渲染均 PASS 才允许 `publish_status=PASS`。

**验收口径**

- 人工构造一次快照范围不一致、Top10 自失效、价位冲突和未知枚举，构建必须失败；
- 当前 2026-08-28 回归样例在修复前必须 FAIL、修复后才可 PASS；
- 页面“数据审计”同时展示结构状态和语义状态，不能只显示总 PASS。

## 四、P1：日报需求闭环

### P1-01 今日雷达补齐 30 秒行动摘要

**复用内容：**`weekly_market_review.daily` 的末日记录、`current_states`、`daily_transition_ledger`。

**增量产出：**

```text
daily_market_snapshot
daily_state_distribution
daily_radar_distribution
daily_focus_sectors[3..5]
```

每个重点板块至少包含：关注原因、四维缺口、当前值/阈值/差值、最早复核时间、观察退出条件。页面在现有“今日总体判断”面板中增加，不新建频道。

**验收口径：**使用者 30 秒内能回答“市场是否允许、今天最值得盯哪 3～5 个、每项还差什么”。成交额缺失时继续显示未知。

### P1-02 启动扫描增加独立 B/C 早期池

**复用内容：**`current_states`、`daily_transition_ledger`、`diffusion` 和资金字段。

**增量产出：**`daily_early_pool`，包含入池、升级、降级、退出；为当前行业记录补充：

```text
return_5 / return_10 / return_20
relative_strength
volume_ratio
resistance_level
distance_to_resistance_pct
diffusion_state
```

**验收口径：**90 行业全景继续保留；B/C 池可独立查看变化；所有证据在同一行，不要求跨标签拼接；早期池仍不得绕过四维正式确认。

### P1-03 日报资金增加加速与撤退 Top10

**复用内容：**现有四窗口资金和周度榜单排序逻辑。

新增 `daily_flow_leaderboards`：

- 边际加速 Top10；
- 资金撤退 Top10；
- 流出转流入；
- 流入转流出；
- 价强资弱、价弱资强。

**验收口径：**每个榜单公开窗口、公式、阈值和单位；日榜只回答上一交易日→今日，不复用“本周变化”字段名；供应商资金与量价压力代理继续分列。

### P1-04 龙头梯队增加日变化及一致性判断

**复用内容：**`weekly_leader_changes`，由生成端筛选 `event_date=as_of` 形成 `daily_leader_changes`。

每条增加：

```text
leader_sector_alignment: ALIGNED | DIVERGENT | UNKNOWN
alignment_reason
```

**验收口径：**日报可查看 L1/L2/L3 的新增、退出、晋级、降级；龙头改善但板块确认恶化时必须明确显示背离。

### P1-05 图形主表展示已有关键字段

在修复 P0-03 后，直接在现有 D5 表格增加：

- 距触发百分比；
- 触发状态；
- 触发前撤销位/状态；
- 触发后失效位/状态；
- 风险标记；
- 未知字段。

**验收口径：**不需要用户用收盘价手算距离；风险和 UNKNOWN 不再只藏在风险页；L1、L2、L3 继续分池展示。

### P1-06 四维确认下沉量化缺口

将当前只在 `next_week_watchlist.dimension_checks` 中使用的结构提取为通用 `current_states[].dimension_checks`，供日报重点、四维确认和周报 Top10 共同消费。

每维统一包含：

```text
state
current_value
threshold
difference
continuity_requirement
contradiction
earliest_review
```

**验收口径：**同一板块在日报和周报的当前值、阈值和状态逐字段一致；数值超过阈值但状态 FAIL 时，必须显示连续性或反证原因。

### P1-07 风险监控分层而不删除全量

保留 90 行全量风险追溯表，默认新增三个分组：

1. `NEW_OR_WORSENED`：新增/恶化风险；
2. `PERSISTENT_RISK`：持续风险；
3. `DATA_UNKNOWN`：仅证据未知。

“市场闸门未 PASS”本身不再自动等同于最高风险；需结合风险阶段、资金撤退、扩散收窄、突破失效和数据缺失确定等级。

**验收口径：**默认视图不再 90/90 同级平铺；各分组计数与全量表闭合；风险等级变化可追溯到日迁移原因。

### P1-08 报告说明增加字段字典

在现有 glossary 下增加 `field_dictionary` 表，不另建说明文档。至少覆盖：

- 四维分量和阈值；
- A/B/C/D；
- 生命周期与雷达；
- 四窗口资金和占比；
- 价资关系与风险背离；
- 扩散和领导力；
- 图形触发、撤销、失效；
- 历史概率和样本状态。

**验收口径：**任一页面字段均能在字典中找到来源、单位、窗口、公式、阈值和缺失处理。

## 五、P1：周报表达与发布完善

### P1-09 本周市场复盘增加风格/板块轮动摘要

复用 `weekly_market_review`、`weekly_mainline_candidates` 和 `weekly_flow_leaderboards`，由生成端输出 3～5 条 `weekly_style_rotation_summary`。每条必须引用日期、板块代码和证据字段，不由浏览器生成自然语言结论。

### P1-10 主线候选公开入选规则

保留 formed/forming/potential 三池，为每条增加 `entry_rule_detail`、`thresholds`、`exit_reason` 和 `evidence_change_summary`。空池继续合法，不为展示补位。

### P1-11 图形复盘增加可信典型案例

P0-01 修复后，从真实事件中选择最多 3～5 个 `weekly_pattern_case_studies`，展示完整的日序列、层级迁移、触发/失效日期和排除理由。没有可比案例时显示为空，不从不可比记录中选例。

### P1-12 下周计划改善可执行表达

在 P0-02 的三类条件基础上，页面将研究动作区分为：

```text
CONTINUE_WATCH
NEAR_CONFIRMATION
UPGRADE_AFTER_GATE_PASS
EXIT_WATCH
```

Top10 不足 10 个时按实际数量输出。当前值、阈值、差值、连续性和反证必须同时显示，避免“数值过阈值但状态 FAIL”无法解释。

### P1-13 增加生成与发布审计时间

在 `report_metadata` 增加：

```text
generated_at
published_at
schedule_window
schedule_status
```

**验收口径：**周五日报和周报均能证明生成时点；周报在周五晚间至周六窗口内完成；短周明确 `PARTIAL_WEEK`；超时则显示 `LATE_PUBLICATION`，不能只依赖 Git 提交时间推断。

## 六、P2：验收后持续优化项

### P2-01 可执行历史验证

在现有收盘到收盘统计之外，逐步增加：

- 次日开盘/VWAP 入场；
- 手续费、滑点、涨跌停和流动性约束；
- 1/3/5/10/20 日收益；
- 假突破率、期望收益、盈亏比、MFE/MAE；
- 按市场状态和规则版本分层。

新增统计继续只作辅助证据，不单独触发。

### P2-02 历史时点行业成分

保存每日行业成分快照和分类版本，降低当前成分反向污染历史龙头、扩散度和概率的问题。行业改名继续以代码连接。

### P2-03 页面摘要与大表体验

- W5 的数百条事件默认显示摘要和真实典型案例，全量表折叠查看；
- 大表增加搜索、筛选和分页，但默认顺序保持生产审计顺序；
- 用户排序后显示“用户排序”，不得冒充模型排名；
- 对重点候选增加服务于规则复核的小型价格/量能/触发位图，不做装饰性大屏。

### P2-04 市场成交额数据补采

当前五个交易日成交额均为未知。应补充稳定来源、来源时间、覆盖和失败原因；补采失败时继续显式 UNKNOWN，不得用量能比替代。

### P2-05 性能与体积控制

当前单 HTML 内嵌大量事件。保持单文件交付的前提下，可对全量 W5 采用延迟渲染、分页或压缩；不得为减小体积再次把展示子集冒充完整快照。

## 七、建议实施批次

| 批次 | 范围 | 主要交付 | 放行条件 |
|---|---|---|---|
| 迭代 1 | P0-01～P0-06 | 数据可比性、条件语义、价位语义、状态机、枚举和语义审计 | `publish_status=PASS`，周度图形事件与 Top10 复验通过 |
| 迭代 2 | P1-01～P1-08 | 日报行动摘要、早期池、日榜、日龙头变化、量化缺口、风险分层、字段字典 | 日报 8 频道逐项通过，30 秒人工场景通过 |
| 迭代 3 | P1-09～P1-13 | 周报摘要、规则披露、典型案例、下周计划、发布审计 | 周报 7 频道和发布节奏通过 |
| 迭代 4 | P2 | 可执行统计、历史成分、图形和性能 | 不阻断二次优化验收，独立评审 |

每个迭代只在当前生成链上增加字段、校验和展示，不复制新算法、不另建报告体系。

## 八、必须补充的自动检查

在现有数量、排序和哈希校验之外，至少增加：

1. 跨日图形快照范围和版本可比；不可比时禁止输出新增/移除；
2. 图形事件计数与事件数组、前后集合闭合；
3. Top10 入选时观察退出条件不得已触发；
4. 触发前撤销位、触发位、触发后失效位关系合法；
5. 状态、风险标记、候选池去留相互一致；
6. 所有允许和实际枚举均有 glossary；
7. 所有页面字段均有 field dictionary；
8. 生命周期迁移符合版本化状态机；
9. 同一板块日报和周报的四维值、阈值、状态一致；
10. 日榜使用日变化、周榜使用周变化，字段不得混用；
11. 风险分层计数与全量风险表闭合；
12. 周五日报迁移与周报保留的周五迁移逐字段一致；
13. `UNKNOWN/PARTIAL` 不得通过市场闸门；
14. 正式候选不得由 L2/L3 自动补位；
15. 15 个标签页经真实浏览器渲染后均正常显示或呈现真实空状态；
16. 结构、语义、渲染任一审计 FAIL 时禁止发布为 PASS。

## 九、复验材料清单

下一轮验收应一次提交：

1. 修正后的 2026-08-28 固定回归周报；
2. 修正前后 `weekly_pattern_events` 差异及事件审计表；
3. Top10 三类条件及生成时评价结果；
4. 15 条 L3 价位冲突的逐条回归结果；
5. 经批准的状态机版本和旧状态映射；
6. glossary 与 field dictionary 覆盖报告；
7. 普通交易日日报样例；
8. 完整五交易日周报样例；
9. 节假日短周样例；
10. 存在 S3/正式候选/触发与失效的历史回归样例；
11. 自动检查结果和真实浏览器截图/渲染日志；
12. 生成时间、发布时间和调度状态记录。

## 十、最终完成定义

### 周报可复验

P0-01～P0-06 全部关闭，图形事件、下周计划、价位语义、状态机和审计均可信。

### 日报通过

P1-01～P1-08 全部关闭，首页重点、早期池、日资金榜、龙头日变化、量化缺口、风险分层和字段说明闭合。

### 周报通过

日报通过，且 P1-09～P1-13 关闭；周报能可信回答“本周形成/衰退什么、下周盯什么”，并满足发布节奏。

### 二次优化整体通过

日报与周报均通过，四类回归样例走通“早期发现”和“确认板块→正式候选→触发/失效”两条完整路径。P2 可继续迭代，不作为本轮最终验收阻断项。

---

本清单只要求修正和补强当前实现，不要求替换数据源、重写页面框架或重建整套报告生成系统。
