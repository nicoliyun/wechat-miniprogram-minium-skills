# 更新日志

## v1.6.0(2024-10-09)
1. `F` 修复打开小程序报`timeout`问题
2. `A` 新增支持使用虚拟账号进行自动化测试
3. `F` 修复ide上隐私弹窗无法处理问题
4. `F` 修复 `miniwxml` 部分 selector 写法无法查找到元素问题
5. `F` 修复`MiniTest.capture`方法截取元素区域不准确问题
6. `A` 新增`Page.wxml`属性，获取Page的页面 wxml
7. `F` 修复ide 上 mock chooseLocation的逻辑
8. `F` 修复页面对比方法
9. `F` 修复`MiniElementNotFoundError`传参没兼容旧版本问题
10. `A` 新增`App.go_to`. 与`App.relaunch`相似, 区别在于`go_to`仅在当前页面不是目标页面时进行relaunch
11. `F` 修复 `miniwxml` 处理中文的问题
12. `F` 修复 mock request 传入错误规则会引起请求无法正常发送的情况
13. `A` 新增`Native.select_wechat_avatar`方法处理选择微信头像需求
14. `U` 优化 mock request, 支持请求参数的正则表达匹配
15. `F` 修复 xpath selector 的转化逻辑
16. `A` 如果 case 中使用了`auto_fix`参数, 或配置了全局`autofix`, 而导致case 可以顺利通过的, 结果中使用`autofix_succ`字段标记
17. `A` 新增全局配置`autofix`, 使查找元素时可以自动开启纠错功能
18. `F` 修复`element_is_exists` 在切换页面时没有更新新 pageid 问题，导致最终判断页面元素不存在
19. `A` 新增`MiniTest.relaunch_miniprogram`方法，重启小程序
20. `A` case 报`MiniElementNotFoundError`且可以通过`autofix`方式找到可能得元素时, 相关信息会在报告的`代码与堆栈`tab 中显示

## v1.5.5(2024-05-30)
1. `A` [Page.get_element](https://minitest.weixin.qq.com/#/minium/Python/api/Page#get_element) 和 [Page.get_elements](https://minitest.weixin.qq.com/#/minium/Python/api/Page#get_elements)方法新增 `auto_fix` 参数, 在找不到元素时，对 selector进行一定范围内的微调，尝试找到可能符合条件的元素
2. `F` 修复 ios 平台识别小程序是否在前台的逻辑有误问题
3. `U` 优化h5的输入方法

## v1.5.4(2024-04-22)
1. `F` 修复 windows 下 h5 页面自动化问题
2. `F` 修复基础库 3.2.5 以后版本 `input` 方法报错问题
3. `F` 修复`forward_miniprogram_inside`和`forward_miniprogram`接口
4. `F` 修复`get_elements`和`get_element`接口
5. `U` 优化`app.current_page`对于`page destory`的异常处理能力
6. `F` 修复部分 Android 机器真机调试时获取进程id异常的问题
7. `F` 修复部分page wxml文件无法正常落地问题
8. `F` 修复`trial`版本调试基础库识别错误问题
9. `U` 优化 iOS Native 驱动, 详情见: [ios配置进阶](https://minitest.weixin.qq.com/#/minium/Python/framework/mobile?id=ios配置进阶)
10. `F` 修复 Android native 上`allow_send_subscribe_message`接口
11. `U` 优化兼容逻辑，修复测试过程中，开发者工具出现`重新编译`，导致之后的测试 case 都失败的问题
12. `U` 优化拉起真机调试过程中, 出现未链接等情况时的容错逻辑（打开真机调试，但手机上未打开小程序或出现白屏等）

## v1.5.1(2024-01-08)
1. `A` 支持小程序内嵌h5页面的测试能力, 详情见: [H5测试](https://minitest.weixin.qq.com/#/minium/Python/introduction/h5test)
2. `A` 新增`用户隐私`官方弹窗处理方法[`allow_privacy`](https://minitest.weixin.qq.com/#/minium/Python/api/Native#allow_privacy)
3. `A` 报告中新增简单的网络请求信息展示 
4. `F` 修复报告中一些小问题
5. `A` 新增`Native.handle_alter_before_unload`处理由`wx.enableAlertBeforeUnload`引起的弹窗
6. `A` `Minitest`主动捕获小程序的jserror并落地到`weapp.log`中, 报告中`小程序日志`也会展示
7. `A` 新增[Minitest.get_current_requests](https://minitest.weixin.qq.com/#/minium/Python/framework/Minitest?id=get_current_requests)获取当前case运行期间捕获的小程序请求日志
8. `A` 新增[Minitest.get_weapp_logs](https://minitest.weixin.qq.com/#/minium/Python/framework/Minitest?id=get_weapp_logs)获取当前case运行期间捕获的小程序日志, 包括jserror
9. `F` 使用[App.current_page](https://minitest.weixin.qq.com/#/minium/Python/api/App), 测试框架中[Minitest.page](https://minitest.weixin.qq.com/#/minium/Python/framework/Minitest)进行页面操作, 出现`PageDestroyed`错误时, 框架会自动尝试重新获取当前页面继续操作
10. `F` 修复`app.mock_wx_method`mock同步方法时传值不对问题
11. `F` 修复`app.go_home`方法返回首页等待超时问题

## v1.4.6(2023-08-28)
1. `A` 新增[`app.get_modals`](https://minitest.weixin.qq.com/#/minium/Python/api/App#get_modals)方法, 获取`showModal` & `showToast` 调起的弹窗信息
2. `A` 新增[`app.get_unhandle_modal`](https://minitest.weixin.qq.com/#/minium/Python/api/App#get_unhandle_modal)方法, 获取`showModal`调起的未处理的弹窗信息
3. `F` 修复`allow_get_user_phone`, `get_perf`, `text_exists`接口
4. `F` 修复`mock_choose_image_with_name`在已经有本地mock数据时, 仍提示需要配置相关参数的问题
5. `F` 修复`video`组件`play`方法失效问题
6. `A` 新增一些用例修饰器`justAtPlatform`和`skipAtPlatform`, 用以修饰用例支持的运行平台
7. `A` 新增配置项`check_mp_foreground`在case开始时, 检查小程序是否在前台
8. `U` 优化调整ide截图（需要ide在前台）超时后，后续截图指令响应时间缩短至2s
9.  `U` `allow_get_user_phone`/`allow_authorize`接口支持处理未绑定手机号的情况
10. `U` `handle_modal`接口支持处理传入`bool`类型
11. `U` 优化了`allow_authorize`逻辑, 对于有多个授权弹窗同时弹出的场景有所优化
12. `U` 修复[`app.wait_util`](https://minitest.weixin.qq.com/#/minium/Python/api/App#wait_util)等待超时失败问题
13. `F` 修复`allow_send_subscribe_message`处理订阅消息弹窗问题
14. `U` 优化了`mock/hook`的实现方式，支持部分第三方开发框架开发的小程序，详情请看[说明](https://minitest.weixin.qq.com/#/minium/Python/framework/mock)
15. `F` 修复了[`app.wait_for_page`](https://minitest.weixin.qq.com/#/minium/Python/api/App#wait_for_page)超时报错问题
16. `F` 修复读取配置文件报找不到文件问题

## v1.4.3(2023-07-06)
1. `A` `input`方法新增`with_confirm`参数, 用于触发键盘上的`确认`/`发送`等按钮事件

## v1.4.2(2023-06-30)
1. `F` 修复python3.11版本以上的兼容问题
2. `F` 修复`wait_for_page`报错问题
3. `F` 修复使用`app.current_page`调用`get_element`报`page destroyed`问题
4. `F` 修复`minitest -v`报`urlencode import error`的问题

## v1.4.1
1. `F` 修复导入`urllib3.request`库的问题

## v1.4.0(2023-04-27)
1. `F` 获取源码和错误行数逻辑兼容ddt用例
2. `A` 新增[网络面板](https://minitest.weixin.qq.com/#/minium/Python/framework/networkpanel)说明
3. `U` 优化setup & teardown报错时不能获取到源码和错误行数问题
4. `U` 优化链接断连重连, 对于可能造成的指令失效问题, 体现在指令报错中(`MiniConnectionClosedError`/`MiniClientOfflineError`/`MiniTimeoutCauseByConnectionBreakError`/`MiniTimeoutCauseByClientOffline`)
5. `F` 修复`Callback.callback`收到`dict`类型回调时可能出现`KeyError`的报错
6. `A` 新增[`retry`](https://minitest.weixin.qq.com/#/minium/Python/framework/modifier?id=retry)&[`catch`](https://minitest.weixin.qq.com/#/minium/Python/framework/modifier?id=catch)修饰器
7. `F` 修复安卓性能截图问题
8. `A` minitest框架针对因网络掉线导致测试失败的用例，进行1次重试
9. `U` 优化自动截图配置, 原`assert_capture`配置更新为[`auto_capture`](https://minitest.weixin.qq.com/#/minium/Python/framework/config?id=使用minitest测试框架支持的项目配置)
10. `F` 修复`outputs`路径中有未完成的测试任务时，测试报告显示异常问题
11. `U` 优化用户使用新版本python时，由于unittest版本更新引起的测试用例兼容性问题
12. `F` 修复用户运行云测平台生成的录制回放case时, 部分接口报错问题
13. `U` 优化检测开发者工具异常逻辑，自动重启项目


## v1.3.2(2023-02-08)
1. `A` 新增一些[用例修饰器](https://minitest.weixin.qq.com/#/minium/Python/framework/modifier)
2. `F` 修复[`app.mock_call_function`](https://minitest.weixin.qq.com/#/minium/Python/api/App#mock_call_function)失效问题
3. `F` 修复报告中时间显示问题
4. `A` 新增[minium.Callback](https://minitest.weixin.qq.com/#/minium/Python/framework/callback)方便使用`hook_wx_method`等需要获取回调信息的接口
5. `F` 修复处理ide上授权弹窗是报`Tool.native unimplemented`的问题

## v1.3.1(2022-12-28)
1. `A` 新增`ide`平台原生组件(授权弹窗等)操作支持。涉及的[`Native`](https://minitest.weixin.qq.com/#/minium/Python/api/Native)接口包括: `allow_login`, `allow_authorize`, `allow_get_user_info`, `allow_get_location`, `allow_get_we_run_data`, `allow_record`, `allow_write_photos_album`, `allow_camera`, `allow_send_subscribe_message`, `allow_get_user_phone`, `handle_modal`, `close_payment_dialog` 
2. `F` 修复python3.11版本引起的`unittest`报错问题

## v1.3.0(2022-11-07)
1. `F` 修复windows下config文件读取编码问题
2. `F` 修复`swiper.swipe_to`不会触发`animationfinish`问题
3. `A` [`app.switch_tab`](https://minitest.weixin.qq.com/#/minium/Python/api/App#switch_tab)新增`is_click`参数, 兼容切换tab时不触发onTabItemTap问题
4. `F` 修复[`app.wait_for_page`](https://minitest.weixin.qq.com/#/minium/Python/api/App#wait_for_page)等待插件页面时兼容问题
5. `F` 修复windows系统对于config.json文件编码兼容问题
6. `F` 修复windows系统配置`dev_tool_path`但不生效问题
7. `A` 新增debug模式, 配合`close_ide: false`和`full_reset: false`两项配置, 可以在跑完case后不关闭开发者工具和保持真机的远程调试，仅供**调试**使用，不建议用于正式测试任务
8. `F` 修复[Page.get_element](https://minitest.weixin.qq.com/#/minium/Python/api/Page#get_element)使用xpath+inner_text查找元素时inner_text没有处理首尾空字符的问题

## v1.2.9(2022-09-19)
1. `A` 新增[`app.mock_choose_images`](https://minitest.weixin.qq.com/#/minium/Python/api/App#mock_choose_images)
2. `F` 修复测试报告中包含截图太多时无法滚动问题
3. `F` 修复windows上运行部分adb命令报错问题
4. `F` 修复使用xpath方法查找`page`开头的自定义组件失败问题
5. `F` 修复安卓输入支付密码失败问题
6. `F` 修复`minitest -a`指令报错不清晰问题, 同时支持配合`-c`参数辅助启动开发者工具
7. `F` 修复配置`auto_authorize`为`true`的情况下, 部分授权弹窗没有被正确处理的问题
8. `A` 当case报`MiniElementNotFoundError`时, `MiniTest`框架会在`self.test_config.case_output`路径下生成`*.wxml`文件记录报错时页面wxml帮助用户排查"为什么找不到元素"
9. `F` 修复真机调试`mock_call_function`失效问题

## v1.2.8(2022-07-01)
1. `A` 支持通过mock方式进行"上传图片"操作, 相关接口:[`app.mock_choose_image`](https://minitest.weixin.qq.com/#/minium/Python/api/App#mock_choose_image)
2. `A` 新增方法mock云函数调用: [`app.mock_call_function`](https://minitest.weixin.qq.com/#/minium/Python/api/App#mock_call_function), [`app.mock_call_function_once`](https://minitest.weixin.qq.com/#/minium/Python/api/App#mock_call_function_once), [`app.restore_call_function`](https://minitest.weixin.qq.com/#/minium/Python/api/App#restore_call_function)
3. `A` 新增方法mock云托管调用: [`app.mock_call_container`](https://minitest.weixin.qq.com/#/minium/Python/api/App#mock_call_container), [`app.mock_call_container_once`](https://minitest.weixin.qq.com/#/minium/Python/api/App#mock_call_container_once), [`app.restore_call_container`](https://minitest.weixin.qq.com/#/minium/Python/api/App#restore_call_container)
4. `U` 优化network pannel
5. `A` 支持使用`真机调试2.0`进行真机自动化测试(手机基础库需要`2.25.1`以上版本), 2.0模式下[`app.evaluate`](https://minitest.weixin.qq.com/#/minium/Python/api/App#evaluate)方法只支持运行es5语法的js代码

## v1.2.7(2022-06-20)
1. `F` 修复js代码注入问题

## v1.2.6(2022-05-26)
1. `F` 修复插件页调用`go_home`会报`rejected due to no permission currently`问题
2. `F` 修复安卓真机的分享操作
3. `D` 安卓8.0.16版本客户端之后, 不再支持`map_select_location`方法
4. `A` 命令行新增`--task-limit-time`选项, 设置任务跑测超时时间
5. `F` 修复`auto_relaunch`相关逻辑
6. `F` 修复ios`allow_send_subscribe_message`接口
7. `U` 调用`Element.input`方法输入的内容以换行结尾认为是触发`confirm`方法
8. `F` 修复mock request时，没有返回RequestTask, 导致小程序可能后续的绑定操作无法进行的问题
9. `F` 修复配置了`assert_capture`后因截图失败导致的case失败问题
10. `F` 修复自动授权失败问题
11. `A` 新增[`app.wait_for_page`](https://minitest.weixin.qq.com/#/minium/Python/api/App#wait_for_page)方法等待指定页面跳转成功
12. `A` 新增[`element.scroll_to`](https://minitest.weixin.qq.com/#/minium/Python/api/Element#scroll_to)方法, 支持普通元素滚动, 需要配置基础库版本>=`v2.23.4`
13. `A` assert失败的时候, 留下WXML的快照, 记录在result.json中`assert_list[idx].wxml`中
14. `A` 新增配置项`teardown_snapshot`, 开启后会在case结束时生成page.data和page.wxml的快照用于复盘, 记录在result.json的`page_data`和`page_wxml`中
15. `F` 修复安卓部分手机无法进行真机测试问题
16. `A` 命令行新增`--check-env`选项, 检查当前测试环境
17. `U` 真机测试相关模块动态加载
18. `A` 新增[`app.wait_util`](https://minitest.weixin.qq.com/#/minium/Python/api/App#wait_util)方法等待指定页面异步加载成功

## v1.2.2(2021-11-23)
1. `A` 增加 [`app.mock_request_once`](https://minitest.weixin.qq.com/#/minium/Python/api/App#mock_request_once)，支持mock request一次后自动失效
2. `A` 增加命令行参数`--task-limit-time`，限制任务执行时长，单位s. 时间到后，自动结束测试进程。单位: s
3. `F` 修复`native.back_to_miniprogram`的逻辑
4. `F` 修复`native.map_select_location`对新版本微信兼容问题
5. `F` 修复安卓`native.forward_miniprogram`分享小程序问题
6. `F` 修复插件页面中调用`app.go_home`接口报`rejected due to no permission currently`问题
7. `F` 修复安卓初始化真机测试环境问题
8. `F` 修复ios真机报`Connection aborted`问题

## v1.2.1(2021-09-26)
1. `F` fix`Page.wait_data_contains`使用不清晰问题
2. `F` hook Sync方法时，不应注入callback回调
3. `A` 新增自动同意授权配置项`auto_authorize`
4. `F` 修复分享小程序相关接口
5. `A` 新增配置项`audits`，支持自动启动体验评分，并在关闭ide的时候自动在`outputs`目录(配置中的测试结果输出目录)下生成报告

## v1.2.0(2021-09-10)
1. `A` 新增了测试小程序和测试用例工程[git地址](https://git.weixin.qq.com/minitest/minitest-demo.git)
2. `F` 修复多媒体元素(`VideoElement`/`AudioElement`/`LivePlayerElement`/`LivePusherElement`)接口失效问题，并补充了用例
3. `A` 使用新版开发者工具，支持自动打开服务端口
4. `F` 修复`enable_log`接口重复调用会一行log回调多次的问题
5. `A` `App.screen_shot`在配置了真机信息的情况下，也支持真机截图了
6. `A` `App.call_wx_method`和`App.mock_wx_method`支持调用和mock插件上的wx方法(2.19.3基础库支持)
7. `F` App重复实例化重复注入监听函数的问题
8. `F` fix断言函数`msg`参数中包含`/`等字符时，自动截图报错问题
9. `A` `Page.element_is_exists`支持更多条件
10. `A` 新增`App.hook_current_page_method`和`App.release_hook_current_page_method`方法，支持hook当前页面的函数调用
11. `F` 尝试修复远程调试拉起失效问题

## v1.1.0(2021-08-05)
1. `A` `get_element`支持`>>>`跨自定义组件选择器，[详情](https://minitest.weixin.qq.com/#/minium/Python/api/Page#get_element)
2. `F` `allow_authorize`接口在ios端传参问题
3. `A` [Page.get_element](https://minitest.weixin.qq.com/#/minium/Python/api/Page#get_element)和[Element.get_element](https://minitest.weixin.qq.com/#/minium/Python/api/Element#get_element) 在获取不到元素的时候，会抛`MiniElementNotFoundError`

## v1.0.9(2021-07-19)
1. `A` 新增多种接口处理各种授权弹窗，以及一个通用接口[`allow_authorize`](https://minitest.weixin.qq.com/#/minium/Python/api/Native#allow_authorize)处理非特定的授权弹窗
2. `A` 新增[`allow_send_subscribe_message`](https://minitest.weixin.qq.com/#/minium/Python/api/Native#allow_send_subscribe_message)处理订阅消息授权弹窗

## v1.0.8(2021-06-22)
1. `A` `minium.ddt_*`支持自定义test method命名规则，详情见[数据驱动测试](https://minitest.weixin.qq.com/#/minium/Python/introduction/sample#test_ddt)
2. `A` 增加 [`app.mock_request`](https://minitest.weixin.qq.com/#/minium/Python/api/App#mock_request) 和 [`app.restore_request`](https://minitest.weixin.qq.com/#/minium/Python/api/App#restore_request)方法，用于细化mock网络请求返回
3. `A` 配置项新增[`mock_request`](https://minitest.weixin.qq.com/#/minium/Python/framework/config#mock_request配置项)项，用以配置整个测试任务运行时，需要mock的网络请求

[下载](https://minitest.weixin.qq.com/minium/Python/dist/minium-1.0.8.zip)

## v1.0.7(2021-05-24)
1. `F` 优化log显示
2. `U` 优化启动逻辑
3. `U` 细化报错类型

[下载](https://minitest.weixin.qq.com/minium/Python/dist/minium-1.0.7.zip)

## v1.0.6(2021-4-12)
1. `F` fix assert 失败后，报告仍然显示成功的问题
2. `A` `assert_capture`配置项同时控制setup和teardown的截图
3. `F` fix部分case没有正确生成报告的问题

## v1.0.5(2021-03-25)
1. `F` setupclass失败后，报告丢失问题
1. `F` 部分case的报告没有正常生成的问题
2. `A` 配置新增`mock_native_modal`，支持`ide`环境下mock可能出现弹窗的方法，详情见[IDE的mock_native_modal配置项](https://minitest.weixin.qq.com/#/minium/Python/framework/config#IDE的mock_native_modal配置项)

## v1.0.4(2021-03-02)
1. `F` pycharm中使用单测能力丢失的问题
2. `F` 使用unittest启动不能识别case的问题

## v1.0.3(2021-02-25)

1. `F` fix安卓handle_modal失效的问题

## v1.0.2(2021-02-01)

1. `A` 增加`enable_network_panel`配置项，监听所有`wx.request`接口的request和response
2. `F` fix crash后无法继续后面的用例的问题

## v1.0.0b-beta2(2021-01-12)

1. `A` page增加wait_for接口
2. `A` android增加click_point点击坐标接口
3. `U`  fix wait_data_contains bug

## v1.0.0b-beta2(2021-01-12)

1. `U` 截图接口修改capture的参数 

## v1.0.0b-beta2(2020-10-28)

1. `A` 新增接口 text_exists ， text_click 

## v1.0.0b-beta2(2020-10-27)

1. `U` bug fix
2. `A` 新增接口get_pay_value,close_payment_dialog,input_pay_password

## v1.0.0b-beta2(2020-09-03)

1. `U` bug fix
2. `A` 新增 release_hook_wx_method 接口

## v1.0.0-beta(2020-05-01)

1. `A` 新增 reset_remote_debug 接口
2. `U` 更新 handle_modal 接口处理，取消断言改为 warnning 提示，并返回成功状态
3.  `U` 在 case setup 的时候主动检测是否出现远程调试断开的情况
4.  `U` 针对 get_element()超时逻辑做调整，默认超时时间调整为 0，即不重试，有等待需要的可自行调整重试等待时间。另外，对于超时的情况不再 raise Exception，改成 warnning 的形式，并返回空的 element list，使用者可通过返回结果进行判断
5.  `A` 为 scroll-view element 添加四个可获取属性，scrollTop，scrollLeft，scrollWidth，scrollHeight，可用于坐标系运算
6.  `U` 支持 cli v2
7.  `A` 新增 request_timeout 参数，与 remote_connect_timeout 区分开，用作 send 请求等待的超时时间
8.  `D` 移除 CaseService, 框架内不再提供上层的用例调度管理模块
9.  `U` 优化运行体验，针对连接失败，启动失败，配置错误作出相应的重试和提示
10. `F` log 等级设置无效
11. `A` 新增 ide 截图接口（仅能截取 webView 部分）
12. `F` bug fix
13. `A` 新增 Android 性能数据获取接口
14. `F` 全平台默认多线程使用 spawn 模式

## v0.0.3(2019-10-28)

1. `U` bug fix
2. `A` 新增监听小程序 JS 错误
3. `U` 异步请求结果保存
4. `U` 更新部分 native 操作路径，以适应 7.0.7 版本微信
5. `U` 返回 Page.call_method 执行的结果
6. `A` 新增小程序事件监听机制
7. `A` 支持数据驱动
8. `A` 新增 @exit_when_err 装饰器，用于装饰某条用例，当这条用例失败时便不继续往下执行
9. `U` 适配 iOS 13
10. `A` Android 支持部分性能数据收集
11.  `A` minitest 命令新增 `--source` 参数，用于添加文件查找路径
12.  `U` iOS 取消保存 iproxy log
13.  `U` evaluate() 增加参数 `sync` 指定是否同步执行，默认异步执行
14.  `U` 测试报告大改版
15.  `A` Element 支持 touchstart、touchmove、touchend 事件触发
16.  `A` Element 新增接口 move() ，支持移动延时以及平滑移动
17.  `A` Page 新增接口 element_is_exists() ，查询元素是否存在
18.  `A` 支持自定义组件 get/set data 以及 call_method()

## v0.0.2(2019-08-20)

1. `U` bug fix
2. `A` 新增 AppService 代码注入
3. `A` 新增将函数暴露给小程序调用的能力
4. `A` 新增配置文件 yaml 支持
5. `A` 新增支持 VideoContext、AudioContext、LivePlayerContext、LivePusherContext 控制
6. `A` 新增 Android 配置可选 uiautomator 版本
7. `A` 新增显示 uiautomator apk 路径的命令
8. `A` 新增命令行打印构建参数
9. `A` 新增配置控制assert截图

## v0.0.1(2019-06-26)

1. `A` 新增小程序层控制
2. `A` 新增 Native 层控制
3. `A` 新增真机运行
4. `A` 新增自动化测试集成框架
5. `A` 新增测试报告生成
6. `A` 新增命令行调用命令：`miniruntest` `miniruntest` `mininative`


