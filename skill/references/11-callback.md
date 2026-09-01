<!--
 * @Author: yopofeng
 * @Date: 2023-01-06 12:23:22
 * @LastEditors: yopofeng
 * @LastEditTime: 2023-01-06 16:01:58
 * @FilePath: /minium-doc/minium/Python/framework/callback.md
 * @Description: 
 * 
 * Copyright (c) 2023 by yopofeng yopofeng@tencent.com, All Rights Reserved. 
-->
# `Class` minium.Callback :id=minium-Callback

> 自动化测试中涉及到一些需要监听异步回调的场景, 如需要监听点击按钮后是否有`模态弹窗`弹出, 弹窗内容是什么等。

**Properties:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|is_called|bool|False|是否有被调用过|

## Callback() :id=init
> 初始化函数

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|callback|FunctionType|None|自定义回调函数|


## wait_called() :id=wait_called
> 等待回调函数被调用

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|timeout|int|10|等待超时时间|


## get_callback_result() :id=get_callback_result
> 获取回调结果, 超时未获取到结果报AssertionError

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|timeout|int|0|等待超时时间|

**代码示例:** 
```python
import minium, os
from minium import Callback
class FirstTest(minium.MiniTest):
    def test_callback(self):
        before = Callback()  # 创建接口调用前callback实例
        self.app.hook_wx_method("showToast", before=before)  # 监听wx.showToast调用
        self.call_wx_method("showToast", {
            "title": "我是弹窗"
        })  # 此处例子直接调用接口以保证接口被触发。正常业务逻辑应该是操作某些元素后，由小程序触发wx.showToast
        result = before.get_callback_result(timeout=2)  # 等待接口调用结果
        self.assertDictEqual({
            "title": "我是弹窗"
        }, result)
```
