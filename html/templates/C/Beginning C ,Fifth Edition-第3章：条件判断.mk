# Beginning C ,Fifth Edition

## 第3章 条件判断

本章将在可以编写的程序种类和构建程序的灵活性方面迈出一大步。我们要学习一种非常强大的编程工具:比较表达式的值,根据其结果,选择执行某组语句。也就是说,可以控制程序中语句的执行顺序。

**本章的主要内容:**
- 根据算术比较的结果来判断
- 逻辑运算符的概念及其用法
- 再谈从键盘上读取数据
- 编写一个可用作计算器的程序

### 3.1 判断过程
在程序中做出判断,就是选择执行一组程序语句,而不执行另一组程序语句。在现实生活中,我们总是要做判断。

> 跟 Java 一样。 
#### 3.1.1 算数比较
C中的比较涉及一些新运算符。比较两个值有6个关系运算符：
```
<
<=
==
!=
>
>=
```
这些运算都会得到 int 类型的值。如果比较结果为真,每个操作的结果都是 1,否则如果比较结果为假,则每个操作的结果都是 0。如上一章所述, stabool.h 头文件为这些值定义了符号 true 和 false,于是 2!=3得到 true, 5L>3L 和 6 <= 12 也得到 true,表达式 2==3、5<4和 1.2>= 1.3 都得到 0,即 false。

这些表达式称为逻辑表达式或布尔表达式,因为每个表达式都会得到两个结果之一: true 或 false,关系运算符生成布尔结果,所以可以把结果存储在 bool 类型的变量中。例如:
```
bool result =5 <4;1/ result will be false
```
任何非零数值在转换为 bool 类型时,都得到 true。这表示,可以把算术表达式的结果赋予 bool 变量,如果它是非零值,就存储 true ,否则就存储 false.


#### 3.1.2 基本的 if 语句
有了用于比较的关系运算符后,就需要使用一个语句来做判断。最简单的语句就是 if 语句。如果要比较自己和他人的体重,并根据结果打印不同的句子,就可以编写如下程序:
```
int my_weight = 169;// Weight in 1bs 
int your weight = 175;/ Weight in 1bs 

if(your weight > my weight)
    printf ("You are heavier than me.\n");

if (your weight < my weight)
printf ("I am heavier than you.\n");

if (your weight ==my weight)
    print ("We are exactly the same weight.\n");

```

#### 3.1.3 扩展 if 语句: if-else


#### 3.1.4 在 if 语句中使用代码块


#### 3.1.5 嵌套的 if 语句


#### 3.1.6 测试字符


#### 3.1.7 逻辑运算符
```
&& //与
|| //或
！ //非 
```



#### 3.1.8 条件运算符
三元运算符


#### 3.1.9 运算符的优先级
从表3-2可以看出,所有比较运算符的优先级都低于二元算术运算符,二元逻辑运算符的优先级低于比较运算符。因此,先执行算术运算,再比较,之后执行逻辑操作。赋值是列表中的最后一个,所以它们在其他运算都完成后执行。条件运算符的优先级高于赋值运算符。



### 3.2 多项选择问题

在编程时,常常会遇到多项选择问题。例如,根据候选人是否来自6所不同大学中的一所来选择一组不同的动作。另一个例子是根据某一天是星期几来执行某组语句。在c语言中,有两种方式处理多项选择问题。一种是采用 else-if 形式的 if 语句,这是处理多项选择的最常见方式。另一种是 switch 语句,它限制了选择某个选项的方式,但在使用 switch 语句的场合中,它提供了一种非常简洁且便于理解的解决方案。下面先介绍 else-if 语句。


#### 3.2.1 给多项选择使用 else-if 语句


#### 3.2.2 switch 语句


#### 3.2.2 goto 语句


### 3.3 按位运算符
在进入本章的大型示例之前,还要先学习一组运算符,它们看起来类似于前面介绍的逻辑运算符,但实际上与逻辑运算符完全不同。这些运算符称为按位运算符,因为它们操作的是整数值中的位。按位运算符有6个,如表3-5所示。

![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/2020-12-07_201210.png)


#### 3.3.1 按位运算符的 op= 用法
所有的二元按位运算符都可以在 op= 形式的赋值语句中使用,但 ~ 运算符例外,它是一元运算符。如第2章所述,如下形式的语句:
```
lhs op= rhs;
```
等价于:
```
lhs = lhs op (rhs);
```

例如：
```
value <<= 4;
```


#### 3.3.2 使用按位运算符
从学术的角度来看,按位运算符很有趣,但它们用于什么场合?它们不用于日常的编程工作,但在一些领域非常有效。按位与&、按位或|运算符的一个主要用途是测试并设置整数变量中的各个位。此时可以使用各个位存储涉及二选一的数据。例如,可以使用一个整数变量存储一个人的几个特性。在一个位中存储这个人是男性还是女性,使用3个位指定这个人是否会说法语、德语或意大利语。再使用另一个位记录这个人的薪水是否多于S50000,在这4个位中,都记录了一组数据。下面看看这是如何实现的。

只有两个位都是1,结果才是1,此时可以使用 & 运算符选择整数变量的一个部分,甚至可以选择其中的一个位。首先定义一个值,它一般称为掩码,用于选择需要的位。在掩码中,希望保持不变的位置上包含1,希望舍弃的位置上包含0。接着对这个掩码与要从中选择位的值执行按位与操作。下面看一个例子。下面的语句定义了掩码:
```
unsigned int male=0x1;// Mask selecting first (rightmost) bit 
unsigned int french= 0x2;// Mask selecting second bit
unsigned int german= 0x4;// Mask selecting third bit
unsigned int italian =0x8;// Mask selecting fourth bit/
unsigned int payBracket = 0x10;// Mask selecting fifth bit
```






