# `Class` minium.App :id=minium-App

> `App` 提供小程序应用层面的各种操作, 包括页面跳转, 获取当前页面, 页面栈等功能

可以从[`minium.Minium.app`](https://minitest.weixin.qq.com/#/minium/Python/api/Minium)或从[`minium.MiniTest.app`](https://minitest.weixin.qq.com/#/minium/Python/framework/Minitest)获得`App`实例

**Properties:**

|名称| 类型| 默认值| 说明|
| :----- | ----- | :-----: | :----- |
|app_id|str|None|当前项目appid|
|current_page|[Page](https://minitest.weixin.qq.com/#/minium/Python/api/Page)|None|当前页面|

---

## screen_shot() :id=screen_shot
>  截图

!> ide上仅能截取到wxml页面的内容，Modal/Actionsheet/授权弹窗等无法截取

!> 公共库 2.10.0 开始生效

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|save_path|str|Not None| 截图保存路径|
|format|str|raw| 截图数据返回格式，raw 或者 pillow|

**Returns:**
-   raw or pillow data

**代码示例:**

``` python
#!/usr/bin/env python3
import minium, os
class AppTest(minium.MiniTest):
	def test_screen_shot(self):
        output_path = os.path.join(os.path.dirname(__file__), "outputs/test_screen_shot.png")
        if not os.path.isdir(os.path.dirname(output_path)):
            os.mkdir(os.path.dirname(output_path))
        if os.path.isfile(output_path):
            os.remove(output_path)
        ret = self.app.screen_shot(output_path)  # 截图并存到`output_path`文件夹中
        self.assertTrue(os.path.isfile(output_path))
        os.remove(output_path)
```


<!-- --- 该接口在case中没什么实际意义，去掉

## exit() :id=exit
> 退出小程序

!> 基础库 2.7.6 开始支持

**Returns:**
- `None`

**代码示例:**

``` python
#!/usr/bin/env python3
import minium
class AppTest(minium.MiniTest):
	def test_exit(self):
        self.app.exit()
``` -->

---

## enable_log() :id=enable_log
> 启动小程序日志事件, 打开开关后, 小程序console中打印的日志会回传

> case中调用无意义

**Returns:**
- `None`


---

## add_observer() :id=add_observer
> 监听小程序的事件

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|event|str|Not None|需要监听的事件|
|callback|func|Not None|收到事件后的回调函数|

**Returns:**
- `None`

**代码示例见[`enable_log`](#enable_log)**

---

## remove_observer() :id=remove_observer
> 移除小程序事件监听

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|event|str|Not None|需要监听的事件|
|callback|func|None|对应[`add_observer`](#add_observer)指定的监听函数，不传则移除该事件所有监听函数|

**Returns:**
- `None`

**代码示例见[`enable_log`](#enable_log)**

---

## evaluate() :id=evaluate
> 向 app Service 层注入代码并执行

> 真机调试2.0下, 注入的代码只支持es5的语法

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|app_function|str|Not None|代码字符串|
|args|list|Not None|参数|
|sync|bool|False|是否同步执行|

**Returns:**

- sync == True: dict(result={"result": 函数返回值})
- sync == False: str(消息ID)。配合[`get_async_response`](#get_async_response)使用获取返回值

**代码示例:**
```python
import minium

# sync == True
@minium.ddt_class
class TestApp(minium.MiniTest):
    @minium.ddt_case([], ["1", "2"])
    def test_evaluate_sync(self, args):
        result = self.app.evaluate(
            "function(){args=arguments;return 'test evaluate: '.concat(Array.from(args));}", args, sync=True
        )
        self.assertEqual(
            result.get("result", {}).get("result"), "test evaluate: {}".format(",".join(args))
        )
```

---

## get_async_response() :id=get_async_response
> 获取`evaluate`方法异步调用的结果

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|msg_id|str|Not None|`evaluate`返回的消息ID|
|timeout|int|None|等待超时时间，None: 立刻返回|

**Returns:**
- `None` or Dict

**代码示例:**
```python
import minium

# sync == False
@minium.ddt_class
class TestApp(minium.MiniTest):
    @minium.ddt_case([], ["1", "2"])
    def test_evaluate_async(self, args):
        msg_id = self.app.evaluate(
            "function(){args=arguments;return 'test evaluate: '.concat(Array.from(args));}", args, sync=False
        )
        # 你可以做一些其他操作后, 再通过get_async_response方法获取前面注入代码的运行结果
        result = self.app.get_async_response(msg_id, 5)
        self.assertEqual(
            result.get("result", {}).get("result"), "test evaluate: {}".format(",".join(args))
        )
```

---

## expose_function() :id=expose_function
> 在 AppService 全局暴露方法，供小程序侧调用测试脚本中的方法，类似在开发者工具console pannel中运行代码

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|name|str|Not None|供小程序调用的方法名字|
|binding_function|list|Not None|脚本中的方法实现|

**Returns:**

- dict(name=f"{name}", args=[调用方法的参数])

**代码示例:**

``` python
#!/usr/bin/env python3
import minium
from minium import Callback
class AppTest(minium.MiniTest):
    def test_expose_function(self):
        callback = Callback()

        self.app.expose_function("test_expose_function", callback.callback)
        self.app.evaluate("function(){test_expose_function.apply(this, arguments)}", expected_args, sync=True)
        self.assertTrue(callback.wait_called(timeout=10), "有回调")  # 有信号量, 证明10s内有回调
        self.assertListEqual(callback.get_callback_result(), expected_args, "回参一致")
```

---

## on_exception_thrown() :id=on_exception_thrown
> 监听小程序 js 层的错误，报错的时候执行回调

> 与体验评分功能冲突, 开启体验评分后将不能收到报错回调

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|func|function|Not None|错误回调|

**Returns:**

- {"message": err_msg, "stack": err_stack}

**代码示例:**

```python
#!/usr/bin/env python3
import minium
class AppTest(minium.MiniTest):
	def test_on_exception_thrown(self):
        is_exception_thrown = threading.Semaphore(0)  # 监听回调, 阻塞当前主线程
        e = None
        def on_exception(err):
            nonlocal e
            is_exception_thrown.release()
            e = err

        self.app.on_exception_thrown(on_exception)
        try:
            self.app.navigate_to("/pages/exception_page/exception_page")  # 进入页面会throw error
        except:
            pass
        self.assertTrue(is_exception_thrown.acquire(timeout=10), "监听到报错")
        self.assertTrue(is_exception_thrown.acquire(timeout=10), "监听到第二次报错")
        self.assertEqual(e.message, "thisonload is not defined")
        self.assertIsNotNone(e.stack, "stack not empty")
```

---

## call_wx_method() :id=call_wx_method
> 调用[小程序的API](https://developers.weixin.qq.com/miniprogram/dev/api/)

!> 非`wx.xxxSync`函数都会等到complete回调之后返回

**Parameters:**

!> 无需传递 success 与 fail 回调，fail 时直接当成调用错误

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|method|str|Not None|函数名|
|args|dict|None|参数|
|plugin_appid|str|"auto"|`"auto"`: 如果当前page是插件页，自动填充appid; <br>`"{appid}"`: 调用该插件环境下的wx.{method}; <br>`None`: 调用小程序环境下的wx.{method}|

**Returns:**

- dict(result={"result": success回调对象})

**代码示例:**
```python
#!/usr/bin/env python3
import minium
class AppTest(minium.MiniTest):
	def test_call_wx_method(self):
        # 调用wx.getSystemInfo接口获取systemInfo
        sys_info = self.app.call_wx_method("getSystemInfo").get("result", {}).get("result")
        self.assertIsInstance(sys_info, dict, "is dict")
        self.assertTrue(True if sys_info else False, "not empty")
```

---

## mock_wx_method() :id=mock_wx_method
> mock小程序API的调用，能mock的函数参考[小程序的API](https://developers.weixin.qq.com/miniprogram/dev/api/)。

!> 该接口只能mock`wx.xxx`的调用, 如果小程序在启动时保存了接口引用/采取了proxy模式调用接口则可能mock失败，如`const request = wx.request; /* 使用mock_wx_method方法mock request接口 */; request({url: "xxx"})`

> minium v1.4.5后, 实现方式请参考[关于mock&hook能力说明](https://minitest.weixin.qq.com/#/minium/Python/framework/mock)

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|method|str|Not None|函数名|
|functionDeclaration|str|None|functionDeclaration函数名|
|result|str\|dict|None|mock之后回调的结果|
|args|str\|dict|None|functionDeclaration函数的参数，functionDeclaration不为None时生效|
|success|bool|True| 触发回调类型，success or fail，result 为 str 时生效|
|plugin_appid|str|"auto"|`"auto"`: 如果当前page是插件页，自动填充appid; <br>`"{appid}"`: mock该插件环境下的wx.{method}; <br>`None`: mock小程序环境下的wx.{method}|

> 输入的 result 为 dict 时，相当于自定义一个完整的 wx method 返回结果，有比较高的自由度

**Returns:**
- `None`

**代码实例:**
```python
#!/usr/bin/env python3
import minium
@minium.ddt_class(testNameFormat="%(name)s_%(index)s")
class AppTest(minium.MiniTest):
	@minium.ddt_unpack
    @minium.ddt_case(
        # mock result
        ("getStorage", None, None, {"data": "test test test"}),
        # mock function and match key
        ("getStorage", """function(options,defval){
		    if(options.key==='test_mock') return {data:'1111'}
		    if(options.key==='sex') return {data:'male'}
		    return {data:defval}
		  }""", "unknow", {"data": "1111"}),
        # mock function and not match key
        ("getStorage", """function(options,defval){
		    if(options.key==='name') return {data:'1111'}
		    if(options.key==='sex') return {data:'male'}
		    return {data:defval}
		  }""", "unknow", {"data": "unknow"}),
    )
    def test_mock_and_restore_wx_method(self, method, functionDeclaration, args, result):
        try:
            current_value = (
                self.app.call_wx_method(method, {"key": "test_mock"}).get("result").get("result")
            )
        except minium.MiniAppError as e:
            current_value = e
        if functionDeclaration:
            # 有functionDeclaration情况下 result参数是预期返回
            self.app.mock_wx_method(method, functionDeclaration=functionDeclaration, args=args)
        else:
            self.app.mock_wx_method(method, result=result)
        mock_value = (
            self.app.call_wx_method(method, {"key": "test_mock"}).get("result").get("result")
        )
        self.app.restore_wx_method(method)
        self.assertDictEqual(mock_value, result, "mock success")
        if isinstance(current_value, minium.MiniAppError):
            self.assertRaises(
                minium.MiniAppError, self.app.call_wx_method, method, {"key": "test_mock"}
            )
        else:
            real_value = (
                self.app.call_wx_method(method, {"key": "test_mock"}).get("result").get("result")
            )
            self.assertDictEqual(real_value, current_value, "restore success")
```

---

## restore_wx_method() :id=restore_wx_method
> 去掉函数的mock

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|method|str|Not None|函数名|

**Returns:**
- `None`

**代码实例见[mock_wx_method](#mock_wx_method)**

---

## hook_wx_method() :id=hook_wx_method
> hook小程序API的调用，能hook的函数参考[小程序的API](https://developers.weixin.qq.com/miniprogram/dev/api/)。

!> 该接口只能hook`wx.xxx`的调用, 如果小程序在启动时保存了接口引用/采取了proxy模式调用接口则可能hook失败，如`const request = wx.request; /* 使用hook_wx_method方法hook request接口 */; request({url: "xxx"})`

> minium v1.4.5后, 实现方式请参考[关于mock&hook能力说明](https://minitest.weixin.qq.com/#/minium/Python/framework/mock)


**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|method|str|Not None|函数名|
|before|func|None|在需要 hook 的方法之前调用, 监听函数能获取方法传入的参数.|
|after|func|None|在需要 hook 的方法之后调用, 监听函数能获取方法的返回值.|
|callback|func|None|在需要 hook 的方法回调之后调用, 监听函数能获取方法的回调值|


**Returns:**
- `None`

**代码实例:**
```python
#!/usr/bin/env python3
import minium
from minium import Callback
@minium.ddt_class(testNameFormat="%(name)s_%(index)s")
class AppTest(minium.MiniTest):
	    @minium.ddt_case(
        (
            "setStorage",
            {
                "data": c_time,
                "key": "test_storage",
            },
            None,
            {"errMsg": "setStorage:ok"}
        ),
        ("getStorageSync", "test_storage", c_time, None),
        (
            "getStorage", 
            {
                "key": "test_storage",
            }, None,
            {"errMsg": "getStorage:ok", "data": c_time}),
    )
    def test_hook_and_restore_wx_method(self, data):
        [method_name, input_args, expected_return, expected_callback] = data

        before = Callback()     # 创建接口调用前callback实例
        after = Callback()      # 创建接口调用前callback实例
        callback = Callback()   # 创建接口调用前callback实例

        self.app.hook_wx_method(method_name, before=before, after=after, callback=callback)
        self.app.call_wx_method(method_name, input_args)
        self.assertTrue(before.wait_called(timeout=10), "before called")
        self.assertTrue(after.wait_called(timeout=10), "after called")
        if not method_name.endswith("Sync"):
            self.assertTrue(callback.wait_called(timeout=10), "callback called")
            if isinstance(expected_callback, dict):
                self.assertDictEqual(expected_callback, callback.get_callback_result(), "callback ok")
            else:
                self.assertEqual(expected_callback, callback.get_callback_result(), "callback ok")
        if isinstance(input_args, dict):
            self.assertDictEqual(input_args, before.get_callback_result(), "before ok")
        else:
            self.assertEqual(input_args, before.get_callback_result(), "before ok")
        if isinstance(expected_return, dict):
            self.assertDictEqual(expected_return, after.get_callback_result(), "after ok")
        else:
            self.assertEqual(expected_return, after.get_callback_result(), "after ok")
        # 释放hook，不应再有回调
        self.app.release_hook_wx_method(method_name)
        self.app.call_wx_method(method_name, input_args)
        self.assertFalse(before._Callback__called.acquire(timeout=5), "before 不应再有回调")
        self.assertFalse(after._Callback__called.acquire(timeout=5), "after 不应再有回调")
        if not method_name.endswith("Sync"):
            self.assertFalse(callback._Callback__called.acquire(timeout=5), "callback 不应再有回调")
```
---

## release_hook_wx_method() :id=release_hook_wx_method
> 释放hook小程序API的调用。


**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|method|str|Not None|函数名|


**Returns:**
- `None`

**代码实例见[hook_wx_method](#hook_wx_method)**

---

## hook_current_page_method() :id=hook_current_page_method
> hook当前页面上的方法。<br>如 `button` 上 `bindtap="testtap"`, `hook_current_page_method("testtap", callback)`即可在点击按钮时获得回调 


**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|method|str|Not None|方法名|
|callback|func|None|方法被调用前回调函数|


**Returns:**
- `None`

**代码实例:**

```python
import minium, threading
from minium import Callback
@minium.ddt_class
class TestApp(minium.MiniTest):
    def test_hook_current_page_method(self):
        self.app.redirect_to("/pages/testapp/testapp")
        excepted_callback_args = {"test": 1}
        callback = Callback()

        self.app.hook_current_page_method("testpagehook", callback.callback)
        self.app.current_page.call_method("testpagehook", [excepted_callback_args])
        self.assertTrue(callback.wait_called(timeout=10), "callback called")
        if isinstance(excepted_callback_args, dict):
            self.assertDictEqual(
                excepted_callback_args, callback.get_callback_result(), "callback ok"
            )
        else:
            self.assertEqual(excepted_callback_args, callback.get_callback_result(), "callback ok")
```

---

## release_hook_current_page_method() :id=release_hook_current_page_method
> 释放当前页面方法的监听函数。


**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|method|str|Not None|函数名|


**Returns:**
- `None`

---

## mock_request() :id=mock_request
> mock `wx.request` 方法，根据正则匹配结果返回特定构造的数据. 匹配顺序与调用顺序一致（先加入的规则先匹配）

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|rule|str\|dict|Not None|规则，如类型为str，则默认匹配`url`|
|success|dict|None|成功回调结果，与参数`fail`需二选一|
|fail|str\|dict|None|失败回调结果，如类型为str，会自动填充成基础库返回格式，与参数`success`需二选一|
|reverse|bool|False|True: 优先匹配当前规则; False: 优先匹配前面加入的规则|

***PS: rule 匹配说明:***
- rule中规定每个字段需要匹配的正则表达式
- 如有规则: `{"url": "aaa", "data": {"content": "\\d+"}}`
- 小程序调用`wx.request({url: url, data: data})`, `url`需要为包含"aaa", `data`中需要包含`content`字段并值为纯数字字符串, 才能匹配该规则, 如`{url: "bbaaac", data: {content: "123"}}`
- 如果需要匹配 url 中 某些query 参数, 如`url = "https://weixin.qq.com/abc?a=1&b=b1b&c=3"`, 其中`c`可以忽略, `a`必须为数字, `b`可以是任意非空参数, rule 可以这样写: `{"url": "https://weixin.qq.com/abc", "params": {"a": r"\d+", "b": "*"}}`

**Returns:**
- `None`

**代码实例:**
```python
#!/usr/bin/env python3
import minium
class RequestTest(minium.MiniTest):
    def test_mock_request(self):
        self.app.restore_request()  # 清空规则
        mock_resp1 = {"data": "mock result1", "statusCode": 200}
        mock_resp2 = {"data": "mock result2", "statusCode": 200}
        mock_resp3 = {"data": "mock result3", "statusCode": 200}
        rule1 = ".*/SendMsg\\?.*"
        url1 = "http://minitest.weixin.qq.com/SendMsg?content=test"
        rule2 = {"url": ".*/SendMsg$"}
        url2 = "http://minitest.weixin.qq.com/SendMsg"
        rule3 = {"url": ".*/SendMsg.*", "data": {"content": "^\\d+$"}}
        url3 = "http://minitest.weixin.qq.com/SendMsgData"
        data = {"content": "12557"}
        # 加入规则1
        self.app.mock_request(rule1, success=mock_resp1)
        result = self.app.call_wx_method("request", [{"url": url1}]).get("result", {}).get("result")
        self.assertDictEqual(result, mock_resp1)                # 返回mock1的数据
        with self.assertRaises(minium.MiniAppError):
            self.app.call_wx_method("request", [{"url": url2}]) # 规则不匹配，调用原request方法
        # 加入规则2
        self.app.mock_request(rule2, success=mock_resp2)
        result = self.app.call_wx_method("request", [{"url": url2}]).get("result", {}).get("result")
        self.assertDictEqual(result, mock_resp2)                # 返回mock2的数据
        # 加入规则3
        self.app.mock_request(rule3, success=mock_resp3)
        result = self.app.call_wx_method("request", [{"url": url2, "data": data}]).get("result", {}).get("result")
        self.assertDictEqual(result, mock_resp2)                # 虽然与规则3也匹配，但优先匹配规则2，返回mock2的数据
        result = self.app.call_wx_method("request", [{"url": url3, "data": data}]).get("result", {}).get("result")
        self.assertDictEqual(result, mock_resp3)                # 返回mock3的数据
```

---

## mock_request_once() :id=mock_request_once
> mock `wx.request` 方法，根据正则匹配结果返回特定构造的数据. 匹配顺序与调用顺序一致（先加入的规则先匹配）. 一旦匹配到一个请求，该规则失效，不需要再调用`restore_request`方法清除规则

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|rule|str\|dict|Not None|规则，如类型为str，则默认匹配`url`|
|success|dict|None|成功回调结果，与参数`fail`需二选一|
|fail|str\|dict|None|失败回调结果，如类型为str，会自动填充成基础库返回格式，与参数`success`需二选一|

**Returns:**
- `None`

---

## restore_request() :id=restore_request
> 清除掉所有mock request的匹配规则

**Parameters:**
- `None`

**Returns:**
- `None`

**代码实例见[mock_request](#mock_request)**

---

## get_all_pages_path() :id=get_all_pages_path
> 获取所有已配置的页面路径

**Returns:** 
- `list`

**代码实例:**
```python
import minium
class AppTest(minium.MiniTest):
    def test_get_all_pages_path(self):
        all_pages_path = self.app.get_all_pages_path()
        self.assertListEqual(
            [
                "pages/index/index",
                "pages/mine/mine",
                "pages/login/wechatlogin",
                "pages/login/selflogin",
                "pages/testapp/testapp",
                "pages/testpage/testpage",
                "pages/testelement/testelement",
                "pages/testnative/testnative",
                "pages/exception_page/exception_page"
            ],
            all_pages_path,
            "test ok",
        )
```

---

## get_current_page() :id=get_current_page
> 获取当前顶层页面

**Returns:** 
- [Page](https://minitest.weixin.qq.com/#/minium/Python/api/Page)

**代码实例:**
```python
import minium
class AppTest(minium.MiniTest):
    def test_get_current_page(self):
        page = self.app.get_current_page()  # 同self.app.current_page
        self.assertIsNotNone(page.path)
        self.assertNotEqual("", page.path)
```

---

## get_page_stack() :id=get_page_stack
> 获取当前小程序页面栈

**Returns:** 
- list[[Page](https://minitest.weixin.qq.com/#/minium/Python/api/Page)]

**代码实例:**
```python
import minium
class AppTest(minium.MiniTest):
    def test_get_page_stack(self):
        self.app.go_home()
        page1 = self.app.get_current_page()
        self.app.navigate_to("/pages/testapp/testapp")
        pages = self.app.get_page_stack()
        self.assertEqual("/pages/testapp/testapp", pages[1].path)
        self.assertEqual(page1.path, pages[0].path)
```

---

## go_home() :id=go_home
> 跳转到小程序首页

**Returns:** 
- [Page](https://minitest.weixin.qq.com/#/minium/Python/api/Page)

---

## navigate_to() :id=navigate_to
> 以导航的方式跳转到指定页面

!> 不能跳到 tabbar 页面。支持相对路径和绝对路径, 小程序中页面栈最多十层

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|url|str|Not None|页面路径|
|params|dict|None|页面参数|
|is_wait_url_change|bool|True|是否等待新的页面跳转|

*PS: 页面路径规则：*

- /page/tabBar/API/index: 绝对路径,最前面为/
- tabBar/API/index: 相对路径, 会被拼接在当前页面父节点的路径后面

**路径后可以带参数。参数与路径之间使用 ? 分隔，参数键与参数值用 = 相连，不同参数用 & 分隔；如 'path?key=value&key2=value2'**

**Returns:** 
- [Page](https://minitest.weixin.qq.com/#/minium/Python/api/Page)

**代码实例:**
```python
import minium
class AppTest(minium.MiniTest):
    def test_navigate_to_and_back(self):
        pass_page = self.app.get_current_page()
        query = {"value1": "1", "value2": "dd"}
        page = self.app.navigate_to("/pages/testapp/testapp", query)
        current_page = self.app.get_current_page()
        self.assertEqual("/pages/testapp/testapp", page.path)
        self.assertDictEqual(query, page.query)
        self.assertDictEqual(current_page.query, page.query)
        self.app.navigate_back()
        page = self.app.get_current_page()
        self.assertEqual(pass_page.path, page.path)
        self.assertDictEqual(pass_page.query, page.query)
```

---

## navigate_back() :id=navigate_back
> 关闭当前页面，返回上一页面或多级页面。

!> 如果超出当前页面栈最大层数，返回首页

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|delta|int|1|返回的层数|


**Returns:** 
- [Page](https://minitest.weixin.qq.com/#/minium/Python/api/Page)

**代码实例见[navigate_to](#navigate_to)**

---

## redirect_to() :id=redirect_to
> 关闭当前页面，重定向到应用内的某个页面

!> 不允许跳转到 tabbar 页面

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|url|str|Not None|页面路径|
|params|dict|None|页面参数|
|is_wait_url_change|bool|True|是否等待新的页面跳转|

*PS: 页面路径规则：*

- /page/tabBar/API/index: 绝对路径,最前面为/
- tabBar/API/index: 相对路径, 会被拼接在当前页面父节点的路径后面

**路径后可以带参数。参数与路径之间使用 ? 分隔，参数键与参数值用 = 相连，不同参数用 & 分隔；如 'path?key=value&key2=value2'**

**Returns:** 
- [Page](https://minitest.weixin.qq.com/#/minium/Python/api/Page)

**代码实例:**
```python
import minium
class AppTest(minium.MiniTest):
    def test_redirect_to(self):
        pages = self.app.get_page_stack()
        query = {"value1": "1", "value2": "dd"}
        self.app.redirect_to("/pages/testapp/testapp", query)
        page = self.app.get_current_page()
        self.assertEqual("/pages/testapp/testapp", page.path)
        self.assertDictEqual(query, page.query)
        self.assertEqual(len(pages), len(self.app.get_page_stack()), "len not change")
```

---

## relaunch() :id=relaunch
> 关闭所有页面，打开到应用内的某个页面

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|url|str|Not None|页面路径|
|params|dict|None|页面参数|
|is_wait_url_change|bool|True|是否等待新的页面跳转|

*PS: 页面路径规则：*

- /page/tabBar/API/index: 绝对路径,最前面为/
- tabBar/API/index: 相对路径, 会被拼接在当前页面父节点的路径后面

**路径后可以带参数。参数与路径之间使用 ? 分隔，参数键与参数值用 = 相连，不同参数用 & 分隔；如 'path?key=value&key2=value2'**

**Returns:** 
- [Page](https://minitest.weixin.qq.com/#/minium/Python/api/Page)

**代码实例:**
```python
import minium
class AppTest(minium.MiniTest):
    def test_relaunch(self):
        self.app.navigate_to("/pages/testpage/testpage")
        query = {"value1": "1", "value2": "dd"}
        self.app.relaunch("/pages/testpage/testpage", query)
        pages = self.app.get_page_stack()
        self.assertEqual(1, len(pages))
        page = pages[0]
        self.assertEqual("/pages/testpage/testpage", page.path)
        self.assertDictEqual(query, page.query)
```

---

## switch_tab() :id=switch_tab
> 跳转到 tabBar 页面

!> 会关闭其他所有非 tabBar 页面

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|url|str|Not None|需要跳转的 tabBar 页面的路径（需在 app.json 的 tabBar 字段定义的页面），路径后不能带参数|
|is_click|bool|False|切换tab的时候触发一次`onTabItemTap`|


**Returns:** 
- [Page](https://minitest.weixin.qq.com/#/minium/Python/api/Page)

**代码实例:**
```python
import minium
class AppTest(minium.MiniTest):
    def test_switch_tab(self):
        self.app.switch_tab("/pages/mine/mine")
        page = self.app.current_page
        self.assertEqual("/pages/mine/mine", page.path)
```

---

## go_to() :id=go_to
> 进入目标页面; 如果当前页面不是目标页面, 则relaunch

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|url|str|Not None|页面路径|
|params|dict|None|页面参数|
|is_wait_url_change|bool|True|是否等待新的页面跳转|

**Returns:** 
- [Page](https://minitest.weixin.qq.com/#/minium/Python/api/Page)

---

## get_perf_time() :id=get_perf_time
> 查询小程序的性能指标，跟stop_get_perf_time配对使用，2.11.0开始支持

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|entry_types|list|Not None|可选项为['render', 'script', 'navigation', 'loadPackage']中的1个或多个|

**Returns:**
- `None`

**代码实例见[stop_get_perf_time](#stop_get_perf_time)**

---

## stop_get_perf_time() :id=stop_get_perf_time
> 结束查询，跟get_perf_time配对使用，2.11.0开始支持


**Parameters:**
- `None`

**Returns:**
- time list,duration单位为ms

**代码实例:**
```python
#!/usr/bin/env python3
import minium
class AppTest(minium.MiniTest):
	self.app.get_perf_time(entry_types=["navigation"])
        self.app.navigate_to("/pages/testapp/testapp")
        self.app.redirect_to("/pages/testpage/testpage")
        perf_data = self.app.stop_get_perf_time()
        print(perf_data)
        self.assertListEqual(
            [
                {
                    "name": data["name"],
                    "entryType": data["entryType"],
                    "navigationType": data["navigationType"],
                    "path": data["path"],
                }
                for data in perf_data
            ],
            [
                {
                    "name": "route",
                    "entryType": "navigation",
                    "navigationType": "navigateTo",
                    "path": "pages/testapp/testapp",
                },
                {
                    "name": "route",
                    "entryType": "navigation",
                    "navigationType": "redirectTo",
                    "path": "pages/testpage/testpage",
                },
            ],
        )
        for data in perf_data:
            self.assertIsNot(0, data["startTime"])
            self.assertIsNot(0, data["duration"])
            self.assertIsNot(0, data["navigationStart"])
```

---

## wait_for_page() :id=wait_for_page
> 等待页面跳转成功


**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|page_path|str|Not None|需要等待的页面路径, 需要绝对路径, 如`/pages/index`|
|max_timeout|int|10|最大等待时间|


**Returns:** 
- `bool`

**代码实例:**
```python
import minium
class AppTest(minium.MiniTest):
    def test_wait_for_page(self):
        el = self.app.current_page.get_element("button", inner_text="跳转到testpage")
        el.tap()
        ret = self.app.wait_for_page("/pages/testpage/testpage")
        self.assertTrue(ret, "wait success")
        self.assertEqual(self.app.current_page.path, "/pages/testpage/testpage", "path ok")
```

---

## wait_util() :id=wait_util
> 指定时间内, 剩余没有完成的异步请求数 <= {cnt}个, 此时认为页面异步加载完成

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|cnt|int|Not None|剩余的异步请求个数|
|max_timeout|int|10|最大等待时间|


**Returns:** 
- `bool`

**代码实例:**
```python
import minium
class AppTest(minium.MiniTest):
    def test_wait_for_page(self):
        el = self.app.current_page.get_element("button", inner_text="跳转到testpage")
        el.tap()
        ret = self.app.wait_util(0, 5)  # 5s内, 页面没有任何未完成的异步请求
        self.assertTrue(ret, "wait success")
```

---

## mock_choose_image() :id=mock_choose_image
> mock `wx.chooseImage`, `wx.chooseMedia`, `CameraContext.takePhoto`接口, 完成选择图片功能. mock后, 仅支持单次的图片选择, 下一次的图片选择操作会重置到原始状态

> minium v1.2.8支持

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|name|str|Not None|图片名, 如`test.png`|
|image_b64data|str|Not None|base64格式的图片数据|


**Returns:** 
- `bool`

**代码实例:**
```python
import minium
import base64

class AppTest(minium.MiniTest):
    def test_mock_choose_image(self):
        image_name = "test.png"  # 运行这个case时需要在本目录下有名为test.png的图片
        with open(image_name, "rb") as fd:
            c = fd.read()
            image_b64data = base64.b64encode(c).decode("utf8")
        self.app.mock_choose_image(image_name, image_b64data)
        # 实际使用中不应直接调用`call_wx_method`, 应操作小程序触发wx.chooseImage等相关接口
        ret = self.app.call_wx_method("chooseImage", {})
        # ret.result.result.tempFilePaths[0] 应为test.png在小程序上的存储路径
        # 该路径设置到image标签的src中应能看到test.png这张图
```

---

## mock_choose_images() :id=mock_choose_images
> mock `wx.chooseImage`, `wx.chooseMedia`, `CameraContext.takePhoto`接口, 完成选择图片功能, 支持选择多图

> minium v1.2.9支持

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|items|list|Not None|mock的图片信息列表, 如: [{name, b64data} ... ], 其中`name`与`b64data`参数与`mock_choose_image`中`name`与`image_b64data`相同|


**Returns:** 
- `bool`

**代码实例:**
```python
import minium
import base64

class AppTest(minium.MiniTest):
    def test_mock_choose_images(self):
        image_names = ["test.png", "test2.png",]  # 运行这个case时需要在本目录下有名为test.png和test2.png的图片
        items = []
        for name in image_names:
            with open(name, "rb") as fd:
                c = fd.read()
                image_b64data = base64.b64encode(c).decode("utf8")
                items.append({
                    "name": name,
                    "b64data": image_b64data
                })
        self.app.mock_choose_images(items)
        ret = self.app.call_wx_method("chooseImage", {})
        # ret.result.result.tempFilePaths[0] 应为test.png在小程序上的存储路径
        # ret.result.result.tempFilePaths[1] 应为test2.png在小程序上的存储路径
```

---

## mock_call_function() :id=mock_call_function
> mock `wx.cloud.callFunction` 接口, 相关小程序接口文档: [callFunction](https://developers.weixin.qq.com/miniprogram/dev/wxcloud/reference-sdk-api/functions/Cloud.callFunction.html)

> minium v1.2.8支持

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|rule|dict|Not None|正则匹配规则, 与[`mock_request`](#mock_request)中规则定义一致|
|success|dict|None|成功回调结果，与参数`fail`需二选一|
|fail|str\|dict|None|失败回调结果，如类型为str，会自动填充成基础库返回格式，与参数`success`需二选一|

**Returns:**
- `None`

**代码实例:**
```python
import minium
import base64

class AppTest(minium.MiniTest):
    def test_mock_call_function(self):
        # 清理环境
        self.app.restore_call_function()
        self.app.call_wx_method("clearStorageSync")
        # mock的回调数据
        resp = {
            "result": {
                "openid": "testopenid"
            },
            "requestID": "requestID应该不能重复使用, mock后如果需要使用获取更多opendata, 请注意在业务后台甄别"
        }
        # mock获取openid的云函数
        self.app.mock_call_function({
            "name": "quickstartFunctions",
            "data": {
                "type": "getOpenId"
            }
        }, success=resp)
        # 进入调用该云函数的页面, 调用成功后会把openid设置到page.data上
        page = self.app.navigate_to("/pages/login/selflogin")
        self.assertTrue(page.wait_data_contains("openId"), "调用getOpenId不成功") 
        self.assertEqual(page.data.openId, resp["result"]["openid"])
```

---

## mock_call_function_once() :id=mock_call_function_once
> 功能与[`mock_call_function`](#mock_call_function)相似, 不同之处在于插入的规则匹配命中一次之后就会失效

> minium v1.2.8支持

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|rule|dict|Not None|正则匹配规则, 与[`mock_request`](#mock_request)中规则定义一致|
|success|dict|None|成功回调结果，与参数`fail`需二选一|
|fail|str\|dict|None|失败回调结果，如类型为str，会自动填充成基础库返回格式，与参数`success`需二选一|

**Returns:**
- `None`

**代码实例:**
见[`mock_call_function`](#mock_call_function)

---

## restore_call_function() :id=restore_call_function
> 清理`mock_call_function`插入的所有匹配规则

> minium v1.2.8支持

**Parameters:**
- `None`

**Returns:**
- `None`

**代码实例:**
见[`mock_call_function`](#mock_call_function)

---

## mock_call_container() :id=mock_call_container
> mock `wx.cloud.callContainer` 接口, 相关小程序接口文档: [callContainer](https://developers.weixin.qq.com/miniprogram/dev/wxcloud/reference-sdk-api/container/Cloud.callContainer.html)

> minium v1.2.8支持

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|rule|dict|Not None|正则匹配规则, 与[`mock_request`](#mock_request)中规则定义一致|
|success|dict|None|成功回调结果，与参数`fail`需二选一|
|fail|str\|dict|None|失败回调结果，如类型为str，会自动填充成基础库返回格式，与参数`success`需二选一|

**Returns:**
- `None`


---

## mock_call_container_once() :id=mock_call_container_once
> 功能与[`mock_call_container`](#mock_call_container)相似, 不同之处在于插入的规则匹配命中一次之后就会失效

> minium v1.2.8支持

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|rule|dict|Not None|正则匹配规则, 与[`mock_request`](#mock_request)中规则定义一致|
|success|dict|None|成功回调结果，与参数`fail`需二选一|
|fail|str\|dict|None|失败回调结果，如类型为str，会自动填充成基础库返回格式，与参数`success`需二选一|

**Returns:**
- `None`

---

## restore_call_container() :id=restore_call_container
> 清理`mock_call_container`插入的所有匹配规则

> minium v1.2.8支持

**Parameters:**
- `None`

**Returns:**
- `None`

---

## get_modals() :id=get_modals
> 获取modal/toast弹窗信息

> minium v1.4.5支持

> [基于mock/hook能力](https://minitest.weixin.qq.com/#/minium/Python/framework/mock)

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|since|float|None|获取从该时间戳开始的检测到的弹窗, None: 获取所有|

**Returns:**
- List[Item]

每个`Item`都为dict

|名称| 类型| 说明|
| :----- | :-----: | :----- |
|type|str|modal / toast|
|title|str|modal / toast的标题|
|content|str|modal 的内容|

**代码实例:**

```python
import minium, time
class AppTest(minium.MiniTest):
    def test_get_modal_info(self):
        stime = time.time()
        self.app.call_wx_method_async("showToast", {"title": "test get"})
        self.app.call_wx_method_async("showModal", {"title": "test get", "content": "hello"})
        time.sleep(2)
        self.assertListEqual(self.app.get_modals(stime), [
            {"title": "test get", "type": "toast"},
            {"title": "test get", "content": "hello", "type": "modal"}
        ])
        self.assertListEqual(self.app.get_unhandle_modal(), [
            {"title": "test get", "content": "hello", "type": "modal"}
        ])
        self.native.handle_modal("取消")
        time.sleep(2)
        self.assertListEqual(self.app.get_unhandle_modal(), [])
        self.assertTrue(True)
```

---

## get_unhandle_modal() :id=get_unhandle_modal
> 获取未处理的弹窗信息

> minium v1.4.5支持

> [基于mock/hook能力](https://minitest.weixin.qq.com/#/minium/Python/framework/mock)

**Returns:**
- List[Item]

每个`Item`都为dict

|名称| 类型| 说明|
| :----- | :-----: | :----- |
|type|str|modal|
|title|str|modal 的标题|
|content|str|modal 的内容|

**代码实例:**
见[`get_modals`](#get_modals)
