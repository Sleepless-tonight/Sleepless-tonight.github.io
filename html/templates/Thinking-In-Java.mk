# Thinking In Java

1. 标签：Java、基础、thinking-in-java、源码解读、进阶、Java开源框架
2. 时间：2018年7月17日19:20:24
3. 连接：http://www.nostyling.cn/html/templates/Thinking-In-Java.mk

### 第 1 章：对象入门
###### 面向对象编程（OOP）
#### 1.1 抽象的进步
所有编程语言的最终目的都是提供一种“抽象”方法。面向对象的程序设计是一大进步，我们将问题空间中的元素以及它们在方案空间的表示物称作“对象”（Object）。所有东西都是对象。程序是一大堆对象的组合。每个对象都有自己的存储空间，可容纳其他对象。每个对象都有一种类型。一个类最重要的特征就是“能将什么消息发给它？”。 同一类所有对象都能接收相同的消息。

#### 1.2 对象的接口
我们向对象发出的请求是通过它的“接口”（Interface）定义的，对象的“类型”或“类”则规定了它的接口形式。“类型”与“接口”的等价或对应关系是面向对象程序设计的基础。接口定义了一类对象能接收的信息，做哪些事情。

#### 1.3 实现方案的隐藏
“接口”（Interface）规定了可对一个特定的对象发出哪些请求。在某个地方存在着一些代码，以便满足这些请求。这些代码与那些隐藏起来的数据便叫作“隐藏的实现”。“接口”（Interface）重要一点是让牵连到的所有成员都遵守相同的规则。进行访问控制，第一个原因是防止程序员接触他们不该接触的东西。第二个原因是允许库设计人员修改内部结构，不用担心它会对客户程序员造成什么影响。一个继承的类可访问受保护的成员，但不能访问私有成员。

#### 1.4 方案的重复使用
为重复使用一个类，最简单的办法是仅直接使用那个类的对象。但同时也能将那个类的一个对象置入一个新类。我们把这叫作“创建一个成员对象”。新类可由任意数量和类型的其他对象构成。这个概念叫作“组织”——在现有类的基础上组织一个新类。有时，我们也将组织称作“包含”关系，比如“一辆车包含了一个变速箱”。
 
新类的“成员对象”通常设为“私有”（Private），使用这个类的客户程序员不能访问它们。这样一来，我们可在不干扰客户代码的前提下，从容地修改那些成员。也可以在“运行期”更改成员，这进一步增大了灵活性。后面要讲到的“继承”并不具备这种灵活性，因为编译器必须对通过继承创建的类加以限制。
 
轻易的运用继承是非常笨拙的，会大大增加程序的复杂程度。首先应考虑“组织”（类包含）对象；这样做得更加简单和灵活。利用对象的组织，我们的设计可保持清爽。

#### 1.5 继承：重新使用接口
 在Java语言中，继承是通过extends关键字实现的 使用继承时，相当于创建了一个新类。这个新类不仅包含了现有类型的所有成员（尽管private成员被隐藏起来，且不能访问），但更重要的是，它复制了基础类的接口。也就是说，可向基础类的对象发送的所有消息亦可原样发给衍生类的对象。若只是简单地继承一个类，并不做其他任何事情，来自基础类接口的方法就会直接照搬到衍生类。这意味着衍生类的对象不仅有相同的类型，也有同样的行为，这一后果通常是我们不愿见到的。
 
##### 1.5.1 改善基础类
改变基础类一个现有函数的行为。我们将其称作“改善”那个函数。

继承只改善原基础类的函数，衍生类型就是与基础类完全相同的类型，都拥有完全相同的接口，此时，我们通常认为基础类和衍生类之间存在一种“等价”关系；但在许多时候，我们必须为衍生类型加入新的接口元素，所以不仅扩展了接口，也创建了一种新类型。我们将其称作“类似”关系；

#### 1.6 多形对象的互换使用
通常，继承最终会以创建一系列类收场，所有类都建立在统一的基础接口上。

对这样的一系列类，我们可以将衍生类的对象当作基础类（完全相同）的一个对象对待。

把衍生类型（子类）当作它的基本类型（父类）处理的过程叫作“Upcasting”（上溯造型）。在面向对象的程序里，通常都要用到上溯造型技术。这是避免去调查准确类型的一个好办法。
##### 1.6.1 动态绑定
将一条消息发给对象时，如果并不知道对方的具体类型是什么，但采取的行动同样是正确的，这种情况就叫作“多形性”（Polymorphism）（多态性）。对面向对象的程序设计语言来说，它们用以实现多形性的方法叫作“动态绑定”。编译器和运行期系统会负责对所有细节的控制；我们只需知道会发生什么事情，而且更重要的是，如何利用它帮助自己设计程序。

##### 1.6.2 抽象的基础类和接口

设计程序时，我们经常都希望基础类只为自己的衍生类提供一个接口，而不是实际创建基础类的一个对象，为达到这个目的，需要把那个类变成“抽象”的——使用abstract关键字。

亦可用abstract关键字描述一个尚未实现的方法，指出：“这是适用于从这个类继承的所有类型的一个接口函数，但目前尚没有对它进行任何形式的实现。抽象方法也许只能在一个抽象类里创建。继承了一个类后，那个方法就必须实现，否则继承的类也会变成“抽象”类。

interface（接口）关键字将抽象类的概念更延伸了一步，它完全禁止了所有的函数定义。“接口”是一种相当有效和常用的工具。另外如果自己愿意，亦可将多个接口都合并到一起（不能从多个普通class或abstract class中继承）。

```
                备注：这是一段个人的总结：
                    interface（接口）更倾向于表明这个类是能干什么事，也就是说这类的类实现了哪些方法及继承与此接口的类必需要实现哪些方法；接口更像一个规范文件。
                    abstract（抽象）更倾向于表明一类类的共有特性，由基础类或一个接口衍生的一系列类的共有特性，所以不仅仅表明这个类能干哪些事。
                    也就是说 interface（接口）的方法都可以在接口中无实现，只规定了子类必须需要实现哪些方法，而 abstract（抽象）可以把子类相同实现的方法在抽象类里实现，子类各自特别且必须的方法用抽象方法规定然后在子类里各自实现。
                    abstract（抽象）可以看为一种跟 public、static 同级别的修饰符（修饰了类（class）和方法），而 interface（接口）可以看为一种跟 class 同级别的修饰符，标志着质的改变。
                    interface（接口）可以说是对 abstract（抽象）的抽象。
                    interface（接口）帮助了对象的分层，各组件之间的松耦合。

                    abstract 语法要求：
                        1、有抽象方法的类只能是抽象类
                        2、抽象类里可没有抽象方法有普通方法
                        3、抽象类不能被实例化
                        4、抽象类可以包含：成员变量、方法（普通、抽象）、构造器、初始化快、内部类（接口、枚举）、抽象类的构造器不能用于创造实列，主要用于被其子类调用
                        5、抽象不能修饰变量（成员、局部），不能修饰构造器，抽象类里的构造器只能是普通的构造器。
                        总结如下：
                            1、抽象类与普通类相比“一得一失”：1、“得”可包含抽象方法。2、“失”无法被实列化。
                            2、抽象类是用来被它的子类继承的，方法由子类实现。而 final 修饰的类不能被继承， final 修饰的方法不能被重写，所以 final 和 abstract 是互斥的。
                            3、static 修饰方法是属于这个类本身的（类Class和实列Object的区别），如果该方法被定义成抽象方法，通过类调用的时候也会出错，因为调用了一个没有方法实体的方法，所以 static 和 abstract 是互斥的（非绝对，可以同时修饰内部类）。
                            4、abstract 修饰的方法必须被之类重写才有意义，因此 abstract 方法不能是私有的，所以 private 和 abstract 是互斥的。

                    interface 语法要求：
                        1、接口可以包含：静态常量、方法（抽象）、内部类（接口、枚举）、默认方法（类方法）
                        2、接口只可以继承多个父接口（之间用英文逗号“,”隔开），不能继承类。
                        3、接口修饰符可以是 public 或者省略，如果省略了 public 访问控制符，则默认采用包权限访问控制符，即只有相同包结构下才可以访问该接口。
                        4、接口内的所有成员都是 public 访问权限，可省略，如果指定则只可使用 public 访问修饰符。
                        5、接口的成员变量均为静态常量，不管是否使用 public static final 修饰符都认为只可做如此修饰。
                        6、接口的方法只能是抽象、类方法、默认方法，如果不是默认方法，系统将自动为普通方法增加 public abstract 修饰符，且不能有方法实现（方法体），类方法、默认方法必须有方法实现（方法体）。
                        7、定义默认方法，需要用 default 修饰且默认添加 public 修饰 ，默认方法不能用 static 修饰，所以不能直接用接口来调用默认方法，由接口的实现类的实例来调用这些默认方法。
                        8、类方法需用 static 修饰 ，可用接口直接调用。
                        9、接口的内部类（接口、枚举）默认采用 public static 修饰符。
                        10、接口可看做为特殊的类，受限于一个源文件只能有一个 public 修饰。
                        11、接口不能创建实例，作为声明引用类型变量时此接口必须有其实现类。
```

#### 1.7 对象的创建和存在时间

从技术角度说，OOP（面向对象程序设计）只是涉及抽象的数据类型、继承以及多形性，但另一些问题也可能显得非常重要。

最重要的问题之一是对象的创建及破坏方式。对象需要的数据位于哪儿，及对象的“存在时间”。

##### 1.7.1 集合与继承器

“继续器”（Iterator），它属于一种对象，负责选择集合内的元素，并把它们提供给继承器的用户。它存在于所有集合中

不同的集合在进行特定操作时往往有不同的效率。
##### 1.7.2 单根结构

所有类最终是从单独一个基础类继承（Object）。他们最终都属于相同的类型。

所有对象都在内存堆中创建，可以极大简化参数的传递。

可以更方便地实现一个垃圾收集器。

由于运行期的类型信息肯定存在于所有对象中，所以永远不会遇到判断不出一个对象的类型的情况。这对系统级的操作来说显得特别重要，比如违例控制；

##### 1.7.3 集合库与方便使用集合

为了使这些集合能够重复使用，或者“再生”，Java提供了一种通用类型，以前曾把它叫作“Object”。所以容纳了Object的一个集合实际可以容纳任何东西。这使我们对它的重复使用变得非常简便。

但由于集合只能容纳Object，所以在我们向集合里添加对象句柄时，它会上溯造型成Object，这样便丢失了它的身份或者标识信息。再次使用它的时候，会得到一个Object句柄，而非指向我们早先置入的那个类型的句柄。

（↑↑↑↑↑解释上面两个段落：为了复用将集合元素的类型设置为Object，当向集合中添加元素的时候会因为 Upcasting 而丢失 元素的实际类型，以至于无法调用元素的实际有用接口）

我们再次用到了造型（Cast）。下溯造型成一种更“特殊”的类型。这种造型方法叫作“下溯造型”（Downcasting）。

在从一个集合提取对象句柄时，必须用某种方式准确地记住它们是什么，以保证下溯造型的正确进行。

我们可以采用“参数化类型”。

（↑↑↑↑↑解释上面段落：集合泛型的原因）

##### 1.7.4 清除时的困境：由谁负责清除？

每个对象都要求资源才能“生存”，其中最令人注目的资源是内存。如果不再需要使用一个对象，就必须将其清除，以便释放这些资源，以便其他对象使用。

问题1：如何才能知道什么时间删除对象呢？

垃圾收集器“知道”一个对象在什么时候不再使用，然后会自动释放那个对象占据的内存空间。


2.垃圾收集器对效率及灵活性的影响

代价就是运行期的开销。

我们不能确定它什么时候启动或者要花多长的时间。这意味着在Java程序执行期间，存在着一种不连贯的因素。所以在某些特殊的场合，我们必须避免用它——比如在一个程序的执行必须保持稳定、连贯的时候。

#### 1.8 违例控制：解决错误

错误必然发生

它们严重依赖程序员的警觉性

“违例控制”将错误控制方案内置到程序设计语言中，有时甚至内建到操作系统内。这“违例控制”将错误控制方案内置到程序设计语言中，有时甚至内建到操作系统内。

违例不能被忽略，“掷”出的一个违例不同于从函数返回的错误值，那些错误值或标志的作用是指示一个错误状态，是可以忽略的。

注意违例控制并不属于一种面向对象的特性

#### 1.9 多线程

在计算机编程中，一个基本的概念就是同时对多个任务加以控制。许多程序设计问题都要求程序能够停下手头的工作，改为处理其他一些问题，再返回主进程。

要求将问题划分进入独立运行的程序片断中，使整个程序能更迅速地响应用户的请求。在一个程序中，这些独立运行的片断叫作“线程”（Thread），利用它编程的概念就叫作“多线程处理”。

最开始，线程只是用于分配单个处理器的处理时间的一种工具。但假如操作系统本身支持多个处理器，那么每个线程都可分配给一个不同的处理器，真正进入“并行运算”状态。

从程序设计语言的角度看，多线程操作最有价值的特性之一就是程序员不必关心到底使用了多少个处理器。程序在逻辑意义上被分割为数个线程；假如机器本身安装了多个处理器，那么程序会运行得更快，毋需作出任何特殊的调校。

一个问题：临界资源！一些支持共享，不支持并行的资源，需要在线程使用期间必须进入锁定状态。（比如“屏幕”是个共享资源，但是不能同时播放两个画面。）

Java中对多线程处理的支持是在对象这一级支持的，所以一个执行线程可表达为一个对象。Java也提供了有限的资源锁定方案。它能锁定任何对象占用的内存（内存实际是多种共享资源的一种），所以同一时间只能有一个线程使用特定的内存空间。为达到这个目的，需要使用 synchronized 关键字。

#### 1.10 永久性

Java8移除永久代


#### 1.11 Java和因特网

#### 1.12 分析和设计
- (1) 对象是什么？（怎样将自己的项目分割成一系列单独的组件？）
- (2) 它们的接口是什么？（需要将什么消息发给每一个对象？）


整个过程可划分为四个阶段：
- 阶段0：拟出一个计划、
- 阶段1：要制作什么？
    - 在上一代程序设计中（即“过程化或程序化设计”），这个阶段称为“建立需求分析和系统规格”。
    - 最有价值的工具就是一个名为“使用条件”的集合。
- 阶段2：如何构建？
    - 此时可考虑采用一种特殊的图表工具：“统一建模语言”（UML）。
    - 包含的各类对象在外观上是什么样子，以及相互间是如何沟通的。
- 阶段3：开始创建

- 阶段4：校订

#### 1.13 Java还是 C++


### 第 2 章：一切都是对象
###### Java语言首先便假定了我们只希望进行面向对象的程序设计。

#### 2.1 用句柄操纵对象
###### 将一切都“看作”对象，操纵的 标识符 实际是指向一个对象的“句柄”（Handle）。
```
            创建一个String句柄：
                String s;
                这里创建的只是句柄，并不是对象。s实际并未与任何东西连接（即“没有实体”）。
                一种更安全的做法是：创建一个句柄时，记住无论如何都进行初始化：
                String s = "asdf";
            总结：
                句柄指向对象，通过句柄操作对象，句柄是句柄，对象是对象。
```

#### 2.2 所有对象都必须创建
###### 创建句柄时，我们希望它同一个新对象连接。通常用 new 关键字达到这一目的。。new的意思是：“把我变成这些对象的一种新实体”。

##### 2.2.1 保存到什么地方
###### 程序运行时，我们最好对数据保存到什么地方做到心中有数。特别要注意的是内存的分配。有六个地方都可以保存数据：

-  (1) 寄存器：
    - 位于处理器内部。这是最快的保存区域。
    - 以寄存器是根据需要由编译器分配。
    - 我们对此没有直接的控制权。
- (2) 堆栈（stack）：
    - 驻留于常规RAM（随机访问存储器）区域，这是一种特别快、特别有效的数据保存方式，仅次于寄存器。
    - 创建程序时，Java编译器必须准确地知道堆栈内保存的所有数据的“长度”以及“存在时间”。这是由于它必须生成相应的代码，以便向上和向下移动指针。这一限制无疑影响了程序的灵活性。
    - 有些Java数据要保存在堆栈里——基本类型数据、对象句柄，但Java对象并不放到其中。
    - 每个线程都有自己独立的栈。
- (3) 堆（Heap）：
    - 一种常规用途的内存池（也在RAM区域），在堆里分配存储空间时会花掉更长的时间！
    - 编译器不必知道要从堆里分配多少存储空间，也不必知道存储的数据要在堆里停留多长的时间。因此，用堆保存数据时会得到更大的灵活性。要求创建一个对象时，只需用new命令编制相关的代码即可。执行这些代码时，会在堆里自动进行数据的保存。
    - 保存了Java对象。
    - 堆在整个JVM中只有一个（所以堆中的数据可被多个线程共享），堆里面的内存空间由GC来负责回收。
- (4) 静态存储 ：
    - 这儿的“静态”（Static）是指“位于固定位置”（尽管也在RAM里）。
    - 程序运行期间，静态存储的数据将随时等候调用。可用static关键字指出一个对象的特定元素是静态的。
    - Java对象本身永远都不会置入静态存储空间。
- (5) 常数存储 ：
    - 常数值通常直接置于程序代码内部。这样做是安全的，因为它们永远都不会改变。有的常数需要严格地保护，所以可考虑将它们置入只读存储器（ROM）。
- (6) 非RAM存储 ：
    - 若数据完全独立于一个程序之外。其中两个最主要的例子便是“流式对象”和“固定对象”。对于流式对象，对象会变成字节流，通常会发给另一台机器。而对于固定对象，对象保存在磁盘中。

##### 2.2.2 特殊情况：主要类型
###### 有一系列类需特别对待；可将它们想象成“基本”、“主要”或者“主”（Primitive）类型，进行程序设计时要频繁用到它们。之所以要特别对待，是由于用new创建对象（特别是小的、简单的变量）并不是非常有效，因为new将对象置于“堆”里。对于这些类型，Java采纳了与C和C++相同的方法。也就是说，不是用new创建变量，而是创建一个并非句柄的“自动”变量。这个变量容纳了具体的值，并置于堆栈中，能够更高效地存取。

###### Java决定了每种主要类型的大小。(8bit=1byte)

主类型 | 大小 | 封装器类型
---|---|---
boolean | 1-bit | Boolean
byte | 8-bit | Byte[11]
char | 16-bit | Character
short | 16-bit | Short
int | 32-bit | Integer
long | 64-bit | Long
float | 32-bit | Float
double | 64-bit | Double

> （注意：若变量是主数据类型作为类成员使用，Java可自动分配默认值，可保证主类型的成员变量肯定得到了初始化（自动初始化）（C++不具备这一功能），却并不适用于“局部”变量——那些变量并非一个类的字段，不会自动初始化，会得到一条编译期错误。）

- 高精度数字
    - 用于进行高精度的计算：BigInteger和BigDecimal。尽管它们大致可以划分为“封装器”类型，但两者都没有对应的“主类型”。这两个类都有自己特殊的“方法”，对应于我们针对主类型执行的操作。

##### 2.2.3 Java的数组
###### Java的一项主要设计目标就是安全性。一个Java可以保证被初始化，而且不可在它的范围之外访问。由于系统自动进行范围检查，所以必然要付出一些代价：针对每个数组，以及在运行期间对索引的校验，都会造成少量的内存开销。
###### 创建对象数组时，实际创建的是一个句柄数组。而且每个句柄都会自动初始化成一个特殊值，并带有自己的关键字：null（空）。一旦Java看到null，就知道该句柄并未指向一个对象。正式使用前，必须为每个句柄都分配一个对象。

#### 2.3 所有对象都必须创建
###### 在大多数程序设计语言中，变量的“存在时间”（Lifetime）一直是程序员需要着重考虑的问题。变量应持续多长的时间？如果想清除它，那么何时进行？在变量存在时间上纠缠不清会造成大量的程序错误。

##### 2.3.1 作用域（Scope）
###### 作用域同时决定了它的“可见性”以及“存在时间”。在C，C++和Java里，作用域是由花括号的位置决定的。
- 例子：
```java
                    {
                    int x = 12;
                    /* only x available */
                    {
                    int q = 96;
                    /* both x & q available */
                    }
                    /* only x available */
                    /* q “out of scope” */
                    }
```
                    
###### 作为在作用域里定义的一个变量，它只有在那个作用域结束之前才可使用。

##### 2.3.2 对象的作用域
###### Java对象不具备与主类型一样的存在时间。用 new 关键字创建一个Java对象的时候，它会超出作用域的范围之外。
- 例子：
```java
                    {
                    String s = new String("a string");
                    } /* 作用域的终点 */
```                   
###### 那么句柄 s会在作用域的终点处消失。然而，s 指向的 String 对象依然占据着内存空间。在上面这段代码里，我们没有办法访问对象，因为指向它的唯一一个句柄已超出了作用域的边界。
###### 这样造成的结果便是：对于用 new 创建的对象，只要我们愿意，它们就会一直保留下去。这个编程问题在 C 和 C++ 里特别突出。看来在 C++ 里遇到的麻烦最大：由于不能从语言获得任何帮助，所以在需要对象的时候，根本无法确定它们是否可用。而且更麻烦的是，在 C++ 里，一旦工作完成，必须保证将对象清除。
###### 假如 Java 让对象依然故我，怎样才能防止它们大量充斥内存，并最终造成程序的“凝固”呢。在 C++ 里，这个问题最令程序员头痛。但 Java 以后，情况却发生了改观。Java 有一个特别的“垃圾收集器”，它会查找用new创建的所有对象，并辨别其中哪些不再被引用。随后，它会自动释放由那些闲置对象占据的内存，以便能由新对象使用。这意味着我们根本不必操心内存的回收问题。只需简单地创建对象，一旦不再需要它们，它们就会自动离去。这样做可防止在 C++里很常见的一个编程问题：由于程序员忘记释放内存造成的“内存溢出”。

#### 2.4 新建数据类型：类
###### 一切东西都是对象，那么用什么决定一个“类”（Class）的外观与行为呢？换句话说，是什么建立起了一个对象的“类型”（class）呢？通过 class 关键字。
- 例如：
```java
                //这样就引入了一种新类型。
                    class ATypeName {/*类主体置于这里}

                //这样就用new创建这种类型的一个新对象：
                    ATypeName a = new ATypeName();
```


##### 2.4.1 字段和方法
###### 定义一个类时（我们在Java里的全部工作就是定义类、制作那些类的对象以及将消息发给那些对象），可在自己的类里设置两种类型的元素：数据成员（有时也叫“字段”）、成员函数（通常叫“方法”）。其中，数据成员是一种对象（通过它的句柄与其通信），可以为任何类型。它也可以是主类型（并不是句柄）之一。如果是指向对象的一个句柄，则必须初始化那个句柄，用一种名为“构建器”的特殊函数将其与一个实际对象连接起来（就象早先看到的那样，使用new关键字）。但若是一种主类型，则可在类定义位置直接初始化（正如后面会看到的那样，句柄亦可在定义位置初始化）。
###### 每个对象都为自己的数据成员保有存储空间；数据成员不会在对象之间共享。（这个共享是指指向一块内存位置的意思么？）
- 示例：
```java
                    class DataOnly {
                    int i;
                    float f;
                    boolean b;
                    }
```

###### 对象实例化后可值赋给数据成员，但首先必须知道如何引用一个对象的成员。首先要写上对象句柄的名字，再跟随一个点号，再跟随对象内部成员的名字。即“对象句柄.成员”。(引用 或者 说 访问权限 会受 修饰符（public、protected、default、private）影响。)
- 例如：
```java
                    d.i = 47;
                    d.f = 1.1f;
                    d.b = false;
```

###### 一个对象也可能包含了另一个对象，只需保持“连接句点”即可。
- 例如：
```java
                    myPlane.leftTank.capacity = 100;
```

- 1、主成员的默认值：
    - 若某个主数据类型属于一个类成员，那么即使不明确（显式）进行初始化，也可以保证它们获得一个默认值（自动初始化）。
        - 主类型 默认值：
```java
                        Boolean false
                        Char '\u0000'(null)
                        byte (byte)0
                        short (short)0
                        int 0
                        long 0L
                        float 0.0f
                        double 0.0d
```


- 注意：
    - 若变量是主数据类型作为类成员使用，Java可自动分配默认值，可保证主类型的成员变量肯定得到了初始化（自动初始化）（C++不具备这一功能），却并不适用于“局部”变量——那些变量并非一个类的字段，不会自动初始化，会得到一条编译期错误。

#### 2.5 方法、自变量和返回值
###### 我们一直用“函数”（Function）这个词指代一个已命名的子例程。但在 Java 里，更常用的一个词却是“方法”（Method），代表“完成某事的途径”。尽管它们表达的实际是同一个意思。
###### Java的“方法”决定了一个对象能够接收的消息。
###### 方法的基本组成部分包括名字、自变量、返回类型以及主体。下面便是它最基本的形式：
```java
                返回类型 方法名( /* 自变量列表*/ ) {/* 方法主体 */}
```

###### 返回类型是指调用方法之后返回的数值类型。显然，方法名的作用是对具体的方法进行标识和引用。自变量列表列出了想传递给方法的信息类型和名称。
###### Java的方法只能作为类的一部分创建。只能针对某个对象调用一个方法（注释③），而且那个对象必须能够执行那个方法调用。

###### 为一个对象调用方法时，需要先列出对象的名字，在后面跟上一个句点，再跟上方法名以及它的参数列表。亦即“对象名.方法名(自变量1，自变量2，自变量3...)。例如：我们有一个方法名叫f()，它没有自变量，返回的是类型为int的一个值。假设有一个名为a的对象，可为其调用方法f()，则代码如下：
```java
                int x = a.f();
```

###### 象这样调用一个方法的行动通常叫作“向对象发送一条消息”。在上面的例子中，消息是f()，而对象是 a。面向对象的程序设计通常简单地归纳为“向对象发送消息”。

> ③：正如马上就要学到的那样，“静态”方法可针对类调用，毋需一个对象。

##### 2.5.1 自变量列表
###### 自变量列表规定了我们传送给方法的是什么信息。这些信息——如同Java内其他任何东西——采用的都是对象的形式。因此，我们必须在自变量列表里指定要传递的对象类型，以及每个对象的名字。正如在Java其他地方处理对象时一样，我们实际传递的是“句柄”（注释④）。然而，句柄的类型必须正确。倘若希望自变量是一个“字串”，那么传递的必须是一个字串。
> ④：对于前面提及的“特殊”数据类型 boolean，char，byte，short，int，long，，float以及double来说是一个例外。但在传递对象时，通常都是指传递指向对象的句柄。（也就是说 基本类型 传递的是值本身）
###### return 关键字的运用。它主要做两件事情。首先，它意味着“离开方法，我已完工了”。其次，假设方法生成了一个值，则那个值紧接在 return 语句的后面。可按返回 那个值，但倘若不想返回任何东西，就可指示方法返回 void（空）。
###### 若返回类型为 void，则 return 关键字唯一的作用就是退出方法。
###### 但假设已指定了一种非 void 的返回类型，那么无论从何地返回，编译器都会确保我们返回的是正确的类型。

#### 2.6 构建 Java 程序
##### 2.6.1 名字的可见性
###### Java 的设计者鼓励程序员反转使用自己的 Internet 域名，给一个库生成明确的名字。

##### 2.6.2 使用其他组件
###### 用 import 关键字准确告诉 Java 编译器我们希望的类是什么。import 的作用是指示编译器导入一个“包”——或者说一个“类库”（在其他语言里，可将“库”想象成一系列函数、数据以及类的集合。但请记住，Java的所有代码都必须写入一个类中）。
- 例如：
```java
                    import java.util.Vector;
```


##### 2.6.3 static关键字
###### static 修饰的成员表明它是属于这个类本(Class)身，而不是属于该类的单个实列(Object)，没有使用 static 修饰的成员只可通过实例调动，static 修饰的成员不能直接访问非静态成员（因为非静态成员没有初始化）。
###### 通常，用 new 创建那个类的一个对象，才会正式生成数据存储空间，并可使用相应的方法。
###### 但在两种特殊的情形下，上述方法并不堪用。一种情形是只想用一个存储区域来保存一个特定的数据——无论要创建多少个对象，甚至根本不创建对象。另一种情形是我们需要一个特殊的方法，它没有与这个类的任何对象关联。也就是说，即使没有创建对象，也需要一个能调用的方法。为满足这两方面的要求，可使用 static（静态）关键字。一旦将什么东西设为 static，数据或方法就不会同那个类的任何对象实例联系到一起。所以尽管从未创建那个类的一个对象，仍能调用一个 static方法，或访问一些 static数据。
- 例如：
```java
                    class StaticTest {
                        static int i = 47;
                    }

```

###### 我们制作了两个 StaticTest对象：
```java
                    StaticTest st1 = new StaticTest();
                    StaticTest st2 = new StaticTest();
```


###### 但它们仍然只占据 StaticTest.i的一个存储空间。这两个对象都共享同样的i。无论st1.i还是st2.i都有同样的值47，因为它们引用的是同样的内存区域。
###### 所以有两个办法可引用一个 static 变量。可通过一个对象命名它，如 st2.i，亦可直接用它的类名引用，如 StaticTest.i（最好用这个办法引用 static 变量，因为它强调了那个变量的“静态”本质）。

###### static一项重要的用途就是帮助我们在不必创建对象的前提下调用那个方法。和其他任何方法一样，static方法也能创建自己类型的命名对象。所以经常把 static方法作为一个“领头羊”使用，用它生成一系列自己类型的“实例”。


#### 2.7 我们的第一个Java程序
###### 由于java.lang默认进入每个Java代码文件，所以这些类在任何时候都可直接使用。
###### 通过为 Runtime类调用getRuntime()方法，main()的第五行创建了一个Runtime对象，Runtime可告诉我们与内存使用有关的信息。

#### 2.8 注释和嵌入文档
##### 2.8.1 注释文档
###### 人们需要考虑程序的文档化问题。用于提取注释的工具叫作javadoc。它不仅提取由这些注释标记指示的信息，也将毗邻注释的类名或方法名提取出来。
###### javadoc输出的是一个HTML文件，可用自己的Web浏览器查看。
##### 2.8.2 具体语法
###### 所有javadoc命令都只能出现于 “/**” 注释中。有三种类型的注释文档，它们对应于位于注释后面的元素：类、变量或者方法。
```java
                    /** 一个类注释 */
                    public class docTest {
                    /** 一个变量注释 */
                    public int i;
                    /** 一个方法注释 */
                    public void f() {}
                    }
```

> 注意javadoc只能为public（公共）和protected（受保护）成员处理注释文档。“private”（私有）和“友好”（详见5章）成员的注释会被忽略，我们看不到任何输出（也可以用-private标记包括private成员）。

##### 2.8.3 嵌入HTML
###### javadoc 将HTML命令传递给最终生成的HTML文档。

###### 亦可象在其他 Web文档里那样运用HTML，对普通文本进行格式化，使其更具条理、更加美观：
```java
                    /**
                    * 您<em>甚至</em>可以插入一个列表：
                    * <ol>
                    * <li> 项目一
                    * <li> 项目二
                    * <li> 项目三
                    * </ol>
                    */
```
###### 注意在文档注释中，位于一行最开头的星号会被javadoc丢弃。同时丢弃的还有前导空格。javadoc 会对所有内容进行格式化，使其与标准的文档外观相符。不要将 &lt;h1> 或 &lt;hr> 这样的标题当作嵌入HTML使用，因为javadoc会插入自己的标题，我们给出的标题会与之冲撞。

##### 2.8.4 @see：引用其他类
###### 所有三种类型的注释文档都可包含@see标记，它允许我们引用其他类里的文档。对于这个标记，javadoc会生成相应的HTML，将其直接链接到其他文档。格式如下：
```java
                    @see 类名
                    @see 完整类名
                    @see 完整类名#方法名
```

###### 每一格式都会在生成的文档里自动加入一个超链接的“See Also”（参见）条目。注意javadoc不会检查我们指定的超链接，不会验证它们是否有效。

##### 2.8.5 类文档标记
```java
                1. @version
                    格式如下：
                        @version 版本信息
                    其中，“版本信息”代表任何适合作为版本说明的资料。
                2. @author
                    格式如下：
                        @author 作者信息
                    其中，“作者信息”包括您的姓名、电子函件地址或者其他任何适宜的资料。
```


##### 2.8.6 变量文档标记
###### 变量文档只能包括嵌入的HTML以及@see引用。

##### 2.8.7 方法文档标记
###### 除嵌入HTML和@see引用之外，方法还允许使用针对参数、返回值以及违例的文档标记。
```java
                1. @param
                    格式如下：
                        @param 参数名 说明
                    其中，“参数名”是指参数列表内的标识符，而“说明”代表一些可延续到后续行内的说明文字。

                2. @return
                    格式如下：
                        @return 说明
                    其中，“说明”是指返回值的含义。它可延续到后面的行内。

                3. @exception
                    格式如下：
                        @exception 完整类名 说明
                    其中，“完整类名”明确指定了一个违例类的名字，它是在其他某个地方定义好的。而“说明”（同样可以延续到下面的行）告诉我们为什么这种特殊类型的违例会在方法调用中出现。

                4. @deprecated
                    格式如下：
                        @deprecated
                    标记用于指出一些旧功能已由改进过的新功能取代。该标记的作用是建议用户不必再使用一种特定的功能，因为未来改版时可能摒弃这一功能。
```

##### 2.8.8 文档示例

#### 2.9 编码样式
###### 一个非正式的Java编程标准是大写一个类名的首字母。若类名由几个单词构成，那么把它们紧靠到一起（也就是说，不要用下划线来分隔名字）。此外，每个嵌入单词的首字母都采用大写形式。
- 例如：
```java
                class AllTheColorsOfTheRainbow { // ...}
```

###### 其他几乎所有内容：方法、字段（成员变量）以及对象句柄名称，可接受的样式与类样式差不多，只是标识符的第一个字母采用小写。
- 例如：
```java
                int anIntegerRepresentingColors;
                void changeTheHueOfTheColor(int newHue) {
                // ...
                }
```
#### 2.10 总结
###### 本章是基础知识。


### 第3章 控制程序流程
###### 程序必须能操纵自己的世界，在执行过程中作出判断与选择。

#### 3.1 使用Java运算符
###### 几乎所有运算符都只能操作“主类型”（Primitives）（基本类型）。唯一的例外是“=”、“==”和“!=”，它们能操作所有对象（也是对象易令人混淆的一个地方）。除此以外，String类支持“+”和“+=”。

##### 3.1.1 优先级
###### 运算符的优先级决定了存在多个运算符时一个表达式各部分的计算顺序。

##### 3.1.2 赋值
###### 赋值是用等号运算符（=）进行的。它的意思是“取得右边的值，把它复制到左边”。
###### 右边的值可以是任何常数、变量或者表达式，只要能产生一个值就行。但左边的值必须是一个明确的、已命名的变量。
###### 对主数据类型的赋值是非常直接的。由于主类型容纳了实际的值，而且并非指向一个对象的句柄，所以在为其赋值的时候，可将来自一个地方的内容复制到另一个地方。
###### 但在为对象“赋值”的时候，情况却发生了变化。对一个对象进行操作时，我们真正操作的是它的句柄。所以倘若“从一个对象到另一个对象”赋值，实际就是将句柄从一个地方复制到另一个地方。这意味着假若为对象使用“C=D”，那么C和D最终都会指向最初只有D才指向的那个对象。

##### 3.1.3 算术运算符
###### Java的基本算术运算符与其他大多数程序设计语言是相同的。其中包括加号（+）、减号（-）、除号（/）、乘号（*）以及模数（%，从整数除法中获得余数）。整数除法会直接砍掉小数，而不是进位。

###### 1. 一元加、减运算符
###### 一元减号（-）和一元加号（+）与二元加号和减号都是相同的运算符。
- 例如：
```java
                    x = -a;
```
###### 一元减号得到的运算对象的负值。一元加号的含义与一元减号相反，虽然它实际并不做任何事情。

##### 3.1.4 自动递增和递减
###### 两种很不错的快捷运算方式是递增和递减运算符（常称作“自动递增”和“自动递减”运算符）。其中，递减运算符是“--”，意为“减少一个单位”；递增运算符是“++”，意为“增加一个单位”。举个例子来说，假设A是一个int（整数）值，则表达式++A就等价于（A = A + 1）。
###### 对每种类型的运算符，都有两个版本可供选用；通常将其称为“前缀版”和“后缀版”。。对于前递增和前递减（如++A或--A），会先执行运算，再生成值。而对于后递增和后递减（如A++或A--），会先生成值，再执行运算。

##### 3.1.5 关系运算符
###### 关系运算符生成的是一个“布尔”（Boolean）结果。它们评价的是运算对象值之间的关系。若关系是真实的，关系表达式会生成 true（真）；若关系不真实，则生成 false（假）。关系运算符包括小于（<）、大于（>）、小于或等于（<=）、大于或等于（>=）、等于（==）以及不等于（!=）。等于和不等于适用于所有内建的数据类型，但其他比较不适用于 boolean 类型。

- 1、检查对象是否相等
    - 关系运算符==和!=也适用于所有对象。
    - ==和!=比较的就是对象句柄。
    - 若想对比两个对象的实际内容是否相同？此时，必须使用所有对象都适用的特殊方法equals()。
    - 于 equals()的默认行为是比较句柄。
    - 多数Java类库都实现了equals()，所以它实际比较的是对象的内容，而非它们的句柄。

##### 3.1.6 逻辑运算符
###### 逻辑运算符AND（&&）、OR（||）以及NOT（!）能生成一个布尔值（true或false）。

###### 1. 短路
###### 操作逻辑运算符时，我们会遇到一种名为“短路”的情况。这意味着只有明确得出整个表达式真或假的结论，才会对表达式进行逻辑求值。因此，一个逻辑表达式的所有部分都有可能不进行求值。
###### 短路就是说，当逻辑运算表达式的结果已经得出，剩余的逻辑表达式将不会得到执行。）

##### 3.1.7 按位运算符
###### 二进制下用 1 表示真，0 表示假
###### 按位运算符允许我们操作一个整数主数据类型中的单个“比特”，即二进制位。按位运算符会对两个自变量中对应的位执行布尔代数，并最终生成一个结果。
###### 若两个输入位都是1，则按位AND运算符（&）在输出位里生成一个1；否则生成0。
```java
                1 & 1 = 1
                0 & 1 = 0
                1 & 0 = 0
                0 & 0 = 0
```

###### 若两个输入位里至少有一个是1，则按位OR运算符（|）在输出位里生成一个1；只有在两个输入位都是0的情况下，它才会生成一个0。
```java
                1 | 1 = 1
                0 | 1 = 1
                1 | 0 = 1
                0 | 0 = 0
```
###### XOR（^，异或）:如果a、b两个值不相同，则异或结果为1。如果a、b两个值相同，异或结果为0。
```java
                1 ^ 1 = 0
                0 ^ 1 = 1
                1 ^ 0 = 1
                0 ^ 0 = 0
```
###### 异或的一个用法，交换两个变量的值。
```java
                int a = 1;//01
                int b = 2;//10
                a=a^b;//a=11
                b=b^a;//b=01
                a=a^b;//a=10
```
###### NOT（~，也叫作“非”运算符）属于一元运算符；它只对一个自变量进行操作（其他所有运算符都是二元运算符）。按位NOT生成与输入位的相反的值——若输入0，则输出1；输入1，则输出0。
```java
                ~ 1 = 0
                ~ 0 = 1
```
###### 按位运算符和逻辑运算符都使用了同样的字符，只是数量不同。
###### 按位运算符可与等号（=）联合使用，以便合并运算及赋值

##### 3.1.8 移位运算符
###### 移位运算符面向的运算对象也是二进制的“位”。可单独用它们处理整数类型（主类型的一种）。
###### 左移位运算符（<<）能将运算符左边的运算对象向左移动运算符右侧指定的位数（在低位补0）。
###### “有符号”右移位运算符（>>）则将运算符左边的运算对象向右移动运算符右侧指定的位数。“有符号”右移位运算符使用了“符号扩展”：若值为正，则在高位插入0；若值为负，则在高位插入1。
###### “无符号”右移位运算符（>>>），它使用了“零扩展”：无论正负，都在高位插入0。

###### 若对 char，byte 或者 short 进行移位处理，那么在移位进行之前，它们会自动转换成一个int。只有右侧的5个低位才会用到。这样可防止我们在一个int数里移动不切实际的位数。若对一个long值进行处理，最后得到的结果也是long。此时只会用到右侧的6个低位，防止移动超过long值里现成的位数。但在进行“无符号”右移位时，也可能遇到一个问题。若对byte或short值进行右移位运算，得到的可能不是正确的结果（Java 1.0和Java 1.1特别突出）。它们会自动转换成int类型，并进行右移位。但“零扩展”不会发生，所以在那些情况下会得到-1的结果。

###### 移位可与等号（<<=或>>=或>>>=）组合使用。此时，运算符左边的值会移动由右边的值指定的位数，再将得到的结果赋回左边的值。

##### 3.1.9 三元 if-else 运算符
###### 表达式采取下述形式：
```java
                布尔表达式 ? 值0:值1
```
###### 若“布尔表达式”的结果为true，就计算“值0”，而且它的结果成为最终由运算符产生的值。但若“布尔表达式”的结果为false，计算的就是“值1”，而且它的结果成为最终由运算符产生的值。
###### 可将条件运算符用于自己的“副作用”，或用于它生成的值。但通常都应将其用于值，因为那样做可将运算符与if-else明确区别开。

##### 3.1.10 逗号运算符
###### 在Java里需要用到逗号的唯一场所就是for循环，

##### 3.1.11 字串运算符+
###### + 运算符在Java里有一项特殊用途：连接不同的字串。

##### 3.1.12 运算符常规操作规则

##### 3.1.13 造型运算符
###### “造型”（Cast）的作用是“与一个模型匹配”。
###### Java允许我们将任何主类型“造型”为其他任何一种主类型，但布尔值（bollean）要除外，后者根本不允许进行任何造型处理。“类”不允许进行造型。为了将一种类转换成另一种，必须采用特殊的方法。

- 1、字面值
    - 十六进制（Base 16）——它适用于所有整数数据类型——用一个前置的0x或0X指示。并在后面跟随采用大写或小写形式的0-9以及a-f。若试图将一个变量初始化成超出自身能力的一个值（无论这个值的数值形式如何）,最大的十六进制值只会在char，byte以及short身上出现。若超出这一限制，编译器会将值自动变成一个int，并告诉我们需要对这一次赋值进行“缩小造型”。这样一来，我们就可清楚获知自己已超载了边界。
    - 八进制（Base 8）是用数字中的一个前置0以及0-7的数位指示的。在C，C++或者Java中，对二进制数字没有相应的“字面”表示方法。
    - 字面值后的尾随字符标志着它的类型。若为大写或小写的L，代表long；大写或小写的F，代表float；大写或小写的D，则代表double。
    - 指数总是采用一种我们认为很不直观的记号方法：1.39e-47f。在科学与工程学领域，“e”代表自然对数的基数，约等于2.718（Java一种更精确的double值采用Math.E的形式）。它在象“1.39×e的-47次方”这样的指数表达式中使用，意味着“1.39×2.718的-47次方”。然而，自FORTRAN语言发明后，人们自然而然地觉得e代表“10多少次幂”。这种做法显得颇为古怪，因为FORTRAN最初面向的是科学与工程设计领域。理所当然，它的设计者应对这样的混淆概念持谨慎态度（注释①）。但不管怎样，这种特别的表达方法在C，C++以及现在的Java中顽固地保留下来了。所以倘若您习惯将e作为自然对数的基数使用，那么在Java中看到象“1.39e-47f”这样的表达式时，请转换您的思维，从程序设计的角度思考它；它真正的含义是“1.39×10的-47次方”。(‘E’这个字母的含义其实很简单，就是‘Exponential’的意思，即‘指数’或‘幂数’，代表计算系统的基数——一般都是10。)

- 2、转型
    - 通常，表达式中最大的数据类型是决定了表达式最终结果大小的那个类型。若将一个float值与一个double值相乘，结果就是double；如将一个int和一个long值相加，则结果为long。

##### 3.1.14 Java没有“sizeof”
###### Java不需要sizeof()运算符来满足这方面的需要，因为所有数据类型在所有机器的大小都是相同的。


#### 3.2 执行控制
###### Java使用了C的全部控制语句，在Java里，涉及的关键字包括if-else、while、do-while、for以及一个名为switch的选择语句。

##### 3.2.1 真和假
###### 所有条件语句都利用条件表达式的真或假来决定执行流程。
##### 3.2.2 if-else
###### if-else语句或许是控制程序流程最基本的形式。其中的else是可选的，可按下述两种形式来使用if：
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
###### 布尔表达式（条件）必须产生一个布尔结果。
- 1、return
    - return关键字有两方面的用途：指定一个方法返回什么值（假设它没有void返回值），并立即返回那个值（方法在遇到return后便不再继续）。
##### 3.2.3 反复
###### while，do-while和for控制着循环，有时将其划分为“反复语句”。
###### while循环的格式如下：
```java
                    while(布尔表达式)
                    语句
```


###### 在循环刚开始时，会计算一次“布尔表达式”的值。而对于后来每一次额外的循环，都会在开始前重新计算一次。
###### do-while的格式如下：
```java
                    do
                    语句
                    while(布尔表达式)
```

###### while和do-while唯一的区别就是do-while肯定会至少执行一次；也就是说，至少会将其中的语句“过一遍”——即便表达式第一次便计算为false。而在while循环结构中，若条件第一次就为false，那么其中的语句根本不会执行。在实际应用中，while比do-while更常用一些。
###### for循环的格式如下：
```java
                    for(初始表达式; 布尔表达式; 步进)
                    语句
```

###### for循环在第一次反复之前要进行初始化。随后，它会进行条件测试，而且在每一次反复的时候，进行某种形式的“步进”（Stepping）。
###### 无论初始表达式，布尔表达式，还是步进，都可以置空。每次反复前，都要测试一下布尔表达式。若获得的结果是false，就会继续执行紧跟在for语句后面的那行代码。在每次循环的末尾，会计算一次步进。
- 初始表达式：for初始化时 只执行一次
- 布尔表达式：每一次反复时 当 布尔表达式 结果为 false 时， 整个 for 循环结束。
- 语句：
- 步进：
> 注意变量c是在需要用到它的时候定义的——在for循环的控制表达式内部，而非在由起始花括号标记的代码块的最开头。c的作用域是由for控制的表达式。
###### 以于象C这样传统的程序化语言，要求所有变量都在一个块的开头定义。所以在编译器创建一个块的时候，它可以为那些变量分配空间。而在Java和C++中，则可在整个块的范围内分散变量声明，在真正需要的地方才加以定义。这样便可形成更自然的编码风格，也更易理解。
###### 可在for语句里定义多个变量，但它们必须具有同样的类型：
```java
                    for(int i = 0, j = 1;
                    i < 10 && j != 11;
                    i++, j++)
```
###### 只有for循环才具备在控制表达式里定义变量的能力。对于其他任何条件或循环语句，都不可采用这种方法。

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
###### 无论在初始化还是在步进部分，语句都是顺序执行的。此外，尽管初始化部分可设置任意数量的定义，但都属于同一类型。

##### 3.2.6 中断和继续
###### 在任何循环语句的主体部分，亦可用break和continue控制循环的流程。其中，break用于强行退出循环，不执行循环中剩余的语句。而continue则停止执行当前的反复，然后退回循环起始（布尔表达式）和，开始新的反复。
###### 编译器将 while(true) 与 for(;;)看作同一回事。
###### 1. 臭名昭著的“goto”
###### goto关键字很早就在程序设计语言中出现。事实上，goto是汇编语言的程序控制结构的始祖：“若条件A，则跳到这里；否则跳到那里”。事实上，goto是在源码的级别跳转的，所以招致了不好的声誉。若程序总是从一个地方跳到另一个地方，还有什么办法能识别代码的流程呢？真正的问题并不在于使用goto，而在于goto的滥用。而且在一些少见的情况下，goto是组织控制流程的最佳手段。
###### goto是Java的一个保留字，并未在语言中得到正式使用，在break和continue这两个关键字的身上，我们仍然能看出一些goto的影子。：标签。
###### “标签”是后面跟一个冒号的标识符，就象下面这样：
```java
                        label1:
```                    
###### 对Java来说，唯一用到标签的地方是在循环语句之前。进一步说，它实际需要紧靠在循环语句的前方——在标签和循环之间置入任何语句都是不明智的。而在循环之前设置标签的唯一理由是：我们希望在其中嵌套另一个循环或者一个开关。这是由于break和continue关键字通常只中断当前循环，但若随同标签使用，它们就会中断到存在标签的地方。如下所示：
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

###### 大家要记住的重点是：在Java里唯一需要用到标签的地方就是拥有嵌套循环，而且想中断或继续多个嵌套级别的时候。
###### 标签和goto使我们难于对程序作静态分析。这是由于它们在程序的执行流程中引入了许多“怪圈”。但幸运的是，Java标签不会造成这方面的问题，因为它们的活动场所已被限死，不可通过特别的方式到处传递程序的控制权。由此也引出了一个有趣的问题：通过限制语句的能力，反而能使一项语言特性更加有用。

##### 3.2.7 开关
###### “开关”（Switch）有时也被划分为一种“选择语句”。根据一个整数表达式的值，switch语句可从一系列代码选出一段执行。
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

###### 其中，“整数选择因子”是一个特殊的表达式，能产生整数值。switch能将整数选择因子的结果与每个整数值比较。若发现相符的，就执行对应的语句（简单或复合语句）。若没有发现相符的，就执行default语句。
###### 大家会注意到每个case均以一个break结尾。这样可使执行流程跳转至switch主体的末尾。这是构建switch语句的一种传统方式，但break是可选的。若省略break，会继续执行后面的case语句的代码，直到遇到一个break为止。注意最后的default语句没有break，因为执行流程已到了break的跳转目的地。当然，如果考虑到编程风格方面的原因，完全可以在default语句的末尾放置一个break，尽管它并没有任何实际的用处。
###### switch 语句是实现多路选择的一种易行方式（比如从一系列执行路径中挑选一个）。但它要求使用一个选择因子，并且必须是int或char那样的整数值。（在java中switch后的表达式的类型只能为以下几种：byte、short、char、int（在Java1.6中是这样），在java1.7后支持了对string的判断）
###### 将一个float或double值造型成整数值后，总是将小数部分“砍掉”，不作任何进位处理。

#### 3.3 总结
###### 本章总结了大多数程序设计语言都具有的基本特性：计算、运算符优先顺序、类型转换以及选择和循环等等。现在，我们作好了相应的准备，可继续向面向对象的程序设计领域迈进。在下一章里，我们将讨论对象的初始化与清除问题，再后面则讲述隐藏的基本实现方法。

### 第4章 初始化和清除
###### “随着计算机的进步，‘不安全’的程序设计已成为造成编程代价高昂的罪魁祸首之一。”
###### “初始化”和“清除”是这些安全问题的其中两个。
###### C++为我们引入了“构建器”的概念。这是一种特殊的方法，在一个对象创建之后自动调用。Java也沿用了这个概念，但新增了自己的“垃圾收集器”，能在资源不再需要的时候自动释放它们。本章将讨论初始化和清除的问题，以及Java如何提供它们的支持。

#### 4.1 用构建器自动初始化
###### 对于方法的创建，可将其想象成为自己写的每个类都调用一次initialize()。这个名字提醒我们在使用对象之前，应首先进行这样的调用。但不幸的是，这也意味着用户必须记住调用方法。在Java中，由于提供了名为“构建器”的一种特殊方法，所以类的设计者可担保每个对象都会得到正确的初始化。若某个类有一个构建器，那么在创建对象时，Java会自动调用那个构建器——甚至在用户毫不知觉的情况下。所以说这是可以担保的！（也叫：构造器）

###### 构建器的名字与类名相同。这样一来，可保证象这样的一个方法会在初始化期间自动调用。
###### 一旦创建一个对象：
```java
            new Rock();
```
###### 就会分配相应的存储空间，并调用构建器。请注意所有方法首字母小写的编码规则并不适用于构建器。这是由于构建器的名字必须与类名完全相同！ 和其他任何方法一样，构建器也能使用自变量。
###### 利用构建器的自变量，我们可为一个对象的初始化设定相应的参数。
###### 构建器属于一种较特殊的方法类型，因为它没有返回值。这与 void 返回值存在着明显的区别。对于void返回值，尽管方法本身不会自动返回什么，但仍然可以让它返回另一些东西。构建器则不同，它不仅什么也不会自动返回，而且根本不能有任何选择。

#### 4.2 方法过载（overload，也翻译成重载）
###### 我们创建一个对象时，会分配一个名字代表这个类。我们用名字引用或描述所有对象与方法。
###### 在日常生活中，我们用相同的词表达多种不同的含义——即词的“过载”。
###### 大多数程序设计语言（特别是C）要求我们为每个函数都设定一个独一无二的标识符。在Java里，允许方法名出现过载情况。

##### 4.2.1 区分过载方法
###### 规则：每个过载的方法都必须采取独一无二的自变量类型列表。

##### 4.2.2 主类型的过载
###### 主（数据）类型能从一个“较小”的类型自动转变成一个“较大”的类型。涉及过载问题时，这会稍微造成一些混乱。
- 分两种情况：
    - 1、若我们的数据类型“小于”方法中使用的自变量类型，就会对那种数据类型进行“转型”处理。
    - 2、若我们的数据类型.“大于”过载方法期望的自变量类型，就必须用括号中的类型名将其“强转”处理。这是一种缩小转换”。也就是说，在造型或转型过程中可能丢失一些信息。

##### 4.2.3 返回值过载
###### 我们也可能调用一个方法，同时忽略返回值；
- 例如：
```java
        f();
```
```java
    void f() {}
    int f() {}
```
###### 所以不能根据返回值类型来区分过载的方法。

##### 4.2.4 默认构建器
###### 创建一个没有构建器的类，则编译程序会帮我们自动创建一个默认无参的构建器，如果已经定义了一个构建器（无论是否有自变量），编译程序都不会帮我们自动合成一个。

##### 4.2.5 this关键字
###### 假定我们在一个方法的内部，并希望获得当前对象的句柄。由于那个句柄是由编译器“秘密”传递的，所以没有标识符可用。然而，针对这一目的有个专用的关键字：this。this关键字（注意只能在方法内部使用）可为已调用了其方法的那个对象生成相应的句柄。

###### 1、在构建器里调用构建器
###### 若为一个类写了多个构建器，那么经常都需要在一个构建器里调用另一个构建器，以避免写重复的代码。可用this关键字做到这一点。
- 例如：
```java
public class Test {
    private int petalCount = 0;
    private String s = new String("null");
    Test(int petals) {
        petalCount = petals;
        System.out.println(
                "Constructor w/ int arg only, petalCount= "
                        + petalCount);
    }
    Test(String ss) {
        System.out.println(
                "Constructor w/ String arg only, s=" + ss);
        s = ss;
    }
    Test(String s, int petals) {
        this(petals);
        //this(s); // Can't call two!
        this.s = s; // Another use of "this"
        System.out.println("String & int args");
    }
    Test() {
        this("hi", 47);
        System.out.println(
                "default constructor (no args)");
    }
    void print() {
    //! this(11); // 必须是构造函数主体中的第一个语句
        System.out.println(
                "petalCount = " + petalCount + " s = "+ s);
    }

    public static void main(String[] args) {

        Test x = new Test();
        x.print();

    }

}
```
> 注意：尽管可用 this 调用一个构建器，但不可调用两个。除此以外，对“this”代替构造器的调用必须是构造函数主体中的第一个语句，否则会收到编译程序的报错信息。
>
>编译器不让我们从除了一个构建器之外的其他任何方法内部调用一个构建器。
>
>这个例子也向大家展示了 this 的另一项用途。由于自变量s的名字以及成员数据s的名字是相同的，所以会出现混淆。为解决这个问题，可用this.s来引用成员数据。

###### 1、static 的含义
###### 在没有任何对象的前提下，我们可针对类本身发出对一个static方法的调用。事实上，那正是static方法最基本的意义。它就好象我们创建一个全局函数的等价物（在C语言中）。除了全局函数不允许在Java中使用以外，若将一个static方法置入一个类的内部，它就可以访问其他static方法以及static字段。

#### 4.3 清除：收尾和垃圾收集
###### 垃圾收集器只知道释放那些由 new 分配的内存,如何释放对象的“特殊”内存。，Java提供了一个名为 finalize()的方法，可为我们的类定义它。在理想情况下，它的工作原理应该是这样的：一旦垃圾收集器准备好释放对象占用的存储空间，它首先调用finalize()，而且只有在下一次垃圾收集过程中，才会真正回收对象的内存。所以如果使用finalize()，就可以在垃圾收集期间进行一些重要的清除或清扫工作。
> 不建议用finalize方法完成“非内存资源”的清理工作，但建议用于：① 清理本地对象(通过JNI创建的对象)；② 作为确保某些非内存资源(如Socket、文件等)释放的一个补充：在finalize方法中显式调用其他资源释放方法。其原因可见下文[finalize 的问题]

###### 垃圾收集并不等于“破坏”！
###### 我们的对象可能不会当作垃圾被收掉！
###### 有时可能发现一个对象的存储空间永远都不会释放，因为自己的程序永远都接近于用光空间的临界点。若程序执行结束，而且垃圾收集器一直都没有释放我们创建的任何对象的存储空间，则随着程序的退出，那些资源会返回给操作系统。这是一件好事情，因为垃圾收集本身也要消耗一些开销。如永远都不用它，那么永远也不用支出这部分开销。

###### ↑↑↑如上所述，JVM可能并不进行 GC，那么 finalize() 也不会被调用！！！

##### 4.3.1 finalize()用途何在
###### 此时，大家可能已相信了自己应该将 finalize()作为一种常规用途的清除方法使用。它有什么好处呢？ 要记住的第三个重点是：

###### 垃圾收集只跟内存有关！

###### 也就是说，垃圾收集器存在的唯一原因是为了回收程序不再使用的内存。所以对于与垃圾收集有关的任何活动来说，其中最值得注意的是finalize()方法，它们也必须同内存以及它的回收有关。

###### 但这是否意味着假如对象包含了其他对象，finalize()就应该明确释放那些对象呢？答案是否定的——垃圾收集器会负责释放所有对象占据的内存，无论这些对象是如何创建的。它将对 finalize()的需求限制到特殊的情况。在这种情况下，我们的对象可采用与创建对象时不同的方法分配一些存储空间。但大家或许会注意到，Java中的所有东西都是对象，所以这到底是怎么一回事呢？

###### 之所以要使用finalize()，看起来似乎是由于有时需要采取与Java的普通方法不同的一种方法，通过分配内存来做一些具有C风格的事情。这主要可以通过“固有方法”来进行，它是从Java里调用非Java方法的一种方式（固有方法的问题在附录A讨论）。C和C++是目前唯一获得固有方法支持的语言。但由于它们能调用通过其他语言编写的子程序，所以能够有效地调用任何东西。在非Java代码内部，也许能调用C的 malloc()系列函数，用它分配存储空间。而且除非调用了free()，否则存储空间不会得到释放，从而造成内存“漏洞”的出现。当然，free()是一个C和C++函数，所以我们需要在finalize()内部的一个固有方法中调用它。

##### 4.3.2 必须执行清除





























---






















---
(5) 第5章：隐藏实现过程
(6) 第6章：类再生
(7) 第7章：多形性
(8) 第8章：对象的容纳
(9) 第9章：违例差错控制
(10) 第10章：Java IO系统
(11) 第11章：运行期类型鉴定
(12) 第12章：传递和返回对象
(13) 第13章：创建窗口和程序片
(14) 第14章：多线程
(15) 第15章 网络编程
(16) 第16章 设计范式
(17) 第17章 项目
(18) 附录A：使用非Java代码
(19) 附录B：对比C++和Java
(20) 附录C：Java编程规则
(21) 附录D：性能
(22) 附录E：关于垃圾收集的一些话
(23) 附录F：推荐读物



