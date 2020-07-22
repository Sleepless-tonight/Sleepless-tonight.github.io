## 第15章 网络编程
历史上的网络编程都倾向于困难、复杂，而且极易出错。

程序员必须掌握与网络有关的大量细节，有时甚至要对硬件有深刻的认识。一般地，我们需要理解连网协议中不同的“层”（Layer）。而且对于每个连网库，一般都包含了数量众多的函数，分别涉及信息块的连接、打包和拆包；这些块的来回运输；以及握手等等。这是一项令人痛苦的工作。

但是，连网本身的概念并不是很难。我们想获得位于其他地方某台机器上的信息，并把它们移到这儿；或者相反。这与读写文件非常相似，只是文件存在于远程机器上，而且远程机器有权决定如何处理我们请求或者发送的数据。

Java最出色的一个地方就是它的“无痛苦连网”概念。有关连网的基层细节已被尽可能地提取出去，并隐藏在JVM以及Java的本机安装系统里进行控制。我们使用的编程模型是一个文件的模型；事实上，网络连接（一个“套接字”）已被封装到系统对象里，所以可象对其他数据流那样采用同样的方法调用。除此以外，在我们处理另一个连网问题——同时控制多个网络连接——的时候，Java内建的多线程机制也是十分方便的。

本章将用一系列易懂的例子解释Java的连网支持。

### 15.1 机器的标识
当然，为了分辨来自别处的一台机器，以及为了保证自己连接的是希望的那台机器，必须有一种机制能独一无二地标识出网络内的每台机器。早期网络只解决了如何在本地网络环境中为机器提供唯一的名字。但Java面向的是整个因特网，这要求用一种机制对来自世界各地的机器进行标识。为达到这个目的，我们采用了IP（互联网地址）的概念。IP以两种形式存在着：

(1) 大家最熟悉的DNS（域名服务）形式。我自己的域名是bruceeckel.com。所以假定我在自己的域内有一台名为Opus的计算机，它的域名就可以是Opus.bruceeckel.com。这正是大家向其他人发送电子函件时采用的名字，而且通常集成到一个万维网（WWW）地址里。

(2) 此外，亦可采用“四点”格式，亦即由点号（.）分隔的四组数字，比如202.98.32.111。 不管哪种情况，IP地址在内部都表达成一个由32个二进制位（bit）构成的数字（注释①），所以IP地址的每一组数字都不能超过255。利用由java.net提供的static InetAddress.getByName()，我们可以让一个特定的Java对象表达上述任何一种形式的数字。结果是类型为InetAddress的一个对象，可用它构成一个“套接字”（Socket），大家在后面会见到这一点。

①：这意味着最多只能得到40亿左右的数字组合，全世界的人很快就会把它用光。但根据目前正在研究的新IP编址方案，它将采用128 bit的数字，这样得到的唯一性IP地址也许在几百年的时间里都不会用完。

作为运用InetAddress.getByName()一个简单的例子，请考虑假设自己有一家拨号连接因特网服务提供者（ISP），那么会发生什么情况。每次拨号连接的时候，都会分配得到一个临时IP地址。但在连接期间，那个IP地址拥有与因特网上其他IP地址一样的有效性。如果有人按照你的IP地址连接你的机器，他们就有可能使用在你机器上运行的Web或者FTP服务器程序。当然这有个前提，对方必须准确地知道你目前分配到的IP。由于每次拨号连接获得的IP都是随机的，怎样才能准确地掌握你的IP呢？ 下面这个程序利用InetAddress.getByName()来产生你的IP地址。为了让它运行起来，事先必须知道计算机的名字。该程序只在Windows 95中进行了测试，但大家可以依次进入自己的“开始”、“设置”、“控制面板”、“网络”，然后进入“标识”卡片。其中，“计算机名称”就是应在命令行输入的内容。

```java
//: WhoAmI.java
// Finds out your network address when you're 
// connected to the Internet.
package c15;
import java.net.*;

public class WhoAmI {
  public static void main(String[] args) 
      throws Exception {
    if(args.length != 1) {
      System.err.println(
        "Usage: WhoAmI MachineName");
      System.exit(1);
    }
    InetAddress a = 
      InetAddress.getByName(args[0]);
    System.out.println(a);
  }
} ///:~
```
就我自己的情况来说，机器的名字叫作“Colossus”（来自同名电影，“巨人”的意思。我在这台机器上有一个很大的硬盘）。所以一旦连通我的ISP，就象下面这样执行程序：

```
java whoAmI Colossus
```
得到的结果象下面这个样子（当然，这个地址可能每次都是不同的）：
```
Colossus/202.98.41.151
```
假如我把这个地址告诉一位朋友，他就可以立即登录到我的个人Web服务器，只需指定目标地址 http://202.98.41.151 即可（当然，我此时不能断线）。有些时候，这是向其他人发送信息或者在自己的Web站点正式出台以前进行测试的一种方便手段。

#### 15.1.1 服务器和客户机
网络最基本的精神就是让两台机器连接到一起，并相互“交谈”或者“沟通”。一旦两台机器都发现了对方，就可以展开一次令人愉快的双向对话。但它们怎样才能“发现”对方呢？这就象在游乐园里那样：一台机器不得不停留在一个地方，侦听其他机器说：“嘿，你在哪里呢？”

“停留在一个地方”的机器叫作“服务器”（Server）；到处“找人”的机器则叫作“客户机”（Client）或者“客户”。它们之间的区别只有在客户机试图同服务器连接的时候才显得非常明显。一旦连通，就变成了一种双向通信，谁来扮演服务器或者客户机便显得不那么重要了。

所以服务器的主要任务是侦听建立连接的请求，这是由我们创建的特定服务器对象完成的。而客户机的任务是试着与一台服务器建立连接，这是由我们创建的特定客户机对象完成的。一旦连接建好，那么无论在服务器端还是客户机端，连接只是魔术般地变成了一个IO数据流对象。从这时开始，我们可以象读写一个普通的文件那样对待连接。所以一旦建好连接，我们只需象第10章那样使用自己熟悉的IO命令即可。这正是Java连网最方便的一个地方。

- 在没有网络的前提下测试程序

由于多种潜在的原因，我们可能没有一台客户机、服务器以及一个网络来测试自己做好的程序。我们也许是在一个课堂环境中进行练习，或者写出的是一个不十分可靠的网络应用，还能拿到网络上去。IP的设计者注意到了这个问题，并建立了一个特殊的地址——localhost——来满足非网络环境中的测试要求。在Java中产生这个地址最一般的做法是：

```
InetAddress addr = InetAddress.getByName(null);
```
如果向getByName()传递一个null（空）值，就默认为使用localhost。我们用InetAddress对特定的机器进行索引，而且必须在进行进一步的操作之前得到这个InetAddress（互联网地址）。我们不可以操纵一个InetAddress的内容（但可把它打印出来，就象下一个例子要演示的那样）。创建InetAddress的唯一途径就是那个类的static（静态）成员方法getByName()（这是最常用的）、getAllByName()或者getLocalHost()。

为得到本地主机地址，亦可向其直接传递字串"localhost"：
```
InetAddress.getByName("localhost");
```
或者使用它的保留IP地址（四点形式），就象下面这样：
```
InetAddress.getByName("127.0.0.1");
```
这三种方法得到的结果是一样的。

#### 15.1.2 端口：机器内独一无二的场所

有些时候，一个IP地址并不足以完整标识一个服务器。这是由于在一台物理性的机器中，往往运行着多个服务器（程序）。由IP表达的每台机器也包含了“端口”（Port）。我们设置一个客户机或者服务器的时候，必须选择一个无论客户机还是服务器都认可连接的端口。就象我们去拜会某人时，IP地址是他居住的房子，而端口是他在的那个房间。

注意端口并不是机器上一个物理上存在的场所，而是一种软件抽象（主要是为了表述的方便）。客户程序知道如何通过机器的IP地址同它连接，但怎样才能同自己真正需要的那种服务连接呢（一般每个端口都运行着一种服务，一台机器可能提供了多种服务，比如HTTP和FTP等等）？端口编号在这里扮演了重要的角色，它是必需的一种二级定址措施。也就是说，我们请求一个特定的端口，便相当于请求与那个端口编号关联的服务。“报时”便是服务的一个典型例子。通常，每个服务都同一台特定服务器机器上的一个独一 无二的端口编号关联在一起。客户程序必须事先知道自己要求的那项服务的运行端口号。
系统服务保留了使用端口1到端口1024的权力，所以不应让自己设计的服务占用这些以及其他任何已知正在使用的端口。本书的第一个例子将使用端口8080（为追忆我的第一台机器使用的老式8位Intel 8080芯片，那是一部使用CP/M操作系统的机子）。

### 15.2 套接字

“套接字”或者“插座”（Socket）也是一种软件形式的抽象，用于表达两台机器间一个连接的“终端”。针对一个特定的连接，每台机器上都有一个“套接字”，可以想象它们之间有一条虚拟的“线缆”。线缆的每一端都插入一个“套接字”或者“插座”里。当然，机器之间的物理性硬件以及电缆连接都是完全未知的。抽象的基本宗旨是让我们尽可能不必知道那些细节。

在Java中，我们创建一个套接字，用它建立与其他机器的连接。从套接字得到的结果是一个InputStream以及OutputStream（若使用恰当的转换器，则分别是Reader和Writer），以便将连接作为一个IO流对象对待。有两个基于数据流的套接字类：ServerSocket，服务器用它“侦听”进入的连接；以及Socket，客户用它初始一次连接。一旦客户（程序）申请建立一个套接字连接，ServerSocket就会返回（通过accept()方法）一个对应的服务器端套接字，以便进行直接通信。从此时起，我们就得到了真正的“套接字－套接字”连接，可以用同样的方式对待连接的两端，因为它们本来就是相同的！此时可以利用getInputStream()以及getOutputStream()从每个套接字产生对应的InputStream和OutputStream对象。这些数据流必须封装到缓冲区内。可按第10章介绍的方法对类进行格式化，就象对待其他任何流对象那样。

对于Java库的命名机制，ServerSocket（服务器套接字）的使用无疑是容易产生混淆的又一个例证。大家可能认为ServerSocket最好叫作“ServerConnector”（服务器连接器），或者其他什么名字，只是不要在其中安插一个“Socket”。也可能以为ServerSocket和Socket都应从一些通用的基础类继承。事实上，这两种类确实包含了几个通用的方法，但还不够资格把它们赋给一个通用的基础类。相反，ServerSocket的主要任务是在那里耐心地等候其他机器同它连接，再返回一个实际的Socket。这正是“ServerSocket”这个命名不恰当的地方，因为它的目标不是真的成为一个Socket，而是在其他人同它连接的时候产生一个Socket对象。

然而，ServerSocket确实会在主机上创建一个物理性的“服务器”或者侦听用的套接字。这个套接字会侦听进入的连接，然后利用accept()方法返回一个“已建立”套接字（本地和远程端点均已定义）。容易混淆的地方是这两个套接字（侦听和已建立）都与相同的服务器套接字关联在一起。侦听套接字只能接收新的连接请求，不能接收实际的数据包。所以尽管ServerSocket对于编程并无太大的意义，但它确实是“物理性”的。

创建一个ServerSocket时，只需为其赋予一个端口编号。不必把一个IP地址分配它，因为它已经在自己代表的那台机器上了。但在创建一个Socket时，却必须同时赋予IP地址以及要连接的端口编号（另一方面，从ServerSocket.accept()返回的Socket已经包含了所有这些信息）。


#### 15.2.1 一个简单的服务器和客户机程序
这个例子将以最简单的方式运用套接字对服务器和客户机进行操作。服务器的全部工作就是等候建立一个连接，然后用那个连接产生的Socket创建一个InputStream以及一个OutputStream。在这之后，它从InputStream读入的所有东西都会反馈给OutputStream，直到接收到行中止（END）为止，最后关闭连接。

客户机连接与服务器的连接，然后创建一个OutputStream。文本行通过OutputStream发送。客户机也会创建一个InputStream，用它收听服务器说些什么（本例只不过是反馈回来的同样的字句）。

服务器与客户机（程序）都使用同样的端口号，而且客户机利用本地主机地址连接位于同一台机器中的服务器（程序），所以不必在一个物理性的网络里完成测试（在某些配置环境中，可能需要同真正的网络建立连接，否则程序不能工作——尽管实际并不通过那个网络通信）。

下面是服务器程序：

```java
//: JabberServer.java
// Very simple server that just
// echoes whatever the client sends.
import java.io.*;
import java.net.*;

public class JabberServer {  
  // Choose a port outside of the range 1-1024:
  public static final int PORT = 8080;
  public static void main(String[] args) 
      throws IOException {
    ServerSocket s = new ServerSocket(PORT);
    System.out.println("Started: " + s);
    try {
      // Blocks until a connection occurs:
      Socket socket = s.accept();
      try {
        System.out.println(
          "Connection accepted: "+ socket);
        BufferedReader in = 
          new BufferedReader(
            new InputStreamReader(
              socket.getInputStream()));
        // Output is automatically flushed
        // by PrintWriter:
        PrintWriter out = 
          new PrintWriter(
            new BufferedWriter(
              new OutputStreamWriter(
                socket.getOutputStream())),true);
        while (true) {  
          String str = in.readLine();
          if (str.equals("END")) break;
          System.out.println("Echoing: " + str);
          out.println(str);
        }
      // Always close the two sockets...
      } finally {
        System.out.println("closing...");
        socket.close();
      }
    } finally {
      s.close();
    }
  } 
} ///:~
```
可以看到，ServerSocket需要的只是一个端口编号，不需要IP地址（因为它就在这台机器上运行）。调用accept()时，方法会暂时陷入停顿状态（堵塞），直到某个客户尝试同它建立连接。换言之，尽管它在那里等候连接，但其他进程仍能正常运行（参考第14章）。建好一个连接以后，accept()就会返回一个Socket对象，它是那个连接的代表。

清除套接字的责任在这里得到了很艺术的处理。假如ServerSocket构建器失败，则程序简单地退出（注意必须保证ServerSocket的构建器在失败之后不会留下任何打开的网络套接字）。针对这种情况，main()会“掷”出一个IOException违例，所以不必使用一个try块。若ServerSocket构建器成功执行，则其他所有方法调用都必须到一个try-finally代码块里寻求保护，以确保无论块以什么方式留下，ServerSocket都能正确地关闭。

同样的道理也适用于由accept()返回的Socket。若accept()失败，那么我们必须保证Socket不再存在或者含有任何资源，以便不必清除它们。但假若执行成功，则后续的语句必须进入一个try-finally块内，以保障在它们失败的情况下，Socket仍能得到正确的清除。由于套接字使用了重要的非内存资源，所以在这里必须特别谨慎，必须自己动手将它们清除（Java中没有提供“破坏器”来帮助我们做这件事情）。

无论ServerSocket还是由accept()产生的Socket都打印到System.out里。这意味着它们的toString方法会得到自动调用。这样便产生了：
```
ServerSocket[addr=0.0.0.0,PORT=0,localport=8080]
Socket[addr=127.0.0.1,PORT=1077,localport=8080]
```
大家不久就会看到它们如何与客户程序做的事情配合。

程序的下一部分看来似乎仅仅是打开文件，以便读取和写入，只是InputStream和OutputStream是从Socket对象创建的。利用两个“转换器”类InputStreamReader和OutputStreamWriter，InputStream和OutputStream对象已经分别转换成为Java 1.1的Reader和Writer对象。也可以直接使用Java1.0的InputStream和OutputStream类，但对输出来说，使用Writer方式具有明显的优势。这一优势是通过PrintWriter表现出来的，它有一个过载的构建器，能获取第二个参数——一个布尔值标志，指向是否在每一次println()结束的时候自动刷新输出（但不适用于print()语句）。每次写入了输出内容后（写进out），它的缓冲区必须刷新，使信息能正式通过网络传递出去。对目前这个例子来说，刷新显得尤为重要，因为客户和服务器在采取下一步操作之前都要等待一行文本内容的到达。若刷新没有发生，那么信息不会进入网络，除非缓冲区满（溢出），这会为本例带来许多问题。 编写网络应用程序时，需要特别注意自动刷新机制的使用。每次刷新缓冲区时，必须创建和发出一个数据包（数据封）。就目前的情况来说，这正是我们所希望的，因为假如包内包含了还没有发出的文本行，服务器和客户机之间的相互“握手”就会停止。换句话说，一行的末尾就是一条消息的末尾。但在其他许多情况下，消息并不是用行分隔的，所以不如不用自动刷新机制，而用内建的缓冲区判决机制来决定何时发送一个数据包。这样一来，我们可以发出较大的数据包，而且处理进程也能加快。

注意和我们打开的几乎所有数据流一样，它们都要进行缓冲处理。本章末尾有一个练习，清楚展现了假如我们不对数据流进行缓冲，那么会得到什么样的后果（速度会变慢）。

无限while循环从BufferedReader in内读取文本行，并将信息写入System.out，然后写入PrintWriter.out。注意这可以是任何数据流，它们只是在表面上同网络连接。

客户程序发出包含了"END"的行后，程序会中止循环，并关闭Socket。

下面是客户程序的源码：
```java
//: JabberClient.java
// Very simple client that just sends
// lines to the server and reads lines
// that the server sends.
import java.net.*;
import java.io.*;

public class JabberClient {
  public static void main(String[] args) 
      throws IOException {
    // Passing null to getByName() produces the
    // special "Local Loopback" IP address, for
    // testing on one machine w/o a network:
    InetAddress addr = 
      InetAddress.getByName(null);
    // Alternatively, you can use 
    // the address or name:
    // InetAddress addr = 
    //    InetAddress.getByName("127.0.0.1");
    // InetAddress addr = 
    //    InetAddress.getByName("localhost");
    System.out.println("addr = " + addr);
    Socket socket = 
      new Socket(addr, JabberServer.PORT);
    // Guard everything in a try-finally to make
    // sure that the socket is closed:
    try {
      System.out.println("socket = " + socket);
      BufferedReader in =
        new BufferedReader(
          new InputStreamReader(
            socket.getInputStream()));
      // Output is automatically flushed
      // by PrintWriter:
      PrintWriter out =
        new PrintWriter(
          new BufferedWriter(
            new OutputStreamWriter(
              socket.getOutputStream())),true);
      for(int i = 0; i < 10; i ++) {
        out.println("howdy " + i);
        String str = in.readLine();
        System.out.println(str);
      }
      out.println("END");
    } finally {
      System.out.println("closing...");
      socket.close();
    }
  }
} ///:~
```
在main()中，大家可看到获得本地主机IP地址的InetAddress的三种途径：使用null，使用localhost，或者直接使用保留地址127.0.0.1。当然，如果想通过网络同一台远程主机连接，也可以换用那台机器的IP地址。打印出InetAddress addr后（通过对toString()方法的自动调用），结果如下：
```
localhost/127.0.0.1
```
通过向getByName()传递一个null，它会默认寻找localhost，并生成特殊的保留地址127.0.0.1。注意在名为socket的套接字创建时，同时使用了InetAddress以及端口号。打印这样的某个Socket对象时，为了真正理解它的含义，请记住一次独一无二的因特网连接是用下述四种数据标识的：clientHost（客户主机）、clientPortNumber（客户端口号）、serverHost（服务主机）以及serverPortNumber（服务端口号）。服务程序启动后，会在本地主机（127.0.0.1）上建立为它分配的端口（8080）。一旦客户程序发出请求，机器上下一个可用的端口就会分配给它（这种情况下是1077），这一行动也在与服务程序相同的机器（127.0.0.1）上进行。现在，为了使数据能在客户及服务程序之间来回传送，每一端都需要知道把数据发到哪里。所以在同一个“已知”服务程序连接的时候，客户会发出一个“返回地址”，使服务器程序知道将自己的数据发到哪儿。我们在服务器端的示范输出中可以体会到这一情况：

### 15.3 服务多个客户
### 15.4 数据报
### 15.5 一个Web应用
### 15.6 Java与CGI的沟通
### 15.7 用JDBC连接数据库
### 15.8 远程方法
### 15.9 总结
### 15.10 练习
