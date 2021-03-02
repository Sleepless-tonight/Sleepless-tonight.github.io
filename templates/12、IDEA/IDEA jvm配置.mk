
1. 默认配置
```
-Xms128m
-Xmx750m
-XX:ReservedCodeCacheSize=240m
-XX:+UseConcMarkSweepGC
-XX:SoftRefLRUPolicyMSPerMB=50
-ea
-Dsun.io.useCanonCaches=false
-Djava.net.preferIPv4Stack=true
-Djdk.http.auth.tunneling.disabledSchemes=""
-XX:+HeapDumpOnOutOfMemoryError
-XX:-OmitStackTraceInFastThrow

```
2. 一种复杂的未验证配置

```
-server
-Xms2g
-Xmx2g
-XX:NewRatio=3
-Xss16m
-XX:+UseConcMarkSweepGC
-XX:+CMSParallelRemarkEnabled
-XX:ConcGCThreads=4
-XX:ReservedCodeCacheSize=240m
-XX:+AlwaysPreTouch
-XX:+TieredCompilation
-XX:+UseCompressedOops
-XX:SoftRefLRUPolicyMSPerMB=50
-Dsun.io.useCanonCaches=false
-Djava.net.preferIPv4Stack=true
-Djsse.enableSNIExtension=false
-ea
```
## 关于字段的意义

```
#-Xmx   Java Heap最大值，默认值为物理内存的1/4，最佳设值应该视物理内存大小及计算机内其他内存开销而定；

#-Xms   Java Heap初始值，Server端JVM最好将-Xms和-Xmx设为相同值，开发测试机JVM可以保留默认值；

#-Xmn   Java Heap Young区大小，不熟悉最好保留默认值；

#-Xss   每个线程的Stack大小，不熟悉最好保留默认值；

#-XX:NewRatio		新生代内存容量与老生代内存容量的比例

#-XX:ReservedCodeCacheSize	保留代码占用的内存容量

#-XX:+UseConcMarkSweepGC	对老生代采用并发标记交换算法进行GC
```
