<!--
 * @Author: yopofeng
 * @Date: 2021-02-25 16:56:11
 * @LastEditTime: 2023-01-06 12:19:46
 * @LastEditors: yopofeng
 * @Description: 
-->
# 测试框架

minium提供一个基于[unittest](https://docs.python.org/3/library/unittest.html)封装好的测试框架[`MiniTest`](https://minitest.weixin.qq.com/#/minium/Python/framework/Minitest)，利用这个简单的框架对小程序测试可以起到事半功倍的效果。

测试基类[Minitest](https://minitest.weixin.qq.com/#/minium/Python/framework/Minitest.md)会根据[测试配置](https://minitest.weixin.qq.com/#/minium/Python/framework/config.md)进行测试，minitest向上继承了`unittest.TestCase`，并做了以下改动：

1. 加载读取测试配置
2. 在合适的时机初始化[minium.Minium](https://minitest.weixin.qq.com/#/minium/Python/api/Minium)和[minium.Native](https://minitest.weixin.qq.com/#/minium/Python/api/Native)
3. 根据配置打开IDE，拉起小程序项目和或自动打开真机调试
4. 注入测试逻辑
5. 拦截assert调用，记录检验结果
6. 记录运行时数据和截图，用于测试报告生成

使用MiniTest可以大大降低小程序测试成本。如何快速使用测试框架进行测试，可参考[例子](https://minitest.weixin.qq.com/#/minium/Python/framework/example)


