# Chrome 88+ 客户端兼容方案：在不修改第三方服务的前提下恢复业务访问

> 本文承接 `result.md` 的 HAR 结论。目标是在无法修改第三方站点、Cookie 属性和 CAS 服务的情况下，让 Chrome 尽可能获得与 360 税务专版相同的访问效果。本文中的策略名称、版本边界和行为另经 Chrome/Chromium 官方资料核对；实际域名及链路证据仍以两个 HAR 为准。

## 一、直接结论

针对题述 **Chrome 98 / Windows 7**，客户端首选方案是：

1. 通过 Chrome 企业策略 `LegacySameSiteCookieBehaviorEnabledForDomainList`，仅对业务 Cookie 所属域 `sat.tax`（建议值 `[*.]sat.tax`）启用旧 SameSite 行为；
2. 确认没有启用全局第三方 Cookie 阻止；如有，则再通过 `CookiesAllowedForUrls` 允许 `dyxscx.yhs.data.sat.tax` 在顶层站点 `portal.zjsw.tax.cn` 中使用 Cookie，或者至少把 `BlockThirdPartyCookies` 设为 `false` 做诊断；
3. 应用策略后完全退出 Chrome，重新启动，清除这三个站点的旧 Cookie并重新登录；
4. 在 `chrome://policy` 验证策略已生效，再以新 HAR 确认业务请求开始携带 `JSESSIONID` 等 Cookie。

对 Chrome 98 而言，**只允许第三方 Cookie可能仍不够**：HAR 中业务 Cookie没有 `SameSite`，Chrome 80+ 会默认按 `SameSite=Lax` 处理；跨站 iframe 中 Lax Cookie仍不会发送。因此“第三方 Cookie允许”和“旧 SameSite回退”是两层不同限制，Chrome 98 应先配置旧 SameSite域名单，再检查第三方 Cookie设置。

若无管理员权限或目标 Chrome 已不再支持旧 SameSite策略，客户端最可靠的绕行是：**不要把业务系统嵌入 portal 的 iframe，改成顶层标签页/独立窗口打开。** Lax Cookie允许跨站的顶层安全方法导航（本链路为 GET），而不允许跨站 iframe。此方案改变页面呈现方式，但不修改第三方服务，安全面也明显小于全局关闭浏览器保护。

## 二、为什么客户端方案必须同时处理两层限制

HAR 的异常链路由 `openXtgnToIframeTab` 发起：顶层站点是 `portal.zjsw.tax.cn`，子框架业务站点是 `dyxscx.yhs.data.sat.tax:8145`，二者不是同站。Chrome 异常 #2、#7、#8、#12 对业务域的请求都没有 Cookie；业务域每次下发新的 `JSESSIONID`，下一跳仍不发送。SSO 域 `dddl.zjsw.tax.cn` 的 `CASTGC`、SSO `JSESSIONID` 等则持续发送，且两次成功签发 ticket。

Chrome 官方说明：未声明 SameSite 的 Cookie从 Chrome 80起按 `SameSite=Lax` 处理；需要在第三方上下文发送的 Cookie通常必须是 `SameSite=None; Secure`。题述服务却使用 HTTP，且 `JSESSIONID/refer/header_referer/sj_sso_name` 都没有 SameSite和 Secure，故标准现代配置无法在跨站 iframe中使用这些 Cookie。[Chromium SameSite FAQ](https://www.chromium.org/updates/same-site/faq/)

这与用户设置的“阻止第三方 Cookie”并非同一开关：

- SameSite决定某个 Cookie自身是否允许随跨站请求发送；
- 第三方 Cookie设置/策略决定浏览器是否允许嵌入站点访问第三方 Cookie；
- 任意一层阻止，HAR 中最终都可能表现为业务请求没有 Cookie。

所以不能只做“设置 → 允许第三方 Cookie”便认定问题解决，必须以 Network 中 #7 后续是否携带同一个业务 `JSESSIONID`为验收标准。

## 三、方案一：Chrome 88～93/题述 Chrome 98 的企业域名单兼容

### 3.1 适用性与版本边界

Chrome为旧内部系统提供过两项企业回退策略：

- `LegacySameSiteCookieBehaviorEnabled`：全局回退；已在 Chrome 93移除，不推荐；
- `LegacySameSiteCookieBehaviorEnabledForDomainList`：只对指定 Cookie域回退，Chrome 98时期仍适用，应优先采用。

旧行为会把未声明 SameSite的 Cookie当成可跨站使用，并取消旧系统在 HTTP 下无法满足的 `SameSite=None` 必须配 `Secure` 的要求；Chromium官方还说明，从 Chrome 86起，此回退同时禁用匹配 Cookie的 Schemeful Same-Site行为。[Chromium Cookie Legacy SameSite Policies](https://www.chromium.org/administrators/policy-list-3/cookie-legacy-samesite-policies/)

重要边界：Chrome官方文档最后只承诺域名单策略至少保留至 **2025-01-07**，没有承诺在此后的所有 Chrome版本继续存在。因此：

- Chrome 98：可按本节配置；
- Chrome 88～93：也可按本节配置；
- 当前或未来新版 Chrome：先看 `chrome://policy` 是否识别该策略；若显示未知/未加载，不要继续依赖它，转用第五节“顶层窗口”方案。

### 3.2 为什么策略值必须包含 `[*.]sat.tax`

异常 HAR 中同时存在两类业务 Cookie：

- `refer/header_referer/sj_sso_name`：响应头明确指定 `Domain=sat.tax`；
- `JSESSIONID`：未指定 Domain，是 `dyxscx.yhs.data.sat.tax` 的 host-only Cookie。

Chromium官方要求旧 SameSite域名单匹配的是 **Cookie的Domain或设置该host-only Cookie的主机**，不是嵌入它的 portal域，也不能带 scheme/端口。因而最小且同时覆盖两类 Cookie的值是：

```text
[*.]sat.tax
```

不要写成以下形式：

```text
http://dyxscx.yhs.data.sat.tax:8145
portal.zjsw.tax.cn
```

前者错误地带了 scheme/端口；后者是顶层来源站点而不是业务 Cookie所属域。官方明确说明：该域名单不得写 scheme或端口，并应填写 Cookie被设置的域/主机。

### 3.3 Windows注册表配置（Chrome 98推荐）

需管理员权限。先关闭所有 Chrome进程，然后在提升权限的命令提示符运行：

```bat
reg add "HKLM\SOFTWARE\Policies\Google\Chrome\LegacySameSiteCookieBehaviorEnabledForDomainList" /v 1 /t REG_SZ /d "[*.]sat.tax" /f
```

如果单位只允许当前用户策略，也可尝试将 `HKLM` 改为 `HKCU`；最终是否加载必须以 `chrome://policy` 为准。域成员终端更推荐由管理员通过 Chrome ADMX/组策略集中下发：

```text
Google Chrome
  └─ Content settings
      └─ Revert to legacy SameSite behavior for cookies on these sites
          [*.]sat.tax
```

策略仅应覆盖 `sat.tax`，不要全局回退所有站点。全局回退扩大 CSRF和跨站跟踪风险，而且全局策略从 Chrome 93起已经移除。

### 3.4 检查并允许第三方 Cookie

先在普通窗口测试，不要用无痕窗口。Chrome官方说明 `BlockThirdPartyCookies=false` 允许第三方 Cookie，但该策略不适用于无痕模式；无痕模式仍会阻止，需站点级允许。[Chrome Enterprise：BlockThirdPartyCookies](https://chromeenterprise.google/policies/block-third-party-cookies/)

诊断时可临时执行：

```bat
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v BlockThirdPartyCookies /t REG_DWORD /d 0 /f
```

这会全局允许第三方 Cookie，范围较大，只适合作为快速验证或隔离专用浏览器配置。验证成功后，应优先换成定向的 `CookiesAllowedForUrls`。

对新版支持“第三方站点,顶层站点”二元匹配的 Chrome，可配置：

```bat
reg add "HKLM\SOFTWARE\Policies\Google\Chrome\CookiesAllowedForUrls" /v 1 /t REG_SZ /d "http://dyxscx.yhs.data.sat.tax:8145,http://portal.zjsw.tax.cn" /f
```

为了让 SSO/CAS在同一业务流程中不受站点级阻止，还可追加：

```bat
reg add "HKLM\SOFTWARE\Policies\Google\Chrome\CookiesAllowedForUrls" /v 2 /t REG_SZ /d "http://dddl.zjsw.tax.cn,http://portal.zjsw.tax.cn" /f
```

Chrome官方说明 `CookiesAllowedForUrls`支持“第三方URL,顶层URL”配对以定向允许第三方 Cookie；策略自 Chrome 11已存在，但配对语义是否被特定旧版本完整支持，应由 `chrome://policy`和实际 HAR验证。[Chrome Enterprise：CookiesAllowedForUrls](https://chromeenterprise.google/policies/cookies-allowed-for-urls/)

若 Chrome 98不接受上述二元模式，可退回单域允许：

```bat
reg add "HKLM\SOFTWARE\Policies\Google\Chrome\CookiesAllowedForUrls" /v 1 /t REG_SZ /d "http://dyxscx.yhs.data.sat.tax:8145" /f
reg add "HKLM\SOFTWARE\Policies\Google\Chrome\CookiesAllowedForUrls" /v 2 /t REG_SZ /d "http://dddl.zjsw.tax.cn" /f
```

注意：`CookiesAllowedForUrls`解决的是Cookie内容设置/第三方阻止，不能替代 `LegacySameSiteCookieBehaviorEnabledForDomainList` 对未声明 SameSite Cookie的兼容处理。

### 3.5 使策略和会话真正生效

1. 打开 `chrome://policy`，点击“重新加载政策”。
2. 确认 `LegacySameSiteCookieBehaviorEnabledForDomainList` 状态为“确定/OK”，值包含 `[*.]sat.tax`；确认 `BlockThirdPartyCookies=false`或 `CookiesAllowedForUrls`已加载。
3. 完全退出所有 Chrome窗口；任务管理器确认无 `chrome.exe`残留，再重启。
4. 清除以下三个站点的 Cookie，而不是清除全浏览器：
   - `portal.zjsw.tax.cn`
   - `dddl.zjsw.tax.cn`
   - `dyxscx.yhs.data.sat.tax`
5. 从 portal重新登录，重新点击功能。不要复用 HAR 中已有 ticket。
6. DevTools Network开启 Preserve log，导出一份新 HAR。

### 3.6 成功判据

必须同时满足：

- 首次业务 `/sword?ctrl=YhscxCtrl_openDhcxTabPage...` 携带业务 Cookie，或CAS回调后的下一次业务请求携带前一响应设置的同一个 `JSESSIONID`；
- 不再出现每次业务请求都产生新 `JSESSIONID`；
- 不再进入第二轮 `ec1=0001`重试；
- 不再出现 `amp;ec1`和最终500；
- 最终 `/sword` 返回200并继续加载业务资源。

如果策略显示已加载但业务请求仍无 Cookie，在 DevTools中选中请求 → Cookies，查看每个 Cookie的 blocked reason，并在 Console/Issues中确认究竟是 SameSite、第三方阻止还是其他企业策略。

## 四、仅适用于 Chrome 88～93 的临时启动参数

作为短期验证，可用独立测试配置启动旧版 Chrome：

```bat
"C:\Program Files\Google\Chrome\Application\chrome.exe" ^
  --user-data-dir="C:\ChromeTaxTest" ^
  --disable-features=SameSiteByDefaultCookies,CookiesWithoutSameSiteMustBeSecure
```

该方法有明确期限：

- `chrome://flags/#same-site-by-default-cookies` 和 `#cookies-without-same-site-must-be-secure` 从 Chrome 91起已删除；
- 上述命令行 `--disable-features` 从 Chrome 94起已删除；
- 因此它 **不适用于题述 Chrome 98**，也不应作为长期部署方案。[Chromium SameSite Updates](https://www.chromium.org/updates/same-site/)

独立 `--user-data-dir` 的目的是避免用弱化参数启动日常浏览配置。不要同时打开同一用户数据目录的普通 Chrome，也不要把该快捷方式用于互联网浏览。

## 五、方案二：改为顶层标签页/独立窗口打开（新版 Chrome首选绕行）

当旧 SameSite企业策略已从目标 Chrome移除、终端无管理员权限，或组织不接受降低 Cookie保护时，客户端侧最稳妥的方案是让业务系统成为地址栏中的顶层站点，而不是 portal iframe里的第三方站点。

Chrome官方定义中，`SameSite=Lax` Cookie可在跨站 **顶层导航 + 安全方法** 中发送；本业务入口是 GET。它不会在跨站 iframe中发送。[Chromium Cookie Legacy SameSite Policies](https://www.chromium.org/administrators/policy-list-3/cookie-legacy-samesite-policies/)

可按以下优先级实施：

1. 在 portal点击前按 `Ctrl`或中键，尝试“在新标签页中打开”；若元素不是链接，则右键检查是否有“新窗口打开”。
2. 从 DevTools Network复制首次业务请求 #2 的 Request URL，在点击业务的同一登录会话中立即粘贴到新标签页。URL含动态 `baseuuid/rUUID`和身份参数，不应分享、收藏或长期复用。
3. 若每次都要自动完成，可部署一个单位自有的、最小权限浏览器扩展/用户脚本，只拦截 portal内指向 `dyxscx.yhs.data.sat.tax:8145` 的 iframe导航并调用 `window.open(url, '_blank')`。扩展不得读取/导出 Cookie，也不应改写 ticket或响应头。
4. 如果工作流允许，先在顶层标签页访问业务域完成CAS/建立业务会话，再回 portal点击；但最终是否成功取决于业务Cookie是否在iframe中仍受Lax限制，因此不如“业务始终保持顶层”可靠。

限制：此方式无法保持“业务页面嵌在 portal标签页内”的界面效果，但能避开导致本次故障的第三方 iframe上下文，也不依赖已过渡期的旧策略。若业务页面强依赖 `window.parent`调用，可能需要单位自有扩展做极小的窗口适配；不能保证仅复制URL就覆盖所有交互。

## 六、方案三：隔离的兼容 Chrome 98 配置

如果业务必须维持 iframe形态，且 `LegacySameSiteCookieBehaviorEnabledForDomainList` 在 Chrome 98确实生效，建议建立专用 Windows账号或专用 Chrome配置，仅用于税务内网：

- 仅允许访问 `portal.zjsw.tax.cn`、`dddl.zjsw.tax.cn`、`dyxscx.yhs.data.sat.tax:8145`及其必要业务依赖；
- 只对 `[*.]sat.tax`回退旧 SameSite，不做全局回退；
- 如必须全局允许第三方 Cookie，仅在该隔离配置中实施；
- 禁用密码同步、个人账号登录和无关扩展；
- 使用操作系统/网络ACL限制互联网访问；
- 定期检查 `chrome://policy`和重新抓取最小 HAR。

这在效果上最接近360税务专版的“专用兼容浏览器”，同时把弱化安全策略限定在业务环境。Chrome 98和Windows 7本身都属于陈旧运行环境，不应承担普通互联网浏览。

## 七、不建议或无效的方法

| 方法 | 结论 | 原因 |
|---|---|---|
| Chrome 98中修改两个 SameSite flags | 无效 | 相关 `chrome://flags` 从 Chrome 91已删除。 |
| Chrome 98使用 `--disable-features=SameSiteByDefaultCookies,...` | 无效 | 命令行回退从 Chrome 94已删除。 |
| 只关闭“阻止第三方 Cookie” | 可能不够 | 未声明 SameSite的业务 Cookie仍按 Lax处理，iframe中仍可能不发。 |
| 无痕模式 | 不建议 | Chrome官方说明第三方 Cookie在无痕模式默认被阻止，`BlockThirdPartyCookies=false`也不适用于无痕。 |
| 扩展伪造/注入 `Cookie`请求头 | 不可行且危险 | Cookie是浏览器受保护请求头；强行处理易泄露会话，也无法可靠复制 HttpOnly会话语义。 |
| 从360导出 Cookie再导入Chrome | 不建议 | 会话敏感、可能绑定浏览器/IP/终端且会过期，存在账号劫持风险；也不能解决下一次 Set-Cookie仍被阻止。 |
| 手工修改最终URL中的 `&amp;` | 治标且通常无效 | 第二张 ticket通常一次性，且此前业务 JSESSIONID仍丢失；复制后可能已被消费。 |
| 安装随机“SameSite/CORS解除”扩展 | 不建议 | CORS不是本问题；扩展会获得高权限，存在凭证泄露风险。 |
| 禁用 Web 安全、站点隔离或证书校验 | 禁止 | 范围过大，且不针对已证实的 Cookie原因。 |
| 长期冻结 Chrome 98 | 不建议 | 只能维持兼容，无法获得安全更新；应使用隔离环境并推动供应商修复。 |

## 八、最小化验证矩阵

每次测试均清除三个站点Cookie、重新登录、只点击一次并导出 HAR；不要复用 ticket。

| 测试 | SameSite域名单 | 第三方Cookie | 打开方式 | 目的与预期 |
|---|---|---|---|---|
| A 基线 | 无 | 当前值 | iframe | 复现业务Cookie为空、两轮CAS、500。 |
| B 只允许第三方 | 无 | 允许 | iframe | 若仍失败，证明第三方开关不能越过SameSite=Lax。 |
| C 只回退SameSite | `[*.]sat.tax` | 当前值 | iframe | 若成功，说明当前未额外阻止第三方Cookie。 |
| D 两项同时 | `[*.]sat.tax` | 允许/定向例外 | iframe | Chrome 98推荐目标；应发送业务JSESSIONID并最终200。 |
| E 顶层窗口 | 无 | 当前值 | 顶层GET | 若成功，确认iframe第三方上下文是必要条件；适合作为新版Chrome长期客户端绕行。 |

若 D仍失败，按顺序检查：

1. `chrome://policy` 是否识别并加载两个策略；
2. 是否在普通窗口而非无痕窗口；
3. 业务请求 Cookies面板中的具体 blocked reason；
4. 是否有上级GPO、杀毒/上网行为管理软件或其他Chrome策略覆盖；
5. 是否清除了旧Cookie并重新建立了会话；
6. 业务 #7之后是否发送了与 #7响应同值的 `JSESSIONID`。

如果 D中 Cookie已连续发送，但仍出现 `ec1=0001`或500，则客户端 Cookie根因已排除，剩余是 `result.md` 已证实的服务端 ticket校验/URL编码缺陷，客户端不能可靠修复；只能采用顶层窗口绕过触发条件，或由第三方厂商修复。

## 九、推荐部署决策

### 对现有 Chrome 98终端

采用以下组合，最接近360税务专版：

```text
LegacySameSiteCookieBehaviorEnabledForDomainList = [*.]sat.tax
CookiesAllowedForUrls = 定向允许业务域（必要时包含SSO域）
普通窗口 + 专用Chrome配置/专用Windows账号
```

先在1台隔离测试机执行验证矩阵 D；新 HAR达到“业务JSESSIONID连续 + 最终200”后，再通过域组策略小范围灰度。不要先全单位下发全局第三方 Cookie允许。

### 对当前新版 Chrome终端

优先测试 `CookiesAllowedForUrls`的定向第三方 Cookie例外，但必须确认旧 SameSite域名单策略是否仍被该版本支持。若不支持，直接采用顶层标签页/独立窗口方案。不要依赖已经删除的 flags和命令行参数。

### 长期结论

纯客户端兼容只能是受控过渡措施。第三方服务目前使用“HTTP + 跨站 iframe + 无 SameSite/Secure的会话 Cookie”，与现代浏览器安全模型存在结构性冲突；服务端又会在失败重试中构造 `&amp;ec1`并导致500。客户端可以通过旧策略模拟360行为或通过顶层窗口避开 iframe，但无法永久保证所有未来 Chrome版本都维持旧 Cookie兼容能力。

## 十、官方依据

- [Chromium：Cookie Legacy SameSite Policies](https://www.chromium.org/administrators/policy-list-3/cookie-legacy-samesite-policies/)：旧 SameSite域名单的语义、域名匹配规则、Chrome 93全局策略移除和临时支持期限。
- [Chromium：SameSite Updates](https://www.chromium.org/updates/same-site/)：Chrome 91移除 flags、Chrome 94移除命令行回退。
- [Chromium：SameSite FAQ](https://www.chromium.org/updates/same-site/faq/)：无 SameSite按 Lax处理；跨站Cookie需要 `SameSite=None; Secure`；HTTP下的限制。
- [Chrome Enterprise：CookiesAllowedForUrls](https://chromeenterprise.google/policies/cookies-allowed-for-urls/)：按第三方站点/顶层站点定向允许 Cookie及 Windows注册表位置。
- [Chrome Enterprise：BlockThirdPartyCookies](https://chromeenterprise.google/policies/block-third-party-cookies/)：策略值、Windows注册表位置及无痕模式限制。

## 十一、国产信创 x86/ARM + CEF 139 编程实现

### 11.1 结论与推荐顺序

CEF 139 对应 Chromium 139，不能使用 Chrome 88～93时代的 SameSite flags或 Chrome 94以前的 `--disable-features`回退。对可修改客户端源码的信创应用，推荐顺序是：

1. **最佳架构：业务页面使用独立的 CEF Browser/main frame，作为原生子窗口嵌入业务区域。** 视觉上仍像 portal内的页签，但在 Chromium的 Cookie模型中，业务站点是该 WebContents的顶层站点，不是 portal iframe的第三方站点。
2. **如果必须保留网页 iframe：用 CEF 139的 `CefRequestContext::SetContentSetting`，对准确的“业务origin + portal顶层origin”设置 `LEGACY_COOKIE_ACCESS=ALLOW`和 `COOKIES=ALLOW`。** 这是 CEF 139中直接对应旧系统兼容需求的编程接口。
3. 所有 portal、业务、SSO浏览器实例必须共享同一个持久化 `CefRequestContext`，否则 Cookie仍会因为 Cookie store隔离而丢失。
4. `CefCookieManager`和 `CefCookieAccessFilter`用于观察、验证和限制，不作为绕过 SameSite的主方案。
5. 本机反向代理/完整自定义 ResourceHandler只能作为最后手段，因为需要重写 Location、Cookie域、绝对URL和CAS service，风险及维护成本很高。

CPU架构不改变 SameSite/Cookie语义。同一套 CEF C++逻辑适用于 x86_64、ARM64；差异集中在 CEF二进制、编译工具链、sandbox/GPU兼容和动态加载方式，而不是 HTTP认证代码。

### 11.2 CEF 139提供的关键能力

CEF 139官方 API枚举包含：

```cpp
CEF_CONTENT_SETTING_TYPE_COOKIES
CEF_CONTENT_SETTING_TYPE_LEGACY_COOKIE_ACCESS
```

其中 `LEGACY_COOKIE_ACCESS`的官方说明非常明确：启用旧 Cookie访问行为后，将同时关闭：

- 未声明 SameSite时默认按 Lax处理；
- `SameSite=None`必须同时设置 Secure；
- Schemeful Same-Site。

这会使未声明 SameSite的 Cookie按旧行为处理，并允许老式HTTP站点继续使用跨站Cookie。[CEF 139：Content Setting Types](https://cef-builds.spotifycdn.com/docs/139.0/cef__types__content__settings_8h.html)

`CefRequestContext::SetContentSetting`可按 requesting URL和top-level URL写入内容设置，必须在 browser process UI线程调用。官方同时警告：错误使用可能造成安全问题，因此必须按精确origin定向配置，不能设成全局默认。[CEF 139：CefRequestContext](https://cef-builds.spotifycdn.com/docs/139.0/classCefRequestContext.html)

### 11.3 方案A：CEF 139定向兼容设置

下面是原生 CEF C++示意代码。枚举名和方法来自 CEF 139；项目中应结合所用CEF API版本宏、智能指针和日志框架调整。

```cpp
#include "include/cef_request_context.h"
#include "include/cef_request_context_handler.h"
#include "include/internal/cef_types_content_settings.h"
#include "include/wrapper/cef_helpers.h"

namespace {
constexpr char kPortalOrigin[] = "http://portal.zjsw.tax.cn";
constexpr char kBusinessOrigin[] =
    "http://dyxscx.yhs.data.sat.tax:8145";
constexpr char kSsoOrigin[] = "http://dddl.zjsw.tax.cn";
}

class TaxRequestContextHandler : public CefRequestContextHandler {
 public:
  void OnRequestContextInitialized(
      CefRefPtr<CefRequestContext> context) override {
    CEF_REQUIRE_UI_THREAD();

    // 1. 仅在 portal 顶层页面嵌入业务域时恢复旧 SameSite 行为。
    context->SetContentSetting(
        kBusinessOrigin,
        kPortalOrigin,
        CEF_CONTENT_SETTING_TYPE_LEGACY_COOKIE_ACCESS,
        CEF_CONTENT_SETTING_VALUE_ALLOW);

    // 2. 定向允许 portal 顶层页面中的业务 Cookie。
    context->SetContentSetting(
        kBusinessOrigin,
        kPortalOrigin,
        CEF_CONTENT_SETTING_TYPE_COOKIES,
        CEF_CONTENT_SETTING_VALUE_ALLOW);

    // 3. SSO 在同一 iframe 重定向链中出现，也做精确例外。
    context->SetContentSetting(
        kSsoOrigin,
        kPortalOrigin,
        CEF_CONTENT_SETTING_TYPE_COOKIES,
        CEF_CONTENT_SETTING_VALUE_ALLOW);

    // 启动日志中读取并校验，防止静默失败。
    const auto legacy = context->GetContentSetting(
        kBusinessOrigin,
        kPortalOrigin,
        CEF_CONTENT_SETTING_TYPE_LEGACY_COOKIE_ACCESS);
    const auto cookies = context->GetContentSetting(
        kBusinessOrigin,
        kPortalOrigin,
        CEF_CONTENT_SETTING_TYPE_COOKIES);

    CHECK_EQ(legacy, CEF_CONTENT_SETTING_VALUE_ALLOW);
    CHECK_EQ(cookies, CEF_CONTENT_SETTING_VALUE_ALLOW);
  }

 private:
  IMPLEMENT_REFCOUNTING(TaxRequestContextHandler);
};
```

创建独立且持久化的 RequestContext：

```cpp
CefRequestContextSettings rc_settings;
rc_settings.cache_path = "/var/lib/tax-browser/profile";
rc_settings.persist_session_cookies = true;

auto tax_context = CefRequestContext::CreateContext(
    rc_settings, new TaxRequestContextHandler());

// portal Browser、业务 Browser、弹出的SSO窗口均传入同一个 tax_context。
CefBrowserHost::CreateBrowser(
    window_info, client, kPortalOrigin, browser_settings,
    /*extra_info=*/nullptr, tax_context);
```

实施注意点：

- `cache_path`必须是当前用户可写、每个应用实例独占的绝对路径；多进程不得同时用不兼容版本打开同一profile。
- `persist_session_cookies=true`不是解决单次重定向丢Cookie的必要条件，但对专用业务客户端重启后保持会话有用。若合规要求每次退出清会话，则设为false。
- `http/https/ws/wss`本来就是 CEF默认 cookieable schemes。`cookieable_schemes_list`无需增加 `http`，也不能解决 SameSite；错误设置 `cookieable_schemes_exclude_defaults=true`反而会禁用HTTP Cookie。[CEF 139：cef_settings_t](https://cef-builds.spotifycdn.com/docs/139.0/structcef__settings__t.html)
- content setting的具体primary/secondary scope最终以 `GetContentSetting`返回值和抓包为准。不要为了“确保有效”把 requesting/top-level URL都置空，因为那会对所有站点全局回退。
- 如果应用用的是 Alloy runtime和相关 content setting行为与Chrome runtime不同，必须在目标CEF 139发行包上执行第11.8节测试；不要假定普通Chrome注册表策略自动作用于CEF。

### 11.4 方案B：原生多Browser容器，彻底移除第三方iframe

这是面向 CEF 139和未来版本更稳健的设计。实现方式：

```text
原生信创客户端窗口
├─ 左侧/顶部：Portal CefBrowser（main frame = portal.zjsw.tax.cn）
└─ 业务页签：Business CefBrowser（main frame = dyxscx...sat.tax:8145）
                  └─ CAS重定向仍在该main frame中完成
```

虽然两个CEF Browser控件都嵌在同一个原生窗口中，但 Chromium会把每个 Browser/WebContents的main frame视为各自顶层站点。业务页面不再是 portal网页中的第三方iframe，未声明SameSite的 Lax Cookie可随顶层GET导航发送。

建议流程：

1. 在 portal Browser的 `CefRequestHandler::OnBeforeBrowse`或渲染进程桥接代码中识别目标主机 `dyxscx.yhs.data.sat.tax:8145`的子框架导航。
2. 仅当 URL来自受信任portal且目标主机、端口、scheme完全匹配白名单时，取消原iframe导航。
3. 创建/激活业务 Browser页签，并在它的main frame调用 `LoadURL(original_url)`。
4. 两个 Browser共享 `tax_context`，保证 portal和SSO Cookie store一致。
5. 业务 Browser内部允许CAS重定向自然进行，不要读取、缓存、拼接或复用 ticket。

示意伪代码：

```cpp
bool Client::OnBeforeBrowse(CefRefPtr<CefBrowser> browser,
                            CefRefPtr<CefFrame> frame,
                            CefRefPtr<CefRequest> request,
                            bool user_gesture,
                            bool is_redirect) {
  if (!frame->IsMain() && IsExactBusinessUrl(request->GetURL()) &&
      IsPortalMainFrame(browser->GetMainFrame()->GetURL())) {
    OpenBusinessNativeTab(request->GetURL(), shared_tax_context_);
    return true;  // 取消 portal 中的 iframe 导航。
  }
  return false;
}
```

真实工程中 `OpenBusinessNativeTab`应切回CEF UI线程执行；URL校验必须解析scheme/host/port，不得使用字符串前缀包含判断，防止 `dyxscx...attacker.example`之类绕过。

这个方案的优点：

- 不依赖 `LEGACY_COOKIE_ACCESS`将来是否保留；
- 不需要全局允许第三方 Cookie；
- 视觉上仍可作为应用内页签，不必打开外部浏览器；
- x86_64和ARM64逻辑完全一致。

可能限制：若业务JS必须访问 `window.parent`中的portal对象，多Browser后不再同一DOM树。应通过最小化的原生消息桥传递必要业务事件，禁止提供任意JS执行或Cookie读取能力。根据现有HAR，业务页面主要通过URL参数启动，尚无证据证明它必须调用portal父窗口，因此应先做PoC验证。

### 11.5 为什么几种看似可行的 CEF API不能单独解决

#### CefCookieAccessFilter

`CanSendCookie/CanSaveCookie`是过滤器：返回false可以进一步禁止，返回true只是允许符合 Chromium底层规则的 Cookie继续处理。它不是“强制发送被SameSite拒绝的Cookie”的旁路；被底层策略排除的 Cookie可能根本不会作为候选进入回调。[CEF 139：CefCookieAccessFilter](https://cef-builds.spotifycdn.com/docs/139.0/classCefCookieAccessFilter.html)

它适合做验证日志：仅记录 Cookie名称、domain、same_site、secure和是否主/子框架，严禁记录值。

#### CefCookieManager::SetCookie

CookieManager能显式设置 Cookie属性，也能访问HttpOnly Cookie，但直接把服务端Cookie改设为 `SameSite=None`仍受到 Chromium的 `None requires Secure`校验；本系统是HTTP，不能靠这一招独立解决。若先启用 `LEGACY_COOKIE_ACCESS`，CookieManager改写又变得多余。[CEF：CefCookieManager](https://cef-builds.spotifycdn.com/docs/125.0/classCefCookieManager.html)

更不能在客户端预置伪造的 `JSESSIONID`；服务器不认识该会话值，且CAS会话可能绑定服务端状态。

#### OnResourceResponse / ResponseFilter

CEF官方说明 `OnResourceResponse`收到的 response不能修改；`CefResponseFilter`用于响应正文过滤，不是修改响应头。因此不能在那里简单把 `Set-Cookie`改成另一个SameSite值。[CEF：CefResourceRequestHandler](https://cef-builds.spotifycdn.com/docs/121.2/classCefResourceRequestHandler.html)

若用 `GetResourceHandler`接管默认加载，就必须自己实现完整网络请求、重定向、Cookie、缓存、压缩、认证和错误处理，等同于在客户端内造代理，不应作为首选。

#### 手工添加 Cookie请求头

不建议在 `OnBeforeResourceLoad`中拼接 Cookie头。它会绕开正常Cookie隔离、安全审计和HttpOnly语义，容易把业务会话发给错误origin；还可能被network service重写。正确做法是修正 content setting/顶层上下文，让 Chromium cookie store自行发送。

### 11.6 针对最终 `&amp;ec1` 500的客户端兜底

只要业务 Cookie连续，HAR中的第二轮CAS和 `&amp;ec1`通常不会触发，所以应先解决会话连续性。若仍需保护用户体验，可在导航前做 **检测而非盲目修复**：

```cpp
if (IsBusinessMainFrame(request) &&
    HasQueryKey(request->GetURL(), "amp;ec1")) {
  LogSanitizedAuthLoop();
  ShowControlledErrorAndRestartLogin();
  return RV_CANCEL;
}
```

不要把 `amp;ec1`直接替换成 `ec1`后继续提交：ticket可能已被签发或消费，`sso_paragram`还丢失了Base64尾部 `=`；部分修复可能造成ticket重放或把错误状态带入业务服务。安全的客户端动作是终止异常链、清理该RequestContext中三个业务域的会话Cookie并重新登录，或提示使用业务main frame模式。

如果确需客户端修复错误Location，必须在封闭测试环境中通过完整自定义ResourceHandler/代理实现，并同时保证：

- 仅处理精确业务/SSO origin；
- 保留每一层percent-encoding和Base64 padding；
- 不记录ticket/Cookie值；
- 每张ticket只提交一次；
- 失败时fail closed，不回退到原始畸形URL。

这已经属于协议适配器，不是普通浏览器配置，必须经过第三方系统方书面确认和安全评审。

### 11.7 信创 x86/ARM 工程差异

#### 通用要求

- 固定并记录完整 CEF版本，例如 `139.0.1+... / Chromium 139.0.7258.31`，不能只写“CEF3”。
- CEF helper子进程、resources、locales、snapshot、sandbox文件必须与主 `libcef`/动态库同版本同架构。
- x86_64、ARM64分别构建安装包，禁止跨架构混用profile目录或子进程。
- UA伪装成Chrome 86/360不会改变 Cookie策略，不是解决方案。
- 不要设置 `no_sandbox=true`来解决Cookie问题；sandbox与SameSite无关。

CEF官方示例工程说明 Linux构建可使用与宿主匹配的x64、ARM或ARM64发行包；Windows也提供x64/ARM64构建入口。[CEF Project示例](https://github.com/chromiumembedded/cef-project/blob/master/README.md)

#### Linux ARM64特别检查

CEF项目曾记录 Linux ARM64在 CEF 129+中晚期 `dlopen(libcef.so)`可能报 `cannot allocate memory in static TLS block`。该问题与HTTP 500无关，但会影响信创ARM客户端能否启动。工程上应：

- 优先在进程启动早期加载/链接 `libcef.so`，避免业务框架加载大量库后才动态装入CEF；
- 对采用JCEF、CEF4Delphi或自研动态插件加载器的方案，在目标发行版/内核/glibc上先做启动压力测试；
- 不要用修改 `LD_PRELOAD`、禁用sandbox等方式掩盖问题；采用CEF 139对应修复版本和官方匹配发行包；
- 在鲲鹏、飞腾等不同ARM64平台分别验证，因为系统glibc和动态加载顺序可能不同。

参考：[CEF Issue #3803：Linux ARM64 static TLS](https://github.com/chromiumembedded/cef/issues/3803)。

### 11.8 CEF 139最小验收测试

构建四个开关组合，每组使用全新RequestContext `cache_path`，避免旧Cookie污染：

| 组 | 页面结构 | LEGACY_COOKIE_ACCESS | COOKIES例外 | 预期 |
|---|---|---|---|---|
| CEF-A | portal iframe | 无 | 无 | 复现业务Cookie为空和500。 |
| CEF-B | portal iframe | ALLOW | 无 | 判断是否还存在第三方Cookie内容设置阻止。 |
| CEF-C | portal iframe | ALLOW | 业务+SSO对portal定向ALLOW | 目标兼容态：业务JSESSIONID连续、最终200。 |
| CEF-D | 独立Business Browser main frame | 无 | 无/默认 | 推荐长期态：顶层GET链成功、最终200。 |

每组记录：

- `GetContentSetting`读取值；
- browser ID、frame ID、`frame->IsMain()`、request initiator（只记origin）；
- `CanSaveCookie/CanSendCookie`中 Cookie名称、domain、same_site、secure，不记值；
- DevTools Protocol或CEF日志导出的状态码和重定向目标，ticket脱敏；
- #7响应的业务JSESSIONID是否在下一次业务请求发送（只比较内存哈希，不落盘明文）。

验收条件与Chrome相同：首次业务请求或CAS回调后业务Cookie连续、只消费一张ticket、不产生第二轮 `ec1=0001`、不存在 `amp;ec1`、最终200。

如果 CEF-C成功而CEF-D失败，说明业务main frame适配存在应用逻辑问题；如果CEF-D成功而CEF-C失败，优先采用多Browser架构；如果两者都失败且Cookie已连续，则应回到服务端ticket校验/URL编码层排查，不能再归因于CPU或Chromium Cookie策略。
