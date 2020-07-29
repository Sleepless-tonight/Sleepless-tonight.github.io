## 第16章 设计范式
### 16.1 范式的概念
> 将保持不变的东西身上发生的变化孤立出来
>
> 设计范式：可以说对问题不变的地方抽象总结
> 
> 变化的影响隔离出来

在最开始，可将范式想象成一种特别聪明、能够自我适应的手法，它可以解决特定类型的问题。也就是说，它类似一些需要全面认识某个问题的人。在了解了问题的方方面面以后，最后提出一套最通用、最灵活的解决方案。具体问题或许是以前见到并解决过的。然而，从前的方案也许并不是最完善的，大家会看到它如何在一个范式里具体表达出来。

尽管我们称之为“设计范式”，但它们实际上并不局限于设计领域。思考“范式”时，应脱离传统意义上分析、设计以及实施的思考方式。相反，“范式”是在一个程序里具体表达一套完整的思想，所以它有时可能出现在分析阶段或者高级设计阶段。这一点是非常有趣的，因为范式具有以代码形式直接实现的形式，所以可能不希望它在低级设计或者具体实施以前显露出来（而且事实上，除非真正进入那些阶段，否则一般意识不到自己需要一个范式来解决问题）。

范式的基本概念亦可看成是程序设计的基本概念：添加一层新的抽象！只要我们抽象了某些东西，就相当于隔离了特定的细节。而且这后面最引人注目的动机就是“将保持不变的东西身上发生的变化孤立出来”。这样做的另一个原因是一旦发现程序的某部分由于这样或那样的原因可能发生变化，我们一般都想防止那些改变在代码内部繁衍出其他变化。这样做不仅可以降低代码的维护代价，也更便于我们理解（结果同样是降低开销）。

为设计出功能强大且易于维护的应用项目，通常最困难的部分就是找出我称之为“领头变化”的东西。这意味着需要找出造成系统改变的最重要的东西，或者换一个角度，找出付出代价最高、开销最大的那一部分。一旦发现了“领头变化”，就可以为自己定下一个焦点，围绕它展开自己的设计。

所以设计范式的最终目标就是将代码中变化的内容隔离开。如果从这个角度观察，就会发现本书实际已采用了一些设计范式。举个例子来说，继承可以想象成一种设计范式（类似一个由编译器实现的）。在都拥有同样接口（即保持不变的东西）的对象内部，它允许我们表达行为上的差异（即发生变化的东西）。合成亦可想象成一种范式，因为它允许我们修改——动态或静态——用于实现类的对象，所以也能修改类的运作方式。

在《Design Patterns》一书中，大家还能看到另一种范式：“继承器”（即Iterator，Java 1.0和1.1不负责任地把它叫作Enumeration，即“枚举”；Java1.2的集合则改回了“继承器”的称呼）。当我们在集合里遍历，逐个选择不同的元素时，继承器可将集合的实施细节有效地隐藏起来。利用继承器，可以编写出通用的代码，以便对一个序列里的所有元素采取某种操作，同时不必关心这个序列是如何构建的。这样一来，我们的通用代码即可伴随任何能产生继承器的集合使用。

#### 16.1.1 单子 单例模式 
> 枚举 是实现单例模式的最佳方法。它不仅能避免多线程同步问题，它更简洁，自动支持序列化机制，绝对防止多次实例化。

或许最简单的设计范式就是“单子”（Singleton），它能提供对象的一个（而且只有一个）实例。单子在Java库中得到了应用，但下面这个例子显得更直接一些：
```java
//: SingletonPattern.java
// The Singleton design pattern: you can
// never instantiate more than one.
package c16;

// Since this isn't inherited from a Cloneable
// base class and cloneability isn't added,
// making it final prevents cloneability from
// being added in any derived classes:
final class Singleton {
  private static Singleton s = new Singleton(47);
  private int i;
  private Singleton(int x) { i = x; }
  public static Singleton getHandle() { 
    return s; 
  }
  public int getValue() { return i; }
  public void setValue(int x) { i = x; }
}

public class SingletonPattern {
  public static void main(String[] args) {
    Singleton s = Singleton.getHandle();
    System.out.println(s.getValue());
    Singleton s2 = Singleton.getHandle();
    s2.setValue(9);
    System.out.println(s.getValue());
    try {
      // Can't do this: compile-time error.
      // Singleton s3 = (Singleton)s2.clone();
    } catch(Exception e) {}
  }
} ///:~
```
创建单子的关键就是防止客户程序员采用除由我们提供的之外的任何一种方式来创建一个对象。必须将所有构建器都设为private（私有），而且至少要创建一个构建器，以防止编译器帮我们自动同步一个默认构建器（它会自做聪明地创建成为“友好的”——friendly，而非private）。

此时应决定如何创建自己的对象。在这儿，我们选择了静态创建的方式。但亦可选择等候客户程序员发出一个创建请求，然后根据他们的要求动态创建。不管在哪种情况下，对象都应该保存为“私有”属性。我们通过公用方法提供访问途径。在这里，getHandle()会产生指向Singleton的一个句柄。剩下的接口（getValue()和setValue()）属于普通的类接口。

Java也允许通过克隆（Clone）方式来创建一个对象。在这个例子中，将类设为final可禁止克隆的发生。由于Singleton是从Object直接继承的，所以clone()方法会保持protected（受保护）属性，不能够使用它（强行使用会造成编译期错误）。然而，假如我们是从一个类结构中继承，那个结构已经过载了clone()方法，使其具有public属性，并实现了Cloneable，那么为了禁止克隆，需要过载clone()，并掷出一个CloneNotSupportedException（不支持克隆违例），就象第12章介绍的那样。亦可过载clone()，并简单地返回this。那样做会造成一定的混淆，因为客户程序员可能错误地认为对象尚未克隆，仍然操纵的是原来的那个。

注意我们并不限于只能创建一个对象。亦可利用该技术创建一个有限的对象池。但在那种情况下，可能需要解决池内对象的共享问题。如果不幸真的遇到这个问题，可以自己设计一套方案，实现共享对象的登记与撤消登记。

16.1.2 范式分类

《Design Patterns》一书讨论了23种不同的范式，并依据三个标准分类（所有标准都涉及那些可能发生变化的方面）。这三个标准是：

(1) 创建：对象的创建方式。这通常涉及对象创建细节的隔离，这样便不必依赖具体类型的对象，所以在新添一种对象类型时也不必改动代码。

(2) 结构：设计对象，满足特定的项目限制。这涉及对象与其他对象的连接方式，以保证系统内的改变不会影响到这些连接。

(3) 行为：对程序中特定类型的行动进行操纵的对象。这要求我们将希望采取的操作封装起来，比如解释一种语言、实现一个请求、在一个序列中遍历（就象在继承器中那样）或者实现一种算法。本章提供了“观察器”（Observer）和“访问器”（Visitor）的范式的例子。

《Design Patterns》为所有这23种范式都分别使用了一节，随附的还有大量示例，但大多是用C++编写的，少数用Smalltalk编写（如看过这本书，就知道这实际并不是个大问题，因为很容易即可将基本概念从两种语言翻译到Java里）。现在这本书并不打算重复《Design Patterns》介绍的所有范式，因为那是一本独立的书，大家应该单独阅读。相反，本章只准备给出一些例子，让大家先对范式有个大致的印象，并理解它们的重要性到底在哪里。


### 16.2 观察器范式
观察器（Observer）范式解决的是一个相当普通的问题：由于某些对象的状态发生了改变，所以一组对象都需要更新，那么该如何解决？在Smalltalk的MVC（模型－视图－控制器）的“模型－视图”部分中，或在几乎等价的“文档－视图结构”中，大家可以看到这个问题。现在我们有一些数据（“文档”）以及多个视图，假定为一张图（Plot）和一个文本视图。若改变了数据，两个视图必须知道对自己进行更新，而那正是“观察器”要负责的工作。这是一种十分常见的问题，它的解决方案已包括进标准的java.util库中。

在Java中，有两种类型的对象用来实现观察器范式。其中，Observable类用于跟踪那些当发生一个改变时希望收到通知的所有个体——无论“状态”是否改变。如果有人说“好了，所有人都要检查自己，并可能要进行更新”，那么Observable类会执行这个任务——为列表中的每个“人”都调用notifyObservers()方法。notifyObservers()方法属于基础类Observable的一部分。

在观察器范式中，实际有两个方面可能发生变化：观察对象的数量以及更新的方式。也就是说，观察器范式允许我们同时修改这两个方面，不会干扰围绕在它周围的其他代码。

下面这个例子类似于第14章的ColorBoxes示例。箱子（Boxes）置于一个屏幕网格中，每个都初始化一种随机的颜色。此外，每个箱子都“实现”（implement）了“观察器”（Observer）接口，而且随一个Observable对象进行了注册。若点击一个箱子，其他所有箱子都会收到一个通知，指出一个改变已经发生。这是由于Observable对象会自动调用每个Observer对象的update()方法。在这个方法内，箱子会检查被点中的那个箱子是否与自己紧邻。若答案是肯定的，那么也修改自己的颜色，保持与点中那个箱子的协调。
```java
//: BoxObserver.java
// Demonstration of Observer pattern using
// Java's built-in observer classes.
import java.awt.*;
import java.awt.event.*;
import java.util.*;

// You must inherit a new type of Observable:
class BoxObservable extends Observable {
  public void notifyObservers(Object b) {
    // Otherwise it won't propagate changes:
    setChanged();
    super.notifyObservers(b);
  }
}

public class BoxObserver extends Frame {
  Observable notifier = new BoxObservable();
  public BoxObserver(int grid) {
    setTitle("Demonstrates Observer pattern");
    setLayout(new GridLayout(grid, grid));
    for(int x = 0; x < grid; x++)
      for(int y = 0; y < grid; y++)
        add(new OCBox(x, y, notifier));
  }   
  public static void main(String[] args) {
    int grid = 8;
    if(args.length > 0)
      grid = Integer.parseInt(args[0]);
    Frame f = new BoxObserver(grid);
    f.setSize(500, 400);
    f.setVisible(true);
    f.addWindowListener(
      new WindowAdapter() {
        public void windowClosing(WindowEvent e) {
          System.exit(0);
        }
      });
  }
}

class OCBox extends Canvas implements Observer {
  Observable notifier;
  int x, y; // Locations in grid
  Color cColor = newColor();
  static final Color[] colors = { 
    Color.black, Color.blue, Color.cyan, 
    Color.darkGray, Color.gray, Color.green,
    Color.lightGray, Color.magenta, 
    Color.orange, Color.pink, Color.red, 
    Color.white, Color.yellow 
  };
  static final Color newColor() {
    return colors[
      (int)(Math.random() * colors.length)
    ];
  }
  OCBox(int x, int y, Observable notifier) {
    this.x = x;
    this.y = y;
    notifier.addObserver(this);
    this.notifier = notifier;
    addMouseListener(new ML());
  }
  public void paint(Graphics  g) {
    g.setColor(cColor);
    Dimension s = getSize();
    g.fillRect(0, 0, s.width, s.height);
  }
  class ML extends MouseAdapter {
    public void mousePressed(MouseEvent e) {
      notifier.notifyObservers(OCBox.this);
    }
  }
  public void update(Observable o, Object arg) {
    OCBox clicked = (OCBox)arg;
    if(nextTo(clicked)) {
      cColor = clicked.cColor;
      repaint();
    }
  }
  private final boolean nextTo(OCBox b) {
    return Math.abs(x - b.x) <= 1 && 
           Math.abs(y - b.y) <= 1;
  }
} ///:~
```
如果是首次查阅Observable的联机帮助文档，可能会多少感到有些困惑，因为它似乎表明可以用一个原始的Observable对象来管理更新。但这种说法是不成立的；大家可自己试试——在BoxObserver中，创建一个Observable对象，替换BoxObservable对象，看看会有什么事情发生。事实上，什么事情也不会发生。为真正产生效果，必须从Observable继承，并在衍生类代码的某个地方调用setChanged()。这个方法需要设置“changed”（已改变）标志，它意味着当我们调用notifyObservers()的时候，所有观察器事实上都会收到通知。在上面的例子中，setChanged()只是简单地在notifyObservers()中调用，大家可依据符合实际情况的任何标准决定何时调用setChanged()。

BoxObserver包含了单个Observable对象，名为notifier。每次创建一个OCBox对象时，它都会同notifier联系到一起。在OCBox中，只要点击鼠标，就会发出对notifyObservers()方法的调用，并将被点中的那个对象作为一个参数传递进去，使收到消息（用它们的update()方法）的所有箱子都能知道谁被点中了，并据此判断自己是否也要变动。通过notifyObservers()和update()中的代码的结合，我们可以应付一些非常复杂的局面。

在notifyObservers()方法中，表面上似乎观察器收到通知的方式必须在编译期间固定下来。然而，只要稍微仔细研究一下上面的代码，就会发现BoxObserver或OCBox中唯一需要留意是否使用BoxObservable的地方就是创建Observable对象的时候——从那时开始，所有东西都会使用基本的Observable接口。这意味着以后若想更改通知方式，可以继承其他Observable类，并在运行期间交换它们。

---
1.1 观察者模式是oo设计中经常用到的模式之一，大家在解决实际需求时，观察者模式往往都会用到，而javase中已经提供了Observer接口和Observable类让你简单快速的实现观察者模式，因此有必要去了解Observer和Observable；

2.观察者模式概述
2.1 角色：被观察对象，观察者

2.2 关系： 
1）.被观察对象：观察者 = 1：n 
2）.被观察对象状态发生变化，会通知所有观察者，观察者将做出相应的反应

2.3 详细说明：参见【设计模式】观察者模式

3.源码分析
3.1 Observer接口  观察者
Observer为java.util包下的一个接口，源码如下：

public interface Observer {
    void update(Observable o, Object arg);
}
所有 观察者 需要在 被观察对象 发生变化时做出相应的反应，所做的具体反应就是实现Observer接口的update方法，实现update方法时你可以用到两个参数，一个参数的类型是Observable，另一个参数的类型是Object。当然如果完全由自己去实现一个观察者模式的方案，自己去设计Observer接口时，可能不会设计这两个参数。那为什么jdk设计该接口时规定接口中有这两个参数呢？那就是通用性。想想整个观察者模式有哪些类之间需要交互？使用该模式时牵扯三个类，一个是观察者，一个是被观察对象，一个是调用者(调用者可以是被观察对象本身调用，更多情况是一个具体的业务类)，当前接口代表观察者，要与被观察对象交互，因此update方法需要持有被观察对象(Observable)的引用，第一参数产生了；如何与调用者通信，则是添加了类型为Object的参数（该参数是调用者调用Observable实例的notifyObservers(Object obj)方法时传入的，当然也可以不传）；第一个参数可以说是为观察者提供了一种拉取数据的方式，update中的业务可以根据所需去拉去自己想要的被观察对象的信息(一般被观察对象中提供getter)，第二个参数则是由调用者调用notifyObservers(Object obj)将一些信息推过来。通过这两个参数，观察者，被观察对象，调用者(调用通知刷新方法的可能是被观察对象本身，此时只存在观察者与被观察者两者)三者就联系起来了。

3.2 Observable 类 被观察对象

public class Observable {
    private boolean changed = false;
    private Vector<Observer> obs;
    public Observable(){};
    protected synchronized void setChanged(){};
    protected synchronized void clearChanged(){};
    public synchronized void addObserver(Observer o){};
    public synchronized void deleteObserver(Observer o) {};
    public synchronized void deleteObservers(){};
    public synchronized boolean hasChanged(){};
    public synchronized int countObservers(){};
    public void notifyObservers(){};
    public void notifyObservers(Object arg){};
}
先说成员变量： 
1）该类中含有一个boolean型的变量changed，代表是否发生改变了，Observable类只提供这个boolean值来表明是否发生变化，而不定义什么叫变化，因为每个业务中对变化的具体定义不一样，因此子类自己来判断是否变化；该变量既提供了一种抽象(变与不变)，同时提供了一种观察者更新状态的可延迟加载，通过后面的notifyObservers方法分析可知观察者是否会调用update方法，依赖于changed变量，因此即使被观察者在逻辑上发生改变了，只要不调用setChanged，update是不会被调用的。如果我们在某些业务场景不需要频繁触发update，则可以适时调用setChanged方法来延迟刷新。
2）该类含有一个集合类Vector，该类泛型为Observer，主要用来存放所有观察自己的对象的引用，以便在更新时可以挨个遍历集合中的观察者，逐个调用update方法 
说明： 
1.8的jdk源码为Vector，有版本的源码是ArrayList的集合实现； 
Vector这个类和ArrayList的继承体系是一致，主要有两点不同，一是Vector是线程安全的，ArrayList不是线程安全的，Vector的操作依靠在方法上加了同步关键字来保证线程安全，与此同时ArrayList的性能是要好于Vector的；二是Vector和ArrayList扩容阀值不太一样，ArrayList较Vector更节省空间；
再来说说方法： 
1）操作changed变量的方法为setChanged()，clearChanged()，hasChanged()；见名知意，第一个设置变化状态，第二清除变化状态，这两个的访问权限都是protected，表明这两个方法由子类去调用，由子类来告诉什么时候被观察者发生变化了，什么时候变化消失，而hasChanged()方法的访问权限是公有的，调用者可以使用该方法。三个方法都有同步关键字保证变量的读写操作线程安全。

2）操作Vector类型变量obs的方法为addObserver(Observer o)， deleteObserver(Observer o)， deleteObservers()，countObservers()，这四个方法分别实现了动态添加观察者，删除观察者，删除所有观察者，获取观察者数量。四个方法的访问权限都是公有的，这是提供给调用者的方法，让调用者来实时动态的控制哪些观察者来观察该被观察对象。

3）操作Vector型变量obs的四个方法都加有同步关键字，但是我们刚才分析成员属性Vector obs这个变量时，说Vector类型为线程安全的，而上述四个方法为什么还要加同步关键字呢，这是怎么回事？据我推测应该是程序员重构遗留问题吧，因为前面我说道，有历史版本的源码是使用的ArrayList来持有Observer的引用，而ArrayList不是线程安全的，所以上述四个操作结合的方法需要加上同步关键字来保证线程安全，而后来换成线程安全的Vector了，但这四个操作集合的方法依旧保留了同步关键字。

4）两个对外的方法notifyObservers()，notifyObservers(Object arg)，该方法由调用者来操作，用来通知所有的观察者需要做更新操作了。

---

### 16.3 模拟垃圾回收站
这个问题的本质是若将垃圾丢进单个垃圾筒，事实上是未经分类的。但在以后，某些特殊的信息必须恢复，以便对垃圾正确地归类。在最开始的解决方案中，RTTI扮演了关键的角色（详见第11章）。

这并不是一种普通的设计，因为它增加了一个新的限制。正是这个限制使问题变得非常有趣——它更象我们在工作中碰到的那些非常麻烦的问题。这个额外的限制是：垃圾抵达垃圾回收站时，它们全都是混合在一起的。程序必须为那些垃圾的分类定出一个模型。这正是RTTI发挥作用的地方：我们有大量不知名的垃圾，程序将正确判断出它们所属的类型。
```java
//: RecycleA.java 
// Recycling with RTTI
package c16.recyclea;
import java.util.*;
import java.io.*;

abstract class Trash {
  private double weight;
  Trash(double wt) { weight = wt; }
  abstract double value();
  double weight() { return weight; }
  // Sums the value of Trash in a bin:
  static void sumValue(Vector bin) {
    Enumeration e = bin.elements();
    double val = 0.0f;
    while(e.hasMoreElements()) {
      // One kind of RTTI:
      // A dynamically-checked cast
      Trash t = (Trash)e.nextElement();
      // Polymorphism in action:
      val += t.weight() * t.value();
      System.out.println(
        "weight of " +
        // Using RTTI to get type
        // information about the class:
        t.getClass().getName() +
        " = " + t.weight());
    }
    System.out.println("Total value = " + val);
  }
}

class Aluminum extends Trash {
  static double val  = 1.67f;
  Aluminum(double wt) { super(wt); }
  double value() { return val; }
  static void value(double newval) {
    val = newval;
  }
}

class Paper extends Trash {
  static double val = 0.10f;
  Paper(double wt) { super(wt); }
  double value() { return val; }
  static void value(double newval) {
    val = newval;
  }
}

class Glass extends Trash {
  static double val = 0.23f;
  Glass(double wt) { super(wt); }
  double value() { return val; }
  static void value(double newval) {
    val = newval;
  }
}

public class RecycleA {
  public static void main(String[] args) {
    Vector bin = new Vector();
    // Fill up the Trash bin:
    for(int i = 0; i < 30; i++)
      switch((int)(Math.random() * 3)) {
        case 0 :
          bin.addElement(new
            Aluminum(Math.random() * 100));
          break;
        case 1 :
          bin.addElement(new
            Paper(Math.random() * 100));
          break;
        case 2 :
          bin.addElement(new
            Glass(Math.random() * 100));
      }
    Vector 
      glassBin = new Vector(),
      paperBin = new Vector(),
      alBin = new Vector();
    Enumeration sorter = bin.elements();
    // Sort the Trash:
    while(sorter.hasMoreElements()) {
      Object t = sorter.nextElement();
      // RTTI to show class membership:
      if(t instanceof Aluminum)
        alBin.addElement(t);
      if(t instanceof Paper)
        paperBin.addElement(t);
      if(t instanceof Glass)
        glassBin.addElement(t);
    }
    Trash.sumValue(alBin);
    Trash.sumValue(paperBin);
    Trash.sumValue(glassBin);
    Trash.sumValue(bin);
  }
} ///:~
```
这意味着在本书采用的源码目录中，这个文件会被置入从c16（代表第16章的程序）分支出来的recyclea子目录中。第17章的解包工具会负责将其置入正确的子目录。之所以要这样做，是因为本章会多次改写这个特定的例子；它的每个版本都会置入自己的“包”（package）内，避免类名的冲突。

其中创建了几个Vector对象，用于容纳Trash句柄。当然，Vector实际容纳的是Object（对象），所以它们最终能够容纳任何东西。之所以要它们容纳Trash（或者从Trash衍生出来的其他东西），唯一的理由是我们需要谨慎地避免放入除Trash以外的其他任何东西。如果真的把某些“错误”的东西置入Vector，那么不会在编译期得到出错或警告提示——只能通过运行期的一个违例知道自己已经犯了错误。

Trash句柄加入后，它们会丢失自己的特定标识信息，只会成为简单的Object句柄（上溯造型）。然而，由于存在多形性的因素，所以在我们通过Enumeration sorter调用动态绑定方法时，一旦结果Object已经造型回Trash，仍然会发生正确的行为。sumValue()也用一个Enumeration对Vector中的每个对象进行操作。

表面上持，先把Trash的类型上溯造型到一个集合容纳基础类型的句柄，再回过头重新下溯造型，这似乎是一种非常愚蠢的做法。为什么不只是一开始就将垃圾置入适当的容器里呢？（事实上，这正是拨开“回收”一团迷雾的关键）。在这个程序中，我们很容易就可以换成这种做法，但在某些情况下，系统的结构及灵活性都能从下溯造型中得到极大的好处。

该程序已满足了设计的初衷：它能够正常工作！只要这是个一次性的方案，就会显得非常出色。但是，真正有用的程序应该能够在任 何时候解决问题。所以必须问自己这样一个问题：“如果情况发生了变化，它还能工作吗？”举个例子来说，厚纸板现在是一种非常有价值的可回收物品，那么如何把它集成到系统中呢（特别是程序很大很复杂的时候）？由于前面在switch语句中的类型检查编码可能散布于整个程序，所以每次加入一种新类型时，都必须找到所有那些编码。若不慎遗漏一个，编译器除了指出存在一个错误之外，不能再提供任何有价值的帮助。

RTTI在这里使用不当的关键是“每种类型都进行了测试”。如果由于类型的子集需要特殊的对待，所以只寻找那个子集，那么情况就会变得好一些。但假如在一个switch语句中查找每一种类型，那么很可能错过一个重点，使最终的代码很难维护。在下一节中，大家会学习如何逐步对这个程序进行改进，使其显得越来越灵活。这是在程序设计中一种非常有意义的例子。

### 16.4 改进设计
《Design Patterns》书内所有方案的组织都围绕“程序进化时会发生什么变化”这个问题展开。对于任何设计来说，这都可能是最重要的一个问题。若根据对这个问题的回答来构造自己的系统，就可以得到两个方面的结果：系统不仅更易维护（而且更廉价），而且能产生一些能够重复使用的对象，进而使其他相关系统的构造也变得更廉价。这正是面向对象程序设计的优势所在，但这一优势并不是自动体现出来的。它要求对我们对需要解决的问题有全面而且深入的理解。在这一节中，我们准备在系统的逐步改进过程中向大家展示如何做到这一点。

就目前这个回收系统来说，对“什么会变化”这个问题的回答是非常普通的：更多的类型会加入系统。因此，设计的目标就是尽可能简化这种类型的添加。在回收程序中，我们准备把涉及特定类型信息的所有地方都封装起来。这样一来（如果没有别的原因），所有变化对那些封装来说都是在本地进行的。这种处理方式也使代码剩余的部分显得特别清爽。

#### 16.4.1 “制作更多的对象”

这样便引出了面向对象程序设计时一条常规的准则，我最早是在Grady Booch那里听说的：“若设计过于复杂，就制作更多的对象”。尽管听起来有些暧昧，且简单得可笑，但这确实是我知道的最有用一条准则（大家以后会注意到“制作更多的对象”经常等同于“添加另一个层次的迂回”）。一般情况下，如果发现一个地方充斥着大量繁复的代码，就需要考虑什么类能使它显得清爽一些。用这种方式整理系统，往往会得到一个更好的结构，也使程序更加灵活。

首先考虑Trash对象首次创建的地方，这是main()里的一个switch语句：
```
for(int i = 0; i < 30; i++)
      switch((int)(Math.random() * 3)) {
        case 0 :
          bin.addElement(new
            Aluminum(Math.random() * 100));
          break;
        case 1 :
          bin.addElement(new
            Paper(Math.random() * 100));
          break;
        case 2 :
          bin.addElement(new
            Glass(Math.random() * 100));
      }
```
这些代码显然“过于复杂”，也是新类型加入时必须改动代码的场所之一。如果经常都要加入新类型，那么更好的方案就是建立一个独立的方法，用它获取所有必需的信息，并创建一个句柄，指向正确类型的一个对象——已经上溯造型到一个Trash对象。在《Design Patterns》中，它被粗略地称呼为“创建范式”。要在这里应用的特殊范式是Factory方法的一种变体。在这里，Factory方法属于Trash的一名static（静态）成员。但更常见的一种情况是：它属于衍生类中一个被过载的方法。 Factory方法的基本原理是我们将创建对象所需的基本信息传递给它，然后返回并等候句柄（已经上溯造型至基础类型）作为返回值出现。从这时开始，就可以按多形性的方式对待对象了。因此，我们根本没必要知道所创建对象的准确类型是什么。事实上，Factory方法会把自己隐藏起来，我们是看不见它的。这样做可防止不慎的误用。如果想在没有多形性的前提下使用对象，必须明确地使用RTTI和指定造型。

但仍然存在一个小问题，特别是在基础类中使用更复杂的方法（不是在这里展示的那种），且在衍生类里过载（覆盖）了它的前提下。如果在衍生类里请求的信息要求更多或者不同的参数，那么该怎么办呢？“创建更多的对象”解决了这个问题。为实现Factory方法，Trash类使用了一个新的方法，名为factory。为了将创建数据隐藏起来，我们用一个名为Info的新类包含factory方法创建适当的Trash对象时需要的全部信息。下面是Info一种简单的实现方式：
```
class Info {
  int type;
  // Must change this to add another type:
  static final int MAX_NUM = 4;
  double data;
  Info(int typeNum, double dat) {
    type = typeNum % MAX_NUM;
    data = dat;
  }
}

```
Info对象唯一的任务就是容纳用于factory()方法的信息。现在，假如出现了一种特殊情况，factory()需要更多或者不同的信息来新建一种类型的Trash对象，那么再也不需要改动factory()了。通过添加新的数据和构建器，我们可以修改Info类，或者采用子类处理更典型的面向对象形式。

用于这个简单示例的factory()方法如下：
```
  static Trash factory(Info i) {
    switch(i.type) {
      default: // To quiet the compiler
      case 0:
        return new Aluminum(i.data);
      case 1:
        return new Paper(i.data);
      case 2:
        return new Glass(i.data);
      // Two lines here:
      case 3: 
        return new Cardboard(i.data);
    }
  }
```
在这里，对象的准确类型很容易即可判断出来。但我们可以设想一些更复杂的情况，factory()将采用一种复杂的算法。无论如何，现在的关键是它已隐藏到某个地方，而且我们在添加新类型时知道去那个地方。

新对象在main()中的创建现在变得非常简单和清爽：
```
for(int i = 0; i < 30; i++)
      bin.addElement(
        Trash.factory(
          new Info(
            (int)(Math.random() * Info.MAX_NUM),
            Math.random() * 100)));
```
我们在这里创建了一个Info对象，用于将数据传入factory()；后者在内存堆中创建某种Trash对象，并返回添加到Vector bin内的句柄。当然，如果改变了参数的数量及类型，仍然需要修改这个语句。但假如Info对象的创建是自动进行的，也可以避免那个麻烦。例如，可将参数的一个Vector传递到Info对象的构建器中（或直接传入一个factory()调用）。这要求在运行期间对参数（自变量）进行分析与检查，但确实提供了非常高的灵活程度。

大家从这个代码可看出Factory要负责解决的“领头变化”问题：如果向系统添加了新类型（发生了变化），唯一需要修改的代码在Factory内部，所以Factory将那种变化的影响隔离出来了。

#### 16.4.2 用于原型创建的一个范式

上述设计方案的一个问题是仍然需要一个中心场所，必须在那里知道所有类型的对象：在factory()方法内部。如果经常都要向系统添加新类型，factory()方法为每种新类型都要修改一遍。若确实对这个问题感到苦恼，可试试再深入一步，将与类型有关的所有信息——包括它的创建过程——都移入代表那种类型的类内部。这样一来，每次新添一种类型的时候，需要做的唯一事情就是从一个类继承。

为将涉及类型创建的信息移入特定类型的Trash里，必须使用“原型”（prototype）范式（来自《Design Patterns》那本书）。这里最基本的想法是我们有一个主控对象序列，为自己感兴趣的每种类型都制作一个。这个序列中的对象只能用于新对象的创建，采用的操作类似内建到Java根类Object内部的clone()机制。在这种情况下，我们将克隆方法命名为tClone()。准备创建一个新对象时，要事先收集好某种形式的信息，用它建立我们希望的对象类型。然后在主控序列中遍历，将手上的信息与主控序列中原型对象内任何适当的信息作对比。若找到一个符合自己需要的，就克隆它。

采用这种方案，我们不必用硬编码的方式植入任何创建信息。每个对象都知道如何揭示出适当的信息，以及如何对自身进行克隆。所以一种新类型加入系统的时候，factory()方法不需要任何改变。

为解决原型的创建问题，一个方法是添加大量方法，用它们支持新对象的创建。但在Java 1.1中，如果拥有指向Class对象的一个句柄，那么它已经提供了对创建新对象的支持。利用Java 1.1的“反射”（已在第11章介绍）技术，即便我们只有指向Class对象的一个句柄，亦可正常地调用一个构建器。这对原型问题的解决无疑是个完美的方案。

原型列表将由指向所有想创建的Class对象的一个句柄列表间接地表示。除此之外，假如原型处理失败，则factory()方法会认为由于一个特定的Class对象不在列表中，所以会尝试装载它。通过以这种方式动态装载原型，Trash类根本不需要知道自己要操纵的是什么类型。因此，在我们添加新类型时不需要作出任何形式的修改。于是，我们可在本章剩余的部分方便地重复利用它。
```java
//: Trash.java
// Base class for Trash recycling examples
package c16.trash;
import java.util.*;
import java.lang.reflect.*;

public abstract class Trash {
  private double weight;
  Trash(double wt) { weight = wt; }
  Trash() {}
  public abstract double value();
  public double weight() { return weight; }
  // Sums the value of Trash in a bin:
  public static void sumValue(Vector bin) {
    Enumeration e = bin.elements();
    double val = 0.0f;
    while(e.hasMoreElements()) {
      // One kind of RTTI:
      // A dynamically-checked cast
      Trash t = (Trash)e.nextElement();
      val += t.weight() * t.value();
      System.out.println(
        "weight of " +
        // Using RTTI to get type
        // information about the class:
        t.getClass().getName() +
        " = " + t.weight());
    }
    System.out.println("Total value = " + val);
  }
  // Remainder of class provides support for
  // prototyping:
  public static class PrototypeNotFoundException
      extends Exception {}
  public static class CannotCreateTrashException
      extends Exception {}
  private static Vector trashTypes = 
    new Vector();
  public static Trash factory(Info info) 
      throws PrototypeNotFoundException, 
      CannotCreateTrashException {
    for(int i = 0; i < trashTypes.size(); i++) {
      // Somehow determine the new type
      // to create, and create one:
      Class tc = 
        (Class)trashTypes.elementAt(i);
      if (tc.getName().indexOf(info.id) != -1) {
        try {
          // Get the dynamic constructor method
          // that takes a double argument:
          // 通过类对象的getConstructor()或getDeclaredConstructor()方法获得构造器（Constructor）对象并调用其newInstance()方法创建对象，适用于无参和有参构造方法。
          Constructor ctor =
            tc.getConstructor(
              new Class[] {double.class});
          // Call the constructor to create a 
          // new object:
          return (Trash)ctor.newInstance(
            new Object[]{new Double(info.data)});
        } catch(Exception ex) {
          ex.printStackTrace();
          throw new CannotCreateTrashException();
        }
      }
    }
    // Class was not in the list. Try to load it,
    // but it must be in your class path!
    try {
      System.out.println("Loading " + info.id);
      trashTypes.addElement(
        Class.forName(info.id));
    } catch(Exception e) {
      e.printStackTrace();
      throw new PrototypeNotFoundException();
    }
    // Loaded successfully. Recursive call 
    // should work this time:
    return factory(info);
  }
  public static class Info {
    public String id;
    public double data;
    public Info(String name, double data) {
      id = name;
      this.data = data;
    }
  }
} ///:~
```
基本Trash类和sumValue()还是象往常一样。这个类剩下的部分支持原型范式。大家首先会看到两个内部类（被设为static属性，使其成为只为代码组织目的而存在的内部类），它们描述了可能出现的违例。在它后面跟随的是一个Vector trashTypes，用于容纳Class句柄。

在Trash.factory()中，Info对象id（Info类的另一个版本，与前面讨论的不同）内部的String包含了要创建的那种Trash的类型名称。这个String会与列表中的Class名比较。若存在相符的，那便是要创建的对象。当然，还有很多方法可以决定我们想创建的对象。之所以要采用这种方法，是因为从一个文件读入的信息可以转换成对象。

发现自己要创建的Trash（垃圾）种类后，接下来就轮到“反射”方法大显身手了。getConstructor()方法需要取得自己的参数——由Class句柄构成的一个数组。这个数组代表着不同的参数，并按它们正确的顺序排列，以便我们查找的构建器使用。在这儿，该数组是用Java 1.1的数组创建语法动态创建的：

```
new Class[] {double.class}
```
这个代码假定所有Trash类型都有一个需要double数值的构建器（注意double.class与Double.class是不同的）。若考虑一种更灵活的方案，亦可调用getConstructors()，令其返回可用构建器的一个数组。 从getConstructors()返回的是指向一个Constructor对象的句柄（该对象是java.lang.reflect的一部分）。我们用方法newInstance()动态地调用构建器。该方法需要获取包含了实际参数的一个Object数组。这个数组同样是按Java 1.1的语法创建的：
```
new Object[] {new Double(info.data)}
```
在这种情况下，double必须置入一个封装（容器）类的内部，使其真正成为这个对象数组的一部分。通过调用newInstance()，会提取出double，但大家可能会觉得稍微有些迷惑——参数既可能是double，也可能是Double，但在调用的时候必须用Double传递。幸运的是，这个问题只存在于基本数据类型中间。

理解了具体的过程后，再来创建一个新对象，并且只为它提供一个Class句柄，事情就变得非常简单了。就目前的情况来说，内部循环中的return永远不会执行，我们在终点就会退出。在这儿，程序动态装载Class对象，并把它加入trashTypes（垃圾类型）列表，从而试图纠正这个问题。若仍然找不到真正有问题的地方，同时装载又是成功的，那么就重复调用factory方法，重新试一遍。

正如大家会看到的那样，这种设计方案最大的优点就是不需要改动代码。无论在什么情况下，它都能正常地使用（假定所有Trash子类都包含了一个构建器，用以获取单个double参数）。

- Trash子类

为了与原型机制相适应，对Trash每个新子类唯一的要求就是在其中包含了一个构建器，指示它获取一个double参数。Java 1.1的“反射”机制可负责剩下的所有工作。 下面是不同类型的Trash，每种类型都有它们自己的文件里，但都属于Trash包的一部分（同样地，为了方便在本章内重复使用）：
```java
//: Aluminum.java 
// The Aluminum class with prototyping
package c16.trash;

public class Aluminum extends Trash {
  private static double val = 1.67f;
  public Aluminum(double wt) { super(wt); }
  public double value() { return val; }
  public static void value(double newVal) {
    val = newVal;
  }
} ///:~
```
下面是一种新的Trash类型：
```java
//: Cardboard.java 
// The Cardboard class with prototyping
package c16.trash;

public class Cardboard extends Trash {
  private static double val = 0.23f;
  public Cardboard(double wt) { super(wt); }
  public double value() { return val; }
  public static void value(double newVal) {
    val = newVal;
  }
} ///:~
```
可以看出，除构建器以外，这些类根本没有什么特别的地方。

- 从外部文件中解析出Trash

与Trash对象有关的信息将从一个外部文件中读取。针对Trash的每个方面，文件内列出了所有必要的信息——每行都代表一个方面，采用“垃圾（废品）名称:值”的固定格式。例如：


```
c16.Trash.Glass:54
c16.Trash.Paper:22
c16.Trash.Paper:11
c16.Trash.Glass:17
c16.Trash.Aluminum:89
c16.Trash.Paper:88
c16.Trash.Aluminum:76
c16.Trash.Cardboard:96
c16.Trash.Aluminum:25
c16.Trash.Aluminum:34
c16.Trash.Glass:11
c16.Trash.Glass:68
c16.Trash.Glass:43
c16.Trash.Aluminum:27
c16.Trash.Cardboard:44
c16.Trash.Aluminum:18
c16.Trash.Paper:91
c16.Trash.Glass:63
c16.Trash.Glass:50
c16.Trash.Glass:80
c16.Trash.Aluminum:81
c16.Trash.Cardboard:12
c16.Trash.Glass:12
c16.Trash.Glass:54
c16.Trash.Aluminum:36
c16.Trash.Aluminum:93
c16.Trash.Glass:93
c16.Trash.Paper:80
c16.Trash.Glass:36
c16.Trash.Glass:12
c16.Trash.Glass:60
c16.Trash.Paper:66
c16.Trash.Aluminum:36
c16.Trash.Cardboard:22
```
注意在给定类名的时候，类路径必须包含在内，否则就找不到类。

为解析它，每一行内容都会读入，并用字串方法indexOf()来建立“:”的一个索引。首先用字串方法substring()取出垃圾的类型名称，接着用一个静态方法Double.valueOf()取得相应的值，并转换成一个double值。trim()方法则用于删除字串两头的多余空格。

Trash解析器置入单独的文件中，因为本章将不断地用到它。如下所示：
```java
//: ParseTrash.java 
// Open a file and parse its contents into
// Trash objects, placing each into a Vector
package c16.trash;
import java.util.*;
import java.io.*;

public class ParseTrash {
  public static void 
  fillBin(String filename, Fillable bin) {
    try {
      BufferedReader data =
        new BufferedReader(
          new FileReader(filename));
      String buf;
      while((buf = data.readLine())!= null) {
        String type = buf.substring(0, 
          buf.indexOf(':')).trim();
        double weight = Double.valueOf(
          buf.substring(buf.indexOf(':') + 1)
          .trim()).doubleValue();
        bin.addTrash(
          Trash.factory(
            new Trash.Info(type, weight)));
      }
      data.close();
    } catch(IOException e) {
      e.printStackTrace();
    } catch(Exception e) {
      e.printStackTrace();
    }
  }
  // Special case to handle Vector:
  public static void 
  fillBin(String filename, Vector bin) {
    fillBin(filename, new FillableVector(bin));
  }
} ///:~
```
在RecycleA.java中，我们用一个Vector容纳Trash对象。然而，亦可考虑采用其他集合类型。为做到这一点，fillBin()的第一个版本将获取指向一个Fillable的句柄。后者是一个接口，用于支持一个名为addTrash()的方法：
```java
//: Fillable.java 
// Any object that can be filled with Trash
package c16.trash;

public interface Fillable {
  void addTrash(Trash t);
} ///:~
```
支持该接口的所有东西都能伴随fillBin使用。当然，Vector并未实现Fillable，所以它不能工作。由于Vector将在大多数例子中应用，所以最好的做法是添加另一个过载的fillBin()方法，令其以一个Vector作为参数。利用一个适配器（Adapter）类，这个Vector可作为一个Fillable对象使用：
```java
//: FillableVector.java 
// Adapter that makes a Vector Fillable
package c16.trash;
import java.util.*;

public class FillableVector implements Fillable {
  private Vector v;
  public FillableVector(Vector vv) { v = vv; }
  public void addTrash(Trash t) {
    v.addElement(t);
  }
} ///:~
```
可以看到，这个类唯一的任务就是负责将Fillable的addTrash()同Vector的addElement()方法连接起来。利用这个类，已过载的fillBin()方法可在ParseTrash.java中伴随一个Vector使用：
```
  public static void 
  fillBin(String filename, Vector bin) {
    fillBin(filename, new FillableVector(bin));
  }
```
这种方案适用于任何频繁用到的集合类。除此以外，集合类还可提供它自己的适配器类，并实现Fillable（稍后即可看到，在DynaTrash.java中）。

- 原型机制的重复应用
现在，大家可以看到采用原型技术的、修订过的RecycleA.java版本了：
```java
//: RecycleAP.java 
// Recycling with RTTI and Prototypes
package c16.recycleap;
import c16.trash.*;
import java.util.*;

public class RecycleAP {
  public static void main(String[] args) {
    Vector bin = new Vector();
    // Fill up the Trash bin:
    ParseTrash.fillBin("Trash.dat", bin);
    Vector 
      glassBin = new Vector(),
      paperBin = new Vector(),
      alBin = new Vector();
    Enumeration sorter = bin.elements();
    // Sort the Trash:
    while(sorter.hasMoreElements()) {
      Object t = sorter.nextElement();
      // RTTI to show class membership:
      if(t instanceof Aluminum)
        alBin.addElement(t);
      if(t instanceof Paper)
        paperBin.addElement(t);
      if(t instanceof Glass)
        glassBin.addElement(t);
    }
    Trash.sumValue(alBin);
    Trash.sumValue(paperBin);
    Trash.sumValue(glassBin);
    Trash.sumValue(bin);
  }
} ///:~
```
所有Trash对象——以及ParseTrash及支撑类——现在都成为名为c16.trash的一个包的一部分，所以它们可以简单地导入。 无论打开包含了Trash描述信息的数据文件，还是对那个文件进行解析，所有涉及到的操作均已封装到static（静态）方法ParseTrash.fillBin()里。所以它现在已经不是我们设计过程中要注意的一个重点。在本章剩余的部分，大家经常都会看到无论添加的是什么类型的新类，ParseTrash.fillBin()都会持续工作，不会发生改变，这无疑是一种优良的设计方案。

提到对象的创建，这一方案确实已将新类型加入系统所需的变动严格地“本地化”了。但在使用RTTI的过程中，却存在着一个严重的问题，这里已明确地显露出来。程序表面上工作得很好，但却永远侦测到不能“硬纸板”（Cardboard）这种新的废品类型——即使列表里确实有一个硬纸板类型！之所以会出现这种情况，完全是由于使用了RTTI的缘故。RTTI只会查找那些我们告诉它查找的东西。RTTI在这里错误的用法是“系统中的每种类型”都进行了测试，而不是仅测试一种类型或者一个类型子集。正如大家以后会看到的那样，在测试每一种类型时可换用其他方式来运用多形性特征。但假如以这种形式过多地使用RTTI，而且又在自己的系统里添加了一种新类型，很容易就会忘记在程序里作出适当的改动，从而埋下以后难以发现的Bug。因此，在这种情况下避免使用RTTI是很有必要的，这并不仅仅是为了表面好看——也是为了产生更易维护的代码。

### 16.5 抽象的应用
走到这一步，接下来该考虑一下设计方案剩下的部分了——在哪里使用类？既然归类到垃圾箱的办法非常不雅且过于暴露，为什么不隔离那个过程，把它隐藏到一个类里呢？这就是著名的“如果必须做不雅的事情，至少应将其本地化到一个类里”规则。看起来就象下面这样：

![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/16-1.gif)

现在，只要一种新类型的Trash加入方法，对TrashSorter对象的初始化就必须变动。可以想象，TrashSorter类看起来应该象下面这个样子：
```
class TrashSorter extends Vector {
void sort(Trash t) { /* ... */ }
}
```
也就是说，TrashSorter是由一系列句柄构成的Vector（系列），而那些句柄指向的又是由Trash句柄构成的Vector；利用addElement()，可以安装新的TrashSorter，如下所示：
```
TrashSorter ts = new TrashSorter();
ts.addElement(new Vector());
```
但是现在，sort()却成为一个问题。用静态方式编码的方法如何应付一种新类型加入的事实呢？为解决这个问题，必须从sort()里将类型信息删除，使其需要做的所有事情就是调用一个通用方法，用它照料涉及类型处理的所有细节。这当然是对一个动态绑定方法进行描述的另一种方式。所以sort()会在序列中简单地遍历，并为每个Vector都调用一个动态绑定方法。由于这个方法的任务是收集它感兴趣的垃圾片，所以称之为grab(Trash)。结构现在变成了下面这样：
![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/16-2.gif)

其中，TrashSorter需要调用每个grab()方法；然后根据当前Vector容纳的是什么类型，会获得一个不同的结果。也就是说，Vector必须留意自己容纳的类型。解决这个问题的传统方法是创建一个基础“Trash bin”（垃圾筒）类，并为希望容纳的每个不同的类型都继承一个新的衍生类。若Java有一个参数化的类型机制，那就也许是最直接的方法。但对于这种机制应该为我们构建的各个类，我们不应该进行麻烦的手工编码，以后的“观察”方式提供了一种更好的编码方式。

OOP设计一条基本的准则是“为状态的变化使用数据成员，为行为的变化使用多性形”。对于容纳Paper（纸张）的Vector，以及容纳Glass（玻璃）的Vector，大家最开始或许会认为分别用于它们的grab()方法肯定会产生不同的行为。但具体如何却完全取决于类型，而不是其他什么东西。可将其解释成一种不同的状态，而且由于Java有一个类可表示类型（Class），所以可用它判断特定的Tbin要容纳什么类型的Trash。

用于Tbin的构建器要求我们为其传递自己选择的一个Class。这样做可告诉Vector它希望容纳的是什么类型。随后，grab()方法用Class BinType和RTTI来检查我们传递给它的Trash对象是否与它希望收集的类型相符。 下面列出完整的解决方案。设定为注释的编号（如1）便于大家对照程序后面列出的说明。
```java
//: RecycleB.java
// Adding more objects to the recycling problem
package c16.recycleb;
import c16.trash.*;
import java.util.*;

// A vector that admits only the right type:
class Tbin extends Vector {
  Class binType;
  Tbin(Class binType) {
    this.binType = binType;
  }
  boolean grab(Trash t) {
    // Comparing class types:
    if(t.getClass().equals(binType)) {
      addElement(t);
      return true; // Object grabbed
    }
    return false; // Object not grabbed
  }
}

class TbinList extends Vector { //(*1*)
  boolean sort(Trash t) {
    Enumeration e = elements();
    while(e.hasMoreElements()) {
      Tbin bin = (Tbin)e.nextElement();
      if(bin.grab(t)) return true;
    }
    return false; // bin not found for t
  }
  void sortBin(Tbin bin) { // (*2*)
    Enumeration e = bin.elements();
    while(e.hasMoreElements())
      if(!sort((Trash)e.nextElement()))
        System.out.println("Bin not found");
  }
}

public class RecycleB {
  static Tbin bin = new Tbin(Trash.class);
  public static void main(String[] args) {
    // Fill up the Trash bin:
    ParseTrash.fillBin("Trash.dat", bin);

    TbinList trashBins = new TbinList();
    trashBins.addElement(
      new Tbin(Aluminum.class));
    trashBins.addElement(
      new Tbin(Paper.class));
    trashBins.addElement(
      new Tbin(Glass.class));
    // add one line here: (*3*)
    trashBins.addElement(
      new Tbin(Cardboard.class));

    trashBins.sortBin(bin); // (*4*)

    Enumeration e = trashBins.elements();
    while(e.hasMoreElements()) {
      Tbin b = (Tbin)e.nextElement();
      Trash.sumValue(b);
    }
    Trash.sumValue(bin);
  }
} ///:~
```
(1) TbinList容纳一系列Tbin句柄，所以在查找与我们传递给它的Trash对象相符的情况时，sort()能通过Tbin继承。

(2) sortBin()允许我们将一个完整的Tbin传递进去，而且它会在Tbin里遍历，挑选出每种Trash，并将其归类到特定的Tbin中。请注意这些代码的通用性：新类型加入时，它本身不需要任何改动。只要新类型加入（或发生其他事件）时大量代码都不需要变化，就表明我们设计的是一个容易扩展的系统。

(3) 现在可以体会添加新类型有多么容易了。为支持添加，只需要改动几行代码。如确实有必要，甚至可以进一步地改进设计，使更多的代码都保持“固定”。

(4) 一个方法调用使bin的内容归类到对应的、特定类型的垃圾筒里。

### 16.6 多重派遣
上述设计方案肯定是令人满意的。系统内新类型的加入涉及添加或修改不同的类，但没有必要在系统内对代码作大范围的改动。除此以外，RTTI并不象它在RecycleA.java里那样被不当地使用。然而，我们仍然有可能更深入一步，以最“纯”的角度来看待RTTI， 考虑如何在垃圾分类系统中将它完全消灭。

为达到这个目标，首先必须认识到：对所有与不同类型有特殊关联的活动来说——比如侦测一种垃圾的具体类型，并把它置入适当的垃圾筒里——这些活动都应当通过多形性以及动态绑定加以控制。

以前的例子都是先按类型排序，再对属于某种特殊类型的一系列元素进行操作。现在一旦需要操作特定的类型，就请先停下来想一想。事实上，多形性（动态绑定的方法调用）整个的宗旨就是帮我们管理与不同类型有特殊关联的信息。既然如此，为什么还要自己去检查类型呢？

答案在于大家或许不以为然的一个道理：Java只执行单一派遣。也就是说，假如对多个类型未知的对象执行某项操作，Java只会为那些类型中的一种调用动态绑定机制。这当然不能解决问题，所以最后不得不人工判断某些类型，才能有效地产生自己的动态绑定行为。

为解决这个缺陷，我们需要用到“多重派遣”机制，这意味着需要建立一个配置，使单一方法调用能产生多个动态方法调用，从而在一次处理过程中正确判断出多种类型。为达到这个要求，需要对多个类型结构进行操作：每一次派遣都需要一个类型结构。下面的例子将对两个结构进行操作：现有的Trash系列以及由垃圾筒（Trash Bin）的类型构成的一个系列——不同的垃圾或废品将置入这些筒内。第二个分级结构并非绝对显然的。在这种情况下，我们需要人为地创建它，以执行多重派遣（由于本例只涉及两次派遣，所以称为“双重派遣”）。 

#### 16.6.1 实现双重派遣

记住多形性只能通过方法调用才能表现出来，所以假如想使双重派遣正确进行，必须执行两个方法调用：在每种结构中都用一个来判断其中的类型。在Trash结构中，将使用一个新的方法调用addToBin()，它采用的参数是由TypeBin构成的一个数组。那个方法将在数组中遍历，尝试将自己加入适当的垃圾筒，这里正是双重派遣发生的地方。

![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/16-3.gif)

新建立的分级结构是TypeBin，其中包含了它自己的一个方法，名为add()，而且也应用了多形性。但要注意一个新特点：add()已进行了“过载”处理，可接受不同的垃圾类型作为参数。因此，双重满足机制的一个关键点是它也要涉及到过载。 程序的重新设计也带来了一个问题：现在的基础类Trash必须包含一个addToBin()方法。为解决这个问题，一个最直接的办法是复制所有代码，并修改基础类。然而，假如没有对源码的控制权，那么还有另一个办法可以考虑：将addToBin()方法置入一个接口内部，保持Trash不变，并继承新的、特殊的类型Aluminum，Paper，Glass以及Cardboard。我们在这里准备采取后一个办法。 这个设计方案中用到的大多数类都必须设为public（公用）属性，所以它们放置于自己的类内。下面列出接口代码：
```
//: TypedBinMember.java
// An interface for adding the double dispatching
// method to the trash hierarchy without
// modifying the original hierarchy.
package c16.doubledispatch;

interface TypedBinMember {
  // The new method:
  boolean addToBin(TypedBin[] tb);
} ///:~
```
在Aluminum，Paper，Glass以及Cardboard每个特定的子类型内，都会实现接口TypeBinMember的addToBin()方法，但每种情况下使用的代码“似乎”都是完全一样的：
```java
//: DDAluminum.java
// Aluminum for double dispatching
package c16.doubledispatch;
import c16.trash.*;

public class DDAluminum extends Aluminum
    implements TypedBinMember {
  public DDAluminum(double wt) { super(wt); }
  public boolean addToBin(TypedBin[] tb) {
    for(int i = 0; i < tb.length; i++)
      if(tb[i].add(this))
        return true;
    return false;
  }
} ///:~
//: DDPaper.java
// Paper for double dispatching
package c16.doubledispatch;
import c16.trash.*;

public class DDPaper extends Paper
    implements TypedBinMember {
  public DDPaper(double wt) { super(wt); }
  public boolean addToBin(TypedBin[] tb) {
    for(int i = 0; i < tb.length; i++)
      if(tb[i].add(this))
        return true;
    return false;
  }
} ///:~
//: DDGlass.java
// Glass for double dispatching
package c16.doubledispatch;
import c16.trash.*;

public class DDGlass extends Glass
    implements TypedBinMember {
  public DDGlass(double wt) { super(wt); }
  public boolean addToBin(TypedBin[] tb) {
    for(int i = 0; i < tb.length; i++)
      if(tb[i].add(this))
        return true;
    return false;
  }
} ///:~
//: DDCardboard.java
// Cardboard for double dispatching
package c16.doubledispatch;
import c16.trash.*;

public class DDCardboard extends Cardboard
    implements TypedBinMember {
  public DDCardboard(double wt) { super(wt); }
  public boolean addToBin(TypedBin[] tb) {
    for(int i = 0; i < tb.length; i++)
      if(tb[i].add(this))
        return true;
    return false;
  }
} ///:~
```
每个addToBin()内的代码会为数组中的每个TypeBin对象调用add()。但请注意参数：this。对Trash的每个子类来说，this的类型都是不同的，所以不能认为代码“完全”一样——尽管以后在Java里加入参数化类型机制后便可认为一样。这是双重派遣的第一个部分，因为一旦进入这个方法内部，便可知道到底是Aluminum，Paper，还是其他什么垃圾类型。在对add()的调用过程中，这种信息是通过this的类型传递的。编译器会分析出对add()正确的过载版本的调用。但由于tb[i]会产生指向基础类型TypeBin的一个句柄，所以最终会调用一个不同的方法——具体什么方法取决于当前选择的TypeBin的类型。那就是第二次派遣。

下面是TypeBin的基础类：
```java
//: TypedBin.java
// Vector that knows how to grab the right type
package c16.doubledispatch;
import c16.trash.*;
import java.util.*;

public abstract class TypedBin {
  Vector v = new Vector();
  protected boolean addIt(Trash t) {
    v.addElement(t);
    return true;
  }
  public Enumeration elements() {
    return v.elements();
  }
  public boolean add(DDAluminum a) {
    return false;
  }
  public boolean add(DDPaper a) {
    return false;
  }
  public boolean add(DDGlass a) {
    return false;
  }
  public boolean add(DDCardboard a) {
    return false;
  }
} ///:~
```
可以看到，过载的add()方法全都会返回false。如果未在衍生类里对方法进行过载，它就会一直返回false，而且调用者（目前是addToBin()）会认为当前Trash对象尚未成功加入一个集合，所以会继续查找正确的集合。

在TypeBin的每一个子类中，都只有一个过载的方法会被过载——具体取决于准备创建的是什么垃圾筒类型。举个例子来说，CardboardBin会过载add(DDCardboard)。过载的方法会将垃圾对象加入它的集合，并返回true。而CardboardBin中剩余的所有add()方法都会继续返回false，因为它们尚未过载。事实上，假如在这里采用了参数化类型机制，Java代码的自动创建就要方便得多（使用C++的“模板”，我们不必费事地为子类编码，或者将addToBin()方法置入Trash里；Java在这方面尚有待改进）。

由于对这个例子来说，垃圾的类型已经定制并置入一个不同的目录，所以需要用一个不同的垃圾数据文件令其运转起来。下面是一个示范性的DDTrash.dat：
```
c16.DoubleDispatch.DDGlass:54
c16.DoubleDispatch.DDPaper:22
c16.DoubleDispatch.DDPaper:11
c16.DoubleDispatch.DDGlass:17
c16.DoubleDispatch.DDAluminum:89
c16.DoubleDispatch.DDPaper:88
c16.DoubleDispatch.DDAluminum:76
c16.DoubleDispatch.DDCardboard:96
c16.DoubleDispatch.DDAluminum:25
c16.DoubleDispatch.DDAluminum:34
c16.DoubleDispatch.DDGlass:11
c16.DoubleDispatch.DDGlass:68
c16.DoubleDispatch.DDGlass:43
c16.DoubleDispatch.DDAluminum:27
c16.DoubleDispatch.DDCardboard:44
c16.DoubleDispatch.DDAluminum:18
c16.DoubleDispatch.DDPaper:91
c16.DoubleDispatch.DDGlass:63
c16.DoubleDispatch.DDGlass:50
c16.DoubleDispatch.DDGlass:80
c16.DoubleDispatch.DDAluminum:81
c16.DoubleDispatch.DDCardboard:12
c16.DoubleDispatch.DDGlass:12
c16.DoubleDispatch.DDGlass:54
c16.DoubleDispatch.DDAluminum:36
c16.DoubleDispatch.DDAluminum:93
c16.DoubleDispatch.DDGlass:93
c16.DoubleDispatch.DDPaper:80
c16.DoubleDispatch.DDGlass:36
c16.DoubleDispatch.DDGlass:12
c16.DoubleDispatch.DDGlass:60
c16.DoubleDispatch.DDPaper:66
c16.DoubleDispatch.DDAluminum:36
c16.DoubleDispatch.DDCardboard:22
```
下面列出程序剩余的部分：

```java
//: DoubleDispatch.java
// Using multiple dispatching to handle more
// than one unknown type during a method call.
package c16.doubledispatch;
import c16.trash.*;
import java.util.*;

class AluminumBin extends TypedBin {
  public boolean add(DDAluminum a) {
    return addIt(a);
  }
}

class PaperBin extends TypedBin {
  public boolean add(DDPaper a) {
    return addIt(a);
  }
}

class GlassBin extends TypedBin {
  public boolean add(DDGlass a) {
    return addIt(a);
  }
}

class CardboardBin extends TypedBin {
  public boolean add(DDCardboard a) {
    return addIt(a);
  }
}

class TrashBinSet {
  private TypedBin[] binSet = {
    new AluminumBin(),
    new PaperBin(),
    new GlassBin(),
    new CardboardBin()
  };
  public void sortIntoBins(Vector bin) {
    Enumeration e = bin.elements();
    while(e.hasMoreElements()) {
      TypedBinMember t =
        (TypedBinMember)e.nextElement();
      if(!t.addToBin(binSet))
        System.err.println("Couldn't add " + t);
    }
  }
  public TypedBin[] binSet() { return binSet; }
}

public class DoubleDispatch {
  public static void main(String[] args) {
    Vector bin = new Vector();
    TrashBinSet bins = new TrashBinSet();
    // ParseTrash still works, without changes:
    ParseTrash.fillBin("DDTrash.dat", bin);
    // Sort from the master bin into the
    // individually-typed bins:
    bins.sortIntoBins(bin);
    TypedBin[] tb = bins.binSet();
    // Perform sumValue for each bin...
    for(int i = 0; i < tb.length; i++)
      Trash.sumValue(tb[i].v);
    // ... and for the master bin
    Trash.sumValue(bin);
  }
} ///:~
```
其中，TrashBinSet封装了各种不同类型的TypeBin，同时还有sortIntoBins()方法。所有双重派遣事件都会在那个方法里发生。可以看到，一旦设置好结构，再归类成各种TypeBin的工作就变得十分简单了。除此以外，两个动态方法调用的效率可能也比其他排序方法高一些。

注意这个系统的方便性主要体现在main()中，同时还要注意到任何特定的类型信息在main()中都是完全独立的。只与Trash基础类接口通信的其他所有方法都不会受到Trash类中发生的改变的干扰。

添加新类型需要作出的改动是完全孤立的：我们随同addToBin()方法继承Trash的新类型，然后继承一个新的TypeBin（这实际只是一个副本，可以简单地编辑），最后将一种新类型加入TrashBinSet的集合初化化过程。

### 16.7 访问器范式


### 16.8 RTTI真的有害吗
### 16.9 总结
### 16.10 练习
