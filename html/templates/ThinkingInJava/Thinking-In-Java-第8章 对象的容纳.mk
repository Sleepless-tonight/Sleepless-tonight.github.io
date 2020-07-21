## 第8章 对象的容纳
“如果一个程序只含有数量固定的对象，而且已知它们的存在时间，那么这个程序可以说是相当简单的。”

通常，我们的程序需要根据程序运行时才知道的一些标准创建新对象。若非程序正式运行，否则我们根本不知道自己到底需要多少数量的对象，甚至不知道它们的准确类型。为了满足常规编程的需要，我们要求能在任何时候、任何地点创建任意数量的对象。所以不可依赖一个已命名的句柄来容纳自己的每一个对象，
因为根本不知道自己实际需要多少这样的东西。

为解决这个非常关键的问题，Java提供了容纳对象（或者对象的句柄）的多种方式。其中内建的类型是数组，我们之前已讨论过它，本章准备加深大家对它的认识。此外，Java的工具（实用程序）库提供了一些“集合类”（亦称作“容器类”，但该术语已由AWT使用，所以这里仍采用“集合”这一称呼）。利用这些集合类，我们可以容纳乃至操纵自己的对象。本章的剩余部分会就此进行详细讨论。

### 8.1 数组
数组只是容纳对象的一种方式。但由于还有其他大量方法可容纳数组，所以是哪些地方使数组显得如此特别呢？ 有两方面的问题将数组与其他集合类型区分开来：效率和类型。对于Java来说，为保存和访问一系列对象（实际是对象的句柄）数组，最有效的方法莫过于数组。数组实际代表一个简单的线性序列，它使得元素的访问速度非常快，但我们却要为这种速度付出代价：创建一个数组对象时，它的大小是固定的，而且不可在那个数组对象的“存在时间”内发生改变。可创建特定大小的一个数组，然后假如用光了存储空间，就再创建一个新数组，将所有句柄从旧数组移到新数组。这属于“矢量”（Vector）类的行为，本章稍后还会详细讨论它。然而，由于为这种大小的灵活性要付出较大的代价，所以我们认为矢量的效率并没有数组高。

C++的矢量类知道自己容纳的是什么类型的对象，但同Java的数组相比，它却有一个明显的缺点：C++矢量类的operator[]不能进行范围检查，所以很容易超出边界（然而，它可以查询vector有多大，而且at()方法确实能进行范围检查）。在Java中，无论使用的是数组还是集合，都会进行范围检查——若超过边界，就会获得一个RuntimeException（运行期违例）错误。正如大家在第9章会学到的那样，这类违例指出的是一个程序员错误，所以不需要在代码中检查它。在另一方面，由于C++的vector不进行范围检查，所以访问速度较快——在Java中，由于对数组和集合都要进行范围检查，所以对性能有一定的影响。

本章还要学习另外几种常见的集合类：Vector（矢量）、Stack（堆栈）以及Hashtable（散列表）。这些类都涉及对对象的处理——好象它们没有特定的类型。换言之，它们将其当作Object类型处理（Object类型是Java中所有类的“根”类）。从某个角度看，这种处理方法是非常合理的：我们仅需构建一个集合，然后任何Java对象都可以进入那个集合（除基本数据类型外——可用Java的基本类型封装类将其作为常数置入集合，或者将其封装到自己的类内，作为可以变化的值使用）。这再一次反映了数组优于常规集合：创建一个数组时，可令其容纳一种特定的类型。这意味着可进行编译期类型检查，预防自己设置了错误的类型，或者错误指定了准备提取的类型。当然，在编译期或者运行期，Java会防止我们将不当的消息发给一个对象。所以我们不必考虑自己的哪种做法更加危险，只要编译器能及时地指出错误，同时在运行期间加快速度，目的也就达到了。此外，用户很少会对一次违例事件感到非常惊讶的。

考虑到执行效率和类型检查，应尽可能地采用数组。然而，当我们试图解决一个更常规的问题时，数组的局限也可能显得非常明显。在研究过数组以后，本章剩余的部分将把重点放到Java提供的集合类身上。

#### 8.1.1 数组和第一类对象
无论使用的数组属于什么类型，数组标识符实际都是指向真实对象的一个句柄。那些对象本身是在内存“堆”里创建的。堆对象既可“隐式”创建（即默认产生），亦可“显式”创建（即明确指定，用一个new表达式）。堆对象的一部分（实际是我们能访问的唯一字段或方法）是只读的length（长度）成员，它告诉我们那个数组对象里最多能容纳多少元素。对于数组对象，“[]”语法是我们能采用的唯一另类访问方法。

下面这个例子展示了对数组进行初始化的不同方式，以及如何将数组句柄分配给不同的数组对象。它也揭示出对象数组和基本数据类型数组在使用方法上几乎是完全一致的。唯一的差别在于对象数组容纳的是句柄，而基本数据类型数组容纳的是具体的数值（若在执行此程序时遇到困难，请参考第3章的“赋值”小节）：

length只告诉我们可将多少元素置入那个数组。换言之，我们只知道数组对象的大小或容量，不知其实际容纳了多少个元素。
尽管如此，由于数组对象在创建之初会自动初始化成null，所以可检查它是否为null，判断一个特定的数组“空位”是否容纳一个对象。类似地，由基本数据类型构成的数组会自动初始化成零（针对数值类型）、null（字符类型）或者false（布尔类型）。

Java 1.1加入了一种新的数组初始化语法，可将其想象成“动态集合初始化”。
```
hide(new Weeble[] {new Weeble(), new Weeble() });
```
对于由基本数据类型构成的数组，它们的运作方式与对象数组极为相似，只是前者直接包容了基本类型的数据值。

集合类只能容纳对象句柄。但对一个数组，却既可令其直接容纳基本类型的数据，亦可容纳指向对象的句柄。

创建和访问一个基本数据类型数组，那么比起访问一个封装数据的集合，前者的效率会高出许多。

当然，假如准备一种基本数据类型，同时又想要集合的灵活性（在需要的时候可自动扩展，腾出更多的空间），就不宜使用数组，必须使用由封装的数据构成的一个集合。大家或许认为针对每种基本数据类型，都应有一种特殊类型的Vector。但Java并未提供这一特性。某些形式的建模机制或许会在某一天帮助Java更好地解决这个问题（注释①）。

①：这儿是C++比Java做得好的一个地方，因为C++通过template关键字提供了对“参数化类型”的支持。

#### 8.1.2 数组的返回
假定我们现在想写一个方法，同时不希望它仅仅返回一样东西，而是想返回一系列东西。此时，象C和C++这样的语言会使问题复杂化，因为我们不能返回一个数组，只能返回指向数组的一个指针。这样就非常麻烦，因为很难控制数组的“存在时间”，它很容易造成内存“漏洞”的出现。

Java采用的是类似的方法，但我们能“返回一个数组”。当然，此时返回的实际仍是指向数组的指针。但在Java里，我们永远不必担心那个数组的是否可用——只要需要，它就会自动存在。而且垃圾收集器会在我们完成后自动将其清除。

返回数组与返回其他任何对象没什么区别——最终返回的都是一个句柄。


### 8.2 集合

为容纳一组对象，最适宜的选择应当是数组。而且假如容纳的是一系列基本数据类型，更是必须采用数组。

Java提供了四种类型的“集合类”：Vector（矢量）、BitSet（位集）、Stack（堆栈）以及Hashtable（散列表）。与拥有集合功能的其他语言相比，尽管这儿的数量显得相当少，但仍然能用它们解决数量惊人的实际问题。

这些集合类具有形形色色的特征。例如，Stack实现了一个LIFO（先入先出）序列，而Hashtable是一种“关联数组”，允许我们将任何对象关联起来。除此以外，所有Java集合类都能自动改变自身的大小。所以，我们在编程时可使用数量众多的对象，同时不必担心会将集合弄得有多大。

#### 8.2.1 缺点：类型未知

使用Java集合的“缺点”是在将对象置入一个集合时丢失了类型信息。之所以会发生这种情况，是由于当初编写集合时，那个集合的程序员根本不知道用户到底想把什么类型置入集合。若指示某个集合只允许特定的类型，会妨碍它成为一个“常规用途”的工具，为用户带来麻烦。为解决这个问题，集合实际容纳的是类型为Object的一些对象的句柄。这种类型当然代表Java中的所有对象，因为它是所有类的根。当然，也要注意这并不包括基本数据类型，因为它们并不是从“任何东西”继承来的。这是一个很好的方案，只是不适用下述场合：
- (1) 将一个对象句柄置入集合时，由于类型信息会被抛弃，所以任何类型的对象都可进入我们的集合——即便特别指示它只能容纳特定类型的对象。举个例子来说，虽然指示它只能容纳猫，但事实上任何人都可以把一条狗扔进来。
- (2) 由于类型信息不复存在，所以集合能肯定的唯一事情就是自己容纳的是指向一个对象的句柄。正式使用它之前，必须对其进行造型，使其具有正确的类型。

值得欣慰的是，Java不允许人们滥用置入集合的对象。假如将一条狗扔进一个猫的集合，那么仍会将集合内的所有东西都看作猫，所以在使用那条狗时会得到一个“违例”错误。在同样的意义上，假若试图将一条狗的句柄“造型”到一只猫，那么运行期间仍会得到一个“违例”错误。

这些处理的意义都非常深远。尽管显得有些麻烦，但却获得了安全上的保证。我们从此再难偶然造成一些隐藏得深的错误。若程序的一个部分（或几个部分）将对象插入一个集合，但我们只是通过一次违例在程序的某个部分发现一个错误的对象置入了集合，就必须找出插入错误的位置。当然，可通过检查代码达到这个目的，但这或许是最笨的调试工具。另一方面，我们可从一些标准化的集合类开始自己的编程。尽管它们在功能上存在一些不足，且显得有些笨拙，但却能保证没有隐藏的错误。

1. 错误有时并不显露出来

在某些情况下，程序似乎正确地工作，不造型回我们原来的类型。第一种情况是相当特殊的：String类从编译器获得了额外的帮助，使其能够正常工作。只要编译器期待的是一个String对象，但它没有得到一个，就会自动调用在Object里定义、并且能够由任何Java类覆盖的toString()方法。这个方法能生成满足要求的String对象，然后在我们需要的时候使用。

1. 参数化类型

这类问题并不是孤立的——我们许多时候都要在其他类型的基础上创建新类型。此时，在编译期间拥有特定的类型信息是非常有帮助的。这便是“参数化类型”的概念。在C++中，它由语言通过“模板”获得了直接支持。至少，Java保留了关键字generic，期望有一天能够支持参数化类型。但我们现在无法确定这一天何时会来临。

### 8.3 枚举器（迭代器）

在任何集合类中，必须通过某种方法在其中置入对象，再用另一种方法从中取得对象。毕竟，容纳各种各样的对象正是集合的首要任务。在Vector中，addElement()便是我们插入对象采用的方法，而elementAt()是提取对象的唯一方法。Vector非常灵活，我们可在任何时候选择任何东西，并可使用不同的索引选择多个元素。

若从更高的角度看这个问题，就会发现它的一个缺陷：需要事先知道集合的准确类型，否则无法使用。乍看来，这一点似乎没什么关系。但假若最开始决定使用Vector，后来在程序中又决定（考虑执行效率的原因）改变成一个List（属于Java1.2集合库的一部分），这时又该如何做呢？
可利用“反复器”（Iterator）的概念达到这个目的。它可以是一个对象，作用是遍历一系列对象，并选择那个序列中的每个对象，同时不让客户程序员知道或关注那个序列的基础结构。此外，我们通常认为反复器是一种“轻量级”对象；也就是说，创建它只需付出极少的代价。但也正是由于这个原因，我们常发现反复器存在一些似乎很奇怪的限制。例如，有些反复器只能朝一个方向移动。 Java的Enumeration（枚举，注释②）便是具有这些限制的一个反复器的例子。除下面这些外，不可再用它做其他任何事情：

(1) 用一个名为elements()的方法要求集合为我们提供一个Enumeration。我们首次调用它的nextElement()时，这个Enumeration会返回序列中的第一个元素。

(2) 用nextElement()获得下一个对象。

(3) 用hasMoreElements()检查序列中是否还有更多的对象。

②：“反复器”这个词在C++和OOP的其他地方是经常出现的，所以很难确定为什么Java的开发者采用了这样一个奇怪的名字。Java 1.2的集合库修正了这个问题以及其他许多问题。

只可用Enumeration做这些事情，不能再有更多。它属于反复器一种简单的实现方式，但功能依然十分强大。为体会它的运作过程，让我们复习一下本章早些时候提到的CatsAndDogs.java程序。在原始版本中，elementAt()方法用于选择每一个元素，但在下述修订版中，可看到使用了一个“枚举”：

使用Enumeration，我们不必关心集合中的元素数量。所有工作均由hasMoreElements()和nextElement()自动照管了。

注意其中没有与序列类型有关的信息。我们拥有的全部东西便是Enumeration。为了解有关序列的情况，一个Enumeration便足够了：可取得下一个对象，亦可知道是否已抵达了末尾。取得一系列对象，然后在其中遍历，从而执行一个特定的操作——这是一个颇有价值的编程概念，本书许多地方都会沿用这一思路。
这个看似特殊的例子甚至可以更为通用，因为它使用了常规的toString()方法（之所以称为常规，是由于它属于Object类的一部分）。下面是调用打印的另一个方法（尽管在效率上可能会差一些）：

它采用了封装到Java内部的“自动转换成字串”技术。一旦编译器碰到一个字串，后面跟随一个“+”，就会希望后面又跟随一个字串，并自动调用toString()。在Java 1.1中，第一个字串是不必要的；所有对象都会转换成字串。亦可对此执行一次造型，获得与调用toString()同样的效果：

但我们想做的事情通常并不仅仅是调用Object方法，所以会再度面临类型造型的问题。对于自己感兴趣的类型，必须假定自己已获得了一个Enumeration，然后将结果对象造型成为那种类型（若操作错误，会得到运行期违例）。

>总结：
>
> 这章就是讲迭代器的，自己去看一下集合的迭代器实现就行了。

### 8.4 集合的类型
标准Java 1.0和1.1库配套提供了非常少的一系列集合类。但对于自己的大多数编程要求，它们基本上都能胜任。正如大家到本章末尾会看到的，Java 1.2提供的是一套重新设计过的大型集合库。

这章是讲集合的先看两张图
![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/2243690-9cd9c896e0d512ed.gif)
![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/java-coll.png)

集合框架被设计成要满足以下几个目标。
- 该框架必须是高性能的。基本集合（动态数组，链表，树，哈希表）的实现也必须是高效的。
- 该框架允许不同类型的集合，以类似的方式工作，具有高度的互操作性。
- 对一个集合的扩展和适应必须是简单的。


#### 8.4.1 Vector 矢量
#### 8.4.2 BitSet
#### 8.4.3 Stack
Stack有时也可以称为“后入先出”（LIFO）集合。换言之，我们在堆栈里最后“压入”的东西将是以后第一个“弹出”的。和其他所有Java集合一样，我们压入和弹出的都是“对象”，所以必须对自己弹出的东西进行“造型”。

一种很少见的做法是拒绝使用Vector作为一个Stack的基本构成元素，而是从Vector里“继承”一个Stack。这样一来，它就拥有了一个Vector的所有特征及行为，另外加上一些额外的Stack行为。很难判断出设计者到底是明确想这样做，还是属于一种固有的设计。

#### 8.4.4 Hashtable
Vector允许我们用一个数字从一系列对象中作出选择，所以它实际是将数字同对象关联起来了。但假如我们想根据其他标准选择一系列对象呢？堆栈就是这样的一个例子：它的选择标准是“最后压入堆栈的东西”。这种“从一系列对象中选择”的概念亦可叫作一个“映射”、“字典”或者“关联数组”。从概念上讲，它看起来象一个Vector，但却不是通过数字来查找对象，而是用另一个对象来查找它们！这通常都属于一个程序中的重要进程。

在Java中，这个概念具体反映到抽象类Dictionary身上。该类的接口是非常直观的size()告诉我们其中包含了多少元素；isEmpty()判断是否包含了元素（是则为true）；put(Object key, Object value)添加一个值（我们希望的东西），并将其同一个键关联起来（想用于搜索它的东西）；get(Object key)获得与某个键对应的值；而remove(Object Key)用于从列表中删除“键－值”对。还可以使用枚举技术：keys()产生对键的一个枚举（Enumeration）；而elements()产生对所有值的一个枚举。这便是一个Dictionary（字典）的全部。

标准Java库只包含Dictionary的一个变种，名为Hashtable（散列表，注释③）。Java的散列表具有与AssocArray相同的接口（因为两者都是从Dictionary继承来的）。但有一个方面却反映出了差别：执行效率。若仔细想想必须为一个get()做的事情，就会发现在一个Vector里搜索键的速度要慢得多。但此时用散列表却可以加快不少速度。不必用冗长的线性搜索技术来查找一个键，而是用一个特殊的值，名为“散列码”。散列码可以获取对象中的信息，然后将其转换成那个对象“相对唯一”的整数（int）。所有对象都有一个散列码，而hashCode()是根类Object的一个方法。Hashtable获取对象的hashCode()，然后用它快速查找键。这样可使性能得到大幅度提升（④）。散列表的具体工作原理已超出了本书的范围（⑤）——大家只需要知道散列表是一种快速的“字典”（Dictionary）即可，而字典是一种非常有用的工具。

我们用第二个实例进行检索。 大家或许认为此时要做的全部事情就是正确地覆盖hashCode()。但这样做依然行不能，除非再做另一件事情：覆盖也属于Object一部分的equals()。当散列表试图判断我们的键是否等于表内的某个键时，就会用到这个方法。同样地，默认的Object.equals()只是简单地比较对象地址，所以一个Groundhog(3)并不等于另一个Groundhog(3)。
因此，为了在散列表中将自己的类作为键使用，必须同时覆盖hashCode()和equals()。

#### 8.4.5 再论枚举器
我们现在可以开始演示Enumeration（枚举）的真正威力：将穿越一个序列的操作与那个序列的基础结构分隔开。在下面的例子里，PrintData类用一个Enumeration在一个序列中移动，并为每个对象都调用toString()方法。此时创建了两个不同类型的集合：一个Vector和一个Hashtable。并且在它们里面分别填充Mouse和Hamster对象（本章早些时候已定义了这些类；注意必须先编译HamsterMaze.java和WorksAnyway.java，否则下面的程序不能编译）。由于Enumeration隐藏了基层集合的结构，所以PrintData不知道或者不关心Enumeration来自于什么类型的集合：


### 8.5 排序
Java 1.0和1.1库都缺少的一样东西是算术运算，甚至没有最简单的排序运算方法。因此，我们最好创建一个Vector，利用经典的Quicksort（快速排序）方法对其自身进行排序。

编写通用的排序代码时，面临的一个问题是必须根据对象的实际类型来执行比较运算，从而实现正确的排序。当然，一个办法是为每种不同的类型都写一个不同的排序方法。然而，应认识到假若这样做，以后增加新类型时便不易实现代码的重复利用。

程序设计一个主要的目标就是“将发生变化的东西同保持不变的东西分隔开”。在这里，保持不变的代码是通用的排序算法，而每次使用时都要变化的是对象的实际比较方法。因此，我们不可将比较代码“硬编码”到多个不同的排序例程内，而是采用“回调”技术。利用回调，经常发生变化的那部分代码会封装到它自己的类内，而总是保持相同的代码则“回调”发生变化的代码。这样一来，不同的对象就可以表达不同的比较方式，同时向它们传递相同的排序代码。

每次调用addElement()时，都可对Vector进行排序，而且将其连续保持在一个排好序的状态。但在开始读取之前，人们总是向一个Vector添加大量元素。所以与其在每个addElement()后排序，不如一直等到有人想读取Vector，再对其进行排序。后者的效率要高得多。这种除非绝对必要，否则就不采取行动的方法叫作“懒惰求值”（还有一种类似的技术叫作“懒惰初始化”——除非真的需要一个字段值，否则不进行初始化）。
```
        Comparator<Users> comparator = new Comparator<Users>() {
            @Override
            public int compare(Users s1, Users s2) {
                //先排年龄
                System.out.println(s1.age.compareTo(s2.age));
                //return s1.age.compareTo(s2.age);//降序
                return s2.age.compareTo(s1.age);//升序

            }
        };

        //这里就会自动根据规则进行排序
        Collections.sort(list, comparator);
```

### 8.6 通用集合库

### 8.7 新集合
对我来说，集合类属于最强大的一种工具，特别适合在原创编程中使用。大家可能已感觉到我对Java 1.1提供的集合多少有点儿失望。因此，看到Java 1.2对集合重新引起了正确的注意后，确实令人非常愉快。这个版本的集合也得到了完全的重新设计（由Sun公司的Joshua Bloch）。我认为新设计的集合是Java 1.2中两项最主要的特性之一（另一项是Swing库，将在第13章叙述），因为它们极大方便了我们的编程，也使Java变成一种更成熟的编程系统。

有些设计使得元素间的结合变得更紧密，也更容易让人理解。例如，许多名字都变得更短、更明确了，而且更易使用；类型同样如此。有些名字进行了修改，更接近于通俗：我感觉特别好的一个是用“反复器”（Inerator）代替了“枚举”（Enumeration）。

此次重新设计也加强了集合库的功能。现在新增的行为包括链接列表、队列以及撤消组队（即“双终点队列”）。

新的集合库考虑到了“容纳自己对象”的问题，并将其分割成两个明确的概念：
(1) 集合（Collection）：一组单独的元素，通常应用了某种规则。在这里，一个List（列表）必须按特定的顺序容纳元素，而一个Set（集）不可包含任何重复的元素。相反，“包”（Bag）的概念未在新的集合库中实现，因为“列表”已提供了类似的功能。
(2) 映射（Map）：一系列“键－值”对（这已在散列表身上得到了充分的体现）。从表面看，这似乎应该成为一个“键－值”对的“集合”，但假若试图按那种方式实现它，就会发现实现过程相当笨拙。这进一步证明了应该分离成单独的概念。另一方面，可以方便地查看Map的某个部分。只需创建一个集合，然后用它表示那一部分即可。这样一来，Map就可以返回自己键的一个Set、一个包含自己值的List或者包含自己“键－值”对的一个List。和数组相似，Map可方便扩充到多个“维”，毋需涉及任何新概念。只需简单地在一个Map里包含其他Map（后者又可以包含更多的Map，以此类推）。

Collection和Map可通过多种形式实现，具体由编程要求决定。下面列出的是一个帮助大家理解的新集合示意图：

![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/8-1.gif)

这张图刚开始的时候可能让人有点儿摸不着头脑，但在通读了本章以后，相信大家会真正理解它实际只有三个集合组件：Map，List和Set。而且每个组件实际只有两、三种实现方式（注释⑥），而且通常都只有一种特别好的方式。只要看出了这一点，集合就不会再令人生畏。

⑥：写作本章时，Java 1.2尚处于β测试阶段，所以这张示意图没有包括以后会加入的TreeSet。
虚线框代表“接口”，点线框代表“抽象”类，而实线框代表普通（实际）类。点线箭头表示一个特定的类准备实现一个接口（在抽象类的情况下，则是“部分”实现一个接口）。双线箭头表示一个类可生成箭头指向的那个类的对象。例如，任何集合都可以生成一个反复器（Iterator），而一个列表可以生成一个ListIterator（以及原始的反复器，因为列表是从集合继承的）。

在类的分级结构中，可看到大量以“Abstract”（抽象）开头的类，这刚开始可能会使人感觉迷惑。它们实际上是一些工具，用于“部分”实现一个特定的接口。举个例子来说，假如想生成自己的Set，就不是从Set接口开始，然后自行实现所有方法。相反，我们可以从AbstractSet继承，只需极少的工作即可得到自己的新类。尽管如此，新集合库仍然包含了足够的功能，可满足我们的几乎所有需求。所以考虑到我们的目的，可忽略所有以“Abstract”开头的类。

ArrayList是一个典型的Collection，它代替了Vector的位置。

利用iterator()方法，所有集合都能生成一个“反复器”（Iterator）。反复器其实就象一个“枚举”（Enumeration），是后者的一个替代物，只是：

- (1) 它采用了一个历史上默认、而且早在OOP中得到广泛采纳的名字（反复器）。
- (2) 采用了比Enumeration更短的名字：hasNext()代替了hasMoreElement()，而next()代替了nextElement()。
- (3) 添加了一个名为remove()的新方法，可删除由Iterator生成的上一个元素。所以每次调用next()的时候，只需调用remove()一次。


#### 8.7.1 使用 Collections
Collections 总结了用一个集合能做的所有事情（亦可对Set和List做同样的事情，尽管List还提供了一些额外的功能）。Map 要单独对待。

#### 8.7.2 使用Lists
List（接口） 顺序是List最重要的特性；它可保证元素按照规定的顺序排列。List为Collection添加了大量方法，以便我们在List中部插入和删除元素（只推荐对LinkedList这样做）。List也会生成一个ListIterator（列表反复器），利用它可在一个列表里朝两个方向遍历，同时插入和删除位于列表中部的元素（同样地，只建议对LinkedList这样做）

ArrayList＊ 由一个数组后推得到的List。作为一个常规用途的对象容器使用，用于替换原先的Vector。允许我们快速访问元素，但在从列表中部插入和删除元素时，速度却嫌稍慢。一般只应该用ListIterator对一个ArrayList进行向前和向后遍历，不要用它删除和插入元素；与LinkedList相比，它的效率要低许多

LinkedList 提供优化的顺序访问性能，同时可以高效率地在列表中部进行插入和删除操作。但在进行随机访问时，速度却相当慢，此时应换用ArrayList。也提供了addFirst()，addLast()，getFirst()，getLast()，removeFirst()以及removeLast()（未在任何接口或基础类中定义），以便将其作为一个规格、队列以及一个双向队列使用。

#### 8.7.3 使用Sets
Set拥有与Collection完全相同的接口，所以和两种不同的List不同，它没有什么额外的功能。相反，Set完全就是一个Collection，只是具有不同的行为（这是实例和多形性最理想的应用：用于表达不同的行为）。在这里，一个Set只允许每个对象存在一个实例（正如大家以后会看到的那样，一个对象的“值”的构成是相当复杂的）。

Set（接口） 添加到Set的每个元素都必须是独一无二的；否则Set就不会添加重复的元素。添加到Set里的对象必须定义equals()，从而建立对象的唯一性。Set拥有与Collection完全相同的接口。一个Set不能保证自己可按任何特定的顺序维持自己的元素

HashSet＊ 用于除非常小的以外的所有Set。对象也必须定义hashCode() ArraySet 由一个数组后推得到的Set。面向非常小的Set设计，特别是那些需要频繁创建和删除的。对于小Set，与HashSet相比，ArraySet创建和反复所需付出的代价都要小得多。但随着Set的增大，它的性能也会大打折扣。不需要HashCode() TreeSet 由一个“红黑树”后推得到的顺序Set（注释⑦）。这样一来，我们就可以从一个Set里提到一个顺序集合

HashSet维持的顺序与ArraySet是不同的。这是由于它们采用了不同的方法来保存元素，以便它们以后的定位。ArraySet保持着它们的顺序状态，而HashSet使用一个散列函数，这是特别为快速检索设计的）。创建自己的类型时，一定要注意Set需要通过一种方式来维持一种存储顺序，

#### 8.7.4 使用Maps
Map（接口） 维持“键－值”对应关系（对），以便通过一个键查找相应的值

HashMap＊ 基于一个散列表实现（用它代替Hashtable）。针对“键－值”对的插入和检索，这种形式具有最稳定的性能。可通过构建器对这一性能进行调整，以便设置散列表的“能力”和“装载因子”

ArrayMap 由一个ArrayList后推得到的Map。对反复的顺序提供了精确的控制。面向非常小的Map设计，特别是那些需要经常创建和删除的。对于非常小的Map，创建和反复所付出的代价要比HashMap低得多。但在Map变大以后，性能也会相应地大幅度降低

TreeMap 在一个“红－黑”树的基础上实现。查看键或者“键－值”对时，它们会按固定的顺序排列（取决于Comparable或 Comparator，稍后即会讲到）。TreeMap最大的好处就是我们得到的是已排好序的结果。TreeMap是含有subMap()方法的唯一一种Map，利用它可以返回树的一部分

keySet()方法会产生一个Set，它由Map中的键后推得来。在这儿，它只被当作一个Collection对待。values()也得到了类似的对待，它的作用是产生一个List，其中包含了Map中的所有值（注意键必须是独一无二的，而值可以有重复）。由于这些Collection是由Map后推得到的，所以一个Collection中的任何改变都会在相应的Map中反映出来。

当创建自己的类，将其作为Map中的一个键使用时，必须注意到和以前的Set相同的问题。

#### 8.7.5 决定实施方案

从早些时候的那幅示意图可以看出，实际上只有三个集合组件：Map，List和Set。而且每个接口只有两种或三种实施方案。若需使用由一个特定的接口提供的功能，如何才能决定到底采取哪一种方案呢？

为理解这个问题，必须认识到每种不同的实施方案都有自己的特点、优点和缺点。比如在那张示意图中，可以看到Hashtable，Vector和Stack的“特点”是它们都属于“传统”类，所以不会干扰原有的代码。但在另一方面，应尽量避免为新的（Java 1.2）代码使用它们。

其他集合间的差异通常都可归纳为它们具体是由什么“后推”的。换言之，取决于物理意义上用于实施目标接口的数据结构是什么。例如，ArrayList，LinkedList以及Vector（大致等价于ArrayList）都实现了List接口，所以无论选用哪一个，我们的程序都会得到类似的结果。然而，ArrayList（以及Vector）是由一个数组后推得到的；而LinkedList是根据常规的双重链接列表方式实现的，因为每个单独的对象都包含了数据以及指向列表内前后元素的句柄。正是由于这个原因，假如想在一个列表中部进行大量插入和删除操作，那么LinkedList无疑是最恰当的选择（LinkedList还有一些额外的功能，建立于AbstractSequentialList中）。若非如此，就情愿选择ArrayList，它的速度可能要快一些。

作为另一个例子，Set既可作为一个ArraySet实现，亦可作为HashSet实现。ArraySet是由一个ArrayList后推得到的，设计成只支持少量元素，特别适合要求创建和删除大量Set对象的场合使用。然而，一旦需要在自己的Set中容纳大量元素，ArraySet的性能就会大打折扣。写一个需要Set的程序时，应默认选择HashSet。而且只有在某些特殊情况下（对性能的提升有迫切的需求），才应切换到ArraySet。

1. 决定使用何种List

为体会各种List实施方案间的差异，最简便的方法就是进行一次性能测验。

可以看出，在ArrayList中进行随机访问（即get()）以及循环反复是最划得来的；但对于LinkedList却是一个不小的开销。但另一方面，在列表中部进行插入和删除操作对于LinkedList来说却比ArrayList划算得多。我们最好的做法也许是先选择一个ArrayList作为自己的默认起点。以后若发现由于大量的插入和删除造成了性能的降低，再考虑换成LinkedList不迟。

1. 决定使用何种Set

可在ArraySet以及HashSet间作出选择，具体取决于Set的大小（如果需要从一个Set中获得一个顺序列表，请用TreeSet；注释⑧）。

最后对ArraySet的测试只有500个元素，而不是1000个，因为它太慢了。

进行add()以及contains()操作时，HashSet显然要比ArraySet出色得多，而且性能明显与元素的多寡关系不大。一般编写程序的时候，几乎永远用不着使用ArraySet。

1. 决定使用何种Map

选择不同的Map实施方案时，注意Map的大小对于性能的影响是最大的，

由于Map的大小是最严重的问题，所以程序的计时测试按Map的大小（或容量）来分割时间，以便得到令人信服的测试结果。

即使大小为10，ArrayMap的性能也要比HashMap差——除反复循环时以外。而在使用Map时，反复的作用通常并不重要（get()通常是我们时间花得最多的地方）。TreeMap提供了出色的put()以及反复时间，但get()的性能并不佳。但是，我们为什么仍然需要使用TreeMap呢？这样一来，我们可以不把它作为Map使用，而作为创建顺序列表的一种途径。树的本质在于它总是顺序排列的，不必特别进行排序（它的排序方式马上就要讲到）。一旦填充了一个TreeMap，就可以调用keySet()来获得键的一个Set“景象”。然后用toArray()产生包含了那些键的一个数组。随后，可用static方法Array.binarySearch()快速查找排好序的数组中的内容。当然，也许只有在HashMap的行为不可接受的时候，才需要采用这种做法。因为HashMap的设计宗旨就是进行快速的检索操作。最后，当我们使用Map时，首要的选择应该是HashMap。只有在极少数情况下才需要考虑其他方法。 此外，在上面那张表里，有另一个性能问题没有反映出来。下述程序用于测试不同类型Map的创建速度：


#### 8.7.7 排序和搜索
Java 1.2添加了自己的一套实用工具，可用来对数组或列表进行排列和搜索。这些工具都属于两个新类的“静态”方法。这两个类分别是用于排序和搜索数组的Arrays，以及用于排序和搜索列表的Collections。

1. 数组

Arrays类为所有基本数据类型的数组提供了一个过载的sort()和binarySearch()，它们亦可用于String和Object。下面这个例子显示出如何排序和搜索一个字节数组（其他所有基本数据类型都是类似的）以及一个String数组：

```java
package c08.newcollections;
import java.util.*;

public class Array1 {
  static Random r = new Random();
  static String ssource =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ" +
    "abcdefghijklmnopqrstuvwxyz";
  static char[] src = ssource.toCharArray();
  // Create a random String
  public static String randString(int length) {
    char[] buf = new char[length];
    int rnd;
    for(int i = 0; i < length; i++) {
      rnd = Math.abs(r.nextInt()) % src.length;
      buf[i] = src[rnd];
    }
    return new String(buf);
  }
  // Create a random array of Strings:
  public static
  String[] randStrings(int length, int size) {
    String[] s = new String[size];
    for(int i = 0; i < size; i++)
      s[i] = randString(length);
    return s;
  }
  public static void print(byte[] b) {
    for(int i = 0; i < b.length; i++)
      System.out.print(b[i] + " ");
    System.out.println();
  }
  public static void print(String[] s) {
    for(int i = 0; i < s.length; i++)
      System.out.print(s[i] + " ");
    System.out.println();
  }
  public static void main(String[] args) {
    byte[] b = new byte[15];
    r.nextBytes(b); // Fill with random bytes
    print(b);
    Arrays.sort(b);
    print(b);
    int loc = Arrays.binarySearch(b, b[10]);
    System.out.println("Location of " + b[10] +
      " = " + loc);
    // Test String sort & search:
    String[] s = randStrings(4, 10);
    print(s);
    Arrays.sort(s);
    print(s);
    loc = Arrays.binarySearch(s, s[4]);
    System.out.println("Location of " + s[4] +
      " = " + loc);
  }
} ///:~
```
类的第一部分包含了用于产生随机字串对象的实用工具，可供选择的随机字母保存在一个字符数组中。randString()返回一个任意长度的字串；而readStrings()创建随机字串的一个数组，同时给定每个字串的长度以及希望的数组大小。两个print()方法简化了对示范数组的显示。在main()中，Random.nextBytes()用随机选择的字节填充数组自变量（没有对应的Random方法用于创建其他基本数据类型的数组）。获得一个数组后，便可发现为了执行sort()或者binarySearch()，只需发出一次方法调用即可。与binarySearch()有关的还有一个重要的警告：若在执行一次binarySearch()之前不调用sort()，便会发生不可预测的行为，其中甚至包括无限循环。

对String的排序以及搜索是相似的，但在运行程序的时候，我们会注意到一个有趣的现象：排序遵守的是字典顺序，亦即大写字母在字符集中位于小写字母的前面。因此，所有大写字母都位于列表的最前面，后面再跟上小写字母——Z居然位于a的前面。似乎连电话簿也是这样排序的。

1. 可比较与比较器

若用自己的Comparator来进行一次sort()，那么在使用binarySearch()时必须使用那个相同的Comparator。

Arrays类提供了另一个sort()方法，它会采用单个自变量：一个Object数组，但没有Comparator。这个sort()方法也必须用同样的方式来比较两个Object。通过实现Comparable接口，它采用了赋予一个类的“自然比较方法”。这个接口含有单独一个方法——compareTo()，能分别根据它小于、等于或者大于自变量而返回负数、零或者正数，从而实现对象的比较。下面这个例子简单地阐示了这一点：

1. 列表

可用与数组相同的形式排序和搜索一个列表（List）。用于排序和搜索列表的静态方法包含在类Collections中，但它们拥有与Arrays中差不多的签名：sort(List)用于对一个实现了Comparable的对象列表进行排序；binarySearch(List,Object)用于查找列表中的某个对象；sort(List,Comparator)利用一个“比较器”对一个列表进行排序；

#### 8.7.8 实用工具
Collections类中含有其他大量有用的实用工具：

1. 使Collection或Map不可修改

1. Collection或Map的同步

synchronized关键字是“多线程”机制一个非常重要的部分。我们到第14章才会对这一机制作深入的探讨。在这儿，大家只需注意到Collections类提供了对整个容器进行自动同步的一种途径。它的语法与“不可修改”的方法是类似的：

能查出除我们的进程自己需要负责的之外的、对容器的其他任何修改。若探测到有其他方面也准备修改容器，便会立即产生一个ConcurrentModificationException（并发修改违例）。我们将这一机制称为“立即失败”——它并不用更复杂的算法在“以后”侦测问题，而是“立即”产生违例。

### 8.8 总结
### 8.9 练习

