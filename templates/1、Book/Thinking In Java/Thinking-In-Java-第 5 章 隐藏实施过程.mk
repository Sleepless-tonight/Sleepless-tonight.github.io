## 第 5 章 隐藏实施过程
“进行面向对象的设计时，一项基本的考虑是：如何将发生变化的东西与保持不变的东西分隔开。”

这一点对于库来说是特别重要的。那个库的用户（客户程序员）必须能依赖自己使用的那一部分，并知道一旦新版本的库出台，自己不需要改写代码。而与此相反，库的创建者必须能自由地进行修改与改进，同时保证客户程序员代码不会受到那些变动的影响。

为达到这个目的，需遵守一定的约定或规则。例如，库程序员在修改库内的一个类时，必须保证不删除已有的方法，因为那样做会造成客户程序员代码出现断点。然而，相反的情况却是令人痛苦的。对于一个数据成员，库的创建者怎样才能知道哪些数据成员已受到客户程序员的访问呢？若方法属于某个类唯一的一部分，而且并不一定由客户程序员直接使用，那么这种痛苦的情况同样是真实的。如果库的创建者想删除一种旧有的实施方案，并置入新代码，此时又该怎么办呢？对那些成员进行的任何改动都可能中断客户程序员的代码。所以库创建者处在一个尴尬的境地，似乎根本动弹不得。

为解决这个问题，Java推出了“访问指示符”的概念，允许库创建者声明哪些东西是客户程序员可以使用的，哪些是不可使用的。这种访问控制的级别在“最大访问”和“最小访问”的范围之间，分别包括：public，“友好的”（无关键字），protected以及private。根据前一段的描述，大家或许已总结出作为一名库设计者，应将所有东西都尽可能保持为“private”（私有），并只展示出那些想让客户程序员使用的方法。这种思路是完全正确的，尽管它有点儿违背那些用其他语言（特别是C）编程的人的直觉，那些人习惯于在没有任何限制的情况下访问所有东西。到这一章结束时，大家应该可以深刻体会到Java访问控制的价值。

然而，组件库以及控制谁能访问那个库的组件的概念现在仍不是完整的。仍存在这样一个问题：如何将组件绑定到单独一个统一的库单元里。这是通过Java的package（打包）关键字来实现的，而且访问指示符要受到类在相同的包还是在不同的包里的影响。所以在本章的开头，大家首先要学习库组件如何置入包里。这样才能理解访问指示符的完整含义。

### 5.1 包：库单元

我们用import关键字导入一个完整的库时，就会获得“包”（Package）。例如：
```java
import java.util.*;
```

它的作用是导入完整的实用工具（Utility）库，该库属于标准Java开发工具包的一部分。由于Vector位于java.util里，所以现在要么指定完整名称“java.util.Vector”（可省略import语句），要么简单地指定一个“Vector”（因为import是默认的）。


若想导入单独一个类，可在import语句里指定那个类的名字：
```java
import java.util.Vector;
```

之所以要进行这样的导入，是为了提供一种特殊的机制，以便管理“命名空间”（Name Space）。我们所有类成员的名字相互间都会隔离起来。位于类A内的一个方法f()不会与位于类B内的、拥有相同“签名”（自变量列表）的f()发生冲突。但类名会不会冲突呢？假设创建一个stack类，将它安装到已有一个stack类（由其他人编写）的机器上，这时会出现什么情况呢？对于因特网中的Java应用，这种情况会在用户毫不知晓的时候发生，因为类会在运行一个Java程序的时候自动下载。


正是由于存在名字潜在的冲突，所以特别有必要对Java中的命名空间进行完整的控制，而且需要创建一个完全独一无二的名字，无论因特网存在什么样的限制


迄今为止，本书的大多数例子都仅存在于单个文件中，而且设计成局部（本地）使用，没有同包名发生冲突（在这种情况下，类名置于“默认包”内）。这是一种有效的做法，而且考虑到问题的简化，本书剩下的部分也将尽可能地采用它。然而，若计划创建一个“对因特网友好”或者说“适合在因特网使用”的程序，必须考虑如何防止类名的重复。 为Java创建一个源码文件的时候，它通常叫作一个“编辑单元”（有时也叫作“翻译单元”）。每个编译单元都必须有一个以.java结尾的名字。而且在编译单元的内部，可以有一个公共（public）类，它必须拥有与文件相同的名字（包括大小写形式，但排除.java文件扩展名）。如果不这样做，编译器就会报告出错。每个编译单元内都只能有一个public类（同样地，否则编译器会报告出错）。那个编译单元剩下的类（如果有的话）可在那个包外面的世界面前隐藏起来，因为它们并非“公共”的（非public），而且它们由用于主public类的“支撑”类组成。


编译一个.java文件时，我们会获得一个名字完全相同的输出文件；但对于.java文件中的每个类，它们都有一个.class扩展名。因此，我们最终从少量的.java文件里有可能获得数量众多的.class文件。如以前用一种汇编语言写过程序，那么可能已习惯编译器先分割出一种过渡形式（通常是一个.obj文件），再用一个链接器将其与其他东西封装到一起（生成一个可执行文件），或者与一个库封装到一起（生成一个库）。但那并不是Java的工作方式。一个有效的程序就是一系列.class文件，它们可以封装和压缩到一个JAR文件里（使用Java 1.1提供的jar工具）。Java解释器负责对这些文件的寻找、装载和解释（注释①）。
> ①：Java并没有强制一定要使用解释器。一些固有代码的Java编译器可生成单独的可执行文件。

> class 文件径打破了C或者C++等语言所遵循的传统，使用这些传统语言写的程序通常首先被编译，然后被连接成单独的、专门支持特定硬件平台和操作系统的二进制文件。通常情况下，一个平台上的二进制可执行文件不能在其他平台上工作。而Java class文件是可以运行在任何支持Java虚拟机的硬件平台和操作系统上的二进制文件。
>
>当编译和连接一个C++程序时，所获得的可执行二进制文件只能在指定的硬件平台和操作系统上运行，因为这个二进制文件包含了对目标处理器的机器语言。而Java编译器把Java源文件的指令翻译成字节码，这种字节码就是Java虚拟机的“机器语言”。
>
>与普通程序不同的是，Java程序（class文件）并不是本地的可执行程序。当运行Java程序时，首先运行JVM（Java虚拟机），然后再把Java class加载到JVM里头运行，负责加载Java class的这部分就叫做Class Loader。
>
>在cmd下使用javac 编译某一java文件则会产生.class文件,用java +类名运行。


“库”也由一系列类文件构成。每个文件都有一个public类（并没强迫使用一个public类，但这种情况最很典型的），所以每个文件都有一个组件。如果想将所有这些组件（它们在各自独立的.java和.class文件里）都归纳到一起，那么package关键字就可以发挥作用）。
       

若在一个文件的开头使用下述代码：

```java
package mypackage;
```

那么 package 语句必须作为文件的第一个非注释语句出现。该语句的作用是指出这个编译单元属于名为mypackage的一个库的一部分。或者换句话说，它表明这个编译单元内的public类名位于mypackage这个名字的下面。如果其他人想使用这个名字，要么指出完整的名字，要么与mypackage联合使用import关键字（使用前面给出的选项）。注意根据Java包（封装）的约定，名字内的所有字母都应小写，甚至那些中间单词亦要如此。


每个 .java 文件中只能有一个 public类


现在，如果有人想使用 MyClass，或者想使用 mypackage 内的其他任何 public类，他们必须用 import关键字激活 mypackage内的名字，使它们能够使用。另一个办法则是指定完整的名称：

```java
mypackage.MyClass m = new mypackage.MyClass();
```

或者
```java
import mypackage.*;
// . . .
MyClass m = new MyClass();
```

一定要记住 package 和 import 关键字允许我们做的事情就是分割单个全局命名空间，保证我们不会遇到名字的冲突——无论有多少人使用因特网，也无论多少人用Java编写自己的类。

#### 5.1.1 创建独一无二的包名


大家或许已注意到这样一个事实：由于一个包永远不会真的“封装”到单独一个文件里面，它可由多个.class文件构成，所以局面可能稍微有些混乱。为避免这个问题，最合理的一种做法就是将某个特定包使用的所有.class文件都置入单个目录里。也就是说，我们要利用操作系统的分级文件结构避免出现混乱局面。这正是Java所采取的方法。 它同时也解决了另两个问题：创建独一无二的包名以及找出那些可能深藏于目录结构某处的类。正如我们在第2章讲述的那样，为达到这个目的，需要将.class文件的位置路径编码到package的名字里。但根据约定，编译器强迫package名的第一部分是类创建者的因特网域名。由于因特网域名肯定是独一无二的（由InterNIC保证——注释②，它控制着域名的分配），所以假如按这一约定行事，package的名称就肯定不会重复，所以永远不会遇到名称冲突的问题。换句话说，除非将自己的域名转让给其他人，而且对方也按照相同的路径名编写Java代码，否则名字的冲突是永远不会出现的。当然，如果你没有自己的域名，那么必须创造一个非常生僻的包名（例如自己的英文姓名），以便尽最大可能创建一个独一无二的包名。如决定发行自己的Java代码，那么强烈推荐去申请自己的域名，它所需的费用是非常低廉的。


Java解释器的工作程序如下：首先，它找到环境变量CLASSPATH（将Java或者具有Java解释能力的工具——如浏览器——安装到机器中时，通过操作系统进行设定）。CLASSPATH包含了一个或多个目录，它们作为一种特殊的“根”使用，从这里展开对.class文件的搜索。从那个根开始，解释器会寻找包名，并将每个点号（句点）替换成一个斜杠，从而生成从CLASSPATH根开始的一个路径名（所以package foo.bar.baz会变成foo\bar\baz或者foo/bar/baz；具体是正斜杠还是反斜杠由操作系统决定）。随后将它们连接到一起，成为CLASSPATH内的各个条目（入口）。以后搜索.class文件时，就可从这些地方开始查找与准备创建的类名对应的名字。此外，它也会搜索一些标准目录——这些目录与Java解释器驻留的地方有关。


使用JAR文件时要注意一个问题：必须将JAR文件的名字置于类路径里，而不仅仅是它所在的路径。所以对一个名为grape.jar的JAR文件来说，我们的类路径需要包括：

```java
CLASSPATH=.;D:\JAVA\LIB;C:\flavors\grape.jar
```

1. 自动编译:

为导入的类首次创建一个对象时（或者访问一个类的static成员时），编译器会在适当的目录里寻找同名的.class文件（所以如果创建类X的一个对象，就应该是X.class）。若只发现X.class，它就是必须使用的那一个类。然而，如果它在相同的目录中还发现了一个X.java，编译器就会比较两个文件的日期标记。如果X.java比X.class新，就会自动编译X.java，生成一个最新的X.class。 对于一个特定的类，或在与它同名的.java文件中没有找到它，就会对那个类采取上述的处理。


#### 5.1.2 自定义工具库


创建自己的工具库，以便减少或者完全消除重复的代码。

1. CLASSPATH的陷阱

#### 5.1.3 利用导入改变行为


Java已取消的一种特性是C的“条件编译”，它允许我们改变参数，获得不同的行为，同时不改变其他任何代码。Java之所以抛弃了这一特性，可能是由于该特性经常在C里用于解决跨平台问题：代码的不同部分根据具体的平台进行编译，否则不能在特定的平台上运行。由于Java的设计思想是成为一种自动跨平台的语言，所以这种特性是没有必要的。


然而，条件编译还有另一些非常有价值的用途。一种很常见的用途就是调试代码。调试特性可在开发过程中使用，但在发行的产品中却无此功能。Alen Holub（www.holub.com）提出了利用包（package）来模仿条件编译的概念。根据这一概念，它创建了C“断定机制”一个非常有用的Java版本。之所以叫作“断定机制”，是由于我们可以说“它应该为真”或者“它应该为假”。如果语句不同意你的断定，就可以发现相关的情况。这种工具在调试过程中是特别有用的。


通过改变导入的package，我们可将自己的代码从调试版本变成最终的发行版本。这种技术可应用于任何种类的条件代码。

#### 5.1.4 包的停用

大家应注意这样一个问题：每次创建一个包后，都在为包取名时间接地指定了一个目录结构。这个包必须存在（驻留）于由它的名字规定的目录内。而且这个目录必须能从CLASSPATH开始搜索并发现。最开始的时候，package关键字的运用可能会令人迷惑，因为除非坚持遵守根据目录路径指定包名的规则，否则就会在运行期获得大量莫名其妙的消息，指出找不到一个特定的类——即使那个类明明就在相同的目录中。若得到象这样的一条消息，请试着将package语句作为注释标记出去。如果这样做行得通，就可知道问题到底出在哪儿。

### 5.2 Java 访问指示符

#### private -> default（Friendly） -> protected-> public
#### 类中 -> 包内 -> 子类 -> 公开
修饰符 | 类内部 | 同包 | 子类 | 任何地方
---|---|---|---|---
private | Yes |   |   |  
default | Yes | Yes |   |  
protected | Yes | Yes | Yes|  
public | Yes | Yes | Yes | Yes
#### 5.2.1 default（Friendly）


(4) Provide 提供“accessor／mutator”方法（亦称为“get／set”方法），以便读取和修改值。这是 OOP环境中最正规的一种方法，也是Java Beans的基础——具体情况会在第13章介绍。

#### 5.2.3 private

private 有非常重要的用途，特别是在涉及多线程处理的时候（详情见第14章）。

```java
//: IceCream.java
// Demonstrates "private" keyword

class Sundae {
  private Sundae() {}
  static Sundae makeASundae() { 
    return new Sundae(); 
  }
}

public class IceCream {
  public static void main(String[] args) {
    //! Sundae x = new Sundae();
    Sundae x = Sundae.makeASundae();
  }
} ///:~
```


例子演示了使用private的方便：有时可能想控制对象的创建方式，并防止有人直接访问一个特定的构建器（或者所有构建器）。在上面的例子中，我们不可通过它的构建器创建一个Sundae对象；相反，必须调用makeASundae()方法来实现（注释③）。

> ③：此时还会产生另一个影响：由于默认构建器是唯一获得定义的，而且它的属性是private，所以可防止对这个类的继承（这是第6章要重点讲述的主题）。


### 5.3 接口与实现

我们通常认为访问控制是“隐藏实施细节”的一种方式。将数据和方法封装到类内后，可生成一种数据类型，它具有自己的特征与行为。但由于两方面重要的原因，访问为那个数据类型加上了自己的边界。第一个原因是规定客户程序员哪些能够使用，哪些不能。我们可在结构里构建自己的内部机制，不用担心客户程序员将其当作接口的一部分，从而自由地使用或者“滥用”。

这个原因直接导致了第二个原因：我们需要将接口同实施细节分离开。若结构在一系列程序中使用，但用户除了将消息发给public接口之外，不能做其他任何事情，我们就可以改变不属于public的所有东西（如“友好的”、protected以及private），同时不要求用户对他们的代码作任何修改。

我们现在是在一个面向对象的编程环境中，其中的一个类（class）实际是指“一类对象”，就象我们说“鱼类”或“鸟类”那样。从属于这个类的所有对象都共享这些特征与行为。“类”是对属于这一类的所有对象的外观及行为进行的一种描述。

在一些早期OOP语言中，如Simula-67，关键字class的作用是描述一种新的数据类型。同样的关键字在大多数面向对象的编程语言里都得到了应用。它其实是整个语言的焦点：需要新建数据类型的场合比那些用于容纳数据和方法的“容器”多得多。

在一些早期OOP语言中，如Simula-67，关键字class的作用是描述一种新的数据类型。同样的关键字在大多数面向对象的编程语言里都得到了应用。它其实是整个语言的焦点：需要新建数据类型的场合比那些用于容纳数据和方法的“容器”多得多。

在Java中，类是最基本的OOP概念。它是本书未采用粗体印刷的关键字之一——由于数量太多，所以会造成页面排版的严重混乱。

由于接口和实施细节仍然混合在一起，所以只是部分容易阅读。也就是说，仍然能够看到源码——实施的细节，因为它们需要保存在类里面。向一个类的消费者显示出接口实际是“类浏览器”的工作。这种工具能查找所有可用的类，总结出可对它们采取的全部操作（比如可以使用哪些成员等），并用一种清爽悦目的形式显示出来。到大家读到这本书的时候，所有优秀的Java开发工具都应推出了自己的浏览器。

### 5.4 类访问

在Java中，亦可用访问指示符判断出一个库内的哪些类可由那个库的用户使用。
#### 我们注意到一些额外的限制：
1. 每个编译单元（文件）都只能有一个public类。每个编译单元有一个公共接口的概念是由那个公共类表达出来的。根据自己的需要，它可拥有任意多个提供支撑的“友好”类。但若在一个编译单元里使用了多个public类，编译器就会向我们提示一条出错消息。
2. public类的名字必须与包含了编译单元的那个文件的名字完全相符，甚至包括它的大小写形式。
3. 可能（但并常见）有一个编译单元根本没有任何公共类。此时，可按自己的意愿任意指定文件名。(内部使用，不希望有客户程序员依赖。)
4. 若不愿其他任何人访问那个类，可将所有构建器设为private。这样一来，在类的一个static成员内部，除自己之外的其他所有人都无法创建属于那个类的一个对象（注释⑤）。
5. 若不愿其他任何人访问那个类，可将所有构建器设为private。这样一来，在类的一个static成员内部，除自己之外的其他所有人都无法创建属于那个类的一个对象（注释⑤）。

### 5.5 总结


对于任何关系，最重要的一点都是规定好所有方面都必须遵守的界限或规则。

有两方面的原因要求我们控制对成员的访问。第一个是防止用户接触那些他们不应碰的工具。对于数据类型的内部机制，那些工具是必需的。但它们并不属于用户接口的一部分，用户不必用它来解决自己的特定问题。所以将方法和字段变成“私有”（private）后，可极大方便用户。因为他们能轻易看出哪些对于自己来说是最重要的，以及哪些是自己需要忽略的。这样便简化了用户对一个类的理解。

进行访问控制的第二个、也是最重要的一个原因是：允许库设计者改变类的内部工作机制，同时不必担心它会对客户程序员产生什么影响。

一个类的公共接口是所有用户都能看见的，所以在进行分析与设计的时候，这是应尽量保证其准确性的最重要的一个部分。但也不必过于紧张，少许的误差仍然是允许的。若最初设计的接口存在少许问题，可考虑添加更多的方法，只要保证不删除客户程序员已在他们的代码里使用的东西。

