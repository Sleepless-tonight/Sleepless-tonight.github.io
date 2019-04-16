# Beginning C ,Fifth Edition
#### 前言&nbsp;
有抱负的程序员必将面对的三重障碍，遍布程序设计语言中的各类术语、理解如何使用语言元素（而不仅仅只是知道它们的概念）、领会如何在手机场景中应用该语言。

#### 第1章&nbsp;&nbsp;C 语言编程

##### 1.1&nbsp;&nbsp;C 语言

##### 1.2&nbsp;&nbsp;标准库
标准库定语了编写C程序时常常需要的常量、符号和函数。它还提供了基本C语言的一些可选扩展，标准库以不依赖及其的形式实现，即相同的C代码在不同的底层硬件上会实现相同的功能。

标准库在一系列文件——头文件中指定。头文件的扩展名总是.h。使用一组标准功能可用于C程序文件，只需要将队形标准头文件含进来。

##### 1.3&nbsp;&nbsp;学习 C

##### 1.4&nbsp;&nbsp;创建 C 程序
C 程序的创建工程有 4 个基本步骤：
- 编辑
- 编译
- 链接
- 执行

##### 1.4.1&nbsp;&nbsp;编辑
创建和修改 C 程序的源代码——我们编写的程序指令称之为源代码。

##### 1.4.2&nbsp;&nbsp;编译
编译器可以将源代码转换成机器语言，在编译过程中，会找到并报告错误。编译会生成对象代码，存放于对象文件它与源文件同名，这些文件在Windows中扩展名通常是 .obj,Linux中通常是.o

若编译器是GUN，编译命令是：

```
gcc -c main.c
```

编译过程包括两个阶段：第一个阶段称为预处理阶段，在此期间会修改或添加代码。第二阶段是生成对象代码的实际编译过程。源文件可以包含预处理宏，他们勇于添加或修改 C 语言程序。

##### 1.4.3&nbsp;&nbsp;链接
链接器（linker）将源代码文件中有编译器产生的各种对象模块组合起来，再从C语言提供的程序库中添加必要的代码块，将他们组合成一个可执行的文件，链接器也会检测和报告错误，可以将一个程序拆分成几个源代码文件，再用链接器连接起来，每个源文件提供部分功能，每个源文件分别编译。

链接阶段出现错误，意味着要重新编译源代码，链接成功则会产生一个可执行文件，但这并不意味着程序能正常工作。

##### 1.4.4&nbsp;&nbsp;执行
执行阶段就是当成功完成了前述 3 个过程后运行程序。

##### 1.5&nbsp;&nbsp;创建第一个程序

```
#include <stdio.h>
 
 int main(void){
     printf("Hello world!");
     return 0;
 }
 
```

##### 1.6&nbsp;&nbsp;编辑第一个程序

```
/* 注意 \" ， \"序列称之为转义序列（escape sequence）。 */
#include <stdio.h>
 
 int main(void){
     printf("Hello world!\n");
     return 0;
 }
 
```

##### 1.7&nbsp;&nbsp;处理错误

根据编译器提示，处理错误吧。

##### 1.8&nbsp;&nbsp;剖析一个简单的程序

##### 1.8.1&nbsp;&nbsp;注释

```
多行注释：/*    */；无论 /* 之后的任何文本都会被认为是注释直到标示注释结束的 */ 为止。
单行注释：//；代码行上两个斜杠后面的所有内容都会被编译器忽略。
```

##### 1.8.2&nbsp;&nbsp;预处理指令

下面的代码行：
```
#include <stdio.h>
```

符号 # 标示这是一个预处理指令（preprocessing directive），告诉编译器在编译源代码前，要先执行一些操作，编译器在编译过程开始前的预处理阶段处理这些指令，预处理指令相当多，大多数放于程序源文件的开头。

在这个例子中，编译器要将 stdio.h 文件的内容包含进来，这个文件称之为头文件（header file），因为它通常放在程序的开头出。在本例中，头文件定义了 C 标准库中的一些函数信息，通常，在头文件中指定的信息应有编译器用于在程序中集成预定义函数和其他全局对象，有时需要创建自己的头文件。本例中用到标准库中的printf()函数，所以必须包含 stdio.h 头文件。 stdio.h 头文件包含了编译器理解 printf() 以及其他输入/输出函数所需要的信息。名称 stdio 是标准输入/输出（standard input/output）的缩写。C 语言中石油的头文件的扩展名都是 .h 。

> 注意：
>
> &nbsp;&nbsp;&nbsp;&nbsp;在一些系统中，头文件名是不区分大小写的，但在#include 指令里，这些文件名通常是小写。

##### 1.8.3&nbsp;&nbsp;定义 main() 函数

下面的5行指令定义了main()函数：
```
 int main(void)
 {
     printf("Hello world!\n");
     return 0;
 }
```
函数是两个括号主键执行某组操作的一段代码，每个 C 程序都是由一个或多个函数组成，每个 C 程序都必须有个 main() 函数，main()函数是每个 C 程序的执行起点。在执行阶段执行可执行文件时，操作系统会执行这个程序的main()函数。

定义main()函数的第一行代码如下：
```
int main(void)
```
定义main()函数的第一行代码开头是一个关键字 int，它标示main()函数的返回值类型。

在下面的语句中，指定了执行完 main()函数后要返回的值：
```
return 0;
```
这个 return 语句结束了 main() 函数的执行。

函数名“main”后面的括号，是给函数main传递信息的入口，void 表示 给 main()函数传递的数据是无。

##### 1.8.4&nbsp;&nbsp;关键字

##### 1.8.5&nbsp;&nbsp;函数体
函数体是在函数名称后面起始及结束两个大括号之间的代码块。

每个函数必须有函数体，但函数体可以是空的。

##### 1.8.6&nbsp;&nbsp;输出信息

printf() 是一个标准的库函数，它会将给printf() 函数传递的信息输出到命令行上。

##### 1.8.7&nbsp;&nbsp;参数

包含在函数名后圆括号内的项称为参数，它是指要传递诶函数的数据，当一个函数有多个参数时，要用逗号隔开。

##### 1.8.8&nbsp;&nbsp;控制符

反斜杠(\)在文本字符串里具有特殊意义，他表示转义序列的开始。反斜杠后面的字符表示是哪种转义序列。

表 1-1 是转义序列表：
![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/2019-04-12_183608.png)

##### 1.8.9&nbsp;&nbsp;三字母序列

这类转义序列存在的唯一原因是，有9个特殊的字母序列，称之为三字母序列，这是包含三个字母的序列，分别表示#、[、]、\、^、~、|、{和}：

![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/2019-04-12_185336.png)

在 International Organization of Standardization(ISO)不变的代码集中编写C代码时，需要用到它们，可以完全不用理会它们，使用三字母序列时，编译器会发出一个警告，因为通常是不应该使用三字母序列的。

##### 1.9&nbsp;&nbsp;预处理器

预处理指令可以把头文件的内容包含到源文件中。编译的预处理阶段可以做的工作远不止此，除了指令外，源文件还可以包含宏。宏是提供给预处理器的指令，来添加或修改程序中的 C 语句。宏可以很简单，只定义一个符号，例如INCHES_PER_FOOT，只要出现这个符号，就用12代替。其指令如下：

```
#define  INCHES_PER_FOOT 12
```

在源文件中包含这个指令，则代码中只要出现 INCHES_PER_FOOT ，就用 12 替代它。例如：
```
printf("Hello world!\n",INCHES_PER_FOOT);

```
在预处理后，这个语句变成：
```
printf("Hello world!\n",12);

```
宏也可以很复杂，根据特定的条件把大量代码添加到源文件中。

##### 1.10&nbsp;&nbsp;用 C 语言开发程序
介绍编写程序时需要完成的基本步骤。

##### 1.10.1&nbsp;&nbsp;了解问题

了解需求，定义程序要解决的问题部分。


##### 1.10.2&nbsp;&nbsp;详细设计

讲需求分解为可管理的单元模块，描述这些独立模块互相沟通的方式。


##### 1.10.3&nbsp;&nbsp;实施

有计划的实施。

##### 1.10.4&nbsp;&nbsp;测试

##### 1.11&nbsp;&nbsp;函数及模块化编程

大多数编程语言都提供一种方法，将程序切割成多个段，各个段都可以独立编写。在 C 语言中这些段称之为函数。

每个函数都完成一个指定的、定义明确的工作，程序中操作的执行由一个main()总体掌控。

程序切割成多个易于管理的小单元，对编程非常重要。

##### 1.12&nbsp;&nbsp;常见错误

编译和连接报错好找，但是不报错缺得不到正确的结果才是头疼的。


##### 1.13&nbsp;&nbsp;要点


![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/2019-04-13_171407.png)


#### 第2章&nbsp;&nbsp;编程初步

在程序中仓储数据项的地方是可以变化的，叫做变量(variable)，这是本章的主题。

**本章的主要内容：**
- 内存的用法及变量的概念
- 在 C 中如何计算
- 变量的不同类型及其用途
- 强制类型转换的概念及其使用场合
- 编写一个程序，计算树木的高度

##### 2.1&nbsp;&nbsp;计算机的内存

计算机执行程序时，组成程序的指令和程序操作的数据都必须存储到某个地方。这个地方就是机器的内存，也称之为主内存(main memory)，或随机访问存储器(Random Access Memory, RAM)，RAM是易失性存储器。关闭 PC 后，RAM 的内容就会丢失。PC 把一个或多个磁盘驱动器作为其永久存储器。要在程序结束执行后存储起来的任何数据，都应该写入磁盘。

计算机用二进制存储数据：0 或 1.计算机有时用真(true)和假(false)表示它们：1 是真，0 是假。每一个数据称之为一个位(bit),即二进制数(binary digit)的缩写。

内存中的位以 8 个为一组，没组的 8 位称之为一个字节(byte)。为了使用字节的内容，每个字节用一个数字表示，第一个字节用 0 表示，第二个字节用 1 表示，直到计算机内存的最后一个字节。字节的这个数字标记称之为字节的地址(address)。因此，每个字节的地址都是唯一的。字节的地址唯一地表示计算机内存中的字节。

总之，内存的最小单位是位(bit)，将8个位组合为一组，称之为字节(byte)。每个字节都有唯一的地址。字节的地址从 0 开始。位只能是 0 或 1 ，如图所示：

![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/2019-04-13_182303.png)

计算机的内存的常用单位是千字节(KB)、兆字节(MB)、千兆字节(GB)。磁盘驱动器还使用兆兆字节(TB)。这些单位的大小如下：
- 1KB 是1024 字节。
- 1MB 是1024 KB，也就是1 048 576 字节。
- 1GB 是1024 NB，也就是1 072 741 841 字节。
- 1TB 是1024 GB，也就是1 099 511 627 776 字节。

如果 PC 有 1GB 的 RAM ，字节地址就是0~1 073 741 841 。0 到 1023 共 1024 个数字(1 byte ,8位)，MB 需要 20 个位，GB 需要 30 个位，

##### 2.2&nbsp;&nbsp;什么是变量

变量时计算机里一块特定的内存，它是由一个或多个连续的字节组成，一般是1、2、4、8 或 16 字节。每个变量都有一个名称，可以用该名称表示内存的这个位置，以提取它包含的数据或存储一个新的数值。

**变量的命名**

给变量指定名称一遍称为变量名。变量的命名是很有弹性的。可以由：字母、数字、下划线（_）组成，要以字母开头。以一或两个下划线开头的变量名常用字头文件中，所以在源代码中给变量命名时，不要讲下划线作第一个字符，以免和标准库里的变量名冲突。变量名的另一个要点是，变量名是区分大小写的。
> **警告：**
>
> &nbsp;&nbsp;&nbsp;&nbsp;变量名可以包含的字符数取决于编译器，遵循 C 语言标准的编译器至少支持 31 个字符，只要不超过这个程度就没问题。有些编译器会截短过长的变量名。

##### 2.3&nbsp;&nbsp;存储整数的变量

```
int salary ;
```
这个语句称为变量声明，因为它声明了变量的名称，在这里，变量名是 salary。

变量声明也指定了这个变量存储的数据类型。这里使用关键字 int 指定 salary 用来存放一个整数。

变量声明也称为变量的定义，因为它分配了一些存储空间，来存储整数数值，该整数可用变量名 salary 来引用。

**注意：**

声明引入了一个变量名，定义则给变量分配了存储空间，有这个区别的原因在本书后面会很清楚。

现在还未指定变量 salary 的值 ，所以此刻该变量包含一个垃圾值，即上次使用这块内存空间时遗留在此的值。

下一个语句是：

```c
salary = 10000;
```
这是一个简单的算数赋值语句，它将等号右边的数值存储到等号左边的变量中。

等号“=”称为赋值运算符，它将右边的值赋予左边的变量。

然后是熟悉的 printf() 语句，但它有两个参数：
```
printf("My salary is %d.",salary);
```
- 参数1：控制字符串，用来控制气候的参数输出以书面方式显示，它是放在双引号内的字符串，也称为格式字符串，因为它制定了输出数据的格式。
- 参数2：是变量名 salary，这个变量的显示方式由第一个参数——控制字符串来确定。

在控制字符串在有个%d，它称为变量值的转换说明符（conversion specific）。

转换说明符确定变量在屏幕上显示的方式，换言之，他们制定最初的二进制值转换为什么形式，显示在屏幕上。在本列中使用了 d，它是应用于整数值的十进制说明符，表示第二个参数salary输出为一个十进制数。

> **注意：**
>
> &nbsp;&nbsp;&nbsp;&nbsp;转换说明符总是以%字符开头，以便 printf()函数识别出它们。所以如果要输出%字符，就必须用转义序列%%。

控制字符串可以存在多个转换说明符，例如：

```
int brides = 5;
int brothers = 10;
printf("%d My salary is %d .",brides,brothers);
```

在一个语句中声明多个同类型的变量时，可以用逗号将数据类型后面的变量名分开。例如：

```
int brides ,brothers ;

int brides2 ,
    brothers2 ;
```

##### 2.3.1&nbsp;&nbsp;变量的使用

下面的代码展示了将两个整数变量进行计算并赋值个变量 a 。

```
int brides = 5;
int brothers = 10;
int a = brides + brothers;
printf(" My salary is %d .",a);
```

##### 2.3.2&nbsp;&nbsp;变量的初始化

变量的声明：

```
int salary ;
```
此时变量的值是上一个程序在那块内存中留下的数值，它可以是任何数。

变量的初始化：
```
salary = 10 ;
```
最好在声明变量时就对其进行初始化：
```
int salary = 10 ;
```

**1、基本算数运算**
在 C 语言中，算数语句的格式如下：

```
变量名 = 算数表达式；
```

赋值运算符右边的算数表达式指定使用变量中存储的值或者直接的数字，以算术运算符如加（+）、减（-）、乘（*）、除（/）、取模（%）等运算符进行计算。例如：

```
int brides = 5;
int brothers = 10;
int a = brides + brothers + 5 ;
```

赋值运算先计算赋值运算符右边的算数表达式，再将所得结果赋值到左边的变量中。

> **注意：**
>
> &nbsp;&nbsp;&nbsp;&nbsp;应用运算符的值称为操作数。需要两个操作数的运算符(如%)称为二元运算符。应用于一个值的运算符称为一元运算符。因此-在表达式a-b中是二元运算符,在表达式-data中是一元运算符。


如果两个或多个字符串彼此相邻,编译器会将它们连接起来,构成一个字符串。

例如：

```
    int a = 10;
    int b = 20;
    printf("字符串1!%d \n-- \n""字符串2!%d", a, b);
    //或者
    printf("字符串1!%d \n-- \n"
    "字符串2!%d",
     a, b);

```

##### 2.4&nbsp;&nbsp;变量和内存





















