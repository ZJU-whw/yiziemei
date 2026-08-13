# Chrome 98 完整验证 HAR 复核报告

> 本报告基于重新上传的完整 `js-ver98-ok.har`，并与 `js-500.har`、`js-OK.har`、`js-ver98.har`、`js-ver98-2.har` 联合对比。报告不完整展示 Cookie、ticket、身份信息、纳税人信息或动态会话值；相同值仅通过脱敏哈希一致性判断。

## 一、更新后的最终结论

完整 HAR 已经确认以下事实：

1. Chrome 98 配置 `LegacySameSiteCookieBehaviorEnabledForDomainList=[*.]sat.tax`、`BlockThirdPartyCookies=0` 后，原始 HTTP 500 链路已经被修复。
2. 原 500 的直接触发因素是业务域 Cookie在跨站 iframe中不连续：CAS ticket回调没有携带先前建立的业务 `JSESSIONID`，导致业务系统不断建立新会话、进入 `ec1=0001` 重试、生成第二张 ticket，并最终在异常参数链路中返回500。
3. 当前 Chrome 98 首次 iframe访问已经能够保持同一个业务 `JSESSIONID`，ticket只产生一次并被接受，因此不再出现 `ec1`、二次 CAS和500。
4. 首次 iframe访问随后出现身份选择，是一个新的后续阶段：业务系统已经返回200并设置 `_cookie_user_name`、`_session_is_expired_`，但从跨站业务 iframe提交到 `dddl.zjsw.tax.cn/chooseIdentify` 的 POST没有携带SSO Cookie，于是跳到统一身份平台 `changeIdentity`。
5. 顶层标签页访问没有重新走CAS，也没有创建新的业务 Cookie；它复用了首次 iframe流程已经建立的同一 `JSESSIONID`及身份Cookie，直接返回完整一户式页面。
6. 完整 `js-ver98-ok.har` 现在证明：再次从 portal iframe打开一户式时，入口请求 #79同样复用上述完整业务 Cookie集合，直接返回200，随后页面资源、菜单、纳税人信息和业务数据接口均正常加载。
7. 所以“顶层访问后 iframe恢复”的网络本质是业务会话已经被预热并保存在同一浏览器 Cookie存储中。当前证据没有显示顶层访问产生了新的认证凭据。
8. 仍需通过一个最小测试区分：是否只要在首次身份页后重新点击/刷新 iframe就能成功，还是顶层请求还改变了无法从HAR观察的业务服务端会话状态。

## 二、完整 `js-ver98-ok.har` 概况

重新上传的完整文件包含354条请求，时间范围为：

```text
2026-08-13T02:27:54.567Z
至
2026-08-13T02:28:20.799Z
```

状态码统计：

| 状态码 | 数量 |
|---:|---:|
| 200 | 343 |
| 302 | 10 |
| 404 | 1 |
| 301 | 0 |
| 401 | 0 |
| 403 | 0 |
| 500 | 0 |

主机分布：

| 主机 | 请求数 |
|---|---:|
| `dyxscx.yhs.data.sat.tax` | 275 |
| `cktsqd.zjsw.tax.cn` | 40 |
| `tpass.zjsw.tax.cn` | 26 |
| `dddl.zjsw.tax.cn` | 7 |
| `portal.zjsw.tax.cn` | 5 |
| `tpass.zjsw.tax` | 1 |

此前精简文件只保留到第45条，因此缺少真正的一户式入口及后续275条业务请求。完整文件消除了该证据缺口。

## 三、五份 HAR 的核心业务时间线

### 3.1 原异常：`js-500.har`

| 序号 | 请求 | 状态 | 关键事实 |
|---|---|---:|---|
| #2 | 首次 `GET dyxscx.../sword?ctrl=YhscxCtrl_openDhcxTabPage...` | 302 | Cookie为空；设置 `refer`、`JSESSIONID`、`header_referer`、`sj_sso_name` 后跳SSO |
| #4～#6 | `dddl.../js_sso_server` | 302 | SSO Cookie存在；#6产生第一张ticket |
| #7 | 第一张ticket回调业务 `/sword` | 302 | Cookie仍为空；重新创建不同 `JSESSIONID`；转到 `ec1=0001` |
| #8 | `/sword?...&ec1=0001` | 302 | Cookie仍为空；再次创建新 `JSESSIONID`；进入第二轮SSO |
| #9～#11 | 第二轮SSO | 302 | #11产生第二张ticket，回调参数中出现字面量 `amp;ec1` |
| #12 | 第二张ticket回调业务 `/sword` | 500 | Cookie仍为空；返回Tomcat内部服务器错误页 |

### 3.2 360正常基线：`js-OK.har`

360税务专版的首次业务入口 #2：

```text
GET dyxscx.../sword?ctrl=YhscxCtrl_openDhcxTabPage...
HTTP 200
```

请求携带：

```text
header_referer
sj_sso_name
refer
JSESSIONID
_session_is_expired_
_cookie_user_name
```

没有CAS重定向，直接返回“一户式查询基本信息”并继续加载业务资源。

### 3.3 Chrome 98首次 iframe：`js-ver98.har`

| 序号 | 请求 | 状态 | 关键事实 |
|---|---|---:|---|
| #2 | 首次业务 `/sword` | 302 | 已发送 `header_referer`、`sj_sso_name`；响应建立 `refer`和业务 `JSESSIONID` |
| #4～#6 | SSO/CAS | 302 | #6产生一张ticket |
| #7 | ticket回调业务 `/sword` | 302 | 发送 `header_referer`、`sj_sso_name`、`refer`、与#2相同的 `JSESSIONID`；ticket被接受 |
| #8 | 重定向回原始业务 URL | 200 | 使用同一 `JSESSIONID`；设置 `_session_is_expired_=true`及非空 `_cookie_user_name` |
| #9 | `POST dddl.../chooseIdentify` | 302 | `Origin`为`dyxscx...sat.tax`；Cookie完全为空；转`tpass.../changeIdentity` |
| #10～#21 | 身份选择页面 | 302/200 | 加载统一身份选择页面；无500 |

### 3.4 Chrome 98顶层访问：`js-ver98-2.har`

核心请求 #2：

```text
GET dyxscx.../sword?ctrl=YhscxCtrl_openDhcxTabPage...
HTTP 200
Referer: http://dyxscx.yhs.data.sat.tax:8145/
页面标题: 一户式查询基本信息
```

请求携带完整六类业务 Cookie，而且：

- `JSESSIONID` 与 `js-ver98.har` #2/#7/#8完全相同；
- `_cookie_user_name` 与 `js-ver98.har` #8设置的值相同；
- `_session_is_expired_` 与 #8设置的值相同；
- 没有CAS请求；
- 没有ticket；
- 没有新建 `JSESSIONID`。

### 3.5 Chrome 98再次 iframe：完整 `js-ver98-ok.har`

在 #78，portal先调用：

```text
POST http://portal.zjsw.tax.cn/ajax.sword...
HTTP 200
```

随后 #79 在 portal iframe中打开一户式：

```text
GET http://dyxscx.yhs.data.sat.tax:8145/sword?ctrl=YhscxCtrl_openDhcxTabPage...
HTTP 200
Referer: http://portal.zjsw.tax.cn/
Content-Type: text/html;charset=UTF-8
页面标题: 一户式查询基本信息
```

请求发送：

```text
header_referer
sj_sso_name
refer
JSESSIONID
_session_is_expired_
_cookie_user_name
```

这六项与 `js-ver98-2.har` 顶层成功请求的Cookie名称完全相同；脱敏哈希进一步确认：

- #79的 `JSESSIONID` 与 `js-ver98.har` #2/#7/#8、`js-ver98-2.har` #2相同；
- #79的 `_cookie_user_name` 与首次 iframe #8设置、顶层请求使用的值相同；
- #79的 `_session_is_expired_` 同样连续。

#79响应体大小与顶层成功响应一致：

```text
content.size = 18346
bodySize     = 5006
```

解析响应中的 `SwordPageData` 后，两次成功页面的业务字段结构和业务字段值一致，仅动态 `sessionID` 不同。这符合重新生成页面级会话标识的正常行为。

## 四、完整成功 iframe 的后续业务链路

`js-ver98-ok.har` 中 `dyxscx` 共275条请求：

| 方法 | 数量 |
|---|---:|
| GET | 264 |
| POST | 11 |

状态：

| 状态 | 数量 |
|---|---:|
| 200 | 274 |
| 404 | 1 |

唯一404是静态图片：

```text
GET /yhscx/common/img/line.png
HTTP 404
```

它没有阻断页面或数据接口，不属于认证问题。

主要动态请求如下：

| 序号 | 请求 | 状态 | 响应类型/作用 |
|---|---|---:|---|
| #79 | `GET /sword?ctrl=YhscxCtrl_openDhcxTabPage` | 200 | 一户式主页面 |
| #210 | `POST /ajax.sword?ctrl=DhcxCtrl_queryNsrxxByDjxh` | 200 | 纳税人信息JSON |
| #211 | `POST /ajax.sword?ctrl=DhcxCtrl_getMenu` | 200 | 菜单数据JSON |
| #212 | `GET /sword?ctrl=DhcxCtrl_loadPage` | 200 | 子页面，标题“出口退税概要信息” |
| #344 | `POST /ajax.sword?ctrl=YxscxGyCtrl_getYmsybz` | 200 | 业务JSON |
| #346 | `POST /ajax.sword?ctrl=YxscxGyCtrl_getQueryData` | 200 | 非空业务数据JSON |
| #347 | `POST /ajax.sword?ctrl=CktssbqkCtrl_queryCkqyznfxfx` | 200 | 非空业务数据JSON |
| #348～#353 | 多次 `YxscxGyCtrl_getQueryData` | 200 | 多组非空业务数据JSON |

这些动态请求均携带与 #79相同的六类业务 Cookie，包括同一业务 `JSESSIONID`。因此“页面外壳200但数据没有加载”的可能性已经被完整HAR排除：主页面、菜单、子页面和数据查询均成功。

## 五、#79之前的 SSO 链路不能解释为一户式重新认证

完整HAR在 #3～#77之间记录了 `cktsqd.zjsw.tax.cn` 业务及其SSO/tpass认证：

```text
cktsqd业务入口
→ dddl SSO
→ tpass登录
→ dddl登录回调
→ cktsqd ticket回调
→ chooseIdentify
→ cktsqd业务页面
```

该链路属于 `cktsqd.zjsw.tax.cn`，不是 `dyxscx.yhs.data.sat.tax`。

关键证据：

- `dyxscx`在 #79直接返回200；
- #79前没有面向 `dyxscx`的CAS ticket；
- #79继续使用九分钟前首次 iframe建立的业务 `JSESSIONID`；
- #79没有设置新的 `refer`或 `JSESSIONID`。

因此，不能把第4步成功解释成“重新进入门户后SSO又给一户式签发了新ticket”。实际是原业务会话继续有效。

`cktsqd`链路仍提供了一个有价值的对照：其 #40同样调用 `POST dddl.../chooseIdentify`，因为来源属于 `tax.cn`同站上下文，请求携带 `CASTGC`、SSO `JSESSIONID`、`_idnetify_key_`、`sso_cookie_logid`、`sso_cookie_uid` 等九项Cookie，并直接返回业务系统。`js-ver98.har` #9从跨站 `sat.tax`发起时Cookie为零并转到 `changeIdentity`。该差异继续支持SSO SameSite覆盖不完整的判断。

## 六、完整证据对根因判断的修正

### 6.1 原500根因：结论不变，置信度进一步提高

原500最可能根因仍是：

```text
跨站iframe
→ 业务域未声明SameSite的Cookie不发送
→ ticket回调无法复用业务JSESSIONID
→ 会话不断重建
→ ec1重试和第二张ticket
→ 异常参数/服务端异常处理返回500
```

`[*.]sat.tax` 策略实施后，ticket回调成功复用同一业务会话，整个500链路消失。这构成前后对照证据。

### 6.2 当前首次身份页：两个因素可能共同作用

因素一：跨站 `chooseIdentify` POST缺少SSO Cookie。

支持证据：

- `js-ver98.har` #9 Cookie完全为空；
- `log_ticket`为空；
- 响应转向 `changeIdentity`；
- `js-ver98-ok.har` #40的同站 `chooseIdentify` 携带九项SSO Cookie并直接回业务站。

因素二：首次业务会话初始化后，业务URL没有再请求一次。

支持证据：

- 首次 iframe #8已经设置 `_cookie_user_name`和 `_session_is_expired_`；
- 顶层请求携带这些Cookie后直接成功；
- 后续 iframe #79携带同一组Cookie也直接成功；
- 顶层与后续iframe均不需要新CAS或新ticket。

当前HAR无法完全区分：顶层成功是单纯“第二次请求”效果，还是顶层正常页面执行又修改了同一 `JSESSIONID`对应的服务端内部状态。需要专门的最小测试确认。

### 6.3 入口身份参数仍是混杂因素

今日请求中 `swryDm`、`swryxm` 为空，而昨日异常/360基线请求中这两个字段有值；业务对象也不同。因此身份选择页可能部分属于应用自身的身份确认逻辑。后续应使用同一业务对象和同一人员身份对照测试。

## 七、更新后的可能性评级

| 判断项 | 评级 | HAR支持证据 | 限制/反证 |
|---|---:|---|---|
| 原500由业务Cookie/SameSite会话断裂触发 | 极高，已基本证实 | 原回调无Cookie且连续新建会话；策略后同一 `JSESSIONID`贯穿并无500 | 无实质反证 |
| 顶层后iframe成功来自既有业务会话/Cookie预热 | 极高 | 顶层与#79使用首次iframe建立的同一 `JSESSIONID`及身份Cookie；#79无新CAS | 顶层页面可能还修改了不可见的服务端会话内部状态 |
| 首次身份页由 `chooseIdentify` 跨站POST缺SSO Cookie触发 | 高 | 跨站#9 Cookie为零并转身份页；同站#40带九项Cookie并直接返回 | 两个请求来自不同业务应用 |
| 只需第二次iframe请求，无需顶层访问 | 中高，待最小测试确认 | 首次#8已设置完整身份Cookie，后续#79直接成功 | 现有流程中间确实执行过一次顶层完整页面 |
| `swryDm/swryxm`为空触发身份确认 | 中 | 今日字段为空且出现身份页 | 会话预热后字段仍为空，但#79直接成功 |
| CORS/OPTIONS | 极低 | 全部HAR无OPTIONS、401、403及CORS错误 | 无支持证据 |
| User-Agent/Accept差异 | 极低 | Chrome异常和验证HAR使用相同Chrome 98 UA及主要请求头 | 无支持证据 |

## 八、Chrome 98后续参数调整建议

### 8.1 当前配置应保留

```text
LegacySameSiteCookieBehaviorEnabledForDomainList:
  [*.]sat.tax

BlockThirdPartyCookies:
  0
```

该组合已经被HAR证明可以消除500并保持业务会话。

### 8.2 是否增加 `[*.]tax.cn`

如果目标是让全新会话第一次点击就不出现身份选择，可以受控增加：

```text
[*.]tax.cn
```

测试后的策略值：

```text
[*.]sat.tax
[*.]tax.cn
```

其作用不是修复已经解决的业务500，而是验证跨站 `POST /chooseIdentify` 能否开始携带SSO Cookie。

成功判据：

```text
js-ver98.har #9对应请求
Cookie由空变为包含CASTGC、SSO JSESSIONID、_idnetify_key_等
且不再跳changeIdentity
```

如果简单“再次点击 iframe”已经能解决当前问题，可以不扩大Legacy SameSite范围，安全面更小。

不要直接配置 `[*.]tax`。只有 `[*.]tax.cn`测试后仍明确证明 `tpass.zjsw.tax` 缺必要Cookie，才单独测试精确主机：

```text
tpass.zjsw.tax
```

### 8.3 第三方Cookie策略收敛

`BlockThirdPartyCookies=0` 是全局放开，适合诊断，不宜用于普通互联网浏览配置。确认功能稳定后，应在隔离的税务专用Chrome配置中使用，或测试通过 `CookiesAllowedForUrls`仅允许必要内网站点。

注意：允许第三方Cookie和Legacy SameSite回退解决的是两层不同限制，定向Cookie允许不能自动替代 `[*.]sat.tax` 的旧SameSite行为。

## 九、最小化确认测试

### 测试1：最关键——不经过顶层窗口的第二次iframe访问

使用新的独立Chrome用户目录：

1. 仅配置当前 `[*.]sat.tax`、`BlockThirdPartyCookies=0`；
2. 登录portal；
3. 第一次点击一户式，等待身份选择页出现；
4. 不选择身份、不顶层打开URL；
5. 关闭当前iframe页签或返回portal；
6. 再次点击同一业务对象的一户式；
7. 导出完整HAR。

结果解释：

- 第二次直接200：证明顶层不是必要条件，第一次流程设置完Cookie后只需受控重试；
- 第二次仍进身份页，而顶层后成功：说明顶层正常页面还初始化了服务端会话内部状态或页面级状态。

### 测试2：只增加 `[*.]tax.cn`

使用另一个全新用户目录，保持业务对象一致：

1. 配置 `[*.]sat.tax`和 `[*.]tax.cn`；
2. 保持 `BlockThirdPartyCookies=0`；
3. 首次只点击一次；
4. 检查 `POST dddl.../chooseIdentify` 的Cookie和Location。

若第一次即可完成，说明扩展SSO域名单可代替预热/重试。

### 测试3：清除单项业务状态

在已成功的会话中逐组清除后测试：

1. 只清 `_cookie_user_name`和 `_session_is_expired_`；
2. 只清业务 `JSESSIONID`；
3. 保留业务Cookie但清除SSO Cookie。

预期用途：

- 清身份Cookie后复现身份页：确认它们是首次/再次访问差异的直接状态；
- 清 `JSESSIONID`后重新CAS：确认业务会话连续性；
- 只清SSO Cookie但既有业务页仍正常：证明预热后的一户式不依赖后续SSO。

### 测试4：固定请求参数

同一登录人员、同一纳税人分别测试：

```text
swryDm/swryxm非空
swryDm/swryxm为空
```

避免把业务身份选择规则与浏览器策略混在一起。

### 抓包要求

- Network启用Preserve log；
- 从portal点击前开始；
- 记录到业务数据接口完成；
- 导出包含响应内容的HAR；
- 同时记录 `chrome://policy` 状态；
- 在Network Cookies面板记录 blocked reason；
- 每组使用独立用户目录，禁止复用上一组会话。

## 十、CEF3 / Chromium 139在x86与ARM信创终端的更新方案

### 10.1 本次完整HAR对CEF方案的直接意义

完整HAR已证明：只要CEF能够保存并在后续iframe请求发送以下Cookie，业务可直接工作：

```text
header_referer
sj_sso_name
refer
JSESSIONID
_session_is_expired_
_cookie_user_name
```

CEF 139无需伪造ticket，也无需在每次打开一户式时重新执行CAS。重点是保持同一业务会话和一次性处理首次初始化。

### 10.2 推荐实现

1. portal、`cktsqd`、`dyxscx`、SSO、身份页和临时顶层窗口全部使用同一个持久化 `CefRequestContext`。
2. 配置统一 `cache_path`；不要为iframe、弹窗、业务模块分别建立隔离RequestContext。
3. 如需要跨进程重启保存会话，再启用 `persist_session_cookies=1`。
4. 保存原始业务URL仅用于当前内存会话和一次受控重试；不得写日志或长期存储其中的身份参数。
5. 首次请求如完成ticket回调、同一 `JSESSIONID`连续并收到 `_cookie_user_name`、`_session_is_expired_`，但导航到 `changeIdentity`，允许对原业务URL重试一次。
6. 重试前通过 `CefCookieManager`确认业务域的必要Cookie已存在。
7. 设置每个业务入口一次性的retry标志，避免无限循环。
8. 若第二次iframe仍失败，则使用同一RequestContext创建临时顶层Browser加载原业务URL，成功后再返回iframe。
9. 多身份账号不得静默跳过真实身份选择；只有业务 `_cookie_user_name`与portal当前身份一致时才能自动重试。

建议状态机：

```text
portal打开一户式iframe
  → 首次业务请求
  → ticket回调是否使用同一JSESSIONID？
      ├─ 否：报告Cookie策略/RequestContext隔离问题
      └─ 是：是否已获得_cookie_user_name和_session_is_expired_？
          ├─ 否：继续正常认证
          └─ 是：页面是否完整？
              ├─ 是：结束
              └─ 否：同RequestContext重试原URL一次
                   ├─ 成功：结束
                   └─ 失败：顶层预热或显示身份选择
```

### 10.3 Chromium 139版本边界

Chrome官方将 `LegacySameSiteCookieBehaviorEnabledForDomainList` 标为支持Chrome 79～131，因此CEF/Chromium 139不能依赖该企业策略。

x86与ARM的Cookie规则相同。应以共享RequestContext、持久Cookie存储和受控导航状态机解决，而不是为不同CPU维护不同逻辑。

不建议：

- 使用已失效的 `--disable-features=SameSiteByDefaultCookies,...`作为生产方案；
- 在请求回调中伪造 `Cookie`头；
- 把360浏览器Cookie复制到CEF；
- 全局关闭Web Security、站点隔离或证书校验；
- 为每个CEF Browser创建独立Cookie存储。

如果必须在Chromium 139 iframe中全面模拟旧SameSite行为，只能维护严格限定内网域名的Chromium网络栈补丁。该方案安全和升级成本高，应排在“同RequestContext受控重试/顶层预热”之后。

## 十一、部署建议

### Chrome 98

当前最小可用配置保持不变：

```text
[*.]sat.tax
BlockThirdPartyCookies=0
```

先完成“不顶层访问，直接第二次点击iframe”的最小测试。如果成功，客户端自动化只需在首次会话初始化后重试业务URL一次。

如果要求全新会话第一次点击即无身份页，再测试加入 `[*.]tax.cn`；以 `chooseIdentify` 是否发送SSO Cookie作为验收标准，不要只看页面外观。

### CEF 139 / 信创x86与ARM

推荐：

```text
单一持久化CefRequestContext
+ 统一CookieManager
+ 首次会话状态识别
+ 原业务URL单次重试
+ 必要时同RequestContext顶层预热
```

本次完整HAR已经为该方案提供直接网络证据：顶层成功请求与后续iframe成功请求使用同一套业务Cookie和同一个业务 `JSESSIONID`，后续iframe不需要新ticket。

## 十二、官方参考

- [Chrome Enterprise：LegacySameSiteCookieBehaviorEnabledForDomainList](https://chromeenterprise.google/policies/legacy-same-site-cookie-behavior-enabled-for-domain-list/)：策略语义、域名匹配规则和Chrome 79～131支持范围。
- [Chrome Enterprise：CookiesAllowedForUrls](https://chromeenterprise.google/policies/cookies-allowed-for-urls/)：定向允许站点Cookie。
- [Chrome Enterprise：URL Pattern格式](https://chromeenterprise.google/policies/url-patterns/)：企业策略域名与URL模式语法。
- [Chromium：Cookie Legacy SameSite Policies](https://chromium.googlesource.com/website/+/refs/heads/main/site/administrators/policy-list-3/cookie-legacy-samesite-policies/index.md)：Legacy SameSite行为及生命周期说明。
- [CEF 139：`cef_settings_t`](https://cef-builds.spotifycdn.com/docs/139.0/structcef__settings__t.html)：`cache_path`、`persist_session_cookies`等配置定义。
