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

```
Socket[addr=127.0.0.1,port=1077,localport=8080]

```
这意味着服务器刚才已接受了来自127.0.0.1这台机器的端口1077的连接，同时监听自己的本地端口（8080）。而在客户端：
```
Socket[addr=localhost/127.0.0.1,PORT=8080,localport=1077]
```
这意味着客户已用自己的本地端口1077与127.0.0.1机器上的端口8080建立了 连接。

大家会注意到每次重新启动客户程序的时候，本地端口的编号都会增加。这个编号从1025（刚好在系统保留的1-1024之外）开始，并会一直增加下去，除非我们重启机器。若重新启动机器，端口号仍然会从1025开始增值（在Unix机器中，一旦超过保留的套按字范围，数字就会再次从最小的可用数字开始）。

创建好Socket对象后，将其转换成BufferedReader和PrintWriter的过程便与在服务器中相同（同样地，两种情况下都要从一个Socket开始）。在这里，客户通过发出字串"howdy"，并在后面跟随一个数字，从而初始化通信。注意缓冲区必须再次刷新（这是自动发生的，通过传递给PrintWriter构建器的第二个参数）。若缓冲区没有刷新，那么整个会话（通信）都会被挂起，因为用于初始化的“howdy”永远不会发送出去（缓冲区不够满，不足以造成发送动作的自动进行）。从服务器返回的每一行都会写入System.out，以验证一切都在正常运转。为中止会话，需要发出一个"END"。若客户程序简单地挂起，那么服务器会“掷”出一个违例。

大家在这里可以看到我们采用了同样的措施来确保由Socket代表的网络资源得到正确的清除，这是用一个try-finally块实现的。


套接字建立了一个“专用”连接，它会一直持续到明确断开连接为止（专用连接也可能间接性地断开，前提是某一端或者中间的某条链路出现故障而崩溃）。这意味着参与连接的双方都被锁定在通信中，而且无论是否有数据传递，连接都会连续处于开放状态。从表面看，这似乎是一种合理的连网方式。然而，它也为网络带来了额外的开销。本章后面会介绍进行连网的另一种方式。采用那种方式，连接的建立只是暂时的。

```
总结：
Service:

    // 1、此动作是开辟端口 
    ServerSocket s = new ServerSocket(PORT);

    // 2、监控开辟端口是否有 Clien 连接，有则创建 Socket，此时 Service 是阻塞于此的
    Socket socket = s.accept();

    // 创建成功的 Socket : localport 监控端口、port 连接端口（回信端口）
    // Socket[addr=127.0.0.1,port=1077,localport=8080]   

Clien:
    // 3、向指定 地址、端口 创建 Socket
    Socket socket =  new Socket(addr, port);

    // 创建成功的 Socket : localport 监控端口、port 连接端口（回信端口）
    // Socket[addr=localhost/127.0.0.1,PORT=8080,localport=1077]
```

### 15.3 服务多个客户
JabberServer可以正常工作，但每次只能为一个客户程序提供服务。在典型的服务器中，我们希望同时能处理多个客户的请求。解决这个问题的关键就是多线程处理机制。而对于那些本身不支持多线程的语言，达到这个要求无疑是异常困难的。通过第14章的学习，大家已经知道Java已对多线程的处理进行了尽可能的简化。由于Java的线程处理方式非常直接，所以让服务器控制多名客户并不是件难事。

最基本的方法是在服务器（程序）里创建单个ServerSocket，并调用accept()来等候一个新连接。一旦accept()返回，我们就取得结果获得的Socket，并用它新建一个线程，令其只为那个特定的客户服务。然后再调用accept()，等候下一次新的连接请求。

对于下面这段服务器代码，大家可发现它与JabberServer.java例子非常相似，只是为一个特定的客户提供服务的所有操作都已移入一个独立的线程类中：
```java
//: MultiJabberServer.java
// A server that uses multithreading to handle 
// any number of clients.
import java.io.*;
import java.net.*;

class ServeOneJabber extends Thread {
  private Socket socket;
  private BufferedReader in;
  private PrintWriter out;
  public ServeOneJabber(Socket s) throws IOException {
    socket = s;
    in = 
      new BufferedReader(
        new InputStreamReader(
          socket.getInputStream()));
    // Enable auto-flush:
    out = 
      new PrintWriter(
        new BufferedWriter(
          new OutputStreamWriter(
            socket.getOutputStream())), true);
    // If any of the above calls throw an 
    // exception, the caller is responsible for
    // closing the socket. Otherwise the thread
    // will close it.
    start(); // Calls run()
  }
  public void run() {
    try {
      while (true) {  
        String str = in.readLine();
        if (str.equals("END")) break;
        System.out.println("Echoing: " + str);
        out.println(str);
      }
      System.out.println("closing...");
    } catch (IOException e) {
    } finally {
      try {
        socket.close();
      } catch(IOException e) {}
    }
  }
}

public class MultiJabberServer {  
  static final int PORT = 8080;
  public static void main(String[] args)
      throws IOException {
    ServerSocket s = new ServerSocket(PORT);
    System.out.println("Server Started");
    try {
      while(true) {
        // Blocks until a connection occurs:
        Socket socket = s.accept();
        try {
          new ServeOneJabber(socket);
        } catch(IOException e) {
          // If it fails, close the socket,
          // otherwise the thread will close it:
          socket.close();
        }
      }
    } finally {
      s.close();
    }
  } 
} ///:~
```
每次有新客户请求建立一个连接时，ServeOneJabber线程都会取得由accept()在main()中生成的Socket对象。然后和往常一样，它创建一个BufferedReader，并用Socket自动刷新PrintWriter对象。最后，它调用Thread的特殊方法start()，令其进行线程的初始化，然后调用run()。这里采取的操作与前例是一样的：从套扫字读入某些东西，然后把它原样反馈回去，直到遇到一个特殊的"END"结束标志为止。

同样地，套接字的清除必须进行谨慎的设计。就目前这种情况来说，套接字是在ServeOneJabber外部创建的，所以清除工作可以“共享”。若ServeOneJabber构建器失败，那么只需向调用者“掷”出一个违例即可，然后由调用者负责线程的清除。但假如构建器成功，那么必须由ServeOneJabber对象负责线程的清除，这是在它的run()里进行的。

请注意MultiJabberServer有多么简单。和以前一样，我们创建一个ServerSocket，并调用accept()允许一个新连接的建立。但这一次，accept()的返回值（一个套接字）将传递给用于ServeOneJabber的构建器，由它创建一个新线程，并对那个连接进行控制。连接中断后，线程便可简单地消失。

如果ServerSocket创建失败，则再一次通过main()掷出违例。如果成功，则位于外层的try-finally代码块可以担保正确的清除。位于内层的try-catch块只负责防范ServeOneJabber构建器的失败；若构建器成功，则ServeOneJabber线程会将对应的套接字关掉。

为了证实服务器代码确实能为多名客户提供服务，下面这个程序将创建许多客户（使用线程），并同相同的服务器建立连接。每个线程的“存在时间”都是有限的。一旦到期，就留出空间以便创建一个新线程。允许创建的线程的最大数量是由final int maxthreads决定的。大家会注意到这个值非常关键，因为假如把它设得很大，线程便有可能耗尽资源，并产生不可预知的程序错误。

```java
//: MultiJabberClient.java
// Client that tests the MultiJabberServer
// by starting up multiple clients.
import java.net.*;
import java.io.*;

class JabberClientThread extends Thread {
  private Socket socket;
  private BufferedReader in;
  private PrintWriter out;
  private static int counter = 0;
  private int id = counter++;
  private static int threadcount = 0;
  public static int threadCount() { 
    return threadcount; 
  }
  public JabberClientThread(InetAddress addr) {
    System.out.println("Making client " + id);
    threadcount++;
    try {
      socket = 
        new Socket(addr, MultiJabberServer.PORT);
    } catch(IOException e) {
      // If the creation of the socket fails, 
      // nothing needs to be cleaned up.
    }
    try {    
      in = 
        new BufferedReader(
          new InputStreamReader(
            socket.getInputStream()));
      // Enable auto-flush:
      out = 
        new PrintWriter(
          new BufferedWriter(
            new OutputStreamWriter(
              socket.getOutputStream())), true);
      start();
    } catch(IOException e) {
      // The socket should be closed on any 
      // failures other than the socket 
      // constructor:
      try {
        socket.close();
      } catch(IOException e2) {}
    }
    // Otherwise the socket will be closed by
    // the run() method of the thread.
  }
  public void run() {
    try {
      for(int i = 0; i < 25; i++) {
        out.println("Client " + id + ": " + i);
        String str = in.readLine();
        System.out.println(str);
      }
      out.println("END");
    } catch(IOException e) {
    } finally {
      // Always close it:
      try {
        socket.close();
      } catch(IOException e) {}
      threadcount--; // Ending this thread
    }
  }
}

public class MultiJabberClient {
  static final int MAX_THREADS = 40;
  public static void main(String[] args) 
      throws IOException, InterruptedException {
    InetAddress addr = 
      InetAddress.getByName(null);
    while(true) {
      if(JabberClientThread.threadCount() 
         < MAX_THREADS)
        new JabberClientThread(addr);
      Thread.currentThread().sleep(100);
    }
  }
} ///:~
```
JabberClientThread构建器获取一个InetAddress，并用它打开一个套接字。大家可能已看出了这样的一个套路：Socket肯定用于创建某种Reader以及／或者Writer（或者InputStream和／或OutputStream）对象，这是运用Socket的唯一方式（当然，我们可考虑编写一、两个类，令其自动完成这些操作，避免大量重复的代码编写工作）。同样地，start()执行线程的初始化，并调用run()。在这里，消息发送给服务器，而来自服务器的信息则在屏幕上回显出来。然而，线程的“存在时间”是有限的，最终都会结束。注意在套接字创建好以后，但在构建器完成之前，假若构建器失败，套接字会被清除。否则，为套接字调用close()的责任便落到了run()方法的头上。

threadcount跟踪计算目前存在的JabberClientThread对象的数量。它将作为构建器的一部分增值，并在run()退出时减值（run()退出意味着线程中止）。在MultiJabberClient.main()中，大家可以看到线程的数量会得到检查。若数量太多，则多余的暂时不创建。方法随后进入“休眠”状态。这样一来，一旦部分线程最后被中止，多作的那些线程就可以创建了。大家可试验一下逐渐增大MAX_THREADS，看看对于你使用的系统来说，建立多少线程（连接）才会使您的系统资源降低到危险程度。

### 15.4 数据报

大家迄今看到的例子使用的都是“传输控制协议”（TCP），亦称作“基于数据流的套接字”。根据该协议的设计宗旨，它具有高度的可靠性，而且能保证数据顺利抵达目的地。换言之，它允许重传那些由于各种原因半路“走失”的数据。而且收到字节的顺序与它们发出来时是一样的。当然，这种控制与可靠性需要我们付出一些代价：TCP具有非常高的开销。

还有另一种协议，名为“用户数据报协议”（UDP），它并不刻意追求数据包会完全发送出去，也不能担保它们抵达的顺序与它们发出时一样。我们认为这是一种“不可靠协议”（TCP当然是“可靠协议”）。听起来似乎很糟，但由于它的速度快得多，所以经常还是有用武之地的。对某些应用来说，比如声音信号的传输，如果少量数据包在半路上丢失了，那么用不着太在意，因为传输的速度显得更重要一些。大多数互联网游戏，如Diablo，采用的也是UDP协议通信，因为网络通信的快慢是游戏是否流畅的决定性因素。也可以想想一台报时服务器，如果某条消息丢失了，那么也真的不必过份紧张。另外，有些应用也许能向服务器传回一条UDP消息，以便以后能够恢复。如果在适当的时间里没有响应，消息就会丢失。

Java对数据报的支持与它对TCP套接字的支持大致相同，但也存在一个明显的区别。对数据报来说，我们在客户和服务器程序都可以放置一个DatagramSocket（数据报套接字），但与ServerSocket不同，前者不会干巴巴地等待建立一个连接的请求。这是由于不再存在“连接”，取而代之的是一个数据报陈列出来。另一项本质的区别的是对TCP套接字来说，一旦我们建好了连接，便不再需要关心谁向谁“说话”——只需通过会话流来回传送数据即可。但对数据报来说，它的数据包必须知道自己来自何处，以及打算去哪里。这意味着我们必须知道每个数据报包的这些信息，否则信息就不能正常地传递。

DatagramSocket用于收发数据包，而DatagramPacket包含了具体的信息。准备接收一个数据报时，只需提供一个缓冲区，以便安置接收到的数据。数据包抵达时，通过DatagramSocket，作为信息起源地的因特网地址以及端口编号会自动得到初化。所以一个用于接收数据报的DatagramPacket构建器是：DatagramPacket(buf, buf.length)

其中，buf是一个字节数组。既然buf是个数组，大家可能会奇怪为什么构建器自己不能调查出数组的长度呢？实际上我也有同感，唯一能猜到的原因就是C风格的编程使然，那里的数组不能自己告诉我们它有多大。

可以重复使用数据报的接收代码，不必每次都建一个新的。每次用它的时候（再生），缓冲区内的数据都会被覆盖。

缓冲区的最大容量仅受限于允许的数据报包大小，这个限制位于比64KB稍小的地方。但在许多应用程序中，我们都宁愿它变得还要小一些，特别是在发送数据的时候。具体选择的数据包大小取决于应用程序的特定要求。

发出一个数据报时，DatagramPacket不仅需要包含正式的数据，也要包含因特网地址以及端口号，以决定它的目的地。所以用于输出DatagramPacket的构建器是：
```
DatagramPacket(buf, length, inetAddress, port)

```
这一次，buf（一个字节数组）已经包含了我们想发出的数据。length可以是buf的长度，但也可以更短一些，意味着我们只想发出那么多的字节。另两个参数分别代表数据包要到达的因特网地址以及目标机器的一个目标端口（注释②）。

②：我们认为TCP和UDP端口是相互独立的。也就是说，可以在端口8080同时运行一个TCP和UDP服务程序，两者之间不会产生冲突。

大家也许认为两个构建器创建了两个不同的对象：一个用于接收数据报，另一个用于发送它们。如果是好的面向对象的设计方案，会建议把它们创建成两个不同的类，而不是具有不同的行为的一个类（具体行为取决于我们如何构建对象）。这也许会成为一个严重的问题，但幸运的是，DatagramPacket的使用相当简单，我们不需要在这个问题上纠缠不清。这一点在下例里将有很明确的说明。该例类似于前面针对TCP套接字的MultiJabberServer和MultiJabberClient例子。多个客户都会将数据报发给服务器，后者会将其反馈回最初发出消息的同样的客户。

为简化从一个String里创建DatagramPacket的工作（或者从DatagramPacket里创建String），这个例子首先用到了一个工具类，名为Dgram：
```java
//: Dgram.java
// A utility class to convert back and forth
// Between Strings and DataGramPackets.
import java.net.*;

public class Dgram {
  public static DatagramPacket toDatagram(String s, InetAddress destIA, int destPort) {
    // Deprecated in Java 1.1, but it works:
    byte[] buf = new byte[s.length() + 1];
    s.getBytes(0, s.length(), buf, 0);
    // The correct Java 1.1 approach, but it's
    // Broken (it truncates the String):
    // byte[] buf = s.getBytes();
    return new DatagramPacket(buf, buf.length, 
      destIA, destPort);
  }
  public static String toString(DatagramPacket p){
    // The Java 1.0 approach:
    // return new String(p.getData(), 
    //  0, 0, p.getLength());
    // The Java 1.1 approach:
    return 
      new String(p.getData(), 0, p.getLength());
  }
} ///:~
```
Dgram的第一个方法采用一个String、一个InetAddress以及一个端口号作为自己的参数，将String的内容复制到一个字节缓冲区，再将缓冲区传递进入DatagramPacket构建器，从而构建一个DatagramPacket。注意缓冲区分配时的"+1"——这对防止截尾现象是非常重要的。String的getByte()方法属于一种特殊操作，能将一个字串包含的char复制进入一个字节缓冲。该方法现在已被“反对”使用；Java 1.1有一个“更好”的办法来做这个工作，但在这里却被当作注释屏蔽掉了，因为它会截掉String的部分内容。所以尽管我们在Java 1.1下编译该程序时会得到一条“反对”消息，但它的行为仍然是正确无误的（这个错误应该在你读到这里的时候修正了）。

Dgram.toString()方法同时展示了Java 1.0的方法和Java 1.1的方法（两者是不同的，因为有一种新类型的String构建器）。

下面是用于数据报演示的服务器代码：
```java
//: ChatterServer.java
// A server that echoes datagrams
import java.net.*;
import java.io.*;
import java.util.*;

public class ChatterServer {
  static final int INPORT = 1711;
  private byte[] buf = new byte[1000];
  private DatagramPacket dp = 
    new DatagramPacket(buf, buf.length);
  // Can listen & send on the same socket:
  private DatagramSocket socket;

  public ChatterServer() {
    try {
      socket = new DatagramSocket(INPORT);
      System.out.println("Server started");
      while(true) {
        // Block until a datagram appears:
        socket.receive(dp);
        String rcvd = Dgram.toString(dp) +
          ", from address: " + dp.getAddress() +
          ", port: " + dp.getPort();
        System.out.println(rcvd);
        String echoString = 
          "Echoed: " + rcvd;
        // Extract the address and port from the
        // received datagram to find out where to
        // send it back:
        DatagramPacket echo = 
          Dgram.toDatagram(echoString,
            dp.getAddress(), dp.getPort());
        socket.send(echo);
      }
    } catch(SocketException e) {
      System.err.println("Can't open socket");
      System.exit(1);
    } catch(IOException e) {
      System.err.println("Communication error");
      e.printStackTrace();
    }
  }
  public static void main(String[] args) {
    new ChatterServer();
  }
} ///:~
```
ChatterServer创建了一个用来接收消息的DatagramSocket（数据报套接字），而不是在我们每次准备接收一条新消息时都新建一个。这个单一的DatagramSocket可以重复使用。它有一个端口号，因为这属于服务器，客户必须确切知道自己把数据报发到哪个地址。尽管有一个端口号，但没有为它分配因特网地址，因为它就驻留在“这”台机器内，所以知道自己的因特网地址是什么（目前是默认的localhost）。在无限while循环中，套接字被告知接收数据（receive()）。然后暂时挂起，直到一个数据报出现，再把它反馈回我们希望的接收人——DatagramPacket dp——里面。数据包（Packet）会被转换成一个字串，同时插入的还有数据包的起源因特网地址及套接字。这些信息会显示出来，然后添加一个额外的字串，指出自己已从服务器反馈回来了。

大家可能会觉得有点儿迷惑。正如大家会看到的那样，许多不同的因特网地址和端口号都可能是消息的起源地——换言之，客户程序可能驻留在任何一台机器里（就这一次演示来说，它们都驻留在localhost里，但每个客户使用的端口编号是不同的）。为了将一条消息送回它真正的始发客户，需要知道那个客户的因特网地址以及端口号。幸运的是，所有这些资料均已非常周到地封装到发出消息的DatagramPacket内部，所以我们要做的全部事情就是用getAddress()和getPort()把它们取出来。利用这些资料，可以构建DatagramPacket echo——它通过与接收用的相同的套接字发送回来。除此以外，一旦套接字发出数据报，就会添加“这”台机器的因特网地址及端口信息，所以当客户接收消息时，它可以利用getAddress()和getPort()了解数据报来自何处。事实上，getAddress()和getPort()唯一不能告诉我们数据报来自何处的前提是：我们创建一个待发送的数据报，并在正式发出之前调用了getAddress()和getPort()。到数据报正式发送的时候，这台机器的地址以及端口才会写入数据报。所以我们得到了运用数据报时一项重要的原则：不必跟踪一条消息的来源地！因为它肯定保存在数据报里。事实上，对程序来说，最可靠的做法是我们不要试图跟踪，而是无论如何都从目标数据报里提取出地址以及端口信息（就象这里做的那样）。

为测试服务器的运转是否正常，下面这程序将创建大量客户（线程），它们都会将数据报包发给服务器，并等候服务器把它们原样反馈回来。
```java
//: ChatterServer.java
// A server that echoes datagrams
import java.net.*;
import java.io.*;
import java.util.*;

public class ChatterServer {
  static final int INPORT = 1711;
  private byte[] buf = new byte[1000];
  private DatagramPacket dp = 
    new DatagramPacket(buf, buf.length);
  // Can listen & send on the same socket:
  private DatagramSocket socket;

  public ChatterServer() {
    try {
      socket = new DatagramSocket(INPORT);
      System.out.println("Server started");
      while(true) {
        // Block until a datagram appears:
        socket.receive(dp);
        String rcvd = Dgram.toString(dp) +
          ", from address: " + dp.getAddress() +
          ", port: " + dp.getPort();
        System.out.println(rcvd);
        String echoString = 
          "Echoed: " + rcvd;
        // Extract the address and port from the
        // received datagram to find out where to
        // send it back:
        DatagramPacket echo = 
          Dgram.toDatagram(echoString,
            dp.getAddress(), dp.getPort());
        socket.send(echo);
      }
    } catch(SocketException e) {
      System.err.println("Can't open socket");
      System.exit(1);
    } catch(IOException e) {
      System.err.println("Communication error");
      e.printStackTrace();
    }
  }
  public static void main(String[] args) {
    new ChatterServer();
  }
} ///:~
```
ChatterClient被创建成一个线程（Thread），所以可以用多个客户来“骚扰”服务器。从中可以看到，用于接收的DatagramPacket和用于ChatterServer的那个是相似的。在构建器中，创建DatagramPacket时没有附带任何参数（自变量），因为它不需要明确指出自己位于哪个特定编号的端口里。用于这个套接字的因特网地址将成为“这台机器”（比如localhost），而且会自动分配端口编号，这从输出结果即可看出。同用于服务器的那个一样，这个DatagramPacket将同时用于发送和接收。

hostAddress是我们想与之通信的那台机器的因特网地址。在程序中，如果需要创建一个准备传出去的DatagramPacket，那么必须知道一个准确的因特网地址和端口号。可以肯定的是，主机必须位于一个已知的地址和端口号上，使客户能启动与主机的“会话”。

每个线程都有自己独一无二的标识号（尽管自动分配给线程的端口号是也会提供一个唯一的标识符）。在run()中，我们创建了一个String消息，其中包含了线程的标识编号以及该线程准备发送的消息编号。我们用这个字串创建一个数据报，发到主机上的指定地址；端口编号则直接从ChatterServer内的一个常数取得。一旦消息发出，receive()就会暂时被“堵塞”起来，直到服务器回复了这条消息。与消息附在一起的所有信息使我们知道回到这个特定线程的东西正是从始发消息中投递出去的。在这个例子中，尽管是一种“不可靠”协议，但仍然能够检查数据报是否到去过了它们该去的地方（这在localhost和LAN环境中是成立的，但在非本地连接中却可能出现一些错误）。

运行该程序时，大家会发现每个线程都会结束。这意味着发送到服务器的每个数据报包都会回转，并反馈回正确的接收者。如果不是这样，一个或更多的线程就会挂起并进入“堵塞”状态，直到它们的输入被显露出来。

大家或许认为将文件从一台机器传到另一台的唯一正确方式是通过TCP套接字，因为它们是“可靠”的。然而，由于数据报的速度非常快，所以它才是一种更好的选择。我们只需将文件分割成多个数据报，并为每个包编号。接收机器会取得这些数据包，并重新“组装”它们；一个“标题包”会告诉机器应该接收多少个包，以及组装所需的另一些重要信息。如果一个包在半路“走丢”了，接收机器会返回一个数据报，告诉发送者重传。

### 15.5 一个Web应用
现在让我们想想如何创建一个应用，令其在真实的Web环境中运行，它将把Java的优势表现得淋漓尽致。这个应用的一部分是在Web服务器上运行的一个Java程序，另一部分则是一个“程序片”或“小应用程序”（Applet），从服务器下载至浏览器（即“客户”）。这个程序片从用户那里收集信息，并将其传回Web服务器上运行的应用程序。程序的任务非常简单：程序片会询问用户的E-mail地址，并在验证这个地址合格后（没有包含空格，而且有一个@符号），将该E-mail发送给Web服务器。服务器上运行的程序则会捕获传回的数据，检查一个包含了所有E-mail地址的数据文件。如果那个地址已包含在文件里，则向浏览器反馈一条消息，说明这一情况。该消息由程序片负责显示。若是一个新地址，则将其置入列表，并通知程序片已成功添加了电子函件地址。

若采用传统方式来解决这个问题，我们要创建一个包含了文本字段及一个“提交”（Submit）按钮的HTML页。用户可在文本字段里键入自己喜欢的任何内容，并毫无阻碍地提交给服务器（在客户端不进行任何检查）。提交数据的同时，Web页也会告诉服务器应对数据采取什么样的操作——知会“通用网关接口”（CGI）程序，收到这些数据后立即运行服务器。这种CGI程序通常是用Perl或C写的（有时也用C++，但要求服务器支持），而且必须能控制一切可能出现的情况。它首先会检查数据，判断是否采用了正确的格式。若答案是否定的，则CGI程序必须创建一个HTML页，对遇到的问题进行描述。这个页会转交给服务器，再由服务器反馈回用户。用户看到出错提示后，必须再试一遍提交，直到通过为止。若数据正确，CGI程序会打开数据文件，要么把电子函件地址加入文件，要么指出该地址已在数据文件里了。无论哪种情况，都必须格式化一个恰当的HTML页，以便服务器返回给用户。

作为Java程序员，上述解决问题的方法显得非常笨拙。而且很自然地，我们希望一切工作都用Java完成。首先，我们会用一个Java程序片负责客户端的数据有效性校验，避免数据在服务器和客户之间传来传去，浪费时间和带宽，同时减轻服务器额外构建HTML页的负担。然后跳过Perl CGI脚本，换成在服务器上运行一个Java应用。事实上，我们在这儿已完全跳过了Web服务器，仅仅需要从程序片到服务器上运行的Java应用之间建立一个连接即可。

正如大家不久就会体验到的那样，尽管看起来非常简单，但实际上有一些意想不到的问题使局面显得稍微有些复杂。用Java 1.1写程序片是最理想的，但实际上却经常行不通。到本书写作的时候，拥有Java 1.1能力的浏览器仍为数不多，而且即使这类浏览器现在非常流行，仍需考虑照顾一下那些升级缓慢的人。所以从安全的角度看，程序片代码最好只用Java 1.0编写。基于这一前提，我们不能用JAR文件来合并（压缩）程序片中的.class文件。所以，我们应尽可能减少.class文件的使用数量，以缩短下载时间。 好了，再来说说我用的Web服务器（写这个示范程序时用的就是它）。它确实支持Java，但仅限于Java 1.0！所以服务器应用也必须用Java 1.0编写。

#### 15.5.1 服务器应用

现在讨论一下服务器应用（程序）的问题，我把它叫作NameCollecor（名字收集器）。假如多名用户同时尝试提交他们的E-mail地址，那么会发生什么情况呢？若NameCollector使用TCP/IP套接字，那么必须运用早先介绍的多线程机制来实现对多个客户的并发控制。但所有这些线程都试图把数据写到同一个文件里，其中保存了所有E-mail地址。这便要求我们设立一种锁定机制，保证多个线程不会同时访问那个文件。一个“信号机”可在这里帮助我们达到目的，但或许还有一种更简单的方式。

如果我们换用数据报，就不必使用多线程了。用单个数据报即可“侦听”进入的所有数据报。一旦监视到有进入的消息，程序就会进行适当的处理，并将答复数据作为一个数据报传回原先发出请求的那名接收者。若数据报半路上丢失了，则用户会注意到没有答复数据传回，所以可以重新提交请求。

服务器应用收到一个数据报，并对它进行解读的时候，必须提取出其中的电子函件地址，并检查本机保存的数据文件，看看里面是否已经包含了那个地址（如果没有，则添加之）。所以我们现在遇到了一个新的问题。Java 1.0似乎没有足够的能力来方便地处理包含了电子函件地址的文件（Java 1.1则不然）。但是，用C轻易就可以解决这个问题。因此，我们在这儿有机会学习将一个非Java程序同Java程序连接的最简便方式。程序使用的Runtime对象包含了一个名为exec()的方法，它会独立机器上一个独立的程序，并返回一个Process（进程）对象。我们可以取得一个OutputStream，它同这个单独程序的标准输入连接在一起；并取得一个InputStream，它则同标准输出连接到一起。要做的全部事情就是用任何语言写一个程序，只要它能从标准输入中取得自己的输入数据，并将输出结果写入标准输出即可。如果有些问题不能用Java简便与快速地解决（或者想利用原有代码，不想改写），就可以考虑采用这种方法。亦可使用Java的“固有方法”（Native Method），但那要求更多的技巧，大家可以参考一下附录A。

1. C程序

这个非Java应用是用C写成，因为Java不适合作CGI编程；起码启动的时间不能让人满意。它的任务是管理电子函件（E-mail）地址的一个列表。标准输入会接受一个E-mail地址，程序会检查列表中的名字，判断是否存在那个地址。若不存在，就将其加入，并报告操作成功。但假如名字已在列表里了，就需要指出这一点，避免重复加入。大家不必担心自己不能完全理解下列代码的含义。它仅仅是一个演示程序，告诉你如何用其他语言写一个程序，并从Java中调用它。在这里具体采用何种语言并不重要，只要能够从标准输入中读取数据，并能写入标准输出即可。
```c
//: Listmgr.c
// Used by NameCollector.java to manage 
// the email list file on the server
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define BSIZE 250

int alreadyInList(FILE* list, char* name) {
  char lbuf[BSIZE];
  // Go to the beginning of the list:
  fseek(list, 0, SEEK_SET);
  // Read each line in the list:
  while(fgets(lbuf, BSIZE, list)) {
    // Strip off the newline:
    char * newline = strchr(lbuf, '\n');
    if(newline != 0) 
      *newline = '\0';
    if(strcmp(lbuf, name) == 0)
      return 1;
  }
  return 0;
}

int main() {
  char buf[BSIZE];
  FILE* list = fopen("emlist.txt", "a+t");
  if(list == 0) {
    perror("could not open emlist.txt");
    exit(1);
  }
  while(1) {
    gets(buf); /* From stdin */
    if(alreadyInList(list, buf)) {
      printf("Already in list: %s", buf);
      fflush(stdout);
    }
    else {
      fseek(list, 0, SEEK_END);
      fprintf(list, "%s\n", buf);
      fflush(list);
      printf("%s added to list", buf);
      fflush(stdout);
    }
  }
} ///:~
```
该程序假设C编译器能接受'//'样式注释（许多编译器都能，亦可换用一个C++编译器来编译这个程序）。如果你的编译器不能接受，则简单地将那些注释删掉即可。

文件中的第一个函数检查我们作为第二个参数（指向一个char的指针）传递给它的名字是否已在文件中。在这儿，我们将文件作为一个FILE指针传递，它指向一个已打开的文件（文件是在main()中打开的）。函数fseek()在文件中遍历；我们在这儿用它移至文件开头。fgets()从文件list中读入一行内容，并将其置入缓冲区lbuf——不会超过规定的缓冲区长度BSIZE。所有这些工作都在一个while循环中进行，所以文件中的每一行都会读入。接下来，用strchr()找到新行字符，以便将其删掉。最后，用strcmp()比较我们传递给函数的名字与文件中的当前行。若找到一致的内容，strcmp()会返回0。函数随后会退出，并返回一个

1，指出该名字已经在文件里了（注意这个函数找到相符内容后会立即返回，不会把时间浪费在检查列表剩余内容的上面）。如果找遍列表都没有发现相符的内容，则函数返回0。

在main()中，我们用fopen()打开文件。第一个参数是文件名，第二个是打开文件的方式；a+表示“追加”，以及“打开”（或“创建”，假若文件尚不存在），以便到文件的末尾进行更新。fopen()函数返回的是一个FILE指针；若为0，表示打开操作失败。此时需要用perror()打印一条出错提示消息，并用exit()中止程序运行。

如果文件成功打开，程序就会进入一个无限循环。调用gets(buf)的函数会从标准输入中取出一行（记住标准输入会与Java程序连接到一起），并将其置入缓冲区buf中。缓冲区的内容随后会简单地传递给alreadyInList()函数，如内容已在列表中，printf()就会将那条消息发给标准输出（Java程序正在监视它）。fflush()用于对输出缓冲区进行刷新。

如果名字不在列表中，就用fseek()移到列表末尾，并用fprintf()将名字“打印”到列表末尾。随后，用printf()指出名字已成功加入列表（同样需要刷新标准输出），无限循环返回，继续等候一个新名字的进入。

记住一般不能先在自己的计算机上编译此程序，再把编译好的内容上载到Web服务器，因为那台机器使用的可能是不同类的处理器和操作系统。例如，我的Web服务器安装的是Intel的CPU，但操作系统是Linux，所以必须先下载源码，再用远程命令（通过telnet）指挥Linux自带的C编译器，令其在服务器端编译好程序。

1. Java程序

这个程序先启动上述的C程序，再建立必要的连接，以便同它“交谈”。随后，它创建一个数据报套接字，用它“监视”或者“侦听”来自程序片的数据报包。
```java
//: NameCollector.java
// Extracts email names from datagrams and stores
// them inside a file, using Java 1.02.
import java.net.*;
import java.io.*;
import java.util.*;

public class NameCollector {
  final static int COLLECTOR_PORT = 8080;
  final static int BUFFER_SIZE = 1000;
  byte[] buf = new byte[BUFFER_SIZE];
  DatagramPacket dp = 
    new DatagramPacket(buf, buf.length);
  // Can listen & send on the same socket:
  DatagramSocket socket;
  Process listmgr;
  PrintStream nameList;
  DataInputStream addResult;
  public NameCollector() {
    try {
      listmgr =
        Runtime.getRuntime().exec("listmgr.exe");
      nameList = new PrintStream(
        new BufferedOutputStream(
          listmgr.getOutputStream()));
      addResult = new DataInputStream(
        new BufferedInputStream(
          listmgr.getInputStream()));

    } catch(IOException e) {
      System.err.println(
        "Cannot start listmgr.exe");
      System.exit(1);
    }
    try {
      socket =
        new DatagramSocket(COLLECTOR_PORT);
      System.out.println(
        "NameCollector Server started");
      while(true) {
        // Block until a datagram appears:
        socket.receive(dp);
        String rcvd = new String(dp.getData(),
            0, 0, dp.getLength());
        // Send to listmgr.exe standard input:
        nameList.println(rcvd.trim());
        nameList.flush();
        byte[] resultBuf = new byte[BUFFER_SIZE];
        int byteCount = 
          addResult.read(resultBuf);
        if(byteCount != -1) {
          String result = 
            new String(resultBuf, 0).trim();
          // Extract the address and port from 
          // the received datagram to find out 
          // where to send the reply:
          InetAddress senderAddress =
            dp.getAddress();
          int senderPort = dp.getPort();
          byte[] echoBuf = new byte[BUFFER_SIZE];
          result.getBytes(
            0, byteCount, echoBuf, 0);
          DatagramPacket echo =
            new DatagramPacket(
              echoBuf, echoBuf.length,
              senderAddress, senderPort);
          socket.send(echo);
        }
        else
          System.out.println(
            "Unexpected lack of result from " +
            "listmgr.exe");
      }
    } catch(SocketException e) {
      System.err.println("Can't open socket");
      System.exit(1);
    } catch(IOException e) {
      System.err.println("Communication error");
      e.printStackTrace();
    }
  }
  public static void main(String[] args) {
    new NameCollector();
  }
} ///:~
```
NameCollector中的第一个定义应该是大家所熟悉的：选定端口，创建一个数据报包，然后创建指向一个DatagramSocket的句柄。接下来的三个定义负责与C程序的连接：一个Process对象是C程序由Java程序启动之后返回的，而且那个Process对象产生了InputStream和OutputStream，分别代表C程序的标准输出和标准输入。和Java IO一样，它们理所当然地需要“封装”起来，所以我们最后得到的是一个PrintStream和DataInputStream。

这个程序的所有工作都是在构建器内进行的。为启动C程序，需要取得当前的Runtime对象。我们用它调用exec()，再由后者返回Process对象。在Process对象中，大家可看到通过一简单的调用即可生成数据流：getOutputStream()和getInputStream()。从这个时候开始，我们需要考虑的全部事情就是将数据传给数据流nameList，并从addResult中取得结果。

和往常一样，我们将DatagramSocket同一个端口连接到一起。在无限while循环中，程序会调用receive()——除非一个数据报到来，否则receive()会一起处于“堵塞”状态。数据报出现以后，它的内容会提取到String rcvd里。我们首先将该字串两头的空格剔除（trim），再将其发给C程序。如下所示：

```
nameList.println(rcvd.trim());
```
之所以能这样编码，是因为Java的exec()允许我们访问任何可执行模块，只要它能从标准输入中读，并能向标准输出中写。还有另一些方式可与非Java代码“交谈”，这将在附录A中讨论。

从C程序中捕获结果就显得稍微麻烦一些。我们必须调用read()，并提供一个缓冲区，以便保存结果。read()的返回值是来自C程序的字节数。若这个值为-1，意味着某个地方出现了问题。否则，我们就将resultBuf（结果缓冲区）转换成一个字串，然后同样清除多余的空格。随后，这个字串会象往常一样进入一个DatagramPacket，并传回当初发出请求的那个同样的地址。注意发送方的地址也是我们接收到的DatagramPacket的一部分。

记住尽管C程序必须在Web服务器上编译，但Java程序的编译场所可以是任意的。这是由于不管使用的是什么硬件平台和操作系统，编译得到的字节码都是一样的。就就是Java的“跨平台”兼容能力。

#### 15.5.2 NameSender程序片

正如早先指出的那样，程序片必须用Java 1.0编写，使其能与绝大多数的浏览器适应。也正是由于这个原因，我们产生的类数量应尽可能地少。所以我们在这儿不考虑使用前面设计好的Dgram类，而将数据报的所有维护工作都转到代码行中进行。此外，程序片要用一个线程监视由服务器传回的响应信息，而非实现Runnable接口，用集成到程序片的一个独立线程来做这件事情。当然，这样做对代码的可读性不利，但却能产生一个单类（以及单个服务器请求）程序片：
```java
//: NameSender.java
// An applet that sends an email address
// as a datagram, using Java 1.02.
import java.awt.*;
import java.applet.*;
import java.net.*;
import java.io.*;

public class NameSender extends Applet 
    implements Runnable {
  private Thread pl = null;
  private Button send = new Button(
    "Add email address to mailing list");
  private TextField t = new TextField(
    "type your email address here", 40);
  private String str = new String();
  private Label 
    l = new Label(), l2 = new Label();
  private DatagramSocket s; 
  private InetAddress hostAddress;
  private byte[] buf = 
    new byte[NameCollector.BUFFER_SIZE];
  private DatagramPacket dp =
    new DatagramPacket(buf, buf.length);
  private int vcount = 0;
  public void init() {
    setLayout(new BorderLayout());
    Panel p = new Panel();
    p.setLayout(new GridLayout(2, 1));
    p.add(t);
    p.add(send);
    add("North", p);
    Panel labels = new Panel();
    labels.setLayout(new GridLayout(2, 1));
    labels.add(l);
    labels.add(l2);
    add("Center", labels);
    try {
      // Auto-assign port number:
      s = new DatagramSocket();
      hostAddress = InetAddress.getByName(
        getCodeBase().getHost());
    } catch(UnknownHostException e) {
      l.setText("Cannot find host");
    } catch(SocketException e) {
      l.setText("Can't open socket");
    } 
    l.setText("Ready to send your email address");
  }
  public boolean action (Event evt, Object arg) {
    if(evt.target.equals(send)) {
      if(pl != null) {
        // pl.stop(); Deprecated in Java 1.2
        Thread remove = pl;
        pl = null;
        remove.interrupt();
      }
      l2.setText("");
      // Check for errors in email name:
      str = t.getText().toLowerCase().trim();
      if(str.indexOf(' ') != -1) {
        l.setText("Spaces not allowed in name");
        return true;
      }
      if(str.indexOf(',') != -1) {
        l.setText("Commas not allowed in name");
        return true;
      }
      if(str.indexOf('@') == -1) {
        l.setText("Name must include '@'");
        l2.setText("");
        return true;
      }
      if(str.indexOf('@') == 0) {
        l.setText("Name must preceed '@'");
        l2.setText("");
        return true;
      }
      String end = 
        str.substring(str.indexOf('@'));
      if(end.indexOf('.') == -1) {
        l.setText("Portion after '@' must " +
          "have an extension, such as '.com'");
        l2.setText("");
        return true;
      }
      // Everything's OK, so send the name. Get a
      // fresh buffer, so it's zeroed. For some 
      // reason you must use a fixed size rather
      // than calculating the size dynamically:
      byte[] sbuf = 
        new byte[NameCollector.BUFFER_SIZE];
      str.getBytes(0, str.length(), sbuf, 0);
      DatagramPacket toSend =
        new DatagramPacket(
          sbuf, 100, hostAddress,
          NameCollector.COLLECTOR_PORT);
      try {
        s.send(toSend);
      } catch(Exception e) {
        l.setText("Couldn't send datagram");
        return true;
      }
      l.setText("Sent: " + str);
      send.setLabel("Re-send");
      pl = new Thread(this);
      pl.start();
      l2.setText(
        "Waiting for verification " + ++vcount);
    }
    else return super.action(evt, arg);
    return true;
  }
  // The thread portion of the applet watches for
  // the reply to come back from the server:
  public void run() {
    try {
      s.receive(dp);
    } catch(Exception e) {
      l2.setText("Couldn't receive datagram");
      return;
    }
    l2.setText(new String(dp.getData(),
      0, 0, dp.getLength()));
  }
} ///:~
```

程序片的UI（用户界面）非常简单。它包含了一个TestField（文本字段），以便我们键入一个电子函件地址；以及一个Button（按钮），用于将地址发给服务器。两个Label（标签）用于向用户报告状态信息。

到现在为止，大家已能判断出DatagramSocket、InetAddress、缓冲区以及DatagramPacket都属于网络连接中比较麻烦的部分。最后，大家可看到run()方法实现了线程部分，使程序片能够“侦听”由服务器传回的响应信息。

init()方法用大家熟悉的布局工具设置GUI，然后创建DatagramSocket，它将同时用于数据报的收发。

action()方法只负责监视我们是否按下了“发送”（send）按钮。记住，我们已被限制在Java 1.0上面，所以不能再用较灵活的内部类了。按钮按下以后，采取的第一项行动便是检查线程pl，看看它是否为null（空）。如果不为null，表明有一个活动线程正在运行。消息首次发出时，会启动一个新线程，用它监视来自服务器的回应。所以假若有个线程正在运行，就意味着这并非用户第一次发送消息。pl句柄被设为null，同时中止原来的监视者（这是最合理的一种做法，因为stop()已被Java 1.2“反对”，这在前一章已解释过了）。

无论这是否按钮被第一次按下，I2中的文字都会清除。

下一组语句将检查E-mail名字是否合格。String.indexOf()方法的作用是搜索其中的非法字符。如果找到一个，就把情况报告给用户。注意进行所有这些工作时，都不必涉及网络通信，所以速度非常快，而且不会影响带宽和服务器的性能。

名字校验通过以后，它会打包到一个数据报里，然后采用与前面那个数据报示例一样的方式发到主机地址和端口编号。第一个标签会发生变化，指出已成功发送出去。而且按钮上的文字也会改变，变成“重发”（resend）。这时会启动线程，第二个标签则会告诉我们程序片正在等候来自服务器的回应。

线程的run()方法会利用NameSender中包含的DatagramSocket来接收数据（receive()），除非出现来自服务器的数据报包，否则receive()会暂时处于“堵塞”或者“暂停”状态。结果得到的数据包会放进NameSender的DatagramPacketdp中。数据会从包中提取出来，并置入NameSender的第二个标签。随后，线程的执行将中断，成为一个“死”线程。若某段时间里没有收到来自服务器的回应，用户可能变得不耐烦，再次按下按钮。这样做会中断当前线程（数据发出以后，会再建一个新的）。由于用一个线程来监视回应数据，所以用户在监视期间仍然可以自由使用UI。

- Web页

当然，程序片必须放到一个Web页里。下面列出完整的Web页源码；稍微研究一下就可看出，我用它从自己开办的邮寄列表（Mailling List）里自动收集名字。
```haml
<HTML>
<HEAD>
<META CONTENT="text/html">
<TITLE>
Add Yourself to Bruce Eckel's Java Mailing List
</TITLE>
</HEAD>
<BODY LINK="#0000ff" VLINK="#800080" BGCOLOR="#ffffff">
<FONT SIZE=6><P>
Add Yourself to Bruce Eckel's Java Mailing List
</P></FONT>
The applet on this page will automatically add your email address to the mailing list, so you will receive update information about changes to the online version of "Thinking in Java," notification when the book is in print, information about upcoming Java seminars, and notification about the “Hands-on Java Seminar” Multimedia CD. Type in your email address and press the button to automatically add yourself to this mailing list. <HR>
<applet code=NameSender width=400 height=100>
</applet>
<HR>
If after several tries, you do not get verification it means that the Java application on the server is having problems. In this case, you can add yourself to the list by sending email to 
<A HREF="mailto:Bruce@EckelObjects.com">
Bruce@EckelObjects.com</A>
</BODY>
</HTML>
```
程序片标记（）的使用非常简单，和第13章展示的那一个并没有什么区别。

#### 15.5.3 要注意的问题
前面采取的似乎是一种完美的方法。没有CGI编程，所以在服务器启动一个CGI程序时不会出现延迟。数据报方式似乎能产生非常快的响应。此外，一旦Java 1.1得到绝大多数人的采纳，服务器端的那一部分就可完全用Java编写（尽管利用标准输入和输出同一个非Java程序连接也非常容易）。

但必须注意到一些问题。其中一个特别容易忽略：由于Java应用在服务器上是连续运行的，而且会把大多数时间花在Datagram.receive()方法的等候上面，这样便为CPU带来了额外的开销。至少，我在自己的服务器上便发现了这个问题。另一方面，那个服务器上不会发生其他更多的事情。而且假如我们使用一个任务更为繁重的服务器，启动程序用“nice”（一个Unix程序，用于防止进程贪吃CPU资源）或其他等价程序即可解决问题。在许多情况下，都有必要留意象这样的一些应用——一个堵塞的receive()完全可能造成CPU的瘫痪。

第二个问题涉及防火墙。可将防火墙理解成自己的本地网与因特网之间的一道墙（实际是一个专用机器或防火墙软件）。它监视进出因特网的所有通信，确保这些通信不违背预设的规则。

防火墙显得多少有些保守，要求严格遵守所有规则。假如没有遵守，它们会无情地把它们拒之门外。例如，假设我们位于防火墙后面的一个网络中，开始用Web浏览器同因特网连接，防火墙要求所有传输都用可以接受的http端口同服务器连接，这个端口是80。现在来了这个Java程序片NameSender，它试图将一个数据报传到端口8080，这是为了越过“受保护”的端口范围0-1024而设置的。防火墙很自然地把它想象成最坏的情况——有人使用病毒或者非法扫描端口——根本不允许传输的继续进行。

只要我们的客户建立的是与因特网的原始连接（比如通过典型的ISP接驳Internet），就不会出现此类防火墙问题。但也可能有一些重要的客户隐藏在防火墙后，他们便不能使用我们设计的程序。

在学过有关Java的这么多东西以后，这是一件使人相当沮丧的事情，因为看来必须放弃在服务器上使用Java，改为学习如何编写C或Perl脚本程序。但请大家不要绝望。

一个出色方案是由Sun公司提出的。如一切按计划进行，Web服务器最终都装备“小服务程序”或者“服务程序片”（Servlet）。它们负责接收来自客户的请求（经过防火墙允许的80端口）。而且不再是启动一个CGI程序，它们会启动小服务程序。根据Sun的设想，这些小服务程序都是用Java编写的，而且只能在服务器上运行。运行这种小程序的服务器会自动启动它们，令其对客户的请求进行处理。这意味着我们的所有程序都可以用Java写成（100%纯咖啡）。这显然是一种非常吸引人的想法：一旦习惯了Java，就不必换用其他语言在服务器上处理客户请求。

由于只能在服务器上控制请求，所以小服务程序API没有提供GUI功能。这对NameCollector.java来说非常适合，它本来就不需要任何图形界面。

在本书写作时，java.sun.com已提供了一个非常廉价的小服务程序专用服务器。Sun鼓励其他Web服务器开发者为他们的服务器软件产品加入对小服务程序的支持。

### 15.6 Java与CGI的沟通

### 15.7 用JDBC连接数据库

### 15.8 远程方法
为通过网络执行其他机器上的代码，传统的方法不仅难以学习和掌握，也极易出错。思考这个问题最佳的方式是：某些对象正好位于另一台机器，我们可向它们发送一条消息，并获得返回结果，就象那些对象位于自己的本地机器一样。Java 1.1的“远程方法调用”（RMI）采用的正是这种抽象。本节将引导大家经历一些必要的步骤，创建自己的RMI对象。

#### 15.8.1 远程接口概念

RMI对接口有着强烈的依赖。在需要创建一个远程对象的时候，我们通过传递一个接口来隐藏基层的实施细节。所以客户得到远程对象的一个句柄时，它们真正得到的是接口句柄。这个句柄正好同一些本地的根代码连接，由后者负责通过网络通信。但我们并不关心这些事情，只需通过自己的接口句柄发送消息即可。

创建一个远程接口时，必须遵守下列规则：

(1) 远程接口必须为public属性（不能有“包访问”；也就是说，它不能是“友好的”）。否则，一旦客户试图装载一个实现了远程接口的远程对象，就会得到一个错误。

(2) 远程接口必须扩展接口java.rmi.Remote。

(3) 除与应用程序本身有关的违例之外，远程接口中的每个方法都必须在自己的throws从句中声明java.rmi.RemoteException。

(4) 作为参数或返回值传递的一个远程对象（不管是直接的，还是在本地对象中嵌入）必须声明为远程接口，不可声明为实施类。

下面是一个简单的远程接口示例，它代表的是一个精确计时服务：
```java
//: PerfectTimeI.java
// The PerfectTime remote interface
package c15.ptime;
import java.rmi.*;

interface PerfectTimeI extends Remote {
  long getPerfectTime() throws RemoteException;
} ///:~
```
它表面上与其他接口是类似的，只是对Remote进行了扩展，而且它的所有方法都会“掷”出RemoteException（远程违例）。记住接口和它所有的方法都是public的。

#### 15.8.2 远程接口的实施

服务器必须包含一个扩展了UnicastRemoteObject的类，并实现远程接口。这个类也可以含有附加的方法，但客户只能使用远程接口中的方法。这是显然的，因为客户得到的只是指向接口的一个句柄，而非实现它的那个类。

必须为远程对象明确定义构建器，即使只准备定义一个默认构建器，用它调用基础类构建器。必须把它明确地编写出来，因为它必须“掷”出RemoteException违例。

下面列出远程接口PerfectTime的实施过程：
```java
//: PerfectTime.java
// The implementation of the PerfectTime 
// remote object
package c15.ptime;
import java.rmi.*;
import java.rmi.server.*;
import java.rmi.registry.*;
import java.net.*;

public class PerfectTime 
    extends UnicastRemoteObject
    implements PerfectTimeI {
  // Implementation of the interface:
  public long getPerfectTime() 
      throws RemoteException {
    return System.currentTimeMillis();
  }
  // Must implement constructor to throw
  // RemoteException:
  public PerfectTime() throws RemoteException {
    // super(); // Called automatically
  }
  // Registration for RMI serving:
  public static void main(String[] args) {
    System.setSecurityManager(
      new RMISecurityManager());
    try {
      PerfectTime pt = new PerfectTime();
      Naming.bind(
        "//colossus:2005/PerfectTime", pt);
      System.out.println("Ready to do time");
    } catch(Exception e) {
      e.printStackTrace();
    }
  }
} ///:~
```
在这里，main()控制着设置服务器的全部细节。保存RMI对象时，必须在程序的某个地方采取下述操作：

(1) 创建和安装一个安全管理器，令其支持RMI。作为Java发行包的一部分，适用于RMI唯一一个是RMISecurityManager。

(2) 创建远程对象的一个或多个实例。在这里，大家可看到创建的是PerfectTime对象。

(3) 向RMI远程对象注册表注册至少一个远程对象。一个远程对象拥有的方法可生成指向其他远程对象的句柄。这样一来，客户只需到注册表里访问一次，得到第一个远程对象即可。

- 设置注册表

在这儿，大家可看到对静态方法Naming.bind()的一个调用。然而，这个调用要求注册表作为计算机上的一个独立进程运行。注册表服务器的名字是rmiregistry。在32位Windows环境中，可使用：
```
start rmiregistry
```
令其在后台运行。在Unix中，使用：
```
rmiregistry &
```
和许多网络程序一样，rmiregistry 位于机器启动它所在的某个IP地址处，但它也必须监视一个端口。如果象上面那样调用 rmiregistry，不使用参数，注册表的端口就会默认为1099。若希望它位于其他某个端口，只需在命令行添加一个参数，指定那个端口编号即可。对这个例子来说，端口将位于2005，所以rmiregistry应该象下面这样启动（对于32位Windows）：

```
start rmiregistry 2005
```
对于Unix，则使用下述命令：
```
rmiregistry 2005 &
```
与端口有关的信息必须传送给bind()命令，同时传送的还有注册表所在的那台机器的IP地址。但假若我们想在本地测试RMI程序，就象本章的网络程序一直测试的那样，这样做就会带来问题。在JDK 1.1.1版本中，存在着下述两方面的问题（注释⑦）：

(1) localhost不能随RMI工作。所以为了在单独一台机器上完成对RMI的测试，必须提供机器的名字。为了在32位Windows环境中调查自己机器的名字，可进入控制面板，选择“网络”，选择“标识”卡片，其中列出了计算机的名字。就我自己的情况来说，我的机器叫作“Colossus”（因为我用几个大容量的硬盘保存各种不同的开发系统——Clossus是“巨人”的意思）。似乎大写形式会被忽略。

(2) 除非计算机有一个活动的TCP/IP连接，否则RMI不能工作，即使所有组件都只需要在本地机器里互相通信。这意味着在试图运行程序之前，必须连接到自己的ISP（因特网服务提供者），否则会得到一些含义模糊的违例消息。

⑦：为找出这些信息，我不知损伤了多少个脑细胞。

考虑到这些因素，bind()命令变成了下面这个样子：
```
Naming.bind("//colossus:2005/PerfectTime", pt);
```
若使用默认端口1099，就没有必要指定一个端口，所以可以使用：
```
Naming.bind("//colossus/PerfectTime", pt);

```
在JDK未来的版本中（1.1之后），一旦改正了localhost的问题，就能正常地进行本地测试，去掉IP地址，只使用标识符： Naming.bind("PerfectTime", pt);

服务名是任意的；它在这里正好为PerfectTime，和类名一样，但你可以根据情况任意修改。最重要的是确保它在注册表里是个独一无二的名字，以便客户正常地获取远程对象。若这个名字已在注册表里了，就会得到一个AlreadyBoundException违例。为防止这个问题，可考虑坚持使用rebind()，放弃bind()。这是由于rebind()要么会添加一个新条目，要么将同名的条目替换掉。 尽管main()退出，我们的对象已经创建并注册，所以会由注册表一直保持活动状态，等候客户到达并发出对它的请求。只要rmiregistry处于运行状态，而且我们没有为名字调用Naming.unbind()方法，对象就肯定位于那个地方。考虑到这个原因，在我们设计自己的代码时，需要先关闭rmiregistry，并在编译远程对象的一个新版本时重新启动它。

并不一定要将rmiregistry作为一个外部进程启动。若事前知道自己的是要求用以注册表的唯一一个应用，就可在程序内部启动它，使用下述代码：
```
LocateRegistry.createRegistry(2005);
```
和前面一样，2005代表我们在这个例子里选用的端口号。这等价于在命令行执行rmiregistry 2005。但在设计RMI代码时，这种做法往往显得更加方便，因为它取消了启动和中止注册表所需的额外步骤。一旦执行完这个代码，就可象以前一样使用Naming进行“绑定”——bind()。

#### 15.8.3 创建根与干
若编译和运行PerfectTime.java，即使rmiregistry正确运行，它也无法工作。这是由于RMI的框架尚未就位。首先必须创建根和干，以便提供网络连接操作，并使我们将远程对象伪装成自己机器内的某个本地对象。

所有这些幕后的工作都是相当复杂的。我们从远程对象传入、传出的任何对象都必须“implement Serializable”（如果想传递 远程引用，而非整个对象，对象的参数就可以“implement Remote”）。因此可以想象，当根和干通过网络“汇集”所有参数并返回结果的时候，会自动进行序列化以及数据的重新装配。幸运的是，我们根本没必要了解这些方面的任何细节，但根和干却是必须创建的。一个简单的过程如下：在编译好的代码中调用rmic，它会创建必需的一些文件。所以唯一要做的事情就是为编译过程新添一个步骤。

然而，rmic工具与特定的包和类路径有很大的关联。PerfectTime.java位于包c15.Ptime中，即使我们调用与PerfectTime.class同一目录内的rmic，rmic都无法找到文件。这是由于它搜索的是类路径。因此，我们必须同时指定类路径，就象下面这样：
```
rmic c15.PTime.PerfectTime
```
执行这个命令时，并不一定非要在包含了PerfectTime.class的目录中，但结果会置于当前目录。 若rmic成功运行，目录里就会多出两个新类：
```
PerfectTime_Stub.class
PerfectTime_Skel.class
```
它们分别对应根（Stub）和干（Skeleton）。现在，我们已准备好让服务器与客户互相沟通了。

#### 15.8.4 使用远程对象
RMI全部的宗旨就是尽可能简化远程对象的使用。我们在客户程序中要做的唯一一件额外的事情就是查找并从服务器取回远程接口。自此以后，剩下的事情就是普通的Java编程：将消息发给对象。下面是使用PerfectTime的程序：

```java
//: DisplayPerfectTime.java
// Uses remote object PerfectTime
package c15.ptime;
import java.rmi.*;
import java.rmi.registry.*;

public class DisplayPerfectTime {
  public static void main(String[] args) {
    System.setSecurityManager(
      new RMISecurityManager());
    try {
      PerfectTimeI t = 
        (PerfectTimeI)Naming.lookup(
          "//colossus:2005/PerfectTime");
      for(int i = 0; i < 10; i++)
        System.out.println("Perfect time = " +
          t.getPerfectTime());
    } catch(Exception e) {
      e.printStackTrace();
    }
  }
} ///:~
```
ID字串与那个用Naming注册对象的那个字串是相同的，第一部分指出了URL和端口号。由于我们准备使用一个URL，所以也可以指定因特网上的一台机器。

从Naming.lookup()返回的必须造型到远程接口，而不是到类。若换用类，会得到一个违例提示。 在下述方法调用中：
```
t.getPerfectTime( )
```
我们可看到一旦获得远程对象的句柄，用它进行的编程与用本地对象的编程是非常相似（仅有一个区别：远程方法会“掷”出一个RemoteException违例）。

#### 15.8.5 RMI的替选方案
RMI只是一种创建特殊对象的方式，它创建的对象可通过网络发布。它最大的优点就是提供了一种“纯Java”方案，但假如已经有许多用其他语言编写的代码，则RMI可能无法满足我们的要求。目前，两种最具竞争力的替选方案是微软的DCOM（根据微软的计划，它最终会移植到除Windows以外的其他平台）以及CORBA。CORBA自Java 1.1便开始支持，是一种全新设计的概念，面向跨平台应用。在由Orfali和Harkey编著的《Client/Server Programming with Java and CORBA》一书中（John Wiley&Sons 1997年出版），大家可获得对Java中的分布式对象的全面介绍（该书似乎对CORBA似乎有些偏见）。为CORBA赋予一个较公正的对待的一本书是由Andreas Vogel和Keith Duddy编写的《Java Programming with CORBA》，John Wiley&Sons于1997年出版。

### 15.9 总结
由于篇幅所限，还有其他许多涉及连网的概念没有介绍给大家。Java也为URL提供了相当全面的支持，包括为因特网上不同类型的客户提供协议控制器等等。

除此以外，一种正在逐步流行的技术叫作Servlet Server。它是一种因特网服务器应用，通过Java控制客户请求，而非使用以前那种速度很慢、且相当麻烦的CGI（通用网关接口）协议。这意味着为了在服务器那一端提供服务，我们可以用Java编程，不必使用自己不熟悉的其他语言。由于Java具有优秀的移植能力，所以不必关心具体容纳这个服务器是什么平台。

所有这些以及其他特性都在《Java Network Programming》一书中得到了详细讲述。该书由Elliotte Rusty Harold编著，O'Reilly于1997年出版。


### 15.10 练习
(1) 编译和运行本章中的JabberServer和JabberClient程序。接着编辑一下程序，删去为输入和输出设计的所有缓冲机制，然后再次编译和运行，观察一下结果。

(2) 创建一个服务器，用它请求用户输入密码，然后打开一个文件，并将文件通过网络连接传送出去。创建一个同该服务器连接的客户，为其分配适当的密码，然后捕获和保存文件。在自己的机器上用localhost（通过调用InetAddress.getByName(null)生成本地IP地址127.0.0.1）测试这两个程序。

(3) 修改练习2中的程序，令其用多线程机制对多个客户进行控制。

(4) 修改JabberClient，禁止输出刷新，并观察结果。

(5) 以ShowHTML.java为基础，创建一个程序片，令其成为对自己Web站点的特定部分进行密码保护的大门。

(6) （可能有些难度）创建一对客户／服务器程序，利用数据报（Datagram）将一个文件从一台机器传到另一台（参见本章数据报小节末尾的叙述）。

(7) （可能有些难度）对VLookup.java程序作一番修改，使我们能点击得到的结果名字，然后程序会自动取得那个名字，并把它复制到剪贴板（以便我们方便地粘贴到自己的E-mail）。可能要回过头去研究一下IO数据流的那一章，回忆该如何使用Java 1.1剪贴板。