# Beginning C ,Fifth Edition

## 第6章：字符串和文本的应用
本章将探讨如何使用字符数组,以扩展数组知识。我们经常需要将文本字符串用作个实体,不过C语言没有提供字符串数据类型,而是使用char类型的数组元素存储字符串。本章将介绍如何创建和处理字符串变量,标准库函数如何简化字符串的处理。

**本章的主要内容:**
- 如何创建字符串变量
- 如何连接两个或多个字符串,形成一个字符串
- 如何比较字符串
- 如何使用字符串数组
- 哪些库函数能处理字符串,如何应用它们


### 6.1 什么是字符串
字符串常量的例子非常常见。字符串常量是放在一对双引号中的一串字符或符号。一对双引号之间的任何内容都会被编译器视为字符串,包括特殊字符和嵌入的空格。每次使用printr)显示信息时,就将该信息定义成字符串常量了。以下的语句是用这种方法使用字符串的例子:
```
printf ("This is a string.");
printf ("This is on\ntwo lines!");
printf ("For \" you write \\\".");
```
这3个字符串例子如图6-1所示。存储在内存中的字符码的十进制值显示在这些字符的下方。

第一个字符串是一系列字符后跟一个句号。printf()函数会把这个字符串输出为:
```
This is a string.
```
第二个字符串有一个换行符\n,所以字符串显示在两行上:
第一个字符串是一系列字符后跟一个句号。printf()函数会把这个字符串输出为:
```
This is on
two lines!
```







