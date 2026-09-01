<!--
 * @Author: yopofeng yopofeng@tencent.com
 * @Date: 2023-05-04 11:44:50
 * @LastEditors: yopofeng yopofeng@tencent.com
 * @LastEditTime: 2023-08-28 16:48:11
 * @FilePath: /minium-doc/minium/Python/framework/networkpanel.md
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
-->
# 网络面板
!> 网络面板是minitest框架通过minium hook能力封装的网络请求记录功能。测试配置`enable_network_panel: true`生效，且仅在Minitest测试框架中生效

> [基于mock/hook能力](https://minitest.weixin.qq.com/#/minium/Python/framework/mock)

## 网络请求日志
网络请求日志文件存放在`{self.test_config.case_output}/request.log`中，case运行过程中所有网络日志会在case运行完毕后存储到`request.log`中, log文件中，每一行为一条请求记录(json格式)，各个字段如下:

|配置项| 说明|
| :----- | :----- |
|start_timestamp|请求开始时间戳，单位ms|
|end_timestamp|请求结束时间戳，单位ms|
|request|请求内容, 同`wx.request(obj)`传入的`obj`|
|response|请求返回的内容，同`wx.request({success(res){}})`中的`res`|
|mocked|请求是否被`mock`了，mock方法见[mock_request](https://minitest.weixin.qq.com/#/minium/Python/api/App?id=mock_request)|

## 如何自己监听网络请求
用户还能通过网络面板封装好的功能自己监听网络请求。


**代码示例:**

``` python
#!/usr/bin/env python3
import minium, time

g_network_message_dict = {}  # 记录所有请求

def send_request(message):
    [msg_id, obj, ms, hash_id] = message["args"]
    if msg_id not in g_network_message_dict:
        g_network_message_dict[msg_id] = {"timestamp": time.time() * 1000}
    g_network_message_dict[msg_id]["start_timestamp"] = ms
    g_network_message_dict[msg_id]["request"] = json.loads(obj)

def request_callback(message):
    [msg_id, res, ms, hash_id, mocked] = message["args"]
    if msg_id not in g_network_message_dict:
        g_network_message_dict[msg_id] = {"timestamp": time.time() * 1000}
    g_network_message_dict[msg_id]["end_timestamp"] = ms
    g_network_message_dict[msg_id]["response"] = json.loads(res)
    g_network_message_dict[msg_id]["mocked"] = bool(mocked)

class AppTest(minium.MiniTest):
    def test_network_panel(self):
        # 监听小程序的request事件，收集到请求的参数和回包
        self.app.add_observer('mini_send_request', send_request)
        self.app.add_observer('mini_request_callback', request_callback)

        # do some request
        self.app.call_wx_method("request", {"url": "http://minitest.weixin.qq.com/SendMsg?content=test"})
        time.sleep(2) # 等待一下消息回调, 不是必要
        
        self.logger.info(g_network_message_dict)  # g_network_message_dict中有所有自监听以来收集到的请求信息

        # 移除监听, 不然信息会一直累积
        self.app.remove_observer('mini_send_request', send_request)
        self.app.remove_observer('mini_request_callback', request_callback)
```
