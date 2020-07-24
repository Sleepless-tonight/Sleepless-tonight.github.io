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





### 15.5 一个Web应用
### 15.6 Java与CGI的沟通
### 15.7 用JDBC连接数据库
### 15.8 远程方法
### 15.9 总结
### 15.10 练习
