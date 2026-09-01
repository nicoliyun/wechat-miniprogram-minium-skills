# 真机测试

minium通过[配置文件](https://minitest.weixin.qq.com/#/minium/Python/framework/config)来识别小程序运行的平台，如果需要测试手机上的小程序，那么需要把配置项`platform`改成`Android`或者`iOS`。

?> 小程序真机调试是基于小程序开发者工具的[`真机调试`](https://developers.weixin.qq.com/miniprogram/dev/devtools/remote-debug.html)能力和`appnium`实现的。如果case使用了[minium.Native](https://minitest.weixin.qq.com/#/minium/Python/api/Native)的接口，则配置文件中必须配置`device_desire`配置项

## 真机调试常见问题

- `真机调试2.0`将在minium`v1.2.8`版本支持. 手机上需要配合`2.25.1`以上版本基础库才可生效。不满足以上两个条件的需切换回`真机调试1.0`

- `真机调试1.0`在`基础库版本 > 2.25.3`的情况下，会获取不到真机上的元素，需要切换`真机调试2.0`

- 如果小程序在`真机调试2.0`上不可运行（出现无法修复的报错），必须使用`真机调试1.0`的，可先给手机推送`2.25.3`或以下版本的基础库，再进行真机调试，操作如下图所示

![推送基础库](https://minitest.weixin.qq.com/resources/pushlib.png)

## 切换真机调试版本
- 手动点击`真机调试`, 如出现`切换真机调试2.0`字眼则当前处于`真机调试1.0`版本。反之则正在使用`真机调试2.0`版本
- 
![真机调试20](https://minitest.weixin.qq.com/resources/真机调试20.png)


## Android
- 电脑上需要安装好[adb](https://developer.android.com/studio/command-line/adb.html?hl=zh-cn)
- 确认打开了手机中的"开发者选项"，并且打开"开发者选项"内的"允许USB调试"。不同手机打开开关不一, 可上网搜索具体品牌手机如何打开"开发者选项"的教程
- 需要保证命令行能识别到手机设备
```shell
$ adb devices

List of devices attached
28fb61d0ef1c7ece	device
```
- 如果只有一台手机在线，那么只需要把`platform`配置成`Android`即可， 而如果多台设备连接到手机，配置文件需要制定设备的序列号，如:

```json
{
  "debug_mode": "debug",
  "enable_app_log": false,
  "platform": "Android",
  "device_desire": {
    "serial": "28fb61d0ef1c7ece"
  }
}
```
?> 在我们连接真机的时候，Android手机会**自动安装**微信测试的apk(你也可以运行`minitest --apk`获取apk路径进行手动安装)，有些手机在安装过程中会弹框或者输入密码，所以第一次运行的时候可能需要人为的处理


## IOS

### 额外依赖
ios真机驱动需要安装额外的依赖库
```
pip3 install "minium[ios]"
```

### 安装 libmobiledevice

```shell
brew uninstall ideviceinstaller
brew uninstall libimobiledevice
brew install --HEAD libimobiledevice
brew link --overwrite libimobiledevice
brew install ideviceinstaller
brew link --overwrite ideviceinstaller
```

如果没有安装过直接 brew install ideviceinstaller 即可。

当然你也可以本地编译：

```shell
git clone https://github.com/libimobiledevice/libimobiledevice.git
cd libimobiledevice
./autogen.sh --disable-openssl
make
sudo make install
```

### 配置 WebDriverAgent

minium 不包含 WebDriverAgent（简称wda） 工程，先执行以下命令clone工程：
```shell
mkdir wda
cd wda
echo "{}" > package.json
npm i appium
# 新版本的 appium 可能不再包含 webdriveragent 依赖, 可自行安装
# npm i appium-webdriveragent
echo `pwd`/node_modules/appium/node_modules/appium-webdriveragent
```
以上最后输出的路径为wda工程路径，可用xcode打开，也可写到[device_desire配置](https://minitest.weixin.qq.com/#/minium/Python/framework/config.md#使用wda工程的device_desire配置项)中

按照以下指引配置工程

![1](https://minitest.weixin.qq.com/resources/wda1.png)
![2](https://minitest.weixin.qq.com/resources/wda2.png)
![3](https://minitest.weixin.qq.com/resources/wda3.png)

配置完成之后，可以用`⌘+u`快捷键运行 unit test 测试 wda 是否正常运行

![4](https://minitest.weixin.qq.com/resources/wda4.png)

更加详细的配置说明请访问[appium/WebDriverAgent/wiki](https://github.com/facebookarchive/WebDriverAgent/wiki/Starting-WebDriverAgent)

### 配置测试 config.json

在用例目录下面新增一个叫`config.json`的配置文件，格式如下

```json
{
  "platform": "iOS",
  "device_desire":{
    "wda_project_path": "/Users/sherlock/wda/node_modules/appium/node_modules/appium-webdriveragent", //自定义 wda 的路径
    "device_info": {
          "udid": "aee531018e668ff1aadee0889f5ebe21a2292...", //手机的 udid 
          "model": "iPhone XR",
          "version": "12.2.5",
          "name": "sherlock's iPhone"
    }
  }
}
```

!> ***PS: JSON不支持注释，请把“//”以及后面的内容删掉***

### iOS配置进阶
minium 对于 ios native 驱动的实例化有以下几个途径：通过 `xcode + appium-webdriveragent`, `wda 驱动的代理(wda_ip + wda_port)` 和 `tidevice + 编译安装好的 wda app(ios17 以及以上版本暂不支持)`。针对以下途径, 可以按照建议配置以下信息以供驱动实例化.
- `xcode + appium-webdriveragent`
```json
{
  "platform": "iOS",
  "device_desire":{
    "wda_project_path": "/Users/xxx/wda/node_modules/appium/node_modules/appium-webdriveragent",
    "device_info": {
          "udid": "aee531018e668ff1aadee0889f5ebe21a2292...",
    }
  }
}
```
- `wda 驱动的代理(wda_ip + wda_port)`
```json
{
  "platform": "iOS",
  "device_desire":{
    "wda_ip": "127.0.0.1",
    "wda_port": "127.0.0.1",
    "device_info": {
          "udid": "aee531018e668ff1aadee0889f5ebe21a2292...",
    }
  }
}
```
- `tidevice + 编译安装好的 wda app(ios17 以及以上版本暂不支持)`
```json
{
  "platform": "iOS",
  "device_desire":{
    "wda_bundle": "com.facebook.WebDriverAgentRunner.xctrunner",
    "device_info": {
          "udid": "aee531018e668ff1aadee0889f5ebe21a2292...",
    }
  }
}
```
测试配置的方式如下, 留意运行过程是否产生了 warning 和 error: 
```python
import minium
config = minium.MiniConfig.from_file("config.json")
native = minium.Native(config.device_desire, "ios")
native.start_wechat()
print(native.source())
```


> 详细说明请看：[测试配置](https://minitest.weixin.qq.com/#/minium/Python/framework/config)

## 云真机测试

为了让开发者更方便的进行真机测试，我们还提供了`云真机测试服务`，详情请参考[服务文档](https://developers.weixin.qq.com/miniprogram/dev/devtools/minitest/minium.html)

#### 云真机测试与本地真机测试优缺点对比

| 能力 | 本地真机 | 云真机 |
| -------------- | ------------- | --------------- |
|  测试账号  | 可以用自己的微信账号 | 只支持使用[虚拟账号](https://developers.weixin.qq.com/miniprogram/dev/devtools/minitest/virtual_test.html)测试 |
|  真机部署  | 需要自己部署真机，安装wda或者adb环境  | 无需准备真机环境，直接提测 |
|  环境维护  | 需要自己维护开发者工具登录态  | 不依赖开发者工具，无需用户维护 |
| 查看报告  | 需要自己搭建报告查看环境   |  提供详细的测试报告，并支持分享报告https链接  | 
| 性能数据 |  需要手动调用接口获取   | 支持查看用例性能数据，如CPU，内存占用等，可以开启体验评分，进一步查看运行时性能数据 |
| Devops | 需要自己实现   | 提供第三方https接口提交任务，获取结果，详情参考 [小程序云测实现Devops流程实践分享](https://developers.weixin.qq.com/community/minihome/article/doc/000aa2b6f30de0e397bda04f751413) |
