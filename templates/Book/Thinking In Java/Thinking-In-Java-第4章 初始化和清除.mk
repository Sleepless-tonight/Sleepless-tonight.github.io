## 第4章 初始化和清除

“随着计算机的进步，‘不安全’的程序设计已成为造成编程代价高昂的罪魁祸首之一。”

“初始化”和“清除”是这些安全问题的其中两个。

C++为我们引入了“构建器”的概念。这是一种特殊的方法，在一个对象创建之后自动调用。Java也沿用了这个概念，但新增了自己的“垃圾收集器”，能在资源不再需要的时候自动释放它们。本章将讨论初始化和清除的问题，以及Java如何提供它们的支持。

### 4.1 用构建器自动初始化

对于方法的创建，可将其想象成为自己写的每个类都调用一次initialize()。这个名字提醒我们在使用对象之前，应首先进行这样的调用。但不幸的是，这也意味着用户必须记住调用方法。在Java中，由于提供了名为“构建器”的一种特殊方法，所以类的设计者可担保每个对象都会得到正确的初始化。若某个类有一个构建器，那么在创建对象时，Java会自动调用那个构建器——甚至在用户毫不知觉的情况下。所以说这是可以担保的！（也叫：构造器）


构建器的名字与类名相同。这样一来，可保证象这样的一个方法会在初始化期间自动调用。

一旦创建一个对象：
```java
            new Rock();
```

就会分配相应的存储空间，并调用构建器。请注意所有方法首字母小写的编码规则并不适用于构建器。这是由于构建器的名字必须与类名完全相同！ 和其他任何方法一样，构建器也能使用自变量。

利用构建器的自变量，我们可为一个对象的初始化设定相应的参数。

构建器属于一种较特殊的方法类型，因为它没有返回值。这与 void 返回值存在着明显的区别。对于void返回值，尽管方法本身不会自动返回什么，但仍然可以让它返回另一些东西。构建器则不同，它不仅什么也不会自动返回，而且根本不能有任何选择。

### 4.2 方法过载（overload，也翻译成重载）

我们创建一个对象时，会分配一个名字代表这个类。我们用名字引用或描述所有对象与方法。

在日常生活中，我们用相同的词表达多种不同的含义——即词的“过载”。

大多数程序设计语言（特别是C）要求我们为每个函数都设定一个独一无二的标识符。在Java里，允许方法名出现过载情况。

#### 4.2.1 区分过载方法

规则：每个过载的方法都必须采取独一无二的自变量类型列表。

#### 4.2.2 主类型的过载

主（数据）类型能从一个“较小”的类型自动转变成一个“较大”的类型。涉及过载问题时，这会稍微造成一些混乱。
- 分两种情况：
    - 1、若我们的数据类型“小于”方法中使用的自变量类型，就会对那种数据类型进行“转型”处理。
    - 2、若我们的数据类型.“大于”过载方法期望的自变量类型，就必须用括号中的类型名将其“强转”处理。这是一种缩小转换”。也就是说，在造型或转型过程中可能丢失一些信息。

#### 4.2.3 返回值过载

我们也可能调用一个方法，同时忽略返回值；
- 例如：
```java
        f();
```
```java
    void f() {}
    int f() {}
```

所以不能根据返回值类型来区分过载的方法。

#### 4.2.4 默认构建器

创建一个没有构建器的类，则编译程序会帮我们自动创建一个默认无参的构建器，如果已经定义了一个构建器（无论是否有自变量），编译程序都不会帮我们自动合成一个。

#### 4.2.5 this关键字

假定我们在一个方法的内部，并希望获得当前对象的句柄。由于那个句柄是由编译器“秘密”传递的，所以没有标识符可用。然而，针对这一目的有个专用的关键字：this。this关键字（注意只能在方法内部使用）可为已调用了其方法的那个对象生成相应的句柄。


1、在构建器里调用构建器

若为一个类写了多个构建器，那么经常都需要在一个构建器里调用另一个构建器，以避免写重复的代码。可用this关键字做到这一点。
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


1、static 的含义

在没有任何对象的前提下，我们可针对类本身发出对一个static方法的调用。事实上，那正是static方法最基本的意义。它就好象我们创建一个全局函数的等价物（在C语言中）。除了全局函数不允许在Java中使用以外，若将一个static方法置入一个类的内部，它就可以访问其他static方法以及static字段。

### 4.3 清除：收尾和垃圾收集

垃圾收集器只知道释放那些由 new 分配的内存,如何释放对象的“特殊”内存。，Java提供了一个名为 finalize()的方法，可为我们的类定义它。在理想情况下，它的工作原理应该是这样的：一旦垃圾收集器准备好释放对象占用的存储空间，它首先调用finalize()，而且只有在下一次垃圾收集过程中，才会真正回收对象的内存。所以如果使用finalize()，就可以在垃圾收集期间进行一些重要的清除或清扫工作。
> 不建议用finalize方法完成“非内存资源”的清理工作，但建议用于：① 清理本地对象(通过JNI创建的对象)；② 作为确保某些非内存资源(如Socket、文件等)释放的一个补充：在finalize方法中显式调用其他资源释放方法。其原因可见下文[finalize 的问题]


垃圾收集并不等于“破坏”！

我们的对象可能不会当作垃圾被收掉！

有时可能发现一个对象的存储空间永远都不会释放，因为自己的程序永远都接近于用光空间的临界点。若程序执行结束，而且垃圾收集器一直都没有释放我们创建的任何对象的存储空间，则随着程序的退出，那些资源会返回给操作系统。这是一件好事情，因为垃圾收集本身也要消耗一些开销。如永远都不用它，那么永远也不用支出这部分开销。


↑↑↑如上所述，JVM可能并不进行 GC，那么 finalize() 也不会被调用！！！

#### 4.3.1 finalize()用途何在

此时，大家可能已相信了自己应该将 finalize()作为一种常规用途的清除方法使用。它有什么好处呢？ 要记住的第三个重点是：


垃圾收集只跟内存有关！


也就是说，垃圾收集器存在的唯一原因是为了回收程序不再使用的内存。所以对于与垃圾收集有关的任何活动来说，其中最值得注意的是finalize()方法，它们也必须同内存以及它的回收有关。


但这是否意味着假如对象包含了其他对象，finalize()就应该明确释放那些对象呢？答案是否定的——垃圾收集器会负责释放所有对象占据的内存，无论这些对象是如何创建的。它将对 finalize()的需求限制到特殊的情况。在这种情况下，我们的对象可采用与创建对象时不同的方法分配一些存储空间。但大家或许会注意到，Java中的所有东西都是对象，所以这到底是怎么一回事呢？


之所以要使用 finalize()，看起来似乎是由于有时需要采取与Java的普通方法不同的一种方法，通过分配内存来做一些具有C风格的事情。这主要可以通过“固有方法”来进行，它是从Java里调用非Java方法的一种方式（固有方法的问题在附录A讨论）。C和C++是目前唯一获得固有方法支持的语言。但由于它们能调用通过其他语言编写的子程序，所以能够有效地调用任何东西。在非Java代码内部，也许能调用C的 malloc()系列函数，用它分配存储空间。而且除非调用了free()，否则存储空间不会得到释放，从而造成内存“漏洞”的出现。当然，free()是一个C和C++函数，所以我们需要在finalize()内部的一个固有方法中调用它。

> 个人总结一下：就是说在垃圾回收中需要注意的或者说影响垃圾回收行为的代码就是 finalize()，如果一个类有 finalize() ，那么它在第一次被垃圾回收器找上门的时候并不会直接被回收，而是执行 finalize() 中的代码，第二次被垃圾回收器找上门时才会被回收，另需注意的是，只有内存不足才会触发垃圾回收，才会进一步触发 finalize() 在中的代码，可能整个程序运行期间都不会进行垃圾回收，那么在 finalize() 中的代码也不会被执行。 

#### 4.3.2 必须执行清除

为清除一个对象，那个对象的用户必须在希望进行清除的地点调用一个清除方法。这听起来似乎很容易做到，但却与C++“破坏器”的概念稍有抵触。在C++中，所有对象都会破坏（清除）。或者换句话说，所有对象都“应该”破坏。若将C++对象创建成一个本地对象，比如在堆栈中创建（在Java中是不可能的），那么清除或破坏工作就会在“结束花括号”所代表的、创建这个对象的作用域的末尾进行。若对象是用new创建的（类似于Java），那么当程序员调用C++的delete命令时（Java没有这个命令），就会调用相应的破坏器。若程序员忘记了，那么永远不会调用破坏器，我们最终得到的将是一个内存“漏洞”，另外还包括对象的其他部分永远不会得到清除。


相反，Java不允许我们创建本地（局部）对象——无论如何都要使用new。但在Java中，没有“delete”命令来释放对象，因为垃圾收集器会帮助我们自动释放存储空间。所以如果站在比较简化的立场，我们可以说正是由于存在垃圾收集机制，所以Java没有破坏器。然而，随着以后学习的深入，就会知道垃圾收集器的存在并不能完全消除对破坏器的需要，或者说不能消除对破坏器代表的那种机制的需要（而且绝对不能直接调用finalize()，所以应尽量避免用它）。若希望执行除释放存储空间之外的其他某种形式的清除工作，仍然必须调用Java中的一个方法。它等价于C++的破坏器，只是没后者方便。


finalize()最有用处的地方之一是观察垃圾收集的过程。下面这个例子向大家展示了垃圾收集所经历的过程，并对前面的陈述进行了总结。

```java
//: Garbage.java
// Demonstration of the garbage
// collector and finalization

class Chair {
  static boolean gcrun = false;
  static boolean f = false;
  static int created = 0;
  static int finalized = 0;
  int i;
  Chair() {
    i = ++created;
    if(created == 47) 
      System.out.println("Created 47");
  }
  protected void finalize() {
    if(!gcrun) {
      gcrun = true;
      System.out.println(
        "Beginning to finalize after " +
        created + " Chairs have been created");
    }
    if(i == 47) {
      System.out.println(
        "Finalizing Chair #47, " +
        "Setting flag to stop Chair creation");
      f = true;
    }
    finalized++;
    if(finalized >= created)
      System.out.println(
        "All " + finalized + " finalized");
  }
}

public class Garbage {
  public static void main(String[] args) {
    if(args.length == 0) {
      System.err.println("Usage: \n" +
        "java Garbage before\n  or:\n" +
        "java Garbage after");
      return;
    }
    while(!Chair.f) {
      new Chair();
      new String("To take up space");
    }
    System.out.println(
      "After all Chairs have been created:\n" +
      "total created = " + Chair.created +
      ", total finalized = " + Chair.finalized);
    if(args[0].equals("before")) {
      System.out.println("gc():");
      System.gc();
      System.out.println("runFinalization():");
      System.runFinalization();
    }
    System.out.println("bye!");
    if(args[0].equals("after"))
      System.runFinalizersOnExit(true);
  }
} ///:~
```


上面这个程序创建了许多Chair对象，而且在垃圾收集器开始运行后的某些时候，程序会停止创建Chair。由于垃圾收集器可能在任何时间运行，所以我们不能准确知道它在何时启动。因此，程序用一个名为gcrun的标记来指出垃圾收集器是否已经开始运行。利用第二个标记f，Chair可告诉main()它应停止对象的生成。这两个标记都是在finalize()内部设置的，它调用于垃圾收集期间。


另两个 static 变量——created以及 finalized——分别用于跟踪已创建的对象数量以及垃圾收集器已进行完收尾工作的对象数量。最后，每个Chair都有它自己的（非static）int i，所以能跟踪了解它具体的编号是多少。编号为47的Chair进行完收尾工作后，标记会设为true，最终结束Chair对象的创建过程。


所有这些都在main()的内部进行——在下面这个循环里：
```java
while(!Chair.f) {
new Chair();
new String("To take up space");
}
```

为强制进行收尾工作，可先调用System.gc()，再调用System.runFinalization()。这样可清除到目前为止没有使用的所有对象。若在这里首先调用runFinalization()，再调用gc()，收尾模块根本不会执行。

> 有些Java虚拟机（JVM）可能已开始表现出不同的行为。为展示 GC 过程及 finalize() 作用，另寻以下示例：
```java
//示例代码--周志明著 Java虚拟机
public class FinalizeEscapeGC {

    public static FinalizeEscapeGC SAVE_HOOK = null;
    public String name;
    public FinalizeEscapeGC(String name) {
        this.name = name;
    }
    public void isAlive() {
        System.out.println("yes, i am still alive");
    }
    @Override
    protected void finalize() throws Throwable {
        super.finalize();
        System.out.println("finalize method executed!");
        System.out.println(this.name);
        FinalizeEscapeGC.SAVE_HOOK = this;
    }
    public static void main(String[] args) throws Throwable {
        SAVE_HOOK = new FinalizeEscapeGC("abc");
        SAVE_HOOK =null;
        System.gc();
        Thread.sleep(500);
        if(SAVE_HOOK != null) {
            SAVE_HOOK.isAlive();
        } else {
            System.out.println("no, i am dead");
        }
        
        SAVE_HOOK =null;
        System.gc();
        Thread.sleep(500);
        if(SAVE_HOOK != null) {
            SAVE_HOOK.isAlive();
        } else {
            System.out.println("no, i am dead");
        }
    }
}
// 第21行，第一次垃圾回收，名为abc的FinalizeEscapeGC实例对象的finalize()方法执行，此时全局静态变量 SAVE_HOOK又重新指向了改对象，使得该对象“复活”，
// 第29行，再次切断引用链，30行，第二次垃圾回收，该对象的finalize()方法不会再执行了。该对象在堆中的空间被释放。

```

### 4.4 成员初始化

一个类的所有基本类型数据成员都会保证获得一个初始值。若被定义成相对于一个方法的“局部”变量，这一保证就通过编译期的出错提示表现出来。

#### 4.4.1 规定初始化

想自己为变量赋予一个初始值，直接的做法是在类内部定义变量的同时也为其赋值。

#### 4.4.2 构建器初始化

可考虑用构建器执行初始化进程。这样便可在编程时获得更大的灵活程度。要注意这样一件事情：不可妨碍自动初始化的进行，它在构建器进入之前就会发生。例如：
```java
class Counter {
int i;
Counter() { i = 7; }
// . . .
```

那么i首先会初始化成零，然后变成 7。对于所有基本类型以及对象句柄，这种情况都是成立的，其中包括在定义时已进行了明确初始化的那些一些。


1. 初始化顺序

在一个类里，初始化的顺序是由变量在类内的定义顺序决定的。即使变量定义大量遍布于方法定义的中间，那些变量仍会在调用任何方法之前得到初始化——甚至在构建器调用之前。例如：
```java
//: OrderOfInitialization.java
// Demonstrates initialization order.

// When the constructor is called, to create a
// Tag object, you'll see a message:
class Tag {
  Tag(int marker) {
    System.out.println("Tag(" + marker + ")");
  }
}

class Card {
  Tag t1 = new Tag(1); // Before constructor
  Card() {
    // Indicate we're in the constructor:
    System.out.println("Card()");
    t3 = new Tag(33); // Re-initialize t3
  }
  Tag t2 = new Tag(2); // After constructor
  void f() {
    System.out.println("f()");
  }
  Tag t3 = new Tag(3); // At end
}

public class OrderOfInitialization {
  public static void main(String[] args) {
    Card t = new Card();
    t.f(); // Shows that construction is done
  }
} ///:~
```


它的输入结果如下：
```java
Tag(1)
Tag(2)
Tag(3)
Card()
Tag(33)
f()
```

2. 静态数据的初始化

若数据是静态的（static），那么同样的事情就会发生；如果它属于一个基本类型（主类型），而且未对其初始化，就会自动获得自己的标准基本类型初始值；如果它是指向一个对象的句柄，那么除非新建一个对象，并将句柄同它连接起来，否则就会得到一个空值（NULL）。

static 值只有一个存储区域。如果它属于一个基本类型（主类型），而且未对其初始化，就会自动获得自己的标准基本类型初始值；如果它是指向一个对象的句柄，那么除非新建一个对象，并将句柄同它连接起来，否则就会得到一个空值（NULL）。
```java
//: StaticInitialization.java
// Specifying initial values in a
// class definition.

class Bowl {
  Bowl(int marker) {
    System.out.println("Bowl(" + marker + ")");
  }
  void f(int marker) {
    System.out.println("f(" + marker + ")");
  }
}

class Table {
  static Bowl b1 = new Bowl(1);
  Table() {
    System.out.println("Table()");
    b2.f(1);
  }
  void f2(int marker) {
    System.out.println("f2(" + marker + ")");
  }
  static Bowl b2 = new Bowl(2);
}

class Cupboard {
  Bowl b3 = new Bowl(3);
  static Bowl b4 = new Bowl(4);
  Cupboard() {
    System.out.println("Cupboard()");
    b4.f(2);
  }
  void f3(int marker) {
    System.out.println("f3(" + marker + ")");
  }
  static Bowl b5 = new Bowl(5);
}

public class StaticInitialization {
  public static void main(String[] args) {
    System.out.println(
      "Creating new Cupboard() in main");
    new Cupboard();
    System.out.println(
      "Creating new Cupboard() in main");
    new Cupboard();
    t2.f2(1);
    t3.f3(1);
  }
  static Table t2 = new Table();
  static Cupboard t3 = new Cupboard();
} ///:~
```


Bowl允许我们检查一个类的创建过程，而Table和Cupboard能创建散布于类定义中的Bowl的static成员。注意在static定义之前，Cupboard先创建了一个非static的Bowl b3。它的输出结果如下：

```java
Bowl(1)
Bowl(2)
Table()
f(1)
Bowl(4)
Bowl(5)
Bowl(3)
Cupboard()
f(2)
Creating new Cupboard() in main
Bowl(3)
Cupboard()
f(2)
Creating new Cupboard() in main
Bowl(3)
Cupboard()
f(2)
f2(1)
f3(1)
```


static 初始化只有在必要的时候才会进行。如果不创建一个 Table 对象，而且永远都不引用 Table.b1或 Table.b2，那么 static Bowl  b1和 b2永远都不会创建。然而，只有在创建了第一个 Table 对象之后（或者发生了第一次 static 访问），它们才会创建。在那以后，static对象不会重新初始化。 初始化的顺序是首先 static（如果它们尚未由前一次对象创建过程初始化），接着是非 static对象。大家可从输出结果中找到相应的证据。


总结一下对象的创建过程。请考虑一个名为Dog的类：

1. 类型为Dog的一个对象首次创建时，或者Dog类的static方法／static字段首次访问时，Java解释器必须找到Dog.class（在事先设好的类路径里搜索）。

2. 找到Dog.class后（它会创建一个Class对象，这将在后面学到），它的所有static初始化模块都会运行。因此，static初始化仅发生一次——在Class对象首次载入的时候。

3. 创建一个new Dog()时，Dog对象的构建进程首先会在内存堆（Heap）里为一个Dog对象分配足够多的存储空间。

4. 这种存储空间会清为零，将Dog中的所有基本类型设为它们的默认值（零用于数字，以及boolean和char的等价设定）。

5. 进行字段定义时发生的所有初始化都会执行。

6. 执行构建器。正如第6章将要讲到的那样，这实际可能要求进行相当多的操作，特别是在涉及继承的时候。


1. 明确进行的静态初始化

Java允许我们将其他static初始化工作划分到类内一个特殊的“static构建从句”（有时也叫作“静态块”）里。它看起来象下面这个样子：

```java
class Spoon {
  static int i;
  static {
    i = 47;
  }
}
  // . . .
```

尽管看起来象个方法，但它实际只是一个static关键字，后面跟随一个方法主体。与其他static初始化一样，这段代码仅执行一次——首次生成那个类的一个对象时，或者首次访问属于那个类的一个static成员时（即便从未生成过那个类的对象）。例如：
```java
//: ExplicitStatic.java
// Explicit static initialization
// with the "static" clause.

class Cup {
  Cup(int marker) {
    System.out.println("Cup(" + marker + ")");
  }
  void f(int marker) {
    System.out.println("f(" + marker + ")");
  }
}

class Cups {
  static Cup c1;
  static Cup c2;
  static {
    c1 = new Cup(1);
    c2 = new Cup(2);
  }
  Cups() {
    System.out.println("Cups()");
  }
}

public class ExplicitStatic {
  public static void main(String[] args) {
    System.out.println("Inside main()");
    Cups.c1.f(99);  // (1)
  }
  static Cups x = new Cups();  // (2)
  static Cups y = new Cups();  // (2) 
} ///:~
```


2. 非静态实例的初始化

针对每个对象的非静态变量的初始化，Java 1.1提供了一种类似的语法格式。下面是一个例子：
```java
//: Mugs.java
// Java 1.1 "Instance Initialization"

class Mug {
  Mug(int marker) {
    System.out.println("Mug(" + marker + ")");
  }
  void f(int marker) {
    System.out.println("f(" + marker + ")");
  }
}

public class Mugs {
  Mug c1;
  Mug c2;
  {
    c1 = new Mug(1);
    c2 = new Mug(2);
    System.out.println("c1 & c2 initialized");
  }
  Mugs() {
    System.out.println("Mugs()");
  }
  public static void main(String[] args) {
    System.out.println("Inside main()");
    Mugs x = new Mugs();
  }
} ///:~
```


它看起来与静态初始化从句极其相似，只是static关键字从里面消失了。为支持对“匿名内部类”的初始化（参见第7章），必须采用这一语法格式。

### 4.5 数组初始化

数组属于引用数据类型，所以在数组使用之前一定要开辟控件（实例化），如果使用了没有开辟空间的数组，则一定会出现 NullPointerException 异常信息。既然数组属于引用数据类型，那么也一定可以发生引用传递。

数组先开辟内存空间，而后再使用索引进行内容的设置，实际上这种做法都叫做动态初始化，而如果希望数组在定义的时候可以同时出现设置内容，那么就可以采用静态初始化完成。
```java
        //动态初始化
		int data[] = null;
		data = new int[3]; //开辟一个长度为3的数组
		int temp[] = null; //声明对象
		data[0] = 10;
		data[1] = 20;
		data[2] = 30;
        //静态初始化
        int data[] = {1, 2, 4, 545, 11, 32, 13131, 4444};
        int data2[] = new int[] {1, 2, 4, 545, 11, 32, 13131, 4444};
```

所有数组都有一个本质成员（无论它们是对象数组还是基本类型数组），可对其进行查询——但不是改变，从而获知数组内包含了多少个元素。这个成员就是length。

基本数据类型的数组元素会自动初始化成“空”值（对于数值，空值就是零；对于char，它是null；而对于boolean，它却是false）。

### 4.6 总结


作为初始化的一种具体操作形式，构建器应使大家明确感受到在语言中进行初始化的重要性。与C++的程序设计一样，判断一个程序效率如何，关键是看是否由于变量的初始化不正确而造成了严重的编程错误（臭虫）。这些形式的错误很难发现，而且类似的问题也适用于不正确的清除或收尾工作。由于构建器使我们能保证正确的初始化和清除（若没有正确的构建器调用，编译器不允许对象创建），所以能获得完全的控制权和安全性。


在C++中，与“构建”相反的“破坏”（Destruction）工作也是相当重要的，因为用new创建的对象必须明确地清除。在Java中，垃圾收集器会自动为所有对象释放内存，所以Java中等价的清除方法并不是经常都需要用到的。如果不需要类似于构建器的行为，Java的垃圾收集器可以极大简化编程工作，而且在内存的管理过程中增加更大的安全性。有些垃圾收集器甚至能清除其他资源，比如图形和文件句柄等。然而，垃圾收集器确实也增加了运行期的开销。但这种开销到底造成了多大的影响却是很难看出的，因为到目前为止，Java解释器的总体运行速度仍然是比较慢的。随着这一情况的改观，我们应该能判断出垃圾收集器的开销是否使Java不适合做一些特定的工作（其中一个问题是垃圾收集器不可预测的性质）。


由于所有对象都肯定能获得正确的构建，所以同这儿讲述的情况相比，构建器实际做的事情还要多得多。特别地，当我们通过“创作”或“继承”生成新类的时候，对构建的保证仍然有效，而且需要一些附加的语法来提供对它的支持。大家将在以后的章节里详细了解创作、继承以及它们对构建器造成的影响。


