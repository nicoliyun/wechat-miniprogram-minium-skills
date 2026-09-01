# `Class` minium.Native :id=minium-native

> `Native` 提供了针对小程序内涉及原生控件(授权弹窗、弹窗、地图、分享小程序等)的操作封装

!> 除注明`开发者工具支持`支持的接口外，其他接口IDE平台暂不支持。部分接口需要在配置了[IDE的mock_native_modal配置项](https://minitest.weixin.qq.com/#/minium/Python/framework/config#IDE的mock_native_modal配置项)后通过mock的方式实现.

可以通过实例化[`minium.Native`](#init)或从[`minium.MiniTest.native`](https://minitest.weixin.qq.com/#/minium/Python/framework/Minitest)获得`Native`实例

---

## Native() :id=init

> 初始化

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|json_conf|dict|Not None|native 操作初始化参数, 对应[测试配置](https://minitest.weixin.qq.com/#/minium/Python/framework/config.md)中`device_desire`字段, 如配置文件为`{"device_desire": {"device_info": {"udid": "xxx"}}}`, 此处 json_conf 为`{"device_info": {"udid": "xxx"}}`|
|platform|str|Not None|平台。目前仅支持`android`和`ios`|

Android 和 iOS 使用的 json_conf 有些许差别：

_Android json_conf ：_

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|serial|str|Not None|手机 serial 序列号|

_iOS json_conf ：_

参考[`IOS的device_desire配置项`](https://minitest.weixin.qq.com/#/minium/Python/framework/config.md#IOS的device_desire配置项)

**代码示例:**

```python {"id":"01HKM3JMGGH26Z49AZASVXV318"}
import minium
native = minium.Native({
    "serial": "28fb61d0ef1c7ece"
}, "android")

```

---

## start_wechat() :id=start_wechat

> 启动微信App

**Returns:**

- `None`

**代码示例:**

```python {"id":"01HKM3JMGGH26Z49AZAXKWFC61"}
import minium
class NativeTest(minium.MiniTest):
    def test_start_wechat(self):
        self.native.start_wechat()
	
```

---

## stop_wechat() :id=stop_wechat

> 杀掉微信

**Returns:**

- `None`

**代码示例:**

```python {"id":"01HKM3JMGGH26Z49AZAZY0V1BK"}
import minium
class NativeTest(minium.MiniTest):
    def test_start_wechat(self):
        self.native.stop_wechat()	
```

---

## screen_shot() :id=screen_shot

> 截屏

> 开发者工具支持

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|filename|str|时间戳|截图文件名|

**Returns:**

- 截图文件名 `str`

**代码示例:**

```python {"id":"01HKM3JMGGH26Z49AZB1PCYQ2Z"}
import minium, os
class NativeTest(minium.MiniTest):
    def test_screen_shot(self):
        """
        截图并保存为test_native_screen_shot.png
        """
        file_name = "test_native_screen_shot.png"
        if os.path.isfile(file_name):
            os.remove(file_name)
        self.native.screen_shot(file_name)  # 截图
        self.assertTrue(os.path.isfile(file_name), "%s exists" % file_name)
        os.remove(file_name)
```

---

## allow_login() :id=allow_login

> 处理微信登陆确认弹框，点击允许或者取消

> 开发者工具支持, 开发者工具版本在`1.06.2211072`以下的需配置[IDE的mock_native_modal配置项](https://minitest.weixin.qq.com/#/minium/Python/framework/config#IDE的mock_native_modal配置项)

同[`allow_authorize`](#allow_authorize)

---

## allow_privacy() :id=allow_privacy

> 处理[官方隐私授权弹窗](https://developers.weixin.qq.com/miniprogram/dev/framework/user-privacy/PrivacyAuthorize.html), 该接口会在调用其他`allow_`接口前尝试调用来处理可能弹出的隐私授权弹窗, 你也可以显式调用处理

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|answer|bool|True|True 或 False|

**Returns:**

- `bool`

![privacy](https://res.wx.qq.com/wxdoc/dist/assets/img/privacyAuthurize2.b4eab590.png)

---

## allow_authorize() :id=allow_authorize

> 处理微信授权弹框的通用方法，点击允许或者拒绝。
> 该方法不对具体授权窗口做检验工作

> 可处理窗口包括：获取用户信息，获取位置，获取微信运动数据，获取录音权限，获取相册权限，获取摄像头权限，获取手机号码(仅真机支持)

> 开发者工具支持, 开发者工具版本在`1.06.2211072`以下的需配置[IDE的mock_native_modal配置项](https://minitest.weixin.qq.com/#/minium/Python/framework/config#IDE的mock_native_modal配置项)

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|answer|bool|True|True 或 False|

**Returns:**

- `bool`

```python {"id":"01HKM3JMGH3R7WZFYMYZSF6HDC"}
import minium, threading
from minium import Callback
@minium.ddt_class(testNameFormat="%(name)s_%(index)s")
class TestNative(minium.MiniTest):
    @classmethod
    def setUpClass(cls) -> None:
        super().setUpClass()
        cls.mini.clear_auth()   # 先清空授权才会弹窗
    
    def setUp(self) -> None:
        super().setUp()
        if self.page.path != "/pages/testnative/testnative":
            self.app.redirect_to("/pages/testnative/testnative")

    @minium.ddt_unpack
    @minium.ddt_case(
        ddt_data(("record", "allow_record"), "record"),
        ddt_data(("writePhotosAlbum", "allow_write_photos_album"), "write_photos_album"),
        ddt_data(("camera", "allow_camera"), "camera"),
    )
    def test_allow_authorize(self, scope, method):
        callback = Callback()  # 监听回调, 阻塞当前主线程

        self.app.hook_wx_method("authorize", callback=callback.callback)
        self.app.get_current_page().get_element(f"#{scope}").tap()
        getattr(self.native, method)()
        self.assertTrue(callback.wait_called(timeout=10), "callback called")
        self.assertDictContainsSubset({"errMsg": "authorize:ok"}, callback.get_callback_result())
```

---

## allow_get_user_info() :id=allow_get_user_info

> 处理获取用户信息确认弹框

> 开发者工具支持, 开发者工具版本在`1.06.2211072`以下的需要配置[IDE的mock_native_modal配置项](https://minitest.weixin.qq.com/#/minium/Python/framework/config#IDE的mock_native_modal配置项)

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|answer|bool|True|True: 允许 或 False: 拒绝|

**Returns:**

- `None`

**代码示例:**

```python {"id":"01HKM3JMGH3R7WZFYMZ2NBZ5A8"}
import minium, threading
from minium import Callback
@minium.ddt_class(testNameFormat="%(name)s_%(index)s")
class TestNative(minium.MiniTest):
    @classmethod
    def setUpClass(cls) -> None:
        super().setUpClass()
        cls.mini.clear_auth()   # 先清空授权才会弹窗
    
    def setUp(self) -> None:
        super().setUp()
        if self.page.path != "/pages/testnative/testnative":
            self.app.redirect_to("/pages/testnative/testnative")

    def test_allow_get_user_info(self):
        callback = Callback()  # 监听回调, 阻塞当前主线程

        # 获取用户授权会调用wx.getUserProfile接口，先监听它的回调
        self.app.hook_wx_method("getUserProfile", callback=callback.callback)
        self.app.get_current_page().get_element("#getUserProfile").tap()  # 触发获取用户授权弹窗
        self.native.allow_get_user_info()  # 允许授权
        self.assertTrue(callback.wait_called(timeout=10), "callback called")
        self.assertDictContainsSubset({"errMsg": "getUserProfile:ok"}, callback.get_callback_result())
```

---

## allow_get_location() :id=allow_get_location

> 处理获取位置信息确认弹框

> 开发者工具支持, 开发者工具版本在`1.06.2211072`以下的需要配置[IDE的mock_native_modal配置项](https://minitest.weixin.qq.com/#/minium/Python/framework/config#IDE的mock_native_modal配置项)

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|answer|bool|True|True 或 False|

**Returns:**

- `None`

**代码示例:**

```python {"id":"01HKM3JMGH3R7WZFYMZ4RHGX3H"}
import minium, threading
from minium import Callback
@minium.ddt_class(testNameFormat="%(name)s_%(index)s")
class TestNative(minium.MiniTest):
    @classmethod
    def setUpClass(cls) -> None:
        super().setUpClass()
        cls.mini.clear_auth()   # 先清空授权才会弹窗
    
    def setUp(self) -> None:
        super().setUp()
        if self.page.path != "/pages/testnative/testnative":
            self.app.redirect_to("/pages/testnative/testnative")

    def test_allow_get_location(self):
        callback = Callback()  # 监听回调, 阻塞当前主线程

        # 获取地理位置信息会调用wx.getLocation接口，先监听它的回调
        self.app.hook_wx_method("getLocation", callback=callback.callback)
        self.app.get_current_page().get_element("#testGetLocation").tap()  # 触发获取地理位置逻辑
        self.native.allow_get_location()  # 允许获取用户地理位置
        self.assertTrue(callback.wait_called(timeout=10), "callback called")
        # getLocation:fail:ERROR_SERVER_NOT_LOCATION : 手机使用5g可能会报这个错误，但不是接口问题，pass
        if callback.get_callback_result()["errMsg"] == "getLocation:fail:ERROR_SERVER_NOT_LOCATION":
            self.logger.error("getLocation:fail:ERROR_SERVER_NOT_LOCATION")
            return
        self.assertDictContainsSubset({"errMsg": "getLocation:ok"}, callback.get_callback_result())
```

---

## allow_get_we_run_data() :id=allow_get_we_run_data

> 处理获取微信运动数据确认弹框

> 开发者工具支持, 开发者工具版本在`1.06.2211072`以下的需要配置[IDE的mock_native_modal配置项](https://minitest.weixin.qq.com/#/minium/Python/framework/config#IDE的mock_native_modal配置项)

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|answer|bool|True|True 或 False|

**Returns:**

- `None`

**代码示例:**

```python {"id":"01HKM3JMGH3R7WZFYMZ6RHHDJW"}
import minium, threading
from minium import Callback
@minium.ddt_class(testNameFormat="%(name)s_%(index)s")
class TestNative(minium.MiniTest):
    @classmethod
    def setUpClass(cls) -> None:
        super().setUpClass()
        cls.mini.clear_auth()   # 先清空授权才会弹窗
    
    def setUp(self) -> None:
        super().setUp()
        if self.page.path != "/pages/testnative/testnative":
            self.app.redirect_to("/pages/testnative/testnative")

    def test_allow_get_we_run_data(self):
        # 先看看微信运动的授权状态, 如果已经拒绝授权，则该case需要报错才能通过
        except_fail = False
        try:
            ret = self.app.call_wx_method("getSetting", [{}]).get("result", {}).get("result")
            authSetting = ret.get("authSetting", None)
            if authSetting and authSetting.get("scope.werun") == False:
                except_fail = True
        except:
            except_fail = True
        callback = Callback()  # 监听回调, 阻塞当前主线程
        ret = {"errMsg": ""}

        # 获取微信运动信息会调用wx.getWeRunData接口，先监听它的回调
        self.app.hook_wx_method("getWeRunData", callback=callback.callback)
        self.app.get_current_page().get_element("#testGetWeRunData").tap()  # 触发获取用户微信运动信息
        print("before allow %f" % time.time())
        self.native.allow_get_we_run_data()  # 允许
        print("after allow %f" % time.time())
        self.assertTrue(callback.wait_called(timeout=30), "callback called")
        if except_fail:
            self.assertIn("getWeRunData:fail", ret["errMsg"])
        else:
            self.assertDictContainsSubset({"errMsg": "getWeRunData:ok"}, ret)
```

---

## allow_record() :id=allow_record

> 处理获取录音权限确认弹框

> 开发者工具支持, 开发者工具版本在`1.06.2211072`以下的需要配置[IDE的mock_native_modal配置项](https://minitest.weixin.qq.com/#/minium/Python/framework/config#IDE的mock_native_modal配置项)

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|answer|bool|True|True 或 False|

**Returns:**

- `None`

__代码示例见[`allow_authorize`](#allow_authorize)__

---

## allow_write_photos_album() :id=allow_write_photos_album

> 处理获取保存相册确认弹框

> 开发者工具支持, 开发者工具版本在`1.06.2211072`以下的需要配置[IDE的mock_native_modal配置项](https://minitest.weixin.qq.com/#/minium/Python/framework/config#IDE的mock_native_modal配置项)

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|answer|bool|True|True 或 False|

**Returns:**

- `None`

__代码示例见[`allow_authorize`](#allow_authorize)__

---

## allow_camera() :id=allow_camera

> 处理使用摄像头确认弹框

> 开发者工具支持, 开发者工具版本在`1.06.2211072`以下的需要配置[IDE的mock_native_modal配置项](https://minitest.weixin.qq.com/#/minium/Python/framework/config#IDE的mock_native_modal配置项)

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|answer|bool|True|True 或 False|

**Returns:**

- `None`

__代码示例见[`allow_authorize`](#allow_authorize)__

---

## allow_send_subscribe_message() :id=allow_send_subscribe_message

> 处理订阅信息授权弹窗

> 开发者工具支持, 开发者工具版本在`1.06.2211072`以下的需要配置[IDE的mock_native_modal配置项](https://minitest.weixin.qq.com/#/minium/Python/framework/config#IDE的mock_native_modal配置项)

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|answer|bool|True|True 或 False|

**Returns:**

- `None`

__代码示例见[`allow_authorize`](#allow_authorize)__

---

## allow_get_user_phone() :id=allow_get_user_phone

> 处理获取用户手机号码确认弹框

> 开发者工具版本在`1.06.2211072`以上支持

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|answer|bool|True|True 或 False|

**Returns:**

- `None`

**代码示例:**

```python {"id":"01HKM3JMGH3R7WZFYMZ7966GS0"}
import minium, threading
from minium import Callback
@minium.ddt_class(testNameFormat="%(name)s_%(index)s")
class TestNative(minium.MiniTest):
    @classmethod
    def setUpClass(cls) -> None:
        super().setUpClass()
        cls.mini.clear_auth()   # 先清空授权才会弹窗
    
    def setUp(self) -> None:
        super().setUp()
        if self.page.path != "/pages/testnative/testnative":
            self.app.redirect_to("/pages/testnative/testnative")

    def test_allow_get_user_phone(self):
        """
        测试号可能没有绑定手机
        """
        callback = Callback()  # 监听回调, 阻塞当前主线程
        detail = errMsg = None

        # 用户同意小程序获取他的手机号后, 会回调绑定在页面的方法, 先监听回调函数以获取回调详情
        self.app.hook_current_page_method("testGetPhoneNumber", callback)
        self.app.get_current_page().get_element("#testGetPhoneNumber").tap()  # 向用户发起授权申请
        if self.native.handle_modal("取消", title="微信帐号还没有绑定手机号"):  # 没绑定，会回调fail
            self.assertTrue(callback.wait_called(timeout=10), "callback called")
            self.assertIn("getPhoneNumber:fail", errMsg)
        else:  # 有绑定，需要点击弹窗
            self.native.allow_get_user_phone()  # 允许授权
            self.assertTrue(callback.wait_called(timeout=10), "callback called")
            self.assertDictContainsSubset({"errMsg": "getPhoneNumber:ok"}, detail)
```

---

## handle_modal() :id=handle_modal

> 处理模态弹窗. `wx.showModal`接口调用/其他小程序提醒弹窗

> 开发者工具支持, 开发者工具版本在`1.06.2211072`以下的需要配置[IDE的mock_native_modal配置项](https://minitest.weixin.qq.com/#/minium/Python/framework/config#IDE的mock_native_modal配置项)

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|btn_text|str or bool|确定|根据传入的 btn_text 进行点击. 如果传入bool值, True: 确定, False: 取消|
|title|str|None|传入弹窗的 title 可以校验当前弹窗是否为预期弹窗|

**Returns:**

- `None`

**代码示例:**

```python {"id":"01HKM3JMGH3R7WZFYMZ7H95J5C"}
import minium, threading, time
from minium import Callback
@minium.ddt_class(testNameFormat="%(name)s_%(index)s")
class TestNative(minium.MiniTest):    
    def setUp(self) -> None:
        super().setUp()
        if self.page.path != "/pages/testnative/testnative":
            self.app.redirect_to("/pages/testnative/testnative")

    def test_handle_modal(self):
        callback = Callback()  # 监听回调, 阻塞当前主线程
            
        # 监听showModal回调, 确认由弹窗弹出
        self.app.hook_wx_method("showModal", callback=callback.callback)
        self.page.get_element("#testModal").tap()  # 触发弹窗
        time.sleep(2)
        self.native.handle_modal("确定")  # 点击弹窗的"确定"按钮
        is_called = callback.wait_called(timeout=10)
        self.app.release_hook_wx_method("showModal")
        self.assertTrue(is_called, "callback called")
        self.assertDictContainsSubset({"errMsg": "showModal:ok", "cancel": False, "confirm": True}, callback.get_callback_result())
```

---

## handle_action_sheet() :id=handle_action_sheet

!> 推荐使用[FormElement.pick()](https://minitest.weixin.qq.com/#/minium/Python/api/FormElement?id=pick)

> 处理上拉菜单

> 开发者工具支持, 需要配置[IDE的mock_native_modal配置项](https://minitest.weixin.qq.com/#/minium/Python/framework/config#IDE的mock_native_modal配置项)

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|item|str|Not None|要选择的 item|

**Returns:**

- `None`

**代码示例:**

```python {"id":"01HKM3JMGH3R7WZFYMZ8XNB9X6"}
import minium, threading, time
from minium import Callback
@minium.ddt_class(testNameFormat="%(name)s_%(index)s")
class TestNative(minium.MiniTest):    
    def setUp(self) -> None:
        super().setUp()
        if self.page.path != "/pages/testnative/testnative":
            self.app.redirect_to("/pages/testnative/testnative")

    @minium.ddt_case(
        ("A", {"errMsg": "showActionSheet:ok", "tapIndex": 0}),
        ("测试", {"errMsg": "showActionSheet:ok", "tapIndex": 1}),
        ("C", {"errMsg": "showActionSheet:ok", "tapIndex": 2}),
        ("取消", {"errMsg": "showActionSheet:fail cancel"}),
    )
    def test_handle_action_sheet(self, args):
        [item, cb_args] = args
        callback = Callback()  # 监听回调, 阻塞当前主线程
        # 监听showActionSheet回调, 确认由弹窗弹出
        self.app.hook_wx_method("showActionSheet", callback=callback.callback)
        self.page.get_element("#testActionSheet").tap()  # 触发选择器
        time.sleep(1)
        self.native.handle_action_sheet(item)  # 选择{item}
        is_called = callback.wait_called(timeout=10)
        self.app.release_hook_wx_method("showActionSheet")
        self.assertTrue(is_called, "callback called")
        self.assertDictEqual(cb_args, callback.get_callback_result())
```

---

## handle_alter_before_unload() :id=handle_alter_before_unload

> 处理由wx.enableAlertBeforeUnload引起的弹框

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|answer|bool|True|True 或 False|

**Returns:**

- `bool`

---

## forward_miniprogram() :id=forward_miniprogram

> 通过右上角更多菜单转发小程序

> **开发者工具不支持**

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|name|str|Not None|要分享的人|
|text|str|None|分享携带的内容|
|create_new_chat|bool|True|是否新建聊天|

**Returns:**

- `None`

**代码示例:**

```python {"id":"01HKM3JMGH3R7WZFYMZ93Y0X4E"}
import minium
class TestNative(minium.MiniTest):
    def test_forward_miniprogram(self):
        """
        把当前小程序页面分享给"微信团队" (微信团队是不能分享的，这里只是个例子)
        """
        if self.page.path != "/pages/testnative/testnative":
            self.app.redirect_to("/pages/testnative/testnative")
        self.native.forward_miniprogram("微信团队", "转发发送的文字")
```

---

## forward_miniprogram_inside() :id=forward_miniprogram_inside

> 小程序内触发转发小程序

> **开发者工具不支持**

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|name|str|Not None|要分享的人|
|text|str|None|分享携带的内容|
|create_new_chat|bool|True|是否新建聊天|

**Returns:**

- `None`

**代码示例:**

```xml {"id":"01HKM3JMGH3R7WZFYMZ9HXSWYN"}
<!-- 小程序wxml -->
<button id="testshare" open-type="share">share</button>
```

```python {"id":"01HKM3JMGH3R7WZFYMZA4Q8G72"}
import minium, time
class TestNative(minium.MiniTest):
    def test_forward_miniprogram_inside(self):
        """
        处理由分享按钮弹出的分享窗口
        把当前小程序页面分享给"微信团队"
        """
        if self.page.path != "/pages/testnative/testnative":
            self.app.redirect_to("/pages/testnative/testnative")
        self.page.get_element("#testshare").tap()
        time.sleep(2)
        self.native.forward_miniprogram_inside("微信团队", "转发发送的文字")
```

---

## input_text() :id=input_text

!> 接口将不再维护。推荐使用[FormElement.input()](https://minitest.weixin.qq.com/#/minium/Python/api/FormElement?id=input)

> 给当前获得焦点的 input 输入框输入文字

!> 调用此函数之前必须确保输入框处于输入状态, 部分安卓机器已经不适用
某些 wda 版本密码框输入会失败

> **开发者工具不支持**

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|text|str|None|输入的内容|

**Returns:**

- `None`

---

## input_clear() :id=input_clear

!> 推荐使用[FormElement.input()](https://minitest.weixin.qq.com/#/minium/Python/api/FormElement?id=input)

> 清除当前获得焦点的 input 输入框的文字

!> 调用此函数之前必须确保输入框处于输入状态, 部分安卓机器已经不适用

> **开发者工具不支持**

**Parameters:**

- `None`

**Returns:**

- `None`

---

## textarea_text() :id=textarea_text

!> 推荐使用[FormElement.input()](https://minitest.weixin.qq.com/#/minium/Python/api/FormElement?id=input)

> 给当前获得焦点的 textarea 输入框输入文字, 部分安卓机器已经不适用

> **开发者工具不支持**

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|text|str|None|输入的内容|
|index|int|0|多个 textarea 同时存在一个页面从上往下排序, 计数从 0 开始|

**Returns:**

- `None`

---

## textarea_clear() :id=textarea_clear

!> 推荐使用[FormElement.input()](https://minitest.weixin.qq.com/#/minium/Python/api/FormElement?id=input)

> 清除当前获得焦点的 textarea 输入框的文字, 部分安卓机器已经不适用

> **开发者工具不支持**

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|index|int|0|多个 textarea 同时存在一个页面从上往下排序, 计数从 0 开始|

**Returns:**

- `None`

---

## map_select_location() :id=map_select_location

> 原生地图组件选择位置

> 开发者工具支持, 需要配置[IDE的mock_native_modal配置项](https://minitest.weixin.qq.com/#/minium/Python/framework/config#IDE的mock_native_modal配置项)

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|name|str|None|位置名称|

**Returns:**

- `None`

**代码示例:**

```python {"id":"01HKM3JMGH3R7WZFYMZCVAAHDV"}
import minium, threading
from minium import Callback
@minium.ddt_class(testNameFormat="%(name)s_%(index)s")
class TestNative(minium.MiniTest):
    @classmethod
    def setUpClass(cls) -> None:
        super().setUpClass()
        cls.mini.clear_auth()   # 先清空授权才会弹窗
    
    def setUp(self) -> None:
        super().setUp()
        if self.page.path != "/pages/testnative/testnative":
            self.app.redirect_to("/pages/testnative/testnative")

    def test_map_select_location(self):
        callback = Callback()  # 监听回调, 阻塞当前主线程
        self.app.hook_wx_method("chooseLocation", callback=callback.callback)
        self.page.get_element("#testChooseLocation").tap()
        time.sleep(1)
        self.native.allow_get_location(True)  # 授权获取位置
        self.native.map_select_location("腾讯微信总部")  # 确认选择位置
        expected_res = {
            "errMsg": "chooseLocation:ok",
            "name": "腾讯微信总部",
            "address": "广东省广州市海珠区tit创意园品牌街",
            "latitude": 23.100039,
            "longitude": 113.32456,
        }
        is_called = callback.wait_called(timeout=10)
        self.app.release_hook_wx_method("chooseLocation")
        self.assertTrue(is_called, "callback called")
        self.assertDictContainsSubset(expected_res, callback.get_callback_result())
```

---

## map_back_to_mp() :id=map_back_to_mp

> 原生地图组件查看定位页面,返回小程序

> 开发者工具支持, 需要配置[IDE的mock_native_modal配置项](https://minitest.weixin.qq.com/#/minium/Python/framework/config#IDE的mock_native_modal配置项)

**Parameters:**

- `None`

**Returns:**

- `None`

**代码示例:**

```python {"id":"01HKM3JMGH3R7WZFYMZFA01N35"}
import minium, threading
from minium import Callback
@minium.ddt_class(testNameFormat="%(name)s_%(index)s")
class TestNative(minium.MiniTest):
    @classmethod
    def setUpClass(cls) -> None:
        super().setUpClass()
        cls.mini.clear_auth()   # 先清空授权才会弹窗
    
    def setUp(self) -> None:
        super().setUp()
        if self.page.path != "/pages/testnative/testnative":
            self.app.redirect_to("/pages/testnative/testnative")

    def test_map_back_to_mp(self):
        callback = Callback()  # 监听回调, 阻塞当前主线程
        self.app.hook_wx_method("chooseLocation", callback=callback.callback)
        self.app.get_current_page().get_element("#testChooseLocation").tap()  # 进入地图界面
        time.sleep(1)
        self.native.allow_get_location(True)  # 授权获取位置
        self.native.map_back_to_mp()  # 确认选择位置
        is_called = callback.wait_called(timeout=10)
        self.app.release_hook_wx_method("chooseLocation")
        self.assertTrue(is_called, "callback called")
        self.assertDictContainsSubset({"errMsg": "chooseLocation:fail cancel"}, callback.get_callback_result())
```

---

## deactivate() :id=deactivate

> 使微信进入后台一段时间, 再切回前台

> **开发者工具不支持**

!> iOS 12.0 之后由于 wda 的原因可能不生效

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|duration|int|None|进入后台的时间|

**Returns:**

- `None`

**代码示例:**

```python {"id":"01HKM3JMGH3R7WZFYMZFAMPHC2"}
import minium
class NativeTest(minium.MiniTest):
    def test_deactivate(self):
        self.native.deactivate(10)
```

---

## get_pay_value() :id=get_pay_value

!> IOS因为隐私政策，所以只支持 Android

> 获取支付弹窗中的支付金额

> **开发者工具不支持**

**Parameters:**

- `None`

**Returns:**

- `str`

---

## input_pay_password() :id=input_pay_password

!> IOS因为隐私政策，所以只支持 Android

> 支付弹窗中输入支付密码

> **开发者工具不支持**

**Parameters:**

| 名称 |  类型  | 默认值 | 说明     |
| :--- | :----: | :----: | :------- |
| psw  | str |   无   | 支付密码 |

**Returns:**

- `None`

---

## close_payment_dialog() :id=close_payment_dialog

> 关闭支付弹窗

> 开发者工具版本在`1.06.2211072`以上支持

**Parameters:**

- `None`

**Returns:**

- `None`

---

## text_exists() :id=text_exists

> 检测原生页面上文字是否存在

> **开发者工具不支持**

**Parameters:**

| 名称          | 类型 | 默认值 | 说明                                                |
| :----------- | :-----: | :----: | :-------------------------------------------------- |
| text         | str  |  None  | 需要检测的文字                                      |
| iscontain    | bool | False  | 为False时，完全匹配文本为True时，包含匹配文本 |
| wait_seconds | int  |   5    | 最小等待市场，单位s                                 |

**Returns:**

- `bool`

**代码示例:**

```python {"id":"01HKM3JMGJD9X4HYJKJC3ND1KM"}
import minium, time
class TestNative(minium.MiniTest):    
    def setUp(self) -> None:
        super().setUp()
        if self.page.path != "/pages/testnative/testnative":
            self.app.redirect_to("/pages/testnative/testnative")

    def test_text_exists(self):
        self.page.get_element("#testModal").tap()
        time.sleep(2)
        self.assertTrue(self.native.text_exists("modal", iscontain=True))
        self.assertFalse(self.native.text_exists("modal"))
        self.native.handle_modal("确定")
```

---

## text_click() :id=text_click

> 点击原生页面上的文字

> **开发者工具不支持**

**Parameters:**

| 名称      |  类型   | 默认值 | 说明                                                |
| :-------- | :-----: | :----: | :-------------------------------------------------- |
| text      | str  |  None  | 需要点击的文字                                      |
| iscontain | bool | False  | 为False时，完全匹配文本为True时，包含匹配文本 |

**Returns:**

- `None`

**代码示例:**

```python {"id":"01HKM3JMGJD9X4HYJKJFNYNKKC"}
import minium, time, threading
from minium import Callback
class TestNative(minium.MiniTest):    
    def setUp(self) -> None:
        super().setUp()
        if self.page.path != "/pages/testnative/testnative":
            self.app.redirect_to("/pages/testnative/testnative")

    def test_text_click(self):
        callback = Callback()  # 监听回调, 阻塞当前主线程
            
        self.app.hook_wx_method("showModal", callback=callback.callback)
        self.page.get_element("#testModal").tap()
        time.sleep(2)
        self.native.text_click("确定")
        is_called = callback.wait_called(timeout=10)
        self.app.release_hook_wx_method("showModal")
        self.assertTrue(is_called, "callback called")
        self.assertDictContainsSubset({"errMsg": "showModal:ok", "cancel": False, "confirm": True}, callback.get_callback_result())
```

---

## start_get_perf() :id=start_get_perf

> 获取 CPU 内存 数据

> **开发者工具不支持**

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|timeinterval|int|15|时间间隔，单位s|

**Returns:**

- `None`

**代码示例:**

```python {"id":"01HKM3JMGJD9X4HYJKJG8Q5AKZ"}
import minium, time, json
class TestNative(minium.MiniTest):    
    def setUp(self) -> None:
        super().setUp()
        if self.page.path != "/pages/testnative/testnative":
            self.app.redirect_to("/pages/testnative/testnative")

    def test_get_perf(self):
        self.native.start_get_perf(1)
        time.sleep(20)
        data = json.loads(self.native.stop_get_perf())
        self.assertTrue(len(data) > 0, "have data")
        item = data[int(len(data)/2)]
        self.assertNotEqual(item["cpu"], 0, "cpu not 0")
        self.assertNotEqual(item["mem"], 0, "mem not 0")
```

---

## stop_get_perf() :id=stop_get_perf

> 获取 CPU 内存 数据

> **开发者工具不支持**

**Parameters:**

- `None`

**Returns:**

- `str`: [{"cpu": cpu_data, "mem": mem_data, "timestamp": timestamp}, ... ,]

__代码示例见[start_get_perf](#start_get_perf)__

---

## start_get_fps() :id=start_get_fps

!> 该接口废除，请使用`start_get_perf`和`stop_get_perf`

> **开发者工具不支持**

---

## click_coordinate() :id=click_coordinate

> 点击坐标

> **开发者工具不支持**

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|x|int||横坐标|
|y|int||纵坐标|

**Returns:**

- `None`

---

## select_wechat_avatar() :id=select_wechat_avatar
> 选择微信头像

**Parameters:**

**Returns:**

- `bool`

