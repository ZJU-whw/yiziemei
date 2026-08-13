# Chrome 98 二次验证 HAR 分析与后续客户端兼容方案

> 分析对象：`js-500.har`、`js-OK.har`、`js-ver98.har`、`js-ver98-2.har`、`js-ver98-ok.har`。本文只引用 HAR 中可验证的网络事实；Cookie 值、ticket、身份标识和纳税人信息均不完整展示。

## 一、结论摘要

本次 Chrome 98 测试已经证明：

1. `LegacySameSiteCookieBehaviorEnabledForDomainList=[*.]sat.tax` 与 `BlockThirdPartyCookies=0` 已经消除了原先 HTTP 500 的直接触发链路。
2. Chrome 现在能够在 CAS ticket 回调业务系统时携带同一个业务 `JSESSIONID`，不再发生会话反复重建、第二轮 CAS、`ec1=0001` 和最终 500。
3. 当前“出现用户身份选择页”的直接网络表现是：跨站 iframe 中从业务站发起的 `POST /js_sso_server/chooseIdentify` 没有携带任何 SSO Cookie，随后被重定向到统一身份平台 `changeIdentity` 页面。
4. `js-ver98-2.har` 证明，顶层访问并没有重新登录或重新建立业务会话；它直接复用了第一次 iframe 流程已经建立的 `JSESSIONID`、`_cookie_user_name` 和 `_session_is_expired_`，然后返回完整的一户式页面。
5. 因而“顶层访问后恢复”至少包含一个重要因素：第一次 iframe 流程已完成会话初始化，但没有再次加载业务 URL；顶层访问相当于用刚建立好的身份状态发起第二次业务请求。
6. 当前 Legacy SameSite 域名单只包含 `[*.]sat.tax`，没有覆盖 `dddl.zjsw.tax.cn` 及可能设置为 `Domain=.tax.cn` 的 SSO Cookie。建议下一步受控测试增加 `[*.]tax.cn`。
7. `js-ver98-ok.har` 中没有任何 `dyxscx.yhs.data.sat.tax` 请求，它记录的是 `cktsqd.zjsw.tax.cn` 的另一条业务链路，因此不能直接证明第 4 步的一户式 iframe 网络请求已经成功，建议重新抓取。

## 二、`js-500.har` 与 `js-ver98.har` 的逐跳差异

### 2.1 原异常链路：`js-500.har`

| 请求序号 | 请求 | 状态 | 关键事实 |
|---|---|---:|---|
| #2 | `GET http://dyxscx.yhs.data.sat.tax:8145/sword?...` | 302 | 首次进入业务系统；请求 Cookie 完全为空；响应设置 `refer`、`JSESSIONID`、`header_referer`、`sj_sso_name`，然后跳 SSO |
| #4～#6 | `dddl.zjsw.tax.cn/js_sso_server...` | 302 | SSO Cookie 正常发送；#6 产生第一张 CAS ticket |
| #7 | `GET /sword?sso_paragram=...&ticket=...` | 302 | ticket 首次提交业务系统，但请求 Cookie 仍为空；业务系统重新设置一个不同的 `JSESSIONID`，并转到 `ec1=0001` |
| #8 | `GET /sword?sso_paragram=...&ec1=0001` | 302 | Cookie 仍为空；又生成新的 `JSESSIONID`，进入第二轮 CAS |
| #9～#11 | 第二轮 SSO | 302 | #11 产生第二张 ticket；回调 URL 中存在字面量 `amp;ec1` |
| #12 | 第二张 ticket 回调 `/sword?...&amp;ec1=...&ticket=...` | 500 | 请求 Cookie 仍为空；Tomcat 返回“HTTP状态 500 - 内部服务器错误” |

异常链路中，业务域响应下发的 `JSESSIONID` 从未在后续业务请求中被发送。每一次业务请求都进入新的会话，最终使 ticket 校验/重试链路失控。

### 2.2 当前链路：`js-ver98.har`

| 请求序号 | 请求 | 状态 | 关键事实 |
|---|---|---:|---|
| #2 | `GET http://dyxscx.yhs.data.sat.tax:8145/sword?...` | 302 | 已携带 `header_referer`、`sj_sso_name`；响应设置 `refer` 和业务 `JSESSIONID`，跳 SSO |
| #4～#6 | `dddl.zjsw.tax.cn/js_sso_server...` | 302 | SSO Cookie 正常发送；#6 产生一张 ticket |
| #7 | `GET /sword?sso_paragram=...&ticket=...` | 302 | 携带 `header_referer`、`sj_sso_name`、`refer` 和与 #2 相同的 `JSESSIONID`；ticket 被接受，直接重定向回原始业务 URL |
| #8 | 原始业务 `/sword?ctrl=YhscxCtrl_openDhcxTabPage...` | 200 | 仍携带同一个 `JSESSIONID`；响应设置 `_session_is_expired_=true` 和非空 `_cookie_user_name` |
| #9 | `POST http://dddl.zjsw.tax.cn/js_sso_server/chooseIdentify` | 302 | `Origin` 为业务域；Cookie 完全为空；`log_ticket` 为空；跳转到 `tpass.zjsw.tax/.../changeIdentity` |
| #10 | `GET http://tpass.zjsw.tax/.../changeIdentity` | 302 | 再跳到 `tpass.zjsw.tax.cn/changeIdentity.html` |
| #11～#21 | 身份选择页面资源 | 200 | 加载统一身份选择页面的 CSS/JS；没有业务 500 |

### 2.3 核心对照

| 对比项 | `js-500.har` | `js-ver98.har` |
|---|---|---|
| 浏览器 UA | Chrome 98 | Chrome 98 |
| ticket 回调是否发送业务 Cookie | 否 | 是 |
| `JSESSIONID` 是否连续 | 否，每跳都重新生成 | 是，#2、#7、#8 为同一值 |
| ticket 是否被接受 | 否，进入 `ec1=0001` | 是，返回原始业务 URL |
| CAS轮数 | 两轮 | 一轮 |
| 是否出现 `amp;ec1` | 是 | 否 |
| 业务最终状态 | 500 | 200 后进入身份选择流程 |

由此可以判定：`[*.]sat.tax` 的 Legacy SameSite 回退已经修复原始 500 的关键 Cookie 连续性问题。User-Agent、Accept、Accept-Language 等请求头在两个 Chrome 98 HAR 中没有能解释结果差异的变化。

## 三、当前身份选择页的具体原因

`js-ver98.har` #9 是当前最关键的请求：

```text
POST http://dddl.zjsw.tax.cn/js_sso_server/chooseIdentify
HTTP 302
Origin:  http://dyxscx.yhs.data.sat.tax:8145
Referer: http://dyxscx.yhs.data.sat.tax:8145/
Cookie:  空
```

表单中：

```text
service         存在
swrysfdm        存在
header_referer  存在
log_ticket      空
```

响应位置：

```text
http://tpass.zjsw.tax/api/v1.0/authtax/oauth2/changeIdentity?...
→ http://tpass.zjsw.tax.cn/changeIdentity.html?...
```

这表明业务系统不是返回了错误页面，而是主动向 SSO 提交身份确认请求。该请求没有携带 `CASTGC`、SSO `JSESSIONID`、`_idnetify_key_`、`sso_cookie_uid` 等既有 SSO Cookie，因此 SSO 没有直接确认当前身份，而是转入统一身份选择页面。

这与“允许第三方 Cookie”不是完全相同的问题。`BlockThirdPartyCookies=0` 解决内容设置层的第三方 Cookie 阻止；没有声明 SameSite 的 Cookie 在 Chrome 80+ 中仍可能按 `SameSite=Lax` 处理。当前旧 SameSite域名单只覆盖 `sat.tax`，并未覆盖 SSO Cookie 所属的 `tax.cn`。

## 四、为什么顶层窗口访问后能正常显示

`js-ver98-2.har` 的核心请求为：

```text
GET http://dyxscx.yhs.data.sat.tax:8145/sword?...
HTTP 200
Content-Type: text/html;charset=UTF-8
页面标题: 一户式查询基本信息
```

请求携带六类业务 Cookie：

```text
header_referer
sj_sso_name
refer
JSESSIONID
_session_is_expired_
_cookie_user_name
```

其中：

- `JSESSIONID` 与 `js-ver98.har` #2 创建、#7/#8 使用的是同一个值；
- `_session_is_expired_` 和 `_cookie_user_name` 正是 `js-ver98.har` #8 刚刚设置的；
- 顶层请求没有重新访问 CAS；
- 没有新 ticket；
- 没有创建新的 `JSESSIONID`；
- 请求直接返回完整的一户式页面。

因此，HAR 不支持“顶层窗口重新完成了一次登录”的解释。更准确的解释是：

> 第一次 iframe 流程已经完成 CAS 与业务会话初始化，并下发了业务身份 Cookie；顶层访问只是带着这些已经建立的 Cookie 再请求一次原始业务 URL。

目前尚不能证明一定要顶层窗口才能成功。关闭身份页后再次点击、直接刷新 iframe，可能同样会利用刚建立的 `_cookie_user_name` 和 `_session_is_expired_` 返回完整业务页面。

另需注意，`js-ver98.har` #8 与 `js-ver98-2.har` 的业务主体参数相同，但动态 `baseuuid/rUUID` 不同，因此两个 URL 不是逐字节完全一致；这不影响 Cookie 连续性的结论，但后续测试应尽量固定业务对象和操作步骤。

## 五、`js-ver98-ok.har` 的有效信息与证据边界

`js-ver98-ok.har` 中的主机统计为：

```text
tpass.zjsw.tax.cn   26 次
cktsqd.zjsw.tax.cn   8 次
dddl.zjsw.tax.cn     7 次
portal.zjsw.tax.cn   3 次
tpass.zjsw.tax       1 次
dyxscx.yhs.data.sat.tax 0 次
```

因此该文件没有记录第 4 步所述的一户式 `dyxscx...` 请求，不能用于比较“预热后的一户式 iframe 请求携带了哪些 Cookie”。它记录的是 `cktsqd.zjsw.tax.cn` 的另一条业务认证链路。

但它提供了一个重要同站对照。#40 同样请求：

```text
POST http://dddl.zjsw.tax.cn/js_sso_server/chooseIdentify
Origin: http://cktsqd.zjsw.tax.cn
```

该请求携带：

```text
CASTGC
JSESSIONID
_idnetify_url_key_
header_referer（两个作用域）
_cookie_login_origin
_idnetify_key_
sso_cookie_logid
sso_cookie_uid
```

随后直接返回 `cktsqd.zjsw.tax.cn`，并携带脱敏后的 `identifyd` 等身份参数。

对比：

- 从 `dyxscx...sat.tax` 发起的 `chooseIdentify`：Cookie 为零，跳 `changeIdentity`；
- 从 `cktsqd.zjsw.tax.cn` 发起的 `chooseIdentify`：携带九项 SSO Cookie，直接回业务系统。

虽然二者不是同一个业务应用，但这是“剩余身份选择现象与跨站 SSO Cookie 缺失有关”的强支持证据。

## 六、请求参数不完全一致带来的混杂因素

昨日与今日 HAR 并不是同一组完整业务参数：

- 纳税人和税务机关参数不同；
- `js-500.har` 中 `swryDm`、`swryxm` 有值；
- `js-ver98.har` 中 `swryDm`、`swryxm` 为空；
- 动态 UUID 不同。

因此，今天出现身份选择页面也可能部分受到“入口 URL 没有明确操作人员身份”的影响。下一轮应固定同一纳税人、同一操作人员身份，分别测试 `swryDm/swryxm` 非空与为空，避免把业务身份选择逻辑误判为浏览器 Cookie 问题。

## 七、建议的 Chrome 98 参数调整

### 7.1 下一步首选配置

保留当前：

```text
LegacySameSiteCookieBehaviorEnabledForDomainList:
  [*.]sat.tax

BlockThirdPartyCookies:
  0
```

增加：

```text
[*.]tax.cn
```

Windows 注册表示例：

```bat
reg add "HKLM\SOFTWARE\Policies\Google\Chrome\LegacySameSiteCookieBehaviorEnabledForDomainList" ^
 /v 2 /t REG_SZ /d "[*.]tax.cn" /f
```

调整后的域名单应为：

```text
[*.]sat.tax
[*.]tax.cn
```

原因：

- `[*.]sat.tax` 覆盖业务域 Cookie；
- `[*.]tax.cn` 覆盖 portal、`dddl.zjsw.tax.cn`、`tpass.zjsw.tax.cn`，以及可能设置为 `Domain=.tax.cn` 的 Cookie；
- Legacy SameSite 域名单按 Cookie 的 Domain/host 匹配，不能填写 scheme 或端口。

不要直接增加 `[*.]tax`，范围过宽。如果加入 `[*.]tax.cn` 后，链路仍在 `tpass.zjsw.tax` 这个不带 `.cn` 的中间节点丢失必要 Cookie，再单独增加并测试：

```text
tpass.zjsw.tax
```

每次只增加一项，避免无法判断具体生效项。

### 7.2 暂时不要调整的项目

- 不要修改 `Origin`、`Referer` 或 User-Agent；HAR 没有证据表明这些是当前故障点。
- 不要增加 CORS 放行或模拟 OPTIONS；本链路没有 OPTIONS 请求和 CORS 失败。
- 不要手工复制 ticket、Cookie 或身份值。
- 不要全局禁用 Web 安全、站点隔离或证书检查。

### 7.3 策略应用检查

1. 在 `chrome://policy` 点击“重新加载政策”。
2. 确认域名单状态为 OK，且显示两项域名。
3. 完全关闭所有 Chrome 进程后重新启动。
4. 使用普通窗口，不使用无痕窗口。
5. 使用独立测试用户数据目录或清理相关站点 Cookie后重新登录。

## 八、最小化验证矩阵

### 测试 A：验证是否只需要第二次 iframe 请求

保持当前策略，不顶层访问：

1. 第一次点击一户式，出现身份选择页；
2. 不进行身份选择；
3. 关闭当前 iframe 业务标签；
4. 再次点击同一一户式功能；
5. 导出第二次点击的完整 HAR。

若第二次直接成功并发送六项业务 Cookie，说明主要问题是首次会话初始化后缺少业务重试，不一定要求顶层窗口。

### 测试 B：验证 `[*.]tax.cn`

使用全新会话，配置：

```text
[*.]sat.tax
[*.]tax.cn
BlockThirdPartyCookies=0
```

首次只点击一次。重点检查：

```text
POST http://dddl.zjsw.tax.cn/js_sso_server/chooseIdentify
```

是否开始携带 `CASTGC`、SSO `JSESSIONID`、`_idnetify_key_`、`sso_cookie_uid` 等 Cookie。

如果该 POST 携带 SSO Cookie后直接返回业务站、不再跳 `changeIdentity`，即可确认剩余问题是 SSO域未被 Legacy SameSite 策略覆盖。

### 测试 C：区分顶层上下文与“第二次请求”

分别使用干净会话测试：

1. iframe 首次出现身份页后，直接刷新 iframe；
2. iframe 首次出现身份页后，关闭并再次点击；
3. iframe 首次出现身份页后，顶层打开完整业务 URL；
4. 全新会话直接顶层打开完整业务 URL。

判定方法：

- 1、2、3 均成功：核心是首次会话初始化后需要再请求一次；
- 只有 3、4 成功：顶层浏览上下文是必要条件；
- 加入 `[*.]tax.cn` 后首次点击成功：SSO Cookie的 SameSite覆盖是主要剩余因素。

### 测试 D：固定身份和业务对象

使用同一纳税人、同一登录人员，分别测试：

```text
swryDm/swryxm 非空
swryDm/swryxm 为空
```

若只有空值进入身份选择页，则需要把“入口身份参数缺失”列为业务逻辑主因，而不是继续扩大浏览器兼容策略。

### 测试 E：重新抓取第 4 步

DevTools Network需：

- 勾选 Preserve log；
- 从点击 portal功能之前开始记录；
- 确认 Network中实际出现 `dyxscx.yhs.data.sat.tax`；
- 等一户式页面及主要资源加载完成后再导出；
- 导出时包含响应内容；
- 同时保存 `chrome://policy` 状态和 Network Cookies 面板中的 blocked reason。

## 九、可能性评级

| 可能性 | 评级 | 支持证据 | 反对/限制证据 |
|---|---:|---|---|
| 原 500由业务 Cookie/SameSite 丢失触发 | 极高，已基本证实 | `js-500` ticket回调无 Cookie；`js-ver98` 携带同一 `JSESSIONID` 后不再500 | 无实质反证 |
| 当前身份页由 SSO域未加入 Legacy SameSite名单触发 | 高 | `js-ver98` #9 Cookie为零；`js-ver98-ok` #40 对应请求带九项SSO Cookie并直接回业务站 | #4～#6 的SSO GET仍能发送Cookie；两个 `chooseIdentify` 来自不同业务域 |
| 首次业务会话初始化后缺少一次业务重载 | 高 | #8 设置身份Cookie；顶层请求复用同一会话直接200且没有重新CAS | 两次请求间隔约6分钟，HAR不能排除期间存在未记录的人工操作或服务端状态变化 |
| 入口操作人员参数为空导致身份确认 | 中 | 今日 `swryDm/swryxm` 为空，且不是昨日同一业务对象 | #8 已从SSO获得并设置非空 `_cookie_user_name` |
| 第三方 Cookie总开关仍在阻止 | 低 | 当前已配置为0，且业务 `JSESSIONID` 已连续发送 | #9仍无 Cookie，说明 SameSite或请求上下文仍可能单独限制 |
| CORS/OPTIONS | 极低 | HAR中无OPTIONS和CORS报错；均为页面导航GET/表单POST | 无支持证据 |
| User-Agent/Accept差异 | 极低 | 两份Chrome HAR均为Chrome 98且主要请求头一致 | 无支持证据 |

## 十、CEF3 / Chromium 139 在 x86、ARM 信创终端的方案

### 10.1 版本边界

Chrome官方当前标注 `LegacySameSiteCookieBehaviorEnabledForDomainList` 支持 Chrome 79～131。CEF/Chromium 139不能把该策略作为可持续方案。

Cookie SameSite判断属于 Chromium网络栈行为，x86、ARM下逻辑相同。CPU架构不是该问题的影响变量；真正需要保证的是所有浏览窗口共享同一 Cookie存储和 RequestContext。

### 10.2 推荐的 CEF 139 实现

1. portal、业务站、SSO、身份页和临时顶层窗口全部使用同一个持久化 `CefRequestContext`。
2. 配置统一的 `cache_path`，不要为不同窗口或 iframe创建相互隔离的 RequestContext。
3. 如需要跨浏览器重启保留会话，可设置 `persist_session_cookies=1`；只要求同一次运行期间共享则不是必须。
4. 保存本次业务入口的原始 URL，但不要持久化、打印或上传其中的身份参数和动态 ticket。
5. 检测第一次业务流程是否已经建立：
   - 业务 `JSESSIONID` 存在；
   - `_cookie_user_name` 存在；
   - `_session_is_expired_` 存在；
   - ticket回调没有进入 `ec1=0001`。
6. 若满足上述条件但页面转向 `changeIdentity`，在同一 RequestContext 中对原始业务 URL执行一次受控重载。
7. 必须设置单次重试标记，防止业务异常时形成无限导航循环。
8. 若存在多个可选身份，只有确认 `_cookie_user_name` 与当前 portal登录人员一致时才能自动重载；否则必须显示身份选择页面，避免身份串用。
9. 如果 iframe重载仍失败，则在同一 RequestContext中建立临时顶层 CEF Browser完成初始化，成功后再把业务 URL加载回 iframe。

建议状态机：

```text
portal点击
  → iframe首次业务请求
  → CAS回调成功且业务身份Cookie已建立？
      ├─ 否：按正常SSO流程处理/报告失败
      └─ 是：业务页面是否完整？
          ├─ 是：结束
          └─ 否且进入changeIdentity：同一RequestContext重载原URL一次
               ├─ 成功：结束
               └─ 失败：临时顶层窗口完成初始化或显示身份选择
```

### 10.3 不建议的 CEF做法

- 不依赖 `--disable-features=SameSiteByDefaultCookies,...`；这类旧回退开关在 Chrome 94以后已不是可靠方案。
- 不在 `OnBeforeResourceLoad` 中伪造 `Cookie` 请求头；Chromium网络层仍可能重新执行 Cookie校验，而且容易产生账号串用和敏感信息泄漏。
- 不从360浏览器复制 Cookie到 CEF。
- 不为每个 Browser创建独立 RequestContext。
- 不全局禁用 Web Security、站点隔离或证书校验。

如果 CEF 139必须在 iframe中完全模拟旧版 Cookie行为，最终技术手段只能是维护一个作用域严格限定于内部域名的 Chromium/CEF网络栈补丁。该方案需要长期跟随 Chromium升级和安全审计，维护成本明显高于“共享RequestContext + 单次业务重载/顶层预热”，不建议优先采用。

## 十一、最终建议

### Chrome 98

首先进行两项测试：

1. 保持当前策略，首次出现身份页后不顶层访问，直接关闭/刷新并第二次打开 iframe；
2. 在全新会话中把 Legacy SameSite域名单扩展为 `[*.]sat.tax` 和 `[*.]tax.cn`，检查 `chooseIdentify` POST是否开始发送SSO Cookie。

若第1项成功，客户端可以采用“一次受控重试”解决首次会话初始化问题；若第2项使首次访问直接成功，则应采用两域名单配置。

### CEF 139 / 信创 x86、ARM

不能继续依赖只支持到 Chrome 131的 Legacy SameSite企业策略。应采用：

```text
统一持久化 CefRequestContext
+ 同一 CookieManager
+ 首次流程状态检测
+ 单次业务URL重载
+ 必要时同RequestContext顶层预热
```

### 证据边界

目前可以确定原500已被业务 Cookie连续性修复；当前最可能是 SSO `chooseIdentify` 跨站 POST丢 Cookie与首次业务身份初始化两个因素共同作用。由于 `js-ver98-ok.har` 未包含 `dyxscx...` 请求，最终确认仍需要重新抓取一次“顶层预热后重新打开一户式 iframe”的完整 HAR。

## 十二、官方参考

- [Chrome Enterprise：LegacySameSiteCookieBehaviorEnabledForDomainList](https://chromeenterprise.google/policies/legacy-same-site-cookie-behavior-enabled-for-domain-list/)：策略语义、域名匹配方式和 Chrome 79～131支持范围。
- [Chrome Enterprise：CookiesAllowedForUrls](https://chromeenterprise.google/policies/cookies-allowed-for-urls/)：按站点允许 Cookie及定向第三方 Cookie例外。
- [Chrome Enterprise：策略 URL Pattern格式](https://chromeenterprise.google/policies/url-patterns/)：策略域名/URL模式格式。
- [Chromium：Cookie Legacy SameSite Policies](https://chromium.googlesource.com/website/+/refs/heads/main/site/administrators/policy-list-3/cookie-legacy-samesite-policies/index.md)：旧SameSite兼容策略说明和生命周期记录。
- [CEF 139：`cef_settings_t`](https://cef-builds.spotifycdn.com/docs/139.0/structcef__settings__t.html)：`cache_path`、`persist_session_cookies`、命令行参数开关等配置定义。
