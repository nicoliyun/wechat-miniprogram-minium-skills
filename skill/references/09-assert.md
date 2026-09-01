<!--
 * @Author: yopofeng
 * @Date: 2023-01-06 12:16:36
 * @LastEditors: yopofeng yopofeng@tencent.com
 * @LastEditTime: 2023-01-09 16:29:45
 * @FilePath: /minium-doc/minium/Python/framework/assert.md
 * @Description: 
 * 
 * Copyright (c) 2023 by yopofeng yopofeng@tencent.com, All Rights Reserved. 
-->
# 断言

> MiniTest测试框架提供丰富的断言方法

## assertFalse(expr)
> 检查表达式expr是否为False

## assertTrue(expr)
> 检查表达式expr是否为True

## assertRaises(expected_exception)
> 检查是否有预期的错误产生

**代码示例:** 
```python
def raiseValueError():
    raise ValueError("value error")

class FirstTest(minium.MiniTest):
    def test(self):
        with self.assertRaises(ValueError) as cm:
            raiseValueError()
        the_exception = cm.exception
        self.assertEqual(str(the_exception), 'value error')
```

## assertEqual(a, b)
> 判断两个值是否相等, 等同于`a == b`


## assertNotEqual(a, b)
> 检查两个值是否不相等, 等同于`a != b`

## assertAlmostEqual(a, b, places=7)
> 检查两个值是否几乎相等, 精确到小数点后`places`位, 等同于`round(a - b, places) == 0`


## assertNotAlmostEqual(a, b, places=7)
> 检查两个值是否几乎不相等, 与`assertAlmostEqual`相反


## assertSequenceEqual(seq1, seq2)
> 检查两个序列是否相等

**Parameters:**

| 名称 |    类型    | 默认值 | 说明 |
| :--- | :--------: | :----: | :--- |
| seq1 | list/tuple |        |      |
| seq2 | list/tuple |        |      |

## assertListEqual(list1, list2) / assertTupleEqual(tuple1, tuple2)
> 同`assertSequenceEqual`


## assertSetEqual(set1, set2)
> 判断两个集合是否一样


## assertIn(a, b)
> 判断a是否包含在b中, 等同于`a in b`

## assertNotIn(a, b)
> 判断a是否不包含在b中, 等同于`a not in b`


## assertIs(a, b)
> 等同于`a is b`

## assertIsNot(a, b)
> 等同于`a is not b`

## assertDictEqual(d1, d2)
> 判断两个dict是否一样, 判断一样的标准是`key-value`都相等

**Parameters:**

| 名称 | 类型  | 默认值 | 说明 |
| :--- | :---: | :----: | :--- |
| d1   | dict  |        |      |
| d2   | dict  |        |      |

## assertDictContainsSubset(d1, d2)
> 判断的d1是否包含在d2中, d1的`key-value`对在d2中都有

## assertMultiLineEqual(s1, s2)
> 多行文本对比, 判断多行str是否相等

## assertLess(a, b)
> 等同于`a < b`

## assertLessEqual(a, b)
> 等同于`a <= b`

## assertGreater(a, b)
> 等同于`a > b`

## assertGreaterEqual(a, b)
> 等同于`a >= b`

## assertIsNone(a)
> 等同于`a is None`

## assertIsNotNone(a, b)
> 等同于`a is not None`

## assertIsInstance(obj, cls)
> 等同于`isinstance(obj, cls)`

## assertNotIsInstance(a, b)
> 等同于`not isinstance(obj, cls)`

## assertRegex(text, expected_regex)
> `text`满足正则表达式`expected_regex`, 等同于`expected_regex.search(text)`

## assertNotRegex(text, unexpected_regex)
> `text`不满足正则表达式`unexpected_regex`, 等同于`not unexpected_regex.search(text)`

## assertSetContainsSubset(subset, superset)
> 判断subset是否包含在superset中
