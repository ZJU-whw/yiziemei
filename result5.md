# Chrome 139 仅浏览器侧适配旧 iframe 系统的方案

## 一、约束与结论

当前约束是：

- 业务系统、SSO、Cookie 属性和页面框架都不能修改；
- 只能在 Chrome/Chromium 139 浏览器侧适配；
- 旧系统通过 HTTP 跨站 iframe 运行；
- Chrome 101 曾依靠以下策略恢复旧 Cookie 行为：

```bat
reg add "HKLM\SOFTWARE\Policies\Google\Chrome\LegacySameSiteCookieBehaviorEnabledForDomainList" /v 1 /t REG_SZ /d "[*.]sat.tax" /f
reg add "HKLM\SOFTWARE\Policies\Google\Chrome\LegacySameSiteCookieBehaviorEnabledForDomainList" /v 2 /t REG_SZ /d "[*.]tax.cn" /f
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v BlockThirdPartyCookies /t REG_DWORD /d 0 /f
```

直接结论如下：

1. `LegacySameSiteCookieBehaviorEnabledForDomainList` 官方只支持 Chrome 79～131，在 Chrome 139 中写入同名注册表项无效；
2. Chrome 139 没有另一项企业策略、`chrome://flags` 开关或启动参数可以等价恢复该行为；
3. `BlockThirdPartyCookies=0` 和 `CookiesAllowedForUrls` 只能处理“第三方 Cookie 内容设置”，不能绕过 `SameSite=Lax`；
4. 旧系统又是 HTTP，无法在浏览器侧简单把响应改成 `SameSite=None; Secure`：`SameSite=None` 必须带 `Secure`，而普通 HTTP 不能使用 Secure Cookie；
5. 所以，在服务端完全不改的前提下，不存在“再加几条注册表命令”这种无开发量方案。

可落地路线按推荐顺序为：

```text
方案一：浏览器将业务入口改为顶层标签页/窗口（推荐，风险最低）
方案二：必须保留 iframe 时，开发受管 MV3 Cookie 桥接扩展
方案三：自研 Chromium 139 时，恢复限定域名的 Legacy SameSite 补丁
```

## 二、为什么现有 Chrome 139 策略不能解决

原配置解决的是两层独立限制：

| 配置 | 作用 | Chrome 139 状态 |
|---|---|---|
| `LegacySameSiteCookieBehaviorEnabledForDomainList` | 将指定域的未声明 SameSite Cookie 恢复为旧行为 | 仅支持到 131，139 无效 |
| `BlockThirdPartyCookies=0` | 允许第三方 Cookie，不让用户改为阻止 | 139 有效，但不覆盖 SameSite |
| `CookiesAllowedForUrls` | 为指定嵌入站点/顶层站点允许第三方 Cookie | 139 有效，但不覆盖 SameSite |

Chrome 会把未声明 SameSite 的 Cookie 通常按 `Lax` 处理。在跨站 iframe 导航、iframe 内 POST 和子资源请求中，这些 Cookie 不会发送。

Chromium 官方还明确说明：

- `chrome://flags` 中相关 SameSite 开关从 Chrome 91 起已移除；
- `--disable-features=SameSiteByDefaultCookies,CookiesWithoutSameSiteMustBeSecure` 启动参数从 Chrome 94 起已移除。

因此，下列尝试在 Chrome 139 中都不能作为方案：

```text
继续写 LegacySameSiteCookieBehaviorEnabledForDomainList 注册表
只设置 BlockThirdPartyCookies=0
只配置 CookiesAllowedForUrls
使用旧的 chrome://flags SameSite 开关
使用旧的 --disable-features=SameSiteByDefaultCookies 启动参数
```

## 三、方案一：浏览器侧改为顶层标签页/窗口

### 3.1 原理

SameSite 对“跨站 iframe 请求”和“顶层导航”的处理不同。未声明 SameSite、按 `Lax` 处理的 Cookie，通常可用于安全方法发起的顶层导航，但不能用于跨站 iframe。

已有 HAR 也证明：业务地址以顶层页面访问时能够复用业务会话并返回完整页面；随后主页面、菜单和数据请求均正常。因此，不改服务端时，最稳妥的浏览器适配是让一户式业务在同一 Chrome 用户配置、同一 Cookie 存储中的新标签页或弹窗运行，而不是继续放在 portal 的跨站 iframe 内。

### 3.2 实现方式

开发一个权限尽量小的 Manifest V3 扩展，由企业策略强制安装：

1. 内容脚本只注入 `portal.zjsw.tax.cn`；
2. 识别原本加载 `dyxscx.yhs.data.sat.tax:8145` 的入口；
3. 阻止其继续装入 iframe；
4. 使用 `chrome.tabs.create()` 或 `chrome.windows.create()` 在顶层打开原始业务 URL；
5. portal、业务页、SSO 和身份选择全程使用同一 Chrome Profile，不使用无痕窗口；
6. 业务窗口关闭后返回 portal，不复制、不记录 Cookie 和 ticket。

如果无法稳定识别点击按钮，也可监听页面中新建或更新的目标 iframe：匹配精确业务 host 后，将该 `src` 转为顶层标签页打开，并停止 iframe 导航。

### 3.3 状态机

```text
用户点击一户式
  → 扩展取得原业务 URL
  → 同一 Profile 顶层打开
  → 正常执行 CAS/SSO 跳转
  → 如进入身份选择，让用户正常选择
  → 回到业务域并加载页面
```

不能把 CAS ticket 写入日志或长期保存。ticket 通常只能消费一次，扩展也不得自行复制旧 ticket 重放。

### 3.4 验收重点

- 使用全新 Chrome Profile 首次登录测试，不能只用已经预热的会话；
- 顶层业务请求应能保持同一 `JSESSIONID`；
- ticket 回调不再连续新建业务会话；
- 不再出现 `ec1=0001`、第二张 ticket 和 HTTP 500；
- 测试身份选择、会话过期、退出、重新登录和多身份账号；
- 如果某一步仍通过跨站 POST 依赖旧 Cookie，继续把该认证页面留在同一顶层标签页完成，不要提前塞回 iframe。

### 3.5 优缺点

优点：不伪造 Cookie、不改变 Chrome 安全模型、不维护 Chromium 内核补丁，实施和后续升级成本最低。

缺点：用户界面从 iframe 变成新标签页或独立窗口。如果“必须原位显示在 iframe 中”是硬性要求，则使用方案二或方案三。

## 四、方案二：受管 MV3 Cookie 桥接扩展

### 4.1 适用条件

只有必须保留现有跨站 iframe 交互、又完全不能修改服务端时，才考虑该方案。

其本质是：扩展读取 Chrome 已存储但因 SameSite 未自动发送的旧 Cookie，在非常严格的域名、顶层来源和请求类型范围内，将 Cookie 请求头补回去，从而在 Chrome 139 中模拟旧策略。

这不是普通扩展商店方案，应作为企业受管安全组件开发、签名、强制安装和审计。

### 4.2 Chrome 139 能力依据

Chrome 官方扩展文档说明：

- `chrome.webRequest` 能观察和修改传输中的请求；
- 要读取或修改 `Cookie`、`Set-Cookie`，监听器必须声明 `extraHeaders`；
- Manifest V3 普通扩展不能使用 `webRequestBlocking`；
- 通过企业策略安装的扩展仍可使用 `webRequestBlocking`。

因此推荐技术形态是：

```text
Manifest V3
+ 企业策略强制安装
+ webRequest / webRequestBlocking / cookies
+ 精确 host_permissions
+ onBeforeSendHeaders + extraHeaders
+ chrome.cookies.onChanged 维护内存 Cookie 索引
```

### 4.3 处理流程

1. 先在顶层完成 portal、业务域和 SSO 域的正常访问，使旧 Cookie 进入 Chrome Cookie Store；
2. 扩展通过 `chrome.cookies` 初始化内存索引，并监听 Cookie 新建、更新和删除；
3. 仅当顶层站点是批准的 portal、目标请求是批准的 `sat.tax`/`tax.cn` 精确主机时处理；
4. 在 `onBeforeSendHeaders` 中读取 Chrome 已准备的 Cookie 头；
5. 按 RFC Cookie 的 domain、hostOnly、path、secure、expiry 和 storeId 规则筛选内存 Cookie；
6. 只补充 Chrome 因 SameSite 未发送、且属于当前目标 URL 的 Cookie；
7. 用户退出或 Cookie 过期时同步删除内存状态；
8. 扩展重启或 Service Worker 冷启动尚未完成索引时，暂停这次业务入口并初始化后重新导航，不能发送不完整 Cookie。

初步域名范围应限制为已有 HAR 中实际出现的主机，例如：

```text
顶层来源：portal.zjsw.tax.cn
业务目标：dyxscx.yhs.data.sat.tax:8145
身份目标：dddl.zjsw.tax.cn
SSO 目标：实际抓包确认后的精确主机
```

不要直接给扩展 `<all_urls>`，也不要使用 `[*.]sat.tax`、`[*.]tax.cn` 作为最终权限边界；先根据完整 HAR 列出确实参与认证的精确主机。

### 4.4 必须保留的 Chrome 策略

旧系统为 HTTP，且需要在第三方上下文建立或更新 Cookie。专用受管终端仍应设置：

```bat
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v BlockThirdPartyCookies /t REG_DWORD /d 0 /f
```

它不能修复 SameSite，但可防止第三方 Cookie 内容设置在另一层拦截 Cookie。扩展负责的是 SameSite 导致的缺失请求头。

### 4.5 安全边界

Cookie 桥接扩展实际上绕过了浏览器为防止 CSRF 和跨站跟踪建立的 SameSite 边界，必须满足：

- 仅在隔离的税务专用 Chrome Profile 中启用；
- 只允许组织策略强制安装，禁止用户侧载和修改；
- 校验目标 URL、initiator、tab 顶层 origin 和资源类型；
- 不把 Cookie、ticket、身份参数写入日志、磁盘或扩展同步存储；
- 不向第三方脚本暴露 Cookie，尤其是 `HttpOnly` Cookie；
- 不修改 `Origin`、证书校验、CORS 或站点隔离；
- 仅追加缺失 Cookie，不覆盖 Chrome 已发送的同名 Cookie；
- 对 Cookie 名称设置白名单，并对扩展包做代码签名、升级控制和审计；
- 先在测试环境验证退出登录和过期删除，防止会话残留或串号。

### 4.6 技术风险

- MV3 Service Worker 会休眠，冷启动竞态必须专门处理；
- 同名 Cookie 可能因 Domain、Path、hostOnly 不同而同时存在，不能只按名称取值；
- CAS ticket 是一次性的，扩展不能重复提交旧请求；
- Cookie 桥接可能让原本被 SameSite 防住的跨站请求重新具有登录态，必须依赖精确来源白名单；
- 浏览器升级可能改变扩展 API 行为，需要把 Chrome 139、后续升级版本都纳入回归测试。

该方案必须先做最小 PoC，以 HAR 验证 request header 的最终结果；没有通过完整认证、退出和串号测试前不能生产部署。

## 五、方案三：Chromium 139 私有补丁

如果交付的是可自行编译的 Chromium/CEF 139，而不是 Google 官方 Chrome，可从 Chromium 131 保留的 Legacy SameSite 实现中移植相关策略和 Cookie 判定逻辑。

实现要求：

- 只对配置白名单中的精确业务 Cookie 域恢复旧行为；
- 不提供全局关闭 SameSite 的启动参数；
- 策略默认关闭，受管配置才启用；
- x86 和 ARM 使用同一逻辑与同一测试用例；
- 每次 Chromium 安全升级都重新合并、审计和回归；
- 在 `chrome://policy` 或自有管理页面明确展示该兼容策略状态；
- 对补丁版本、适用域名和退出计划留档。

该方案最接近 Chrome 101 的原始体验，但内核维护和安全责任最大。对于 Google 官方签名的 Chrome 139，不能通过替换 DLL、修改安装目录或普通命令行实现这一方案。

仅在 CEF 请求回调中尝试写 `Cookie` 头也不一定可靠，因为 Cookie 处理主要在 Chromium Network Service 内完成；应在网络栈 Cookie inclusion 判定层实现和测试，而不是依赖页面 JavaScript或复制其他浏览器的 Cookie。

## 六、建议决策

### 可接受新标签页/窗口

选择方案一。它是当前约束下风险和维护成本最低的正式方案：

```text
受管 MV3 扩展
→ 截获指定业务 iframe 入口
→ 同一 Profile 顶层打开
→ 原认证流程自行完成
```

### 必须保持 iframe 原位显示，使用官方 Chrome 139

选择方案二：开发并强制安装精确域名范围的 MV3 Cookie 桥接扩展。先完成 PoC，再根据 HAR 补全 Cookie 名称、主机和跳转状态机。

### 必须保持 iframe，且可以自研浏览器

优先方案三：维护 Chromium 139 的限定域 Legacy SameSite 补丁。它比扩展手工拼装 Cookie 更接近浏览器原生 Cookie 语义，但升级成本更高。

## 七、统一验收清单

1. 使用全新 Profile，不复用旧测试 Cookie；
2. `chrome://policy` 中确认 `BlockThirdPartyCookies=false` 生效；
3. Network 开启 Preserve log，从 portal 登录前开始记录；
4. 比对首次业务请求、第一张 ticket 回调和最终业务请求的 `JSESSIONID`；
5. `POST /chooseIdentify` 应携带所需 SSO Cookie，或在顶层完成身份选择；
6. 不得出现会话连续重建、`ec1=0001`、第二张 ticket 和 500；
7. 验证刷新、返回、并发打开两个业务、会话过期、退出登录、账号切换；
8. 验证扩展/浏览器异常退出重启后不会复用已过期会话；
9. 测试不在白名单的普通互联网网站，确认扩展不会补充任何 Cookie；
10. 每次 Chrome/Chromium 升级均执行完整回归。

## 八、官方参考

- [Chrome Enterprise：LegacySameSiteCookieBehaviorEnabledForDomainList](https://chromeenterprise.google/policies/legacy-same-site-cookie-behavior-enabled-for-domain-list/)：支持范围为 Chrome 79～131。
- [Chromium：SameSite Updates](https://www.chromium.org/updates/same-site/)：相关 flags 从 Chrome 91 移除，旧 `--disable-features` 启动参数从 Chrome 94 移除。
- [Chrome Enterprise：BlockThirdPartyCookies](https://chromeenterprise.google/policies/block-third-party-cookies/)：允许或阻止第三方 Cookie 的企业策略。
- [Chrome Enterprise：CookiesAllowedForUrls](https://chromeenterprise.google/policies/cookies-allowed-for-urls/)：第三方 Cookie 的定向内容设置例外；不能替代 SameSite 回退。
- [Chrome Extensions：chrome.webRequest](https://developer.chrome.com/docs/extensions/reference/api/webRequest)：Cookie/Set-Cookie 需要 `extraHeaders`；策略安装的 MV3 扩展仍可使用 `webRequestBlocking`。
- [Chrome Extensions：declarativeNetRequest](https://developer.chrome.com/docs/extensions/reference/api/declarativeNetRequest)：请求头修改能力及 Cookie header 支持范围。
- [MDN：Set-Cookie](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Set-Cookie)：SameSite、Secure、Domain、Path 和 Partitioned 规则。
