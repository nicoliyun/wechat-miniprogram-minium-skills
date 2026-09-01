# 小程序内嵌h5页面测试说明

> 小程序内嵌h5页面是指小程序中使用[`web-view`](https://developers.weixin.qq.com/miniprogram/dev/component/web-view.html)组件包裹的h5页面

!> 目前只支持在`Android真机`上使用

## 本地调试环境准备
### 真机调试环境
1. 需要满足[真机测试](https://minitest.weixin.qq.com/#/minium/Python/framework/mobile?id=android)中的条件
2. 在微信任意会话中, 发送以下链接, 并点开它
```
http://debugxweb.qq.com/?inspector=true
```
3. 通过以下方式验证是否开启成功
- 打开chrome, 输入`chrome://inspect/`并打开
- 手机上打开你的小程序
- 检查chrome上是否有类似如下截图的内容
![chromeh5](https://minitest.weixin.qq.com/resources/chromeh5.png)
- 如不成功, 重启微信后重复2操作

### 如何调试
- 打开chrome, 输入`chrome://inspect/`并打开
- 手机上打开你的小程序, 并进入你需要测试的h5页面
- 在chrome上找到你的h5页面的链接, 如:
![chromeh5url](https://minitest.weixin.qq.com/resources/chromeh5url.png)
- 点击`inspect`开始调试页面
- 你可以在inpector中获取到你需要的控件的`xpath`/`css selector`等信息帮助你编写case

## 测试流程说明
- 本能力基于[小程序真机测试](https://minitest.weixin.qq.com/#/minium/Python/framework/mobile), 首先需要小程序能正常运行真机调试才能继续跑下去
- 小程序跳转到`内嵌h5页面`后, 框架会自动实例化[H5Page](https://minitest.weixin.qq.com/#/minium/Python/api/H5Page), 一般不需要开发者自己实例化
- `H5Page`实例化成功说明`minium`已经成功链接上inspector，如果实例化失败，`H5Page`会退化成普通的[`Page`](https://minitest.weixin.qq.com/#/minium/Python/api/Page)，此时继续运行case可能会出现无法找到元素等报错
- 一般实例化`H5Page`失败的原因有: 1. usb链接断了, 可以通过`adb devices`指令测试. 2. `inspector`挂了, 因为这个`inspector`属于浏览器内核内容, 除了重启当前页面(如[redirect_to](https://minitest.weixin.qq.com/#/minium/Python/api/App?id=redirect_to))没有其他方法修复.
- 获取当前页面的方法一般有: [App.current_page](https://minitest.weixin.qq.com/#/minium/Python/api/App), 测试框架中[Minitest.page](https://minitest.weixin.qq.com/#/minium/Python/framework/Minitest), [App.get_current_page()](https://minitest.weixin.qq.com/#/minium/Python/api/App?id=get_current_page)



