
#### 1、对象的内存布局
转载于知乎 刘缙 的回答
##### 1、对象的内存布局：
###### C/C++的内存布局：

```
struct Point {
    float x;
    float y;
    float z;
};
```

bytes | field
---|---
4 | x
4 | y
4 | z
###### Java 的内存布局：

bytes | field
---|---
12 | object header
4 | x
4 | y
4 | z

##### 2、嵌套对象的内存布局：
###### C/C++的内存布局：

```
struct Line {
    struct Point begin;
    struct Point end;
};
```

bytes | field
---|---
4 | begin.x
4 | begin.y
4 | begin.z
4 | end.x
4 | end.y
4 | end.z
###### Java 的内存布局：
![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/d71be36c2b1cfe7370fb231619295cd5_hd.png)


##### 3、数组对象的内存布局：
###### C/C++的内存布局：

```
struct Point v[100];
```

bytes | field
---|---
4 | v[0].x
4 | v[0].y
4 | v[0].z
4 | v[1].x
4 | v[1].y
4 | v[1].z
... | ...
###### Java 的内存布局：
![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/1ebd05c48c441883202c772746ede3a8_hd.png)



#### 2、Java 属性的内存空间分配：
```        
int e;
int f = 3;
String a;
String b = new String();
String c = "xxx";

```
![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/2018-11-26_153933.png)
> 可以看到只有b、c、f 属性分配了内存空间。以此可以确认声明变量时（无论引用类型还是基本类型），都不在内存分配空间，只有声明的变量触发了初始化后（initialized），才会被分配内存空间，例如变量作为类静态（static）属性，类加载后就会初始化，或者作为方法的形参也会被初始化。

> 注意"引用"也是占用空间的，基本类型的引用就是“数据”本身，引用类型的引用是“数据”所在内存空间的首地址

> 这里要特殊考虑String，以及Integer、Double等几个基本类型包装类，它们都是immutable类型，因为没有提供自身修改的函数，每次操作都是新生成一个对象，并把该空间的首地址赋给引用。
