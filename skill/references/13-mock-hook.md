<!--
 * @Author: yopofeng
 * @Date: 2023-01-06 12:23:22
 * @LastEditors: yopofeng yopofeng@tencent.com
 * @LastEditTime: 2023-08-28 16:53:09
 * @FilePath: /minium-doc/minium/Python/framework/mock.md
 * @Description: 
 * 
 * Copyright (c) 2023 by yopofeng yopofeng@tencent.com, All Rights Reserved. 
-->
# 关于mock和hook能力说明

> minium中基于mock/hook能力实现了很多实用api, mock/hook能力是否正常也关系着这一类的api能力是否能正常使用. 这部分能力/api在文档中会注明`基于mock/hook能力`

## mock

`mock`, 替换接口实现. 如`wx.getStorageSync("test")`返回结果是`1`, mock该接口后可以让其返回`2`


## hook

`hook`, 在api调用前后进行插桩监控。分为`before`: 函数调用前. `after`: 函数调用后. `callback`: 函数回调时


## 如何验证功能是否正常

### 原理
[`mock_wx_method`](https://minitest.weixin.qq.com/#/minium/Python/api/App#mock_wx_method)和[`hook_wx_method`](https://minitest.weixin.qq.com/#/minium/Python/api/App#hook_wx_method)都是对wx对象下的api进行重写操作。如果小程序在minium对接口进行mock/hook操作前, 对wx下的api最原始的引用进行保存, 则minium无法对接口进行有效的重写, 功能不能正常使用。

### 验证方法

> 验证方法以`showModal`接口为例, 其他 API 类似

1. 准备被测小程序, 在随便一个页面新增一个`button`, 绑定一个事件调用`showModal`接口
```wxml
<button bindtap="testmock">测试mock</button>
```
```js
testmock() {
    // 如果为其他框架开发小程序, 如uni-app, 你可能是使用uni.showModal进行调用
    wx.showModal({
        title: "test mock",
        content: "如果我被mock了我不应该弹出"
    })
}
```
2. 手动点击`测试mock`这个按钮, 此时小程序应有弹窗弹出
3. python脚本中mock调用`showModal`
```python
# 此为例子, 前面需要先根据快速开始手动实例化Minium实例
mini.app.mock_wx_method("showModal", result={"errMsg": "showModal:ok", "confirm": True, "cancel": False})
```
4. python脚本中调用`showModal`验证是否mock指令是否生效. 调用后, 小程序不应有title为"test test"的弹窗弹出. 此时证明mock_wx_method **`已生效`**
```python
mini.app.call_wx_method("showModal", {"title": "test test"})
# 指令运行后立即返回且ide/真机上没有title为"test test"的弹窗弹出
```
5. 手动点击`测试mock`这个按钮, 小程序不应有title为"test mock"的弹窗弹出。如果仍有, 则说明mock/hook功能对于你的小程序 **`不能正常使用`** 。造成这种情况的原因，可能是因为你的小程序对`showModal`这个方法的原始引用进行了保存/重写，方式包括但不限于通过`Proxy`对象进行代理、使用一个全局`Object`对所有api引用进行保存。解决方法参考[处理被代理/被保存的API](#处理被代理被保存的api)

## 处理被代理/被保存的API

> 基于第三方开发平台开发的小程序, 如uni-app, taro等, 框架中封装了自己的一些api, 并对`wx`下的API原始引用进行保存/重写。此时小程序中调用 API 时可能并不会调用到被minium框架改写后的方法

对于[验证方法](#验证方法)步骤5中判定为 **`不能正常使用`** 的小程序, 可以对你的小程序进行如下适配操作:

__在app.js中把代理wx的对象/保存api原始引用的object赋值给`wx._MINI_WX_PROXY_`__

如:
- 在uni-app中: `wx._MINI_WX_PROXY_ = uni`
- 在taro中: `wx._MINI_WX_PROXY_ = taro`

进行适配后的小程序, 可通过[验证方法](#验证方法)中的指引重新验证. 如仍然失败, 可准备[小程序代码片段](https://developers.weixin.qq.com/miniprogram/dev/devtools/minicode.html)以及接口调用代码, 到[社区](https://developers.weixin.qq.com/community/minihome/mixflow/2315318279491616771)进行反馈

