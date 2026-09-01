# `Class` minium.MiniTest :id=minium-MiniTest
> `MiniTest`是minium中继承自`unittest.TestCase`的测试基类, 你可以在testcase中使用框架实例化好的Minium/App/Native实例。
> 也可以使用`unittest`中的各种断言函数

**Properties:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|mini|[minium.Minium](https://minitest.weixin.qq.com/#/minium/Python/api/Minium)|None|Minium实例，可直接调用minium.Minium中的方法|
|app|[minium.App](https://minitest.weixin.qq.com/#/minium/Python/api/App)|None|App实例，可直接调用minium.App中的方法|
|page|[minium.Page](https://minitest.weixin.qq.com/#/minium/Python/api/Page)|None|当前页面Page实例，可直接调用minium.Page中的方法|
|native|[minium.Native](https://minitest.weixin.qq.com/#/minium/Python/api/Native)|None|Native实例，可直接调用minium.Native中的方法|
|logger|Logger|None|可以调用`logger.info`, `logger.warning`, `logger.error`, `logger.debug`打印日志, 日志内容会在报告日志中体现|
|test_config|[minium.MiniConfig](https://minitest.weixin.qq.com/#/minium/Python/framework/config.md#基础项目配置)|None|case运行时对应的配置实例, case setUp时创建|

**代码示例:** 

```python
#!/usr/bin/env python3
import minium
class FirstTest(minium.MiniTest):
    def test_get_system_info(self):
        sys_info = self.mini.get_system_info()
        self.logger.info(f'SDKVersion is: {sys_info.get("SDKVersion")}')  # 可以使用self.logger打印一些log
        self.assertIn("SDKVersion", sys_info)

if __name__ == "__main__":
    import unittest
    loaded_suite = unittest.TestLoader().loadTestsFromTestCase(FirstTest)
    result = unittest.TextTestRunner().run(loaded_suite)
    print(result)
```

**运行**

直接执行py文件或参考[例子](https://minitest.weixin.qq.com/#/minium/Python/framework/example)使用命令行启动

## capture() :id=capture
> 截图

!> 使用该接口截的图会显示在报告中

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|name|str|时间(时分秒)|截图名|
|region|[Page](https://minitest.weixin.qq.com/#/minium/Python/api/Page)/[Element](https://minitest.weixin.qq.com/#/minium/Python/api/Element)|None|截取指定区域, 传入`Page`则截取除除系统顶部状态栏部分区域, 传入`Element` 则截取element所在区域. 该功能需要安装额外的依赖库: [`opencv-python`](https://pypi.org/project/opencv-python/)|


**Returns:** 
- `str`: 截图存放的真实路径

**代码实例:**
```python
import minium, os
class FirstTest(minium.MiniTest):
    def test_capture(self):
        path = self.capture("test_capture.png")
        self.assertTrue(os.path.exists(path), "截图路径存在")

    def test_capture_region(self):
        el = self.page.get_element("button")
        path = self.capture("test_capture_el.png", region=el)
        path = self.capture("test_capture_page.png", region=self.page)
        self.assertTrue(os.path.exists(path), "截图路径存在")
```

---

## get_current_requests() :id=get_current_requests
> 返回当前case运行期间捕获的小程序请求日志


**Parameters:**

- `None`

**Returns:** 
- `list[dict]`: 每个item的内容如下

|名称| 类型| 说明|
| :----- | :-----: | :----- |
|timestamp|float|记录时间戳|
|start_timestamp|int|请求开始的时间, 单位ms|
|end_timestamp|int|请求结束的时间, 单位ms|
|request|dict\|None|请求. 与`wx.request(obj)`传入的`obj`一致|
|response|dict\|None|返回. 与`wx.request({complete(res) {} })`回调的`res`一致|


---

## get_weapp_logs() :id=get_weapp_logs
> 返回当前case运行期间捕获的小程序日志, 包括jserror


**Parameters:**

- `None`

**Returns:** 
- `list[dict]`: 每个item的内容如下

|名称| 类型| 说明|
| :----- | :-----: | :----- |
|type|str|log\|warn\|error|
|message|str|log内容|
|dt|str|日志时间, `年-月-日 时:分:秒`|


---

## relaunch_miniprogram() :id=relaunch_miniprogram

**Parameters:**

- `None`

**Returns:** 

- `None`

**代码实例:**
```python
import minium
class FirstTest(minium.MiniTest):
    def test_relaunch_miniprogram(self):
        self.relaunch_miniprogram()  # 可能会经历关闭开发者工具/重启手机微信等一系列流程

```
