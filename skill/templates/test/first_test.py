#!/usr/bin/env python3
"""minium 用例示例：覆盖跳转、元素定位、交互、等待、数据校验、Mock、截图。

运行：minitest -m test.first_test -c config.json -g
注意：本文件不可直接 `python first_test.py` 运行，必须由 minitest 驱动。
"""
import minium


class FirstTest(minium.MiniTest):
    """示例：一个模块（页面）一个测试类。"""

    @classmethod
    def setUpClass(cls):
        super(FirstTest, cls).setUpClass()
        # 类级别只做一次页面跳转，减少 setUp 开销
        cls.page = cls.app.navigate_to("/pages/index/index")

    @minium.exit_when_error
    def test_00_page_loaded(self):
        """前置校验：页面必须加载成功，失败则终止后续用例。"""
        self.assertEqual(self.page.path, "pages/index/index", "页面路径正确")
        self.assertTrue(self.page.element_is_exists(".container", max_timeout=10), "根节点存在")

    def test_01_element_and_click(self):
        """元素定位与点击：优先 选择器 + inner_text/text_contains。"""
        self.page.get_element("button", inner_text="立即报名", max_timeout=5).click()
        self.assertTrue(self.page.wait_for(".signup-form", max_timeout=5), "报名表单出现")

    def test_02_input_and_data(self):
        """输入框与页面数据校验。"""
        self.page.get_element("input.weui-input").input("13800000000")
        self.assertEqual(self.page.get_element("input.weui-input").value, "13800000000", "输入内容正确")
        self.page.wait_data_contains("formData.phone", max_timeout=5)

    def test_03_mock_wx_method(self):
        """Mock 微信 API：不依赖真实定位/网络。"""
        try:
            self.app.mock_wx_method(
                "getLocation",
                result={"latitude": 30.5078, "longitude": 114.4191, "errMsg": "getLocation:ok"},
            )
            self.page.get_element("button", inner_text="获取位置").click()
            self.assertTrue(self.page.wait_for(".location", max_timeout=5), "位置展示")
        finally:
            self.app.restore_wx_method("getLocation")  # 必须还原，避免污染其他用例

    def test_04_assert_and_capture(self):
        """断言与截图（截图会进入测试报告）。"""
        titles = [e.inner_text for e in self.page.get_elements(".card .title")]
        self.assertIn("活动详情", titles, "卡片标题包含活动详情")
        self.capture("首页")
