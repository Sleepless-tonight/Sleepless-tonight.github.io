# Beginning C ,Fifth Edition

## 第7章：指针
第6章已提到过指针,还给出使用指针的提示。本章深入探索这个主题,了解指针的功用。本章将介绍许多新概念,所以可能需要多次重复某些内容。本章很长,需要花一些时间学习其内容,用一些例子体验指针。指针的基本概念很简单,但是可以应用它们解决复杂的问题。指针是用C语言高效编程的一个基本元素。

**本章的主要内容:**
- 指针的概念及用法
- 指针和数组的关系
- 如何将指针用于字符串
- 如何声明和使用指针数组
- 如何编写功能更强的计算器程序


### 7.1 指针初探

指针是C语言中最强大的工具之一,它也是最容易令人困惑的主题,所以一定要在开始时正确理解其概念,在深入探讨指针时,要对其操作有清楚的认识。

第2和第5章讨论内存时,谈到计算机如何为声明的变量分配一块内存。在程序中使用变量名引用这块内存,但是一旦编译执行程序,计算机就使用内存位置的地址来引用它。这是计算机用来引用“盒子(其中存储了变量值)"的值。

请看下面的语句:
```
int number = 5;
```
这条语句会分配一块内存来存储一个整数,使用 number 名称可以访问这个整数。值 5 存储在这个区域中。计算机用一个地址引用这个区域。存储这个数据的地址取决于所使用的计算机、操作系统和编译器。在源程序中,这个变量名是固定不变的,但地址在不同的系统上是不同的。

可以存储地址的变量称为指针(pointers),存储在指针中的地址通常是另一个变量,如图7-1所示。指针 pnumber 含有另一个变量 number 的地址,变量 number 是一个值为 99 的整数变量。存储在 pnumber 中的地址是 number 第一个字节的地址。“指针”这个词也用于表示一个地址,例如"strcat_s()函数返回一个指针"。

![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/2021-03-09_135546.png)

首先,知道变量 pnumber 是一个指针是不够的,更重要的是,编译器必须知道它所指的变量类型。没有这个信息,根本不可能知道它占用多少内存,或者如何处理它所指的内存的内容。char 类型值的指针指向占有一个字节的值,而 long 类型值的指针通常指向占有4个字节的值。因此,每个指针都和某个变量类型相关联,也只能用于指向该类型的变量。所以如果指针的类型是 int,就只能指向 int 类型的变量,如果指针的类型是 float,就只能指向 float 类型的变量。一般给定类型的指针写成 type*,其中 type 是任意给定的类型。

类型名 void 表示没有指定类型,所以 void* 类型的指针可以包含任意类型的数据项地址。类型 void* 常常用做参数类型,或以独立于类型的方式处理数据的函数的返回值类型。任意类型的指针都可以传送为 void* 类型的值,在使用它时,再将其转换为合适的类型。例如, int 类型变量的地址可以存储在 void* 类型的指针变量中。要访问存储在 void* 指针所指地址中的整数值,必须先把指针转换为 int* 类型。本章后面介绍的 malloc() 库函数分配在程序中使用的内存,返回 void* 类型的指针。



#### 7.1.1 声明指针
以下语句可以声明一个指向 int 类型变量的指针:
```
int *pnumber;
```
pnumber 变量的类型是 int *,它可以存储任意 int 类型变量的地址。该语句还可以写作:
```
int* pnumber;
```
这条语句的作用与上一条语句完全相同,可以使用任意一个,但最好始终使用其中的一个。

这条语句创建了 pnumber 变量,但没有初始化它。未初始化的指针是非常危险的,比未初始化的普通变量危险得多,所以应总是在声明指针时对它进行初始化。重写刚才的声明,初始化 pnumber ,使它不指向任何对象:

```
int *pnumber = NULL;
```
NULL 是在标准库中定义的一个常量,对于指针它表示 0,NULL 是一个不指向任何内存位置的值。这表示,使用不指向任何对象的指针,不会意外覆盖内存。NULL 在头文件<stddef.h>. <stdib.h>、 <stdio.h>、<string.h>、<time.h>、<wchar.h>和<locale.h>中定义,只要编译器不能识别NULL,就应在源文件中包含<stddef.h>头文件。

如果用已声明的变量地址初始化pointer变量,可以使用寻址运算符&,例如:

```
int number = 99;
int *pnumber = &number;
```

pnumber 的初值是 number 变量的地址。注意, number 的声明必须在 pnumber 的声明之前。否则,代码就不能编译。编译器需要先分配好空间,才能使用 number 的地址初始化 pnumber 变量。

指针的声明没有什么特别之处。可以用相同的语句声明一般的变量和指针,例如:

```
int number,*pnumber,pve;
```




















































