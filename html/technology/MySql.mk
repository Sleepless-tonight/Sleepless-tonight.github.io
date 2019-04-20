## **MySql 数据类型**

一、MySQL的数据类型
主要包括以下五大类：

整数类型：BIT、BOOL、TINY INT、SMALL INT、MEDIUM INT、 INT、 BIG INT

浮点数类型：FLOAT、DOUBLE、DECIMAL

字符串类型：CHAR、VARCHAR、TINY TEXT、TEXT、MEDIUM TEXT、LONGTEXT、TINY BLOB、BLOB、MEDIUM BLOB、LONG BLOB

日期类型：Date、DateTime、TimeStamp、Time、Year

其他数据类型：BINARY、VARBINARY、ENUM、SET、Geometry、Point、MultiPoint、LineString、MultiLineString、Polygon、GeometryCollection 等。

![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/20180606105956467.png)

1、整数

类型 | 说明 | 存储需求（取值范围）
---|---|---
tinyin | 很小整数 | 1字节（[0~255]、[-128~127]）；255 = 2^8-1；127=2^7-1
smallint | 小整数 | 2字节（[0~65535]、[-32768~32767]）；65535 = 2^16-1
mediumint | 中等 | 3字节（[0~16777215]）；16777215 = 2^24-1
int(intege) | 普通 | 4字节（[0~4294967295]）；4294967295 = 2^32-1
bigint | 大整数 | 8字节（[0~18446744073709551615]）；18446744073709551615 = 2^64-1

**注：** 取值范围如果加了unsigned，则最大值翻倍，如tinyint unsigned的取值范围为(0~256)。

2、浮点数&定点数

类型 | 说明 | 存储需求（取值范围）
---|---|---
float(m,d) | 单精度浮点数 | 4字节(8位精度) m总个数，d小数位
double(m,d) | 双精度浮点数 | 8字节(16位精度) m总个数，d小数位
decimal(m,d) | 压缩的“严格”定点数 | m<65 ，d<30

**注：** 定点数以字符串形式存储，对精度要求高时使用decimal较好；尽量避免对浮点数进行减法和比较运算。


3、时间/日期类型

数据类型 | 格式 
---|---
date | YYYY-MM-DD 
time | HH:MM:SS 
year | YYYY
datetime | YYYY-MM-DD HH:MM:SS
timestamp | YYYYMMDD HHMMSS 

**注：** 若定义一个字段为timestamp，这个字段里的时间数据会随其他字段修改的时候自动刷新，所以这个数据类型的字段可以存放这条记录最后被修改的时间。


