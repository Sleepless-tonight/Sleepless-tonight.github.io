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
```
int main(void){

    bool a = true;
    double x = 10.25;
    double less = 0.0;
    less = floor(x);
    label: ;
    --less;
    printf("test %.2f \n", less);


    goto label;



    --less;
    printf("test %.2f \n", less);
    --less;
    less = (less--);
    printf("test %.2f \n", less);

    printf("Hello\n world!");
    printf("Hello\t world!");
    return 0;
}

```
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

##### 掩码
只有两个位都是1,结果才是1,此时可以使用 & 运算符选择整数变量的一个部分,甚至可以选择其中的一个位。首先定义一个值,它一般称为掩码,用于选择需要的位。在掩码中,希望保持不变的位置上包含1,希望舍弃的位置上包含0。接着对这个掩码与要从中选择位的值执行按位与操作。下面看一个例子。下面的语句定义了掩码:
```
// 00000000000000000000000000000001
unsigned int male=0x1;// Mask selecting first (rightmost) bit 
// 00000000000000000000000000000010
unsigned int french= 0x2;// Mask selecting second bit
// 00000000000000000000000000000100
unsigned int german= 0x4;// Mask selecting third bit
// 00000000000000000000000000001000
unsigned int italian =0x8;// Mask selecting fourth bit/
// 00000000000000000000000000001010
unsigned int payBracket = 0x10;// Mask selecting fifth bit
```
在每条语句中, 1位表示该条件是true。这些二进制掩码都选择一个位,所以可以定义一个 unsigned int 变量 personal_data 来存储一个人的 5 项信息。如果第一位是 1,这个人就是男性,如果是 0,这个人就是女性。如果第二位是 1,这个人就说法语,如果是 0 这个人就不说法语,数据值右边的 5 位都是这样。
因此,可以给一个说德语的人测试变量 personal_data ,如下面的语句所示:
```
if (personal_data & german)
/* Do something because they speak German */
```
如果 personal_data 对应掩码 german 的位是1,表达式personalData & german的值就不是0(true),否则就是0。
> 任何非零数值在转换为 bool 类型时,都得到 true。这表示,可以把算术表达式的结果赋予 bool 变量,如果它是非零值,就存储 true ,否则就存储 false.

> 掩码 german 其它位均为0，会将 personal_data 除 第三位 之外的值均为 0，
> 
> 当 personal_data 第三位的值是 1 时，personal_data & german 表达式的结果是 00100，否则的结果 00000
> 
> 因为 非 0 的数转化为 bool 时 会得到 true ，说以，只要 当 personal_data 第三位的值是 1 时 与掩码 00100 进行与运算，则可得到 true 变量，以此确定 personal_data 的第三位的值。
>
> 总结一下：一个指定位为1其它位均为0的掩码与另一个数据进行 与 运算，则可以确定另一个数据指定位的值是否为 1。

另一个需要理解的操作是如何设置各个位。此时可以使用按位 或(OR) 运算符。按位或运算符与测试位的掩码一起使用,就可以设置变量中的各个位。如果要设置变量 personal_data,记录某个说法语的人,就可以使用下面的语句:
```
 personal_data |= french;
```
上面的语句与如下语句等效：
```
personal_data = personal_data | french;
```

> 掩码 french 第二位为 1，其它位均为0，
>
> personal_data 与 掩码 french 进行 或(OR) 运算时：personal_data 的其它位为 1 时，与 0 或运算后结果也是 1，personal_data 的其它位为 0 时，与 0 或运算后结果也是 0，personal_data 第二位 与 1 进行或运算时会被设置为1。
> 
> 总结一下： 指定位数据与 0 进行或运算时会保持原值，与 1 进行或运算时会被设置为1，也就是完成了指定位数据赋值。

personal_data 中从右数的第二位设置为1,其他位都不变。利用运算符的工作方式,可以在一条语句中设置多个位:
上面的语句与如下语句等效：
```
personal_data = personal_data | french | german | male;
```
> 非（~）运算
>
> 非运算即取反运算，在二进制中1变0,0变1
> ~110101
> =001010
##### 重置一个位
如何重置一个位?假定要将男性位设置为女性,就需要将一个位重置为0,此时应使用~运算符和按位与(AND)运算符:
```
personal_data &= ~male;
```
这是可行的,因为~male将表示男性的位设置为0,其他位仍设置为1。因此,对应于男性的位设置为0, 0与任何值的与操作都是0,其他位保持不变。如果另一个位是1,则1&1仍是1。如果另一个位是0,则0&1仍是0.使用位的例子记录了个人数据的特定项。如果要使用Windows应用程序编程接口(API)编写PC程序,就会经常使用各个位来记录各种Windows参数的状态,在这种情况下,按位运算符非常有用。

```
int main(void){
    unsigned int original = 0xABC;
    unsigned int result = 0;
    unsigned int mask = 0xF;    // Rightmost four bits 最右边的四位
    printf("\n original = %X", original);

    // insert first digit in result
    result |= original & mask;  // Put right 4 bits from original in result 将结果从原位置右移4位
    // Get second digit 得到第二位数
    original >>= 4;             // shift original right four positions 移动原始的右四个位置
    result <<= 4;               // Make room for next digit 给下一位腾出位置
    result |= original & mask;  // Put right 4 bits from original in result 将结果从原来的4位右移

    // Get third digit 得到第二位数
    original >>= 4;             // Shift oriqinal right four positions  向右移动原来的四个位置
    result <<= 4;               // Make room for next digit 给下一位腾出位置
    result |= original & mask;  // Put right 4 bits from original in result 返回结果的右4位
    printf("\t result = %X\n", result);
    return 0;
}
```

这个程序使用了前面探讨的掩码概念。original中最右边的十六进制数是通过表达式original & mask将original和mask的值执行按位与操作而获得的。这会把其他十六进制数设置为0,因为mask的值的二进制形式为:
```
0000 0000 0000 1111
```
可以看出, original中只有右边的4位没有改变。这4位都是1,在执行按位与操作的结果中,这4位仍是1,其他位都是0,这是因为0与任何值执行按位与操作,结果都是0,选择了右边的4位后,用下面的语句存储结果:
```
result |= original & mask;  // Put right 4 bits from original in result 
```
result的内容与右边表达式生成的十六进制数进行或操作。为了获得original中的第二位,需要把它移动到第一个数字所在的位置。为此将original向右移动4位:
```
original >>= 4;  
```
第一个数字被移出,且被舍弃。为了给original的下一个数字腾出空间,下面的语句将result的内容向左移动4位:
```
result <<= 4;  
```
现在要在result中插入original中的第二个数字,而当前这个数字在第一个数字的位置上,使用下面的语句:
```
result |= original & mask;  // Put right 4 bits from original in result  
```
要得到第三个数字,重复上述过程。显然,可以对任意多个数字重复这个过程。

### 3.4 设计程序


#### 3.4.1 问题

#### 3.4.2 分析

#### 3.4.3 解决方案


### 3.5 小节

### 3.6 联系

