# `Class` minium.ViewElement :id=minium-view-element
> `ViewElement` 继承于  `BaseElement`, 提供了对视图类组件的操作 <br />
元素标签包含`scroll-view`, `swiper`, `movable-view`

!> 公共库 2.10.0 开始生效

通过调用[`Page.get_element`](https://minitest.weixin.qq.com/#/minium/Python/api/Page?id=get_element)/[`Page.get_elements`](https://minitest.weixin.qq.com/#/minium/Python/api/Page?id=get_elements)/[`Element.get_element`](https://minitest.weixin.qq.com/#/minium/Python/api/Element?id=get_element)/[`Element.get_elements`](https://minitest.weixin.qq.com/#/minium/Python/api/Element?id=get_elements)方法获取`Element`实例

---

## scroll_to() :id=scroll_to
> scroll-view 容器滚动操作

!> 如果遇到滚动操作不生效, 可借助开发者工具上的【`工具`->`自动化测试`】工具录制相关操作，确定scroll操作的目标对象是`/`/`scroll-view`/`view`, 如为`/`的情况下，需使用`Page.scroll_to`


**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|  x |int|None|x 轴上滚动的距离|
|  y |int|None|y 轴上滚动的距离|

**Returns:**
- `None`

**代码示例:** 

```python
import minium, threading
from minium import Callback
@minium.ddt_class
class TestElement(minium.MiniTest):
    def test_scroll_to(self):
        page = self.app.redirect_to("/pages/testelement/testelement")
        callback = Callback()
        # 监听滚动事件, 方便最后验证滚动结果
        self.app.hook_current_page_method("scroll", callback.callback)
        el = page.get_element("scroll-view")
        el.scroll_to(x=20)  # 横向滚动20像素
        self.assertTrue(callback.wait_called(timeout=10), "callback called")
        self.assertEqual(callback.get_callback_result()["detail"]["scrollLeft"], 20, "pick ok")
```

---

## swipe_to() :id=swipe_to
> 切换 swiper 容器当前的页面


**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|  index |int|None| 索引值，从 0 开始 |

**Returns:**
- `None`

**代码示例:** 

```python
import minium, threading
from minium import Callback
@minium.ddt_class
class TestElement(minium.MiniTest):
    def test_swipe_to(self):
        page = self.app.redirect_to("/pages/testelement/testelement")
        callback = Callback()
        # 监听change事件, 方便最后验证结果
        self.app.hook_current_page_method("swiperChange", callback.callback)
        el = page.get_element("swiper")
        el.swipe_to(2)  # 切换到第二个tab
        self.assertTrue(callback.wait_called(timeout=10), "callback called")
        self.assertEqual(callback.get_callback_result()["detail"]["current"], 2, "pick ok")
```

---

## move_to() :id=move_to
> movable-view 容器拖拽滑动


**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|  x |int|None|x 轴方向的偏移距离|
|  y |int|None|y 轴方向的偏移距离|

*PS: x,y 偏移量相对于`movable-area`左上角，如示例中，`movable-area`左上角为(25, 25)*

**Returns:**
- `None`

**代码示例:** 
```xml
<!-- 小程序wxml -->
<movable-area>
  <movable-view x="{{x}}" y="{{y}}" direction="all">text</movable-view>
</movable-area>
```

```python
import minium, time
@minium.ddt_class
class TestElement(minium.MiniTest):
    def test_move_to(self):
        page = self.app.redirect_to("/pages/testelement/testelement")
        element = page.get_element("movable-view")
        # reset
        element.move_to(0, 0)   # 把movable-view复位
        time.sleep(2)
        rect = element.rect     # 记录初始位置
        print(rect)
        element.move_to(20, 100)  # 移动到坐标为20, 100的地方
        time.sleep(2)
        self.assertDictContainsSubset(
            {
                "left": 20 + rect.x,
                "top": 100 + rect.y,
            },
            element.rect,
        )
```

---