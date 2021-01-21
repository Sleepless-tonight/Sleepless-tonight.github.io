# Beginning C ,Fifth Edition

## 第4章 循环
本章将介绍如何重复执行一个语句块,直到满足某个条件为止,这称为循环。语句块的执行次数可以简单地用一个计数器来控制,语句块重复执行指定的次数,或者还可以更复杂一些,重复执行一个语句块,直到满足某个条件为止,例如用户输入 quit。后者可以编写上一章的计算器示例,使计算过程重复需要的次数,而不必使用goto语句。

**本章的主要内容**
- 使语句或语句块重复执行指定的次数
- 重复执行语句或语句块,直到满足某个条件为止
- 使用for, while和do-while循环
- 递增和递减运算符的作用及其用法
- 编写一个简单的Simon游戏程序

### 4.1 循环
循环是带有比较数据项功能的一个基本编程工具。循环总是隐含了某种比较,因为它提供了终止循环的方式。典型的循环是使一系列语句重复执行指定的次数,这种循环会存储循环块执行的次数,与需要的重复次数相比较,比较的结果确定何时应终止循环。

### 4.2 递增和递减运算符
```
++ number;
-- number;
```


### 4.3 for 循环
![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/2021-01-18_192608.png)


### 4.4 for 循环的一般语法

```
for(int i = 1, j = 2; i<=5; ++i,j = j+2)
printf("%5d",i*j);

```

### 4.5 再谈递增和递减运算符



#### 4.5.1 递增运算符
先看看递增运算符。假如变量的类型是 int ，下面的3调语句有相同的结果：
```
count = count + 1;
count += 1;
++count;
```
这些语句都给变量 count 加 1.最后一致形式最简洁。
也可以在表达式中使用递增运算符。这个运算符在表达式中的动作是递增变量的值,然后,在表达式中使用递增的值。例如,假设count的值是5,执行如下语句:
```
total =+count +6;
```
变量count会递增到6,在计算等号右边的表达式时,会使用这个值。因此变量total的值为12,这个指令改变两个变量count和total.

#### 4.5.2 递增运算符的前置和后置形式。
前面将++运算符放在变量前面,这叫做前置形式。这个运算符也可以写在变量的后面,这称为后置形式。在表达式中使用前置和后置形式的效果大不相同。如果在表达式中编写的是count++,则变量count的值在使用之后才递增。这看起来有点复杂。修改前面的例子:
```
total = 6 + count ++;
```


#### 4.5.3 递减运算符
递减运算符的操作和递增运算符完全相同。它的形式是--,作用是给它操作的变量减1。它的使用方式和++完全相同。例如,假设变量count是int类型,下面3条语句会有相同的结果:
```
count = count - 1;
count -= 1;
--count;
```


### 4.6 再论 for 循环
```C
#include "stdio.h"
int main(void){
    unsigned long long int sum = 0LL;
    unsigned int count = 0;
    printf("\nEnter the number of integers you want to sum:");
    scanf("%u", &count);
    for (int i = 1; i <= count; ++i) {
        sum += i;
    }
    printf("\nTotal of the first %u numbers is %llu\n", count, sum);
    return 0;
}
```

#### 4.6.1 修改 for 循环变量
上面的程序完全可以写为下面这样，结果完全一样：
```
#include "stdio.h"
int main(void){
    unsigned long long int sum = 0LL;
    unsigned int count = 0;
    printf("\nEnter the number of integers you want to sum:");
    scanf("%u", &count);
    for (int i = 1; i <= count; sum += i++) ;
    printf("\nTotal of the first %u numbers is %llu\n", count, sum);
    return 0;
}
```

#### 4.6.2 没有参数的 for 循环








