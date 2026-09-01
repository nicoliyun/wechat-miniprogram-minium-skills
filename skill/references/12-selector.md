# 元素定位 :id=selector

minium 通过 WXSS 选择器来定位元素的, 目前小程序仅支持以下的选择器：

| 选择器 | 样例 | 样例描述 |
| :---: | :---: | :---: |
|.class	|.intro	|选择所有拥有 class="intro" 的组件|
|#id	|#firstname|	选择拥有 id="firstname" 的组件|
|element|	view|	选择所有 view 组件|
|element, element|	view, checkbox|	选择所有文档的 view 组件和所有的 checkbox 组件|
|::after|	view::after|	在 view 组件后边插入内容|
|::before|	view::before|	在 view 组件前边插入内容|
|a>>>b|	custom-element1>>>.custom-element2>>>.the-descendant|	跨自定义组件的后代选择器|
|/xpath|	/view[1]|	第一个view元素|

***PS:跨自定义组件的后代选择器中 `custom-element1` 和 `.custom-element2` 必须是自定义组件标签或者能获取到自定义组件的选择器***

## 简单选择器
> 关于选择器的一些基础知识：
> [CSS选择器](https://www.w3school.com.cn/css/css_selectors.asp).
> [XPath](https://www.w3school.com.cn/xpath/xpath_syntax.asp).

一个元素的选择器可以由以下格式组成的:
```
tageName + #id + .className
```

e.g: 
```wxml
<view id="main" class="page-section page-section-gap" style="text-align: center;"></view>
```
假如要查找像上面这一个元素的话, 最完整的写法可以这样:

```JavaScript
get_element("view#main.page-section.page-section-gap")
```

还可以这样:

```javaScript
get_element("view[id='main'][class='page-section page-section-gap']")
```

通常我们只需要关注一个元素的 id 和 class 即可。

但是有时候有的情况是, 有一堆没有 id, class相同的同名标签, 我们没办法通过 id 或者 class 来区分了, 比如以下页面:

```wxml
<view class="weui-cell weui-cell_input">
  <input class="weui-input" type="number" placeholder="这是一个数字输入框" />
  <input class="weui-input" password type="text" placeholder="这是一个密码输入框" />
  <input class="weui-input" type="digit" placeholder="带小数点的数字键盘"/>
</view>
```

我们可以通过属性来区分, 如需要寻找这堆元素中的

```wxml
<input class="weui-input" type="digit" placeholder="带小数点的数字键盘"/>
```

可以这样写

```javaScript
get_element("input[type='digit']")
```

或者

```javaScript
get_element("input[placeholder='带小数点的数字键盘']")
```

另外`bindinput` 这一类绑定方法是不能用作寻路依据的。
eg:
```wxml
<input bindinput="inputValue"/>
```
```javaScript
get_element("input[bindinput='inputValue']")  // 这样是匹配不到你要的元素的
```

## 跨自定义组件的后代选择器

### 如何辨别组件是否为自定义组件
1. 看wxml文件或微信开发者工具的wxml pannel, 标签名字不在[小程序官方组件](https://developers.weixin.qq.com/miniprogram/dev/component/)列表中的都是`自定义组件`
2. 看微信开发者工具的wxml pannel, 标签下面有`#shadow-root`的, 则为`自定义组件`, 如下图中`mytest`和`test22`。

*PS: 新版本开发者工具可能会在<page/xxx>的标签下也出现#shadow-root, 这个不需要加到selector中，如图中`pages/testelement/testelement`*。

![自定义组件](https://minitest.weixin.qq.com/resources/自定义组件.png)

![自定义组件2](https://minitest.weixin.qq.com/resources/自定义组件2.png)

### 如何写跨自定义组件的选择器
如上图的例子, 需要定位红框中的`text`元素, 你需要这样写
```javaScript
get_element("mytest >>> test22 >>> text")
```
或者
```javaScript
get_element("mytest").get_element("test22").get_element("text")
```

## 定位不到元素的排查方法

1. 获取 case 失败时，框架记录的页面 wxml 文件(需要打开`teardown_snapshot`配置项, 或 case 是因为`MiniElementNotFoundError`而失败)
2. wxml 文件存储位置可见报告文件中的**用例产物**目录
  - ![用例产物](https://minitest.weixin.qq.com/resources/用例产物.png)
3. 打开对应**用例产物**目录，找到 wxml 后缀的文件就是框架记录的页面 wxml 文件, 记录文件路径
  - ![pagewxml](https://minitest.weixin.qq.com/resources/pagewxml.png)
4. 使用命令排查 selector，例如需要排查selector: `mytest >>> test2 >>> .test2`
  - `miniwxml 04105738.wxml "mytest >>> test2 >>> .test2"`
5. 如果有查找到可能的元素, 可根据提示确认元素是否符合预期，如果符合，请按提示修改选择器.
  - ![searchwxml](https://minitest.weixin.qq.com/resources/searchwxml.png)
6. 另外，也可以尝试使用[Page.get_element](https://minitest.weixin.qq.com/#/minium/Python/api/Page#get_element)/[Page.get_elements](https://minitest.weixin.qq.com/#/minium/Python/api/Page#get_elements)中的`auto_fix`选项, 对 case 进行动态修复
