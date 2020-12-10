##### 高低版本MySQL数据库的 springboot 配置
###### 1、概述
MySQL为使用MySQL Connector / J的Java编程语言开发的客户端应用程序提供连接。Connector /J实现了Java数据库连接（JDBC）API，以及它的许多增值扩展。它还支持新的X DevAPI。

MySQL Connector / J是JDBC Type 4驱动程序。可以使用与JDBC 3.0和 JDBC 4.2规范兼容的不同版本 （请参阅 第2章，Connector / J版本以及它们支持的MySQL和Java版本）。Type 4标识表示驱动程序是MySQL协议的纯Java实现，不依赖于MySQL客户端库。

对于使用通用设计模式的数据访问的大型程序，请考虑使用一种流行的持久性框架，如 Hibernate，Spring的JDBC模板或MyBatis SQL Maps，以减少用于调试，调整，保护和调试的JDBC代码量。保持。

###### 2、版本差异
目前有两个MySQL Connector / J版本可用：

Connector / J 8.0（以前的Connector / J 6.0; 有关版本号更改的说明，请参阅 MySQL Connector / J 8.0.7中的更改）是Java 8平台的Type 4纯Java JDBC 4.2驱动程序。它提供了与MySQL 5.5,5.6,5.7和8.0的所有功能的兼容性。Connector / J 8.0提供了易于开发的功能，包括使用Driver Manager自动注册，标准化有效性检查，分类SQLExceptions，支持大量更新计数，支持包中的本地和偏移日期时间变体java.time ，支持JDBC-4 .x XML处理，支持每个连接客户端信息，并支持 NCHAR， NVARCHAR和 NCLOB数据类型。

Connector / J 5.1也是Type 4纯Java JDBC驱动程序，符合JDBC 3.0,4.0,4.1和4.2规范。它提供了与MySQL 5.5,5.6,5.7和8.0的所有功能的兼容性。

Connector / J版本的摘要：

Connector / J版本 | JDBC版本 | MySQL服务器版 | JRE支持 | 编译需要JDK | 状态
---|---|---|---|---|---
8 | 4.2 | 5.5,5.6,5.7,8.0 | 1.8.x的 | 1.8.x的 | 一般可用性。推荐版本。
5.1 | 3.0,4.0,4.1,4.2 | 5.5,5.6 *，5.7 *，8.0 * | 1.5.x，1.6.x，1.7.x，1.8.x * | 1.5.x和1.8.x. | 一般可用性

*使用某些密码套件时，Connector / J 5.1需要JRE 1.8.x才能使用SSL / TLS连接到MySQL 5.6,5.7和8.0。

###### 3、Connector / J 8.0新功能
它支持MySQL 5.5,5.6,5.7和8.0。

它支持JDBC 4.2规范。

它是Java 8平台的MySQL驱动程序。对于Java 7或更早版本，请改用Connector / J 5.1。

它支持新的X DevAPI，通过它可以为Java应用程序提供MySQL 5.7和8.0对JSON，NoSQL，文档集合和其他功能的本机支持。有关详细信息，请参阅将MySQL用作文档存储和 X DevAPI用户指南。

###### 4、从旧版本升级
以下是Connector / J从5.1到8.0的一些更改，可能需要进行调整：

>  1、Java 8平台上运行：
Connector / J 8.0专门为在Java8平台上运行而创建。虽然已知Java8与早期Java版本强烈兼容，但确实存在不兼容性，并且在Java 8上运行之前可能需要调整设计用于Java7的代码。开发人员应参考Oracle提供的 不兼容性信息。

> 2、连接属性的变化：以下是已从Connector / J 5.1更改（删除，添加，更改其名称或更改其默认值）的连接属性从Connector / J 5.1到8.0。
> - 已删除的属性（在连接期间不使用它们）：
> > - useDynamicCharsetInfo
> > - useBlobToStoreUTF8OutsideBMP， utf8OutsideBmpExcludedColumnNamePattern和 utf8OutsideBmpIncludedColumnNamePattern：MySQL 5.5及更高版本支持utf8mb4字符集，这是连接器/ J应用程序应使用的字符集，用于支持Unicode版本3的基本多语言平面（BMP）之外的字符。
> - 以下日期和时间属性：
> > - dynamicCalendars
> > - noTzConversionForTimeType
> > - noTzConversionForDateType
> > - cacheDefaultTimezone
> > - useFastIntParsing
> > - useFastDateParsing
> > - useJDBCCompliantTimezoneShift
> > - useLegacyDatetimeCode
> > - useSSPSCompatibleTimezoneShift
> > - useTimezone
> > - useGmtMillisForDatetimes
> > - dumpMetadataOnColumnNotFound
> > - relaxAutoCommit
> > - strictFloatingPoint
> > - runningCTS13
> > - retainStatementAfterResultSetClose
> > - nullNamePatternMatchesAll （自8.0.9发布以来删除）
> - 已添加的属性：
> > - mysqlx.useAsyncProtocol
> - 名称已更改的属性：
> > - com.mysql.jdbc.faultInjection.serverCharsetIndex 变成 com.mysql.cj.testsuite.faultInjection.serverCharsetIndex
> > - loadBalanceEnableJMX 至 ha.enableJMX
> > - replicationEnableJMX 至 ha.enableJMX
> - 更改了默认值的属性：
> > - nullCatalogMeansCurrent现在 false默认情况下

###### 5、Connector / J API的变化：
从版本5.1到8.0的Connector / J API的更改。您可能需要相应地调整API调用：

> - java.sql.Driver在MySQL Connector / J 中实现的类的名称 已从更改 **com.mysql.jdbc.Driver**为 **com.mysql.cj.jdbc.Driver**。旧类名已被弃用。
> - 这些常用接口的名称也已更改：
> > - **ExceptionInterceptor**：from com.mysql.jdbc.ExceptionInterceptor to com.mysql.cj.exceptions.ExceptionInterceptor
> > - **StatementInterceptor**：from com.mysql.jdbc.StatementInterceptorV2 to com.mysql.cj.interceptors.QueryInterceptor
> > - **ConnectionLifecycleInterceptor**：从。 com.mysql.jdbc.ConnectionLifecycleInterceptor 到 com.mysql.cj.jdbc.interceptors.ConnectionLifecycleInterceptor
> > - **AuthenticationPlugin**：from com.mysql.jdbc.AuthenticationPlugin to com.mysql.cj.protocol.AuthenticationPlugin
> > - **BalanceStrategy**：从 com.mysql.jdbc.BalanceStrategy 到 com.mysql.cj.jdbc.ha.BalanceStrategy。

###### 6、Ant构建属性的更改
从源代码构建Connector / J的 许多Ant属性 已重命名：

旧名 | 	新名字
---|---|
com.mysql.jdbc.extra.libs | 	com.mysql.cj.extra.libs
com.mysql.jdbc.jdk | 	com.mysql.cj.build.jdk
debug.enable | 	com.mysql.cj.build.addDebugInfo
com.mysql.jdbc.noCleanBetweenCompiles | 	com.mysql.cj.build.noCleanBetweenCompiles
com.mysql.jdbc.commercialBuild	 | com.mysql.cj.build.commercial
com.mysql.jdbc.filterLicense | 	com.mysql.cj.build.filterLicense
com.mysql.jdbc.noCryptoBuild | 	com.mysql.cj.build.noCrypto
com.mysql.jdbc.noSources | 	com.mysql.cj.build.noSources
com.mysql.jdbc.noMavenSources | 	com.mysql.cj.build.noMavenSources
major_version | 	com.mysql.cj.build.driver.version.major
minor_version | 	com.mysql.cj.build.driver.version.minor
subminor_version | 	com.mysql.cj.build.driver.version.subminor
version_status | 	com.mysql.cj.build.driver.version.status
extra.version | 	com.mysql.cj.build.driver.version.extra
snapshot.version | 	com.mysql.cj.build.driver.version.snapshot
version | 	com.mysql.cj.build.driver.version
full.version | 	com.mysql.cj.build.driver.version.full
prodDisplayName	 | com.mysql.cj.build.driver.displayName
prodName    |    com.mysql.cj.build.driver.name
fullProdName | 	com.mysql.cj.build.driver.fullName
buildDir | 	com.mysql.cj.build.dir
buildDriverDir	 | com.mysql.cj.build.dir.driver
mavenUploadDir | 	com.mysql.cj.build.dir.maven
distDir | 	com.mysql.cj.dist.dir
toPackage | 	com.mysql.cj.dist.dir.prepare
packageDest	 | com.mysql.cj.dist.dir.package
com.mysql.jdbc.docs.sourceDir | 	com.mysql.cj.dist.dir.prebuilt.docs

已重命名或删除了 许多用于测试Connector / J的Ant属性：

旧名  | 	新名字
---|---|
buildTestDir | 	com.mysql.cj.testsuite.build.dir
junit.results | 	com.mysql.cj.testsuite.junit.results
com.mysql.jdbc.testsuite.jvm | 	com.mysql.cj.testsuite.jvm
test | 	com.mysql.cj.testsuite.test.class
methods	 | com.mysql.cj.testsuite.test.methods
com.mysql.jdbc.testsuite.url | 	com.mysql.cj.testsuite.url
com.mysql.jdbc.testsuite.admin-url | 	com.mysql.cj.testsuite.url.admin
com.mysql.jdbc.testsuite.ClusterUrl	 | com.mysql.cj.testsuite.url.cluster
com.mysql.jdbc.testsuite.url.sha256default | 	com.mysql.cj.testsuite.url.openssl
com.mysql.jdbc.testsuite.cantGrant | 	com.mysql.cj.testsuite.cantGrant
com.mysql.jdbc.testsuite.no-multi-hosts-tests | 	com.mysql.cj.testsuite.disable.multihost.tests
com.mysql.jdbc.test.ds.host | 	com.mysql.cj.testsuite.ds.host
com.mysql.jdbc.test.ds.port	 | com.mysql.cj.testsuite.ds.port
com.mysql.jdbc.test.ds.db | 	com.mysql.cj.testsuite.ds.db
com.mysql.jdbc.test.ds.user	 | com.mysql.cj.testsuite.ds.user
com.mysql.jdbc.test.ds.password | 	com.mysql.cj.testsuite.ds.password
com.mysql.jdbc.test.tabletype | 	com.mysql.cj.testsuite.loadstoreperf.tabletype
com.mysql.jdbc.testsuite.loadstoreperf.useBigResults | 	com.mysql.cj.testsuite.loadstoreperf.useBigResults
com.mysql.jdbc.testsuite.MiniAdminTest.runShutdown | 	com.mysql.cj.testsuite.miniAdminTest.runShutdown
com.mysql.jdbc.testsuite.noDebugOutput | 	com.mysql.cj.testsuite.noDebugOutput
com.mysql.jdbc.testsuite.retainArtifacts | 	com.mysql.cj.testsuite.retainArtifacts
com.mysql.jdbc.testsuite.runLongTests | 	com.mysql.cj.testsuite.runLongTests
com.mysql.jdbc.test.ServerController.basedir | 	com.mysql.cj.testsuite.serverController.basedir
com.mysql.jdbc.ReplicationConnection.isSlave | 	com.mysql.cj.testsuite.replicationConnection.isSlave
com.mysql.jdbc.test.isLocalHostnameReplacement | 	删除
com.mysql.jdbc.testsuite.driver	 | 删除
com.mysql.jdbc.testsuite.url.default | 	删除。不再需要，因为已从测试套件中删除了多JVM测试。

###### 7、Exceptions 的变化
从版本5.1到8.0的Connector / J已删除了一些例外。用于捕获已删除异常的应用程序现在的相应异常捕获在下面表中列出：

在Connector / J 5.1中删除了异常 | 	Connector / J 8.0中的Catch异常
---|---|
com.mysql.jdbc.exceptions.jdbc4.CommunicationsException	 | com.mysql.cj.jdbc.exceptions.CommunicationsException
com.mysql.jdbc.exceptions.[jdbc4.]MySQLDataException | 	java.sql.SQLDataException
com.mysql.jdbc.exceptions.[jdbc4.]MySQLIntegrityConstraintViolationException | 	java.sql.SQLIntegrityConstraintViolationException
com.mysql.jdbc.exceptions.[jdbc4.]MySQLInvalidAuthorizationSpecException | 	java.sql.SQLInvalidAuthorizationSpecException
com.mysql.jdbc.exceptions.[jdbc4.]MySQLNonTransientConnectionExceptioñ | 	java.sql.SQLNonTransientConnectionException
com.mysql.jdbc.exceptions.[jdbc4.]MySQLNonTransientException | 	java.sql.SQLNonTransientException
com.mysql.jdbc.exceptions.[jdbc4.]MySQLQueryInterruptedException | 	com.mysql.cj.jdbc.exceptions.MySQLQueryInterruptedException
com.mysql.jdbc.exceptions.MySQLStatementCancelledException | 	com.mysql.cj.jdbc.exceptions.MySQLStatementCancelledException
com.mysql.jdbc.exceptions.[jdbc4.]MySQLSyntaxErrorException	 | java.sql.SQLSyntaxErrorException
com.mysql.jdbc.exceptions.[jdbc4.]MySQLTimeoutException	 | java.sql.SQLTimeoutException
com.mysql.jdbc.exceptions.[jdbc4.]MySQLTransactionRollbackException	 | java.sql.SQLTransactionRollbackException
com.mysql.jdbc.exceptions.[jdbc4.]MySQLTransientConnectionException | 	Ĵava.sql.SQLTransientConnectionException
com.mysql.jdbc.exceptions.[jdbc4.]MySQLTransientException | 	java.sql.SQLTransientException
com.mysql.jdbc.exceptions.[jdbc4.]MySQLIntegrityConstraintViolationException | 	java.sql.SQLIntegrityConstraintViolationException

###### 8、其他变更
以下是Connector / J 8.0的其他更改：

> - 删除了ReplicationDriver。现在，您只需使用该jdbc:mysql:replication://方案即可获得复制设置的连接，而不是使用单独的驱动程序 。
> - Connector / J 8.0始终对日期时间值执行时间偏移调整，并且调整需要满足以下条件之一：
> > - MySQL服务器配置了Java可识别的规范时区（例如，Europe / Paris，Etc / GMT-5，UTC等）
> > - 通过设置Connector / J连接属性serverTimezone（例如， serverTimezone=Europe/Paris）来覆盖服务器的时区 。

###### 9、Testing Connector/J 测试连接器
随源代码一起提供的Connector / J源代码库或包包含一个扩展的测试套件，其中包含可以独立执行的测试用例。测试用例分为以下几类：
> - Unit tests: They are methods located in packages aligning with the classes that they test.
    >  单元测试：它们是位于包中的方法，与它们测试的类对齐。
> - Functional tests: Classes from the package testsuite.simple. Include test code for the main features of Connector/J.
    > 功能测试：包中的类testsuite.simple。包含Connector / J主要功能的测试代码。
> - Performance tests: Classes from the package testsuite.perf. Include test code to make measurements for the performance of Connector/J.
    > 性能测试：包中的类testsuite.perf。包括测试代码以测量Connector / J的性能。
> - Regression tests: Classes from the package testsuite.regression. Includes code for testing bug and regression fixes.
    > 回归测试：包中的类testsuite.regression。包括用于测试错误和回归修复的代码。
> - X DevAPI and X Protocol tests: Classes from the package testsuite.x for testing X DevAPI and X Protocol functionality.
    X DevAPI和X协议测试：来自包的类， testsuite.x用于测试X DevAPI和X协议功能。
> - 要使用Ant运行测试：请阅读 MySQL 8.0 Reference Manual

###### 10、Connector / J示例
一些使用Connector / J的示例的摘要
- 例7.1，“Connector / J：从DriverManager” 获取连接 “
- 例7.2，“Connector / J：使用java.sql.Statement执行 SELECT查询”
- 例7.3，“Connector / J：调用存储过程”
- 例7.4，“Connector / J：Using Connection.prepareCall()”
- 例7.5，“Connector / J：注册输出参数”
- 例7.6，“Connector / J：设置CallableStatement输入参数”
- 例7.7，“Connector / J：检索结果和输出参数值”
- 例7.8，“Connector / J：AUTO_INCREMENT使用Statement.getGeneratedKeys()” 检索列值“
- 例7.9，“Connector / J：AUTO_INCREMENT使用SELECT LAST_INSERT_ID()” 检索列值“
- 例7.10，“Connector / J：检索AUTO_INCREMENT列值Updatable ResultSets”
- 例8.1，“Connector / J：使用与J2EE应用程序服务器的连接池”
- 例14.1，“Connector / J：具有重试逻辑的事务示例”

###### 11、Connector / J参考
- 6.1驱动程序/数据源类名
> java.sql.Driver在MySQL Connector / J 中实现的类的名称 是 com.mysql.cj.jdbc.Driver。
- 6.2连接URL语法
> 连接URL的通用格式：
> > protocol//[hosts][/database][?properties]
>
> 针对URL任何保留的字符（例如, /, :, @, (, ), [, ], &, #, =, ?, and space)出现在连接URL的任何部分空间必须％的编码。
>
> **protocol** 连接有四种可能的协议：
> - jdbc:mysql: 用于普通和基本的故障转移连接。
> - jdbc:mysql:loadbalance:用于配置负载平衡。有关 详细信息，请参见 第9.3节“使用Connector / J配置负载平衡”。
> - jdbc:mysql:replication:用于配置复制设置。有关详细信息，请参见 第9.4节“使用Connector / J配置主/从复制” 。
> - mysqlx: 用于使用X协议的连接。
>
> **hosts**  hosts 部分可能只包含主机名，也可能是由多个主机名，端口号，主机特定属性和用户凭证等各种元素组成的复杂结构。。
> > - 单主机连接不添加特定于主机的属性：
      > >   - 该hosts部分的格式为 host：port。连接URL的示例：
              > >     - jdbc:mysql://host1:33060/sakila
> >   - host可以是IPv4或IPv6主机名字符串，在后一种情况下，它必须放在方括号内，例如 “ [1000：2000 :: abcd]。”当 host没有指定，默认值localhost 被使用。
> >   - port是一个标准端口号，即1到65535之间的整数。普通MySQL连接的默认端口号是3306，使用X协议的连接是33060。如果 port未指定，则使用相应的默认值。
>
> > - 单主机连接添加特定于主机的属性：
      > >   - 在这种情况下，主机被定义为一系列 。密钥用于标识主机，端口以及任何特定于主机的属性。指定键有两种备用格式： key=value
              > >     - 在“ address-equals ”格式：
                        > >       - address=(host=host_or_ip)(port=port)(key1=value1)(key2=value2)...(keyN=valueN)
> >     - 在“ address-equals ”示例：
          > >       - jdbc:mysql://address=(host=myhost)(port=1111)(key1=value1)/db
> >     -
> >     - 在“ key-value”格式：
          > >       - (host=host,port=port,key1=value1,key2=value2,...,keyN=valueN)
> >     - 在“  key-value”示例：
          > >       - jdbc:mysql://(host=myhost,port=1111,key1=value1)/db
> >   - 可以添加其他键包括 user， password， protocol，等等。它们会覆盖properties URL部分中设置的全局值 。将覆盖限制为用户，密码，网络超时以及语句和元数据高速缓存大小; 其他每个主机覆盖的影响未定义。
> >   - key区分大小写。仅在两种情况下不同的两个密钥被认为是冲突的，并且不能保证将使用哪一个密钥
>
> > - 多个主机：
      > >   - 多个主机有两种格式：
              > >     - 以逗号分隔的列表列出主机 格式：
                        > >       - host1,host2,...,hostN
> >     - 示例：
          > >       - jdbc:mysql://myhost1:1111,myhost2:2222/db
> >       - jdbc:mysql://address=(host=myhost1)(port=1111)(key1=value1),address=(host=myhost2)(port=2222)(key2=value2)/db
> >       - jdbc:mysql://(host=myhost1,port=1111,key1=value1),(host=myhost2,port=2222,key2=value2)/db
> >       - jdbc:mysql://myhost1:1111,(host=myhost2,port=2222,key2=value2)/db
> >       - mysqlx://(address=host1:1111,priority=1,key1=value1),(address=host2:2222,priority=2,key2=value2)/db
> >     -
> >     - 以逗号分隔的列表中列出主机，然后用方括号括起列表 格式：
          > >       - [host1,host2,...,hostN]
> >       - 这称为主机子列表表单，它允许列表中的所有主机共享 用户凭据，就好像它们是单个主机一样。列表中的每个主机都可以使用上面单个主机中描述的三种方式中的任何一种进行指定 。
> >     - 示例：
          > >       - jdbc:mysql://sandy:secret@[myhost1:1111,myhost2:2222]/db
> >       - jdbc:mysql://sandy:secret@[address=(host=myhost1)(port=1111)(key1=value1),address=(host=myhost2)(port=2222)(key2=value2)]/db
> >       - jdbc:mysql://sandy:secret@[myhost1:1111,address=(host=myhost2)(port=2222)(key2=value2)]/db
> >       - 虽然无法递归编写主机子列表，但主机列表可能包含主机子列表作为其成员主机。
>
> **用户凭据**  用户凭据可以在连接URL之外设置，使用连接URL设置时，有几种方法可以指定它们：
> > - 使用以下用户凭据对 单个主机，主机子列表或主机列表中的任何主机进行前缀 @：
      > >     -  user:password@host_or_host_sublist
> >  - 示例：
       > >     -  mysqlx://sandy:secret@[(address=host1:1111,priority=1,key1=value1),(address=host2:2222,priority=2,key2=value2))]/db
>
> > - 使用 keys： user 和 password 为每个主机指定凭据：
      > >     -  (user=sandy)(password=mypass)
> >  - 示例：
       > >     - jdbc:mysql://[(host=myhost1,port=1111,user=sandy,password=secret),(host=myhost2,port=2222,user=finn,password=secret)]/db
> >     - jdbc:mysql://address=(host=myhost1)(port=1111)(user=sandy)(password=secret),address=(host=myhost2)(port=2222)(user=finn)(password=secret)/db
>
> **database**  要打开的默认数据库或目录。如果未指定数据库，则建立连接时不使用默认数据库。在这种情况下，要么setCatalog() 在Connection实例上调用方法，要么在SQL语句中使用数据库名称（即，）指定表名。
>
>>  &emsp;
>
> **properties**  应用于所有主机的一系列全局属性 ，以符号“?”开头，以符号“&”分隔
> >  - 示例：
       > >     - jdbc:mysql://(host=myhost1,port=1111),(host=myhost2,port=2222)/db?key1=value1&key2=value2&key3=value3
> >  - 对于 key-value 对，以下情况如下：
       > >     - key而且 value只是字符串。在Connector / J内部执行适当的类型转换和验证。
> >     - key区分大小写。仅在情况不同的两个密钥被认为是冲突的，并且不确定将使用哪个密钥。
> >     - 使用键值对指定的任何特定于主机的值（如 具有主机特定属性的单个主机 和 上面的多个主机中所述）将覆盖此处设置的全局值。


###### 12、JDBC相关
- 7.1使用JDBC DriverManager 接口连接MySQL
- 7.2使用JDBC Statement对象执行SQL
- 7.3使用JDBC CallableStatements执行存储过程
- 7.4 通过JDBC检索AUTO_INCREMENT列值

###### 13、使用Connector / J连接池


###### 14、多主机连接
以下各节讨论涉及多主机连接的许多主题，即服务器负载平衡，故障转移和复制。

> - 开发人员应该了解通过Connector / J管理的多主机连接的以下内容：
    >   - 每个多主机连接都是底层物理连接的包装。
>   - 每个底层物理连接都有自己的会话。鉴于MySQL架构，无法跟踪，共享或复制会话。
>   - 物理连接之间的每个切换意味着会话之间的切换。
>   - 在事务边界内，物理连接之间没有切换。超出事务边界，无法保证不会发生切换。

- 9.1配置服务器故障转移
- 9.2使用X协议时配置客户端故障转移
- 9.3使用Connector / J配置负载平衡
- 9.4使用Connector / J配置主/从复制
- 9.5高级负载平衡和故障转移配置

###### 15、使用Connector / J拦截器类
拦截器是一种软件设计模式，它提供了一种扩展或修改程序某些方面的透明方式，类似于用户出口。不需要重新编译。使用Connector / J，通过更新连接字符串来启用和禁用拦截器，以引用您实例化的不同拦截器类集。

第6.3节“配置属性” 中介绍了控制拦截器的连接属性 ：
- **connectionLifecycleInterceptors**，您可以在其中指定实现com.mysql.cj.jdbc.interceptors.ConnectionLifecycleInterceptor 接口的类的完全限定名称 。在这些类型的拦截器类中，您可以记录诸如回滚之类的事件，测量事务开始和结束之间的时间，或计算诸如调用之类的事件 setAutoCommit()。
- **exceptionInterceptors**，您可以在其中指定实现com.mysql.cj.exceptions.ExceptionInterceptor 接口的类的完全限定名称 。在这些类型的拦截器类中，您可以向可能具有多个原因或指示服务器设置问题的异常添加额外的诊断信息。 exceptionInterceptors处理Exception从Connector / J代码抛出时调用类。
- **queryInterceptors**，您可以在其中指定实现com.mysql.cj.interceptors.QueryInterceptor 接口的类的完全限定名称 。在这些类型的拦截器类中，您可以更改或扩充某些类型的语句所执行的处理，例如自动检查memcached服务器中的查询数据，重写慢速查询，记录有关语句执行的信息或将请求路由到远程服务器。

###### 16、Spring中使用 Connector / J

- 13.1使用 JdbcTemplate
    - **NamedParameterJdbcTemplate**，使用Spring的JDBC类来完全抽象出传统JDBC类的使用，NamedParameterJdbcTemplate可以使用全部jdbcTemplate方法，并支持 **具名参数** 。
```
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:aop="http://www.springframework.org/schema/aop"
	xmlns:context="http://www.springframework.org/schema/context"
	xsi:schemaLocation="http://www.springframework.org/schema/aop http://www.springframework.org/schema/aop/spring-aop-4.1.xsd
		http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
		http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.1.xsd">

	<!-- 自动扫描的包 -->
	<context:component-scan base-package="com.happBKs.spring.jdbcSpring"></context:component-scan>



	<!-- 导入资源文件 -->
	<context:property-placeholder location="classpath:db.properties" />

	<!-- 配置c3p0数据源 -->
	<bean id="dataSource" class="com.mchange.v2.c3p0.ComboPooledDataSource">
		<property name="user" value="${jdbc.user}"></property>
		<property name="password" value="${jdbc.password}"></property>
		<property name="jdbcUrl" value="${jdbc.jdbcUrl}"></property>
		<property name="driverClass" value="${jdbc.driverClass}"></property>
		<property name="initialPoolSize" value="${jdbc.initPoolSize}"></property>
		<property name="maxPoolSize" value="${jdbc.maxPoolSize}"></property>
	</bean>
	
	<!-- 配置jdbc模板类 -->
	<bean id="jdbcTemplate" class="org.springframework.jdbc.core.JdbcTemplate">
		<property name="dataSource" ref="dataSource"></property>
	</bean>

	<!-- 配置 NamedParameterJdbcTemplate，该对象可以使用具名参数。
	但它没有无参构造器，所以必须为其制定构造参数，这里指定的是出c3p0数据源
	-->
	<bean id="namedParameterJdbcTemplate"
		class="org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate">
		<constructor-arg ref="dataSource"></constructor-arg>
	</bean>
	
</beans>

```
Spring 中使用 Connector / J：
```
// 1、Create a new application context. this processes the Spring config
ApplicationContext ctx =
    new ClassPathXmlApplicationContext("ex1appContext.xml");
// 2、Retrieve the data source from the application context
    DataSource ds = (DataSource) ctx.getBean("dataSource");
// 3、Open a database connection using Spring's DataSourceUtils
Connection c = DataSourceUtils.getConnection(ds);
try {
    // 4、retrieve a list of three random cities
    PreparedStatement ps = c.prepareStatement(
        "select City.Name as 'City', Country.Name as 'Country' " +
        "from City inner join Country on City.CountryCode = Country.Code " +
        "order by rand() limit 3");
    ResultSet rs = ps.executeQuery();
    while(rs.next()) {
        String city = rs.getString("City");
        String country = rs.getString("Country");
        System.out.printf("The city %s is in %s%n", city, country);
    }
} catch (SQLException ex) {
    // something has failed and we print a stack trace to analyse the error 有些东西失败了，我们打印一个堆栈跟踪来分析错误
    ex.printStackTrace();
    // 5、ignore failure closing connection 忽略故障关闭连接
    try { c.close(); } catch (SQLException e) { }
} finally {
    // 6、properly release our connection 正确释放连接
    DataSourceUtils.releaseConnection(c, ds);
}
```



###### 兼容配置

```
spring:
  profiles: dev
  datasource:
    url: jdbc:mysql://192.168.100.220:3306/dts2?autoReconnect=true&useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=CONVERT_TO_NULL&useSSL=false&useAffectedRows=true
    username: username
    password: password
    driverClassName: com.mysql.cj.jdbc.Driver
    type: com.alibaba.druid.pool.DruidDataSource
    initialSize: 5
    sminIdle: 5
    maxActive: 20
    maxWait: 60000
    timeBetweenEvictionRunsMillis: 60000
    minEvictableIdleTimeMillis: 300000
    validationQuery: SELECT 1 FROM DUAL
    testWhileIdle: true
    testOnBorrow: false
    testOnReturn: false
    poolPreparedStatements: true
    maxPoolPreparedStatementPerConnectionSize: 20
    filters: stat,wall,log4j

```













