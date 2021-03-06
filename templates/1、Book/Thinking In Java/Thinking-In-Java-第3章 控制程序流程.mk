## 第3章 控制程序流程
程序必须能操纵自己的世界，在执行过程中作出判断与选择。  

### 3.1 使用Java运算符

几乎所有运算符都只能操作“主类型”（Primitives）（基本类型）。唯一的例外是“=”、“==”和“!=”，它们能操作所有对象（也是对象易令人混淆的一个地方）。除此以外，String类支持“+”和“+=”。

#### 3.1.1 优先级

运算符的优先级决定了存在多个运算符时一个表达式各部分的计算顺序。

#### 3.1.2 赋值

赋值是用等号运算符（=）进行的。它的意思是“取得右边的值，把它复制到左边”。

右边的值可以是任何常数、变量或者表达式，只要能产生一个值就行。但左边的值必须是一个明确的、已命名的变量。

对主数据类型的赋值是非常直接的。由于主类型容纳了实际的值，而且并非指向一个对象的句柄，所以在为其赋值的时候，可将来自一个地方的内容复制到另一个地方。

但在为对象“赋值”的时候，情况却发生了变化。对一个对象进行操作时，我们真正操作的是它的句柄。所以倘若“从一个对象到另一个对象”赋值，实际就是将句柄从一个地方复制到另一个地方。这意味着假若为对象使用“C=D”，那么C和D最终都会指向最初只有D才指向的那个对象。

#### 3.1.3 算术运算符

Java的基本算术运算符与其他大多数程序设计语言是相同的。其中包括加号（+）、减号（-）、除号（/）、乘号（*）以及模数（%，从整数除法中获得余数）。整数除法会直接砍掉小数，而不是进位。


1. 一元加、减运算符

一元减号（-）和一元加号（+）与二元加号和减号都是相同的运算符。
- 例如：
```java
                    x = -a;
```

一元减号得到的运算对象的负值。一元加号的含义与一元减号相反，虽然它实际并不做任何事情。

#### 3.1.4 自动递增和递减

两种很不错的快捷运算方式是递增和递减运算符（常称作“自动递增”和“自动递减”运算符）。其中，递减运算符是“--”，意为“减少一个单位”；递增运算符是“++”，意为“增加一个单位”。举个例子来说，假设A是一个int（整数）值，则表达式++A就等价于（A = A + 1）。

对每种类型的运算符，都有两个版本可供选用；通常将其称为“前缀版”和“后缀版”。。对于前递增和前递减（如++A或--A），会先执行运算，再生成值。而对于后递增和后递减（如A++或A--），会先生成值，再执行运算。

#### 3.1.5 关系运算符

关系运算符生成的是一个“布尔”（Boolean）结果。它们评价的是运算对象值之间的关系。若关系是真实的，关系表达式会生成 true（真）；若关系不真实，则生成 false（假）。关系运算符包括小于（<）、大于（>）、小于或等于（<=）、大于或等于（>=）、等于（==）以及不等于（!=）。等于和不等于适用于所有内建的数据类型，但其他比较不适用于 boolean 类型。

- 1、检查对象是否相等
    - 关系运算符==和!=也适用于所有对象。
    - ==和!=比较的就是对象句柄。
    - 若想对比两个对象的实际内容是否相同？此时，必须使用所有对象都适用的特殊方法equals()。
    - 于 equals()的默认行为是比较句柄。
    - 多数Java类库都实现了equals()，所以它实际比较的是对象的内容，而非它们的句柄。

#### 3.1.6 逻辑运算符

逻辑运算符AND（&&）、OR（||）以及NOT（!）能生成一个布尔值（true或false）。


1. 短路

操作逻辑运算符时，我们会遇到一种名为“短路”的情况。这意味着只有明确得出整个表达式真或假的结论，才会对表达式进行逻辑求值。因此，一个逻辑表达式的所有部分都有可能不进行求值。

短路就是说，当逻辑运算表达式的结果已经得出，剩余的逻辑表达式将不会得到执行。）

#### 3.1.7 按位运算符

二进制下用 1 表示真，0 表示假

按位运算符允许我们操作一个整数主数据类型中的单个“比特”，即二进制位。按位运算符会对两个自变量中对应的位执行布尔代数，并最终生成一个结果。

若两个输入位都是1，则按位AND运算符（&）在输出位里生成一个1；否则生成0。
```java
                1 & 1 = 1
                0 & 1 = 0
                1 & 0 = 0
                0 & 0 = 0
```


若两个输入位里至少有一个是1，则按位OR运算符（|）在输出位里生成一个1；只有在两个输入位都是0的情况下，它才会生成一个0。
```java
                1 | 1 = 1
                0 | 1 = 1
                1 | 0 = 1
                0 | 0 = 0
```

XOR（^，异或）:如果a、b两个值不相同，则异或结果为1。如果a、b两个值相同，异或结果为0。
```java
                1 ^ 1 = 0
                0 ^ 1 = 1
                1 ^ 0 = 1
                0 ^ 0 = 0
```

异或的一个用法，交换两个变量的值。
```java
                int a = 1;//01
                int b = 2;//10
                a=a^b;//a=11
                b=b^a;//b=01
                a=a^b;//a=10
```

NOT（~，也叫作“非”运算符）属于一元运算符；它只对一个自变量进行操作（其他所有运算符都是二元运算符）。按位NOT生成与输入位的相反的值——若输入0，则输出1；输入1，则输出0。
```java
                ~ 1 = 0
                ~ 0 = 1
```

按位运算符和逻辑运算符都使用了同样的字符，只是数量不同。

按位运算符可与等号（=）联合使用，以便合并运算及赋值

#### 3.1.8 移位运算符

移位运算符面向的运算对象也是二进制的“位”。可单独用它们处理整数类型（主类型的一种）。

左移位运算符（<<）能将运算符左边的运算对象向左移动运算符右侧指定的位数（在低位补0）。

“有符号”右移位运算符（>>）则将运算符左边的运算对象向右移动运算符右侧指定的位数。“有符号”右移位运算符使用了“符号扩展”：若值为正，则在高位插入0；若值为负，则在高位插入1。

“无符号”右移位运算符（>>>），它使用了“零扩展”：无论正负，都在高位插入0。


若对 char，byte 或者 short 进行移位处理，那么在移位进行之前，它们会自动转换成一个int。只有右侧的5个低位才会用到。这样可防止我们在一个int数里移动不切实际的位数。若对一个long值进行处理，最后得到的结果也是long。此时只会用到右侧的6个低位，防止移动超过long值里现成的位数。但在进行“无符号”右移位时，也可能遇到一个问题。若对byte或short值进行右移位运算，得到的可能不是正确的结果（Java 1.0和Java 1.1特别突出）。它们会自动转换成int类型，并进行右移位。但“零扩展”不会发生，所以在那些情况下会得到-1的结果。


移位可与等号（<<=或>>=或>>>=）组合使用。此时，运算符左边的值会移动由右边的值指定的位数，再将得到的结果赋回左边的值。

#### 3.1.9 三元 if-else 运算符

表达式采取下述形式：
```java
                布尔表达式 ? 值0:值1
```

若“布尔表达式”的结果为true，就计算“值0”，而且它的结果成为最终由运算符产生的值。但若“布尔表达式”的结果为false，计算的就是“值1”，而且它的结果成为最终由运算符产生的值。

可将条件运算符用于自己的“副作用”，或用于它生成的值。但通常都应将其用于值，因为那样做可将运算符与if-else明确区别开。

#### 3.1.10 逗号运算符

在Java里需要用到逗号的唯一场所就是for循环，

#### 3.1.11 字串运算符+

+ 运算符在Java里有一项特殊用途：连接不同的字串。

#### 3.1.12 运算符常规操作规则

#### 3.1.13 造型运算符

“造型”（Cast）的作用是“与一个模型匹配”。

Java允许我们将任何主类型“造型”为其他任何一种主类型，但布尔值（bollean）要除外，后者根本不允许进行任何造型处理。“类”不允许进行造型。为了将一种类转换成另一种，必须采用特殊的方法。

- 1、字面值
    - 十六进制（Base 16）——它适用于所有整数数据类型——用一个前置的0x或0X指示。并在后面跟随采用大写或小写形式的0-9以及a-f。若试图将一个变量初始化成超出自身能力的一个值（无论这个值的数值形式如何）,最大的十六进制值只会在char，byte以及short身上出现。若超出这一限制，编译器会将值自动变成一个int，并告诉我们需要对这一次赋值进行“缩小造型”。这样一来，我们就可清楚获知自己已超载了边界。
    - 八进制（Base 8）是用数字中的一个前置0以及0-7的数位指示的。在C，C++或者Java中，对二进制数字没有相应的“字面”表示方法。
    - 字面值后的尾随字符标志着它的类型。若为大写或小写的L，代表long；大写或小写的F，代表float；大写或小写的D，则代表double。
    - 指数总是采用一种我们认为很不直观的记号方法：1.39e-47f。在科学与工程学领域，“e”代表自然对数的基数，约等于2.718（Java一种更精确的double值采用Math.E的形式）。它在象“1.39×e的-47次方”这样的指数表达式中使用，意味着“1.39×2.718的-47次方”。然而，自FORTRAN语言发明后，人们自然而然地觉得e代表“10多少次幂”。这种做法显得颇为古怪，因为FORTRAN最初面向的是科学与工程设计领域。理所当然，它的设计者应对这样的混淆概念持谨慎态度（注释①）。但不管怎样，这种特别的表达方法在C，C++以及现在的Java中顽固地保留下来了。所以倘若您习惯将e作为自然对数的基数使用，那么在Java中看到象“1.39e-47f”这样的表达式时，请转换您的思维，从程序设计的角度思考它；它真正的含义是“1.39×10的-47次方”。(‘E’这个字母的含义其实很简单，就是‘Exponential’的意思，即‘指数’或‘幂数’，代表计算系统的基数——一般都是10。)

- 2、转型
    - 通常，表达式中最大的数据类型是决定了表达式最终结果大小的那个类型。若将一个float值与一个double值相乘，结果就是double；如将一个int和一个long值相加，则结果为long。
    
### 3.* Expressions, Statements, and Blocks 表达式，语句和块
运算符可用于构建表达式，这些表达式可计算值。表达式是语句的核心组成部分；语句可以分为多个块。

一个表达式是变量，运算符和方法调用，它们根据语言的语法构造由一个构建体，计算结果为单个值。

表达式返回的值的数据类型取决于表达式中使用的元素。

一条语句构成了完整的执行单元。通过使用分号（;）终止表达式，可以将以下类型的表达式制成语句。
- 赋值表达式
- 任何使用++或--
- 方法调用
- 对象创建表达式
这样的语句称为表达式语句。这是一些表达式语句的例子。
```
//赋值语句
aValue = 8933.234; 
//增量语句
aValue ++; 
//方法调用语句
System.out.println（“ H​​ello World！”）; 
//对象创建语句
Bicycle myBike = new Bicycle（）;
```
除表达式语句外，还有两种其他语句：声明语句和控制流语句。一个声明语句声明一个变量。

代码块
代码块是一组平衡括号之间的零条或多个语句，并且可以在任何地方使用单个语句是允许的。


#### 3.1.14 Java没有“sizeof”

Java不需要sizeof()运算符来满足这方面的需要，因为所有数据类型在所有机器的大小都是相同的。


### 3.2 执行控制

Java使用了C的全部控制语句，在Java里，涉及的关键字包括if-else、while、do-while、for以及一个名为switch的选择语句。

#### 3.2.1 真和假

所有条件语句都利用条件表达式的真或假来决定执行流程。
#### 3.2.2 if-else

if-else语句或许是控制程序流程最基本的形式。其中的else是可选的，可按下述两种形式来使用if：
```java
                    if(布尔表达式)
                    语句
```

- 或者：
```java
                    if(布尔表达式)
                    语句
                    else
                    语句
```

布尔表达式（条件）必须产生一个布尔结果。
- 1、return
    - return关键字有两方面的用途：指定一个方法返回什么值（假设它没有void返回值），并立即返回那个值（方法在遇到return后便不再继续）。
#### 3.2.3 反复

while，do-while和for控制着循环，有时将其划分为“反复语句”。

while循环的格式如下：
```java
                    while(布尔表达式)
                    语句
```



在循环刚开始时，会计算一次“布尔表达式”的值。而对于后来每一次额外的循环，都会在开始前重新计算一次。

do-while的格式如下：
```java
                    do
                    语句
                    while(布尔表达式)
```


while和do-while唯一的区别就是do-while肯定会至少执行一次；也就是说，至少会将其中的语句“过一遍”——即便表达式第一次便计算为false。而在while循环结构中，若条件第一次就为false，那么其中的语句根本不会执行。在实际应用中，while比do-while更常用一些。

for循环的格式如下：
```java
                    for(初始表达式; 布尔表达式; 步进)
                    语句
```


for循环在第一次反复之前要进行初始化。随后，它会进行条件测试，而且在每一次反复的时候，进行某种形式的“步进”（Stepping）。

无论初始表达式，布尔表达式，还是步进，都可以置空。每次反复前，都要测试一下布尔表达式。若获得的结果是false，就会继续执行紧跟在for语句后面的那行代码。在每次循环的末尾，会计算一次步进。
- 初始表达式：for初始化时 只执行一次
- 布尔表达式：每一次反复时 当 布尔表达式 结果为 false 时， 整个 for 循环结束。
- 语句：
- 步进：
> 注意变量c是在需要用到它的时候定义的——在for循环的控制表达式内部，而非在由起始花括号标记的代码块的最开头。c的作用域是由for控制的表达式。

以于象C这样传统的程序化语言，要求所有变量都在一个块的开头定义。所以在编译器创建一个块的时候，它可以为那些变量分配空间。而在Java和C++中，则可在整个块的范围内分散变量声明，在真正需要的地方才加以定义。这样便可形成更自然的编码风格，也更易理解。

可在for语句里定义多个变量，但它们必须具有同样的类型：
```java
                    for(int i = 0, j = 1;
                    i < 10 && j != 11;
                    i++, j++)
```

只有for循环才具备在控制表达式里定义变量的能力。对于其他任何条件或循环语句，都不可采用这种方法。

- 1、逗号运算符
    - Java里唯一用到逗号运算符的地方就是for循环的控制表达式。在控制表达式的初始化和步进控制部分，我们可使用一系列由逗号分隔的语句。而且那些语句均会独立执行。
- 例子：
```java
                        public class CommaOperator {
                            public static void main(String[] args) {
                                for(int i = 1, j = i + 10; i < 5;
                                    i++, j = i * 2) {
                                System.out.println("i= " + i + " j= " + j);
                                }
                            }
                        }
```
- 输出如下：
```java
                        i= 1 j= 11
                        i= 2 j= 4
                        i= 3 j= 6
                        i= 4 j= 8
```

无论在初始化还是在步进部分，语句都是顺序执行的。此外，尽管初始化部分可设置任意数量的定义，但都属于同一类型。

#### 3.2.6 中断和继续

在任何循环语句的主体部分，亦可用break和continue控制循环的流程。其中，break用于强行退出循环，不执行循环中剩余的语句。而continue则停止执行当前的反复，然后退回循环起始（布尔表达式）和，开始新的反复。

编译器将 while(true) 与 for(;;)看作同一回事。

1. 臭名昭著的“goto”

goto关键字很早就在程序设计语言中出现。事实上，goto是汇编语言的程序控制结构的始祖：“若条件A，则跳到这里；否则跳到那里”。事实上，goto是在源码的级别跳转的，所以招致了不好的声誉。若程序总是从一个地方跳到另一个地方，还有什么办法能识别代码的流程呢？真正的问题并不在于使用goto，而在于goto的滥用。而且在一些少见的情况下，goto是组织控制流程的最佳手段。

goto是Java的一个保留字，并未在语言中得到正式使用，在break和continue这两个关键字的身上，我们仍然能看出一些goto的影子。：标签。

“标签”是后面跟一个冒号的标识符，就象下面这样：
```java
                        label1:
```                    

对Java来说，唯一用到标签的地方是在循环语句之前。进一步说，它实际需要紧靠在循环语句的前方——在标签和循环之间置入任何语句都是不明智的。而在循环之前设置标签的唯一理由是：我们希望在其中嵌套另一个循环或者一个开关。这是由于break和continue关键字通常只中断当前循环，但若随同标签使用，它们就会中断到存在标签的地方。如下所示：
```java
                        label1:
                        外部循环{
                        内部循环{
                        //...
                        break; //1
                        //...
                        continue; //2
                        //...
                        continue label1; //3
                        //...
                        break label1; //4
                        }
                        }
```

- 在条件1中，break中断内部循环，并在外部循环结束。
- 在条件2中，continue移回内部循环的起始处。
- 在条件3中，continue label1却同时中断内部循环以及外部循环，并移至label1处。随后，它实际是继续循环，但却从外部循环开始。
- 在条件4中，break label1也会中断所有循环，并回到label1处，但并不重新进入循环。也就是说，它实际是完全中止了两个循环。
---
- (1) 简单的一个continue会退回最内层循环的开头（顶部），并继续执行。
- (2) 带有标签的continue会到达标签的位置，并重新进入紧接在那个标签后面的循环。
- (3) break会中断当前循环，并移离当前标签的末尾。
- (4) 带标签的break会中断当前循环，并移离由那个标签指示的循环的末尾


大家要记住的重点是：在Java里唯一需要用到标签的地方就是拥有嵌套循环，而且想中断或继续多个嵌套级别的时候。

标签和goto使我们难于对程序作静态分析。这是由于它们在程序的执行流程中引入了许多“怪圈”。但幸运的是，Java标签不会造成这方面的问题，因为它们的活动场所已被限死，不可通过特别的方式到处传递程序的控制权。由此也引出了一个有趣的问题：通过限制语句的能力，反而能使一项语言特性更加有用。

#### 3.2.7 开关

“开关”（Switch）有时也被划分为一种“选择语句”。根据一个整数表达式的值，switch语句可从一系列代码选出一段执行。
- 它的格式如下：
```java
                    switch(整数选择因子) {
                    case 整数值1 : 语句; break;
                    case 整数值2 : 语句; break;
                    case 整数值3 : 语句; break;
                    case 整数值4 : 语句; break;
                    case 整数值5 : 语句; break;
                    //..
                    default:语句;
                    }
```


其中，“整数选择因子”是一个特殊的表达式，能产生整数值。switch能将整数选择因子的结果与每个整数值比较。若发现相符的，就执行对应的语句（简单或复合语句）。若没有发现相符的，就执行default语句。

大家会注意到每个case均以一个break结尾。这样可使执行流程跳转至switch主体的末尾。这是构建switch语句的一种传统方式，但break是可选的。若省略break，会继续执行后面的case语句的代码，直到遇到一个break为止。注意最后的default语句没有break，因为执行流程已到了break的跳转目的地。当然，如果考虑到编程风格方面的原因，完全可以在default语句的末尾放置一个break，尽管它并没有任何实际的用处。

switch 语句是实现多路选择的一种易行方式（比如从一系列执行路径中挑选一个）。但它要求使用一个选择因子，并且必须是int或char那样的整数值。（在java中switch后的表达式的类型只能为以下几种：byte、short、char、int（在Java1.6中是这样），在java1.7后支持了对string的判断）

将一个float或double值造型成整数值后，总是将小数部分“砍掉”，不作任何进位处理。

### 3.3 总结

本章总结了大多数程序设计语言都具有的基本特性：计算、运算符优先顺序、类型转换以及选择和循环等等。现在，我们作好了相应的准备，可继续向面向对象的程序设计领域迈进。在下一章里，我们将讨论对象的初始化与清除问题，再后面则讲述隐藏的基本实现方法。

