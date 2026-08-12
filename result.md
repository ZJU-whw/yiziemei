# 360 正常与 Chrome HTTP 500 的 HAR 链路对比分析

> 数据源：`js-OK.har`（360税务专版浏览器，279条）与 `js-500.har`（Chrome 98，12条）。全部时间均来自 HAR，使用 UTC（`Z`）。Cookie、ticket、人员及纳税人标识已脱敏。

## 一、结论摘要

**最可能根因：Chrome 中业务域 Cookie 在跨站 iframe 链路中未被发送，导致业务应用会话无法连续。** HAR 的发起栈明确出现 `openXtgnToIframeTab`；顶层/来源站点是 `portal.zjsw.tax.cn`，iframe 业务站点是 `dyxscx.yhs.data.sat.tax:8145`，两者跨站。Chrome 的四次业务域请求（异常 #2、#7、#8、#12）全部没有 `Cookie`；与此同时，业务域在 #2、#7、#8、#12 持续下发 `refer` 和新的 `JSESSIONID`，但所有这些 Cookie 均未在下一次业务域请求中出现。正常 #2 则携带 `header_referer`、`sj_sso_name`、`refer`、`JSESSIONID`、`_session_is_expired_`、`_cookie_user_name` 六个 Cookie，直接返回 200。

这些业务 Cookie 的 `Set-Cookie` 均未声明 `SameSite`；也未声明 `Secure`，且全链路是 HTTP。因此，与 HAR 最吻合的是 Chrome 的 SameSite/第三方 Cookie 策略在跨站 iframe 中抑制了业务 Cookie。HAR 能证明“未发送”和“属性缺失”，但不能单独区分是 Chrome 98 的 SameSite-by-default、用户启用的第三方 Cookie 阻止策略，还是两者叠加。

**第二根因（也是最终 500 的直接触发条件）：服务端的 CAS 重试 URL 构造有确定性缺陷。** 第一张 ticket 回到业务域后，异常 #7 返回 `ec1=0001`；构造 #8 时把 `sso_paragram` 的 Base64 尾部 `=` 丢失（560 → 559字符）。第二张 ticket 的 Location 又把参数分隔符输出为 HTML 实体 `&amp;ec1=0001`。Chrome 按 HTTP Location 原样请求，最终 #12 的实际参数名是 `amp;ec1`，不是 `ec1`，且 `sso_paragram` 已无法按标准 Base64 解码。业务服务未做健壮性校验，最终返回通用的 HTTP 500 页面。

因果链可概括为：**跨站 iframe 不带业务 Cookie → 进入 CAS → ticket 已签发但业务会话仍不连续 → #7 产生 `ec1=0001` → 重试 URL 被服务端破坏（丢 `=`、写入 `&amp;`）→ #12 `/sword` 未捕获异常并返回 500。**

## 二、样本范围与总体统计

| 项目 | 360 正常 | Chrome 异常 |
|---|---:|---:|
| 请求数 | 279 | 12 |
| 时间范围 | `2026-08-12T01:25:41.519Z` ～ `2026-08-12T01:26:48.115Z` | `2026-08-12T01:04:51.671Z` ～ `2026-08-12T01:04:52.050Z` |
| 方法 | GET 267；POST 12；OPTIONS 0 | GET 11；POST 1；OPTIONS 0 |
| 状态码 | {200: 278, 404: 1} | {200: 2, 302: 9, 500: 1} |
| 301/401/403 | 均无 | 均无 |
| 302 | 0 | 9（#2、#4～#11） |
| 500 | 0 | 1（#12） |

正常样本唯一非 200 是 #132：`GET /yhscx/common/img/line.png` → 404，发生在主页面成功加载之后，与认证及 500 无关。两份 HAR 都没有 OPTIONS，因此不存在预检失败链。

## 三、业务入口和 SSO/CAS Redirect 链

### 3.1 首次进入业务系统

两份 HAR 的 #2 都是首次访问 `http://dyxscx.yhs.data.sat.tax:8145/sword`，HTTP 方法均为 GET，业务参数集合相同；除每次生成的 `baseuuid`、`rUUID` 外，`ctrl`、`djxh`、`swjgDm`、`ymbm`、`jrxtbm`、`nsrsbh`、`nsrmc`、`shxydm`、`swryDm`、`swryxm`、`gbiSage` 均一致。这证明比较的是同一业务动作。

- 360 #2：带六个业务 Cookie，直接 **200**，HTML 响应正文约 17,683 字符，随后继续加载 277 条资源/业务请求。
- Chrome #2：业务 Cookie **全部缺失**，返回 **302**，Location 指向 `dddl.zjsw.tax.cn/js_sso_server?service=...`，并下发 `refer`、`JSESSIONID`、`header_referer`、`sj_sso_name`。

### 3.2 Chrome 的完整认证链（异常 #2～#12）

| 请求 | 状态 | 作用与证据 |
|---:|---:|---|
| #2 业务 `/sword?ctrl=YhscxCtrl_openDhcxTabPage...` | 302 | 首次进入业务系统；无 Cookie；业务端把原业务 Query 编码成 `sso_paragram`，将目标 `/sword?sso_paragram=...` 作为 CAS `service`。 |
| #4 SSO `/js_sso_server?service=...` | 302 | SSO Cookie 存在；规范化到带尾斜杠的 `/js_sso_server/`。 |
| #5 SSO `/js_sso_server/?service=...` | 302 | `CASTGC` 已发送，转到 `/login?service=...`。 |
| #6 SSO `/login?service=...` | 302 | **第一张 ticket 在该响应的 Location 中产生**（ticket 存在，已脱敏）；Location 回业务 `/sword?sso_paragram=...&ticket=...`。 |
| #7 业务 `/sword?sso_paragram=...&ticket=...` | 302 | **第一张 ticket 在此提交给业务系统**；仍无 Cookie；业务端下发全新 `JSESSIONID`，并 Location 到 `/sword?...&ec1=0001`，表明认证/回调未正常完成。 |
| #8 业务 `/sword?sso_paragram=...&ec1=0001` | 302 | 仍无 Cookie；再次跳 SSO。此 URL 中 `sso_paragram` 已从 560 字符变成 559 字符，Base64 尾部 `=` 丢失。 |
| #9～#10 SSO | 302 | 第二轮规范化并转 `/login`；SSO Cookie 与第一轮保持一致。 |
| #11 SSO `/login?service=...` | 302 | **第二张 ticket 产生**；Location 含字面量 `&amp;ec1=0001`，不是合法的 Query 分隔写法。 |
| #12 业务 `/sword?sso_paragram=...&amp;ec1=0001&ticket=...` | **500** | **第二张 ticket 在此提交**；实际 Query key 为 `sso_paragram`、`amp;ec1`、`ticket`；无 Cookie；响应为通用“HTTP状态 500 - 内部服务器错误”HTML。 |

正常 HAR 中没有 CAS URL、`service`、`ticket`、`ec1` 或 `sso_paragram`。不能据此声称“360 的 ticket 校验成功”；实际证据是 360 在记录开始时已经拥有可用的业务会话，首次业务请求直接 200，根本没有进入本次 CAS 链。

`sso_paragram` 的第一次有效值可 Base64 解码为原始 13 个业务参数，且与 Chrome #2 原始 Query **逐字段完全一致**；这证明第一次 CAS `service` 没有把业务参数换成另一项业务。第二轮值因少一个 `=` 已不能按标准 Base64 解码。

## 四、关键对应请求逐字段对比

### 4.1 业务入口：正常 #2 对 Chrome #2

| 字段 | 360 #2（正常） | Chrome #2（异常） | 判断 |
|---|---|---|---|
| Host | dyxscx.yhs.data.sat.tax:8145 | dyxscx.yhs.data.sat.tax:8145 | 相同 |
| Cookie | `header_referer`, `sj_sso_name`, `refer`, `JSESSIONID`, `_session_is_expired_`, `_cookie_user_name` | — | **关键差异** |
| Origin | — | — | 相同 |
| Referer | http://portal.zjsw.tax.cn/sword?ctrl=MH003InitLoginxxCtrl_openWin | http://portal.zjsw.tax.cn/ | 不同/见值 |
| User-Agent | Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.198 Safari/537.36 | Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 | 不同/见值 |
| Accept | text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9 | text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9 | 相同 |
| Accept-Language | zh-CN,zh;q=0.9 | zh-CN,zh;q=0.9 | 相同 |
| Sec-Fetch-Site | — | — | 相同 |
| Sec-Fetch-Mode | — | — | 相同 |
| Sec-Fetch-Dest | — | — | 相同 |
| Authorization | — | — | 相同 |
| URL/Query | `/sword`；13个业务参数 | `/sword`；同样13个业务参数 | 除 `baseuuid`、`rUUID` 外业务值一致 |
| 状态/Redirect | **200**；无跳转 | **302** → SSO | 由会话状态分叉 |

两边 Accept 完全一致；Accept-Language 都是 `zh-CN,zh;q=0.9`；Origin 都缺失（文档/iframe导航通常没有 Origin）。Referer 有轻微差异：正常保留 portal 的 `/sword?ctrl=MH003...`，异常只保留 `http://portal.zjsw.tax.cn/`，但两者同属 portal，且没有证据显示服务端依赖 Referer 完成认证。UA 的实质差异是 360 样本报告 Chromium 86/WOW64，Chrome 样本报告 Chrome 98/Win64。

### 4.2 响应头：正常 #2 对 Chrome #2

| 字段 | 360 #2 | Chrome #2 |
|---|---|---|
| Set-Cookie | `_cookie_user_name`、`_session_is_expired_`（均 Path=/，另一次同名用户 Cookie） | `refer`（Domain=sat.tax; Path=/）、`JSESSIONID`（Path=/; HttpOnly）、`header_referer`（Domain=sat.tax; Path=/）、`sj_sso_name`（Domain=sat.tax; Path=/） |
| Location | 无 | `http://dddl.zjsw.tax.cn/js_sso_server?service=...` |
| Content-Type | `text/html;charset=UTF-8` | HAR 未记录 |
| Access-Control-Allow-* | 全部缺失 | 全部缺失 |
| Body | HTML，HAR text 17,683字符 | 空，302 |

### 4.3 Chrome 最终 #12 与正常对应请求 #2

正常样本没有完全相同的 `ticket` 回调请求；语义上唯一对应项是正常 #2，因为 #12 的有效 `sso_paragram` 本应还原到 #2 的业务入口参数。

| 字段 | 正常 #2 | Chrome #12（500） |
|---|---|---|
| URL | `/sword?ctrl=YhscxCtrl_openDhcxTabPage&...` | `/sword?sso_paragram=[559字符]&amp;ec1=0001&ticket=[存在]` |
| QueryString | 13个原始业务参数 | keys=`sso_paragram`,`amp;ec1`,`ticket`；应有的 `ec1` 不存在 |
| Cookie | `header_referer`,`sj_sso_name`,`refer`,`JSESSIONID`,`_session_is_expired_`,`_cookie_user_name` | **无** |
| Referer | portal 完整 `/sword?...` | `http://portal.zjsw.tax.cn/` |
| Origin | 无 | 无 |
| User-Agent | Chromium 86/WOW64 | Chrome 98/Win64 |
| Accept | 两者相同：HTML/xhtml/xml/images/* 导航 Accept | 两者相同 |
| Authorization | 无 | 无 |
| 响应状态 | 200 | **500** |
| Response Headers | Content-Type=`text/html;charset=UTF-8`；业务用户 Cookie | Content-Type=`text/html;charset=utf-8`；新下发 `refer`、新 `JSESSIONID`；无 Location/CORS 头 |
| Response Body | 业务页面 HTML，17,683字符 | 413字符通用 HTML，仅显示“HTTP状态 500 - 内部服务器错误”，无异常栈 |

## 五、Cookie 生命周期与丢失点

### 5.1 360 正常

正常记录一开始，portal #1 已发送 `MHWB_SESSION`、`_cookie_user_name`、`_cookie_login_origin`。首次业务请求 #2 已发送六个业务 Cookie；其中关键的 `JSESSIONID`、`refer`、`header_referer`、`sj_sso_name` **不是在本 HAR 中创建的**，说明它们来自记录开始前。正常业务后续请求持续携带这六个 Cookie。

正常样本的 Set-Cookie 事件：portal #1 设置 `_cookie_login_origin`（Domain=.tax.cn; Path=/）和 `_cookie_user_name`（Path=/）；业务 #2、#133～#135、#267、#269～#276 重复设置 `_cookie_user_name` 与 `_session_is_expired_`（Path=/）。这些响应均未出现 SameSite 或 Secure。

### 5.2 Chrome 异常

| 响应 # | 主机 | Set-Cookie（值脱敏） | 下一次同业务主机请求是否发送 |
|---:|---|---|---|
| #2 | `dyxscx.yhs.data.sat.tax:8145` | `refer`（Domain=sat.tax；Path=/；SameSite=未设置；Secure=未设置；Expires/Max-Age=未设置）<br>`JSESSIONID`（Path=/；HttpOnly；SameSite=未设置；Secure=未设置；Expires/Max-Age=未设置）<br>`header_referer`（Domain=sat.tax；Path=/；SameSite=未设置；Secure=未设置；Expires/Max-Age=未设置）<br>`sj_sso_name`（Domain=sat.tax；Path=/；SameSite=未设置；Secure=未设置；Expires/Max-Age=未设置） | **否，Cookie 头为空** |
| #7 | `dyxscx.yhs.data.sat.tax:8145` | `refer`（Domain=sat.tax；Path=/；SameSite=未设置；Secure=未设置；Expires/Max-Age=未设置）<br>`JSESSIONID`（Path=/；HttpOnly；SameSite=未设置；Secure=未设置；Expires/Max-Age=未设置） | **否，Cookie 头为空** |
| #8 | `dyxscx.yhs.data.sat.tax:8145` | `refer`（Domain=sat.tax；Path=/；SameSite=未设置；Secure=未设置；Expires/Max-Age=未设置）<br>`JSESSIONID`（Path=/；HttpOnly；SameSite=未设置；Secure=未设置；Expires/Max-Age=未设置）<br>`header_referer`（Domain=sat.tax；Path=/；SameSite=未设置；Secure=未设置；Expires/Max-Age=未设置）<br>`sj_sso_name`（Domain=sat.tax；Path=/；SameSite=未设置；Secure=未设置；Expires/Max-Age=未设置） | **否，Cookie 头为空** |
| #12 | `dyxscx.yhs.data.sat.tax:8145` | `refer`（Domain=sat.tax；Path=/；SameSite=未设置；Secure=未设置；Expires/Max-Age=未设置）<br>`JSESSIONID`（Path=/；HttpOnly；SameSite=未设置；Secure=未设置；Expires/Max-Age=未设置） | 无后续请求 |

Chrome 业务端 #2、#7、#8、#12 下发的四个 `JSESSIONID` 值彼此不同，证明服务端不断创建新会话，而不是恢复前一跳会话。Domain/Path 不能单独解释：`refer/header_referer/sj_sso_name` 使用 Domain=`sat.tax`、Path=`/`，`JSESSIONID` 是业务主机的 host-only Cookie、Path=`/`；两类 Cookie 都未被发送。

相反，SSO 域 `dddl.zjsw.tax.cn` 的 Cookie 没有丢失：#4 已发送 `_idnetify_key_`、SSO `JSESSIONID`、`sso_cookie_logid`、`sso_cookie_uid` 等；进入带尾斜杠路径的 #5 后还发送 `CASTGC`；#6、#9、#10、#11 中相关值保持一致。因此“SSO 服务器 Cookie 在 Redirect 中丢失”不符合 HAR。丢失的是跨站 iframe 中的 **业务域 Cookie**。

## 六、请求头、响应头与 CORS 汇总

- 两份 HAR 的任何请求都没有 `Authorization`。
- 两份 HAR 都没有 `Sec-Fetch-Site`、`Sec-Fetch-Mode`、`Sec-Fetch-Dest`。这是 HAR 未记录/浏览器实现差异，不能把“缺少 Sec-Fetch”当根因。
- 正常 13 个请求有 Origin，异常只有 portal #1 有 Origin；这些都是 XHR。认证失败链是 document/iframe 导航，不是跨域 XHR。
- 两份 HAR 的所有响应都没有 `Access-Control-Allow-Origin`、`Access-Control-Allow-Credentials`、`Access-Control-Allow-Headers`、`Access-Control-Allow-Methods`。
- 两份 HAR 均无 OPTIONS；也无 301、401、403。故 CORS/预检不是 500 的前置原因。
- Host、Accept、Accept-Language 在对应业务入口基本相同；关键可观测差异是 Cookie 和 UA/浏览器版本。

## 七、分层归因评级

| 候选 | 可能性 | 支持证据 | 反对/限制证据 |
|---|---|---|---|
| A. Chrome 浏览器安全策略 | **高** | Chrome 的所有业务域 iframe 请求无 Cookie；SSO 同站 Cookie 正常；360 同业务入口会发送 Cookie。 | HAR 不含 Chrome DevTools 的 cookie-blocked-reason，无法指出具体策略开关。 |
| B. SameSite Cookie | **很高** | 明确是 `openXtgnToIframeTab` 跨站 iframe；业务 Set-Cookie 全无 SameSite；Chrome 后续不发；正常 360 发。 | 正常 Cookie 是记录前已有，HAR 不含其原始 SameSite 属性；也不能排除用户显式阻止第三方 Cookie。 |
| C. 第三方 Cookie | **中高** | 业务域相对 portal 是第三方 iframe；Chrome 抑制全部业务 Cookie。 | HAR 不能读取浏览器“阻止第三方 Cookie”设置；SameSite=Lax 默认本身就足以产生相似现象。 |
| D. Cookie Domain/Path | **低** | 无正面支持；若单个属性错误，通常只影响相应 Cookie。 | Domain=`sat.tax` 能覆盖该业务子域、Path=`/` 匹配；host-only `JSESSIONID` 和 Domain Cookie 同时都缺失；正常 360 可发送同名业务 Cookie。 |
| E. SSO/CAS Session 丢失 | **SSO侧低；业务侧很高** | 业务侧每跳新 JSESSIONID，业务会话明确不连续。 | SSO 的 CASTGC、JSESSIONID、识别 Cookie 在两轮中持续发送，且两次成功发 ticket，故不是 SSO 域会话丢失。 |
| F. ticket 校验失败 | **高（中间故障）** | #6 发第一张 ticket，#7 提交后没有 200而返回 `ec1=0001` 并重新认证；没有形成业务会话。 | HAR 没有 CAS 后端校验请求或服务端日志，无法证明是 ticket 本身无效还是业务会话/回调处理失败。 |
| G. CORS/OPTIONS | **极低** | 无。 | 0 个 OPTIONS、无 CORS 错误响应；失败发生在 document/iframe 302链和服务端500。 |
| H. 服务端业务异常 | **高（最终500层）** | #12 确实收到服务端 HTTP 500；响应是服务器生成的通用错误页。 | 最初分叉发生在 Cookie 缺失；同一业务正常请求可200，因此不是业务功能数据必然报错。 |
| I. 其他：重试URL编码缺陷 | **很高（直接触发）** | #7 后 Base64 `=` 被丢；#11 Location 包含字面 `&amp;`；#12 参数名实际为 `amp;ec1`，随后500。 | HAR 无服务端栈，不能确定500具体代码行；但输入畸变是直接可见事实。 |

## 八、为什么 360 正常而 Chrome 异常

360 正常不是因为它完成了本次 CAS，而是因为它在首次业务请求前已经拥有并发送业务会话 Cookie，直接绕过了 CAS。Chrome 虽在 portal 和 SSO 域都有有效 Cookie，也能获得 ticket，但在跨站 iframe 请求业务域时始终不发送业务 Cookie。360 税务专版浏览器报告的是 Chromium 86，并可能具有兼容策略/白名单或更宽松的第三方 Cookie 策略；Chrome 98 则表现出更严格的跨站 Cookie 行为。后半句是对可见网络行为的机制解释，HAR 本身不能证明具体浏览器策略配置。

## 九、服务端修改建议

1. **优先修复站点与 Cookie 架构。** 全链路改为 HTTPS；需要在跨站 iframe 使用的会话 Cookie 显式设置 `SameSite=None; Secure; HttpOnly; Path=/`。不要只加 `SameSite=None` 而继续 HTTP，因为现代 Chromium 要求 None Cookie 同时 Secure。
2. **长期消除第三方上下文。** 让 portal 与业务通过同一可注册站点/统一反向代理访问，或避免在跨站 iframe 内承载登录会话。随着第三方 Cookie 限制继续收紧，仅靠 `SameSite=None` 并非长期稳妥方案。
3. **修复 CAS service URL 编码。** 使用 URI builder 对内层 service 逐层 percent-encode；不得对 HTTP `Location` 做 HTML escaping；必须保留 Base64 padding，最好改用 Base64URL（或完整 URL 编码）。#11 的 `&amp;ec1` 必须输出为参数语义正确的 `&ec1`，且嵌套在 service 时应编码为 `%26ec1%3D0001`。
4. **ticket 回调不应依赖回调前的业务 JSESSIONID。** CAS ticket 应能建立新的业务会话；若必须关联 state，使用服务端签名、一次性且与 Cookie 策略兼容的 state，不要假定第三方 iframe Cookie 一定存在。
5. **错误处理返回 4xx/可诊断错误。** 对缺少/非法 `sso_paragram`、错误参数名、Base64 解码失败和 ticket 校验失败显式校验，不得抛出未捕获异常形成500；服务端日志记录关联ID而不是 ticket 明文。

## 十、Chrome 端验证与最小化确认测试

### 10.1 立即验证

1. Chrome DevTools → Application → Cookies，观察 `dyxscx.yhs.data.sat.tax` 的 `JSESSIONID/refer/header_referer/sj_sso_name` 是否存储，以及 Network 请求 Cookies 面板中的 blocked reason。
2. DevTools Issues 面板检查 SameSite/第三方 Cookie 警告；同时记录 Console。HAR 没保存 blocked reason，这一步能补齐关键证据。
3. 临时允许该站点第三方 Cookie或关闭对应阻止策略后，清空 portal、SSO、业务三个站点 Cookie，重新登录并只点击一次。若 Chrome #2 开始发送业务 Cookie并直接/经一次CAS后200，则确认 Cookie 策略链。
4. 将业务 URL 单独在顶层标签页打开（不是 portal iframe）。若顶层可建立/发送 JSESSIONID，而 iframe 不行，基本锁定 SameSite/第三方上下文，而非 Domain/Path。
5. 不要复用 HAR 中 ticket；CAS ticket 通常一次性。每次测试重新登录并签发。

### 10.2 最小化四组测试

| 组 | 唯一变量 | 预期判定 |
|---|---|---|
| T1 基线 | Chrome 98，当前 iframe/HTTP/Cookie 属性 | 复现：业务请求 Cookie 为空，进入两轮 CAS并500。 |
| T2 顶层导航 | 同一 Chrome/同账号，只把业务 URL 在顶层打开 | 若 Cookie 可连续且成功，确认跨站 iframe 是必要条件。 |
| T3 Cookie 修复 | 测试环境 HTTPS + `SameSite=None; Secure`，其余不变 | 若 #7 能携带前一步 JSESSIONID且CAS后200，确认首要根因。 |
| T4 URL 修复 | 保持 Cookie 问题以强制进入重试，但修复 service percent-encoding/禁止HTML escape | 即使认证失败也应返回可控4xx/错误页，不应出现 `amp;ec1`、Base64丢 padding或500；确认第二根因。 |

服务端同步记录每组的：业务 JSESSIONID 哈希、ticket 校验结果、service 原文/解码后参数名、`sso_paragram` 长度与解码异常、最终异常栈。判定标准不是“页面看起来正常”，而是 #7/#12 是否携带前一步业务 Cookie、是否仅签发/消费一张 ticket、最终是否200。

## 十一、完整请求时间线

下表按 HAR `entries` 原始顺序列出。动态身份值、ticket、UUID、纳税人/人员字段已脱敏；URL 路径、控制器名、Query 参数名、状态码和跳转目标保留。HAR 没有 pages 元数据，因此顺序按 `startedDateTime`/entries 展示；并发资源的毫秒级顺序以 HAR 记录为准。

<details open>
<summary><strong>Chrome 异常：12条完整时间线</strong></summary>

| # | 开始时间（UTC） | 方法 | 状态 | URL（敏感值脱敏） | Redirect/最终响应 |
|---:|---|---|---:|---|---|
| 1 | `2026-08-12T01:04:51.671Z` | POST | **200** | `http://portal.zjsw.tax.cn/ajax.sword?r=0.5318956111343476&rUUID=[已脱敏]` | 最终 `200` OK |
| 2 | `2026-08-12T01:04:51.722Z` | GET | **302** | `http://dyxscx.yhs.data.sat.tax:8145/sword?ctrl=YhscxCtrl_openDhcxTabPage&djxh=[已脱敏]&swjgDm=13301090000&ymbm=dhcx009&jrxtbm=WBXT-CKTS&nsrsbh=[已脱敏]&nsrmc=[已脱敏]&shxydm=[已脱敏]&swryDm=[已脱敏]&swryxm=[已脱敏]&gbiSage=CUR&baseuuid=[已脱敏]&rUUID=[已脱敏]` | Location → `http://dddl.zjsw.tax.cn/js_sso_server?service=http://dyxscx.yhs.data.sat.tax:8145/sword?[嵌套参数已概括]` |
| 3 | `2026-08-12T01:04:51.738Z` | GET | **200** | `http://portal.zjsw.tax.cn/layout/layout1/blue/box_img/s_l.png` | 最终 `200` OK |
| 4 | `2026-08-12T01:04:51.788Z` | GET | **302** | `http://dddl.zjsw.tax.cn/js_sso_server?service=http://dyxscx.yhs.data.sat.tax:8145/sword?[嵌套参数已概括]` | Location → `http://dddl.zjsw.tax.cn/js_sso_server/?service=http://dyxscx.yhs.data.sat.tax:8145/sword?[嵌套参数已概括]` |
| 5 | `2026-08-12T01:04:51.798Z` | GET | **302** | `http://dddl.zjsw.tax.cn/js_sso_server/?service=http://dyxscx.yhs.data.sat.tax:8145/sword?[嵌套参数已概括]` | Location → `http://dddl.zjsw.tax.cn/js_sso_server/login?service=http://dyxscx.yhs.data.sat.tax:8145/sword?[嵌套参数已概括]` |
| 6 | `2026-08-12T01:04:51.806Z` | GET | **302** | `http://dddl.zjsw.tax.cn/js_sso_server/login?service=http://dyxscx.yhs.data.sat.tax:8145/sword?[嵌套参数已概括]` | Location → `http://dyxscx.yhs.data.sat.tax:8145/sword?sso_paragram=[存在，560字符]&ticket=[存在，已脱敏]` |
| 7 | `2026-08-12T01:04:51.817Z` | GET | **302** | `http://dyxscx.yhs.data.sat.tax:8145/sword?sso_paragram=[存在，560字符]&ticket=[存在，已脱敏]` | Location → `/sword?sso_paragram=[存在，559字符]&ec1=0001` |
| 8 | `2026-08-12T01:04:51.959Z` | GET | **302** | `http://dyxscx.yhs.data.sat.tax:8145/sword?sso_paragram=[存在，559字符]&ec1=0001` | Location → `http://dddl.zjsw.tax.cn/js_sso_server?service=http://dyxscx.yhs.data.sat.tax:8145/sword?[嵌套参数已概括]` |
| 9 | `2026-08-12T01:04:52.024Z` | GET | **302** | `http://dddl.zjsw.tax.cn/js_sso_server?service=http://dyxscx.yhs.data.sat.tax:8145/sword?[嵌套参数已概括]` | Location → `http://dddl.zjsw.tax.cn/js_sso_server/?service=http://dyxscx.yhs.data.sat.tax:8145/sword?[嵌套参数已概括]` |
| 10 | `2026-08-12T01:04:52.032Z` | GET | **302** | `http://dddl.zjsw.tax.cn/js_sso_server/?service=http://dyxscx.yhs.data.sat.tax:8145/sword?[嵌套参数已概括]` | Location → `http://dddl.zjsw.tax.cn/js_sso_server/login?service=http://dyxscx.yhs.data.sat.tax:8145/sword?[嵌套参数已概括]` |
| 11 | `2026-08-12T01:04:52.040Z` | GET | **302** | `http://dddl.zjsw.tax.cn/js_sso_server/login?service=http://dyxscx.yhs.data.sat.tax:8145/sword?[嵌套参数已概括]` | Location → `http://dyxscx.yhs.data.sat.tax:8145/sword?sso_paragram=[存在，559字符]&amp;ec1=0001&ticket=[存在，已脱敏]` |
| 12 | `2026-08-12T01:04:52.050Z` | GET | **500** | `http://dyxscx.yhs.data.sat.tax:8145/sword?sso_paragram=[存在，559字符]&amp;ec1=0001&ticket=[存在，已脱敏]` | 最终 `500`  |

</details>

<details>
<summary><strong>360 正常：279条完整时间线</strong></summary>

| # | 开始时间（UTC） | 方法 | 状态 | URL（敏感值脱敏） | Redirect/最终响应 |
|---:|---|---|---:|---|---|
| 1 | `2026-08-12T01:25:41.519Z` | POST | **200** | `http://portal.zjsw.tax.cn/ajax.sword?r=0.7163893431399351&rUUID=[已脱敏]` | 最终 `200` OK |
| 2 | `2026-08-12T01:25:41.580Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/sword?ctrl=YhscxCtrl_openDhcxTabPage&djxh=[已脱敏]&swjgDm=13301090000&ymbm=dhcx009&jrxtbm=WBXT-CKTS&nsrsbh=[已脱敏]&nsrmc=[已脱敏]&shxydm=[已脱敏]&swryDm=[已脱敏]&swryxm=[已脱敏]&gbiSage=CUR&baseuuid=[已脱敏]&rUUID=[已脱敏]` | 最终 `200`  |
| 3 | `2026-08-12T01:25:41.598Z` | GET | **200** | `http://portal.zjsw.tax.cn/layout/layout1/blue/box_img/s_l.png` | 最终 `200` OK |
| 4 | `2026-08-12T01:25:42.155Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/common/js/domain.js` | 最终 `200`  |
| 5 | `2026-08-12T01:25:42.155Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/blueWingsNew/public/common_wings_config.js` | 最终 `200`  |
| 6 | `2026-08-12T01:25:42.155Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/blueWingsNew/public/diy_wings_config.js` | 最终 `200`  |
| 7 | `2026-08-12T01:25:42.156Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsFileUpload/wingsFileUpload.css` | 最终 `200`  |
| 8 | `2026-08-12T01:25:42.156Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/uploadfile/js/vendor/jquery.ui.widget.js` | 最终 `200`  |
| 9 | `2026-08-12T01:25:42.156Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/uploadfile/js/jquery.iframe-transport.js` | 最终 `200`  |
| 10 | `2026-08-12T01:25:42.157Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/uploadfile/js/jquery.fileupload.js` | 最终 `200`  |
| 11 | `2026-08-12T01:25:42.157Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/uploadfile/js/jquery.fileupload-ui.js` | 最终 `200`  |
| 12 | `2026-08-12T01:25:42.157Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/uploadfile/js/jquery.fileupload-process.js` | 最终 `200`  |
| 13 | `2026-08-12T01:25:42.157Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/uploadfile/js/jquery.fileupload-image.js` | 最终 `200`  |
| 14 | `2026-08-12T01:25:42.158Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/uploadfile/js/jquery.fileupload-audio.js` | 最终 `200`  |
| 15 | `2026-08-12T01:25:42.158Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/uploadfile/js/jquery.fileupload-video.js` | 最终 `200`  |
| 16 | `2026-08-12T01:25:42.158Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/uploadfile/js/jquery.fileupload-validate.js` | 最终 `200`  |
| 17 | `2026-08-12T01:25:42.159Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsFileUpload/wingsFileUpload.js` | 最终 `200`  |
| 18 | `2026-08-12T01:25:42.159Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/webuploader/webuploader.css` | 最终 `200`  |
| 19 | `2026-08-12T01:25:42.159Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/webuploader/webuploader.js` | 最终 `200`  |
| 20 | `2026-08-12T01:25:42.160Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsFrameTab/wingsFrameTab.css` | 最终 `200`  |
| 21 | `2026-08-12T01:25:42.160Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsAccordion/wingsAccordion.css` | 最终 `200`  |
| 22 | `2026-08-12T01:25:42.160Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsFrameTab/wingsFrameTab.js` | 最终 `200`  |
| 23 | `2026-08-12T01:25:42.160Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsAccordion/wingsAccordion.js` | 最终 `200`  |
| 24 | `2026-08-12T01:25:42.161Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/move/multiselect.js` | 最终 `200`  |
| 25 | `2026-08-12T01:25:42.161Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsMove/wingsMove.js` | 最终 `200`  |
| 26 | `2026-08-12T01:25:42.161Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsMenu/wingsMenuStyle.css` | 最终 `200`  |
| 27 | `2026-08-12T01:25:42.161Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsMenu/wingsMenu.js` | 最终 `200`  |
| 28 | `2026-08-12T01:25:42.162Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsTabSelect/wingsTabSelect.css` | 最终 `200`  |
| 29 | `2026-08-12T01:25:42.162Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsTabSelect/wingsTabSelect.js` | 最终 `200`  |
| 30 | `2026-08-12T01:25:42.162Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/zdyCommon/css/uploading.css` | 最终 `200`  |
| 31 | `2026-08-12T01:25:42.163Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/zdyCommon/css/wingsZdyCommon.css` | 最终 `200`  |
| 32 | `2026-08-12T01:25:42.164Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/zdyCommon/css/zdyCommon.css` | 最终 `200`  |
| 33 | `2026-08-12T01:25:42.164Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/common/css/pages.css` | 最终 `200`  |
| 34 | `2026-08-12T01:25:42.164Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/common/css/table_center.css` | 最终 `200`  |
| 35 | `2026-08-12T01:25:42.165Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/common/watermark/watermark.css` | 最终 `200`  |
| 36 | `2026-08-12T01:25:42.165Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/common/js/crypto-js.js` | 最终 `200`  |
| 37 | `2026-08-12T01:25:42.165Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/zdyCommon/js/afterCommon.js` | 最终 `200`  |
| 38 | `2026-08-12T01:25:42.165Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/zdyCommon/js/zdyToolbar.js` | 最终 `200`  |
| 39 | `2026-08-12T01:25:42.166Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/common/js/numberFormat.js` | 最终 `200`  |
| 40 | `2026-08-12T01:25:42.166Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/common/js/common.js` | 最终 `200`  |
| 41 | `2026-08-12T01:25:42.166Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wingWeb/domain.js` | 最终 `200`  |
| 42 | `2026-08-12T01:25:42.167Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/common/js/submitUtils.js` | 最终 `200`  |
| 43 | `2026-08-12T01:25:42.167Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/common/js/gy_utils.js` | 最终 `200`  |
| 44 | `2026-08-12T01:25:42.167Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/common/js/yxscxDownload.js` | 最终 `200`  |
| 45 | `2026-08-12T01:25:42.167Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/common/watermark/watermark.js` | 最终 `200`  |
| 46 | `2026-08-12T01:25:42.168Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/common/js/commformat.js` | 最终 `200`  |
| 47 | `2026-08-12T01:25:42.168Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/wings/wingsZdyInclude.js` | 最终 `200`  |
| 48 | `2026-08-12T01:25:42.168Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/zdyCommon/js/exportPageData.js` | 最终 `200`  |
| 49 | `2026-08-12T01:25:42.169Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/yhscx/dhcx/dhcx000/common.css` | 最终 `200`  |
| 50 | `2026-08-12T01:25:42.169Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/yhscx/common/css/page_nsrxxList.css` | 最终 `200`  |
| 51 | `2026-08-12T01:25:42.169Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/yhscx/dhcx/dhcx000/dhcx.css` | 最终 `200`  |
| 52 | `2026-08-12T01:25:42.169Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/common/js/wbxt.js` | 最终 `200`  |
| 53 | `2026-08-12T01:25:42.170Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/yhscx/dhcx/dhcx000/dhcx.js` | 最终 `200`  |
| 54 | `2026-08-12T01:25:42.288Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/common/excanvas.min.js` | 最终 `200`  |
| 55 | `2026-08-12T01:25:42.289Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/common/html5shiv.js` | 最终 `200`  |
| 56 | `2026-08-12T01:25:42.290Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/common/respond.min.js` | 最终 `200`  |
| 57 | `2026-08-12T01:25:42.290Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/jquery/1.10.2/jquery.min.js` | 最终 `200`  |
| 58 | `2026-08-12T01:25:42.291Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/jquery/2.1.1/jquery.min.js` | 最终 `200`  |
| 59 | `2026-08-12T01:25:42.291Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/bootstrap/3.3.7/css/bootstrap.css` | 最终 `200`  |
| 60 | `2026-08-12T01:25:42.291Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/bootstrap/3.3.7/js/bootstrap.min.js` | 最终 `200`  |
| 61 | `2026-08-12T01:25:42.292Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/font/font-awesome.min.css` | 最终 `200`  |
| 62 | `2026-08-12T01:25:42.292Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/bootstrap/3.3.7/css/bootstrap.wings.css` | 最终 `200`  |
| 63 | `2026-08-12T01:25:42.293Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/css/css-ie.min.css` | 最终 `200`  |
| 64 | `2026-08-12T01:25:42.293Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/css/exception_dialog.css` | 最终 `200`  |
| 65 | `2026-08-12T01:25:42.294Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/js/common.js` | 最终 `200`  |
| 66 | `2026-08-12T01:25:42.294Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/js/wings.min.js` | 最终 `200`  |
| 67 | `2026-08-12T01:25:42.295Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/common/json2.js` | 最终 `200`  |
| 68 | `2026-08-12T01:25:42.295Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/common/json2.min.js` | 最终 `200`  |
| 69 | `2026-08-12T01:25:42.296Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/js/SwordAdapter.js` | 最终 `200`  |
| 70 | `2026-08-12T01:25:42.296Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/dialog/bootstrap-dialog.js` | 最终 `200`  |
| 71 | `2026-08-12T01:25:42.297Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsDialog/wingsDialog.js` | 最终 `200`  |
| 72 | `2026-08-12T01:25:42.297Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsTab/wingsTab.js` | 最终 `200`  |
| 73 | `2026-08-12T01:25:42.297Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsTab/wingsTab.css` | 最终 `200`  |
| 74 | `2026-08-12T01:25:42.298Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/bootstrapSuggest/bootstrap-suggest-forwings.js` | 最终 `200`  |
| 75 | `2026-08-12T01:25:42.299Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsSuggest/wingsSuggest.js` | 最终 `200`  |
| 76 | `2026-08-12T01:25:42.299Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/progressbar/spin.js` | 最终 `200`  |
| 77 | `2026-08-12T01:25:42.300Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsprogressbar/wingsprogressbar.js` | 最终 `200`  |
| 78 | `2026-08-12T01:25:42.301Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsDatetime/bootstrap-datetimepicker.min.css` | 最终 `200`  |
| 79 | `2026-08-12T01:25:42.302Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsDatetime/bootstrap-datetimepicker.js` | 最终 `200`  |
| 80 | `2026-08-12T01:25:42.303Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsDatetime/bootstrap-datetimepicker.zh-CN.js` | 最终 `200`  |
| 81 | `2026-08-12T01:25:42.303Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsDatetime/wingsDatetime.js` | 最终 `200`  |
| 82 | `2026-08-12T01:25:42.304Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsToolbar/wingsToolbar.js` | 最终 `200`  |
| 83 | `2026-08-12T01:25:42.305Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/css/wingsToolbars.css` | 最终 `200`  |
| 84 | `2026-08-12T01:25:42.306Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsSelector/select2.css` | 最终 `200`  |
| 85 | `2026-08-12T01:25:42.307Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsSelector/wingsSelector.js` | 最终 `200`  |
| 86 | `2026-08-12T01:25:42.307Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsSelector/select2.js` | 最终 `200`  |
| 87 | `2026-08-12T01:25:42.311Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsSelector/wingsMultipleSelector.js` | 最终 `200`  |
| 88 | `2026-08-12T01:25:42.312Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsSelector/wingsSelect2.css` | 最终 `200`  |
| 89 | `2026-08-12T01:25:42.313Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsSelector/wingsSelector2.js` | 最终 `200`  |
| 90 | `2026-08-12T01:25:42.313Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/datatable/1.10.12/css/jquery.dataTables.css` | 最终 `200`  |
| 91 | `2026-08-12T01:25:42.313Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/datatable/1.10.12/css/dataTables.bootstrap.css` | 最终 `200`  |
| 92 | `2026-08-12T01:25:42.314Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsDatatable/wingsDataTables.css` | 最终 `200`  |
| 93 | `2026-08-12T01:25:42.314Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/datatable/1.10.12/js/jquery.dataTables.js` | 最终 `200`  |
| 94 | `2026-08-12T01:25:42.315Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/datatable/1.10.12/js/jquery.dataTables.min.js` | 最终 `200`  |
| 95 | `2026-08-12T01:25:42.315Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsDatatable/wingsDataTables.min.js` | 最终 `200`  |
| 96 | `2026-08-12T01:25:42.316Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsDatatable/wingsDataTables.js` | 最终 `200`  |
| 97 | `2026-08-12T01:25:42.316Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsDatatable/extensions/wingsDataTables.plugins.js` | 最终 `200`  |
| 98 | `2026-08-12T01:25:42.317Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsValidate/wingsValidate.css` | 最终 `200`  |
| 99 | `2026-08-12T01:25:42.317Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/common/jquery.validate.js` | 最终 `200`  |
| 100 | `2026-08-12T01:25:42.318Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsValidate/wingsValidate.js` | 最终 `200`  |
| 101 | `2026-08-12T01:25:42.318Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsValidate/wingsValidate2.js` | 最终 `200`  |
| 102 | `2026-08-12T01:25:42.319Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/iCheck/icheck.min.js` | 最终 `200`  |
| 103 | `2026-08-12T01:25:42.319Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsICheck/wingsICheck.js` | 最终 `200`  |
| 104 | `2026-08-12T01:25:42.320Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/iCheck/skins/all.css` | 最终 `200`  |
| 105 | `2026-08-12T01:25:42.320Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/ztree/zTreeStyle/zTreeStyle.css` | 最终 `200`  |
| 106 | `2026-08-12T01:25:42.320Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsTree/wingsTree.css` | 最终 `200`  |
| 107 | `2026-08-12T01:25:42.321Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/ztree/jquery.ztree.all.js` | 最终 `200`  |
| 108 | `2026-08-12T01:25:42.321Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsTree/wingsTree.js` | 最终 `200`  |
| 109 | `2026-08-12T01:25:42.322Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/common/locache.js` | 最终 `200`  |
| 110 | `2026-08-12T01:25:42.323Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsCache/wingsCache.js` | 最终 `200`  |
| 111 | `2026-08-12T01:25:42.326Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsToolbar/wingsToolbar2.js` | 最终 `200`  |
| 112 | `2026-08-12T01:25:42.326Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsToolbar/wingsToolbar3.js` | 最终 `200`  |
| 113 | `2026-08-12T01:25:42.347Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/store/store.legacy.min.js` | 最终 `200`  |
| 114 | `2026-08-12T01:25:42.349Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/demo/wingsSuggest/suggestTest.js` | 最终 `200`  |
| 115 | `2026-08-12T01:25:42.350Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/css/wingsForm.css` | 最终 `200`  |
| 116 | `2026-08-12T01:25:42.351Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsRadioAndCheckBox/wingsRadioAndCheckBox.js` | 最终 `200`  |
| 117 | `2026-08-12T01:25:43.546Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/iCheck/skins/minimal/_all.css` | 最终 `200`  |
| 118 | `2026-08-12T01:25:43.548Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/iCheck/skins/square/_all.css` | 最终 `200`  |
| 119 | `2026-08-12T01:25:43.548Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/iCheck/skins/flat/_all.css` | 最终 `200`  |
| 120 | `2026-08-12T01:25:43.549Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/iCheck/skins/line/_all.css` | 最终 `200`  |
| 121 | `2026-08-12T01:25:43.549Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/iCheck/skins/polaris/polaris.css` | 最终 `200`  |
| 122 | `2026-08-12T01:25:43.549Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/iCheck/skins/futurico/futurico.css` | 最终 `200`  |
| 123 | `2026-08-12T01:25:43.740Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/zdyCommon/js/wingsDataTables.js` | 最终 `200`  |
| 124 | `2026-08-12T01:25:43.741Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/blueWingsNew/public/echarts.min.js` | 最终 `200`  |
| 125 | `2026-08-12T01:25:43.741Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/blueWingsNew/js/select.js` | 最终 `200`  |
| 126 | `2026-08-12T01:25:43.742Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/blueWingsNew/js/side_bar.js` | 最终 `200`  |
| 127 | `2026-08-12T01:25:43.742Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/blueWingsNew/css/build.css` | 最终 `200`  |
| 128 | `2026-08-12T01:25:43.743Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/blueWingsNew/js/from.js` | 最终 `200`  |
| 129 | `2026-08-12T01:25:43.744Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/blueWingsNew/public/onresize.js` | 最终 `200`  |
| 130 | `2026-08-12T01:25:43.749Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/blueWingsNew/public/js/margin-padding.js` | 最终 `200`  |
| 131 | `2026-08-12T01:25:44.737Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/yhscx/common/img/icon-qitb.png` | 最终 `200`  |
| 132 | `2026-08-12T01:25:44.808Z` | GET | **404** | `http://dyxscx.yhs.data.sat.tax:8145/yhscx/common/img/line.png` | 最终 `404`  |
| 133 | `2026-08-12T01:25:44.901Z` | POST | **200** | `http://dyxscx.yhs.data.sat.tax:8145/ajax.sword?ctrl=DhcxCtrl_queryNsrxxByDjxh` | 最终 `200`  |
| 134 | `2026-08-12T01:25:45.017Z` | POST | **200** | `http://dyxscx.yhs.data.sat.tax:8145/ajax.sword?ctrl=DhcxCtrl_getMenu` | 最终 `200`  |
| 135 | `2026-08-12T01:25:45.148Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/sword?ctrl=DhcxCtrl_loadPage&djxh=[已脱敏]&dsjid=[已脱敏]&menuCode=dhcx009001&page=[已脱敏]&sjlybz=ZJST&nsrsbh=[已脱敏]&shxydm=[已脱敏]&nsrmc=[已脱敏]&appId=yhscx_dhcx&systemInfo=[已脱敏]&zgswjDm=13301090000&zgswskfjDm=13301099300&jrxtbm=WBXT-CKTS` | 最终 `200`  |
| 136 | `2026-08-12T01:25:45.255Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/blueWingsNew/public/common_wings_config.js` | 最终 `200`  |
| 137 | `2026-08-12T01:25:45.256Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/blueWingsNew/public/diy_wings_config.js` | 最终 `200`  |
| 138 | `2026-08-12T01:25:45.257Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsFileUpload/wingsFileUpload.css` | 最终 `200`  |
| 139 | `2026-08-12T01:25:45.257Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/uploadfile/js/vendor/jquery.ui.widget.js` | 最终 `200`  |
| 140 | `2026-08-12T01:25:45.258Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/uploadfile/js/jquery.iframe-transport.js` | 最终 `200`  |
| 141 | `2026-08-12T01:25:45.258Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/uploadfile/js/jquery.fileupload.js` | 最终 `200`  |
| 142 | `2026-08-12T01:25:45.259Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/uploadfile/js/jquery.fileupload-ui.js` | 最终 `200`  |
| 143 | `2026-08-12T01:25:45.259Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/uploadfile/js/jquery.fileupload-process.js` | 最终 `200`  |
| 144 | `2026-08-12T01:25:45.260Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/uploadfile/js/jquery.fileupload-image.js` | 最终 `200`  |
| 145 | `2026-08-12T01:25:45.260Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/uploadfile/js/jquery.fileupload-audio.js` | 最终 `200`  |
| 146 | `2026-08-12T01:25:45.260Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/uploadfile/js/jquery.fileupload-video.js` | 最终 `200`  |
| 147 | `2026-08-12T01:25:45.261Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/uploadfile/js/jquery.fileupload-validate.js` | 最终 `200`  |
| 148 | `2026-08-12T01:25:45.261Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsFileUpload/wingsFileUpload.js` | 最终 `200`  |
| 149 | `2026-08-12T01:25:45.262Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/webuploader/webuploader.css` | 最终 `200`  |
| 150 | `2026-08-12T01:25:45.262Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/webuploader/webuploader.js` | 最终 `200`  |
| 151 | `2026-08-12T01:25:45.263Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsFrameTab/wingsFrameTab.css` | 最终 `200`  |
| 152 | `2026-08-12T01:25:45.263Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsAccordion/wingsAccordion.css` | 最终 `200`  |
| 153 | `2026-08-12T01:25:45.263Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsFrameTab/wingsFrameTab.js` | 最终 `200`  |
| 154 | `2026-08-12T01:25:45.264Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsAccordion/wingsAccordion.js` | 最终 `200`  |
| 155 | `2026-08-12T01:25:45.265Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/move/multiselect.js` | 最终 `200`  |
| 156 | `2026-08-12T01:25:45.265Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsMove/wingsMove.js` | 最终 `200`  |
| 157 | `2026-08-12T01:25:45.266Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsMenu/wingsMenuStyle.css` | 最终 `200`  |
| 158 | `2026-08-12T01:25:45.266Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsMenu/wingsMenu.js` | 最终 `200`  |
| 159 | `2026-08-12T01:25:45.268Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsTabSelect/wingsTabSelect.css` | 最终 `200`  |
| 160 | `2026-08-12T01:25:45.268Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsTabSelect/wingsTabSelect.js` | 最终 `200`  |
| 161 | `2026-08-12T01:25:45.268Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/zdyCommon/css/uploading.css` | 最终 `200`  |
| 162 | `2026-08-12T01:25:45.269Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/zdyCommon/css/wingsZdyCommon.css` | 最终 `200`  |
| 163 | `2026-08-12T01:25:45.269Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/zdyCommon/css/zdyCommon.css` | 最终 `200`  |
| 164 | `2026-08-12T01:25:45.270Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/common/css/pages.css` | 最终 `200`  |
| 165 | `2026-08-12T01:25:45.270Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/common/css/table_center.css` | 最终 `200`  |
| 166 | `2026-08-12T01:25:45.271Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/common/watermark/watermark.css` | 最终 `200`  |
| 167 | `2026-08-12T01:25:45.271Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/common/js/crypto-js.js` | 最终 `200`  |
| 168 | `2026-08-12T01:25:45.272Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/zdyCommon/js/afterCommon.js` | 最终 `200`  |
| 169 | `2026-08-12T01:25:45.272Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/zdyCommon/js/zdyToolbar.js` | 最终 `200`  |
| 170 | `2026-08-12T01:25:45.273Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/common/js/numberFormat.js` | 最终 `200`  |
| 171 | `2026-08-12T01:25:45.273Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/common/js/common.js` | 最终 `200`  |
| 172 | `2026-08-12T01:25:45.273Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wingWeb/domain.js` | 最终 `200`  |
| 173 | `2026-08-12T01:25:45.274Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/common/js/submitUtils.js` | 最终 `200`  |
| 174 | `2026-08-12T01:25:45.274Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/common/js/gy_utils.js` | 最终 `200`  |
| 175 | `2026-08-12T01:25:45.275Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/common/js/yxscxDownload.js` | 最终 `200`  |
| 176 | `2026-08-12T01:25:45.275Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/common/watermark/watermark.js` | 最终 `200`  |
| 177 | `2026-08-12T01:25:45.276Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/common/js/commformat.js` | 最终 `200`  |
| 178 | `2026-08-12T01:25:45.276Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/wings/wingsZdyInclude.js` | 最终 `200`  |
| 179 | `2026-08-12T01:25:45.278Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/zdyCommon/js/exportPageData.js` | 最终 `200`  |
| 180 | `2026-08-12T01:25:45.278Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/yhscx/common/css/diypart_no.css` | 最终 `200`  |
| 181 | `2026-08-12T01:25:45.279Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/common/css/loadwait.css` | 最终 `200`  |
| 182 | `2026-08-12T01:25:45.279Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/common/js/domain.js` | 最终 `200`  |
| 183 | `2026-08-12T01:25:45.280Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/yhscx/dhcx/dhcx009/dhcx009017/ckts.js` | 最终 `200`  |
| 184 | `2026-08-12T01:25:45.357Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/common/excanvas.min.js` | 最终 `200`  |
| 185 | `2026-08-12T01:25:45.358Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/common/html5shiv.js` | 最终 `200`  |
| 186 | `2026-08-12T01:25:45.359Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/common/respond.min.js` | 最终 `200`  |
| 187 | `2026-08-12T01:25:45.359Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/jquery/1.10.2/jquery.min.js` | 最终 `200`  |
| 188 | `2026-08-12T01:25:45.360Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/jquery/2.1.1/jquery.min.js` | 最终 `200`  |
| 189 | `2026-08-12T01:25:45.361Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/bootstrap/3.3.7/css/bootstrap.css` | 最终 `200`  |
| 190 | `2026-08-12T01:25:45.361Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/bootstrap/3.3.7/js/bootstrap.min.js` | 最终 `200`  |
| 191 | `2026-08-12T01:25:45.362Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/font/font-awesome.min.css` | 最终 `200`  |
| 192 | `2026-08-12T01:25:45.362Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/bootstrap/3.3.7/css/bootstrap.wings.css` | 最终 `200`  |
| 193 | `2026-08-12T01:25:45.363Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/css/css-ie.min.css` | 最终 `200`  |
| 194 | `2026-08-12T01:25:45.364Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/css/exception_dialog.css` | 最终 `200`  |
| 195 | `2026-08-12T01:25:45.364Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/js/common.js` | 最终 `200`  |
| 196 | `2026-08-12T01:25:45.365Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/js/wings.min.js` | 最终 `200`  |
| 197 | `2026-08-12T01:25:45.366Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/common/json2.js` | 最终 `200`  |
| 198 | `2026-08-12T01:25:45.366Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/common/json2.min.js` | 最终 `200`  |
| 199 | `2026-08-12T01:25:45.366Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/js/SwordAdapter.js` | 最终 `200`  |
| 200 | `2026-08-12T01:25:45.367Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/dialog/bootstrap-dialog.js` | 最终 `200`  |
| 201 | `2026-08-12T01:25:45.368Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsDialog/wingsDialog.js` | 最终 `200`  |
| 202 | `2026-08-12T01:25:45.368Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsTab/wingsTab.js` | 最终 `200`  |
| 203 | `2026-08-12T01:25:45.369Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsTab/wingsTab.css` | 最终 `200`  |
| 204 | `2026-08-12T01:25:45.369Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/bootstrapSuggest/bootstrap-suggest-forwings.js` | 最终 `200`  |
| 205 | `2026-08-12T01:25:45.370Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsSuggest/wingsSuggest.js` | 最终 `200`  |
| 206 | `2026-08-12T01:25:45.370Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/progressbar/spin.js` | 最终 `200`  |
| 207 | `2026-08-12T01:25:45.371Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsprogressbar/wingsprogressbar.js` | 最终 `200`  |
| 208 | `2026-08-12T01:25:45.372Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsDatetime/bootstrap-datetimepicker.min.css` | 最终 `200`  |
| 209 | `2026-08-12T01:25:45.372Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsDatetime/bootstrap-datetimepicker.js` | 最终 `200`  |
| 210 | `2026-08-12T01:25:45.373Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsDatetime/bootstrap-datetimepicker.zh-CN.js` | 最终 `200`  |
| 211 | `2026-08-12T01:25:45.373Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsDatetime/wingsDatetime.js` | 最终 `200`  |
| 212 | `2026-08-12T01:25:45.374Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsToolbar/wingsToolbar.js` | 最终 `200`  |
| 213 | `2026-08-12T01:25:45.375Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/css/wingsToolbars.css` | 最终 `200`  |
| 214 | `2026-08-12T01:25:45.379Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsSelector/select2.css` | 最终 `200`  |
| 215 | `2026-08-12T01:25:45.380Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsSelector/wingsSelector.js` | 最终 `200`  |
| 216 | `2026-08-12T01:25:45.381Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsSelector/select2.js` | 最终 `200`  |
| 217 | `2026-08-12T01:25:45.381Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsSelector/wingsMultipleSelector.js` | 最终 `200`  |
| 218 | `2026-08-12T01:25:45.382Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsSelector/wingsSelect2.css` | 最终 `200`  |
| 219 | `2026-08-12T01:25:45.382Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsSelector/wingsSelector2.js` | 最终 `200`  |
| 220 | `2026-08-12T01:25:45.383Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/datatable/1.10.12/css/jquery.dataTables.css` | 最终 `200`  |
| 221 | `2026-08-12T01:25:45.383Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/datatable/1.10.12/css/dataTables.bootstrap.css` | 最终 `200`  |
| 222 | `2026-08-12T01:25:45.384Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsDatatable/wingsDataTables.css` | 最终 `200`  |
| 223 | `2026-08-12T01:25:45.384Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/datatable/1.10.12/js/jquery.dataTables.js` | 最终 `200`  |
| 224 | `2026-08-12T01:25:45.385Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/datatable/1.10.12/js/jquery.dataTables.min.js` | 最终 `200`  |
| 225 | `2026-08-12T01:25:45.385Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsDatatable/wingsDataTables.min.js` | 最终 `200`  |
| 226 | `2026-08-12T01:25:45.387Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsDatatable/wingsDataTables.js` | 最终 `200`  |
| 227 | `2026-08-12T01:25:45.388Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsDatatable/extensions/wingsDataTables.plugins.js` | 最终 `200`  |
| 228 | `2026-08-12T01:25:45.388Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsValidate/wingsValidate.css` | 最终 `200`  |
| 229 | `2026-08-12T01:25:45.389Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/common/jquery.validate.js` | 最终 `200`  |
| 230 | `2026-08-12T01:25:45.390Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsValidate/wingsValidate.js` | 最终 `200`  |
| 231 | `2026-08-12T01:25:45.390Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsValidate/wingsValidate2.js` | 最终 `200`  |
| 232 | `2026-08-12T01:25:45.391Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/iCheck/icheck.min.js` | 最终 `200`  |
| 233 | `2026-08-12T01:25:45.391Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsICheck/wingsICheck.js` | 最终 `200`  |
| 234 | `2026-08-12T01:25:45.391Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/iCheck/skins/all.css` | 最终 `200`  |
| 235 | `2026-08-12T01:25:45.392Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/ztree/zTreeStyle/zTreeStyle.css` | 最终 `200`  |
| 236 | `2026-08-12T01:25:45.392Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsTree/wingsTree.css` | 最终 `200`  |
| 237 | `2026-08-12T01:25:45.393Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/ztree/jquery.ztree.all.js` | 最终 `200`  |
| 238 | `2026-08-12T01:25:45.393Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsTree/wingsTree.js` | 最终 `200`  |
| 239 | `2026-08-12T01:25:45.394Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/common/locache.js` | 最终 `200`  |
| 240 | `2026-08-12T01:25:45.394Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsCache/wingsCache.js` | 最终 `200`  |
| 241 | `2026-08-12T01:25:45.398Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsToolbar/wingsToolbar2.js` | 最终 `200`  |
| 242 | `2026-08-12T01:25:45.399Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsToolbar/wingsToolbar3.js` | 最终 `200`  |
| 243 | `2026-08-12T01:25:45.399Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/plugins/store/store.legacy.min.js` | 最终 `200`  |
| 244 | `2026-08-12T01:25:45.401Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/demo/wingsSuggest/suggestTest.js` | 最终 `200`  |
| 245 | `2026-08-12T01:25:45.401Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/css/wingsForm.css` | 最终 `200`  |
| 246 | `2026-08-12T01:25:45.402Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/plugins/wingsRadioAndCheckBox/wingsRadioAndCheckBox.js` | 最终 `200`  |
| 247 | `2026-08-12T01:25:46.624Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/iCheck/skins/minimal/_all.css` | 最终 `200`  |
| 248 | `2026-08-12T01:25:46.625Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/iCheck/skins/square/_all.css` | 最终 `200`  |
| 249 | `2026-08-12T01:25:46.625Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/iCheck/skins/flat/_all.css` | 最终 `200`  |
| 250 | `2026-08-12T01:25:46.630Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/iCheck/skins/line/_all.css` | 最终 `200`  |
| 251 | `2026-08-12T01:25:46.630Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/iCheck/skins/polaris/polaris.css` | 最终 `200`  |
| 252 | `2026-08-12T01:25:46.630Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/iCheck/skins/futurico/futurico.css` | 最终 `200`  |
| 253 | `2026-08-12T01:25:46.842Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/zdyCommon/js/wingsDataTables.js` | 最终 `200`  |
| 254 | `2026-08-12T01:25:46.843Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/blueWingsNew/public/echarts.min.js` | 最终 `200`  |
| 255 | `2026-08-12T01:25:46.843Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/blueWingsNew/js/select.js` | 最终 `200`  |
| 256 | `2026-08-12T01:25:46.844Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/blueWingsNew/js/side_bar.js` | 最终 `200`  |
| 257 | `2026-08-12T01:25:46.845Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/blueWingsNew/css/build.css` | 最终 `200`  |
| 258 | `2026-08-12T01:25:46.845Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/blueWingsNew/js/from.js` | 最终 `200`  |
| 259 | `2026-08-12T01:25:46.846Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/blueWingsNew/public/onresize.js` | 最终 `200`  |
| 260 | `2026-08-12T01:25:46.846Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/blueWingsNew/public/js/margin-padding.js` | 最终 `200`  |
| 261 | `2026-08-12T01:25:47.447Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/yhscx/dhcx/dhcx014/ldtssjfn/img/ldtsfn_ts.png` | 最终 `200`  |
| 262 | `2026-08-12T01:25:47.448Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/blueWingsNew/public/images/Eject_bg3.png` | 最终 `200`  |
| 263 | `2026-08-12T01:25:47.554Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/blueWingsNew/public/images/grid-page-down.png` | 最终 `200`  |
| 264 | `2026-08-12T01:25:47.556Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/include/bootstrap/3.3.7/fonts/glyphicons-halflings-regular.woff2` | 最终 `200`  |
| 265 | `2026-08-12T01:25:47.673Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/img/find.png` | 最终 `200`  |
| 266 | `2026-08-12T01:25:47.674Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/wings/core/img/refresh.png` | 最终 `200`  |
| 267 | `2026-08-12T01:25:47.703Z` | POST | **200** | `http://dyxscx.yhs.data.sat.tax:8145/ajax.sword?ctrl=YxscxGyCtrl_getYmsybz` | 最终 `200`  |
| 268 | `2026-08-12T01:25:47.855Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/theme/wings/zdyCommon/img/qq.gif` | 最终 `200`  |
| 269 | `2026-08-12T01:25:47.889Z` | POST | **200** | `http://dyxscx.yhs.data.sat.tax:8145/ajax.sword?ctrl=YxscxGyCtrl_getQueryData` | 最终 `200`  |
| 270 | `2026-08-12T01:25:47.893Z` | POST | **200** | `http://dyxscx.yhs.data.sat.tax:8145/ajax.sword?ctrl=CktssbqkCtrl_queryCkqyznfxfx` | 最终 `200`  |
| 271 | `2026-08-12T01:26:16.781Z` | POST | **200** | `http://dyxscx.yhs.data.sat.tax:8145/ajax.sword?ctrl=YxscxGyCtrl_getQueryData` | 最终 `200`  |
| 272 | `2026-08-12T01:26:17.019Z` | POST | **200** | `http://dyxscx.yhs.data.sat.tax:8145/ajax.sword?ctrl=YxscxGyCtrl_getQueryData` | 最终 `200`  |
| 273 | `2026-08-12T01:26:17.032Z` | POST | **200** | `http://dyxscx.yhs.data.sat.tax:8145/ajax.sword?ctrl=YxscxGyCtrl_getQueryData` | 最终 `200`  |
| 274 | `2026-08-12T01:26:17.045Z` | POST | **200** | `http://dyxscx.yhs.data.sat.tax:8145/ajax.sword?ctrl=YxscxGyCtrl_getQueryData` | 最终 `200`  |
| 275 | `2026-08-12T01:26:17.057Z` | POST | **200** | `http://dyxscx.yhs.data.sat.tax:8145/ajax.sword?ctrl=YxscxGyCtrl_getQueryData` | 最终 `200`  |
| 276 | `2026-08-12T01:26:17.066Z` | POST | **200** | `http://dyxscx.yhs.data.sat.tax:8145/ajax.sword?ctrl=YxscxGyCtrl_getQueryData` | 最终 `200`  |
| 277 | `2026-08-12T01:26:23.023Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/yhscx/dhcx/dhcx009/dhcx009017/img/up.png` | 最终 `200`  |
| 278 | `2026-08-12T01:26:23.024Z` | GET | **200** | `http://dyxscx.yhs.data.sat.tax:8145/yxscx/yhscx/dhcx/dhcx009/dhcx009017/img/down.png` | 最终 `200`  |
| 279 | `2026-08-12T01:26:48.115Z` | GET | **200** | `http://portal.zjsw.tax.cn/layout/layout1/blue/box_img/tab_bg.png` | 最终 `200` OK |

</details>

## 十二、证据边界

本结论严格区分事实与推断：HAR 直接证明 Cookie 是否发送、Set-Cookie 属性、Redirect Location、ticket 是否存在、参数被破坏和最终500；但 HAR 不包含 Chrome cookie blocked reason、浏览器第三方 Cookie 设置、CAS 后端校验请求、负载均衡节点信息或服务端异常栈。因此，SameSite与显式第三方 Cookie 阻止的最终二选一需用 T2/T3 补证；500 的具体 Java 异常类需查业务服务日志。现有证据已经足以排除 CORS/OPTIONS 和 SSO域 Cookie 丢失，并把问题定位到“跨站 iframe 业务会话不连续 + 服务端重试URL编码缺陷”这一连续链路。
