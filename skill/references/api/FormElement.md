# `Class` minium.FormElement :id=minium-form-element
> `FormElement` 继承于  `BaseElement`, 提供了对表单类组件的操作 <br />
元素标签包含`input`, `textarea`, `switch`, `slider`, `picker`

!> 公共库 2.10.0 开始生效

通过调用[`Page.get_element`](https://minitest.weixin.qq.com/#/minium/Python/api/Page?id=get_element)/[`Page.get_elements`](https://minitest.weixin.qq.com/#/minium/Python/api/Page?id=get_elements)/[`Element.get_element`](https://minitest.weixin.qq.com/#/minium/Python/api/Element?id=get_element)/[`Element.get_elements`](https://minitest.weixin.qq.com/#/minium/Python/api/Element?id=get_elements)方法获取`Element`实例

---

## input() :id=input
> `input` & `textarea` 组件输入文字

> IDE上不会改变element上的value属性，建议使用变化的Page.data/hook绑定的input方法判断是否生效

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|text|str|None|输入文本|
|with_confirm|bool|False|输入完毕后, 是否触发`confirm`事件。即输入完毕后, 是否需要触发键盘上的`确认`/`发送`等按钮|

**Returns:**
- `None`

**代码示例:** 
```xml
<!-- 小程序wxml -->
<input id="username" bindinput="userNameInput" type="text"/>
```

```python
import minium, threading, time
from minium import Callback
@minium.ddt_class
class TestElement(minium.MiniTest):
    def test_input(self):
        """
        测试输入:
        1. 在`input`组件输入`test123`
        2. 通过hook绑定的输入事件获取输入的详情
        """
        callback = Callback()
        page = self.app.redirect_to("/pages/testelement/testelement")
        el = page.get_element("#username")
        # hook绑定的输入事件获取输入的详情, 详情通过callback函数记录
        self.app.hook_current_page_method("userNameInput", callback.callback)
        # 输入, 组件上应显示test123
        el.input("test123")
        time.sleep(3)
        # 检验有输入事件触发
        self.assertTrue(callback.wait_called(timeout=10), "callback called")
        # 检验输入详情
        self.assertEqual(callback.get_callback_result()["detail"]["value"], "test123", "input text ok")
```

---

## switch() :id=switch
> 改变 switch 组件的状态

**Parameters:**
- `None`

**Returns:**
- `None`

**代码示例:** 
```xml
<!-- 小程序wxml -->
<switch bindchange="switchChange" ></switch>
```


```python
import minium, threading
from minium import Callback
@minium.ddt_class
class TestElement(minium.MiniTest):
    def test_switch(self):
        """
        测试switch:
        1. 改变`switch`组件状态
        2. 通过hook绑定的change事件获取状态改变的详情
        """
        callback = Callback()
        page = self.app.redirect_to("/pages/testelement/testelement")
        self.app.hook_current_page_method("switchChange", callback.callback)
        el = page.get_element("switch")
        checked = el.checked
        el.switch()
        self.assertTrue(callback.wait_called(timeout=10), "callback called")
        self.assertEqual(callback.get_callback_result(), not checked, "switch ok")
        el.switch()
        self.assertTrue(callback._Callback__called.acquire(timeout=10), "callback called")
        self.assertEqual(callback.get_callback_result(), not (not checked), "switch ok")
```

---

## slide_to() :id=slide_to
> slider 组件滑动到指定数值

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
| value|int|None|数值|

**Returns:**
- `None`

**代码示例:** 
```xml
<!-- 小程序wxml -->
<slider value="{{testdata1}}" bindchange="sliderchange" step="5"/>
```

```python
import minium, time
@minium.ddt_class
class TestElement(minium.MiniTest):
    def test_slide_to(self):
        """
        slider 组件滑动到`80`
        """
        page = self.app.redirect_to("/pages/testelement/testelement")
        element_slider = page.get_element("slider")
        element_slider.slide_to(80)
        time.sleep(1)
        self.assertEqual(element_slider.value, 80, "slider ok")
```

---

## pick() :id=pick
> picker 组件选值

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|value|看下表|Not None|属性名称|

**value 的取值：**

|选择器类型|类型| 说明|
| :----- | :-----: | :----- |
|selector: 普通选择器|int|表示选择了 range 中的第几个 (下标从 0 开始) |
|multiSelector: 多列选择器|int|表示选择了 range 中的第几个 (下标从 0 开始) |
|time: 时间选择器|str|表示选中的时间，格式为"hh:mm"|
|date: 日期选择器|str|表示选中的日期，格式为"YYYY-MM-DD"|
|region: 省市区选择器|list|表示选中的省市区，如["广东省", "广州市", "海珠区"]|

**Returns:**
- `None`

**代码示例:** 

```python
import minium, threading
from minium import Callback
@minium.ddt_class
class TestElement(minium.MiniTest):
    @classmethod
    def setUpClass(cls):
        super(TestElement, cls).setUpClass()
        cls.page = cls.app.redirect_to("/pages/testelement/testelement")

    @minium.ddt_unpack
    @minium.ddt_case(
        (0, 3, "bindPickerChange"),
        (1, "9:30", "bindTimeChange"),
        (2, "2019-10-31", "bindDateChange"),
    )  
    def test_pick(self, index, value, method):
        """
        测试选择器
        不会进行真正的滚动选择操作, 通过派发change事件来模拟选择完成操作
        """
        callback = Callback()
        els = self.page.get_elements("picker")
        self.app.hook_current_page_method(method, callback.callback)
        els[index].click()  # 阻止picker弹起
        els[index].pick(value)  # 用trigger模拟pick完成的动作
        self.assertTrue(callback.wait_called(timeout=10), "callback called")
        self.assertEqual(callback.get_callback_result()["detail"]["value"], value, "pick ok")  

```

---