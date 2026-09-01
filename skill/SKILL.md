---
name: wechat-miniprogram-minium
description: "Use when 用户要求搭建或编写微信小程序 minium（Python）自动化测试：环境安装、config.json 配置、用例编写、元素定位、Mock/Hook、Native 授权弹窗处理、真机与云真机运行、测试计划与报告；或排查 minium 报错（MiniElementNotFoundError、mock/hook 失效、真机调试连接失败、元素定位不到等）。"
---

# 微信小程序 minium 自动化测试 Skill（Python 版）

基于官方文档 [minitest.weixin.qq.com/#/minium/Python/readme](https://minitest.weixin.qq.com/#/minium/Python/readme) 全量封装（文档快照见 `references/`，对应 minium v1.6.0）。

## 0. 使用边界

- **本 Skill 语言版本**：Python 版 minium（另有 JS 版，不适用本文）。
- **能力范围**：小程序 UI 自动化、页面/数据校验、wx API 调用与 Mock/Hook、原生弹窗与授权处理、内嵌 H5（仅 Android 真机）、真机与云真机执行。
- **不适用**：纯接口测试、小程序静态代码扫描、云测平台 Monkey/录制回放（走云测产品能力，非编写脚本）。

## 1. 核心对象模型（必须先理解）

```
minium.Minium          初始化/驱动整个框架，持有配置与 App 实例
  └── minium.App       应用级：页面跳转、当前页面、页面栈、wx API 调用与 Mock/Hook、JS 注入
        └── minium.Page   页面级：data、元素查找、滚动、等待、调用页面函数
              └── minium.Element  元素级：属性/样式/点击/长按/滑动/trigger/子元素查找
minium.Native          微信原生层：授权弹窗、Modal、支付、地图选点、输入、性能采集（真机）
minium.H5Page / H5Element   web-view 内嵌 H5（仅 Android 真机）
minium.MiniTest        测试基类，继承 unittest.TestCase
```

在 `MiniTest` 用例中可直接用 `self.mini` / `self.app` / `self.page` / `self.native` / `self.logger` / `self.test_config`，框架已实例化好。

## 2. 标准工作流（SOP）

### Step 1 环境检查（不通过不要往下走）

| 检查项 | 命令/动作 | 通过标准 |
| :-- | :-- | :-- |
| Python 版本 | `python3 -V` | ≥ 3.8 |
| minium 已装 | `minitest -v` | 输出 `{'version': '1.x.x', ...}` |
| 开发者工具 | 最新稳定版 | 已登录 |
| **安全模式（最常见坑）** | 设置 → 安全设置 → **服务端口：打开** | 端口可用 |
| 自动化连通性 | `"path/to/cli" auto --project "path/to/project" --auto-port 9420` | 有 WebSocket 启动日志、IDE 顶部出现自动化提示 |

安装：

```bash
pip3 install minium                       # 常规
pip3 install "minium[ios]"                # 需要 iOS 真机时
pip3 install https://minitest.weixin.qq.com/minium/Python/dist/minium-latest.zip   # 装最新版
```

路径约定（下文沿用）：
- `path/to/project`：含 `project.config.json` 的小程序源码目录
- `path/to/cli`：macOS `<安装路径>/Contents/MacOS/cli`，默认 `/Applications/wechatwebdevtools.app/Contents/MacOS/cli`；Windows `<安装路径>/cli.bat`

### Step 2 搭项目骨架

从 `templates/` 复制，改真实路径即可：

```
.
├── test/
│   ├── __init__.py          # 必须有，用例以包形式被加载
│   └── first_test.py        # 约定 *_test.py
├── config.json              # 运行配置
├── suite.json               # 测试计划（可选）
└── outputs/                 # 运行产物（建议 .gitignore）
```

### Step 3 写配置 `config.json`

最常用项（完整 20+ 项见 `references/03-config.md`）：

| 配置项 | 默认 | 说明 |
| :-- | :-- | :-- |
| `project_path` | "" | 小程序项目目录；配置后必须同时配 `dev_tool_path` |
| `dev_tool_path` | 见默认值 | IDE cli 路径 |
| `platform` | "ide" | `ide` / `Android` / `iOS` |
| `debug_mode` | "info" | `error/warn/info/debug` |
| `test_port` | 9420 | IDE 自动化监听端口 |
| `auto_relaunch` | true | 每个 case 启动前 relaunch 到启动页 |
| `enable_app_log` | true | 监听小程序日志 |
| `enable_network_panel` | false | 记录所有 `wx.request`（日志落 `request.log`，基于 hook） |
| `auto_capture` | "auto" | `auto`：setUp/tearDown/断言时截图；`error`：仅失败截图；`assert`/`False` |
| `outputs` | outputs | 结果目录 |
| `auto_authorize` | false | 自动处理授权弹窗（基于 hook，会改写部分 wx API） |
| `mock_native_modal` | null | IDE 上 mock 授权弹窗（配置见 03-config.md） |
| `mock_request` | [] | 全局 mock 网络请求规则 |
| `device_desire` | null | 真机设备参数（Android `serial`；iOS `wda_project_path`/`wda_ip+wda_port`/`wda_bundle` + `device_info.udid`） |
| `account_info` | null | 多账号运行：`wx_nick_name` + `open_id` |
| `audits` | false | 自动体验评分 |
| `close_ide` / `full_reset` / `debug` | false | 调试用：`debug=true` 时不重启微信、结束不关小程序 |

> JSON 不支持注释，写配置时勿加 `//`。

### Step 4 编写用例

```python
#!/usr/bin/env python3
import minium

class FirstTest(minium.MiniTest):
    def test_get_system_info(self):
        sys_info = self.mini.get_system_info()
        self.logger.info(f'SDKVersion: {sys_info.get("SDKVersion")}')   # 日志进报告
        self.assertIn("SDKVersion", sys_info)
```

**铁律：用例文件不可 `python xxx_test.py` 直接运行，必须由 `minitest` 命令驱动。**

### Step 5 运行

```bash
minitest -m test.first_test -c config.json -g          # 单个模块（包名，不是路径）
minitest -s suite.json -c config.json -g               # 按测试计划
minitest -p ./test -c config.json -g                   # 整个目录
minitest --case test_login -m test.login_test -c config.json -g   # 单条用例
```

### Step 6 看报告

- `-g` 参数直接生成报告；或对已有产物 `minireport <input_path> <output_path>`
- 报告是静态站点，**不能直接双击 index.html**，需起静态服务：
  `python3 -m http.server 12345 -d outputs` → 浏览器打开 `http://localhost:12345`

## 3. 命令行速查

| 参数 | 说明 |
| :-- | :-- |
| `-m MODULE` | 用例包名/文件名 |
| `-p PATH` | 用例目录，默认当前目录 |
| `--case NAME` | 指定 `test_` 开头的用例名 |
| `-s SUITE` | 测试计划文件 |
| `-c CONFIG` | 配置文件 |
| `-g` | 生成网页报告 |
| `-a` | 查看 IDE 已登录的多账号 open_id（需 9420 端口以自动化模式打开 IDE） |
| `--mode` | `parallel`（每账号取一个 pkg）/ `fork`（每账号跑全量） |
| `--task-limit-time` | 任务超时（秒），到点终止 |
| `--module_search_path` | 追加 module 搜索路径 |
| `-v` / `-h` | 版本 / 帮助 |

其他命令：

```bash
miniwxml <wxml文件> "<selector>"     # 离线校验选择器，定位不到元素时用它排查
minireport <input_path> <output_path> # 由产物生成报告
```

`suite.json` 的 `pkg_list` 按数组顺序执行，匹配规则是**通配符（不是正则）**：

```json
{"pkg_list": [{"pkg": "test.*_test", "case_list": ["test_*"]}]}
```

## 4. 元素定位（最高频故障点）

### 选择器语法（minium 只支持这些）

| 类型 | 示例 |
| :-- | :-- |
| id | `#the-id` |
| class（可连写多个） | `.a-class.another-class` |
| 标签 | `view` |
| 子元素 | `.parent > .child` |
| 后代 | `.ancestor .descendant` |
| **跨自定义组件后代** | `custom-element1 >>> .custom-element2 >>> .the-descendant` |
| 并集 | `#a-node, .some-other-nodes` |
| xpath | `/view[5]`、`/page/view[10]/mytest2/view/view[1]`（以 `/` 或 `//` 开头） |
| 属性 | `input[type='digit']`、`view[id='main'][class='page-section']` |

组合写法：`tagName + #id + .className`，如 `get_element("view#main.page-section")`。

### 必记规则

1. **自定义组件不支持穿透**：要么 `>>>` 逐层连接，要么 `get_element("mytest").get_element("test22").get_element("text")` 逐层取。
2. 判断自定义组件：WXML 面板中标签带 `#shadow-root` 的即为自定义组件（`<page/xxx>` 根节点的 shadow-root 不算）。
3. **`bindinput` 之类绑定方法不能作为定位依据**（`input[bindinput='xxx']` 匹配不到）。
4. xpath 不支持 `[text()='xxx']` 这类条件；xpath 可在真机调试 WXML 面板「选择节点 → 右键 → copy → copy full xpath」获取。
5. `get_elements(..., index=n)` 取前 n+1 个；`index=-1`（默认）取全部。
6. `max_timeout=0` 表示不等待；写用例时**建议显式给 `max_timeout`（3~10s）**，比 `time.sleep` 可靠。
7. 找不到元素抛 `MiniElementNotFoundError`；可用 `auto_fix=True`（minium ≥1.5.5）让框架推测可能的目标元素，报告中以 `autofix_succ` 标记。

### 定位不到元素的标准排查流程

1. 从报告的**用例产物**目录拿到框架记录的页面 `.wxml` 文件
2. `miniwxml 04105738.wxml "mytest >>> test2 >>> .test2"` 离线校验选择器
3. 按提示修正；仍失败则改用逐层 `get_element` 或开启 `auto_fix`

## 5. 用例编写规范

### MiniTest 基类

属性：`self.mini` / `self.app` / `self.page` / `self.native` / `self.logger` / `self.test_config`

方法：

| 方法 | 说明 |
| :-- | :-- |
| `capture(name=None, region=None)` | 截图进报告；`region` 传 Page 或 Element 可截局部（需装 `opencv-python`） |
| `get_current_requests()` | 当前 case 捕获的请求日志（含 request/response/时间戳） |
| `get_weapp_logs()` | 当前 case 捕获的小程序日志（含 jserror） |
| `relaunch_miniprogram()` | 重启小程序（≥1.6.0） |

### 修饰器（`references/10-modifier.md`）

`skip(reason)`、`skipIf(cond_or_func, reason)`、`skipUnless`、`expectedFailure`、`expectedException`、`retry(cnt, expected_exception=None)`、`catch(Ex1, Ex2...)`、`justAtPlatform(p)`、`skipAtPlatform(p)`、`justAtCloud`、`skipAtCloud`、`exit_when_error`（修饰初始化用例，失败即终止测试计划）、`ddt_class`、`ddt_case`、`ddt_unpack`、`ddt_data(值, name=名)`

### 数据驱动

```python
@minium.ddt_class(testNameFormat="%(name)s")     # 可选，%(index)s 必含
class RenameTest(minium.MiniTest):
    @minium.ddt_case(
        minium.ddt_data(1, name="test_one"),
        minium.ddt_data(2, name="test_two"),
    )
    def test_ddt(self, value):
        self.assertIn(value, [1, 3])
```

### 断言

除 unittest 全套（`assertEqual/assertTrue/assertIn/assertDictEqual/assertRaises/assertAlmostEqual/assertRegex/assertIsNone/assertGreater...`）外，minium 额外提供 `assertDictContainsSubset`、`assertSetContainsSubset`。

## 6. 常用 API 速查（完整签名见 `references/api/`）

### App（`api/App.md`）

| 类别 | 方法 |
| :-- | :-- |
| 页面跳转 | `navigate_to(url, params=None)`（不能跳 tabBar，页面栈最多 10 层）、`redirect_to(url, params=None)`、`relaunch(url, params=None)`、`go_to(url)`（非目标页才 relaunch，≥1.6.0）、`switch_tab(url, is_click=False)`（路径不可带参数）、`navigate_back(delta=1)`、`go_home()` |
| 页面信息 | `get_current_page()`、`current_page`（属性）、`get_page_stack()`、`get_all_pages_path()` |
| 等待 | `wait_for_page()`、`wait_util()` |
| wx API | `call_wx_method(method, args=None)` → `ret["result"]["result"]` |
| Mock/Hook | `mock_wx_method` / `restore_wx_method` / `hook_wx_method` / `release_hook_wx_method` / `hook_current_page_method` |
| 网络 Mock | `mock_request` / `mock_request_once` / `restore_request` |
| JS 注入 | `evaluate(app_function, args, sync=False)`（异步配合 `get_async_response(msg_id, timeout)`）、`expose_function(name, fn)` |
| 其他 | `screen_shot(save_path, format="raw")`、`add_observer/remove_observer`、`get_modals()`、`get_unhandle_modal()`、`get_perf_time/stop_get_perf_time`、`mock_choose_image(s)`、`mock_call_function`、`mock_call_container` |

### Page（`api/Page.md`）

| 成员 | 说明 |
| :-- | :-- |
| `data` | 读写页面 data，**直接赋值等价于 setData** |
| `path` / `query` / `page_id` / `wxml` / `renderer` | 页面元信息 |
| `scroll_x/y` `scroll_width/height` `inner_size` | 滚动与窗口 |
| `get_element(selector, inner_text=None, text_contains=None, value=None, max_timeout=0, xpath=None, auto_fix=False)` | 找不到抛 `MiniElementNotFoundError` |
| `get_elements(selector, ..., index=-1)` | 返回列表 |
| `element_is_exists(selector, max_timeout=10, ...)` | 返回 bool |
| `scroll_to(scroll_top, duration=300)` | 滚动；不生效时先确认滚动主体是 `/`、`scroll-view` 还是 `view` |
| `call_method(method, args=None)` | 调用 Page 上定义的函数 |
| `wait_for(condition, max_timeout=10)` | `int`=等秒数；`str`=等元素选择器；`func`=等返回 True 的函数 |
| `wait_data_contains(*keys, max_timeout=10)` | 等 data 出现指定 key，支持 `"a.b.c"` 或 `("a","b","c")` |

### Element（`api/Element.md`）

属性：`size` `offset` `rect` `value` `inner_text` `inner_wxml` `outer_wxml`，以及**魔法糖**——直接读标签属性，如 `get_element("switch").checked`

方法：`get_element(s)` / `get_elements(s, index=-1)` / `attribute(name)` / `styles(names)`（都返回 list）/ `tap(force=False)` / `click()`（点击前校验 `pointer-events`）/ `long_press(duration=350)` / `move(x_offset, y_offset, move_delay=350, smooth=False)` / `touch_start` `touch_move` `touch_end` / `trigger(trigger_type, detail)` / `scroll_to(top, left)`

子类：
- `FormElement`：`input(text)`、`switch()`、`slide_to()`、`pick()`
- `ViewElement`：`scroll_to()`、`swipe_to()`、`move_to()`
- `CustomElement`：`data`、`call_method()`
- `VideoElement` / `AudioElement` / `LivePlayerElement` / `LivePusherElement`：播放控制类

> `input`/`picker` 的 tap 在 v1.4.0 后默认忽略，需 `tap(force=True)`。

### Native（`api/Native.md`，真机为主）

授权：`allow_authorize` `allow_login` `allow_privacy` `allow_get_user_info` `allow_get_location` `allow_get_we_run_data` `allow_record` `allow_write_photos_album` `allow_camera` `allow_send_subscribe_message` `allow_get_user_phone`
弹窗：`handle_modal` `handle_action_sheet` `handle_alter_before_unload`
输入：`input_text` `input_clear` `textarea_text` `textarea_clear` `click_coordinate`
地图：`map_select_location` `map_back_to_mp`
支付：`get_pay_value` `input_pay_password` `close_payment_dialog`
其他：`forward_miniprogram` `text_exists` `text_click` `start_get_perf/stop_get_perf` `start_get_fps` `select_wechat_avatar` `start_wechat/stop_wechat`

## 7. Mock / Hook

- **mock** = 替换 wx API 实现；**hook** = 在 API 调用前/后/回调插桩（`before` / `after` / `callback`）。
- 标准姿势：

```python
try:
    self.app.mock_wx_method("getLocation", result={"latitude": 30.5, "longitude": 114.4, "errMsg": "getLocation:ok"})
    ...                                  # 触发业务
finally:
    self.app.restore_wx_method("getLocation")   # 必须还原，避免污染后续用例
```

- 监听异步回调用 `minium.Callback`：`is_called`、`wait_called(timeout=10)`、`get_callback_result(timeout=0)`

```python
from minium import Callback
before = Callback()
self.app.hook_wx_method("showToast", before=before)
self.app.call_wx_method("showToast", {"title": "我是弹窗"})
self.assertDictEqual({"title": "我是弹窗"}, before.get_callback_result(timeout=2))
```

- **uni-app / taro 等第三方框架**常把 wx API 原始引用保存或 Proxy 代理，导致 mock/hook 失效。解决：在 `app.js` 中 `wx._MINI_WX_PROXY_ = uni`（taro 则赋值 `taro`）。
- 配置层 mock：全局 `mock_request` 支持正则匹配 url 与请求参数，见 `references/03-config.md`。

## 8. 真机与云真机

| 场景 | 要点 |
| :-- | :-- |
| Android | 配 `platform: "Android"`；装 adb、开 USB 调试、`adb devices` 可见；多设备需 `device_desire.serial`。首次运行会自动安装测试 apk，可能需人工确认 |
| iOS | `pip3 install "minium[ios]"`；装 libimobiledevice；准备 WebDriverAgent，三选一：`xcode + appium-webdriveragent`（`wda_project_path`）、`wda_ip + wda_port` 代理、`tidevice + wda_bundle`（iOS 17+ 不支持） |
| 真机调试版本 | 真机调试 2.0 需 minium ≥1.2.8 且基础库 ≥2.25.1；**真机调试 1.0 在基础库 > 2.25.3 时取不到元素**，需切 2.0（或给手机推 ≤2.25.3 基础库） |
| 云真机 | 上传用例 zip → 建 Minium 类型测试计划 → 提交任务；支持虚拟账号、报告分享、一键重跑失败用例；每台机器至少扣 10 分钟 |

## 9. 编写规范与最佳实践（Checklist）

1. **一个页面/模块一个测试类**，用例方法 `test_xx` 语义化命名，按序号组织（`test_00_前置` → `test_01_...`）。
2. **用 `setUpClass` 做一次性跳转**，减少每个用例重复拉起页面；不要在用例中 `time.sleep` 硬等，优先 `wait_for` / `wait_data_contains` / `element_is_exists(max_timeout=)`。
3. **选择器优先 id/class + `inner_text`/`text_contains`**，其次 `>>>` 跨组件，最后才 xpath（xpath 对页面结构变化极敏感）。
4. **每条用例可独立运行**：不依赖其他用例的副作用；Mock/Hook 必须在 `finally` 还原。
5. **断言带 message**，失败时报告里一眼可见。
6. **关键节点 `self.capture()`**，报告中可直接看到现场。
7. **平台差异用修饰器收敛**：`@minium.justAtPlatform("ide")` / `@minium.skipAtPlatform("Android")`，而不是在用例里写 if。
8. **不稳定用例用 `@minium.retry(2, 指定异常)`**，禁止无差别全局重试掩盖问题。
9. **外部依赖（定位/支付/相册/登录）一律 Mock**，保证可重复执行。
10. **产物与用例分离**：`outputs/` 加入 `.gitignore`。

## 10. 常见错误排查

| 现象 | 原因与处理 |
| :-- | :-- |
| IDE 没自动打开 / 连接超时 | 未开「安全设置 → 服务端口」；先跑 `cli auto --project ... --auto-port 9420` 做环境检查 |
| traceback 含 `_miniClassSetUp` | 调试基础库过旧：IDE 右上角 详情 → 本地设置 → 调试基础库 选最新 |
| `MiniElementNotFoundError` | 走第 4 节排查流程（`miniwxml` 校验 + `auto_fix` + 逐层取元素） |
| mock/hook 不生效 | 小程序保存了 wx 原始引用或用了 Proxy → 设 `wx._MINI_WX_PROXY_`；按 `references/13-mock-hook.md` 5 步验证 |
| IDE 上授权弹窗/地图无法处理 | 配 `mock_native_modal`（weRunData/userInfo/location/locations），用 `native.handle_modal` 等处理 |
| `input` 输入无效 | 小程序 input 是原生实现，用 `Element.trigger("input", {"value": ...})` 或 `FormElement.input()`；注意 UI 上不显示输入内容 |
| 真机取不到元素 | 真机调试 1.0 + 基础库 > 2.25.3，切真机调试 2.0 |
| 页面操作报 `PageDestroyed` | ≥1.5.1 框架会自动重新获取当前页面；仍失败说明页面已销毁，需重新 `navigate_to` |
| 报告打不开 | 静态站点，需 `python3 -m http.server` 或 nginx 托管，不能双击 html |
| 滚动没生效 | 确认滚动主体是 `/` / `scroll-view` / `view`，先 `get_element` 再 `scroll_to` |

## 11. 参考资料索引

本目录下的 `references/` 是官方文档快照（链接已重写为线上地址，可点击跳转）：

| 文件 | 内容 |
| :-- | :-- |
| `01-quickstart.md` | 运行环境、安装、环境检查、最小可运行示例 |
| `02-first-case.md` | 目录结构、第一个 case、运行与查看结果 |
| `03-config.md` | **全部配置项**、Android/iOS `device_desire`、`mock_native_modal`、`mock_request` |
| `04-cli.md` / `05-suite.md` | 命令行工具 / 测试计划 |
| `06-result-report.md` | 结果目录结构与报告生成、托管方式 |
| `07-framework-intro.md` | 测试框架做了哪些封装 |
| `08-MiniTest.md` | MiniTest 属性与方法 |
| `09-assert.md` / `10-modifier.md` / `11-callback.md` | 断言 / 修饰器 / Callback |
| `12-selector.md` | **元素定位**（含自定义组件判别、排查流程） |
| `13-mock-hook.md` | mock/hook 原理、验证方法、第三方框架适配 |
| `14-network-panel.md` | 网络请求日志与自定义监听 |
| `15-multi-accounts.md` | 多账号并行配置 |
| `16-real-device.md` | Android/iOS 真机、WDA 配置、云真机对比 |
| `17-h5-test.md` | 内嵌 H5（仅 Android 真机） |
| `18-samples.md` | 官方示例：UI/单页面/原生组件/mock/接口/DDT |
| `19-faq.md` / `20-update-log.md` | 反馈渠道 / 版本更新日志 |
| `api/*.md` | Minium、App、Page、Element 及 Form/View/Custom/Video/Audio/Live 子类、Native、H5Page、H5Element 完整签名与示例 |

`templates/` 为可直接复制的项目脚手架：`config.json`、`suite.json`、`test/__init__.py`、`test/first_test.py`、`.gitignore`。

## 12. 执行前必读提醒

- 生成配置/用例前，先确认三项真实信息：**小程序项目路径**、**IDE cli 路径**、**platform（ide/Android/iOS）**；未知则先问用户，不要编造路径。
- 首次交付应先跑通 1 条用例（`minitest -m test.first_test -c config.json -g`），确认环境通过后再批量编写。
- 官方文档以 [minitest.weixin.qq.com](https://minitest.weixin.qq.com/#/minium/Python/readme) 为准；本 Skill 快照对应 minium v1.6.0，若用户版本明显更新，提示其核对 `references/20-update-log.md`。
