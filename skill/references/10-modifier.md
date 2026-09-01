<!--
 * @Author: yopofeng yopofeng@tencent.com
 * @Date: 2023-01-09 16:35:51
 * @LastEditors: yopofeng yopofeng@tencent.com
 * @LastEditTime: 2023-08-28 13:23:29
 * @FilePath: /minium-doc/minium/Python/framework/modifier.md
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
-->
# 用例修饰器
> minium提供一些实用的用例修饰器用以管理用例

## skip(reason)
> 无条件跳过该用例

**代码示例:** 
```python
import minium
class FirstTest(minium.MiniTest):
    @minium.skip("跳过该用例")
    def test_skip(self):
        raise RuntimeError("用例不应被运行")
```

## skipUnless(condition, reason)
> 当`condition is not True`, 跳过该用例

## skipIf(func_or_condition, reason='')
> 有条件跳过用例

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|func_or_condition|FunctionType or bool||条件函数或者条件变量|



**代码示例:** 
```python
import minium
import random

shouldSkip = True

@minium.ddt_class
class FirstTest(minium.MiniTest):
    @minium.skipIf(shouldSkip, "应该跳过该用例")
    def test_skip1(self):
        raise RuntimeError("用例不应被运行")

    @minium.skipIf(lambda :(random.randint(0,10) % 2 == 0), "随机跳过该用例")
    def test_skip2(self):
        self.logger.info("用例可能被随机跳过")

    @minium.skipIf(lambda self: self.test_config.platform == "ide", "platform为ide时跳过该用例")
    def test_skip3(self):
        self.assertNotEqual(self.test_config.platform, "ide", "platform为ide时该用例不应被执行")

    @minium.skipIf(lambda self, value: value % 2 == 0, "跳过value % 2 == 0的用例")
    @minium.ddt_case(1,2,3)
    def test_skip4(self, value):
        self.assertNotEqual(value % 2, 0, "value % 2 == 0的用例不应被执行")

```

## expectedFailure
> 用例预期失败

## expectedException(exception_or_type)
> 用例报预期错误


**代码示例:** 
```python
import minium

class FirstTest(minium.MiniTest):
    
    @minium.expectedException(ValueError("should raise value error"))
    def test_exception1(self):
        raise ValueError("should raise value error")
    
    @minium.expectedFailure
    @minium.expectedException(ValueError("should raise value error"))
    def test_exception2(self):
        raise ValueError("should raise value error2")

    @minium.expectedFailure
    @minium.expectedException(ValueError("should raise value error"))
    def test_exception3(self):
        raise RuntimeError("should raise value error")

    @minium.expectedFailure
    @minium.expectedException(ValueError("should raise value error"))
    def test_exception4(self):
        print("should raise value error")

```


## retry(cnt, expected_exception=None) :id=retry
> 重试

**Parameters:**

|名称| 类型| 默认值| 说明|
| :----- | :-----: | :-----: | :----- |
|cnt|int||重试次数, 被修饰的函数最多运行cnt次|
|expected_exception|Exception or None|None|遇到指定报错才重试, None则遇到任何报错都会重试|


```python
import minium

class FirstTest(minium.MiniTest):
    cnt = 0
    
    @minium.retry(2, ValueError)
    def test_retry(self):
        self.cnt += 1
        if self.cnt % 2:
            raise ValueError("should raise value error")
    
```

## catch(Exception1, Exception2, ... ,) :id=catch
> 忽略指定报错


```python
import minium

class FirstTest(minium.MiniTest):
    cnt = 0
    
    @minium.catch(ValueError, RuntimeError)
    def test_retry(self):
        raise ValueError("should raise value error")
    
```

## justAtPlatform(platform) :id=justAtPlatform
> 指定平台下才运行


```python
import minium

class FirstTest(minium.MiniTest):
    cnt = 0
    
    @minium.justAtPlatform("ide")
    def test_skip(self):
        self.assertTrue(True, "justAtPlatform修饰的用例应被执行")
    
```

## skipAtPlatform(platform) :id=skipAtPlatform
> 跳过指定平台


```python
import minium

class FirstTest(minium.MiniTest):
    cnt = 0
    
    @minium.skipAtPlatform("ide")
    def test_skip(self):
        self.assertTrue(False, "skipAtPlatform修饰的用例应被跳过")
    
```

## justAtCloud :id=justAtCloud
> 仅在平台下才运行


```python
import minium

class FirstTest(minium.MiniTest):
    cnt = 0
    
    @minium.justAtCloud
    def test_skip(self):
        self.assertTrue(True, "justAtCloud修饰的用例应被执行")
    
```

## skipAtCloud :id=skipAtCloud
> 跳过云测平台


```python
import minium

class FirstTest(minium.MiniTest):
    cnt = 0
    
    @minium.skipAtCloud
    def test_skip(self):
        self.assertTrue(False, "skipAtCloud修饰的用例应被跳过")
    
```