## 第10章 Java IO系统
由于存在大量不同的设计方案，所以该任务的困难性是很容易证明的。其中最大的挑战似乎是如何覆盖所有可能的因素。不仅有三种不同的种类的IO需要考虑（文件、控制台、网络连接），而且需要通过大量不同的方式与它们通信（顺序、随机访问、二进制、字符、按行、按字等等）。

Java库的设计者通过创建大量类来攻克这个难题。事实上，Java的IO系统采用了如此多的类，以致刚开始会产生不知从何处入手的感觉（具有讽刺意味的是，Java的IO设计初衷实际要求避免过多的类）。从Java 1.0升级到Java 1.1后，IO库的设计也发生了显著的变化。此时并非简单地用新库替换旧库，Sun的设计人员对原来的库进行了大手笔的扩展，添加了大量新的内容。因此，我们有时不得不混合使用新库与旧库，产生令人无奈的复杂代码。


### 10.1 输入和输出
装饰者模式，处理不同来源的输入和输出。
![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/iostream2xx.png)
>直接总结：
>
>1、能读取文件、写入文件、复制文件、利用缓冲区就行。
>
>2、知道完成这些操作有那些步骤就行。

可将Java库的IO类分割为输入与输出两个部分，这一点在用Web浏览器阅读联机Java类文档时便可知道。通过继承，从InputStream（输入流）衍生的所有类都拥有名为read()的基本方法，用于读取单个字节或者字节数组。类似地，从OutputStream衍生的所有类都拥有基本方法write()，用于写入单个字节或者字节数组。然而，我们通常不会用到这些方法；它们之所以存在，是因为更复杂的类可以利用它们，以便提供一个更有用的接口。因此，我们很少用单个类创建自己的系统对象。一般情况下，我们都是将多个对象重叠在一起，提供自己期望的功能。我们之所以感到Java的流库（Stream Library）异常复杂，正是由于为了创建单独一个结果流，却需要创建多个对象的缘故。

很有必要按照功能对类进行分类。库的设计者首先决定与输入有关的所有类都从InputStream继承，而与输出有关的所有类都从OutputStream继承。

#### 10.1.1 InputStream的类型
InputStream的作用是标志那些从不同起源地产生输入的类。这些起源地包括（每个都有一个相关的InputStream子类）：

- (1) 字节数组
- (2) String对象
- (3) 文件
- (4) “管道”，它的工作原理与现实生活中的管道类似：将一些东西置入一端，它们在另一端出来。
- (5) 一系列其他流，以便我们将其统一收集到单独一个流内。
- (6) 其他起源地，如Internet连接等（将在本书后面的部分讲述）。
除此以外，FilterInputStream也属于InputStream的一种类型，用它可为“破坏器”类提供一个基础类，以便将属性或者有用的接口同输入流连接到一起。
> 具体哪种类型有何特性，自己查找API吧。
#### 10.1.2 OutputStream的类型
> 具体哪种类型有何特性，自己查找API吧。
### 10.2 增添属性和有用的接口


利用层次化对象动态和透明地添加单个对象的能力的做法叫作“装饰器”（Decorator）方案——“方案”属于本书第16章的主题（注释①）。装饰器方案规定封装于初始化对象中的所有对象都拥有相同的接口，以便利用装饰器的“透明”性质——我们将相同的消息发给一个对象，无论它是否已被“装饰”。这正是在Java IO库里存在“过滤器”（Filter）类的原因：抽象的“过滤器”类是所有装饰器的基础类（装饰器必须拥有与它装饰的那个对象相同的接口，但装饰器亦可对接口作出扩展，这种情况见诸于几个特殊的“过滤器”类中）。

子类处理要求大量子类对每种可能的组合提供支持时，便经常会用到装饰器——由于组合形式太多，造成子类处理变得不切实际。Java IO库要求许多不同的特性组合方案，这正是装饰器方案显得特别有用的原因。但是，装饰器方案也有自己的一个缺点。在我们写一个程序的时候，装饰器为我们提供了大得多的灵活性（因为可以方便地混合与匹配属性），但它们也使自己的代码变得更加复杂。原因在于Java IO库操作不便，我们必须创建许多类——“核心”IO类型加上所有装饰器——才能得到自己希望的单个IO对象。

FilterInputStream和FilteOutputStream分别是过滤输入流和过滤输出流,他们的作用是为基础流提供一些额外的功能

FilterInputStream和FilterOutputStream（这两个名字不十分直观）提供了相应的装饰器接口，用于控制一个特定的输入流（InputStream）或者输出流（OutputStream）。它们分别是从InputStream和OutputStream衍生出来的。此外，它们都属于抽象类，在理论上为我们与一个流的不同通信手段都提供了一个通用的接口。事实上，FilterInputStream和FilterOutputStream只是简单地模仿了自己的基础类，它们是一个装饰器的基本要求。

#### 10.2.1 通过FilterInputStream从InputStream里读入数据
FilterInputStream类要完成两件全然不同的事情。其中，DataInputStream允许我们读取不同的基本类型数据以及String对象（所有方法都以“read”开头，比如readByte()，readFloat()等等）。伴随对应的DataOutputStream，我们可通过数据“流”将基本类型的数据从一个地方搬到另一个地方。这些“地方”是由表10.1总结的那些类决定的。若读取块内的数据，并自己进行解析，就不需要用到DataInputStream。但在其他许多情况下，我们一般都想用它对自己读入的数据进行自动格式化。 剩下的类用于修改InputStream的内部行为方式：是否进行缓冲，是否跟踪自己读入的数据行，以及是否能够推回一个字符等等。后两种类看起来特别象提供对构建一个编译器的支持（换言之，添加它们为了支持Java编译器的构建），所以在常规编程中一般都用不着它们。

也许几乎每次都要缓冲自己的输入，无论连接的是哪个IO设备。所以IO库最明智的做法就是将未缓冲输入作为一种特殊情况处理，同时将缓冲输入接纳为标准做法。

#### 10.2.2 通过FilterOutputStream向OutputStream里写入数据
与DataInputStream对应的是DataOutputStream，后者对各个基本数据类型以及String对象进行格式化，并将其置入一个数据“流”中，以便任何机器上的DataInputStream都能正常地读取它们。所有方法都以“wirte”开头，例如writeByte()，writeFloat()等等。

若想进行一些真正的格式化输出，比如输出到控制台，请使用PrintStream。利用它可以打印出所有基本数据类型以及String对象，并可采用一种易于查看的格式。这与DataOutputStream正好相反，后者的目标是将那些数据置入一个数据流中，以便DataInputStream能够方便地重新构造它们。System.out静态对象是一个PrintStream。

PrintStream内两个重要的方法是print()和println()。它们已进行了覆盖处理，可打印出所有数据类型。print()和println()之间的差异是后者在操作完毕后会自动添加一个新行。

BufferedOutputStream属于一种“修改器”，用于指示数据流使用缓冲技术，使自己不必每次都向流内物理性地写入数据。通常都应将它应用于文件处理和控制器IO。 表10.4 FilterOutputStream的类型


### 10.3 本身的缺陷：RandomAccessFile
RandomAccessFile用于包含了已知长度记录的文件，以便我们能用seek()从一条记录移至另一条；然后读取或修改那些记录。各记录的长度并不一定相同；只要知道它们有多大以及置于文件何处即可。

首先，我们有点难以相信RandomAccessFile不属于InputStream或者OutputStream分层结构的一部分。除了恰巧实现了DataInput以及DataOutput（这两者亦由DataInputStream和DataOutputStream实现）接口之外，它们与那些分层结构并无什么关系。它甚至没有用到现有InputStream或OutputStream类的功能——采用的是一个完全不相干的类。该类属于全新的设计，含有自己的全部（大多数为固有）方法。之所以要这样做，是因为RandomAccessFile拥有与其他IO类型完全不同的行为，因为我们可在一个文件里向前或向后移动。不管在哪种情况下，它都是独立运作的，作为Object的一个“直接继承人”使用。

从根本上说，RandomAccessFile类似DataInputStream和DataOutputStream的联合使用。其中，getFilePointer()用于了解当前在文件的什么地方，seek()用于移至文件内的一个新地点，而length()用于判断文件的最大长度。此外，构建器要求使用另一个自变量（与C的fopen()完全一样），指出自己只是随机读（"r"），还是读写兼施（"rw"）。这里没有提供对“只写文件”的支持。也就是说，假如是从DataInputStream继承的，那么RandomAccessFile也有可能能很好地工作。

还有更难对付的。很容易想象我们有时要在其他类型的数据流中搜索，比如一个ByteArrayInputStream，但搜索方法只有RandomAccessFile才会提供。而后者只能针对文件才能操作，不能针对数据流操作。此时，BufferedInputStream确实允许我们标记一个位置（使用mark()，它的值容纳于单个内部变量中），并用reset()重设那个位置。但这些做法都存在限制，并不是特别有用。
### 10.4 File类
File类有一个欺骗性的名字——通常会认为它对付的是一个文件，但实情并非如此。它既代表一个特定文件的名字，也代表目录内一系列文件的名字。若代表一个文件集，便可用list()方法查询这个集，返回的是一个字串数组。之所以要返回一个数组，而非某个灵活的集合类，是因为元素的数量是固定的。而且若想得到一个不同的目录列表，只需创建一个不同的File对象即可。事实上，“FilePath”（文件路径）似乎是一个更好的名字。本节将向大家完整地例示如何使用这个类，其中包括相关的FilenameFilter（文件名过滤器）接口。

#### 10.4.1 目录列表器
现在假设我们想观看一个目录列表。可用两种方式列出File对象。若在不含自变量（参数）的情况下调用list()，会获得File对象包含的一个完整列表。然而，若想对这个列表进行某些限制，就需要使用一个“目录过滤器”，该类的作用是指出应如何选择File对象来完成显示。

实现”interface FilenameFilter（关于接口的问题，已在第7章进行了详述）。下面让我们看看FilenameFilter接口有多么简单
```
public interface FilenameFilter {
boolean accept(文件目录, 字串名);
}
```
它指出这种类型的所有对象都提供了一个名为accept()的方法。之所以要创建这样的一个类，背后的全部原因就是把accept()方法提供给list()方法，使list()能够“回调”accept()，从而判断应将哪些文件名包括到列表中。因此，通常将这种技术称为“回调”，有时也称为“算子”（也就是说，DirFilter是一个算子，因为它唯一的作用就是容纳一个方法）。由于list()采用一个FilenameFilter对象作为自己的自变量使用，所以我们能传递实现了FilenameFilter的任何类的一个对象，用它决定（甚至在运行期）list()方法的行为方式。回调的目的是在代码的行为上提供更大的灵活性。

通过DirFilter，我们看出尽管一个“接口”只包含了一系列方法，但并不局限于只能写那些方法（但是，至少必须提供一个接口内所有方法的定义。在这种情况下，DirFilter构建器也会创建）。

accept()方法必须接纳一个File对象，用它指示用于寻找一个特定文件的目录；并接纳一个String，其中包含了要寻找之文件的名字。可决定使用或忽略这两个参数之一，但有时至少要使用文件名。记住list()方法准备为目录对象中的每个文件名调用

accept()，核实哪个应包含在内——具体由accept()返回的“布尔”结果决定。 为确定我们操作的只是文件名，其中没有包含路径信息，必须采用String对象，并在它的外部创建一个File对象。然后调用

getName()，它的作用是去除所有路径信息（采用与平台无关的方式）。随后，accept()用String类的indexOf()方法检查文件名内部是否存在搜索字串"afn"。若在字串内找到afn，那么返回值就是afn的起点索引；但假如没有找到，返回值就是-1。注意这只是一个简单的字串搜索例子，未使用常见的表达式“通配符”方案，比如"fo?.b?r*"；这种方案更难实现。

list()方法返回的是一个数组。可查询这个数组的长度，然后在其中遍历，选定数组元素。与C和C++的类似行为相比，这种于方法内外方便游历数组的行为无疑是一个显著的进步。

注意filter()的自变量必须是final。这一点是匿名内部类要求的，使其能使用来自本身作用域以外的一个对象。


#### 10.4.2 检查与创建目录
File类并不仅仅是对现有目录路径、文件或者文件组的一个表示。亦可用一个File对象新建一个目录，甚至创建一个完整的目录路径——假如它尚不存在的话。亦可用它了解文件的属性（长度、上一次修改日期、读／写属性等），检查一个File对象到底代表一个文件还是一个目录，以及删除一个文件等等。

### 10.5 IO流的典型应用
尽管库内存在大量IO流类，可通过多种不同的方式组合到一起，但实际上只有几种方式才会经常用到。然而，必须小心在意才能得到正确的组合。下面这个相当长的例子展示了典型IO配置的创建与使用，可在写自己的代码时将其作为一个参考使用。注意每个配置都以一个注释形式的编号起头，并提供了适当的解释信息。

#### 10.5.1 输入流
- 缓冲的输入文件

为打开一个文件以便输入，需要使用一个FileInputStream，同时将一个String或File对象作为文件名使用。为提高速度，最好先对文件进行缓冲处理，从而获得用于一个BufferedInputStream的构建器的结果句柄。为了以格式化的形式读取输入数据，我们将那个结果句柄赋给用于一个DataInputStream的构建器。DataInputStream是我们的最终（final）对象，并是我们进行读取操作的接口。
```
      DataInputStream in =
        new DataInputStream(
          new BufferedInputStream(
            new FileInputStream(args[0])
          )
        );
      String s, s2 = new String();
      while((s = in.readLine())!= null)
        s2 += s + "\n";
      in.close();
```
在这个例子中，只用到了readLine()方法，但理所当然任何DataInputStream方法都可以采用。一旦抵达文件末尾，readLine()就会返回一个null（空），以便中止并退出while循环。

“String s2”用于聚集完整的文件内容（包括必须添加的新行，因为readLine()去除了那些行）。随后，在本程序的后面部分中使用s2。最后，我们调用close()，用它关闭文件。从技术上说，会在运行finalize()时调用close()。而且我们希望一旦程序退出，就发生这种情况（无论是否进行垃圾收集）。然而，Java 1.0有一个非常突出的错误（Bug），造成这种情况不会发生。在Java 1.1中，必须明确调用System.runFinalizersOnExit(true)，用它保证会为系统中的每个对象调用finalize()。然而，最安全的方法还是为文件明确调用close()。


StringBufferInputStream的接口是有限的，所以通常需要将其封装到一个DataInputStream内，从而增强它的能力。然而，若选择用readByte()每次读出一个字符，那么所有值都是有效的，所以不可再用返回值来侦测何时结束输入。相反，可用available()方法判断有多少字符可用。下面这个例子展示了如何从文件中一次读出一个字符：
```
      DataInputStream in = 
        new DataInputStream(
         new BufferedInputStream(
          new FileInputStream("TestEof.java")));
      while(in.available() != 0)
        System.out.print((char)in.readByte());

```
注意取决于当前从什么媒体读入，avaiable()的工作方式也是有所区别的。它在字面上意味着“可以不受阻塞读取的字节数量”。对一个文件来说，它意味着整个文件。但对一个不同种类的数据流来说，它却可能有不同的含义。因此在使用时应考虑周全。

#### 10.5.2 输出流
两类主要的输出流是按它们写入数据的方式划分的：一种按人的习惯写入，另一种为了以后由一个DataInputStream而写入。RandomAccessFile是独立的，尽管它的数据格式兼容于DataInputStream和DataOutputStream。


#### 10.5.3 快捷文件处理
这段说的是工具类，熟悉可IO的API自己写就行。


#### 10.5.4 从标准输入中读取数据
以Unix首先倡导的“标准输入”、“标准输出”以及“标准错误输出”概念为基础，Java提供了相应的System.in，System.out以及System.err。贯这一整本书，大家都会接触到如何用System.out进行标准输出，它已预封装成一个PrintStream对象。

System.err同样是一个PrintStream，但System.in是一个原始的InputStream，未进行任何封装处理。这意味着尽管能直接使用System.out和System.err，但必须事先封装System.in，否则不能从中读取数据。
典型情况下，我们希望用readLine()每次读取一行输入信息，所以需要将System.in封装到一个DataInputStream中。这是Java 1.0进行行输入时采取的“老”办法。在本章稍后，大家还会看到Java 1.1的解决方案。
```
  public static void main(String[] args) {
    DataInputStream in =
      new DataInputStream(
        new BufferedInputStream(System.in));
    String s;
    try {
      while((s = in.readLine()).length() != 0)
        System.out.println(s);
      // An empty line terminates the program
    } catch(IOException e) {
      e.printStackTrace();
    }
  }

```


#### 10.5.5 管道数据流
本章已简要介绍了PipedInputStream（管道输入流）和PipedOutputStream（管道输出流）。尽管描述不十分详细，但并不是说它们作用不大。然而，只有在掌握了多线程处理的概念后，才可真正体会它们的价值所在。原因很简单，因为管道化的数据流就是用于线程之间的通信。这方面的问题将在第14章用一个示例说明。


### 10.6 StreamTokenizer
尽管StreamTokenizer并不是从InputStream或OutputStream衍生的，但它只随同InputStream工作，所以十分恰当地包括在库的IO部分中。
StreamTokenizer类用于将任何InputStream分割为一系列“记号”（Token）。这些记号实际是一些断续的文本块，中间用我们选择的任何东西分隔。例如，我们的记号可以是单词，中间用空白（空格）以及标点符号分隔。 

- 类java.io.StreamTokenizer可以获取输入流并将其分析为Token(标记)。StreamTokenizer的nextToken方法将读取下一个标记
- 默认情况下，StreamTokenizer认为下列内容是Token：字母、数字、除C和C++注释符号以外的其他符号。如符号“/”不是Token，注释后的内容也不是，而“\”是Token。单引号和双引号以及其中的内容，只能算是一个Token。
- 要统计文件的字符数，不能简单地统计Token数，因为字符数不等于Token，按照Token的规定，引号中的内容就算是10页也算是一个Token。如果希望引号和引号中的内容都算作Token，应该通过StreamTokenizer的ordinaryCha()方法将单引号和双引号当做普通字符处理。

```
StreamTokenizer用来分隔字符串。

可以获取输入流并将其分析为Token(标记)。StreamTokenizer的nextToken方法将读取下一个标记。

功能 
1、 将输入流分解成一组标记，允许一次读一个。分解过程由一张表和一些可以设置成各种状态的标志来控制。  
2、读取的每个字节被认为是“\u0000”-“\u00FF”之间的字符。空格(“\u0000”-“\u0020”)，字母(“A”-“Z”,“a”-“z”,“\u00A0”-“\u00FF”)，数字，串引号(“,“)，注释字符(“/”)）。  
3、做法：以一个InputStream作为源，创建一个StreamTokenizer对象，设置参数,循环调用nextToken，返回流中下一个标记的类型，并处理相关的值。 
4、主要用于分析Java风格的输入；不是通用的标记分析器。  ttype域：nextToken后刚读取的标记类型。六种情况： 

单字符标记：表示该字符（转换成整数） 
引号串标记：引号符(String类型域sval存储了串内容) 
TT_WORD(-3)：单词。String类型域sval存储了该单词。 
TT_NUMBER(-2)：数。double类型域nval保存该数值。只能识别十进制浮点数。( ?  3.4e79,0xffff ) 
 TT_EOL(“\n”)：行结束。 
TT_EOF(-1)：文件结束。
 //创建分析给定字符流的标记生成器
            StreamTokenizer st = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
  //ordinaryChar方法指定字符参数在此标记生成器中是“普通”字符。
            st.ordinaryChar('\''); //指定单引号、双引号和注释符号是普通字符
            st.ordinaryChar('\"');
            st.ordinaryChar('/')
 
  //nextToken方法读取下一个Token.
  //TT_EOF指示已读到流末尾的常量。
            while (st.nextToken() != StreamTokenizer.TT_EOF) {
  //在调用 nextToken 方法之后，ttype字段将包含刚读取的标记的类型
                switch (st.ttype) {
  //TT_EOL指示已读到行末尾的常量。
                case StreamTokenizer.TT_EOL:
                    break;
  //TT_NUMBER指示已读到一个数字标记的常量
                case StreamTokenizer.TT_NUMBER:
  //如果当前标记是一个数字，nval字段将包含该数字的值
                    s = String.valueOf((st.nval));
                    System.out.println(s);
                    numberSum += s.length();
                    break;
  //TT_WORD指示已读到一个文字标记的常量
                case StreamTokenizer.TT_WORD:
   //如果当前标记是一个文字标记，sval字段包含一个给出该文字标记的字符的字符串
                    s = st.sval;
                    wordSum += s.length();
                    break;
                default:
```


#### 10.6.1 StringTokenizer
无论如何，只应将StringTokenizer看作StreamTokenizer一种简单而且特殊的简化形式。然而，如果有一个字串需要进行记号处理，而且StringTokenizer的功能实在有限，那么应该做的全部事情就是用StringBufferInputStream将其转换到一个数据流里，再用它创建一个功能更强大的StreamTokenizer。

> 跟 StreamTokenizer 差不多，反正我没用过。。。

### 10.7 Java 1.1的IO流
之所以在Java 1.1里添加了Reader和Writer层次，最重要的原因便是国际化的需求。老式IO流层次结构只支持8位字节流，不能很好地控制16位Unicode字符。由于Unicode主要面向的是国际化支持（Java内含的char是16位的Unicode），所以添加了Reader和Writer层次，以提供对所有IO操作中的Unicode的支持。除此之外，新库也对速度进行了优化，可比旧库更快地运行。 与本书其他地方一样，我会试着提供对类的一个概述，但假定你会利用联机文档搞定所有的细节，比如方法的详尽列表等。

> 我还以为将NIO呢，但是NIO不是JDK 1.4 及以上版本里提供的咩。。。

### 10.8 压缩
> 就是讲压缩API 的，自己看API写用例就行了。。。没啥细究的。。。

Java 1.1也添加一个类，用以支持对压缩格式的数据流的读写。它们封装到现成的IO类中，以提供压缩功能。
```
CheckedInputStream GetCheckSum()为任何InputStream产生校验和（不仅是解压）
CheckedOutputStream GetCheckSum()为任何OutputStream产生校验和（不仅是解压）
DeflaterOutputStream 用于压缩类的基础类
ZipOutputStream 一个DeflaterOutputStream，将数据压缩成Zip文件格式
GZIPOutputStream 一个DeflaterOutputStream，将数据压缩成GZIP文件格式
InflaterInputStream 用于解压类的基础类
ZipInputStream 一个DeflaterInputStream，解压用Zip文件格式保存的数据
GZIPInputStream 一个DeflaterInputStream，解压用GZIP文件格式保存的数据
```
尽管存在许多种压缩算法，但是Zip和GZIP可能最常用的。所以能够很方便地用多种现成的工具来读写这些格式的压缩数据。
#### 10.8.1 用GZIP进行简单压缩
#### 10.8.2 用Zip进行多文件保存
#### 10.8.3 Java归档（jar）实用程序
Zip格式亦在Java 1.1的JAR（Java ARchive）文件格式中得到了采用。这种文件格式的作用是将一系列文件合并到单个压缩文件里，就象Zip那样。然而，同Java中其他任何东西一样，JAR文件是跨平台的，所以不必关心涉及具体平台的问题。除了可以包括声音和图像文件以外，也可以在其中包括类文件。

一个JAR文件由一系列采用Zip压缩格式的文件构成，同时还有一张“详情单”，对所有这些文件进行了描述（可创建自己的详情单文件；否则，jar程序会为我们代劳）。在联机用户文档中，可以找到与JAR详情单更多的资料（详情单的英语是“Manifest”）。 jar实用程序已与Sun的JDK配套提供，可以按我们的选择自动压缩文件。请在命令行调用它：

### 10.9 对象序列化
> 对象序列化这些年养活了很多安全工程师。。。

Java 1.1增添了一种有趣的特性，名为“对象序列化”（Object Serialization）。它面向那些实现了Serializable接口的对象，可将它们转换成一系列字节，并可在以后完全恢复回原来的样子。这一过程亦可通过网络进行。这意味着序列化机制能自动补偿操作系统间的差异。换句话说，可以先在Windows机器上创建一个对象，对其序列化，然后通过网络发给一台Unix机器，然后在那里准确无误地重新“装配”。不必关心数据在不同机器上如何表示，也不必关心字节的顺序或者其他任何细节。

就其本身来说，对象的序列化是非常有趣的，因为利用它可以实现“有限持久化”。请记住“持久化”意味着对象的“生存时间”并不取决于程序是否正在执行——它存在或“生存”于程序的每一次调用之间。通过序列化一个对象，将其写入磁盘，以后在程序重新调用时重新恢复那个对象，就能圆满实现一种“持久”效果。之所以称其为“有限”，是因为不能用某种“persistent”（持久）关键字简单地地定义一个对象，并让系统自动照看其他所有细节问题（尽管将来可能成为现实）。相反，必须在自己的程序中明确地序列化和组装对象。

语言里增加了对象序列化的概念后，可提供对两种主要特性的支持。Java 1.1的“远程方法调用”（RMI）使本来存在于其他机器的对象可以表现出好象就在本地机器上的行为。将消息发给远程对象时，需要通过对象序列化来传输参数和返回值。RMI将在第15章作具体讨论。

对象的序列化也是Java Beans必需的，后者由Java 1.1引入。使用一个Bean时，它的状态信息通常在设计期间配置好。程序启动以后，这种状态信息必须保存下来，以便程序启动以后恢复；具体工作由对象序列化完成。
> 学习JSP，不可避免地你会接触到JavaBeans

对象的序列化处理非常简单，只需对象实现了Serializable接口即可（该接口仅是一个标记，没有方法）。在Java 1.1中，许多标准库类都发生了改变，以便能够序列化——其中包括用于基本数据类型的全部封装器、所有集合类以及其他许多东西。甚至Class对象也可以序列化（第11章讲述了具体实现过程）。

为序列化一个对象，首先要创建某些OutputStream对象，然后将其封装到ObjectOutputStream对象内。此时，只需调用writeObject()即可完成对象的序列化，并将其发送给OutputStream。相反的过程是将一个InputStream封装到ObjectInputStream内，然后调用 readObject()。和往常一样，我们最后获得的是指向一个上溯造型Object的句柄，所以必须下溯造型，以便能够直接设置。

对象序列化特别“聪明”的一个地方是它不仅保存了对象的“全景图”，而且能追踪对象内包含的所有句柄并保存那些对象；接着又能对每个对象内包含的句柄进行追踪；以此类推。我们有时将这种情况称为“对象网”，单个对象可与之建立连接。而且它还包含了对象的句柄数组以及成员对象。若必须自行操纵一套对象序列化机制，那么在代码里追踪所有这些链接时可能会显得非常麻烦。在另一方面，由于Java对象的序列化似乎找不出什么缺点，所以请尽量不要自己动手，让它用优化的算法自动维护整个对象网。下面这个例子对序列化机制进行了测试。它建立了许多链接对象的一个“Worm”（蠕虫），每个对象都与Worm中的下一段链接，同时又与属于不同类（Data）的对象句柄数组链接：
```
//: Worm.java
// Demonstrates object serialization in Java 1.1
import java.io.*;

class Data implements Serializable {
  private int i;
  Data(int x) { i = x; }
  public String toString() {
    return Integer.toString(i);
  }
}

public class Worm implements Serializable {
  // Generate a random int value:
  private static int r() {
    return (int)(Math.random() * 10);
  }
  private Data[] d = {
    new Data(r()), new Data(r()), new Data(r())
  };
  private Worm next;
  private char c;
  // Value of i == number of segments
  Worm(int i, char x) {
    System.out.println(" Worm constructor: " + i);
    c = x;
    if(--i > 0)
      next = new Worm(i, (char)(x + 1));
  }
  Worm() {
    System.out.println("Default constructor");
  }
  public String toString() {
    String s = ":" + c + "(";
    for(int i = 0; i < d.length; i++)
      s += d[i].toString();
    s += ")";
    if(next != null)
      s += next.toString();
    return s;
  }
  public static void main(String[] args) {
    Worm w = new Worm(6, 'a');
    System.out.println("w = " + w);
    try {
      ObjectOutputStream out =
        new ObjectOutputStream(
          new FileOutputStream("worm.out"));
      out.writeObject("Worm storage");
      out.writeObject(w);
      out.close(); // Also flushes output
      ObjectInputStream in =
        new ObjectInputStream(
          new FileInputStream("worm.out"));
      String s = (String)in.readObject();
      Worm w2 = (Worm)in.readObject();
      System.out.println(s + ", w2 = " + w2);
    } catch(Exception e) {
      e.printStackTrace();
    }
    try {
      ByteArrayOutputStream bout =
        new ByteArrayOutputStream();
      ObjectOutputStream out =
        new ObjectOutputStream(bout);
      out.writeObject("Worm storage");
      out.writeObject(w);
      out.flush();
      ObjectInputStream in =
        new ObjectInputStream(
          new ByteArrayInputStream(
            bout.toByteArray()));
      String s = (String)in.readObject();
      Worm w3 = (Worm)in.readObject();
      System.out.println(s + ", w3 = " + w3);
    } catch(Exception e) {
      e.printStackTrace();
    }
  }
} ///:~
```


真正的序列化过程却是非常简单的。一旦从另外某个流里创建了ObjectOutputStream，writeObject()就会序列化对象。注意也可以为一个String调用writeObject()。亦可使用与DataOutputStream相同的方法写入所有基本数据类型（它们有相同的接口）。

有两个单独的try块看起来是类似的。第一个读写的是文件，而另一个读写的是一个ByteArray（字节数组）。可利用对任何DataInputStream或者DataOutputStream的序列化来读写特定的对象；正如在关于连网的那一章会讲到的那样，这些对象甚至包括网络。

可以看出，装配回原状的对象确实包含了原来那个对象里包含的所有链接。

注意在对一个Serializable（可序列化）对象进行重新装配的过程中，不会调用任何构建器（甚至默认构建器）。整个对象都是通过从InputStream中取得数据恢复的。

作为Java 1.1特性的一种，我们注意到对象的序列化并不属于新的Reader和Writer层次结构的一部分，而是沿用老式的InputStream和OutputStream结构。所以在一些特殊的场合下，不得不混合使用两种类型的层次结构。

#### 10.9.1 寻找类

读者或许会奇怪为什么需要一个对象从它的序列化状态中恢复。举个例子来说，假定我们序列化一个对象，并通过网络将其作为文件传送给另一台机器。此时，位于另一台机器的程序可以只用文件目录来重新构造这个对象吗？ 回答这个问题的最好方法就是做一个实验。下面这个文件位于本章的子目录下：
```
//: Alien.java
// A serializable class
import java.io.*;

public class Alien implements Serializable {
} ///:~
```
用于创建和序列化一个Alien对象的文件位于相同的目录下：
```
//: FreezeAlien.java
// Create a serialized output file
import java.io.*;

public class FreezeAlien {
  public static void main(String[] args) 
      throws Exception {
    ObjectOutput out = 
      new ObjectOutputStream(
        new FileOutputStream("file.x"));
    Alien zorcon = new Alien();
    out.writeObject(zorcon); 
  }
} ///:~
```
该程序并不是捕获和控制违例，而是将违例简单、直接地传递到main()外部，这样便能在命令行报告它们。 程序编译并运行后，将结果产生的file.x复制到名为xfiles的子目录，代码如下：
```
//: ThawAlien.java
// Try to recover a serialized file without the 
// class of object that's stored in that file.
package c10.xfiles;
import java.io.*;

public class ThawAlien {
  public static void main(String[] args) 
      throws Exception {
    ObjectInputStream in =
      new ObjectInputStream(
        new FileInputStream("file.x"));
    Object mystery = in.readObject();
    System.out.println(
      mystery.getClass().toString());
  }
} ///:~
```
该程序能打开文件，并成功读取mystery对象中的内容。然而，一旦尝试查找与对象有关的任何资料——这要求Alien的Class对象——Java虚拟机（JVM）便找不到Alien.class（除非它正好在类路径内，而本例理应相反）。这样就会得到一个名叫ClassNotFoundException的违例（同样地，若非能够校验Alien存在的证据，否则它等于消失）。

恢复了一个序列化的对象后，如果想对其做更多的事情，必须保证JVM能在本地类路径或者因特网的其他什么地方找到相关的.class文件。

>总结：
>
>这小节说啥了，是在说，通过序列化恢复产生的对象，在 JVM 中是没有.class 的，除非它正好在相同类路径内。

#### 10.9.2 序列化的控制
正如大家看到的那样，默认的序列化机制并不难操纵。然而，假若有特殊要求又该怎么办呢？我们可能有特殊的安全问题，不希望对象的某一部分序列化；或者某一个子对象完全不必序列化，因为对象恢复以后，那一部分需要重新创建。

此时，通过实现Externalizable接口，用它代替Serializable接口，便可控制序列化的具体过程。这个Externalizable接口扩展了Serializable，并增添了两个方法：writeExternal()和readExternal()。在序列化和重新装配的过程中，会自动调用这两个方法，以便我们执行一些特殊操作。

下面这个例子展示了Externalizable接口方法的简单应用。注意Blip1和Blip2几乎完全一致，除了极微小的差别（自己研究一下代码，看看是否能发现）：

```java
//: Blips.java
// Simple use of Externalizable & a pitfall
import java.io.*;
import java.util.*;

class Blip1 implements Externalizable {
  public Blip1() {
    System.out.println("Blip1 Constructor");
  }
  public void writeExternal(ObjectOutput out)
      throws IOException {
    System.out.println("Blip1.writeExternal");
  }
  public void readExternal(ObjectInput in)
     throws IOException, ClassNotFoundException {
    System.out.println("Blip1.readExternal");
  }
}

class Blip2 implements Externalizable {
  Blip2() {
    System.out.println("Blip2 Constructor");
  }
  public void writeExternal(ObjectOutput out)
      throws IOException {
    System.out.println("Blip2.writeExternal");
  }
  public void readExternal(ObjectInput in)
     throws IOException, ClassNotFoundException {
    System.out.println("Blip2.readExternal");
  }
}

public class Blips {
  public static void main(String[] args) {
    System.out.println("Constructing objects:");
    Blip1 b1 = new Blip1();
    Blip2 b2 = new Blip2();
    try {
      ObjectOutputStream o =
        new ObjectOutputStream(
          new FileOutputStream("Blips.out"));
      System.out.println("Saving objects:");
      o.writeObject(b1);
      o.writeObject(b2);
      o.close();
      // Now get them back:
      ObjectInputStream in =
        new ObjectInputStream(
          new FileInputStream("Blips.out"));
      System.out.println("Recovering b1:");
      b1 = (Blip1)in.readObject();
      // OOPS! Throws an exception:
//!   System.out.println("Recovering b2:");
//!   b2 = (Blip2)in.readObject();
    } catch(Exception e) {
      e.printStackTrace();
    }
  }
} ///:~
```
该程序输出如下：
```
Constructing objects:
Blip1 Constructor
Blip2 Constructor
Saving objects:
Blip1.writeExternal
Blip2.writeExternal
Recovering b1:
Blip1 Constructor
Blip1.readExternal
```

未恢复Blip2对象的原因是那样做会导致一个违例。你找出了Blip1和Blip2之间的区别吗？Blip1的构建器是“公共的”（public），Blip2的构建器则不然，这样便会在恢复时造成违例。试试将Blip2的构建器属性变成“public”，然后删除//!注释标记，看看是否能得到正确的结果。

恢复b1后，会调用Blip1默认构建器。这与恢复一个Serializable（可序列化）对象不同。在后者的情况下，对象完全以它保存下来的二进制位为基础恢复，不存在构建器调用。而对一个Externalizable对象，所有普通的默认构建行为都会发生（包括在字段定义时的初始化），而且会调用readExternal()。必须注意这一事实——特别注意所有默认的构建行为都会进行——否则很难在自己的Externalizable对象中产生正确的行为。

下面这个例子揭示了保存和恢复一个Externalizable对象必须做的全部事情：
```java
//: Blip3.java
// Reconstructing an externalizable object
import java.io.*;
import java.util.*;

class Blip3 implements Externalizable {
  int i;
  String s; // No initialization
  public Blip3() {
    System.out.println("Blip3 Constructor");
    // s, i not initialized
  }
  public Blip3(String x, int a) {
    System.out.println("Blip3(String x, int a)");
    s = x;
    i = a;
    // s & i initialized only in non-default
    // constructor.
  }
  public String toString() { return s + i; }
  public void writeExternal(ObjectOutput out)
      throws IOException {
    System.out.println("Blip3.writeExternal");
    // You must do this:
    out.writeObject(s); out.writeInt(i);
  }
  public void readExternal(ObjectInput in)
     throws IOException, ClassNotFoundException {
    System.out.println("Blip3.readExternal");
    // You must do this:
    s = (String)in.readObject(); 
    i =in.readInt();
  }
  public static void main(String[] args) {
    System.out.println("Constructing objects:");
    Blip3 b3 = new Blip3("A String ", 47);
    System.out.println(b3.toString());
    try {
      ObjectOutputStream o =
        new ObjectOutputStream(
          new FileOutputStream("Blip3.out"));
      System.out.println("Saving object:");
      o.writeObject(b3);
      o.close();
      // Now get it back:
      ObjectInputStream in =
        new ObjectInputStream(
          new FileInputStream("Blip3.out"));
      System.out.println("Recovering b3:");
      b3 = (Blip3)in.readObject();
      System.out.println(b3.toString());
    } catch(Exception e) {
      e.printStackTrace();
    }
  }
} ///:~
```
```
Constructing objects:
Blip3(String x, int a)
A String 47
Saving object:
Blip3.writeExternal
Recovering b3:
Blip3 Constructor
Blip3.readExternal
A String 47
```

其中，字段s和i只在第二个构建器中初始化，不关默认构建器的事。这意味着假如不在readExternal中初始化s和i，它们就会成为null（因为在对象创建的第一步中已将对象的存储空间清除为1）。若注释掉跟随于“You must do this”后面的两行代码，并运行程序，就会发现当对象恢复以后，s是null，而i是零。

若从一个Externalizable对象继承，通常需要调用writeExternal()和readExternal()的基础类版本，以便正确地保存和恢复基础类组件。

所以为了让一切正常运作起来，千万不可仅在writeExternal()方法执行期间写入对象的重要数据（没有默认的行为可用来为一个Externalizable对象写入所有成员对象）的，而是必须在readExternal()方法中也恢复那些数据。初次操作时可能会有些不习惯，因为Externalizable对象的默认构建行为使其看起来似乎正在进行某种存储与恢复操作。但实情并非如此。
>总结：
>
> 对象继承 Externalizable 实现序列化，需要注意 writeExternal()和readExternal() 方法，
> 序列化时：在 writeExternal() 方法 写入对象的重要的想恢复的数据。
> 反序列化时： 会先调用方法的 公开无参构造方法（不公开会报错），在readExternal()方法中恢复那些序列化时的out的数据。

- transient（临时）关键字

控制序列化过程时，可能有一个特定的子对象不愿让Java的序列化机制自动保存与恢复。一般地，若那个子对象包含了不想序列化的敏感信息（如密码），就会面临这种情况。即使那种信息在对象中具有“private”（私有）属性，但一旦经序列化处理，人们就可以通过读取一个文件，或者拦截网络传输得到它。

为防止对象的敏感部分被序列化，一个办法是将自己的类实现为Externalizable，就象前面展示的那样。这样一来，没有任何东西可以自动序列化，只能在writeExternal()明确序列化那些需要的部分。

然而，若操作的是一个Serializable对象，所有序列化操作都会自动进行。为解决这个问题，可以用transient（临时）逐个字段地关闭序列化，它的意思是“不要麻烦你（指自动机制）保存或恢复它了——我会自己处理的”。

例如，假设一个Login对象包含了与一个特定的登录会话有关的信息。校验登录的合法性时，一般都想将数据保存下来，但不包括密码。为做到这一点，最简单的办法是实现Serializable，并将password字段设为transient。

可以看到，其中的date和username字段保持原始状态（未设成transient），所以会自动序列化。然而，password被设为transient，所以不会自动保存到磁盘；另外，自动序列化机制也不会作恢复它的尝试。输出如下：

一旦对象恢复成原来的样子，password字段就会变成null。注意必须用toString()检查password是否为null，因为若用过载的“+”运算符来装配一个String对象，而且那个运算符遇到一个null句柄，就会造成一个名为NullPointerException的违例（新版Java可能会提供避免这个问题的代码）。

我们也发现date字段被保存到磁盘，并从磁盘恢复，没有重新生成。

由于Externalizable对象默认时不保存它的任何字段，所以transient关键字只能伴随Serializable使用。

- Externalizable 的替代方法

若不是特别在意要实现Externalizable接口，还有另一种方法可供选用。我们可以实现Serializable接口，并添加（注意是“添加”，而非“覆盖”或者“实现”）名为writeObject()和readObject()的方法。一旦对象被序列化或者重新装配，就会分别调用那两个方法。也就是说，只要提供了这两个方法，就会优先使用它们，而不考虑默认的序列化机制。 这些方法必须含有下列准确的签名：
```
private void 
  writeObject(ObjectOutputStream stream)
    throws IOException;

private void 
  readObject(ObjectInputStream stream)
    throws IOException, ClassNotFoundException
```
从设计的角度出发，情况变得有些扑朔迷离。首先，大家可能认为这些方法不属于基础类或者Serializable接口的一部分，它们应该在自己的接口中得到定义。但请注意它们被定义成“private”，这意味着它们只能由这个类的其他成员调用。然而，我们实际并不从这个类的其他成员中调用它们，而是由ObjectOutputStream和ObjectInputStream的writeObject()及readObject()方法来调用我们对象的writeObject()和readObject()方法（注意我在这里用了很大的抑制力来避免使用相同的方法名——因为怕混淆）。大家可能奇怪ObjectOutputStream和ObjectInputStream如何有权访问我们的类的private方法——只能认为这是序列化机制玩的一个把戏。


在任何情况下，接口中的定义的任何东西都会自动具有public属性，所以假若writeObject()和readObject()必须为private，那么它们不能成为接口（interface）的一部分。但由于我们准确地加上了签名，所以最终的效果实际与实现一个接口是相同的。

看起来似乎我们调用ObjectOutputStream.writeObject()的时候，我们传递给它的Serializable对象似乎会被检查是否实现了自己的writeObject()。若答案是肯定的是，便会跳过常规的序列化过程，并调用writeObject()。readObject()也会遇到同样的情况。

还存在另一个问题。在我们的writeObject()内部，可以调用defaultWriteObject()，从而决定采取默认的writeObject()行动。类似地，在readObject()内部，可以调用defaultReadObject()。下面这个简单的例子演示了如何对一个Serializable对象的存储与恢复进行控制：
````
//: SerialCtl.java
// Controlling serialization by adding your own
// writeObject() and readObject() methods.
import java.io.*;

public class SerialCtl implements Serializable {
  String a;
  transient String b;
  public SerialCtl(String aa, String bb) {
    a = "Not Transient: " + aa;
    b = "Transient: " + bb;
  }
  public String toString() {
    return a + "\n" + b;
  }
  private void 
    writeObject(ObjectOutputStream stream)
      throws IOException {
    stream.defaultWriteObject();
    stream.writeObject(b);
  }
  private void 
    readObject(ObjectInputStream stream)
      throws IOException, ClassNotFoundException {
    stream.defaultReadObject();
    b = (String)stream.readObject();
  }
  public static void main(String[] args) {
    SerialCtl sc = 
      new SerialCtl("Test1", "Test2");
    System.out.println("Before:\n" + sc);
    ByteArrayOutputStream buf = 
      new ByteArrayOutputStream();
    try {
      ObjectOutputStream o =
        new ObjectOutputStream(buf);
      o.writeObject(sc);
      // Now get it back:
      ObjectInputStream in =
        new ObjectInputStream(
          new ByteArrayInputStream(
            buf.toByteArray()));
      SerialCtl sc2 = (SerialCtl)in.readObject();
      System.out.println("After:\n" + sc2);
    } catch(Exception e) {
      e.printStackTrace();
    }
  }
} ///:~
````
在这个例子中，一个String保持原始状态，其他设为transient（临时），以便证明非临时字段会被defaultWriteObject()方法自动保存，而transient字段必须在程序中明确保存和恢复。字段是在构建器内部初始化的，而不是在定义的时候，这证明了它们不会在重新装配的时候被某些自动化机制初始化。

若准备通过默认机制写入对象的非transient部分，那么必须调用defaultWriteObject()，令其作为writeObject()中的第一个操作；并调用defaultReadObject()，令其作为readObject()的第一个操作。这些都是不常见的调用方法。举个例子来说，当我们为一个ObjectOutputStream调用defaultWriteObject()的时候，而且没有为其传递参数，就需要采取这种操作，使其知道对象的句柄以及如何写入所有非transient的部分。这种做法非常不便。

transient对象的存储与恢复采用了我们更熟悉的代码。现在考虑一下会发生一些什么事情。在main()中会创建一个SerialCtl对象，随后会序列化到一个ObjectOutputStream里（注意这种情况下使用的是一个缓冲区，而非文件——与ObjectOutputStream完全一致）。正式的序列化操作是在下面这行代码里发生的：
```
o.writeObject(sc);
```
其中，writeObject()方法必须核查sc，判断它是否有自己的writeObject()方法（不是检查它的接口——它根本就没有，也不是检查类的类型，而是利用反射方法实际搜索方法）。若答案是肯定的，就使用那个方法。类似的情况也会在readObject()上发生。或许这是解决问题唯一实际的方法，但确实显得有些古怪。

- 版本问题

有时候可能想改变一个可序列化的类的版本（比如原始类的对象可能保存在数据库中）。尽管这种做法得到了支持，但一般只应在非常特殊的情况下才用它。此外，它要求操作者对背后的原理有一个比较深的认识，而我们在这里还不想达到这种深度。JDK 1.1的HTML文档对这一主题进行了非常全面的论述（可从Sun公司下载，但可能也成了Java开发包联机文档的一部分）。

#### 10.9.3 利用“持久性”
一个比较诱人的想法是用序列化技术保存程序的一些状态信息，从而将程序方便地恢复到以前的状态。但在具体实现以前，有些问题是必须解决的。如果两个对象都有指向第三个对象的句柄，该如何对这两个对象序列化呢？如果从两个对象序列化后的状态恢复它们，第三个对象的句柄只会出现在一个对象身上吗？如果将这两个对象序列化成独立的文件，然后在代码的不同部分重新装配它们，又会得到什么结果呢？

下面这个例子对上述问题进行了很好的说明：
```java
//: MyWorld.java
import java.io.*;
import java.util.*;

class House implements Serializable {}

class Animal implements Serializable {
  String name;
  House preferredHouse;
  Animal(String nm, House h) { 
    name = nm; 
    preferredHouse = h;
  }
  public String toString() {
    return name + "[" + super.toString() + 
      "], " + preferredHouse + "\n";
  }
}

public class MyWorld {
  public static void main(String[] args) {
    House house = new House();
    Vector  animals = new Vector();
    animals.addElement(
      new Animal("Bosco the dog", house));
    animals.addElement(
      new Animal("Ralph the hamster", house));
    animals.addElement(
      new Animal("Fronk the cat", house));
    System.out.println("animals: " + animals);

    try {
      ByteArrayOutputStream buf1 = 
        new ByteArrayOutputStream();
      ObjectOutputStream o1 =
        new ObjectOutputStream(buf1);
      o1.writeObject(animals);
      o1.writeObject(animals); // Write a 2nd set
      // Write to a different stream:
      ByteArrayOutputStream buf2 = 
        new ByteArrayOutputStream();
      ObjectOutputStream o2 =
        new ObjectOutputStream(buf2);
      o2.writeObject(animals);
      // Now get them back:
      ObjectInputStream in1 =
        new ObjectInputStream(
          new ByteArrayInputStream(
            buf1.toByteArray()));
      ObjectInputStream in2 =
        new ObjectInputStream(
          new ByteArrayInputStream(
            buf2.toByteArray()));
      Vector animals1 = (Vector)in1.readObject();
      Vector animals2 = (Vector)in1.readObject();
      Vector animals3 = (Vector)in2.readObject();
      System.out.println("animals1: " + animals1);
      System.out.println("animals2: " + animals2);
      System.out.println("animals3: " + animals3);
    } catch(Exception e) {
      e.printStackTrace();
    }
  }
} ///:~

```
```
animals: [Bosco the dog[com.openjfx.test.io.Animal@44c8afef], com.openjfx.test.io.House@5891e32e
, Ralph the hamster[com.openjfx.test.io.Animal@cb0ed20], com.openjfx.test.io.House@5891e32e
, Fronk the cat[com.openjfx.test.io.Animal@8e24743], com.openjfx.test.io.House@5891e32e
]
animals1: [Bosco the dog[com.openjfx.test.io.Animal@48a242ce], com.openjfx.test.io.House@1e4a7dd4
, Ralph the hamster[com.openjfx.test.io.Animal@4f51b3e0], com.openjfx.test.io.House@1e4a7dd4
, Fronk the cat[com.openjfx.test.io.Animal@4b9e255], com.openjfx.test.io.House@1e4a7dd4
]
animals2: [Bosco the dog[com.openjfx.test.io.Animal@48a242ce], com.openjfx.test.io.House@1e4a7dd4
, Ralph the hamster[com.openjfx.test.io.Animal@4f51b3e0], com.openjfx.test.io.House@1e4a7dd4
, Fronk the cat[com.openjfx.test.io.Animal@4b9e255], com.openjfx.test.io.House@1e4a7dd4
]
animals3: [Bosco the dog[com.openjfx.test.io.Animal@5e57643e], com.openjfx.test.io.House@133e16fd
, Ralph the hamster[com.openjfx.test.io.Animal@51b279c9], com.openjfx.test.io.House@133e16fd
, Fronk the cat[com.openjfx.test.io.Animal@1ad282e0], com.openjfx.test.io.House@133e16fd
]
```

这里一件有趣的事情是也许是能针对一个字节数组应用对象的序列化，从而实现对任何Serializable（可序列化）对象的一个“全面复制”（全面复制意味着复制的是整个对象网，而不仅是基本对象和它的句柄）。复制问题将在第12章进行全面讲述。

Animal对象包含了类型为House的字段。在main()中，会创建这些Animal的一个Vector，并对其序列化两次，分别送入两个不同的数据流内。这些数据重新装配并打印出来后，可看到下面这样的结果（对象在每次运行时都会处在不同的内存位置，所以每次运行的结果有区别）：

当然，我们希望装配好的对象有与原来不同的地址。但注意在animals1和animals2中出现了相同的地址，其中包括共享的、对House对象的引用。在另一方面，当animals3恢复以后，系统没有办法知道另一个流内的对象是第一个流内对象的化身，所以会产生一个完全不同的对象网。

只要将所有东西都序列化到单独一个数据流里，就能恢复获得与以前写入时完全一样的对象网，不会不慎造成对象的重复。当然，在写第一个和最后一个对象的时间之间，可改变对象的状态，但那必须由我们明确采取操作——序列化时，对象会采用它们当时的任何状态（包括它们与其他对象的连接关系）写入。
> 也就是说一个队形在数据流里系列化两次，会恢复为一个对象，不同的流里会复制对象

若想保存系统状态，最安全的做法是当作一种“微观”操作序列化。如果序列化了某些东西，再去做其他一些工作，再来序列化更多的东西，以此类推，那么最终将无法安全地保存系统状态。相反，应将构成系统状态的所有对象都置入单个集合内，并在一次操作里完成那个集合的写入。这样一来，同样只需一次方法调用，即可成功恢复之。

下面这个例子是一套假想的计算机辅助设计（CAD）系统，对这一方法进行了很好的演示。此外，它还为我们引入了static字段的问题——如留意联机文档，就会发现Class是“Serializable”（可序列化）的，所以只需简单地序列化Class对象，就能实现static字段的保存。这无论如何都是一种明智的做法。

```java
//: CADState.java
// Saving and restoring the state of a 
// pretend CAD system.
import java.io.*;
import java.util.*;

abstract class Shape implements Serializable {
  public static final int 
    RED = 1, BLUE = 2, GREEN = 3;
  private int xPos, yPos, dimension;
  private static Random r = new Random();
  private static int counter = 0;
  abstract public void setColor(int newColor);
  abstract public int getColor();
  public Shape(int xVal, int yVal, int dim) {
    xPos = xVal;
    yPos = yVal;
    dimension = dim;
  }
  public String toString() {
    return getClass().toString() + 
      " color[" + getColor() +
      "] xPos[" + xPos +
      "] yPos[" + yPos +
      "] dim[" + dimension + "]\n";
  }
  public static Shape randomFactory() {
    int xVal = r.nextInt() % 100;
    int yVal = r.nextInt() % 100;
    int dim = r.nextInt() % 100;
    switch(counter++ % 3) {
      default: 
      case 0: return new Circle(xVal, yVal, dim);
      case 1: return new Square(xVal, yVal, dim);
      case 2: return new Line(xVal, yVal, dim);
    }
  }
}

class Circle extends Shape {
  private static int color = RED;
  public Circle(int xVal, int yVal, int dim) {
    super(xVal, yVal, dim);
  }
  public void setColor(int newColor) { 
    color = newColor;
  }
  public int getColor() { 
    return color;
  }
}

class Square extends Shape {
  private static int color;
  public Square(int xVal, int yVal, int dim) {
    super(xVal, yVal, dim);
    color = RED;
  }
  public void setColor(int newColor) { 
    color = newColor;
  }
  public int getColor() { 
    return color;
  }
}

class Line extends Shape {
  private static int color = RED;
  public static void 
  serializeStaticState(ObjectOutputStream os)
      throws IOException {
    os.writeInt(color);
  }
  public static void 
  deserializeStaticState(ObjectInputStream os)
      throws IOException {
    color = os.readInt();
  }
  public Line(int xVal, int yVal, int dim) {
    super(xVal, yVal, dim);
  }
  public void setColor(int newColor) { 
    color = newColor;
  }
  public int getColor() { 
    return color;
  }
}

public class CADState {
  public static void main(String[] args) 
      throws Exception {
    Vector shapeTypes, shapes;
    if(args.length == 0) {
      shapeTypes = new Vector();
      shapes = new Vector();
      // Add handles to the class objects:
      shapeTypes.addElement(Circle.class);
      shapeTypes.addElement(Square.class);
      shapeTypes.addElement(Line.class);
      // Make some shapes:
      for(int i = 0; i < 10; i++)
        shapes.addElement(Shape.randomFactory());
      // Set all the static colors to GREEN:
      for(int i = 0; i < 10; i++)
        ((Shape)shapes.elementAt(i))
          .setColor(Shape.GREEN);
      // Save the state vector:
      ObjectOutputStream out =
        new ObjectOutputStream(
          new FileOutputStream("CADState.out"));
      out.writeObject(shapeTypes);
      Line.serializeStaticState(out);
      out.writeObject(shapes);
    } else { // There's a command-line argument
      ObjectInputStream in =
        new ObjectInputStream(
          new FileInputStream(args[0]));
      // Read in the same order they were written:
      shapeTypes = (Vector)in.readObject();
      Line.deserializeStaticState(in);
      shapes = (Vector)in.readObject();
    }
    // Display the shapes:
    System.out.println(shapes);
  }
} ///:~
```
Shape（几何形状）类“实现了可序列化”（implements Serializable），所以从Shape继承的任何东西也都会自动“可序列化”。每个Shape都包含了数据，而且每个衍生的Shape类都包含了一个特殊的static字段，用于决定所有那些类型的Shape的颜色（如将一个static字段置入基础类，结果只会产生一个字段，因为static字段未在衍生类中复制）。可对基础类中的方法进行覆盖处理，以便为不同的类型设置颜色（static方法不会动态绑定，所以这些都是普通的方法）。每次调用 randomFactory()方法时，它都会创建一个不同的Shape（Shape值采用随机值）。

Circle（圆）和Square（矩形）属于对Shape的直接扩展；唯一的差别是Circle在定义时会初始化颜色，而Square在构建器中初始化。Line（直线）的问题将留到以后讨论。

在main()中，一个Vector用于容纳Class对象，而另一个用于容纳形状。若不提供相应的命令行参数，就会创建shapeTypes Vector，并添加Class对象。然后创建shapes Vector，并添加Shape对象。接下来，所有static color值都会设成GREEN，而且所有东西都会序列化到文件CADState.out。

若提供了一个命令行参数（假设CADState.out），便会打开那个文件，并用它恢复程序的状态。无论在哪种情况下，结果产生的Shape的Vector都会打印出来。下面列出它某一次运行的结果：
```
>java CADState
[class Circle color[3] xPos[-51] yPos[-99] dim[38]
, class Square color[3] xPos[2] yPos[61] dim[-46]
, class Line color[3] xPos[51] yPos[73] dim[64]
, class Circle color[3] xPos[-70] yPos[1] dim[16]
, class Square color[3] xPos[3] yPos[94] dim[-36]
, class Line color[3] xPos[-84] yPos[-21] dim[-35]
, class Circle color[3] xPos[-75] yPos[-43] dim[22]
, class Square color[3] xPos[81] yPos[30] dim[-45]
, class Line color[3] xPos[-29] yPos[92] dim[17]
, class Circle color[3] xPos[17] yPos[90] dim[-76]
]

>java CADState CADState.out
[class Circle color[1] xPos[-51] yPos[-99] dim[38]
, class Square color[0] xPos[2] yPos[61] dim[-46]
, class Line color[3] xPos[51] yPos[73] dim[64]
, class Circle color[1] xPos[-70] yPos[1] dim[16]
, class Square color[0] xPos[3] yPos[94] dim[-36]
, class Line color[3] xPos[-84] yPos[-21] dim[-35]
, class Circle color[1] xPos[-75] yPos[-43] dim[22]
, class Square color[0] xPos[81] yPos[30] dim[-45]
, class Line color[3] xPos[-29] yPos[92] dim[17]
, class Circle color[1] xPos[17] yPos[90] dim[-76]
]
```
从中可以看出，xPos，yPos以及dim的值都已成功保存和恢复出来。但在获取static信息时却出现了问题。所有“3”都已进入，但没有正常地出来。Circle有一个1值（定义为RED），而Square有一个0值（记住，它们是在构建器里初始化的）。看上去似乎static根本没有得到初始化！实情正是如此——尽管类Class是“可以序列化的”，但却不能按我们希望的工作。所以假如想序列化static值，必须亲自动手。

这正是Line中的serializeStaticState()和deserializeStaticState()两个static方法的用途。可以看到，这两个方法都是作为存储和恢复进程的一部分明确调用的（注意写入序列化文件和从中读回的顺序不能改变）。所以为了使CADState.java正确运行起来，必须采用下述三种方法之一：
- (1) 为几何形状添加一个serializeStaticState()和deserializeStaticState()。
- (2) 删除Vector shapeTypes以及与之有关的所有代码
- (3) 在几何形状内添加对新序列化和撤消序列化静态方法的调用

要注意的另一个问题是安全，因为序列化处理也会将private数据保存下来。若有需要保密的字段，应将其标记成transient。但在这之后，必须设计一种安全的信息保存方法。这样一来，一旦需要恢复，就可以重设那些private变量。


### 10.10 总结
Java IO流库能满足我们的许多基本要求：可以通过控制台、文件、内存块甚至因特网（参见第15章）进行读写。可以创建新的输入和输出对象类型（通过从InputStream和OutputStream继承）。向一个本来预期为收到字串的方法传递一个对象时，由于Java已限制了“自动类型转换”，所以会自动调用toString()方法。而我们可以重新定义这个toString()，扩展一个数据流能接纳的对象种类。

在IO数据流库的联机文档和设计过程中，仍有些问题没有解决。比如当我们打开一个文件以便输出时，完全可以指定一旦有人试图覆盖该文件就“掷”出一个违例——有的编程系统允许我们自行指定想打开一个输出文件，但唯一的前提是它尚不存在。但在Java中，似乎必须用一个File对象来判断某个文件是否存在，因为假如将其作为FileOutputStream或者FileWriter打开，那么肯定会被覆盖。若同时指定文件和目录路径，File类设计上的一个缺陷就会暴露出来，因为它会说“不要试图在单个类里做太多的事情”！ IO流库易使我们混淆一些概念。它确实能做许多事情，而且也可以移植。但假如假如事先没有吃透装饰器方案的概念，那么所有的设计都多少带有一点盲目性质。所以不管学它还是教它，都要特别花一些功夫才行。而且它并不完整：没有提供对输出格式化的支持，而其他几乎所有语言的IO包都提供了这方面的支持（这一点没有在Java 1.1里得以纠正，它完全错失了改变库设计方案的机会，反而增添了更特殊的一些情况，使复杂程度进一步提高）。Java 1.1转到那些尚未替换的IO库，而不是增加新库。而且库的设计人员似乎没有很好地指出哪些特性是不赞成的，哪些是首选的，造成库设计中经常都会出现一些令人恼火的反对消息。

然而，一旦掌握了装饰器方案，并开始在一些较为灵活的环境使用库，就会认识到这种设计的好处。到那个时候，为此多付出的代码行应该不至于使你觉得太生气。


### 10.11 练习
(1) 打开一个文本文件，每次读取一行内容。将每行作为一个String读入，并将那个String对象置入一个Vector里。按相反的顺序打印出Vector中的所有行。

(2) 修改练习1，使读取那个文件的名字作为一个命令行参数提供。

(3) 修改练习2，又打开一个文本文件，以便将文字写入其中。将Vector中的行随同行号一起写入文件。

(4) 修改练习2，强迫Vector中的所有行都变成大写形式，将结果发给System.out。

(5) 修改练习2，在文件中查找指定的单词。打印出包含了欲找单词的所有文本行。

(6) 在Blips.java中复制文件，将其重命名为BlipCheck.java。然后将类Blip2重命名为BlipCheck（在进程中将其标记为public）。删除文件中的//!记号，并执行程序。接下来，将BlipCheck的默认构建器变成注释信息。运行它，并解释为什么仍然能够工作。

(7) 在Blip3.java中，将接在“You must do this:”字样后的两行变成注释，然后运行程序。解释得到的结果为什么会与执行了那两行代码不同。

(8) 转换SortedWordCount.java程序，以便使用Java 1.1 IO流。

(9) 根据本章正文的说明修改程序CADState.java。

(10) 在第7章（中间部分）找到GreenhouseControls.java示例，它应该由三个文件构成。在GreenhouseControls.java中，Restart()内部类有一个硬编码的事件集。请修改这个程序，使其能从一个文本文件里动态读取事件以及它们的相关时间。

