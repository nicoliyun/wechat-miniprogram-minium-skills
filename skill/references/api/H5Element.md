# `Class` minium.H5Element :id=minium-h5element
> `H5Element` 提供了对页面元素控件进行操作, 以及在控件内查找子控件的能力

通过调用[`H5Page.get_element`](https://minitest.weixin.qq.com/#/minium/Python/api/H5Page?id=get_element)方法获取`H5Element`实例

**Properties:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|inner_text|str|Not None|元素文本|

---

## tap() :id=tap
> 点击元素，部分只监听touch事件的元素，无法用click()点击

**Returns:**
- `None`
  
**代码示例:** 

```python
import minium
@minium.ddt_class
class TestElement(minium.MiniTest):
    def setUp(self):
        self.logger.info(self.app.platform)
        self.app.relaunch("/pages/webview/webview")

    def test_tap(self):
        element = self.page.get_element('//*[@id="home-drug-eyao"]/div/div[2]/div[1]/div[1]')
        element.tap()
```


---

## click() :id=click
> 点击元素

**Returns:**
- `None`
  
**代码示例:** 

```python
import minium
@minium.ddt_class
class TestElement(minium.MiniTest):
    def setUp(self):
        self.logger.info(self.app.platform)
        self.app.relaunch("/pages/webview/webview")

    def test_click(self):
        h5el = self.page.get_element('用药查询')
        h5el.click()
```

---

## input() :id=input
> input & textarea 组件输入文字


**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|text|str|None|输入文本|
|with_confirm|bool|False|输入完毕后, 是否触发confirm事件。即输入完毕后, 是否需要触发键盘上的确认/发送等按钮|

**Returns:**
- `None`
  
**代码示例:** 

```python
import minium
@minium.ddt_class
class TestElement(minium.MiniTest):
    def setUp(self):
        self.logger.info(self.app.platform)
        self.app.relaunch("/pages/webview/webview")

    def test_h5_element_input(self):
        h5page = self.page
        # input
        element = h5page.get_element(
            '//*[@id="app"]/div[1]/div/div[1]/div[1]/div/div[2]/div[15]'
        )
        element.click()
        element_input = h5page.get_element(
            '/html/body/div/div/div/div[2]/div/div/div[1]/div/div/form/input'
        )
        element_input.input("测试输入")
        element_search = h5page.get_element(
            '/html/body/div/div/div/div[2]/div/div/div[1]/div/span[1]'
        )
        element_search.click()
        element_result = h5page.get_element(
            '/html/body/div/div/div/div[1]/div/div/div[2]/div/div[5]/div/p[1]'
        )
        self.assertEqual(
            "没有找到相关结果",
            element_result.inner_text,
        )

```

---

## input_clear() :id=input_clear
> 清空input & textarea 组件输入的文字


**Parameters:**

- `None`

**Returns:**
- `None`
  
**代码示例:** 

```python
import minium
@minium.ddt_class
class TestElement(minium.MiniTest):
    def setUp(self):
        self.logger.info(self.app.platform)
        self.app.relaunch("/pages/webview/webview")

    def test_h5_element_input_clear(self):
        h5page = self.page

        # input_clear
        element = h5page.get_element(
            '//*[@id="app"]/div[1]/div/div[1]/div[1]/div/div[2]/div[15]'
        )
        element.click()
        # time.sleep(2)
        element_input = h5page.get_element(
            '/html/body/div/div/div/div[2]/div/div/div[1]/div/div/form/input'
        )
        element_input.input("测试输入")
        # time.sleep(2)
        element_search = h5page.get_element(
            '/html/body/div/div/div/div[2]/div/div/div[1]/div/span[1]'
        )
        element_search.click()
        # time.sleep(3)
        element_result = h5page.get_element(
            '/html/body/div/div/div/div[1]/div/div/div[2]/div/div[5]/div/p[1]'
        )
        self.assertEqual(
            "没有找到相关结果",
            element_result.inner_text,
        )
        element_afterinput = h5page.get_element(
            '/html/body/div/div/div/div[1]/div/div/div[1]/div[1]/div/form/input'
        )
        element_afterinput.input_clear()
        element_search = h5page.get_element(
            '/html/body/div/div/div/div[1]/div/div/div[1]/div[1]/span[2]'
        )
        self.assertEqual(
            "取消",
            element_search.inner_text)

```

---

## get_classname() :id=get_classname
> 获取元素的classname


**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|name|str/list|Not None|属性名称|

**Returns:**
- 属性值列表, `list`

  
**代码示例:** 

```python
import minium
@minium.ddt_class
class TestElement(minium.MiniTest):
    def setUp(self):
        self.logger.info(self.app.platform)
        self.app.relaunch("/pages/webview/webview")

    def test_h5_element_get_classname(self):
        h5page = self.page

        # get_classname
        element = h5page.get_element(
            '.tool-content'
        )
        self.assertEqual(
            "tool-content",
            element.get_classname(),
        )

```

---

## get_src() :id=get_src
> 获取img元素的src


**Parameters:**

- `None`

**Returns:**
- `None`
  
**代码示例:** 

```python
import minium
@minium.ddt_class
class TestElement(minium.MiniTest):
    def setUp(self):
        self.logger.info(self.app.platform)
        self.app.relaunch("/pages/webview/webview")

    def test_h5_element_get_src(self):
        h5page = self.page
        # get_src
        element = h5page.get_element(
            '//img'
        )
        self.assertIsNotNone(element.get_src())

```

---

## attribute() :id=attribute
> 获取元素属性


**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|name|str/list|Not None|属性名称|

**Returns:**
- 属性值列表, `list`
  
**代码示例:** 

```python
import minium
@minium.ddt_class
class TestElement(minium.MiniTest):
    def setUp(self):
        self.logger.info(self.app.platform)
        self.app.relaunch("/pages/webview/webview")

    def test_h5_element_attribute(self):
        h5page = self.page
        element = h5page.get_element(
            '/html/body/div/div/div/div[1]/div/div[2]/div/div/div/div/div[1]'
        )
        self.assertEqual(element.attribute("role"), "button")
        self.assertListEqual(element.attribute(["role","class"]),['button', 'tool-item'])

```

---

## long_press() :id=long_press
> 长按元素


**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|duration|int|350|时长，ms|

**Returns:**
- `None`
  
**代码示例:** 

```python
import minium
@minium.ddt_class
class TestElement(minium.MiniTest):
    def setUp(self):
        self.logger.info(self.app.platform)
        self.app.relaunch("/pages/webview/webview")

    def test_h5_element_long_press(self):
        h5page = self.page
        element = h5page.get_element(
            '/html/body/div/div/div/div[1]/div/div[2]/div/div/div/div/div[1]'
        )
        element.long_press(3000)

```

---

## move() :id=move
> 移动元素（触发元素的 touchstart、touchmove、touchend 事件）


**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|x_offset|int|Not None|x 方向上的偏移，往右为正数，往左为负数|
|y_offset|int|Not None|y 方向上的偏移，往下为正数，往上为负数|
|move_delay|int|350|移动前摇，ms|
|smooth|bool|False|平滑移动|

**Returns:**
- `None`
  
**代码示例:** 

```python
import minium
@minium.ddt_class
class TestElement(minium.MiniTest):
    def setUp(self):
        self.logger.info(self.app.platform)
        self.app.relaunch("/pages/webview/webview")

    def test_h5_element_move(self):
        h5page = self.page
        element = h5page.get_element(
            '/html/body/div/div/div/div[1]/div/div[2]/div/div/div/div/div[1]'
        )
        element.move(-1000, 0, 350, False)

```

---


## touch_start() :id=touch_start
> 触发元素的 touchstart 事件


**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|touches|list|Not None|说明见[小程序文档](https://developers.weixin.qq.com/miniprogram/dev/framework/view/wxml/event.html#touches)|
|changed_touches|list|Not None|说明见[小程序文档](https://developers.weixin.qq.com/miniprogram/dev/framework/view/wxml/event.html#touches)|

**Returns:**
- `None`
  
---


## touch_move() :id=touch_move
> 触发元素的 touchmove事件


**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|touches|list|Not None|说明见[小程序文档](https://developers.weixin.qq.com/miniprogram/dev/framework/view/wxml/event.html#touches)|
|changed_touches|list|Not None|说明见[小程序文档](https://developers.weixin.qq.com/miniprogram/dev/framework/view/wxml/event.html#touches)|

**Returns:**
- `None`
  
---


## touch_end() :id=touch_end
> 触发元素的 touchend事件


**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|changed_touches|list|Not None|说明见[小程序文档](https://developers.weixin.qq.com/miniprogram/dev/framework/view/wxml/event.html#touches)|

**Returns:**
- `None`
  

---


## styles() :id=styles
> 获取元素的样式属性


**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|names|str \| list|Not None|需要获取的 style 属性|


**Returns:**
- `None`
  
**代码示例:** 

```python
import minium
@minium.ddt_class
class TestElement(minium.MiniTest):
    def setUp(self):
        self.logger.info(self.app.platform)
        self.app.relaunch("/pages/webview/webview")

    def test_h5_element_styles(self):
        h5page = self.page
        element = h5page.get_element(
            '/html/body/div/div/div/div[1]/div/div[2]/div/div/div/div/div[1]'
        )
        self.assertEqual(element.styles("borderColor"), "rgb(13, 124, 255)")
        self.assertListEqual(element.styles(["color", "floodColor"]), ['rgb(13, 124, 255)', 'rgb(0, 0, 0)'])

```

---


## scroll_to() :id=scroll_to
> 元素滚动


**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|  top |int|None|x 轴上滚动的距离|
|  left |int|None|y 轴上滚动的距离|


**Returns:**
- `None`
  
**代码示例:** 

```python
import minium
@minium.ddt_class
class TestElement(minium.MiniTest):
    def setUp(self):
        self.logger.info(self.app.platform)
        self.app.relaunch("/pages/webview/webview")

    def test_h5_element_scroll_to(self):
        h5page = self.page
        element = h5page.get_element(
            '/html/body/div/div/div/div[1]/div/div[2]/div/div/div/div/div[1]'
        )
        element.scroll_to(1000, 0)

```

---


## play() :id=play
> 播放-仅限 video 组件


**Parameters:**

- `None`

**Returns:**
- `None`
  
**代码示例:** 

```python
import minium, time
@minium.ddt_class
class TestElement(minium.MiniTest):
    def setUp(self):
        self.logger.info(self.app.platform)
        self.app.relaunch("/pages/webview/webview")

    def test_h5_video_element(self):
        video = self.page.get_element('/html/body/div/div/div/div[1]/div[1]/div[2]/div/div/div/div/div/video')
        video.play()
        time.sleep(2)
        video.pause()
        time.sleep(2)
        video.seek(20)
        time.sleep(2)
        video.stop()

```

---


## pause() :id=pause
> 暂停-仅限 video 组件


**Parameters:**

- `None`

**Returns:**
- `None`
  
**代码示例:** 

见[play()](#play)

---


## seek() :id=seek
> 跳转到指定位置-仅限 video 组件


**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|position|int|None|跳转到的位置，单位 s|

**Returns:**
- `None`
  
**代码示例:** 

见[play()](#play)

---


## stop() :id=stop
> 停止-仅限 video 组件


**Parameters:**

- `None`

**Returns:**
- `None`
  
**代码示例:** 

见[play()](#play)

---