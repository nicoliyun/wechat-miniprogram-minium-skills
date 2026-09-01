# `Class` minium.Page :id=minium-page

> `Page`提供了小程序页面内包括 set data, 获取控件, 页面滚动等功能

通过调用[`App.get_current_page`](https://minitest.weixin.qq.com/#/minium/Python/api/App?id=get_current_page)方法获取`Page`实例

**Properties:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|page_id|str|Not None|页面 ID|
|path|str|Not None|页面路径|
|query|str|Not None|页面参数|
|plugin_appid|str|None|如果页面是插件页面，该属性为插件的appid|
|renderer|str|"webview"|页面渲染方式: webview/skyline|
|data|str|Not None|页面数据|
|inner_size|dict|Not None|窗口的大小|
|scroll_height|int|Not None| 可滚动高度|
|scroll_width|int|Not None| 可滚动宽度|
|scroll_x|int|Not None| 当前窗口顶点的 x 坐标|
|scroll_y|int|Not None| 当前窗口顶点的 y 坐标|
|is_webview|bool|None| 是否为内嵌h5页面, None表示未检测过/无法确定|
|wxml|str|""| 当前页面的页面 wxml|

---

## data :id=data

> 当前页面数据, 可直接赋值，相当于setData
> **代码示例:**

```js {"id":"01J9RJQMZ35JFF39086RW2E6EA"}
Page({
    data: {"testdata1": 1}
})
```

```python {"id":"01J9RJQMZ35JFF39086TCB7W1Z"}
import minium
class PageTest(minium.MiniTest):
    def test_data(self):
        self.app.navigate_to("/pages/testpage/testpage")
        page = self.app.get_current_page()
        data = page.data
        self.assertDictEqual({"testdata1": 1}, data)
        data["testdata1"] = 30 
        page.data = data  # Page.data.testdata1 == 30
        page.data = {"testdata2": "test2"}  # Page.data.testdata2 == "test2"
        page = self.app.get_current_page()
        self.assertDictEqual({"testdata1": 30, "testdata2": "test2"}, page.data)
```

## element_is_exists() :id=element_is_exists

> 在当前页面查询元素是否存在

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|selector|str|Not None|css选择器或以`/`或`//`开头的xpath|
|max_timeout|int|10|超时时间，单位 s|
|inner_text|str|None|通过控件内的文字识别控件|
|text_contains|str|None|通过控件内的文字模糊匹配控件|
|value|str|None|通过控件的 value 识别控件|
|xpath|str|None|显式指定xpath|

**Returns:**

- `bool`

**代码示例:**

```python {"id":"01J9RJQMZ35JFF39086VGCET7B"}
import minium
@minium.ddt_class(testNameFormat="%(name)s_%(index)s")
class TestPageGetElement(minium.MiniTest):
    @classmethod
    def setUpClass(cls):
        super(TestPageGetElement, cls).setUpClass()
        cls.page = cls.app.navigate_to("/pages/testelement/testelement")
    
    @minium.ddt_case(
        # 多个用例
        # 展开后为: 选择器, 预期是否存在
        (".testclass", True),
        ("#testclass", False),
        (".testclass2", False),
        ("/view[5]", True),
    )
    def test_element_is_exists(self, args):
        [selector, is_exists] = args
        self.assertEqual(is_exists, self.page.element_is_exists(selector, max_timeout=5))
```

---

## get_element() :id=get_element

> 在当前页面查询控件, 如果匹配到多个结果, 则返回第一个匹配到的结果, 如果没有找到元素，抛`MiniElementNotFoundError`

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|selector|str|Not None|[CSS选择器](https://www.w3school.com.cn/css/css_selectors.asp)或以`/`或`//`开头的[XPath](https://www.w3school.com.cn/xpath/xpath_syntax.asp)|
|inner_text|str|None|通过控件内的文字识别控件|
|text_contains|str|None|通过控件内的文字模糊匹配控件|
|value|str|None|通过控件的 value 识别控件|
|max_timeout|int|0|超时时间，单位 s|
|xpath|str|None|显式指定[XPath](https://www.w3school.com.cn/xpath/xpath_syntax.asp), 小程序基础库2.19.5后支持|
|auto_fix|bool|False|当`max_timeout != 0`且没有找到目标元素时, 框架尝试通过整个页面元素【推测】你可以想要查找的元素，如果有符合条件的【可能的元素】，则返回该元素实例；一般可以解决：xpath 丢失中间节点、跨自定义组件 css selector 写法不当问题; `minium v.5.5`支持|

***PS: selector 仅支持下列语法:***

- ID选择器：`#the-id`
- class选择器（可以连续指定多个）：`.a-class.another-class`
- 标签选择器：`view`
- 子元素选择器：`.the-parent > .the-child`
- 后代选择器：`.the-ancestor .the-descendant`
- [跨自定义组件的后代选择器](https://minitest.weixin.qq.com/#/minium/Python/introduction/selector?id=跨自定义组件的后代选择器)：`custom-element1>>>.custom-element2>>>.the-descendant`
   **custom-element1 和 .custom-element2必须是自定义组件标签或者能获取到自定义组件的选择器**
- 多选择器的并集：`#a-node, .some-other-nodes`
- xpath：可以在真机调试的wxml pannel`选择节点->右键->copy->copy full xpath`获取，暂不支持`[text()='xxx']`这类xpath条件
- __自定义组件不支持穿透, 需要先get自定义组件, 再使用Element.get_element获取其子节点, 或使用[>>>]连接自定义组件及其后代元素, 如发现无法正常定位, 可根据这个方法[辨别自定义组件](https://minitest.weixin.qq.com/#/minium/Python/introduction/selector?id=如何辨别组件是否为自定义组件)__
- [更多元素定位实例](https://minitest.weixin.qq.com/#/minium/Python/introduction/selector)

**Returns:**

- [Element](https://minitest.weixin.qq.com/#/minium/Python/api/Element)

**代码示例:**

```python {"id":"01J9RJQMZ49E1RYB39AC3GWB99"}
import minium
@minium.ddt_class
class TestPageGetElement(minium.MiniTest):
    @classmethod
    def setUpClass(cls):
        super(TestPageGetElement, cls).setUpClass()
        cls.page = cls.app.navigate_to("/pages/testelement/testelement")
    
    @minium.ddt_case(
        # 多个用例
        # 参数展开后对应: 选择器, 文本, 包含的文本, 值, 预期文本, 预期子wxml, 预期wxml
        ("view", None, None, None, "first node", "first node", "<view>first node</view>"),
        ("/page/view[10]/mytest2/view/view[1]", None, None, None, "2-1", "<text>2-1</text>", '<view class="test21"><text>2-1</text></view>'),
    )
    def test_element_is_exists(self, args):
        [
            selector,
            inner_text,
            text_contains,
            value,
            expected_inner_text,
            expected_inner_wxml,
            expected_outer_wxml,
        ] = args
        element = self.page.get_element(
            selector, inner_text=inner_text, text_contains=text_contains, value=value, max_timeout=0
        )
        self.assertEqual(expected_inner_text, element.inner_text, "inner text ok")
        self.assertEqual(expected_inner_wxml, element.inner_wxml, "inner wxml ok")
        self.assertEqual(expected_outer_wxml, element.outer_wxml)
```

---

## get_elements() :id=get_elements

> 在当前页面查询控件, 并返回一个或者多个结果

__PS: 支持的选择器同 [`get_element()`](#get_element)__

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|selector|str|Not None|css选择器或以`/`或`//`开头的xpath|
|max_timeout|int|0|超时时间，单位 s|
|inner_text|str|None|通过控件内的文字识别控件, xpath暂不支持|
|text_contains|str|None|通过控件内的文字模糊匹配控件, xpath暂不支持|
|value|str|None|通过控件的 value 识别控件, xpath暂不支持|
|index|int|-1|index==-1: 获取所有符合的元素, index>=0: 获取前index+1符合的元素|
|xpath|str|None|显式指定xpath, 小程序基础库2.19.5后支持|
|auto_fix|bool|False|当`max_timeout != 0`且没有找到目标元素时, 框架尝试通过整个页面元素【推测】你可以想要查找的元素，如果有符合条件的【可能的元素】，则返回该元素实例；一般可以解决：xpath 丢失中间节点、跨自定义组件 css selector 写法不当问题; `minium v.5.5`支持|

**Returns:**

- List[[Element](https://minitest.weixin.qq.com/#/minium/Python/api/Element)]

**代码示例:**

```python {"id":"01J9RJQMZ49E1RYB39AC3W00ZH"}
import minium
@minium.ddt_class
class TestPageGetElement(minium.MiniTest):
    @classmethod
    def setUpClass(cls):
        super(TestPageGetElement, cls).setUpClass()
        cls.page = cls.app.navigate_to("/pages/testelement/testelement")

    @minium.ddt_case(
        # 四种选择器写法, 参数展开对应: 选择器, 对应元素个数
        (".testclass", 2),
        (".child", 3),
        (".parent .child", 2),
        ("/page/view[10]/mytest2/view/view[1]", 1)
    )
    def test_get_elements(self, args):
        [selector, number] = args
        elements = self.page.get_elements(selector, max_timeout=5)
        self.assertEqual(number, len(elements))

```

---

## scroll_to() :id=scroll_to

> 滚动到指定高度

!> 如果遇到滚动操作不生效, 可借助开发者工具上的【`工具`->`自动化测试`】工具录制相关操作，确定scroll操作的目标对象是`/`/`scroll-view`/`view`, 不为`/`的情况下，需先获取到相应元素后再进行`scroll_to`操作

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|scroll_top|int|Not None|高度，单位 px|
|duration|int|300|滚动动画时长，单位 ms|

**Returns:**

- `None`

**代码示例:**

```python {"id":"01J9RJQMZ49E1RYB39ADVC9FAE"}
import minium, time
class PageTest(minium.MiniTest):
    def test_scroll_to(self):
        page = self.app.redirect_to("/pages/testpage/testpage")
        # 500ms内页面滚动到高度为200px的位置
        page.scroll_to(200,500)
        time.sleep(1)
        self.assertEqual(page.scroll_y, 200, "scroll success")
```

---

## call_method()  :id=call_method

> 调用[page的函数](https://developers.weixin.qq.com/miniprogram/dev/reference/api/Page.html)

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|method|str|Not None|函数名称|
|args|dict|None|函数参数|

**Returns:**

- `dict`

**代码示例:**

```js {"id":"01J9RJQMZ49E1RYB39AFDZKHHV"}
Page({
  callMethod: function(e) {
    e.message = "this is test callMethod"
    return e
  },
})
```

```python {"id":"01J9RJQMZ49E1RYB39AJG1TD3F"}
import minium
class PageTest(minium.MiniTest):	
    def test_call_method(self):
        page = self.app.redirect_to("/pages/testpage/testpage")
        # 调用页面上的callMethod方法
        result = page.call_method("callMethod", {"test": "test call method"})
        self.assertDictEqual(
            {"test": "test call method", "message": "this is test callMethod"},
            result.get("result", {}).get("result"),
        )
```

---

## wait_for() :id=wait_for

> 等待直到指定的条件成立, 条件可以是页面元素, 也可以是自定义的函数或者是需要等待的时间(单位秒)

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|condition|int\|str\|function|Not None|指定条件, int: 等待的秒数. str: 等待元素的选择器. function: 自定义的函数, 需要返回`bool`类型|
|max_timeout|int|10|超时时间，单位 s|

**Returns:**

- `bool`

**代码示例:**

```python {"id":"01J9RJQMZ49E1RYB39ANH29X9S"}
import minium, time
@minium.ddt_class
class PageTest(minium.MiniTest):
    @classmethod
    def setUpClass(cls):
        super(PageTest, cls).setUpClass()
        cls.page = cls.app.navigate_to("/pages/testpage/testpage")
    
    def test_wait_for_number(self):
        c_time = int(time.time())
        self.page.wait_for(2)
        self.assertEqual(int(time.time()), c_time + 2)

    @minium.ddt_case(
        ".waitfor",
        "mytest>>>.componentclass",
        "//view[text()='wait for']"
    )
    def test_wait_for_element(self, selector):
        self.page.call_method("testWaitFor")
        time.sleep(1)
        self.assertTrue(self.page.wait_for(selector, max_timeout=2))
        time.sleep(2)

    def test_wait_for_condition(self):
        def page_wait():
            ret = self.page.element_is_exists(".waitfor")
            return ret

        self.page.call_method("testWaitFor")
        time.sleep(1)
        self.assertTrue(self.page.wait_for(page_wait, max_timeout=2))
```

---

## wait_data_contains() :id=wait_data_contains

> 等待Page.data中特定keys出现

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|*keys_list|list\|str|Not None|等待的页面的data包含的key。如果是需要等待深层的data，可以使用"a.b.c"或("a", "b", "c")的表达方法|
|max_timeout|int|10|超时时间，单位 s|

**Returns:**

- `bool`

**代码示例:**

```python {"id":"01J9RJQMZ49E1RYB39AQ4J6FAQ"}
import minium, time
@minium.ddt_class
class PageTest(minium.MiniTest):
    @classmethod
    def setUpClass(cls):
        super(PageTest, cls).setUpClass()
        cls.page = cls.app.navigate_to("/pages/testpage/testpage")
	
    @minium.ddt_case(
        (("testwait",),),
        (("waitkeys", "a"),),
        ("waitkeys.b",),
        ("testwait", "waitkeys.b",)
    )
    def test_wait_data_contains(self, keys):
        self.page.call_method("testWaitData")   # 2s后: page.data={testwait: 1, waitkeys: {a: 1, b: false}}, 4s: page.data = {}
        self.assertTrue(self.page.wait_data_contains(*keys, max_timeout=3))
        time.sleep(4)
```

---





