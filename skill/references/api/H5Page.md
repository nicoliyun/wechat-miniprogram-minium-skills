# `Class` minium.H5Page :id=minium-h5page

> `H5Page`提供了小程序内嵌h5页面驱动能力([`web-view`](https://developers.weixin.qq.com/miniprogram/dev/component/web-view.html)组件下包裹的h5页面), `H5Page`继承自[`minium.Page`](https://minitest.weixin.qq.com/#/minium/Python/api/Page), 重复的属性和方法, 此处不再描述.

!> 目前只支持在`Android真机`上使用, 一般由框架自动生成, 无需自己实例化. 更多说明见[H5测试](https://minitest.weixin.qq.com/#/minium/Python/introduction/h5test)

通过调用[`App.get_current_page`](https://minitest.weixin.qq.com/#/minium/Python/api/App?id=get_current_page)方法获取`H5Page`实例

**Properties:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|title|str|Not None|h5页面的title|
|page_url|str|Not None|h5页面url|
|scroll_height|int|Not None| 可滚动高度|
|scroll_width|int|Not None| 可滚动宽度|
|scroll_x|int|Not None| 当前窗口顶点的 x 坐标|
|scroll_y|int|Not None| 当前窗口顶点的 y 坐标|

## element_is_exists() :id=element_is_exists

> 在当前页面查询元素是否存在

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|selector|str|Not None|css selector/xpath/full xpath/文案|
|max_timeout|int|10|超时时间，单位 s|
|inner_text|str|None|通过控件内的文字识别控件|
|text_contains|str|None|通过控件内的文字模糊匹配控件|
|value|str|None|通过控件的 value 识别控件|
|xpath|str|None|显式指定xpath|

**Returns:**

- `bool`

**代码示例:**

```python {"id":"01HHZZK404SF3A46F7WXC3SDD2"}
import minium
@minium.ddt_class(testNameFormat="%(name)s_%(index)s")
class TestPageGetElement(minium.MiniTest):
    def setUp(self):
        self.logger.info(self.app.platform)
        self.app.relaunch("/pages/webview/webview")

    def test_element_is_exists(self):
        self.assertTrue(self.page.element_is_exists("疾病专区"), "元素不存在")
```

---

## get_element() :id=get_element

> 在当前页面查询控件, 如果匹配到多个结果, 则返回第一个匹配到的结果, 如果没有找到元素，抛`NoSuchElementException`

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|picker|str|Not None|[CSS选择器](https://www.w3school.com.cn/css/css_selectors.asp)或以`/`或`//`开头的[XPath](https://www.w3school.com.cn/xpath/xpath_syntax.asp)/文案|

**Returns:**

- [H5Element](https://minitest.weixin.qq.com/#/minium/Python/api/H5Element)

**代码示例:**

```python {"id":"01HHZZK404SF3A46F7WZQ7MGN6"}
import minium
@minium.ddt_class
class TestPageGetElement(minium.MiniTest):
    def setUp(self):
        self.logger.info(self.app.platform)
        self.app.relaunch("/pages/webview/webview")

    def test_get_element(self):
        self.assertEqual(self.page.get_element("疾病专区").inner_text, "疾病专区", "元素不存在")
```

---

## go_back() :id=go_back

> 返回上一页

**Returns:**

- `None`

**代码示例:**

```python {"id":"01HHZZK404SF3A46F7WZQ7MGN6"}
import minium, time
@minium.ddt_class
class TestPageGetElement(minium.MiniTest):
    def setUp(self):
        self.logger.info(self.app.platform)
        self.app.relaunch("/pages/webview/webview")

    def test_go_back(self):
        url = self.page.page_url
        self.page.get_element("疾病专区").click()  # 进入h5页面中另外一个连接
        time.sleep(2)
        self.assertNotEqual(url, self.page.page_url, "没有跳转")
        self.page.go_back()
        time.sleep(2)
        self.assertEqual(url, self.page.page_url, "没有返回")
```

---

## scroll_to() :id=scroll_to

> 滚动到指定高度


**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|scroll_top|int|Not None|高度，单位 px|
|duration|int|1|滚动动画时长，单位 s|

**Returns:**

- `None`

**代码示例:**

```python {"id":"01HHZZK404SF3A46F7WZQ7MGN6"}
import minium
@minium.ddt_class
class TestPageGetElement(minium.MiniTest):
    def setUp(self):
        self.logger.info(self.app.platform)
        self.app.relaunch("/pages/webview/webview")

    def test_scoll_to(self):
        # 2秒内滚动到高度为500px的位置
        self.page.scroll_to(500, 2)
        self.assertEqual(round(self.page.scroll_y), 500, "scroll success")

```

---

## wait_for() :id=wait_for

> 等待直到指定的条件成立, 条件可以是页面元素, 也可以是自定义的函数或者是需要等待的时间(单位秒)


**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|condition|int/str/function|Not None|指定条件, int: 等待的秒数. str: 等待元素的选择器. function: 自定义的函数, 需要返回bool类型|
|max_timeout|int|10|超时时间，单位 s|

**Returns:**

- `bool`

**代码示例:**

```python {"id":"01HHZZK404SF3A46F7WZQ7MGN6"}
import minium, time
@minium.ddt_class
class TestPageGetElement(minium.MiniTest):
    def setUp(self):
        self.logger.info(self.app.platform)
        self.app.relaunch("/pages/webview/webview")

    def test_wait_for(self):
        start = time.time()
        self.page.wait_for(5)
        self.assertTrue(time.time() - start >= 5)

        self.page.get_element('疾病专区').click()
        self.assertTrue(self.page.wait_for('热门专区'))

```

---

