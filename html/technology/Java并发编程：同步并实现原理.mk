# Java并发编程：Synchronized 同步并实现原理

##### 一、Synchronized 的基本使用

1. 修饰普通方法

    ######  对方法的同步本质上是对对象的同步（方法本质上是属于对象的方法），所以同一同的对象，只能顺序的执行，不能并发执行。

2. 修饰静态方法

    ######  对静态方法的同步本质上是对类的同步（静态方法本质上是属于类的方法，而不是对象上的方法），所以即使方法属于不同的对象，但是它们都属于类的实例，所以也只能顺序的执行，不能并发执行。
3. 修饰代码块
    
   ######  对于代码块的同步实质上需要获取Synchronized关键字后面括号中对象的monitor


```

jvm用monitorenter和monitorexit指令对同步提供显式支持。而java常用sychronized方法。
sychronized“方法”通常不是用monitorenter和monitorexit指令实现的。往往是由“方法调用指令”检查常数池里的ACC_SYCHRONIZED标志
但monitorenter和monitorexit指令是为了支持sychronized“语句”而存在的。
注意这里的方法和语句的区别。

语句实例如下：test.java
public class test {
  public test() {
  }
  public static void main(String[] args) {
    synchronized(new Object()){
        int i = 0;
    }
  }

}
编译完的结果：
C:\JBuilderX\bin>javap -c  -classpath "d:/epm40/classes" test
Compiled from "test.java"
public class test extends java.lang.Object{
public test();
  Code:
   0:   aload_0
   1:   invokespecial   #1; //Method java/lang/Object."":()V
   4:   nop
   5:   return

public static void main(java.lang.String[]);
  Code:
   0:   new     #2; //class Object
   3:   dup
   4:   invokespecial   #1; //Method java/lang/Object."":()V
   7:   dup
   8:   astore_1
   9:   monitorenter
   10:  iconst_0
   11:  istore_2
   12:  nop
   13:  aload_1
   14:  monitorexit
   15:  goto    23
   18:  astore_3
   19:  aload_1
   20:  monitorexit
   21:  aload_3
   22:  athrow
   23:  nop
   24:  return
  Exception table:
   from   to  target type
    10    15    18   any
    18    21    18   any

}

而synchronized方法编译没有特殊之处，只是在方法名上加了synchronzied字样。

1、同步代码块：
    monitorenter ：
    
        每个对象有一个监视器锁（monitor）。当monitor被占用时就会处于锁定状态，线程执行monitorenter指令时尝试获取monitor的所有权，过程如下：
        
        1、如果monitor的进入数为0，则该线程进入monitor，然后将进入数设置为1，该线程即为monitor的所有者。
        
        2、如果线程已经占有该monitor，只是重新进入，则进入monitor的进入数加1.
        
        3.如果其他线程已经占用了monitor，则该线程进入阻塞状态，直到monitor的进入数为0，再重新尝试获取monitor的所有权。
    
    monitorexit：
    
    　　执行monitorexit的线程必须是objectref所对应的monitor的所有者。
    
    　　指令执行时，monitor的进入数减1，如果减1后进入数为0，那线程退出monitor，不再是这个monitor的所有者。其他被这个monitor阻塞的线程可以尝试去获取这个 monitor 的所有权。
    
    　　Synchronized的语义底层是通过一个monitor的对象来完成，其实wait/notify等方法也依赖于monitor对象，这就是为什么只有在同步的块或者方法中才能调用wait/notify等方法，否则会抛出java.lang.IllegalMonitorStateException的异常的原因。

2、同步方法
    方法的同步并没有通过指令monitorenter和monitorexit来完成（理论上其实也可以通过这两条指令来实现），不过相对于普通方法，其常量池中多了ACC_SYNCHRONIZED标示符。JVM就是根据该标示符来实现方法的同步的：当方法调用时，调用指令将会检查方法的 ACC_SYNCHRONIZED 访问标志是否被设置，如果设置了，执行线程将先获取monitor，获取成功之后才能执行方法体，方法执行完后再释放monitor。在方法执行期间，其他任何线程都无法再获得同一个monitor对象。 其实本质上没有区别，只是方法的同步是一种隐式的方式来实现，无需通过字节码来完成。
```