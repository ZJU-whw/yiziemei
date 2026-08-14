# CEF3 139 强制恢复固定跨站 iframe 会话的方案

## 一、结论

可以实现，而且在 CEF3 139 中优先使用 CEF 自带的定域 Legacy Cookie Content Setting，不需要先手工拼接每一个 iframe 请求的 `Cookie` 请求头，也通常不需要修改 Chromium 内核。

CEF 139.0.1 的公开 API 中仍存在：

```cpp
CEF_CONTENT_SETTING_TYPE_LEGACY_COOKIE_ACCESS
```

CEF 对它的定义正是：

- 未声明 `SameSite` 的 Cookie 按 `SameSite=None` 处理；
- `SameSite=None` Cookie 不强制要求 `Secure`；
- 关闭 Schemeful Same-Site 比较。

可通过：

```cpp
CefRequestContext::SetContentSetting(...)
```

只对业务 Cookie 所属的固定域启用。Google Chrome 139 已删除对应企业策略，并不代表 CEF 139 删除了这个程序接口。

本系统推荐结构为：

```text
单一持久 CefRequestContext
+ CefCookieManager 导入/保存完整业务 Cookie
+ LEGACY_COOKIE_ACCESS 对 Cookie 域定向 ALLOW
+ 允许所需的第三方 Cookie
+ 等所有 Cookie 写入完成后再加载 iframe
```

这里的“session”必须最终表现为浏览器发送给服务器的 Cookie，例如 `JSESSIONID`、SSO Cookie、身份 Cookie。客户端不能把 Java/Tomcat 内存中的服务器 Session 对象直接塞入 HTTP 请求；如果程序拿到的是服务端 Session ID，则仍需按服务器原有 Cookie 名称和作用域写入。

## 二、为什么该方案优于手工设置 Cookie 请求头

`CefCookieManager::SetCookie()` 只负责把 Cookie 写入 Cookie Store。单独调用它并不能绕过 SameSite：Cookie 即使存在，也可能在跨站 iframe 中被 Chromium 排除。

`CefCookieAccessFilter::CanSendCookie()` 也不是强制放行接口。它用于进一步过滤 Chromium 已经考虑发送的 Cookie；返回 `true` 不能保证把早先因 SameSite 被排除的 Cookie重新加入。

`OnBeforeResourceLoad()` 虽然允许修改 `CefRequest`，但直接构造 `Cookie` 请求头需要自行正确实现 Domain、hostOnly、Path、Secure、过期、同名 Cookie 顺序和删除同步，风险明显更高。

`LEGACY_COOKIE_ACCESS` 在 Chromium Cookie inclusion 判定层改变指定 Cookie 域的访问语义，最接近 Chrome 101 中旧策略的原生行为。

## 三、关键实现

### 3.1 所有相关 Browser 必须共享同一个 RequestContext

portal、业务 iframe、CAS/SSO 跳转、身份选择窗口和弹窗必须使用同一个 `CefRequestContext`：

```cpp
CefRequestContextSettings rc_settings;
CefString(&rc_settings.cache_path) = cache_path;
rc_settings.persist_session_cookies = 1;  // 仅在需要跨程序重启保留时启用

auto request_context =
    CefRequestContext::CreateContext(rc_settings, request_context_handler);
```

创建每个 Browser 时都传入同一个 `request_context`。不要为 iframe、弹窗或不同业务模块重新创建隔离的 RequestContext。

`persist_session_cookies=1` 不是当前会话共享的必要条件；它只控制没有 Expires/Max-Age 的会话 Cookie 是否跨程序重启持久化，并且要求配置非空 `cache_path`。

### 3.2 对真实 Cookie Domain 启用旧 SameSite 语义

建议在创建 Browser 或加载 portal 之前完成：

```cpp
void AllowLegacyCookieDomain(
    CefRefPtr<CefRequestContext> context,
    const std::string& cookie_domain) {
  // 建议在 Browser Process UI 线程调用。
  std::string domain = cookie_domain;
  while (!domain.empty() && domain.front() == '.') {
    domain.erase(domain.begin());
  }

  const std::string domain_url = "http://" + domain + "/";

  // Chromium 对 LEGACY_COOKIE_ACCESS 的查询只使用 Cookie Domain；
  // top_level_url 应为空，scheme 对这种设置没有实际意义。
  context->SetContentSetting(
      domain_url,
      CefString(),
      CEF_CONTENT_SETTING_TYPE_LEGACY_COOKIE_ACCESS,
      CEF_CONTENT_SETTING_VALUE_ALLOW);
}
```

初始化示例：

```cpp
AllowLegacyCookieDomain(request_context,
                        "dyxscx.yhs.data.sat.tax");
AllowLegacyCookieDomain(request_context,
                        "sat.tax");
AllowLegacyCookieDomain(request_context,
                        "dddl.zjsw.tax.cn");
AllowLegacyCookieDomain(request_context,
                        "zjsw.tax.cn");
```

不要仅照抄以上四项，应以程序实际取得的 Cookie 的 `domain` 字段为准：

- host-only Cookie：配置实际设置它的完整主机，例如 `dyxscx.yhs.data.sat.tax`；
- `Domain=.sat.tax`：去掉开头的点后配置 `sat.tax`；
- `Domain=.zjsw.tax.cn`：配置 `zjsw.tax.cn`；
- SSO 使用其他 Cookie 域时必须分别加入。

Chromium 139 的实现会使用 Cookie 自己的 Domain 查询 `LEGACY_COOKIE_ACCESS`，并传入空的 top-level URL。它不按 iframe 的目标端口查询。因此此设置本身不能精确限制到 `:8145`：应同时在应用导航和请求处理层只允许固定 host、port 和协议。若同一 host 的其他端口承载不可信系统，应改用更细粒度的请求拦截方案或内核补丁。

### 3.3 验证设置值

在开始加载 iframe 前检查：

```cpp
auto value = request_context->GetContentSetting(
    "http://dyxscx.yhs.data.sat.tax/",
    CefString(),
    CEF_CONTENT_SETTING_TYPE_LEGACY_COOKIE_ACCESS);

if (value != CEF_CONTENT_SETTING_VALUE_ALLOW) {
  // 阻止加载 iframe，记录不包含 Cookie 值的配置错误。
}
```

注意：`SetContentSetting()` 返回 `void`。固定域名时应在启动阶段预先设置，不要等第一条 iframe 请求已经发出后才修改。

## 四、将程序取得的完整会话写入 CEF

### 4.1 使用同一 RequestContext 的 CookieManager

```cpp
auto cookie_manager = request_context->GetDefaultCookieManager(nullptr);
```

不要使用另一个 RequestContext 的 CookieManager，也不要把 Cookie 只保存到程序自有变量后期待 CEF 自动使用。

### 4.2 写入示例

```cpp
CefCookie cookie;
cookie.name = "JSESSIONID";
cookie.value = session_id;
cookie.domain = "dyxscx.yhs.data.sat.tax";  // 按原 Cookie 属性填写
cookie.path = "/";
cookie.secure = 0;                           // 原系统为 HTTP
cookie.httponly = 1;
cookie.same_site = CEF_COOKIE_SAME_SITE_UNSPECIFIED;
cookie.has_expires = 0;                      // 会话 Cookie

cookie_manager->SetCookie(
    "http://dyxscx.yhs.data.sat.tax:8145/",
    cookie,
    set_cookie_callback);
```

需要逐项导入完整会话中的所有必要 Cookie，而不是只写 `JSESSIONID`。已有 HAR 显示应重点核对：

```text
业务域：JSESSIONID、refer、header_referer、sj_sso_name、
        _session_is_expired_、_cookie_user_name

SSO/身份域：CASTGC、SSO JSESSIONID、_idnetify_key_、
            sso_cookie_logid、sso_cookie_uid 等
```

每个 Cookie 必须保留它自己的：

```text
name、value、domain/hostOnly、path、secure、httponly、expires
```

不要把所有 Cookie 都改成同一个 Domain 或 Path。不同 host、Domain、Path 下可以存在同名 `JSESSIONID`，它们是不同 Cookie。

如果原 Cookie 未声明 SameSite，导入时使用：

```cpp
CEF_COOKIE_SAME_SITE_UNSPECIFIED
```

如果服务器明确设置了 `SameSite=Lax` 或 `SameSite=Strict`，`LEGACY_COOKIE_ACCESS` 不会覆盖这一显式属性。此时若仍需强制跨站发送，只能在确认业务安全边界后，把程序导入的副本设为 `UNSPECIFIED`，或使用请求头桥接/内核补丁；上线前必须验证服务端后续 `Set-Cookie` 是否又将其覆盖。

### 4.3 必须等待异步写入完成

`SetCookie()` 是异步操作。程序必须统计所有 `CefSetCookieCallback::OnComplete(bool success)`：

```text
全部必要 Cookie 写入成功
→ 可选 FlushStore
→ 再触发 iframe LoadURL
```

任何关键 Cookie 写入失败都不应继续导航，否则仍会出现新建 Session、重复 CAS ticket 和 500。

`FlushStore()` 只保证落盘；同一运行期通常不需要为了让 Cookie 生效而每次 Flush，但必须等待 `SetCookie` 回调成功。

## 五、同时处理第三方 Cookie 阻止

Legacy SameSite 和第三方 Cookie 阻止是两层限制。除启用 `LEGACY_COOKIE_ACCESS` 外，还应保证当前 RequestContext 没有阻止第三方 Cookie。

可先检查 CEF Profile preference 是否存在并可修改：

```cpp
const CefString pref_name = "profile.block_third_party_cookies";

if (request_context->HasPreference(pref_name) &&
    request_context->CanSetPreference(pref_name)) {
  auto value = CefValue::Create();
  value->SetBool(false);

  CefString error;
  if (!request_context->SetPreference(pref_name, value, error)) {
    // 阻止业务加载并记录 error，但不要记录 Cookie/session。
  }
}
```

也可为已知的“嵌入站点 + 顶层站点”设置 Cookie 内容许可：

```cpp
request_context->SetContentSetting(
    "http://dyxscx.yhs.data.sat.tax:8145/",
    "http://portal.zjsw.tax.cn/",
    CEF_CONTENT_SETTING_TYPE_COOKIES,
    CEF_CONTENT_SETTING_VALUE_ALLOW);

request_context->SetContentSetting(
    "http://dddl.zjsw.tax.cn/",
    "http://dyxscx.yhs.data.sat.tax:8145/",
    CEF_CONTENT_SETTING_TYPE_COOKIES,
    CEF_CONTENT_SETTING_VALUE_ALLOW);
```

实际调用后应使用 `GetContentSetting()` 验证。CEF 运行时和 Profile 配置可能不同，不能只假设默认允许。

## 六、推荐执行时序

固定域名场景不建议等 `OnBeforeResourceLoad()` 才临时设置，推荐：

```text
CEF 初始化
  → 创建唯一 CefRequestContext
  → 设置 LEGACY_COOKIE_ACCESS 域名单
  → 设置第三方 Cookie 许可
  → 创建 Browser 并登录 portal
  → 程序取得/更新全量会话 Cookie
  → CefCookieManager 异步写入全部 Cookie
  → 全部回调 success
  → 加载业务 iframe
  → HAR/DevTools 验证最终 Cookie 请求头
```

如果会话只能在点击 iframe 的瞬间取得：

1. 在 `OnBeforeBrowse` 或业务入口控制层识别精确 host、port；
2. 暂停/取消首次 iframe 导航；
3. 写入并等待全部 Cookie 回调；
4. 使用原 URL 重新加载一次；
5. 设置一次性 retry 标记，禁止无限重试。

也可在 `OnBeforeResourceLoad()` 返回 `RV_CONTINUE_ASYNC` 后异步处理，但线程切换、回调生命周期和 Cookie inclusion 时点更容易出错。固定域名时优先在导航前完成。

## 七、请求头强制注入只作为后备方案

如果实测 CEF 二进制虽然包含枚举，但当前 Runtime 未将设置传到 Network Service，或者业务 Cookie 显式声明 `Lax/Strict`，再考虑在 `CefResourceRequestHandler::OnBeforeResourceLoad()` 修改请求头。

该回调允许修改 `CefRequest`，可使用 `SetHeaderByName("Cookie", ...)`。但是必须：

- 精确匹配 scheme、host、port、path、frame 和顶层 portal；
- 根据 Domain、hostOnly、Path、Secure、expiry 重新筛选 Cookie；
- 合并 Chromium 已经生成的 Cookie，不能粗暴覆盖；
- 正确处理同名 Cookie和排序；
- 同步处理服务端删除、过期和退出登录；
- 不记录 Cookie 值；
- 用 HAR 确认 Network Service 最终确实发出了修改后的请求头。

这条路线相当于程序自行承担 Cookie Jar 的部分职责，维护风险高于 `LEGACY_COOKIE_ACCESS`。

## 八、安全边界

由于该方案恢复了浏览器已经淘汰的跨站 Cookie 行为，至少应做到：

- 仅对固定业务 Cookie Domain 启用，不设置全局默认 ALLOW；
- 导航层同时限制固定协议、host 和 port；
- 只在税务专用 CEF Profile 中运行；
- 禁止加载不在白名单中的外部页面；
- Cookie/session/ticket 不写日志、不跨用户复用；
- 用户切换、退出或会话过期时同步 `DeleteCookies()`；
- 多身份账号不得静默复用上一个身份的 Session；
- portal、iframe、弹窗使用同一 RequestContext，但不同登录用户使用不同 cache path；
- 不关闭证书校验、Web Security、CORS 或站点隔离；
- 每次升级 CEF 都回归 `LEGACY_COOKIE_ACCESS` 是否仍存在及行为是否一致。

## 九、验收判据

使用全新 cache path 完整测试：

1. `GetContentSetting()` 对每个真实 Cookie Domain 返回 `ALLOW`；
2. `VisitUrlCookies(url, true, ...)` 能看到所需 Cookie；
3. 首次 iframe 业务请求携带业务 Cookie；
4. 第一张 CAS ticket 回调携带与首次业务请求相同的 `JSESSIONID`；
5. `POST /chooseIdentify` 携带所需 SSO Cookie；
6. 不再连续创建新 `JSESSIONID`；
7. 不再出现 `ec1=0001`、第二张 ticket 和 HTTP 500；
8. 刷新、并发窗口、身份切换、退出和超时均不会串 Session；
9. 非白名单 host/port 的请求不获得任何强制会话；
10. x86 与 ARM 使用同一用例和 HAR 判据。

## 十、最终建议

当前条件下，先做一个最小 PoC：

```text
固定 RequestContext
+ 对实际 Cookie Domain 设置 LEGACY_COOKIE_ACCESS=ALLOW
+ profile.block_third_party_cookies=false
+ 将完整 Cookie 异步写入该 Context
+ 回调全部成功后重新加载 iframe
```

该方案直接利用 CEF 139 暴露的 Cookie 兼容能力，比在所有请求中手工强制拼接 Session 更可靠。如果 PoC 中 `GetContentSetting()` 返回 ALLOW，但 Network 中仍没有 Cookie，应先检查 Cookie 的真实 Domain、Path、显式 SameSite、RequestContext 是否一致和第三方 Cookie 设置，再考虑请求头注入或 Chromium 补丁。

## 十一、官方参考

- [CEF 139：Content Setting 类型](https://cef-builds.spotifycdn.com/docs/139.0/cef__types__content__settings_8h.html)：`CEF_CONTENT_SETTING_TYPE_LEGACY_COOKIE_ACCESS` 的定义和旧 SameSite 语义。
- [CEF 139：CefRequestContext](https://cef-builds.spotifycdn.com/docs/139.0/classCefRequestContext.html)：`SetContentSetting()`、`GetContentSetting()`、`SetPreference()` 与共享 Context。
- [CEF 139：CefCookieManager](https://cef-builds.spotifycdn.com/docs/139.0/classCefCookieManager.html)：Cookie 的访问、写入、删除和持久化接口。
- [CEF 139：CefCookieAccessFilter](https://cef-builds.spotifycdn.com/docs/139.0/classCefCookieAccessFilter.html)：Cookie 发送/保存过滤器的能力边界。
- [CEF 139：CefResourceRequestHandler](https://cef-builds.spotifycdn.com/docs/139.0/classCefResourceRequestHandler.html)：`OnBeforeResourceLoad()` 的异步暂停和请求修改能力。
- [Chromium：CookieSettingsBase](https://chromium.googlesource.com/chromium/src/+/main/components/content_settings/core/common/cookie_settings_base.cc)：Legacy Cookie Access 按 Cookie Domain、空 top-level URL 查询的实现。
- [Chromium：CookieSettingsBase 头文件](https://chromium.googlesource.com/chromium/src/+/main/components/content_settings/core/common/cookie_settings_base.h)：Legacy access 对未声明 SameSite Cookie 的语义说明。
