## 第 2 章：一切都是对象
Java语言首先便假定了我们只希望进行面向对象的程序设计。

### 2.1 用句柄操纵对象

将一切都“看作”对象，操纵的 标识符 实际是指向一个对象的“句柄”（Handle）。

```
            创建一个String句柄：
                String s;
                这里创建的只是句柄，并不是对象。s实际并未与任何东西连接（即“没有实体”）。
                一种更安全的做法是：创建一个句柄时，记住无论如何都进行初始化：
                String s = "asdf";
            总结：
                句柄指向对象，通过句柄操作对象，句柄是句柄，对象是对象。
```

### 2.2 所有对象都必须创建
创建句柄时，我们希望它同一个新对象连接。通常用 new 关键字达到这一目的。。new的意思是：“把我变成这些对象的一种新实体”。

#### 2.2.1 保存到什么地方
程序运行时，我们最好对数据保存到什么地方做到心中有数。特别要注意的是内存的分配。有六个地方都可以保存数据：

在Java中是不可能得到真正的内存地址的，也不会提供直接操作“内存地址”的方式。

Java中堆是由JVM管理的不能直接操作。
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

#### 2.2.2 特殊情况：主要类型
有一系列类需特别对待；可将它们想象成“基本”、“主要”或者“主”（Primitive）类型，进行程序设计时要频繁用到它们。之所以要特别对待，是由于用new创建对象（特别是小的、简单的变量）并不是非常有效，因为new将对象置于“堆”里。对于这些类型，Java采纳了与C和C++相同的方法。也就是说，不是用new创建变量，而是创建一个并非句柄的“自动”变量。这个变量容纳了具体的值，并置于堆栈中，能够更高效地存取。

Java决定了每种主要类型的大小。(8bit=1byte)

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

- 注意：
  - 若变量是主数据类型作为类成员使用，Java可自动分配默认值，可保证主类型的成员变量肯定得到了初始化（自动初始化）（C++不具备这一功能），却并不适用于“局部”变量——那些变量并非一个类的字段，不会自动初始化，会得到一条编译期错误。

- 高精度数字
    - 用于进行高精度的计算：BigInteger和BigDecimal。尽管它们大致可以划分为“封装器”类型，但两者都没有对应的“主类型”。这两个类都有自己特殊的“方法”，对应于我们针对主类型执行的操作。

#### 2.2.3 Java的数组
 Java的一项主要设计目标就是安全性。一个Java可以保证被初始化，而且不可在它的范围之外访问。由于系统自动进行范围检查，所以必然要付出一些代价：针对每个数组，以及在运行期间对索引的校验，都会造成少量的内存开销。

创建对象数组时，实际创建的是一个句柄数组。而且每个句柄都会自动初始化成一个特殊值，并带有自己的关键字：null（空）。一旦Java看到null，就知道该句柄并未指向一个对象。正式使用前，必须为每个句柄都分配一个对象。

### 2.3 所有对象都必须创建

在大多数程序设计语言中，变量的“存在时间”（Lifetime）一直是程序员需要着重考虑的问题。变量应持续多长的时间？如果想清除它，那么何时进行？在变量存在时间上纠缠不清会造成大量的程序错误。

#### 2.3.1 作用域（Scope）

作用域同时决定了它的“可见性”以及“存在时间”。在C，C++和Java里，作用域是由花括号的位置决定的。
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
                    
作为在作用域里定义的一个变量，它只有在那个作用域结束之前才可使用。

#### 2.3.2 对象的作用域

Java对象不具备与主类型一样的存在时间。用 new 关键字创建一个Java对象的时候，它会超出作用域的范围之外。
- 例子：
```java
                    {
                    String s = new String("a string");
                    } /* 作用域的终点 */
```                   

那么句柄 s会在作用域的终点处消失。然而，s 指向的 String 对象依然占据着内存空间。在上面这段代码里，我们没有办法访问对象，因为指向它的唯一一个句柄已超出了作用域的边界。
这样造成的结果便是：对于用 new 创建的对象，只要我们愿意，它们就会一直保留下去。这个编程问题在 C 和 C++ 里特别突出。看来在 C++ 里遇到的麻烦最大：由于不能从语言获得任何帮助，所以在需要对象的时候，根本无法确定它们是否可用。而且更麻烦的是，在 C++ 里，一旦工作完成，必须保证将对象清除。

假如 Java 让对象依然故我，怎样才能防止它们大量充斥内存，并最终造成程序的“凝固”呢。在 C++ 里，这个问题最令程序员头痛。但 Java 以后，情况却发生了改观。Java 有一个特别的“垃圾收集器”，它会查找用new创建的所有对象，并辨别其中哪些不再被引用。随后，它会自动释放由那些闲置对象占据的内存，以便能由新对象使用。这意味着我们根本不必操心内存的回收问题。只需简单地创建对象，一旦不再需要它们，它们就会自动离去。这样做可防止在 C++里很常见的一个编程问题：由于程序员忘记释放内存造成的“内存溢出”。

### 2.4 新建数据类型：类
一切东西都是对象，那么用什么决定一个“类”（Class）的外观与行为呢？换句话说，是什么建立起了一个对象的“类型”（class）呢？通过 class 关键字。
- 例如：
```java
                //这样就引入了一种新类型。
                    class ATypeName {/*类主体置于这里}

                //这样就用new创建这种类型的一个新对象：
                    ATypeName a = new ATypeName();
```


#### 2.4.1 字段和方法
定义一个类时（我们在Java里的全部工作就是定义类、制作那些类的对象以及将消息发给那些对象），可在自己的类里设置两种类型的元素：数据成员（有时也叫“字段”）、成员函数（通常叫“方法”）。其中，数据成员是一种对象（通过它的句柄与其通信），可以为任何类型。它也可以是主类型（并不是句柄）之一。如果是指向对象的一个句柄，则必须初始化那个句柄，用一种名为“构建器”的特殊函数将其与一个实际对象连接起来（就象早先看到的那样，使用new关键字）。但若是一种主类型，则可在类定义位置直接初始化（正如后面会看到的那样，句柄亦可在定义位置初始化）。  
每个对象都为自己的数据成员保有存储空间；数据成员不会在对象之间共享。（这个共享是指指向一块内存位置的意思么？）  
- 示例：
```java
                    class DataOnly {
                    int i;
                    float f;
                    boolean b;
                    }
```


对象实例化后可值赋给数据成员，但首先必须知道如何引用一个对象的成员。首先要写上对象句柄的名字，再跟随一个点号，再跟随对象内部成员的名字。即“对象句柄.成员”。(引用 或者 说 访问权限 会受 修饰符（public、protected、default、private）影响。)  
- 例如：
```java
                    d.i = 47;
                    d.f = 1.1f;
                    d.b = false;
```

一个对象也可能包含了另一个对象，只需保持“连接句点”即可。
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

### 2.5 方法、自变量和返回值
我们一直用“函数”（Function）这个词指代一个已命名的子例程。但在 Java 里，更常用的一个词却是“方法”（Method），代表“完成某事的途径”。尽管它们表达的实际是同一个意思。  
Java的“方法”决定了一个对象能够接收的消息。  
方法的基本组成部分包括名字、自变量、返回类型以及主体。下面便是它最基本的形式：  
```java
                返回类型 方法名( /* 自变量列表*/ ) {/* 方法主体 */}
```

返回类型是指调用方法之后返回的数值类型。显然，方法名的作用是对具体的方法进行标识和引用。自变量列表列出了想传递给方法的信息类型和名称。  
Java的方法只能作为类的一部分创建。只能针对某个对象调用一个方法（注释③），而且那个对象必须能够执行那个方法调用。  

为一个对象调用方法时，需要先列出对象的名字，在后面跟上一个句点，再跟上方法名以及它的参数列表。亦即“对象名.方法名(自变量1，自变量2，自变量3...)。例如：我们有一个方法名叫f()，它没有自变量，返回的是类型为int的一个值。假设有一个名为a的对象，可为其调用方法f()，则代码如下：  
```java
                int x = a.f();
```

象这样调用一个方法的行动通常叫作“向对象发送一条消息”。在上面的例子中，消息是f()，而对象是 a。面向对象的程序设计通常简单地归纳为“向对象发送消息”。  

> ③：正如马上就要学到的那样，“静态”方法可针对类调用，毋需一个对象。
> 自变量 也叫 形参，是方法的局部变量。

#### 2.5.1 自变量列表
自变量列表规定了我们传送给方法的是什么信息。这些信息——如同Java内其他任何东西——采用的都是对象的形式。因此，我们必须在自变量列表里指定要传递的对象类型，以及每个对象的名字。正如在Java其他地方处理对象时一样，我们实际传递的是“句柄”（注释④）。然而，句柄的类型必须正确。倘若希望自变量是一个“字串”，那么传递的必须是一个字串。  
> ④：对于前面提及的“特殊”数据类型 boolean，char，byte，short，int，long，，float以及double来说是一个例外。但在传递对象时，通常都是指传递指向对象的句柄。（也就是说 基本类型 传递的是值本身）
return 关键字的运用。它主要做两件事情。首先，它意味着“离开方法，我已完工了”。其次，假设方法生成了一个值，则那个值紧接在 return 语句的后面。可按返回 那个值，但倘若不想返回任何东西，就可指示方法返回 void（空）。  
若返回类型为 void，则 return 关键字唯一的作用就是退出方法。  
但假设已指定了一种非 void 的返回类型，那么无论从何地返回，编译器都会确保我们返回的是正确的类型。  

### 2.6 构建 Java 程序
#### 2.6.1 名字的可见性
Java 的设计者鼓励程序员反转使用自己的 Internet 域名，给一个库生成明确的名字。  

#### 2.6.2 使用其他组件
用 import 关键字准确告诉 Java 编译器我们希望的类是什么。import 的作用是指示编译器导入一个“包”——或者说一个“类库”（在其他语言里，可将“库”想象成一系列函数、数据以及类的集合。但请记住，Java的所有代码都必须写入一个类中）。  
- 例如：
```java
                    import java.util.Vector;
```


#### 2.6.3 static关键字
static 修饰的成员表明它是属于这个类本(Class)身，而不是属于该类的单个实列(Object)，没有使用 static 修饰的成员只可通过实例调动，static 修饰的成员不能直接访问非静态成员（因为非静态成员没有初始化）。  
通常，用 new 创建那个类的一个对象，才会正式生成数据存储空间，并可使用相应的方法。  
但在两种特殊的情形下，上述方法并不堪用。一种情形是只想用一个存储区域来保存一个特定的数据——无论要创建多少个对象，甚至根本不创建对象。另一种情形是我们需要一个特殊的方法，它没有与这个类的任何对象关联。也就是说，即使没有创建对象，也需要一个能调用的方法。为满足这两方面的要求，可使用 static（静态）关键字。一旦将什么东西设为 static，数据或方法就不会同那个类的任何对象实例联系到一起。所以尽管从未创建那个类的一个对象，仍能调用一个 static方法，或访问一些 static数据。  
- 例如：
```java
                    class StaticTest {
                        static int i = 47;
                    }

```

我们制作了两个 StaticTest对象：  
```java
                    StaticTest st1 = new StaticTest();
                    StaticTest st2 = new StaticTest();
```


但它们仍然只占据 StaticTest.i的一个存储空间。这两个对象都共享同样的i。无论st1.i还是st2.i都有同样的值47，因为它们引用的是同样的内存区域。  
所以有两个办法可引用一个 static 变量。可通过一个对象命名它，如 st2.i，亦可直接用它的类名引用，如 StaticTest.i（最好用这个办法引用 static 变量，因为它强调了那个变量的“静态”本质）。  

static一项重要的用途就是帮助我们在不必创建对象的前提下调用那个方法。和其他任何方法一样，static方法也能创建自己类型的命名对象。所以经常把 static方法作为一个“领头羊”使用，用它生成一系列自己类型的“实例”。  


### 2.7 我们的第一个Java程序
由于java.lang默认进入每个Java代码文件，所以这些类在任何时候都可直接使用。  
通过为 Runtime类调用getRuntime()方法，main()的第五行创建了一个Runtime对象，Runtime可告诉我们与内存使用有关的信息。  

### 2.8 注释和嵌入文档
#### 2.8.1 注释文档
人们需要考虑程序的文档化问题。用于提取注释的工具叫作javadoc。它不仅提取由这些注释标记指示的信息，也将毗邻注释的类名或方法名提取出来。  
javadoc输出的是一个HTML文件，可用自己的Web浏览器查看。    
#### 2.8.2 具体语法
所有javadoc命令都只能出现于 “/**” 注释中。有三种类型的注释文档，它们对应于位于注释后面的元素：类、变量或者方法。    
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

#### 2.8.3 嵌入HTML
javadoc 将HTML命令传递给最终生成的HTML文档。  

亦可象在其他 Web文档里那样运用HTML，对普通文本进行格式化，使其更具条理、更加美观：  
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
注意在文档注释中，位于一行最开头的星号会被javadoc丢弃。同时丢弃的还有前导空格。javadoc 会对所有内容进行格式化，使其与标准的文档外观相符。不要将 &lt;h1> 或 &lt;hr> 这样的标题当作嵌入HTML使用，因为javadoc会插入自己的标题，我们给出的标题会与之冲撞。  

#### 2.8.4 @see：引用其他类
所有三种类型的注释文档都可包含@see标记，它允许我们引用其他类里的文档。对于这个标记，javadoc会生成相应的HTML，将其直接链接到其他文档。格式如下：  
```java
                    @see 类名
                    @see 完整类名
                    @see 完整类名#方法名
```

每一格式都会在生成的文档里自动加入一个超链接的“See Also”（参见）条目。注意javadoc不会检查我们指定的超链接，不会验证它们是否有效。  

#### 2.8.5 类文档标记
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


#### 2.8.6 变量文档标记
变量文档只能包括嵌入的HTML以及@see引用。  
 
#### 2.8.7 方法文档标记
除嵌入HTML和@see引用之外，方法还允许使用针对参数、返回值以及违例的文档标记。  
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

#### 2.8.8 文档示例

### 2.9 编码样式
一个非正式的Java编程标准是大写一个类名的首字母。若类名由几个单词构成，那么把它们紧靠到一起（也就是说，不要用下划线来分隔名字）。此外，每个嵌入单词的首字母都采用大写形式。  
- 例如：
```java
                class AllTheColorsOfTheRainbow { // ...}
```

其他几乎所有内容：方法、字段（成员变量）以及对象句柄名称，可接受的样式与类样式差不多，只是标识符的第一个字母采用小写。  
- 例如：
```java
                int anIntegerRepresentingColors;
                void changeTheHueOfTheColor(int newHue) {
                // ...
                }
```
### 2.10 总结
本章是基础知识。  


