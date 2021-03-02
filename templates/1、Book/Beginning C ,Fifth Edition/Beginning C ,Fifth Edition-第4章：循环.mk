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
```
 for (;;){
 }
```

#### 4.6.3 循环内的 break 语句
第3章在switch语句中使用过break语句。它的作用是终止switch块中代码的执行,并继续执行跟在switch后的第一行语句。break语句在循环体内的作用和switch基本相同。



#### 4.6.4 使用 for循环限制输入

#### 4.6.5 生成伪随机整数
在前一个例子中,如果程序在每次执行时,可以生成要猜测的数字,该数字每次都不同,就更有趣了。为此,可以使用在头文件<stdlib.h>中声明的函数rand):
```
int chosen = 0;
chosen =rand();
```
每次调用rand()函数,它都会返回一个随机整数,这个值在0到<stdlib.h>定义的RAND-MAX之间。由rand)函数产生的整数称为伪随机数(pseudo-random),因为真正的随机数只能在自然的过程中产生,而不能通过运算法则产生。

每次调用rand()函数,它都会返回一个随机整数,这个值在0到<stdlib.h>定义的RAND MAX之间。由rand()函数产生的整数称为伪随机数(pseudo-random),因为真正的随机数只能在自然的过程中产生,而不能通过运算法则产生。

rand()函数使用一个起始的种子值生成一系列数字,对于一个特定的种子,所产生的序列数永远是相同的。如果使用这个函数和默认的种子值,如上面的代码所示,就总是得到相同的序列数,这会使这个游戏没什么意思,只是在测试程序时比较有用。stdlib.h提供了另一个标准函数srand(),在调用这个函数时,可以用作为参数传递给函数的特定种子值来初始化序列数。

乍看之下,这似乎并没有让猜数游戏改变多少,因为每次执行程序时,必须产生一个不同的种子值。此时可以使用另一个库函数:在<time.h>头文件中声明的函数time()。time()函数会把自1970年1月1日起至今的总秒数返回为一个整数,因为时间永不停歇所以每次执行程序时,都会得到不同的值。time)函数需要一个参数NULL, NULL是在<stdib.h>中定义的符号,表示不引用任何内容。NULL的用法和含义详见第7章。因此,要在每次执行程序时得到不同的伪随机序列数,可以使用以下的语句:
```
srand(time(NULL));
int chosen = 0;  // Use clock value as starting seed
chosen = rand(); // set to a random integer 0 to RAND MAX
```
只需要在程序中调用一次函数srand0)来生成序列。之后每次调用rand0,都会得到另一个伪随机数。上限值RAND MAX相当大,通常是类型int可以存储的最大值。如果需要更小范围的数值,可以按比例缩小rand)的返回值,提供所需范围的值。假设要得到的数值在0到limit(不包含limit)的范围内,最简单的方法如下:
```
srand(time(NULL));
int limit = 20;
int chosen = 0;  // Use clock value as starting seed
chosen = rand() % limit; // 0 to limit - 1
```


#### 4.6.6 再谈循环控制选项
```
for (int i = 1; i <= count; i+=2) {

    }
```



#### 4.6.7 浮点累心的循环控制变量

```
for (double x = 1.0; x < 11; x += 1.0) {
        sum += 1.0/x;
    }
```
这种情形并不常见。注意,分数值通常没有浮点数形式的精确表示,所以不应把相等判断作为结束循环的条件,例如:
```
for (double x = 0.0; x != 2.0; x += 0.2) {

}
```
这个循环应输出0.0-2.0之间的x值,其递增量为0.2,所以应该有11行输出。但0.2没有浮点数形式的二进制精确表示,所以这个循环会使计算机一直运行下去(除非在Microsoft Windows下使用Ctrl+C令它停止)。



### 4.7 while 循环
while 循环 的一般语法如下：
```
while( expression)
    statement1;
statement2;   
```
while循环。在while循环中,只要某个逻辑表达式等于true,就重复执行一组语句。



### 4.8 嵌套循环
有时需要将一个循环放在另一个循环里面。例如计算某条街上每间房子的居住人数。这需要进入每间房子,计算每间房子的居住人数。统计所有的房子是一个外部循环,在外部循环的每次迭代中,都要使用一个内部循环来计算居住人数。



### 4.9 嵌套循环和 goto 语句
有时在这样的深层嵌套循环中,希望从最内层的循环跳到最外层循环的外面,执行最外层循环后面的语句。最内层循环中的break语句只能跳出这个最内层的循环,执行由j控制的循环。要使用break语句完全跳出嵌套循环,需要相当复杂的逻辑才能中断每一层循环,最后跳出最外层的循环。此时可以使用goto语句,因为它提供了一种避免复杂逻辑的方法。例如:
```
for (int i = 0; i < 10; ++i) {
    for (int j = 0; j < 20; ++j) {
        for (int k = 0; k < 20; ++k) {
            /* Do something useful */
             if (must escape) 
             goto out;
        }
    }
}
out:
```
这段代码假定,可以在最内层的循环中修改must escape,发出应结束整个嵌套循环的信号。如果变量must escape是true,就执行goto语句,直接跳到有out标志的语句。这样就可以直接退出整个嵌套循环,不需要在外部循环中进行复杂的判断。


### 4.10 do-while 循环
第3种循环类型是do-while循环。既然已经有for循环和while循环了,为什么还需要这个循环? do-while和这两个循环有非常微妙的区别。它是在循环结束时测试循环是否继续,所以这个循环的语句或语句块至少会执行一次



### 4.11 continue 语句
有时不希望结束循环,但要跳过目前的迭代,继续执行下一个迭代。循环体内的continue语句就有这个作用,它可以编写为:
```
continue;
```




### 4.12 设计程序




#### 4.12.1 问题



### 4.13 小节



### 4.14 习题

























